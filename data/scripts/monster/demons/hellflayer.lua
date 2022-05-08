local mType = Game.createMonsterType("Hellflayer")
local monster = {}

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
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10
}

monster.strategiesTarget = {
	nearest = 70,
	health = 10,
	damage = 10,
	random = 10,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	boss = false,
	convinceable = false,
	pushable = false,
	illusionable = true,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	healthHidden = false,
	ignoreSpawnBlock = false,
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
	{text = "You should consider bargaining for your life!", yell = false},
	{text = "Your tainted soul belongs to us anyway!", yell = false}
}

monster.loot = {
	{name = "gold coin", chance = 90000, maxCount = 130},
	{name = "platinum coin", chance = 20000, maxCount = 9},
	{name = "flask of demonic blood", chance = 4000, maxCount = 3},
	{name = "gold ingot", chance = 1300, maxCount = 2},
	{name = "great mana potion", chance = 9600, maxCount = 2},
	{name = "great spirit potion", chance = 2300, maxCount = 2},
	{name = "small amethyst", chance = 2000, maxCount = 5},
	{name = "small diamond", chance = 900, maxCount = 5},
	{name = "small emerald", chance = 900, maxCount = 5},
	{name = "small ruby", chance = 2000, maxCount = 5},
	{name = "small topaz", chance = 900, maxCount = 5},
	{name = "ultimate health potion", chance = 5300, maxCount = 2},
	{name = "demonbone amulet", chance = 1000},
	{name = "demonic essence", chance = 1600},
	{id = 7632, chance = 800},
	{name = "green gem", chance = 800},
	{name = "magma boots", chance = 500},
	{name = "magma legs", chance = 1200},
	{name = "mastermind shield", chance = 350},
	{name = "pair of hellflayer horns", chance = 800},
	{name = "red gem", chance = 500},
	{name = "rift bow", chance = 280},
	{name = "rift crossbow", chance = 180},
	{name = "skull helmet", chance = 450},
	{name = "rift lance", chance = 200},
	{name = "titan axe", chance = 900},
	{name = "golden armor", chance = 750},
	{name = "spellbook of mind control", chance = 900},
	{name = "heavy mace", chance = 400}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 85, attack = 165},
	{name ="combat", interval = 2000, chance = 11, minDamage = -800, maxDamage = -1250, length = 3, spread = 0, type = COMBAT_DEATHDAMAGE, effect = CONST_ME_MORTAREA, direction = true},
	{name ="combat", interval = 2000, chance = 14, minDamage = -460, maxDamage = -630, type = COMBAT_FIREDAMAGE, shootEffect = CONST_ANI_FLAMMINGARROW, target = true},
	{name ="combat", interval = 2000, chance = 18, minDamage = -380, maxDamage = -520, radius = 4, type = COMBAT_FIREDAMAGE, effect = CONST_ME_EXPLOSIONHIT, shootEffect = CONST_ANI_EXPLOSION, target = true},
	{name ="combat", interval = 2000, chance = 22, minDamage = -260, maxDamage = -450, radius = 3, type = COMBAT_PHYSICALDAMAGE, effect = CONST_ME_GROUNDSHAKER},
}

monster.defenses = {
	defense = 20,
	armor = 55,
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 300, maxDamage = 580, effect = CONST_ME_MAGIC_BLUE}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = -10},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 100},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 100}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
