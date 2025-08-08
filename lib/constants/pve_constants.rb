FIRST_PERIOD_OF_EXPANSION = 974
CURRENT_SEASON = 15

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
    keystone_dungeons: [
      { id: 499, name: "Priory of the Sacred Flame", mythic_id: 40659, legacy: false },
      { id: 503, name: "Ara-Kara, City of Echoes", mythic_id: 20487, legacy: false },
      { id: 505, name: "The Dawnbreaker", mythic_id: 40715, legacy: false },
      { id: 525, name: "Operation: Floodgate", mythic_id: 41344, legacy: false },
      { id: 542, name: "Eco-Dome Al'dani", mythic_id: 42785, legacy: false },
      { id: 378, name: "Halls of Atonement", mythic_id: 14392, legacy: true },
      { id: 391, name: "Tazavesh: Streets of Wonder", mythic_id: 0, legacy: true },
      { id: 370, name: "Tazavesh: So'leah's Gambit", mythic_id: 15168, legacy: true },
    ],
    crests: [
      { name: 'Gilded', ilvl_cap: 723, weekly_increase: 90, first_period: 1023, icon_item_id: 240929 },
      { name: 'Runed', ilvl_cap: 704, weekly_increase: 90, first_period: 1023, icon_item_id: 240930 },
      { name: 'Carved', ilvl_cap: 691, weekly_increase: 90, first_period: 1023, icon_item_id: 240931 },
      { name: 'Weathered', ilvl_cap: 678, weekly_increase: 90, first_period: 1023, icon_item_id: 240928 },
    ],
    track_cutoffs: [
      { ilvl: 707, track: 'Myth' },
      { ilvl: 694, track: 'Hero' },
      { ilvl: 681, track: 'Champion' },
      { ilvl: 668, track: 'Veteran' },
      { ilvl: 655, track: 'Adventurer' },
      { ilvl: 642, track: 'Explorer' }
    ],
    great_vault: {
      raid: {
        mythic: { ilvl: 707, track: 'Myth' },
        heroic: { ilvl: 694, track: 'Hero' },
        normal: { ilvl: 681, track: 'Champion' },
        raid_finder: { ilvl: 668, track: 'Veteran' },
      },
      dungeon: {
        10 => { ilvl: 707, track: 'Myth' },
        9 => { ilvl: 704, track: 'Hero' },
        8 => { ilvl: 704, track: 'Hero' },
        7 => { ilvl: 704, track: 'Hero' },
        6 => { ilvl: 701, track: 'Hero' },
        5 => { ilvl: 697, track: 'Hero' },
        4 => { ilvl: 697, track: 'Hero' },
        3 => { ilvl: 694, track: 'Hero' },
        2 => { ilvl: 694, track: 'Hero' },
        1 => { ilvl: 691, track: 'Champion' }, # Regular Mythic
        0 => { ilvl: 678, track: 'Veteran' }, # Heroic
        -1 => { ilvl: nil, track: nil },
      },
      delve: {
        11 => { ilvl: 694, track: 'Hero' },
        10 => { ilvl: 694, track: 'Hero' },
        9 => { ilvl: 694, track: 'Hero' },
        8 => { ilvl: 694, track: 'Hero' },
        7 => { ilvl: 694, track: 'Hero' },
        6 => { ilvl: 687, track: 'Champion' },
        5 => { ilvl: 684, track: 'Champion' },
        4 => { ilvl: 678, track: 'Veteran' },
        3 => { ilvl: 675, track: 'Veteran' },
        2 => { ilvl: 671, track: 'Veteran' },
        1 => { ilvl: 668, track: 'Veteran' },
      }
    }
  }
}

EXPANSION_DUNGEONS = [
  { heroic_id: 20486, mythic_id: 20487, name: "Ara-Kara, City of Echoes" },
  { heroic_id: 40653, mythic_id: 40654, name: "Cinderbrew Meadery" },
  { heroic_id: 40709, mythic_id: 40710, name: "City of Threads" },
  { heroic_id: 20483, mythic_id: 20484, name: "Darkflame Cleft" },
  { heroic_id: 40658, mythic_id: 40659, name: "Priory of the Sacred Flame" },
  { heroic_id: 40714, mythic_id: 40715, name: "The Dawnbreaker" },
  { heroic_id: 40717, mythic_id: 40718, name: "The Rookery" },
  { heroic_id: 40721, mythic_id: 40722, name: "The Stonevault" },
  { heroic_id: 41343, mythic_id: 41344, name: "Operation: Floodgate" },
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
  41625, # Dimensius, the All-Devouring
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
]

VALID_RAIDS = {
  live: [
    {"name"=>"Nerub-ar Palace", "days"=>[], "id"=>38, "encounters"=>[{"id"=>2902, "name"=>"Ulgrax", "raid_ids"=>{"raid_finder"=>[40267], "normal"=>[40268], "heroic"=>[40269], "mythic"=>[40270]}}, {"id"=>2917, "name"=>"The Bloodbound Horror", "raid_ids"=>{"raid_finder"=>[40271], "normal"=>[40272], "heroic"=>[40273], "mythic"=>[40274]}}, {"id"=>2898, "name"=>"Sikran", "raid_ids"=>{"raid_finder"=>[40275], "normal"=>[40276], "heroic"=>[40277], "mythic"=>[40278]}}, {"id"=>2918, "name"=>"Rasha'nan", "raid_ids"=>{"raid_finder"=>[40279], "normal"=>[40280], "heroic"=>[40281], "mythic"=>[40282]}}, {"id"=>2919, "name"=>"Broodtwister Ovi'nax", "raid_ids"=>{"raid_finder"=>[40283], "normal"=>[40284], "heroic"=>[40285], "mythic"=>[40286]}}, {"id"=>2920, "name"=>"Nexus-Princess Ky'veza", "raid_ids"=>{"raid_finder"=>[40287], "normal"=>[40288], "heroic"=>[40289], "mythic"=>[40290]}}, {"id"=>2921, "name"=>"The Silken Court", "raid_ids"=>{"raid_finder"=>[40291], "normal"=>[40292], "heroic"=>[40293], "mythic"=>[40294]}}, {"id"=>2922, "name"=>"Queen Ansurek", "raid_ids"=>{"raid_finder"=>[40295], "normal"=>[40296], "heroic"=>[40297], "mythic"=>[40298]}}]},
    {"name"=>"Liberation of Undermine", "days"=>[], "id"=>42, "encounters"=>[{"id"=>3009, "name"=>"Vexie and the Geargrinders", "raid_ids"=>{"raid_finder"=>[41299], "normal"=>[41300], "heroic"=>[41301], "mythic"=>[41302]}}, {"id"=>3010, "name"=>"Cauldron of Carnage", "raid_ids"=>{"raid_finder"=>[41303], "normal"=>[41304], "heroic"=>[41305], "mythic"=>[41306]}}, {"id"=>3011, "name"=>"Rik Reverb", "raid_ids"=>{"raid_finder"=>[41307], "normal"=>[41308], "heroic"=>[41309], "mythic"=>[41310]}}, {"id"=>3012, "name"=>"Stix Bunkjunker", "raid_ids"=>{"raid_finder"=>[41311], "normal"=>[41312], "heroic"=>[41313], "mythic"=>[41314]}}, {"id"=>3013, "name"=>"Sprocketmonger Lockenstock", "raid_ids"=>{"raid_finder"=>[41315], "normal"=>[41316], "heroic"=>[41317], "mythic"=>[41318]}}, {"id"=>3014, "name"=>"The One-Armed Bandit", "raid_ids"=>{"raid_finder"=>[41319], "normal"=>[41320], "heroic"=>[41321], "mythic"=>[41322]}}, {"id"=>3015, "name"=>"Mug'Zee, Heads of Security", "raid_ids"=>{"raid_finder"=>[41323], "normal"=>[41324], "heroic"=>[41325], "mythic"=>[41326]}}, {"id"=>3016, "name"=>"Chrome King Gallywix", "raid_ids"=>{"raid_finder"=>[41327], "normal"=>[41328], "heroic"=>[41329], "mythic"=>[41330]}}]},
    {"name"=>"Manaforge Omega", "days"=>[0, 1, 2, 3, 4, 5, 6], "id"=>44, "encounters"=>[{"id"=>3129, "name"=>"Plexus Sentinel", "raid_ids"=>{"raid_finder"=>[41633], "normal"=>[41634], "heroic"=>[41635], "mythic"=>[41636]}}, {"id"=>3131, "name"=>"Loom'ithar", "raid_ids"=>{"raid_finder"=>[41637], "normal"=>[41638], "heroic"=>[41639], "mythic"=>[41640]}}, {"id"=>3130, "name"=>"Soulbinder Naazindhri", "raid_ids"=>{"raid_finder"=>[41641], "normal"=>[41642], "heroic"=>[41643], "mythic"=>[41644]}}, {"id"=>3132, "name"=>"Forgeweaver Araz", "raid_ids"=>{"raid_finder"=>[41645], "normal"=>[41646], "heroic"=>[41647], "mythic"=>[41648]}}, {"id"=>3122, "name"=>"The Soul Hunters", "raid_ids"=>{"raid_finder"=>[41649], "normal"=>[41650], "heroic"=>[41651], "mythic"=>[41652]}}, {"id"=>3133, "name"=>"Fractillus", "raid_ids"=>{"raid_finder"=>[41653], "normal"=>[41654], "heroic"=>[41655], "mythic"=>[41656]}}, {"id"=>3134, "name"=>"Nexus-King Salhadaar", "raid_ids"=>{"raid_finder"=>[41657], "normal"=>[41658], "heroic"=>[41659], "mythic"=>[41660]}}, {"id"=>3135, "name"=>"Dimensius, the All-Devouring", "raid_ids"=>{"raid_finder"=>[41661], "normal"=>[41662], "heroic"=>[41663], "mythic"=>[41664]}}]}
  ],
  classic_era: [
  ],
  classic_progression: [
    {"name"=>"Mogu'shan Vaults", "days"=>[0, 1, 2, 3, 4, 5, 6], "id"=>nil, "encounters"=>[{"id"=>nil, "name"=>"The Stone Guard", "raid_ids"=>{"raid_finder"=>[6983], "normal"=>[6789, 7914], "heroic"=>[6790, 7915]}}, {"id"=>nil, "name"=>"Feng the Accursed", "raid_ids"=>{"raid_finder"=>[6984], "normal"=>[6791, 7917], "heroic"=>[6792, 7918]}}, {"id"=>nil, "name"=>"Gara'jal the Spiritbinder", "raid_ids"=>{"raid_finder"=>[6985], "normal"=>[6793, 7919], "heroic"=>[6794, 7920]}}, {"id"=>nil, "name"=>"The Spirit Kings", "raid_ids"=>{"raid_finder"=>[6986], "normal"=>[6795, 7921], "heroic"=>[6796, 7922]}}, {"id"=>nil, "name"=>"Elegon", "raid_ids"=>{"raid_finder"=>[6987], "normal"=>[6797, 7923], "heroic"=>[6798, 7924]}}, {"id"=>nil, "name"=>"Will of the Emperor", "raid_ids"=>{"raid_finder"=>[6988], "normal"=>[6799, 7926], "heroic"=>[6800, 7927]}}]},
    {"name"=>"Heart of Fear", "days"=>[], "id"=>nil, "encounters"=>[{"id"=>nil, "name"=>"Imperial Vizier Zor'lok", "raid_ids"=>{"raid_finder"=>[6991], "normal"=>[6801, 7951], "heroic"=>[6802, 7953]}}, {"id"=>nil, "name"=>"Blade Lord Ta'yak", "raid_ids"=>{"raid_finder"=>[6992], "normal"=>[6803, 7954], "heroic"=>[6804, 7955]}}, {"id"=>nil, "name"=>"Garalon", "raid_ids"=>{"raid_finder"=>[6993], "normal"=>[6805, 7956], "heroic"=>[6806, 7957]}}, {"id"=>nil, "name"=>"Wind Lord Mel'jarak", "raid_ids"=>{"raid_finder"=>[6994], "normal"=>[6807, 7958], "heroic"=>[6808, 7960]}}, {"id"=>nil, "name"=>"Amber-Shaper Un'sok", "raid_ids"=>{"raid_finder"=>[6995], "normal"=>[6809, 7961], "heroic"=>[6810, 7962]}}, {"id"=>nil, "name"=>"Grand Empress Shek'zeer", "raid_ids"=>{"raid_finder"=>[6996], "normal"=>[6811, 7963], "heroic"=>[6812, 7964]}}]},
    {"name"=>"Terrace of Endless Spring", "days"=>[], "id"=>nil, "encounters"=>[{"id"=>nil, "name"=>"Protectors of the Endless", "raid_ids"=>{"raid_finder"=>[6997], "normal"=>[6813, 7965], "heroic"=>[6814, 7966]}}, {"id"=>nil, "name"=>"Tsulong", "raid_ids"=>{"raid_finder"=>[6998], "normal"=>[6815, 7967], "heroic"=>[6816, 7968]}}, {"id"=>nil, "name"=>"Lei Shi", "raid_ids"=>{"raid_finder"=>[6999], "normal"=>[6817, 7969], "heroic"=>[6818, 7970]}}, {"id"=>nil, "name"=>"Sha of Fear", "raid_ids"=>{"raid_finder"=>[7000], "normal"=>[6819, 7971], "heroic"=>[6820, 7972]}}]},
  ],
}

WCL_IDS = {
  live: VALID_RAIDS[:live].map{ |raid| raid["encounters"].map{ |encounter| encounter["id"].to_s } }.flatten,
  classic_era: VALID_RAIDS[:classic_era].map{ |raid| raid["encounters"].map{ |encounter| encounter["id"].to_s } }.flatten,
  classic_progression: VALID_RAIDS[:classic_progression].map{ |raid| raid["encounters"].map{ |encounter| encounter["id"].to_s } }.flatten,
}
