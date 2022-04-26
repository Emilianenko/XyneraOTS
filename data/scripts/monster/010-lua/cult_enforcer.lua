local mType = Game.createMonsterType("Cult Enforcer")
local monster = {}

monster.description = "a cult enforcer"
monster.experience = 1000
monster.outfit = {
	lookType = 134,
	lookHead = 114,
	lookBody = 19,
	lookLegs = 76,
	lookFeet = 76,
	lookAddons = 1,
	lookMount = 0
}

monster.health = 1150
monster.maxHealth = 1150
monster.race = "blood"
monster.corpse = 6080
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
	convinceable = true,
	pushable = true,
	illusionable = true,
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
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
	{text = "No one will stop us!", yell = false}
}

monster.loot = {
	{name = "bolt", chance = 90450, maxCount = 10},
	{name = "gold coin", chance = 75410, maxCount = 30},
	{name = "grapes", chance = 15400},
	{name = "great health potion", chance = 12340, maxCount = 2},
	{name = "meat", chance = 5000},
	{name = "crossbow", chance = 830},
	{name = "green tunic", chance = 760},
	{name = "might ring", chance = 700, maxCount = 2},
	{name = "rope", chance = 1000},
	{name = "scarf", chance = 1000},
	{name = "scroll", chance = 830},
	{name = "small diamond", chance = 830},
	{name = "war hammer", chance = 130},
	{name = "halberd", chance = 830},
	{name = "guardian shield", chance = 330},
	{name = "knight legs", chance = 230},
	{name = "warrior helmet", chance = 200}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -250},
	{name ="combat", type = COMBAT_PHYSICALDAMAGE, shootEffect = CONST_ANI_SPEAR, range = 5,  interval = 2000, chance = 30, minDamage = 0, maxDamage = -140, target = true}
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
