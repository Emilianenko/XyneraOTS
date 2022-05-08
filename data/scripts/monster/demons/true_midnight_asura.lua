local mType = Game.createMonsterType("True Midnight Asura")
local monster = {}

monster.name = "True Midnight Asura"
monster.description = "a true midnight asura"
monster.experience = 7313
monster.outfit = {
	lookType = 1068,
	lookHead = 0,
	lookBody = 76,
	lookLegs = 53,
	lookFeet = 0,
	lookAddons = 1,
	lookMount = 0
}

monster.health = 9000
monster.maxHealth = 9000
monster.runHealth = 0
monster.race = "blood"
monster.corpse = 31274
monster.speed = 340
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
	{type = COMBAT_ENERGYDAMAGE, percent = -10},
	{type = COMBAT_EARTHDAMAGE, percent = -20},
	{type = COMBAT_FIREDAMAGE, percent = 10},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 10},
	{type = COMBAT_HOLYDAMAGE , percent = 30},
	{type = COMBAT_DEATHDAMAGE , percent = 100}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -470},
	{name ="combat", interval = 2000, chance = 14, minDamage = -60, maxDamage = -290, length = 4, spread = 0, type = COMBAT_MANADRAIN, effect = CONST_ME_PURPLEENERGY, direction = true},
	{name ="combat", interval = 2000, chance = 23, minDamage = -500, maxDamage = -730, range = 5, radius = 1, type = COMBAT_DEATHDAMAGE, effect = CONST_ME_MORTAREA, shootEffect = CONST_ANI_SUDDENDEATH, target = true},
	{name ="drunk", interval = 2000, chance = 18, range = 7, radius = 4, effect = CONST_ME_STUN, shootEffect = CONST_ANI_REDSTAR, target = true},
	{name ="combat", interval = 2000, chance = 16, minDamage = -500, maxDamage = -760, length = 6, spread = 0, type = COMBAT_LIFEDRAIN, effect = CONST_ME_BLACKSMOKE, direction = true},
}

monster.defenses = {
	defense = 75,
	armor = 75,
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 190, maxDamage = 360, effect = CONST_ME_HITAREA},
	{name ="invisible", interval = 2000, chance = 11, duration = 8000, effect = CONST_ME_MAGIC_BLUE}
}

monster.loot = {
	{id = 2152, chance = 100000, maxCount = 8},
	{id = 24630, chance = 21887},
	{id = 24631, chance = 21824},
	{id = 5944, chance = 21077},
	{id = 6558, chance = 20517},
	{id = 7591, chance = 19894, maxCount = 2},
	{id = 2145, chance = 15691, maxCount = 3},
	{id = 6500, chance = 14975},
	{id = 7762, chance = 14477, maxCount = 3},
	{id = 2146, chance = 12702, maxCount = 3},
	{id = 2134, chance = 10118},
	{id = 2144, chance = 9776, maxCount = 2},
	{id = 7368, chance = 9278, maxCount = 5},
	{id = 9970, chance = 8250, maxCount = 2},
	{id = 2143, chance = 8188, maxCount = 2},
	{id = 2149, chance = 7846, maxCount = 2},
	{id = 2147, chance = 7597, maxCount = 2},
	{id = 2160, chance = 5853},
	{id = 28415, chance = 4172, maxCount = 3},
	{id = 2185, chance = 3643},
	{id = 3967, chance = 3300},
	{id = 2153, chance = 2553},
	{id = 7404, chance = 2242},
	{id = 2158, chance = 2086},
	{id = 2170, chance = 2055},
	{id = 24637, chance = 1993},
	{id = 9971, chance = 1712},
	{id = 8910, chance = 1152},
	{id = 8889, chance = 996},
	{id = 2656, chance = 965},
	{id = 8902, chance = 965},
	{id = 2124, chance = 934},
	{id = 2154, chance = 747}
}

mType:register(monster)
