local mType = Game.createMonsterType("Falcon Paladin")
local monster = {}

monster.name = "Falcon Paladin"
monster.description = "a falcon paladin"
monster.experience = 6544
monster.outfit = {
	lookType = 1071,
	lookHead = 57,
	lookBody = 96,
	lookLegs = 38,
	lookFeet = 105,
	lookAddons = 2,
	lookMount = 0
}

monster.health = 8500
monster.maxHealth = 8500
monster.runHealth = 0
monster.race = "undead"
monster.corpse = 31382
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
	{text = "Uuunngh!", yell = false}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "drunk", condition = true},
	{type = "bleed", condition = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 10},
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
	{name ="combat", interval = 2000, chance = 23, minDamage = 0, maxDamage = -500, range = 6, type = COMBAT_PHYSICALDAMAGE, shootEffect = CONST_ANI_ROYALSPEAR, target = true},
	{name ="combat", interval = 2000, chance = 14, minDamage = -400, maxDamage = -500, range = 6, radius = 3, type = COMBAT_ENERGYDAMAGE, effect = CONST_ME_ENERGYAREA, shootEffect = CONST_ANI_POWERBOLT, target = true},
	{name ="combat", interval = 2000, chance = 18, minDamage = -250, maxDamage = -350, length = 4, spread = 0, type = COMBAT_ENERGYDAMAGE, effect = CONST_ME_ENERGYHIT, direction = true}
}

monster.defenses = {
	defense = 82,
	armor = 82
}

monster.loot = {
	{id = 2152, chance = 89491, maxCount = 6},
	{id = 8472, chance = 47853, maxCount = 2},
	{id = 2145, chance = 47304, maxCount = 2},
	{id = 2150, chance = 46786, maxCount = 2},
	{id = 2149, chance = 45751, maxCount = 2},
	{id = 7368, chance = 29333, maxCount = 10},
	{id = 2147, chance = 23576, maxCount = 2},
	{id = 9970, chance = 22906, maxCount = 2},
	{id = 7365, chance = 18581, maxCount = 15},
	{id = 2156, chance = 9412},
	{id = 2155, chance = 5879},
	{id = 2153, chance = 5239},
	{id = 7632, chance = 1858},
	{id = 31478, chance = 1371},
	{id = 31479, chance = 1036},
	{id = 2514, chance = 487},
	{id = 2466, chance = 366}
}

mType:register(monster)
