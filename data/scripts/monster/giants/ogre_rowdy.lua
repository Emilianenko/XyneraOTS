local mType = Game.createMonsterType("ogre rowdy")
local monster = {}

monster.name = "Ogre Rowdy"
monster.description = "an ogre rowdy"
monster.experience = 4200
monster.outfit = {
	lookType = 1213,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 4500
monster.maxHealth = 4500
monster.runHealth = 0
monster.race = "blood"
monster.corpse = 34187
monster.speed = 420
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
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 70},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -30},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -450},
	{name ="combat", interval = 2000, chance = 13, type = COMBAT_FIREDAMAGE, minDamage = -250, maxDamage = -400, range = 5, radius = 4, target = true, shootEffect = CONST_ANI_WHIRLWINDAXE, effect = CONST_ME_EXPLOSIONHIT},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -200, maxDamage = -450, radius = 3, target = false, effect = CONST_ME_FIREAREA},
	{name ="combat", interval = 2000, chance = 18, type = COMBAT_FIREDAMAGE, minDamage = -280, maxDamage = -420, range = 3, shootEffect = CONST_ANI_FLAMMINGARROW}
}

monster.defenses = {
	defense = 98,
	armor = 98
}

monster.loot = {
	{id = 2152, chance = 100000},
	{id = 7840, chance = 24595, maxCount = 9},
	{id = 24845, chance = 18447},
	{id = 24844, chance = 17476},
	{id = 24847, chance = 11327},
	{id = 2187, chance = 8091},
	{id = 8921, chance = 5016},
	{id = 27618, chance = 4531},
	{id = 2149, chance = 3722},
	{id = 18413, chance = 3074},
	{id = 8844, chance = 2589, maxCount = 2},
	{id = 24849, chance = 2265},
	{id = 18414, chance = 1942},
	{id = 18409, chance = 1294},
	{id = 2158, chance = 1133},
	{id = 24850, chance = 1133},
	{id = 24828, chance = 971},
	{id = 7633, chance = 809}
}

mType:register(monster)
