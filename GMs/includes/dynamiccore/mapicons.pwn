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
	LoadDynamicMapIcons();
}


CMD:gotomapicon(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4)
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
    if(PlayerInfo[playerid][pAdmin] >= 4)
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
			    	format(string, sizeof(string), "MapIcon ID %d | %f from you", i, GetDistance(DMPInfo[i][dmpPosX], DMPInfo[i][dmpPosY], DMPInfo[i][dmpPosZ], X, Y, Z));
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
	if(PlayerInfo[playerid][pAdmin] >= 4)
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
	if(PlayerInfo[playerid][pAdmin] < 4)
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