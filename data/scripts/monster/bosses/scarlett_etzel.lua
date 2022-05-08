local mType = Game.createMonsterType("scarlett etzel")
local monster = {}

monster.name = "Scarlett Etzel"
monster.description = "Scarlett Etzel"
monster.experience = 20000
monster.outfit = {
	lookType = 1201,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 30000
monster.maxHealth = 30000
monster.runHealth = 0
monster.race = "blood"
monster.corpse = 34109
monster.speed = 175
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
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -600},
	{name ="combat", interval = 2000, chance = 16, type = COMBAT_DEATHDAMAGE, minDamage = -400, maxDamage = -600, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA},
	{name ="combat", interval = 2000, chance = 13, type = COMBAT_HOLYDAMAGE, minDamage = -450, maxDamage = -640, length = 7, spread = 0, effect = CONST_ME_HOLYAREA},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -480, maxDamage = -630, radius = 5, target = false, effect = CONST_ME_EXPLOSIONHIT}
}

monster.defenses = {
	defense = 10,
	armor = 10
}

monster.loot = {
	{id = 2155, chance = 100000, maxCount = 2},
	{id = 26191, chance = 95652},
	{id = 2152, chance = 95652, maxCount = 9},
	{id = 26029, chance = 73913, maxCount = 38},
	{id = 26031, chance = 52174, maxCount = 31},
	{id = 2156, chance = 30435, maxCount = 2},
	{id = 2158, chance = 26087, maxCount = 2},
	{id = 28415, chance = 26087, maxCount = 113},
	{id = 26030, chance = 26087, maxCount = 11},
	{id = 7443, chance = 21739, maxCount = 19},
	{id = 7632, chance = 21739},
	{id = 7440, chance = 21739, maxCount = 18},
	{id = 9971, chance = 17391},
	{id = 7899, chance = 17391},
	{id = 2154, chance = 17391},
	{id = 7439, chance = 13043, maxCount = 15},
	{id = 7890, chance = 13043},
	{id = 7900, chance = 13043},
	{id = 7884, chance = 13043},
	{id = 2160, chance = 8696},
	{id = 25172, chance = 8696},
	{id = 7887, chance = 8696},
	{id = 7903, chance = 8696},
	{id = 2153, chance = 8696},
	{id = 32715, chance = 4348},
	{id = 32717, chance = 4348},
	{id = 7885, chance = 4348}
}

mType:register(monster)
