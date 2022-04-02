local storage = 400

local t = TalkAction("/tplook")
t.onSay = function(player, words, param)
	if not player:getGroup():getAccess() then
		return true
	end
	
	local newValue = player:getStorageValue(storage) < 1 and 1 or 0
	player:setStorageValue(storage, newValue)
	player:sendTextMessage(MESSAGE_INFO_DESCR, string.format("onLook teleport %s.", newValue == 1 and "enabled" or "disabled"))
end
t:register()

local ec = EventCallback
ec.onLook = function(self, thing, position, distance, description)
	if self:getGroup():getAccess() and self:getStorageValue(storage) == 1 then
		local tile = Tile(position)
		if not tile then
			Game.createTile(position)
		end
	
		self:teleportTo(position)
	end
	
	return description
end
ec:register()