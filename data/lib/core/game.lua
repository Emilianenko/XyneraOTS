function Game.broadcastMessage(message, messageType)
	if not messageType then
		messageType = MESSAGE_STATUS_WARNING
	end

	Game.sendConsoleMessage(CONSOLEMESSAGE_TYPE_BROADCAST, os.date("%H:%M") .. " " .. message)

	for _, player in ipairs(Game.getPlayers()) do
		player:sendTextMessage(messageType, message)
	end
end

function Game.convertIpToString(ip)
	local band = bit.band
	local rshift = bit.rshift
	return string.format("%d.%d.%d.%d",
		band(ip, 0xFF),
		band(rshift(ip, 8), 0xFF),
		band(rshift(ip, 16), 0xFF),
		rshift(ip, 24)
	)
end

function Game.getReverseDirection(direction)
	if direction == WEST then
		return EAST
	elseif direction == EAST then
		return WEST
	elseif direction == NORTH then
		return SOUTH
	elseif direction == SOUTH then
		return NORTH
	elseif direction == NORTHWEST then
		return SOUTHEAST
	elseif direction == NORTHEAST then
		return SOUTHWEST
	elseif direction == SOUTHWEST then
		return NORTHEAST
	elseif direction == SOUTHEAST then
		return NORTHWEST
	end
	return NORTH
end

function Game.getSkillType(weaponType)
	if weaponType == WEAPON_CLUB then
		return SKILL_CLUB
	elseif weaponType == WEAPON_SWORD then
		return SKILL_SWORD
	elseif weaponType == WEAPON_AXE then
		return SKILL_AXE
	elseif weaponType == WEAPON_DISTANCE then
		return SKILL_DISTANCE
	elseif weaponType == WEAPON_SHIELD then
		return SKILL_SHIELD
	end
	return SKILL_FIST
end

if not globalStorageTable then
	globalStorageTable = {}
end

function Game.getStorageValue(key)
	return globalStorageTable[key]
end

function Game.setStorageValue(key, value)
	globalStorageTable[key] = value
end

do
	local cdShort = {"d", "h", "m", "s"}
	local cdLong = {" day", " hour", " minute", " second"}
	local function getTimeUnitGrammar(amount, unitID, isLong)
		return isLong and string.format("%s%s", cdLong[unitID], amount ~= 1 and "s" or "") or cdShort[unitID]
	end

	function Game.getCountdownString(duration, longVersion, hideZero)
		if duration < 0 then
			return "expired"
		end
		
		local days = math.floor(duration/86400)
		local hours = math.floor((duration % 86400)/3600)
		local minutes = math.floor((duration % 3600)/60)
		local seconds = math.floor(duration % 60)
		
		local response = {}
		if hideZero then
			if days > 0 then
				response[#response+1] = days .. getTimeUnitGrammar(days, 1, longVersion)
			end

			if hours > 0 then
				response[#response+1] = hours .. getTimeUnitGrammar(hours, 2, longVersion)
			end
			
			if minutes > 0 then
				response[#response+1] = minutes .. getTimeUnitGrammar(minutes, 3, longVersion)
			end
			
			if seconds > 0 then
				response[#response+1] = seconds .. getTimeUnitGrammar(seconds, 4, longVersion)
			end
		else
			if days > 0 then
				response[#response+1] = days .. getTimeUnitGrammar(days, 1, longVersion)
				response[#response+1] = hours .. getTimeUnitGrammar(hours, 2, longVersion)
				response[#response+1] = minutes .. getTimeUnitGrammar(minutes, 3, longVersion)
				response[#response+1] = seconds .. getTimeUnitGrammar(seconds, 4, longVersion)
			elseif hours > 0 then
				response[#response+1] = hours .. getTimeUnitGrammar(hours, 2, longVersion)
				response[#response+1] = minutes .. getTimeUnitGrammar(minutes, 3, longVersion)
				response[#response+1] = seconds .. getTimeUnitGrammar(seconds, 4, longVersion)
			elseif minutes > 0 then
				response[#response+1] = minutes .. getTimeUnitGrammar(minutes, 3, longVersion)
				response[#response+1] = seconds .. getTimeUnitGrammar(seconds, 4, longVersion)
			elseif seconds >= 0 then
				response[#response+1] = seconds .. getTimeUnitGrammar(seconds, 4, longVersion)
			end
		end
		
		return table.concat(response, " ")
	end
end

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

function Game.verifyName(origName)
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
