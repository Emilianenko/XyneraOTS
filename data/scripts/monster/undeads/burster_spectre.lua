local mType = Game.createMonsterType("Burster Spectre")
local monster = {}

monster.name = "Burster Spectre"
monster.description = "a burster spectre"
monster.experience = 6000
monster.outfit = {
	lookType = 1122,
	lookHead = 9,
	lookBody = 10,
	lookLegs = 86,
	lookFeet = 79,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 6500
monster.maxHealth = 6500
monster.runHealth = 0
monster.race = "undead"
monster.corpse = 32819
monster.speed = 400
monster.summonCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 0
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
	{text = "We came tooo thiiiiss wooorld to... get youuu!", yell = false}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "drunk", condition = true},
	{type = "bleed", condition = false}
}

monster.reflects = {
	{type = COMBAT_ICEDAMAGE, percent = 33},
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 100},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = -20},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 70},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400},
	{name ="combat", interval = 2000, chance = 19, minDamage = -250, maxDamage = -350, range = 6, radius = 3, type = COMBAT_ICEDAMAGE, shootEffect = CONST_ANI_SMALLICE, effect = CONST_ME_ICEATTACK, target = true},
	{name ="combat", interval = 2000, chance = 13, minDamage = -200, maxDamage = -380, length = 5, spread = 2, type = COMBAT_ICEDAMAGE, effect = CONST_ME_ICEATTACK, direction = true},
	{name ="combat", interval = 2000, chance = 17, minDamage = -200, maxDamage = -300, radius = 3, type = COMBAT_PHYSICALDAMAGE, effect = CONST_ME_MAGIC_BLUE},
	{name ="combat", interval = 2000, chance = 22, minDamage = -300, maxDamage = -400, radius = 6, type = COMBAT_LIFEDRAIN, effect = CONST_ME_MAGIC_BLUE},

}

monster.defenses = {
	defense = 70,
	armor = 70,
	{name ="combat", interval = 2000, chance = 15, minDamage = 150, maxDamage = 200, effect = CONST_ME_MAGIC_BLUE, type = COMBAT_HEALING},
}

monster.loot = {
	{id = 2152, chance = 75531, maxCount = 7},
	{id = 8472, chance = 22822, maxCount = 3},
	{id = 2200, chance = 7424},
	{id = 2177, chance = 7105},
	{id = 8922, chance = 3327},
	{id = 2189, chance = 3114},
	{id = 7888, chance = 2163},
	{id = 2197, chance = 2155},
	{id = 32859, chance = 1975},
	{id = 2201, chance = 1664},
	{id = 2171, chance = 1328},
	{id = 2176, chance = 1319},
	{id = 2183, chance = 877},
	{id = 32836, chance = 705},
	{id = 18412, chance = 606},
	{id = 2198, chance = 483},
	{id = 2199, chance = 426},
	{id = 10221, chance = 361},
	{id = 2178, chance = 197},
	{id = 2174, chance = 115}
}

mType:register(monster)
