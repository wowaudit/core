FIRST_PERIOD_OF_EXPANSION = 885

CURRENT_KEYSTONE_SEASON = 11
FIRST_PERIOD_OF_SEASON = 933

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
  168 => "The Everbloom", #"Freehold", #"Halls of Valor",
  198 => "Darkheart Thicket", #"Neltharus", #"The Azure Vault",
  199 => "Black Rook Hold", #"Brackenhide Hollow", #"Ruby Life Pools",
  244 => "Atal'Dazar", #"Uldaman: Legacy of Tyr", #"Algeth'ar Academy",
  248 => "Waycrest Manor", #"The Underrot", #"Court of Stars",
  456 => "Throne of the Tides", #"Halls of Infusion", #"The Nokhud Offensive",
  463 => "Galakrond's Fall", #"Neltharion's Lair", #"Shadowmoon Burial Grounds",
  464 => "Murozond's Rise", #"The Vortex Pinnacle", #"Temple of the Jade Serpent",
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
    mythic: 480,
    heroic: 467,
    normal: 454,
    raid_finder: 441,
  },
  'dungeon' => {
    20 => 483,
    19 => 480,
    18 => 480,
    17 => 476,
    16 => 476,
    15 => 476,
    14 => 473,
    13 => 473,
    12 => 473,
    11 => 470,
    10 => 470,
    9 => 467,
    8 => 467,
    7 => 463,
    6 => 463,
    5 => 460,
    4 => 460,
    3 => 457,
    2 => 454,
    0 => nil,
  },
  'pvp' => { # Estimates
    2400 => 483,
    2100 => 480,
    1950 => 476,
    1800 => 473,
    1600 => 470,
    1400 => 467,
    1200 => 463,
    1000 => 460,
    0 => 454,
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
    {"name"=>"Vault of the Incarnates", "days"=>[], "id"=>31, "encounters"=>[{"id"=>2587, "name"=>"Eranog", "raid_ids"=>{"raid_finder"=>[16359], "normal"=>[16371], "heroic"=>[16379], "mythic"=>[16387]}}, {"id"=>2639, "name"=>"Terros", "raid_ids"=>{"raid_finder"=>[16361], "normal"=>[16372], "heroic"=>[16380], "mythic"=>[16388]}}, {"id"=>2590, "name"=>"The Primal Council", "raid_ids"=>{"raid_finder"=>[16362], "normal"=>[16373], "heroic"=>[16381], "mythic"=>[16389]}}, {"id"=>2592, "name"=>"Sennarth, the Cold Breath", "raid_ids"=>{"raid_finder"=>[16366], "normal"=>[16374], "heroic"=>[16382], "mythic"=>[16390]}}, {"id"=>2635, "name"=>"Dathea, Ascended", "raid_ids"=>{"raid_finder"=>[16367], "normal"=>[16375], "heroic"=>[16383], "mythic"=>[16391]}}, {"id"=>2605, "name"=>"Kurog Grimtotem", "raid_ids"=>{"raid_finder"=>[16368], "normal"=>[16376], "heroic"=>[16384], "mythic"=>[16392]}}, {"id"=>2614, "name"=>"Broodkeeper Diurna", "raid_ids"=>{"raid_finder"=>[16369], "normal"=>[16377], "heroic"=>[16385], "mythic"=>[16393]}}, {"id"=>2607, "name"=>"Raszageth the Storm-Eater", "raid_ids"=>{"raid_finder"=>[16370], "normal"=>[16378], "heroic"=>[16386], "mythic"=>[16394]}}]},
    {"name"=>"Aberrus, the Shadowed Crucible", "days"=>[], "id"=>33, "encounters"=>[{"id"=>2688, "name"=>"Kazzara, the Hellforged", "raid_ids"=>{"raid_finder"=>[18180], "normal"=>[18189], "heroic"=>[18210], "mythic"=>[18219]}}, {"id"=>2687, "name"=>"The Amalgamation Chamber", "raid_ids"=>{"raid_finder"=>[18181], "normal"=>[18190], "heroic"=>[18211], "mythic"=>[18220]}}, {"id"=>2693, "name"=>"The Forgotten Experiments", "raid_ids"=>{"raid_finder"=>[18182], "normal"=>[18191], "heroic"=>[18212], "mythic"=>[18221]}}, {"id"=>2682, "name"=>"Assault of the Zaqali", "raid_ids"=>{"raid_finder"=>[18183], "normal"=>[18192], "heroic"=>[18213], "mythic"=>[18222]}}, {"id"=>2680, "name"=>"Rashok, the Elder", "raid_ids"=>{"raid_finder"=>[18184], "normal"=>[18194], "heroic"=>[18214], "mythic"=>[18223]}}, {"id"=>2689, "name"=>"Zskarn, the Vigilant Steward", "raid_ids"=>{"raid_finder"=>[18185], "normal"=>[18195], "heroic"=>[18215], "mythic"=>[18224]}}, {"id"=>2683, "name"=>"Magmorax", "raid_ids"=>{"raid_finder"=>[18186], "normal"=>[18196], "heroic"=>[18216], "mythic"=>[18225]}}, {"id"=>2684, "name"=>"Echo of Neltharion", "raid_ids"=>{"raid_finder"=>[18188], "normal"=>[18197], "heroic"=>[18217], "mythic"=>[18226]}}, {"id"=>2685, "name"=>"Scalecommander Sarkareth", "raid_ids"=>{"raid_finder"=>[18187], "normal"=>[18198], "heroic"=>[18218], "mythic"=>[18227]}}]},
    {"name"=>"Amirdrassil, the Dream's Hope", "days"=>[0, 1, 2, 3, 4, 5, 6], "id"=>35, "encounters"=>[{"id"=>2820, "name"=>"Gnarlroot", "raid_ids"=>{"raid_finder"=>[19348], "normal"=>[19360], "heroic"=>[19369], "mythic"=>[19378]}}, {"id"=>2709, "name"=>"Igira the Cruel", "raid_ids"=>{"raid_finder"=>[19352], "normal"=>[19361], "heroic"=>[19370], "mythic"=>[19379]}}, {"id"=>2737, "name"=>"Volcoross", "raid_ids"=>{"raid_finder"=>[19353], "normal"=>[19362], "heroic"=>[19371], "mythic"=>[19380]}}, {"id"=>2728, "name"=>"Council of Dreams", "raid_ids"=>{"raid_finder"=>[19354], "normal"=>[19363], "heroic"=>[19372], "mythic"=>[19381]}}, {"id"=>2731, "name"=>"Larodar", "raid_ids"=>{"raid_finder"=>[19355], "normal"=>[19364], "heroic"=>[19373], "mythic"=>[19382]}}, {"id"=>2708, "name"=>"Nymue", "raid_ids"=>{"raid_finder"=>[19356], "normal"=>[19365], "heroic"=>[19374], "mythic"=>[19383]}}, {"id"=>2824, "name"=>"Smolderon", "raid_ids"=>{"raid_finder"=>[19357], "normal"=>[19366], "heroic"=>[19375], "mythic"=>[19384]}}, {"id"=>2786, "name"=>"Tindral Sageswift", "raid_ids"=>{"raid_finder"=>[19358], "normal"=>[19367], "heroic"=>[19376], "mythic"=>[19385]}}, {"id"=>2677, "name"=>"Fyrakk", "raid_ids"=>{"raid_finder"=>[19359], "normal"=>[19368], "heroic"=>[19377], "mythic"=>[19386]}}]}
  ],
  classic_era: [
  ],
  classic_progression: [
  ],
}

WCL_IDS = {
  live: VALID_RAIDS[:live].map{ |raid| raid["encounters"].map{ |encounter| encounter["id"].to_s } }.flatten,
  classic_era: VALID_RAIDS[:classic_era].map{ |raid| raid["encounters"].map{ |encounter| encounter["id"].to_s } }.flatten,
  classic_progression: VALID_RAIDS[:classic_progression].map{ |raid| raid["encounters"].map{ |encounter| encounter["id"].to_s } }.flatten,
}
