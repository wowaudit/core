# -*- coding: utf-8 -*-
from execute_query import execute_query

def realms(realms_kr,realms_tw):
  kr = ["(\"KR\",\"{0}\")".format(i) for i in realms_kr]
  tw = ["(\"TW\",\"{0}\")".format(i) for i in realms_tw]
  execute_query("INSERT INTO realms (region, name) VALUES {0}".format(','.join(kr)))
  execute_query("INSERT INTO realms (region, name) VALUES {0}".format(','.join(tw)))


eu = ["Aegwynn",  "Aerie Peak",  "Agamaggan",  "Aggra (Português)",  "Aggramar",  "Ahn'Qiraj",  "Al'Akir",  "Alexstrasza",  "Alleria",\
         "Alonsus",  "Aman'Thul",  "Ambossar",  "Anachronos",  "Anetheron",  "Antonidas",  "Anub'arak",  "Arak-arahm",  "Arathi",\
         "Arathor",  "Archimonde",  "Area 52",  "Argent Dawn",  "Arthas",  "Arygos",  "Ashenvale",  "Aszune",  "Auchindoun",\
         "Azjol-Nerub",  "Azshara",  "Azuregos",  "Azuremyst",  "Baelgun",  "Balnazzar",  "Benedictus",\
         "Blackhand",  "Blackmoore",  "Blackrock",  "Blackscar", "Bladefist",\
         "Blade's Edge",  "Bloodfeather",  "Bloodhoof",  "Bloodscalp",  "Blutkessel",  "Booty Bay",  "Borean Tundra",\
         "Boulderfist",  "Brill",  "Bronze Dragonflight",  "Bronzebeard",   "Burning Blade",  "Burning Legion", "Burning Steppes",\
         "Chamber Of Aspects",  "Chants éternels",  "Cho'gall",  "Chromaggus",  "Colinas Pardas",  "Confrérie Du Thorium",\
         "Conseil des Ombres",  "Crushridge",  "C'Thun",  "Culte de la Rive noire",  "Daggerspine",  "Dalaran", "Dalvengyr",\
         "Darkmoon Faire",  "Darksorrow",  "Darkspear",  "Das Konsortium",  "Das Syndikat",  "Deathguard", "Deathweaver",\
         "Deathwing",  "Deepholm",  "Defias Brotherhood",  "Dentarg",  "Der Abyssische Rat",  "Der Mithrilorden",\
         "Der Rat Von Dalaran",  "Destromath",  "Dethecus",  "Die Aldor",  "Die Arguswacht",  "Die Ewige Wacht",  "Die Nachtwache",\
         "Die Silberne Hand",  "Die Todeskrallen",  "Doomhammer",  "Draenor",  "Dragonblight",  "Dragonmaw", "Drak'thul",\
         "Drek'Thar",  "Dun Modr",  "Dun Morogh",  "Dunemaul",  "Durotan",  "Earthen Ring",  "Echsenkessel", "Eitrigg",\
         "Eldre'Thalas",  "Elune",  "Emerald Dream",  "Emeriss",  "Eonar",  "Eredar",  "Eversong",  "Executus", "Exodar",\
         "Festung der Stürme",  "Fordragon",  "Forscherliga",  "Frostmane",  "Frostmourne",  "Frostwhisper", "Frostwolf",\
         "Galakrond",  "Garona",  "Garrosh",  "Genjuros",  "Ghostlands",  "Gilneas",  "Goldrinn",  "Gordunni", "Gorgonnash",\
         "Greymane",  "Grim Batol",  "Grom",  "Gul'dan",  "Hakkar",  "Haomarush",  "Hellfire",  "Hellscream", "Howling Fjord",\
         "Hyjal",  "Illidan",  "Jaedenar",  "Kael'thas",  "Kalaran",  "Karazhan",  "Kargath",  "Kazzak", "Kel'Thuzad",\
         "Khadgar",  "Khaz Modan",  "Khaz'goroth",  "Kil'jaeden",  "Kilrogg",  "Kirin Tor",  "Kor'gall", "Krag'jin",\
         "Krasus",  "Kul Tiras",  "Kult der Verdammten",  "La Croisade ecarlate",  "Laughing Skull",  "Les Clairvoyants",\
         "Les Sentinelles",  "Lich King",  "Lightbringer",  "Lightning's Blade",  "Lordaeron",  "Los Errantes", "Lothar",\
         "Lycanthoth",  "Madmortem",  "Magtheridon",  "Malfurion",  "Mal'Ganis",  "Malorne",  "Malygos",  "Mannoroth",\
         "Marecage de Zangar",  "Mazrigos",  "Medivh",  "Minahonda",  "Moonglade",  "Mug'thol",  "Nagrand",  "Naralex",\
         "Nathrezim",  "Naxxramas",  "Nazjatar",  "Nefarian",  "Nemesis",  "Neptulon",  "Nera'thor",  "Ner'zhul",  "Nethersturm",\
         "Nordrassil",  "Norgannon",  "Nozdormu",  "Onyxia",  "Outland",  "Perenolde",  "Pozzo dell'Eternità",  "Proudmoore",\
         "Quel'Thalas",  "Ragnaros",  "Rajaxx",  "Rashgarroth",  "Ravencrest",  "Ravenholdt",  "Razuvious",  "Rexxar",\
         "Runetotem",  "Sanguino",  "Sargeras",  "Saurfang",  "Scarshield Legion",  "Sen'jin",  "Shadowsong",  "Shattered Halls",\
         "Shattered Hand",  "Shattrath",  "Shen'dralar",  "Silvermoon",  "Sinstralis",  "Skullcrusher",  "Soulflayer",\
         "Spinebreaker",  "Sporeggar",  "Steamwheedle Cartel",  "Stormrage",  "Stormreaver",  "Stormscale",  "Sunstrider",\
         "Suramar",  "Sylvanas",  "Taerar",  "Talnivarr",  "Tarren Mill",  "Teldrassil",  "Temple noir",  "Terenas",  "Terokkar",\
         "Terrordar",  "The Maelstrom",  "The Sha'tar",  "The Venture Co",  "Theradras",  "Thermaplugg",  "Thrall",\
         "Throk'Feroth",  "Thunderhorn",  "Tichondrius",  "Tirion",  "Todeswache",  "Trollbane",  "Turalyon",  "Twilight's Hammer",\
         "Twisting Nether",  "Tyrande",  "Uldaman",  "Ulduar",  "Uldum",  "Un'Goro",  "Varimathras",  "Vashj", "Vek'lor",\
         "Vek'nilash",  "Vol'jin",  "Wildhammer",  "Wrathbringer",  "Xavius",  "Ysera",  "Ysondre",  "Zenedar", "Ревущий фьорд", "Гордунни", "Свежеватель Душ", "Ясеневый лес", "Черный Шрам", "Разувий", "Страж смерти", "Дракономор", "Азурегос", "Борейская тундра", "Вечная Песня", "Пиратская Бухта", "Голдринн", "Король-лич", "Галакронд", "Гром",\
         "Zirkel des Cenarius",  "Zul'jin",  "Zuluhed"]
us = ["Aegwynn", "Aerie Peak", "Agamaggan", "Aggramar", "Akama", "Alexstrasza", "Alleria", "Altar of Storms", "Alterac Mountains",\
         "Aman'Thul", "Anasterian", "Andorhal", "Anetheron", "Antonidas", "Anub'arak", "Anvilmar", "Arathor", "Archimonde", "Area 52",\
         "Argent Dawn", "Arthas", "Arygos", "Auchindoun", "Azgalor", "Azjol-Nerub", "Azralon", "Azshara", "Azuremyst", "Baelgun",\
         "Balnazzar", "Barthilas", "Benedictus",\
         "Black Dragonflight", "Blackhand", "Blackrock", "Blackwater Raiders", "Blackwing Lair", "Bladefist", "Blade's Edge",\
         "Bleeding Hollow",  "Blood Furnace", "Bloodhoof", "Bloodscalp", "Bonechewer", "Borean Tundra", "Boulderfist",\
         "Bronzebeard", "Broxigar",  "Burning Blade", "Burning Legion", "Caelestrasz", "Cairne", "Cenarion Circle", "Cenarius",\
         "Cho'gall", "Chromaggus", "Coilfang", "Crushridge", "Daggerspine", "Dalaran", "Dalvengyr", "Dark Iron", "Darkspear",\
         "Darrowmere", "Dath'Remar", "Dawnbringer", "Deathwing", "Demon Soul", "Dentarg", "Destromath", "Dethecus", "Detheroc",\
         "Doomhammer", "Draenor", "Dragonblight", "Dragonmaw", "Draka", "Drakkari", "Drak'Tharon", "Drak'thul", "Dreadmaul",\
         "Drenden", "Dunemaul", "Durotan", "Duskwood", "Earthen Ring", "Echo Isles", "Eitrigg", "Eldre'Thalas", "Elune",\
         "Emerald Dream", "Eonar", "Eredar", "Executus", "Exodar", "Farstriders", "Feathermoon", "Fenris", "Firetree",\
         "Fizzcrank", "Frostmane", "Frostmourne", "Frostwolf", "Galakrond", "Gallywix", "Garithos", "Garona", "Garrosh",\
         "Ghostlands", "Gilneas", "Gnomeregan", "Goldrinn", "Gorefiend", "Gorgonnash", "Greymane", "Grizzly Hills", "Gul'dan",\
         "Gundrak", "Gurubashi", "Hakkar", "Haomarush", "Hellscream", "Hydraxis", "Hyjal", "Icecrown", "Illidan", "Jaedenar",\
         "Jubei'Thos", "Kael'thas", "Kalaran", "Kalecgos", "Kargath", "Kel'Thuzad", "Khadgar", "Khaz Modan", "Khaz'goroth",\
         "Kil'jaeden", "Kilrogg", "Kirin Tor", "Korgath", "Korialstrasz", "Kul Tiras", "Laughing Skull", "Lethon", "Lightbringer",\
         "Lightninghoof", "Lightning's Blade", "Llane", "Lothar", "Lycanthoth", "Madoran", "Maelstrom", "Magtheridon", "Maiev",\
         "Malfurion", "Mal'Ganis", "Malorne", "Malygos", "Mannoroth", "Medivh", "Misha", "Mok'Nathal", "Moon Guard", "Moonrunner",\
         "Mug'thol", "Muradin", "Nagrand", "Nathrezim", "Nazgrel", "Nazjatar", "Nemesis", "Ner'zhul", "Nesingwary",\
         "Nordrassil", "Norgannon", "Onyxia", "Perenolde", "Proudmoore", "Quel'dorei", "Quel'Thalas", "Ragnaros", "Ravencrest",\
         "Ravenholdt", "Rexxar", "Rivendare", "Runetotem", "Sargeras", "Saurfang", "Scarlet Crusade", "Scilla", "Sen'jin", "Sentinels",\
         "Shadow Council", "Shadowmoon", "Shadowsong", "Shandris", "Shattered Halls", "Shattered Hand", "Shu'halo", "Silver Hand",\
         "Silvermoon", "Sisters of Elune", "Skullcrusher", "Skywall", "Smolderthorn", "Spinebreaker", "Spirestone", "Staghelm",\
         "Steamwheedle Cartel", "Stonemaul", "Stormrage", "Stormreaver", "Stormscale", "Suramar", "Tanaris", "Terenas", "Terokkar",\
         "Thaurissan", "The Forgotten Coast", "The Scryers", "The Underbog", "The Venture Co", "Thorium Brotherhood", "Thrall",\
         "Thunderhorn", "Thunderlord", "Tichondrius", "Tol Barad", "Tortheldrin", "Trollbane", "Turalyon", "Twisting Nether",\
         "Uldaman", "Uldum", "Undermine", "Ursin", "Uther", "Vashj", "Vek'nilash", "Velen", "Warsong", "Whisperwind",\
         "Wildhammer", "Windrunner", "Winterhoof", "Wyrmrest Accord", "Ysera", "Ysondre", "Zangarmarsh", "Zul'jin", "Zuluhed"]

kr = ["Azshara","Hyjal","Hellscream","Cenarius","Zul'jin","Deathwing","Durotan","Burning Legion","Windrunner","Norgannon","Malfurion","Dalaran","Stormrage","Garona","Gul'dan","Wildhammer","Rexxar","Alexstrasza",\
      "가로나","굴단","노르간논","달라란","데스윙","듀로탄","렉사르","말퓨리온","불타는 군단","세나리우스","스톰레이지","아즈샤라","알렉스트라자","와일드해머","윈드러너","줄진","하이잘","헬스크림"]

tw = ["Shadowmoon","Sundown Marsh","Arthas","Wrathbringer","Crystalpine Stinger","Zealot Blade","Chillwind Point","Skywall","Demon Fall Canyon","Stormscale","Silverwing Hold","Spirestone","World Tree","Light's Hope",\
      "Arygos","Dragonmaw","Frostmane","Bleeding Hollow","Nightsong","Hellscream","Whisperwind","Menethil","Quel'dorei","Icecrown","Order of the Cloud Serpent", "世界之樹", "亞雷戈斯","冰霜之刺", "冰風崗哨","地獄吼", "夜空之歌",\
      "天空之牆","寒冰皇冠","尖石","屠魔山谷","巨龍之喉","憤怒使者","日落沼澤","暗影之月","水晶之刺","狂熱之刃","眾星之子","米奈希爾","聖光之願","血之谷","語風","銀翼要塞","阿薩斯","雲蛟衛","雷鱗"]

realms(kr,tw)
