FIRST_PERIOD_OF_EXPANSION = 974
CURRENT_SEASON = 13

SEASON_DATA = {
  13 => {
    first_period: 974,
    pvp_season: 38,
    keystone_dungeons: [
      { id: 503, name: "Ara-Kara, City of Echoes" },
      { id: 502, name: "City of Threads" },
      { id: 501, name: "The Stonevault" },
      { id: 505, name: "The Dawnbreaker" },
      { id: 507, name: "Grim Batol" },
      { id: 376, name: "The Necrotic Wake" },
      { id: 375, name: "Mists of Tirna Scithe" },
      { id: 353, name: "Siege of Boralus" },
    ],
    vault_ilvl: {
      raid: {
        mythic: 623,
        heroic: 610,
        normal: 597,
        raid_finder: 584,
      },
      dungeon: {
        10 => 623,
        9 => 619,
        8 => 619,
        7 => 616,
        6 => 613,
        5 => 613,
        4 => 610,
        3 => 610,
        2 => 606,
        0 => nil,
      },
      delve: {
        11 => 616,
        10 => 616,
        9 => 616,
        8 => 616,
        7 => 610,
        6 => 606,
        5 => 603,
        4 => 587,
        3 => 587,
        2 => 584,
        1 => 584,
      }
    }
  }
}

EXPANSION_DUNGEONS = [
  { mythic_id: 0, heroic_id: 20486, name: "Ara-Kara, City of Echoes" },
  { mythic_id: 0, heroic_id: 40653, name: "Cinderbrew Meadery" },
  { mythic_id: 0, heroic_id: 40709, name: "City of Threads" },
  { mythic_id: 0, heroic_id: 20483, name: "Darkflame Cleft" },
  { mythic_id: 0, heroic_id: 40658, name: "Priory of the Sacred Flame" },
  { mythic_id: 0, heroic_id: 40714, name: "The Dawnbreaker" },
  { mythic_id: 0, heroic_id: 40717, name: "The Rookery" },
  { mythic_id: 0, heroic_id: 40721, name: "The Stonevault" },
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

GREAT_VAULT_BLACKLISTED_PERIODS = [932, 974, 975]

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
]

VALID_RAIDS = {
  live: [
    {"name"=>"Nerub-ar Palace", "days"=>[0, 1, 2, 3, 4, 5, 6], "id"=>nil, "encounters"=>[{"id"=>nil, "name"=>"Ulgrax", "raid_ids"=>{"raid_finder"=>[], "normal"=>[], "heroic"=>[], "mythic"=>[]}}, {"id"=>nil, "name"=>"The Bloodbound Horror", "raid_ids"=>{"raid_finder"=>[], "normal"=>[], "heroic"=>[], "mythic"=>[]}}, {"id"=>nil, "name"=>"Sikran", "raid_ids"=>{"raid_finder"=>[], "normal"=>[], "heroic"=>[], "mythic"=>[]}}, {"id"=>nil, "name"=>"Rasha'nan", "raid_ids"=>{"raid_finder"=>[], "normal"=>[], "heroic"=>[], "mythic"=>[]}}, {"id"=>nil, "name"=>"Broodtwister Ovi'nax", "raid_ids"=>{"raid_finder"=>[], "normal"=>[], "heroic"=>[], "mythic"=>[]}}, {"id"=>nil, "name"=>"Nexus-Princess Ky'veza", "raid_ids"=>{"raid_finder"=>[], "normal"=>[], "heroic"=>[], "mythic"=>[]}}, {"id"=>nil, "name"=>"The Silken Court", "raid_ids"=>{"raid_finder"=>[], "normal"=>[], "heroic"=>[], "mythic"=>[]}}, {"id"=>nil, "name"=>"Queen Ansurek", "raid_ids"=>{"raid_finder"=>[], "normal"=>[], "heroic"=>[], "mythic"=>[]}}]},
  ],
  classic_era: [
  ],
  classic_progression: [
    {"name"=>"Blackwing Descent", "days"=>[0, 1, 2, 3, 4, 5, 6], "id"=>nil, "encounters"=>[{"id"=>nil, "name"=>"Omnotron Defense System", "raid_ids"=>{"normal"=>[5557], "heroic"=>[5558]}}, {"id"=>nil, "name"=>"Magmaw", "raid_ids"=>{"normal"=>[5555], "heroic"=>[5556]}}, {"id"=>nil, "name"=>"Atramedes", "raid_ids"=>{"normal"=>[5561], "heroic"=>[5562]}}, {"id"=>nil, "name"=>"Chimaeron", "raid_ids"=>{"normal"=>[5564], "heroic"=>[5563]}}, {"id"=>nil, "name"=>"Maloriak", "raid_ids"=>{"normal"=>[5559], "heroic"=>[5560]}}, {"id"=>nil, "name"=>"Nefarian's End", "raid_ids"=>{"normal"=>[5565], "heroic"=>[5566]}}]},
    {"name"=>"The Bastion of Twilight", "days"=>[0, 1, 2, 3, 4, 5, 6], "id"=>nil, "encounters"=>[{"id"=>nil, "name"=>"Halfus Wyrmbreaker", "raid_ids"=>{"normal"=>[5554], "heroic"=>[5553]}}, {"id"=>nil, "name"=>"Theralion and Valiona", "raid_ids"=>{"normal"=>[5567], "heroic"=>[5568]}}, {"id"=>nil, "name"=>"Ascendant Council", "raid_ids"=>{"normal"=>[5569], "heroic"=>[5570]}}, {"id"=>nil, "name"=>"Cho'gall", "raid_ids"=>{"normal"=>[5572], "heroic"=>[5571]}}, {"id"=>nil, "name"=>"Sinestra", "raid_ids"=>{"heroic"=>[5573]}}]},
    {"name"=>"Throne of the Four Winds", "days"=>[0, 1, 2, 3, 4, 5, 6], "id"=>nil, "encounters"=>[{"id"=>nil, "name"=>"The Conclave of Wind", "raid_ids"=>{"normal"=>[5575], "heroic"=>[5574]}}, {"id"=>nil, "name"=>"Al'Akir", "raid_ids"=>{"normal"=>[5576], "heroic"=>[5577]}}]},
  ],
}

WCL_IDS = {
  live: VALID_RAIDS[:live].map{ |raid| raid["encounters"].map{ |encounter| encounter["id"].to_s } }.flatten,
  classic_era: VALID_RAIDS[:classic_era].map{ |raid| raid["encounters"].map{ |encounter| encounter["id"].to_s } }.flatten,
  classic_progression: VALID_RAIDS[:classic_progression].map{ |raid| raid["encounters"].map{ |encounter| encounter["id"].to_s } }.flatten,
}
