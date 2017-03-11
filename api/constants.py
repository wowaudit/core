# -*- coding: utf-8 -*-

# Use one of these modes as the first parameter in calling the script (defaults to the first mode in the constant list)
# Debug mode: has limited exception handling in order to debug errors, does not write to database so does not impact production
#             Avoid using the debug mode on production server as to not overwrite production csv files
# Production mode: regular mode used in production
MODES = ["debug","production","production_patreon","warcraftlogs","snapshot_US","snapshot_EU"]

CURRENT_VERSION = "2"
CYCLE_MINIMUM = 120 #seconds
MAXIMUM_RUNTIME = 3500 #seconds
MAX_ALLOCATED = 25 #guilds
TIER_IDS = range(138309,138381) #Tier 19
REPUTATIONS = {1859:'nightfallen',1948:'valarjar',1894:'wardens',1883:'dreamweavers',1828:'highmountain_tribe',1900:'court_of_farondis'}
CLASSES = {1:'Warrior',2:'Paladin',3:'Hunter',4:'Rogue',5:'Priest',6:'Death Knight',7:'Shaman',8:'Mage',9:'Warlock',10:'Monk',11:'Druid',12:'Demon Hunter'}
ITEMS = ['head','neck','shoulder','back','chest','wrist','hands','waist','legs','feet','finger1','finger2','trinket1','trinket2']
STANDINGS = {0:'Hated',1:'Hostile',2:'Unfriendly',3:'Neutral',4:'Friendly',5:'Honored',6:'Revered',7:'Exalted'}
REP_AMOUNT = {0:36000,1:3000,2:3000,3:3000,4:6000,5:12000,6:21000,7:999}
MYTHIC_DUNGEONS = {10880:'Eye of Azshara',10883:'Darkheart Thicket',10886:'Neltharion\'s Lair',10889:'Halls of Valor',10892:'Violet Hold',10895:'Violet Hold', \
                   10898:'Vault of the Wardens',10901:'Black Rook Hold',10904:'Maw of Souls',10907:'Arcway',10910:'Court of Stars',11406:'Karazhan'}
URL = "https://{0}.api.battle.net/wow/character/{1}/{2}?fields=items,reputation,audit,statistics,achievements,pets&apikey={3}"
WCL_URL = "https://www.warcraftlogs.com:443/v1/parses/character/{0}/{1}/{2}?zone={3}&metric={4}&api_key={5}"
WCL_ZONES_URL = "https://www.warcraftlogs.com:443/v1/zones?api_key={0}"
VALID_RAIDS = {'Emerald Nightmare':{'id':10,'raid_order':1, u'encounters': [{u'id': 1853, u'name': u'Nythendra','order': 1}, {u'id': 1873, u'name': u"Il'gynoth, Heart of Corruption",'order': 5}, {u'id': 1876, u'name': u'Elerethe Renferal','order': 2},
                {u'id': 1841, u'name': u'Ursoc','order': 3}, {u'id': 1854, u'name': u'Dragons of Nightmare','order': 4}, {u'id': 1877, u'name': u'Cenarius','order': 6}, {u'id': 1864, u'name': u'Xavius','order': 7}]},
               'Trial of Valor':{'id':12,'raid_order':2, u'encounters': [{u'id': 1958, u'name': u'Odyn','order': 1}, {u'id': 1962, u'name': u'Guarm','order': 2}, {u'id': 2008, u'name': u'Helya','order': 3}]},
               'The Nighthold':{'id':11,'raid_order':3, u'encounters': [{u'id': 1849, u'name': u'Skorpyron','order': 1}, {u'id': 1865, u'name': u'Chronomatic Anomaly','order': 2}, {u'id': 1867, u'name': u'Trilliax','order': 3},
                {u'id': 1871, u'name': u'Spellblade Aluriel','order': 4}, {u'id': 1862, u'name': u'Tichondrius','order': 5}, {u'id': 1863, u'name': u'Star Augur Etraeus','order': 6}, {u'id': 1842, u'name': u'Krosus','order': 7},
                {u'id': 1886, u'name': u"High Botanist Tel'arn",'order': 8}, {u'id': 1872, u'name': u'Grand Magistrix Elisande','order': 9}, {u'id': 1866, u'name': u"Gul'dan",'order': 10}]}}
RAID_DIFFICULTIES = {3:'Normal',4:'Heroic',5:'Mythic'}
WCL_ROLES_TO_SPEC_MAP = {'Heal':['Restoration','Holy','Discipline','Mistweaver'],
                         'Tank':['Blood','Vengeance','Protection','Brewmaster','Guardian'],
                         'Melee':['Outlaw','Subtlety','Assassination','Feral','Windwalker','Havoc','Enhancement','Survival','Arms','Fury','Retribution','Unholy','Frost'],
                         'Ranged':['Shadow','Affliction','Demonology','Destruction','Arcane','Fire','Frost','Balance','Marksmanship','BeastMastery','Elemental']}
HEADER = ['name','class','rank','ilvl','equipped_traits','artifact_ilvl','head_ilvl','head_id','head_name','head_quality','neck_ilvl','neck_id','neck_name','neck_quality', \
         'shoulder_ilvl','shoulder_id','shoulder_name','shoulder_quality','back_ilvl','back_id','back_name','back_quality','chest_ilvl','chest_id','chest_name','chest_quality', \
         'wrist_ilvl','wrist_id','wrist_name','wrist_quality','hands_ilvl','hands_id','hands_name','hands_quality','waist_ilvl','waist_id','waist_name','waist_quality', \
         'legs_ilvl','legs_id','legs_name','legs_quality','feet_ilvl','feet_id','feet_name','feet_quality','finger1_ilvl','finger1_id','finger1_name','finger1_quality','finger2_ilvl', \
         'finger2_id','finger2_name','finger2_quality','trinket1_ilvl','trinket1_id','trinket1_name','trinket1_quality','trinket2_ilvl','trinket2_id','trinket2_name','trinket2_quality', \
         'relic1_ilvl','relic1_id','relic1_name','relic1_quality','relic2_ilvl','relic2_id','relic2_name','relic2_quality','relic3_ilvl','relic3_id','relic3_name','relic3_quality', \
         'nightfallen_standing','nightfallen_value','valarjar_standing','valarjar_value','wardens_standing','wardens_value','dreamweavers_standing','dreamweavers_value',\
         'highmountain_tribe_standing','highmountain_tribe_value','court_of_farondis_standing','court_of_farondis_value','enchant_quality_neck','enchant_quality_back','enchant_quality_finger1',\
         'enchant_quality_finger2','empty_sockets','reputation_ranking','role','dungeons_done_total','Eye of Azshara','Darkheart Thicket','Neltharion\'s Lair','Halls of Valor','Violet Hold', \
         'Vault of the Wardens','Black Rook Hold','Maw of Souls','Arcway','Court of Stars','Karazhan','dungeons_this_week','wqs_done_total','wqs_this_week','legendary_amount', \
         'achievement_points','mounts','exalted_amount','unique_pets','lvl_25_pets','realm','legendary_list','neck_enchant','back_enchant','finger1_enchant','finger2_enchant','gem_list', \
         'tier_head','tier_shoulder','tier_back','tier_chest','tier_hands','tier_legs','ap_obtained_total','ap_this_week','spec1_traits','spec1_ilvl',\
         'spec2_traits','spec2_ilvl','spec3_traits','spec3_ilvl','spec4_traits','spec4_ilvl','current_spec_name','highest_ilvl_ever_equipped','main_spec','Cathedral of Eternal Night', \
         'WCL_id','WCL_Normal_best','WCL_Normal_median','WCL_Normal_average','WCL_Heroic_best','WCL_Heroic_median','WCL_Heroic_average','WCL_Mythic_best','WCL_Mythic_median','WCL_Mythic_average','user_id']
RELIC_ILVL = {2:690,3:695,4:700,5:705,7:710,8:715,9:720,10:725,12:730,13:735,14:740,15:745,17:750,18:755,19:760,21:765, \
               22:770,23:775,24:780,26:785,27:790,28:795,29:800,31:805,32:810,33:815,35:820,36:825,37:830,39:835,40:840,42:845,43:850,45:855,46:860,48:865,49:870,51:875, \
               52:880,53:885,55:890,56:895,58:900,59:905,61:910,62:915,64:920,65:925}
ENCHANTS = {'finger1':{5423:(1,"+150 Crit"),5424:(1,"+150 Haste"),5425:(1,"+150 Mastery"),5426:(1,"+150 Versatility"),5427:(2,"+200 Crit"),5428:(2,"+200 Haste"),5429:(2,"+200 Mastery"), \
             5430:(2,"+200 Versatility")},'finger2':{5423:(1,"+150 Crit"),5424:(1,"+150 Haste"),5425:(1,"+150 Mastery"),5426:(1,"+150 Versatility"),5427:(2,"+200 Crit"),5428:(2,"+200 Haste"),5429:(2,"+200 Mastery"), \
             5430:(2,"+200 Versatility")},'back':{5431:(1,"+150 Strength"),5432:(1,"+150 Agility"),5433:(1,"+150 Intellect"),5434:(2,"+200 Strength"),5435:(2,"+200 Agility"), \
             5436:(2,"+200 Intellect")},'neck':{5437:(2,"Mark of the Claw"),5438:(2,"Mark of the Distant Army"),5439:(2,"Mark of the Hidden Satyr"), \
             5889:(2,"Mark of the Heavy Hide"),5890:(2,"Mark of the Trained Soldier"),5891:(2,"Mark of the Ancient Priestess")}}
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

TIME_ZONE = 'Europe/Amsterdam'
