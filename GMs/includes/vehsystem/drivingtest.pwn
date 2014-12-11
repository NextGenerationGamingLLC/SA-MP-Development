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
{ 1021.3587,1375.9686,10.4787 }, 
{ 1009.7725,1410.5199,10.4034 },
{ 1010.3500,1485.8680,10.4052 },
{ 1010.5669,1577.8893,10.4036 },
{ 1009.5898,1697.4026,10.5067 },
{ 1009.4944,1793.5509,10.4032 },
{ 1068.6902,1811.0573,10.4038 },
{ 1190.8784,1811.0106,12.7297 },
{ 1254.9192,1810.6492,11.9946 }, 
{ 1312.7216,1810.4337,10.3953 },  
{ 1338.9166,1871.5557,10.4033 }, 
{ 1462.6924,1870.7106,10.4035 }, 
{ 1489.4149,1909.8195,10.4049 },
{ 1490.1340,1959.7477,10.4048 },  
{ 1518.4924,1970.2098,10.4050 },
{ 1569.9048,1993.4430,10.4043 },
{ 1608.5851,2009.9819,10.4234 },
{ 1677.6237,2010.8085,10.4051 },
{ 1708.7397,2039.5209,10.4099 },
{ 1790.5760,2050.9314,10.5613 },
{ 1891.3947,2041.3688,10.4051 },
{ 1976.6172,2019.6747,10.4052 },
{ 2062.7764,2020.0709,10.4055 },
{ 2112.5938,2019.5693,10.4115 },
{ 2124.6768,1939.6301,10.4044 },
{ 2124.3538,1865.9308,10.4048 },
{ 2064.5537,1743.0740,10.4093 },
{ 2044.7959,1663.9976,10.4049 },
{ 2044.5089,1560.0400,10.4040 },
{ 2016.2328,1457.0096,10.4049 },
{ 1914.2184,1455.7648,10.4050 },
{ 1755.4486,1455.3308,11.6902 },
{ 1732.3202,1502.4784,10.4032 },
{ 1727.1018,1559.4255,10.4014 },
{ 1739.1005,1627.4176,8.4988 },
{ 1779.3802,1579.1951,6.4675 },
{ 1785.9537,1337.2716,6.4676 },
{ 1785.0732,1118.0811,6.4752 },
{ 1677.4462,855.1962,7.1324 },
{ 1543.3982,855.0053,6.5456 },
{ 1363.7695,863.8972,6.5457 },
{ 1236.5439,999.0943,6.5543 },
{ 1228.5381,1144.3035,6.5456 },
{ 1230.1389,1288.7510,6.4766 },
{ 1229.8815,1533.6556,6.4676 },
{ 1237.1559,1674.5157,6.4887 },
{ 1296.2042,1800.9603,10.3773 },
{ 1232.1875,1815.8116,13.3062 }, 
{ 1155.5483,1816.2562,10.4021 }, 
{ 1059.6334,1816.2264,10.4047 },
{ 1005.1685,1786.8921,10.4037 }, 
{ 1004.7665,1679.5763,10.5066 }, 
{ 1004.4409,1587.5620,10.3814 }, 
{ 1004.0306,1472.0040,10.4051 }, 
{ 1063.9111,1371.4750,10.5395 },
{ 1148.1923,1369.2704,10.4042 }

};
//player_get_speed
// PVARS: pDTest (Is the player testing), pTestMarker (The marker the player is on),  pTestZone (Roads, Highways), pTestVeh (The vehicle the player is testing with)
new pFindDrive[MAX_PLAYERS];
new pDriveTimer[MAX_PLAYERS];

CMD:drivingtest(playerid,params[]){
	if(!IsPlayerInRangeOfPoint(playerid, 4.0, 1173.0698,1348.4688,10.9219)) 
	{
		SetPlayerCheckpoint(playerid, 1168.5768,1364.7848,10.8125, 2.0);
		pFindDrive[playerid] = 1;
		return SendClientMessageEx(playerid, COLOR_GREY, "You aren't at the driving school! Your GPS has been set to the location of the driving school.");
	}
	if(PlayerInfo[playerid][pCarLic] >= 1) return SendClientMessageEx(playerid, COLOR_GREY, "You already have your license!");
	ShowPlayerDialog(playerid,
	DIALOG_DSVEH_CAUTION,
	DIALOG_STYLE_MSGBOX,
	"DRIVING TEST",
	"{FE2C2C}READ CAREFULLY\n{FFFFFF}You are about to take the drivers license test.\nOn main roads, the speed limit is {FE2C2C}50{FFFFFF} and on the highway/freeway the speed limit is {FE2C2C}100{FFFFFF}.\nIf you exceed the speed limit you will fail the test however you can take it again.\nIf you are out of the vehicle for more than one minute, you will fail.", "Agree", "Disagree");
	return 1;
}

DrivingTestFinish(playerid)
{
	new pTestVeh = GetPVarInt(playerid, "PTestVeh");
	DestroyVehicle(pTestVeh);
	DeletePVar(playerid, "pTestVeh");
	DeletePVar(playerid, "pDTest");
	DeletePVar(playerid, "pTestMarker");
	DisablePlayerCheckpoint(playerid);
	PlayerInfo[playerid][pCarLic] = 1;
	SendClientMessageEx(playerid, COLOR_WHITE, "Driving Instructor: You have successfully completed driving school and earned your license!");
	return 1;
}

DrivingSchoolSpeedMeter(playerid, Float:speed)
{
	new pTestMarker = GetPVarInt(playerid, "pTestMarker");
	if(pTestMarker < 24 || (pTestMarker >= 30 && pTestMarker < 36) || pTestMarker >= 46)
	{
		if(speed > 50)
		{
			SetPlayerCheckpoint(playerid, 1138.3353,1375.6553,10.4057, 4.0);
			SendClientMessageEx(playerid, COLOR_GREY, "You have exceeded the resdiental speed limit of 50MPH, you have failed the test.");
			SetPVarInt(playerid, "pDTest", 2);
		}
	}
	else if(speed >= 100)
	{
		SetPlayerCheckpoint(playerid, 1138.3353,1375.6553,10.4057, 4.0);
		SendClientMessageEx(playerid, COLOR_GREY, "You have exceeded the freeway speed limit of 100MPH, you have failed the test.");
		SetPVarInt(playerid, "pDTest", 2);
	}
	return 1;
}

hook OnGameModeInit()
{
	CreateDynamicPickup(1239, 1, 1173.0698,1348.4688,10.9219);
	CreateDynamic3DTextLabel("/drivingtest to begin the driving test.", 0xFF0000FF, 1173.0698,1348.4688,10.9219,4.0);
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
			SendClientMessageEx(playerid, COLOR_YELLOW, "You have 60 secconds to get back in your vehicle or it will be taken back.");
		}
		else if(oldstate == PLAYER_STATE_ONFOOT && newstate == PLAYER_STATE_DRIVER && GetPlayerVehicleID(playerid) == pTestVeh)
		{
			KillTimer(pDriveTimer[playerid]);
		}
	}
	else if(oldstate == PLAYER_STATE_ONFOOT && newstate == PLAYER_STATE_DRIVER)
	{
		if(PlayerInfo[playerid][pCarLic] == 0)
		{
			SendClientMessageEx(playerid, COLOR_YELLOW, "Warning: You don't have a driver's license! To get one, go to the Driving School in Las Venturas. (/drivingtest)");
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
					SetPVarInt(playerid, "PTestVeh", CreateVehicle(404, 1138.3353,1375.6553,10.4057, 91.0917, 3, 3, -1));
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