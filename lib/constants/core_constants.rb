CURRENT_VERSION = {
  live: 1031,
  classic_era: 105,
  classic_progression: 308,
}

PREVENT_SKIP_TIMESTAMP = Time.parse("2025-03-03 22:30:00 +0200").to_i

TIME_ZONE = 'Europe/Amsterdam'
HOUR = (1.0 / 24)

SCHEDULER_PAUSE_AFTER_CYCLE = 1 #seconds

WCL_URL = "https://www.warcraftlogs.com:443/v1/rankings/character/{name}/{realm}/{region}?zone={zone}&metric={metric}&timeframe=historical&api_key={key}"

RAIDER_IO_URL = "https://raider.io/api/v1/characters/profile?region={region}&realm={realm}&name={name}&fields=mythic_plus_scores_by_season:current,mythic_plus_highest_level_runs,mythic_plus_weekly_highest_level_runs,mythic_plus_recent_runs"

DAILY_RESET = {
  'EU' => 4,
  'US' => 15,
  'KR' => 2,
  'TW' => 2
}

WEEKLY_RESET = {
  'EU' => {
    'hour' => 4,
    'day' => "Wednesday"
  },
  'US' => {
    'hour' => 15,
    'day' => "Tuesday"
  },
  'KR' => {
    'hour' => 2,
    'day' => "Thursday"
  },
  'TW' => {
    'hour' => 2,
    'day' => "Thursday"
  }
}

FIELDS = {
  live: [
    :achievements,
    :achievement_statistics,
    :completed_quests,
    :equipment,
    :mounts, # Only needed to track Mythic raid mounts, when relevant
    :pets,
    :professions,
    :pvp_bracket_2v2,
    :pvp_bracket_3v3,
    :pvp_bracket_rbg,
    :pvp_summary,
    :season_keystones,
    :reputations,
    :status,
    :titles,
  ],
  classic_era: [
    :equipment,
    :pvp_summary,
    :status,
  ],
  classic_progression: [
    :equipment,
    :achievements,
    :achievement_statistics,
    :pvp_summary,
    :pvp_bracket_2v2,
    :pvp_bracket_3v3,
    :pvp_bracket_5v5,
    :status,
  ]
}

HEADER = {
  live: [
    'name',
    'class',
    'realm_slug',
    'ilvl',
    'gender',
    'faction',
    'head_ilvl',
    'head_id',
    'head_name',
    'head_quality',
    'neck_ilvl',
    'neck_id',
    'neck_name',
    'neck_quality',
    'shoulder_ilvl',
    'shoulder_id',
    'shoulder_name',
    'shoulder_quality',
    'back_ilvl',
    'back_id',
    'back_name',
    'back_quality',
    'chest_ilvl',
    'chest_id',
    'chest_name',
    'chest_quality',
    'wrist_ilvl',
    'wrist_id',
    'wrist_name',
    'wrist_quality',
    'hands_ilvl',
    'hands_id',
    'hands_name',
    'hands_quality',
    'waist_ilvl',
    'waist_id',
    'waist_name',
    'waist_quality',
    'legs_ilvl',
    'legs_id',
    'legs_name',
    'legs_quality',
    'feet_ilvl',
    'feet_id',
    'feet_name',
    'feet_quality',
    'finger_1_ilvl',
    'finger_1_id',
    'finger_1_name',
    'finger_1_quality',
    'finger_2_ilvl',
    'finger_2_id',
    'finger_2_name',
    'finger_2_quality',
    'trinket_1_ilvl',
    'trinket_1_id',
    'trinket_1_name',
    'trinket_1_quality',
    'trinket_2_ilvl',
    'trinket_2_id',
    'trinket_2_name',
    'trinket_2_quality',
    'main_hand_ilvl',
    'main_hand_id',
    'main_hand_name',
    'main_hand_quality',
    'off_hand_ilvl',
    'off_hand_id',
    'off_hand_name',
    'off_hand_quality',
    'WCL_raid_finder',
    'WCL_normal',
    'WCL_heroic',
    'WCL_mythic',
    "week_heroic_dungeons",
    "season_heroic_dungeons",
    "week_delves",
    "season_delves",
    "worldsoul_memories",
    "awakening_the_machine",
    "coffer_keys",
    "weathered_crests",
    'toys_owned',
    'carved_crests',
    'enchant_quality_wrist',
    'enchant_quality_legs',
    'enchant_quality_main_hand',
    'enchant_quality_off_hand',
    'enchant_quality_finger_1',
    'enchant_quality_finger_2',
    'empty_sockets',
    'race',
    'role',
    'season_mythic_dungeons',
    'runed_crests',
    'operation_floodgate_total',
    'operation_floodgate_score',
    'cinderbrew_meadery_total',
    'cinderbrew_meadery_score',
    'the_rookery_total',
    'the_rookery_score',
    'darkflame_cleft_total',
    "darkflame_cleft_score",
    'priory_of_the_sacred_flame_total',
    'priory_of_the_sacred_flame_score',
    'week_mythic_dungeons',
    'wqs_done_total',
    'wqs_this_week',
    'note',
    'achievement_points',
    'mounts',
    'exalted_amount',
    'unique_pets',
    'lvl_25_pets',
    'realm',
    'join_date',
    'main_hand_enchant',
    'off_hand_enchant',
    'finger_1_enchant',
    'finger_2_enchant',
    'gem_list',
    'enchant_quality_back',
    'enchant_quality_chest',
    'enchant_quality_feet',
    'back_enchant',
    'chest_enchant',
    'feet_enchant',
    'theater_troupe',
    'blizzard_last_modified',
    'rank',
    'wrist_enchant',
    'legs_enchant',
    'highest_ilvl_ever_equipped',
    'character_id',
    'historical_wqs_done',
    'historical_mplus_done',
    'historical_dungeons_done',
    'raids_raid_finder',
    'raids_raid_finder_weekly',
    'raids_normal',
    'raids_normal_weekly',
    'raids_heroic',
    'raids_heroic_weekly',
    'raids_mythic',
    'raids_mythic_weekly',
    'honor_level',
    '2v2_rating',
    '2v2_season_played',
    '2v2_week_played',
    'honorable_kills',
    '3v3_rating',
    '3v3_season_played',
    '3v3_week_played',
    'rbg_rating',
    'rbg_season_played',
    'rbg_week_played',
    'max_2v2_rating',
    'max_3v3_rating',
    'm+_score',
    'weekly_highest_m+',
    'season_highest_m+',
    'profession_1',
    'profession_2',
    'worldsoul_weekly',
    'weekly_event_completed',
    'titles',
    'cutting_edge',
    'ahead_of_the_curve',
    'quests_done_total',
    'dailies_done_total',
    'operation_mechagon_workshop_total',
    'operation_mechagon_workshop_score',
    'theater_of_pain_total',
    'theater_of_pain_score',
    'great_vault_slot_1',
    'great_vault_slot_2',
    'great_vault_slot_3',
    'great_vault_slot_4',
    'great_vault_slot_5',
    'great_vault_slot_6',
    'great_vault_slot_7',
    'great_vault_slot_8',
    'great_vault_slot_9',
    'assembly_of_the_deeps_renown',
    'council_of_dornogal_renown',
    'hallowfall_arathi_renown',
    'severed_threads_renown',
    'total_renown_score',
    'the_motherlode_total',
    'the_motherlode_score',
    'jewelry_sockets',
    'ingenuity_sparks_equipped',
    'best_head_ilvl',
    'best_head_id',
    'best_head_name',
    'best_head_quality',
    'best_neck_ilvl',
    'best_neck_id',
    'best_neck_name',
    'best_neck_quality',
    'best_shoulder_ilvl',
    'best_shoulder_id',
    'best_shoulder_name',
    'best_shoulder_quality',
    'best_back_ilvl',
    'best_back_id',
    'best_back_name',
    'best_back_quality',
    'best_chest_ilvl',
    'best_chest_id',
    'best_chest_name',
    'best_chest_quality',
    'best_wrist_ilvl',
    'best_wrist_id',
    'best_wrist_name',
    'best_wrist_quality',
    'best_hands_ilvl',
    'best_hands_id',
    'best_hands_name',
    'best_hands_quality',
    'best_waist_ilvl',
    'best_waist_id',
    'best_waist_name',
    'best_waist_quality',
    'best_legs_ilvl',
    'best_legs_id',
    'best_legs_name',
    'best_legs_quality',
    'best_feet_ilvl',
    'best_feet_id',
    'best_feet_name',
    'best_feet_quality',
    'best_finger_1_ilvl',
    'best_finger_1_id',
    'best_finger_1_name',
    'best_finger_1_quality',
    'best_finger_2_ilvl',
    'best_finger_2_id',
    'best_finger_2_name',
    'best_finger_2_quality',
    'best_trinket_1_ilvl',
    'best_trinket_1_id',
    'best_trinket_1_name',
    'best_trinket_1_quality',
    'best_trinket_2_ilvl',
    'best_trinket_2_id',
    'best_trinket_2_name',
    'best_trinket_2_quality',
    'best_main_hand_ilvl',
    'best_main_hand_id',
    'best_main_hand_name',
    'best_main_hand_quality',
    'best_off_hand_ilvl',
    'best_off_hand_id',
    'best_off_hand_name',
    'best_off_hand_quality',
    'historical_great_vault_slot_1',
    'historical_great_vault_slot_2',
    'historical_great_vault_slot_3',
    'historical_great_vault_slot_4',
    'historical_great_vault_slot_5',
    'historical_great_vault_slot_6',
    'historical_great_vault_slot_7',
    'historical_great_vault_slot_8',
    'historical_great_vault_slot_9',
    'tier_head_ilvl',
    'tier_shoulder_ilvl',
    'tier_chest_ilvl',
    'tier_hands_ilvl',
    'tier_legs_ilvl',
    'tier_head_difficulty',
    'tier_shoulder_difficulty',
    'tier_chest_difficulty',
    'tier_hands_difficulty',
    'tier_legs_difficulty',
    'embellished_item_id_1',
    'embellished_item_level_1',
    'embellished_spell_id_1',
    'embellished_spell_name_1',
    'embellished_item_id_2',
    'embellished_item_level_2',
    'embellished_spell_id_2',
    'embellished_spell_name_2',
    'profession_recipes',
    'spark_head_ilvl',
    'spark_head_id',
    'spark_head_name',
    'spark_head_quality',
    'spark_neck_ilvl',
    'spark_neck_id',
    'spark_neck_name',
    'spark_neck_quality',
    'spark_shoulder_ilvl',
    'spark_shoulder_id',
    'spark_shoulder_name',
    'spark_shoulder_quality',
    'spark_back_ilvl',
    'spark_back_id',
    'spark_back_name',
    'spark_back_quality',
    'spark_chest_ilvl',
    'spark_chest_id',
    'spark_chest_name',
    'spark_chest_quality',
    'spark_wrist_ilvl',
    'spark_wrist_id',
    'spark_wrist_name',
    'spark_wrist_quality',
    'spark_hands_ilvl',
    'spark_hands_id',
    'spark_hands_name',
    'spark_hands_quality',
    'spark_waist_ilvl',
    'spark_waist_id',
    'spark_waist_name',
    'spark_waist_quality',
    'spark_legs_ilvl',
    'spark_legs_id',
    'spark_legs_name',
    'spark_legs_quality',
    'spark_feet_ilvl',
    'spark_feet_id',
    'spark_feet_name',
    'spark_feet_quality',
    'spark_finger_1_ilvl',
    'spark_finger_1_id',
    'spark_finger_1_name',
    'spark_finger_1_quality',
    'spark_finger_2_ilvl',
    'spark_finger_2_id',
    'spark_finger_2_name',
    'spark_finger_2_quality',
    'spark_trinket_1_ilvl',
    'spark_trinket_1_id',
    'spark_trinket_1_name',
    'spark_trinket_1_quality',
    'spark_trinket_2_ilvl',
    'spark_trinket_2_id',
    'spark_trinket_2_name',
    'spark_trinket_2_quality',
    'spark_main_hand_ilvl',
    'spark_main_hand_id',
    'spark_main_hand_name',
    'spark_main_hand_quality',
    'spark_off_hand_ilvl',
    'spark_off_hand_id',
    'spark_off_hand_name',
    'spark_off_hand_quality',
    'shuffle_rating',
    'shuffle_season_played',
    'shuffle_week_played',
    'epic_gem',
    'professions_visible',
    'circlet_ilvl',
    'circlet_singing_thunder_name',
    'circlet_singing_sea_name',
    'circlet_singing_wind_name',
    'head_enchant_level',
    'raid_buff_percentage',
    'head_enchant',
    'gallywix_mount',
    'ansurek_mount',
    'gilded_crests',
    'upgrade_level_head',
    'upgrade_level_neck',
    'upgrade_level_shoulder',
    'upgrade_level_back',
    'upgrade_level_chest',
    'upgrade_level_wrist',
    'upgrade_level_hands',
    'upgrade_level_waist',
    'upgrade_level_legs',
    'upgrade_level_feet',
    'upgrade_level_finger_1',
    'upgrade_level_finger_2',
    'upgrade_level_trinket_1',
    'upgrade_level_trinket_2',
    'upgrade_level_main_hand',
    'upgrade_level_off_hand',
    'total_upgrades_missing',
    'valorstones',
    'summary_visible',
    'roster_visible',
    'overview_visible',
    'vault_visible',
    'raids_visible',
    'crit_gear_percentage',
    'haste_gear_percentage',
    'mastery_gear_percentage',
    'vers_gear_percentage',
    'crit_enchant_percentage',
    'haste_enchant_percentage',
    'mastery_enchant_percentage',
    'vers_enchant_percentage',
    'mythic_track_items',
    'heroic_track_items',
    'normal_track_items',
    'raid_finder_track_items',
    'world_advanced_track_items',
    'world_basic_track_items',
    'cartels_of_undermine_renown',
    'gallagio_loyalty_rewards_club_renown',
    'waist_spell',
  ],
  classic_era: [
    'name',
    'class',
    'realm_slug',
    'ilvl',
    'gender',
    'faction',
    'head_ilvl',
    'head_id',
    'head_name',
    'head_quality',
    'neck_ilvl',
    'neck_id',
    'neck_name',
    'neck_quality',
    'shoulder_ilvl',
    'shoulder_id',
    'shoulder_name',
    'shoulder_quality',
    'back_ilvl',
    'back_id',
    'back_name',
    'back_quality',
    'chest_ilvl',
    'chest_id',
    'chest_name',
    'chest_quality',
    'wrist_ilvl',
    'wrist_id',
    'wrist_name',
    'wrist_quality',
    'hands_ilvl',
    'hands_id',
    'hands_name',
    'hands_quality',
    'waist_ilvl',
    'waist_id',
    'waist_name',
    'waist_quality',
    'legs_ilvl',
    'legs_id',
    'legs_name',
    'legs_quality',
    'feet_ilvl',
    'feet_id',
    'feet_name',
    'feet_quality',
    'finger_1_ilvl',
    'finger_1_id',
    'finger_1_name',
    'finger_1_quality',
    'finger_2_ilvl',
    'finger_2_id',
    'finger_2_name',
    'finger_2_quality',
    'trinket_1_ilvl',
    'trinket_1_id',
    'trinket_1_name',
    'trinket_1_quality',
    'trinket_2_ilvl',
    'trinket_2_id',
    'trinket_2_name',
    'trinket_2_quality',
    'main_hand_ilvl',
    'main_hand_id',
    'main_hand_name',
    'main_hand_quality',
    'off_hand_ilvl',
    'off_hand_id',
    'off_hand_name',
    'off_hand_quality',
    "", #'WCL_raid_finder',
    "", #'WCL_normal',
    "", #'WCL_heroic',
    "", #'WCL_mythic',
    "ranged_ilvl",
    "ranged_id",
    "ranged_name",
    "ranged_quality",
    "main_hand_enchant_quality",
    "off_hand_enchant_quality",
    "ranged_enchant_quality",
    'head_enchant_quality',
    "shoulder_enchant_quality",
    "back_enchant_quality",
    "chest_enchant_quality",
    "wrist_enchant_quality",
    "hands_enchant_quality",
    "legs_enchant_quality",
    "feet_enchant_quality",
    "",
    "level",
    'race',
    'role',
    "",
    "main_hand_enchant_name",
    "off_hand_enchant_name",
    "ranged_enchant_name",
    'head_enchant_name',
    "shoulder_enchant_name",
    "back_enchant_name",
    "chest_enchant_name",
    "wrist_enchant_name",
    "hands_enchant_name",
    "legs_enchant_name",
    "feet_enchant_name",
    "",
    "",
    "",
    'note',
    "tier_2.5_head",
    "tier_2.5_shoulder",
    "tier_2.5_chest",
    "tier_2.5_legs",
    "tier_2.5_feet",
    'realm',
    'join_date',
    "tier_1_head",
    "tier_1_shoulder",
    "tier_1_chest",
    "tier_1_wrist",
    "tier_1_hands",
    "tier_1_waist",
    "tier_1_legs",
    "tier_1_feet",
    "tier_1_status",
    "tier_2_status",
    "tier_2.5_status",
    "tier_3_status",
    'blizzard_last_modified',
    'rank',
    "",
    "",
    'highest_ilvl_ever_equipped',
    'character_id',
    "legendary_sulfuras",
    "legendary_thunderfury",
    "legendary_atiesh",
    "", #'raids_raid_finder',
    "", #'raids_raid_finder_weekly',
    "", #'raids_normal',
    "", #'raids_normal_weekly',
    "", #'raids_heroic',
    "", #'raids_heroic_weekly',
    "", #'raids_mythic',
    "", #'raids_mythic_weekly',
    'honor_level',
    "honor_title",
    "",
    "makgora_duels_won",
    'honorable_kills',
    "tier_2_head",
    "tier_2_shoulder",
    "tier_2_chest",
    "tier_2_wrist",
    "tier_2_hands",
    "tier_2_waist",
    "tier_2_legs",
    "tier_2_feet",
    "tier_3_head",
    "tier_3_shoulder",
    "tier_3_chest",
    "tier_3_wrist",
    "tier_3_hands",
    "tier_3_waist",
    "tier_3_legs",
    "tier_3_feet",
    "tier_3_finger",
    'summary_visible',
    'roster_visible',
    'overview_visible',
    'vault_visible',
    'raids_visible',
  ],
  classic_progression: [
    'name',
    'class',
    'realm_slug',
    'ilvl',
    'gender',
    'faction',
    'head_ilvl',
    'head_id',
    'head_name',
    'head_quality',
    'neck_ilvl',
    'neck_id',
    'neck_name',
    'neck_quality',
    'shoulder_ilvl',
    'shoulder_id',
    'shoulder_name',
    'shoulder_quality',
    'back_ilvl',
    'back_id',
    'back_name',
    'back_quality',
    'chest_ilvl',
    'chest_id',
    'chest_name',
    'chest_quality',
    'wrist_ilvl',
    'wrist_id',
    'wrist_name',
    'wrist_quality',
    'hands_ilvl',
    'hands_id',
    'hands_name',
    'hands_quality',
    'waist_ilvl',
    'waist_id',
    'waist_name',
    'waist_quality',
    'legs_ilvl',
    'legs_id',
    'legs_name',
    'legs_quality',
    'feet_ilvl',
    'feet_id',
    'feet_name',
    'feet_quality',
    'finger_1_ilvl',
    'finger_1_id',
    'finger_1_name',
    'finger_1_quality',
    'finger_2_ilvl',
    'finger_2_id',
    'finger_2_name',
    'finger_2_quality',
    'trinket_1_ilvl',
    'trinket_1_id',
    'trinket_1_name',
    'trinket_1_quality',
    'trinket_2_ilvl',
    'trinket_2_id',
    'trinket_2_name',
    'trinket_2_quality',
    'main_hand_ilvl',
    'main_hand_id',
    'main_hand_name',
    'main_hand_quality',
    'off_hand_ilvl',
    'off_hand_id',
    'off_hand_name',
    'off_hand_quality',
    "", #'WCL_raid_finder',
    "", #'WCL_normal',
    "", #'WCL_heroic',
    "", #'WCL_mythic',
    "ranged_ilvl",
    "ranged_id",
    "ranged_name",
    "ranged_quality",
    "main_hand_enchant_quality",
    "off_hand_enchant_quality",
    "ranged_enchant_quality",
    '',
    "shoulder_enchant_quality",
    "back_enchant_quality",
    "chest_enchant_quality",
    "wrist_enchant_quality",
    "hands_enchant_quality",
    "legs_enchant_quality",
    "feet_enchant_quality",
    "waist_enchant_quality",
    "level",
    'race',
    'role',
    "",
    "main_hand_enchant_name",
    "off_hand_enchant_name",
    "ranged_enchant_name",
    '',
    "shoulder_enchant_name",
    "back_enchant_name",
    "chest_enchant_name",
    "wrist_enchant_name",
    "hands_enchant_name",
    "legs_enchant_name",
    "feet_enchant_name",
    "waist_enchant_name",
    "gem_list",
    "empty_sockets",
    'note',
    "tier_16_head",
    "tier_16_shoulder",
    "tier_16_chest",
    "tier_16_legs",
    "tier_16_hands",
    'realm',
    'join_date',
    "tier_14_head",
    "tier_14_shoulder",
    "tier_14_chest",
    'achievement_points',
    "tier_14_hands",
    "exalted_amount",
    "tier_14_legs",
    "mounts_obtained",
    "tier_14_status",
    "tier_15_status",
    "tier_16_status",
    "wrathion_questline",
    'blizzard_last_modified',
    'rank',
    "meta_gem",
    "unique_pets",
    'highest_ilvl_ever_equipped',
    'character_id',
    "",
    "",
    "",
    "profession_1",
    "profession_1_benefits",
    'raids_normal',
    'raids_normal_weekly',
    'raids_heroic',
    'raids_heroic_weekly',
    "profession_2",
    "profession_2_benefits",
    '2v2_rating',
    '2v2_season_played',
    '2v2_week_played',
    'max_2v2_rating',
    'honorable_kills',
    "tier_15_head",
    "tier_15_shoulder",
    "tier_15_chest",
    "quests_done_total",
    "tier_15_hands",
    "dailies_done_total",
    "tier_15_legs",
    'summary_visible',
    'roster_visible',
    'overview_visible',
    'vault_visible',
    'raids_visible',
    "",
    "",
    "",
    '3v3_rating',
    '3v3_season_played',
    '3v3_week_played',
    'max_3v3_rating',
    '5v5_rating',
    '5v5_season_played',
    '5v5_week_played',
    'max_5v5_rating',
  ],
}

CHARACTER_IDENTIFICATION_IDS = [
  6, # Level 10
  131, # Journeyman Medic
  973, # 5 Daily Quests Completed
  14271, # WoW's 16th Anniversary
]
