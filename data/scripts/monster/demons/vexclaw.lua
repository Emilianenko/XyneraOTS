local mType = Game.createMonsterType("Vexclaw")
local monster = {}

monster.name = "Vexclaw"
monster.description = "a vexclaw"
monster.experience = 6248
monster.outfit = {
	lookType = 854,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 8500
monster.maxHealth = 8500
monster.runHealth = 0
monster.race = "blood"
monster.corpse = 25432
monster.speed = 270
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
	targetDistance = 4,
	healthHidden = false,
	canWalkOnEnergy = false,
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
	{text = "Power is miiiiine!", yell = false},
	{text = "Weakness must be culled!", yell = false},
	{text = "Will Prove my power!", yell = false}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "drunk", condition = true},
	{type = "bleed", condition = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 5},
	{type = COMBAT_ENERGYDAMAGE, percent = 10},
	{type = COMBAT_EARTHDAMAGE, percent = 40},
	{type = COMBAT_FIREDAMAGE, percent = 75},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -5},
	{type = COMBAT_HOLYDAMAGE , percent = -10},
	{type = COMBAT_DEATHDAMAGE , percent = 20}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -550},
	{name ="combat", interval = 2000, chance = 25, minDamage = -350, maxDamage = -480, radius = 4, range = 7, type = COMBAT_FIREDAMAGE, effect = CONST_ME_FIREAREA, shootEffect = CONST_ANI_BURSTARROW, target = true}, -- fire ball
	{name ="combat", interval = 2000, chance = 22, minDamage = -260, maxDamage = -450, radius = 6, range = 7, type = COMBAT_PHYSICALDAMAGE, effect = CONST_ME_GROUNDSHAKER, shootEffect = CONST_ANI_BURSTARROW, target = true}, --greater groundshaker ball
	{name ="combat", interval = 2000, chance = 16, minDamage = -400, maxDamage = -500, radius = 6, type = COMBAT_ENERGYDAMAGE, effect = CONST_ME_ENERGYHIT}, --greater energy ball
	{name ="combat", interval = 2000, chance = 14, minDamage = -100, maxDamage = -170, length = 6, spread = 0, type = COMBAT_MANADRAIN, effect = CONST_ME_ICEATTACK, direction = true}, -- ice beam
	{name ="wexclaw wave", interval = 2000, chance = 13, minDamage = -530, maxDamage = -600} -- T wave manadrain
}

monster.defenses = {
	defense = 55,
	armor = 55,
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 230, maxDamage = 400, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name = "speed", chance = 15, interval = 2*1000, speed = 320, effect = CONST_ME_MAGIC_RED, duration = 5000}
}

monster.loot = {
	{id = 2148, chance = 87216, maxCount = 197},
	{id = 2152, chance = 87131, maxCount = 9},
	{id = 8472, chance = 16078, maxCount = 5},
	{id = 7590, chance = 16044, maxCount = 5},
	{id = 25384, chance = 13313},
	{id = 8473, chance = 12954, maxCount = 5},
	{id = 6500, chance = 12715},
	{id = 2795, chance = 12391, maxCount = 6},
	{id = 2149, chance = 7100, maxCount = 5},
	{id = 2147, chance = 6639, maxCount = 5},
	{id = 2150, chance = 6622, maxCount = 5},
	{id = 9970, chance = 6213, maxCount = 5},
	{id = 2156, chance = 3175},
	{id = 2154, chance = 3072},
	{id = 2396, chance = 3038},
	{id = 2432, chance = 2714},
	{id = 2167, chance = 1741},
	{id = 2164, chance = 1741},
	{id = 2393, chance = 1246},
	{id = 2214, chance = 956},
	{id = 2462, chance = 853},
	{id = 2520, chance = 546},
	{id = 2171, chance = 461},
	{id = 25383, chance = 444},
	{id = 25523, chance = 358},
	{id = 25382, chance = 324},
	{id = 2514, chance = 307},
	{id = 2470, chance = 273},
	{id = 2472, chance = 102},
	{id = 25522, chance = 85},
	{id = 7382, chance = 68}
}

mType:register(monster)
