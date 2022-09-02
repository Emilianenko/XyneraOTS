HIRELING_FEATURE_BANKER = 2^0 -- bank
HIRELING_FEATURE_TRADER = 2^1 -- potions
HIRELING_FEATURE_COOK = 2^2 -- cooking
HIRELING_FEATURE_STEWARD = 2^3 -- stash access

-- register hireling features
local creatureevent = CreatureEvent("HirelingFeatures")
function creatureevent.onLogin(player)
	Game.playerHirelingFeatures(player:getGuid(), player:getStorageValue(HIRELING_UNLOCK_BASE_STORAGE))
	return true
end
creatureevent:register()

-- set hireling features (true - unlock, false - lock)
function Player:setHirelingFeature(featureId, enable)
	local features = math.max(0, self:getStorageValue(HIRELING_UNLOCK_BASE_STORAGE))
	local newValue
	if enable then
		newValue = bit.addFlag(features, featureId)
	else
		newValue = bit.removeFlag(features, featureId)
	end

	self:setStorageValue(HIRELING_UNLOCK_BASE_STORAGE, newValue)	
	Game.playerHirelingFeatures(self:getGuid(), newValue)
end
