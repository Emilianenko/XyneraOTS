---- CONFIG
local level = 200
local familiarDuration = 15 * 60 -- in seconds
local cooldown = 30 * 60 * 1000 -- in milliseconds
CheckFamiliarsInterval = 60 * 1000

local summonSpells = {
	{pet = "sorcerer familiar", name = "Summon Sorcerer Familiar", words = "utevo gran res ven", icon = 196, mana = 3000, vocation = {1, 5}},
	{pet = "druid familiar", name = "Summon Druid Familiar", words = "utevo gran res dru", icon = 197, mana = 3000, vocation = {2, 6}},
	{pet = "paladin familiar", name = "Summon Paladin Familiar", words = "utevo gran res sac", icon = 195, mana = 2000, vocation = {3, 7}},
	{pet = "knight familiar", name = "Summon Knight Familiar", words = "utevo gran res eq", icon = 194, mana = 1000, vocation = {4, 8}},
}

---- DISPATCHER
-- reload-safe
if not PlayerFamiliars then
	PlayerFamiliars = {}
	
	function CheckFamiliars()
		for familiarIndex, familiarExpires in pairs(PlayerFamiliars) do
			local familiar = Creature(familiarIndex)
			if familiar then
				local master = familiar:getMaster()
				if master then
					if os.time() > familiarExpires then
						familiar:remove()
						PlayerFamiliars[familiarIndex] = nil
					end
				else
					familiar:remove()
					PlayerFamiliars[familiarIndex] = nil
				end
			else
				PlayerFamiliars[familiarIndex] = nil
			end
		end
		
		addEvent(CheckFamiliars, CheckFamiliarsInterval)
	end
	
	CheckFamiliars()
end

---- SPELL
-- place function
local function placeFamiliar(player, petName)
	-- check if player can use currently selected familiar skin
	local lookType = -1
	local familiarId = player:getCurrentFamiliar()
	
	if player:canUseFamiliar(familiarId) then
		local familiar = Game.getFamiliarById(familiarId)
		if familiar then
			lookType = familiar.clientId
		end
	end
	
	local playerPos = player:getPosition()
	local summon = Game.createMonster(petName, playerPos, true)
	if not summon then
		local tile = player:getTile()
		if tile and tile:hasFlag(TILESTATE_PROTECTIONZONE) then
			summon = Game.createMonster(petName, playerPos, false, true)
		end
		
		if not summon then
			player:sendCancelMessage(RETURNVALUE_NOTENOUGHROOM)
			playerPos:sendMagicEffect(CONST_ME_POFF)
			return false
		end
	end
	
	player:addSummon(summon)
	summon:setFamiliar(true)
	summon:changeSpeed(player:getBaseSpeed())
	if lookType ~= -1 then
		summon:setOutfit({["lookType"] = lookType})
	end
	
	PlayerFamiliars[summon:getId()] = os.time() + familiarDuration
	return summon
end

-- summon function
local function summonFamiliar(player, petName)
	-- general
	if player:getSkull() == SKULL_BLACK then
		player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
		return false
	end
	
	local playerPos = player:getPosition()
	
	-- familiar specific
	local summons = player:getSummons()
	if #summons > 0 then
		if not player:getGroup():getAccess() then
			if #summons > 2 then
				player:sendCancelMessage("You cannot summon more creatures.")
				playerPos:sendMagicEffect(CONST_ME_POFF)
				return false
			end
			
			for i = 1, #summons do
				if summons[i]:isMonster() and summons[i]:isFamiliar() then
					player:sendCancelMessage("You already summoned the familiar.")
					playerPos:sendMagicEffect(CONST_ME_POFF)
					return false
				end
			end
		end
	end
	
	if placeFamiliar(player, petName) then
		playerPos:sendMagicEffect(CONST_ME_MAGIC_BLUE)
		return true
	end
	
	return false
end

-- register spells
for summonSpell = 1, #summonSpells do
	local spellConfig = summonSpells[summonSpell]
	local spell = Spell(SPELL_INSTANT)
	spell:id(spellConfig.icon)
	spell:name(spellConfig.name)
	spell:words(spellConfig.words)
	spell:level(level)
	spell:mana(spellConfig.mana)
	spell:isPremium(true)
	spell:needLearn(false)
	spell:group(SPELLGROUP_SUPPORT)
	spell:cooldown(cooldown)
	spell:groupCooldown(2000)
	spell:isAggressive(false)
	local vocMap = {}
	if #spellConfig.vocation > 0 then
		for i = 1, #spellConfig.vocation do
			local voc = Vocation(spellConfig.vocation[i])
			if voc then
				vocMap[#vocMap + 1] = voc:getName()
			end
		end
	end
	spell:vocation(unpack(vocMap))
	
	function spell.onCastSpell(player, variant)
		if not player:getPosition():canPlaceSummon(player) then
			player:sendCancelMessage("You cannot summon anything here.")
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			return false
		end
	
		return summonFamiliar(player, spellConfig.pet)
	end
	spell:register()
end

---- LOAD AND SAVE
-- logout
do
	local creatureevent = CreatureEvent("familiarLogout")
	function creatureevent.onLogout(player)
		local found = false
		
		local summons = player:getSummons()
		if #summons > 0 then
			for i = 1, #summons do
				local summon = summons[i]
				if summon:isMonster() and summon:isFamiliar() then
					local expiresAt = PlayerFamiliars[summon:getId()]
					player:setStorageValue(PlayerStorageKeys.familiarDuration, expiresAt and expiresAt - os.time() or -1)
					player:setStorageValue(PlayerStorageKeys.familiarHealth, summon:getHealth())
					
					found = true
					break
				end
			end			
		end
		
		if not found then
			player:setStorageValue(PlayerStorageKeys.familiarHealth, -1)
			player:setStorageValue(PlayerStorageKeys.familiarDuration, -1)
		end
		
		return true
	end
	creatureevent:register()
end

-- death
do
	local creatureevent = CreatureEvent("familiarDeath")
	function creatureevent.onDeath(player)
		player:setStorageValue(PlayerStorageKeys.familiarHealth, -1)
		player:setStorageValue(PlayerStorageKeys.familiarDuration, -1)
		return true
	end
	creatureevent:register()
end

-- load and register
do
	local creatureevent = CreatureEvent("familiarLogin")
	function creatureevent.onLogin(player)
		local duration = player:getStorageValue(PlayerStorageKeys.familiarDuration)
		if duration > 0 then
			local health = player:getStorageValue(PlayerStorageKeys.familiarHealth)
			if health > 0 then
				local vocName = player:getVocation():getBase():getName():lower()
				if vocName ~= "none" then
					local summon = placeFamiliar(player, string.format("%s familiar", vocName))
					if summon then
						summon:setHealth(health)
						PlayerFamiliars[summon:getId()] = os.time() + duration
					end
				end
			end			
		end
		
		-- register logout and death
		player:registerEvent("familiarLogout")
		player:registerEvent("familiarDeath")
		return true
	end
	creatureevent:register()
end

---- ONLOOK
local function familiarOnLookEvent(self, thing, description)
	if thing:isMonster() then
		local master = thing:getMaster()
		if master and master:isPlayer() then		
			local expiresAt = PlayerFamiliars[thing:getId()]
			if expiresAt then
				local duration = math.floor(math.max(0, expiresAt - os.time()))
				if duration > 60 then
					description = string.format("%s (Master: %s).\nIt will disappear in %s.", description, master:getName(), Game.getCountdownString(duration, true, false))
				else
					description = string.format("%s (Master: %s).\nIt will disappear in less than one minute.", description, master:getName())
				end
			end
		end
	end
	
	return description
end
do
	local ec = EventCallback
	ec.onLook = function(self, thing, position, distance, description)
		return familiarOnLookEvent(self, thing, description)
	end
	ec:register()
end
do
	local ec = EventCallback
	ec.onLookInBattleList = function(self, creature, distance, description)
		return familiarOnLookEvent(self, creature, description)
	end
	ec:register()
end

---- UPDATE FAMILIAR SKIN ON SET OUTFIT
local ec = EventCallback
ec.onChangeOutfit = function(self, outfit)
	if self:isPlayer() then
		local familiar = Game.getFamiliarById(self:getCurrentFamiliar())
		if familiar then
			local summons = self:getSummons()
			if #summons > 0 then
				for i = 1, #summons do
					local summon = summons[i]
					if summon:isMonster() and summon:isFamiliar() then
						summon:setOutfit({["lookType"] = familiar.clientId})
						return true
					end
				end
			end
		end
	end
	
	return true
end
ec:register()