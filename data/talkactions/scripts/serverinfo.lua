local infoUpdateInterval = 5 * 60
local serverInfoCache = {
	stages = {},
	skill = 1,
	magic = 1,
	loot = 1,
	spawn = 1,
	expiresAt = -1
}

local spaceSmall = string.char(2)
local function showAsColumns(left, right, width)
	local separator = string.rep(spaceSmall, width - left:len() - right:len())
	return string.format("%s%s%s", left, separator, right)
end

function onSay(player, words, param)
	local now = os.time()
	if now > serverInfoCache.expiresAt or player:isAdmin() then
		for stageId, stage in pairs(Game.getExperienceStages()) do
			local stageValue = string.format("x%d", stage.multiplier)
			if stage.maxlevel ~= 0 then
				serverInfoCache.stages[stageId] = showAsColumns(string.format("[%d%s-%s%d]:", stage.minlevel, spaceSmall, spaceSmall, stage.maxlevel), stageValue, 15)
			else
				serverInfoCache.stages[stageId] = showAsColumns(string.format("[%d+]:", stage.minlevel), stageValue, 15)
			end
		end
		
		serverInfoCache.skill = showAsColumns("Skill:", string.format("x%d", configManager.getNumber(configKeys.RATE_SKILL)), 17)
		serverInfoCache.magic = showAsColumns("Magic:", string.format("x%d", configManager.getNumber(configKeys.RATE_MAGIC)), 16)
		serverInfoCache.loot = showAsColumns("Loot:", string.format("x%d", configManager.getNumber(configKeys.RATE_LOOT)), 16)
		serverInfoCache.spawn = showAsColumns("Spawn:", string.format("x%d", configManager.getNumber(configKeys.RATE_SPAWN)), 15)
		serverInfoCache.expiresAt = now + infoUpdateInterval
	end

	local serverInfo = ""
	if #serverInfoCache.stages > 0 then
		serverInfo = string.format(
			"Server Info:\n%s\n%s\n%s\n%s\n%s\n\n\nStages:\n%s",
			showAsColumns("Exp (stage):", string.format("x%d", Game.getExperienceStage(player:getLevel())), 15),
			serverInfoCache.skill,
			serverInfoCache.magic,
			serverInfoCache.loot,
			serverInfoCache.spawn,
			table.concat(serverInfoCache.stages, "\n")
		)
	else
		serverInfo = string.format(
			"Server Info:\n%s\n%s\n%s\n%s\n%s",
			showAsColumns("Exp:", string.format("x%d", Game.getExperienceStage(player:getLevel())), 16),
			serverInfoCache.skill,
			serverInfoCache.magic,
			serverInfoCache.loot,
			serverInfoCache.spawn
		)
	end
	
	player:sendColorMessage(serverInfo, MESSAGE_COLOR_YELLOW)
	return false
end
