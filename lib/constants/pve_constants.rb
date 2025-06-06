FIRST_PERIOD_OF_EXPANSION = 974
CURRENT_SEASON = 14

SEASON_DATA = {
  13 => {
    first_period: 974,
    pvp_season: 38,
    spark_label: "Omen Crafted",
    keystone_dungeons: [
      { id: 503, name: "Ara-Kara, City of Echoes", mythic_id: 20487, legacy: false },
      { id: 502, name: "City of Threads", mythic_id: 40710, legacy: false },
      { id: 501, name: "The Stonevault", mythic_id: 40722, legacy: false },
      { id: 505, name: "The Dawnbreaker", mythic_id: 40715, legacy: false },
      { id: 507, name: "Grim Batol", mythic_id: 0, legacy: true },
      { id: 376, name: "The Necrotic Wake", mythic_id: 14404, legacy: true },
      { id: 375, name: "Mists of Tirna Scithe", mythic_id: 14395, legacy: true },
      { id: 353, name: "Siege of Boralus", mythic_id: 12773, legacy: true },
    ],
    crests: [
      { name: 'Gilded', ilvl_cap: 639, weekly_increase: 90, first_period: 975, icon_item_id: 220789 },
      { name: 'Runed', ilvl_cap: 619, weekly_increase: 90, first_period: 975, icon_item_id: 220790 },
      { name: 'Carved', ilvl_cap: 606, weekly_increase: 90, first_period: 972, icon_item_id: 221373 },
      { name: 'Weathered', ilvl_cap: 593, weekly_increase: 90, first_period: 972, icon_item_id: 220788 },
    ],
    track_cutoffs: [
      { ilvl: 623, track: 'Myth' },
      { ilvl: 610, track: 'Hero' },
      { ilvl: 597, track: 'Champion' },
      { ilvl: 584, track: 'Veteran' },
      { ilvl: 571, track: 'Adventurer' },
      { ilvl: 558, track: 'Explorer' }
    ],
    great_vault: {
      raid: {
        mythic: { ilvl: 623, track: 'Myth' },
        heroic: { ilvl: 610, track: 'Hero' },
        normal: { ilvl: 597, track: 'Champion' },
        raid_finder: { ilvl: 584, track: 'Veteran' },
      },
      dungeon: {
        10 => { ilvl: 623, track: 'Myth' },
        9 => { ilvl: 619, track: 'Hero' },
        8 => { ilvl: 619, track: 'Hero' },
        7 => { ilvl: 616, track: 'Hero' },
        6 => { ilvl: 613, track: 'Hero' },
        5 => { ilvl: 613, track: 'Hero' },
        4 => { ilvl: 610, track: 'Hero' },
        3 => { ilvl: 610, track: 'Hero' },
        2 => { ilvl: 606, track: 'Champion' },
        1 => { ilvl: 603, track: 'Champion' }, # Regular Mythic
        0 => { ilvl: 593, track: 'Veteran' }, # Heroic
        -1 => { ilvl: nil, track: nil },
      },
      delve: {
        11 => { ilvl: 616, track: 'Hero' },
        10 => { ilvl: 616, track: 'Hero' },
        9 => { ilvl: 616, track: 'Hero' },
        8 => { ilvl: 616, track: 'Hero' },
        7 => { ilvl: 610, track: 'Hero' },
        6 => { ilvl: 606, track: 'Champion' },
        5 => { ilvl: 603, track: 'Champion' },
        4 => { ilvl: 587, track: 'Champion' },
        3 => { ilvl: 587, track: 'Veteran' },
        2 => { ilvl: 584, track: 'Veteran' },
        1 => { ilvl: 584, track: 'Veteran' },
      }
    }
  },
  14 => {
    first_period: 1001,
    pvp_season: 39,
    spark_label: "Fortune Crafted",
    keystone_dungeons: [
      { id: 525, name: "Operation: Floodgate", mythic_id: 41344, legacy: false },
      { id: 506, name: "Cinderbrew Meadery", mythic_id: 40654, legacy: false },
      { id: 500, name: "The Rookery", mythic_id: 40718, legacy: false },
      { id: 504, name: "Darkflame Cleft", mythic_id: 20484, legacy: false },
      { id: 499, name: "Priory of the Sacred Flame", mythic_id: 40659, legacy: false },
      { id: 247, name: "The MOTHERLODE!!", mythic_id: 12779, legacy: true },
      { id: 370, name: "Operation: Mechagon - Workshop", mythic_id: 13620, legacy: true },
      { id: 382, name: "Theater of Pain", mythic_id: 14407, legacy: true },
    ],
    crests: [
      { name: 'Gilded', ilvl_cap: 678, weekly_increase: 90, first_period: 1001, icon_item_id: 231264 },
      { name: 'Runed', ilvl_cap: 658, weekly_increase: 90, first_period: 1001, icon_item_id: 231270 },
      { name: 'Carved', ilvl_cap: 645, weekly_increase: 90, first_period: 1001, icon_item_id: 231153 },
      { name: 'Weathered', ilvl_cap: 632, weekly_increase: 90, first_period: 1000, icon_item_id: 231267 },
    ],
    track_cutoffs: [
      { ilvl: 662, track: 'Myth' },
      { ilvl: 649, track: 'Hero' },
      { ilvl: 636, track: 'Champion' },
      { ilvl: 623, track: 'Veteran' },
      { ilvl: 610, track: 'Adventurer' },
      { ilvl: 597, track: 'Explorer' }
    ],
    great_vault: {
      raid: {
        mythic: { ilvl: 662, track: 'Myth' },
        heroic: { ilvl: 649, track: 'Hero' },
        normal: { ilvl: 636, track: 'Champion' },
        raid_finder: { ilvl: 623, track: 'Veteran' },
      },
      dungeon: {
        10 => { ilvl: 662, track: 'Myth' },
        9 => { ilvl: 658, track: 'Hero' },
        8 => { ilvl: 658, track: 'Hero' },
        7 => { ilvl: 658, track: 'Hero' },
        6 => { ilvl: 655, track: 'Hero' },
        5 => { ilvl: 652, track: 'Hero' },
        4 => { ilvl: 652, track: 'Hero' },
        3 => { ilvl: 649, track: 'Hero' },
        2 => { ilvl: 649, track: 'Champion' },
        1 => { ilvl: 646, track: 'Champion' }, # Regular Mythic
        0 => { ilvl: 623, track: 'Veteran' }, # Heroic
        -1 => { ilvl: nil, track: nil },
      },
      delve: {
        11 => { ilvl: 649, track: 'Hero' },
        10 => { ilvl: 649, track: 'Hero' },
        9 => { ilvl: 649, track: 'Hero' },
        8 => { ilvl: 649, track: 'Hero' },
        7 => { ilvl: 645, track: 'Champion' },
        6 => { ilvl: 645, track: 'Champion' },
        5 => { ilvl: 642, track: 'Champion' },
        4 => { ilvl: 636, track: 'Champion' },
        3 => { ilvl: 626, track: 'Veteran' },
        2 => { ilvl: 623, track: 'Veteran' },
        1 => { ilvl: 623, track: 'Veteran' },
      }
    }
  }
}

EXPANSION_DUNGEONS = [
  { heroic_id: 20486, name: "Ara-Kara, City of Echoes" },
  { heroic_id: 40653, name: "Cinderbrew Meadery" },
  { heroic_id: 40709, name: "City of Threads" },
  { heroic_id: 20483, name: "Darkflame Cleft" },
  { heroic_id: 40658, name: "Priory of the Sacred Flame" },
  { heroic_id: 40714, name: "The Dawnbreaker" },
  { heroic_id: 40717, name: "The Rookery" },
  { heroic_id: 40721, name: "The Stonevault" },
  { heroic_id: 41343, name: "Operation: Floodgate" },
]

WEEKLY_EVENT_QUESTS = [
  83347, # Emissary of War
  83345, # A Call to Battle
  83364, # A Savage Path Through Time
  83362, # A Shrouded Path Through Time
  83366, # The World Awaits
  83359, # A Shattered Path Through Time
  83365, # A Frozen Path Through Time
]

# https://www.wowhead.com/quest=82449/the-call-of-the-worldsoul
WORLDSOUL_WEEKLY_QUESTS = [82449, 82458, 82482, 82516, 82483, 82453, 82489, 82659, 82678, 82679, 82490, 82491, 82492, 82493, 82494, 82496, 82497, 82498, 82499, 82500, 82501, 82502, 82503, 82504, 82505, 82506, 82507, 82508, 82509, 82510, 82512, 82488, 82487, 82486, 82485, 82452, 82495, 82706, 82707, 82709, 82711, 82712, 82746]

RAID_DIFFICULTIES = {
  1 => 'raid_finder',
  3 => 'normal',
  4 => 'heroic',
  5 => 'mythic'
}

GREAT_VAULT_RAID_KILLS_NEEDED = {
  1 => 2,
  2 => 4,
  3 => 6,
}

GREAT_VAULT_BLACKLISTED_PERIODS = [932, 974, 975, 1000]

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
  40254, # Queen Ansurek
  41297, # Chrome King Gallywix
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
  40253, # Queen Ansurek
  41298, # Chrome King Gallywix
]

VALID_RAIDS = {
  live: [
    {"name"=>"Nerub-ar Palace", "days"=>[], "id"=>38, "encounters"=>[{"id"=>2902, "name"=>"Ulgrax", "raid_ids"=>{"raid_finder"=>[40267], "normal"=>[40268], "heroic"=>[40269], "mythic"=>[40270]}}, {"id"=>2917, "name"=>"The Bloodbound Horror", "raid_ids"=>{"raid_finder"=>[40271], "normal"=>[40272], "heroic"=>[40273], "mythic"=>[40274]}}, {"id"=>2898, "name"=>"Sikran", "raid_ids"=>{"raid_finder"=>[40275], "normal"=>[40276], "heroic"=>[40277], "mythic"=>[40278]}}, {"id"=>2918, "name"=>"Rasha'nan", "raid_ids"=>{"raid_finder"=>[40279], "normal"=>[40280], "heroic"=>[40281], "mythic"=>[40282]}}, {"id"=>2919, "name"=>"Broodtwister Ovi'nax", "raid_ids"=>{"raid_finder"=>[40283], "normal"=>[40284], "heroic"=>[40285], "mythic"=>[40286]}}, {"id"=>2920, "name"=>"Nexus-Princess Ky'veza", "raid_ids"=>{"raid_finder"=>[40287], "normal"=>[40288], "heroic"=>[40289], "mythic"=>[40290]}}, {"id"=>2921, "name"=>"The Silken Court", "raid_ids"=>{"raid_finder"=>[40291], "normal"=>[40292], "heroic"=>[40293], "mythic"=>[40294]}}, {"id"=>2922, "name"=>"Queen Ansurek", "raid_ids"=>{"raid_finder"=>[40295], "normal"=>[40296], "heroic"=>[40297], "mythic"=>[40298]}}]},
    {"name"=>"Liberation of Undermine", "days"=>[0, 1, 2, 3, 4, 5, 6], "id"=>42, "encounters"=>[{"id"=>3009, "name"=>"Vexie and the Geargrinders", "raid_ids"=>{"raid_finder"=>[41299], "normal"=>[41300], "heroic"=>[41301], "mythic"=>[41302]}}, {"id"=>3010, "name"=>"Cauldron of Carnage", "raid_ids"=>{"raid_finder"=>[41303], "normal"=>[41304], "heroic"=>[41305], "mythic"=>[41306]}}, {"id"=>3011, "name"=>"Rik Reverb", "raid_ids"=>{"raid_finder"=>[41307], "normal"=>[41308], "heroic"=>[41309], "mythic"=>[41310]}}, {"id"=>3012, "name"=>"Stix Bunkjunker", "raid_ids"=>{"raid_finder"=>[41311], "normal"=>[41312], "heroic"=>[41313], "mythic"=>[41314]}}, {"id"=>3013, "name"=>"Sprocketmonger Lockenstock", "raid_ids"=>{"raid_finder"=>[41315], "normal"=>[41316], "heroic"=>[41317], "mythic"=>[41318]}}, {"id"=>3014, "name"=>"The One-Armed Bandit", "raid_ids"=>{"raid_finder"=>[41319], "normal"=>[41320], "heroic"=>[41321], "mythic"=>[41322]}}, {"id"=>3015, "name"=>"Mug'Zee, Heads of Security", "raid_ids"=>{"raid_finder"=>[41323], "normal"=>[41324], "heroic"=>[41325], "mythic"=>[41326]}}, {"id"=>3016, "name"=>"Chrome King Gallywix", "raid_ids"=>{"raid_finder"=>[41327], "normal"=>[41328], "heroic"=>[41329], "mythic"=>[41330]}}]}
  ],
  classic_era: [
  ],
  classic_progression: [
    {"name"=>"Blackwing Descent", "days"=>[], "id"=>nil, "encounters"=>[{"id"=>nil, "name"=>"Omnotron Defense System", "raid_ids"=>{"normal"=>[5557], "heroic"=>[5558]}}, {"id"=>nil, "name"=>"Magmaw", "raid_ids"=>{"normal"=>[5555], "heroic"=>[5556]}}, {"id"=>nil, "name"=>"Atramedes", "raid_ids"=>{"normal"=>[5561], "heroic"=>[5562]}}, {"id"=>nil, "name"=>"Chimaeron", "raid_ids"=>{"normal"=>[5564], "heroic"=>[5563]}}, {"id"=>nil, "name"=>"Maloriak", "raid_ids"=>{"normal"=>[5559], "heroic"=>[5560]}}, {"id"=>nil, "name"=>"Nefarian's End", "raid_ids"=>{"normal"=>[5565], "heroic"=>[5566]}}]},
    {"name"=>"The Bastion of Twilight", "days"=>[], "id"=>nil, "encounters"=>[{"id"=>nil, "name"=>"Halfus Wyrmbreaker", "raid_ids"=>{"normal"=>[5554], "heroic"=>[5553]}}, {"id"=>nil, "name"=>"Theralion and Valiona", "raid_ids"=>{"normal"=>[5567], "heroic"=>[5568]}}, {"id"=>nil, "name"=>"Ascendant Council", "raid_ids"=>{"normal"=>[5569], "heroic"=>[5570]}}, {"id"=>nil, "name"=>"Cho'gall", "raid_ids"=>{"normal"=>[5572], "heroic"=>[5571]}}, {"id"=>nil, "name"=>"Sinestra", "raid_ids"=>{"heroic"=>[5573]}}]},
    {"name"=>"Throne of the Four Winds", "days"=>[], "id"=>nil, "encounters"=>[{"id"=>nil, "name"=>"The Conclave of Wind", "raid_ids"=>{"normal"=>[5575], "heroic"=>[5574]}}, {"id"=>nil, "name"=>"Al'Akir", "raid_ids"=>{"normal"=>[5576], "heroic"=>[5577]}}]},
    {"name"=>"Firelands", "days"=>[], "id"=>nil, "encounters"=>[{"id"=>nil, "name"=>"Beth'tilac", "raid_ids"=>{"normal"=>[5964], "heroic"=>[5965]}}, {"id"=>nil, "name"=>"Lord Rhyolith", "raid_ids"=>{"normal"=>[5966], "heroic"=>[5967]}}, {"id"=>nil, "name"=>"Alysrazor", "raid_ids"=>{"normal"=>[5970], "heroic"=>[5971]}}, {"id"=>nil, "name"=>"Shannox", "raid_ids"=>{"normal"=>[5968], "heroic"=>[5969]}}, {"id"=>nil, "name"=>"Baleroc, the Gatekeeper", "raid_ids"=>{"normal"=>[5972], "heroic"=>[5973]}}, {"id"=>nil, "name"=>"Majordomo Staghelm", "raid_ids"=>{"normal"=>[5974], "heroic"=>[5975]}}, {"id"=>nil, "name"=>"Ragnaros", "raid_ids"=>{"normal"=>[5976], "heroic"=>[5977]}}]},
    {"name"=>"Dragon Soul", "days"=>[0, 1, 2, 3, 4, 5, 6], "id"=>nil, "encounters"=>[{"id"=>nil, "name"=>"Morchok", "raid_ids"=>{"normal"=>[6153], "heroic"=>[6154]}}, {"id"=>nil, "name"=>"Warlord Zon'ozz", "raid_ids"=>{"normal"=>[6155], "heroic"=>[6156]}}, {"id"=>nil, "name"=>"Yor'sahj the Unsleeping", "raid_ids"=>{"normal"=>[6157], "heroic"=>[6158]}}, {"id"=>nil, "name"=>"Hagara the Stormbinder", "raid_ids"=>{"normal"=>[6159], "heroic"=>[6160]}}, {"id"=>nil, "name"=>"Ultraxion", "raid_ids"=>{"normal"=>[6161], "heroic"=>[6162]}}, {"id"=>nil, "name"=>"Warmaster Blackhorn", "raid_ids"=>{"normal"=>[6163], "heroic"=>[6164]}}, {"id"=>nil, "name"=>"Spine of Deathwing", "raid_ids"=>{"normal"=>[6165], "heroic"=>[6166]}}, {"id"=>nil, "name"=>"Madness of Deathwing", "raid_ids"=>{"normal"=>[], "heroic"=>[]}}]}
  ],
}

WCL_IDS = {
  live: VALID_RAIDS[:live].map{ |raid| raid["encounters"].map{ |encounter| encounter["id"].to_s } }.flatten,
  classic_era: VALID_RAIDS[:classic_era].map{ |raid| raid["encounters"].map{ |encounter| encounter["id"].to_s } }.flatten,
  classic_progression: VALID_RAIDS[:classic_progression].map{ |raid| raid["encounters"].map{ |encounter| encounter["id"].to_s } }.flatten,
}
