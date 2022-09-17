local function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

if Game.isDevMode() then
	DEPLOY_LINE_COUNT_CMAKE = 0
	DEPLOY_LINE_COUNT_BUILD = 0
end

local cmakelog = "log_cmake.txt"
local buildlog = "build/log_build.txt"

function checkDeploy()
	if file_exists(cmakelog) then
		local lineId = 1
		for line in io.lines(cmakelog) do
			if lineId > DEPLOY_LINE_COUNT_CMAKE then
				sendChannelMessage(CHANNEL_CONSOLE, TALKTYPE_CHANNEL_O, line)
				DEPLOY_LINE_COUNT_CMAKE = lineId
			end
			lineId = lineId + 1
		end
	end
	
	if file_exists(buildlog) then
		local lineId = 1
		for line in io.lines(buildlog) do
			if lineId > DEPLOY_LINE_COUNT_BUILD then
				sendChannelMessage(CHANNEL_CONSOLE, TALKTYPE_CHANNEL_O, line)
				DEPLOY_LINE_COUNT_BUILD = lineId
			end
			lineId = lineId + 1
		end
	end
	
	addEvent(checkDeploy, 1000)
end

local t = TalkAction("/deploy")
t.onSay = function(player, words, param)
	if player:getAccountType() < ACCOUNT_TYPE_GOD then
		return true
	end
	
	if IS_COMPILING then
		player:sendColorMessage("Compilation already started. Please wait for server restart.", MESSAGE_COLOR_PURPLE)
		return false
	end
	
	if Game.isWindows() then
		player:sendColorMessage("Command not supported on Windows.", MESSAGE_COLOR_PURPLE)
		return false
	end

	if not Game.isDevMode() then
		player:sendColorMessage("Access denied. Dev mode required.", MESSAGE_COLOR_PURPLE)
		return false
	end
	
	IS_COMPILING = true
	Game.broadcastMessage("A new server version will be deployed soon. Please log out.", MESSAGE_STATUS_WARNING)
	player:openChannel(CHANNEL_CONSOLE)
	addEvent(checkDeploy, 1000)
	os.execute("./deploy.sh &")
	
	return false
end
t:register()
