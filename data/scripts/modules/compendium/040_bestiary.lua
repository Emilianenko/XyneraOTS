RATE_BESTIARY = 2 -- amount of points you get for killing monsters

-- you can hook other bestiary modifiers here
function Player:getIndividualBestiaryRate()
	return RATE_BESTIARY
end

local bestiaryLootTiers = {
	-- do not add more/remove tiers
	
	-- from rarest to common
	[0] = 10, -- very-rare
	[1] = 100, -- rare
	[2] = 1000, -- semi-rare
	[3] = 5000, -- uncommon
	[4] = 100000 -- common
}
------ METADATA
GameBestiary = {
	---- Amphibic
	["toad"] = {id = 262, class = BESTIARY_TYPE_AMPHIBIC, difficulty = 2, rarity = 1},
	["green frog"] = {id = 267, class = BESTIARY_TYPE_AMPHIBIC, difficulty = 1, rarity = 1},
	["azure frog"] = {id = 268, class = BESTIARY_TYPE_AMPHIBIC, difficulty = 2, rarity = 1},
	["coral frog"] = {id = 269, class = BESTIARY_TYPE_AMPHIBIC, difficulty = 2, rarity = 1},
	["crimson frog"] = {id = 270, class = BESTIARY_TYPE_AMPHIBIC, difficulty = 2, rarity = 1},
	["orchid frog"] = {id = 271, class = BESTIARY_TYPE_AMPHIBIC, difficulty = 2, rarity = 1},
	["infernal frog"] = {id = 563, class = BESTIARY_TYPE_AMPHIBIC, difficulty = 3, rarity = 2},
	["filth toad"] = {id = 735, class = BESTIARY_TYPE_AMPHIBIC, difficulty = 2, rarity = 2},
	["bog frog"] = {id = 738, class = BESTIARY_TYPE_AMPHIBIC, difficulty = 1, rarity = 1},
	["salamander"] = {id = 913, class = BESTIARY_TYPE_AMPHIBIC, difficulty = 2, rarity = 1},
	
	---- Aquatic
	["crab"] = {id = 112, class = BESTIARY_TYPE_AQUATIC, difficulty = 1, rarity = 1},
	["quara predator"] = {id = 237, class = BESTIARY_TYPE_AQUATIC, difficulty = 3, rarity = 1},
	["quara predator scout"] = {id = 238, class = BESTIARY_TYPE_AQUATIC, difficulty = 3, rarity = 1},
	["quara constrictor"] = {id = 239, class = BESTIARY_TYPE_AQUATIC, difficulty = 3, rarity = 1},
	["quara constrictor scout"] = {id = 240, class = BESTIARY_TYPE_AQUATIC, difficulty = 3, rarity = 1},
	["quara mantassin"] = {id = 241, class = BESTIARY_TYPE_AQUATIC, difficulty = 3, rarity = 1},
	["quara mantassin scout"] = {id = 242, class = BESTIARY_TYPE_AQUATIC, difficulty = 3, rarity = 1},
	["quara hydromancer"] = {id = 243, class = BESTIARY_TYPE_AQUATIC, difficulty = 3, rarity = 1},
	["quara hydromancer scout"] = {id = 244, class = BESTIARY_TYPE_AQUATIC, difficulty = 3, rarity = 1},
	["quara pincher"] = {id = 245, class = BESTIARY_TYPE_AQUATIC, difficulty = 3, rarity = 1},
	["quara pincher scout"] = {id = 246, class = BESTIARY_TYPE_AQUATIC, difficulty = 3, rarity = 1},
	["blood crab"] = {id = 261, class = BESTIARY_TYPE_AQUATIC, difficulty = 2, rarity = 1},
	["deepsea blood crab"] = {id = 437, class = BESTIARY_TYPE_AQUATIC, difficulty = 2, rarity = 1},
	["crustacea gigantica"] = {id = 697, class = BESTIARY_TYPE_AQUATIC, difficulty = 3, rarity = 4},
	["deepling scout"] = {id = 734, class = BESTIARY_TYPE_AQUATIC, difficulty = 3, rarity = 1},
	["deepling warrior"] = {id = 769, class = BESTIARY_TYPE_AQUATIC, difficulty = 3, rarity = 1},
	["deepling guard"] = {id = 770, class = BESTIARY_TYPE_AQUATIC, difficulty = 3, rarity = 1},
	["deepling spellsinger"] = {id = 772, class = BESTIARY_TYPE_AQUATIC, difficulty = 3, rarity = 1},
	["manta ray"] = {id = 779, class = BESTIARY_TYPE_AQUATIC, difficulty = 3, rarity = 3},
	["calamary"] = {id = 780, class = BESTIARY_TYPE_AQUATIC, difficulty = 2, rarity = 2},
	["jellyfish"] = {id = 781, class = BESTIARY_TYPE_AQUATIC, difficulty = 2, rarity = 2},
	["shark"] = {id = 782, class = BESTIARY_TYPE_AQUATIC, difficulty = 3, rarity = 1},
	["northern pike"] = {id = 783, class = BESTIARY_TYPE_AQUATIC, difficulty = 0, rarity = 2},
	["fish"] = {id = 784, class = BESTIARY_TYPE_AQUATIC, difficulty = 1, rarity = 1},
	["deepling worker"] = {id = 795, class = BESTIARY_TYPE_AQUATIC, difficulty = 2, rarity = 1},
	["deepling brawler"] = {id = 859, class = BESTIARY_TYPE_AQUATIC, difficulty = 3, rarity = 2},
	["deepling master librarian"] = {id = 860, class = BESTIARY_TYPE_AQUATIC, difficulty = 3, rarity = 3},
	["deepling tyrant"] = {id = 861, class = BESTIARY_TYPE_AQUATIC, difficulty = 4, rarity = 3},
	["deepling elite"] = {id = 862, class = BESTIARY_TYPE_AQUATIC, difficulty = 3, rarity = 2},
	["renegade quara constrictor"] = {id = 1097, class = BESTIARY_TYPE_AQUATIC, difficulty = 3, rarity = 3},
	["renegade quara hydromancer"] = {id = 1098, class = BESTIARY_TYPE_AQUATIC, difficulty = 3, rarity = 3},
	["renegade quara mantassin"] = {id = 1099, class = BESTIARY_TYPE_AQUATIC, difficulty = 3, rarity = 3},
	["renegade quara pincher"] = {id = 1100, class = BESTIARY_TYPE_AQUATIC, difficulty = 3, rarity = 3},
	["renegade quara predator"] = {id = 1101, class = BESTIARY_TYPE_AQUATIC, difficulty = 3, rarity = 3},
	["abyssal calamary"] = {id = 1105, class = BESTIARY_TYPE_AQUATIC, difficulty = 2, rarity = 1},
	["deathling scout"] = {id = 1667, class = BESTIARY_TYPE_AQUATIC, difficulty = 4, rarity = 1},
	["deathling spellsinger"] = {id = 1677, class = BESTIARY_TYPE_AQUATIC, difficulty = 4, rarity = 1},
	
	---- Bird
	["chicken"] = {id = 111, class = BESTIARY_TYPE_BIRD, difficulty = 1, rarity = 1},
	["flamingo"] = {id = 212, class = BESTIARY_TYPE_BIRD, difficulty = 1, rarity = 1},
	["parrot"] = {id = 217, class = BESTIARY_TYPE_BIRD, difficulty = 1, rarity = 1},
	["terror bird"] = {id = 218, class = BESTIARY_TYPE_BIRD, difficulty = 1, rarity = 1},
	["seagull"] = {id = 264, class = BESTIARY_TYPE_BIRD, difficulty = 1, rarity = 1},
	["penguin"] = {id = 318, class = BESTIARY_TYPE_BIRD, difficulty = 1, rarity = 1},
	["dire penguin"] = {id = 335, class = BESTIARY_TYPE_BIRD, difficulty = 2, rarity = 4},
	["berserker chicken"] = {id = 561, class = BESTIARY_TYPE_BIRD, difficulty = 3, rarity = 2},
	["demon parrot"] = {id = 562, class = BESTIARY_TYPE_BIRD, difficulty = 3, rarity = 2},
	["marsh stalker"] = {id = 914, class = BESTIARY_TYPE_BIRD, difficulty = 2, rarity = 1},
	["pigeon"] = {id = 915, class = BESTIARY_TYPE_BIRD, difficulty = 0, rarity = 2},
	["cave parrot"] = {id = 1307, class = BESTIARY_TYPE_BIRD, difficulty = 1, rarity = 1},
	["agrestic chicken"] = {id = 1979, class = BESTIARY_TYPE_BIRD, difficulty = 1, rarity = 1},
	
	---- Construct
	["stone golem"] = {id = 67, class = BESTIARY_TYPE_CONSTRUCT, difficulty = 2, rarity = 1},
	["ice golem"] = {id = 326, class = BESTIARY_TYPE_CONSTRUCT, difficulty = 3, rarity = 1},
	["worker golem"] = {id = 503, class = BESTIARY_TYPE_CONSTRUCT, difficulty = 3, rarity = 1},
	["damaged worker golem"] = {id = 524, class = BESTIARY_TYPE_CONSTRUCT, difficulty = 2, rarity = 1},
	["war golem"] = {id = 533, class = BESTIARY_TYPE_CONSTRUCT, difficulty = 3, rarity = 1},
	["eternal guardian"] = {id = 615, class = BESTIARY_TYPE_CONSTRUCT, difficulty = 3, rarity = 1},
	["cake golem"] = {id = 680, class = BESTIARY_TYPE_CONSTRUCT, difficulty = 2, rarity = 4},
	["iron servant"] = {id = 700, class = BESTIARY_TYPE_CONSTRUCT, difficulty = 2, rarity = 4},
	["golden servant"] = {id = 701, class = BESTIARY_TYPE_CONSTRUCT, difficulty = 3, rarity = 4},
	["diamond servant"] = {id = 702, class = BESTIARY_TYPE_CONSTRUCT, difficulty = 3, rarity = 4},
	["sandstone scorpion"] = {id = 705, class = BESTIARY_TYPE_CONSTRUCT, difficulty = 3, rarity = 3},
	["clay guardian"] = {id = 706, class = BESTIARY_TYPE_CONSTRUCT, difficulty = 3, rarity = 1},
	["enraged crystal golem"] = {id = 873, class = BESTIARY_TYPE_CONSTRUCT, difficulty = 3, rarity = 1},
	["damaged crystal golem"] = {id = 874, class = BESTIARY_TYPE_CONSTRUCT, difficulty = 2, rarity = 2},
	["stone devourer"] = {id = 879, class = BESTIARY_TYPE_CONSTRUCT, difficulty = 4, rarity = 2},
	["weeper"] = {id = 882, class = BESTIARY_TYPE_CONSTRUCT, difficulty = 4, rarity = 2},
	["orewalker"] = {id = 883, class = BESTIARY_TYPE_CONSTRUCT, difficulty = 4, rarity = 2},
	["lava golem"] = {id = 884, class = BESTIARY_TYPE_CONSTRUCT, difficulty = 4, rarity = 2},
	["magma crawler"] = {id = 885, class = BESTIARY_TYPE_CONSTRUCT, difficulty = 4, rarity = 1},
	["infected weeper"] = {id = 897, class = BESTIARY_TYPE_CONSTRUCT, difficulty = 4, rarity = 2},
	["glooth golem"] = {id = 1038, class = BESTIARY_TYPE_CONSTRUCT, difficulty = 3, rarity = 1},
	["metal gargoyle"] = {id = 1039, class = BESTIARY_TYPE_CONSTRUCT, difficulty = 3, rarity = 1},
	["rustheap golem"] = {id = 1041, class = BESTIARY_TYPE_CONSTRUCT, difficulty = 3, rarity = 1},
	["walker"] = {id = 1043, class = BESTIARY_TYPE_CONSTRUCT, difficulty = 3, rarity = 2},
	["iron servant replica"] = {id = 1325, class = BESTIARY_TYPE_CONSTRUCT, difficulty = 3, rarity = 1},
	["diamond servant replica"] = {id = 1326, class = BESTIARY_TYPE_CONSTRUCT, difficulty = 3, rarity = 3},
	["golden servant replica"] = {id = 1327, class = BESTIARY_TYPE_CONSTRUCT, difficulty = 3, rarity = 3},
	["biting book"] = {id = 1656, class = BESTIARY_TYPE_CONSTRUCT, difficulty = 4, rarity = 1},
	["animated snowman"] = {id = 1751, class = BESTIARY_TYPE_CONSTRUCT, difficulty = 3, rarity = 3},
	["rotten golem"] = {id = 1939, class = BESTIARY_TYPE_CONSTRUCT, difficulty = 5, rarity = 1},
	
	---- Demon
	["demon"] = {id = 35, class = BESTIARY_TYPE_DEMON, difficulty = 4, rarity = 1},
	["fire devil"] = {id = 40, class = BESTIARY_TYPE_DEMON, difficulty = 2, rarity = 1},
	["dark torturer"] = {id = 285, class = BESTIARY_TYPE_DEMON, difficulty = 4, rarity = 1},
	["destroyer"] = {id = 287, class = BESTIARY_TYPE_DEMON, difficulty = 3, rarity = 1},
	["diabolic imp"] = {id = 288, class = BESTIARY_TYPE_DEMON, difficulty = 3, rarity = 1},
	["fury"] = {id = 291, class = BESTIARY_TYPE_DEMON, difficulty = 4, rarity = 1},
	["hellhound"] = {id = 294, class = BESTIARY_TYPE_DEMON, difficulty = 4, rarity = 1},
	["hellfire fighter"] = {id = 295, class = BESTIARY_TYPE_DEMON, difficulty = 4, rarity = 1},
	["juggernaut"] = {id = 296, class = BESTIARY_TYPE_DEMON, difficulty = 4, rarity = 1},
	["plaguesmith"] = {id = 314, class = BESTIARY_TYPE_DEMON, difficulty = 3, rarity = 1},
	["hellspawn"] = {id = 519, class = BESTIARY_TYPE_DEMON, difficulty = 3, rarity = 1},
	["gozzler"] = {id = 523, class = BESTIARY_TYPE_DEMON, difficulty = 2, rarity = 1},
	["duskbringer"] = {id = 581, class = BESTIARY_TYPE_DEMON, difficulty = 3, rarity = 4},
	["shadow hound"] = {id = 582, class = BESTIARY_TYPE_DEMON, difficulty = 3, rarity = 4},
	["herald of gloom"] = {id = 586, class = BESTIARY_TYPE_DEMON, difficulty = 3, rarity = 4},
	["shaburak demon"] = {id = 724, class = BESTIARY_TYPE_DEMON, difficulty = 3, rarity = 1},
	["shaburak lord"] = {id = 725, class = BESTIARY_TYPE_DEMON, difficulty = 3, rarity = 3},
	["shaburak prince"] = {id = 726, class = BESTIARY_TYPE_DEMON, difficulty = 3, rarity = 3},
	["askarak demon"] = {id = 727, class = BESTIARY_TYPE_DEMON, difficulty = 3, rarity = 1},
	["askarak lord"] = {id = 728, class = BESTIARY_TYPE_DEMON, difficulty = 3, rarity = 3},
	["askarak prince"] = {id = 729, class = BESTIARY_TYPE_DEMON, difficulty = 3, rarity = 3},
	["nightfiend"] = {id = 973, class = BESTIARY_TYPE_DEMON, difficulty = 3, rarity = 4},
	["demon outcast"] = {id = 1019, class = BESTIARY_TYPE_DEMON, difficulty = 4, rarity = 1},
	["dawnfire asura"] = {id = 1134, class = BESTIARY_TYPE_DEMON, difficulty = 4, rarity = 1},
	["midnight asura"] = {id = 1135, class = BESTIARY_TYPE_DEMON, difficulty = 3, rarity = 1},
	["grimeleech"] = {id = 1196, class = BESTIARY_TYPE_DEMON, difficulty = 4, rarity = 1},
	["vexclaw"] = {id = 1197, class = BESTIARY_TYPE_DEMON, difficulty = 4, rarity = 1},
	["hellflayer"] = {id = 1198, class = BESTIARY_TYPE_DEMON, difficulty = 4, rarity = 1},
	["frost flower asura"] = {id = 1619, class = BESTIARY_TYPE_DEMON, difficulty = 3, rarity = 1},
	["true dawnfire asura"] = {id = 1620, class = BESTIARY_TYPE_DEMON, difficulty = 4, rarity = 1},
	["true midnight asura"] = {id = 1621, class = BESTIARY_TYPE_DEMON, difficulty = 4, rarity = 1},
	["true frost flower asura"] = {id = 1622, class = BESTIARY_TYPE_DEMON, difficulty = 4, rarity = 1},
	["floating savant"] = {id = 1637, class = BESTIARY_TYPE_DEMON, difficulty = 4, rarity = 1},
	["many faces"] = {id = 1927, class = BESTIARY_TYPE_DEMON, difficulty = 5, rarity = 1},
	["brachiodemon"] = {id = 1930, class = BESTIARY_TYPE_DEMON, difficulty = 5, rarity = 1},
	["infernal demon"] = {id = 1938, class = BESTIARY_TYPE_DEMON, difficulty = 5, rarity = 1},
	
	---- Dragon
	["dragon"] = {id = 34, class = BESTIARY_TYPE_DRAGON, difficulty = 3, rarity = 1},
	["dragon lord"] = {id = 39, class = BESTIARY_TYPE_DRAGON, difficulty = 3, rarity = 1},
	["hydra"] = {id = 121, class = BESTIARY_TYPE_DRAGON, difficulty = 3, rarity = 1},
	["frost dragon"] = {id = 317, class = BESTIARY_TYPE_DRAGON, difficulty = 3, rarity = 1},
	["dragon hatchling"] = {id = 385, class = BESTIARY_TYPE_DRAGON, difficulty = 3, rarity = 1},
	["dragon lord hatchling"] = {id = 386, class = BESTIARY_TYPE_DRAGON, difficulty = 3, rarity = 1},
	["frost dragon hatchling"] = {id = 402, class = BESTIARY_TYPE_DRAGON, difficulty = 3, rarity = 1},
	["wyrm"] = {id = 461, class = BESTIARY_TYPE_DRAGON, difficulty = 3, rarity = 1},
	["draken warmaster"] = {id = 617, class = BESTIARY_TYPE_DRAGON, difficulty = 3, rarity = 1},
	["draken spellweaver"] = {id = 618, class = BESTIARY_TYPE_DRAGON, difficulty = 4, rarity = 1},
	["ghastly dragon"] = {id = 643, class = BESTIARY_TYPE_DRAGON, difficulty = 4, rarity = 1},
	["draken elite"] = {id = 672, class = BESTIARY_TYPE_DRAGON, difficulty = 4, rarity = 1},
	["draken abomination"] = {id = 673, class = BESTIARY_TYPE_DRAGON, difficulty = 4, rarity = 1},
	["elder wyrm"] = {id = 963, class = BESTIARY_TYPE_DRAGON, difficulty = 4, rarity = 1},
	["haunted dragon"] = {id = 1376, class = BESTIARY_TYPE_DRAGON, difficulty = 4, rarity = 3},
	["ice dragon"] = {id = 1380, class = BESTIARY_TYPE_DRAGON, difficulty = 3, rarity = 3},
	
	---- Elemental
	["fire elemental"] = {id = 49, class = BESTIARY_TYPE_ELEMENTAL, difficulty = 3, rarity = 1},
	["water elemental"] = {id = 236, class = BESTIARY_TYPE_ELEMENTAL, difficulty = 3, rarity = 1},
	["massive water elemental"] = {id = 279, class = BESTIARY_TYPE_ELEMENTAL, difficulty = 3, rarity = 1},
	["massive fire elemental"] = {id = 313, class = BESTIARY_TYPE_ELEMENTAL, difficulty = 3, rarity = 1},
	["massive earth elemental"] = {id = 455, class = BESTIARY_TYPE_ELEMENTAL, difficulty = 3, rarity = 1},
	["massive energy elemental"] = {id = 456, class = BESTIARY_TYPE_ELEMENTAL, difficulty = 3, rarity = 1},
	["energy elemental"] = {id = 457, class = BESTIARY_TYPE_ELEMENTAL, difficulty = 3, rarity = 1},
	["earth elemental"] = {id = 458, class = BESTIARY_TYPE_ELEMENTAL, difficulty = 3, rarity = 1},
	["cliff strider"] = {id = 889, class = BESTIARY_TYPE_ELEMENTAL, difficulty = 4, rarity = 2},
	["ironblight"] = {id = 890, class = BESTIARY_TYPE_ELEMENTAL, difficulty = 4, rarity = 2},
	["furious fire elemental"] = {id = 1000, class = BESTIARY_TYPE_ELEMENTAL, difficulty = 3, rarity = 1},
	["high voltage elemental"] = {id = 1116, class = BESTIARY_TYPE_ELEMENTAL, difficulty = 3, rarity = 1},
	["raging fire"] = {id = 1121, class = BESTIARY_TYPE_ELEMENTAL, difficulty = 3, rarity = 4},
	["lava lurker"] = {id = 1563, class = BESTIARY_TYPE_ELEMENTAL, difficulty = 4, rarity = 1},
	["ravenous lava lurker"] = {id = 1569, class = BESTIARY_TYPE_ELEMENTAL, difficulty = 3, rarity = 1},
	["knowledge elemental"] = {id = 1670, class = BESTIARY_TYPE_ELEMENTAL, difficulty = 4, rarity = 2},
	["turbulent elemental"] = {id = 1940, class = BESTIARY_TYPE_ELEMENTAL, difficulty = 5, rarity = 1},
	
	---- Extra Dimensional
	["yielothax"] = {id = 717, class = BESTIARY_TYPE_EXTRA_DIMENSIONAL, difficulty = 3, rarity = 1},
	["reality reaver"] = {id = 1224, class = BESTIARY_TYPE_EXTRA_DIMENSIONAL, difficulty = 4, rarity = 1},
	["sparkion"] = {id = 1234, class = BESTIARY_TYPE_EXTRA_DIMENSIONAL, difficulty = 4, rarity = 1},
	["breach brood"] = {id = 1235, class = BESTIARY_TYPE_EXTRA_DIMENSIONAL, difficulty = 4, rarity = 1},
	["dread intruder"] = {id = 1260, class = BESTIARY_TYPE_EXTRA_DIMENSIONAL, difficulty = 4, rarity = 1},
	["instable sparkion"] = {id = 1264, class = BESTIARY_TYPE_EXTRA_DIMENSIONAL, difficulty = 3, rarity = 1},
	["instable breach brood"] = {id = 1265, class = BESTIARY_TYPE_EXTRA_DIMENSIONAL, difficulty = 3, rarity = 1},
	["stabilizing reality reaver"] = {id = 1266, class = BESTIARY_TYPE_EXTRA_DIMENSIONAL, difficulty = 3, rarity = 1},
	["stabilizing dread intruder"] = {id = 1267, class = BESTIARY_TYPE_EXTRA_DIMENSIONAL, difficulty = 3, rarity = 1},
	["courage leech"] = {id = 1941, class = BESTIARY_TYPE_EXTRA_DIMENSIONAL, difficulty = 5, rarity = 1},
	
	---- Fey
	["dryad"] = {id = 383, class = BESTIARY_TYPE_FEY, difficulty = 3, rarity = 4},
	["wisp"] = {id = 462, class = BESTIARY_TYPE_FEY, difficulty = 1, rarity = 1},
	["faun"] = {id = 1434, class = BESTIARY_TYPE_FEY, difficulty = 3, rarity = 1},
	["pooka"] = {id = 1435, class = BESTIARY_TYPE_FEY, difficulty = 3, rarity = 1},
	["twisted pooka"] = {id = 1436, class = BESTIARY_TYPE_FEY, difficulty = 3, rarity = 1},
	["swan maiden"] = {id = 1437, class = BESTIARY_TYPE_FEY, difficulty = 3, rarity = 2},
	["pixie"] = {id = 1438, class = BESTIARY_TYPE_FEY, difficulty = 3, rarity = 1},
	["boogy"] = {id = 1439, class = BESTIARY_TYPE_FEY, difficulty = 3, rarity = 1},
	["nymph"] = {id = 1485, class = BESTIARY_TYPE_FEY, difficulty = 3, rarity = 1},
	["dark faun"] = {id = 1496, class = BESTIARY_TYPE_FEY, difficulty = 3, rarity = 1},
	["arctic faun"] = {id = 1626, class = BESTIARY_TYPE_FEY, difficulty = 3, rarity = 2},
	["percht"] = {id = 1740, class = BESTIARY_TYPE_FEY, difficulty = 3, rarity = 3},
	["schiach"] = {id = 1741, class = BESTIARY_TYPE_FEY, difficulty = 3, rarity = 3},
	
	---- Giant
	["cyclops"] = {id = 22, class = BESTIARY_TYPE_GIANT, difficulty = 2, rarity = 1},
	["behemoth"] = {id = 55, class = BESTIARY_TYPE_GIANT, difficulty = 3, rarity = 1},
	["frost giant"] = {id = 324, class = BESTIARY_TYPE_GIANT, difficulty = 2, rarity = 1},
	["frost giantess"] = {id = 334, class = BESTIARY_TYPE_GIANT, difficulty = 2, rarity = 1},
	["cyclops smith"] = {id = 389, class = BESTIARY_TYPE_GIANT, difficulty = 3, rarity = 1},
	["cyclops drone"] = {id = 391, class = BESTIARY_TYPE_GIANT, difficulty = 3, rarity = 1},
	["ogre brute"] = {id = 1161, class = BESTIARY_TYPE_GIANT, difficulty = 3, rarity = 1},
	["ogre savage"] = {id = 1162, class = BESTIARY_TYPE_GIANT, difficulty = 3, rarity = 1},
	["ogre shaman"] = {id = 1163, class = BESTIARY_TYPE_GIANT, difficulty = 3, rarity = 1},
	["orclops doomhauler"] = {id = 1314, class = BESTIARY_TYPE_GIANT, difficulty = 3, rarity = 1},
	["orclops ravager"] = {id = 1320, class = BESTIARY_TYPE_GIANT, difficulty = 3, rarity = 1},
	["ogre ruffian"] = {id = 1820, class = BESTIARY_TYPE_GIANT, difficulty = 4, rarity = 1},
	["ogre rowdy"] = {id = 1821, class = BESTIARY_TYPE_GIANT, difficulty = 4, rarity = 1},
	["ogre sage"] = {id = 1822, class = BESTIARY_TYPE_GIANT, difficulty = 4, rarity = 1},
	["orger"] = {id = 1841, class = BESTIARY_TYPE_GIANT, difficulty = 3, rarity = 3},
	["loricate orger"] = {id = 1857, class = BESTIARY_TYPE_GIANT, difficulty = 3, rarity = 3},
	["bellicose orger"] = {id = 1858, class = BESTIARY_TYPE_GIANT, difficulty = 3, rarity = 3},
	
	---- Human
	["necromancer"] = {id = 9, class = BESTIARY_TYPE_HUMAN, difficulty = 3, rarity = 1},
	["warlock"] = {id = 10, class = BESTIARY_TYPE_HUMAN, difficulty = 3, rarity = 1},
	["hunter"] = {id = 11, class = BESTIARY_TYPE_HUMAN, difficulty = 2, rarity = 1},
	["valkyrie"] = {id = 12, class = BESTIARY_TYPE_HUMAN, difficulty = 2, rarity = 1},
	["wild warrior"] = {id = 47, class = BESTIARY_TYPE_HUMAN, difficulty = 2, rarity = 1},
	["witch"] = {id = 54, class = BESTIARY_TYPE_HUMAN, difficulty = 2, rarity = 1},
	["monk"] = {id = 57, class = BESTIARY_TYPE_HUMAN, difficulty = 2, rarity = 1},
	["priestess"] = {id = 58, class = BESTIARY_TYPE_HUMAN, difficulty = 3, rarity = 1},
	["stalker"] = {id = 72, class = BESTIARY_TYPE_HUMAN, difficulty = 2, rarity = 1},
	["hero"] = {id = 73, class = BESTIARY_TYPE_HUMAN, difficulty = 3, rarity = 1},
	["amazon"] = {id = 77, class = BESTIARY_TYPE_HUMAN, difficulty = 2, rarity = 1},
	["smuggler"] = {id = 222, class = BESTIARY_TYPE_HUMAN, difficulty = 2, rarity = 1},
	["bandit"] = {id = 223, class = BESTIARY_TYPE_HUMAN, difficulty = 2, rarity = 1},
	["assassin"] = {id = 224, class = BESTIARY_TYPE_HUMAN, difficulty = 2, rarity = 1},
	["dark monk"] = {id = 225, class = BESTIARY_TYPE_HUMAN, difficulty = 2, rarity = 1},
	["pirate marauder"] = {id = 247, class = BESTIARY_TYPE_HUMAN, difficulty = 2, rarity = 1},
	["pirate cutthroat"] = {id = 248, class = BESTIARY_TYPE_HUMAN, difficulty = 3, rarity = 1},
	["pirate buccaneer"] = {id = 249, class = BESTIARY_TYPE_HUMAN, difficulty = 3, rarity = 1},
	["pirate corsair"] = {id = 250, class = BESTIARY_TYPE_HUMAN, difficulty = 3, rarity = 1},
	["enlightened of the cult"] = {id = 252, class = BESTIARY_TYPE_HUMAN, difficulty = 3, rarity = 1},
	["acolyte of the cult"] = {id = 253, class = BESTIARY_TYPE_HUMAN, difficulty = 3, rarity = 1},
	["adept of the cult"] = {id = 254, class = BESTIARY_TYPE_HUMAN, difficulty = 3, rarity = 1},
	["novice of the cult"] = {id = 255, class = BESTIARY_TYPE_HUMAN, difficulty = 2, rarity = 1},
	["nomad"] = {id = 310, class = BESTIARY_TYPE_HUMAN, difficulty = 2, rarity = 1},
	["barbarian skullhunter"] = {id = 322, class = BESTIARY_TYPE_HUMAN, difficulty = 2, rarity = 1},
	["barbarian bloodwalker"] = {id = 323, class = BESTIARY_TYPE_HUMAN, difficulty = 3, rarity = 1},
	["ice witch"] = {id = 331, class = BESTIARY_TYPE_HUMAN, difficulty = 3, rarity = 1},
	["barbarian brutetamer"] = {id = 332, class = BESTIARY_TYPE_HUMAN, difficulty = 2, rarity = 1},
	["barbarian headsplitter"] = {id = 333, class = BESTIARY_TYPE_HUMAN, difficulty = 2, rarity = 1},
	["dark magician"] = {id = 371, class = BESTIARY_TYPE_HUMAN, difficulty = 2, rarity = 1},
	["dark apprentice"] = {id = 372, class = BESTIARY_TYPE_HUMAN, difficulty = 2, rarity = 1},
	["poacher"] = {id = 376, class = BESTIARY_TYPE_HUMAN, difficulty = 2, rarity = 1},
	["mutated human"] = {id = 521, class = BESTIARY_TYPE_HUMAN, difficulty = 3, rarity = 1},
	["crazed beggar"] = {id = 525, class = BESTIARY_TYPE_HUMAN, difficulty = 2, rarity = 1},
	["gang member"] = {id = 526, class = BESTIARY_TYPE_HUMAN, difficulty = 2, rarity = 1},
	["gladiator"] = {id = 527, class = BESTIARY_TYPE_HUMAN, difficulty = 2, rarity = 1},
	["mad scientist"] = {id = 528, class = BESTIARY_TYPE_HUMAN, difficulty = 2, rarity = 1},
	["infernalist"] = {id = 529, class = BESTIARY_TYPE_HUMAN, difficulty = 4, rarity = 1},
	["acolyte of darkness"] = {id = 578, class = BESTIARY_TYPE_HUMAN, difficulty = 2, rarity = 4},
	["nightslayer"] = {id = 579, class = BESTIARY_TYPE_HUMAN, difficulty = 3, rarity = 4},
	["doomsday cultist"] = {id = 583, class = BESTIARY_TYPE_HUMAN, difficulty = 2, rarity = 4},
	["midnight warrior"] = {id = 585, class = BESTIARY_TYPE_HUMAN, difficulty = 3, rarity = 4},
	["bride of night"] = {id = 587, class = BESTIARY_TYPE_HUMAN, difficulty = 3, rarity = 4},
	["feverish citizen"] = {id = 719, class = BESTIARY_TYPE_HUMAN, difficulty = 2, rarity = 3},	
	["nomad_blue"] = {baseName = "Nomad", id = 776, class = BESTIARY_TYPE_HUMAN, difficulty = 2, rarity = 2},
	["nomad_female"] = {baseName = "Nomad", id = 777, class = BESTIARY_TYPE_HUMAN, difficulty = 2, rarity = 2},
	["grave robber"] = {id = 867, class = BESTIARY_TYPE_HUMAN, difficulty = 2, rarity = 3},
	["crypt defiler"] = {id = 868, class = BESTIARY_TYPE_HUMAN, difficulty = 2, rarity = 3},
	["adventurer"] = {id = 922, class = BESTIARY_TYPE_HUMAN, difficulty = 2, rarity = 1},
	["shadow pupil"] = {id = 960, class = BESTIARY_TYPE_HUMAN, difficulty = 3, rarity = 1},
	["blood priest"] = {id = 961, class = BESTIARY_TYPE_HUMAN, difficulty = 3, rarity = 1},
	["blood hand"] = {id = 974, class = BESTIARY_TYPE_HUMAN, difficulty = 3, rarity = 1},
	["glooth bandit"] = {id = 1119, class = BESTIARY_TYPE_HUMAN, difficulty = 3, rarity = 1},
	["glooth brigand"] = {id = 1120, class = BESTIARY_TYPE_HUMAN, difficulty = 3, rarity = 1},
	["vicious squire"] = {id = 1145, class = BESTIARY_TYPE_HUMAN, difficulty = 3, rarity = 1},
	["renegade knight"] = {id = 1146, class = BESTIARY_TYPE_HUMAN, difficulty = 3, rarity = 1},
	["vile grandmaster"] = {id = 1147, class = BESTIARY_TYPE_HUMAN, difficulty = 3, rarity = 1},
	["misguided thief"] = {id = 1413, class = BESTIARY_TYPE_HUMAN, difficulty = 3, rarity = 1},
	["goldhanded cultist"] = {id = 1481, class = BESTIARY_TYPE_HUMAN, difficulty = 3, rarity = 2},
	["goldhanded cultist bride"] = {id = 1482, class = BESTIARY_TYPE_HUMAN, difficulty = 3, rarity = 2},
	["cult believer"] = {id = 1512, class = BESTIARY_TYPE_HUMAN, difficulty = 3, rarity = 1},
	["cult enforcer"] = {id = 1513, class = BESTIARY_TYPE_HUMAN, difficulty = 3, rarity = 1},
	["cult scholar"] = {id = 1514, class = BESTIARY_TYPE_HUMAN, difficulty = 3, rarity = 2},
	["cobra assassin"] = {id = 1775, class = BESTIARY_TYPE_HUMAN, difficulty = 4, rarity = 1},
	["cobra scout"] = {id = 1776, class = BESTIARY_TYPE_HUMAN, difficulty = 4, rarity = 1},
	["burning gladiator"] = {id = 1798, class = BESTIARY_TYPE_HUMAN, difficulty = 4, rarity = 1},
	["priestess of the wild sun"] = {id = 1799, class = BESTIARY_TYPE_HUMAN, difficulty = 4, rarity = 1},
	["black sphinx acolyte"] = {id = 1800, class = BESTIARY_TYPE_HUMAN, difficulty = 4, rarity = 1},
	["cobra vizier"] = {id = 1824, class = BESTIARY_TYPE_HUMAN, difficulty = 4, rarity = 1},
	["usurper knight"] = {id = 1972, class = BESTIARY_TYPE_HUMAN, difficulty = 4, rarity = 1},
	["usurper archer"] = {id = 1973, class = BESTIARY_TYPE_HUMAN, difficulty = 4, rarity = 1},
	["usurper warlock"] = {id = 1974, class = BESTIARY_TYPE_HUMAN, difficulty = 4, rarity = 1},
	["hulking carnisylvan"] = {id = 2107, class = BESTIARY_TYPE_HUMAN, difficulty = 4, rarity = 1},
	["poisonous carnisylvan"] = {id = 2108, class = BESTIARY_TYPE_HUMAN, difficulty = 4, rarity = 1},
	["dark carnisylvan"] = {id = 2109, class = BESTIARY_TYPE_HUMAN, difficulty = 4, rarity = 1},
	
	---- Humanoid
	["orc warlord"] = {id = 2, class = BESTIARY_TYPE_HUMANOID, difficulty = 3, rarity = 1},
	["orc rider"] = {id = 4, class = BESTIARY_TYPE_HUMANOID, difficulty = 2, rarity = 1},
	["orc"] = {id = 5, class = BESTIARY_TYPE_HUMANOID, difficulty = 2, rarity = 1},
	["orc shaman"] = {id = 6, class = BESTIARY_TYPE_HUMANOID, difficulty = 2, rarity = 1},
	["orc warrior"] = {id = 7, class = BESTIARY_TYPE_HUMANOID, difficulty = 2, rarity = 1},
	["orc berserker"] = {id = 8, class = BESTIARY_TYPE_HUMANOID, difficulty = 3, rarity = 1},
	["troll"] = {id = 15, class = BESTIARY_TYPE_HUMANOID, difficulty = 1, rarity = 1},
	["minotaur mage"] = {id = 23, class = BESTIARY_TYPE_HUMANOID, difficulty = 2, rarity = 1},
	["minotaur archer"] = {id = 24, class = BESTIARY_TYPE_HUMANOID, difficulty = 2, rarity = 1},
	["minotaur"] = {id = 25, class = BESTIARY_TYPE_HUMANOID, difficulty = 2, rarity = 1},
	["minotaur guard"] = {id = 29, class = BESTIARY_TYPE_HUMANOID, difficulty = 2, rarity = 1},
	["orc spearman"] = {id = 50, class = BESTIARY_TYPE_HUMANOID, difficulty = 2, rarity = 1},
	["frost troll"] = {id = 53, class = BESTIARY_TYPE_HUMANOID, difficulty = 1, rarity = 1},
	["orc leader"] = {id = 59, class = BESTIARY_TYPE_HUMANOID, difficulty = 3, rarity = 1},
	["goblin"] = {id = 61, class = BESTIARY_TYPE_HUMANOID, difficulty = 1, rarity = 1},
	["elf"] = {id = 62, class = BESTIARY_TYPE_HUMANOID, difficulty = 2, rarity = 1},
	["elf arcanist"] = {id = 63, class = BESTIARY_TYPE_HUMANOID, difficulty = 2, rarity = 1},
	["elf scout"] = {id = 64, class = BESTIARY_TYPE_HUMANOID, difficulty = 2, rarity = 1},
	["dwarf geomancer"] = {id = 66, class = BESTIARY_TYPE_HUMANOID, difficulty = 3, rarity = 1},
	["dwarf"] = {id = 69, class = BESTIARY_TYPE_HUMANOID, difficulty = 2, rarity = 1},
	["dwarf guard"] = {id = 70, class = BESTIARY_TYPE_HUMANOID, difficulty = 2, rarity = 1},
	["dwarf soldier"] = {id = 71, class = BESTIARY_TYPE_HUMANOID, difficulty = 2, rarity = 1},
	["swamp troll"] = {id = 76, class = BESTIARY_TYPE_HUMANOID, difficulty = 2, rarity = 1},
	["dworc voodoomaster"] = {id = 214, class = BESTIARY_TYPE_HUMANOID, difficulty = 2, rarity = 1},
	["dworc fleshhunter"] = {id = 215, class = BESTIARY_TYPE_HUMANOID, difficulty = 2, rarity = 1},
	["dworc venomsniper"] = {id = 216, class = BESTIARY_TYPE_HUMANOID, difficulty = 2, rarity = 1},
	["island troll"] = {id = 277, class = BESTIARY_TYPE_HUMANOID, difficulty = 1, rarity = 1},
	["chakoya tribewarden"] = {id = 319, class = BESTIARY_TYPE_HUMANOID, difficulty = 2, rarity = 1},
	["chakoya toolshaper"] = {id = 328, class = BESTIARY_TYPE_HUMANOID, difficulty = 2, rarity = 1},
	["chakoya windcaller"] = {id = 329, class = BESTIARY_TYPE_HUMANOID, difficulty = 2, rarity = 1},
	["goblin leader"] = {id = 377, class = BESTIARY_TYPE_HUMANOID, difficulty = 2, rarity = 4},
	["dwarf henchman"] = {id = 379, class = BESTIARY_TYPE_HUMANOID, difficulty = 3, rarity = 1},
	["troll champion"] = {id = 392, class = BESTIARY_TYPE_HUMANOID, difficulty = 2, rarity = 1},
	["grynch clan goblin"] = {id = 393, class = BESTIARY_TYPE_HUMANOID, difficulty = 1, rarity = 4},
	["goblin assassin"] = {id = 463, class = BESTIARY_TYPE_HUMANOID, difficulty = 2, rarity = 1},
	["goblin scavenger"] = {id = 464, class = BESTIARY_TYPE_HUMANOID, difficulty = 2, rarity = 1},
	["furious troll"] = {id = 540, class = BESTIARY_TYPE_HUMANOID, difficulty = 2, rarity = 2},
	["troll legionnaire"] = {id = 541, class = BESTIARY_TYPE_HUMANOID, difficulty = 3, rarity = 1},
	["orc marauder"] = {id = 614, class = BESTIARY_TYPE_HUMANOID, difficulty = 3, rarity = 1},
	["firestarter"] = {id = 737, class = BESTIARY_TYPE_HUMANOID, difficulty = 2, rarity = 3},
	["elf overseer"] = {id = 741, class = BESTIARY_TYPE_HUMANOID, difficulty = 3, rarity = 4},
	["troll guard"] = {id = 745, class = BESTIARY_TYPE_HUMANOID, difficulty = 2, rarity = 4},
	["enslaved dwarf"] = {id = 886, class = BESTIARY_TYPE_HUMANOID, difficulty = 3, rarity = 1},
	["lost berserker"] = {id = 888, class = BESTIARY_TYPE_HUMANOID, difficulty = 4, rarity = 1},
	["corym charlatan"] = {id = 916, class = BESTIARY_TYPE_HUMANOID, difficulty = 2, rarity = 1},
	["corym skirmisher"] = {id = 917, class = BESTIARY_TYPE_HUMANOID, difficulty = 3, rarity = 1},
	["corym vanguard"] = {id = 918, class = BESTIARY_TYPE_HUMANOID, difficulty = 3, rarity = 1},
	["little corym charlatan"] = {id = 920, class = BESTIARY_TYPE_HUMANOID, difficulty = 2, rarity = 2},
	["lost husher"] = {id = 924, class = BESTIARY_TYPE_HUMANOID, difficulty = 3, rarity = 1},
	["lost basher"] = {id = 925, class = BESTIARY_TYPE_HUMANOID, difficulty = 3, rarity = 1},
	["lost thrower"] = {id = 926, class = BESTIARY_TYPE_HUMANOID, difficulty = 3, rarity = 1},
	["moohtant"] = {id = 1044, class = BESTIARY_TYPE_HUMANOID, difficulty = 3, rarity = 1},
	["minotaur amazon"] = {id = 1045, class = BESTIARY_TYPE_HUMANOID, difficulty = 4, rarity = 1},
	["execowtioner"] = {id = 1046, class = BESTIARY_TYPE_HUMANOID, difficulty = 3, rarity = 1},
	["mooh'tah warrior"] = {id = 1051, class = BESTIARY_TYPE_HUMANOID, difficulty = 3, rarity = 1},
	["minotaur hunter"] = {id = 1052, class = BESTIARY_TYPE_HUMANOID, difficulty = 3, rarity = 1},
	["worm priestess"] = {id = 1053, class = BESTIARY_TYPE_HUMANOID, difficulty = 3, rarity = 1},
	["minotaur invader"] = {id = 1109, class = BESTIARY_TYPE_HUMANOID, difficulty = 3, rarity = 3},
	["broken shaper"] = {id = 1321, class = BESTIARY_TYPE_HUMANOID, difficulty = 3, rarity = 1},
	["twisted shaper"] = {id = 1322, class = BESTIARY_TYPE_HUMANOID, difficulty = 3, rarity = 1},
	["shaper matriarch"] = {id = 1394, class = BESTIARY_TYPE_HUMANOID, difficulty = 3, rarity = 1},
	["misguided bully"] = {id = 1412, class = BESTIARY_TYPE_HUMANOID, difficulty = 3, rarity = 1},
	["barkless devotee"] = {id = 1486, class = BESTIARY_TYPE_HUMANOID, difficulty = 3, rarity = 1},
	["barkless fanatic"] = {id = 1488, class = BESTIARY_TYPE_HUMANOID, difficulty = 3, rarity = 1},
	["orc cultist"] = {id = 1503, class = BESTIARY_TYPE_HUMANOID, difficulty = 3, rarity = 2},
	["orc cult priest"] = {id = 1504, class = BESTIARY_TYPE_HUMANOID, difficulty = 3, rarity = 2},
	["orc cult inquisitor"] = {id = 1505, class = BESTIARY_TYPE_HUMANOID, difficulty = 3, rarity = 2},
	["orc cult fanatic"] = {id = 1506, class = BESTIARY_TYPE_HUMANOID, difficulty = 3, rarity = 2},
	["orc cult minion"] = {id = 1507, class = BESTIARY_TYPE_HUMANOID, difficulty = 3, rarity = 2},
	["minotaur cult follower"] = {id = 1508, class = BESTIARY_TYPE_HUMANOID, difficulty = 3, rarity = 1},
	["minotaur cult prophet"] = {id = 1509, class = BESTIARY_TYPE_HUMANOID, difficulty = 3, rarity = 1},
	["minotaur cult zealot"] = {id = 1510, class = BESTIARY_TYPE_HUMANOID, difficulty = 3, rarity = 1},
	["lost exile"] = {id = 1529, class = BESTIARY_TYPE_HUMANOID, difficulty = 3, rarity = 1},
	["crazed winter vanguard"] = {id = 1730, class = BESTIARY_TYPE_HUMANOID, difficulty = 4, rarity = 1},
	["crazed winter rearguard"] = {id = 1731, class = BESTIARY_TYPE_HUMANOID, difficulty = 4, rarity = 1},
	["crazed summer vanguard"] = {id = 1732, class = BESTIARY_TYPE_HUMANOID, difficulty = 4, rarity = 1},
	["crazed summer rearguard"] = {id = 1733, class = BESTIARY_TYPE_HUMANOID, difficulty = 4, rarity = 1},
	["soul-broken harbinger"] = {id = 1734, class = BESTIARY_TYPE_HUMANOID, difficulty = 4, rarity = 1},
	["insane siren"] = {id = 1735, class = BESTIARY_TYPE_HUMANOID, difficulty = 4, rarity = 1},
	["pirat cutthroat"] = {id = 2036, class = BESTIARY_TYPE_HUMANOID, difficulty = 3, rarity = 1},
	["pirat scoundrel"] = {id = 2037, class = BESTIARY_TYPE_HUMANOID, difficulty = 3, rarity = 1},
	["pirat bombardier"] = {id = 2038, class = BESTIARY_TYPE_HUMANOID, difficulty = 3, rarity = 1},
	["pirat mate"] = {id = 2039, class = BESTIARY_TYPE_HUMANOID, difficulty = 3, rarity = 1},
	
	---- Lycanthrope
	["werewolf"] = {id = 510, class = BESTIARY_TYPE_LYCANTHROPE, difficulty = 3, rarity = 1},
	["werebear"] = {id = 1142, class = BESTIARY_TYPE_LYCANTHROPE, difficulty = 3, rarity = 1},
	["wereboar"] = {id = 1143, class = BESTIARY_TYPE_LYCANTHROPE, difficulty = 3, rarity = 1},
	["werebadger"] = {id = 1144, class = BESTIARY_TYPE_LYCANTHROPE, difficulty = 3, rarity = 1},
	["werefox"] = {id = 1549, class = BESTIARY_TYPE_LYCANTHROPE, difficulty = 3, rarity = 1},
	["werehyaena"] = {id = 1963, class = BESTIARY_TYPE_LYCANTHROPE, difficulty = 3, rarity = 1},
	["werehyaena shaman"] = {id = 1964, class = BESTIARY_TYPE_LYCANTHROPE, difficulty = 3, rarity = 1},
	["werelion"] = {id = 1965, class = BESTIARY_TYPE_LYCANTHROPE, difficulty = 4, rarity = 1},
	["werelioness"] = {id = 1966, class = BESTIARY_TYPE_LYCANTHROPE, difficulty = 4, rarity = 1},
	
	---- Magical
	["bonelord"] = {id = 17, class = BESTIARY_TYPE_MAGICAL, difficulty = 2, rarity = 1},
	["green djinn"] = {id = 51, class = BESTIARY_TYPE_MAGICAL, difficulty = 3, rarity = 1},
	["blue djinn"] = {id = 80, class = BESTIARY_TYPE_MAGICAL, difficulty = 3, rarity = 1},
	["gargoyle"] = {id = 95, class = BESTIARY_TYPE_MAGICAL, difficulty = 2, rarity = 1},
	["efreet"] = {id = 103, class = BESTIARY_TYPE_MAGICAL, difficulty = 3, rarity = 1},
	["marid"] = {id = 104, class = BESTIARY_TYPE_MAGICAL, difficulty = 3, rarity = 1},
	["elder bonelord"] = {id = 108, class = BESTIARY_TYPE_MAGICAL, difficulty = 3, rarity = 1},
	["gazer"] = {id = 109, class = BESTIARY_TYPE_MAGICAL, difficulty = 2, rarity = 1},
	["phantasm"] = {id = 292, class = BESTIARY_TYPE_MAGICAL, difficulty = 4, rarity = 1},
	["nightmare"] = {id = 299, class = BESTIARY_TYPE_MAGICAL, difficulty = 3, rarity = 1},
	["crystal spider"] = {id = 330, class = BESTIARY_TYPE_MAGICAL, difficulty = 3, rarity = 1},
	["bog raider"] = {id = 460, class = BESTIARY_TYPE_MAGICAL, difficulty = 3, rarity = 1},
	["nightmare scion"] = {id = 518, class = BESTIARY_TYPE_MAGICAL, difficulty = 3, rarity = 1},
	["nightstalker"] = {id = 520, class = BESTIARY_TYPE_MAGICAL, difficulty = 3, rarity = 1},
	["medusa"] = {id = 570, class = BESTIARY_TYPE_MAGICAL, difficulty = 4, rarity = 1},
	["midnight panther"] = {id = 698, class = BESTIARY_TYPE_MAGICAL, difficulty = 3, rarity = 4},
	["thornfire wolf"] = {id = 739, class = BESTIARY_TYPE_MAGICAL, difficulty = 3, rarity = 4},
	["crystal wolf"] = {id = 740, class = BESTIARY_TYPE_MAGICAL, difficulty = 3, rarity = 4},
	["crystalcrusher"] = {id = 869, class = BESTIARY_TYPE_MAGICAL, difficulty = 3, rarity = 1},
	["armadile"] = {id = 880, class = BESTIARY_TYPE_MAGICAL, difficulty = 4, rarity = 2},
	["dragonling"] = {id = 894, class = BESTIARY_TYPE_MAGICAL, difficulty = 3, rarity = 2},
	["rorc"] = {id = 978, class = BESTIARY_TYPE_MAGICAL, difficulty = 2, rarity = 1},
	["forest fury"] = {id = 980, class = BESTIARY_TYPE_MAGICAL, difficulty = 3, rarity = 1},
	["shock head"] = {id = 1004, class = BESTIARY_TYPE_MAGICAL, difficulty = 4, rarity = 1},
	["sight of surrender"] = {id = 1012, class = BESTIARY_TYPE_MAGICAL, difficulty = 4, rarity = 1},
	["guzzlemaw"] = {id = 1013, class = BESTIARY_TYPE_MAGICAL, difficulty = 4, rarity = 1},
	["silencer"] = {id = 1014, class = BESTIARY_TYPE_MAGICAL, difficulty = 3, rarity = 1},
	["choking fear"] = {id = 1015, class = BESTIARY_TYPE_MAGICAL, difficulty = 4, rarity = 1},
	["terrorsleep"] = {id = 1016, class = BESTIARY_TYPE_MAGICAL, difficulty = 4, rarity = 1},
	["retching horror"] = {id = 1018, class = BESTIARY_TYPE_MAGICAL, difficulty = 4, rarity = 1},
	["feversleep"] = {id = 1021, class = BESTIARY_TYPE_MAGICAL, difficulty = 3, rarity = 1},
	["frazzlemaw"] = {id = 1022, class = BESTIARY_TYPE_MAGICAL, difficulty = 4, rarity = 1},
	["tainted soul"] = {id = 1137, class = BESTIARY_TYPE_MAGICAL, difficulty = 2, rarity = 1},
	["redeemed soul"] = {id = 1138, class = BESTIARY_TYPE_MAGICAL, difficulty = 2, rarity = 1},
	["elder forest fury"] = {id = 1157, class = BESTIARY_TYPE_MAGICAL, difficulty = 3, rarity = 2},
	["weakened frazzlemaw"] = {id = 1442, class = BESTIARY_TYPE_MAGICAL, difficulty = 3, rarity = 1},
	["enfeebled silencer"] = {id = 1443, class = BESTIARY_TYPE_MAGICAL, difficulty = 3, rarity = 1},
	["brain squid"] = {id = 1653, class = BESTIARY_TYPE_MAGICAL, difficulty = 4, rarity = 1},
	["flying book"] = {id = 1654, class = BESTIARY_TYPE_MAGICAL, difficulty = 3, rarity = 2},
	["cursed book"] = {id = 1655, class = BESTIARY_TYPE_MAGICAL, difficulty = 4, rarity = 2},
	["guardian of tales"] = {id = 1659, class = BESTIARY_TYPE_MAGICAL, difficulty = 4, rarity = 2},
	["burning book"] = {id = 1663, class = BESTIARY_TYPE_MAGICAL, difficulty = 4, rarity = 1},
	["icecold book"] = {id = 1664, class = BESTIARY_TYPE_MAGICAL, difficulty = 4, rarity = 1},
	["energetic book"] = {id = 1665, class = BESTIARY_TYPE_MAGICAL, difficulty = 4, rarity = 1},
	["energuardian of tales"] = {id = 1666, class = BESTIARY_TYPE_MAGICAL, difficulty = 4, rarity = 1},
	["rage squid"] = {id = 1668, class = BESTIARY_TYPE_MAGICAL, difficulty = 4, rarity = 1},
	["squid warden"] = {id = 1669, class = BESTIARY_TYPE_MAGICAL, difficulty = 4, rarity = 1},
	["animated feather"] = {id = 1671, class = BESTIARY_TYPE_MAGICAL, difficulty = 4, rarity = 1},
	["lumbering carnivor"] = {id = 1721, class = BESTIARY_TYPE_MAGICAL, difficulty = 3, rarity = 1},
	["spiky carnivor"] = {id = 1722, class = BESTIARY_TYPE_MAGICAL, difficulty = 4, rarity = 1},
	["menacing carnivor"] = {id = 1723, class = BESTIARY_TYPE_MAGICAL, difficulty = 4, rarity = 1},
	["thanatursus"] = {id = 1728, class = BESTIARY_TYPE_MAGICAL, difficulty = 4, rarity = 1},
	["arachnophobica"] = {id = 1729, class = BESTIARY_TYPE_MAGICAL, difficulty = 4, rarity = 1},
	["crypt warden"] = {id = 1805, class = BESTIARY_TYPE_MAGICAL, difficulty = 4, rarity = 1},
	["lamassu"] = {id = 1806, class = BESTIARY_TYPE_MAGICAL, difficulty = 4, rarity = 1},
	["feral sphinx"] = {id = 1807, class = BESTIARY_TYPE_MAGICAL, difficulty = 4, rarity = 1},
	["sphinx"] = {id = 1808, class = BESTIARY_TYPE_MAGICAL, difficulty = 4, rarity = 1},
	["manticore"] = {id = 1816, class = BESTIARY_TYPE_MAGICAL, difficulty = 4, rarity = 1},
	["gryphon"] = {id = 1819, class = BESTIARY_TYPE_MAGICAL, difficulty = 3, rarity = 2},
	["venerable girtablilu"] = {id = 2098, class = BESTIARY_TYPE_MAGICAL, difficulty = 4, rarity = 1},
	["girtablilu warrior"] = {id = 2099, class = BESTIARY_TYPE_MAGICAL, difficulty = 4, rarity = 1},
	["bashmu"] = {id = 2100, class = BESTIARY_TYPE_MAGICAL, difficulty = 4, rarity = 1},
	["juvenile bashmu"] = {id = 2101, class = BESTIARY_TYPE_MAGICAL, difficulty = 4, rarity = 1},

	---- Mammal
	["war wolf"] = {id = 3, class = BESTIARY_TYPE_MAMMAL, difficulty = 2, rarity = 1},
	["black sheep"] = {id = 13, class = BESTIARY_TYPE_MAMMAL, difficulty = 1, rarity = 2},
	["sheep"] = {id = 14, class = BESTIARY_TYPE_MAMMAL, difficulty = 1, rarity = 1},
	["bear"] = {id = 16, class = BESTIARY_TYPE_MAMMAL, difficulty = 2, rarity = 1},
	["rat"] = {id = 21, class = BESTIARY_TYPE_MAMMAL, difficulty = 1, rarity = 1},
	["wolf"] = {id = 27, class = BESTIARY_TYPE_MAMMAL, difficulty = 1, rarity = 1},
	["deer"] = {id = 31, class = BESTIARY_TYPE_MAMMAL, difficulty = 1, rarity = 1},
	["dog"] = {id = 32, class = BESTIARY_TYPE_MAMMAL, difficulty = 0, rarity = 1},
	["lion"] = {id = 41, class = BESTIARY_TYPE_MAMMAL, difficulty = 2, rarity = 1},
	["polar bear"] = {id = 42, class = BESTIARY_TYPE_MAMMAL, difficulty = 2, rarity = 1},
	["winter wolf"] = {id = 52, class = BESTIARY_TYPE_MAMMAL, difficulty = 1, rarity = 1},	
	["cave rat"] = {id = 56, class = BESTIARY_TYPE_MAMMAL, difficulty = 1, rarity = 1},
	["pig"] = {id = 60, class = BESTIARY_TYPE_MAMMAL, difficulty = 1, rarity = 1},
	["rabbit"] = {id = 74, class = BESTIARY_TYPE_MAMMAL, difficulty = 1, rarity = 1},
	["hyaena"] = {id = 94, class = BESTIARY_TYPE_MAMMAL, difficulty = 2, rarity = 1},
	["badger"] = {id = 105, class = BESTIARY_TYPE_MAMMAL, difficulty = 1, rarity = 1},	
	["skunk"] = {id = 106, class = BESTIARY_TYPE_MAMMAL, difficulty = 1, rarity = 1},
	["yeti"] = {id = 110, class = BESTIARY_TYPE_MAMMAL, difficulty = 3, rarity = 4},
	["kongra"] = {id = 116, class = BESTIARY_TYPE_MAMMAL, difficulty = 2, rarity = 1},
	["merlkin"] = {id = 117, class = BESTIARY_TYPE_MAMMAL, difficulty = 2, rarity = 1},
	["sibang"] = {id = 118, class = BESTIARY_TYPE_MAMMAL, difficulty = 2, rarity = 1},
	["bat"] = {id = 122, class = BESTIARY_TYPE_MAMMAL, difficulty = 1, rarity = 1},
	["panda"] = {id = 123, class = BESTIARY_TYPE_MAMMAL, difficulty = 2, rarity = 1},
	["tiger"] = {id = 125, class = BESTIARY_TYPE_MAMMAL, difficulty = 2, rarity = 1},
	["elephant"] = {id = 211, class = BESTIARY_TYPE_MAMMAL, difficulty = 2, rarity = 1},
	["mammoth"] = {id = 260, class = BESTIARY_TYPE_MAMMAL, difficulty = 2, rarity = 1},
	["husky"] = {id = 325, class = BESTIARY_TYPE_MAMMAL, difficulty = 0, rarity = 1},
	["silver rabbit"] = {id = 327, class = BESTIARY_TYPE_MAMMAL, difficulty = 1, rarity = 1},
	["squirrel"] = {id = 384, class = BESTIARY_TYPE_MAMMAL, difficulty = 1, rarity = 1},
	["cat"] = {id = 387, class = BESTIARY_TYPE_MAMMAL, difficulty = 0, rarity = 1},
	["mutated rat"] = {id = 502, class = BESTIARY_TYPE_MAMMAL, difficulty = 3, rarity = 1},
	["mutated bat"] = {id = 509, class = BESTIARY_TYPE_MAMMAL, difficulty = 3, rarity = 1},
	["mutated tiger"] = {id = 516, class = BESTIARY_TYPE_MAMMAL, difficulty = 3, rarity = 1},
	["evil sheep"] = {id = 555, class = BESTIARY_TYPE_MAMMAL, difficulty = 3, rarity = 1},
	["evil sheep lord"] = {id = 556, class = BESTIARY_TYPE_MAMMAL, difficulty = 3, rarity = 2},
	["hot dog"] = {id = 557, class = BESTIARY_TYPE_MAMMAL, difficulty = 3, rarity = 2},
	["doom deer"] = {id = 559, class = BESTIARY_TYPE_MAMMAL, difficulty = 3, rarity = 2},
	["killer rabbit"] = {id = 560, class = BESTIARY_TYPE_MAMMAL, difficulty = 2, rarity = 2},
	["gnarlhound"] = {id = 630, class = BESTIARY_TYPE_MAMMAL, difficulty = 2, rarity = 1},
	["boar"] = {id = 693, class = BESTIARY_TYPE_MAMMAL, difficulty = 2, rarity = 1},
	["white deer"] = {id = 720, class = BESTIARY_TYPE_MAMMAL, difficulty = 1, rarity = 3},
	["starving wolf"] = {id = 723, class = BESTIARY_TYPE_MAMMAL, difficulty = 2, rarity = 3},
	["wild horse"] = {id = 730, class = BESTIARY_TYPE_MAMMAL, difficulty = 1, rarity = 4},
	["dromedary"] = {id = 733, class = BESTIARY_TYPE_MAMMAL, difficulty = 1, rarity = 1},
	["horse_white"] = {baseName = "Horse", id = 750, class = BESTIARY_TYPE_MAMMAL, difficulty = 1, rarity = 2},
	["horse_brown"] = {baseName = "Horse", id = 751, class = BESTIARY_TYPE_MAMMAL, difficulty = 1, rarity = 2},
	["horse_darkbrown"] = {baseName = "Horse", id = 752, class = BESTIARY_TYPE_MAMMAL, difficulty = 1, rarity = 3},
	["terrified elephant"] = {id = 771, class = BESTIARY_TYPE_MAMMAL, difficulty = 2, rarity = 1},
	["mushroom sniffer"] = {id = 870, class = BESTIARY_TYPE_MAMMAL, difficulty = 0, rarity = 1},
	["water buffalo"] = {id = 872, class = BESTIARY_TYPE_MAMMAL, difficulty = 2, rarity = 4},
	["modified gnarlhound"] = {id = 877, class = BESTIARY_TYPE_MAMMAL, difficulty = 0, rarity = 2},
	["vulcongra"] = {id = 898, class = BESTIARY_TYPE_MAMMAL, difficulty = 4, rarity = 1},
	["roaring lion"] = {id = 981, class = BESTIARY_TYPE_MAMMAL, difficulty = 3, rarity = 1},
	["noble lion"] = {id = 1118, class = BESTIARY_TYPE_MAMMAL, difficulty = 3, rarity = 2},
	["gloom wolf"] = {id = 1139, class = BESTIARY_TYPE_MAMMAL, difficulty = 2, rarity = 2},
	["clomp"] = {id = 1174, class = BESTIARY_TYPE_MAMMAL, difficulty = 3, rarity = 1},
	["stone rhino"] = {id = 1395, class = BESTIARY_TYPE_MAMMAL, difficulty = 3, rarity = 2},
	["fox"] = {id = 1548, class = BESTIARY_TYPE_MAMMAL, difficulty = 1, rarity = 1},
	["mole"] = {id = 1570, class = BESTIARY_TYPE_MAMMAL, difficulty = 2, rarity = 1},
	["baleful bunny"] = {id = 1742, class = BESTIARY_TYPE_MAMMAL, difficulty = 3, rarity = 3},
	["roast pork"] = {id = 1855, class = BESTIARY_TYPE_MAMMAL, difficulty = 3, rarity = 3},
	["cow"] = {id = 1856, class = BESTIARY_TYPE_MAMMAL, difficulty = 3, rarity = 3},
	["white lion"] = {id = 1967, class = BESTIARY_TYPE_MAMMAL, difficulty = 4, rarity = 1},
	["exotic bat"] = {id = 2051, class = BESTIARY_TYPE_MAMMAL, difficulty = 3, rarity = 1},
	
	---- Plant
	["carniphila"] = {id = 120, class = BESTIARY_TYPE_PLANT, difficulty = 3, rarity = 1},
	["spit nettle"] = {id = 221, class = BESTIARY_TYPE_PLANT, difficulty = 2, rarity = 1},
	["haunted treeling"] = {id = 511, class = BESTIARY_TYPE_PLANT, difficulty = 3, rarity = 1},
	["bane bringer"] = {id = 679, class = BESTIARY_TYPE_PLANT, difficulty = 3, rarity = 4},
	["humongous fungus"] = {id = 881, class = BESTIARY_TYPE_PLANT, difficulty = 4, rarity = 1},
	["hideous fungus"] = {id = 891, class = BESTIARY_TYPE_PLANT, difficulty = 4, rarity = 1},
	["swampling"] = {id = 919, class = BESTIARY_TYPE_PLANT, difficulty = 2, rarity = 1},
	["leaf golem"] = {id = 979, class = BESTIARY_TYPE_PLANT, difficulty = 2, rarity = 1},
	["wilting leaf golem"] = {id = 982, class = BESTIARY_TYPE_PLANT, difficulty = 3, rarity = 1},
	["glooth anemone"] = {id = 1042, class = BESTIARY_TYPE_PLANT, difficulty = 3, rarity = 1},
	["omnivora"] = {id = 1141, class = BESTIARY_TYPE_PLANT, difficulty = 3, rarity = 1},
	["cloak of terror"] = {id = 1928, class = BESTIARY_TYPE_PLANT, difficulty = 5, rarity = 1},
	["branchy crawler"] = {id = 1931, class = BESTIARY_TYPE_PLANT, difficulty = 5, rarity = 1},
	["lavafungus"] = {id = 2095, class = BESTIARY_TYPE_PLANT, difficulty = 4, rarity = 1},

	---- Reptile
	["snake"] = {id = 28, class = BESTIARY_TYPE_REPTILE, difficulty = 1, rarity = 1},
	["cobra"] = {id = 81, class = BESTIARY_TYPE_REPTILE, difficulty = 2, rarity = 1},
	["lizard templar"] = {id = 113, class = BESTIARY_TYPE_REPTILE, difficulty = 2, rarity = 1},
	["lizard sentinel"] = {id = 114, class = BESTIARY_TYPE_REPTILE, difficulty = 2, rarity = 1},
	["lizard snakecharmer"] = {id = 115, class = BESTIARY_TYPE_REPTILE, difficulty = 3, rarity = 1},
	["crocodile"] = {id = 119, class = BESTIARY_TYPE_REPTILE, difficulty = 2, rarity = 1},
	["serpent spawn"] = {id = 220, class = BESTIARY_TYPE_REPTILE, difficulty = 3, rarity = 1},
	["tortoise"] = {id = 258, class = BESTIARY_TYPE_REPTILE, difficulty = 2, rarity = 1},
	["thornback tortoise"] = {id = 259, class = BESTIARY_TYPE_REPTILE, difficulty = 2, rarity = 1},
	["wyvern"] = {id = 290, class = BESTIARY_TYPE_REPTILE, difficulty = 3, rarity = 1},
	["sea serpent"] = {id = 438, class = BESTIARY_TYPE_REPTILE, difficulty = 3, rarity = 1},
	["young sea serpent"] = {id = 439, class = BESTIARY_TYPE_REPTILE, difficulty = 3, rarity = 1},
	["lizard zaogun"] = {id = 616, class = BESTIARY_TYPE_REPTILE, difficulty = 3, rarity = 1},
	["lizard chosen"] = {id = 620, class = BESTIARY_TYPE_REPTILE, difficulty = 3, rarity = 1},
	["lizard dragon priest"] = {id = 623, class = BESTIARY_TYPE_REPTILE, difficulty = 3, rarity = 1},
	["lizard legionnaire"] = {id = 624, class = BESTIARY_TYPE_REPTILE, difficulty = 3, rarity = 1},
	["lizard high guard"] = {id = 625, class = BESTIARY_TYPE_REPTILE, difficulty = 3, rarity = 1},
	["killer caiman"] = {id = 627, class = BESTIARY_TYPE_REPTILE, difficulty = 3, rarity = 1},
	["lizard magistratus"] = {id = 655, class = BESTIARY_TYPE_REPTILE, difficulty = 3, rarity = 1},
	["lizard noble"] = {id = 656, class = BESTIARY_TYPE_REPTILE, difficulty = 4, rarity = 1},
	["stampor"] = {id = 694, class = BESTIARY_TYPE_REPTILE, difficulty = 3, rarity = 1},
	["draptor"] = {id = 695, class = BESTIARY_TYPE_REPTILE, difficulty = 3, rarity = 4},
	["seacrest serpent"] = {id = 1096, class = BESTIARY_TYPE_REPTILE, difficulty = 4, rarity = 3},
	["stonerefiner"] = {id = 1525, class = BESTIARY_TYPE_REPTILE, difficulty = 3, rarity = 1},
	["young goanna"] = {id = 1817, class = BESTIARY_TYPE_REPTILE, difficulty = 4, rarity = 1},
	["adult goanna"] = {id = 1818, class = BESTIARY_TYPE_REPTILE, difficulty = 4, rarity = 1},

	---- Slime
	["slime"] = {id = 19, class = BESTIARY_TYPE_SLIME, difficulty = 2, rarity = 1},
	["squidgy slime"] = {id = 20, class = BESTIARY_TYPE_SLIME, difficulty = 2, rarity = 3},
	["son of verminor"] = {id = 265, class = BESTIARY_TYPE_SLIME, difficulty = 4, rarity = 1},
	["defiler"] = {id = 289, class = BESTIARY_TYPE_SLIME, difficulty = 4, rarity = 1},
	["acid blob"] = {id = 513, class = BESTIARY_TYPE_SLIME, difficulty = 3, rarity = 1},
	["death blob"] = {id = 514, class = BESTIARY_TYPE_SLIME, difficulty = 3, rarity = 1},
	["mercury blob"] = {id = 515, class = BESTIARY_TYPE_SLIME, difficulty = 2, rarity = 1},
	["midnight spawn"] = {id = 584, class = BESTIARY_TYPE_SLIME, difficulty = 3, rarity = 4},
	["glooth blob"] = {id = 1054, class = BESTIARY_TYPE_SLIME, difficulty = 3, rarity = 1},
	["devourer"] = {id = 1056, class = BESTIARY_TYPE_SLIME, difficulty = 3, rarity = 1},
	["ink blob"] = {id = 1658, class = BESTIARY_TYPE_SLIME, difficulty = 4, rarity = 1},

	---- Undead
	["ghoul"] = {id = 18, class = BESTIARY_TYPE_UNDEAD, difficulty = 2, rarity = 1},
	["skeleton"] = {id = 33, class = BESTIARY_TYPE_UNDEAD, difficulty = 2, rarity = 1},
	["demon skeleton"] = {id = 37, class = BESTIARY_TYPE_UNDEAD, difficulty = 3, rarity = 1},
	["ghost"] = {id = 48, class = BESTIARY_TYPE_UNDEAD, difficulty = 2, rarity = 1},
	["mummy"] = {id = 65, class = BESTIARY_TYPE_UNDEAD, difficulty = 2, rarity = 1},
	["vampire"] = {id = 68, class = BESTIARY_TYPE_UNDEAD, difficulty = 3, rarity = 1},
	["banshee"] = {id = 78, class = BESTIARY_TYPE_UNDEAD, difficulty = 3, rarity = 1},
	["lich"] = {id = 99, class = BESTIARY_TYPE_UNDEAD, difficulty = 3, rarity = 1},
	["crypt shambler"] = {id = 100, class = BESTIARY_TYPE_UNDEAD, difficulty = 2, rarity = 1},
	["bonebeast"] = {id = 101, class = BESTIARY_TYPE_UNDEAD, difficulty = 3, rarity = 1},
	["pirate skeleton"] = {id = 256, class = BESTIARY_TYPE_UNDEAD, difficulty = 2, rarity = 1},
	["pirate ghost"] = {id = 257, class = BESTIARY_TYPE_UNDEAD, difficulty = 2, rarity = 1},
	["hand of cursed fate"] = {id = 281, class = BESTIARY_TYPE_UNDEAD, difficulty = 4, rarity = 1},
	["undead dragon"] = {id = 282, class = BESTIARY_TYPE_UNDEAD, difficulty = 4, rarity = 1},
	["lost soul"] = {id = 283, class = BESTIARY_TYPE_UNDEAD, difficulty = 3, rarity = 1},
	["betrayed wraith"] = {id = 284, class = BESTIARY_TYPE_UNDEAD, difficulty = 3, rarity = 1},
	["spectre"] = {id = 286, class = BESTIARY_TYPE_UNDEAD, difficulty = 3, rarity = 1},
	["blightwalker"] = {id = 298, class = BESTIARY_TYPE_UNDEAD, difficulty = 4, rarity = 1},
	["braindeath"] = {id = 321, class = BESTIARY_TYPE_UNDEAD, difficulty = 3, rarity = 1},
	["undead jester"] = {id = 388, class = BESTIARY_TYPE_UNDEAD, difficulty = 1, rarity = 4},
	["skeleton warrior"] = {id = 446, class = BESTIARY_TYPE_UNDEAD, difficulty = 2, rarity = 1},
	["grim reaper"] = {id = 465, class = BESTIARY_TYPE_UNDEAD, difficulty = 4, rarity = 1},
	["vampire bride"] = {id = 483, class = BESTIARY_TYPE_UNDEAD, difficulty = 3, rarity = 1},
	["undead gladiator"] = {id = 508, class = BESTIARY_TYPE_UNDEAD, difficulty = 3, rarity = 1},
	["zombie"] = {id = 512, class = BESTIARY_TYPE_UNDEAD, difficulty = 3, rarity = 1},
	["vampire pig"] = {id = 558, class = BESTIARY_TYPE_UNDEAD, difficulty = 3, rarity = 2},
	["bane of light"] = {id = 580, class = BESTIARY_TYPE_UNDEAD, difficulty = 3, rarity = 4},
	["undead mine worker"] = {id = 594, class = BESTIARY_TYPE_UNDEAD, difficulty = 2, rarity = 2},
	["undead prospector"] = {id = 595, class = BESTIARY_TYPE_UNDEAD, difficulty = 2, rarity = 2},
	["souleater"] = {id = 675, class = BESTIARY_TYPE_UNDEAD, difficulty = 3, rarity = 1},
	["undead cavebear"] = {id = 696, class = BESTIARY_TYPE_UNDEAD, difficulty = 3, rarity = 4},
	["ghoulish hyaena"] = {id = 704, class = BESTIARY_TYPE_UNDEAD, difficulty = 3, rarity = 3},
	["grave guard"] = {id = 707, class = BESTIARY_TYPE_UNDEAD, difficulty = 3, rarity = 3},
	["tomb servant"] = {id = 708, class = BESTIARY_TYPE_UNDEAD, difficulty = 3, rarity = 3},
	["death priest"] = {id = 710, class = BESTIARY_TYPE_UNDEAD, difficulty = 3, rarity = 3},
	["elder mummy"] = {id = 711, class = BESTIARY_TYPE_UNDEAD, difficulty = 3, rarity = 3},
	["honour guard"] = {id = 712, class = BESTIARY_TYPE_UNDEAD, difficulty = 2, rarity = 3},
	["vampire viscount"] = {id = 958, class = BESTIARY_TYPE_UNDEAD, difficulty = 3, rarity = 1},
	["vicious manbat"] = {id = 959, class = BESTIARY_TYPE_UNDEAD, difficulty = 3, rarity = 4},
	["white shade"] = {id = 962, class = BESTIARY_TYPE_UNDEAD, difficulty = 2, rarity = 1},
	["gravedigger"] = {id = 975, class = BESTIARY_TYPE_UNDEAD, difficulty = 3, rarity = 1},
	["tarnished spirit"] = {id = 976, class = BESTIARY_TYPE_UNDEAD, difficulty = 2, rarity = 1},
	["blood beast"] = {id = 1040, class = BESTIARY_TYPE_UNDEAD, difficulty = 3, rarity = 1},
	["rot elemental"] = {id = 1055, class = BESTIARY_TYPE_UNDEAD, difficulty = 3, rarity = 1},
	["ghost wolf"] = {id = 1148, class = BESTIARY_TYPE_UNDEAD, difficulty = 2, rarity = 3},
	["putrid mummy"] = {id = 1415, class = BESTIARY_TYPE_UNDEAD, difficulty = 3, rarity = 1},
	["falcon knight"] = {id = 1646, class = BESTIARY_TYPE_UNDEAD, difficulty = 4, rarity = 1},
	["falcon paladin"] = {id = 1647, class = BESTIARY_TYPE_UNDEAD, difficulty = 4, rarity = 1},
	["skeleton elite warrior"] = {id = 1674, class = BESTIARY_TYPE_UNDEAD, difficulty = 4, rarity = 1},
	["undead elite gladiator"] = {id = 1675, class = BESTIARY_TYPE_UNDEAD, difficulty = 4, rarity = 1},
	["ripper spectre"] = {id = 1724, class = BESTIARY_TYPE_UNDEAD, difficulty = 4, rarity = 1},
	["gazer spectre"] = {id = 1725, class = BESTIARY_TYPE_UNDEAD, difficulty = 4, rarity = 1},
	["burster spectre"] = {id = 1726, class = BESTIARY_TYPE_UNDEAD, difficulty = 4, rarity = 1},
	["flimsy lost soul"] = {id = 1864, class = BESTIARY_TYPE_UNDEAD, difficulty = 4, rarity = 1},
	["mean lost soul"] = {id = 1865, class = BESTIARY_TYPE_UNDEAD, difficulty = 4, rarity = 1},
	["freakish lost soul"] = {id = 1866, class = BESTIARY_TYPE_UNDEAD, difficulty = 4, rarity = 1},
	["cursed prospector"] = {id = 1880, class = BESTIARY_TYPE_UNDEAD, difficulty = 4, rarity = 1},
	["evil prospector"] = {id = 1885, class = BESTIARY_TYPE_UNDEAD, difficulty = 4, rarity = 1},
	["bony sea devil"] = {id = 1926, class = BESTIARY_TYPE_UNDEAD, difficulty = 5, rarity = 1},
	["vibrant phantom"] = {id = 1929, class = BESTIARY_TYPE_UNDEAD, difficulty = 5, rarity = 1},
	["capricious phantom"] = {id = 1932, class = BESTIARY_TYPE_UNDEAD, difficulty = 5, rarity = 1},
	["infernal phantom"] = {id = 1933, class = BESTIARY_TYPE_UNDEAD, difficulty = 5, rarity = 1},
	["mould phantom"] = {id = 1945, class = BESTIARY_TYPE_UNDEAD, difficulty = 5, rarity = 1},
	["druid's apparition"] = {id = 1946, class = BESTIARY_TYPE_UNDEAD, difficulty = 5, rarity = 1},
	["knight's apparition"] = {id = 1947, class = BESTIARY_TYPE_UNDEAD, difficulty = 5, rarity = 1},
	["paladin's apparition"] = {id = 1948, class = BESTIARY_TYPE_UNDEAD, difficulty = 5, rarity = 1},
	["sorcerer's apparition"] = {id = 1949, class = BESTIARY_TYPE_UNDEAD, difficulty = 5, rarity = 1},
	["distorted phantom"] = {id = 1962, class = BESTIARY_TYPE_UNDEAD, difficulty = 5, rarity = 1},
	["crypt warrior"] = {id = 1995, class = BESTIARY_TYPE_UNDEAD, difficulty = 4, rarity = 1},
	
	---- Vermin
	["rotworm"] = {id = 26, class = BESTIARY_TYPE_VERMIN, difficulty = 2, rarity = 1},
	["spider"] = {id = 30, class = BESTIARY_TYPE_VERMIN, difficulty = 1, rarity = 1},
	["poison spider"] = {id = 36, class = BESTIARY_TYPE_VERMIN, difficulty = 1, rarity = 1},
	["giant spider"] = {id = 38, class = BESTIARY_TYPE_VERMIN, difficulty = 3, rarity = 1},
	["scorpion"] = {id = 43, class = BESTIARY_TYPE_VERMIN, difficulty = 2, rarity = 1},
	["wasp"] = {id = 44, class = BESTIARY_TYPE_VERMIN, difficulty = 1, rarity = 1},
	["bug"] = {id = 45, class = BESTIARY_TYPE_VERMIN, difficulty = 1, rarity = 1},
	["ancient scarab"] = {id = 79, class = BESTIARY_TYPE_VERMIN, difficulty = 3, rarity = 1},
	["larva"] = {id = 82, class = BESTIARY_TYPE_VERMIN, difficulty = 2, rarity = 1},
	["scarab"] = {id = 83, class = BESTIARY_TYPE_VERMIN, difficulty = 2, rarity = 1},
	["centipede"] = {id = 124, class = BESTIARY_TYPE_VERMIN, difficulty = 2, rarity = 1},
	["butterfly_purple"] = {baseName = "Butterfly", id = 213, class = BESTIARY_TYPE_VERMIN, difficulty = 0, rarity = 1},
	["tarantula"] = {id = 219, class = BESTIARY_TYPE_VERMIN, difficulty = 2, rarity = 1},
	["butterfly_blue"] = {baseName = "Butterfly", id = 227, class = BESTIARY_TYPE_VERMIN, difficulty = 0, rarity = 1},
	["butterfly_red"] = {baseName = "Butterfly", id = 228, class = BESTIARY_TYPE_VERMIN, difficulty = 0, rarity = 1},
	["carrion worm"] = {id = 251, class = BESTIARY_TYPE_VERMIN, difficulty = 2, rarity = 1},
	["insect swarm"] = {id = 621, class = BESTIARY_TYPE_VERMIN, difficulty = 2, rarity = 1},
	["terramite"] = {id = 631, class = BESTIARY_TYPE_VERMIN, difficulty = 2, rarity = 1},
	["wailing widow"] = {id = 632, class = BESTIARY_TYPE_VERMIN, difficulty = 3, rarity = 1},
	["lancer beetle"] = {id = 633, class = BESTIARY_TYPE_VERMIN, difficulty = 3, rarity = 1},
	["sandcrawler"] = {id = 641, class = BESTIARY_TYPE_VERMIN, difficulty = 1, rarity = 1},
	["brimstone bug"] = {id = 674, class = BESTIARY_TYPE_VERMIN, difficulty = 3, rarity = 1},
	["berrypest"] = {id = 691, class = BESTIARY_TYPE_VERMIN, difficulty = 0, rarity = 4},
	["sacred spider"] = {id = 709, class = BESTIARY_TYPE_VERMIN, difficulty = 3, rarity = 3},
	["slug"] = {id = 731, class = BESTIARY_TYPE_VERMIN, difficulty = 2, rarity = 1},
	["insectoid scout"] = {id = 732, class = BESTIARY_TYPE_VERMIN, difficulty = 2, rarity = 3},
	["ladybug"] = {id = 778, class = BESTIARY_TYPE_VERMIN, difficulty = 2, rarity = 3},
	["crawler"] = {id = 786, class = BESTIARY_TYPE_VERMIN, difficulty = 3, rarity = 1},
	["spidris"] = {id = 787, class = BESTIARY_TYPE_VERMIN, difficulty = 3, rarity = 3},
	["kollos"] = {id = 788, class = BESTIARY_TYPE_VERMIN, difficulty = 3, rarity = 3},
	["swarmer"] = {id = 790, class = BESTIARY_TYPE_VERMIN, difficulty = 3, rarity = 1},
	["spitter"] = {id = 791, class = BESTIARY_TYPE_VERMIN, difficulty = 3, rarity = 1},
	["waspoid"] = {id = 792, class = BESTIARY_TYPE_VERMIN, difficulty = 3, rarity = 1},
	["insectoid worker"] = {id = 796, class = BESTIARY_TYPE_VERMIN, difficulty = 3, rarity = 1},
	["spidris elite"] = {id = 797, class = BESTIARY_TYPE_VERMIN, difficulty = 3, rarity = 3},
	["hive overseer"] = {id = 801, class = BESTIARY_TYPE_VERMIN, difficulty = 4, rarity = 3},
	["drillworm"] = {id = 878, class = BESTIARY_TYPE_VERMIN, difficulty = 3, rarity = 1},
	["wiggler"] = {id = 899, class = BESTIARY_TYPE_VERMIN, difficulty = 3, rarity = 1},
	["emerald damselfly"] = {id = 912, class = BESTIARY_TYPE_VERMIN, difficulty = 2, rarity = 1},
	["deepworm"] = {id = 1531, class = BESTIARY_TYPE_VERMIN, difficulty = 4, rarity = 1},
	["diremaw"] = {id = 1532, class = BESTIARY_TYPE_VERMIN, difficulty = 4, rarity = 1},
	["cave devourer"] = {id = 1544, class = BESTIARY_TYPE_VERMIN, difficulty = 4, rarity = 1},
	["tunnel tyrant"] = {id = 1545, class = BESTIARY_TYPE_VERMIN, difficulty = 4, rarity = 1},
	["chasm spawn"] = {id = 1546, class = BESTIARY_TYPE_VERMIN, difficulty = 4, rarity = 1},
	["lacewing moth"] = {id = 1736, class = BESTIARY_TYPE_VERMIN, difficulty = 3, rarity = 2},
	["hibernal moth"] = {id = 1737, class = BESTIARY_TYPE_VERMIN, difficulty = 3, rarity = 2},
	["exotic cave spider"] = {id = 2024, class = BESTIARY_TYPE_VERMIN, difficulty = 3, rarity = 1},
	["lavaworm"] = {id = 2088, class = BESTIARY_TYPE_VERMIN, difficulty = 4, rarity = 1},
	["tremendous tyrant"] = {id = 2089, class = BESTIARY_TYPE_VERMIN, difficulty = 4, rarity = 1},
	["varnished diremaw"] = {id = 2090, class = BESTIARY_TYPE_VERMIN, difficulty = 4, rarity = 1},
	["streaked devourer"] = {id = 2091, class = BESTIARY_TYPE_VERMIN, difficulty = 4, rarity = 1},
	["eyeless devourer"] = {id = 2092, class = BESTIARY_TYPE_VERMIN, difficulty = 4, rarity = 1},
	["blemished spawn"] = {id = 2093, class = BESTIARY_TYPE_VERMIN, difficulty = 4, rarity = 1},
	["afflicted strider"] = {id = 2094, class = BESTIARY_TYPE_VERMIN, difficulty = 4, rarity = 1},
	["cave chimera"] = {id = 2096, class = BESTIARY_TYPE_VERMIN, difficulty = 4, rarity = 1},
}

do -- generate remaining metadata
	-- bestiary main page
	-- autogenerated
	GameBestiaryTypes = {}
	GameBestiaryCount = 0
	for bestiaryType = BESTIARY_TYPE_FIRST, BESTIARY_TYPE_LAST do
		GameBestiaryTypes[bestiaryType] = {name = BestiaryNameByType[bestiaryType], races = {}}
	end
	for raceName, raceData in pairs(GameBestiary) do
		if GameBestiaryTypes[raceData.class] then
			GameBestiaryTypes[raceData.class].races[#GameBestiaryTypes[raceData.class].races + 1] = raceData.id
			GameBestiaryCount = GameBestiaryCount + 1
		end
	end
	
	-- order bestiary by id ascending
	for _, categoryData in pairs(GameBestiaryTypes) do
		table.sort(categoryData.races)
	end
	
	local bestiaryRaceToNameMap = {}
	for raceName, raceData in pairs(GameBestiary) do
		bestiaryRaceToNameMap[raceData.id] = raceName
	end
	function getBestiaryRaceDataById(id)
		return id and bestiaryRaceToNameMap[id] and GameBestiary[bestiaryRaceToNameMap[id]]
	end
	
	-- execute after monster types have been loaded
	-- cache monster names
	local function cacheBaseNames()
		for raceName, raceData in pairs(GameBestiary) do
			if not raceData.baseName then
				local monsterType = MonsterType(raceName)
				if monsterType then
					GameBestiary[raceName].baseName	= monsterType:name()
				end
			end
		end
	end
	addEvent(cacheBaseNames, 1000)
end

GameBestiaryDifficulties = {
	-- number of stars (from harmless to challenging)
	-- rarity 4 triggers rare values
	[0] = {kills = {5, 10, 25}, rareKills = {2, 3, 5}, charmPoints = 1, rareCharmPoints = 5},
	[1] = {kills = {10, 100, 250}, rareKills = {2, 3, 5}, charmPoints = 5, rareCharmPoints = 10},
	[2] = {kills = {25, 250, 500}, rareKills = {2, 3, 5}, charmPoints = 15, rareCharmPoints = 30},
	[3] = {kills = {50, 500, 1000}, rareKills = {2, 3, 5}, charmPoints = 25, rareCharmPoints = 50},
	[4] = {kills = {100, 1000, 2500}, rareKills = {2, 3, 5}, charmPoints = 50, rareCharmPoints = 100},
	[5] = {kills = {200, 2000, 5000}, rareKills = {2, 3, 5}, charmPoints = 100, rareCharmPoints = 200}
}

function Monster:getBestiaryRaceName()
	local outfit = self:getOutfit()
	local lookType = outfit.lookType
	local monsterName = self:getName():lower()
	-- special entries

	-- butterfly types
	if monsterName == "butterfly" then
		if lookType == 10 then
			return "butterfly_yellow" -- no matching race id
		elseif lookType == 213 then
			return "butterly_purple"
		elseif lookType == 227 then
			return "butterly_blue"
		elseif lookType == 228 then
			return "butterly_red"
		end
		
		return
		
	-- nomad variants
	elseif monsterName == "nomad" then
		if lookType == 150 then
			return "nomad_female"
		elseif outfit.lookBody == 48 then
			return "nomad_blue"
		end
		
		return "nomad"
	
	-- horse types
	elseif monsterName == "horse" then
		if lookType == 434 then
			return "horse_white"
		elseif lookType == 435 then
			return "horse_darkbrown"
		elseif lookType == 436 then
			return "horse_brown"
		end
		
		return
		
	-- exclude demongoblin
	elseif monsterName == "demon" then
		if self:getMaxHealth() == 8200 then
			return "demon"
		end
		
		return "demon_goblin" -- no matching race id
	end
	
	return monsterName
end

------ STORAGE MANAGER
-- charms
local charmPointsStorage = PlayerStorageKeys.resourcesBase + RESOURCE_CHARM_POINTS
function Player:getCharmPoints()
	return self:getStorageValue(charmPointsStorage)
end

function Player:setCharmPoints(amount)
	return self:setStorageValue(charmPointsStorage, amount)
end

function Player:addCharmPoints(amount)
	return self:setCharmPoints(self:getCharmPoints() + amount)
end

function Player:removeCharmPoints(amount)
	return self:setCharmPoints(self:getCharmPoints() - amount)
end

-- bestiary progress
function Player:getBestiaryRaceProgress(raceId)
	return math.max(0, self:getStorageValue(PlayerStorageKeys.bestiaryRaceProgressBase + raceId))
end

function Player:setBestiaryRaceProgress(raceId, newLevel)
	return self:setStorageValue(PlayerStorageKeys.bestiaryRaceProgressBase + raceId, newLevel)
end

function Player:getBestiaryCategoryProgress(categoryId)
	return math.max(0, self:getStorageValue(PlayerStorageKeys.bestiaryCategoryProgressBase + categoryId))
end

function Player:addBestiaryCategoryProgress(categoryId, amount)
	return self:setStorageValue(PlayerStorageKeys.bestiaryCategoryProgressBase + categoryId, self:getBestiaryCategoryProgress(categoryId) + amount)
end

-- kill count
function Player:getBestiaryKillCount(raceId)
	return math.max(0, self:getStorageValue(PlayerStorageKeys.bestiaryKillCountBase + raceId))
end

do
	local function getBestiaryLevelByKills(killMap, killCount)
		if killCount == 0 then
			return 0
		end
		
		for i = 1, #killMap do
			if killCount < killMap[i] then
				return i
			end
		end
		
		return #killMap + 1
	end
	
	function Player:addBestiaryKillCount(raceId, amount)
		-- note: this function ignores bestiary rate
		-- if you intend to use bestiary rate when adding kills, call:
		-- player:addBestiaryKillCount(raceId, player:getIndividualBestiaryRate())
		
		-- get race data
		local race = getBestiaryRaceDataById(raceId)
		if not race then
			return
		end
		
		-- update kill count
		local killCount = self:getBestiaryKillCount(raceId) + amount
		self:setStorageValue(PlayerStorageKeys.bestiaryKillCountBase + raceId, killCount)
		
		-- update unlock level info
		local progessLevel = self:getBestiaryRaceProgress(raceId)
		if progessLevel > 3 then
			-- fully unlocked, no more level ups
			return
		end
		
		-- determine if the player levelled up
		local rare = race.rarity == 4
		local killMap = not rare and GameBestiaryDifficulties[race.difficulty].kills or GameBestiaryDifficulties[race.difficulty].rareKills
		local newProgressLevel = getBestiaryLevelByKills(killMap, killCount)
		if newProgressLevel > progessLevel then
			
			-- unlock details
			self:setBestiaryRaceProgress(raceId, newProgressLevel)
			
			-- complete the monster
			if newProgressLevel == 4 then
				self:addBestiaryCategoryProgress(race.class, 1)
				self:addCharmPoints(not rare and GameBestiaryDifficulties[race.difficulty].charmPoints or GameBestiaryDifficulties[race.difficulty].rareCharmPoints)
			end
			
			-- send message
			local monsterName = race.baseName
			if monsterName then
				self:sendTextMessage(MESSAGE_STATUS_WARNING, string.format('You unlocked details for the creature "%s".', monsterName))
			end
			
			-- trigger screenshot (possible to disable in client)
			self:takeScreenshot(progessLevel < 4 and SCREENSHOT_TYPE_BESTIARYENTRYUNLOCKED or SCREENSHOT_TYPE_BESTIARYENTRYCOMPLETED)			
		end
		
	end
end

function Player:addBestiaryKill(killedMonster)
	local raceName = killedMonster:getBestiaryRaceName()
	if raceName then
		local race = GameBestiary[raceName]
		if race and race.id then
			self:addBestiaryKillCount(race.id, self:getIndividualBestiaryRate())
			return true
		end
	end
	
	return false
end

------ DEV FUNCTIONS (may cause lag when used)
-- full unlock creature
function Player:completeBestiaryEntry(raceId)
	local race = getBestiaryRaceDataById(raceId)
	if not race then
		return false
	end
	
	if self:getBestiaryRaceProgress(raceId) == 4 then
		return true
	end

	local killMap = not (race.rarity == 4) and GameBestiaryDifficulties[race.difficulty].kills or GameBestiaryDifficulties[race.difficulty].rareKills
	
	self:addBestiaryKillCount(raceId, self:getBestiaryKillCount(raceId) - killMap[3])
	return true
end

-- full reset creature
function Player:resetBestiaryEntry(raceId)
	local progessLevel = self:getStorageValue(PlayerStorageKeys.bestiaryRaceProgressBase + raceId)
	-- reset category progress for this creature
	if progessLevel == 4 then
		self:setStorageValue(PlayerStorageKeys.bestiaryCategoryProgressBase + categoryId, self:getStorageValue(PlayerStorageKeys.bestiaryCategoryProgressBase + categoryId) - 1)
	end
	
	-- reset kill count and unlock level
	self:setStorageValue(PlayerStorageKeys.bestiaryRaceProgressBase + raceId, -1)
	self:setStorageValue(PlayerStorageKeys.bestiaryKillCountBase + raceId, -1)
	
	-- remove gained charm points (if applicable)
	local race = getBestiaryRaceDataById(raceId)
	if race and progessLevel == 4 then
		self:addCharmPoints(-(not (race.rarity == 4) and GameBestiaryDifficulties[race.difficulty].charmPoints or GameBestiaryDifficulties[race.difficulty].rareCharmPoints))
	end
end

-- full unlock bestiary
function Player:unlockFullBestiary()
	for raceId, _ in pairs(bestiaryRaceToNameMap) do
		self:completeBestiaryEntry(raceId)
	end
end

-- full reset bestiary
function Player:resetBestiary()
	for raceId, _ in pairs(bestiaryRaceToNameMap) do
		self:setStorageValue(PlayerStorageKeys.bestiaryRaceProgressBase + raceId, -1)
		self:setStorageValue(PlayerStorageKeys.bestiaryKillCountBase + raceId, -1)
	end
	
	for categoryId = BESTIARY_TYPE_FIRST, BESTIARY_TYPE_LAST do
		self:setStorageValue(PlayerStorageKeys.bestiaryCategoryProgressBase + categoryId, -1)
	end
	
	self:setCharmPoints(0)
end

------ EVENTS
-- login: set storage bestiaryInitCharmSystem to 1 set charms to 0
do
	local loginEvent = CreatureEvent("bestiaryLogin")
	function loginEvent.onLogin(player)
		local initStorage = PlayerStorageKeys.bestiaryInitCharmSystem
		if not initStorage then
			print("Warning: bestiary system storages missing. Please add missing values to data/lib/core/storages.")
			return true
		end
		
		-- initialize charm system
		if player:getStorageValue(initStorage) == -1 then
			player:setStorageValue(initStorage, 1)
			player:setCharmPoints(0)
		end
		
		return true
	end
	loginEvent:register()
end

-- monster death: add kill to all relevant players
do
	local ec = EventCallback
	ec.onDropLoot = function(self, corpse)
		local damageMap = self:getDamageMap()
		local expiresAt = os.mtime() - 5 * 60 * 1000 -- max time since dealing dmg to monster, to count to bestiary
		for cid, dmgData in pairs(damageMap) do
			if expiresAt < dmgData.ticks then
				local player = Player(cid)
				if player then
					player:addBestiaryKill(self)
				end
			end
		end
	end
	ec:register()
end
------ PROTOCOL

-- 0x2A add bestiary tracker list
-- 0xE1 request races (declared and linked)
-- 0xE2 request creatures
-- 0xE3 request monster

function Player:sendCharms()
	local response = NetworkMessage()
	response:addByte(COMPENDIUM_RESPONSE_CHARMS)
	response:addU32(0) -- charm points

	local charmCount = 19
	response:addByte(charmCount) -- charm count

	-- charm block
	for i = 0, charmCount-1 do--18 do
	response:addByte(i) -- charmId
	response:addString("name")
	response:addString("description")
	response:addByte(2) -- charm level (0-2)
	response:addU16(10) -- cost in charm points
	response:addByte(1) -- is unlocked
	response:addByte(0) -- is monster assigned
	-- if yes:
	--response:addU16(10) -- raceId
	--response:addU32(10) -- remove cost
	end
	
	response:addByte(255) -- amount of charms you can assign (0-254), 255 - unlimited
	
	-- list of monsters you can assign your charms to
	response:addU16(2) -- raceCount
	response:addU16(10) -- raceId (shows on the list)
	response:addU16(11) -- raceId (shows on the list)
	response:sendToPlayer(self)
end

function Player:sendBestiary()
	self:sendResourceBalance(RESOURCE_BANK_BALANCE, self:getBankBalance())
	self:sendResourceBalance(RESOURCE_GOLD_EQUIPPED, self:getMoney())
	self:sendResourceBalance(RESOURCE_CHARM_POINTS, self:getCharmPoints())
	
	local response = NetworkMessage()
	response:addByte(COMPENDIUM_RESPONSE_BESTIARY)
	response:addU16(BESTIARY_TYPE_LAST)
	for bestiaryType = BESTIARY_TYPE_FIRST, BESTIARY_TYPE_LAST do
		response:addString(GameBestiaryTypes[bestiaryType].name)
		response:addU16(#GameBestiaryTypes[bestiaryType].races) -- total
		response:addU16(self:getBestiaryCategoryProgress(bestiaryType)) -- unlocked by player
	end
	response:sendToPlayer(self)
end

-- open bestiary/charms
function onRequestBestiaryCharms(player, recvbyte, networkMessage)
	player:sendBestiary()
	--player:sendCharms()
	return true
end

do
	local callback = onRequestBestiaryCharms
	setPacketEvent(COMPENDIUM_REQUEST_BESTIARY, callback)
end

-- click on monster category
do
	local callback = function(player, recvbyte, networkMessage)
		networkMessage:getByte() -- request type (0 in this case)
		local requestedCategory = BestiaryTypeByName[networkMessage:getString()]
		local bestiaryTab = GameBestiaryTypes[requestedCategory]
		if not bestiaryTab then
			sendCompendiumError(player, COMPENDIUM_PLAYER_BASEINFORMATION, COMPENDIUM_RESPONSETYPE_NODATA)
			return true
		end
		
		local m = NetworkMessage()
		m:addByte(COMPENDIUM_RESPONSE_BESTIARY_SPECIES)
		m:addString(bestiaryTab.name)

		-- monsters block
		m:addU16(#bestiaryTab.races) -- amount of monsters
		if #bestiaryTab.races > 0 then
			for raceIndex = 1, #bestiaryTab.races do
				local raceData = getBestiaryRaceDataById(bestiaryTab.races[raceIndex])
				if raceData then
					m:addU16(raceData.id)
					local progessLevel = player:getBestiaryRaceProgress(raceData.id)
					m:addByte(progessLevel) -- progress level(0-4, if > 1, demands rarity byte)
					if progessLevel > 0 then
						m:addByte(raceData.rarity - 1)
					end
				else
					m:addU16(0)
					m:addByte(0)
				end
			end
		end
		
		m:sendToPlayer(player)
		return true
	end
	setPacketEvent(COMPENDIUM_REQUEST_BESTIARY_SPECIES, callback)
end

-- view bestiary creature
do
	-- error page for incorrect creature
	local function sendGenericPage(player)
		local m = NetworkMessage()
		m:addByte(COMPENDIUM_RESPONSE_BESTIARY_RACE)
		m:addU16(0) -- raceId
		m:addString("Amphibic") -- category name (for return to category button)
		m:addByte(3) -- progress level
		m:addU32(0) -- kill counter
		m:addU16(0) -- kills to 1
		m:addU16(0) -- kills to 2
		m:addU16(0) -- kills to 3
		m:addByte(0) -- difficulty
		m:addByte(3) -- rarity
		m:addByte(0) -- amount of loot items
		m:addU16(0) -- charm points
		m:addByte(2) -- 0 - melee, 1 - ranged, 2 - harmless
		m:addByte(0) -- 0 - no icon, 1 - spells or skills
		m:addU32(0) -- hp
		m:addU32(0) -- exp
		m:addU16(0) -- speed
		m:addU16(0) -- armor
		m:addByte(0) -- amount of elements
		m:addU16(1) -- locations amount
		m:addString("Error: Creature not found.") -- location
		m:sendToPlayer(player)
	end
	
	local function getLootTierByChance(chance)
		local maxIndex = table.maxn(bestiaryLootTiers)
		for i = 0, maxIndex do
			if chance < bestiaryLootTiers[i] then
				return i
			end
		end
		
		return maxIndex
	end
	
	local callback = function(player, recvbyte, networkMessage)
		local raceId = networkMessage:getU16()
		local race = getBestiaryRaceDataById(raceId)
		if not race then
			-- creature not found
			sendGenericPage(player)
			return true
		end
		
		local m = NetworkMessage()
		m:addByte(COMPENDIUM_RESPONSE_BESTIARY_RACE)
		m:addU16(raceId) -- raceId
		m:addString(BestiaryNameByType[race.class] or "Amphibic") -- category name (for return to category button)
		
		local progressLevel = player:getBestiaryRaceProgress(raceId)
		
		-- kill counter
		m:addByte(progressLevel) -- progress level
		m:addU32(player:getBestiaryKillCount(raceId)) -- kill counter
		
		local rare = race.rarity == 4
		local killMap = not rare and GameBestiaryDifficulties[race.difficulty].kills or GameBestiaryDifficulties[race.difficulty].rareKills
		-- GameBestiaryDifficulties
		m:addU16(killMap[1]) -- kills to 1
		m:addU16(killMap[2]) -- kills to 2
		m:addU16(killMap[3]) -- kills to 3

		-- rating
		m:addByte(race.difficulty) -- difficulty
		m:addByte(race.rarity - 1) -- rarity

		local charmReward = not rare and GameBestiaryDifficulties[race.difficulty].charmPoints or GameBestiaryDifficulties[race.difficulty].rareCharmPoints
		-- monster type info
		local monsterType = MonsterType(race.baseName)
		if monsterType then
			local loot = monsterType:getLoot()	
			m:addByte(#loot) -- amount of loot items
			if #loot > 0 then
				for i = 1, #loot do
					local lootData = loot[i]
					local lootRarity = getLootTierByChance(lootData.chance)
					local lootType = ItemType(lootData.itemId)
					local lootId = lootType and lootType:getClientId()
					
					if progressLevel >= (4-lootRarity) and lootId and lootId ~= 0 then
						-- send unlocked
						m:addU16(lootId)
						m:addByte(4-lootRarity)
						m:addByte(0) -- isEventLoot (bool)
						m:addString(lootType:getName())
						m:addByte(lootData.maxCount > 1 and 0x01 or 0x00)
					else
						-- send locked
						m:addU16(0)
						m:addByte(4-lootRarity)
						m:addByte(0)
					end
				end
			end

			if progressLevel > 1 then
				local attackType = monsterType:isHostile() and (monsterType:targetDistance() < 2 and BESTIARY_MELEE or BESTIARY_RANGED) or BESTIARY_HARMLESS
				local isCaster = 0
				local atkList = monsterType:getAttackList()
				for _, attack in pairs(atkList) do
					if attack.isMelee == 0 then
						isCaster = 1
						break
					end
				end
				isCaster = #monsterType:getDefenseList() == 0 and isCaster or 1
				
				m:addU16(charmReward) -- charm points
				m:addByte(attackType) -- 0 - melee, 1 - ranged, 2 - harmless
				m:addByte(isCaster) -- 0 - no icon, 1 - spells or skills
				m:addU32(math.min(monsterType:maxHealth(), 0xFFFFFFFF)) -- hp
				m:addU32(math.min(monsterType:experience(), 0xFFFFFFFF)) -- exp
				m:addU16(math.min(math.floor(monsterType:baseSpeed()/2), 0xFFFF)) -- speed
				m:addU16(monsterType:armor()) -- armor
			end

			if progressLevel > 2 then
				local resistanceMap = {}
				local elements = monsterType:getElementList()
				local immunities = monsterType:combatImmunities()
				local statCount = 0
				
				for combatId = CLIENT_COMBAT_FIRST, CLIENT_COMBAT_LAST do
					local combatType = getClientCombatId(combatId)
					if elements[combatType] then
						resistanceMap[combatId] = 100 - elements[combatType]
					end
					
					if bit.band(immunities, combatType) ~= 0 then
						resistanceMap[combatId] = 0
					end
					
					if not resistanceMap[combatId] then
						resistanceMap[combatId] = 100
					end
					
					statCount = statCount + 1
				end

				m:addByte(statCount) -- amount of elements
				for combatId = CLIENT_COMBAT_FIRST, CLIENT_COMBAT_LAST do
					m:addByte(combatId) -- element client id
					m:addU16(resistanceMap[combatId]) -- percent modifier
				end
					
				m:addU16(1) -- locations block
					m:addString("No data") -- location
			end
		else
			m:addByte(0)
			if progressLevel > 1 then
				m:addU16(charmReward) -- charm points
				m:addByte(0) -- 0 - melee, 1 - ranged, 2 - harmless
				m:addByte(0) -- 0 - no icon, 1 - casts spells or skills
				m:addU32(0) -- hp
				m:addU32(0) -- exp
				m:addU16(0) -- speed
				m:addU16(0) -- armor
			end
			
			if progressLevel > 2 then
				m:addByte(0) -- amount of elements
				m:addU16(1) -- locations block
				m:addString("Unknown") -- location
			end
		end
		
		-- to do: charm system
		if progressLevel > 3 then
			m:addByte(0) -- charm id
			m:addByte(1) -- ?
			--	m:addU32(1000) -- removal cost if id > 0
				
			-- no charm:
			-- byte 0
			-- byte 1
		end
		m:sendToPlayer(player)
		return true
	end
	setPacketEvent(COMPENDIUM_REQUEST_BESTIARY_RACE, callback)
end
