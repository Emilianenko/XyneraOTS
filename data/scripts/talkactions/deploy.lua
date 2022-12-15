---- automatic compilation on detecting a new version
AUTODEPLOY = true
AUTODEPLOY_INTERVAL = 60 * 60 * 1000 -- 1h

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
				Game.appendConsoleHistory(CONSOLEMESSAGE_TYPE_RESPONSE, line, false)
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
				Game.appendConsoleHistory(CONSOLEMESSAGE_TYPE_RESPONSE, line, false)
				DEPLOY_LINE_COUNT_BUILD = lineId
			end
			lineId = lineId + 1
		end
	end
	
	addEvent(checkDeploy, 1000)
end

function ExecuteDeploy()
	if IS_COMPILING then
		return
	end

	IS_COMPILING = true
	Game.broadcastMessage("A new server version will be deployed soon. Please log out.", MESSAGE_STATUS_WARNING)
	addEvent(checkDeploy, 1000)
	os.execute("./deploy.sh &")
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
	
	ExecuteDeploy()
	return false
end
t:register()

---- autodeploy code
if AUTODEPLOY then
	function deployChecker()
		if AUTODEPLOY then
			local handle = io.popen("git rev-parse HEAD")
			local newRev = handle:read("*a")
			handle:close()
			
			if AUTODEPLOY_GIT_REV ~= newRev then
				ExecuteDeploy()
				return
			end
			
			addEvent(deployChecker, AUTODEPLOY_INTERVAL)
		end
	end

	local function deployStarter()
		if IS_COMPILING then
			Game.sendConsoleMessage(CONSOLEMESSAGE_TYPE_ERROR, "AUTODEPLOY: Compilation already started!")
			return
		end
		
		if Game.isWindows() then
			-- this will be annoying locally, lets just not
			-- Game.sendConsoleMessage(CONSOLEMESSAGE_TYPE_WARNING, "AUTODEPLOY: Feature not available in Windows operating systems.")
			return
		end
		
		if not Game.isDevMode() then
			Game.sendConsoleMessage(CONSOLEMESSAGE_TYPE_WARNING, "AUTODEPLOY: Dev mode is disabled, feature unavailable.")
			return
		end
		
		if not AUTODEPLOY_INIT then
			local handle = io.popen("git rev-parse HEAD")
			AUTODEPLOY_GIT_REV = handle:read("*a")
			handle:close()
			addEvent(deployChecker, AUTODEPLOY_INTERVAL)
			AUTODEPLOY_INIT = true
		end
	end
	
	deployStarter()
end
