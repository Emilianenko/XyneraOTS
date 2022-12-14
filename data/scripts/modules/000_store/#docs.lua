--[[
	-- client description variables
	store_description_placeholder_account
	store_description_placeholder_activated
	store_description_placeholder_backtoinbox
	store_description_placeholder_battlesign
	store_description_placeholder_battlesignicon
	store_description_placeholder_box
	store_description_placeholder_boxicon
	store_description_placeholder_capacity
	store_description_placeholder_character
	store_description_placeholder_house
	store_description_placeholder_info
	store_description_placeholder_limit
	store_description_placeholder_limiticon
	store_description_placeholder_once
	store_description_placeholder_speedboost
	store_description_placeholder_storeinbox
	store_description_placeholder_storeinboxicon
	store_description_placeholder_transferableprice
	store_description_placeholder_usablebyall
	store_description_placeholder_usablebyallicon
	store_description_placeholder_use
	store_description_placeholder_useicon
	store_description_placeholder_vocationlevelcheck

	---- 13.10 protocol
	-- EMPTY PLACEHOLDER PAGE
		local msg = NetworkMessage()
		msg:addByte(0xFC)
		msg:addString("") -- tabName
		msg:addU32(0) -- offerId
		msg:addByte(0) -- sort type
		msg:addByte(0) -- menu count

		msg:addString("") -- tab name
		msg:addU16(0) -- menu count
		msg:addU16(0) -- ?
		msg:sendToPlayer(self)

	-- EMPTY HOME PAGE (estimated)
		local msg = NetworkMessage()
		msg:addByte(0xFC)
		msg:addString("Home") -- tabName
		msg:addU32(0) -- offerId
		msg:addByte(0) -- sort type
		msg:addByte(0) -- menu count

		msg:addString("") -- tab name
		msg:addU16(0) -- menu count
		msg:addByte(0)
		msg:addByte(0)
		msg:addByte(0)
		msg:addByte(0)
		msg:sendToPlayer(self)
]]


--[[
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
		description = desc_decoration,
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
		description = desc_decoration,
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
		description = desc_decoration,
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
		description = desc_decoration,
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
		description = desc_decoration,
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
		description = desc_decoration_useable,
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
		description = desc_decoration_useable,
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
		description = desc_decoration_useable,
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
		description = desc_decoration_useable,
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
		description = desc_decoration_useable,
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
		description = desc_decoration_useable,
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
		description = desc_decoration_useable,
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
		description = desc_decoration,
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
		description = desc_decoration,
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
		description = desc_decoration,
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
		description = desc_decoration,
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
		description = desc_decoration,
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
		description = desc_decoration,
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
		description = desc_decoration,
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
		description = desc_decoration,
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
		description = desc_decoration,
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
		description = desc_decoration,
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
		description = desc_decoration_useable,
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
		description = desc_decoration_useable,
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
	]]