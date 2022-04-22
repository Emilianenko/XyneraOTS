--[[
Reserved player storage ranges:
- 300000 to 310000+ reserved for achievements
- 310000 to 320000+ reserved for achievement progress

- 320000 to 320255 reserved for player resources (wildcards, charms, etc)

- 330000 to 340000 reserved for bestiary killCount
- 340000 to 350000 reserved for bestiary unlock levels
- 360000 to 360100 reserved for bestiary categories progress

- 10000000 to 20000000 reserved for outfits, mounts and familiars on source

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
	commandsCooldown = 70037,
	
	-- auto loot
	autoLootMode = 70038,
	autoLootFallback = 70040,
	
	-- condition taint storages
	taints = 70041,
	taintB_cooldown = 70047,
	taintD_cooldown = 70049,
	
	-- total range: 300000-319999
	achievementsBase = 300000,
	achievementsCounter = 310000,
	
	-- total range: 320000-320255
	resourcesBase = 320000,

	forgeDustLevel = 320256,

	-- total range: 329999-359999
	bestiaryInitCharmSystem = 329999,
	bestiaryKillCountBase = 330000,
	bestiaryRaceProgressBase = 340000,
	bestiaryCategoryProgressBase = 350000
}

GlobalStorageKeys = {
}

-- unused
-- AccountStorageKeys = {}
