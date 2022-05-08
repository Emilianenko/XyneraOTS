local mType = Game.createMonsterType("priestess of the wild sun")
local monster = {}

monster.name = "Priestess Of The Wild Sun"
monster.description = "a priestess of the wild sun"
monster.experience = 6400
monster.outfit = {
	lookType = 1199,
	lookHead = 95,
	lookBody = 78,
	lookLegs = 94,
	lookFeet = 3,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 8500
monster.maxHealth = 8500
monster.runHealth = 0
monster.race = "blood"
monster.corpse = 34075
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
	{text = "Fafnar will burn you!", yell = false},
	{text = "Fear the Wild Sun!", yell = false},
	{text = "There is only one true sun!", yell = false}
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
	{type = COMBAT_ENERGYDAMAGE, percent = 85},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 80},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -25},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -350},
	{name ="combat", interval = 2000, chance = 8, type = COMBAT_FIREDAMAGE, minDamage = -300, maxDamage = -500, ring = 2, target = false, effect = CONST_ME_EXPLOSIONHIT},
	{name ="combat", interval = 2000, chance = 14, type = COMBAT_FIREDAMAGE, minDamage = -350, maxDamage = -500, range = 3, radius = 2, target = true, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_EXPLOSIONHIT},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_ENERGYDAMAGE, minDamage = -250, maxDamage = -400, radius = 3, target = false, effect = CONST_ME_ENERGYAREA},
	{name ="combat", interval = 2000, chance = 12, type = COMBAT_ENERGYDAMAGE, minDamage = -250, maxDamage = -350, length = 4, spread = 3, effect = CONST_ME_ENERGYHIT}
}

monster.defenses = {
	defense = 82,
	armor = 82
}

monster.loot = {
	{id = 2152, chance = 100000, maxCount = 3},
	{id = 34099, chance = 8759},
	{id = 34089, chance = 7183},
	{id = 33987, chance = 2927},
	{id = 2454, chance = 2567},
	{id = 2188, chance = 2499},
	{id = 2418, chance = 1801},
	{id = 7383, chance = 1531},
	{id = 18409, chance = 1283},
	{id = 33979, chance = 653},
	{id = 33980, chance = 563}
}

mType:register(monster)
