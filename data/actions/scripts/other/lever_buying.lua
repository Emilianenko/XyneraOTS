function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	
    local config = {
		item_id = 2268, -- here past item id which you are selling
		count_of_item = 100, -- here past count of item id which you are selling
		how_much_cost = 13500 -- here past price, now it means 50 gold coins.
	}

    if item:getUniqueId() == 50021 then
        if player:removeTotalMoney(how_much_cost) then
            player:sendColorMessage("Sorry, you don't have enough money.", MESSAGE_COLOR_YELLOW)
            return true
        else
            player:sendColorMessage("You don't have enough money.", MESSAGE_COLOR_PURPLE)
            player:getPosition():sendMagicEffect(CONST_ME_POFF)
        end
    end    
	return true
end