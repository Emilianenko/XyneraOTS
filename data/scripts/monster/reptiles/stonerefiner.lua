local mType = Game.createMonsterType("Stonerefiner")
local monster = {}

monster.name = "Stonerefiner"
monster.description = "a stonerefiner"
monster.experience = 500
monster.outfit = {
	lookType = 1032,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 800
monster.maxHealth = 800
monster.runHealth = 0
monster.race = "blood"
monster.corpse = 30193
monster.speed = 650
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
	canPushItems = false,
	canPushCreatures = false,
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
	{text = "knak knak knak", yell = false},
	{text = "nomnomnom", yell = false}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = false},
	{type = "drunk", condition = true},
	{type = "bleed", condition = false}
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

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -130},
	{name ="combat", interval = 2000, chance = 25, minDamage = -50, maxDamage = -100, radius = 4, range = 5, type = COMBAT_PHYSICALDAMAGE, effect = CONST_ME_STONES, shootEffect = CONST_ANI_SMALLSTONE, target = true},
	{name ="combat", interval = 2000, chance = 14, minDamage = -60, maxDamage = -90, radius = 3, type = COMBAT_EARTHDAMAGE, effect = CONST_ME_HITAREA},
}

monster.defenses = {
	defense = 20,
	armor = 20
}

monster.loot = {
	{id = 2152, chance = 50783, maxCount = 4},
	{id = 29957, chance = 39831},
	{id = 13757, chance = 29832},
	{id = 9967, chance = 24959},
	{id = 30262, chance = 20115},
	{id = 10557, chance = 19463},
	{id = 20101, chance = 10408}
}

mType:register(monster)
