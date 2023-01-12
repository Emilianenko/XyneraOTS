local mType = Game.createMonsterType("Energuardian of Tales")
local monster = {}

monster.name = "Energuardian Of Tales"
monster.description = "an energuardian of tales"
monster.experience = 11361
monster.outfit = {
	lookType = 1063,
	lookHead = 86,
	lookBody = 85,
	lookLegs = 82,
	lookFeet = 93,
	lookAddons = 3,
	lookMount = 0
}

monster.health = 14000
monster.maxHealth = 14000
monster.runHealth = 0
monster.race = "blood"
monster.corpse = 31530
monster.speed = 3500
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
	{type = COMBAT_ENERGYDAMAGE, percent = 100},
	{type = COMBAT_EARTHDAMAGE, percent = -12},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -500},
	{name ="combat", interval = 2000, chance = 15, minDamage = -1200, maxDamage = -1600, range = 6, type = COMBAT_ENERGYDAMAGE, effect = CONST_ME_ENERGYAREA, shootEffect = CONST_ANI_ENERGY, target = true},
	{name ="combat", interval = 2000, chance = 20, minDamage = -650, maxDamage = -800, radius = 3, type = COMBAT_ENERGYDAMAGE, effect = CONST_ME_ENERGYAREA},
	{name ="combat", interval = 2000, chance = 24, minDamage = -550, maxDamage = -650, radius = 3, range = 7, type = COMBAT_ENERGYDAMAGE, effect = CONST_ME_ENERGYAREA, shootEffect = CONST_ANI_ENERGYBALL, target = true},
	{name ="combat", interval = 2000, chance = 17, minDamage = -650, maxDamage = -850, length = 6, spread = 0, type = COMBAT_ENERGYDAMAGE, effect = CONST_ME_PURPLEENERGY, direction = true}
}

monster.defenses = {
	defense = 77,
	armor = 77
}

monster.loot = {
	{id = 31225, chance = 58678, maxCount = 6},
	{id = 2150, chance = 55619, maxCount = 10},
	{id = 31226, chance = 20288, maxCount = 4},
	{id = 8473, chance = 13235},
	{id = 8901, chance = 9114},
	{id = 26029, chance = 9003},
	{id = 7895, chance = 7703},
	{id = 7838, chance = 7497, maxCount = 15},
	{id = 8920, chance = 7133},
	{id = 7889, chance = 4105, maxCount = 2},
	{id = 2164, chance = 2441},
	{id = 2171, chance = 2346},
	{id = 18390, chance = 1268},
	{id = 11355, chance = 888},
	{id = 10221, chance = 697}
}

mType:register(monster)
