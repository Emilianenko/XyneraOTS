local mType = Game.createMonsterType("Raxias")
local monster = {}

monster.name = "Raxias"
monster.description = ""
monster.experience = 900
monster.outfit = {
	lookType = 0,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 1100
monster.maxHealth = 1100
monster.runHealth = 0
monster.race = "blood"
monster.corpse = 0
monster.speed = 0
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
	boss = true,
	ignoreSpawnBlock = false,
	pushable = false,
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 4,
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
	{text = "This is a nightmare and you won't wake up!", yell = false},
	{text = "This was your last chance!", yell = false},
	{text = "Blood, fight and rage!", yell = false}
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
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -350}
}

monster.defenses = {
	defense = 5,
	armor = 10,
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 50, maxDamage = 150}
}

monster.loot = {
	{id = 2148, chance = 100000, maxCount = 139},
	{id = 28350, chance = 14286},
	{id = 2760, chance = 14286},
	{id = 28391, chance = 14286, maxCount = 6},
	{id = 2792, chance = 11429, maxCount = 2},
	{id = 27039, chance = 8571, maxCount = 2},
	{id = 28349, chance = 8571},
	{id = 7588, chance = 8571, maxCount = 2},
	{id = 1294, chance = 5714, maxCount = 4},
	{id = 7591, chance = 2857, maxCount = 2},
	{id = 2074, chance = 2857},
	{id = 27618, chance = 2857},
	{id = 7759, chance = 2857},
	{id = 2664, chance = 2857}
}

mType:register(monster)
