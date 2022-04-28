local mType = Game.createMonsterType("Cult Believer")
local monster = {}

monster.description = "a cult believer"
monster.experience = 850
monster.outfit = {
	lookType = 132,
	lookHead = 98,
	lookBody = 77,
	lookLegs = 39,
	lookFeet = 57,
	lookAddons = 1,
	lookMount = 0
}

monster.health = 975
monster.maxHealth = 975
monster.race = "blood"
monster.corpse = 22017
monster.speed = 260
monster.manaCost = 390

monster.changeTarget = {
	interval = 4000,
	chance = 20
}

monster.strategiesTarget = {
	nearest = 70,
	health = 10,
	damage = 10,
	random = 10,
}

monster.flags = {
	summonable = true,
	attackable = true,
	hostile = true,
	boss = false,
	convinceable = true,
	pushable = true,
	illusionable = true,
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	healthHidden = false,
	ignoreSpawnBlock = false,
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
	{text = "Death to the unbelievers!", yell = false}
}

monster.loot = {
	{id = "bolt", chance = 90450, maxCount = 10},
	{id = "gold coin", chance = 75410, maxCount = 30},
	{id = "grapes", chance = 15400},
	{id = "great health potion", chance = 12340, maxCount = 2},
	{id = "meat", chance = 5000},
	{id = "crossbow", chance = 830},
	{id = "green tunic", chance = 760},
	{id = "might ring", chance = 700, maxCount = 2},
	{id = "rope", chance = 1000},
	{id = "scarf", chance = 1000},
	{id = "scroll", chance = 830},
	{id = "small diamond", chance = 830},
	{id = "war hammer", chance = 130},
	{id = "halberd", chance = 830},
	{id = "guardian shield", chance = 330},
	{id = "knight legs", chance = 230},
	{id = "warrior helmet", chance = 200}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -220}
}

monster.defenses = {
	defense = 50,
	armor = 35,
	{name ="combat", interval = 4000, chance = 25, type = COMBAT_HEALING, minDamage = 150, maxDamage = 200, effect = CONST_ME_MAGIC_BLUE, target = false}
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
	{type = COMBAT_HOLYDAMAGE , percent = -20},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
