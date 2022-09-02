local tileRequerimentsConfig = {
    --[[
        [actionId] = {
            -- base
            areaName = "this area",
            zoneEnterMsg = "Custom message goes here.",
            showZoneEnterMsg = true,
            
            -- requirements
            level = a,
            levelMax = b,
            
            storageKey = c,
            storageValue = d,
            storageValueMax = e,
            storageFailMsg = "The magic barrier prevents you from entering.",  -- message players without quest will see
            storageMaxFailMsg = "This area is no longer safe to explore.",
            
            vocations = {},
            
            requiredItemId = gggg,
            requiredItemCount = hh,
            
            -- teleportation
            teleportSuccess = Position(i, j, k),
            teleportFail = Position(l, m, n),
            tileEffectSuccess = o,
            tileEffectFail = p,
            playerEffectSuccess = q,
            playerEffectFail = r,
            
            -- events
            callbackRequest = function(player, item, config, fromPosition)
                -- extra requirements
                return true
            end,
            callbackSuccess = function(player, item, config, fromPosition) end,
            callbackFail = function(player, item, config, fromPosition) end,
        }
    ]]
    
        -- levels 250-300 only
        -- teleport if success
        -- walk back if fail
        [36000] = {
            level = 250,
            levelMax = 300,
            playerEffectFail = CONST_ME_MAGIC_RED,
            playerEffectSuccess = CONST_ME_MAGIC_GREEN,
        },
        
        -- level 500 + quest needed
        -- nothing if success
        -- teleport + msg if fail
        [36001] = {
            level = 250,
            zoneEnterMsg = "Custom message goes here.",
            -- teleportSuccess = Position(1121, 959, 7),
            playerEffectFail = CONST_ME_MAGIC_RED,
            playerEffectSuccess = CONST_ME_MAGIC_GREEN,
        },
    
        -- level 50 to walk over tile
        -- walk back if fail, no msg
        [36002] = {
            -- teleportSuccess = Position(1121, 959, 7),
            storageKey = 100000000,
            storageFailMsg = "this place is not finished yet",  -- message players without quest will see
            playerEffectFail = CONST_ME_MAGIC_RED,
            playerEffectSuccess = CONST_ME_MAGIC_GREEN,
        }
    }
    
    local function sendTPMessage(player, text)
        return player:sendTextMessage(MESSAGE_INFO_DESCR, text)
    end
    
    -- player did not met the requirements, throw him out
    local function denyPlayerEnter(player, item, config, fromPosition)
        if config.teleportFail then
            player:teleportTo(config.teleportFail)
        else
            player:walkback(item:getPosition(), fromPosition)
        end
        
        if config.tileEffectFail then
            item:getPosition():sendMagicEffect(config.tileEffectFail)
        end
        
        if config.playerEffectFail then
            player:getPosition():sendMagicEffect(config.playerEffectFail)
        end
        
        if config.callbackFail then
            config.callbackFail(player, item, config, fromPosition)
        end
    end
    
    local tileRequeriments = MoveEvent()
    function tileRequeriments.onStepIn(creature, item, position, fromPosition)
        local player = creature:getPlayer()
        if not player then
            -- ignore monsters and npcs
            return true
        end
    
        local config = tileRequerimentsConfig[item.actionid]
        local areaName = config.areaName or "this area"
        
        -- callbackRequest (custom requirement check)
        if config.callbackRequest and not config.callbackRequest(player, item) then
            -- denied by embedded script
            denyPlayerEnter(player, item, config, fromPosition)
            return true
        end
        
        -- level check
        do
            local playerLevel = player:getLevel()
            if (config.level and playerLevel < config.level) or (config.levelMax and playerLevel > config.levelMax) then
                denyPlayerEnter(player, item, config, fromPosition)
                
                if config.level and config.levelMax then
                    sendTPMessage(player, string.format("You need to be between level %d and %d to enter %s.", config.level, config.levelMax, areaName))
                elseif config.level then
                    sendTPMessage(player, string.format("You need to be level %d to enter %s.", config.level, areaName))
                elseif config.levelMax then
                    sendTPMessage(player, string.format("You need to be below level %d to enter %s.", config.levelMax, areaName))
                end
                
                return true
            end
        end
        
        -- storage check
        if config.storageKey then
            local playerStorage = player:getStorageValue(config.storageKey)
            if config.storageValue and playerStorage < config.storageValue then
                denyPlayerEnter(player, item, config, fromPosition)
                if config.storageFailMsg then
                    sendTPMessage(player, config.storageFailMsg)
                end
                return true
            end
            
            if config.storageValueMax and playerStorage > config.storageValueMax then
                denyPlayerEnter(player, item, config, fromPosition)
                if config.storageMaxFailMsg then
                    sendTPMessage(player, config.storageMaxFailMsg)
                end
                return true
            end
        end
        
        -- vocation check
        if config.vocations and not table.contains(config.vocations, player:getVocation():getId()) then
            denyPlayerEnter(player, item, config, fromPosition)
            sendTPMessage(player, string.format("Your vocation cannot enter %s.", areaName))
            return true
        end
    
        -- item check
        if config.requiredItemId then
            local neededCount = config.requiredItemCount or 1
            
            -- check if itemType exists
            local itemType = ItemType(config.requiredItemId)
            if not itemType then
                local itemPos = item:getPosition()
                print(string.format("Warning: incorrect item id requirement for special tile [%d] at position %d %d %d", item.actionId, itemPos.x, itemPos.y, itemPos.z))
                sendTPMessage(player, "Unable to enter. Under construction.")
                denyPlayerEnter(player, item, config, fromPosition)
                return true
            end
            
            -- check if player has item
            if player:getItemCount(config.requiredItemId) < neededCount then
                denyPlayerEnter(player, item, config, fromPosition)
                local msg = string.format("You need %s %s to enter %s.", (neededCount ~= 1 and neededCount or itemType:getArticle()), (neededCount ~= 1 and itemType:getPluralName() or itemType:getName()), areaName)
                sendTPMessage(player, msg)
                return true
            end
            
            player:removeItem(config.requiredItemId, neededCount)
        end
        
        -- success
        if config.teleportSuccess then
            player:teleportTo(config.teleportSuccess)
        end
        
        if config.tileEffectSuccess then
            player:getPosition():sendMagicEffect(config.tileEffectSuccess)
        end
        
        if config.playerEffectSuccess then
            player:getPosition():sendMagicEffect(config.playerEffectSuccess)
        end
        
        if config.showZoneEnterMsg or config.zoneEnterMsg then
            sendTPMessage(player, config.zoneEnterMsg or string.format("Entering %s.", areaName))
        end
        
        if config.callbackSuccess then
            config.callbackSuccess(player, item, config, fromPosition)
        end
        
        return true
    end
    
    tileRequeriments:type("stepin")
    for actionId, _ in pairs(tileRequerimentsConfig) do
        tileRequeriments:aid(actionId)
    end
    tileRequeriments:register()