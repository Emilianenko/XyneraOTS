local mType = Game.createMonsterType("True Dawnfire Asura")
local monster = {}

monster.name = "True Dawnfire Asura"
monster.description = "a true dawnfire asura"
monster.experience = 7475
monster.outfit = {
	lookType = 1068,
	lookHead = 114,
	lookBody = 94,
	lookLegs = 79,
	lookFeet = 121,
	lookAddons = 1,
	lookMount = 0
}

monster.health = 8500
monster.maxHealth = 8500
monster.runHealth = 0
monster.race = "blood"
monster.corpse = 31319
monster.speed = 360
monster.summonCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 0
}

monster.flags = {
	attackable = true,
	hostile = true,
	summonable = false,
	convinceable = false,
	illusionable = false,
	boss = false,
	ignoreSpawnBlock = true,
	pushable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	healthHidden = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "drunk", condition = true},
	{type = "bleed", condition = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = -10},
	{type = COMBAT_ENERGYDAMAGE, percent = -10},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -5},
	{type = COMBAT_HOLYDAMAGE , percent = -10},
	{type = COMBAT_DEATHDAMAGE , percent = 20}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -700},
	{name ="asura soulfire", interval = 2000, chance = 20}, -- fire box
	{name ="combat", interval = 2000, chance = 20, minDamage = -350, maxDamage = -720, range = 5, type = COMBAT_FIREDAMAGE, effect = CONST_ME_FIREATTACK, shootEffect = CONST_ANI_FIRE, target = true}, --flame strike
	{name ="combat", interval = 2000, chance = 16, minDamage = -550, maxDamage = -680, radius = 4, range = 7, type = COMBAT_DEATHDAMAGE, effect = CONST_ME_MORTAREA, shootEffect = CONST_ANI_DEATH, target = true}, --death ball
	{name ="asura skill reducer", interval = 2000, chance = 10, range = 7}, -- magic lvl reducer
	{name ="combat", interval = 2000, chance = 18, minDamage = -50, maxDamage = -300, length = 8, spread = 0, type = COMBAT_MANADRAIN, effect = CONST_ME_MAGIC_RED, direction = true}, --manadrain beam
	{name ="speed", interval = 2000, chance = 19, radius = 3, speed = -700, effect = CONST_ME_BLACKSMOKE, duration = 7000} --paralyze
}

monster.defenses = {
	defense = 77,
	armor = 77,
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 180, maxDamage = 280}
}

monster.loot = {
	{id = 2152, chance = 100000, maxCount = 12},
	{id = 6558, chance = 30588},
	{id = 24630, chance = 22538},
	{id = 6500, chance = 21977},
	{id = 24631, chance = 21902},
	{id = 5944, chance = 19843},
	{id = 2149, chance = 17784, maxCount = 5},
	{id = 7590, chance = 17147, maxCount = 2},
	{id = 2147, chance = 11868, maxCount = 3},
	{id = 7760, chance = 9472, maxCount = 3},
	{id = 9970, chance = 8836, maxCount = 2},
	{id = 2145, chance = 7825, maxCount = 2},
	{id = 2150, chance = 6739, maxCount = 2},
	{id = 2160, chance = 4380},
	{id = 2133, chance = 4231},
	{id = 28415, chance = 3931, maxCount = 3},
	{id = 2156, chance = 3557},
	{id = 2663, chance = 3295},
	{id = 5911, chance = 3145},
	{id = 2194, chance = 2958},
	{id = 24637, chance = 2920},
	{id = 2158, chance = 2733},
	{id = 8871, chance = 2209},
	{id = 7899, chance = 2059},
	{id = 2187, chance = 1310},
	{id = 8902, chance = 1123},
	{id = 6300, chance = 1011}
}

mType:register(monster)
