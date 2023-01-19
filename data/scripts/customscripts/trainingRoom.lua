-- Sistema de training rooms para Bercik
local exitEvents = {}
local config = {
	actionId = 54561,
	exitActionId = 54562,

	-- Area
	firstTrainerPos = Position(1793, 1826, 6),
	distanceX = 29,
	distanceY = 20,
	rows = 29,
	columns = 19,
	exitTeleportPos = Position(0, 1, 0), -- relative position from firstTrainerPos

	-- Others
	exitPosition = Position(1121, 959, 7),
	exitPremiumAccountTime = 24 * 60 -- 24 hours
}

local function getTrainerPos()
	for column = 0, config.columns-1 do
		for row = 0, config.rows-1 do
			local trainerPos = config.firstTrainerPos + Position(config.distanceX * row, config.distanceY * column)
			local tile = Tile(trainerPos)
			if tile and tile:getCreatureCount() == 0 then
				return trainerPos
			end
		end
	end
end

local function getFormattedTime(seconds)
	local formattedTime = ""
	local hours = math.floor(seconds / 3600)
	seconds = (seconds % 3600)
	if hours > 0 then
		formattedTime = string.format("%s%d hour%s", formattedTime, hours, (hours > 1 and "s" or ""))
	end
	local minutes = math.floor(seconds / 60)
	seconds = (seconds % 60)
	if minutes > 0 then
		formattedTime = string.format("%s%s%d minute%s", formattedTime, (hours > 0 and " and " or ""), minutes, (minutes > 1 and "s" or ""))
	end
	return formattedTime
end

local function exitEvent(playerId)
	local player = Player(playerId)
	if not player then
		return
	end

	player:getPosition():sendMagicEffect(CONST_ME_POFF)
	player:teleportTo(config.exitPosition, false)
	config.exitPosition:sendMagicEffect(CONST_ME_TELEPORT)
	exitEvents[playerId] = nil
end

local moveEvent = MoveEvent()

function moveEvent.onStepIn(creature, item, pos, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local trainerPos = getTrainerPos()
	if not trainerPos then
		player:sendCancelMessage("Sorry, it is not possible to enter because there is no space.")
		return true
	end

	player:getPosition():sendMagicEffect(CONST_ME_POFF)
	player:teleportTo(trainerPos, false)
	trainerPos:sendMagicEffect(CONST_ME_TELEPORT)
	local isPremium = player:isPremium()
	player:sendTextMessage(MESSAGE_INFO_DESCR, string.format("Time training limit: %s", getFormattedTime(config.exitPremiumAccountTime * 60), (isPremium and "Premium")))
	player:setAfk(true)
	local exitTime = player:isPremium() and config.exitPremiumAccountTime
	local playerId = player:getId()
	exitEvents[playerId] = addEvent(exitEvent, 1000 * 60 * exitTime, playerId)

	local exitTeleportPos = trainerPos + config.exitTeleportPos
	local exitTeleportTile = Tile(exitTeleportPos)
	if exitTeleportTile then
		local magicForcefield = exitTeleportTile:getItemById(1387)
		if magicForcefield then
			magicForcefield:remove()
		end
		
		magicForcefield = Game.createItem(1387, 1, exitTeleportPos)
		if magicForcefield then
			magicForcefield:setAttribute(ITEM_ATTRIBUTE_ACTIONID, config.exitActionId)
		end
	end
	return true
end

moveEvent:aid(config.actionId)
moveEvent:register()

moveEvent = MoveEvent()

function moveEvent.onStepIn(creature, item, pos, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	stopEvent(exitEvents[player:getId()])
	pos:sendMagicEffect(CONST_ME_POFF)
	player:teleportTo(config.exitPosition, false)
	config.exitPosition:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

moveEvent:aid(config.exitActionId)
moveEvent:register()
