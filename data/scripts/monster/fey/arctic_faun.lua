local mType = Game.createMonsterType("Arctic Faun")
local monster = {}

monster.name = "Arctic Faun"
monster.description = "an arctic faun"
monster.experience = 300
monster.outfit = {
	lookType = 980,
	lookHead = 85,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 85,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 300
monster.maxHealth = 300
monster.runHealth = 0
monster.race = "blood"
monster.corpse = 31466
monster.speed = 210
monster.summonCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 0
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
	{text = "Dance with me!", yell = false},
	{text = "In vino veritas! Hahaha!", yell = false},
	{text = "Wine, women and song!", yell = false}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "drunk", condition = true},
	{type = "bleed", condition = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 10},
	{type = COMBAT_ENERGYDAMAGE, percent = -10},
	{type = COMBAT_EARTHDAMAGE, percent = 70},
	{type = COMBAT_FIREDAMAGE, percent = -15},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 80},
	{type = COMBAT_HOLYDAMAGE , percent = 30},
	{type = COMBAT_DEATHDAMAGE , percent = 20}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -100},
	{name ="combat", interval = 2000, chance = 17, minDamage = -20, maxDamage = -60, range = 5, type = COMBAT_ICEDAMAGE, effect = CONST_ME_ICETORNADO, shootEffect = CONST_ANI_SNOWBALL, target = true}, -- ice whirl
	{name ="combat", interval = 2000, chance = 100, minDamage = -5, maxDamage = -37, range = 5, type = COMBAT_ICEDAMAGE, effect = CONST_ME_ICEAREA, shootEffect = CONST_ANI_SNOWBALL, target = true}, -- icicle
}

monster.defenses = {
	defense = 30,
	armor = 30,
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 30, maxDamage = 60, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.loot = {
	{id = 2148, chance = 100000, maxCount = 105},
	{id = 28351, chance = 15133},
	{id = 7588, chance = 11406},
	{id = 28348, chance = 9923},
	{id = 28349, chance = 9713},
	{id = 28391, chance = 8282, maxCount = 3},
	{id = 2760, chance = 8046},
	{id = 2687, chance = 6103, maxCount = 5},
	{id = 2681, chance = 5276},
	{id = 2074, chance = 5079},
	{id = 28393, chance = 4988, maxCount = 2},
	{id = 1294, chance = 4935, maxCount = 2},
	{id = 7591, chance = 3570},
	{id = 2664, chance = 1024},
	{id = 9928, chance = 341},
	{id = "die", chance = 210},
	{id = 28355, chance = 210}
}

mType:register(monster)
