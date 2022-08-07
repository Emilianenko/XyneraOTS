local mType = Game.createMonsterType("Ink Blob")
local monster = {}

monster.name = "Ink Blob"
monster.description = "an ink blob"
monster.experience = 14450
monster.outfit = {
	lookType = 1064,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 9500
monster.maxHealth = 9500
monster.runHealth = 0
monster.race = "blood"
monster.corpse = 31258
monster.speed = 380
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
	{type = COMBAT_ENERGYDAMAGE, percent = -8},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -550},
	{name ="combat", interval = 2000, chance = 25, minDamage = -600, maxDamage = -900, radius = 3, range = 7, type = COMBAT_EARTHDAMAGE, effect = CONST_ME_HITBYPOISON, shootEffect = CONST_ANI_POISONARROW, target = true},
	{name ="combat", interval = 2000, chance = 20, minDamage = -600, maxDamage = -850, radius = 5, type = COMBAT_EARTHDAMAGE, effect = CONST_ME_MAGIC_BLUE},
	{name ="combat", interval = 2000, chance = 14, minDamage = -700, maxDamage = -950, radius = 4, type = COMBAT_EARTHDAMAGE, effect = CONST_ME_MAGIC_BLUE},
	{name ="InkBlobWave", interval = 2000, chance = 15, minDamage = -1200, maxDamage = -1650}
}

monster.defenses = {
	defense = 70,
	armor = 70
}

monster.loot = {
	{id = 2152, chance = 74513, maxCount = 25},
	{id = 18437, chance = 69680, maxCount = 50},
	{id = 2145, chance = 68355, maxCount = 7},
	{id = 9970, chance = 49649, maxCount = 3},
	{id = 31224, chance = 44661, maxCount = 4},
	{id = 10557, chance = 34762},
	{id = 7633, chance = 14965},
	{id = 7886, chance = 6157},
	{id = 7903, chance = 6002},
	{id = 2158, chance = 5378},
	{id = 7885, chance = 2650},
	{id = 10219, chance = 1793},
	{id = 2197, chance = 1793},
	{id = 2200, chance = 1247},
	{id = 7884, chance = 1169},
	{id = 8912, chance = 701},
	{id = 11339, chance = 624},
	{id = 7887, chance = 546},
	{id = 8880, chance = 78}
}

mType:register(monster)
