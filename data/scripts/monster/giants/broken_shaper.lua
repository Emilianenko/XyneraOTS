local mType = Game.createMonsterType("Broken Shaper")
local monster = {}

monster.name = "Broken Shaper"
monster.description = "a broken shaper"
monster.experience = 1600
monster.outfit = {
	lookType = 932,
	lookHead = 94,
	lookBody = 76,
	lookLegs = 0,
	lookFeet = 82,
	lookAddons = 1,
	lookMount = 0
}

monster.health = 2200
monster.maxHealth = 2200
monster.runHealth = 0
monster.race = "blood"
monster.corpse = 27724
monster.speed = 310
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
	canWalkOnFire = false,
	canWalkOnPoison = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "<grunt>", yell = false},
	{text = "Raar!!", yell = false}
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
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -240},
	{name ="BrokenShaperWave", interval = 2000, chance = 20, minDamage = 0, maxDamage = -240},
	{name ="combat", interval = 2000, chance = 26, minDamage = 0, maxDamage = -80, range = 6, type = COMBAT_PHYSICALDAMAGE, shootEffect = CONST_ANI_SMALLSTONE, target = true},
}

monster.defenses = {
	defense = 37,
	armor = 37,
	{name ="combat", interval = 2000, chance = 20, minDamage = 0, maxDamage = 220, effect = CONST_ME_MAGIC_BLUE, type = COMBAT_HEALING},
	{name = "speed", chance = 10, interval = 2000, speed = 300, duration = 7000, effect = CONST_ME_MAGIC_RED}
}

monster.loot = {
	{id = 2148, chance = 100000, maxCount = 173},
	{id = 2152, chance = 75194, maxCount = 2},
	{id = 27039, chance = 20255, maxCount = 2},
	{id = 27041, chance = 19957},
	{id = 27040, chance = 17550},
	{id = 27042, chance = 13976},
	{id = 2666, chance = 9722},
	{id = 2260, chance = 8245},
	{id = 7591, chance = 7196},
	{id = 2789, chance = 6100, maxCount = 2},
	{id = 2146, chance = 5099},
	{id = 5022, chance = 4968, maxCount = 3},
	{id = 5913, chance = 4635},
	{id = 24849, chance = 4373},
	{id = 27046, chance = 4361},
	{id = 2147, chance = 4027},
	{id = 9809, chance = 2895},
	{id = 2214, chance = 2597},
	{id = 5914, chance = 2037},
	{id = 27047, chance = 1620},
	{id = 2396, chance = 1180},
	{id = 5912, chance = 1037},
	{id = 2162, chance = 1025},
	{id = 5909, chance = 965},
	{id = 5910, chance = 643},
	{id = 5911, chance = 536},
	{id = 2195, chance = 226}
}

mType:register(monster)
