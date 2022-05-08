local mType = Game.createMonsterType("duke krule")
local monster = {}

monster.name = "Duke Krule"
monster.description = "Duke Krule"
monster.experience = 55000
monster.outfit = {
	lookType = 1221,
	lookHead = 19,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 3,
	lookMount = 0
}

monster.health = 290000
monster.maxHealth = 290000
monster.runHealth = 0
monster.race = "venom"
monster.corpse = 34255
monster.speed = 250
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
	targetDistance = 4,
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
	{type = COMBAT_FIREDAMAGE, percent = 20},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -600},
	{name ="combat", interval = 1800, chance = 60, type = COMBAT_MANADRAIN, minDamage = -400, maxDamage = -1000, length = 7, spread = 2, effect = CONST_ME_EXPLOSIONHIT},
	{name ="combat", interval = 1800, chance = 19, type = COMBAT_PHYSICALDAMAGE, minDamage = -400, maxDamage = -1000, length = 7, spread = 0, effect = CONST_ME_BLOCKHIT},
	{name ="combat", interval = 1800, chance = 40, type = COMBAT_FIREDAMAGE, minDamage = -300, maxDamage = -500, radius = 10, target = false, effect = CONST_ME_HITBYFIRE}
}

monster.defenses = {
	defense = 25,
	armor = 78,
	{name ="combat", interval = 2000, chance = 14, type = COMBAT_HEALING, minDamage = 150, maxDamage = 350, effect = CONST_ME_MAGIC_BLUE}
}

monster.maxSummons = 3
monster.summons = {
	{name = "Soul Scourge", chance = 20, interval = 2000}
}

monster.loot = {
	{id = 2158, chance = 100000, maxCount = 2},
	{id = 7443, chance = 100000, maxCount = 11},
	{id = 2152, chance = 100000, maxCount = 8},
	{id = 26189, chance = 100000},
	{id = 25172, chance = 100000, maxCount = 3},
	{id = 26031, chance = 100000, maxCount = 2},
	{id = 26030, chance = 100000, maxCount = 4}
}

mType:register(monster)
