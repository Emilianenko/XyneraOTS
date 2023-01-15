local mType = Game.createMonsterType("Crazed Summer Rearguard")
local monster = {}

monster.name = "Crazed Summer Rearguard"
monster.description = "a crazed summer rearguard"
monster.experience = 4700
monster.outfit = {
	lookType = 1136,
	lookHead = 114,
	lookBody = 94,
	lookLegs = 3,
	lookFeet = 121,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 5300
monster.maxHealth = 5300
monster.runHealth = 0
monster.race = "blood"
monster.corpse = 32737
monster.speed = 400
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
	{text = "Is this real life?", yell = false},
	{text = "Weeeuuu weeeuuu!!!", yell = false}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "drunk", condition = true},
	{type = "bleed", condition = false}
}

monster.reflects = {
	{type = COMBAT_FIREDAMAGE, percent = 31},
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = -10},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 40},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -25},
	{type = COMBAT_HOLYDAMAGE , percent = 20},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -450},
	{name ="combat", interval = 2000, chance = 23, minDamage = -220, maxDamage = -300, range = 6, type = COMBAT_FIREDAMAGE, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREATTACK, target = true},
	{name ="combat", interval = 2000, chance = 19, minDamage = -220, maxDamage = -300, range = 6, radius = 3, type = COMBAT_FIREDAMAGE, shootEffect = CONST_ANI_FLAMMINGARROW, effect = CONST_ME_EXPLOSIONHIT, target = true}
}

monster.defenses = {
	defense = 76,
	armor = 76
}

monster.loot = {
	{id = 2152, chance = 84762, maxCount = 11},
	{id = 5921, chance = 10361},
	{id = 32661, chance = 8154},
	{id = 10552, chance = 7238},
	{id = 7760, chance = 5969},
	{id = 18420, chance = 4601},
	{id = 18414, chance = 4579},
	{id = 28391, chance = 4127, maxCount = 8},
	{id = "ring of blue plasma", chance = 2571},
	{id = 2664, chance = 1313},
	{id = 2154, chance = 1070},
	{id = "collar of blue plasma", chance = 938},
	{id = 32651, chance = 850},
	{id = 7759, chance = 761, maxCount = 2},
	{id = 2145, chance = 574},
	{id = 18453, chance = 474}
}

mType:register(monster)
