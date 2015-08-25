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
	DocButtons[0] = CreateButton(597.35022, 1495.02881, 6001.10938, 180.00);
	DocButtons[1] = CreateButton(590.35669, 1484.88452, 6001.10938, 90.00);
	DocButtons[2] = CreateButton(590.35199, 1481.74048, 6001.10938, 90.00);
	DocButtons[3] = CreateButton(585.33081, 1478.44385, 6001.10938, 270.00);
	DocButtons[4] = CreateButton(589.62848, 1495.06372, 6001.10938, 0.00);
	DocButtons[5] = CreateButton(589.81085, 1487.91870, 6001.10938, 0.00);
	DocButtons[6] = CreateButton(589.85394, 1475.79370, 6001.10938, 0.00);
	DocButtons[7] = CreateButton(567.36774, 1475.78076, 6001.10938, 0.00);
	DocButtons[8] = CreateButton(562.53558, 1475.25171, 6001.10938, 90.00);
	DocButtons[9] = CreateButton(549.62268, 1475.17310, 5997.64258, 90.00);
	DocButtons[10] = CreateButton(555.01172, 1475.77649, 5997.64258, 0.00);
	DocButtons[11] = CreateButton(547.00482, 1498.27478, 5997.64258, 0.00);
	DocButtons[12] = CreateButton(581.68353, 1492.52795, 6001.10938, 0.00);
	DocButtons[13] = CreateButton(581.66846, 1495.06531, 6001.10938, 0.00);
	DocButtons[14] = CreateButton(578.28308, 1471.08630, 6008.33350, 0.00);
	DocButtons[15] = CreateButton(584.73883, 1475.85547, 6008.33350, 0.00);
	DocButtons[16] = CreateButton(587.71490, 1475.85547, 6008.33350, 0.00);
	DocButtons[17] = CreateButton(597.27667, 1492.54871, 6008.33350, 180.00);
	DocButtons[18] = CreateButton(592.48859, 1495.47900, 6008.33350, 180.00);
	DocButtons[19] = CreateButton(589.09015, 1495.47241, 6008.33350, 180.00);
	DocButtons[20] = CreateButton(591.32568, 1486.47046, 6015.14746, 0.00);
	DocButtons[21] = CreateButton(568.17041, 1455.06677, 6001.10938, 270.00);
	DocButtons[22] = CreateButton(555.69672, 1466.10669, 6001.14990, 0.00);
	DocButtons[23] = CreateButton(574.04047, 1454.24988, 6001.05078, 180.00);
	DocButtons[24] = CreateButton(576.57416, 1449.88806, 6001.05078, 270.00);
	DocButtons[25] = CreateButton(566.48718, 1429.47644, 6001.05078, 180.00);
	DocButtons[26] = CreateButton(553.63123, 1429.40625, 6001.05078, 0.00);
	
	DocCPButton = CreateButton(568.29041, 1461.34607, 6008.45410, 90.00000);
	
	DocElevatorCall[0] = CreateButton(579.07770, 1488.00403, 6001.09277, 90.00000);
	DocElevatorCall[1] = CreateButton(579.07770, 1488.00403, 6008.11475, 90.00000);
	DocElevatorCall[2] = CreateButton(579.07770, 1488.00403, 6015.20801, 90.00000);
	DocElevatorInside = CreateButton(578.91467, 1492.18884, 6001.04785, 270.00000);
	
	//SFPD
	SFPDHighCMDButton[0] = CreateButton(-1576.30066, 702.27972, 20.18620, 0); // Chief
	SFPDHighCMDButton[1] = CreateButton(-1576.38074, 696.90778, 20.18620, 180); // Deputy Chief
	SFPDHighCMDButton[2] = CreateButton(-1585.98792, 697.89203, 20.18620, 180); // Commander
	
	SFPDLobbyButton[0] =  CreateButton(-1602.30322, 705.35291, 14.34120, -90);
	SFPDLobbyButton[1] =  CreateButton(-1596.22266, 702.63599, 14.34120, 0);
	
	print("[Streamer] Dynamic Buttons has been loaded.");
	
	return 1;
}