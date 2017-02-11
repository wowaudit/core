# -*- coding: utf-8 -*-

# Use one of these modes as the first parameter in calling the script (defaults to the first mode in the constant list)
# Debug mode: has limited exception handling in order to debug errors, does not write to database so does not impact production
#             Avoid using the debug mode on production server as to not overwrite production csv files
# Production mode: regular mode used in production
MODES = ["debug","production"]

CURRENT_VERSION = "1.0"
CYCLE_MINIMUM = 60 #seconds
MAXIMUM_RUNTIME = 1700 #seconds
PATH_TO_CSV = 'csv/'
TIER_IDS = range(138309,138381) #Tier 19
REP_ORDERED = ['nightfallen','valarjar','wardens','dreamweavers','highmountain tribe','court of farondis']
REPUTATIONS = {1859:'nightfallen',1948:'valarjar',1894:'wardens',1883:'dreamweavers',1828:'highmountain tribe',1900:'court of farondis'}
CLASSES = {1:'Warrior',2:'Paladin',3:'Hunter',4:'Rogue',5:'Priest',6:'Death Knight',7:'Shaman',8:'Mage',9:'Warlock',10:'Monk',11:'Druid',12:'Demon Hunter'}
ITEMS = ['head','neck','shoulder','back','chest','wrist','hands','waist','legs','feet','finger1','finger2','trinket1','trinket2']
STANDINGS = {0:'Hated',1:'Hostile',2:'Unfriendly',3:'Neutral',4:'Friendly',5:'Honored',6:'Revered',7:'Exalted'}
REP_AMOUNT = {0:36000,1:3000,2:3000,3:3000,4:6000,5:12000,6:21000,7:999}
MYTHIC_DUNGEONS = {10880:'Eye of Azshara',10883:'Darkheart Thicket',10886:'Neltharion\'s Lair',10889:'Halls of Valor',10892:'Violet Hold',10895:'Violet Hold', \
                   10898:'Vault of the Wardens',10901:'Black Rook Hold',10904:'Maw of Souls',10907:'Arcway',10910:'Court of Stars',11406:'Karazhan'}
URL = "https://{0}.api.battle.net/wow/character/{1}/{2}?fields=items,reputation,audit,statistics,achievements,pets&apikey={3}".encode('utf-8')
HEADER = ['head_ilvl','head_id','head_icon','head_q','neck_ilvl','neck_id','neck_icon','neck_q', \
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
