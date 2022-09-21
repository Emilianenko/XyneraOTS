local mType = Game.createMonsterType("cobra vizier")
local monster = {}

monster.name = "Cobra Vizier"
monster.description = "a cobra vizier"
monster.experience = 7650
monster.outfit = {
	lookType = 1217,
	lookHead = 19,
	lookBody = 19,
	lookLegs = 67,
	lookFeet = 78,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 8500
monster.maxHealth = 8500
monster.runHealth = 0
monster.race = "blood"
monster.corpse = 34295
monster.speed = 320
monster.summonCost = 0

monster.changeTarget = {
	interval = 4000,
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
	canWalkOnEnergy = true,
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
	{text = "COMBINE FORCES MY BRETHEN!", yell = false},
	{text = "Feel the cobras wrath!", yell = false},
	{text = "OH NO, YOU WON'T!", yell = false}
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
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
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
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -480},
	{name ="Cobra Chain", interval = 2000, chance = 40},
	{name ="short explosion wave", interval = 2000, chance = 15, minDamage = -280, maxDamage = -400},
	{name ="combat", interval = 2000, chance = 12, type = COMBAT_EARTHDAMAGE, minDamage = -350, maxDamage = -520, range = 4, radius = 4, target = true, shootEffect = CONST_ANI_SMALLEARTH, effect = CONST_ME_GREEN_RINGS}
}

monster.defenses = {
	defense = 82,
	armor = 82,
	{name ="speed", interval = 2000, chance = 8, speed = {min = 340, max = 340}, duration = 5000, effect = CONST_ME_MAGIC_GREEN}
}

monster.loot = {
	{id = 2152, chance = 71279, maxCount = 4},
	{id = 2181, chance = 32193},
	{id = 34334, chance = 14817},
	{id = 7886, chance = 14169},
	{id = 7903, chance = 13073},
	{id = 2182, chance = 12375},
	{id = 18419, chance = 11279},
	{id = 2156, chance = 7458},
	{id = 7633, chance = 6512},
	{id = 18421, chance = 5017},
	{id = 27048, chance = 4485},
	{id = 18414, chance = 3754},
	{id = 2127, chance = 3306},
	{id = 2155, chance = 3189},
	{id = 18420, chance = 2807},
	{id = 2409, chance = 2542},
	{id = 24849, chance = 897, maxCount = 3}
}

mType:register(monster)
