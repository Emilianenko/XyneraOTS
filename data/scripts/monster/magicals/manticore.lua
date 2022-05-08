local mType = Game.createMonsterType("manticore")
local monster = {}

monster.name = "Manticore"
monster.description = "a manticore"
monster.experience = 5100
monster.outfit = {
	lookType = 1189,
	lookHead = 116,
	lookBody = 97,
	lookLegs = 113,
	lookFeet = 20,
	lookAddons = 1,
	lookMount = 0
}

monster.health = 6700
monster.maxHealth = 6700
monster.runHealth = 0
monster.race = "blood"
monster.corpse = 34046
monster.speed = 300
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
	interval = 2000,
	chance = 5,
	{text = "I'm spotting my next meal", yell = false}
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
	{type = COMBAT_ICEDAMAGE, percent = -20},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -500},
	{name ="combat", interval = 2000, chance = 13, type = COMBAT_FIREDAMAGE, minDamage = -350, maxDamage = -450, length = 8, spread = 0, effect = CONST_ME_HITBYFIRE},
	{name ="combat", interval = 4000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -300, maxDamage = -400, radius = 3, target = true, shootEffect = CONST_ANI_ENVENOMEDARROW, effect = CONST_ME_GREEN_RINGS},
	{name ="combat", interval = 2000, chance = 22, type = COMBAT_FIREDAMAGE, minDamage = -300, maxDamage = -500, range = 4, shootEffect = CONST_ANI_BURSTARROW}
}

monster.defenses = {
	defense = 78,
	armor = 78
}

monster.loot = {
	{id = 2152, chance = 100000, maxCount = 3},
	{id = 34095, chance = 9280},
	{id = 34096, chance = 7723},
	{id = 2149, chance = 5706},
	{id = 18421, chance = 4957},
	{id = 7840, chance = 4265, maxCount = 9},
	{id = 2153, chance = 2882},
	{id = 7899, chance = 2824},
	{id = 28393, chance = 2824, maxCount = 3},
	{id = 27618, chance = 2594},
	{id = 7891, chance = 2248},
	{id = 2191, chance = 1844},
	{id = 7900, chance = 1787},
	{id = 28415, chance = 1268, maxCount = 3},
	{id = 7894, chance = 1153},
	{id = 8921, chance = 865},
	{id = 18409, chance = 807}
}

mType:register(monster)
