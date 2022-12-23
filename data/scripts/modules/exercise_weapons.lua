CUSTOM_ATTR_TRAINING_OCCUPIER = 34200

local function isUnoccupiedDummy(player, target)
	if not target:getType():isMovable() then
		return true
	end
	
	local cid = target:getCustomAttribute(CUSTOM_ATTR_TRAINING_OCCUPIER)
	if not cid or cid < 1 then
		return true
	end
	
	local trainingPlayer = Player(cid)
	if trainingPlayer and cid ~= player:getId() and trainingPlayer:getTrainingDummy() == target then
		return false
	end
	
	return true
end

local function initTraining(player, item, target)
	if os.time() < player:getStorageValue(PlayerStorageKeys.trainingWeaponCooldown) then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Please wait a few seconds before selecting a target again.")
		return false
	end
	player:setStorageValue(PlayerStorageKeys.trainingWeaponCooldown, os.time() + 5)
	
	if target and target:isItem() then
		local itemId = target:getType():getId()
		if itemId > 31213 and itemId < 31222 then
			if player:getZone() == ZONE_PROTECTION then
				if isUnoccupiedDummy(player, target) then
					if target:getType():isMovable() then
						target:setCustomAttribute(CUSTOM_ATTR_TRAINING_OCCUPIER, player:getId())
					end
					
					player:startTraining(item, target)
					return true
				end
				
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "This exercise dummy is currently in use.")
			else
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "This exercise dummy can only be used while being in a protection zone.")
			end
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You may only use it on exercise target.")
		end
	end
	
	return false
end

local function isRangedTraining(itemId)
	local t = ItemType(itemId)
	local n = t:getName():lower()
	return n:match("wand") or n:match("rod") or n:match("bow")
end

local trainingWeaponMelee = Action()
function trainingWeaponMelee.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	return initTraining(player, item, target)
end

local trainingWeaponRanged = Action()
function trainingWeaponRanged.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item:getTopParent() ~= player then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Take up the weapon before using it.")
		return false
	end

	if player:getPosition():getDistance(target:getPosition()) > 6 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Stand closer to the target.")
		return false
	end
	
	return initTraining(player, item, target)
end

-- training
for itemId = 31196, 31201 do
	if isRangedTraining(itemId) then
		trainingWeaponRanged:id(itemId)
	else
		trainingWeaponMelee:id(itemId)
	end	
end
-- normal
for itemId = 31208, 31213 do
	if isRangedTraining(itemId) then
		trainingWeaponRanged:id(itemId)
	else
		trainingWeaponMelee:id(itemId)
	end	
end

-- durable, lasting
for itemId = 37935, 37946 do
	if isRangedTraining(itemId) then
		trainingWeaponRanged:id(itemId)
	else
		trainingWeaponMelee:id(itemId)
	end	
end

trainingWeaponRanged:allowFarUse(true)
trainingWeaponRanged:register()
trainingWeaponMelee:register()
