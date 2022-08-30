-- click on anything: memorizes an item
-- click on podium: sets an item to clicked podium

local podiumRune = Action()
function podiumRune.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target and target:isItem() then
		if target:isPodium() then
			local clientId = player:getStorageValue(PlayerStorageKeys.podiumRune)
			if clientId > 0 then		
				target:setFlag(PODIUM_SHOW_PLATFORM, true)
				target:setFlag(PODIUM_SHOW_OUTFIT, true)
				target:setFlag(PODIUM_SHOW_MOUNT, false)
				target:setOutfit({lookTypeEx = clientId})
				target:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
			end
		else
			local itemType = target:getType()
			if itemType:isMovable() and itemType:isPickupable() or player:isAdmin() then
				player:setStorageValue(PlayerStorageKeys.podiumRune, target:getClientId())
				player:sendTextMessage(MESSAGE_INFO_DESCR, "Item selected.")
				target:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
			else
				player:sendTextMessage(MESSAGE_INFO_DESCR, "You cannot select this item.")
			end
		end
	end

	return true
end
podiumRune:id(2282)
podiumRune:register()
