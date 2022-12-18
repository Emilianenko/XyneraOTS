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

-- bed offer generator and helpers
local function wordHelper(first, rest)
   return string.format("%s%s", first:upper(), rest:lower())
end

local function upAllWords(text)
	return string.gsub(text, "(%a)([%w_']*)", wordHelper)
end

local lastOfferId = 0
function GenerateBed(bedName, price, publishedAt, headBoard, footBoard)
	local hb = ItemType(headBoard)
	local fb = ItemType(footBoard)
	local bed = {
		string.format("%s Headboard", upAllWords(hb:getName())), hb:getClientId(),
		string.format("%s Footboard", upAllWords(fb:getName())), fb:getClientId()
	}

	local productId = #StoreOffers + 1
	lastOfferId = lastOfferId + 1
	StoreOffers[productId] = {
		name = bedName,
		description = desc_bed,
		publishedAt = publishedAt,

		packages = {
			[1] = {
				amount = 1,
				price = price,
				currency = STORE_CURRENCY_COINS,
				offerId = lastOfferId,
				status = STORE_CATEGORY_TYPE_NORMAL,
			},
		},
	
		type = STORE_OFFER_TYPE_DEFAULT,
		image = string.format("%s.png", bedName:gsub(" ", "_")),
		bed = bed,
		
		-- for direct offer id request
		category = STORE_TAB_BEDS,
	}
	
	table.insert(StoreCategories[STORE_TAB_BEDS].offers, productId)
end

-- mount offer generator
function GenerateMount(name, lookType, price, publishedAt, description)
	local tier = price > 800 and 3 or price < 750 and 1 or 2

	local productId = #StoreOffers + 1
	lastOfferId = lastOfferId + 1
	StoreOffers[productId] = {
		name = name,
		description = string.format("{character}\n{speedboost}\n\n<i>%s</i>", description),
		publishedAt = publishedAt,

		packages = {
			[1] = {
				amount = 1,
				price = price,
				currency = STORE_CURRENCY_COINS,
				offerId = lastOfferId,
				status = STORE_CATEGORY_TYPE_NORMAL,
			},
		},
	
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = lookType,
		
		-- for direct offer id request
		category = STORE_TAB_MOUNTS,
		subCategory = tier
	}
	
	table.insert(StoreCategories[STORE_TAB_MOUNTS].offerTypes[tier].offers, productId)
	
	Game.setStoreMount(lookType, lastOfferId)
end

-- premium time (vip pass) generator
function GeneratePremium(days, price, publishedAt)
	local productId = #StoreOffers + 1
	lastOfferId = lastOfferId + 1
	StoreOffers[productId] = {
		name = string.format("%d days", days),
		description = desc_premium,
		publishedAt = publishedAt,

		packages = {
			[1] = {
				amount = 1,
				price = price,
				currency = STORE_CURRENCY_COINS,
				offerId = lastOfferId,
				status = STORE_CATEGORY_TYPE_NORMAL,
			},
		},
	
		type = STORE_OFFER_TYPE_DEFAULT,
		image = string.format("Premium_Time_%d.png", days),
		premDays = days,
		-- for direct offer id request
		category = STORE_TAB_PREMIUM,
	}
	
	table.insert(StoreCategories[STORE_TAB_PREMIUM].offers, productId)
end

-- XP Boost
function GenerateXPBoost(price)
	local productId = #StoreOffers + 1
	lastOfferId = lastOfferId + 1
	StoreOffers[productId] = {
		name = "XP Boost",
		description = [[<i>Purchase a boost that increases the experience points your character gains from hunting by 50%!</i>

{character}
{info} lasts for 1 hour hunting time
{info} paused if stamina falls under 14 hours
{info} can be purchased up to 5 times between 2 server saves
{info} price increases with every purchase
{info} cannot be purchased if an XP boost is already active]],

		publishedAt = 0,
		packages = {
			[1] = {
				amount = 1,
				price = price,
				currency = STORE_CURRENCY_COINS,
				offerId = lastOfferId,
				status = STORE_CATEGORY_TYPE_NORMAL,
			},
		},
	
		type = STORE_OFFER_TYPE_DEFAULT,
		image = "Product_XpBoost.png",
		XPBoost = true,
		
		-- for direct offer id request
		category = STORE_TAB_BOOSTS,
	}
	
	table.insert(StoreCategories[STORE_TAB_BOOSTS].offers, productId)
	
	STORE_OFFERID_XPBOOST = productId
end

-- outfit offer generator and macros
local descOutfitColor = "{character}\n{info} colours can be changed using the Outfit dialog\n"
local descOutfitAddons = "{info} includes basic outfit and 2 addons which can be selected individually\n"

function GenerateOutfit(name, lookTypeM, lookTypeF, price, publishedAt, description)
	local retro = name:lower():match("retro") and true
	local tier = retro and 4 or price > 850 and 3 or price < 730 and 1 or 2
	local productId = #StoreOffers + 1
	lastOfferId = lastOfferId + 1
	StoreOffers[productId] = {
		name = name,
		description = string.format("%s%s\n<i>%s</i>", descOutfitColor, retro and "" or descOutfitAddons, description),
		publishedAt = publishedAt,

		packages = {
			[1] = {
				amount = 1,
				price = price,
				currency = STORE_CURRENCY_COINS,
				offerId = lastOfferId,
				status = STORE_CATEGORY_TYPE_NORMAL,
			},
		},
	
		type = STORE_OFFER_TYPE_OUTFIT,
		lookTypeMale = lookTypeM,
		lookTypeFemale = lookTypeF,
		
		-- for direct offer id request
		category = STORE_TAB_OUTFITS,
		subCategory = tier
	}
	
	table.insert(StoreCategories[STORE_TAB_OUTFITS].offerTypes[tier].offers, productId)
	
	Game.setStoreOutfit(lookTypeM, lastOfferId)
	Game.setStoreOutfit(lookTypeF, lastOfferId)
end

-- carpet offer generator
function GenerateCarpet(itemId, price, publishedAt)
	local productId = #StoreOffers + 1
	lastOfferId = lastOfferId + 1
	StoreOffers[productId] = {
		name = upAllWords(ItemType(itemId):getName()),
		description = desc_carpet,
		publishedAt = publishedAt,

		packages = {
			[1] = {
				amount = 1,
				price = price,
				currency = STORE_CURRENCY_COINS,
				offerId = lastOfferId,
				status = STORE_CATEGORY_TYPE_NORMAL,
			},
			[2] = {
				amount = 5,
				price = price * 5,
				currency = STORE_CURRENCY_COINS,
				offerId = lastOfferId + 1,
				status = STORE_CATEGORY_TYPE_NORMAL,
			},
		},
	
		type = STORE_OFFER_TYPE_ITEM,
		itemId = CarpetMap[itemId],
		
		-- for direct offer id request
		category = STORE_TAB_DECORATIONS,
		subCategory = 1
	}

	-- +1 for every price tag after first
	lastOfferId = lastOfferId + 1
	
	table.insert(StoreCategories[STORE_TAB_DECORATIONS].offerTypes[1].offers, productId)
end

-- generic offer generator
-- amountBase - amount on first price tag (example: 1)
-- amountMulti - multiplier for second price tag (example: 5), no second price tag if nil
function GenerateStoreItem(itemId, price, category, subCategory, publishedAt, amountBase, amountMulti, description)
	local productId = #StoreOffers + 1
	lastOfferId = lastOfferId + 1
	local offer = {
		name = upAllWords(ItemType(itemId):getName()),
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
	
		type = STORE_OFFER_TYPE_ITEM,
		itemId = itemId,
		
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
end

function GenerateStoreService(name, serviceId, price, category, image, publishedAt, description)
	if not serviceId or serviceId < 1 or serviceId > STORE_SERVICE_LAST then
		return
	end

	local productId = #StoreOffers + 1
	lastOfferId = lastOfferId + 1
	StoreOffers[productId] = {
		name = name,
		description = description,
		publishedAt = publishedAt,

		packages = {
			[1] = {
				amount = 1,
				price = price,
				currency = STORE_CURRENCY_COINS,
				offerId = lastOfferId,
				status = STORE_CATEGORY_TYPE_NORMAL,
			},
		},
	
		type = STORE_OFFER_TYPE_DEFAULT,
		image = image,
		serviceId = serviceId,
		configurable = serviceId <= STORE_SERVICE_LAST_CONFIGURABLE,
		
		-- for direct offer id request
		category = category
	}

	table.insert(StoreCategories[category].offers, productId)
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
	
	-- add product / perform a service
	-- checks were already performed
	local success = false
	if offer.type == STORE_OFFER_TYPE_OUTFIT then
		-- outfit offer
		self:addOutfitAddon(offer.lookTypeMale, 3)
		self:addOutfitAddon(offer.lookTypeFemale, 3)
		success = true
	elseif offer.type == STORE_OFFER_TYPE_MOUNT then
		-- mount offer
		self:addMount(Game.getMountIdByLookType(offer.lookType))
		success = true
	elseif offer.type == STORE_OFFER_TYPE_ITEM then
		if offer.itemId == ITEM_GOLD_POUCH then
			self:setStorageValue(PlayerStorageKeys.storeGoldPouchBought, 1)
		end

		-- item offer
		self:addStoreKit(ReverseCarpetMap and ReverseCarpetMap[offer.itemId] or offer.itemId, packInfo.amount)
		success = true
	elseif offer.bed then
		-- bed offer
		-- add footBoard first so headBoard lands on first slot of store inbox
		self:addStoreKit(Game.getItemTypeByClientId(offer.bed[4]):getId(), packInfo.amount)
		self:addStoreKit(Game.getItemTypeByClientId(offer.bed[2]):getId(), packInfo.amount)
		success = true
	elseif offer.premDays then
		-- vip system
		-- not supported yet
	elseif offer.XPBoost then
		-- xp boost
		-- not supported yet
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
							self:rename(name)
							success = true
						end
					else
						self:sendStoreMessage(STORE_MESSAGE_ERROR_BUY, string.format("Name \"%s\" is already in use!", name))
						return
					end
				end
			elseif serviceId == STORE_SERVICE_SEX_CHANGE then
				self:changeSex()
				success = true
			elseif serviceId == STORE_SERVICE_TEMPLE_TELEPORT then
				self:teleportTo(self:getTown():getTemplePosition())
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
end

-- to do: save players and houses
-- add logging