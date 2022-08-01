-- make defining absurd prices easier
STACK_100CC = 10000 * 100

-- storage key on which the forge dust balance will be stored
FORGE_DUST_STORAGE = PlayerStorageKeys.resourcesBase + RESOURCE_FORGE_DUST

-- item constants
ITEM_FORGE_DUST = 39816 -- not meant to be in-game item
ITEM_FORGE_SLIVERS = 39765
ITEM_FORGE_CORES = 39766
ITEM_FORGE_CHEST = 40217

-- items that will act as forge
ITEM_FORGE_PLACE_FIRST = 39771
ITEM_FORGE_PLACE_LAST = 39798

-- protocol
FORGE_REQUEST_USEFORGE = 0xBF -- fuse/transfer/convert
FORGE_REQUEST_HISTORY = 0xC0 -- request forge history

FORGE_RESPONSE_BASE = 0x87 -- forge window
FORGE_RESPONSE_META = 0x86 -- forge metadata (classes, tiers, chances, costs)
FORGE_RESPONSE_HISTORY = 0x88 -- forge actions history / to do
FORGE_RESPONSE_EXIT = 0x89 -- close forge UI (no more bytes required)
FORGE_RESPONSE_RESULT = 0x8A -- fusion/transfer result

FORGE_ACTION_CONVERSION = 2 -- for history tab

-- forge results
FORGE_RESULT_FAILURE = 0
FORGE_RESULT_SUCCESS = 1

-- forge bonuses
FORGE_BONUS_NONE = 0
FORGE_BONUS_DUSTKEPT = 1 -- dust not consumed
FORGE_BONUS_CORESKEPT = 2 -- cores not consumed
FORGE_BONUS_GOLDKEPT = 3 -- gold not consumed
FORGE_BONUS_ITEMKEPT_ONETIERLOST = 4 -- item not consumed, lost 1 tier only
FORGE_BONUS_ITEMKEPT_NOTIERLOST = 5 -- second item and its tier kept
FORGE_BONUS_BOTHUPGRADED = 6 -- both items gained tier
FORGE_BONUS_EXTRATIER = 7 -- item gained two tiers
FORGE_BONUS_ITEMNOTCONSUMED = 8 -- second item did not lose a tier
	
-- error handler
--[[
	normally the player should not be able to reach these error states
	this handles weird situations such as:
	- player trading while using forge
	- player resources changing when being in forge window
	- player's client sending bad requests to the forge
]]

FORGE_ERROR_NOTENOUGHGOLD = 1
FORGE_ERROR_NOTENOUGHDUST = 2
FORGE_ERROR_NOTENOUGHSLIVERS = 3
FORGE_ERROR_NOTENOUGHCORES = 4
FORGE_ERROR_NOTENOUGHITEMS = 5
FORGE_ERROR_NOTENOUGHCAP = 6
FORGE_ERROR_NOTENOUGHROOM = 7
FORGE_ERROR_NOTUPGRADEABLE = 8
FORGE_ERROR_MAXDUSTLEVELREACHED = 9
FORGE_ERROR_BADLEVELINCREASEPRICE = 10
FORGE_ERROR_TIERTOOHIGH = 11
FORGE_ERROR_NOTINFORGE = 12
FORGE_ERROR_BADREQUEST = 13

-- cache forge data to resend ui after dust level upgrade
FORGE_CACHE_TYPE_BYTE = 1
FORGE_CACHE_TYPE_U16 = 2
ForgeCache = {}

do
	local forgeOrder = {
		"sliversDustCost", "sliversPerConversion", "coreSliversCost", "dustLimitIncreaseCost",
		"minStoredDustLimit", "maxStoredDustLimit", "fusionDustCost", "transferDustCost",
		"fusionBaseSuccessRate", "fusionBonusSuccessRate", "fusionReducedTierLossChance"
	}
	function getForgeOrder()
		return forgeOrder
	end
end