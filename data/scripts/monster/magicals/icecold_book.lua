local mType = Game.createMonsterType("Icecold Book")
local monster = {}

monster.name = "Icecold Book"
monster.description = "an icecold book"
monster.experience = 12750
monster.outfit = {
	lookType = 1061,
	lookHead = 87,
	lookBody = 85,
	lookLegs = 79,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 21000
monster.maxHealth = 21000
monster.runHealth = 0
monster.race = "blood"
monster.corpse = 31430
monster.speed = 440
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
	{type = COMBAT_FIREDAMAGE, percent = -10},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 100},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -850},
	{name ="combat", interval = 2000, chance = 30, minDamage = -600, maxDamage = -800, range = 6, type = COMBAT_ICEDAMAGE, effect = CONST_ME_ICEATTACK, shootEffect = CONST_ANI_ICE, target = true},
	{name ="combat", interval = 2000, chance = 25, minDamage = -750, maxDamage = -1300, length = 5, spread = 0, type = COMBAT_ICEDAMAGE, effect = CONST_ME_ICEATTACK, direction = true},
	{name ="combat", interval = 2000, chance = 19, minDamage = -650, maxDamage = -950, radius = 3, type = COMBAT_ICEDAMAGE, effect = CONST_ME_ICETORNADO}
     
}

monster.defenses = {
	defense = 82,
	armor = 82,
	{name ="combat", interval = 2000, chance = 20, minDamage = 200, maxDamage = 350, effect = CONST_ME_MAGIC_BLUE, type = COMBAT_HEALING},
}

monster.loot = {
	{id = 2152, chance = 91092, maxCount = 5},
	{id = 31225, chance = 62213},
	{id = 2145, chance = 46321},
	{id = 2146, chance = 27362, maxCount = 9},
	{id = 26029, chance = 21258},
	{id = 2396, chance = 21115},
	{id = 8473, chance = 18509},
	{id = 31223, chance = 18223},
	{id = 31222, chance = 16925},
	{id = 7902, chance = 13406},
	{id = 10578, chance = 12933},
	{id = 7387, chance = 6324},
	{id = 7896, chance = 4762},
	{id = 7441, chance = 4663},
	{id = 7892, chance = 3288},
	{id = 2445, chance = 2639},
	{id = 7897, chance = 1760},
	{id = 2479, chance = 1661},
	{id = 7437, chance = 1650},
	{id = 8878, chance = 935},
	{id = 18412, chance = 605},
	{id = 10220, chance = 132}
}

mType:register(monster)
