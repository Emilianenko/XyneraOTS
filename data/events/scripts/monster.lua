function Monster:onDropLoot(corpse)
	local player = Player(corpse:getCorpseOwner())
	if player then
		player:updateKillTracker(self, corpse)
	end
	
	if configManager.getNumber(configKeys.RATE_LOOT) == 0 then
		return
	end

	if EventCallback.onDropLoot then
		EventCallback.onDropLoot(self, corpse)
	end

	local lootCreated = corpse:getItemHoldingCount() > 0
	local player = Player(corpse:getCorpseOwner())
	local mType = self:getType()
	
	if not player or player:getStamina() > 840 then
		lootCreated = true
	end
	
	if lootCreated then
		local monsterLoot = mType:getLoot()
		for i = 1, #monsterLoot do
			local item = corpse:createLootItem(monsterLoot[i])
			if not item then
				print("[Warning] DropLoot: Could not add loot item to corpse.")
			end
		end		
	end
	
	if player then
		local text
		if lootCreated then
			text = ("Loot of %s: %s"):format(mType:getNameDescription(), corpse:getColorContentDescription())
		else
			text = ("Loot of %s: nothing (due to low stamina)"):format(mType:getNameDescription())
		end
		
		local party = player:getParty()
		if party then
			party:broadcastPartyLoot(text)
		else
			player:sendTextMessage(MESSAGE_LOOT, text)
		end
	end
end

function Monster:onSpawn(position, startup, artificial)
	if EventCallback.onSpawn then
		return EventCallback.onSpawn(self, position, startup, artificial)
	else
		return true
	end
end
