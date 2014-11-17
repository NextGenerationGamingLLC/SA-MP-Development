/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

					Dynamic Arrestpoint System 

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

CMD:arrestedit(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] >= 4)
	{
		new string[128], choice[32], id, amount;
		if(sscanf(params, "s[32]dD", choice, id, amount))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /arrestedit [name] [id] [amount]");
			SendClientMessageEx(playerid, COLOR_GREY, "Available names: Position, Type, jailpos1, jailpos2, Delete");
			return 1;
		}

		if(id >= MAX_ARRESTPOINTS)
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "Invalid Arrest Points ID!");
			return 1;
		}

		if(strcmp(choice, "position", true) == 0)
		{
			GetPlayerPos(playerid, ArrestPoints[id][arrestPosX], ArrestPoints[id][arrestPosY], ArrestPoints[id][arrestPosZ]);
			ArrestPoints[id][arrestInt] = GetPlayerInterior(playerid);
			ArrestPoints[id][arrestVW] = GetPlayerVirtualWorld(playerid);
			format(string, sizeof(string), "You have changed the position on Arrest Point #%d.", id);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			DestroyDynamic3DTextLabel(ArrestPoints[id][arrestTextID]);
			DestroyDynamicPickup(ArrestPoints[id][arrestPickupID]);
			switch(ArrestPoints[id][arrestType])
			{
				case 0:
				{
					format(string, sizeof(string), "/arrest\nArrest Point #%d", id);
					ArrestPoints[id][arrestTextID] = CreateDynamic3DTextLabel(string, COLOR_DBLUE, ArrestPoints[id][arrestPosX], ArrestPoints[id][arrestPosY], ArrestPoints[id][arrestPosZ]+0.6, 4.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, ArrestPoints[id][arrestVW], ArrestPoints[id][arrestInt], -1);
					ArrestPoints[id][arrestPickupID] = CreateDynamicPickup(1247, 23, ArrestPoints[id][arrestPosX], ArrestPoints[id][arrestPosY], ArrestPoints[id][arrestPosZ], ArrestPoints[id][arrestVW]);
				}
				case 2:
				{
					format(string, sizeof(string), "/docarrest\nArrest Point #%d", id);
					ArrestPoints[id][arrestTextID] = CreateDynamic3DTextLabel(string, COLOR_DBLUE, ArrestPoints[id][arrestPosX], ArrestPoints[id][arrestPosY], ArrestPoints[id][arrestPosZ]+0.6, 4.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, ArrestPoints[id][arrestVW], ArrestPoints[id][arrestInt], -1);
					ArrestPoints[id][arrestPickupID] = CreateDynamicPickup(1247, 23, ArrestPoints[id][arrestPosX], ArrestPoints[id][arrestPosY], ArrestPoints[id][arrestPosZ], ArrestPoints[id][arrestVW]);
				}
				case 3:
				{
					format(string, sizeof(string), "/warrantarrest\nArrest Point #%d", id);
					ArrestPoints[id][arrestTextID] = CreateDynamic3DTextLabel(string, COLOR_DBLUE, ArrestPoints[id][arrestPosX], ArrestPoints[id][arrestPosY], ArrestPoints[id][arrestPosZ]+0.6, 4.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, ArrestPoints[id][arrestVW], ArrestPoints[id][arrestInt], -1);
					ArrestPoints[id][arrestPickupID] = CreateDynamicPickup(1247, 23, ArrestPoints[id][arrestPosX], ArrestPoints[id][arrestPosY], ArrestPoints[id][arrestPosZ], ArrestPoints[id][arrestVW]);
				}
				case 4:
				{
					format(string, sizeof(string), "/jarrest\nArrest Point #%d", id);
					ArrestPoints[id][arrestTextID] = CreateDynamic3DTextLabel(string, COLOR_DBLUE, ArrestPoints[id][arrestPosX], ArrestPoints[id][arrestPosY], ArrestPoints[id][arrestPosZ]+0.6, 4.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, ArrestPoints[id][arrestVW], ArrestPoints[id][arrestInt], -1);
					ArrestPoints[id][arrestPickupID] = CreateDynamicPickup(1247, 23, ArrestPoints[id][arrestPosX], ArrestPoints[id][arrestPosY], ArrestPoints[id][arrestPosZ], ArrestPoints[id][arrestVW]);
				}
			}
			SaveArrestPoint(id);
			format(string, sizeof(string), "%s has edited Arrest Point ID %d's position.", GetPlayerNameEx(playerid), id);
			Log("logs/arrestedit.log", string);
			return 1;
		}
		else if(strcmp(choice, "type", true) == 0)
		{
			if(ArrestPoints[id][arrestPosX] == 0)
			{
				format(string, sizeof(string), "Arrest Point #%d does not exist.", id);
				SendClientMessageEx(playerid, COLOR_WHITE, string);
				return 1;
			}
			ArrestPoints[id][arrestType] = amount;
			format(string, sizeof(string), "You have changed the type for Arrest Point #%d to %d.", id, amount);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			DestroyDynamic3DTextLabel(ArrestPoints[id][arrestTextID]);
			DestroyDynamicPickup(ArrestPoints[id][arrestPickupID]);
			switch(ArrestPoints[id][arrestType])
			{
				case 0:
				{
					format(string, sizeof(string), "/arrest\nArrest Point #%d", id);
					ArrestPoints[id][arrestTextID] = CreateDynamic3DTextLabel(string, COLOR_DBLUE, ArrestPoints[id][arrestPosX], ArrestPoints[id][arrestPosY], ArrestPoints[id][arrestPosZ]+0.6, 4.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, ArrestPoints[id][arrestVW], ArrestPoints[id][arrestInt], -1);
					ArrestPoints[id][arrestPickupID] = CreateDynamicPickup(1247, 23, ArrestPoints[id][arrestPosX], ArrestPoints[id][arrestPosY], ArrestPoints[id][arrestPosZ], ArrestPoints[id][arrestVW]);
				}
				case 2:
				{
					format(string, sizeof(string), "/docarrest\nArrest Point #%d", id);
					ArrestPoints[id][arrestTextID] = CreateDynamic3DTextLabel(string, COLOR_DBLUE, ArrestPoints[id][arrestPosX], ArrestPoints[id][arrestPosY], ArrestPoints[id][arrestPosZ]+0.6, 4.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, ArrestPoints[id][arrestVW], ArrestPoints[id][arrestInt], -1);
					ArrestPoints[id][arrestPickupID] = CreateDynamicPickup(1247, 23, ArrestPoints[id][arrestPosX], ArrestPoints[id][arrestPosY], ArrestPoints[id][arrestPosZ], ArrestPoints[id][arrestVW]);
				}
				case 3:
				{
					format(string, sizeof(string), "/warrantarrest\nArrest Point #%d", id);
					ArrestPoints[id][arrestTextID] = CreateDynamic3DTextLabel(string, COLOR_DBLUE, ArrestPoints[id][arrestPosX], ArrestPoints[id][arrestPosY], ArrestPoints[id][arrestPosZ]+0.6, 4.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, ArrestPoints[id][arrestVW], ArrestPoints[id][arrestInt], -1);
					ArrestPoints[id][arrestPickupID] = CreateDynamicPickup(1247, 23, ArrestPoints[id][arrestPosX], ArrestPoints[id][arrestPosY], ArrestPoints[id][arrestPosZ], ArrestPoints[id][arrestVW]);
				}
				case 4:
				{
					format(string, sizeof(string), "/jarrest\nArrest Point #%d", id);
					ArrestPoints[id][arrestTextID] = CreateDynamic3DTextLabel(string, COLOR_DBLUE, ArrestPoints[id][arrestPosX], ArrestPoints[id][arrestPosY], ArrestPoints[id][arrestPosZ]+0.6, 4.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, ArrestPoints[id][arrestVW], ArrestPoints[id][arrestInt], -1);
					ArrestPoints[id][arrestPickupID] = CreateDynamicPickup(1247, 23, ArrestPoints[id][arrestPosX], ArrestPoints[id][arrestPosY], ArrestPoints[id][arrestPosZ], ArrestPoints[id][arrestVW]);
				}
			}
			SaveArrestPoint(id);
			format(string, sizeof(string), "%s has changed the type on Arrest Point ID %d to %d.", GetPlayerNameEx(playerid), id, amount);
			Log("logs/arrestedit.log", string);
			return 1;
		}
		else if(strcmp(choice, "jailpos1", true) == 0) 
		{
			if(ArrestPoints[id][arrestPosX] == 0)
			{
				format(string, sizeof(string), "Arrest Point #%d does not exist.", id);
				SendClientMessageEx(playerid, COLOR_WHITE, string);
				return 1;
			}
			GetPlayerPos(playerid, ArrestPoints[id][JailPos1][0], ArrestPoints[id][JailPos1][1], ArrestPoints[id][JailPos1][2]);
			ArrestPoints[id][jailVW] = GetPlayerVirtualWorld(playerid);
			ArrestPoints[id][jailInt] = GetPlayerInterior(playerid);
			format(string, sizeof(string), "You have changed the jail cell position 1 on Arrest Point #%d.", id);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SaveArrestPoint(id);
			format(string, sizeof(string), "%s has changed the jail cell position 1 on Arrest Point ID %d.", GetPlayerNameEx(playerid), id);
			Log("logs/arrestedit.log", string);
		}
		else if(strcmp(choice, "jailpos2", true) == 0) 
		{
			if(ArrestPoints[id][arrestPosX] == 0)
			{
				format(string, sizeof(string), "Arrest Point #%d does not exist.", id);
				SendClientMessageEx(playerid, COLOR_WHITE, string);
				return 1;
			}
			GetPlayerPos(playerid, ArrestPoints[id][JailPos2][0], ArrestPoints[id][JailPos2][1], ArrestPoints[id][JailPos2][2]);
			ArrestPoints[id][jailVW] = GetPlayerVirtualWorld(playerid);
			ArrestPoints[id][jailInt] = GetPlayerInterior(playerid);
			format(string, sizeof(string), "You have changed the jail cell position 2 on Arrest Point #%d.", id);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SaveArrestPoint(id);
			format(string, sizeof(string), "%s has changed the jail cell position 2 on Arrest Point ID %d.", GetPlayerNameEx(playerid), id);
			Log("logs/arrestedit.log", string);
		}
		else if(strcmp(choice, "delete", true) == 0)
		{
			if(ArrestPoints[id][arrestPosX] == 0)
			{
				format(string, sizeof(string), "Arrest Point #%d does not exist.", id);
				SendClientMessageEx(playerid, COLOR_WHITE, string);
				return 1;
			}
			DestroyDynamic3DTextLabel(ArrestPoints[id][arrestTextID]);
			DestroyDynamicPickup(ArrestPoints[id][arrestPickupID]);
			ArrestPoints[id][arrestPosX] = 0.0;
			ArrestPoints[id][arrestPosY] = 0.0;
			ArrestPoints[id][arrestPosZ] = 0.0;
			ArrestPoints[id][arrestVW] = 0;
			ArrestPoints[id][arrestInt] = 0;
			ArrestPoints[id][arrestType] = 0;
			SaveArrestPoint(id);
			format(string, sizeof(string), "You have deleted Arrest Point #%d.", id);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			format(string, sizeof(string), "%s has deleted Arrest Point ID %d.", GetPlayerNameEx(playerid), id);
			Log("logs/arrestedit.log", string);
			return 1;
		}
	}
	else SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	return 1;
}

CMD:arreststatus(playerid, params[])
{
	new id;
	if(sscanf(params, "i", id))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /arreststatus [id]");
		return 1;
	}
	if (PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pFactionModerator] >= 1)
	{
		new string[128];
		format(string,sizeof(string),"|___________ Arrest Point Status (ID: %d) ___________|", id);
		SendClientMessageEx(playerid, COLOR_GREEN, string);
		format(string, sizeof(string), "[Position] X: %f | Y: %f | Z: %f | VW: %d | Int: %d | Type: %d", ArrestPoints[id][arrestPosX], ArrestPoints[id][arrestPosY], ArrestPoints[id][arrestPosZ], ArrestPoints[id][arrestVW], ArrestPoints[id][arrestInt], ArrestPoints[id][arrestType]);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "[JailPos 1] X: %f | Y: %f | Z: %f | VW: %d | Int: %d", ArrestPoints[id][JailPos1][0], ArrestPoints[id][JailPos1][1], ArrestPoints[id][JailPos1][2], ArrestPoints[id][jailVW], ArrestPoints[id][jailInt]);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "[JailPos 2] X: %f | Y: %f | Z: %f", ArrestPoints[id][JailPos2][0], ArrestPoints[id][JailPos2][1], ArrestPoints[id][JailPos2][2]);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	}
	return 1;
}

CMD:arrestnext(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 4)
	{
		SendClientMessageEx(playerid, COLOR_RED, "* Listing next available Arrest Point...");
		for(new x = 0; x < MAX_ARRESTPOINTS; x++)
		{
			if(ArrestPoints[x][arrestPosX] == 0)
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

CMD:gotoarrestpoint(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pFactionModerator] >= 1)
	{
		new id;
		if(sscanf(params, "d", id)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /gotoarrestpoint [id]");

		SetPlayerPos(playerid, ArrestPoints[id][arrestPosX], ArrestPoints[id][arrestPosY], ArrestPoints[id][arrestPosZ]);
		SetPlayerInterior(playerid, ArrestPoints[id][arrestInt]);
		PlayerInfo[playerid][pInt] = ArrestPoints[id][arrestInt];
		SetPlayerVirtualWorld(playerid, ArrestPoints[id][arrestVW]);
		PlayerInfo[playerid][pVW] = ArrestPoints[id][arrestVW];
	}
	return 1;
}
