function onSay(player, words, param)
	if not player:getGroup():getAccess() then
		return true
	end

	local position = player:getPosition()
	position:getNextPosition(player:getDirection())

	local tile = Tile(position)
	if not tile then
		player:sendColorMessage("There is no tile in front of you.", MESSAGE_COLOR_PURPLE)
		return false
	end

	local thing = tile:getTopVisibleThing(player)
	if not thing then
		player:sendColorMessage("There is an empty tile in front of you.", MESSAGE_COLOR_PURPLE)
		return false
	end

	local separatorPos = param:find(',')
	if not separatorPos then
		player:sendColorMessage(string.format("Usage: %s attribute, value.", words), MESSAGE_COLOR_PURPLE)
		return false
	end

	local attribute = string.trim(param:sub(0, separatorPos - 1))
	local value = string.trim(param:sub(separatorPos + 1))

	if thing:isItem() then
		local attributeId = Game.getItemAttributeByName(attribute)
		if attributeId == ITEM_ATTRIBUTE_NONE then
			player:sendColorMessage("Invalid attribute name.", MESSAGE_COLOR_PURPLE)
			return false
		end

		if not thing:setAttribute(attribute, value) then
			player:sendColorMessage("Could not set attribute.", MESSAGE_COLOR_PURPLE)
			return false
		end

		player:sendColorMessage(string.format("Attribute %s set to: %s", attribute, thing:getAttribute(attributeId)), MESSAGE_COLOR_PURPLE)
		position:sendMagicEffect(CONST_ME_MAGIC_GREEN)
	else
		player:sendColorMessage("Thing in front of you is not supported.", MESSAGE_COLOR_PURPLE)
		return false
	end
end
