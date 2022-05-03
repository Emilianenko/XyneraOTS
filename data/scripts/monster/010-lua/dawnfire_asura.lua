local mType = Game.createMonsterType("Dawnfire Asura")
local monster = {}

monster.name = "Dawnfire Asura"
monster.description = "a dawnfire asura"
monster.experience = 4100
monster.outfit = {
	lookType = 150,
	lookHead = 114,
	lookBody = 94,
	lookLegs = 78,
	lookFeet = 79,
	lookAddons = 1,
	lookMount = 0
}

monster.health = 2900
monster.maxHealth = 2900
monster.runHealth = 0
monster.race = "blood"
monster.corpse = 24643
monster.speed = 280
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
	{text = "May the flames consume you!", yell = false},
	{text = "Encounter the flames of destiny!", yell = false},
	{text = "Fire and destruction!", yell = false}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "drunk", condition = true},
	{type = "bleed", condition = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = -10},
	{type = COMBAT_ENERGYDAMAGE, percent = -5},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -10},
	{type = COMBAT_HOLYDAMAGE , percent = -10},
	{type = COMBAT_DEATHDAMAGE , percent = 20}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -252},
	{name ="asura soulfire", interval = 2000, chance = 20}, -- fire box
	{name ="combat", interval = 2000, chance = 17, minDamage = 0, maxDamage = -170, range = 5, type = COMBAT_FIREDAMAGE, effect = CONST_ME_FIREATTACK, shootEffect = CONST_ANI_FIRE, target = true}, --flame strike
	{name ="combat", interval = 2000, chance = 18, minDamage = 0, maxDamage = -300, radius = 4, range = 7, type = COMBAT_DEATHDAMAGE, effect = CONST_ME_MORTAREA, shootEffect = CONST_ANI_DEATH, target = true}, --death box
	{name ="asura skill reducer", interval = 2000, chance = 10, range = 7}, -- magic lvl reducer
	{name ="combat", interval = 2000, chance = 16, minDamage = 0, maxDamage = -250, length = 6, spread = 0, type = COMBAT_MANADRAIN, effect = CONST_ME_MAGIC_RED, direction = true}, --manadrain beam
	{name ="speed", interval = 2000, chance = 19, radius = 3, speed = -700, effect = CONST_ME_BLACKSMOKE, duration = 7000} --paralyze
	
}

monster.defenses = {
	defense = 48,
	armor = 48,
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 80, maxDamage = 119}
	
}

monster.loot = {
	{id = 2152, chance = 84178, maxCount = 9},
	{id = 2148, chance = 69692, maxCount = 100},
	{id = 6558, chance = 20951},
	{id = 5944, chance = 14237},
	{id = 24630, chance = 12216},
	{id = 24631, chance = 11191},
	{id = 6500, chance = 10351},
	{id = 7590, chance = 9263, maxCount = 2},
	{id = 2147, chance = 5999, maxCount = 3},
	{id = 2150, chance = 3326, maxCount = 2},
	{id = 2149, chance = 3326, maxCount = 2},
	{id = 2145, chance = 2860, maxCount = 2},
	{id = 9970, chance = 2829, maxCount = 2},
	{id = 5911, chance = 2487},
	{id = 2663, chance = 2331},
	{id = 2187, chance = 1212},
	{id = 2194, chance = 1026},
	{id = 2156, chance = 964},
	{id = 2133, chance = 777},
	{id = 8871, chance = 746},
	{id = 7899, chance = 404},
	{id = 2158, chance = 311},
	{id = 6300, chance = 280},
	{id = 24637, chance = 187},
	{id = 8902, chance = 62}
}

mType:register(monster)
