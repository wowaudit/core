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
  12 => 'Demon Hunter',
  nil => ''
}

DEFAULT_ROLES = {
  'Death Knight' => 'melee',
  'Demon Hunter' => 'melee',
  'Druid' => 'melee',
  'Hunter' => 'ranged',
  'Mage' => 'ranged',
  'Monk' => 'melee',
  'Paladin' => 'melee',
  'Priest' => 'ranged',
  'Rogue' => 'melee',
  'Shaman' => 'ranged',
  'Warlock' => 'ranged',
  'Warrior' => 'melee'
}

ROLES_TO_SPEC = {
  'heal' => [
    'Restoration',
    'Holy',
    'Discipline',
    'Mistweaver'
  ],
  'tank' => [
    'Blood',
    'Vengeance',
    'Protection',
    'Brewmaster',
    'Guardian'
  ],
  'melee' => [
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
  'ranged' => [
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
  'tank' => {
    'Death Knight' => [1],
    'Demon Hunter' => [2],
    'Druid' => [2],
    'Monk' => [1],
    'Paladin' => [2],
    'Warrior' => [3]
  },
  'heal' => {
    'Druid' => [3],
    'Monk' => [2],
    'Paladin' => [1],
    'Priest' => [1,2],
    'Shaman' => [3]
  },
  'ranged'=> {
    'Druid' => [4],
    'Hunter' => [1,2],
    'Mage' => [1,2,3],
    'Priest' => [3],
    'Shaman' => [2],
    'Warlock' => [1,2,3]
  },
  'melee'=> {
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
