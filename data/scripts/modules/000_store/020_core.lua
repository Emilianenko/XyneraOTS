-- description macros
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

-- permission check
function Player:getOfferStatus(offer, fastCheck)
	local messages = {}

	if offer.type == STORE_OFFER_TYPE_OUTFIT then
		-- is an outfit offer
		if self:canWearOutfit(offer.lookTypeMale) or self:canWearOutfit(offer.lookTypeFemale) then
			if fastCheck then
				return STORE_REASON_OWNED_OUTFIT
			end

			messages[#messages + 1] = STORE_REASON_OWNED_OUTFIT
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
	end
	
	return messages
end