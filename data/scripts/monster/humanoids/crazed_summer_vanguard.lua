local mType = Game.createMonsterType("Crazed Summer Vanguard")
local monster = {}

monster.name = "Crazed Summer Vanguard"
monster.description = "a crazed summer vanguard"
monster.experience = 5000
monster.outfit = {
	lookType = 1137,
	lookHead = 114,
	lookBody = 93,
	lookLegs = 3,
	lookFeet = 83,
	lookAddons = 1,
	lookMount = 0
}

monster.health = 5500
monster.maxHealth = 5500
monster.runHealth = 0
monster.race = "blood"
monster.corpse = 32733
monster.speed = 390
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
	{text = "I see colours, all colours! Or are these just illusions?", yell = false},
	{text = "La di da di doo!!", yell = false}
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
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 50},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -30},
	{type = COMBAT_HOLYDAMAGE , percent = 20},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -450},
	{name ="Crazed Summer Vanguard Chain", interval = 2000, chance = 20},
	{name ="combat", interval = 2000, chance = 16, minDamage = -230, maxDamage = -280, length = 6, type = COMBAT_FIREDAMAGE, effect = CONST_ME_FIREAREA, direction = true},
	{name ="combat", interval = 2000, chance = 24, minDamage = -200, maxDamage = -300, radius = 3, type = COMBAT_FIREDAMAGE, effect = CONST_ME_EXPLOSIONHIT},
	{name ="combat", interval = 2000, chance = 19, minDamage = -200, maxDamage = -280, radius = 4, type = COMBAT_FIREDAMAGE, effect = CONST_ME_EXPLOSIONAREA}

}

monster.defenses = {
	defense = 77,
	armor = 77
}

monster.loot = {
	{id = 2152, chance = 85363, maxCount = 13},
	{id = 12421, chance = 29249},
	{id = 8872, chance = 9263},
	{id = 32661, chance = 8899},
	{id = 7732, chance = 8437},
	{id = 2377, chance = 7610},
	{id = 2201, chance = 7221},
	{id = 2419, chance = 6868},
	{id = 2403, chance = 6589},
	{id = 7890, chance = 5373},
	{id = 2191, chance = 4741},
	{id = 8921, chance = 4692},
	{id = 7891, chance = 2857},
	{id = 32651, chance = 924},
	{id = 7443, chance = 292}
}

mType:register(monster)
