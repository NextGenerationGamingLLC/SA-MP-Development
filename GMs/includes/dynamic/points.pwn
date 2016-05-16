/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

    	    		  Point System (Revision)
    			        by Winterfield

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

CMD:capture(playerid, params[])
{
	szMiscArray[0] = 0;
	if(servernumber == 2) return SendClientMessageEx(playerid, COLOR_WHITE, "This command is disabled!");
	if(GetPVarInt(playerid,"Injured") == 1) return SendClientMessageEx(playerid, COLOR_GRAD1, " You can not capture while injured!");
	if (!IsACriminal(playerid) || PlayerInfo[playerid][pRank] < arrGroupData[PlayerInfo[playerid][pMember]][g_iPointCapRank]) return SendClientMessageEx(playerid, COLOR_GRAD1, " You are not high rank enough to capture!");

	new vw = GetPlayerVirtualWorld(playerid);
	new id = -1;

	for (new i=0; i<MAX_POINTS; i++)
	{
		if (IsPlayerInRangeOfPoint(playerid, 1.0, DynPoints[i][poPos][0], DynPoints[i][poPos][1], DynPoints[i][poPos][2]))
		{
			if(vw == DynPoints[i][pointVW]) { id = i; }
		}		
	}

	if(DynPoints[id][poInactive] >= 1) return SendClientMessageEx(playerid, COLOR_GRAD1, " You cannot capture this point!");

	if(id == -1) return SendClientMessageEx(playerid, COLOR_GRAD1, " You are not at the capture place!"); // A small check.
	if(DynPoints[id][poCapturable] <= 0) return SendClientMessageEx(playerid, COLOR_GRAD1, " This point is not ready for takeover.");
	if(DynPoints[id][poBeingCaptured] != INVALID_PLAYER_ID) return SendClientMessageEx(playerid, COLOR_GRAD1, " This point is already being captured!");
	if(DynPoints[id][poCapperGroup] == PlayerInfo[playerid][pMember]) return SendClientMessageEx(playerid, COLOR_GRAD1, " This point is already being captured by your family!");
	if(GetPlayerPing(playerid) > 500) return SendClientMessageEx(playerid, COLOR_WHITE, "You can not capture with 500+ ping!");

	format(szMiscArray, sizeof(szMiscArray), "%s is attempting to capture the point (VW: %d).", GetPlayerNameEx(playerid), DynPoints[id][pointVW]);
	ProxDetector(70.0, playerid, szMiscArray, COLOR_RED,COLOR_RED,COLOR_RED,COLOR_RED,COLOR_RED);
	GetPlayerPos(playerid, DynPoints[id][CapturePos][0], DynPoints[id][CapturePos][1], DynPoints[id][CapturePos][2]);

	DynPoints[id][poBeingCaptured] = playerid;
	DynPoints[id][poCaptureTime] = 10;
	SetTimerEx("ProgressTimer", 1000, 0, "d", id);
	return 1;
}

CMD:points(playerid, params[])
{
	szMiscArray[0] = 0;

	for(new i; i < MAX_POINTS; i++)
	{
		if (DynPoints[i][poType] >= 0)
		{
			if(DynPoints[i][poID] != 0)
			{
				if(DynPoints[i][poInactive] != 1)
				{		
					if(DynPoints[i][poCapperGroupOwned] != INVALID_GROUP_ID) {
						format(szMiscArray, sizeof(szMiscArray), "Point ID: %d | Name: %s | Owner: %s | Captured By: %s | Hours: %d", DynPoints[i][poID], DynPoints[i][poName],arrGroupData[DynPoints[i][poCapperGroupOwned]][g_szGroupName],DynPoints[i][CapturePlayerName],DynPoints[i][poTimestamp1]);
					}
					else {
						format(szMiscArray, sizeof(szMiscArray), "Point ID: %d | Name: %s | Owner: Nobody | Captured By: Nobody | Hours: %d", DynPoints[i][poID], DynPoints[i][poName], DynPoints[i][poTimestamp1]);
					}
					SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
				}
			}
		}
	}
	return 1;
}

CMD:pointtime(playerid, params[])
{
	new point, string[128];
	if(sscanf(params, "i", point)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /pointtime [pointid]");
	
	if(point < 1 || point > MAX_POINTS || DynPoints[point-1][poInactive] >= 1) return SendClientMessageEx(playerid, COLOR_GRAD2, "Invalid ID!");
	
	if(DynPoints[point-1][poTimestamp2] > 0)
	{
		format(string, sizeof(string), "Time left until fully captured: %d minutes.", DynPoints[point-1][poTimestamp2]);
		SendClientMessageEx(playerid, COLOR_YELLOW, string);
	}
	else SendClientMessageEx(playerid, COLOR_GRAD2, "This point is not being captured at the moment.");
	return 1;
}

CMD:editpoints(playerid, params[])
{
	if(PlayerInfo[playerid][pFactionModerator] >= 2 || PlayerInfo[playerid][pAdmin] >= 1337)
	{
		ListPoints(playerid);
	}
	else SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to preform this command.");
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case DIALOG_LISTPOINTS:
		{
			if(!response) return 1;
			switch(listitem)
			{
				case 0 .. MAX_POINTS:
				{
					new szDialogStr[1000];
					SetPVarInt(playerid, "pEditingPoint", listitem);
					format(szDialogStr, sizeof szDialogStr, "Name: %s\nType: %s\nPosition\nMaterial Amount (%d)\nInactive (%d)\nReset", DynPoints[listitem][poName], PointTypeToName(DynPoints[listitem][poType]), DynPoints[listitem][poMaterials], DynPoints[listitem][poInactive]);
					ShowPlayerDialogEx(playerid, DIALOG_EDITPOINT, DIALOG_STYLE_LIST, "Edit Points", szDialogStr, "Select", "Cancel");
				}
			}
		}
		case DIALOG_EDITPOINT:
		{
			if(!response) return 1;
			szMiscArray[0] = 0;
			switch(listitem)
			{
				case 0:
				{
					ShowPlayerDialogEx(playerid, DIALOG_EDITPOINT_NAME, DIALOG_STYLE_INPUT, "Edit Points - Name", "Please enter a new name for the point.", "Select", "Cancel");
				}
				case 1:
				{
					ShowPlayerDialogEx(playerid, DIALOG_EDITPOINT_TYPE, DIALOG_STYLE_LIST, "Edit Points - Type", "Materials\nPot\nCrack\nNone", "Select", "Cancel");
				}
				case 2:
				{
					ShowPlayerDialogEx(playerid, DIALOG_EDITPOINT_POSITION, DIALOG_STYLE_LIST, "Edit Points - Position", "Pickup Point\nDelivery Point", "Select", "Cancel");
				}
				case 3:
				{
					ShowPlayerDialogEx(playerid, DIALOG_EDITPOINT_MATERIALS, DIALOG_STYLE_INPUT, "Edit Points - Materials", "Please enter the amount of materials the point will give each hour.", "Select", "Cancel");
				}
				case 4:
				{
					switch(DynPoints[GetPVarInt(playerid, "pEditingPoint")][poInactive])
					{
						case 0: DynPoints[GetPVarInt(playerid, "pEditingPoint")][poInactive] = 1;
						case 1: DynPoints[GetPVarInt(playerid, "pEditingPoint")][poInactive] = 0;
					}

					format(szMiscArray, sizeof szMiscArray, "Name: %s\nType: %s\nPosition\nMaterial Amount (%d)\nInactive (%d)\t%d\nReset", 
						DynPoints[GetPVarInt(playerid, "pEditingPoint")][poName], 
						PointTypeToName(DynPoints[GetPVarInt(playerid, "pEditingPoint")][poType]), 
						DynPoints[GetPVarInt(playerid, "pEditingPoint")][poMaterials], 
						DynPoints[GetPVarInt(playerid, "pEditingPoint")][poInactive]);

					ShowPlayerDialogEx(playerid, DIALOG_EDITPOINT, DIALOG_STYLE_LIST, "Edit Points", szMiscArray, "Select", "Cancel");

					SavePoint(GetPVarInt(playerid, "pEditingPoint"));
				}
				case 5:
				{
					DynPoints[GetPVarInt(playerid, "pEditingPoint")][poCapperGroupOwned] = INVALID_GROUP_ID;
					DynPoints[GetPVarInt(playerid, "pEditingPoint")][poCapperGroup] = INVALID_GROUP_ID;
					DynPoints[GetPVarInt(playerid, "pEditingPoint")][poCaptureTime] = -1;
					DynPoints[GetPVarInt(playerid, "pEditingPoint")][poBeingCaptured] = INVALID_PLAYER_ID;
					DynPoints[GetPVarInt(playerid, "pEditingPoint")][poCapturable] = 1;
					DynPoints[GetPVarInt(playerid, "pEditingPoint")][poBeingCaptured] = INVALID_PLAYER_ID;
					DynPoints[GetPVarInt(playerid, "pEditingPoint")][poTimestamp1] = 0;
					DynPoints[GetPVarInt(playerid, "pEditingPoint")][poTimestamp2] = 0;
					DynPoints[GetPVarInt(playerid, "pEditingPoint")][HasCrashed] = 0;
					SavePoint(GetPVarInt(playerid, "pEditingPoint"));
				}
			}
		}
		case DIALOG_EDITPOINT_NAME:
		{
			szMiscArray[0] = 0;
			if(!response) return 1;

			if(strlen(inputtext) > 25) return ShowPlayerDialogEx(playerid, DIALOG_EDITPOINT_NAME, DIALOG_STYLE_INPUT, "Edit Points - Name", "Please enter a new name for the point.\n\nPlease specify a name under 25 characters.", "Select", "Cancel"); 
			strcpy(DynPoints[GetPVarInt(playerid, "pEditingPoint")][poName], inputtext, 25);

			format(szMiscArray, sizeof szMiscArray, "Name: %s\nType: %s\nPosition\nMaterial Amount (%d)\nInactive (%d)\nReset", 
				DynPoints[GetPVarInt(playerid, "pEditingPoint")][poName], 
				PointTypeToName(DynPoints[GetPVarInt(playerid, "pEditingPoint")][poType]), 
				DynPoints[GetPVarInt(playerid, "pEditingPoint")][poMaterials], 
				DynPoints[GetPVarInt(playerid, "pEditingPoint")][poInactive]);

			ShowPlayerDialogEx(playerid, DIALOG_EDITPOINT, DIALOG_STYLE_LIST, "Edit Points", szMiscArray, "Select", "Cancel");

			SavePoint(GetPVarInt(playerid, "pEditingPoint"));
		}
		case DIALOG_EDITPOINT_TYPE:
		{
			szMiscArray[0] = 0;
			if(!response) return 1;
			switch(listitem)
			{
				case 0 .. 3:
				{
					DynPoints[GetPVarInt(playerid, "pEditingPoint")][poType] = listitem;

					format(szMiscArray, sizeof szMiscArray, "Name: %s\nType: %s\nPosition\nMaterial Amount (%d)\nInactive (%d)\t%d\nReset", 
						DynPoints[GetPVarInt(playerid, "pEditingPoint")][poName], 
						PointTypeToName(DynPoints[GetPVarInt(playerid, "pEditingPoint")][poType]), 
						DynPoints[GetPVarInt(playerid, "pEditingPoint")][poMaterials], 
						DynPoints[GetPVarInt(playerid, "pEditingPoint")][poInactive]);

					ShowPlayerDialogEx(playerid, DIALOG_EDITPOINT, DIALOG_STYLE_LIST, "Edit Points", szMiscArray, "Select", "Cancel");

					SavePoint(GetPVarInt(playerid, "pEditingPoint"));
				}
			}
		}
		case DIALOG_EDITPOINT_POSITION:
		{
			new Float: pvPos[3];
			GetPlayerPos(playerid, pvPos[0], pvPos[1], pvPos[2]);
			switch(listitem)
			{
				case 0:
				{
					DynPoints[GetPVarInt(playerid, "pEditingPoint")][poPos][0] = pvPos[0];
					DynPoints[GetPVarInt(playerid, "pEditingPoint")][poPos][1] = pvPos[1];
					DynPoints[GetPVarInt(playerid, "pEditingPoint")][poPos][2] = pvPos[2];
					DynPoints[GetPVarInt(playerid, "pEditingPoint")][pointVW] = GetPlayerVirtualWorld(playerid);

					SavePoint(GetPVarInt(playerid, "pEditingPoint"));
				}
				case 1:
				{
					DynPoints[GetPVarInt(playerid, "pEditingPoint")][poPos2][0] = pvPos[0];
					DynPoints[GetPVarInt(playerid, "pEditingPoint")][poPos2][1] = pvPos[1];
					DynPoints[GetPVarInt(playerid, "pEditingPoint")][poPos2][2] = pvPos[2];
					DynPoints[GetPVarInt(playerid, "pEditingPoint")][pointVW2] = GetPlayerVirtualWorld(playerid);

					SavePoint(GetPVarInt(playerid, "pEditingPoint"));
				}
			}
		}
		case DIALOG_EDITPOINT_MATERIALS:
		{
			szMiscArray[0] = 0;
			if(!IsNumeric(inputtext)) return ShowPlayerDialogEx(playerid, DIALOG_EDITPOINT_MATERIALS, DIALOG_STYLE_INPUT, "Edit Points - Materials", "Please enter the amount of materials the point will give each hour.\n\nPlease enter a numerical integer.", "Select", "Cancel");

			DynPoints[GetPVarInt(playerid, "pEditingPoint")][poMaterials] = strval(inputtext);

			format(szMiscArray, sizeof szMiscArray, "Name: %s\nType: %s\nPosition\nMaterial Amount (%d)\nInactive (%d)\t%d\nReset", 
				DynPoints[GetPVarInt(playerid, "pEditingPoint")][poName], 
				PointTypeToName(DynPoints[GetPVarInt(playerid, "pEditingPoint")][poType]), 
				DynPoints[GetPVarInt(playerid, "pEditingPoint")][poMaterials], 
				DynPoints[GetPVarInt(playerid, "pEditingPoint")][poInactive]);

			ShowPlayerDialogEx(playerid, DIALOG_EDITPOINT, DIALOG_STYLE_LIST, "Edit Points", szMiscArray, "Select", "Cancel");

			SavePoint(GetPVarInt(playerid, "pEditingPoint"));
		}
	}
	return 1;
}	

ListPoints(playerid) {

	new szDialogStr[MAX_POINTS * 25], i;

	while(i < MAX_POINTS) 
	{
		if(DynPoints[i][poName][0])
			format(szDialogStr, sizeof szDialogStr, "%s\n(%i) %s{FFFFFF}", szDialogStr, i + 1, DynPoints[i][poName]);

		else
			format(szDialogStr, sizeof szDialogStr, "%s\n(%i) (empty)", szDialogStr, i + 1);

		++i;
	}
	return ShowPlayerDialogEx(playerid, DIALOG_LISTPOINTS, DIALOG_STYLE_LIST, "Edit Points", szDialogStr, "Select", "Cancel");
}

forward ProgressTimer(id);
public ProgressTimer(id)
{
	szMiscArray[0] = 0;
	if(DynPoints[id][poBeingCaptured] != INVALID_PLAYER_ID && DynPoints[id][poCapturable] >= 1)
	{
		DynPoints[id][poCaptureTime]--;

		format(szMiscArray, sizeof(szMiscArray), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~%d seconds left", DynPoints[id][poCaptureTime]);
		GameTextForPlayer(DynPoints[id][poBeingCaptured], szMiscArray, 1100, 3);

		strmid(GetPlayerNameEx(DynPoints[id][poBeingCaptured]), DynPoints[id][PlayerNameCapping], 0, 32, 32);

		if(DynPoints[id][poCaptureTime] >= 1) SetTimerEx("ProgressTimer", 1000, 0, "d", id);
		format(szMiscArray, sizeof(szMiscArray), "%s is attempting to capture the point, time left: %d", GetPlayerNameEx(DynPoints[id][poBeingCaptured]), DynPoints[id][poCaptureTime]);
		UpdateDynamic3DTextLabelText(DynPoints[id][poTextID], COLOR_RED, szMiscArray);
	}
	else
	{
	    DestroyDynamic3DTextLabel(DynPoints[id][poTextID]);

	    format(szMiscArray, sizeof(szMiscArray), "%s has become available for capture! Stand here and to /capture it.", DynPoints[id][poName]);
		DynPoints[id][poTextID] = CreateDynamic3DTextLabel(szMiscArray, COLOR_YELLOW, DynPoints[id][poPos][0], DynPoints[id][poPos][1], DynPoints[id][poPos][2], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1);

	    DynPoints[id][poBeingCaptured] = INVALID_PLAYER_ID;
		DynPoints[id][poCaptureTime] = -1;
	}

	if(DynPoints[id][poCaptureTime] <= 0)
	{
		DestroyDynamic3DTextLabel(DynPoints[id][poTextID]);

	    CaptureTimer(id);
	    DynPoints[id][poCaptureTime] = 0;
	}
	return 1;
}

forward CaptureTimer(id);
public CaptureTimer(id)
{
	szMiscArray[0] = 0;
	if (DynPoints[id][poBeingCaptured] != INVALID_PLAYER_ID && DynPoints[id][poCapturable] >= 1)
	{
		new Float: x, Float: y, Float: z;
		GetPlayerPos(DynPoints[id][poBeingCaptured], x, y, z);
		if (DynPoints[id][CapturePos][0] != x || DynPoints[id][CapturePos][1] != y || DynPoints[id][CapturePos][2] != z || GetPVarInt(DynPoints[id][poBeingCaptured],"Injured") == 1)
		{
			SendClientMessageEx(DynPoints[id][poBeingCaptured], COLOR_LIGHTBLUE, "You failed to capture. You either moved or died while attempting to capture.");

			DynPoints[id][poBeingCaptured] = INVALID_PLAYER_ID;
			DynPoints[id][poCaptureTime] = -1;
		}
		else
		{
			if(DynPoints[id][poCapturable] <= 0)
			{
			    SendClientMessageEx(DynPoints[id][poBeingCaptured], COLOR_LIGHTBLUE, "You failed to capture. The point was already captured.");

				DynPoints[id][poBeingCaptured] = INVALID_PLAYER_ID;
				DynPoints[id][poCaptureTime] = -1;
				return 1;
			}
			if(playerTabbed[DynPoints[id][poBeingCaptured]] != 0)
			{
			    SendClientMessageEx(DynPoints[id][poBeingCaptured], COLOR_LIGHTBLUE, "You failed to capture. You were alt-tabbed.");
			    format(szMiscArray, sizeof(szMiscArray), "{AA3333}AdmWarning{FFFF00}: %s (ID %d) may have possibly alt tabbed to capture a point.", GetPlayerNameEx(DynPoints[id][poBeingCaptured]), DynPoints[id][poBeingCaptured]);
				ABroadCast( COLOR_YELLOW, szMiscArray, 2 );
   				DynPoints[id][poBeingCaptured] = INVALID_PLAYER_ID;
				DynPoints[id][poCaptureTime] = -1;
			    return 1;
			}
			if(GetPlayerVirtualWorld(DynPoints[id][poBeingCaptured]) != DynPoints[id][pointVW])
			{
			    SendClientMessageEx(DynPoints[id][poBeingCaptured], COLOR_LIGHTBLUE, "You failed to capture. You were not in the point virtual world.");
			    format(szMiscArray, sizeof(szMiscArray), "{AA3333}AdmWarning{FFFF00}: %s (ID %d) may have possibly desynced himself to capture a point.", GetPlayerNameEx(DynPoints[id][poBeingCaptured]), DynPoints[id][poBeingCaptured]);
				ABroadCast( COLOR_YELLOW, szMiscArray, 2 );
   				DynPoints[id][poBeingCaptured] = INVALID_PLAYER_ID;
				DynPoints[id][poCaptureTime] = -1;
			    return 1;
			}
			new fam = PlayerInfo[DynPoints[id][poBeingCaptured]][pMember];
            DynPoints[id][PlayerNameCapping] = GetPlayerNameEx(DynPoints[id][poBeingCaptured]);

		   	format(szMiscArray, sizeof(szMiscArray), "%s has attempted to take control of the %s for %s, it will be theirs in 10 minutes.", DynPoints[id][PlayerNameCapping], DynPoints[id][poName], arrGroupData[fam][g_szGroupName]);
			SendClientMessageToAllEx(COLOR_YELLOW, szMiscArray);
			UpdateDynamic3DTextLabelText(DynPoints[id][poTextID], COLOR_YELLOW, szMiscArray);
			
			DynPoints[id][poCaptureTime] = 1;
			DynPoints[id][poBeingCaptured] = INVALID_PLAYER_ID;
			DynPoints[id][poCapperGroup] = fam;
			DynPoints[id][poTimestamp2] = 10;
			SavePoint(id);
			if(DynPoints[id][poTimer] != -1) KillTimer(DynPoints[id][poTimer]);
			DynPoints[id][poTimer] = SetTimerEx("CaptureTimerEx", 60000, 1, "d", id);
		}
	}
	return 1;
}

forward CaptureTimerEx(id);
public CaptureTimerEx(id)
{
	szMiscArray[0] = 0;
	new fam = DynPoints[id][poCapperGroup];
	if (DynPoints[id][poTimestamp2] > 0)
	{
		DynPoints[id][poTimestamp2]--;
		format(szMiscArray, sizeof(szMiscArray), "%s has successfully attempted to take over of %s for %s, it will be theirs in %d minutes!", DynPoints[id][PlayerNameCapping], DynPoints[id][poName], arrGroupData[fam][g_szGroupName], DynPoints[id][poTimestamp2]);
		UpdateDynamic3DTextLabelText(DynPoints[id][poTextID], COLOR_YELLOW, szMiscArray);
		SavePoint(id);
	}
	else if (DynPoints[id][poTimestamp2] == 0)
	{
		DynPoints[id][poCapperGroupOwned] = DynPoints[id][poCapperGroup];
		DynPoints[id][poCapperGroup] = INVALID_GROUP_ID;
		DynPoints[id][poCaptureTime] = -1;
		DynPoints[id][poBeingCaptured] = INVALID_PLAYER_ID;
		DynPoints[id][poCapturable] = 0;
		DynPoints[id][poBeingCaptured] = INVALID_PLAYER_ID;
		DynPoints[id][poTimestamp2] = -1;
		DestroyDynamic3DTextLabel(DynPoints[id][poTextID]);
		strmid(DynPoints[id][CapturePlayerName], DynPoints[id][PlayerNameCapping], 0, 32, 32);
		format(szMiscArray, sizeof(szMiscArray), "%s has successfully taken control of the %s for %s.", DynPoints[id][CapturePlayerName], DynPoints[id][poName], arrGroupData[fam][g_szGroupName]);
		SendClientMessageToAllEx(COLOR_YELLOW, szMiscArray);
		SavePoint(id);
		KillTimer(DynPoints[id][poTimer]);
		DynPoints[id][poTimer] = -1;
		DynPoints[id][poTimestamp1] = 24;
		DynPoints[id][HasCrashed] = 0;
	}
}

UpdatePoint(id)
{
	new string[256];
	DestroyDynamicPickup(DynPoints[id][poPickupID]);
	DestroyDynamic3DTextLabel(DynPoints[id][poTextID]);
	DynPoints[id][poPickupID] = CreateDynamicPickup(1239, 1, DynPoints[id][poPos][0], DynPoints[id][poPos][1], DynPoints[id][poPos][2], -1);

	if(DynPoints[id][poTimestamp2] > 0)
	{
		format(szMiscArray, sizeof(szMiscArray), "%s has successfully attempted to take over of %s for %s, it will be theirs in %d minutes!", DynPoints[id][PlayerNameCapping], DynPoints[id][poName], arrGroupData[DynPoints[id][poCapperGroup]][g_szGroupName], DynPoints[id][poTimestamp2]);
		CreateDynamic3DTextLabel(string, COLOR_YELLOW, DynPoints[id][poPos][0], DynPoints[id][poPos][1], DynPoints[id][poPos][2], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1);
	}

	else if(DynPoints[id][poCapturable] >= 1 && DynPoints[id][poInactive] != 1) {
		format(string, sizeof(string), "%s has become available for capture! Stand here and to /capture it.", DynPoints[id][poName]);
		DynPoints[id][poTextID] = CreateDynamic3DTextLabel(string, COLOR_YELLOW, DynPoints[id][poPos][0], DynPoints[id][poPos][1], DynPoints[id][poPos][2], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1);
	}

	else switch(DynPoints[id][poType])
	{
		case 0: DynPoints[id][poTextID] = CreateDynamic3DTextLabel("Materials Pickup\nType /getmats to get materials.", COLOR_YELLOW, DynPoints[id][poPos][0], DynPoints[id][poPos][1], DynPoints[id][poPos][2], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1);
		case 1: DynPoints[id][poTextID] = CreateDynamic3DTextLabel("Drug Pickup\nType /getcrate to get pot.", COLOR_YELLOW, DynPoints[id][poPos][0], DynPoints[id][poPos][1], DynPoints[id][poPos][2], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1);
		case 2: DynPoints[id][poTextID] = CreateDynamic3DTextLabel("Drug Pickup\nType /getcrate to get crack.", COLOR_YELLOW, DynPoints[id][poPos][0], DynPoints[id][poPos][1], DynPoints[id][poPos][2], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1);
		case 3: 
		{
			if(DynPoints[id][poCapturable] != 1 && DynPoints[id][poInactive] != 1) { // Deletes the text label as a whole, will only display when the point is captureable.
				DestroyDynamic3DTextLabel(DynPoints[id][poTextID]);
			}
		}
	}
	return 1;
}

PointTypeToName(id)
{
	new type[24];
	switch(id)
	{
		case 0: format(type, 24, "Materials");
		case 1: format(type, 24, "Pot");
		case 2: format(type, 24, "Crack");
		case 3: format(type, 24, "None");
	}
	return type;
}

SavePoint(id)
{
	new szQuery[2048];
	
	format(szQuery, sizeof(szQuery), "UPDATE `dynpoints` SET \
		`pointname` = '%s', \
		`type` = '%d', \
		`posx` = '%f', \
		`posy` = '%f', \
		`posz` = '%f', \
		`pos2x` = '%f', \
		`pos2y` = '%f', \
		`pos2z` = '%f', \
		`vw` = '%d', \
		`vw2` = '%d', \
		`capturable` = '%d', \
		`captureplayername` = '%s', \
		`playernamecapping` = '%s', \
		`cappergroup` = '%d', \
		`cappergroupowned` = '%d', \
		`inactive` = '%d', \
		`materials` = '%d', \
		`timestamp1` = '%d', \
		`timestamp2` = '%d' WHERE `id` = %d",
		g_mysql_ReturnEscaped(DynPoints[id][poName], MainPipeline),
		DynPoints[id][poType],
		DynPoints[id][poPos][0],
		DynPoints[id][poPos][1],
		DynPoints[id][poPos][2],
		DynPoints[id][poPos2][0],
		DynPoints[id][poPos2][1],
		DynPoints[id][poPos2][2],
		DynPoints[id][pointVW],
		DynPoints[id][pointVW2],
		DynPoints[id][poCapturable],
		g_mysql_ReturnEscaped(DynPoints[id][CapturePlayerName], MainPipeline),
		g_mysql_ReturnEscaped(DynPoints[id][PlayerNameCapping], MainPipeline),
		DynPoints[id][poCapperGroup],
		DynPoints[id][poCapperGroupOwned],
		DynPoints[id][poInactive],
		DynPoints[id][poMaterials],
		DynPoints[id][poTimestamp1],
		DynPoints[id][poTimestamp2],
		id+1
	);	
		
	mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "i", SENDDATA_THREAD);	
	UpdatePoint(id);
}	

stock LoadPoints()
{
	printf("[Dynamic Points] Loading Dynamic Points from the database, please wait...");
	mysql_function_query(MainPipeline, "SELECT * FROM `dynpoints`", true, "OnLoadPoints", "");
}

forward OnLoadPoints();
public OnLoadPoints()
{
	new fields, rows, id, result[128];
	cache_get_data(rows, fields, MainPipeline);

	while((id < rows))
	{
		cache_get_field_content(id, "pointname", DynPoints[id][poName], MainPipeline, MAX_PLAYER_NAME);
		cache_get_field_content(id, "id", result, MainPipeline); DynPoints[id][poID] = strval(result);
		cache_get_field_content(id, "type", result, MainPipeline); DynPoints[id][poType] = strval(result);
		cache_get_field_content(id, "posx", result, MainPipeline); DynPoints[id][poPos][0] = floatstr(result);
		cache_get_field_content(id, "posy", result, MainPipeline); DynPoints[id][poPos][1] = floatstr(result);
		cache_get_field_content(id, "posz", result, MainPipeline); DynPoints[id][poPos][2] = floatstr(result);
		cache_get_field_content(id, "pos2x", result, MainPipeline); DynPoints[id][poPos2][0] = floatstr(result);
		cache_get_field_content(id, "pos2y", result, MainPipeline); DynPoints[id][poPos2][1] = floatstr(result);
		cache_get_field_content(id, "pos2z", result, MainPipeline); DynPoints[id][poPos2][2] = floatstr(result);
		cache_get_field_content(id, "vw", result, MainPipeline); DynPoints[id][pointVW] = strval(result);
		cache_get_field_content(id, "vw2", result, MainPipeline); DynPoints[id][pointVW2] = strval(result);
		cache_get_field_content(id, "capturable", result, MainPipeline); DynPoints[id][poCapturable] = strval(result);
		cache_get_field_content(id, "captureplayername", DynPoints[id][CapturePlayerName], MainPipeline, MAX_PLAYER_NAME);
		cache_get_field_content(id, "playernamecapping", DynPoints[id][PlayerNameCapping], MainPipeline, MAX_PLAYER_NAME);
		cache_get_field_content(id, "cappergroup", result, MainPipeline); DynPoints[id][poCapperGroup] = strval(result);
		cache_get_field_content(id, "cappergroupowned", result, MainPipeline); DynPoints[id][poCapperGroupOwned] = strval(result);
		cache_get_field_content(id, "inactive", result, MainPipeline); DynPoints[id][poInactive] = strval(result);
		cache_get_field_content(id, "materials", result, MainPipeline); DynPoints[id][poMaterials] = strval(result);
		cache_get_field_content(id, "timestamp1", result, MainPipeline); DynPoints[id][poTimestamp1] = strval(result);
		cache_get_field_content(id, "timestamp2", result, MainPipeline); DynPoints[id][poTimestamp2] = strval(result);
		
		if(DynPoints[id][poCapperGroup] != INVALID_GROUP_ID)
		{
			DynPoints[id][HasCrashed] = 1;
			DynPoints[id][poTimer] = SetTimerEx("CaptureTimerEx", 60000, 1, "d", id);
		}

		UpdatePoint(id);

		DynPoints[id][poBeingCaptured] = INVALID_PLAYER_ID;
		
		id++;
	}
	if(id == 0) print("[Dynamic Points] No dynamic points has been loaded.");
	if(id != 0) printf("[Dynamic Points] %d dynamic points has been loaded.", id);
	return 1;
}