local mType = Game.createMonsterType("Soul-Broken Harbinger")
local monster = {}

monster.name = "Soul-Broken Harbinger"
monster.description = "a soul-broken harbinger"
monster.experience = 5800
monster.outfit = {
	lookType = 1137,
	lookHead = 85,
	lookBody = 10,
	lookLegs = 16,
	lookFeet = 83,
	lookAddons = 3,
	lookMount = 0
}

monster.health = 6300
monster.maxHealth = 6300
monster.runHealth = 0
monster.race = "blood"
monster.corpse = 32790
monster.speed = 420
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
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "drunk", condition = true},
	{type = "bleed", condition = false}
}

monster.reflects = {
	{type = COMBAT_ICEDAMAGE, percent = 31},
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = -5},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = -30},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 55},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 20}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -550},
	{name ="Crazed Winter Vanguard Chain", interval = 2000, chance = 20},
	{name ="combat", interval = 2000, chance = 17, minDamage = -50, maxDamage = -350, range = 6, type = COMBAT_ICEDAMAGE, shootEffect = CONST_ANI_SNOWBALL, effect = CONST_ME_ICEATTACK, target = true},
	{name ="combat", interval = 2000, chance = 19, minDamage = -100, maxDamage = -300, radius = 3, type = COMBAT_ICEDAMAGE, effect = CONST_ME_ICETORNADO},
	{name ="combat", interval = 2000, chance = 25, minDamage = -100, maxDamage = -300, range = 6, radius = 3, type = COMBAT_ICEDAMAGE, shootEffect = CONST_ANI_SMALLICE, effect = CONST_ME_ICEATTACK, target = true},
	{name ="combat", interval = 2000, chance = 13, minDamage = -200, maxDamage = -300, radius = 4, type = COMBAT_ICEDAMAGE, effect = CONST_ME_ICEAREA},
	{name ="combat", interval = 2000, chance = 15, minDamage = -120, maxDamage = -200, length = 3, type = COMBAT_ICEDAMAGE, effect = CONST_ME_GIANTICE, direction = true},
}

monster.defenses = {
	defense = 76,
	armor = 76
}

monster.loot = {
	{id = 2152, chance = 100000, maxCount = 12},
	{id = 32714, chance = 15206, maxCount = 3},
	{id = 32661, chance = 12716},
	{id = 10552, chance = 9483},
	{id = 2396, chance = 4843},
	{id = 7896, chance = 3274},
	{id = 7892, chance = 3111},
	{id = "ring of blue plasma", chance = 2611},
	{id = 2477, chance = 2394},
	{id = 2528, chance = 1799},
	{id = 2664, chance = 1366},
	{id = 2519, chance = 1272},
	{id = 8902, chance = 1136},
	{id = 26199, chance = 1015}
}

mType:register(monster)
