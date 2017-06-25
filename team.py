# -*- coding: utf-8 -*-
from member import Member
from constants import *
from auth import *
from concurrent import futures
from tornado import ioloop, httpclient
from dateutil import tz
import requests, datetime, sys, copy, time
from execute_query import execute_query
from writer import write_csv, log, error
from json import loads, dumps
from azure.storage.blob import BlockBlobService
from azure.storage.blob import ContentSettings
uploader = BlockBlobService(account_name=AZURE_NAME, account_key=AZURE_KEY)
try:
    from minio import Minio
    from minio.policy import Policy
    minioClient = Minio('minio.wowaudit.com',access_key=MINIO_ACCESS,secret_key=MINIO_SECRET,secure=False)
except: print "Loading the Minio client failed. Not storing files in Minio."

class Team(object):

    def __init__(self, data, mode, client):
        self.team_id, self.name, self.region, self.realm, self.key_code, self.last_refreshed, self.last_refreshed_wcl, self.patreon, self.team_name = data[:9]
        self.version_message = "{0}|Your spreadsheet is out of date, if you are still using version 4.0 you may see old data, blank sheets, and error notification mails from Google; please make a new copy at https://wowaudit.com/copy. In case you get these mails you should revoke authorisation of all scripts called Refresh first, at https://myaccount.google.com/permissions".format(CURRENT_VERSION)
        self.last_reset = self.reset_timestamp()
        self.tracking_all = True
        self.members = {}
        self.add_member(data)
        self.name = self.name
        self.realm = self.realm
        self.mode = mode
        self.client = client

    def add_member(self, data):
        name = data[10]
        if name not in self.members: self.members[name] = Member(data,self.team_id,self.last_reset)
        if self.members[name].status == 'not tracking': self.tracking_all = False

    def reset_timestamp(self):
        times = {'EU':{'hour':5,'day':2},'US':{'hour':11,'day':1},'TW':{'hour':5,'day':2},'KR':{'hour':5,'day':2}}
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
        self.wrong_characters = []
        self.errored_characters = []
        self.count = 0
        keep_going = self.with_concurrent() if self.client == 'concurrent' else self.with_tornado()
        if not keep_going: return False
        self.generate_warnings()
        self.update_characters_in_db()

        log('info','Total Members: {0} | Members Refreshed: {1} | Result: {2}{3} success'.format( \
            len(self.members),len(self.csv_data), round(float(len(self.csv_data)) / float(len(self.members)) * 100,0), "%"),self.team_id)
        if len(self.csv_data) > 0:
            self.write()
            log('info','CSV file written successfully.',self.team_id)

    def with_tornado(self,zone=0):
        self.tornado_count = 0
        self.tornado_results = []
        self.tornado_params = []
        http_client = httpclient.AsyncHTTPClient()
        for character in self.members:
            self.tornado_count += 1
            url, realm = self.get_url(character,zone)
            http_client.fetch(url, callback = lambda response, character=self.members[character], realm=realm: self.handle_request_tornado(response, character, realm), connect_timeout=400, request_timeout=400)

        ioloop.IOLoop.instance().start()
        for result in self.tornado_results:
            keep_going = self.process_result(result)
            if not keep_going: return False
        return True

    def handle_request_tornado(self, response, member, realm):
        ''' Collects the response of each individual request. '''
        self.tornado_results.append((response.body,response.code,member,realm))
        self.tornado_count -= 1
        if self.tornado_count == 0:
            ioloop.IOLoop.instance().stop()

    def with_concurrent(self,zone=0):
        with futures.ThreadPoolExecutor(max_workers=10) as executor:
            tasks = dict((executor.submit(self.handle_request_concurrent, character, zone), character) for character in self.members)
            for character in futures.as_completed(tasks):
                keep_going = self.process_result(character.result())
                if not keep_going: return False
        return True

    def handle_request_concurrent(self,character,zone):
        url, realm = self.get_url(character,zone)
        response = requests.get(url)
        return (response.text,response.status_code,self.members[character],realm)

    def get_url(self,character,zone):
        if self.members[character].realm: realm = self.members[character].realm
        else: realm = self.realm

        if self.mode == 'warcraftlogs':
            metric = 'hps' if self.members[character].role == 'Heal' else 'dps'
            self.members[character].url = WCL_URL.format(self.members[character].name.encode('utf-8'),self.to_slug(realm).encode('utf-8'),self.region,zone,metric,WCL_KEY).replace(" ","%20")
        elif self.mode == 'raiderio':
            self.members[character].url = RAIDER_IO_URL.format(self.region,self.to_slug(realm).encode('utf-8'),self.members[character].name.encode('utf-8'))
        else:
            self.members[character].url = URL.format(self.region,self.to_slug(realm).encode('utf-8'),self.members[character].name.encode('utf-8'),API_KEY[self.region.upper()][self.mode]).replace(" ","%20")
        return (self.members[character].url, realm)

    def to_slug(self, realm):
        realm = realm.replace(u"'",u"")
        realm = realm.replace(u"-",u"")
        realm = realm.replace(u" ",u"-")
        realm = realm.replace(u"(",u"")
        realm = realm.replace(u")",u"")
        realm = realm.replace(u'\xea',u"e")
        realm = realm.replace(u'\xe0',u"a")
        realm = realm.lower()
        return realm

    def process_result(self, result):
        data, result_code, member, realm = result
        self.count += 1
        if data:
            if self.mode == 'warcraftlogs': return self.process_warcraftlogs_result(data, result_code, member)
            if self.mode == 'raiderio': return self.process_raiderio_result(data, result_code, member)
            try:
                if result_code == 200 and len(loads(data)) > 0:
                    processed_data, processed_spec_data, processed_snapshot_data = member.check(loads(data),realm,self.region)
                    self.csv_data.append(processed_data)
                    self.spec_data.append(processed_spec_data)
                    if processed_snapshot_data: self.snapshot_data.append(processed_snapshot_data)
                elif result_code == 403:
                    log('error','API limit reached. Waiting for 1 minute. Status code: {0}'.format(result_code),self.team_id,member.character_id)
                    time.sleep(60)
                    log('info','Waited for 1 minute. Checking this team again now.',self.team_id)
                    self.check()
                    return False

                else:
                    if result_code == 404: self.wrong_characters.append(member.character_id)
                    if result_code == 500 or result_code == 504: self.errored_characters.append(member.character_id)
                    log('error','Could not fetch character data. Status code: {0}'.format(result_code),self.team_id,member.character_id)
                    if member.last_refresh:
                        try:
                            self.csv_data.append(loads(member.last_refresh))
                            self.csv_data[-1][0] = member.name
                        except Exception as e:
                            log('error','Error in loading old character data. Error: {0}'.format(error(e)),self.team_id,member.character_id)
            except Exception as e:
                log('error','Error in processing API result. Error: {0}'.format(error(e)),self.team_id,member.character_id)
        else:
            self.errored_characters.append(member.character_id)
            log('error','No data returned by API. Status code: {0}'.format(result_code),self.team_id,member.character_id)
            if member.last_refresh:
                try:
                    self.csv_data.append(loads(member.last_refresh))
                    self.csv_data[-1][0] = member.name
                except:
                    log('error','Error in loading old character data. Data: {0}'.format(member.last_refresh[:100]),self.team_id,member.character_id)
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
                            if member.role:
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
            except Exception as e: log('error','Processing the API result of this character failed. Error: {0}'.format(error(e)),self.team_id,member.character_id)

        elif result_code == 429:
            log('info','Rate limit exceeded. Pausing for 1 minute and then retrying this guild.',self.team_id,member.character_id)
            return False

        elif result_code != 200:
            log('error','The API call returned an error. Result code: {0}'.format(result_code),self.team_id,member.character_id)
        return True

    def process_raiderio_result(self,data,result_code,member):
        if result_code == 200:
            try: self.processed_data[member.name]['raider_io_score'] = loads(data)['mythic_plus_scores']['all']
            except: self.processed_data[member.name]['raider_io_score'] = '-'
        else:
            self.processed_data[member.name]['raider_io_score'] = '-'
        self.success += 1
        return True

    def generate_warnings(self):
        if not self.tracking_all:
            self.warning_message = "warning|Not all added members are being tracked. Please check wowaudit.com and update the list of members."
        elif len(self.wrong_characters) > 0:
            self.warning_message = "warning|Not all added members have a valid role for their class. Please check wowaudit.com and update the list of members."
        else:
            self.warning_message = "good|All added members are being tracked, there are no problems!"

    def update_characters_in_db(self):
        if self.snapshot_data:
            base_snapshot_query = 'UPDATE characters SET weekly_snapshot = CASE '
            for member in self.snapshot_data:
                base_snapshot_query += 'WHEN id = {0} THEN \'{1}\' '.format(member[0],dumps(member[1]))

            if self.mode != 'debug':
                execute_query(base_snapshot_query + ' ELSE weekly_snapshot END')
                log('info','Updated snapshots for {0} characters'.format(len(self.snapshot_data)),self.team_id)

            old_snapshot_query = 'UPDATE characters SET old_snapshots = CASE '
            for member in self.members:
                old_snapshot_query += 'WHEN id = {0} THEN \'{1}\' '.format(self.members[member].character_id,'|'.join([dumps(week) for week in self.members[member].old_snapshots]))

            if self.mode != 'debug': execute_query(old_snapshot_query + ' ELSE old_snapshots END')

        if len(self.spec_data) > 0:

            base_spec_query = 'UPDATE characters SET per_spec = CASE '
            for member in self.spec_data:
                base_spec_query += 'WHEN id = {0} THEN \'{1}\' '.format(member[0],member[1])

            base_spec_query += ' ELSE per_spec END, tier_data = CASE '
            for member in self.spec_data:
                base_spec_query += 'WHEN id = {0} THEN \'{1}\' '.format(member[0],dumps(member[2]))

            base_spec_query += ' ELSE tier_data END, last_refresh = CASE '
            for member in self.csv_data:
                base_spec_query += 'WHEN id = {0} THEN \'{1}\' '.format(member[HEADER.index('character_id')],dumps(member).replace("'","\\'"))

            base_spec_query += ' ELSE last_refresh END, status = CASE '
            for member in self.spec_data:
                base_spec_query += 'WHEN id = {0} THEN \'tracking\' '.format(member[0])

            for member in self.wrong_characters:
                base_spec_query += 'WHEN id = {0} THEN \'not tracking\' '.format(member)

            for member in self.errored_characters:
                base_spec_query += 'WHEN id = {0} THEN \'temporarily unavailable\' '.format(member)

            if self.mode != 'debug': execute_query(base_spec_query + ' ELSE status END',False)

        elif (len(self.wrong_characters) + len(self.errored_characters)) > 0:
            base_spec_query = 'UPDATE characters SET status = CASE '
            for member in self.wrong_characters:
                base_spec_query += 'WHEN id = {0} THEN \'not tracking\' '.format(member)

            if self.mode != 'debug': execute_query(base_spec_query + ' ELSE status END',False)

        if self.mode != 'debug': execute_query('UPDATE teams SET last_refreshed = {0} WHERE id = {1}'.format((datetime.datetime.now()-datetime.datetime(2017,1,1)).total_seconds(),self.team_id))

    def write(self):
        with open('{0}{1}.csv'.format(PATH_TO_CSV,self.key_code),'w+') as csvfile:
            write_csv(csvfile,self)

        if self.mode != 'debug':
            try: minioClient.fput_object('wowcsv',self.key_code + '.csv','{0}{1}.csv'.format(PATH_TO_CSV,self.key_code))
            except: log('error','The Minio storage service appears to be unavailable. File is not written.',self.team_id)

            try: uploader.create_blob_from_path('wowcsv',self.key_code + '.csv','{0}{1}.csv'.format(PATH_TO_CSV,self.key_code),content_settings=ContentSettings(content_type='application/CSV'))
            except: log('error','The Azure storage service appears to be unavailable. File is not written.',self.team_id)

    def update_warcraftlogs(self,override):
        self.success = 0
        self.count = 0
        self.processed_data = {}
        for member in self.members:
            self.processed_data[member] = {}
            for raid in VALID_RAIDS:
                for encounter in raid['encounters']:
                    self.processed_data[member][encounter['name']] = {3:{'raid':raid},4:{'raid':raid},5:{'raid':raid}}

        for raid in VALID_RAIDS:
            if datetime.datetime.utcnow().weekday() in raid['days'] or override:
                keep_going = self.with_tornado(raid['id'])
                if not keep_going:
                    time.sleep(60)
                    return self.update_warcraftlogs(override)

        self.mode = 'raiderio'
        self.with_tornado()
        self.mode = 'warcraftlogs'

        if self.success > 0:
            base_spec_query = 'UPDATE characters SET warcraftlogs = CASE '
            for member in self.processed_data:
                if self.members[member].warcraftlogs:
                    data = loads(self.members[member].warcraftlogs)
                else:
                    data = False
                output = {'best_3': [],'best_4': [],'best_5': [],'median_3': [],'median_4': [],'median_5': [],'average_3': [],'average_4': [],'average_5': []}
                for metric in output:
                    offset = 0
                    for raid in VALID_RAIDS:
                        for index, encounter in enumerate(raid['encounters']):
                            try: output[metric].append(str(int(self.processed_data[member][encounter['name']][int(metric.split('_')[1])][metric.split('_')[0]])))
                            except:
                                if data:
                                    try: output[metric].append(data[metric][index + offset])
                                    except: output[metric].append('-')
                                else:
                                    output[metric].append('-')
                        offset += len(raid['encounters'])
                try: output['character_id'] = self.processed_data[member]['warcraftlogs_id']
                except: output['character_id'] = ''
                try: output['raider_io_score'] = self.processed_data[member]['raider_io_score']
                except: output['raider_io_score'] = ''

                base_spec_query += 'WHEN id = {0} THEN \'{1}\' '.format(self.members[member].character_id,dumps(output).replace("'","\\'"))

            execute_query(base_spec_query + ' ELSE warcraftlogs END',False)

        log('info','WCL data added to the database succesfully. Used {0} data points, for a total of {1} members.'.format(self.success, len(self.processed_data)),self.team_id)
