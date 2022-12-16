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
		-- checkboxes
		msg:addByte(0)
		msg:addByte(0)
		msg:addByte(0)
		msg:addByte(0)
		msg:addByte(0)
		msg:addByte(0)
		-- list of worlds
		msg:addByte(0)
	elseif type == 4 then
		-- main character change ui
		msg:addByte(1) -- character count
		msg:addString("Player") -- name
		msg:addString("Xynera") -- world
		msg:addString("Druid") -- vocation
		msg:addU16(100) -- level
	elseif type == 5 then
		-- tournament ui
		msg:addString("Twoj Stary Pijany")
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
		msg:addString("message")
	end
	msg:sendToPlayer(self)
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
			self:addU32(offerId) -- packinfo.offerId(?)
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
	self:addByte(offer.configurable) -- 0 - buy, 1 - configure
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
			msg:addString(banner.image)--banner.image
			msg:addByte(banner.type) -- Banner Type (offer)
			msg:addU32(banner.offerId) -- offerId
			msg:addByte(0) -- unknown 1
			msg:addByte(0) -- unknown 1
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
			m:addU32(offerId)
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
