local mType = Game.createMonsterType("Anomaly")
local monster = {}

monster.name = "Anomaly"
monster.description = "an anomaly"
monster.experience = 50000
monster.outfit = {
	lookType = 876,
	lookHead = 38,
	lookBody = 79,
	lookLegs = 76,
	lookFeet = 79,
	lookAddons = 1,
	lookMount = 0
}

monster.health = 290000
monster.maxHealth = 290000
monster.runHealth = 0
monster.race = "blood"
monster.corpse = 26220
monster.speed = 400
monster.summonCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 10
}

monster.flags = {
	attackable = true,
	hostile = true,
	summonable = false,
	convinceable = false,
	illusionable = false,
	boss = true,
	ignoreSpawnBlock = false,
	pushable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	healthHidden = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false
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
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1300}
}

monster.defenses = {
	defense = 5,
	armor = 10
}

monster.loot = {
	{id = 26167, chance = 100000},
	{id = 26201, chance = 100000, maxCount = 5},
	{id = 26175, chance = 100000},
	{id = 2148, chance = 100000, maxCount = 200},
	{id = 25377, chance = 100000, maxCount = 7},
	{id = 26165, chance = 100000},
	{id = 2152, chance = 100000, maxCount = 35},
	{id = 18414, chance = 68586, maxCount = 3},
	{id = 18413, chance = 65445, maxCount = 3},
	{id = 18415, chance = 64921, maxCount = 3},
	{id = 7590, chance = 58115, maxCount = 10},
	{id = 8472, chance = 57592, maxCount = 10},
	{id = 8473, chance = 49215, maxCount = 10},
	{id = 2147, chance = 27225, maxCount = 10},
	{id = 2158, chance = 22513},
	{id = 9970, chance = 19372, maxCount = 10},
	{id = "void boots", chance = 19372},
	{id = "giant shimmering pearl", chance = 18848},
	{id = 2155, chance = 18848},
	{id = 2149, chance = 18848, maxCount = 10},
	{id = "ring of red plasma", chance = 17801},
	{id = 2150, chance = 17801, maxCount = 10},
	{id = "ring of green plasma", chance = 17277},
	{id = 2154, chance = 17277},
	{id = 2156, chance = 16754},
	{id = 2145, chance = 16754, maxCount = 10},
	{id = "ring of blue plasma", chance = 15707},
	{id = "collar of blue plasma", chance = 12042},
	{id = 7451, chance = 10995},
	{id = 7901, chance = 10471},
	{id = 26200, chance = 8377},
	{id = 7427, chance = 7853},
	{id = 7895, chance = 6806},
	{id = 7898, chance = 6283},
	{id = 8901, chance = 6283},
	{id = 2153, chance = 5759},
	{id = 26199, chance = 4712},
	{id = 18450, chance = 4188},
	{id = "tiara of power", chance = 4188},
	{id = 6553, chance = 3141}
}

mType:register(monster)
