local mType = Game.createMonsterType("sun marked goanna")
local monster = {}

monster.name = "Sun-Marked Goanna"
monster.description = "a sun-marked goanna"
monster.experience = 7600
monster.outfit = {
	lookType = 1195,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 7800
monster.maxHealth = 7800
monster.runHealth = 0
monster.race = "blood"
monster.corpse = 34061
monster.speed = 190
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
	{type = COMBAT_EARTHDAMAGE, percent = 75},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -350, condition = {type = CONDITION_POISON, minDamage = 380, maxDamage = 380, interval = 4000}},
	{name ="short poison twave", interval = 2000, chance = 10, minDamage = -250, maxDamage = -380},
	{name ="combat", interval = 2000, chance = 12, type = COMBAT_EARTHDAMAGE, minDamage = -450, maxDamage = -550, range = 3, radius = 1, target = true, shootEffect = CONST_ANI_EARTH, effect = CONST_ME_EXPLOSIONHIT},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -210, maxDamage = -300, radius = 5, target = false, effect = CONST_ME_GROUNDSHAKER}
}

monster.defenses = {
	defense = 84,
	armor = 84,
	{name ="speed", interval = 2000, chance = 5, speed = {min = 500, max = 500}, duration = 5000, effect = CONST_ME_MAGIC_RED}
}

monster.loot = {
	{id = 2152, chance = 100000, maxCount = 3},
	{id = 34084, chance = 75000},
	{id = 18437, chance = 50000},
	{id = 7850, chance = 25000, maxCount = 14},
	{id = 34084, chance = 25000},
	{id = 7903, chance = 25000},
	{id = 2181, chance = 25000}
}

mType:register(monster)
