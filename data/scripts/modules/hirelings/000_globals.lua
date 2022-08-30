-- base outfit (not counted towards limit)
HIRELING_BASE_MALE = 1108
HIRELING_BASE_FEMALE = 1107

-- storage range for unlocked hirelings
-- key: base storage + hirelingId
-- value: amount of owned copies of the outfit
HIRELING_UNLOCK_BASE_STORAGE = 9000000

HirelingOutfits = {
	-- standard outfits
	[1] = {name = "Apprentice", male = 1108, female = 1107},
	[2] = {name = "Banker", male = 1110, female = 1109},
	[3] = {name = "Trader", male = 1112, female = 1111},
	[4] = {name = "Cook", male = 1114, female = 1113},
	[5] = {name = "Steward", male = 1116, female = 1115},
	[6] = {name = "Servant", male = 1118, female = 1117},
	
	-- unisex outfits
	-- note: 1124, 1126, 1130 and 1132 are identical to looktypes below
	[7] = {name = "Bonelord", type = 1123},
	[8] = {name = "Dragon", type = 1125},
	[9] = {name = "Hydra", type = 1129},
	[10] = {name = "Ferumbras", type = 1131},

	-- custom outfits
	[100] = {name = "Orc", type = 5},
	[101] = {name = "Necromancer", type = 9},
	[102] = {name = "Minotaur Mage", type = 23},
	[103] = {name = "Skeleton", type = 33},
	[104] = {name = "Witch", type = 54},
	[105] = {name = "Monk", type = 57},
	[106] = {name = "Goblin", type = 61},
	[107] = {name = "Elf Arcanist", type = 63},
	[108] = {name = "Mummy", type = 65},
	[109] = {name = "Dwarf Geomancer", type = 66},
	[110] = {name = "Gamemaster", type = 75},
	[111] = {name = "Pirate", type = 96},
	[112] = {name = "Lich", type = 99},
	[113] = {name = "Efreet", type = 103},
	[114] = {name = "Marid", type = 104},
	[115] = {name = "Lizard", type = 115},
	[116] = {name = "Merlkin", type = 117},
	[117] = {name = "Panda", type = 123},
	[118] = {name = "Tiger", type = 125},
	[119] = {name = "Retro Apprentice", male = 127, female = 126},
	[120] = {name = "Blood Crab", type = 200},
	[121] = {name = "Voodoomaster", type = 214},
	[122] = {name = "Terror Bird", type = 218},
	[123] = {name = "Tarantula", type = 219},
	[124] = {name = "Handmaiden", type = 230},
	[125] = {name = "Hellhound", type = 240},
	[126] = {name = "Dragon Hatchling", type = 271},
	[127] = {name = "Dragon Lord Hatchling", type = 272},
	[128] = {name = "Squirrel", type = 274},
	[129] = {name = "Cat", type = 276},
	[130] = {name = "Drone", type = 280},
	[131] = {name = "Frost Dragon Hatchling", type = 283},
	[132] = {name = "Cockroach", type = 284},
	[133] = {name = "Grim Reaper", type = 300},
	[134] = {name = "Snapping Turtle", type = 303},
	[135] = {name = "Worker Golem", type = 304},
	[136] = {name = "Medusa", type = 330},
	[137] = {name = "Ghastly Dragon", type = 351},
	[138] = {name = "Blob", type = 452},
	[139] = {name = "Hamster", type = 545},
	[140] = {name = "Forest Fury", type = 569},
	[141] = {name = "Retro Wolf", type = 918},
	[142] = {name = "Ancient Dragon Bones", type = 928},
	[143] = {name = "Faun", type = 980},
	[144] = {name = "Fairy", type = 982},
	[145] = {name = "Unicorn", type = 1019},
	[146] = {name = "Fox", type = 1029},
	[147] = {name = "Snail", type = 1046},
	[148] = {name = "Feather", type = 1058},
	[149] = {name = "Squid", type = 1059},
	[150] = {name = "Book", type = 1060},
	[151] = {name = "Elder Dragon Bones", type = 1079},
	[152] = {name = "White Owl", type = 1105},
	[153] = {name = "Spirit Flame", type = 1219},
	[154] = {name = "Cow", type = 1253},
	[155] = {name = "White Lion", type = 1290},
	[156] = {name = "Raccoon", type = 1378},
	[157] = {name = "Wild Cat", type = 1533},
}
