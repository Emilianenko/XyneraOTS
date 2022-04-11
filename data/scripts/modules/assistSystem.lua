-- returns all the players who assisted in killing the creature
function Creature:getKillCreditsMap()
	local assistMap = {}
	local partyMap = {}
	
	local damageMap = self:getDamageMap()
	for attackerId, _ in pairs(damageMap) do
		if not assistMap[attackerId] then
			local attacker = Creature(attackerId)
			if attacker then
				-- count summon contribution as player contribution
				if attacker:isMonster() then
					local master = attacker:getMaster()
					if master and master:isPlayer() then
						attacker = master
					end
				end

				-- get real attacker id
				local realAttackerId = attacker:getId()

				-- count player contribution
				if attacker:isPlayer() then
					assistMap[realAttackerId] = true
					
					-- count party contribution
					local party = attacker:getParty()
					if party then
						local leader = party:getLeader():getId()
						if not partyMap[leader] then
							partyMap[leader] = true
							
							for k, partyMember in pairs(party:getActiveMembers()) do
								assistMap[partyMember:getId()] = true
							end
						end
					end
				end
			end
		end
	end
	
	local outputAssistMap = {}
	local ticksDuration = configManager.getNumber(configKeys.PZ_LOCKED)
	for playerId, _ in pairs(assistMap) do
		outputAssistMap[playerId] = true
		for assistId, ticks in pairs(Player(playerId):getAssistMap()) do
			if Player(assistId) and os.time() - ticks <= ticksDuration then
				outputAssistMap[assistId] = true
			end
		end
	end
	
	return outputAssistMap
end