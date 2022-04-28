local mType = Game.createMonsterType("Cult Scholar")
local monster = {}

monster.description = "a cult scholar"
monster.experience = 1100
monster.outfit = {
	lookType = 145,
	lookHead = 0,
	lookBody = 77,
	lookLegs = 21,
	lookFeet = 21,
	lookAddons = 1,
	lookMount = 0
}


monster.health = 1650
monster.maxHealth = 1650
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
	{text = "The Secrets are ours alone!", yell = false}
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
	{name ="combat", interval = 2000, type = COMBAT_PHYSICALDAMAGE, effect = CONST_ME_MORTAREA, shootEffect = CONST_ANI_DEATH,  chance = 24, minDamage = -80, maxDamage = -200, target = TRUE},
    {name = "combat", type = COMBAT_POISONDAMAGE, interval = 2000, chance = 19, minDamage = -100, maxDamage = -230, length = 5, spread = 0, effect = CONST_ME_POISONAREA}
} 
monster.defenses = {
	defense = 50,
	armor = 35,
	{name ="combat", interval = 4000, chance = 25, type = COMBAT_HEALING, minDamage = 20, maxDamage = 80, effect = CONST_ME_MAGIC_BLUE, target = false}
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

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
