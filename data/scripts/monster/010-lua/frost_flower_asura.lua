local mType = Game.createMonsterType("Frost Flower Asura")
local monster = {}

monster.name = "Frost Flower Asura"
monster.description = "a frost flower asura"
monster.experience = 4200
monster.outfit = {
	lookType = 150,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 86,
	lookAddons = 3,
	lookMount = 0
}

monster.health = 3500
monster.maxHealth = 3500
monster.runHealth = 0
monster.race = "blood"
monster.corpse = 31462
monster.speed = 220
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
	ignoreSpawnBlock = false,
	pushable = false,
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 4,
	healthHidden = false,
	canWalkOnEnergy = true,
	canWalkOnFire = false,
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
	{type = COMBAT_PHYSICALDAMAGE, percent = -5},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = -10},
	{type = COMBAT_FIREDAMAGE, percent = -15},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 100},
	{type = COMBAT_HOLYDAMAGE , percent = 30},
	{type = COMBAT_DEATHDAMAGE , percent = 20}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -219},
	{name ="combat", interval = 2000, chance = 17, minDamage = -70, maxDamage = -145, length = 4, spread = 0, type = COMBAT_MANADRAIN, effect = CONST_ME_PURPLEENERGY, direction = true}, --purple beam
	{name ="combat", interval = 2000, chance = 35, minDamage = -150, maxDamage = -230, range = 5, type = COMBAT_ICEDAMAGE, effect = CONST_ME_ICEATTACK, shootEffect = CONST_ANI_ICE, target = true}, --ice strike
	{name ="frost asura freezing beam", interval = 2000, chance = 19}
}

monster.defenses = {
	defense = 56,
	armor = 56
}

monster.loot = {
	{id = 2148, chance = 100000, maxCount = 100},
	{id = 2152, chance = 100000, maxCount = 6},
	{id = 24630, chance = 20381},
	{id = 6558, chance = 19721},
	{id = 5944, chance = 18548},
	{id = 24631, chance = 17815},
	{id = 6500, chance = 16716},
	{id = 7591, chance = 12537, maxCount = 2},
	{id = 7368, chance = 10117, maxCount = 5},
	{id = 2145, chance = 8284, maxCount = 3},
	{id = 2146, chance = 7918, maxCount = 3},
	{id = 2143, chance = 7111, maxCount = 2},
	{id = 2144, chance = 5425, maxCount = 2},
	{id = 2134, chance = 4985},
	{id = 2147, chance = 4472, maxCount = 2},
	{id = 9970, chance = 4032, maxCount = 2},
	{id = 2149, chance = 3959, maxCount = 2},
	{id = 8911, chance = 3079},
	{id = 3967, chance = 3079},
	{id = 2154, chance = 2053},
	{id = 2183, chance = 1173},
	{id = 2170, chance = 880},
	{id = 2656, chance = 806},
	{id = 7404, chance = 733},
	{id = 9971, chance = 440},
	{id = 24637, chance = 367},
	{id = 2158, chance = 293},
	{id = 8889, chance = 293},
	{id = 8902, chance = 293},
	{id = 2124, chance = 73}
}

mType:register(monster)
