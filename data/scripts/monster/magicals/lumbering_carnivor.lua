local mType = Game.createMonsterType("Lumbering Carnivor")
local monster = {}

monster.name = "Lumbering Carnivor"
monster.description = "a lumbering carnivor"
monster.experience = 1452
monster.outfit = {
	lookType = 1133,
	lookHead = 0,
	lookBody = 59,
	lookLegs = 67,
	lookFeet = 85,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 2600
monster.maxHealth = 2600
monster.runHealth = 0
monster.race = "blood"
monster.corpse = 32721
monster.speed = 400
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
	{type = COMBAT_PHYSICALDAMAGE, percent = 20},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = -40},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -300},
	{name ="combat", interval = 2000, chance = 17, minDamage = -180, maxDamage = -210, length = 2, type = COMBAT_PHYSICALDAMAGE, effect = CONST_ME_HITAREA, direction = true },
	{name ="combat", interval = 2000, chance = 19, minDamage = -160, maxDamage = -190, length = 4, type = COMBAT_PHYSICALDAMAGE, effect = CONST_ME_HITAREA, direction = true },
	{name ="combat", interval = 2000, chance = 27, minDamage = -190, maxDamage = -240, radius = 3, range = 6, type = COMBAT_EARTHDAMAGE, effect = CONST_ME_EXPLOSIONAREA, shootEffect = CONST_ANI_SMALLSTONE, target = true },
	{name ="combat", interval = 2000, chance = 20, minDamage = 0, maxDamage = -200, range = 6, type = COMBAT_PHYSICALDAMAGE, shootEffect = CONST_ANI_CRYSTALLINEARROW, target = true},
}

monster.defenses = {
	defense = 65,
	armor = 65
}

monster.loot = {
	{id = 2152, chance = 64483, maxCount = 3},
	{id = 32001, chance = 20477, maxCount = 3},
	{id = 2386, chance = 15711},
	{id = 2396, chance = 6925},
	{id = 2376, chance = 4914},
	{id = 7633, chance = 2159},
	{id = 2155, chance = 2085},
	{id = 2377, chance = 1787},
	{id = 2153, chance = 1713},
	{id = 7454, chance = 1564},
	{id = 2158, chance = 1042},
	{id = 24741, chance = 1042},
	{id = 18415, chance = 968},
	{id = 2656, chance = 521},
	{id = 8871, chance = 74}
}

mType:register(monster)
