# -*- coding: utf-8 -*-
from member import Member
from constants import *
from auth import API_KEY, WCL_KEY, PATH_TO_CSV
from concurrent import futures
from tornado import ioloop, httpclient
from dateutil import tz
import requests, datetime, sys, copy, time
from execute_query import execute_query
from writer import write_csv, log, error
from json import loads, dumps
try: from google.cloud import storage
except: print 'Google Cloud library not found. Assuming test environment.'

class Guild(object):

    def __init__(self, data, mode, client):
        self.guild_id, self.name, self.region, self.realm, self.key_code, self.last_checked, self.patreon = data[:7]
        self.version_message = "{0}|Your spreadsheet is out of date. Make a copy of the new version on wow.vanlankveld.me.".format(CURRENT_VERSION)
        self.last_reset = self.reset_timestamp()
        self.tracking_all = True
        self.members = {}
        self.add_member(data)
        self.name = self.name
        self.realm = self.realm
        self.mode = mode
        self.client = client

    def add_member(self, data):
        name = data[8]
        if name not in self.members: self.members[name] = Member(data,self.guild_id,self.last_reset)
        if self.members[name].status == 'not tracking': self.tracking_all = False

    def reset_timestamp(self):
        times = {'EU':{'hour':5,'day':2},'US':{'hour':11,'day':1}}
        last_reset_datetime = datetime.datetime.utcnow()

        if last_reset_datetime.weekday() == times[self.region]['day']:
            if last_reset_datetime.hour < times[self.region]['hour']:
                last_reset_datetime -= datetime.timedelta(days=1)
                while last_reset_datetime.weekday() != times[self.region]['day']: last_reset_datetime -= datetime.timedelta(days=1)
        else:
            while last_reset_datetime.weekday() != times[self.region]['day']: last_reset_datetime -= datetime.timedelta(days=1)

        last_reset_datetime = last_reset_datetime.replace(hour=times[self.region]['hour'],minute=0,second=0)
        return time.mktime(last_reset_datetime.timetuple())

    def check(self):
        self.csv_data = []
        self.snapshot_data = []
        self.spec_data = []
        self.wrong_users = []
        self.count = 0
        keep_going = self.with_concurrent() if self.client == 'concurrent' else self.with_tornado()
        if not keep_going: return False
        self.generate_warnings()
        self.update_users_in_db()

        log('info','Total Members: {0} | Members Refreshed: {1} | Result: {2}{3} success'.format( \
            len(self.members),len(self.csv_data), round(float(len(self.csv_data)) / float(len(self.members)) * 100,0), "%"),self.guild_id)
        if len(self.csv_data) > 0: self.write()

    def with_tornado(self,zone=0):
        self.tornado_count = 0
        self.tornado_results = []
        self.tornado_params = []
        http_client = httpclient.AsyncHTTPClient()
        for user in self.members:
            self.tornado_count += 1
            url, realm = self.get_url(user,zone)
            http_client.fetch(url, callback = lambda response, user=self.members[user], realm=realm: self.handle_request_tornado(response, user, realm), connect_timeout=400, request_timeout=400)

        ioloop.IOLoop.instance().start()
        for result in self.tornado_results:
            keep_going = self.process_result(result)
            if not keep_going and self.mode != 'warcraftlogs': return False
        return True

    def handle_request_tornado(self, response, member, realm):
        ''' Collects the response of each individual request. '''
        self.tornado_results.append((response.body,response.code,member,realm))
        self.tornado_count -= 1
        if self.tornado_count == 0:
            ioloop.IOLoop.instance().stop()

    def with_concurrent(self,zone=0):
        with futures.ThreadPoolExecutor(max_workers=10) as executor:
            tasks = dict((executor.submit(self.handle_request_concurrent, user, zone), user) for user in self.members)
            for user in futures.as_completed(tasks):
                keep_going = self.process_result(user.result())
                if not keep_going and self.mode != 'warcraftlogs': return False
        return True

    def handle_request_concurrent(self,user,zone):
        url, realm = self.get_url(user,zone)
        response = requests.get(url)
        return (response.text,response.status_code,self.members[user],realm)

    def get_url(self,user,zone):
        if self.members[user].realm: realm = self.members[user].realm
        else: realm = self.realm

        if self.mode == 'warcraftlogs':
            metric = 'hps' if self.members[user].role == 'Heal' else 'dps'
            self.members[user].url = WCL_URL.format(self.members[user].name.encode('utf-8'),realm.replace("'","").replace("-","").replace(" ","-").replace("(","").replace(")","").encode('utf-8').replace("й","и"),self.region,zone,metric,WCL_KEY).replace(" ","%20")
        else:
            self.members[user].url = URL.format(self.region,realm.encode('utf-8'),self.members[user].name.encode('utf-8'),API_KEY[self.mode]).replace(" ","%20")
        return (self.members[user].url, realm)

    def process_result(self, result):
        data, result_code, member, realm = result
        self.count += 1
        if data:
            if self.mode == 'warcraftlogs': return self.process_warcraftlogs_result(data, result_code, member)
            try:
                if result_code == 200 and len(loads(data)) > 0:
                    processed_data, processed_spec_data, processed_snapshot_data = member.check(loads(data),realm,self.region)
                    self.csv_data.append(processed_data)
                    self.spec_data.append(processed_spec_data)
                    if processed_snapshot_data: self.snapshot_data.append(processed_snapshot_data)
                elif result_code == 403:
                    log('error','API limit reached. Waiting for 1 minute. Status code: {0}'.format(result_code),self.guild_id,member.user_id)
                    time.sleep(60)
                    log('info','Waited for 1 minute. Checking this guild again now.',self.guild_id)
                    self.check()
                    return False

                else:
                    self.wrong_users.append(member.user_id)
                    log('error','Could not fetch user data. Status code: {0}'.format(result_code),self.guild_id,member.user_id)
                    if member.last_refresh:
                        try:
                            self.csv_data.append(loads(member.last_refresh))
                            self.csv_data[-1][0] = member.name
                        except Exception as e:
                            log('error','Error in loading old user data. Error: {0}'.format(error(e)),self.guild_id,member.user_id)
            except Exception as e:
                log('error','Error in processing API result. Error: {0}'.format(error(e)),self.guild_id,member.user_id)
        else:
            self.wrong_users.append(member.user_id)
            log('error','No data returned by API. Status code: {0}'.format(result_code),self.guild_id,member.user_id)
            if member.last_refresh:
                try:
                    self.csv_data.append(loads(member.last_refresh))
                    self.csv_data[-1][0] = member.name
                except:
                    log('error','Error in loading old user data. Data: {0}'.format(member.last_refresh[:100]),self.guild_id,member.user_id)
                    if self.mode == 'debug': raise Exception
        return True

    def process_warcraftlogs_result(self,data,result_code,member):
        if result_code == 200 and len(loads(data)) > 0:
            try:
                for encounter in loads(data):
                    self.processed_data[member.name]['warcraftlogs_id'] = encounter['specs'][0]['data'][0]['character_id']
                    stored = False
                    if encounter['difficulty'] >= 3: # Exclude Looking for Raid data
                        for spec in encounter['specs']:
                            if spec['spec'] == member.role:
                                self.processed_data[member.name][encounter['name']][encounter['difficulty']].update({'best': spec['best_historical_percent'], 'median': spec['historical_median'], 'average': spec['historical_avg']})
                                stored = True
                                break
                            elif spec['spec'] in WCL_ROLES_TO_SPEC_MAP[member.role]:
                                self.processed_data[member.name][encounter['name']][encounter['difficulty']].update({'best': spec['best_historical_percent'], 'median': spec['historical_median'], 'average': spec['historical_avg']})
                                stored = True
                                break
                        if not stored:
                            self.processed_data[member.name][encounter['name']][encounter['difficulty']].update({'best': '-', 'median': '-', 'average': '-'})
                self.success += 1
            except Exception as e: log('error','Processing the API result of this user failed. Error: {0}'.format(error(e)),self.guild_id,member.user_id)
        elif result_code != 200:
            log('error','The API call returned an error. Result code: {0}'.format(result_code),self.guild_id,member.user_id)

    def generate_warnings(self):
        if not self.tracking_all:
            self.warning_message = "warning|Not all added members are being tracked. Please check wow.vanlankveld.me and update the list of members."
        elif len(self.wrong_users) > 0:
            self.warning_message = "warning|Not all added members have a valid role for their class. Please check wow.vanlankveld.me and update the list of members."
        else:
            self.warning_message = "good|All added members are being tracked, there are no problems!"

    def update_users_in_db(self):
        if self.snapshot_data:
            base_snapshot_query = 'UPDATE users SET weekly_snapshot = CASE '
            for member in self.snapshot_data:
                base_snapshot_query += 'WHEN user_id = {0} THEN \'{1}\' '.format(member[0],dumps(member[1]))

            if self.mode != 'debug':
                execute_query(base_snapshot_query + ' ELSE weekly_snapshot END')
                log('info','Updated snapshots for {0} users'.format(len(self.snapshot_data)),self.guild_id)

            old_snapshot_query = 'UPDATE users SET old_snapshots = CASE '
            for member in self.members:
                old_snapshot_query += 'WHEN user_id = {0} THEN \'{1}\' '.format(self.members[member].user_id,'|'.join([dumps(week) for week in self.members[member].old_snapshots]))

            if self.mode != 'debug': execute_query(old_snapshot_query + ' ELSE old_snapshots END')

        if len(self.spec_data) > 0:

            base_spec_query = 'UPDATE users SET per_spec = CASE '
            for member in self.spec_data:
                base_spec_query += 'WHEN user_id = {0} THEN \'{1}\' '.format(member[0],member[1])

            base_spec_query += ' ELSE per_spec END, tier_data = CASE '
            for member in self.spec_data:
                base_spec_query += 'WHEN user_id = {0} THEN \'{1}\' '.format(member[0],dumps(member[2]))

            base_spec_query += ' ELSE tier_data END, last_refresh = CASE '
            for member in self.csv_data:
                base_spec_query += 'WHEN user_id = {0} THEN \'{1}\' '.format(member[HEADER.index('user_id')],dumps(member).replace("'","\\'"))

            base_spec_query += ' ELSE last_refresh END, status = CASE '
            for member in self.spec_data:
                base_spec_query += 'WHEN user_id = {0} THEN \'tracking\' '.format(member[0])

            for member in self.wrong_users:
                base_spec_query += 'WHEN user_id = {0} THEN \'not tracking\' '.format(member)

            if self.mode != 'debug': execute_query(base_spec_query + ' ELSE status END',False)

        elif len(self.wrong_users) > 0:
            base_spec_query = 'UPDATE users SET status = CASE '
            for member in self.wrong_users:
                base_spec_query += 'WHEN user_id = {0} THEN \'not tracking\' '.format(member)

            if self.mode != 'debug': execute_query(base_spec_query + ' ELSE status END',False)

        if self.mode != 'debug': execute_query('UPDATE guilds SET last_checked = {0} WHERE guild_id = {1}'.format((datetime.datetime.now()-datetime.datetime(2017,1,1)).total_seconds(),self.guild_id))

    def write(self):
        with open('{0}{1}.csv'.format(PATH_TO_CSV,self.key_code),'w+') as csvfile:
            write_csv(csvfile,self)

        if self.mode != 'debug':
            bucket = storage.Client().get_bucket('wowcsv')
            gcloud_path = bucket.blob('{0}.csv'.format(self.key_code))
            gcloud_path.upload_from_filename(filename='{0}{1}.csv'.format(PATH_TO_CSV,self.key_code))
            gcloud_path.cache_control = 'no-cache'
            gcloud_path.patch()
            gcloud_path.make_public()

    def update_warcraftlogs(self):
        self.success = 0
        self.count = 0
        self.processed_data = {}
        for member in self.members:
            self.processed_data[member] = {}
            for raid in VALID_RAIDS:
                for encounter in raid['encounters']:
                    self.processed_data[member][encounter['name']] = {3:{'raid':raid},4:{'raid':raid},5:{'raid':raid}}

        for raid in VALID_RAIDS:
            self.with_tornado(raid['id'])

        if self.success > 0:
            base_spec_query = 'UPDATE users SET warcraftlogs = CASE '
            for member in self.processed_data:
                output = {'best_3': [],'best_4': [],'best_5': [],'median_3': [],'median_4': [],'median_5': [],'average_3': [],'average_4': [],'average_5': []}
                for metric in output:
                    for raid in VALID_RAIDS:
                        for encounter in raid['encounters']:
                            try: output[metric].append(str(int(self.processed_data[member][encounter['name']][int(metric.split('_')[1])][metric.split('_')[0]])))
                            except: output[metric].append('-')
                output['character_id'] = self.processed_data[member]['warcraftlogs_id']
                base_spec_query += 'WHEN user_id = {0} THEN \'{1}\' '.format(self.members[member].user_id,dumps(output).replace("'","\\'"))

            execute_query(base_spec_query + ' ELSE warcraftlogs END',False)

        log('info','WCL data added to the database succesfully. Used {0} data points, for a total of {1} members.'.format(self.success, len(self.processed_data)),self.guild_id)
