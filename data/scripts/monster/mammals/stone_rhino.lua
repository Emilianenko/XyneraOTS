local mType = Game.createMonsterType("Stone Rhino")
local monster = {}

monster.name = "Stone Rhino"
monster.description = "a stone rhino"
monster.experience = 1800
monster.outfit = {
	lookType = 936,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 3000
monster.maxHealth = 3000
monster.runHealth = 50
monster.race = "blood"
monster.corpse = 27738
monster.speed = 290
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
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	healthHidden = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "SNIFF!", yell = false}
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
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -420},
	{name ="drunk", interval = 2000, chance = 20, range = 1, effect = CONST_ME_STUN}
}

monster.defenses = {
	defense = 72,
	armor = 72,
	{name ="combat", interval = 2000, chance = 20, minDamage = 0, maxDamage = 195, effect = CONST_ME_MAGIC_BLUE, type = COMBAT_HEALING},
}

monster.loot = {
	{id = 24842, chance = 17625},
	{id = 5925, chance = 10024},
	{id = 27044, chance = 8694},
	{id = 27045, chance = 4608},
	{id = 3973, chance = 1378}
}

mType:register(monster)
