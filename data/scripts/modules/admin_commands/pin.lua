PinModeStorage = 94999

if not PastDisplayNames then
	PastDisplayNames = {}
end

if not PastPositions then
	PastPositions = {}
end

local talk = TalkAction("/pin")

local function pinLoop(cid)
	local player = Player(cid)
	if not player or player:getStorageValue(PinModeStorage) == -1 then
		return
	end

	local pos = player:getPosition()
	if not (PastPositions[cid] and PastPositions[cid] == pos) then
		player:setDisplayName(string.format("<font color='yellow'>%s %d, %d, %d</font>", string.char(3), pos.x, pos.y, pos.z))
		PastPositions[cid] = pos
	end
	
	addEvent(pinLoop, 100, cid)
end

local function resetLabel(cid)
	local player = Player(cid)
	if not player then
		return
	end
	
	player:setDisplayName(PastDisplayNames[cid] or "")
end

function talk.onSay(player, words, param)
	if player:getAccountType() < ACCOUNT_TYPE_TUTOR then
		return true
	end

	local cid = player:getId()
	
	local newStor = player:getStorageValue(PinModeStorage) == -1 and 1 or -1
	if not PastDisplayNames[cid] then
		newStor = 1
	end
	
	player:setStorageValue(PinModeStorage, newStor)
	if newStor == 1 then
		local rememberName = player:getDisplayName()
		if not rememberName:find(string.char(3)) then
			PastDisplayNames[cid] = rememberName
		end
		pinLoop(cid)
	else
		addEvent(resetLabel, 150, cid)
	end
	
	return false
end

talk:register()
