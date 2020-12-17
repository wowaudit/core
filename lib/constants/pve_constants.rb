MYTHIC_DUNGEONS = {
  14392 => 'Halls of Atonement',
  14395 => 'Mists of Tirna Scithe',
  14404 => 'The Necrotic Wake',
  14389 => 'De Other Side',
  14398 => 'Plaguefall',
  14205 => 'Sanguine Depths',
  14401 => 'Spires of Ascension',
  14407 => 'Theater of Pain',
}

KEYSTONE_DUNGEONS = [375, 376, 377, 378, 379, 380, 381, 382]

WEEKLY_EVENT_QUESTS = [
  62631,
  62635,
  62636,
  62637,
  62638,
  62639,
  62640,
]

RAID_DIFFICULTIES = {
  1 => 'raid_finder',
  3 => 'normal',
  4 => 'heroic',
  5 => 'mythic'
}

TORGHAST_WINGS = {
  89002 => 'skoldus_hall',
  89003 => 'fracture_chambers',
  89004 => 'soulforges',
  89005 => 'coldheart_interstitia',
  89006 => 'mortregar',
  89007 => 'upper_reaches',
}

TORGHAST_TWISTING_CORRIDORS_IDS = [
  14468, 14469, 14470, 14471, 14472, 14568, 14569, 14570
]

GREAT_VAULT_RAID_KILLS_NEEDED = {
  1 => 3,
  2 => 7,
  3 => 10,
}

GREAT_VAULT_TO_ILVL = {
  'raid' => {
    'mythic' => 226,
    'heroic' => 213,
    'normal' => 200,
    'raid_finder' => 187,
  },
  'dungeon' => {
    14 => 226,
    13 => 223,
    12 => 223,
    11 => 220,
    10 => 220,
    9 => 216,
    8 => 216,
    7 => 213,
    6 => 210,
    5 => 210,
    4 => 207,
    3 => 203,
    2 => 200,
    0 => '',
  },
  'pvp' => {
    2100 => 226,
    1800 => 220,
    1600 => 213,
    1400 => 207,
    0 => 200,
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
]

VALID_RAIDS = [{
  'name' => 'Castle Nathria', 'days' => [0, 1, 2, 3, 4, 5, 6], 'id' => 26,
  'encounters' => [{
    'id' => 2398, 'name' => 'Shriekwing', 'raid_ids' => {
      'raid_finder' => [14422], 'normal' => [14419], 'heroic' => [14420], 'mythic' => [14421]
    }
  }, {
    'id' => 2418, 'name' => "Huntsman Altimor", 'raid_ids' => {
      'raid_finder' => [14426], 'normal' => [14423], 'heroic' => [14424], 'mythic' => [14425]
    }
  }, {
    'id' => 2383, 'name' => "Hungering Destroyer", 'raid_ids' => {
      'raid_finder' => [14430], 'normal' => [14427], 'heroic' => [14428], 'mythic' => [14429]
    }
  }, {
    'id' => 2402, 'name' => "Sun King's Salvation", 'raid_ids' => {
      'raid_finder' => [14438], 'normal' => [14435], 'heroic' => [14436], 'mythic' => [14437]
    }
  }, {
    'id' => 2405, 'name' => "Artificer Xy'mox", 'raid_ids' => {
      'raid_finder' => [14434], 'normal' => [14431], 'heroic' => [14432], 'mythic' => [14433]
    }
  }, {
    'id' => 2406, 'name' => "Lady Inerva Darkvein", 'raid_ids' => {
      'raid_finder' => [14442], 'normal' => [14439], 'heroic' => [14440], 'mythic' => [14441]
    }
  }, {
    'id' => 2412, 'name' => "The Council of Blood", 'raid_ids' => {
      'raid_finder' => [14446], 'normal' => [14443], 'heroic' => [14444], 'mythic' => [14445]
    }
  }, {
    'id' => 2399, 'name' => "Sludgefist", 'raid_ids' => {
      'raid_finder' => [14450], 'normal' => [14447], 'heroic' => [14448], 'mythic' => [14449]
    }
  }, {
    'id' => 2417, 'name' => "Stone Legion Generals", 'raid_ids' => {
      'raid_finder' => [14454], 'normal' => [14451], 'heroic' => [14452], 'mythic' => [14453]
    }
  }, {
    'id' => 2407, 'name' => "Sire Denathrius", 'raid_ids' => {
      'raid_finder' => [14458], 'normal' => [14455], 'heroic' => [14456], 'mythic' => [14457]
    }
  }]
}]

WCL_IDS = VALID_RAIDS.map{ |raid| raid["encounters"].map{ |encounter| encounter["id"].to_s } }.flatten
