local mType = Game.createMonsterType("gaffir")
local monster = {}

monster.name = "Gaffir"
monster.description = "Gaffir"
monster.experience = 25000
monster.outfit = {
	lookType = 1217,
	lookHead = 34,
	lookBody = 129,
	lookLegs = 113,
	lookFeet = 19,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 48500
monster.maxHealth = 48500
monster.runHealth = 0
monster.race = "blood"
monster.corpse = 33963
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
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -550},
	{name ="combat", interval = 2000, chance = 8, type = COMBAT_PHYSICALDAMAGE, minDamage = -450, maxDamage = -650, radius = 3, target = false, effect = CONST_ME_GROUNDSHAKER},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = -400, maxDamage = -580, length = 5, spread = 0, effect = CONST_ME_EXPLOSIONHIT},
	{name ="combat", interval = 3000, chance = 14, type = COMBAT_FIREDAMAGE, minDamage = -500, maxDamage = -750, range = 4, shootEffect = CONST_ANI_FIRE},
	{name ="combat", interval = 2000, chance = 16, type = COMBAT_EARTHDAMAGE, minDamage = -500, maxDamage = -620, range = 4, radius = 4, target = true, shootEffect = CONST_ANI_EARTH, effect = CONST_ME_GREEN_RINGS},
	{name ="combat", interval = 3000, chance = 12, type = COMBAT_EARTHDAMAGE, minDamage = -320, maxDamage = -500, radius = 2, target = false, effect = CONST_ME_GREEN_RINGS}
}

monster.defenses = {
	defense = 83,
	armor = 83
}

monster.maxSummons = 1
monster.summons = {
	{name = "Black Cobra", chance = 10, interval = 2000}
}

monster.loot = {
	{id = 9970, chance = 20163},
	{id = 2146, chance = 19619},
	{id = 2145, chance = 17439},
	{id = 2149, chance = 14714},
	{id = 2147, chance = 14169},
	{id = 2150, chance = 13896}
}

mType:register(monster)
