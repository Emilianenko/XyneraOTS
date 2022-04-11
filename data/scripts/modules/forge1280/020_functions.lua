-- load forge config for this file
local forgeMeta = getForgeMeta()
local forgeData = getForgeData()

-- forge history manager
do
	local history = {}
	local function shortenCost(str)
		return str:reverse():gsub("000", "k"):reverse()
	end
	
	-- creature id (number), details (table depending on action type)
	function appendForgeHistory(cid, details)
		if not history[cid] then
			history[cid] = {}
		end
		
		local detailsResponse
		if details.action == FORGE_ACTION_FUSION then
			detailsResponse = string.format("2x [%d] %s ->", details.tier, details.itemA)
			if details.success then
				if details.bonus == 4 then
					detailsResponse = string.format("%s [%d] %s, [%d] %s", detailsResponse, details.tier + 1, details.itemA, details.tier - 1, details.itemA)
				elseif details.bonus == 5 then
					detailsResponse = string.format("%s [%d] %s, [%d] %s", detailsResponse, details.tier + 1, details.itemA, details.tier, details.itemA)
				elseif details.bonus == 6 then
					detailsResponse = string.format("%s 2x [%d] %s", detailsResponse, details.tier + 1, details.itemA)
				elseif details.bonus == 7 then
					detailsResponse = string.format("%s [%d] %s", detailsResponse, details.tier + 2, details.itemA)
				elseif details.bonus == 8 then
					detailsResponse = string.format("%s [%d] %s, [%d] %s", detailsResponse, details.tier + 1, details.itemA, details.tier, details.itemA)
				else
					detailsResponse = string.format("%s [%d] %s", detailsResponse, details.tier + 1, details.itemA)
				end
			else
				if details.tier > 0 or tierLossPrevented then
					if tierLossPrevented then
						detailsResponse = string.format("%s 2x [%d] %s", detailsResponse, details.tier, details.itemA)
					else
						detailsResponse = string.format("%s [%d] %s, [%d] %s", detailsResponse, details.tier, details.itemA, details.tier - 1, details.itemA)
					end
				else
					detailsResponse = string.format("%s [%d] %s", detailsResponse, details.tier, details.itemA)
				end
			end
			
			if details.successCore then
				detailsResponse = string.format("%s, success rate boost", detailsResponse)
			end
			
			if details.tierCore then
				detailsResponse = string.format("%s, reduced tier loss chance", detailsResponse)
			end
			
			detailsResponse = string.format("%s, cores: %d, dust: %d, cost: %s", detailsResponse, details.coresCost, details.dustCost, shortenCost(tostring(details.cost)))
		elseif details.action == FORGE_ACTION_TRANSFER then
			detailsResponse = string.format("[%d] %s -> [%d] %s, cores: 1, dust: %d, cost: %s", details.tier, details.itemA, details.tier - 1, details.itemB, forgeData.transferDustCost, shortenCost(tostring(details.cost)))
		elseif details.action == FORGE_ACTION_DUSTTOSLIVERS then
			-- this line is not necessary because the id is already correct
			-- details.action = FORGE_ACTION_CONVERSION
			detailsResponse = string.format("%d dust to %d slivers.", details.cost, details.gained)
		elseif details.action == FORGE_ACTION_SLIVERSTOCORES then
			details.action = FORGE_ACTION_CONVERSION
			detailsResponse = string.format("%d slivers to %d cores.", details.cost, details.gained)
		elseif details.action == FORGE_ACTION_INCREASELIMIT then
			details.action = FORGE_ACTION_CONVERSION
			detailsResponse = string.format("Dust limit: %d -> %d, Cost: %d", details.gained, details.gained + 1, details.cost)
		else
			detailsResponse = "(unknown)"
		end
		
		history[cid][#history[cid] + 1] = {action = details.action, at = os.time(), details = detailsResponse, success = details.success}
		
		-- insertion to database can go here
	end
	
	function getForgeHistory(cid)
		-- reading from db can go here
		return history[cid]
	end
end

-- filter too frequent requests
do
	function dispatcherSendForgeUI(cid)
		local player = Player(cid)
		if player and not player:isRemoved() then
			player:sendForgeUI()
		end
	end
	
	-- enter forge on use
	local forgeAction = Action()
	function forgeAction.onUse(player, item, fromPosition, target, toPosition, isHotkey)
		player:addDispatcherTask(dispatcherSendForgeUI, DISPATCHER_FORGE_ENTER, player:getId())
		return true
	end
	for i = ITEM_FORGE_PLACE_FIRST, ITEM_FORGE_PLACE_LAST do
		forgeAction:id(i)
	end
	forgeAction:register()
end

-- forge resource methods
do
	-- dust
	function Player:getForgeDust()
		return math.max(0, self:getStorageValue(FORGE_DUST_STORAGE))
	end

	function Player:setForgeDust(amount)
		return self:setStorageValue(FORGE_DUST_STORAGE, amount)
	end

	function Player:addForgeDust(amount, isForced)
		if isForced then
			local newCount = self:getForgeDust() + amount
			return self:setForgeDust(newCount) and newCount or 0
		end
		
		local currentDust = self:getForgeDust()
		local dustLimit = self:getForgeDustLimit()
		if currentDust >= dustLimit then
			return 0
		end
		
		local newAmount = math.min(currentDust + amount, dustLimit)
		return self:setForgeDust(newAmount) and newAmount - currentDust or 0
	end

	function Player:removeForgeDust(amount)
		return self:setForgeDust(self:getForgeDust() - amount)
	end

	-- dust level
	function Player:getForgeDustLevel()
		return math.max(0, self:getStorageValue(PlayerStorageKeys.forgeDustLevel))
	end

	function Player:setForgeDustLevel(level)
		return self:setStorageValue(PlayerStorageKeys.forgeDustLevel, level)
	end

	function Player:getForgeDustLimit()
		return math.min(forgeData.maxStoredDustLimit, forgeData.minStoredDustLimit + self:getForgeDustLevel())
	end
	
	-- slivers
	function Player:getSlivers()
		return self:getItemCount(ITEM_FORGE_SLIVERS)
	end

	function Player:addSlivers(amount)
		return self:addItem(ITEM_FORGE_SLIVERS, amount)
	end
	
	function Player:removeSlivers(amount)
		return self:removeItem(ITEM_FORGE_SLIVERS, amount)
	end
	
	-- cores
	function Player:getForgeCores()
		return self:getItemCount(ITEM_FORGE_CORES)
	end
	
	function Player:addForgeCores(amount)
		return self:addItem(ITEM_FORGE_CORES, amount)
	end
	
	function Player:removeForgeCores(amount)
		return self:removeItem(ITEM_FORGE_CORES, amount)
	end
end

-- item check passed, perform the action
do
	local forgeBonuses = getForgeBonuses()
	local function rollBonus()
		local checkChance = 0
		local totalChance = forgeBonuses.totalChance
		local roll = math.random(totalChance)
		
		for index, chance in pairs(forgeBonuses) do
			if tonumber(index) and chance ~= 0 then
				checkChance = checkChance + chance
				if roll < checkChance then
					return index
				end
			end
		end
	end
	
	---- FUSION
	function Player:fuseItems(item1, item2, usesSuccessRateCore, usesTierLossCore, cost)
		local tier = item1:getTier()
		local forgeResultData = {
			action = FORGE_ACTION_FUSION,
			success = false,
			tierLoss = false,
			itemA = item1:getName(),
			tier = tier,
			successCore = usesSuccessRateCore > 0,
			tierCore = usesTierLossCore > 0,
			bonus = 0,
			cost = 0,
			dustCost = 0,
			coresCost = 0
		}
	
		if self:getFreeCapacity() < ItemType(ITEM_FORGE_CHEST):getWeight() then
			-- no cap to carry the chest with forge output
			self:sendDefaultForgeError(FORGE_ERROR_NOTENOUGHCAP)	
		end
		
		local playerBP = self:getSlotItem(CONST_SLOT_BACKPACK)
		if not playerBP or playerBP:getEmptySlots(true) < 1 then
			-- unable to carry the chest
			self:sendDefaultForgeError(FORGE_ERROR_NOTENOUGHROOM)	
		end

		-- roll bonus
		local bonusType = rollBonus(FORGE_ACTION_FUSION)
		
		-- roll result
		local successChance = forgeData.fusionBaseSuccessRate
		if usesSuccessRateCore > 0 then
			successChance = successChance + forgeData.fusionBonusSuccessRate
		end
		
		-- generate chest
		local chest = Game.createItem(ITEM_FORGE_CHEST)
		
		-- get values to work with
		local clientId = item1:getType():getClientId()
		local coresCost = (usesSuccessRateCore > 0 and 1 or 0) + (usesTierLossCore > 0 and 1 or 0)
			
		--  forge data for output message
		local params = {
			startClientId = clientId,
			startTier = tier,
			outputClientId = clientId,
			outputTier = 0,
			bonusType = 0,
			bonusClientId = clientId,
			bonusTier = 0,
			coresCost = coresCost
		}
		
		---- fusion successful
		if math.random(100) < successChance then
			item1:setTier(tier + 1)
			
			-- apply rolled bonus
			local keepSecond = false
			local bonusTier = 0
			if bonusType == FORGE_BONUS_ITEMKEPT_ONETIERLOST then
				if tier > 0 then
					bonusTier = tier - 1
					item2:setTier(bonusTier)
					keepSecond = true
				else
					-- unable to apply this bonus
					-- remove it from post fusion notification
					bonusType = FORGE_BONUS_NONE
				end
			elseif bonusType == FORGE_BONUS_ITEMKEPT_NOTIERLOST then
				bonusTier = tier
				keepSecond = true
			elseif bonusType == FORGE_BONUS_BOTHUPGRADED then
				bonusTier = tier + 1
				item2:setTier(bonusTier)
				keepSecond = true				
			elseif bonusType == FORGE_BONUS_EXTRATIER then
				if tier+2 <= #forgeMeta[item1:getClassification()] then
					bonusTier = tier + 2
					item1:setTier(bonusTier)
				else
					-- unable to apply this bonus
					-- remove it from post fusion notification
					bonusType = FORGE_BONUS_NONE
				end
			elseif bonusType == FORGE_BONUS_ITEMNOTCONSUMED then
				bonusTier = tier
				keepSecond = true
			end
			
			-- register output tier
			params.bonusType = bonusType
			params.outputTier = tier + 1
			params.bonusTier = bonusTier
			
			-- move items to chest
			item1:moveTo(chest)
			if keepSecond then
				item2:moveTo(chest)
			else
				item2:remove()
			end
			self:addItemEx(chest)
			
			-- consume resources
			if bonusType ~= FORGE_BONUS_DUSTKEPT then
				forgeResultData.dustCost = forgeData.fusionDustCost
				self:removeForgeDust(forgeData.fusionDustCost)
			end
			if bonusType ~= FORGE_BONUS_CORESKEPT then
				forgeResultData.coresCost = coresCost
				self:removeForgeCores(coresCost)
			end
			if bonusType ~= FORGE_BONUS_GOLDKEPT then
				forgeResultData.cost = cost
				self:removeTotalMoney(cost)
			end
			
			-- log forge action
			forgeResultData.success = true
			forgeResultData.bonus = bonusType
			appendForgeHistory(self:getId(), forgeResultData)
			
			-- send fusion animation
			self:sendForgeResult(FORGE_ACTION_FUSION, FORGE_RESULT_SUCCESS, params)
			return
		end

		---- fusion failed
		-- roll tier loss
		local isTierLost = math.random(100) < (usesTierLossCore > 0 and forgeData.fusionReducedTierLossChance or 100)
		local keepSecond = false
		params.outputTier = tier + 1
		
		if isTierLost then
			local newTier = tier - 1
			if newTier >= 0 then
				item2:setTier(newTier)
				keepSecond = true
			end
		else
			forgeResultData.tierLossPrevented = true
			params.bonusType = FORGE_BONUS_ITEMNOTCONSUMED
			params.bonusTier = tier
			keepSecond = true
		end
		
		-- move items to chest
		item1:moveTo(chest)
		if keepSecond then
			item2:moveTo(chest)
		else
			item2:remove()
		end
		self:addItemEx(chest)
		
		-- consume resources
		self:removeForgeDust(forgeData.fusionDustCost)
		self:removeForgeCores(coresCost)
		self:removeTotalMoney(cost)
		
		-- log forge action
		forgeResultData.dustCost = forgeData.fusionDustCost
		forgeResultData.coresCost = coresCost
		forgeResultData.cost = cost
		appendForgeHistory(self:getId(), forgeResultData)
			
		-- send fusion animation
		self:sendForgeResult(FORGE_ACTION_FUSION, FORGE_RESULT_FAILURE, params)
		return
	end

	---- TRANSFER
	function Player:transferTier(item1, item2, cost)
		-- NOTE: no bonuses for transfer
		-- NOTE: transfer is always successful (100% chance)
		local tier = item1:getTier()
		local forgeResultData = {
			action = FORGE_ACTION_TRANSFER,
			success = true,
			itemA = item1:getName(),
			itemB = item2:getName(),
			tier = tier,
			cost = cost
		}
		
		if self:getFreeCapacity() < ItemType(ITEM_FORGE_CHEST):getWeight() then
			-- no cap to carry the chest with forge output
			self:sendDefaultForgeError(FORGE_ERROR_NOTENOUGHCAP)	
		end
		
		local playerBP = self:getSlotItem(CONST_SLOT_BACKPACK)
		if not playerBP or playerBP:getEmptySlots(true) < 1 then
			-- unable to carry the chest
			self:sendDefaultForgeError(FORGE_ERROR_NOTENOUGHROOM)	
		end
		
		-- generate chest
		local chest = Game.createItem(ITEM_FORGE_CHEST)
		
		--  forge data for output message
		local params = {
			startClientId = item1:getType():getClientId(),
			startTier = tier,
			outputClientId = item2:getType():getClientId(),
			outputTier = tier - 1,
			bonusType = 0,
		}
		
		-- transfer the tier
		item1:setTier(0)
		item2:setTier(tier - 1)
		item1:moveTo(chest)
		item2:moveTo(chest)
		self:addItemEx(chest)
		
		-- consume resources
		self:removeForgeDust(forgeData.transferDustCost)
		self:removeForgeCores(1)
		self:removeTotalMoney(cost)
		
		-- log forge action
		appendForgeHistory(self:getId(), forgeResultData)
		
		-- send animation
		self:sendForgeResult(FORGE_ACTION_TRANSFER, FORGE_RESULT_SUCCESS, params)
	end
end

-- forge search
local function fusionSearch(item, itemId, tier)
	local mainCondition = item:getId() == itemId and item:getTier() == tier
	if not forgeData.allowCustomItemFusion then
		mainCondition = mainCondition and item:isMarketable()
	end
	
	return mainCondition
end

local function transferSearch(item, itemId, tier)
	local mainCondition = item:getId() == itemId and item:getTier() == tier
	if not forgeData.allowCustomItemTransfer then
		mainCondition = mainCondition and item:isMarketable()
	end
	
	return mainCondition
end

-- queryFunc(item) - function that will be used for search
-- count to find
function Container:getItemsByQuery(count, queryFunc, ...)
	local response = {}
	local resultingCount = 0
	if count == 0 then
		return response, resultingCount
	end
	
	for _, item in pairs(self:getItems(true)) do
		if queryFunc(item, ...) then
			response[#response + 1] = item
			resultingCount = resultingCount + 1 --item:getCount() if stackables get classes in the future
		end
		
		if resultingCount >= count then
			return response, resultingCount
		end
	end
	
	return response, resultingCount
end

-- player requests processors
do
	---- FUSION
	function Player:onFusionRequest(clientId, tier, targetClientId, usesSuccessRateCore, usesTierLossCore)
		if clientId ~= targetClientId then
			-- bad request (fusion has to be two identical items)
			self:sendDefaultForgeError(FORGE_ERROR_BADREQUEST)
			return
		end

		-- check if player has bp
		local playerBP = self:getSlotItem(CONST_SLOT_BACKPACK)
		if not playerBP then
			-- player lost his backpack
			self:sendDefaultForgeError(FORGE_ERROR_NOTENOUGHITEMS)
		end
		
		-- check if item type exists
		local itemType = Game.getItemTypeByClientId(clientId)
		if not itemType then
			-- bad request (client id does not match any item)
			self:sendDefaultForgeError(FORGE_ERROR_BADREQUEST)
			return
		end
		
		-- check if item class is eligible
		local class = itemType:getClassification()
		if class == 0 or class > #forgeMeta then
			-- selected item has unsupported classification
			self:sendDefaultForgeError(FORGE_ERROR_NOTUPGRADEABLE)
			return
		end
		
		-- check if tier can be upgraded
		if tier >= #forgeMeta[class] then
			-- tier too high to upgrade
			self:sendDefaultForgeError(FORGE_ERROR_TIERTOOHIGH)
			return
		end
		
		-- check if player has required resources
		local cost = forgeMeta[class][tier+1]
		if self:getTotalMoney() < cost then
			-- not enough gold
			self:sendDefaultForgeError(FORGE_ERROR_NOTENOUGHGOLD)
			return
		end
		if self:getForgeDust() < forgeData.fusionDustCost then
			-- not enough dust
			self:sendDefaultForgeError(FORGE_ERROR_NOTENOUGHDUST)
			return
		end
		if self:getForgeCores() < usesSuccessRateCore + usesTierLossCore then
			-- selected cores not available
			self:sendDefaultForgeError(FORGE_ERROR_NOTENOUGHCORES)
			return
		end

		-- check if player is near the forge
		if not self:isInForge() then
			-- player is not close enough to the forge
			self:sendDefaultForgeError(FORGE_ERROR_NOTINFORGE)
			return
		end
		
		-- iterate player containers to find items
		local itemsForFusion, itemCount = playerBP:getItemsByQuery(2, fusionSearch, itemType:getId(), tier)
		if itemCount >= 2 then
			-- items found, perform the fusion
			self:fuseItems(itemsForFusion[1], itemsForFusion[2], usesSuccessRateCore, usesTierLossCore, cost)
		end
	end

	---- TRANSFER
	function Player:onForgeTransferRequest(clientId, tier, targetClientId)
		-- check if tier can be transfered
		if tier < 2 then
			-- selected item has unsupported tier
			self:sendDefaultForgeError(FORGE_ERROR_NOTUPGRADEABLE)
		end
		
		-- check if player has bp
		local playerBP = self:getSlotItem(CONST_SLOT_BACKPACK)
		if not playerBP then
			-- player lost his backpack
			self:sendDefaultForgeError(FORGE_ERROR_NOTENOUGHITEMS)
		end
		
		-- check if item types exist
		local fromItem = Game.getItemTypeByClientId(clientId)
		local toItem = Game.getItemTypeByClientId(targetClientId)
		if not (fromItem and toItem) then
			-- bad request (one of client ids does not match any item)
			self:sendDefaultForgeError(FORGE_ERROR_BADREQUEST)
		end
		
		-- check if item classes are eligible
		local fromClass = fromItem:getClassification()
		if fromClass ~= toItem:getClassification() then
			-- classes do not match
			self:sendDefaultForgeError(FORGE_ERROR_NOTUPGRADEABLE)
			return
		end
		if fromClass == 0 or fromClass > #forgeMeta then
			-- selected items have unsupported classification
			self:sendDefaultForgeError(FORGE_ERROR_NOTUPGRADEABLE)
			return
		end
		
		-- check if player has required resources
		local cost = forgeMeta[fromClass][tier]
		if self:getTotalMoney() < cost then
			-- not enough gold
			self:sendDefaultForgeError(FORGE_ERROR_NOTENOUGHGOLD)
			return
		end
		if self:getForgeDust() < forgeData.transferDustCost then
			-- not enough dust
			self:sendDefaultForgeError(FORGE_ERROR_NOTENOUGHDUST)
			return
		end
		if self:getForgeCores() < 1 then -- transfer always costs 1 core
			-- not enough cores
			self:sendDefaultForgeError(FORGE_ERROR_NOTENOUGHCORES)
			return
		end

		-- check if player is near the forge
		if not self:isInForge() then
			-- player is not close enough to the forge
			self:sendDefaultForgeError(FORGE_ERROR_NOTINFORGE)
			return
		end
		
		-- find the items
		local transferItems, itemCount = playerBP:getItemsByQuery(1, transferSearch, fromItem:getId(), tier)
		if itemCount >= 1 then
			local targetItems, targetItemCount = playerBP:getItemsByQuery(1, transferSearch, toItem:getId(), 0)
			if targetItemCount >= 1 then
				-- start the transfer
				self:transferTier(transferItems[1], targetItems[1], cost)
				return
			end
		end
		
		-- items not found
		self:sendDefaultForgeError(FORGE_ERROR_NOTENOUGHITEMS)
		return
	end

	function Player:onResourceConversion(forgeAction)
		local forgeResultData = {
			action = forgeAction,
			success = true
		}
		
		if forgeAction == FORGE_ACTION_DUSTTOSLIVERS then
			-- price check
			local cost = forgeData.sliversDustCost * forgeData.sliversPerConversion
			local dust = self:getForgeDust()
			if cost > dust then
				return self:sendDefaultForgeError(FORGE_ERROR_NOTENOUGHDUST)
			end

			-- conversion (dust to slivers)
			if self:addSlivers(forgeData.sliversPerConversion) then
				self:removeForgeDust(cost)
				self:sendResourceBalance(RESOURCE_FORGE_DUST, dust - cost)
				self:sendResourceBalance(RESOURCE_FORGE_SLIVERS, self:getSlivers())
			end
			
			-- info for action logging
			forgeResultData.cost = cost
			forgeResultData.gained = forgeData.sliversPerConversion
		elseif forgeAction == FORGE_ACTION_SLIVERSTOCORES then
			-- price check
			local slivers = self:getSlivers()
			local cost = forgeData.coreSliversCost
			if cost > slivers then
				return self:sendDefaultForgeError(FORGE_ERROR_NOTENOUGHSLIVERS)
			end
			
			-- conversion (slivers to cores)
			if self:addForgeCores(1) then
				self:removeSlivers(cost)
				self:sendResourceBalance(RESOURCE_FORGE_SLIVERS, slivers - cost)
				self:sendResourceBalance(RESOURCE_FORGE_CORES, self:getForgeCores() + 1)
			end
			
			-- info for action logging
			forgeResultData.cost = cost
			forgeResultData.gained = 1
		else --if forgeAction == FORGE_ACTION_INCREASELIMIT then
			-- max level check
			local playerDustLevel = self:getForgeDustLevel()
			if forgeData.minStoredDustLimit + playerDustLevel >= forgeData.maxStoredDustLimit then
				return self:sendDefaultForgeError(FORGE_ERROR_MAXDUSTLEVELREACHED)
			end
			
			-- integrity check
			local upgradeCost = self:getForgeDustLimit() - forgeData.dustLimitIncreaseCost
			if upgradeCost < 0 then
				return self:sendDefaultForgeError(FORGE_ERROR_BADLEVELINCREASEPRICE)
			end
			
			-- price check
			local dust = self:getForgeDust()
			if upgradeCost > dust then
				return self:sendDefaultForgeError(FORGE_ERROR_NOTENOUGHDUST)
			end
						
			-- upgrade
			self:removeForgeDust(upgradeCost)
			self:setForgeDustLevel(playerDustLevel + 1)
			self:sendForgeUI(true)
			self:sendResourceBalance(RESOURCE_FORGE_DUST, dust - upgradeCost)
			
			-- info for action logging
			forgeResultData.cost = upgradeCost
			forgeResultData.gained = forgeData.minStoredDustLimit + playerDustLevel
		end
		
		-- log forge action
		appendForgeHistory(self:getId(), forgeResultData)
	end
end

-- forge check
function Player:isInForge()
	local playerPos = self:getPosition()
	for deltaX = -1, 1 do
	for deltaY = -1, 1 do
		local pos = Position(playerPos.x + deltaX, playerPos.y + deltaY, playerPos.z)
		local tile = Tile(pos)
		if tile then
			for _, item in pairs(tile:getItems()) do
				local itemId = item:getType():getId()
				if itemId >= ITEM_FORGE_PLACE_FIRST and itemId <= ITEM_FORGE_PLACE_LAST then
					return true
				end
			end
		end
	end
	end
	
	return false
end

-- cache forge ui to reduce about of operations during dust limit upgrades
function NetworkMessage:addAndCacheForgeValue(cid, value, varType)
	ForgeCache[cid][#ForgeCache[cid] + 1] = {value, varType}
	if varType == FORGE_CACHE_TYPE_BYTE then
		self:addByte(value)
	elseif varType == FORGE_CACHE_TYPE_U16 then
		self:addU16(value)
	else
		error("Variable type not supported")
	end
end
