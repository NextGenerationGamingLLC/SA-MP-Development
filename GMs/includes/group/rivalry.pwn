/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

					Rivalry System
						Jingles

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


hook OnPlayerDisconnect(playerid) {

	if(GetPVarType(playerid, "RepFam_TL")) {

		if(IsValidDynamic3DTextLabel(Text3D:GetPVarInt(playerid, "RepFam_TL"))) {
			DestroyDynamic3DTextLabel(Text3D:GetPVarInt(playerid, "RepFam_TL"));
		}
	}
	DeletePVar(playerid, "RepFam_TL");
	DeletePVar(playerid, "RepFam");
}

timer RepFam_Cooldown[1000 * 120](playerid) { // 2 minutes

	DeletePVar(playerid, "RepFam");
}

Rivalry_Toggle(playerid, bool:bState) {
 
    RemovePlayerAttachedObject(playerid, 8);
    if(bState == true) {
 
        SetPVarInt(playerid, "RepFam_TL", _:CreateDynamic3DTextLabel(
            arrGroupData[PlayerInfo[playerid][pMember]][g_szGroupName],
            arrGroupData[PlayerInfo[playerid][pMember]][g_hDutyColour] * 256 + 0xFF,
            0.0, 0.0, -0.3, 40,
            .attachedplayer = playerid,
            .testlos = 1,
            .worldid = -1,
            .interiorid = -1,
            .streamdistance = 40));
        SetPlayerAttachedObject(playerid, 8, arrGroupData[PlayerInfo[playerid][pMember]][g_iGroupToyID], PlayerInfo[playerid][pGroupToyBone],
            PlayerInfo[playerid][pGroupToy][0], PlayerInfo[playerid][pGroupToy][1], PlayerInfo[playerid][pGroupToy][2],
            PlayerInfo[playerid][pGroupToy][3], PlayerInfo[playerid][pGroupToy][4], PlayerInfo[playerid][pGroupToy][5],
            PlayerInfo[playerid][pGroupToy][6], PlayerInfo[playerid][pGroupToy][7], PlayerInfo[playerid][pGroupToy][8]);
        SendClientMessageEx(playerid, COLOR_WHITE, "You are now representing your gang (/grouptoy to adjust).");
 
        //if(PlayerInfo[playerid][pToggledChats][23] == 0) TextDrawShowForPlayer(playerid, TD_RepFam);
    }
    else {
        DestroyDynamic3DTextLabel(Text3D:GetPVarInt(playerid, "RepFam_TL"));
        DeletePVar(playerid, "RepFam_TL");
        SendClientMessageEx(playerid, COLOR_WHITE, "You are not representing your gang anymore.");
 
        TextDrawHideForPlayer(playerid, TD_RepFam);
    }
}

CMD:aviewrivals(playerid, params[]) {

	if(!IsAdminLevel(playerid, ADMIN_GENERAL)) return 1;
	szMiscArray[0] = 0;
	szMiscArray = "Gang\tRival";
	for(new i; i < MAX_GROUP_RIVALS; ++i) {

		for(new j; j < MAX_GROUPS; ++j) {

			if(arrGroupData[j][g_iRivals][i] != INVALID_GROUP_ID) {

				format(szMiscArray, sizeof(szMiscArray), "%s\n{%s}%s\t{%s}%s",
					szMiscArray,
					Group_NumToDialogHex(arrGroupData[j][g_hDutyColour]),
					arrGroupData[j][g_szGroupName],
					Group_NumToDialogHex(arrGroupData[arrGroupData[j][g_iRivals][i]][g_hDutyColour]),
					arrGroupData[arrGroupData[j][g_iRivals][i]][g_szGroupName]);
			}
		}
	}
	ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_TABLIST_HEADERS, "Gangs | Rival List", szMiscArray, "<<", "");
	return 1;
}


CMD:repfam(playerid, params[]) {
 
    if(!IsACriminal(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not part of a gang.");
    if(PlayerInfo[playerid][pHospital] > 0) return SendClientMessage(playerid, COLOR_GRAD2, "You can't do that at this time!");
    if(GetPVarType(playerid, "RepFam")) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot take your bandana off yet.");
    if(GetPVarType(playerid, "RepFam_TL")) Rivalry_Toggle(playerid, false);
    else {
        SetPVarInt(playerid, "RepFam", 1);
        Rivalry_Toggle(playerid, true);
        defer RepFam_Cooldown(playerid);
    }
    return 1;
}

CMD:repcheck(playerid, params[]) {

	if(!IsACriminal(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not part of a gang.");
	if(GetPVarType(playerid, "RepFam_TL")) SendClientMessageEx(playerid, COLOR_GREEN, "[GANG]: {CCCCCC}You're representing the gang.");
	else SendClientMessageEx(playerid, COLOR_GREEN, "[GANG]: {CCCCCC}You're not representing the gang.");
	return 1;
}

CMD:myrivals(playerid, params[]) {

	if(!IsACriminal(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not part of a gang.");
	if(arrGroupData[PlayerInfo[playerid][pMember]][g_iGroupType] != GROUP_TYPE_CRIMINAL) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not in a gang.");
	Rivalry_GetRivalList(playerid, PlayerInfo[playerid][pMember]);
	return 1;
}

CMD:grouptoy(playerid, params[]) {

	if(!IsACriminal(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not part of a gang.");
	if(arrGroupData[PlayerInfo[playerid][pMember]][g_iGroupToyID] == 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "Your group does not have a toy.");
	if(!GetPVarType(playerid, "RepFam_TL")) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not wearing it.");
	if(isnull(params)) return SendClientMessageEx(playerid, COLOR_GRAD1, "USAGE: /grouptoy [pos/bone]");
	if(strcmp(params, "pos", true) == 0) {
		SetPVarInt(playerid, "EditGToy", 1);
		EditAttachedObject(playerid, 8);
	}
	if(strcmp(params, "bone", true) == 0) {

		szMiscArray[0] = 0;
		for(new i; i < sizeof(HoldingBones); ++i) {
			format(szMiscArray, sizeof(szMiscArray), "%s%s\n", szMiscArray, HoldingBones[i]);
		}
		ShowPlayerDialogEx(playerid, DIALOG_TOYS_GROUP, DIALOG_STYLE_LIST, "Edit Group Toy", szMiscArray, "Select", "Cancel");
	}
	return 1;
}

CMD:editgrouptoy(playerid, params[]) {

	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pGangModerator] < 2) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not allowed to use this command.");

	new iGroupID,
		iObjectID;
	if(sscanf(params, "dd", iGroupID, iObjectID)) return SendClientMessageEx(playerid, COLOR_GRAD1, "USAGE: /editgrouptoy [Group ID] [Object ID]");
	
	if(!(1 <= iGroupID < MAX_GROUPS)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You specified an invalid Group ID.");
	arrGroupData[iGroupID-1][g_iGroupToyID] = iObjectID;
	SaveGroup(iGroupID-1);
	format(szMiscArray, sizeof(szMiscArray), "[Group Toy]: You set %s's toy to object ID %d", arrGroupData[iGroupID-1][g_szGroupName], iObjectID);
	SendClientMessageEx(playerid, COLOR_GRAD1, szMiscArray);
	return 1;
}

CMD:amanagerivals(playerid, params[]) {

	if(IsAdminLevel(playerid, ADMIN_SENIOR, 0) || PlayerInfo[playerid][pGangModerator] >= 2) {

		if(isnull(params)) return SendClientMessageEx(playerid, COLOR_GRAD1, "Usage: /amanagerivals [Group ID]");
		new iGroupID = strval(params);
		if(!(0 < iGroupID <= MAX_GROUPS)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You specified an invalid group ID.");
		iGroupID--; // GroupIDs start at 1 in the dialogs.
		Rivalry_GetRivalList(playerid, iGroupID);
	}
	else SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot use this command.");
	return 1;
}


hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	switch(dialogid) {

		case DIALOG_GROUP_RIVALS: {

			if(!response) {
				DeletePVar(playerid, "AddRival");
				DeletePVar(playerid, "RemRival");
				DeletePVar(playerid, "RGroupID");
				return 1;
			}
			if(GetPVarType(playerid, "AddRival")) {

				new iAddGroupID = ListItemTrackId[playerid][listitem],
					iGroupID = GetPVarInt(playerid, "RGroupID"),
					iFreeSlot[2];

				iFreeSlot[0] = INVALID_GROUP_ID;
				iFreeSlot[1] = INVALID_GROUP_ID;
				DeletePVar(playerid, "RGroupID");

				for(new i; i < MAX_GROUP_RIVALS; ++i) {

					if(arrGroupData[iGroupID][g_iRivals][i] == iAddGroupID) {
						DeletePVar(playerid, "AddRival");
						DeletePVar(playerid, "RemRival");
						return SendClientMessageEx(playerid, COLOR_GRAD1, "These groups are already rivals.");
					}
					if(iFreeSlot[0] == INVALID_GROUP_ID && arrGroupData[iAddGroupID][g_iRivals][i] == INVALID_GROUP_ID) iFreeSlot[0] = i;
					if(iFreeSlot[1] == INVALID_GROUP_ID && arrGroupData[iGroupID][g_iRivals][i] == INVALID_GROUP_ID) iFreeSlot[1] = i;
				}

				if(iFreeSlot[0] == INVALID_GROUP_ID || iFreeSlot[1] == INVALID_GROUP_ID) {
					DeletePVar(playerid, "AddRival");
					DeletePVar(playerid, "RemRival");
					return SendClientMessageEx(playerid, COLOR_GRAD1, "One of the groups cannot have another rival.");
				}

				format(szMiscArray, sizeof(szMiscArray), "[RIVALS]: {FFFF00}%s {CCCCCC}and {FFFF00}%s {CCCCCC}are now rivals.", arrGroupData[iGroupID][g_szGroupName], arrGroupData[iAddGroupID][g_szGroupName]);
				foreach(new i: Player)
				{
					if(PlayerInfo[i][pMember] == iGroupID) {
						ChatTrafficProcess(i, arrGroupData[iGroupID][g_hRadioColour] * 256 + 255, szMiscArray, 12);
					}
					if(PlayerInfo[i][pMember] == iAddGroupID) {
						ChatTrafficProcess(i, arrGroupData[iAddGroupID][g_hRadioColour] * 256 + 255, szMiscArray, 12);
					}
				}

				format(szMiscArray, sizeof(szMiscArray), "Successfully added %s to %s's rivals.", arrGroupData[iAddGroupID][g_szGroupName], arrGroupData[iGroupID][g_szGroupName]);
				SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);

				format(szMiscArray, sizeof(szMiscArray), "Successfully added %s to %s's rivals.", arrGroupData[iGroupID][g_szGroupName], arrGroupData[iAddGroupID][g_szGroupName]);
				SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);

				format(szMiscArray, sizeof(szMiscArray), "%s (%d) added %s to %s's rivals.",
					GetPlayerNameExt(playerid), GetPlayerSQLId(playerid), arrGroupData[iAddGroupID][g_szGroupName], arrGroupData[iGroupID][g_szGroupName]);
				Log("logs/rivals", szMiscArray);

				arrGroupData[iAddGroupID][g_iRivals][iFreeSlot[0]] = iGroupID;
				arrGroupData[iGroupID][g_iRivals][iFreeSlot[1]] = iAddGroupID;

				SaveGroup(iGroupID);
				SaveGroup(iAddGroupID);

				DeletePVar(playerid, "AddRival");
				DeletePVar(playerid, "RGroupID");
				return 1;
			}
			if(GetPVarType(playerid, "RemRival")) {

				new iRemGroupID = ListItemTrackId[playerid][listitem],
					iGroupID = GetPVarInt(playerid, "RGroupID");

				DeletePVar(playerid, "RGroupID");
				format(szMiscArray, sizeof(szMiscArray), "[RIVALS]: {FFFF00}%s {CCCCCC}and {FFFF00}%s {CCCCCC}are no longer rivals.", arrGroupData[iGroupID][g_szGroupName], arrGroupData[iRemGroupID][g_szGroupName]);
				foreach(new i: Player)
				{
					if(PlayerInfo[i][pMember] == iGroupID) {
						ChatTrafficProcess(i, arrGroupData[iGroupID][g_hRadioColour] * 256 + 255, szMiscArray, 12);
					}
					if(PlayerInfo[i][pMember] == iRemGroupID) {
						ChatTrafficProcess(i, arrGroupData[iRemGroupID][g_hRadioColour] * 256 + 255, szMiscArray, 12);
					}
				}

				format(szMiscArray, sizeof(szMiscArray), "Successfully removed %s from %s's rivals.", arrGroupData[iRemGroupID][g_szGroupName], arrGroupData[iGroupID][g_szGroupName]);
				SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);

				format(szMiscArray, sizeof(szMiscArray), "%s (%d) removed %s from %s's rivals.",
					GetPlayerNameExt(playerid), GetPlayerSQLId(playerid), arrGroupData[iRemGroupID][g_szGroupName], arrGroupData[iGroupID][g_szGroupName]);
				Log("logs/rivals", szMiscArray);

				format(szMiscArray, sizeof(szMiscArray), "%s (%d) removed %s from %s's rivals.",
					GetPlayerNameExt(playerid), GetPlayerSQLId(playerid), arrGroupData[iGroupID][g_szGroupName], arrGroupData[iRemGroupID][g_szGroupName]);
				Log("logs/rivals", szMiscArray);

				for(new i; i < MAX_GROUP_RIVALS; ++i) {

					if(arrGroupData[iGroupID][g_iRivals][i] == iRemGroupID) arrGroupData[iGroupID][g_iRivals][i] = INVALID_GROUP_ID;
					if(arrGroupData[iRemGroupID][g_iRivals][i] == iGroupID) arrGroupData[iRemGroupID][g_iRivals][i] = INVALID_GROUP_ID;
				}

				SaveGroup(iGroupID);
				SaveGroup(iRemGroupID);
				DeletePVar(playerid, "RemRival");
				DeletePVar(playerid, "RGroupID");
				return 1;
			}
			if(strcmp("Add Rival", inputtext, true) == 0) {

				new szTitle[GROUP_MAX_NAME_LEN + 24],
					iGroupID = GetPVarInt(playerid, "RGroupID"),
					iDialogCount;

				format(szTitle, sizeof(szTitle), "{%s}%s (ID %d) | Add Rival", Group_NumToDialogHex(arrGroupData[iGroupID][g_hDutyColour]), arrGroupData[iGroupID][g_szGroupName], iGroupID + 1);
				for(new i; i < MAX_GROUPS; ++i) {

					if(arrGroupData[i][g_iGroupType] == GROUP_TYPE_CRIMINAL) {
						ListItemTrackId[playerid][iDialogCount] = i;
						format(szMiscArray, sizeof(szMiscArray), "%s(%d) {%s}%s\n", szMiscArray, i, Group_NumToDialogHex(arrGroupData[i][g_hDutyColour]), arrGroupData[i][g_szGroupName]);
						iDialogCount++;
					}
				}
				SetPVarInt(playerid, "AddRival", 1);
				ShowPlayerDialogEx(playerid, DIALOG_GROUP_RIVALS, DIALOG_STYLE_LIST, szTitle, szMiscArray, "Add", "Cancel");
				return 1;
			}
			if(strcmp("Remove Rival", inputtext, true) == 0) {
				new szTitle[GROUP_MAX_NAME_LEN + 24],
					iGroupID = GetPVarInt(playerid, "RGroupID"),
					iRivalID,
					iDialogCount;

				format(szTitle, sizeof(szTitle), "{%s}%s (ID %d) | Remove Rival", Group_NumToDialogHex(arrGroupData[iGroupID][g_hDutyColour]), arrGroupData[iGroupID][g_szGroupName], iGroupID + 1);
				for(new i; i < MAX_GROUP_RIVALS; ++i) {

					if(arrGroupData[iGroupID][g_iRivals][i] != INVALID_GROUP_ID) {
	
						iRivalID = arrGroupData[iGroupID][g_iRivals][i];
						ListItemTrackId[playerid][iDialogCount] = iRivalID;
						format(szMiscArray, sizeof(szMiscArray), "%s(%d) {%s}%s (ID %d)\n", szMiscArray, iRivalID, Group_NumToDialogHex(arrGroupData[iRivalID][g_hDutyColour]), arrGroupData[iRivalID][g_szGroupName], iRivalID + 1);
						iDialogCount++;
					}
				}
				SetPVarInt(playerid, "RemRival", 1);
				ShowPlayerDialogEx(playerid, DIALOG_GROUP_RIVALS, DIALOG_STYLE_LIST, szTitle, szMiscArray, "Select", "Cancel");
				return 1;
			}
		}
		case DIALOG_TOYS_GROUP: {

			if(!response) return 1;
			PlayerInfo[playerid][pGroupToyBone] = listitem;
			mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "UPDATE `accounts` SET `GroupToyBone` = %d WHERE `id` = %d", listitem, GetPlayerSQLId(playerid));
			mysql_tquery(MainPipeline, szMiscArray, "OnQueryFinish", "i", SENDDATA_THREAD);

			format(szMiscArray, sizeof(szMiscArray), "[Group Toy]: Attached to %s", HoldingBones[listitem]);
			SendClientMessageEx(playerid, COLOR_GRAD1, szMiscArray);
			RemovePlayerAttachedObject(playerid, 8);
			SetPlayerAttachedObject(playerid, 8, arrGroupData[PlayerInfo[playerid][pMember]][g_iGroupToyID], PlayerInfo[playerid][pGroupToyBone],
				PlayerInfo[playerid][pGroupToy][0], PlayerInfo[playerid][pGroupToy][1], PlayerInfo[playerid][pGroupToy][2],
				PlayerInfo[playerid][pGroupToy][3], PlayerInfo[playerid][pGroupToy][4], PlayerInfo[playerid][pGroupToy][5], 
				PlayerInfo[playerid][pGroupToy][6], PlayerInfo[playerid][pGroupToy][7], PlayerInfo[playerid][pGroupToy][8]);
		}
	}
	return 0;
}

Rivalry_GetRivalList(playerid, iGroupID) {

	szMiscArray[0] = 0;

	new iRivalID,
		szTitle[GROUP_MAX_NAME_LEN + 24];

	SetPVarInt(playerid, "RGroupID", iGroupID);
	format(szTitle, sizeof(szTitle), "{%s}%s (ID %d) | Rivals", Group_NumToDialogHex(arrGroupData[iGroupID][g_hDutyColour]), arrGroupData[iGroupID][g_szGroupName], iRivalID + 1);
	for(new i; i < MAX_GROUP_RIVALS; ++i) {
		iRivalID = arrGroupData[iGroupID][g_iRivals][i];
		if(iRivalID == INVALID_GROUP_ID) format(szMiscArray, sizeof(szMiscArray), "%s(%d) (Empty)\n", szMiscArray, i);
		else {
			format(szMiscArray, sizeof(szMiscArray), "%s(%d) {%s} %s (ID %d)\n", 
				szMiscArray, i, Group_NumToDialogHex(arrGroupData[iRivalID][g_hDutyColour]), arrGroupData[iRivalID][g_szGroupName], iRivalID + 1);
		}
	}
	if(IsAdminLevel(playerid, ADMIN_SENIOR, 0) || PlayerInfo[playerid][pGangModerator] >= 2) strcat(szMiscArray, "Add Rival\nRemove Rival", sizeof(szMiscArray));
	ShowPlayerDialogEx(playerid, DIALOG_GROUP_RIVALS, DIALOG_STYLE_LIST, szTitle, szMiscArray, "Select", "Cancel");
}

hook OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart) {

	if(GetPVarType(playerid, "RepFam")) {

		RepFam_Cooldown(playerid);
		SetPVarInt(playerid, "RepFam", 1);
		defer RepFam_Cooldown[1000 * 30](playerid);
	}
}

hook OnPlayerConnect(playerid)
{
    TD_RepFam = TextDrawCreate(581.5, 414, "/repfam");
    TextDrawFont(TD_RepFam, 2);
    TextDrawLetterSize(TD_RepFam, 0.25, 2.8000000000000003);
    TextDrawColor(TD_RepFam, 0xffffffFF);
    TextDrawSetOutline(TD_RepFam, true);
    TextDrawSetProportional(TD_RepFam, true);
    TextDrawSetShadow(TD_RepFam, 1);
}