local mType = Game.createMonsterType("Animated Feather")
local monster = {}

monster.name = "Animated Feather"
monster.description = "an animated feather"
monster.experience = 9860
monster.outfit = {
	lookType = 1058,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 13000
monster.maxHealth = 13000
monster.runHealth = 0
monster.race = "blood"
monster.corpse = 31234
monster.speed = 420
monster.summonCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 10
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
	{type = COMBAT_FIREDAMAGE, percent = -18},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 100},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -600},
	{name ="combat", interval = 2000, chance = 22, minDamage = -600, maxDamage = -800, range = 6, type = COMBAT_ICEDAMAGE, effect = CONST_ME_ICEATTACK, shootEffect = CONST_ANI_ICE, target = true},
	{name ="combat", interval = 2000, chance = 27, minDamage = -500, maxDamage = -850, range = 7, radius = 3, type = COMBAT_ICEDAMAGE, effect = CONST_ME_ICEAREA, shootEffect = CONST_ANI_SNOWBALL, target = true },
	{name ="animatedFeatherWave", interval = 2000, chance = 20, minDamage = -800, maxDamage = -1150},
	{name ="combat", interval = 2000, chance = 15, minDamage = -500, maxDamage = -850, radius = 3, type = COMBAT_ICEDAMAGE, effect = CONST_ME_ICETORNADO}


}

monster.defenses = {
	defense = 79,
	armor = 79
}

monster.loot = {
	{id = 31226, chance = 77954, maxCount = 5},
	{id = 2152, chance = 77430, maxCount = 21},
	{id = 2146, chance = 39742, maxCount = 12},
	{id = 26029, chance = 17360, maxCount = 2},
	{id = 2167, chance = 14017},
	{id = 7441, chance = 13856},
	{id = 31223, chance = 13144},
	{id = 7902, chance = 7237},
	{id = 2145, chance = 4686, maxCount = 12},
	{id = 7387, chance = 4619},
	{id = 2177, chance = 3558},
	{id = 7888, chance = 3088},
	{id = 2445, chance = 2820},
	{id = 2033, chance = 2497},
	{id = 2183, chance = 2336},
	{id = 18412, chance = 953},
	{id = 7437, chance = 846},
	{id = 10220, chance = 470},
	{id = 8878, chance = 161}
}

mType:register(monster)
