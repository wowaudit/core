CURRENT_KEYSTONE_SEASON = 8
FIRST_PERIOD_OF_SEASON = 866

LEADERBOARD_KEYSTONE_DUNGEONS = {
  166 =>  "Grimrail Depot",
  169 =>  "Iron Docks",
  227 =>  "Return to Karazhan: Lower",
  234 =>  "Return to Karazhan: Upper",
  369 =>  "Operation: Mechagon - Junkyard",
  370 =>  "Operation: Mechagon - Workshop",
  391 =>  "Tazavesh: Streets of Wonder",
  392 =>  "Tazavesh: So'leah's Gambit",
}

KEYSTONE_DUNGEONS = LEADERBOARD_KEYSTONE_DUNGEONS.merge({
  197 =>  "Eye of Azshara",
  198 =>  "Darkheart Thicket",
  199 =>  "Black Rook Hold",
  206 =>  "Neltharion's Lair",
  207 =>  "Vault of the Wardens",
  210 =>  "Court of Stars",
})

SLUGIFIED_DUNGEON_NAMES = LEADERBOARD_KEYSTONE_DUNGEONS.transform_values do |dungeon_name|
  dungeon_name.gsub("'", "").gsub(":", "").gsub(" -", "").gsub(" ", "_").downcase
end

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

TORGHAST_LAYER_CRITERIA = [6, 12, 18, 24, 30, 36, 42, 48, 53, 58, 63, 68, 73, 78, 83, 88]

TORGHAST_TWISTING_CORRIDORS_IDS = [
  14468, 14469, 14470, 14471, 14472, 14568, 14569, 14570
]

TORGHAST_JAILERS_GAUNTLET_IDS = [
  15251, 15252, 15253, 15254, 15255, 15256, 15257, 15258
]

GREAT_VAULT_RAID_KILLS_NEEDED = {
  1 => 2,
  2 => 5,
  3 => 8,
}

GREAT_VAULT_TO_ILVL = {
  'raid' => {
    'mythic' => 304,
    'heroic' => 291,
    'normal' => 278,
    'raid_finder' => 265,
  },
  'dungeon' => {
    15 => 304,
    14 => 301,
    13 => 298,
    12 => 298,
    11 => 294,
    10 => 291,
    9 => 288,
    8 => 288,
    7 => 285,
    6 => 282,
    5 => 282,
    4 => 278,
    3 => 278,
    2 => 278,
    0 => '',
  },
  'pvp' => {
    2400 => 301,
    2100 => 298,
    1950 => 295,
    1800 => 291,
    1600 => 288,
    1400 => 285,
    1200 => 282,
    1000 => 278,
    0 => 275,
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
  15135, # Sylvanas Windrunner
  15471, # The Jailer
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
]

VALID_RAIDS = [{
  'name' => 'Castle Nathria', "days"=> [0, 1, 2, 3, 4, 5, 6], fated_periods: [866, 869, 872, 875, 878, 879, 880, 881, 882], 'id' => 26,
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
}, {
  'name' => 'Sanctum of Domination', "days"=> [0, 1, 2, 3, 4, 5, 6], fated_periods: [867, 870, 873, 876, 878, 879, 880, 881, 882], 'id' => 28,
  'encounters' => [{
    'id' => 2423, 'name' => 'The Tarragrue', 'raid_ids' => {
      'raid_finder' => [15136], 'normal' => [15137], 'heroic' => [15138], 'mythic' => [15139]
    }
  }, {
    'id' => 2433, 'name' => "The Eye of the Jailer", 'raid_ids' => {
      'raid_finder' => [15140], 'normal' => [15141], 'heroic' => [15142], 'mythic' => [15143]
    }
  }, {
    'id' => 2429, 'name' => "The Nine", 'raid_ids' => {
      'raid_finder' => [15144], 'normal' => [15145], 'heroic' => [15146], 'mythic' => [15147]
    }
  }, {
    'id' => 2432, 'name' => "Remnant of Ner'zhul", 'raid_ids' => {
      'raid_finder' => [15148], 'normal' => [15149], 'heroic' => [15150], 'mythic' => [15151]
    }
  }, {
    'id' => 2434, 'name' => "Soulrender Dormazain", 'raid_ids' => {
      'raid_finder' => [15152], 'normal' => [15153], 'heroic' => [15154], 'mythic' => [15155]
    }
  }, {
    'id' => 2430, 'name' => "Painsmith Raznal", 'raid_ids' => {
      'raid_finder' => [15156], 'normal' => [15157], 'heroic' => [15158], 'mythic' => [15159]
    }
  }, {
    'id' => 2436, 'name' => "Guardian of the First Ones", 'raid_ids' => {
      'raid_finder' => [15160], 'normal' => [15161], 'heroic' => [15162], 'mythic' => [15163]
    }
  }, {
    'id' => 2431, 'name' => "Fatescribe Roh-Kalo", 'raid_ids' => {
      'raid_finder' => [15164], 'normal' => [15165], 'heroic' => [15166], 'mythic' => [15167]
    }
  }, {
    'id' => 2422, 'name' => "Kel'Thuzad", 'raid_ids' => {
      'raid_finder' => [15169], 'normal' => [15170], 'heroic' => [15171], 'mythic' => [15172]
    }
  }, {
    'id' => 2435, 'name' => "Sylvanas Windrunner", 'raid_ids' => {
      'raid_finder' => [15173], 'normal' => [15174], 'heroic' => [15175], 'mythic' => [15176]
    }
  }]
},
# Automatically generated
{"name"=>"Sepulcher of the First Ones", "days"=>[0, 1, 2, 3, 4, 5, 6], fated_periods: [868, 871, 874, 877, 878, 879, 880, 881, 882], "id"=>29, "encounters"=>[{"id"=>2512, "name"=>"Vigilant Guardian", "raid_ids"=>{"raid_finder"=>[15424], "normal"=>[15425], "heroic"=>[15426], "mythic"=>[15427]}}, {"id"=>2542, "name"=>"Skolex", "raid_ids"=>{"raid_finder"=>[15428], "normal"=>[15429], "heroic"=>[15430], "mythic"=>[15431]}}, {"id"=>2553, "name"=>"Artificer Xy'mox", "raid_ids"=>{"raid_finder"=>[15432], "normal"=>[15433], "heroic"=>[15434], "mythic"=>[15435]}}, {"id"=>2540, "name"=>"Dausegne", "raid_ids"=>{"raid_finder"=>[15436], "normal"=>[15437], "heroic"=>[15438], "mythic"=>[15439]}}, {"id"=>2544, "name"=>"Prototype Pantheon", "raid_ids"=>{"raid_finder"=>[15440], "normal"=>[15441], "heroic"=>[15442], "mythic"=>[15443]}}, {"id"=>2539, "name"=>"Lihuvim", "raid_ids"=>{"raid_finder"=>[15444], "normal"=>[15445], "heroic"=>[15446], "mythic"=>[15447]}}, {"id"=>2529, "name"=>"Halondrus", "raid_ids"=>{"raid_finder"=>[15448], "normal"=>[15449], "heroic"=>[15450], "mythic"=>[15451]}}, {"id"=>2546, "name"=>"Anduin Wrynn", "raid_ids"=>{"raid_finder"=>[15452], "normal"=>[15453], "heroic"=>[15454], "mythic"=>[15455]}}, {"id"=>2543, "name"=>"Lords of Dread", "raid_ids"=>{"raid_finder"=>[15456], "normal"=>[15457], "heroic"=>[15458], "mythic"=>[15459]}}, {"id"=>2549, "name"=>"Rygelon", "raid_ids"=>{"raid_finder"=>[15460], "normal"=>[15461], "heroic"=>[15462], "mythic"=>[15463]}}, {"id"=>2537, "name"=>"The Jailer", "raid_ids"=>{"raid_finder"=>[15464], "normal"=>[15465], "heroic"=>[15466], "mythic"=>[15467]}}]},
]

WCL_IDS = VALID_RAIDS.map{ |raid| raid["encounters"].map{ |encounter| encounter["id"].to_s } }.flatten
