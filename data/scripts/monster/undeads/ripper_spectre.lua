local mType = Game.createMonsterType("Ripper Spectre")
local monster = {}

monster.name = "Ripper Spectre"
monster.description = "a ripper spectre"
monster.experience = 3500
monster.outfit = {
	lookType = 1122,
	lookHead = 81,
	lookBody = 78,
	lookLegs = 61,
	lookFeet = 94,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 3800
monster.maxHealth = 3800
monster.runHealth = 0
monster.race = "undead"
monster.corpse = 32682
monster.speed = 380
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
	pushable = true,
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
	{type = COMBAT_EARTHDAMAGE, percent = 66},
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 70},
	{type = COMBAT_ENERGYDAMAGE, percent = -10},
	{type = COMBAT_EARTHDAMAGE, percent = 20},
	{type = COMBAT_FIREDAMAGE, percent = -10},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.attacks = {
	-- {name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -350, condition = {type = CONDITION_POISON, minDamage = 210, maxDamage = 210, interval = 4000}},
	-- {name ="combat", interval = 2000, chance = 23, minDamage = -210, maxDamage = -300, radius = 4, type = COMBAT_EARTHDAMAGE, effect = CONST_ME_POISONAREA},
	-- {name ="combat", interval = 2000, chance = 29, minDamage = -150, maxDamage = -300, radius = 4, type = COMBAT_EARTHDAMAGE, effect = CONST_ME_EXPLOSIONAREA},
	-- {name ="RipperSpectreTWave", interval = 2000, chance = 20, minDamage = -80, maxDamage = -200}

}

monster.defenses = {
	defense = 69,
	armor = 69,
	{name ="combat", interval = 2000, chance = 20, minDamage = 140, maxDamage = 180, effect = CONST_ME_MAGIC_BLUE, type = COMBAT_HEALING},
}

monster.loot = {
	{id = 2152, chance = 74540, maxCount = 4},
	{id = 8472, chance = 23295, maxCount = 2},
	{id = 2377, chance = 12818},
	{id = 2181, chance = 6267},
	{id = 2134, chance = 3722},
	{id = 2127, chance = 3655},
	{id = 11309, chance = 3303},
	{id = 8912, chance = 2775},
	{id = 32860, chance = 1800},
	{id = 27047, chance = 1178},
	{id = 2409, chance = 1151},
	{id = 7404, chance = 947},
	{id = 32836, chance = 772},
	{id = 2383, chance = 393},
	{id = 7408, chance = 176}
}

mType:register(monster)
