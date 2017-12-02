ITEMS = [
  'head',
  'neck',
  'shoulder',
  'back',
  'chest',
  'wrist',
  'hands',
  'waist',
  'legs',
  'feet',
  'finger1',
  'finger2',
  'trinket1',
  'trinket2'
]

RELIC_ILVL = {
  2 => 690,
  3 => 695,
  4 => 700,
  5 => 705,
  7 => 710,
  8 => 715,
  9 => 720,
  10 => 725,
  12 => 730,
  13 => 735,
  14 => 740,
  15 => 745,
  17 => 750,
  18 => 755,
  19 => 760,
  21 => 765,
  22 => 770,
  23 => 775,
  24 => 780,
  26 => 785,
  27 => 790,
  28 => 795,
  29 => 800,
  31 => 805,
  32 => 810,
  33 => 815,
  35 => 820,
  36 => 825,
  37 => 830,
  39 => 835,
  40 => 840,
  42 => 845,
  43 => 850,
  45 => 855,
  46 => 860,
  48 => 865,
  49 => 870,
  51 => 875,
  52 => 880,
  53 => 885,
  55 => 890,
  56 => 895,
  58 => 900,
  59 => 905,
  61 => 910,
  62 => 915,
  64 => 920,
  65 => 925,
  67 => 930,
  68 => 935,
  70 => 940,
  71 => 945,
  72 => 950,
  74 => 955,
  75 => 960,
  77 => 965,
  78 => 970,
  80 => 975,
  81 => 980,
  83 => 985
}

ENCHANTS = {
  'finger1' => {
    5423 => [1, "+150 Crit"],
    5424 => [1, "+150 Haste"],
    5425 => [1, "+150 Mastery"],
    5426 => [1, "+150 Versatility"],
    5427 => [2, "+200 Crit"],
    5428 => [2, "+200 Haste"],
    5429 => [2, "+200 Mastery"],
    5430 => [2, "+200 Versatility"]
  },
  'finger2' => {
    5423 => [1, "+150 Crit"],
    5424 => [1, "+150 Haste"],
    5425 => [1, "+150 Mastery"],
    5426 => [1, "+150 Versatility"],
    5427 => [2, "+200 Crit"],
    5428 => [2, "+200 Haste"],
    5429 => [2, "+200 Mastery"],
    5430 => [2, "+200 Versatility"]
  },
  'back'=> {
    5431 => [1, "+150 Strength"],
    5432 => [1, "+150 Agility"],
    5433 => [1, "+150 Intellect"],
    5311 => [2, "Gift of Haste"],
    5434 => [2, "+200 Strength"],
    5435 => [2, "+200 Agility"],
    5436 => [2, "+200 Intellect"]
  },
  'neck' => {
    5437 => [2, "Mark of the Claw"],
    5438 => [2, "Mark of the Distant Army"],
    5439 => [2, "Mark of the Hidden Satyr"],
    5889 => [2, "Mark of the Heavy Hide"],
    5890 => [2, "Mark of the Trained Soldier"],
    5891 => [2, "Mark of the Ancient Priestess"],
    5895 => [2, "Mark of the Master"],
    5896 => [2, "Mark of the Versatile"],
    5897 => [2, "Mark of the Quick"],
    5898 => [2, "Mark of the Deadly"]
  }
}

# 1 = Uncommon gem
# 2 = Rare gem
# 3 = Epic gem
GEMS = {
  130215 => 1,
  130216 => 1,
  130217 => 1,
  130218 => 1,
  130219 => 2,
  130220 => 2,
  130221 => 2,
  130222 => 2,
  130246 => 3,
  130247 => 3,
  130248 => 3,
  151580 => 3,
  151583 => 3,
  151584 => 3,
  151585 => 3
}

ARTIFACTS = {
  # Death Knight
  "Maw of the Damned" => ['Blood', 1],
  "Blades of the Fallen Prince" => ['Frost', 2],
  "Apocalypse" => ['Unholy', 3],

  # Demon Hunter
  "Twinblades of the Deceiver" => ['Havoc', 1],
  "Aldrachi Warblades" => ['Vengeance', 2],

  # Druid
  "Scythe of Elune" => ['Balance', 4],
  "Fangs of Ashamane" => ['Feral', 1],
  "Claws of Ursoc" => ['Guardian', 2],
  "G'Hanir, the Mother Tree" => ['Restoration', 3],

  # Hunter
  "Titanstrike" => ['Beast Mastery', 1],
  "Thas'dorah, Legacy of the Windrunners" => ['Marksmanship', 2],
  "Talonclaw" => ['Survival', 3],

  # Mage
  "Aluneth" => ['Arcane', 1],
  "Felo'melorn" => ['Fire', 2],
  "Ebonchill" => ['Frost', 3],

  # Monk
  "Fu Zan, the Wanderer's Companion" => ['Brewmaster', 1],
  "Sheilun, Staff of the Mists" => ['Mistweaver', 2],
  "Fists of the Heavens" => ['Windwalker', 3],

  # Paladin
  "The Silver Hand" => ['Holy', 1],
  "Truthguard" => ['Protection', 2],
  "Ashbringer" => ['Retribution', 3],

  # Priest
  "Light's Wrath" => ['Discipline', 1],
  "T'uure, Beacon of the Naaru" => ['Holy', 2],
  "Xal'atath, Blade of the Black Empire" => ['Shadow', 3],

  # Shaman
  "Doomhammer" => ['Enhancement', 1],
  "The Fist of Ra-den" => ['Elemental', 2],
  "Sharas'dal, Scepter of Tides" => ['Restoration', 3],

  # Rogue
  "The Kingslayers" => ['Assassination', 1],
  "The Dreadblades" => ['Outlaw', 2],
  "Fangs of the Devourer" => ['Subtlety', 3],

  # Warlock
  "Ulthalesh, the Deadwind Harvester" => ['Affliction', 1],
  "Scepter of Sargeras" => ['Destruction', 2],
  "Skull of the Man'ari" => ['Demonology', 3],

  # Warrior
  "Warswords of the Valarjar" => ['Fury', 1],
  "Strom'kar, the Warbreaker" => ['Arms', 2],
  "Scale of the Earth-Warder" => ['Protection', 3]
}

PANTHEON_TRINKETS = {
  154172 => "Wildcard",
  154173 => "Tank",
  154174 => "Agility",
  154175 => "Heal",
  154176 => "Strength",
  154177 => "Intellect"
}

BLANK_TIER_DATA = "{\"head\": 0, \"shoulder\": 0, \"back\": 0, \"chest\": 0, \"hands\": 0, \"legs\": 0, \"trinket\": \"0_None\"}"
