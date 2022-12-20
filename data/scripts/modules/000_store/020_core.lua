-- description macros
-- to do: change prem to one char on acc
local desc_premium = [[<i>Enhance your gaming experience by gaining additional abilities and advantages:</i>

&#8226; access to Premium areas
&#8226; use fast transport system (ships, carpet)
&#8226; more spells
&#8226; rent houses
&#8226; found guilds
&#8226; offline training
&#8226; larger depots
&#8226; and many more

{usablebyallicon} valid for all characters on this account
{activated}]]

local desc_carpet = [[{house}
{box}
{storeinbox}
{useicon} use an unwrapped carpet to roll it out or up
{backtoinbox}]]

local desc_bed = [[<i>Sleep in a bed to restore soul, mana and hit points and to train your skills!</i>

{house}
{boxicon} comes in 2 boxes which can only be unwrapped by purchasing character, put the 2 parts together to get a functional bed
{storeinbox}
{usablebyallicon} if not already occupied, it can be used by every Premium character that has access to the house
{useicon} use it to sleep in it
{backtoinbox}]]

local desc_decoration = [[{house}
{box}
{storeinbox}
{backtoinbox}]]

local desc_decoration_useable = [[{house}
{box}
{storeinbox}
{use}
{backtoinbox}]]

local desc_rune = [[{character}
{storeinbox}
{vocationlevelcheck}
{battlesign}
{capacity}]]

local desc_xpboost = [[<i>Purchase a boost that increases the experience points your character gains from hunting by 50%!</i>

{character}
{info} lasts for 1 hour hunting time
{info} paused if stamina falls under 14 hours
{info} can be purchased up to 5 times between 2 server saves
{info} price increases with every purchase
{info} cannot be purchased if an XP boost is already active]]

-- bed offer generator and helpers
local function wordHelper(first, rest)
   return string.format("%s%s", first:upper(), rest:lower())
end

local function upAllWords(text)
	return string.gsub(text, "(%a)([%w_']*)", wordHelper)
end

local lastOfferId = 0

-- generic offer generator
-- amountBase - amount on first price tag (example: 1)
-- amountMulti - multiplier for second price tag (example: 5), no second price tag if nil
function StoreCreateOffer(name, price, category, subCategory, publishedAt, amountBase, amountMulti, description)
	local productId = #StoreOffers + 1
	lastOfferId = lastOfferId + 1
	local offer = {
		name = name,
		description = description,
		publishedAt = publishedAt,

		packages = {
			[1] = {
				amount = amountBase,
				price = price,
				currency = STORE_CURRENCY_COINS,
				offerId = lastOfferId,
				status = STORE_CATEGORY_TYPE_NORMAL,
			},
		},
			
		-- for direct offer id request
		category = category,
		subCategory = subCategory
	}

	-- second price tag
	if amountMulti then
		lastOfferId = lastOfferId + 1
		offer.packages[2] = {
			amount = amountBase * amountMulti,
			price = price * amountMulti,
			currency = STORE_CURRENCY_COINS,
			offerId = lastOfferId + 1,
			status = STORE_CATEGORY_TYPE_NORMAL,
		}
	end
	
	StoreOffers[productId] = offer
	
	if subCategory then
		table.insert(StoreCategories[category].offerTypes[subCategory].offers, productId)
	else
		table.insert(StoreCategories[category].offers, productId)
	end
	
	-- xp boost button in skills window
	if name == "XP Boost" then
		STORE_OFFERID_XPBOOST = productId
	end
	
	return StoreOffers[productId]
end

-- item offer generator
function GenerateStoreItem(itemId, price, category, subCategory, publishedAt, amountBase, amountMulti, description)
	local offer = StoreCreateOffer(
		upAllWords(ItemType(itemId):getName()),
		price, category, subCategory, publishedAt,
		amountBase, amountMulti, description
	)

	offer.type = STORE_OFFER_TYPE_ITEM
	offer.itemId = itemId	
end

-- bed offer generator
function GenerateBed(bedName, price, publishedAt, headBoard, footBoard)
	local offer = StoreCreateOffer(
		bedName, price, STORE_TAB_BEDS, nil,
		publishedAt, 1, nil, desc_bed
	)
	
	local hb = ItemType(headBoard)
	local fb = ItemType(footBoard)
	local bed = {
		string.format("%s Headboard", upAllWords(hb:getName())), hb:getClientId(),
		string.format("%s Footboard", upAllWords(fb:getName())), fb:getClientId()
	}

	offer.type = STORE_OFFER_TYPE_DEFAULT
	offer.image = string.format("%s.png", bedName:gsub(" ", "_"))
	offer.bed = bed
end

-- outfit offer generator and macros
local descOutfitColor = "{character}\n{info} colours can be changed using the Outfit dialog\n"
local descOutfitAddons = "{info} includes basic outfit and 2 addons which can be selected individually\n"

function GenerateOutfit(name, lookTypeM, lookTypeF, price, publishedAt, description)
	local retro = name:lower():match("retro") and true
	local tier = retro and 4 or price > 850 and 3 or price < 730 and 1 or 2

	local offer = StoreCreateOffer(
		name, price, STORE_TAB_OUTFITS, tier,
		publishedAt, 1, nil,
		string.format("%s%s\n<i>%s</i>", descOutfitColor, retro and "" or descOutfitAddons, description)
	)
	
	offer.type = STORE_OFFER_TYPE_OUTFIT
	offer.lookTypeMale = lookTypeM
	offer.lookTypeFemale = lookTypeF

	Game.setStoreOutfit(lookTypeM, lastOfferId)
	Game.setStoreOutfit(lookTypeF, lastOfferId)
end

-- mount offer generator
function GenerateMount(name, lookType, price, publishedAt, description)
	local tier = price > 800 and 3 or price < 750 and 1 or 2
	
	local offer = StoreCreateOffer(
		name, price, STORE_TAB_MOUNTS, tier,
		publishedAt, 1, nil,
		string.format("{character}\n{speedboost}\n\n<i>%s</i>", description)
	)
	
	offer.type = STORE_OFFER_TYPE_MOUNT
	offer.lookType = lookType
	
	Game.setStoreMount(lookType, lastOfferId)
end

-- premium time (vip pass) generator
function GeneratePremium(days, price, publishedAt)
	local offer = StoreCreateOffer(
		string.format("%d days", days), price,
		STORE_TAB_PREMIUM, nil, publishedAt, 1, nil,
		desc_premium
	)
	
	offer.type = STORE_OFFER_TYPE_DEFAULT
	offer.image = string.format("Premium_Time_%d.png", days)
	offer.premDays = days
end

-- XP Boost
function GenerateXPBoost(price)
	local offer = StoreCreateOffer(
		"XP Boost", price,
		STORE_TAB_BOOSTS, nil, publishedAt, 1, nil,
		desc_xpboost
	)
	
	offer.type = STORE_OFFER_TYPE_DEFAULT
	offer.image = "Product_XpBoost.png"
	offer.XPBoost = true
end

-- carpet offer generator
function GenerateCarpet(itemId, price, publishedAt)
	local offer = StoreCreateOffer(
		upAllWords(ItemType(itemId):getName()), price,
		STORE_TAB_DECORATIONS, 1, publishedAt, 1, 5,
		desc_carpet
	)

	offer.type = STORE_OFFER_TYPE_ITEM
	offer.itemId = CarpetMap[itemId]
end

-- rune offer generator
function GenerateRune(itemId, price, runeType, publishedAt, description)
	GenerateStoreItem(
		itemId, price,
		STORE_TAB_RUNES, runeType,
		publishedAt, 250, nil,
		string.format("%s\n\n<i>%s</i>", desc_rune, description)
	)
end

-- service offer generator
function GenerateStoreService(name, serviceId, price, category, image, publishedAt, description)
	if not serviceId or serviceId < 1 or serviceId > STORE_SERVICE_LAST then
		return
	end

	local offer = StoreCreateOffer(
		name, price,
		category, nil, publishedAt, 1, nil,
		description
	)
	
	offer.type = STORE_OFFER_TYPE_DEFAULT
	offer.image = image
	offer.serviceId = serviceId
	offer.configurable = serviceId <= STORE_SERVICE_LAST_CONFIGURABLE
end

-- permission check
function Player:getOfferStatus(offer, fastCheck)
	local messages = {}

	if offer.type == STORE_OFFER_TYPE_OUTFIT then
		if not Outfit(offer.lookTypeMale) or not Outfit(offer.lookTypeFemale) then
			-- is valid outfit offer
			if fastCheck then
				return STORE_REASON_ERROR
			end
			
			messages[#messages + 1] = STORE_REASON_ERROR
		else
			-- was outfit already bought
			if self:canWearOutfit(offer.lookTypeMale) or self:canWearOutfit(offer.lookTypeFemale) then
				if fastCheck then
					return STORE_REASON_OWNED_OUTFIT
				end

				messages[#messages + 1] = STORE_REASON_OWNED_OUTFIT
			end
		end
	elseif offer.type == STORE_OFFER_TYPE_MOUNT then
		-- is a mount offer
		local mid = Game.getMountIdByLookType(offer.lookType)
		if mid then
			if self:hasMount(mid) then
				if fastCheck then
					return STORE_REASON_OWNED_MOUNT
				end

				messages[#messages + 1] = STORE_REASON_OWNED_MOUNT
			end
		else
			if fastCheck then
				return STORE_REASON_ERROR
			end
			
			messages[#messages + 1] = STORE_REASON_ERROR
		end
	elseif offer.serviceId then
		local serviceId = offer.serviceId
		if serviceId > STORE_SERVICE_NONE and serviceId <= STORE_SERVICE_LAST then
			-- supported service types
			if serviceId == STORE_SERVICE_BUY_HIRELING then
				-- conditions will apply
			elseif serviceId == STORE_SERVICE_TEMPLE_TELEPORT then
				-- temple tp - distance check
				local currentPos = self:getPosition()
				local homePos = self:getTown():getTemplePosition()
				if currentPos:getDistance(homePos) < 15 and math.abs(currentPos.z - homePos.z) < 3 then
					if fastCheck then
						return STORE_REASON_TOO_CLOSE
					end
					
					messages[#messages + 1] = STORE_REASON_TOO_CLOSE
				end
				
				-- temple tp - infight check
				if self:hasCondition(CONDITION_INFIGHT) and not self:getTile():getZone() == ZONE_PROTECTION then					
					if fastCheck then
						return STORE_REASON_INFIGHT
					end
					
					messages[#messages + 1] = STORE_REASON_INFIGHT
				end
			end
		else
			-- unsupported service type
			if fastCheck then
				return STORE_REASON_ERROR
			end
			
			messages[#messages + 1] = STORE_REASON_ERROR
		end		
	else
		-- in house items tab
		local parentName = StoreCategories[offer.category].parent
		if parentName and parentName == StoreCategories[STORE_TAB_HOUSES].name then
			if not self:getHouse() then
				if fastCheck then
					return STORE_REASON_NEED_HOUSE
				end
				
				messages[#messages + 1] = STORE_REASON_NEED_HOUSE
			end
		end
		
		if offer.type == STORE_OFFER_TYPE_ITEM then
			local itemType = ItemType(offer.itemId)
			if itemType then
				if itemType:isPickupable() and self:getFreeCapacity() < itemType:getWeight() * offer.packages[1].amount then
					if fastCheck then
						return STORE_REASON_CAPACITY
					end
					
					messages[#messages + 1] = STORE_REASON_CAPACITY
				end
				
				if itemType:getId() == ITEM_GOLD_POUCH then
					-- can only be bought once
					if self:getStorageValue(PlayerStorageKeys.storeGoldPouchBought) == 1 then
						if fastCheck then
							return STORE_REASON_GOLD_POUCH
						end
						
						messages[#messages + 1] = STORE_REASON_GOLD_POUCH
					end
				elseif itemType:isRune() then
					local rune = Spell(itemType:getId())
					if rune then
						if self:getLevel() < rune:runeLevel() then
							if fastCheck then
								return STORE_REASON_LEVEL
							end
							
							messages[#messages + 1] = STORE_REASON_LEVEL
						end
						
						if self:getBaseMagicLevel() < rune:runeMagicLevel() then
							if fastCheck then
								return STORE_REASON_MAGLEVEL
							end
							
							messages[#messages + 1] = STORE_REASON_MAGLEVEL
						end
						
						local runeVocMap = rune:vocation()
						if runeVocMap and #runeVocMap > 0 then
							local vocFound = false
							local pVocName = self:getVocation():getName()
							for _, runeVocName in ipairs(runeVocMap) do
								if pVocName:match(runeVocName) then
									vocFound = true
									break
								end
							end
							
							if not vocFound then
								if fastCheck then
									return STORE_REASON_VOCATION
								end
								
								messages[#messages + 1] = STORE_REASON_VOCATION
							end
						end
					end
				end
			else
				if fastCheck then
					return STORE_REASON_ERROR
				end
				
				messages[#messages + 1] = STORE_REASON_ERROR
			end
		end
	end
	
	return fastCheck and STORE_REASON_OK or messages
end

function Player:addStoreKit(furnitureId, amount)
	local it = ItemType(furnitureId)
	if it:isPickupable() then
		self:addStoreItem(furnitureId, amount)
	else
		for i = 1, amount do
			local kit = self:addStoreItem(ITEM_STORE_KIT, 1)
			kit:setAttribute(ITEM_ATTRIBUTE_WRAPID, furnitureId)
		end
	end
end

-- method for both offline and online players
function AppendStoreHistory(accountId, playerGuid, ip, offerName, amount, price, currency, param1, param2)
	local resultId = db.storeQuery(string.format("SELECT `email` FROM `accounts` WHERE `id` = %d", accountId))
	local email = ""
	if resultId ~= false then
		email = result.getString(resultId, "email") or ""
		result.free(resultId)
	end

	local columns = "`date`,`status`,`account_id`,`player_id`,`email`,`ip`,`name`,`amount`,`price`,`currency`,`param_1`,`param_2`"
	local fields = {os.time(), 0, accountId, playerGuid, db.escapeString(email), ip, db.escapeString(offerName), amount, price, currency, param1 and db.escapeString(param1) or "''", param2 and db.escapeString(param2) or "''"}
	local q = string.format("INSERT INTO `store_history` (%s) VALUES (%s)", columns, table.concat(fields, ","))
	db.query(q)	
end

-- method for online players
function Player:appendStoreHistory(offerName, amount, price, currency, param1, param2)
	AppendStoreHistory(self:getAccountId(), self:getGuid(), self:getIp(), offerName, amount, price, currency, param1, param2)
end

function Player:processStorePurchase(offerId, productId, name, type, location)
	-- launched from onStoreBuy
	-- checks were already performed so we assume that the table entries exist
	
	-- fetch offer data
	local offer = StoreOffers[productId]
	
	-- fetch price tag
	local packInfo
	for i = 1, #offer.packages do
		if not packInfo and offer.packages[i].offerId == offerId then
			packInfo = offer.packages[i]
		end
	end
	
	-- declare offer params
	local param1, param2
	
	-- add product / perform a service
	-- checks were already performed
	local success = false
	if offer.type == STORE_OFFER_TYPE_OUTFIT then
		-- outfit offer
		param1 = offer.lookTypeMale
		param2 = offer.lookTypeFemale
		self:addOutfitAddon(param1, 3)
		self:addOutfitAddon(param2, 3)
		success = true
	elseif offer.type == STORE_OFFER_TYPE_MOUNT then
		-- mount offer
		param1 = offer.lookType
		param2 = Game.getMountIdByLookType(param1)
		self:addMount(param2)
		success = true
	elseif offer.type == STORE_OFFER_TYPE_ITEM then
		if offer.itemId == ITEM_GOLD_POUCH then
			param2 = PlayerStorageKeys.storeGoldPouchBought
			self:setStorageValue(param2, 1)
		end

		param1 = ReverseCarpetMap and ReverseCarpetMap[offer.itemId] or offer.itemId
		
		-- item offer
		self:addStoreKit(param1, packInfo.amount)
		success = true
	elseif offer.bed then
		-- bed offer
		-- add footBoard first so headBoard lands on first slot of store inbox
		param1 = Game.getItemTypeByClientId(offer.bed[4]):getId()
		param2 = Game.getItemTypeByClientId(offer.bed[2]):getId()
		self:addStoreKit(param1, packInfo.amount)
		self:addStoreKit(param2, packInfo.amount)
		success = true
	elseif offer.premDays then
		param1 = offer.premDays
		-- vip system
		-- not supported yet
	elseif offer.XPBoost then
		-- xp boost
		-- not supported yet
		-- param1 - boost id(?)
	elseif offer.serviceId then
		-- store services
		local serviceId = offer.serviceId
		if serviceId > 0 and serviceId <= STORE_SERVICE_LAST then
			if serviceId == STORE_SERVICE_NAME_CHANGE then
				if name and name:len() > 0 then
					-- prevent duplicate player names
					if not Game.playerExists(name) then
						local ret = Game.verifyName(name)
						if ret then
							self:sendStoreMessage(STORE_MESSAGE_ERROR_BUY, ret)
							return
						else
							param1 = self:getName()
							param2 = name
							self:rename(name)
							success = true
						end
					else
						self:sendStoreMessage(STORE_MESSAGE_ERROR_BUY, string.format("Name \"%s\" is already in use!", name))
						return
					end
				end
			elseif serviceId == STORE_SERVICE_SEX_CHANGE then
				param1 = self:getSex()
				self:changeSex()
				param2 = self:getSex()
				success = true
			elseif serviceId == STORE_SERVICE_TEMPLE_TELEPORT then
				local currentPos = self:getPosition()
				local homePos = self:getTown():getTemplePosition()
				self:teleportTo(homePos)
				homePos:sendMagicEffect(CONST_ME_TELEPORT)
				param1 = string.format("%d,%d,%d", currentPos.x, currentPos.y, currentPos.z)
				param2 = string.format("%d,%d,%d:%d", homePos.x, homePos.y, homePos.z, self:getTown():getId())
				success = true
			end
		end
	end
	
	-- service configuration checker
	if not success then
		self:sendStoreMessage(STORE_MESSAGE_ERROR_BUY, "Service not supported!")
		return
	end
	
	local amountStr = packInfo.amount ~= 0 and string.format("%dx ", packInfo.amount) or ""
	self:sendStoreSuccess(string.format("You have bought %s%s for %d coins!", amountStr, offer.name, packInfo.price))
	
	-- consume coins
	if packInfo.currency == STORE_CURRENCY_COINS then
		self:addStoreCoins(-packInfo.price)
	else
		self:addAccountResource(packInfo.currency, -packInfo.price)
	end
	
	-- add to history
	self:appendStoreHistory(offer.name, packInfo.amount, -packInfo.price, packInfo.currency, param1, param2)
end

local historyPageCountCache = {}
local pageQueryCooldown = 5
local entriesPerPage = 25

function Player:getStoreHistoryPageCount()
	local cid = self:getId()
	if historyPageCountCache[cid] and os.time() < historyPageCountCache[cid][1] then
		return historyPageCountCache[cid][2]
	end
	
	local pageCount = 0
	local resultId = db.storeQuery("SELECT COUNT(*) AS `count` FROM `store_history` WHERE `account_id` = 1")
	if resultId ~= false then
		pageCount = math.floor(math.max((result.getNumber(resultId, "count") or 0) - 1, 0) / entriesPerPage) + 1
		result.free(resultId)
	end
	
	historyPageCountCache[cid] = {os.time() + pageQueryCooldown, pageCount}
	return pageCount
end

function Player:getStoreHistoryPage(pageId)
	local page = {}
	local q = "SELECT `transaction_id`, `date`, `status`, `name`, `amount`, `price`, `currency` FROM `store_history` WHERE `account_id` = %d ORDER BY `transaction_id` DESC LIMIT %d, %d;"
	local resultId = db.storeQuery(string.format(q, self:getAccountId(), pageId * entriesPerPage, entriesPerPage))
	if resultId ~= false then
		repeat
			page[#page + 1] = {
				id = result.getNumber(resultId, "transaction_id"),
				name = result.getString(resultId, "name"),
				date = result.getNumber(resultId, "date"),
				status = result.getNumber(resultId, "status"),
				amount = result.getNumber(resultId, "amount"),
				price = result.getNumber(resultId, "price"),
				currency = result.getNumber(resultId, "currency")
			}
		until not result.next(resultId)
		result.free(resultId)
	end
	
	return page
end