EXPANSION_PROFESSIONS = {
  2871 => "Alchemy",
  2872 => "Blacksmithing",
  2874 => "Enchanting",
  2875 => "Engineering",
  2877 => "Herbalism",
  2878 => "Inscription",
  2879 => "Jewelcrafting",
  2880 => "Leatherworking",
  2881 => "Mining",
  2882 => "Skinning",
  2883 => "Tailoring"
}

BASE_PROFESSIONS = {
  171 => "Alchemy",
  164 => "Blacksmithing",
  333 => "Enchanting",
  202 => "Engineering",
  182 => "Herbalism",
  773 => "Inscription",
  755 => "Jewelcrafting",
  165 => "Leatherworking",
  186 => "Mining",
  393 => "Skinning",
  197 => "Tailoring"
}

# Example to generate:
# https://www.wowhead.com/guide/the-war-within/professions/tailoring-overview#tailoring-recipes
# $("div[id^='tab-tailoring'] tr").each((i, row) => $(row).find("td:last-of-type").text() == "Profession Trainer" || $(row).find("td:last-of-type").text().includes("Automatically") || $(row).find("td:last-of-type").text() == "Source" || $(row).find("td:last-of-type").text() == "" ? null : console.log(`"${$(row).find("td:first-of-type a[data-type='item']").find("img").attr("alt")}" => { id: ${$(row).find("td:first-of-type a[data-type='item']").attr('href')?.split("/item=")[1].split("/")[0]}, profession: 'Tailoring' },`))
SPARK_RECIPE_NAME_TO_ITEM_ID = {
  "Algari Alchemist Stone" =>	{ id: 210816, profession: 'Alchemy' },
  "Algari Flask Cauldron" =>	{ id: 212719, profession: 'Alchemy' },
  "Algari Potion Cauldron" =>	{ id: 212751, profession: 'Alchemy' },
  "Everforged Warglaive" =>	{ id: 222441, profession: 'Blacksmithing' },
  "Everforged Greataxe" =>	{ id: 222443, profession: 'Blacksmithing' },
  "Everforged Longsword" =>	{ id: 222440, profession: 'Blacksmithing' },
  "Everforged Dagger" =>	{ id: 222439, profession: 'Blacksmithing' },
  "Everforged Vambraces" =>	{ id: 222435, profession: 'Blacksmithing' },
  "Everforged Pauldrons" =>	{ id: 222436, profession: 'Blacksmithing' },
  "Everforged Breastplate" =>	{ id: 222430, profession: 'Blacksmithing' },
  "Everforged Mace" =>	{ id: 222442, profession: 'Blacksmithing' },
  "Everforged Defender" =>	{ id: 222432, profession: 'Blacksmithing' },
  "Everforged Sabatons" =>	{ id: 222429, profession: 'Blacksmithing' },
  "Everforged Greatbelt" =>	{ id: 222431, profession: 'Blacksmithing' },
  "Everforged Stabber" =>	{ id: 222438, profession: 'Blacksmithing' },
  "Everforged Helm" =>	{ id: 222433, profession: 'Blacksmithing' },
  "Everforged Legplates" =>	{ id: 222434, profession: 'Blacksmithing' },
  "Everforged Gauntlets" =>	{ id: 222437, profession: 'Blacksmithing' },
  "Charged Slicer" => { id: 222451, profession: 'Blacksmithing' },
  "Charged Claymore" => { id: 222447, profession: 'Blacksmithing' },
  "Charged Halberd" => { id: 222448, profession: 'Blacksmithing' },
  "Charged Facesmasher" => { id: 222446, profession: 'Blacksmithing' },
  "Charged Hexsword" => { id: 222444, profession: 'Blacksmithing' },
  "Charged Runeaxe" => { id: 222445, profession: 'Blacksmithing' },
  "Charged Crusher" => { id: 222449, profession: 'Blacksmithing' },
  "Charged Invoker" => { id: 222450, profession: 'Blacksmithing' },
  "Beledar's Bulwark" => { id: 222459, profession: 'Blacksmithing' },
  "Sanctified Steps" => { id: 222458, profession: 'Blacksmithing' },
  "Siphoning Stiletto" => { id: 222463, profession: 'Blacksmithing' },
  "Artisan Leatherworker's Toolset" => { id: 222493, profession: 'Blacksmithing' },
  "Artisan Needle Set" => { id: 222491, profession: 'Blacksmithing' },
  "Artisan Leatherworker's Knife" => { id: 222492, profession: 'Blacksmithing' },
  "Artisan Sickle" => { id: 222488, profession: 'Blacksmithing' },
  "Artisan Pickaxe" => { id: 222489, profession: 'Blacksmithing' },
  "Artisan Skinning Knife" => { id: 222490, profession: 'Blacksmithing' },
  "Magnificent Jeweler's Setting" =>	{ id: 213777, profession: 'Jewelcrafting' },
  "Culminating Blasphemite" =>	{ id: 213741, profession: 'Jewelcrafting' },
  "Elusive Blasphemite" =>	{ id: 213744, profession: 'Jewelcrafting' },
  "Insightful Blasphemite" =>	{ id: 213738, profession: 'Jewelcrafting' },
  "Binding of Binding" =>	{ id: 215133, profession: 'Jewelcrafting' },
  "Fractured Gemstone Locket" =>	{ id: 215134, profession: 'Jewelcrafting' },
  "Ring of Earthen Craftsmanship" =>	{ id: 215135, profession: 'Jewelcrafting' },
  "Amulet of Earthen Craftsmanship" =>	{ id: 215136, profession: 'Jewelcrafting' },
  "Enchanter's Crystal" =>	{ id: 215125, profession: 'Jewelcrafting' },
  "Extravagant Loupes" =>	{ id: 215124, profession: 'Jewelcrafting' },
  "Forger's Font Inspector" =>	{ id: 215123, profession: 'Jewelcrafting' },
  "Novelist's Specs" =>	{ id: 215122, profession: 'Jewelcrafting' },
  "Transcribe to Radiance" => { id: 222625, profession: 'Inscription' },
  "Transcribe to Symbiosis" => { id: 222624, profession: 'Inscription' },
  "Transcribe to Vivacity" => { id: 222623, profession: 'Inscription' },
  "Transcribe to Ascension" => { id: 222622, profession: 'Inscription' },
  "Darkmoon Sigil: Radiance" => { id: 226025, profession: 'Inscription' },
  "Darkmoon Sigil: Vivacity" => { id: 226031, profession: 'Inscription' },
  "Darkmoon Sigil: Symbiosis" => { id: 226028, profession: 'Inscription' },
  "Darkmoon Sigil: Ascension" => { id: 226022, profession: 'Inscription' },
  "Vagabond's Bounding Baton" => { id: 222568, profession: 'Inscription' },
  "Vagabond's Careful Crutch" => { id: 222567, profession: 'Inscription' },
  "Vagabond's Torch" => { id: 222566, profession: 'Inscription' },
  "Contract: Assembly of the Deeps" => { id: 222600, profession: 'Inscription' },
  "Contract: Hallowfall Arathi" => { id: 222603, profession: 'Inscription' },
  "Contract: The Severed Threads" => { id: 222606, profession: 'Inscription' },
  "Contract: Council of Dornogal" => { id: 222597, profession: 'Inscription' },
  "Algari Missive of Crafting Speed" => { id: 219660, profession: 'Inscription' },
  "Algari Missive of Deftness" => { id: 222644, profession: 'Inscription' },
  "Algari Missive of Finesse" => { id: 222638, profession: 'Inscription' },
  "Algari Missive of Ingenuity" => { id: 222626, profession: 'Inscription' },
  "Algari Missive of Multicraft" => { id: 222632, profession: 'Inscription' },
  "Algari Missive of Perception" => { id: 222641, profession: 'Inscription' },
  "Algari Missive of Resourcefulness" => { id: 222629, profession: 'Inscription' },
  "Inscribed Rolling Pin" => { id: 222578, profession: 'Inscription' },
  "Silver Tongue's Quill" => { id: 222574, profession: 'Inscription' },
  "Patient Alchemist's Mixing Rod" => { id: 222576, profession: 'Inscription' },
  "Algari Treatise on Inscription" => { id: 222548, profession: 'Inscription' },
  "Algari Treatise on Blacksmithing" => { id: 222554, profession: 'Inscription' },
  "Algari Treatise on Enchanting" => { id: 222550, profession: 'Inscription' },
  "Algari Treatise on Engineering" => { id: 222621, profession: 'Inscription' },
  "Algari Treatise on Herbalism" => { id: 222552, profession: 'Inscription' },
  "Algari Treatise on Alchemy" => { id: 222546, profession: 'Inscription' },
  "Algari Treatise on Jewelcrafting" => { id: 222551, profession: 'Inscription' },
  "Algari Treatise on Leatherworking" => { id: 222549, profession: 'Inscription' },
  "Algari Treatise on Mining" => { id: 222553, profession: 'Inscription' },
  "Algari Treatise on Skinning" => { id: 222649, profession: 'Inscription' },
  "Algari Treatise on Tailoring" => { id: 222547, profession: 'Inscription' },
  "Algari Competitor's Emblem" => { id: 219933, profession: 'Inscription' },
  "Algari Competitor's Pillar" => { id: 225368, profession: 'Inscription' },
  "Algari Competitor's Staff" => { id: 225369, profession: 'Inscription' },
  "Algari Competitor's Lamp" => { id: 225372, profession: 'Inscription' },
  "Algari Competitor's Insignia of Alacrity" => { id: 219932, profession: 'Inscription' },
  "Algari Competitor's Medallion" => { id: 219931, profession: 'Inscription' },
  "Consecrated Cloak" => { id: 222817, profession: 'Tailoring' },
  "Consecrated Cord" => { id: 222816, profession: 'Tailoring' },
  "Consecrated Cuffs" => { id: 222815, profession: 'Tailoring' },
  "Consecrated Gloves" => { id: 222822, profession: 'Tailoring' },
  "Consecrated Hood" => { id: 222818, profession: 'Tailoring' },
  "Consecrated Leggings" => { id: 222820, profession: 'Tailoring' },
  "Consecrated Mantle" => { id: 222821, profession: 'Tailoring' },
  "Consecrated Robe" => { id: 222819, profession: 'Tailoring' },
  "Consecrated Slippers" => { id: 222814, profession: 'Tailoring' },
  "Artisan Alchemist's Robe" => { id: 222850, profession: 'Tailoring' },
  "Artisan Enchanter's Hat" => { id: 222849, profession: 'Tailoring' },
  "Artisan Chef's Hat" => { id: 222851, profession: 'Tailoring' },
  "Artisan Fishing Cap" => { id: 222848, profession: 'Tailoring' },
  "Artisan Gardening Hat" => { id: 222847, profession: 'Tailoring' },
  "Concoctor's Clutch" => { id: 222859, profession: 'Tailoring' },
  "Darkmoon Duffle" => { id: 222864, profession: 'Tailoring' },
  "Excavator's Haversack" => { id: 222866, profession: 'Tailoring' },
  "Ignition Satchel" => { id: 222860, profession: 'Tailoring' },
  "Jeweler's Purse" => { id: 222867, profession: 'Tailoring' },
  "Magically \"Infinite\" Messenger" => { id: 222862, profession: 'Tailoring' },
  "Prodigy's Toolbox" => { id: 222863, profession: 'Tailoring' },
  "The Severed Satchel" => { id: 224852, profession: 'Tailoring' },
  "Duskweave Bag" => { id: 222856, profession: 'Tailoring' },
  "Dawnweave Reagent Bag" => { id: 222854, profession: 'Tailoring' },
  "Gardener's Seed Satchel" => { id: 222865, profession: 'Tailoring' },
  "Hideseeker's Tote" => { id: 225936, profession: 'Tailoring' },
  "Hideshaper's Workbag" => { id: 222861, profession: 'Tailoring' },
  "Grips of the Woven Dawn" => { id: 222807, profession: 'Tailoring' },
  "Treads of the Woven Dawn" => { id: 222808, profession: 'Tailoring' },
  "Warm Sunrise Bracers" => { id: 222811, profession: 'Tailoring' },
  "Cool Sunset Bracers" => { id: 222812, profession: 'Tailoring' },
  "Gloves of the Woven Dusk" => { id: 222809, profession: 'Tailoring' },
  "Slippers of the Woven Dusk" => { id: 222810, profession: 'Tailoring' },
  "Dawnthread Lining" => { id: 222868, profession: 'Tailoring' },
  "Duskthread Lining" => { id: 222872, profession: 'Tailoring' },
  "Daybreak Spellthread" => { id: 222894, profession: 'Tailoring' },
  "Sunset Spellthread" => { id: 222891, profession: 'Tailoring' },
  "Algari Competitor's Cloth Bands" => { id: 217120, profession: 'Tailoring' },
  "Algari Competitor's Cloth Cloak" => { id: 217125, profession: 'Tailoring' },
  "Algari Competitor's Cloth Gloves" => { id: 217122, profession: 'Tailoring' },
  "Algari Competitor's Cloth Hood" => { id: 217121, profession: 'Tailoring' },
  "Algari Competitor's Cloth Leggings" => { id: 217117, profession: 'Tailoring' },
  "Algari Competitor's Cloth Sash" => { id: 217124, profession: 'Tailoring' },
  "Algari Competitor's Cloth Shoulderpads" => { id: 217118, profession: 'Tailoring' },
  "Algari Competitor's Cloth Treads" => { id: 217119, profession: 'Tailoring' },
  "Algari Competitor's Cloth Tunic" => { id: 217123, profession: 'Tailoring' },
  "Defender's Armor Kit" => { id: 219906, profession: 'Leatherworking' },
  "Stormbound Armor Kit" => { id: 219909, profession: 'Leatherworking' },
  "Rune-Branded Armbands" => { id: 219334, profession: 'Leatherworking' },
  "Rune-Branded Grasps" => { id: 219333, profession: 'Leatherworking' },
  "Rune-Branded Hood" => { id: 219329, profession: 'Leatherworking' },
  "Rune-Branded Kickers" => { id: 219327, profession: 'Leatherworking' },
  "Rune-Branded Legwraps" => { id: 219332, profession: 'Leatherworking' },
  "Rune-Branded Mantle" => { id: 219330, profession: 'Leatherworking' },
  "Rune-Branded Tunic" => { id: 219328, profession: 'Leatherworking' },
  "Rune-Branded Waistband" => { id: 219331, profession: 'Leatherworking' },
  "Glyph-Etched Binding" => { id: 219339, profession: 'Leatherworking' },
  "Glyph-Etched Breastplate" => { id: 219336, profession: 'Leatherworking' },
  "Glyph-Etched Cuisses" => { id: 219340, profession: 'Leatherworking' },
  "Glyph-Etched Epaulets" => { id: 219338, profession: 'Leatherworking' },
  "Glyph-Etched Gauntlets" => { id: 219341, profession: 'Leatherworking' },
  "Glyph-Etched Guise" => { id: 219337, profession: 'Leatherworking' },
  "Glyph-Etched Stompers" => { id: 219335, profession: 'Leatherworking' },
  "Glyph-Etched Vambraces" => { id: 219342, profession: 'Leatherworking' },
  "Sanctified Torchbearer's Grips" => { id: 219492, profession: 'Leatherworking' },
  "Waders of the Unifying Flame" => { id: 219489, profession: 'Leatherworking' },
  "Blessed Weapon Grip" => { id: 219495, profession: 'Leatherworking' },
  "Adrenal Surge Clasp" => { id: 219502, profession: 'Leatherworking' },
  "Vambraces of Deepening Darkness" => { id: 219501, profession: 'Leatherworking' },
  "Writhing Armor Banding" => { id: 219504, profession: 'Leatherworking' },
  "Busy Bee's Buckle" => { id: 219509, profession: 'Leatherworking' },
  "Roiling Thunderstrike Talons" => { id: 219513, profession: 'Leatherworking' },
  "Rook Feather Wristwraps" => { id: 219511, profession: 'Leatherworking' },
  "Reinforced Setae Flyers" => { id: 219508, profession: 'Leatherworking' },
  "Smoldering Pollen Hauberk" => { id: 219507, profession: 'Leatherworking' },
  "Weathered Stormfront Vest" => { id: 219512, profession: 'Leatherworking' },
  "Algari Competitor's Leather Belt" => { id: 217130, profession: 'Leatherworking' },
  "Algari Competitor's Leather Boots" => { id: 217126, profession: 'Leatherworking' },
  "Algari Competitor's Leather Chestpiece" => { id: 217127, profession: 'Leatherworking' },
  "Algari Competitor's Leather Gloves" => { id: 217132, profession: 'Leatherworking' },
  "Algari Competitor's Leather Mask" => { id: 217128, profession: 'Leatherworking' },
  "Algari Competitor's Leather Shoulderpads" => { id: 217129, profession: 'Leatherworking' },
  "Algari Competitor's Leather Trousers" => { id: 217131, profession: 'Leatherworking' },
  "Algari Competitor's Leather Wristwraps" => { id: 217133, profession: 'Leatherworking' },
  "Algari Competitor's Chain Chainmail" => { id: 217135, profession: 'Leatherworking' },
  "Algari Competitor's Chain Cowl" => { id: 217136, profession: 'Leatherworking' },
  "Algari Competitor's Chain Cuffs" => { id: 217141, profession: 'Leatherworking' },
  "Algari Competitor's Chain Epaulets" => { id: 217137, profession: 'Leatherworking' },
  "Algari Competitor's Chain Gauntlets" => { id: 217140, profession: 'Leatherworking' },
  "Algari Competitor's Chain Girdle" => { id: 217138, profession: 'Leatherworking' },
  "Algari Competitor's Chain Leggings" => { id: 217139, profession: 'Leatherworking' },
  "Algari Competitor's Chain Treads" => { id: 217134, profession: 'Leatherworking' },
  "Arathi Leatherworker's Smock" => { id: 219871, profession: 'Leatherworking' },
  "Charged Scrapmaster's Gauntlets" => { id: 219870, profession: 'Leatherworking' },
  "Earthen Forgemaster's Apron" => { id: 219874, profession: 'Leatherworking' },
  "Earthen Jeweler's Cover" => { id: 219876, profession: 'Leatherworking' },
  "Stonebound Herbalist's Pack" => { id: 219867, profession: 'Leatherworking' },
  "Deep Tracker's Cap" => { id: 219869, profession: 'Leatherworking' },
  "Deep Tracker's Pack" => { id: 219868, profession: 'Leatherworking' },
  "Nerubian Alchemist's Hat" => { id: 219872, profession: 'Leatherworking' },
  "Enchanted Gilded Harbinger Crest" => { id: 224073, profession: 'Enchanting' },
  "Enchanted Runed Harbinger Crest" => { id: 224072, profession: 'Enchanting' },
  "Enchanted Weathered Harbinger Crest" => { id: 224069, profession: 'Enchanting' },
  "Concentration Concentrate" => { id: 224173, profession: 'Enchanting' },
  "Oil of Beledar's Grace" => { id: 224108, profession: 'Enchanting' },
  "Oil of Deep Toxins" => { id: 224111, profession: 'Enchanting' },
  "Scepter of Radiant Magics" => { id: 224405, profession: 'Enchanting' },
  "Runed Null Stone Rod" => { id: 224116, profession: 'Enchanting' },
  "Runed Ironclaw Rod" => { id: 224115, profession: 'Enchanting' },
  "Cavalry's March" => { id: 50475, profession: 'Enchanting' },
  "Defender's March" => { id: 50477, profession: 'Enchanting' },
  "Scout's March" => { id: 50476, profession: 'Enchanting' },
  "Chant of Armored Avoidance" => { id: 50521, profession: 'Enchanting' },
  "Chant of Armored Leech" => { id: 50523, profession: 'Enchanting' },
  "Chant of Armored Speed" => { id: 50525, profession: 'Enchanting' },
  "Council's Intellect" => { id: 50503, profession: 'Enchanting' },
  "Crystalline Radiance" => { id: 50504, profession: 'Enchanting' },
  "Oathsworn's Strength" => { id: 50505, profession: 'Enchanting' },
  "Stormrider's Agility" => { id: 50501, profession: 'Enchanting' },
  "Chant of Burrowing Rapidity" => { id: 50531, profession: 'Enchanting' },
  "Chant of Leeching Fangs" => { id: 50529, profession: 'Enchanting' },
  "Chant of Winged Grace" => { id: 50527, profession: 'Enchanting' },
  "Algari Deftness" => { id: 50506, profession: 'Enchanting' },
  "Algari Finesse" => { id: 50507, profession: 'Enchanting' },
  "Algari Ingenuity" => { id: 50508, profession: 'Enchanting' },
  "Algari Perception" => { id: 50509, profession: 'Enchanting' },
  "Algari Resourcefulness" => { id: 50510, profession: 'Enchanting' },
  "Radiant Critical Strike" => { id: 50479, profession: 'Enchanting' },
  "Radiant Haste" => { id: 50481, profession: 'Enchanting' },
  "Radiant Mastery" => { id: 50483, profession: 'Enchanting' },
  "Radiant Versatility" => { id: 50485, profession: 'Enchanting' },
  "Cursed Critical Strike" => { id: 50532, profession: 'Enchanting' },
  "Cursed Haste" => { id: 50533, profession: 'Enchanting' },
  "Cursed Mastery" => { id: 50534, profession: 'Enchanting' },
  "Cursed Versatility" => { id: 50535, profession: 'Enchanting' },
  "Authority of Air" => { id: 50486, profession: 'Enchanting' },
  "Authority of Fiery Resolve" => { id: 50487, profession: 'Enchanting' },
  "Authority of Radiant Power" => { id: 50488, profession: 'Enchanting' },
  "Authority of Storms" => { id: 50511, profession: 'Enchanting' },
  "Authority of the Depths" => { id: 50536, profession: 'Enchanting' },
  "Entropy Enhancer" => { id: 221868, profession: 'Engineering' },
  "Chaos Circuit" => { id: 221865, profession: 'Engineering' },
  "Bottled Brilliance" => { id: 225987, profession: 'Engineering' },
  "Safety Switch" => { id: 221862, profession: 'Engineering' },
  "Gyrating Gear" => { id: 221859, profession: 'Engineering' },
  "Whimsical Wiring" => { id: 221856, profession: 'Engineering' },
  "Handful of Bismuth Bolts" => { id: 221853, profession: 'Engineering' },
  "Blame Redirection Device" => { id: 221926, profession: 'Engineering' },
  "Complicated Fuse Box" => { id: 221932, profession: 'Engineering' },
  "Recalibrated Safety Switch" => { id: 221923, profession: 'Engineering' },
  "Concealed Chaos Module" => { id: 221938, profession: 'Engineering' },
  "Energy Redistribution Beacon" => { id: 221941, profession: 'Engineering' },
  "Pouch of Pocket Grenades" => { id: 221935, profession: 'Engineering' },
  "Adjustable Cogwheel" => { id: 221920, profession: 'Engineering' },
  "Impeccable Cogwheel" => { id: 221917, profession: 'Engineering' },
  "Overclocked Cogwheel" => { id: 221914, profession: 'Engineering' },
  "Serrated Cogwheel" => { id: 221911, profession: 'Engineering' },
  "Blasting Bracers" => { id: 221805, profession: 'Engineering' },
  "Clanking Cuffs" => { id: 221808, profession: 'Engineering' },
  "Dangerous Distraction Inhibitor" => { id: 221804, profession: 'Engineering' },
  "Overclocked Idea Generator" => { id: 221802, profession: 'Engineering' },
  "P.0.W. x2" => { id: 221969, profession: 'Engineering' },
  "Studious Brilliance Expeditor" => { id: 221801, profession: 'Engineering' },
  "Supercharged Thought Enhancer" => { id: 221803, profession: 'Engineering' },
  "Venting Vambraces" => { id: 221806, profession: 'Engineering' },
  "Whirring Wristwraps" => { id: 221807, profession: 'Engineering' },
  "Aqirite Brainwave Projector" => { id: 221789, profession: 'Engineering' },
  "Aqirite Fisherfriend" => { id: 221791, profession: 'Engineering' },
  "Aqirite Fueled Samophlange" => { id: 221798, profession: 'Engineering' },
  "Aqirite Miner's Headgear" => { id: 221796, profession: 'Engineering' },
  "Lapidary's Aqirite Clamps" => { id: 221793, profession: 'Engineering' },
  "Miner's Aqirite Hoard" => { id: 221800, profession: 'Engineering' },
  "Spring-Loaded Aqirite Fabric Cutters" => { id: 221787, profession: 'Engineering' },
  "Bismuth Brainwave Projector" => { id: 221788, profession: 'Engineering' },
  "Bismuth Fisherfriend" => { id: 221790, profession: 'Engineering' },
  "Bismuth Miner's Headgear" => { id: 221795, profession: 'Engineering' },
  "Lapidary's Bismuth Clamps" => { id: 221792, profession: 'Engineering' },
  "Miner's Bismuth Hoard" => { id: 221799, profession: 'Engineering' },
  "Spring-Loaded Bismuth Fabric Cutters" => { id: 221786, profession: 'Engineering' },
  "Box o' Booms" => { id: 224586, profession: 'Engineering' },
  "Potion Bomb of Power" => { id: 221880, profession: 'Engineering' },
  "Potion Bomb of Recovery" => { id: 221876, profession: 'Engineering' },
  "Potion Bomb of Speed" => { id: 221872, profession: 'Engineering' },
  "Crowd Pummeler 2-30" => { id: 221967, profession: 'Engineering' },
  "Convincingly Realistic Jumper Cables" => { id: 221953, profession: 'Engineering' },
  "Irresistible Red Button" => { id: 221945, profession: 'Engineering' },
  "Pausing Pylon" => { id: 221949, profession: 'Engineering' },
  "Algari Repair Bot 11O" => { id: 221957, profession: 'Engineering' },
  "Portable Profession Possibility Projector" => { id: 221959, profession: 'Engineering' },
  "Barrel of Fireworks" => { id: 219387, profession: 'Engineering' },
  "Defective Escape Pod" => { id: 221962, profession: 'Engineering' },
  "Filmless Camera" => { id: 221964, profession: 'Engineering' },
  "Wormhole Generator: Khaz Algar" => { id: 221966, profession: 'Engineering' },
  "Stonebound Lantern" => { id: 219403, profession: 'Engineering' },
  "Tinker: Earthen Delivery Drill" => { id: 221904, profession: 'Engineering' },
  "Tinker: Heartseeking Health Injector" => { id: 221908, profession: 'Engineering' },
  "Algari Competitor's Cloth Bracers" => { id: 217155, profession: 'Engineering' },
  "Algari Competitor's Cloth Goggles" => { id: 217151, profession: 'Engineering' },
  "Algari Competitor's Leather Bracers" => { id: 217156, profession: 'Engineering' },
  "Algari Competitor's Leather Goggles" => { id: 217152, profession: 'Engineering' },
  "Algari Competitor's Mail Bracers" => { id: 217157, profession: 'Engineering' },
  "Algari Competitor's Mail Goggles" => { id: 217153, profession: 'Engineering' },
  "Algari Competitor's Plate Bracers" => { id: 217158, profession: 'Engineering' },
  "Algari Competitor's Plate Goggles" => { id: 217154, profession: 'Engineering' },
  "Algari Competitor's Rifle" => { id: 225370, profession: 'Engineering' },
}
