-- use this file to add store offers

-- VIP Pass (Premium Time)
	-- days, price, publishedAt
	GeneratePremium(30, 250, 3)
	GeneratePremium(90, 750, 2)
	GeneratePremium(180, 1500, 1)
	GeneratePremium(360, 3000, 0)
	
-- XP Boosts
	-- price
	GenerateXPBoost(30)

	-- other boosts?
	-- stamina reset?
	-- frag remover?
	-- loot rate boost?
	-- skill rate boost?

-- Extra Services
	-- name, serviceId, price, category, image, publishedAt, description
	GenerateStoreService("Sex Change", STORE_SERVICE_SEX_CHANGE, 120, STORE_TAB_SERVICES, "Product_CharacterSexChange.png", 24, "<i>Turns your female character into a male one - or vice versa.</i>\n\n{character}\n{activated}\n{info} you will keep all outfits you have purchased or earned in quest")
	GenerateStoreService("Name Change", STORE_SERVICE_NAME_CHANGE, 250, STORE_TAB_SERVICES, "Product_CharacterNameChange.png", 30, "<i>Tired of your current character name? Purchase a new one!</i>\n\n{character}\n{info} relog may be required after purchase to finalise the name change")

-- Useful Things
	GenerateStoreService("Temple Teleport", STORE_SERVICE_TEMPLE_TELEPORT, 15, STORE_TAB_USEFUL, "Product_Transportation_TempleTeleport.png", 1268, "<i>Teleports you instantly to your home temple.</i>\n\n{character}\n{useicon} use it to teleport you to your home temple\n{battlesignicon} cannot be used while having a battle sign or a protection zone block\n{info} does not work in no-logout zones or close to a character's home temple")

	-- gold pouch
	GenerateStoreItem(26377, 900, STORE_TAB_USEFUL, nil, 1474963200, 1, nil, "<i>Carries as many gold, platinum or crystal coins as your capacity allows, however, no other items.</i>\n\n{character}\n{storeinbox}\n{once}\n{useicon} use it to open it\n{info} always placed on the first position of your Store inbox")

-- Outfits
	-- name, lookTypeMale, lookTypeFemale, price, publishedAt, description
	GenerateOutfit("Full Fencer Outfit", 1575, 1576, 750, 1658476800, "They are skilled, they are disciplined, they wield their weapon with deadly precision as a form of art. Fencers are true masters of the blade who can cut through anything and anyone in the blink of an eye. While being feared for their lethal attacks, they are also admired for their elegant and fierce style, their dashing looks. Do not be on the fence, be a fencer, or at least dress like one with this fashionable, cutting-edge outfit.")
	GenerateOutfit("Full Nordic Chieftain Outfit", 1500, 1501, 750, 1650614400, "Where others not dare to tread due to the biting cold and freezing winds, the Nordic Chieftain feels right at home. Braving the harsh conditions is possible due to a protective layer of warm clothing, as well as suitable armament to fend off any hostile wildlife. The helmet's massive horns are a tad heavy and unwieldy, but show the chieftain's status.")
	GenerateOutfit("Full Ghost Blade Outfit", 1489, 1490, 600, 1643965200, "Being a Ghost Blade means having mastered the way of the warrior. No matter the circumstances, these fighters retain full control over their body and mind, with the sole focus of vanquishing their foe. So great is their ability that they not only control the weapons in their hands perfectly, but two floating blades following them as well.")
	GenerateOutfit("Full Arbalester Outfit", 1449, 1450, 600, 1634889600, "Armed with a powerful crossbow, and gifted with steady hands as well as a sharp eye, the Arbalester is not one to be trifled with. Requiring both skill and strength to properly wield, the arbalest is a mighty tool in the hands of an able marksman, shooting deadly bolts across great distance.")
	GenerateOutfit("Full Dragon Knight Outfit", 1444, 1445, 870, 1627027200, "A Dragon Knight is ready for everything, channeling the primordial might of the winged, ancient beasts into weapons and armour. Their imposing demeanour and impressive appearance are often enough to quell any animosity towards them, and those who still dare oppose them are not long for this world.")
	GenerateOutfit("Full Forest Warden Outfit", 1415, 1416, 750, 1622188800, "The Forest Warden watches over all living things in the woods, be they plants or beasts. They have a special connection to the earth they tread on, the air they breathe, and the wind which whispers around them. Naturally, the suit that they don is not made out of dead vegetation, but is a living being itself.")
	GenerateOutfit("Full Rune Master Outfit", 1384, 1385, 870, 1614330000, "A Rune Master has dedicated their whole life to the study and mastery of runes. They are intrigued by the ancient symbols, shrouded in mystery, and how their magic works. Rune Masters have a deep understanding of the awesome power they are wielding and can make use of the full potential of runes.")
	GenerateOutfit("Full Merry Garb Outfit", 1382, 1383, 600, 1609837200, "Are you ready for the festive season? Or feeling festive regardless of the time of year? Then the Merry Garb is perfect for you. Donning the outfit not only puts you in a mirthful mood, but spreads blitheness on your travels throughout the lands.")
	GenerateOutfit("Full Moth Cape Outfit", 1338, 1339, 600, 1601020800, "If you are fascinated by this particular group of insects and want to show your deep appreciation of these critters, the Moth Cape is for you. The wing-shaped coat and the antennae provide you with the feeling of being a moth without experiencing the downside of inevitably being drawn to light.")
	GenerateOutfit("Full Jouster Outfit", 1331, 1332, 750, 1593158400, "The Jouster is all geared up for a tournament, ready to partake in festive activities involving friendly competition to prove their chivalry. However, being well-armoured, they are also a force to be reckoned with on the battlefield, especially with a trusty steed at their service.")
	GenerateOutfit("Full Trailblazer Outfit", 1292, 1293, 600, 1585299600, "The Trailblazer is on a mission of enlightenment and carries the flame of wisdom near and far. The everlasting shine brightens the hearts and minds of all creatures its rays touch, bringing light even to the darkest corners of the world as a beacon of insight and knowledge.")
	GenerateOutfit("Full Herder Outfit", 1279, 1280, 750, 1576227600, "The Herder is one with nature, being outside all day, watching carefully over his flock. If you like to spend time on picturesque meadows and are always looking for greener pastures, then this outfit is for you.")
	GenerateOutfit("Full Breezy Garb Outfit", 1245, 1246, 600, 1564128000, "Even the most eager adventurers and toughest warriors need some time to rest and recharge. Enjoy tranquility and peace as you picnic in good company at one of your favourite places. Put on your Breezy Garb outfit, grab your walking stick, a basket filled with tasty snacks and then head out into nature!")
	GenerateOutfit("Full Guidon Bearer Outfit", 1186, 1187, 870, 1556262000, "Carrying the guidon of a unit, always marching in front, is not only an honour but also comes with great responsibility. Guidon bearers wield great power, they lead where others follow and keep the spirits of the troops up as they wave their flag against the golden suns.")
	GenerateOutfit("Full Owl Keeper Outfit", 1173, 1174, 600, 1550566800, "Owl Keepers are often referred to as spirits walking through the forest at night, mere shadows during the day. They are also said to be shamans, protecting the flora and fauna. You often see them wearing a stag's antlers on their head and in the company of an owl, for they are as wise and mysterious as these intriguing creatures.")
	GenerateOutfit("Full Pumpkin Mummy Outfit", 1127, 1128, 870, 1541149200, "If you cannot decide whether to wrap yourself up as a mummy or flaunt an enormous pumpkin head for your next hunting party, why not combine both? The Pumpkin Mummy outfit is the perfect costume for scary nights and spooky days.")
	GenerateOutfit("Full Sinister Archer Outfit", 1102, 1103, 600, 1532678400, "From an early age, the Sinister Archer has been fascinated by people's dark machinations and perversions. Sinister Archers claim that they advocate the good and that they only use their arrows to pierce the hearts of those who have committed many crimes and misdeeds. However, they are still viewed by the public with much suspicion due to their dubious appearance. To keep their identity secret, they often hide themselves behind a skull-like face guard that can easily withstand even axe and club blows.")
	GenerateOutfit("Full Mercenary Outfit", 1056, 1057, 870, 1524812400, "The Mercenary carries a powerful, razor-sharp axe on his shoulders that effortlessly cuts through any armour and bone. You should better tell your friends to keep a safe distance, since heads will roll over the blood-soaked battleground after a powerful swing of yours.\nConsidering the sheer size of this axe, it might even be possible to chop onions without shedding a tear.")
	GenerateOutfit("Full Siege Master Outfit", 1050, 1051, 600, 1519981200, "Neither thick stone walls nor heavily armoured gates can stop the Siege Master, who brings down hostile fortifications in the blink of an eye. Whenever he tenses his muscular arms to lift the powerful battering ram, his enemies' knees begin to buckle. It is the perfect outfit for those who also stand for brute strength and immense destruction.")
	GenerateOutfit("Full Sun Priest Outfit", 1023, 1024, 750, 1515229200, "Do you worship warm temperatures and are opposed to the thought of long and dark winter nights? Do you refuse to spend countless evenings in front of your chimney while ice-cold wind whistles through the cracks and niches of your house? It is time to stop freezing and to become an honourable Sun Priest! With this stylish outfit, you can finally show the world your unconditional dedication and commitment to the sun!")
	GenerateOutfit("Full Herbalist Outfit", 1021, 1020, 750, 1509091200, "The Herbalist outfit is the perfect outfit for all herbs collectors. Those of you who are aware that you do not necessarily have to reach into the mouth of a hydra to get a hydra tongue and those who know exactly where to get blood- and shadow-herbs will find a matching outfit for their daily hobby. Show the world your affinity for herbs and impress your friends with your knowledge of medicine and potions.")
	GenerateOutfit("Full Entrepreneur Outfit", 472, 471, 750, 1501228800, "Slaughter through hordes of monsters during your early morning hunt and kiss the hand of Queen Eloise later on at the evening reception in her historical residence. With the Entrepreneur outfit you will cut a fine figure on every occasion.")
	GenerateOutfit("Full Trophy Hunter Outfit", 957, 958, 870, 1498204800, "You spend hours in the woods in search of wild and rare animals? Countless stuffed skulls of deer, wolves and other creatures are decorating your walls? Now you have the chance to present your trophies in public. Become a Trophy Hunter and cover your shoulders with the finest bear skulls!")
	GenerateOutfit("Retro Noble(wo)man Outfit", 966, 967, 870, 1496995200, "The king has invited you to a summer ball and you have nothing to wear for this special event? Do not worry, the Retro Noble(wo)man outfit makes you a real eye catcher on every festive occasion.")
	GenerateOutfit("Retro Summoner Outfit", 964, 965, 870, 1496995200, "While the Retro Mage usually throws runes and mighty spells directly at the enemies, the Retro Summoner outfit might be the better choice for adventurers that prefer to send mighty summons to the battlefield to keep their enemies at distance.")
	GenerateOutfit("Retro Warrior Outfit", 962, 963, 870, 1496995200, "You are fearless and strong as a behemoth but have problems finding the right outfit for your adventures? The Retro Warrior outfit is a must-have for all fashion-conscious old-school adventurers out there.")
	GenerateOutfit("Retro Knight Outfit", 970, 971, 870, 1495785600, "Who needs a fancy looking sword with bling-bling and ornaments? Back in the days, we survived without such unnecessary accessories! Time to show those younkers what a Retro Knight is made of.")
	GenerateOutfit("Retro Hunter Outfit", 972, 973, 870, 1495785600, "Whenever you pick up your bow and spears, you walk down memory lane and think of your early days? Treat yourself with the fashionable Retro Hunter outfit and hunt some good old monsters from your childhood.")
	GenerateOutfit("Retro Mage Outfit", 968, 969, 870, 1495785600, "Dress up as a Retro Mage and you will always cut a fine figure on the battleground while eliminating your enemies with your magical powers the old-fashioned way.")
	GenerateOutfit("Retro Citizen Outfit", 974, 975, 870, 1495785600, "Do you still remember your first stroll through the streets of Thais? For old times' sake, walk the paths of Nostalgia as a Retro Citizen!")
	GenerateOutfit("Full Pharaoh Outfit", 955, 956, 750, 1488531600, "You know how to read hieroglyphs? You admire the exceptional architectural abilities and the unsolved mysteries of an ancient high culture? Next time you pay a visit to your friends, tell them to prepare a bathtub full of milk and honey for you because a Pharaoh is now walking through the streets of Ankrahmun!")
	GenerateOutfit("Full Grove Keeper Outfit", 908, 909, 870, 1480662000, "Feeling the springy grass under your feet and inhaling the spicy air of the forest is pure satisfaction for your soul? Every animal is your friend and you caringly look after trees and plants all the time? Then it is time to become one with nature: Become a Grove Keeper!")
	GenerateOutfit("Full Lupine Warden Outfit", 899, 900, 840, 1475222400, "Do you feel the adrenaline rushing through your veins when the sun goes down and a full moon lightens the night? Do you have the urge to hunt down your target no matter what? Unleash the beast inside of you and lead your friends to battle with the Lupine Warden outfit!")
	GenerateOutfit("Full Arena Champion Outfit", 884, 885, 870, 1475222399, "Fight your bloody battles in the arena and become a darling of the crowd. Once you have made it to the top and everyone is cheering your name, the fashionable outfit of an Arena Champion will show the world what you are made of.")
	GenerateOutfit("Full Philosopher Outfit", 873, 874, 750, 1475222398, "Do you feel the urge to tell people what is really going on in the world? Do you know all answers to the important questions of life? Are you a true philosopher? Then dress like one to showcase the latest fashion for all wise theorists.")
	GenerateOutfit("Full Winter Warden Outfit", 853, 852, 870, 1475222397, "The warm and cosy cloak of the Winter Warden outfit will keep you warm in every situation. Best thing, it is not only comfortable but fashionable as well. You will be the envy of any snow queen or king, guaranteed!")
	GenerateOutfit("Full Royal Pumpkin Outfit", 760, 759, 840, 1475222396, "The mutated pumpkin is too weak for your mighty weapons? Time to show that evil vegetable how to scare the living daylight out of people! Put on a scary looking pumpkin on your head and spread terror and fear amongst the population.")
	GenerateOutfit("Full Sea Dog Outfit", 750, 749,  600, 1475222395, "Ahoy mateys! Flaunt the swashbuckling Sea Dog outfit and strike a pose with your hook to impress both landlubbers and fellow pirates. Board your next ship in style!")
	GenerateOutfit("Full Champion Outfit", 633, 632, 570, 1475222385, "Protect your body with heavy armour plates and spiky bones to teach your enemies the meaning of fear! The Champion outfit perfectly suits battle-hardened warriors who rely on their trusty sword and shield.")
	GenerateOutfit("Full Conjurer Outfit", 634, 635, 720, 1475222386, "You recently graduated from the Magic Academy and want to bring your knowledge to good use? Congratulations, you are now an honourable disciple of magic! Open up a bottle of well-aged mana and treat yourself with the fashionable Conjurer outfit.")
	GenerateOutfit("Full Beastmaster Outfit", 637, 636, 870, 1475222384, "Do you have enough authority to make wild animals subservient to you? Become a Beastmaster and surround yourself with fearsome companions. When your beasts bare their teeth, your enemies will turn tails and run.")
	GenerateOutfit("Full Chaos Acolyte Outfit", 665, 664, 900, 1475222387, "You have always felt like the cat among the pigeons and have a fable for dark magic? The Chaos Acolyte outfit is a perfect way to express your inner nature. Show your commitment for the higher cause and wreak havoc on your enemies in this unique outfit.")
	GenerateOutfit("Full Death Herald Outfit", 667, 666, 600, 1475222388, "Death and decay are your ever-present companions? Your enemies are dropping like flies and your path is covered with their bodies? However, as decency demands, you want to at least give them a proper funeral? Then the Death Herald is just the right outfit for you.")
	GenerateOutfit("Full Ranger Outfit", 684, 683, 750, 1475222389, "Most of the day, the Ranger is looking over his forest. He is taking care of all animals and plants and tries to keep everything in balance. Intruders are greeted by a warning shot from his deadly longbow. It is the perfect outfit for Paladins who live in close touch with nature.")
	GenerateOutfit("Full Ceremonial Garb Outfit", 695, 694, 750, 1475222390, "If you want to make a great entrance at a costume party, the Ceremonial Garb is certainly a good choice. With a drum over your shoulder and adorned with feathers you are perfectly dressed to lead a carnival parade through the streets of Thais.")
	GenerateOutfit("Full Puppeteer Outfit", 697, 696, 870, 1475222391, "Are you a fan of puppetry? You like to travel the world together with one or two little acting fellows? Or are you simply the one who likes to pull the strings? Then the Puppeteer outfit is the right choice for you.")
	GenerateOutfit("Full Spirit Caller Outfit", 699, 698, 600, 1475222392, "You are in love with the deep soul of Mother Earth and prefer to walk in the shadows of her wooden children? Choose the Spirit Caller outfit to live in harmony with nature.")
	GenerateOutfit("Full Evoker Outfit", 725, 724, 840, 1475222393, "Dance around flickering fires in the Evoker outfit while singing unholy chants to praise witchcraft and wizardry. Your faithful bat will always be by your side.")
	GenerateOutfit("Full Seaweaver Outfit", 733, 732, 570, 1475222394, "The Seaweaver outfit is the perfect choice if you want to show the world that you are indeed a son or a daughter of the submarine kingdom. You can almost feel the salty taste and the rough wind of the sea when wearing it.")

-- Mounts
	-- name, lookType, price, publishedAt, description
	GenerateMount("Parade Horse", 1578, 870, 1661500800, "A seasoned warrior knows how to make an entry, and so does his faithful companion: Fully armored! Saddle up your impressive Jousting Horse to charge into battle in style, gallop into the arena on the back of your striking Tourney Horse, and ride your distinguished Parade Horse through the streets of Thais to show off your chivalrous qualities. With a horse in full barding, nobody will ever rain on your parade again.")
	GenerateMount("Jousting Horse", 1579, 870, 1661500800, "A seasoned warrior knows how to make an entry, and so does his faithful companion: Fully armored! Saddle up your impressive Jousting Horse to charge into battle in style, gallop into the arena on the back of your striking Tourney Horse, and ride your distinguished Parade Horse through the streets of Thais to show off your chivalrous qualities. With a horse in full barding, nobody will ever rain on your parade again.")
	GenerateMount("Tourney Horse", 1580, 870, 1661500800, "A seasoned warrior knows how to make an entry, and so does his faithful companion: Fully armored! Saddle up your impressive Jousting Horse to charge into battle in style, gallop into the arena on the back of your striking Tourney Horse, and ride your distinguished Parade Horse through the streets of Thais to show off your chivalrous qualities. With a horse in full barding, nobody will ever rain on your parade again.")
	GenerateMount("Poppy Ibex", 1526, 750, 1653638400, "No mountain is too high, no wall too steep to climb for the agile Poppy, Mint and Cinnamon Ibex. They keep their balance on the thinnest of ledges, so you will never stumble, slip or go flying off the edges. Moreover, these sturdy fellows certainly know how to make an entrance as they dive down from the highest peaks and attack opponents with their impressive horns. And if you dare to call them a wild goat, they might kick you with their legs.")
	GenerateMount("Mint Ibex", 1527, 750, 1653638400, "No mountain is too high, no wall too steep to climb for the agile Poppy, Mint and Cinnamon Ibex. They keep their balance on the thinnest of ledges, so you will never stumble, slip or go flying off the edges. Moreover, these sturdy fellows certainly know how to make an entrance as they dive down from the highest peaks and attack opponents with their impressive horns. And if you dare to call them a wild goat, they might kick you with their legs.")
	GenerateMount("Cinnamon Ibex", 1528, 750, 1653638400, "No mountain is too high, no wall too steep to climb for the agile Poppy, Mint and Cinnamon Ibex. They keep their balance on the thinnest of ledges, so you will never stumble, slip or go flying off the edges. Moreover, these sturdy fellows certainly know how to make an entrance as they dive down from the highest peaks and attack opponents with their impressive horns. And if you dare to call them a wild goat, they might kick you with their legs.")
	GenerateMount("Topaz Shrine", 1491, 690, 1648198800, "The famous Wandering Shrines were first raised by the nomad people of the Zaoan steppe. Their exceptional craftsmanship, combining architectonic features with living animals, is acknowledged even far beyond the continent of Zao. These spiritual companions will give you the opportunity to regain your strength during long and exciting journeys.")
	GenerateMount("Jade Shrine", 1492, 690, 1648198800, "The famous Wandering Shrines were first raised by the nomad people of the Zaoan steppe. Their exceptional craftsmanship, combining architectonic features with living animals, is acknowledged even far beyond the continent of Zao. These spiritual companions will give you the opportunity to regain your strength during long and exciting journeys.")
	GenerateMount("Obsidian Shrine", 1493, 690, 1648198800, "The famous Wandering Shrines were first raised by the nomad people of the Zaoan steppe. Their exceptional craftsmanship, combining architectonic features with living animals, is acknowledged even far beyond the continent of Zao. These spiritual companions will give you the opportunity to regain your strength during long and exciting journeys.")
	GenerateMount("Emerald Raven", 1453, 690, 1641373200, "The origins of the Emerald Raven, Mystic Raven, and Radiant Raven are shrouded in darkness, as no written record nor tale told by even the most knowing storytellers mentions but a trace of them. Superstition surrounds them, as some see these gigantic birds as an echo of a long forgotten past, while others believe them to herald hitherto unknown events. What is clear is that they are highly intelligent beings which make great companions if they deem somebody worthy.")
	GenerateMount("Mystic Raven", 1454, 690, 1641373200, "The origins of the Emerald Raven, Mystic Raven, and Radiant Raven are shrouded in darkness, as no written record nor tale told by even the most knowing storytellers mentions but a trace of them. Superstition surrounds them, as some see these gigantic birds as an echo of a long forgotten past, while others believe them to herald hitherto unknown events. What is clear is that they are highly intelligent beings which make great companions if they deem somebody worthy.")
	GenerateMount("Radiant Raven", 1455, 690, 1641373200, "The origins of the Emerald Raven, Mystic Raven, and Radiant Raven are shrouded in darkness, as no written record nor tale told by even the most knowing storytellers mentions but a trace of them. Superstition surrounds them, as some see these gigantic birds as an echo of a long forgotten past, while others believe them to herald hitherto unknown events. What is clear is that they are highly intelligent beings which make great companions if they deem somebody worthy.")
	GenerateMount("Rustwurm", 1446, 870, 1632470400, "The Bogwurm, Gloomwurm, and Rustwurm belong to a little known subset of the dragon family, and usually live out their lives in habitats far away from human interaction. Them being cunning hunters, and their keen sense of perception make these wurms great companions for whomever can locate and tame them.")
	GenerateMount("Bogwurm", 1447, 870, 1632470400, "The Bogwurm, Gloomwurm, and Rustwurm belong to a little known subset of the dragon family, and usually live out their lives in habitats far away from human interaction. Them being cunning hunters, and their keen sense of perception make these wurms great companions for whomever can locate and tame them.")
	GenerateMount("Gloomwurm", 1448, 870, 1632470400, "The Bogwurm, Gloomwurm, and Rustwurm belong to a little known subset of the dragon family, and usually live out their lives in habitats far away from human interaction. Them being cunning hunters, and their keen sense of perception make these wurms great companions for whomever can locate and tame them.")
	GenerateMount("Hyacinth", 1439, 750, 1624608000, "Born from the depths of the forest, where flora and fauna intertwine in mysterious ways, the Floral Beast is a colourful creature that is sure to turn some heads. The Hyacinth, Peony, and Dandelion mount are loyal companions that will safely carry you through their natural habitat of the woods, or lands unknown to them.")
	GenerateMount("Peony", 1440, 750, 1624608000, "Born from the depths of the forest, where flora and fauna intertwine in mysterious ways, the Floral Beast is a colourful creature that is sure to turn some heads. The Hyacinth, Peony, and Dandelion mount are loyal companions that will safely carry you through their natural habitat of the woods, or lands unknown to them.")
	GenerateMount("Dandelion", 1441, 750, 1624608000, "Born from the depths of the forest, where flora and fauna intertwine in mysterious ways, the Floral Beast is a colourful creature that is sure to turn some heads. The Hyacinth, Peony, and Dandelion mount are loyal companions that will safely carry you through their natural habitat of the woods, or lands unknown to them.")
	GenerateMount("Void Watcher", 1389, 870, 1616749200, "If you are looking for a vigilant and faithful companion, look no further! Glide through every realm and stare into the darkest abyss on the back of a Void Watcher. They already know everything about you anyway for they have been watching you from the shadows!")
	GenerateMount("Rune Watcher", 1390, 870, 1616749200, "If you are looking for a vigilant and faithful companion, look no further! Glide through every realm and stare into the darkest abyss on the back of a Rune Watcher. They already know everything about you anyway for they have been watching you from the shadows!")
	GenerateMount("Rift Watcher", 1391, 870, 1616749200, "If you are looking for a vigilant and faithful companion, look no further! Glide through every realm and stare into the darkest abyss on the back of a Rift Watcher. They already know everything about you anyway for they have been watching you from the shadows!")
	GenerateMount("Merry Mammoth", 1379, 750, 1607677200, "The Festive Mammoth, Holiday Mammoth and Merry Mammoth are gentle giants with a massive appearance and impressive tusks, whose mission it is to deliver gifts all across the world. They are good-natured beings, spreading joy wherever they go, but you best not cross them - a mammoth never forgets.")
	GenerateMount("Holiday Mammoth", 1380, 750, 1607677200, "The Festive Mammoth, Holiday Mammoth and Merry Mammoth are gentle giants with a massive appearance and impressive tusks, whose mission it is to deliver gifts all across the world. They are good-natured beings, spreading joy wherever they go, but you best not cross them - a mammoth never forgets.")
	GenerateMount("Festive Mammoth", 1381, 750, 1607677200, "The Festive Mammoth, Holiday Mammoth and Merry Mammoth are gentle giants with a massive appearance and impressive tusks, whose mission it is to deliver gifts all across the world. They are good-natured beings, spreading joy wherever they go, but you best not cross them - a mammoth never forgets.")
	GenerateMount("Cunning Hyaena", 1334, 750, 1595577600, "The Cunning Hyaena, Scruffy Hyaena and Voracious Hyaena are highly social animals and loyal companions to whomever is able to befriend them. Coming from sun-soaked places, they prefer a warm climate, but are able to cope in other environments as well.")
	GenerateMount("Voracious Hyaena", 1333, 750, 1595577600, "The Cunning Hyaena, Scruffy Hyaena and Voracious Hyaena are highly social animals and loyal companions to whomever is able to befriend them. Coming from sun-soaked places, they prefer a warm climate, but are able to cope in other environments as well.")
	GenerateMount("Scruffy Hyaena", 1335, 750, 1595577600, "The Cunning Hyaena, Scruffy Hyaena and Voracious Hyaena are highly social animals and loyal companions to whomever is able to befriend them. Coming from sun-soaked places, they prefer a warm climate, but are able to cope in other environments as well.")
	GenerateMount("Eventide Nandu", 1311, 500, 1587625200, "These birds have a strong maternal instinct since their fledglings are completely dependent on their parents for protection. Do not expect them to abandon their brood only because they are carrying you around. In fact, if you were to separate them from their chick, the Savanna Ostrich, Coral Rhea and Eventide Nandu would turn into vicious beings, so don't even try it!")
	GenerateMount("Coral Rhea", 1310, 500, 1587625200, "These birds have a strong maternal instinct since their fledglings are completely dependent on their parents for protection. Do not expect them to abandon their brood only because they are carrying you around. In fact, if you were to separate them from their chick, the Savanna Ostrich, Coral Rhea and Eventide Nandu would turn into vicious beings, so don't even try it!")
	GenerateMount("Savanna Ostrich", 1309, 500, 1587625200, "These birds have a strong maternal instinct since their fledglings are completely dependent on their parents for protection. Do not expect them to abandon their brood only because they are carrying you around. In fact, if you were to separate them from their chick, the Savanna Ostrich, Coral Rhea and Eventide Nandu would turn into vicious beings, so don't even try it!")
	GenerateMount("Snow Strider", 1284, 870, 1580461200, "A magical fire burns inside these wolves. Bred as the faithful guardians for an eccentric wizard's tower, these creatures make for loyal companions during your travels. While not originally intended for riding, their sturdy frame makes the Dawn Strayer, Dusk Pryer and Snow Strider suitable mounts.")
	GenerateMount("Dusk Pryer", 1285, 870, 1580461200, "A magical fire burns inside these wolves. Bred as the faithful guardians for an eccentric wizard's tower, these creatures make for loyal companions during your travels. While not originally intended for riding, their sturdy frame makes the Dawn Strayer, Dusk Pryer and Snow Strider suitable mounts.")
	GenerateMount("Dawn Strayer", 1286, 870, 1580461200, "A magical fire burns inside these wolves. Bred as the faithful guardians for an eccentric wizard's tower, these creatures make for loyal companions during your travels. While not originally intended for riding, their sturdy frame makes the Dawn Strayer, Dusk Pryer and Snow Strider suitable mounts.")
	GenerateMount("Floating Augur", 1266, 870, 1572598800, "These creatures are Floating Savants whose mind has been warped and bent to focus their extraordinary mental capabilities on one single goal: to do their master's bidding. Instead of being filled with an endless pursuit of knowledge, their live is now one of continuous thralldom and serfhood. The Floating Sage, the Floating Scholar and the Floating Augur are at your disposal.")
	GenerateMount("Floating Scholar", 1265, 870, 1572598800, "These creatures are Floating Savants whose mind has been warped and bent to focus their extraordinary mental capabilities on one single goal: to do their master's bidding. Instead of being filled with an endless pursuit of knowledge, their live is now one of continuous thralldom and serfhood. The Floating Sage, the Floating Scholar and the Floating Augur are at your disposal.")
	GenerateMount("Floating Sage", 1264, 870, 1572598800, "These creatures are Floating Savants whose mind has been warped and bent to focus their extraordinary mental capabilities on one single goal: to do their master's bidding. Instead of being filled with an endless pursuit of knowledge, their live is now one of continuous thralldom and serfhood. The Floating Sage, the Floating Scholar and the Floating Augur are at your disposal.")
	GenerateMount("Zaoan Badger", 1249, 690, 1566547200, "Badgers have been a staple of the world's fauna for a long time, and finally some daring souls have braved the challenge to tame some exceptional specimens - and succeeded! While the common badger you can encounter during your travels might seem like a rather unassuming creature, the Battle Badger, the Ether Badger, and the Zaoan Badger are fierce and mighty beasts, which are at your beck and call.")
	GenerateMount("Ether Badger", 1248, 690, 1566547200, "Badgers have been a staple of the world's fauna for a long time, and finally some daring souls have braved the challenge to tame some exceptional specimens - and succeeded! While the common badger you can encounter during your travels might seem like a rather unassuming creature, the Battle Badger, the Ether Badger, and the Zaoan Badger are fierce and mighty beasts, which are at your beck and call.")
	GenerateMount("Battle Badger", 1247, 690, 1566547200, "Badgers have been a staple of the world's fauna for a long time, and finally some daring souls have braved the challenge to tame some exceptional specimens - and succeeded! While the common badger you can encounter during your travels might seem like a rather unassuming creature, the Battle Badger, the Ether Badger, and the Zaoan Badger are fierce and mighty beasts, which are at your beck and call.")
	GenerateMount("Nightmarish Crocovile", 1185, 750, 1558681200, "To the keen observer, the crocovile is clearly a relative of the crocodile, albeit their look suggests an even more aggressive nature. While it is true that the power of its massive and muscular body can not only crush enemies dead but also break through any gate like a battering ram, a crocovile is, above all, a steadfast companion showing unwavering loyalty to its owner.")
	GenerateMount("Swamp Crocovile", 1184, 750, 1558681200, "To the keen observer, the crocovile is clearly a relative of the crocodile, albeit their look suggests an even more aggressive nature. While it is true that the power of its massive and muscular body can not only crush enemies dead but also break through any gate like a battering ram, a crocovile is, above all, a steadfast companion showing unwavering loyalty to its owner.")
	GenerateMount("River Crocovile", 1183, 750, 1558681200, "To the keen observer, the crocovile is clearly a relative of the crocodile, albeit their look suggests an even more aggressive nature. While it is true that the power of its massive and muscular body can not only crush enemies dead but also break through any gate like a battering ram, a crocovile is, above all, a steadfast companion showing unwavering loyalty to its owner.")
	GenerateMount("Cony Cart", 1181, 870, 1554451200, "Your lower back worsens with every trip you spend on the back of your mount and you are looking for a more comfortable alternative to travel through the lands? Say no more! The Cony Cart comes with two top-performing hares that never get tired thanks to the brand new and highly innovative propulsion technology. Just keep some back-up carrots in your pocket and you will be fine!")
	GenerateMount("Bunny Dray", 1180, 870, 1554451200, "Your lower back worsens with every trip you spend on the back of your mount and you are looking for a more comfortable alternative to travel through the lands? Say no more! The Bunny Dray comes with two top-performing hares that never get tired thanks to the brand new and highly innovative propulsion technology. Just keep some back-up carrots in your pocket and you will be fine!")
	GenerateMount("Rabbit Rickshaw", 1179, 870, 1554451200, "Your lower back worsens with every trip you spend on the back of your mount and you are looking for a more comfortable alternative to travel through the lands? Say no more! The Rabbit Rickshaw comes with two top-performing hares that never get tired thanks to the brand new and highly innovative propulsion technology. Just keep some back-up carrots in your pocket and you will be fine!")
	GenerateMount("Festive Snowman", 1167, 900, 1546592400, "When the nights are getting longer and freezing wind brings driving snow into the land, snowmen rise and shine on every corner. Lately, a peaceful, arcane creature has found shelter in one of them and used its magical power to call the Festive Snowman into being. Wrap yourself up well and warmly and jump on the back of your new frosty companion.")
	GenerateMount("Muffled Snowman", 1168, 900, 1546592400, "When the nights are getting longer and freezing wind brings driving snow into the land, snowmen rise and shine on every corner. Lately, a peaceful, arcane creature has found shelter in one of them and used its magical power to call the Muffled Snowman into being. Wrap yourself up well and warmly and jump on the back of your new frosty companion.")
	GenerateMount("Caped Snowman", 1169, 900, 1546592400, "When the nights are getting longer and freezing wind brings driving snow into the land, snowmen rise and shine on every corner. Lately, a peaceful, arcane creature has found shelter in one of them and used its magical power to call the Caped Snowman into being. Wrap yourself up well and warmly and jump on the back of your new frosty companion.")
	GenerateMount("Tawny Owl", 1104, 870, 1538121600, "Owls have always been a symbol of mystery, magic and wisdom in various mythologies and fairy tales. Having one of these enigmatic creatures of the night as a trustworthy companion provides you with a silent guide whose ever-watchful eyes will cut through the shadows, help you navigate the darkness and unravel great secrets.")
	GenerateMount("Snowy Owl", 1105, 870, 1538121600, "Owls have always been a symbol of mystery, magic and wisdom in various mythologies and fairy tales. Having one of these enigmatic creatures of the night as a trustworthy companion provides you with a silent guide whose ever-watchful eyes will cut through the shadows, help you navigate the darkness and unravel great secrets.")
	GenerateMount("Boreal Owl", 1106, 870, 1538121600, "Owls have always been a symbol of mystery, magic and wisdom in various mythologies and fairy tales. Having one of these enigmatic creatures of the night as a trustworthy companion provides you with a silent guide whose ever-watchful eyes will cut through the shadows, help you navigate the darkness and unravel great secrets.")
	GenerateMount("Ebony Tiger", 1091, 750, 1529654400, "It is said that in ancient times, the sabre-tooth tiger was already used as a mount by elder warriors of Svargrond. As seafaring began to expand, this noble big cat was also transported to other regions. Influenced by the new environment and climatic changes, the fur of the Ebony Tiger has developed its extraordinary colouring over several generations.")
	GenerateMount("Feral Tiger", 1092, 750, 1529654400, "It is said that in ancient times, the sabre-tooth tiger was already used as a mount by elder warriors of Svargrond. As seafaring began to expand, this noble big cat was also transported to other regions. Influenced by the new environment and climatic changes, the fur of the Feral Tiger has developed its extraordinary colouring over several generations.")
	GenerateMount("Jungle Tiger", 1093, 750, 1529654400, "It is said that in ancient times, the sabre-tooth tiger was already used as a mount by elder warriors of Svargrond. As seafaring began to expand, this noble big cat was also transported to other regions. Influenced by the new environment and climatic changes, the fur of the Jungle Tiger has developed its extraordinary colouring over several generations.")
	GenerateMount("Marsh Toad", 1052, 690, 1522137600, "For centuries, humans and monsters have dumped their garbage in the swamps around Venore. The combination of old, rusty weapons, stale mana and broken runes have turned some of the swamp dwellers into gigantic frogs. Benefit from those mutations and make the Marsh Toad a faithful mount for your adventures even beyond the bounds of the swamp.")
	GenerateMount("Sanguine Frog", 1053, 690, 1522137600, "For centuries, humans and monsters have dumped their garbage in the swamps around Venore. The combination of old, rusty weapons, stale mana and broken runes have turned some of the swamp dwellers into gigantic frogs. Benefit from those mutations and make the Sanguine Frog a faithful mount for your adventures even beyond the bounds of the swamp.")
	GenerateMount("Toxic Toad", 1054, 690, 1522137600, "For centuries, humans and monsters have dumped their garbage in the swamps around Venore. The combination of old, rusty weapons, stale mana and broken runes have turned some of the swamp dwellers into gigantic frogs. Benefit from those mutations and make the Toxic Toad a faithful mount for your adventures even beyond the bounds of the swamp.")
	GenerateMount("Cranium Spider", 1025, 690, 1510650000, "It is said that the Cranium Spider was born long before Banor walked the earth. While its parents died in the war against the cruel hordes sent by Brog and Zathroth, their child survived by hiding in skulls of burned enemies. It never left its hiding spot and as it grew older, the skulls merged into its body. Now, it is fully-grown and thirsts for revenge.")
	GenerateMount("Cave Tarantula", 1026, 690, 1510650000, "It is said that the Cave Tarantula was born long before Banor walked the earth. While its parents died in the war against the cruel hordes sent by Brog and Zathroth, their child survived by hiding in skulls of burned enemies. It never left its hiding spot and as it grew older, the skulls merged into its body. Now, it is fully-grown and thirsts for revenge.")
	GenerateMount("Gloom Widow", 1027, 690, 1510650000, "It is said that the Gloom Widow was born long before Banor walked the earth. While its parents died in the war against the cruel hordes sent by Brog and Zathroth, their child survived by hiding in skulls of burned enemies. It never left its hiding spot and as it grew older, the skulls merged into its body. Now, it is fully-grown and thirsts for revenge.")
	GenerateMount("Blazing Unicorn", 1017, 870, 1503648000, "The Blazing Unicorn lives in a deep rivalry with its cousin the Arctic Unicorn. Even though they were born in completely different areas, they somehow share the same bloodline. The eternal battle between fire and ice continues. Who will win? Crystal blue vs. tangerine! The choice is yours!")
	GenerateMount("Arctic Unicorn", 1018, 870, 1503648000, "The Arctic Unicorn lives in a deep rivalry with its cousin the Blazing Unicorn. Even though they were born in completely different areas, they somehow share the same bloodline. The eternal battle between fire and ice continues. Who will win? Tangerine vs.crystal blue! The choice is yours!")
	GenerateMount("Prismatic Unicorn", 1019, 870, 1503648000, "Legend has it that a mare and a stallion once reached the end of a rainbow and decided to stay there. Influenced by the mystical power of the rainbow, the mare gave birth to an exceptional foal: Not only the big, strong horn on its forehead but the unusual colouring of its hair makes the Prismatic Unicorn a unique mount in every respect.")
	GenerateMount("Armoured War Horse", 426, 870, 1506672000, "The Armoured War Horse is a dangerous black beauty! When you see its threatening, blood-red eyes coming towards you, you'll know trouble is on its way. Protected by its heavy armour plates, the warhorse is the perfect partner for dangerous hunting sessions and excessive enemy slaughtering.")
	GenerateMount("Shadow Draptor", 427, 870, 1506672000, "A wild, ancient creature, which had been hiding in the depths of the shadows for a very long time, has been spotted again! The almighty Shadow Draptor has returned and only the bravest adventurers can control such a beast!")
	GenerateMount("Steelbeak", 522, 870, 1501228800, "Forged by only the highest skilled blacksmiths in the depths of Kazordoon's furnaces, a wild animal made out of the finest steel arose from glowing embers and blazing heat. Protected by its impenetrable armour, the Steelbeak is ready to accompany its master on every battleground.")
	GenerateMount("Crimson Ray", 521, 870, 1501228800, "Have you ever dreamed of gliding through the air on the back of a winged creature? With its deep red wings, the majestic Crimson Ray is a worthy mount for courageous heroes. Feel like a king on its back as you ride into your next adventure.")
	GenerateMount("Jungle Saurian", 959, 750, 1494576000, "Thousands of years ago, its ancestors ruled the world. The Jungle Saurian likes to hide in dense wood and overturned trees.")
	GenerateMount("Ember Saurian", 960, 750, 1494576000, "Thousands of years ago, its ancestors ruled the world. The Ember Saurian has been spotted in a sea of flames and fire deep down in the depths of Kazordoon.")
	GenerateMount("Lagoon Saurian", 961, 750, 1494576000, "Thousands of years ago, its ancestors ruled the world. The Lagoon Saurian feels most comfortable in torrential rivers and behind dangerous waterfalls.")
	GenerateMount("Gold Sphinx", 950, 750, 1490346000, "Ride a Gold Sphinx on your way through ancient chambers and tombs and have a loyal friend by your side while fighting countless mummies and other creatures.")
	GenerateMount("Emerald Sphinx", 951, 750, 1490346000, "Ride an Emerald Sphinx on your way through ancient chambers and tombs and have a loyal friend by your side while fighting countless mummies and other creatures.")
	GenerateMount("Shadow Sphinx", 952, 750, 1490346000, "Ride a Shadow Sphinx on your way through ancient chambers and tombs and have a loyal friend by your side while fighting countless mummies and other creatures.")
	GenerateMount("Jackalope", 905, 870, 1483686000, "Do you like fluffy bunnies but think they are too small? Do you admire the majesty of stags and their antlers but are afraid of their untameable wilderness? Do not worry, the mystic creature Jackalope consolidates the best qualities of both animals. Hop on its backs and enjoy the ride.")
	GenerateMount("Dreadhare", 907, 870, 1483686000, "Do you like fluffy bunnies but think they are too small? Do you admire the majesty of stags and their antlers but are afraid of their untameable wilderness? Do not worry, the mystic creature Dreadhare consolidates the best qualities of both animals. Hop on its backs and enjoy the ride.")
	GenerateMount("Wolpertinger", 906, 870, 1483686000, "Do you like fluffy bunnies but think they are too small? Do you admire the majesty of stags and their antlers but are afraid of their untameable wilderness? Do not worry, the mystic creature Wolpertinger consolidates the best qualities of both animals. Hop on its backs and enjoy the ride.")
	GenerateMount("Ivory Fang", 901, 750, 1477036800, "Incredible strength and smartness, an irrepressible will to survive, passionately hunting in groups. If these attributes apply to your character, we have found the perfect partner for you. Have a proper look at Ivory Fang, which stands loyally by its master's side in every situation. It is time to become the leader of the wolf pack!")
	GenerateMount("Shadow Claw", 902, 750, 1477036800, "Incredible strength and smartness, an irrepressible will to survive, passionately hunting in groups. If these attributes apply to your character, we have found the perfect partner for you. Have a proper look at Shadow Claw, which stands loyally by its master's side in every situation. It is time to become the leader of the wolf pack!")
	GenerateMount("Snow Pelt", 903, 750, 1477036800, "Incredible strength and smartness, an irrepressible will to survive, passionately hunting in groups. If these attributes apply to your character, we have found the perfect partner for you. Have a proper look at Snow Pelt, which stands loyally by its master's side in every situation. It is time to become the leader of the wolf pack!")
	GenerateMount("Swamp Snapper", 886, 690, 3190, "You are intrigued by tortoises and would love to throne on a tortoise shell when travelling the wilderness? The Swamp Snapper might become your new trustworthy companion then, which will transport you safely and even carry you during combat.")
	GenerateMount("Mould Shell", 887, 690, 3204, "You are intrigued by tortoises and would love to throne on a tortoise shell when travelling the wilderness? The Mould Shell might become your new trustworthy companion then, which will transport you safely and even carry you during combat.")
	GenerateMount("Reed Lurker", 888, 690, 3218, "You are intrigued by tortoises and would love to throne on a tortoise shell when travelling the wilderness? The Reed Lurker might become your new trustworthy companion then, which will transport you safely and even carry you during combat.")
	GenerateMount("Bloodcurl", 869, 750, 1690, "You are fascinated by insectoid creatures and can picture yourself riding one during combat or just for travelling? The Bloodcurl will carry you through the wilderness with ease.")
	GenerateMount("Leafscuttler", 870, 750, 1703, "You are fascinated by insectoid creatures and can picture yourself riding one during combat or just for travelling? The Leafscuttler will carry you through the wilderness with ease.")
	GenerateMount("Mouldpincer", 868, 750, 1716, "You are fascinated by insectoid creatures and can picture yourself riding one during combat or just for travelling? The Mouldpincer will carry you through the wilderness with ease.")
	GenerateMount("Nightdweller", 849, 870, 1558, "If you are more of an imp than an angel, you may prefer riding out on a Nightdweller to scare fellows on their festive strolls. Its devilish mask, claw-like hands and sharp hooves makes it the perfect companion for any daring adventurer who likes to stand out.")
	GenerateMount("Frostflare", 850, 870, 1570, "If you are more of an imp than an angel, you may prefer riding out on a Frostflare to scare fellows on their festive strolls. Its devilish mask, claw-like hands and sharp hooves makes it the perfect companion for any daring adventurer who likes to stand out.")
	GenerateMount("Cinderhoof", 851, 870, 1583, "If you are more of an imp than an angel, you may prefer riding out on a Cinderhoof to scare fellows on their festive strolls. Its devilish mask, claw-like hands and sharp hooves makes it the perfect companion for any daring adventurer who likes to stand out.")
	GenerateMount("Slagsnare", 761, 780, 1430, "The Slagsnare has external characteristics of different breeds. It is assumed that his brain is also composed of many different species, which makes it completely unpredictable. Only few have managed to approach this creature unharmed and only the best could tame it.")
	GenerateMount("Nightstinger", 762, 780, 1442, "The Nightstinger has external characteristics of different breeds. It is assumed that his brain is also composed of many different species, which makes it completely unpredictable. Only few have managed to approach this creature unharmed and only the best could tame it.")
	GenerateMount("Razorcreep", 763, 780, 1454, "The Razorcreep has external characteristics of different breeds. It is assumed that his brain is also composed of many different species, which makes it completely unpredictable. Only few have managed to approach this creature unharmed and only the best could tame it.")
	GenerateMount("Gorongra", 738, 720, 967, "Get yourself a mighty travelling companion with broad shoulders and a gentle heart. Gorongra is a physically imposing creature that is much more peaceful than its relatives, Tiquanda's wild kongras, and will carry you safely wherever you ask it to go.")
	GenerateMount("Noctungra", 739, 720, 979, "Get yourself a mighty travelling companion with broad shoulders and a gentle heart. Noctungra is a physically imposing creature that is much more peaceful than its relatives, Tiquanda's wild kongras, and will carry you safely wherever you ask it to go.")
	GenerateMount("Silverneck", 740, 720, 990, "Get yourself a mighty travelling companion with broad shoulders and a gentle heart. Silverneck is a physically imposing creature that is much more peaceful than its relatives, Tiquanda's wild kongras, and will carry you safely wherever you ask it to go.")
	GenerateMount("Sea Devil", 734, 570, 348, "If the Sea Devil moves its fins, it generates enough air pressure that it can even float over land. Its numerous eyes allow it to quickly detect dangers even in confusing situations and eliminate them with one powerful bite. If you watch your fingers, you are going to be good friends.")
	GenerateMount("Coralripper", 735, 570, 353, "If the Coralripper moves its fins, it generates enough air pressure that it can even float over land. Its numerous eyes allow it to quickly detect dangers even in confusing situations and eliminate them with one powerful bite. If you watch your fingers, you are going to be good friends.")
	GenerateMount("Plumfish", 736, 570, 358, "If the Plumfish moves its fins, it generates enough air pressure that it can even float over land. Its numerous eyes allow it to quickly detect dangers even in confusing situations and eliminate them with one powerful bite. If you watch your fingers, you are going to be good friends.")
	GenerateMount("Flitterkatzen", 726, 870, 326, "Rumour has it that many years ago elder witches had gathered to hold a magical feast high up in the mountains. They had crossbred Flitterkatzen to easily conquer rocky canyons and deep valleys. Nobody knows what happened on their way up but only the mount has been seen ever since.")
	GenerateMount("Venompaw", 727, 870, 331, "Rumour has it that many years ago elder witches had gathered to hold a magical feast high up in the mountains. They had crossbred Venompaw to easily conquer rocky canyons and deep valleys. Nobody knows what happened on their way up but only the mount has been seen ever since.")
	GenerateMount("Batcat", 728, 870, 336, "Rumour has it that many years ago elder witches had gathered to hold a magical feast high up in the mountains. They had crossbred Batcat to easily conquer rocky canyons and deep valleys. Nobody knows what happened on their way up but only the mount has been seen ever since.")
	GenerateMount("Ringtail Waccoon", 691, 750, 303, "Waccoons are cuddly creatures that love nothing more than to be petted and snuggled! Share a hug, ruffle the fur of the Ringtail Waccoon and scratch it behind its ears to make it happy.")
	GenerateMount("Night Waccoon", 692, 750, 308, "Waccoons are cuddly creatures that love nothing more than to be petted and snuggled! Share a hug, ruffle the fur of the Night Waccoon and scratch it behind its ears to make it happy.")
	GenerateMount("Emerald Waccoon", 693, 750, 313, "Waccoons are cuddly creatures that love nothing more than to be petted and snuggled! Share a hug, ruffle the fur of the Emerald Waccoon and scratch it behind its ears to make it happy.")
	GenerateMount("Flying Divan", 688, 900, 281, "The Flying Divan is the perfect mount for those who are too busy to take care of an animal mount or simply like to travel on a beautiful, magic hand-woven carpet.")
	GenerateMount("Magic Carpet", 689, 900, 289, "The Magic Carpet is the perfect mount for those who are too busy to take care of an animal mount or simply like to travel on a beautiful, magic hand-woven carpet.")
	GenerateMount("Floating Kashmir", 690, 900, 296, "The Floating Kashmir is the perfect mount for those who are too busy to take care of an animal mount or simply like to travel on a beautiful, magic hand-woven carpet.")
	GenerateMount("Shadow Hart", 685, 660, 259, "Treat your character to a new travelling companion with a gentle nature and an impressive antler: The noble Shadow Hart will carry you through the deepest snow.")
	GenerateMount("Black Stag", 686, 660, 266, "Treat your character to a new travelling companion with a gentle nature and an impressive antler: The noble Black Stag will carry you through the deepest snow.")
	GenerateMount("Emperor Deer", 687, 660, 274, "Treat your character to a new travelling companion with a gentle nature and an impressive antler: The noble Emperor Deer will carry you through the deepest snow.")
	GenerateMount("Tundra Rambler", 672, 750, 237, "With its thick, shaggy hair, the Tundra Rambler will keep you warm even in the chilly climate of the Ice Islands. Due to its calm and peaceful nature, it is not letting itself getting worked up easily.")
	GenerateMount("Highland Yak", 673, 750, 244, "With its thick, shaggy hair, the Highland Yak will keep you warm even in the chilly climate of the Ice Islands. Due to its calm and peaceful nature, it is not letting itself getting worked up easily.")
	GenerateMount("Glacier Vagabond", 674, 750, 252, "With its thick, shaggy hair, the Glacier Vagabond will keep you warm even in the chilly climate of the Ice Islands. Due to its calm and peaceful nature, it is not letting itself getting worked up easily.")
	GenerateMount("Golden Dragonfly", 669, 600, 215, "If you are more interested in the achievements of science, you may enjoy a ride on the Golden Dragonfly, one of the new insect-like flying machines. Even if you do not move around, the wings of these unusual vehicles are always in motion.")
	GenerateMount("Steel Bee", 670, 600, 222, "If you are more interested in the achievements of science, you may enjoy a ride on the Steel Bee, one of the new insect-like flying machines. Even if you do not move around, the wings of these unusual vehicles are always in motion.")
	GenerateMount("Copper Fly", 671, 600, 229, "If you are more interested in the achievements of science, you may enjoy a ride on the Copper Fly, one of the new insect-like flying machines. Even if you do not move around, the wings of these unusual vehicles are always in motion.")
	GenerateMount("Doombringer", 644, 780, 192, "Once captured and held captive by a mad hunter, the Doombringer is the result of sick experiments. Fed only with demon dust and concentrated demonic blood it had to endure a dreadful transformation. The demonic blood that is now running through its veins, however, provides it with incredible strength and endurance.")
	GenerateMount("Woodland Prince", 647, 780, 200, "Once captured and held captive by a mad hunter, the Woodland Prince is the result of sick experiments. Fed only with demon dust and concentrated demonic blood it had to endure a dreadful transformation. The demonic blood that is now running through its veins, however, provides it with incredible strength and endurance.")
	GenerateMount("Hailstorm Fury", 648, 780, 207, "Once captured and held captive by a mad hunter, the Hailstorm Fury is the result of sick experiments. Fed only with demon dust and concentrated demonic blood it had to endure a dreadful transformation. The demonic blood that is now running through its veins, however, provides it with incredible strength and endurance.")
	GenerateMount("Siegebreaker", 649, 690, 154, "The Siegebreaker is out searching for the best bamboo. Its heavy armour allows it to visit even the most dangerous places. Treat it nicely with its favourite food from time to time and it will become a loyal partner.")
	GenerateMount("Poisonbane", 650, 690, 161, "The Poisonbane is out searching for the best bamboo. Its heavy armour allows it to visit even the most dangerous places. Treat it nicely with its favourite food from time to time and it will become a loyal partner.")
	GenerateMount("Blackpelt", 651, 690, 169, "The Blackpelt is out searching for the best bamboo. Its heavy armour allows it to visit even the most dangerous places. Treat it nicely with its favourite food from time to time and it will become a loyal partner.")
	GenerateMount("Nethersteed", 629, 900, 132, "Once a majestic and proud warhorse, the Nethersteed has fallen in a horrible battle many years ago. Driven by agony and pain, its spirit once again took possession of its rotten corpse to avenge its death. Stronger than ever, it seeks a master to join the battlefield, aiming for nothing but death and destruction.")
	GenerateMount("Tempest", 630, 900, 139, "Once a majestic and proud warhorse, the Tempest has fallen in a horrible battle many years ago. Driven by agony and pain, its spirit once again took possession of its rotten corpse to avenge its death. Stronger than ever, it seeks a master to join the battlefield, aiming for nothing but death and destruction.")
	GenerateMount("Flamesteed", 626, 900, 147, "Once a majestic and proud warhorse, the Flamesteed has fallen in a horrible battle many years ago. Driven by agony and pain, its spirit once again took possession of its rotten corpse to avenge its death. Stronger than ever, it seeks a master to join the battlefield, aiming for nothing but death and destruction.")
	GenerateMount("Tombstinger", 546, 600, 110, "The Tombstinger is a scorpion that has surpassed the natural boundaries of its own kind. Way bigger, stronger and faster than ordinary scorpions, it makes a perfect companion for fearless heroes and explorers. Just be careful of his poisonous sting when you mount it.")
	GenerateMount("Death Crawler", 624, 600, 117, "The Death Crawler is a scorpion that has surpassed the natural boundaries of its own kind. Way bigger, stronger and faster than ordinary scorpions, it makes a perfect companion for fearless heroes and explorers. Just be careful of his poisonous sting when you mount it.")
	GenerateMount("Jade Pincer", 628, 600, 124, "The Jade Pincer is a scorpion that has surpassed the natural boundaries of its own kind. Way bigger, stronger and faster than ordinary scorpions, it makes a perfect companion for fearless heroes and explorers. Just be careful of his poisonous sting when you mount it.")
	GenerateMount("Desert King", 572, 450, 57, "Its roaring is piercing marrow and bone and can be heard over ten miles away. The Desert King is the undisputed ruler of its territory and no one messes with this animal. Show no fear and prove yourself worthy of its trust and you will get yourself a valuable companion for your adventures.")
	GenerateMount("Jade Lion", 627, 450, 95, "Its roaring is piercing marrow and bone and can be heard over ten miles away. The Jade Lion is the undisputed ruler of its territory and no one messes with this animal. Show no fear and prove yourself worthy of its trust and you will get yourself a valuable companion for your adventures.")
	GenerateMount("Winter King", 631, 450, 102, "Its roaring is piercing marrow and bone and can be heard over ten miles away. The Winter King is the undisputed ruler of its territory and no one messes with this animal. Show no fear and prove yourself worthy of its trust and you will get yourself a valuable companion for your adventures.")

-- Beds
	-- name, price, publishedAt, headboard, footboard
	GenerateBed("Verdant Bed", 150, 1663920000, 28752, 28753)
	GenerateBed("Homely Bed", 120, 1663920000, 36976, 36977)
	GenerateBed("Wrought-Iron Bed", 150, 1663920000, 37862, 37863)
	GenerateBed("Vengothic Bed", 180, 1663920000, 38539, 38540)
	GenerateBed("Ornate Bed", 180, 1663920000, 38527, 38528)
	GenerateBed("Magnificent Bed", 180, 1663920000, 38515, 38516)
	GenerateBed("Grandiose Bed", 150, 1663920000, 38592, 38593)
	GenerateBed("Log Bed", 150, 1663920000, 39687, 39688)
	GenerateBed("Kraken Bed", 150, 1663920000, 39857, 39858)
	GenerateBed("Sleeping Mat", 120, 1663920000, 40941, 40942)
	GenerateBed("Knightly Bed", 180, 1663920000, 44468, 44469)
	GenerateBed("Flower Bed", 150, 1663920000, 44785, 44786)

	-- bone bed is from quest
	-- other beds should be from shop

-- Carpets
	-- itemId, price, publishedAt
	GenerateCarpet(26087, 35, 1449565200) -- yalaharian carpet
	GenerateCarpet(26088, 30, 1449565200) -- white fur carpet
	GenerateCarpet(26089, 25, 1449565200) -- bamboo mat
	GenerateCarpet(26363, 35, 1472547600) -- crimson carpet
	GenerateCarpet(26366, 35, 1472547600) -- azure carpet
	GenerateCarpet(26367, 35, 1472547600) -- emerald carpet
	GenerateCarpet(26368, 30, 1472547600) -- light parquet carpet
	GenerateCarpet(26369, 30, 1472547600) -- dark parquet carpet
	GenerateCarpet(26370, 30, 1472547600) -- marble floor
	GenerateCarpet(27072, 35, 1484557200) -- colorful carpet
	GenerateCarpet(27073, 35, 1484557200) -- flowery carpet
	GenerateCarpet(27074, 30, 1484557200) -- striped carpet
	GenerateCarpet(27075, 30, 1484557200) -- fur carpet
	GenerateCarpet(27076, 25, 1484557200) -- diamond carpet
	GenerateCarpet(27077, 30, 1484557200) -- patterned carpet
	GenerateCarpet(27078, 25, 1484557200) -- night sky carpet
	GenerateCarpet(27079, 25, 1484557200) -- star carpet
	GenerateCarpet(28770, 30, 1500973200) -- verdant carpet
	GenerateCarpet(28772, 30, 1500973200) -- shaggy carpet
	GenerateCarpet(28774, 35, 1500973200) -- mystic carpet
	GenerateCarpet(28776, 25, 1500973200) -- stone tiles
	GenerateCarpet(28779, 25, 1500973200) -- wooden planks
	GenerateCarpet(28807, 30, 1500973200) -- wheat carpet
	GenerateCarpet(28808, 25, 1500973200) -- crested carpet
	GenerateCarpet(28810, 35, 1500973200) -- decorated carpet
	GenerateCarpet(38543, 30, 1606726800) -- lilac carpet
	GenerateCarpet(38545, 30, 1606726800) -- pom-pom carpet
	GenerateCarpet(38547, 30, 1606726800) -- natural pom-pom carpet
	GenerateCarpet(38549, 30, 1606726800) -- owig rug
	GenerateCarpet(38551, 30, 1606726800) -- panther rug
	GenerateCarpet(38553, 25, 1606726800) -- moon carpet
	GenerateCarpet(38555, 30, 1606726800) -- romantic carpet
	GenerateCarpet(39675, 30, 1626080400) -- grass
	GenerateCarpet(44794, 30, 1658134800) -- flowery grass

-- Runes
	-- gfb
	GenerateRune(2304, 28, STORE_RUNE_TYPE_ATTACK, "A shot of this rune affects a huge area - up to 37 square metres! It stands to reason that the Great Fireball is a favourite of most Tibians, as it is well suited both to hit whole crowds of monsters and individual targets that are difficult to hit because they are fast or hard to spot.")

	-- sd
	GenerateRune(2268, 12, STORE_RUNE_TYPE_ATTACK, "Nearly no other spell can compare to Sudden Death when it comes to sheer damage. For this reason it is immensely popular despite the fact that only a single target is affected. However, since the damage caused by the rune is of deadly nature, it is less useful against most undead creatures.")

	-- ava
	GenerateRune(2274, 12, STORE_RUNE_TYPE_ATTACK, "The ice damage which arises from this rune is a useful weapon in every battle but it comes in particularly handy if you fight against a horde of creatures dominated by the element fire.")

	-- icicle
	GenerateRune(2271, 6, STORE_RUNE_TYPE_ATTACK, "Particularly creatures determined by the element fire are vulnerable against this ice-cold rune. Being hit by the magic stored in this rune, an ice arrow seems to pierce the heart of the struck victim. The damage done by this rune is quite impressive which makes this a quite popular rune among mages.")

	-- mw
	GenerateRune(2293, 23, STORE_RUNE_TYPE_FIELD, "This spell causes all particles that are contained in the surrounding air to quickly gather and contract until a solid wall is formed that covers one full square metre. The wall that is formed that way is impenetrable to any missiles or to light and no creature or character can walk through it. However, the wall will only last for a couple of seconds.")
	
	-- thunderstorm
	GenerateRune(2315, 9, STORE_RUNE_TYPE_ATTACK, "Flashes filled with dangerous energy hit the rune user's opponent when this rune is being used. It is especially effective against ice dominated creatures. Covering up an area up to 37 squares, this rune is particularly useful when you meet a whole mob of opponents.")
	
	-- energy bomb
	GenerateRune(2262, 40, STORE_RUNE_TYPE_FIELD, "Using the Energy Bomb rune will create a field of deadly energy that deals damage to all who carelessly step into it. Its area of effect is covering a full 9 square metres! Creatures that are caught in the middle of an Energy Bomb are frequently confused by the unexpected effect, and some may even stay in the field of deadly sparks for a while.")

	-- energy wall
	GenerateRune(2279, 17, STORE_RUNE_TYPE_FIELD, "Casting this spell generates a solid wall made up of magical energy. Walls made this way surpass any other magically created obstacle in width, so it is always a good idea to have an Energy Wall rune or two in one's pocket when travelling through the wilderness.")
	
	-- fire field
	GenerateRune(2301, 6, STORE_RUNE_TYPE_FIELD, "When this rune is used a field of one square metre is covered by searing fire that will last for some minutes, gradually diminishing as the blaze wears down. As with all field spells, Fire Field is quite useful to block narrow passageways or to create large, connected barriers.")

	-- stone shower
	GenerateRune(2288, 7, STORE_RUNE_TYPE_ATTACK, "Particularly creatures with an affection to energy will suffer greatly from this rune filled with powerful earth damage. As the name already says, a shower of stones drums on the opponents of the rune user in an area up to 37 squares.")

	-- animate dead
	GenerateRune(2316, 75, STORE_RUNE_TYPE_SUMMON, "After a long time of research, the magicians of Edron succeeded in storing some life energy in a rune. When this energy was unleashed onto a body it was found that an undead creature arose that could be mentally controlled by the user of the rune. This rune is useful to create allies in combat.")

	-- chameleon
	GenerateRune(2291, 42, STORE_RUNE_TYPE_SUPPORT, "The metamorphosis caused by this rune is only superficial, and while casters who are using the rune can take on the exterior form of nearly any inanimate object, they will always retain their original smell and mental abilities. So there is no real practical use for this rune, making this largely a fun rune.")
	
	-- connvince rune
	GenerateRune(2290, 16, STORE_RUNE_TYPE_SUMMON, "Using this rune together with some mana, you can convince certain creatures. The needed amount of mana is determined by the power of the creature one wishes to convince, so the amount of mana to convince a rat is lower than that which is needed for an orc.")

	-- cure poison
	GenerateRune(2266, 13, STORE_RUNE_TYPE_HEALING, "In the old days, many adventurers fell prey to poisonous creatures that were roaming the caves and forests. After many years of research druids finally succeeded in altering the cure poison spell so it could be bound to a rune. By using this rune it is possible to stop the effect of any known poison.")
	
	-- disintegrate
	GenerateRune(2310, 5, STORE_RUNE_TYPE_SUPPORT, "Nothing is worse than being cornered when fleeing from an enemy you just cannot beat, especially if the obstacles in your way are items you could easily remove if only you had the time! However, there is one reliable remedy: The Disintegrate rune will instantly destroy up to 500 movable items that are in your way, making room for a quick escape.")

	-- energy field
	GenerateRune(2277, 8, STORE_RUNE_TYPE_FIELD, "This spell creates a limited barrier made up of crackling energy that will cause electrical damage to all those passing through. Since there are few creatures that are immune to the harmful effects of energy this spell is not to be underestimated.")

	-- explosion
	GenerateRune(2313, 6, STORE_RUNE_TYPE_ATTACK, "This rune must be aimed at areas rather than at specific creatures, so it is possible for explosions to be unleashed even if no targets are close at all. These explosions cause a considerable physical damage within a substantial blast radius.")

	-- fire bomb
	GenerateRune(2305, 29, STORE_RUNE_TYPE_FIELD, "This rune is a deadly weapon in the hands of the skilled user. On releasing it an area of 9 square metres is covered by searing flames that will scorch all those that are unfortunate enough to be caught in them. Worse, many monsters are confused by the unexpected blaze, and with a bit of luck a caster will even manage to trap his opponents by using the spell.")
	
	-- fire wall
	GenerateRune(2303, 12, STORE_RUNE_TYPE_FIELD, "This rune offers reliable protection against all creatures that are afraid of fire. The exceptionally long duration of the spell as well as the possibility to form massive barriers or even protective circles out of fire walls make this a versatile, practical spell.")

	-- fireball
	GenerateRune(2302, 6, STORE_RUNE_TYPE_ATTACK, "When this rune is used a massive fiery ball is released which hits the aimed foe with immense power. It is especially effective against opponents of the element earth.")

	-- intense healing
	GenerateRune(2265, 19, STORE_RUNE_TYPE_HEALING, "This rune is commonly used by young adventurers who are not skilled enough to use the rune's stronger version. Also, since the rune's effectiveness is determined by the user's magic skill, it is still popular among experienced spell casters who use it to get effective healing magic at a cheap price.")

	-- paralyse
	GenerateRune(2278, 140, STORE_RUNE_TYPE_SUPPORT, "The effect of this rune causes the target's blood to thicken, leaving it paralysed and unable to fight or escape unless the effect has worn off. This rune can buy its user precious time in combat.")

	-- poison bomb
	GenerateRune(2286, 17, STORE_RUNE_TYPE_FIELD, "This rune causes an area of 9 square metres to be contaminated with toxic gas that will poison anybody who is caught within it. Conceivable applications include the blocking of areas or the combat against fast-moving or invisible targets. Keep in mind, however, that there are a number of creatures that are immune to poison.")

	-- poison wall
	GenerateRune(2289, 10, STORE_RUNE_TYPE_FIELD, "When this rune is used a wall of concentrated toxic fumes is created which inflicts a moderate poison on all those who are foolish enough to enter it. The effect is usually impressive enough to discourage monsters from doing so, although few of the stronger ones will hesitate if there is nothing but a poison wall between them and their dinner.")

	-- soulfire
	GenerateRune(2308, 9, STORE_RUNE_TYPE_ATTACK, "Soulfire is an immensely evil spell as it directly targets a creature's very life essence. When the rune is used on a victim, its soul is temporarily moved out of its body, casting it down into the blazing fires of hell itself! Note that the experience and the mental strength of the caster influence the damage that is caused.")

	-- ultimate healing
	GenerateRune(2273, 35, STORE_RUNE_TYPE_HEALING, "The coveted Ultimate Healing rune is an all-time favourite among all vocations. No other healing enchantments that are bound into runes can compare to its salutary effect.")

	-- wild growth
	GenerateRune(2269, 32, STORE_RUNE_TYPE_FIELD, "By unleashing this spell, all seeds that are lying dormant in the surrounding quickly sprout and grow into full-sized plants, thus forming an impenetrable thicket. Unfortunately, plant life created this way is short-lived and will collapse within minutes, so the magically created obstacle will not last long.")

-- Potions
	-- itemId, price1, amount1, price2, amount2
	
	-- health, mana, spirit
	-- normal
	GeneratePotion(7618, 6, 125, 12, 300)
	GeneratePotion(7620, 6, 125, 11, 300)

	-- strong
	GeneratePotion(7588, 10, 100, 21, 250)
	GeneratePotion(7589, 7, 100, 17, 250)

	-- great
	GeneratePotion(7591, 18, 100, 41, 250)
	GeneratePotion(7590, 11, 100, 26, 250)
	GeneratePotion(8472, 18, 100, 41, 250)

	-- ultimate
	GeneratePotion(8473, 29, 100, 68, 250)
	GeneratePotion(26029, 33, 100, 79, 250)
	GeneratePotion(26030, 33, 100, 79, 250)
	
	-- supreme
	GeneratePotion(26031, 47, 100, 113, 250)

-- Casks and Kegs
	GenerateCasksKegs(KegTable, 28535, 28570)

-- irregular items
-- GenerateStoreItem
-- itemId, price, category, subCategory, publishedAt, amountBase, amountMulti, description

	-- normal exercise weapons
	for itemId = 31208, 31213 do
		GenerateStoreItem(itemId, 25, STORE_TAB_EXERCISE, 1, 0, 1, nil, generateExerciseDesc(itemId))
	end
	
	-- durable and lasting exercise weapons
	for itemId = 37935, 37946 do
		local price = itemId < 37941 and 90 or 720
		GenerateStoreItem(itemId, price, STORE_TAB_EXERCISE, itemId < 37941 and 2 or 3, 0, 1, nil, generateExerciseDesc(itemId))
	end
	
-- House Upgrades
	-- dummies
	GenerateStoreItem(31215, 900, STORE_TAB_UPGRADES, 1, 0, 1, nil, StoreDescriptions.dummy)
	GenerateStoreItem(31217, 900, STORE_TAB_UPGRADES, 1, 0, 1, nil, StoreDescriptions.dummy)
	GenerateStoreItem(31219, 900, STORE_TAB_UPGRADES, 1, 0, 1, nil, StoreDescriptions.dummy)
	
	-- mailboxes
	GenerateStoreItem(26055, 150, STORE_TAB_UPGRADES, 2, 0, 1, nil, StoreDescriptions.mailbox)
	GenerateStoreItem(26057, 200, STORE_TAB_UPGRADES, 2, 0, 1, nil, StoreDescriptions.mailbox)
	
	-- shrines
	GenerateStoreItem(27831, 150, STORE_TAB_UPGRADES, 3, 0, 1, nil, StoreDescriptions.imbu)
	GenerateStoreItem(27839, 200, STORE_TAB_UPGRADES, 3, 0, 1, nil, StoreDescriptions.imbu)
	
	-- reward
	GenerateStoreItem(28377, 150, STORE_TAB_UPGRADES, 4, 0, 1, nil, StoreDescriptions.dailyshrine)
	GenerateStoreItem(28379, 200, STORE_TAB_UPGRADES, 4, 0, 1, nil, StoreDescriptions.dailyshrine)

-- Furniture
-- {{itemId, price}}, setName, subCategory
	-- note: furniture sets also generate offers for individual items
	GenerateFurnitureSet(
		-- table, chest, chair, wardrobe
		{{26074, 60}, {26083, 70}, {26061, 60}, {26075, 100}},
		"Magnificent", 1
	)
	GenerateFurnitureSet(
		{{26067, 50}, {26079, 80}, {26065, 50}, {26077, 110}},
		"Ferocious", 2
	)
	GenerateFurnitureSet(
		{{26354, 50}, {26358, 80}, {26351, 50}, {26356, 100}},
		"Rustic", 3
	)
	GenerateFurnitureSet(
		{{27881, 50}, {27885, 80}, {27879, 50}, {27883, 100}},
		"Vengothic", 4
	)
	GenerateFurnitureSet(
		{{28767, 50}, {28763, 80}, {28759, 50}, {28761, 100}},
		"Verdant", 5
	)
	GenerateFurnitureSet(
		{{28817, 50}, {28821, 80}, {28814, 50}, {28818, 100}},
		"Ornate", 6
	)

	-- alchemistic tab does not have a set
	GenerateStoreItem(30320, 100, STORE_TAB_FURNITURE, 7, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(30318, 50, STORE_TAB_FURNITURE, 7, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(30321, 80, STORE_TAB_FURNITURE, 7, 0, 1, nil, StoreDescriptions.furniture_default)

	GenerateFurnitureSet(
		{{31336, 50}, {31338, 80}, {31332, 50}, {31343, 100}},
		"Skeletal", 8
	)
	GenerateFurnitureSet(
		{{31592, 60}, {31594, 60}, {31590, 70}, {31598, 100}},
		"Comfy", 9
	)
	GenerateFurnitureSet(
		{{33847, 50}, {33843, 80}, {33841, 50}, {33848, 100}},
		"Dwarven Stone", 10
	)
	GenerateFurnitureSet(
		{{34335, 50}, {34343, 80}, {34349, 50}, {34361, 100}},
		"Hrodmir", 11
	)
	GenerateFurnitureSet(
		{{35433, 60}, {35436, 80}, {35434, 50}, {35431, 100}},
		"Ice", 12
	)
	GenerateFurnitureSet(
		{{35690, 50}, {35699, 80}, {35694, 50}, {35688, 100}},
		"Heart", 13
	)
	GenerateFurnitureSet(
		{{36690, 80}, {36696, 50}, {36694, 50}, {36686, 110}},
		"Artist", 14
	)
	GenerateFurnitureSet(
		{{36704, 80}, {36710, 50}, {36708, 50}, {36700, 110}},
		"Sculptor", 15
	)
	GenerateFurnitureSet(
		{{36940, 100}, {36952, 50}, {36950, 50}, {36932, 90}},
		"Kitchen", 16
	)
	GenerateFurnitureSet(
		{{37819, 90}, {37829, 50}, {37826, 50}, {37831, 90}},
		"Smithy", 17
	)
	GenerateFurnitureSet(
		{{38569, 50}, {38577, 70}, {38573, 60}, {38567, 100}},
		"Grandiose", 18
	)
	
	GenerateFurnitureSet(
		{{38615, 60}, {38616, 60}, {38617, 60}},
		"Grandiose Couch", 18
	)
	
	-- gilded grandiose chest
	GenerateStoreItem(38581, 90, STORE_TAB_FURNITURE, 18, 0, 1, nil, StoreDescriptions.furniture_default)
	
	GenerateFurnitureSet(
		{{39295, 50}, {39288, 80}, {39292, 60}, {39301, 100}},
		"Volcanic", 19
	)
	
	GenerateFurnitureSet(
		{{39664, 50}, {39667, 50}, {39662, 80}, {39665, 100}},
		"Nature", 20
	)
	
	GenerateFurnitureSet(
		{{39834, 60}, {39837, 70}, {39832, 80}, {39835, 100}},
		"Kraken", 21
	)

	GenerateFurnitureSet(
		{{40951, 60}, {40952, 70}, {40926, 60}, {40930, 100}},
		"Zaoan", 22
	)
	
	GenerateFurnitureSet(
		{{44454, 60}, {44537, 60}, {44452, 70}, {44472, 100}},
		"Knightly", 23
	)
	
	-- knightly bench
	GenerateFurnitureSet(
		{{44549, 80}, {44552, 60}},
		"Knightly Bench", 23
	)
	GenerateStoreItem(44548, 60, STORE_TAB_FURNITURE, 23, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(44550, 80, STORE_TAB_FURNITURE, 23, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(44551, 80, STORE_TAB_FURNITURE, 23, 0, 1, nil, StoreDescriptions.furniture_default)
	
	-- knightly chess table
	GenerateStoreItem(44458, 60, STORE_TAB_FURNITURE, 23, 0, 1, nil, StoreDescriptions.furniture_default)
	
	-- knightly decorative shield
	GenerateStoreItem(44533, 60, STORE_TAB_FURNITURE, 23, 0, 1, nil, StoreDescriptions.furniture_default)
	
	GenerateFurnitureSet(
		{{44771, 80}, {44776, 60}, {44767, 60}, {44772, 90}},
		"Floral", 24
	)
	
	-- to do: seafarer
	
	-- round side table
	GenerateStoreItem(33864, 50, STORE_TAB_FURNITURE, 26, 0, 1, nil, StoreDescriptions.furniture_default)

	-- square side table
	GenerateStoreItem(33863, 50, STORE_TAB_FURNITURE, 26, 0, 1, nil, StoreDescriptions.furniture_default)

	-- wooden bookcase
	GenerateStoreItem(33850, 100, STORE_TAB_FURNITURE, 26, 0, 1, nil, StoreDescriptions.furniture_default)

-- Decorations
	-- TO DO: fix descriptions, add scripts, check rotate
	
	-- tapestries (x1, x5 options)
	GenerateStoreItem(26104, 50, STORE_TAB_DECORATIONS, 2, 0, 1, 5, StoreDescriptions.furniture_default)
	GenerateStoreItem(26105, 70, STORE_TAB_DECORATIONS, 2, 0, 1, 5, StoreDescriptions.furniture_default)
	GenerateStoreItem(26106, 60, STORE_TAB_DECORATIONS, 2, 0, 1, 5, StoreDescriptions.furniture_default)
	GenerateStoreItem(26380, 60, STORE_TAB_DECORATIONS, 2, 0, 1, 5, StoreDescriptions.furniture_default)
	GenerateStoreItem(26379, 70, STORE_TAB_DECORATIONS, 2, 0, 1, 5, StoreDescriptions.furniture_default)
	GenerateStoreItem(26381, 50, STORE_TAB_DECORATIONS, 2, 0, 1, 5, StoreDescriptions.furniture_default)
	GenerateStoreItem(40923, 50, STORE_TAB_DECORATIONS, 2, 0, 1, 5, StoreDescriptions.furniture_default)
	GenerateStoreItem(40924, 50, STORE_TAB_DECORATIONS, 2, 0, 1, 5, StoreDescriptions.furniture_default)
	GenerateStoreItem(40925, 50, STORE_TAB_DECORATIONS, 2, 0, 1, 5, StoreDescriptions.furniture_default)
	
	-- pets (missing use/decay scripts)
	GenerateStoreItem(26098, 250, STORE_TAB_DECORATIONS, 3, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(26100, 180, STORE_TAB_DECORATIONS, 3, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(26107, 150, STORE_TAB_DECORATIONS, 3, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(26347, 180, STORE_TAB_DECORATIONS, 3, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(26364, 150, STORE_TAB_DECORATIONS, 3, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(27088, 180, STORE_TAB_DECORATIONS, 3, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(27869, 250, STORE_TAB_DECORATIONS, 3, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(28734, 180, STORE_TAB_DECORATIONS, 3, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(28827, 180, STORE_TAB_DECORATIONS, 3, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(28829, 250, STORE_TAB_DECORATIONS, 3, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(31346, 150, STORE_TAB_DECORATIONS, 3, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(31350, 150, STORE_TAB_DECORATIONS, 3, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(34336, 150, STORE_TAB_DECORATIONS, 3, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(34359, 250, STORE_TAB_DECORATIONS, 3, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(34611, 180, STORE_TAB_DECORATIONS, 3, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(35444, 250, STORE_TAB_DECORATIONS, 3, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(35446, 250, STORE_TAB_DECORATIONS, 3, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(35696, 180, STORE_TAB_DECORATIONS, 3, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(36684, 250, STORE_TAB_DECORATIONS, 3, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(36926, 180, STORE_TAB_DECORATIONS, 3, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(37809, 250, STORE_TAB_DECORATIONS, 3, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(38605, 250, STORE_TAB_DECORATIONS, 3, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(39302, 250, STORE_TAB_DECORATIONS, 3, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(39678, 180, STORE_TAB_DECORATIONS, 3, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(39867, 180, STORE_TAB_DECORATIONS, 3, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(40959, 180, STORE_TAB_DECORATIONS, 3, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(44539, 250, STORE_TAB_DECORATIONS, 3, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(44804, 180, STORE_TAB_DECORATIONS, 3, 0, 1, nil, StoreDescriptions.furniture_default)
	-- captain crab (to do)

	-- plants (missing transformitem scripts for florals)
	GenerateStoreItem(27872, 50, STORE_TAB_DECORATIONS, 4, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(27873, 50, STORE_TAB_DECORATIONS, 4, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(27874, 50, STORE_TAB_DECORATIONS, 4, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(27875, 50, STORE_TAB_DECORATIONS, 4, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(27876, 50, STORE_TAB_DECORATIONS, 4, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(31345, 150, STORE_TAB_DECORATIONS, 4, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(31353, 50, STORE_TAB_DECORATIONS, 4, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(31354, 50, STORE_TAB_DECORATIONS, 4, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(31355, 50, STORE_TAB_DECORATIONS, 4, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(40946, 50, STORE_TAB_DECORATIONS, 4, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(40947, 50, STORE_TAB_DECORATIONS, 4, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(44796, 50, STORE_TAB_DECORATIONS, 4, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(44797, 50, STORE_TAB_DECORATIONS, 4, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(44798, 50, STORE_TAB_DECORATIONS, 4, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(44800, 50, STORE_TAB_DECORATIONS, 4, 0, 1, nil, StoreDescriptions.furniture_default)

	-- paintings
	GenerateStoreItem(30353, 100, STORE_TAB_DECORATIONS, 5, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(30354, 50, STORE_TAB_DECORATIONS, 5, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(30355, 100, STORE_TAB_DECORATIONS, 5, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(30356, 100, STORE_TAB_DECORATIONS, 5, 0, 1, nil, StoreDescriptions.furniture_default)
	-- to do: 2 piece painting: 31603+31604, 250
	GenerateStoreItem(38596, 50, STORE_TAB_DECORATIONS, 5, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(40948, 50, STORE_TAB_DECORATIONS, 5, 0, 1, nil, StoreDescriptions.furniture_default)

	-- busts (missing use/rotate scripts)
	GenerateStoreItem(36714, 100, STORE_TAB_DECORATIONS, 6, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(30348, 70, STORE_TAB_DECORATIONS, 6, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(30351, 50, STORE_TAB_DECORATIONS, 6, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(30358, 50, STORE_TAB_DECORATIONS, 6, 0, 1, nil, StoreDescriptions.furniture_default)

	-- lamps (missing use/rotate scripts)
	GenerateStoreItem(26092, 60, STORE_TAB_DECORATIONS, 7, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(26097, 90, STORE_TAB_DECORATIONS, 7, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(27091, 90, STORE_TAB_DECORATIONS, 7, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(27866, 180, STORE_TAB_DECORATIONS, 7, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(30324, 180, STORE_TAB_DECORATIONS, 7, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(30329, 120, STORE_TAB_DECORATIONS, 7, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(30344, 120, STORE_TAB_DECORATIONS, 7, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(31331, 120, STORE_TAB_DECORATIONS, 7, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(31577, 60, STORE_TAB_DECORATIONS, 7, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(31579, 60, STORE_TAB_DECORATIONS, 7, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(31581, 60, STORE_TAB_DECORATIONS, 7, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(31583, 60, STORE_TAB_DECORATIONS, 7, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(33852, 80, STORE_TAB_DECORATIONS, 7, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(33871, 80, STORE_TAB_DECORATIONS, 7, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(34352, 120, STORE_TAB_DECORATIONS, 7, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(34354, 80, STORE_TAB_DECORATIONS, 7, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(34380, 80, STORE_TAB_DECORATIONS, 7, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(34595, 80, STORE_TAB_DECORATIONS, 7, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(34599, 80, STORE_TAB_DECORATIONS, 7, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(35441, 180, STORE_TAB_DECORATIONS, 7, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(35703, 180, STORE_TAB_DECORATIONS, 7, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(35704, 120, STORE_TAB_DECORATIONS, 7, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(35705, 90, STORE_TAB_DECORATIONS, 7, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(36961, 80, STORE_TAB_DECORATIONS, 7, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(37817, 80, STORE_TAB_DECORATIONS, 7, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(38600, 80, STORE_TAB_DECORATIONS, 7, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(39275, 90, STORE_TAB_DECORATIONS, 7, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(39279, 80, STORE_TAB_DECORATIONS, 7, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(39281, 80, STORE_TAB_DECORATIONS, 7, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(39672, 60, STORE_TAB_DECORATIONS, 7, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(39674, 80, STORE_TAB_DECORATIONS, 7, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(39842, 80, STORE_TAB_DECORATIONS, 7, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(39843, 60, STORE_TAB_DECORATIONS, 7, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(39844, 60, STORE_TAB_DECORATIONS, 7, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(40955, 60, STORE_TAB_DECORATIONS, 7, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(40957, 60, STORE_TAB_DECORATIONS, 7, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(44476, 80, STORE_TAB_DECORATIONS, 7, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(44478, 60, STORE_TAB_DECORATIONS, 7, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(44528, 60, STORE_TAB_DECORATIONS, 7, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(44530, 60, STORE_TAB_DECORATIONS, 7, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(44791, 60, STORE_TAB_DECORATIONS, 7, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(44793, 80, STORE_TAB_DECORATIONS, 7, 0, 1, nil, StoreDescriptions.furniture_default)
	-- 3 new, not listed yet

	-- festive
	GenerateStoreItem(32883, 50, STORE_TAB_DECORATIONS, 8, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(32885, 100, STORE_TAB_DECORATIONS, 8, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(32890, 180, STORE_TAB_DECORATIONS, 8, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(32894, 180, STORE_TAB_DECORATIONS, 8, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(32897, 50, STORE_TAB_DECORATIONS, 8, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(32899, 50, STORE_TAB_DECORATIONS, 8, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(32902, 50, STORE_TAB_DECORATIONS, 8, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(32903, 50, STORE_TAB_DECORATIONS, 8, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(32904, 120, STORE_TAB_DECORATIONS, 8, 0, 1, nil, StoreDescriptions.furniture_default)

	-- cushions
	GenerateStoreItem(33873, 50, STORE_TAB_DECORATIONS, 9, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(33874, 50, STORE_TAB_DECORATIONS, 9, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(33875, 50, STORE_TAB_DECORATIONS, 9, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(33876, 50, STORE_TAB_DECORATIONS, 9, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(33877, 50, STORE_TAB_DECORATIONS, 9, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(33878, 50, STORE_TAB_DECORATIONS, 9, 0, 1, nil, StoreDescriptions.furniture_default)

	-- skulls
	GenerateStoreItem(36716, 100, STORE_TAB_DECORATIONS, 10, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(33865, 100, STORE_TAB_DECORATIONS, 10, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(33866, 70, STORE_TAB_DECORATIONS, 10, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(33867, 80, STORE_TAB_DECORATIONS, 10, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(33868, 50, STORE_TAB_DECORATIONS, 10, 0, 1, nil, StoreDescriptions.furniture_default)

	-- pirate
	GenerateStoreItem(34589, 120, STORE_TAB_DECORATIONS, 11, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(34592, 120, STORE_TAB_DECORATIONS, 11, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(34601, 50, STORE_TAB_DECORATIONS, 11, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(34602, 50, STORE_TAB_DECORATIONS, 11, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(34603, 120, STORE_TAB_DECORATIONS, 11, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(34604, 50, STORE_TAB_DECORATIONS, 11, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(34607, 80, STORE_TAB_DECORATIONS, 11, 0, 1, nil, StoreDescriptions.furniture_default)

	-- kitchen (missing scripts for use/rotate)
	GenerateStoreItem(36956, 60, STORE_TAB_DECORATIONS, 12, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(36965, 80, STORE_TAB_DECORATIONS, 12, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(36938, 50, STORE_TAB_DECORATIONS, 12, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(36928, 120, STORE_TAB_DECORATIONS, 12, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(36958, 50, STORE_TAB_DECORATIONS, 12, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(36936, 50, STORE_TAB_DECORATIONS, 12, 0, 1, nil, StoreDescriptions.furniture_default)

	-- smithy (missing scripts?)
	GenerateStoreItem(37815, 120, STORE_TAB_DECORATIONS, 13, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(37834, 80, STORE_TAB_DECORATIONS, 13, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(37838, 50, STORE_TAB_DECORATIONS, 13, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(37842, 120, STORE_TAB_DECORATIONS, 13, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(37844, 60, STORE_TAB_DECORATIONS, 13, 0, 1, nil, StoreDescriptions.furniture_default)

	-- kraken (missing scripts)
	GenerateStoreItem(39847, 100, STORE_TAB_DECORATIONS, 14, 0, 1, nil, StoreDescriptions.furniture_default)

	-- zaoan (missing scripts?)
	GenerateStoreItem(40932, 60, STORE_TAB_DECORATIONS, 15, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(40949, 40, STORE_TAB_DECORATIONS, 15, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(40963, 60, STORE_TAB_DECORATIONS, 15, 0, 1, nil, StoreDescriptions.furniture_default)
	
	-- seafarer (to do)
	
	-- other (to do: get descs individually
	GenerateStoreItem(28768, 120, STORE_TAB_DECORATIONS, 17, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(28733, 250, STORE_TAB_DECORATIONS, 17, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(28737, 90, STORE_TAB_DECORATIONS, 17, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(30339, 120, STORE_TAB_DECORATIONS, 17, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(30345, 50, STORE_TAB_DECORATIONS, 17, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(30335, 100, STORE_TAB_DECORATIONS, 17, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(31586, 50, STORE_TAB_DECORATIONS, 17, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(31584, 90, STORE_TAB_DECORATIONS, 17, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(31600, 90, STORE_TAB_DECORATIONS, 17, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(31601, 120, STORE_TAB_DECORATIONS, 17, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(34339, 120, STORE_TAB_DECORATIONS, 17, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(34605, 120, STORE_TAB_DECORATIONS, 17, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(35442, 100, STORE_TAB_DECORATIONS, 17, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(36720, 120, STORE_TAB_DECORATIONS, 17, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(36718, 100, STORE_TAB_DECORATIONS, 17, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(38629, 500, STORE_TAB_DECORATIONS, 17, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(39283, 120, STORE_TAB_DECORATIONS, 17, 0, 1, nil, StoreDescriptions.furniture_default)
	GenerateStoreItem(39863, 120, STORE_TAB_DECORATIONS, 17, 0, 1, nil, StoreDescriptions.furniture_default)

-- Hirelings
	-- apprentice 150
	-- cook 900
	-- trader 150
	-- steward 250
	-- banker 250
	
	-- hireling dresses
	-- bronze 300 servant
	-- silver 500 banker, cook, steward, trader
	-- gold 900 bonelord, dragon, ferumbras, hydra
