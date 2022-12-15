-- autogenerate helpers for store indexing
CategoryToIdMap = {}
for index, categoryData in pairs(StoreCategories) do
	-- index category
	CategoryToIdMap[categoryData.name] = index
	
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
