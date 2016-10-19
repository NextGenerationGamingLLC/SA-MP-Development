#include <YSI\y_hooks>

hook OnGameModeInit() {
	
	print("[Streamer] Loading Dynamic Objects...");

	//CrateLoad = CreateDynamicObject(964,-2114.1, -1723.5, 11984.5, 0, 0, 337.994, .worldid = 0, .interiorid = 1, .streamdistance = 200); //object(cj_metal_crate) (1)
	//CrateLoad = CreateDynamicObject(964, -2136.05, -1573.24, 3550.00,0.00000000,0.00000000,180.00000000, .worldid = 0, .interiorid = 1, .streamdistance = 200); //object(cj_metal_crate) (1)
	CrateLoad[0] = CreateDynamicObject(964, 2701.17188, -2654.36353, 12.63166,   0.00000, 0.00000, 88.00000, .worldid = 0, .interiorid = 0, .streamdistance = 200); //object(cj_metal_crate) (1)	
	CrateLoad[1] = CreateDynamicObject(964, 2579.03467, 2811.95459, 9.82230,   0.00000, 0.00000, 176.93890, .worldid = 0, .interiorid = 0, .streamdistance = 200);

	new VIPLogo = CreateDynamicObject(19353, 1803.89, -1593.99, 14.05,   0.00, 0.00, 312.26);
	SetDynamicObjectMaterialText(VIPLogo, 0, "{842787}VIP LOUNGE", 90, "Impact", 56, 1, 0xFFFFFFFF, 0, 1);

	new FCTS = CreateDynamicObject(19482, -58.9155, -1118.4808, 7.4781, 0.0000, 0.0000, 160.3858);
	SetDynamicObjectMaterialText(FCTS, 0, "{880000}Flint County Towing Services", 110, "Impact", 40, 1, 0xFF000000, 0, 1);
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

	DocCellRoomDoors[0] = CreateDynamicObject(1495, 568.36981, 1453.9955, 5999.47168,   0.00000, 0.00000, 270.00000); // cell block 1
	DocCellRoomDoors[1] = CreateDynamicObject(1495, 572.8498, 1453.9955, 5999.47168,   0.00000, 0.00000, 270.00000); // cell block 2
	DocCellRoomDoors[2] = CreateDynamicObject(1495, 585.77289, 1448.87915, 5999.45947,   0.00000, 0.00000, 90.00000); // showers
	DocCellRoomDoors[3] = CreateDynamicObject(1495, 553.98120, 1466.11426, 5999.44971,   0.00000, 0.00000, 0.00000); // cafe 1
	DocCellRoomDoors[4] = CreateDynamicObject(1495, 553.98169, 1474.47205, 5999.48877,   0.00000, 0.00000, 0.00000); // cafe 2
	DocCellRoomDoors[5] = CreateDynamicObject(1495, 583.51978, 1455.05212, 5999.47266,   0.00000, 0.00000, 0.00000); // laundry
	DocCellRoomDoors[6] = CreateDynamicObject(1495, 531.66589, 1428.00647, 10999.45703,   0.00000, 0.00000, 0.00000); // isolation
	DocCellRoomDoors[7] = CreateDynamicObject(1495, 566.54053, 1462.30774, 6003.41699,   0.00000, 0.00000, 0.00000); // control panel
	DocCellRoomDoors[8] = CreateDynamicObject(1569, 572.9866, 1447.5975, 5999.4727,   0.00000, 0.00000, 90.00000); // small control room
	DocCellRoomDoors[9] = CreateDynamicObject(1569, 597.01477, 1452.43774, 5999.44873,   0.00000, 0.00000, 90.00000); // processing 1
	DocCellRoomDoors[10] = CreateDynamicObject(1569, 599.12000, 1451.45422, 5999.47754,   0.00000, 0.00000, 0.00000); // processing 2
	DocCellRoomDoors[11] = CreateDynamicObject(1569, 589.21820, 1448.87537, 5999.46826,   0.00000, 0.00000, 90.00000); // processing 3
	DocCellRoomDoors[12] = CreateDynamicObject(1569, 579.57898, 1463.63379, 5999.46143,   0.00000, 0.00000, 90.00000); // classroom
	DocCellRoomDoors[13] = CreateDynamicObject(1569, 572.99377, 1468.63940, 5999.43994,   0.00000, 0.00000, 90.00000); // closet
	DocCellRoomDoors[14] = CreateDynamicObject(1569, 572.98419, 1434.65295, 5999.52295,   0.00000, 0.00000, 90.00000); // medward
	DocCellRoomDoors[15] = CreateDynamicObject(1569, 575.50751, 1461.82019, 5999.47168,   0.00000, 0.00000, 0.00000); // hallway
	DocCellRoomDoors[16] = CreateDynamicObject(1495, 526.92139, 1414.63281, 10999.45703,   0.00000, 0.00000, 270.00000); // lobby 1 
	DocCellRoomDoors[17] = CreateDynamicObject(1495, 529.96143, 1414.63281, 10999.45703,   0.00000, 0.00000, 270.00000); // lobby 2
	DocCellRoomDoors[18] = CreateDynamicObject(1495, 542.2069, 1417.86682, 10999.45703,   0.00000, 0.00000, 90.00000); // visitation

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

	CreateDynamicObject(6922, 2551.58936, 112.29691, 28.16482,   0.00000, 0.00000, 90.00000); // New Robada DMV

	// SASD Interior doors.
	SASDDoors[0] = CreateDynamicObject(1495, 14.92530, 53.51950, 996.84857,   0.00000, 0.00000, 90.00000);
	SASDDoors[1] = CreateDynamicObject(1495, 8.70370, 57.32530, 991.03699,   0.00000, 0.00000, 270.00000);
	
	print("[Streamer] Dynamic Objects has been loaded.");
	return 1;
}