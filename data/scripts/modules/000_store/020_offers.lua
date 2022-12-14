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
StoreOffers = {}
