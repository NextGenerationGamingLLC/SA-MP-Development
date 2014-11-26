/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

					Dynamic Door System

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

stock SaveDynamicDoors()
{
	for(new i = 0; i < MAX_DDOORS; i++)
	{
		SaveDynamicDoor(i);
	}
	return 1;
}

stock RehashDynamicDoor(doorid)
{
	DestroyDynamicPickup(DDoorsInfo[doorid][ddPickupID]);
	if(IsValidDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID])) DestroyDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID]);
	DDoorsInfo[doorid][ddSQLId] = -1;
	DDoorsInfo[doorid][ddOwner] = -1;
	DDoorsInfo[doorid][ddCustomInterior] = 0;
	DDoorsInfo[doorid][ddExteriorVW] = 0;
	DDoorsInfo[doorid][ddExteriorInt] = 0;
	DDoorsInfo[doorid][ddInteriorVW] = 0;
	DDoorsInfo[doorid][ddInteriorInt] = 0;
	DDoorsInfo[doorid][ddExteriorX] = 0.0;
	DDoorsInfo[doorid][ddExteriorY] = 0.0;
	DDoorsInfo[doorid][ddExteriorZ] = 0.0;
	DDoorsInfo[doorid][ddExteriorA] = 0.0;
	DDoorsInfo[doorid][ddInteriorX] = 0.0;
	DDoorsInfo[doorid][ddInteriorY] = 0.0;
	DDoorsInfo[doorid][ddInteriorZ] = 0.0;
	DDoorsInfo[doorid][ddInteriorA] = 0.0;
	DDoorsInfo[doorid][ddCustomExterior] = 0;
	DDoorsInfo[doorid][ddType] = 0;
	DDoorsInfo[doorid][ddRank] = 0;
	DDoorsInfo[doorid][ddVIP] = 0;
	DDoorsInfo[doorid][ddAllegiance] = 0;
	DDoorsInfo[doorid][ddGroupType] = 0;
	DDoorsInfo[doorid][ddFamily] = 0;
	DDoorsInfo[doorid][ddFaction] = 0;
	DDoorsInfo[doorid][ddAdmin] = 0;
	DDoorsInfo[doorid][ddWanted] = 0;
	DDoorsInfo[doorid][ddVehicleAble] = 0;
	DDoorsInfo[doorid][ddColor] = 0;
	DDoorsInfo[doorid][ddPickupModel] = 0;
	DDoorsInfo[doorid][ddLocked] = 0;
	LoadDynamicDoor(doorid);
}

stock RehashDynamicDoors()
{
	printf("[RehashDynamicDoors] Deleting dynamic doors from server...");
	for(new i = 0; i < MAX_DDOORS; i++)
	{
		RehashDynamicDoor(i);
	}
	LoadDynamicDoors();
}

CMD:changedoorpass(playerid, params[])
{
    for(new i = 0; i < sizeof(DDoorsInfo); i++) {
        if (IsPlayerInRangeOfPoint(playerid,3.0,DDoorsInfo[i][ddExteriorX], DDoorsInfo[i][ddExteriorY], DDoorsInfo[i][ddExteriorZ]) && PlayerInfo[playerid][pVW] == DDoorsInfo[i][ddExteriorVW] || IsPlayerInRangeOfPoint(playerid,3.0,DDoorsInfo[i][ddInteriorX], DDoorsInfo[i][ddInteriorY], DDoorsInfo[i][ddInteriorZ]) && PlayerInfo[playerid][pVW] == DDoorsInfo[i][ddInteriorVW])
		{
			new doorpass[24];
			if(sscanf(params, "s[24]", doorpass)) { SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /changedoorpass [pass]"); SendClientMessageEx(playerid, COLOR_WHITE, "To remove the password on the door set the password to 'none'."); return 1; }
        	if(DDoorsInfo[i][ddType] == 2 && DDoorsInfo[i][ddFaction] != INVALID_GROUP_ID && PlayerInfo[playerid][pLeader] == DDoorsInfo[i][ddFaction])
			{
				format(DDoorsInfo[i][ddPass], 24, "%s", doorpass);
				SendClientMessageEx(playerid, COLOR_WHITE, "You have changed the password of this door.");
				SaveDynamicDoor(i);
			}
			else if(DDoorsInfo[i][ddType] == 3 && DDoorsInfo[i][ddFamily] != INVALID_FAMILY_ID && PlayerInfo[playerid][pFMember] == DDoorsInfo[i][ddFamily] && PlayerInfo[playerid][pRank] == 6)
			{
				format(DDoorsInfo[i][ddPass], 24, "%s", doorpass);
				SendClientMessageEx(playerid, COLOR_WHITE, "You have changed the password of this door.");
				SaveDynamicDoor(i);
			}
			else if(DDoorsInfo[i][ddType] == 1 && DDoorsInfo[i][ddOwner] == GetPlayerSQLId(playerid))
			{
				format(DDoorsInfo[i][ddPass], 24, "%s", doorpass);
				SendClientMessageEx(playerid, COLOR_WHITE, "You have changed the password of this door.");
				SaveDynamicDoor(i);
			}
			else SendClientMessageEx(playerid, COLOR_GREY, "You cannot change the password on this lock.");
		}
	}
	return 1;
}

CMD:lockdoor(playerid, params[])
{
    for(new i = 0; i < sizeof(DDoorsInfo); i++) {
        if (IsPlayerInRangeOfPoint(playerid,3.0,DDoorsInfo[i][ddExteriorX], DDoorsInfo[i][ddExteriorY], DDoorsInfo[i][ddExteriorZ]) && PlayerInfo[playerid][pVW] == DDoorsInfo[i][ddExteriorVW] || IsPlayerInRangeOfPoint(playerid,3.0,DDoorsInfo[i][ddInteriorX], DDoorsInfo[i][ddInteriorY], DDoorsInfo[i][ddInteriorZ]) && PlayerInfo[playerid][pVW] == DDoorsInfo[i][ddInteriorVW])
		{
        	if(DDoorsInfo[i][ddType] == 2 && DDoorsInfo[i][ddFaction] != INVALID_GROUP_ID && PlayerInfo[playerid][pLeader] == DDoorsInfo[i][ddFaction])
			{
				if(DDoorsInfo[i][ddLocked] == 0)
				{
					DDoorsInfo[i][ddLocked] = 1;
					SendClientMessageEx(playerid, COLOR_WHITE, "This door has been locked.");
				}
				else if(DDoorsInfo[i][ddLocked] == 1)
				{
					DDoorsInfo[i][ddLocked] = 0;
					SendClientMessageEx(playerid, COLOR_GREY, "This door has been unlocked.");
				}
			}
			else if(DDoorsInfo[i][ddType] == 3 && DDoorsInfo[i][ddFamily] != INVALID_FAMILY_ID && PlayerInfo[playerid][pFMember] == DDoorsInfo[i][ddFamily] && PlayerInfo[playerid][pRank] == 6)
			{
				if(DDoorsInfo[i][ddLocked] == 0)
				{
					DDoorsInfo[i][ddLocked] = 1;
					SendClientMessageEx(playerid, COLOR_WHITE, "This door has been locked.");
				}
				else if(DDoorsInfo[i][ddLocked] == 1)
				{
					DDoorsInfo[i][ddLocked] = 0;
					SendClientMessageEx(playerid, COLOR_GREY, "This door has been unlocked.");
				}
			}
			else if(DDoorsInfo[i][ddType] == 1 && DDoorsInfo[i][ddOwner] == GetPlayerSQLId(playerid))
			{
				if(DDoorsInfo[i][ddLocked] == 0)
				{
					DDoorsInfo[i][ddLocked] = 1;
					SendClientMessageEx(playerid, COLOR_WHITE, "This door has been locked.");
				}
				else if(DDoorsInfo[i][ddLocked] == 1)
				{
					DDoorsInfo[i][ddLocked] = 0;
					SendClientMessageEx(playerid, COLOR_GREY, "This door has been unlocked.");
				}
			}
			else SendClientMessageEx(playerid, COLOR_GREY, "You cannot lock this door.");
		}
	}
	return 1;
}

CMD:doorpass(playerid, params[])
{
    for(new i = 0; i < sizeof(DDoorsInfo); i++) {
        if (IsPlayerInRangeOfPoint(playerid,3.0,DDoorsInfo[i][ddExteriorX], DDoorsInfo[i][ddExteriorY], DDoorsInfo[i][ddExteriorZ]) && PlayerInfo[playerid][pVW] == DDoorsInfo[i][ddExteriorVW] || IsPlayerInRangeOfPoint(playerid,3.0,DDoorsInfo[i][ddInteriorX], DDoorsInfo[i][ddInteriorY], DDoorsInfo[i][ddInteriorZ]) && PlayerInfo[playerid][pVW] == DDoorsInfo[i][ddInteriorVW]) {
        	if(DDoorsInfo[i][ddPass] < 1)
                return SendClientMessageEx(playerid, COLOR_GREY, "This door isn't allowed to be locked");
         	if(strcmp(DDoorsInfo[i][ddPass], "None", true) == 0)
                return SendClientMessageEx(playerid, COLOR_GREY, "This door isn't allowed to be locked");

			ShowPlayerDialog(playerid, DOORLOCK, DIALOG_STYLE_INPUT, "Door Security","Enter the password for this door","Login","Cancel");
			SetPVarInt(playerid, "Door", i);
		}
	}
	return 1;
}

CMD:goindoor(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pShopTech] >= 1)
	{
		new string[48], doornum;
		if(sscanf(params, "d", doornum)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /goindoor [doornumber]");

		if(doornum <= 0 || doornum >= MAX_DDOORS)
		{
			format(string, sizeof(string), "Door ID must be between 1 and %d.", MAX_DDOORS - 1);
			return SendClientMessageEx(playerid, COLOR_GREY, string);
		}

		SetPlayerInterior(playerid,DDoorsInfo[doornum][ddInteriorInt]);
		SetPlayerPos(playerid,DDoorsInfo[doornum][ddInteriorX],DDoorsInfo[doornum][ddInteriorY],DDoorsInfo[doornum][ddInteriorZ]);
		SetPlayerFacingAngle(playerid,DDoorsInfo[doornum][ddInteriorA]);
		PlayerInfo[playerid][pInt] = DDoorsInfo[doornum][ddInteriorInt];
		PlayerInfo[playerid][pVW] = DDoorsInfo[doornum][ddInteriorVW];
		SetPlayerVirtualWorld(playerid, DDoorsInfo[doornum][ddInteriorVW]);
		if(DDoorsInfo[doornum][ddCustomInterior]) Player_StreamPrep(playerid, DDoorsInfo[doornum][ddInteriorX],DDoorsInfo[doornum][ddInteriorY],DDoorsInfo[doornum][ddInteriorZ], FREEZE_TIME);
	}
	return 1;
}

CMD:gotodoor(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pShopTech] >= 1)
	{
		new string[48], doornum;
		if(sscanf(params, "d", doornum)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /gotodoor [doornumber]");

		if(doornum <= 0 || doornum >= MAX_DDOORS)
		{
			format(string, sizeof(string), "Door ID must be between 1 and %d.", MAX_DDOORS - 1);
			return SendClientMessageEx(playerid, COLOR_GREY, string);
		}

		SetPlayerInterior(playerid,DDoorsInfo[doornum][ddExteriorInt]);
		SetPlayerPos(playerid,DDoorsInfo[doornum][ddExteriorX],DDoorsInfo[doornum][ddExteriorY],DDoorsInfo[doornum][ddExteriorZ]);
		SetPlayerFacingAngle(playerid,DDoorsInfo[doornum][ddExteriorA]);
		PlayerInfo[playerid][pInt] = DDoorsInfo[doornum][ddExteriorInt];
		SetPlayerVirtualWorld(playerid, DDoorsInfo[doornum][ddExteriorVW]);
		PlayerInfo[playerid][pVW] = DDoorsInfo[doornum][ddExteriorVW];
		if(DDoorsInfo[doornum][ddCustomExterior]) Player_StreamPrep(playerid, DDoorsInfo[doornum][ddExteriorX],DDoorsInfo[doornum][ddExteriorY],DDoorsInfo[doornum][ddExteriorZ], FREEZE_TIME);
	}
	return 1;
}

CMD:ddstatus(playerid, params[])
{
	new doorid;
	if(sscanf(params, "i", doorid))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /ddstatus [doorid]");
		return 1;
	}
	if (PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pShopTech] >= 1)
	{
		new string[128];
		format(string,sizeof(string),"|___________ Door Status (ID: %d) ___________|", doorid);
		SendClientMessageEx(playerid, COLOR_GREEN, string);
		format(string, sizeof(string), "(Ext) X: %f | Y: %f | Z: %f | (Int) X: %f | Y: %f | Z: %f", DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddInteriorX], DDoorsInfo[doorid][ddInteriorY], DDoorsInfo[doorid][ddInteriorZ]);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "Pickup ID: %d | Custom Int: %d | Custom Ext: %d | Exterior VW: %d | Exterior Int: %d | Interior VW: %d | Interior Int: %d", DDoorsInfo[doorid][ddPickupID], DDoorsInfo[doorid][ddCustomInterior], DDoorsInfo[doorid][ddCustomExterior], DDoorsInfo[doorid][ddExteriorVW], DDoorsInfo[doorid][ddExteriorInt], DDoorsInfo[doorid][ddInteriorVW], DDoorsInfo[doorid][ddInteriorInt]);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "Type: %d | Rank: %d | VIP: %d | Allegiance: %d | Group Type: %d | Family: %d | Faction: %d | Admin: %d | Wanted: %d", DDoorsInfo[doorid][ddType], DDoorsInfo[doorid][ddRank], DDoorsInfo[doorid][ddVIP], DDoorsInfo[doorid][ddAllegiance], DDoorsInfo[doorid][ddGroupType], DDoorsInfo[doorid][ddFamily], DDoorsInfo[doorid][ddFaction], DDoorsInfo[doorid][ddAdmin], DDoorsInfo[doorid][ddWanted]);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "Vehiclable: %d | Locked: %d | Password: %s", DDoorsInfo[doorid][ddVehicleAble], DDoorsInfo[doorid][ddLocked], DDoorsInfo[doorid][ddPass]);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	}
	return 1;
}

CMD:ddnear(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pShopTech] >= 1)
	{
		new option;
		if(!sscanf(params, "d", option)) 
		{
			new string[64];
			format(string, sizeof(string), "* Listing all dynamic doors within 30 meters of you in VW %d...", option);
			SendClientMessageEx(playerid, COLOR_RED, string);
			for(new i, szMessage[128]; i < MAX_DDOORS; i++)
			{
				if(strcmp(DDoorsInfo[i][ddDescription], "None", true) != 0)
				{
					if(IsPlayerInRangeOfPoint(playerid, 30, DDoorsInfo[i][ddInteriorX], DDoorsInfo[i][ddInteriorY], DDoorsInfo[i][ddInteriorZ]) && DDoorsInfo[i][ddInteriorVW] == option)
					{
						format(szMessage, sizeof(szMessage), "(Interior) DDoor ID %d | %f from you | Interior: %d", i, GetPlayerDistanceFromPoint(playerid, DDoorsInfo[i][ddInteriorX], DDoorsInfo[i][ddInteriorY], DDoorsInfo[i][ddInteriorZ]), DDoorsInfo[i][ddInteriorInt]);
						SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
					}
					if(IsPlayerInRangeOfPoint(playerid, 30, DDoorsInfo[i][ddExteriorX], DDoorsInfo[i][ddExteriorY], DDoorsInfo[i][ddExteriorZ]) && DDoorsInfo[i][ddExteriorVW] == option)
					{
						format(szMessage, sizeof(szMessage), "(Exterior) DDoor ID %d | %f from you | Interior: %d", i, GetPlayerDistanceFromPoint(playerid, DDoorsInfo[i][ddExteriorX], DDoorsInfo[i][ddExteriorY], DDoorsInfo[i][ddExteriorZ]), DDoorsInfo[i][ddExteriorInt]);
						SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
					}
				}
			}
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_RED, "* Listing all dynamic doors within 30 meters of you...");
			for(new i, szMessage[128]; i < MAX_DDOORS; i++)
			{
				if(strcmp(DDoorsInfo[i][ddDescription], "None", true) != 0)
				{
					if(IsPlayerInRangeOfPoint(playerid, 30, DDoorsInfo[i][ddInteriorX], DDoorsInfo[i][ddInteriorY], DDoorsInfo[i][ddInteriorZ]))
					{
						format(szMessage, sizeof(szMessage), "(Interior) DDoor ID %d | %f from you | Virtual World: %d | Interior: %d", i, GetPlayerDistanceFromPoint(playerid, DDoorsInfo[i][ddInteriorX], DDoorsInfo[i][ddInteriorY], DDoorsInfo[i][ddInteriorZ]), DDoorsInfo[i][ddInteriorVW], DDoorsInfo[i][ddInteriorInt]);
						SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
					}
					if(IsPlayerInRangeOfPoint(playerid, 30, DDoorsInfo[i][ddExteriorX], DDoorsInfo[i][ddExteriorY], DDoorsInfo[i][ddExteriorZ]))
					{
						format(szMessage, sizeof(szMessage), "(Exterior) DDoor ID %d | %f from you | Virtual World: %d | Interior: %d", i, GetPlayerDistanceFromPoint(playerid, DDoorsInfo[i][ddExteriorX], DDoorsInfo[i][ddExteriorY], DDoorsInfo[i][ddExteriorZ]), DDoorsInfo[i][ddExteriorVW], DDoorsInfo[i][ddExteriorInt]);
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

CMD:ddnext(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pShopTech] >= 1)
	{
		SendClientMessageEx(playerid, COLOR_RED, "* Listing next available dynamic door...");
		for(new x;x<MAX_DDOORS;x++)
		{
		    if(DDoorsInfo[x][ddExteriorX] == 0.0) // If the door is at blueberry!
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

CMD:ddname(playerid, params[]) {
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pShopTech] >= 1)
	{
		new
			szName[128],
			iDoorID;

		if(sscanf(params, "ds[128]", iDoorID, szName)) {
			return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /ddname [doorid] [name]");
		}
		else if(!(0 <= iDoorID <= MAX_DDOORS)) {
			return SendClientMessageEx(playerid, COLOR_GREY, "Invalid door specified.");
		}
		else if(strfind(szName, "\r") != -1 || strfind(szName, "\n") != -1) {
			return SendClientMessageEx(playerid, COLOR_GREY, "Newline characters are forbidden.");
		}

		strcat((DDoorsInfo[iDoorID][ddDescription][0] = 0, DDoorsInfo[iDoorID][ddDescription]), szName, 128);
		SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully changed the name of this door.");

		DestroyDynamicPickup(DDoorsInfo[iDoorID][ddPickupID]);
		if(IsValidDynamic3DTextLabel(DDoorsInfo[iDoorID][ddTextID])) DestroyDynamic3DTextLabel(DDoorsInfo[iDoorID][ddTextID]);
		CreateDynamicDoor(iDoorID);
		SaveDynamicDoor(iDoorID);

		format(szName, sizeof(szName), "%s has edited door ID %d's name to %s.", GetPlayerNameEx(playerid), iDoorID, DDoorsInfo[iDoorID][ddDescription]);
		Log("logs/ddedit.log", szName);
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use that command.");
	return 1;
}

CMD:ddowner(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pFactionModerator] >= 2 || PlayerInfo[playerid][pShopTech] >= 1)
	{
		new playername[MAX_PLAYER_NAME], doorid, szName[128];
		if(sscanf(params, "ds[24]", doorid, playername)) return SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /ddowner [door] [player name]");

		if(DDoorsInfo[doorid][ddType] != 1) return SendClientMessageEx(playerid, COLOR_GRAD1, "This door is not owned by a player!");

		new giveplayerid = ReturnUser(playername);
		if(IsPlayerConnected(giveplayerid))
		{
			strcat((DDoorsInfo[doorid][ddOwnerName][0] = 0, DDoorsInfo[doorid][ddOwnerName]), GetPlayerNameEx(giveplayerid), 24);
			DDoorsInfo[doorid][ddOwner] = GetPlayerSQLId(giveplayerid);
			SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully changed the owner of this door.");

			DestroyDynamicPickup(DDoorsInfo[doorid][ddPickupID]);
			if(IsValidDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID])) DestroyDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID]);
			CreateDynamicDoor(doorid);
			SaveDynamicDoor(doorid);
			
			format(szName, sizeof(szName), "%s has edited door ID %d's owner to %s (SQL ID: %d).", GetPlayerNameEx(playerid), doorid, GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid));
			Log("logs/ddedit.log", szName);
		}
		else
		{
			new query[128], tmpName[24];

			mysql_escape_string(playername, tmpName);
			format(query,sizeof(query), "SELECT `id`, `Username` FROM `accounts` WHERE `Username` = '%s'", tmpName);
			mysql_function_query(MainPipeline, query, true, "OnSetDDOwner", "ii", playerid, doorid);
		}
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command!");
	return 1;
}

CMD:ddpass(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pShopTech] < 1) return SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use that command.");

	new string[128],
		doorid,
		doorpass[24];

	if(sscanf(params, "ds[24]", doorid, doorpass)) { SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /ddPass [doorid] [pass]"); SendClientMessageEx(playerid, COLOR_WHITE, "To remove the password on the door set the password to 'none' "); return 1; }
	format(DDoorsInfo[doorid][ddPass], 24, "%s", doorpass);
	SendClientMessageEx(playerid, COLOR_WHITE, "You have changed the password of that door.");
	SaveDynamicDoor(doorid);
	format(string, sizeof(string), "%s has edited DoorID %d's password to %s.", GetPlayerNameEx(playerid), doorid, doorpass);
	Log("logs/ddedit.log", string);
	return 1;
}

CMD:ddedit(playerid, params[])
{
 	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pShopTech] >= 1)
	{
		new string[128], choice[32], doorid, amount;
		if(sscanf(params, "s[32]dD", choice, doorid, amount))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /ddedit [name] [doorid] [amount]");
			SendClientMessageEx(playerid, COLOR_GREY, "Available names: Exterior, Interior, CustomInterior, CustomExterior, Type, Rank, VIP, Famed");
			SendClientMessageEx(playerid, COLOR_GREY, "Allegiance, GroupType, Family, Faction, Wanted, Admin, VehicleAble, Color, PickupModel, Delete");
			return 1;
		}

		if(doorid >= MAX_DDOORS)
		{
			SendClientMessageEx( playerid, COLOR_WHITE, "Invalid Door ID!");
			return 1;
		}

		if(strcmp(choice, "interior", true) == 0)
		{
			GetPlayerPos(playerid, DDoorsInfo[doorid][ddInteriorX], DDoorsInfo[doorid][ddInteriorY], DDoorsInfo[doorid][ddInteriorZ]);
			GetPlayerFacingAngle(playerid, DDoorsInfo[doorid][ddInteriorA]);
			DDoorsInfo[doorid][ddInteriorInt] = GetPlayerInterior(playerid);
			DDoorsInfo[doorid][ddInteriorVW] = GetPlayerVirtualWorld(playerid);
			SendClientMessageEx(playerid, COLOR_WHITE, "You have changed the interior!");
			SaveDynamicDoor(doorid);
			format(string, sizeof(string), "%s has edited DoorID %d's Interior.", GetPlayerNameEx(playerid), doorid);
			Log("logs/ddedit.log", string);
			return 1;
		}
		else if(strcmp(choice, "custominterior", true) == 0)
		{
			if(DDoorsInfo[doorid][ddCustomInterior] == 0)
			{
				DDoorsInfo[doorid][ddCustomInterior] = 1;
				SendClientMessageEx(playerid, COLOR_WHITE, "Door set to custom interior!");
			}
			else
			{
				DDoorsInfo[doorid][ddCustomInterior] = 0;
				SendClientMessageEx(playerid, COLOR_WHITE, "Door set to normal (not custom) interior!");
			}
			SaveDynamicDoor(doorid);
			format(string, sizeof(string), "%s has edited DoorID %d's CustomInterior.", GetPlayerNameEx(playerid), doorid);
			Log("logs/ddedit.log", string);
			return 1;
		}
		else if(strcmp(choice, "customexterior", true) == 0)
		{
			if(DDoorsInfo[doorid][ddCustomExterior] == 0)
			{
				DDoorsInfo[doorid][ddCustomExterior] = 1;
				SendClientMessageEx(playerid, COLOR_WHITE, "Door set to custom exterior!");
			}
			else
			{
				DDoorsInfo[doorid][ddCustomExterior] = 0;
				SendClientMessageEx(playerid, COLOR_WHITE, "Door set to normal (not custom) exterior!");
			}
			SaveDynamicDoor(doorid);
			format(string, sizeof(string), "%s has edited DoorID %d's CustomExterior.", GetPlayerNameEx(playerid), doorid);
			Log("logs/ddedit.log", string);
			return 1;
		}
		else if(strcmp(choice, "exterior", true) == 0)
		{
			GetPlayerPos(playerid, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ]);
			GetPlayerFacingAngle(playerid, DDoorsInfo[doorid][ddExteriorA]);
			DDoorsInfo[doorid][ddExteriorVW] = GetPlayerVirtualWorld(playerid);
			DDoorsInfo[doorid][ddExteriorInt] = GetPlayerInterior(playerid);
			SendClientMessageEx(playerid, COLOR_WHITE, "You have changed the exterior!");
			DestroyDynamicPickup(DDoorsInfo[doorid][ddPickupID]);
			if(IsValidDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID])) DestroyDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID]);
			CreateDynamicDoor(doorid);
			SaveDynamicDoor(doorid);
			format(string, sizeof(string), "%s has edited DoorID %d's Exterior.", GetPlayerNameEx(playerid), doorid);
			Log("logs/ddedit.log", string);
		}
		else if(strcmp(choice, "type", true) == 0)
		{
			DDoorsInfo[doorid][ddType] = amount;

			format(string, sizeof(string), "You have changed the type to %d.", amount);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			switch(DDoorsInfo[doorid][ddType])
			{
				case 1:
				{
					if(DDoorsInfo[doorid][ddOwner] != -1 && strcmp(DDoorsInfo[doorid][ddOwnerName], "Nobody", false) != 0)
					{
						DestroyDynamicPickup(DDoorsInfo[doorid][ddPickupID]);
						if(IsValidDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID])) DestroyDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID]);
						CreateDynamicDoor(doorid);
					}
					else SendClientMessageEx(playerid, COLOR_GREY, "Use /ddowner to update the owner of this door.");
				}
				case 2:
				{
					if(DDoorsInfo[doorid][ddFaction] != INVALID_GROUP_ID)
					{
						DDoorsInfo[doorid][ddOwner] = -1;
						strcat((DDoorsInfo[doorid][ddOwnerName][0] = 0, DDoorsInfo[doorid][ddOwnerName]), arrGroupData[DDoorsInfo[doorid][ddFaction]][g_szGroupName], 42);
						DestroyDynamicPickup(DDoorsInfo[doorid][ddPickupID]);
						if(IsValidDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID])) DestroyDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID]);
						CreateDynamicDoor(doorid);
					}
					else SendClientMessageEx(playerid, COLOR_GREY, "Use /ddedit faction to update the owner of this door.");
				}
				case 3:
				{
					if(DDoorsInfo[doorid][ddFamily] != INVALID_GROUP_ID)
					{
						DDoorsInfo[doorid][ddOwner] = -1;
						strcat((DDoorsInfo[doorid][ddOwnerName][0] = 0, DDoorsInfo[doorid][ddOwnerName]), FamilyInfo[DDoorsInfo[doorid][ddFamily]][FamilyName], 42);
						DestroyDynamicPickup(DDoorsInfo[doorid][ddPickupID]);
						if(IsValidDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID])) DestroyDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID]);
						CreateDynamicDoor(doorid);
					}
					else SendClientMessageEx(playerid, COLOR_GREY, "Use /ddedit family to update the owner of this door.");
				}
				default:
				{
					strcat((DDoorsInfo[doorid][ddOwnerName][0] = 0, DDoorsInfo[doorid][ddOwnerName]), "Nobody", 42);
					DestroyDynamicPickup(DDoorsInfo[doorid][ddPickupID]);
					if(IsValidDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID])) DestroyDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID]);
					CreateDynamicDoor(doorid);
				}
			}
			SaveDynamicDoor(doorid);
			format(string, sizeof(string), "%s has edited DoorID %d's type.", GetPlayerNameEx(playerid), doorid);
			Log("logs/ddedit.log", string);
			return 1;
		}
		else if(strcmp(choice, "rank", true) == 0)
		{
			DDoorsInfo[doorid][ddRank] = amount;

			format(string, sizeof(string), "You have changed the rank to %d.", amount);
			SendClientMessageEx(playerid, COLOR_WHITE, string);

			SaveDynamicDoor(doorid);
			format(string, sizeof(string), "%s has edited DoorID %d's rank.", GetPlayerNameEx(playerid), doorid);
			Log("logs/ddedit.log", string);
			return 1;
		}
		else if(strcmp(choice, "vip", true) == 0)
		{
			DDoorsInfo[doorid][ddVIP] = amount;

			format(string, sizeof(string), "You have changed the VIP Level to %d.", amount);
			SendClientMessageEx(playerid, COLOR_WHITE, string);

			SaveDynamicDoor(doorid);
			format(string, sizeof(string), "%s has edited DoorID %d's VIP Level.", GetPlayerNameEx(playerid), doorid);
			Log("logs/ddedit.log", string);
			return 1;
		}
		else if(strcmp(choice, "famed", true) == 0)
		{
			DDoorsInfo[doorid][ddFamed] = amount;

			format(string, sizeof(string), "You have changed the Famed Level to %d.", amount);
			SendClientMessageEx(playerid, COLOR_WHITE, string);

			SaveDynamicDoor(doorid);
			format(string, sizeof(string), "%s has edited DoorID %d's Famed Level.", GetPlayerNameEx(playerid), doorid);
			Log("logs/ddedit.log", string);
			return 1;
		}
		else if(strcmp(choice, "dpc", true) == 0)
		{
			if(DDoorsInfo[doorid][ddDPC] == 0)
			{
				DDoorsInfo[doorid][ddDPC] = 1;
				SendClientMessageEx(playerid, COLOR_WHITE, "Door set to DPC!");
			}
			else
			{
				DDoorsInfo[doorid][ddDPC] = 0;
				SendClientMessageEx(playerid, COLOR_WHITE, "Door set to normal (no longer DPC)!");
			}
			SaveDynamicDoor(doorid);
			format(string, sizeof(string), "%s has set DoorID %d's DPC value.", GetPlayerNameEx(playerid), doorid);
			Log("logs/ddedit.log", string);
			return 1;
		}
		else if(strcmp(choice, "allegiance", true) == 0)
		{
			DDoorsInfo[doorid][ddAllegiance] = amount;

			format(string, sizeof(string), "You have changed the Allegiance to %d.", amount);
			SendClientMessageEx(playerid, COLOR_WHITE, string);

			SaveDynamicDoor(doorid);
			format(string, sizeof(string), "%s has edited DoorID %d's Allegiance to %d.", GetPlayerNameEx(playerid), doorid, amount);
			Log("logs/ddedit.log", string);
			return 1;
		}
		else if(strcmp(choice, "grouptype", true) == 0)
		{
			DDoorsInfo[doorid][ddGroupType] = amount;

			format(string, sizeof(string), "You have changed the Group Type to %d.", amount);
			SendClientMessageEx(playerid, COLOR_WHITE, string);

			SaveDynamicDoor(doorid);
			format(string, sizeof(string), "%s has edited DoorID %d's Group Type to %d.", GetPlayerNameEx(playerid), doorid, amount);
			Log("logs/ddedit.log", string);
			return 1;
		}
		else if(strcmp(choice, "family", true) == 0)
		{
			DDoorsInfo[doorid][ddFamily] = amount+1;

			format(string, sizeof(string), "You have changed the Family to %d.", amount);
			SendClientMessageEx(playerid, COLOR_WHITE, string);

			if(DDoorsInfo[doorid][ddType] == 3)
			{
				strcat((DDoorsInfo[doorid][ddOwnerName][0] = 0, DDoorsInfo[doorid][ddOwnerName]), FamilyInfo[DDoorsInfo[doorid][ddFamily]][FamilyName], 42);
				DestroyDynamicPickup(DDoorsInfo[doorid][ddPickupID]);
				if(IsValidDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID])) DestroyDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID]);
				CreateDynamicDoor(doorid);
			}
			else
			{
				format(string, sizeof(string), "Use '/ddedit type %d 3' to update the owner of this door.", doorid);
				SendClientMessageEx(playerid, COLOR_GREY, string);
			}

			SaveDynamicDoor(doorid);
			format(string, sizeof(string), "%s has edited DoorID %d's Family.", GetPlayerNameEx(playerid), doorid);
			Log("logs/ddedit.log", string);
			return 1;
		}
		else if(strcmp(choice, "faction", true) == 0)
		{
			DDoorsInfo[doorid][ddFaction] = amount-1;

			format(string, sizeof(string), "You have changed the Faction to %d.", amount);
			SendClientMessageEx(playerid, COLOR_WHITE, string);

			if(DDoorsInfo[doorid][ddType] == 2)
			{
				strcat((DDoorsInfo[doorid][ddOwnerName][0] = 0, DDoorsInfo[doorid][ddOwnerName]), arrGroupData[DDoorsInfo[doorid][ddFaction]][g_szGroupName], 42);
				DestroyDynamicPickup(DDoorsInfo[doorid][ddPickupID]);
				if(IsValidDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID])) DestroyDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID]);
				CreateDynamicDoor(doorid);
			}
			else
			{
				format(string, sizeof(string), "Use '/ddedit type %d 2' to update the owner of this door.", doorid);
				SendClientMessageEx(playerid, COLOR_GREY, string);
			}

			SaveDynamicDoor(doorid);
			format(string, sizeof(string), "%s has edited DoorID %d's Faction.", GetPlayerNameEx(playerid), doorid);
			Log("logs/ddedit.log", string);
			return 1;
		}
		else if(strcmp(choice, "admin", true) == 0)
		{
			DDoorsInfo[doorid][ddAdmin] = amount;

			format(string, sizeof(string), "You have changed the Admin Level to %d.", amount);
			SendClientMessageEx(playerid, COLOR_WHITE, string);

			SaveDynamicDoor(doorid);
			format(string, sizeof(string), "%s has edited DoorID %d's Admin Level.", GetPlayerNameEx(playerid), doorid);
			Log("logs/ddedit.log", string);
			return 1;
		}
		else if(strcmp(choice, "wanted", true) == 0)
		{
			DDoorsInfo[doorid][ddWanted] = amount;

			format(string, sizeof(string), "You have changed the Wanted to %d.", amount);
			SendClientMessageEx(playerid, COLOR_WHITE, string);

			SaveDynamicDoor(doorid);
			format(string, sizeof(string), "%s has edited DoorID %d's Wanted.", GetPlayerNameEx(playerid), doorid);
			Log("logs/ddedit.log", string);
			return 1;
		}
		else if(strcmp(choice, "vehicleable", true) == 0)
		{
			DDoorsInfo[doorid][ddVehicleAble] = amount;

			format(string, sizeof(string), "You have changed the VehicleAble to %d.", amount);
			SendClientMessageEx(playerid, COLOR_WHITE, string);

			SaveDynamicDoor(doorid);
			format(string, sizeof(string), "%s has edited DoorID %d's VehicleAble.", GetPlayerNameEx(playerid), doorid);
			Log("logs/ddedit.log", string);
			return 1;
		}
		else if(strcmp(choice, "color", true) == 0)
		{
			DDoorsInfo[doorid][ddColor] = amount;

			format(string, sizeof(string), "You have changed the Color to %d.", amount);
			SendClientMessageEx(playerid, COLOR_WHITE, string);

			DestroyDynamicPickup(DDoorsInfo[doorid][ddPickupID]);
			if(IsValidDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID])) DestroyDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID]);
			CreateDynamicDoor(doorid);

			SaveDynamicDoor(doorid);
			format(string, sizeof(string), "%s has edited DoorID %d's Color.", GetPlayerNameEx(playerid), doorid);
			Log("logs/ddedit.log", string);
			return 1;
		}
		else if(strcmp(choice, "pickupmodel", true) == 0)
		{
			DDoorsInfo[doorid][ddPickupModel] = amount;

			format(string, sizeof(string), "You have changed the PickupModel to %d.", amount);
			SendClientMessageEx(playerid, COLOR_WHITE, string);

			DestroyDynamicPickup(DDoorsInfo[doorid][ddPickupID]);
			if(IsValidDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID])) DestroyDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID]);
			CreateDynamicDoor(doorid);

			SaveDynamicDoor(doorid);
			format(string, sizeof(string), "%s has edited DoorID %d's PickupModel.", GetPlayerNameEx(playerid), doorid);
			Log("logs/ddedit.log", string);
			return 1;
		}
		else if(strcmp(choice, "delete", true) == 0)
		{
			if(strcmp(DDoorsInfo[doorid][ddDescription], "None", true) == 0) {
				format(string, sizeof(string), "DoorID %d does not exist.", doorid);
				SendClientMessageEx(playerid, COLOR_WHITE, string);
				return 1;
			}
			if(IsValidDynamicPickup(DDoorsInfo[doorid][ddPickupID])) DestroyDynamicPickup(DDoorsInfo[doorid][ddPickupID]);
			if(IsValidDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID])) DestroyDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID]);
			DDoorsInfo[doorid][ddDescription] = 0;
			DDoorsInfo[doorid][ddCustomInterior] = 0;
			DDoorsInfo[doorid][ddExteriorVW] = 0;
			DDoorsInfo[doorid][ddExteriorInt] = 0;
			DDoorsInfo[doorid][ddInteriorVW] = 0;
			DDoorsInfo[doorid][ddInteriorInt] = 0;
			DDoorsInfo[doorid][ddExteriorX] = 0;
			DDoorsInfo[doorid][ddExteriorY] = 0;
			DDoorsInfo[doorid][ddExteriorZ] = 0;
			DDoorsInfo[doorid][ddExteriorA] = 0;
			DDoorsInfo[doorid][ddInteriorX] = 0;
			DDoorsInfo[doorid][ddInteriorY] = 0;
			DDoorsInfo[doorid][ddInteriorZ] = 0;
			DDoorsInfo[doorid][ddInteriorA] = 0;
			DDoorsInfo[doorid][ddCustomExterior] = 0;
			DDoorsInfo[doorid][ddType] = 0;
			DDoorsInfo[doorid][ddRank] = 0;
			DDoorsInfo[doorid][ddVIP] = 0;
			DDoorsInfo[doorid][ddFamed] = 0;
			DDoorsInfo[doorid][ddDPC] = 0;
			DDoorsInfo[doorid][ddAllegiance] = 0;
			DDoorsInfo[doorid][ddGroupType] = 0;
			DDoorsInfo[doorid][ddFamily] = 0;
			DDoorsInfo[doorid][ddFaction] = 0;
			DDoorsInfo[doorid][ddAdmin] = 0;
			DDoorsInfo[doorid][ddWanted] = 0;
			DDoorsInfo[doorid][ddVehicleAble] = 0;
			DDoorsInfo[doorid][ddColor] = 0;
			DDoorsInfo[doorid][ddPass] = 0;
			DDoorsInfo[doorid][ddLocked] = 0;
			SaveDynamicDoor(doorid);
			format(string, sizeof(string), "You have deleted DoorID %d.", doorid);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			format(string, sizeof(string), "%s has deleted DoorID %d.", GetPlayerNameEx(playerid), doorid);
			Log("logs/ddedit.log", string);
			return 1;
		}
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use that command.");
	return 1;
}