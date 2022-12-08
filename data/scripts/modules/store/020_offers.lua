-- OFFER LIST
local desc_premium = [[<i>Enhance your gaming experience by gaining additional abilities and advantages:</i>

&#8226; access to Premium areas
&#8226; use fast transport system (ships, carpet)
&#8226; more spells
&#8226; rent houses
&#8226; found guilds
&#8226; offline training
&#8226; larger depots
&#8226; and many more

{usablebyallicon} valid for all characters on this account
{activated}]]

local desc_carpet = [[{house}
{box}
{storeinbox}
{useicon} use an unwrapped carpet to roll it out or up
{backtoinbox}]]
--[[
StoreOffers = {
	[182] = {
		name = 'Arctic Unicorn',
		description = "{character}\n{speedboost}\n\n<i>The Arctic Unicorn lives in a deep rivalry with its cousin the Blazing Unicorn. Even though they were born in completely different areas, they somehow share the same bloodline. The eternal battle between fire and ice continues. Who will win? Tangerine vs.crystal blue! The choice is yours!</i>",
		publishedAt = 1503648000,
		-- configurable = false,		
		packages = {
			[1] = {
				amount = 1, -- default: 0
				price = 870, -- max u32
				currency = 0,
				status = STORE_CATEGORY_TYPE_NORMAL,
				-- if status is discount:
				-- discountUntil = os.time() + 86400,
				-- oldPrice = 500,
				-- disbaledReasons = {"reason"},
			}
		},
		
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1018,
	},
}
]]
StoreOffers = {
	[1] = {
		name = "Flowery Grass",
		description = desc_carpet,
		publishedAt = 1663920000,

		packages = {
			[1] = {
				amount = 1,
				price = 30,
				currency = 0,
				offerId = 40016336,
				status = 0,
			},
			[2] = {
				amount = 5,
				price = 150,
				currency = 0,
				offerId = 40016343,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 44795,
	},
	[2] = {
		name = "Purple Flower Lamp",
		description = [[]],
		publishedAt = 1663920000,

		packages = {
			[1] = {
				amount = 1,
				price = 80,
				currency = 0,
				offerId = 40016335,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 44792,
	},
	[3] = {
		name = "Turquoise Flower Lamp",
		description = [[]],
		publishedAt = 1663920000,

		packages = {
			[1] = {
				amount = 1,
				price = 60,
				currency = 0,
				offerId = 40016334,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 44790,
	},
	-- TO DO: moveable bed system
	[4] = {
		name = "Flower Bed",
		description = [[<i>Sleep in a bed to restore soul, mana and hit points and to train your skills!</i>

{house}
{boxicon} comes in 2 boxes which can only be unwrapped by purchasing character, put the 2 parts together to get a functional bed
{storeinbox}
{usablebyallicon} if not already occupied, it can be used by every Premium character that has access to the house
{useicon} use it to sleep in it
{backtoinbox}]],
		publishedAt = 1663920000,

		packages = {
			[1] = {
				amount = 1,
				price = 150,
				currency = 0,
				offerId = 40016344,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_DEFAULT,
		image = "Product_HouseEquipment_FlowerBed.png",
	},
	[5] = {
		name = "Wall Flowers",
		description = [[]],
		publishedAt = 1663920000,

		packages = {
			[1] = {
				amount = 1,
				price = 50,
				currency = 0,
				offerId = 40016337,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 44796,
	},
	[6] = {
		name = "Wall Fern",
		description = [[]],
		publishedAt = 1663920000,

		packages = {
			[1] = {
				amount = 1,
				price = 50,
				currency = 0,
				offerId = 40016338,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 44797,
	},
	[7] = {
		name = "Wall Leaves",
		description = [[]],
		publishedAt = 1663920000,

		packages = {
			[1] = {
				amount = 1,
				price = 50,
				currency = 0,
				offerId = 40016339,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 44798,
	},
	[8] = {
		name = "Tendrils",
		description = [[]],
		publishedAt = 1663920000,

		packages = {
			[1] = {
				amount = 1,
				price = 50,
				currency = 0,
				offerId = 40016340,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 44800,
	},
	[9] = {
		name = "Water Nymph",
		description = [[]],
		publishedAt = 1663920000,

		packages = {
			[1] = {
				amount = 1,
				price = 180,
				currency = 0,
				offerId = 40016341,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
	},
	[10] = {
		name = "Flower Furniture",
		description = [[]],
		publishedAt = 1663920000,

		packages = {
			[1] = {
				amount = 1,
				price = 290,
				currency = 0,
				offerId = 40016342,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_DEFAULT,
		image = "Product_HouseEquipment_FloralFurniture_Bundle.png",
	},
	[11] = {
		name = "Flower Cabinet",
		description = [[]],
		publishedAt = 1663920000,

		packages = {
			[1] = {
				amount = 1,
				price = 90,
				currency = 0,
				offerId = 40016333,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
	},
	[12] = {
		name = "Flower Table",
		description = [[]],
		publishedAt = 1663920000,

		packages = {
			[1] = {
				amount = 1,
				price = 80,
				currency = 0,
				offerId = 40016332,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
	},
	[13] = {
		name = "Flower Chest",
		description = [[]],
		publishedAt = 1663920000,

		packages = {
			[1] = {
				amount = 1,
				price = 60,
				currency = 0,
				offerId = 40016331,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
	},
	[14] = {
		name = "Flower Chair",
		description = [[]],
		publishedAt = 1663920000,

		packages = {
			[1] = {
				amount = 1,
				price = 60,
				currency = 0,
				offerId = 40016330,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
	},
	[15] = {
		name = "30 days",
		description = desc_premium,
		publishedAt = 39,

		packages = {
			[1] = {
				amount = 1,
				price = 250,
				currency = 0,
				offerId = 39,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_DEFAULT,
		image = "Product_PremiumTime30.png",
	},
	[16] = {
		name = "90 days",
		description = desc_premium,
		publishedAt = 371,

		packages = {
			[1] = {
				amount = 1,
				price = 750,
				currency = 0,
				offerId = 371,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_DEFAULT,
		image = "Product_PremiumTime90.png",
	},
	[17] = {
		name = "180 days",
		description = desc_premium,
		publishedAt = 378,

		packages = {
			[1] = {
				amount = 1,
				price = 1500,
				currency = 0,
				offerId = 378,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_DEFAULT,
		image = "Product_PremiumTime180.png",
	},
	[18] = {
		name = "360 days",
		description = desc_premium,
		publishedAt = 386,

		packages = {
			[1] = {
				amount = 1,
				price = 3000,
				currency = 0,
				offerId = 386,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_DEFAULT,
		image = "Product_PremiumTime360.png",
	},
	[19] = {
		name = "Flowery Grass",
		description = [[]],
		publishedAt = 1663920000,

		packages = {
			[1] = {
				amount = 1,
				price = 30,
				currency = 0,
				offerId = 40016336,
				status = 0,
			},
			[2] = {
				amount = 5,
				price = 150,
				currency = 0,
				offerId = 40016343,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
	},
	[20] = {
		name = "Purple Flower Lamp",
		description = [[]],
		publishedAt = 1663920000,

		packages = {
			[1] = {
				amount = 1,
				price = 80,
				currency = 0,
				offerId = 40016335,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
	},
	[21] = {
		name = "Turquoise Flower Lamp",
		description = [[]],
		publishedAt = 1663920000,

		packages = {
			[1] = {
				amount = 1,
				price = 60,
				currency = 0,
				offerId = 40016334,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
	},
	[22] = {
		name = "Flower Bed",
		description = [[<i>Sleep in a bed to restore soul, mana and hit points and to train your skills!</i>

{house}
{boxicon} comes in 2 boxes which can only be unwrapped by purchasing character, put the 2 parts together to get a functional bed
{storeinbox}
{usablebyallicon} if not already occupied, it can be used by every Premium character that has access to the house
{useicon} use it to sleep in it
{backtoinbox}]],
		publishedAt = 1663920000,

		packages = {
			[1] = {
				amount = 1,
				price = 150,
				currency = 0,
				offerId = 40016344,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_DEFAULT,
		image = "Product_HouseEquipment_FlowerBed.png",
	},
	[23] = {
		name = "Wall Flowers",
		description = [[]],
		publishedAt = 1663920000,

		packages = {
			[1] = {
				amount = 1,
				price = 50,
				currency = 0,
				offerId = 40016337,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
	},
	[24] = {
		name = "Wall Fern",
		description = [[]],
		publishedAt = 1663920000,

		packages = {
			[1] = {
				amount = 1,
				price = 50,
				currency = 0,
				offerId = 40016338,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
	},
	[25] = {
		name = "Wall Leaves",
		description = [[]],
		publishedAt = 1663920000,

		packages = {
			[1] = {
				amount = 1,
				price = 50,
				currency = 0,
				offerId = 40016339,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
	},
	[26] = {
		name = "Tendrils",
		description = [[]],
		publishedAt = 1663920000,

		packages = {
			[1] = {
				amount = 1,
				price = 50,
				currency = 0,
				offerId = 40016340,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
	},
	[27] = {
		name = "Water Nymph",
		description = [[]],
		publishedAt = 1663920000,

		packages = {
			[1] = {
				amount = 1,
				price = 180,
				currency = 0,
				offerId = 40016341,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
	},
	[28] = {
		name = "Flower Furniture",
		description = [[]],
		publishedAt = 1663920000,

		packages = {
			[1] = {
				amount = 1,
				price = 290,
				currency = 0,
				offerId = 40016342,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_DEFAULT,
		image = "Product_HouseEquipment_FloralFurniture_Bundle.png",
	},
	[29] = {
		name = "Flower Cabinet",
		description = [[]],
		publishedAt = 1663920000,

		packages = {
			[1] = {
				amount = 1,
				price = 90,
				currency = 0,
				offerId = 40016333,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
	},
	[30] = {
		name = "Flower Table",
		description = [[]],
		publishedAt = 1663920000,

		packages = {
			[1] = {
				amount = 1,
				price = 80,
				currency = 0,
				offerId = 40016332,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
	},
	[31] = {
		name = "Flower Chest",
		description = [[]],
		publishedAt = 1663920000,

		packages = {
			[1] = {
				amount = 1,
				price = 60,
				currency = 0,
				offerId = 40016331,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
	},
	[32] = {
		name = "Flower Chair",
		description = [[]],
		publishedAt = 1663920000,

		packages = {
			[1] = {
				amount = 1,
				price = 60,
				currency = 0,
				offerId = 40016330,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
	},
	[33] = {
		name = "All regular Blessings",
		description = [[<i>Reduces your character's chance to lose any items as well as the amount of your character's experience and skill loss upon death:</i>

&#8226; 1 blessing = 8.00% less Skill / XP loss, 30% equipment protection
&#8226; 2 blessing = 16.00% less Skill / XP loss, 55% equipment protection
&#8226; 3 blessing = 24.00% less Skill / XP loss, 75% equipment protection
&#8226; 4 blessing = 32.00% less Skill / XP loss, 90% equipment protection
&#8226; 5 blessing = 40.00% less Skill / XP loss, 100% equipment protection
&#8226; 6 blessing = 48.00% less Skill / XP loss, 100% equipment protection
&#8226; 7 blessing = 56.00% less Skill / XP loss, 100% equipment protection

{character}
{limit|5}
{info} added directly to the Record of Blessings
{info} characters with a red or black skull will always lose all equipment upon death]],
		publishedAt = 1494316800,

		packages = {
			[1] = {
				amount = 1,
				price = 130,
				currency = 0,
				offerId = 7236922,
				status = 0,
			},
			[2] = {
				amount = 5,
				price = 650,
				currency = 0,
				offerId = 7236937,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_DEFAULT,
		image = "Product_Blessing_AllPvE.png",
	},
	[34] = {
		name = "The Wisdom of Solitude",
		description = [[<i>Reduces your character's chance to lose any items as well as the amount of your character's experience and skill loss upon death:</i>

&#8226; 1 blessing = 8.00% less Skill / XP loss, 30% equipment protection
&#8226; 2 blessing = 16.00% less Skill / XP loss, 55% equipment protection
&#8226; 3 blessing = 24.00% less Skill / XP loss, 75% equipment protection
&#8226; 4 blessing = 32.00% less Skill / XP loss, 90% equipment protection
&#8226; 5 blessing = 40.00% less Skill / XP loss, 100% equipment protection
&#8226; 6 blessing = 48.00% less Skill / XP loss, 100% equipment protection
&#8226; 7 blessing = 56.00% less Skill / XP loss, 100% equipment protection

{character}
{limit|5}
{info} added directly to the Record of Blessings
{info} characters with a red or black skull will always lose all equipment upon death]],
		publishedAt = 1494316800,

		packages = {
			[1] = {
				amount = 1,
				price = 15,
				currency = 0,
				offerId = 7236925,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_DEFAULT,
		image = "Product_Blessing_Solitude.png",
	},
	[35] = {
		name = "The Spark of the Phoenix",
		description = [[<i>Reduces your character's chance to lose any items as well as the amount of your character's experience and skill loss upon death:</i>

&#8226; 1 blessing = 8.00% less Skill / XP loss, 30% equipment protection
&#8226; 2 blessing = 16.00% less Skill / XP loss, 55% equipment protection
&#8226; 3 blessing = 24.00% less Skill / XP loss, 75% equipment protection
&#8226; 4 blessing = 32.00% less Skill / XP loss, 90% equipment protection
&#8226; 5 blessing = 40.00% less Skill / XP loss, 100% equipment protection
&#8226; 6 blessing = 48.00% less Skill / XP loss, 100% equipment protection
&#8226; 7 blessing = 56.00% less Skill / XP loss, 100% equipment protection

{character}
{limit|5}
{info} added directly to the Record of Blessings
{info} characters with a red or black skull will always lose all equipment upon death]],
		publishedAt = 1494316800,

		packages = {
			[1] = {
				amount = 1,
				price = 20,
				currency = 0,
				offerId = 7236913,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_DEFAULT,
		image = "Product_Blessing_Phoenix.png",
	},
	[36] = {
		name = "The Fire of the Suns",
		description = [[<i>Reduces your character's chance to lose any items as well as the amount of your character's experience and skill loss upon death:</i>

&#8226; 1 blessing = 8.00% less Skill / XP loss, 30% equipment protection
&#8226; 2 blessing = 16.00% less Skill / XP loss, 55% equipment protection
&#8226; 3 blessing = 24.00% less Skill / XP loss, 75% equipment protection
&#8226; 4 blessing = 32.00% less Skill / XP loss, 90% equipment protection
&#8226; 5 blessing = 40.00% less Skill / XP loss, 100% equipment protection
&#8226; 6 blessing = 48.00% less Skill / XP loss, 100% equipment protection
&#8226; 7 blessing = 56.00% less Skill / XP loss, 100% equipment protection

{character}
{limit|5}
{info} added directly to the Record of Blessings
{info} characters with a red or black skull will always lose all equipment upon death]],
		publishedAt = 1494316800,

		packages = {
			[1] = {
				amount = 1,
				price = 15,
				currency = 0,
				offerId = 7236928,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_DEFAULT,
		image = "Product_Blessing_Suns.png",
	},
	[37] = {
		name = "The Spiritual Shielding",
		description = [[<i>Reduces your character's chance to lose any items as well as the amount of your character's experience and skill loss upon death:</i>

&#8226; 1 blessing = 8.00% less Skill / XP loss, 30% equipment protection
&#8226; 2 blessing = 16.00% less Skill / XP loss, 55% equipment protection
&#8226; 3 blessing = 24.00% less Skill / XP loss, 75% equipment protection
&#8226; 4 blessing = 32.00% less Skill / XP loss, 90% equipment protection
&#8226; 5 blessing = 40.00% less Skill / XP loss, 100% equipment protection
&#8226; 6 blessing = 48.00% less Skill / XP loss, 100% equipment protection
&#8226; 7 blessing = 56.00% less Skill / XP loss, 100% equipment protection

{character}
{limit|5}
{info} added directly to the Record of Blessings
{info} characters with a red or black skull will always lose all equipment upon death]],
		publishedAt = 1494316800,

		packages = {
			[1] = {
				amount = 1,
				price = 15,
				currency = 0,
				offerId = 7236919,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_DEFAULT,
		image = "Product_Blessing_Shielding.png",
	},
	[38] = {
		name = "The World's Embrace",
		description = [[<i>Reduces your character's chance to lose any items as well as the amount of your character's experience and skill loss upon death:</i>

&#8226; 1 blessing = 8.00% less Skill / XP loss, 30% equipment protection
&#8226; 2 blessing = 16.00% less Skill / XP loss, 55% equipment protection
&#8226; 3 blessing = 24.00% less Skill / XP loss, 75% equipment protection
&#8226; 4 blessing = 32.00% less Skill / XP loss, 90% equipment protection
&#8226; 5 blessing = 40.00% less Skill / XP loss, 100% equipment protection
&#8226; 6 blessing = 48.00% less Skill / XP loss, 100% equipment protection
&#8226; 7 blessing = 56.00% less Skill / XP loss, 100% equipment protection

{character}
{limit|5}
{info} added directly to the Record of Blessings
{info} characters with a red or black skull will always lose all equipment upon death]],
		publishedAt = 1494316800,

		packages = {
			[1] = {
				amount = 1,
				price = 15,
				currency = 0,
				offerId = 7236896,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_DEFAULT,
		image = "Product_Blessing_Tibia.png",
	},
	[39] = {
		name = "Heart of the Mountain",
		description = [[<i>Reduces your character's chance to lose any items as well as the amount of your character's experience and skill loss upon death:</i>

&#8226; 1 blessing = 8.00% less Skill / XP loss, 30% equipment protection
&#8226; 2 blessing = 16.00% less Skill / XP loss, 55% equipment protection
&#8226; 3 blessing = 24.00% less Skill / XP loss, 75% equipment protection
&#8226; 4 blessing = 32.00% less Skill / XP loss, 90% equipment protection
&#8226; 5 blessing = 40.00% less Skill / XP loss, 100% equipment protection
&#8226; 6 blessing = 48.00% less Skill / XP loss, 100% equipment protection
&#8226; 7 blessing = 56.00% less Skill / XP loss, 100% equipment protection

{character}
{limit|5}
{info} added directly to the Record of Blessings
{info} characters with a red or black skull will always lose all equipment upon death]],
		publishedAt = 1494316800,

		packages = {
			[1] = {
				amount = 1,
				price = 25,
				currency = 0,
				offerId = 7236931,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_DEFAULT,
		image = "Product_Blessing_HeartOfTheMountain.png",
	},
	[40] = {
		name = "Blood of the Mountain",
		description = [[<i>Reduces your character's chance to lose any items as well as the amount of your character's experience and skill loss upon death:</i>

&#8226; 1 blessing = 8.00% less Skill / XP loss, 30% equipment protection
&#8226; 2 blessing = 16.00% less Skill / XP loss, 55% equipment protection
&#8226; 3 blessing = 24.00% less Skill / XP loss, 75% equipment protection
&#8226; 4 blessing = 32.00% less Skill / XP loss, 90% equipment protection
&#8226; 5 blessing = 40.00% less Skill / XP loss, 100% equipment protection
&#8226; 6 blessing = 48.00% less Skill / XP loss, 100% equipment protection
&#8226; 7 blessing = 56.00% less Skill / XP loss, 100% equipment protection

{character}
{limit|5}
{info} added directly to the Record of Blessings
{info} characters with a red or black skull will always lose all equipment upon death]],
		publishedAt = 1494316800,

		packages = {
			[1] = {
				amount = 1,
				price = 25,
				currency = 0,
				offerId = 7236934,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_DEFAULT,
		image = "Product_Blessing_BloodOfTheMountain.png",
	},
	[41] = {
		name = "Twist of Fate",
		description = [[<i>Protects your character's regular blessings or an Amulet of Loss if you are unfortunate enough to die in a PvP fight.</i>

{character}
{limit|5}
{info} added directly to the Record of Blessings
{info} does not work for characters with a red or black skull]],
		publishedAt = 1494316800,

		packages = {
			[1] = {
				amount = 1,
				price = 8,
				currency = 0,
				offerId = 7236916,
				status = 0,
			},
			[2] = {
				amount = 5,
				price = 40,
				currency = 0,
				offerId = 7236940,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_DEFAULT,
		image = "Product_Blessing_Fate.png",
	},
	[42] = {
		name = "Death Redemption",
		description = [[<i>Reduces the penalty of your character's most recent death.</i>

{character}
{info} can only be used for the most recent death and only within 24 hours after this death]],
		publishedAt = 1494316800,

		packages = {
			[1] = {
				amount = 1,
				price = 260,
				currency = 0,
				offerId = 7236944,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_DEFAULT,
		image = "Product_Blessing_Subsequent.png",
	},
	[43] = {
		name = "Health Cask",
		description = [[<i>Place it in your house and fill up potions to restore your hit points!</i>

{house}
{box}
{storeinbox}
{usablebyallicon} can be used to fill up potions by all characters that have access to the house
{storeinboxicon} potions created from this cask will be sent to your Store inbox and can only be stored there and in depot box
{backtoinbox}
{info} usable 1000 times a piece
{transferableprice}]],
		publishedAt = 499155200,

		packages = {
			[1] = {
				amount = 1,
				price = 5,
				currency = 1,
				offerId = 7264569,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 28535,
	},
	[44] = {
		name = "Strong Health Cask",
		description = [[<i>Place it in your house and fill up potions to restore your hit points!</i>

{house}
{box}
{storeinbox}
{usablebyallicon} can be used to fill up potions by all characters that have access to the house
{storeinboxicon} potions created from this cask will be sent to your Store inbox and can only be stored there and in depot box
{backtoinbox}
{info} usable 1000 times a piece
{transferableprice}]],
		publishedAt = 1499155200,

		packages = {
			[1] = {
				amount = 1,
				price = 11,
				currency = 1,
				offerId = 7264572,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 28536,
	},
	[45] = {
		name = "Great Health Cask",
		description = [[<i>Place it in your house and fill up potions to restore your hit points!</i>

{house}
{box}
{storeinbox}
{usablebyallicon} can be used to fill up potions by all characters that have access to the house
{storeinboxicon} potions created from this cask will be sent to your Store inbox and can only be stored there and in depot box
{backtoinbox}
{info} usable 1000 times a piece
{transferableprice}]],
		publishedAt = 1499155200,

		packages = {
			[1] = {
				amount = 1,
				price = 22,
				currency = 1,
				offerId = 7264575,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 28537,
	},
	[46] = {
		name = "Ultimate Health Cask",
		description = [[<i>Place it in your house and fill up potions to restore your hit points!</i>

{house}
{box}
{storeinbox}
{usablebyallicon} can be used to fill up potions by all characters that have access to the house
{storeinboxicon} potions created from this cask will be sent to your Store inbox and can only be stored there and in depot box
{backtoinbox}
{info} usable 1000 times a piece
{transferableprice}]],
		publishedAt = 1499155200,

		packages = {
			[1] = {
				amount = 1,
				price = 36,
				currency = 1,
				offerId = 7264578,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 28538,
	},
	[47] = {
		name = "Supreme Health Cask",
		description = [[<i>Place it in your house and fill up potions to restore your hit points!</i>

{house}
{box}
{storeinbox}
{usablebyallicon} can be used to fill up potions by all characters that have access to the house
{storeinboxicon} potions created from this cask will be sent to your Store inbox and can only be stored there and in depot box
{backtoinbox}
{info} usable 1000 times a piece
{transferableprice}]],
		publishedAt = 1499155200,

		packages = {
			[1] = {
				amount = 1,
				price = 59,
				currency = 1,
				offerId = 7264581,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 28539,
	},
	[48] = {
		name = "Mana Cask",
		description = [[<i>Place it in your house and fill up potions to refill your mana!</i>

{house}
{box}
{storeinbox}
{usablebyallicon} can be used to fill up potions by all characters that have access to the house
{storeinboxicon} potions created from this cask will be sent to your Store inbox and can only be stored there and in depot box
{backtoinbox}
{info} usable 1000 times a piece
{transferableprice}]],
		publishedAt = 1499155200,

		packages = {
			[1] = {
				amount = 1,
				price = 5,
				currency = 1,
				offerId = 7264584,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 28545,
	},
	[49] = {
		name = "Strong Mana Cask",
		description = [[<i>Place it in your house and fill up potions to refill your mana!</i>

{house}
{box}
{storeinbox}
{usablebyallicon} can be used to fill up potions by all characters that have access to the house
{storeinboxicon} potions created from this cask will be sent to your Store inbox and can only be stored there and in depot box
{backtoinbox}
{info} usable 1000 times a piece
{transferableprice}]],
		publishedAt = 1499155200,

		packages = {
			[1] = {
				amount = 1,
				price = 9,
				currency = 1,
				offerId = 7264587,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 28546,
	},
	[50] = {
		name = "Great Mana Cask",
		description = [[<i>Place it in your house and fill up potions to refill your mana!</i>

{house}
{box}
{storeinbox}
{usablebyallicon} can be used to fill up potions by all characters that have access to the house
{storeinboxicon} potions created from this cask will be sent to your Store inbox and can only be stored there and in depot box
{backtoinbox}
{info} usable 1000 times a piece
{transferableprice}]],
		publishedAt = 1499155200,

		packages = {
			[1] = {
				amount = 1,
				price = 14,
				currency = 1,
				offerId = 7264590,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 28547,
	},
	[51] = {
		name = "Ultimate Mana Cask",
		description = [[<i>Place it in your house and fill up potions to refill your mana!</i>

{house}
{box}
{storeinbox}
{usablebyallicon} can be used to fill up potions by all characters that have access to the house
{storeinboxicon} potions created from this cask will be sent to your Store inbox and can only be stored there and in depot box
{backtoinbox}
{info} usable 1000 times a piece
{transferableprice}]],
		publishedAt = 1499155200,

		packages = {
			[1] = {
				amount = 1,
				price = 42,
				currency = 1,
				offerId = 7264593,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 28548,
	},
	[52] = {
		name = "Great Spirit Cask",
		description = [[<i>Place it in your house and fill up potions to restore your hit points and mana!</i>

{house}
{box}
{storeinbox}
{usablebyallicon} can be used to fill up potions by all characters that have access to the house
{storeinboxicon} potions created from this cask will be sent to your Store inbox and can only be stored there and in depot box
{backtoinbox}
{info} usable 1000 times a piece
{transferableprice}]],
		publishedAt = 1499155200,

		packages = {
			[1] = {
				amount = 1,
				price = 22,
				currency = 1,
				offerId = 7264596,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 28555,
	},
	[53] = {
		name = "Ultimate Spirit Cask",
		description = [[<i>Place it in your house and fill up potions to restore your hit points and mana!</i>

{house}
{box}
{storeinbox}
{usablebyallicon} can be used to fill up potions by all characters that have access to the house
{storeinboxicon} potions created from this cask will be sent to your Store inbox and can only be stored there and in depot box
{backtoinbox}
{info} usable 1000 times a piece
{transferableprice}]],
		publishedAt = 1499155200,

		packages = {
			[1] = {
				amount = 1,
				price = 42,
				currency = 1,
				offerId = 7264599,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 28556,
	},
	[54] = {
		name = "Lasting Exercise Wand",
		description = [[<i>Use it to train your magic level on an exercise dummy!</i>

  

{character}

{storeinbox}

{useicon} use it on an exercise dummy to train your magic level

{info} usable 14400 times a piece]],
		publishedAt = 1607936400,

		packages = {
			[1] = {
				amount = 1,
				price = 720,
				currency = 0,
				offerId = 40005142,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 37946,
	},
	[55] = {
		name = "Lasting Exercise Rod",
		description = [[<i>Use it to train your magic level on an exercise dummy!</i>

  

{character}

{storeinbox}

{useicon} use it on an exercise dummy to train your magic level

{info} usable 14400 times a piece]],
		publishedAt = 1607936400,

		packages = {
			[1] = {
				amount = 1,
				price = 720,
				currency = 0,
				offerId = 40005140,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 37945,
	},
	[56] = {
		name = "Lasting Exercise Bow",
		description = [[<i>Use it to train your distance fighting skill on an exercise dummy!</i>

  

{character}

{storeinbox}

{useicon} use it on an exercise dummy to train your distance fighting skill

{info} usable 14400 times a piece]],
		publishedAt = 1607936400,

		packages = {
			[1] = {
				amount = 1,
				price = 720,
				currency = 0,
				offerId = 40005138,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 37944,
	},
	[57] = {
		name = "Lasting Exercise Club",
		description = [[<i>Use it to train your club fighting skill on an exercise dummy!</i>

  

{character}

{storeinbox}

{useicon} use it on an exercise dummy to train your club  fighting skill

{info} usable 14400 times a piece]],
		publishedAt = 1607936400,

		packages = {
			[1] = {
				amount = 1,
				price = 720,
				currency = 0,
				offerId = 40005136,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 37943,
	},
	[58] = {
		name = "Lasting Exercise Axe",
		description = [[<i>Use it to train your axe fighting skill on an exercise dummy!</i>

  

{character}

{storeinbox}

{useicon} use it on an exercise dummy to train your axe fighting skill

{info} usable 14400 times a piece]],
		publishedAt = 1607936400,

		packages = {
			[1] = {
				amount = 1,
				price = 720,
				currency = 0,
				offerId = 40005134,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 37942,
	},
	[59] = {
		name = "Lasting Exercise Sword",
		description = [[<i>Use it to train your sword fighting skill on an exercise dummy!</i>

  

{character}

{storeinbox}

{useicon} use it on an exercise dummy to train your sword fighting skill

{info} usable 14400 times a piece]],
		publishedAt = 1607936400,

		packages = {
			[1] = {
				amount = 1,
				price = 720,
				currency = 0,
				offerId = 40005132,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 37941,
	},
	[60] = {
		name = "Durable Exercise Wand",
		description = [[<i>Use it to train your magic level on an exercise dummy!</i>

  

{character}

{storeinbox}

{useicon} use it on an exercise dummy to train your magic level

{info} usable 1800 times a piece]],
		publishedAt = 1607936400,

		packages = {
			[1] = {
				amount = 1,
				price = 90,
				currency = 0,
				offerId = 40005130,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 37940,
	},
	[61] = {
		name = "Durable Exercise Rod",
		description = [[<i>Use it to train your magic level on an exercise dummy!</i>

  

{character}

{storeinbox}

{useicon} use it on an exercise dummy to train your magic level

{info} usable 1800 times a piece]],
		publishedAt = 1607936400,

		packages = {
			[1] = {
				amount = 1,
				price = 90,
				currency = 0,
				offerId = 40005128,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 37939,
	},
	[62] = {
		name = "Durable Exercise Bow",
		description = [[<i>Use it to train your distance fighting skill on an exercise dummy!</i>

  

{character}

{storeinbox}

{useicon} use it on an exercise dummy to train your distance fighting skill

{info} usable 1800 times a piece]],
		publishedAt = 1607936400,

		packages = {
			[1] = {
				amount = 1,
				price = 90,
				currency = 0,
				offerId = 40005126,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 37938,
	},
	[63] = {
		name = "Durable Exercise Club",
		description = [[<i>Use it to train your club fighting skill on an exercise dummy!</i>

  

{character}

{storeinbox}

{useicon} use it on an exercise dummy to train your club  fighting skill

{info} usable 1800 times a piece]],
		publishedAt = 1607936400,

		packages = {
			[1] = {
				amount = 1,
				price = 90,
				currency = 0,
				offerId = 40005124,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 37937,
	},
	[64] = {
		name = "Durable Exercise Axe",
		description = [[<i>Use it to train your axe fighting skill on an exercise dummy!</i>

  

{character}

{storeinbox}

{useicon} use it on an exercise dummy to train your axe fighting skill

{info} usable 1800 times a piece]],
		publishedAt = 1607936400,

		packages = {
			[1] = {
				amount = 1,
				price = 90,
				currency = 0,
				offerId = 40005122,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 37936,
	},
	[65] = {
		name = "Durable Exercise Sword",
		description = [[<i>Use it to train your sword fighting skill on an exercise dummy!</i>

  

{character}

{storeinbox}

{useicon} use it on an exercise dummy to train your sword fighting skill

{info} usable 1800 times a piece]],
		publishedAt = 1607936400,

		packages = {
			[1] = {
				amount = 1,
				price = 90,
				currency = 0,
				offerId = 40005114,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 37935,
	},
	[66] = {
		name = "Exercise Sword",
		description = [[<i>Use it to train your sword fighting skill on an exercise dummy!</i>
  
{character}
{storeinbox}
{useicon} use it on an exercise dummy to train your sword fighting skill
{info} usable 500 times a piece]],
		publishedAt = 1525762800,

		packages = {
			[1] = {
				amount = 1,
				price = 25,
				currency = 0,
				offerId = 7262851,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 31208,
	},
	[67] = {
		name = "Exercise Axe",
		description = [[<i>Use it to train your axe fighting skill on an exercise dummy!</i>
  
{character}
{storeinbox}
{useicon} use it on an exercise dummy to train your axe fighting skill
{info} usable 500 times a piece]],
		publishedAt = 1525762800,

		packages = {
			[1] = {
				amount = 1,
				price = 25,
				currency = 0,
				offerId = 7262853,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 31209,
	},
	[68] = {
		name = "Exercise Club",
		description = [[<i>Use it to train your club fighting skill on an exercise dummy!</i>
  
{character}
{storeinbox}
{useicon} use it on an exercise dummy to train your club  fighting skill
{info} usable 500 times a piece]],
		publishedAt = 1525762800,

		packages = {
			[1] = {
				amount = 1,
				price = 25,
				currency = 0,
				offerId = 7262855,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 31210,
	},
	[69] = {
		name = "Exercise Bow",
		description = [[<i>Use it to train your distance fighting skill on an exercise dummy!</i>
  
{character}
{storeinbox}
{useicon} use it on an exercise dummy to train your distance fighting skill
{info} usable 500 times a piece]],
		publishedAt = 1525762800,

		packages = {
			[1] = {
				amount = 1,
				price = 25,
				currency = 0,
				offerId = 7262857,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 31211,
	},
	[70] = {
		name = "Exercise Rod",
		description = [[<i>Use it to train your magic level on an exercise dummy!</i>
  
{character}
{storeinbox}
{useicon} use it on an exercise dummy to train your magic level
{info} usable 500 times a piece]],
		publishedAt = 1525762800,

		packages = {
			[1] = {
				amount = 1,
				price = 25,
				currency = 0,
				offerId = 7262859,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 31212,
	},
	[71] = {
		name = "Exercise Wand",
		description = [[<i>Use it to train your magic level on an exercise dummy!</i>
  
{character}
{storeinbox}
{useicon} use it on an exercise dummy to train your magic level
{info} usable 500 times a piece]],
		publishedAt = 1525762800,

		packages = {
			[1] = {
				amount = 1,
				price = 25,
				currency = 0,
				offerId = 7262861,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 31213,
	},
	[72] = {
		name = "Lasting Exercise Wand",
		description = [[<i>Use it to train your magic level on an exercise dummy!</i>

  

{character}

{storeinbox}

{useicon} use it on an exercise dummy to train your magic level

{info} usable 14400 times a piece]],
		publishedAt = 1607936400,

		packages = {
			[1] = {
				amount = 1,
				price = 720,
				currency = 0,
				offerId = 40005142,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 37946,
	},
	[73] = {
		name = "Lasting Exercise Rod",
		description = [[<i>Use it to train your magic level on an exercise dummy!</i>

  

{character}

{storeinbox}

{useicon} use it on an exercise dummy to train your magic level

{info} usable 14400 times a piece]],
		publishedAt = 1607936400,

		packages = {
			[1] = {
				amount = 1,
				price = 720,
				currency = 0,
				offerId = 40005140,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 37945,
	},
	[74] = {
		name = "Lasting Exercise Bow",
		description = [[<i>Use it to train your distance fighting skill on an exercise dummy!</i>

  

{character}

{storeinbox}

{useicon} use it on an exercise dummy to train your distance fighting skill

{info} usable 14400 times a piece]],
		publishedAt = 1607936400,

		packages = {
			[1] = {
				amount = 1,
				price = 720,
				currency = 0,
				offerId = 40005138,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 37944,
	},
	[75] = {
		name = "Lasting Exercise Club",
		description = [[<i>Use it to train your club fighting skill on an exercise dummy!</i>

  

{character}

{storeinbox}

{useicon} use it on an exercise dummy to train your club  fighting skill

{info} usable 14400 times a piece]],
		publishedAt = 1607936400,

		packages = {
			[1] = {
				amount = 1,
				price = 720,
				currency = 0,
				offerId = 40005136,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 37943,
	},
	[76] = {
		name = "Lasting Exercise Axe",
		description = [[<i>Use it to train your axe fighting skill on an exercise dummy!</i>

  

{character}

{storeinbox}

{useicon} use it on an exercise dummy to train your axe fighting skill

{info} usable 14400 times a piece]],
		publishedAt = 1607936400,

		packages = {
			[1] = {
				amount = 1,
				price = 720,
				currency = 0,
				offerId = 40005134,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 37942,
	},
	[77] = {
		name = "Lasting Exercise Sword",
		description = [[<i>Use it to train your sword fighting skill on an exercise dummy!</i>

  

{character}

{storeinbox}

{useicon} use it on an exercise dummy to train your sword fighting skill

{info} usable 14400 times a piece]],
		publishedAt = 1607936400,

		packages = {
			[1] = {
				amount = 1,
				price = 720,
				currency = 0,
				offerId = 40005132,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 37941,
	},
	[78] = {
		name = "Durable Exercise Wand",
		description = [[<i>Use it to train your magic level on an exercise dummy!</i>

  

{character}

{storeinbox}

{useicon} use it on an exercise dummy to train your magic level

{info} usable 1800 times a piece]],
		publishedAt = 1607936400,

		packages = {
			[1] = {
				amount = 1,
				price = 90,
				currency = 0,
				offerId = 40005130,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 37940,
	},
	[79] = {
		name = "Durable Exercise Rod",
		description = [[<i>Use it to train your magic level on an exercise dummy!</i>

  

{character}

{storeinbox}

{useicon} use it on an exercise dummy to train your magic level

{info} usable 1800 times a piece]],
		publishedAt = 1607936400,

		packages = {
			[1] = {
				amount = 1,
				price = 90,
				currency = 0,
				offerId = 40005128,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 37939,
	},
	[80] = {
		name = "Durable Exercise Bow",
		description = [[<i>Use it to train your distance fighting skill on an exercise dummy!</i>

  

{character}

{storeinbox}

{useicon} use it on an exercise dummy to train your distance fighting skill

{info} usable 1800 times a piece]],
		publishedAt = 1607936400,

		packages = {
			[1] = {
				amount = 1,
				price = 90,
				currency = 0,
				offerId = 40005126,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 37938,
	},
	[81] = {
		name = "Durable Exercise Club",
		description = [[<i>Use it to train your club fighting skill on an exercise dummy!</i>

  

{character}

{storeinbox}

{useicon} use it on an exercise dummy to train your club  fighting skill

{info} usable 1800 times a piece]],
		publishedAt = 1607936400,

		packages = {
			[1] = {
				amount = 1,
				price = 90,
				currency = 0,
				offerId = 40005124,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 37937,
	},
	[82] = {
		name = "Durable Exercise Axe",
		description = [[<i>Use it to train your axe fighting skill on an exercise dummy!</i>

  

{character}

{storeinbox}

{useicon} use it on an exercise dummy to train your axe fighting skill

{info} usable 1800 times a piece]],
		publishedAt = 1607936400,

		packages = {
			[1] = {
				amount = 1,
				price = 90,
				currency = 0,
				offerId = 40005122,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 37936,
	},
	[83] = {
		name = "Durable Exercise Sword",
		description = [[<i>Use it to train your sword fighting skill on an exercise dummy!</i>

  

{character}

{storeinbox}

{useicon} use it on an exercise dummy to train your sword fighting skill

{info} usable 1800 times a piece]],
		publishedAt = 1607936400,

		packages = {
			[1] = {
				amount = 1,
				price = 90,
				currency = 0,
				offerId = 40005114,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 37935,
	},
	[84] = {
		name = "Exercise Sword",
		description = [[<i>Use it to train your sword fighting skill on an exercise dummy!</i>
  
{character}
{storeinbox}
{useicon} use it on an exercise dummy to train your sword fighting skill
{info} usable 500 times a piece]],
		publishedAt = 1525762800,

		packages = {
			[1] = {
				amount = 1,
				price = 25,
				currency = 0,
				offerId = 7262851,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 31208,
	},
	[85] = {
		name = "Exercise Axe",
		description = [[<i>Use it to train your axe fighting skill on an exercise dummy!</i>
  
{character}
{storeinbox}
{useicon} use it on an exercise dummy to train your axe fighting skill
{info} usable 500 times a piece]],
		publishedAt = 1525762800,

		packages = {
			[1] = {
				amount = 1,
				price = 25,
				currency = 0,
				offerId = 7262853,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 31209,
	},
	[86] = {
		name = "Exercise Club",
		description = [[<i>Use it to train your club fighting skill on an exercise dummy!</i>
  
{character}
{storeinbox}
{useicon} use it on an exercise dummy to train your club  fighting skill
{info} usable 500 times a piece]],
		publishedAt = 1525762800,

		packages = {
			[1] = {
				amount = 1,
				price = 25,
				currency = 0,
				offerId = 7262855,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 31210,
	},
	[87] = {
		name = "Exercise Bow",
		description = [[<i>Use it to train your distance fighting skill on an exercise dummy!</i>
  
{character}
{storeinbox}
{useicon} use it on an exercise dummy to train your distance fighting skill
{info} usable 500 times a piece]],
		publishedAt = 1525762800,

		packages = {
			[1] = {
				amount = 1,
				price = 25,
				currency = 0,
				offerId = 7262857,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 31211,
	},
	[88] = {
		name = "Exercise Rod",
		description = [[<i>Use it to train your magic level on an exercise dummy!</i>
  
{character}
{storeinbox}
{useicon} use it on an exercise dummy to train your magic level
{info} usable 500 times a piece]],
		publishedAt = 1525762800,

		packages = {
			[1] = {
				amount = 1,
				price = 25,
				currency = 0,
				offerId = 7262859,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 31212,
	},
	[89] = {
		name = "Exercise Wand",
		description = [[<i>Use it to train your magic level on an exercise dummy!</i>
  
{character}
{storeinbox}
{useicon} use it on an exercise dummy to train your magic level
{info} usable 500 times a piece]],
		publishedAt = 1525762800,

		packages = {
			[1] = {
				amount = 1,
				price = 25,
				currency = 0,
				offerId = 7262861,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 31213,
	},
	[90] = {
		name = "Health Keg",
		description = [[<i>Fill up potions to restore your hit points no matter where you are!</i>

{character}
{vocationlevelcheck}
{storeinboxicon} potions created from this keg will be sent to your Store inbox and can only be stored there and in depot box
{info} usable 500 times a piece
{info} saves capacity because it's constant weight equals only 250 potions]],
		publishedAt = 1499155200,

		packages = {
			[1] = {
				amount = 1,
				price = 26,
				currency = 0,
				offerId = 7240138,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 28559,
	},
	[91] = {
		name = "Mana Keg",
		description = [[<i>Fill up potions to refill your mana no matter where you are!</i>

{character}
{vocationlevelcheck}
{storeinboxicon} potions created from this keg will be sent to your Store inbox and can only be stored there and in depot box
{info} usable 500 times a piece
{info} saves capacity because it's constant weight equals only 250 potions]],
		publishedAt = 1499155200,

		packages = {
			[1] = {
				amount = 1,
				price = 26,
				currency = 0,
				offerId = 7240148,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 28564,
	},
	[92] = {
		name = "Strong Mana Keg",
		description = [[<i>Fill up potions to refill your mana no matter where you are!</i>

{character}
{vocationlevelcheck}
{storeinboxicon} potions created from this keg will be sent to your Store inbox and can only be stored there and in depot box
{info} usable 500 times a piece
{info} saves capacity because it's constant weight equals only 250 potions]],
		publishedAt = 1499155200,

		packages = {
			[1] = {
				amount = 1,
				price = 43,
				currency = 0,
				offerId = 7240150,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 28565,
	},
	[93] = {
		name = "Health Potion",
		description = [[<i>Restores your character's hit points.</i>

{character}
{vocationlevelcheck}
{storeinbox}
{battlesign}
{capacity}]],
		publishedAt = 2206,

		packages = {
			[1] = {
				amount = 125,
				price = 6,
				currency = 0,
				offerId = 2201,
				status = 0,
			},
			[2] = {
				amount = 300,
				price = 11,
				currency = 0,
				offerId = 2206,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 7618,
	},
	[94] = {
		name = "Mana Potion",
		description = [[<i>Refills your character's mana.</i>

{character}
{vocationlevelcheck}
{storeinbox}
{battlesign}
{capacity}]],
		publishedAt = 2216,

		packages = {
			[1] = {
				amount = 125,
				price = 6,
				currency = 0,
				offerId = 2212,
				status = 0,
			},
			[2] = {
				amount = 300,
				price = 12,
				currency = 0,
				offerId = 2216,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 7620,
	},
	[95] = {
		name = "Strong Mana Potion",
		description = [[<i>Refills your character's mana.</i>

{character}
{vocationlevelcheck}
{storeinbox}
{battlesign}
{capacity}]],
		publishedAt = 3044,

		packages = {
			[1] = {
				amount = 100,
				price = 7,
				currency = 0,
				offerId = 2233,
				status = 0,
			},
			[2] = {
				amount = 250,
				price = 17,
				currency = 0,
				offerId = 3044,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 7589,
	},
	[96] = {
		name = "Animate Dead Rune",
		description = [[{character}
{storeinbox}
{vocationlevelcheck}
{battlesign}
{capacity}

<i>After a long time of research, the magicians of Edron succeeded in storing some life energy in a rune. When this energy was unleashed onto a body it was found that an undead creature arose that could be mentally controlled by the user of the rune. This rune is useful to create allies in combat.</i>]],
		publishedAt = 2317,

		packages = {
			[1] = {
				amount = 250,
				price = 75,
				currency = 0,
				offerId = 2317,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 2316,
	},
	[97] = {
		name = "Avalanche Rune",
		description = [[{character}
{storeinbox}
{vocationlevelcheck}
{battlesign}
{capacity}

<i>The ice damage which arises from this rune is a useful weapon in every battle but it comes in particularly handy if you fight against a horde of creatures dominated by the element fire.</i>]],
		publishedAt = 2325,

		packages = {
			[1] = {
				amount = 250,
				price = 12,
				currency = 0,
				offerId = 2325,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 2274,
	},
	[98] = {
		name = "Chameleon Rune",
		description = [[{character}
{storeinbox}
{vocationlevelcheck}
{battlesign}
{capacity}

<i>The metamorphosis caused by this rune is only superficial, and while casters who are using the rune can take on the exterior form of nearly any inanimate object, they will always retain their original smell and mental abilities. So there is no real practical use for this rune, making this largely a fun rune.</i>]],
		publishedAt = 2333,

		packages = {
			[1] = {
				amount = 250,
				price = 42,
				currency = 0,
				offerId = 2333,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 2291,
	},
	[99] = {
		name = "Convince Rune",
		description = [[{character}
{storeinbox}
{vocationlevelcheck}
{battlesign}
{capacity}

<i>Using this rune together with some mana, you can convince certain creatures. The needed amount of mana is determined by the power of the creature one wishes to convince, so the amount of mana to convince a rat is lower than that which is needed for an orc.</i>]],
		publishedAt = 2342,

		packages = {
			[1] = {
				amount = 250,
				price = 16,
				currency = 0,
				offerId = 2342,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 2290,
	},
	[100] = {
		name = "Cure Poison Rune",
		description = [[{character}
{storeinbox}
{vocationlevelcheck}
{battlesign}
{capacity}

<i>In the old days, many adventurers fell prey to poisonous creatures that were roaming the caves and forests. After many years of research druids finally succeeded in altering the cure poison spell so it could be bound to a rune. By using this rune it is possible to stop the effect of any known poison.</i>]],
		publishedAt = 2350,

		packages = {
			[1] = {
				amount = 250,
				price = 13,
				currency = 0,
				offerId = 2350,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 2266,
	},
	[101] = {
		name = "Disintegrate Rune",
		description = [[{character}
{storeinbox}
{vocationlevelcheck}
{battlesign}
{capacity}

<i>Nothing is worse than being cornered when fleeing from an enemy you just cannot beat, especially if the obstacles in your way are items you could easily remove if only you had the time! However, there is one reliable remedy: The Disintegrate rune will instantly destroy up to 500 movable items that are in your way, making room for a quick escape.</i>]],
		publishedAt = 2479,

		packages = {
			[1] = {
				amount = 250,
				price = 5,
				currency = 0,
				offerId = 2479,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 2310,
	},
	[102] = {
		name = "Energy Bomb Rune",
		description = [[{character}
{storeinbox}
{vocationlevelcheck}
{battlesign}
{capacity}

<i>Using the Energy Bomb rune will create a field of deadly energy that deals damage to all who carelessly step into it. Its area of effect is covering a full 9 square metres! Creatures that are caught in the middle of an Energy Bomb are frequently confused by the unexpected effect, and some may even stay in the field of deadly sparks for a while.</i>]],
		publishedAt = 2487,

		packages = {
			[1] = {
				amount = 250,
				price = 40,
				currency = 0,
				offerId = 2487,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 2262,
	},
	[103] = {
		name = "Energy Field Rune",
		description = [[{character}
{storeinbox}
{vocationlevelcheck}
{battlesign}
{capacity}

<i>This spell creates a limited barrier made up of crackling energy that will cause electrical damage to all those passing through. Since there are few creatures that are immune to the harmful effects of energy this spell is not to be underestimated.</i>]],
		publishedAt = 2496,

		packages = {
			[1] = {
				amount = 250,
				price = 8,
				currency = 0,
				offerId = 2496,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 2277,
	},
	[104] = {
		name = "Energy Wall Rune",
		description = [[{character}
{storeinbox}
{vocationlevelcheck}
{battlesign}
{capacity}

<i>Casting this spell generates a solid wall made up of magical energy. Walls made this way surpass any other magically created obstacle in width, so it is always a good idea to have an Energy Wall rune or two in one's pocket when travelling through the wilderness.</i>]],
		publishedAt = 2504,

		packages = {
			[1] = {
				amount = 250,
				price = 17,
				currency = 0,
				offerId = 2504,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 2279,
	},
	[105] = {
		name = "Explosion Rune",
		description = [[{character}
{storeinbox}
{vocationlevelcheck}
{battlesign}
{capacity}

<i>This rune must be aimed at areas rather than at specific creatures, so it is possible for explosions to be unleashed even if no targets are close at all. These explosions cause a considerable physical damage within a substantial blast radius.</i>]],
		publishedAt = 2512,

		packages = {
			[1] = {
				amount = 250,
				price = 6,
				currency = 0,
				offerId = 2512,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 2313,
	},
	[106] = {
		name = "Fireball Rune",
		description = [[{character}
{storeinbox}
{vocationlevelcheck}
{battlesign}
{capacity}

<i>When this rune is used a massive fiery ball is released which hits the aimed foe with immense power. It is especially effective against opponents of the element earth.</i>]],
		publishedAt = 2521,

		packages = {
			[1] = {
				amount = 250,
				price = 6,
				currency = 0,
				offerId = 2521,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 2302,
	},
	[107] = {
		name = "Fire Bomb Rune",
		description = [[{character}
{storeinbox}
{vocationlevelcheck}
{battlesign}
{capacity}

<i>This rune is a deadly weapon in the hands of the skilled user. On releasing it an area of 9 square metres is covered by searing flames that will scorch all those that are unfortunate enough to be caught in them. Worse, many monsters are confused by the unexpected blaze, and with a bit of luck a caster will even manage to trap his opponents by using the spell.</i>]],
		publishedAt = 2530,

		packages = {
			[1] = {
				amount = 250,
				price = 29,
				currency = 0,
				offerId = 2530,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 2305,
	},
	[108] = {
		name = "Fire Field Rune",
		description = [[{character}
{storeinbox}
{vocationlevelcheck}
{battlesign}
{capacity}

<i>When this rune is used a field of one square metre is covered by searing fire that will last for some minutes, gradually diminishing as the blaze wears down. As with all field spells, Fire Field is quite useful to block narrow passageways or to create large, connected barriers.</i>]],
		publishedAt = 2538,

		packages = {
			[1] = {
				amount = 250,
				price = 6,
				currency = 0,
				offerId = 2538,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 2301,
	},
	[109] = {
		name = "Fire Wall Rune",
		description = [[{character}
{storeinbox}
{vocationlevelcheck}
{battlesign}
{capacity}

<i>This rune offers reliable protection against all creatures that are afraid of fire. The exceptionally long duration of the spell as well as the possibility to form massive barriers or even protective circles out of fire walls make this a versatile, practical spell.</i>]],
		publishedAt = 2547,

		packages = {
			[1] = {
				amount = 250,
				price = 12,
				currency = 0,
				offerId = 2547,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 2303,
	},
	[110] = {
		name = "Great Fireball Rune",
		description = [[{character}
{storeinbox}
{vocationlevelcheck}
{battlesign}
{capacity}

<i>A shot of this rune affects a huge area - up to 37 square metres! It stands to reason that the Great Fireball is a favourite of most adventurers, as it is well suited both to hit whole crowds of monsters and individual targets that are difficult to hit because they are fast or hard to spot.</i>]],
		publishedAt = 2555,

		packages = {
			[1] = {
				amount = 250,
				price = 12,
				currency = 0,
				offerId = 2555,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 2304,
	},
	[111] = {
		name = "Icicle Rune",
		description = [[{character}
{storeinbox}
{vocationlevelcheck}
{battlesign}
{capacity}

<i>Particularly creatures determined by the element fire are vulnerable against this ice-cold rune. Being hit by the magic stored in this rune, an ice arrow seems to pierce the heart of the struck victim. The damage done by this rune is quite impressive which makes this a quite popular rune among mages.</i>]],
		publishedAt = 2563,

		packages = {
			[1] = {
				amount = 250,
				price = 6,
				currency = 0,
				offerId = 2563,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 2271,
	},
	[112] = {
		name = "Intense Healing Rune",
		description = [[{character}
{storeinbox}
{vocationlevelcheck}
{battlesign}
{capacity}

<i>This rune is commonly used by young adventurers who are not skilled enough to use the rune's stronger version. Also, since the rune's effectiveness is determined by the user's magic skill, it is still popular among experienced spell casters who use it to get effective healing magic at a cheap price.</i>]],
		publishedAt = 2572,

		packages = {
			[1] = {
				amount = 250,
				price = 19,
				currency = 0,
				offerId = 2572,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 2265,
	},
	[113] = {
		name = "Magic Wall Rune",
		description = [[{character}
{storeinbox}
{vocationlevelcheck}
{battlesign}
{capacity}

<i>This spell causes all particles that are contained in the surrounding air to quickly gather and contract until a solid wall is formed that covers one full square metre. The wall that is formed that way is impenetrable to any missiles or to light and no creature or character can walk through it. However, the wall will only last for a couple of seconds.</i>]],
		publishedAt = 2580,

		packages = {
			[1] = {
				amount = 250,
				price = 23,
				currency = 0,
				offerId = 2580,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 2293,
	},
	[114] = {
		name = "Poison Bomb Rune",
		description = [[{character}
{storeinbox}
{vocationlevelcheck}
{battlesign}
{capacity}

<i>This rune causes an area of 9 square metres to be contaminated with toxic gas that will poison anybody who is caught within it. Conceivable applications include the blocking of areas or the combat against fast-moving or invisible targets. Keep in mind, however, that there are a number of creatures that are immune to poison.</i>]],
		publishedAt = 2597,

		packages = {
			[1] = {
				amount = 250,
				price = 17,
				currency = 0,
				offerId = 2597,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 2286,
	},
	[115] = {
		name = "Poison Wall Rune",
		description = [[{character}
{storeinbox}
{vocationlevelcheck}
{battlesign}
{capacity}

<i>When this rune is used a wall of concentrated toxic fumes is created which inflicts a moderate poison on all those who are foolish enough to enter it. The effect is usually impressive enough to discourage monsters from doing so, although few of the stronger ones will hesitate if there is nothing but a poison wall between them and their dinner.</i>]],
		publishedAt = 2605,

		packages = {
			[1] = {
				amount = 250,
				price = 10,
				currency = 0,
				offerId = 2605,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 2289,
	},
	[116] = {
		name = "Soulfire Rune",
		description = [[{character}
{storeinbox}
{vocationlevelcheck}
{battlesign}
{capacity}

<i>Soulfire is an immensely evil spell as it directly targets a creature's very life essence. When the rune is used on a victim, its soul is temporarily moved out of its body, casting it down into the blazing fires of hell itself! Note that the experience and the mental strength of the caster influence the damage that is caused.</i>]],
		publishedAt = 2614,

		packages = {
			[1] = {
				amount = 250,
				price = 9,
				currency = 0,
				offerId = 2614,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 2308,
	},
	[117] = {
		name = "Stone Shower Rune",
		description = [[{character}
{storeinbox}
{vocationlevelcheck}
{battlesign}
{capacity}

<i>Particularly creatures with an affection to energy will suffer greatly from this rune filled with powerful earth damage. As the name already says, a shower of stones drums on the opponents of the rune user in an area up to 37 squares.</i>]],
		publishedAt = 2622,

		packages = {
			[1] = {
				amount = 250,
				price = 7,
				currency = 0,
				offerId = 2622,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 2288,
	},
	[118] = {
		name = "Sudden Death Rune",
		description = [[{character}
{storeinbox}
{vocationlevelcheck}
{battlesign}
{capacity}

<i>Nearly no other spell can compare to Sudden Death when it comes to sheer damage. For this reason it is immensely popular despite the fact that only a single target is affected. However, since the damage caused by the rune is of deadly nature, it is less useful against most undead creatures.</i>]],
		publishedAt = 2631,

		packages = {
			[1] = {
				amount = 250,
				price = 28,
				currency = 0,
				offerId = 2631,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 2268,
	},
	[119] = {
		name = "Thunderstorm Rune",
		description = [[{character}
{storeinbox}
{vocationlevelcheck}
{battlesign}
{capacity}

<i>Flashes filled with dangerous energy hit the rune user's opponent when this rune is being used. It is especially effective against ice dominated creatures. Covering up an area up to 37 squares, this rune is particularly useful when you meet a whole mob of opponents.</i>]],
		publishedAt = 2639,

		packages = {
			[1] = {
				amount = 250,
				price = 9,
				currency = 0,
				offerId = 2639,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 2315,
	},
	[120] = {
		name = "Ultimate Healing Rune",
		description = [[{character}
{storeinbox}
{vocationlevelcheck}
{battlesign}
{capacity}

<i>The coveted Ultimate Healing rune is an all-time favourite among all vocations. No other healing enchantments that are bound into runes can compare to its salutary effect.</i>]],
		publishedAt = 2647,

		packages = {
			[1] = {
				amount = 250,
				price = 35,
				currency = 0,
				offerId = 2647,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 2273,
	},
	[121] = {
		name = "Parade Horse",
		description = [[{character}
{speedboost}

<i>A seasoned warrior knows how to make an entry, and so does his faithful companion: Fully armored! Saddle up your impressive Jousting Horse to charge into battle in style, gallop into the arena on the back of your striking Tourney Horse, and ride your distinguished Parade Horse through the streets of Thais to show off your chivalrous qualities. With a horse in full barding, nobody will ever rain on your parade again.</i>]],
		publishedAt = 1661500800,

		packages = {
			[1] = {
				amount = 1,
				price = 870,
				currency = 0,
				offerId = 40016165,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1578,
	},
	[122] = {
		name = "Jousting Horse",
		description = [[{character}
{speedboost}

<i>A seasoned warrior knows how to make an entry, and so does his faithful companion: Fully armored! Saddle up your impressive Jousting Horse to charge into battle in style, gallop into the arena on the back of your striking Tourney Horse, and ride your distinguished Parade Horse through the streets of Thais to show off your chivalrous qualities. With a horse in full barding, nobody will ever rain on your parade again.</i>]],
		publishedAt = 1661500800,

		packages = {
			[1] = {
				amount = 1,
				price = 870,
				currency = 0,
				offerId = 40016166,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1579,
	},
	[123] = {
		name = "Tourney Horse",
		description = [[{character}
{speedboost}

<i>A seasoned warrior knows how to make an entry, and so does his faithful companion: Fully armored! Saddle up your impressive Jousting Horse to charge into battle in style, gallop into the arena on the back of your striking Tourney Horse, and ride your distinguished Parade Horse through the streets of Thais to show off your chivalrous qualities. With a horse in full barding, nobody will ever rain on your parade again.</i>]],
		publishedAt = 1661500800,

		packages = {
			[1] = {
				amount = 1,
				price = 870,
				currency = 0,
				offerId = 40016167,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1580,
	},
	[124] = {
		name = "Poppy Ibex",
		description = [[{character}
{speedboost}

<i>No mountain is too high, no wall too steep to climb for the agile Poppy, Mint and Cinnamon Ibex. They keep their balance on the thinnest of ledges, so you will never stumble, slip or go flying off the edges. Moreover, these sturdy fellows certainly know how to make an entrance as they dive down from the highest peaks and attack opponents with their impressive horns. And if you dare to call them a wild goat, they might kick you with their legs.</i>]],
		publishedAt = 1653638400,

		packages = {
			[1] = {
				amount = 1,
				price = 750,
				currency = 0,
				offerId = 40014248,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1526,
	},
	[125] = {
		name = "Mint Ibex",
		description = [[{character}
{speedboost}

<i>No mountain is too high, no wall too steep to climb for the agile Poppy, Mint and Cinnamon Ibex. They keep their balance on the thinnest of ledges, so you will never stumble, slip or go flying off the edges. Moreover, these sturdy fellows certainly know how to make an entrance as they dive down from the highest peaks and attack opponents with their impressive horns. And if you dare to call them a wild goat, they might kick you with their legs.</i>]],
		publishedAt = 1653638400,

		packages = {
			[1] = {
				amount = 1,
				price = 750,
				currency = 0,
				offerId = 40014249,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1527,
	},
	[126] = {
		name = "Cinnamon Ibex",
		description = [[{character}
{speedboost}

<i>No mountain is too high, no wall too steep to climb for the agile Poppy, Mint and Cinnamon Ibex. They keep their balance on the thinnest of ledges, so you will never stumble, slip or go flying off the edges. Moreover, these sturdy fellows certainly know how to make an entrance as they dive down from the highest peaks and attack opponents with their impressive horns. And if you dare to call them a wild goat, they might kick you with their legs.</i>]],
		publishedAt = 1653638400,

		packages = {
			[1] = {
				amount = 1,
				price = 750,
				currency = 0,
				offerId = 40014250,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1528,
	},
	[127] = {
		name = "Topaz Shrine",
		description = [[{character}
{speedboost}

<i>The famous Wandering Shrines were first raised by the nomad people of the Zaoan steppe. Their exceptional craftsmanship, combining architectonic features with living animals, is acknowledged even far beyond the continent of Zao. These spiritual companions will give you the opportunity to regain your strength during long and exciting journeys.</i>]],
		publishedAt = 1648198800,

		packages = {
			[1] = {
				amount = 1,
				price = 690,
				currency = 0,
				offerId = 40013954,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1491,
	},
	[128] = {
		name = "Jade Shrine",
		description = [[{character}
{speedboost}

<i>The famous Wandering Shrines were first raised by the nomad people of the Zaoan steppe. Their exceptional craftsmanship, combining architectonic features with living animals, is acknowledged even far beyond the continent of Zao. These spiritual companions will give you the opportunity to regain your strength during long and exciting journeys.</i>]],
		publishedAt = 1648198800,

		packages = {
			[1] = {
				amount = 1,
				price = 690,
				currency = 0,
				offerId = 40013955,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1492,
	},
	[129] = {
		name = "Obsidian Shrine",
		description = [[{character}
{speedboost}

<i>The famous Wandering Shrines were first raised by the nomad people of the Zaoan steppe. Their exceptional craftsmanship, combining architectonic features with living animals, is acknowledged even far beyond the continent of Zao. These spiritual companions will give you the opportunity to regain your strength during long and exciting journeys.</i>]],
		publishedAt = 1648198800,

		packages = {
			[1] = {
				amount = 1,
				price = 690,
				currency = 0,
				offerId = 40013956,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1493,
	},
	[130] = {
		name = "Emerald Raven",
		description = [[{character}
{speedboost}

<i>The origins of the Emerald Raven, Mystic Raven, and Radiant Raven are shrouded in darkness, as no written record nor tale told by even the most knowing storytellers mentions but a trace of them. Superstition surrounds them, as some see these gigantic birds as an echo of a long forgotten past, while others believe them to herald hitherto unknown events. What is clear is that they are highly intelligent beings which make great companions if they deem somebody worthy.</i>]],
		publishedAt = 1641373200,

		packages = {
			[1] = {
				amount = 1,
				price = 690,
				currency = 0,
				offerId = 40010707,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1453,
	},
	[131] = {
		name = "Mystic Raven",
		description = [[{character}
{speedboost}

<i>The origins of the Emerald Raven, Mystic Raven, and Radiant Raven are shrouded in darkness, as no written record nor tale told by even the most knowing storytellers mentions but a trace of them. Superstition surrounds them, as some see these gigantic birds as an echo of a long forgotten past, while others believe them to herald hitherto unknown events. What is clear is that they are highly intelligent beings which make great companions if they deem somebody worthy.</i>]],
		publishedAt = 1641373200,

		packages = {
			[1] = {
				amount = 1,
				price = 690,
				currency = 0,
				offerId = 40010708,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1454,
	},
	[132] = {
		name = "Radiant Raven",
		description = [[{character}
{speedboost}

<i>The origins of the Emerald Raven, Mystic Raven, and Radiant Raven are shrouded in darkness, as no written record nor tale told by even the most knowing storytellers mentions but a trace of them. Superstition surrounds them, as some see these gigantic birds as an echo of a long forgotten past, while others believe them to herald hitherto unknown events. What is clear is that they are highly intelligent beings which make great companions if they deem somebody worthy.</i>]],
		publishedAt = 1641373200,

		packages = {
			[1] = {
				amount = 1,
				price = 690,
				currency = 0,
				offerId = 40010709,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1455,
	},
	[133] = {
		name = "Rustwurm",
		description = [[{character}
{speedboost}

<i>The Bogwurm, Gloomwurm, and Rustwurm belong to a little known subset of the dragon family, and usually live out their lives in habitats far away from human interaction. Them being cunning hunters, and their keen sense of perception make these wurms great companions for whomever can locate and tame them.</i>]],
		publishedAt = 1632470400,

		packages = {
			[1] = {
				amount = 1,
				price = 870,
				currency = 0,
				offerId = 40010172,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1446,
	},
	[134] = {
		name = "Bogwurm",
		description = [[{character}
{speedboost}

<i>The Bogwurm, Gloomwurm, and Rustwurm belong to a little known subset of the dragon family, and usually live out their lives in habitats far away from human interaction. Them being cunning hunters, and their keen sense of perception make these wurms great companions for whomever can locate and tame them.</i>]],
		publishedAt = 1632470400,

		packages = {
			[1] = {
				amount = 1,
				price = 870,
				currency = 0,
				offerId = 40010173,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1447,
	},
	[135] = {
		name = "Gloomwurm",
		description = [[{character}
{speedboost}

<i>The Bogwurm, Gloomwurm, and Rustwurm belong to a little known subset of the dragon family, and usually live out their lives in habitats far away from human interaction. Them being cunning hunters, and their keen sense of perception make these wurms great companions for whomever can locate and tame them.</i>]],
		publishedAt = 1632470400,

		packages = {
			[1] = {
				amount = 1,
				price = 870,
				currency = 0,
				offerId = 40010174,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1448,
	},
	[136] = {
		name = "Hyacinth",
		description = [[{character}
{speedboost}

<i>Born from the depths of the forest, where flora and fauna intertwine in mysterious ways, the Floral Beast is a colourful creature that is sure to turn some heads. The Hyacinth, Peony, and Dandelion mount are loyal companions that will safely carry you through their natural habitat of the woods, or lands unknown to them.</i>]],
		publishedAt = 1624608000,

		packages = {
			[1] = {
				amount = 1,
				price = 750,
				currency = 0,
				offerId = 40008353,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1439,
	},
	[137] = {
		name = "Peony",
		description = [[{character}
{speedboost}

<i>Born from the depths of the forest, where flora and fauna intertwine in mysterious ways, the Floral Beast is a colourful creature that is sure to turn some heads. The Hyacinth, Peony, and Dandelion mount are loyal companions that will safely carry you through their natural habitat of the woods, or lands unknown to them.</i>]],
		publishedAt = 1624608000,

		packages = {
			[1] = {
				amount = 1,
				price = 750,
				currency = 0,
				offerId = 40008354,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1440,
	},
	[138] = {
		name = "Dandelion",
		description = [[{character}
{speedboost}

<i>Born from the depths of the forest, where flora and fauna intertwine in mysterious ways, the Floral Beast is a colourful creature that is sure to turn some heads. The Hyacinth, Peony, and Dandelion mount are loyal companions that will safely carry you through their natural habitat of the woods, or lands unknown to them.</i>]],
		publishedAt = 1624608000,

		packages = {
			[1] = {
				amount = 1,
				price = 750,
				currency = 0,
				offerId = 40008355,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1441,
	},
	[139] = {
		name = "Void Watcher",
		description = [[{character}
{speedboost}

<i>If you are looking for a vigilant and faithful companion, look no further! Glide through every realm and stare into the darkest abyss on the back of a Void Watcher. They already know everything about you anyway for they have been watching you from the shadows!</i>]],
		publishedAt = 1616749200,

		packages = {
			[1] = {
				amount = 1,
				price = 870,
				currency = 0,
				offerId = 40007357,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1389,
	},
	[140] = {
		name = "Rune Watcher",
		description = [[{character}
{speedboost}

<i>If you are looking for a vigilant and faithful companion, look no further! Glide through every realm and stare into the darkest abyss on the back of a Rune Watcher. They already know everything about you anyway for they have been watching you from the shadows!</i>]],
		publishedAt = 1616749200,

		packages = {
			[1] = {
				amount = 1,
				price = 870,
				currency = 0,
				offerId = 40007358,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1390,
	},
	[141] = {
		name = "Rift Watcher",
		description = [[{character}
{speedboost}

<i>If you are looking for a vigilant and faithful companion, look no further! Glide through every realm and stare into the darkest abyss on the back of a Rift Watcher. They already know everything about you anyway for they have been watching you from the shadows!</i>]],
		publishedAt = 1616749200,

		packages = {
			[1] = {
				amount = 1,
				price = 870,
				currency = 0,
				offerId = 40007359,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1391,
	},
	[142] = {
		name = "Merry Mammoth",
		description = [[{character}
{speedboost}

<i>The Festive Mammoth, Holiday Mammoth and Merry Mammoth are gentle giants with a massive appearance and impressive tusks, whose mission it is to deliver gifts all across the world. They are good-natured beings, spreading joy wherever they go, but you best not cross them - a mammoth never forgets.</i>]],
		publishedAt = 1607677200,

		packages = {
			[1] = {
				amount = 1,
				price = 750,
				currency = 0,
				offerId = 40006113,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1379,
	},
	[143] = {
		name = "Holiday Mammoth",
		description = [[{character}
{speedboost}

<i>The Festive Mammoth, Holiday Mammoth and Merry Mammoth are gentle giants with a massive appearance and impressive tusks, whose mission it is to deliver gifts all across the world. They are good-natured beings, spreading joy wherever they go, but you best not cross them - a mammoth never forgets.</i>]],
		publishedAt = 1607677200,

		packages = {
			[1] = {
				amount = 1,
				price = 750,
				currency = 0,
				offerId = 40006114,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1380,
	},
	[144] = {
		name = "Festive Mammoth",
		description = [[{character}
{speedboost}

<i>The Festive Mammoth, Holiday Mammoth and Merry Mammoth are gentle giants with a massive appearance and impressive tusks, whose mission it is to deliver gifts all across the world. They are good-natured beings, spreading joy wherever they go, but you best not cross them - a mammoth never forgets.</i>]],
		publishedAt = 1607677200,

		packages = {
			[1] = {
				amount = 1,
				price = 750,
				currency = 0,
				offerId = 40006115,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1381,
	},
	[145] = {
		name = "Cunning Hyaena",
		description = [[{character}
{speedboost}

<i>The Cunning Hyaena, Scruffy Hyaena and Voracious Hyaena are highly social animals and loyal companions to whomever is able to befriend them. Coming from sun-soaked places, they prefer a warm climate, but are able to cope in other environments as well.</i>]],
		publishedAt = 1595577600,

		packages = {
			[1] = {
				amount = 1,
				price = 750,
				currency = 0,
				offerId = 40001984,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1334,
	},
	[146] = {
		name = "Voracious Hyaena",
		description = [[{character}
{speedboost}

<i>The Cunning Hyaena, Scruffy Hyaena and Voracious Hyaena are highly social animals and loyal companions to whomever is able to befriend them. Coming from sun-soaked places, they prefer a warm climate, but are able to cope in other environments as well.</i>]],
		publishedAt = 1595577600,

		packages = {
			[1] = {
				amount = 1,
				price = 750,
				currency = 0,
				offerId = 40001983,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1333,
	},
	[147] = {
		name = "Scruffy Hyaena",
		description = [[{character}
{speedboost}

<i>The Cunning Hyaena, Scruffy Hyaena and Voracious Hyaena are highly social animals and loyal companions to whomever is able to befriend them. Coming from sun-soaked places, they prefer a warm climate, but are able to cope in other environments as well.</i>]],
		publishedAt = 1595577600,

		packages = {
			[1] = {
				amount = 1,
				price = 750,
				currency = 0,
				offerId = 40001982,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1335,
	},
	[148] = {
		name = "Eventide Nandu",
		description = [[{character}
{speedboost}

<i>These birds have a strong maternal instinct since their fledglings are completely dependent on their parents for protection. Do not expect them to abandon their brood only because they are carrying you around. In fact, if you were to separate them from their chick, the Savanna Ostrich, Coral Rhea and Eventide Nandu would turn into vicious beings, so don't even try it!</i>]],
		publishedAt = 1587625200,

		packages = {
			[1] = {
				amount = 1,
				price = 500,
				currency = 0,
				offerId = 40001507,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1311,
	},
	[149] = {
		name = "Coral Rhea",
		description = [[{character}
{speedboost}

<i>These birds have a strong maternal instinct since their fledglings are completely dependent on their parents for protection. Do not expect them to abandon their brood only because they are carrying you around. In fact, if you were to separate them from their chick, the Savanna Ostrich, Coral Rhea and Eventide Nandu would turn into vicious beings, so don't even try it!</i>]],
		publishedAt = 1587625200,

		packages = {
			[1] = {
				amount = 1,
				price = 500,
				currency = 0,
				offerId = 40001506,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1310,
	},
	[150] = {
		name = "Savanna Ostrich",
		description = [[{character}
{speedboost}

<i>These birds have a strong maternal instinct since their fledglings are completely dependent on their parents for protection. Do not expect them to abandon their brood only because they are carrying you around. In fact, if you were to separate them from their chick, the Savanna Ostrich, Coral Rhea and Eventide Nandu would turn into vicious beings, so don't even try it!</i>]],
		publishedAt = 1587625200,

		packages = {
			[1] = {
				amount = 1,
				price = 500,
				currency = 0,
				offerId = 40001505,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1309,
	},
	[151] = {
		name = "Snow Strider",
		description = [[{character}
{speedboost}

<i>A magical fire burns inside these wolves. Bred as the faithful guardians for an eccentric wizard's tower, these creatures make for loyal companions during your travels. While not originally intended for riding, their sturdy frame makes the Dawn Strayer, Dusk Pryer and Snow Strider suitable mounts.</i>]],
		publishedAt = 1580461200,

		packages = {
			[1] = {
				amount = 1,
				price = 870,
				currency = 0,
				offerId = 40001134,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1284,
	},
	[152] = {
		name = "Dusk Pryer",
		description = [[{character}
{speedboost}

<i>A magical fire burns inside these wolves. Bred as the faithful guardians for an eccentric wizard's tower, these creatures make for loyal companions during your travels. While not originally intended for riding, their sturdy frame makes the Dawn Strayer, Dusk Pryer and Snow Strider suitable mounts.</i>]],
		publishedAt = 1580461200,

		packages = {
			[1] = {
				amount = 1,
				price = 870,
				currency = 0,
				offerId = 40001133,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1285,
	},
	[153] = {
		name = "Dawn Strayer",
		description = [[{character}
{speedboost}

<i>A magical fire burns inside these wolves. Bred as the faithful guardians for an eccentric wizard's tower, these creatures make for loyal companions during your travels. While not originally intended for riding, their sturdy frame makes the Dawn Strayer, Dusk Pryer and Snow Strider suitable mounts.</i>]],
		publishedAt = 1580461200,

		packages = {
			[1] = {
				amount = 1,
				price = 870,
				currency = 0,
				offerId = 40001132,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1286,
	},
	[154] = {
		name = "Floating Augur",
		description = [[{character}
{speedboost}

<i>These creatures are Floating Savants whose mind has been warped and bent to focus their extraordinary mental capabilities on one single goal: to do their master's bidding. Instead of being filled with an endless pursuit of knowledge, their live is now one of continuous thralldom and serfhood. The Floating Sage, the Floating Scholar and the Floating Augur are at your disposal.</i>]],
		publishedAt = 1572598800,

		packages = {
			[1] = {
				amount = 1,
				price = 870,
				currency = 0,
				offerId = 40000290,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1266,
	},
	[155] = {
		name = "Floating Scholar",
		description = [[{character}
{speedboost}

<i>These creatures are Floating Savants whose mind has been warped and bent to focus their extraordinary mental capabilities on one single goal: to do their master's bidding. Instead of being filled with an endless pursuit of knowledge, their live is now one of continuous thralldom and serfhood. The Floating Sage, the Floating Scholar and the Floating Augur are at your disposal.</i>]],
		publishedAt = 1572598800,

		packages = {
			[1] = {
				amount = 1,
				price = 870,
				currency = 0,
				offerId = 40000288,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1265,
	},
	[156] = {
		name = "Floating Sage",
		description = [[{character}
{speedboost}

<i>These creatures are Floating Savants whose mind has been warped and bent to focus their extraordinary mental capabilities on one single goal: to do their master's bidding. Instead of being filled with an endless pursuit of knowledge, their live is now one of continuous thralldom and serfhood. The Floating Sage, the Floating Scholar and the Floating Augur are at your disposal.</i>]],
		publishedAt = 1572598800,

		packages = {
			[1] = {
				amount = 1,
				price = 870,
				currency = 0,
				offerId = 40000189,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1264,
	},
	[157] = {
		name = "Zaoan Badger",
		description = [[{character}
{speedboost}

<i>Badgers have been a staple of the world's fauna for a long time, and finally some daring souls have braved the challenge to tame some exceptional specimens - and succeeded! While the common badger you can encounter during your travels might seem like a rather unassuming creature, the Battle Badger, the Ether Badger, and the Zaoan Badger are fierce and mighty beasts, which are at your beck and call.</i>]],
		publishedAt = 1566547200,

		packages = {
			[1] = {
				amount = 1,
				price = 690,
				currency = 0,
				offerId = 7267415,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1249,
	},
	[158] = {
		name = "Ether Badger",
		description = [[{character}
{speedboost}

<i>Badgers have been a staple of the world's fauna for a long time, and finally some daring souls have braved the challenge to tame some exceptional specimens - and succeeded! While the common badger you can encounter during your travels might seem like a rather unassuming creature, the Battle Badger, the Ether Badger, and the Zaoan Badger are fierce and mighty beasts, which are at your beck and call.</i>]],
		publishedAt = 1566547200,

		packages = {
			[1] = {
				amount = 1,
				price = 690,
				currency = 0,
				offerId = 7267319,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1248,
	},
	[159] = {
		name = "Battle Badger",
		description = [[{character}
{speedboost}

<i>Badgers have been a staple of the world's fauna for a long time, and finally some daring souls have braved the challenge to tame some exceptional specimens - and succeeded! While the common badger you can encounter during your travels might seem like a rather unassuming creature, the Battle Badger, the Ether Badger, and the Zaoan Badger are fierce and mighty beasts, which are at your beck and call.</i>]],
		publishedAt = 1566547200,

		packages = {
			[1] = {
				amount = 1,
				price = 690,
				currency = 0,
				offerId = 7267317,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1247,
	},
	[160] = {
		name = "Nightmarish Crocovile",
		description = [[{character}
{speedboost}

<i>To the keen observer, the crocovile is clearly a relative of the crocodile, albeit their look suggests an even more aggressive nature. While it is true that the power of its massive and muscular body can not only crush enemies dead but also break through any gate like a battering ram, a crocovile is, above all, a steadfast companion showing unwavering loyalty to its owner.</i>]],
		publishedAt = 1558681200,

		packages = {
			[1] = {
				amount = 1,
				price = 750,
				currency = 0,
				offerId = 7266531,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1185,
	},
	[161] = {
		name = "Swamp Crocovile",
		description = [[{character}
{speedboost}

<i>To the keen observer, the crocovile is clearly a relative of the crocodile, albeit their look suggests an even more aggressive nature. While it is true that the power of its massive and muscular body can not only crush enemies dead but also break through any gate like a battering ram, a crocovile is, above all, a steadfast companion showing unwavering loyalty to its owner.</i>]],
		publishedAt = 1558681200,

		packages = {
			[1] = {
				amount = 1,
				price = 750,
				currency = 0,
				offerId = 7266530,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1184,
	},
	[162] = {
		name = "River Crocovile",
		description = [[{character}
{speedboost}

<i>To the keen observer, the crocovile is clearly a relative of the crocodile, albeit their look suggests an even more aggressive nature. While it is true that the power of its massive and muscular body can not only crush enemies dead but also break through any gate like a battering ram, a crocovile is, above all, a steadfast companion showing unwavering loyalty to its owner.</i>]],
		publishedAt = 1558681200,

		packages = {
			[1] = {
				amount = 1,
				price = 750,
				currency = 0,
				offerId = 7266529,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1183,
	},
	[163] = {
		name = "Cony Cart",
		description = [[{character}
{speedboost}

<i>Your lower back worsens with every trip you spend on the back of your mount and you are looking for a more comfortable alternative to travel through the lands? Say no more! The Cony Cart comes with two top-performing hares that never get tired thanks to the brand new and highly innovative propulsion technology. Just keep some back-up carrots in your pocket and you will be fine!</i>]],
		publishedAt = 1554451200,

		packages = {
			[1] = {
				amount = 1,
				price = 870,
				currency = 0,
				offerId = 7266518,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1181,
	},
	[164] = {
		name = "Bunny Dray",
		description = [[{character}
{speedboost}

<i>Your lower back worsens with every trip you spend on the back of your mount and you are looking for a more comfortable alternative to travel through the lands? Say no more! The Bunny Dray comes with two top-performing hares that never get tired thanks to the brand new and highly innovative propulsion technology. Just keep some back-up carrots in your pocket and you will be fine!</i>]],
		publishedAt = 1554451200,

		packages = {
			[1] = {
				amount = 1,
				price = 870,
				currency = 0,
				offerId = 7266516,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1180,
	},
	[165] = {
		name = "Rabbit Rickshaw",
		description = [[{character}
{speedboost}

<i>Your lower back worsens with every trip you spend on the back of your mount and you are looking for a more comfortable alternative to travel through the lands? Say no more! The Rabbit Rickshaw comes with two top-performing hares that never get tired thanks to the brand new and highly innovative propulsion technology. Just keep some back-up carrots in your pocket and you will be fine!</i>]],
		publishedAt = 1554451200,

		packages = {
			[1] = {
				amount = 1,
				price = 870,
				currency = 0,
				offerId = 7266426,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1179,
	},
	[166] = {
		name = "Festive Snowman",
		description = [[{character}
{speedboost}

<i>When the nights are getting longer and freezing wind brings driving snow into the land, snowmen rise and shine on every corner. Lately, a peaceful, arcane creature has found shelter in one of them and used its magical power to call the Festive Snowman into being. Wrap yourself up well and warmly and jump on the back of your new frosty companion.</i>]],
		publishedAt = 1546592400,

		packages = {
			[1] = {
				amount = 1,
				price = 900,
				currency = 0,
				offerId = 7266128,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1167,
	},
	[167] = {
		name = "Muffled Snowman",
		description = [[{character}
{speedboost}

<i>When the nights are getting longer and freezing wind brings driving snow into the land, snowmen rise and shine on every corner. Lately, a peaceful, arcane creature has found shelter in one of them and used its magical power to call the Muffled Snowman into being. Wrap yourself up well and warmly and jump on the back of your new frosty companion.</i>]],
		publishedAt = 1546592400,

		packages = {
			[1] = {
				amount = 1,
				price = 900,
				currency = 0,
				offerId = 7266041,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1168,
	},
	[168] = {
		name = "Caped Snowman",
		description = [[{character}
{speedboost}

<i>When the nights are getting longer and freezing wind brings driving snow into the land, snowmen rise and shine on every corner. Lately, a peaceful, arcane creature has found shelter in one of them and used its magical power to call the Caped Snowman into being. Wrap yourself up well and warmly and jump on the back of your new frosty companion.</i>]],
		publishedAt = 1546592400,

		packages = {
			[1] = {
				amount = 1,
				price = 900,
				currency = 0,
				offerId = 7266039,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1169,
	},
	[169] = {
		name = "Tawny Owl",
		description = [[{character}
{speedboost}

<i>Owls have always been a symbol of mystery, magic and wisdom in various mythologies and fairy tales. Having one of these enigmatic creatures of the night as a trustworthy companion provides you with a silent guide whose ever-watchful eyes will cut through the shadows, help you navigate the darkness and unravel great secrets.</i>]],
		publishedAt = 1538121600,

		packages = {
			[1] = {
				amount = 1,
				price = 870,
				currency = 0,
				offerId = 7265122,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1104,
	},
	[170] = {
		name = "Snowy Owl",
		description = [[{character}
{speedboost}

<i>Owls have always been a symbol of mystery, magic and wisdom in various mythologies and fairy tales. Having one of these enigmatic creatures of the night as a trustworthy companion provides you with a silent guide whose ever-watchful eyes will cut through the shadows, help you navigate the darkness and unravel great secrets.</i>]],
		publishedAt = 1538121600,

		packages = {
			[1] = {
				amount = 1,
				price = 870,
				currency = 0,
				offerId = 7265206,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1105,
	},
	[171] = {
		name = "Boreal Owl",
		description = [[{character}
{speedboost}

<i>Owls have always been a symbol of mystery, magic and wisdom in various mythologies and fairy tales. Having one of these enigmatic creatures of the night as a trustworthy companion provides you with a silent guide whose ever-watchful eyes will cut through the shadows, help you navigate the darkness and unravel great secrets.</i>]],
		publishedAt = 1538121600,

		packages = {
			[1] = {
				amount = 1,
				price = 870,
				currency = 0,
				offerId = 7265208,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1106,
	},
	[172] = {
		name = "Ebony Tiger",
		description = [[{character}
{speedboost}

<i>It is said that in ancient times, the sabre-tooth tiger was already used as a mount by elder warriors of Svargrond. As seafaring began to expand, this noble big cat was also transported to other regions. Influenced by the new environment and climatic changes, the fur of the Ebony Tiger has developed its extraordinary colouring over several generations.</i>]],
		publishedAt = 1529654400,

		packages = {
			[1] = {
				amount = 1,
				price = 750,
				currency = 0,
				offerId = 7264481,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1091,
	},
	[173] = {
		name = "Feral Tiger",
		description = [[{character}
{speedboost}

<i>It is said that in ancient times, the sabre-tooth tiger was already used as a mount by elder warriors of Svargrond. As seafaring began to expand, this noble big cat was also transported to other regions. Influenced by the new environment and climatic changes, the fur of the Feral Tiger has developed its extraordinary colouring over several generations.</i>]],
		publishedAt = 1529654400,

		packages = {
			[1] = {
				amount = 1,
				price = 750,
				currency = 0,
				offerId = 7264562,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1092,
	},
	[174] = {
		name = "Jungle Tiger",
		description = [[{character}
{speedboost}

<i>It is said that in ancient times, the sabre-tooth tiger was already used as a mount by elder warriors of Svargrond. As seafaring began to expand, this noble big cat was also transported to other regions. Influenced by the new environment and climatic changes, the fur of the Jungle Tiger has developed its extraordinary colouring over several generations.</i>]],
		publishedAt = 1529654400,

		packages = {
			[1] = {
				amount = 1,
				price = 750,
				currency = 0,
				offerId = 7264564,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1093,
	},
	[175] = {
		name = "Marsh Toad",
		description = [[{character}
{speedboost}

<i>For centuries, humans and monsters have dumped their garbage in the swamps around Venore. The combination of old, rusty weapons, stale mana and broken runes have turned some of the swamp dwellers into gigantic frogs. Benefit from those mutations and make the Marsh Toad a faithful mount for your adventures even beyond the bounds of the swamp.</i>]],
		publishedAt = 1522137600,

		packages = {
			[1] = {
				amount = 1,
				price = 690,
				currency = 0,
				offerId = 7256755,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1052,
	},
	[176] = {
		name = "Sanguine Frog",
		description = [[{character}
{speedboost}

<i>For centuries, humans and monsters have dumped their garbage in the swamps around Venore. The combination of old, rusty weapons, stale mana and broken runes have turned some of the swamp dwellers into gigantic frogs. Benefit from those mutations and make the Sanguine Frog a faithful mount for your adventures even beyond the bounds of the swamp.</i>]],
		publishedAt = 1522137600,

		packages = {
			[1] = {
				amount = 1,
				price = 690,
				currency = 0,
				offerId = 7256753,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1053,
	},
	[177] = {
		name = "Toxic Toad",
		description = [[{character}
{speedboost}

<i>For centuries, humans and monsters have dumped their garbage in the swamps around Venore. The combination of old, rusty weapons, stale mana and broken runes have turned some of the swamp dwellers into gigantic frogs. Benefit from those mutations and make the Toxic Toad a faithful mount for your adventures even beyond the bounds of the swamp.</i>]],
		publishedAt = 1522137600,

		packages = {
			[1] = {
				amount = 1,
				price = 690,
				currency = 0,
				offerId = 7256675,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1054,
	},
	[178] = {
		name = "Cranium Spider",
		description = [[{character}
{speedboost}

<i>It is said that the Cranium Spider was born long before Banor walked the earth. While its parents died in the war against the cruel hordes sent by Brog and Zathroth, their child survived by hiding in skulls of burned enemies. It never left its hiding spot and as it grew older, the skulls merged into its body. Now, it is fully-grown and thirsts for revenge.</i>]],
		publishedAt = 1510650000,

		packages = {
			[1] = {
				amount = 1,
				price = 690,
				currency = 0,
				offerId = 7252515,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1025,
	},
	[179] = {
		name = "Cave Tarantula",
		description = [[{character}
{speedboost}

<i>It is said that the Cave Tarantula was born long before Banor walked the earth. While its parents died in the war against the cruel hordes sent by Brog and Zathroth, their child survived by hiding in skulls of burned enemies. It never left its hiding spot and as it grew older, the skulls merged into its body. Now, it is fully-grown and thirsts for revenge.</i>]],
		publishedAt = 1510650000,

		packages = {
			[1] = {
				amount = 1,
				price = 690,
				currency = 0,
				offerId = 7252587,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1026,
	},
	[180] = {
		name = "Gloom Widow",
		description = [[{character}
{speedboost}

<i>It is said that the Gloom Widow was born long before Banor walked the earth. While its parents died in the war against the cruel hordes sent by Brog and Zathroth, their child survived by hiding in skulls of burned enemies. It never left its hiding spot and as it grew older, the skulls merged into its body. Now, it is fully-grown and thirsts for revenge.</i>]],
		publishedAt = 1510650000,

		packages = {
			[1] = {
				amount = 1,
				price = 690,
				currency = 0,
				offerId = 7252589,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1027,
	},
	[181] = {
		name = "Blazing Unicorn",
		description = [[{character}
{speedboost}

<i>The Blazing Unicorn lives in a deep rivalry with its cousin the Arctic Unicorn. Even though they were born in completely different areas, they somehow share the same bloodline. The eternal battle between fire and ice continues. Who will win? Crystal blue vs. tangerine! The choice is yours!</i>]],
		publishedAt = 1503648000,

		packages = {
			[1] = {
				amount = 1,
				price = 870,
				currency = 0,
				offerId = 7241368,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1017,
	},
	[182] = {
		name = "Arctic Unicorn",
		description = [[{character}
{speedboost}

<i>The Arctic Unicorn lives in a deep rivalry with its cousin the Blazing Unicorn. Even though they were born in completely different areas, they somehow share the same bloodline. The eternal battle between fire and ice continues. Who will win? Tangerine vs.crystal blue! The choice is yours!</i>]],
		publishedAt = 1503648000,

		packages = {
			[1] = {
				amount = 1,
				price = 870,
				currency = 0,
				offerId = 7241440,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1018,
	},
	[183] = {
		name = "Prismatic Unicorn",
		description = [[{character}
{speedboost}


<i>Legend has it that a mare and a stallion once reached the end of a rainbow and decided to stay there. Influenced by the mystical power of the rainbow, the mare gave birth to an exceptional foal: Not only the big, strong horn on its forehead but the unusual colouring of its hair makes the Prismatic Unicorn a unique mount in every respect.</i>]],
		publishedAt = 1503648000,

		packages = {
			[1] = {
				amount = 1,
				price = 870,
				currency = 0,
				offerId = 7241442,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1019,
	},
	[184] = {
		name = "Armoured War Horse",
		description = [[{character}
{speedboost}

<i>The Armoured War Horse is a dangerous black beauty! When you see its threatening, blood-red eyes coming towards you, you'll know trouble is on its way. Protected by its heavy armour plates, the warhorse is the perfect partner for dangerous hunting sessions and excessive enemy slaughtering.</i>]],
		publishedAt = 1506672000,

		packages = {
			[1] = {
				amount = 1,
				price = 870,
				currency = 0,
				offerId = 7237091,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 426,
	},
	[185] = {
		name = "Shadow Draptor",
		description = [[{character}
{speedboost}

<i>A wild, ancient creature, which had been hiding in the depths of the shadows for a very long time, has been spotted again! The almighty Shadow Draptor has returned and only the bravest adventurers can control such a beast!</i>]],
		publishedAt = 1506672000,

		packages = {
			[1] = {
				amount = 1,
				price = 870,
				currency = 0,
				offerId = 7237093,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 427,
	},
	[186] = {
		name = "Steelbeak",
		description = [[{character}
{speedboost}

<i>Forged by only the highest skilled blacksmiths in the depths of Kazordoon's furnaces, a wild animal made out of the finest steel arose from glowing embers and blazing heat. Protected by its impenetrable armour, the Steelbeak is ready to accompany its master on every battleground.</i>]],
		publishedAt = 1501228800,

		packages = {
			[1] = {
				amount = 1,
				price = 870,
				currency = 0,
				offerId = 7237095,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 522,
	},
	[187] = {
		name = "Crimson Ray",
		description = [[{character}
{speedboost}

<i>Have you ever dreamed of gliding through the air on the back of a winged creature? With its deep red wings, the majestic Crimson Ray is a worthy mount for courageous heroes. Feel like a king on its back as you ride into your next adventure.</i>]],
		publishedAt = 1501228800,

		packages = {
			[1] = {
				amount = 1,
				price = 870,
				currency = 0,
				offerId = 7237097,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 521,
	},
	[188] = {
		name = "Jungle Saurian",
		description = [[{character}
{speedboost}

<i>Thousands of years ago, its ancestors ruled the world. The Jungle Saurian likes to hide in dense wood and overturned trees.</i>]],
		publishedAt = 1494576000,

		packages = {
			[1] = {
				amount = 1,
				price = 750,
				currency = 0,
				offerId = 7236055,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 959,
	},
	[189] = {
		name = "Ember Saurian",
		description = [[{character}
{speedboost}


<i>Thousands of years ago, its ancestors ruled the world. The Ember Saurian has been spotted in a sea of flames and fire deep down in the depths of Kazordoon.</i>]],
		publishedAt = 1494576000,

		packages = {
			[1] = {
				amount = 1,
				price = 750,
				currency = 0,
				offerId = 7236057,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 960,
	},
	[190] = {
		name = "Lagoon Saurian",
		description = [[{character}
{speedboost}


<i>Thousands of years ago, its ancestors ruled the world. The Lagoon Saurian feels most comfortable in torrential rivers and behind dangerous waterfalls.</i>]],
		publishedAt = 1494576000,

		packages = {
			[1] = {
				amount = 1,
				price = 750,
				currency = 0,
				offerId = 7236059,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 961,
	},
	[191] = {
		name = "Gold Sphinx",
		description = [[{character}
{speedboost}

<i>Ride a Gold Sphinx on your way through ancient chambers and tombs and have a loyal friend by your side while fighting countless mummies and other creatures.</i>]],
		publishedAt = 1490346000,

		packages = {
			[1] = {
				amount = 1,
				price = 750,
				currency = 0,
				offerId = 36178543,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 950,
	},
	[192] = {
		name = "Emerald Sphinx",
		description = [[{character}
{speedboost}

<i>Ride an Emerald Sphinx on your way through ancient chambers and tombs and have a loyal friend by your side while fighting countless mummies and other creatures.</i>]],
		publishedAt = 1490346000,

		packages = {
			[1] = {
				amount = 1,
				price = 750,
				currency = 0,
				offerId = 36178545,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 951,
	},
	[193] = {
		name = "Shadow Sphinx",
		description = [[{character}
{speedboost}

<i>Ride a Shadow Sphinx on your way through ancient chambers and tombs and have a loyal friend by your side while fighting countless mummies and other creatures.</i>]],
		publishedAt = 1490346000,

		packages = {
			[1] = {
				amount = 1,
				price = 750,
				currency = 0,
				offerId = 36178547,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 952,
	},
	[194] = {
		name = "Jackalope",
		description = [[{character}
{speedboost}

<i>Do you like fluffy bunnies but think they are too small? Do you admire the majesty of stags and their antlers but are afraid of their untameable wilderness? Do not worry, the mystic creature Jackalope consolidates the best qualities of both animals. Hop on its backs and enjoy the ride.</i>]],
		publishedAt = 1483686000,

		packages = {
			[1] = {
				amount = 1,
				price = 870,
				currency = 0,
				offerId = 4348,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 905,
	},
	[195] = {
		name = "Dreadhare",
		description = [[{character}
{speedboost}

<i>Do you like fluffy bunnies but think they are too small? Do you admire the majesty of stags and their antlers but are afraid of their untameable wilderness? Do not worry, the mystic creature Dreadhare consolidates the best qualities of both animals. Hop on its backs and enjoy the ride.</i>]],
		publishedAt = 1483686000,

		packages = {
			[1] = {
				amount = 1,
				price = 870,
				currency = 0,
				offerId = 4363,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 907,
	},
	[196] = {
		name = "Wolpertinger",
		description = [[{character}
{speedboost}

<i>Do you like fluffy bunnies but think they are too small? Do you admire the majesty of stags and their antlers but are afraid of their untameable wilderness? Do not worry, the mystic creature Wolpertinger consolidates the best qualities of both animals. Hop on its backs and enjoy the ride.</i>]],
		publishedAt = 1483686000,

		packages = {
			[1] = {
				amount = 1,
				price = 870,
				currency = 0,
				offerId = 4378,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 906,
	},
	[197] = {
		name = "Ivory Fang",
		description = [[{character}
{speedboost}

<i>Incredible strength and smartness, an irrepressible will to survive, passionately hunting in groups. If these attributes apply to your character, we have found the perfect partner for you. Have a proper look at Ivory Fang, which stands loyally by its master's side in every situation. It is time to become the leader of the wolf pack!</i>]],
		publishedAt = 1477036800,

		packages = {
			[1] = {
				amount = 1,
				price = 750,
				currency = 0,
				offerId = 4005,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 901,
	},
	[198] = {
		name = "Shadow Claw",
		description = [[{character}
{speedboost}

<i>Incredible strength and smartness, an irrepressible will to survive, passionately hunting in groups. If these attributes apply to your character, we have found the perfect partner for you. Have a proper look at Shadow Claw, which stands loyally by its master's side in every situation. It is time to become the leader of the wolf pack!</i>]],
		publishedAt = 1477036800,

		packages = {
			[1] = {
				amount = 1,
				price = 750,
				currency = 0,
				offerId = 4019,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 902,
	},
	[199] = {
		name = "Snow Pelt",
		description = [[{character}
{speedboost}

<i>Incredible strength and smartness, an irrepressible will to survive, passionately hunting in groups. If these attributes apply to your character, we have found the perfect partner for you. Have a proper look at Snow Pelt, which stands loyally by its master's side in every situation. It is time to become the leader of the wolf pack!</i>]],
		publishedAt = 1477036800,

		packages = {
			[1] = {
				amount = 1,
				price = 750,
				currency = 0,
				offerId = 4034,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 903,
	},
	[200] = {
		name = "Swamp Snapper",
		description = [[{character}
{speedboost}

<i>You are intrigued by tortoises and would love to throne on a tortoise shell when travelling the wilderness? The Swamp Snapper might become your new trustworthy companion then, which will transport you safely and even carry you during combat.</i>]],
		publishedAt = 3190,

		packages = {
			[1] = {
				amount = 1,
				price = 690,
				currency = 0,
				offerId = 3190,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 886,
	},
	[201] = {
		name = "Mould Shell",
		description = [[{character}
{speedboost}

<i>You are intrigued by tortoises and would love to throne on a tortoise shell when travelling the wilderness? The Mould Shell might become your new trustworthy companion then, which will transport you safely and even carry you during combat.</i>]],
		publishedAt = 3204,

		packages = {
			[1] = {
				amount = 1,
				price = 690,
				currency = 0,
				offerId = 3204,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 887,
	},
	[202] = {
		name = "Reed Lurker",
		description = [[{character}
{speedboost}

<i>You are intrigued by tortoises and would love to throne on a tortoise shell when travelling the wilderness? The Reed Lurker might become your new trustworthy companion then, which will transport you safely and even carry you during combat.</i>]],
		publishedAt = 3218,

		packages = {
			[1] = {
				amount = 1,
				price = 690,
				currency = 0,
				offerId = 3218,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 888,
	},
	[203] = {
		name = "Bloodcurl",
		description = [[{character}
{speedboost}

<i>You are fascinated by insectoid creatures and can picture yourself riding one during combat or just for travelling? The Bloodcurl will carry you through the wilderness with ease.</i>]],
		publishedAt = 1690,

		packages = {
			[1] = {
				amount = 1,
				price = 750,
				currency = 0,
				offerId = 1690,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 869,
	},
	[204] = {
		name = "Leafscuttler",
		description = [[{character}
{speedboost}

<i>You are fascinated by insectoid creatures and can picture yourself riding one during combat or just for travelling? The Leafscuttler will carry you through the wilderness with ease.</i>]],
		publishedAt = 1703,

		packages = {
			[1] = {
				amount = 1,
				price = 750,
				currency = 0,
				offerId = 1703,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 870,
	},
	[205] = {
		name = "Mouldpincer",
		description = [[{character}
{speedboost}

<i>You are fascinated by insectoid creatures and can picture yourself riding one during combat or just for travelling? The Mouldpincer will carry you through the wilderness with ease.</i>]],
		publishedAt = 1716,

		packages = {
			[1] = {
				amount = 1,
				price = 750,
				currency = 0,
				offerId = 1716,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 868,
	},
	[206] = {
		name = "Nightdweller",
		description = [[{character}
{speedboost}

<i>If you are more of an imp than an angel, you may prefer riding out on a Nightdweller to scare fellows on their festive strolls. Its devilish mask, claw-like hands and sharp hooves makes it the perfect companion for any daring adventurer who likes to stand out.</i>]],
		publishedAt = 1558,

		packages = {
			[1] = {
				amount = 1,
				price = 870,
				currency = 0,
				offerId = 1558,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 849,
	},
	[207] = {
		name = "Frostflare",
		description = [[{character}
{speedboost}

<i>If you are more of an imp than an angel, you may prefer riding out on a Frostflare to scare fellows on their festive strolls. Its devilish mask, claw-like hands and sharp hooves makes it the perfect companion for any daring adventurer who likes to stand out.</i>]],
		publishedAt = 1570,

		packages = {
			[1] = {
				amount = 1,
				price = 870,
				currency = 0,
				offerId = 1570,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 850,
	},
	[208] = {
		name = "Cinderhoof",
		description = [[{character}
{speedboost}

<i>If you are more of an imp than an angel, you may prefer riding out on a Cinderhoof to scare fellows on their festive strolls. Its devilish mask, claw-like hands and sharp hooves makes it the perfect companion for any daring adventurer who likes to stand out.</i>]],
		publishedAt = 1583,

		packages = {
			[1] = {
				amount = 1,
				price = 870,
				currency = 0,
				offerId = 1583,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 851,
	},
	[209] = {
		name = "Slagsnare",
		description = [[{character}
{speedboost}

<i>The Slagsnare has external characteristics of different breeds. It is assumed that his brain is also composed of many different species, which makes it completely unpredictable. Only few have managed to approach this creature unharmed and only the best could tame it.</i>]],
		publishedAt = 1430,

		packages = {
			[1] = {
				amount = 1,
				price = 780,
				currency = 0,
				offerId = 1430,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 761,
	},
	[210] = {
		name = "Nightstinger",
		description = [[{character}
{speedboost}

<i>The Nightstinger has external characteristics of different breeds. It is assumed that his brain is also composed of many different species, which makes it completely unpredictable. Only few have managed to approach this creature unharmed and only the best could tame it.</i>]],
		publishedAt = 1442,

		packages = {
			[1] = {
				amount = 1,
				price = 780,
				currency = 0,
				offerId = 1442,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 762,
	},
	[211] = {
		name = "Razorcreep",
		description = [[{character}
{speedboost}

<i>The Razorcreep has external characteristics of different breeds. It is assumed that his brain is also composed of many different species, which makes it completely unpredictable. Only few have managed to approach this creature unharmed and only the best could tame it.</i>]],
		publishedAt = 1454,

		packages = {
			[1] = {
				amount = 1,
				price = 780,
				currency = 0,
				offerId = 1454,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 763,
	},
	[212] = {
		name = "Gorongra",
		description = [[{character}
{speedboost}

<i>Get yourself a mighty travelling companion with broad shoulders and a gentle heart. Gorongra is a physically imposing creature that is much more peaceful than its relatives, Tiquanda's wild kongras, and will carry you safely wherever you ask it to go.</i>]],
		publishedAt = 967,

		packages = {
			[1] = {
				amount = 1,
				price = 720,
				currency = 0,
				offerId = 967,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 738,
	},
	[213] = {
		name = "Noctungra",
		description = [[{character}
{speedboost}

<i>Get yourself a mighty travelling companion with broad shoulders and a gentle heart. Noctungra is a physically imposing creature that is much more peaceful than its relatives, Tiquanda's wild kongras, and will carry you safely wherever you ask it to go.</i>]],
		publishedAt = 979,

		packages = {
			[1] = {
				amount = 1,
				price = 720,
				currency = 0,
				offerId = 979,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 739,
	},
	[214] = {
		name = "Silverneck",
		description = [[{character}
{speedboost}

<i>Get yourself a mighty travelling companion with broad shoulders and a gentle heart. Silverneck is a physically imposing creature that is much more peaceful than its relatives, Tiquanda's wild kongras, and will carry you safely wherever you ask it to go.</i>]],
		publishedAt = 990,

		packages = {
			[1] = {
				amount = 1,
				price = 720,
				currency = 0,
				offerId = 990,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 740,
	},
	[215] = {
		name = "Sea Devil",
		description = [[{character}
{speedboost}

<i>If the Sea Devil moves its fins, it generates enough air pressure that it can even float over land. Its numerous eyes allow it to quickly detect dangers even in confusing situations and eliminate them with one powerful bite. If you watch your fingers, you are going to be good friends.</i>]],
		publishedAt = 348,

		packages = {
			[1] = {
				amount = 1,
				price = 570,
				currency = 0,
				offerId = 348,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 734,
	},
	[216] = {
		name = "Coralripper",
		description = [[{character}
{speedboost}

<i>If the Coralripper moves its fins, it generates enough air pressure that it can even float over land. Its numerous eyes allow it to quickly detect dangers even in confusing situations and eliminate them with one powerful bite. If you watch your fingers, you are going to be good friends.</i>]],
		publishedAt = 353,

		packages = {
			[1] = {
				amount = 1,
				price = 570,
				currency = 0,
				offerId = 353,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 735,
	},
	[217] = {
		name = "Plumfish",
		description = [[{character}
{speedboost}

<i>If the Plumfish moves its fins, it generates enough air pressure that it can even float over land. Its numerous eyes allow it to quickly detect dangers even in confusing situations and eliminate them with one powerful bite. If you watch your fingers, you are going to be good friends.</i>]],
		publishedAt = 358,

		packages = {
			[1] = {
				amount = 1,
				price = 570,
				currency = 0,
				offerId = 358,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 736,
	},
	[218] = {
		name = "Flitterkatzen",
		description = [[{character}
{speedboost}

<i>Rumour has it that many years ago elder witches had gathered to hold a magical feast high up in the mountains. They had crossbred Flitterkatzen to easily conquer rocky canyons and deep valleys. Nobody knows what happened on their way up but only the mount has been seen ever since.</i>]],
		publishedAt = 326,

		packages = {
			[1] = {
				amount = 1,
				price = 870,
				currency = 0,
				offerId = 326,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 726,
	},
	[219] = {
		name = "Venompaw",
		description = [[{character}
{speedboost}

<i>Rumour has it that many years ago elder witches had gathered to hold a magical feast high up in the mountains. They had crossbred Venompaw to easily conquer rocky canyons and deep valleys. Nobody knows what happened on their way up but only the mount has been seen ever since.</i>]],
		publishedAt = 331,

		packages = {
			[1] = {
				amount = 1,
				price = 870,
				currency = 0,
				offerId = 331,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 727,
	},
	[220] = {
		name = "Batcat",
		description = [[{character}
{speedboost}

<i>Rumour has it that many years ago elder witches had gathered to hold a magical feast high up in the mountains. They had crossbred Batcat to easily conquer rocky canyons and deep valleys. Nobody knows what happened on their way up but only the mount has been seen ever since.</i>]],
		publishedAt = 336,

		packages = {
			[1] = {
				amount = 1,
				price = 870,
				currency = 0,
				offerId = 336,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 728,
	},
	[221] = {
		name = "Ringtail Waccoon",
		description = [[{character}
{speedboost}

<i>Waccoons are cuddly creatures that love nothing more than to be petted and snuggled! Share a hug, ruffle the fur of the Ringtail Waccoon and scratch it behind its ears to make it happy.</i>]],
		publishedAt = 303,

		packages = {
			[1] = {
				amount = 1,
				price = 750,
				currency = 0,
				offerId = 303,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 691,
	},
	[222] = {
		name = "Night Waccoon",
		description = [[{character}
{speedboost}

<i>Waccoons are cuddly creatures that love nothing more than to be petted and snuggled! Share a hug, ruffle the fur of the Night Waccoon and scratch it behind its ears to make it happy.</i>]],
		publishedAt = 308,

		packages = {
			[1] = {
				amount = 1,
				price = 750,
				currency = 0,
				offerId = 308,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 692,
	},
	[223] = {
		name = "Emerald Waccoon",
		description = [[{character}
{speedboost}

<i>Waccoons are cuddly creatures that love nothing more than to be petted and snuggled! Share a hug, ruffle the fur of the Emerald Waccoon and scratch it behind its ears to make it happy.</i>]],
		publishedAt = 313,

		packages = {
			[1] = {
				amount = 1,
				price = 750,
				currency = 0,
				offerId = 313,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 693,
	},
	[224] = {
		name = "Flying Divan",
		description = [[{character}
{speedboost}


<i>The Flying Divan is the perfect mount for those who are too busy to take care of an animal mount or simply like to travel on a beautiful, magic hand-woven carpet.</i>]],
		publishedAt = 281,

		packages = {
			[1] = {
				amount = 1,
				price = 900,
				currency = 0,
				offerId = 281,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 688,
	},
	[225] = {
		name = "Magic Carpet",
		description = [[{character}
{speedboost}


<i>The Magic Carpet is the perfect mount for those who are too busy to take care of an animal mount or simply like to travel on a beautiful, magic hand-woven carpet.</i>]],
		publishedAt = 289,

		packages = {
			[1] = {
				amount = 1,
				price = 900,
				currency = 0,
				offerId = 289,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 689,
	},
	[226] = {
		name = "Floating Kashmir",
		description = [[{character}
{speedboost}


<i>The Floating Kashmir is the perfect mount for those who are too busy to take care of an animal mount or simply like to travel on a beautiful, magic hand-woven carpet.</i>]],
		publishedAt = 296,

		packages = {
			[1] = {
				amount = 1,
				price = 900,
				currency = 0,
				offerId = 296,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 690,
	},
	[227] = {
		name = "Shadow Hart",
		description = [[{character}
{speedboost}

<i>Treat your character to a new travelling companion with a gentle nature and an impressive antler: The noble Shadow Hart will carry you through the deepest snow.</i>]],
		publishedAt = 259,

		packages = {
			[1] = {
				amount = 1,
				price = 660,
				currency = 0,
				offerId = 259,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 685,
	},
	[228] = {
		name = "Black Stag",
		description = [[{character}
{speedboost}

<i>Treat your character to a new travelling companion with a gentle nature and an impressive antler: The noble Black Stag will carry you through the deepest snow.</i>]],
		publishedAt = 266,

		packages = {
			[1] = {
				amount = 1,
				price = 660,
				currency = 0,
				offerId = 266,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 686,
	},
	[229] = {
		name = "Emperor Deer",
		description = [[{character}
{speedboost}

<i>Treat your character to a new travelling companion with a gentle nature and an impressive antler: The noble Emperor Deer will carry you through the deepest snow.</i>]],
		publishedAt = 274,

		packages = {
			[1] = {
				amount = 1,
				price = 660,
				currency = 0,
				offerId = 274,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 687,
	},
	[230] = {
		name = "Tundra Rambler",
		description = [[{character}
{speedboost}

<i>With its thick, shaggy hair, the Tundra Rambler will keep you warm even in the chilly climate of the Ice Islands. Due to its calm and peaceful nature, it is not letting itself getting worked up easily.</i>]],
		publishedAt = 237,

		packages = {
			[1] = {
				amount = 1,
				price = 750,
				currency = 0,
				offerId = 237,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 672,
	},
	[231] = {
		name = "Highland Yak",
		description = [[{character}
{speedboost}

<i>With its thick, shaggy hair, the Highland Yak will keep you warm even in the chilly climate of the Ice Islands. Due to its calm and peaceful nature, it is not letting itself getting worked up easily.</i>]],
		publishedAt = 244,

		packages = {
			[1] = {
				amount = 1,
				price = 750,
				currency = 0,
				offerId = 244,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 673,
	},
	[232] = {
		name = "Glacier Vagabond",
		description = [[{character}
{speedboost}

<i>With its thick, shaggy hair, the Glacier Vagabond will keep you warm even in the chilly climate of the Ice Islands. Due to its calm and peaceful nature, it is not letting itself getting worked up easily.</i>]],
		publishedAt = 252,

		packages = {
			[1] = {
				amount = 1,
				price = 750,
				currency = 0,
				offerId = 252,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 674,
	},
	[233] = {
		name = "Golden Dragonfly",
		description = [[{character}
{speedboost}

<i>If you are more interested in the achievements of science, you may enjoy a ride on the Golden Dragonfly, one of the new insect-like flying machines. Even if you do not move around, the wings of these unusual vehicles are always in motion.</i>]],
		publishedAt = 215,

		packages = {
			[1] = {
				amount = 1,
				price = 600,
				currency = 0,
				offerId = 215,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 669,
	},
	[234] = {
		name = "Steel Bee",
		description = [[{character}
{speedboost}

<i>If you are more interested in the achievements of science, you may enjoy a ride on the Steel Bee, one of the new insect-like flying machines. Even if you do not move around, the wings of these unusual vehicles are always in motion.</i>]],
		publishedAt = 222,

		packages = {
			[1] = {
				amount = 1,
				price = 600,
				currency = 0,
				offerId = 222,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 670,
	},
	[235] = {
		name = "Copper Fly",
		description = [[{character}
{speedboost}

<i>If you are more interested in the achievements of science, you may enjoy a ride on the Copper Fly, one of the new insect-like flying machines. Even if you do not move around, the wings of these unusual vehicles are always in motion.</i>]],
		publishedAt = 229,

		packages = {
			[1] = {
				amount = 1,
				price = 600,
				currency = 0,
				offerId = 229,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 671,
	},
	[236] = {
		name = "Doombringer",
		description = [[{character}
{speedboost}

<i>Once captured and held captive by a mad hunter, the Doombringer is the result of sick experiments. Fed only with demon dust and concentrated demonic blood it had to endure a dreadful transformation. The demonic blood that is now running through its veins, however, provides it with incredible strength and endurance.</i>]],
		publishedAt = 192,

		packages = {
			[1] = {
				amount = 1,
				price = 780,
				currency = 0,
				offerId = 192,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 644,
	},
	[237] = {
		name = "Woodland Prince",
		description = [[{character}
{speedboost}

<i>Once captured and held captive by a mad hunter, the Woodland Prince is the result of sick experiments. Fed only with demon dust and concentrated demonic blood it had to endure a dreadful transformation. The demonic blood that is now running through its veins, however, provides it with incredible strength and endurance.</i>]],
		publishedAt = 200,

		packages = {
			[1] = {
				amount = 1,
				price = 780,
				currency = 0,
				offerId = 200,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 647,
	},
	[238] = {
		name = "Hailstorm Fury",
		description = [[{character}
{speedboost}

<i>Once captured and held captive by a mad hunter, the Hailstorm Fury is the result of sick experiments. Fed only with demon dust and concentrated demonic blood it had to endure a dreadful transformation. The demonic blood that is now running through its veins, however, provides it with incredible strength and endurance.</i>]],
		publishedAt = 207,

		packages = {
			[1] = {
				amount = 1,
				price = 780,
				currency = 0,
				offerId = 207,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 648,
	},
	[239] = {
		name = "Siegebreaker",
		description = [[{character}
{speedboost}

<i>The Siegebreaker is out searching for the best bamboo. Its heavy armour allows it to visit even the most dangerous places. Treat it nicely with its favourite food from time to time and it will become a loyal partner.</i>]],
		publishedAt = 154,

		packages = {
			[1] = {
				amount = 1,
				price = 690,
				currency = 0,
				offerId = 154,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 649,
	},
	[240] = {
		name = "Poisonbane",
		description = [[{character}
{speedboost}

<i>The Poisonbane is out searching for the best bamboo. Its heavy armour allows it to visit even the most dangerous places. Treat it nicely with its favourite food from time to time and it will become a loyal partner.</i>]],
		publishedAt = 161,

		packages = {
			[1] = {
				amount = 1,
				price = 690,
				currency = 0,
				offerId = 161,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 650,
	},
	[241] = {
		name = "Blackpelt",
		description = [[{character}
{speedboost}

<i>The Blackpelt is out searching for the best bamboo. Its heavy armour allows it to visit even the most dangerous places. Treat it nicely with its favourite food from time to time and it will become a loyal partner.</i>]],
		publishedAt = 169,

		packages = {
			[1] = {
				amount = 1,
				price = 690,
				currency = 0,
				offerId = 169,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 651,
	},
	[242] = {
		name = "Nethersteed",
		description = [[{character}
{speedboost}

<i>Once a majestic and proud warhorse, the Nethersteed has fallen in a horrible battle many years ago. Driven by agony and pain, its spirit once again took possession of its rotten corpse to avenge its death. Stronger than ever, it seeks a master to join the battlefield, aiming for nothing but death and destruction.</i>]],
		publishedAt = 132,

		packages = {
			[1] = {
				amount = 1,
				price = 900,
				currency = 0,
				offerId = 132,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 629,
	},
	[243] = {
		name = "Tempest",
		description = [[{character}
{speedboost}


<i>Once a majestic and proud warhorse, the Tempest has fallen in a horrible battle many years ago. Driven by agony and pain, its spirit once again took possession of its rotten corpse to avenge its death. Stronger than ever, it seeks a master to join the battlefield, aiming for nothing but death and destruction.</i>]],
		publishedAt = 139,

		packages = {
			[1] = {
				amount = 1,
				price = 900,
				currency = 0,
				offerId = 139,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 630,
	},
	[244] = {
		name = "Flamesteed",
		description = [[{character}
{speedboost}


<i>Once a majestic and proud warhorse, the Flamesteed has fallen in a horrible battle many years ago. Driven by agony and pain, its spirit once again took possession of its rotten corpse to avenge its death. Stronger than ever, it seeks a master to join the battlefield, aiming for nothing but death and destruction.</i>]],
		publishedAt = 147,

		packages = {
			[1] = {
				amount = 1,
				price = 900,
				currency = 0,
				offerId = 147,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 626,
	},
	[245] = {
		name = "Tombstinger",
		description = [[{character}
{speedboost}


<i>The Tombstinger is a scorpion that has surpassed the natural boundaries of its own kind. Way bigger, stronger and faster than ordinary scorpions, it makes a perfect companion for fearless heroes and explorers. Just be careful of his poisonous sting when you mount it.</i>]],
		publishedAt = 110,

		packages = {
			[1] = {
				amount = 1,
				price = 600,
				currency = 0,
				offerId = 110,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 546,
	},
	[246] = {
		name = "Death Crawler",
		description = [[{character}
{speedboost}


<i>The Death Crawler is a scorpion that has surpassed the natural boundaries of its own kind. Way bigger, stronger and faster than ordinary scorpions, it makes a perfect companion for fearless heroes and explorers. Just be careful of his poisonous sting when you mount it.</i>]],
		publishedAt = 117,

		packages = {
			[1] = {
				amount = 1,
				price = 600,
				currency = 0,
				offerId = 117,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 624,
	},
	[247] = {
		name = "Jade Pincer",
		description = [[{character}
{speedboost}


<i>The Jade Pincer is a scorpion that has surpassed the natural boundaries of its own kind. Way bigger, stronger and faster than ordinary scorpions, it makes a perfect companion for fearless heroes and explorers. Just be careful of his poisonous sting when you mount it.</i>]],
		publishedAt = 124,

		packages = {
			[1] = {
				amount = 1,
				price = 600,
				currency = 0,
				offerId = 124,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 628,
	},
	[248] = {
		name = "Desert King",
		description = [[{character}
{speedboost}

<i>Its roaring is piercing marrow and bone and can be heard over ten miles away. The Desert King is the undisputed ruler of its territory and no one messes with this animal. Show no fear and prove yourself worthy of its trust and you will get yourself a valuable companion for your adventures.</i>]],
		publishedAt = 57,

		packages = {
			[1] = {
				amount = 1,
				price = 450,
				currency = 0,
				offerId = 57,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 572,
	},
	[249] = {
		name = "Jade Lion",
		description = [[{character}
{speedboost}

<i>Its roaring is piercing marrow and bone and can be heard over ten miles away. The Jade Lion is the undisputed ruler of its territory and no one messes with this animal. Show no fear and prove yourself worthy of its trust and you will get yourself a valuable companion for your adventures.</i>]],
		publishedAt = 95,

		packages = {
			[1] = {
				amount = 1,
				price = 450,
				currency = 0,
				offerId = 95,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 627,
	},
	[250] = {
		name = "Winter King",
		description = [[{character}
{speedboost}

<i>Its roaring is piercing marrow and bone and can be heard over ten miles away. The Winter King is the undisputed ruler of its territory and no one messes with this animal. Show no fear and prove yourself worthy of its trust and you will get yourself a valuable companion for your adventures.</i>]],
		publishedAt = 102,

		packages = {
			[1] = {
				amount = 1,
				price = 450,
				currency = 0,
				offerId = 102,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 631,
	},
	[251] = {
		name = "Full Fencer Outfit",
		description = [[{character}
{info} colours can be changed using the Outfit dialog
{info} includes basic outfit and 2 addons which can be selected individually

<i>They are skilled, they are disciplined, they wield their weapon with deadly precision as a form of art. Fencers are true masters of the blade who can cut through anything and anyone in the blink of an eye. While being feared for their lethal attacks, they are also admired for their elegant and fierce style, their dashing looks. Do not be on the fence, be a fencer, or at least dress like one with this fashionable, cutting-edge outfit.</i>]],
		publishedAt = 1658476800,

		packages = {
			[1] = {
				amount = 1,
				price = 750,
				currency = 0,
				offerId = 40016111,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_OUTFIT,
		lookType = 1575,
		lookHead = 95,
		lookBody = 113,
		lookLegs = 39,
		lookFeet = 115,
	},
	[252] = {
		name = "Full Nordic Chieftain Outfit",
		description = [[{character}
{info} colours can be changed using the Outfit dialog
{info} includes basic outfit and 2 addons which can be selected individually

<i>Where others not dare to tread due to the biting cold and freezing winds, the Nordic Chieftain feels right at home. Braving the harsh conditions is possible due to a protective layer of warm clothing, as well as suitable armament to fend off any hostile wildlife. The helmet's massive horns are a tad heavy and unwieldy, but show the chieftain's status.</i>]],
		publishedAt = 1650614400,

		packages = {
			[1] = {
				amount = 1,
				price = 750,
				currency = 0,
				offerId = 40014187,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_OUTFIT,
		lookType = 1500,
		lookHead = 95,
		lookBody = 113,
		lookLegs = 39,
		lookFeet = 115,
	},
	[253] = {
		name = "Full Ghost Blade Outfit",
		description = [[{character}
{info} colours can be changed using the Outfit dialog
{info} includes basic outfit and 2 addons which can be selected individually

<i>Being a Ghost Blade means having mastered the way of the warrior. No matter the circumstances, these fighters retain full control over their body and mind, with the sole focus of vanquishing their foe. So great is their ability that they not only control the weapons in their hands perfectly, but two floating blades following them as well.</i>]],
		publishedAt = 1643965200,

		packages = {
			[1] = {
				amount = 1,
				price = 600,
				currency = 0,
				offerId = 40011214,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_OUTFIT,
		lookType = 1489,
		lookHead = 95,
		lookBody = 113,
		lookLegs = 39,
		lookFeet = 115,
	},
	[254] = {
		name = "Full Arbalester Outfit",
		description = [[{character}
{info} colours can be changed using the Outfit dialog
{info} includes basic outfit and 2 addons which can be selected individually

<i>Armed with a powerful crossbow, and gifted with steady hands as well as a sharp eye, the Arbalester is not one to be trifled with. Requiring both skill and strength to properly wield, the arbalest is a mighty tool in the hands of an able marksman, shooting deadly bolts across great distance.</i>]],
		publishedAt = 1634889600,

		packages = {
			[1] = {
				amount = 1,
				price = 600,
				currency = 0,
				offerId = 40010649,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_OUTFIT,
		lookType = 1449,
		lookHead = 95,
		lookBody = 113,
		lookLegs = 39,
		lookFeet = 115,
	},
	[255] = {
		name = "Full Dragon Knight Outfit",
		description = [[{character}
{info} colours can be changed using the Outfit dialog
{info} includes basic outfit and 2 addons which can be selected individually

<i>A Dragon Knight is ready for everything, channeling the primordial might of the winged, ancient beasts into weapons and armour. Their imposing demeanour and impressive appearance are often enough to quell any animosity towards them, and those who still dare oppose them are not long for this world.</i>]],
		publishedAt = 1627027200,

		packages = {
			[1] = {
				amount = 1,
				price = 870,
				currency = 0,
				offerId = 40008693,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_OUTFIT,
		lookType = 1444,
		lookHead = 95,
		lookBody = 113,
		lookLegs = 39,
		lookFeet = 115,
	},
	[256] = {
		name = "Full Forest Warden Outfit",
		description = [[{character}
{info} colours can be changed using the Outfit dialog
{info} includes basic outfit and 2 addons which can be selected individually

<i>The Forest Warden watches over all living things in the woods, be they plants or beasts. They have a special connection to the earth they tread on, the air they breathe, and the wind which whispers around them. Naturally, the suit that they don is not made out of dead vegetation, but is a living being itself.</i>]],
		publishedAt = 1622188800,

		packages = {
			[1] = {
				amount = 1,
				price = 750,
				currency = 0,
				offerId = 40008304,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_OUTFIT,
		lookType = 1415,
		lookHead = 95,
		lookBody = 113,
		lookLegs = 39,
		lookFeet = 115,
	},
	[257] = {
		name = "Full Rune Master Outfit",
		description = [[{character}
{info} colours can be changed using the Outfit dialog
{info} includes basic outfit and 2 addons which can be selected individually

<i>A Rune Master has dedicated their whole life to the study and mastery of runes. They are intrigued by the ancient symbols, shrouded in mystery, and how their magic works. Rune Masters have a deep understanding of the awesome power they are wielding and can make use of the full potential of runes.</i>]],
		publishedAt = 1614330000,

		packages = {
			[1] = {
				amount = 1,
				price = 870,
				currency = 0,
				offerId = 40007309,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_OUTFIT,
		lookType = 1384,
		lookHead = 95,
		lookBody = 113,
		lookLegs = 39,
		lookFeet = 115,
	},
	[258] = {
		name = "Full Merry Garb Outfit",
		description = [[{character}
{info} colours can be changed using the Outfit dialog
{info} includes basic outfit and 2 addons which can be selected individually

<i>Are you ready for the festive season? Or feeling festive regardless of the time of year? Then the Merry Garb is perfect for you. Donning the outfit not only puts you in a mirthful mood, but spreads blitheness on your travels throughout the lands.</i>]],
		publishedAt = 1609837200,

		packages = {
			[1] = {
				amount = 1,
				price = 600,
				currency = 0,
				offerId = 40006710,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_OUTFIT,
		lookType = 1382,
		lookHead = 95,
		lookBody = 113,
		lookLegs = 39,
		lookFeet = 115,
	},
	[259] = {
		name = "Full Moth Cape Outfit",
		description = [[{character}
{info} colours can be changed using the Outfit dialog
{info} includes basic outfit and 2 addons which can be selected individually

<i>If you are fascinated by this particular group of insects and want to show your deep appreciation of these critters, the Moth Cape is for you. The wing-shaped coat and the antennae provide you with the feeling of being a moth without experiencing the downside of inevitably being drawn to light.</i>]],
		publishedAt = 1601020800,

		packages = {
			[1] = {
				amount = 1,
				price = 600,
				currency = 0,
				offerId = 40005053,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_OUTFIT,
		lookType = 1338,
		lookHead = 95,
		lookBody = 113,
		lookLegs = 39,
		lookFeet = 115,
	},
	[260] = {
		name = "Full Jouster Outfit",
		description = [[{character}
{info} colours can be changed using the Outfit dialog
{info} includes basic outfit and 2 addons which can be selected individually

<i>The Jouster is all geared up for a tournament, ready to partake in festive activities involving friendly competition to prove their chivalry. However, being well-armoured, they are also a force to be reckoned with on the battlefield, especially with a trusty steed at their service.</i>]],
		publishedAt = 1593158400,

		packages = {
			[1] = {
				amount = 1,
				price = 750,
				currency = 0,
				offerId = 40001964,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_OUTFIT,
		lookType = 1331,
		lookHead = 95,
		lookBody = 113,
		lookLegs = 39,
		lookFeet = 115,
	},
	[261] = {
		name = "Full Trailblazer Outfit",
		description = [[{character}
{info} colours can be changed using the Outfit dialog
{info} includes basic outfit and 2 addons which can be selected individually

<i>The Trailblazer is on a mission of enlightenment and carries the flame of wisdom near and far. The everlasting shine brightens the hearts and minds of all creatures its rays touch, bringing light even to the darkest corners of the world as a beacon of insight and knowledge.</i>]],
		publishedAt = 1585299600,

		packages = {
			[1] = {
				amount = 1,
				price = 600,
				currency = 0,
				offerId = 40001420,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_OUTFIT,
		lookType = 1292,
		lookHead = 95,
		lookBody = 113,
		lookLegs = 39,
		lookFeet = 115,
	},
	[262] = {
		name = "Full Herder Outfit",
		description = [[{character}
{info} colours can be changed using the Outfit dialog
{info} includes basic outfit and 2 addons which can be selected individually

<i>The Herder is one with nature, being outside all day, watching carefully over his flock. If you like to spend time on picturesque meadows and are always looking for greener pastures, then this outfit is for you.</i>]],
		publishedAt = 1576227600,

		packages = {
			[1] = {
				amount = 1,
				price = 750,
				currency = 0,
				offerId = 40000947,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_OUTFIT,
		lookType = 1279,
		lookHead = 95,
		lookBody = 113,
		lookLegs = 39,
		lookFeet = 115,
	},
	[263] = {
		name = "Full Breezy Garb Outfit",
		description = [[{character}
{info} colours can be changed using the Outfit dialog
{info} includes basic outfit and 2 addons which can be selected individually

<i>Even the most eager adventurers and toughest warriors need some time to rest and recharge. Enjoy tranquility and peace as you picnic in good company at one of your favourite places. Put on your Breezy Garb outfit, grab your walking stick, a basket filled with tasty snacks and then head out into nature!</i>]],
		publishedAt = 1564128000,

		packages = {
			[1] = {
				amount = 1,
				price = 600,
				currency = 0,
				offerId = 7267311,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_OUTFIT,
		lookType = 1245,
		lookHead = 95,
		lookBody = 113,
		lookLegs = 39,
		lookFeet = 115,
	},
	[264] = {
		name = "Full Guidon Bearer Outfit",
		description = [[{character}
{info} colours can be changed using the Outfit dialog
{info} includes basic outfit and 2 addons which can be selected individually

<i>Carrying the guidon of a unit, always marching in front, is not only an honour but also comes with great responsibility. Guidon bearers wield great power, they lead where others follow and keep the spirits of the troops up as they wave their flag against the golden suns.</i>]],
		publishedAt = 1556262000,

		packages = {
			[1] = {
				amount = 1,
				price = 870,
				currency = 0,
				offerId = 7266524,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_OUTFIT,
		lookType = 1186,
		lookHead = 95,
		lookBody = 113,
		lookLegs = 39,
		lookFeet = 115,
	},
	[265] = {
		name = "Full Owl Keeper Outfit",
		description = [[{character}
{info} colours can be changed using the Outfit dialog
{info} includes basic outfit and 2 addons which can be selected individually

<i>Owl Keepers are often referred to as spirits walking through the forest at night, mere shadows during the day. They are also said to be shamans, protecting the flora and fauna. You often see them wearing a stag's antlers on their head and in the company of an owl, for they are as wise and mysterious as these intriguing creatures.</i>]],
		publishedAt = 1550566800,

		packages = {
			[1] = {
				amount = 1,
				price = 600,
				currency = 0,
				offerId = 7266151,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_OUTFIT,
		lookType = 1173,
		lookHead = 95,
		lookBody = 113,
		lookLegs = 39,
		lookFeet = 115,
	},
	[266] = {
		name = "Full Pumpkin Mummy Outfit",
		description = [[{character}
{info} colours can be changed using the Outfit dialog
{info} includes basic outfit and 2 addons which can be selected individually

<i>If you cannot decide whether to wrap yourself up as a mummy or flaunt an enormous pumpkin head for your next hunting party, why not combine both? The Pumpkin Mummy outfit is the perfect costume for scary nights and spooky days.</i>]],
		publishedAt = 1541149200,

		packages = {
			[1] = {
				amount = 1,
				price = 870,
				currency = 0,
				offerId = 7265451,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_OUTFIT,
		lookType = 1127,
		lookHead = 95,
		lookBody = 113,
		lookLegs = 39,
		lookFeet = 115,
	},
	[267] = {
		name = "Full Sinister Archer Outfit",
		description = [[{character}
{info} colours can be changed using the Outfit dialog
{info} includes basic outfit and 2 addons which can be selected individually

<i>From an early age, the Sinister Archer has been fascinated by people's dark machinations and perversions. Sinister Archers claim that they advocate the good and that they only use their arrows to pierce the hearts of those who have committed many crimes and misdeeds. However, they are still viewed by the public with much suspicion due to their dubious appearance. To keep their identity secret, they often hide themselves behind a skull-like face guard that can easily withstand even axe and club blows.</i>]],
		publishedAt = 1532678400,

		packages = {
			[1] = {
				amount = 1,
				price = 600,
				currency = 0,
				offerId = 7264725,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_OUTFIT,
		lookType = 1102,
		lookHead = 95,
		lookBody = 113,
		lookLegs = 39,
		lookFeet = 115,
	},
	[268] = {
		name = "Full Mercenary Outfit",
		description = [[{character}
{info} colours can be changed using the Outfit dialog
{info} includes basic outfit and 2 addons which can be selected individually

<i>The Mercenary carries a powerful, razor-sharp axe on his shoulders that effortlessly cuts through any armour and bone. You should better tell your friends to keep a safe distance, since heads will roll over the blood-soaked battleground after a powerful swing of yours.
Considering the sheer size of this axe, it might even be possible to chop onions without shedding a tear.</i>]],
		publishedAt = 1524812400,

		packages = {
			[1] = {
				amount = 1,
				price = 870,
				currency = 0,
				offerId = 7262822,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_OUTFIT,
		lookType = 1056,
		lookHead = 95,
		lookBody = 113,
		lookLegs = 39,
		lookFeet = 115,
	},
	[269] = {
		name = "Full Siege Master Outfit",
		description = [[{character}
{info} colours can be changed using the Outfit dialog
{info} includes basic outfit and 2 addons which can be selected individually

<i>Neither thick stone walls nor heavily armoured gates can stop the Siege Master, who brings down hostile fortifications in the blink of an eye. Whenever he tenses his muscular arms to lift the powerful battering ram, his enemies' knees begin to buckle. It is the perfect outfit for those who also stand for brute strength and immense destruction.</i>]],
		publishedAt = 1519981200,

		packages = {
			[1] = {
				amount = 1,
				price = 600,
				currency = 0,
				offerId = 7257542,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_OUTFIT,
		lookType = 1050,
		lookHead = 95,
		lookBody = 113,
		lookLegs = 39,
		lookFeet = 115,
	},
	[270] = {
		name = "Full Sun Priest Outfit",
		description = [[{character}
{info} colours can be changed using the Outfit dialog
{info} includes basic outfit and 2 addons which can be selected individually

<i>Do you worship warm temperatures and are opposed to the thought of long and dark winter nights? Do you refuse to spend countless evenings in front of your chimney while ice-cold wind whistles through the cracks and niches of your house? It is time to stop freezing and to become an honourable Sun Priest! With this stylish outfit, you can finally show the world your unconditional dedication and commitment to the sun!</i>]],
		publishedAt = 1515229200,

		packages = {
			[1] = {
				amount = 1,
				price = 750,
				currency = 0,
				offerId = 7257893,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_OUTFIT,
		lookType = 1023,
		lookHead = 95,
		lookBody = 113,
		lookLegs = 39,
		lookFeet = 115,
	},
	[271] = {
		name = "Full Herbalist Outfit",
		description = [[{character}
{info} colours can be changed using the Outfit dialog
{info} includes basic outfit and 2 addons which can be selected individually

<i>The Herbalist outfit is the perfect outfit for all herbs collectors. Those of you who are aware that you do not necessarily have to reach into the mouth of a hydra to get a hydra tongue and those who know exactly where to get blood- and shadow-herbs will find a matching outfit for their daily hobby. Show the world your affinity for herbs and impress your friends with your knowledge of medicine and potions.</i>]],
		publishedAt = 1509091200,

		packages = {
			[1] = {
				amount = 1,
				price = 750,
				currency = 0,
				offerId = 7257933,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_OUTFIT,
		lookType = 1021,
		lookHead = 95,
		lookBody = 113,
		lookLegs = 39,
		lookFeet = 115,
	},
	[272] = {
		name = "Full Entrepreneur Outfit",
		description = [[{character}
{info} colours can be changed using the Outfit dialog
{info} includes basic outfit and 2 addons which can be selected individually

<i>Slaughter through hordes of monsters during your early morning hunt and kiss the hand of Queen Eloise later on at the evening reception in her historical residence. With the Entrepreneur outfit you will cut a fine figure on every occasion.</i>]],
		publishedAt = 1501228800,

		packages = {
			[1] = {
				amount = 1,
				price = 750,
				currency = 0,
				offerId = 7257935,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_OUTFIT,
		lookType = 472,
		lookHead = 95,
		lookBody = 113,
		lookLegs = 39,
		lookFeet = 115,
	},
	[273] = {
		name = "Full Trophy Hunter Outfit",
		description = [[{character}
{info} colours can be changed using the Outfit dialog
{info} includes basic outfit and 2 addons which can be selected individually

<i>You spend hours in the woods in search of wild and rare animals? Countless stuffed skulls of deer, wolves and other creatures are decorating your walls? Now you have the chance to present your trophies in public. Become a Trophy Hunter and cover your shoulders with the finest bear skulls!</i>]],
		publishedAt = 1498204800,

		packages = {
			[1] = {
				amount = 1,
				price = 870,
				currency = 0,
				offerId = 7257937,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_OUTFIT,
		lookType = 957,
		lookHead = 95,
		lookBody = 113,
		lookLegs = 39,
		lookFeet = 115,
	},
	[274] = {
		name = "Retro Noble(wo)man Outfit",
		description = [[{character}
{info} colours can be changed using the Outfit dialog

<i>The king has invited you to a summer ball and you have nothing to wear for this special event? Do not worry, the Retro Noble(wo)man outfit makes you a real eye catcher on every festive occasion.</i>]],
		publishedAt = 1496995200,

		packages = {
			[1] = {
				amount = 1,
				price = 870,
				currency = 0,
				offerId = 7257939,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_OUTFIT,
		lookType = 966,
		lookHead = 95,
		lookBody = 113,
		lookLegs = 39,
		lookFeet = 115,
	},
	[275] = {
		name = "Retro Summoner Outfit",
		description = [[{character}
{info} colours can be changed using the Outfit dialog

<i>While the Retro Mage usually throws runes and mighty spells directly at the enemies, the Retro Summoner outfit might be the better choice for adventurers that prefer to send mighty summons to the battlefield to keep their enemies at distance.</i>]],
		publishedAt = 1496995200,

		packages = {
			[1] = {
				amount = 1,
				price = 870,
				currency = 0,
				offerId = 7257941,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_OUTFIT,
		lookType = 964,
		lookHead = 95,
		lookBody = 113,
		lookLegs = 39,
		lookFeet = 115,
	},
	[276] = {
		name = "Retro Warrior Outfit",
		description = [[{character}
{info} colours can be changed using the Outfit dialog

<i>You are fearless and strong as a behemoth but have problems finding the right outfit for your adventures? The Retro Warrior outfit is a must-have for all fashion-conscious old-school adventurers out there.</i>]],
		publishedAt = 1496995200,

		packages = {
			[1] = {
				amount = 1,
				price = 870,
				currency = 0,
				offerId = 7257943,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_OUTFIT,
		lookType = 962,
		lookHead = 95,
		lookBody = 113,
		lookLegs = 39,
		lookFeet = 115,
	},
	[277] = {
		name = "Retro Knight Outfit",
		description = [[{character}
{info} colours can be changed using the Outfit dialog

<i>Who needs a fancy looking sword with bling-bling and ornaments? Back in the days, we survived without such unnecessary accessories! Time to show those younkers what a Retro Knight is made of.</i>]],
		publishedAt = 1495785600,

		packages = {
			[1] = {
				amount = 1,
				price = 870,
				currency = 0,
				offerId = 7257945,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_OUTFIT,
		lookType = 970,
		lookHead = 95,
		lookBody = 113,
		lookLegs = 39,
		lookFeet = 115,
	},
	[278] = {
		name = "Retro Hunter Outfit",
		description = [[{character}
{info} colours can be changed using the Outfit dialog

<i>Whenever you pick up your bow and spears, you walk down memory lane and think of your early days? Treat yourself with the fashionable Retro Hunter outfit and hunt some good old monsters from your childhood.</i>]],
		publishedAt = 1495785600,

		packages = {
			[1] = {
				amount = 1,
				price = 870,
				currency = 0,
				offerId = 7257947,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_OUTFIT,
		lookType = 972,
		lookHead = 95,
		lookBody = 113,
		lookLegs = 39,
		lookFeet = 115,
	},
	[279] = {
		name = "Retro Mage Outfit",
		description = [[{character}
{info} colours can be changed using the Outfit dialog

<i>Dress up as a Retro Mage and you will always cut a fine figure on the battleground while eliminating your enemies with your magical powers the old-fashioned way.</i>]],
		publishedAt = 1495785600,

		packages = {
			[1] = {
				amount = 1,
				price = 870,
				currency = 0,
				offerId = 7257949,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_OUTFIT,
		lookType = 968,
		lookHead = 95,
		lookBody = 113,
		lookLegs = 39,
		lookFeet = 115,
	},
	[280] = {
		name = "Retro Citizen Outfit",
		description = [[{character}
{info} colours can be changed using the Outfit dialog

<i>Do you still remember your first stroll through the streets of Thais? For old times' sake, walk the paths of Nostalgia as a Retro Citizen!</i>]],
		publishedAt = 1495785600,

		packages = {
			[1] = {
				amount = 1,
				price = 870,
				currency = 0,
				offerId = 7257951,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_OUTFIT,
		lookType = 974,
		lookHead = 95,
		lookBody = 113,
		lookLegs = 39,
		lookFeet = 115,
	},
	[281] = {
		name = "Full Pharaoh Outfit",
		description = [[{character}
{info} colours can be changed using the Outfit dialog
{info} includes basic outfit and 2 addons which can be selected individually

<i>You know how to read hieroglyphs? You admire the exceptional architectural abilities and the unsolved mysteries of an ancient high culture? Next time you pay a visit to your friends, tell them to prepare a bathtub full of milk and honey for you because a Pharaoh is now walking through the streets of Ankrahmun!</i>]],
		publishedAt = 1488531600,

		packages = {
			[1] = {
				amount = 1,
				price = 750,
				currency = 0,
				offerId = 7257953,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_OUTFIT,
		lookType = 955,
		lookHead = 95,
		lookBody = 113,
		lookLegs = 39,
		lookFeet = 115,
	},
	[282] = {
		name = "Full Grove Keeper Outfit",
		description = [[{character}
{info} colours can be changed using the Outfit dialog
{info} includes basic outfit and 2 addons which can be selected individually

<i>Feeling the springy grass under your feet and inhaling the spicy air of the forest is pure satisfaction for your soul? Every animal is your friend and you caringly look after trees and plants all the time? Then it is time to become one with nature: Become a Grove Keeper!</i>]],
		publishedAt = 1480662000,

		packages = {
			[1] = {
				amount = 1,
				price = 870,
				currency = 0,
				offerId = 7257955,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_OUTFIT,
		lookType = 908,
		lookHead = 95,
		lookBody = 113,
		lookLegs = 39,
		lookFeet = 115,
	},
	[283] = {
		name = "Full Lupine Warden Outfit",
		description = [[{character}
{info} colours can be changed using the Outfit dialog
{info} includes basic outfit and 2 addons which can be selected individually

<i>Do you feel the adrenaline rushing through your veins when the sun goes down and a full moon lightens the night? Do you have the urge to hunt down your target no matter what? Unleash the beast inside of you and lead your friends to battle with the Lupine Warden outfit!</i>]],
		publishedAt = 1475222400,

		packages = {
			[1] = {
				amount = 1,
				price = 840,
				currency = 0,
				offerId = 7257957,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_OUTFIT,
		lookType = 899,
		lookHead = 95,
		lookBody = 113,
		lookLegs = 39,
		lookFeet = 115,
	},
	[284] = {
		name = "Full Arena Champion Outfit",
		description = [[{character}
{info} colours can be changed using the Outfit dialog
{info} includes basic outfit and 2 addons which can be selected individually

<i>Fight your bloody battles in the arena and become a darling of the crowd. Once you have made it to the top and everyone is cheering your name, the fashionable outfit of an Arena Champion will show the world what you are made of.</i>]],
		publishedAt = 1475222399,

		packages = {
			[1] = {
				amount = 1,
				price = 870,
				currency = 0,
				offerId = 7257959,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_OUTFIT,
		lookType = 884,
		lookHead = 95,
		lookBody = 113,
		lookLegs = 39,
		lookFeet = 115,
	},
	[285] = {
		name = "Full Philosopher Outfit",
		description = [[{character}
{info} colours can be changed using the Outfit dialog
{info} includes basic outfit and 2 addons which can be selected individually

<i>Do you feel the urge to tell people what is really going on in the world? Do you know all answers to the important questions of life? Are you a true philosopher? Then dress like one to showcase the latest fashion for all wise theorists.</i>]],
		publishedAt = 1475222398,

		packages = {
			[1] = {
				amount = 1,
				price = 750,
				currency = 0,
				offerId = 7257961,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_OUTFIT,
		lookType = 873,
		lookHead = 95,
		lookBody = 113,
		lookLegs = 39,
		lookFeet = 115,
	},
	[286] = {
		name = "Full Winter Warden Outfit",
		description = [[{character}
{info} colours can be changed using the Outfit dialog
{info} includes basic outfit and 2 addons which can be selected individually

<i>The warm and cosy cloak of the Winter Warden outfit will keep you warm in every situation. Best thing, it is not only comfortable but fashionable as well. You will be the envy of any snow queen or king, guaranteed!</i>]],
		publishedAt = 1475222397,

		packages = {
			[1] = {
				amount = 1,
				price = 870,
				currency = 0,
				offerId = 7257963,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_OUTFIT,
		lookType = 853,
		lookHead = 95,
		lookBody = 113,
		lookLegs = 39,
		lookFeet = 115,
	},
	[287] = {
		name = "Full Royal Pumpkin Outfit",
		description = [[{character}
{info} colours can be changed using the Outfit dialog
{info} includes basic outfit and 2 addons which can be selected individually

<i>The mutated pumpkin is too weak for your mighty weapons? Time to show that evil vegetable how to scare the living daylight out of people! Put on a scary looking pumpkin on your head and spread terror and fear amongst the population.</i>]],
		publishedAt = 1475222396,

		packages = {
			[1] = {
				amount = 1,
				price = 840,
				currency = 0,
				offerId = 7257965,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_OUTFIT,
		lookType = 760,
		lookHead = 95,
		lookBody = 113,
		lookLegs = 39,
		lookFeet = 115,
	},
	[288] = {
		name = "Full Sea Dog Outfit",
		description = [[{character}
{info} colours can be changed using the Outfit dialog
{info} includes basic outfit and 2 addons which can be selected individually

<i>Ahoy mateys! Flaunt the swashbuckling Sea Dog outfit and strike a pose with your hook to impress both landlubbers and fellow pirates. Board your next ship in style!</i>]],
		publishedAt = 1475222395,

		packages = {
			[1] = {
				amount = 1,
				price = 600,
				currency = 0,
				offerId = 7257967,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_OUTFIT,
		lookType = 750,
		lookHead = 95,
		lookBody = 113,
		lookLegs = 39,
		lookFeet = 115,
	},
	[289] = {
		name = "Full Champion Outfit",
		description = [[{character}
{info} colours can be changed using the Outfit dialog
{info} includes basic outfit and 2 addons which can be selected individually

<i>Protect your body with heavy armour plates and spiky bones to teach your enemies the meaning of fear! The Champion outfit perfectly suits battle-hardened warriors who rely on their trusty sword and shield.</i>]],
		publishedAt = 1475222385,

		packages = {
			[1] = {
				amount = 1,
				price = 570,
				currency = 0,
				offerId = 7257969,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_OUTFIT,
		lookType = 633,
		lookHead = 95,
		lookBody = 113,
		lookLegs = 39,
		lookFeet = 115,
	},
	[290] = {
		name = "Full Conjurer Outfit",
		description = [[{character}
{info} colours can be changed using the Outfit dialog
{info} includes basic outfit and 2 addons which can be selected individually

<i>You recently graduated from the Magic Academy and want to bring your knowledge to good use? Congratulations, you are now an honourable disciple of magic! Open up a bottle of well-aged mana and treat yourself with the fashionable Conjurer outfit.</i>]],
		publishedAt = 1475222386,

		packages = {
			[1] = {
				amount = 1,
				price = 720,
				currency = 0,
				offerId = 7257971,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_OUTFIT,
		lookType = 634,
		lookHead = 95,
		lookBody = 113,
		lookLegs = 39,
		lookFeet = 115,
	},
	[291] = {
		name = "Full Beastmaster Outfit",
		description = [[{character}
{info} colours can be changed using the Outfit dialog
{info} includes basic outfit and 2 addons which can be selected individually

<i>Do you have enough authority to make wild animals subservient to you? Become a Beastmaster and surround yourself with fearsome companions. When your beasts bare their teeth, your enemies will turn tails and run.</i>]],
		publishedAt = 1475222384,

		packages = {
			[1] = {
				amount = 1,
				price = 870,
				currency = 0,
				offerId = 7257973,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_OUTFIT,
		lookType = 637,
		lookHead = 95,
		lookBody = 113,
		lookLegs = 39,
		lookFeet = 115,
	},
	[292] = {
		name = "Full Chaos Acolyte Outfit",
		description = [[{character}
{info} colours can be changed using the Outfit dialog
{info} includes basic outfit and 2 addons which can be selected individually

<i>You have always felt like the cat among the pigeons and have a fable for dark magic? The Chaos Acolyte outfit is a perfect way to express your inner nature. Show your commitment for the higher cause and wreak havoc on your enemies in this unique outfit.</i>]],
		publishedAt = 1475222387,

		packages = {
			[1] = {
				amount = 1,
				price = 900,
				currency = 0,
				offerId = 7257975,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_OUTFIT,
		lookType = 665,
		lookHead = 95,
		lookBody = 113,
		lookLegs = 39,
		lookFeet = 115,
	},
	[293] = {
		name = "Full Death Herald Outfit",
		description = [[{character}
{info} colours can be changed using the Outfit dialog
{info} includes basic outfit and 2 addons which can be selected individually

<i>Death and decay are your ever-present companions? Your enemies are dropping like flies and your path is covered with their bodies? However, as decency demands, you want to at least give them a proper funeral? Then the Death Herald is just the right outfit for you.</i>]],
		publishedAt = 1475222388,

		packages = {
			[1] = {
				amount = 1,
				price = 600,
				currency = 0,
				offerId = 7257977,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_OUTFIT,
		lookType = 667,
		lookHead = 95,
		lookBody = 113,
		lookLegs = 39,
		lookFeet = 115,
	},
	[294] = {
		name = "Full Ranger Outfit",
		description = [[{character}
{info} colours can be changed using the Outfit dialog
{info} includes basic outfit and 2 addons which can be selected individually

<i>Most of the day, the Ranger is looking over his forest. He is taking care of all animals and plants and tries to keep everything in balance. Intruders are greeted by a warning shot from his deadly longbow. It is the perfect outfit for Paladins who live in close touch with nature.</i>]],
		publishedAt = 1475222389,

		packages = {
			[1] = {
				amount = 1,
				price = 750,
				currency = 0,
				offerId = 7257979,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_OUTFIT,
		lookType = 684,
		lookHead = 95,
		lookBody = 113,
		lookLegs = 39,
		lookFeet = 115,
	},
	[295] = {
		name = "Full Ceremonial Garb Outfit",
		description = [[{character}
{info} colours can be changed using the Outfit dialog
{info} includes basic outfit and 2 addons which can be selected individually

<i>If you want to make a great entrance at a costume party, the Ceremonial Garb is certainly a good choice. With a drum over your shoulder and adorned with feathers you are perfectly dressed to lead a carnival parade through the streets of Thais.</i>]],
		publishedAt = 1475222390,

		packages = {
			[1] = {
				amount = 1,
				price = 750,
				currency = 0,
				offerId = 7257981,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_OUTFIT,
		lookType = 695,
		lookHead = 95,
		lookBody = 113,
		lookLegs = 39,
		lookFeet = 115,
	},
	[296] = {
		name = "Full Puppeteer Outfit",
		description = [[{character}
{info} colours can be changed using the Outfit dialog
{info} includes basic outfit and 2 addons which can be selected individually

<i>Are you a fan of puppetry? You like to travel the world together with one or two little acting fellows? Or are you simply the one who likes to pull the strings? Then the Puppeteer outfit is the right choice for you.</i>]],
		publishedAt = 1475222391,

		packages = {
			[1] = {
				amount = 1,
				price = 870,
				currency = 0,
				offerId = 7257983,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_OUTFIT,
		lookType = 697,
		lookHead = 95,
		lookBody = 113,
		lookLegs = 39,
		lookFeet = 115,
	},
	[297] = {
		name = "Full Spirit Caller Outfit",
		description = [[{character}
{info} colours can be changed using the Outfit dialog
{info} includes basic outfit and 2 addons which can be selected individually

<i>You are in love with the deep soul of Mother Earth and prefer to walk in the shadows of her wooden children? Choose the Spirit Caller outfit to live in harmony with nature.</i>]],
		publishedAt = 1475222392,

		packages = {
			[1] = {
				amount = 1,
				price = 600,
				currency = 0,
				offerId = 7257985,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_OUTFIT,
		lookType = 699,
		lookHead = 95,
		lookBody = 113,
		lookLegs = 39,
		lookFeet = 115,
	},
	[298] = {
		name = "Full Evoker Outfit",
		description = [[{character}
{info} colours can be changed using the Outfit dialog
{info} includes basic outfit and 2 addons which can be selected individually

<i>Dance around flickering fires in the Evoker outfit while singing unholy chants to praise witchcraft and wizardry. Your faithful bat will always be by your side.</i>]],
		publishedAt = 1475222393,

		packages = {
			[1] = {
				amount = 1,
				price = 840,
				currency = 0,
				offerId = 7257987,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_OUTFIT,
		lookType = 725,
		lookHead = 95,
		lookBody = 113,
		lookLegs = 39,
		lookFeet = 115,
	},
	[299] = {
		name = "Full Seaweaver Outfit",
		description = [[{character}
{info} colours can be changed using the Outfit dialog
{info} includes basic outfit and 2 addons which can be selected individually

<i>The Seaweaver outfit is the perfect choice if you want to show the world that you are indeed a son or a daughter of the submarine kingdom. You can almost feel the salty taste and the rough wind of the sea when wearing it.</i>]],
		publishedAt = 1475222394,

		packages = {
			[1] = {
				amount = 1,
				price = 570,
				currency = 0,
				offerId = 7257989,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_OUTFIT,
		lookType = 733,
		lookHead = 95,
		lookBody = 113,
		lookLegs = 39,
		lookFeet = 115,
	},
	[300] = {
		name = "Flowery Grass",
		description = [[]],
		publishedAt = 1663920000,

		packages = {
			[1] = {
				amount = 1,
				price = 30,
				currency = 0,
				offerId = 40016336,
				status = 0,
			},
			[2] = {
				amount = 5,
				price = 150,
				currency = 0,
				offerId = 40016343,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
	},
	[301] = {
		name = "Purple Flower Lamp",
		description = [[]],
		publishedAt = 1663920000,

		packages = {
			[1] = {
				amount = 1,
				price = 80,
				currency = 0,
				offerId = 40016335,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
	},
	[302] = {
		name = "Turquoise Flower Lamp",
		description = [[]],
		publishedAt = 1663920000,

		packages = {
			[1] = {
				amount = 1,
				price = 60,
				currency = 0,
				offerId = 40016334,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
	},
	[303] = {
		name = "Flower Bed",
		description = [[<i>Sleep in a bed to restore soul, mana and hit points and to train your skills!</i>

{house}
{boxicon} comes in 2 boxes which can only be unwrapped by purchasing character, put the 2 parts together to get a functional bed
{storeinbox}
{usablebyallicon} if not already occupied, it can be used by every Premium character that has access to the house
{useicon} use it to sleep in it
{backtoinbox}]],
		publishedAt = 1663920000,

		packages = {
			[1] = {
				amount = 1,
				price = 150,
				currency = 0,
				offerId = 40016344,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_DEFAULT,
		image = "Product_HouseEquipment_FlowerBed.png",
	},
	[304] = {
		name = "Wall Flowers",
		description = [[]],
		publishedAt = 1663920000,

		packages = {
			[1] = {
				amount = 1,
				price = 50,
				currency = 0,
				offerId = 40016337,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
	},
	[305] = {
		name = "Wall Fern",
		description = [[]],
		publishedAt = 1663920000,

		packages = {
			[1] = {
				amount = 1,
				price = 50,
				currency = 0,
				offerId = 40016338,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
	},
	[306] = {
		name = "Wall Leaves",
		description = [[]],
		publishedAt = 1663920000,

		packages = {
			[1] = {
				amount = 1,
				price = 50,
				currency = 0,
				offerId = 40016339,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
	},
	[307] = {
		name = "Tendrils",
		description = [[]],
		publishedAt = 1663920000,

		packages = {
			[1] = {
				amount = 1,
				price = 50,
				currency = 0,
				offerId = 40016340,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
	},
	[308] = {
		name = "Water Nymph",
		description = [[]],
		publishedAt = 1663920000,

		packages = {
			[1] = {
				amount = 1,
				price = 180,
				currency = 0,
				offerId = 40016341,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
	},
	[309] = {
		name = "Flower Furniture",
		description = [[]],
		publishedAt = 1663920000,

		packages = {
			[1] = {
				amount = 1,
				price = 290,
				currency = 0,
				offerId = 40016342,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_DEFAULT,
		image = "Product_HouseEquipment_FloralFurniture_Bundle.png",
	},
	[310] = {
		name = "Flower Cabinet",
		description = [[]],
		publishedAt = 1663920000,

		packages = {
			[1] = {
				amount = 1,
				price = 90,
				currency = 0,
				offerId = 40016333,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
	},
	[311] = {
		name = "Flower Table",
		description = [[]],
		publishedAt = 1663920000,

		packages = {
			[1] = {
				amount = 1,
				price = 80,
				currency = 0,
				offerId = 40016332,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
	},
	[312] = {
		name = "Flower Chest",
		description = [[]],
		publishedAt = 1663920000,

		packages = {
			[1] = {
				amount = 1,
				price = 60,
				currency = 0,
				offerId = 40016331,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
	},
	[313] = {
		name = "Flower Chair",
		description = [[]],
		publishedAt = 1663920000,

		packages = {
			[1] = {
				amount = 1,
				price = 60,
				currency = 0,
				offerId = 40016330,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
	},
	[314] = {
		name = "XP Boost",
		description = [[<i>Purchase a boost that increases the experience points your character gains from hunting by 50%!</i>

{character}
{info} lasts for 1 hour hunting time
{info} paused if stamina falls under 14 hours
{info} can be purchased up to 5 times between 2 server saves
{info} price increases with every purchase
{info} cannot be purchased if an XP boost is already active]],
		publishedAt = 1474963200,

		packages = {
			[1] = {
				amount = 1,
				price = 30,
				currency = 0,
				offerId = 3516,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_DEFAULT,
		image = "Product_XpBoost.png",
	},
	[315] = {
		name = "Sex Change",
		description = [[<i>Turns your female character into a male one - or vice versa.</i>

{character}
{activated}
{info} you will keep all outfits you have purchased or earned in quest]],
		publishedAt = 24,

		packages = {
			[1] = {
				amount = 1,
				price = 120,
				currency = 0,
				offerId = 24,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_DEFAULT,
		image = "Product_CharacterSexChange.png",
	},
	[316] = {
		name = "Name Change",
		description = [[<i>Tired of your current character name? Purchase a new one!</i>

{character}
{info} relog required after purchase to finalise the name change]],
		publishedAt = 30,

		packages = {
			[1] = {
				amount = 1,
				price = 250,
				currency = 0,
				offerId = 30,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_DEFAULT,
		image = "Product_CharacterNameChange.png",
	},
	[317] = {
		name = "Main Character Change",
		description = [[Make one of your characters your new main character!

{info} select your new main character during the purchase
{info} your new main character may not be hidden, scheduled for deletion or a Tournament character]],
		publishedAt = 7267041,

		packages = {
			[1] = {
				amount = 1,
				price = 250,
				currency = 0,
				offerId = 7267041,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_DEFAULT,
		image = "Product_MainCharacterChange.png",
	},
	[318] = {
		name = "World Transfer",
		description = [[<i>Use a Character World Transfer to move your character to a new game world if you have not transferred this character within the last 6 months.</i>

{character}
{info} destination world can still be changed on the game website after the purchase
{info} talk to NPC Sharon and log out on the transfer platform to finalise the transfer

{info} restrictions for a Character World Transfer:
&#8226; characters can only transfer to game worlds with the same or stricter PvP rules
&#8226; characters may not have a red or black skull
&#8226; characters may not be guild leaders, own a house or have open Store Coin offers in the Market]],
		publishedAt = 46,

		packages = {
			[1] = {
				amount = 1,
				price = 750,
				currency = 0,
				offerId = 46,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_DEFAULT,
		image = "Product_CharacterWorldTransfer.png",
	},
	[319] = {
		name = "Express World Transfer",
		description = [[<i>Use an Express Character World Transfer to move your character to a new game world if you have already transferred this character within the last 6 months.</i>

{character}
{info} destination world can still be changed on the game website after the purchase
{info} talk to NPC Sharon and log out on the transfer platform to finalise the transfer

{info} restrictions for an Express Character World Transfer:
&#8226; characters can only transfer to game worlds with the same or stricter PvP rules
&#8226; characters may not have a red or black skull
&#8226; characters may not be guild leaders, own a house or have open Store Coin offers in the Market]],
		publishedAt = 393,

		packages = {
			[1] = {
				amount = 1,
				price = 1500,
				currency = 0,
				offerId = 393,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_DEFAULT,
		image = "Product_ExpressCharacterWorldTransfer.png",
	},
	[320] = {
		name = "Magic Gold Converter",
		description = [[<i>Changes automatically either a stack of 100 gold pieces into 1 platinum coin, or a stack of 100 platinum coins into 1 crystal coin!</i>

{character}
{storeinbox}
{useicon} use it to activate or deactivate the automatic conversion
{info} converts all stacks of 100 gold or platinum in the inventory whenever it is activated
{info} deactivated upon purchase
{info} usable for 500 conversions a piece]],
		publishedAt = 1525762802,

		packages = {
			[1] = {
				amount = 1,
				price = 15,
				currency = 0,
				offerId = 7262830,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 31181,
	},
	[321] = {
		name = "Charm Expansion",
		description = [[<i>Assign as many of your unlocked Charms as you like and get a 25% discount whenever you are removing a Charm from a creature!</i>

{character}
{once}]],
		publishedAt = 1513674000,

		packages = {
			[1] = {
				amount = 1,
				price = 450,
				currency = 0,
				offerId = 7261766,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_DEFAULT,
		image = "Product_UsefulThings_UnlimitedBonusUsage.png",
	},
	[322] = {
		name = "Instant Reward Access",
		description = [[<i>No matter where you are, claim your daily reward on the spot!</i>

{character}
{info} added to your reward wall
{limit|90}]],
		publishedAt = 1502179200,

		packages = {
			[1] = {
				amount = 30,
				price = 100,
				currency = 0,
				offerId = 7237746,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_DEFAULT,
		image = "Product_UsefulThings_CollectionTokens.png",
	},
	[323] = {
		name = "Permanent Prey Slot",
		description = [[<i>Get an additional prey slot to activate additional prey!</i>

{character}
{limit|3}
{info} added directly to Prey dialog]],
		publishedAt = 1482224400,

		packages = {
			[1] = {
				amount = 1,
				price = 900,
				currency = 0,
				offerId = 35689,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_DEFAULT,
		image = "Product_UsefulThings_PermanentPreySlot.png",
	},
	[324] = {
		name = "Permanent Hunting Task Slot",
		description = [[Get an additional Prey Hunting Task slot to activate additional hunting tasks!
{character}
{limit|3}
{info} added directly to Hunting Tasks tab in the Prey dialog]],
		publishedAt = 1576486800,

		packages = {
			[1] = {
				amount = 1,
				price = 750,
				currency = 0,
				offerId = 40000935,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_DEFAULT,
		image = "Product_UsefulThings_PermanentHuntingTaskSlot.png",
	},
	[325] = {
		name = "Gold Pouch",
		description = [[<i>Carries as many gold, platinum or crystal coins as your capacity allows, however, no other items.</i>

{character}
{storeinbox}
{once}
{useicon} use it to open it
{info} always placed on the first position of your Store inbox]],
		publishedAt = 1474963200,

		packages = {
			[1] = {
				amount = 1,
				price = 900,
				currency = 0,
				offerId = 3536,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 26377,
	},
	[326] = {
		name = "Gold Converter",
		description = [[<i>Changes either a stack of 100 gold pieces into 1 platinum coin, or a stack of 100 platinum coins into 1 crystal coin!</i>

{character}
{storeinbox}
{useicon} use it on a stack of 100 to change it to the superior currency
{info} usable 500 times a piece]],
		publishedAt = 1474963200,

		packages = {
			[1] = {
				amount = 1,
				price = 5,
				currency = 0,
				offerId = 3543,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 26378,
	},
	[327] = {
		name = "Temple Teleport",
		description = [[<i>Teleports you instantly to your home temple.</i>

{character}
{useicon} use it to teleport you to your home temple
{battlesignicon} cannot be used while having a battle sign or a protection zone block
{info} does not work in no-logout zones or close to a character's home temple]],
		publishedAt = 1268,

		packages = {
			[1] = {
				amount = 1,
				price = 15,
				currency = 0,
				offerId = 1268,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_DEFAULT,
		image = "Product_Transportation_TempleTeleport.png",
	},
	[328] = {
		name = "Prey Wildcard",
		description = [[<i>Use Prey Wildcards to reroll the bonus of an active prey, to lock your active prey or to select a prey of your choice.</i>

{character}
{info} added directly to Prey dialog
{limit|50}]],
		publishedAt = 1482224400,

		packages = {
			[1] = {
				amount = 5,
				price = 50,
				currency = 0,
				offerId = 7264826,
				status = 0,
			},
			[2] = {
				amount = 20,
				price = 200,
				currency = 0,
				offerId = 7264829,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_DEFAULT,
		image = "Product_UsefulThings_PreyBonusReroll.png",
	},
	[329] = {
		name = "Restricted Tournament Ticket",
		description = [[Buy a ticket for the upcoming Tournament - world type: restricted Store. The ticket will be automatically redeemed by your character created for this Tournament world type.
{limiticon} can only be owned once per account
{activated}]],
		publishedAt = 1584435600,

		packages = {
			[1] = {
				amount = 1,
				price = 300,
				currency = 0,
				offerId = 7266419,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_DEFAULT,
		image = "Product_RestrictedTournamentTicket.png",
	},
	[330] = {
		name = "Gilded Warlord Sword",
		description = [[{house}
{box}
{storeinbox}
{backtoinbox}]],
		publishedAt = 1662451200,

		packages = {
			[1] = {
				amount = 1,
				price = 1500,
				currency = 2,
				offerId = 40016308,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
	},
	[331] = {
		name = "Gilded Horned Helmet",
		description = [[{house}
{box}
{storeinbox}
{backtoinbox}]],
		publishedAt = 1650441600,

		packages = {
			[1] = {
				amount = 1,
				price = 1500,
				currency = 2,
				offerId = 40014238,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 41788,
	},
	[332] = {
		name = "Gilded Blessed Shield",
		description = [[{house}
{box}
{storeinbox}
{backtoinbox}]],
		publishedAt = 1636358400,

		packages = {
			[1] = {
				amount = 1,
				price = 1500,
				currency = 2,
				offerId = 40010698,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 39821,
	},
	[333] = {
		name = "Gilded Magic Longsword",
		description = [[{house}
{box}
{storeinbox}
{backtoinbox}]],
		publishedAt = 1625731200,

		packages = {
			[1] = {
				amount = 1,
				price = 1500,
				currency = 2,
				offerId = 40008481,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 39651,
	},
	[334] = {
		name = "Gilded Crown",
		description = [[{house}
{box}
{storeinbox}
{backtoinbox}]],
		publishedAt = 1598860800,

		packages = {
			[1] = {
				amount = 1,
				price = 1500,
				currency = 2,
				offerId = 40002125,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 36988,
	},
	[335] = {
		name = "Baby Brain Squid",
		description = [[{house}
{box}
{storeinbox}
{use}
{backtoinbox}]],
		publishedAt = 1588320000,

		packages = {
			[1] = {
				amount = 1,
				price = 800,
				currency = 2,
				offerId = 40001445,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 35565,
	},
	[336] = {
		name = "Baby Vulcongra",
		description = [[{house}
{box}
{storeinbox}
{use}
{backtoinbox}]],
		publishedAt = 1588320000,

		packages = {
			[1] = {
				amount = 1,
				price = 800,
				currency = 2,
				offerId = 40001446,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 35564,
	},
	[337] = {
		name = "Guzzlemaw Grub",
		description = [[{house}
{box}
{storeinbox}
{use}
{backtoinbox}]],
		publishedAt = 1588320000,

		packages = {
			[1] = {
				amount = 1,
				price = 800,
				currency = 2,
				offerId = 40001447,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 35563,
	},
	[338] = {
		name = "Demon Doll",
		description = [[{house}
{box}
{storeinbox}
{use}
{backtoinbox}]],
		publishedAt = 1588320000,

		packages = {
			[1] = {
				amount = 1,
				price = 400,
				currency = 2,
				offerId = 40001448,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 35574,
	},
	[339] = {
		name = "Vexclaw Doll",
		description = [[{house}
{box}
{storeinbox}
{use}
{backtoinbox}]],
		publishedAt = 1588320000,

		packages = {
			[1] = {
				amount = 1,
				price = 400,
				currency = 2,
				offerId = 40001449,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 35599,
	},
	[340] = {
		name = "Ogre Rowdy Doll",
		description = [[{house}
{box}
{storeinbox}
{use}
{backtoinbox}]],
		publishedAt = 1588320000,

		packages = {
			[1] = {
				amount = 1,
				price = 400,
				currency = 2,
				offerId = 40001450,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 35600,
	},
	[341] = {
		name = "Retching Horror Doll",
		description = [[{house}
{box}
{storeinbox}
{use}
{backtoinbox}]],
		publishedAt = 1588320000,

		packages = {
			[1] = {
				amount = 1,
				price = 400,
				currency = 2,
				offerId = 40001451,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 35601,
	},
	[342] = {
		name = "Cozy Couch Right End",
		description = [[{house}
{box}
{storeinbox}
{backtoinbox}]],
		publishedAt = 1588320000,

		packages = {
			[1] = {
				amount = 1,
				price = 100,
				currency = 2,
				offerId = 40001456,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 35612,
	},
	[343] = {
		name = "Cozy Couch Corner",
		description = [[{house}
{box}
{storeinbox}
{backtoinbox}]],
		publishedAt = 1588320000,

		packages = {
			[1] = {
				amount = 1,
				price = 100,
				currency = 2,
				offerId = 40001455,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 35620,
	},
	[344] = {
		name = "Cozy Couch",
		description = [[{house}
{box}
{storeinbox}
{backtoinbox}]],
		publishedAt = 1588320000,

		packages = {
			[1] = {
				amount = 1,
				price = 100,
				currency = 2,
				offerId = 40001454,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 35604,
	},
	[345] = {
		name = "Cozy Couch Left End",
		description = [[{house}
{box}
{storeinbox}
{backtoinbox}]],
		publishedAt = 1588320000,

		packages = {
			[1] = {
				amount = 1,
				price = 100,
				currency = 2,
				offerId = 40001453,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 35608,
	},
	[346] = {
		name = "Cozy Couch Round",
		description = [[{house}
{box}
{storeinbox}
{backtoinbox}]],
		publishedAt = 1588320000,

		packages = {
			[1] = {
				amount = 1,
				price = 100,
				currency = 2,
				offerId = 40001452,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 35616,
	},
	[347] = {
		name = "Carved Table Centre",
		description = [[{house}
{box}
{storeinbox}
{backtoinbox}]],
		publishedAt = 1588320000,

		packages = {
			[1] = {
				amount = 1,
				price = 100,
				currency = 2,
				offerId = 40001459,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 35630,
	},
	[348] = {
		name = "Carved Table Corner",
		description = [[{house}
{box}
{storeinbox}
{backtoinbox}]],
		publishedAt = 1588320000,

		packages = {
			[1] = {
				amount = 1,
				price = 100,
				currency = 2,
				offerId = 40001457,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 35625,
	},
	[349] = {
		name = "Carved Table",
		description = [[{house}
{box}
{storeinbox}
{backtoinbox}]],
		publishedAt = 1588320000,

		packages = {
			[1] = {
				amount = 1,
				price = 100,
				currency = 2,
				offerId = 40001458,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 35628,
	},
	[350] = {
		name = "Full Dragon Slayer Outfit",
		description = [[{account}
{info} colours can be changed using the Outfit dialog
{info} includes basic outfit and 2 addons which can be selected individually

<i>The souls of countless slain dragons have been fused over the years with this armour, wrought from the impervious scales of the ancestors of those very same beings, wicked and wise, winged and wild. The Dragon Slayer Outfit has seen an unfathomable amount of bloodshed, but it pales in comparison to the untold lives lost in the strife over the armour itself. Only the mightiest warriors can even begin to dream of ever owning this exceedingly rare token of power.</i>]],
		publishedAt = 1588320000,

		packages = {
			[1] = {
				amount = 1,
				price = 5000,
				currency = 2,
				offerId = 40001414,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_OUTFIT,
		lookType = 1288,
		lookHead = 95,
		lookBody = 113,
		lookLegs = 39,
		lookFeet = 115,
	},
	[351] = {
		name = "Sublime Tournament Accolade",
		description = [[{house}
{box}
{storeinbox}
{backtoinbox}]],
		publishedAt = 1556697600,

		packages = {
			[1] = {
				amount = 1,
				price = 500,
				currency = 2,
				offerId = 7266904,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 34129,
	},
	[352] = {
		name = "Tournament Accolade",
		description = [[{house}
{box}
{storeinbox}
{backtoinbox}]],
		publishedAt = 1556697600,

		packages = {
			[1] = {
				amount = 1,
				price = 500,
				currency = 2,
				offerId = 7266902,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 34127,
	},
	[353] = {
		name = "Tournament Carpet",
		description = desc_carpet,
		publishedAt = 1556697600,

		packages = {
			[1] = {
				amount = 1,
				price = 70,
				currency = 2,
				offerId = 7266898,
				status = 0,
			},
			[2] = {
				amount = 5,
				price = 350,
				currency = 2,
				offerId = 7266900,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 34124,
	},
	[354] = {
		name = "Sublime Tournament Carpet",
		description = desc_carpet,
		publishedAt = 1556697600,

		packages = {
			[1] = {
				amount = 1,
				price = 70,
				currency = 2,
				offerId = 7266894,
				status = 0,
			},
			[2] = {
				amount = 5,
				price = 350,
				currency = 2,
				offerId = 7266896,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 34125,
	},
	[355] = {
		name = "Cerberus Champion Puppy",
		description = [[{house}
{box}
{storeinbox}
{use}
{backtoinbox}]],
		publishedAt = 1556697600,

		packages = {
			[1] = {
				amount = 1,
				price = 800,
				currency = 2,
				offerId = 7266892,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 34120,
	},
	[356] = {
		name = "Cerberus Champion",
		description = [[{account}
{speedboost}

<i>A fierce and grim guardian of the underworld has risen to fight side by side with the bravest warriors in order to send evil creatures into the realm of the dead. The three headed Cerberus Champion is constantly baying for blood and using its sharp fangs it easily rips apart even the strongest armour and shield.</i>]],
		publishedAt = 1556697600,

		packages = {
			[1] = {
				amount = 1,
				price = 1250,
				currency = 2,
				offerId = 7266753,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1209,
	},
	[357] = {
		name = "Full Void Master Outfit",
		description = [[{account}
{info} colours can be changed using the Outfit dialog
{info} includes basic outfit and 2 addons which can be selected individually

<i>According to ancient rumours, the pulsating orb that the Void Master balances skilfully on the tip of his staff consists of powerful cosmic spheres. If you gaze too long into the infinite emptiness inside the orb, its powers will absorb your mind.</i>]],
		publishedAt = 1556697600,

		packages = {
			[1] = {
				amount = 1,
				price = 1750,
				currency = 2,
				offerId = 7266646,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_OUTFIT,
		lookType = 1202,
		lookHead = 95,
		lookBody = 113,
		lookLegs = 39,
		lookFeet = 115,
	},
	[358] = {
		name = "Full Lion of War Outfit",
		description = [[{account}
{info} colours can be changed using the Outfit dialog
{info} includes basic outfit and 2 addons which can be selected individually

<i>The Lion of War has fought on countless battlefields and never lost once. Enemies tremble with fear when he batters his sword against his almighty shield. Realising that a Lion of War knows no mercy, his opponents often surrender before the battle even begins.</i>]],
		publishedAt = 1556697600,

		packages = {
			[1] = {
				amount = 1,
				price = 1750,
				currency = 2,
				offerId = 7266655,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_OUTFIT,
		lookType = 1206,
		lookHead = 95,
		lookBody = 113,
		lookLegs = 39,
		lookFeet = 115,
	},
	[359] = {
		name = "Full Veteran Paladin Outfit",
		description = [[{account}
{info} colours can be changed using the Outfit dialog
{info} includes basic outfit and 2 addons which can be selected individually

<i>A Veteran Paladin has mastered the art of distance fighting. No matter how far away his prey may be, a marksman like the Veteran Paladin will always hit with extraordinary precision. No one can escape his keen hawk-eyed vision and even small stones become deadly weapons in his hands.</i>]],
		publishedAt = 1556697600,

		packages = {
			[1] = {
				amount = 1,
				price = 1750,
				currency = 2,
				offerId = 7266653,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_OUTFIT,
		lookType = 1204,
		lookHead = 95,
		lookBody = 113,
		lookLegs = 39,
		lookFeet = 115,
	},
	[360] = {
		name = "Jousting Eagle",
		description = [[{account}
{speedboost}

<i>High above the clouds far away from dry land, the training of giant eagles takes place. Only the cream of the crop is able to survive in such harsh environment long enough to call themselves Jousting Eagles while the weaklings find themselves at the bottom of the sea. The tough ones become noble and graceful mounts that are well known for their agility and endurance.</i>]],
		publishedAt = 1556697600,

		packages = {
			[1] = {
				amount = 1,
				price = 1250,
				currency = 2,
				offerId = 7266657,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_MOUNT,
		lookType = 1208,
	},
	[361] = {
		name = "Jousting Eagle Baby",
		description = [[{house}
{box}
{storeinbox}
{use}
{backtoinbox}]],
		publishedAt = 1556697600,

		packages = {
			[1] = {
				amount = 1,
				price = 800,
				currency = 2,
				offerId = 7266755,
				status = 0,
			},
		},
		type = STORE_OFFER_TYPE_ITEM,
		itemId = 34118,
	},
}
