-- HOME PAGE
StoreBannerDelay = 2
StoreBanners = {
	[1] = {image = "Home/banner_arbalester.png", type = 4, offerId = 0},
	[2] = {image = "Home/banner_babyelephant.png", type = 4, offerId = 0},
	[3] = {image = "Home/banner_herder.png", type = 4, offerId = 0},
}

-- STORE TABS
StoreCategories = {
	-- use strict indexes so Lua wont reorder it randomly
	-- make sure it matches constants file
	-- it is required for redirects and autoregister to work properly
	[1] = {
		name = "VIP Pass", -- premium time
		image = "PremiumTime",
		offers = {},
	},
	[2] = {
		name = "Consumables",
		redirect = STORE_TAB_BLESSINGS,
	},
	[3] = {
		name = "Blessings", parent = "Consumables",
		offerTypes = {
			[1] = { name = "Regular", offers = {}},
			[2] = { name = "Specials", offers = {}}
		},
	},
	[4] = {
		name = "Casks", parent = "Consumables",
		offerTypes = {
			[1] = { name = "Health Casks", offers = {}},
			[2] = { name = "Mana Casks", offers = {}},
			[3] = { name = "Spirit Casks", offers = {}}
		},
	},
	[5] = {
		name = "Exercise Weapons", parent = "Consumables",
		image = "ExerciseWeapons",
		offerTypes = {
			[1] = { name = "Normal", offers = {}},
			[2] = { name = "Durable", offers = {}},
			[3] = { name = "Lasting", offers = {}}
		},
	},
	[6] = {
		name = "Kegs", parent = "Consumables",
		offerTypes = {
			[1] = { name = "Health Kegs", offers = {}},
			[2] = { name = "Mana Kegs", offers = {}},
			[3] = { name = "Spirit Kegs", offers = {}}
		},
	},
	[7] = {
		name = "Potions", parent = "Consumables",
		offerTypes = {
			[1] = { name = "Health Potions", offers = {}},
			[2] = { name = "Mana Potions", offers = {}},
			[3] = { name = "Spirit Potions", offers = {}}
		},
	},
	[8] = {
		name = "Runes", parent = "Consumables",
		offerTypes = {
			[1] = { name = "Damage", offers = {}},
			[2] = { name = "Fields and Walls", offers = {}},
			[3] = { name = "Healing", offers = {}},
			[4] = { name = "Summon", offers = {}},
			[5] = { name = "Support", offers = {}}
		},
	},
	[9] = {
		name = "Cosmetics",
		redirect = STORE_TAB_MOUNTS,
	},
	[10] = {
		name = "Mounts", parent = "Cosmetics",
		offerTypes = {
			[1] = { name = "Bronze Mounts", offers = {}},
			[2] = { name = "Silver Mounts", offers = {}},
			[3] = { name = "Gold Mounts", offers = {}}
		},
	},
	[11] = {
		name = "Outfits", parent = "Cosmetics",
		offerTypes = {
			[1] = { name = "Bronze Outfits", offers = {}},
			[2] = { name = "Silver Outfits", offers = {}},
			[3] = { name = "Gold Outfits", offers = {}},
			[4] = { name = "Retro Outfits", offers = {}}
		},
	},
	[12] = {
		name = "Houses",
		image = "HouseTools",
		redirect = STORE_TAB_DECORATIONS,
	},
	[13] = {
		name = "Decorations", parent = "Houses",
		image = "HouseDecorations",
		offerTypes = {
			[1] = { name = "Floor Coverings", offers = {}},
			[2] = { name = "Tapestries", offers = {}},
			[3] = { name = "Pets", offers = {}},
			[4] = { name = "Plants", offers = {}},
			[5] = { name = "Paintings", offers = {}},
			[6] = { name = "Busts", offers = {}},
			[7] = { name = "Lamps", offers = {}},
			[8] = { name = "Festive", offers = {}},
			[9] = { name = "Cushions", offers = {}},
			[10] = { name = "Skulls", offers = {}},
			[11] = { name = "Pirate", offers = {}},
			[12] = { name = "Kitchen", offers = {}},
			[13] = { name = "Smithy", offers = {}},
			[14] = { name = "Kraken", offers = {}},
			[15] = { name = "Zaoan", offers = {}},
			[16] = { name = "Seafarer", offers = {}},
			[17] = { name = "Other", offers = {}}
		},
	},
	[14] = {
		name = "Furniture", parent = "Houses",
		image = "HouseFurniture",
		offerTypes = {
			[1] = { name = "Magnificent", offers = {}},
			[2] = { name = "Ferocious", offers = {}},
			[3] = { name = "Rustic", offers = {}},
			[4] = { name = "Vengothic", offers = {}},
			[5] = { name = "Verdant", offers = {}},
			[6] = { name = "Ornate", offers = {}},
			[7] = { name = "Alchemistic", offers = {}},
			[8] = { name = "Skeletal", offers = {}},
			[9] = { name = "Comfy", offers = {}},
			[10] = { name = "Dwarven Stone", offers = {}},
			[11] = { name = "Hrodmir", offers = {}},
			[12] = { name = "Ice", offers = {}},
			[13] = { name = "Heart", offers = {}},
			[14] = { name = "Artist", offers = {}},
			[15] = { name = "Sculptor", offers = {}},
			[16] = { name = "Kitchen", offers = {}},
			[17] = { name = "Smithy", offers = {}},
			[18] = { name = "Grandiose", offers = {}},
			[19] = { name = "Volcanic", offers = {}},
			[20] = { name = "Nature", offers = {}},
			[21] = { name = "Kraken", offers = {}},
			[22] = { name = "Zaoan Aristocrat", offers = {}},
			[23] = { name = "Knightly", offers = {}},
			[24] = { name = "Floral", offers = {}},
			[25] = { name = "Seafarer", offers = {}},
			[26] = { name = "Other", offers = {}},
		},
	},
	[15] = {
		name = "Beds", parent = "Houses",
		offers = {},
	},
	[16] = {
		name = "Upgrades", parent = "Houses",
		image = "HouseUpgrades",
		offerTypes = {
			[1] = { name = "Expert Exercise Dummies", offers = {}},
			[2] = { name = "Mailboxes", offers = {}},
			[3] = { name = "Imbuing Shrines", offers = {}},
			[4] = { name = "Daily Reward Shrines", offers = {}}
		},
	},
	[17] = {
		name = "Hirelings", parent = "Houses",
		image = "HouseTools_NPCApprenticeships",
		offers = {},
	},
	[18] = {
		name = "Hireling Dresses", parent = "Houses",
		image = "HouseTools_NPCDresses",
		offerTypes = {
			[1] = { name = "Bronze Outfits", offers = {}},
			[2] = { name = "Silver Outfits", offers = {}},
			[3] = { name = "Gold Outfits", offers = {}},
		},
	},
	[19] = {
		name = "Boosts",
		offers = {},
	},
	[20] = {
		name = "Extras",
		redirect = STORE_TAB_SERVICES,
	},
	[21] = {
		name = "Extra Services", parent = "Extras",
		image = "ExtraServices",
		offers = {},
	},
	[22] = {
		name = "Useful Things", parent = "Extras",
		image = "UsefulThings",
		offers = {},
	},
	--[[
	-- unused
	[23] = {
		name = "Tournament",
		redirect = STORE_TAB_TICKETS,
	},
	[24] = {
		name = "Tickets", parent = "Tournament",
		offers = {},
	},
	[25] = {
		name = "Exclusive Offers", parent = "Tournament",
		image = "ExclusiveOffers",
		offers = {},
	}
	]]
}
