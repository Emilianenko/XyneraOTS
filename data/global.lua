math.randomseed(os.time())
dofile('data/lib/lib.lua')

PROMOTION_PRICE = 20000
PROMOTION_LEVEL = 20

do
	local stack_100cc = 1000000
	GOLDEN_OUTFIT_PRICE_ARMOR = 500 * stack_100cc
	GOLDEN_OUTFIT_PRICE_BOOTS = 250 * stack_100cc
	GOLDEN_OUTFIT_PRICE_HELMET = 250 * stack_100cc
end

ropeSpots = {
	384, 418, 8278, 8592, 13189, 14435, 14436, 14857, 15635, 19518, 24621, 24622, 24623, 24624, 26019
}

-- list of looktypes to avoid when generating outfit windows
LOOK_TYPE_LAST = 1577
InvalidLookTypes = {
	1, 135, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173,
	174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188,
	189, 190, 191, 411, 415, 424, 439, 440, 468, 469, 474, 475, 476, 477, 478,
	479, 480, 481, 482, 483, 484, 485, 501, 518, 519, 520, 524, 525, 536, 543,
	549, 576, 581, 582, 597, 616, 623, 625, 638, 639, 640, 641, 642, 643, 645,
	646, 652, 653, 654, 655, 656, 657, 658, 659, 660, 661, 662, 663, 678, 700,
	701, 702, 703, 704, 705, 706, 707, 708, 709, 710, 711, 713, 715, 718, 719,
	722, 723, 737, 741, 742, 743, 744, 748, 751, 752, 753, 754, 755, 756, 757,
	758, 764, 765, 766, 767, 768, 769, 770, 771, 772, 773, 774, 775, 776, 777,
	778, 779, 780, 781, 782, 783, 784, 785, 786, 787, 788, 789, 790, 791, 792,
	793, 794, 795, 796, 797, 798, 799, 800, 801, 802, 803, 804, 805, 806, 807,
	808, 809, 810, 811, 812, 813, 814, 815, 816, 817, 818, 819, 820, 821, 822,
	823, 824, 825, 826, 827, 828, 829, 830, 831, 832, 833, 834, 835, 836, 837,
	838, 839, 840, 841, 847, 861, 863, 864, 865, 866, 867, 871, 872, 880, 891,
	892, 893, 894, 895, 896, 897, 898, 911, 912, 917, 930, 941, 942, 946, 953,
	954, 983, 995, 996, 997, 998, 999, 1000, 1001, 1002, 1003, 1004, 1005, 1006,
	1007, 1008, 1009, 1010, 1012, 1014, 1015, 1022, 1028, 1074, 1075, 1080, 1081,
	1082, 1083, 1084, 1085, 1086, 1087, 1089, 1090, 1096, 1097, 1098, 1099, 1100,
	1141, 1145, 1153, 1154, 1155, 1156, 1160, 1170, 1171, 1172, 1176, 1177, 1178,
	1182, 1192, 1193, 1194, 1198, 1215, 1216, 1225, 1226, 1227, 1228, 1235, 1236,
	1237, 1238, 1239, 1240, 1241, 1242, 1250, 1254, 1263, 1267, 1273, 1274, 1287,
	1302, 1318, 1319, 1320, 1327, 1328, 1329, 1330, 1340, 1343, 1345, 1347, 1348,
	1349, 1350, 1351, 1352, 1353, 1354, 1355, 1356, 1357, 1358, 1359, 1360, 1361,
	1362, 1368, 1369, 1370, 1374, 1375, 1376, 1388, 1392, 1395, 1400, 1402, 1404,
	1409, 1410, 1411, 1420, 1421, 1427, 1428, 1429, 1432, 1433, 1434, 1435, 1438,
	1442, 1443, 1451, 1452, 1458, 1462, 1470, 1471, 1472, 1473, 1474, 1475, 1476,
	1477, 1478, 1479, 1480, 1481, 1482, 1483, 1484, 1485, 1486, 1487, 1488, 1494,
	1495, 1496, 1497, 1498, 1499, 1502, 1503, 1504, 1505, 1506, 1507, 1508, 1509,
	1510, 1511, 1512, 1513, 1514, 1515, 1516, 1517, 1518, 1519, 1520, 1521, 1522,
	1523, 1524, 1525, 1529, 1530, 1531, 1532, 1544, 1545, 1563, 1564, 1571, 1572,
	1573, 1574
}

function getDistanceBetween(firstPosition, secondPosition)
	local xDif = math.abs(firstPosition.x - secondPosition.x)
	local yDif = math.abs(firstPosition.y - secondPosition.y)
	local posDif = math.max(xDif, yDif)
	if firstPosition.z ~= secondPosition.z then
		posDif = posDif + 15
	end
	return posDif
end

function getFormattedWorldTime()
	local worldTime = getWorldTime()
	local hours = math.floor(worldTime / 60)

	local minutes = worldTime % 60
	if minutes < 10 then
		minutes = '0' .. minutes
	end
	return hours .. ':' .. minutes
end

function getLootRandom()
	return math.random(0, MAX_LOOTCHANCE) / configManager.getNumber(configKeys.RATE_LOOT)
end

function bit.addFlag(totalFlags, flag)
	return bit.bor(totalFlags, flag)
end

function bit.removeFlag(totalFlags, flag)
	return bit.band(totalFlags, bit.bnot(flag))
end

table.contains = function(array, value)
	for _, targetColumn in pairs(array) do
		if targetColumn == value then
			return true
		end
	end
	return false
end

table.maxn = function(array)
	local max = 0
	for key in pairs(array) do
		if type(key) == "number" and key > max then
			max = key
		end
	end
	return max
end

string.split = function(str, sep)
	local res = {}
	for v in str:gmatch("([^" .. sep .. "]+)") do
		res[#res + 1] = v
	end
	return res
end

string.splitTrimmed = function(str, sep)
	local res = {}
	for v in str:gmatch("([^" .. sep .. "]+)") do
		res[#res + 1] = v:trim()
	end
	return res
end

string.trim = function(str)
	return str:match'^()%s*$' and '' or str:match'^%s*(.*%S)'
end

if not nextUseStaminaTime then
	nextUseStaminaTime = {}
end

function getPlayerDatabaseInfo(name_or_guid)
	local sql_where = ""

	if type(name_or_guid) == 'string' then
		sql_where = "WHERE `p`.`name`=" .. db.escapeString(name_or_guid) .. ""
	elseif type(name_or_guid) == 'number' then
		sql_where = "WHERE `p`.`id`='" .. name_or_guid .. "'"
	else
		return false
	end

	local sql_query = [[
		SELECT
			`p`.`id` as `guid`,
			`p`.`name`,
			CASE WHEN `po`.`player_id` IS NULL
				THEN 0
				ELSE 1
			END AS `online`,
			`p`.`group_id`,
			`p`.`level`,
			`p`.`experience`,
			`p`.`vocation`,
			`p`.`maglevel`,
			`p`.`skill_fist`,
			`p`.`skill_club`,
			`p`.`skill_sword`,
			`p`.`skill_axe`,
			`p`.`skill_dist`,
			`p`.`skill_shielding`,
			`p`.`skill_fishing`,
			`p`.`town_id`,
			`p`.`balance`,
			`gm`.`guild_id`,
			`gm`.`nick`,
			`g`.`name` AS `guild_name`,
			CASE WHEN `p`.`id` = `g`.`ownerid`
				THEN 1
				ELSE 0
			END AS `is_leader`,
			`gr`.`name` AS `rank_name`,
			`gr`.`level` AS `rank_level`,
			`h`.`id` AS `house_id`,
			`h`.`name` AS `house_name`,
			`h`.`town_id` AS `house_town`
		FROM `players` AS `p`
		LEFT JOIN `players_online` AS `po`
			ON `p`.`id` = `po`.`player_id`
		LEFT JOIN `guild_membership` AS `gm`
			ON `p`.`id` = `gm`.`player_id`
		LEFT JOIN `guilds` AS `g`
			ON `gm`.`guild_id` = `g`.`id`
		LEFT JOIN `guild_ranks` AS `gr`
			ON `gm`.`rank_id` = `gr`.`id`
		LEFT JOIN `houses` AS `h`
			ON `p`.`id` = `h`.`owner`
	]] .. sql_where

	local query = db.storeQuery(sql_query)
	if not query then
		return false
	end

	local info = {
		["guid"] = result.getNumber(query, "guid"),
		["name"] = result.getString(query, "name"),
		["online"] = result.getNumber(query, "online"),
		["group_id"] = result.getNumber(query, "group_id"),
		["level"] = result.getNumber(query, "level"),
		["experience"] = result.getNumber(query, "experience"),
		["vocation"] = result.getNumber(query, "vocation"),
		["maglevel"] = result.getNumber(query, "maglevel"),
		["skill_fist"] = result.getNumber(query, "skill_fist"),
		["skill_club"] = result.getNumber(query, "skill_club"),
		["skill_sword"] = result.getNumber(query, "skill_sword"),
		["skill_axe"] = result.getNumber(query, "skill_axe"),
		["skill_dist"] = result.getNumber(query, "skill_dist"),
		["skill_shielding"] = result.getNumber(query, "skill_shielding"),
		["skill_fishing"] = result.getNumber(query, "skill_fishing"),
		["town_id"] = result.getNumber(query, "town_id"),
		["balance"] = result.getNumber(query, "balance"),
		["guild_id"] = result.getNumber(query, "guild_id"),
		["nick"] = result.getString(query, "nick"),
		["guild_name"] = result.getString(query, "guild_name"),
		["is_leader"] = result.getNumber(query, "is_leader"),
		["rank_name"] = result.getString(query, "rank_name"),
		["rank_level"] = result.getNumber(query, "rank_level"),
		["house_id"] = result.getNumber(query, "house_id"),
		["house_name"] = result.getString(query, "house_name"),
		["house_town"] = result.getNumber(query, "house_town")
	}

	result.free(query)
	return info
end
