CLASSES = {
  1 => 'Warrior',
  2 => 'Paladin',
  3 => 'Hunter',
  4 => 'Rogue',
  5 => 'Priest',
  6 => 'Death Knight',
  7 => 'Shaman',
  8 => 'Mage',
  9 => 'Warlock',
  10 => 'Monk',
  11 => 'Druid',
  12 => 'Demon Hunter'
}

FACTIONS = {
  0 => 'Alliance',
  1 => 'Horde'
}

RACES = {
  1 => "Human",
  2 => "Orc",
  3 => "Dwarf",
  4 => "Night Elf",
  5 => "Undead",
  6 => "Tauren",
  7 => "Gnome",
  8 => "Troll",
  9 => "Goblin",
  10 => "Blood Elf",
  11 => "Draenei",
  22 => "Worgen",
  24 => "Pandaren",
  25 => "Pandaren",
  26 => "Pandaren",
  27 => "Nightborne",
  28 => "Highmountain Tauren",
  29 => "Void Elf",
  30 => "Lightforged Draenei",
  34 => "Dark Iron Dwarf",
  36 => "Mag'har Orc"
}

DEFAULT_ROLES = {
  'Death Knight' => 'Melee',
  'Demon Hunter' => 'Melee',
  'Druid' => 'Melee',
  'Hunter' => 'Ranged',
  'Mage' => 'Ranged',
  'Monk' => 'Melee',
  'Paladin' => 'Melee',
  'Priest' => 'Ranged',
  'Rogue' => 'Melee',
  'Shaman' => 'Ranged',
  'Warlock' => 'Ranged',
  'Warrior' => 'Melee'
}

ROLES_TO_SPEC = {
  'Heal' => [
    'Restoration',
    'Holy',
    'Discipline',
    'Mistweaver'
  ],
  'Tank' => [
    'Blood',
    'Vengeance',
    'Protection',
    'Brewmaster',
    'Guardian'
  ],
  'Melee' => [
    'Outlaw',
    'Subtlety',
    'Assassination',
    'Feral',
    'Windwalker',
    'Havoc',
    'Enhancement',
    'Survival',
    'Arms','Fury',
    'Retribution',
    'Unholy',
    'Frost'
  ],
  'Ranged' => [
    'Shadow',
    'Affliction',
    'Demonology',
    'Destruction',
    'Arcane',
    'Fire',
    'Frost',
    'Balance',
    'Marksmanship',
    'Beast Mastery',
    'Elemental'
  ]
}

ROLES = {
  'Tank' => {
    'Death Knight' => [1],
    'Demon Hunter' => [2],
    'Druid' => [2],
    'Monk' => [1],
    'Paladin' => [2],
    'Warrior' => [3]
  },
  'Heal' => {
    'Druid' => [3],
    'Monk' => [2],
    'Paladin' => [1],
    'Priest' => [1,2],
    'Shaman' => [3]
  },
  'Ranged'=> {
    'Druid' => [4],
    'Hunter' => [1,2],
    'Mage' => [1,2,3],
    'Priest' => [3],
    'Shaman' => [2],
    'Warlock' => [1,2,3]
  },
  'Melee'=> {
    'Death Knight' => [2,3],
    'Demon Hunter' => [1],
    'Druid' => [1],
    'Hunter' => [3],
    'Monk' => [3],
    'Paladin' => [3],
    'Rogue' => [1,2,3],
    'Shaman' => [1],
    'Warrior' => [1,2]
  }
}
