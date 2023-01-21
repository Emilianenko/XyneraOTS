local mType = Game.createMonsterType("Insane Siren")
local monster = {}

monster.name = "Insane Siren"
monster.description = "an insane siren"
monster.experience = 6000
monster.outfit = {
	lookType = 1136,
	lookHead = 72,
	lookBody = 94,
	lookLegs = 79,
	lookFeet = 4,
	lookAddons = 3,
	lookMount = 0
}

monster.health = 6500
monster.maxHealth = 6500
monster.runHealth = 0
monster.race = "blood"
monster.corpse = 32789
monster.speed = 420
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
	{text = "Dream or nightmare?", yell = false}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "drunk", condition = true},
	{type = "bleed", condition = false}
}

monster.reflects = {
	{type = COMBAT_FIREDAMAGE, percent = 33},
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = -10},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 55},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -20},
	{type = COMBAT_HOLYDAMAGE , percent = 25},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -500},
	{name ="Crazed Summer Vanguard Chain", interval = 2000, chance = 18},
	{name ="combat", interval = 2000, chance = 22, minDamage = -100, maxDamage = -200, range = 6, type = COMBAT_FIREDAMAGE, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREATTACK, target = true},
	{name ="combat", interval = 2000, chance = 16, minDamage = -140, maxDamage = -230, length = 4, spread = 0, type = COMBAT_FIREDAMAGE, effect = CONST_ME_FIREATTACK, direction = true},
	{name ="combat", interval = 2000, chance = 14, minDamage = -250, maxDamage = -400, radius = 3, type = COMBAT_FIREDAMAGE, effect = CONST_ME_FIREAREA},
	{name ="combat", interval = 2000, chance = 16, minDamage = -100, maxDamage = -300, range = 6, radius = 3, type = COMBAT_FIREDAMAGE, shootEffect = CONST_ANI_BURSTARROW, effect = CONST_ME_EXPLOSIONHIT, target = true},
	{name ="combat", interval = 2000, chance = 14, minDamage = -100, maxDamage = -300, radius = 4, type = COMBAT_FIREDAMAGE, effect = CONST_ME_EXPLOSIONHIT}

}

monster.defenses = {
	defense = 76,
	armor = 76
}

monster.loot = {
	{id = 2152, chance = 70660, maxCount = 12},
	{id = 12430, chance = 12674},
	{id = 8473, chance = 12153},
	{id = 32661, chance = 9375},
	{id = 8921, chance = 4514, maxCount = 2},
	{id = 2191, chance = 3125},
	{id = 2432, chance = 2951},
	{id = 2187, chance = 2951},
	{id = 7890, chance = 2778},
	{id = 5922, chance = 2257},
	{id = 7899, chance = 2257},
	{id = 32651, chance = 2257, maxCount = 2},
	{id = 7894, chance = 694},
	{id = 7900, chance = 347}
}

mType:register(monster)
