local mType = Game.createMonsterType("Crazed Winter Vanguard")
local monster = {}

monster.name = "Crazed Winter Vanguard"
monster.description = "a crazed winter vanguard"
monster.experience = 5400
monster.outfit = {
	lookType = 1137,
	lookHead = 8,
	lookBody = 67,
	lookLegs = 8,
	lookFeet = 1,
	lookAddons = 1,
	lookMount = 0
}

monster.health = 5800
monster.maxHealth = 5800
monster.runHealth = 0
monster.race = "blood"
monster.corpse = 32778
monster.speed = 380
monster.summonCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 5
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

monster.reflects = {
	{type = COMBAT_ICEDAMAGE, percent = 31},
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = -20},
	{type = COMBAT_EARTHDAMAGE, percent = -15},
	{type = COMBAT_FIREDAMAGE, percent = -30},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 50},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 15}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -450},
	{name ="Crazed Winter Vanguard Chain", interval = 2000, chance = 20},
	{name ="combat", interval = 2000, chance = 18, minDamage = -150, maxDamage = -250, length = 3, type = COMBAT_ICEDAMAGE, effect = CONST_ME_GIANTICE, direction = true},
	{name ="combat", interval = 2000, chance = 24, minDamage = -200, maxDamage = -300, radius = 3, type = COMBAT_ICEDAMAGE, effect = CONST_ME_ICETORNADO},
	{name ="combat", interval = 2000, chance = 19, minDamage = -200, maxDamage = -300, radius = 4, type = COMBAT_ICEDAMAGE, effect = CONST_ME_ICEAREA},
}

monster.defenses = {
	defense = 77,
	armor = 77
}

monster.loot = {
	{id = 2152, chance = 86304, maxCount = 13},
	{id = 32714, chance = 13258},
	{id = 7760, chance = 13224},
	{id = 12430, chance = 10070},
	{id = 8473, chance = 9333},
	{id = 32661, chance = 8399},
	{id = 27617, chance = 6736},
	{id = 2396, chance = 6419},
	{id = 8911, chance = 5948},
	{id = 7888, chance = 5031},
	{id = 7897, chance = 2494},
	{id = 2198, chance = 711},
	{id = 2158, chance = 171}
}

mType:register(monster)
