local mType = Game.createMonsterType("Werelioness")
local monster = {}

monster.description = "a werelioness"
monster.experience = 2500
monster.outfit = {
	lookType = 1301,
	lookHead = 58,
	lookBody = 2,
	lookLegs = 94,
	lookFeet = 94,
	lookAddons = 0,
	lookMount = 0
}


monster.health = 3000
monster.maxHealth = 3000
monster.race = "blood"
monster.corpse = 36841
monster.speed = 210
monster.manaCost = 0
monster.runHealth = 5

monster.changeTarget = {
	interval = 2000,
	chance = 20
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	boss = false,
	convinceable = false,
	pushable = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	healthHidden = false,
	ignoreSpawnBlock = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true
}

monster.light = {
	level = 1,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{name = "Platinum Coin", chance = 100000, maxCount = 5},
	{name = "Gold Coin", chance = 100000, maxCount = 60},
	{name = "Small Enchanted Sapphire", chance = 5000, maxCount = 2},
	{name = "Black Pearl", chance = 5000, maxCount = 2},
	{name = "Ham", chance = 5000, maxCount = 2},
	{name = "Meat", chance = 5000, maxCount = 2},
	{name = "Soul Orb", chance = 5000, maxCount = 2},
	{name = "White Pearl", chance = 1500, maxCount = 2},
	{name = "Ankh", chance = 5000},
	{name = "Crystal Sword", chance = 5000},
	{name = "Serpent Sword", chance = 5000},
	{name = "Rapier", chance = 5000},
	{name = "Lion's Mane", chance = 5000},
	{name = "Lightning Headband", chance = 1500},
	{name = "Steel Helmet", chance = 1500},
	{name = "Doublet", chance = 1500},
	{name = "Ivory Carving", chance = 1500},
	{name = "Magma Legs", chance = 500},
	{name = "Crown Helmet", chance = 500},
	{name = "White Silk Flower", chance = 200},
	{name = "Lion Figurine", chance = 100}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -350},
	{name ="combat", interval = 2000, chance = 17, type = COMBAT_HOLYDAMAGE, minDamage = -300, maxDamage = -350, range = 5, effect = CONST_ME_HOLYAREA, shootEffect = CONST_ANI_SMALLHOLY, target = true},
	{name ="combat", interval = 2000, chance = 100, type = COMBAT_FIREDAMAGE, minDamage = -250, maxDamage = -350, length = 4, spread = 2, effect = CONST_ME_FIREAREA}
}

monster.defenses = {
	defense = 40,
	armor = 40,
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 100, maxDamage = 150, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 40},
	{type = COMBAT_FIREDAMAGE, percent = 35},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 25},
	{type = COMBAT_HOLYDAMAGE , percent = -5},
	{type = COMBAT_DEATHDAMAGE , percent = 50}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
