-- 5 or 6 [twist of fate] ?
local totalBlessCount = 8

function onSay(player, words, param)
    if player:hasBlessing(1) then
        player:sendTextMessage(MESSAGE_INFO_DESCR, "You are already blessed.")
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
    else
        local playerBlessCost
        if player:getLevel() < 200 then
            -- under level 50 it's free
            playerBlessCost = 0
        else
            -- from level 50 cost 36k + 200 gold coins for each level
            -- limit to maximum 120k
            playerBlessCost = math.min(200000, 100000 + (player:getLevel() - 200) * 1200)
            
        end
        

        if player:removeTotalMoney(playerBlessCost) then
            for blessId = 1, totalBlessCount do
                player:addBlessing(blessId)
            end

            player:sendTextMessage(MESSAGE_INFO_DESCR, "You received all blessings for " .. playerBlessCost .. " gold coins.")
            player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
        else
            player:sendTextMessage(MESSAGE_INFO_DESCR, "You do not have enough money. Bless on your level costs " .. playerBlessCost .. " gold coins.")
            player:getPosition():sendMagicEffect(CONST_ME_POFF)
        end
    end

    return false
end