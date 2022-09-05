local mType = Game.createMonsterType("Orclops Doomhauler")
local monster = {}

monster.name = "Orclops Doomhauler"
monster.description = "an orclops doomhauler"
monster.experience = 1200
monster.outfit = {
	lookType = 934,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 1700
monster.maxHealth = 1700
monster.runHealth = 20
monster.race = "blood"
monster.corpse = 27734
monster.speed = 240
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
	{text = "Me mash!", yell = false},
	{text = "GRRRRR!", yell = false},
	{text = "Muhahaha!", yell = false},
	{text = "Me strong, you weak!", yell = false}
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
	{type = COMBAT_ENERGYDAMAGE, percent = -10},
	{type = COMBAT_EARTHDAMAGE, percent = 30},
	{type = COMBAT_FIREDAMAGE, percent = 15},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -10},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 10}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -215},
	{name ="combat", interval = 2000, chance = 100, minDamage = -175, maxDamage = -220, range = 5, radius = 1, type = COMBAT_PHYSICALDAMAGE, effect = CONST_ME_EXPLOSIONAREA, shootEffect = CONST_ANI_LARGEROCK, target = true},
	-- bleeding area attack 
}

monster.defenses = {
	defense = 35,
	armor = 35,
	{name ="speed", interval = 2000, chance = 8, speed = {min = 210, max = 210}, duration = 5000, effect = CONST_ME_MAGIC_RED}
}

monster.loot = {
	{id = 2148, chance = 100000, maxCount = 184},
	{id = 27038, chance = 20240},
	{id = 27036, chance = 19822},
	{id = 7588, chance = 16606},
	{id = 27037, chance = 14976},
	{id = 2788, chance = 8105, maxCount = 3},
	{id = 2428, chance = 7863},
	{id = 2194, chance = 5969},
	{id = 2147, chance = 3227, maxCount = 3},
	{id = 2144, chance = 3116, maxCount = 2},
	{id = 9970, chance = 2951, maxCount = 2},
	{id = 8843, chance = 2918, maxCount = 2},
	{id = 18417, chance = 2445, maxCount = 2},
	{id = 7452, chance = 1388},
	{id = 20108, chance = 1377},
	{id = 7439, chance = 1046},
	{id = 11374, chance = 1002},
	{id = 3953, chance = 947}
}

mType:register(monster)
