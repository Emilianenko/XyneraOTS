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

function onLogin(player)
	local serverName = configManager.getString(configKeys.SERVER_NAME)
	local loginStr = "Welcome to " .. serverName .. "!"
	if player:getLastLoginSaved() <= 0 then
		loginStr = loginStr .. " Please choose your outfit."
		player:sendOutfitWindow()
	else
		if loginStr ~= "" then
			player:sendTextMessage(MESSAGE_STATUS_DEFAULT, loginStr)
		end

		loginStr = string.format("Your last visit in %s: %s.", serverName, os.date("%d %b %Y %X", player:getLastLoginSaved()))
	end
	player:sendTextMessage(MESSAGE_STATUS_DEFAULT, loginStr)

	-- Promotion
	local vocation = player:getVocation()
	local promotion = vocation:getPromotion()
	if player:isPremium() then
		local value = player:getStorageValue(PlayerStorageKeys.promotion)
		if value == 1 then
			player:setVocation(promotion)
		end
	elseif not promotion then
		player:setVocation(vocation:getDemotion())
	end

	-- Events
	player:registerEvent("PlayerDeath")
	player:registerEvent("DropLoot")
	
	-- schedule sending less important data
	local cid = player:getId()
	addEvent(sendForgeTypesAsync, 100, cid) -- classification info for market and forge
	addEvent(sendColorTypesAsync, 200, cid) -- message colors meta
	return true
end
