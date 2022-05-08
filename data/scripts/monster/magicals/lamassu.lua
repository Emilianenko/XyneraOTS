local mType = Game.createMonsterType("lamassu")
local monster = {}

monster.name = "Lamassu"
monster.description = "a lamassu"
monster.experience = 9000
monster.outfit = {
	lookType = 1190,
	lookHead = 50,
	lookBody = 2,
	lookLegs = 0,
	lookFeet = 76,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 8700
monster.maxHealth = 8700
monster.runHealth = 0
monster.race = "blood"
monster.corpse = 34050
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
	{type = COMBAT_EARTHDAMAGE, percent = 80},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 80},
	{type = COMBAT_DEATHDAMAGE , percent = -30}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -550},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_HOLYDAMAGE, minDamage = -350, maxDamage = -490, radius = 3, target = false, effect = CONST_ME_HOLYAREA},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -330, maxDamage = -410, range = 5, radius = 3, target = true, shootEffect = CONST_ANI_SMALLEARTH, effect = CONST_ME_SMALLPLANTS}
}

monster.defenses = {
	defense = 82,
	armor = 82
}

monster.loot = {
	{id = 2152, chance = 100000},
	{id = 34098, chance = 13744},
	{id = 2156, chance = 13744, maxCount = 2},
	{id = 18420, chance = 10581},
	{id = 18413, chance = 10466, maxCount = 2},
	{id = 18414, chance = 9603, maxCount = 2},
	{id = 7887, chance = 8108},
	{id = 34097, chance = 7131},
	{id = 7903, chance = 7016},
	{id = 24850, chance = 5290},
	{id = 2149, chance = 5060},
	{id = 24849, chance = 3278},
	{id = 28393, chance = 3220, maxCount = 2},
	{id = 18416, chance = 2818},
	{id = 18421, chance = 2588},
	{id = 2198, chance = 2070},
	{id = 2153, chance = 1955},
	{id = 10219, chance = 1898},
	{id = 2158, chance = 1495},
	{id = 18415, chance = 748}
}

mType:register(monster)
