-- returns all the players who assisted in killing the creature
-- do not remove nil checks, the map can hold both true and false
local partyRewardRange = 40

function Creature:getKillCreditsMap()
	local selfPos = self:getPosition()
	local partyMap = {}
	
	local damageMap = self:getDamageMap()
	for attackerId, _ in pairs(damageMap) do
		if partyMap[attackerId] == nil then
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
					partyMap[realAttackerId] = true
					
					-- count party contribution
					local party = attacker:getParty()
					if party then
						local leader = party:getLeader():getId()
						if partyMap[leader] == nil then
							partyMap[leader] = selfPos:getDistance(party:getLeader():getPosition()) < partyRewardRange

							for k, partyMember in pairs(party:getActiveMembers()) do
								partyMap[partyMember:getId()] = selfPos:getDistance(partyMember:getPosition()) < partyRewardRange
							end
						end
					end
				end
			end
		end
	end
	
	return partyMap
end