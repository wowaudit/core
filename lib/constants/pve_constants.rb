MYTHIC_DUNGEONS = {
  12749 => 'Atal\'Dazar',
  12752 => 'Freehold',
  12763 => 'King\'s Rest',
  12779 => 'The MOTHERLODE!!',
  12768 => 'Shrine of the Storm',
  12773 => 'Siege of Boralus',
  12776 => 'Temple of Sethraliss',
  12782 => 'Tol Dagor',
  12745 => 'Underrot',
  12785 => 'Waycrest Manor'
}

RAID_DIFFICULTIES = {
  1 => 'Raid Finder',
  3 => 'Normal',
  4 => 'Heroic',
  5 => 'Mythic'
}

#TODO: Add Warcraft Logs IDs when they get added
VALID_RAIDS = [{
  'name' => 'Uldir', 'days' => [0, 1, 2, 3, 4, 5, 6], 'id' => 0, 'partition' => 1,
  'encounters' => [{
    'id' => 0, 'name' => 'Taloc', 'raid_ids' => {
      'raid_finder' => 12786, 'normal' => 12787, 'heroic' => 12788, 'mythic' => 12789
    }
  }, {
    'id' => 0, 'name' => 'MOTHER', 'raid_ids' => {
      'raid_finder' => 12790, 'normal' => 12791, 'heroic' => 12792, 'mythic' => 12793
    }
  }, {
    'id' => 0, 'name' => 'Fetid Devourer', 'raid_ids' => {
      'raid_finder' => 12794, 'normal' => 12795, 'heroic' => 12796, 'mythic' => 12797
    }
  }, {
    'id' => 0, 'name' => 'Zek\'voz, Herald of N\'zoth', 'raid_ids' => {
      'raid_finder' => 12798, 'normal' => 12799, 'heroic' => 12800, 'mythic' => 12801
    }
  }, {
    'id' => 0, 'name' => 'Vectis', 'raid_ids' => {
      'raid_finder' => 12802, 'normal' => 12803, 'heroic' => 12804, 'mythic' => 12805
    }
  }, {
    'id' => 0, 'name' => 'Zul, Reborn', 'raid_ids' => {
      'raid_finder' => 12808, 'normal' => 12809, 'heroic' => 12810, 'mythic' => 12811
    }
  }, {
    'id' => 0, 'name' => 'Mythrax the Unraveler', 'raid_ids' => {
      'raid_finder' => 12813, 'normal' => 12814, 'heroic' => 12815, 'mythic' => 12816
    }
  }, {
    'id' => 0, 'name' => 'G\'huun', 'raid_ids' => {
      'raid_finder' => 12817, 'normal' => 12818, 'heroic' => 12819, 'mythic' => 12820
    }
  }]
}]

WCL_IDS = VALID_RAIDS.map{ |raid| raid["encounters"].map{ |encounter| encounter["id"].to_s } }.flatten
