CURRENT_VERSION = 1008

TIME_ZONE = 'Europe/Amsterdam'
HOUR = (1.0 / 24)

SCHEDULER_PAUSE_AFTER_CYCLE = 1 #seconds

WCL_URL = "https://www.warcraftlogs.com:443/v1/rankings/character/{name}/{realm}/{region}?zone={zone}&metric={metric}&timeframe=historical&api_key={key}"

RAIDER_IO_URL = "https://raider.io/api/v1/characters/profile?region={region}&realm={realm}&name={name}&fields=mythic_plus_scores_by_season:current,mythic_plus_highest_level_runs,mythic_plus_weekly_highest_level_runs,mythic_plus_recent_runs"

# UTC times
EXPANSION_START = Date.new(2022, 11, 29)

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
  "weekly_Brackenhide Hollow",
  "weekly_Halls of Infusion",
  "weekly_Neltharus",
  "weekly_Ruby Life Pools",
  "weekly_Algeth'ar Academy",
  "weekly_The Azure Vault",
  "weekly_The Nokhud Offensive",
  "weekly_Uldaman: Legacy of Tyr",
  'court_of_stars_total',
  'court_of_stars_score',
  'enchant_quality_wrist',
  'enchant_quality_legs',
  'enchant_quality_main_hand',
  'enchant_quality_off_hand',
  'enchant_quality_finger_1',
  'enchant_quality_finger_2',
  'empty_sockets',
  'race',
  'role',
  'dungeons_done_total',
  'weekly_regular_dungeons_done',
  'ruby_life_pools_total',
  'ruby_life_pools_score',
  'the_nokhud_offensive_total',
  'the_nokhud_offensive_score',
  'the_azure_vault_total',
  'the_azure_vault_score',
  'algethar_academy_total',
  "algethar_academy_score",
  'halls_of_valor_total',
  'halls_of_valor_score',
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
  'enchant_quality_feet',
  'back_enchant',
  'chest_enchant',
  'feet_enchant',
  'aiding_the_accord',
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
  'weekly_feast',
  'weekly_event_completed',
  'titles',
  'cutting_edge',
  'ahead_of_the_curve',
  'quests_done_total',
  'dailies_done_total',
  'shadowmoon_burial_grounds_total',
  'shadowmoon_burial_grounds_score',
  'temple_of_the_jade_serpent_total',
  'temple_of_the_jade_serpent_score',
  'great_vault_slot_1',
  'great_vault_slot_2',
  'great_vault_slot_3',
  'great_vault_slot_4',
  'great_vault_slot_5',
  'great_vault_slot_6',
  'great_vault_slot_7',
  'great_vault_slot_8',
  'great_vault_slot_9',
  'dragonscale_expedition_renown',
  'maruuk_centaur_renown',
  'iskaara_tuskarr_renown',
  'valdrakken_accord_renown',
  'total_renown_score',
  'court_of_stars_total',
  'court_of_stars_score',
  'enchant_quality_neck',
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
  'food_embellishment',
]
