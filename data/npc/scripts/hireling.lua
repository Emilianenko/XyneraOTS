---- SCRIPT FOR ALL HIRELING NPCS
HirelingTradeList = {
	["various"] = {
		-- furniture
		{id = 6114, buy = 90},
		{id = 3921, buy = 20},
		{id = 3914, buy = 25},
		{id = 3919, buy = 12},
		{id = 3911, buy = 30},
		{id = 3912, buy = 50},
		{id = 6373, buy = 70},
		{id = 20254, buy = 90},
		{id = 3912, buy = 30},
		{id = 3915, buy = 18},
		{id = 8692, buy = 200},
		{id = 3932, buy = 25},
		{id = 20257, buy = 40},
		{id = 3916, buy = 25},
		{id = 3923, buy = 50},
		{id = 3930, buy = 50},
		{id = 3902, buy = 40},
		{id = 3934, buy = 50},
		{id = 3937, buy = 8},
		{id = 3907, buy = 25},
		{id = 3931, buy = 50},
		{id = 3920, buy = 10},
		{id = 3917, buy = 30},
		{id = 3929, buy = 50},
		{id = 6372, buy = 80},
		{id = 3927, buy = 75},
		{id = 3933, buy = 200},
		{id = 2104, buy = 5},
		{id = 3901, buy = 40},
		{id = 3904, buy = 25},
		{id = 3926, buy = 30},
		{id = 14328, buy = 25},
		{id = 3908, buy = 20},
		{id = 3935, buy = 20},
		{id = 3905, buy = 55},
		{id = 14329, buy = 25},
		{id = 3928, buy = 50},
		{id = 3924, buy = 35},
		{id = 3920, buy = 20},
		{id = 3918, buy = 7},
		{id = 3906, buy = 25},
		{id = 3913, buy = 25},
		{id = 20255, buy = 50},
		{id = 6115, buy = 50},
		{id = 3903, buy = 15},
	},
	
	["equipment"] = {},
	["weapons"] = {}, -- unconfirmed
	["distance"] = {},
	["wands"] = {},
	["rods"] = {},
	["potions"] = {},
	["runes"] = {},
	["supplies"] = {},
	["tools"] = {},
	["post"] = {},
	["supplies"] = {},
}

-- generate item names and register them to full list
-- (main trade dialog and "selection" keyword)
HirelingTradeListFull = {}
for category, categoryData in pairs(HirelingTradeList) do
	for _, offerData in pairs(categoryData) do
		offerData.name = ItemType(offerData.id):getName()
		HirelingTradeListFull[#HirelingTradeListFull + 1] = offerData
	end
end

---- INITIALIZING
local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local count = {}
local transfer = {}

---- TRADE
function buyKurwaPrzepisanyOdZeraBoJebanyModulOdmawiaPosluszenstwa(player, itemid, subType, amount, ignoreCap, inBackpacks)
	local cid = player:getId()

	-- lista kurwa jebana z rzeczami pierdolonymi
	local isAdmin = player:isAdmin()
	local features = math.max(0, Game.playerHirelingFeatures(Npc(getNpcCid()):getOwnerGUID()))
	local hasTrade = isAdmin or bit.hasFlag(features, HIRELING_FEATURE_TRADER)
	local shopList = hasTrade and HirelingTradeListFull or HirelingTradeList.various

	local shopItem
	for _, itemData in pairs(shopList) do
		if itemData.id == itemid then
			shopItem = itemData
			break
		end
	end

	if not shopItem then
		-- nie ma takiego przedmiotu w trade na liscie ty oszukujaca kurwo
		return false
	end
	
	if not shopItem.buy or shopItem.buy == 0 then
		-- tego przedmiotu nie da sie tu kupic nawet nie probuj
		return false
	end

	local stackable = ItemType(itemid):isStackable()
	if not stackable then
		-- nawet nie mysl frajerze ze kupisz wiecej niz 100
		amount = math.min(amount, 100)
	end

	-- calculate the price initially
	local totalCost = amount * shopItem.buy
	if inBackpacks then
		local realSlots = stackable and math.ceil(amount/100) or amount
		totalCost = totalCost + (math.max(1, math.ceil(realSlots / ItemType(ITEM_SHOPPING_BAG):getCapacity())) * 20)
	end

	if totalCost <= 0 then
		-- nie ma za darmo psie
		return false
	end

	local parseInfo = {
		[TAG_PLAYERNAME] = player:getName(),
		[TAG_ITEMCOUNT] = amount,
		[TAG_TOTALCOST] = totalCost,
		[TAG_ITEMNAME] = shopItem.name
	}

	if player:getTotalMoney() < totalCost then
		local msg = npcHandler:getMessage(MESSAGE_NEEDMONEY)
		msg = npcHandler:parseMessage(msg, parseInfo)
		player:sendCancelMessage(msg)
		npcHandler.talkStart[cid] = os.time()
		return false
	end

	local subType = shopItem.subType or 1
	local amountSold, backpacksSold = doNpcSellItem(cid, itemid, amount, subType, ignoreCap, inBackpacks, ITEM_SHOPPING_BAG)

	-- payment
	if amountSold > 0 or backpacksSold > 0 then
		local realCost = (amountSold * shopItem.buy) + (backpacksSold * 20)
		if not player:removeTotalMoney(realCost) then
			local pos = player:getPosition()
			print(
				string.format(
					"Warning: shop error, unable to remove money from player \"%s\", pos: %d %d %d, totalCost: %d, realCost: %d",
					player:getName(),
					pos.x, pos.y, pos.z,
					totalCost,
					realCost
				)
			)
		end
	end

	-- post payment events
	if amountSold < amount then
		local msgId = MESSAGE_NEEDMORESPACE
		if amountSold == 0 then
			msgId = MESSAGE_NEEDSPACE
		end

		local msg = npcHandler:getMessage(msgId)
		parseInfo[TAG_ITEMCOUNT] = amountSold
		msg = npcHandler:parseMessage(msg, parseInfo)
		player:sendCancelMessage(msg)
		npcHandler.talkStart[cid] = os.time()
	end

	if amountSold > 0 then
		local msg = npcHandler:getMessage(MESSAGE_BOUGHT)
		msg = npcHandler:parseMessage(msg, parseInfo)
		player:sendTextMessage(MESSAGE_INFO_DESCR, msg)
		npcHandler.talkStart[cid] = os.time()
	end

	return amount > 0 and amountSold > 0
end

function sellKurwaPrzepisanyOdZeraBoJebanyModulOdmawiaPosluszenstwa(player, itemId, amount, subType, ignoreCap, inBackpacks)
	local cid = player:getId()
	if not ItemType(itemid):isStackable() then
		amount = math.min(amount, 100)
	end
	
	local parseInfo = {
		[TAG_PLAYERNAME] = player:getName(),
		[TAG_ITEMCOUNT] = amount,
		[TAG_TOTALCOST] = amount * shopItem.sell,
		[TAG_ITEMNAME] = shopItem.name
	}

	if not ItemType(itemid):isFluidContainer() then
		subType = -1
	end

	if player:removeItem(itemid, amount, subType, ignoreEquipped, true) then
		local msg = npcHandler:getMessage(MESSAGE_SOLD)
		msg = npcHandler:parseMessage(msg, parseInfo)
		player:sendTextMessage(MESSAGE_INFO_DESCR, msg)
		player:addMoney(amount * shopItem.sell)
		npcHandler.talkStart[cid] = os.time()
		return true
	else
		local msg = npcHandler:getMessage(MESSAGE_NEEDITEM)
		msg = npcHandler:parseMessage(msg, parseInfo)
		player:sendCancelMessage(msg)
		npcHandler.talkStart[cid] = os.time()
		return false
	end
end

---- HELPER FUNCTIONS
local function canGreet(self, player)
	if self:getOwnerGUID() == 0 then
		return true	
	end

	local tile = self:getTile()
	if tile then
		local house = tile:getHouse()
		if house then
			if house:getAccessLevel(player) == HOUSE_NOT_INVITED then
				return false
			end		
		end
	end	

	return true
end

HIRELING_FEATURE_FIRST = HIRELING_FEATURE_BANKER
HIRELING_FEATURE_LAST = HIRELING_FEATURE_STEWARD

local hirelingFeatureBase = "Do you want to see my {goods}"
local hirelingFeatureOffer = {
	[HIRELING_FEATURE_BANKER] = "access your {bank} account",
	[HIRELING_FEATURE_COOK] = "order {food}",
	[HIRELING_FEATURE_STEWARD] = "open your {stash}",
}
local topicList = {
	NONE = 0,
	DEPOSIT_GOLD = 1,
	DEPOSIT_CONSENT = 2,
	WITHDRAW_GOLD = 3,
	WITHDRAW_CONSENT = 4,
	TRANSFER_PLAYER_GOLD = 5,
	TRANSFER_PLAYER_WHO = 6,
	TRANSFER_PLAYER_CONSENT = 7,
	CHANGE_GOLD_CHOOSE = 8,
	CHANGE_GOLD_PLATINUM = 9,
	CHANGE_GOLD_PLATINUM_CONSENT = 10,
	CHANGE_PLATINUM_GOLD_OR_CRYSTAL = 11,
	CHANGE_PLATINUM_GOLD = 12,
	CHANGE_PLATINUM_GOLD_CONSENT = 13,
	CHANGE_PLATINUM_CRYSTAL = 14,
	CHANGE_PLATINUM_CRYSTAL_CONSENT = 15,
	CHANGE_CRYSTAL_PLATINUM = 16,
	CHANGE_CRYSTAL_PLATINUM_CONSENT = 17,
	
	FOOD_CONSENT = 18,
}

local function getHirelingFeaturesString(features, isAdmin)
	local response = hirelingFeatureBase
	local unlocked = {}
	
	for offerId = HIRELING_FEATURE_FIRST, HIRELING_FEATURE_LAST do
		if hirelingFeatureOffer[offerId] and (bit.hasFlag(features, offerId) or isAdmin) then
			unlocked[#unlocked + 1] = hirelingFeatureOffer[offerId]
		end
	end
	
	if #unlocked == 0 then
		return "I can show you my {goods}."
	elseif #unlocked == 1 then
		return string.format("%s or %s?", hirelingFeatureBase, unlocked[1])
	end
	
	return string.format("%s, %s or %s?", hirelingFeatureBase, table.concat(unlocked, ", ", 1, #unlocked - 1), unlocked[#unlocked])
end

local function greetCallback(cid)
	count[cid], transfer[cid] = nil, nil
	return true
end

---- NPC FUNCTIONS
function onCreatureAppear(creature)
	-- execute hireling code if module is installed
	if HirelingsUsageCache then
		local cid = creature:getId()
		if cid == getNpcCid() then
			-- give other systems time to set stats to the npc
			addEvent(onHirelingInit, 100, cid)
		end
	end
	
	-- continue with default behaviour
	npcHandler:onCreatureAppear(creature)
end

function onCreatureDisappear(creature)
	-- execute hireling code if module is installed
	if HirelingsUsageCache then
		local cid = creature:getId()
		if cid == getNpcCid() then
			local npc = Npc(cid)
			
			-- unregister
			onHirelingDestroy(cid, npc:getOwnerGUID(), npc:getOutfit().lookType)
		elseif creature:isPlayer() then
			closeShopWindow(creature)
		end
	end
	
	-- continue with default behaviour
	npcHandler:onCreatureDisappear(creature)
end

function onCreatureSay(cid, type, msg)
	if not (msgcontains(msg, "bye") or msgcontains(msg, "farewell")) then
		if not canGreet(Npc(getNpcCid()), Player(cid)) then
			return
		end
	end
	
	npcHandler:onCreatureSay(cid, type, msg)
end

function onThink()
	npcHandler:onThink()
end

---- CALLBACKS
-- change outfit dialogue cooldown
local cooldown = {}

-- feature handler
local featureLocked = "I'm not a %s and would not know how to help you with that, sorry. I can start a %s apprenticeship if you buy it for me in the store!"

-- bank
local breakpoints = {
	[1] = {100000000, "I think you must be one of the world's richest inhabitants! Your account balance is %d gold."},
	[2] = {10000000, "You have made ten millions and it still grows! Your account balance is %d gold."},
	[3] = {1000000, "Wow, you have reached the magic number of a million gp! Your account balance is %d gold!"},
	[4] = {100000, "You certainly have made a pretty penny. Your account balance is %d gold."},
	[5] = {0, "Your account balance is %d gold."}
}

-- cuisine
local dishPrice = 15000
local dishes = {
	[1] = {32068, "Oh yes, very spicy chilly combined with delicious minced carniphila meat and a side dish of fine salad!"},
	[2] = {32069, "Aaah, the northern cuisine! A catch of fresh salmon right from the coast Svargrond is the base of this extraordinary fishy dish."},
	[3] = {32070, "A traditional and classy meal. A beefy casserole which smells far better than it sounds!"},
	[4] = {32071, "A tasty chunk of juicy beef with an aromatic sauce and parsley potatoes, mmh!"},
	[5] = {32072, "Oooh, well... that one didn't quite turn out as it was supposed to be, I'm sorry."}
}

local specialDish = "Mmh, how about a special treat for you today? Please select from roaster wyvern {wings}, carrot {pie}, tropical marinated {tiger} or a delicatessen {salad}!"
local selectableDishes = {
	["wings"] = {32064, "Oh yes, a tasty roasted wings to make you even tougher and skilled with the defensive arts."},
	["pie"] = {32065, "Divine! Carrot is a well known nourishment that makes the eyes see even more sharply."},
	["tiger"] = {32066, "Magnifique! A tiger meat that has been marinated for several hours in magic spices."},
	["salad"] = {32067, "Aaah, the beauty of the simple dishes! A delicate salad made of selected ingredients, capable of bring joy to the hearts of bravest warriors and their weapons."},
}


local function getBankBalanceResponse(balance)
	for _, bankData in ipairs(breakpoints) do
		if balance > bankData[1] then
			return string.format(bankData[2], balance)
		end
	end
end

function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end
	
	-- unlock hireling dialogue if module enabled
	if HirelingsUsageCache then
		-- declare userdata
		local player = Player(cid)
		local npc = Npc(getNpcCid())
		
		-- check access level
		local isAdmin = player:isAdmin()
		local isOwner = isAdmin or npc:getOwnerGUID() == player:getGuid()

		-- check unlocked features
		local features = math.max(0, Game.playerHirelingFeatures(npc:getOwnerGUID()))
		local hasBank = isAdmin or bit.hasFlag(features, HIRELING_FEATURE_BANKER)
		local hasTrade = isAdmin or bit.hasFlag(features, HIRELING_FEATURE_TRADER)
		local hasCooking = isAdmin or bit.hasFlag(features, HIRELING_FEATURE_COOK)
		local hasStash = isAdmin or bit.hasFlag(features, HIRELING_FEATURE_STEWARD)

		-- npc: do you want food for 15k?
		if npcHandler.topic[cid] == topicList.FOOD_CONSENT then
			if msgcontains(msg, "yes") and player:removeTotalMoney(dishPrice) then
				local roll = math.random(#dishes + 1)
				if dishes[roll] then
					player:addStoreItem(dishes[roll][1], 1)
					npcHandler:say(dishes[roll][2], cid)
				else
					player:setStorageValue(HIRELING_COOK_STORAGE, 1)
					npcHandler:say(specialDish, cid)
				end
			else
				npcHandler:say("Ok then.", cid)
			end
			
			npcHandler.topic[cid] = topicList.NONE
			return true
		end

		-- dish choice menu
		for key, dishData in pairs(selectableDishes) do
			if msgcontains(msg, key) then
				if player:getStorageValue(HIRELING_COOK_STORAGE) > 0 then
					player:addStoreItem(dishData[1], 1)
					player:setStorageValue(HIRELING_COOK_STORAGE, -1)
					npcHandler:say(dishData[2], cid)
				else
					npcHandler:say("I can check if we have ingredients to {cook} that dish today.", cid)
				end

				npcHandler.topic[cid] = topicList.NONE
				return true
			end
		end

		-- trading menu
		for category, _ in pairs(HirelingTradeList) do
			if msgcontains(msg, category) then
				if hasTrade or category == "various" then
					npc:openShopWindow(
						player,
						HirelingTradeList[category],
						buyKurwaPrzepisanyOdZeraBoJebanyModulOdmawiaPosluszenstwa,
						sellKurwaPrzepisanyOdZeraBoJebanyModulOdmawiaPosluszenstwa
					)
				else
					npcHandler:say(string.format(featureLocked, "trade", "trading"), cid)
				end
				npcHandler.topic[cid] = topicList.NONE
				return true
			end
		end
		
		-- dialogue
		if msgcontains(msg, "service") then
			npcHandler:say(getHirelingFeaturesString(features, isAdmin), cid)
			npcHandler.topic[cid] = topicList.NONE
			return true

		elseif msgcontains(msg, "trade") or msgcontains(msg, "goods") or msgcontains(msg, "selection") then
			if hasTrade then
				npc:openShopWindow(
					player,
					HirelingTradeListFull,
					buyKurwaPrzepisanyOdZeraBoJebanyModulOdmawiaPosluszenstwa,
					sellKurwaPrzepisanyOdZeraBoJebanyModulOdmawiaPosluszenstwa
				)
				npcHandler:say("I sell a {selection} of {various} items, {equipment}, {distance} weapons, {wands} and {rods}, {potions}, {runes}, {supplies}, {tools} and {postal} goods. Just ask!", cid)
			else
				npc:openShopWindow(
					player,
					HirelingTradeList.various,
					buyKurwaPrzepisanyOdZeraBoJebanyModulOdmawiaPosluszenstwa,
					sellKurwaPrzepisanyOdZeraBoJebanyModulOdmawiaPosluszenstwa
				)
				npcHandler:say("While I'm not a trader, I still have a collection of {various} items to sell if you like!", cid)
			end
			
			npcHandler.topic[cid] = topicList.NONE
			return true
		elseif msgcontains(msg, "cook") or msgcontains(msg, "dish") or msgcontains(msg, "food") then
			if player:getStorageValue(HIRELING_COOK_STORAGE) < 1 then
				if hasCooking then
					npcHandler:say(string.format("Hmm, yes! A variety of fine food awaits! However, a small expense of %d gold is expected to make these delicious masterpieces happen. Shall I?", dishPrice), cid)
					npcHandler.topic[cid] = topicList.FOOD_CONSENT
				else
					npcHandler:say(string.format(featureLocked, "cook", "cooking"), cid)
					npcHandler.topic[cid] = topicList.NONE
				end
			else
				-- dish of choice (gold was already consumed)
				npcHandler:say(specialDish, cid)
				npcHandler.topic[cid] = topicList.NONE
			end
			
			return true
		elseif msgcontains(msg, "stash") then
			-- if hasStash then
			-- end

			-- UNSUPPORTED			
			npcHandler:say("Feature not supported yet. Apologies for inconvenience.", cid)
			npcHandler.topic[cid] = topicList.NONE
			return true
		elseif msgcontains(msg, "bank") then
			if hasBank then
				npcHandler:say("Would you like to know more about the {basic} or {advanced} functions of your bank account?", cid)
			else
				npcHandler:say(string.format(featureLocked, "bank", "banking"), cid)
			end
			
			npcHandler.topic[cid] = topicList.NONE
			return true
		elseif msgcontains(msg, "lamp") then
			if isOwner then
				npcHandler:say("If you need me back in my lamp, simply click on me and you will find me in your store inbox.", cid)
			else
				npcHandler:say("If you own a house, you can buy your very personal hireling lamps at the {store}.", cid)
			end
			
			npcHandler.topic[cid] = topicList.NONE
			return true
		elseif msgcontains(msg, "store") then
			-- open hireling tab in store
			
			-- UNSUPPORTED
			npcHandler:say("Feature not supported yet. Apologies for inconvenience.", cid)
			npcHandler.topic[cid] = topicList.NONE
			return true			
		elseif msgcontains(msg, "job") or msgcontains(msg, "hireling") then
			npcHandler:say("I work here as a hireling.", cid)
			npcHandler.topic[cid] = topicList.NONE
			return true
		elseif msgcontains(msg, "outfit") then
			if isOwner then
				if cooldown[cid] and os.time() - cooldown[cid] > 0 then
					npcHandler:say("Please give me a moment to finish changing my clothing.", cid)
				else
					cooldown[cid] = os.time() + 3
					sendHirelingUI(player, npc)
				end
			else
				npcHandler:say("House owners can dress their hirelings through the context menu.", cid)
			end
			
			npcHandler.topic[cid] = topicList.NONE
			return true
		else
			-- bank specific keywords
			if hasBank then
				if msgcontains(msg, "basic") or msgcontains(msg, "functions") or msgcontains(msg, "help") then
					npcHandler:say("You can check the {balance} of your bank account, {deposit} money or {withdraw} it. You can {transfer} money to other characters, provided that they have a vocation, or {change} the coins in your inventory.", cid)
					npcHandler.topic[cid] = topicList.NONE
				elseif msgcontains(msg, "advanced") then
					npcHandler:say("Your bank account will be used automatically when you want to {rent} a house or place an offer on an item on the {market}. Let me know if you want to know about how either one works.", cid)
					npcHandler.topic[cid] = topicList.NONE
				elseif msgcontains(msg, "market") then
					npcHandler:say("If you buy an item from the market, the required gold will be deducted from your bank account automatically. On the other hand, money you earn for selling items via the market will be added to your account. It's easy!", cid)
					npcHandler.topic[cid] = topicList.NONE
				elseif msgcontains(msg, "money") then
					npcHandler:say("We can {change} money for you. You can also access your {bank account}.", cid)
					npcHandler.topic[cid] = topicList.NONE
				elseif msgcontains(msg, "balance") then
					npcHandler:say(getBankBalanceResponse(player:getBankBalance()), cid)
					npcHandler.topic[cid] = topicList.NONE
				elseif msgcontains(msg, "deposit") then
					count[cid] = player:getMoney()
					if count[cid] < 1 then
						npcHandler:say("You do not have enough gold.", cid)
						npcHandler.topic[cid] = topicList.NONE
						return true
					end
					if msgcontains(msg, "all") then
						npcHandler:say("Would you really like to deposit " .. count[cid] .. " gold?", cid)
						npcHandler.topic[cid] = topicList.DEPOSIT_CONSENT
						return true
					else
						if string.match(msg, "%d+") then
							count[cid] = getMoneyCount(msg)
							if count[cid] < 1 then
								npcHandler:say("You do not have enough gold.", cid)
								npcHandler.topic[cid] = topicList.NONE
								return true
							end
							npcHandler:say("Would you really like to deposit " .. count[cid] .. " gold?", cid)
							npcHandler.topic[cid] = topicList.DEPOSIT_CONSENT
							return true
						else
							npcHandler:say("Please tell me how much gold it is you would like to deposit.", cid)
							npcHandler.topic[cid] = topicList.DEPOSIT_GOLD
							return true
						end
					end
					if not isValidMoney(count[cid]) then
						npcHandler:say("Sorry, but you can't deposit that much.", cid)
						npcHandler.topic[cid] = topicList.NONE
						return true
					end
				elseif npcHandler.topic[cid] == topicList.DEPOSIT_GOLD then
					count[cid] = getMoneyCount(msg)
					if isValidMoney(count[cid]) then
						npcHandler:say("Would you really like to deposit " .. count[cid] .. " gold?", cid)
						npcHandler.topic[cid] = topicList.DEPOSIT_CONSENT
						return true
					else
						npcHandler:say("You do not have enough gold.", cid)
						npcHandler.topic[cid] = topicList.NONE
						return true
					end
				elseif npcHandler.topic[cid] == topicList.DEPOSIT_CONSENT then
					if msgcontains(msg, "yes") then
						if player:getMoney() >= tonumber(count[cid]) then
							player:depositMoney(count[cid])
							npcHandler:say("Alright, we have added the amount of " .. count[cid] .. " gold to your {balance}. You can {withdraw} your money anytime you want to.", cid)
						else
							npcHandler:say("You do not have enough gold.", cid)
						end
					else
						npcHandler:say("As you wish. Is there something else I can do for you?", cid)
					end
					
					npcHandler.topic[cid] = topicList.NONE
					return true
				elseif msgcontains(msg, "withdraw") then
					if string.match(msg, "%d+") then
						count[cid] = getMoneyCount(msg)
						if isValidMoney(count[cid]) then
							npcHandler:say("Are you sure you wish to withdraw " .. count[cid] .. " gold from your bank account?", cid)
							npcHandler.topic[cid] = topicList.WITHDRAW_GOLD
						else
							npcHandler:say("There is not enough gold in your account.", cid)
							npcHandler.topic[cid] = topicList.NONE
						end
						
						return true
					else
						npcHandler:say("Please tell me how much gold you would like to withdraw.", cid)
						npcHandler.topic[cid] = topicList.WITHDRAW_CONSENT
						return true
					end
				elseif npcHandler.topic[cid] == topicList.WITHDRAW_CONSENT then
					count[cid] = getMoneyCount(msg)
					if isValidMoney(count[cid]) then
						npcHandler:say("Are you sure you wish to withdraw " .. count[cid] .. " gold from your bank account?", cid)
						npcHandler.topic[cid] = topicList.WITHDRAW_GOLD
					else
						npcHandler:say("There is not enough gold in your account.", cid)
						npcHandler.topic[cid] = topicList.NONE
					end
					
					return true
				elseif npcHandler.topic[cid] == topicList.WITHDRAW_GOLD then
					if msgcontains(msg, "yes") then
						if player:canCarryMoney(count[cid]) then
							if player:withdrawMoney(count[cid]) then
								npcHandler:say("Here you are, " .. count[cid] .. " gold. Please let me know if there is something else I can do for you.", cid)
							else
								npcHandler:say("There is not enough gold in your account.", cid)
							end
						else
							npcHandler:say("Whoah, hold on, you have no room in your inventory to carry all those coins. I don't want you to drop it on the floor, maybe come back with a cart!", cid)
						end
					else
						npcHandler:say("The customer is king! Come back anytime you want to if you wish to {withdraw} your money.", cid)
					end
					
					npcHandler.topic[cid] = topicList.NONE
					return true
				elseif msgcontains(msg, "transfer") then
					local parts = msg:split(" ")
					if #parts < 3 then
						if #parts == 2 then
							-- Immediate topicList.TRANSFER_PLAYER_GOLD simulation
							count[cid] = getMoneyCount(parts[2])
							if player:getBankBalance() < count[cid] then
								npcHandler:say("There is not enough gold in your account.", cid)
								npcHandler.topic[cid] = topicList.NONE
								return true
							end
							
							if isValidMoney(count[cid]) then
								npcHandler:say("Who would you like transfer " .. count[cid] .. " gold to?", cid)
								npcHandler.topic[cid] = topicList.TRANSFER_PLAYER_WHO
							else
								npcHandler:say("There is not enough gold in your account.", cid)
								npcHandler.topic[cid] = topicList.NONE
							end
						else
							npcHandler:say("Please tell me the amount of gold you would like to transfer.", cid)
							npcHandler.topic[cid] = topicList.TRANSFER_PLAYER_GOLD
						end
					else -- "transfer 250 playerName" or "transfer 250 to playerName"
						local receiver = ""

						local seed = 3
						if #parts > 3 then
							seed = parts[3] == "to" and 4 or 3
						end
						for i = seed, #parts do
							receiver = receiver .. " " .. parts[i]
						end
						receiver = receiver:trim()

						-- Immediate topicList.TRANSFER_PLAYER_GOLD simulation
						count[cid] = getMoneyCount(parts[2])
						if player:getBankBalance() < count[cid] then
							npcHandler:say("There is not enough gold in your account.", cid)
							npcHandler.topic[cid] = topicList.NONE
							return true
						end
						
						if isValidMoney(count[cid]) then
							-- Immediate topicList.TRANSFER_PLAYER_WHO simulation
							transfer[cid] = getPlayerDatabaseInfo(receiver)
							if player:getName() == transfer[cid].name then
								npcHandler:say("Why would you want to transfer money to yourself? You already have it!", cid)
								npcHandler.topic[cid] = topicList.NONE
								return true
							end

							if transfer[cid] then
								if transfer[cid].vocation == VOCATION_NONE and Player(cid):getVocation() ~= 0 then
									npcHandler:say("I'm afraid this character only holds a junior account at our bank. Do not worry, though. Once he has chosen his vocation, his account will be upgraded.", cid)
									npcHandler.topic[cid] = topicList.NONE
									return true
								end
								npcHandler:say("So you would like to transfer " .. count[cid] .. " gold to " .. transfer[cid].name .. "?", cid)
								npcHandler.topic[cid] = topicList.TRANSFER_PLAYER_CONSENT
							else
								npcHandler:say("This player does not exist.", cid)
								npcHandler.topic[cid] = topicList.NONE
							end
							-- end topicList.TRANSFER_PLAYER_WHO
						else
							npcHandler:say("There is not enough gold in your account.", cid)
							npcHandler.topic[cid] = topicList.NONE
						end
					end
				elseif npcHandler.topic[cid] == topicList.TRANSFER_PLAYER_GOLD then
					local currencyValue = tonumber(msg)
					if not currencyValue or currencyValue < 1 then
						npcHandler:say("Please tell me the amount of gold you would like to transfer, make sure to specify a number.", cid)
						npcHandler.topic[cid] = topicList.TRANSFER_PLAYER_GOLD
						return true
					end
					
					count[cid] = getMoneyCount(msg)
					if player:getBankBalance() < count[cid] then
						npcHandler:say("There is not enough gold in your account.", cid)
						npcHandler.topic[cid] = topicList.NONE
						return true
					end
					
					if isValidMoney(count[cid]) then
						npcHandler:say("Who would you like transfer " .. count[cid] .. " gold to?", cid)
						npcHandler.topic[cid] = topicList.TRANSFER_PLAYER_WHO
					else
						npcHandler:say("There is not enough gold in your account.", cid)
						npcHandler.topic[cid] = topicList.NONE
					end
				elseif npcHandler.topic[cid] == topicList.TRANSFER_PLAYER_WHO then
					transfer[cid] = getPlayerDatabaseInfo(msg)
					if not transfer[cid] then
						npcHandler:say("Hmm, my ledgers have no records of anyone with the name " .. msg .. ". Please ensure the name is correct.", cid)
						npcHandler.topic[cid] = topicList.TRANSFER_PLAYER_WHO
						return true
					end
					if player:getName() == transfer[cid].name then
						npcHandler:say("Fill in this field with person who receives your gold!", cid)
						npcHandler.topic[cid] = topicList.NONE
						return true
					end

					if transfer[cid] then
						if transfer[cid].vocation == VOCATION_NONE and Player(cid):getVocation() ~= 0 then
							npcHandler:say("I'm afraid this character only holds a junior account at our bank. Do not worry, though. Once he has chosen his vocation, his account will be upgraded.", cid)
							npcHandler.topic[cid] = topicList.NONE
							return true
						end
						npcHandler:say("So you would like to transfer " .. count[cid] .. " gold to " .. transfer[cid].name .. "?", cid)
						npcHandler.topic[cid] = topicList.TRANSFER_PLAYER_CONSENT
					else
						npcHandler:say("This player does not exist.", cid)
						npcHandler.topic[cid] = topicList.NONE
					end
				elseif npcHandler.topic[cid] == topicList.TRANSFER_PLAYER_CONSENT then
					if msgcontains(msg, "yes") then
						if not player:transferMoneyTo(transfer[cid], count[cid]) then
							npcHandler:say("You cannot transfer money to this account.", cid)
						else
							npcHandler:say("Very well. You have transfered " .. count[cid] .. " gold to " .. transfer[cid].name .. ".", cid)
							transfer[cid] = nil
						end
					elseif msgcontains(msg, "no") then
						npcHandler:say("Alright, is there something else I can do for you?", cid)
					end
					npcHandler.topic[cid] = topicList.NONE
				elseif msgcontains(msg, "change") then
					local parts = msg:split(" ")
					if #parts > 1 then
						if parts[2]:lower() == "gold" then
							npcHandler:say("How many platinum coins would you like to get?", cid)
							npcHandler.topic[cid] = topicList.CHANGE_GOLD_PLATINUM
						elseif parts[2]:lower() == "platinum" then
							npcHandler:say("Would you like to change your platinum coins into {gold} or {crystal}?", cid)
							npcHandler.topic[cid] = topicList.CHANGE_PLATINUM_GOLD_OR_CRYSTAL
						elseif parts[2]:lower() == "crystal" then
							npcHandler:say("How many crystal coins would you like to change into platinum?", cid)
							npcHandler.topic[cid] = topicList.CHANGE_CRYSTAL_PLATINUM
						end
					else
						npcHandler:say("Would you like to change {gold}, {platinum} or {crystal} coins?", cid)
						npcHandler.topic[cid] = topicList.CHANGE_GOLD_CHOOSE
					end
				elseif msgcontains(msg, "gold") and npcHandler.topic[cid] == topicList.CHANGE_GOLD_CHOOSE then
					npcHandler:say("How many platinum coins would you like to get?", cid)
					npcHandler.topic[cid] = topicList.CHANGE_GOLD_PLATINUM
				elseif msgcontains(msg, "platinum") and npcHandler.topic[cid] == topicList.CHANGE_GOLD_CHOOSE then
					npcHandler:say("Would you like to change your platinum coins into gold or crystal?", cid)
					npcHandler.topic[cid] = topicList.CHANGE_PLATINUM_GOLD_OR_CRYSTAL
				elseif msgcontains(msg, "crystal") and npcHandler.topic[cid] == topicList.CHANGE_GOLD_CHOOSE then
					npcHandler:say("How many crystal coins would you like to change into platinum?", cid)
					npcHandler.topic[cid] = topicList.CHANGE_CRYSTAL_PLATINUM
				elseif npcHandler.topic[cid] == topicList.CHANGE_GOLD_PLATINUM then
					if getMoneyCount(msg) < 1 then
						npcHandler:say("Sorry, you do not have enough gold coins.", cid)
						npcHandler.topic[cid] = topicList.NONE
					else
						count[cid] = getMoneyCount(msg)
						npcHandler:say("So you would like me to change " .. count[cid] * 100 .. " of your gold coins into " .. count[cid] .. " platinum coins?", cid)
						npcHandler.topic[cid] = topicList.CHANGE_GOLD_PLATINUM_CONSENT
					end
				elseif npcHandler.topic[cid] == topicList.CHANGE_GOLD_PLATINUM_CONSENT then
					if msgcontains(msg, "yes") then
						if player:removeItem(ITEM_GOLD_COIN, count[cid] * 100) then
							player:addItem(ITEM_PLATINUM_COIN, count[cid])
							npcHandler:say("Here you are.", cid)
						else
							npcHandler:say("Sorry, you do not have enough gold coins.", cid)
						end
					else
						npcHandler:say("Well, can I help you with something else?", cid)
					end
					npcHandler.topic[cid] = topicList.NONE
				elseif npcHandler.topic[cid] == topicList.CHANGE_PLATINUM_GOLD_OR_CRYSTAL then
					if msgcontains(msg, "gold") then
						npcHandler:say("How many platinum coins would you like to change into gold?", cid)
						npcHandler.topic[cid] = topicList.CHANGE_PLATINUM_GOLD
					elseif msgcontains(msg, "crystal") then
						npcHandler:say("How many crystal coins would you like to get?", cid)
						npcHandler.topic[cid] = topicList.CHANGE_PLATINUM_CRYSTAL
					else
						npcHandler:say("Well, can I help you with something else?", cid)
						npcHandler.topic[cid] = topicList.NONE
					end
				elseif npcHandler.topic[cid] == topicList.CHANGE_PLATINUM_GOLD then
					if getMoneyCount(msg) < 1 then
						npcHandler:say("Sorry, you do not have enough platinum coins.", cid)
						npcHandler.topic[cid] = topicList.NONE
					else
						count[cid] = getMoneyCount(msg)
						npcHandler:say("So you would like me to change " .. count[cid] .. " of your platinum coins into " .. count[cid] * 100 .. " gold coins for you?", cid)
						npcHandler.topic[cid] = topicList.CHANGE_PLATINUM_GOLD_CONSENT
					end
				elseif npcHandler.topic[cid] == topicList.CHANGE_PLATINUM_GOLD_CONSENT then
					if msgcontains(msg, "yes") then
						if player:getFreeCapacity() >= getMoneyWeight(count[cid]) then
							if player:removeItem(ITEM_PLATINUM_COIN, count[cid]) then
								player:addItem(ITEM_GOLD_COIN, count[cid] * 100)
								npcHandler:say("Here you are.", cid)
							else
								npcHandler:say("Sorry, you do not have enough platinum coins.", cid)
							end
						else
							npcHandler:say("Whoah, hold on, you have no room in your inventory to carry all those coins. I don't want you to drop it on the floor, maybe come back with a cart!", cid)
						end
					else
						npcHandler:say("Well, can I help you with something else?", cid)
					end
					npcHandler.topic[cid] = topicList.NONE
				elseif npcHandler.topic[cid] == topicList.CHANGE_PLATINUM_CRYSTAL then
					if getMoneyCount(msg) < 1 then
						npcHandler:say("Sorry, you do not have enough platinum coins.", cid)
						npcHandler.topic[cid] = topicList.NONE
					else
						count[cid] = getMoneyCount(msg)
						npcHandler:say("So you would like me to change " .. count[cid] * 100 .. " of your platinum coins into " .. count[cid] .. " crystal coins for you?", cid)
						npcHandler.topic[cid] = topicList.CHANGE_PLATINUM_CRYSTAL_CONSENT
					end
				elseif npcHandler.topic[cid] == topicList.CHANGE_PLATINUM_CRYSTAL_CONSENT then
					if msgcontains(msg, "yes") then
						if player:removeItem(ITEM_PLATINUM_COIN, count[cid] * 100) then
							player:addItem(ITEM_CRYSTAL_COIN, count[cid])
							npcHandler:say("Here you are.", cid)
						else
							npcHandler:say("Sorry, you do not have enough platinum coins.", cid)
						end
					else
						npcHandler:say("Well, can I help you with something else?", cid)
					end
					npcHandler.topic[cid] = topicList.NONE
				elseif npcHandler.topic[cid] == topicList.CHANGE_CRYSTAL_PLATINUM then
					if getMoneyCount(msg) < 1 then
						npcHandler:say("Sorry, you do not have enough crystal coins.", cid)
						npcHandler.topic[cid] = topicList.NONE
					else
						count[cid] = getMoneyCount(msg)
						npcHandler:say("So you would like me to change " .. count[cid] .. " of your crystal coins into " .. count[cid] * 100 .. " platinum coins for you?", cid)
						npcHandler.topic[cid] = topicList.CHANGE_CRYSTAL_PLATINUM_CONSENT
					end
				elseif npcHandler.topic[cid] == topicList.CHANGE_CRYSTAL_PLATINUM_CONSENT then
					if msgcontains(msg, "yes") then
						if player:getFreeCapacity() >= getMoneyWeight(count[cid]) then
							if player:removeItem(ITEM_CRYSTAL_COIN, count[cid]) then
								player:addItem(ITEM_PLATINUM_COIN, count[cid] * 100)
								npcHandler:say("Here you are.", cid)
							else
								npcHandler:say("Sorry, you do not have enough crystal coins.", cid)
							end
						else
							npcHandler:say("Whoah, hold on, you have no room in your inventory to carry all those coins. I don't want you to drop it on the floor, maybe come back with a cart!", cid)
						end
					else
						npcHandler:say("Well, can I help you with something else?", cid)
					end
					npcHandler.topic[cid] = topicList.NONE
				else
					npcHandler.topic[cid] = topicList.NONE
				end
			else
				npcHandler:say(string.format(featureLocked, "bank", "banking"), cid)
				npcHandler.topic[cid] = topicList.NONE
			end -- bank branch
		end -- dialogue tree
	end -- hireling module
	return true
end

---- REGISTER
npcHandler:setMessage(MESSAGE_GREET, "It is good to see you. I'm always at your {service}")
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
