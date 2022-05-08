local mType = Game.createMonsterType("cobra assassin")
local monster = {}

monster.name = "Cobra Assassin"
monster.description = "a cobra assassin"
monster.experience = 6980
monster.outfit = {
	lookType = 1217,
	lookHead = 2,
	lookBody = 2,
	lookLegs = 77,
	lookFeet = 19,
	lookAddons = 1,
	lookMount = 0
}

monster.health = 8200
monster.maxHealth = 8200
monster.runHealth = 0
monster.race = "blood"
monster.corpse = 34203
monster.speed = 280
monster.summonCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10
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
	{text = "Hey, maybe you want to strike a deal... no?", yell = false},
	{text = "Stand and deliver! Your money... AND your life actually!", yell = false},
	{text = "You will not leave this place breathing!", yell = false}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "drunk", condition = true},
	{type = "bleed", condition = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 20},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -450},
	{name ="shorter poison twave", interval = 2000, chance = 10, minDamage = -300, maxDamage = -380},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -280, maxDamage = -400, radius = 4, target = false, effect = CONST_ME_EXPLOSIONHIT},
	{name ="combat", interval = 2000, chance = 12, type = COMBAT_PHYSICALDAMAGE, minDamage = -250, maxDamage = -400, length = 5, spread = 0, effect = CONST_ME_BLOCKHIT}
}

monster.defenses = {
	defense = 81,
	armor = 81
}

monster.loot = {
	{id = 2152, chance = 71666, maxCount = 9},
	{id = 24850, chance = 31115, maxCount = 5},
	{id = 2149, chance = 27969, maxCount = 3},
	{id = 2403, chance = 23456},
	{id = 2419, chance = 17438},
	{id = 34334, chance = 16093},
	{id = 2200, chance = 14247},
	{id = 2450, chance = 8913},
	{id = 2442, chance = 7955},
	{id = 18415, chance = 7112},
	{id = 2395, chance = 4946},
	{id = 2420, chance = 4924},
	{id = 9971, chance = 4673},
	{id = 18421, chance = 3032},
	{id = 5944, chance = 2279},
	{id = 18420, chance = 957}
}

mType:register(monster)
