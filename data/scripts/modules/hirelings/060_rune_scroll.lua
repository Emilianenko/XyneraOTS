-- change name scroll
-- change sex rune
local hirelingItem = Action()
function hirelingItem.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local itemId = item:getId()
	if itemId == ITEM_HIRELING_RUNE then
		-- hireling sex change
		if target and target:isCreature() then
			if target:isNpc() and target:getOwnerGUID() == player:getGuid() or player:getId() == target:getId() or player:isAdmin() then
				if target:changeSex() then
					target:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
					if not player:isAdmin() then
						item:remove(1)
					else
						player:sendTextMessage(MESSAGE_INFO_DESCR, "Administrator mode: rune not consumed.")
					end
				else
					player:sendCancelMessage("This creature cannot be altered.")
					player:getPosition():sendMagicEffect(CONST_ME_POFF, player)
				end
			elseif target:isNpc() and target:getSpeechBubble(SPEECHBUBBLE_HIRELING) then
				player:sendCancelMessage("You do not own this hireling.")
				player:getPosition():sendMagicEffect(CONST_ME_POFF, player)
			else
				return false
			end
			
			return true
		end
	elseif itemId == ITEM_HIRELING_SCROLL then
		-- hireling name change
		-- (item consumption in event)
		if target and target:isCreature() then
			local msg = NetworkMessage()
			msg:addByte(0xDB)
			msg:addU32(0) -- unknown
			msg:addU32(target:getId())
			msg:sendToPlayer(player)
			return true
		end
	end
	
	return false
end

hirelingItem:id(ITEM_HIRELING_SCROLL)
hirelingItem:id(ITEM_HIRELING_RUNE)
hirelingItem:allowFarUse(true)
hirelingItem:blockWalls(false)
hirelingItem:register()

local illegalPatterns = {
	-- double characters
	"''", "  ", "%-%-",

	-- combined characters
	"%-'", "'%-",

	-- triple letters
	"aaa", "bbb", "ccc", "ddd", "eee", "fff", "ggg", "hhh",
	"iii", "jjj", "kkk", "lll", "mmm", "nnn", "ooo", "ppp",
	"qqq", "rrr", "sss", "ttt", "uuu", "vvv", "www", "xxx",
	"yyy", "zzz",

	-- imposting staff
	"gm ", "god ", "adm ", "admin", "administrator", "administrador", "staff ",
	
	-- sentences
	"you ", " are ", "are you", "you are", "you're", "do not", "don't", "cya ", " cya"
}

-- remove spaces and special chars before checking
local illegalWords = {
	-- list of blocked words
	
	-- imposting server administration
	"owner", "gamemaster", "hoster", "account", "server", "serwer", "servidor",
	
	-- politically incorrect
	"hitler", "stalin", "mussolini", "zedong", "queenelizabeth", "popefrancis", "trump", "xiyingping", "putin", "zelensky", "andrzejduda",
	"holocaust", "holodomor", "terror", "genocide", "andrzejdupa",
	
	-- other
	"nigg", "fag", "fuck",
}

local function verifyName(origName)
	-- turn lowercase for matching bad words
	local name = origName:lower()
	
	-- small letter at front
	if origName:sub(1, 1):match("%l") then
		return "The first name should start with a capital letter."
	end
		
	-- name length
	local length = origName:len()
	if length < 4 then
		return "Name too short."	
	elseif length > 21 then
		return "Name too long."
	end
	
	-- 4+ words in names
	local words = name:split(" ")
	if #words > 3 then
		return "Name contains too many words."
	end
	
	-- numbers and special chars
	if not name:match("^[a-zA-Z' %-]+$") then
		return "Name contains invalid pattern."
	end
	
	-- rat, demon, orc, etc.
	if Monster(name) then
		return "Name contains reserved words."
	end
	
	-- words verification
	for _, word in pairs(words) do
		-- n l t
		if word:len() == 1 then
			return "Name contains invalid pattern."
		end
		
		-- nms lk ths
		if not (word:match("[aeiouy]")) then
			return "Name contains words without vowels."
		end
		
		-- -names' -like- 'this'
		if word:sub(1, 1):match("[%-']") or word:sub(-1, -1):match("[%-']") then
			return "Name contains invalid pattern."
		end
		
		-- nAmEs lIkE tHiS
		if word:sub(2, -1):match("%u") then
			return "Name contains invalid pattern."
		end
	end
	
	-- names with matched illegalPatterns
	for _, p in pairs(illegalPatterns) do
		if name:find(p) then
			return "Name contains invalid pattern."
		end
	end
	
	-- names with illegal words
	-- special characters and spaces cut for better matching
	name = name:gsub("'", ""):gsub(" ", ""):gsub("-", "")
	for _, p in pairs(illegalWords) do
		if name:find(p) then
			return "Name contains reserved words."
		end
	end
	
	return false
end

-- rename
local ec = EventCallback
function ec.onEditName(player, target, name)
	if not target then
		return
	end

	-- rename anyone (admin mode)
	if player:isAdmin() then
		-- prevent duplicate player names
		if target:isPlayer() then
			if Game.playerExists(name) then
				player:sendTextMessage(MESSAGE_INFO_DESCR, string.format("Name \"%s\" is already in use!", name))
				return
			end
		end

		-- rename
		target:rename(name)
		target:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
		
		-- name verification (check only)
		local nameError = verifyName(name)
		if nameError then
			nameError = string.format("\nWarning: Potentially illegal name.\nReason: %s", nameError)
		end
		nameError = nameError or ""
		
		player:sendTextMessage(MESSAGE_INFO_DESCR, string.format("Administrator mode: Creature renamed successfully.%s", nameError))
		return
	end

	-- spoofed packet or lost the rename scroll before confirming new name
	if player:getItemCount(ITEM_HIRELING_SCROLL) == 0 then
		return
	end
	
	-- rename self
	if player:getId() == target:getId() then
		-- name verification
		local nameError = verifyName(name)
		if nameError then
			player:sendTextMessage(MESSAGE_INFO_DESCR, string.format("This name may not be used.\nReason: %s", nameError))
			return
		end

		-- prevent duplicate name
		if Game.playerExists(name) then
			player:sendTextMessage(MESSAGE_INFO_DESCR, string.format("Name \"%s\" is already in use!", name))
			return
		end
		
		if player:removeItem(ITEM_HIRELING_SCROLL, 1) then
			target:rename(name)
			player:sendTextMessage(MESSAGE_STATUS_WARNING, "Warning: Due to name change, you may need to restart your client in order to be able to log in again!")
			target:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
		else
			player:sendTextMessage(MESSAGE_INFO_DESCR, "Error: unable to consume hireling scroll.")
		end
		
		return
	end
	
	-- spoofed packet or lost admin permissions while editing
	local npc = Npc(target:getId())
	if not npc then
		return
	end
	
	-- hireling check
	if npc:getSpeechBubble() ~= SPEECHBUBBLE_HIRELING then
		return
	end
	
	-- owner verification
	if npc:getOwnerGUID() ~= player:getGuid() then
		player:sendCancelMessage("You do not own this hireling.")
		return
	end
	
	-- name verification
	local nameError = verifyName(name)
	if nameError then
		player:sendTextMessage(MESSAGE_INFO_DESCR, string.format("This name may not be used.\nReason: %s", nameError))
		return
	end

	-- rename
	if player:removeItem(ITEM_HIRELING_SCROLL, 1) then
		local oldName = target:getName()
		target:rename(name)
		target:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
		player:sendTextMessage(MESSAGE_INFO_DESCR, string.format("%s successfully renamed to \"%s\".", oldName, name))
		return
	end
	
	player:sendTextMessage(MESSAGE_INFO_DESCR, "Error: unable to consume hireling scroll.")
end
ec:register()
