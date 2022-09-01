-- get sex name
function sexToString(sex)
	return sex == PLAYERSEX_MALE and "male" or "female"
end

-- unlock hireling outfit
function Player:addHirelingOutfit(hirelingId, count)
	if hirelingId <= 1 or hirelingId > 0xFFFF then
		-- id 1 is unlimited
		-- ids below 1 are not allowed
		return false
	end
	
	local currentAmount = math.max(0, self:getStorageValue(HIRELING_UNLOCK_BASE_STORAGE + hirelingId))
	self:setStorageValue(HIRELING_UNLOCK_BASE_STORAGE + hirelingId, math.max(0, currentAmount + count))
	return true
end
