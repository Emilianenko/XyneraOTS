local mType = Game.createMonsterType("True Frost Flower Asura")
local monster = {}

monster.name = "True Frost Flower Asura"
monster.description = "a true frost flower asura"
monster.experience = 7069
monster.outfit = {
	lookType = 1068,
	lookHead = 9,
	lookBody = 0,
	lookLegs = 86,
	lookFeet = 9,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 4000
monster.maxHealth = 4000
monster.runHealth = 0
monster.race = "blood"
monster.corpse = 31323
monster.speed = 300
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
	targetDistance = 4,
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
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -500},
	{name ="combat", interval = 2000, chance = 18, minDamage = -70, maxDamage = -270, length = 3, spread = 0, type = COMBAT_MANADRAIN, effect = CONST_ME_PURPLEENERGY, direction = true}, --purple beam
	{name ="combat", interval = 2000, chance = 30, minDamage = -450, maxDamage = -760, range = 5, type = COMBAT_ICEDAMAGE, effect = CONST_ME_ICEATTACK, shootEffect = CONST_ANI_ICE, target = true}, --ice strike
	{name ="frost asura freezing beam", interval = 2000, chance = 16}
}

monster.defenses = {
	defense = 72,
	armor = 72,
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 150, maxDamage = 330}
}

monster.loot = {
	{id = 2152, chance = 100000, maxCount = 8},
	{id = 24630, chance = 23438},
	{id = 24631, chance = 21034},
	{id = 7591, chance = 20913, maxCount = 2},
	{id = 6558, chance = 20192},
	{id = 5944, chance = 18389},
	{id = 2149, chance = 16466, maxCount = 5},
	{id = 6500, chance = 15024},
	{id = 2145, chance = 12019, maxCount = 3},
	{id = 7759, chance = 11298, maxCount = 3},
	{id = 2146, chance = 11178, maxCount = 3},
	{id = 7368, chance = 10457, maxCount = 5},
	{id = 2144, chance = 9976, maxCount = 2},
	{id = 2134, chance = 9135},
	{id = 2143, chance = 8894, maxCount = 2},
	{id = 9970, chance = 8774, maxCount = 2},
	{id = 2147, chance = 8293, maxCount = 2},
	{id = 2160, chance = 6611},
	{id = 2154, chance = 4327},
	{id = 28415, chance = 4207, maxCount = 3},
	{id = 9971, chance = 3486},
	{id = 3967, chance = 3486},
	{id = 8911, chance = 3125},
	{id = 2170, chance = 2163},
	{id = 2158, chance = 1923},
	{id = 8902, chance = 1923},
	{id = 2656, chance = 1683},
	{id = 8889, chance = 1563},
	{id = 7404, chance = 1082},
	{id = 2183, chance = 1082},
	{id = 2124, chance = 962},
	{id = 24637, chance = 841}
}

mType:register(monster)
