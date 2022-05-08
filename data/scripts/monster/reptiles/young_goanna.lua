local mType = Game.createMonsterType("young goanna")
local monster = {}

monster.name = "Young Goanna"
monster.description = "a young goanna"
monster.experience = 6100
monster.outfit = {
	lookType = 1196,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 6200
monster.maxHealth = 6200
monster.runHealth = 0
monster.race = "blood"
monster.corpse = 34065
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

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = -20},
	{type = COMBAT_EARTHDAMAGE, percent = 80},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -230, condition = {type = CONDITION_POISON, startDamage = 15, interval = 4000}},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -300, maxDamage = -490, range = 3, radius = 1, target = true, shootEffect = CONST_ANI_EARTH, effect = CONST_ME_EXPLOSIONHIT}
}

monster.defenses = {
	defense = 78,
	armor = 78,
	{name ="speed", interval = 2000, chance = 5, speed = {min = 400, max = 400}, duration = 5000, effect = CONST_ME_MAGIC_RED}
}

monster.loot = {
	{id = 2152, chance = 100000, maxCount = 3},
	{id = 18437, chance = 68257, maxCount = 35},
	{id = 34216, chance = 10299},
	{id = 2182, chance = 9514},
	{id = 2181, chance = 9453},
	{id = 18413, chance = 9000},
	{id = 34215, chance = 8034},
	{id = 28391, chance = 4440, maxCount = 3},
	{id = 34217, chance = 4017},
	{id = 24849, chance = 3866},
	{id = 2409, chance = 3866},
	{id = 7761, chance = 3775},
	{id = 2154, chance = 3111},
	{id = 18415, chance = 3081},
	{id = 8912, chance = 2960},
	{id = 28393, chance = 2658, maxCount = 3},
	{id = 2153, chance = 2537},
	{id = 34144, chance = 2175},
	{id = 2170, chance = 1782},
	{id = 2158, chance = 1117},
	{id = 33996, chance = 1087},
	{id = 34101, chance = 997},
	{id = 7887, chance = 936},
	{id = 18418, chance = 725},
	{id = 10219, chance = 725},
	{id = 7903, chance = 513},
	{id = 28355, chance = 393},
	{id = 24741, chance = 121}
}

mType:register(monster)
