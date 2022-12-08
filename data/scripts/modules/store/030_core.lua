-- autogenerate helpers for store indexing
local categoryToIdMap = {}
for index, categoryData in pairs(StoreCategories) do
	-- index category
	categoryToIdMap[categoryData.name] = index
	
	-- cache offer count
	local offerCount = 0
	if categoryData.offers then
		offerCount = offerCount + #categoryData.offers
	end
	
	local offerTypeCount = 0
	if categoryData.offerTypes and #categoryData.offerTypes > 0 then
		for tabId = 1, #categoryData.offerTypes do
			offerCount = offerCount + #categoryData.offerTypes[tabId].offers
			offerTypeCount = offerTypeCount + 1
		end
	end
	
	StoreCategories[index].offerCount = offerCount
	StoreCategories[index].offerTypeCount = offerTypeCount
end

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
			self:addByte(0) -- reasonCount?
			--self:addString('Failed to load the offer!')
		self:addByte(0) -- offerStatus
	self:addByte(3) -- offerType
		self:addU16(3547)
	self:addByte(0) -- TryOn Type
	self:addString("") -- parent name (menu or dropdown menu)
	self:addU16(0) -- Popularity Score
	self:addU32(0) -- Published at
	self:addByte(0) -- 0 - buy, 1 - configure
	self:addU16(0) -- "this package contains" list
		-- package list member
		--self:addString("Unable to load the offer!")
		--self:addByte(STORE_OFFER_TYPE_ITEM)
		--	self:addU16(3547)
end

function NetworkMessage:addStoreOffer(offerId, parentName)
-- keep the tabbing for self-documenting packet structure
	-- string offerName
	-- u8 priceTagsCount
		-- price tag:
			-- u32 offerId
			-- u16 amount
			-- u32 price
			-- u8 currency
			-- u8 isDisabled
				-- u8 reasons count
					-- reason:
					-- string reason
			-- u8 offerStatus
				-- 0: normal
				-- 1: new
				-- 2: sale
					-- u32: expires at?
					-- u32: previous price
				-- 3: blue + hourglass
				-- 4: client crash
	-- u8 offerType
		-- type 0 (special):
			-- string image link
			-- u8 unknown

			-- string parent
			-- u8 unknown 2
			-- u8 unknown 3
			-- u32 published at
			-- u8 unknown 4
			-- ??
		-- type 1 (mount):
			-- u16 lookType
		-- type 2 (outfit with all addons):
			-- u16 lookType
			-- 4x u8 colors
		-- type 3 (item)
			-- u16 clientId
		-- type 4 (hireling)
			-- u8 gender (1, 2 only)
			-- u16 lookMale
			-- u16 lookFemale
			-- 4x u8 colors
		-- type 5 and above:
			-- client crashes
	-- u8 enum try on (0 - no button, 1 and 2 - try on mode)
	-- string tabName
	-- u32 published at
	-- u8 0 - buy, 1 - configure
	
	-- u16 product list count
		-- product:
		-- string name
		-- u8 offerType
			-- offerType data

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
			
			if packInfo.disbaledReasons and #packInfo.disbaledReasons > 0 then
				self:addByte(1)
				self:addByte(0)
				--[[
				self:addByte(#packInfo.disabledReasons)
				for i = 1, #packInfo.disabledReasons do
					self:addString(disbaledReasons[i])
				end
				]]
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
		self:addU16(offer.lookType)
		self:addU16(offer.lookHead)
		self:addU16(offer.lookBody)
		self:addU16(offer.lookLegs)
		self:addU16(offer.lookFeet)
		tryOnType = 2
	elseif offerType == STORE_OFFER_TYPE_ITEM then
		self:addU16(ItemType(offer.itemId or 100):getClientId())
	else --if offerType == STORE_OFFER_TYPE_HIRELING then
		self:addByte(1) -- gender - 1 or 2
		self:addU16(offer.lookTypeFemale)
		self:addU16(offer.lookTypeMale)
		self:addU16(offer.lookHead)
		self:addU16(offer.lookBody)
		self:addU16(offer.lookLegs)
		self:addU16(offer.lookFeet)
	end

	self:addByte(tryOnType) -- TryOn Type
	self:addString(parentName) -- parent name (menu or dropdown menu)
	self:addU16(offer.popularity) -- Popularity Score
	self:addU32(offer.publishedAt) -- Published at
	self:addByte(offer.configurable) -- 0 - buy, 1 - configure
	self:addU16(0) -- "this package contains" list
		-- package list member
		--self:addString("Unable to load the offer!")
		--self:addByte(STORE_OFFER_TYPE_ITEM)
		--	self:addU16(3547)
--[[
		-- package list member
		self:addString("5x Kekando")
		self:addByte(STORE_OFFER_TYPE_DEFAULT)
			self:addU16(offer.fileName)
]]
end

function Player:sendStoreUI(actionType, tabName)
	local isHomePage = false
	local tabInfo = categoryToIdMap[tabName] and StoreCategories[categoryToIdMap[tabName] ]
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

	-- ?
	msg:addU16(0)
	
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
					msg:addStoreOffer(tabInfo.offers[i], tabInfo.name)
					descriptionsToSend[#descriptionsToSend + 1] = tabInfo.offers[i]
				end
			end
			
			if tabInfo.offerTypes and #tabInfo.offerTypes > 0 then
				for dropDownId = 1, #tabInfo.offerTypes do
					local currentTab = tabInfo.offerTypes[dropDownId]
					if currentTab.offers and #currentTab.offers > 0 then
						for offerIndex = 1, #currentTab.offers do
							local currentOfferId = currentTab.offers[offerIndex]
							msg:addStoreOffer(currentOfferId, currentTab.name)
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
		--[[
			print("----")
			for k, v in pairs(request) do
				print(k, v)
			end
		]]
		player:sendStoreUI(request.actionType, request.primaryText)
	end
	ec:register()
end
