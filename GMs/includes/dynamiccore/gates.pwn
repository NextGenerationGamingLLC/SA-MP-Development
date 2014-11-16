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

CMD:gate(playerid, params[])
{
	new Float:X, Float:Y, Float:Z;
	for(new i = 0; i < sizeof(GateInfo); i++)
	{
		GetDynamicObjectPos(GateInfo[i][gGATE], X, Y, Z);
		if(GateInfo[i][gFamilyID] != -1 && PlayerInfo[playerid][pFMember] == GateInfo[i][gFamilyID] && IsPlayerInRangeOfPoint(playerid,GateInfo[i][gRange], X, Y, Z) && GetPlayerVirtualWorld(playerid) == GateInfo[i][gVW] && GetPlayerInterior(playerid) == GateInfo[i][gInt])
		{
			if(GateInfo[i][gLocked] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "This gate is currently locked.");
			if(GateInfo[i][gAutomate] == 1) return 1;
			MoveGate(playerid, i);
		}
		else if(GateInfo[i][gGroupID] != -1 && (0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS) && PlayerInfo[playerid][pMember] == GateInfo[i][gGroupID] && IsPlayerInRangeOfPoint(playerid,GateInfo[i][gRange], X, Y, Z) && GetPlayerVirtualWorld(playerid) == GateInfo[i][gVW] && GetPlayerInterior(playerid) == GateInfo[i][gInt])
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

CMD:gsave(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pShopTech] >= 1)
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