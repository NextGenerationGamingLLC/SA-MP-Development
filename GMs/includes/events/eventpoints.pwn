/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

					Event Points System

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
LoadEventPoints() {

	if(!fexist("eventpoints.cfg"))
		return 1;

	new
		szFileStr[256],
		File: fHandle = fopen("eventpoints.cfg", io_read),
		iIndex;

	while(iIndex < MAX_EVENTPOINTS && fread(fHandle, szFileStr)) {
		if(!sscanf(szFileStr, "p<|>fffiis[64]i",
			EventPoints[iIndex][epPosX],
			EventPoints[iIndex][epPosY],
			EventPoints[iIndex][epPosZ],
			EventPoints[iIndex][epVW],
			EventPoints[iIndex][epInt],
			EventPoints[iIndex][epPrize],
			EventPoints[iIndex][epFlagable]
		) && EventPoints[iIndex][epPosX] != 0.0) {
			EventPoints[iIndex][epObjectID] = CreateDynamicPickup(1274, 1, EventPoints[iIndex][epPosX], EventPoints[iIndex][epPosY], EventPoints[iIndex][epPosZ], EventPoints[iIndex][epVW]);
			format(szFileStr,sizeof(szFileStr),"Event Point (ID: %d)\nPrize: %s\nType /claimpoint to claim your prize!", iIndex, EventPoints[iIndex][epPrize]);
			EventPoints[iIndex][epText3dID] = CreateDynamic3DTextLabel(szFileStr, COLOR_YELLOW, EventPoints[iIndex][epPosX], EventPoints[iIndex][epPosY], EventPoints[iIndex][epPosZ]+0.5, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, EventPoints[iIndex][epVW], EventPoints[iIndex][epInt]);
			++iIndex;
		}
	}
	printf("[LoadEventPoints] %i event points loaded.", iIndex);
	return fclose(fHandle);
}

SaveEventPoints() {

	new
		szFileStr[256],
		File: fHandle = fopen("eventpoints.cfg", io_write);

	if(fHandle)
	{
		for(new iIndex; iIndex < MAX_EVENTPOINTS; iIndex++) {
			format(szFileStr, sizeof(szFileStr), "%f|%f|%f|%d|%d|%s|%d\r\n",
				EventPoints[iIndex][epPosX],
				EventPoints[iIndex][epPosY],
				EventPoints[iIndex][epPosZ],
				EventPoints[iIndex][epVW],
				EventPoints[iIndex][epInt],
				EventPoints[iIndex][epPrize],
				EventPoints[iIndex][epFlagable]
			);
			fwrite(fHandle, szFileStr);
		}
		return fclose(fHandle);
	}
	return 0;
}


stock InitEventPoints()
{
	for(new i = 0; i < MAX_EVENTPOINTS; i++)
	{
	    EventPoints[i][epObjectID] = 0;
	}
	return 1;
}

CMD:gotopoint(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use this command!");
		return 1;
	}

	new points;
	if(sscanf(params, "d", points)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /gotopoint [pointid]");

	if(points >= MAX_EVENTPOINTS || points < 0)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /gotopoint [pointid]");
		return 1;
	}
	SetPlayerPos(playerid, EventPoints[points][epPosX], EventPoints[points][epPosY], EventPoints[points][epPosZ]);
	SetPlayerVirtualWorld(playerid, EventPoints[points][epVW]);
	SetPlayerInterior(playerid, EventPoints[points][epInt]);
	return 1;
}

CMD:createpoint(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use this command!");
		return 1;
	}

	new string[128], objectid, flagable, pointid, prize[64];
	if(sscanf(params, "ddds[64]", objectid, flagable, pointid, prize)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /createpoint [objectid] [flagable] [pointid] [prize]");

	if(EventPoints[pointid][epObjectID] != 0)
	{
		DestroyDynamicPickup(EventPoints[pointid][epObjectID]);
		EventPoints[pointid][epObjectID] = 0;
		if(IsValidDynamic3DTextLabel(EventPoints[pointid][epText3dID]))
		{
			DestroyDynamic3DTextLabel(EventPoints[pointid][epText3dID]);
		}

		EventPoints[pointid][epPosX] = 0.0;
		EventPoints[pointid][epPosY] = 0.0;
		EventPoints[pointid][epPosZ] = 0.0;
		EventPoints[pointid][epVW] = 0;
		EventPoints[pointid][epInt] = 0;
	}
	new Float:x, Float:y, Float:z;

	GetPlayerPos(playerid, x, y, z);
	new tvw = GetPlayerVirtualWorld(playerid);
	new tint = GetPlayerInterior(playerid);

	EventPoints[pointid][epPosX] = x;
	EventPoints[pointid][epPosY] = y;
	EventPoints[pointid][epPosZ] = z;
	EventPoints[pointid][epVW] = tvw;
	EventPoints[pointid][epInt] = tint;
	EventPoints[pointid][epFlagable] = flagable;
	format(EventPoints[pointid][epPrize], 64, "%s", prize);

	format(string,sizeof(string),"Event Point (ID: %d)\nPrize: %s\nType /claimpoint to claim your prize!", pointid, EventPoints[pointid][epPrize]);
	EventPoints[pointid][epObjectID] = CreateDynamicPickup(objectid, 1, EventPoints[pointid][epPosX], EventPoints[pointid][epPosY], EventPoints[pointid][epPosZ], EventPoints[pointid][epVW]);
	EventPoints[pointid][epText3dID] = CreateDynamic3DTextLabel(string, COLOR_YELLOW, EventPoints[pointid][epPosX], EventPoints[pointid][epPosY], EventPoints[pointid][epPosZ]+0.5, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, EventPoints[pointid][epVW], EventPoints[pointid][epInt]);

	format(string,sizeof(string),"You have placed PointID %d at your current position.", pointid);
	SendClientMessageEx(playerid, COLOR_GRAD2, string);
	return 1;
}

CMD:deletepoint(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use this command!");
		return 1;
	}

	new string[128], pointid;
	if(sscanf(params, "d", pointid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /deletepoint [pointid]");

	if(pointid >= MAX_EVENTPOINTS || pointid < 0)
	{
		return 1;
	}
	if(EventPoints[pointid][epObjectID] != 0)
	{
		DestroyDynamicPickup(EventPoints[pointid][epObjectID]);
		EventPoints[pointid][epObjectID] = 0;
		if(IsValidDynamic3DTextLabel(EventPoints[pointid][epText3dID]))
		{
			DestroyDynamic3DTextLabel(EventPoints[pointid][epText3dID]);
		}

		EventPoints[pointid][epPosX] = 0.0;
		EventPoints[pointid][epPosY] = 0.0;
		EventPoints[pointid][epPosZ] = 0.0;
		EventPoints[pointid][epVW] = 0;
		EventPoints[pointid][epInt] = 0;
		EventPoints[pointid][epFlagable] = 0;
		format(EventPoints[pointid][epPrize], 64, "");

		format(string,sizeof(string),"You have deleted PointID %d from the server.", pointid);
		SendClientMessageEx(playerid, COLOR_GRAD2, string);
	}
	return 1;
}

CMD:claimpoint(playerid, params[])
{
	for(new p = 0; p < MAX_EVENTPOINTS; p++)
	{
		if(IsPlayerInRangeOfPoint(playerid, 5.0, EventPoints[p][epPosX], EventPoints[p][epPosY], EventPoints[p][epPosZ]))
		{
			if(EventPoints[p][epObjectID] != 0)
			{
				new string[128];

				format(string, sizeof(string), " Congratulations you have won a Special Prize (%s)!", EventPoints[p][epPrize]);
				SendClientMessageEx(playerid, COLOR_GRAD2, string);
				SendClientMessageEx(playerid, COLOR_GRAD2, " Note: This prize may take up to 48 hours to be rewarded..");
				if(EventPoints[p][epFlagable] == 1)
				{
					format(string, 128, "Special Prize (%s)", EventPoints[p][epPrize]);
                    AddFlag(playerid, INVALID_PLAYER_ID, string);
				}
				format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s has just found PointID %d, they are now pending a special prize.", GetPlayerNameEx(playerid), p);
				ABroadCast(COLOR_YELLOW, string, 4);

				format(string, sizeof(string), "AdmCmd: %s(%d) has just found PointID %d, Prize: %s", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), p, EventPoints[p][epPrize]);
				Log("logs/gifts.log", string);

				DestroyDynamicPickup(EventPoints[p][epObjectID]);
				EventPoints[p][epObjectID] = 0;

				if(IsValidDynamic3DTextLabel(EventPoints[p][epText3dID]))
				{
					DestroyDynamic3DTextLabel(EventPoints[p][epText3dID]);
				}

				EventPoints[p][epPosX] = 0.0;
				EventPoints[p][epPosY] = 0.0;
				EventPoints[p][epPosZ] = 0.0;
				EventPoints[p][epVW] = 0;
				EventPoints[p][epInt] = 0;
				EventPoints[p][epFlagable] = 0;
				format(EventPoints[p][epPrize], 64, "");
			}
		}
	}
	return 1;
}

CMD:claimpoints(playerid, params[])
{
	new amount;
	for(new i; i < MAX_EVENTPOINTS; i++)
	{
		if(EventPoints[i][epPosX] != 0.0) amount++;
	}
	new string[48];
	format(string, sizeof(string), "There are %d available claim points on the map!", amount);
	SendClientMessageEx(playerid, -1, string);
	return 1;
}