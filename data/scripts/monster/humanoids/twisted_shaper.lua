local mType = Game.createMonsterType("Twisted Shaper")
local monster = {}

monster.name = "Twisted Shaper"
monster.description = "a twisted shaper"
monster.experience = 1750
monster.outfit = {
	lookType = 932,
	lookHead = 105,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 94,
	lookAddons = 1,
	lookMount = 0
}

monster.health = 2500
monster.maxHealth = 2500
monster.runHealth = 0
monster.race = "blood"
monster.corpse = 27724
monster.speed = 280
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
	canWalkOnFire = false,
	canWalkOnPoison = true
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Ti Jezz Kur Tar!", yell = false}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "drunk", condition = true},
	{type = "bleed", condition = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 5},
	{type = COMBAT_ENERGYDAMAGE, percent = -5},
	{type = COMBAT_EARTHDAMAGE, percent = 40},
	{type = COMBAT_FIREDAMAGE, percent = -5},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 30},
	{type = COMBAT_HOLYDAMAGE , percent = 30},
	{type = COMBAT_DEATHDAMAGE , percent = 10}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -120},
	{name ="combat", interval = 2000, chance = 20, minDamage = -5, maxDamage = -75, radius = 4, type = COMBAT_MANADRAIN, effect = CONST_ME_MAGIC_BLUE},
	{name ="TwistedShaperWave", interval = 2000, chance = 16, minDamage = -90, maxDamage = -185},
	{name ="speed", interval = 2000, chance = 15, range = 6, speed = -700, duration = 5000, effect = CONST_ME_ICEATTACK, shootEffect = CONST_ANI_ICE, target = true},
	{name ="combat", interval = 2000, chance = 24, minDamage = -160, maxDamage = -280, range = 5, type = COMBAT_PHYSICALDAMAGE, effect = CONST_ME_PURPLEENERGY, shootEffect = CONST_ANI_ENERGY, target = true},
}

monster.defenses = {
	defense = 35,
	armor = 35,
	{name ="combat", interval = 2000, chance = 20, minDamage = 0, maxDamage = 300, effect = CONST_ME_MAGIC_BLUE, type = COMBAT_HEALING},
}

monster.loot = {
	{id = 2148, chance = 100000, maxCount = 175},
	{id = 2152, chance = 75010, maxCount = 2},
	{id = 27039, chance = 20014, maxCount = 2},
	{id = 27040, chance = 18933},
	{id = 27041, chance = 17574},
	{id = 27043, chance = 14608},
	{id = 2666, chance = 10256},
	{id = 2167, chance = 7651},
	{id = 7591, chance = 7124},
	{id = 27046, chance = 5502},
	{id = 2147, chance = 5461},
	{id = 2789, chance = 5184, maxCount = 3},
	{id = 5022, chance = 5128, maxCount = 5},
	{id = 15649, chance = 5031, maxCount = 4},
	{id = 24849, chance = 4990},
	{id = 2189, chance = 3617},
	{id = 27048, chance = 970},
	{id = 2171, chance = 402},
	{id = 2114, chance = 180},
	{id = 11343, chance = 55}
}

mType:register(monster)
