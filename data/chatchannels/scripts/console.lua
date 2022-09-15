function canJoin(player)
	return Game.isDevMode() and player:getAccountType() >= ACCOUNT_TYPE_GOD
end

local green = {CONSOLEMESSAGE_TYPE_STARTUP, CONSOLEMESSAGE_TYPE_STARTUP_SPECIAL}
local yellow = {CONSOLEMESSAGE_TYPE_WARNING}
local red = {CONSOLEMESSAGE_TYPE_ERROR, CONSOLEMESSAGE_TYPE_BROADCAST}
local pattern = string.format("%%%s(.-)%%m", string.char(27))
local function showConsoleHistory(playerId)
	local player = Player(playerId)
	if player then
		for _, messageData in pairs(Game.getConsoleHistory()) do
			local channelColor = MESSAGE_PARTY
			local say = false
			if table.contains(green, messageData.type) then
				channelColor = MESSAGE_CHANNEL_MANAGEMENT
			elseif table.contains(yellow, messageData.type) then
				channelColor = TALKTYPE_CHANNEL_Y
				say = true
			elseif table.contains(red, messageData.type) then
				channelColor = TALKTYPE_CHANNEL_R1
				say = true
			end

			local msgToSend = messageData.message:gsub(pattern, "")
			if say then
				player:channelSay(nil, channelColor, msgToSend, CHANNEL_CONSOLE)
			else
				player:sendTextMessage(channelColor, msgToSend, CHANNEL_CONSOLE)
			end
		end
	end
end

function onJoin(player, isReload)
	if not isReload then
		addEvent(showConsoleHistory, 100, player:getId())
	end
	return true
end

local function executeCommand(message)
	os.execute(string.format("%s 1> tmp.txt 2>&1", message))
	local messageCount = 0
	for line in io.lines("tmp.txt") do
		if messageCount < 100 then
			sendChannelMessage(CHANNEL_CONSOLE, TALKTYPE_CHANNEL_O, line)
			messageCount = messageCount + 1
		else
			sendChannelMessage(CHANNEL_CONSOLE, TALKTYPE_CHANNEL_R1, "RESULT LONGER THAN 100 LINES!")
			return
		end
	end
end

function onSpeak(player, type, message)
	if player:getAccountType() < ACCOUNT_TYPE_GOD then
		return false
	end

	local name = player:getName()
	local guid = player:getGuid()
	local ip = Game.convertIpToString(player:getIp())
	local logEntry = string.format("%s (ID: %d | %s): %s\n", name, guid, ip, message)
	
	sendChannelMessage(CHANNEL_CONSOLE, TALKTYPE_CHANNEL_Y, logEntry)
	local f = io.open("data/logs/console_channel.txt", "a+")
	f:write(logEntry)
	f:close()
	addEvent(executeCommand, 100, message)
	return false
end