local mType = Game.createMonsterType("Deepworm")
local monster = {}

monster.name = "Deepworm"
monster.description = "a deepworm"
monster.experience = 2300
monster.outfit = {
	lookType = 1033,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 3500
monster.maxHealth = 3500
monster.runHealth = 0
monster.race = "blood"
monster.corpse = 30201
monster.speed = 204
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
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "drunk", condition = true},
	{type = "bleed", condition = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 30},
	{type = COMBAT_FIREDAMAGE, percent = -20},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -300},
	{name ="combat", interval = 2000, chance = 20, minDamage = -320, maxDamage = -390, radius = 4, type = COMBAT_EARTHDAMAGE, effect = CONST_ME_HITBYPOISON, shootEffect = CONST_ANI_POISON, target = true},
	{name ="combat", interval = 2000, chance = 14, minDamage = -200, maxDamage = -300, length = 5, spread = 0, type = COMBAT_EARTHDAMAGE, effect = CONST_ME_HITBYPOISON, direction = true},
}

monster.defenses = {
	defense = 73,
	armor = 73
}

monster.loot = {
	{id = 30250, chance = 23762},
	{id = 2791, chance = 22422},
	{id = 2666, chance = 19407},
	{id = 2671, chance = 19263},
	{id = 2796, chance = 18569},
	{id = 2792, chance = 14286},
	{id = 30249, chance = 13161},
	{id = 30248, chance = 10290},
	{id = 2168, chance = 8519},
	{id = 18415, chance = 5863},
	{id = 7887, chance = 4762},
	{id = 7762, chance = 3398, maxCount = 2},
	{id = 10219, chance = 2201},
	{id = 30309, chance = 1795},
	{id = 8912, chance = 1268},
	{id = 7633, chance = 718}
}

mType:register(monster)
