/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Map Icon System

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

stock LoadDynamicMapIcon(mapiconid)
{
	new string[128];
	mysql_format(MainPipeline, string, sizeof(string), "SELECT * FROM `dmapicons` WHERE `id`=%d", mapiconid);
	mysql_tquery(MainPipeline, string, "OnLoadDynamicMapIcon", "i", mapiconid);
}

stock LoadDynamicMapIcons()
{
	printf("[LoadDynamicMapIcons] Loading data from database...");
	mysql_tquery(MainPipeline, "SELECT * FROM `dmapicons`", "OnLoadDynamicMapIcons", "");
}

forward OnLoadDynamicMapIcon(index);
public OnLoadDynamicMapIcon(index)
{
	new rows;
	cache_get_row_count(rows);

	for(new row; row < rows; row++)
	{
		cache_get_value_name_int(row, "id", DMPInfo[index][dmpSQLId]); 
	 	cache_get_value_name_int(row, "MarkerType", DMPInfo[index][dmpMarkerType]);
		cache_get_value_name_int(row, "Color", DMPInfo[index][dmpColor]); 
		cache_get_value_name_int(row, "VW", DMPInfo[index][dmpVW]);
		cache_get_value_name_int(row, "Int", DMPInfo[index][dmpInt]); 
		cache_get_value_name_float(row, "PosX", DMPInfo[index][dmpPosX]);
		cache_get_value_name_float(row, "PosY", DMPInfo[index][dmpPosY]);
		cache_get_value_name_float(row, "PosZ", DMPInfo[index][dmpPosZ]);
		if(DMPInfo[index][dmpPosX] != 0.0)
		{
			if(DMPInfo[index][dmpMarkerType] != 0) DMPInfo[index][dmpMapIconID] = CreateDynamicMapIcon(DMPInfo[index][dmpPosX], DMPInfo[index][dmpPosY], DMPInfo[index][dmpPosZ], DMPInfo[index][dmpMarkerType], DMPInfo[index][dmpColor], DMPInfo[index][dmpVW], DMPInfo[index][dmpInt], -1, 500.0);
		}
	}
	return 1;
}

forward OnLoadDynamicMapIcons();
public OnLoadDynamicMapIcons()
{
	new i, rows;
	cache_get_row_count(rows);

	while(i < rows)
	{
		/*DMPInfo[i][dmpSQLId] = cache_get_field_content_int(i, "id", MainPipeline);  
		DMPInfo[i][dmpMarkerType] = cache_get_field_content_int(i, "MarkerType", MainPipeline);
		DMPInfo[i][dmpColor] = cache_get_field_content_int(i, "Color", MainPipeline); 
		DMPInfo[i][dmpVW] = cache_get_field_content_int(i, "VW", MainPipeline); 
		DMPInfo[i][dmpInt] = cache_get_field_content_int(i, "Int", MainPipeline);
		DMPInfo[i][dmpPosX] = cache_get_field_content_float(i, "PosX", MainPipeline); 
		DMPInfo[i][dmpPosY] = cache_get_field_content_float(i, "PosY", MainPipeline); 
		DMPInfo[i][dmpPosZ] = cache_get_field_content_float(i, "PosZ", MainPipeline); 
		if(DMPInfo[i][dmpPosX] != 0.0)
		{
			if(DMPInfo[i][dmpMarkerType] != 0) DMPInfo[i][dmpMapIconID] = CreateDynamicMapIcon(DMPInfo[i][dmpPosX], DMPInfo[i][dmpPosY], DMPInfo[i][dmpPosZ], DMPInfo[i][dmpMarkerType], DMPInfo[i][dmpColor], DMPInfo[i][dmpVW], DMPInfo[i][dmpInt], -1, 500.0);
		}*/
		LoadDynamicMapIcon(i);
		i++;
	}
	if(i > 0) printf("[LoadDynamicMapIcons] %d map icons rehashed/loaded.", i);
	else printf("[LoadDynamicMapIcons] Failed to load any map icons.");
	return 1;
}

stock SaveDynamicMapIcon(mapiconid)
{
	new string[512];

	mysql_format(MainPipeline, string, sizeof(string), "UPDATE `dmapicons` SET \
		`MarkerType`=%d, \
		`Color`=%d, \
		`VW`=%d, \
		`Int`=%d, \
		`PosX`=%f, \
		`PosY`=%f, \
		`PosZ`=%f WHERE `id`=%d",
		DMPInfo[mapiconid][dmpMarkerType],
		DMPInfo[mapiconid][dmpColor],
		DMPInfo[mapiconid][dmpVW],
		DMPInfo[mapiconid][dmpInt],
		DMPInfo[mapiconid][dmpPosX],
		DMPInfo[mapiconid][dmpPosY],
		DMPInfo[mapiconid][dmpPosZ],
		DMPInfo[mapiconid][dmpSQLId]
	); // Array starts from zero, MySQL starts at 1 (this is why we are adding one).

	mysql_tquery(MainPipeline, string, "OnQueryFinish", "i", SENDDATA_THREAD);
}

stock SaveDynamicMapIcons()
{
	for(new i = 1; i < MAX_DMAPICONS; i++)
	{
		SaveDynamicMapIcon(i);
	}
	return 1;
}

stock RehashDynamicMapIcon(mapiconid)
{
	if(IsValidDynamicMapIcon(DMPInfo[mapiconid][dmpMapIconID])) DestroyDynamicMapIcon(DMPInfo[mapiconid][dmpMapIconID]);
	DMPInfo[mapiconid][dmpMarkerType] = 0;
	DMPInfo[mapiconid][dmpColor] = 0;
	DMPInfo[mapiconid][dmpVW] = 0;
	DMPInfo[mapiconid][dmpInt] = 0;
	DMPInfo[mapiconid][dmpPosX] = 0.0;
	DMPInfo[mapiconid][dmpPosY] = 0.0;
	DMPInfo[mapiconid][dmpPosZ] = 0.0;
	LoadDynamicMapIcon(mapiconid);
}

stock RehashDynamicMapIcons()
{
	printf("[RehashDynamicMapIcons] Deleting map icons from server...");
	for(new i = 1; i < MAX_DMAPICONS; i++)
	{
		RehashDynamicMapIcon(i);
	}
	//LoadDynamicMapIcons();
}


CMD:gotomapicon(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1 && PlayerInfo[playerid][pBM] < 2)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use this command!");
		return 1;
	}

	new mapiconid;
	if(sscanf(params, "d", mapiconid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /gotomapicon [mapiconid]");

	if(mapiconid >= MAX_DMAPICONS || mapiconid < 1)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /gotomapicon [mapiconid]");
		return 1;
	}
	SetPlayerPos(playerid, DMPInfo[mapiconid][dmpPosX], DMPInfo[mapiconid][dmpPosY], DMPInfo[mapiconid][dmpPosZ]);
	SetPlayerVirtualWorld(playerid, DMPInfo[mapiconid][dmpVW]);
	SetPlayerInterior(playerid, DMPInfo[mapiconid][dmpInt]);
	return 1;
}

CMD:dmpnear(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1 || PlayerInfo[playerid][pBM] == 2)
	{
		SendClientMessageEx(playerid, COLOR_RED, "* Listing all map icons within 30 meters of you");
		new Float:X, Float:Y, Float:Z;
  		GetPlayerPos(playerid, X, Y, Z);
		for(new i=1;i<MAX_DMAPICONS;i++)
		{
			if(IsPlayerInRangeOfPoint(playerid, 30, DMPInfo[i][dmpPosX], DMPInfo[i][dmpPosY], DMPInfo[i][dmpPosZ]))
			{
				if(DMPInfo[i][dmpMarkerType] != 0)
				{
				    new string[128];
			    	format(string, sizeof(string), "MapIcon ID %d | %f from you", i, GetDistanceBetweenPoints(DMPInfo[i][dmpPosX], DMPInfo[i][dmpPosY], DMPInfo[i][dmpPosZ], X, Y, Z));
			    	SendClientMessageEx(playerid, COLOR_WHITE, string);
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

CMD:dmpnext(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1 || PlayerInfo[playerid][pBM] == 2)
	{
		SendClientMessageEx(playerid, COLOR_RED, "* Listing next available map icon...");
		for(new x=1;x<MAX_DMAPICONS;x++)
		{
		    if(DMPInfo[x][dmpMarkerType] == 0)
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

CMD:dmpedit(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1 && PlayerInfo[playerid][pBM] < 2)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use that command.");
		return 1;
	}

	new string[128], choice[32], mapiconid, amount;
	if(sscanf(params, "s[32]dD", choice, mapiconid, amount))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /dmpedit [name] [mapiconid] [(Optional)amount]");
		SendClientMessageEx(playerid, COLOR_GREY, "Available names: Position, Type, Color, Delete");
		return 1;
	}

	if(mapiconid < 1 || mapiconid >= MAX_DMAPICONS)
	{
		SendClientMessageEx( playerid, COLOR_WHITE, "Invalid Map Icon ID!");
	}

	if(strcmp(choice, "position", true) == 0)
	{
		GetPlayerPos(playerid, DMPInfo[mapiconid][dmpPosX], DMPInfo[mapiconid][dmpPosY], DMPInfo[mapiconid][dmpPosZ]);
		DMPInfo[mapiconid][dmpInt] = GetPlayerInterior(playerid);
		DMPInfo[mapiconid][dmpVW] = GetPlayerVirtualWorld(playerid);
		SendClientMessageEx(playerid, COLOR_WHITE, "You have changed the position!");
		if(IsValidDynamicMapIcon(DMPInfo[mapiconid][dmpMapIconID])) DestroyDynamicMapIcon(DMPInfo[mapiconid][dmpMapIconID]);
		DMPInfo[mapiconid][dmpMapIconID] = CreateDynamicMapIcon(DMPInfo[mapiconid][dmpPosX], DMPInfo[mapiconid][dmpPosY], DMPInfo[mapiconid][dmpPosZ], DMPInfo[mapiconid][dmpMarkerType], DMPInfo[mapiconid][dmpColor], DMPInfo[mapiconid][dmpVW], DMPInfo[mapiconid][dmpInt], -1, 500.0);
		SaveDynamicMapIcon(mapiconid);
		format(string, sizeof(string), "%s has edited MapIconID %d's Position.", GetPlayerNameEx(playerid), mapiconid);
		Log("logs/dmpedit.log", string);
		return 1;
	}
	else if(strcmp(choice, "delete", true) == 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You have deleted the map icon!");
		DMPInfo[mapiconid][dmpPosX] = 0.0;
		DMPInfo[mapiconid][dmpPosY] = 0.0;
		DMPInfo[mapiconid][dmpPosZ] = 0.0;
		DMPInfo[mapiconid][dmpVW] = 0;
		DMPInfo[mapiconid][dmpInt] = 0;
		DMPInfo[mapiconid][dmpMarkerType] = 0;
		DMPInfo[mapiconid][dmpColor] = 0;
		SaveDynamicMapIcon(mapiconid);
		if(IsValidDynamicMapIcon(DMPInfo[mapiconid][dmpMapIconID])) DestroyDynamicMapIcon(DMPInfo[mapiconid][dmpMapIconID]);
		format(string, sizeof(string), "%s has deleted MapIconID %d.", GetPlayerNameEx(playerid), mapiconid);
		Log("logs/dmpedit.log", string);
		return 1;

	}
	else if(strcmp(choice, "type", true) == 0)
	{
		DMPInfo[mapiconid][dmpMarkerType] = amount;
		format(string, sizeof(string), "You have set the marker type to %d.", amount);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		if(IsValidDynamicMapIcon(DMPInfo[mapiconid][dmpMapIconID])) DestroyDynamicMapIcon(DMPInfo[mapiconid][dmpMapIconID]);
		DMPInfo[mapiconid][dmpMapIconID] = CreateDynamicMapIcon(DMPInfo[mapiconid][dmpPosX], DMPInfo[mapiconid][dmpPosY], DMPInfo[mapiconid][dmpPosZ], DMPInfo[mapiconid][dmpMarkerType], DMPInfo[mapiconid][dmpColor], DMPInfo[mapiconid][dmpVW], DMPInfo[mapiconid][dmpInt], -1, 500.0);
		format(string, sizeof(string), "%s has edited MapIconID %d's Marker Type to %d.", GetPlayerNameEx(playerid), mapiconid, amount);
		Log("logs/dmpedit.log", string);
	}
	else if(strcmp(choice, "color", true) == 0)
	{
		DMPInfo[mapiconid][dmpColor] = amount;
		format(string, sizeof(string), "You have set the color to %d.", amount);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		if(IsValidDynamicMapIcon(DMPInfo[mapiconid][dmpMapIconID])) DestroyDynamicMapIcon(DMPInfo[mapiconid][dmpMapIconID]);
		DMPInfo[mapiconid][dmpMapIconID] = CreateDynamicMapIcon(DMPInfo[mapiconid][dmpPosX], DMPInfo[mapiconid][dmpPosY], DMPInfo[mapiconid][dmpPosZ], DMPInfo[mapiconid][dmpMarkerType], DMPInfo[mapiconid][dmpColor], DMPInfo[mapiconid][dmpVW], DMPInfo[mapiconid][dmpInt], -1, 500.0);
		format(string, sizeof(string), "%s has edited MapIconID %d's Color to %d.", GetPlayerNameEx(playerid), mapiconid, amount);
		Log("logs/dmpedit.log", string);
	}
	SaveDynamicMapIcon(mapiconid);
	return 1;
}