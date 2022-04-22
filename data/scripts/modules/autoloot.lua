-- helpers for autoloot sorting
AutoLootMeta = {
	-- 20 entries per line for easier reading
	[LOOT_TYPE_TOOL] = {
		2036, 2044, 2047, 2050, 2062, 2063, 2120, 2217, 2324, 2356, 2361, 2548, 2549, 2552, 2553, 2554, 2556, 2557, 2558, 2559,
		2560, 2561, 2563, 2564, 2565, 2566, 2567, 2568, 2569, 2570, 2571, 2572, 2573, 2578, 2580, 2600, 4846, 5468, 5710, 5865,
		5908, 5941, 5942, 5946, 6561, 7731, 7734, 8613, 8717, 10152, 10153, 10223, 10511, 10513, 10515, 23588, 24126, 24127, 24135, 24183,
		24185, 32606, 33983, 33984, 33990, 34569, 39199, 39200, 39201,
	},
	[LOOT_TYPE_POTION] = {
		7634, 7635, 7636, 38219, 39379, 39380, 39381, 39382, 39383, 39384, 39385, 39386, 39387, 39388, 39389, 39390, 39391, 39392, 39393, 39394,
		39395, 39396, 39397, 39398,
	},
	[LOOT_TYPE_FOOD] = {
		2328, 2692, 2693, 2694, 5467, 6277, 6280, 8846, 9992, 9993, 9994, 9995, 9997, 9998, 9999, 10000, 10001, 11245, 12540, 12542,
		12543, 12544, 12641, 14341, 14345, 22644, 31140, 31141, 31142, 32651, 33988, 34341, 34342, 34570, 34617, 34699, 34700, 34701, 34722, 34723,
		34724, 34726, 34729, 34854, 36586, 40680, 40681, 40682, 40683,
	},
	[LOOT_TYPE_DECORATION] = {
		1678, 1679, 1680, 1681, 1682, 1683, 1684, 1685, 1686, 1687, 1688, 1689, 1690, 1691, 1692, 1693, 1845, 1848, 1851, 1852,
		1853, 1854, 1857, 1860, 1863, 1866, 1869, 1872, 1880, 1881, 2035, 2070, 2071, 2072, 2074, 2075, 2076, 2077, 2079, 2093,
		2096, 2099, 2100, 2102, 2103, 2104, 2107, 2108, 2110, 2112, 2113, 2114, 2162, 2184, 2192, 2193, 2194, 2322, 2326, 2355,
		2741, 2744, 2745, 2746, 2747, 2754, 2759, 2760, 2798, 2799, 2800, 2801, 2802, 2803, 2804, 2805, 3901, 3902, 3903, 3904,
		3905, 3908, 3911, 3915, 3916, 3917, 3918, 3919, 3920, 3922, 3923, 3924, 3925, 3926, 3927, 3928, 3929, 3930, 3931, 3932,
		3933, 3934, 3937, 3951, 3952, 3953, 3954, 3955, 5080, 5086, 5087, 5088, 5616, 5669, 5791, 5810, 5813, 5928, 5929, 5953,
		6114, 6115, 6372, 6373, 6388, 6490, 6492, 6499, 6512, 6526, 6572, 6575, 6576, 6577, 7183, 7393, 7394, 7395, 7396, 7397,
		7398, 7399, 7400, 7401, 7447, 7448, 7655, 7733, 7735, 7936, 7956, 7958, 7959, 7964, 7965, 8072, 8692, 8860, 8974, 9006,
		9019, 9447, 9448, 9693, 9837, 9941, 9942, 9958, 9959, 9969, 9972, 9974, 9979, 9980, 9981, 10159, 10306, 11126, 11133, 11161,
		11205, 11207, 11211, 11255, 11256, 11264, 11315, 11336, 11338, 11400, 12635, 12650, 12651, 13472, 13560, 13564, 13565, 13566, 13567, 13739,
		13774, 13875, 13944, 14328, 14329, 14331, 14332, 15437, 15438, 15441, 15445, 15446, 15447, 15448, 15449, 15450, 15556, 15619, 15620, 15621,
		15638, 16016, 16017, 16018, 16019, 16075, 16099, 18388, 18391, 18455, 20105, 20254, 20255, 20257, 20608, 20609, 20610, 20611, 20612, 20613,
		20614, 20615, 20616, 20617, 20618, 20619, 21695, 21699, 21703, 21705, 22611, 22612, 22613, 22614, 22616, 22642, 22643, 22645, 22649, 22699,
		23589, 24222, 24225, 24226, 24321, 24322, 24323, 24638, 24757, 24758, 24759, 24760, 25387, 25393, 25431, 25535, 26145, 26146, 26147, 26148,
		26149, 26192, 26197, 27050, 27606, 27607, 28631, 28632, 28633, 30247, 30362, 31149, 32603, 32857, 32971, 32973, 33018, 33019, 33020, 33027,
		33028, 33029, 34730, 34731, 34732, 34733, 35402, 35420, 35421, 35975, 35976, 35986, 36875, 38245, 38246, 38247, 38248, 38348, 39494, 39607,
		39608, 39609, 39610, 39611, 39612, 40506, 40509, 40510, 40512, 40514, 40516, 40518, 40526, 40527, 40528, 40529, 40530, 40531, 40532, 40534,
		40542, 40543, 40544, 40545, 40546, 40547, 40548, 40609, 40613, 40614, 40615, 40617, 40618, 40619, 40620, 40621, 40623, 40624, 40643, 40648,
		40649, 40650, 40651, 40652, 40653, 40654, 40655, 40656, 40657, 40658, 40659, 40660, 40661, 40662, 40663, 40664, 40665, 40666, 40667, 40668,
		40669, 40670, 40689, 40690, 40691, 40692, 40693, 40694, 40695, 40711, 40712, 40713, 40714, 40715, 40716, 40717, 40718, 40719, 40720, 40721,
		40722, 40723, 40724, 40725, 40763, 40865,
	},
	[LOOT_TYPE_OTHER] = {
		2010, 2022, 2024, 2220, 2221, 2222, 2223, 2224, 2225, 2226, 2227, 2228, 2229, 2230, 2231, 2232, 2233, 2234, 2235, 2236,
		2237, 2238, 2239, 2240, 2241, 2242, 2243, 2244, 2245, 2246, 2250, 2251, 2252, 2253, 2254, 2255, 2256, 2257, 2258, 2259,
		2318, 2319, 2320, 2327, 2329, 2330, 2331, 2332, 2333, 2335, 2336, 2337, 2338, 2340, 2341, 2344, 2345, 2346, 2347, 2551,
		4838, 4839, 4840, 4843, 4845, 4849, 4851, 4852, 4853, 4854, 4855, 4858, 4863, 4864, 4865, 4869, 4874, 5786, 5792, 5793,
		5794, 5795, 5796, 5797, 5802, 5937, 5938, 5945, 5947, 5951, 5957, 5958, 6086, 6087, 6088, 6089, 6090, 6091, 6093, 6106,
		6107, 6108, 6119, 6120, 6547, 6548, 6549, 6550, 6551, 7140, 7242, 7243, 7245, 7247, 7248, 7249, 7251, 7253, 7281, 7286,
		7289, 7314, 7441, 7442, 7444, 7445, 7446, 7476, 7479, 7482, 7483, 7484, 7485, 7487, 7488, 7490, 7491, 7492, 7494, 7495,
		7496, 7498, 7499, 7500, 7501, 7502, 7503, 7526, 7528, 7587, 7698, 7699, 7700, 7702, 7703, 7704, 7705, 7706, 7707, 7736,
		7955, 7960, 7961, 7962, 8111, 8182, 8187, 8189, 8190, 8204, 8261, 8262, 8263, 8264, 8265, 8267, 8297, 8301, 8309, 8370,
		8693, 8694, 8699, 8701, 8752, 8761, 8763, 8766, 8767, 8768, 9074, 9078, 9111, 9112, 9113, 9116, 9117, 9369, 9633, 9634,
		9635, 9636, 9662, 9674, 9675, 9676, 9677, 9678, 9687, 9688, 9689, 9733, 9734, 9735, 9737, 9742, 9743, 9744, 9930, 9949,
		10025, 10026, 10028, 10031, 10033, 10034, 10046, 10047, 10048, 10050, 10061, 10062, 10092, 10099, 10100, 10101, 10102, 10103, 10104, 10105,
		10109, 10122, 10123, 10151, 10154, 10155, 10157, 10158, 10165, 10166, 10167, 10169, 10170, 10173, 10224, 10225, 10305, 10307, 10308, 10454,
		10503, 10613, 10614, 10615, 10616, 10760, 10926, 10928, 10942, 10943, 10944, 10945, 11076, 11100, 11106, 11135, 11164, 11339, 11343, 11422,
		11427, 11428, 12284, 12285, 12287, 12289, 12290, 12295, 12297, 12300, 12303, 12318, 12320, 12323, 12324, 12325, 12326, 12327, 12328, 12382,
		12501, 12502, 12503, 12504, 12505, 12506, 12507, 12508, 12655, 12670, 12671, 12969, 13044, 13110, 13115, 13130, 13158, 13160, 13161, 13162,
		13165, 13173, 13216, 13217, 13218, 13219, 13220, 13221, 13222, 13224, 13238, 13601, 13633, 13670, 13759, 13831, 13940, 13954, 14320, 14321,
		14322, 14323, 14325, 14326, 14336, 14337, 14338, 14339, 14342, 14343, 14344, 14346, 14347, 14348, 14349, 14350, 14351, 14352, 14354, 15431,
		15432, 15433, 15439, 15440, 15463, 15464, 15465, 15559, 15572, 15573, 15574, 15575, 16094, 18215, 18395, 18396, 18422, 18423, 18457, 18509,
		18517, 18518, 18519, 18520, 18521, 18522, 18554, 21248, 21250, 21252, 21253, 21462, 21585, 22363, 22542, 22598, 22604, 22605, 22606, 22607,
		22647, 22727, 23574, 23704, 23705, 23838, 23874, 23876, 24116, 24138, 24267, 24268, 24270, 24271, 24274, 24275, 24664, 24665, 24738, 24739,
		24814, 24815, 24816, 25360, 25381, 25427, 26144, 26467, 26642, 27071, 27094, 27529, 30311, 30312, 30313, 30588, 30589, 30590, 31448, 31449,
		32824, 32825, 32856, 32974, 32975, 32976, 32977, 32978, 33631, 34393, 34394, 34727, 34728, 34752, 36893, 38232, 39493, 39765, 39766, 40600,
		40602, 40603, 40604, 40605, 40606, 40607, 40608, 40610, 40611, 40612,
	},
	[LOOT_TYPE_VALUABLE] = {
		1982, 1983, 1984, 1985, 1986, 2122, 2127, 2134, 2137, 2140, 2141, 2143, 2144, 2145, 2146, 2147, 2149, 2150, 2151, 2153,
		2154, 2155, 2156, 2157, 2158, 2159, 2174, 2176, 2177, 2178, 3957, 4873, 5015, 5022, 5907, 5944, 6104, 6570, 6571, 7632,
		7633, 7737, 7739, 7759, 7760, 7761, 7762, 7844, 7845, 7846, 9076, 9108, 9694, 9695, 9696, 9697, 9698, 9699, 9808, 9809,
		9810, 9811, 9812, 9813, 9814, 9815, 9816, 9820, 9821, 9822, 9955, 9970, 9971, 10523, 10531, 11115, 11116, 11134, 11258, 11259,
		11260, 11261, 11262, 12559, 12560, 12561, 12562, 12563, 12564, 12565, 12566, 12567, 12568, 12569, 12570, 12571, 12572, 12573, 12574, 12575,
		12576, 12577, 12578, 12579, 12580, 12581, 12582, 12583, 12584, 12585, 12586, 12587, 12588, 12589, 12590, 12591, 12592, 12593, 12594, 12595,
		12596, 12597, 12598, 12599, 12600, 12601, 12602, 12603, 12604, 12605, 12606, 12662, 12663, 13247, 13291, 13292, 13294, 13295, 13298, 13305,
		13307, 13498, 13506, 13508, 13535, 13536, 13537, 13538, 13539, 13540, 13541, 13542, 13543, 13544, 13545, 13546, 13876, 13925, 13926, 13938,
		13939, 15515, 15545, 15546, 16004, 16005, 16006, 16015, 16096, 16102, 18413, 18414, 18415, 18416, 18417, 18418, 18419, 18420, 18421, 18447,
		18448, 18449, 18497, 18498, 18499, 18500, 18501, 18502, 18503, 18504, 18505, 18506, 18507, 18508, 18511, 18516, 20138, 21399, 21400, 21452,
		21466, 21467, 21468, 21469, 21470, 21471, 21472, 22608, 22726, 23557, 23754, 24682, 24683, 24684, 24849, 24850, 25172, 25377, 25402, 25521,
		26143, 26168, 26194, 26334, 26335, 26340, 26341, 27046, 27047, 27048, 27053, 27585, 27595, 27596, 27597, 27598, 27605, 27610, 27611, 27612,
		27613, 27614, 27615, 27616, 27617, 27618, 27715, 27900, 28016, 28017, 28345, 28393, 28730, 28837, 30261, 30310, 31447, 31550, 31551, 31552,
		31553, 32001, 32002, 32003, 32709, 32710, 32711, 32712, 32715, 32716, 32717, 32826, 32827, 32972, 33921, 33922, 33923, 33924, 33979, 33980,
		34228, 34229, 34230, 34231, 34232, 35239, 35245, 35278, 35279, 35280, 35281, 35282, 35285, 35287, 35289, 35359, 35425, 35426, 35427, 35428,
		35429, 35430, 36434, 36435, 36436, 36437, 36664, 36678, 36679, 36680, 36681, 36728, 36729, 36730, 36731, 36732, 36826, 36866, 36914, 38234,
		38235, 38236, 38237, 38251, 38351, 39491, 39492, 39594, 39658, 39659, 39714, 39715, 39716, 40549, 40550, 40754,
	},
	[LOOT_TYPE_CREATURE_PRODUCT] = {
		3956, 3976, 4850, 5480, 5804, 5808, 5809, 5875, 5876, 5877, 5878, 5879, 5880, 5881, 5882, 5883, 5884, 5885, 5886, 5887,
		5888, 5889, 5890, 5891, 5892, 5893, 5894, 5895, 5896, 5897, 5898, 5899, 5900, 5901, 5902, 5903, 5904, 5905, 5906, 5909,
		5910, 5911, 5912, 5913, 5914, 5919, 5920, 5921, 5922, 5925, 5930, 5943, 5948, 5954, 5956, 6097, 6098, 6099, 6100, 6101,
		6102, 6126, 6497, 6500, 6527, 6534, 6535, 6536, 6537, 6539, 6540, 6546, 6558, 7250, 7290, 7732, 8298, 8299, 8300, 8302,
		8303, 8304, 8305, 8306, 8310, 8614, 8859, 8971, 9020, 9690, 9966, 9967, 9968, 10529, 10548, 10549, 10550, 10551, 10552, 10553,
		10554, 10555, 10556, 10557, 10558, 10559, 10560, 10561, 10562, 10563, 10564, 10565, 10566, 10567, 10568, 10569, 10571, 10572, 10573, 10574,
		10575, 10576, 10577, 10578, 10579, 10580, 10581, 10582, 10583, 10584, 10585, 10600, 10601, 10602, 10603, 10605, 10606, 10607, 10608, 10609,
		10610, 10611, 11113, 11189, 11190, 11191, 11192, 11193, 11194, 11195, 11196, 11197, 11198, 11199, 11200, 11206, 11208, 11209, 11210, 11212,
		11213, 11214, 11215, 11216, 11217, 11218, 11219, 11220, 11221, 11222, 11223, 11224, 11225, 11226, 11227, 11228, 11229, 11230, 11231, 11232,
		11233, 11234, 11235, 11236, 11237, 11238, 11314, 11321, 11322, 11324, 11325, 11326, 11327, 11328, 11330, 11331, 11332, 11333, 11334, 11335,
		11337, 11361, 11366, 11367, 11369, 11371, 11372, 11373, 12399, 12400, 12401, 12402, 12403, 12404, 12405, 12406, 12407, 12408, 12409, 12410,
		12411, 12412, 12413, 12414, 12419, 12420, 12421, 12422, 12423, 12425, 12426, 12427, 12428, 12429, 12430, 12431, 12432, 12433, 12434, 12435,
		12436, 12437, 12438, 12439, 12440, 12441, 12442, 12443, 12444, 12445, 12446, 12447, 12448, 12449, 12466, 12467, 12468, 12469, 12470, 12471,
		12495, 12608, 12614, 12615, 12616, 12617, 12622, 12627, 12628, 12629, 12636, 12640, 12658, 12659, 13026, 13027, 13159, 13296, 13299, 13300,
		13301, 13302, 13303, 13304, 13530, 13533, 13534, 13757, 13758, 13870, 13881, 13942, 13943, 15271, 15421, 15422, 15423, 15424, 15425, 15426,
		15430, 15434, 15435, 15436, 15452, 15455, 15479, 15480, 15481, 15482, 15483, 15484, 15485, 15486, 15622, 18424, 18425, 18426, 18427, 18428,
		18429, 18430, 18431, 18432, 18433, 18434, 18495, 18496, 19738, 19741, 19742, 19743, 20089, 20097, 20098, 20099, 20102, 20103, 20106, 20107,
		20110, 20111, 20127, 20128, 20129, 20130, 20131, 20133, 20134, 20135, 20136, 20137, 21241, 21242, 21243, 21244, 21245, 21246, 21247, 21310,
		21311, 21312, 21313, 21314, 21427, 21428, 22396, 22397, 22517, 22518, 22532, 22533, 22534, 22535, 22536, 22537, 22538, 22539, 22540, 22541,
		22609, 22610, 23474, 23553, 23564, 23565, 23566, 23567, 23568, 23569, 23570, 23571, 23572, 23573, 23575, 24169, 24170, 24630, 24631, 24663,
		24708, 24709, 24710, 24711, 24712, 24713, 24840, 24842, 24844, 24845, 24847, 25384, 25385, 25386, 25425, 26157, 26158, 26159, 26160, 26161,
		26162, 26163, 26164, 26165, 26166, 26167, 26169, 26170, 26171, 26172, 26173, 26174, 26175, 26176, 26177, 26178, 26179, 26180, 26342, 26343,
		27036, 27037, 27040, 27041, 27042, 27043, 27044, 27045, 27593, 27594, 27621, 27622, 27623, 27624, 27625, 27626, 27627, 27628, 27629, 27630,
		27631, 27632, 27633, 27634, 27744, 27745, 28347, 28349, 28350, 28351, 28352, 28353, 28357, 28358, 28398, 28399, 28400, 28401, 29957, 30025,
		30118, 30119, 30248, 30249, 30250, 30251, 30252, 30253, 30254, 30255, 30256, 30257, 30258, 30259, 30260, 30262, 30263, 30264, 30274, 30275,
		30276, 30277, 30278, 30279, 30280, 30281, 30282, 30283, 31222, 31223, 31224, 31225, 31226, 31477, 31478, 31479, 31480, 31947, 32004, 32598,
		32599, 32600, 32601, 32602, 32661, 32714, 32743, 32744, 32843, 32844, 32845, 32846, 32847, 32848, 32851, 32864, 32924, 32925, 32926, 32927,
		32931, 32932, 32933, 32934, 32935, 32936, 32937, 32938, 32940, 32941, 32980, 32981, 33987, 33996, 34093, 34094, 34095, 34096, 34097, 34098,
		34099, 34214, 34215, 34216, 34217, 34244, 34245, 34246, 34247, 34248, 34249, 34250, 34251, 34278, 34279, 34280, 34334, 34665, 34666, 34667,
		34668, 34883, 34884, 35234, 35235, 35236, 35237, 35249, 35250, 35251, 35252, 35253, 35254, 35255, 35256, 35354, 35360, 35361, 35367, 35380,
		35381, 36576, 36577, 36578, 36579, 36580, 36581, 36582, 36583, 36584, 36585, 36588, 36589, 36590, 36591, 36592, 36593, 36594, 36599, 36600,
		36601, 36603, 36608, 36609, 36638, 36670, 36674, 36675, 36676, 36677, 36756, 36757, 36758, 36759, 36794, 36795, 36796, 36797, 36798, 36799,
		36800, 36801, 36802, 36803, 36804, 36805, 36816, 36817, 36818, 36819, 36820, 38227, 38228, 38229, 38230, 38244, 38252, 38266, 38267, 38268,
		38269, 38270, 39425, 39426, 39427, 39428, 39429, 39430, 39431, 39432, 39433, 39434, 39435, 39436, 39437, 39438, 39439, 39440, 39441, 39442,
		39443, 39444, 39445, 39446, 39447, 39448, 39449, 39450, 39451, 39452, 39461, 39462, 39463, 39464, 39465, 39476, 39477, 39478, 39479, 39627,
		39628, 40762, 40958,
	}
}

-- protocol
AUTOLOOT_REQUEST_QUICKLOOT = 0x8F -- 143 - loot corpse/tile
AUTOLOOT_REQUEST_SELECT_CONTAINER = 0x90 -- 144 - select loot container
AUTOLOOT_REQUEST_SETSETTINGS = 0x91 -- 145 - add/remove loot item

AUTOLOOT_RESPONSE_LOOT_CONTAINERS = 0xC0 -- 192 - loot container info

-- loot message helpers
LOOTED_RESOURCE_ABSENT = 0 -- corpse has no items
LOOTED_RESOURCE_NONE = 1 -- failed to loot items
LOOTED_RESOURCE_SOME = 2 -- failed to loot some items
LOOTED_RESOURCE_ALL = 3 -- looted all items

local config = {
	maxCorpsesLimit = 20, -- how many corpses will be checked
	maxLootListLength = 2000, -- how many items can the player register
	messageErrorPosition = "You cannot loot this position.",
	messageErrorOwner = "You are not the owner.",
	
	lootAbsent = "No loot.",
	lootStart = "You looted",
	lootItem = {
		[LOOTED_RESOURCE_NONE] = "none of the dropped items",
		[LOOTED_RESOURCE_SOME] = "only some of the dropped items",
		[LOOTED_RESOURCE_ALL] = "all items",
	},
	
	lootGold = {
		[LOOTED_RESOURCE_NONE] = "none of the dropped gold",
		[LOOTED_RESOURCE_SOME] = "only some of the dropped gold",
		[LOOTED_RESOURCE_ALL] = "complete %d gold",
	},
	
	categoryFull = "Attention! One of assigned loot containers is full!",
	unassignedFull = "Attention! Container for unassigned loot is full!",
	mainFull = "Attention! All your containers are full!",
	noCapacity = "Attention! You cannot take any more items!",
}

-- global autoloot cache
if not AutoLoot then
	AutoLoot = {}
	LootContainersCache = {}
end

-- ItemType helpers
function ItemType:isTool()
	return table.contains(AutoLootMeta[LOOT_TYPE_TOOL], self:getId())
end

function ItemType:isPotion()
	local itemId = self:getId()
	return Potions[itemId] or table.contains(AutoLootMeta[LOOT_TYPE_POTION], itemId)
end

function ItemType:isFood()
	local itemId = self:getId()
	return Foods[itemId] or table.contains(AutoLootMeta[LOOT_TYPE_FOOD], itemId)
end

function ItemType:isDecoration()
	return table.contains(AutoLootMeta[LOOT_TYPE_DECORATION], self:getId())
end

function ItemType:isOther()
	return table.contains(AutoLootMeta[LOOT_TYPE_OTHER], self:getId())
end

function ItemType:isValuable()
	return table.contains(AutoLootMeta[LOOT_TYPE_VALUABLE], self:getId())
end

function ItemType:isCreatureProduct()
	return table.contains(AutoLootMeta[LOOT_TYPE_CREATURE_PRODUCT], self:getId())
end

function Player:getLootContainers()
	local flagsToSearch = {}
	for lootType = LOOT_TYPE_NONE + 1, LOOT_TYPE_LAST do
		flagsToSearch[2^lootType] = true
	end

	local containers = {}
	for slot = CONST_SLOT_FIRST, CONST_SLOT_STORE_INBOX do
		local slotItem = self:getSlotItem(slot)
		if slotItem then
			if slotItem:isContainer() then
				if slotItem:isLootContainer() then
					local flags = self:getLootContainerFlags(slotItem:getLootContainerId())
					if flags ~= 0 then
						for flag, _ in pairs(flagsToSearch) do
							if bit.band(flags, flag) ~= 0 then
								containers[flag] = slotItem
								flagsToSearch[flag] = nil
							end
						end
					end
				end
				
				for _, child in pairs(slotItem:getItems(true)) do
					if child:isContainer() and child:isLootContainer() then
						local childFlags = self:getLootContainerFlags(child:getLootContainerId())
						if childFlags ~= 0 then
							for flag, _ in pairs(flagsToSearch) do
								if bit.band(childFlags, flag) ~= 0 then
									containers[flag] = child
									flagsToSearch[flag] = nil
								end
							end
						end
					end
				end
			end
		end
	end
		
	return containers
end

local function getLootedStatus(currentAmount, totalAmount, currentStatus)
	if currentAmount == 0 and totalAmount == 0 then
		return LOOTED_RESOURCE_ABSENT
	elseif currentAmount == 0 then
		return LOOTED_RESOURCE_NONE
	elseif currentAmount < totalAmount then
		return LOOTED_RESOURCE_SOME
	end
	
	return LOOTED_RESOURCE_ALL
end

local function getNextLootedStatus(currentStatus, elementStatus)
	if elementStatus == LOOTED_RESOURCE_ABSENT then
		return currentStatus 
	elseif currentStatus == elementStatus or currentStatus == LOOTED_RESOURCE_ABSENT then
		return elementStatus
	elseif currentStatus == LOOTED_RESOURCE_ALL or currentStatus == LOOTED_RESOURCE_NONE and (elementStatus == LOOTED_RESOURCE_ALL or elementStatus == LOOTED_RESOURCE_SOME) then
		return LOOTED_RESOURCE_SOME
	end
	
	return currentStatus
end

local function getLootResponse(lootedItems, lootedGold, itemCount, goldCount, corpseCount)
	if lootedItems == LOOTED_RESOURCE_ABSENT and lootedGold == LOOTED_RESOURCE_ABSENT then
		if corpseCount > 1 then
			return string.format("%s (%d corpse%s)", config.lootAbsent, corpseCount, corpseCount == 1 and "" or "s")
		else
			return config.lootAbsent
		end
	elseif
		corpseCount > 1 and (lootedItems == LOOTED_RESOURCE_ALL and lootedGold == LOOTED_RESOURCE_ALL
		or lootedItems == LOOTED_RESOURCE_ALL and lootedGold == LOOTED_RESOURCE_ABSENT
		or lootedItems == LOOTED_RESOURCE_ABSENT and lootedGold == LOOTED_RESOURCE_ALL)
	then
		return string.format("%s %d corpse%s.", config.lootStart, corpseCount, corpseCount == 1 and "" or "s")
	end
	
	local lootInfo = {}
	if lootedItems ~= LOOTED_RESOURCE_ABSENT then
		if itemCount == 1 then
			lootInfo[#lootInfo + 1] = "1 item"
		else
			lootInfo[#lootInfo + 1] = config.lootItem[lootedItems]
		end
	end
	
	if lootedGold ~= LOOTED_RESOURCE_ABSENT then
		if lootedGold == LOOTED_RESOURCE_ALL then
			lootInfo[#lootInfo + 1] = string.format(config.lootGold[lootedGold], goldCount)
		else
			lootInfo[#lootInfo + 1] = config.lootGold[lootedGold]
		end
	end
	
	local corpses = ""
	if corpseCount > 1 then
		corpses = string.format(" (%d corpse%s)", corpseCount, corpseCount == 1 and "" or "s")
	end
	
	return string.format("%s %s.%s", config.lootStart, table.concat(lootInfo, " and "), corpses)
end

local lootSorting = {
	[2^LOOT_TYPE_ARMOR] = ItemType.isArmor,
	[2^LOOT_TYPE_AMULET] = ItemType.isNecklace,
	[2^LOOT_TYPE_BOOTS] = ItemType.isBoots,
	[2^LOOT_TYPE_CONTAINER] = ItemType.isContainer,
	[2^LOOT_TYPE_DECORATION] = ItemType.isDecoration,
	[2^LOOT_TYPE_FOOD] = ItemType.isFood,
	[2^LOOT_TYPE_HELMET] = ItemType.isHelmet,
	[2^LOOT_TYPE_LEGS] = ItemType.isLegs,
	[2^LOOT_TYPE_OTHER] = ItemType.isOther,
	[2^LOOT_TYPE_POTION] = ItemType.isPotion,
	[2^LOOT_TYPE_RING] = ItemType.isRing,
	[2^LOOT_TYPE_RUNE] = ItemType.isRune,
	[2^LOOT_TYPE_SHIELD] = ItemType.isShield,
	[2^LOOT_TYPE_TOOL] = ItemType.isTool,
	[2^LOOT_TYPE_VALUABLE] = ItemType.isValuable,
	[2^LOOT_TYPE_AMMO] = ItemType.isAmmo,
	[2^LOOT_TYPE_AXE] = ItemType.isAxe,
	[2^LOOT_TYPE_CLUB] = ItemType.isClub,
	[2^LOOT_TYPE_DISTANCE] = ItemType.isDistanceWeapon,
	[2^LOOT_TYPE_SWORD] = ItemType.isSword,
	[2^LOOT_TYPE_WAND] = ItemType.isWand,
	[2^LOOT_TYPE_CREATURE_PRODUCT] = ItemType.isCreatureProduct,
	[2^LOOT_TYPE_QUIVER] = ItemType.isQuiver,
	[2^LOOT_TYPE_GOLD] = ItemType.isCurrency
}

local unassigned = 2^LOOT_TYPE_UNASSIGNED
function internalLootItem(player, item, lootContainers, usesFallback, mainContainer)
	local itemType = item:getType()
	local lootedItem = item:clone()
	local found = false
	local isSkipMode = player:getStorageValue(PlayerStorageKeys.autoLootMode) ~= 1
	local isItemListed = table.contains(AutoLoot[player:getId()], item:getClientId())
	
	if isSkipMode and isItemListed then
		return
	elseif not isSkipMode and not isItemListed then
		return
	end
	
	-- query type-specific backpacks
	for category, container in pairs(lootContainers) do
		if lootSorting[category] and lootSorting[category](itemType) then
			found = true

			local ret = container:addItemEx(lootedItem)
			if ret == RETURNVALUE_NOERROR then
				return ret
			elseif ret == RETURNVALUE_CONTAINERNOTENOUGHROOM then
				player:sendTextMessage(MESSAGE_STATUS_WARNING, config.categoryFull)
			end
			
			break
		end
	end

	-- query unassigned loot backpack
	if lootContainers[unassigned] then
		found = true
	
		local ret = lootContainers[unassigned]:addItemEx(lootedItem)
		if ret == RETURNVALUE_NOERROR then
			return ret
		elseif ret == RETURNVALUE_CONTAINERNOTENOUGHROOM then
			player:sendTextMessage(MESSAGE_STATUS_WARNING, config.unassignedFull)
		end
	end

	-- dedicated container is full
	-- check if we can use main backpack
	-- check will be skipped if there is no container for item category or unassigned loot
	if found then
		if not usesFallback then
			lootedItem:remove()
			player:sendTextMessage(MESSAGE_STATUS_WARNING, config.unassignedFull)
			return RETURNVALUE_CONTAINERNOTENOUGHROOM
		end
	end
	
	-- query main backpack
	if mainContainer then
		local ret = mainContainer:addItemEx(lootedItem)
		if ret ~= RETURNVALUE_NOERROR then
			lootedItem:remove()
		end
		
		if ret == RETURNVALUE_CONTAINERNOTENOUGHROOM then
			player:sendTextMessage(MESSAGE_STATUS_WARNING, config.mainFull)
		elseif ret == RETURNVALUE_NOTENOUGHCAPACITY then
			player:sendTextMessage(MESSAGE_STATUS_WARNING, config.noCapacity)
		end
		
		return ret
	end
	
	-- no free slots found
	lootedItem:remove()
	player:sendTextMessage(MESSAGE_STATUS_WARNING, config.noCapacity)
	return RETURNVALUE_CONTAINERNOTENOUGHROOM
end

function internalLootCorpse(player, corpse, lootedItems, lootedGold, lootContainers)
	if not corpse:isContainer() then
		return LOOTED_RESOURCE_ABSENT, LOOTED_RESOURCE_ABSENT, 0, 0
	end
	
	local corpseItems = 0
	local retrievedItems = 0
	local corpseGold = 0
	local retrievedGold = 0 -- stacks
	local retrievedGoldAmount = 0 -- exact amount
	
	local mainContainer = player:getSlotItem(CONST_SLOT_BACKPACK)
	local usesFallback = player:getStorageValue(PlayerStorageKeys.autoLootFallback) == 1
	
	for _, corpseItem in pairs(corpse:getItems()) do
		local isCurrency = corpseItem:isCurrency()
		if isCurrency then
			corpseGold = corpseGold + 1
		else
			corpseItems = corpseItems + 1
		end
		
		if internalLootItem(player, corpseItem, lootContainers, usesFallback, mainContainer) == RETURNVALUE_NOERROR then
			corpseItem:remove()
			
			if isCurrency then
				retrievedGold = retrievedGold + 1
				retrievedGoldAmount = retrievedGoldAmount + corpseItem:getWorth()
			else
				retrievedItems = retrievedItems + 1
			end
		end
	end
	
	-- looted items response
	return getLootedStatus(retrievedItems, corpseItems, lootedItems), getLootedStatus(retrievedGold, corpseGold, lootedGold), retrievedItems, retrievedGoldAmount
end

function Player:canOpenCorpse(corpse)
	local owner = corpse:getCorpseOwner()
	if owner == self:getId() or owner == 0 then
		return true
	end
	
	owner = Player(owner)
	if not owner then
		return true
	end
	
	local playerParty = self:getParty()
	local ownerParty = owner:getParty()

	return playerParty and ownerParty and playerParty == ownerParty
end

function parseRequestQuickLoot(player, recvbyte, msg)
	local position = Position(msg:getU16(), msg:getU16(), msg:getByte())
	
	local stackpos = msg:getByte()
	local spriteId = msg:getU16()
	local containerPos = msg:getByte()
	local isGround = msg:getByte() == 1

	local lootedItems = LOOTED_RESOURCE_ABSENT
	local lootedGold = LOOTED_RESOURCE_ABSENT
	local itemCount = 0
	local goldCount = 0
	local corpseCount = 0
	local lootContainers = player:getLootContainers()
	
	if position.x ~= CONTAINER_POSITION then
		-- shift + right click on the floor
	
		-- distance check
		if position:getDistance(player:getPosition()) > 1 then
			player:sendTextMessage(MESSAGE_LOOT, config.messageErrorPosition)
			return
		end

		-- tile check
		local tile = Tile(position)
		if not tile then
			player:sendTextMessage(MESSAGE_LOOT, config.messageErrorPosition)
			return
		end
		
		if tile:getHouse() then
			-- no looting inside houses
			return
		end
		
		local hasBodies = false
		local looted = false

		local items = tile:getItems()
		for _, corpse in ipairs(items) do
			if corpse:isCorpse() and corpse:isContainer() then
				hasBodies = true
				
				if player:canOpenCorpse(corpse) and corpseCount < config.maxCorpsesLimit then
					local tmpLootedItems = LOOTED_RESOURCE_ABSENT
					local tmpLootedGold = LOOTED_RESOURCE_ABSENT
					local tmpItemCount = 0
					local tmpGoldCount = 0
					
					tmpLootedItems, tmpLootedGold, tmpItemCount, tmpGoldCount = internalLootCorpse(player, corpse, tmpLootedItems, tmpLootedGold, lootContainers)
					corpseCount = corpseCount + 1
					lootedItems = getNextLootedStatus(lootedItems, tmpLootedItems)
					lootedGold = getNextLootedStatus(lootedGold, tmpLootedGold)
					itemCount = itemCount + tmpItemCount
					goldCount = goldCount + tmpGoldCount
					looted = true
				end
			end
		end
		
		if hasBodies and not looted then
			player:sendTextMessage(MESSAGE_LOOT, config.messageErrorOwner)
			return
		end
	else
		-- shift + right click in container ui
		-- this way of looting does not show amount of corpses looted
		if bit.band(position.y, 0x40) ~= 0 then
			local openedContainer = player:getContainerById(position.y - 0x40)
			if not openedContainer then
				-- user is lagging and the the container is no longer there
				return
			end

			local corpseTile = Tile(openedContainer:getPosition())
			if corpseTile and corpseTile:getHouse() then
				-- no looting inside houses
				return
			end
			
			if not player:canOpenCorpse(openedContainer) then
				-- container is open but the player has lost rights to it
				-- (eg by leaving party)
				player:sendTextMessage(MESSAGE_LOOT, config.messageErrorOwner)
				return
			end
			
			local clickedItem = openedContainer:getItems()[position.z + 1]
			if not clickedItem then
				-- user is lagging and the clicked item is no longer there
				return
			end
			
			if clickedItem:isCorpse() or clickedItem:isContainer() and not clickedItem:isPickupable() then
				-- clicked a corpse in browse field
				if not player:canOpenCorpse(clickedItem) then
					-- corpse click in browse field, owner check failed
					player:sendTextMessage(MESSAGE_LOOT, config.messageErrorOwner)
					return
				end
				
				lootedItems, lootedGold, itemCount, goldCount = internalLootCorpse(player, clickedItem, lootedItems, lootedGold, lootContainers)
			else
				-- clicked an item inside the corpse
				local isCurrency = clickedItem:isCurrency()
				
				local ret = internalLootItem(player, clickedItem, lootContainers, player:getStorageValue(PlayerStorageKeys.autoLootFallback) == 1, player:getSlotItem(CONST_SLOT_BACKPACK))
				if ret == RETURNVALUE_NOERROR then
					local itemCount = clickedItem:getCount()
					clickedItem:remove()
					
					if isCurrency then
						lootedGold = LOOTED_RESOURCE_ALL
						goldCount = goldCount + itemCount
					else
						lootedItems = LOOTED_RESOURCE_ALL
						itemCount = itemCount + itemCount
					end
				else
					if isCurrency then
						lootedGold = LOOTED_RESOURCE_NONE
					else
						lootedItems = LOOTED_RESOURCE_NONE
					end
				end
			end
		end
	end
	
	-- response
	player:sendTextMessage(MESSAGE_LOOT, getLootResponse(lootedItems, lootedGold, itemCount, goldCount, corpseCount))
end
setPacketEvent(AUTOLOOT_REQUEST_QUICKLOOT, parseRequestQuickLoot)

-- auto loot update
function parseRequestUpdateAutoloot(player, recvbyte, msg)		
	player:setStorageValue(PlayerStorageKeys.autoLootMode, msg:getByte())	
	local listSize = math.min(msg:getU16(), config.maxLootListLength)
	local lootList = {}
	
	for listIndex = 1, listSize do
		lootList[#lootList + 1] = msg:getU16()
	end
	AutoLoot[player:getId()] = lootList
end
setPacketEvent(AUTOLOOT_REQUEST_SETSETTINGS, parseRequestUpdateAutoloot)

function Player:selectLootContainer(item, category)
	if category <= LOOT_TYPE_NONE or category > LOOT_TYPE_LAST then
		return
	end
	
	if not item:isContainer() then
		return
	end
	
	local itemId = item:getId()
	if itemId == ITEM_STORE_INBOX or itemId == ITEM_GOLD_POUCH and category ~= LOOT_TYPE_GOLD or item:getType():isQuiver() and category ~= LOOT_TYPE_AMMO then
		local m = ModalWindow()
		m:setTitle("Invalid Loot Container")
		m:setMessage("This container cannot hold items of selected category.")
		m:addButton(1, "Ok")
		m:sendToPlayer(self)
		return
	end
	
	local lootContainerId = item:getLootContainerId()
	self:setLootContainer(category, lootContainerId)
	
	local previousContainer = LootContainersCache[self:getId()][category]
	if previousContainer then
		self:updateLootContainerById(previousContainer.id)
	end
	
	LootContainersCache[self:getId()][category] = {id = lootContainerId, spriteId = item:getClientId()}
	self:sendLootContainers()
	item:refresh()
end

function Player:updateLootContainerById(lootContainerId)
	-- search inventory
	for slot = CONST_SLOT_FIRST, CONST_SLOT_STORE_INBOX do
		local slotItem = self:getSlotItem(slot)
		if slotItem then
			if slotItem:isContainer() and slotItem:isLootContainer() and slotItem:getLootContainerId() == lootContainerId then
				slotItem:refresh()
				return
			end
		end
	end

	-- search opened containers
	for _, container in pairs(self:getOpenContainers()) do
		for a, containerItem in pairs(container:getItems(false)) do
			if containerItem:isContainer() and containerItem:isLootContainer() and containerItem:getLootContainerId() == lootContainerId then
				containerItem:refresh()
				return
			end
		end
	end
end

function Player:deSelectLootContainer(category)
	if category <= LOOT_TYPE_NONE or category > LOOT_TYPE_LAST then
		return
	end
	
	-- store deselected container info to search it later
	local cid = self:getId()
	local lootContainerId = LootContainersCache[cid][category].id
	
	-- unregister deselected container
	self:setLootContainer(category, 0)
	LootContainersCache[cid][category] = nil
	self:sendLootContainers()

	-- find deselected container and update icon
	self:updateLootContainerById(lootContainerId)
end

-- select loot container from list
function parseSelectLootContainer(player, recvbyte, msg)
	local mode = msg:getByte()
	if mode == 0x00 then
		-- choose a container
		local lootType = msg:getByte()
		local position = Position(msg:getU16(), msg:getU16(), msg:getByte())
		local spriteId = msg:getU16()
		local containerPos = msg:getByte() + 1 -- client first index is 0, container:getItems() first index is 1
				
		local isPlayerInventory = position.x == CONTAINER_POSITION
		if not isPlayerInventory then
			return
		end
		
		if bit.band(position.y, 0x40) ~= 0 then
			local parent = player:getContainerById(position.y - 0x40)
			if not (parent and parent:isContainer()) then
				-- not a container
				return
			end

			if parent:getTopParent() ~= player then
				-- not in player inventory
				return
			end
			
			local containerItem = parent:getItems()[containerPos]
			if not containerItem then
				-- invalid slot
				return
			end
			
			player:selectLootContainer(containerItem, lootType)			
		elseif position.y >= CONST_SLOT_FIRST and position.y <= CONST_SLOT_LAST then
			-- slot position
			local chosenItem = player:getSlotItem(position.y)
			if chosenItem then
				player:selectLootContainer(chosenItem, lootType)
			end
		end
	elseif mode == 0x01 then
		-- clear loot container
		player:deSelectLootContainer(msg:getByte())
	elseif mode == 0x03 then
		-- toggle fallback to main container
		player:setStorageValue(PlayerStorageKeys.autoLootFallback, msg:getByte() == 0x01 and 1 or 0)
		player:sendLootContainers()
	end
end
setPacketEvent(AUTOLOOT_REQUEST_SELECT_CONTAINER, parseSelectLootContainer)

local function addPlayerLootContainer(player, container)
	local cid = player:getId()
	local lootContainerId = container:getLootContainerId()
	local flags = player:getLootContainerFlags(lootContainerId)
	if flags ~= 0 then
		for lootType = LOOT_TYPE_NONE + 1, LOOT_TYPE_LAST do
			if bit.band(flags, 2^lootType) ~= 0 then
				LootContainersCache[cid][lootType] = {id = lootContainerId, spriteId = container:getClientId()}
			end
		end
	end
end

-- add player to autoloot lists
function Player:registerAutoLoot()
	local cid = self:getId()
	if LootContainersCache[cid] then
		return
	end
	
	LootContainersCache[cid] = {}
	
	for slot = CONST_SLOT_FIRST, CONST_SLOT_STORE_INBOX do
		local slotItem = self:getSlotItem(slot)
		if slotItem then
			if slotItem:isContainer() then
				if slotItem:isLootContainer() then
					addPlayerLootContainer(self, slotItem)
				end
			
				for _, containerItem in pairs(slotItem:getItems(true)) do
					if containerItem:isContainer() and containerItem:isLootContainer() then
						addPlayerLootContainer(self, containerItem)
					end
				end
			end
		end
	end
end

-- remove player from autoloot lists
function Player:unregisterAutoLoot()
	local cid = self:getId()
	AutoLoot[cid] = nil
end

-- login
do
	local creatureEvent = CreatureEvent("AutoLootLogin")
	function creatureEvent.onLogin(player)
		if player:getStorageValue(PlayerStorageKeys.autoLootFallback) == -1 then
			-- enable fallback container by default
			player:setStorageValue(PlayerStorageKeys.autoLootFallback, 1)
		end
		
		player:registerEvent("AutoLootLogout")
		player:registerEvent("AutoLootDeath")
		player:registerAutoLoot()
		player:sendLootContainers()
		return true
	end
	creatureEvent:register()
end

-- logout
do
	local creatureEvent = CreatureEvent("AutoLootLogout")
	function creatureEvent.onLogout(player)
		player:unregisterAutoLoot()
		return true
	end
	creatureEvent:register()
end

-- death
do
	local creatureEvent = CreatureEvent("AutoLootDeath")
	function creatureEvent.onDeath(player)
		player:unregisterAutoLoot()
		return true
	end
	creatureEvent:register()
end

-- send loot containers
function Player:sendLootContainers()
	local msg = NetworkMessage()
	msg:addByte(AUTOLOOT_RESPONSE_LOOT_CONTAINERS)
	msg:addByte(self:getStorageValue(PlayerStorageKeys.autoLootFallback) == 1 and 0x01 or 0x00) -- fallback to main container checkbox

	local lootContainers = {}
	
	for categoryId, containerData in pairs(LootContainersCache[self:getId()]) do
		lootContainers[#lootContainers + 1] = {categoryId, containerData.spriteId}
	end
	
	msg:addByte(#lootContainers) -- list of containers
	for _, containerData in pairs(lootContainers) do
		msg:addByte(containerData[1])
		msg:addU16(containerData[2])
	end
	
	msg:sendToPlayer(self)
end
