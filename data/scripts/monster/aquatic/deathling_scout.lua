local mType = Game.createMonsterType("Deathling Scout")
local monster = {}

monster.name = "Deathling Scout"
monster.description = "a Deathling scout"
monster.experience = 6300
monster.outfit = {
	lookType = 1073,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 7200
monster.maxHealth = 7200
monster.runHealth = 50
monster.race = "blood"
monster.corpse = 31286
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
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	healthHidden = false,
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "VBOX°", yell = false},
	{text = "O(J-LJ-T =|-°", yell = false}
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
	{type = COMBAT_ENERGYDAMAGE, percent = -10},
	{type = COMBAT_EARTHDAMAGE, percent = -10},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 100},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 10}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -300},
	{name ="combat", interval = 2000, chance = 25, minDamage = -150, maxDamage = -350, range = 6, type = COMBAT_PHYSICALDAMAGE, shootEffect = CONST_ANI_SPEAR, target = true},
	{name ="combat", interval = 2000, chance = 25, minDamage = -150, maxDamage = -300, range = 6, type = COMBAT_PHYSICALDAMAGE, effect = CONST_ME_EXPLOSIONAREA, shootEffect = CONST_ANI_LARGEROCK, target = true},
	{name ="combat", interval = 2000, chance = 20, minDamage = -350, maxDamage = -550, radius = 4, type = COMBAT_EARTHDAMAGE, effect = CONST_ME_GROUNDSHAKER}
}

monster.defenses = {
	defense = 72,
	armor = 72
}

monster.loot = {
	{id = 18304, chance = 25260, maxCount = 25},
	{id = 15649, chance = 21340, maxCount = 25},
	{id = 2149, chance = 20910, maxCount = 12},
	{id = 15425, chance = 20280},
	{id = 15426, chance = 15100},
	{id = 15488, chance = 14630},
	{id = 7759, chance = 13000, maxCount = 8},
	{id = 15452, chance = 11240},
	{id = 7590, chance = 10000},
	{id = 7591, chance = 10000},
	{id = 13838, chance = 6620},
	{id = 13870, chance = 6070},
	{id = 15453, chance = 3630},
	{id = 15451, chance = 3470},
	{id = 3052, chance = 3000},
	{id = 5895, chance = 920},
	{id = 15403, chance = 440}
}

mType:register(monster)
