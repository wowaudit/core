CURRENT_VERSION = "8.0"

TIME_ZONE = 'Europe/Amsterdam'
HOUR = (1.0 / 24)

SCHEDULER_PAUSE_AFTER_CYCLE = 1 #seconds

WCL_URL = "https://www.warcraftlogs.com:443/v1/rankings/character/{name}/{realm}/{region}?zone={zone}&metric={metric}&partition={partition}&timeframe=historical&api_key=#{WCL_KEY}"

RAIDER_IO_URL = "https://raider.io/api/v1/characters/profile?region={region}&realm={realm}&name={name}&fields=mythic_plus_scores,mythic_plus_highest_level_runs,mythic_plus_weekly_highest_level_runs"

HONOR_URL = "https://worldofwarcraft.com/{region}/character/{realm}/{name}/pvp"

BNET_FIELDS = [
  "items",
  "reputation",
  "audit",
  "statistics",
  "achievements",
  "pets",
  "pvp",
  "mounts",
  "feed"
]

# UTC times
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
  'artifact_level',
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
  'finger1_ilvl',
  'finger1_id',
  'finger1_name',
  'finger1_quality',
  'finger2_ilvl',
  'finger2_id',
  'finger2_name',
  'finger2_quality',
  'trinket1_ilvl',
  'trinket1_id',
  'trinket1_name',
  'trinket1_quality',
  'trinket2_ilvl',
  'trinket2_id',
  'trinket2_name',
  'trinket2_quality',
  'mainhand_ilvl',
  'mainhand_id',
  'mainhand_name',
  'mainhand_quality',
  'offhand_ilvl',
  'offhand_id',
  'offhand_name',
  'offhand_quality',
  'WCL_raid_finder',
  'WCL_normal',
  'WCL_heroic',
  'WCL_mythic',
  'proudmoore_taljani_standing',
  'proudmoore_taljani_value',
  '7th_legion_zandalari_standing',
  '7th_legion_zandalari_value',
  'storms_wake_voldunai_standing',
  'storms_wake_voldunai_value',
  'order_of_embers_honorbound_standing',
  'order_of_embers_honorbound_value',
  'champions_of_azeroth_standing',
  'champions_of_azeroth_value',
  'tortollan_seekers_standing',
  'tortollan_seekers_value',
  'enchant_quality_main_hand',
  'enchant_quality_off_hand',
  'enchant_quality_finger1',
  'enchant_quality_finger2',
  'empty_sockets',
  'reputation_ranking',
  'role',
  'dungeons_done_total',
  'Atal\'Dazar',
  'Freehold',
  'King\'s Rest',
  'The MOTHERLODE!!',
  'Shrine of the Storm',
  'Siege of Boralus',
  'Temple of Sethraliss',
  'Tol Dagor',
  'Underrot',
  'Waycrest Manor',
  '', # Keep placeholder for future dungeon
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
  'finger1_enchant',
  'finger2_enchant',
  'gem_list', # IMPORTANT: Data is shifted after this column
  'rank',
  'ap_obtained_total',
  'ap_this_week',
  'current_spec_name',
  'highest_ilvl_ever_equipped',
  'character_id',
  'historical_wqs_done',
  'historical_ap_gained',
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
  'RBG_rating',
  'RBG_season_played',
  'RBG_week_played',
  'max_2v2_rating',
  'max_3v3_rating',
  'm+_score',
  'weekly_highest_m+',
  'season_highest_m+'
]
