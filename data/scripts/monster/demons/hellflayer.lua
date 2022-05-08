local mType = Game.createMonsterType("Hellflayer")
local monster = {}

monster.name = "Hellflayer"
monster.description = "a hellflayer"
monster.experience = 11000
monster.outfit = {
	lookType = 856,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 14000
monster.maxHealth = 14000
monster.runHealth = 0
monster.race = "blood"
monster.corpse = 25443
monster.speed = 330
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
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	healthHidden = false,
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = true
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Your tainted soul belongs to us anyway!", yell = false},
	{text = "You should consider bargaining for your life!", yell = false}
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
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -850},
	{name ="combat", interval = 2000, chance = 11, minDamage = -800, maxDamage = -1250, length = 3, spread = 0, type = COMBAT_DEATHDAMAGE, effect = CONST_ME_MORTAREA, direction = true},
	{name ="combat", interval = 2000, chance = 14, minDamage = -460, maxDamage = -630, type = COMBAT_FIREDAMAGE, shootEffect = CONST_ANI_FLAMMINGARROW, target = true},
	{name ="combat", interval = 2000, chance = 18, minDamage = -380, maxDamage = -520, radius = 4, type = COMBAT_FIREDAMAGE, effect = CONST_ME_EXPLOSIONHIT, shootEffect = CONST_ANI_EXPLOSION, target = true},
	{name ="combat", interval = 2000, chance = 22, minDamage = -260, maxDamage = -450, radius = 3, type = COMBAT_PHYSICALDAMAGE, effect = CONST_ME_GROUNDSHAKER}
}

monster.defenses = {
	defense = 55,
	armor = 55,
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 300, maxDamage = 580, effect = CONST_ME_MAGIC_BLUE}
}

monster.loot = {
	{id = 2148, chance = 90342, maxCount = 198},
	{id = 2152, chance = 89201, maxCount = 12},
	{id = 6558, chance = 21458},
	{id = 6500, chance = 17924},
	{id = 7590, chance = 14612, maxCount = 5},
	{id = 25385, chance = 14194},
	{id = 8472, chance = 13526, maxCount = 5},
	{id = 8473, chance = 12274, maxCount = 5},
	{id = 2147, chance = 7348, maxCount = 5},
	{id = 9970, chance = 7264, maxCount = 5},
	{id = 2145, chance = 7014, maxCount = 5},
	{id = 2150, chance = 6707, maxCount = 5},
	{id = 2149, chance = 6652, maxCount = 5},
	{id = 9971, chance = 6067, maxCount = 2},
	{id = 7632, chance = 3813},
	{id = 2156, chance = 2004},
	{id = 2153, chance = 1252},
	{id = 25383, chance = 891},
	{id = 2155, chance = 863},
	{id = 7894, chance = 835},
	{id = 7891, chance = 751},
	{id = 7413, chance = 668},
	{id = 2466, chance = 529},
	{id = 25522, chance = 445},
	{id = 25523, chance = 417},
	{id = 2514, chance = 306},
	{id = 5741, chance = 278},
	{id = 2472, chance = 250},
	{id = 2136, chance = 195},
	{id = 25382, chance = 195},
	{id = 8902, chance = 83},
	{id = 2452, chance = 28}
}

mType:register(monster)
