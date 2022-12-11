local mType = Game.createMonsterType("Spiky Carnivor")
local monster = {}

monster.name = "Spiky Carnivor"
monster.description = "a spiky carnivor"
monster.experience = 1650
monster.outfit = {
	lookType = 1139,
	lookHead = 79,
	lookBody = 121,
	lookLegs = 23,
	lookFeet = 86,
	lookAddons = 1,
	lookMount = 0
}

monster.health = 2800
monster.maxHealth = 2800
monster.runHealth = 0
monster.race = "blood"
monster.corpse = 32755
monster.speed = 320
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
	{type = COMBAT_PHYSICALDAMAGE, percent = 40},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = -30},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -300, condition = {type = CONDITION_POISON, minDamage = -210, maxDamage = -210, interval = 4000}}, -- 10 hp/tick
	{name ="combat", interval = 2000, chance = 27, minDamage = -110, maxDamage = -170, length = 6, type = COMBAT_EARTHDAMAGE, effect = CONST_ME_HITBYPOISON, direction = true },
	{name ="combat", interval = 2000, chance = 23, minDamage = -180, maxDamage = -230, radius = 4, type = COMBAT_PHYSICALDAMAGE, effect = CONST_ME_GROUNDSHAKER},
	{name ="combat", interval = 2000, chance = 19, minDamage = -110, maxDamage = -170, length = 2, type = COMBAT_PHYSICALDAMAGE, effect = CONST_ME_HITAREA, direction = true },
	{name ="SpikyCarnivorTWave", interval = 2000, chance = 17, minDamage = -190, maxDamage = -230},
}

monster.defenses = {
	defense = 71,
	armor = 71
}

monster.loot = {
	{id = 2152, chance = 67042, maxCount = 6},
	{id = 2489, chance = 13344},
	{id = 32002, chance = 10289, maxCount = 2},
	{id = 18418, chance = 9325},
	{id = 18417, chance = 6833},
	{id = 2515, chance = 4582},
	{id = 2475, chance = 2492},
	{id = 28393, chance = 2412, maxCount = 2},
	{id = 2151, chance = 1929},
	{id = 7888, chance = 1768},
	{id = 7887, chance = 1768},
	{id = 2656, chance = 1688},
	{id = 27618, chance = 1286},
	{id = 7889, chance = 965},
	{id = 2485, chance = 241},
	{id = 20109, chance = 161},
	{id = 10221, chance = 161},
	{id = 7884, chance = 161}
}

mType:register(monster)
