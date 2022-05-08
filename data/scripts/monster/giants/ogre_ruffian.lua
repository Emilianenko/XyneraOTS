local mType = Game.createMonsterType("ogre ruffian")
local monster = {}

monster.name = "Ogre Ruffian"
monster.description = "an ogre ruffian"
monster.experience = 5000
monster.outfit = {
	lookType = 1212,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 5500
monster.maxHealth = 5500
monster.runHealth = 0
monster.race = "blood"
monster.corpse = 34183
monster.speed = 430
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
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "drunk", condition = true},
	{type = "bleed", condition = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 50},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -20},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -450},
	{name ="combat", interval = 2000, chance = 13, type = COMBAT_PHYSICALDAMAGE, minDamage = -250, maxDamage = -450, radius = 5, target = false, effect = CONST_ME_GROUNDSHAKER},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -200, maxDamage = -350, range = 4, radius = 5, target = true, shootEffect = CONST_ANI_LARGEROCK, effect = CONST_ME_POFF}
}

monster.defenses = {
	defense = 102,
	armor = 102
}

monster.loot = {
	{id = 2152, chance = 100000},
	{id = 24845, chance = 17820},
	{id = 24844, chance = 16771},
	{id = 2146, chance = 12998, maxCount = 2},
	{id = 2666, chance = 10063},
	{id = 7387, chance = 5031},
	{id = 2149, chance = 4193},
	{id = 2197, chance = 3564},
	{id = 2391, chance = 2935},
	{id = 2156, chance = 2725},
	{id = 24847, chance = 2725},
	{id = 23540, chance = 1677},
	{id = 20108, chance = 1677},
	{id = 18419, chance = 1468},
	{id = 24849, chance = 1468},
	{id = 2154, chance = 1468},
	{id = 2158, chance = 1048},
	{id = 18416, chance = 419},
	{id = 7761, chance = 419},
	{id = 24827, chance = 210}
}

mType:register(monster)
