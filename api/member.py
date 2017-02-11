# -*- coding: utf-8 -*-
from constants import *
import time, datetime
from json import loads, dumps

class Member(object):

    def __init__(self,data):
        self.user_id, self.name, self.role, self.snapshot, self.legendary_snapshot, self.realm, self.spec_stored_data, self.tier_data, self.status = data[6:]
        self.name = self.name.encode('utf-8')
        self.realm = self.realm

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

    def process_basic_data(self,data):
        self.processed_data['name'] = data['name']
        self.processed_data['class'] = CLASSES[data['class']]

    def process_gear_data(self,data):
        self.worst_gem = []
        self.legendaries_equipped = []
        self.missing_enchants = []
        self.enchanted_items = []
        self.ilvl = 0.0

        for item in ITEMS:
            try:
                self.worst_gem.append(str(GEMS[data['items'][item]['tooltipParams']['gem0']]))
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
                    self.tier_data[item] = int(data['items'][item]['itemLevel'])

                self.ilvl += data['items'][item]['itemLevel']
                self.processed_data[item + '_ilvl'] = data['items'][item]['itemLevel']
                self.processed_data[item + '_id'] = data['items'][item]['id']
                self.processed_data[item + '_name'] = data['items'][item]['name']
                self.processed_data[item + '_quality'] = data['items'][item]['quality']

                if data['items'][item]['itemLevel'] >= 800 and data['items'][item]['quality'] == 5:
                    self.legendaries_equipped.append('{0}_{1}'.format(data['items'][item]['id'],data['items'][item]['name']))

            except KeyError:
                self.processed_data[item + '_ilvl'] = ''
                self.processed_data[item + '_id'] = ''
                self.processed_data[item + '_name'] = ''
                self.processed_data[item + '_quality'] = ''

    def process_artifact_data(self,data):
        try:
            self.ilvl += data['items']['mainHand']['itemLevel']
            self.ilvl += data['items']['mainHand']['itemLevel']
            self.processed_data['artifact_ilvl'] = data['items']['mainHand']['itemLevel']

            total_traits = 0
            if data['items']['mainHand']['artifactTraits']: weapon = 'mainHand'
            else:
                try:
                    if data['items']['offHand']['artifactTraits']: weapon = 'offHand'
                    else: weapon = False
                except: weapon = False

            if weapon:
                self.spec_name, self.spec_id = ARTIFACTS[data['items'][weapon]['name']]

                for trait in data['items'][weapon]['artifactTraits']:
                    total_traits += int(trait['rank'])

                total_traits -= len(data['items'][weapon]['relics'])
                self.processed_data['equipped_traits'] = total_traits

                for relic in [1,2,3]:
                    try:
                        self.processed_data.update(
                            'relic{0}_ilvl'.format(relic): RELIC_ILVL[data['items'][weapon]['bonusLists'][relic]-1472],
                            'relic{0}_id'.format(relic): data['items'][weapon]['relics'][relic - 1]['itemId'],
                            'relic{0}_name'.format(relic): '',
                            'relic{0}_quality'.format(relic): '')
                    except:
                        self.processed_data.update(
                            'relic{0}_ilvl'.format(relic):'',
                            'relic{0}_id'.format(relic):'',
                            'relic{0}_name'.format(relic): '',
                            'relic{0}_quality'.format(relic): '')

            else: raise KeyError

        except KeyError:
            self.spec_name = 'Unknown'
            self.spec_id = 1
            self.processed_data['equipped_traits'] = 0
            self.processed_data['artifact_ilvl'] = 0
            for relic in [1,2,3]:
                self.processed_data.update(
                    'relic{0}_ilvl'.format(relic):'',
                    'relic{0}_id'.format(relic):'',
                    'relic{0}_name'.format(relic): '',
                    'relic{0}_quality'.format(relic): '')

    def check(self,data,realm,region):
        self.processed_data = {}
        spec_information = []

        self.process_basic_data(data)
        self.process_gear_data(data)
        self.process_artifact_data(data)

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
            ROLES[self.role][CLASSES[data['class']]]
            role = self.role
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

        if not self.dungeon_snapshot == 'not there':
            row_data.append(dungeon_count-self.dungeon_snapshot)
        else: row_data.append(0)

        try:
            wq_data = data['achievements']['criteria'].index(33094)
            wq_amount = data['achievements']['criteriaQuantity'][wq_data]
        except: wq_amount = 0

        if not self.wq_snapshot == 'not there':
            row_data += [wq_amount,wq_amount-self.wq_snapshot]
        else: row_data += [wq_amount,0]

        flag = False
        for legendary in legendaries_equipped:
            if legendary not in self.legendaries:
                flag = True

        if flag:
            all_legendaries = set(legendaries_equipped + self.legendaries)
            execute_query('UPDATE users SET legendaries = \'{0}\' WHERE user_id = \'{1}\''.format('|'.join(all_legendaries).replace("'","\\'"),self.user_id))
            row_data.append(len(all_legendaries))

        else:
            row_data.append(len(self.legendaries))
            all_legendaries = self.legendaries

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
        row_data += [self.tier_data['head'],self.tier_data['shoulder'],self.tier_data['back'], \
                     self.tier_data['chest'],self.tier_data['hands'],self.tier_data['legs']]

        try:
            ap_data = data['achievements']['criteria'].index(30103)
            ap_amount = data['achievements']['criteriaQuantity'][ap_data]
        except: ap_amount = 0

        if not self.ap_snapshot == 'not there':
            row_data += [ap_amount,ap_amount-self.ap_snapshot]
        else: row_data += [ap_amount,0]

        #Spec data
        spec_output = []
        for spec in [1,2,3,4]:
            if spec == spec_id:
                spec_information += [total_traits,average_ilvl_equipped]
                spec_output.append('{0}_{1}'.format(total_traits,average_ilvl_equipped))
                self.specs[spec] = (total_traits,average_ilvl_equipped)
            else:
                spec_information += [self.specs[spec][0],self.specs[spec][1]]
                spec_output.append('{0}_{1}'.format(self.specs[spec][0],self.specs[spec][1]))

        spec_output.append(str(max(float(self.max_ilvl),float(average_ilvl_equipped))))

        #Find main spec
        max_spec = [0,0]
        for spec in [1,2,3,4]:
            if spec in ROLES[role][CLASSES[data['class']]]:
                if int(self.specs[spec][0]) >= int(max_spec[1]):
                    max_spec = [spec,int(self.specs[spec][0])]

        row_data += spec_information
        row_data.append(spec_name)
        row_data.append(max(float(self.max_ilvl),float(average_ilvl_equipped)))
        row_data.append(max_spec[0])
        row_data.append(0) #Cathedral of Eternal Night Dungeon

        #Snapshot dungeon and WQ data
        if (region == 'EU' and datetime.datetime.weekday(datetime.datetime.now()) == 2 and datetime.datetime.now().hour == 7) or \
           (region == 'US' and datetime.datetime.weekday(datetime.datetime.now()) == 1 and datetime.datetime.now().hour == 13):
            snapshot_data = (self.user_id,{'dungeons':dungeon_count,'wqs':wq_amount,'ap':ap_amount})
        elif self.dungeon_snapshot == 'not there' or self.wq_snapshot == 'not there' or self.ap_snapshot == 'not there':
            snapshot_data = (self.user_id,{'dungeons':dungeon_count if self.dungeon_snapshot == 'not there' else self.dungeon_snapshot, \
            'wqs':wq_amount if self.wq_snapshot == 'not there' else self.wq_snapshot, \
            'ap':ap_amount if self.ap_snapshot == 'not there' else self.ap_snapshot})
        else: snapshot_data = False

        #Store updated spec data
        spec_data = [self.user_id,'|'.join(spec_output),self.tier_data]

        return [row_data,spec_data,snapshot_data]

