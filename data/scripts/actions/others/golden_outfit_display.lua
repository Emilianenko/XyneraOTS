local outfitStages = {
	[1] = { -- north
		34168, -- armor
		34160, -- armor + boots
		34164, -- armor + helmet
		34172 -- full armor
	},
	[2] = { -- east
		34165,
		34156,
		34161,
		34169
	},
	[3] = { -- south
		34166,
		34158,
		34162,
		34170		
	},
	[4] = { -- west
		34167,
		34159,
		34163,
		34171
	}
}

local function getOutfitData(itemId)
	for outfitGroup = 1, #outfitStages do
		for outfitMode = 1, #outfitStages[outfitGroup] do
			if outfitStages[outfitGroup][outfitMode] == itemId then
				return outfitGroup, outfitMode
			end
		end
	end
end

local goldenOutfitDisplay = Action()
function goldenOutfitDisplay.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	-- locate destination tile
	local tile = item:getTile()
	if not tile then
		-- unable to locate target tile
		return RETURNVALUE_CANNOTUSETHISOBJECT	
	end
	
	-- check if house
	local house = tile:getHouse()
	if not house or player:getAccountId() ~= house:getOwnerAccountId() then
		-- guests cant toggle the display
		return RETURNVALUE_CANNOTUSETHISOBJECT	
	end

	local outfitCycles = {}
	for addon = 0, 3 do
		if player:hasOutfit(1210, addon) or player:hasOutfit(1211, addon) then
			outfitCycles[#outfitCycles + 1] = addon + 1
		end
	end
	
	if #outfitCycles == 0 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need the Golden Outfit to use it.")
		return true
	end
	
	local outfitGroup, outfitMode = getOutfitData(item:getId())
	if not outfitMode then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Unable to modify the stand.")
		return true
	end
	
	-- get next mode
	local nextCycle = -1
	for tryMode = 1, #outfitCycles do
		if outfitCycles[tryMode] > outfitMode then
			nextCycle = tryMode
			break;
		end
	end
	
	if nextCycle == -1 then
		nextCycle = 1
	end
	
	item:transform(outfitStages[outfitGroup][outfitCycles[nextCycle]])
	item:getPosition():sendMagicEffect(CONST_ME_EARLY_THUNDER)
	return true
end

goldenOutfitDisplay:id(34156)
for i = 34158, 34172 do
	goldenOutfitDisplay:id(i)
end

goldenOutfitDisplay:register()