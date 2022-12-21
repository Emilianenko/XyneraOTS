-- keep it global for furniture kits code
CarpetMap = {
	-- 10.90
	[25393] = 25392, -- rift carpet
	[26087] = 26109, -- yalaharian carpet
	[26088] = 26110, -- white fur carpet
	[26089] = 26111, -- bamboo mat carpet
	[26193] = 26192, -- void carpet
	
	-- 10.97
	[26363] = 26371, -- crimson carpet
	[26366] = 26372, -- azure carpet
	[26367] = 26373, -- emerald carpet
	[26368] = 26374, -- light parquet carpet
	[26369] = 26375, -- dark parquet carpet
	[26370] = 26376, -- marble floor
	
	-- 11.04
	[27072] = 27080, -- colorful carpet
	[27073] = 27081, -- flowery carpet
	[27074] = 27082, -- striped carpet
	[27075] = 27083, -- fur carpet
	[27076] = 27084, -- diamond carpet
	[27077] = 27085, -- patterned carpet
	[27078] = 27086, -- night sky carpet
	[27079] = 27087, -- star carpet
	
	-- 11.40
	[28770] = 28771, -- verdant carpet
	[28772] = 28773, -- shaggy carpet
	[28774] = 28775, -- mystic carpet
	[28776] = 28777, -- stone tiles
	[28779] = 28778, -- wooden planks
	[28807] = 28806, -- wheat carpet
	[28808] = 28809, -- crested carpet
	[28810] = 28811, -- decorated carpet
	
	-- 12.15
	[34122] = 34124, -- tournament carpet
	[34123] = 34125, -- sublime tournament carpet
	
	-- 12.60
	[38543] = 38544, -- lilac carpet
	[38545] = 38546, -- pom-pom carpet
	[38547] = 38548, -- natural pom-pom carpet
	[38549] = 38550, -- owig rug
	[38551] = 38552, -- panther rug
	[38553] = 38554, -- moon carpet
	[38555] = 38556, -- romantic carpet
	
	-- 12.70
	[39494] = 39152, -- eldritch carpet
	[39607] = 39595, -- cloth (sapling)
	[39608] = 39597, -- cloth (almanac)
	[39609] = 39599, -- cloth (book)
	[39610] = 39601, -- cloth (cube)
	[39611] = 39603, -- cloth (ring)
	[39612] = 39605, -- cloth (cobra)
	[39675] = 39676, -- grass

	-- 12.85
	-- festive carpets
	[40506] = 40505, -- dragon lord
	[40509] = 40507, -- dragon
	[40510] = 40508, -- elemental
	[40512] = 40511, -- morgaroth
	[40514] = 40513, -- ghazbaran
	[40516] = 40515, -- orshabaal
	[40518] = 40517, -- red cake
	[40526] = 40519, -- orange cake
	[40527] = 40520, -- yellow cake
	[40528] = 40521, -- green cake
	[40529] = 40522, -- sky blue cake
	[40530] = 40523, -- blue cake
	[40531] = 40524, -- purple cake
	[40532] = 40525, -- pink cake
	[40534] = 40533, -- red t-25 carpet
	[40542] = 40535, -- orange t-25 carpet
	[40543] = 40536, -- yellow t-25 carpet
	[40544] = 40537, -- green t-25 carpet
	[40545] = 40538, -- sky blue t-25 carpet
	[40546] = 40539, -- blue t-25 carpet
	[40547] = 40540, -- purple t-25 carpet
	[40548] = 40541, -- pink t-25 carpet
	[40911] = 40912, -- zaoan mat pattern 1
	[40913] = 40914, -- zaoan mat pattern 2
	[40915] = 40916, -- zaoan mat pattern 3
	[40917] = 40918, -- zaoan mat pattern 4
	[40919] = 40920, -- zaoan mat pattern 5
	[40921] = 40922, -- zaoan mat pattern 6
	
	-- 12.91
	[44794] = 44795, -- flowery grass
	
	-- 13.10
	[47082] = 47080, -- cloth (idol)
}

ReverseCarpetMap = {
	-- decolouring artefact carpets
	[39596] = 39607, -- sapling
	[39598] = 39608, -- almanac
	[39600] = 39609, -- book
	[39602] = 39610, -- cube
	[39604] = 39611, -- ring
	[39606] = 39612, -- cobra
	[47081] = 47082, -- idol
}

for k, v in pairs(CarpetMap) do
	ReverseCarpetMap[v] = k
end

local carpets = Action()

function carpets.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	-- detect action type
	local foldId = ReverseCarpetMap[item.itemid]
	local unfoldId = CarpetMap[item.itemid]
	if not (foldId or unfoldId) then
		-- carpet registered but erased from the table
		return false
	end
	
	-- check house permissions
	local tile = item:getTile()
	local house = tile:getHouse()
	if not house then
		player:sendTextMessage(MESSAGE_STATUS_SMALL, "You may use this only inside a house.")
		return true
	elseif house:getOwnerGuid() ~= player:getGuid() then
		player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
		return true
	end
	
	if foldId then
		-- carpet is unfolded, fold it
		item:transform(foldId)
	else
		-- carpet is folded, unfold it

		-- carpets to reorder
		local carpetStack = {}
		
		-- check if more carpets are allowed
		local carpetCount = 0
		for stackPos, tileItem in pairs(tile:getItems()) do
			local carpetId = tileItem:getId()
			if ReverseCarpetMap[carpetId] then
				carpetStack[#carpetStack + 1] = tileItem
				carpetCount = carpetCount + 1
			end
		end
		if carpetCount > 2 then
			player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
			return true
		end
		
		local tilePos = tile:getPosition()
		local shufflePos = Position(tilePos.x, tilePos.y + 1, tilePos.z)
		
		-- move the carpet to the floor if clicked from a container
		if fromPosition.x == CONTAINER_POSITION then
			item:moveTo(tile:getPosition())
		end
		
		item:transform(unfoldId)
		
		if #carpetStack > 0 then
			for i = #carpetStack, 1, -1 do
				carpetStack[i]:moveTo(shufflePos)
				carpetStack[i]:moveTo(tilePos)
			end
		end
	end

	return true
end

-- register folding
for carpetId, _ in pairs(ReverseCarpetMap) do
	carpets:id(carpetId)
end

-- register unfolding
for carpetId, _ in pairs(CarpetMap) do
	carpets:id(carpetId)
end

carpets:register()
