--[[
    Credits: Sarah Wesker
    Version: 1.2
    Compat: TFS 1.3
    Create: December 2020
]]--

local config = {
    miscellaneous = {
        name = "FireStorm", -- event name
        talkaction = "!firestorm", -- Talkaction words
        -->> These two functions are compatible with newer versions of TFS Eyes o.o <<-
        canPushPlayers = false, -- Allow players within the event to push each other?
        canMoveItems = false, -- Allow moving items within the event?
        enterOnlyInPzTile = true
    },
    start = {
        time = "22:53:00", -- time to start event each day
        waiting = '30s' -- wait player to enter event, examples: 10s -> 10 seconds | 2m -> 2 minutes
    },
    area = {
        center = Position(902, 807, 7), -- center room event
        radius = {
            x = 23, -- radius X
            y = 21 -- radius Y
        }
    },
    players = {
        min = 2, -- min required
        max = 10, -- max players in the evento
        corpseId = 6325, -- corpse id :v
        storage = 7777 -- storage, to remove players from the event in case they get trapped! (it should never happen)
    },
    state = {
        type = 'stoped', -- no edit!
        debug = false -- not use in production
    },
    waves = { -- Wave properties in the event
        interval = 3000, -- event speed
        dificulty = 1, -- default start dificulty
        distanceEffect = CONST_ANI_FIRE, -- rain effect
        impactEffect = CONST_ME_FIREAREA, -- impact effect
        warningEffect = CONST_ME_HITBYFIRE, -- warning effect
        iDWhenWaves = { waves = 5, increase = 0.2 } -- every 5 waves, increase the difficulty 0.2
    },
    rewardBag = 44577, -- Reward bag id
    rewards = { -- In this table, you can add the rewards, as are the example:
        { itemId = 2160, count = 100, chance = 100 },
        { itemId = 25172, count = 10, chance = 70 },
        { itemId = 39765, count = 5, chance = 50 },
        { itemId = 39766, count = 3, chance = 30 },
        { itemId = 25377, count = 10, chance = 70 }
    },
    cache = { -- This table should not be modified for anything
        eventIds = {},
        players = {},
        tiles = {},
        tileCount = 0,
        waves = 0,
        dificulty = 0
    }
}

_FSE = {}

function _FSE.isWalkable(x, y, z)
    local tile = Tile(x, y, z)
    if not tile or tile:hasFlag(TILESTATE_FLOORCHANGE) then
        return false
    end

    local ground = tile:getGround()
    if not ground or ground:hasProperty(CONST_PROP_BLOCKSOLID) then
        return false
    end

    local items = tile:getItems()
    for i = 1, tile:getItemCount() do
        local item = items[i]
        local itemType = item:getType()
        if itemType:getType() ~= ITEM_TYPE_MAGICFIELD and not itemType:isMovable() and item:hasProperty(CONST_PROP_BLOCKSOLID) then
            return false
        end
    end
    return tile
end

local function shuffle(tbl)
    for i = #tbl, 2, -1 do
        local j = math.random(i)
        tbl[i], tbl[j] = tbl[j], tbl[i]
    end
end

local function loadTiles()
    config.cache.tiles = {}
    config.cache.tileCount = 0
    for x = config.area.center.x - config.area.radius.x, config.area.center.x + config.area.radius.x do 
        for y = config.area.center.y - config.area.radius.y, config.area.center.y + config.area.radius.y do
            local tile = _FSE.isWalkable(x, y, config.area.center.z)
            if tile then
                table.insert(config.cache.tiles, tile)
                config.cache.tileCount = config.cache.tileCount +1
            end
        end
    end
    shuffle(config.cache.tiles)
end

if not Container.getItems then
    function Container.getItems(self, array)
        local array = array or {}
        for slot = 0, self:getCapacity() - 1 do
            local item = self:getItem(slot)
            if item and item:isContainer() then
                array = item:getItems(array)
            elseif item then
                array[#array +1] = item
            end
        end
        return array
    end
end

local function formatTime(seconds)
    if seconds <= 0 then return '0s' end
    local days = math.floor(seconds / 86400)
    seconds = (seconds % 86400)
    local hours = math.floor(seconds / 3600)
    seconds = (seconds % 3600)
    local minutes = math.floor(seconds / 60)
    seconds = (seconds % 60)
    local result = ''
    if days >= 1 then result = string.format("%s%u days", result, days) end
    if hours >= 1 then result = string.format("%s%s%u hours", result, (days > 0 and ' ' or ''), hours) end
    if minutes >= 1 then result = string.format("%s%s%u minutes", result, (hours > 0 and ' ' or ''), minutes) end
    if seconds >= 1 then result = string.format("%s%s%u seconds", result, (minutes > 0 and ' ' or ''), seconds) end
    return result
end

local function getTime(str)
    local seconds = str:match('(%d+)s') or 0
    local minutes = str:match('(%d+)m') or 0
    local hours = str:match('(%d+)h') or 0
    return seconds, minutes, hours
end

function _FSE.debug(message, player)
    local errorMsg = string.format("[%s - Debug] %s", config.miscellaneous.name, message)
    if player then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, errorMsg)
    end
end

function _FSE.eventSay(message)
    Game.broadcastMessage(string.format("%s says:\n%s", config.miscellaneous.name, message), MESSAGE_EVENT_ADVANCE)
end

function _FSE.sayToPlayers(message)
    for _, playerId in pairs(config.cache.players) do
        local player = Player(playerId)
        if player then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("%s says:\n%s", config.miscellaneous.name, message))
        end
    end
end

function _FSE.removeCachePlayer(player)
    local playerId = player:getId()
    for index, pid in pairs(config.cache.players) do
        if pid == playerId then
            table.remove(config.cache.players, index)
            return true
        end
    end
    return false
end

function _FSE.finish()
    local winner = Player(config.cache.players[1])
    if winner then
        stopEvent(config.cache.eventIds['looping'])
        stopEvent(config.cache.eventIds['warningLooping'])
        winner:getPosition():sendMagicEffect(CONST_ME_TUTORIALSQUARE)
        winner:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Congratulations, you are the winner!")
        _FSE.eventSay(string.format("The player %s is the winner!", winner:getName()))
        config.cache.eventIds['winner'] = addEvent(_FSE.sendRewards, 3000)
    else
        _FSE.close()
    end
end

function _FSE.sendRewards()
    local winner = Player(config.cache.players[1])
    if not winner then
        _FSE.close()
        return
    end
    local bag = Game.createItem(config.rewardBag, 1)
    if bag then
        for _, reward in pairs(config.rewards) do
            if reward.chance >= math.random(1, 100) then
                bag:addItem(reward.itemId, reward.count, INDEX_WHEREEVER, FLAG_NOLIMIT)
            end
        end
        local inbox = winner:getInbox()
        if inbox then
            local description, items = "You rewards: ", bag:getItems()
            for _, item in pairs(items) do
                description = string.format("%s%d %s%s", description, item:getCount(), item:getName(), (_ == #items and '.' or ', '))
            end
            inbox:addItemEx(bag, INDEX_WHEREEVER, FLAG_NOLIMIT)
            winner:sendTextMessage(MESSAGE_INFO_DESCR, description..'\nCheck your depot inbox.')
        end
    end
    _FSE.close()
end

function _FSE.killPlayer(player)
    if not _FSE.removeCachePlayer(player) and config.state.debug then
        _FSE.debug(string.format("The player %s could not be removed from the cache, this is weird.", player:getName()))
    end
    local playerPos = player:getPosition()
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You are burned.")
    _FSE.resetPlayer(player)
    local corpse = Game.createItem(config.players.corpseId, 1, playerPos)
    if corpse then
        corpse:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, string.format("%s ashes.", player:getName()))
    end
end

function _FSE.resetPlayer(player)
    player:setStorageValue(config.players.storage, -1)
    local town = player:getTown()
    if not town then town = Town(1) end
    player:getPosition():sendMagicEffect(CONST_ME_POFF)
    local townPos = town:getTemplePosition()
    player:teleportTo(townPos)
    townPos:sendMagicEffect(CONST_ME_TELEPORT)
end

function _FSE.cleanCorpses()
    for _, tile in pairs(config.cache.tiles) do
        local corpse = tile:getItemById(config.players.corpseId)
        if corpse then
            corpse:remove()
        end
        local creatures = tile:getCreatures()
        for _, creature in pairs(creatures) do
            if creature:isPlayer() then
                _FSE.resetPlayer(creature)
            end
        end
    end
end

function _FSE.checkWaiting()
    if #config.cache.players >= config.players.min then
        _FSE.eventPreparing()
        return
    end
    config.state.type = "stoped"
    _FSE.eventSay("The event has been closed due to lack of participants.")
    _FSE.kickPlayers()
end

function _FSE.kickPlayers()
    for _, playerId in pairs(config.cache.players) do
        local player = Player(playerId)
        if player then
            _FSE.resetPlayer(player)
        end
    end
    config.cache.players = {}
end

function _FSE.kickPlayer(player)
    local index = _FSE.isPlayerExist(player)
    if not index then
        return false
    end
    _FSE.resetPlayer(player)
    table.remove(config.cache.players, index)
    return true
end

function _FSE.isPlayerExist(player)
    local playerId = player:getId()
    for _, pid in pairs(config.cache.players) do
        if playerId == pid then
            return _
        end
    end
    return false
end

function _FSE.joinPlayer(player)
    table.insert(config.cache.players, player:getId())
    player:setStorageValue(config.players.storage, 1)
    player:getPosition():sendMagicEffect(CONST_ME_POFF)
    player:teleportTo(config.area.center)
    config.area.center:sendMagicEffect(CONST_ME_TELEPORT)
    if #config.cache.players >= config.players.max then
        local waitingEventId = config.cache.eventIds['waiting']
        if waitingEventId then
            stopEvent(waitingEventId)
            config.cache.eventIds['waiting'] = nil
        end
        _FSE.eventPreparing()
    end
    return true
end

function _FSE.eventPreparing()
    _FSE.eventSay("We are ready to start, get ready...")
    config.state.type = "preparing"
    config.cache.eventIds['warningLooping'] = addEvent(_FSE.eventWaveWarningLooping, 6000)
end


function _FSE.eventWaveWarningLooping()
    if config.cache.dificulty == 0 then
        config.state.type = "started"
        config.cache.dificulty = config.waves.dificulty
        if config.state.debug then
            _FSE.debug(string.format("load default dificulty: %d", config.cache.dificulty))
        end
    elseif #config.cache.players == 1 then
        _FSE.finish()
        return
    end
    local affectedTileCount = math.min(config.cache.tileCount, (config.cache.tileCount / 6) * config.cache.dificulty)
    local affectedTileList = {}
    local start = os.mtime()
    while affectedTileCount > 0 do
        if os.mtime() - start > 20 then
            break
        end
        local rNumber = math.random(1, config.cache.tileCount)
        if not table.contains(affectedTileList, rNumber) then
            table.insert(affectedTileList, rNumber)
            affectedTileCount = affectedTileCount -1
        end
    end
    for _, tNumber in pairs(affectedTileList) do
        local tile = config.cache.tiles[tNumber]
        tile:getPosition():sendMagicEffect(config.waves.warningEffect)
    end
    local interval = math.max(500, config.waves.interval / config.cache.dificulty)
    config.cache.eventIds['looping'] = addEvent(_FSE.eventWaveLooping, interval, affectedTileList, interval)
end

function _FSE.eventWaveLooping(affectedTileList, interval)
    for _, tNumber in pairs(affectedTileList) do
        local tile = config.cache.tiles[tNumber]
        local position = tile:getPosition()
        local fromPos = Position(position.x -5, position.y -5, position.z)
        fromPos:sendDistanceEffect(position, config.waves.distanceEffect)
        position:sendMagicEffect(config.waves.impactEffect)
        local creatures = tile:getCreatures()
        for _, creature in pairs(creatures) do
            if creature:isPlayer() then
                _FSE.killPlayer(creature)
                if #config.cache.players == 1 then
                    _FSE.finish()
                    return
                end
            end
        end
    end
    -- increase wave count and dificulty
    if config.cache.waves > 0 and (config.cache.waves % config.waves.iDWhenWaves.waves == 0) then
        config.cache.dificulty = config.cache.dificulty + config.waves.iDWhenWaves.increase
        _FSE.sayToPlayers("The difficulty has increased!")
    end
    config.cache.waves = config.cache.waves +1
    config.cache.eventIds['warningLooping'] = addEvent(_FSE.eventWaveWarningLooping, interval)
end

function _FSE.init()
    if config.cache.tileCount == 0 then
        loadTiles()
        if config.state.debug then
            _FSE.debug(string.format("loaded %d tiles.", config.cache.tileCount))
        end
    end
    _FSE.cleanCorpses()
    local s, m ,h = getTime(config.start.waiting)
    local tseconds = s+(m*60)+(h*60*60)
    _FSE.eventSay(string.format("The event will start in %s, use the command %s to enter.", formatTime(tseconds), config.miscellaneous.talkaction))
    config.cache.eventIds['waiting'] = addEvent(_FSE.checkWaiting, tseconds * 1000)
    config.state.type = "open"
    return true
end

function _FSE.close()
    for _, eventId in pairs(config.cache.eventIds) do
        stopEvent(eventId)
    end
    config.cache.waves = 0
    config.cache.dificulty = 0
    config.cache.eventIds = {}
    _FSE.kickPlayers()
    config.state.type = "close"
end

local global = GlobalEvent("FireStorm")
global.onTime = _FSE.init
global:time(config.start.time)
global:register()

local talk = TalkAction(config.miscellaneous.talkaction)
function talk.onSay(player, words, param)
    if player:getGroup():getAccess() then
        if param == "open" then
            if table.contains({'open', 'started', 'preparing'}, config.state.type) then
                player:sendCancelMessage("The event is now open.")
            else
                _FSE.init()
            end
            return false
        elseif param == "close" then
            if table.contains({'close', 'stoped'}, config.state.type) then
                player:sendCancelMessage("The event is already closed.")
            else
                _FSE.close()
            end
            return false
        end
    end
    if config.miscellaneous.enterOnlyInPzTile then
        if not player:getTile():hasFlag(TILESTATE_PROTECTIONZONE) then
            player:sendCancelMessage("You can enter only in PZ.")
            return false
        end
    end
    if table.contains({'back', 'exit'}, param:lower()) then
        if table.contains({'preparing', 'started'}, config.state.type) then
            player:sendCancelMessage("Sorry, but the event already started.")
        elseif not _FSE.kickPlayer(player) then
            player:sendCancelMessage("Sorry, but you are not at the event.")
        else
            player:sendCancelMessage("You have left the event.")
        end
        return false
    end
    if _FSE.isPlayerExist(player) then
        player:sendCancelMessage("Sorry, you're already inside the event.")
        return false
    end
    if config.state.type == "open" then
        if not _FSE.joinPlayer(player) then
            player:sendCancelMessage("Sorry, there are no more spaces.")
        end
    elseif table.contains({'close', 'stoped'}, config.state.type) then
        player:sendCancelMessage("Sorry, but the event is closed.")
    else
        player:sendCancelMessage("Sorry, but the event is running.")
    end
    return false
end

talk:separator(" ")
talk:register()

local cEvent = CreatureEvent("FireStorm")
function cEvent.onLogin(player)
    if player:getStorageValue(config.players.storage) == 1 then
        _FSE.resetPlayer(player)
    end
    return true
end
cEvent:register()

local cEvent = CreatureEvent("FireStormLogout")
function cEvent.onLogout(player)
    if player:getStorageValue(config.players.storage) == 1 then
        player:sendCancelMessage("You cannot logout, because you are at the event.")
        return false
    end
    return true
end
cEvent:register()


if EventCallback then
    local ec = EventCallback
    function ec.onMoveCreature(player, creature, fromPosition, toPosition)
        if not player:getGroup():getAccess() then
            if not config.miscellaneous.canPushPlayers then
                if player:getStorageValue(config.players.storage) == 1 then
                    player:sendCancelMessage("It is not allowed to move players in the event.")
                    return false
                end
            end
        end
        return true
    end
    ec:register(-1)

    local ec = EventCallback
    function ec.onMoveItem(player, item, count, fromPosition, toPosition, fromCylinder, toCylinder)
        if not player:getGroup():getAccess() then
            if not config.miscellaneous.canMoveItems then
                if toPosition.x ~= CONTAINER_POSITION or fromPosition.x ~= CONTAINER_POSITION then
                    if player:getStorageValue(config.players.storage) == 1 then
                        player:sendCancelMessage("It is not allowed to move items in the event.")
                        return RETURNVALUE_SCRIPT
                    end
                end
            end
        end
        return RETURNVALUE_NOERROR
    end
    ec:register()

elseif config.state.debug then
    _FSE.debug("Your current version does not support EventCallback functionalities.")
end