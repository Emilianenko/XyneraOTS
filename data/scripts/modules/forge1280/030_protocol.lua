---- parse methods
do
	function parseForgeRequest(player, recvbyte, msg)
		-- request forge action
		if recvbyte == FORGE_REQUEST_USEFORGE then
			-- check if player is near the forge
			if not player:isInForge() then
				-- player is not close enough to the forge
				player:sendDefaultForgeError(FORGE_ERROR_NOTINFORGE)
				return
			end
			
			local forgeAction = msg:getByte()
			
			-- fusion
			if forgeAction == FORGE_ACTION_FUSION then
				player:onFusionRequest(
					msg:getU16(), -- from item
					msg:getByte(), -- from item tier
					msg:getU16(), -- to item (not needed technically)
					msg:getByte(), -- increase success chance
					msg:getByte() -- reduce tier loss
				)
				return
				
			-- transfer
			elseif forgeAction == FORGE_ACTION_TRANSFER then
				player:onForgeTransferRequest(
					msg:getU16(), -- from item
					msg:getByte(), -- from item tier
					msg:getU16() -- to item
				)
				return

			-- convert resources
			elseif forgeAction <= FORGE_ACTION_INCREASELIMIT then
				player:onResourceConversion(forgeAction)
				return
			end
				
			-- bad request
			player:sendDefaultForgeError(FORGE_ERROR_BADREQUEST)
			return
		end
		
		-- request history
		-- send history + forge resources
		--[[
		request history (both sources):
			192
			0 (?)
			0 (page?)
			9 (entries per page?)
		]]
		player:sendForgeHistory(msg:getByte())
		
		--print(recvbyte, message:getByte(), message:getByte(), message:getByte(), message:getByte(), message:getByte(), message:getByte(), message:getByte(), message:getByte(), message:getByte(), message:getByte(), message:getByte())
		--player:addDispatcherTask(dispatcherSendForgeUI, DISPATCHER_FORGE_ENTER, player:getId())
	end

	setPacketEvent(FORGE_REQUEST_USEFORGE, parseForgeRequest)
	setPacketEvent(FORGE_REQUEST_HISTORY, parseForgeRequest)
end

---- send methods
-- forge resources
function Player:sendForgeResources()
	self:sendResourceBalance(RESOURCE_BANK_BALANCE, self:getBankBalance())
	self:sendResourceBalance(RESOURCE_GOLD_EQUIPPED, self:getMoney())
	self:sendResourceBalance(RESOURCE_FORGE_DUST, self:getForgeDust())
	self:sendResourceBalance(RESOURCE_FORGE_SLIVERS, self:getSlivers())
	self:sendResourceBalance(RESOURCE_FORGE_CORES, self:getForgeCores())
end

-- error handler
do
	local errorMsgs = {
		[FORGE_ERROR_NOTENOUGHGOLD] = "Not enough gold.",
		[FORGE_ERROR_NOTENOUGHDUST] = "Not enough dust.",
		[FORGE_ERROR_NOTENOUGHSLIVERS] = "Not enough slivers.",
		[FORGE_ERROR_NOTENOUGHCORES] = "Not enough exaltation cores.",
		[FORGE_ERROR_NOTENOUGHITEMS] = "You do not have necessary items.",
		[FORGE_ERROR_NOTENOUGHCAP] = "Not enough capacity.",
		[FORGE_ERROR_NOTENOUGHROOM] = "Not enough room.",
		[FORGE_ERROR_NOTUPGRADEABLE] = "Selected items cannot be processed.",
		[FORGE_ERROR_MAXDUSTLEVELREACHED] = "Maximum level reached.",
		[FORGE_ERROR_BADLEVELINCREASEPRICE] = "Bad forge system configuration. Please contact server administrator.",
		[FORGE_ERROR_TIERTOOHIGH] = "Maximal tier reached.",
		[FORGE_ERROR_NOTINFORGE] = "Stand near forge to perform this action.",
		[FORGE_ERROR_BADREQUEST] = "Unable to process your request.",
	}
	function Player:sendDefaultForgeError(errorCode)
		self:closeForgeUI() -- escape forge dialog

		errorCode = errorCode or 0
		local errorMsg = errorMsgs[errorCode] or "(unknown error code)"
		self:popupFYI(string.format("Error: %s", errorMsg))
	end
end

-- load the data defined in other files
local forgeMeta = getForgeMeta()
local forgeData = getForgeData()
local forgeOrder = getForgeOrder()

do
	local function parseForgeItemType(t, itemType, itemId, count, class, tier)
		if not t[class] then
			t[class] = {}
		end
		
		if count > 0 then
			t[class][itemId + tier * ITEMTIER_HASH] = count
		end
		return
	end

	-- base UI
	function Player:sendForgeUI(loadFromCache)
		-- FUSION
		-- collect item data for fusion
		
		local cid = self:getId()
		
		-- only dust level upgrade was made, load from cache instead
		if loadFromCache and ForgeCache[cid] then
			if #ForgeCache[cid] > 0 then
				local m = NetworkMessage()
				m:addByte(FORGE_RESPONSE_BASE)
				
				-- read cached bytes
				for i = 1, #ForgeCache[cid] do
					local cachedValue = ForgeCache[cid][i]
					if cachedValue[2] == FORGE_CACHE_TYPE_BYTE then
						m:addByte(cachedValue[1])
					elseif cachedValue[2] == FORGE_CACHE_TYPE_U16 then
						m:addU16(cachedValue[1])
					-- elseif ... then
					-- more types
					end
				end
				
				m:addByte(self:getForgeDustLimit())
				m:sendToPlayer(self)
				return
			end
		end
		
		-- tables fill memory in Lua fast so
		-- I recommend clearing it also when the player is walking through forge area entrance, logging out or dying
		ForgeCache[cid] = {}
		
		local playerItems = self:getItemsByLocation(LOCATION_BACKPACK, not forgeData.allowCustomItemFusion)
		local fusionItems = {}
		local fusionItemsCount = 0
		for itemInfo, count in pairs(playerItems) do
			-- you need 2 items in order for them to be displayed
			if count > 1 then
				local itemId, tier = unhashItemInfo(itemInfo)
				local itemType = ItemType(itemId)
				local class = itemType:getClassification()
				if class > 0 and forgeMeta[class] and tier < #forgeMeta[class] then
					fusionItems[itemInfo] = count
					fusionItemsCount = fusionItemsCount + 1
				end
			end
		end
		
		-- TRANSFER
		-- collect item data for transfer
		local playerItemsToTransfer
		if forgeData.allowCustomItemFusion == forgeData.allowCustomItemTransfer then
			playerItemsToTransfer = playerItems
		else
			playerItemsToTransfer = self:getItemsByLocation(LOCATION_BACKPACK, not forgeData.allowCustomItemTransfer)
		end
		
		local donors = {} -- items player moves the tier from		
		local recipents = {} -- items player moves the tier to
		
		for itemInfo, count in pairs(playerItemsToTransfer) do
			local itemId, tier = unhashItemInfo(itemInfo)
			local itemType = ItemType(itemId)
			local class = itemType:getClassification()
			
			if class > 0 then -- classless items are ignored by the client ui
				if tier == 0 then -- recipents can be tier zero only
					parseForgeItemType(recipents, itemType, itemId, count, class, tier)
				elseif tier > 1 and forgeMeta[class] and tier <= #forgeMeta[class] then -- donors need to be tier 2 at least because tier gets lowered by 1 during transform
					parseForgeItemType(donors, itemType, itemId, count, class, tier)
				end
			end
		end

		local transferGroupsCount = 0
		for _, categoryData in pairs(donors) do
			transferGroupsCount = transferGroupsCount + 1
		end

		-- RESPONSE
		-- start the packet
		local m = NetworkMessage()
		m:addByte(FORGE_RESPONSE_BASE) -- header
		
		-- fusion tab
		m:addAndCacheForgeValue(cid, fusionItemsCount, FORGE_CACHE_TYPE_U16)
		for itemInfo, count in pairs(fusionItems) do
			local itemId, tier = unhashItemInfo(itemInfo)
			m:addAndCacheForgeValue(cid, 1, FORGE_CACHE_TYPE_BYTE) -- number of "friend" items (unused)
			-- 1 item to send:
			m:addAndCacheForgeValue(cid, ItemType(itemId):getClientId(), FORGE_CACHE_TYPE_U16)
			m:addAndCacheForgeValue(cid, tier, FORGE_CACHE_TYPE_BYTE)
			m:addAndCacheForgeValue(cid, math.min(count, 0xFFFF), FORGE_CACHE_TYPE_U16)
		end

		-- transfer tab
		m:addAndCacheForgeValue(cid, transferGroupsCount, FORGE_CACHE_TYPE_BYTE)
		if transferGroupsCount > 0 then
			for class, items in pairs(donors) do
				local itemCount = 0
				for _, v in pairs(items) do
					itemCount = itemCount + 1
				end
				
				-- potential donors
				m:addAndCacheForgeValue(cid, itemCount, FORGE_CACHE_TYPE_U16)
				for itemInfo, count in pairs(items) do
					local itemId, tier = unhashItemInfo(itemInfo)
					m:addAndCacheForgeValue(cid, ItemType(itemId):getClientId(), FORGE_CACHE_TYPE_U16)
					m:addAndCacheForgeValue(cid, tier, FORGE_CACHE_TYPE_BYTE)
					m:addAndCacheForgeValue(cid, math.min(count, 0xFFFF), FORGE_CACHE_TYPE_U16)
				end
				
				-- potential recipents
				local recipentsCount = 0
				if recipents[class] then
					for k, v in pairs(recipents[class]) do
						recipentsCount = recipentsCount + 1
					end
				end
				
				m:addAndCacheForgeValue(cid, recipentsCount, FORGE_CACHE_TYPE_U16)
				if recipentsCount > 0 then
					for itemId, count in pairs(recipents[class]) do
						m:addAndCacheForgeValue(cid, ItemType(itemId):getClientId(), FORGE_CACHE_TYPE_U16)
						m:addAndCacheForgeValue(cid, math.min(count, 0xFFFF), FORGE_CACHE_TYPE_U16)
					end
				end
			end
		end
		
		m:addByte(self:getForgeDustLimit())
		m:sendToPlayer(self)

		if not loadFromCache then
			self:sendForgeResources()
		end
	end
	
	function Player:sendDustLevelUpdate()
		local m = NetworkMessage()
		m:addByte(FORGE_RESPONSE_BASE)
		m:addU16(0)
		m:addByte(0)
		m:addByte(self:getForgeDustLimit())
		m:sendToPlayer(self)
	end
end

do
	local bonusTypesWithItem = {
		FORGE_BONUS_ITEMKEPT_ONETIERLOST,
		FORGE_BONUS_ITEMKEPT_NOTIERLOST,
		FORGE_BONUS_BOTHUPGRADED,
		FORGE_BONUS_EXTRATIER,
		FORGE_BONUS_ITEMNOTCONSUMED
	}
	function Player:sendForgeResult(forgeAction, result, params)
		self:closeForgeUI() -- escape forge dialog
	--[[
		local params = {
			startClientId = a,
			startTier = b,
			outputClientId = c,
			outputTier = d,
			bonusType = e,
			bonusClientId = f,
			bonusTier = g,
			coresCost = h
		}
	]]
		-- don't display when cores were not used
		if params.bonusType == FORGE_BONUS_CORESKEPT and params.coresCost == 0 then
			params.bonusType = FORGE_BONUS_NONE
		end
		
		local m = NetworkMessage()
		m:addByte(FORGE_RESPONSE_RESULT)	
		m:addByte(forgeAction) -- fusion or transfer
		m:addByte(result) -- isSuccess
		
		-- left side item
		m:addU16(params.startClientId)
		m:addByte(params.startTier)
		
		-- right side item
		m:addU16(params.outputClientId)	
		m:addByte(params.outputTier)
		
		-- rolled bonus
		-- 0x00 - nothing
		-- 0x01 - no dust consumed
		-- 0x02 - cores not consumed (requires extra byte: amount of cores)
		-- 0x03 - gold not consumed
		
		-- (values below require u16 clientId, u8 tier)
		-- 0x04 - item not consumed, lost 1 tier only
		-- 0x05 - you kept the second item and its tier
		-- 0x06 - both items gained extra tier
		-- 0x07 - item gained two tiers
		-- 0x08 - second item was not consumed
		m:addByte(params.bonusType)
		if params.bonusType == FORGE_BONUS_CORESKEPT then
			m:addByte(params.coresCost)
		elseif table.contains(bonusTypesWithItem, params.bonusType) then
			m:addU16(params.bonusClientId)
			m:addByte(params.bonusTier)
		end

		m:sendToPlayer(self)
	end
end

function Player:closeForgeUI()
	local m = NetworkMessage()
	m:addByte(FORGE_RESPONSE_EXIT)
	m:sendToPlayer(self)
end

function Player:sendForgeHistory(page)
	self:sendForgeResources()
	
	page = page + 1 -- client starts index at 0
	
	local history = getForgeHistory(self:getId())
	if not history then
		history = {}
	end
	
	local lastPage = math.max(1, math.floor((#history-1)/forgeData.historyEntriesPerPage)+1)
	local currentPage = math.min(page, lastPage)
	
	local historyToSend = {}
	for i = ((currentPage-1) * forgeData.historyEntriesPerPage)+1, math.min(#history, currentPage * forgeData.historyEntriesPerPage) do
		historyToSend[#historyToSend + 1] = history[i]
	end
	
	local response = NetworkMessage()
	response:addByte(FORGE_RESPONSE_HISTORY)
	response:addU16(currentPage-1)
	response:addU16(lastPage)
	response:addByte(#historyToSend)
	if #historyToSend > 0 then
		for i = 1, #historyToSend do
			response:addU32(historyToSend[i].at)
			response:addByte(historyToSend[i].action)
			response:addString(historyToSend[i].details)
			response:addByte(historyToSend[i].success and 0x01 or 0x00)
		end
	end
	
	response:sendToPlayer(self)
end

-- overrides native function
-- to do: move to on connect event
-- to do: resend on reload
function Player:sendItemClasses()
	local msg = NetworkMessage()
	msg:addByte(FORGE_RESPONSE_META)
	msg:addByte(#forgeMeta)
	if #forgeMeta > 0 then
		for classId, classData in pairs(forgeMeta) do
			msg:addByte(classId)
			msg:addByte(#classData)
			if #classData > 0 then
				for tierId = 0, #classData-1 do
					msg:addByte(tierId)
					msg:addU64(classData[tierId+1])
				end
			end
		end
	end
	
	-- other metadata
	for i = 1, #forgeOrder do
		msg:addByte(forgeData[forgeOrder[i]])
	end
	
	msg:sendToPlayer(self)
end