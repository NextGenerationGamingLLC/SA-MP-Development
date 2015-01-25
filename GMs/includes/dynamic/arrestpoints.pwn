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

stock LoadArrestPoint(id)
{
	new string[128];
	format(string, sizeof(string), "SELECT * FROM `arrestpoints` WHERE `id`=%d", id);
	mysql_function_query(MainPipeline, string, true, "OnLoadArrestPoints", "i", id);
}

stock LoadArrestPoints()
{
	printf("[LoadArrestPoints] Loading data from database...");
	mysql_function_query(MainPipeline, "SELECT * FROM `arrestpoints`", true, "OnLoadArrestPoints", "");
}

forward OnLoadArrestPoint(index);
public OnLoadArrestPoint(index)
{
	new rows, fields, tmp[128], string[128];
	cache_get_data(rows, fields, MainPipeline);

	for(new row; row < rows; row++)
	{
		cache_get_field_content(row, "id", tmp, MainPipeline);  ArrestPoints[index][arrestSQLId] = strval(tmp);
		cache_get_field_content(row, "PosX", tmp, MainPipeline); ArrestPoints[index][arrestPosX] = floatstr(tmp);
		cache_get_field_content(row, "PosY", tmp, MainPipeline); ArrestPoints[index][arrestPosY] = floatstr(tmp);
		cache_get_field_content(row, "PosZ", tmp, MainPipeline); ArrestPoints[index][arrestPosZ] = floatstr(tmp);
		cache_get_field_content(row, "VW", tmp, MainPipeline); ArrestPoints[index][arrestVW] = strval(tmp);
		cache_get_field_content(row, "Int", tmp, MainPipeline); ArrestPoints[index][arrestInt] = strval(tmp);
		cache_get_field_content(row, "Type", tmp, MainPipeline); ArrestPoints[index][arrestType] = strval(tmp);
		if(ArrestPoints[index][arrestPosX] != 0)
		{
			switch(ArrestPoints[index][arrestType])
			{
				case 0:
				{
					format(string, sizeof(string), "/arrest\nArrest Point #%d", index);
					ArrestPoints[index][arrestTextID] = CreateDynamic3DTextLabel(string, COLOR_DBLUE, ArrestPoints[index][arrestPosX], ArrestPoints[index][arrestPosY], ArrestPoints[index][arrestPosZ]+0.6, 4.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, ArrestPoints[index][arrestVW], ArrestPoints[index][arrestInt], -1);
					ArrestPoints[index][arrestPickupID] = CreateDynamicPickup(1247, 23, ArrestPoints[index][arrestPosX], ArrestPoints[index][arrestPosY], ArrestPoints[index][arrestPosZ], ArrestPoints[index][arrestVW]);
				}
				case 2:
				{
					format(string, sizeof(string), "/docarrest\nArrest Point #%d", index);
					ArrestPoints[index][arrestTextID] = CreateDynamic3DTextLabel(string, COLOR_DBLUE, ArrestPoints[index][arrestPosX], ArrestPoints[index][arrestPosY], ArrestPoints[index][arrestPosZ]+0.6, 4.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, ArrestPoints[index][arrestVW], ArrestPoints[index][arrestInt], -1);
					ArrestPoints[index][arrestPickupID] = CreateDynamicPickup(1247, 23, ArrestPoints[index][arrestPosX], ArrestPoints[index][arrestPosY], ArrestPoints[index][arrestPosZ], ArrestPoints[index][arrestVW]);
				}
				case 3:
				{
					format(string, sizeof(string), "/warrantarrest\nArrest Point #%d", index);
					ArrestPoints[index][arrestTextID] = CreateDynamic3DTextLabel(string, COLOR_DBLUE, ArrestPoints[index][arrestPosX], ArrestPoints[index][arrestPosY], ArrestPoints[index][arrestPosZ]+0.6, 4.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, ArrestPoints[index][arrestVW], ArrestPoints[index][arrestInt], -1);
					ArrestPoints[index][arrestPickupID] = CreateDynamicPickup(1247, 23, ArrestPoints[index][arrestPosX], ArrestPoints[index][arrestPosY], ArrestPoints[index][arrestPosZ], ArrestPoints[index][arrestVW]);
				}
				case 4:
				{
					format(string, sizeof(string), "/jarrest\nArrest Point #%d", index);
					ArrestPoints[index][arrestTextID] = CreateDynamic3DTextLabel(string, COLOR_DBLUE, ArrestPoints[index][arrestPosX], ArrestPoints[index][arrestPosY], ArrestPoints[index][arrestPosZ]+0.6, 4.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, ArrestPoints[index][arrestVW], ArrestPoints[index][arrestInt], -1);
					ArrestPoints[index][arrestPickupID] = CreateDynamicPickup(1247, 23, ArrestPoints[index][arrestPosX], ArrestPoints[index][arrestPosY], ArrestPoints[index][arrestPosZ], ArrestPoints[index][arrestVW]);
				}
			}
		}
	}
	return 1;
}

forward OnLoadArrestPoints();
public OnLoadArrestPoints()
{
	new i, rows, fields, tmp[128], string[128];
	cache_get_data(rows, fields, MainPipeline);

	while(i < rows)
	{
		cache_get_field_content(i, "id", tmp, MainPipeline);  ArrestPoints[i][arrestSQLId] = strval(tmp);
		cache_get_field_content(i, "PosX", tmp, MainPipeline); ArrestPoints[i][arrestPosX] = floatstr(tmp);
		cache_get_field_content(i, "PosY", tmp, MainPipeline); ArrestPoints[i][arrestPosY] = floatstr(tmp);
		cache_get_field_content(i, "PosZ", tmp, MainPipeline); ArrestPoints[i][arrestPosZ] = floatstr(tmp);
		cache_get_field_content(i, "VW", tmp, MainPipeline); ArrestPoints[i][arrestVW] = strval(tmp);
		cache_get_field_content(i, "Int", tmp, MainPipeline); ArrestPoints[i][arrestInt] = strval(tmp);
		cache_get_field_content(i, "Type", tmp, MainPipeline); ArrestPoints[i][arrestType] = strval(tmp);
		cache_get_field_content(i, "jailVW", tmp, MainPipeline); ArrestPoints[i][jailVW] = strval(tmp);
		cache_get_field_content(i, "jailInt", tmp, MainPipeline); ArrestPoints[i][jailInt] = strval(tmp);
		cache_get_field_content(i, "jailpos1x", tmp, MainPipeline); ArrestPoints[i][JailPos1][0] = floatstr(tmp);
		cache_get_field_content(i, "jailpos1y", tmp, MainPipeline); ArrestPoints[i][JailPos1][1] = floatstr(tmp);
		cache_get_field_content(i, "jailpos1z", tmp, MainPipeline); ArrestPoints[i][JailPos1][2] = floatstr(tmp);
		cache_get_field_content(i, "jailpos2x", tmp, MainPipeline); ArrestPoints[i][JailPos2][0] = floatstr(tmp);
		cache_get_field_content(i, "jailpos2y", tmp, MainPipeline); ArrestPoints[i][JailPos2][1] = floatstr(tmp);
		cache_get_field_content(i, "jailpos2z", tmp, MainPipeline); ArrestPoints[i][JailPos2][2] = floatstr(tmp);
		if(ArrestPoints[i][arrestPosX] != 0)
		{
			switch(ArrestPoints[i][arrestType])
			{
				case 0:
				{
					format(string, sizeof(string), "/arrest\nArrest Point #%d", i);
					ArrestPoints[i][arrestTextID] = CreateDynamic3DTextLabel(string, COLOR_DBLUE, ArrestPoints[i][arrestPosX], ArrestPoints[i][arrestPosY], ArrestPoints[i][arrestPosZ]+0.6, 4.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, ArrestPoints[i][arrestVW], ArrestPoints[i][arrestInt], -1);
					ArrestPoints[i][arrestPickupID] = CreateDynamicPickup(1247, 23, ArrestPoints[i][arrestPosX], ArrestPoints[i][arrestPosY], ArrestPoints[i][arrestPosZ], ArrestPoints[i][arrestVW]);
				}
				case 2:
				{
					format(string, sizeof(string), "/docarrest\nArrest Point #%d", i);
					ArrestPoints[i][arrestTextID] = CreateDynamic3DTextLabel(string, COLOR_DBLUE, ArrestPoints[i][arrestPosX], ArrestPoints[i][arrestPosY], ArrestPoints[i][arrestPosZ]+0.6, 4.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, ArrestPoints[i][arrestVW], ArrestPoints[i][arrestInt], -1);
					ArrestPoints[i][arrestPickupID] = CreateDynamicPickup(1247, 23, ArrestPoints[i][arrestPosX], ArrestPoints[i][arrestPosY], ArrestPoints[i][arrestPosZ], ArrestPoints[i][arrestVW]);
				}
				case 3:
				{
					format(string, sizeof(string), "/warrantarrest\nArrest Point #%d", i);
					ArrestPoints[i][arrestTextID] = CreateDynamic3DTextLabel(string, COLOR_DBLUE, ArrestPoints[i][arrestPosX], ArrestPoints[i][arrestPosY], ArrestPoints[i][arrestPosZ]+0.6, 4.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, ArrestPoints[i][arrestVW], ArrestPoints[i][arrestInt], -1);
					ArrestPoints[i][arrestPickupID] = CreateDynamicPickup(1247, 23, ArrestPoints[i][arrestPosX], ArrestPoints[i][arrestPosY], ArrestPoints[i][arrestPosZ], ArrestPoints[i][arrestVW]);
				}
				case 4:
				{
					format(string, sizeof(string), "/jarrest\nArrest Point #%d", i);
					ArrestPoints[i][arrestTextID] = CreateDynamic3DTextLabel(string, COLOR_DBLUE, ArrestPoints[i][arrestPosX], ArrestPoints[i][arrestPosY], ArrestPoints[i][arrestPosZ]+0.6, 4.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, ArrestPoints[i][arrestVW], ArrestPoints[i][arrestInt], -1);
					ArrestPoints[i][arrestPickupID] = CreateDynamicPickup(1247, 23, ArrestPoints[i][arrestPosX], ArrestPoints[i][arrestPosY], ArrestPoints[i][arrestPosZ], ArrestPoints[i][arrestVW]);
				}
			}
		}
		i++;
	}
}

stock SaveArrestPoint(id)
{
	new string[1024];
	format(string, sizeof(string), "UPDATE `arrestpoints` SET \
		`PosX`=%f, \
		`PosY`=%f, \
		`PosZ`=%f, \
		`VW`=%d, \
		`Int`=%d, \
		`Type`=%d, \
		`jailVW`=%d, \
		`jailInt`=%d, \
		`jailpos1x`=%f, \
		`jailpos1y`=%f, \
		`jailpos1z`=%f, \
		`jailpos2x`=%f, \
		`jailpos2y`=%f, \
		`jailpos2z`=%f WHERE `id`=%d",
		ArrestPoints[id][arrestPosX],
		ArrestPoints[id][arrestPosY],
		ArrestPoints[id][arrestPosZ],
		ArrestPoints[id][arrestVW],
		ArrestPoints[id][arrestInt],
		ArrestPoints[id][arrestType],
		ArrestPoints[id][jailVW],
		ArrestPoints[id][jailInt],
		ArrestPoints[id][JailPos1][0],
		ArrestPoints[id][JailPos1][1],
		ArrestPoints[id][JailPos1][2],
		ArrestPoints[id][JailPos2][0],
		ArrestPoints[id][JailPos2][1],
		ArrestPoints[id][JailPos2][2],
		id
	);

	mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);
}

stock SaveArrestPoints()
{
	for(new i = 0; i < MAX_ARRESTPOINTS; i++)
	{
		SaveArrestPoint(i);
	}
	return 1;
}

stock RehashArrestPoint(id)
{
	DestroyDynamic3DTextLabel(ArrestPoints[id][arrestTextID]);
	DestroyDynamicPickup(ArrestPoints[id][arrestPickupID]);
	ArrestPoints[id][arrestSQLId] = -1;
	ArrestPoints[id][arrestPosX] = 0.0;
	ArrestPoints[id][arrestPosY] = 0.0;
	ArrestPoints[id][arrestPosZ] = 0.0;
	ArrestPoints[id][arrestVW] = 0;
	ArrestPoints[id][arrestInt] = 0;
	ArrestPoints[id][arrestType] = 0;
	LoadArrestPoint(id);
}

stock RehashArrestPoints()
{
	printf("[RehashArrestPoints] Deleting Arrest Points from server...");
	for(new i = 0; i < MAX_ARRESTPOINTS; i++)
	{
		RehashArrestPoint(i);
	}
	LoadArrestPoints();
}

GetArrestPointID(playerid) {
	new a = -1;
	for(new x = 0; x < MAX_ARRESTPOINTS; x++) 
	{
		if(IsPlayerInRangeOfPoint(playerid, 8.0, ArrestPoints[x][arrestPosX], ArrestPoints[x][arrestPosY], ArrestPoints[x][arrestPosZ]) && GetPlayerInterior(playerid) == ArrestPoints[x][arrestInt] && GetPlayerVirtualWorld(playerid) == ArrestPoints[x][arrestVW])
		{
			a = x;
			break;
		}
	}
	return a;
}

stock IsAtArrestPoint(playerid, type)
{
	if(IsPlayerConnected(playerid))
	{
		for(new x; x < MAX_ARRESTPOINTS; x++)
		{
			if(ArrestPoints[x][arrestPosX] != 0)
			{
				if(ArrestPoints[x][arrestType] == type)
				{
					switch(ArrestPoints[x][arrestType])
					{
						case 0:
						{
							if(IsPlayerInRangeOfPoint(playerid, 4.0, ArrestPoints[x][arrestPosX], ArrestPoints[x][arrestPosY], ArrestPoints[x][arrestPosZ]) && GetPlayerInterior(playerid) == ArrestPoints[x][arrestInt] && GetPlayerVirtualWorld(playerid) == ArrestPoints[x][arrestVW]) return 1;
						}
						case 1:
						{
							if(IsPlayerInRangeOfPoint(playerid, 50.0, ArrestPoints[x][arrestPosX], ArrestPoints[x][arrestPosY], ArrestPoints[x][arrestPosZ]) && GetPlayerInterior(playerid) == ArrestPoints[x][arrestInt] && GetPlayerVirtualWorld(playerid) == ArrestPoints[x][arrestVW]) return 1;
						}
						case 2:
						{
							if(IsPlayerInRangeOfPoint(playerid, 10.0, ArrestPoints[x][arrestPosX], ArrestPoints[x][arrestPosY], ArrestPoints[x][arrestPosZ]) && GetPlayerInterior(playerid) == ArrestPoints[x][arrestInt] && GetPlayerVirtualWorld(playerid) == ArrestPoints[x][arrestVW]) return 1;
						}
						case 3:
						{
							if(IsPlayerInRangeOfPoint(playerid, 4.0, ArrestPoints[x][arrestPosX], ArrestPoints[x][arrestPosY], ArrestPoints[x][arrestPosZ]) && GetPlayerInterior(playerid) == ArrestPoints[x][arrestInt] && GetPlayerVirtualWorld(playerid) == ArrestPoints[x][arrestVW]) return 1;
						}
						case 4:
						{
							if(IsPlayerInRangeOfPoint(playerid, 4.0, ArrestPoints[x][arrestPosX], ArrestPoints[x][arrestPosY], ArrestPoints[x][arrestPosZ]) && GetPlayerInterior(playerid) == ArrestPoints[x][arrestInt] && GetPlayerVirtualWorld(playerid) == ArrestPoints[x][arrestVW]) return 1;
						}
					}
				}
			}
		}
	}
	return 0;
}

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
