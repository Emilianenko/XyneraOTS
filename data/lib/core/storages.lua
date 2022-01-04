--[[
Reserved player storage ranges:
- 300000 to 310000+ reserved for achievements
- 310000 to 320000+ reserved for achievement progress
- 320000 to 320255 reserved for player resources (wildcards, charms, etc)
- 10000000 to 20000000 reserved for outfits and mounts on source

Reserved account storage ranges:
-- 1000000 reserved for store coins
]]--
PlayerStorageKeys = {
	annihilatorReward = 70015,
	goldenOutfit = 70016,
	-- empty 70017
	promotion = 70018,
	delayLargeSeaShell = 70019,
	firstRod = 70020,
	delayWallMirror = 70021,
	-- empty 70022
	madSheepSummon = 70023,
	crateUsable = 70024,
	-- empty 70025
	afflictedOutfit = 70026,
	afflictedPlagueMask = 70027,
	afflictedPlagueBell = 70028,
	familiarHealth = 70029,
	familiarDuration = 70030,
	nailCaseUseCount = 70031,
	swampDigging = 70032,
	insectoidCell = 70033,
	vortexTamer = 70034,
	mutatedPumpkin = 70035,
	randomizeMount = 70036,
	achievementsBase = 300000,
	achievementsCounter = 310000,
	resourcesBase = 320000,
	forgeDustLevel = 320256,
}

GlobalStorageKeys = {
}

-- unused
-- AccountStorageKeys = {}
