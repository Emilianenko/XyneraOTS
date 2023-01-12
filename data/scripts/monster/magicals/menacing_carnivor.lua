local mType = Game.createMonsterType("Menacing Carnivor")
local monster = {}

monster.name = "Menacing Carnivor"
monster.description = "a menacing carnivor"
monster.experience = 2112
monster.outfit = {
	lookType = 1138,
	lookHead = 86,
	lookBody = 51,
	lookLegs = 83,
	lookFeet = 91,
	lookAddons = 3,
	lookMount = 0
}

monster.health = 3500
monster.maxHealth = 3500
monster.runHealth = 0
monster.race = "blood"
monster.corpse = 32759
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

monster.reflects = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 22},
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 50},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -20},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
	
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400, condition = {type = CONDITION_POISON, minDamage = -190, maxDamage = -190, interval = 4000}},
	{name ="combat", interval = 2000, chance = 20, minDamage = -0, maxDamage = -280, range = 6, type = COMBAT_PHYSICALDAMAGE, shootEffect = CONST_ANI_WHIRLWINDSWORD, effect = CONST_ME_HITBYPOISON, target = true },
	{name ="combat", interval = 2000, chance = 27, minDamage = -170, maxDamage = -250, length = 7, type = COMBAT_EARTHDAMAGE, effect = CONST_ME_HITBYPOISON, direction = true },
	{name ="combat", interval = 2000, chance = 23, minDamage = -140, maxDamage = -200, range = 6, radius = 3, type = COMBAT_EARTHDAMAGE, shootEffect = CONST_ANI_SNOWBALL, effect = CONST_ME_EXPLOSIONAREA, target = true},
	{name ="combat", interval = 2000, chance = 24, minDamage = -170, maxDamage = -230, radius = 4, type = COMBAT_EARTHDAMAGE, effect = CONST_ME_GROUNDSHAKER}, 
	{name ="MenacingCarnivorTWave", interval = 2000, chance = 22, minDamage = -160, maxDamage = -230}
}

monster.defenses = {
	defense = 68,
	armor = 68
}

monster.loot = {
	{id = 2152, chance = 65806, maxCount = 8},
	{id = 2394, chance = 17419},
	{id = 26029, chance = 9770},
	{id = 32003, chance = 7097},
	{id = 2181, chance = 5253},
	{id = 7449, chance = 4977},
	{id = 2147, chance = 4147},
	{id = 18421, chance = 3318},
	{id = 24849, chance = 2581},
	{id = 7885, chance = 2396},
	{id = 7760, chance = 2028},
	{id = 8922, chance = 1751},
	{id = 2420, chance = 1659},
	{id = 2442, chance = 1567},
	{id = 2477, chance = 1198},
	{id = 27617, chance = 1014},
	{id = 8920, chance = 1014},
	{id = 2459, chance = 922},
	{id = 2191, chance = 922},
	{id = 2409, chance = 829},
	{id = 24850, chance = 645},
	{id = 2188, chance = 553}
}

mType:register(monster)
