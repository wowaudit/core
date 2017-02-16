# -*- coding: utf-8 -*-
from member import Member
from constants import *
from auth import API_KEY, WCL_KEY, PATH_TO_CSV
from concurrent import futures
import requests, datetime, sys
from execute_query import execute_query
from writer import write_csv
from json import loads, dumps

class Guild(object):

    def __init__(self, data, mode, new_snapshot=False):
        self.guild_id, self.name, self.region, self.realm, self.key_code, self.last_checked = data[:6]
        self.version_message = "{0}|Your spreadsheet is out of date. Make a copy of the new version on wow.vanlankveld.me.".format(CURRENT_VERSION)
        self.tracking_all = True
        self.members = {}
        self.add_member(data)
        self.name = self.name.encode('utf-8')
        self.realm = self.realm.encode('utf-8')
        self.mode = mode
        self.new_snapshot = new_snapshot

    def add_member(self, data):
        name = data[7]
        if name not in self.members: self.members[name] = Member(data)
        if self.members[name].status == 'not tracking': self.tracking_all = False

    def check(self):
        self.csv_data = []
        self.snapshot_data = []
        self.spec_data = []
        self.wrong_users = []
        count = 0

        with futures.ThreadPoolExecutor(max_workers=20) as executor:
            tasks = dict((executor.submit(self.make_request_api, user), user) for user in self.members)
            for user in futures.as_completed(tasks):
                data, result_code, member, realm = user.result()
                count += 1

                if result_code == 200 and len(loads(data)) > 0:
                    processed_data, processed_spec_data, processed_snapshot_data = member.check(loads(data),realm,self.region,self.new_snapshot)
                    self.csv_data.append(processed_data)
                    self.spec_data.append(processed_spec_data)
                    if processed_snapshot_data: self.snapshot_data.append(processed_snapshot_data)
                    #print u'Progress: {0}/{1}'.format(count,len(self.members))
                else:
                    self.wrong_users.append(member.user_id)
                    #print u'Skipped one due to a query error. Progress: {0}/{1}'.format(count,len(self.members))

        self.generate_warnings()
        self.update_users_in_db()
        if len(self.csv_data) > 0:
            self.write()
        else:
            print 'Not writing a new csv file for this guild, the check of all {0} members returned an error.'.format(len(self.wrong_users))

    def make_request_api(self,user,zone=0):
        if self.members[user].realm: realm = self.members[user].realm.encode('utf-8')
        else: realm = self.realm

        if self.mode == 'warcraftlogs':
            metric = 'hps' if self.members[user].role == 'Heal' else 'dps'
            response = requests.get(WCL_URL.format(self.members[user].name,realm.replace("'","").replace(" ","-"),self.region,zone,metric,WCL_KEY).replace(" ","%20"))
        else:
            response = requests.get(URL.format(self.region,realm,self.members[user].name,API_KEY).replace(" ","%20"))

        return (response.text,response.status_code,self.members[user],realm)

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
                base_snapshot_query += 'WHEN user_id = \'{0}\' THEN \'{1}\' '.format(member[0],dumps(member[1]))

            if self.mode != 'debug':
                execute_query(base_snapshot_query + ' ELSE weekly_snapshot END')
                print 'Updated the weekly snapshot for the newly added users or because it is wednesday morning for guild with ID {0}.'.format(self.guild_id)

        if len(self.spec_data) > 0:

            base_spec_query = 'UPDATE users SET per_spec = CASE '
            for member in self.spec_data:
                base_spec_query += 'WHEN user_id = {0} THEN \'{1}\' '.format(member[0],member[1])

            base_spec_query += ' ELSE per_spec END, tier_data = CASE '
            for member in self.spec_data:
                base_spec_query += 'WHEN user_id = {0} THEN \'{1}\' '.format(member[0],dumps(member[2]))

            base_spec_query += ' ELSE tier_data END, status = CASE '
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
            write_csv(csvfile,self.name,self.realm,self.region,self.version_message,self.warning_message,self.csv_data)

    def update_warcraftlogs(self):
        count = 0
        success = 0
        self.processed_data = {}
        for member in self.members:
            self.processed_data[member] = {}
            for raid in VALID_RAIDS:
                for encounter in VALID_RAIDS[raid]['encounters']:
                    self.processed_data[member][encounter['name']] = {1:{'raid':raid},3:{'raid':raid},4:{'raid':raid},5:{'raid':raid}}

        for raid in VALID_RAIDS:
            with futures.ThreadPoolExecutor(max_workers=20) as executor:
                tasks = dict((executor.submit(self.make_request_api, user, VALID_RAIDS[raid]['id']), user) for user in self.members)
                for user in futures.as_completed(tasks):
                    data, result_code, member, realm = user.result()
                    count += 1

                    if result_code == 200 and len(loads(data)) > 0:
                        self.prepare_warcraftlogs_data(loads(data),member)
                        success += 1
                    elif result_code != 200:
                        print data, result_code, member.name, realm
                        print u'Skipped one due to a query error. Progress: {0}/{1}'.format(count,len(self.members)*len(VALID_RAIDS))

        if success > 0: self.process_warcraftlogs_data()

    def prepare_warcraftlogs_data(self,data,member):
        for encounter in data:
            self.processed_data[member.name.decode('utf-8')]['warcraftlogs_id'] = encounter['specs'][0]['data'][0]['character_id']
            stored = False
            for spec in encounter['specs']:
                if spec['spec'] == member.role:
                    self.processed_data[member.name.decode('utf-8')][encounter['name']][encounter['difficulty']].update({'best': spec['best_historical_percent'], 'median': spec['historical_median'], 'average': spec['historical_avg']})
                    stored = True
                    break
                elif spec['spec'] in WCL_ROLES_TO_SPEC_MAP[member.role]:
                    self.processed_data[member.name.decode('utf-8')][encounter['name']][encounter['difficulty']].update({'best': spec['best_historical_percent'], 'median': spec['historical_median'], 'average': spec['historical_avg']})
                    stored = True
                    break
            if not stored:
                self.processed_data[member.name.decode('utf-8')][encounter['name']][encounter['difficulty']].update({'best': '-', 'median': '-', 'average': '-'})


    def process_warcraftlogs_data(self):
        base_spec_query = 'UPDATE users SET warcraftlogs = CASE '
        try:
            for member in self.processed_data:
                output = {'character_id': self.processed_data[member]['warcraftlogs_id'],
                          'best_3': [],
                          'best_4': [],
                          'best_5': [],
                          'median_3': [],
                          'median_4': [],
                          'median_5': [],
                          'average_3': [],
                          'average_4': [],
                          'average_5': []}

                #Ugliest code in the history of the world, needs refactor badly (had issues with ordering of output string)
                for raid_order in range(1,len(VALID_RAIDS)+1):
                    for raid in VALID_RAIDS:
                        if VALID_RAIDS[raid]['raid_order'] == raid_order:
                            for order in range(1,len(VALID_RAIDS[raid]['encounters'])+1):
                                for encounter in VALID_RAIDS[raid]['encounters']:
                                    if encounter['order'] == order:
                                        for difficulty in self.processed_data[member][encounter['name']]:
                                            for metric in ['best','median','average']:
                                                if difficulty in RAID_DIFFICULTIES:
                                                    try: output['{0}_{1}'.format(metric,difficulty)].append('{0}@{1}_{2}'.format(self.processed_data[member][encounter['name']][difficulty]['raid'],encounter['name'],self.processed_data[member][encounter['name']][difficulty][metric]))
                                                    except: output['{0}_{1}'.format(metric,difficulty)].append('{0}@{1}_{2}'.format(self.processed_data[member][encounter['name']][difficulty]['raid'],encounter['name'],'-'))

                base_spec_query += 'WHEN user_id = {0} THEN \'{1}\' '.format(self.members[member]   .user_id,dumps(output).replace("'","\\'"))

            execute_query(base_spec_query + ' ELSE warcraftlogs END',False)

        except: pass
