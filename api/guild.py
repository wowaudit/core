# -*- coding: utf-8 -*-
from member import Member
from constants import *
from auth import API_KEY
from concurrent import futures
import requests, datetime
from json import loads, dumps
from execute_query import execute_query
from writer import UnicodeWriter
from dateutil import tz

class Guild(object):

    def __init__(self, data):
        self.guild_id, self.name, self.region, self.realm, self.key_code, self.last_checked = data[:6]
        self.version_message = "{0}|Your spreadsheet is out of date. Make a copy of the new version on wow.vanlankveld.me.".format(CURRENT_VERSION)
        self.tracking_all = True
        self.members = {}
        self.add_member(data)
        self.name = self.name.encode('utf-8')
        self.realm = self.realm.encode('utf-8')

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
            tasks = dict((executor.submit(self.make_request_futures, user), user) for user in self.members)
            for user in futures.as_completed(tasks):
                data, result_code, member, realm = user.result()
                count += 1

                if result_code == 200 and len(loads(data)) > 0:
                    self.csv_data.append(self.add_row(loads(data),member.name,realm))
                    #print u'Progress: {0}/{1}'.format(count,len(self.members))
                else:
                    self.wrong_users.append(member.user_id)
                    #print u'Skipped one due to a query error. Progress: {0}/{1}'.format(count,len(self.members))

        if not self.tracking_all:
            self.warning_message = "warning|Not all added members are being tracked. Please check wow.vanlankveld.me and update the list of members."
        elif len(self.wrong_users) > 0:
            self.warning_message = "warning|Not all added members have a valid role for their class. Please check wow.vanlankveld.me and update the list of members."
        else:
            self.warning_message = "good|All added members are being tracked, there are no problems!"

        if self.snapshot_data:
            base_snapshot_query = 'UPDATE users SET weekly_snapshot = CASE '
            for member in self.snapshot_data:
                base_snapshot_query += 'WHEN user_id = \'{0}\' THEN \'{1}\' '.format(member[0],dumps(member[1]))

            execute_query(base_snapshot_query + ' ELSE weekly_snapshot END')
            print 'Updated the weekly snapshot for the newly added users or because it is wednesday morning for guild with ID {0}.'.format(self.guild_id)

        #Update spec and tier data in DB, as well as status


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

            execute_query(base_spec_query + ' ELSE status END',False)

        elif len(self.wrong_users) > 0:
            base_spec_query = 'UPDATE users SET status = CASE '
            for member in self.wrong_users:
                base_spec_query += 'WHEN user_id = {0} THEN \'not tracking\' '.format(member)

            execute_query(base_spec_query + ' ELSE status END',False)

        execute_query('UPDATE guilds SET last_checked = {0} WHERE guild_id = {1}'.format((datetime.datetime.now()-datetime.datetime(2017,1,1)).total_seconds(),self.guild_id))

        with open('{0}{1}.csv'.format(PATH_TO_CSV,self.key_code),'w+') as csvfile:
            self.write_csv(csvfile)

    def make_request_futures(self,user):
        if self.members[user].realm: realm = self.members[user].realm.encode('utf-8')
        else: realm = self.realm
        response = requests.get(URL.format(self.region,realm,self.members[user].name,API_KEY).replace(" ","%20"))
        return (response.text,response.status_code,self.members[user],realm)


    def add_row(self,data,member,realm):
        legendaries_equipped = []
        spec_information = []
        member = member.decode('utf-8')
        row_data = [data['name'], CLASSES[data['class']]]
        missing_enchants = []
        enchanted_items = []
        worst_gem = []
        ilvl = 0.0

        for item in ITEMS:
            try:
                worst_gem.append(str(GEMS[data['items'][item]['tooltipParams']['gem0']]))
            except: pass
            try:
                if item in ENCHANTS:
                    try:
                        missing_enchants.append(ENCHANTS[item][data['items'][item]['tooltipParams']['enchant']][0])
                        enchanted_items.append(ENCHANTS[item][data['items'][item]['tooltipParams']['enchant']][1])
                    except KeyError:
                        missing_enchants.append(0)
                        enchanted_items.append('')

                if int(data['items'][item]['id']) in TIER_IDS:
                    self.members[member].tier_data[item] = int(data['items'][item]['itemLevel'])


                ilvl += data['items'][item]['itemLevel']
                row_data += [data['items'][item]['itemLevel'], data['items'][item]['id'], data['items'][item]['name'], data['items'][item]['quality']]

                if data['items'][item]['itemLevel'] >= 800 and data['items'][item]['quality'] == 5:
                    legendaries_equipped.append('{0}_{1}'.format(data['items'][item]['id'],data['items'][item]['name']))

            except KeyError:
                row_data += ['', '', '', '']
        try:
            ilvl += data['items']['mainHand']['itemLevel']
            ilvl += data['items']['mainHand']['itemLevel']
            row_data.insert(2,data['items']['mainHand']['itemLevel'])

            total_traits = 0
            if data['items']['mainHand']['artifactTraits']: weapon = 'mainHand'
            else:
                try:
                    if data['items']['offHand']['artifactTraits']: weapon = 'offHand'
                    else: weapon = False
                except: weapon = False

            if weapon:
                spec_name, spec_id = ARTIFACTS[data['items'][weapon]['name']]

                for trait in data['items'][weapon]['artifactTraits']:
                    total_traits += int(trait['rank'])

                total_traits -= len(data['items'][weapon]['relics'])
                row_data.insert(2,total_traits)

                try: row_data += [RELIC_ILVL[data['items'][weapon]['bonusLists'][1]-1472],data['items'][weapon]['relics'][0]['itemId'],'','']
                except: row_data += ['','','','']

                try: row_data += [RELIC_ILVL[data['items'][weapon]['bonusLists'][2]-1472],data['items'][weapon]['relics'][1]['itemId'],'','']
                except: row_data += ['','','','']

                try: row_data += [RELIC_ILVL[data['items'][weapon]['bonusLists'][3]-1472],data['items'][weapon]['relics'][2]['itemId'],'','']
                except: row_data += ['','','','']

            else:
                spec_name = 'Unknown'
                spec_id = 1
                total_traits = 0
                row_data.insert(2,0)
                row_data += ['', '', '', '', '', '', '', '', '', '', '', ''] #RELICS

        except KeyError:
            spec_name = 'Unknown'
            spec_id = 1
            total_traits = 0
            row_data.insert(2,0)
            row_data.insert(2,0)
            row_data += ['', '', '', '', '', '', '', '', '', '', '', ''] #RELICS

        average_ilvl_equipped = round(ilvl / (len(ITEMS) + 2),2)
        row_data.insert(2,average_ilvl_equipped)

        reps = {}
        rep_value = 0
        exalted_rep_amount = 0
        for reputation in REPUTATIONS:
            for rep_data in data['reputation']:
                if rep_data['standing'] == 7: exalted_rep_amount += 1
                if rep_data['id'] == reputation:
                    reps[REPUTATIONS[reputation]] = [STANDINGS[rep_data['standing']], rep_data['value']]
                    rep_value += ( ( rep_data['standing'] - 2 ) + ( float(rep_data['value']) / REP_AMOUNT[rep_data['standing']] ) )

        for reputation in REP_ORDERED:
            try: row_data += reps[reputation]
            except: row_data += ['Neutral',0]
        row_data += missing_enchants + [data['audit']['emptySockets']]
        row_data.append(rep_value)

        try:
            ROLES[self.members[member].role][CLASSES[data['class']]]
            role = self.members[member].role
        except:
            role = DEFAULT_ROLES[CLASSES[data['class']]]
        row_data.append(role)

        dungeon_list = {}
        dungeon_count = 0
        id_count = 1
        dungeon_data = data['statistics']['subCategories'][5]['subCategories'][6]['statistics']
        for dungeon in dungeon_data:
            if dungeon['id'] in MYTHIC_DUNGEONS:
                dungeon_count += dungeon['quantity']
                try: dungeon_list[MYTHIC_DUNGEONS[dungeon['id']]][1] += dungeon['quantity']
                except: dungeon_list[MYTHIC_DUNGEONS[dungeon['id']]] = [id_count,dungeon['quantity']]
            id_count += 1
        dungeon_list = [i[1][1] for i in sorted(dungeon_list.items(), key=lambda x: x[1][0])]
        row_data += [dungeon_count] + dungeon_list

        if not self.members[member].dungeon_snapshot == 'not there':
            row_data.append(dungeon_count-self.members[member].dungeon_snapshot)
        else: row_data.append(0)

        try:
            wq_data = data['achievements']['criteria'].index(33094)
            wq_amount = data['achievements']['criteriaQuantity'][wq_data]
        except: wq_amount = 0

        if not self.members[member].wq_snapshot == 'not there':
            row_data += [wq_amount,wq_amount-self.members[member].wq_snapshot]
        else: row_data += [wq_amount,0]

        flag = False
        for legendary in legendaries_equipped:
            if legendary not in self.members[member].legendaries:
                flag = True

        if flag:
            all_legendaries = set(legendaries_equipped + self.members[member].legendaries)
            execute_query('UPDATE users SET legendaries = \'{0}\' WHERE user_id = \'{1}\''.format('|'.join(all_legendaries).replace("'","\\'"),self.members[member].user_id))
            row_data.append(len(all_legendaries))

        else:
            row_data.append(len(self.members[member].legendaries))
            all_legendaries = self.members[member].legendaries

        row_data.append(data['achievementPoints'])
        row_data.append(data['statistics']['subCategories'][0]['subCategories'][2]['statistics'][7]['quantity']) #mounts total
        row_data.append(exalted_rep_amount / len(REPUTATIONS))

        pets_owned = []
        unique_pets = 0
        level_25_pets = 0
        for pet in data['pets']['collected']:
            if pet['stats']['speciesId'] not in pets_owned:
                unique_pets += 1
                pets_owned.append(pet['stats']['speciesId'])
                if pet['stats']['level'] == 25: level_25_pets += 1
        row_data += [unique_pets,level_25_pets]

        row_data.append(realm)
        row_data.append('|'.join(all_legendaries))
        row_data += enchanted_items
        row_data.append('|'.join(worst_gem))
        row_data += [self.members[member].tier_data['head'],self.members[member].tier_data['shoulder'],self.members[member].tier_data['back'], \
                     self.members[member].tier_data['chest'],self.members[member].tier_data['hands'],self.members[member].tier_data['legs']]

        try:
            ap_data = data['achievements']['criteria'].index(30103)
            ap_amount = data['achievements']['criteriaQuantity'][ap_data]
        except: ap_amount = 0

        if not self.members[member].ap_snapshot == 'not there':
            row_data += [ap_amount,ap_amount-self.members[member].ap_snapshot]
        else: row_data += [ap_amount,0]

        #Spec data
        spec_output = []
        for spec in [1,2,3,4]:
            if spec == spec_id:
                spec_information += [total_traits,average_ilvl_equipped]
                spec_output.append('{0}_{1}'.format(total_traits,average_ilvl_equipped))
                self.members[member].specs[spec] = (total_traits,average_ilvl_equipped)
            else:
                spec_information += [self.members[member].specs[spec][0],self.members[member].specs[spec][1]]
                spec_output.append('{0}_{1}'.format(self.members[member].specs[spec][0],self.members[member].specs[spec][1]))

        spec_output.append(str(max(float(self.members[member].max_ilvl),float(average_ilvl_equipped))))

        #Find main spec
        max_spec = [0,0]
        for spec in [1,2,3,4]:
            if spec in ROLES[role][CLASSES[data['class']]]:
                if int(self.members[member].specs[spec][0]) >= int(max_spec[1]):
                    max_spec = [spec,int(self.members[member].specs[spec][0])]

        row_data += spec_information
        row_data.append(spec_name)
        row_data.append(max(float(self.members[member].max_ilvl),float(average_ilvl_equipped)))
        row_data.append(max_spec[0])
        row_data.append(0) #Cathedral of Eternal Night Dungeon

        #Snapshot dungeon and WQ data
        if (self.region == 'EU' and datetime.datetime.weekday(datetime.datetime.now()) == 2 and datetime.datetime.now().hour == 7) or \
           (self.region == 'US' and datetime.datetime.weekday(datetime.datetime.now()) == 1 and datetime.datetime.now().hour == 13):
            self.snapshot_data.append((self.members[member].user_id,{'dungeons':dungeon_count,'wqs':wq_amount,'ap':ap_amount}))
        elif self.members[member].dungeon_snapshot == 'not there' or self.members[member].wq_snapshot == 'not there' or self.members[member].ap_snapshot == 'not there':
            self.snapshot_data.append((self.members[member].user_id,{'dungeons':dungeon_count if self.members[member].dungeon_snapshot == 'not there' else self.members[member].dungeon_snapshot, \
            'wqs':wq_amount if self.members[member].wq_snapshot == 'not there' else self.members[member].wq_snapshot, \
            'ap':ap_amount if self.members[member].ap_snapshot == 'not there' else self.members[member].ap_snapshot}))

        #Store updated spec data
        self.spec_data.append([self.members[member].user_id,'|'.join(spec_output),self.members[member].tier_data])

        return row_data

    def write_csv(self,csvfile):
        writer = UnicodeWriter(csvfile,delimiter=',', lineterminator='\n')
        utc_time = datetime.datetime.utcnow().replace(tzinfo=tz.gettz('UTC'))
        europe_time = utc_time.astimezone(tz.gettz('Europe/Amsterdam'))
        writer.writerow([europe_time.strftime('%d-%m %H:%M'),self.name,self.realm,self.region,self.version_message,self.warning_message]+header)
        csv_data = sorted(self.csv_data,key=lambda x: x[2])
        rank = 1
        for row in reversed(csv_data):
            new_row = []
            for i in row:
                if isinstance(i,int) or isinstance(i,float):
                    new_row.append(unicode(i))
                else:
                    try: new_row.append(i.encode('utf-8'))
                    except: new_row.append(i)

            if row[-1] == 'none':
                new_row.insert(2,'-')

            else:
                new_row.insert(2,unicode(rank))
                rank += 1
            if len(new_row) > 88:
                writer.writerow(new_row)
