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
	
	self:addString(offer.name)
	if offer.packages and #offer.packages ~= 0 then
		self:addByte(#offer.packages) -- offer amount
		for i = 1, #offer.packages do
			local packInfo = offer.packages[i]
		
			self:addU32(offerId) -- offerId(?)
			self:addU16(packInfo.amount)
			self:addU32(packInfo.price)
			self:addByte(packInfo.currency)
			if packInfo.disabledReasons and #packInfo.disabledReasons > 0 then
				self:addByte(1)
				self:addByte(#packInfo.disabledReasons)
				for i = 1, #packInfo.disabledReasons do
					self:addU16(packInfo.disabledReasons[i] - 1)
				end
			else
				self:addByte(0)
			end
			
			self:addByte(packInfo.status)
			if packInfo.status == STORE_CATEGORY_TYPE_DISCOUNT then
				self:addU32(packInfo.discountUntil)
				self:addU32(packInfo.oldPrice)
			end			
		end
	else
		-- push defaults
		self:addByte(1) -- offer amount
			self:addU32(offerId) -- offer id
			self:addU16(0) -- amount
			self:addU32(0) -- price
			self:addByte(0) -- currency
			self:addByte(1) -- isDisabled
				self:addByte(0) -- reasonCount
					--self:addString("Offer disabled.")
			self:addByte(0) -- offerStatus
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

		self:addU16(player:getSex() == 1 and offer.lookTypeMale or offer.lookTypeFemale)
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

function Player:sendStoreUI(actionType, tabName)
	local isHomePage = false
	local tabInfo = CategoryToIdMap[tabName] and StoreCategories[CategoryToIdMap[tabName] ]
	if tabInfo and tabInfo.redirect then
		tabInfo = StoreCategories[tabInfo.redirect]
	end
	
	if actionType == 0 or not tabInfo then
		isHomePage = true
		tabInfo = {
			name = "Home",
		}
	end

	if isHomePage then
		self:sendStoreMeta()
	end
	
	local msg = NetworkMessage()
	msg:addByte(0xFC)
	
	-- tree position
	msg:addString(tabInfo.name)
	
	msg:addU32(0) -- offerId
	msg:addByte(0) -- sort by 0 - most popular, 1 - alphabetically, 2 - newest
	if tabInfo.offerTypes then
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
	for _, reason in pairs(StoreOfferDisableReasons) do
		msg:addString(reason)
	end
	
	-- add available offers
	local descriptionsToSend = {}
	if isHomePage then
		-- to do: featured
		msg:addU16(0)
	else
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
		player:sendStoreUI(request.actionType, request.primaryText)
	end
	ec:register()
end
