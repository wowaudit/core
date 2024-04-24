FIRST_PERIOD_OF_EXPANSION = 885

CURRENT_KEYSTONE_SEASON = 12
FIRST_PERIOD_OF_SEASON = 956

MYTHIC_DUNGEONS = {
  16076 => "Brackenhide Hollow",
  16079 => "Halls of Infusion",
  16082 => "Neltharus",
  16085 => "Ruby Life Pools",
  16088 => "Algeth'ar Academy",
  16091 => "The Azure Vault",
  16094 => "The Nokhud Offensive",
  16097 => "Uldaman: Legacy of Tyr",
}

KEYSTONE_DUNGEONS = {
  399 => "Ruby Life Pools",
  400 => "The Nokhud Offensive",
  401 => "The Azure Vault",
  402 => "Algeth'ar Academy",
  403 => "Uldaman: Legacy of Tyr",
  404 => "Neltharus",
  405 => "Brackenhide Hollow",
  406 => "Halls of Infusion",
}

SLUGIFIED_DUNGEON_NAMES = KEYSTONE_DUNGEONS.transform_values do |dungeon_name|
  dungeon_name.gsub("'", "").gsub(":", "").gsub(" -", "").gsub(" ", "_").downcase
end

WEEKLY_EVENT_QUESTS = [
  72719, # A Fel Path Through Time
  72720, # The Arena Calls
  72722, # Emissary of War
  72723, # A Calll to Battle
  72724, # A Savage Path Through Time
  72725, # A Shrouded Path Through Time
  72727, # A Burning Path Through Time
  72728, # The World Awaits
  72810, # A Shattered Path Through Time
]

RAID_DIFFICULTIES = {
  1 => 'raid_finder',
  3 => 'normal',
  4 => 'heroic',
  5 => 'mythic'
}

GREAT_VAULT_RAID_KILLS_NEEDED = {
  1 => 2,
  2 => 4,
  3 => 7,
}

GREAT_VAULT_BLACKLISTED_PERIODS = [932]

GREAT_VAULT_TO_ILVL = {
  'raid' => {
    mythic: 519,
    heroic: 506,
    normal: 493,
    raid_finder: 480,
  },
  'dungeon' => {
    10 => 522,
    9 => 519,
    8 => 519,
    7 => 515,
    6 => 515,
    5 => 512,
    4 => 512,
    3 => 509,
    2 => 509,
    0 => nil, # 506
  },
  'pvp' => { # Estimates
    2400 => 522,
    2100 => 519,
    1950 => 515,
    1800 => 512,
    1600 => 509,
    1400 => 509,
    1200 => 506,
    1000 => 506,
    0 => 506,
  }
}

CUTTING_EDGE_ACHIEVEMENTS = [
  7485, # Will of the Emperor
  7486, # Grand Empress Shek'zeer
  7487, # Sha of Fear
  8238, # Lei Shen
  8260, # Ra-den
  8400, # Garrosh Hellscream (10 player)
  8401, # Garrosh Hellscream (25 player)
  9442, # Imperator Mar'gok
  9443, # Blackhand's Crucible
  10045, # Archimonde
  11191, # Xavius
  11580, # Helya
  11192, # Gul'dan
  11875, # Kil'jaeden
  12111, # Argus the Unmaker
  12535, # G'huun
  13323, # Lady Jaina Proudmoore
  13419, # Uu'nat, Harbinger of the Void
  13785, # Queen Azshara
  14069, # N'zoth the Corruptor
  14461, # Sire Denathrius
  15135, # Sylvanas Windrunner
  15471, # The Jailer
  17108, # Raszageth the Storm-Eater
  18254, # Scalecommander Sarkareth
  19351, # Fyrakk the Blazing
]

AHEAD_OF_THE_CURVE_ACHIEVEMENTS = [
  6954, # Will of the Emperor
  8246, # Grand Empress Shek'zeer
  8248, # Sha of Fear
  8249, # Lei Shen
  8260, # Ra-den (count if Cutting Edge is obtained)
  8398, # Garrosh Hellscream (10 player)
  8399, # Garrosh Hellscream (25 player)
  9441, # Imperator Mar'gok
  9444, # Blackhand's Crucible
  10044, # Archimonde
  11194, # Xavius
  11581, # Helya
  11195, # Gul'dan
  11874, # Kil'jaeden
  12110, # Argus the Unmaker
  12536, # G'huun
  13322, # Lady Jaina Proudmoore
  13418, # Uu'nat, Harbinger of the Void
  13784, # Queen Azshara
  14068, # N'zoth the Corruptor
  14460, # Sire Denathrius
  15134, # Sylvanas Windrunner
  15470, # The Jailer
  17107, # Raszageth the Storm-Eater
  18253, # Scalecommander Sarkareth
  19350, # Fyrakk the Blazing
]

VALID_RAIDS = {
  live: [
    {"name"=>"Vault of the Incarnates", "days"=>[0, 1, 2, 3, 4, 5, 6], "id"=>31, "encounters"=>[{"id"=>2587, "name"=>"Eranog", "raid_ids"=>{"raid_finder"=>[16359], "normal"=>[16371], "heroic"=>[16379], "mythic"=>[16387]}}, {"id"=>2639, "name"=>"Terros", "raid_ids"=>{"raid_finder"=>[16361], "normal"=>[16372], "heroic"=>[16380], "mythic"=>[16388]}}, {"id"=>2590, "name"=>"The Primal Council", "raid_ids"=>{"raid_finder"=>[16362], "normal"=>[16373], "heroic"=>[16381], "mythic"=>[16389]}}, {"id"=>2592, "name"=>"Sennarth, the Cold Breath", "raid_ids"=>{"raid_finder"=>[16366], "normal"=>[16374], "heroic"=>[16382], "mythic"=>[16390]}}, {"id"=>2635, "name"=>"Dathea, Ascended", "raid_ids"=>{"raid_finder"=>[16367], "normal"=>[16375], "heroic"=>[16383], "mythic"=>[16391]}}, {"id"=>2605, "name"=>"Kurog Grimtotem", "raid_ids"=>{"raid_finder"=>[16368], "normal"=>[16376], "heroic"=>[16384], "mythic"=>[16392]}}, {"id"=>2614, "name"=>"Broodkeeper Diurna", "raid_ids"=>{"raid_finder"=>[16369], "normal"=>[16377], "heroic"=>[16385], "mythic"=>[16393]}}, {"id"=>2607, "name"=>"Raszageth the Storm-Eater", "raid_ids"=>{"raid_finder"=>[16370], "normal"=>[16378], "heroic"=>[16386], "mythic"=>[16394]}}]},
    {"name"=>"Aberrus, the Shadowed Crucible", "days"=>[0, 1, 2, 3, 4, 5, 6], "id"=>33, "encounters"=>[{"id"=>2688, "name"=>"Kazzara, the Hellforged", "raid_ids"=>{"raid_finder"=>[18180], "normal"=>[18189], "heroic"=>[18210], "mythic"=>[18219]}}, {"id"=>2687, "name"=>"The Amalgamation Chamber", "raid_ids"=>{"raid_finder"=>[18181], "normal"=>[18190], "heroic"=>[18211], "mythic"=>[18220]}}, {"id"=>2693, "name"=>"The Forgotten Experiments", "raid_ids"=>{"raid_finder"=>[18182], "normal"=>[18191], "heroic"=>[18212], "mythic"=>[18221]}}, {"id"=>2682, "name"=>"Assault of the Zaqali", "raid_ids"=>{"raid_finder"=>[18183], "normal"=>[18192], "heroic"=>[18213], "mythic"=>[18222]}}, {"id"=>2680, "name"=>"Rashok, the Elder", "raid_ids"=>{"raid_finder"=>[18184], "normal"=>[18194], "heroic"=>[18214], "mythic"=>[18223]}}, {"id"=>2689, "name"=>"Zskarn, the Vigilant Steward", "raid_ids"=>{"raid_finder"=>[18185], "normal"=>[18195], "heroic"=>[18215], "mythic"=>[18224]}}, {"id"=>2683, "name"=>"Magmorax", "raid_ids"=>{"raid_finder"=>[18186], "normal"=>[18196], "heroic"=>[18216], "mythic"=>[18225]}}, {"id"=>2684, "name"=>"Echo of Neltharion", "raid_ids"=>{"raid_finder"=>[18188], "normal"=>[18197], "heroic"=>[18217], "mythic"=>[18226]}}, {"id"=>2685, "name"=>"Scalecommander Sarkareth", "raid_ids"=>{"raid_finder"=>[18187], "normal"=>[18198], "heroic"=>[18218], "mythic"=>[18227]}}]},
    {"name"=>"Amirdrassil, the Dream's Hope", "days"=>[0, 1, 2, 3, 4, 5, 6], "id"=>35, "encounters"=>[{"id"=>2820, "name"=>"Gnarlroot", "raid_ids"=>{"raid_finder"=>[19348], "normal"=>[19360], "heroic"=>[19369], "mythic"=>[19378]}}, {"id"=>2709, "name"=>"Igira the Cruel", "raid_ids"=>{"raid_finder"=>[19352], "normal"=>[19361], "heroic"=>[19370], "mythic"=>[19379]}}, {"id"=>2737, "name"=>"Volcoross", "raid_ids"=>{"raid_finder"=>[19353], "normal"=>[19362], "heroic"=>[19371], "mythic"=>[19380]}}, {"id"=>2728, "name"=>"Council of Dreams", "raid_ids"=>{"raid_finder"=>[19354], "normal"=>[19363], "heroic"=>[19372], "mythic"=>[19381]}}, {"id"=>2731, "name"=>"Larodar", "raid_ids"=>{"raid_finder"=>[19355], "normal"=>[19364], "heroic"=>[19373], "mythic"=>[19382]}}, {"id"=>2708, "name"=>"Nymue", "raid_ids"=>{"raid_finder"=>[19356], "normal"=>[19365], "heroic"=>[19374], "mythic"=>[19383]}}, {"id"=>2824, "name"=>"Smolderon", "raid_ids"=>{"raid_finder"=>[19357], "normal"=>[19366], "heroic"=>[19375], "mythic"=>[19384]}}, {"id"=>2786, "name"=>"Tindral Sageswift", "raid_ids"=>{"raid_finder"=>[19358], "normal"=>[19367], "heroic"=>[19376], "mythic"=>[19385]}}, {"id"=>2677, "name"=>"Fyrakk", "raid_ids"=>{"raid_finder"=>[19359], "normal"=>[19368], "heroic"=>[19377], "mythic"=>[19386]}}]}
  ],
  classic_era: [
  ],
  classic_progression: [
    {"name"=>"Naxxramas (10)", "days"=>[], "id"=>nil, "encounters"=>[{"id"=>nil, "name"=>"Anub'Rekhan", "raid_ids"=>{"normal"=>[1361], "heroic"=>[]}}, {"id"=>nil, "name"=>"Grand Widow Faerlina", "raid_ids"=>{"normal"=>[1362], "heroic"=>[]}}, {"id"=>nil, "name"=>"Maexxna", "raid_ids"=>{"normal"=>[1363], "heroic"=>[]}}, {"id"=>nil, "name"=>"Noth the Plaguebringer", "raid_ids"=>{"normal"=>[1365], "heroic"=>[]}}, {"id"=>nil, "name"=>"Heigan the Unclean", "raid_ids"=>{"normal"=>[1369], "heroic"=>[]}}, {"id"=>nil, "name"=>"Loatheb", "raid_ids"=>{"normal"=>[1370], "heroic"=>[]}}, {"id"=>nil, "name"=>"Instructor Razuvious", "raid_ids"=>{"normal"=>[1374], "heroic"=>[]}}, {"id"=>nil, "name"=>"Gothik the Harvester", "raid_ids"=>{"normal"=>[1366], "heroic"=>[]}}, {"id"=>nil, "name"=>"The Four Horsemen", "raid_ids"=>{"normal"=>[1375], "heroic"=>[]}}, {"id"=>nil, "name"=>"Patchwerk", "raid_ids"=>{"normal"=>[1364], "heroic"=>[]}}, {"id"=>nil, "name"=>"Grobbulus", "raid_ids"=>{"normal"=>[1371], "heroic"=>[]}}, {"id"=>nil, "name"=>"Gluth", "raid_ids"=>{"normal"=>[1372], "heroic"=>[]}}, {"id"=>nil, "name"=>"Thaddius", "raid_ids"=>{"normal"=>[1373], "heroic"=>[]}}, {"id"=>nil, "name"=>"Sapphiron", "raid_ids"=>{"normal"=>[1376], "heroic"=>[]}}, {"id"=>nil, "name"=>"Kel'Thuzad", "raid_ids"=>{"normal"=>[1377], "heroic"=>[]}}]},
    {"name"=>"Naxxramas (25)", "days"=>[], "id"=>nil, "encounters"=>[{"id"=>nil, "name"=>"Anub'Rekhan", "raid_ids"=>{"normal"=>[1368], "heroic"=>[]}}, {"id"=>nil, "name"=>"Grand Widow Faerlina", "raid_ids"=>{"normal"=>[1380], "heroic"=>[]}}, {"id"=>nil, "name"=>"Maexxna", "raid_ids"=>{"normal"=>[1386], "heroic"=>[]}}, {"id"=>nil, "name"=>"Noth the Plaguebringer", "raid_ids"=>{"normal"=>[1387], "heroic"=>[]}}, {"id"=>nil, "name"=>"Heigan the Unclean", "raid_ids"=>{"normal"=>[1382], "heroic"=>[]}}, {"id"=>nil, "name"=>"Loatheb", "raid_ids"=>{"normal"=>[1385], "heroic"=>[]}}, {"id"=>nil, "name"=>"Instructor Razuvious", "raid_ids"=>{"normal"=>[1384], "heroic"=>[]}}, {"id"=>nil, "name"=>"Gothik the Harvester", "raid_ids"=>{"normal"=>[1379], "heroic"=>[]}}, {"id"=>nil, "name"=>"The Four Horsemen", "raid_ids"=>{"normal"=>[1383], "heroic"=>[]}}, {"id"=>nil, "name"=>"Patchwerk", "raid_ids"=>{"normal"=>[1367], "heroic"=>[]}}, {"id"=>nil, "name"=>"Grobbulus", "raid_ids"=>{"normal"=>[1381], "heroic"=>[]}}, {"id"=>nil, "name"=>"Gluth", "raid_ids"=>{"normal"=>[1378], "heroic"=>[]}}, {"id"=>nil, "name"=>"Thaddius", "raid_ids"=>{"normal"=>[1388], "heroic"=>[]}}, {"id"=>nil, "name"=>"Sapphiron", "raid_ids"=>{"normal"=>[1389], "heroic"=>[]}}, {"id"=>nil, "name"=>"Kel'Thuzad", "raid_ids"=>{"normal"=>[1390], "heroic"=>[]}}]},
    {"name"=>"Sartharion/Malygos/Onyxia (10)", "days"=>[], "id"=>nil, "encounters"=>[{"id"=>nil, "name"=>"Sartharion", "raid_ids"=>{"normal"=>[1392], "heroic"=>[]}}, {"id"=>nil, "name"=>"Malygos", "raid_ids"=>{"normal"=>[1391], "heroic"=>[]}}, {"id"=>nil, "name"=>"Onyxia", "raid_ids"=>{"normal"=>[1098], "heroic"=>[]}}]},
    {"name"=>"Sartharion/Malygos/Onyxia (25)", "days"=>[], "id"=>nil, "encounters"=>[{"id"=>nil, "name"=>"Sartharion", "raid_ids"=>{"normal"=>[1393], "heroic"=>[]}}, {"id"=>nil, "name"=>"Malygos", "raid_ids"=>{"normal"=>[1394], "heroic"=>[]}}, {"id"=>nil, "name"=>"Onyxia", "raid_ids"=>{"normal"=>[1098], "heroic"=>[]}}]},
    {"name"=>"Vault of Archavon (10)", "days"=>[], "id"=>nil, "encounters"=>[{"id"=>nil, "name"=>"Archavon the Stone Watcher", "raid_ids"=>{"normal"=>[1753], "heroic"=>[]}}, {"id"=>nil, "name"=>"Emalon the Storm Watcher", "raid_ids"=>{"normal"=>[2870], "heroic"=>[]}}, {"id"=>nil, "name"=>"Koralon the Flame Watcher", "raid_ids"=>{"normal"=>[4074], "heroic"=>[]}}, {"id"=>nil, "name"=>"Toravon the Ice Watcher", "raid_ids"=>{"normal"=>[4657], "heroic"=>[]}}]},
    {"name"=>"Vault of Archavon (25)", "days"=>[], "id"=>nil, "encounters"=>[{"id"=>nil, "name"=>"Archavon the Stone Watcher", "raid_ids"=>{"normal"=>[1754], "heroic"=>[]}}, {"id"=>nil, "name"=>"Emalon the Storm Watcher", "raid_ids"=>{"normal"=>[3236], "heroic"=>[]}}, {"id"=>nil, "name"=>"Koralon the Flame Watcher", "raid_ids"=>{"normal"=>[4075], "heroic"=>[]}}, {"id"=>nil, "name"=>"Toravon the Ice Watcher", "raid_ids"=>{"normal"=>[4658], "heroic"=>[]}}]},
    {"name"=>"Ulduar (10)", "days"=>[], "id"=>nil, "encounters"=>[{"id"=>nil, "name"=>"Flame Leviathan", "raid_ids"=>{"normal"=>[2856], "heroic"=>[]}}, {"id"=>nil, "name"=>"Ignis the Furnace Master", "raid_ids"=>{"normal"=>[2858], "heroic"=>[]}}, {"id"=>nil, "name"=>"Razorscale", "raid_ids"=>{"normal"=>[2857], "heroic"=>[]}}, {"id"=>nil, "name"=>"XT-002 Deconstructor", "raid_ids"=>{"normal"=>[2859], "heroic"=>[]}}, {"id"=>nil, "name"=>"The Assembly of Iron", "raid_ids"=>{"normal"=>[2860], "heroic"=>[]}}, {"id"=>nil, "name"=>"Kologarn", "raid_ids"=>{"normal"=>[2861], "heroic"=>[]}}, {"id"=>nil, "name"=>"Auriaya", "raid_ids"=>{"normal"=>[2868], "heroic"=>[]}}, {"id"=>nil, "name"=>"Hodir", "raid_ids"=>{"normal"=>[2862], "heroic"=>[]}}, {"id"=>nil, "name"=>"Thorim", "raid_ids"=>{"normal"=>[2863], "heroic"=>[]}}, {"id"=>nil, "name"=>"Freya", "raid_ids"=>{"normal"=>[2864], "heroic"=>[]}}, {"id"=>nil, "name"=>"Mimiron", "raid_ids"=>{"normal"=>[2865], "heroic"=>[]}}, {"id"=>nil, "name"=>"General Vezax", "raid_ids"=>{"normal"=>[2866], "heroic"=>[]}}, {"id"=>nil, "name"=>"Yogg-Saron", "raid_ids"=>{"normal"=>[2869], "heroic"=>[]}}, {"id"=>nil, "name"=>"Algalon the Observer", "raid_ids"=>{"normal"=>[2867], "heroic"=>[]}}]},
    {"name"=>"Ulduar (25)", "days"=>[], "id"=>nil, "encounters"=>[{"id"=>nil, "name"=>"Flame Leviathan", "raid_ids"=>{"normal"=>[2872], "heroic"=>[]}}, {"id"=>nil, "name"=>"Ignis the Furnace Master", "raid_ids"=>{"normal"=>[2874], "heroic"=>[]}}, {"id"=>nil, "name"=>"Razorscale", "raid_ids"=>{"normal"=>[2873], "heroic"=>[]}}, {"id"=>nil, "name"=>"XT-002 Deconstructor", "raid_ids"=>{"normal"=>[2884], "heroic"=>[]}}, {"id"=>nil, "name"=>"The Assembly of Iron", "raid_ids"=>{"normal"=>[2885], "heroic"=>[]}}, {"id"=>nil, "name"=>"Kologarn", "raid_ids"=>{"normal"=>[2875], "heroic"=>[]}}, {"id"=>nil, "name"=>"Auriaya", "raid_ids"=>{"normal"=>[2882], "heroic"=>[]}}, {"id"=>nil, "name"=>"Hodir", "raid_ids"=>{"normal"=>[3256], "heroic"=>[]}}, {"id"=>nil, "name"=>"Thorim", "raid_ids"=>{"normal"=>[3257], "heroic"=>[]}}, {"id"=>nil, "name"=>"Freya", "raid_ids"=>{"normal"=>[3258], "heroic"=>[]}}, {"id"=>nil, "name"=>"Mimiron", "raid_ids"=>{"normal"=>[2879], "heroic"=>[]}}, {"id"=>nil, "name"=>"General Vezax", "raid_ids"=>{"normal"=>[2880], "heroic"=>[]}}, {"id"=>nil, "name"=>"Yogg-Saron", "raid_ids"=>{"normal"=>[2883], "heroic"=>[]}}, {"id"=>nil, "name"=>"Algalon the Observer", "raid_ids"=>{"normal"=>[2881], "heroic"=>[]}}]},
    {"name"=>"Trial of the Crusader (10)", "days"=>[], "id"=>nil, "encounters"=>[{"id"=>nil, "name"=>"The Northrend Beasts", "raid_ids"=>{"normal"=>[4028], "heroic"=>[4030]}}, {"id"=>nil, "name"=>"Lord Jaraxxus", "raid_ids"=>{"normal"=>[4032], "heroic"=>[4033]}}, {"id"=>nil, "name"=>"Faction Champions", "raid_ids"=>{"normal"=>[4036], "heroic"=>[4037]}}, {"id"=>nil, "name"=>"Twin Val'kyr", "raid_ids"=>{"normal"=>[4040], "heroic"=>[4041]}}, {"id"=>nil, "name"=>"Anub'arak", "raid_ids"=>{"normal"=>[4044], "heroic"=>[4045]}}]},
    {"name"=>"Trial of the Crusader (25)", "days"=>[], "id"=>nil, "encounters"=>[{"id"=>nil, "name"=>"The Northrend Beasts", "raid_ids"=>{"normal"=>[4031], "heroic"=>[4029]}}, {"id"=>nil, "name"=>"Lord Jaraxxus", "raid_ids"=>{"normal"=>[4034], "heroic"=>[4035]}}, {"id"=>nil, "name"=>"Faction Champions", "raid_ids"=>{"normal"=>[4038], "heroic"=>[4039]}}, {"id"=>nil, "name"=>"Twin Val'kyr", "raid_ids"=>{"normal"=>[4042], "heroic"=>[4043]}}, {"id"=>nil, "name"=>"Anub'arak", "raid_ids"=>{"normal"=>[4046], "heroic"=>[4047]}}]},
    {"name"=>"Icecrown Citadel (10)", "days"=>[], "id"=>nil, "encounters"=>[{"id"=>nil, "name"=>"Lord Marrowgar", "raid_ids"=>{"normal"=>[4639], "heroic"=>[4640]}}, {"id"=>nil, "name"=>"Lady Deathwhisper", "raid_ids"=>{"normal"=>[4643], "heroic"=>[4654]}}, {"id"=>nil, "name"=>"Icecrown Gunship Battle", "raid_ids"=>{"normal"=>[4644], "heroic"=>[4659]}}, {"id"=>nil, "name"=>"Deathbringer Saurfang", "raid_ids"=>{"normal"=>[4645], "heroic"=>[4662]}}, {"id"=>nil, "name"=>"Festergut", "raid_ids"=>{"normal"=>[4646], "heroic"=>[4665]}}, {"id"=>nil, "name"=>"Rotface", "raid_ids"=>{"normal"=>[4647], "heroic"=>[4668]}}, {"id"=>nil, "name"=>"Professor Putricide", "raid_ids"=>{"normal"=>[4650], "heroic"=>[4677]}}, {"id"=>nil, "name"=>"Blood Prince Council", "raid_ids"=>{"normal"=>[4648], "heroic"=>[4671]}}, {"id"=>nil, "name"=>"Blood-Queen Lana'thel", "raid_ids"=>{"normal"=>[4651], "heroic"=>[4680]}}, {"id"=>nil, "name"=>"Valithria Dreamwalker", "raid_ids"=>{"normal"=>[4649], "heroic"=>[4674]}}, {"id"=>nil, "name"=>"Sindragosa", "raid_ids"=>{"normal"=>[4652], "heroic"=>[4684]}}, {"id"=>nil, "name"=>"The Lich King", "raid_ids"=>{"normal"=>[4653], "heroic"=>[4686]}}]},
    {"name"=>"Icecrown Citadel (25)", "days"=>[], "id"=>nil, "encounters"=>[{"id"=>nil, "name"=>"Lord Marrowgar", "raid_ids"=>{"normal"=>[4641], "heroic"=>[4642]}}, {"id"=>nil, "name"=>"Lady Deathwhisper", "raid_ids"=>{"normal"=>[4655], "heroic"=>[4656]}}, {"id"=>nil, "name"=>"Icecrown Gunship Battle", "raid_ids"=>{"normal"=>[4660], "heroic"=>[4661]}}, {"id"=>nil, "name"=>"Deathbringer Saurfang", "raid_ids"=>{"normal"=>[4663], "heroic"=>[4664]}}, {"id"=>nil, "name"=>"Festergut", "raid_ids"=>{"normal"=>[4666], "heroic"=>[4667]}}, {"id"=>nil, "name"=>"Rotface", "raid_ids"=>{"normal"=>[4669], "heroic"=>[4670]}}, {"id"=>nil, "name"=>"Professor Putricide", "raid_ids"=>{"normal"=>[4678], "heroic"=>[4679]}}, {"id"=>nil, "name"=>"Blood Prince Council", "raid_ids"=>{"normal"=>[4672], "heroic"=>[4673]}}, {"id"=>nil, "name"=>"Blood-Queen Lana'thel", "raid_ids"=>{"normal"=>[4681], "heroic"=>[4682]}}, {"id"=>nil, "name"=>"Valithria Dreamwalker", "raid_ids"=>{"normal"=>[4675], "heroic"=>[4676]}}, {"id"=>nil, "name"=>"Sindragosa", "raid_ids"=>{"normal"=>[4683], "heroic"=>[4685]}}, {"id"=>nil, "name"=>"The Lich King", "raid_ids"=>{"normal"=>[4687], "heroic"=>[4688]}}]},
  ],
}

WCL_IDS = {
  live: VALID_RAIDS[:live].map{ |raid| raid["encounters"].map{ |encounter| encounter["id"].to_s } }.flatten,
  classic_era: VALID_RAIDS[:classic_era].map{ |raid| raid["encounters"].map{ |encounter| encounter["id"].to_s } }.flatten,
  classic_progression: VALID_RAIDS[:classic_progression].map{ |raid| raid["encounters"].map{ |encounter| encounter["id"].to_s } }.flatten,
}
