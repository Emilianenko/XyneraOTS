local mType = Game.createMonsterType("urmahlullu the weakened")
local monster = {}

monster.name = "Urmahlullu The Weakened"
monster.description = "Urmahlullu The Weakened"
monster.experience = 85000
monster.outfit = {
	lookType = 1197,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 130000
monster.maxHealth = 130000
monster.runHealth = 0
monster.race = "blood"
monster.corpse = 34069
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
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 2000,
	chance = 5,
	{text = "You will regret this!", yell = false}
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
	{type = COMBAT_ENERGYDAMAGE, percent = 40},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1100},
	{name ="combat", interval = 3000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -500, maxDamage = -800, radius = 4, target = false, effect = CONST_ME_FIREAREA},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -550, maxDamage = -800, radius = 3, target = false, effect = CONST_ME_FIREAREA},
	{name ="combat", interval = 2000, chance = 18, type = COMBAT_FIREDAMAGE, minDamage = -450, maxDamage = -600, ring = 3, target = false, effect = CONST_ME_FIREATTACK}
}

monster.defenses = {
	defense = 10,
	armor = 10
}

monster.loot = {
	{id = 26191, chance = 100000},
	{id = 2155, chance = 100000, maxCount = 2},
	{id = 2152, chance = 100000, maxCount = 6},
	{id = 26029, chance = 100000, maxCount = 14},
	{id = 2160, chance = 50000, maxCount = 4},
	{id = 7895, chance = 50000},
	{id = 26031, chance = 50000, maxCount = 3},
	{id = 2154, chance = 50000, maxCount = 2},
	{id = 7439, chance = 25000, maxCount = 19},
	{id = 2158, chance = 25000},
	{id = 7838, chance = 25000, maxCount = 94},
	{id = 7889, chance = 25000},
	{id = 2156, chance = 25000},
	{id = 28415, chance = 25000, maxCount = 48},
	{id = 26030, chance = 25000, maxCount = 9},
	{id = 34279, chance = 25000}
}

mType:register(monster)
