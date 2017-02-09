# -*- coding: utf-8 -*-
from json import loads, dumps
import datetime, time, sys
from dateutil import tz
from execute_query import execute_query
from concurrent import futures
import requests
#import urllib2
from writer import UnicodeWriter

CURRENT_VERSION = "1.0"
CYCLE_MINIMUM = 60 #seconds
MAXIMUM_RUNTIME = 1700 #seconds
PATH_TO_CSV = 'csv_files/media/'
TIER_IDS = range(138309,138381) #Tier 19
REP_ORDERED = ['nightfallen','valarjar','wardens','dreamweavers','highmountain tribe','court of farondis']
REPUTATIONS = {1859:'nightfallen',1948:'valarjar',1894:'wardens',1883:'dreamweavers',1828:'highmountain tribe',1900:'court of farondis'}
CLASSES = {1:'Warrior',2:'Paladin',3:'Hunter',4:'Rogue',5:'Priest',6:'Death Knight',7:'Shaman',8:'Mage',9:'Warlock',10:'Monk',11:'Druid',12:'Demon Hunter'}
ITEMS = ['head','neck','shoulder','back','chest','wrist','hands','waist','legs','feet','finger1','finger2','trinket1','trinket2']
STANDINGS = {0:'Hated',1:'Hostile',2:'Unfriendly',3:'Neutral',4:'Friendly',5:'Honored',6:'Revered',7:'Exalted'}
REP_AMOUNT = {0:36000,1:3000,2:3000,3:3000,4:6000,5:12000,6:21000,7:999}
MYTHIC_DUNGEONS = {10880:'Eye of Azshara',10883:'Darkheart Thicket',10886:'Neltharion\'s Lair',10889:'Halls of Valor',10892:'Violet Hold',10895:'Violet Hold', \
                   10898:'Vault of the Wardens',10901:'Black Rook Hold',10904:'Maw of Souls',10907:'Arcway',10910:'Court of Stars',11406:'Karazhan'}
URL = "https://{0}.api.battle.net/wow/character/{1}/{2}?fields=items,reputation,audit,statistics,achievements,pets&apikey=xg7qvw9t36rdvwh8u67smuu5v8rbrvge".encode('utf-8')
header = ['head_ilvl','head_id','head_icon','head_q','neck_ilvl','neck_id','neck_icon','neck_q', \
         'shoulder_ilvl','shoulder_id','shoulder_icon','shoulder_q','cloak_ilvl','cloak_id','cloak_icon','cloak_q','chest_ilvl','chest_id','chest_icon','chest_q', \
         'wrist_ilvl','wrist_id','wrist_icon','wrist_q','gloves_ilvl','gloves_id','gloves_icon','gloves_q','waist_ilvl','waist_id','waist_icon','waist_q', \
         'legs_ilvl','legs_id','legs_icon','legs_q','boots_ilvl','boots_id','boots_icon','boots_q','ring1_ilvl','ring1_id','ring1_icon','ring1_q','ring2_ilvl', \
         'ring2_id','ring2_icon','ring2_q','trinket1_ilvl','trinket1_id','trinket1_icon','trinket1_q','trinket2_ilvl','trinket2_id','trinket2_icon','trinket2_q', \
         'relic1_ilvl','relic1_id','relic1_icon','relic1_q','relic2_ilvl','relic2_id','relic2_icon','relic2_q','relic3_ilvl','relic3_id','relic3_icon','relic3_q', \
         'nightfallen_standing','nightfallen_value','valarjar_standing','valarjar_value','wardens_standing','wardens_value','dreamweavers_standing','dreamweavers_value',\
         'highmountain-tribe_standing','highmountain-tribe_value','court-of-farondis_standing','court-of-farondis_value','enchant_q_neck','enchant_q_cloak','enchant_q_ring1',\
         'enchant_q_ring2','missing_sockets','rep_value','role','dungeon_total','eye_of_azshara','darkheart_thicket','neltharions_lair','halls_of_valor','violet_hold', \
         'vault of the wardens','black rook hold','maw of souls','arcway','court of stars','karazhan','this_week','wq_alltime','wq_this_week','legendary_amount', \
         'achievements','mounts','exalted_reps','pets','pets_lvl25','realm','legendary_list','neck_enchant','cloak_enchant','ring1_enchant','ring2_enchant','gem_list', \
         'tier_helm_ilvl','tier_shoulder_ilvl','tier_cloak_ilvl','tier_chest_ilvl','tier_gloves_ilvl','tier_legs_ilvl','total_ap','weekly_ap','spec1_traits','spec1_ilvl',\
         'spec2_traits','spec2_ilvl','spec3_traits','spec3_ilvl','spec4_traits','spec4_ilvl','current_spec','ilvl_eq_record','main_spec','cathedral_of_eternal_night']
RELIC_ILVL = {2:690,3:695,4:700,5:705,7:710,8:715,9:720,10:725,12:730,13:735,14:740,15:745,17:750,18:755,19:760,21:765, \
               22:770,23:775,24:780,26:785,27:790,28:795,29:800,31:805,32:810,33:815,35:820,36:825,37:830,39:835,40:840,42:845,43:850,45:855,46:860,48:865,49:870,51:875, \
               52:880,53:885,55:890,56:895,58:900,59:905,61:910,62:915,64:920,65:925}
ENCHANTS = {'finger1':{5423:(1,"+150 Crit"),5424:(1,"+150 Haste"),5425:(1,"+150 Mastery"),5426:(1,"+150 Versatility"),5427:(2,"+200 Crit"),5428:(2,"+200 Haste"),5429:(2,"+200 Mastery"), \
             5430:(2,"+200 Versatility")},'finger2':{5423:(1,"+150 Crit"),5424:(1,"+150 Haste"),5425:(1,"+150 Mastery"),5426:(1,"+150 Versatility"),5427:(2,"+200 Crit"),5428:(2,"+200 Haste"),5429:(2,"+200 Mastery"), \
             5430:(2,"+200 Versatility")},'back':{5431:(1,"+150 Strength"),5432:(1,"+150 Agility"),5433:(1,"+150 Intellect"),5434:(2,"+200 Strength"),5435:(2,"+200 Agility"), \
             5436:(2,"+200 Intellect")},'neck':{5437:(2,"Mark of the Claw"),5438:(2,"Mark of the Distant Army"),5439:(2,"Mark of the Hidden Satyr"), \
             5889:(2,"Mark of the Heavy Hide"),5890:(2,"Mark of the Heavy Soldier"),5891:(2,"Mark of the Ancient Priestess")}}
GEMS = {130218:1,130217:1,130216:1,130215:1,130219:2,130220:2,130221:2,130222:2,130246:3,130247:3,130248:3} #1 = 100, 2 = 150, 3 = epic unique

ARTIFACTS = {'Ulthalesh, the Deadwind Harvester':('Affliction',1),'Scepter of Sargeras':('Destruction',2),"Skull of the Man'ari":('Demonology',3), \
             "Light's Wrath":('Discipline',1),"T'uure, Beacon of the Naaru":('Holy',2),"Xal'atath, Blade of the Black Empire":('Shadow',3), \
             "Doomhammer":('Enhancement',1),"The Fist of Ra-den":('Elemental',2),"Sharas'dal, Scepter of Tides":('Restoration',3), \
             "Maw of the Damned":('Blood',1),"Blades of the Fallen Prince":('Frost',2),"Apocalypse":('Unholy',3), \
             "Twinblades of the Deceiver":('Havoc',1),"Aldrachi Warblades":('Vengeance',2),"Scythe of Elune":('Balance',4), \
             "Fangs of Ashamane":('Feral',1),"Claws of Ursoc":('Guardian',2),"G'Hanir, the Mother Tree":('Restoration',3), \
             "Titanstrike":('Beast Mastery',1),"Thas'dorah, Legacy of the Windrunners":('Marksmanship',2),"Talonclaw":('Survival',3), \
             "Aluneth":('Arcane',1),"Felo'melorn":('Fire',2),"Ebonchill":('Frost',3), \
             "Fu Zan, the Wanderer's Companion":('Brewmaster',1),"Sheilun, Staff of the Mists":('Mistweaver',2),"Fists of the Heavens":('Windwalker',3), \
             "The Silver Hand":('Holy',1),"Truthguard":('Protection',2),"Ashbringer":('Retribution',3), \
             "The Kingslayers":('Assassination',1),"The Dreadblades":('Outlaw',2),"Fangs of the Devourer":('Subtlety',3), \
             "Warswords of the Valarjar":('Fury',1),"Strom'kar, the Warbreaker":('Arms',2),"Scale of the Earth-Warder":('Protection',3)}

ROLES = {'Tank':{'Death Knight':[1],'Monk':[1],'Paladin':[2],'Warrior':[3],'Druid':[2],'Demon Hunter':[2]},\
         'Heal':{'Paladin':[1],'Monk':[2],'Priest':[1,2],'Druid':[3],'Shaman':[3]},\
         'Ranged':{'Mage':[1,2,3],'Warlock':[1,2,3],'Priest':[3],'Druid':[4],'Shaman':[2],'Hunter':[1,2]},\
         'Melee':{'Rogue':[1,2,3],'Demon Hunter':[1],'Monk':[3],'Druid':[1],'Shaman':[1],'Hunter':[3],'Death Knight':[2,3],'Paladin':[3],'Warrior':[1,2]}}
DEFAULT_ROLES = {'Death Knight':'Melee','Monk':'Melee','Paladin':'Melee','Warrior':'Melee','Druid':'Melee', \
                 'Demon Hunter':'Melee','Priest':'Ranged','Warlock':'Ranged','Mage':'Ranged','Rogue':'Melee', \
                 'Shaman':'Ranged','Hunter':'Ranged'}
START_TIME = time.time()

try:
    DEBUG_MODE = str(sys.argv[1])
    MAXIMUM_RUNTIME = 7200
    print 'Running in debug mode.'
except Exception:
    DEBUG_MODE = False

try:
    GUILD_IDS = str(sys.argv[2]).split(',')
    print 'Going to cycle through the following guild IDs: {0}'.format(','.join(GUILD_IDS))
except Exception:
    GUILD_IDS = False


class Guilds(object):

    def __init__(self):
        self.guilds = []
        self.done = {}
        data = execute_query('SELECT guilds.guild_id, guilds.name, guilds.region, guilds.realm, guilds.key_code, guilds.last_checked, users.user_id, users.name, users.role, users.weekly_snapshot ' + \
                             ', users.legendaries, users.realm, users.per_spec, users.tier_data, users.status FROM guilds, users WHERE guilds.guild_id = users.guild_id ORDER BY guilds.last_checked ASC')
        count = 0
        for member in data:
            key_code = member[4]

            if key_code not in self.done:
                self.guilds.append(Guild(member))
                self.done[key_code] = count
                count += 1
            else: self.guilds[self.done[key_code]].add_member(member)

    def check_all(self):
        count = 0
        for guild in self.guilds:
            count += 1
            if time.time() - START_TIME >= MAXIMUM_RUNTIME: return False
            if DEBUG_MODE == False:
                try:
                    guild.check()
                    print 'Finished checking guild with ID {0}. Progress in this cycle: {1}/{2}'.format(guild.guild_id,count,len(self.guilds))
                except:
                    print 'Encountered an error when checking guild with ID {0}. Progress in this cycle: {1}/{2}'.format(guild.guild_id,count,len(self.guilds))

            else:
                if GUILD_IDS:
                    if str(guild.guild_id) in GUILD_IDS:
                        guild.check()
                        print 'Finished checking guild with ID {0}. Progress in this cycle: {1}/{2}'.format(guild.guild_id,count,len(self.guilds))
                else:
                    guild.check()
                    print 'Finished checking guild with ID {0}. Progress in this cycle: {1}/{2}'.format(guild.guild_id,count,len(self.guilds))
        return True

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
        response = requests.get(URL.format(self.region,realm,self.members[user].name).replace(" ","%20"))
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

class Member(object):

    def __init__(self,data):
        self.user_id, self.name, self.role, self.snapshot, self.legendary_snapshot, self.realm, self.spec_data, self.tier_data, self.status = data[6:]
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
            if self.spec_data.split('|')[:-1]:
                for spec in self.spec_data.split('|')[:-1]:
                    traits, max_ilvl = spec.split('_')
                    self.specs[count] = (traits,max_ilvl)
                    count += 1
                self.max_ilvl = self.spec_data.split('|')[-1]
            else:
                self.specs = {1:(0,0),2:(0,0),3:(0,0),4:(0,0)}
                self.max_ilvl = 0

        except:
            self.specs = {1:(0,0),2:(0,0),3:(0,0),4:(0,0)}
            self.max_ilvl = 0

keep_going = True
while keep_going:
    step_time = time.time()
    guilds = Guilds()
    keep_going = guilds.check_all()
    if time.time() - step_time < CYCLE_MINIMUM and keep_going:
        sleep_duration = 3 + CYCLE_MINIMUM - (time.time() - step_time)

        if (time.time() + sleep_duration) - START_TIME < MAXIMUM_RUNTIME:
            print 'Completed a full cycle faster than the minimum set time. Going to sleep for {0} seconds.'.format(round(sleep_duration,1))
            time.sleep(sleep_duration)
        else: keep_going = False
    if DEBUG_MODE == 'debug':
        keep_going = True

print 'Reached the maximum runtime. Aborting now.'
