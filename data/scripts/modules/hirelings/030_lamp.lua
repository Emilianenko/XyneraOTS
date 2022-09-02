-- hireling lamp
local hirelingLamp = Action()
function hirelingLamp.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:isAdmin() then
		player:sendTextMessage(MESSAGE_INFO_DESCR, "Administrator mode: placing hireling anywhere.")
		player:createHirelingFromLamp(item, true)
		return true
	end
	
	local tile = player:getTile()
	if tile then
		local house = tile:getHouse()
		if house and house:getOwnerGuid() == player:getGuid() then
			player:createHirelingFromLamp(item)
			return true
		end
	end
	
	player:getPosition():sendMagicEffect(CONST_ME_POFF)
	return false
end
hirelingLamp:id(ITEM_HIRELING_LAMP) -- 32088
hirelingLamp:register()

-- dismiss a hireling
local ec = EventCallback
function ec.onUseCreature(player, target)
	if not target then
		return
	end
	
	-- npc not found, try searching tile stack
	if not target:isNpc() then
		local tile = target:getTile()
		if tile then
			for _, creature in pairs(tile:getCreatures()) do
				if creature:isNpc() then
					target = creature
					break
				end
			end
		end	
	end
	
	-- npc still not found, check admin permissions to remove creature
	if not target:isNpc() then
		if player:isAdmin() then
			target:remove()
			player:sendTextMessage(MESSAGE_INFO_DESCR, "Creature removed.")
		end
		return
	end
	
	-- send hireling to lamp
	player:dismissHireling(target)
end
ec:register()