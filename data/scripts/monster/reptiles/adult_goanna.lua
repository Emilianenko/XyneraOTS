local mType = Game.createMonsterType("adult goanna")
local monster = {}

monster.name = "Adult Goanna"
monster.description = "an adult goanna"
monster.experience = 6650
monster.outfit = {
	lookType = 1195,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 8300
monster.maxHealth = 8300
monster.runHealth = 0
monster.race = "blood"
monster.corpse = 34061
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
	canWalkOnPoison = false
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
	{type = COMBAT_ENERGYDAMAGE, percent = -10},
	{type = COMBAT_EARTHDAMAGE, percent = 75},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -350, condition = {type = CONDITION_POISON, startDamage = 19, interval = 4000}},
	{name ="short poison twave", interval = 2000, chance = 10, minDamage = -250, maxDamage = -380},
	{name ="combat", interval = 2000, chance = 12, type = COMBAT_EARTHDAMAGE, minDamage = -300, maxDamage = -600, range = 5, radius = 1, target = true, shootEffect = CONST_ANI_EARTH, effect = CONST_ME_EXPLOSIONHIT},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -200, maxDamage = -380, radius = 5, target = false, effect = CONST_ME_GROUNDSHAKER}
}

monster.defenses = {
	defense = 84,
	armor = 84,
	{name ="speed", interval = 2000, chance = 5, speed = {min = 500, max = 500}, duration = 5000, effect = CONST_ME_MAGIC_RED}
}

monster.loot = {
	{id = 2152, chance = 100000, maxCount = 3},
	{id = 18437, chance = 55359, maxCount = 8},
	{id = 7850, chance = 14253, maxCount = 30},
	{id = 34216, chance = 11621},
	{id = 2127, chance = 10154},
	{id = 7761, chance = 8951},
	{id = 18413, chance = 8161},
	{id = 2146, chance = 7747, maxCount = 2},
	{id = 34214, chance = 7559},
	{id = 2181, chance = 7409},
	{id = 7903, chance = 6732},
	{id = 18416, chance = 6581},
	{id = 7887, chance = 6093},
	{id = 34217, chance = 4739},
	{id = 2134, chance = 3874},
	{id = 2154, chance = 3761},
	{id = 34144, chance = 3159},
	{id = 2155, chance = 3121},
	{id = 2409, chance = 2670},
	{id = 24849, chance = 2219},
	{id = 24850, chance = 2106, maxCount = 2},
	{id = 10219, chance = 1956},
	{id = 2664, chance = 1692},
	{id = 2150, chance = 1504},
	{id = 33996, chance = 1354},
	{id = 24741, chance = 1241},
	{id = 34101, chance = 1015},
	{id = 2143, chance = 1015},
	{id = 27047, chance = 827},
	{id = 27048, chance = 790}
}

mType:register(monster)
