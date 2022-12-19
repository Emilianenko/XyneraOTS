function Player:sendStoreMeta()
	local msg = NetworkMessage()
	msg:addByte(0xFB)

	msg:addU16(#StoreCategories)
	for _, category in ipairs(StoreCategories) do
		msg:addString(category.name)
		msg:addByte(0) -- category type?
		
		msg:addByte(1) -- image count
		-- images
		msg:addString(string.format("Category_%s.png", category.image or category.name)) -- category image
			
		if category.parent then
			msg:addString(category.parent)
		else
			msg:addString("")
		end
	end
	
	msg:sendToPlayer(self)
end

function Player:sendStoreRequest(type, offerId)
	local msg = NetworkMessage()
	msg:addByte(0xE1)
	msg:addU32(offerId)
	msg:addByte(type)
	
	-- request types:
	-- 1: player name change (no extra data needed)
	-- 3: hireling name/sex ui (no extra data needed)

	if type == 2 then
		-- character world transfer
		msg:addByte(0) -- byte ignored
		msg:addByte(1) -- world list
			msg:addString("Xynera") -- world name
			msg:addByte(1) -- premium only
			msg:addByte(1) -- isLocked
			msg:addByte(1) -- world type
			
		-- reasons you cant transfer (1 - x symbol)
		msg:addByte(0) -- has red skull
		msg:addByte(0) -- has black skull
		msg:addByte(0) -- has guild
		msg:addByte(0) -- has house
		msg:addByte(0) -- has coins in market
	elseif type == 4 then
		-- main character change ui
		msg:addByte(1) -- character count
		msg:addString("Player") -- character name
		msg:addString("Xynera") -- world
		msg:addString("Druid") -- vocation
		msg:addU16(100) -- level
	elseif type == 5 then
		-- tournament joining ui
		msg:addString("Player") -- character name
		msg:addByte(3) -- world location
			msg:addString("Europe")
			msg:addString("Brazil")
			msg:addString("United States")
		msg:addByte(4) -- vocations
			msg:addByte(1)
			msg:addByte(2)
			msg:addByte(3)
			msg:addByte(4)
		msg:addByte(3) -- starting town
			msg:addString("Carlin")
			msg:addString("Thais")
			msg:addString("Venore")
		msg:addByte(0) -- show warning (bool)
	elseif type == 6 then
		-- "attention" message window with "ok" and "cancel" buttons
		msg:addString("message")
	end
	msg:sendToPlayer(self)
end

function Player:sendStoreMessage(storeMessageType, text)
	local msg = NetworkMessage()
	msg:addByte(0xE0)
	msg:addByte(storeMessageType)
	msg:addString(text)
	msg:sendToPlayer(self)
end

function Player:sendStoreSuccess(text)
	m = NetworkMessage()
	m:addByte(0xFE)
	m:addByte(0x00)
	m:addString(text)
	m:sendToPlayer(self)
end

function NetworkMessage:addStoreOfferError(offerId)
-- keep the tabbing for self-documenting packet structure
	-- error page
	self:addString("Error loading offer")
	self:addByte(1) -- offer amount
		-- offer
		self:addU32(offerId) -- offer id
		self:addU16(0) --amount
		self:addU32(0) --price
		self:addByte(0) -- currency
		self:addByte(1) -- isDisabled
			self:addByte(1) -- reasonCount
			self:addU16(STORE_REASON_ERROR)
		self:addByte(0) -- offerStatus
	self:addByte(STORE_OFFER_TYPE_ITEM) -- offerType
		self:addU16(3547)
	self:addByte(0) -- TryOn Type
	self:addString("") -- parent name (menu or dropdown menu)
	self:addU16(0) -- Popularity Score
	self:addU32(0) -- Published at
	self:addByte(1) -- 0 - buy, 1 - configure
	self:addU16(0) -- "this package contains" list
end

function NetworkMessage:addStoreOffer(offerId, parentName, player)
	local offer = StoreOffers[offerId]
	if not offer then
		self:addStoreOfferError(offerId)
		return
	end
	
	if offer.packages and #offer.packages ~= 0 then
		local offerErrors = player:getOfferStatus(offer)
		self:addString(offer.name)
		self:addByte(#offer.packages) -- offer amount
		for i = 1, #offer.packages do
			local packInfo = offer.packages[i]
			-- price tag data
			self:addU32(packInfo.offerId) -- packInfo.offerId(?)
			self:addU16(packInfo.amount)
			self:addU32(packInfo.price)
			self:addByte(packInfo.currency)

			-- offer unavailable reasons
			local reasonCount = #offerErrors + (packInfo.disabledReasons and #packInfo.disabledReasons or 0)			
			if reasonCount > 0 then
				self:addByte(1)
				self:addByte(reasonCount)
				
				if packInfo.disabledReasons and #packInfo.disabledReasons > 0 then
					for j = 1, #packInfo.disabledReasons do
						self:addU16(packInfo.disabledReasons[j] - 1)
					end
				end
				
				if #offerErrors > 0 then
					for j = 1, #offerErrors do
						self:addU16(offerErrors[j] - 1)
					end
				end
			else
				self:addByte(0)
			end
			
			-- offer status
			self:addByte(packInfo.status)
			if packInfo.status == STORE_CATEGORY_TYPE_DISCOUNT then
				self:addU32(packInfo.discountUntil)
				self:addU32(packInfo.oldPrice)
			end			
		end
	else
		-- push defaults
		self:addStoreOfferError(offerId)
		return
	end

	local offerType = offer.type or 0
	self:addByte(offerType) -- offerType
	
	local tryOnType = 0
	if offerType == STORE_OFFER_TYPE_DEFAULT then
		self:addString(offer.image)
	elseif offerType == STORE_OFFER_TYPE_MOUNT then
		self:addU16(offer.lookType)
		tryOnType = 1
	elseif offerType == STORE_OFFER_TYPE_OUTFIT then
		local outfit = player:getOutfit();
		local lookType = player:getSex() == 1 and offer.lookTypeMale or offer.lookTypeFemale
		self:addU16(lookType)
		-- outfit colors
		self:addByte(outfit.lookHead)
		self:addByte(outfit.lookBody)
		self:addByte(outfit.lookLegs)
		self:addByte(outfit.lookFeet)
		tryOnType = 2
	elseif offerType == STORE_OFFER_TYPE_ITEM then
		self:addU16(ItemType(offer.itemId or 100):getClientId())
	else --if offerType == STORE_OFFER_TYPE_HIRELING then
		self:addByte(1) -- gender - 1 or 2
		self:addU16(offer.lookTypeFemale)
		self:addU16(offer.lookTypeMale)
		self:addByte(outfit.lookHead)
		self:addByte(outfit.lookBody)
		self:addByte(outfit.lookLegs)
		self:addByte(outfit.lookFeet)
	end

	self:addByte(tryOnType) -- TryOn Type
	self:addString(parentName) -- parent name (menu or dropdown menu)
	self:addU16(offer.popularity) -- Popularity Score
	self:addU32(offer.publishedAt) -- Published at
	self:addByte(offer.configurable and 1 or 0) -- 0 - buy, 1 - configure
	if offer.bed then
		self:addU16(2) -- package items
		
		-- headboard
		self:addString(offer.bed[1])
		self:addByte(1) -- offerType item
		self:addU16(offer.bed[2])
		
		-- footboard
		self:addString(offer.bed[3])
		self:addByte(1) -- offerType item
		self:addU16(offer.bed[4])
	else
		self:addU16(0)
	end
end

function Player:sendStoreUI(actionType, tabName, productId)
	local isHomePage = false
	local isSearch = false
	local tabInfo = CategoryToIdMap[tabName] and StoreCategories[CategoryToIdMap[tabName]]
	if tabInfo and tabInfo.redirect then
		tabInfo = StoreCategories[tabInfo.redirect]
	end
	
	if actionType == 5 then
		tabInfo = {
			name = "Search",
		}
		isSearch = true
	elseif actionType == 0 or not tabInfo then
		isHomePage = true
		tabInfo = {
			name = "Home",
		}
	end
	
	self:sendStoreMeta()
	
	local msg = NetworkMessage()
	msg:addByte(0xFC)
	
	-- tree position
	msg:addString(tabInfo.name)
	
	msg:addU32(productId or 0) -- offerId
	msg:addByte(0) -- sort by 0 - most popular, 1 - alphabetically, 2 - newest

	if not isSearch and tabInfo.offerTypes then
		msg:addByte(tabInfo.offerTypeCount) -- dropdown menu middle
		for typeId = 1, #tabInfo.offerTypes do
			msg:addString(tabInfo.offerTypes[typeId].name)
		end
	else
		msg:addByte(0) -- menucount
	end
	
	msg:addString(tabInfo.parent and "" or tabInfo.name) -- dropdown menu position
	-- offer disable reasons
	msg:addU16(StoreOfferDisableReasonsCount)
	for i = 1, STORE_REASON_LAST do
		local reason = StoreOfferDisableReasons[i]
		if reason then
			msg:addString(reason)
		end
	end

	-- add available offers
	local descriptionsToSend = {}
	if isHomePage then
		-- to do: featured
		msg:addU16(0)
	elseif isSearch then
		-- store search
		local queryLength = tabName:len()
		if #StoreOffers > 0 and queryLength > 2 and queryLength < 31 then
			tabName = tabName:lower()
			for i = 1, #StoreOffers do
				local offer = StoreOffers[i]
				if offer.name:lower():match(tabName) then
					-- search results and descs to send use same ids
					-- so there is no point in declaring searchResutls table
					-- to memorize it twice
					descriptionsToSend[#descriptionsToSend + 1] = i
				end
			end
			
			msg:addU16(#descriptionsToSend)
			if #descriptionsToSend > 0 then
				for i = 1, #descriptionsToSend do
					msg:addStoreOffer(descriptionsToSend[i], tabInfo.name, self)
				end
			end
		else
			-- store has no offers or query length is incorrect
			msg:addU16(0)
		end
	else
		-- normal store browsing
		local offerCount = tabInfo.offerCount -- autogenerated
		if offerCount > 0 then
			msg:addU16(offerCount)

			if tabInfo.offers and #tabInfo.offers > 0 then
				for i = 1, #tabInfo.offers do
					msg:addStoreOffer(tabInfo.offers[i], tabInfo.name, self)
					descriptionsToSend[#descriptionsToSend + 1] = tabInfo.offers[i]
				end
			end
			
			if tabInfo.offerTypes and #tabInfo.offerTypes > 0 then
				for dropDownId = 1, #tabInfo.offerTypes do
					local currentTab = tabInfo.offerTypes[dropDownId]
					if currentTab.offers and #currentTab.offers > 0 then
						for offerIndex = 1, #currentTab.offers do
							local currentOfferId = currentTab.offers[offerIndex]
							msg:addStoreOffer(currentOfferId, currentTab.name, self)
							descriptionsToSend[#descriptionsToSend + 1] = currentOfferId
						end
					end
				end
			end
		else
			msg:addU16(0)
		end
	end

	-- homepage banners
	if isHomePage then
		msg:addByte(#StoreBanners)
		for _, banner in ipairs(StoreBanners) do
			msg:addString(banner.image) -- banner.image
			msg:addByte(banner.type) -- Banner Type (offer)
			msg:addU32(banner.offerId) -- offerId
			msg:addByte(0) -- unknown 1
			msg:addByte(0) -- unknown 2
		end
		
		msg:addByte(StoreBannerDelay) -- banner delay
	elseif isSearch then
		msg:addByte(0) -- "too many results" error message when set to 1
	end
	
	-- send tab
	msg:sendToPlayer(self)

	-- send offer descriptions
	for _, offerId in ipairs(descriptionsToSend) do
		local offer = StoreOffers[offerId]
		if offer then
			local m = NetworkMessage()
			m:addByte(0xEA)
			m:addU32(offer.packages[1].offerId)
			m:addString(offer.description)
			m:sendToPlayer(self)
		end
	end

	-- send store coins balance
	self:sendStoreBalance()
end

do
	local ec = EventCallback
	function ec.onStoreBrowse(player, request)
		if request.offerId ~= 0 then
			local offer = StoreOffers[request.offerId]
			if offer then
				request.primaryText = StoreCategories[offer.category].name
			end
		elseif request.actionType == 1 and request.primaryValue == 1 and STORE_OFFERID_XPBOOST then
			request.primaryText = StoreCategories[STORE_TAB_BOOSTS].name
			request.offerId = STORE_OFFERID_XPBOOST
		end
		
		player:sendStoreUI(request.actionType, request.primaryText, request.offerId)
	end
	ec:register()
end
do
	local errMsg = {
		[1] = "Invalid product id!",
		[2] = "Unable to load offer data!",
		[3] = "You do not have enough coins!",
	}

	-- handle "buy" action	
	local ec = EventCallback
	function ec.onStoreBuy(player, offerId, action, name, type, location)
		-- cooldown check
		if os.time() < player:getStorageValue(PlayerStorageKeys.storeLastUseCooldown) then
			player:sendStoreMessage(STORE_MESSAGE_ERROR_BUY, "Please wait a few seconds.")
			return
		end
	
		-- find product by price tag clicked
		local productId = OfferToProductIdMap[offerId]
		if not productId then
			-- indexing failed
			player:sendStoreMessage(STORE_MESSAGE_ERROR_BUY, errMsg[1])
			return
		end
		
		-- find full product data
		local offer = StoreOffers[productId]
		if not offer then
			-- offer indexed but does not exist
			player:sendStoreMessage(STORE_MESSAGE_ERROR_BUY, errMsg[2])
			return
		end
		
		-- product is a service, send a form to fill
		local serviceId = offer.serviceId
		if action == STORE_ACTION_BUY and serviceId and serviceId > STORE_SERVICE_NONE and serviceId <= STORE_SERVICE_LAST_CONFIGURABLE then
			-- filling a form required to complete the purchase
			player:sendStoreRequest(serviceId, offerId)
			return
		end

		-- add cooldown
		player:setStorageValue(PlayerStorageKeys.storeLastUseCooldown, os.time() + 3)
		
		-- get price tag info
		local packInfo
		for i = 1, #offer.packages do
			if not packInfo and offer.packages[i].offerId == offerId then
				packInfo = offer.packages[i]
			end
		end
		if not packInfo then
			player:sendStoreMessage(STORE_MESSAGE_ERROR_BUY, errMsg[2])
			return
		end
		
		-- get account currency status
		if packInfo.currency == STORE_CURRENCY_COINS then
			if player:getStoreCoins() < packInfo.price then
				player:sendStoreMessage(STORE_MESSAGE_ERROR_BUY, errMsg[3])
				return
			end
		else
			if player:getAccountResource(packInfo.currency) < packInfo.price then
				player:sendStoreMessage(STORE_MESSAGE_ERROR_BUY, errMsg[3])
				return
			end
		end
		
		-- check if player can buy this offer
		local buyRet = player:getOfferStatus(offer, true)
		if buyRet ~= STORE_REASON_OK then
			-- buy button was active, but offer is no longer available
			-- example scenario:
			-- player tried to buy temple tp
			-- player was not in fight when opening store
			-- a monster spawned and player can no longer buy this offer
			player:sendStoreMessage(STORE_MESSAGE_ERROR_BUY, StoreOfferDisableReasons[buyRet])
			return
		end
		
		-- all checks were performed
		-- consume coins and send item to player
		player:processStorePurchase(offerId, productId, name, type, location)
	end
	ec:register()
end
do
	local ec = EventCallback
	function ec.onStoreHistoryBrowse(player, pageId, isInit)
		player:addDispatcherTask(storeLoadHistoryPage, DISPATCHER_PAGINATION, player:getId(), pageId)
	end
	ec:register()
end

function Player:viewStoreHistoryPage(pageId)
	m = NetworkMessage()
	m:addByte(0xFD)
	m:addU32(pageId)
	m:addU32(self:getStoreHistoryPageCount())

	local page = self:getStoreHistoryPage(pageId)
	m:addByte(#page) -- amount of entries
	if #page > 0 then
		for i = 1, #page do
			local row = page[i]
			m:addU32(row.id) -- transactionId
			m:addU32(row.date)
			m:addByte(row.status) -- 0 - amount, 1 - gift, 2 - refund
			m:addI32(row.price) -- price
			m:addByte(row.currency) -- currency
			
			-- offer name
			local amount = row.amount > 1 and string.format("%dx ", row.amount) or ""
			m:addString(string.format("%s%s", amount, row.name))
			m:addByte(0) -- show details button
		end
	end
	
	m:sendToPlayer(self)
end

function storeLoadHistoryPage(playerId, pageId)
	local player = Player(playerId)
	if player then
		player:viewStoreHistoryPage(pageId)
	end
end