function sendCraftedOutfitWindowFull(player, param)
	if not player:isAdmin() then
		return true
	end
	
	local currentOutfit = player:getOutfit()
	local m = NetworkMessage()
	m:addByte(0xC8)
	
	-- current outfit
	m:addU16(currentOutfit.lookType)
	m:addByte(currentOutfit.lookHead)
	m:addByte(currentOutfit.lookBody)
	m:addByte(currentOutfit.lookLegs)
	m:addByte(currentOutfit.lookFeet)
	m:addByte(currentOutfit.lookAddons)
	
	-- current mount
	m:addU16(0)
	m:addByte(0)
	m:addByte(0)
	m:addByte(0)
	m:addByte(0)
	
	-- current familiar
	m:addU16(0)
	
	local lookType = tonumber(param)
	if lookType then
		if not table.contains(InvalidLookTypes, lookType) then
			m:addU16(1)
			m:addU16(lookType)
			m:addString("Selected outfit")
			m:addByte(3)
			m:addByte(0)
		else
			player:sendTextMessage(MESSAGE_INFO_DESCR, "This looktype will crash your client.")
			return false
		end
	else
		local realCount = LOOK_TYPE_LAST - #InvalidLookTypes
		
		-- outfits block
		m:addU16(realCount)
		for lookType = 1, LOOK_TYPE_LAST do
			if not table.contains(InvalidLookTypes, lookType) then
				m:addU16(lookType)
				m:addString(tostring(lookType))
				m:addByte(3) -- unlocked addons
				m:addByte(0) -- unlock mode (0 - available, 1 - store (requires u32 offerId after that), 2 - golden outfit tooltip, 3 - royal costume tooltip
			end
		end
	end
	
	-- mounts block
	m:addU16(0)
	
	-- familiars block
	m:addU16(0)
	
	-- flags
	m:addByte(0)
	m:addByte(0)
	
	-- randomize
	m:addByte(0)
	m:sendToPlayer(player)
end

local t = TalkAction("/looktype", "/o", "/outfit")
t.onSay = function(player, words, param)
	sendCraftedOutfitWindowFull(player, param)
end
t:separator(" ")
t:register()
