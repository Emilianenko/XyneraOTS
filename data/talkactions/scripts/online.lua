local maxPlayersPerMessage = 20
local highlightAdmin = true
local highlightAdminPlayer = false
local highlightTutor = true

function sendOnlinePage(cid, msg)
	local player = Player(cid)
	if player then
		player:sendTextMessage(MESSAGE_LOOT, msg)
	end
end

function onSay(player, words, param)
	if not player:talkactionCooldownCheck() then
		return
	end
	
	local players = Game.getPlayers()
	local onlineList = {}
	local playersAfk = 0
	local legendAfk = false
	local legendTutor = false
	local legendAdmin = false
	
	for _, targetPlayer in ipairs(players) do
		if player:canSeeCreature(targetPlayer) then
			local entry = string.format("%s [%d]", targetPlayer:getName(), targetPlayer:getLevel())
			local accType = targetPlayer:getAccountType()
			local hasAccess = targetPlayer:getGroup():getAccess()
			local color = MESSAGE_COLOR_WHITE
			if targetPlayer:isAdmin() then
				if (hasAccess and highlightAdmin) or (not hasAccess and highlightAdminPlayer) then
					color = MESSAGE_COLOR_BLUE
					legendAdmin = true
				end
			elseif highlightTutor and accType >= ACCOUNT_TYPE_TUTOR and accType <= ACCOUNT_TYPE_SENIORTUTOR then
				color = MESSAGE_COLOR_YELLOW
				legendTutor = true
			elseif targetPlayer:isAfk() then
				color = MESSAGE_COLOR_PURPLE
				playersAfk = playersAfk + 1
				legendAfk = true
			end
			
			if color ~= MESSAGE_COLOR_WHITE then
				entry = string.format("{%d|%s}", color, entry)
			end
			
			table.insert(onlineList, entry)
		end
	end
	
	local playersOnline = #onlineList
	local pagesCount = math.ceil(playersOnline / maxPlayersPerMessage)
	local pageId = 1
	local cid = player:getId()
	local legend = ""
	
	-- show legend only when at least one uncommon online type is online
	if legendAfk or legendTutor or legendAdmin then
		legend = "\n\n[Online"
		if legendAfk then
			legend = string.format("%s, {%d|Training}", legend, MESSAGE_COLOR_PURPLE)
		end
		
		if legendTutor then
			legend = string.format("%s, {%d|Tutor}", legend, MESSAGE_COLOR_YELLOW)	
		end
		
		if legendAdmin then
			legend = string.format("%s, {%d|Staff}", legend, MESSAGE_COLOR_BLUE)	
		end
		
		legend = legend .. "]"
	end
	
	local onlineCountStr = playersOnline
	if playersAfk > 0 then
		onlineCountStr = string.format("%d (%d active {%d|%+d afk})", playersOnline, playersOnline - playersAfk, MESSAGE_COLOR_PURPLE, playersAfk)
	end
	
	for i = 1, playersOnline, maxPlayersPerMessage do
		local j = math.min(i + maxPlayersPerMessage - 1, playersOnline)
		local msg = table.concat(onlineList, ", ", i, j)
		local page = pagesCount > 1 and string.format(" [page %d/%d]", pageId, math.max(1, pagesCount)) or ""
		msg = string.format("Player%s online: %s%s:\n%s%s", playersOnline ~= 1 and "s" or "", onlineCountStr, page, msg, legend)

		if pageId ~= 1 then
			addEvent(sendOnlinePage, 3000 * pageId, player:getId(), msg)
		else
			sendOnlinePage(cid, msg)
		end
		
		pageId = pageId + 1
	end
	return false
end
