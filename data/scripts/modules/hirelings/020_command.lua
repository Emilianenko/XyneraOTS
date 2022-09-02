local talk = TalkAction("!hirelings")
function talk.onSay(player, words, param)
	local guid = player:getGuid()
	local cache = HirelingsPlacedCache[guid]
	local hirelingsCount = cache and #cache or 0
	local response = string.format("Placed Hirelings: %s", hirelingsCount)
	if hirelingsCount > 0 then
		for i = 1, hirelingsCount do
			local npc = Npc(cache[i])
			if npc then
				local outfitId = getHirelingOutfitIdByLookType(npc:getOutfit().lookType)
				local outfitName = outfitId and HirelingOutfits[outfitId].name or "Other"
				response = string.format("%s\n - %s (%s, %s)", response, npc:getName(), outfitName, sexToString(npc:getSex()))
			else
				response = string.format("%s\n - missing data", response, cache[i])
			end
		end
	end
	
	response = string.format("%s\n\nOutfits Usage:", response)	
	for outfitId = 1, table.maxn(HirelingOutfits) do
		local hirelingData = HirelingOutfits[outfitId]
		if hirelingData then
			local outfitsInUse = HirelingsUsageCache[guid] and HirelingsUsageCache[guid][outfitId] or 0
			local totalAvailable = outfitId > 1 and player:getStorageValue(HIRELING_UNLOCK_BASE_STORAGE + outfitId) or -100
			if totalAvailable > -1 or totalAvailable == -100 then
				if outfitId ~= 1 then
					if totalAvailable > 0 then
						response = string.format("%s\n - %s (%d/%d)", response, HirelingOutfits[outfitId].name, outfitsInUse, totalAvailable)
					end
				else
					response = string.format("%s\n - %s (%d/-)", response, HirelingOutfits[outfitId].name, outfitsInUse)
				end
			end
		end
	end

	player:popupFYI(response)
	return false
end

talk:register()
