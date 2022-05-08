local mType = Game.createMonsterType("Midnight Asura")
local monster = {}

monster.name = "Midnight Asura"
monster.description = "a midnight asura"
monster.experience = 4100
monster.outfit = {
	lookType = 150,
	lookHead = 0,
	lookBody = 114,
	lookLegs = 90,
	lookFeet = 90,
	lookAddons = 1,
	lookMount = 0
}

monster.health = 3100
monster.maxHealth = 3100
monster.runHealth = 0
monster.race = "blood"
monster.corpse = 24644
monster.speed = 240
monster.summonCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 0
}

monster.flags = {
	attackable = true,
	hostile = true,
	summonable = false,
	convinceable = false,
	illusionable = false,
	boss = false,
	ignoreSpawnBlock = true,
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
	{text = "Death and Darkness!", yell = false},
	{text = "Embrace the night!", yell = false},
	{text = "May night fall upon you!", yell = false}
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
	{type = COMBAT_ENERGYDAMAGE, percent = -10},
	{type = COMBAT_EARTHDAMAGE, percent = -10},
	{type = COMBAT_FIREDAMAGE, percent = 10},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 10},
	{type = COMBAT_HOLYDAMAGE , percent = 30},
	{type = COMBAT_DEATHDAMAGE , percent = 100}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -387},
	{name ="combat", interval = 2000, chance = 18, minDamage = -30, maxDamage = -150, length = 4, spread = 0, type = COMBAT_MANADRAIN, effect = CONST_ME_PURPLEENERGY, direction = true},
	{name ="combat", interval = 2000, chance = 20, minDamage = -40, maxDamage = -230, range = 5, radius = 1, type = COMBAT_DEATHDAMAGE, effect = CONST_ME_MORTAREA, shootEffect = CONST_ANI_SUDDENDEATH, target = true},
	{name ="drunk", interval = 2000, chance = 14, range = 7, radius = 4, effect = CONST_ME_STUN, shootEffect = CONST_ANI_REDSTAR, target = true},
	{name ="combat", interval = 2000, chance = 16, minDamage = -50, maxDamage = -240, length = 8, spread = 0, type = COMBAT_LIFEDRAIN, effect = CONST_ME_BLACKSMOKE, direction = true},
	

}

monster.defenses = {
	defense = 55,
	armor = 55,
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 120, maxDamage = 170, effect = CONST_ME_HITAREA},
	{name ="invisible", interval = 2000, chance = 8, duration = 8000, effect = CONST_ME_MAGIC_BLUE}
}

monster.loot = {
	{id = 2152, chance = 80334, maxCount = 6},
	{id = 2148, chance = 70751, maxCount = 100},
	{id = 6558, chance = 14791},
	{id = 5944, chance = 13689},
	{id = 24630, chance = 12788},
	{id = 6500, chance = 10618},
	{id = 24631, chance = 10050},
	{id = 7591, chance = 8114, maxCount = 2},
	{id = 2145, chance = 6377, maxCount = 3},
	{id = 7368, chance = 6043, maxCount = 5},
	{id = 2143, chance = 5910, maxCount = 2},
	{id = 2146, chance = 5242, maxCount = 3},
	{id = 2134, chance = 3940},
	{id = 2144, chance = 3806, maxCount = 2},
	{id = 2147, chance = 3706, maxCount = 2},
	{id = 2149, chance = 3038, maxCount = 2},
	{id = 9970, chance = 2805, maxCount = 2},
	{id = 2185, chance = 2504},
	{id = 3967, chance = 2037},
	{id = 2154, chance = 1035},
	{id = 2170, chance = 935},
	{id = 8910, chance = 601},
	{id = 2124, chance = 501},
	{id = 2656, chance = 434},
	{id = 24637, chance = 401},
	{id = 2158, chance = 367},
	{id = 7404, chance = 234},
	{id = 9971, chance = 200},
	{id = 8889, chance = 167},
	{id = 8902, chance = 134}
}

mType:register(monster)
