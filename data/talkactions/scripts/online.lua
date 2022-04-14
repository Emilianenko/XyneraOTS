local maxPlayersPerMessage = 20
local highlightAdmin = true
local highlightAdminPlayer = false
local highlightTutor = true

function onSay(player, words, param)
	local players = Game.getPlayers()
	local onlineList = {}

	for _, targetPlayer in ipairs(players) do
		if player:canSeeCreature(targetPlayer) then
			local entry = string.format("%s [%d]", targetPlayer:getName(), targetPlayer:getLevel())
			local accType = targetPlayer:getAccountType()
			local hasAccess = targetPlayer:getGroup():getAccess()
			local color = MESSAGE_COLOR_WHITE
			if targetPlayer:isAdmin() then
				if (highlightAdmin and hasAccess) or (highlightAdminPlayer and targetPlayer:isAdmin()) then
					color = MESSAGE_COLOR_BLUE
				end
			elseif highlightTutor and accType >= ACCOUNT_TYPE_TUTOR and accType <= ACCOUNT_TYPE_SENIORTUTOR then
				color = MESSAGE_COLOR_YELLOW
			elseif highlightAdmin and hasAccess and accType > ACCOUNT_TYPE_SENIORTUTOR and accType < ACCOUNT_TYPE_GOD then
				color = MESSAGE_COLOR_GREEN
			end
			
			entry = string.format("{%d|%s}", color, entry)
			
			table.insert(onlineList, entry)
		end
	end
	
	local playersOnline = #onlineList
	local pagesCount = math.ceil(playersOnline / maxPlayersPerMessage)
	local pageId = 1
	for i = 1, playersOnline, maxPlayersPerMessage do
		local j = math.min(i + maxPlayersPerMessage - 1, playersOnline)
		local msg = table.concat(onlineList, ", ", i, j)
		local page = pagesCount > 1 and string.format(" (page %d/%d)", pageId, math.max(1, pagesCount)) or ""
		player:sendTextMessage(MESSAGE_LOOT, string.format("%d player%s online%s:\n%s", playersOnline, playersOnline ~= 1 and "s" or "", page, msg))
		pageId = pageId + 1
	end
	return false
end
