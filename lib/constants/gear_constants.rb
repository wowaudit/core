base_items = [
  'main_hand',
  'off_hand',
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
  'finger_1',
  'finger_2',
  'trinket_1',
  'trinket_2'
]

ITEMS = {
  live: base_items,
  classic_era: base_items + ['ranged'],
  classic_progression: base_items + ['ranged'],
}

QUALITIES = {
  POOR: 0,
  COMMON: 1,
  UNCOMMON: 2,
  RARE: 3,
  EPIC: 4,
  LEGENDARY: 5,
  ARTIFACT: 6,
  HEIRLOOM: 7,
}

weapon_enchants = {
  3370 => [4, "Rune of Razorice"],
  3847 => [4, "Rune of the Stoneskin Gargoyle"],
  3368 => [4, "Rune of the Fallen Crusader"],
  6241 => [4, "Rune of Sanguination"],
  6242 => [4, "Rune of Spellwarding"],
  6243 => [4, "Rune of Hysteria"],
  6244 => [4, "Rune of Unending Thirst"],
  6245 => [4, "Rune of the Apocalypse"],
  7437 => [2, "Council's Guile (1)", { crit: 2735 * 0.4 }],
  7438 => [2, "Council's Guile (2)", { crit: 3325 * 0.4 }],
  7439 => [4, "Council's Guile (3)", { crit: 3910 * 0.4 }],
  7440 => [2, "Stormrider's Fury (1)", { haste: 2735 * 0.4 }],
  7441 => [2, "Stormrider's Fury (2)", { haste: 3325 * 0.4 }],
  7442 => [4, "Stormrider's Fury (3)", { haste: 3910 * 0.4 }],
  7443 => [2, "Stonebound Artistry (1)", { mastery: 2735 * 0.4 }],
  7444 => [2, "Stonebound Artistry (2)", { mastery: 3325 * 0.4 }],
  7445 => [4, "Stonebound Artistry (3)", { mastery: 3910 * 0.4 }],
  7446 => [2, "Oathsworn's Tenacity (1)", { vers: 2735 * 0.4 }],
  7447 => [2, "Oathsworn's Tenacity (2)", { vers: 3325 * 0.4 }],
  7448 => [4, "Oathsworn's Tenacity (3)", { vers: 3910 * 0.4 }],
  7449 => [2, "Authority of Air (1)"],
  7450 => [2, "Authority of Air (2)"],
  7451 => [4, "Authority of Air (3)"],
  7452 => [2, "Authority of Fiery Resolve (1)"],
  7453 => [2, "Authority of Fiery Resolve (2)"],
  7454 => [4, "Authority of Fiery Resolve (3)"],
  7455 => [2, "Authority of Storms (1)"],
  7456 => [2, "Authority of Storms (2)"],
  7457 => [4, "Authority of Storms (3)"],
  7458 => [2, "Authority of the Depths (1)"],
  7459 => [2, "Authority of the Depths (2)"],
  7460 => [4, "Authority of the Depths (3)"],
  7461 => [2, "Authority of Radiant Power (1)"],
  7462 => [2, "Authority of Radiant Power (2)"],
  7463 => [4, "Authority of Radiant Power (3)"],
}

ring_enchants = {
  7329 => [2, "Glimmering Critical Strike (1)", { crit: 130 }],
  7330 => [2, "Glimmering Critical Strike (2)", { crit: 160 }],
  7331 => [2, "Glimmering Critical Strike (3)", { crit: 190 }],
  7335 => [2, "Glimmering Haste (1)", { haste: 130 }],
  7336 => [2, "Glimmering Haste (2)", { haste: 160 }],
  7337 => [2, "Glimmering Haste (3)", { haste: 190 }],
  7341 => [2, "Glimmering Mastery (1)", { mastery: 130 }],
  7342 => [2, "Glimmering Mastery (2)", { mastery: 160 }],
  7343 => [2, "Glimmering Mastery (3)", { mastery: 190 }],
  7347 => [2, "Glimmering Versatility (1)", { vers: 130 }],
  7348 => [2, "Glimmering Versatility (2)", { vers: 160 }],
  7349 => [2, "Glimmering Versatility (3)", { vers: 190 }],
  7468 => [2, "Cursed Critical Strike (1)", { crit: 270, haste: -80 }],
  7469 => [2, "Cursed Critical Strike (2)", { crit: 335, haste: -100 }],
  7470 => [4, "Cursed Critical Strike (3)", { crit: 390, haste: -115 }],
  7332 => [2, "Radiant Critical Strike (1)", { crit: 220 }],
  7333 => [2, "Radiant Critical Strike (2)", { crit: 265 }],
  7334 => [4, "Radiant Critical Strike (3)", { crit: 315 }],
  7471 => [2, "Cursed Haste (1)", { haste: 270, vers: -80 }],
  7472 => [2, "Cursed Haste (2)", { haste: 335, vers: -100 }],
  7473 => [4, "Cursed Haste (3)", { haste: 390, vers: -115 }],
  7338 => [2, "Radiant Haste (1)", { haste: 220 }],
  7339 => [2, "Radiant Haste (2)", { haste: 265 }],
  7340 => [4, "Radiant Haste (3)", { haste: 315 }],
  7477 => [2, "Cursed Mastery (1)", { mastery: 270, crit: -80 }],
  7478 => [2, "Cursed Mastery (2)", { mastery: 335, crit: -100 }],
  7479 => [4, "Cursed Mastery (3)", { mastery: 390, crit: -115 }],
  7344 => [2, "Radiant Mastery (1)", { mastery: 220 }],
  7345 => [2, "Radiant Mastery (2)", { mastery: 265 }],
  7346 => [4, "Radiant Mastery (3)", { mastery: 315 }],
  7474 => [2, "Cursed Versatility (1)", { vers: 270, mastery: -80 }],
  7475 => [2, "Cursed Versatility (2)", { vers: 335, mastery: -100 }],
  7476 => [4, "Cursed Versatility (3)", { vers: 390, mastery: -115 }],
  7350 => [2, "Radiant Versatility (1)", { vers: 220 }],
  7351 => [2, "Radiant Versatility (2)", { vers: 265 }],
  7352 => [4, "Radiant Versatility (3)", { vers: 315 }],
}

ENCHANTS = {
  'back' => {
    7398 => [2, "Whisper of Silken Avoidance (1)"],
    7399 => [2, "Whisper of Silken Avoidance (2)"],
    7400 => [2, "Whisper of Silken Avoidance (3)"],
    7401 => [2, "Chant of Winged Grace (1)"],
    7402 => [2, "Chant of Winged Grace (2)"],
    7403 => [4, "Chant of Winged Grace (3)"],
    7404 => [2, "Whisper of Silken Leech (1)"],
    7405 => [2, "Whisper of Silken Leech (2)"],
    7406 => [2, "Whisper of Silken Leech (3)"],
    7407 => [2, "Chant of Leeching Fangs (1)"],
    7408 => [2, "Chant of Leeching Fangs (2)"],
    7409 => [4, "Chant of Leeching Fangs (3)"],
    7410 => [2, "Whisper of Silken Speed (1)"],
    7411 => [2, "Whisper of Silken Speed (2)"],
    7412 => [2, "Whisper of Silken Speed (3)"],
    7413 => [2, "Chant of Burrowing Rapidity (1)"],
    7414 => [2, "Chant of Burrowing Rapidity (2)"],
    7415 => [4, "Chant of Burrowing Rapidity (3)"],
  },
  'chest' => {
    7353 => [2, "Stormrider's Agility (1)"],
    7354 => [2, "Stormrider's Agility (2)"],
    7355 => [4, "Stormrider's Agility (3)"],
    7356 => [2, "Council's Intellect (1)"],
    7357 => [2, "Council's Intellect (2)"],
    7358 => [4, "Council's Intellect (3)"],
    7359 => [2, "Oathsworn's Strength (1)"],
    7360 => [2, "Oathsworn's Strength (2)"],
    7361 => [4, "Oathsworn's Strength (3)"],
    7362 => [2, "Crystalline Radiance (1)"],
    7363 => [2, "Crystalline Radiance (2)"],
    7364 => [4, "Crystalline Radiance (3)"],
  },
  'wrist' => {
    7380 => [2, "Whisper of Armored Avoidance (1)"],
    7381 => [2, "Whisper of Armored Avoidance (2)"],
    7382 => [2, "Whisper of Armored Avoidance (3)"],
    7383 => [2, "Chant of Armored Avoidance (1)"],
    7384 => [2, "Chant of Armored Avoidance (2)"],
    7385 => [4, "Chant of Armored Avoidance (3)"],
    7386 => [2, "Whisper of Armored Leech (1)"],
    7387 => [2, "Whisper of Armored Leech (2)"],
    7388 => [2, "Whisper of Armored Leech (3)"],
    7389 => [2, "Chant of Armored Leech (1)"],
    7390 => [2, "Chant of Armored Leech (2)"],
    7391 => [4, "Chant of Armored Leech (3)"],
    7392 => [2, "Whisper of Armored Speed (1)"],
    7393 => [2, "Whisper of Armored Speed (2)"],
    7394 => [2, "Whisper of Armored Speed (3)"],
    7395 => [2, "Chant of Armored Speed (1)"],
    7396 => [2, "Chant of Armored Speed (2)"],
    7397 => [4, "Chant of Armored Speed (3)"],
  },
  'legs' => {
    7535 => [2, "Weavercloth Spellthread (1)"],
    7536 => [2, "Weavercloth Spellthread (2)"],
    7537 => [2, "Weavercloth Spellthread (3)"],
    7529 => [2, "Daybreak Spellthread (1)"],
    7530 => [2, "Daybreak Spellthread (2)"],
    7531 => [4, "Daybreak Spellthread (3)"],
    7532 => [2, "Sunset Spellthread (1)"],
    7533 => [2, "Sunset Spellthread (2)"],
    7534 => [4, "Sunset Spellthread (3)"],
    7596 => [2, "Dual Layered Armor Kit (1)"],
    7597 => [2, "Dual Layered Armor Kit (2)"],
    7598 => [2, "Dual Layered Armor Kit (3)"],
    7652 => [2, "Charged Armor Kit (1)"],
    7653 => [2, "Charged Armor Kit (2)"],
    7654 => [2, "Charged Armor Kit (3)"],
    7599 => [2, "Stormbound Armor Kit (1)"],
    7600 => [2, "Stormbound Armor Kit (2)"],
    7601 => [4, "Stormbound Armor Kit (3)"],
    7593 => [2, "Defender's Armor Kit (1)"],
    7594 => [2, "Defender's Armor Kit (2)"],
    7595 => [4, "Defender's Armor Kit (3)"],
  },
  'feet' => {
    6605 => [2, "Plainsrunner's Breeze (1)"],
    6606 => [2, "Plainsrunner's Breeze (2)"],
    6607 => [2, "Plainsrunner's Breeze (3)"],
    7416 => [2, "Scout's March (1)"],
    7417 => [2, "Scout's March (2)"],
    7418 => [4, "Scout's March (3)"],
    7419 => [2, "Cavalry's March (1)"],
    7420 => [2, "Cavalry's March (2)"],
    7421 => [2, "Cavalry's March (3)"],
    7422 => [2, "Defender's March (1)"],
    7423 => [2, "Defender's March (2)"],
    7424 => [4, "Defender's March (3)"],
  },
  'finger_1' => ring_enchants,
  'finger_2' => ring_enchants,
  'main_hand' => weapon_enchants,
  'off_hand' => weapon_enchants,
}

CORRUPTION_HELM_ENCHANTS = {
  7912 => { level: 'Lesser', name: "Twilight Devastation" },
  7914 => { level: 'Greater', name: "Twilight Devastation" },
  7915 => { level: 'Lesser', name: "Echoing Void" },
  7917 => { level: 'Greater', name: "Echoing Void" },
  7922 => { level: 'Lesser', name: "Infinite Stars" },
  7924 => { level: 'Greater', name: "Infinite Stars" },
  7925 => { level: 'Lesser', name: "Gushing Wound" },
  7927 => { level: 'Greater', name: "Gushing Wound" },
  7928 => { level: 'Lesser', name: "Twisted Appendage" },
  7930 => { level: 'Greater', name: "Twisted Appendage" },
  7931 => { level: 'Lesser', name: "Void Ritual" },
  7933 => { level: 'Greater', name: "Void Ritual" },
}

BELT_SPELLS = [
  {
    match_string: "Equip: Your spells and abilities have a chance to turn you into a Lightning Rod striking a random enemy target within 40 yds for",
    name: "Charged Bolts",
  },
  {
    match_string: "Equip: Your spells and attacks have a chance to send a Charged Bolt at your target that deals",
    name: "Charged Crystal",
  },
  {
    match_string: "Equip: When you take damage, you have a chance to gain a Titan Energy Shield preventing up to",
    name: "Energy Shield",
  },
  {
    match_string: "Your heals have a chance to Spark jumping to the lowest health target within 40 yds, healing them for",
    name: "Charged Touch",
  },
  {
    match_string: "Equip: You gain Electric Current upon entering combat, increasing your Mastery by",
    name: "Electric Current",
  },
  {
    match_string: "Equip: Your spells and abilities have a chance to turn you into a Lightning Rod causing strikes that heal the lowest health friendly target within 40 yds for",
    name: "Cauterizing Bolts",
  },
  {
    match_string: "Equip: Your spells and abilities have a chance to trigger Critical Overload, increasing your Critical Strike by",
    name: "Critical Chain",
  },
  {
    match_string: "Equip: Your spells and abilities have a chance to grant you Static Charge, increasing your Versatility by",
    name: "Static Charge",
  },
  {
    match_string: "Equip: Your spells and abilities have a chance to trigger a Spark Burst granting you",
    name: "Spark Burst",
  }
]

GEM_QUALITY_MAPPING = {
  legacy: 1,
  uncommon: 2,
  rare: 3,
  epic: 4,
}

TRACKED_STATS = {
  VERSATILITY: :vers,
  MASTERY_RATING: :mastery,
  HASTE_RATING: :haste,
  CRIT_RATING: :crit,
}

DIFFICULTY_LETTERS = ['M', 'H', 'N', 'R']

GEMS = {
  192900=>{:quality=>1, :name=>"Crafty Queen's Ruby (1)", :stats=>{:crit=>18, :haste=>18}},
  192901=>{:quality=>1, :name=>"Crafty Queen's Ruby (2)", :stats=>{:haste=>22, :crit=>22}},
  192902=>{:quality=>1, :name=>"Crafty Queen's Ruby (3)", :stats=>{:haste=>26, :crit=>26}},
  192917=>{:quality=>1, :name=>"Crafty Alexstraszite (1)", :stats=>{:crit=>49, :haste=>23}},
  192918=>{:quality=>1, :name=>"Crafty Alexstraszite (2)", :stats=>{:crit=>60, :haste=>28}},
  192919=>{:quality=>1, :name=>"Crafty Alexstraszite (3)", :stats=>{:crit=>70, :haste=>33}},
  192983=>{:quality=>1, :name=>"Fierce Illimited Diamond (1)", :stats=>{:haste=>46}},
  192984=>{:quality=>1, :name=>"Fierce Illimited Diamond (2)", :stats=>{:haste=>56}},
  192985=>{:quality=>1, :name=>"Fierce Illimited Diamond (3)", :stats=>{:haste=>66}},
  192903=>{:quality=>1, :name=>"Zen Mystic Sapphire (1)", :stats=>{:vers=>18, :mastery=>18}},
  192904=>{:quality=>1, :name=>"Zen Mystic Sapphire (2)", :stats=>{:vers=>22, :mastery=>22}},
  192905=>{:quality=>1, :name=>"Zen Mystic Sapphire (3)", :stats=>{:vers=>26, :mastery=>26}},
  192906=>{:quality=>1, :name=>"Energized Vibrant Emerald (1)", :stats=>{:haste=>18, :vers=>18}},
  192907=>{:quality=>1, :name=>"Energized Vibrant Emerald (2)", :stats=>{:haste=>22, :vers=>22}},
  192908=>{:quality=>1, :name=>"Energized Vibrant Emerald (3)", :stats=>{:haste=>26, :vers=>26}},
  192910=>{:quality=>1, :name=>"Sensei's Sundered Onyx (1)", :stats=>{:mastery=>18, :crit=>18}},
  192911=>{:quality=>1, :name=>"Sensei's Sundered Onyx (2)", :stats=>{:mastery=>22, :crit=>22}},
  192912=>{:quality=>1, :name=>"Sensei's Sundered Onyx (3)", :stats=>{:mastery=>26, :crit=>26}},
  192913=>{:quality=>1, :name=>"Solid Eternity Amber (1)", :stats=>{}},
  192914=>{:quality=>1, :name=>"Solid Eternity Amber (2)", :stats=>{}},
  192916=>{:quality=>1, :name=>"Solid Eternity Amber (3)", :stats=>{}},
  192920=>{:quality=>1, :name=>"Sensei's Alexstraszite (1)", :stats=>{:crit=>49, :mastery=>23}},
  192921=>{:quality=>1, :name=>"Sensei's Alexstraszite (2)", :stats=>{:crit=>60, :mastery=>28}},
  192922=>{:quality=>1, :name=>"Sensei's Alexstraszite (3)", :stats=>{:crit=>70, :mastery=>33}},
  192923=>{:quality=>1, :name=>"Radiant Alexstraszite (1)", :stats=>{:crit=>49, :vers=>23}},
  192924=>{:quality=>1, :name=>"Radiant Alexstraszite (2)", :stats=>{:crit=>60, :vers=>28}},
  192925=>{:quality=>1, :name=>"Radiant Alexstraszite (3)", :stats=>{:crit=>70, :vers=>33}},
  192926=>{:quality=>1, :name=>"Deadly Alexstraszite (1)", :stats=>{:crit=>62}},
  192927=>{:quality=>1, :name=>"Deadly Alexstraszite (2)", :stats=>{:crit=>75}},
  192928=>{:quality=>1, :name=>"Deadly Alexstraszite (3)", :stats=>{:crit=>88}},
  192933=>{:quality=>1, :name=>"Energized Malygite (1)", :stats=>{:vers=>49, :haste=>23}},
  192934=>{:quality=>1, :name=>"Energized Malygite (2)", :stats=>{:vers=>60, :haste=>28}},
  192935=>{:quality=>1, :name=>"Energized Malygite (3)", :stats=>{:vers=>70, :haste=>33}},
  192936=>{:quality=>1, :name=>"Zen Malygite (1)", :stats=>{:vers=>49, :mastery=>23}},
  192937=>{:quality=>1, :name=>"Zen Malygite (2)", :stats=>{:vers=>60, :mastery=>28}},
  192938=>{:quality=>1, :name=>"Zen Malygite (3)", :stats=>{:vers=>70, :mastery=>33}},
  192929=>{:quality=>1, :name=>"Radiant Malygite (1)", :stats=>{:vers=>49, :crit=>23}},
  192931=>{:quality=>1, :name=>"Radiant Malygite (2)", :stats=>{:vers=>60, :crit=>28}},
  192932=>{:quality=>1, :name=>"Radiant Malygite (3)", :stats=>{:vers=>70, :crit=>33}},
  192940=>{:quality=>1, :name=>"Stormy Malygite (1)", :stats=>{:vers=>62}},
  192941=>{:quality=>1, :name=>"Stormy Malygite (2)", :stats=>{:vers=>75}},
  192942=>{:quality=>1, :name=>"Stormy Malygite (3)", :stats=>{:vers=>88}},
  192950=>{:quality=>1, :name=>"Energized Ysemerald (1)", :stats=>{:haste=>49, :vers=>23}},
  192951=>{:quality=>1, :name=>"Energized Ysemerald (2)", :stats=>{:haste=>60, :vers=>28}},
  192952=>{:quality=>1, :name=>"Energized Ysemerald (3)", :stats=>{:haste=>70, :vers=>33}},
  192946=>{:quality=>1, :name=>"Keen Ysemerald (1)", :stats=>{:haste=>49, :mastery=>23}},
  192947=>{:quality=>1, :name=>"Keen Ysemerald (2)", :stats=>{:haste=>60, :mastery=>28}},
  192948=>{:quality=>1, :name=>"Keen Ysemerald (3)", :stats=>{:haste=>70, :mastery=>33}},
  192943=>{:quality=>1, :name=>"Crafty Ysemerald (1)", :stats=>{:haste=>49, :crit=>23}},
  192944=>{:quality=>1, :name=>"Crafty Ysemerald (2)", :stats=>{:haste=>60, :crit=>28}},
  192945=>{:quality=>1, :name=>"Crafty Ysemerald (3)", :stats=>{:haste=>70, :crit=>33}},
  192953=>{:quality=>1, :name=>"Quick Ysemerald (1)", :stats=>{:haste=>62}},
  192954=>{:quality=>1, :name=>"Quick Ysemerald (2)", :stats=>{:haste=>75}},
  192955=>{:quality=>1, :name=>"Quick Ysemerald (3)", :stats=>{:haste=>88}},
  192962=>{:quality=>1, :name=>"Zen Neltharite (1)", :stats=>{:mastery=>49, :vers=>23}},
  192963=>{:quality=>1, :name=>"Zen Neltharite (2)", :stats=>{:mastery=>60, :vers=>28}},
  192964=>{:quality=>1, :name=>"Zen Neltharite (3)", :stats=>{:mastery=>70, :vers=>33}},
  192959=>{:quality=>1, :name=>"Keen Neltharite (1)", :stats=>{:mastery=>49, :haste=>23}},
  192960=>{:quality=>1, :name=>"Keen Neltharite (2)", :stats=>{:mastery=>60, :haste=>28}},
  192961=>{:quality=>1, :name=>"Keen Neltharite (3)", :stats=>{:mastery=>70, :haste=>33}},
  192956=>{:quality=>1, :name=>"Sensei's Neltharite (1)", :stats=>{:mastery=>49, :crit=>23}},
  192957=>{:quality=>1, :name=>"Sensei's Neltharite (2)", :stats=>{:mastery=>60, :crit=>28}},
  192958=>{:quality=>1, :name=>"Sensei's Neltharite (3)", :stats=>{:mastery=>70, :crit=>33}},
  192965=>{:quality=>1, :name=>"Fractured Neltharite (1)", :stats=>{:mastery=>62}},
  192966=>{:quality=>1, :name=>"Fractured Neltharite (2)", :stats=>{:mastery=>75}},
  192967=>{:quality=>1, :name=>"Fractured Neltharite (3)", :stats=>{:mastery=>88}},
  192968=>{:quality=>1, :name=>"Jagged Nozdorite (1)", :stats=>{:crit=>23}},
  192969=>{:quality=>1, :name=>"Jagged Nozdorite (2)", :stats=>{:crit=>28}},
  192970=>{:quality=>1, :name=>"Jagged Nozdorite (3)", :stats=>{:crit=>33}},
  192971=>{:quality=>1, :name=>"Forceful Nozdorite (1)", :stats=>{:haste=>23}},
  192972=>{:quality=>1, :name=>"Forceful Nozdorite (2)", :stats=>{:haste=>28}},
  192973=>{:quality=>1, :name=>"Forceful Nozdorite (3)", :stats=>{:haste=>33}},
  192974=>{:quality=>1, :name=>"Puissant Nozdorite (1)", :stats=>{:mastery=>23}},
  192975=>{:quality=>1, :name=>"Puissant Nozdorite (2)", :stats=>{:mastery=>28}},
  192976=>{:quality=>1, :name=>"Puissant Nozdorite (3)", :stats=>{:mastery=>33}},
  192977=>{:quality=>1, :name=>"Steady Nozdorite (1)", :stats=>{:vers=>23}},
  192978=>{:quality=>1, :name=>"Steady Nozdorite (2)", :stats=>{:vers=>28}},
  192979=>{:quality=>1, :name=>"Steady Nozdorite (3)", :stats=>{:vers=>33}},
  192980=>{:quality=>1, :name=>"Inscribed Illimited Diamond (1)", :stats=>{:crit=>46}},
  192981=>{:quality=>1, :name=>"Inscribed Illimited Diamond (2)", :stats=>{:crit=>56}},
  192982=>{:quality=>1, :name=>"Inscribed Illimited Diamond (3)", :stats=>{:crit=>66}},
  192986=>{:quality=>1, :name=>"Skillful Illimited Diamond (1)", :stats=>{:mastery=>46}},
  192987=>{:quality=>1, :name=>"Skillful Illimited Diamond (2)", :stats=>{:mastery=>56}},
  192988=>{:quality=>1, :name=>"Skillful Illimited Diamond (3)", :stats=>{:mastery=>66}},
  192989=>{:quality=>1, :name=>"Resplendent Illimited Diamond (1)", :stats=>{:vers=>46}},
  192990=>{:quality=>1, :name=>"Resplendent Illimited Diamond (2)", :stats=>{:vers=>56}},
  192991=>{:quality=>1, :name=>"Resplendent Illimited Diamond (3)", :stats=>{:vers=>66}},
  213453=>{:quality=>2, :name=>"Quick Ruby (1)", :stats=>{:crit=>118, :haste=>39}},
  213454=>{:quality=>2, :name=>"Quick Ruby (2)", :stats=>{:crit=>132, :haste=>44}},
  213456=>{:quality=>2, :name=>"Masterful Ruby (1)", :stats=>{:crit=>118, :mastery=>39}},
  213457=>{:quality=>2, :name=>"Masterful Ruby (2)", :stats=>{:crit=>132, :mastery=>44}},
  213458=>{:quality=>4, :name=>"Masterful Ruby (3)", :stats=>{:crit=>147, :mastery=>49}},
  213459=>{:quality=>2, :name=>"Versatile Ruby (1)", :stats=>{:crit=>118, :vers=>39}},
  213460=>{:quality=>2, :name=>"Versatile Ruby (2)", :stats=>{:crit=>132, :vers=>44}},
  213461=>{:quality=>4, :name=>"Versatile Ruby (3)", :stats=>{:crit=>147, :vers=>49}},
  213462=>{:quality=>2, :name=>"Deadly Ruby (1)", :stats=>{:crit=>141}},
  213463=>{:quality=>2, :name=>"Deadly Ruby (2)", :stats=>{:crit=>159}},
  213464=>{:quality=>4, :name=>"Deadly Ruby (3)", :stats=>{:crit=>176}},
  213465=>{:quality=>2, :name=>"Deadly Sapphire (1)", :stats=>{:vers=>118, :crit=>39}},
  213466=>{:quality=>2, :name=>"Deadly Sapphire (2)", :stats=>{:vers=>132, :crit=>44}},
  213467=>{:quality=>4, :name=>"Deadly Sapphire (3)", :stats=>{:vers=>147, :crit=>49}},
  213468=>{:quality=>2, :name=>"Quick Sapphire (1)", :stats=>{:vers=>118, :haste=>39}},
  213469=>{:quality=>2, :name=>"Quick Sapphire (2)", :stats=>{:vers=>132, :haste=>44}},
  213470=>{:quality=>4, :name=>"Quick Sapphire (3)", :stats=>{:vers=>147, :haste=>49}},
  213471=>{:quality=>2, :name=>"Masterful Sapphire (1)", :stats=>{:vers=>118, :mastery=>39}},
  213472=>{:quality=>2, :name=>"Masterful Sapphire (2)", :stats=>{:vers=>132, :mastery=>44}},
  213473=>{:quality=>4, :name=>"Masterful Sapphire (3)", :stats=>{:vers=>147, :mastery=>49}},
  213474=>{:quality=>2, :name=>"Versatile Sapphire (1)", :stats=>{:vers=>141}},
  213475=>{:quality=>2, :name=>"Versatile Sapphire (2)", :stats=>{:vers=>159}},
  213476=>{:quality=>4, :name=>"Versatile Sapphire (3)", :stats=>{:vers=>176}},
  213477=>{:quality=>2, :name=>"Deadly Emerald (1)", :stats=>{:haste=>118, :crit=>39}},
  213478=>{:quality=>2, :name=>"Deadly Emerald (2)", :stats=>{:haste=>132, :crit=>44}},
  213479=>{:quality=>4, :name=>"Deadly Emerald (3)", :stats=>{:haste=>147, :crit=>49}},
  213480=>{:quality=>2, :name=>"Masterful Emerald (1)", :stats=>{:haste=>118, :mastery=>39}},
  213481=>{:quality=>2, :name=>"Masterful Emerald (2)", :stats=>{:haste=>132, :mastery=>44}},
  213482=>{:quality=>4, :name=>"Masterful Emerald (3)", :stats=>{:haste=>147, :mastery=>49}},
  213483=>{:quality=>2, :name=>"Versatile Emerald (1)", :stats=>{:haste=>118, :vers=>39}},
  213484=>{:quality=>2, :name=>"Versatile Emerald (2)", :stats=>{:haste=>132, :vers=>44}},
  213485=>{:quality=>4, :name=>"Versatile Emerald (3)", :stats=>{:haste=>147, :vers=>49}},
  213486=>{:quality=>2, :name=>"Quick Emerald (1)", :stats=>{:haste=>141}},
  213487=>{:quality=>2, :name=>"Quick Emerald (2)", :stats=>{:haste=>159}},
  213488=>{:quality=>4, :name=>"Quick Emerald (3)", :stats=>{:haste=>176}},
  213489=>{:quality=>2, :name=>"Deadly Onyx (1)", :stats=>{:mastery=>118, :crit=>39}},
  213490=>{:quality=>2, :name=>"Deadly Onyx (2)", :stats=>{:mastery=>132, :crit=>44}},
  213491=>{:quality=>4, :name=>"Deadly Onyx (3)", :stats=>{:mastery=>147, :crit=>49}},
  213492=>{:quality=>2, :name=>"Quick Onyx (1)", :stats=>{:mastery=>118, :haste=>39}},
  213493=>{:quality=>2, :name=>"Quick Onyx (2)", :stats=>{:mastery=>132, :haste=>44}},
  213494=>{:quality=>4, :name=>"Quick Onyx (3)", :stats=>{:mastery=>147, :haste=>49}},
  213495=>{:quality=>2, :name=>"Versatile Onyx (1)", :stats=>{:mastery=>118, :vers=>39}},
  213496=>{:quality=>2, :name=>"Versatile Onyx (2)", :stats=>{:mastery=>132, :vers=>44}},
  213497=>{:quality=>4, :name=>"Versatile Onyx (3)", :stats=>{:mastery=>147, :vers=>49}},
  213498=>{:quality=>2, :name=>"Masterful Onyx (1)", :stats=>{:mastery=>141}},
  213499=>{:quality=>2, :name=>"Masterful Onyx (2)", :stats=>{:mastery=>159}},
  213500=>{:quality=>4, :name=>"Masterful Onyx (3)", :stats=>{:mastery=>176}},
  213501=>{:quality=>2, :name=>"Deadly Amber (1)", :stats=>{:crit=>39}},
  213502=>{:quality=>2, :name=>"Deadly Amber (2)", :stats=>{:crit=>44}},
  213503=>{:quality=>4, :name=>"Deadly Amber (3)", :stats=>{:crit=>49}},
  213504=>{:quality=>2, :name=>"Quick Amber (1)", :stats=>{:haste=>39}},
  213505=>{:quality=>2, :name=>"Quick Amber (2)", :stats=>{:haste=>44}},
  213506=>{:quality=>4, :name=>"Quick Amber (3)", :stats=>{:haste=>49}},
  213507=>{:quality=>2, :name=>"Masterful Amber (1)", :stats=>{:mastery=>39}},
  213508=>{:quality=>2, :name=>"Masterful Amber (2)", :stats=>{:mastery=>44}},
  213509=>{:quality=>4, :name=>"Masterful Amber (3)", :stats=>{:mastery=>49}},
  213510=>{:quality=>2, :name=>"Versatile Amber (1)", :stats=>{:vers=>39}},
  213511=>{:quality=>2, :name=>"Versatile Amber (2)", :stats=>{:vers=>44}},
  213512=>{:quality=>4, :name=>"Versatile Amber (3)", :stats=>{:vers=>49}},
  213515=>{:quality=>2, :name=>"Solid Amber (1)", :stats=>{}},
  213516=>{:quality=>2, :name=>"Solid Amber (2)", :stats=>{}},
  213517=>{:quality=>4, :name=>"Solid Amber (3)", :stats=>{}},
  213455=>{:quality=>4, :name=>"Quick Ruby (3)", :stats=>{:crit=>147, :haste=>49}},
  213738=>{:quality=>4, :name=>"Insightful Blasphemite (1)", :stats=>{}},
  213739=>{:quality=>4, :name=>"Insightful Blasphemite (2)", :stats=>{}},
  213740=>{:quality=>4, :name=>"Insightful Blasphemite (3)", :stats=>{}},
  213741=>{:quality=>4, :name=>"Culminating Blasphemite (1)", :stats=>{}},
  213742=>{:quality=>4, :name=>"Culminating Blasphemite (2)", :stats=>{}},
  213743=>{:quality=>4, :name=>"Culminating Blasphemite (3)", :stats=>{}},
  213744=>{:quality=>4, :name=>"Elusive Blasphemite (1)", :stats=>{}},
  213745=>{:quality=>4, :name=>"Elusive Blasphemite (2)", :stats=>{}},
  213746=>{:quality=>4, :name=>"Elusive Blasphemite (3)", :stats=>{}},
  213747=>{:quality=>4, :name=>"Enduring Bloodstone ()", :stats=>{}},
  213748=>{:quality=>4, :name=>"Cognitive Bloodstone ()", :stats=>{}},
  213749=>{:quality=>4, :name=>"Determined Bloodstone ()", :stats=>{}},
  217113=>{:quality=>4, :name=>"Cubic Blasphemia (1)", :stats=>{}},
  217114=>{:quality=>4, :name=>"Cubic Blasphemia (2)", :stats=>{}},
  217115=>{:quality=>4, :name=>"Cubic Blasphemia (3)", :stats=>{}}
}

EPIC_GEMS = {
  192980 => 1, # Dragonflight, Epic (385)
  192983 => 1,
  192989 => 1,
  192986 => 1,
  194112 => 1,
  192987 => 1, # Epic (400)
  192981 => 1,
  192990 => 1,
  192984 => 1,
  194113 => 1,
  192985 => 1, # Epic (415)
  192982 => 1,
  192988 => 1,
  192991 => 1,
  194114 => 1,
  213741 => 2, # War Within, Epic (580)
  213744 => 2,
  213738 => 2,
  217113 => 2,
  213739 => 2, # Epic (595)
  213742 => 2,
  213745 => 2,
  217114 => 2,
  213743 => 4, # Epic (610)
  213746 => 4,
  213740 => 4,
  217115 => 2,
}

CIRCLET_GEMS = {
  228634 => 'Thunderlord',
  228635 => 'Squall Sailor',
  228636 => 'Undersea',
  228638 => 'Stormbringer',
  228639 => 'Fathomdweller',
  228640 => 'Windsinger',
  228642 => 'Storm Sewer',
  228643 => 'Old Salt',
  228644 => 'Mariner',
  228646 => 'Legendary',
  228647 => 'Seabed',
  228648 => 'Roaring',
}

TIER_ITEMS_BY_SLOT = {
  'head' => [
    # Liberation of Undermine
    229271, 229262, 229325, 229235, 229244, 229298, 229316, 229289, 229307, 229343, 229334, 229253, 229280
  ],
  'shoulder' => [
    # Liberation of Undermine
    229242, 229305, 229260, 229296, 229341, 229332, 229251, 229323, 229233, 229314, 229278, 229287, 229269
  ],
  'chest' => [
    # Liberation of Undermine
    229256, 229337, 229247, 229265, 229274, 229346, 229301, 229310, 229328, 229238, 229319, 229292, 229283
  ],
  'hands' => [
    # Liberation of Undermine
    229263, 229254, 229335, 229272, 229245, 229236, 229299, 229308, 229317, 229326, 229344, 229290, 229281
  ],
  'legs' => [
    # Liberation of Undermine
    229243, 229306, 229270, 229324, 229261, 229234, 229342, 229297, 229288, 229315, 229333, 229252, 229279
  ],
}

TIER_ITEMS = TIER_ITEMS_BY_SLOT.values.flatten

LEGACY_TIER_CUTOFFS = { 1 => 'R', 636 => 'N', 649 => 'H', 662 => 'M' }
