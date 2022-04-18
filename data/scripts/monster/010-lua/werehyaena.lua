local mType = Game.createMonsterType("Werehyaena")
local monster = {}

monster.description = "a werehyaena"
monster.experience = 2200
monster.outfit = {
	lookType = 1300,
	lookHead = 57,
	lookBody = 77,
	lookLegs = 1,
	lookFeet = 1,
	lookAddons = 0,
	lookMount = 0
}


monster.health = 2700
monster.maxHealth = monster.health
monster.race = "blood"
monster.corpse = 36477
monster.speed = 120
monster.manaCost = 0

monster.changeTarget = {
	interval = 5*1000,
	chance = 0
}


monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	challengeable = true,
	convinceable = false,
	ignoreSpawnBlock = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	targetDistance = 1,
	staticAttackChance = 90,
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = true
}

monster.voices = {
	interval = 0,
	chance = 0
}

monster.loot = {
	{id = 2152, chance = 100000, maxCount = 3},
    {id = 7591, chance = 49970, maxCount = 3},
    {id = 2666, chance = 19070},
    {id = "axe", chance = 16810},
    {id = "knife", chance = 16620},
    {id = "werehyaena nose", chance = 12670},
    {id = "halberd", chance = 11480},
    {id = "red crystal fragment", chance = 9540},
    {id = "small enchanted amethyst", chance = 5760, maxCount = 5},
    {id = "life preserver", chance = 5670},
    {id= 3039, chance = 5590},
    {id = "yellow gem", chance = 5420},
    {id = "combat knife", chance = 4700},
    {id = "green crystal fragment", chance = 4580},
    {id = "ratana", chance = 4280},
    {id = "werehyaena talisman", chance = 750},
    {id = "werehyaena trophy", chance = 190}
}

monster.attacks = {
	{name = "melee", type = COMBAT_PHYSICALDAMAGE, interval = 2*1000, minDamage = 0, maxDamage = -300},
    {name = "combat", type = COMBAT_EARTHDAMAGE, interval = 2*1000, chance = 17, minDamage = -175, maxDamage = -255, radius = 3, effect = CONST_ME_HITBYPOISON},
    {name = "combat", type = COMBAT_DEATHDAMAGE, interval = 2*1000, chance = 15, minDamage = -330, maxDamage = -370, target = true, range = 5, radius = 1, shootEffect = CONST_ANI_LARGEROCK, effect = CONST_ME_MORTAREA},
    {name = "combat", type = COMBAT_DEATHDAMAGE, interval = 2*1000, chance = 13, minDamage = -225, maxDamage = -275, length = 3, spread = 0, effect = CONST_ME_MORTAREA}
}

monster.defenses = {
	{name = "speed", chance = 15, interval = 2*1000, speed = 200, duration = 5*1000, effect = CONST_ME_MAGIC_BLUE},
	defense = 0,
	armor = 38
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 60},
	{type = COMBAT_FIREDAMAGE, percent = 75},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -20},
	{type = COMBAT_HOLYDAMAGE , percent = 95},
	{type = COMBAT_DEATHDAMAGE , percent = -5}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = true},
	{type = "invisible", condition = true},
	{type = "bleed", condition = true}
}

mType:register(monster)
