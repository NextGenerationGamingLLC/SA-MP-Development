#include <YSI\y_hooks>

hook OnGameModeInit() {
	
	print("[Streamer] Loading Dynamic Objects...");

	//CrateLoad = CreateDynamicObject(964,-2114.1, -1723.5, 11984.5, 0, 0, 337.994, .worldid = 0, .interiorid = 1, .streamdistance = 200); //object(cj_metal_crate) (1)
	CrateLoad = CreateDynamicObject(964, -2136.05, -1573.24, 3550.00,0.00000000,0.00000000,180.00000000, .worldid = 0, .interiorid = 1, .streamdistance = 200); //object(cj_metal_crate) (1)

	new VIPLogo = CreateDynamicObject(19353, 1803.89, -1593.99, 14.05,   0.00, 0.00, 312.26);
	SetDynamicObjectMaterialText(VIPLogo, 0, "{842787}VIP LOUNGE", 90, "Impact", 56, 1, 0xFFFFFFFF, 0, 1);

	new FCTS = CreateDynamicObject(19482, -58.9155, -1118.4808, 7.4781, 0.0000, 0.0000, 160.3858);
	SetDynamicObjectMaterialText(FCTS, 0, "{880000}Flint County Towing Services", 110, "Impact", 40, 1, 0xFF000000, 0, 1);
	//new TR = CreateDynamicObject(19482, -2328.9254, 2313.8192, 16.7774, 0.0000, 0.0000, 90.0);
	//SetDynamicObjectMaterialText(TR, 0, "The People's Plaza", 70, "Georgia", 24, 1, 0xFFFFFFFF, 0, 1);
	
    /* (ongamemodeinit) - LSPD stuff */
	eastlobby1 = CreateDynamicObject(1536,253.14941406,110.59960938,1002.21502686,0.00000000,0.00000000,270.00000000,-1,10,-1,100.0); // East lobby door (moves north)
	eastlobby2 = CreateDynamicObject(1536,253.18457031,107.59960938,1002.21502686,0.00000000,0.00000000,90.00000000,-1,10,-1,100.0); // East lobby door (moves south)
	westlobby1 = CreateDynamicObject(1536,239.71582031,116.09179688,1002.21502686,0.00000000,0.00000000,90.00000000,-1,10,-1,100.0); // West lobby door (moves north)
	westlobby2 = CreateDynamicObject(1536,239.67968750,119.09960938,1002.21502686,0.00000000,0.00000000,269.98901367,-1,10,-1,100.0); // West lobby door (moves south)
	locker1 = CreateDynamicObject(1536,267.29980469,112.56640625,1003.61718750,0.00000000,0.00000000,179.99450684,-1,10,-1,100.0); // Locker door (moves east)
	locker2 = CreateDynamicObject(1536,264.29980469,112.52929688,1003.61718750,0.00000000,0.00000000,0.00000000,-1,10,-1,100.0); // Locker door (moves west)
	cctv1 = CreateDynamicObject(1536,264.44921875,115.79980469,1003.61718750,0.00000000,0.00000000,0.00000000,-1,10,-1,100.0); // CCTV door (moves west)
	cctv2 = CreateDynamicObject(1536,267.46875000,115.83691406,1003.61718750,0.00000000,0.00000000,179.99450684,-1,10,-1,100.0); // CCTV door (moves east)
	chief1 = CreateDynamicObject(1536,229.59960938,119.50000000,1009.21875000,0.00000000,0.00000000,0.00000000,-1,10,-1,100.0); // innermost chief's door
	chief2 = CreateDynamicObject(1536,232.59960938,119.53515625,1009.21875000,0.00000000,0.00000000,179.99450684,-1,10,-1,100.0); // outermost chief's door (both move west)

	/* Noose Int Buttons End */
	sasd1A = CreateDynamicObject(1536,2511.65332031,-1697.00976562,561.79223633,0.00000000,0.00000000,0.00000000); //R6
	sasd1B = CreateDynamicObject(1536,2514.67211914,-1696.97485352,561.79223633,0.00000000,0.00000000,180.00000000); //object(gen_doorext15) (2)
 	sasd2A = CreateDynamicObject(1536,2516.87548828,-1697.01525879,561.79223633,0.00000000,0.00000000,0.00000000); //R5
	sasd2B = CreateDynamicObject(1536,2519.89257812,-1696.97509766,561.79223633,0.00000000,0.00000000,179.99450684); //object(gen_doorext15) (4)
	sasd3A = CreateDynamicObject(1536,2522.15600586,-1697.01550293,561.79223633,0.00000000,0.00000000,0.00000000); //R4
	sasd3B = CreateDynamicObject(1536,2525.15893555,-1696.98010254,561.79223633,0.00000000,0.00000000,179.99450684); //object(gen_doorext15) (6)
	sasd4A = CreateDynamicObject(1536,2511.84130859,-1660.08081055,561.79528809,0.00000000,0.00000000,0.00000000); //West
	sasd4B = CreateDynamicObject(1536,2514.81982422,-1660.04650879,561.80004883,0.00000000,0.00000000,180.00000000); //object(gen_doorext15) (1)
	sasd5A = CreateDynamicObject(1536,2522.86059570,-1660.07177734,561.80206299,0.00000000,0.00000000,179.99450684); //East
	sasd5B = CreateDynamicObject(1536,2519.84228516,-1660.10888672,561.80004883,0.00000000,0.00000000,0.00000000); //object(gen_doorext15) (1)

	lspddoor1 = CreateDynamicObject(1569, 246.35150146484, 72.547714233398, 1002.640625, 0.000000, 0.000000, 0.000000); //
	lspddoor2 = CreateDynamicObject(1569, 245.03300476074, 72.568511962891, 1002.640625, 0.000000, 0.000000, 0.000000); //

	/* SAAS CARRIER */
	/*sidelift = CreateDynamicObject(3114, 231.916656, 3615.134277, 17.269205, 0.0000, 0.0000, 0.0000); // Side Lift Up
	backhatch = CreateDynamicObject(3113, 180.344864, 3600.390137, 2.516232, 0.0000, 0.0000, 0.0000); // Back Hatch Closed
	backlift = CreateDynamicObject(3115, 189.694626, 3599.983398, 17.483730, 0.0000, 0.0000, 0.0000); // Back Lift Up

	Carrier[0] = CreateDynamicObject(10771, 288.665771, 3600.003418, 6.032381, 0.0000, 0.0000, 0.0000);
	Carrier[1] = CreateDynamicObject(11145, 225.782196, 3600.015137, 4.754915, 0.0000, 0.0000, 0.0000);
	Carrier[2] = CreateDynamicObject(11149, 282.526093, 3594.805176, 12.487646, 0.0000, 0.0000, 0.0000);
	Carrier[3] = CreateDynamicObject(11146, 279.620544, 3600.541016, 12.893089, 0.0000, 0.0000, 0.0000);
	Carrier[4] = CreateDynamicObject(10770, 291.858917, 3592.397949, 39.171509, 0.0000, 0.0000, 0.0000);
	Carrier[5] = CreateDynamicObject(10772, 290.014313, 3599.787598, 17.833616, 0.0000, 0.0000, 0.0000);
	Carrier[6] = CreateDynamicObject(1671, 354.860748, 3589.442383, 11.234554, 0.0000, 0.0000, 175.3254);
	Carrier[7] = CreateDynamicObject(925, 304.330383, 3589.067383, 11.735489, 0.0000, 0.0000, 0.0000);
	Carrier[8] = CreateDynamicObject(930, 301.851654, 3588.497070, 11.131838, 0.0000, 0.0000, 0.0000);
	Carrier[9] = CreateDynamicObject(930, 301.856079, 3589.598145, 11.181837, 0.0000, 0.0000, 0.0000);
	Carrier[10] = CreateDynamicObject(964, 300.513062, 3589.303711, 10.705961, 0.0000, 0.0000, 177.4217);
	Carrier[11] = CreateDynamicObject(964, 299.024902, 3589.362793, 10.698584, 0.0000, 0.0000, 177.4217);
	Carrier[12] = CreateDynamicObject(1271, 305.058319, 3591.442871, 11.048584, 0.0000, 0.0000, 359.1406);
	Carrier[13] = CreateDynamicObject(1431, 303.009491, 3591.383789, 11.253574, 0.0000, 0.0000, 0.0000);
	Carrier[14] = CreateDynamicObject(2567, 297.100800, 3591.239746, 12.558563, 0.0000, 0.0000, 91.1003);
	Carrier[15] = CreateDynamicObject(3576, 301.050110, 3593.777344, 12.198634, 0.0000, 0.0000, 0.0000);
	Carrier[16] = CreateDynamicObject(3633, 304.567841, 3593.262207, 11.173386, 0.0000, 0.0000, 0.0000);

	CarrierS[0] = CreateDynamicObject(3267, 320.358582, 3592.519043, 21.567169, 0.0000, 0.0000, 0.0000);
	CarrierS[1] = CreateDynamicObject(11237, 291.557526, 3592.407715, 39.065594, 0.0000, 0.0000, 0.0000);
	CarrierS[2] = CreateDynamicObject(3395, 354.861725, 3590.989746, 10.797120, 0.0000, 0.0000, 88.0403);
	CarrierS[3] = CreateDynamicObject(1671, 356.571838, 3588.612793, 11.234554, 0.0000, 0.0000, 134.9316);
	CarrierS[4] = CreateDynamicObject(3393, 358.360016, 3588.834961, 10.797121, 0.0000, 0.0000, 0.0000);
	CarrierS[5] = CreateDynamicObject(3277, 320.391876, 3592.538086, 21.514416, 0.0000, 0.0000, 164.0483); */
	
	DocElevator = CreateDynamicObject(18755, 577.03979, 1490.21484, 6001.31250,   0.00000, 0.00000, -180.00000);
	
	DocInnerElevator[0] = CreateDynamicObject(18756, 577.04480, 1488.24072, 6001.29541,   0.00000, 0.00000, 180.00000);
	DocInnerElevator[1] = CreateDynamicObject(18757, 577.04480, 1492.22827, 6001.29541,   0.00000, 0.00000, 180.00000);
	
	DocElevatorExt[0] = CreateDynamicObject(18756, 577.10480, 1488.24072, 6001.21533,   0.00000, 0.00000, 180.00000);
	DocElevatorExt[1] = CreateDynamicObject(18757, 577.10480, 1492.22827, 6001.21533,   0.00000, 0.00000, 180.00000);
	DocElevatorExt[2] = CreateDynamicObject(18756, 577.10480, 1488.24072, 6008.37744,   0.00000, 0.00000, 180.00000);
	DocElevatorExt[3] = CreateDynamicObject(18757, 577.10480, 1492.22827, 6008.37744,   0.00000, 0.00000, 180.00000);
	DocElevatorExt[4] = CreateDynamicObject(18756, 577.10480, 1488.24072, 6015.39063,   0.00000, 0.00000, 180.00000);
	DocElevatorExt[5] = CreateDynamicObject(18757, 577.10480, 1492.22827, 6015.39063,   0.00000, 0.00000, 180.00000);
	
	DocAdmFloor1[0] = CreateDynamicObject(1495, 597.56000, 1494.96692, 5999.42773,   0.00000, 0.00000, 0.00000); // lobby gate
	DocAdmFloor1[1] = CreateDynamicObject(1495, 587.84039, 1495.08362, 5999.40771,   0.00000, 0.00000, 0.00000);// security entrance 1
	DocAdmFloor1[2] = CreateDynamicObject(1495, 590.28851, 1484.60571, 5999.42773,   0.00000, 0.00000, 270.00000); // lobby office to hallway
	DocAdmFloor1[3] = CreateDynamicObject(1495, 590.30060, 1481.43665, 5999.42773,   0.00000, 0.00000, 270.00000); // rear room to first hallway
	DocAdmFloor1[4] = CreateDynamicObject(1495, 579.84003, 1495.06958, 5999.42773,   0.00000, 0.00000, 0.00000); // visitor rooms
	DocAdmFloor1[5] = CreateDynamicObject(1495, 585.3400, 1478.2000, 5999.42773,   0.00000, 0.00000, 270.00000); // elevator hallway to first hallway
	DocAdmFloor1[6] = CreateDynamicObject(1495, 588.07373, 1475.81750, 5999.42773,   0.00000, 0.00000, 0.00000); // first hallway to parking elevator hallway
	DocAdmFloor1[7] = CreateDynamicObject(1495, 565.61963, 1475.81018, 5999.42773,   0.00000, 0.00000, 0.00000); // door to hospital wing
	DocAdmFloor1[8] = CreateDynamicObject(1569, 562.43921, 1473.47998, 5999.42676,   0.00000, 0.00000, 90.00000); // door to prison hallway
	DocAdmFloor1[9] = CreateDynamicObject(1495, 587.85999, 1487.88196, 5999.40771,   0.00000, 0.00000, 0.00000); // security entrance 2
	DocAdmFloor1[10] = CreateDynamicObject(1495, 579.83752, 1492.54773, 5999.40771,   0.00000, 0.00000, 0.00000); // visitor security

	DocAdmFloor2[0] = CreateDynamicObject(1536, 585.09998, 1475.88965, 6006.48047,   0.00000, 0.00000, 0.00000); // control room hallway
	DocAdmFloor2[1] = CreateDynamicObject(1536, 578.65002, 1471.09973, 6006.48047,   0.00000, 0.00000, 0.00000); // control room entrance
	DocAdmFloor2[2] = CreateDynamicObject(1536, 587.15039, 1495.40857, 6006.48047,   0.00000, 0.00000, 0.00000); // interogation 1
	DocAdmFloor2[3] = CreateDynamicObject(1536, 590.52771, 1495.39905, 6006.48047,   0.00000, 0.00000, 0.00000); // interogation 2
	DocAdmFloor2[4] = CreateDynamicObject(1536, 588.08301, 1475.89587, 6006.48047,   0.00000, 0.00000, 0.00000); // court house - rear room
	DocAdmFloor2[5] = CreateDynamicObject(1536, 597.62762, 1492.52954, 6006.48047,   0.00000, 0.00000, 0.00000); // court house room
	DocAdmFloor2[6] = CreateDynamicObject(1536, 591.09857, 1486.54163, 6013.39307,   0.00000, 0.00000, 180.00000); // warden's office

	DocCellRoomDoors[0] = CreateDynamicObject(1495, 553.22644, 1475.87146, 5995.95947,   0.00000, 0.00000, 0.00000); // messhall entrance
	DocCellRoomDoors[1] = CreateDynamicObject(1495, 553.96301, 1466.10803, 5999.47119,   0.00000, 0.00000, 0.00000); // prison entrance door
	DocCellRoomDoors[2] = CreateDynamicObject(1495, 568.22601, 1455.32703, 5999.47119,   0.00000, 0.00000, 90.00000); // gym entrance hallway
	DocCellRoomDoors[3] = CreateDynamicObject(1495, 547.46350, 1498.26025, 5995.95947,   0.00000, 0.00000, 0.00000); // kitchen access door
	DocCellRoomDoors[4] = CreateDynamicObject(1536, 549.62292, 1473.38794, 5995.95947,   0.00000, 0.00000, 90.00000); // court yard access
	//DocCellRoomDoors[5] = CreateDynamicObject(1536, 551.03003, 1471.72058, 5995.95947,   0.00000, 0.00000, 0.00000); //  hallway to isolation
	//DocCellRoomDoors[6] = CreateDynamicObject(1536, 551.03961, 1462.23999, 5995.95947,   0.00000, 0.00000, 0.00000); // isolation cells checkpoint
	DocCellRoomDoors[5] = CreateDynamicObject(1495, 573.79968, 1454.22156, 5999.47168,   0.00000, 0.00000, 180.00000); // Gym hallway
	DocCellRoomDoors[6] = CreateDynamicObject(1495, 576.60413, 1449.64075, 5999.47168,   0.00000, 0.00000, 270.00000); // Showers
	DocCellRoomDoors[7] = CreateDynamicObject(1495, 566.11102, 1429.46960, 5999.47168,   0.00000, 0.00000, 180.00000); // Inside gym
	DocCellRoomDoors[8] = CreateDynamicObject(1495, 553.28021, 1429.46667, 5999.47168,   0.00000, 0.00000, 180.00000); // Call-centre

	DocCellsFloor1[0] = CreateDynamicObject(19302, 567.21069, 1445.88171, 6000.74609,   0.00000, 0.00000, 0.00000); // cell 1 - floor 1
	DocCellsFloor1[1] = CreateDynamicObject(19302, 563.58539, 1445.88171, 6000.74609,   0.00000, 0.00000, 0.00000); // cell 2 - floor 1
	DocCellsFloor1[2] = CreateDynamicObject(19302, 559.87738, 1445.88171, 6000.74609,   0.00000, 0.00000, 0.00000); // cell 3 - floor 1
	DocCellsFloor1[3] = CreateDynamicObject(19302, 556.21832, 1445.88171, 6000.74609,   0.00000, 0.00000, 0.00000); // cell 4 - floor 1
	DocCellsFloor1[4] = CreateDynamicObject(19302, 552.55121, 1445.88171, 6000.74609,   0.00000, 0.00000, 0.00000); // cell 5 - floor 1
	DocCellsFloor1[5] = CreateDynamicObject(19302, 548.86353, 1445.88171, 6000.74609,   0.00000, 0.00000, 0.00000); // cell 6 - floor 1
	DocCellsFloor1[6] = CreateDynamicObject(19302, 545.21039, 1445.86316, 6000.74609,   0.00000, 0.00000, 0.00000); // cell 7 - floor 1
	DocCellsFloor1[7] = CreateDynamicObject(19302, 542.56842, 1446.81152, 6000.74609,   0.00000, 0.00000, 270.00000); // cell 8 - floor 1
	DocCellsFloor1[8] = CreateDynamicObject(19302, 542.54321, 1450.46936, 6000.74609,   0.00000, 0.00000, 270.00000); // cell 9 - floor 1
	DocCellsFloor1[9] = CreateDynamicObject(19302, 542.55432, 1454.13354, 6000.74609,   0.00000, 0.00000, 270.00000); // cell 10 - floor 1
	DocCellsFloor1[10] = CreateDynamicObject(19302, 542.55432, 1457.79626, 6000.74609,   0.00000, 0.00000, 270.00000); // cell 11 - floor 1
	DocCellsFloor1[11] = CreateDynamicObject(19302, 543.48657, 1462.26819, 6000.74609,   0.00000, 0.00000, 180.00000); // cell 12 - floor 1
	DocCellsFloor1[12] = CreateDynamicObject(19302, 547.16162, 1462.26819, 6000.74609,   0.00000, 0.00000, 180.00000); // cell 13 - floor 1
	DocCellsFloor1[13] = CreateDynamicObject(19302, 550.84277, 1462.28821, 6000.74609,   0.00000, 0.00000, 180.00000); // cell 14 - floor 1
	DocCellsFloor1[14] = CreateDynamicObject(19302, 556.91632, 1462.26819, 6000.74609,   0.00000, 0.00000, 180.00000); // cell 15 - floor 1
	DocCellsFloor1[15] =  CreateDynamicObject(19302, 560.60620, 1462.26819, 6000.74609,   0.00000, 0.00000, 180.00000);  // cell 16 - floor 1
	DocCellsFloor2[0] = CreateDynamicObject(19302, 567.23071, 1445.88171, 6004.63135,   0.00000, 0.00000, 0.00000); // cell 1 - floor 2
	DocCellsFloor2[1] = CreateDynamicObject(19302, 563.58539, 1445.88171, 6004.63135,   0.00000, 0.00000, 0.00000); // cell 1 - floor 2
	DocCellsFloor2[2] = CreateDynamicObject(19302, 559.87738, 1445.88171, 6004.63135,   0.00000, 0.00000, 0.00000);  // cell 2 - floor 2
	DocCellsFloor2[3] = CreateDynamicObject(19302, 556.21832, 1445.88171, 6004.63135,   0.00000, 0.00000, 0.00000);  // cell 3 - floor 2
	DocCellsFloor2[4] = CreateDynamicObject(19302, 552.55121, 1445.88171, 6004.63135,   0.00000, 0.00000, 0.00000);  // cell 4 - floor 2
	DocCellsFloor2[5] = CreateDynamicObject(19302, 548.86353, 1445.88171, 6004.63135,   0.00000, 0.00000, 0.00000);  // cell 5 - floor 2
	DocCellsFloor2[6] = CreateDynamicObject(19302, 545.21039, 1445.86316, 6004.63135,   0.00000, 0.00000, 0.00000);  // cell 6 - floor 2
	DocCellsFloor2[7] = CreateDynamicObject(19302, 542.56842, 1446.81152, 6004.63135,   0.00000, 0.00000, 270.00000);  // cell 7 - floor 2
	DocCellsFloor2[8] = CreateDynamicObject(19302, 542.54321, 1450.46936, 6004.63135,   0.00000, 0.00000, 270.00000);  // cell 8 - floor 2
	DocCellsFloor2[9] = CreateDynamicObject(19302, 542.55432, 1454.13354, 6004.63135,   0.00000, 0.00000, 270.00000);  // cell 9 - floor 2
	DocCellsFloor2[10] = CreateDynamicObject(19302, 542.55432, 1457.79626, 6004.63135,   0.00000, 0.00000, 270.00000);  // cell 10 - floor 2
	DocCellsFloor2[11] = CreateDynamicObject(19302, 543.48657, 1462.26819, 6004.63135,   0.00000, 0.00000, 180.00000);  // cell 11 - floor 2
	DocCellsFloor2[12] = CreateDynamicObject(19302, 547.16162, 1462.26819, 6004.63135,   0.00000, 0.00000, 180.00000);  // cell 12 - floor 2
	DocCellsFloor2[13] = CreateDynamicObject(19302, 550.84277, 1462.28821, 6004.63135,   0.00000, 0.00000, 180.00000);  // cell 13 - floor 2
	DocCellsFloor2[14] = CreateDynamicObject(19302, 556.91632, 1462.26819, 6004.63135,   0.00000, 0.00000, 180.00000);  // cell 14 - floor 2

	// Doc Isolation Cell Doors:
	DocIsolationDoors[0] = CreateDynamicObject(19302, -2139.23169, -150.71797, 2010.47229,   0.00000, 0.00000, 0.00000);
	DocIsolationDoors[1] = CreateDynamicObject(19302, -2135.38452, -150.72092, 2010.47229,   0.00000, 0.00000, 0.00000);
	DocIsolationDoors[2] = CreateDynamicObject(19302, -2131.57104, -150.67859, 2010.47229,   0.00000, 0.00000, 0.00000);
	DocIsolationDoors[3] = CreateDynamicObject(19302, -2143.49438, -150.77216, 2010.47229,   0.00000, 0.00000, 0.00000);
	DocIsolationDoors[4] = CreateDynamicObject(19302, -2147.36108, -150.60271, 2010.47229,   0.00000, 0.00000, 0.00000);
	

	DocIsolationDoors[5] = CreateDynamicObject(19302, -2147.28296, -150.68958, 2014.5593,   0.00000, 0.00000, 0.00000);
	DocIsolationDoors[6] = CreateDynamicObject(19302, -2151.34473, -150.66469, 2014.5593,   0.00000, 0.00000, 0.00000);
	DocIsolationDoors[7] = CreateDynamicObject(19302, -2154.62915, -150.68343, 2014.5593,   0.00000, 0.00000, 0.00000);
	DocIsolationDoors[8] = CreateDynamicObject(19302, -2143.52930, -150.66467, 2014.5593,   0.00000, 0.00000, 0.00000);
	DocIsolationDoors[9] = CreateDynamicObject(19302, -2139.22485, -150.67685, 2014.5593,   0.00000, 0.00000, 0.00000);
	DocIsolationDoors[10] = CreateDynamicObject(19302, -2135.43311, -150.65767, 2014.5593,   0.00000, 0.00000, 0.00000);
	DocIsolationDoors[11] = CreateDynamicObject(19302, -2131.43262, -150.6903, 2014.5593,   0.00000, 0.00000, 0.00000);

	DocIsolationDoors[12] = CreateDynamicObject(19302, -2147.46753, -137.1050, 2010.47229,   0.00000, 0.00000, 0.00000);
	DocIsolationDoors[13] = CreateDynamicObject(19302, -2151.54419, -137.20715, 2010.47229,   0.00000, 0.00000, 0.00000);
	DocIsolationDoors[14] = CreateDynamicObject(19302, -2143.61450, -137.09286, 2010.47229,   0.00000, 0.00000, 0.00000);
	DocIsolationDoors[15] = CreateDynamicObject(19302, -2139.13940, -137.20073, 2010.47229,   0.00000, 0.00000, 0.00000);
	DocIsolationDoors[16] = CreateDynamicObject(19302, -2135.33667, -137.10387, 2010.47229,   0.00000, 0.00000, 0.00000);
	DocIsolationDoors[17] = CreateDynamicObject(19302, -2131.41870, -137.20285, 2010.47229,   0.00000, 0.00000, 0.00000);
	

	DocIsolationDoors[18] = CreateDynamicObject(19302, -2154.72876, -137.2157, 2014.6953,   0.00000, 0.00000, 0.00000);
	DocIsolationDoors[19] = CreateDynamicObject(19302, -2151.53076, -137.23778, 2014.6953,   0.00000, 0.00000, 0.00000);
	DocIsolationDoors[20] = CreateDynamicObject(19302, -2147.42139, -137.08806, 2014.6953,   0.00000, 0.00000, 0.00000);
	DocIsolationDoors[21] = CreateDynamicObject(19302, -2143.48828, -137.1256, 2014.6953,   0.00000, 0.00000, 0.00000);
	DocIsolationDoors[22] = CreateDynamicObject(19302, -2139.47119, -137.28308, 2014.6953,   0.00000, 0.00000, 0.00000);
	DocIsolationDoors[23] = CreateDynamicObject(19302, -2135.35815, -137.12624, 2014.6953,   0.00000, 0.00000, 0.00000);
	DocIsolationDoors[24] = CreateDynamicObject(19302, -2131.47437, -137.20755, 2014.6953,   0.00000, 0.00000, 0.00000);
	
	// Gym dynamic objects (bmx parkour)
	BikeParkourObjects[0] = CreateDynamicObject(2669,2848.1015625,-2243.1552734,99.0883789,0.0000000,0.0000000,90.0000000, .worldid = 5, .streamdistance = 300); //object(cj_chris_crate) (1)
	//BikeParkourObjects[1] = CreateDynamicObject(1381,2847.4970703,-2243.1191406,4901.4877930,0.0000000,0.0000000,69.7851562, .worldid = -1, .streamdistance = 300); //object(magnocrane_04) (1)

    MoveDynamicObject(BikeParkourObjects[0], 2848.1015625, -2238.1552734, 99.0883789, 0.5, 0.0, 0.0, 90.0);
	//MoveDynamicObject(BikeParkourObjects[1], 2847.4970703, -2243.1191406, 4901.4877930, 0.5, 0.0, 0.0, 69.7851562);
	
	gFerrisWheel = CreateObject( 18877, gFerrisOrigin[0], gFerrisOrigin[1], gFerrisOrigin[2],
	  							 0.0, 0.0, -270.0, 300.0 );
	CreateObject( 18878, gFerrisOrigin[0], gFerrisOrigin[1], gFerrisOrigin[2],
	  							 0.0, 0.0, -270.0, 300.0 );
 	for(new x;x<10;x++)
    {
        gFerrisCages[x] = CreateObject( 19316, gFerrisOrigin[0], gFerrisOrigin[1], gFerrisOrigin[2],
	  							 0.0, 0.0, -270.0, 300.0 );

        AttachObjectToObject( gFerrisCages[x], gFerrisWheel,
							  gFerrisCageOffsets[x][0],
							  gFerrisCageOffsets[x][1],
	  						  gFerrisCageOffsets[x][2],
							  0.0, 0.0, -270.0, 0 );
	}
	
	//FDSA Static object ground
	CreateObject(8531, 1289.93, -2552.11, 13.34,   0.00, 0.00, 186.04);
	 
	//FDSA Static object roof
	CreateDynamicObject(19377, 1296.63, -2584.18, 16.73,   0.00, 90.00, 6.00, .worldid = 0, .streamdistance = 200);
	CreateDynamicObject(19377, 1301.41, -2578.00, 16.81,   0.00, 90.00, 6.00, .worldid = 0, .streamdistance = 200);
	
	//SFPD
	SFPDHighCMDDoor[0] = CreateDynamicObject(1536, -1578.19397, 702.29370, 18.64510,   0.00000, 0.00000, 0.00000, .streamdistance = 50); // Chief
	SFPDHighCMDDoor[1] = CreateDynamicObject(1536, -1578.26196, 696.84729, 18.64510,   0.00000, 0.00000, 0.00000, .streamdistance = 50); //Deputy Chief
	SFPDHighCMDDoor[2] = CreateDynamicObject(1536, -1587.77795, 697.84589, 18.64510,   0.00000, 0.00000, 0.00000, .streamdistance = 50); //Commander
	
	SFPDLobbyDoor[0] = CreateDynamicObject(1495, -1602.26709, 704.99298, 12.85020,   0.00000, 0.00000, -90.00000, .streamdistance = 50);
	SFPDLobbyDoor[1] = CreateDynamicObject(1495, -1598.17004, 702.68219, 12.85020,   0.00000, 0.00000, 0.00000, .streamdistance = 50);
	
	print("[Streamer] Dynamic Objects has been loaded.");
	return 1;
}