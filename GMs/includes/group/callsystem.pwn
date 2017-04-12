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
					
	* Copyright (c) 2016, Next Generation Gaming, LLC
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

#include <YSI\y_hooks>

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	switch(dialogid) {

		case DIALOG_CALLS_MENU: {

			if(!response) return DeletePVar(playerid, "AC"), DeletePVar(playerid, "IC"), DeletePVar(playerid, "Calls"), 1;

			if(GetPVarType(playerid, "Calls")) {

				switch(listitem) {

					case 0: Calls_Group(playerid); 
					case 1: Calls_Business(playerid);
				}
				DeletePVar(playerid, "Calls");
				return 1;
			}

			SetPVarInt(playerid, "CALL_CHOICE", listitem);
			ShowPlayerDialogEx(playerid, DIALOG_CALLS_MENU2, DIALOG_STYLE_INPUT, "Calls | Specify ID", "Please specify the caller ID (seen in /ac)", "Select", "Cancel");
		}
		case DIALOG_CALLS_MENU2: {

			if(response) {

				switch(GetPVarInt(playerid, "CALL_CHOICE")) {

					case 0: {

						if(GetPVarType(playerid, "AC")) AcceptCall_Group(playerid, strval(inputtext));
						if(GetPVarType(playerid, "IC")) IgnoreCall_Group(playerid, strval(inputtext));

					}
					case 1: {

						if(GetPVarType(playerid, "AC")) AcceptCall_Business(playerid, strval(inputtext));
						if(GetPVarType(playerid, "IC")) IgnoreCall_Business(playerid, strval(inputtext));

					}
				}
			}

			DeletePVar(playerid, "AC");
			DeletePVar(playerid, "IC");
			DeletePVar(playerid, "CALL_CHOICE");
		}
	}
	return 0;
}

stock SendCallToQueue(callfrom, description[], area[], mainzone[], type, vehicleid = INVALID_VEHICLE_ID)
{
    new newid = INVALID_CALL_ID;

	for(new i; i < MAX_CALLS; i++)
	{
		if(Calls[i][HasBeenUsed] == 0)
		{
			newid = i;
			break;
		}
    }
    if(newid != INVALID_CALL_ID)
    {
		foreach(new i: Player)
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
							format(szMiscArray, sizeof(szMiscArray), "HQ: All Units APB: Reporter: %s", GetPlayerNameEx(callfrom));
							SendClientMessageEx(i, TEAM_BLUE_COLOR, szMiscArray);
							format(szMiscArray, sizeof(szMiscArray), "HQ: Location: %s, Description: %s", area, description);
							SendClientMessageEx(i, TEAM_BLUE_COLOR, szMiscArray);
						}
						if(type == 1 && IsAMedic(i))
						{
							PlayCrimeReportForPlayer(i, callfrom, 7);
							format(szMiscArray, sizeof(szMiscArray), "HQ: All Units APB: Reporter: %s", GetPlayerNameEx(callfrom));
							SendClientMessageEx(i, TEAM_BLUE_COLOR, szMiscArray);
							format(szMiscArray, sizeof(szMiscArray), "HQ: Location: %s, Description: %s", area, description);
							SendClientMessageEx(i, TEAM_BLUE_COLOR, szMiscArray);
						}
						if(type == 2 && IsACop(i))
						{
							PlayCrimeReportForPlayer(i, callfrom, 7);
							format(szMiscArray, sizeof(szMiscArray), "HQ: All Units APB: Reporter: %s", GetPlayerNameEx(callfrom));
							SendClientMessageEx(i, TEAM_BLUE_COLOR, szMiscArray);
							format(szMiscArray, sizeof(szMiscArray), "HQ: Location: %s, Description: %s", area, description);
							SendClientMessageEx(i, TEAM_BLUE_COLOR, szMiscArray);
						}
						if(type == 3 && (IsACop(i) || IsATowman(i)))
						{
							PlayCrimeReportForPlayer(i, callfrom, 7);
							format(szMiscArray, sizeof(szMiscArray), "HQ: All Units APB: Reporter: %s", GetPlayerNameEx(callfrom));
							SendClientMessageEx(i, TEAM_BLUE_COLOR, szMiscArray);
							format(szMiscArray, sizeof(szMiscArray), "HQ: Location: %s, Description: %s", area, description);
							SendClientMessageEx(i, TEAM_BLUE_COLOR, szMiscArray);
						}
						if(type == 5 && (IsACop(i) || IsAMedic(i)))
						{
							PlayCrimeReportForPlayer(i, callfrom, 7);
							format(szMiscArray, sizeof(szMiscArray), "HQ: All Units APB: Reporter: %s", GetPlayerNameEx(callfrom));
							SendClientMessageEx(i, TEAM_BLUE_COLOR, szMiscArray);
							format(szMiscArray, sizeof(szMiscArray), "HQ: Location: %s, Description: %s", area, description);
							SendClientMessageEx(i, TEAM_BLUE_COLOR, szMiscArray);
						}
					}
				}
				if(type == 6)
				{
					new x = GetPVarInt(callfrom, "GRPCALL");
					Calls[newid][c_iGroupID] = x;

					if(PlayerInfo[i][pMember] == x) {

						format(szMiscArray, sizeof(szMiscArray), "Landline: Caller: %s | %d", GetPlayerNameEx(callfrom), PlayerInfo[callfrom][pPnumber]);
						SendClientMessageEx(i, COLOR_PINK, szMiscArray);
						format(szMiscArray, sizeof(szMiscArray), "Landline: Location: %s, Description: %s", area, description);
						SendClientMessageEx(i, COLOR_PINK, szMiscArray);
					}
				}
				if(type == 7)
				{
					new x = GetPVarInt(callfrom, "BUSICALL");
					Calls[newid][c_iBusinessID] = x;

					if(PlayerInfo[i][pBusiness] == x) {

						format(szMiscArray, sizeof(szMiscArray), "Landline: Caller: %s | %d", GetPlayerNameEx(callfrom), PlayerInfo[callfrom][pPnumber]);
						SendClientMessageEx(i, COLOR_PINK, szMiscArray);
						format(szMiscArray, sizeof(szMiscArray), "Landline: Location: %s, Description: %s", area, description);
						SendClientMessageEx(i, COLOR_PINK, szMiscArray);
						
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
		mysql_format(MainPipeline, query, sizeof(query), "INSERT INTO `911Calls` (Caller, Phone, Area, MainZone, Description, Type, Time) VALUES ('%s', %d, '%e', '%s', '%e', %d, UNIX_TIMESTAMP())", GetPlayerNameEx(callfrom), PlayerInfo[callfrom][pPnumber], area, mainzone, description, type);
		mysql_tquery(MainPipeline, query, "OnQueryFinish", "i", SENDDATA_THREAD);
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
		Calls[i][c_iGroupID] = INVALID_GROUP_ID;
		Calls[i][c_iBusinessID] = INVALID_BUSINESS_ID;
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

Calls_Group(playerid) {

	if(0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS)
	{
		new iGroupID = PlayerInfo[playerid][pMember];

		switch(arrGroupData[iGroupID][g_iGroupType]) {

			case GROUP_TYPE_NEWS: SendClientMessageEx(playerid, arrGroupData[iGroupID][g_hDutyColour] * 256 + 170, "____________________ HOTLINE ____________________");
			default: SendClientMessageEx(playerid, arrGroupData[iGroupID][g_hDutyColour] * 256 + 170, "____________________ LANDLINE ____________________");
		}
		for(new i = 999; i >= 0; i--)
		{
			if(Calls[i][BeingUsed] == 1)
			{
				if(Calls[i][Type] == 6 && Calls[i][c_iGroupID] == iGroupID)	{
					
					format(szMiscArray, sizeof(szMiscArray), "%s | Call #%i | Description: %s | Location: %s | Pending: %d minutes", GetPlayerNameEx(Calls[i][CallFrom]), i, Calls[i][Description], Calls[i][Area], Calls[i][TimeToExpire]);
					SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
				}
				else {

					for(new j; j < arrGroupData[PlayerInfo[playerid][pMember]][g_iJCount]; j++)
					{
						if(strcmp(arrGroupJurisdictions[PlayerInfo[playerid][pMember]][j][g_iAreaName], Calls[i][Area], true) == 0 || strcmp(arrGroupJurisdictions[PlayerInfo[playerid][pMember]][j][g_iAreaName], Calls[i][MainZone], true) == 0 || (!strcmp(arrGroupJurisdictions[PlayerInfo[playerid][pMember]][j][g_iAreaName], gMainZones[9][SAZONE_NAME], true) && strcmp(Calls[i][MainZone], gMainZones[3][SAZONE_NAME], true) == -1))
						{
							if(Calls[i][Type] == 0 && IsACop(playerid))
							{
								format(szMiscArray, sizeof(szMiscArray), "[EMERGENCY] %s | Call #%i | Description: %s | 10-20: %s | Pending: %d minutes", GetPlayerNameEx(Calls[i][CallFrom]), i, Calls[i][Description], Calls[i][Area], Calls[i][TimeToExpire]);
								SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
							}
							else if(Calls[i][Type] == 1 && IsAMedic(playerid))
							{
								format(szMiscArray, sizeof(szMiscArray), "%s | Call #%i | Description: %s | 10-20: %s | Pending: %d minutes", GetPlayerNameEx(Calls[i][CallFrom]), i, Calls[i][Description], Calls[i][Area], Calls[i][TimeToExpire]);
								SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
							}
							else if(Calls[i][Type] == 2 && IsACop(playerid))
							{
								format(szMiscArray, sizeof(szMiscArray), "%s | Call #%i | Description: %s | 10-20: %s | Pending: %d minutes", GetPlayerNameEx(Calls[i][CallFrom]), i, Calls[i][Description], Calls[i][Area], Calls[i][TimeToExpire]);
								SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
							}
							else if(Calls[i][Type] == 3 && (IsATowman(playerid)))
							{
								format(szMiscArray, sizeof(szMiscArray), "[TOWING] %s | Call #%i | Description: %s | 10-20: %s | Pending: %d minutes", GetPlayerNameEx(Calls[i][CallFrom]), i, Calls[i][Description], Calls[i][Area], Calls[i][TimeToExpire]);
								SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
							}
							else if(Calls[i][Type] == 4 && IsACop(playerid))
							{
								format(szMiscArray, sizeof(szMiscArray), "%s | Call #%i | Description: %s | 10-20: %s | Pending: %d minutes", GetPlayerNameEx(Calls[i][CallFrom]), i, Calls[i][Description], Calls[i][Area], Calls[i][TimeToExpire]);
								SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
							}
							else if(Calls[i][Type] == 5 && (IsACop(playerid) || IsAMedic(playerid)))
							{
								format(szMiscArray, sizeof(szMiscArray), "%s | Call #%i | Description: %s | 10-20: %s | Pending: %d minutes", GetPlayerNameEx(Calls[i][CallFrom]), i, Calls[i][Description], Calls[i][Area], Calls[i][TimeToExpire]);
								SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
							}
						}
					}
				}
			}
		}
		SendClientMessageEx(playerid, arrGroupData[iGroupID][g_hDutyColour] * 256 + 170, "___________________________________________________");
	}
}

Calls_Business(playerid) {

	if(PlayerInfo[playerid][pBusiness] != INVALID_BUSINESS_ID)
	{

		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "____________________ COMPANY LINE ____________________");
		for(new i = 999; i >= 0; i--)
		{
			if(Calls[i][BeingUsed] == 1)
			{
				if(Calls[i][Type] == 7 && Calls[i][c_iBusinessID] == PlayerInfo[playerid][pBusiness])
				{
					format(szMiscArray, sizeof(szMiscArray), "%s | Call #%i | Description: %s | Location: %s | Pending: %d minutes", GetPlayerNameEx(Calls[i][CallFrom]), i, Calls[i][Description], Calls[i][Area], Calls[i][TimeToExpire]);
					SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
				}
			}
		}
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "___________________________________________________");
	}
}

CMD:calls(playerid, params[])
{
	
	if(PlayerInfo[playerid][pBusiness] == INVALID_BUSINESS_ID && PlayerInfo[playerid][pMember] == INVALID_GROUP_ID) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot use this feature.");
	SetPVarInt(playerid, "Calls", 1);
	ShowPlayerDialogEx(playerid, DIALOG_CALLS_MENU, DIALOG_STYLE_LIST, "Landline Calls", "Group\nBusiness", "Select", "Cancel");
	return 1;
}

CMD:ac(playerid, params[])
{
	return cmd_acceptcall(playerid, params);
}


AcceptCall_Group(playerid, callid) {

	if(0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS)
	{
		new string[128];

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
				foreach(new i: Player)
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

AcceptCall_Business(playerid, callid) {

	if(0 <= PlayerInfo[playerid][pBusiness] < MAX_BUSINESSES) {
			
		if(callid < 0 || callid > 999) return SendClientMessageEx(playerid, COLOR_GREY, "   Call number cannot be below 0 or above 999!");
		if(Calls[callid][BeingUsed] == 0) return SendClientMessageEx(playerid, COLOR_GREY, "   There is no pending call with that number!");
		if(playerid == Calls[callid][CallFrom]) return SendClientMessageEx(playerid, COLOR_GREY, "   You can't accept your own call!");
		if(Calls[callid][Type] != 7) return SendClientMessageEx(playerid, COLOR_GREY, "   You cannot answer this call!");
		if(!IsPlayerConnected(Calls[callid][CallFrom]))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "   The caller has disconnected!");
			Calls[callid][CallFrom] = INVALID_PLAYER_ID;
			Calls[callid][BeingUsed] = 0;
			return 1;
		}

		foreach(new i: Player)
		{
			if(PlayerInfo[i][pMember] == PlayerInfo[playerid][pMember] && PlayerInfo[playerid][pRank] >= arrGroupData[PlayerInfo[playerid][pMember]][g_iRadioAccess]) {
				format(szMiscArray, sizeof(szMiscArray), "%s has accepted %s's call from %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(Calls[callid][CallFrom]), Calls[callid][Area]);
				SendClientMessageEx(i, COLOR_DBLUE, szMiscArray);
			}
			if(GetPVarInt(i, "BigEar") == 4 && GetPVarInt(i, "BigEarGroup") == PlayerInfo[playerid][pMember]) {
				format(szMiscArray, sizeof(szMiscArray), "(BE) %s has accepted %s's call from %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(Calls[callid][CallFrom]), Calls[callid][Area]);
				SendClientMessageEx(i, COLOR_DBLUE, szMiscArray);
			}
		}

		new Float: fPos[3];
		PlayCrimeReportForPlayer(playerid, Calls[callid][CallFrom], 8);
		AddCallToken(playerid);
		format(szMiscArray, sizeof(szMiscArray), "%s has accepted your call. You are now in a direct call with them. (/h to hang up)", GetPlayerNameEx(playerid));
		SendClientMessageEx(Calls[callid][CallFrom], COLOR_WHITE, szMiscArray);
		format(szMiscArray, sizeof(szMiscArray), "You have accepted %s's call. You are now in a direct call with them. (/h to hang up)", GetPlayerNameEx(Calls[callid][CallFrom]));
		SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
		Mobile[playerid] = Calls[callid][CallFrom];
		SetPlayerAttachedObject(playerid, 8, 330, 6);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
		Mobile[Calls[callid][CallFrom]] = playerid;
		SetPlayerAttachedObject(Calls[callid][CallFrom], 8, 330, 6);
		SetPlayerSpecialAction(Calls[callid][CallFrom], SPECIAL_ACTION_USECELLPHONE);
		PlayerInfo[playerid][pCallsAccepted]++;
		GetPlayerPos(Calls[callid][CallFrom], fPos[0], fPos[1], fPos[2]);
		SetPlayerCheckpoint(playerid, fPos[0], fPos[1], fPos[2], 15.0);
		
		
		Calls[callid][RespondingID] = playerid;
		Calls[callid][BeingUsed] = 0;
		Calls[callid][TimeToExpire] = 0;
		strmid(Calls[callid][Area], "None", 0, 4, 4);
		strmid(Calls[callid][MainZone], "None", 0, 4, 4);
		strmid(Calls[callid][Description], "None", 0, 4, 4);
		DeletePVar(Calls[callid][CallFrom], "Has911Call");

	}
	return 1;
}

IgnoreCall_Group(playerid, callid) {

	if(0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS)
	{
		new string[128];

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
			foreach(new i: Player)
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

IgnoreCall_Business(playerid, callid) {

	if(0 <= PlayerInfo[playerid][pBusiness] < MAX_BUSINESSES)
	{
		new string[128];

		if(callid < 0 || callid > 999) return SendClientMessageEx(playerid, COLOR_GREY, "   Call number cannot be below 0 or above 999!");
		if(Calls[callid][BeingUsed] == 0) return SendClientMessageEx(playerid, COLOR_GREY, "   There is no pending call with that number!");
		if(playerid == Calls[callid][CallFrom]) return SendClientMessageEx(playerid, COLOR_GREY, "   You can't drop your own call!");
		if(Calls[callid][Type] != 7) return SendClientMessageEx(playerid, COLOR_GREY, "   You cannot ignore this call!");
		if(!IsPlayerConnected(Calls[callid][CallFrom]))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "   The caller has disconnected!");
			Calls[callid][CallFrom] = INVALID_PLAYER_ID;
			Calls[callid][BeingUsed] = 0;
			return 1;
		}
		for(new j; j < arrGroupData[PlayerInfo[playerid][pMember]][g_iJCount]; j++)
		{
			foreach(new i: Player)
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


CMD:acceptcall(playerid, params[])
{	
	if(PlayerInfo[playerid][pBusiness] == INVALID_BUSINESS_ID && PlayerInfo[playerid][pMember] == INVALID_GROUP_ID) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot use this feature.");
	SetPVarInt(playerid, "AC", 1);
	ShowPlayerDialogEx(playerid, DIALOG_CALLS_MENU, DIALOG_STYLE_LIST, "Landline Calls", "Group\nBusiness", "Select", "Cancel");
	return 1;
}

CMD:ic(playerid, params[])
{
	return cmd_ignorecall(playerid, params);
}

CMD:ignorecall(playerid, params[])
{
	if(PlayerInfo[playerid][pBusiness] == INVALID_BUSINESS_ID && PlayerInfo[playerid][pMember] == INVALID_GROUP_ID) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot use this feature.");
	SetPVarInt(playerid, "IC", 1);
	ShowPlayerDialogEx(playerid, DIALOG_CALLS_MENU, DIALOG_STYLE_LIST, "Landline Calls", "Group\nBusiness", "Select", "Cancel");
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
			return SendClientMessageEx(playerid, COLOR_WHITE, "You have dropped your call." );
		}
	}
	SendClientMessageEx(playerid, COLOR_GRAD2, "You don't have any pending calls.");
	return 1;
}

CMD:clearallcalls(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1 || PlayerInfo[playerid][pFactionModerator] >= 1) {
        new string[128];
        ClearCalls();
        SendClientMessageEx(playerid,COLOR_GRAD1, "You have cleared all pending calls.");
        format(string, sizeof(string), "AdmCmd: %s has cleared all pending calls.", GetPlayerNameEx(playerid));
        ABroadCast(COLOR_LIGHTRED, string, 3);
    }
    else SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
    return 1;
}