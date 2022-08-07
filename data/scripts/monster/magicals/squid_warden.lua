local mType = Game.createMonsterType("Squid Warden")
local monster = {}

monster.name = "Squid Warden"
monster.description = "a squid warden"
monster.experience = 15300
monster.outfit = {
	lookType = 1059,
	lookHead = 9,
	lookBody = 21,
	lookLegs = 3,
	lookFeet = 57,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 16500
monster.maxHealth = 16500
monster.runHealth = 0
monster.race = "blood"
monster.corpse = 31442
monster.speed = 430
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
	{text = "The blood in your veins shall freeze!", yell = false}
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
	{type = COMBAT_FIREDAMAGE, percent = -15},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 100},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -550},
	{name ="combat", interval = 2000, chance = 22, minDamage = -600, maxDamage = -900, range = 6, type = COMBAT_ICEDAMAGE, effect = CONST_ME_ICEATTACK, shootEffect = CONST_ANI_SNOWBALL, target = true},
	{name ="combat", interval = 2000, chance = 19, minDamage = -600, maxDamage = -850, radius = 3, type = COMBAT_ICEDAMAGE, effect = CONST_ME_ICEAREA},
	{name ="combat", interval = 2000, chance = 17, minDamage = -800, maxDamage = -1100, radius = 2, type = COMBAT_ICEDAMAGE, effect = CONST_ME_ICETORNADO},
	{name ="combat", interval = 2000, chance = 24, minDamage = -400, maxDamage = -580, range = 7, radius = 3, type = COMBAT_ICEDAMAGE, effect = CONST_ME_GROUNDSHAKER, shootEffect = CONST_ANI_SNOWBALL, target = true},
	{name ="combat", interval = 2000, chance = 17, minDamage = -650, maxDamage = -770, length = 5, spread = 0, type = COMBAT_ICEDAMAGE, effect = CONST_ME_SOUND_BLUE, direction = true}
}

monster.defenses = {
	defense = 78,
	armor = 78
}

monster.loot = {
	{id = 2146, chance = 67860, maxCount = 3},
	{id = 2152, chance = 50737, maxCount = 50},
	{id = 31226, chance = 35481, maxCount = 6},
	{id = 10578, chance = 22667},
	{id = 26029, chance = 17305},
	{id = 31224, chance = 16000},
	{id = 8473, chance = 15312},
	{id = 7441, chance = 14007},
	{id = 7902, chance = 7551},
	{id = 2396, chance = 5375},
	{id = 2445, chance = 4856},
	{id = 7449, chance = 4435},
	{id = 23565, chance = 4379},
	{id = 7387, chance = 4056},
	{id = 10580, chance = 3986},
	{id = 7896, chance = 2681},
	{id = 7897, chance = 2330},
	{id = 7437, chance = 870},
	{id = 8878, chance = 716},
	{id = 18412, chance = 702},
	{id = 10220, chance = 295}
}

mType:register(monster)
