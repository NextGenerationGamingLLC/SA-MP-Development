/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

					Call System

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

stock SendCallToQueue(callfrom, description[], area[], mainzone[], type, vehicleid = INVALID_VEHICLE_ID)
{
    new bool:breakingloop = false, newid = INVALID_CALL_ID, string[128];

	for(new i; i < MAX_CALLS; i++)
	{
		if(!breakingloop)
		{
			if(Calls[i][HasBeenUsed] == 0)
			{
				breakingloop = true;
				newid = i;
			}
		}
    }
    if(newid != INVALID_CALL_ID)
    {
		for(new i = 0; i < MAX_PLAYERS; ++i)
		{
			if(IsPlayerConnected(i))
			{
				if(0 <= PlayerInfo[i][pMember] < MAX_GROUPS)
				{
					for(new j; j < arrGroupData[PlayerInfo[i][pMember]][g_iJCount]; j++)
					{
						if(strcmp(arrGroupJurisdictions[PlayerInfo[i][pMember]][j][g_iAreaName], area, true) == 0 || strcmp(arrGroupJurisdictions[PlayerInfo[i][pMember]][j][g_iAreaName], mainzone, true) == 0)
						{
							if((type == 0 || type == 4) && IsACop(i))
							{
								PlayCrimeReportForPlayer(i, callfrom, 7);
								format(string, sizeof(string), "HQ: All Units APB: Reporter: %s", GetPlayerNameEx(callfrom));
								SendClientMessageEx(i, TEAM_BLUE_COLOR, string);
								format(string, sizeof(string), "HQ: Location: %s, Description: %s", area, description);
								SendClientMessageEx(i, TEAM_BLUE_COLOR, string);
							}
							if(type == 1 && IsAMedic(i))
							{
								PlayCrimeReportForPlayer(i, callfrom, 7);
								format(string, sizeof(string), "HQ: All Units APB: Reporter: %s", GetPlayerNameEx(callfrom));
								SendClientMessageEx(i, TEAM_BLUE_COLOR, string);
								format(string, sizeof(string), "HQ: Location: %s, Description: %s", area, description);
								SendClientMessageEx(i, TEAM_BLUE_COLOR, string);
							}
							if(type == 2 && IsACop(i))
							{
								PlayCrimeReportForPlayer(i, callfrom, 7);
								format(string, sizeof(string), "HQ: All Units APB: Reporter: %s", GetPlayerNameEx(callfrom));
								SendClientMessageEx(i, TEAM_BLUE_COLOR, string);
								format(string, sizeof(string), "HQ: Location: %s, Description: %s", area, description);
								SendClientMessageEx(i, TEAM_BLUE_COLOR, string);
							}
							if(type == 3 && (IsACop(i) || IsATowman(i)))
							{
								PlayCrimeReportForPlayer(i, callfrom, 7);
								format(string, sizeof(string), "HQ: All Units APB: Reporter: %s", GetPlayerNameEx(callfrom));
								SendClientMessageEx(i, TEAM_BLUE_COLOR, string);
								format(string, sizeof(string), "HQ: Location: %s, Description: %s", area, description);
								SendClientMessageEx(i, TEAM_BLUE_COLOR, string);
							}
							if(type == 5 && (IsACop(i) || IsAMedic(i)))
							{
								PlayCrimeReportForPlayer(i, callfrom, 7);
								format(string, sizeof(string), "HQ: All Units APB: Reporter: %s", GetPlayerNameEx(callfrom));
								SendClientMessageEx(i, TEAM_BLUE_COLOR, string);
								format(string, sizeof(string), "HQ: Location: %s, Description: %s", area, description);
								SendClientMessageEx(i, TEAM_BLUE_COLOR, string);
							}
							if(type == 6 && (IsAReporter(i)))
							{
								format(string, sizeof(string), "Hotline: Caller: %s", GetPlayerNameEx(callfrom));
								SendClientMessageEx(i, COLOR_PINK, string);
								format(string, sizeof(string), "Hotline: Location: %s, Description: %s", area, description);
								SendClientMessageEx(i, COLOR_PINK, string);
							}
						}
					}
				}
			}
     	}
     	SetPVarInt(callfrom, "Has911Call", 1);
		strmid(Calls[newid][Area], area, 0, strlen(area), 28);
		strmid(Calls[newid][MainZone], mainzone, 0, strlen(mainzone), 28);
		strmid(Calls[newid][Description], description, 0, strlen(description), 128);
		Calls[newid][CallFrom] = callfrom;
		Calls[newid][Type] = type;
		Calls[newid][TimeToExpire] = 0;
		Calls[newid][HasBeenUsed] = 1;
		Calls[newid][BeingUsed] = 1;
		Calls[newid][CallVehicleId] = vehicleid;
		Calls[newid][CallExpireTimer] = SetTimerEx("CallTimer", 60000, 0, "d", newid);
		new query[512];
		format(query, sizeof(query), "INSERT INTO `911Calls` (Caller, Phone, Area, MainZone, Description, Type, Time) VALUES ('%s', %d, '%s', '%s', '%s', %d, UNIX_TIMESTAMP())", GetPlayerNameEx(callfrom), PlayerInfo[callfrom][pPnumber], g_mysql_ReturnEscaped(area, MainPipeline), mainzone, g_mysql_ReturnEscaped(description, MainPipeline), type);
		mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
    }
    else
    {
        ClearCalls();
        SendCallToQueue(callfrom, description, area, mainzone, type, vehicleid);
    }
}

stock ClearCalls()
{
	for(new i; i < MAX_CALLS; i++)
	{
	    if(Calls[i][BeingUsed] == 1) DeletePVar(Calls[i][CallFrom], "Has911Call");
		strmid(Calls[i][Area], "None", 0, 4, 4);
		strmid(Calls[i][MainZone], "None", 0, 4, 4);
		strmid(Calls[i][Description], "None", 0, 4, 4);
		Calls[i][RespondingID] = INVALID_PLAYER_ID;
        Calls[i][CallFrom] = INVALID_PLAYER_ID;
		Calls[i][Type] = -1;
        Calls[i][TimeToExpire] = 0;
        Calls[i][HasBeenUsed] = 0;
        Calls[i][BeingUsed] = 0;
		Calls[i][CallVehicleId] = INVALID_VEHICLE_ID;
	}
	return 1;
}

forward CallTimer(callid);
public CallTimer(callid)
{
	if(Calls[callid][BeingUsed] == 1)
	{
	    if(Calls[callid][TimeToExpire] >= 0)
	    {
	        Calls[callid][TimeToExpire]++;
  			Calls[callid][CallExpireTimer] = SetTimerEx("CallTimer", 60000, 0, "d", callid);
		}
	}
	return 1;
}

CMD:calls(playerid, params[])
{
	if(0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS)
	{
		new string[128];
		if(arrGroupData[PlayerInfo[playerid][pMember]][g_iGroupType] == 4) SendClientMessageEx(playerid, COLOR_PINK, "____________________ HOTLINE ____________________");
		else SendClientMessageEx(playerid, COLOR_DBLUE, "____________________ 911 CALLS ____________________");
		for(new i = 999; i >= 0; i--) // Why in hell would we run 4 unnecessary loops here?
		{
			if(Calls[i][BeingUsed] == 1)
			{
				for(new j; j < arrGroupData[PlayerInfo[playerid][pMember]][g_iJCount]; j++)
				{
					if(strcmp(arrGroupJurisdictions[PlayerInfo[playerid][pMember]][j][g_iAreaName], Calls[i][Area], true) == 0 || strcmp(arrGroupJurisdictions[PlayerInfo[playerid][pMember]][j][g_iAreaName], Calls[i][MainZone], true) == 0 || (!strcmp(arrGroupJurisdictions[PlayerInfo[playerid][pMember]][j][g_iAreaName], gMainZones[9][SAZONE_NAME], true) && strcmp(Calls[i][MainZone], gMainZones[3][SAZONE_NAME], true) == -1))
					{
						if(Calls[i][Type] == 0 && IsACop(playerid))
						{
							format(string, sizeof(string), "[EMERGENCY] %s | Call #%i | Description: %s | 10-20: %s | Pending: %d minutes", GetPlayerNameEx(Calls[i][CallFrom]), i, Calls[i][Description], Calls[i][Area], Calls[i][TimeToExpire]);
							SendClientMessageEx(playerid, COLOR_RED, string);
						}
						else if(Calls[i][Type] == 1 && IsAMedic(playerid))
						{
							format(string, sizeof(string), "%s | Call #%i | Description: %s | 10-20: %s | Pending: %d minutes", GetPlayerNameEx(Calls[i][CallFrom]), i, Calls[i][Description], Calls[i][Area], Calls[i][TimeToExpire]);
							SendClientMessageEx(playerid, COLOR_WHITE, string);
						}
						else if(Calls[i][Type] == 2 && IsACop(playerid))
						{
							format(string, sizeof(string), "%s | Call #%i | Description: %s | 10-20: %s | Pending: %d minutes", GetPlayerNameEx(Calls[i][CallFrom]), i, Calls[i][Description], Calls[i][Area], Calls[i][TimeToExpire]);
							SendClientMessageEx(playerid, COLOR_WHITE, string);
						}
						else if(Calls[i][Type] == 3 && (IsACop(playerid) || IsATowman(playerid)))
						{
							format(string, sizeof(string), "[TOWING] %s | Call #%i | Description: %s | 10-20: %s | Pending: %d minutes", GetPlayerNameEx(Calls[i][CallFrom]), i, Calls[i][Description], Calls[i][Area], Calls[i][TimeToExpire]);
							SendClientMessageEx(playerid, COLOR_WHITE, string);
						}
						else if(Calls[i][Type] == 4 && IsACop(playerid))
						{
							format(string, sizeof(string), "%s | Call #%i | Description: %s | 10-20: %s | Pending: %d minutes", GetPlayerNameEx(Calls[i][CallFrom]), i, Calls[i][Description], Calls[i][Area], Calls[i][TimeToExpire]);
							SendClientMessageEx(playerid, COLOR_WHITE, string);
						}
						else if(Calls[i][Type] == 5 && (IsACop(playerid) || IsAMedic(playerid)))
						{
							format(string, sizeof(string), "%s | Call #%i | Description: %s | 10-20: %s | Pending: %d minutes", GetPlayerNameEx(Calls[i][CallFrom]), i, Calls[i][Description], Calls[i][Area], Calls[i][TimeToExpire]);
							SendClientMessageEx(playerid, COLOR_WHITE, string);
						}
						else if(Calls[i][Type] == 6 && (IsAReporter(playerid)))
						{
							format(string, sizeof(string), "%s | Call #%i | Description: %s | Location: %s | Pending: %d minutes", GetPlayerNameEx(Calls[i][CallFrom]), i, Calls[i][Description], Calls[i][Area], Calls[i][TimeToExpire]);
							SendClientMessageEx(playerid, COLOR_WHITE, string);
						}
					}
				}
			}
		}
		/* for(new i = 999; i >= 0; i--)
		{
			if(Calls[i][BeingUsed] == 1)
			{
				for(new j; j < arrGroupData[PlayerInfo[playerid][pMember]][g_iJCount]; j++)
				{
					if(strcmp(arrGroupJurisdictions[PlayerInfo[playerid][pMember]][j][g_iAreaName], Calls[i][Area], true) == 0 || strcmp(arrGroupJurisdictions[PlayerInfo[playerid][pMember]][j][g_iAreaName], Calls[i][MainZone], true) == 0)
					{
						if(Calls[i][Type] == 1 && IsAMedic(playerid))
						{
							format(string, sizeof(string), "%s | Call #%i | Description: %s | 10-20: %s | Pending: %d minutes", GetPlayerNameEx(Calls[i][CallFrom]), i, Calls[i][Description], Calls[i][Area], Calls[i][TimeToExpire]);
							SendClientMessageEx(playerid, COLOR_WHITE, string);
						}
					}
				}
			}
		}
		for(new i = 999; i >= 0; i--)
		{
			if(Calls[i][BeingUsed] == 1)
			{
				for(new j; j < arrGroupData[PlayerInfo[playerid][pMember]][g_iJCount]; j++)
				{
					if(strcmp(arrGroupJurisdictions[PlayerInfo[playerid][pMember]][j][g_iAreaName], Calls[i][Area], true) == 0 || strcmp(arrGroupJurisdictions[PlayerInfo[playerid][pMember]][j][g_iAreaName], Calls[i][MainZone], true) == 0)
					{
						if(Calls[i][Type] == 2 && IsACop(playerid))
						{
							format(string, sizeof(string), "%s | Call #%i | Description: %s | 10-20: %s | Pending: %d minutes", GetPlayerNameEx(Calls[i][CallFrom]), i, Calls[i][Description], Calls[i][Area], Calls[i][TimeToExpire]);
							SendClientMessageEx(playerid, COLOR_WHITE, string);
						}
					}
				}
			}
		}
		for(new i = 999; i >= 0; i--)
		{
			if(Calls[i][BeingUsed] == 1)
			{
				for(new j; j < arrGroupData[PlayerInfo[playerid][pMember]][g_iJCount]; j++)
				{
					if(strcmp(arrGroupJurisdictions[PlayerInfo[playerid][pMember]][j][g_iAreaName], Calls[i][Area], true) == 0 || strcmp(arrGroupJurisdictions[PlayerInfo[playerid][pMember]][j][g_iAreaName], Calls[i][MainZone], true) == 0)
					{
						if(Calls[i][Type] == 3 && (IsACop(playerid) || IsATowman(playerid)))
						{
							format(string, sizeof(string), "[TOWING] %s | Call #%i | Description: %s | 10-20: %s | Pending: %d minutes", GetPlayerNameEx(Calls[i][CallFrom]), i, Calls[i][Description], Calls[i][Area], Calls[i][TimeToExpire]);
							SendClientMessageEx(playerid, COLOR_WHITE, string);
						}
					}
				}
			}
		} */
		SendClientMessageEx(playerid, COLOR_DBLUE, "___________________________________________________");
	}
	return 1;
}

CMD:ac(playerid, params[])
{
	return cmd_acceptcall(playerid, params);
}

CMD:acceptcall(playerid, params[])
{
	if(0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS)
	{
		new string[128], callid;
		if(sscanf(params, "d", callid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /ac [call #]");

		if(callid < 0 || callid > 999) return SendClientMessageEx(playerid, COLOR_GREY, "   Call number cannot be below 0 or above 999!");
		if(Calls[callid][BeingUsed] == 0) return SendClientMessageEx(playerid, COLOR_GREY, "   There is no pending call with that number!");
		if(playerid == Calls[callid][CallFrom]) return SendClientMessageEx(playerid, COLOR_GREY, "   You can't accept your own call!");
		if(((Calls[callid][Type] == 0 || Calls[callid][Type] == 4) && !IsACop(playerid)) || (Calls[callid][Type] == 1 && !IsAMedic(playerid)) || (Calls[callid][Type] == 2 && !IsACop(playerid)) || (Calls[callid][Type] == 3 && !IsACop(playerid) && !IsATowman(playerid))) return SendClientMessageEx(playerid, COLOR_GREY, "   You cannot answer this call!");
		if(!IsPlayerConnected(Calls[callid][CallFrom]))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "   The caller has disconnected!");
			Calls[callid][CallFrom] = INVALID_PLAYER_ID;
			Calls[callid][BeingUsed] = 0;
			return 1;
		}
		for(new j; j < arrGroupData[PlayerInfo[playerid][pMember]][g_iJCount]; j++)
		{
			if(strcmp(arrGroupJurisdictions[PlayerInfo[playerid][pMember]][j][g_iAreaName], Calls[callid][Area], true) == 0 || strcmp(arrGroupJurisdictions[PlayerInfo[playerid][pMember]][j][g_iAreaName], Calls[callid][MainZone], true) == 0)
			{
				new Float: Pos[3], Float: carPos[3], targetid = Calls[callid][CallFrom], targetslot = GetPlayerVehicle(Calls[callid][CallFrom], Calls[callid][CallVehicleId]);
				if(Calls[callid][CallVehicleId] != INVALID_VEHICLE_ID && Calls[callid][Type] == 4) {
					switch(PlayerVehicleInfo[targetid][targetslot][pvAlarm]) {
						case 1: {
							new zone[MAX_ZONE_NAME], mainzone[MAX_ZONE_NAME];
							Get3DZone(carPos[0], carPos[1], carPos[2], zone, sizeof(zone));
							Get2DMainZone(carPos[0], carPos[1], mainzone, sizeof(mainzone));
							format(string, sizeof(string), "This %s(%d) is located in %s(%s).", GetVehicleName(Calls[callid][CallVehicleId]), zone, mainzone);
							SendClientMessageEx(playerid, COLOR_YELLOW, string);
						}
						case 2: {
							if(PlayerVehicleInfo[targetid][targetslot][pvAlarmTriggered]) {
								
								if(PlayerVehicleInfo[targetid][targetslot][pvId] != INVALID_PLAYER_VEHICLE_ID)
								{
									GetVehiclePos(PlayerVehicleInfo[targetid][targetslot][pvId], carPos[0], carPos[1], carPos[2]);
									if(CheckPointCheck(playerid))
									{
										return SendClientMessageEx(playerid, COLOR_WHITE, "Please ensure that your current checkpoint is destroyed first (you either have material packages, or another existing checkpoint).");
									}
									else
									{
										new zone[MAX_ZONE_NAME], mainzone[MAX_ZONE_NAME];
										Get3DZone(carPos[0], carPos[1], carPos[2], zone, sizeof(zone));
										Get2DMainZone(carPos[0], carPos[1], mainzone, sizeof(mainzone));
										format(string, sizeof(string), "This %s(%d) is located in %s(%s).", GetVehicleName(Calls[callid][CallVehicleId]), zone, mainzone);
										SendClientMessageEx(playerid, COLOR_YELLOW, string);
										
										SetPVarFloat(playerid, "CarLastX", carPos[0]);
										SetPVarFloat(playerid, "CarLastY", carPos[1]);
										SetPVarFloat(playerid, "CarLastZ", carPos[2]);
										SetPVarInt(playerid, "TrackVehicleBurglary", 120);
										SetPVarInt(playerid, "CallId", callid);
										SetPlayerCheckpoint(playerid, carPos[0], carPos[1], carPos[2], 15.0);
										SendClientMessageEx(playerid, COLOR_WHITE, "Hint: Make your way to the checkpoint to find the vehicle(Will only last 2 minutes)!");
									}
								}
								else if(PlayerVehicleInfo[targetid][targetslot][pvImpounded]) SendClientMessageEx(playerid, COLOR_WHITE, "You can not track an impounded vehicle.");
								else if(PlayerVehicleInfo[targetid][targetslot][pvDisabled] == 1) SendClientMessageEx(playerid, COLOR_WHITE, "You can not track a disabled vehicle.");
								else if(PlayerVehicleInfo[targetid][targetslot][pvSpawned] == 0) SendClientMessageEx(playerid, COLOR_WHITE, "You can not track a stored vehicle.");
								else SendClientMessageEx(playerid, COLOR_WHITE, "You can not track a non-existent vehicle.");
							}
						}
					}
				}
				//foreach(new i: Player)
				for(new i = 0; i < MAX_PLAYERS; ++i)
				{
					if(IsPlayerConnected(i))
					{
						if(PlayerInfo[i][pMember] == PlayerInfo[playerid][pMember] && PlayerInfo[playerid][pRank] >= arrGroupData[PlayerInfo[playerid][pMember]][g_iRadioAccess]) {
							format(string, sizeof(string), "%s has accepted %s's call from %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(Calls[callid][CallFrom]), Calls[callid][Area]);
							SendClientMessageEx(i, COLOR_DBLUE, string);
						}
						if(GetPVarInt(i, "BigEar") == 4 && GetPVarInt(i, "BigEarGroup") == PlayerInfo[playerid][pMember]) {
							format(string, sizeof(string), "(BE) %s has accepted %s's call from %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(Calls[callid][CallFrom]), Calls[callid][Area]);
							SendClientMessageEx(i, COLOR_DBLUE, string);
						}
					}	
				}
				PlayCrimeReportForPlayer(playerid, Calls[callid][CallFrom], 8);
				AddCallToken(playerid);
				format(string, sizeof(string), "%s has accepted your call. You are now in a direct call with them. (/h to hang up)", GetPlayerNameEx(playerid));
				SendClientMessageEx(Calls[callid][CallFrom], COLOR_WHITE, string);
				format(string, sizeof(string), "You have accepted %s's call. You are now in a direct call with them. (/h to hang up)", GetPlayerNameEx(Calls[callid][CallFrom]));
				SendClientMessageEx(playerid, COLOR_WHITE, string);
				Mobile[playerid] = Calls[callid][CallFrom];
				SetPlayerAttachedObject(playerid, 8, 330, 6);
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
				Mobile[Calls[callid][CallFrom]] = playerid;
				SetPlayerAttachedObject(Calls[callid][CallFrom], 8, 330, 6);
				SetPlayerSpecialAction(Calls[callid][CallFrom], SPECIAL_ACTION_USECELLPHONE);
				PlayerInfo[playerid][pCallsAccepted]++;
				GetPlayerPos(Calls[callid][CallFrom], Pos[0], Pos[1], Pos[2]);
				SetPlayerCheckpoint(playerid, Pos[0], Pos[1], Pos[2], 15.0);
				
				
				Calls[callid][RespondingID] = playerid;
				Calls[callid][BeingUsed] = 0;
				Calls[callid][TimeToExpire] = 0;
				strmid(Calls[callid][Area], "None", 0, 4, 4);
				strmid(Calls[callid][MainZone], "None", 0, 4, 4);
				strmid(Calls[callid][Description], "None", 0, 4, 4);
				DeletePVar(Calls[callid][CallFrom], "Has911Call");
				return 1;
			}
		}
		return SendClientMessageEx(playerid, COLOR_GREY, "   This call is not within your jurisdiction!");
	}
	return 1;
}

CMD:ic(playerid, params[])
{
	return cmd_ignorecall(playerid, params);
}

CMD:ignorecall(playerid, params[])
{
	if(0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS)
	{
		new string[128], callid;
		if(sscanf(params, "d", callid)) return SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /ic [call #]");

		if(callid < 0 || callid > 999) return SendClientMessageEx(playerid, COLOR_GREY, "   Call number cannot be below 0 or above 999!");
		if(Calls[callid][BeingUsed] == 0) return SendClientMessageEx(playerid, COLOR_GREY, "   There is no pending call with that number!");
		if(playerid == Calls[callid][CallFrom]) return SendClientMessageEx(playerid, COLOR_GREY, "   You can't drop your own call!");
		if((Calls[callid][Type] == 0 && !IsACop(playerid)) || (Calls[callid][Type] == 1 && !IsAMedic(playerid)) || (Calls[callid][Type] == 2 && !IsACop(playerid)) || (Calls[callid][Type] == 3 && !IsACop(playerid) && !IsATowman(playerid))) return SendClientMessageEx(playerid, COLOR_GREY, "   You cannot answer this call!");
		if(!IsPlayerConnected(Calls[callid][CallFrom]))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "   The caller has disconnected!");
			Calls[callid][CallFrom] = INVALID_PLAYER_ID;
			Calls[callid][BeingUsed] = 0;
			return 1;
		}
		for(new j; j < arrGroupData[PlayerInfo[playerid][pMember]][g_iJCount]; j++)
		{
			//foreach(new i: Player)
			for(new i = 0; i < MAX_PLAYERS; ++i)
			{
				if(IsPlayerConnected(i))
				{
					if(PlayerInfo[i][pMember] == PlayerInfo[playerid][pMember] && PlayerInfo[playerid][pRank] >= arrGroupData[PlayerInfo[playerid][pMember]][g_iRadioAccess]) {
						format(string, sizeof(string), "%s has dropped %s's call.", GetPlayerNameEx(playerid), GetPlayerNameEx(Calls[callid][CallFrom]));
						SendClientMessageEx(i, COLOR_DBLUE, string);
					}
					if(GetPVarInt(i, "BigEar") == 4 && GetPVarInt(i, "BigEarGroup") == PlayerInfo[playerid][pMember]) {
						format(string, sizeof(string), "(BE) %s has dropped %s's call.", GetPlayerNameEx(playerid), GetPlayerNameEx(Calls[callid][CallFrom]));
						SendClientMessageEx(i, COLOR_DBLUE, string);
					}
				}	
			}
			DeletePVar(Calls[callid][CallFrom], "Has911Call");
			Calls[callid][CallFrom] = INVALID_PLAYER_ID;
			Calls[callid][BeingUsed] = 0;
			Calls[callid][TimeToExpire] = 0;
			strmid(Calls[callid][Area], "None", 0, 4, 4);
			strmid(Calls[callid][MainZone], "None", 0, 4, 4);
			strmid(Calls[callid][Description], "None", 0, 4, 4);
			return 1;
		}
		return SendClientMessageEx(playerid, COLOR_GREY, "   This call is not within your jurisdiction!");
	}
	return 1;
}

CMD:cancelcall(playerid, params[])
{
    for(new i = 0; i < MAX_CALLS; i++)
	{
	    if(Calls[i][CallFrom] == playerid)
	    {
	        Calls[i][CallFrom] = INVALID_PLAYER_ID;
			Calls[i][BeingUsed] = 0;
			Calls[i][TimeToExpire] = 0;
			strmid(Calls[i][Area], "None", 0, 4, 4);
			strmid(Calls[i][MainZone], "None", 0, 4, 4);
			strmid(Calls[i][Description], "None", 0, 4, 4);
			DeletePVar(playerid, "Has911Call");
			return SendClientMessageEx(playerid, COLOR_WHITE, "You have dropped your 911 call." );
		}
	}
	SendClientMessageEx(playerid, COLOR_GRAD2, "You don't have any pending 911 calls.");
	return 1;
}

CMD:clearallcalls(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pFactionModerator] >= 1) {
        new string[128];
        ClearCalls();
        SendClientMessageEx(playerid,COLOR_GRAD1, "You have cleared all pending 911 calls.");
        format(string, sizeof(string), "AdmCmd: %s has cleared all pending 911 calls.", GetPlayerNameEx(playerid));
        ABroadCast(COLOR_LIGHTRED, string, 3);
    }
    else SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
    return 1;
}