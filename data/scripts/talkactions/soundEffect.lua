--[[
enum SoundEffect_t : uint16_t {
	SOUND_EFFECT_TYPE_SILENCE = 0,
	SOUND_EFFECT_TYPE_HUMAN_CLOSE_ATK_FIST = 1, // meele
	SOUND_EFFECT_TYPE_MONSTER_CLOSE_ATK_FIST = 2, // meele
	SOUND_EFFECT_TYPE_MELEE_ATK_SWORD = 3,
	SOUND_EFFECT_TYPE_MELEE_ATK_CLUB = 4,
	SOUND_EFFECT_TYPE_MELEE_ATK_AXE = 5,
	SOUND_EFFECT_TYPE_DIST_ATK_BOW = 6,
	SOUND_EFFECT_TYPE_DIST_ATK_CROSSBOW = 7,
	SOUND_EFFECT_TYPE_DIST_ATK_THROW = 8,
	SOUND_EFFECT_TYPE_MAGICAL_RANGE_ATK = 9,
	SOUND_EFFECT_TYPE_SPELL_OR_RUNE = 10,
	SOUND_EFFECT_TYPE_OTHER = 11,
	SOUND_EFFECT_TYPE_PHYSICAL_RANGE_MISS = 12,
	SOUND_EFFECT_TYPE_DIST_ATK_BOW_SHOT = 13,
	SOUND_EFFECT_TYPE_DIST_ATK_CROSSBOW_SHOT = 14,
	SOUND_EFFECT_TYPE_DIST_ATK_THROW_SHOT = 15,
	SOUND_EFFECT_TYPE_DIST_ATK_ROD_SHOT = 16,
	SOUND_EFFECT_TYPE_DIST_ATK_WAND_SHOT = 17,
	SOUND_EFFECT_TYPE_BURST_ARROW_EFFECT = 18,
	SOUND_EFFECT_TYPE_DIAMOND_ARROW_EFFECT = 19,
	SOUND_EFFECT_TYPE_NO_DAMAGE = 20,
	SOUND_EFFECT_TYPE_MONSTER_MELEE_ATK_FIST = 100,
	SOUND_EFFECT_TYPE_MONSTER_MELEE_ATK_CLAW = 101,
	SOUND_EFFECT_TYPE_MONSTER_MELEE_ATK_BITE = 102,
	SOUND_EFFECT_TYPE_MONSTER_MELEE_ATK_RIP = 103,
	SOUND_EFFECT_TYPE_MONSTER_MELEE_ATK_ACID = 104,
	SOUND_EFFECT_TYPE_MONSTER_MELEE_ATK_MAGIC = 105,
	SOUND_EFFECT_TYPE_MONSTER_MELEE_ATK_ETHEREAL = 106,
	SOUND_EFFECT_TYPE_MONSTER_MELEE_ATK_CONSTRUCT = 107,
	SOUND_EFFECT_TYPE_SPELL_LIGHT_HEALING = 1001,
	SOUND_EFFECT_TYPE_SPELL_INTENSE_HEALING = 1002,
	SOUND_EFFECT_TYPE_SPELL_ULTIMATE_HEALING = 1003,
	SOUND_EFFECT_TYPE_SPELL_INTENSE_HEALING_RUNE = 1004,
	SOUND_EFFECT_TYPE_SPELL_ULTIMATE_HEALING_RUNE = 1005,
	SOUND_EFFECT_TYPE_SPELL_HASTE = 1006,
	SOUND_EFFECT_TYPE_SPELL_LIGHT_MAGIC_MISSILE_RUNE = 1007,
	SOUND_EFFECT_TYPE_SPELL_HEAVY_MAGIC_MISSILE_RUNE = 1008,
	SOUND_EFFECT_TYPE_SPELL_SUMMON_CREATURE = 1009,
	SOUND_EFFECT_TYPE_SPELL_LIGHT = 1010,
	SOUND_EFFECT_TYPE_SPELL_GREAT_LIGHT = 1011,
	SOUND_EFFECT_TYPE_SPELL_CONVINCE_CREATURE_RUNE = 1012,
	SOUND_EFFECT_TYPE_SPELL_ENERGY_WAVE = 1013,
	SOUND_EFFECT_TYPE_SPELL_CHAMELEON_RUNE = 1014,
	SOUND_EFFECT_TYPE_SPELL_FIREBALL_RUNE = 1015,
	SOUND_EFFECT_TYPE_SPELL_GREAT_FIREBALL_RUNE = 1016,
	SOUND_EFFECT_TYPE_SPELL_FIRE_BOMB_RUNE = 1017,
	SOUND_EFFECT_TYPE_SPELL_EXPLOSION_RUNE = 1018,
	SOUND_EFFECT_TYPE_SPELL_FIRE_WAVE = 1019,
	SOUND_EFFECT_TYPE_SPELL_FIND_PERSON = 1020,
	SOUND_EFFECT_TYPE_SPELL_SUDDENDEATH_RUNE = 1021,
	SOUND_EFFECT_TYPE_SPELL_ENERGY_BEAM = 1022,
	SOUND_EFFECT_TYPE_SPELL_GREAT_ENERGY_BEAM = 1023,
	SOUND_EFFECT_TYPE_SPELL_HELLSCORE = 1024,
	SOUND_EFFECT_TYPE_SPELL_FIRE_FIELD_RUNE = 1025,
	SOUND_EFFECT_TYPE_SPELL_POISON_FIELD_RUNE = 1026,
	SOUND_EFFECT_TYPE_SPELL_ENERGY_FIELD_RUNE = 1027,
	SOUND_EFFECT_TYPE_SPELL_FIRE_ALL_RUNE = 1028,
	SOUND_EFFECT_TYPE_SPELL_CURE_POISON = 1029,
	SOUND_EFFECT_TYPE_SPELL_DESTROY_FIELD_RUNE = 1030,
	SOUND_EFFECT_TYPE_SPELL_CURE_POISON_RUNE = 1031,
	SOUND_EFFECT_TYPE_SPELL_POISON_WALL_RUNE = 1032,
	SOUND_EFFECT_TYPE_SPELL_ENERGY_WALL_RUNE = 1033,
	SOUND_EFFECT_TYPE_SPELL_SALVATION = 1036,
	SOUND_EFFECT_TYPE_SPELL_CREATURE_ILLUSION = 1038,
	SOUND_EFFECT_TYPE_SPELL_STRONG_HASTE = 1039,
	SOUND_EFFECT_TYPE_SPELL_FOOD = 1042,
	SOUND_EFFECT_TYPE_SPELL_STRONG_ICE_WAVE = 1043,
	SOUND_EFFECT_TYPE_SPELL_MAGIC_SHIELD = 1044,
	SOUND_EFFECT_TYPE_SPELL_INVISIBLE = 1045,
	SOUND_EFFECT_TYPE_SPELL_CONJURE_EXPLOSIVE_ARROW = 1049,
	SOUND_EFFECT_TYPE_SPELL_SOUL_FIRE_RUNE = 1050,
	SOUND_EFFECT_TYPE_SPELL_CONJUREARROW = 1051,
	SOUND_EFFECT_TYPE_SPELL_PARALYSE_RUNE = 1054,
	SOUND_EFFECT_TYPE_SPELL_ENERGY_BOMB_RUNE = 1055,
	SOUND_EFFECT_TYPE_SPELL_WRATH_OF_NATURE = 1056,
	SOUND_EFFECT_TYPE_SPELL_STRONG_ETHEREAL_SPEAR = 1057,
	SOUND_EFFECT_TYPE_SPELL_FRONT_SWEEP = 1059,
	SOUND_EFFECT_TYPE_SPELL_BRUTAL_STRIKE = 1061,
	SOUND_EFFECT_TYPE_SPELL_ANNIHILATION = 1062,
	SOUND_EFFECT_TYPE_SPELL_INVITE_GUESTS = 1071,
	SOUND_EFFECT_TYPE_SPELL_INVITE_SUBOWNERS = 1072,
	SOUND_EFFECT_TYPE_SPELL_KICK_GUEST = 1073,
	SOUND_EFFECT_TYPE_SPELL_EDIT_DOOR = 1074,
	SOUND_EFFECT_TYPE_SPELL_ULTIMATE_LIGHT = 1075,
	SOUND_EFFECT_TYPE_SPELL_MAGIC_ROPE = 1076,
	SOUND_EFFECT_TYPE_SPELL_STALAGMITE_RUNE = 1077,
	SOUND_EFFECT_TYPE_SPELL_DISINTEGRATE_RUNE = 1078,
	SOUND_EFFECT_TYPE_SPELL_BERSERK = 1080,
	SOUND_EFFECT_TYPE_SPELL_LEVITATE = 1081,
	SOUND_EFFECT_TYPE_SPELL_MASS_HEALING = 1082,
	SOUND_EFFECT_TYPE_SPELL_ANIMATE_DEAD_RUNE = 1083,
	SOUND_EFFECT_TYPE_SPELL_HEAL_FRIEND = 1084,
	SOUND_EFFECT_TYPE_SPELL_UNDEAD_LEGION = 1085,
	SOUND_EFFECT_TYPE_SPELL_MAGICWALL_RUNE = 1086,
	SOUND_EFFECT_TYPE_SPELL_DEATH_STRIKE = 1087,
	SOUND_EFFECT_TYPE_SPELL_ENERGY_STRIKE = 1088,
	SOUND_EFFECT_TYPE_SPELL_FLAME_STRIKE = 1089,
	SOUND_EFFECT_TYPE_SPELL_CANCEL_INVISIBILITY = 1090,
	SOUND_EFFECT_TYPE_SPELL_POISON_BOMB_RUNE = 1091,
	SOUND_EFFECT_TYPE_SPELL_CONJURE_WAND_OF_DARKNESS = 1092,
	SOUND_EFFECT_TYPE_SPELL_CHALLENGE = 1093,
	SOUND_EFFECT_TYPE_SPELL_WILDGROWTH_RUNE = 1094,
	SOUND_EFFECT_TYPE_SPELL_FIERCE_BERSERK = 1105,
	SOUND_EFFECT_TYPE_SPELL_GROUNDSHAKER = 1106,
	SOUND_EFFECT_TYPE_SPELL_WHIRLWIND_THROW = 1107,
	SOUND_EFFECT_TYPE_SPELL_ENCHANT_SPEAR = 1110,
	SOUND_EFFECT_TYPE_SPELL_ETHEREAL_SPEAR = 1111,
	SOUND_EFFECT_TYPE_SPELL_ICE_STRIKE = 1112,
	SOUND_EFFECT_TYPE_SPELL_TERRA_STRIKE = 1113,
	SOUND_EFFECT_TYPE_SPELL_ICICLE_RUNE = 1114,
	SOUND_EFFECT_TYPE_SPELL_AVALANCHE_RUNE = 1115,
	SOUND_EFFECT_TYPE_SPELL_STONE_SHOWER_RUNE = 1116,
	SOUND_EFFECT_TYPE_SPELL_THUNDERSTORM_RUNE = 1117,
	SOUND_EFFECT_TYPE_SPELL_ETERNAL_WINTER = 1118,
	SOUND_EFFECT_TYPE_SPELL_RAGE_OF_THE_SKIES = 1119,
	SOUND_EFFECT_TYPE_SPELL_TERRA_WAVE = 1120,
	SOUND_EFFECT_TYPE_SPELL_ICE_WAVE = 1121,
	SOUND_EFFECT_TYPE_SPELL_DIVINE_MISSILE = 1122,
	SOUND_EFFECT_TYPE_SPELL_WOUND_CLEANSING = 1123,
	SOUND_EFFECT_TYPE_SPELL_DIVINE_CALDERA = 1124,
	SOUND_EFFECT_TYPE_SPELL_DIVINE_HEALING = 1125,
	SOUND_EFFECT_TYPE_SPELL_TRAIN_PARTY = 1126,
	SOUND_EFFECT_TYPE_SPELL_PROTECT_PARTY = 1127,
	SOUND_EFFECT_TYPE_SPELL_HEAL_PARTY = 1128,
	SOUND_EFFECT_TYPE_SPELL_ENCHANT_PARTY = 1129,
	SOUND_EFFECT_TYPE_SPELL_HOLY_MISSILE_RUNE = 1130,
	SOUND_EFFECT_TYPE_SPELL_CHARGE = 1131,
	SOUND_EFFECT_TYPE_SPELL_PROTECTOR = 1132,
	SOUND_EFFECT_TYPE_SPELL_BLOOD_RAGE = 1133,
	SOUND_EFFECT_TYPE_SPELL_SWIFTFOOT = 1134,
	SOUND_EFFECT_TYPE_SPELL_SHARPSHOOTER = 1135,
	SOUND_EFFECT_TYPE_SPELL_IGNITE = 1138,
	SOUND_EFFECT_TYPE_SPELL_CURSE = 1139,
	SOUND_EFFECT_TYPE_SPELL_ELECTRIFY = 1140,
	SOUND_EFFECT_TYPE_SPELL_INFLICT_WOUND = 1141,
	SOUND_EFFECT_TYPE_SPELL_ENVENOM = 1142,
	SOUND_EFFECT_TYPE_SPELL_HOLY_FLASH = 1143,
	SOUND_EFFECT_TYPE_SPELL_CURE_BLEEDING = 1144,
	SOUND_EFFECT_TYPE_SPELL_CURE_BURNING = 1145,
	SOUND_EFFECT_TYPE_SPELL_CURE_ELECTRIFICATION = 1146,
	SOUND_EFFECT_TYPE_SPELL_CURE_CURSE = 1147,
	SOUND_EFFECT_TYPE_SPELL_PHYSICAL_STRIKE = 1148,
	SOUND_EFFECT_TYPE_SPELL_LIGHTNING = 1149,
	SOUND_EFFECT_TYPE_SPELL_STRONG_FLAME_STRIKE = 1150,
	SOUND_EFFECT_TYPE_SPELL_STRONG_ENERGY_STRIKE = 1151,
	SOUND_EFFECT_TYPE_SPELL_STRONG_ICE_STRIKE = 1152,
	SOUND_EFFECT_TYPE_SPELL_STRONG_TERRA_STRIKE = 1153,
	SOUND_EFFECT_TYPE_SPELL_ULTIMATE_FLAME_STRIKE = 1154,
	SOUND_EFFECT_TYPE_SPELL_ULTIMATE_ENERGY_STRIKE = 1155,
	SOUND_EFFECT_TYPE_SPELL_ULTIMATE_ICE_STRIKE = 1156,
	SOUND_EFFECT_TYPE_SPELL_ULTIMATE_TERRA_STRIKE = 1157,
	SOUND_EFFECT_TYPE_SPELL_INTENSE_WOUND_CLEANSING = 1158,
	SOUND_EFFECT_TYPE_SPELL_RECOVERY = 1159,
	SOUND_EFFECT_TYPE_SPELL_INTENSE_RECOVERY = 1160,
	SOUND_EFFECT_TYPE_SPELL_PRACTISE_HEALING = 1166,
	SOUND_EFFECT_TYPE_SPELL_PRACTISE_FIRE_WAVE = 1167,
	SOUND_EFFECT_TYPE_SPELL_PRACTISE_MAGIC_MISSILE_RUNE = 1168,
	SOUND_EFFECT_TYPE_SPELL_APPRENT_ICES_STRIKE = 1169,
	SOUND_EFFECT_TYPE_SPELL_MUD_ATTACK = 1172,
	SOUND_EFFECT_TYPE_SPELL_CHILL_OUT = 1173,
	SOUND_EFFECT_TYPE_SPELL_MAGIC_PATCH = 1174,
	SOUND_EFFECT_TYPE_SPELL_BRUISE_BANE = 1175,
	SOUND_EFFECT_TYPE_SPELL_ARROW_CALL = 1176,
	SOUND_EFFECT_TYPE_SPELL_BUZZ = 1177,
	SOUND_EFFECT_TYPE_SPELL_SCORCH = 1178,
	SOUND_EFFECT_TYPE_SPELL_LIGHTEST_MISSILE_RUNE = 1179,
	SOUND_EFFECT_TYPE_SPELL_LIGHTSTONE_SHOWER_RUNE = 1180,
	SOUND_EFFECT_TYPE_SPELL_SUMMON_KNIGHT_FAMILIAR = 1194,
	SOUND_EFFECT_TYPE_SPELL_SUMMON_PALADIN_FAMILIAR = 1195,
	SOUND_EFFECT_TYPE_SPELL_SUMMON_SORCERER_FAMILIAR = 1196,
	SOUND_EFFECT_TYPE_SPELL_SUMMON_DRUID_FAMILIAR = 1197,
	SOUND_EFFECT_TYPE_SPELL_CHIVALROUS_CHALLENGE = 1237,
	SOUND_EFFECT_TYPE_SPELL_DIVINE_DAZZLE = 1238,
	SOUND_EFFECT_TYPE_SPELL_FAIR_WOUND_CLEANSING = 1239,
	SOUND_EFFECT_TYPE_SPELL_GREAT_FIRE_WAVE = 1240,
	SOUND_EFFECT_TYPE_SPELL_RESTORATION = 1241,
	SOUND_EFFECT_TYPE_SPELL_NATURES_EMBRACE = 1242,
	SOUND_EFFECT_TYPE_SPELL_EXPOSE_WEAKNESS = 1243,
	SOUND_EFFECT_TYPE_SPELL_SAP_STRENGTH = 1244,
	SOUND_EFFECT_TYPE_SPELL_CANCEL_MAGIC_SHIELD = 1245,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_SINGLE_TARGET_FIRE = 2002,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_SINGLE_TARGET_ENERGY = 2003,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_SINGLE_TARGET_EARTH = 2004,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_SINGLE_TARGET_ICE = 2005,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_SINGLE_TARGET_DEATH = 2006,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_SINGLE_TARGET_HOLY = 2007,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_SINGLE_TARGET_HIT = 2008,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_SINGLE_TARGET_LIFEDRAIN = 2009,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_SINGLE_TARGET_MANADRAIN = 2010,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_SINGLE_TARGET_DROWNING = 2011,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_SINGLE_TARGET_BLEEDING = 2012,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_SINGLE_TARGET_HEALING = 2013,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_SMALL_AREA_FIRE = 2015,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_SMALL_AREA_ENERGY = 2016,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_SMALL_AREA_EARTH = 2017,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_SMALL_AREA_ICE = 2018,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_SMALL_AREA_DEATH = 2019,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_SMALL_AREA_HOLY = 2020,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_SMALL_AREA_HIT = 2021,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_SMALL_AREA_LIFEDRAIN = 2022,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_SMALL_AREA_MANADRAIN = 2023,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_SMALL_AREA_DROWNING = 2024,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_SMALL_AREA_BLEEDING = 2025,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_SMALL_AREA_HEALING = 2026,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_LARGE_AREAFIRE = 2028,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_LARGE_AREAENERGY = 2029,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_LARGE_AREAEARTH = 2030,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_LARGE_AREAICE = 2031,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_LARGE_AREADEATH = 2032,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_LARGE_AREAHOLY = 2033,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_LARGE_AREAHIT = 2034,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_LARGE_AREALIFEDRAIN = 2035,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_LARGE_AREAMANADRAIN = 2036,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_LARGE_AREADROWNING = 2037,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_LARGE_AREABLEEDING = 2038,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_LARGE_AREAHEALING = 2039,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_WAVE_FIRE = 2041,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_WAVE_ENERGY = 2042,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_WAVE_EARTH = 2043,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_WAVE_ICE = 2044,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_WAVE_DEATH = 2045,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_WAVE_HOLY = 2046,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_WAVE_HIT = 2047,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_WAVE_LIFEDRAIN = 2048,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_WAVE_MANADRAIN = 2049,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_WAVE_DROWNING = 2050,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_WAVE_BLEEDING = 2051,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_WAVE_HEALING = 2052,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_DELETEFIELD = 2054,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_CHALLENGE = 2055,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_SPEED = 2056,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_DRUNKEN = 2057,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_STRENGTH = 2058,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_OUTFIT = 2059,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_SUMMON = 2060,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_MAGICLEVEL = 2061,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_TELEPORT = 2062,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_HEX = 2063,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_SUPER_DRUNKEN = 2064,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_ROOT = 2065,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_FEAR = 2066,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_HIGHRISK_TELEPORT = 2067,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_MINION = 2068,
	SOUND_EFFECT_TYPE_MONSTER_SPELL_AGONY = 2069,
	SOUND_EFFECT_TYPE_AMPHIBIC_BARK = 2500,
	SOUND_EFFECT_TYPE_AQUATIC_BEAST_BARK = 2501,
	SOUND_EFFECT_TYPE_AQUATIC_CRITTER_BARK = 2502,
	SOUND_EFFECT_TYPE_AQUATIC_DEEPLING_BARK = 2503,
	SOUND_EFFECT_TYPE_AQUATIC_QUARA_BARK = 2504,
	SOUND_EFFECT_TYPE_BIRD_BARK = 2505,
	SOUND_EFFECT_TYPE_CONSTRUCT_BARK = 2506,
	SOUND_EFFECT_TYPE_DEMON_BARK = 2507,
	SOUND_EFFECT_TYPE_DRAGON_BARK = 2508,
	SOUND_EFFECT_TYPE_ELEMENTAL_EARTH_BARK = 2509,
	SOUND_EFFECT_TYPE_ELEMENTAL_ENERGY_BARK = 2510,
	SOUND_EFFECT_TYPE_ELEMENTAL_FIRE_BARK = 2511,
	SOUND_EFFECT_TYPE_ELEMENTAL_WATER_BARK = 2512,
	SOUND_EFFECT_TYPE_EXTRA_DIMENSIONAL_BEAST_BARK = 2513,
	SOUND_EFFECT_TYPE_EXTRA_DIMENSIONAL_ENERGY_BARK = 2514,
	SOUND_EFFECT_TYPE_EXTRA_DIMENSIONAL_HORROR_BARK = 2515,
	SOUND_EFFECT_TYPE_FEY_BARK = 2516,
	SOUND_EFFECT_TYPE_GIANT_BARK = 2517,
	SOUND_EFFECT_TYPE_HUMAN_FEMALE_BARK = 2518,
	SOUND_EFFECT_TYPE_HUMAN_MALE_BARK = 2519,
	SOUND_EFFECT_TYPE_HUMANOID_GOBLIN_BARK = 2520,
	SOUND_EFFECT_TYPE_HUMANOID_ORC_BARK = 2521,
	SOUND_EFFECT_TYPE_LYCANTHROPE_BARK = 2522,
	SOUND_EFFECT_TYPE_MAGICAL_ENERGY_BARK = 2523,
	SOUND_EFFECT_TYPE_MAGICAL_HORROR_BARK = 2524,
	SOUND_EFFECT_TYPE_MAMMAL_BEAR_BARK = 2525,
	SOUND_EFFECT_TYPE_MAMMAL_CRITTER_BARK = 2526, // coloquei pra testar o rat
	SOUND_EFFECT_TYPE_MAMMAL_DOG_BARK = 2527,
	SOUND_EFFECT_TYPE_MAMMAL_ELEPHANT_BARK = 2528,
	SOUND_EFFECT_TYPE_MAMMAL_FERAL_BARK = 2529,
	SOUND_EFFECT_TYPE_MAMMAL_HORSE_BARK = 2530,
	SOUND_EFFECT_TYPE_MAMMAL_MAMMOTH_BARK = 2531,
	SOUND_EFFECT_TYPE_MONSTER__BARK = 2532,
	SOUND_EFFECT_TYPE_PHANTOM_BARK = 2533,
	SOUND_EFFECT_TYPE_PLANT_BARK = 2534,
	SOUND_EFFECT_TYPE_REPTILE_LARGE_BARK = 2535,
	SOUND_EFFECT_TYPE_REPTILE_SMALL_BARK = 2536,
	SOUND_EFFECT_TYPE_SLIME_BARK = 2537,
	SOUND_EFFECT_TYPE_UNDEAD_BARK = 2538,
	SOUND_EFFECT_TYPE_VERMIN_CRITTER_BARK = 2539,
	SOUND_EFFECT_TYPE_VERMIN_INSECT_BARK = 2540,
	SOUND_EFFECT_TYPE_VERMIN_ROTWORM_BARK = 2541,
	SOUND_EFFECT_TYPE_HUMAN_SAGE_BARK = 2542,
	SOUND_EFFECT_TYPE_HUMAN_CRONE_BARK = 2543,
	SOUND_EFFECT_TYPE_APE_BARK = 2544,
	SOUND_EFFECT_TYPE_AMPHIBIC_DEATH = 2600,
	SOUND_EFFECT_TYPE_AQUATIC_BEAST_DEATH = 2601,
	SOUND_EFFECT_TYPE_AQUATIC_CRITTER_DEATH = 2602,
	SOUND_EFFECT_TYPE_AQUATIC_DEEPLING_DEATH = 2603,
	SOUND_EFFECT_TYPE_AQUATIC_QUARA_DEATH = 2604,
	SOUND_EFFECT_TYPE_BIRD_DEATH = 2605,
	SOUND_EFFECT_TYPE_CONSTRUCT_DEATH = 2606,
	SOUND_EFFECT_TYPE_DEMON_DEATH = 2607,
	SOUND_EFFECT_TYPE_DRAGON_DEATH = 2608,
	SOUND_EFFECT_TYPE_ELEMENTAL_EARTH_DEATH = 2609,
	SOUND_EFFECT_TYPE_ELEMENTAL_ENERGY_DEATH = 2610,
	SOUND_EFFECT_TYPE_ELEMENTAL_FIRE_DEATH = 2611,
	SOUND_EFFECT_TYPE_ELEMENTAL_WATER_DEATH = 2612,
	SOUND_EFFECT_TYPE_EXTRA_DIMENSIONAL_BEAST_DEATH = 2613,
	SOUND_EFFECT_TYPE_EXTRA_DIMENSIONAL_ENERGY_DEATH = 2614,
	SOUND_EFFECT_TYPE_EXTRA_DIMENSIONAL_HORROR_DEATH = 2615,
	SOUND_EFFECT_TYPE_FEY_DEATH = 2616,
	SOUND_EFFECT_TYPE_GIANT_DEATH = 2617,
	SOUND_EFFECT_TYPE_HUMAN_FEMALE_DEATH = 2618,
	SOUND_EFFECT_TYPE_HUMAN_MALE_DEATH = 2619,
	SOUND_EFFECT_TYPE_HUMANOID_GOBLIN_DEATH = 2620,
	SOUND_EFFECT_TYPE_HUMANOID_ORC_DEATH = 2621,
	SOUND_EFFECT_TYPE_LYCANTHROPE_DEATH = 2622,
	SOUND_EFFECT_TYPE_MAGICAL_ENERGY_DEATH = 2623,
	SOUND_EFFECT_TYPE_MAGICAL_HORROR_DEATH = 2624,
	SOUND_EFFECT_TYPE_MAMMAL_BEAR_DEATH = 2625,
	SOUND_EFFECT_TYPE_MAMMAL_CRITTER_DEATH = 2626,
	SOUND_EFFECT_TYPE_MAMMAL_DOG_DEATH = 2627,
	SOUND_EFFECT_TYPE_MAMMAL_ELEPHANT_DEATH = 2628,
	SOUND_EFFECT_TYPE_MAMMAL_FERAL_DEATH = 2629,
	SOUND_EFFECT_TYPE_MAMMAL_HORSE_DEATH = 2630,
	SOUND_EFFECT_TYPE_MAMMAL_MAMMOTH_DEATH = 2631,
	SOUND_EFFECT_TYPE_MONSTER_DEATH = 2632,
	SOUND_EFFECT_TYPE_PHANTOM_DEATH = 2633,
	SOUND_EFFECT_TYPE_PLANT_DEATH = 2634,
	SOUND_EFFECT_TYPE_REPTILE_LARGE_DEATH = 2635,
	SOUND_EFFECT_TYPE_REPTILE_SMALL_DEATH = 2636,
	SOUND_EFFECT_TYPE_SLIME_DEATH = 2637,
	SOUND_EFFECT_TYPE_UNDEAD_DEATH = 2638,
	SOUND_EFFECT_TYPE_VERMIN_CRITTER_DEATH = 2639,
	SOUND_EFFECT_TYPE_VERMIN_INSECT_DEATH = 2640,
	SOUND_EFFECT_TYPE_VERMIN_ROTWORM_DEATH = 2641,
	SOUND_EFFECT_TYPE_HUMAN_SAGE_DEATH = 2642,
	SOUND_EFFECT_TYPE_HUMAN_CRONE_DEATH = 2643,
	SOUND_EFFECT_TYPE_APE_DEATH = 2644,
	SOUND_EFFECT_TYPE_UNKNOWN_CREATURE_DEATH_1 = 2645,
	SOUND_EFFECT_TYPE_UNKNOWN_CREATURE_DEATH_2 = 2646,
	SOUND_EFFECT_TYPE_UNKNOWN_CREATURE_DEATH_3 = 2647,
	SOUND_EFFECT_TYPE_UNKNOWN_CREATURE_DEATH_4 = 2648,
	SOUND_EFFECT_TYPE_ACTION_HEAVY_METAL_LOUD = 2649,
	SOUND_EFFECT_TYPE_ENV_INSECTS_BIRDS = 2651,
	SOUND_EFFECT_TYPE_ENV_WIND_1 = 2652,
	SOUND_EFFECT_TYPE_ENV_WIND_CLOSE = 2653,
	SOUND_EFFECT_TYPE_ENV_WATER_DEPTH_BOAT_SURFACE = 2654,
	SOUND_EFFECT_TYPE_ENV_METALIC_SPACE = 2655,
	SOUND_EFFECT_TYPE_ENV_FROGS_INSECTS_WOODS = 2656,
	SOUND_EFFECT_TYPE_ENV_WATER_DEPTH = 2657,
	SOUND_EFFECT_TYPE_ENV_SEA_WAVE = 2658,
	SOUND_EFFECT_TYPE_ENV_WIND_2 = 2659,
	SOUND_EFFECT_TYPE_ENV_WIND_3 = 2660,
	SOUND_EFFECT_TYPE_ENV_MONKEYS = 2661,
	SOUND_EFFECT_TYPE_ENV_STORM_COMING = 2662,
	SOUND_EFFECT_TYPE_ACTION_HITTING_WOOD = 2663,
	SOUND_EFFECT_TYPE_ENV_WOOD_STICK_SMASH = 2664,
	SOUND_EFFECT_TYPE_ENV_THICK_BLOB_LIQUID_1 = 2665,
	SOUND_EFFECT_TYPE_ENV_LITTLE_BIRTS_FLOREST = 2666,
	SOUND_EFFECT_TYPE_ENV_THICK_BLOCK_LIQUID_CLOSE = 2667,
	SOUND_EFFECT_TYPE_ACTION_METAL_CHAINS_MOVING = 2668,
	SOUND_EFFECT_TYPE_ENV_CRICKET_1 = 2669,
	SOUND_EFFECT_TYPE_ENV_CRICKET_2 = 2670,
	SOUND_EFFECT_TYPE_ENV_CRICKET_3 = 2671,
	SOUND_EFFECT_TYPE_ENV_CICADA_1 = 2672,
	SOUND_EFFECT_TYPE_ENV_STONES_FALLING = 2673,
	SOUND_EFFECT_TYPE_ACTION_OPEN_DOOR = 2674,
	SOUND_EFFECT_TYPE_ACTION_CLOSE_DOOR = 2675,
	SOUND_EFFECT_TYPE_ENV_OWL = 2676,
	SOUND_EFFECT_TYPE_ENV_ELETRONIC_DEVICE = 2678,
	SOUND_EFFECT_TYPE_ENV_REPTILE_NOISE = 2679,
	SOUND_EFFECT_TYPE_ENV_FORGE_METAL_1 = 2680,
	SOUND_EFFECT_TYPE_ENV_FROG = 2681,
	SOUND_EFFECT_TYPE_ACTION_WOOD_OBJECT_USING = 2682,
	SOUND_EFFECT_TYPE_ACTION_METAL_OBJECT_HIT = 2683,
	SOUND_EFFECT_TYPE_ACTION_NAIL_HIT = 2684,
	SOUND_EFFECT_TYPE_ENV_BELL_RING = 2685,
	SOUND_EFFECT_TYPE_ENV_HOT_METAL_ON_WATER = 2686,
	SOUND_EFFECT_TYPE_ENV_WATER_SMOKE = 2687,
	SOUND_EFFECT_TYPE_ENV_WOLF_HOWL = 2688,
	SOUND_EFFECT_TYPE_ENV_WOOD_CRACKLE_CLOSE = 2689,
	SOUND_EFFECT_TYPE_ENV_LAUGHT = 2690,
	SOUND_EFFECT_TYPE_ENV_WIND_MOVING_LEAF = 2691,
	SOUND_EFFECT_TYPE_ENV_WIND_MOVING_FEW_LEAF = 2692,
	SOUND_EFFECT_TYPE_ACTION_PORTAL_CAST = 2693,
	SOUND_EFFECT_TYPE_ACTION_FIRE_MAGIC_CAST = 2694,
	SOUND_EFFECT_TYPE_ENV_TRAPDOOR_OPEN = 2695,
	SOUND_EFFECT_TYPE_ENV_NAIL_FALLING = 2696,
	SOUND_EFFECT_TYPE_ENV_LIGHT_BLOB_LIQUID = 2697,
	SOUND_EFFECT_TYPE_ENV_LION_ROAR = 2698,
	SOUND_EFFECT_TYPE_ENV_MOVING_OBJECT_BUTTON_TRIGGER = 2699,
	SOUND_EFFECT_TYPE_ENV_SNAKE_1 = 2700,
	SOUND_EFFECT_TYPE_ENV_HUMAN_SCREEN_1 = 2701,
	SOUND_EFFECT_TYPE_ENV_HUMAN_SCREEN_2 = 2702,
	SOUND_EFFECT_TYPE_ENV_SEAGUL_1 = 2703,
	SOUND_EFFECT_TYPE_ENV_FAST_FOOTSTEPS = 2704,
	SOUND_EFFECT_TYPE_ENV_SLOW_FOOTSTEPS = 2705,
	SOUND_EFFECT_TYPE_ENV_THICK_BLOB_LIQUID_2 = 2706,
	SOUND_EFFECT_TYPE_ENV_MOVING_LEAF = 2707,
	SOUND_EFFECT_TYPE_ENV_WOOD_CRACKLE_1= 2708,
	SOUND_EFFECT_TYPE_ACTION_OBJECT_FALLING_DEPTH = 2709,
	SOUND_EFFECT_TYPE_ACTION_BUTTON_TRIGGER = 2710,
	SOUND_EFFECT_TYPE_ENV_HEAVEN_DARK_REVERB = 2711,
	SOUND_EFFECT_TYPE_ENV_WIND_4 = 2712,
	SOUND_EFFECT_TYPE_ENV_INSECT_1 = 2713,
	SOUND_EFFECT_TYPE_ENV_FLUTE_SONG = 2714,
	SOUND_EFFECT_TYPE_ENV_INSECTS_BIRDS_DEATH = 2715,
	SOUND_EFFECT_TYPE_ENV_INSECT_CREATURE_DEATH = 2716,
	SOUND_EFFECT_TYPE_ENV_LOW_ROAR = 2717,
	SOUND_EFFECT_TYPE_ENV_SINISTER_BURPH = 2718,
	SOUND_EFFECT_TYPE_ENV_CROWD_SCREEN = 2719,
	SOUND_EFFECT_TYPE_ENV_BIRDS_FLYING = 2720,
	SOUND_EFFECT_TYPE_ENV_CROWD_VOICES_1 = 2721,
	SOUND_EFFECT_TYPE_ENV_BIRD_CUCO = 2722,
	SOUND_EFFECT_TYPE_ENV_RAVINE = 2723,
	SOUND_EFFECT_TYPE_ENV_RAVINE_METALIC = 2724,
	SOUND_EFFECT_TYPE_ENV_STICKS_LEAF_STEP = 2725,
	SOUND_EFFECT_TYPE_ACTION_DISPEL_MAGIC_1 = 2726,
	SOUND_EFFECT_TYPE_ACTION_DISPEL_MAGIC_2 = 2727,
	SOUND_EFFECT_TYPE_ENV_CROWD_VOICES_2 = 2728,
	SOUND_EFFECT_TYPE_ENV_CROWD_VOICES_3 = 2729,
	SOUND_EFFECT_TYPE_ENV_CROWD_VOICES_4 = 2730,
	SOUND_EFFECT_TYPE_ACTION_METAL_OBJECT_FALL = 2731,
	SOUND_EFFECT_TYPE_ENV_HOURSE_STEPS = 2732,
	SOUND_EFFECT_TYPE_ENV_DRUMES_SINISTER_REVERB = 2733,
	SOUND_EFFECT_TYPE_ACTION_WOOD_PIECES_FALL = 2734,
	SOUND_EFFECT_TYPE_ACTION_KNIFE_CUT_FLESH = 2735,
	SOUND_EFFECT_TYPE_ENV_CROWD_VOICES_5 = 2736,
	SOUND_EFFECT_TYPE_ENV_CICADA_2 = 2738,
	SOUND_EFFECT_TYPE_ENV_FLYES = 2739,
	SOUND_EFFECT_TYPE_ENV_NOISE_WATER = 2740,
	SOUND_EFFECT_TYPE_ENV_PIG_SOUND_1 = 2741,
	SOUND_EFFECT_TYPE_ENV_PIG_SOUND_2 = 2742,
	SOUND_EFFECT_TYPE_ENV_SHEEP_SOUND_1 = 2743,
	SOUND_EFFECT_TYPE_ENV_SHEEP_SOUND_2 = 2744,
	SOUND_EFFECT_TYPE_ENV_FIRE = 2745,
	SOUND_EFFECT_TYPE_ENV_NOISE_SNOW = 2746,
	SOUND_EFFECT_TYPE_ENV_FIRE_PLACE = 2747,
	SOUND_EFFECT_TYPE_ENV_WATERFALL = 2748,
	SOUND_EFFECT_TYPE_ENV_WATER_SOURCE = 2749,
	SOUND_EFFECT_TYPE_ACTION_HAMMER_HITING_NAILS_1 = 2750,
	SOUND_EFFECT_TYPE_ACTION_HAMMER_HITING_NAILS_2 = 2751,
	SOUND_EFFECT_TYPE_ENV_QUICK_STEPS = 2752,
	SOUND_EFFECT_TYPE_ENV_HEAVY_OBJECT_FALL = 2753,
	SOUND_EFFECT_TYPE_ACTION_HITING_FORGE = 2754,
	SOUND_EFFECT_TYPE_ENV_WOOD_CRACKLE_2 = 2755,
	SOUND_EFFECT_TYPE_ACTION_WOOD_HIT = 2756,
	SOUND_EFFECT_TYPE_MUSIC_CUT_BIRDS = 2757,
	SOUND_EFFECT_TYPE_MUSIC_CUT_LITTLE_BIRDS = 2758,
	SOUND_EFFECT_TYPE_MUSIC_CUT_INSECTS_1 = 2759,
	SOUND_EFFECT_TYPE_MUSIC_CUT_INSECTS_2 = 2760,
	SOUND_EFFECT_TYPE_MUSIC_CUT_INSECTS_3 = 2761,
	SOUND_EFFECT_TYPE_MUSIC_CUT_FLUTE_WEST = 2762,
	SOUND_EFFECT_TYPE_MUSIC_CUT_CROWS_VOICES = 2763,
	SOUND_EFFECT_TYPE_MUSIC_CUT_WIND_WATER = 2764,
	SOUND_EFFECT_TYPE_MUSIC_CUT_THICK_BLOCK_DEPTH = 2765,
	SOUND_EFFECT_TYPE_ENV_CAMEL = 2766,
	SOUND_EFFECT_TYPE_UNKNOWN_CREATURE_DEATH_5 = 2767,
	SOUND_EFFECT_TYPE_ENV_CHICKEN_1 = 2768,
	SOUND_EFFECT_TYPE_ENV_CHICKEN_2 = 2769,
	SOUND_EFFECT_TYPE_ENV_THRILLER_METALLIC = 2770,
	SOUND_EFFECT_TYPE_ACTION_NOTIFICATION = 2771,
	SOUND_EFFECT_TYPE_ACTION_LEVEL_ACHIEVEMENT = 2772,
	SOUND_EFFECT_TYPE_ACTION_SCREENSHOT = 2773,
	SOUND_EFFECT_TYPE_ACTION_CLICK_ON = 2774,
	SOUND_EFFECT_TYPE_ACTION_CLICK_OFF = 2775,
	SOUND_EFFECT_TYPE_ACTION_DRUMS = 2776,
	SOUND_EFFECT_TYPE_ACTION_XYLOPHONE_SLOW_DRUM = 2777,
	SOUND_EFFECT_TYPE_ACTION_HARP_1 = 2778,
	SOUND_EFFECT_TYPE_ACTION_HARP_2 = 2779,
	SOUND_EFFECT_TYPE_ACTION_MOVING_WOOD = 2780,
	SOUND_EFFECT_TYPE_ACTION_CRATE_BREAK_MAGIC_DUST = 2781,
	SOUND_EFFECT_TYPE_ACTION_BELL_RING = 2783,
	SOUND_EFFECT_TYPE_ACTION_SELECT_OBJECT = 2785,
	SOUND_EFFECT_TYPE_ITEM_MOVE_BACKPACK = 2786,
    SOUND_EFFECT_TYPE_ITEM_USE_POTION = 2787,
    SOUND_EFFECT_TYPE_ITEM_MOVE_NECKLACES = 2788,
    SOUND_EFFECT_TYPE_ITEM_MOVE_ARMORS = 2789,
	SOUND_EFFECT_TYPE_ITEM_MOVE_METALIC = 2790,
    SOUND_EFFECT_TYPE_ITEM_MOVE_DISTANCE = 2791,
	SOUND_EFFECT_TYPE_ITEM_MOVE_WOOD = 2792,
	SOUND_EFFECT_TYPE_ITEM_MOVE_STACKABLE = 2793,
	SOUND_EFFECT_TYPE_ITEM_MOVE_DEFAULT = 2794,
    SOUND_EFFECT_TYPE_ITEM_MOVE_LEGS = 2795,
    SOUND_EFFECT_TYPE_ITEM_MOVE_HELMETS = 2796,
    SOUND_EFFECT_TYPE_ITEM_MOVE_QUIVERS = 2797,
    SOUND_EFFECT_TYPE_ITEM_MOVE_RINGS = 2798,
    SOUND_EFFECT_TYPE_ENV_FROG_OR_LIQUID = 2799,
    SOUND_EFFECT_TYPE_ACTION_WOOD_OBJECT_HIT_STORE = 2800,
    SOUND_EFFECT_TYPE_ITEM_MOVE_BOOTS = 2801,
    SOUND_EFFECT_TYPE_ACTION_SWORD_DRAWN = 2802,
    SOUND_EFFECT_TYPE_ACTION_EAT = 2803,
    SOUND_EFFECT_TYPE_ACTION_STORE_BIG_OBJECT = 2804,
    SOUND_EFFECT_TYPE_ACTION_STORE_WOOD_OBJECT = 2805,
    SOUND_EFFECT_TYPE_ACTION_VIP_LOGOUT = 2806,
    SOUND_EFFECT_TYPE_ACTION_VIP_LOGIN = 2807,
    SOUND_EFFECT_TYPE_ENV_CAT_1 = 2808,
    SOUND_EFFECT_TYPE_ENV_INSECT_2 = 2809,
    SOUND_EFFECT_TYPE_ENV_SEAGUL_2 = 2810,
    SOUND_EFFECT_TYPE_ENV_LIQUID_SPILL = 2811,
    SOUND_EFFECT_TYPE_ENV_COW_MOO_1 = 2813,
    SOUND_EFFECT_TYPE_ENV_COW_MOO_2 = 2814,
    SOUND_EFFECT_TYPE_ENV_CAT_2 = 2815,
    SOUND_EFFECT_TYPE_ACTION_REAWRD_FEY = 2816,
    SOUND_EFFECT_TYPE_ACTION_REWARD_GUITAR_1 = 2817,
    SOUND_EFFECT_TYPE_ACTION_REWARD_GUITAR_2 = 2818,
    SOUND_EFFECT_TYPE_ENV_WOODS_WATER_SOURCE = 2819,
    SOUND_EFFECT_TYPE_ENV_HYENA = 2820,
    SOUND_EFFECT_TYPE_UNKNOWN_CREATURE_DEATH_6 = 2821,
    SOUND_EFFECT_TYPE_ENV_COW_MOO_3 = 2822,
    SOUND_EFFECT_TYPE_UNKNOWN_CREATURE_DEATH_7 = 2823,
    SOUND_EFFECT_TYPE_ENV_METALIC_SPACE_ALIEN = 2824,
    SOUND_EFFECT_TYPE_ACTION_AIR_STRIKE = 2825,
    SOUND_EFFECT_TYPE_ENV_WATER = 2828,
    SOUND_EFFECT_TYPE_ENV_SNAKE_2 = 2829,
	SOUND_EFFECT_TYPE_GOD_SPELL_KILL_ALL_MONSTERS = 10001, // No sound ingame
};
]]

local monkeySounds = {2661, 2820}

local t = TalkAction("/y", "!y", "/monke", "!monke")
t.onSay = function(player, words, param)
	if not player:isAdmin() then
		return true
	end
	
	local effect = tonumber(param)
	if not effect and (param and param:match("monke") or words:match("monke")) then
		effect = monkeySounds[math.random(#monkeySounds)]
	end

	local msg = NetworkMessage()
	--[[
	-- sound to client, any pos, max volume
	msg:addByte(0x85)
	msg:addByte(2)
	msg:addU16(effect)
	]]
	
	local ppos = player:getPosition()
	-- sound to client, player pos
	msg:addByte(0x83) -- sendMagicEffect header
	msg:addPosition(ppos)
	msg:addByte(6) -- type sound
	msg:addByte(1) -- origin (global / own / other player / monster)
	msg:addU16(effect) -- effect
	msg:addByte(0) -- end loop
	
	local spec = Game.getSpectators(ppos, true, true)
	if spec then
		for _, target in pairs(spec) do
			msg:sendToPlayer(target)
		end
	end
	
	return false
end
t:separator(" ")
t:register()
