﻿--[[

LibQuestData
by Sharlikran
https://sharlikran.github.io/

^(\d{1,4}), "(.*)"
    \[\1] = "\2",

(.*) = "(.*)" = "(.*), ",
"\2", = \{\3\,},

^"(.*)", = \{(.*)\},
    \["\1"] = \{\2 },
--]]
local lib = _G["LibQuestData"]

lib.quest_givers["fr"] = {
	   [601] = "Léon Milielle",
	   [901] = "chambellan Weller^md",
	   [906] = "duc Sébastien^md",
	  [1872] = "baron Alard Dorell^md",
	  [1953] = "sieur Edmond",
	  [2048] = "mercenaire",
	  [2089] = "général Godrun^md",
	  [2321] = "milicienne Agazu^fd",
	  [2442] = "comtesse Ilise Manteau^fd",
	  [2697] = "Michel Gette",
	  [3134] = "Guillaume Nurin",
	  [4904] = "Lothson Froidœil",
	  [4982] = "Valdam Andoren",
	  [5057] = "second Elvira Derre^fmd",
	  [5126] = "Dro-dara",
	  [5127] = "Knarstygg",
	  [5269] = "Michel Hélomaine",
	  [5298] = "capitaine Dugakh^md",
	  [5424] = "Mathias Vesture",
	  [5444] = "Janne Marolles",
	  [5697] = "Blaise Pamarc",
	  [5752] = "sœur Tabakah",
	  [5830] = "Hosni at-Tura",
	  [5837] = "Arcady Charnis",
	  [5880] = "Géron Drothan",
	  [5894] = "Adiel Charnis",
	  [5897] = "Serge Arcole",
	  [6016] = "maître Altien^md",
	  [6017] = "abbé Durak^md",
	  [6062] = "frère Alphonse",
	  [6063] = "sœur Safia",
	  [6188] = "capitaine de la garde Rama^md",
	  [6216] = "Pierre Lanier",
	  [6225] = "commandant de la garde Kurt^md",
	  [6235] = "frère Perry",
	  [6332] = "capitaine de la garde Ernard^md",
	  [6359] = "Falice Menoît",
	  [6396] = "haut-roi Émeric^md",
	  [6505] = "frère Giraud",
	  [6624] = "Tyrée Marence",
	  [6849] = "Ingride Vanne",
	  [6898] = "sieur Graham",
	  [8204] = "wyresse Shannia^fd",
	  [8250] = "reine Arzhela^fd",
	  [8959] = "Ufa la vipère rouge",
	  [9320] = "maître Muzgu^md",
	  [9479] = "sergent Stégine^md",
	 [10098] = "roi Fahara'jad^md",
	 [10099] = "Gurlak",
	 [10107] = "prince Azah^md",
	 [10165] = "Gabrielle Bénèle",
	 [10193] = "garde du trône Farvad^md",
	 [10355] = "Ramati at-Gar",
	 [10533] = "Kasal",
	 [10575] = "capitaine Rawan^md",
	 [10714] = "Rajesh",
	 [10758] = "éclaireur de la côte d'or",
	 [10884] = "Talia at-Marimah",
	 [11019] = "cadavre^fm",
	 [11315] = "Qadim",
	 [11580] = "frère Zacharie",
	 [11639] = "Hubert",
	 [11776] = "milicienne Kétrique^fd",
	 [11987] = "M'jaddha",
	 [11994] = "Phinis Vanne",
	 [12012] = "dame Sirali at-Tura",
	 [12025] = "capitaine Albert Marck^md",
   [13001] = "La prêtresse Piétine",
	 [13020] = "dame Dabienne",
	 [13123] = "Merthyval Lort",
	 [13134] = "Margot Oscent",
	 [13156] = "général Thoda^md",
	 [13318] = "duchesse Lakana^fd",
	 [13490] = "portemort",
	 [13965] = "grand seigneur de guerre Sorcalin^fmd",
	 [13982] = "Anseï Halelah^fd",
	 [13983] = "Abats",
	 [13988] = "capitaine Arésin^md",
	 [14080] = "gardienne de l'Eau^fd",
	 [14087] = "patrouilleur de Daguefilante",
	 [14090] = "capitaine Farlivère^fmd",
	 [14096] = "wyresse Hélène^fd",
	 [14098] = "Bernard Rédain",
	 [14110] = "porcher Wickton^md",
	 [14118] = "seigneur Arcady Noëllaume^md",
	 [14180] = "wyresse Jéhanne^fd",
	 [14194] = "mendiant Matthew^md",
	 [14261] = "reine Maraya^fd",
	 [14299] = "Gloria Fausta",
	 [14308] = "Guy LeBlanc",
	 [14328] = "Bumnog",
	 [14341] = "seigneur Alain Diel^md",
	 [14358] = "conjuratrice Grahla^fd",
	 [14382] = "grand prêtre Zuladr^md",
	 [14464] = "Alexia Dencent",
	 [14532] = "Erwan Castille",
	 [14580] = "Léonce Diel",
	 [14619] = "Alana Rélin",
	 [14648] = "éclaireur Hanil^md",
	 [14660] = "sieur Marley Oris",
	 [14678] = "roi Donel Deleyn^md",
	 [14708] = "wyresse Iléana^fd",
	 [14763] = "général Gautier^md",
	 [14810] = "général Mandin^fmd",
	 [14811] = "dame Éloïse Noëllaume",
	 [14869] = "commandant Marone Alès^md",
	 [14970] = "Darien Gautier",
	 [14992] = "Tamien Sellan",
	 [15015] = "wyresse Gwen^fd",
	 [15034] = "Ildani",
	 [15047] = "Harald Vaincval",
	 [15079] = "Merien Sellan",
	 [15340] = "Stibbons",
	 [15342] = "dame Clarisse Laurent",
	 [15350] = "Lort le Fossoyeur",
	 [15496] = "Jowan Hinault",
	 [15531] = "Letta",
	 [15595] = "sieur Malik Nasir",
	 [15620] = "Richard Dusant",
	 [15651] = "Adifa Dunarpents",
	 [15680] = "Shari",
	 [15705] = "wyresse Démara^fd",
	 [15843] = "sieur Lanis Shaldon",
	 [15876] = "sergent Eubella Bruhl^fmd",
	 [15877] = "Kahaba",
	 [15984] = "Odéi Philippe",
	 [16111] = "Hayazzin",
	 [16147] = "Marent Ergend",
	 [16170] = "garde du corps royale",
	 [16239] = "Anjan",
	 [16430] = "Hadoon",
	 [16507] = "Resnoît Léoncièle",
	 [16574] = "Onwyn",
	 [16579] = "Samsi af-Bazra",
	 [16601] = "Musi",
	 [16686] = "recrue Thomas^mfd",
	 [16696] = "Athel Bael",
	 [16730] = "Rahannal",
	 [16828] = "caporal Aldouin^md",
	 [16984] = "Jarrod",
	 [17131] = "héraut Kixathi^fmd",
	 [17185] = "Mazrahil le Scarabée Rusé",
	 [17262] = "Basile Fenandre",
	 [17269] = "Nemarc",
	 [17393] = "Garmeg Trouvefer",
	 [17394] = "wyresse Freyda^fd",
	 [17439] = "wyresse Rashan^fd",
	 [17482] = "Ayma",
	 [17508] = "sieur Edgard",
	 [17658] = "corbeau étrange",
	 [17832] = "Gurhul gra-Khazgur",
	 [17887] = "Yarah",
	 [18095] = "comte Vérandis Corbeguet^md",
	 [18238] = "capitaine Hjolm^md",
	 [18239] = "capitaine Llaari^fmd",
	 [18241] = "soldat du Pacte^fm",
	 [18317] = "capitaine Noris^md",
	 [18365] = "Holgunn",
	 [18366] = "Tanval Indoril",
	 [18372] = "sergent Rhorlak^md",
	 [18373] = "Furon Rii",
	 [18374] = "Reesa",
	 [18377] = "Aeridi",
	 [18378] = "Guraf Hroason",
	 [18379] = "Rorygg",
	 [18380] = "Douce-écaille",
	 [18405] = "Vartis Dareel",
	 [18427] = "Ix-Utha",
	 [18436] = "sergent Eila^fmd",
	 [18506] = "Marche-cendre",
	 [18549] = "Naryu Virian",
	 [18551] = "Varon Davel",
	 [18589] = "Svanhildr",
	 [18640] = "prêtresse Bréla^fd",
	 [18642] = "Drelden Orn",
	 [18647] = "Fendell",
	 [18661] = "Garyn Indoril",
	 [18691] = "guérisseur Sénar^md",
	 [18706] = "Idrasa",
	 [18727] = "sergent Ren^md",
	 [18759] = "Norgred Heaumedur",
	 [18764] = "Madras Tédas",
	 [18813] = "Croche-poisson",
	 [18814] = "Vara-Zeen",
	 [18819] = "Leel-Vata",
	 [18820] = "sorcier Vunal^md",
	 [18824] = "Cloya",
	 [18826] = "Onuja",
	 [18848] = "conseiller Ralden^md",
	 [18849] = "Mavos Siloreth",
	 [18870] = "sorcière Nilae^fd",
	 [18942] = "Bala",
	 [19003] = "Hrogar",
	 [19004] = "Uggonn",
	 [19030] = "Fafnyr",
	 [19057] = "Sar-Keer",
	 [19099] = "augure Bodani^fm",
	 [19148] = "Jin-Ei",
	 [19169] = "sergent Gjorring^md",
	 [19187] = "Hennus",
	 [19216] = "Nilthis",
	 [19244] = "Beron Telvanni",
	 [19257] = "Zasha-Ja",
	 [19268] = "Feldsii Maren",
	 [19272] = "Ruvali Manothrel",
	 [19279] = "Merarii Telvanni",
	 [19321] = "Azeenus",
	 [19385] = "sergent Rila Lenith^fmd",
	 [19403] = "Edrasa Drelas",
	 [19515] = "Hraelgar Brisepierre",
	 [19684] = "Ragna Cime-foudre",
	 [19705] = "disciple Sildras^md",
	 [19762] = "capitaine Diiril^md",
	 [19764] = "Senil Fenrila",
	 [19768] = "Un-Œil",
	 [19790] = "Kotholl",
	 [19796] = "sergent Hadril^md",
	 [19809] = "Neposh",
	 [19826] = "Fervyn",
	 [19843] = "maître de caravane Girano^md",
	 [19901] = "chef Suhlak^fmd",
	 [19929] = "éclaireur Kanat^md",
	 [19933] = "sergent Larthas^md",
	 [19939] = "grand maître Omin Drès^md",
	 [19941] = "Denu Faren",
	 [19947] = "vice-chanoine Hrondar^md",
	 [19958] = "vice-chanoinesse Heita-Meen^fd",
	 [19960] = "Sen Drès",
	 [19963] = "Ral Savani",
	 [20052] = "S'jash",
	 [20054] = "Bimee-Kas",
	 [20083] = "Doute-de-la-Lune",
	 [20126] = "Saryvn",
	 [20144] = "éclaireur Galsar^md",
	 [20146] = "Qa'tesh",
	 [20182] = "sphère dwemer brisée",
	 [20183] = "vice-chanoinesse Servyna^fd",
	 [20217] = "Wareem",
	 [20261] = "Kiameed",
	 [20297] = "Daeril",
	 [20342] = "Churasu",
	 [20349] = "Drillk",
	 [20369] = "Bédyni l'artificière",
	 [20373] = "vicaire Brethis^md",
	 [20374] = "guérisseuse Ravel^fd",
	 [20436] = "Jilux",
	 [20455] = "Rabeen-Ei",
	 [20475] = "Xijai-Teel",
	 [20476] = "Parash",
	 [20494] = "Padeeheï",
	 [20497] = "Gareth",
	 [20499] = "Desha",
	 [20567] = "sergent Jagyr^md",
	 [20661] = "Ordonnateur Muron",
	 [20693] = "Almalexia",
	 [20695] = "patriarche Sept-panses^md",
	 [20702] = "sergent Aamrila^fmd",
	 [20749] = "Ordonnatrice",
	 [21096] = "mage de bataille Gaston^md",
	 [21114] = "Sia",
	 [21163] = "Gai-Luron",
	 [21175] = "Chitakus",
	 [21176] = "Lodyna Arethi",
	 [21237] = "Dort-l'Œil-Ouvert",
	 [21261] = "Mousse-Silencieuse",
	 [21265] = "Cœur-Pâle",
	 [21401] = "Relnus Andalen",
	 [21402] = "Ven Andalen",
	 [21424] = "acolyte Krem^md",
	 [21425] = "Orona",
	 [21436] = "Rigurt l'effronté",
	 [21452] = "Aspéra l'oubliée",
	 [21483] = "Neeta-Li",
	 [21485] = "Kara",
	 [21540] = "frère Samel",
	 [21676] = "Elynisi Arthalen",
	 [21683] = "Esseulé^md",
	 [21758] = "Longue-Griffe",
	 [21762] = "Trouve-Vite",
	 [21851] = "Lyranth",
	 [21966] = "chercheur impérial",
	 [21980] = "prévôt Saervild Vent-d'acier^md",
	 [21987] = "prévôt Hernik^md",
	 [21993] = "Bezeer",
	 [21994] = "Jurni",
	 [22014] = "Damrina",
	 [22039] = "sylvegarde Raleetal^fd",
	 [22345] = "maîtresse de guilde Œil-Perçant^fd",
	 [22368] = "Aelif",
	 [22380] = "Naril Héléran",
	 [22388] = "Rôde-en-Secret",
	 [22411] = "Napetui",
	 [22412] = "Sejaijilax",
	 [22425] = "Kireth Vanos",
	 [22426] = "Raynor Vanos",
	 [22461] = "Shaali Kulun",
	 [22486] = "Duryn Beleran",
	 [22487] = "Erranza",
	 [22562] = "prêtresse Dilyne^fd",
	 [22775] = "Ordonnatrice Gorili^fd",
	 [22792] = "sylvegarde",
	 [22864] = "Regarde-sous-les-Cailloux",
	 [22909] = "Ganthis",
	 [23029] = "Nosaleeth",
	 [23111] = "Feyne Vildan",
	 [23205] = "archimage Valeyn^md",
	 [23215] = "Telbaril Oran",
	 [23219] = "valet des freux^md",
	 [23267] = "Aaméla Réthandus",
	 [23353] = "prévôt Nuleem-Malem^fmd",
	 [23400] = "Tah-Tehat",
	 [23455] = "prêtresse Madrana^fd",
	 [23459] = "Valastë",
	 [23460] = "archimage Shalidor^md",
	 [23503] = "Nojaxia",
	 [23511] = "Vigrod Fauche-spectre",
	 [23512] = "Engling",
	 [23528] = "capitaine Vivéka^fmd",
	 [23534] = "Dajaheel",
	 [23535] = "contremaître Gandis^md",
	 [23545] = "Jaknir",
	 [23584] = "gardien du savoir Bragur^md",
	 [23601] = "Jorunn le Roi-scalde",
	 [23604] = "reine Ayrenn^fd",
	 [23605] = "capitaine Odreth^md",
	 [23606] = "Razum-dar",
	 [23609] = "roi Kurog^md",
	 [23731] = "éclaireur Claurth^md",
	 [23747] = "centurion Gjakil^md",
	 [23748] = "Tovisa",
	 [23770] = "Hodmar",
	 [23781] = "sergent Nen^md",
	 [23829] = "Melril",
	 [23845] = "lieutenant Belron^md",
	 [23847] = "Damar",
	 [23849] = "Paldeen",
	 [23859] = "acolyte Garni^fd",
	 [24034] = "Vanus Galérion",
	 [24154] = "Maahi",
	 [24188] = "Tréva",
	 [24224] = "Netapatuu",
	 [24261] = "Hoknir",
	 [24276] = "Bura-Natoo",
	 [24277] = "capitaine Rana^fmd",
	 [24316] = "Darj le chasseur",
	 [24317] = "Rolunda",
	 [24318] = "sergent Seyne^fmd",
	 [24322] = "Molla",
	 [24333] = "Vila Theran",
	 [24369] = "Aéra Tourne-terre",
	 [24387] = "Halmaera",
	 [24761] = "Prophète^md",
	 [24895] = "Hamill",
	 [24903] = "Nolu-Azza",
	 [24905] = "Vudeelal",
	 [24959] = "Kralald",
	 [24966] = "Thulvald Cognée",
	 [24968] = "Wenaxi",
	 [24987] = "capitaine Alhana^fmd",
	 [25014] = "Fresgil",
	 [25043] = "Yraldar Lacime",
	 [25052] = "Esqoo",
	 [25053] = "Fens Lacime",
	 [25080] = "Onze-bonds",
	 [25108] = "Nelerien",
	 [25154] = "Valéric",
	 [25163] = "Hanmaer Reprisepoils",
	 [25210] = "centurion Mobareed^md",
	 [25303] = "Griffes-de-fer",
	 [25374] = "Praxin Douare",
	 [25413] = "Jorygg Mornaube",
	 [25544] = "lieutenant Koruni^fmd",
	 [25546] = "capitaine Hamar^md",
	 [25600] = "Murilam Dalen",
	 [25604] = "thane Méra Sombrage^fmd",
	 [25618] = "Jurana",
	 [25622] = "Bishalus",
	 [25663] = "reine Nurnhilde^fd",
	 [25688] = "prince Irnskar^md",
	 [25720] = "général Yéveth Noramil^md",
	 [25779] = "Ula-Reen",
	 [25781] = "Talmo",
	 [25789] = "gardien Sud-Hareem^md",
	 [25800] = "Séna Aralor",
	 [25882] = "conservateur Nicolas^md",
	 [25907] = "Hilan",
	 [25939] = "thane Harvald^md",
	 [25940] = "thane Oda Sœur-louve^fmd",
	 [26087] = "Hlotild la renarde",
	 [26090] = "acolyte Madrana^fd",
	 [26098] = "Aspéra l'amie des géants",
	 [26099] = "Dame Verte^fd",
	 [26188] = "Finvir",
	 [26217] = "Cadwell",
	 [26225] = "trameur Gwilon^md",
	 [26226] = "trameuse Endrith^fd",
	 [26314] = "Frirvid Frigeroc",
	 [26317] = "Silvenar^md",
	 [26324] = "Berj Cœurgranit",
	 [26509] = "Mathragor",
	 [26601] = "Lothgar Main-sûre",
	 [26655] = "gardien Cirion^md",
	 [26767] = "Élandora",
	 [26768] = "Salgaer",
	 [26810] = "Gakurek",
	 [26885] = "Œil-d'orage",
	 [26926] = "Selgaard Fendbûche",
	 [26955] = "garde du corps royale",
	 [26956] = "garde du corps royal",
	 [26964] = "grand prêtre Esling^md",
	 [26969] = "Marièle la Main de fer",
	 [27022] = "Ollslid",
	 [27023] = "Fjorolfa",
	 [27063] = "Jomund Nivemel",
	 [27295] = "Helgith",
	 [27323] = "frappeuse Aldewë^fd",
	 [27324] = "second Valion^md",
	 [27326] = "matelot Ambaran^md",
	 [27340] = "Nedrek",
	 [27352] = "Galithor",
	 [27354] = "Nila Belavel",
	 [27473] = "Valdur",
	 [27560] = "Séla",
	 [27605] = "sage Tirora^fd",
	 [27687] = "Hokurek",
	 [27743] = "Tervur Sadri",
	 [27744] = "Hloénor Harfang",
	 [27848] = "Aering",
	 [27926] = "éclaireur Fenrir^md",
	 [27966] = "Farandor",
	 [27971] = "Shandi",
	 [27998] = "Hallfrida",
	 [28005] = "sergent Sjarakki^fmd",
	 [28082] = "Kérig",
	 [28127] = "Enthis Hlan",
	 [28198] = "gardienne de Sylvanhenge Lara^fd",
	 [28206] = "Rudrasa",
	 [28261] = "Atirr",
	 [28281] = "capitaine Vari Martel^fmd",
	 [28283] = "Snorrvild",
	 [28331] = "âme de Finoriell^fd",
	 [28480] = "Boît-et-Chante",
	 [28490] = "Eraral-dro",
	 [28493] = "séductrice Trilvath^fd",
	 [28505] = "Béra Lamarreur",
	 [28539] = "Laen la Marcheporte",
	 [28611] = "matelot Henaril^md",
	 [28612] = "matelot Sorangarion^md",
	 [28659] = "Alphrost",
	 [28672] = "lieutenant Ehran^md",
	 [28674] = "sergent Linaarië^fmd",
	 [28693] = "sœur des inondations",
	 [28707] = "Dralof Marcheleau",
	 [28731] = "Radrase Alen",
	 [28828] = "Imwyn Givrarbre",
	 [28852] = "Élenwën",
	 [28918] = "Main-Sûre",
	 [28925] = "Télenger l'artificier",
	 [28928] = "Andewën",
	 [28930] = "haut commissaire Urcelmo^md",
	 [28941] = "prêtresse Langwë^fd",
	 [28959] = "légionnaire Artastë^fd",
	 [28974] = "Angardil",
	 [28982] = "Sonya Derniersang",
	 [28993] = "Mael",
	 [28994] = "Lliae l'Éclair",
	 [29008] = "Sirinque",
	 [29017] = "Bermund",
	 [29102] = "prince Næmon^md",
	 [29120] = "Caralith",
	 [29144] = "légionnaire Mincarionë^fd",
	 [29145] = "légionnaire Tanacar^md",
	 [29146] = "Aniastë",
	 [29168] = "caporal Brédek^md",
	 [29222] = "capitaine Tendil^md",
	 [29300] = "capitaine de la garde Astanya^fmd",
	 [29434] = "Holgunn le Borgne",
	 [29464] = "Rellus",
	 [29604] = "Joue-avec-le-feu",
	 [29678] = "Tabil",
	 [29782] = "Hanilan",
	 [29791] = "enquêteur Irnand^md",
	 [29844] = "scalde Jakaral^md",
	 [29886] = "capitaine Henyon^md",
	 [29901] = "Daljari Demi-troll",
	 [29914] = "Earos",
	 [29915] = "Curime",
	 [30018] = "Widulf",
	 [30026] = "Sarisa Rothalen",
	 [30061] = "Vélatossë",
	 [30069] = "Aninwë",
	 [30103] = "Iroda",
	 [30138] = "Elfe Noir",
	 [30164] = "Éminelya",
	 [30178] = "Runehild",
	 [30179] = "Logod",
	 [30183] = "Yngvar",
	 [30200] = "Hauting",
	 [30201] = "Korra",
	 [30202] = "sage Svari^fd",
	 [30300] = "Mérormo",
	 [30307] = "Lamolime",
	 [30408] = "Eirfa",
	 [30431] = "Svein",
	 [30896] = "thane sylvestre Dailithil^fmd",
	 [30932] = "Halino",
	 [30933] = "Ocanim",
	 [31026] = "Hekvid",
	 [31223] = "capitaine Khammo^md",
	 [31326] = "Anganirne",
	 [31327] = "Ceborn",
	 [31344] = "sergent Jorald^md",
	 [31388] = "Tharuin la Mélancolique",
	 [31416] = "Mareki",
	 [31421] = "Théofa",
	 [31429] = "éclaireur Arfanel^md",
	 [31444] = "éclaireuse Endetuilë^fd",
	 [31575] = "gardien Heldil^md",
	 [31639] = "aldarque Colaste^fd",
	 [31746] = "défenseur Deux-Lames",
	 [31808] = "Gorgath Œil-de-lynx",
	 [31837] = "capitaine Erronfaire^fmd",
	 [31902] = "Amitra",
	 [31964] = "Borald",
	 [31967] = "Malana",
	 [31977] = "monastique Nénaron^md",
	 [32013] = "Mizrali",
	 [32068] = "Parmitilir",
	 [32071] = "Nilwën",
	 [32098] = "Solvar",
	 [32099] = "capitaine Attiring^fmd",
	 [32114] = "Odunn Gris-ciel",
	 [32172] = "Peruin",
	 [32225] = "Rolancano",
	 [32270] = "Gilien",
	 [32285] = "Fasundil",
	 [32298] = "Endarastë",
	 [32348] = "Cariël",
	 [32356] = "lieutenant Rarili^fmd",
	 [32387] = "Baham",
	 [32388] = "Brea Glisseneige",
	 [32394] = "Thragof",
	 [32495] = "Octin Murric",
	 [32496] = "Marayna Murric",
	 [32506] = "Palomir",
	 [32507] = "recrue Gorak^mfd",
	 [32532] = "Jurak-dar",
	 [32535] = "Bakkhara",
	 [32555] = "Parle-en-Lumières",
	 [32620] = "Creuse-Profond",
	 [32631] = "instructrice Ninla^fd",
	 [32643] = "capitaine Cirenwë^fmd",
	 [32649] = "Télonil",
	 [32654] = "Lérisa l'astucieuse",
	 [32703] = "Alandarë",
	 [32859] = "lieutenant Gustave^md",
	 [32861] = "lieutenant Adeline^fmd",
	 [32863] = "capitaine Gwyssa^fmd",
	 [32904] = "Oraneth",
	 [32946] = "capitaine Un-Œil^fmd",
	 [33007] = "Henilien",
	 [33013] = "Rondor",
	 [33017] = "Observateur^md",
	 [33085] = "capitaine Landarë^fmd",
	 [33088] = "Arelmo",
	 [33089] = "sergent Artinairë^fmd",
	 [33179] = "dame Élanwë",
	 [33559] = "Lisondor",
	 [33696] = "projection de Kireth Vanos",
	 [33806] = "Glanir",
	 [33868] = "sylvegarde Xohaneel^fd",
	 [33896] = "Grunyun le Sordide",
	 [33938] = "Péras",
	 [33961] = "fragment d'Alanwë^fmd",
	 [33997] = "seigneur Gharesh-ri^md",
	 [34268] = "Trélan",
	 [34307] = "Lugharz",
	 [34308] = "Janese Lurgette",
	 [34346] = "Suriel",
	 [34393] = "Teegya",
	 [34394] = "Sarodor",
	 [34397] = "Gahotar",
	 [34431] = "Sirdor",
	 [34438] = "éclaireuse Aldanya^fd",
	 [34504] = "Skordo le surin",
	 [34565] = "Gwilir",
	 [34566] = "Moramat",
	 [34568] = "chaman Bogham^md",
	 [34623] = "capitaine Jimila^fmd",
	 [34646] = "lieutenant Kazargi^fmd",
	 [34733] = "Faraniël",
	 [34755] = "Tzik'nith",
	 [34817] = "Eryarion",
	 [34822] = "Nondor",
	 [34823] = "Khezuli",
	 [34824] = "Laranalda",
	 [34928] = "Ancalin",
	 [34975] = "Firtoril",
	 [34976] = "Tandarë",
	 [34984] = "Neetra",
	 [34994] = "Alanwë",
	 [35004] = "Egranor",
	 [35073] = "Ordonnateur Areth^md",
	 [35257] = "Sylvian Hérius",
	 [35305] = "Azum",
	 [35427] = "Endarwe",
	 [35432] = "Dulini",
	 [35492] = "Vyctoria Girien",
	 [35510] = "milicien Charlic^md",
	 [35859] = "Néramo",
	 [35873] = "Dugroth",
	 [35897] = "Tharayya",
	 [35918] = "acolyte Eldri^fd",
	 [36093] = "capitaine Linwën^fmd",
	 [36102] = "Englor",
	 [36113] = "Pirondil",
	 [36115] = "Khali",
	 [36116] = "Shazah",
	 [36119] = "Engor",
	 [36129] = "Aniël",
	 [36187] = "sentinelle Bériel^mf",
	 [36188] = "sentinelle Rechiche^mfd",
	 [36280] = "Decius",
	 [36290] = "Sigunn",
	 [36294] = "Medveig",
	 [36295] = "Helfhild",
	 [36356] = "Azlakha",
	 [36584] = "chaman Glazulg^md",
	 [36598] = "capitaine Kaleen^fmd",
	 [36599] = "Jakarn",
	 [36611] = "fille d'écurie",
	 [36632] = "Tevynni Hédran",
	 [36654] = "Jilan-dar",
	 [36913] = "Liane",
	 [36916] = "Lambur",
	 [36971] = "Iriën",
	 [36985] = "apprenti Savur^md",
	 [37058] = "Rozag gro-Khazun",
	 [37059] = "Frédérique Lynielle",
	 [37096] = "Talres Voren",
	 [37181] = "caporal Anerël^fmd",
	 [37391] = "Andrilion",
	 [37396] = "Nicolène",
	 [37461] = "chef Tazgol^md",
	 [37534] = "Laganakh",
	 [37593] = "Yeux-voilés",
	 [37595] = "Ezzag",
	 [37596] = "Kalari",
	 [37727] = "éclaireuse Mengaër^fd",
	 [37900] = "Hlénir Rédoran",
	 [37976] = "centurion Burri^fmd",
	 [37978] = "préfet Antias^fmd",
	 [37985] = "Tazia",
	 [37986] = "Calircarya",
	 [37987] = "Berdonion",
	 [37988] = "Ghadar",
	 [37996] = "Gugnir",
	 [38032] = "Malfanir",
	 [38043] = "Shazim",
	 [38047] = "Ufgra gra-Gum",
	 [38057] = "Daine",
	 [38077] = "Siraj",
	 [38093] = "lieutenant Clarice^fmd",
	 [38116] = "sergent Muzbar^md",
	 [38181] = "Nilaendril",
	 [38182] = "sergent Dagla^fmd",
	 [38201] = "Matys Dérone",
	 [38217] = "Ongalion",
	 [38251] = "Gruluk gro-Khazun",
	 [38269] = "Mâche-sa-queue",
	 [38302] = "duc Nathaniel^md",
	 [38303] = "Aemilia Hadrianus",
	 [38329] = "Ozozur",
	 [38346] = "sieur Hugues",
	 [38373] = "Zal-sa",
	 [38407] = "Bataba",
	 [38413] = "haut commissaire Alduril^fmd",
	 [38494] = "Suronii",
	 [38498] = "Azahrr",
	 [38532] = "Mezha-dro",
	 [38649] = "Indaenir",
	 [38650] = "Bodring",
	 [38852] = "Magula",
	 [38856] = "sergent Irinwën^fmd",
	 [38863] = "sergent Farya^fmd",
	 [38969] = "épiscope lunaire Hunal^md",
	 [38974] = "Marius",
	 [38979] = "Erranenen",
	 [38984] = "Angwë",
	 [38996] = "Gordag",
	 [39037] = "Hjorik",
	 [39166] = "Zahra",
	 [39189] = "Ehtayah",
	 [39191] = "Félari",
	 [39202] = "Rémy Bérard",
	 [39330] = "épouse chasseresse Lurgush^fd",
	 [39336] = "Grigerda",
	 [39459] = "Benduin",
	 [39465] = "Orthenir",
	 [39475] = "Yanaril",
	 [39483] = "thane sylvestre Fariël^fmd",
	 [39505] = "thane sylvestre Niriël^fmd",
	 [39542] = "Zadala",
	 [39562] = "Fongoth",
	 [39579] = "Nara",
	 [39613] = "Hazazi",
	 [39623] = "Ofglog gro-Mordécorce",
	 [39706] = "éclaireur Traqueneige",
	 [39729] = "Ukatsei",
	 [39771] = "Uggissar",
	 [39774] = "Hojard",
	 [39782] = "Tom le Faux-jeton",
	 [39790] = "Garnikh",
	 [39954] = "capitaine des veilleurs Zafira^fmd",
	 [40105] = "Sind",
	 [40118] = "Halindor",
	 [40119] = "thane sylvestre Bowenas^fmd",
	 [40266] = "Dulan",
	 [40375] = "Gouvernante^fd",
	 [40395] = "Bunul",
	 [40554] = "Khaba",
	 [40577] = "Heluïn",
	 [40578] = "Mel Adrys",
	 [40684] = "sergent Firion^fmd",
	 [40712] = "Armin",
	 [40755] = "Leono Draconis",
	 [40849] = "Gathwën",
	 [40903] = "Gadris",
	 [41027] = "Sylvain Quintin",
	 [41044] = "Anglorn",
	 [41091] = "éclaireur Ruluril^md",
	 [41115] = "Shatasha",
	 [41116] = "Rasha",
	 [41160] = "Zaeri",
	 [41191] = "Kazirra",
	 [41205] = "Balag",
	 [41207] = "Feluni",
	 [41233] = "Rathisa l'Éventreur",
	 [41235] = "Thorinor",
	 [41385] = "Zulana",
	 [41387] = "Estinan",
	 [41389] = "Cartirinque",
	 [41397] = "Tertius Falto",
	 [41418] = "Gungrim",
	 [41425] = "trameuse Benieth^fd",
	 [41480] = "Mansa",
	 [41506] = "Saldir",
	 [41511] = "Edheldor",
	 [41547] = "Éliana Salvius",
	 [41549] = "Talania Priscus",
	 [41560] = "Marimah",
	 [41634] = "Malkur Valos",
	 [41644] = "Apphia Matia",
	 [41788] = "trameur Maruin^md",
	 [41887] = "Juranda-ra",
	 [41890] = "Cendrequeue",
	 [41928] = "Yahyif",
	 [41929] = "Eneriëll",
	 [41934] = "Azbi-ra",
	 [41947] = "prêtresse Sendël^fd",
	 [42130] = "officier Lorin^fmd",
	 [42297] = "Arcarin",
	 [42332] = "Zan",
	 [42346] = "singe curieux",
	 [42461] = "Fabanil",
	 [42500] = "Kauzanabi-jo",
	 [42520] = "Krodak",
	 [42555] = "Darius",
	 [42576] = "Olvyia Indaram",
	 [42577] = "Peau-Miroir",
	 [42578] = "Adalmor",
	 [42579] = "Véronard Liancourt",
	 [42584] = "Bugbesh",
	 [42922] = "sorcier Carindon^md",
	 [42928] = "Jagnas",
	 [42929] = "capitaine Sarandil^md",
	 [43049] = "Melrethël",
	 [43094] = "Hadam-do",
	 [43163] = "major Cirenwë^fmd",
	 [43242] = "bosco Ostéos^md",
	 [43247] = "Ragalvir",
	 [43321] = "Dralnas Moryon",
	 [43334] = "Galbenël",
	 [43360] = "Kanniz",
	 [43401] = "Jéromec Lemal",
	 [43519] = "Roi-Nature^md",
	 [43622] = "Reine-Nature^fd",
	 [43657] = "disciple de Léki",
	 [43719] = "Firiliril",
	 [43782] = "Fatahala",
	 [43839] = "Anoure",
	 [43942] = "Meriq",
	 [43948] = "Aqabi de l'Impie",
	 [44036] = "Mordra la puissante",
	 [44059] = "officier Parwinël^fmd",
	 [44100] = "Uhrih",
	 [44127] = "Thonoras",
	 [44153] = "Dringoth",
	 [44280] = "projection de Vanus Galérion",
	 [44283] = "Rollin",
	 [44302] = "Gilraën",
	 [44485] = "Élaldor",
	 [44502] = "Sorderion",
	 [44625] = "Lataryon",
	 [44665] = "Nellor",
	 [44679] = "Haras",
	 [44697] = "Laurosse",
	 [44707] = "Erinël",
	 [44709] = "Égannor",
	 [44731] = "Dinwenël",
	 [44741] = "Taraline",
	 [44855] = "Œil-Froid",
	 [44856] = "Kunira-daro",
	 [44861] = "Marisette",
	 [44864] = "Sumiril",
	 [44894] = "Cinnar",
	 [44899] = "Nivrilin",
	 [45170] = "Gamirth",
	 [45200] = "Thalara",
	 [45458] = "Alandis",
	 [45475] = "Galsi Mavani",
	 [45641] = "Aurorelle Varin",
	 [45645] = "Gasteau Chamrond",
	 [45688] = "Adamir",
	 [45723] = "Wilminn",
	 [45725] = "Zimar",
	 [45744] = "soldat Alque^fmd",
	 [45745] = "soldat Cularalda^fmd",
	 [45757] = "Narion",
	 [45759] = "Ledronor",
	 [45845] = "Radreth",
	 [45909] = "Glaras",
	 [45953] = "Eringor",
	 [46174] = "Anenya",
	 [46204] = "Curinure",
	 [46241] = "Aicessar",
	 [46323] = "Zaddo",
	 [46439] = "Valarril",
	 [46520] = "Adusa-daro",
	 [46595] = "Daribert Hurier",
	 [46655] = "Ancalmo",
	 [46700] = "Fingaenion",
	 [47088] = "Gluineth",
	 [47445] = "lieutenant Sgugh^fmd",
	 [47472] = "soldat Garion^fmd",
	 [47473] = "capitaine Elonthor^md",
	 [47631] = "Gwendis",
	 [47667] = "Sebazi",
	 [47677] = "Zaag",
	 [47685] = "Arkas",
	 [47686] = "Ikran",
	 [47754] = "Jean-Jacques Alois",
	 [47765] = "Rafora Casca",
	 [47770] = "Enda",
	 [47854] = "lieutenant Ergend^md",
	 [47924] = "Llotha Nelvani",
	 [48009] = "Brelor",
	 [48092] = "Gahgdar",
	 [48116] = "Githiril",
	 [48295] = "sergent Antieve^md",
	 [48567] = "capitaine Eugien Kermétaye^md",
	 [48570] = "Bistrand Giroux",
	 [48573] = "wyresse Delphique^fd",
	 [48660] = "Enthoras",
	 [48891] = "Teeba-Ja",
	 [48893] = "grand Ordonnateur Danys^md",
	 [48916] = "Sabonn",
	 [48996] = "Fol-Œil",
	 [49030] = "Forinor",
	 [49180] = "Nathalye Ervine",
	 [49189] = "Alvaren Garoutte",
	 [49284] = "wyresse Linnae^fd",
	 [49349] = "Mizahabi",
	 [49408] = "Beryn",
	 [49410] = "roi Camoran Aeradan^md",
	 [49432] = "Mendil",
	 [49482] = "Orthelos",
	 [49534] = "Herminius Sophus",
	 [49608] = "Archimbert Dantaine",
	 [49624] = "Maenlin",
	 [49646] = "Lashgikh",
	 [49669] = "Aucun",
	 [49698] = "Cirmo",
	 [49708] = "Adainurr",
	 [49709] = "Meleras",
	 [49743] = "Najan",
	 [49778] = "gardien du panthéon",
	 [49863] = "Thoreki",
	 [49898] = "érudit Cantier^md",
	 [49926] = "Gerweruin",
	 [49955] = "fine-lame Qariar^mfd",
	 [49958] = "Glothoriën",
	 [49985] = "Sarandël",
	 [50037] = "Vorundil",
	 [50091] = "Eminairë",
	 [50141] = "Caesonia",
	 [50228] = "Turshan-dar",
	 [50233] = "capitaine Wardush^md",
	 [50237] = "capitaine Gemelle^fmd",
	 [50416] = "Semusa",
	 [50525] = "Afwa",
	 [50550] = "Kailstig la Hache",
	 [50639] = "squelette",
	 [50684] = "Longue-Ombre",
	 [50765] = "Turuk Rougegriffes",
	 [50990] = "Angamar",
	 [51086] = "Malma",
	 [51088] = "Brendar",
	 [51134] = "Israk Blanche-tempête",
	 [51310] = "capitaine Thayer^fmd",
	 [51397] = "Titus Valerius",
	 [51461] = "Fédéric Seychelle",
	 [51615] = "Sadaifa",
	 [51842] = "Vaerarre",
	 [51901] = "Voleuse^fd",
	 [51963] = "héraut des Astromanciens",
	 [52071] = "Érold",
	 [52096] = "Dathlyn",
	 [52103] = "Caalorne",
	 [52105] = "Hjagir",
	 [52118] = "Voit-les-Embranchements",
	 [52166] = "Shuldrashi",
	 [52169] = "Arethil",
	 [52181] = "Parquier Gimbert",
	 [52291] = "sergent Oorga^fmd",
	 [52731] = "gardien Creux",
	 [52741] = "Genthël",
	 [52751] = "Firtorël",
	 [52752] = "roi Laloriaran Dynar^md",
	 [52753] = "Aérona Bérendas",
	 [52929] = "monastique Tanaamë^fd",
	 [52930] = "monastique Firinorë^fd",
	 [52931] = "Nilynë Hlor",
	 [53979] = "gardien Cirdur^md",
	 [53980] = "Aldunië",
	 [53983] = "Hartmin",
	 [54043] = "Gorvyn Dran",
	 [54049] = "Greban",
	 [54154] = "Umbarilë",
	 [54228] = "Nazdura",
	 [54410] = "Fada at-Glina",
	 [54577] = "recrue Maëlle^fd",
	 [54580] = "Ibrula",
	 [54848] = "messagère royale",
	 [55120] = "caporal Adel^md",
	 [55125] = "Lodiss",
	 [55221] = "Ralai",
	 [55270] = "Combat-avec-la-Queue",
	 [55351] = "Sara Bénèle",
	 [55378] = "Nhalan",
	 [56177] = "astromancienne Nudryn^fd",
	 [56248] = "Mordra la puissante",
	 [56459] = "Mihayya",
	 [56501] = "Safa al-Satakalaam",
	 [56503] = "Feuilles-au-Vent",
	 [56504] = "Cingleronce Brise-dents",
	 [56513] = "capitaine Trémouille^md",
	 [56525] = "Riurik",
	 [56701] = "Thalinfar",
	 [57474] = "régente Cassipia^fd",
	 [57577] = "Nendirumë",
	 [57649] = "Petite Feuille",
	 [57850] = "Atildel",
	 [58495] = "croisé Dalamar^md",
	 [58640] = "Médéric Vyger",
	 [58826] = "Maj al-Ragath",
	 [58841] = "Glirion Barbe-Rousse",
	 [58889] = "Millenith",
	 [59027] = "Céleste Guerrier^md",
	 [59046] = "Danel Telleno",
	 [59335] = "Orgotha",
	 [59362] = "Fedar Githrano",
	 [59388] = "Glurbasha",
	 [59604] = "Cinosarion",
	 [59685] = "mère forgeronne Alga^fd",
	 [59780] = "Dirdre",
	 [59840] = "épouse forgeronne Kharza^fd",
	 [59873] = "archiviste Murboga^fd",
	 [59900] = "Rogzesh",
	 [59908] = "Laurig",
	 [59963] = "chef Bazrag^md",
	 [60187] = "sœur Terran Arminus^fd",
	 [60285] = "Adara'haï",
	 [64703] = "Mazgroth",
	 [64741] = "épouse de bouclier Razbela^fd",
	 [64769] = "Lazghal",
	 [64805] = "Eveli Flèche-vive",
	 [64864] = "Meram Farr",
	 [64891] = "seigneur Ethian",
	 [65199] = "Fa-Nuit-Hen",
	 [65239] = "Talviah Aliaria",
	 [65270] = "Brulak",
	 [65296] = "Nashruth",
	 [65444] = "Lozruth",
	 [65634] = "Orzorga",
	 [65717] = "Zabani",
	 [65736] = "Mulzah",
	 [65951] = "curatrice Umutha^fd",
	 [66284] = "Kyrtos",
	 [66293] = "Youss",
	 [66310] = "Dagarha",
	 [66412] = "Nammadin",
	 [66701] = "Doranar",
	 [66830] = "chef Urgdosh^md",
	 [66840] = "Eshir",
	 [66846] = "Zinadia",
	 [67016] = "Borfree l'Émoussé",
	 [67018] = "Arzorag",
	 [67019] = "Guruzug",
	 [67033] = "Drudun",
	 [67826] = "Grazda",
	 [67828] = "Astara Caerellius",
	 [67843] = "Langue noire Terenus^mfd",
	 [68132] = "Zéira",
	 [68328] = "Quen",
	 [68594] = "Shalug le Requin",
	 [68654] = "Rohefa",
	 [68688] = "Bakhum",
	 [68825] = "Thrag",
	 [68884] = "Stuga",
	 [69048] = "Andarri",
	 [69081] = "Sabileh",
	 [69142] = "Lund",
	 [69854] = "Spencer Rye",
	 [70383] = "Quen",
	 [70459] = "Elam Drals",
	 [70472] = "Nevusa",
	 [72001] = "Amélie Crowe",
    -- Shar Morrowind
    -- Shar Crown Store
    -- Shar Misc
    -- Shar Elsweyr
    -- Shar Skyrim
	 [90000] = "Le lieutenant Korleva",
    -- Summerset
	 [91008] = "La matriarche Helenaerë",
    -- Clockwork City
    -- New auto created
    [100001] = "Moon-Bishop Azin-jo",
    [100072] = "Gwingeval",
    [100073] = "Quintia Rullus",
    [100085] = "Le légat Gallus",
    [100095] = "Sœur J'Reeza",
    [100112] = "Le haut commissaire Tanerline",
    [100120] = "La justiciar Farowël",
    [100123] = "le justiciar Tanorian",
    [100140] = "Grimpe-de-Rire",
    -- Skyrim
    [200001] = "Le prêtre Isonir",
    [200004] = "La thane-épée Jylta",
    [200006] = "Hidaver",
    [200009] = "Fenrar",
    [200010] = "Alfgar",
    [200011] = "Alwyn",
    [200014] = "La poupée Heiruna",
    [200015] = "Jolfr",
    [200018] = "Le surveillant Urlvar",
    [200021] = "Relmerea Sethandus",
    [200022] = "Svana",
    [200030] = "Leiborn",
    [200046] = "Aerolf",
    -- Existing
	[500000] = "Sarcophage ayléide",
	[500001] = "Heist Board",
	[500002] = "Reacquisition Board",
	[500003] = "Tharayya's Journal, Entry 10",
	[500004] = "Tharayya's Journal, Entry 2",
	[500005] = "Promissory Note",
	[500006] = "La lettre à Tavo",
	[500007] = "Letter to Fadeel",
	[500008] = "Altmeri Relic",
	[500009] = "Commandes d'équipement artisanal",
	[500010] = "Commandes de consommables artisanaux",
	[500011] = "Journal ensanglanté",
	[500012] = "Mages Guild Handbill",
	[500013] = "Folded Note",
	[500014] = "Shipping Manifest",
	[500015] = "Doctor's Bag",
	[500016] = "Crate",
	[500017] = "Letter",
	[500018] = "Wet Bag",
	[500019] = "Notebook",
	[500020] = "Message to Jena",
	[500021] = "Weathered Notes",
	[500022] = "Letter to Belya",
	[500023] = "Crate",
	[500024] = "Note",
	[500025] = "Journal Page",
	[500026] = "Letter from Historian Maaga",
	[500027] = "Invitation À l'enclave des Indomptables",
	[500028] = "Orders from Knight-Commander Varaine",
	[500029] = "Pelorrah's Research Notes",
	[500030] = "Contrat de livraison",
	[500031] = "A Dire Warning",
	[500032] = "Bandit Note",
	[500033] = "Feu de camp",
	[500034] = "Urne daedrique",
	[500035] = "Pendentif",
	[500036] = "Sac abandonné",
	[500037] = "Message rédigé en hâte",
	[500038] = "Le luth d'Idria",
	[500039] = "Le journal de Nettira",
	[500040] = "Winterborn's Note",
	[500041] = "The Gray Passage",
	[500042] = "Orrery",
	[500043] = "Centurion Control Lexicon",
	[500044] = "Unusual Stone Carving",
	[500045] = "Troll Socialization Research Notes",
	[500046] = "Note griffonnée à la hâte",
	[500047] = "Fighters Guild Handbill",
	[500048] = "Bandit Note",
	[500049] = "Bouclier mal en point",
	[500050] = "Risa's Journal",
	[500051] = "A Fair Warning",
	[500052] = "Pierre parlante",
	[500053] = "Dusty Scroll",
	[500054] = "Burial Urn",
	[500055] = "Advertisement",
	[500056] = "Ancient Nord Burial Jar",
	[500057] = "Tomb Urn",
	[500058] = "Handre's Last Will",
	[500059] = "Tonneau suspect",
	[500060] = "Ordres de l'éclaireur",
	[500061] = "Note des Freux écarlates",
	[500062] = "Guifford Vinielle's Sketchbook",
	[500063] = "Bandit's Journal",
	[500064] = "Runensteinfragment",
	[500065] = "Torn Letter",
	[500066] = "Nimriell's Research",
	[500067] = "Azura Shrine",
	[500068] = "L'Arc de Storgh",
	[500069] = "Mercano's Journal",
	[500070] = "Backpack",
	[500071] = "Nadafa's Journal",
	[500072] = "Strange Sapling",
	[500073] = "Scouting Board",
	[500074] = "Vase bosmer",
	[500075] = "Le Journal d'un prêtre Z'en",
	[500076] = "Journal humide",
	[500077] = "L’éventail de pierres de Moranda",
	[500078] = "Le Journal de Graccus vol. 2",
	[500079] = "Instrument poussiéreux",
	[500080] = "Make the Wilds Safer, Earn Gold",
	[500081] = "Yenadar's Journal",
	[500082] = "Suspicious Bottle",
	[500083] = "Parchemin antique",
	[500084] = "Klaandor's Journal",
	[500085] = "Nedras' Journal",
	[500086] = "Ancient Sword",
	[500087] = "Épée",
	[500088] = "Le temple de Sul",
	[500089] = "Étrange appareil",
	[500090] = "La mise en garde",
	[500091] = "Plans d'attaque",
	[500092] = "Coffre usé par les intempéries",
	[500093] = "Cursed Skull",
	[500094] = "Last Will and Testament of Frodibert Fontbonne",
	[500095] = "Stolen Goods",
	[500096] = "Coffre déterré",
	[500097] = "Frostheart Blossom",
	[500098] = "Ceremonial Scroll",
	[500099] = "Ancient Scroll",
	[500100] = "Amulette du Pacte",
	[500101] = "Offer of Amnesty",
	[500102] = "Agolas's Journal",
	[500103] = "Old Pack",
	[500104] = "To the Hero of Wrothgar!",
	[500105] = "House of Orsimer Glories",
	[500106] = "Note from Velsa",
	[500107] = "Tip Board",
	[500108] = "Note from Quen",
	[500109] = "Note from Zeira",
	[500110] = "Note from Walks-Softly",
	[500111] = "Message from Walks-Softly",
	[500112] = "Message from Velsa",
	[500113] = "Guilde des voleurs",
	[500114] = "Guilde des mages",
	[500115] = "Guilde des guerriers",
	[500116] = "Indomptable",
	[500117] = "chapeau de Julianos",
	[500118] = "panneau des primes",
	[500119] = "Confrérie noire",
	[500120] = "Destinés à mourir",
	[500121] = "Note from Astara",
	[500122] = "Note from Kor",
	[500123] = "Note d'Azara",
}
