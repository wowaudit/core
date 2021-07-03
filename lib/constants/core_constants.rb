CURRENT_VERSION = 910

TIME_ZONE = 'Europe/Amsterdam'
HOUR = (1.0 / 24)

SCHEDULER_PAUSE_AFTER_CYCLE = 1 #seconds

WCL_URL = "https://www.warcraftlogs.com:443/v1/rankings/character/{name}/{realm}/{region}?zone={zone}&metric={metric}&timeframe=historical&api_key={key}"

RAIDER_IO_URL = "https://raider.io/api/v1/characters/profile?region={region}&realm={realm}&name={name}&fields=mythic_plus_scores_by_season:current,mythic_plus_highest_level_runs,mythic_plus_weekly_highest_level_runs"

# UTC times
EXPANSION_START = Date.new(2020, 11, 24)

DAILY_RESET = {
  'EU' => 7,
  'US' => 15,
  'KR' => 2,
  'TW' => 2
}

WEEKLY_RESET = {
  'EU' => {
    'hour' => 5,
    'day' => "Wednesday"
  },
  'US' => {
    'hour' => 11,
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

HEADER = [
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
  'the_ascended_standing',
  'the_ascended_value',
  'court_of_harvesters_standing',
  'court_of_harvesters_value',
  'the_undying_army_standing',
  'the_undying_army_value',
  'the_wild_hunt_standing',
  'the_wild_hunt_value',
  'the_avowed_standing',
  'the_avowed_value',
  'venari_standing',
  'venari_value',
  'enchant_quality_main_hand',
  'enchant_quality_off_hand',
  'enchant_quality_finger_1',
  'enchant_quality_finger_2',
  'empty_sockets',
  'race',
  'role',
  'dungeons_done_total',
  'Halls of Atonement',
  'Mists of Tirna Scithe',
  'The Necrotic Wake',
  'De Other Side',
  'Plaguefall',
  'Sanguine Depths',
  'Spires of Ascension',
  'Theater of Pain',
  'Tazavesh, the Veiled Market',
  '', # Future dungeon
  '', # Future dungeon
  'dungeons_this_week',
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
  'enchant_quality_primary',
  'back_enchant',
  'chest_enchant',
  'primary_enchant',
  'renown_level',
  'blizzard_last_modified',
  'rank',
  'current_covenant',
  'current_soulbind',
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
  'torghast_floors',
  'weekly_event_completed',
  'titles',
  'cutting_edge',
  'ahead_of_the_curve',
  'quests_done_total',
  'dailies_done_total',
  'current_legendary_ilvl',
  'current_legendary_id',
  'current_legendary_name',
  '',
  'great_vault_slot_1',
  'great_vault_slot_2',
  'great_vault_slot_3',
  'great_vault_slot_4',
  'great_vault_slot_5',
  'great_vault_slot_6',
  'great_vault_slot_7',
  'great_vault_slot_8',
  'great_vault_slot_9',
  'conduit_1_ilvl',
  'conduit_1_id',
  'conduit_1_name',
  'conduit_2_ilvl',
  'conduit_2_id',
  'conduit_2_name',
  'conduit_3_ilvl',
  'conduit_3_id',
  'conduit_3_name',
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
  'torghast_layers_coldheart_interstitia',
  'torghast_layers_upper_reaches',
  'torghast_layers_skoldus_hall',
  'torghast_layers_mortregar',
  'torghast_layers_soulforges',
  'torghast_layers_fracture_chambers',
  'torghast_layers_twisting_corridors',
  'archivists_codex_standing',
  'archivists_codex_value',
  'deaths_advance_standing',
  'deaths_advance_value',
  'Halls of Atonement_score',
  'Mists of Tirna Scithe_score',
  'The Necrotic Wake_score',
  'De Other Side_score',
  'Plaguefall_score',
  'Sanguine Depths_score',
  'Spires of Ascension_score',
  'Theater of Pain_score',
  'Tazavesh, the Veiled Market_score',
  'conduit_4_ilvl',
  'conduit_4_id',
  'conduit_4_name',
  'conduit_5_ilvl',
  'conduit_5_id',
  'conduit_5_name',
  'conduit_6_ilvl',
  'conduit_6_id',
  'conduit_6_name',
]
