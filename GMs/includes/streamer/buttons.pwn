#include <YSI\y_hooks>

hook OnGameModeInit() {
	
	print("[Streamer] Loading Dynamic Buttons...");

    /* LSPD buttons */
 	eastin = CreateButton(253.44921875,110.59960938,1003.79998779,90.00000000); //object(fire_break) (1)
	westout = CreateButton(239.79492188,116.18457031,1003.87286377,90.00000000); //object(fire_break) (2)
	westin = CreateButton(239.32031250,116.27441406,1003.87286377,270.00000000); //object(fire_break) (3)
	eastout = CreateButton(253.00000000,110.59960938,1003.79998779,270.00000000); //
	elevator = CreateButton(275.83984375,120.94921875,1005.12280273,90.00000000); //object(kmb_keypad) (1)
	cctvin = CreateButton(264.55566406,115.97949219,1005.12280273,179.99450684); //object(kmb_keypad) (2)
	cctvout = CreateButton(264.55566406,115.69531250,1005.12280273,0.00000000); //object(kmb_keypad) (3)
	lockerin = CreateButton(267.21679688,112.40917969,1005.12280273,0.00000000); //object(kmb_keypad) (4)
	lockerout = CreateButton(267.21679688,112.66992188,1005.12280273,179.99450684); //object(kmb_keypad) (5)
	chiefout = CreateButton(232.50000000,119.38476562,1010.81384277,0.00000000); //object(sec_keypad) (2)
	chiefin = CreateButton(229.67089844,119.66992188,1010.81384277,179.99450684); //object(sec_keypad) (1)
	roofkey = CreateButton(1565.93652344,-1667.35058594,28.85165977,179.99450684); //object(sec_keypad) (3)
	garagekey = CreateButton(1567.14550781,-1689.62011719,6.69999981,0.00000000); //object(sec_keypad) (4)
 	sasdbtn1 = CreateButton(2514.59179688,-1697.05761719,563.19116211,0.00000000); //SASD West
	sasdbtn2 = CreateButton(2522.82299805,-1660.15917969,563.15893555,0.00000000); //SASD East
	sasdbtn3 = CreateButton(2525.09863281,-1697.05761719,563.16284180,0.00000000); //SASD R4
	sasdbtn4 = CreateButton(2519.84375000,-1697.00659180,563.20904541,0.00000000); //SASD R5
	sasdbtn5 = CreateButton(2514.77880859,-1660.15917969,563.16925049); //SASD R6
	
	FBILobbyLeftBTN[0] = CreateButton(297.66613770,-1498.67749023,-44.59006119,0.79565430); //Lobby Button Left
	FBILobbyLeftBTN[1] = CreateButton(297.24850464,-1498.23107910,-44.59006119,180); //Lobby Button Left
	FBILobbyRightBTN[0] = CreateButton(300.05300903,-1521.40747070,-44.59006119,180); //Lobby Button Right
	FBILobbyRightBTN[1] = CreateButton(300.16033936,-1521.84387207,-44.59006119,0); //Lobby Button Right
	FBIPrivateBTN[0] = CreateButton(298.87384033,-1495.87316895,-27.32773209,270); //Private Office Button
	FBIPrivateBTN[1] = CreateButton(300.49453735,-1495.33837891,-27.28091812,180.49487305); //Private Office Button
	
	//new doc buttons
	
	DocCPButton[0] = CreateButton(562.11182, 1466.07971, 6004.94434, 0.00000);
	DocCPButton[1] = CreateButton(568.39807, 1448.59290, 6001.06250, 90.00000);

	DocButton[0] = CreateButton(568.43280, 1454.26233, 6000.82764, 90.00000); // cell block 1
	DocButton[1] = CreateButton(572.89282, 1454.26233, 6000.82764, 90.00000); // cell block 2
	DocButton[2] = CreateButton(585.79999, 1450.63147, 6000.82764, 90.00000); // showers
	DocButton[3] = CreateButton(555.69019, 1466.07507, 6000.82764, 0.00000); // cafe 
	DocButton[4] = CreateButton(555.69019, 1474.57507, 6000.82764, 180.00000); // cafe 
	DocButton[5] = CreateButton(585.50427, 1455.00159, 6000.82764, 0.00000); // laundry
	DocButton[6] = CreateButton(533.41315, 1427.92419, 11000.79883, 0.00000); // isolation
	DocButton[7] = CreateButton(566.26862, 1462.26050, 6004.94434, 0.00000); // control room
	DocButton[8] = CreateButton(573.03278, 1449.44226, 6000.82764, 90.00000); //small control room
	DocButton[9] = CreateButton(596.94958, 1452.18896, 6000.82764, 270.00000); // processing 1
	DocButton[10] = CreateButton(598.88861, 1451.52319, 6000.82764, 180.00000); // processing 2
	DocButton[11] = CreateButton(589.25580, 1450.58044, 6000.82764, 90.00000); // processing 3
	DocButton[12] = CreateButton(579.50372, 1463.32056, 6000.82764, 270.00000); // classroom
	DocButton[13] = CreateButton(572.92511, 1470.46106, 6000.82764, 270.00000); // janitors
	DocButton[14] = CreateButton(572.91278, 1436.46228, 6000.82764, 270.00000); // med ward
	DocButton[15] = CreateButton(577.34839, 1461.79333, 6000.82764, 0.00000); // hallway
	DocButton[16] = CreateButton(526.89038, 1414.83362, 11000.79883, 270.00000); // lobby1
	DocButton[17] = CreateButton(529.95319, 1414.83459, 11000.79883, 270.00000); // lobby 2
	DocButton[18] = CreateButton(542.25250, 1419.69385, 11000.79883, 90.00000); //visitation
	
	//SFPD
	SFPDHighCMDButton[0] = CreateButton(-1576.30066, 702.27972, 20.18620, 0); // Chief
	SFPDHighCMDButton[1] = CreateButton(-1576.38074, 696.90778, 20.18620, 180); // Deputy Chief
	SFPDHighCMDButton[2] = CreateButton(-1585.98792, 697.89203, 20.18620, 180); // Commander
	
	SFPDLobbyButton[0] =  CreateButton(-1602.30322, 705.35291, 14.34120, -90);
	SFPDLobbyButton[1] =  CreateButton(-1596.22266, 702.63599, 14.34120, 0);


	// New SASD Interior buttons.
	SASDButtons[0] = CreateButton(14.98460, 55.32560, 998.19952, 270);
	SASDButtons[1] = CreateButton(8.64260, 57.66020, 992.35028, 90);
	SASDButtons[2] = CreateButton(8.82460, 57.66020, 992.35028, 270);
	SASDButtons[3] = CreateButton(14.80460, 55.32560, 998.19952, 90);
	
	print("[Streamer] Dynamic Buttons has been loaded.");
	
	return 1;
}