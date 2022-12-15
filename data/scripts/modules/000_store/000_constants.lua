-- store tab constants
STORE_TAB_HOME = 0
STORE_TAB_PREMIUM = 1
STORE_TAB_CONSUMABLES = 2
STORE_TAB_BLESSINGS = 3
STORE_TAB_CASKS = 4
STORE_TAB_EXERCISE = 5
STORE_TAB_KEGS = 6
STORE_TAB_POTIONS = 7
STORE_TAB_RUNES = 8
STORE_TAB_COSMETICS = 9
STORE_TAB_MOUNTS = 10
STORE_TAB_OUTFITS = 11
STORE_TAB_HOUSES = 12
STORE_TAB_DECORATIONS = 13
STORE_TAB_FURNITURE = 14
STORE_TAB_BEDS = 15
STORE_TAB_UPGRADES = 16
STORE_TAB_HIRELINGS = 17
STORE_TAB_HIRELING_DRESS = 18
STORE_TAB_BOOSTS = 19
STORE_TAB_EXTRAS = 20
STORE_TAB_SERVICES = 21
STORE_TAB_USEFUL = 22
STORE_TAB_TOURNAMENT = 23
STORE_TAB_TICKETS = 24
STORE_TAB_EXCLUSIVE = 25

-- offer status
STORE_CATEGORY_TYPE_NORMAL = 0
STORE_CATEGORY_TYPE_NEW = 1
STORE_CATEGORY_TYPE_DISCOUNT = 2
STORE_CATEGORY_TYPE_TIMED = 3

-- currency type
STORE_CURRENCY_COINS = 0
STORE_CURRENCY_TRANSFERABLE = 1
STORE_CURRENCY_TOURNAMENT = 2

-- offer structure
STORE_OFFER_TYPE_DEFAULT = 0
STORE_OFFER_TYPE_MOUNT = 1
STORE_OFFER_TYPE_OUTFIT = 2
STORE_OFFER_TYPE_ITEM = 3
STORE_OFFER_TYPE_HIRELING = 4

-- reasons offer is disabled
STORE_REASON_ERROR = 1
STORE_REASON_MAINTENANCE = 2
STORE_REASON_OWNED_OUTFIT = 3
STORE_REASON_OWNED_ADDON = 4
STORE_REASON_NEED_OUTFIT = 5
STORE_REASON_NEED_PREMIUM = 6
STORE_REASON_NEED_HOUSE = 7
STORE_REASON_OWNED_MOUNT = 8
STORE_REASON_BLESS_ALL = 9
STORE_REASON_BLESS_MAX = 10
STORE_REASON_GOLDPOUCH = 11
STORE_REASON_HIRELING_NEEDED = 12
STORE_REASON_HIRELING_OUTFIT = 13
STORE_REASON_HIRELING_SKILL = 14
STORE_REASON_HIRELING_LIMIT = 15
STORE_REASON_HIRELING_DRESS = 16
STORE_REASON_JOKERS = 17
STORE_REASON_WILDCARDS = 18
STORE_REASON_CHARM = 19
STORE_REASON_PREYSLOTS = 20
STORE_REASON_XP_ACTIVE = 21
STORE_REASON_XP_LIMIT = 22

STORE_REASON_LAST = STORE_REASON_XP_LIMIT

StoreOfferDisableReasons = {
	-- errors
	[STORE_REASON_ERROR] = "Failed to load the offer.",
	[STORE_REASON_MAINTENANCE] = "Disabled by an administrator.",	

	-- premium required
	[STORE_REASON_NEED_PREMIUM] = "This product is reserved for characters with VIP access.\nTreat yourself to some Premium Time!",
	
	-- house
	[STORE_REASON_NEED_HOUSE] = "You do not own a house or a guildhall. You can use this item only in houses you own by purchasing character.",
	
	-- outfits
	[STORE_REASON_OWNED_OUTFIT] = "You already have this outfit.",
	[STORE_REASON_OWNED_ADDON] = "You already have this addon.",
	[STORE_REASON_NEED_OUTFIT] = "You need the outfit first in order to buy the addon.",

	-- mounts
	[STORE_REASON_OWNED_MOUNT] = "You already have this mount.",
	
	-- bless
	[STORE_REASON_BLESS_ALL] = "You already have all Blessings.",
	[STORE_REASON_BLESS_MAX] = "You reached the maximum amount for this blessing.",
	[STORE_REASON_GOLDPOUCH] = "You already have Loot Pouch.",
	
	-- hirelings
	[STORE_REASON_HIRELING_NEEDED] = "You need to have a hireling.",
	[STORE_REASON_HIRELING_OUTFIT] = "This hireling outfit is already unlocked.",
	[STORE_REASON_HIRELING_SKILL] = "This skill is already unlocked.",
	[STORE_REASON_HIRELING_LIMIT] = "You already have bought the maximum number of allowed hirelings.",
	[STORE_REASON_HIRELING_DRESS] = "You cannot purchase this dress. Either all of your hirelings already have it in their wardrobe or you do not own any hireling.",
	
	-- services
	[STORE_REASON_JOKERS] = "You already have maximum of reward tokens.",
	[STORE_REASON_WILDCARDS] = "You already have maximum of prey wildcards.",
	[STORE_REASON_CHARM] = "You already have charm expansion.",
	[STORE_REASON_PREYSLOTS] = "You already have unlocked all slots.",
	[STORE_REASON_XP_ACTIVE] = "You already have an active XP boost.",
	[STORE_REASON_XP_LIMIT] = "You cannot buy more XP boosts today.",
}

StoreOfferDisableReasonsCount = 0
for k, v in pairs(StoreOfferDisableReasons) do
	StoreOfferDisableReasonsCount = StoreOfferDisableReasonsCount + 1
end

-- main cache for store system
StoreOffers = {}
