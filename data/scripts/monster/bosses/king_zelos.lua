local mType = Game.createMonsterType("king zelos")
local monster = {}

monster.name = "King Zelos"
monster.description = "King Zelos"
monster.experience = 75000
monster.outfit = {
	lookType = 1224,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 480000
monster.maxHealth = 480000
monster.runHealth = 0
monster.race = "blood"
monster.corpse = 34267
monster.speed = 250
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
	interval = 2000,
	chance = 5,
	{text = "Mine is the power of death! You can't defeat me!", yell = false},
	{text = "I will rule again and my realm of death will span the world!", yell = false},
	{text = "My lich-knights will conquer this world for me!", yell = false}
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
	{type = COMBAT_ENERGYDAMAGE, percent = 3},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 5},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.attacks = {
}

monster.defenses = {
	defense = 10,
	armor = 10
}

monster.loot = {
	{id = 2160, chance = 100000, maxCount = 8},
	{id = 25172, chance = 99725, maxCount = 4},
	{id = 25377, chance = 73352, maxCount = 3},
	{id = 26031, chance = 57967, maxCount = 20},
	{id = 26030, chance = 56044, maxCount = 20},
	{id = 26029, chance = 54670, maxCount = 20},
	{id = 2154, chance = 27473, maxCount = 2},
	{id = 2156, chance = 26374, maxCount = 2},
	{id = 2487, chance = 17582},
	{id = 7443, chance = 15934, maxCount = 10},
	{id = 7440, chance = 15934, maxCount = 10},
	{id = 7439, chance = 14286, maxCount = 10},
	{id = 2155, chance = 12912},
	{id = 9971, chance = 12363},
	{id = 26199, chance = 11538},
	{id = 2158, chance = 11264},
	{id = 7884, chance = 10714},
	{id = 26187, chance = 10440},
	{id = 26198, chance = 10165},
	{id = 26200, chance = 9341},
	{id = 7899, chance = 9341},
	{id = 7898, chance = 7967},
	{id = 1986, chance = 7692},
	{id = 26185, chance = 7143},
	{id = 34246, chance = 7143},
	{id = 26189, chance = 6868},
	{id = 7897, chance = 6593},
	{id = 2153, chance = 6044, maxCount = 2},
	{id = 34244, chance = 5495},
	{id = 34245, chance = 4396},
	{id = 32717, chance = 4121},
	{id = 5885, chance = 3022},
	{id = 32716, chance = 3022},
	{id = 5904, chance = 3022},
	{id = 5909, chance = 2198, maxCount = 4},
	{id = 5892, chance = 1923},
	{id = 7414, chance = 1374},
	{id = 2195, chance = 1374},
	{id = 34393, chance = 1374},
	{id = 34237, chance = 1099},
	{id = 34238, chance = 1099},
	{id = 32715, chance = 1099},
	{id = 34236, chance = 1099},
	{id = 34239, chance = 1099},
	{id = 13532, chance = 824},
	{id = 32712, chance = 824},
	{id = 15515, chance = 549},
	{id = 5884, chance = 549},
	{id = 27048, chance = 275}
}

mType:register(monster)
