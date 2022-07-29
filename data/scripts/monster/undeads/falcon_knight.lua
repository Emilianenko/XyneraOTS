local mType = Game.createMonsterType("Falcon Knight")
local monster = {}

monster.name = "Falcon Knight"
monster.description = "a falcon knight"
monster.experience = 5985
monster.outfit = {
	lookType = 1071,
	lookHead = 57,
	lookBody = 96,
	lookLegs = 38,
	lookFeet = 105,
	lookAddons = 1,
	lookMount = 0
}

monster.health = 9000
monster.maxHealth = 9000
monster.runHealth = 0
monster.race = "undead"
monster.corpse = 31278
monster.speed = 220
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
	{text = "Mmmhaarrrgh!", yell = false}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "drunk", condition = true},
	{type = "bleed", condition = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 30},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = -10},
	{type = COMBAT_DEATHDAMAGE , percent = 50}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400},
	{name ="combat", interval = 2000, chance = 20, minDamage = -250, maxDamage = -380, length = 4, spread = 0, type = COMBAT_HOLYDAMAGE, effect = CONST_ME_HOLYDAMAGE, direction = true},
	{name ="combat", interval = 2000, chance = 15, minDamage = -350, maxDamage = -500, radius = 3, type = COMBAT_EARTHDAMAGE, effect = CONST_ME_GROUNDSHAKER}
}

monster.defenses = {
	defense = 86,
	armor = 86
}

monster.loot = {
	{id = 2671, chance = 83273},
	{id = 5944, chance = 41379},
	{id = 7591, chance = 39762, maxCount = 3},
	{id = 6558, chance = 36507, maxCount = 4},
	{id = 2150, chance = 30332, maxCount = 3},
	{id = 7368, chance = 29793, maxCount = 10},
	{id = 7590, chance = 23731, maxCount = 3},
	{id = 2147, chance = 19623, maxCount = 3},
	{id = 2145, chance = 18208, maxCount = 3},
	{id = 7365, chance = 17827, maxCount = 15},
	{id = 2149, chance = 17423, maxCount = 3},
	{id = 9970, chance = 5186, maxCount = 3},
	{id = 7413, chance = 3974},
	{id = 7632, chance = 3413},
	{id = 7452, chance = 2515},
	{id = 2476, chance = 2110},
	{id = 31479, chance = 1549},
	{id = 31478, chance = 1280},
	{id = 2466, chance = 1280},
	{id = 2454, chance = 1212},
	{id = 2153, chance = 1190},
	{id = 2514, chance = 988},
	{id = 2155, chance = 965},
	{id = 2578, chance = 427},
	{id = 2136, chance = 314},
	{id = 2452, chance = 269}
}

mType:register(monster)
