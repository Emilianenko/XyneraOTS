---- CONSTANTS
CONDITION_SUBID_HEXED = 600


---- LOCALS
local hex = {
	-- lesser
	[1] = {icon = ICON_LESSERHEX, healingPercent = 50},
	
	-- intense
	[2] = {icon = ICON_INTENSEHEX, healingPercent = 50, damagePercent = 50},
	
	-- greater
	[3] = {icon = ICON_GREATERHEX, healingPercent = 50, damagePercent = 50, HPPercent = 40}
}

local iconToLevel = {
	[ICON_LESSERHEX] = 1,
	[ICON_INTENSEHEX] = 2,
	[ICON_GREATERHEX] = 3,
}


---- FUNCTIONS

-- note: hex descriptions are hardcoded in client
-- - lesser = less healing
-- - intense = less healing + less damage
-- - greater = less healing + less damage + reduced max hp
-- note2: duration -1 = permanent until change/logout/death
function Creature:setHex(hexLevel, duration)
	self:removeCondition(CONDITION_ATTRIBUTES, CONDITIONID_COMBAT, CONDITION_SUBID_HEXED)

	if hexLevel < 1 then
		return true
	elseif hexLevel > 3 then
		return false
	end
	
	local condition = Condition(CONDITION_ATTRIBUTES)
	condition:setParameter(CONDITION_PARAM_SUBID, CONDITION_SUBID_HEXED)
	condition:setParameter(CONDITION_PARAM_TICKS, duration)
	condition:setParameter(CONDITION_PARAM_ICONS, hex[hexLevel].icon)
	
	if hex[hexLevel].HPPercent then
		condition:setParameter(CONDITION_PARAM_STAT_MAXHITPOINTSPERCENT, hex[hexLevel].HPPercent)
	end
	
	self:addCondition(condition)	
	return true
end

function Creature:getHexLevel()
	local cond = self:getCondition(CONDITION_ATTRIBUTES, CONDITIONID_COMBAT, CONDITION_SUBID_HEXED)
	if not cond then
		return 0
	end
	
	return iconToLevel[cond:getIcons()] or 0
end


---- SCRIPTS FOR HEX EFFECTS

-- healing/damage debuff
do
	local creatureevent = CreatureEvent("HexStatus")
	function creatureevent.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
		-- healing received debuff
		local targetHex = creature:getHexLevel()
		if targetHex > 0 then
			local hexInfo = hex[targetHex]
			if not hexInfo then
				return primaryDamage, primaryType, secondaryDamage, secondaryType
			end
			
			local healMod = hexInfo.healingPercent
			if primaryType == COMBAT_HEALING and healMod then
				primaryDamage = primaryDamage * healMod / 100
			end

			if secondaryType == COMBAT_HEALING and healMod then
				secondaryDamage = secondaryDamage * healMod / 100
			end
		end

		-- damage output debuff
		if attacker then
			local attackerHex = attacker:getHexLevel()
			if attackerHex > 0 then
				local hexInfo = hex[attackerHex]
				if not hexInfo then
					return primaryDamage, primaryType, secondaryDamage, secondaryType
				end
				
				local damageMod = hexInfo.damagePercent
				if primaryType ~= COMBAT_HEALING and damageMod then
					primaryDamage = primaryDamage * damageMod / 100
				end

				if secondaryType ~= COMBAT_HEALING and damageMod then
					secondaryDamage = secondaryDamage * damageMod / 100
				end
			end
		end
		
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end
	creatureevent:register()
end

-- registering the healing and damage debuffs
do
	local creatureevent = CreatureEvent("HexDebuffLogin")
	function creatureevent.onLogin(player)
		player:registerEvent("HexStatus")
		return true
	end
	creatureevent:register()
	
	local ec = EventCallback
	ec.onSpawn = function(self, position, startup, artificial)
		self:registerEvent("HexStatus")
		return true
	end
	ec:register()
end
