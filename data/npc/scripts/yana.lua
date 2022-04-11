local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

local shop = {
	{id=30686, buy=50, sell=0, name='axe of desctruction'},
	{id=30684, buy=50, sell=0, name='blade of desctruction'},
	{id=30690, buy=50, sell=0, name='bow of desctruction'},
	{id=30687, buy=50, sell=0, name='chopper of desctruction'},
	{id=30691, buy=50, sell=0, name='crossbow of desctruction'},
	{id=30689, buy=50, sell=0, name='hammer of desctruction'},
	{id=30688, buy=50, sell=0, name='mace of desctruction'},
	{id=30693, buy=50, sell=0, name='rod of desctruction'},
	{id=30685, buy=50, sell=0, name='slayer of desctruction'},
	{id=30692, buy=50, sell=0, name='wand of desctruction'},
}

local function setNewTradeTable(table)
	local items, item = {}
	for i = 1, #table do
		item = table[i]
		items[item.id] = {id = item.id, buy = item.buy, sell = item.sell, subType = 0, name = item.name}
	end
	return items
end

local function onBuy(cid, item, subType, amount, ignoreCap, inBackpacks)
	local player = Player(cid)
	local itemsTable = setNewTradeTable(shop)
	if not ignoreCap and player:getFreeCapacity() < ItemType(itemsTable[item].id):getWeight(amount) then
		return player:sendTextMessage(MESSAGE_FAILURE, "You don't have enough cap.")
	end
	if itemsTable[item].buy then
		if player:removeItem(Npc():getCurrency(), amount * itemsTable[item].buy) then
			if amount > 1 then
				currencyName = ItemType(Npc():getCurrency()):getPluralName():lower()
			else
				currencyName = ItemType(Npc():getCurrency()):getName():lower()
			end
			player:addItem(itemsTable[item].id, amount)
			return player:sendTextMessage(MESSAGE_TRADE,
						"Bought "..amount.."x "..itemsTable[item].name.." for "..itemsTable[item].buy * amount.." "..currencyName..".")
		else
			return player:sendTextMessage(MESSAGE_TRADE, "You don't have enough "..currencyName..".")
		end
	end

	return true
end

local function onSell(cid, item, subType, amount, ignoreCap, inBackpacks)
	return true
end

local products = {
	-----------------------------------------------------------------
	['strike'] = {
		['basic'] =  {
			text = "The basic bundle for the strike imbuement consists of 20 protective charms. Would you like to buy it for 2 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?",
			itens = {
				[1] = {id = 12400, amount = 20}
			},
			value = 2
		},
		['intricate'] =  {
			text = "The intricate bundle for the strike imbuement consists of 20 protective charms and 25 sabreteeth. Would you like to buy it for 4 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?",
			itens = {
				[1] = {id = 12400, amount = 20},
				[2] = {id = 11228, amount = 25}
			},
			value = 4
		},
		['powerful'] = {
			text = "The powerful bundle for the strike imbuement consists of 20 protective charms, 25 sabreteeth and 5 vexclaw talons. Would you like to buy it for 6 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?",
			itens = {
				[1] = {id = 12400, amount = 20},
				[2] = {id = 11228, amount = 25},
				[3] = {id = 25384, amount = 5}
			},
			value = 6
		}
	},
	 ----------------------------------------------------------------- 
	['vampirism'] = {
		['basic'] =  {
			text = "The basic bundle for the vampirism imbuement consists of 25 vampire teeth. Would you like to buy it for 2 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?",
			itens = {
				[1] = {id = 10602, amount = 25}
			},
			value = 2
		},
		['intricate'] =  {
			text = "The intricate bundle for the strike imbuement consists of 20 protective charms and 25 sabreteeth. Would you like to buy it for 4 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?",
			itens = {
				[1] = {id = 10602, amount = 25},
				[2] = {id = 10550, amount = 15}
			},
			value = 4
		},
		['powerful'] = {
			text = "The powerful bundle for the vampirism imbuement consists of 25 vampire teeth, 15 bloody pincers and 5 pieces of dead brain. Would you like to it for 6 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?",
			itens = {
				[1] = {id = 10602, amount = 25},
				[2] = {id = 10550, amount = 15},
				[3] = {id = 10580, amount = 5}
			},
			value = 6
		}
	},
	     -----------------------------------------------------------------
	['void'] = {
		['basic'] =  {
			text = "The basic bundle for the void imbuement consists of 25 rope belts. Would you like to buy it for 2 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?",
			itens = {
				[1] = {id = 12448, amount = 25}
			},
			value = 2,
		},
		['intricate'] =  {
			text = "The intricate bundle for the void imbuement consists of 25 rope belts and 25 silencer claws. Would you like to buy it for 4 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?.",
			itens = {
				[1] = {id = 12448, amount = 25},
				[2] = {id = 22534, amount = 25}
			},
			value = 4,
		},
		['powerful'] = {
			text = "The powerful bundle for the void imbuement consists of 25 rope belts, 25 silencer claws and 5 grimeleech wings. Would you like to buy it for 6 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?",
			itens = {
				[1] = {id = 12448, amount = 25},
				[2] = {id = 22534, amount = 25},
				[3] = {id = 25386, amount = 5}
			},
			value = 6,
		}
	},
         -----------------------------------------------------------------
         ['epiphany'] = {
            ['basic'] =  {
                text = "The basic bundle for the epiphany imbuement consists of 25 elvish talismans. Would you like to buy it for 2 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?",
                itens = {
                    [1] = {id = 10552, amount = 25}
                },
                value = 2,
            },
            ['intricate'] =  {
                text = "The intricate bundle for the epiphany imbuement consists of 25 elvish talismans and 15 broken shamanic staffs. Would you like to buy it for 4 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?.",
                itens = {
                    [1] = {id = 10552, amount = 25},
                    [2] = {id = 12408, amount = 15}
                },
                value = 4,
            },
            ['powerful'] = {
                text = "The powerful bundle for the epiphany imbuement consists of 25 elvish talismans, 15 broken shamanic staffs and 15 strands of medusa hair. Would you like to buy it for 6 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?",
                itens = {
                    [1] = {id = 10552, amount = 25},
                    [2] = {id = 12408, amount = 15},
                    [3] = {id = 11226, amount = 15}
                },
                value = 6,
            }
        },
-----------------------------------------------------------------------------------------
['featherweight'] = {
	['basic'] =  {
		text = "The basic bundle for the featherweight imbuement consists of 20 fairy wings. Would you like to buy it for 2 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?",
		itens = {
			[1] = {id = 28999, amount = 20}
		},
		value = 2,
	},
	['intricate'] =  {
		text = "The intricate bundle for the featherweight imbuement consists of 20 fairy wings and 10 little bowl of myrrh.. Would you like to buy it for 4 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?.",
		itens = {
			[1] = {id = 28999, amount = 20},
			[2] = {id = 29007, amount = 10}
		},
		value = 4,
	},
	['powerful'] = {
		text = "The powerful bundle for the featherweight imbuement consists of 20 fairy wings, 10 little bowl of myrrh. and 5 goosebump leathers. Would you like to buy it for 6 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?",
		itens = {
			[1] = {id = 28999, amount = 20},
			[2] = {id = 29007, amount = 10},
			[3] = {id = 22539, amount = 5}
		},
		value = 6,
	}
},
 ------------------------------------------------------------------------------
 ['vibrancy'] = {
	['basic'] =  {
		text = "The basic bundle for the vibrancy imbuement consists of 20 wereboar hooves. Would you like to buy it for 2 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?",
		itens = {
			[1] = {id = 24709, amount = 20}
		},
		value = 2,
	},
	['intricate'] =  {
		text = "The intricate bundle for the vibrancy imbuement consists of 20 wereboar hooves and 15 crystallized anger. Would you like to buy it for 4 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?.",
		itens = {
			[1] = {id = 24709, amount = 20},
			[2] = {id = 26163, amount = 15}
		},
		value = 4,
	},
	['powerful'] = {
		text = "The powerful bundle for the vibrancy imbuement consists of 20 wereboar hooves, 15 crystallized anger and 5 quills. Would you like to buy it for 6 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?",
		itens = {
			[1] = {id = 24709, amount = 20},
			[2] = {id = 26163, amount = 15},
			[3] = {id = 33314, amount = 5}
		},
		value = 6,
	}
},
 ---------------------------------------------------------------------------------------
 ['swiftness'] = {
	['basic'] =  {
		text = "The basic bundle for the swiftness imbuement consists of 15 damselfly wings. Would you like to buy it for 2 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?",
		itens = {
			[1] = {id = 19738, amount = 15}
		},
		value = 2,
	},
	['intricate'] =  {
		text = "The intricate bundle for the swiftness imbuement consists of 15 damselfly wings and 25 compasses. Would you like to buy it for 4 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?.",
		itens = {
			[1] = {id = 19738, amount = 15},
			[2] = {id = 11219, amount = 25}
		},
		value = 4,
	},
	['powerful'] = {
		text = "The powerful bundle for the swiftness imbuement consists of 15 damselfly wings, 25 compasses and 20 waspoid wings. Would you like to buy it for 6 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?",
		itens = {
			[1] = {id = 19738, amount = 15},
			[2] = {id = 11219, amount = 25},
			[3] = {id = 15484, amount = 20}
		},
		value = 6,
	}
},
 ----------------------------------------------------------------------------
 ['scorch'] = {
	['basic'] =  {
		text = "The basic bundle for the scorch imbuement consists of 25 fiery hearts. Would you like to buy it for 2 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?",
		itens = {
			[1] = {id = 10553, amount = 25}
		},
		value = 2,
	},
	['intricate'] =  {
		text = "The intricate bundle for the scorch imbuement consists of 25 fiery hearts and 5 green dragon scales. Would you like to buy it for 4 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?.",
		itens = {
			[1] = {id = 10553, amount = 25},
			[2] = {id = 5920, amount = 5}
		},
		value = 4,
	},
	['powerful'] = {
		text = "The powerful bundle for the scorch imbuement consists of 25 fiery hearts, 5 green dragon scales and 5 demon horns. Would you like to buy it for 6 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?",
		itens = {
			[1] = {id = 10553, amount = 25},
			[2] = {id = 5920, amount = 5},
			[3] = {id = 5954, amount = 5}
		},
		value = 6,
	}
},
 ------------------------------------------------------------------------------
 ['venom'] = {
	['basic'] =  {
		text = "The basic bundle for the venom imbuement consists of 25 swamp grass. Would you like to buy it for 2 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?",
		itens = {
			[1] = {id = 10603, amount = 25}
		},
		value = 2,
	},
	['intricate'] =  {
		text = "The intricate bundle for the venom imbuement consists of 25 swamp grass and 20 poisonous slimes. Would you like to buy it for 4 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?.",
		itens = {
			[1] = {id = 10603, amount = 25},
			[2] = {id = 10557, amount = 20}
		},
		value = 4,
	},
	['powerful'] = {
		text = "The powerful bundle for the venom imbuement consists of 25 swamp grass, 20 poisonous slimes and 2 slime hearts. Would you like to buy it for 6 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?",
		itens = {
			[1] = {id = 10603, amount = 25},
			[2] = {id = 10557, amount = 20},
			[3] = {id = 23565, amount = 2}
		},
		value = 6,
	}
},
 ---------------------------------------------------------------------------
 ['frost'] = {
	['basic'] =  {
		text = "The basic bundle for the frost imbuement consists of 25 frosty hearts. Would you like to buy it for 2 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?",
		itens = {
			[1] = {id = 10578, amount = 25}
		},
		value = 2,
	},
	['intricate'] =  {
		text = "The intricate bundle for the frost imbuement consists of 25 frosty hearts and 10 seacrest hairs. Would you like to buy it for 4 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?.",
		itens = {
			[1] = {id = 10578, amount = 25},
			[2] = {id = 24170, amount = 10}
		},
		value = 4,
	},
	['powerful'] = {
		text = "The powerful bundle for the frost imbuement consists of 25 frosty hearts, 10 seacrest hairs and 5 polar bear paws. Would you like to buy it for 6 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?",
		itens = {
			[1] = {id = 10578, amount = 25},
			[2] = {id = 24170, amount = 10},
			[3] = {id = 10567, amount = 5}
		},
		value = 6,
	}
},
 -------------------------------------------------------------------------------------
 ['electrify'] = {
	['basic'] =  {
		text = "The basic bundle for the electrify imbuement consists of 25 rorc feathers. Would you like to buy it for 2 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?",
		itens = {
			[1] = {id = 21310, amount = 25}
		},
		value = 2,
	},
	['intricate'] =  {
		text = "The intricate bundle for the electrify imbuement consists of 25 rorc feathers and 5 peacock feather fans. Would you like to buy it for 4 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?.",
		itens = {
			[1] = {id = 21310, amount = 25},
			[2] = {id = 24631, amount = 5}
		},
		value = 4,
	},
	['powerful'] = {
		text = "The powerful bundle for the electrify imbuement consists of 25 rorc feathers, 5 peacock feather fans and 1 energy vein. Would you like to buy it for 6 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?",
		itens = {
			[1] = {id = 21310, amount = 25},
			[2] = {id = 24631, amount = 5},
			[3] = {id = 26164, amount = 1}
		},
		value = 6,
	}
},
 -------------------------------------------------------------------------------------
 ['reap'] = {
	['basic'] =  {
		text = "The basic bundle for the reap imbuement consists of 25 piles of grave earth. Would you like to buy it for 2 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?",
		itens = {
			[1] = {id = 12440, amount = 25}
		},
		value = 2,
	},
	['intricate'] =  {
		text = "The intricate bundle for the reap imbuement consists of 25 piles of grave earth and 20 demonic skeletal hands. Would you like to buy it for 4 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?.",
		itens = {
			[1] = {id = 12440, amount = 25},
			[2] = {id = 10564, amount = 20}
		},
		value = 4,
	},
	['powerful'] = {
		text = "The powerful bundle for the reap imbuement consists of 25 piles of grave earth, 20 demonic skeletal hands and 5 petrified scream. Would you like to buy it for 6 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?",
		itens = {
			[1] = {id = 12440, amount = 25},
			[2] = {id = 10564, amount = 20},
			[3] = {id = 11337, amount = 5}
		},
		value = 6,
	}
},
 -----------------------------------------------------------------------------------
 ['lich shroud'] = {
	['basic'] =  {
		text = "The basic bundle for the lich shroud imbuement consists of 25 flasks of embalming fluid. Would you like to buy it for 2 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?",
		itens = {
			[1] = {id = 12422, amount = 25}
		},
		value = 2,
	},
	['intricate'] =  {
		text = "The intricate bundle for the lich shroud imbuement consists of 25 flasks of embalming fluid and 20 gloom wolf furs. Would you like to buy it for 4 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?.",
		itens = {
			[1] = {id = 12422, amount = 25},
			[2] = {id = 24663, amount = 20}
		},
		value = 4,
	},
	['powerful'] = {
		text = "The powerful bundle for the lich shroud imbuement consists of 25 flasks of embalming fluid, 20 gloom wolf furs and 5 mystical hourglasses. Would you like to buy it for 6 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?",
		itens = {
			[1] = {id = 12422, amount = 25},
			[2] = {id = 24663, amount = 20},
			[3] = {id = 10577, amount = 5}
		},
		value = 6,
	}
},
 ---------------------------------------------------------------------------------------
 ['snake skin'] = {
	['basic'] =  {
		text = "The basic bundle for the snake skin imbuement consists of 25 pieces of swampling wood. Would you like to buy it for 2 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?",
		itens = {
			[1] = {id = 20103, amount = 25}
		},
		value = 2,
	},
	['intricate'] =  {
		text = "The intricate bundle for the snake skin imbuement consists of 25 pieces of swampling wood and 20 snake skins. Would you like to buy it for 4 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?.",
		itens = {
			[1] = {id = 20103, amount = 25},
			[2] = {id = 10611, amount = 20}
		},
		value = 4,
	},
	['powerful'] = {
		text = "The powerful bundle for the snake skin imbuement consists of 25 pieces of swampling wood, 20 snake skins and 10 brimstone fangs. Would you like to buy it for 6 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?",
		itens = {
			[1] = {id = 20103, amount = 25},
			[2] = {id = 10611, amount = 20},
			[3] = {id = 12658, amount = 10}
		},
		value = 6,
	}
},
 -----------------------------------------------------------------------------------
 ['dragon hide'] = {
	['basic'] =  {
		text = "The basic bundle for the dragon hide imbuement consists of 20 green dragon leather. Would you like to buy it for 2 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?",
		itens = {
			[1] = {id = 5877, amount = 20}
		},
		value = 2,
	},
	['intricate'] =  {
		text = "The intricate bundle for the dragon hide imbuement consists of 20 green dragon leather and 10 blazing bone. Would you like to buy it for 4 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?.",
		itens = {
			[1] = {id = 5877, amount = 20},
			[2] = {id = 18425, amount = 10}
		},
		value = 4,
	},
	['powerful'] = {
		text = "The powerful bundle for the dragon hide imbuement consists of 20 green dragon leather, 10 blazing bone and 5 draken sulphur. Would you like to buy it for 6 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?",
		itens = {
			[1] = {id = 5877, amount = 20},
			[2] = {id = 18425, amount = 10},
			[3] = {id = 12614, amount = 5}
		},
		value = 6,
	}
},
 -----------------------------------------------------------------------------------------
 ['quara scale'] = {
	['basic'] =  {
		text = "The basic bundle for the quara scale imbuement consists of 25 winter wolf furs. Would you like to buy it for 2 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?",
		itens = {
			[1] = {id = 11212, amount = 25}
		},
		value = 2,
	},
	['intricate'] =  {
		text = "The intricate bundle for the quara scale imbuement consists of 25 winter wolf furs and 15 thick fur. Would you like to buy it for 4 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?.",
		itens = {
			[1] = {id = 11212, amount = 25},
			[2] = {id = 11224, amount = 15}
		},
		value = 4,
	},
	['powerful'] = {
		text = "The powerful bundle for the quara scale imbuement consists of 25 winter wolf furs, 15 thick fur and 10 deepling warts. Would you like to buy it for 6 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?",
		itens = {
			[1] = {id = 11212, amount = 25},
			[2] = {id = 11224, amount = 15},
			[3] = {id = 15425, amount = 10}
		},
		value = 6,
	}
},
 ---------------------------------------------------------------------------------------
 ['cloud fabric'] = {
	['basic'] =  {
		text = "The basic bundle for the cloud fabric imbuement consists of 20 wyvern talismans. Would you like to buy it for 2 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?",
		itens = {
			[1] = {id = 10561, amount = 20}
		},
		value = 2,
	},
	['intricate'] =  {
		text = "The intricate bundle for the cloud fabric imbuement consists of 20 wyvern talismans and 15 crawler head platings. Would you like to buy it for 4 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?.",
		itens = {
			[1] = {id = 10561, amount = 20},
			[2] = {id = 15482, amount = 15}
		},
		value = 4,
	},
	['powerful'] = {
		text = "The powerful bundle for the cloud fabric imbuement consists of 20 wyvern talismans, 15 crawler head platings and 10 wyrm scales. Would you like to buy it for 6 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?",
		itens = {
			[1] = {id = 10561, amount = 20},
			[2] = {id = 15482, amount = 15},
			[3] = {id = 10582, amount = 10}
		},
		value = 6,
	}
},
 -------------------------------------------------------------------------------------------
 ['demon presence'] = {
	['basic'] =  {
		text = "The basic bundle for the demon presence imbuement consists of 25 cultish robes. Would you like to buy it for 2 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?",
		itens = {
			[1] = {id = 10556, amount = 25}
		},
		value = 2,
	},
	['intricate'] =  {
		text = "The intricate bundle for the demon presence imbuement consists of 25 cultish robes and 25 cultish masks. Would you like to buy it for 4 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?.",
		itens = {
			[1] = {id = 10556, amount = 25},
			[2] = {id = 10555, amount = 25}
		},
		value = 4,
	},
	['powerful'] = {
		text = "The powerful bundle for the demon presence imbuement consists of 25 cultish robes, 25 cultish masks and 20 hellspawn tails. Would you like to buy it for 6 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?",
		itens = {
			[1] = {id = 10556, amount = 25},
			[2] = {id = 10555, amount = 25},
			[3] = {id = 11221, amount = 20}
		},
		value = 6,
	}
},
 --------------------------------------------------------------------------------------------
 ['chop'] = {
	['basic'] =  {
		text = "The basic bundle for the chop imbuement consists of 20 orc teeth. Would you like to buy it for 2 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?",
		itens = {
			[1] = {id = 11113, amount = 20}
		},
		value = 2,
	},
	['intricate'] =  {
		text = "The intricate bundle for the chop imbuement consists of 20 orc teeth and 25 battle stones. Would you like to buy it for 4 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?.",
		itens = {
			[1] = {id = 11113, amount = 20},
			[2] = {id = 12403, amount = 25}
		},
		value = 4,
	},
	['powerful'] = {
		text = "The powerful bundle for the chop imbuement consists of 20 orc teeth, 25 battle stones and 20 moohtant horns. Would you like to buy it for 6 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?",
		itens = {
			[1] = {id = 11113, amount = 20},
			[2] = {id = 12403, amount = 25},
			[3] = {id = 23571, amount = 20}
		},
		value = 6,
	}
},
 ------------------------------------------------------------------------------------------------
 ['slash'] = {
	['basic'] =  {
		text = "The basic bundle for the slash imbuement consists of 25 lion's manes. Would you like to buy it for 2 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?",
		itens = {
			[1] = {id = 10608, amount = 25}
		},
		value = 2,
	},
	['intricate'] =  {
		text = "The intricate bundle for the slash imbuement consists of 25 lion's manes and 25 mooh'tah shells. Would you like to buy it for 4 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?.",
		itens = {
			[1] = {id = 10608, amount = 25},
			[2] = {id = 23573, amount = 25}
		},
		value = 4,
	},
	['powerful'] = {
		text = "The powerful bundle for the slash imbuement consists of 25 lion's manes, 25 mooh'tah shells and 5 war crystals. Would you like to buy it for 6 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?",
		itens = {
			[1] = {id = 10608, amount = 25},
			[2] = {id = 23573, amount = 25},
			[3] = {id = 10571, amount = 5}
		},
		value = 6,
	}
},
 -------------------------------------------------------------------------------------------------
 ['bash'] = {
	['basic'] =  {
		text = "The basic bundle for the bash imbuement consists of 20 cyclops toes. Would you like to buy it for 2 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?",
		itens = {
			[1] = {id = 10574, amount = 20}
		},
		value = 2,
	},
	['intricate'] =  {
		text = "The intricate bundle for the bash imbuement consists of 20 cyclops toes and 15 ogre nose rings. Would you like to buy it for 4 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?.",
		itens = {
			[1] = {id = 10574, amount = 20},
			[2] = {id = 24845, amount = 15}
		},
		value = 4,
	},
	['powerful'] = {
		text = "The powerful bundle for the bash imbuement consists of 20 cyclops toes, 15 ogre nose rings and 10 warmaster's wristguards. Would you like to buy it for 6 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?",
		itens = {
			[1] = {id = 10574, amount = 20},
			[2] = {id = 24845, amount = 15},
			[3] = {id = 11322, amount = 10}
		},
		value = 6,
	}
},
 ------------------------------------------------------------------------------------------------
 ['precision'] = {
	['basic'] =  {
		text = "The basic bundle for the precision imbuement consists of 25 elven scouting glasss. Would you like to buy it for 2 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?",
		itens = {
			[1] = {id = 12420, amount = 25}
		},
		value = 2,
	},
	['intricate'] =  {
		text = "The intricate bundle for the precision imbuement consists of 25 elven scouting glasss and 20 elven hooves. Would you like to buy it for 4 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?.",
		itens = {
			[1] = {id = 12420, amount = 25},
			[2] = {id = 21311, amount = 20}
		},
		value = 4,
	},
	['powerful'] = {
		text = "The powerful bundle for the precision imbuement consists of 25 elven scouting glasss, 20 elven hooves and 10 metal spikes. Would you like to buy it for 6 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?",
		itens = {
			[1] = {id = 12420, amount = 25},
			[2] = {id = 21311, amount = 20},
			[3] = {id = 11215, amount = 10}
		},
		value = 6,
	}
},
 --------------------------------------------------------------------------------------------
 ['blockade'] = {
	['basic'] =  {
		text = "The basic bundle for the blockade imbuement consists of 20 pieces of scarab shell. Would you like to buy it for 2 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?",
		itens = {
			[1] = {id = 10558, amount = 20}
		},
		value = 2,
	},
	['intricate'] =  {
		text = "The intricate bundle for the blockade imbuement consists of 20 pieces of scarab shell and 25 brimstone shells. Would you like to buy it for 4 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?.",
		itens = {
			[1] = {id = 10558, amount = 20},
			[2] = {id = 12659, amount = 25}
		},
		value = 4,
	},
	['powerful'] = {
		text = "The powerful bundle for the blockade imbuement consists of 20 pieces of scarab shell, 25 brimstone shells and 25 frazzle skins. Would you like to buy it for 6 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?",
		itens = {
			[1] = {id = 10558, amount = 20},
			[2] = {id = 12659, amount = 25},
			[3] = {id = 22533, amount = 25}
		},
		value = 6,
	}
},
-----------------------------------------------------------------------------------------


}

local answerType = {}
local answerLevel = {}

function onCreatureAppear(cid)
	npcHandler:onCreatureAppear(cid)
end
function onCreatureDisappear(cid)
	npcHandler:onCreatureDisappear(cid)
end
function onCreatureSay(cid, type, msg)
	npcHandler:onCreatureSay(cid, type, msg)
end
function onThink()
	npcHandler:onThink()
end

local function greetCallback(cid)
	npcHandler.topic[cid] = 0
	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)

	if msgcontains(msg, "information") then
		npcHandler:say({"{Tokens} are small objects made of metal or other materials. You can use them to buy superior equipment from token traders like me.",
						"There are several ways to obtain the tokens I'm interested in - killing certain bosses, for example. In exchange for a certain amount of tokens, I can offer you some first-class items."}, cid)
	-- elseif msgcontains(msg, "worth") then
	-- to do: check if Heart of Destruction was killed
	-- after kill msg: 'You disrupted the Heart of Destruction, defeated the World Devourer and bought our world some time. You have proven your worth.'
	-- npcHandler:say({"Disrupt the Heart of Destruction, fell the World Devourer to prove your worth and you will be granted the power to imbue 'Powerful Strike', 'Powerful Void' and --'Powerful Vampirism'."}, cid)
	elseif msgcontains(msg, "tokens") then
		openShopWindow(cid, shop, onBuy, onSell)
		npcHandler:say("If you have any gold tokens with you, let's have a look! These are my offers.", cid)
	elseif msgcontains(msg, "trade") then
		npcHandler:say({"I have creature products for the imbuements {strike}, {vampirism}, {void}, {epiphany}, {featherweight}, {vibrancy}, {swiftness}, {scorch}, {venom}, {frost}, {electrify}, {reap}, {lich shroud}, {snake skin}, {dragon hide}, {quara scale}, {cloud fabric}, {demon presence}, {chop}, {slash}, {bash}, {precision}, {blockade}. Make your choice, please!"}, cid)
		npcHandler.topic[cid] = 1
	elseif npcHandler.topic[cid] == 1 then
		local imbueType = products[msg:lower()]
		if imbueType then
			npcHandler:say({"You have chosen "..msg..". {Basic}, {intricate} or {powerful}?"}, cid)
			answerType[cid] = msg
			npcHandler.topic[cid] = 2
		end
	elseif npcHandler.topic[cid] == 2 then
		local imbueLevel = products[answerType[cid]][msg:lower()]
		if imbueLevel then
			answerLevel[cid] = msg:lower()
			local neededCap = 0
			for i = 1, #products[answerType[cid]][answerLevel[cid]].itens do
				neededCap = neededCap + ItemType(products[answerType[cid]][answerLevel[cid]].itens[i].id):getWeight() * products[answerType[cid]][answerLevel[cid]].itens[i].amount
			end
			npcHandler:say({imbueLevel.text.."...", 
							"Make sure that you have ".. #products[answerType[cid]][answerLevel[cid]].itens .." free slot and that you can carry ".. string.format("%.2f",neededCap/100) .." oz in addition to that."}, cid)
			npcHandler.topic[cid] = 3
		end
	elseif npcHandler.topic[cid] == 3 then
		if msgcontains(msg, "yes") then
			local neededCap = 0
			for i = 1, #products[answerType[cid]][answerLevel[cid]].itens do
				neededCap = neededCap + ItemType(products[answerType[cid]][answerLevel[cid]].itens[i].id):getWeight() * products[answerType[cid]][answerLevel[cid]].itens[i].amount
			end
			if player:getFreeCapacity() > neededCap then
				if player:getItemCount(Npc():getCurrency()) >= products[answerType[cid]][answerLevel[cid]].value then
					for i = 1, #products[answerType[cid]][answerLevel[cid]].itens do
						player:addItem(products[answerType[cid]][answerLevel[cid]].itens[i].id, products[answerType[cid]][answerLevel[cid]].itens[i].amount)
					end
					player:removeItem(Npc():getCurrency(), products[answerType[cid]][answerLevel[cid]].value)
					npcHandler:say("There it is.", cid)
					npcHandler.topic[cid] = 0
				else
					npcHandler:say("I'm sorry but it seems you don't have enough ".. ItemType(Npc():getCurrency()):getPluralName():lower() .." yet. Bring me "..products[answerType[cid]][answerLevel[cid]].value.." of them and we'll make a trade.", cid)
				end
			else
				npcHandler:say("You don\'t have enough capacity. You must have "..neededCap.." oz.", cid)
			end
		elseif msgcontains(msg, "no") then
			npcHandler:say("Your decision. Come back if you have changed your mind.",cid)
		end
		npcHandler.topic[cid] = 0
	end
	return true
end



local voices = { {text = 'Trading tokens! First-class equipment available!'} }
npcHandler:addModule(VoiceModule:new(voices))

npcHandler:setCallback(CALLBACK_ONADDFOCUS, onAddFocus)
npcHandler:setCallback(CALLBACK_ONRELEASEFOCUS, onReleaseFocus)

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
