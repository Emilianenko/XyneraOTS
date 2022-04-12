local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)


function onCreatureAppear(cid)                npcHandler:onCreatureAppear(cid)             end
function onCreatureDisappear(cid)             npcHandler:onCreatureDisappear(cid)         end
function onCreatureSay(cid, type, msg)         npcHandler:onCreatureSay(cid, type, msg)     end
function onThink()                             npcHandler:onThink()                         end

npcHandler:setMessage(MESSAGE_GREET, "Greetings |PLAYERNAME|. Can you help me? If you help me, I will reward you with beautiful addons! Say {addons} or {help} if you do not know what to do.")

function playerBuyAddonNPC(cid, message, keywords, parameters, node)
	local player = Player(cid)
    if(not npcHandler:isFocused(cid)) then
        return false
    end
    if (parameters.confirm ~= true) and (parameters.decline ~= true) then
        if(player:getPremiumDays(cid) == 0) and (parameters.premium == true) then
            npcHandler:say('Sorry, but this addon and only for premium players!', cid)
            npcHandler:resetNpc()
            return true
        end
        if (player:getStorageValue(parameters.storageID) ~= -1) then
            npcHandler:say('You already have this addon!', cid)
            npcHandler:resetNpc()
            return true
        end
        local itemsTable = parameters.items
        local items_list = ''
        if table.maxn(itemsTable) > 0 then
            for i = 1, table.maxn(itemsTable) do
                local item = itemsTable[i]
                items_list = items_list .. item[2] .. ' ' .. getItemName(item[1])
                if i ~= table.maxn(itemsTable) then
                    items_list = items_list .. ', '
                end
            end
        end
        local text = ''
        if (parameters.cost > 0) and table.maxn(parameters.items) then
            text = items_list .. ' and ' .. parameters.cost .. ' gp'
        elseif (parameters.cost > 0) then
            text = parameters.cost .. ' gp'
        elseif table.maxn(parameters.items) then
            text = items_list
        end
        npcHandler:say('Brought me ' .. text .. ' for ' .. keywords[1] ..' addon'.. '?', cid)
        return true
    elseif (parameters.confirm == true) then
        local addonNode = node:getParent()
        local addoninfo = addonNode:getParameters()
        local items_number = 0
        if table.maxn(addoninfo.items) > 0 then
            for i = 1, table.maxn(addoninfo.items) do
                local item = addoninfo.items[i]
                if (player:getItemCount(item[1]) >= item[2]) then
                    items_number = items_number + 1
                end
            end
        end
        if(player:getMoney(cid) >= addoninfo.cost) and (items_number == table.maxn(addoninfo.items)) then
            player:removeMoney(addoninfo.cost)
            if table.maxn(addoninfo.items) > 0 then
                for i = 1, table.maxn(addoninfo.items) do
                    local item = addoninfo.items[i]
                    player:removeItem(item[1],item[2])
                end
            end
            player:addOutfitAddon(addoninfo.outfit_male, addoninfo.addon)
            player:addOutfitAddon(addoninfo.outfit_female, addoninfo.addon)
            player:setStorageValue(addoninfo.storageID,1)
            npcHandler:say('Here it is your addon!', cid)
            player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
        else
            npcHandler:say('You do not have the necessary items!', cid)
        end
        npcHandler:resetNpc()
        return true
    elseif (parameters.decline == true) then
        npcHandler:say('This does not interest you? Try another!', cid)
        npcHandler:resetNpc()
        return true
    end
    return false
end

local noNode = KeywordNode:new({'no'}, playerBuyAddonNPC, {decline = true})
local yesNode = KeywordNode:new({'yes'}, playerBuyAddonNPC, {confirm = true})

-- citizen (done)
local outfit_node = keywordHandler:addKeyword({'first citizen'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{5878,5}}, outfit_female = 136, outfit_male = 128, addon = 1, storageID = 999001})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)
local outfit_node = keywordHandler:addKeyword({'second citizen'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{2480,1}}, outfit_female = 136, outfit_male = 128, addon = 2, storageID = 999002})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)

-- hunter (done)
local outfit_node = keywordHandler:addKeyword({'first hunter'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{2455,1}, {5948,20}, {5876,20}}, outfit_female = 137, outfit_male = 129, addon = 1, storageID = 999003})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)
local outfit_node = keywordHandler:addKeyword({'second hunter'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{5875,1}}, outfit_female = 137, outfit_male = 129, addon = 2, storageID = 999004})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)

-- knight (done)
local outfit_node = keywordHandler:addKeyword({'first knight'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{5880,20}, {2393,1}}, outfit_female = 139, outfit_male = 131, addon = 1, storageID = 999005})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)
local outfit_node = keywordHandler:addKeyword({'second knight'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{5893,10}}, outfit_female = 139, outfit_male = 131, addon = 2, storageID = 999006})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)

-- mage (done)
local outfit_node = keywordHandler:addKeyword({'first mage'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{2182,1}, {2186,1}, {2185,1}, {8911,1}, {2181,1}, {2183,1}, {2190,1}, {2191,1}, {2188,1}, {8921,1}, {2189,1}, {2187,1}, {5904,5}, {5809,1}}, outfit_female = 141, outfit_male = 130, addon = 1, storageID = 999007}) 
outfit_node:addChildKeywordNode(yesNode) 
outfit_node:addChildKeywordNode(noNode) 
local outfit_node = keywordHandler:addKeyword({'second mage'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{5903,1}}, outfit_female = 141, outfit_male = 130, addon = 2, storageID = 999008}) 
outfit_node:addChildKeywordNode(yesNode) 
outfit_node:addChildKeywordNode(noNode) 


-- summoner (done)
local outfit_node = keywordHandler:addKeyword({'first summoner'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{5958,1}}, outfit_female = 138, outfit_male = 133, addon = 1, storageID = 999009}) 
outfit_node:addChildKeywordNode(yesNode) 
outfit_node:addChildKeywordNode(noNode) 
local outfit_node = keywordHandler:addKeyword({'second summoner'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{5883,10}, {5911,20}, {5922,20}, {5879,100}, {5882,10}, {5881,20}, {5904,5}, {5905,5}}, outfit_female = 138, outfit_male = 133, addon = 2, storageID = 999010}) 
outfit_node:addChildKeywordNode(yesNode) 
outfit_node:addChildKeywordNode(noNode) 


-- barbarian (done)
local outfit_node = keywordHandler:addKeyword({'first barbarian'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{5880,30}, {2393,1}, {5893,20}, {5876,20}}, outfit_female = 147, outfit_male = 143, addon = 1, storageID = 999011})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)
local outfit_node = keywordHandler:addKeyword({'second barbarian'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{5911,25}, {5910,25}, {5884,1}, {5885,1}, {5879,100}}, outfit_female = 147, outfit_male = 143, addon = 2, storageID = 999012})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)

-- druid (done)
local outfit_node = keywordHandler:addKeyword({'first druid'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{5930,2}}, outfit_female = 148, outfit_male = 144, addon = 1, storageID = 999013})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)
local outfit_node = keywordHandler:addKeyword({'second druid'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{5906,40}}, outfit_female = 148, outfit_male = 144, addon = 2, storageID = 999014})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)

-- nobleman (done)
local outfit_node = keywordHandler:addKeyword({'first nobleman'}, playerBuyAddonNPC, {premium = false, cost = 150000, items = {}, outfit_female = 140, outfit_male = 132, addon = 1, storageID = 999015})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)
local outfit_node = keywordHandler:addKeyword({'second nobleman'}, playerBuyAddonNPC, {premium = false, cost = 150000, items = {}, outfit_female = 140, outfit_male = 132, addon = 2, storageID = 999016})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)

-- oriental (done)
local outfit_node = keywordHandler:addKeyword({'first oriental'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{5945,1}}, outfit_female = 150, outfit_male = 146, addon = 1, storageID = 999017})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)
local outfit_node = keywordHandler:addKeyword({'second oriental'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{5883,10}, {5895,10}, {5912,10}, {5891,2}}, outfit_female = 150, outfit_male = 146, addon = 2, storageID = 999018})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)

-- warrior (done)
local outfit_node = keywordHandler:addKeyword({'first warrior'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{5899,50}, {5925,20}, {5919,1}}, outfit_female = 142, outfit_male = 134, addon = 1, storageID = 999019})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)
local outfit_node = keywordHandler:addKeyword({'second warrior'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{5880,20}}, outfit_female = 142, outfit_male = 134, addon = 2, storageID = 999020})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)

-- wizard (done)
local outfit_node = keywordHandler:addKeyword({'first wizard'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{5922,25}}, outfit_female = 149, outfit_male = 145, addon = 1, storageID = 999021})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)
local outfit_node = keywordHandler:addKeyword({'second wizard'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{2536,1}, {2492,1}, {2488,1}, {2123,1}}, outfit_female = 149, outfit_male = 145, addon = 2, storageID = 999022})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)

-- assassin (done)
local outfit_node = keywordHandler:addKeyword({'first assassin'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{5912,20}, {5910,20}, {5911,20}, {5913,20}, {5914,20}, {5909,20}, {5879,100}}, outfit_female = 156, outfit_male = 152, addon = 1, storageID = 999023})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)
local outfit_node = keywordHandler:addKeyword({'second assassin'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{5804,1}, {5930,1}, {7404,5}}, outfit_female = 156, outfit_male = 152, addon = 2, storageID = 999024})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)

-- beggar (done)
local outfit_node = keywordHandler:addKeyword({'first beggar'}, playerBuyAddonNPC, {premium = false, cost = 20000, items = {{5921,5}, {5913,5}}, outfit_female = 157, outfit_male = 153, addon = 1, storageID = 999025})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)
local outfit_node = keywordHandler:addKeyword({'second beggar'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{6107,1}}, outfit_female = 157, outfit_male = 153, addon = 2, storageID = 999026})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)

-- pirate (done)
local outfit_node = keywordHandler:addKeyword({'first pirate'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{6098,5}, {6126,5}, {6097,5}}, outfit_female = 155, outfit_male = 151, addon = 1, storageID = 999027})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)
local outfit_node = keywordHandler:addKeyword({'second pirate'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{6101,1}, {6102,1}, {6100,1}, {6099,1}}, outfit_female = 155, outfit_male = 151, addon = 2, storageID = 999028})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)

-- shaman (done)
local outfit_node = keywordHandler:addKeyword({'first shaman'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{3967,1}, {5883,10}, {5881,5}}, outfit_female = 158, outfit_male = 154, addon = 1, storageID = 999029})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)
local outfit_node = keywordHandler:addKeyword({'second shaman'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{5015,1}}, outfit_female = 158, outfit_male = 154, addon = 2, storageID = 999030})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)

-- norseman (done)
local outfit_node = keywordHandler:addKeyword({'first norseman'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{7290,5}}, outfit_female = 252, outfit_male = 251, addon = 1, storageID = 999031})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)
local outfit_node = keywordHandler:addKeyword({'second norseman'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{7290,5}}, outfit_female = 252, outfit_male = 251, addon = 2, storageID = 999032})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)

-- jester (done)(custom)
local outfit_node = keywordHandler:addKeyword({'first jester'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{5912,2}, {5913,2}, {5914,2}, {5909,2}}, outfit_female = 270, outfit_male = 273, addon = 1, storageID = 999033})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)
local outfit_node = keywordHandler:addKeyword({'second jester'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{5912,1}, {5910,1}, {5911,1}, {5909,1}, {5879,1}}, outfit_female = 270, outfit_male = 273, addon = 2, storageID = 999034})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)

-- demonhunter (done)(custom)
local outfit_node = keywordHandler:addKeyword({'first demonhunter'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{5906,5}, {6500,10}, {11221,5}, {10585,10}}, outfit_female = 288, outfit_male = 289, addon = 1, storageID = 999035})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)

-- nightmare (done)(custom)
local outfit_node = keywordHandler:addKeyword({'first nightmare'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{6500,20}, {11199,5}}, outfit_female = 269, outfit_male = 268, addon = 1, storageID = 999037})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)
local outfit_node = keywordHandler:addKeyword({'second nightmare'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{6500,20}, {6391,1}, {2414,1}}, outfit_female = 269, outfit_male = 268, addon = 2, storageID = 999038})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)

-- brotherhood (done)(custom)
local outfit_node = keywordHandler:addKeyword({'first brotherhood'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{6500,20}, {8702,1}}, outfit_female = 279, outfit_male = 278, addon = 1, storageID = 999039})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)
local outfit_node = keywordHandler:addKeyword({'second brotherhood'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{6500,20}, {10556,5}, {10566,5}, {10562,5}}, outfit_female = 279, outfit_male = 278, addon = 2, storageID = 999040})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)

-- warmaster (done)(custom)
local outfit_node = keywordHandler:addKeyword({'first warmaster'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{11326,1}, {11330,1}, {11332,1}, {11334,1}}, outfit_female = 336, outfit_male = 335, addon = 1, storageID = 999042})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)
local outfit_node = keywordHandler:addKeyword({'second warmaster'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{11328,5}, {5876,5}, {11302,1}}, outfit_female = 336, outfit_male = 335, addon = 2, storageID = 999043})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)

-- wayfarer (done)(custom)
local outfit_node = keywordHandler:addKeyword({'first wayfarer'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{12657,1}}, outfit_female = 367, outfit_male = 366, addon = 1, storageID = 999044})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)
local outfit_node = keywordHandler:addKeyword({'second wayfarer'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{12656,1}}, outfit_female = 367, outfit_male = 366, addon = 2, storageID = 999045})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)

-- elementalist (done)(custom)
local outfit_node = keywordHandler:addKeyword({'first elementalist'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{13756,4}, {13758,10}}, outfit_female = 433, outfit_male = 432, addon = 1, storageID = 999046})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)
local outfit_node = keywordHandler:addKeyword({'second elementalist'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{13940,5}}, outfit_female = 433, outfit_male = 432, addon = 2, storageID = 999047})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)

-- afflicted (done)(custom)
local outfit_node = keywordHandler:addKeyword({'first afflicted'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{13926,1}}, outfit_female = 431, outfit_male = 430, addon = 1, storageID = 999048})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)
local outfit_node = keywordHandler:addKeyword({'second afflicted'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{13925,1}}, outfit_female = 431, outfit_male = 430, addon = 2, storageID = 999049})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)

-- deepling (done)(custom)
local outfit_node = keywordHandler:addKeyword({'first deepling'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{15433,1}, {15453,1}}, outfit_female = 463, outfit_male = 464, addon = 1, storageID = 999050})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)
local outfit_node = keywordHandler:addKeyword({'second deepling'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{15422,1}, {15432,1}, {15455,10}}, outfit_female = 463, outfit_male = 464, addon = 2, storageID = 999051})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)

-- insectoid (done)(custom)
local outfit_node = keywordHandler:addKeyword({'first insectoid'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{15484,20}}, outfit_female = 465, outfit_male = 466, addon = 1, storageID = 999052})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)
local outfit_node = keywordHandler:addKeyword({'second insectoid'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{15483,10}, {15485,10}, {15480,5}}, outfit_female = 465, outfit_male = 466, addon = 2, storageID = 999053})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)

-- Warlord (done)(custom)
local outfit_node = keywordHandler:addKeyword({'first warlord'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{5922,20}, {5893,20}, {10585,10}, {5930,5}}, outfit_female = 512, outfit_male = 513, addon = 1, storageID = 999056})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)
local outfit_node = keywordHandler:addKeyword({'second warlord'}, playerBuyAddonNPC, {premium = false, cost = 0, items = { {5925,20},{11221,10},{5880,10}}, outfit_female = 512, outfit_male = 513, addon = 2, storageID = 999057})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)

-- Guardian (done)(custom)
local outfit_node = keywordHandler:addKeyword({'first guardian'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{5879,20}, {5911,20}, {5914,20}, {5921,5}}, outfit_female = 516, outfit_male = 514, addon = 1, storageID = 999058})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)
local outfit_node = keywordHandler:addKeyword({'second guardian'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{5876,20}, {5882,5}}, outfit_female = 516, outfit_male = 514, addon = 2, storageID = 999059})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)

-- Cave Explorer (done)(custom)
local outfit_node = keywordHandler:addKeyword({'first cave explorer'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{7497,1}}, outfit_female = 574, outfit_male = 575, addon = 1, storageID = 999062})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)
local outfit_node = keywordHandler:addKeyword({'second cave explorer'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{2120,1}, {2553,1}}, outfit_female = 574, outfit_male = 575, addon = 2, storageID = 999063})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)

-- Dream warden (done)(custom)
local outfit_node = keywordHandler:addKeyword({'first dream warden'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{22610,1}}, outfit_female = 578, outfit_male = 577, addon = 1, storageID = 999064})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)
local outfit_node = keywordHandler:addKeyword({'second dream warden'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{22609,1}}, outfit_female = 578, outfit_male = 577, addon = 2, storageID = 999065})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)

-- Glooth engineer (done)(custom)
local outfit_node = keywordHandler:addKeyword({'first glooth engineer'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{23467,10}, {13758,5}}, outfit_female = 618, outfit_male = 610, addon = 1, storageID = 999066})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)
local outfit_node = keywordHandler:addKeyword({'second glooth engineer'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{5880,20}, {5948,10}, {5882,5}, {5881,5}}, outfit_female = 618, outfit_male = 610, addon = 2, storageID = 999067})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)

-- Death Herald (done)(custom)
local outfit_node = keywordHandler:addKeyword({'first death herald'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{5710,1}, {9969,5}}, outfit_female = 666, outfit_male = 667, addon = 1, storageID = 999072})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)
local outfit_node = keywordHandler:addKeyword({'second death herald'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{5890,100}, {11400,10}, {5904,20}}, outfit_female = 666, outfit_male = 667, addon = 2, storageID = 999073})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)

-- Recruiter (done)(custom)
local outfit_node = keywordHandler:addKeyword({'first recruiter'}, playerBuyAddonNPC, {premium = false, cost = 500000, items = {}, outfit_female = 745, outfit_male = 746, addon = 1, storageID = 999088})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)
local outfit_node = keywordHandler:addKeyword({'second recruiter'}, playerBuyAddonNPC, {premium = false, cost = 500000, items = {}, outfit_female = 745, outfit_male = 746, addon = 2, storageID = 999089})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)

-- Rift Warrior (done)(custom)
local outfit_node = keywordHandler:addKeyword({'first rift warrior'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{5878,20}, {25382,1}, {25383,1}}, outfit_female = 845, outfit_male = 846, addon = 1, storageID = 999094})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)
local outfit_node = keywordHandler:addKeyword({'second rift warrior'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{25384,5}, {25385,5}, {25386,5}}, outfit_female = 845, outfit_male = 846, addon = 2, storageID = 999095})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)

-- Festive (done)(custom)
local outfit_node = keywordHandler:addKeyword({'first festive'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{27744,1}}, outfit_female = 929, outfit_male = 931, addon = 1, storageID = 999108})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)
local outfit_node = keywordHandler:addKeyword({'second festive'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{27745,10}}, outfit_female = 929, outfit_male = 931, addon = 2, storageID = 999109})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)

-- Makeshift (done)(custom)
local outfit_node = keywordHandler:addKeyword({'first makeshift'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{30313,1}}, outfit_female = 1043, outfit_male = 1042, addon = 1, storageID = 999114})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)
local outfit_node = keywordHandler:addKeyword({'second makeshift'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{30312,1}}, outfit_female = 1043, outfit_male = 1042, addon = 2, storageID = 999115})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)

-- Battle Mage (done)(custom)
local outfit_node = keywordHandler:addKeyword({'first battle mage'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{31448,4}, {31449,2}}, outfit_female = 1070, outfit_male = 1069, addon = 1, storageID = 999120})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)
local outfit_node = keywordHandler:addKeyword({'second battle mage'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{10562,5}, {21247,10}, {5948,10}}, outfit_female = 1070, outfit_male = 1069, addon = 2, storageID = 999121})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)

-- Dream Warrior (done)(custom)
local outfit_node = keywordHandler:addKeyword({'first dream warrior'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{32825,3}}, outfit_female = 1147, outfit_male = 1146, addon = 1, storageID = 999124})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)
local outfit_node = keywordHandler:addKeyword({'second dream warrior'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{32824,1}}, outfit_female = 1147, outfit_male = 1146, addon = 2, storageID = 999125})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)

-- Hand of the Inquisition (done)(custom)
local outfit_node = keywordHandler:addKeyword({'first hand of the inquisition'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{34394,1}}, outfit_female = 1244, outfit_male = 1243, addon = 1, storageID = 999138})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)
local outfit_node = keywordHandler:addKeyword({'second hand of the inquisition'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{34393,1}}, outfit_female = 1244, outfit_male = 1243, addon = 2, storageID = 999139})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)

-- Poltergeist (done)(custom)
local outfit_node = keywordHandler:addKeyword({'first poltergeist'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{31477,10}, {5898,10}, {35287,1}}, outfit_female = 1271, outfit_male = 1270, addon = 1, storageID = 999142})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)
local outfit_node = keywordHandler:addKeyword({'second poltergeist'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{5906,10}, {22396,10}, {37465,1}}, outfit_female = 1271, outfit_male = 1270, addon = 2, storageID = 999143})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)

-- Falconer (done)(custom)
local outfit_node = keywordHandler:addKeyword({'first falconer'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{31479,10}, {5904,10}, {24713,10}}, outfit_female = 1283, outfit_male = 1282, addon = 1, storageID = 999146})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)
local outfit_node = keywordHandler:addKeyword({'second falconer'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{25360,1}}, outfit_female = 1283, outfit_male = 1282, addon = 2, storageID = 999147})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)

-- Revenant (done)(custom)
local outfit_node = keywordHandler:addKeyword({'first revenant'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{36732,1}}, outfit_female = 1323, outfit_male = 1322, addon = 1, storageID = 999150})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)
local outfit_node = keywordHandler:addKeyword({'second revenant'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{36731,1}}, outfit_female = 1323, outfit_male = 1322, addon = 2, storageID = 999151})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)

-- Rascoohan (done)(custom)
local outfit_node = keywordHandler:addKeyword({'first rascoohan'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{38251,1}}, outfit_female = 1372, outfit_male = 1371, addon = 1, storageID = 999156})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)
local outfit_node = keywordHandler:addKeyword({'second rascoohan'}, playerBuyAddonNPC, {premium = false, cost = 0, items = {{38351,1}}, outfit_female = 1372, outfit_male = 1371, addon = 2, storageID = 999157})
outfit_node:addChildKeywordNode(yesNode)
outfit_node:addChildKeywordNode(noNode)


keywordHandler:addKeyword({'addons'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'I can give you addons of {citizen}, {hunter}, {knight}, {mage}, {nobleman}, {summoner}, {warrior}, {barbarian}, {druid}, {wizard}, {oriental}, {pirate}, {assassin}, {beggar}, {shaman}, {norseman}, {nightmare}, {demonhunter}, {brotherhood}, {jester}, {yalaharian}, {wayfarer}, {elementalist}, {afflicted}, {warmaster}, {deepling}, {insectoid}, {entrepreneur}, {warlord}, {guardian}, {demonic}, {cave explorer}, {dream warden}, {glooth engineer}, {beastmaster}, {conjurer}, {chaos acolyte}, {champion}, {ranger}, {recruiter}, {rift warrior}, {festive}, {makeshift}, {battle mage}, {discovorer}, {dream warrior}, {percht raider}, {hand of the inquisition}, {poltergeist}, {falconer}, {revenant}, {rascoohan}.'})
keywordHandler:addKeyword({'second demonhunter'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Esta addon pode ser obtida apenas pela quest Inquisition.'})
keywordHandler:addKeyword({'first demonic'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Esta addon pode ser obtida apenas pela Demon Helmet Quest.'})
keywordHandler:addKeyword({'second demonic'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Esta addon pode ser obtida apenas pela Demon Oak Quest.'})
keywordHandler:addKeyword({'first discovorer'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Esta addon pode ser obtida apenas ao final da Trox Quest.'})
keywordHandler:addKeyword({'second discovorer'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Esta addon pode ser obtida apenas ao final da Trox Quest.'})
keywordHandler:addKeyword({'help'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'To buy the first addon say \'{first NAME addon}\', for the second addon say \'{second NAME addon}\'.'})

npcHandler:addModule(FocusModule:new())
