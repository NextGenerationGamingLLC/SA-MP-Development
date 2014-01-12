/*
    	 		 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
				| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
				| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
				| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
				| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
				| $$\  $$$| $$  \ $$        | $$  \ $$| $$
				| $$ \  $$|  $$$$$$/        | $$  | $$| $$
				|__/  \__/ \______/         |__/  |__/|__/

//--------------------------------[SURFING-NGRP.PWN]--------------------------------

							Next Generation Gaming, LLC
				(created by Next Generation Gaming Development Team)

				Combined:			
				(***) Akatony

		Credits to alternate sources (Correlli for the method, Zeex for ZCMD, etc)
		
 *
 * Copyright (c) 2013, Next Generation Gaming, LLC
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
 
 
 	Note: The Z Coordinate when creating a surfboard is always 0.1 & the rotations should be the following rx = 270.0, ry = 0.0, rz = 180.0
 
 */

 
// ------------------------- [Includes] ---------------------------
#include 	<a_samp>
#include    <zcmd>
#include    <streamer>
#include 	<YSInew\y_timers>
// ------------------------- [Defines] ---------------------------- 
#undef 		MAX_PLAYERS
#define 	MAX_PLAYERS 			500
#define 	MAX_EVENT_PLAYERS		15
#define 	MAX_PLAYER_SURFBOARD	100+MAX_EVENT_PLAYERS // Limited for now
#define		MAX_SURFBOARD_SPEED		30.0
#define 	INVALID_SURFBOARD_ID	-1
#define		COLOR_NAVY				0x0066CCFF
#define 	COLOR_GREEN				0x4FBF30FF
// ------------------------ [Enumeration] -------------------------- 
enum pSurfboard
{
	ID,
	modelID,
	objectID,
	Float: Speed,
	Float: Pos[6],
	Float: UpdatePos[3]
}
// ------------------------- [Variables] ---------------------------
new PlayerSurfboardCount;
new PlayerSurfboardInfo[MAX_PLAYERS][MAX_PLAYER_SURFBOARD][pSurfboard];
new beachparty;
new CurrentCheckPoint[MAX_PLAYERS] = 0;	
new Winners = 0;
new SurfingRaceStarted = 0;
new PlayersInEvent = 0;
// --------------------------- [Array] -----------------------------
new Float:CheckPoints[16][3] = {
    {538.6651,-1967.6935,1.0852},
    {512.1157,-2064.6506,1.0852},
    {646.3782,-2180.7458,1.0852},
    {826.0433,-2299.3477,1.0852},
    {804.0825,-2435.4219,1.0852},
    {592.2265,-2447.6296,1.0852},
    {441.0269,-2362.0586,1.0852},
    {223.8521,-2328.8127,1.0852},
    {73.9931,-2183.2849,1.0852},
    {5.5737,-1988.4398,1.0852},
    {80.8997,-1719.5684,1.0852},
    {-117.1616,-1694.8350,1.0852},
    {-143.4838,-1992.4514,1.0852},
    {75.0184,-2094.4722,1.0852},
    {371.4926,-2046.6212,1.0852},
    {541.0415,-1924.4780,-0.5766}
};
// ---------------------- [SA:MP Callbacks] ------------------------
public OnFilterScriptInit()
{
	print("Initiating Surfing-NGRP, please wait...");
	LoadScript();
	return 1;
}

public OnFilterScriptExit()
{
	printf("Shutting Down Surfing-NGRP...");
	UnLoadScript();
	return 1;
}

public OnPlayerConnect(playerid)
{
	for(new sbid = 0; sbid < MAX_PLAYER_SURFBOARD; sbid++)
	{
		PlayerSurfboardInfo[playerid][sbid][ID] = INVALID_SURFBOARD_ID;
		PlayerSurfboardInfo[playerid][sbid][modelID] = 0;
		PlayerSurfboardInfo[playerid][sbid][objectID] = 0;
		PlayerSurfboardInfo[playerid][sbid][Speed] = 0.0;
		PlayerSurfboardInfo[playerid][sbid][Pos][0] = 0.0;
		PlayerSurfboardInfo[playerid][sbid][Pos][1] = 0.0;
		PlayerSurfboardInfo[playerid][sbid][Pos][2] = 0.0;
		PlayerSurfboardInfo[playerid][sbid][Pos][3] = 0.0;
		PlayerSurfboardInfo[playerid][sbid][Pos][4] = 0.0;
		PlayerSurfboardInfo[playerid][sbid][Pos][5] = 0.0;
		PlayerSurfboardInfo[playerid][sbid][UpdatePos][0] = 0.0;
		PlayerSurfboardInfo[playerid][sbid][UpdatePos][1] = 0.0;
		PlayerSurfboardInfo[playerid][sbid][UpdatePos][2] = 0.0;
		
		CurrentCheckPoint[playerid] = 0;
	}
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	if(GetPVarInt(playerid, "PlayerSurfing") == 1)
	{
		PlayerSurfboardCount--;
		DestroyPlayerSurfboard(playerid);
	}	
	if(GetPVarInt(playerid, "PlayerSurfing") == 2)
	{
		DestroyEventSurfboard(playerid);
	}	
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	if(GetPVarInt(playerid, "PlayerSurfing") == 1)
	{
		PlayerSurfboardCount--;
		DestroyPlayerSurfboard(playerid);
	}	
	if(GetPVarInt(playerid, "PlayerSurfing") == 2)
	{
		DestroyEventSurfboard(playerid);
	}	
	return 1;
}

public OnPlayerEnterDynamicArea(playerid, areaid)
{
	if(areaid == beachparty)
	{
		if(GetPVarInt(playerid, "PlayerSurfing") == 0) 
		{
			if(IsPlayerInAnyVehicle(playerid))
			{
				new carid = GetPlayerVehicleID(playerid);
				if(IsAPlane(carid))
				{
					SendClientMessage(playerid, 0x1DD1DEFF, "The Santa Marina Beach Area is currently restricted from any air traffic due to the 4th of July Events.");
					SendClientMessage(playerid, 0x1DD1DEFF, "We have teleported you over blueberry, make sure to keep enough speed to not stall and fall to the ground.");
					SetVehiclePos(carid, 0, 0, 1000.0);
					//SetPlayerPos(playerid, 0, 0, 1000.0);
				}
			}
		}	
	}	
	return 1;
}

public OnPlayerUpdate(playerid)
{
	if(GetPVarInt(playerid, "PlayerSurfing") != 0) 
	{
		new sID = INVALID_SURFBOARD_ID;
		for(new i = 0; i < MAX_PLAYER_SURFBOARD; i++)
		{
			if(PlayerSurfboardInfo[playerid][i][ID] != INVALID_SURFBOARD_ID)
			{
				sID = PlayerSurfboardInfo[playerid][i][ID];
				break;
			}
		}	
		
		if(sID != INVALID_SURFBOARD_ID)
		{
			if(GetPVarInt(playerid, "WaitingOnEvent") == 0)
			{
		
				new keys[3], Float: floatVal[4];
				GetPlayerPos(playerid, floatVal[0], floatVal[1], floatVal[2]);
				floatVal[3] = PlayerSurfboardInfo[playerid][sID][Speed];
				GetPlayerKeys(playerid, keys[0], keys[1], keys[2]);
				GetXYInFrontOfPlayerOnSB(playerid, floatVal[0], floatVal[1], 50.0);
				PlayerSurfboardInfo[playerid][sID][UpdatePos][0] = floatVal[0];
				PlayerSurfboardInfo[playerid][sID][UpdatePos][1] = floatVal[1];
				PlayerSurfboardInfo[playerid][sID][UpdatePos][2] = PlayerSurfboardInfo[playerid][sID][Pos][2];
				
				if(keys[1] == KEY_UP)
				{
					if(floatVal[3] >= 0.0 && floatVal[3] < MAX_SURFBOARD_SPEED) PlayerSurfboardInfo[playerid][sID][Speed] += 0.10;
					if(floatVal[3] >= MAX_SURFBOARD_SPEED) PlayerSurfboardInfo[playerid][sID][Speed] = MAX_SURFBOARD_SPEED;
				}
				else if(keys[1] == KEY_DOWN)
				{
					if(floatVal[3] >= 0.0 && floatVal[3] < MAX_SURFBOARD_SPEED) PlayerSurfboardInfo[playerid][sID][Speed] -= 0.10;
					if(floatVal[3] >= MAX_SURFBOARD_SPEED) PlayerSurfboardInfo[playerid][sID][Speed] = MAX_SURFBOARD_SPEED;
				}
				if(keys[2] == KEY_LEFT)
				{				
					PlayerSurfboardInfo[playerid][sID][Speed] -= 0.01;
					PlayerSurfboardInfo[playerid][sID][Pos][5] += 1.5;
					SetObjectRot(PlayerSurfboardInfo[playerid][sID][objectID], PlayerSurfboardInfo[playerid][sID][Pos][3], PlayerSurfboardInfo[playerid][sID][Pos][4], PlayerSurfboardInfo[playerid][sID][Pos][5]);
					SetPlayerFacingAngle(playerid, PlayerSurfboardInfo[playerid][sID][Pos][5] + 270.0);
					PlayerSurfboardInfo[playerid][sID][UpdatePos][0] = floatVal[0];
					PlayerSurfboardInfo[playerid][sID][UpdatePos][1] = floatVal[1];
					PlayerSurfboardInfo[playerid][sID][UpdatePos][2] = PlayerSurfboardInfo[playerid][sID][Pos][2]; 
				}
				else if(keys[2] == KEY_RIGHT)
				{
					PlayerSurfboardInfo[playerid][sID][Speed] -= 0.01;
					PlayerSurfboardInfo[playerid][sID][Pos][5] -= 1.5;
					SetObjectRot(PlayerSurfboardInfo[playerid][sID][objectID], PlayerSurfboardInfo[playerid][sID][Pos][3], PlayerSurfboardInfo[playerid][sID][Pos][4], PlayerSurfboardInfo[playerid][sID][Pos][5]);
					SetPlayerFacingAngle(playerid, PlayerSurfboardInfo[playerid][sID][Pos][5] + 270.0);
					PlayerSurfboardInfo[playerid][sID][UpdatePos][0] = floatVal[0];
					PlayerSurfboardInfo[playerid][sID][UpdatePos][1] = floatVal[1];
					PlayerSurfboardInfo[playerid][sID][UpdatePos][2] = PlayerSurfboardInfo[playerid][sID][Pos][2]; 
				}
				if(PlayerSurfboardInfo[playerid][sID][Speed] > 0.010)
				{
					PlayerSurfboardInfo[playerid][sID][Speed] -= 0.010;
					MoveObject(PlayerSurfboardInfo[playerid][sID][objectID], PlayerSurfboardInfo[playerid][sID][UpdatePos][0], PlayerSurfboardInfo[playerid][sID][UpdatePos][1], PlayerSurfboardInfo[playerid][sID][UpdatePos][2], PlayerSurfboardInfo[playerid][sID][Speed]);
				}
				else StopPlayerSurfboard(playerid, sID);
			}	
		}	
	}	
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	new string[128];
    DisablePlayerRaceCheckpoint(playerid);
    CurrentCheckPoint[playerid]++;

	if(CurrentCheckPoint[playerid] == 14)
    {
        GameTextForPlayer(playerid, "Final Checkpoint", 2000, 4);
		SendClientMessage(playerid, 0xF73811FF, "Final Checkpoint");
        SetPlayerRaceCheckpoint(playerid, 1, CheckPoints[CurrentCheckPoint[playerid]][0], CheckPoints[CurrentCheckPoint[playerid]][1], CheckPoints[CurrentCheckPoint[playerid]][2], CheckPoints[CurrentCheckPoint[playerid]+1][0], CheckPoints[CurrentCheckPoint[playerid]+1][1], CheckPoints[CurrentCheckPoint[playerid]+1][2], 15);
	}
	else if(CurrentCheckPoint[playerid] == 15)
	{
	    Winners++;
	    if(Winners == 1)
	    {
	        for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if(GetPVarInt(i, "PlayerSurfing") == 2)
				{
				    format(string, sizeof(string), "[Surfing Event] First Place: %s", GetPlayerNameEx(playerid));
					SendClientMessage(i, COLOR_NAVY, string);
        		}
        	}
			DestroyEventSurfboard(playerid);
        }
        else if(Winners == 2)
	    {
	        for(new i = 0; i < MAX_PLAYERS; i++)
	    	{
				if(GetPVarInt(i, "PlayerSurfing") == 2)
				{
				    format(string, sizeof(string), "[Surfing Event] Second Place: %s", GetPlayerNameEx(playerid));
					SendClientMessage(i, COLOR_NAVY, string);
        		}
        	}
			DestroyEventSurfboard(playerid);
        }
        else if(Winners == 3)
	    {
	        for(new i = 0; i < MAX_PLAYERS; i++)
	    	{
				if(GetPVarInt(i, "PlayerSurfing") == 2)
				{
				    format(string, sizeof(string), "[Surfing Event] Third Place: %s", GetPlayerNameEx(playerid));
					SendClientMessage(i, COLOR_NAVY, string);
        		}
        	}
			DestroyEventSurfboard(playerid);
        }
        else
	    {
			SendClientMessage(playerid, COLOR_NAVY, "You've finished the race, unfortunately you didn't finish in 1st, 2nd or 3d Position.");
	        GameTextForPlayer(playerid, "You've finished the race", 2000, 1);
			DestroyEventSurfboard(playerid);
        }
    }
	else if(CurrentCheckPoint[playerid] < 14)
    {
        format(string, sizeof(string), "Checkpoint %d", CurrentCheckPoint[playerid]);
		SendClientMessage(playerid, 0xF73811FF, string);
        SetPlayerRaceCheckpoint(playerid, 0, CheckPoints[CurrentCheckPoint[playerid]][0], CheckPoints[CurrentCheckPoint[playerid]][1], CheckPoints[CurrentCheckPoint[playerid]][2], CheckPoints[CurrentCheckPoint[playerid]+1][0], CheckPoints[CurrentCheckPoint[playerid]+1][1], CheckPoints[CurrentCheckPoint[playerid]+1][2], 15);
	}
	return 1;
}
// ---------------------- [Public Functions] ------------------------
forward LoadScript();
public LoadScript()
{
	PlayerSurfboardCount = 0;
	SurfingRaceStarted = 0;
	Winners = 0;
	PlayersInEvent = 0;
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		for(new sbid = 0; sbid < MAX_PLAYER_SURFBOARD; sbid++)
		{
			PlayerSurfboardInfo[i][sbid][ID] = INVALID_SURFBOARD_ID;
			PlayerSurfboardInfo[i][sbid][modelID] = 0;
			PlayerSurfboardInfo[i][sbid][objectID] = 0;
			PlayerSurfboardInfo[i][sbid][Speed] = 0.0;
			PlayerSurfboardInfo[i][sbid][Pos][0] = 0.0;
			PlayerSurfboardInfo[i][sbid][Pos][1] = 0.0;
			PlayerSurfboardInfo[i][sbid][Pos][2] = 0.0;
			PlayerSurfboardInfo[i][sbid][Pos][3] = 0.0;
			PlayerSurfboardInfo[i][sbid][Pos][4] = 0.0;
			PlayerSurfboardInfo[i][sbid][Pos][5] = 0.0;
			PlayerSurfboardInfo[i][sbid][UpdatePos][0] = 0.0;
			PlayerSurfboardInfo[i][sbid][UpdatePos][1] = 0.0;
			PlayerSurfboardInfo[i][sbid][UpdatePos][2] = 0.0;
			
			CurrentCheckPoint[i] = 0;
			
			SetPlayerMapIcon(i, 99, 243.6033, -1911.3003, -0.5853, 38, 0, MAPICON_LOCAL);
		}	
	}	
	
	beachparty = CreateDynamicSphere(232.2341, -1839.0952, 3.5475, 150.0, 0, 0);
	CreateDynamic3DTextLabel("Freeroam Surfing \nType /surf to start freeroam surfing", 0xEDE90CFF,243.6033,-1911.3003,-0.5853+0.6,90.0);
	CreateDynamic3DTextLabel("Surfing Event \nType /surf to join the event", 0xEDE90CFF,324.7307,-1912.4688,-0.4616+0.6,20.0);
	CreateDynamicObject(10401,330.5000000,-1909.0000000,2.1000000,0.0000000,0.0000000,312.0000000); //object(hc_shed02_sfs) (1)
	CreateDynamicObject(3430,333.7000100,-1888.5999800,2.1000000,0.0000000,0.0000000,354.0000000); //object(vegasbooth01) (2)
	CreateDynamicObject(3430,317.8999900,-1888.0999800,2.1000000,0.0000000,0.0000000,355.9960000); //object(vegasbooth01) (3)
	CreateDynamicObject(970,333.1000100,-1901.4000200,0.4000000,0.0000000,0.0000000,268.0000000); //object(fencesmallb) (12)
	CreateDynamicObject(970,333.0012200,-1903.8199500,-1.2000000,0.0000000,270.0000000,268.0000000); //object(fencesmallb) (13)
	CreateDynamicObject(970,333.6000100,-1892.0999800,1.2000000,0.0000000,0.0000000,268.0000000); //object(fencesmallb) (14)
	CreateDynamicObject(970,333.4599900,-1896.2004400,1.0000000,0.0000000,0.0000000,267.9950000); //object(fencesmallb) (15)
	CreateDynamicObject(970,333.3687700,-1898.6999500,-0.5000000,0.0000000,90.0000000,267.9950000); //object(fencesmallb) (16)
	CreateDynamicObject(970,317.2000100,-1902.9000200,-1.2000000,0.0000000,270.0000000,267.9950000); //object(fencesmallb) (17)
	CreateDynamicObject(970,317.2500000,-1900.5000000,0.3500000,0.0000000,0.0000000,268.0000000); //object(fencesmallb) (18)
	CreateDynamicObject(970,317.6000100,-1898.0999800,-0.5000000,0.0000000,90.0000000,267.9950000); //object(fencesmallb) (19)
	CreateDynamicObject(970,317.6200000,-1895.5200200,1.0000000,0.0000000,0.0000000,267.9950000); //object(fencesmallb) (20)
	CreateDynamicObject(970,317.7500000,-1891.4000200,1.2000000,0.0000000,0.0000000,267.9950000); //object(fencesmallb) (21)
	CreateDynamicObject(3406,318.0000000,-1907.8000500,-1.8000000,0.0000000,0.0000000,266.0000000); //object(cxref_woodjetty) (1)
	CreateDynamicObject(3406,317.3800000,-1916.5200200,-1.8000000,0.0000000,0.0000000,265.9950000); //object(cxref_woodjetty) (2)
	CreateDynamicObject(3406,331.3999900,-1917.3000500,-1.8000000,0.0000000,0.0000000,265.9950000); //object(cxref_woodjetty) (3)
	CreateDynamicObject(3406,332.0200200,-1908.5400400,-1.8000000,0.0000000,0.0000000,266.0000000); //object(cxref_woodjetty) (4)
	CreateDynamicObject(3406,334.9700000,-1922.4499500,-1.8000000,0.0000000,0.0000000,355.9950000); //object(cxref_woodjetty) (5)
	CreateDynamicObject(3406,314.2000100,-1921.0000000,-1.8000000,0.0000000,0.0000000,355.9900000); //object(cxref_woodjetty) (6)
	CreateDynamicObject(1461,318.2000100,-1892.9000200,1.5000000,0.0000000,0.0000000,88.0000000); //object(dyn_life_p) (1)
	CreateDynamicObject(1461,333.2000100,-1894.0000000,1.5000000,0.0000000,0.0000000,270.0000000); //object(dyn_life_p) (2)
	CreateDynamicObject(1295,316.7000100,-1894.0000000,5.9000000,0.0000000,0.0000000,0.0000000); //object(doublestreetlght1) (1)
	CreateDynamicObject(1295,334.8999900,-1895.0000000,5.9000000,0.0000000,0.0000000,178.0000000); //object(doublestreetlght1) (2)
	CreateDynamicObject(6299,306.0000000,-1880.4000200,3.6000000,0.0000000,0.0000000,40.0000000); //object(pier03c_law2) (1)
	CreateDynamicObject(3276,311.7999900,-1878.0000000,2.0000000,0.0000000,0.0000000,308.0000000); //object(cxreffencesld) (1)
	CreateDynamicObject(864,316.7000100,-1883.0000000,1.1000000,0.0000000,0.0000000,0.0000000); //object(sand_combush1) (1)
	CreateDynamicObject(864,315.1000100,-1881.4000200,1.2000000,0.0000000,0.0000000,0.0000000); //object(sand_combush1) (2)
	CreateDynamicObject(864,314.7000100,-1886.1999500,1.2000000,0.0000000,0.0000000,0.0000000); //object(sand_combush1) (3)
	CreateDynamicObject(864,309.8999900,-1882.5000000,1.2000000,0.0000000,0.0000000,0.0000000); //object(sand_combush1) (4)
	CreateDynamicObject(3276,315.5000000,-1883.0999800,1.8000000,0.0000000,0.0000000,307.9960000); //object(cxreffencesld) (2)
	CreateDynamicObject(1535,296.0999500,-1880.1999500,1.2000000,0.0000000,0.0000000,310.0000000); //object(gen_doorext14) (1)
	CreateDynamicObject(1295,305.2000100,-1867.8000500,5.9000000,0.0000000,0.0000000,320.0000000); //object(doublestreetlght1) (1)
	CreateDynamicObject(1295,280.6000100,-1865.8000500,5.9000000,0.0000000,0.0000000,319.9990000); //object(doublestreetlght1) (1)
	CreateDynamicObject(1295,239.8000000,-1864.3000500,5.9000000,0.0000000,0.0000000,319.9990000); //object(doublestreetlght1) (1)
	CreateDynamicObject(1295,191.3000000,-1866.4000200,5.9000000,0.0000000,0.0000000,319.9990000); //object(doublestreetlght1) (1)
	CreateDynamicObject(1946,320.7999900,-1870.9000200,2.1000000,0.0000000,0.0000000,0.0000000); //object(baskt_ball_hi) (1)
	CreateDynamicObject(1598,313.5000000,-1870.3000500,2.1000000,0.0000000,0.0000000,0.0000000); //object(beachball) (1)
	CreateDynamicObject(1598,330.0000000,-1868.6999500,2.1000000,0.0000000,0.0000000,0.0000000); //object(beachball) (2)
	CreateDynamicObject(1598,324.7000100,-1915.5999800,0.1000000,0.0000000,0.0000000,0.0000000); //object(beachball) (3)
	CreateDynamicObject(1295,350.2999900,-1893.0000000,5.9000000,0.0000000,0.0000000,163.9990000); //object(doublestreetlght1) (1)
	CreateDynamicObject(997,329.7000100,-1899.0999800,0.4000000,0.0000000,0.0000000,358.0000000); //object(lhouse_barrier3) (1)
	CreateDynamicObject(997,324.2000100,-1898.9000200,0.4000000,0.0000000,0.0000000,357.9950000); //object(lhouse_barrier3) (2)
	CreateDynamicObject(997,319.2000100,-1898.8000500,0.4000000,0.0000000,0.0000000,357.9950000); //object(lhouse_barrier3) (3)
	// Barrells for checkpoints
	CreateDynamicObject(1237,538.6651,-1967.6935,1.0852,0.00000000,0.00000000,0.00000000);
	CreateDynamicObject(1237,512.1157,-2064.6506,1.0852,0.00000000,0.00000000,0.00000000);
	CreateDynamicObject(1237,646.3782,-2180.7458,1.0852,0.00000000,0.00000000,0.00000000);
	CreateDynamicObject(1237,826.0433,-2299.3477,1.0852,0.00000000,0.00000000,0.00000000);
	CreateDynamicObject(1237,804.0825,-2435.4219,1.0852,0.00000000,0.00000000,0.00000000);
	CreateDynamicObject(1237,592.2265,-2447.6296,1.0852,0.00000000,0.00000000,0.00000000);
	CreateDynamicObject(1237,441.0269,-2362.0586,1.0852,0.00000000,0.00000000,0.00000000);
	CreateDynamicObject(1237,223.8521,-2328.8127,1.0852,0.00000000,0.00000000,0.00000000);
	CreateDynamicObject(1237,73.9931,-2183.2849,1.0852,0.00000000,0.00000000,0.00000000);
	CreateDynamicObject(1237,5.5737,-1988.4398,1.0852,0.00000000,0.00000000,0.00000000);
	CreateDynamicObject(1237,80.8997,-1719.5684,1.0852,0.00000000,0.00000000,0.00000000);
	CreateDynamicObject(1237,-117.1616,-1694.8350,1.0852,0.00000000,0.00000000,0.00000000);
	CreateDynamicObject(1237,-143.4838,-1992.4514,1.0852,0.00000000,0.00000000,0.00000000);
	CreateDynamicObject(1237,75.0184,-2094.4722,1.0852,0.00000000,0.00000000,0.00000000);
	CreateDynamicObject(1237,-143.4838,-1992.4514,1.0852,0.00000000,0.00000000,0.00000000);
	CreateDynamicObject(1237,371.4926,-2046.6212,1.0852,0.00000000,0.00000000,0.00000000);	
	// Flares for checkpoints
	CreateDynamicObject(354,538.6651,-1967.6935,1.0852,0.00000000,0.00000000,0.00000000);
	CreateDynamicObject(354,512.1157,-2064.6506,1.0852,0.00000000,0.00000000,0.00000000);
	CreateDynamicObject(354,646.3782,-2180.7458,1.0852,0.00000000,0.00000000,0.00000000);
	CreateDynamicObject(354,826.0433,-2299.3477,1.0852,0.00000000,0.00000000,0.00000000);
	CreateDynamicObject(354,804.0825,-2435.4219,1.0852,0.00000000,0.00000000,0.00000000);
	CreateDynamicObject(354,592.2265,-2447.6296,1.0852,0.00000000,0.00000000,0.00000000);
	CreateDynamicObject(354,441.0269,-2362.0586,1.0852,0.00000000,0.00000000,0.00000000);
	CreateDynamicObject(354,223.8521,-2328.8127,1.0852,0.00000000,0.00000000,0.00000000);
	CreateDynamicObject(354,73.9931,-2183.2849,1.0852,0.00000000,0.00000000,0.00000000);
	CreateDynamicObject(354,5.5737,-1988.4398,1.0852,0.00000000,0.00000000,0.00000000);
	CreateDynamicObject(354,80.8997,-1719.5684,1.0852,0.00000000,0.00000000,0.00000000);
	CreateDynamicObject(354,-117.1616,-1694.8350,1.0852,0.00000000,0.00000000,0.00000000);
	CreateDynamicObject(354,-143.4838,-1992.4514,1.0852,0.00000000,0.00000000,0.00000000);
	CreateDynamicObject(354,75.0184,-2094.4722,1.0852,0.00000000,0.00000000,0.00000000);
	CreateDynamicObject(354,-143.4838,-1992.4514,1.0852,0.00000000,0.00000000,0.00000000);
	CreateDynamicObject(354,371.4926,-2046.6212,1.0852,0.00000000,0.00000000,0.00000000);
	
	print("Successfully loaded Surfing-NGRP.");
	return 1;
}	

forward UnLoadScript();
public UnLoadScript()
{
	PlayerSurfboardCount = 0;
	SurfingRaceStarted = 0;
	Winners = 0;
	PlayersInEvent = 0;
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(GetPVarInt(i, "PlayerSurfing") == 1) { DestroyPlayerSurfboard(i); }
		if(GetPVarInt(i, "PlayerSurfing") == 2) { DestroyEventSurfboard(i); }
	}	
	print("Successfully unloaded Surfing-NGRP.");
	return 1;
}	

forward SurfCountdown(playerid);
public SurfCountdown(playerid)
{
	if(GetPVarInt(playerid, "countdownevent") == 1)
	{
	    SendClientMessage(playerid, 0xF73811FF, "[Surfing Event] 3");
	    SetPVarInt(playerid, "countdownevent", 2);
	    SetTimerEx("SurfCountdown", 1000, false, "i", playerid);
	}
	else if(GetPVarInt(playerid, "countdownevent") == 2)
	{
	    SendClientMessage(playerid, 0xF73811FF, "[Surfing Event] 2");
	    SetPVarInt(playerid, "countdownevent", 3);
	    SetTimerEx("SurfCountdown", 1000, false, "i", playerid);
	}
	else if(GetPVarInt(playerid, "countdownevent") == 3)
	{
	    SendClientMessage(playerid, 0xF73811FF, "[Surfing Event] 1");
	    SetPVarInt(playerid, "countdownevent", 4);
	    SetTimerEx("SurfCountdown", 1000, false, "i", playerid);
	}
	else if(GetPVarInt(playerid, "countdownevent") == 4)
	{
	    SendClientMessage(playerid, 0xF73811FF, "[Surfing Event] Go Go Go");
	    CurrentCheckPoint[playerid] = 0;
	    StartSurfRace(playerid);
	}
	return 1;
}

forward StartSurfRace(playerid);
public StartSurfRace(playerid)
{
	Winners = 0;
	SurfingRaceStarted = 1;
	SetPVarInt(playerid, "PlayerSurfing", 2);
	DeletePVar(playerid, "EventStage");
	DeletePVar(playerid, "WaitingOnEvent");
	SetPVarInt(playerid, "countdownevent", 0);
 	SetPlayerRaceCheckpoint(playerid, 0, CheckPoints[CurrentCheckPoint[playerid]][0], CheckPoints[CurrentCheckPoint[playerid]][1], CheckPoints[CurrentCheckPoint[playerid]][2], CheckPoints[CurrentCheckPoint[playerid]+1][0], CheckPoints[CurrentCheckPoint[playerid]+1][1], CheckPoints[CurrentCheckPoint[playerid]+1][2], 15);
	return 1;
}
// ---------------------- [Stock Functions] ------------------------
stock CreatePlayerSurfboard(playerid, modelid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz = 0.0)
{
	new nextid = GetFreePlayerSurfboard(), Float: objPos[3];
	if(nextid == 100) return SendClientMessage(playerid, COLOR_NAVY, "Sorry, we cannot spawn a surfboard at the moment as we have reached the limit of current player surfboards.");
	if(PlayerSurfboardCount == 100) return SendClientMessage(playerid, COLOR_NAVY, "Sorry, we cannot spawn a surfboard at the moment as we have reached the limit of current player surfboards.");	
	
	PlayerSurfboardInfo[playerid][nextid][ID] = nextid;
	PlayerSurfboardInfo[playerid][nextid][modelID] = 2043 + modelid; // Reminder: Valid model id: 1, 2 & 3
	PlayerSurfboardInfo[playerid][nextid][Speed] = 0.0;
	PlayerSurfboardInfo[playerid][nextid][Pos][0] = x;
	PlayerSurfboardInfo[playerid][nextid][Pos][1] = y;
	PlayerSurfboardInfo[playerid][nextid][Pos][2] = z;
	PlayerSurfboardInfo[playerid][nextid][Pos][3] = rx;
	PlayerSurfboardInfo[playerid][nextid][Pos][4] = ry;
	PlayerSurfboardInfo[playerid][nextid][Pos][5] = rz;
	PlayerSurfboardInfo[playerid][nextid][objectID] = CreateObject(2403 + modelid, x, y, z, rx, ry, rz);
	PlayerSurfboardCount++;
	SetPVarInt(playerid, "PlayerSurfing", 1);
	GetObjectPos(PlayerSurfboardInfo[playerid][nextid][objectID], objPos[0], objPos[1], objPos[2]);
	SetPlayerPos(playerid, objPos[0], objPos[1], objPos[2]+2);
	SetPlayerFacingAngle(playerid, PlayerSurfboardInfo[playerid][nextid][Pos][5] + 270.0);
	ApplyAnimation(playerid, "BSKTBALL", "BBALL_def_loop", 4.0, 1, 0, 0, 0, 0);
	
	//printf("Successfully created %d surfboard.", playerid);
	return nextid;
}	

stock CreateEventSurfboard(playerid, modelid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz = 0.0)
{
	new nextid = GetFreePlayerSurfboard(), Float: objPos[3];
	if(nextid == MAX_PLAYER_SURFBOARD) return SendClientMessage(playerid, COLOR_NAVY, "Sorry, we cannot spawn a surfboard at the moment as we have reached the limit of current player surfboards.");
	if(PlayerSurfboardCount == MAX_PLAYER_SURFBOARD) return SendClientMessage(playerid, COLOR_NAVY, "Sorry, we cannot spawn a surfboard at the moment as we have reached the limit of current player surfboards.");	
	
	PlayerSurfboardInfo[playerid][nextid][ID] = nextid;
	PlayerSurfboardInfo[playerid][nextid][modelID] = 2043 + modelid; // Reminder: Valid model id: 1, 2 & 3
	PlayerSurfboardInfo[playerid][nextid][Speed] = 0.0;
	PlayerSurfboardInfo[playerid][nextid][Pos][0] = x;
	PlayerSurfboardInfo[playerid][nextid][Pos][1] = y;
	PlayerSurfboardInfo[playerid][nextid][Pos][2] = z;
	PlayerSurfboardInfo[playerid][nextid][Pos][3] = rx;
	PlayerSurfboardInfo[playerid][nextid][Pos][4] = ry;
	PlayerSurfboardInfo[playerid][nextid][Pos][5] = rz;
	PlayerSurfboardInfo[playerid][nextid][objectID] = CreateObject(2403 + modelid, x, y, z, rx, ry, rz);
	SetPVarInt(playerid, "PlayerSurfing", 2);
	SetPVarInt(playerid, "WaitingOnEvent", 1);
	GetObjectPos(PlayerSurfboardInfo[playerid][nextid][objectID], objPos[0], objPos[1], objPos[2]);
	SetPlayerPos(playerid, objPos[0], objPos[1], objPos[2]+2);
	SetPlayerFacingAngle(playerid, PlayerSurfboardInfo[playerid][nextid][Pos][5] + 270.0);
	ApplyAnimation(playerid, "BSKTBALL", "BBALL_def_loop", 4.0, 1, 0, 0, 0, 0);
	PlayersInEvent++;
	IsEventReady();
	
	//printf("Successfully created %d event surfboard.", playerid);
	return nextid;
}	

stock DestroyPlayerSurfboard(playerid)
{
	new count = 0;
	for(new i = 0; i < MAX_PLAYER_SURFBOARD; i++)
	{
		if(count == 100) { break; }
		if(PlayerSurfboardInfo[playerid][i][ID] != INVALID_SURFBOARD_ID)
		{
			PlayerSurfboardInfo[playerid][i][ID] = INVALID_SURFBOARD_ID;
			PlayerSurfboardInfo[playerid][i][modelID] = 0;
			PlayerSurfboardInfo[playerid][i][Speed] = 0.0;
			PlayerSurfboardInfo[playerid][i][Pos][0] = 0.0;
			PlayerSurfboardInfo[playerid][i][Pos][1] = 0.0;
			PlayerSurfboardInfo[playerid][i][Pos][2] = 0.0;
			PlayerSurfboardInfo[playerid][i][Pos][3] = 0.0;
			PlayerSurfboardInfo[playerid][i][Pos][4] = 0.0;
			PlayerSurfboardInfo[playerid][i][Pos][5] = 0.0;
			PlayerSurfboardInfo[playerid][i][UpdatePos][0] = 0.0;
			PlayerSurfboardInfo[playerid][i][UpdatePos][1] = 0.0;
			PlayerSurfboardInfo[playerid][i][UpdatePos][2] = 0.0;
			DestroyObject(PlayerSurfboardInfo[playerid][i][objectID]);
			PlayerSurfboardInfo[playerid][i][objectID] = 0;
			ClearAnimations(playerid);
			DeletePVar(playerid, "PlayerSurfing");
			SetPlayerPos(playerid, 324.6641,-1892.0195,1.7212);
			
			//printf("Successfully destroyed %d surfboard.", playerid);
		}
		count++;
	}
	return 1;
}	

stock DestroyEventSurfboard(playerid)
{
	for(new i = 0; i < MAX_PLAYER_SURFBOARD; i++)
	{
		if(PlayerSurfboardInfo[playerid][i][ID] != INVALID_SURFBOARD_ID)
		{
			PlayerSurfboardInfo[playerid][i][ID] = INVALID_SURFBOARD_ID;
			PlayerSurfboardInfo[playerid][i][modelID] = 0;
			PlayerSurfboardInfo[playerid][i][Speed] = 0.0;
			PlayerSurfboardInfo[playerid][i][Pos][0] = 0.0;
			PlayerSurfboardInfo[playerid][i][Pos][1] = 0.0;
			PlayerSurfboardInfo[playerid][i][Pos][2] = 0.0;
			PlayerSurfboardInfo[playerid][i][Pos][3] = 0.0;
			PlayerSurfboardInfo[playerid][i][Pos][4] = 0.0;
			PlayerSurfboardInfo[playerid][i][Pos][5] = 0.0;
			PlayerSurfboardInfo[playerid][i][UpdatePos][0] = 0.0;
			PlayerSurfboardInfo[playerid][i][UpdatePos][1] = 0.0;
			PlayerSurfboardInfo[playerid][i][UpdatePos][2] = 0.0;
			DestroyObject(PlayerSurfboardInfo[playerid][i][objectID]);
			PlayerSurfboardInfo[playerid][i][objectID] = 0;
			ClearAnimations(playerid);
			CurrentCheckPoint[playerid] = 0;
			DisablePlayerRaceCheckpoint(playerid);
			SetPVarInt(playerid, "PlayerSurfing", 0);
			DeletePVar(playerid, "EventStage");
			if(GetPVarInt(playerid, "WaitingOnEvent") == 1) { DeletePVar(playerid, "WaitingOnEvent"); }
			PlayersInEvent--;
			if(PlayersInEvent == 0) { SurfingRaceStarted = 0; }
			SetPlayerPos(playerid, 324.6641,-1892.0195,1.7212);
			
			//printf("Successfully destroyed %d surfboard.", playerid);
		}
	}
	return 1;
}

stock IsPlayerSurfboardCreated(sID)
{
	for(new p = 0; p < MAX_PLAYERS; p++)
	{
		if(PlayerSurfboardInfo[p][sID][modelID]) return true;
	}	
	return false;
}	

stock GetFreePlayerSurfboard()
{
	new sID = INVALID_SURFBOARD_ID;
	for(new i = 0; i < MAX_PLAYER_SURFBOARD; i++)
	{
		if(!IsPlayerSurfboardCreated(i))
		{
			sID = i;
			break;
		}
	}
	return sID;
}	

stock SetPlayerSurfboardSpeed(playerid, sID, Float: surfspeed = MAX_SURFBOARD_SPEED)
{
	if(!IsPlayerSurfboardCreated(sID)) return false;
	if(surfspeed > MAX_SURFBOARD_SPEED) PlayerSurfboardInfo[playerid][sID][Speed] = MAX_SURFBOARD_SPEED;
	else PlayerSurfboardInfo[playerid][sID][Speed] = surfspeed;
	return 1;
}	

stock StopPlayerSurfboard(playerid, sID)
{
	if(!IsPlayerSurfboardCreated(sID)) return false;
	PlayerSurfboardInfo[playerid][sID][Speed] = 0.0;
	StopObject(PlayerSurfboardInfo[playerid][sID][objectID]);
	return true;
}

stock GetXYInFrontOfPlayerOnSB(playerid, &Float:x, &Float:y, Float:distance)
{
	new
			Float:angle;
	GetPlayerPos(playerid, x, y, angle);
	GetPlayerFacingAngle(playerid, angle);
	x += (distance * floatsin(-angle + 270.0, degrees));
	y += (distance * floatcos(-angle + 270.0, degrees));
}

stock IsEventReady()
{
	if(PlayersInEvent == MAX_EVENT_PLAYERS)
	{
		 for(new i = 0; i < MAX_PLAYERS; i++)
		 {
			if(GetPVarInt(i, "PlayerSurfing") == 2) 
			{
				SendClientMessage(i, COLOR_GREEN, "Prepare yourselves...");
				SetPVarInt(i, "EventStage", 1);
				SetPVarInt(i, "countdownevent", 1);
				SurfCountdown(i);
			}
		}
	} 
	else 
	{
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(GetPVarInt(i, "PlayerSurfing") == 2)
			{
				SendClientMessage(i, -1, "Waiting for more players...");
				
			}
		}
	} 
	return 1;
}

stock IsAPlane(carid)
{
	switch(GetVehicleModel(carid)) {
		case 592, 577, 511, 512, 593, 520, 553, 476, 519, 460, 513, 548, 425, 417, 487, 488, 497, 563, 447, 469: return 1;
	}
	return 0;
}

stock GetPlayerNameEx(playerid) 
{
	new szName[MAX_PLAYER_NAME], iPos;
	GetPlayerName(playerid, szName, MAX_PLAYER_NAME);
	while ((iPos = strfind(szName, "_", false, iPos)) != -1) szName[iPos] = ' ';
	return szName;
}
// ---------------------- [Commands] --------------------------
CMD:surf(playerid, params[])
{
	//if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, -1, "Currently unavailable, we're fixing an issue");
	new Float: pos[3], string[128];
	
	if(IsPlayerInRangeOfPoint(playerid, 10.0, 324.7307,-1912.4688,-0.4616)) 
	{
		if(GetPVarInt(playerid, "PlayerSurfing") != 0) return SendClientMessage(playerid, COLOR_NAVY, "You're already surfing!");
		if(PlayerSurfboardCount == MAX_PLAYER_SURFBOARD) return SendClientMessage(playerid, COLOR_NAVY, "Sorry, we cannot spawn a surfboard at the moment as we have reached the limit of current player surfboards.");	
		if(PlayersInEvent == MAX_EVENT_PLAYERS) return SendClientMessage(playerid, COLOR_NAVY, "The event is full!");
		if(SurfingRaceStarted == 1) return SendClientMessage(playerid, COLOR_NAVY, "The event has already started!");
	
		GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
		CreateEventSurfboard(playerid, 2, pos[0], pos[1], 0.1000000, 270, 0.0, 180.0);
		format(string, sizeof(string), "You joined the {FF2200}surfing event{F2EF27}, the event will start at %d players.", MAX_EVENT_PLAYERS);
		SendClientMessage(playerid, 0xF2EF27FF, string);
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(GetPVarInt(i, "PlayerSurfing") == 2)
			{
				format(string, sizeof(string), "[Surfing Event] %s has joined the race.", GetPlayerNameEx(playerid));
				SendClientMessage(i, COLOR_GREEN, string);
				
			}
		}
	}	
	else if(IsPlayerInRangeOfPoint(playerid, 50.0, 256.4779,-1930.8368,-0.1967)) 
	{
		if(GetPVarInt(playerid, "PlayerSurfing") != 0) return SendClientMessage(playerid, COLOR_NAVY, "You're already surfing!");
		if(PlayerSurfboardCount == 100) return SendClientMessage(playerid, COLOR_NAVY, "Sorry, we cannot spawn a surfboard at the moment as we have reached the limit of current player surfboards.");	
	
		GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
		CreatePlayerSurfboard(playerid, 1, pos[0], pos[1], 0.1000000, 270, 0.0, 180.0);
	}	
	else 
	{
		SendClientMessage(playerid, COLOR_NAVY, "To join the surfing event, head to the quay next of the dancefloor at Santa Maria Beach.");
		SendClientMessage(playerid, COLOR_NAVY, "If you want to freeroam surf, head next of the light house.");
	}	
	return 1;
}

CMD:leavesurf(playerid, params[])
{
	new string[128];
	if(GetPVarInt(playerid, "EventStage") == 1) return SendClientMessage(playerid, COLOR_NAVY, "You cannot leave the surfing event at this stage.");
	if(GetPVarInt(playerid, "PlayerSurfing") == 2)
	{
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(GetPVarInt(i, "PlayerSurfing") == 2)
			{
				format(string, sizeof(string), "[Surfing Event] %s has left the race (/leavesurf).", GetPlayerNameEx(playerid));
				SendClientMessage(i, COLOR_GREEN, string);
				DestroyEventSurfboard(playerid);			
			}
		}
	}	
	else if(GetPVarInt(playerid, "PlayerSurfing") == 1)
	{
		DestroyPlayerSurfboard(playerid);
		PlayerSurfboardCount--;
		SendClientMessage(playerid, COLOR_NAVY, "You have stopped surfing.");
	}	
	return 1;
}	

CMD:surfers(playerid, params[])
{
	if(!IsPlayerAdmin(playerid)) return 0;
	new string[128];
	format(string, sizeof(string), "Current Surfers %d", PlayerSurfboardCount);
	SendClientMessage(playerid, -1, string);
	return 1;
}

CMD:surfersevent(playerid, params[])
{
	if(!IsPlayerAdmin(playerid)) return 0;
	new string[128];
	format(string, sizeof(string), "Current Surfers %d", PlayersInEvent);
	SendClientMessage(playerid, -1, string);
	return 1;
}		

CMD:joinsurf(playerid, params[])
{
	return SendClientMessage(playerid, -1, "This command has been re-named to /surf");
}	
// ---------------------- [Commands] --------------------------
task SurfUpdate[2000]()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(GetPVarInt(i, "PlayerSurfing") != 0)
		{	
			for(new sID = 0; sID < MAX_PLAYER_SURFBOARD; sID++)
			{
				if(PlayerSurfboardInfo[i][sID][ID] != INVALID_SURFBOARD_ID)
				{
					new Float: pos[3], Float: objPos[3];
					GetObjectPos(PlayerSurfboardInfo[i][sID][objectID], objPos[0], objPos[1], objPos[2]);
					GetPlayerPos(i, pos[0], pos[1], pos[2]);
					if(pos[2] < objPos[2])
					{
						if(GetPVarInt(i, "PlayerSurfing") == 1)
						{
							PlayerSurfboardCount--;
							DestroyPlayerSurfboard(i);
							SendClientMessage(i, COLOR_NAVY, "You have fell off the surfing board & have been sent back to Santa Maria Beach.");
						}	
						else if(GetPVarInt(i, "PlayerSurfing") == 2)
						{
							DestroyEventSurfboard(i);
							SendClientMessage(i, COLOR_NAVY, "You have fell off the surfing board & have been disqualified from the event.");
						}
					}
					if(pos[0] == 0 || pos[1] == 0 || pos[2] == 0)
					{
						if(GetPVarInt(i, "PlayerSurfing") == 1)
						{
							DestroyPlayerSurfboard(i);
							SendClientMessage(i, COLOR_NAVY, "You're currently bugged, we've sent you back to Santa Maria Beach");
						}	
						else if(GetPVarInt(i, "PlayerSurfing") == 2)
						{
							DestroyEventSurfboard(i);
							SendClientMessage(i, COLOR_NAVY, "You're currently bugged, we've sent you back to Santa Maria Beach");
						}	
					}	
				}
			}
		}
	}
	return 1;
}

