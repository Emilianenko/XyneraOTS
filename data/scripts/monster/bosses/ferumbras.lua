local mType = Game.createMonsterType("Ferumbras")
local monster = {}

monster.name = "Ferumbras"
monster.description = ""
monster.experience = 35000
monster.outfit = {
	lookType = 0,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 90000
monster.maxHealth = 90000
monster.runHealth = 0
monster.race = "blood"
monster.corpse = 5931
monster.speed = 0
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
	boss = true,
	ignoreSpawnBlock = false,
	pushable = false,
	canPushItems = false,
	canPushCreatures = false,
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
	{text = "NO ONE WILL STOP ME THIS TIME!", yell = false},
	{text = "THE POWER IS MINE!", yell = false},
	{text = "I returned from death and you dream about defeating me?", yell = false},
	{text = "Witness the first seconds of my eternal world domination!", yell = false},
	{text = "Even in my weakened state I will crush you all!", yell = false}
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
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100}
}

monster.defenses = {
	defense = 5,
	armor = 10
}

monster.loot = {
	{id = 5903, chance = 100000, top = 1},
	{id = 2148, chance = 97959, maxCount = 184},
	{id = 9971, chance = 75510, maxCount = 2},
	{id = 2522, chance = 26531},
	{id = 8903, chance = 26531},
	{id = 2466, chance = 24490},
	{id = 2470, chance = 22449},
	{id = 8902, chance = 22449},
	{id = 8868, chance = 22449},
	{id = 2520, chance = 20408},
	{id = 8885, chance = 20408},
	{id = 7894, chance = 20408},
	{id = 2542, chance = 20408},
	{id = 2127, chance = 18367},
	{id = 7896, chance = 18367},
	{id = 7895, chance = 18367},
	{id = 2539, chance = 18367},
	{id = 8918, chance = 18367},
	{id = 7885, chance = 18367},
	{id = 8930, chance = 16327},
	{id = 7405, chance = 16327},
	{id = 7451, chance = 16327},
	{id = 2149, chance = 16327, maxCount = 100},
	{id = "giant shimmering pearl", chance = 14286, maxCount = 10},
	{id = 2472, chance = 14286},
	{id = 2514, chance = 14286},
	{id = 7417, chance = 14286},
	{id = 8904, chance = 14286},
	{id = 7427, chance = 12245},
	{id = 8926, chance = 12245},
	{id = 8869, chance = 12245},
	{id = 2146, chance = 12245, maxCount = 98},
	{id = 2143, chance = 12245, maxCount = 88},
	{id = 7407, chance = 10204},
	{id = 8924, chance = 10204},
	{id = 8928, chance = 10204},
	{id = 7411, chance = 10204},
	{id = 7410, chance = 10204},
	{id = 2150, chance = 10204, maxCount = 54},
	{id = 9970, chance = 10204, maxCount = 87},
	{id = 7382, chance = 8163},
	{id = 7422, chance = 8163},
	{id = 2152, chance = 8163, maxCount = 58},
	{id = 7423, chance = 8163},
	{id = 5944, chance = 8163, maxCount = 9},
	{id = 7388, chance = 8163},
	{id = 7414, chance = 6122},
	{id = 7403, chance = 6122},
	{id = 2144, chance = 6122, maxCount = 83},
	{id = 7416, chance = 6122},
	{id = 7418, chance = 6122},
	{id = 2415, chance = 4082},
	{id = 7435, chance = 4082},
	{id = 1986, chance = 4082},
	{id = 2145, chance = 4082, maxCount = 82},
	{id = 2147, chance = 4082, maxCount = 92}
}

mType:register(monster)
