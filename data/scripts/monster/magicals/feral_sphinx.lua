local mType = Game.createMonsterType("feral sphinx")
local monster = {}

monster.name = "Feral Sphinx"
monster.description = "a feral sphinx"
monster.experience = 8800
monster.outfit = {
	lookType = 1188,
	lookHead = 76,
	lookBody = 75,
	lookLegs = 57,
	lookFeet = 0,
	lookAddons = 2,
	lookMount = 0
}

monster.health = 9800
monster.maxHealth = 9800
monster.runHealth = 0
monster.race = "blood"
monster.corpse = 34314
monster.speed = 320
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
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 2000,
	chance = 5,
	{text = "I am not as kind as my sisters!", yell = false}
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
	{type = COMBAT_FIREDAMAGE, percent = 80},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -15},
	{type = COMBAT_HOLYDAMAGE , percent = 80},
	{type = COMBAT_DEATHDAMAGE , percent = -15}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -450},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -350, maxDamage = -500, length = 1, spread = 2, effect = CONST_ME_FIREAREA},
	{name ="combat", interval = 2000, chance = 12, type = COMBAT_ENERGYDAMAGE, minDamage = -300, maxDamage = -500, radius = 4, target = false, effect = CONST_ME_ENERGYAREA},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -350, maxDamage = -550, range = 1, shootEffect = CONST_ANI_FIRE},
	{name ="combat", interval = 2000, chance = 8, type = COMBAT_HOLYDAMAGE, minDamage = -400, maxDamage = -580, length = 6, spread = 0, effect = CONST_ME_HOLYAREA}
}

monster.defenses = {
	defense = 90,
	armor = 90,
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 200, maxDamage = 425, effect = CONST_ME_MAGIC_BLUE}
}

monster.loot = {
	{id = 2152, chance = 100000, maxCount = 3},
	{id = 18419, chance = 8064},
	{id = 2156, chance = 7692},
	{id = 2201, chance = 7427},
	{id = 7890, chance = 6844},
	{id = 18415, chance = 5942},
	{id = 34093, chance = 5570},
	{id = 2187, chance = 5464},
	{id = 34094, chance = 4775},
	{id = 2146, chance = 4615, maxCount = 2},
	{id = 8921, chance = 4191},
	{id = 2432, chance = 3448},
	{id = 2158, chance = 3395},
	{id = 7891, chance = 2069},
	{id = 7900, chance = 1538},
	{id = 7894, chance = 1432},
	{id = 7761, chance = 1273, maxCount = 2},
	{id = 2155, chance = 743}
}

mType:register(monster)
