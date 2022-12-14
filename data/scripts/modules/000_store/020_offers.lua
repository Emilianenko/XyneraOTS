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

StoreDescBed = [[<i>Sleep in a bed to restore soul, mana and hit points and to train your skills!</i>

{house}
{boxicon} comes in 2 boxes which can only be unwrapped by purchasing character, put the 2 parts together to get a functional bed
{storeinbox}
{usablebyallicon} if not already occupied, it can be used by every Premium character that has access to the house
{useicon} use it to sleep in it
{backtoinbox}]]

local desc_decoration = [[{house}
{box}
{storeinbox}
{backtoinbox}]]

local desc_decoration_useable = [[{house}
{box}
{storeinbox}
{use}
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
				-- disbaledReasons = {reasonId},
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
		description = StoreDescBed,
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
		description = StoreDescBed,
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
}
