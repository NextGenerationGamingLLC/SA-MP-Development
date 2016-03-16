/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Garbage Job System

				Next Generation Gaming, LLC
	(created by Next Generation Gaming Development Team)

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

// WINTERFIELD: VERSION .278 GARBAGE JOB

#include <YSI\y_hooks>

hook OnGameModeInit() {

	GarbageVehicles[0] = AddStaticVehicleEx(408,2450.0818,-2117.0393,14.0948,359.3405,-1,-1,300); // Garbage 1
	GarbageVehicles[1] = AddStaticVehicleEx(408,2456.0059,-2117.0317,14.0978,359.8398,-1,-1,300); // Garbage 2
	GarbageVehicles[2] = AddStaticVehicleEx(408,2461.9404,-2116.9187,14.1033,1.3363,-1,-1,300); // Garbage 3
	GarbageVehicles[3] = AddStaticVehicleEx(408,2467.7634,-2116.7227,14.1018,0.6403,-1,-1,300); // Garbage 4
	GarbageVehicles[4] = AddStaticVehicleEx(408,2474.4385,-2116.6218,14.0943,2.2394,-1,-1,300); // Garbage 5
	GarbageVehicles[5] = AddStaticVehicleEx(408,2480.3513,-2116.6707,14.0944,359.6030,-1,-1,300); // Garbage 6
	GarbageVehicles[6] = AddStaticVehicleEx(408,2485.4556,-2116.5200,14.0988,1.4351,-1,-1,300); // Garbage 7
	GarbageVehicles[7] = AddStaticVehicleEx(408,2491.1963,-2116.4548,14.0918,0.3940,-1,-1,300); // Garbage 8
}

hook OnPlayerEnterCheckpoint(playerid)
{
    if(GetPVarInt(playerid, "pGarbageRun") >= 1)
	{
		if(IsInGarbageTruck(GetPlayerVehicleID(playerid)))
		{
			if(GetPVarInt(playerid, "pGarbageStage") <= 4)
			{
		    	TogglePlayerControllable(playerid, false);
		    	GameTextForPlayer(playerid, "~W~LOADING...", 5000, 4);
		    	SetTimerEx("GarbageJobLoad", 4000, false, "i", playerid);
			}
			else if(GetPVarInt(playerid, "pGarbageStage") >= 5)
			{
			    new value = 10000+random(10000);
			    
		    	SetVehicleToRespawn(GetPlayerVehicleID(playerid));
		    	
		    	DeletePVar(playerid, "pGarbageRun");
       			DeletePVar(playerid, "pGarbageStage");
       			
       			DisablePlayerCheckpoint(playerid);
		    	
       			GivePlayerCash(playerid, value);
       			
       			format(szMiscArray, sizeof(szMiscArray), "You have completed your garbage run and earned $%s.", number_format(value));
				SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
				
			    if(PlayerInfo[playerid][pDoubleEXP] > 0)
				{
					format(szMiscArray, sizeof(szMiscArray), "You have gained 2 garbage skill points instead of 1. You have %d hours left on the Double EXP token.", PlayerInfo[playerid][pDoubleEXP]);
					SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
					PlayerInfo[playerid][pGarbageSkill] += 2;
				}
				else
				{
					PlayerInfo[playerid][pGarbageSkill] += 1;
				}
			}
			return 1;
		}
		else SendClientMessageEx(playerid, COLOR_GRAD1, "  You are not in a garbage truck!");
	}
 	return 1;
}

command(garbagerun, playerid, params[])
{
	if(PlayerInfo[playerid][pJob] == 27 || PlayerInfo[playerid][pJob2] == 27 || PlayerInfo[playerid][pJob3] == 27)
	{
	    if(IsInGarbageTruck(GetPlayerVehicleID(playerid)))
	    {
	        if(GetPVarInt(playerid, "pGarbageRun") <= 0)
	        {
	        	if(CheckPointCheck(playerid)) cmd_killcheckpoint(playerid, params);
	        	
                SetPVarInt(playerid, "pGarbageRun", 1);
                DeletePVar(playerid, "pGarbageStage");
                SetPVarInt(playerid, "pGarbagePath", random(5));
                    
                SendClientMessageEx(playerid, COLOR_YELLOW, "You have started a garbage run, make your way to your first destination.");
                AdvanceGarbageJob(playerid);
	        }
	        else return SendClientMessageEx(playerid, COLOR_GRAD1, "  You are already on a garbage run!");
	    }
	    else return SendClientMessageEx(playerid, COLOR_GRAD1, "  You are not in a garbage truck!");
	}
	else SendClientMessageEx(playerid, COLOR_GRAD1, "  You are not a garbage man!");
	return 1;
}

AdvanceGarbageJob(playerid)
{
    switch(GetPVarInt(playerid, "pGarbagePath"))
    {
        case 0:
		{
		    switch(GetPVarInt(playerid, "pGarbageStage"))
		    {
		        case 0: SetPlayerCheckpoint(playerid, 1864.9694,-1868.8340,13.5393, 4.0);
		        case 1: SetPlayerCheckpoint(playerid, 1339.1879,-1772.2593,13.5432, 4.0);
		        case 2: SetPlayerCheckpoint(playerid, 1097.3889,-1315.5203,13.7031, 4.0);
		        case 3: SetPlayerCheckpoint(playerid, 788.5202,-1616.8534,13.9347, 4.0);
		        case 4: SetPlayerCheckpoint(playerid, 870.7766,-1339.1848,13.1193, 4.0);
		    }
		}
		case 1:
		{
		    switch(GetPVarInt(playerid, "pGarbageStage"))
		    {
		        case 0: SetPlayerCheckpoint(playerid, 2393.3289,-2011.2156,13.1266, 4.0);
		        case 1: SetPlayerCheckpoint(playerid, 2226.3372,-1689.5676,13.5651, 4.0);
		        case 2: SetPlayerCheckpoint(playerid, 2340.3894,-1314.6295,23.6431, 4.0);
		        case 3: SetPlayerCheckpoint(playerid, 2567.5251,-1490.1581,23.5875, 4.0);
		        case 4: SetPlayerCheckpoint(playerid, 2123.0171,-1724.6511,13.1059, 4.0);
		    }
		}
		case 2:
		{
		    switch(GetPVarInt(playerid, "pGarbageStage"))
		    {
		        case 0: SetPlayerCheckpoint(playerid, 365.6633,-2045.8699,7.2444, 4.0);
		        case 1: SetPlayerCheckpoint(playerid, 1032.4659,-1873.3563,12.8004, 4.0);
		        case 2: SetPlayerCheckpoint(playerid, 2223.6206,-2669.4250,13.1041, 4.0);
		        case 3: SetPlayerCheckpoint(playerid, 2613.2957,-2385.6138,13.1910, 4.0);
		        case 4: SetPlayerCheckpoint(playerid, 2197.1860,-1975.7141,13.1308, 4.0);
		    }
		}
		case 3:
  		{
		    switch(GetPVarInt(playerid, "pGarbageStage"))
		    {
		        case 0: SetPlayerCheckpoint(playerid, 1122.9072,-1567.9572,12.9752, 4.0);
		        case 1: SetPlayerCheckpoint(playerid, 1363.5902,-1489.5615,13.1180, 4.0);
		        case 2: SetPlayerCheckpoint(playerid, 1212.3572,-1128.1580,23.6371, 4.0);
		        case 3: SetPlayerCheckpoint(playerid, 1138.6549,-864.0754,42.8240, 4.0);
		        case 4: SetPlayerCheckpoint(playerid, 694.8854,-1184.0023,15.0451, 4.0);
		    }
		}
		case 4:
		{
		    switch(GetPVarInt(playerid, "pGarbageStage"))
		    {
		        case 0: SetPlayerCheckpoint(playerid, 1217.1318,-874.5201,42.4655, 4.0);
		        case 1: SetPlayerCheckpoint(playerid, 1904.5316,-1776.6147,13.1084, 4.0);
		        case 2: SetPlayerCheckpoint(playerid, 2127.1011,-1795.1913,13.1227, 4.0);
		        case 3: SetPlayerCheckpoint(playerid, 2381.8950,-1937.8840,13.1190, 4.0);
		        case 4: SetPlayerCheckpoint(playerid, 2392.3760,-1476.8688,23.3760, 4.0);
		    }
		}
		case 5:
		{
		    switch(GetPVarInt(playerid, "pGarbageStage"))
		    {
		        case 0: SetPlayerCheckpoint(playerid, 2231.9036,-1415.6742,23.3977, 4.0);
		        case 1: SetPlayerCheckpoint(playerid, 2084.4321,-1261.1422,23.5523, 4.0);
		        case 2: SetPlayerCheckpoint(playerid, 2094.3391,-1074.8816,25.9005, 4.0);
		        case 3: SetPlayerCheckpoint(playerid, 2598.8777,-1060.4468,69.1403, 4.0);
		        case 4: SetPlayerCheckpoint(playerid, 2743.9485,-1944.5190,13.1191, 4.0);
		    }
		}
		case 6:
		{
		    switch(GetPVarInt(playerid, "pGarbageStage"))
		    {
		        case 0: SetPlayerCheckpoint(playerid, 2194.4458,-1978.2390,13.1250, 4.0);
		        case 1: SetPlayerCheckpoint(playerid, 1933.0288,-2036.1970,13.1260, 4.0);
		        case 2: SetPlayerCheckpoint(playerid, 1501.1422,-1864.9788,13.1113, 4.0);
		        case 3: SetPlayerCheckpoint(playerid, 1338.9059,-1843.0479,13.1106, 4.0);
		        case 4: SetPlayerCheckpoint(playerid, 1420.6254,-1350.9736,13.1186, 4.0);
		    }
		}
		case 7:
		{
		    switch(GetPVarInt(playerid, "pGarbageStage"))
		    {
		        case 0: SetPlayerCheckpoint(playerid, 1017.2939,-1344.6605,12.9403, 4.0);
		        case 1: SetPlayerCheckpoint(playerid, 827.6715,-1056.1721,24.8689, 4.0);
		        case 2: SetPlayerCheckpoint(playerid, 1427.1379,-1047.8226,23.1440, 4.0);
		        case 3: SetPlayerCheckpoint(playerid, 2216.7776,-1373.0634,23.5690, 4.0);
		        case 4: SetPlayerCheckpoint(playerid, 2168.1399,-1650.5302,14.6085, 4.0);
		    }
		}
		case 8:
		{
		    switch(GetPVarInt(playerid, "pGarbageStage"))
		    {
		        case 0: SetPlayerCheckpoint(playerid, 2198.2585,-1499.0953,23.5222, 4.0);
		        case 1: SetPlayerCheckpoint(playerid, 2366.4785,-1270.1448,23.3978, 4.0);
		        case 2: SetPlayerCheckpoint(playerid, 2367.8533,-1760.7986,13.1166, 4.0);
		        case 3: SetPlayerCheckpoint(playerid, 2821.5671,-1541.5742,10.4837, 4.0);
		        case 4: SetPlayerCheckpoint(playerid, 2314.0564,-2307.3513,13.1077, 4.0);
		    }
		}
    }
	return 1;
}

forward GarbageJobLoad(playerid);
public GarbageJobLoad(playerid)
{
	SetPVarInt(playerid, "pGarbageStage", GetPVarInt(playerid, "pGarbageStage")+1);
    
    TogglePlayerControllable(playerid, true);
    
    if(GetPVarInt(playerid, "pGarbageStage") != 5)
    {
    	AdvanceGarbageJob(playerid);
    	SendClientMessageEx(playerid, COLOR_WHITE, "Garbage loaded, make your way to the next checkpoint.");
	}
	else
	{
	    SetPlayerCheckpoint(playerid, 2520.4834,-2089.1470,13.5469, 4.0); // return to hq
	    SendClientMessageEx(playerid, COLOR_WHITE, "Your garbage truck is full, make your way back to headquarters.");
	}
    return 1;
}