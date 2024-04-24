BRACKETS = {
  live: {
    '2v2' => 'pvp_bracket_2v2',
    '3v3' => 'pvp_bracket_3v3',
    'rbg' => 'pvp_bracket_rbg',
  },
  classic_progression: {
    '2v2' => 'pvp_bracket_2v2',
    '3v3' => 'pvp_bracket_3v3',
    '5v5' => 'pvp_bracket_5v5',
  }
}

CURRENT_PVP_SEASON = {
  live: 37,
  classic_progression: 8,
}

HONOR_PER_WIN = {
  '2v2' => {
    daily: 200,
    win: 100,
    loss: 25,
  },
  '3v3' => {
    daily: 250,
    win: 125,
    loss: 30,
  },
  'rbg' => {
    daily: 850,
    win: 425, # Estimated
    loss: 125, # Estimated
  },
  'shuffle' => {
    daily: 600,
    win: 300, # Estimated
    loss: 75, # Estimated
  }
}
