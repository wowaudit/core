TIMELINE_EVENTS = {
  1 => {
    from: Date.new(2005, 2, 11), # In US it was 2004-11-23
    to: Date.new(2006, 12, 4),
    title: 'Vanilla',
    criteria: [
      { achievement_id: 433, quality: :legendary, name: 'Grand Marshal', icon: 'achievement_pvp_a_14' },
      { achievement_id: 443, quality: :legendary, name: 'High Warlord', icon: 'achievement_pvp_h_14' },

      { achievement_id: 879, quality: :legendary, name: 'Old School Ride', icon: 'ability_mount_mountainram' },

      { achievement_id: 434, quality: :epic, name: 'Field Marshal', icon: 'achievement_pvp_a_13' },
      { achievement_id: 445, quality: :epic, name: 'Warlord', icon: 'achievement_pvp_h_13' },

      { achievement_id: 473, quality: :epic, name: 'Marshal', icon: 'achievement_pvp_a_12' },
      { achievement_id: 446, quality: :epic, name: 'General', icon: 'achievement_pvp_h_12' },

      { achievement_id: 435, quality: :epic, name: 'Commander', icon: 'achievement_pvp_a_11' },
      { achievement_id: 444, quality: :epic, name: 'Lieutenant General', icon: 'achievement_pvp_h_11' },

      { achievement_id: 436, quality: :epic, name: 'Lieutenant Commander', icon: 'achievement_pvp_a_10' },
      { achievement_id: 447, quality: :epic, name: 'Champion', icon: 'achievement_pvp_h_10' },

      { achievement_id: 437, quality: :epic, name: 'Knight-Champion', icon: 'achievement_pvp_a_09' },
      { achievement_id: 448, quality: :epic, name: 'Centurion', icon: 'achievement_pvp_h_09' },

      { achievement_id: 438, quality: :epic, name: 'Knight-Captain', icon: 'achievement_pvp_a_08' },
      { achievement_id: 469, quality: :epic, name: 'Legionnaire', icon: 'achievement_pvp_h_08' },

      { achievement_id: 472, quality: :rare, name: 'Knight-Lieutenant', icon: 'achievement_pvp_a_07' },
      { achievement_id: 449, quality: :rare, name: 'Blood Guard', icon: 'achievement_pvp_h_07' },

      { achievement_id: 439, quality: :rare, name: 'Knight', icon: 'achievement_pvp_a_06' },
      { achievement_id: 451, quality: :rare, name: 'Stone Guard', icon: 'achievement_pvp_h_06' },

      { achievement_id: 440, quality: :rare, name: 'Sergeant Major', icon: 'achievement_pvp_a_05' },
      { achievement_id: 452, quality: :rare, name: 'First Sergeant', icon: 'achievement_pvp_h_05' },

      { achievement_id: 441, quality: :rare, name: 'Master Sergeant', icon: 'achievement_pvp_a_04' },
      { achievement_id: 450, quality: :rare, name: 'Senior Sergeant', icon: 'achievement_pvp_h_04' },

      { achievement_id: 471, quality: :rare, name: 'Sergeant', icon: 'achievement_pvp_a_03' },
      { achievement_id: 453, quality: :rare, name: 'Sergeant', icon: 'achievement_pvp_h_03' },

      { achievement_id: 470, quality: :rare, name: 'Corporal', icon: 'achievement_pvp_a_02' },
      { achievement_id: 468, quality: :rare, name: 'Grunt', icon: 'achievement_pvp_h_02' },

      { achievement_id: 454, quality: :rare, name: 'Scout', icon: 'achievement_pvp_h_01' },
      { achievement_id: 442, quality: :rare, name: 'Private', icon: 'achievement_pvp_a_01' },
    ]
  },
  2 => {
    from: Date.new(2006, 12, 5),
    to: Date.new(2007, 9, 14),
    title: 'The Burning Crusade', # Actually released 2007-01-16
    criteria: [
      { achievement_id: 696, quality: :epic, name: "Tempest Keep", icon: 'achievement_character_bloodelf_male', time_sensitive: Date.new(2008, 10, 31) },
      { achievement_id: 694, quality: :epic, name: 'Serpentshrine Cavern', icon: 'achievement_boss_ladyvashj', time_sensitive: Date.new(2008, 10, 31) },
      { achievement_id: 432, quality: :rare, name: 'Champion of the Naaru', icon: 'inv_mace_51' },
      { achievement_id: 693, quality: :rare, name: "Magtheridon's Lair", icon: 'achievement_boss_magtheridon', time_sensitive: Date.new(2008, 10, 31) },
      { achievement_id: 690, quality: :rare, name: 'Karazhan', icon: 'achievement_boss_princemalchezaar_02', time_sensitive: Date.new(2008, 10, 31) },
      { achievement_id: 692, quality: :rare, name: "Gruul's Lair", icon: 'achievement_boss_gruulthedragonkiller', time_sensitive: Date.new(2008, 10, 31) },
    ]
  },
  3 => {
    from: Date.new(2007, 9, 15),
    to: Date.new(2008, 5, 12),
    title: 'Mount Hyjal & The Black Temple', # Actually released 2007-05-15
    criteria: [
      { achievement_id: 697, quality: :epic, name: "The Black Temple", icon: 'achievement_boss_illidan', time_sensitive: Date.new(2008, 10, 31) },
      { achievement_id: 695, quality: :epic, name: "Battle for Mount Hyjal", icon: 'achievement_boss_archimonde-', time_sensitive: Date.new(2008, 10, 31) },
      { achievement_id: 431, quality: :rare, name: "Hand of A'dal", icon: 'inv_mace_25' },
    ],
  },
  4 => {
    from: Date.new(2008, 5, 13),
    to: Date.new(2008, 11, 12),
    title: "Zul'Aman & Sunwell Plateau", # Zul'Aman actually released 2007-11-13, Sunwell Plateau actually released 2008-03-25
    criteria: [
      { achievement_id: 698, quality: :legendary, name: "Sunwell Plateau", icon: 'achievement_boss_kiljaedan', time_sensitive: Date.new(2008, 10, 31) },
      { achievement_id: 430, quality: :epic, name: "Amani War Bear", icon: 'ability_druid_challangingroar' },
      { achievement_id: 691, quality: :rare, name: "Zul'Aman", icon: 'achievement_boss_zuljin', time_sensitive: Date.new(2008, 10, 31) },
    ],
  },
  5 => {
    from: Date.new(2008, 11, 13),
    to: Date.new(2009, 4, 13),
    title: 'Wrath of the Lich King',
    criteria: [
      { achievement_id: 1402, quality: :legendary, name: 'Realm First! Conqueror of Naxxramas', icon: 'inv_trinket_naxxramas06', time_sensitive: Date.new(2009, 4, 13) },
      { achievement_id: 1400, quality: :legendary, name: 'Realm First! Magic Seeker', icon: 'inv_misc_head_dragon_blue', time_sensitive: Date.new(2009, 4, 13) },
      { achievement_id: 456, quality: :legendary, name: 'Realm First! Obsidian Slayer', icon: 'achievement_dungeon_coablackdragonflight_25man', time_sensitive: Date.new(2009, 4, 13) },
      { achievement_id: 2138, quality: :epic, name: 'Glory of the Raider (25 player)', icon: 'inv_helmet_06', time_sensitive: Date.new(2009, 4, 13) },
      { achievement_id: 2137, quality: :epic, name: 'Glory of the Raider (10 player)', icon: 'inv_helmet_22', time_sensitive: Date.new(2009, 4, 13) },
      { achievement_id: 575, quality: :rare, name: "Kel'Thuzad's Defeat (25 player)", icon: 'inv_trinket_naxxramas06', time_sensitive: Date.new(2009, 4, 13) },
      { achievement_id: 574, quality: :rare, name: "Kel'Thuzad's Defeat (10 player)", icon: 'inv_trinket_naxxramas06', time_sensitive: Date.new(2009, 4, 13) },
      { achievement_id: 623, quality: :rare, name: "The Spellweaver's Downfall (25 player)", icon: 'achievement_dungeon_nexusraid_10man', time_sensitive: Date.new(2009, 4, 13) },
      { achievement_id: 622, quality: :rare, name: "The Spellweaver's Downfall (10 player)", icon: 'achievement_dungeon_nexusraid', time_sensitive: Date.new(2009, 4, 13) },
      { achievement_id: 625, quality: :rare, name: 'Besting the Black Dragonflight (25 player)', icon: 'achievement_dungeon_coablackdragonflight_10man', time_sensitive: Date.new(2009, 4, 13) },
      { achievement_id: 1876, quality: :rare, name: 'Besting the Black Dragonflight (10 player)', icon: 'achievement_dungeon_coablackdragonflight', time_sensitive: Date.new(2009, 4, 13) },
    ],
  },
  6 => {
    from: Date.new(2009, 4, 14),
    to: Date.new(2009, 8, 3),
    title: 'Ulduar',
    criteria: [
      { achievement_id: 3164, quality: :legendary, name: 'Alone in the Darkness (25 player)', icon: 'spell_shadow_shadesofdarkness', time_sensitive: Date.new(2009, 8, 3) },
      { achievement_id: 3159, quality: :legendary, name: 'Alone in the Darkness (10 player)', icon: 'spell_shadow_shadesofdarkness', time_sensitive: Date.new(2009, 8, 3) },
      { achievement_id: 3005, quality: :legendary, name: "He Feeds On Your Tears (25 player)", icon: 'spell_misc_emotionsad', time_sensitive: Date.new(2009, 8, 3) },
      { achievement_id: 3004, quality: :legendary, name: "He Feeds On Your Tears (10 player)", icon: 'spell_misc_emotionsad', time_sensitive: Date.new(2009, 8, 3) },
      { achievement_id: 3259, quality: :legendary, name: "Realm First! Celestial Defender", icon: 'achievement_boss_algalon_01', time_sensitive: Date.new(2009, 8, 3) },
      { achievement_id: 3117, quality: :legendary, name: "Realm First! Death's Demise", icon: 'achievement_boss_yoggsaron_01', time_sensitive: Date.new(2009, 8, 3) },
      { achievement_id: 3037, quality: :epic, name: 'Algalon the Observer (25 player)', icon: 'achievement_boss_algalon_01', time_sensitive: Date.new(2009, 8, 3) },
      { achievement_id: 3036, quality: :epic, name: 'Algalon the Observer (10 player)', icon: 'achievement_boss_algalon_01', time_sensitive: Date.new(2009, 8, 3) },
      { achievement_id: 3163, quality: :epic, name: 'One Light in the Darkness (25 player)', icon: 'spell_shadow_shadesofdarkness', time_sensitive: Date.new(2009, 8, 3) },
      { achievement_id: 3158, quality: :epic, name: 'One Light in the Darkness (10 player)', icon: 'spell_shadow_shadesofdarkness', time_sensitive: Date.new(2009, 8, 3) },
      { achievement_id: 2887, quality: :rare, name: 'The Siege of Ulduar (25 player)', icon: 'achievement_dungeon_ulduarraid_archway_01', time_sensitive: Date.new(2009, 8, 3) },
      { achievement_id: 2886, quality: :rare, name: 'The Siege of Ulduar (10 player)', icon: 'achievement_dungeon_ulduarraid_archway_01', time_sensitive: Date.new(2009, 8, 3) },
    ],
  },
  7 => {
    from: Date.new(2009, 8, 4),
    to: Date.new(2009, 12, 7),
    title: 'Trial of the Crusader',
    criteria: [
      { achievement_id: 4079, quality: :legendary, name: "A Tribute to Immortality", icon: 'achievement_reputation_argentchampion' },
      { achievement_id: 4156, quality: :legendary, name: "A Tribute to Immortality", icon: 'achievement_reputation_argentchampion' },
      { achievement_id: 4078, quality: :legendary, name: "Realm First! Grand Crusader", icon: 'achievement_reputation_argentcrusader', time_sensitive: Date.new(2009, 12, 7) },
      { achievement_id: 3819, quality: :legendary, name: "A Tribute to Insanity (25 player)", icon: 'inv_crown_13', time_sensitive: Date.new(2009, 12, 7) },
      { achievement_id: 3810, quality: :legendary, name: "A Tribute to Insanity (10 player)", icon: 'inv_crown_13', time_sensitive: Date.new(2009, 12, 7) },
      { achievement_id: 3812, quality: :epic, name: "Call of the Grand Crusade (25 player)", icon: 'achievement_reputation_argentchampion', time_sensitive: Date.new(2009, 12, 7) },
      { achievement_id: 3918, quality: :epic, name: "Call of the Grand Crusade (10 player)", icon: 'achievement_reputation_argentchampion', time_sensitive: Date.new(2009, 12, 7) },
      { achievement_id: 3916, quality: :rare, name: "Call of the Crusade (25 player)", icon: 'achievement_reputation_argentchampion', time_sensitive: Date.new(2009, 12, 7) },
      { achievement_id: 3917, quality: :rare, name: "Call of the Crusade (10 player)", icon: 'achievement_reputation_argentchampion', time_sensitive: Date.new(2009, 12, 7) },
    ],
  },
  8 => {
    from: Date.new(2009, 12, 8),
    to: Date.new(2010, 6, 29),
    title: 'Icecrown Citadel',
    criteria: [
      { achievement_id: 4576, quality: :legendary, name: "Realm First! Fall of the Lich King", icon: 'inv_helmet_96', time_sensitive: Date.new(2010, 11, 22) },
      { achievement_id: 4637, quality: :epic, name: "Heroic: Fall of the Lich King (25 player)", icon: 'achievement_dungeon_icecrown_frostmourne', time_sensitive: Date.new(2010, 11, 22) },
      { achievement_id: 4636, quality: :epic, name: "Heroic: Fall of the Lich King (10 player)", icon: 'achievement_dungeon_icecrown_frostmourne', time_sensitive: Date.new(2010, 11, 22) },
      { achievement_id: 4532, quality: :rare, name: "Fall of the Lich King (25 player)", icon: 'achievement_dungeon_icecrown_frostmourne', time_sensitive: Date.new(2010, 11, 22) },
      { achievement_id: 4532, quality: :rare, name: "Fall of the Lich King (10 player)", icon: 'achievement_dungeon_icecrown_frostmourne', time_sensitive: Date.new(2010, 11, 22) },
    ],
  },
  9 => {
    from: Date.new(2010, 6, 30),
    to: Date.new(2010, 12, 6),
    title: 'Ruby Sanctum',
    criteria: [
      { achievement_id: 4637, quality: :epic, name: "Heroic: The Twilight Destroyer (25 player)", icon: 'spell_shadow_twilight', time_sensitive: Date.new(2010, 11, 22) },
      { achievement_id: 4636, quality: :epic, name: "Heroic: The Twilight Destroyer (10 player)", icon: 'spell_shadow_twilight', time_sensitive: Date.new(2010, 11, 22) },
      { achievement_id: 4532, quality: :rare, name: "The Twilight Destroyer (25 player)", icon: 'spell_shadow_twilight', time_sensitive: Date.new(2010, 11, 22) },
      { achievement_id: 4532, quality: :rare, name: "The Twilight Destroyer (10 player)", icon: 'spell_shadow_twilight', time_sensitive: Date.new(2010, 11, 22) },
    ],
  },
  10 => {
    from: Date.new(2010, 12, 7),
    to: Date.new(2011, 6, 27),
    title: 'Cataclysm',
    criteria: [
      { achievement_id: 5313, quality: :legendary, name: "I Can't Hear You Over the Sound of How Awesome I Am", icon: 'achievement_dungeon_bastion-of-twilight_ladysinestra', time_sensitive: Date.new(2011, 6, 27) },
      { achievement_id: 5116, quality: :epic, name: "Heroic: Nefarian", icon: 'achievement_dungeon_blackwingdescent_raid_nefarian', time_sensitive: Date.new(2011, 6, 27) },
      { achievement_id: 5121, quality: :epic, name: "Heroic: Sinestra", icon: 'achievement_dungeon_bastion-of-twilight_ladysinestra', time_sensitive: Date.new(2011, 6, 27) },
      { achievement_id: 5120, quality: :epic, name: "Heroic: Cho'Gall", icon: 'achievement_dungeon_bastion-of-twilight_chogall-boss', time_sensitive: Date.new(2011, 6, 27) },
      { achievement_id: 5123, quality: :epic, name: "Heroic: Al'Akir", icon: 'achievement_boss_murmur', time_sensitive: Date.new(2011, 6, 27) },
      { achievement_id: 4842, quality: :rare, name: "Blackwing Descent", icon: 'achievement_boss_nefarion', time_sensitive: Date.new(2011, 6, 27) },
      { achievement_id: 4850, quality: :rare, name: "The Bastion of Twilight", icon: 'spell_fire_twilightcano', time_sensitive: Date.new(2011, 6, 27) },
      { achievement_id: 4851, quality: :rare, name: "Throne of the Four Winds", icon: 'achievement_boss_murmur', time_sensitive: Date.new(2011, 6, 27) },
    ],
  },
  11 => {
    from: Date.new(2011, 6, 28),
    to: Date.new(2011, 11, 28),
    title: 'Firelands',
    criteria: [
      { achievement_id: 5803, quality: :epic, name: "Heroic: Ragnaros", icon: 'achievement_firelands-raid_ragnaros', time_sensitive: Date.new(2011, 11, 28) },
      { achievement_id: 5802, quality: :rare, name: "Firelands", icon: 'achievement_zone_firelands', time_sensitive: Date.new(2011, 11, 28) },
    ],
  },
  12 => {
    from: Date.new(2011, 11, 29),
    to: Date.new(2012, 9, 24),
    title: 'Dragon Soul',
    criteria: [
      { achievement_id: 6116, quality: :epic, name: "Heroic: Madness of Deathwing", icon: 'achievment_boss_madnessofdeathwing', time_sensitive: Date.new(2012, 9, 24) },
      { achievement_id: 6177, quality: :rare, name: "Destroyer's End", icon: 'ability_deathwing_cataclysm', time_sensitive: Date.new(2012, 9, 24) },
    ],
  },
  13 => {
    from: Date.new(2012, 9, 25),
    to: Date.new(2013, 3, 4),
    title: 'Mists of Pandaria',
    criteria: [
      { achievement_id: 7487, quality: :epic, name: "Cutting Edge: Sha of Fear", icon: 'achievement_raid_terraceofendlessspring04' },
      { achievement_id: 7486, quality: :epic, name: "Cutting Edge: Grand Empress Shek'zeer", icon: 'achievement_raid_mantidraid07' },
      { achievement_id: 7485, quality: :epic, name: "Cutting Edge: Will of the Emperor", icon: 'achievement_moguraid_06' },
      { achievement_id: 8248, quality: :rare, name: "Ahead of the Curve: Sha of Fear", icon: 'achievement_raid_terraceofendlessspring04' },
      { achievement_id: 8246, quality: :rare, name: "Ahead of the Curve: Grand Empress Shek'zeer", icon: 'achievement_raid_mantidraid07' },
      { achievement_id: 6954, quality: :rare, name: "Ahead of the Curve: Will of the Emperor", icon: 'achievement_moguraid_06' },
    ],
  },
  14 => {
    from: Date.new(2013, 3, 5),
    to: Date.new(2013, 9, 9),
    title: 'Throne of Thunder',
    criteria: [
      { achievement_id: 8089, quality: :legendary, name: "I Thought He Was Supposed to Be Hard?", icon: 'achievement_boss_ra_den', time_sensitive: Date.new(2013, 9, 12) },
      { achievement_id: 8260, quality: :epic, name: "Cutting Edge: Ra-den", icon: 'achievement_boss_ra_den' },
      { achievement_id: 8238, quality: :epic, name: "Cutting Edge: Lei Shen", icon: 'achievement_boss_leishen' },
      { achievement_id: 8249, quality: :rare, name: "Ahead of the Curve: Lei Shen", icon: 'achievement_boss_leishen' },
    ],
  },
  15 => {
    from: Date.new(2013, 9, 10),
    to: Date.new(2014, 11, 12),
    title: 'Siege of Orgrimmar',
    criteria: [
      { achievement_id: 8401, quality: :epic, name: "Cutting Edge: Garrosh Hellscream (25 player)", icon: 'inv_misc_tabard_hellscream' },
      { achievement_id: 8400, quality: :epic, name: "Cutting Edge: Garrosh Hellscream (10 player)", icon: 'inv_misc_tabard_hellscream' },
      { achievement_id: 8399, quality: :rare, name: "Ahead of the Curve: Garrosh Hellscream (25 player)", icon: 'inv_misc_tabard_hellscream' },
      { achievement_id: 8398, quality: :rare, name: "Ahead of the Curve: Garrosh Hellscream (10 player)", icon: 'inv_misc_tabard_hellscream' },
    ],
  },
  16 => {
    from: Date.new(2014, 11, 13),
    to: Date.new(2015, 2, 2),
    title: 'Highmaul',
    criteria: [
      { achievement_id: 9442, quality: :epic, name: "Cutting Edge: Imperator Mar'gok", icon: 'achievement_boss_highmaul_king' },
      { achievement_id: 9441, quality: :rare, name: "Ahead of the Curve: Imperator Mar'gok", icon: 'achievement_boss_highmaul_king' },
    ],
  },
  17 => {
    from: Date.new(2015, 2, 3),
    to: Date.new(2015, 6, 22),
    title: 'Blackrock Foundry',
    criteria: [
      { achievement_id: 9443, quality: :epic, name: "Cutting Edge: Blackhand's Crucible", icon: 'achievement_boss_blackhand' },
      { achievement_id: 9444, quality: :rare, name: "Ahead of the Curve: Blackhand's Crucible", icon: 'achievement_boss_blackhand' },
    ],
  },
  18 => {
    from: Date.new(2015, 6, 23),
    to: Date.new(2016, 8, 29),
    title: 'Hellfire Citadel',
    criteria: [
      { achievement_id: 10045, quality: :epic, name: "Cutting Edge: The Black Gate", icon: 'achievement_boss_hellfire_archimonde' },
      { achievement_id: 10044, quality: :rare, name: "Ahead of the Curve: The Black Gate", icon: 'achievement_boss_hellfire_archimonde' },
    ],
  },
  19 => {
    from: Date.new(2016, 8, 30),
    to: Date.new(2017, 1, 16),
    title: 'Emerald Nightmare & Trial of Valor',
    criteria: [
      { achievement_id: 11387, quality: :legendary, name: "The Chosen", icon: "achievement_raid_trialofvalor", time_sensitive: Date.new(2017, 1, 16) },
      { achievement_id: 11580, quality: :epic, name: "Cutting Edge: Helya", icon: 'achievement_boss_helyra', time_sensitive: Date.new(2017, 1, 16) },
      { achievement_id: 11191, quality: :epic, name: "Cutting Edge: Xavius", icon: 'achievement_emeraldnightmare_xavius' },
      { achievement_id: 11581, quality: :rare, name: "Ahead of the Curve: Helya", icon: 'achievement_boss_helyra', time_sensitive: Date.new(2017, 1, 16) },
      { achievement_id: 11194, quality: :rare, name: "Ahead of the Curve: Xavius", icon: 'achievement_emeraldnightmare_xavius' },
    ],
  },
  20 => {
    from: Date.new(2017, 1, 17),
    to: Date.new(2017, 6, 19),
    title: 'The Nighthold',
    criteria: [
      { achievement_id: 11192, quality: :epic, name: "Cutting Edge: Gul'dan", icon: 'achievement_thenighthold_guldan' },
      { achievement_id: 11195, quality: :rare, name: "Ahead of the Curve: Gul'dan", icon: 'achievement_thenighthold_guldan' },
    ],
  },
  21 => {
    from: Date.new(2017, 6, 20),
    to: Date.new(2017, 11, 27),
    title: 'Tomb of Sargeras',
    criteria: [
      { achievement_id: 11875, quality: :epic, name: "Cutting Edge: Kil'jaeden", icon: 'achievement_boss_kiljaeden2' },
      { achievement_id: 11874, quality: :rare, name: "Ahead of the Curve: Kil'jaeden", icon: 'achievement_boss_kiljaeden2' },
    ],
  },
  22 => {
    from: Date.new(2017, 11, 28),
    to: Date.new(2018, 8, 13),
    title: 'Antorus, the Burning Throne',
    criteria: [
      { achievement_id: 12111, quality: :epic, name: "Cutting Edge: Argus the Unmaker", icon: 'achievement_boss_argus_worldsoul' },
      { achievement_id: 12110, quality: :rare, name: "Ahead of the Curve: Argus the Unmaker", icon: 'achievement_boss_argus_worldsoul' },
    ],
  },
  23 => {
    from: Date.new(2018, 8, 14),
    to: Date.new(2019, 1, 21),
    title: 'Uldir',
    criteria: [
      { achievement_id: 12535, quality: :legendary, name: "Hall of Fame: G'huun (Horde)", icon: 'achievement_nazmir_boss_ghuun', time_sensitive: Date.new(2018, 10, 16) },
      { achievement_id: 12535, quality: :epic, name: "Cutting Edge: G'huun", icon: 'achievement_nazmir_boss_ghuun' },
      { achievement_id: 12536, quality: :rare, name: "Ahead of the Curve: G'huun", icon: 'achievement_nazmir_boss_ghuun' },
    ],
  },
  24 => {
    from: Date.new(2019, 1, 22),
    to: Date.new(2019, 4, 15),
    title: "Battle of Dazar'alor",
    criteria: [
      { achievement_id: 13323, quality: :legendary, name: "Hall of Fame: Lady Jaina Proudmoore (Horde)", icon: 'achievement_boss_zuldazar_jaina', time_sensitive: Date.new(2019, 3, 12) },
      { achievement_id: 13323, quality: :epic, name: "Cutting Edge: Lady Jaina Proudmoore", icon: 'achievement_boss_zuldazar_jaina' },
      { achievement_id: 13322, quality: :rare, name: "Ahead of the Curve: Lady Jaina Proudmoore", icon: 'achievement_boss_zuldazar_jaina' },
    ],
  },
  25 => {
    from: Date.new(2019, 4, 16),
    to: Date.new(2019, 7, 8),
    title: 'Crucible of Storms',
    criteria: [
      { achievement_id: 13419, quality: :legendary, name: "Hall of Fame: Uu'nat, Harbinger of the Void (Horde)", icon: 'achievement_uunat', time_sensitive: Date.new(2019, 6, 18) },
      { achievement_id: 13419, quality: :epic, name: "Cutting Edge: Uu'nat, Harbinger of the Void", icon: 'achievement_uunat' },
      { achievement_id: 13418, quality: :rare, name: "Ahead of the Curve: Uu'nat, Harbinger of the Void", icon: 'achievement_uunat' },
    ],
  },
  26 => {
    from: Date.new(2019, 7, 9),
    to: Date.new(2020, 1, 20),
    title: 'The Eternal Palace',
    criteria: [
      { achievement_id: 13785, quality: :legendary, name: "Hall of Fame: Queen Azshara (Horde)", icon: 'achievement_boss_azshara', time_sensitive: Date.new(2019, 9, 10) },
      { achievement_id: 13779, quality: :legendary, name: "Phenomenal Cosmic Power", icon: "inv_heartofazeroth" },
      { achievement_id: 13785, quality: :epic, name: "Cutting Edge: Queen Azshara", icon: 'achievement_boss_azshara' },
      { achievement_id: 13784, quality: :rare, name: "Ahead of the Curve: Queen Azshara", icon: 'achievement_boss_azshara' },
    ],
  },
  27 => {
    from: Date.new(2020, 1, 21),
    to: Date.new(2020, 11, 22),
    title: "Ny'alotha, the Waking City",
    criteria: [
      { achievement_id: 14069, quality: :legendary, name: "Hall of Fame: N'zoth the Corruptor (Horde)", icon: 'achievement_nzothraid_nzoth', time_sensitive: Date.new(2020, 3, 17) },
      { achievement_id: 14069, quality: :epic, name: "Cutting Edge: N'zoth the Corruptor", icon: 'achievement_nzothraid_nzoth' },
      { achievement_id: 14068, quality: :rare, name: "Ahead of the Curve: N'zoth the Corruptor", icon: 'achievement_nzothraid_nzoth' },
    ],
  },
  28 => {
    from: Date.new(2020, 11, 23),
    to: Date.new(2021, 7, 5),
    title: "Castle Nathria",
    criteria: [
      { achievement_id: 14461, quality: :legendary, name: "Hall of Fame: Sire Denathrius (Horde)", icon: 'achievement_raid_revendrethraid_siredenathrius', time_sensitive: Date.new(2021, 2, 8) },
      { achievement_id: 14461, quality: :epic, name: "Cutting Edge: Sire Denathrius", icon: 'achievement_raid_revendrethraid_siredenathrius' },
      { achievement_id: 14460, quality: :rare, name: "Ahead of the Curve: Sire Denathrius", icon: 'achievement_raid_revendrethraid_siredenathrius' },
    ],
  },
  29 => {
    from: Date.new(2021, 7, 6),
    to: Date.new(2022, 2, 28),
    title: "Sanctum of Domination",
    criteria: [
      { achievement_id: 15135, quality: :legendary, name: "Hall of Fame: Sylvanas Windrunner (Horde)", icon: 'achievement_raid_torghast_sylvanaswindrunner', time_sensitive: Date.new(2021, 8, 17) },
      { achievement_id: 15135, quality: :epic, name: "Cutting Edge: Sylvanas Windrunner", icon: 'achievement_raid_torghast_sylvanaswindrunner' },
      { achievement_id: 15134, quality: :rare, name: "Ahead of the Curve: Sylvanas Windrunner", icon: 'achievement_raid_torghast_sylvanaswindrunner' },
    ],
  },
  30 => {
    from: Date.new(2022, 3, 1),
    to: Date.new(2022, 11, 27),
    title: "Sepulcher of the First Ones",
    criteria: [
      { achievement_id: 15471, quality: :legendary, name: "Hall of Fame: The Jailer (Horde)", icon: 'inv_achievement_raid_progenitorraid_jailer', time_sensitive: Date.new(2022, 5, 17) },
      { achievement_id: 15471, quality: :epic, name: "Cutting Edge: The Jailer", icon: 'inv_achievement_raid_progenitorraid_jailer' },
      { achievement_id: 15470, quality: :rare, name: "Ahead of the Curve: The Jailer", icon: 'inv_achievement_raid_progenitorraid_jailer' },
    ],
  },
  31 => {
    from: Date.new(2022, 11, 28),
    to: Date.new(2023, 5, 8),
    title: "Vault of the Incarnates",
    criteria: [
      { achievement_id: 17108, quality: :legendary, name: "Hall of Fame: Raszageth the Storm-Eater (Horde)", icon: 'achievement_raidprimalist_raszageth', time_sensitive: Date.new(2023, 2, 14) },
      { achievement_id: 17108, quality: :epic, name: "Cutting Edge: Raszageth the Storm-Eater", icon: 'achievement_raidprimalist_raszageth' },
      { achievement_id: 17107, quality: :rare, name: "Ahead of the Curve: Raszageth the Storm-Eater", icon: 'achievement_raidprimalist_raszageth' },
    ],
  },
  32 => {
    from: Date.new(2023, 5, 9),
    to: Date.new(2023, 11, 13),
    title: "Aberrus, the Shadowed Crucible",
    criteria: [
      { achievement_id: 18254, quality: :legendary, name: "Hall of Fame: Scalecommander Sarkareth", icon: 'inv_achievement_raiddragon_sarkareth', time_sensitive: Date.new(2023, 6, 27) },
      { achievement_id: 18254, quality: :epic, name: "Cutting Edge: Scalecommander Sarkareth", icon: 'inv_achievement_raiddragon_sarkareth' },
      { achievement_id: 18253, quality: :rare, name: "Ahead of the Curve: Scalecommander Sarkareth", icon: 'inv_achievement_raiddragon_sarkareth' },
    ],
  },
  33 => {
    from: Date.new(2023, 11, 14),
    to: Date.new(2024, 8, 25),
    title: "Amirdrassil, the Dream's Hope",
    criteria: [
      { achievement_id: 19351, quality: :legendary, name: "Hall of Fame: Fyrakk the Blazing", icon: 'inv_achievement_raidemeralddream_fyrakk', time_sensitive: Date.new(2024, 2, 6) },
      { achievement_id: 19351, quality: :epic, name: "Cutting Edge: Fyrakk the Blazing", icon: 'inv_achievement_raidemeralddream_fyrakk' },
      { achievement_id: 19350, quality: :rare, name: "Ahead of the Curve: Fyrakk the Blazing", icon: 'inv_achievement_raidemeralddream_fyrakk' },
    ],
  },
  34 => {
    from: Date.new(2024, 8, 26),
    to: Date.new(2025, 2, 24),
    title: 'Nerub-ar Palace',
    criteria: [
      { achievement_id: 40254, quality: :legendary, name: "Hall of Fame: Queen Ansurek", icon: 'inv_achievement_raidnerubian_queenansurek', time_sensitive: Date.new(2024, 11, 19) },
      { achievement_id: 40254, quality: :epic, name: "Cutting Edge: Queen Ansurek", icon: 'inv_achievement_raidnerubian_queenansurek' },
      { achievement_id: 40253, quality: :rare, name: "Ahead of the Curve: Queen Ansurek", icon: 'inv_achievement_raidnerubian_queenansurek' },
    ],
  },
  35 => {
    from: Date.new(2025, 2, 25),
    to: Date.new(2025, 8, 11),
    title: 'Liberation of Undermine',
    criteria: [
      { achievement_id: 41297, quality: :legendary, name: "Hall of Fame: Chrome King Gallywix", icon: 'inv_111_raid_achievement_chromekinggallywix', time_sensitive: Date.new(2025, 5, 6) },
      { achievement_id: 41297, quality: :epic, name: "Cutting Edge: Chrome King Gallywix", icon: 'inv_111_raid_achievement_chromekinggallywix' },
      { achievement_id: 41298, quality: :rare, name: "Ahead of the Curve: Chrome King Gallywix", icon: 'inv_111_raid_achievement_chromekinggallywix' },
    ],
  },
  36 => {
    from: Date.new(2025, 8, 12),
    to: Date.new(2026, 3, 1),
    title: 'Manaforge Omega',
    criteria: [
      { achievement_id: 41625, quality: :legendary, name: "Hall of Fame: Dimensius, the All-Devouring", icon: 'inv_112_achievement_raid_dimensius', time_sensitive: Date.new(2025, 10, 7) },
      { achievement_id: 41625, quality: :epic, name: "Cutting Edge: Dimensius, the All-Devouring", icon: 'inv_112_achievement_raid_dimensius' },
      { achievement_id: 41624, quality: :rare, name: "Ahead of the Curve: Dimensius, the All-Devouring", icon: 'inv_112_achievement_raid_dimensius' },
    ],
  },
}
