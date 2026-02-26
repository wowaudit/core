FIRST_PERIOD_OF_EXPANSION = 1052
CURRENT_SEASON = 16

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
  },
  15 => {
    first_period: 1023,
    pvp_season: 40,
    spark_label: "Starlight Crafted",
    spark_ilvl_bump_bonus_id: [13469, 13468],
    keystone_dungeons: [
      { id: 499, name: "Priory of the Sacred Flame", mythic_id: 40659, legacy: false },
      { id: 503, name: "Ara-Kara, City of Echoes", mythic_id: 20487, legacy: false },
      { id: 505, name: "The Dawnbreaker", mythic_id: 40715, legacy: false },
      { id: 525, name: "Operation: Floodgate", mythic_id: 41344, legacy: false },
      { id: 542, name: "Eco-Dome Al'dani", mythic_id: 42785, legacy: false },
      { id: 378, name: "Halls of Atonement", mythic_id: 14392, legacy: true },
      { id: 391, name: "Tazavesh: Streets of Wonder", mythic_id: 0, legacy: true },
      { id: 392, name: "Tazavesh: So'leah's Gambit", mythic_id: 15168, legacy: true },
    ],
    crests: [
      { name: 'Gilded', ilvl_cap: 170, weekly_increase: 90, first_period: 1023, icon_item_id: 240929 },
      { name: 'Runed', ilvl_cap: 157, weekly_increase: 90, first_period: 1023, icon_item_id: 240930 },
      { name: 'Carved', ilvl_cap: 144, weekly_increase: 90, first_period: 1023, icon_item_id: 240931 },
      { name: 'Weathered', ilvl_cap: 131, weekly_increase: 90, first_period: 1023, icon_item_id: 240928 },
    ],
    track_cutoffs: [
      { ilvl: 147, track: 'Myth', bonus_id: 12053, difficulty: :mythic },
      { ilvl: 134, track: 'Hero', bonus_id: 12052, difficulty: :heroic },
      { ilvl: 121, track: 'Champion', bonus_id: 12051, difficulty: :normal },
      { ilvl: 108, track: 'Veteran' },
      { ilvl: 95, track: 'Adventurer' },
      { ilvl: 82, track: 'Explorer' }
    ],
    great_vault: {
      raid: {
        mythic: { ilvl: 147, track: 'Myth' },
        heroic: { ilvl: 134, track: 'Hero' },
        normal: { ilvl: 121, track: 'Champion' },
        raid_finder: { ilvl: 108, track: 'Veteran' },
      },
      dungeon: {
        10 => { ilvl: 147, track: 'Myth' },
        9 => { ilvl: 144, track: 'Hero' },
        8 => { ilvl: 144, track: 'Hero' },
        7 => { ilvl: 144, track: 'Hero' },
        6 => { ilvl: 141, track: 'Hero' },
        5 => { ilvl: 137, track: 'Hero' },
        4 => { ilvl: 137, track: 'Hero' },
        3 => { ilvl: 134, track: 'Hero' },
        2 => { ilvl: 134, track: 'Hero' },
        1 => { ilvl: 131, track: 'Champion' }, # Regular Mythic
        0 => { ilvl: 118, track: 'Veteran' }, # Heroic
        -1 => { ilvl: nil, track: nil },
      },
      delve: {
        11 => { ilvl: 134, track: 'Hero' },
        10 => { ilvl: 134, track: 'Hero' },
        9 => { ilvl: 134, track: 'Hero' },
        8 => { ilvl: 134, track: 'Hero' },
        7 => { ilvl: 134, track: 'Hero' },
        6 => { ilvl: 127, track: 'Champion' },
        5 => { ilvl: 124, track: 'Champion' },
        4 => { ilvl: 118, track: 'Veteran' },
        3 => { ilvl: 115, track: 'Veteran' },
        2 => { ilvl: 111, track: 'Veteran' },
        1 => { ilvl: 108, track: 'Veteran' },
      }
    }
  },
  16 => {
    first_period: 1052,
    pvp_season: 41,
    spark_label: "Radiance Crafted",
    spark_ilvl_bump_bonus_id: [],
    keystone_dungeons: [
      { id: 499, name: "Magister's Terrace", mythic_id: 61217, legacy: false },
      { id: 503, name: "Maisara Caverns", mythic_id: 61655, legacy: false },
      { id: 505, name: "Nexus-Point Xenas", mythic_id: 61658, legacy: false },
      { id: 525, name: "Windrunner Spire", mythic_id: 41295, legacy: false },
      { id: 542, name: "Algeth'ar Academy", mythic_id: 16088, legacy: true },
      { id: 378, name: "Pit of Saron", mythic_id: 0, legacy: true },
      { id: 391, name: "Seat of the Triumvirate", mythic_id: 12613, legacy: true },
      { id: 392, name: "Skyreach", mythic_id: 10195, legacy: true },
    ],
    crests: [
      { name: 'Gilded', ilvl_cap: 289, weekly_increase: 90, first_period: 1055, icon_item_id: 240929 },
      { name: 'Runed', ilvl_cap: 276, weekly_increase: 90, first_period: 1055, icon_item_id: 240930 },
      { name: 'Carved', ilvl_cap: 263, weekly_increase: 90, first_period: 1052, icon_item_id: 240931 },
      { name: 'Weathered', ilvl_cap: 250, weekly_increase: 90, first_period: 1052, icon_item_id: 240928 },
    ],
    track_cutoffs: [
      { ilvl: 272, track: 'Myth', bonus_id: 12053, difficulty: :mythic },
      { ilvl: 259, track: 'Hero', bonus_id: 12052, difficulty: :heroic },
      { ilvl: 246, track: 'Champion', bonus_id: 12051, difficulty: :normal },
      { ilvl: 233, track: 'Veteran' },
      { ilvl: 220, track: 'Adventurer' },
      { ilvl: 207, track: 'Explorer' }
    ],
    great_vault: {
      raid: {
        mythic: { ilvl: 272, track: 'Myth' },
        heroic: { ilvl: 259, track: 'Hero' },
        normal: { ilvl: 246, track: 'Champion' },
        raid_finder: { ilvl: 233, track: 'Veteran' },
      },
      dungeon: {
        10 => { ilvl: 272, track: 'Myth' },
        9 => { ilvl: 269, track: 'Hero' },
        8 => { ilvl: 269, track: 'Hero' },
        7 => { ilvl: 269, track: 'Hero' },
        6 => { ilvl: 266, track: 'Hero' },
        5 => { ilvl: 263, track: 'Hero' },
        4 => { ilvl: 263, track: 'Hero' },
        3 => { ilvl: 259, track: 'Hero' },
        2 => { ilvl: 259, track: 'Hero' },
        1 => { ilvl: 256, track: 'Champion' }, # Regular Mythic
        0 => { ilvl: 243, track: 'Veteran' }, # Heroic
        -1 => { ilvl: nil, track: nil },
      },
      delve: {
        11 => { ilvl: 259, track: 'Hero' },
        10 => { ilvl: 259, track: 'Hero' },
        9 => { ilvl: 259, track: 'Hero' },
        8 => { ilvl: 259, track: 'Hero' },
        7 => { ilvl: 259, track: 'Hero' },
        6 => { ilvl: 256, track: 'Champion' },
        5 => { ilvl: 253, track: 'Champion' },
        4 => { ilvl: 246, track: 'Veteran' },
        3 => { ilvl: 243, track: 'Veteran' },
        2 => { ilvl: 240, track: 'Veteran' },
        1 => { ilvl: 237, track: 'Veteran' },
      }
    }
  }
}

EXPANSION_DUNGEONS = [
  { heroic_id: 61651, mythic_id: 61652, name: "Den of Nalorakk" },
  { heroic_id: 61216, mythic_id: 61217, name: "Magister's Terrace" },
  { heroic_id: 61274, mythic_id: 61275, name: "Murder Row" },
  { heroic_id: 41294, mythic_id: 41295, name: "Windrunner Spire" },
  { heroic_id: 61654, mythic_id: 61655, name: "Maisara Caverns" },
  { heroic_id: 61657, mythic_id: 61658, name: "Nexus-Point Xenas" },
  { heroic_id: 61660, mythic_id: 61661, name: "The Blinding Vale" },
  { heroic_id: 61512, mythic_id: 61513, name: "Voidscar Arena" },
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

# https://www.wowhead.com/quest=89268/lost-legends
HARANIR_WEEKLY_QUESTS = [88993, 88994, 88996, 88997, 88995]

SALTHERIL_WEEKLY_QUESTS = [90573, 90574, 90575, 90576]

# https://www.wowhead.com/quest=93744/unity-against-the-void
UNITY_WEEKLY_QUESTS = [93890, 93889, 93891, 93910, 93769, 93909, 93911, 93767, 93912, 93913, 93892, 93766, 94457]

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

GREAT_VAULT_BLACKLISTED_PERIODS = [932, 974, 975, 1000, 1052, 1053, 1054]

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
  41625, # Dimensius, the All-Devouring
  61625, # Crown of the Cosmos
  61492, # Chimearus, the Undreamt God
  61627, # Midnight Falls
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
  41624, # Dimensius, the All-Devouring
  61624, # Crown of the Cosmos
  61491, # Chimearus, the Undreamt God
  61626, # Midnight Falls
]

VALID_RAIDS = {
  live: [
    {"name"=>"The Voidspire", "days"=>[0, 1, 2, 3, 4, 5, 6], "id"=>nil, "encounters"=>[{"id"=>nil, "name"=>"Imperator Averzian", "raid_ids"=>{"raid_finder"=>[61276], "normal"=>[61277], "heroic"=>[61278], "mythic"=>[61279]}}, {"id"=>nil, "name"=>"Vorasius", "raid_ids"=>{"raid_finder"=>[61280], "normal"=>[61281], "heroic"=>[61282], "mythic"=>[61283]}}, {"id"=>nil, "name"=>"Fallen-King Salhadaar", "raid_ids"=>{"raid_finder"=>[61284], "normal"=>[61285], "heroic"=>[61286], "mythic"=>[61287]}}, {"id"=>nil, "name"=>"Vaelgor & Ezzorak", "raid_ids"=>{"raid_finder"=>[61288], "normal"=>[61289], "heroic"=>[61290], "mythic"=>[61291]}}, {"id"=>nil, "name"=>"Lightblinded Vanguard", "raid_ids"=>{"raid_finder"=>[61292], "normal"=>[61293], "heroic"=>[61294], "mythic"=>[61295]}}, {"id"=>nil, "name"=>"Crown of the Cosmos", "raid_ids"=>{"raid_finder"=>[61296], "normal"=>[61297], "heroic"=>[61298], "mythic"=>[61299]}}]},
    {"name"=>"The Dreamrift", "days"=>[0, 1, 2, 3, 4, 5, 6], "id"=>nil, "encounters"=>[{"id"=>nil, "name"=>"Chimaerus", "raid_ids"=>{"raid_finder"=>[61474], "normal"=>[61475], "heroic"=>[61476], "mythic"=>[61477]}}]},
    {"name"=>"March on Quel'Danas", "days"=>[0, 1, 2, 3, 4, 5, 6], "id"=>nil, "encounters"=>[{"id"=>nil, "name"=>"Belo'ren, Child of Al'ar", "raid_ids"=>{"raid_finder"=>[61300], "normal"=>[61301], "heroic"=>[61302], "mythic"=>[61303]}}, {"id"=>nil, "name"=>"Midnight Falls", "raid_ids"=>{"raid_finder"=>[61304], "normal"=>[61305], "heroic"=>[61306], "mythic"=>[61307]}}]}
  ],
  classic_era: [
  ],
  classic_progression: [
    {"name"=>"Mogu'shan Vaults", "days"=>[], "id"=>nil, "encounters"=>[{"id"=>nil, "name"=>"The Stone Guard", "raid_ids"=>{"raid_finder"=>[6983], "normal"=>[6789, 7914], "heroic"=>[6790, 7915]}}, {"id"=>nil, "name"=>"Feng the Accursed", "raid_ids"=>{"raid_finder"=>[6984], "normal"=>[6791, 7917], "heroic"=>[6792, 7918]}}, {"id"=>nil, "name"=>"Gara'jal the Spiritbinder", "raid_ids"=>{"raid_finder"=>[6985], "normal"=>[6793, 7919], "heroic"=>[6794, 7920]}}, {"id"=>nil, "name"=>"The Spirit Kings", "raid_ids"=>{"raid_finder"=>[6986], "normal"=>[6795, 7921], "heroic"=>[6796, 7922]}}, {"id"=>nil, "name"=>"Elegon", "raid_ids"=>{"raid_finder"=>[6987], "normal"=>[6797, 7923], "heroic"=>[6798, 7924]}}, {"id"=>nil, "name"=>"Will of the Emperor", "raid_ids"=>{"raid_finder"=>[6988], "normal"=>[6799, 7926], "heroic"=>[6800, 7927]}}]},
    {"name"=>"Heart of Fear", "days"=>[], "id"=>nil, "encounters"=>[{"id"=>nil, "name"=>"Imperial Vizier Zor'lok", "raid_ids"=>{"raid_finder"=>[6991], "normal"=>[6801, 7951], "heroic"=>[6802, 7953]}}, {"id"=>nil, "name"=>"Blade Lord Ta'yak", "raid_ids"=>{"raid_finder"=>[6992], "normal"=>[6803, 7954], "heroic"=>[6804, 7955]}}, {"id"=>nil, "name"=>"Garalon", "raid_ids"=>{"raid_finder"=>[6993], "normal"=>[6805, 7956], "heroic"=>[6806, 7957]}}, {"id"=>nil, "name"=>"Wind Lord Mel'jarak", "raid_ids"=>{"raid_finder"=>[6994], "normal"=>[6807, 7958], "heroic"=>[6808, 7960]}}, {"id"=>nil, "name"=>"Amber-Shaper Un'sok", "raid_ids"=>{"raid_finder"=>[6995], "normal"=>[6809, 7961], "heroic"=>[6810, 7962]}}, {"id"=>nil, "name"=>"Grand Empress Shek'zeer", "raid_ids"=>{"raid_finder"=>[6996], "normal"=>[6811, 7963], "heroic"=>[6812, 7964]}}]},
    {"name"=>"Terrace of Endless Spring", "days"=>[], "id"=>nil, "encounters"=>[{"id"=>nil, "name"=>"Protectors of the Endless", "raid_ids"=>{"raid_finder"=>[6997], "normal"=>[6813, 7965], "heroic"=>[6814, 7966]}}, {"id"=>nil, "name"=>"Tsulong", "raid_ids"=>{"raid_finder"=>[6998], "normal"=>[6815, 7967], "heroic"=>[6816, 7968]}}, {"id"=>nil, "name"=>"Lei Shi", "raid_ids"=>{"raid_finder"=>[6999], "normal"=>[6817, 7969], "heroic"=>[6818, 7970]}}, {"id"=>nil, "name"=>"Sha of Fear", "raid_ids"=>{"raid_finder"=>[7000], "normal"=>[6819, 7971], "heroic"=>[6820, 7972]}}]},
    {"name"=>"Throne of Thunder", "days"=>[0, 1, 2, 3, 4, 5, 6], "id"=>nil, "encounters"=>[{"id"=>nil, "name"=>"Jin'rokh the Breaker", "raid_ids"=>{"raid_finder"=>[8141], "normal"=>[8142, 8143], "heroic"=>[8144, 8145]}}, {"id"=>nil, "name"=>"Horridon", "raid_ids"=>{"raid_finder"=>[8148], "normal"=>[8149, 8150], "heroic"=>[8151, 8152]}}, {"id"=>nil, "name"=>"Council of Elders", "raid_ids"=>{"raid_finder"=>[8153], "normal"=>[8154, 8155], "heroic"=>[8156, 8157]}}, {"id"=>nil, "name"=>"Tortos", "raid_ids"=>{"raid_finder"=>[8158], "normal"=>[8159, 8160], "heroic"=>[8161, 8162]}}, {"id"=>nil, "name"=>"Megaera", "raid_ids"=>{"raid_finder"=>[8163], "normal"=>[8164, 8165], "heroic"=>[8166, 8167]}}, {"id"=>nil, "name"=>"Ji-Kun", "raid_ids"=>{"raid_finder"=>[8168], "normal"=>[8169, 8170], "heroic"=>[8171, 8172]}}, {"id"=>nil, "name"=>"Durumu the Forgotten", "raid_ids"=>{"raid_finder"=>[8173], "normal"=>[8174, 8175], "heroic"=>[8176, 8177]}}, {"id"=>nil, "name"=>"Primordius", "raid_ids"=>{"raid_finder"=>[8178], "normal"=>[8179, 8182], "heroic"=>[8180, 8181]}}, {"id"=>nil, "name"=>"Dark Animus", "raid_ids"=>{"raid_finder"=>[8183], "normal"=>[8184, 8185], "heroic"=>[8186, 8187]}}, {"id"=>nil, "name"=>"Iron Qon", "raid_ids"=>{"raid_finder"=>[8188], "normal"=>[8189, 8190], "heroic"=>[8191, 8192]}}, {"id"=>nil, "name"=>"Twin Empyreans", "raid_ids"=>{"raid_finder"=>[8193], "normal"=>[8194, 8195], "heroic"=>[8196, 8197]}}, {"id"=>nil, "name"=>"Lei Shen", "raid_ids"=>{"raid_finder"=>[8198], "normal"=>[8199, 8200], "heroic"=>[8201, 8202]}}, {"id"=>nil, "name"=>"Ra-den", "raid_ids"=>{"heroic"=>[8203, 8256]}}]}
  ],
  classic_anniversary: [
  ],
}

WCL_IDS = {
  live: VALID_RAIDS[:live].map{ |raid| raid["encounters"].map{ |encounter| encounter["id"].to_s } }.flatten,
  classic_era: VALID_RAIDS[:classic_era].map{ |raid| raid["encounters"].map{ |encounter| encounter["id"].to_s } }.flatten,
  classic_progression: VALID_RAIDS[:classic_progression].map{ |raid| raid["encounters"].map{ |encounter| encounter["id"].to_s } }.flatten,
  classic_anniversary: VALID_RAIDS[:classic_anniversary].map{ |raid| raid["encounters"].map{ |encounter| encounter["id"].to_s } }.flatten,
}
