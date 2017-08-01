/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

    	    		  Point System (Re-done)
    			        by Shane Roberts

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

CMD:getmats(playerid, params[])
{
	if(PlayerInfo[playerid][pJob] != 9 && PlayerInfo[playerid][pJob2] != 9 && PlayerInfo[playerid][pJob3] != 9 && PlayerInfo[playerid][pJob] != 18 && PlayerInfo[playerid][pJob2] != 18 && PlayerInfo[playerid][pJob3] != 18) return SendClientMessageEx(playerid,COLOR_GREY,"   You are not an Arms Dealer or Craftsman!");
	if(CheckPointCheck(playerid)) return SendClientMessageEx(playerid, COLOR_WHITE, "Please ensure that your current checkpoint is destroyed first (you either have material packages, or another existing checkpoint).");
	new point, drank[64], vip = ((0 <= PlayerInfo[playerid][pDonateRank] < 5) ? PlayerInfo[playerid][pDonateRank] : 0);
	switch(vip)
	{
		case 0: drank = "Non-VIP";
		case 1: drank = "Bronze VIP";
		case 2: drank = "Silver VIP";
		case 3: drank = "Gold VIP";
		case 4: drank = "Platinum VIP";
	}
	FetchPoint(playerid, point, (IsABoat(GetPlayerVehicleID(playerid)) ? 15.0 : 3.0));
	if(point == -1) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not at a material point!");
	if(DynPoints[point][poType] != 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "This point doesn't offer material runs!");
	if(DynPoints[point][poAmount][vip] < 1) return SendClientMessageEx(playerid, COLOR_GRAD1, "There is no material amount set up for %s for this point!", drank);
	if(DynPoints[point][poPos2][0] == 0.0 || DynPoints[point][poPos2][1] == 0.0) return SendClientMessageEx(playerid, COLOR_GRAD1, "The end delivery point hasn't been setup yet!");
	if(DynPoints[point][poBoat] && !IsABoat(GetPlayerVehicleID(playerid))) return SendClientMessageEx(playerid, COLOR_GRAD1, "You need to be in a boat!");
	if(vip == 0) {
		if(GetPlayerCash(playerid) < 500) return SendClientMessageEx(playerid, COLOR_RED, "You cannot afford the $500 for the materials packages!");
		GivePlayerCash(playerid, -500);
		SendClientMessageEx(playerid, COLOR_WHITE, "You have purchased %s materials packages for $500", number_format(DynPoints[point][poAmount][vip]));
	} else {
		if(GetPlayerCash(playerid) < (500 * vip)) return SendClientMessageEx(playerid, COLOR_RED, "You cannot afford the $%s for the materials packages!", number_format((500 * vip)));
		GivePlayerCash(playerid, -(500 * vip));
		SendClientMessageEx(playerid, COLOR_WHITE, "You have purchased %s materials packages for $%s", number_format(DynPoints[point][poAmount][vip]), number_format((500 * vip)));
	}
	MatsAmount[playerid] = DynPoints[point][poAmount][vip];
	if(vip > 0) SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "VIP: You have recieved more materials packages because of your %s.", drank);
	MatDeliver[playerid] = point;
	SetPVarInt(playerid, "tpMatRunTimer", 10);
	SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_TPMATRUNTIMER);

	if((0 <= DynPoints[point][poCaptureGroup] < MAX_GROUPS)) arrGroupData[DynPoints[point][poCaptureGroup]][g_iBudget] +=500;

	SetPlayerCheckpoint(playerid, DynPoints[point][poPos2][0], DynPoints[point][poPos2][1], DynPoints[point][poPos2][2], 5);
	return 1;
}

CMD:getdrugs(playerid, params[]) {

	if(PlayerInfo[playerid][pJob] != 14 && PlayerInfo[playerid][pJob2] != 14 && PlayerInfo[playerid][pJob3] != 14 && !IsACriminal(playerid)) return SendClientMessageEx(playerid,COLOR_GREY,"  You are not a drug smuggler or in a family!");
	if(CheckPointCheck(playerid)) return SendClientMessageEx(playerid, COLOR_WHITE, "Please ensure that your current checkpoint is destroyed first (you either have material packages, or another existing checkpoint).");
	new point, drank[64], vip = ((0 <= PlayerInfo[playerid][pDonateRank] < 5) ? PlayerInfo[playerid][pDonateRank] : 0), string[128];
	switch(vip)
	{
		case 0: drank = "Non-VIP";
		case 1: drank = "Bronze VIP";
		case 2: drank = "Silver VIP";
		case 3: drank = "Gold VIP";
		case 4: drank = "Platinum VIP";
	}
	FetchPoint(playerid, point, (IsABoat(GetPlayerVehicleID(playerid)) ? 15.0 : 3.0));
	if(point == -1) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not at a drug point!");
	if(DynPoints[point][poType] < 1 || DynPoints[point][poType] > 4) return SendClientMessageEx(playerid, COLOR_GRAD1, "This point doesn't offer any drug runs! (TYPE: %d)", DynPoints[point][poType]);
	if(DynPoints[point][poAmount][vip] < 1) return SendClientMessageEx(playerid, COLOR_GRAD1, "There is no material amount set up for %s for this point!", drank);
	if(DynPoints[point][poPos2][0] == 0.0 || DynPoints[point][poPos2][1] == 0.0) return SendClientMessageEx(playerid, COLOR_GRAD1, "The end delivery point hasn't been setup yet!");
	if(DynPoints[point][poBoat] && !IsABoat(GetPlayerVehicleID(playerid))) return SendClientMessageEx(playerid, COLOR_GRAD1, "You need to be in a boat!");

	if(DynPoints[point][poType] == 1) { // Pot
		if(GetPlayerMoney(playerid) < 2000) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot afford the $2,000!");
		GivePlayerCashEx(playerid, TYPE_ONHAND, -2000);
		SendClientMessageEx(playerid, COLOR_WHITE, "You have purchased %sg of pot packages for $2,000", number_format(DynPoints[point][poAmount][vip]));
	}
	if(DynPoints[point][poType] == 2) { // Crack
		if(PlayerInfo[playerid][pDrugSmuggler] < 50) return SendClientMessageEx(playerid, COLOR_GRAD1, "You need to be at least level two drug smuggler to do this run!");
		if(GetPlayerMoney(playerid) < 10000) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot afford the $10,000!");
		GivePlayerCashEx(playerid, TYPE_ONHAND, -10000);
		SendClientMessageEx(playerid, COLOR_WHITE, "You have purchased %sg of crack packages for $10,000!", number_format(DynPoints[point][poAmount][vip]));
	}
	if(DynPoints[point][poType] == 3) { // Meth
		if(PlayerInfo[playerid][pDrugSmuggler] < 200) return SendClientMessageEx(playerid, COLOR_GRAD1, "You need to be at least level four drug smuggler to do this run!");
		if(GetPlayerMoney(playerid) < 25000) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot afford the $25,000!");
		GivePlayerCashEx(playerid, TYPE_ONHAND, -25000);
		SendClientMessageEx(playerid, COLOR_WHITE, "You have purchased %sg of meth packages for $25,000!", number_format(DynPoints[point][poAmount][vip]));
	}
	if(DynPoints[point][poType] == 4) { // Ecstasy
		if(PlayerInfo[playerid][pDrugSmuggler] < 400) return SendClientMessageEx(playerid, COLOR_GRAD1, "You need to be at least level five drug smuggler to do this run!");
		if(GetPlayerMoney(playerid) < 50000) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot afford the $50,000!");
		GivePlayerCashEx(playerid, TYPE_ONHAND, -50000);
		SendClientMessageEx(playerid, COLOR_WHITE, "You have purchased %sg of ecstasy packages for $50,000!", number_format(DynPoints[point][poAmount][vip]));
	}
	format(string, sizeof(string), "* %s takes a drug package.", GetPlayerNameEx(playerid));
	ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	MatsAmount[playerid] = DynPoints[point][poAmount][vip];
	MatDeliver[playerid] = point;
	if(vip > 0) SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "VIP: You have recieved more packages because of your %s.", drank);
	SetPlayerCheckpoint(playerid, DynPoints[point][poPos2][0], DynPoints[point][poPos2][1], DynPoints[point][poPos2][2], 5);
	SetPVarInt(playerid, "tpMatRunTimer", 10);
	SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_TPMATRUNTIMER);
	return 1;
}

CMD:pointtime(playerid, params[])
{
	new point;
	if(sscanf(params, "i", point)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /pointtime [pointid]");
	if((1 <= point <= MAX_POINTS)) {
		if(strcmp(DynPoints[point-1][poName], "NULL", true) == 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "This point hasn't officaly been setup yet!");
		if(DynPoints[point-1][poCapturable] != 1) return SendClientMessageEx(playerid, COLOR_GRAD1, "%s is not ready for takeover.", DynPoints[point-1][poName]);
		if(!DynPoints[point-1][poTimeLeft]) return SendClientMessageEx(playerid, COLOR_GRAD1, "%s is currently is not being captured!", DynPoints[point-1][poName]);
		SendClientMessageEx(playerid, COLOR_YELLOW, "This point is currently being captured by: %s | Time left: %d minute(s)", arrGroupData[DynPoints[point-1][poCapperGroup]][g_szGroupName], DynPoints[point-1][poTimeLeft]);
	} else {
		SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid point ID given - You can only select from 1 - %d!", MAX_POINTS);
	}
	return 1;
}

CMD:gotodpoint(playerid, params[]) {
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1) {
		new pid;
		if(sscanf(params, "d", pid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /gotodpoint [number]");
		if((1 <= pid <= MAX_POINTS)) {
			if(DynPoints[pid-1][poPos][0] == 0.0 || DynPoints[pid-1][poPos][1] == 0.0) return SendClientMessageEx(playerid, COLOR_GRAD1, "The selected point ID hasn't been setup!");
			SetPlayerPos(playerid, DynPoints[pid-1][poPos][0], DynPoints[pid-1][poPos][1], DynPoints[pid-1][poPos][2]);
			PlayerInfo[playerid][pInt] = DynPoints[pid-1][poInt];
			SetPlayerInterior(playerid,DynPoints[pid-1][poInt]);
			PlayerInfo[playerid][pVW] = DynPoints[pid-1][poVW];
	  		SetPlayerVirtualWorld(playerid,DynPoints[pid-1][poVW]);
			GameTextForPlayer(playerid, "~w~Teleporting", 5000, 1);
		} else {
			SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid point ID given - You can only select from 1 - %d!", MAX_POINTS);
		}
	}
	return 1;
}

CMD:capture(playerid, params[])
{
	new point, string[128];
	if(!IsACriminal(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You need to be apart of a criminal organization to do this!");
	FetchPoint(playerid, point, 1.0);
	if(point == -1) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not at a capture point!");
	if(PlayerInfo[playerid][pRank] < arrGroupData[PlayerInfo[playerid][pMember]][g_iPointCapRank]) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not high rank enough to capture points!");
	if(DynPoints[point][poLocked]) return SendClientMessageEx(playerid, COLOR_GRAD1, "This point is not available for capture!");
	if(DynPoints[point][poCapturable] != 1) return SendClientMessageEx(playerid, COLOR_GRAD1, "This point is not ready to be taken over!");
	if(DynPoints[point][poCapperGroup] == PlayerInfo[playerid][pMember]) return SendClientMessageEx(playerid, COLOR_GRAD1, "Your family is currently processing this take over!");
	if(DynPoints[point][poCapping] != INVALID_PLAYER_ID) return SendClientMessageEx(playerid, COLOR_GRAD1, "Someone is currently starting the takeover for this point!");
	if(GetPlayerPing(playerid) > 500) return SendClientMessageEx(playerid, COLOR_WHITE, "You can not capture with 500+ ping!");

	format(string, sizeof(string), "%s is attempting to capture the point (VW: %d).", GetPlayerNameEx(playerid), DynPoints[point][poVW]);
	ProxDetector(70.0, playerid, string, COLOR_RED,COLOR_RED,COLOR_RED,COLOR_RED,COLOR_RED);
	GetPlayerPos(playerid, DynPoints[point][CapturePos][0], DynPoints[point][CapturePos][1], DynPoints[point][CapturePos][2]);

	DynPoints[point][poCapping] = playerid;
	DynPoints[point][poTimeCapLeft] = 10;
	SetTimerEx("ProgressTimer", 1000, 0, "d", point);
	return 1;
}

forward ProgressTimer(id);
public ProgressTimer(id)
{
	szMiscArray[0] = 0;
	new Float: x, Float: y, Float: z;
	if(DynPoints[id][poCapping] != INVALID_PLAYER_ID && IsPlayerConnected(DynPoints[id][poCapping])) {
		if(--DynPoints[id][poTimeCapLeft] > 0) {
			format(szMiscArray, sizeof(szMiscArray), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~%d seconds left", DynPoints[id][poTimeCapLeft]);
			GameTextForPlayer(DynPoints[id][poCapping], szMiscArray, 1100, 3);
			format(szMiscArray, sizeof(szMiscArray), "%s is attempting to capture the point, time left: %d", GetPlayerNameEx(DynPoints[id][poCapping]), DynPoints[id][poTimeCapLeft]);
			UpdateDynamic3DTextLabelText(DynPoints[id][poTextID], COLOR_RED, szMiscArray);
			SetTimerEx("ProgressTimer", 1000, 0, "d", id);
		} else {
			GetPlayerPos(DynPoints[id][poCapping], x, y, z);
			if (DynPoints[id][CapturePos][0] != x || DynPoints[id][CapturePos][1] != y || DynPoints[id][CapturePos][2] != z || GetPVarInt(DynPoints[id][poCapping],"Injured") == 1) {
				SendClientMessageEx(DynPoints[id][poCapping], COLOR_LIGHTBLUE, "You failed to capture. You either moved or died while attempting to capture.");
				DynPoints[id][poCapping] = INVALID_PLAYER_ID;
				DynPoints[id][poTimeCapLeft] = 0;
				UpdatePoint(id);
				return 1;
			}
			if(DynPoints[id][poCapturable] < 1)
			{
			    SendClientMessageEx(DynPoints[id][poCapping], COLOR_LIGHTBLUE, "You failed to capture. The point was already captured.");
				DynPoints[id][poCapping] = INVALID_PLAYER_ID;
				DynPoints[id][poTimeCapLeft] = 0;
				UpdatePoint(id);
				return 1;
			}
			if(playerTabbed[DynPoints[id][poCapping]] != 0)
			{
			    SendClientMessageEx(DynPoints[id][poCapping], COLOR_LIGHTBLUE, "You failed to capture. You were alt-tabbed.");
			    format(szMiscArray, sizeof(szMiscArray), "{AA3333}AdmWarning{FFFF00}: %s (ID %d) may have possibly alt tabbed to capture a point.", GetPlayerNameEx(DynPoints[id][poCapping]), DynPoints[id][poCapping]);
				ABroadCast( COLOR_YELLOW, szMiscArray, 2 );
   				DynPoints[id][poCapping] = INVALID_PLAYER_ID;
				DynPoints[id][poTimeCapLeft] = 0;
				UpdatePoint(id);
			    return 1;
			}
			if(GetPlayerVirtualWorld(DynPoints[id][poCapping]) != DynPoints[id][poVW] || GetPlayerInterior(DynPoints[id][poCapping]) != DynPoints[id][poInt])
			{
			    SendClientMessageEx(DynPoints[id][poCapping], COLOR_LIGHTBLUE, "You failed to capture. You were not in the point virtual/interior world.");
			    format(szMiscArray, sizeof(szMiscArray), "{AA3333}AdmWarning{FFFF00}: %s (ID %d) may have possibly desynced himself to capture a point.", GetPlayerNameEx(DynPoints[id][poCapping]), DynPoints[id][poCapping]);
				ABroadCast( COLOR_YELLOW, szMiscArray, 2 );
   				DynPoints[id][poCapping] = INVALID_PLAYER_ID;
				DynPoints[id][poTimeCapLeft] = 0;
				UpdatePoint(id);
			    return 1;
			}
			if(!IsACriminal(DynPoints[id][poCapping])) {
			    SendClientMessageEx(DynPoints[id][poCapping], COLOR_LIGHTBLUE, "You failed to capture. You either left the group or were kicked!");
				DynPoints[id][poCapping] = INVALID_PLAYER_ID;
				DynPoints[id][poTimeCapLeft] = 0;
				UpdatePoint(id);
				return 1;
			}
			new fam = PlayerInfo[DynPoints[id][poCapping]][pMember];
			DynPoints[id][poPName] = GetPlayerNameEx(DynPoints[id][poCapping]);

			if(IsValidDynamicPickup(DynPoints[id][poPickupID])) DestroyDynamicPickup(DynPoints[id][poPickupID]);
			DynPoints[id][poPickupID] = CreateDynamicPickup(1313, 23, DynPoints[id][poPos][0], DynPoints[id][poPos][1], DynPoints[id][poPos][2], .worldid = DynPoints[id][poVW], .interiorid = DynPoints[id][poInt]);
		   	format(szMiscArray, sizeof(szMiscArray), "%s has attempted to take control of the %s for %s, it will be theirs in 10 minutes.", DynPoints[id][poPName], DynPoints[id][poName], arrGroupData[fam][g_szGroupName]);
			SendClientMessageToAllEx(COLOR_YELLOW, szMiscArray);
			UpdateDynamic3DTextLabelText(DynPoints[id][poTextID], COLOR_YELLOW, szMiscArray);

			DynPoints[id][poCapping] = INVALID_PLAYER_ID;
			DynPoints[id][poTimeCapLeft] = 0;
			DynPoints[id][poCapperGroup] = fam;
			DynPoints[id][poTimeLeft] = 10;
			if(DynPoints[id][CapTimer] != 0) KillTimer(DynPoints[id][CapTimer]);
			DynPoints[id][CapTimer] = SetTimerEx("CaptureTimer", 60000, 1, "d", id);
		}
	} else {
		DynPoints[id][poCapping] = INVALID_PLAYER_ID;
		DynPoints[id][poTimeCapLeft] = 0;
		UpdatePoint(id);
	}
	return 1;
}

forward CaptureTimer(id);
public CaptureTimer(id)
{
	szMiscArray[0] = 0;
	if(--DynPoints[id][poTimeLeft] > 0) {
		format(szMiscArray, sizeof(szMiscArray), "%s has successfully attempted to take over of %s for %s, it will be theirs in %d minutes!", DynPoints[id][poPName], DynPoints[id][poName], arrGroupData[DynPoints[id][poCapperGroup]][g_szGroupName], DynPoints[id][poTimeLeft]);
		UpdateDynamic3DTextLabelText(DynPoints[id][poTextID], COLOR_YELLOW, szMiscArray);
	} else {
		format(szMiscArray, sizeof(szMiscArray), "%s has successfully taken control of the %s for %s.", DynPoints[id][poPName], DynPoints[id][poName], arrGroupData[DynPoints[id][poCapperGroup]][g_szGroupName]);
		SendClientMessageToAllEx(COLOR_YELLOW, szMiscArray);
		DynPoints[id][poCaptureGroup] = DynPoints[id][poCapperGroup];
		DynPoints[id][poCapperGroup] = INVALID_GROUP_ID;
		strmid(DynPoints[id][poCaptureName], DynPoints[id][poPName], 0, 32, 32);
		DynPoints[id][poTimeLeft] = 0;
		DynPoints[id][poCapturable] = 0;
		DynPoints[id][poTimer] = 25;
		KillTimer(DynPoints[id][CapTimer]);
		DynPoints[id][CapTimer] = 0;
		UpdatePoint(id);
		SavePoint(id);
	}
	return 1;
}

stock FetchPoint(playerid, &point, Float:range)
{
	point = -1;
    for(new p = 0; p < MAX_POINTS; p++)
    {
 	    if(IsPlayerInRangeOfPoint(playerid,range,DynPoints[p][poPos][0], DynPoints[p][poPos][1], DynPoints[p][poPos][2]))
		{
			if(GetPlayerVirtualWorld(playerid) == DynPoints[p][poVW] && GetPlayerInterior(playerid) == DynPoints[p][poInt]) {
				point = p;
			}
			break;
	    }
 	}
}

CMD:points(playerid, params[])
{
	szMiscArray[0] = 0;

	for(new i; i < MAX_POINTS; i++)
	{
		if(strcmp(DynPoints[i][poName], "NULL", true) != 0) {
			if(DynPoints[i][poID] != 0)
			{
				if (DynPoints[i][poType] >= 0)
				{
					if(DynPoints[i][poLocked] != 1)
					{
						if((0 <= DynPoints[i][poCaptureGroup] < MAX_GROUPS)) {
							format(szMiscArray, sizeof(szMiscArray), "Point ID: %d | Name: %s | Owner: %s | Captured By: %s | Hours: %d", DynPoints[i][poID], DynPoints[i][poName],arrGroupData[DynPoints[i][poCaptureGroup]][g_szGroupName],DynPoints[i][poCaptureName],DynPoints[i][poTimer]);
						}
						else {
							format(szMiscArray, sizeof(szMiscArray), "Point ID: %d | Name: %s | Owner: Nobody | Captured By: Nobody | Hours: %d", DynPoints[i][poID], DynPoints[i][poName], DynPoints[i][poTimer]);
						}
						SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
					}
				}
			}
		}
	}
	return 1;
}

CMD:editpoint(playerid, params[])
{
	if(PlayerInfo[playerid][pFactionModerator] >= 2 || PlayerInfo[playerid][pAdmin] >= 1337)
	{
		ListPoints(playerid);
	}
	else SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to preform this command.");
	return 1;
}

ListPoints(playerid) {

	new szDialogStr[MAX_POINTS * 25], i;

	while(i < MAX_POINTS) 
	{
		if(strcmp(DynPoints[i][poName], "NULL", true) != 0)
			format(szDialogStr, sizeof szDialogStr, "%s\n(%i) %s{FFFFFF}", szDialogStr, i + 1, DynPoints[i][poName]);
		else
			format(szDialogStr, sizeof szDialogStr, "%s\n(%i) (empty)", szDialogStr, i + 1);
		++i;
	}
	return ShowPlayerDialogEx(playerid, DIALOG_LISTPOINTS, DIALOG_STYLE_LIST, "Edit Points", szDialogStr, "Select", "Cancel");
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	new szDialogStr[1256];
	switch(dialogid)
	{
		case DIALOG_LISTPOINTS:
		{
			if(!response) return 1;
			switch(listitem)
			{
				case 0 .. MAX_POINTS:
				{
					SetPVarInt(playerid, "pEditingPoint", listitem);
					format(szDialogStr, sizeof szDialogStr, "Name: %s\n\
						Type: %s\n\
						Edit Exterior/Interior Position\n\
						Amount Per Hour (%s)\n\
						Edit Delivery Packages\n\
						Edit Capture Time\n\
						Boat Run Only (%s)\n\
						Locked (%s)\n\
						Reset\n\
						Delete", DynPoints[listitem][poName],
						PointTypeToName(DynPoints[listitem][poType]),
						number_format(DynPoints[listitem][poAmountHour]),
						(DynPoints[listitem][poBoat]) ? ("Yes") : ("No"),
						(DynPoints[listitem][poLocked]) ? ("Yes") : ("No")
						);
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
					ShowPlayerDialogEx(playerid, DIALOG_EDITPOINT_TYPE, DIALOG_STYLE_LIST, "Edit Points - Type", "Materials\nPot\nCrack\nMeth\nEcstasy", "Select", "Cancel");
				}
				case 2:
				{
					ShowPlayerDialogEx(playerid, DIALOG_EDITPOINT_POSITION, DIALOG_STYLE_LIST, "Edit Points - Position", "Pickup Point\nDelivery Point", "Select", "Cancel");
				}
				case 3:
				{
					ShowPlayerDialogEx(playerid, DIALOG_EDITPOINT_MATERIALS, DIALOG_STYLE_INPUT, "Edit Points - Amount Per Hour", "Please enter the amount this point will give per hour to the owned group.", "Select", "Cancel");
				}
				case 4:
				{
					if(!response) return ResetDialog(playerid);
					format(szDialogStr, sizeof szDialogStr, "Package Non-VIP (%s)\n\
						Package Bronze VIP (%s)\n\
						Package Silver VIP (%s)\n\
						Package Gold VIP (%s)\n\
						Package Platinum VIP (%s)", 
						number_format(DynPoints[GetPVarInt(playerid, "pEditingPoint")][poAmount][0]),
						number_format(DynPoints[GetPVarInt(playerid, "pEditingPoint")][poAmount][1]),
						number_format(DynPoints[GetPVarInt(playerid, "pEditingPoint")][poAmount][2]),
						number_format(DynPoints[GetPVarInt(playerid, "pEditingPoint")][poAmount][3]),
						number_format(DynPoints[GetPVarInt(playerid, "pEditingPoint")][poAmount][4])
						);
					ShowPlayerDialogEx(playerid, DIALOG_EDITPOINT_MATVIPLIST, DIALOG_STYLE_LIST, "Edit Points - Edit Delivery Packages", szDialogStr, "Select", "Cancel");
				}
				case 5:
				{
					ShowPlayerDialogEx(playerid, DIALOG_EDITPOINT_CAPTIME, DIALOG_STYLE_INPUT, "Edit Points - Capturable Timer", "Specify a time (hours) to when the point is allowed to be captured.\nSetting 0 will announce point is ready for capture!", "Select", "Cancel");
				}
				case 6:
				{
					switch(DynPoints[GetPVarInt(playerid, "pEditingPoint")][poBoat])
					{
						case 0: DynPoints[GetPVarInt(playerid, "pEditingPoint")][poBoat] = 1;
						case 1: DynPoints[GetPVarInt(playerid, "pEditingPoint")][poBoat] = 0;
					}
					ResetDialog(playerid);
					SavePoint(GetPVarInt(playerid, "pEditingPoint"));
				}
				case 7:
				{
					switch(DynPoints[GetPVarInt(playerid, "pEditingPoint")][poLocked])
					{
						case 0: DynPoints[GetPVarInt(playerid, "pEditingPoint")][poLocked] = 1;
						case 1: DynPoints[GetPVarInt(playerid, "pEditingPoint")][poLocked] = 0;
					}
					UpdatePoint(GetPVarInt(playerid, "pEditingPoint"));
					ResetDialog(playerid);
					SavePoint(GetPVarInt(playerid, "pEditingPoint"));
				}
				case 8:
				{
					DynPoints[GetPVarInt(playerid, "pEditingPoint")][poTimer] = 0;
					DynPoints[GetPVarInt(playerid, "pEditingPoint")][poCapturable] = 1;
					DynPoints[GetPVarInt(playerid, "pEditingPoint")][poCaptureGroup] = INVALID_GROUP_ID;
					DynPoints[GetPVarInt(playerid, "pEditingPoint")][poTimeLeft] = 0;
					DynPoints[GetPVarInt(playerid, "pEditingPoint")][poTimeCapLeft] = 0;
					DynPoints[GetPVarInt(playerid, "pEditingPoint")][CapturePos][0] = 0.00000;
					DynPoints[GetPVarInt(playerid, "pEditingPoint")][CapturePos][1] = 0.00000;
					DynPoints[GetPVarInt(playerid, "pEditingPoint")][CapturePos][2] = 0.00000;
					DynPoints[GetPVarInt(playerid, "pEditingPoint")][poCapperGroup] = INVALID_GROUP_ID;
					DynPoints[GetPVarInt(playerid, "pEditingPoint")][poCapping] = INVALID_PLAYER_ID;
					format(DynPoints[GetPVarInt(playerid, "pEditingPoint")][poPName], MAX_PLAYER_NAME, "No One");
					if(DynPoints[GetPVarInt(playerid, "pEditingPoint")][CapTimer] != 0) KillTimer(DynPoints[GetPVarInt(playerid, "pEditingPoint")][CapTimer]);
					DynPoints[GetPVarInt(playerid, "pEditingPoint")][CapTimer] = 0;
					SendClientMessageEx(playerid, COLOR_YELLOW, "You have reset %s's capture timer / group owner.", DynPoints[GetPVarInt(playerid, "pEditingPoint")][poName]);
					UpdatePoint(GetPVarInt(playerid, "pEditingPoint"));
					SavePoint(GetPVarInt(playerid, "pEditingPoint"));
					ResetDialog(playerid);
				}
				case 9:
				{
					for(new p; p < 3; p++)
					{
						DynPoints[GetPVarInt(playerid, "pEditingPoint")][poPos][p] = 0.00000;
						DynPoints[GetPVarInt(playerid, "pEditingPoint")][poPos2][p] = 0.00000;
						DynPoints[GetPVarInt(playerid, "pEditingPoint")][CapturePos][p] = 0.00000;
					}
					for(new m; m < 5; m++)
					{
						DynPoints[GetPVarInt(playerid, "pEditingPoint")][poAmount][m] = 0;
					}
					DynPoints[GetPVarInt(playerid, "pEditingPoint")][poLocked] = 1;
					DynPoints[GetPVarInt(playerid, "pEditingPoint")][poAmountHour] = 0;
					DynPoints[GetPVarInt(playerid, "pEditingPoint")][poInt] = 0;
					DynPoints[GetPVarInt(playerid, "pEditingPoint")][po2Int] = 0;
					DynPoints[GetPVarInt(playerid, "pEditingPoint")][poVW] = 0;
					DynPoints[GetPVarInt(playerid, "pEditingPoint")][po2VW] = 0;
					DynPoints[GetPVarInt(playerid, "pEditingPoint")][poTimer] = 0;
					DynPoints[GetPVarInt(playerid, "pEditingPoint")][poCapturable] = 1;
					DynPoints[GetPVarInt(playerid, "pEditingPoint")][poCaptureGroup] = INVALID_GROUP_ID;
					DynPoints[GetPVarInt(playerid, "pEditingPoint")][poTimeLeft] = 0;
					DynPoints[GetPVarInt(playerid, "pEditingPoint")][poTimeCapLeft] = 0;
					DynPoints[GetPVarInt(playerid, "pEditingPoint")][poCapperGroup] = INVALID_GROUP_ID;
					DynPoints[GetPVarInt(playerid, "pEditingPoint")][poCapping] = INVALID_PLAYER_ID;
					format(DynPoints[GetPVarInt(playerid, "pEditingPoint")][poPName], MAX_PLAYER_NAME, "No One");
					if(DynPoints[GetPVarInt(playerid, "pEditingPoint")][CapTimer] != 0) KillTimer(DynPoints[GetPVarInt(playerid, "pEditingPoint")][CapTimer]);
					DynPoints[GetPVarInt(playerid, "pEditingPoint")][CapTimer] = 0;
					SendClientMessageEx(playerid, COLOR_YELLOW, "You have delete point: %s.", DynPoints[GetPVarInt(playerid, "pEditingPoint")][poName]);
					format(szMiscArray, sizeof(szMiscArray), "%s has deleted point ID: %d", GetPlayerNameEx(playerid), GetPVarInt(playerid, "pEditingPoint"));
					Log("logs/editpoint.log", szMiscArray);
					format(DynPoints[GetPVarInt(playerid, "pEditingPoint")][poName], MAX_PLAYER_NAME, "NULL");
					UpdatePoint(GetPVarInt(playerid, "pEditingPoint"));
					SavePoint(GetPVarInt(playerid, "pEditingPoint"));
					ResetDialog(playerid);
				}
			}
		}
		case DIALOG_EDITPOINT_NAME:
		{
			szMiscArray[0] = 0;
			if(!response) return ResetDialog(playerid);

			if(strlen(inputtext) > 24) return ShowPlayerDialogEx(playerid, DIALOG_EDITPOINT_NAME, DIALOG_STYLE_INPUT, "Edit Points - Name", "Please enter a new name for the point.\n\nPlease specify a name under 25 characters.", "Select", "Cancel"); 
			strcpy(DynPoints[GetPVarInt(playerid, "pEditingPoint")][poName], (isnull(inputtext) ? "NULL" : inputtext), 24);
			format(szMiscArray, sizeof(szMiscArray), "%s has edited point %d's name to %s", GetPlayerNameEx(playerid), GetPVarInt(playerid, "pEditingPoint"), inputtext);
			Log("logs/editpoint.log", szMiscArray);
			ResetDialog(playerid);
			UpdatePoint(GetPVarInt(playerid, "pEditingPoint"));
			SavePoint(GetPVarInt(playerid, "pEditingPoint"));
		}
		case DIALOG_EDITPOINT_TYPE:
		{
			szMiscArray[0] = 0;
			if(!response) return ResetDialog(playerid);
			switch(listitem)
			{
				case 0 .. 4:
				{
					DynPoints[GetPVarInt(playerid, "pEditingPoint")][poType] = listitem;
					format(szMiscArray, sizeof(szMiscArray), "%s has edited point %d's type to %s.", GetPlayerNameEx(playerid), GetPVarInt(playerid, "pEditingPoint"), PointTypeToName(listitem));
					Log("logs/editpoint.log", szMiscArray);
					SendClientMessageEx(playerid, COLOR_YELLOW, "You have edited point %d's type to %s", GetPVarInt(playerid, "pEditingPoint"), PointTypeToName(listitem));
					ResetDialog(playerid);
					UpdatePoint(GetPVarInt(playerid, "pEditingPoint"));
					SavePoint(GetPVarInt(playerid, "pEditingPoint"));
				}
			}
		}
		case DIALOG_EDITPOINT_POSITION:
		{
			new Float: pvPos[3];
			GetPlayerPos(playerid, pvPos[0], pvPos[1], pvPos[2]);
			if(!response) return ResetDialog(playerid);
			switch(listitem)
			{
				case 0:
				{
					DynPoints[GetPVarInt(playerid, "pEditingPoint")][poPos][0] = pvPos[0];
					DynPoints[GetPVarInt(playerid, "pEditingPoint")][poPos][1] = pvPos[1];
					DynPoints[GetPVarInt(playerid, "pEditingPoint")][poPos][2] = pvPos[2];
					DynPoints[GetPVarInt(playerid, "pEditingPoint")][poVW] = GetPlayerVirtualWorld(playerid);
					DynPoints[GetPVarInt(playerid, "pEditingPoint")][poInt] = GetPlayerInterior(playerid);
					SendClientMessageEx(playerid, COLOR_YELLOW, "You updated the points default location.");
					SavePoint(GetPVarInt(playerid, "pEditingPoint"));
				}
				case 1:
				{
					DynPoints[GetPVarInt(playerid, "pEditingPoint")][poPos2][0] = pvPos[0];
					DynPoints[GetPVarInt(playerid, "pEditingPoint")][poPos2][1] = pvPos[1];
					DynPoints[GetPVarInt(playerid, "pEditingPoint")][poPos2][2] = pvPos[2];
					DynPoints[GetPVarInt(playerid, "pEditingPoint")][po2VW] = GetPlayerVirtualWorld(playerid);
					DynPoints[GetPVarInt(playerid, "pEditingPoint")][po2Int] = GetPlayerInterior(playerid);
					SendClientMessageEx(playerid, COLOR_YELLOW, "You updated the delivery destination for %s", DynPoints[GetPVarInt(playerid, "pEditingPoint")][poName]);
					SavePoint(GetPVarInt(playerid, "pEditingPoint"));
				}
			}
			UpdatePoint(GetPVarInt(playerid, "pEditingPoint"));
			format(szMiscArray, sizeof(szMiscArray), "%s has edited point %d's position %d amount to X: %f, Y: %f, Z: %f, VW: %d", GetPlayerNameEx(playerid), GetPVarInt(playerid, "pEditingPoint"), listitem, pvPos[0], pvPos[0], pvPos[0], GetPlayerVirtualWorld(playerid));
			Log("logs/editpoint.log", szMiscArray);
		}
		case DIALOG_EDITPOINT_MATERIALS:
		{
			szMiscArray[0] = 0;
			if(!response) return ResetDialog(playerid);
			if(!IsNumeric(inputtext) || strval(inputtext) < 0) return ShowPlayerDialogEx(playerid, DIALOG_EDITPOINT_MATERIALS, DIALOG_STYLE_INPUT, "Edit Points - Amount Per Hour", "Please enter the amount this point will give per hour to the owned group.\n\nPlease enter a numerical integer and is 0 or above.", "Select", "Cancel");

			DynPoints[GetPVarInt(playerid, "pEditingPoint")][poAmountHour] = strval(inputtext);

			format(szMiscArray, sizeof(szMiscArray), "%s has edited point %d's per hour amount to %d", GetPlayerNameEx(playerid), GetPVarInt(playerid, "pEditingPoint"), inputtext);
			Log("logs/editpoint.log", szMiscArray);
			ResetDialog(playerid);
			SavePoint(GetPVarInt(playerid, "pEditingPoint"));
		}
		case DIALOG_EDITPOINT_MATVIPLIST:
		{
			if(response) {
				SetPVarInt(playerid, "pEditingVIPPoint", listitem);
				ShowPlayerDialogEx(playerid, DIALOG_EDITPOINT_MATVIPSET, DIALOG_STYLE_INPUT, "Edit Points - Package", "Please enter an amount this package is to give to per delivery.", "Select", "Cancel");
			} else {
				ResetDialog(playerid);
			}
		}
		case DIALOG_EDITPOINT_CAPTIME:
		{
			szMiscArray[0] = 0;
			if(!response) return ResetDialog(playerid);
			if(!IsNumeric(inputtext) || strval(inputtext) < 0) return ShowPlayerDialogEx(playerid, DIALOG_EDITPOINT_CAPTIME, DIALOG_STYLE_INPUT, "Edit Points - Capturable Timer", "Specify a time (hours) to when the point is allowed to be captured.\nSetting 0 will announce point is ready for capture!\n\nPlease enter a numerical integer and is 0 or above.", "Select", "Cancel");
			DynPoints[GetPVarInt(playerid, "pEditingPoint")][poCapturable] = (strval(inputtext) == 0 ? 1 : 0);
			DynPoints[GetPVarInt(playerid, "pEditingPoint")][poTimer] = strval(inputtext);
			format(szMiscArray, sizeof(szMiscArray), "%s has edited point %d's capturable timer to %d", GetPlayerNameEx(playerid), GetPVarInt(playerid, "pEditingPoint"), inputtext);
			Log("logs/editpoint.log", szMiscArray);
			ResetDialog(playerid);
			UpdatePoint(GetPVarInt(playerid, "pEditingPoint"));
			SavePoint(GetPVarInt(playerid, "pEditingPoint"));
		}
		case DIALOG_EDITPOINT_MATVIPSET:
		{
			if(response) {
				if(!IsNumeric(inputtext) || strval(inputtext) < 1) return ShowPlayerDialogEx(playerid, DIALOG_EDITPOINT_MATVIPSET, DIALOG_STYLE_INPUT, "Edit Points - Package", "Please enter an amount this package is to give to per delivery.\n\nPlease enter a numerical integer and is 0 or above.", "Select", "Cancel");
				new drank[16];
				szMiscArray[0] = 0;
				switch(GetPVarInt(playerid, "pEditingVIPPoint"))
				{
					case 0: drank = "Non-VIP";
					case 1: drank = "Bronze VIP";
					case 2: drank = "Silver VIP";
					case 3: drank = "Gold VIP";
					case 4: drank = "Platinum VIP";
				}
				DynPoints[GetPVarInt(playerid, "pEditingPoint")][poAmount][GetPVarInt(playerid, "pEditingVIPPoint")] = strval(inputtext);
				DeletePVar(playerid, "pEditingVIPPoint");
				SavePoint(GetPVarInt(playerid, "pEditingPoint"));
				SendClientMessageEx(playerid, COLOR_YELLOW, "You set %s to get %s per package delivery!", drank, number_format(strval(inputtext)));
				format(szMiscArray, sizeof(szMiscArray), "%s has edited point %d's delivery package to %s for %s.", GetPlayerNameEx(playerid), GetPVarInt(playerid, "pEditingPoint"), number_format(strval(inputtext)), drank);
				Log("logs/editpoint.log", szMiscArray);
				format(szDialogStr, sizeof szDialogStr, "Package Non-VIP (%s)\n\
					Package Bronze VIP (%s)\n\
					Package Silver VIP (%s)\n\
					Package Gold VIP (%s)\n\
					Package Platinum VIP (%s)", 
					number_format(DynPoints[GetPVarInt(playerid, "pEditingPoint")][poAmount][0]),
					number_format(DynPoints[GetPVarInt(playerid, "pEditingPoint")][poAmount][1]),
					number_format(DynPoints[GetPVarInt(playerid, "pEditingPoint")][poAmount][2]),
					number_format(DynPoints[GetPVarInt(playerid, "pEditingPoint")][poAmount][3]),
					number_format(DynPoints[GetPVarInt(playerid, "pEditingPoint")][poAmount][4])
					);
				ShowPlayerDialogEx(playerid, DIALOG_EDITPOINT_MATVIPLIST, DIALOG_STYLE_LIST, "Edit Points - Edit Delivery Packages", szDialogStr, "Select", "Cancel");
			} else {
				format(szDialogStr, sizeof szDialogStr, "Package Non-VIP (%s)\n\
					Package Bronze VIP (%s)\n\
					Package Silver VIP (%s)\n\
					Package Gold VIP (%s)\n\
					Package Platinum VIP (%s)", 
					number_format(DynPoints[GetPVarInt(playerid, "pEditingPoint")][poAmount][0]),
					number_format(DynPoints[GetPVarInt(playerid, "pEditingPoint")][poAmount][1]),
					number_format(DynPoints[GetPVarInt(playerid, "pEditingPoint")][poAmount][2]),
					number_format(DynPoints[GetPVarInt(playerid, "pEditingPoint")][poAmount][3]),
					number_format(DynPoints[GetPVarInt(playerid, "pEditingPoint")][poAmount][4])
					);
				ShowPlayerDialogEx(playerid, DIALOG_EDITPOINT_MATVIPLIST, DIALOG_STYLE_LIST, "Edit Points - Edit Delivery Packages", szDialogStr, "Select", "Cancel");
			}
		}
	}
	return 0;
}

stock ResetDialog(playerid) {
	new szDialogStr[1256];
	format(szDialogStr, sizeof szDialogStr, "Name: %s\n\
		Type: %s\n\
		Edit Exterior/Interior Position\n\
		Amount Hour Hour (%s)\n\
		Edit Delivery Packages\n\
		Edit Capture Time\n\
		Boat Run Only (%s)\n\
		Locked (%s)\n\
		Reset\n\
		Delete", DynPoints[GetPVarInt(playerid, "pEditingPoint")][poName],
		PointTypeToName(DynPoints[GetPVarInt(playerid, "pEditingPoint")][poType]),
		number_format(DynPoints[GetPVarInt(playerid, "pEditingPoint")][poAmountHour]),
		(DynPoints[GetPVarInt(playerid, "pEditingPoint")][poBoat]) ? ("Yes") : ("No"),
		(DynPoints[GetPVarInt(playerid, "pEditingPoint")][poLocked]) ? ("Yes") : ("No")
		);
	return ShowPlayerDialogEx(playerid, DIALOG_EDITPOINT, DIALOG_STYLE_LIST, "Edit Points", szDialogStr, "Select", "Cancel");
}

PointTypeToName(id)
{
	new type[24];
	switch(id)
	{
		case 0: format(type, 24, "Materials");
		case 1: format(type, 24, "Pot");
		case 2: format(type, 24, "Crack");
		case 3: format(type, 24, "Meth");
		case 4: format(type, 24, "Ecstasy");
	}
	return type;
}

stock SavePoint(point) {
	new szQuery[2048];
	mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `dynpoints` SET \
	`pointname` = '%e', \
	`type` = %d, \
	`posx` = %f, \
	`posy` = %f, \
	`posz` = %f, \
	`pos2x` = %f, \
	`pos2y` = %f, \
	`pos2z` = %f, \
	`vw` = %d, \
	`int` = %d, \
	`vw2` = %d, \
	`int2` = %d, \
	`boatonly` = %d, \
	`capturename` = '%e', \
	`capturegroup` = %d, \
	`ready` = %d, \
	`timer` = %d, \
	`amounthour` = %d, \
	`amount0` = %d, \
	`amount1` = %d, \
	`amount2` = %d, \
	`amount3` = %d, \
	`amount4` = %d, \
	`locked` = %d WHERE `id` = %d",
	DynPoints[point][poName],
	DynPoints[point][poType],
	DynPoints[point][poPos][0],
	DynPoints[point][poPos][1],
	DynPoints[point][poPos][2],
	DynPoints[point][poPos2][0],
	DynPoints[point][poPos2][1],
	DynPoints[point][poPos2][2],
	DynPoints[point][poVW],
	DynPoints[point][poInt],
	DynPoints[point][po2VW],
	DynPoints[point][po2Int],
	DynPoints[point][poBoat],
	DynPoints[point][poCaptureName],
	DynPoints[point][poCaptureGroup],
	DynPoints[point][poCapturable],
	DynPoints[point][poTimer],
	DynPoints[point][poAmountHour],
	DynPoints[point][poAmount][0],
	DynPoints[point][poAmount][1],
	DynPoints[point][poAmount][2],
	DynPoints[point][poAmount][3],
	DynPoints[point][poAmount][4],
	DynPoints[point][poLocked],
	point + 1);
	mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "i", SENDDATA_THREAD);
}

stock UpdatePoint(id)
{
	new string[256];
	if(IsValidDynamicPickup(DynPoints[id][poPickupID])) DestroyDynamicPickup(DynPoints[id][poPickupID]);
	if(IsValidDynamic3DTextLabel(DynPoints[id][poTextID])) DestroyDynamic3DTextLabel(DynPoints[id][poTextID]);

	if(DynPoints[id][poPos][0] == 0.0) return 1;
	DynPoints[id][poPickupID] = CreateDynamicPickup(((DynPoints[id][poType] == 1) ? 1279 : (DynPoints[id][poType] == 2 || DynPoints[id][poType] == 3 || DynPoints[id][poType] == 4) ? 1241 : 1239), 23, DynPoints[id][poPos][0], DynPoints[id][poPos][1], DynPoints[id][poPos][2], .worldid = DynPoints[id][poVW], .interiorid = DynPoints[id][poInt]);
	switch(DynPoints[id][poType])
	{
		case 0: format(string, sizeof(string), "Materials Pickup (ID: %d)\nType /getmats to get materials.", DynPoints[id][poID]);
		case 1: format(string, sizeof(string), "Pot Pickup (ID: %d)\nType /getdrugs to get pot.", DynPoints[id][poID]);
		case 2: format(string, sizeof(string), "Crack Pickup (ID: %d)\nType /getdrugs to get crack.", DynPoints[id][poID]);
		case 3: format(string, sizeof(string), "Meth Pickup (ID: %d)\nType /getdrugs to get meth.", DynPoints[id][poID]);
		case 4: format(string, sizeof(string), "Ecstasy Pickup (ID: %d)\nType /getdrugs to get ecstasy.", DynPoints[id][poID]);
	}
	if(DynPoints[id][poCapturable] && !DynPoints[id][poLocked]) {
		format(string, sizeof(string), "%s\n%s has become available for capture! Stand here and /capture it.", string, DynPoints[id][poName]);
	}
	DynPoints[id][poTextID] = CreateDynamic3DTextLabel(string, COLOR_YELLOW, DynPoints[id][poPos][0], DynPoints[id][poPos][1], DynPoints[id][poPos][2]+0.6, 10.0, .testlos = 1, .worldid = DynPoints[id][poVW], .interiorid = DynPoints[id][poInt], .streamdistance = 10.0);
	return 1;
}

stock LoadPoints()
{
	printf("[Dynamic Points] Loading Dynamic Points from the database, please wait...");
	mysql_tquery(MainPipeline, "SELECT * FROM `dynpoints`", "OnLoadPoints", "");
}

forward OnLoadPoints();
public OnLoadPoints()
{
	new i, rows, szField[24];
	cache_get_row_count(rows);

	while(i < rows)
	{
		cache_get_value_name(i, "pointname", DynPoints[i][poName], MAX_PLAYER_NAME);
		cache_get_value_name_int(i, "type", DynPoints[i][poType]);
		cache_get_value_name_int(i, "id", DynPoints[i][poID]);
		cache_get_value_name_float(i, "posx", DynPoints[i][poPos][0]);
		cache_get_value_name_float(i, "posy", DynPoints[i][poPos][1]);
		cache_get_value_name_float(i, "posz", DynPoints[i][poPos][2]);
		cache_get_value_name_float(i, "pos2x", DynPoints[i][poPos2][0]);
		cache_get_value_name_float(i, "pos2y", DynPoints[i][poPos2][1]);
		cache_get_value_name_float(i, "pos2z", DynPoints[i][poPos2][2]);
		cache_get_value_name_int(i, "vw", DynPoints[i][poVW]);
		cache_get_value_name_int(i, "int", DynPoints[i][poInt]);
		cache_get_value_name_int(i, "vw2", DynPoints[i][po2VW]);
		cache_get_value_name_int(i, "int2", DynPoints[i][po2Int]);
		cache_get_value_name_int(i, "boatonly", DynPoints[i][poBoat]);
		cache_get_value_name(i, "capturename", DynPoints[i][poCaptureName], MAX_PLAYER_NAME);
		cache_get_value_name_int(i, "capturegroup", DynPoints[i][poCaptureGroup]);
		cache_get_value_name_int(i, "ready", DynPoints[i][poCapturable]);
		cache_get_value_name_int(i, "timer", DynPoints[i][poTimer]);
		cache_get_value_name_int(i, "amounthour", DynPoints[i][poAmountHour]);
		for(new m; m < 5; m++)
		{
			format(szField, sizeof(szField), "amount%d", m);
			cache_get_value_name_int(i, szField, DynPoints[i][poAmount][m]);
		}
		cache_get_value_name_int(i, "locked", DynPoints[i][poLocked]);
		// Ensure our non-loaded data has something.
		DynPoints[i][poTimeLeft] = 0; // 10 minute timer
		DynPoints[i][poTimeCapLeft] = 0; // 10 second timer
		DynPoints[i][CapturePos][0] = 0.00000;
		DynPoints[i][CapturePos][1] = 0.00000;
		DynPoints[i][CapturePos][2] = 0.00000;
		DynPoints[i][poCapperGroup] = INVALID_GROUP_ID;
		DynPoints[i][poCapping] = INVALID_PLAYER_ID;
		format(DynPoints[i][poPName], MAX_PLAYER_NAME, "No One");
		DynPoints[i][CapTimer] = 0;
		UpdatePoint(i);
		i++;
	}
	if(i > 0) printf("[Dynamic Points] %d dynamic points has been loaded.", i);
	else printf("[Dynamic Points] No dynamic points has been loaded.");
	return 1;
}