local mType = Game.createMonsterType("Orc Cult Priest")
local monster = {}

monster.name = "Orc Cult Priest"
monster.description = "an orc cult priest"
monster.experience = 1000
monster.outfit = {
	lookType = 6,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 1300
monster.maxHealth = 1300
monster.runHealth = 50
monster.race = "blood"
monster.corpse = 5978
monster.speed = 140
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
	{text = "We will crush all oposition!", yell = false}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "drunk", condition = true},
	{type = "bleed", condition = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 50},
	{type = COMBAT_EARTHDAMAGE, percent = -10},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 10},
	{type = COMBAT_DEATHDAMAGE , percent = -5}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -200},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = 0, maxDamage = -210, range = 5, radius = 1, effect = CONST_ME_ENERGYHIT, shootEffect = CONST_ANI_ENERGYBALL, target = true},
	{name ="combat", interval = 2000, chance = 5, type = COMBAT_FIREDAMAGE, minDamage = 0, maxDamage = -250, range = 5, radius = 1, effect = CONST_ME_FIREATTACK, shootEffect = CONST_ANI_FIRE, target = true},
	{name ="outfit", interval = 4000, chance = 15, target = true, duration = 30000,  outfit = {lookType=2}},
	{name ="outfit", interval = 4000, chance = 10, target = true, duration = 30000,  outfit = {lookType=6}},
	{name ="outfit", interval = 4000, chance = 20, target = true, duration = 30000,  outfit = {lookType=5}}
}

monster.defenses = {
	defense = 27,
	armor = 27
}

monster.loot = {
	{id = 2148, chance = 100000, maxCount = 181},
	{id = 7588, chance = 15954},
	{id = 12434, chance = 14104},
	{id = 2147, chance = 12459, maxCount = 6},
	{id = 5910, chance = 10855},
	{id = 10556, chance = 10526},
	{id = 2194, chance = 9252},
	{id = 12408, chance = 8799},
	{id = 12435, chance = 8553},
	{id = 11113, chance = 5345},
	{id = 2144, chance = 2796, maxCount = 2},
	{id = 26642, chance = 1686},
	{id = 2188, chance = 946},
	{id = 7439, chance = 905}
}

mType:register(monster)
