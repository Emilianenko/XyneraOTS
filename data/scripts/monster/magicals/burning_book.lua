local mType = Game.createMonsterType("Burning Book")
local monster = {}

monster.name = "Burning Book"
monster.description = "a burning book"
monster.experience = 11934
monster.outfit = {
	lookType = 1061,
	lookHead = 79,
	lookBody = 113,
	lookLegs = 78,
	lookFeet = 112,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 18000
monster.maxHealth = 18000
monster.runHealth = 0
monster.race = "blood"
monster.corpse = 31410
monster.speed = 440
monster.summonCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 10
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
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -10},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -700},
	{name ="combat", interval = 2000, chance = 30, minDamage = -800, maxDamage = -1100, range = 6, type = COMBAT_FIREDAMAGE, effect = CONST_ME_HITBYFIRE, shootEffect = CONST_ANI_FLAMMINGARROW, target = true},
	{name ="combat", interval = 2000, chance = 25, minDamage = -700, maxDamage = -950, length = 5, spread = 0, type = COMBAT_FIREDAMAGE, effect = CONST_ME_MAGIC_RED, direction = true},
	{name ="combat", interval = 2000, chance = 18, minDamage = -750, maxDamage = -950, radius = 3, type = COMBAT_FIREDAMAGE, effect = CONST_ME_EXPLOSIONAREA},
}

monster.defenses = {
	defense = 82,
	armor = 82,
	{name ="combat", interval = 2000, chance = 20, minDamage = 220, maxDamage = 350, effect = CONST_ME_MAGIC_BLUE, type = COMBAT_HEALING},
	{name = "speed", chance = 15, interval = 2000, speed = 320, duration = 5000, effect = CONST_ME_MAGIC_RED}
}

monster.loot = {
	{id = 2152, chance = 60929, maxCount = 35},
	{id = 31225, chance = 49249, maxCount = 4},
	{id = 6558, chance = 42251},
	{id = 31222, chance = 19291},
	{id = 6500, chance = 18891},
	{id = 7899, chance = 11617},
	{id = 2515, chance = 8525},
	{id = 2150, chance = 5608, maxCount = 7},
	{id = 5944, chance = 5208},
	{id = 2419, chance = 4557},
	{id = 2185, chance = 3868},
	{id = 6300, chance = 2429},
	{id = 7900, chance = 1415},
	{id = 2165, chance = 714},
	{id = 7451, chance = 351}
}

mType:register(monster)
