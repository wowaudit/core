# -*- coding: utf-8 -*-
from constants import *
import time, datetime, itertools
from execute_query import execute_query
from dateutil import tz
from json import loads, dumps
from writer import log

class Member(object):

    def __init__(self,data,team_id,last_reset):
        self.character_id, self.name, self.role, self.snapshot, self.legendary_snapshot, self.realm, self.spec_stored_data, \
        self.tier_data, self.status, self.warcraftlogs, self.last_refresh, self.old_snapshots = data[9:]
        self.team_id = team_id
        self.last_reset = last_reset

        #TODO: Strip whitespace on website instead
        self.name = self.name.replace(' ','')

        self.legendaries = []
        if self.legendary_snapshot:
            for legendary in self.legendary_snapshot.split('|'):
                self.legendaries.append(legendary)

        try: self.dungeon_snapshot = int(loads(self.snapshot)['dungeons'])
        except: self.dungeon_snapshot = 'not there'

        try: self.wq_snapshot = int(loads(self.snapshot)['wqs'])
        except: self.wq_snapshot = 'not there'

        try: self.ap_snapshot = int(loads(self.snapshot)['ap'])
        except: self.ap_snapshot = 'not there'

        try: self.tier_data = loads(self.tier_data)
        except: self.tier_data = {"head":0,"shoulder":0,"back":0,"chest":0,"hands":0,"legs":0}

        try:
            self.old_snapshots = [loads(week) for week in self.old_snapshots.split('|')]
        except:
            self.old_snapshots = []

        self.specs = {}
        count = 1

        try:
            if self.spec_stored_data.split('|')[:-1]:
                for spec in self.spec_stored_data.split('|')[:-1]:
                    traits, max_ilvl = spec.split('_')
                    self.specs[count] = (traits,max_ilvl)
                    count += 1
                self.max_ilvl = self.spec_stored_data.split('|')[-1]
            else:
                self.specs = {1:(0,0),2:(0,0),3:(0,0),4:(0,0)}
                self.max_ilvl = 0

        except:
            self.specs = {1:(0,0),2:(0,0),3:(0,0),4:(0,0)}
            self.max_ilvl = 0

    def check(self,data,realm,region):
        self.processed_data = {}
        spec_information = []

        self.process_basic_data(data,realm)
        self.process_gear_data(data)
        self.process_artifact_data(data)
        self.process_reputation_data(data)
        self.process_dungeon_data(data)
        self.process_warcraftlogs_data(data)
        self.process_wq_data(data)
        self.process_legendary_data(data)
        self.process_nocombat_data(data)
        self.process_spec_data(data)
        self.update_stored_data()
        self.process_old_snapshots()

        self.build_from_header()

        return [self.row_data,self.spec_data,self.snapshot_data]

    def build_from_header(self):
        self.row_data = []
        for item in HEADER:
            self.row_data.append(self.processed_data[item])

    def process_basic_data(self,data,realm):
        self.processed_data['name'] = data['name']
        self.processed_data['class'] = CLASSES[data['class']]
        self.processed_data['realm'] = realm
        self.processed_data['rank'] = '' #Deprecated and not used in any production spreadsheet. Can be replaced with new data.
        self.processed_data['character_id'] = self.character_id

        try:
            ROLES[self.role][CLASSES[data['class']]]
            self.processed_data['role'] = self.role
        except:
            self.processed_data['role'] = DEFAULT_ROLES[CLASSES[data['class']]]

    def process_gear_data(self,data):
        self.worst_gem = []
        self.legendaries_equipped = []
        self.missing_enchants = {}
        self.enchanted_items = {}
        self.ilvl = 0.0

        for item in ITEMS:
            try:
                self.process_enchant(data,item)
                if int(data['items'][item]['id']) in TIER_IDS:
                    self.tier_data[item] = int(data['items'][item]['itemLevel'])

                if 3529 in data['items'][item]['bonusLists']: #Workaround for Armory returning Legendary ilvl wrong
                    self.ilvl += 940
                    self.processed_data[item + '_ilvl'] = 940
                else:
                    self.ilvl += data['items'][item]['itemLevel']
                    self.processed_data[item + '_ilvl'] = data['items'][item]['itemLevel']
                self.processed_data[item + '_id'] = data['items'][item]['id']
                self.processed_data[item + '_name'] = data['items'][item]['name']
                self.processed_data[item + '_quality'] = data['items'][item]['quality']

                if data['items'][item]['itemLevel'] >= 800 and data['items'][item]['quality'] == 5:
                    self.legendaries_equipped.append('{0}_{1}'.format(data['items'][item]['id'],data['items'][item]['name'].encode('utf-8')))

            except KeyError:
                self.processed_data[item + '_ilvl'] = ''
                self.processed_data[item + '_id'] = ''
                self.processed_data[item + '_name'] = ''
                self.processed_data[item + '_quality'] = ''

            if item in self.tier_data: self.processed_data['tier_{0}'.format(item)] = self.tier_data[item]

        try: self.ilvl += (data['items']['mainHand']['itemLevel']*2) # Weapon is always counted twice to keep it fair for 2h specs
        except: pass

        self.processed_data['ilvl'] = round(self.ilvl / (len(ITEMS) + 2),2)
        self.processed_data['empty_sockets'] = data['audit']['emptySockets']
        self.processed_data['gem_list'] = '|'.join(self.worst_gem)

    def process_enchant(self,data,item):
        try: self.worst_gem.append(str(GEMS[data['items'][item]['tooltipParams']['gem0']]))
        except: pass

        if item in ENCHANTS:
            try:
                self.processed_data['enchant_quality_{0}'.format(item)] = ENCHANTS[item][data['items'][item]['tooltipParams']['enchant']][0]
                self.processed_data['{0}_enchant'.format(item)] = ENCHANTS[item][data['items'][item]['tooltipParams']['enchant']][1]
            except KeyError:
                self.processed_data['enchant_quality_{0}'.format(item)] = 0
                self.processed_data['{0}_enchant'.format(item)] = ''

    def process_artifact_data(self,data):
        try:
            self.processed_data['artifact_ilvl'] = data['items']['mainHand']['itemLevel']

            total_traits = 0
            if data['items']['mainHand']['artifactTraits']: weapon = 'mainHand'
            else:
                try:
                    if data['items']['offHand']['artifactTraits']: weapon = 'offHand'
                    else: weapon = False
                except: weapon = False

            if weapon:
                self.processed_data['current_spec_name'], self.spec_id = ARTIFACTS[data['items'][weapon]['name']]

                for trait in data['items'][weapon]['artifactTraits']:
                    total_traits += int(trait['rank'])

                total_traits -= len(data['items'][weapon]['relics'])
                self.processed_data['equipped_traits'] = total_traits

                for relic in [1,2,3]:
                    try:
                        self.processed_data.update({
                            'relic{0}_ilvl'.format(relic): RELIC_ILVL[data['items'][weapon]['bonusLists'][relic]-1472],
                            'relic{0}_id'.format(relic): data['items'][weapon]['relics'][relic - 1]['itemId'],
                            'relic{0}_name'.format(relic): '',
                            'relic{0}_quality'.format(relic): ''})
                    except:
                        self.processed_data.update({
                            'relic{0}_ilvl'.format(relic):'',
                            'relic{0}_id'.format(relic):'',
                            'relic{0}_name'.format(relic): '',
                            'relic{0}_quality'.format(relic): ''})
            else: raise KeyError

        except KeyError:
            self.processed_data['current_spec_name'] = 'Unknown'
            self.spec_id = 1
            self.processed_data['equipped_traits'] = 0
            self.processed_data['artifact_ilvl'] = 0
            for relic in [1,2,3]:
                self.processed_data.update({
                    'relic{0}_ilvl'.format(relic):'',
                    'relic{0}_id'.format(relic):'',
                    'relic{0}_name'.format(relic): '',
                    'relic{0}_quality'.format(relic): ''})

        try:
            ap_data = data['achievements']['criteria'].index(30103)
            ap_amount = data['achievements']['criteriaQuantity'][ap_data]
        except: ap_amount = 0
        self.processed_data['ap_obtained_total'] = ap_amount
        self.processed_data['ap_this_week'] = 0 if self.ap_snapshot == 'not there' else ap_amount-self.ap_snapshot

    def process_reputation_data(self,data):
        reps = {}
        rep_value = 0
        exalted_rep_amount = 0
        for reputation in REPUTATIONS:
            match = False
            for rep_data in data['reputation']:
                if rep_data['standing'] == 7: exalted_rep_amount += 1
                if rep_data['id'] == reputation:
                    self.processed_data['{0}_standing'.format(REPUTATIONS[reputation])] = STANDINGS[rep_data['standing']]
                    # API started always returning 0 as value when Exalted (possibly due to Paragon system). Passing static 999 to make the sheet prettier.
                    self.processed_data['{0}_value'.format(REPUTATIONS[reputation])] = 999 if rep_data['standing'] == 7 else rep_data['value']
                    rep_value += ( ( rep_data['standing'] - 2 ) + ( float(rep_data['value']) / REP_AMOUNT[rep_data['standing']] ) )
                    match = True

            if not match:
                self.processed_data['{0}_standing'.format(REPUTATIONS[reputation])] = 'Neutral'
                self.processed_data['{0}_value'.format(REPUTATIONS[reputation])] = 0
        self.processed_data['reputation_ranking'] = rep_value #Deprecated, not used in any production spreadsheet version. Can be replaced.
        self.processed_data['exalted_amount'] = exalted_rep_amount / len(REPUTATIONS)

    def process_dungeon_data(self,data):
        BOSS_IDS = [[boss['raid_ids'].values() for boss in raid['encounters']] for raid in VALID_RAIDS]
        for i in range(2): BOSS_IDS = list(itertools.chain.from_iterable(BOSS_IDS)) # Flatten the list
        dungeon_list = {}
        raid_list = {}
        dungeon_count = 0
        instance_data = data['statistics']['subCategories'][5]['subCategories'][6]['statistics']
        for instance in instance_data:
            if instance['id'] in MYTHIC_DUNGEONS:
                dungeon_count += instance['quantity']
                try: self.processed_data[MYTHIC_DUNGEONS[instance['id']]] += instance['quantity'] #For dungeons with multiple entries
                except: self.processed_data[MYTHIC_DUNGEONS[instance['id']]] = instance['quantity']

            if instance['id'] in BOSS_IDS:
                raid_list[instance['id']] = (instance['quantity'], 1 if (instance['lastUpdated'] / 1000) > self.last_reset else 0)

        self.processed_data['dungeons_done_total'] = dungeon_count
        if self.dungeon_snapshot != 'not there': self.processed_data['dungeons_this_week'] = dungeon_count-self.dungeon_snapshot
        else: self.processed_data['dungeons_this_week'] = 0

        #Future dungeons with unknown ID that are already added in front-end
        self.processed_data['Cathedral of Eternal Night'] = 0

        # Process raids data
        raid_output = {'raids_normal':[],'raids_normal_weekly':[],'raids_heroic':[],'raids_heroic_weekly':[],'raids_mythic':[],'raids_mythic_weekly':[]}
        for raid in VALID_RAIDS:
            for encounter in raid['encounters']:
                for difficulty in encounter['raid_ids']:
                    raid_output['raids_{0}'.format(difficulty)].append(str(raid_list[encounter['raid_ids'][difficulty]][0]))
                    raid_output['raids_{0}_weekly'.format(difficulty)].append(str(raid_list[encounter['raid_ids'][difficulty]][1]))
        for metric in raid_output: self.processed_data[metric] = '|'.join(raid_output[metric])


    def process_warcraftlogs_data(self,data):
        if self.warcraftlogs:
            data = loads(self.warcraftlogs)
            self.processed_data['WCL_id'] = data['character_id']
            for difficulty in data:
                if data[difficulty] != self.processed_data['WCL_id']:
                    self.processed_data['WCL_{0}_{1}'.format(RAID_DIFFICULTIES[int(difficulty.split('_')[1])],difficulty.split('_')[0])] = '|'.join(data[difficulty])
        else:
            self.processed_data['WCL_id'] = ''
            for difficulty in ['best_3','best_4','best_5','median_3','median_4','median_5','average_3','average_4','average_5']:
                self.processed_data['WCL_{0}_{1}'.format(RAID_DIFFICULTIES[int(difficulty.split('_')[1])],difficulty.split('_')[0])] = ''

    def process_wq_data(self,data):
        try:
            wq_data = data['achievements']['criteria'].index(33094)
            wq_amount = data['achievements']['criteriaQuantity'][wq_data]
        except: wq_amount = 0

        self.processed_data['wqs_done_total'] = wq_amount
        self.processed_data['wqs_this_week'] = 0 if self.wq_snapshot == 'not there' else wq_amount-self.wq_snapshot

        paragon_amount = 0
        for criteria in range(36330,36337):
            try: paragon_amount += data['achievements']['criteriaQuantity'][data['achievements']['criteria'].index(criteria)]
            except: pass # Catch error that is raised when quantity is 0

        # For some reason the first 10 completions are removed from the criterias when the achievement is completed
        if 11653 in data['achievements']['achievementsCompleted']: paragon_amount += 10
        self.processed_data['paragon_amount'] = paragon_amount

    def process_legendary_data(self,data):
        try:
            flag = False
            for legendary in self.legendaries_equipped:
                if legendary not in self.legendaries:
                    flag = True
            if flag:
                all_legendaries = set(self.legendaries_equipped + self.legendaries)
                execute_query('UPDATE characters SET legendaries = \'{0}\' WHERE id = \'{1}\''.format('|'.join(all_legendaries).replace("'","\\'"),self.character_id))
            else: all_legendaries = self.legendaries

            self.processed_data['legendary_amount'] = len(all_legendaries)
            self.processed_data['legendary_list'] = '|'.join(all_legendaries)

        #Taiwanese teams can't handle legendaries for now (TODO)
        except:
            self.processed_data['legendary_amount'] = 0
            self.processed_data['legendary_list'] = ''

    def process_nocombat_data(self,data):
        self.processed_data['achievement_points'] = data['achievementPoints']
        self.processed_data['mounts'] = data['statistics']['subCategories'][0]['subCategories'][2]['statistics'][7]['quantity']

        pets_owned = []
        unique_pets = 0
        level_25_pets = 0
        for pet in data['pets']['collected']:
            if pet['stats']['speciesId'] not in pets_owned:
                unique_pets += 1
                pets_owned.append(pet['stats']['speciesId'])
                if pet['stats']['level'] == 25: level_25_pets += 1
        self.processed_data['unique_pets'] = unique_pets
        self.processed_data['lvl_25_pets'] = level_25_pets

    def process_old_snapshots(self):
        self.processed_data['historical_wqs_done'] = []
        self.processed_data['historical_ap_gained'] = []
        self.processed_data['historical_dungeons_done'] = []
        if len(self.old_snapshots) > 1:
            for i, week in enumerate(self.old_snapshots[1:]):
                self.processed_data['historical_wqs_done'].insert(0,str(week['wqs'] - self.old_snapshots[i]['wqs']))
                self.processed_data['historical_ap_gained'].insert(0,str(week['ap'] - self.old_snapshots[i]['ap']))
                self.processed_data['historical_dungeons_done'].insert(0,str(week['dungeons'] - self.old_snapshots[i]['dungeons']))
        self.processed_data['historical_wqs_done'] = '|'.join(self.processed_data['historical_wqs_done'])
        self.processed_data['historical_ap_gained'] = '|'.join(self.processed_data['historical_ap_gained'])
        self.processed_data['historical_dungeons_done'] = '|'.join(self.processed_data['historical_dungeons_done'])

    def process_spec_data(self,data):
        #Spec data
        self.spec_output = []
        max_spec = [0,0]

        for spec in [1,2,3,4]:
            if spec == self.spec_id:
                self.spec_output.append('{0}_{1}'.format(self.processed_data['equipped_traits'],self.processed_data['ilvl']))
                self.processed_data['spec{0}_traits'.format(spec)] = self.processed_data['equipped_traits']
                self.processed_data['spec{0}_ilvl'.format(spec)] = self.processed_data['ilvl']
                self.specs[spec] = (self.processed_data['equipped_traits'],self.processed_data['ilvl'])
            else:
                self.spec_output.append('{0}_{1}'.format(self.specs[spec][0],self.specs[spec][1]))
                self.processed_data['spec{0}_traits'.format(spec)] = self.specs[spec][0]
                self.processed_data['spec{0}_ilvl'.format(spec)] = self.specs[spec][1]

            #Find main spec
            if spec in ROLES[self.processed_data['role']][CLASSES[data['class']]]:
                if int(self.specs[spec][0]) >= int(max_spec[1]):
                    max_spec = [spec,int(self.specs[spec][0])]

        self.spec_output.append(str(max(float(self.max_ilvl),float(self.processed_data['ilvl']))))
        self.processed_data['highest_ilvl_ever_equipped'] = max(float(self.max_ilvl),float(self.processed_data['ilvl']))
        self.processed_data['main_spec'] = max_spec[0]
        self.spec_data = [self.character_id,'|'.join(self.spec_output),self.tier_data]

    def update_stored_data(self):
        #Sets updated snapshot data if a new snapshot has to be made
        if self.dungeon_snapshot == 'not there' or self.wq_snapshot == 'not there' or self.ap_snapshot == 'not there':
            self.snapshot_data = (self.character_id,{
                'dungeons': self.processed_data['dungeons_done_total'] if self.dungeon_snapshot == 'not there' else self.dungeon_snapshot,
                'wqs': self.processed_data['wqs_done_total'] if self.wq_snapshot == 'not there' else self.wq_snapshot,
                'ap': self.processed_data['ap_obtained_total'] if self.ap_snapshot == 'not there' else self.ap_snapshot})
            self.old_snapshots.append(self.snapshot_data[1])
        else: self.snapshot_data = False
