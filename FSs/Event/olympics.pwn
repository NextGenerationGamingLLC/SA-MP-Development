/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

				Next Generation Gaming, LLC
	(created by Next Generation Gaming Development Team)

	Developers:
		(***) Austin


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
*
*/

#include <a_samp>
#include <sscanf2>
#include <streamer>
#include <zcmd>

#undef MAX_PLAYERS
#define MAX_PLAYERS (700)

/* Configuration */
enum playerEnum
{
	lastInts[2], /* int and vw */
	Float:lastPos[3],
	Float:startPos[3],
	startNum,
	totalLaps,
	hasBike,
	Bike,
};

new TotalPlayers[16];
new pEnum[MAX_PLAYERS][playerEnum];
new locked = 1;
new currentevent = 1;
new winners;
new CheckPoint[MAX_PLAYERS];

new Float:EventTwoPoints[10][3] =
{
	{792.4673,-1048.8589,24.7549},
	{1470.3225,-954.7247,36.1328},
	{2838.8091,-1140.6960,13.0920},
	{2789.6284,-2137.0974,11.1016},
	{2166.3186,-2558.0132,13.5469},
	{1327.2213,-2531.5876,13.5469},
	{1034.0588,-2076.9736,13.5469},
	{628.2008,-1739.3252,13.1892},
	{146.3817,-1564.6563,10.8006},
	{146.3817,-1564.6563,10.8006}
};

new Float:EventOnePoints[16][3] =
{
	{1008.2152,1371.0046,10.8477},
	{1007.4658,1964.6687,10.8477},
	{1276.6271,2053.6201,10.8477},
	{1566.3115,2049.5422,10.8477},
	{1564.8070,1979.3719,10.8477},
	{1486.8209,1874.6790,10.8477},
	{1569.1644,1717.5342,10.8477},
	{1714.4003,1714.9780,10.8477},
	{1733.1749,1617.2562,9.6511},
	{1713.1616,1446.7147,10.5315},
	{1725.8047,1276.9359,10.5315},
	{1650.3882,1269.0944,10.5315},
	{1645.4132,1133.3412,10.5315},
	{1455.7582,1134.7889,10.5315},
	{1015.2450,1193.5031,10.5315}, // 1445.4365,1192.0273,10.5315
	{1015.2450,1193.5031,10.5315}
};

CMD:ogoto(playerid, params[])
{
	if(!IsPlayerAdmin(playerid)) return 1;
	new num, event;
	if(!sscanf(params, "dd", event,num))
	{
		if(event == 1) SetPlayerPos(playerid, EventOnePoints[num][0], EventOnePoints[num][1], EventOnePoints[num][2]);
		if(event == 2) SetPlayerPos(playerid, EventTwoPoints[num][0], EventTwoPoints[num][1], EventTwoPoints[num][2]);
	}
	return 1;
}

/* Callbacks */
public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" Olympic Event by Austin initialized");
	print("--------------------------------------\n");

	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		RemBuildings(i);
		pEnum[i][lastInts][0] = 0;
		pEnum[i][lastInts][1] = 0;
		pEnum[i][startPos][0] = 0.0;
		pEnum[i][startPos][1] = 0.0;
		pEnum[i][startPos][2] = 0.0;
		pEnum[i][startNum] = -1;
		pEnum[i][hasBike] = 0;
		pEnum[i][Bike] = INVALID_VEHICLE_ID;
		pEnum[i][totalLaps] = 0;
		CheckPoint[i] = 0;
	}
	LoadObjects();
	return 1;
}

public OnFilterScriptExit()
{
	EndOlympics();
	return 1;
}

public OnPlayerConnect(playerid)
{
	RemBuildings(playerid);
	pEnum[playerid][lastInts][0] = 0;
	pEnum[playerid][lastInts][1] = 0;
	pEnum[playerid][startPos][0] = 0.0;
	pEnum[playerid][startPos][1] = 0.0;
	pEnum[playerid][startPos][2] = 0.0;
	pEnum[playerid][startNum] = -1;
	pEnum[playerid][hasBike] = 0;
	pEnum[playerid][Bike] = INVALID_VEHICLE_ID;
	pEnum[playerid][totalLaps] = 0;
	CheckPoint[playerid] = 0;
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	if(pEnum[playerid][hasBike]) DestroyVehicle(pEnum[playerid][Bike]);
	pEnum[playerid][lastInts][0] = 0;
	pEnum[playerid][lastInts][1] = 0;
	pEnum[playerid][startPos][0] = 0.0;
	pEnum[playerid][startPos][1] = 0.0;
	pEnum[playerid][startPos][2] = 0.0;
	pEnum[playerid][startNum] = -1;
	pEnum[playerid][hasBike] = 0;
	pEnum[playerid][Bike] = INVALID_VEHICLE_ID;
	pEnum[playerid][totalLaps] = 0;
	CheckPoint[playerid] = 0;
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	new string[128], playerName[24];
	DisablePlayerRaceCheckpoint(playerid);
	CheckPoint[playerid]++;
	pEnum[playerid][totalLaps]++;

	if(currentevent == 1)
	{
		if(CheckPoint[playerid] == 15 && pEnum[playerid][totalLaps] < 15)
		{
			CheckPoint[playerid] = 0;
		}
		if(pEnum[playerid][totalLaps] == 14)
		{
			GameTextForPlayer(playerid, "~r~Final Point", 2000, 4);
			SetPlayerRaceCheckpoint(playerid, 1, EventOnePoints[CheckPoint[playerid]][0], EventOnePoints[CheckPoint[playerid]][1], EventOnePoints[CheckPoint[playerid]][2], EventOnePoints[CheckPoint[playerid]+1][0], EventOnePoints[CheckPoint[playerid]+1][1], EventOnePoints[CheckPoint[playerid]+1][2], 10);
		}
		else if(pEnum[playerid][totalLaps] == 15)
		{
			winners++;
			GetPlayerName(playerid, playerName, 24);
			if(winners == 1)
			{
				format(string, sizeof(string), "%s has come in first place during the Olympics Event!", playerName);
				SendClientMessageToAll(0xDAA520FF, string);
			}
			else if(winners == 2)
			{
				format(string, sizeof(string), "%s has come in second place during the Olympics Event!", playerName);
				SendClientMessageToAll(0xDAA520FF, string);
			}
			else if(winners == 3)
			{
				format(string, sizeof(string), "%s has come in third place during the Olympics Event!", playerName);
				SendClientMessageToAll(0xDAA520FF, string);
			}
			else
			{
				SendClientMessage(playerid, -1, "You have completed the event, but did not come in any place. Thanks for participating!");
			}
		}
		else if(pEnum[playerid][totalLaps] < 14)
		{
			SetPlayerRaceCheckpoint(playerid, 0, EventOnePoints[CheckPoint[playerid]][0], EventOnePoints[CheckPoint[playerid]][1], EventOnePoints[CheckPoint[playerid]][2], EventOnePoints[CheckPoint[playerid]+1][0], EventOnePoints[CheckPoint[playerid]+1][1], EventOnePoints[CheckPoint[playerid]+1][2], 10);
		}
	}
	else
	{
		if(CheckPoint[playerid] == 9 && pEnum[playerid][totalLaps] < 9)
		{
			CheckPoint[playerid] = 0;
		}
		if(pEnum[playerid][totalLaps] == 8)
		{
			GameTextForPlayer(playerid, "~r~Final Point", 2000, 4);
			SetPlayerRaceCheckpoint(playerid, 1, EventTwoPoints[CheckPoint[playerid]][0], EventTwoPoints[CheckPoint[playerid]][1], EventTwoPoints[CheckPoint[playerid]][2], EventTwoPoints[CheckPoint[playerid]+1][0], EventTwoPoints[CheckPoint[playerid]+1][1], EventTwoPoints[CheckPoint[playerid]+1][2], 10);
		}
		else if(pEnum[playerid][totalLaps] == 9)
		{
			winners++;
			GetPlayerName(playerid, playerName, 24);
			if(winners == 1)
			{
				format(string, sizeof(string), "%s has come in first place during the Olympics Event!", playerName);
				SendClientMessageToAll(0xDAA520FF, string);
			}
			else if(winners == 2)
			{
				format(string, sizeof(string), "%s has come in second place during the Olympics Event!", playerName);
				SendClientMessageToAll(0xDAA520FF, string);
			}
			else if(winners == 3)
			{
				format(string, sizeof(string), "%s has come in third place during the Olympics Event!", playerName);
				SendClientMessageToAll(0xDAA520FF, string);
			}
			else
			{
				SendClientMessage(playerid, -1, "You have completed the event, but did not come in any place. Thanks for participating!");
			}
		}
		else if(pEnum[playerid][totalLaps] < 8)
		{
			SetPlayerRaceCheckpoint(playerid, 0, EventTwoPoints[CheckPoint[playerid]][0], EventTwoPoints[CheckPoint[playerid]][1], EventTwoPoints[CheckPoint[playerid]][2], EventTwoPoints[CheckPoint[playerid]+1][0], EventTwoPoints[CheckPoint[playerid]+1][1], EventTwoPoints[CheckPoint[playerid]+1][2], 10);
		}
	}
	return 1;
}

/* Commands */
CMD:joinolympics(playerid, params[])
{
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "Please exit your vehicle before joining.");
	if(GetPlayerColor(playerid) == 0x9C791200 || GetPlayerColor(playerid) == 0xFF800000 || GetPVarInt(playerid, "PlayerCuffed") > 0 || GetPVarInt(playerid, "Injured") == 1 || GetPVarInt(playerid, "IsInArena") >= 0)
		return SendClientMessage(playerid, -1, "You cannot use this command at this time.");
	if(locked) return SendClientMessage(playerid, -1, "The event is currently locked.");

	if(pEnum[playerid][startPos][0] == 0.0 && pEnum[playerid][startPos][1] == 0.0 && pEnum[playerid][startPos][2] == 0.0)
	{
		if(currentevent == 1)
		{
			for(new i = 0; i < 4; i++)
			{
				if(TotalPlayers[i] < 50)
				{
					new Float:pos[3];
					GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
					pEnum[playerid][lastPos][0] = pos[0];
					pEnum[playerid][lastPos][1] = pos[1];
					pEnum[playerid][lastPos][2] = pos[2];
					pEnum[playerid][lastInts][0] = GetPlayerInterior(playerid);
					pEnum[playerid][lastInts][1] = GetPlayerVirtualWorld(playerid);

					TotalPlayers[i]++;

					pEnum[playerid][startNum] = i;
					pEnum[playerid][startPos][0] = EventOnePoints[i][0];
					pEnum[playerid][startPos][1] = EventOnePoints[i][1];
					pEnum[playerid][startPos][2] = EventOnePoints[i][2];

					SetPlayerVirtualWorld(playerid, 1);
					SetPlayerInterior(playerid, 0);
					DisablePlayerCheckpoint(playerid);
					DisablePlayerRaceCheckpoint(playerid);
					SetPlayerFacingAngle(playerid, 0);
					if(i==2) SetPlayerFacingAngle(playerid, 270);
					if(i==3) SetPlayerFacingAngle(playerid, 180);
					ResetPlayerWeapons(playerid);
					TogglePlayerControllable(playerid, 0);
					SetCameraBehindPlayer(playerid);
					SetPlayerPos(playerid, pEnum[playerid][startPos][0], pEnum[playerid][startPos][1]+random(5), pEnum[playerid][startPos][2]);

					new next = i + 1;
					CheckPoint[playerid] = next;
					SetPlayerRaceCheckpoint(playerid, 1, EventOnePoints[next][0], EventOnePoints[next][1], EventOnePoints[next][2], EventOnePoints[next+1][0], EventOnePoints[next+1][1], EventOnePoints[next+1][2], 10);
					break;
				}
	 		}
		 	if(pEnum[playerid][startNum] == -1)
		 	{
		 		SendClientMessage(playerid, -1, "Sorry, but the event spots are all filled.");
		 	}
		}
		else
		{
			for(new i = 0; i < 4; i++) // spread among four, not 9
			{
				if(TotalPlayers[i] < 50)
				{
					new Float:pos[3];
					GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
					pEnum[playerid][lastPos][0] = pos[0];
					pEnum[playerid][lastPos][1] = pos[1];
					pEnum[playerid][lastPos][2] = pos[2];
					pEnum[playerid][lastInts][0] = GetPlayerInterior(playerid);
					pEnum[playerid][lastInts][1] = GetPlayerVirtualWorld(playerid);

					TotalPlayers[i]++;

					pEnum[playerid][startNum] = i;
					pEnum[playerid][startPos][0] = EventTwoPoints[i][0];
					pEnum[playerid][startPos][1] = EventTwoPoints[i][1];
					pEnum[playerid][startPos][2] = EventTwoPoints[i][2];

					SetPlayerVirtualWorld(playerid, 1);
					SetPlayerInterior(playerid, 0);
					DisablePlayerCheckpoint(playerid);
					DisablePlayerRaceCheckpoint(playerid);

					ResetPlayerWeapons(playerid);

					new col = random(5);
					pEnum[playerid][hasBike] = 1;
					pEnum[playerid][Bike] = CreateVehicle(481,  pEnum[playerid][startPos][0], pEnum[playerid][startPos][1]+random(5), pEnum[playerid][startPos][2], (i==3)?130:285, col, col, 200000);
					new engine,lights,alarm,doors,bonnet,boot,objective;
					GetVehicleParamsEx(pEnum[playerid][Bike],engine,lights,alarm,doors,bonnet,boot,objective);
					SetVehicleParamsEx(pEnum[playerid][Bike], VEHICLE_PARAMS_ON, lights,alarm,doors,bonnet,boot,objective);
					SetVehicleVirtualWorld(pEnum[playerid][Bike], 1);
					PutPlayerInVehicle(playerid, pEnum[playerid][Bike], 0);
					TogglePlayerControllable(playerid, 0);
					SetCameraBehindPlayer(playerid);

					new next = i + 1;
					CheckPoint[playerid] = next;
					SetPlayerRaceCheckpoint(playerid, 1, EventTwoPoints[next][0], EventTwoPoints[next][1], EventTwoPoints[next][2], EventTwoPoints[next+1][0], EventTwoPoints[next+1][1], EventTwoPoints[next+1][2], 10);
					break;
				}
	 		}
		 	if(pEnum[playerid][startNum] == -1)
		 	{
		 		SendClientMessage(playerid, -1, "Sorry, but the event spots are all filled.");
		 	}
		}
	}
	else
	{
		SendClientMessage(playerid, -1, "You are already in the event.");
	}
	return 1;
}

CMD:exitolympics(playerid, params[])
{
	if(pEnum[playerid][startPos][0] != 0.0 && pEnum[playerid][startPos][1] != 0.0 && pEnum[playerid][startPos][2] != 0.0)
	{
		pEnum[playerid][lastInts][0] = 0;
		pEnum[playerid][lastInts][1] = 0;
		pEnum[playerid][startPos][0] = 0.0;
		pEnum[playerid][startPos][1] = 0.0;
		pEnum[playerid][startPos][2] = 0.0;
		pEnum[playerid][startNum] = -1;
		if(pEnum[playerid][hasBike]) DestroyVehicle(pEnum[playerid][Bike]);
		pEnum[playerid][hasBike] = 0;
		pEnum[playerid][Bike] = INVALID_VEHICLE_ID;
		pEnum[playerid][totalLaps] = 0;
		TogglePlayerControllable(playerid, 0);

		CallRemoteFunction("Player_StreamPrep", "ifffi", playerid, pEnum[playerid][lastPos][0], pEnum[playerid][lastPos][1], pEnum[playerid][lastPos][2], 2500);
		SetPlayerInterior(playerid, pEnum[playerid][lastInts][0]);
		SetPlayerVirtualWorld(playerid, pEnum[playerid][lastInts][1]);
		CallRemoteFunction("SetPlayerWeapons", "i", playerid);
		DisablePlayerRaceCheckpoint(playerid);
		SendClientMessage(playerid, -1, "You have left the olympics and have been set back to your last position.");
	}
	else
	{
		SendClientMessage(playerid, -1, "You are not in the event.");
	}
	return 1;
}

CMD:obmxcountdown(playerid, params[])
{
	if(IsPlayerAdmin(playerid) || GetPVarInt(playerid, "aLvl") >= 4 || GetPVarInt(playerid, "oStaff") == 1)
	{
		SetTimerEx("CountDown", 100, false, "i", 1);
	}
	else
	{
		SendClientMessage(playerid, -1, "You are not authorized to use this command!");
	}
	return 1;
}

CMD:currentevent(playerid, params[])
{
	if(IsPlayerAdmin(playerid) || GetPVarInt(playerid, "aLvl") >= 4 || GetPVarInt(playerid, "oStaff") == 1)
	{
		new to, string[32];
		if(sscanf(params, "d", to))
		{
			SendClientMessage(playerid, -1, "Usage: /currentevent [1-2]");
			SendClientMessage(playerid, -1, "1 is for the event in LV and 2 is for the LS event.");
			return 1;
		}
		currentevent = to;
		format(string, sizeof(string), "You have set the event to %s", (currentevent == 1) ? ("LV") : ("LS"));
		SendClientMessage(playerid, -1, string);
	}
	else
	{
		SendClientMessage(playerid, -1, "You are not authorized to use this command!");
	}
	return 1;
}

CMD:lockolympics(playerid, params[])
{
	if(IsPlayerAdmin(playerid) || GetPVarInt(playerid, "aLvl") >= 4 || GetPVarInt(playerid, "oStaff") == 1)
	{
		new to, string[36];
		if(sscanf(params, "d", to))
		{
			SendClientMessage(playerid, -1, "Usage: /lockolympics [0-1]");
			SendClientMessage(playerid, -1, "0 is to unlock the event and 1 will lock it.");
			return 1;
		}
		locked = to;
		format(string, sizeof(string), "You have set the event to %s", (locked == 0) ? ("unlocked") : ("locked"));
		SendClientMessage(playerid, -1, string);
	}
	else
	{
		SendClientMessage(playerid, -1, "You are not authorized to use this command!");
	}
	return 1;
}

CMD:endolympics(playerid, params[])
{
	return (IsPlayerAdmin(playerid) || GetPVarInt(playerid, "aLvl") >= 4 || GetPVarInt(playerid, "oStaff") == 1) ? EndOlympics()
			: SendClientMessage(playerid, -1, "You are not authorized to use this command!");
}

CMD:ohelp(playerid, params[])
{
	if(IsPlayerAdmin(playerid) || GetPVarInt(playerid, "aLvl") >= 4 || GetPVarInt(playerid, "oStaff") == 1)
	{
		SendClientMessage(playerid, 0xE3E3E3FF, "*** {FF0000}EVENT COORDINATOR{E3E3E3} *** /endolympics /lockolympics /obmxcountdown /currentevent /makeostaff");
		SendClientMessage(playerid, -1, "/endolympics and /obmxcountdown do not have parameters and work as soon as you type them. Do be careful.");
	}
	SendClientMessage(playerid, 0xE3E3E3FF, "*** OLYMPICS *** /joinolympics /exitolympics");
	return 1;
}

CMD:makeostaff(playerid, params[])
{
	if(IsPlayerAdmin(playerid) || GetPVarInt(playerid, "aLvl") >= 4)
	{
		new target;
		if(sscanf(params, "u", target)) return SendClientMessage(playerid, -1, "Usage: /makeostaff [playerid]");
		new name[24], string[128];
		GetPlayerName(target, name, 24);
		if(GetPVarInt(target, "oStaff") == 0)
		{
			SetPVarInt(target, "oStaff", 1);
			format(string, sizeof(string), "You have given %s (ID:%d) access to the Olympic's admin commands.", name, target);
			SendClientMessage(playerid, -1, string);
  		}
  		else
  		{
			format(string, sizeof(string), "You have revoked %s (ID:%d) access to the Olympic's admin commands.", name, target);
			DeletePVar(target, "oStaff");
		}
	}
	return 1;
}

/* essentially starts the event, unfreezing everyone in. */
forward CountDown(num);
public CountDown(num)
{
	switch(num)
	{
		case 1:
		{
			SendClientMessageToAll(0x33CCFFFF, "3");
			SetTimerEx("CountDown", 1000, false, "i", 2);
		}
		case 2:
		{
			SendClientMessageToAll(0x33CCFFFF, "2");
			SetTimerEx("CountDown", 1000, false, "i", 3);
		}
		case 3:
		{
			SendClientMessageToAll(0x33CCFFFF, "1");
			locked = 1;
			SetTimerEx("CountDown", 800, false, "i", 4);
		}
		case 4: // Go!
		{
			SendClientMessageToAll(0x33CCFFFF, "Go!");
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if(pEnum[i][startPos][0] != 0.0 && pEnum[i][startPos][1] != 0.0 && pEnum[i][startPos][2] != 0.0)
				{
					TogglePlayerControllable(i, 1);
				}
			}
		}
	}
}

/*forward FreezeHandler(playerid);
public FreezeHandler(playerid)
{
	TogglePlayerControllable(playerid, 1);
}*/

forward EndOlympics();
public EndOlympics()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(pEnum[i][startPos][0] != 0.0 && pEnum[i][startPos][1] != 0.0 && pEnum[i][startPos][2] != 0.0)
		{
			cmd_exitolympics(i, " ");
		}
	}
	for(new i = 0; i < 16; i++)
	{
		TotalPlayers[i] = 0;
	}
	locked = 1;
	winners = 0;
	return 1;
}

RemBuildings(playerid)
{
	if(GetPVarInt(playerid, "RemOlympic") == 0)
	{
		RemoveBuildingForPlayer(playerid, 1215, 1035.4453, 1383.3984, 10.3750, 0.25);
		RemoveBuildingForPlayer(playerid, 1215, 1045.3594, 1383.3984, 10.3750, 0.25);
		RemoveBuildingForPlayer(playerid, 1215, 1055.5859, 1383.3984, 10.3750, 0.25);
		RemoveBuildingForPlayer(playerid, 1215, 1074.8438, 1383.3984, 10.3750, 0.25);
		RemoveBuildingForPlayer(playerid, 1215, 1065.7109, 1383.3984, 10.3750, 0.25);
		RemoveBuildingForPlayer(playerid, 1256, 1040.4844, 1393.7109, 5.4766, 0.25);
		RemoveBuildingForPlayer(playerid, 1256, 1045.3594, 1393.7109, 5.4766, 0.25);
		RemoveBuildingForPlayer(playerid, 1256, 1050.7422, 1393.7109, 5.4766, 0.25);
		RemoveBuildingForPlayer(playerid, 1256, 1066.1953, 1393.7109, 5.4766, 0.25);
		RemoveBuildingForPlayer(playerid, 1256, 1071.8359, 1393.7109, 5.4766, 0.25);
		RemoveBuildingForPlayer(playerid, 640, 1040.1016, 1722.8672, 10.5156, 0.25);
		RemoveBuildingForPlayer(playerid, 1215, 1029.5938, 1723.0469, 10.3750, 0.25);
		RemoveBuildingForPlayer(playerid, 1215, 1049.2344, 1723.0469, 10.3750, 0.25);
		RemoveBuildingForPlayer(playerid, 640, 1058.0625, 1722.8672, 10.5156, 0.25);
		RemoveBuildingForPlayer(playerid, 1215, 1067.9063, 1723.0469, 10.3750, 0.25);
		RemoveBuildingForPlayer(playerid, 640, 1077.2500, 1722.8672, 10.5156, 0.25);
		RemoveBuildingForPlayer(playerid, 1412, 1082.5391, 1799.9453, 12.6484, 0.25);
		RemoveBuildingForPlayer(playerid, 1215, 1087.0078, 1723.0469, 10.3750, 0.25);
		RemoveBuildingForPlayer(playerid, 1412, 1087.8125, 1799.9453, 12.6484, 0.25);
		RemoveBuildingForPlayer(playerid, 1412, 1093.0938, 1799.9453, 12.6484, 0.25);
		RemoveBuildingForPlayer(playerid, 640, 1096.8281, 1722.8672, 10.5156, 0.25);
		RemoveBuildingForPlayer(playerid, 1412, 1098.3672, 1799.9453, 12.6484, 0.25);
		RemoveBuildingForPlayer(playerid, 1412, 1103.6406, 1799.9453, 12.6484, 0.25);
		RemoveBuildingForPlayer(playerid, 1215, 1105.4375, 1723.0469, 10.3750, 0.25);
		RemoveBuildingForPlayer(playerid, 1215, 1130.9844, 1383.3984, 10.3750, 0.25);
		RemoveBuildingForPlayer(playerid, 1215, 1121.0703, 1383.3984, 10.3750, 0.25);
		RemoveBuildingForPlayer(playerid, 1215, 1151.3438, 1383.3984, 10.3750, 0.25);
		RemoveBuildingForPlayer(playerid, 1215, 1141.2109, 1383.3984, 10.3750, 0.25);
		RemoveBuildingForPlayer(playerid, 1256, 1125.5703, 1393.7109, 5.4766, 0.25);
		RemoveBuildingForPlayer(playerid, 1256, 1131.2109, 1393.7109, 5.4766, 0.25);
		RemoveBuildingForPlayer(playerid, 1256, 1144.3281, 1393.7109, 5.4766, 0.25);
		RemoveBuildingForPlayer(playerid, 1256, 1149.2031, 1393.7109, 5.4766, 0.25);
		RemoveBuildingForPlayer(playerid, 1256, 1154.5859, 1393.7109, 5.4766, 0.25);
		RemoveBuildingForPlayer(playerid, 640, 1113.7266, 1722.8672, 10.5156, 0.25);
		RemoveBuildingForPlayer(playerid, 1412, 1116.8672, 1770.8672, 12.6484, 0.25);
		RemoveBuildingForPlayer(playerid, 1412, 1116.8672, 1776.1406, 12.6484, 0.25);
		RemoveBuildingForPlayer(playerid, 1412, 1116.8672, 1765.5859, 12.6484, 0.25);
		RemoveBuildingForPlayer(playerid, 1412, 1114.1953, 1799.9453, 12.6484, 0.25);
		RemoveBuildingForPlayer(playerid, 1412, 1108.9219, 1799.9453, 12.6484, 0.25);
		RemoveBuildingForPlayer(playerid, 1412, 1116.8672, 1797.2891, 12.6484, 0.25);
		RemoveBuildingForPlayer(playerid, 1412, 1116.8672, 1792.0078, 12.6484, 0.25);
		RemoveBuildingForPlayer(playerid, 1412, 1116.8672, 1781.4219, 12.6484, 0.25);
		RemoveBuildingForPlayer(playerid, 1412, 1116.8672, 1786.6953, 12.6484, 0.25);
		RemoveBuildingForPlayer(playerid, 1412, 1118.6484, 1760.9453, 12.6484, 0.25);
		RemoveBuildingForPlayer(playerid, 1412, 1122.0547, 1756.9141, 12.6484, 0.25);
		RemoveBuildingForPlayer(playerid, 1215, 1160.4766, 1383.3984, 10.3750, 0.25);
		SetPVarInt(playerid, "RemOlympic",  1);
	}
	return 1;
}

LoadObjects()
{
	CreateDynamic3DTextLabel("/viplocker\nTo open the VIP locker.",0xFFFF00AA,1378.0017, 1747.4668, 927.3564+0.6,4.0);
	CreateDynamicPickup(1239, 23, 1378.0894, 1740.0106, 927.3564);
	//LV Stadium
	CreateDynamicObject(8673, 1088.75, 1799.90, 12.80,   0.00, 0.00, 0.00);
	CreateDynamicObject(8673, 1107.30, 1799.90, 12.80,   0.00, 0.00, 0.00);
	CreateDynamicObject(8673, 1117.30, 1789.90, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1117.30, 1773.21, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1123.50, 1755.00, 12.80,   0.00, 0.00, 128.25);
	CreateDynamicObject(8673, 1132.90, 1737.30, 12.80,   0.00, 0.00, 107.25);
	CreateDynamicObject(8673, 1136.40, 1725.90, 3.84,   0.00, 90.00, 286.00);
	CreateDynamicObject(8673, 1136.80, 1724.48, 3.84,   0.00, 90.00, 286.00);
	CreateDynamicObject(8673, 1147.20, 1723.10, 12.80,   0.00, 0.00, 0.00);
	CreateDynamicObject(8673, 1167.30, 1702.70, 12.80,   0.00, 0.00, 0.00);
	CreateDynamicObject(8673, 1157.20, 1712.70, 12.80,   0.00, 0.00, 270.00);
	CreateDynamicObject(8673, 1177.30, 1692.70, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1177.30, 1672.30, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1177.30, 1651.90, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1177.30, 1631.50, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1177.30, 1611.10, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1177.30, 1590.70, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1177.30, 1570.30, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1177.30, 1549.90, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1177.30, 1529.50, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1177.30, 1509.10, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1177.30, 1488.70, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1177.30, 1468.30, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1177.30, 1447.90, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1177.30, 1427.50, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1177.30, 1407.10, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1177.30, 1394.12, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(969, 1171.40, 1383.30, 9.80,   0.00, 0.00, 180.00);
	CreateDynamicObject(2774, 1172.40, 1383.20, 1.70,   0.00, 0.00, 0.00);
	CreateDynamicObject(2774, 1177.00, 1383.30, 1.60,   0.00, 0.00, 0.00);
	CreateDynamicObject(8673, 1173.30, 1383.30, 3.80,   0.00, 90.00, 0.00);
	CreateDynamicObject(8673, 1176.20, 1383.30, 3.80,   0.00, 90.00, 0.00);
	CreateDynamicObject(8673, 1152.30, 1383.40, 11.20,   0.00, 0.00, 0.00);
	CreateDynamicObject(8673, 1131.90, 1383.40, 11.20,   0.00, 0.00, 0.00);
	CreateDynamicObject(8673, 1113.35, 1383.40, 11.20,   0.00, 0.00, 0.00);
	CreateDynamicObject(8673, 1083.30, 1383.40, 11.20,   0.00, 0.00, 0.00);
	CreateDynamicObject(8673, 1062.90, 1383.40, 11.20,   0.00, 0.00, 0.00);
	CreateDynamicObject(8673, 1044.35, 1383.40, 11.20,   0.00, 0.00, 0.00);
	CreateDynamicObject(2774, 1103.30, 1383.90, 1.70,   0.00, 0.00, 0.00);
	CreateDynamicObject(2774, 1092.90, 1383.90, 1.70,   0.00, 0.00, 0.00);
	CreateDynamicObject(2774, 1033.10, 1383.50, 1.70,   0.00, 0.00, 0.00);
	CreateDynamicObject(2774, 1021.90, 1383.50, 1.70,   0.00, 0.00, 0.00);
	CreateDynamicObject(2774, 1017.90, 1383.60, 1.70,   0.00, 0.00, 0.00);
	CreateDynamicObject(8673, 1019.80, 1383.30, 3.80,   0.00, 90.00, 0.00);
	CreateDynamicObject(8673, 1017.40, 1394.70, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1017.40, 1415.10, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1017.40, 1435.50, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1017.40, 1455.90, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1017.40, 1476.30, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1017.40, 1496.70, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1017.40, 1517.10, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1017.40, 1537.50, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1017.40, 1557.90, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1017.40, 1578.30, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1017.40, 1598.70, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1017.40, 1619.10, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1017.40, 1639.50, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1017.40, 1659.90, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1017.40, 1680.30, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1017.40, 1693.20, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1018.88, 1703.20, 3.84,   0.00, 90.00, 0.00);
	CreateDynamicObject(8673, 1021.80, 1703.20, 3.84,   0.00, 90.00, 0.00);
	CreateDynamicObject(8673, 1020.70, 1713.60, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1020.70, 1734.00, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1020.70, 1754.40, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1020.70, 1774.80, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1020.70, 1789.64, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1030.70, 1799.90, 12.80,   0.00, 0.00, 180.00);
	CreateDynamicObject(8673, 1030.70, 1799.90, 9.90,   0.00, 0.00, 179.99);
	CreateDynamicObject(8843, 1050.80, 1794.50, 9.83,   0.00, 0.00, 180.00);
	CreateDynamicObject(8843, 1060.70, 1794.60, 9.83,   0.00, 0.00, 0.00);
	CreateDynamicObject(9339, 1033.60, 1799.90, 10.50,   0.00, 0.00, 90.00);
	CreateDynamicObject(9339, 1104.40, 1799.90, 10.50,   0.00, 0.00, 90.00);
	CreateDynamicObject(9339, 1078.30, 1799.90, 10.50,   0.00, 0.00, 90.00);
	CreateDynamicObject(9339, 1078.30, 1799.90, 11.90,   0.00, 0.00, 90.00);
	CreateDynamicObject(9339, 1104.40, 1799.90, 11.90,   0.00, 0.00, 90.00);
	CreateDynamicObject(9339, 1033.60, 1799.90, 11.90,   0.00, 0.00, 90.00);
	CreateDynamicObject(8041, 1056.00, 1800.40, 15.60,   0.00, 0.00, 90.00);
	CreateDynamicObject(973, 1047.40, 1794.80, 10.50,   0.00, 0.00, 270.00);
	CreateDynamicObject(973, 1055.30, 1794.10, 10.50,   0.00, 0.00, 90.00);
	CreateDynamicObject(973, 1056.60, 1794.10, 10.50,   0.00, 0.00, 270.00);
	CreateDynamicObject(973, 1064.60, 1794.70, 10.50,   0.00, 0.00, 90.00);
	CreateDynamicObject(1597, 1055.90, 1775.10, 12.50,   0.00, 0.00, 0.00);
	CreateDynamicObject(1597, 1055.90, 1755.50, 12.50,   0.00, 0.00, 0.00);
	CreateDynamicObject(1597, 1055.90, 1735.70, 12.50,   0.00, 0.00, 0.00);
	CreateDynamicObject(1597, 1026.60, 1741.70, 12.50,   0.00, 0.00, 90.00);
	CreateDynamicObject(1597, 1026.60, 1760.60, 12.50,   0.00, 0.00, 90.00);
	CreateDynamicObject(1597, 1026.60, 1779.60, 12.50,   0.00, 0.00, 90.00);
	CreateDynamicObject(1597, 1036.30, 1779.60, 12.50,   0.00, 0.00, 90.00);
	CreateDynamicObject(1597, 1036.30, 1760.60, 12.50,   0.00, 0.00, 90.00);
	CreateDynamicObject(1597, 1036.30, 1741.70, 12.50,   0.00, 0.00, 90.00);
	CreateDynamicObject(1597, 1111.50, 1760.60, 12.50,   0.00, 0.00, 90.00);
	CreateDynamicObject(1597, 1101.80, 1741.70, 12.50,   0.00, 0.00, 90.00);
	CreateDynamicObject(1597, 1111.50, 1741.70, 12.50,   0.00, 0.00, 90.00);
	CreateDynamicObject(1597, 1101.80, 1760.60, 12.50,   0.00, 0.00, 90.00);
	CreateDynamicObject(1597, 1111.50, 1779.60, 12.50,   0.00, 0.00, 90.00);
	CreateDynamicObject(1597, 1101.80, 1779.60, 12.50,   0.00, 0.00, 90.00);
	CreateDynamicObject(1597, 1092.10, 1779.60, 12.50,   0.00, 0.00, 90.00);
	CreateDynamicObject(1597, 1092.10, 1760.60, 12.50,   0.00, 0.00, 90.00);
	CreateDynamicObject(1597, 1092.10, 1741.70, 12.50,   0.00, 0.00, 90.00);
	CreateDynamicObject(1597, 1072.00, 1775.10, 12.50,   0.00, 0.00, 0.00);
	CreateDynamicObject(1597, 1072.00, 1755.50, 12.50,   0.00, 0.00, 0.00);
	CreateDynamicObject(1597, 1072.00, 1735.70, 12.50,   0.00, 0.00, 0.00);
	CreateDynamicObject(3626, 1151.70, 1719.80, 11.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(3626, 1142.30, 1719.80, 11.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(3626, 1140.10, 1708.40, 11.40,   0.00, 0.00, 90.00);
	CreateDynamicObject(3626, 1146.80, 1701.80, 11.40,   0.00, 0.00, 180.00);
	CreateDynamicObject(983, 1137.80, 1719.00, 10.50,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, 1137.80, 1709.90, 10.50,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, 1137.80, 1706.70, 10.50,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, 1141.10, 1699.50, 10.50,   0.00, 0.00, 90.00);
	CreateDynamicObject(983, 1147.50, 1699.50, 10.50,   0.00, 0.00, 90.00);
	CreateDynamicObject(1616, 1137.50, 1710.00, 12.90,   0.00, 0.00, 0.00);
	CreateDynamicObject(11611, 1138.10, 1710.70, 13.20,   0.00, 0.00, 45.25);
	CreateDynamicObject(8673, 1088.75, 1799.90, 12.80,   0.00, 0.00, 0.00);
	CreateDynamicObject(8673, 1107.30, 1799.90, 12.80,   0.00, 0.00, 0.00);
	CreateDynamicObject(8673, 1117.30, 1789.90, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1117.30, 1773.21, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1123.50, 1755.00, 12.80,   0.00, 0.00, 128.25);
	CreateDynamicObject(8673, 1132.90, 1737.30, 12.80,   0.00, 0.00, 107.25);
	CreateDynamicObject(8673, 1136.40, 1725.90, 3.84,   0.00, 90.00, 286.00);
	CreateDynamicObject(8673, 1136.80, 1724.48, 3.84,   0.00, 90.00, 286.00);
	CreateDynamicObject(8673, 1147.20, 1723.10, 12.80,   0.00, 0.00, 0.00);
	CreateDynamicObject(8673, 1167.30, 1702.70, 12.80,   0.00, 0.00, 0.00);
	CreateDynamicObject(8673, 1157.20, 1712.70, 12.80,   0.00, 0.00, 270.00);
	CreateDynamicObject(8673, 1177.30, 1692.70, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1177.30, 1672.30, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1177.30, 1651.90, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1177.30, 1631.50, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1177.30, 1611.10, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1177.30, 1590.70, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1177.30, 1570.30, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1177.30, 1549.90, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1177.30, 1529.50, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1177.30, 1509.10, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1177.30, 1488.70, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1177.30, 1468.30, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1177.30, 1447.90, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1177.30, 1427.50, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1177.30, 1407.10, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1177.30, 1394.12, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(969, 1171.40, 1383.30, 9.80,   0.00, 0.00, 180.00);
	CreateDynamicObject(2774, 1162.08, 1383.20, 1.70,   0.00, 0.00, 0.00);
	CreateDynamicObject(2774, 1177.00, 1383.30, 1.60,   0.00, 0.00, 0.00);
	CreateDynamicObject(8673, 1173.30, 1383.30, 3.80,   0.00, 90.00, 0.00);
	CreateDynamicObject(8673, 1176.20, 1383.30, 3.80,   0.00, 90.00, 0.00);
	CreateDynamicObject(8673, 1152.30, 1383.40, 11.20,   0.00, 0.00, 0.00);
	CreateDynamicObject(8673, 1131.90, 1383.40, 11.20,   0.00, 0.00, 0.00);
	CreateDynamicObject(8673, 1113.35, 1383.40, 11.20,   0.00, 0.00, 0.00);
	CreateDynamicObject(8673, 1083.30, 1383.40, 11.20,   0.00, 0.00, 0.00);
	CreateDynamicObject(8673, 1062.90, 1383.40, 11.20,   0.00, 0.00, 0.00);
	CreateDynamicObject(8673, 1044.35, 1383.40, 11.20,   0.00, 0.00, 0.00);
	CreateDynamicObject(2774, 1103.30, 1383.90, 1.70,   0.00, 0.00, 0.00);
	CreateDynamicObject(2774, 1092.90, 1383.90, 1.70,   0.00, 0.00, 0.00);
	CreateDynamicObject(2774, 1033.10, 1422.73, 0.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(2774, 1021.90, 1422.73, 0.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(2774, 1017.90, 1383.60, 1.70,   0.00, 0.00, 0.00);
	CreateDynamicObject(8673, 1019.80, 1383.30, 3.80,   0.00, 90.00, 0.00);
	CreateDynamicObject(8673, 1017.40, 1394.70, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1017.40, 1415.10, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1017.40, 1435.50, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1017.40, 1455.90, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1017.40, 1476.30, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1017.40, 1496.70, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1017.40, 1517.10, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1017.40, 1537.50, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1017.40, 1557.90, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1017.40, 1578.30, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1017.40, 1598.70, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1017.40, 1619.10, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1017.40, 1639.50, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1017.40, 1659.90, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1017.40, 1680.30, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1017.40, 1693.20, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1018.88, 1703.20, 3.84,   0.00, 90.00, 0.00);
	CreateDynamicObject(8673, 1021.80, 1703.20, 3.84,   0.00, 90.00, 0.00);
	CreateDynamicObject(8673, 1020.70, 1713.60, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1020.70, 1734.00, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1020.70, 1754.40, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1020.70, 1774.80, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1020.70, 1789.64, 12.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1030.70, 1799.90, 12.80,   0.00, 0.00, 180.00);
	CreateDynamicObject(8673, 1030.70, 1799.90, 9.90,   0.00, 0.00, 179.99);
	CreateDynamicObject(8843, 1050.80, 1794.50, 9.83,   0.00, 0.00, 180.00);
	CreateDynamicObject(8843, 1060.70, 1794.60, 9.83,   0.00, 0.00, 0.00);
	CreateDynamicObject(9339, 1033.60, 1799.90, 10.50,   0.00, 0.00, 90.00);
	CreateDynamicObject(9339, 1104.40, 1799.90, 10.50,   0.00, 0.00, 90.00);
	CreateDynamicObject(9339, 1078.30, 1799.90, 10.50,   0.00, 0.00, 90.00);
	CreateDynamicObject(9339, 1078.30, 1799.90, 11.90,   0.00, 0.00, 90.00);
	CreateDynamicObject(9339, 1104.40, 1799.90, 11.90,   0.00, 0.00, 90.00);
	CreateDynamicObject(9339, 1033.60, 1799.90, 11.90,   0.00, 0.00, 90.00);
	CreateDynamicObject(8041, 1056.00, 1800.40, 15.60,   0.00, 0.00, 90.00);
	CreateDynamicObject(973, 1047.40, 1794.80, 10.50,   0.00, 0.00, 270.00);
	CreateDynamicObject(973, 1055.30, 1794.10, 10.50,   0.00, 0.00, 90.00);
	CreateDynamicObject(973, 1056.60, 1794.10, 10.50,   0.00, 0.00, 270.00);
	CreateDynamicObject(973, 1064.60, 1794.70, 10.50,   0.00, 0.00, 90.00);
	CreateDynamicObject(1597, 1055.90, 1775.10, 12.50,   0.00, 0.00, 0.00);
	CreateDynamicObject(1597, 1055.90, 1755.50, 12.50,   0.00, 0.00, 0.00);
	CreateDynamicObject(1597, 1055.90, 1735.70, 12.50,   0.00, 0.00, 0.00);
	CreateDynamicObject(1597, 1026.60, 1741.70, 12.50,   0.00, 0.00, 90.00);
	CreateDynamicObject(1597, 1026.60, 1760.60, 12.50,   0.00, 0.00, 90.00);
	CreateDynamicObject(1597, 1026.60, 1779.60, 12.50,   0.00, 0.00, 90.00);
	CreateDynamicObject(1597, 1036.30, 1779.60, 12.50,   0.00, 0.00, 90.00);
	CreateDynamicObject(1597, 1036.30, 1760.60, 12.50,   0.00, 0.00, 90.00);
	CreateDynamicObject(1597, 1036.30, 1741.70, 12.50,   0.00, 0.00, 90.00);
	CreateDynamicObject(1597, 1111.50, 1760.60, 12.50,   0.00, 0.00, 90.00);
	CreateDynamicObject(1597, 1101.80, 1741.70, 12.50,   0.00, 0.00, 90.00);
	CreateDynamicObject(1597, 1111.50, 1741.70, 12.50,   0.00, 0.00, 90.00);
	CreateDynamicObject(1597, 1101.80, 1760.60, 12.50,   0.00, 0.00, 90.00);
	CreateDynamicObject(1597, 1111.50, 1779.60, 12.50,   0.00, 0.00, 90.00);
	CreateDynamicObject(1597, 1101.80, 1779.60, 12.50,   0.00, 0.00, 90.00);
	CreateDynamicObject(1597, 1092.10, 1779.60, 12.50,   0.00, 0.00, 90.00);
	CreateDynamicObject(1597, 1092.10, 1760.60, 12.50,   0.00, 0.00, 90.00);
	CreateDynamicObject(1597, 1092.10, 1741.70, 12.50,   0.00, 0.00, 90.00);
	CreateDynamicObject(1597, 1072.00, 1775.10, 12.50,   0.00, 0.00, 0.00);
	CreateDynamicObject(1597, 1072.00, 1755.50, 12.50,   0.00, 0.00, 0.00);
	CreateDynamicObject(1597, 1072.00, 1735.70, 12.50,   0.00, 0.00, 0.00);
	CreateDynamicObject(3626, 1151.70, 1719.80, 11.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(3626, 1142.30, 1719.80, 11.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(3626, 1140.10, 1708.40, 11.40,   0.00, 0.00, 90.00);
	CreateDynamicObject(3626, 1146.80, 1701.80, 11.40,   0.00, 0.00, 180.00);
	CreateDynamicObject(983, 1137.80, 1719.00, 10.50,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, 1137.80, 1709.90, 10.50,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, 1137.80, 1706.70, 10.50,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, 1141.10, 1699.50, 10.50,   0.00, 0.00, 90.00);
	CreateDynamicObject(983, 1147.50, 1699.50, 10.50,   0.00, 0.00, 90.00);
	CreateDynamicObject(1616, 1137.50, 1710.00, 12.90,   0.00, 0.00, 0.00);
	CreateDynamicObject(11611, 1138.10, 1710.70, 13.20,   0.00, 0.00, 45.25);
	CreateDynamicObject(18997, 1103.74, 1603.08, 22.72,   0.00, 90.00, 90.00);
	CreateDynamicObject(18997, 1091.76, 1603.08, 22.72,   0.00, 90.00, 90.00);
	CreateDynamicObject(18997, 1109.68, 1603.08, 30.00,   0.00, 90.00, 90.00);
	CreateDynamicObject(18997, 1097.72, 1603.08, 30.00,   0.00, 90.00, 90.00);
	CreateDynamicObject(18997, 1085.76, 1603.08, 30.00,   0.00, 90.00, 90.00);
	CreateDynamicObject(19462, 1093.03, 1602.96, 18.31,   0.00, 0.00, 90.00);
	CreateDynamicObject(19462, 1102.63, 1602.96, 18.31,   0.00, 0.00, 90.00);
	CreateDynamicObject(19462, 1093.03, 1602.94, 21.81,   0.00, 0.00, 90.00);
	CreateDynamicObject(19462, 1102.65, 1602.96, 21.81,   0.00, 0.00, 90.00);
	CreateDynamicObject(18997, 1097.72, 1456.32, 30.00,   0.00, 90.00, 90.00);
	CreateDynamicObject(18997, 1109.68, 1456.32, 30.00,   0.00, 90.00, 90.00);
	CreateDynamicObject(18997, 1085.76, 1456.32, 30.00,   0.00, 90.00, 90.00);
	CreateDynamicObject(18997, 1091.76, 1456.32, 22.72,   0.00, 90.00, 90.00);
	CreateDynamicObject(18997, 1103.74, 1456.32, 22.72,   0.00, 90.00, 90.00);
	CreateDynamicObject(19462, 1102.65, 1456.28, 21.81,   0.00, 0.00, 90.00);
	CreateDynamicObject(19462, 1093.03, 1456.28, 21.81,   0.00, 0.00, 90.00);
	CreateDynamicObject(19462, 1102.63, 1456.28, 18.31,   0.00, 0.00, 90.00);
	CreateDynamicObject(19462, 1093.03, 1456.28, 18.31,   0.00, 0.00, 90.00);
	CreateDynamicObject(8673, 1154.43, 1528.97, 12.98,   0.00, 0.00, 0.00);
	CreateDynamicObject(8673, 1175.35, 1529.55, 6.30,   0.00, 0.00, 0.00);
	CreateDynamicObject(8673, 1154.72, 1529.46, 6.30,   0.00, 0.00, 0.00);
	CreateDynamicObject(8673, 1040.43, 1529.15, 6.30,   0.00, 0.00, 0.00);
	CreateDynamicObject(8673, 1019.74, 1529.13, 6.30,   0.00, 0.00, 0.00);
	CreateDynamicObject(8673, 1040.03, 1529.53, 12.98,   0.00, 0.00, 0.00);
	CreateDynamicObject(1533, 1100.77, 1457.06, 11.52,   0.00, 0.00, 12.68);
	CreateDynamicObject(1537, 1103.70, 1457.72, 11.52,   0.00, 0.00, 12.68);
	CreateDynamicObject(1533, 1092.85, 1457.46, 11.52,   0.00, 0.00, -12.00);
	CreateDynamicObject(1537, 1095.79, 1456.84, 11.52,   0.00, 0.00, -12.00);
	CreateDynamicObject(2774, 1161.65, 1422.72, 0.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(2774, 1172.43, 1422.75, 0.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(18850, 1150.52, 1404.71, -7.24,   0.00, 0.00, 0.00);
	CreateDynamicObject(18850, 1044.23, 1404.57, -7.24,   0.00, 0.00, 0.00);
	CreateDynamicObject(10183, 1073.84, 1398.37, 4.83,   0.00, 0.00, -45.00);
	CreateDynamicObject(10183, 1123.43, 1398.28, 4.83,   0.00, 0.00, 135.00);
	CreateDynamicObject(10183, 1026.34, 1463.49, 4.83,   0.00, 0.00, 135.00);
	CreateDynamicObject(10183, 1168.68, 1463.45, 4.83,   0.00, 0.00, -45.00);
	CreateDynamicObject(8673, 1106.40, 1723.24, 9.85,   0.00, 0.00, 0.00);
	CreateDynamicObject(19122, 1094.70, 1723.19, 10.36,   0.00, 0.00, 0.00);
	CreateDynamicObject(19122, 1092.78, 1723.23, 10.36,   0.00, 0.00, 0.00);
	CreateDynamicObject(8673, 1081.46, 1723.23, 9.85,   0.00, 0.00, 0.00);
	CreateDynamicObject(19122, 1069.55, 1723.21, 10.36,   0.00, 0.00, 0.00);
	CreateDynamicObject(19122, 1067.82, 1723.21, 10.36,   0.00, 0.00, 0.00);
	CreateDynamicObject(8673, 1056.46, 1723.24, 9.85,   0.00, 0.00, 0.00);
	CreateDynamicObject(19122, 1045.12, 1723.21, 10.36,   0.00, 0.00, 0.00);
	CreateDynamicObject(8673, 1032.03, 1723.24, 9.85,   0.00, 0.00, 0.00);
	CreateDynamicObject(19122, 1043.35, 1723.25, 10.36,   0.00, 0.00, 0.00);
	CreateDynamicObject(2773, 1113.51, 1595.19, 12.05,   0.00, 0.00, -12.00);
	CreateDynamicObject(2773, 1110.07, 1595.91, 12.05,   0.00, 0.00, -12.00);
	CreateDynamicObject(2773, 1108.05, 1596.41, 12.05,   0.00, 0.00, -12.00);
	CreateDynamicObject(2773, 1104.53, 1597.20, 12.05,   0.00, 0.00, -12.00);
	CreateDynamicObject(2773, 1102.55, 1597.59, 12.05,   0.00, 0.00, -12.00);
	CreateDynamicObject(2773, 1099.10, 1598.39, 12.05,   0.00, 0.00, -12.00);
	CreateDynamicObject(2773, 1095.74, 1598.17, 12.05,   0.00, 0.00, 12.00);
	CreateDynamicObject(2773, 1092.05, 1597.42, 12.05,   0.00, 0.00, 12.00);
	CreateDynamicObject(2773, 1089.76, 1596.94, 12.05,   0.00, 0.00, 12.00);
	CreateDynamicObject(2773, 1086.07, 1596.21, 12.05,   0.00, 0.00, 12.00);
	CreateDynamicObject(2773, 1083.80, 1595.74, 12.05,   0.00, 0.00, 12.00);
	CreateDynamicObject(2773, 1080.17, 1595.02, 12.05,   0.00, 0.00, 12.00);
	CreateDynamicObject(1892, 1080.16, 1596.50, 11.54,   0.00, 0.00, 12.00);
	CreateDynamicObject(1892, 1082.10, 1596.91, 11.54,   0.00, 0.00, 12.00);
	CreateDynamicObject(1892, 1086.19, 1597.68, 11.54,   0.00, 0.00, 12.00);
	CreateDynamicObject(1892, 1088.15, 1598.09, 11.54,   0.00, 0.00, 12.00);
	CreateDynamicObject(1892, 1092.11, 1598.90, 11.54,   0.00, 0.00, 12.00);
	CreateDynamicObject(1892, 1094.07, 1599.32, 11.54,   0.00, 0.00, 12.00);
	CreateDynamicObject(1892, 1099.72, 1599.70, 11.54,   0.00, 0.00, -12.00);
	CreateDynamicObject(1892, 1101.67, 1599.28, 11.54,   0.00, 0.00, -12.00);
	CreateDynamicObject(1892, 1105.20, 1598.50, 11.54,   0.00, 0.00, -12.00);
	CreateDynamicObject(1892, 1107.15, 1598.07, 11.54,   0.00, 0.00, -12.00);
	CreateDynamicObject(1892, 1110.67, 1597.21, 11.54,   0.00, 0.00, -12.00);
	CreateDynamicObject(1892, 1112.61, 1596.80, 11.54,   0.00, 0.00, -12.00);
	CreateDynamicObject(19147, 1103.75, 1603.09, 17.32,   0.00, 0.00, 0.00);
	CreateDynamicObject(19145, 1091.72, 1603.09, 17.31,   0.00, 0.00, 0.00);
	CreateDynamicObject(19146, 1109.64, 1602.66, 24.60,   0.00, 0.00, 0.00);
	CreateDynamicObject(19144, 1085.73, 1602.66, 24.61,   0.00, 0.00, 0.00);
	CreateDynamicObject(13562, 1104.18, 1705.82, 11.15,   0.00, 0.00, 0.00);
	CreateDynamicObject(13562, 1091.54, 1705.84, 11.15,   0.00, 0.00, 0.00);
	CreateDynamicObject(4242, 1302.61, 1663.64, 922.24,   0.00, 0.00, 0.00);
	CreateDynamicObject(18981, 1326.03, 1607.46, 922.28,   0.00, 90.00, 90.00);
	CreateDynamicObject(18981, 1301.04, 1607.46, 922.28,   0.00, 90.00, 90.00);
	CreateDynamicObject(18981, 1301.05, 1632.45, 922.28,   0.00, 90.00, 90.00);
	CreateDynamicObject(18981, 1301.04, 1657.44, 922.28,   0.00, 90.00, 90.00);
	CreateDynamicObject(18981, 1301.04, 1682.44, 922.28,   0.00, 90.00, 90.00);
	CreateDynamicObject(18981, 1301.04, 1707.44, 922.28,   0.00, 90.00, 90.00);
	CreateDynamicObject(18981, 1301.04, 1732.42, 922.28,   0.00, 90.00, 90.00);
	CreateDynamicObject(18981, 1326.03, 1732.42, 922.28,   0.00, 90.00, 90.00);
	CreateDynamicObject(18981, 1351.03, 1732.42, 922.28,   0.00, 90.00, 90.00);
	CreateDynamicObject(18981, 1351.03, 1607.46, 922.28,   0.00, 90.00, 90.00);
	CreateDynamicObject(18981, 1351.03, 1707.44, 922.28,   0.00, 90.00, 90.00);
	CreateDynamicObject(18981, 1351.03, 1682.44, 922.28,   0.00, 90.00, 90.00);
	CreateDynamicObject(18981, 1351.03, 1657.44, 922.28,   0.00, 90.00, 90.00);
	CreateDynamicObject(18981, 1351.03, 1632.44, 922.28,   0.00, 90.00, 90.00);
	CreateDynamicObject(5812, 1325.36, 1669.69, 922.51,   0.00, 0.00, 0.00);
	CreateDynamicObject(19361, 1313.54, 1620.01, 922.01,   0.00, 0.00, 45.00);
	CreateDynamicObject(19361, 1316.12, 1618.29, 922.01,   0.00, 0.00, 67.50);
	CreateDynamicObject(19361, 1338.42, 1620.01, 922.01,   0.00, 0.00, -45.00);
	CreateDynamicObject(19361, 1335.83, 1618.27, 922.01,   0.00, 0.00, -67.50);
	CreateDynamicObject(19361, 1332.77, 1617.66, 922.01,   0.00, 0.00, 90.00);
	CreateDynamicObject(19453, 1326.36, 1617.66, 922.01,   0.00, 0.00, 90.00);
	CreateDynamicObject(19361, 1319.19, 1617.66, 922.01,   0.00, 0.00, 90.00);
	CreateDynamicObject(19434, 1321.30, 1617.66, 922.01,   0.00, 0.00, 90.00);
	CreateDynamicObject(19453, 1311.23, 1628.88, 922.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19361, 1311.83, 1622.61, 922.01,   0.00, 0.00, 22.00);
	CreateDynamicObject(19361, 1340.12, 1622.61, 922.01,   0.00, 0.00, -22.00);
	CreateDynamicObject(19453, 1311.23, 1638.51, 922.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1311.23, 1648.13, 922.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1311.23, 1657.75, 922.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1311.23, 1667.37, 922.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1311.23, 1676.99, 922.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1311.23, 1686.62, 922.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1311.23, 1696.25, 922.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1311.23, 1705.87, 922.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19361, 1313.55, 1719.54, 922.01,   0.00, 0.00, -45.00);
	CreateDynamicObject(19361, 1311.83, 1716.94, 922.01,   0.00, 0.00, -22.00);
	CreateDynamicObject(19434, 1311.24, 1711.50, 922.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19361, 1311.23, 1713.89, 922.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19361, 1316.14, 1721.26, 922.01,   0.00, 0.00, -67.50);
	CreateDynamicObject(19361, 1319.19, 1721.88, 922.01,   0.00, 0.00, 90.00);
	CreateDynamicObject(19434, 1321.30, 1721.88, 922.01,   0.00, 0.00, 90.00);
	CreateDynamicObject(19453, 1326.36, 1721.88, 922.01,   0.00, 0.00, 90.00);
	CreateDynamicObject(19361, 1332.77, 1721.88, 922.01,   0.00, 0.00, 90.00);
	CreateDynamicObject(19361, 1335.83, 1721.26, 922.01,   0.00, 0.00, 67.50);
	CreateDynamicObject(19361, 1338.42, 1719.54, 922.01,   0.00, 0.00, 45.00);
	CreateDynamicObject(19361, 1340.12, 1716.94, 922.01,   0.00, 0.00, 22.00);
	CreateDynamicObject(19361, 1340.71, 1713.89, 922.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1340.71, 1705.87, 922.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19434, 1340.71, 1711.49, 922.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1340.71, 1696.25, 922.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1340.71, 1686.62, 922.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1340.71, 1676.99, 922.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1340.71, 1667.37, 922.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1340.71, 1657.75, 922.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1340.71, 1648.13, 922.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1340.71, 1638.51, 922.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1340.71, 1628.88, 922.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1359.00, 1628.88, 922.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1359.00, 1638.51, 922.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1359.00, 1648.13, 922.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1357.21, 1619.61, 922.01,   0.00, 0.00, -22.00);
	CreateDynamicObject(19453, 1352.06, 1611.77, 922.01,   0.00, 0.00, -45.00);
	CreateDynamicObject(19453, 1344.20, 1606.53, 922.01,   0.00, 0.00, -67.50);
	CreateDynamicObject(19453, 1334.99, 1604.69, 922.01,   0.00, 0.00, 90.00);
	CreateDynamicObject(19453, 1325.37, 1604.69, 922.01,   0.00, 0.00, 90.00);
	CreateDynamicObject(19453, 1316.08, 1604.71, 922.01,   0.00, 0.00, 90.00);
	CreateDynamicObject(19453, 1292.00, 1628.88, 922.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1293.81, 1619.61, 922.01,   0.00, 0.00, 22.00);
	CreateDynamicObject(19453, 1299.01, 1611.77, 922.01,   0.00, 0.00, 45.00);
	CreateDynamicObject(19453, 1306.84, 1606.53, 922.01,   0.00, 0.00, 67.50);
	CreateDynamicObject(19453, 1292.00, 1638.51, 922.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1292.00, 1648.13, 922.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1292.00, 1657.75, 922.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1292.00, 1667.37, 922.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1292.00, 1676.99, 922.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1292.00, 1686.62, 922.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1292.00, 1696.25, 922.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1292.00, 1705.87, 922.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19361, 1292.00, 1713.89, 922.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19434, 1292.00, 1711.50, 922.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1293.80, 1719.92, 922.01,   0.00, 0.00, -22.00);
	CreateDynamicObject(19453, 1298.99, 1727.76, 922.01,   0.00, 0.00, -45.00);
	CreateDynamicObject(19453, 1306.81, 1732.99, 922.01,   0.00, 0.00, -67.50);
	CreateDynamicObject(19453, 1316.08, 1734.83, 922.01,   0.00, 0.00, 90.00);
	CreateDynamicObject(19453, 1325.37, 1734.83, 922.01,   0.00, 0.00, 90.00);
	CreateDynamicObject(19453, 1334.99, 1734.83, 922.01,   0.00, 0.00, 90.00);
	CreateDynamicObject(19453, 1344.20, 1732.99, 922.01,   0.00, 0.00, 67.50);
	CreateDynamicObject(19453, 1352.06, 1727.76, 922.01,   0.00, 0.00, 45.00);
	CreateDynamicObject(19453, 1357.21, 1719.92, 922.01,   0.00, 0.00, 22.00);
	CreateDynamicObject(19453, 1359.00, 1657.75, 922.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1359.00, 1667.37, 922.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1359.00, 1676.99, 922.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1359.00, 1686.62, 922.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1359.00, 1696.25, 922.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1359.00, 1705.87, 922.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19434, 1359.00, 1711.50, 922.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19361, 1359.00, 1713.89, 922.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(3452, 1339.62, 1592.82, 927.99,   0.00, 0.00, 0.00);
	CreateDynamicObject(3452, 1339.62, 1574.71, 936.31,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1349.64, 1601.84, 923.73,   0.00, 0.00, 90.00);
	CreateDynamicObject(3452, 1310.00, 1592.82, 927.99,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1340.01, 1601.84, 923.73,   0.00, 0.00, 90.00);
	CreateDynamicObject(19453, 1330.38, 1601.84, 923.73,   0.00, 0.00, 90.00);
	CreateDynamicObject(19453, 1320.76, 1601.84, 923.73,   0.00, 0.00, 90.00);
	CreateDynamicObject(19453, 1311.14, 1601.84, 923.73,   0.00, 0.00, 90.00);
	CreateDynamicObject(19453, 1301.52, 1601.84, 923.73,   0.00, 0.00, 90.00);
	CreateDynamicObject(3452, 1310.00, 1574.71, 936.31,   0.00, 0.00, 0.00);
	CreateDynamicObject(3452, 1279.56, 1624.19, 927.99,   0.00, 0.00, -90.00);
	CreateDynamicObject(19453, 1288.56, 1614.63, 923.73,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1288.58, 1624.26, 923.73,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1288.58, 1633.88, 923.73,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1288.58, 1643.50, 923.73,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1288.58, 1653.12, 923.73,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1288.58, 1662.74, 923.73,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1288.58, 1672.36, 923.73,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1288.58, 1681.99, 923.73,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1288.58, 1691.61, 923.73,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1288.58, 1701.23, 923.73,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1288.58, 1710.85, 923.73,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1288.58, 1720.48, 923.73,   0.00, 0.00, 0.00);
	CreateDynamicObject(3452, 1279.56, 1653.81, 927.99,   0.00, 0.00, -90.00);
	CreateDynamicObject(3452, 1279.56, 1683.40, 927.99,   0.00, 0.00, -90.00);
	CreateDynamicObject(3452, 1279.56, 1713.01, 927.99,   0.00, 0.00, -90.00);
	CreateDynamicObject(3452, 1261.44, 1624.19, 936.31,   0.00, 0.00, -90.00);
	CreateDynamicObject(3452, 1261.44, 1653.81, 936.31,   0.00, 0.00, -90.00);
	CreateDynamicObject(3452, 1261.43, 1683.41, 936.31,   0.00, 0.00, -90.00);
	CreateDynamicObject(3452, 1261.43, 1713.01, 936.31,   0.00, 0.00, -90.00);
	CreateDynamicObject(3452, 1310.00, 1746.83, 927.99,   0.00, 0.00, 180.00);
	CreateDynamicObject(3452, 1339.62, 1746.83, 927.99,   0.00, 0.00, 180.00);
	CreateDynamicObject(3452, 1339.62, 1764.94, 936.31,   0.00, 0.00, 180.00);
	CreateDynamicObject(3452, 1310.00, 1764.94, 936.31,   0.00, 0.00, 180.00);
	CreateDynamicObject(3452, 1370.43, 1713.01, 927.99,   0.00, 0.00, 90.00);
	CreateDynamicObject(3452, 1370.41, 1683.40, 927.99,   0.00, 0.00, 90.00);
	CreateDynamicObject(3452, 1370.41, 1653.81, 927.99,   0.00, 0.00, 90.00);
	CreateDynamicObject(3452, 1370.40, 1624.17, 927.99,   0.00, 0.00, 90.00);
	CreateDynamicObject(3452, 1388.52, 1624.19, 936.31,   0.00, 0.00, 90.00);
	CreateDynamicObject(3452, 1388.52, 1653.81, 936.31,   0.00, 0.00, 90.00);
	CreateDynamicObject(3452, 1388.52, 1683.40, 936.31,   0.00, 0.00, 90.00);
	CreateDynamicObject(3452, 1388.52, 1713.01, 936.31,   0.00, 0.00, 90.00);
	CreateDynamicObject(19453, 1293.31, 1601.84, 923.73,   0.00, 0.00, 90.00);
	CreateDynamicObject(19453, 1288.56, 1606.62, 923.73,   0.00, 0.00, 0.00);
	CreateDynamicObject(2774, 1294.97, 1565.28, 935.28,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1361.41, 1606.67, 923.73,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1361.41, 1616.29, 923.73,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1361.41, 1625.92, 923.73,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1361.41, 1635.53, 923.73,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1361.41, 1645.15, 923.73,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1361.41, 1654.77, 923.73,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1361.41, 1664.39, 923.73,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1361.41, 1674.01, 923.73,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1361.41, 1683.63, 923.73,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1361.41, 1693.25, 923.73,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1361.41, 1702.88, 923.73,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1361.41, 1712.50, 923.73,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1361.41, 1722.12, 923.73,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1361.41, 1731.75, 923.73,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1356.63, 1737.86, 923.73,   0.00, 0.00, 90.00);
	CreateDynamicObject(19453, 1347.00, 1737.86, 923.73,   0.00, 0.00, 90.00);
	CreateDynamicObject(19453, 1337.38, 1737.86, 923.73,   0.00, 0.00, 90.00);
	CreateDynamicObject(19453, 1327.76, 1737.86, 923.73,   0.00, 0.00, 90.00);
	CreateDynamicObject(19453, 1318.14, 1737.86, 923.73,   0.00, 0.00, 90.00);
	CreateDynamicObject(19453, 1308.52, 1737.86, 923.73,   0.00, 0.00, 90.00);
	CreateDynamicObject(19453, 1298.88, 1737.86, 923.73,   0.00, 0.00, 90.00);
	CreateDynamicObject(19453, 1288.58, 1730.10, 923.73,   0.00, 0.00, 0.00);
	CreateDynamicObject(2774, 1354.31, 1565.28, 935.28,   0.00, 0.00, 0.00);
	CreateDynamicObject(2774, 1397.70, 1609.11, 935.28,   0.00, 0.00, 0.00);
	CreateDynamicObject(2774, 1397.70, 1669.39, 935.28,   0.00, 0.00, 0.00);
	CreateDynamicObject(2774, 1397.70, 1728.10, 935.28,   0.00, 0.00, 0.00);
	CreateDynamicObject(2774, 1354.01, 1774.08, 935.28,   0.00, 0.00, 0.00);
	CreateDynamicObject(2774, 1252.29, 1728.10, 935.28,   0.00, 0.00, 0.00);
	CreateDynamicObject(2774, 1295.47, 1774.08, 935.28,   0.00, 0.00, 0.00);
	CreateDynamicObject(2774, 1252.29, 1669.39, 935.28,   0.00, 0.00, 0.00);
	CreateDynamicObject(2774, 1252.29, 1609.11, 935.28,   0.00, 0.00, 0.00);
	CreateDynamicObject(2774, 1265.74, 1728.10, 950.00,   0.00, 80.00, 0.00);
	CreateDynamicObject(2774, 1291.00, 1728.10, 953.36,   0.00, 85.00, 0.00);
	CreateDynamicObject(2774, 1313.00, 1728.10, 954.48,   0.00, 90.00, 0.00);
	CreateDynamicObject(2774, 1384.93, 1728.10, 950.00,   0.00, -80.00, 0.00);
	CreateDynamicObject(2774, 1359.57, 1728.10, 953.36,   0.00, -85.00, 0.00);
	CreateDynamicObject(2774, 1339.00, 1728.10, 954.48,   0.00, 90.00, 180.00);
	CreateDynamicObject(2774, 1384.93, 1669.39, 950.00,   0.00, -80.00, 0.00);
	CreateDynamicObject(2774, 1359.57, 1669.39, 953.36,   0.00, -85.00, 0.00);
	CreateDynamicObject(2774, 1339.00, 1669.39, 954.48,   0.00, 90.00, 180.00);
	CreateDynamicObject(2774, 1313.00, 1669.39, 954.48,   0.00, 90.00, 0.00);
	CreateDynamicObject(2774, 1291.00, 1669.41, 953.36,   0.00, 85.00, 0.00);
	CreateDynamicObject(2774, 1265.74, 1669.39, 950.00,   0.00, 80.00, 0.00);
	CreateDynamicObject(2774, 1384.93, 1609.11, 950.00,   0.00, -80.00, 0.00);
	CreateDynamicObject(2774, 1359.57, 1609.11, 953.36,   0.00, -85.00, 0.00);
	CreateDynamicObject(2774, 1339.00, 1609.11, 954.48,   0.00, 90.00, 180.00);
	CreateDynamicObject(2774, 1313.00, 1609.11, 954.48,   0.00, 90.00, 0.00);
	CreateDynamicObject(2774, 1291.00, 1609.11, 953.36,   0.00, 85.00, 0.00);
	CreateDynamicObject(2774, 1265.74, 1609.11, 950.00,   0.00, 80.00, 0.00);
	CreateDynamicObject(13634, 1324.29, 1671.49, 937.73,   0.00, 0.00, 90.00);
	CreateDynamicObject(19434, 1361.41, 1737.15, 923.73,   0.00, 0.00, 0.00);
	CreateDynamicObject(19361, 1292.48, 1737.86, 923.73,   0.00, 0.00, 90.00);
	CreateDynamicObject(19361, 1290.15, 1737.86, 923.73,   0.00, 0.00, 90.00);
	CreateDynamicObject(19361, 1288.58, 1736.34, 923.73,   0.00, 0.00, 0.00);
	CreateDynamicObject(19361, 1356.04, 1601.84, 923.73,   0.00, 0.00, 90.00);
	CreateDynamicObject(19361, 1359.24, 1601.84, 923.73,   0.00, 0.00, 90.00);
	CreateDynamicObject(19434, 1360.66, 1601.84, 923.73,   0.00, 0.00, 90.00);
	CreateDynamicObject(19463, 1366.17, 1727.90, 926.65,   0.00, 0.00, 90.00);
	CreateDynamicObject(18981, 1366.93, 1740.36, 925.86,   0.00, 90.00, 90.00);
	CreateDynamicObject(19463, 1375.80, 1727.90, 926.65,   0.00, 0.00, 90.00);
	CreateDynamicObject(19463, 1375.78, 1727.90, 930.15,   0.00, 0.00, 90.00);
	CreateDynamicObject(19463, 1375.78, 1727.90, 933.64,   0.00, 0.00, 90.00);
	CreateDynamicObject(19463, 1395.03, 1727.90, 937.30,   0.00, 0.00, 90.00);
	CreateDynamicObject(19463, 1385.40, 1727.90, 935.08,   0.00, 0.00, 90.00);
	CreateDynamicObject(3440, 1354.76, 1728.19, 923.42,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1358.32, 1734.50, 923.73,   0.00, 0.00, 45.00);
	CreateDynamicObject(1537, 1360.02, 1732.65, 922.76,   0.00, 0.00, -45.00);
	CreateDynamicObject(1533, 1357.90, 1734.78, 922.76,   0.00, 0.00, -45.00);
	CreateDynamicObject(2773, 1356.89, 1734.12, 923.29,   0.00, 0.00, -45.00);
	CreateDynamicObject(2773, 1359.37, 1731.62, 923.29,   0.00, 0.00, -45.00);
	CreateDynamicObject(3440, 1361.31, 1728.17, 928.66,   0.00, 0.00, 0.00);
	CreateDynamicObject(19463, 1354.48, 1742.63, 926.65,   0.00, 0.00, 0.00);
	CreateDynamicObject(19463, 1354.48, 1752.24, 926.65,   0.00, 0.00, 0.00);
	CreateDynamicObject(19463, 1354.48, 1752.16, 930.15,   0.00, 0.00, 0.00);
	CreateDynamicObject(19463, 1354.48, 1752.16, 933.64,   0.00, 0.00, 0.00);
	CreateDynamicObject(19463, 1354.48, 1761.78, 935.08,   0.00, 0.00, 0.00);
	CreateDynamicObject(19463, 1354.50, 1771.41, 937.30,   0.00, 0.00, 0.00);
	CreateDynamicObject(3440, 1354.76, 1737.76, 928.66,   0.00, 0.00, 0.00);
	CreateDynamicObject(1649, 1355.86, 1736.16, 928.53,   0.00, 90.00, 124.32);
	CreateDynamicObject(1649, 1360.26, 1729.81, 928.53,   0.00, 90.00, 124.32);
	CreateDynamicObject(3440, 1359.12, 1731.36, 928.66,   0.00, 0.00, 0.00);
	CreateDynamicObject(1649, 1358.09, 1732.99, 928.53,   0.00, 90.00, 124.32);
	CreateDynamicObject(3440, 1356.90, 1734.51, 928.66,   0.00, 0.00, 0.00);
	CreateDynamicObject(1649, 1354.53, 1740.20, 929.07,   0.00, 0.00, 270.00);
	CreateDynamicObject(1649, 1354.54, 1744.58, 929.07,   0.00, 0.00, 90.00);
	CreateDynamicObject(3440, 1354.51, 1747.05, 928.66,   0.00, 0.00, 0.00);
	CreateDynamicObject(3440, 1370.68, 1727.93, 928.66,   0.00, 0.00, 0.00);
	CreateDynamicObject(1649, 1363.74, 1727.97, 929.07,   0.00, 0.00, 0.00);
	CreateDynamicObject(1649, 1368.16, 1727.97, 929.07,   0.00, 0.00, 0.00);
	CreateDynamicObject(1649, 1368.16, 1727.97, 929.07,   0.00, 0.00, 180.00);
	CreateDynamicObject(1649, 1363.74, 1727.97, 929.07,   0.00, 0.00, 180.00);
	CreateDynamicObject(1649, 1360.26, 1729.81, 928.53,   0.00, 90.00, -55.68);
	CreateDynamicObject(1649, 1358.09, 1732.99, 928.53,   0.00, 90.00, -55.68);
	CreateDynamicObject(1649, 1355.86, 1736.16, 928.53,   0.00, 90.00, -55.68);
	CreateDynamicObject(1649, 1354.53, 1740.20, 929.07,   0.00, 0.00, 90.00);
	CreateDynamicObject(1649, 1354.53, 1744.56, 929.07,   0.00, 0.00, 270.00);
	CreateDynamicObject(18981, 1391.77, 1740.43, 935.14,   0.00, 90.00, 90.00);
	CreateDynamicObject(18981, 1391.77, 1765.41, 935.14,   0.00, 90.00, 90.00);
	CreateDynamicObject(18981, 1366.93, 1765.41, 935.14,   0.00, 90.00, 90.00);
	CreateDynamicObject(18981, 1366.93, 1740.38, 931.23,   0.00, 90.00, 90.00);
	CreateDynamicObject(18981, 1366.93, 1740.36, 932.23,   0.00, 90.00, 90.00);
	CreateDynamicObject(18981, 1366.93, 1740.36, 933.21,   0.00, 90.00, 90.00);
	CreateDynamicObject(18981, 1366.93, 1740.36, 934.17,   0.00, 90.00, 90.00);
	CreateDynamicObject(18981, 1366.93, 1740.36, 935.14,   0.00, 90.00, 90.00);
	CreateDynamicObject(18981, 1366.93, 1790.40, 935.14,   0.00, 90.00, 90.00);
	CreateDynamicObject(19463, 1379.22, 1732.68, 928.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(19463, 1379.22, 1742.30, 928.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(19463, 1379.22, 1751.93, 928.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(19463, 1379.22, 1751.93, 931.51,   0.00, 0.00, 0.00);
	CreateDynamicObject(19463, 1379.22, 1742.30, 931.51,   0.00, 0.00, 0.00);
	CreateDynamicObject(19463, 1379.22, 1732.68, 931.51,   0.00, 0.00, 0.00);
	CreateDynamicObject(19463, 1359.34, 1752.64, 928.02,   0.00, 0.00, 90.00);
	CreateDynamicObject(19463, 1368.97, 1752.64, 928.02,   0.00, 0.00, 90.00);
	CreateDynamicObject(19463, 1378.59, 1752.64, 928.02,   0.00, 0.00, 90.00);
	CreateDynamicObject(19463, 1378.59, 1752.64, 931.51,   0.00, 0.00, 90.00);
	CreateDynamicObject(19463, 1368.97, 1752.64, 931.51,   0.00, 0.00, 90.00);
	CreateDynamicObject(19463, 1359.34, 1752.64, 931.51,   0.00, 0.00, 90.00);
	CreateDynamicObject(1533, 1368.58, 1752.53, 926.31,   0.00, 0.00, 0.00);
	CreateDynamicObject(1537, 1371.59, 1752.53, 926.31,   0.00, 0.00, 0.00);
	CreateDynamicObject(19463, 1366.17, 1609.36, 926.65,   0.00, 0.00, 90.00);
	CreateDynamicObject(19463, 1375.80, 1609.36, 926.65,   0.00, 0.00, 90.00);
	CreateDynamicObject(19463, 1375.78, 1609.36, 930.15,   0.00, 0.00, 90.00);
	CreateDynamicObject(19463, 1375.78, 1609.36, 933.64,   0.00, 0.00, 90.00);
	CreateDynamicObject(19463, 1385.40, 1609.36, 935.08,   0.00, 0.00, 90.00);
	CreateDynamicObject(19463, 1395.03, 1609.36, 937.30,   0.00, 0.00, 90.00);
	CreateDynamicObject(18981, 1366.91, 1596.84, 925.86,   0.00, 90.00, 90.00);
	CreateDynamicObject(3440, 1354.76, 1608.99, 923.42,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1358.01, 1605.14, 923.73,   0.00, 0.00, -45.00);
	CreateDynamicObject(1537, 1356.84, 1604.12, 922.76,   0.00, 0.00, -135.00);
	CreateDynamicObject(1533, 1358.96, 1606.24, 922.76,   0.00, 0.00, -135.00);
	CreateDynamicObject(18981, 1366.93, 1596.86, 931.23,   0.00, 90.00, 90.00);
	CreateDynamicObject(3440, 1361.44, 1609.03, 928.66,   0.00, 0.00, 0.00);
	CreateDynamicObject(19463, 1354.48, 1597.03, 926.65,   0.00, 0.00, 0.00);
	CreateDynamicObject(3440, 1354.75, 1602.01, 928.66,   0.00, 0.00, 0.00);
	CreateDynamicObject(1649, 1360.43, 1607.95, 928.53,   0.00, 90.00, 45.36);
	CreateDynamicObject(1649, 1358.14, 1605.60, 928.53,   0.00, 90.00, 45.36);
	CreateDynamicObject(1649, 1355.86, 1603.30, 928.53,   0.00, 90.00, 45.36);
	CreateDynamicObject(3440, 1356.92, 1604.43, 928.66,   0.00, 0.00, 0.00);
	CreateDynamicObject(3440, 1359.33, 1606.86, 928.66,   0.00, 0.00, 0.00);
	CreateDynamicObject(1649, 1360.43, 1607.95, 928.53,   0.00, 90.00, -134.58);
	CreateDynamicObject(1649, 1358.14, 1605.60, 928.53,   0.00, 90.00, -134.58);
	CreateDynamicObject(1649, 1355.86, 1603.30, 928.53,   0.00, 90.00, -134.58);
	CreateDynamicObject(1649, 1354.51, 1599.64, 929.09,   0.00, 0.00, 90.00);
	CreateDynamicObject(1649, 1354.51, 1595.23, 929.09,   0.00, 0.00, 90.00);
	CreateDynamicObject(19463, 1354.48, 1587.40, 926.65,   0.00, 0.00, 0.00);
	CreateDynamicObject(19463, 1354.48, 1587.66, 930.15,   0.00, 0.00, 0.00);
	CreateDynamicObject(19463, 1354.48, 1587.66, 933.65,   0.00, 0.00, 0.00);
	CreateDynamicObject(19463, 1354.48, 1578.04, 935.08,   0.00, 0.00, 0.00);
	CreateDynamicObject(19463, 1354.48, 1568.42, 937.30,   0.00, 0.00, 0.00);
	CreateDynamicObject(3440, 1354.49, 1592.72, 928.66,   0.00, 0.00, 0.00);
	CreateDynamicObject(1649, 1363.78, 1609.30, 929.09,   0.00, 0.00, 0.00);
	CreateDynamicObject(1649, 1368.22, 1609.30, 929.09,   0.00, 0.00, 0.00);
	CreateDynamicObject(3440, 1370.70, 1609.30, 928.34,   0.00, 0.00, 0.00);
	CreateDynamicObject(1649, 1368.22, 1609.30, 929.09,   0.00, 0.00, 180.00);
	CreateDynamicObject(1649, 1363.78, 1609.30, 929.09,   0.00, 0.00, 180.00);
	CreateDynamicObject(1649, 1354.51, 1599.64, 929.09,   0.00, 0.00, -90.00);
	CreateDynamicObject(1649, 1354.51, 1595.23, 929.09,   0.00, 0.00, -90.00);
	CreateDynamicObject(19463, 1359.18, 1584.44, 927.99,   0.00, 0.00, 90.00);
	CreateDynamicObject(19463, 1368.80, 1584.44, 927.99,   0.00, 0.00, 90.00);
	CreateDynamicObject(19463, 1378.43, 1584.44, 927.99,   0.00, 0.00, 90.00);
	CreateDynamicObject(19463, 1370.72, 1604.20, 927.99,   0.00, 0.00, 0.00);
	CreateDynamicObject(19463, 1370.72, 1595.23, 927.99,   0.00, 0.00, 0.00);
	CreateDynamicObject(19463, 1370.72, 1585.61, 927.99,   0.00, 0.00, 0.00);
	CreateDynamicObject(19463, 1359.18, 1584.44, 931.49,   0.00, 0.00, 90.00);
	CreateDynamicObject(19463, 1368.80, 1584.44, 931.49,   0.00, 0.00, 90.00);
	CreateDynamicObject(19463, 1378.43, 1584.44, 931.49,   0.00, 0.00, 90.00);
	CreateDynamicObject(19463, 1370.72, 1585.61, 931.49,   0.00, 0.00, 0.00);
	CreateDynamicObject(19463, 1370.72, 1595.23, 931.49,   0.00, 0.00, 0.00);
	CreateDynamicObject(19463, 1370.72, 1604.21, 931.49,   0.00, 0.00, 0.00);
	CreateDynamicObject(18981, 1366.93, 1596.86, 935.14,   0.00, 90.00, 90.00);
	CreateDynamicObject(18981, 1366.93, 1596.86, 932.16,   0.00, 90.00, 90.00);
	CreateDynamicObject(18981, 1366.93, 1596.86, 933.14,   0.00, 90.00, 90.00);
	CreateDynamicObject(18981, 1366.93, 1596.86, 934.14,   0.00, 90.00, 90.00);
	CreateDynamicObject(18981, 1391.91, 1596.86, 935.14,   0.00, 90.00, 90.00);
	CreateDynamicObject(18981, 1366.93, 1571.86, 935.14,   0.00, 90.00, 90.00);
	CreateDynamicObject(18981, 1391.91, 1571.86, 935.14,   0.00, 90.00, 90.00);
	CreateDynamicObject(2773, 1358.34, 1607.18, 923.28,   0.00, 0.00, 45.00);
	CreateDynamicObject(2773, 1355.87, 1604.76, 923.28,   0.00, 0.00, 45.00);
	CreateDynamicObject(18981, 1366.93, 1546.91, 935.14,   0.00, 90.00, 90.00);
	CreateDynamicObject(19463, 1295.14, 1597.03, 926.65,   0.00, 0.00, 0.00);
	CreateDynamicObject(19463, 1295.14, 1587.40, 926.65,   0.00, 0.00, 0.00);
	CreateDynamicObject(19463, 1295.14, 1587.66, 930.15,   0.00, 0.00, 0.00);
	CreateDynamicObject(19463, 1295.14, 1587.66, 933.65,   0.00, 0.00, 0.00);
	CreateDynamicObject(19463, 1295.14, 1578.04, 935.08,   0.00, 0.00, 0.00);
	CreateDynamicObject(19463, 1295.14, 1568.42, 937.30,   0.00, 0.00, 0.00);
	CreateDynamicObject(19463, 1283.79, 1609.36, 926.65,   0.00, 0.00, 90.00);
	CreateDynamicObject(19463, 1274.16, 1609.36, 926.65,   0.00, 0.00, 90.00);
	CreateDynamicObject(19463, 1274.16, 1609.36, 930.13,   0.00, 0.00, 90.00);
	CreateDynamicObject(19463, 1274.16, 1609.36, 933.63,   0.00, 0.00, 90.00);
	CreateDynamicObject(19463, 1264.55, 1609.36, 935.08,   0.00, 0.00, 90.00);
	CreateDynamicObject(19463, 1254.92, 1609.36, 937.30,   0.00, 0.00, 90.00);
	CreateDynamicObject(18981, 1282.59, 1596.84, 925.86,   0.00, 90.00, 90.00);
	CreateDynamicObject(3440, 1294.71, 1608.96, 923.42,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1291.87, 1605.14, 923.73,   0.00, 0.00, 45.00);
	CreateDynamicObject(1537, 1290.59, 1606.59, 922.76,   0.00, 0.00, 135.00);
	CreateDynamicObject(1533, 1292.72, 1604.46, 922.76,   0.00, 0.00, 135.00);
	CreateDynamicObject(2773, 1293.70, 1605.10, 923.28,   0.00, 0.00, -45.00);
	CreateDynamicObject(2773, 1291.24, 1607.59, 923.28,   0.00, 0.00, -45.00);
	CreateDynamicObject(18981, 1282.59, 1596.84, 931.23,   0.00, 90.00, 90.00);
	CreateDynamicObject(18981, 1282.59, 1596.84, 935.14,   0.00, 90.00, 90.00);
	CreateDynamicObject(18981, 1282.59, 1596.84, 932.20,   0.00, 90.00, 90.00);
	CreateDynamicObject(18981, 1282.59, 1596.84, 933.19,   0.00, 90.00, 90.00);
	CreateDynamicObject(18981, 1282.59, 1596.84, 934.18,   0.00, 90.00, 90.00);
	CreateDynamicObject(3440, 1294.75, 1601.78, 928.66,   0.00, 0.00, 0.00);
	CreateDynamicObject(3440, 1288.40, 1609.01, 928.66,   0.00, 0.00, 0.00);
	CreateDynamicObject(1649, 1293.65, 1603.19, 928.58,   0.00, 90.00, -49.26);
	CreateDynamicObject(1649, 1291.54, 1605.65, 928.58,   0.00, 90.00, -49.26);
	CreateDynamicObject(1649, 1289.45, 1608.05, 928.58,   0.00, 90.00, -49.26);
	CreateDynamicObject(3440, 1290.54, 1606.85, 928.66,   0.00, 0.00, 0.00);
	CreateDynamicObject(3440, 1292.73, 1604.45, 928.66,   0.00, 0.00, 0.00);
	CreateDynamicObject(1649, 1293.65, 1603.19, 928.58,   0.00, 90.00, -229.26);
	CreateDynamicObject(1649, 1291.54, 1605.65, 928.58,   0.00, 90.00, -229.26);
	CreateDynamicObject(1649, 1289.45, 1608.05, 928.58,   0.00, 90.00, -229.20);
	CreateDynamicObject(1649, 1286.06, 1609.29, 929.08,   0.00, 0.00, 0.00);
	CreateDynamicObject(3440, 1279.23, 1609.27, 928.66,   0.00, 0.00, 0.00);
	CreateDynamicObject(1649, 1286.06, 1609.29, 929.08,   0.00, 0.00, -180.06);
	CreateDynamicObject(1649, 1295.06, 1599.53, 929.08,   0.00, 0.00, 90.00);
	CreateDynamicObject(1649, 1281.61, 1609.29, 929.08,   0.00, 0.00, 0.00);
	CreateDynamicObject(1649, 1281.61, 1609.29, 929.08,   0.00, 0.00, -180.06);
	CreateDynamicObject(1649, 1295.07, 1595.09, 929.08,   0.00, 0.00, 90.00);
	CreateDynamicObject(3440, 1295.03, 1592.61, 928.66,   0.00, 0.00, 0.00);
	CreateDynamicObject(1649, 1295.07, 1595.09, 929.08,   0.00, 0.00, -90.00);
	CreateDynamicObject(1649, 1295.06, 1599.53, 929.08,   0.00, 0.00, -90.00);
	CreateDynamicObject(19463, 1279.17, 1604.53, 927.97,   0.00, 0.00, 0.00);
	CreateDynamicObject(19463, 1279.17, 1594.91, 927.97,   0.00, 0.00, 0.00);
	CreateDynamicObject(19463, 1279.17, 1585.28, 927.97,   0.00, 0.00, 0.00);
	CreateDynamicObject(19463, 1274.97, 1584.62, 927.97,   0.00, 0.00, 90.00);
	CreateDynamicObject(19463, 1284.60, 1584.62, 927.97,   0.00, 0.00, 90.00);
	CreateDynamicObject(19463, 1294.23, 1584.61, 927.97,   0.00, 0.00, 90.00);
	CreateDynamicObject(19463, 1294.23, 1584.61, 931.46,   0.00, 0.00, 90.00);
	CreateDynamicObject(19463, 1284.58, 1584.62, 931.46,   0.00, 0.00, 90.00);
	CreateDynamicObject(19463, 1274.97, 1584.62, 931.46,   0.00, 0.00, 90.00);
	CreateDynamicObject(19463, 1279.17, 1585.28, 931.46,   0.00, 0.00, 0.00);
	CreateDynamicObject(19463, 1279.17, 1594.91, 931.46,   0.00, 0.00, 0.00);
	CreateDynamicObject(19463, 1279.17, 1604.53, 931.46,   0.00, 0.00, 0.00);
	CreateDynamicObject(1533, 1286.23, 1584.73, 926.37,   0.00, 0.00, -180.00);
	CreateDynamicObject(1537, 1283.22, 1584.74, 926.36,   0.00, 0.00, -180.00);
	CreateDynamicObject(19463, 1283.79, 1727.90, 926.65,   0.00, 0.00, 90.00);
	CreateDynamicObject(19463, 1274.16, 1727.90, 926.65,   0.00, 0.00, 90.00);
	CreateDynamicObject(19463, 1274.16, 1727.90, 933.63,   0.00, 0.00, 90.00);
	CreateDynamicObject(19463, 1274.16, 1727.90, 930.13,   0.00, 0.00, 90.00);
	CreateDynamicObject(19463, 1264.55, 1727.90, 935.08,   0.00, 0.00, 90.00);
	CreateDynamicObject(19463, 1254.92, 1727.90, 937.30,   0.00, 0.00, 90.00);
	CreateDynamicObject(3440, 1279.23, 1727.93, 928.66,   0.00, 0.00, 0.00);
	CreateDynamicObject(19463, 1295.14, 1742.63, 926.65,   0.00, 0.00, 0.00);
	CreateDynamicObject(19463, 1295.14, 1752.24, 926.65,   0.00, 0.00, 0.00);
	CreateDynamicObject(19463, 1295.14, 1752.16, 930.15,   0.00, 0.00, 0.00);
	CreateDynamicObject(19463, 1295.14, 1752.16, 933.64,   0.00, 0.00, 0.00);
	CreateDynamicObject(19463, 1295.14, 1761.78, 935.08,   0.00, 0.00, 0.00);
	CreateDynamicObject(19463, 1295.14, 1771.41, 937.30,   0.00, 0.00, 0.00);
	CreateDynamicObject(3440, 1294.75, 1737.76, 928.66,   0.00, 0.00, 0.00);
	CreateDynamicObject(18981, 1282.59, 1740.36, 925.86,   0.00, 90.00, 90.00);
	CreateDynamicObject(18981, 1282.59, 1740.36, 931.23,   0.00, 90.00, 90.00);
	CreateDynamicObject(18981, 1282.59, 1740.36, 932.20,   0.00, 90.00, 90.00);
	CreateDynamicObject(18981, 1282.59, 1740.36, 933.19,   0.00, 90.00, 90.00);
	CreateDynamicObject(18981, 1282.59, 1740.36, 934.18,   0.00, 90.00, 90.00);
	CreateDynamicObject(18981, 1282.59, 1740.36, 935.14,   0.00, 90.00, 90.00);
	CreateDynamicObject(3440, 1294.71, 1728.19, 923.42,   0.00, 0.00, 0.00);
	CreateDynamicObject(3440, 1288.40, 1728.17, 928.66,   0.00, 0.00, 0.00);
	CreateDynamicObject(19463, 1284.60, 1752.64, 927.97,   0.00, 0.00, 90.00);
	CreateDynamicObject(19463, 1294.23, 1752.64, 927.97,   0.00, 0.00, 90.00);
	CreateDynamicObject(19463, 1294.23, 1752.64, 931.46,   0.00, 0.00, 90.00);
	CreateDynamicObject(19463, 1284.58, 1752.64, 931.46,   0.00, 0.00, 90.00);
	CreateDynamicObject(19463, 1274.97, 1752.64, 927.97,   0.00, 0.00, 90.00);
	CreateDynamicObject(19463, 1274.97, 1752.64, 931.46,   0.00, 0.00, 90.00);
	CreateDynamicObject(19463, 1279.17, 1732.98, 928.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(19463, 1279.17, 1732.68, 931.51,   0.00, 0.00, 0.00);
	CreateDynamicObject(19463, 1279.17, 1742.30, 928.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(19463, 1279.17, 1742.30, 931.51,   0.00, 0.00, 0.00);
	CreateDynamicObject(19463, 1279.17, 1751.93, 928.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(19463, 1279.17, 1751.93, 931.51,   0.00, 0.00, 0.00);
	CreateDynamicObject(1533, 1280.21, 1752.52, 926.31,   0.00, 0.00, 0.00);
	CreateDynamicObject(1537, 1283.22, 1752.53, 926.31,   0.00, 0.00, 0.00);
	CreateDynamicObject(3440, 1295.03, 1747.05, 928.66,   0.00, 0.00, 0.00);
	CreateDynamicObject(19453, 1291.84, 1734.68, 923.73,   0.00, 0.00, -45.00);
	CreateDynamicObject(1533, 1290.85, 1733.51, 922.76,   0.00, 0.00, 45.00);
	CreateDynamicObject(1537, 1292.98, 1735.64, 922.76,   0.00, 0.00, 45.00);
	CreateDynamicObject(2773, 1291.52, 1732.52, 923.29,   0.00, 0.00, 45.00);
	CreateDynamicObject(2773, 1293.94, 1734.99, 923.29,   0.00, 0.00, 45.00);
	CreateDynamicObject(1649, 1293.65, 1736.18, 928.53,   0.00, 90.00, -124.32);
	CreateDynamicObject(1649, 1291.60, 1733.04, 928.53,   0.00, 90.00, -124.32);
	CreateDynamicObject(1649, 1289.51, 1729.81, 928.53,   0.00, 90.00, -124.32);
	CreateDynamicObject(3440, 1292.65, 1734.54, 928.66,   0.00, 0.00, 0.00);
	CreateDynamicObject(3440, 1290.61, 1731.34, 928.66,   0.00, 0.00, 0.00);
	CreateDynamicObject(1649, 1289.51, 1729.81, 928.53,   0.00, 90.00, -304.38);
	CreateDynamicObject(1649, 1291.60, 1733.04, 928.53,   0.00, 90.00, -304.32);
	CreateDynamicObject(1649, 1293.65, 1736.18, 928.53,   0.00, 90.00, -304.32);
	CreateDynamicObject(1649, 1295.06, 1740.09, 929.07,   0.00, 0.00, 270.00);
	CreateDynamicObject(1649, 1295.07, 1744.53, 929.07,   0.00, 0.00, 270.00);
	CreateDynamicObject(1649, 1295.07, 1744.53, 929.07,   0.00, 0.00, 90.00);
	CreateDynamicObject(1649, 1295.06, 1740.09, 929.07,   0.00, 0.00, 90.00);
	CreateDynamicObject(1649, 1286.00, 1727.96, 929.07,   0.00, 0.00, 0.00);
	CreateDynamicObject(1649, 1281.56, 1727.96, 929.07,   0.00, 0.00, 0.00);
	CreateDynamicObject(1649, 1281.56, 1727.96, 929.07,   0.00, 0.00, -179.28);
	CreateDynamicObject(1649, 1286.00, 1727.96, 929.07,   0.00, 0.00, -179.88);
	CreateDynamicObject(2206, 1289.50, 1733.18, 926.35,   0.00, 0.00, 54.84);
	CreateDynamicObject(1671, 1290.43, 1732.96, 926.80,   0.00, 0.00, -131.34);
	CreateDynamicObject(1671, 1291.06, 1733.92, 926.80,   0.00, 0.00, -111.42);
	CreateDynamicObject(1955, 1290.03, 1733.98, 927.41,   114.00, -90.00, 34.24);
	CreateDynamicObject(1955, 1290.08, 1734.09, 927.41,   114.00, -90.00, 91.06);
	CreateDynamicObject(2894, 1289.89, 1733.47, 927.29,   0.00, 0.00, 42.30);
	CreateDynamicObject(2894, 1290.41, 1734.25, 927.29,   0.00, 0.00, -106.86);
	CreateDynamicObject(19143, 1288.89, 1738.96, 930.72,   0.00, 0.00, -162.42);
	CreateDynamicObject(19143, 1285.23, 1733.54, 930.72,   0.00, 0.00, -111.60);
	CreateDynamicObject(14604, 1287.37, 1735.87, 927.30,   0.00, 0.00, -124.80);
	CreateDynamicObject(14391, 1290.86, 1743.83, 927.31,   0.00, 0.00, 90.00);
	CreateDynamicObject(19463, 1290.23, 1742.85, 926.07,   0.00, 0.00, 90.00);
	CreateDynamicObject(18981, 1257.59, 1740.36, 935.14,   0.00, 90.00, 90.00);
	CreateDynamicObject(18981, 1282.59, 1765.36, 935.14,   0.00, 90.00, 90.00);
	CreateDynamicObject(18981, 1257.59, 1765.36, 935.14,   0.00, 90.00, 90.00);
	CreateDynamicObject(18981, 1257.59, 1596.84, 935.14,   0.00, 90.00, 90.00);
	CreateDynamicObject(18981, 1282.59, 1571.86, 935.14,   0.00, 90.00, 90.00);
	CreateDynamicObject(18981, 1257.59, 1571.86, 935.14,   0.00, 90.00, 90.00);
	CreateDynamicObject(18997, 1325.89, 1669.38, 948.26,   90.00, 0.00, 0.00);
	CreateDynamicObject(18997, 1339.18, 1669.38, 948.26,   90.00, 0.00, 0.00);
	CreateDynamicObject(18997, 1312.87, 1669.38, 948.26,   90.00, 0.00, 0.00);
	CreateDynamicObject(18997, 1332.56, 1669.38, 942.00,   90.00, 0.00, 0.00);
	CreateDynamicObject(18997, 1319.29, 1669.38, 942.00,   90.00, 0.00, 0.00);
	CreateDynamicObject(16090, 1326.96, 1659.65, 957.16,   0.00, 90.00, 0.00);
	CreateDynamicObject(16090, 1325.70, 1659.65, 957.16,   0.00, 90.00, 180.00);
	CreateDynamicObject(16090, 1325.70, 1680.31, 957.16,   0.00, 90.00, 180.00);
	CreateDynamicObject(16090, 1326.96, 1680.31, 957.16,   0.00, 90.00, 0.00);
	CreateDynamicObject(19144, 1317.54, 1682.00, 956.33,   0.00, 0.00, 167.94);
	CreateDynamicObject(19145, 1335.12, 1680.87, 956.33,   0.00, 0.00, -163.02);
	CreateDynamicObject(19146, 1335.10, 1660.20, 956.35,   0.00, 0.00, -9.30);
	CreateDynamicObject(19147, 1317.44, 1659.59, 956.33,   0.00, 0.00, 29.58);
	CreateDynamicObject(2290, 1358.19, 1737.26, 926.35,   0.00, 0.00, 32.28);
	CreateDynamicObject(2290, 1363.85, 1732.45, 926.35,   0.00, 0.00, -144.24);
	CreateDynamicObject(2290, 1363.47, 1735.78, 926.35,   0.00, 0.00, -54.48);
	CreateDynamicObject(2290, 1361.62, 1738.39, 926.35,   0.00, 0.00, -54.48);
	CreateDynamicObject(1516, 1360.11, 1736.31, 926.24,   0.00, 0.00, -56.58);
	CreateDynamicObject(1516, 1361.98, 1733.51, 926.24,   0.00, 0.00, -56.58);
	CreateDynamicObject(16151, 1362.39, 1751.47, 926.70,   0.00, 0.00, 90.00);
	CreateDynamicObject(2773, 1371.77, 1751.32, 926.86,   0.00, 0.00, 0.00);
	CreateDynamicObject(2773, 1368.35, 1751.37, 926.86,   0.00, 0.00, 0.00);
	CreateDynamicObject(1775, 1378.63, 1737.54, 927.45,   0.00, 0.00, -90.00);
	CreateDynamicObject(18765, 1326.18, 1702.13, 920.85,   0.00, 0.00, 0.00);
	CreateDynamicObject(1656, 1327.54, 1699.67, 923.47,   0.00, 0.00, 90.00);
	CreateDynamicObject(1656, 1327.94, 1699.67, 923.47,   0.00, 0.00, 90.00);
	CreateDynamicObject(1656, 1327.14, 1699.67, 923.47,   0.00, 0.00, 90.00);
	CreateDynamicObject(1656, 1326.74, 1699.67, 923.47,   0.00, 0.00, 90.00);
	CreateDynamicObject(1656, 1326.34, 1699.67, 923.47,   0.00, 0.00, 90.00);
	CreateDynamicObject(1656, 1325.93, 1699.67, 923.47,   0.00, 0.00, 90.00);
	CreateDynamicObject(1656, 1325.53, 1699.67, 923.47,   0.00, 0.00, 90.00);
	CreateDynamicObject(1656, 1325.13, 1699.67, 923.47,   0.00, 0.00, 90.00);
	CreateDynamicObject(1656, 1324.73, 1699.67, 923.47,   0.00, 0.00, 90.00);
	CreateDynamicObject(1656, 1326.74, 1699.67, 923.71,   0.00, 0.00, 90.00);
	CreateDynamicObject(1656, 1326.34, 1699.67, 923.71,   0.00, 0.00, 90.00);
	CreateDynamicObject(1656, 1325.93, 1699.67, 923.71,   0.00, 0.00, 90.00);
	CreateDynamicObject(1656, 1325.53, 1699.67, 923.71,   0.00, 0.00, 90.00);
	CreateDynamicObject(1656, 1325.13, 1699.67, 923.71,   0.00, 0.00, 90.00);
	CreateDynamicObject(1656, 1324.73, 1699.67, 923.71,   0.00, 0.00, 90.00);
	CreateDynamicObject(1656, 1325.93, 1699.67, 923.95,   0.00, 0.00, 90.00);
	CreateDynamicObject(1656, 1326.34, 1699.67, 923.95,   0.00, 0.00, 90.00);
	CreateDynamicObject(1656, 1326.74, 1699.67, 923.95,   0.00, 0.00, 90.00);
	CreateDynamicObject(16090, 1326.33, 1708.62, 922.18,   0.00, 0.00, 90.00);
	CreateDynamicObject(16090, 1326.33, 1695.42, 922.18,   0.00, 0.00, 90.00);
	CreateDynamicObject(19150, 1331.86, 1707.79, 928.87,   0.00, 0.00, -206.58);
	CreateDynamicObject(19151, 1322.20, 1696.20, 928.87,   0.00, 0.00, -54.60);
	CreateDynamicObject(19152, 1331.93, 1696.24, 928.80,   0.00, 0.00, 32.76);
	CreateDynamicObject(19153, 1321.32, 1707.84, 928.84,   0.00, 0.00, -142.62);
	CreateDynamicObject(2491, 1329.33, 1704.78, 922.73,   0.00, 0.00, -45.48);
	CreateDynamicObject(1955, 1329.08, 1704.86, 924.80,   90.00, 0.00, 45.00);
	CreateDynamicObject(19463, 1375.02, 1727.33, 923.94,   0.00, 0.00, 90.00);
	CreateDynamicObject(18553, 1374.47, 1727.22, 923.56,   0.00, 0.00, -91.00);
	CreateDynamicObject(19463, 1373.63, 1610.34, 923.94,   0.00, 0.00, 90.00);
	CreateDynamicObject(18553, 1374.62, 1610.41, 923.56,   0.00, 0.00, -270.94);
	CreateDynamicObject(19463, 1391.64, 1611.84, 932.30,   0.00, 0.00, 90.00);
	CreateDynamicObject(18553, 1392.49, 1611.93, 931.87,   0.00, 0.00, 89.76);
	CreateDynamicObject(19463, 1392.65, 1727.23, 932.30,   0.00, 0.00, 90.00);
	CreateDynamicObject(18553, 1392.41, 1727.13, 931.87,   0.00, 0.00, 269.04);
	CreateDynamicObject(2942, 1378.75, 1740.18, 926.95,   0.00, 0.00, -90.00);
	CreateDynamicObject(14782, 1378.76, 1746.54, 927.32,   0.00, 0.00, -90.00);
	CreateDynamicObject(2773, 1286.44, 1585.88, 926.86,   0.00, 0.00, 0.00);
	CreateDynamicObject(2773, 1283.01, 1585.89, 926.86,   0.00, 0.00, 0.00);
	CreateDynamicObject(2290, 1281.32, 1608.73, 926.35,   0.00, 0.00, 0.00);
	CreateDynamicObject(2290, 1279.80, 1605.15, 926.35,   0.00, 0.00, 90.00);
	CreateDynamicObject(2290, 1283.35, 1603.62, 926.35,   0.00, 0.00, 180.00);
	CreateDynamicObject(16151, 1290.93, 1585.79, 926.70,   0.00, 0.00, -90.00);
	CreateDynamicObject(2291, 1287.72, 1606.59, 926.35,   0.00, 0.00, 129.78);
	CreateDynamicObject(2291, 1288.35, 1605.86, 926.35,   0.00, 0.00, 129.78);
	CreateDynamicObject(2291, 1289.98, 1604.16, 926.35,   0.00, 0.00, 129.78);
	CreateDynamicObject(2291, 1290.64, 1603.40, 926.35,   0.00, 0.00, 129.78);
	CreateDynamicObject(2291, 1292.08, 1601.82, 926.35,   0.00, 0.00, 129.78);
	CreateDynamicObject(2291, 1292.75, 1601.08, 926.35,   0.00, 0.00, 129.78);
	CreateDynamicObject(14651, 1289.42, 1595.86, 928.29,   0.00, 0.00, 42.84);
	CreateDynamicObject(14651, 1286.42, 1599.00, 928.29,   0.00, 0.00, 42.84);
	CreateDynamicObject(1516, 1282.30, 1606.23, 926.14,   0.00, 0.00, 0.00);
	CreateDynamicObject(2009, 1357.08, 1595.83, 926.35,   0.00, 0.00, 0.00);
	CreateDynamicObject(2009, 1357.07, 1593.87, 926.35,   0.00, 0.00, 0.00);
	CreateDynamicObject(2009, 1357.07, 1591.89, 926.35,   0.00, 0.00, 0.00);
	CreateDynamicObject(1533, 1362.68, 1584.56, 926.32,   0.00, 0.00, 180.00);
	CreateDynamicObject(1537, 1359.68, 1584.56, 926.32,   0.00, 0.00, 180.00);
	CreateDynamicObject(1671, 1357.68, 1591.88, 926.78,   0.00, 0.00, -150.18);
	CreateDynamicObject(1671, 1357.87, 1594.00, 926.78,   0.00, 0.00, -150.18);
	CreateDynamicObject(1671, 1357.96, 1596.07, 926.78,   0.00, 0.00, -150.18);
	CreateDynamicObject(2606, 1354.84, 1590.08, 930.02,   0.00, 0.00, 90.00);
	CreateDynamicObject(2606, 1354.84, 1588.10, 930.02,   0.00, 0.00, 90.00);
	CreateDynamicObject(2606, 1354.84, 1590.08, 929.58,   0.00, 0.00, 90.00);
	CreateDynamicObject(2606, 1354.84, 1590.08, 929.12,   0.00, 0.00, 90.00);
	CreateDynamicObject(2606, 1354.84, 1590.08, 928.66,   0.00, 0.00, 90.00);
	CreateDynamicObject(2606, 1354.84, 1588.10, 929.58,   0.00, 0.00, 90.00);
	CreateDynamicObject(2606, 1354.84, 1588.10, 929.12,   0.00, 0.00, 90.00);
	CreateDynamicObject(2606, 1354.84, 1588.10, 928.66,   0.00, 0.00, 90.00);
	CreateDynamicObject(2206, 1366.92, 1602.45, 926.35,   0.00, 0.00, 90.00);
	CreateDynamicObject(1671, 1368.03, 1603.38, 926.78,   0.00, 0.00, -89.16);
	CreateDynamicObject(19463, 1256.29, 1726.45, 932.30,   0.00, 0.00, 90.00);
	CreateDynamicObject(18553, 1257.35, 1726.36, 931.88,   0.00, 0.00, -90.06);
	CreateDynamicObject(19463, 1257.07, 1609.77, 932.30,   0.00, 0.00, 90.00);
	CreateDynamicObject(18553, 1257.41, 1609.91, 931.88,   0.00, 0.00, -272.82);
	CreateDynamicObject(19463, 1274.51, 1610.91, 923.91,   0.00, 0.00, 90.00);
	CreateDynamicObject(18553, 1275.72, 1611.00, 923.56,   0.00, 0.00, 88.14);
	CreateDynamicObject(19463, 1274.32, 1725.09, 923.91,   0.00, 0.00, 90.00);
	CreateDynamicObject(18553, 1275.28, 1725.01, 923.56,   0.00, 0.00, 269.28);
	CreateDynamicObject(19463, 1353.23, 1587.56, 923.91,   0.00, 0.00, 0.00);
	CreateDynamicObject(18553, 1353.12, 1588.81, 923.51,   0.00, 0.00, -180.42);
	CreateDynamicObject(19463, 1296.00, 1587.51, 923.91,   0.00, 0.00, 0.00);
	CreateDynamicObject(18553, 1296.08, 1588.80, 923.51,   0.00, 0.00, -1.38);
	CreateDynamicObject(19463, 1296.39, 1752.10, 923.91,   0.00, 0.00, 0.00);
	CreateDynamicObject(18553, 1296.50, 1750.78, 923.53,   0.00, 0.00, -0.54);
	CreateDynamicObject(19463, 1352.97, 1751.91, 923.91,   0.00, 0.00, 0.00);
	CreateDynamicObject(18553, 1352.88, 1750.94, 923.53,   0.00, 0.00, -180.72);
	CreateDynamicObject(19463, 1352.44, 1768.33, 932.24,   0.00, 0.00, 0.00);
	CreateDynamicObject(18553, 1352.38, 1769.02, 931.86,   0.00, 0.00, 179.04);
	CreateDynamicObject(19463, 1295.91, 1770.14, 932.24,   0.00, 0.00, 0.00);
	CreateDynamicObject(18553, 1296.00, 1769.10, 931.84,   0.00, 0.00, -0.36);
	CreateDynamicObject(19463, 1352.98, 1569.40, 932.24,   0.00, 0.00, 0.00);
	CreateDynamicObject(18553, 1352.89, 1570.83, 931.86,   0.00, 0.00, -180.72);
	CreateDynamicObject(19463, 1295.91, 1569.44, 932.24,   0.00, 0.00, 0.00);
	CreateDynamicObject(18553, 1295.99, 1570.65, 931.86,   0.00, 0.00, -0.78);

	//Pool
	CreateDynamicObject(6959,2587.9550800,-2251.0996100,0.2000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(vegasnbball1) (1)
	CreateDynamicObject(6959,2670.6494100,-2251.0996100,0.2000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(vegasnbball1) (2)
	CreateDynamicObject(6959,2629.2998000,-2251.0996100,0.2000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(vegasnbball1) (3)
	CreateDynamicObject(3113,2605.5000000,-2245.3999000,4.0000000,0.0000000,90.0000000,270.0000000, .worldid = 1); //object(carrier_door_sfse) (1)
	CreateDynamicObject(10397,2607.0000000,-2287.6992200,3.9900000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(hc_stadlight1_sfs) (1)
	CreateDynamicObject(8240,2641.0000000,-2287.8994100,9.0000000,0.0000000,0.0000000,90.0000000, .worldid = 1); //object(vgssbighanger1) (1)
	CreateDynamicObject(8240,2571.5000000,-2287.8930000,9.0000000,0.0000000,0.0000000,270.0000000, .worldid = 1); //object(vgssbighanger1) (2)
	CreateDynamicObject(4867,2595.3000000,-2230.1000000,-2.0000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(lasrnway3_las) (1)
	CreateDynamicObject(6959,2546.6101100,-2251.1001000,0.2000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(vegasnbball1) (1)
	CreateDynamicObject(6959,2546.5996100,-2291.0996100,0.2000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(vegasnbball1) (1)
	CreateDynamicObject(6959,2546.5937500,-2331.0996100,0.2000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(vegasnbball1) (1)
	CreateDynamicObject(6959,2587.9394500,-2325.7998000,0.2000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(vegasnbball1) (1)
	CreateDynamicObject(6959,2629.2871100,-2325.8000500,0.2000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(vegasnbball1) (1)
	CreateDynamicObject(6959,2670.6396500,-2291.0996100,0.2000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(vegasnbball1) (1)
	CreateDynamicObject(6959,2670.5996100,-2331.0996100,0.2000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(vegasnbball1) (1)
	CreateDynamicObject(9339,2648.9299300,-2284.0000000,-0.3000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(sfnvilla001_cm) (1)
	CreateDynamicObject(9339,2648.8999000,-2292.8798800,-0.3150000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(sfnvilla001_cm) (2)
	CreateDynamicObject(9339,2636.0000000,-2305.8095700,-0.3100000,0.0000000,0.0000000,90.0000000, .worldid = 1); //object(sfnvilla001_cm) (3)
	CreateDynamicObject(9339,2610.6755400,-2305.8000500,-0.3100000,0.0000000,0.0000000,90.0000000, .worldid = 1); //object(sfnvilla001_cm) (4)
	CreateDynamicObject(9339,2584.5498000,-2305.7978500,-0.3100000,0.0000000,0.0000000,90.0000000, .worldid = 1); //object(sfnvilla001_cm) (5)
	CreateDynamicObject(9339,2636.0000000,-2271.0759300,-0.3100000,0.0000000,0.0000000,90.0000000, .worldid = 1); //object(sfnvilla001_cm) (5)
	CreateDynamicObject(2774,2649.1992200,-2273.7998000,-12.0000000,0.0000000,179.9950000,0.0000000, .worldid = 1); //object(cj_airp_pillars) (1)
	CreateDynamicObject(2774,2649.1992200,-2277.6992200,-12.0000000,0.0000000,179.9950000,0.0000000, .worldid = 1); //object(cj_airp_pillars) (2)
	CreateDynamicObject(2774,2649.1992200,-2281.5996100,-12.0000000,0.0000000,179.9950000,0.0000000, .worldid = 1); //object(cj_airp_pillars) (3)
	CreateDynamicObject(2774,2649.1999500,-2294.6001000,-12.0000000,0.0000000,179.9950000,0.0000000, .worldid = 1); //object(cj_airp_pillars) (4)
	CreateDynamicObject(2774,2649.1999500,-2290.1001000,-12.0000000,0.0000000,179.9950000,0.0000000, .worldid = 1); //object(cj_airp_pillars) (5)
	CreateDynamicObject(2774,2649.1999500,-2285.6999500,-12.0000000,0.0000000,179.9950000,0.0000000, .worldid = 1); //object(cj_airp_pillars) (6)
	CreateDynamicObject(2774,2649.1999500,-2303.0000000,-12.0000000,0.0000000,179.9950000,0.0000000, .worldid = 1); //object(cj_airp_pillars) (7)
	CreateDynamicObject(2774,2649.1992200,-2298.7998000,-12.0000000,0.0000000,179.9950000,0.0000000, .worldid = 1); //object(cj_airp_pillars) (8)
	CreateDynamicObject(1698,2649.5000000,-2304.3000500,0.0400000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(esc_step8) (1)
	CreateDynamicObject(1698,2649.6001000,-2300.6999500,0.0400000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(esc_step8) (2)
	CreateDynamicObject(1698,2649.6001000,-2296.6001000,0.0400000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(esc_step8) (3)
	CreateDynamicObject(1698,2649.6001000,-2292.2590300,0.0400000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(esc_step8) (4)
	CreateDynamicObject(1698,2649.6001000,-2287.6999500,0.0400000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(esc_step8) (5)
	CreateDynamicObject(1698,2649.6001000,-2283.6001000,0.0400000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(esc_step8) (6)
	CreateDynamicObject(1698,2649.6001000,-2279.5000000,0.0400000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(esc_step8) (7)
	CreateDynamicObject(1698,2649.6999500,-2276.1001000,0.0400000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(esc_step8) (8)
	CreateDynamicObject(1698,2649.6001000,-2272.6999500,0.0400000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(esc_step8) (9)
	CreateDynamicObject(1892,2605.7500000,-2253.7998000,0.1600000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(security_gatsh) (1)
	CreateDynamicObject(1698,2648.5000000,-2277.6999500,1.0000000,0.0000000,0.0000000,90.0000000, .worldid = 1); //object(esc_step8) (10)
	CreateDynamicObject(1698,2648.5000000,-2281.6001000,1.0000000,0.0000000,0.0000000,90.0000000, .worldid = 1); //object(esc_step8) (11)
	CreateDynamicObject(1698,2648.5000000,-2285.6999500,1.0000000,0.0000000,0.0000000,90.0000000, .worldid = 1); //object(esc_step8) (12)
	CreateDynamicObject(1698,2648.5000000,-2290.1001000,1.0000000,0.0000000,0.0000000,90.0000000, .worldid = 1); //object(esc_step8) (13)
	CreateDynamicObject(1698,2648.5000000,-2294.6001000,1.0000000,0.0000000,0.0000000,90.0000000, .worldid = 1); //object(esc_step8) (14)
	CreateDynamicObject(1698,2648.5000000,-2298.8000500,1.0000000,0.0000000,0.0000000,90.0000000, .worldid = 1); //object(esc_step8) (15)
	CreateDynamicObject(1698,2648.5000000,-2303.0000000,1.0000000,0.0000000,0.0000000,90.0000000, .worldid = 1); //object(esc_step8) (16)
	CreateDynamicObject(1698,2648.5000000,-2273.8000500,1.0000000,0.0000000,0.0000000,90.0000000, .worldid = 1); //object(esc_step8) (17)
	CreateDynamicObject(9339,2609.8898900,-2271.0749500,-0.3080000,0.0000000,0.0000000,90.0000000, .worldid = 1); //object(sfnvilla001_cm) (5)
	CreateDynamicObject(9339,2583.8000500,-2271.0800800,-0.3000000,0.0000000,0.0000000,90.0000000, .worldid = 1); //object(sfnvilla001_cm) (5)
	CreateDynamicObject(9339,2580.1001000,-2305.8010300,-0.3000000,0.0000000,0.0000000,90.0000000, .worldid = 1); //object(sfnvilla001_cm) (5)
	CreateDynamicObject(9339,2580.1894500,-2271.0849600,-0.3050000,0.0000000,0.0000000,90.0000000, .worldid = 1); //object(sfnvilla001_cm) (5)
	CreateDynamicObject(9339,2567.1992200,-2284.0000000,-0.3000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(sfnvilla001_cm) (5)
	CreateDynamicObject(9339,2567.1845700,-2292.7998000,-0.3090000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(sfnvilla001_cm) (5)
	CreateDynamicObject(8177,2667.5000000,-2286.7998000,1.5000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(vgs_concwall05) (1)
	CreateDynamicObject(8176,2683.8994100,-2311.1992200,12.1000000,0.0000000,0.0000000,90.0000000, .worldid = 1); //object(vgs_concwall04) (1)
	CreateDynamicObject(3452,2666.8994100,-2260.6796900,5.5300000,0.0000000,0.0000000,90.0000000, .worldid = 1); //object(bballintvgn1) (1)
	CreateDynamicObject(3452,2666.8990000,-2290.3000000,5.5300000,0.0000000,0.0000000,90.0000000, .worldid = 1); //object(bballintvgn1) (2)
	CreateDynamicObject(3452,2666.8999000,-2319.9250500,5.5300000,0.0000000,0.0000000,90.0000000, .worldid = 1); //object(bballintvgn1) (3)
	CreateDynamicObject(6959,2597.5000000,-2322.6999500,-4.0000000,270.0000000,0.0000000,0.0000000, .worldid = 1); //object(vegasnbball1) (1)
	CreateDynamicObject(8176,2649.5000000,-2250.5000000,12.1000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(vgs_concwall04) (2)
	CreateDynamicObject(6959,2679.6992200,-2255.1992200,12.6000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(vegasnbball1) (3)
	CreateDynamicObject(6959,2679.6990000,-2321.3980000,12.6000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(vegasnbball1) (3)
	CreateDynamicObject(6959,2679.6499000,-2255.6101100,10.6399000,0.0000000,180.0000000,0.0000000, .worldid = 1); //object(vegasnbball1) (3)
	CreateDynamicObject(6959,2679.6689500,-2321.3120100,10.6400000,0.0000000,179.9950000,0.0000000, .worldid = 1); //object(vegasnbball1) (3)
	CreateDynamicObject(3452,2553.2998000,-2315.0996100,5.5300000,0.0000000,0.0000000,270.0000000, .worldid = 1); //object(bballintvgn1) (1)
	CreateDynamicObject(3452,2553.2998000,-2285.4755900,5.5300000,0.0000000,0.0000000,269.9950000, .worldid = 1); //object(bballintvgn1) (1)
	CreateDynamicObject(3452,2553.3000500,-2255.8508300,5.5300000,0.0000000,0.0000000,269.9950000, .worldid = 1); //object(bballintvgn1) (1)
	CreateDynamicObject(8177,2552.5996100,-2277.5000000,1.5000000,0.0000000,0.0000000,179.9950000, .worldid = 1); //object(vgs_concwall05) (1)
	CreateDynamicObject(8177,2534.5000000,-2276.1001000,9.0000000,0.0000000,0.0000000,179.9950000, .worldid = 1); //object(vgs_concwall05) (1)
	CreateDynamicObject(8177,2534.5000000,-2283.3994100,11.8530000,0.0000000,0.0000000,179.9950000, .worldid = 1); //object(vgs_concwall05) (1)
	CreateDynamicObject(6959,2523.7000000,-2305.3990000,13.1000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(vegasnbball1) (1)
	CreateDynamicObject(6959,2523.5000000,-2265.3990000,13.1000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(vegasnbball1) (1)
	CreateDynamicObject(3851,2544.2998000,-2259.7998000,15.1000000,0.0000000,0.0000000,179.9950000, .worldid = 1); //object(carshowwin_sfsx) (1)
	CreateDynamicObject(3851,2544.2998000,-2271.0996100,15.1000000,0.0000000,0.0000000,179.9950000, .worldid = 1); //object(carshowwin_sfsx) (2)
	CreateDynamicObject(3851,2544.2998000,-2282.3994100,15.1000000,0.0000000,0.0000000,179.9950000, .worldid = 1); //object(carshowwin_sfsx) (3)
	CreateDynamicObject(3851,2544.3000000,-2293.7000000,15.1000000,0.0000000,0.0000000,179.9950000, .worldid = 1); //object(carshowwin_sfsx) (4)
	CreateDynamicObject(3851,2544.3000500,-2305.0000000,15.1000000,0.0000000,0.0000000,179.9950000, .worldid = 1); //object(carshowwin_sfsx) (5)
	CreateDynamicObject(3851,2544.3000500,-2316.3000500,15.1000000,0.0000000,0.0000000,179.9950000, .worldid = 1); //object(carshowwin_sfsx) (6)
	CreateDynamicObject(8177,2554.0000000,-2286.3990000,18.5000000,0.0000000,179.9950000,179.9950000, .worldid = 1); //object(vgs_concwall05) (1)
	CreateDynamicObject(3851,2544.1001000,-2316.1001000,15.1000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(carshowwin_sfsx) (7)
	CreateDynamicObject(3851,2544.0996100,-2304.7998000,15.1000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(carshowwin_sfsx) (8)
	CreateDynamicObject(3851,2544.1001000,-2293.5000000,15.1000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(carshowwin_sfsx) (9)
	CreateDynamicObject(3851,2544.0996100,-2282.1992200,15.1000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(carshowwin_sfsx) (10)
	CreateDynamicObject(3851,2544.0996100,-2270.8994100,15.1000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(carshowwin_sfsx) (11)
	CreateDynamicObject(3851,2544.1001000,-2259.6001000,15.1000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(carshowwin_sfsx) (12)
	CreateDynamicObject(1569,2539.3999000,-2321.6999500,13.0000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(adam_v_door) (1)
	CreateDynamicObject(1569,2542.3999000,-2321.6999500,13.0000000,0.0000000,0.0000000,180.0000000, .worldid = 1); //object(adam_v_door) (2)
	CreateDynamicObject(1569,2547.8000500,-2321.6999500,0.1000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(adam_v_door) (3)
	CreateDynamicObject(1569,2550.8000500,-2321.6999500,0.1000000,0.0000000,0.0000000,179.9950000, .worldid = 1); //object(adam_v_door) (4)
	CreateDynamicObject(2773,2551.0000000,-2320.3999000,0.7000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(cj_airprt_bar) (1)
	CreateDynamicObject(2773,2551.0000000,-2318.0000000,0.7000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(cj_airprt_bar) (2)
	CreateDynamicObject(2773,2547.6001000,-2320.3999000,0.7000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(cj_airprt_bar) (3)
	CreateDynamicObject(2773,2547.6001000,-2318.0000000,0.7000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(cj_airprt_bar) (4)
	CreateDynamicObject(2011,2551.6999500,-2321.0000000,0.1000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(nu_plant2_ofc) (1)
	CreateDynamicObject(2011,2546.8999000,-2321.1001000,0.1000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(nu_plant2_ofc) (2)
	CreateDynamicObject(2011,2542.6999500,-2321.1001000,13.0500000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(nu_plant2_ofc) (3)
	CreateDynamicObject(2011,2539.1999500,-2321.1999500,13.0500000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(nu_plant2_ofc) (4)
	CreateDynamicObject(2773,2542.3999000,-2319.6999500,13.6000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(cj_airprt_bar) (5)
	CreateDynamicObject(2773,2539.3999000,-2319.6999500,13.6000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(cj_airprt_bar) (6)
	CreateDynamicObject(8176,2639.3000000,-2295.2000000,-2.4000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(vgs_concwall04) (2)
	CreateDynamicObject(1569,2544.5000000,-2321.6999500,7.6000000,0.0000000,0.0000000,90.0000000, .worldid = 1); //object(adam_v_door) (5)
	CreateDynamicObject(7371,2562.6001000,-2264.3999000,-0.1000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(vgsnelec_fence_02) (1)
	CreateDynamicObject(1506,2671.1796900,-2254.1298800,0.1000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(gen_doorext08) (1)
	CreateDynamicObject(1506,2671.1992200,-2254.0996100,0.1000000,0.0000000,0.0000000,179.9950000, .worldid = 1); //object(gen_doorext08) (2)
	CreateDynamicObject(2773,2669.5000000,-2255.3999000,0.7000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(cj_airprt_bar) (7)
	CreateDynamicObject(2773,2669.5000000,-2257.7998000,0.7000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(cj_airprt_bar) (8)
	CreateDynamicObject(2773,2672.6999500,-2255.5000000,0.7000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(cj_airprt_bar) (9)
	CreateDynamicObject(2773,2672.6999500,-2257.8999000,0.7000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(cj_airprt_bar) (10)
	CreateDynamicObject(2773,2669.1001000,-2260.1999500,0.7000000,0.0000000,0.0000000,334.0000000, .worldid = 1); //object(cj_airprt_bar) (11)
	CreateDynamicObject(2773,2673.1001000,-2260.3999000,0.7000000,0.0000000,0.0000000,24.0000000, .worldid = 1); //object(cj_airprt_bar) (12)
	CreateDynamicObject(1892,2669.6001000,-2264.6001000,0.1600000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(security_gatsh) (1)
	CreateDynamicObject(1892,2671.6001000,-2264.6001000,0.1600000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(security_gatsh) (1)
	CreateDynamicObject(7371,2657.6001000,-2311.1999500,-0.1000000,0.0000000,0.0000000,180.0000000, .worldid = 1); //object(vgsnelec_fence_02) (1)
	CreateDynamicObject(1506,2661.1001000,-2254.1001000,12.6000000,0.0000000,0.0000000,180.4950000, .worldid = 1); //object(gen_doorext08) (2)
	CreateDynamicObject(1506,2661.0000000,-2254.1298800,12.6000000,0.0000000,0.0000000,0.2500000, .worldid = 1); //object(gen_doorext08) (1)
	CreateDynamicObject(2773,2662.6999500,-2255.5000000,13.1000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(cj_airprt_bar) (8)
	CreateDynamicObject(2773,2662.6992200,-2257.8994100,13.1000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(cj_airprt_bar) (8)
	CreateDynamicObject(2773,2660.6001000,-2258.8000500,13.1000000,0.0000000,0.0000000,269.2500000, .worldid = 1); //object(cj_airprt_bar) (8)
	CreateDynamicObject(1518,2671.0000000,-2254.1001000,14.5000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(dyn_tv_2) (1)
	CreateDynamicObject(1518,2671.6001000,-2254.1001000,14.5000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(dyn_tv_2) (2)
	CreateDynamicObject(1518,2672.1999500,-2254.1001000,14.5000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(dyn_tv_2) (3)
	CreateDynamicObject(1518,2672.8000500,-2254.1001000,14.5000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(dyn_tv_2) (4)
	CreateDynamicObject(1808,2663.6001000,-2254.3999000,12.6000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(cj_watercooler2) (1)
	CreateDynamicObject(1808,2664.1001000,-2254.3999000,12.6000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(cj_watercooler2) (2)
	CreateDynamicObject(1808,2546.1001000,-2310.3999000,0.1800000,0.0000000,0.0000000,90.0000000, .worldid = 1); //object(cj_watercooler2) (3)
	CreateDynamicObject(1808,2546.1001000,-2264.0000000,0.1800000,0.0000000,0.0000000,90.0000000, .worldid = 1); //object(cj_watercooler2) (4)
	CreateDynamicObject(1808,2667.6999500,-2283.0000000,0.1800000,0.0000000,0.0000000,90.0000000, .worldid = 1); //object(cj_watercooler2) (5)
	CreateDynamicObject(1808,2667.6999500,-2312.6999500,0.1800000,0.0000000,0.0000000,90.0000000, .worldid = 1); //object(cj_watercooler2) (6)
	CreateDynamicObject(1892,2666.6001000,-2264.6999500,0.1600000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(security_gatsh) (1)
	CreateDynamicObject(1892,2674.5000000,-2264.6001000,0.1600000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(security_gatsh) (1)
	CreateDynamicObject(8177,2554.0090300,-2270.3999000,21.3560000,0.0000000,179.9950000,179.9950000, .worldid = 1); //object(vgs_concwall05) (1)
	CreateDynamicObject(8177,2621.3000500,-2235.8999000,1.5000000,0.0000000,0.0000000,89.9950000, .worldid = 1); //object(vgs_concwall05) (1)
	CreateDynamicObject(8177,2607.1999500,-2235.8999000,4.3490000,0.0000000,0.0000000,89.9950000, .worldid = 1); //object(vgs_concwall05) (1)
	CreateDynamicObject(2774,2605.3999000,-2253.0000000,6.0000000,90.0000000,0.0000000,90.0000000, .worldid = 1); //object(cj_airp_pillars) (2)
	CreateDynamicObject(2774,2605.6001000,-2253.0000000,19.0000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(cj_airp_pillars) (3)
	CreateDynamicObject(2774,2607.2629400,-2253.0000000,19.0000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(cj_airp_pillars) (3)
	CreateDynamicObject(1537,2654.1992200,-2254.1992200,0.1000000,0.0000000,0.0000000,358.7480000, .worldid = 1); //object(gen_doorext16) (1)
	CreateDynamicObject(8177,2605.5000000,-2236.3999000,1.0000000,0.0000000,320.0000000,90.0000000, .worldid = 1); //object(vgs_concwall05) (1)
	CreateDynamicObject(1537,2607.0000000,-2245.9399400,0.1500000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(gen_doorext16) (2)
	CreateDynamicObject(8177,2528.2000000,-2281.8990000,14.5000000,0.0000000,0.0000000,179.9950000, .worldid = 1); //object(vgs_concwall05) (1)
	CreateDynamicObject(8177,2528.2000000,-2270.0000000,17.3560000,0.0000000,0.0000000,179.9950000, .worldid = 1); //object(vgs_concwall05) (1)
	CreateDynamicObject(3851,2538.1001000,-2306.1001000,20.7500000,0.0000000,0.0000000,180.0000000, .worldid = 1); //object(carshowwin_sfsx) (8)
	CreateDynamicObject(3851,2538.1001000,-2294.8000500,20.6000000,0.0000000,0.0000000,179.9950000, .worldid = 1); //object(carshowwin_sfsx) (8)
	CreateDynamicObject(3851,2538.1001000,-2283.5000000,20.6000000,0.0000000,0.0000000,179.9950000, .worldid = 1); //object(carshowwin_sfsx) (8)
	CreateDynamicObject(3851,2538.1001000,-2272.1999500,20.6000000,0.0000000,0.0000000,179.9950000, .worldid = 1); //object(carshowwin_sfsx) (8)
	CreateDynamicObject(3851,2538.1001000,-2260.8999000,20.6000000,0.0000000,0.0000000,179.9950000, .worldid = 1); //object(carshowwin_sfsx) (8)
	CreateDynamicObject(8231,2573.8999000,-2152.0000000,1.7000000,0.0000000,0.0000000,180.0000000, .worldid = 1); //object(vgsbikeschl05) (1)
	CreateDynamicObject(1537,2571.1001000,-2160.4899900,-0.0300000,0.0000000,0.0000000,180.0000000, .worldid = 1); //object(gen_doorext16) (3)
	CreateDynamicObject(1709,2566.6001000,-2160.0000000,-0.0200000,0.0000000,0.0000000,90.0000000, .worldid = 1); //object(kb_couch08) (1)
	CreateDynamicObject(1710,2570.1999500,-2155.8000500,-0.0200000,0.0000000,0.0000000,270.0000000, .worldid = 1); //object(kb_couch07) (1)
	CreateDynamicObject(1818,2567.3999000,-2157.8000500,-0.0200000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(coffee_swank_2) (1)
	CreateDynamicObject(2591,2571.6999500,-2150.3000500,0.5000000,0.0000000,0.0000000,180.0000000, .worldid = 1); //object(ab_partition1) (1)
	CreateDynamicObject(6959,2573.3000500,-2150.6001000,0.0000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(vegasnbball1) (1)
	CreateDynamicObject(2604,2672.5000000,-2254.8000500,13.3500000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(cj_police_counter) (1)
	CreateDynamicObject(2606,2567.8999000,-2160.5000000,2.7000000,20.0000000,0.0000000,180.0000000, .worldid = 1); //object(cj_police_counter2) (1)
	CreateDynamicObject(14455,2565.1001000,-2149.0000000,1.7000000,0.0000000,0.0000000,269.7500000, .worldid = 1); //object(gs_bookcase) (1)
	CreateDynamicObject(3963,2565.0000000,-2157.1999500,2.2000000,0.0000000,0.0000000,270.0000000, .worldid = 1); //object(lee_plane08) (1)
	CreateDynamicObject(3964,2571.8000500,-2145.8999000,2.0000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(lee_plane09) (1)
	CreateDynamicObject(3504,2668.1999500,-2321.0000000,1.5000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(vgsn_portaloo) (1)
	CreateDynamicObject(3504,2669.8999000,-2321.0000000,1.5000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(vgsn_portaloo) (2)
	CreateDynamicObject(3504,2671.5000000,-2321.0000000,1.5000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(vgsn_portaloo) (3)
	CreateDynamicObject(3504,2673.1999500,-2321.0000000,1.5000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(vgsn_portaloo) (4)
	CreateDynamicObject(2774,2567.6999500,-2147.3000500,12.0000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(cj_airp_pillars) (12)
	CreateDynamicObject(2774,2570.8000500,-2147.3999000,12.0000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(cj_airp_pillars) (13)
	CreateDynamicObject(1491,2568.5000000,-2148.1001000,0.0000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(gen_doorint01) (1)
	CreateDynamicObject(1491,2565.3999000,-2148.1001000,0.0000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(gen_doorint01) (2)
	CreateDynamicObject(2774,2564.6001000,-2147.3000500,12.0000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(cj_airp_pillars) (14)
	CreateDynamicObject(2774,2567.6999500,-2145.6499000,12.0000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(cj_airp_pillars) (15)
	CreateDynamicObject(2774,2567.6999500,-2144.0000000,12.0000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(cj_airp_pillars) (16)
	CreateDynamicObject(2371,2570.8999000,-2145.8999000,0.0000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(clothes_rail) (1)
	CreateDynamicObject(2373,2569.1999500,-2143.3999000,0.0000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(clothes_rail3) (1)
	CreateDynamicObject(2374,2569.8999000,-2143.8000500,1.4000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(cj_tshirt) (1)
	CreateDynamicObject(2377,2569.1999500,-2143.8000500,1.4000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(cj_jean_dark) (1)
	CreateDynamicObject(2381,2570.5900900,-2145.3200700,0.7200000,0.0000000,0.0000000,90.0000000, .worldid = 1); //object(cj_8_sweater) (1)
	CreateDynamicObject(2396,2566.5000000,-2143.6999500,2.1000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(cj_4_s_sweater) (1)
	CreateDynamicObject(2398,2566.5000000,-2143.8000500,1.2000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(cj_trackies_light) (1)
	CreateDynamicObject(2630,2570.6999500,-2149.5000000,-0.0200000,0.0000000,0.0000000,310.0000000, .worldid = 1); //object(gym_bike) (1)
	CreateDynamicObject(2630,2570.8000500,-2151.1001000,-0.0200000,0.0000000,0.0000000,309.9960000, .worldid = 1); //object(gym_bike) (2)
	CreateDynamicObject(2818,2565.3999000,-2145.8000500,0.0000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(gb_bedrug02) (1)
	CreateDynamicObject(2818,2565.3999000,-2146.8999000,0.0000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(gb_bedrug02) (2)
	CreateDynamicObject(2818,2565.3999000,-2148.0000000,0.0000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(gb_bedrug02) (3)
	CreateDynamicObject(2818,2565.3999000,-2144.6999500,0.0000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(gb_bedrug02) (4)
	CreateDynamicObject(2818,2565.3999000,-2143.6001000,0.0000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(gb_bedrug02) (5)
	CreateDynamicObject(2817,2569.0000000,-2148.1001000,0.0000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(gb_bedrug01) (1)
	CreateDynamicObject(2827,2567.8999000,-2157.1999500,0.5000000,0.0000000,0.0000000,340.0000000, .worldid = 1); //object(gb_novels05) (1)
	CreateDynamicObject(2826,2567.6001000,-2157.5000000,0.5000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(gb_novels04) (1)
	CreateDynamicObject(2517,2565.3999000,-2145.1001000,0.0000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(cj_shower1) (1)
	CreateDynamicObject(2518,2570.1001000,-2148.6989700,0.1000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(cj_b_sink2) (1)
	CreateDynamicObject(1537,2575.8129900,-2143.5900900,-0.0300000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(gen_doorext16) (4)
	CreateDynamicObject(2071,2565.3000500,-2154.3000500,1.5000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(cj_mlight5) (1)
	CreateDynamicObject(2071,2570.1001000,-2160.1001000,1.5000000,0.0000000,0.0000000,212.0000000, .worldid = 1); //object(cj_mlight5) (2)
	CreateDynamicObject(2069,2565.3000500,-2146.1999500,0.0200000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(cj_mlight7) (1)
	CreateDynamicObject(2069,2570.1999500,-2146.3000500,0.0000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(cj_mlight7) (2)
	CreateDynamicObject(1893,2573.6001000,-2146.5000000,3.9000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(shoplight1) (1)
	CreateDynamicObject(1893,2660.5000000,-2256.1001000,16.5000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(shoplight1) (2)
	CreateDynamicObject(8176,2704.6001000,-2283.8999000,12.9000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(vgs_concwall04) (1)
	CreateDynamicObject(2614,2666.1999500,-2254.1889600,14.7000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(cj_us_flag) (1)
	CreateDynamicObject(2614,2667.5310100,-2260.1001000,2.1000000,0.0000000,0.0000000,90.0000000, .worldid = 1); //object(cj_us_flag) (2)
	CreateDynamicObject(18608,2671.0000000,-2263.3000500,20.6000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(counts_lights01) (1)
	CreateDynamicObject(18608,2663.3999000,-2263.3000500,20.6000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(counts_lights01) (2)
	CreateDynamicObject(1622,2674.1001000,-2265.6001000,2.9900000,0.0000000,351.0000000,19.0000000, .worldid = 1); //object(nt_securecam2_01) (1)
	CreateDynamicObject(14629,2540.8999000,-2280.0000000,20.8000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(mafcas_chande) (1)
	CreateDynamicObject(14618,2527.2000000,-2288.8000000,16.5900000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(ab_pillartemp1) (1)
	CreateDynamicObject(1775,2572.6999500,-2143.8000500,1.1000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(cj_sprunk1) (1)
	CreateDynamicObject(3055,2567.1999500,-2160.6999500,2.2000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(kmb_shutter) (1)
	CreateDynamicObject(1716,2672.1999500,-2255.5000000,12.6000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(kb_slot_stool) (1)
	CreateDynamicObject(1716,2673.8999000,-2255.3999000,12.6000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(kb_slot_stool) (2)
	CreateDynamicObject(3657,2610.5000000,-2254.6999500,0.7000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(airseata_las) (1)
	CreateDynamicObject(3657,2602.1001000,-2254.8999000,0.7000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(airseata_las) (3)
	CreateDynamicObject(638,2664.8000500,-2257.3000500,13.3000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(kb_planter_bush) (1)
	CreateDynamicObject(14537,2536.0000000,-2259.2000000,15.0000000,0.0000000,0.0000000,270.0000000, .worldid = 1); //object(pdomesbar) (1)
	CreateDynamicObject(1569,2674.3000000,-2314.5990000,7.2000000,0.0000000,0.0000000,90.0000000, .worldid = 1); //object(adam_v_door) (5)
	CreateDynamicObject(11472,2668.0000000,-2266.3999000,10.9900000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(des_swtstairs1) (1)
	CreateDynamicObject(10444,2683.3000500,-2266.1001000,13.7000000,0.0000000,0.0000000,90.0000000, .worldid = 1); //object(poolwater_sfs) (1)
	CreateDynamicObject(11472,2673.2519500,-2273.6982400,10.9990000,0.0000000,0.0000000,90.0000000, .worldid = 1); //object(des_swtstairs1) (3)
	CreateDynamicObject(11472,2673.2561000,-2259.6499000,10.9900000,0.0000000,0.0000000,90.0000000, .worldid = 1); //object(des_swtstairs1) (4)
	CreateDynamicObject(1598,2673.0000000,-2261.5996100,13.7900000,49.9990000,4.9990000,5.9990000, .worldid = 1); //object(beachball) (1)
	CreateDynamicObject(1641,2667.8999000,-2261.1999500,14.0001000,0.0000000,0.0000000,3.2500000, .worldid = 1); //object(beachtowel03) (1)
	CreateDynamicObject(1461,2674.0000000,-2259.5996100,14.5900000,0.0000000,0.0000000,309.9960000, .worldid = 1); //object(dyn_life_p) (1)
	CreateDynamicObject(2290,2664.6999500,-2259.5000000,12.5500000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(swk_couch_1) (2)
	CreateDynamicObject(1698,2659.8999000,-2273.6999500,12.9500000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(esc_step8) (18)
	CreateDynamicObject(1698,2659.8999000,-2270.3999000,12.9500000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(esc_step8) (19)
	CreateDynamicObject(1698,2659.8999000,-2267.1001000,12.9500000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(esc_step8) (20)
	CreateDynamicObject(1727,2660.1001000,-2274.0000000,13.0000000,0.0000000,0.0000000,270.0000000, .worldid = 1); //object(mrk_seating2b) (1)
	CreateDynamicObject(1698,2661.1999500,-2273.6999500,12.7000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(esc_step8) (21)
	CreateDynamicObject(1698,2661.1999500,-2270.3999000,12.7000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(esc_step8) (22)
	CreateDynamicObject(1698,2659.8999000,-2267.1001000,12.7000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(esc_step8) (23)
	CreateDynamicObject(1698,2661.1999500,-2267.1001000,12.7000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(esc_step8) (24)
	CreateDynamicObject(1727,2660.1001000,-2272.0000000,13.0000000,0.0000000,0.0000000,269.9950000, .worldid = 1); //object(mrk_seating2b) (2)
	CreateDynamicObject(1727,2660.1001000,-2270.0000000,13.0000000,0.0000000,0.0000000,269.9950000, .worldid = 1); //object(mrk_seating2b) (3)
	CreateDynamicObject(1727,2660.1001000,-2267.8999000,13.0000000,0.0000000,0.0000000,269.9950000, .worldid = 1); //object(mrk_seating2b) (4)
	CreateDynamicObject(1727,2660.1001000,-2265.8000500,13.0000000,0.0000000,0.0000000,269.9950000, .worldid = 1); //object(mrk_seating2b) (5)
	CreateDynamicObject(6959,2674.8000500,-2276.1001000,14.0000000,0.0000000,270.0000000,0.0000000, .worldid = 1); //object(vegasnbball1) (3)
	CreateDynamicObject(8177,2684.3000500,-2289.0000000,9.2460000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(vgs_concwall05) (1)
	CreateDynamicObject(8177,2684.3000500,-2289.0000000,12.1000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(vgs_concwall05) (1)
	CreateDynamicObject(8177,2684.3000500,-2289.0000000,6.3899000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(vgs_concwall05) (1)
	CreateDynamicObject(8177,2684.3000500,-2289.0000000,14.9500000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(vgs_concwall05) (1)
	CreateDynamicObject(8177,2684.3000500,-2285.3000500,17.8000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(vgs_concwall05) (1)
	CreateDynamicObject(8177,2684.3000500,-2289.0000000,20.6500000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(vgs_concwall05) (1)
	CreateDynamicObject(1537,2605.5000000,-2322.6999500,0.9000000,0.0000000,0.0000000,179.9950000, .worldid = 1); //object(gen_doorext16) (1)
	CreateDynamicObject(2207,2661.6999500,-2304.8999000,12.6000000,0.0000000,0.0000000,90.0000000, .worldid = 1); //object(med_office7_desk_1) (1)
	CreateDynamicObject(2356,2660.3999000,-2304.0000000,12.6000000,0.0000000,0.0000000,272.0000000, .worldid = 1); //object(police_off_chair) (1)
	CreateDynamicObject(2894,2661.5000000,-2304.5000000,13.4000000,0.0000000,0.0000000,224.0000000, .worldid = 1); //object(kmb_rhymesbook) (1)
	CreateDynamicObject(2290,2660.1001000,-2319.8999000,12.6000000,0.0000000,0.0000000,90.0000000, .worldid = 1); //object(swk_couch_1) (1)
	CreateDynamicObject(2284,2660.8999000,-2321.1001000,14.6000000,0.0000000,0.0000000,180.0000000, .worldid = 1); //object(frame_6) (1)
	CreateDynamicObject(1754,2661.1999500,-2316.6999500,12.6000000,0.0000000,0.0000000,28.0000000, .worldid = 1); //object(swank_single_1) (1)
	CreateDynamicObject(2204,2662.5000000,-2321.6001000,12.6000000,0.0000000,0.0000000,180.0000000, .worldid = 1); //object(med_office8_cabinet) (1)
	CreateDynamicObject(2295,2663.5000000,-2321.3000500,12.6000000,0.0000000,0.0000000,96.0000000, .worldid = 1); //object(cj_beanbag) (1)
	CreateDynamicObject(2311,2662.3000500,-2319.8000500,12.4689000,0.0000000,0.0000000,94.0000000, .worldid = 1); //object(cj_tv_table2) (1)
	CreateDynamicObject(1852,2538.5000000,-2261.4000000,17.1000000,0.0000000,0.0000000,338.0000000, .worldid = 1); //object(dice02) (1)
	CreateDynamicObject(1726,2539.7000000,-2272.8000000,13.1000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(mrk_seating2) (1)
	CreateDynamicObject(1726,2539.0000000,-2275.9000000,13.1000000,0.0000000,0.0000000,90.0000000, .worldid = 1); //object(mrk_seating2) (2)
	CreateDynamicObject(1726,2541.6000000,-2277.0000000,13.1000000,0.0000000,0.0000000,180.0000000, .worldid = 1); //object(mrk_seating2) (3)
	CreateDynamicObject(1726,2539.6000000,-2278.3000000,13.1000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(mrk_seating2) (4)
	CreateDynamicObject(1726,2539.0000000,-2281.5000000,13.1000000,0.0000000,0.0000000,90.0000000, .worldid = 1); //object(mrk_seating2) (5)
	CreateDynamicObject(1726,2541.7000000,-2282.6000000,13.1000000,0.0000000,0.0000000,179.9950000, .worldid = 1); //object(mrk_seating2) (6)
	CreateDynamicObject(2125,2541.5000000,-2263.2000000,13.4000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(med_din_chair_1) (1)
	CreateDynamicObject(2125,2541.5000000,-2262.0000000,13.4000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(med_din_chair_1) (2)
	CreateDynamicObject(2125,2541.9000000,-2260.9000000,13.4000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(med_din_chair_1) (3)
	CreateDynamicObject(2125,2542.3000000,-2259.8000000,13.4000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(med_din_chair_1) (4)
	CreateDynamicObject(2125,2542.3000000,-2258.4000000,13.4000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(med_din_chair_1) (5)
	CreateDynamicObject(2125,2541.8000000,-2257.4000000,13.4000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(med_din_chair_1) (6)
	CreateDynamicObject(2125,2541.5000000,-2256.3000000,13.4000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(med_din_chair_1) (7)
	CreateDynamicObject(2125,2541.5000000,-2255.1000000,13.4000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(med_din_chair_1) (8)
	CreateDynamicObject(2125,2540.3000000,-2264.6000000,13.4000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(med_din_chair_1) (9)
	CreateDynamicObject(2125,2539.0000000,-2264.6000000,13.4000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(med_din_chair_1) (10)
	CreateDynamicObject(2370,2540.5000000,-2280.8000000,12.6000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(shop_set_1_table) (1)
	CreateDynamicObject(2370,2540.5000000,-2275.3000000,12.6000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(shop_set_1_table) (2)
	CreateDynamicObject(14782,2538.6010000,-2298.6000000,14.1000000,0.0000000,0.0000000,90.0000000, .worldid = 1); //object(int3int_boxing30) (1)
	CreateDynamicObject(956,2538.7000000,-2291.6000000,13.4500000,0.0000000,0.0000000,90.0000000, .worldid = 1); //object(cj_ext_candy) (1)
	CreateDynamicObject(2004,2538.1890000,-2294.1890000,14.7000000,0.0000000,0.0000000,90.0000000, .worldid = 1); //object(cr_safe_door) (1)
	CreateDynamicObject(1548,2539.2000000,-2263.6000000,14.1800000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(cj_drip_tray) (1)
	CreateDynamicObject(1551,2538.3000000,-2261.6000000,14.7000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(dyn_wine_big) (1)
	CreateDynamicObject(1551,2540.4000000,-2256.6000000,14.4000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(dyn_wine_big) (2)
	CreateDynamicObject(1551,2541.4000000,-2260.0000000,14.4000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(dyn_wine_big) (3)
	CreateDynamicObject(1668,2540.5000000,-2262.6000000,14.3000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(propvodkabotl1) (1)
	CreateDynamicObject(1667,2540.4000000,-2257.1000000,14.2920000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(propwineglass1) (1)
	CreateDynamicObject(1950,2538.3000000,-2256.9000000,14.7000000,0.0000000,0.0000000,6.0000000, .worldid = 1); //object(kb_beer) (1)
	CreateDynamicObject(1808,2667.0000000,-2273.9000000,12.6000000,0.0000000,0.0000000,270.0000000, .worldid = 1); //object(cj_watercooler2) (7)
	CreateDynamicObject(14832,2679.0000000,-2261.6000000,15.0000000,0.0000000,0.0000000,180.0000000, .worldid = 1); //object(lm_stripcorner) (2)
	CreateDynamicObject(1775,2669.4000000,-2254.1000000,13.6490000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(cj_sprunk1) (3)
	CreateDynamicObject(1776,2668.2000000,-2254.1000000,13.5920000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(cj_candyvendor) (1)
	CreateDynamicObject(1533,2674.3300000,-2280.3000000,0.1000000,0.0000000,0.0000000,270.0000000, .worldid = 1); //object(gen_doorext12) (1)
	CreateDynamicObject(1533,2674.3300000,-2278.8000000,0.1000000,0.0000000,0.0000000,269.9950000, .worldid = 1); //object(gen_doorext12) (2)
	CreateDynamicObject(1533,2545.8700000,-2296.7000000,0.1000000,0.0000000,0.0000000,90.0000000, .worldid = 1); //object(gen_doorext12) (3)
	CreateDynamicObject(1533,2545.8700000,-2295.2000000,0.1000000,0.0000000,0.0000000,90.0000000, .worldid = 1); //object(gen_doorext12) (4)
	CreateDynamicObject(1726,2539.7000000,-2283.8000000,13.1000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(mrk_seating2) (7)
	CreateDynamicObject(1726,2539.0000000,-2286.9000000,13.1000000,0.0000000,0.0000000,90.0000000, .worldid = 1); //object(mrk_seating2) (8)
	CreateDynamicObject(1726,2541.7000000,-2288.1000000,13.1000000,0.0000000,0.0000000,179.9950000, .worldid = 1); //object(mrk_seating2) (9)
	CreateDynamicObject(2370,2540.7000000,-2286.2000000,12.6000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(shop_set_1_table) (3)
	CreateDynamicObject(1536,2491.9000000,-2248.7000000,15.0000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(gen_doorext15) (1)
	CreateDynamicObject(2852,2541.0000000,-2285.8000000,13.4450000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(gb_bedmags02) (1)
	CreateDynamicObject(2869,2540.9000000,-2280.4000000,13.4200000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(gb_ornament04) (1)
	CreateDynamicObject(2868,2540.7000000,-2286.1000000,13.4100000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(gb_ornament03) (1)
	CreateDynamicObject(2868,2540.8000000,-2274.9000000,13.4230000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(gb_ornament03) (2)
	CreateDynamicObject(1775,2673.4000000,-2321.0000000,13.7000000,0.0000000,0.0000000,180.0000000, .worldid = 1); //object(cj_sprunk1) (4)
	CreateDynamicObject(956,2672.1000000,-2321.1000000,12.9200000,0.0000000,0.0000000,180.0000000, .worldid = 1); //object(cj_ext_candy) (2)
	CreateDynamicObject(8658,2668.6000000,-2318.7000000,13.6000000,0.0000000,0.0000000,180.0000000, .worldid = 1); //object(shabbyhouse11_lvs) (1)
	CreateDynamicObject(1749,2665.1000000,-2321.9000000,14.2000000,0.0000000,0.0000000,228.0000000, .worldid = 1); //object(med_tv_3) (1)
	CreateDynamicObject(1749,2665.1000000,-2321.9000000,13.7000000,0.0000000,0.0000000,227.9990000, .worldid = 1); //object(med_tv_3) (2)
	CreateDynamicObject(1749,2665.1000000,-2321.9000000,13.2000000,0.0000000,0.0000000,227.9990000, .worldid = 1); //object(med_tv_3) (3)
	CreateDynamicObject(1808,2667.8000000,-2321.4000000,12.5800000,0.0000000,0.0000000,180.0000000, .worldid = 1); //object(cj_watercooler2) (8)
	CreateDynamicObject(1809,2668.3000000,-2319.2000000,13.6000000,0.0000000,0.0000000,270.0000000, .worldid = 1); //object(med_hi_fi) (1)
	CreateDynamicObject(1809,2668.3000000,-2318.6000000,13.6000000,0.0000000,0.0000000,269.9950000, .worldid = 1); //object(med_hi_fi) (2)
	CreateDynamicObject(1840,2668.3000000,-2318.1000000,13.7000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(speaker_2) (1)
	CreateDynamicObject(1840,2668.3000000,-2319.8000000,13.7000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(speaker_2) (2)
	CreateDynamicObject(2186,2666.1000000,-2321.4000000,12.6000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(photocopier_1) (1)
	CreateDynamicObject(2192,2668.8780000,-2321.0100000,14.5900000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(fan_1) (1)
	CreateDynamicObject(1569,2674.2000000,-2304.4000000,12.6000000,0.0000000,0.0000000,90.0000000, .worldid = 1); //object(adam_v_door) (5)
	CreateDynamicObject(14782,2673.9000000,-2309.7000000,13.5900000,0.0000000,0.0000000,270.0000000, .worldid = 1); //object(int3int_boxing30) (1)
	CreateDynamicObject(1533,2674.2590000,-2314.9000000,12.5700000,0.0000000,0.0000000,270.0000000, .worldid = 1); //object(gen_doorext12) (1)
	CreateDynamicObject(964,2669.5000000,-2320.8000000,12.6000000,0.0000000,0.0000000,180.0000000, .worldid = 1); //object(cj_metal_crate) (1)
	CreateDynamicObject(964,2670.8000000,-2320.8000000,12.6000000,0.0000000,0.0000000,179.9950000, .worldid = 1); //object(cj_metal_crate) (2)
	CreateDynamicObject(3031,2668.2000000,-2309.6000000,14.1000000,0.0000000,0.0000000,119.7500000, .worldid = 1); //object(wong_dish) (1)
	CreateDynamicObject(8177,2620.5000000,-2296.3000000,-2.0000000,0.0000000,0.0000000,90.0000000, .worldid = 1); //object(vgs_concwall05) (1)
	CreateDynamicObject(8177,2600.5000000,-2280.5000000,-2.0000000,0.0000000,0.0000000,270.0000000, .worldid = 1); //object(vgs_concwall05) (1)
	CreateDynamicObject(8177,2576.9000000,-2272.0000000,-2.0000000,0.0000000,0.0000000,0.0000000, .worldid = 1); //object(vgs_concwall05) (1)

	//Dojo
	CreateDynamicObject(2755,2592.6000000,-1971.2000000,860.0000000,0.0000000,0.0000000,0.0000000); //object(dojo_wall) (1)
	CreateDynamicObject(14789,2590.8000000,-1978.2000000,862.5000000,0.0000000,0.0000000,0.0000000); //object(ab_sfgymmain1) (1)
	CreateDynamicObject(2632,2611.6000000,-1969.9000000,858.3000000,0.0000000,0.0000000,0.0000000); //object(gym_mat02) (1)
	CreateDynamicObject(2632,2611.6000000,-1971.8000000,858.3000000,0.0000000,0.0000000,0.0000000); //object(gym_mat02) (2)
	CreateDynamicObject(2632,2611.6000000,-1973.7000000,858.3000000,0.0000000,0.0000000,0.0000000); //object(gym_mat02) (3)
	CreateDynamicObject(2632,2607.7000000,-1969.9000000,858.3000000,0.0000000,0.0000000,0.0000000); //object(gym_mat02) (4)
	CreateDynamicObject(2632,2607.7000000,-1971.8000000,858.3000000,0.0000000,0.0000000,0.0000000); //object(gym_mat02) (5)
	CreateDynamicObject(2632,2607.7000000,-1973.7000000,858.3000000,0.0000000,0.0000000,0.0000000); //object(gym_mat02) (6)
	CreateDynamicObject(2632,2603.8000000,-1969.9000000,858.3000000,0.0000000,0.0000000,0.0000000); //object(gym_mat02) (7)
	CreateDynamicObject(2632,2603.8000000,-1971.8000000,858.3000000,0.0000000,0.0000000,0.0000000); //object(gym_mat02) (8)
	CreateDynamicObject(2632,2603.8000000,-1973.7000000,858.3000000,0.0000000,0.0000000,0.0000000); //object(gym_mat02) (9)
	CreateDynamicObject(2631,2611.6000000,-1978.2000000,858.3000000,0.0000000,0.0000000,0.0000000); //object(gym_mat1) (1)
	CreateDynamicObject(2631,2607.7000000,-1978.2000000,858.3000000,0.0000000,0.0000000,0.0000000); //object(gym_mat1) (2)
	CreateDynamicObject(2631,2603.8000000,-1978.2000000,858.3000000,0.0000000,0.0000000,0.0000000); //object(gym_mat1) (3)
	CreateDynamicObject(2631,2603.8000000,-1980.1000000,858.3000000,0.0000000,0.0000000,0.0000000); //object(gym_mat1) (4)
	CreateDynamicObject(2631,2603.8000000,-1982.0000000,858.3000000,0.0000000,0.0000000,0.0000000); //object(gym_mat1) (5)
	CreateDynamicObject(2631,2607.7000000,-1980.1000000,858.3000000,0.0000000,0.0000000,0.0000000); //object(gym_mat1) (6)
	CreateDynamicObject(2631,2607.7000000,-1982.0000000,858.3000000,0.0000000,0.0000000,0.0000000); //object(gym_mat1) (7)
	CreateDynamicObject(2631,2611.6000000,-1980.1000000,858.3000000,0.0000000,0.0000000,0.0000000); //object(gym_mat1) (8)
	CreateDynamicObject(2631,2611.6000000,-1982.0000000,858.3000000,0.0000000,0.0000000,0.0000000); //object(gym_mat1) (9)
	CreateDynamicObject(2632,2611.6000000,-1986.4000000,858.3000000,0.0000000,0.0000000,0.0000000); //object(gym_mat02) (11)
	CreateDynamicObject(2632,2607.7000000,-1986.4000000,858.3000000,0.0000000,0.0000000,0.0000000); //object(gym_mat02) (12)
	CreateDynamicObject(2632,2603.8000000,-1986.4000000,858.3000000,0.0000000,0.0000000,0.0000000); //object(gym_mat02) (13)
	CreateDynamicObject(2632,2611.6000000,-1988.3000000,858.3000000,0.0000000,0.0000000,0.0000000); //object(gym_mat02) (14)
	CreateDynamicObject(2632,2611.6000000,-1990.2000000,858.3000000,0.0000000,0.0000000,0.0000000); //object(gym_mat02) (15)
	CreateDynamicObject(2632,2607.7000000,-1988.3000000,858.3000000,0.0000000,0.0000000,0.0000000); //object(gym_mat02) (16)
	CreateDynamicObject(2632,2607.7000000,-1990.2000000,858.3000000,0.0000000,0.0000000,0.0000000); //object(gym_mat02) (17)
	CreateDynamicObject(2632,2603.8000000,-1988.3000000,858.3000000,0.0000000,0.0000000,0.0000000); //object(gym_mat02) (18)
	CreateDynamicObject(2632,2603.8000000,-1990.2000000,858.3000000,0.0000000,0.0000000,0.0000000); //object(gym_mat02) (19)
	CreateDynamicObject(2631,2611.6000000,-1994.4000000,858.3000000,0.0000000,0.0000000,0.0000000); //object(gym_mat1) (10)
	CreateDynamicObject(2631,2611.6000000,-1996.3000000,858.3000000,0.0000000,0.0000000,0.0000000); //object(gym_mat1) (11)
	CreateDynamicObject(2631,2611.6000000,-1998.2000000,858.3000000,0.0000000,0.0000000,0.0000000); //object(gym_mat1) (12)
	CreateDynamicObject(2631,2603.8000000,-1996.3000000,858.3000000,0.0000000,0.0000000,0.0000000); //object(gym_mat1) (13)
	CreateDynamicObject(2631,2607.7000000,-1996.3000000,858.3000000,0.0000000,0.0000000,0.0000000); //object(gym_mat1) (14)
	CreateDynamicObject(2631,2607.7000000,-1994.4000000,858.3000000,0.0000000,0.0000000,0.0000000); //object(gym_mat1) (15)
	CreateDynamicObject(2631,2603.8000000,-1994.4000000,858.3000000,0.0000000,0.0000000,0.0000000); //object(gym_mat1) (16)
	CreateDynamicObject(2631,2603.8000000,-1998.2000000,858.3000000,0.0000000,0.0000000,0.0000000); //object(gym_mat1) (17)
	CreateDynamicObject(2631,2607.7000000,-1998.2000000,858.3000000,0.0000000,0.0000000,0.0000000); //object(gym_mat1) (18)
	CreateDynamicObject(2755,2592.7000000,-1971.2000000,864.3000000,0.0000000,0.0000000,0.0000000); //object(dojo_wall) (2)
	CreateDynamicObject(3819,2593.2000000,-1998.1000000,859.3000000,0.0000000,0.0000000,179.9950000); //object(bleacher_sfsx) (1)
	CreateDynamicObject(3819,2593.2000000,-1986.9000000,859.3000000,0.0000000,0.0000000,179.9950000); //object(bleacher_sfsx) (2)
	CreateDynamicObject(3819,2593.1000000,-1976.3000000,863.6000000,0.0000000,0.0000000,179.9950000); //object(bleacher_sfsx) (3)
	CreateDynamicObject(8177,2591.4000000,-2019.7000000,852.6000000,0.0000000,90.0000000,0.0000000); //object(vgs_concwall05) (1)
	CreateDynamicObject(8177,2594.2560000,-2013.1000000,852.6000000,0.0000000,90.0000000,0.0000000); //object(vgs_concwall05) (2)
	CreateDynamicObject(3819,2593.1000000,-1998.1000000,863.6000000,0.0000000,0.0000000,179.9950000); //object(bleacher_sfsx) (1)
	CreateDynamicObject(3819,2593.1000000,-1986.8000000,863.6000000,0.0000000,0.0000000,179.9950000); //object(bleacher_sfsx) (1)
	CreateDynamicObject(984,2597.7000000,-1983.1000000,858.9000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (1)
	CreateDynamicObject(984,2595.6000000,-1983.1000000,863.2000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (2)
	CreateDynamicObject(984,2595.6000000,-1970.2000000,863.2000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (3)
	CreateDynamicObject(984,2597.7000000,-1996.0000000,858.9000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (4)
	CreateDynamicObject(984,2597.7000000,-1970.3000000,858.9000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (5)
	CreateDynamicObject(3819,2593.2000000,-1976.2000000,859.3000000,0.0000000,0.0000000,179.9950000); //object(bleacher_sfsx) (2)
	CreateDynamicObject(984,2595.6000000,-1995.9000000,863.2000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (6)
	CreateDynamicObject(1775,2590.1000000,-1994.2000000,859.3700000,0.0000000,0.0000000,180.0000000); //object(cj_sprunk1) (1)
	CreateDynamicObject(1776,2590.2000000,-1990.1000000,859.3700000,0.0000000,0.0000000,0.0000000); //object(cj_candyvendor) (1)
	CreateDynamicObject(1569,2591.0000000,-1967.8000000,862.5500000,0.0000000,0.0000000,0.0000000); //object(adam_v_door) (1)
	CreateDynamicObject(1569,2594.0000000,-1967.8000000,862.5500000,0.0000000,0.0000000,180.0000000); //object(adam_v_door) (2)
	CreateDynamicObject(1569,2589.5000000,-1993.0000000,858.2500000,0.0000000,0.0000000,90.0000000); //object(adam_v_door) (3)
	CreateDynamicObject(1980,2590.3000000,-1977.3000000,861.0000000,0.0000000,0.0000000,0.0000000); //object(wilshire7dr1_law) (1)
	CreateDynamicObject(1980,2590.3000000,-1992.0000000,862.7000000,0.0000000,0.0000000,0.0000000); //object(wilshire7dr1_law) (2)
	CreateDynamicObject(1533,2611.2100000,-2002.5500000,858.2350000,0.0000000,0.0000000,181.2500000); //object(gen_doorext12) (1)
	CreateDynamicObject(1569,2590.8000000,-1993.1000000,862.6000000,0.0000000,0.0000000,90.0000000); //object(adam_v_door) (4)
	CreateDynamicObject(14401,2616.7000000,-1982.4000000,858.7000000,0.0000000,0.0000000,0.0000000); //object(bench1) (1)
	CreateDynamicObject(14401,2616.7000000,-1990.3000000,858.7000000,0.0000000,0.0000000,0.0000000); //object(bench1) (2)
	CreateDynamicObject(14401,2616.7000000,-1998.5000000,858.7000000,0.0000000,0.0000000,0.0000000); //object(bench1) (3)
	CreateDynamicObject(14401,2616.9000000,-2006.8000000,858.6000000,0.0000000,0.0000000,0.0000000); //object(bench1) (4)
	CreateDynamicObject(14401,2616.9000000,-2014.4000000,858.6000000,0.0000000,0.0000000,0.0000000); //object(bench1) (5)
	return 1;
}
