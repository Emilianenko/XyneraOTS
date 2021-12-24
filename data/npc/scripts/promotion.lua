local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)              npcHandler:onCreatureAppear(cid)            end
function onCreatureDisappear(cid)           npcHandler:onCreatureDisappear(cid)         end
function onCreatureSay(cid, type, msg)      npcHandler:onCreatureSay(cid, type, msg)    end
function onThink()                          npcHandler:onThink()                        end

-- number formatting for golden outfit prices
local function showBigNumber(n)
	return tostring(math.floor(n)):reverse():gsub("(%d%d%d)","%1."):gsub("%.(%-?)$","%1"):reverse()
end

-- config
local lookTypeM = 1210
local lookTypeF = 1211
local goldenOutfitDisplayId = 34166
local effect = CONST_ME_EARLY_THUNDER

-- topic list (not configurable)
local topic = {
	welcome = 0,
	donationAsked = 1,
	donationReady = 2,
	wantsArmor = 3,
	wantsBoots = 4,
	wantsHelmet = 5,
	promotionAsked = 6
}

-- dialogues
local dialogue = {
	-- promotion
	questionPromotion = string.format("Do you want to be promoted in your vocation for %d gold?", PROMOTION_PRICE),
	alreadyPromoted = "You already have been promoted.",
	unpromotable = "You have to choose your vocation before I can promote you.",
	levelTooLow = string.format("You need to be at least level %d in order to be promoted.", PROMOTION_LEVEL),
	needPremium = "You need a premium account in order to promote.",
	promotionDeclined = "Ok, then not.",
	promoted = "Congratulations! You are now promoted.",
	
	-- golden outfit
	badConfiguration = "My apologies, but we just ran out of golden outfits and I am unable to accept your donation. Please contact the administrator.",
	
	outfitResponse = "In exchange for a truly generous donation, I will offer a special outfit. Do you want to make a donation?",
	outfitDetails = {
		string.format(
			"Excellent! Now, let me explain. If you donate %s gold pieces, you will be entitled to wear a unique outfit. ...",
			showBigNumber(GOLDEN_OUTFIT_PRICE_ARMOR + GOLDEN_OUTFIT_PRICE_BOOTS + GOLDEN_OUTFIT_PRICE_HELMET)
		),
		string.format(
			"You will be entitled to wear the {armor} for %s gold pieces, {boots} for an additional %s and the {helmet} for another %s gold pieces. ...",
			showBigNumber(GOLDEN_OUTFIT_PRICE_ARMOR),
			showBigNumber(GOLDEN_OUTFIT_PRICE_BOOTS),
			showBigNumber(GOLDEN_OUTFIT_PRICE_HELMET)
		),
		"What will it be?"
	},
	
	questions = {
		[topic.wantsArmor] = string.format(
			"So you wold like to donate %s gold pieces which in return will entitle you to wear a unique armor?",
			showBigNumber(GOLDEN_OUTFIT_PRICE_ARMOR)
		),
		[topic.wantsBoots] = string.format(
			"So you would like to donate %s gold pieces which in return will entitle you to wear unique boots?",
			showBigNumber(GOLDEN_OUTFIT_PRICE_BOOTS)
		),
		[topic.wantsHelmet] = string.format(
			"So you would like to donate %s gold pieces which in return will entitle you to wear a unique helmet?",
			showBigNumber(GOLDEN_OUTFIT_PRICE_HELMET)
		)
	},
	
	success = {
		[topic.wantsArmor] = "Take this armor as a token of great gratitude. Let us forever remember this day, my friend!",
		[topic.wantsBoots] = "Take these boots as a token of great gratitude. Let us forever remember this day, my friend!",
		[topic.wantsHelmet] = "Take this helmet as a token of great gratitude. Let us forever remember this day, my friend!"
	},

	notEnoughMoney = "You do not have enough money.",
	alreadyHaveOutfit = "You already own this outfit.",
	alreadyHaveAddon = "You already own this addon.",

	needArmor = "I am sorry but are not yet entitled to wear the {armor}.",
	needBoots = "I am sorry but are not yet entitled to wear the {boots}.",

	invalidOutfitChoice = "In that case, return to me once you made up your mind.",
	playerDontWantDonating = "Hm, I see.",
	playerDontWantThePiece = "Very well, alright then."
}

local outfitKeywords = {
	"helmet", "armor", "boots", "outfit", "addon", "donat"
}

local minStorage = {
	[topic.wantsArmor] = 1,
	[topic.wantsBoots] = 2,	
	[topic.wantsHelmet] = 3
}

local prices = {
	[topic.wantsArmor] = GOLDEN_OUTFIT_PRICE_ARMOR,
	[topic.wantsBoots] = GOLDEN_OUTFIT_PRICE_BOOTS,	
	[topic.wantsHelmet] = GOLDEN_OUTFIT_PRICE_HELMET
}

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	if not player then
		return
	end
	
	local currentTopic = npcHandler.topic[cid] -- read only shortcut, to overwrite current topic, call npcHandler.topic[cid] = newValue
	
	-- promotion
	if currentTopic == topic.promotionAsked then
		-- note: player is allowed to change the conversation topic here
		-- note: npc does not end the conversation in case of failing to promote
		
		-- npc: do you want to be promoted?
		if msgcontains(msg, "yes") then
			-- storage check
			if player:getStorageValue(PlayerStorageKeys.promotion) > 0 then
				npcHandler:say(dialogue.alreadyPromoted, cid)
				npcHandler.topic[cid] = topic.welcome
				return
			end
			
			-- level check
			if player:getLevel() < PROMOTION_LEVEL then
				npcHandler:say(dialogue.levelTooLow, cid)
				npcHandler.topic[cid] = topic.welcome
				return
			end
			
			-- premium check
			if not player:isPremium() then
				npcHandler:say(dialogue.needPremium, cid)
				npcHandler.topic[cid] = topic.welcome
				return
			end
			
			-- promotability check (has voc and is base voc)
			local playerVoc = player:getVocation()
			local playerVocId = playerVoc:getId()
			local demotedVoc = playerVoc:getDemotion()
			if playerVocId == 0 then
				-- no vocation
				npcHandler:say(dialogue.unpromotable, cid)
				npcHandler.topic[cid] = topic.welcome
				return
			elseif demotedVoc then
				-- no storage, but already promoted
				npcHandler:say(dialogue.alreadyPromoted, cid)
				npcHandler.topic[cid] = topic.welcome
				return
			end
			
			-- gold check
			if player:getTotalMoney() < PROMOTION_PRICE then
				npcHandler:say(dialogue.notEnoughMoney, cid)
				npcHandler.topic[cid] = topic.welcome
				return
			end
			
			-- success
			player:setVocation(playerVoc:getPromotion())
			player:setStorageValue(PlayerStorageKeys.promotion, 1)
			player:removeTotalMoney(PROMOTION_PRICE)
			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			npcHandler:say(dialogue.promoted, cid)
			npcHandler.topic[cid] = topic.welcome
			return
		elseif msgcontains(msg, "no") then
			npcHandler:say(dialogue.promotionDeclined, cid)
			npcHandler.topic[cid] = topic.welcome
			return
		end
	end
	
	-- golden outfit
	if currentTopic >= topic.wantsArmor and currentTopic <= topic.wantsHelmet then
		-- note: player is NOT allowed to change the conversation topic here
		-- npc: do you want (this outfit piece)?
		if msgcontains(msg, "yes") then
			-- check if player can buy this piece
			local playerStorage = player:getStorageValue(PlayerStorageKeys.goldenOutfit)
			local storageDiff = minStorage[currentTopic] - math.max(playerStorage, 0)
			if storageDiff > 1 then
				-- need previous piece
				npcHandler:say(player:getStorageValue(PlayerStorageKeys.goldenOutfit) < 1 and dialogue.needArmor or dialogue.needBoots, cid)
				npcHandler.topic[cid] = topic.donationReady
				return
			elseif storageDiff < 1 then
				-- already have this piece
				-- npc ends the conversation
				npcHandler:say(currentTopic == topic.wantsArmor and dialogue.alreadyHaveOutfit or dialogue.alreadyHaveAddon, cid)
				npcHandler.topic[cid] = topic.welcome
				npcHandler:releaseFocus(cid)
				return
			end
			
			-- check if player store inbox is available
			-- (it always should, but who knows?)
			local storeInbox = player:getStoreInbox()
			if not storeInbox then
				-- inbox not detected
				-- npc ends the conversation
				print("[promotion NPC] Warning: Unable to detect player store inbox! PlayerName:", player:getName())
				npcHandler:say(dialogue.badConfiguration, cid)
				npcHandler.topic[cid] = topic.welcome
				npcHandler:releaseFocus(cid)
				return
			end
			
			-- check if player has enough money
			if player:getTotalMoney() < prices[currentTopic] then
				-- not enough money
				-- npc ends the conversation
				npcHandler:say(dialogue.notEnoughMoney, cid)
				npcHandler.topic[cid] = topic.welcome
				npcHandler:releaseFocus(cid)
				return
			end
			
			-- add furniture kit if the player is buying outfit
			if currentTopic == topic.wantsArmor then
				-- check if the kit can be created
				local item = Game.createItem(ITEM_DECORATION_KIT, 1)
				if not item then
					-- failed to create furniture kit
					-- npc ends the conversation
					print("[promotion NPC] Warning: Unable to create golden outfit decoration kit!")
					npcHandler:say(dialogue.badConfiguration, cid)
					npcHandler.topic[cid] = topic.welcome
					npcHandler:releaseFocus(cid)
					return
				end
				
				-- success, add the furniture kit
				item:setAttribute(ITEM_ATTRIBUTE_WRAPID, goldenOutfitDisplayId)
				player:addStoreItemEx(item)
			end
			
			-- all checks were successful, continue transaction
			-- remove money
			player:removeTotalMoney(prices[currentTopic])
			
			-- add outfit/addon
			if currentTopic == topic.wantsArmor then
				player:addOutfit(lookTypeF)
				player:addOutfit(lookTypeM)
			else
				local addonId = minStorage[currentTopic] - 1
				player:addOutfitAddon(lookTypeF, addonId)
				player:addOutfitAddon(lookTypeM, addonId)
			end

			-- set storage
			player:setStorageValue(PlayerStorageKeys.goldenOutfit, minStorage[currentTopic])
			
			-- send effect
			player:getPosition():sendMagicEffect(effect)
			
			-- congratulate
			npcHandler:say(dialogue.success[currentTopic], cid)
			
			-- continue the conversation
			npcHandler.topic[cid] = topic.welcome
			return
		end
		
		-- npc ends the conversation
		npcHandler:say(dialogue.playerDontWantThePiece, cid)
		npcHandler.topic[cid] = topic.welcome
		npcHandler:releaseFocus(cid)
		return
	end
	
	if currentTopic == topic.donationReady then
		-- note: player is NOT allowed to change the conversation topic here
		-- npc talks about outfit pieces, asks: what will it be?
		local newTopic = npcHandler.topic[cid]
		
		-- player chooses the option (or not)
		if msgcontains(msg, "armor") then
			npcHandler.topic[cid] = topic.wantsArmor
		elseif msgcontains(msg, "boots") then
			npcHandler.topic[cid] = topic.wantsBoots
		elseif msgcontains(msg, "helmet") then
			npcHandler.topic[cid] = topic.wantsHelmet
		end
		
		if npcHandler.topic[cid] ~= newTopic then
			-- npc: do you want (this outfit piece)?
			npcHandler:say(dialogue.questions[npcHandler.topic[cid]], cid)
			return
		end
		
		-- npc ends the conversation
		npcHandler:say(dialogue.invalidOutfitChoice, cid)
		npcHandler.topic[cid] = topic.welcome
		npcHandler:releaseFocus(cid)
		return
	end
	
	if currentTopic == topic.donationAsked then
		-- note: player is allowed to change the conversation topic here
		-- npc: do you want to make a donation?
		if msgcontains(msg, "yes") then
			-- npc talks about outfit pieces, asks: what will it be?
			npcHandler:say(dialogue.outfitDetails, cid)
			npcHandler.topic[cid] = topic.donationReady
			return
		elseif msgcontains(msg, "no") then
			-- npc ends the conversation
			npcHandler:say(dialogue.playerDontWantDonating, cid)
			npcHandler.topic[cid] = topic.welcome
			npcHandler:releaseFocus(cid)
			return
		end
	end
	
	-- player is interested in donating
	-- keywords: outfit, addon, helmet, boots, armor, donate
	for i = 1, #outfitKeywords do
		if msgcontains(msg, outfitKeywords[i]) then
			-- npc: do you want to make a donation?
			npcHandler:say(dialogue.outfitResponse, cid)
			npcHandler.topic[cid] = topic.donationAsked
			return
		end
	end

	-- promotion
	if msgcontains(msg, "promot") then
		-- npc: do you want promotion?
		npcHandler:say(dialogue.questionPromotion, cid)
		npcHandler.topic[cid] = topic.promotionAsked
		return
	end
	
	-- other keywords can go here
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
