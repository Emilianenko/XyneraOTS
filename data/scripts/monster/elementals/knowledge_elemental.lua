local mType = Game.createMonsterType("Knowledge Elemental")
local monster = {}

monster.name = "Knowledge Elemental"
monster.description = "a knowledge elemental"
monster.experience = 10603
monster.outfit = {
	lookType = 1065,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 10500
monster.maxHealth = 10500
monster.runHealth = 0
monster.race = "blood"
monster.corpse = 31262
monster.speed = 460
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
	boss = false,
	ignoreSpawnBlock = false,
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
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -600},
	{name ="combat", interval = 2000, chance = 22, minDamage = -850, maxDamage = -1000, range = 5, type = COMBAT_ENERGYDAMAGE, effect = CONST_ME_ENERGYAREA, shootEffect = CONST_ANI_ENERGY, target = true},
	{name ="combat", interval = 2000, chance = 20, minDamage = -600, maxDamage = -800, radius = 2, type = COMBAT_ENERGYDAMAGE, effect = CONST_ME_PURPLEENERGY},
	{name ="combat", interval = 2000, chance = 17, minDamage = -500, maxDamage = -600, length = 5, spread = 0, type = COMBAT_HOLYDAMAGE, effect = CONST_ME_YELLOWENERGY, direction = true},
	{name ="combat", interval = 2000, chance = 25, minDamage = -600, maxDamage = -800, range = 7, radius = 3, type = COMBAT_HOLYDAMAGE, effect = CONST_ME_HOLYDAMAGE, shootEffect = CONST_ANI_HOLY, target = true},
	{name ="combat", interval = 2000, chance = 13, minDamage = -700, maxDamage = -750, radius = 2, type = COMBAT_HOLYDAMAGE, effect = CONST_ME_YELLOWENERGY}
}

monster.defenses = {
	defense = 76,
	armor = 76
}

monster.loot = {
	{id = 2150, chance = 75087, maxCount = 6},
	{id = 2152, chance = 67971, maxCount = 15},
	{id = 31225, chance = 37898, maxCount = 5},
	{id = 31226, chance = 33276, maxCount = 10},
	{id = 31222, chance = 26506},
	{id = 31223, chance = 22542},
	{id = 26029, chance = 15322},
	{id = 7838, chance = 15062, maxCount = 15},
	{id = 8473, chance = 11323, maxCount = 2},
	{id = 2515, chance = 9539},
	{id = 7620, chance = 8864},
	{id = 2167, chance = 7116},
	{id = 2399, chance = 6891, maxCount = 15},
	{id = 2189, chance = 4640},
	{id = 7449, chance = 4553},
	{id = 2425, chance = 2805},
	{id = 2170, chance = 2337},
	{id = 2164, chance = 1887},
	{id = 7889, chance = 1801},
	{id = 2124, chance = 1229},
	{id = 18390, chance = 1229},
	{id = 11355, chance = 364}
}

mType:register(monster)
