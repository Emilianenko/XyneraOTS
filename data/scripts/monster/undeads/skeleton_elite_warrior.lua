local mType = Game.createMonsterType("Skeleton Elite Warrior")
local monster = {}

monster.name = "Skeleton Elite Warrior"
monster.description = "a skeleton elite warrior"
monster.experience = 4500
monster.outfit = {
	lookType = 298,
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
monster.race = "undead"
monster.corpse = 5972
monster.speed = 310
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
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	healthHidden = false,
	canWalkOnEnergy = false,
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
	{type = COMBAT_ENERGYDAMAGE, percent = -5},
	{type = COMBAT_EARTHDAMAGE, percent = 5},
	{type = COMBAT_FIREDAMAGE, percent = -5},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = -25},
	{type = COMBAT_DEATHDAMAGE , percent = 100}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -500},
	{name ="combat", interval = 2000, chance = 25, minDamage = -450, maxDamage = -500, range = 5, radius = 3, type = COMBAT_DEATHDAMAGE, effect = CONST_ME_MORTAREA, shootEffect = CONST_ANI_ENERGYBALL, target = true},
	{name ="combat", interval = 2000, chance = 40, minDamage = -400, maxDamage = -480, range = 1, type = COMBAT_LIFEDRAIN, shootEffect = CONST_ANI_SUDDENDEATH, target = true}, --life drain
	{name ="combat", interval = 2000, chance = 18, minDamage = -180, maxDamage = -390, radius = 4, type = COMBAT_DEATHDAMAGE, effect = CONST_ME_GROUNDSHAKER, target = false},
}

monster.defenses = {
	defense = 75,
	armor = 75
}

monster.loot = {
	{id = 2152, chance = 100000, maxCount = 15},
	{id = 2230, chance = 50190},
	{id = 5944, chance = 25698, maxCount = 5},
	{id = 2787, chance = 25054},
	{id = 12437, chance = 15651, maxCount = 3},
	{id = 11233, chance = 10211},
	{id = 2430, chance = 6249},
	{id = 7381, chance = 5225},
	{id = 27036, chance = 5052},
	{id = 5741, chance = 3145},
	{id = 2376, chance = 1923},
	{id = 2789, chance = 1907},
	{id = 2398, chance = 1841},
	{id = 6553, chance = 363}
}

mType:register(monster)
