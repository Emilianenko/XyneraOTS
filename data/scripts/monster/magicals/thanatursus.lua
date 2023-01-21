local mType = Game.createMonsterType("Thanatursus")
local monster = {}

monster.name = "Thanatursus"
monster.description = "a thanatursus"
monster.experience = 6300
monster.outfit = {
	lookType = 1134,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 7200
monster.maxHealth = 7200
monster.runHealth = 20
monster.race = "blood"
monster.corpse = 32725
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
	{text = "Uuuuuuuuuaaaaaarg!!!", yell = false}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "drunk", condition = true},
	{type = "bleed", condition = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 30},
	{type = COMBAT_ENERGYDAMAGE, percent = 50},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 20},
	{type = COMBAT_DEATHDAMAGE , percent = -20}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -450},
	{name ="combat", interval = 2000, chance = 21, minDamage = -200, maxDamage = -350, range = 6, type = COMBAT_ENERGYDAMAGE, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYAREA, target = true},
	{name ="combat", interval = 2000, chance = 15, minDamage = -200, maxDamage = -300, radius = 3, type = COMBAT_HOLYDAMAGE, effect = CONST_ME_HOLYAREA},
	{name ="combat", interval = 2000, chance = 15, minDamage = -200, maxDamage = -300, range = 6, radius = 3, type = COMBAT_HOLYDAMAGE, shootEffect = CONST_ANI_SMALLHOLY, effect = CONST_ME_BLOCKHIT, target = true},
	{name ="combat", interval = 2000, chance = 14, minDamage = -250, maxDamage = -400, radius = 5, type = COMBAT_HOLYDAMAGE, effect = CONST_ME_BLOCKHIT}

}

monster.defenses = {
	defense = 78,
	armor = 78
}

monster.loot = {
	{id = 2152, chance = 100000, maxCount = 12},
	{id = 2666, chance = 50448},
	{id = 2671, chance = 14824},
	{id = 11223, chance = 12668, maxCount = 6},
	{id = 2381, chance = 12444},
	{id = 7886, chance = 9588},
	{id = 8473, chance = 8609},
	{id = 7903, chance = 6341},
	{id = 8472, chance = 6313, maxCount = 3},
	{id = 2430, chance = 5459},
	{id = 23546, chance = 5053},
	{id = 2189, chance = 4199},
	{id = 3962, chance = 3919},
	{id = 2521, chance = 3597},
	{id = 15453, chance = 2940},
	{id = 2529, chance = 2912},
	{id = 2405, chance = 2660},
	{id = 2425, chance = 2534},
	{id = 10550, chance = 2016},
	{id = 15451, chance = 1792},
	{id = 7413, chance = 1722},
	{id = 18390, chance = 1554}
}

mType:register(monster)
