/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

				Driving License System

				Next Generation Gaming, LLC
	(created by Next Generation Gaming Development Team)
	
	Developers:
		(*) Connor
	
	* Copyright (c) 2014, Next Generation Gaming, LLC
	*
	* All rights reserved.
	*
	* Redistribution and use in source and binary forms, with or without modification,
	* are not permitted in any case.
	*
	*
	* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
	* "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
	* LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
	* A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
	* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
	* EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
	* PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
	* PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
	* LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
	* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
	* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

/*
    MODULE DESCRIPTION:
   		This module will control the driving school (LV), and any other's created afterwards.
        Module created by Connor.
*/
#include <YSI\y_hooks>
#define DIALOG_DSVEH_CAUTION 6941
#define DIALOG_DSVEH_RULES 6942
#define DIALOG_DSVEH_TESTBASE 6943
#define CHECKPOINT_DRIVINGSCHOOL 2539

forward checkTestVehicle(playerid);

new Float:dsPoints[][3] = {
{831.7027, -532.8328,16.1875},// 50MPH here 0 .. 6
{736.7017, -527.3942,16.1853},
{608.3339, -526.9122,16.1875},
{606.4116, -490.6386,16.1875},
{638.1245, -487.9801,16.1875},
{644.0964, -423.1464,16.1875},
{481.3117, -409.6009,28.2226},
{507.2693, -265.1509,39.4962}, // 75 MPH .. 7
{534.5291, -66.4511,33.9791},
{526.1484,	121.7778,23.2391},
{517.1490,	222.0933,14.1163},
{611.3632,	302.6062,19.6489},
{567.7776,	412.1702,18.9297},
{401.7130,	647.6183,16.0570},
{389.5166,	708.9777,7.6662}, // 100 MPH .. 14
{449.6645,	721.1133,6.9957},
{535.5026,	679.9868,3.3407},
{796.2744,	667.3570,11.4930},
{1024.5425,	754.6620,10.7194},
{1114.9189,	807.6386,10.6967},
{1328.7134,	830.4793,7.0510},
{1603.1160,	831.0084,6.7415},
{1775.6427,	830.4814,10.6214},
{1778.5773,	727.1645,13.9155},
{1715.8646,	492.4512,29.7240},
{1617.8558,	177.6520,34.0651},
{1617.5310,	6.6766,36.7841},
{1657.2775,	-278.2856,39.2574},
{1692.4639,	-486.9178,33.5310},
{1702.2354,	-672.2171,44.1025},
{1682.4436,	-805.0659,56.2486},
{1651.8145,	-959.0993,62.6496},
{1616.0876,	-1193.8728,53.7385},
{1589.4042,	-1387.9063,28.5859},
{1562.9680,	-1492.5186,23.4960},
{1748.6364,	-1524.2328,15.1585},
{1895.6719,	-1519.1278,3.2474},
{1999.9910,	-1524.9926,3.4045},
{2035.0435,	-1564.4026,9.5236},// 50 mph .. 38
{2038.1971,	-1601.5859,13.3607},
{2003.9198,	-1612.5131,13.3828},
{1999.0182,	-1698.4968,13.3828},
{1992.3318,	-1749.4905,13.3828},
{1836.0243,	-1749.9882,13.3828},
{1807.0741,	-1729.6615,13.3906},
{1704.1311,	-1730.0616,13.3828},
{1521.5819,	-1729.8215,13.3906},
{1405.7303,	-1730.2463,13.3906},
{1323.9509,	-1730.1533,13.3828},
{1315.2252,	-1645.5785,13.3828}, // 60 mph .. 49
{1330.1670,	-1515.8776,13.3828},
{1360.1370,	-1417.6323,13.3828},
{1360.5392,	-1241.5996,13.3906},
{1358.2805,	-1106.4918,23.8211},
{1374.6986,	-959.8929,34.0587},
{1350.2822,	-933.2753,34.6286},
{1264.5192,	-922.1843,42.3513},
{1171.2117,	-938.7873,42.8333},
{1157.1008,	-840.9021,50.2694},
{1221.5367,	-594.4638,50.4564},
{1264.1517,	-424.7072,2.9596},
{1195.0958,	-419.3996,11.8159},
{1036.3280,	-449.8881,51.6425},
{916.8047,-	535.6148,29.9622},
{847.7750,-	562.9050,16.7240}
};

//player_get_speed
// PVARS: pDTest (Is the player testing), pTestMarker (The marker the player is on),  pTestZone (Roads, Highways), pTestVeh (The vehicle the player is testing with)
new pFindDrive[MAX_PLAYERS];
new pDriveTimer[MAX_PLAYERS];

DrivingTestFinish(playerid)
{
	new pTestVeh = GetPVarInt(playerid, "PTestVeh");
	DestroyVehicle(pTestVeh);
	DeletePVar(playerid, "pTestVeh");
	DeletePVar(playerid, "pDTest");
	DeletePVar(playerid, "pTestMarker");
	DisablePlayerCheckpoint(playerid);
	PlayerInfo[playerid][pCarLic] = gettime() + (86400*80);
	SendClientMessageEx(playerid, COLOR_WHITE, "Driving Instructor: You have successfully completed driving school and earned your license!");
	return 1;
}

DrivingSchoolSpeedMeter(playerid, Float:speed)
{
	new 
		pTestMarker = GetPVarInt(playerid, "pTestMarker"),
		maxspeed = 0; 

	/*if(pTestMarker < 20 || pTestMarker >= 29)
	{
		if(speed > 50)
		{
			SetPlayerCheckpoint(playerid, 814.0655,-600.5410,16.0355, 4.0);
			SendClientMessageEx(playerid, COLOR_GREY, "You have exceeded the resdiental speed limit of 50MPH, you have failed the test.");
			SetPVarInt(playerid, "pDTest", 2);
		}
	}
	else if(speed >= 100)
	{
		SetPlayerCheckpoint(playerid, 814.0655,-600.5410,16.0355, 4.0);
		SendClientMessageEx(playerid, COLOR_GREY, "You have exceeded the freeway speed limit of 100MPH, you have failed the test.");
		SetPVarInt(playerid, "pDTest", 2);
	}*/

	switch(pTestMarker) {
		case 0 .. 6: maxspeed = 50;
		case 7 .. 13: maxspeed = 75;
		case 14 .. 37: maxspeed = 100;
		case 38 .. 48: maxspeed = 50;
		case 49 .. 64: maxspeed = 60; 
	}

	if(speed > (maxspeed + 5)) {
		format(szMiscArray, sizeof(szMiscArray), "You have exceeded the max speed limit of %d MPH.", maxspeed);
		SendClientMessageEx(playerid, COLOR_GREY, szMiscArray);
		SetPlayerCheckpoint(playerid, 814.0655,-600.5410,16.0355, 4.0);
		SetPVarInt(playerid, "pDTest", 2);
	}
	return 1;
}

hook OnGameModeInit()
{
	//CreateDynamicPickup(1239, 1, 1173.0698,1348.4688,10.9219);
	//CreateDynamic3DTextLabel("/drivingtest to begin the driving test.", 0xFF0000FF, 1173.0698,1348.4688,10.9219,4.0);
	return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(GetPVarType(playerid, "pDTest") > 0)
	{
		new pTestVeh = GetPVarInt(playerid, "pTestVeh");
		if(oldstate == PLAYER_STATE_DRIVER && newstate == PLAYER_STATE_ONFOOT)
		{
			pDriveTimer[playerid] = SetTimerEx("checkTestVehicle", 60000, false, "i", playerid);
			SendClientMessageEx(playerid, COLOR_YELLOW, "You have 60 seconds to get back in your vehicle or it will be taken back.");
		}
		else if(oldstate == PLAYER_STATE_ONFOOT && newstate == PLAYER_STATE_DRIVER && GetPlayerVehicleID(playerid) == pTestVeh)
		{
			KillTimer(pDriveTimer[playerid]);
		}
	}
	else if(oldstate == PLAYER_STATE_ONFOOT && newstate == PLAYER_STATE_DRIVER)
	{
		if(PlayerInfo[playerid][pCarLic] < gettime())
		{
			SendClientMessageEx(playerid, COLOR_YELLOW, "Warning: Your drivers license has expired. Head to the DMV to renew it.");
		}
	}
	return 1;
}

public checkTestVehicle(playerid)
{
	if(GetPVarType(playerid, "pDTest") > 0)
	{
		if(GetPlayerVehicleID(playerid) > 0) return 1;
		new pTestVeh = GetPVarInt(playerid, "PTestVeh");
		DestroyVehicle(pTestVeh);
		DeletePVar(playerid, "pTestVeh");
		DeletePVar(playerid, "pDTest");
		DeletePVar(playerid, "pTestMarker");
		DisablePlayerCheckpoint(playerid);
		SendClientMessageEx(playerid, COLOR_YELLOW, "SMS: You have failed your driving test. , Sender: Driving Instructor (555)");
	}
	return 1;
}

hook OnPlayerDisconnect(playerid)
{
	if(GetPVarType(playerid, "PTestVeh"))
	{
		new pTestVeh = GetPVarInt(playerid, "PTestVeh");
		DestroyVehicle(pTestVeh);
	}
	pFindDrive[playerid] = 0;
	pDriveTimer[playerid] = 0;
}

hook OnPlayerEnterCheckpoint(playerid){
	if(pFindDrive[playerid] == 1)
	{
		pFindDrive[playerid] = 0;
		DisablePlayerCheckpoint(playerid);
		SendClientMessageEx(playerid, COLOR_GREY, "You have arrived at the driving school!");
	}
	else if(gPlayerCheckpointStatus[playerid] == CHECKPOINT_DRIVINGSCHOOL)
	{
		new pDTest = GetPVarInt(playerid, "pDTest");
		if(pDTest == 1)
		{
			new pTestMarker = GetPVarInt(playerid, "pTestMarker");
			pTestMarker += 1;
			if(pTestMarker >= sizeof(dsPoints)) return DrivingTestFinish(playerid);
			SetPlayerCheckpoint(playerid, dsPoints[pTestMarker][0], dsPoints[pTestMarker][1], dsPoints[pTestMarker][2], 4.0);
			SetPVarInt(playerid, "pTestMarker", pTestMarker);
		}
		else if(pDTest == 2)
		{
			new pTestVeh = GetPVarInt(playerid, "PTestVeh");
			DestroyVehicle(pTestVeh);
			DeletePVar(playerid, "pTestVeh");
			DeletePVar(playerid, "pDTest");
			DeletePVar(playerid, "pTestMarker");
			DisablePlayerCheckpoint(playerid);
		}
	}
	return 1;
}
hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
	switch(dialogid)
	{
		case DIALOG_DSVEH_CAUTION:
		{
			if(response)
			{
				//1138.3353,1375.6553,10.4057
				ShowPlayerDialog(playerid, 
				DIALOG_DSVEH_RULES,
				DIALOG_STYLE_MSGBOX,
				"Driving Rules", 
				"The rules of the road are as follows..\n1. You must drive on the right side of the road.\n2. You must follow speed limits at all times.\n3. Your seatbelt must be on at all times.\n4. Your vehicle lights must be on at night.\n5. If you get in an accident, you must report it.\n6. You must park correctly at all times.",
				"Next",
				"Cancel");
			}
			else return SendClientMessageEx(playerid, COLOR_GREY, "You have cancelled the driving test.");
		}
		case DIALOG_DSVEH_RULES:
		{
			if(response)
			{
				ShowPlayerDialog(playerid, 
				DIALOG_DSVEH_TESTBASE,
				DIALOG_STYLE_LIST,
				"{FF0000}If you crash into a vehicle, you must...",
				"Run away\nDrive away\nReport the accident to your insurance and police.", "Choose", "Cancel");
			}
		}
		case DIALOG_DSVEH_TESTBASE:
		{
			if(response)
			{
				if(listitem == 2)
				{
					ShowPlayerDialog(playerid, 
					DIALOG_DSVEH_TESTBASE+1,
					DIALOG_STYLE_LIST,
					"{FF0000}You must drive on the LEFT side of the road..",
					"True\nFalse", "Choose", "Cancel");
				}
				else
				{
					return SendClientMessageEx(playerid, COLOR_GREY, "You have failed the test. Incorrect answer.");
				}
			}
		}
		case DIALOG_DSVEH_TESTBASE+1:
		{
			if(response)
			{
				if(listitem == 1)
				{
					ShowPlayerDialog(playerid, 
					DIALOG_DSVEH_TESTBASE+2,
					DIALOG_STYLE_LIST,
					"{FF0000}If the speed limit is 50mph, you must go..",
					"650mph\n120mph\n100mph\n50mph\n300mph\n430mph", "Choose", "Cancel");
				}
				else
				{
					return SendClientMessageEx(playerid, COLOR_GREY, "You have failed the test. Incorrect answer.");
				}
			}
		}
		case DIALOG_DSVEH_TESTBASE+2:
		{
			if(response)
			{
				if(listitem == 3)
				{
					ShowPlayerDialog(playerid, 
					DIALOG_DSVEH_TESTBASE+3,
					DIALOG_STYLE_LIST,
					"{FF0000}Your seatbelt must always be on.",
					"True\nFalse", "Choose", "Cancel");
				}
				else
				{
					return SendClientMessageEx(playerid, COLOR_GREY, "You have failed the test. Incorrect answer.");
				}
			}
		}
		case DIALOG_DSVEH_TESTBASE+3:
		{
			if(response)
			{
				if(listitem == 0)
				{
					SetPlayerVirtualWorld(playerid, 0);
					SetPlayerInterior(playerid, 0);
					SetPVarInt(playerid, "PTestVeh", CreateVehicle(404, 814.0655,-600.5410,16.0355, 90.0, 3, 3, -1));
					new pTestVeh = GetPVarInt(playerid, "PTestVeh");
					PutPlayerInVehicle(playerid, pTestVeh, 0);
					SendClientMessageEx(playerid, COLOR_WHITE, "Driving Instructor: Please make sure you go a max of 50mph in the residential areas. You may now begin.");
					if(!PlayerInfo[playerid][pSpeedo])
					{
						SendClientMessageEx(playerid, COLOR_WHITE, "Your speedometer has been enabled for you.");
						PlayerInfo[playerid][pSpeedo] = 1;
						ShowVehicleHUDForPlayer(playerid);
					}
					SetPVarInt(playerid, "PDTest", 1);
					DisablePlayerCheckpoint(playerid);
					SetPlayerCheckpoint(playerid, dsPoints[0][0], dsPoints[0][1], dsPoints[0][2], 4.0);
					SetPVarInt(playerid, "pTestMarker", 0);
					gPlayerCheckpointStatus[playerid] = CHECKPOINT_DRIVINGSCHOOL;
				}
				else
				{
					return SendClientMessageEx(playerid, COLOR_GREY, "You have failed the test. Incorrect answer.");
				}
			}
		}
		
		
	}
	return 1;
}