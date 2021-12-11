local outfits = {
	{12, "Archdemon"},
	{75, "Gamemaster"},
	{159, "Elf"},
	{160, "Dwarf"},
	{194, "Cultist"},
	{226, "Frog"},
	{253, "Headsplitter"},
	{254, "Skullhunter"},
	{255, "Bloodwalker"},
	{264, "Brutetamer"},
	{266, "CM"},
	{302, "Senator"},
	{493, "Gnome M"},
	{507, "Gnome F"},
	{532, "Corym Charlatan"},
	{533, "Corym Skirmisher"},
	{534, "Corym Vanguard"},
	{545, "Hamster"},
	{842, "Krozaur"},
	{862, "Ragiaz"},
	{875, "Eradicator"},
	{876, "Anomaly"},
	{881, "Pit Demon"},
	{932, "Astral Shaper"},
	{947, "Ancient Dragon"},
	{962, "Retro 1"},
	{963, "Retro 2"},
	{964, "Retro 3"},
	{965, "Retro 4"},
	{966, "Retro 5"},
	{967, "Retro 6"},
	{968, "Retro 7"},
	{969, "Retro 8"},
	{970, "Retro 9"},
	{971, "Retro 10"},
	{972, "Retro 11"},
	{973, "Retro 12"},
	{974, "Retro 13"},
	{975, "Retro 14"},
	{980, "Faun"},
	{1059, "Squid"},
	{1061, "Book"},
	{1062, "Ghulosh"},
	{1063, "Guardian of Tales"},
	{1068, "True Asura"},
	{1071, "Falcon A"},
	{1072, "Falcon B"},
	{1107, "Hireling 1"},
	{1108, "Hireling 2"},
	{1109, "Hireling 3"},
	{1110, "Hireling 4"},
	{1111, "Hireling 5"},
	{1112, "Hireling 6"},
	{1113, "Hireling 7"},
	{1114, "Hireling 8"},
	{1115, "Hireling 9"},
	{1116, "Hireling 10"},
	{1117, "Hireling 11"},
	{1118, "Hireling 12"},
	{1119, "Spectre (flat face)"},
	{1122, "Spectre (normal)"},
	{1133, "Carnivor"},
	{1136, "Elf Rearguard"},
	{1137, "Elf Vanguard"},
	{1188, "Sphinx"},
	{1189, "Manticore"},
	{1190, "Lamassu"},
	{1199, "Issavi Priestess"},
	{1200, "Issavi Acolyte"},
	{1210, "Golden Outfit F"},
	{1211, "Golden Outfit M"},
	{1217, "Cobra Cultist"},
	{1219, "Flickering Soul"},
	{1221, "Lich Knight 1"},
	{1222, "Lich Knight 2"},
	{1223, "Lich Knight 3"},
	{1253, "Cow"},
	{1255, "Orger"},
	{1268, "Lost Soul"},
	{1288, "Dragon Slayer F"},
	{1289, "Dragon Slayer M"},
	{1298, "Phantom"},
	{1300, "Furry (hyaena)"},
	{1301, "Furry (lion)"},
	{1316, "Usurper A"},
	{1317, "Usurper B"},
	{1346, "Corym Pirat"},
	{1363, "Krakoloss (mount)"},
	{1378, "Furry (raccoon)"},
	{1396, "Tunnel Tyrant"},
	{1406, "Cave Chimera"},
	{1407, "Girtablilu"},
	{1408, "Bashmu"},
	{1418, "Carnisylvan"},
	{1430, "Shellodon (mount)"},
}
function sendCraftedOutfitWindow(player)
	if not player:getGroup():getAccess() then
		return true
	end
	
	local currentOutfit = player:getOutfit()
	
	local m = NetworkMessage()
	m:addByte(0xC8)
	
	-- current outfit
	m:addU16(currentOutfit.lookType)
	m:addByte(currentOutfit.lookHead)
	m:addByte(currentOutfit.lookBody)
	m:addByte(currentOutfit.lookLegs)
	m:addByte(currentOutfit.lookFeet)
	m:addByte(currentOutfit.lookAddons)
	
	-- current mount
	m:addU16(0)
	m:addByte(0)
	m:addByte(0)
	m:addByte(0)
	m:addByte(0)
	
	-- current familiar
	m:addU16(0)
	
	-- outfits block
	m:addU16(#outfits)
	for i = 1, #outfits do
		m:addU16(outfits[i][1])
		m:addString(outfits[i][2])
		m:addByte(3)
		m:addByte(0)
	end
	
	-- mounts block
	m:addU16(0)
	
	-- familiars block
	m:addU16(0)
	
	-- flags
	m:addByte(0)
	m:addByte(0)
	
	-- randomize
	m:addByte(0)
	m:sendToPlayer(player)
end

local t = TalkAction("/secretmenu")
t.onSay = function(player, words, param)
	sendCraftedOutfitWindow(player)
end
t:register()
