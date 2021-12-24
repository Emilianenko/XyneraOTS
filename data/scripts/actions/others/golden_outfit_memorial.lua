-- update cache only if last request was x seconds ago
local updateInterval = 10 * 60 -- 10 minutes

-- load/update cached info
-- NOT CONFIGURABLE
local goldenOutfitCache = {[1] = {}, [2] = {}, [3] = {}}
local lastUpdated = 0
local function updateGoldenOutfitCache()
	if os.time() < lastUpdated + updateInterval then
		return
	end
	
	local resultId = db.storeQuery("SELECT `name`, `value` FROM `player_storage` INNER JOIN `players` as `p` ON `p`.`id` = `player_id` WHERE `key` = " .. PlayerStorageKeys.goldenOutfit .. " AND `value` >= 1;")
	if not resultId then
		result.free(resultId)
		return
	end

	repeat
		local addons = result.getNumber(resultId, "value")
		local name = result.getString(resultId, "name")
		table.insert(goldenOutfitCache[addons], "- " .. name)
	until not result.next(resultId)
	result.free(resultId)
	
	lastUpdated = os.time()
end

local goldenOutfitMemorial = Action()
function goldenOutfitMemorial.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	updateGoldenOutfitCache()

	if #goldenOutfitCache[1] == 0 and #goldenOutfitCache[2] == 0 and #goldenOutfitCache[3] == 0 then
		player:showTextDialog(item.itemid, "The Golden Outfit has not been acquired by anyone yet.")
		return true
	end	

	local message = "The following characters have spent a fortune on a Golden Outfit:\n"
	if #goldenOutfitCache[3] > 0 then
		message = message .. string.format("\nFull Outfit for 1,000,000,000 gold:\n%s", table.concat(goldenOutfitCache[3], "\n"))
	end

	if #goldenOutfitCache[2] > 0 then
		message = message .. string.format("\n\nWith One Addon for 750,000,000 gold:\n%s", table.concat(goldenOutfitCache[2], "\n"))
	end

	if #goldenOutfitCache[1] > 0 then
		message = message .. string.format("\n\nBasic Outfit for 500,000,000 gold:\n%s", table.concat(goldenOutfitCache[1], "\n"))
	end

	player:showTextDialog(item.itemid, message)
	return true
end

goldenOutfitMemorial:id(34174, 34175, 34176, 34177, 34178, 34179)
goldenOutfitMemorial:register()