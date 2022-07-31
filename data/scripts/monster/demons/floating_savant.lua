local mType = Game.createMonsterType("Floating Savant")
local monster = {}

monster.name = "Floating Savant"
monster.description = "a floating savant"
monster.experience = 8000
monster.outfit = {
	lookType = 1063,
	lookHead = 113,
	lookBody = 94,
	lookLegs = 78,
	lookFeet = 78,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 8000
monster.maxHealth = 8000
monster.runHealth = 0
monster.race = "blood"
monster.corpse = 31254
monster.speed = 330
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
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "tssooosh tsoooosh tssoooosh!", yell = false},
	{text = "We didn't stop the fire!", yell = false}
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
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -10},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 50}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -750},
	{name ="combat", interval = 2000, chance = 25, minDamage = -300, maxDamage = -420, range = 7, radius = 3, type = COMBAT_FIREDAMAGE, effect = CONST_ME_FIREATTACK, shootEffect = CONST_ANI_FIRE, target = true},
	{name ="combat", interval = 2000, chance = 15, minDamage = -550, maxDamage = -700, range = 7, type = COMBAT_DEATHDAMAGE, effect = CONST_ME_ENERGYAREA, shootEffect = CONST_ANI_DEATH, target = true},
	{name ="combat", interval = 2000, chance = 29, minDamage = -400, maxDamage = -470, radius = 3, type = COMBAT_ENERGYDAMAGE, effect = CONST_ME_EXPLOSIONAREA},
	{name ="combat", interval = 2000, chance = 22, minDamage = -500, maxDamage = -700, length = 6, spread = 0, type = COMBAT_FIREDAMAGE, effect = CONST_ME_EXPLOSIONAREA, direction = true}
}

monster.defenses = {
	defense = 74,
	armor = 74
}

monster.maxSummons = 1
monster.summons = {
    {name = "Lava Lurker Attendant", chance = 15, interval = 2000, max = 1}
}

monster.loot = {
	{id = 2156, chance = 71670, maxCount = 4},
	{id = 5911, chance = 30670, maxCount = 3},
	{id = 6500, chance = 23778},
	{id = 7760, chance = 20595, maxCount = 14},
	{id = 11237, chance = 19784},
	{id = 18420, chance = 19417, maxCount = 8},
	{id = 6558, chance = 15343},
	{id = 3456, chance = 4998},
	{id = 9969, chance = 255},
	{id = 30530, chance = 111}
}

mType:register(monster)
