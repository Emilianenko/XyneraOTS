local mType = Game.createMonsterType("Energetic Book")
local monster = {}

monster.name = "Energetic Book"
monster.description = "an energetic book"
monster.experience = 12034
monster.outfit = {
	lookType = 1061,
	lookHead = 15,
	lookBody = 91,
	lookLegs = 85,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 18500
monster.maxHealth = 18500
monster.runHealth = 0
monster.race = "blood"
monster.corpse = 31434
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
	{type = COMBAT_EARTHDAMAGE, percent = -10},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 100},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1000},
	{name ="combat", interval = 2000, chance = 30, minDamage = -600, maxDamage = -750, range = 6, type = COMBAT_ENERGYDAMAGE, effect = CONST_ME_ENERGYAREA, shootEffect = CONST_ANI_ENERGY, target = true},
	{name ="combat", interval = 2000, chance = 25, minDamage = -650, maxDamage = -800, length = 5, spread = 0, type = COMBAT_HOLYDAMAGE, effect = CONST_ME_STUN, direction = true},
	{name ="combat", interval = 2000, chance = 18, minDamage = -800, maxDamage = -1000, radius = 3, type = COMBAT_ENERGYDAMAGE, effect = CONST_ME_ENERGYAREA}
}

monster.defenses = {
	defense = 82,
	armor = 82,
	{name ="combat", interval = 2000, chance = 20, minDamage = 210, maxDamage = 330, effect = CONST_ME_MAGIC_BLUE, type = COMBAT_HEALING},
	{name = "speed", chance = 15, interval = 2000, speed = 320, duration = 5000, effect = CONST_ME_MAGIC_RED}
}

monster.loot = {
	{id = 2152, chance = 75436, maxCount = 35},
	{id = 31226, chance = 60117, maxCount = 6},
	{id = 31225, chance = 45164, maxCount = 8},
	{id = 26029, chance = 15343},
	{id = 31222, chance = 12733},
	{id = 8473, chance = 11318},
	{id = 26179, chance = 10965},
	{id = 7901, chance = 3122},
	{id = 7889, chance = 2659},
	{id = 2164, chance = 1732},
	{id = 18390, chance = 1683},
	{id = 7895, chance = 1659},
	{id = 7893, chance = 1512},
	{id = 11355, chance = 878},
	{id = 7407, chance = 610}
}

mType:register(monster)
