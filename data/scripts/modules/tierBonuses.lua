-- memorize eq tier buff values
if not playerTierBonuses then
	playerTierBonuses = {}
end

-- stores eq tier bonuses to update later
function Player:cacheTierBonuses()
	local cid = self:getId()
	playerTierBonuses[cid] = {}
	
	for slotId = CONST_SLOT_FIRST, CONST_SLOT_LAST do
		local slotItem = self:getSlotItem(slotId)
		if slotItem then
			local skillType, amount = slotItem:getType():getTierBonus(slotItem:getTier())
			if skillType > -1 then
				playerTierBonuses[cid][skillType] = (playerTierBonuses[cid][skillType] or 0) + amount * 100
			end
		end
	end
end

-- updates eq tier bonuses (requires caching first)
function Player:updateTierBonuses()
	local cid = self:getId()
	
	-- remove old eq tier bonuses
	for skillType, amount in pairs(playerTierBonuses[cid]) do
		self:addSpecialSkill(skillType, -amount)
	end
	
	-- apply new eq tier bonuses
	for slotId = CONST_SLOT_FIRST, CONST_SLOT_LAST do
		local slotItem = self:getSlotItem(slotId)
		if slotItem then
			local skillType, amount = slotItem:getType():getTierBonus(slotItem:getTier())
			if skillType > -1 then
				self:addSpecialSkill(skillType, amount * 100)
			end
		end
	end
end

-- store stats before trading
do
	local ec = EventCallback
	ec.onTradeAccept = function(self, target, item, targetItem)
		self:cacheTierBonuses()
		target:cacheTierBonuses()
		return true
	end
	ec:register()
end

-- apply stats on trade
do
	local ec = EventCallback
	ec.onTradeCompleted = function(self, target, item, targetItem, isSuccess)
		if isSuccess then
			self:updateTierBonuses()
			target:updateTierBonuses()
		end
	end
	ec:register()
end

-- apply stats on equip/deequip
do
	local ec = EventCallback
	ec.onItemMoved = function(self, item, count, fromPosition, toPosition, fromCylinder, toCylinder)
		-- equip
		if toPosition.x == CONTAINER_POSITION and toPosition.y < CONST_SLOT_LAST + 1 then
			local slotItem = self:getSlotItem(toPosition.y)
			if not (slotItem and slotItem:isContainer()) then -- prevent counting moving to backpack
				local skillType, amount = item:getType():getTierBonus(item:getTier())
				if skillType > -1 then
					self:addSpecialSkill(skillType, amount * 100)
				end		
			end
		end
		
		-- deEquip
		if fromPosition.x == CONTAINER_POSITION and fromPosition.y < CONST_SLOT_LAST + 1 then
			local skillType, amount = item:getType():getTierBonus(item:getTier())
			if skillType > -1 then
				self:addSpecialSkill(skillType, -amount * 100)
			end
		end
		
		self:cacheTierBonuses()
		return true
	end
	ec:register()
end

-- apply stats on login
do
	local creatureevent = CreatureEvent("tierSystemLogin")
	function creatureevent.onLogin(player)
		for slotId = CONST_SLOT_FIRST, CONST_SLOT_LAST do
			local slotItem = player:getSlotItem(slotId)
			if slotItem then
				local skillType, amount = slotItem:getType():getTierBonus(slotItem:getTier())
				if skillType > -1 then
					player:addSpecialSkill(skillType, amount * 100)
				end
			end
		end
		
		player:cacheTierBonuses()
		return true
	end
	creatureevent:register()
end

-- override setTier to apply bonuses on equipped
Item.legacySetTier = Item.legacySetTier or Item.setTier
function Item:setTier(newTier)
	local player = Player(self:getParent())

	if player then
		local skillType, amount = self:getType():getTierBonus(self:getTier())
		if skillType > -1 then
			player:addSpecialSkill(skillType, -amount * 100)
		end
	end
	
	local ret = self:legacySetTier(newTier)
	
	if player then
		local skillType, amount = self:getType():getTierBonus(self:getTier())
		if skillType > -1 then
			player:addSpecialSkill(skillType, amount * 100)
		end
	end
	
	return ret
end

if TIERSYSTEM_IS_RELOAD then
	for _, player in pairs(Game.getPlayers()) do
		player:updateTierBonuses()
		player:cacheTierBonuses()
	end
else
	-- next load is reload
	TIERSYSTEM_IS_RELOAD = true
end