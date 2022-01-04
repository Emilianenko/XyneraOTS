local level = 200
local duration = 15 * 60 * 1000
local cooldown = 30 * 60 * 1000

local summonSpells = {
	{pet = "sorcerer familiar", name = "Summon Sorcerer Familiar", words = "utevo gran res ven", icon = 196, cost = 3000, vocation = {1, 5}},
	{pet = "druid familiar", name = "Summon Druid Familiar", words = "utevo gran res dru", icon = 197, cost = 3000, vocation = {2, 6}},
	{pet = "paladin familiar", name = "Summon Paladin Familiar", words = "utevo gran res sac", icon = 195, cost = 2000, vocation = {3, 7}},
	{pet = "knight familiar", name = "Summon Knight Familiar", words = "utevo gran res eq", icon = 194, cost = 1000, vocation = {4, 8}},
}

local function summonFamiliar(spellConfig, player, variant)
	local summons = player:getSummons()
	if #summons > 0 then
		if not player:getGroup():getAccess() then
			if #summons > 2 then
				player:sendCancelMessage("You cannot summon more creatures.")
				player:getPosition():sendMagicEffect(CONST_ME_POFF)
				return false
			end
			
			for i = 1, #summons do
				if summons[i]:isMonster() and summons[i]:isFamiliar() then
					player:sendCancelMessage("You already summoned the familiar.")
					player:getPosition():sendMagicEffect(CONST_ME_POFF)
					return false
				end
			end
		end
	end
	
	-- check if player can use currently selected familiar skin
	local lookType = -1
	local familiarId = player:getCurrentFamiliar()
	
	if player:canUseFamiliar(familiarId) then
		local familiar = Game.getFamiliarById(familiarId)
		if familiar then
			lookType = familiar.clientId
		end
	end
	
	local summon = Game.createMonster(spellConfig.pet, player:getPosition(), false, true)
	if not summon then
		player:sendCancelMessage(RETURNVALUE_NOTENOUGHROOM)
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end
	
	summon:setMaster(player)
	summon:setFamiliar(true)
	summon:changeSpeed(player:getBaseSpeed())
	if lookType ~= -1 then
		summon:setOutfit({["lookType"] = lookType})
	end
	
	return true
end

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

	local vocMap = {}
	if #spellConfig.vocation > 0 then
		for i = 1, #spellConfig.vocation do
			local voc = Vocation(spellConfig.vocation[i])
			if voc then
				vocMap[#vocMap + 1] = voc:getName()
			end
		end
	end
	
	function spell.onCastSpell(player, variant)
		return summonFamiliar(spellConfig, player, variant)
	end
	spell:register()
end