local mType = Game.createMonsterType("Grimeleech")
local monster = {}

monster.name = "Grimeleech"
monster.description = "a grimeleech"
monster.experience = 7216
monster.outfit = {
	lookType = 855,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 1,
	lookMount = 0
}

monster.health = 9500
monster.maxHealth = 9500
monster.runHealth = 0
monster.race = "blood"
monster.corpse = 25436
monster.speed = 340
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
	{text = "Death... Taste!", yell = false}
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
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -450},
	{name ="combat", interval = 2000, chance = 14, minDamage = 0, maxDamage = -200, range = 5, type = COMBAT_PHYSICALDAMAGE, shootEffect = CONST_ANI_GREENSTAR, target = true},
	{name ="combat", interval = 2000, chance = 10, minDamage = -180, maxDamage = -240, range = 1, type = COMBAT_LIFEDRAIN, effect = CONST_ME_MAGIC_RED, target = true},
	{name ="combat", interval = 2000, chance = 11, minDamage = -200, maxDamage = -270, length = 5, spread = 3, type = COMBAT_MANADRAIN, effect = CONST_ME_MAGIC_RED, target = false, direction = true},
	{name ="drunk", interval = 2000, chance = 20, effect = CONST_ME_STUN, shootEffect = CONST_ANI_GLOOTHSPEAR, radius = 3, range = 5, target = true, duration = 10000},
	{name ="grimeleech wave", interval = 2000, chance = 16, minDamage = -450, maxDamage = -650},
	{name ="combat", interval = 2000, chance = 18, minDamage = -320, maxDamage = -400, radius = 3, range = 5, type = COMBAT_DEATHDAMAGE, effect = CONST_ME_POFF, shootEffect = CONST_ANI_GLOOTHSPEAR, target = true},
	{name ="combat", interval = 2000, chance = 13, minDamage = 0, maxDamage = -170, range = 5, type = COMBAT_PHYSICALDAMAGE, shootEffect = CONST_ANI_GLOOTHSPEAR, target = true},
}

monster.defenses = {
	defense = 65,
	armor = 65,
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 200, maxDamage = 300}
}

monster.loot = {
	{id = 2148, chance = 93531, maxCount = 199},
	{id = 2152, chance = 90015, maxCount = 8},
	{id = 7591, chance = 25091, maxCount = 3},
	{id = 8472, chance = 24472, maxCount = 3},
	{id = 7590, chance = 24271, maxCount = 3},
	{id = 6558, chance = 18367},
	{id = 6500, chance = 14978},
	{id = 25386, chance = 14541},
	{id = 2795, chance = 11625, maxCount = 5},
	{id = 2796, chance = 11261, maxCount = 5},
	{id = 2150, chance = 8163, maxCount = 5},
	{id = 2147, chance = 7908, maxCount = 5},
	{id = 9970, chance = 7526, maxCount = 5},
	{id = 2145, chance = 7088, maxCount = 5},
	{id = 8910, chance = 5630},
	{id = 8922, chance = 3335},
	{id = 2154, chance = 2733},
	{id = 2156, chance = 2095},
	{id = 7894, chance = 984},
	{id = 2158, chance = 765},
	{id = 2520, chance = 765},
	{id = 2462, chance = 601},
	{id = 7418, chance = 565},
	{id = 25383, chance = 547},
	{id = 25523, chance = 364},
	{id = 25382, chance = 346},
	{id = 25522, chance = 310},
	{id = 7414, chance = 128},
	{id = 2472, chance = 128},
	{id = 2645, chance = 128},
	{id = 7388, chance = 109}
}

mType:register(monster)
