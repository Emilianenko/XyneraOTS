function Player:onBrowseField(position)
	if EventCallback.onBrowseField then
		return EventCallback.onBrowseField(self, position)
	end
	return true
end

function Player:onLook(thing, position, distance)
	local description = ""
	if EventCallback.onLook then
		description = EventCallback.onLook(self, thing, position, distance, description)
	end
	self:sendTextMessage(MESSAGE_INFO_DESCR, description)
end

function Player:onLookInBattleList(creature, distance)
	local description = ""
	if EventCallback.onLookInBattleList then
		description = EventCallback.onLookInBattleList(self, creature, distance, description)
	end
	self:sendTextMessage(MESSAGE_INFO_DESCR, description)
end

function Player:onLookInTrade(partner, item, distance)
	local description = "You see " .. item:getDescription(distance)
	if EventCallback.onLookInTrade then
		description = EventCallback.onLookInTrade(self, partner, item, distance, description)
	end
	self:sendTextMessage(MESSAGE_INFO_DESCR, description)
end

function Player:onLookInShop(itemType, count, npc)
	local description = "You see "
	if EventCallback.onLookInShop then
		description = EventCallback.onLookInShop(self, itemType, count, description, npc)
	end
	
	self:sendTextMessage(MESSAGE_INFO_DESCR, description)
end

function Player:onLookInMarket(itemType, tier)
	if EventCallback.onLookInMarket then
		EventCallback.onLookInMarket(self, itemType, tier)
	end
end

function Player:onMoveItem(item, count, fromPosition, toPosition, fromCylinder, toCylinder)
	-- prevent moving items into corpses
	if toPosition.x == CONTAINER_POSITION and bit.band(toPosition.y, 0x40) ~= 0 then
		local openedContainer = self:getContainerById(toPosition.y - 0x40)
		if openedContainer:isCorpse() then
			return RETURNVALUE_CONTAINERNOTENOUGHROOM
		end
	end
	
	if EventCallback.onMoveItem then
		return EventCallback.onMoveItem(self, item, count, fromPosition, toPosition, fromCylinder, toCylinder)
	end
	
	return RETURNVALUE_NOERROR
end

function Player:onItemMoved(item, count, fromPosition, toPosition, fromCylinder, toCylinder)
	if EventCallback.onItemMoved then
		EventCallback.onItemMoved(self, item, count, fromPosition, toPosition, fromCylinder, toCylinder)
	end
end

function Player:onMoveCreature(creature, fromPosition, toPosition)
	if EventCallback.onMoveCreature then
		return EventCallback.onMoveCreature(self, creature, fromPosition, toPosition)
	end
	return true
end

function Player:onReportRuleViolation(targetName, reportType, reportReason, comment, translation)
	if EventCallback.onReportRuleViolation then
		EventCallback.onReportRuleViolation(self, targetName, reportType, reportReason, comment, translation)
	end
end

function Player:onReportBug(message, position, category)
	if EventCallback.onReportBug then
		return EventCallback.onReportBug(self, message, position, category)
	end
	return true
end

function Player:onTurn(direction)
	if EventCallback.onTurn then
		return EventCallback.onTurn(self, direction)
	end
	return true
end

function Player:onTradeRequest(target, item)
	if EventCallback.onTradeRequest then
		return EventCallback.onTradeRequest(self, target, item)
	end
	return true
end

function Player:onTradeAccept(target, item, targetItem)
	if EventCallback.onTradeAccept then
		return EventCallback.onTradeAccept(self, target, item, targetItem)
	end
	return true
end

function Player:onTradeCompleted(target, item, targetItem, isSuccess)
	if EventCallback.onTradeCompleted then
		EventCallback.onTradeCompleted(self, target, item, targetItem, isSuccess)
	end
end

function Player:onPodiumRequest(item)
	local podium = Podium(item.uid)
	if not podium then
		self:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
		return
	end
	
	self:sendEditPodium(item)
end

function Player:onPodiumEdit(item, outfit, direction, isVisible)
	local podium = Podium(item.uid)
	if not podium then
		self:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
		return
	end
	
	if not self:getGroup():getAccess() then
		-- check if the player is in melee range
		if getDistanceBetween(self:getPosition(), item:getPosition()) > 1 then
			self:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
			return
		end
		
		-- reset outfit if unable to wear
		if not self:canWearOutfit(outfit.lookType, outfit.lookAddons) then
			outfit.lookType = 0
		end
		
		-- reset mount if unable to ride
		local mount = Game.getMountIdByLookType(outfit.lookMount)
		if not (mount and self:hasMount(mount)) then
			outfit.lookMount = 0
		end
	end

	local podiumOutfit = podium:getOutfit()
	local playerOutfit = self:getOutfit()
	
	-- use player outfit if podium is empty
	if podiumOutfit.lookType == 0 then
		podiumOutfit.lookType = playerOutfit.lookType
		podiumOutfit.lookHead = playerOutfit.lookHead
		podiumOutfit.lookBody = playerOutfit.lookBody
		podiumOutfit.lookLegs = playerOutfit.lookLegs
		podiumOutfit.lookFeet = playerOutfit.lookFeet
		podiumOutfit.lookAddons = playerOutfit.lookAddons
	end

	-- set player mount colors podium is empty	
	if podiumOutfit.lookMount == 0 then
		podiumOutfit.lookMount = playerOutfit.lookMount
		podiumOutfit.lookMountHead = playerOutfit.lookMountHead
		podiumOutfit.lookMountBody = playerOutfit.lookMountBody
		podiumOutfit.lookMountLegs = playerOutfit.lookMountLegs
		podiumOutfit.lookMountFeet = playerOutfit.lookMountFeet
	end
	
	-- "outfit" box checked
	if outfit.lookType ~= 0 then
		podiumOutfit.lookType = outfit.lookType
		podiumOutfit.lookHead = outfit.lookHead
		podiumOutfit.lookBody = outfit.lookBody
		podiumOutfit.lookLegs = outfit.lookLegs
		podiumOutfit.lookFeet = outfit.lookFeet
		podiumOutfit.lookAddons = outfit.lookAddons
	end

	-- "mount" box checked
	if outfit.lookMount ~= 0 then
		podiumOutfit.lookMount = outfit.lookMount
		podiumOutfit.lookMountHead = outfit.lookMountHead
		podiumOutfit.lookMountBody = outfit.lookMountBody
		podiumOutfit.lookMountLegs = outfit.lookMountLegs
		podiumOutfit.lookMountFeet = outfit.lookMountFeet
	end

	-- prevent invisible podium state
	if outfit.lookType == 0 and outfit.lookMount == 0 then
		isVisible = true
	end
	
	-- save player choices		
	podium:setFlag(PODIUM_SHOW_PLATFORM, isVisible)
	podium:setFlag(PODIUM_SHOW_OUTFIT, outfit.lookType ~= 0)
	podium:setFlag(PODIUM_SHOW_MOUNT, outfit.lookMount ~= 0)
	podium:setDirection(direction < DIRECTION_NORTHEAST and direction or DIRECTION_SOUTH)
	podium:setOutfit(podiumOutfit)
end

local soulCondition = Condition(CONDITION_SOUL, CONDITIONID_DEFAULT)
soulCondition:setTicks(4 * 60 * 1000)
soulCondition:setParameter(CONDITION_PARAM_SOULGAIN, 1)

local function getSpentStaminaMinutes(player)
	local playerId = player:getId()
	if not nextUseStaminaTime[playerId] then
		nextUseStaminaTime[playerId] = 0
	end

	local currentTime = os.time()
	local timePassed = currentTime - nextUseStaminaTime[playerId]
	if timePassed <= 0 then
		return 0
	end
	
	return timePassed > 60 and 2 or 1
end

function useStamina(player)
	local staminaMinutes = player:getStamina()
	if staminaMinutes == 0 then
		if EventCallback.onUseStamina then
			local spentMinutes = getSpentStaminaMinutes(player)
			if spentMinutes > 0 then
				staminaMinutes = EventCallback.onUseStamina(player, staminaMinutes, spentMinutes)
				player:setStamina(staminaMinutes)
			end
		end
		
		return
	end

	local spentMinutes = getSpentStaminaMinutes(player)
	if spentMinutes == 0 then
		return
	elseif spentMinutes > 1 then
		if staminaMinutes > 2 then
			staminaMinutes = staminaMinutes - 2
		else
			staminaMinutes = 0
		end
		nextUseStaminaTime[player:getId()] = os.time() + 120
	else
		staminaMinutes = staminaMinutes - 1
		nextUseStaminaTime[player:getId()] = os.time() + 60
	end
	
	if EventCallback.onUseStamina then
		staminaMinutes = EventCallback.onUseStamina(player, staminaMinutes, spentMinutes)
	end
	
	player:setStamina(staminaMinutes)
end

function Player:onGainExperience(source, exp, rawExp)
	if not source or source:isPlayer() then
		return exp
	end

	-- Soul regeneration
	local vocation = self:getVocation()
	if self:getSoul() < vocation:getMaxSoul() and exp >= self:getLevel() then
		soulCondition:setParameter(CONDITION_PARAM_SOULTICKS, vocation:getSoulGainTicks() * 1000)
		self:addCondition(soulCondition)
	end

	-- Apply experience stage multiplier
	exp = exp * Game.getExperienceStage(self:getLevel())

	-- Stamina modifier
	if configManager.getBoolean(configKeys.STAMINA_SYSTEM) then
		useStamina(self)

		local staminaMinutes = self:getStamina()
		if staminaMinutes > 2340 and self:isPremium() then
			exp = exp * 1.5
		elseif staminaMinutes <= 840 then
			exp = exp * 0.5
		end
	end

	return EventCallback.onGainExperience and EventCallback.onGainExperience(self, source, exp, rawExp) or exp
end

function Player:onLoseExperience(exp)
	return EventCallback.onLoseExperience and EventCallback.onLoseExperience(self, exp) or exp
end

function Player:onGainSkillTries(skill, tries)
	if APPLY_SKILL_MULTIPLIER == false then
		return EventCallback.onGainSkillTries and EventCallback.onGainSkillTries(self, skill, tries) or tries
	end

	if skill == SKILL_MAGLEVEL then
		tries = tries * configManager.getNumber(configKeys.RATE_MAGIC)
		return EventCallback.onGainSkillTries and EventCallback.onGainSkillTries(self, skill, tries) or tries
	end
	tries = tries * configManager.getNumber(configKeys.RATE_SKILL)
	return EventCallback.onGainSkillTries and EventCallback.onGainSkillTries(self, skill, tries) or tries
end

function Player:onWrapItem(item)
	if EventCallback.onWrapItem then
		EventCallback.onWrapItem(self, item)
	end
end

function Player:onQuickLoot(position, stackPos, spriteId)
	if EventCallback.onQuickLoot then
		EventCallback.onQuickLoot(self, position, stackPos, spriteId)
	end
end

function Player:onInventoryUpdate(item, slot, equip)
	if EventCallback.onInventoryUpdate then
		EventCallback.onInventoryUpdate(self, item, slot, equip)
	end
end

-- begin inspection feature
function Player:onInspectItem(item)
	if EventCallback.onInspectItem then
		EventCallback.onInspectItem(self, item)
	end
end

function Player:onInspectTradeItem(tradePartner, item)
	if EventCallback.onInspectTradeItem then
		EventCallback.onInspectTradeItem(self, tradePartner, item)
	end
end

function Player:onInspectNpcTradeItem(npc, itemId)
	if EventCallback.onInspectNpcTradeItem then
		EventCallback.onInspectNpcTradeItem(self, npc, itemId)
	end
end

function Player:onInspectCyclopediaItem(itemId)
	if EventCallback.onInspectCyclopediaItem then
		EventCallback.onInspectCyclopediaItem(self, itemId)
	end
end
-- end inspection feature

function Player:onMinimapQuery(position)
	if EventCallback.onMinimapQuery then
		EventCallback.onMinimapQuery(self, position)
	end
	
	-- teleport action for server staff
	-- ctrl + shift + click on minimap
	if not self:getGroup():getAccess() then
		return
	end
	
	local tile = Tile(position)
	if not tile then
		Game.createTile(position)
	end
	
	self:teleportTo(position)
end

function Player:onGuildMotdEdit(message)
	return message
end

function Player:onSetLootList(lootList, mode)
	if EventCallback.onSetLootList then
		EventCallback.onSetLootList(self, lootList, mode)
	end
end

function Player:onManageLootContainer(item, mode, lootType)
	if EventCallback.onManageLootContainer then
		EventCallback.onManageLootContainer(self, item, mode, lootType)
	end
end

function Player:onFuseItems(fromItemType, fromTier, toItemType, successCore, tierLossCore)
	if EventCallback.onFuseItems then
		EventCallback.onFuseItems(self, fromItemType, fromTier, toItemType, successCore, tierLossCore)
	end
end

function Player:onTransferTier(fromItemType, fromTier, toItemType)
	if EventCallback.onTransferTier then
		EventCallback.onTransferTier(self, fromItemType, fromTier, toItemType)
	end
end

function Player:onForgeConversion(conversionType)
	if EventCallback.onForgeConversion then
		EventCallback.onForgeConversion(self, conversionType)
	end
end

function Player:onForgeHistoryBrowse(page)
	if EventCallback.onForgeHistoryBrowse then
		EventCallback.onForgeHistoryBrowse(self, page)
	end
end

function Player:onRequestPlayerTab(target, infoType, currentPage, entriesPerPage)
	if EventCallback.onRequestPlayerTab then
		EventCallback.onRequestPlayerTab(self, target, infoType, currentPage, entriesPerPage)
	end
end

function Player:onBestiaryInit()
	if EventCallback.onBestiaryInit then
		EventCallback.onBestiaryInit(self)
	end
end

function Player:onBestiaryBrowse(category, raceList)
	if EventCallback.onBestiaryBrowse then
		EventCallback.onBestiaryBrowse(self, category, raceList)
	end
end

function Player:onBestiaryRaceView(raceId)
	if EventCallback.onBestiaryRaceView then
		EventCallback.onBestiaryRaceView(self, raceId)
	end
end

function Player:onFrameView(targetId)
	local player = Player(targetId)
	if player and player:isAdmin() then
		return 3
	end

	return 255
end

-- begin onConnect
local function sendForgeTypesAsync(cid)
	local p = Player(cid)
	if p and not p:isRemoved() then
		p:sendItemClasses()
	end
end

local function sendColorTypesAsync(cid)
	local p = Player(cid)
	if p and not p:isRemoved() then
		p:sendMessageColorTypes()
	end
end

function Player:onConnect(isLogin)
	-- schedule sending less important data
	local cid = self:getId()
	addEvent(sendForgeTypesAsync, 100, cid) -- classification info for market and forge
	addEvent(sendColorTypesAsync, 200, cid) -- message colors meta
	
	if EventCallback.onConnect then
		EventCallback.onConnect(self, isLogin)
	end
end
-- end onConnect

-- begin extended protocol
packetEvents = {}
function getPacketEvent(recvbyte)
	return packetEvents[recvbyte]
end

function setPacketEvent(recvbyte, callback)
	if tonumber(recvbyte) then
		packetEvents[tonumber(recvbyte)] = callback
		return true
	end
	
	return false
end

function callPacketEvent(player, recvbyte, networkMessage)
	if packetEvents[recvbyte] then
		return packetEvents[recvbyte](player, recvbyte, networkMessage)
	end
	
	return false
end

function Player:onExtendedProtocol(recvbyte, networkMessage)
	-- unhnadled login packets:
	-- 0xCE -- allow everyone to inspect me(?)
	-- 0xD0 -- quest tracker
	callPacketEvent(self, recvbyte, networkMessage)
end
-- end extended protocol
