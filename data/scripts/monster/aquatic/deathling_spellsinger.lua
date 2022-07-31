local mType = Game.createMonsterType("Deathling Spellsinger")
local monster = {}

monster.name = "Deathling Spellsinger"
monster.description = "a deathling spellsinger"
monster.experience = 6400
monster.outfit = {
	lookType = 1088,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 7200
monster.maxHealth = 7200
monster.runHealth = 0
monster.race = "blood"
monster.corpse = 31508
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
	{text = "BOQOL", yell = false},
	{text = "QOL VBOXCL", yell = false}
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
	{name ="combat", interval = 2000, chance = 25, minDamage = -100, maxDamage = -400, range = 6, type = COMBAT_PHYSICALDAMAGE, shootEffect = CONST_ANI_SPEAR, target = true},
	{name ="combat", interval = 2000, chance = 20, minDamage = -400, maxDamage = -700, length = 6, spread = 0, type = COMBAT_HOLYDAMAGE, effect = CONST_ME_HOLYAREA, direction = true},
	{name ="combat", interval = 2000, chance = 25, minDamage = -150, maxDamage = -300, range = 6, type = COMBAT_PHYSICALDAMAGE, effect = CONST_ME_EXPLOSIONAREA, shootEffect = CONST_ANI_LARGEROCK, target = true},
}

monster.defenses = {
	defense = 72,
	armor = 72,
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 180, maxDamage = 290, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.loot = {
	{id = 2152, chance = 85637, maxCount = 14},
	{id = 18304, chance = 25343, maxCount = 25},
	{id = 2149, chance = 13441, maxCount = 14},
	{id = 15488, chance = 13038},
	{id = 15426, chance = 13015},
	{id = 15452, chance = 9560},
	{id = 7591, chance = 8448},
	{id = 15425, chance = 8140},
	{id = 7590, chance = 7880},
	{id = 15649, chance = 5513, maxCount = 25},
	{id = 13870, chance = 4733},
	{id = 13838, chance = 3431},
	{id = 15453, chance = 3195},
	{id = 5895, chance = 3124},
	{id = 15451, chance = 3005},
	{id = 7759, chance = 2224, maxCount = 4},
	{id = 2168, chance = 2177},
	{id = 15403, chance = 284}
}

mType:register(monster)
