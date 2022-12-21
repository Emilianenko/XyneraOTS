local flaskToTierMap = {
	-- strong, great, normal
	[7634] = 2,
	[7635] = 3,
	[7636] = 1
}

local flask = Action()
function flask.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not target or not target:isItem() then
		return false
	end
	
	local kegId = target:getId()
	if not KegTable[kegId] then
		return false	
	end
	
	local itemId = item:getId()
	local targetName = target:getName():lower()
	local targetPos = target:getPosition()
	local isKeg = targetName:match("keg")
	local tier = targetName:match("strong") and 2 or (targetName:match("great") or targetName:match("ultimate") or targetName:match("supreme")) and 3 or 1
	if flaskToTierMap[itemId] ~= tier then
		targetPos:sendMagicEffect(CONST_ME_BLOCKHIT)
		player:say("This flask does not match.", TALKTYPE_MONSTER_SAY, false, player)
		return false
	end

	local count = item:getCount()
	local charges = target:getAttribute(ITEM_ATTRIBUTE_CHARGES)

	targetPos:sendMagicEffect(targetName:match("health") and CONST_ME_REDSMOKE or targetName:match("mana") and CONST_ME_PURPLESMOKE or CONST_ME_EXPLOSIONHIT)
	
	local newCharges = charges - count
	if newCharges > 0 then
		target:setAttribute(ITEM_ATTRIBUTE_CHARGES, charges - count)
	else
		targetPos:sendMagicEffect(CONST_ME_BLOCKHIT)
		player:say(string.format("You emptied your %s.", isKeg and "keg" or "cask"), TALKTYPE_MONSTER_SAY, false, player)
		target:remove()
	end
	
	item:transform(KegTable[kegId][1], charges - math.max(0, newCharges))
	if newCharges < 0 and charges ~= 0 then
		player:addItem(itemId, math.abs(newCharges), true)
	end
	
	return true
end

flask:id(7634)
flask:id(7635)
flask:id(7636)
flask:register()
