/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

					Dynamic Gates System

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

CMD:gate(playerid, params[])
{
	new Float:X, Float:Y, Float:Z;
	for(new i = 0; i < sizeof(GateInfo); i++)
	{
		GetDynamicObjectPos(GateInfo[i][gGATE], X, Y, Z);
		if(GateInfo[i][gGroupID] != -1 && (0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS) && PlayerInfo[playerid][pMember] == GateInfo[i][gGroupID] && IsPlayerInRangeOfPoint(playerid,GateInfo[i][gRange], X, Y, Z) && GetPlayerVirtualWorld(playerid) == GateInfo[i][gVW] && GetPlayerInterior(playerid) == GateInfo[i][gInt])
		{
			if(GateInfo[i][gLocked] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "This gate is currently locked.");
			if(GateInfo[i][gAutomate] == 1) return 1;
			MoveGate(playerid, i);
		}
		else if(GateInfo[i][gAllegiance] != 0 && GateInfo[i][gGroupType] != 0 && (0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS) && arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance] == GateInfo[i][gAllegiance] && arrGroupData[PlayerInfo[playerid][pMember]][g_iGroupType] == GateInfo[i][gGroupType] && IsPlayerInRangeOfPoint(playerid,GateInfo[i][gRange], X, Y, Z) && GetPlayerVirtualWorld(playerid) == GateInfo[i][gVW] && GetPlayerInterior(playerid) == GateInfo[i][gInt])
		{
			if(GateInfo[i][gLocked] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "This gate is currently locked.");
			if(GateInfo[i][gAutomate] == 1) return 1;
			MoveGate(playerid, i);
		}
		else if(GateInfo[i][gAllegiance] != 0 && GateInfo[i][gGroupType] == 0 && (0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS) && arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance] == GateInfo[i][gAllegiance] && IsPlayerInRangeOfPoint(playerid,GateInfo[i][gRange], X, Y, Z) && GetPlayerVirtualWorld(playerid) == GateInfo[i][gVW] && GetPlayerInterior(playerid) == GateInfo[i][gInt])
		{
			if(GateInfo[i][gLocked] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "This gate is currently locked.");
			if(GateInfo[i][gAutomate] == 1) return 1;
			MoveGate(playerid, i);
		}
		else if(GateInfo[i][gAllegiance] == 0 && GateInfo[i][gGroupType] != 0 && (0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS) && arrGroupData[PlayerInfo[playerid][pMember]][g_iGroupType] == GateInfo[i][gGroupType] && IsPlayerInRangeOfPoint(playerid,GateInfo[i][gRange], X, Y, Z) && GetPlayerVirtualWorld(playerid) == GateInfo[i][gVW] && GetPlayerInterior(playerid) == GateInfo[i][gInt])
		{
			if(GateInfo[i][gLocked] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "This gate is currently locked.");
			if(GateInfo[i][gAutomate] == 1) return 1;
			MoveGate(playerid, i);
		}
	}
    return 1;
}

CMD:agate(playerid, params[])
{
	new Float:X, Float:Y, Float:Z;
	for(new i = 0; i < sizeof(GateInfo); i++)
	{
		GetDynamicObjectPos(GateInfo[i][gGATE], X, Y, Z);
		if(IsPlayerInRangeOfPoint(playerid, 15, X, Y, Z) && PlayerInfo[playerid][pAdmin] >= 2)
		{
			MoveGate(playerid, i);
		}
	}
	return 1;
}

/*
CMD:citylockdown(playerid, params[])
{
	for(new i = 0; i < sizeof(GateInfo); i++)
	{
		if((0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS) && arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance] == GateInfo[i][gAllegiance] && GateInfo[i][gLocked] != 1 && arrGroupData[PlayerInfo[playerid][pMember]][g_iTollLockdown] >= PlayerInfo[playerid][pRank])
		{
			MoveGate(playerid, i);
		}
	}
}*/

CMD:gsave(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1 || PlayerInfo[playerid][pShopTech] >= 1)
	{
        SendClientMessageEx(playerid, COLOR_YELLOW, "You have force saved the Gate database.");
        SaveGates();
    }
    else
	{
        SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
    }
    return 1;
}

CMD:hgate(playerid, params[])
{
	return cmd_movegate(playerid, params);
}

CMD:movegate(playerid, params[])
{
	if(isnull(params)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /movegate [pass]");
	new Float:X, Float:Y, Float:Z;
	for(new i = 0; i < sizeof(GateInfo); i++)
	{
		GetDynamicObjectPos(GateInfo[i][gGATE], X, Y, Z);
		if(GateInfo[i][gGroupID] == -1 && IsPlayerInRangeOfPoint(playerid,GateInfo[i][gRange], X, Y, Z) && GetPlayerVirtualWorld(playerid) == GateInfo[i][gVW])
		{
			if(GateInfo[i][gLocked] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "This gate is currently locked.");
			if(GateInfo[i][gAutomate] == 1) return 1;
			if(strcmp(params, GateInfo[i][gPass], true) == 0)
			{
				if(GateInfo[i][gStatus] == 0)
				{
					MoveDynamicObject(GateInfo[i][gGATE], GateInfo[i][gPosXM], GateInfo[i][gPosYM], GateInfo[i][gPosZM], GateInfo[i][gSpeed], GateInfo[i][gRotXM], GateInfo[i][gRotYM], GateInfo[i][gRotZM]);
					GateInfo[i][gStatus] = 1;
					if(GateInfo[i][gTimer] != 0)
					{
						switch(GateInfo[i][gTimer])
						{
							case 1: SetTimerEx("MoveTimerGate", 3000, false, "i", i);
							case 2: SetTimerEx("MoveTimerGate", 5000, false, "i", i);
							case 3: SetTimerEx("MoveTimerGate", 7000, false, "i", i);
							case 4: SetTimerEx("MoveTimerGate", 10000, false, "i", i);
						}
					}
				}
				else if(GateInfo[i][gStatus] == 1 && GateInfo[i][gTimer] == 0)
				{
					MoveDynamicObject(GateInfo[i][gGATE], GateInfo[i][gPosX], GateInfo[i][gPosY], GateInfo[i][gPosZ], GateInfo[i][gSpeed], GateInfo[i][gRotX], GateInfo[i][gRotY], GateInfo[i][gRotZ]);
					GateInfo[i][gStatus] = 0;
				}
			}
		}
	}
	return 1;
}

CMD:admingatepw(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1 || PlayerInfo[playerid][pShopTech] >= 1)
	{
		new string[128], gateid, pass[24];
		if(sscanf(params, "ds[24]", gateid, pass)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /admingatepw [gateid] [pass]");

		if(strlen(pass) > 24)
		{
			SendClientMessageEx(playerid, COLOR_GRAD2, " Must be 24 characters or less! ");
			return 1;
		}
		format(string, sizeof(string), "Gate Password for gate %d changed to %s", gateid, pass);
		format(GateInfo[gateid][gPass], 24, "%s", pass);
		SendClientMessageEx(playerid, COLOR_GRAD2, string);
		SaveGate(gateid);
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
		return 1;
	}
	return 1;
}

CMD:housegatepw(playerid, params[])
{
	SendClientMessageEx(playerid, COLOR_GREY, "/housegatepw has been changed to /setgatepass!");
	return 1;
}

CMD:setgatepass(playerid, params[])
{
	new Float:X, Float:Y, Float:Z, string[128];
	if(Homes[playerid] == 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "You don't own a home!");
	if(isnull(params)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /setgatepass [pass]");
	if(strlen(params) > 24) return SendClientMessageEx(playerid, COLOR_GRAD2, " Must be 24 characters or less! ");

	for(new i = 0; i < sizeof(GateInfo); i++)
	{
		GetDynamicObjectPos(GateInfo[i][gGATE], X, Y, Z);
		if(IsPlayerInRangeOfPoint(playerid, GateInfo[i][gRange], X, Y, Z))
		{
			if(GateInfo[i][gHID] != -1 && GetPlayerSQLId(playerid) == HouseInfo[GateInfo[i][gHID]][hOwnerID] && GateInfo[i][gGroupID] == INVALID_GROUP_ID)
			{
				format(GateInfo[i][gPass], 24, "%s", params);
				SaveGate(i);
				format(string, sizeof(string), "House Gate Password for gate %d changed to: %s", i, params);
				return SendClientMessageEx(playerid, COLOR_GRAD2, string);
			}
		}
	}
	SendClientMessageEx(playerid, COLOR_WHITE, "* You're not near a gate that you own!");
	return 1;
}

CMD:lockgate(playerid, params[])
{
	new Float:X, Float:Y, Float:Z, string[56];
    for(new i = 0; i < sizeof(GateInfo); i++)
	{
		GetDynamicObjectPos(GateInfo[i][gGATE], X, Y, Z);
		if(IsPlayerInRangeOfPoint(playerid, GateInfo[i][gRange], X, Y, Z) && GetPlayerVirtualWorld(playerid) == GateInfo[i][gVW])
		{
			if(GateInfo[i][gGroupID] == INVALID_GROUP_ID)
			{
				if(GateInfo[i][gHID] != -1 && GetPlayerSQLId(playerid) == HouseInfo[GateInfo[i][gHID]][hOwnerID])
				{
					if(GateInfo[i][gLocked] == 0)
					{
						GateInfo[i][gLocked] = 1;
						format(string, sizeof(string), "* %s has locked their gate.", GetPlayerNameEx(playerid));
						ProxDetector(GateInfo[i][gRange], playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
					}
					else
					{
						GateInfo[i][gLocked] = 0;
						format(string, sizeof(string), "* %s has unlocked their gate.", GetPlayerNameEx(playerid));
						ProxDetector(GateInfo[i][gRange], playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
					}
				}
			}
			else if(GateInfo[i][gGroupID] != INVALID_GROUP_ID)
			{
				if(PlayerInfo[playerid][pLeader] == GateInfo[i][gGroupID])
				{
					if(GateInfo[i][gLocked] == 0)
					{
						GateInfo[i][gLocked] = 1;
						format(string, sizeof(string), "* %s has locked the gate.", GetPlayerNameEx(playerid));
						ProxDetector(GateInfo[i][gRange], playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
					}
					else
					{
						GateInfo[i][gLocked] = 0;
						format(string, sizeof(string), "* %s has unlocked the gate.", GetPlayerNameEx(playerid));
						ProxDetector(GateInfo[i][gRange], playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
					}
				}
			}
			else if(GateInfo[i][gGroupType] != 0)
			{
				if(PlayerInfo[playerid][pFactionModerator] >= 1)
				{
					if(GateInfo[i][gLocked] == 0)
					{
						GateInfo[i][gLocked] = 1;
						format(string, sizeof(string), "* %s has locked the gate.", GetPlayerNameEx(playerid));
						ProxDetector(GateInfo[i][gRange], playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
						format(string, sizeof(string), "%s(%d) has locked gate ID %d.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), i);
						Log("logs/gedit.log", string);
					}
					else
					{
						GateInfo[i][gLocked] = 0;
						format(string, sizeof(string), "* %s has unlocked the gate.", GetPlayerNameEx(playerid));
						ProxDetector(GateInfo[i][gRange], playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);

						format(string, sizeof(string), "%s(%d) has locked gate ID %d.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), i);
						Log("logs/gedit.log", string);
					}
				}
			}
		}
	}
	return 1;
}

CMD:gotogate(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1 || PlayerInfo[playerid][pShopTech] >= 1)
	{
		new string[48], gatenum;
		if(sscanf(params, "d", gatenum)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /gotogate [gatenumber]");

		if(gatenum <= 0 || gatenum >= MAX_GATES)
		{
			format(string, sizeof(string), "Gate ID must be between 1 and %d.", MAX_GATES - 1);
			return SendClientMessageEx(playerid, COLOR_GREY, string);
		}

		SetPlayerPos(playerid,GateInfo[gatenum][gPosX],GateInfo[gatenum][gPosY],GateInfo[gatenum][gPosZ] + 1);
		GameTextForPlayer(playerid, "~w~Teleporting", 5000, 1);
		SetPlayerInterior(playerid, GateInfo[gatenum][gInt]);
		PlayerInfo[playerid][pInt] = GateInfo[gatenum][gInt];
		SetPlayerVirtualWorld(playerid,  GateInfo[gatenum][gVW]);
		PlayerInfo[playerid][pVW] =  GateInfo[gatenum][gVW];
	}
	return 1;
}

CMD:gstatus(playerid, params[])
{
	new gateid;
	if(sscanf(params, "i", gateid))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /gstatus [gateid]");
		return 1;
	}
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1 || PlayerInfo[playerid][pShopTech] >= 1)
	{
		new string[128], timertxt, distancetxt;

		switch(GateInfo[gateid][gTimer])
		{
			case 1: timertxt = 1;
			case 2: timertxt = 3;
			case 3: timertxt = 5;
			case 4: timertxt = 10;
			default: timertxt = 0;
		}
		switch(GateInfo[gateid][gRenderHQ])
		{
			case 1: distancetxt = 100;
			case 2: distancetxt = 150;
			case 3: distancetxt = 200;
			default: distancetxt = 60;
		}

		format(string,sizeof(string),"|___________ Gate Status (ID: %d) ___________|", gateid);
		SendClientMessageEx(playerid, COLOR_GREEN, string);
		format(string, sizeof(string), "X: %f | Y: %f | Z: %f | RotX: %f | RotY: %f | RotZ: %f", GateInfo[gateid][gPosX], GateInfo[gateid][gPosY], GateInfo[gateid][gPosZ], GateInfo[gateid][gRotX], GateInfo[gateid][gRotY], GateInfo[gateid][gRotZ]);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "XM: %f | YM: %f | ZM: %f | RotXM: %f | RotYM: %f | RotZM: %f", GateInfo[gateid][gPosXM], GateInfo[gateid][gPosYM], GateInfo[gateid][gPosZM], GateInfo[gateid][gRotXM], GateInfo[gateid][gRotYM], GateInfo[gateid][gRotZM]);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "Model: %d | HID: %d | VW: %d | Int: %d | Allegiance: %d | Group Type: %d | Group: %d", GateInfo[gateid][gModel], GateInfo[gateid][gHID], GateInfo[gateid][gVW], GateInfo[gateid][gInt], GateInfo[gateid][gAllegiance], GateInfo[gateid][gGroupType], GateInfo[gateid][gGroupID]);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "Range: %.3f | Speed: %.3f | Timer: %d second(s) | Stream: %d | Automated: %d | Locked: %d | Pass: %s", GateInfo[gateid][gRange], GateInfo[gateid][gSpeed], timertxt, distancetxt, GateInfo[gateid][gAutomate], GateInfo[gateid][gLocked], GateInfo[gateid][gPass]);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "Assigned Facility: %d", GateInfo[gateid][gFacility]);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		if(GateInfo[gateid][gTModel] != INVALID_OBJECT_ID)
		{
			format(string, sizeof(string), "Texture Replacement - Index: %d | Model: %d | TXD File: %s | Texture: %s | Color: %x", GateInfo[gateid][gTIndex], GateInfo[gateid][gTModel], GateInfo[gateid][gTTXD], GateInfo[gateid][gTTexture], GateInfo[gateid][gTColor]);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
		}
	}
	else SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	return 1;
}

CMD:gnear(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1 || PlayerInfo[playerid][pShopTech] >= 1)
	{
		new option;
		if(!sscanf(params, "d", option))
		{
			new string[64];
			format(string, sizeof(string), "* Listing all gates within 30 meters of you in VW %d...", option);
			SendClientMessageEx(playerid, COLOR_RED, string);
			for(new i, Float: fGatePos[3], szMessage[48]; i < MAX_GATES; i++)
			{
				GetDynamicObjectPos(GateInfo[i][gGATE], fGatePos[0], fGatePos[1], fGatePos[2]);
				if(option == -1)
				{
					if(IsPlayerInRangeOfPoint(playerid, 30, fGatePos[0], fGatePos[1], fGatePos[2]))
					{
						if(GateInfo[i][gModel] != 0 && GateInfo[i][gModel] != 18631)
						{
							format(szMessage, sizeof(szMessage), "Gate ID %d (VW: %d) | %f from you", i, GateInfo[i][gVW], GetPlayerDistanceFromPoint(playerid, fGatePos[0], fGatePos[1], fGatePos[2]));
							SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
						}
					}
				}
				else
				{
					if(IsPlayerInRangeOfPoint(playerid, 30, fGatePos[0], fGatePos[1], fGatePos[2]) && GateInfo[i][gVW] == option)
					{
						if(GateInfo[i][gModel] != 0 && GateInfo[i][gModel] != 18631)
						{
							format(szMessage, sizeof(szMessage), "Gate ID %d (VW: %d) | %f from you", i, GateInfo[i][gVW], GetPlayerDistanceFromPoint(playerid, fGatePos[0], fGatePos[1], fGatePos[2]));
							SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
						}
					}
				}
			}
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_RED, "* Listing all gates within 30 meters of you...");
			for(new i, Float: fGatePos[3], szMessage[48]; i < MAX_GATES; i++)
			{
				GetDynamicObjectPos(GateInfo[i][gGATE], fGatePos[0], fGatePos[1], fGatePos[2]);
				if(IsPlayerInRangeOfPoint(playerid, 30, fGatePos[0], fGatePos[1], fGatePos[2]) && GateInfo[i][gVW] == GetPlayerVirtualWorld(playerid))
				{
					if(GateInfo[i][gModel] != 0 && GateInfo[i][gModel] != 18631)
					{
						format(szMessage, sizeof(szMessage), "Gate ID %d (VW: %d) | %f from you", i, GateInfo[i][gVW], GetPlayerDistanceFromPoint(playerid, fGatePos[0], fGatePos[1], fGatePos[2]));
						SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
					}
				}
			}
		}
	}
	else
	{
	    SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use that command.");
	}
	return 1;
}

CMD:gnext(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1 || PlayerInfo[playerid][pShopTech] >= 1)
	{
		SendClientMessageEx(playerid, COLOR_RED, "* Listing next available gate...");
		for(new x;x<MAX_GATES;x++)
		{
		    if(GateInfo[x][gModel] == 0)
		    {
		        new string[128];
		        format(string, sizeof(string), "%d is available to use.", x);
		        SendClientMessageEx(playerid, COLOR_WHITE, string);
		        break;
			}
		}
	}
	else
	{
	    SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use that command.");
		return 1;
	}
	return 1;
}

CMD:gedit(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1 || PlayerInfo[playerid][pShopTech] >= 1)
	{
		new x_job[128], gateid, Float:ofloat, string[128];

		if(sscanf(params, "s[128]iF", x_job, gateid, ofloat))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /gedit [name] [gateid] [value]");
			SendClientMessageEx(playerid, COLOR_GREY, "Available names: HID, Model, VW, Int, Open, Closed, PosX(M), PosY(M), PosZ(M), RotX(M), RotZ(M), ToMe(M)");
			SendClientMessageEx(playerid, COLOR_GREY, "Available names: Range, Speed, Allegiance, GroupType, GroupID, Stream, Timer, Facility");
			return 1;
		}

		if(strcmp(x_job, "hid", true) == 0)
		{
			new value = floatround(ofloat, floatround_round);
		    if(value > MAX_HOUSES) return SendClientMessageEx(playerid, COLOR_WHITE, "* Invalid House ID!");
		    GateInfo[gateid][gHID] = value;
		    format(string, sizeof(string), "HID %d assigned to Gate %d", GateInfo[gateid][gHID], gateid);
		    SendClientMessageEx(playerid, COLOR_WHITE, string);
		    SaveGate(gateid);

		    format(string, sizeof(string), "%s has edited GateID %d's House ID to %d.", GetPlayerNameEx(playerid), gateid, value);
		    Log("logs/gedit.log", string);
		}
		else if(strcmp(x_job, "model", true) == 0)
		{
		    new value = floatround(ofloat, floatround_round);

		    if(value == 0)
		    {
				GateInfo[gateid][gHID] = INVALID_HOUSE_ID;
		        GateInfo[gateid][gPosX] = 0.0;
		        GateInfo[gateid][gPosY] = 0.0;
		        GateInfo[gateid][gPosZ] = 0.0;
		        GateInfo[gateid][gRotX] = 0.0;
		        GateInfo[gateid][gRotY] = 0.0;
				GateInfo[gateid][gRotZ] = 0.0;
				GateInfo[gateid][gPosXM] = 0.0;
				GateInfo[gateid][gPosYM] = 0.0;
				GateInfo[gateid][gPosZM] = 0.0;
				GateInfo[gateid][gRotXM] = 0.0;
				GateInfo[gateid][gRotYM] = 0.0;
				GateInfo[gateid][gRotZM] = 0.0;
				GateInfo[gateid][gVW] = 0;
				GateInfo[gateid][gInt] = 0;
				GateInfo[gateid][gAllegiance] = 0;
				GateInfo[gateid][gGroupType] = 0;
				GateInfo[gateid][gGroupID] = INVALID_GROUP_ID;
			}

		    GateInfo[gateid][gModel] = value;
		    format(string, sizeof(string), "Model %d assigned to Gate %d", GateInfo[gateid][gModel], gateid);
            CreateGate(gateid);
		    SendClientMessageEx(playerid, COLOR_WHITE, string);
		    SaveGate(gateid);

		    format(string, sizeof(string), "%s has edited GateID %d's Model to %d.", GetPlayerNameEx(playerid), gateid, value);
		    Log("logs/gedit.log", string);
		}
		else if(strcmp(x_job, "vw", true) == 0)
		{
		    new value = floatround(ofloat, floatround_round);
		    GateInfo[gateid][gVW] = value;
		    format(string, sizeof(string), "Virtual World %d assigned to Gate %d", GateInfo[gateid][gVW], gateid);
            CreateGate(gateid);
		    SendClientMessageEx(playerid, COLOR_WHITE, string);
		    SaveGate(gateid);

		    format(string, sizeof(string), "%s has edited GateID %d's VW to %d.", GetPlayerNameEx(playerid), gateid, value);
		    Log("logs/gedit.log", string);
		}
		else if(strcmp(x_job, "int", true) == 0)
		{
		    new value = floatround(ofloat, floatround_round);
		    GateInfo[gateid][gInt] = value;
		    format(string, sizeof(string), "Interior %d assigned to Gate %d", GateInfo[gateid][gInt], gateid);
			CreateGate(gateid);
		    SendClientMessageEx(playerid, COLOR_WHITE, string);
		    SaveGate(gateid);

		    format(string, sizeof(string), "%s has edited GateID %d's InteriorID to %d.", GetPlayerNameEx(playerid), gateid, value);
		    Log("logs/gedit.log", string);
		}
		else if(strcmp(x_job, "open", true) == 0)
		{
			foreach(new i:Player)
			{
				if(GetPVarInt(i, "EditingGateID") == gateid && i != playerid)
				{
					format(string, sizeof(string), "ERROR: %s (ID: %d) is currently editing this gate.", GetPlayerNameEx(i), i);
					return SendClientMessageEx(playerid, COLOR_WHITE, string);
				}
			}
			SetPVarInt(playerid, "gEdit", 1);
			SetPVarInt(playerid, "EditingGateID", gateid);
			SetDynamicObjectPos(GateInfo[gateid][gGATE], GateInfo[gateid][gPosX], GateInfo[gateid][gPosY], GateInfo[gateid][gPosZ]);
			SetDynamicObjectRot(GateInfo[gateid][gGATE], GateInfo[gateid][gRotX], GateInfo[gateid][gRotY], GateInfo[gateid][gRotZ]);
			EditDynamicObject(playerid, GateInfo[gateid][gGATE]);
			format(string, sizeof(string), "You are now editing the open position of Gate %d.", gateid);
			SendClientMessage(playerid, COLOR_WHITE, string);
			SendClientMessage(playerid, 0xFFFFAAAA, "HINT: Hold {8000FF}~k~~PED_SPRINT~ {FFFFAA}to move your camera, press escape to cancel");
		}
		else if(strcmp(x_job, "closed", true) == 0)
		{
			foreach(new i:Player)
			{
				if(GetPVarInt(i, "EditingGateID") == gateid && i != playerid)
				{
					format(string, sizeof(string), "ERROR: %s (ID: %d) is currently editing this gate.", GetPlayerNameEx(i), i);
					return SendClientMessageEx(playerid, COLOR_WHITE, string);
				}
			}
			SetPVarInt(playerid, "gEdit", 2);
			SetPVarInt(playerid, "EditingGateID", gateid);
			EditDynamicObject(playerid, GateInfo[gateid][gGATE]);
			format(string, sizeof(string), "You are now editing the closed position of Gate %d.", gateid);
			SendClientMessage(playerid, COLOR_WHITE, string);
			SendClientMessage(playerid, 0xFFFFAAAA, "HINT: Hold {8000FF}~k~~PED_SPRINT~ {FFFFAA}to move your camera, press escape to cancel");
		}
		else if(strcmp(x_job, "range", true) == 0)
		{
		    GateInfo[gateid][gRange] = ofloat;
		    format(string, sizeof(string), "Range of %.3f assigned to Gate %d", GateInfo[gateid][gRange], gateid);
		    SendClientMessageEx(playerid, COLOR_WHITE, string);
		    SaveGate(gateid);

		    format(string, sizeof(string), "%s has edited GateID %d's Range to %.3f.", GetPlayerNameEx(playerid), gateid, ofloat);
		    Log("logs/gedit.log", string);
		}
		else if(strcmp(x_job, "speed", true) == 0)
		{
		    GateInfo[gateid][gSpeed] = ofloat;
		    format(string, sizeof(string), "Speed of %.3f assigned to Gate %d", GateInfo[gateid][gSpeed], gateid);
		    SendClientMessageEx(playerid, COLOR_WHITE, string);
		    SaveGate(gateid);

		    format(string, sizeof(string), "%s has edited GateID %d's Speed to %.3f.", GetPlayerNameEx(playerid), gateid, ofloat);
		    Log("logs/gedit.log", string);
		}
		else if(strcmp(x_job, "posx", true) == 0)
		{
		    GateInfo[gateid][gPosX] = ofloat;
		    format(string, sizeof(string), "PosX %f assigned to Gate %d", GateInfo[gateid][gPosX], gateid);
		    SetDynamicObjectPos(GateInfo[gateid][gGATE], GateInfo[gateid][gPosX], GateInfo[gateid][gPosY], GateInfo[gateid][gPosZ]);
		    SendClientMessageEx(playerid, COLOR_WHITE, string);
		    SaveGate(gateid);
		}
		else if(strcmp(x_job, "posy", true) == 0)
		{
		    GateInfo[gateid][gPosY] = ofloat;
		    format(string, sizeof(string), "PosY %f assigned to Gate %d", GateInfo[gateid][gPosY], gateid);
		    SetDynamicObjectPos(GateInfo[gateid][gGATE], GateInfo[gateid][gPosX], GateInfo[gateid][gPosY], GateInfo[gateid][gPosZ]);
		    SendClientMessageEx(playerid, COLOR_WHITE, string);
		    SaveGate(gateid);
		}
		else if(strcmp(x_job, "posz", true) == 0)
		{
			GateInfo[gateid][gPosZ] = ofloat;
		    format(string, sizeof(string), "PosZ %f assigned to Gate %d", GateInfo[gateid][gPosZ], gateid);
		    SetDynamicObjectPos(GateInfo[gateid][gGATE], GateInfo[gateid][gPosX], GateInfo[gateid][gPosY], GateInfo[gateid][gPosZ]);
		    SendClientMessageEx(playerid, COLOR_WHITE, string);
		    SaveGate(gateid);
		}
		else if(strcmp(x_job, "posxm", true) == 0)
		{
		    GateInfo[gateid][gPosXM] = ofloat;
		    format(string, sizeof(string), "PosXM %f assigned to Gate %d", GateInfo[gateid][gPosXM], gateid);
		    SendClientMessageEx(playerid, COLOR_WHITE, string);
		    SaveGate(gateid);
		}
		else if(strcmp(x_job, "posym", true) == 0)
		{
		    GateInfo[gateid][gPosYM] = ofloat;
		    format(string, sizeof(string), "PosYM %f assigned to Gate %d", GateInfo[gateid][gPosYM], gateid);
		    SendClientMessageEx(playerid, COLOR_WHITE, string);
		    SaveGate(gateid);
		}
		else if(strcmp(x_job, "poszm", true) == 0)
		{
		    GateInfo[gateid][gPosZM] = ofloat;
		    format(string, sizeof(string), "PosZM %f assigned to Gate %d", GateInfo[gateid][gPosZM], gateid);
		    SendClientMessageEx(playerid, COLOR_WHITE, string);
		    SaveGate(gateid);
		}
		else if(strcmp(x_job, "rotx", true) == 0)
		{
		    GateInfo[gateid][gRotX] = ofloat;
		    format(string, sizeof(string), "RotX %f assigned to Gate %d", GateInfo[gateid][gRotX], gateid);
		    SetDynamicObjectRot(GateInfo[gateid][gGATE], GateInfo[gateid][gRotX],GateInfo[gateid][gRotY],GateInfo[gateid][gRotZ]);
		    SendClientMessageEx(playerid, COLOR_WHITE, string);
		    SaveGate(gateid);
		}
		else if(strcmp(x_job, "roty", true) == 0)
		{
		    GateInfo[gateid][gRotY] = ofloat;
		    format(string, sizeof(string), "RotY %f assigned to Gate %d", GateInfo[gateid][gRotY], gateid);
		    SetDynamicObjectRot(GateInfo[gateid][gGATE], GateInfo[gateid][gRotX],GateInfo[gateid][gRotY],GateInfo[gateid][gRotZ]);
		    SendClientMessageEx(playerid, COLOR_WHITE, string);
		    SaveGate(gateid);
		}
		else if(strcmp(x_job, "rotz", true) == 0)
		{
			GateInfo[gateid][gRotZ] = ofloat;
		    format(string, sizeof(string), "RotZ %f assigned to Gate %d", GateInfo[gateid][gRotZ], gateid);
		    SetDynamicObjectRot(GateInfo[gateid][gGATE], GateInfo[gateid][gRotX],GateInfo[gateid][gRotY],GateInfo[gateid][gRotZ]);
		    SendClientMessageEx(playerid, COLOR_WHITE, string);
		    SaveGate(gateid);
		}
		else if(strcmp(x_job, "rotxm", true) == 0)
		{
		    GateInfo[gateid][gRotXM] = ofloat;
		    format(string, sizeof(string), "RotXM %f assigned to Gate %d", GateInfo[gateid][gRotXM], gateid);
		    SendClientMessageEx(playerid, COLOR_WHITE, string);
		    SaveGate(gateid);
		}
		else if(strcmp(x_job, "rotym", true) == 0)
		{
		    GateInfo[gateid][gRotYM] = ofloat;
		    format(string, sizeof(string), "RotYM %f assigned to Gate %d", GateInfo[gateid][gRotYM], gateid);
		    SendClientMessageEx(playerid, COLOR_WHITE, string);
		    SaveGate(gateid);
		}
		else if(strcmp(x_job, "rotzm", true) == 0)
		{
		    GateInfo[gateid][gRotZM] = ofloat;
		    format(string, sizeof(string), "RotZM %f assigned to Gate %d", GateInfo[gateid][gRotZM], gateid);
		    SendClientMessageEx(playerid, COLOR_WHITE, string);
		    SaveGate(gateid);
		}
        else if(strcmp(x_job, "tome", true) == 0)
		{
		    GetPlayerPos(playerid,GateInfo[gateid][gPosX],GateInfo[gateid][gPosY], GateInfo[gateid][gPosZ]);
		    GateInfo[gateid][gVW] = GetPlayerVirtualWorld(playerid);
		    GateInfo[gateid][gInt] = GetPlayerInterior(playerid);
			format(string, sizeof(string), "Gate %d Pos moved to %f %f %f, VW: %d INT: %d", gateid, GateInfo[gateid][gPosX], GateInfo[gateid][gPosY], GateInfo[gateid][gPosZ], GateInfo[gateid][gVW], GateInfo[gateid][gInt]);
		    SendClientMessageEx(playerid, COLOR_WHITE, string);
		    if(GateInfo[gateid][gModel] == 0)
			{
			    GateInfo[gateid][gModel] = 18631;
			    GateInfo[gateid][gRange] = 10;
			    GateInfo[gateid][gSpeed] = 5.0;
			}
			CreateGate(gateid);
			SaveGate(gateid);

			format(string, sizeof(string), "%s has edited GateID %d's Position.", GetPlayerNameEx(playerid), gateid);
		    Log("logs/gedit.log", string);
		}
		else if(strcmp(x_job, "tomem", true) == 0)
		{
		    GetPlayerPos(playerid,GateInfo[gateid][gPosXM],GateInfo[gateid][gPosYM], GateInfo[gateid][gPosZM]);
			format(string, sizeof(string), "Gate %d PosM moved to %f %f %f", gateid, GateInfo[gateid][gPosXM], GateInfo[gateid][gPosYM], GateInfo[gateid][gPosZM]);
		    SendClientMessageEx(playerid, COLOR_WHITE, string);
			SaveGate(gateid);

			format(string, sizeof(string), "%s has edited GateID %d's Moved Position.", GetPlayerNameEx(playerid), gateid);
		    Log("logs/gedit.log", string);
		}
		else if(strcmp(x_job, "allegiance", true) == 0)
		{
		    new value = floatround(ofloat, floatround_round);
		    GateInfo[gateid][gAllegiance] = value;
		    format(string, sizeof(string), "Allegiance %d assigned to Gate %d", GateInfo[gateid][gAllegiance], gateid);
		    SendClientMessageEx(playerid, COLOR_WHITE, string);
		    SaveGate(gateid);

		    format(string, sizeof(string), "%s has edited GateID %d's Allegiance to %d.", GetPlayerNameEx(playerid), gateid, value);
		    Log("logs/gedit.log", string);
		}
		else if(strcmp(x_job, "grouptype", true) == 0)
		{
		    new value = floatround(ofloat, floatround_round);
		    GateInfo[gateid][gGroupType] = value;
		    format(string, sizeof(string), "Group Type %d assigned to Gate %d", GateInfo[gateid][gGroupType], gateid);
		    SendClientMessageEx(playerid, COLOR_WHITE, string);
		    SaveGate(gateid);

		    format(string, sizeof(string), "%s has edited GateID %d's Group Type to %d.", GetPlayerNameEx(playerid), gateid, value);
		    Log("logs/gedit.log", string);
		}
		else if(strcmp(x_job, "groupid", true) == 0)
		{
		    new value = floatround(ofloat, floatround_round);
		    GateInfo[gateid][gGroupID] = value;
		    format(string, sizeof(string), "Group ID %d assigned to Gate %d", GateInfo[gateid][gGroupID], gateid);
		    SendClientMessageEx(playerid, COLOR_WHITE, string);
		    SaveGate(gateid);

		    format(string, sizeof(string), "%s has edited GateID %d's Group ID to %d.", GetPlayerNameEx(playerid), gateid, value);
		    Log("logs/gedit.log", string);
		}
		else if(strcmp(x_job, "stream", true) == 0)
		{
		    new value = floatround(ofloat, floatround_round);
		    GateInfo[gateid][gRenderHQ] = value;
		    format(string, sizeof(string), "Stream distance %d assigned to Gate %d", GateInfo[gateid][gRenderHQ], gateid);
            CreateGate(gateid);
		    SendClientMessageEx(playerid, COLOR_WHITE, string);
		    SaveGate(gateid);

		    format(string, sizeof(string), "%s has edited GateID %d's stream distance to %d.", GetPlayerNameEx(playerid), gateid, value);
		    Log("logs/gedit.log", string);
		}
		else if(strcmp(x_job, "timer", true) == 0)
		{
			new value = floatround(ofloat, floatround_round);
		    GateInfo[gateid][gTimer] = value;
		    format(string, sizeof(string), "Timer %d assigned to Gate %d", GateInfo[gateid][gTimer], gateid);
		    SendClientMessageEx(playerid, COLOR_WHITE, string);
		    SaveGate(gateid);

		    format(string, sizeof(string), "%s has edited GateID %d's timer to %d.", GetPlayerNameEx(playerid), gateid, value);
		    Log("logs/gedit.log", string);
		}
		else if(strcmp(x_job, "facility", true) == 0)
		{
			new value = floatround(ofloat, floatround_round);
			if(!(0 <= value < MAX_CRATE_FACILITY)) return SendClientMessageEx(playerid, COLOR_GRAD2, "Invalid facility ID.");
		    GateInfo[gateid][gFacility] = value;
		    format(string, sizeof(string), "Facility %d assigned to Gate %d", value, gateid);
		    SendClientMessageEx(playerid, COLOR_WHITE, string);
		    SaveGate(gateid);
		    format(string, sizeof(string), "%s has edited GateID %d's assigned facility to %d.", GetPlayerNameEx(playerid), gateid, value);
		    Log("logs/gedit.log", string);
		}
	}
	else
	{
	    SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use that command.");
		return 1;
	}
	return 1;
}

CMD:gedittexture(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1 || PlayerInfo[playerid][pShopTech] >= 1)
	{
		new gateid, option[16], var[64], string[128];

		if(sscanf(params, "is[16]s[64]", gateid, option, var))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /gedittexture [gateid] [name] [value]");
			SendClientMessageEx(playerid, COLOR_GREY, "Available names: Index, Model, TXD, Texture, Color, Delete");
			return 1;
		}

		if(strcmp(option, "index", true) == 0)
		{
			new value = strval(var);
		    GateInfo[gateid][gTIndex] = value;
		    format(string, sizeof(string), "Texture index %d assigned to Gate %d", GateInfo[gateid][gTIndex], gateid);
		    SendClientMessageEx(playerid, COLOR_WHITE, string);
		    SaveGate(gateid);

		    format(string, sizeof(string), "%s has edited GateID %d's texture index to %d.", GetPlayerNameEx(playerid), gateid, value);
		    Log("logs/gedit.log", string);
		}
		else if(strcmp(option, "model", true) == 0)
		{
		    new value = strval(var);
		    GateInfo[gateid][gTModel] = value;
		    format(string, sizeof(string), "Texture model %d assigned to Gate %d", GateInfo[gateid][gTModel], gateid);
		    SendClientMessageEx(playerid, COLOR_WHITE, string);
		    SaveGate(gateid);
			CreateGate(gateid);

		    format(string, sizeof(string), "%s has edited GateID %d's texture model to %d.", GetPlayerNameEx(playerid), gateid, value);
		    Log("logs/gedit.log", string);
		}
		else if(strcmp(option, "txd", true) == 0)
		{
		    format(GateInfo[gateid][gTTXD], 64, "%s", var);
		    format(string, sizeof(string), "TXD file %s assigned to Gate %d", GateInfo[gateid][gTTXD], gateid);
		    SendClientMessageEx(playerid, COLOR_WHITE, string);
		    SaveGate(gateid);

		    format(string, sizeof(string), "%s has edited GateID %d's TXD file to %s.", GetPlayerNameEx(playerid), gateid, var);
		    Log("logs/gedit.log", string);
		}
		else if(strcmp(option, "texture", true) == 0)
		{
		    format(GateInfo[gateid][gTTexture], 64, "%s", var);
		    format(string, sizeof(string), "Texture %s assigned to Gate %d", GateInfo[gateid][gTTexture], gateid);
		    SendClientMessageEx(playerid, COLOR_WHITE, string);
		    SaveGate(gateid);

		    format(string, sizeof(string), "%s has edited GateID %d's texture to %s.", GetPlayerNameEx(playerid), gateid, var);
		    Log("logs/gedit.log", string);
		}
		else if(strcmp(option, "color", true) == 0)
		{
			if(strlen(var) > 6 || !ishex(var)) return SendClientMessageEx(playerid, COLOR_GREY, "Color must be a valid hexadecimal color (ie: BCA3FF)");
			new value;
			sscanf(var, "h", value);
		    GateInfo[gateid][gTColor] = value;
		    format(string, sizeof(string), "Material color %d assigned to Gate %d", GateInfo[gateid][gTColor], gateid);
		    SendClientMessageEx(playerid, COLOR_WHITE, string);
		    SaveGate(gateid);

		    format(string, sizeof(string), "%s has edited GateID %d's material color to %d.", GetPlayerNameEx(playerid), gateid, value);
		    Log("logs/gedit.log", string);
		}
		if(strcmp(option, "delete", true) == 0)
		{
		    GateInfo[gateid][gTIndex] = -1;
			GateInfo[gateid][gTModel] = INVALID_OBJECT_ID;
			GateInfo[gateid][gTTXD] = EOS;
			GateInfo[gateid][gTTexture] = EOS;
			GateInfo[gateid][gTColor] = 0;
		    format(string, sizeof(string), "Texture removed from Gate %d", gateid);
		    SendClientMessageEx(playerid, COLOR_WHITE, string);
		    SaveGate(gateid);
			CreateGate(gateid);

		    format(string, sizeof(string), "%s has removed GateID %d's texture.", GetPlayerNameEx(playerid), gateid);
		    Log("logs/gedit.log", string);
		}
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use that command.");
	return 1;
}

CMD:listgates(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	new hid, string[128];
	if(sscanf(params, "d", hid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /listgates [houseid]");
	if(hid <= 0 || hid >= MAX_HOUSES)
	{
		format(string, sizeof(string), "House ID must be between 1 and %d.", MAX_HOUSES - 1);
		return SendClientMessageEx(playerid, COLOR_GREY, string);
	}
	format(string, sizeof(string), "Listing gates linked to house id: %d", hid);
	SendClientMessageEx(playerid, COLOR_WHITE, string);
	for(new i = 0; i < MAX_GATES; i++)
	{
		if(GateInfo[i][gHID] == hid)
		{
			format(string, sizeof(string), "- %d", i);
			SendClientMessageEx(playerid, COLOR_GREY, string);
		}
	}
	return 1;
}

CMD:gmove(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1) return SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use this command.");
	new gateid, giveplayerid, fee, minfee;
	if(sscanf(params, "dudd", gateid, giveplayerid, fee, minfee))
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /gmove <Choice> <GateID> <playerid> <Fine (Percent)> <min. fine>");
		SendClientMessageEx(playerid, COLOR_GREY, "NOTE: Set fine as 0 if you don't want to fine this player.");
		return 1;
	}
	new string[128];
	new totalwealth = PlayerInfo[giveplayerid][pAccount] + GetPlayerCash(giveplayerid);
	if(PlayerInfo[giveplayerid][pPhousekey] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[giveplayerid][pPhousekey]][hOwnerID] == GetPlayerSQLId(giveplayerid)) totalwealth += HouseInfo[PlayerInfo[giveplayerid][pPhousekey]][hSafeMoney];
	if(PlayerInfo[giveplayerid][pPhousekey2] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[giveplayerid][pPhousekey2]][hOwnerID] == GetPlayerSQLId(giveplayerid)) totalwealth += HouseInfo[PlayerInfo[giveplayerid][pPhousekey2]][hSafeMoney];
	if(PlayerInfo[giveplayerid][pPhousekey3] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[giveplayerid][pPhousekey3]][hOwnerID] == GetPlayerSQLId(giveplayerid)) totalwealth += HouseInfo[PlayerInfo[giveplayerid][pPhousekey3]][hSafeMoney];
	if(fee > 0)
	{
		fee = totalwealth / 100 * fee;
		if(PlayerInfo[giveplayerid][pDonateRank] == 3)
		{
			fee = fee / 100 * 95;
		}
		if(PlayerInfo[giveplayerid][pDonateRank] >= 4)
		{
			fee = fee / 100 * 85;
		}
	}
	GetPlayerPos(playerid,GateInfo[gateid][gPosX],GateInfo[gateid][gPosY], GateInfo[gateid][gPosZ]);
	GateInfo[gateid][gVW] = GetPlayerVirtualWorld(playerid);
	GateInfo[gateid][gInt] = GetPlayerInterior(playerid);
	format(string, sizeof(string), "Gate %d Pos moved to %f %f %f, VW: %d INT: %d", gateid, GateInfo[gateid][gPosX], GateInfo[gateid][gPosY], GateInfo[gateid][gPosZ], GateInfo[gateid][gVW], GateInfo[gateid][gInt]);
	SendClientMessageEx(playerid, COLOR_WHITE, string);
	if(GateInfo[gateid][gModel] == 0)
	{
		GateInfo[gateid][gModel] = 18631;
		GateInfo[gateid][gRange] = 10;
		GateInfo[gateid][gSpeed] = 5.0;
	}
	CreateGate(gateid);
	SaveGate(gateid);
	format(string, sizeof(string), "%s has edited GateID %d's Position.", GetPlayerNameEx(playerid), gateid);
	Log("logs/gedit.log", string);
	if(minfee > fee && minfee > 0)
	{
		GivePlayerCashEx(giveplayerid, TYPE_ONHAND, -minfee);
		format(string, sizeof(string), "AdmCmd: %s(%d) was fined $%s by %s, reason: Dynamic Door Move", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), number_format(minfee), GetPlayerNameEx(playerid));
		Log("logs/admin.log", string);
		format(string, sizeof(string), "AdmCmd: %s was fined $%s by %s, reason: Dynamic Door Move", GetPlayerNameEx(giveplayerid), number_format(minfee), GetPlayerNameEx(playerid));
		SendClientMessageToAllEx(COLOR_LIGHTRED, string);
	}
	else if(fee > 0)
	{
		GivePlayerCashEx(giveplayerid, TYPE_ONHAND, -fee);
		format(string, sizeof(string), "AdmCmd: %s(%d) was fined $%s by %s, reason: Dynamic Door Move", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), number_format(fee), GetPlayerNameEx(playerid));
		Log("logs/admin.log", string);
		format(string, sizeof(string), "AdmCmd: %s was fined $%s by %s, reason: Dynamic Door Move", GetPlayerNameEx(giveplayerid), number_format(fee), GetPlayerNameEx(playerid));
		SendClientMessageToAllEx(COLOR_LIGHTRED, string);
	}
	return 1;
}

CMD:reloadgate(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	new gateid, string[128];
	if(sscanf(params, "d", gateid)) return SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /reloadgate <gateid>");
	CreateGate(gateid);
	format(string, sizeof(string), "Reloading Gate ID %d...", gateid);
	SendClientMessageEx(playerid, COLOR_WHITE, string);
	return 1;
}

CreateGate(gateid) {
	if(IsValidDynamicObject(GateInfo[gateid][gGATE])) DestroyDynamicObject(GateInfo[gateid][gGATE]);
	GateInfo[gateid][gGATE] = -1;
	if(GateInfo[gateid][gPosX] == 0.0) return 1;
	switch(GateInfo[gateid][gRenderHQ])
	{
		case 1: GateInfo[gateid][gGATE] = CreateDynamicObject(GateInfo[gateid][gModel], GateInfo[gateid][gPosX], GateInfo[gateid][gPosY], GateInfo[gateid][gPosZ], GateInfo[gateid][gRotX], GateInfo[gateid][gRotY], GateInfo[gateid][gRotZ], GateInfo[gateid][gVW], GateInfo[gateid][gInt], -1, 100.0);
		case 2: GateInfo[gateid][gGATE] = CreateDynamicObject(GateInfo[gateid][gModel], GateInfo[gateid][gPosX], GateInfo[gateid][gPosY], GateInfo[gateid][gPosZ], GateInfo[gateid][gRotX], GateInfo[gateid][gRotY], GateInfo[gateid][gRotZ], GateInfo[gateid][gVW], GateInfo[gateid][gInt], -1, 150.0);
		case 3: GateInfo[gateid][gGATE] = CreateDynamicObject(GateInfo[gateid][gModel], GateInfo[gateid][gPosX], GateInfo[gateid][gPosY], GateInfo[gateid][gPosZ], GateInfo[gateid][gRotX], GateInfo[gateid][gRotY], GateInfo[gateid][gRotZ], GateInfo[gateid][gVW], GateInfo[gateid][gInt], -1, 200.0);
		default: GateInfo[gateid][gGATE] = CreateDynamicObject(GateInfo[gateid][gModel], GateInfo[gateid][gPosX], GateInfo[gateid][gPosY], GateInfo[gateid][gPosZ], GateInfo[gateid][gRotX], GateInfo[gateid][gRotY], GateInfo[gateid][gRotZ], GateInfo[gateid][gVW], GateInfo[gateid][gInt], -1, 60.0);
	}
	if(GateInfo[gateid][gTModel] != INVALID_OBJECT_ID) SetDynamicObjectMaterial(GateInfo[gateid][gGATE], GateInfo[gateid][gTIndex], GateInfo[gateid][gTModel], GateInfo[gateid][gTTXD], GateInfo[gateid][gTTexture], GateInfo[gateid][gTColor]);
	return 1;
}

stock LoadGates()
{
	printf("[LoadGates] Loading data from database...");
	mysql_tquery(MainPipeline, "SELECT * FROM `gates`", "OnLoadGates", "");
}

forward OnLoadGates();
public OnLoadGates()
{
	new i, rows;
	cache_get_row_count(rows);

	while(i < rows)
	{
		cache_get_value_name_int(i, "HID", GateInfo[i][gHID]);
		cache_get_value_name_float(i, "Speed", GateInfo[i][gSpeed]);
		cache_get_value_name_float(i, "Range", GateInfo[i][gRange]);
		cache_get_value_name_int(i, "Model", GateInfo[i][gModel]);
		cache_get_value_name_int(i, "VW", GateInfo[i][gVW]);
		cache_get_value_name_int(i, "Int", GateInfo[i][gInt]);
		cache_get_value_name(i, "Pass", GateInfo[i][gPass], 24);
		cache_get_value_name_float(i, "PosX", GateInfo[i][gPosX]);
		cache_get_value_name_float(i, "PosY", GateInfo[i][gPosY]);
		cache_get_value_name_float(i, "PosZ", GateInfo[i][gPosZ]);
		cache_get_value_name_float(i, "RotX", GateInfo[i][gRotX]);
		cache_get_value_name_float(i, "RotY", GateInfo[i][gRotY]);
		cache_get_value_name_float(i, "RotZ", GateInfo[i][gRotZ]);
		cache_get_value_name_float(i, "PosXM", GateInfo[i][gPosXM]);
		cache_get_value_name_float(i, "PosYM", GateInfo[i][gPosYM]);
		cache_get_value_name_float(i, "PosZM", GateInfo[i][gPosZM]);
		cache_get_value_name_float(i, "RotXM", GateInfo[i][gRotXM]);
		cache_get_value_name_float(i, "RotYM", GateInfo[i][gRotYM]);
		cache_get_value_name_float(i, "RotZM", GateInfo[i][gRotZM]);
		cache_get_value_name_int(i, "Allegiance", GateInfo[i][gAllegiance]);
		cache_get_value_name_int(i, "GroupType", GateInfo[i][gGroupType]);
		cache_get_value_name_int(i, "GroupID", GateInfo[i][gGroupID]);
		cache_get_value_name_int(i, "RenderHQ",  GateInfo[i][gRenderHQ]);
		cache_get_value_name_int(i, "Timer", GateInfo[i][gTimer]);
		cache_get_value_name_int(i, "Automate", GateInfo[i][gAutomate]);
		cache_get_value_name_int(i, "Locked", GateInfo[i][gLocked]);
		cache_get_value_name_int(i, "TIndex", GateInfo[i][gTIndex]);
		cache_get_value_name_int(i, "TModel", GateInfo[i][gTModel]);
		cache_get_value_name(i, "TTXD", GateInfo[i][gTTXD], 64);
		cache_get_value_name(i, "TTexture", GateInfo[i][gTTexture], 64);
		cache_get_value_name_int(i, "TColor", GateInfo[i][gTColor]);
		cache_get_value_name_int(i, "Facility", GateInfo[i][gFacility]);
		if(GateInfo[i][gPosX] != 0.0) CreateGate(i);
		i++;
	}
}

stock SaveGate(id) {

	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "UPDATE `gates` SET \
		`HID`=%d, \
		`Speed`=%f, \
		`Range`=%f, \
		`Model`=%d, \
		`VW`=%d, \
		`Int`=%d, \
		`Pass`='%e', \
		`PosX`=%f, \
		`PosY`=%f, \
		`PosZ`=%f, \
		`RotX`=%f, \
		`RotY`=%f, \
		`RotZ`=%f, \
		`PosXM`=%f, \
		`PosYM`=%f, \
		`PosZM`=%f, \
		`RotXM`=%f, \
		`RotYM`=%f, \
		`RotZM`=%f, \
		`Allegiance`=%d, \
		`GroupType`=%d, \
		`GroupID`=%d, \
		`RenderHQ`=%d, \
		`Timer`=%d, \
		`Automate`=%d, \
		`Locked`=%d, \
		`TIndex`=%d, \
		`TModel`=%d, \
		`TTXD`='%e', \
		`TTexture`='%e', \
		`TColor`=%d, \
		`Facility`=%d \
		WHERE `ID` = %d",
		GateInfo[id][gHID],
		GateInfo[id][gSpeed],
		GateInfo[id][gRange],
		GateInfo[id][gModel],
		GateInfo[id][gVW],
		GateInfo[id][gInt],
		GateInfo[id][gPass],
		GateInfo[id][gPosX],
		GateInfo[id][gPosY],
		GateInfo[id][gPosZ],
		GateInfo[id][gRotX],
		GateInfo[id][gRotY],
		GateInfo[id][gRotZ],
		GateInfo[id][gPosXM],
		GateInfo[id][gPosYM],
		GateInfo[id][gPosZM],
		GateInfo[id][gRotXM],
		GateInfo[id][gRotYM],
		GateInfo[id][gRotZM],
		GateInfo[id][gAllegiance],
		GateInfo[id][gGroupType],
		GateInfo[id][gGroupID],
		GateInfo[id][gRenderHQ],
		GateInfo[id][gTimer],
		GateInfo[id][gAutomate],
		GateInfo[id][gLocked],
		GateInfo[id][gTIndex],
		GateInfo[id][gTModel],
		GateInfo[id][gTTXD],
		GateInfo[id][gTTexture],
		GateInfo[id][gTColor],
		GateInfo[id][gFacility],
		id+1
	);
	mysql_tquery(MainPipeline, szMiscArray, "OnQueryFinish", "i", SENDDATA_THREAD);
	return 0;
}

stock SaveGates()
{
	for(new i = 0; i < MAX_GATES; i++)
	{
		SaveGate(i);
	}
	return 1;
}

forward MoveTimerGate(gateid);
public MoveTimerGate(gateid)
{
	if(GateInfo[gateid][gTimer] != 0)
	{
		if((0 <= GateInfo[gateid][gFacility] < MAX_CRATE_FACILITY)) {
			if(AdminOpened[GateInfo[gateid][gFacility]] || CrateFacility[GateInfo[gateid][gFacility]][cfRaidable] && CrateFacility[GateInfo[gateid][gFacility]][cfRaidTimer] > 0)
				return 1;
		}
		MoveDynamicObject(GateInfo[gateid][gGATE], GateInfo[gateid][gPosX], GateInfo[gateid][gPosY], GateInfo[gateid][gPosZ], GateInfo[gateid][gSpeed], GateInfo[gateid][gRotX], GateInfo[gateid][gRotY], GateInfo[gateid][gRotZ]);
		GateInfo[gateid][gStatus] = 0;
	}
	return 1;
}

stock MoveGate(playerid, gateid)
{
	new string[128];
	if(GateInfo[gateid][gStatus] == 0)
	{
		format(string, sizeof(string), "* %s uses their remote to open the gates.", GetPlayerNameEx(playerid));
		// ProxDetector(GateInfo[gateid][gRange], playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		ProxChatBubble(playerid, string);
		MoveDynamicObject(GateInfo[gateid][gGATE], GateInfo[gateid][gPosXM], GateInfo[gateid][gPosYM], GateInfo[gateid][gPosZM], GateInfo[gateid][gSpeed], GateInfo[gateid][gRotXM], GateInfo[gateid][gRotYM], GateInfo[gateid][gRotZM]);
		GateInfo[gateid][gStatus] = 1;
		if(GateInfo[gateid][gTimer] != 0)
		{
			switch(GateInfo[gateid][gTimer])
			{
				case 1: SetTimerEx("MoveTimerGate", 3000, false, "i", gateid);
				case 2: SetTimerEx("MoveTimerGate", 5000, false, "i", gateid);
				case 3: SetTimerEx("MoveTimerGate", 8000, false, "i", gateid);
				case 4: SetTimerEx("MoveTimerGate", 10000, false, "i", gateid);
			}
		}
	}
	else if(GateInfo[gateid][gStatus] == 1 && GateInfo[gateid][gTimer] == 0)
	{
		if((0 <= GateInfo[gateid][gFacility] < MAX_CRATE_FACILITY)) {
			if(AdminOpened[GateInfo[gateid][gFacility]] || CrateFacility[GateInfo[gateid][gFacility]][cfRaidable] && CrateFacility[GateInfo[gateid][gFacility]][cfRaidTimer] > 0)
				return SendClientMessageEx(playerid, COLOR_GRAD2, "Unable to close the gate it's currently being prevented by the facility!");
		}
		format(string, sizeof(string), "* %s uses their remote to close the gates.", GetPlayerNameEx(playerid));
		// ProxDetector(GateInfo[gateid][gRange], playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		ProxChatBubble(playerid, string);
		MoveDynamicObject(GateInfo[gateid][gGATE], GateInfo[gateid][gPosX], GateInfo[gateid][gPosY], GateInfo[gateid][gPosZ], GateInfo[gateid][gSpeed], GateInfo[gateid][gRotX], GateInfo[gateid][gRotY], GateInfo[gateid][gRotZ]);
		GateInfo[gateid][gStatus] = 0;
	}
	return 1;
}

stock MoveAutomaticGate(playerid, gateid)
{
	MoveDynamicObject(GateInfo[gateid][gGATE], GateInfo[gateid][gPosXM], GateInfo[gateid][gPosYM], GateInfo[gateid][gPosZM], GateInfo[gateid][gSpeed], GateInfo[gateid][gRotXM], GateInfo[gateid][gRotYM], GateInfo[gateid][gRotZM]);
	GateInfo[gateid][gStatus] = 1;
	switch(GateInfo[gateid][gTimer])
	{
		case 1: SetTimerEx("AutomaticGateTimerClose", 3000, false, "ii", playerid, gateid);
		case 2: SetTimerEx("AutomaticGateTimerClose", 5000, false, "ii", playerid, gateid);
		case 3: SetTimerEx("AutomaticGateTimerClose", 8000, false, "ii", playerid, gateid);
		case 4: SetTimerEx("AutomaticGateTimerClose", 10000, false, "ii", playerid, gateid);
		default: SetTimerEx("AutomaticGateTimerClose", 3000, false, "ii", playerid, gateid);
	}
	return 1;
}

forward AutomaticGateTimer(playerid, gateid);
public AutomaticGateTimer(playerid, gateid)
{
	if(GateInfo[gateid][gLocked] == 0)
	{
		if(GateInfo[gateid][gStatus] == 0 && IsPlayerInRangeOfPoint(playerid, GateInfo[gateid][gRange], GateInfo[gateid][gPosX], GateInfo[gateid][gPosY], GateInfo[gateid][gPosZ]))
		{
			if(GateInfo[gateid][gGroupID] != -1 && (0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS) && PlayerInfo[playerid][pMember] == GateInfo[gateid][gGroupID]) MoveAutomaticGate(playerid, gateid);
			else if(GateInfo[gateid][gAllegiance] != 0 && GateInfo[gateid][gGroupType] != 0 && (0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS) && arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance] == GateInfo[gateid][gAllegiance] && arrGroupData[PlayerInfo[playerid][pMember]][g_iGroupType] == GateInfo[gateid][gGroupType]) MoveAutomaticGate(playerid, gateid);
			else if(GateInfo[gateid][gAllegiance] != 0 && GateInfo[gateid][gGroupType] == 0 && (0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS) && arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance] == GateInfo[gateid][gAllegiance]) MoveAutomaticGate(playerid, gateid);
			else if(GateInfo[gateid][gAllegiance] == 0 && GateInfo[gateid][gGroupType] != 0 && (0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS) && arrGroupData[PlayerInfo[playerid][pMember]][g_iGroupType] == GateInfo[gateid][gGroupType]) MoveAutomaticGate(playerid, gateid);
			else MoveAutomaticGate(playerid, gateid);
		}
		SetTimerEx("AutomaticGateTimer", 1000, false, "ii", playerid, gateid);
	}
	else
	{
		if(GateInfo[gateid][gStatus] == 1 && !IsPlayerInRangeOfPoint(playerid, GateInfo[gateid][gRange], GateInfo[gateid][gPosXM], GateInfo[gateid][gPosYM], GateInfo[gateid][gPosZM]))
		{
			MoveDynamicObject(GateInfo[gateid][gGATE], GateInfo[gateid][gPosX], GateInfo[gateid][gPosY], GateInfo[gateid][gPosZ], GateInfo[gateid][gSpeed], GateInfo[gateid][gRotX], GateInfo[gateid][gRotY], GateInfo[gateid][gRotZ]);
			SetTimerEx("AutomaticGateTimer", 1000, false, "ii", playerid, gateid);
			GateInfo[gateid][gStatus] = 0;
			return 1;
		}
	}
	return 1;
}

forward AutomaticGateTimerClose(playerid, gateid);
public AutomaticGateTimerClose(playerid, gateid)
{
	if(GateInfo[gateid][gLocked] == 0)
	{
		if(GateInfo[gateid][gStatus] == 1 && !IsPlayerInRangeOfPoint(playerid, GateInfo[gateid][gRange], GateInfo[gateid][gPosXM], GateInfo[gateid][gPosYM], GateInfo[gateid][gPosZM]))
		{
			MoveDynamicObject(GateInfo[gateid][gGATE], GateInfo[gateid][gPosX], GateInfo[gateid][gPosY], GateInfo[gateid][gPosZ], GateInfo[gateid][gSpeed], GateInfo[gateid][gRotX], GateInfo[gateid][gRotY], GateInfo[gateid][gRotZ]);
			SetTimerEx("AutomaticGateTimer", 1000, false, "ii", playerid, gateid);
			GateInfo[gateid][gStatus] = 0;
			return 1;
		}
		switch(GateInfo[gateid][gTimer])
		{
			case 1: SetTimerEx("AutomaticGateTimerClose", 3000, false, "ii", playerid, gateid);
			case 2: SetTimerEx("AutomaticGateTimerClose", 5000, false, "ii", playerid, gateid);
			case 3: SetTimerEx("AutomaticGateTimerClose", 8000, false, "ii", playerid, gateid);
			case 4: SetTimerEx("AutomaticGateTimerClose", 10000, false, "ii", playerid, gateid);
			default: SetTimerEx("AutomaticGateTimerClose", 3000, false, "ii", playerid, gateid);
		}
	}
	else
	{
		if(GateInfo[gateid][gStatus] == 1 && !IsPlayerInRangeOfPoint(playerid, GateInfo[gateid][gRange], GateInfo[gateid][gPosXM], GateInfo[gateid][gPosYM], GateInfo[gateid][gPosZM]))
		{
			MoveDynamicObject(GateInfo[gateid][gGATE], GateInfo[gateid][gPosX], GateInfo[gateid][gPosY], GateInfo[gateid][gPosZ], GateInfo[gateid][gSpeed], GateInfo[gateid][gRotX], GateInfo[gateid][gRotY], GateInfo[gateid][gRotZ]);
			SetTimerEx("AutomaticGateTimer", 1000, false, "ii", playerid, gateid);
			GateInfo[gateid][gStatus] = 0;
			return 1;
		}
	}
	return 1;
}

forward DeleteGate(gateid, adminid);
public DeleteGate(gateid, adminid)
{
	if(IsValidDynamicObject(GateInfo[gateid][gGATE])) DestroyDynamicObject(GateInfo[gateid][gGATE]), GateInfo[gateid][gGATE] = -1;
	GateInfo[gateid][gHID] = INVALID_HOUSE_ID;
	GateInfo[gateid][gSpeed] = 1.0;
	GateInfo[gateid][gRange] = 1.0;
	GateInfo[gateid][gModel] = 0;
	GateInfo[gateid][gVW] = 0;
	GateInfo[gateid][gInt] = 0;
	GateInfo[gateid][gPosX] = 0.0;
	GateInfo[gateid][gPosY] = 0.0;
	GateInfo[gateid][gPosZ] = 0.0;
	GateInfo[gateid][gRotX] = 0.0;
	GateInfo[gateid][gRotY] = 0.0;
	GateInfo[gateid][gRotZ] = 0.0;
	GateInfo[gateid][gPosXM] = 0.0;
	GateInfo[gateid][gPosYM] = 0.0;
	GateInfo[gateid][gPosZM] = 0.0;
	GateInfo[gateid][gRotXM] = 0.0;
	GateInfo[gateid][gRotYM] = 0.0;
    GateInfo[gateid][gRotZM] = 0.0;
    GateInfo[gateid][gStatus] = 0;
    GateInfo[gateid][gPass][0] = 0;
	GateInfo[gateid][gAllegiance] = 0;
	GateInfo[gateid][gGroupType] = 0;
	GateInfo[gateid][gGroupID] = INVALID_GROUP_ID;
    GateInfo[gateid][gRenderHQ] = 0;
	GateInfo[gateid][gTimer] = 0;
	GateInfo[gateid][gAutomate] = 0;
	GateInfo[gateid][gLocked] = 0;
	GateInfo[gateid][gFacility] = -1;
	szMiscArray[0] = 0;
	format(szMiscArray, sizeof(szMiscArray), "%s has deleted gate id %d", adminid != INVALID_PLAYER_ID ? GetPlayerNameEx(adminid) : ("(Inactive Player Resource System)"), gateid);
	Log("logs/gedit.log", szMiscArray);
	return 1;
}