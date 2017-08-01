/* Under initiategamemode:
GangTag_Load();
*/

/*
	Gangtag System by Jingles
*/

#include <YSI\y_hooks>

/* 
Personally feel this is too much.
hook OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
	if(GetPVarType(playerid, PVAR_GANGTAGTEXT)) DeletePVar(playerid, PVAR_GANGTAGTEXT);
	return 1;
}
*/

hook OnPlayerEnterVehicle(playerid, vehicleid, ispassenger) {
	if(GetPVarType(playerid, PVAR_GANGTAGTEXT)) DeletePVar(playerid, PVAR_GANGTAGTEXT);
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	switch(dialogid)
	{
		case DIALOG_GANGTAGS_INPUT:
		{
			if(!response) return ClearAnimationsEx(playerid), TogglePlayerControllable(playerid, 1), 1;
			if(strlen(inputtext) > MAX_GANGTAGS_LEN) {
				ClearAnimationsEx(playerid);
				DeletePVar(playerid, PVAR_GANGTAGID);
				return SendClientMessage(playerid, COLOR_GRAD1, "Your text is too long.");
			}
			szMiscArray[0] = 0;

			format(szMiscArray, sizeof(szMiscArray), "{AA3333}AdmWarning{FFFF00}: %s (ID: %d) (T:%d) sprayed %s", GetPlayerNameEx(playerid), playerid, GetPVarInt(playerid, PVAR_GANGTAGID), inputtext);
			ABroadCast(COLOR_YELLOW, szMiscArray, 2);

			szMiscArray[0] = 0;

			SetPVarString(playerid, PVAR_GANGTAGTEXT, inputtext);
			for(new i; i < sizeof(szFonts); ++i) format(szMiscArray, sizeof(szMiscArray), "%s%s\n", szMiscArray, szFonts[i]);
			ShowPlayerDialogEx(playerid, DIALOG_GANGTAGS_FONT, DIALOG_STYLE_LIST, "Gang Tags | Font", szMiscArray, "Select", "");
			return 1;
		}
		case DIALOG_GANGTAGS_FONT:
		{
			if(!response) return ClearAnimationsEx(playerid), TogglePlayerControllable(playerid, 1), 1;
			SendClientMessage(playerid, COLOR_GREEN, "[Gang Tags] {DDDDDD}Spraying... Use /tag again to stop tagging.");
			GangTag_InitSeconds(playerid, GANGTAG_TIME, listitem);
		}
		case DIALOG_GANGTAGS_LIST:
		{
			if(!response) return 1;
			new Float:gt_fPos[3];
			GetDynamicObjectPos(arrGangTags[listitem][gt_iObjectID], gt_fPos[0], gt_fPos[1], gt_fPos[2]);
			SetPlayerPos(playerid, gt_fPos[0]+1.0, gt_fPos[1]+1.0, gt_fPos[2] + 0.5);
			return 1;
		}
	}
	return 0;
}


forward GangTag_InitSeconds(playerid, time, fontid);
public GangTag_InitSeconds(playerid, time, fontid)
{
	szMiscArray[0] = 0;
	if(!GetPVarType(playerid, PVAR_GANGTAGTEXT)) return ClearAnimationsEx(playerid), TogglePlayerControllable(playerid, 1), 1;
	time -= 1000;
	new timesec = time/1000;
	format(szMiscArray, sizeof(szMiscArray), "~g~ Spraying... ~w~ %d", timesec);
	GameTextForPlayer(playerid, szMiscArray, 4000, 3);
	if(time > 0) SetTimerEx("GangTag_InitSeconds", 1000, false, "iii", playerid, time, fontid);
	else GangTag_FinishTag(playerid, fontid);
	return 1;
}

GangTag_FinishTag(playerid, fontid)
{
	szMiscArray[0] = 0;
	GetPVarString(playerid, PVAR_GANGTAGTEXT, szMiscArray, sizeof(szMiscArray));
	GangTag_Save(playerid, GetPVarInt(playerid, PVAR_GANGTAGID), szMiscArray, fontid);
	DeletePVar(playerid, PVAR_GANGTAGTEXT);
	ClearAnimationsEx(playerid);
	TogglePlayerControllable(playerid, 1);
	GameTextForPlayer(playerid, "~g~Tagged!", 5000, 3);

	/*new iTurfID = TurfWars_GetTurfID(playerid);
	if(arrTurfWars[iTurfID][tw_iGroupID] != PlayerInfo[playerid][pMember]) {
	
		TurfWars_SetHealth(iTurfID, arrTurfWars[iTurfID][tw_iHealth] - 20);
		Turf_SyncTurf(iTurfID);
	}*/
}

GangTag_Save(iPlayerID, i, text[], fontid)
{
	SetDynamicObjectMaterialText(arrGangTags[i][gt_iObjectID], 0, text, OBJECT_MATERIAL_SIZE_512x512, szFonts[fontid], 1000 / strlen(text), 1, GangTag_IntColor(arrGroupData[PlayerInfo[iPlayerID][pMember]][g_hDutyColour]), 0, 1);
	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "UPDATE `gangtags` SET `gangid` = '%d', `text` = '%e', `fontid` = '%d', `pdbid` = '%d', `pname` = '%s', `color` = '%d' WHERE `id` = '%d'", PlayerInfo[iPlayerID][pMember], text, fontid, GetPlayerSQLId(iPlayerID), GetPlayerNameExt(iPlayerID), arrGroupData[PlayerInfo[iPlayerID][pMember]][g_hDutyColour], i);
	mysql_tquery(MainPipeline, szMiscArray, "GangTag_OnSave", "iis", iPlayerID, i, text);
	DeletePVar(iPlayerID, PVAR_GANGTAGID);
}

forward GangTag_OnSave(iPlayerID, i, text[]);
public GangTag_OnSave(iPlayerID, i, text[])
{
	if(mysql_errno()) print("[Gang Tags] Something went wrong running a query.");
	format(szMiscArray, sizeof(szMiscArray), "%s has tagged on Spray Tag Point: %d (%s)", GetPlayerNameExt(iPlayerID), i, text);
	Log("logs/gangtags.log", szMiscArray);
	return 1;
}

GangTag_Load()
{
	mysql_tquery(MainPipeline, "SELECT *FROM `gangtags` where 1", "GangTag_OnLoad", "");
}

forward GangTag_OnLoad();
public GangTag_OnLoad()
{
	new iRows;
	cache_get_row_count(iRows);
	if(!iRows) return print("[Gang Tags] There are no gang tags in the database.");
	new idx,
		szResult[MAX_GANGTAGS_LEN],
		value,
		Float:fValue;
	while(idx < iRows)
	{
		cache_get_value_name(idx, "text", szResult);
		GangTag_AdmProcess(idx, cache_get_value_name_float(idx, "x", fValue),
			cache_get_value_name_float(idx, "y", fValue),
			cache_get_value_name_float(idx, "z", fValue),
			cache_get_value_name_float(idx, "rx", fValue),
			cache_get_value_name_float(idx, "ry", fValue),
			cache_get_value_name_float(idx, "rz", fValue),
			szResult,
			cache_get_value_name_int(idx, "fontid", value),
			cache_get_value_name_int(idx, "color", value));
		idx++;
	}
	printf("[Gang Tags] Loaded %d gang tags.", idx);
	return 1;
}

GangTag_Create(iPlayerID)
{
	for(new i; i < MAX_GANGTAGS; ++i)
	{
		if(!IsValidDynamicObject(arrGangTags[i][gt_iObjectID]))
		{
			new Float:X, Float:Y, Float:Z;
			GetPlayerPos(iPlayerID, X, Y, Z);
			SetPlayerPos(iPlayerID, X + 0.5, Y + 0.5, Z + 0.5);
			mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "INSERT INTO `gangtags` (`id`, `x`, `y`, `z`, `color`) VALUES ('%d', '%f', '%f', '%f', '%d')", i, X, Y, Z, arrGroupData[PlayerInfo[iPlayerID][pMember]][g_hDutyColour]);
			return mysql_tquery(MainPipeline, szMiscArray, "GangTag_OnCreate", "iifff", iPlayerID, i, X, Y, Z);
		}
	}
	SendClientMessage(iPlayerID, COLOR_GRAD1, "You cannot create any more gang tags.");
	return 1;
}

forward GangTag_OnCreate(iPlayerID, i, Float:X, Float:Y, Float:Z);
public GangTag_OnCreate(iPlayerID, i, Float:X, Float:Y, Float:Z)
{
	new iRows;
	cache_get_row_count(iRows);
	if(!iRows)
	{
		GangTag_AdmProcess(i, X, Y, Z, 0.0, 0.0, 0.0, "/SETUP/", 0, arrGroupData[PlayerInfo[iPlayerID][pMember]][g_hDutyColour]);
		format(szMiscArray, sizeof(szMiscArray), "You have successfully created a gang tag point (ID %d)", i);
		return SendClientMessage(iPlayerID, COLOR_YELLOW, szMiscArray);
	}
	SendClientMessage(iPlayerID, COLOR_GRAD1, "Something went wrong.");
	return 1;
}

GangTag_AdmSave(iPlayerID, i)
{
	new Float:gt_finPos[6];
	GetDynamicObjectPos(arrGangTags[i][gt_iObjectID], gt_finPos[0], gt_finPos[1],  gt_finPos[2]);
	GetDynamicObjectRot(arrGangTags[i][gt_iObjectID], gt_finPos[3], gt_finPos[4],  gt_finPos[5]);
	if(IsValidDynamic3DTextLabel(arrGangTags[i][gt_iTextID])) DestroyDynamic3DTextLabel(arrGangTags[i][gt_iTextID]);
	format(szMiscArray, sizeof(szMiscArray), "Gang Tag Point (ID %d)", i);
	arrGangTags[i][gt_iTextID] = CreateDynamic3DTextLabel(szMiscArray, COLOR_YELLOW, gt_finPos[0], gt_finPos[1],  gt_finPos[2]+2.75, 4.0);
	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "SELECT * FROM `gangtags` WHERE `id` = '%d'", i);
	mysql_tquery(MainPipeline, szMiscArray, "GangTag_OnSetText", "i", i);
	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "UPDATE `gangtags` SET `x` = '%f', `y` = '%f', `z` = '%f', `rx` = '%f', `ry` = '%f', `rz` = '%f' WHERE `id` = '%d'",
		gt_finPos[0], gt_finPos[1],  gt_finPos[2], gt_finPos[3], gt_finPos[4],  gt_finPos[5], i);
	mysql_tquery(MainPipeline, szMiscArray, "GangTag_OnAdmSave", "ii", iPlayerID, i);
}

forward GangTag_OnSetText(i);
public GangTag_OnSetText(i)
{
	new iRows,
		szResult[MAX_GANGTAGS_LEN],
		iCount,
		color,
		fontid;
	cache_get_row_count(iRows);

	while(iCount < iRows)
	{
		cache_get_value_name(iCount, "text", szResult);
		cache_get_value_name_int(iCount, "color", color);
		cache_get_value_name_int(iCount, "fontid", fontid);
		SetDynamicObjectMaterialText(arrGangTags[i][gt_iObjectID], 0, szResult, OBJECT_MATERIAL_SIZE_512x512, szFonts[fontid], 1000 / strlen(szResult), 1, GangTag_IntColor(color), 0, 1);
		++iCount;
	}
	return 1;
}

forward GangTag_OnAdmSave(iPlayerID, i);
public GangTag_OnAdmSave(iPlayerID, i)
{
	if(mysql_errno()) return SendClientMessage(iPlayerID, COLOR_GRAD1, "Something went wrong. Try again later.");
	format(szMiscArray, sizeof(szMiscArray), "You have successfully edited gang tag ID %d", i);
	SendClientMessage(iPlayerID, COLOR_YELLOW, szMiscArray);
	return 1;
}


GangTag_AdmProcess(i, Float:X, Float:Y, Float:Z, Float:RX, Float:RY, Float:RZ, text[], fontid, color)
{
	Iter_Add(GangTags, i);
	if(IsValidDynamicObject(arrGangTags[i][gt_iObjectID])) DestroyDynamicObject(arrGangTags[i][gt_iObjectID]);
	arrGangTags[i][gt_iObjectID] = CreateDynamicObject(GANGTAGS_OBJECTID, X, Y, Z, RX, RY, RZ);
	if(IsValidDynamic3DTextLabel(arrGangTags[i][gt_iTextID])) DestroyDynamic3DTextLabel(arrGangTags[i][gt_iTextID]);
	format(szMiscArray, sizeof(szMiscArray), "Gang Tag Point (ID %d)", i);
	arrGangTags[i][gt_iTextID] = CreateDynamic3DTextLabel(szMiscArray, COLOR_YELLOW, X, Y, Z+2.75, 4.0);
	SetDynamicObjectMaterialText(arrGangTags[i][gt_iObjectID], 0, text, OBJECT_MATERIAL_SIZE_512x512, szFonts[fontid], 1000 / strlen(text), 1, GangTag_IntColor(color), 0, 1);
}

GangTag_Delete(iPlayerID, i)
{
	if(!IsValidDynamicObject(arrGangTags[i][gt_iObjectID])) return SendClientMessage(iPlayerID, COLOR_GRAD1, "You specified an invalid gang tag ID.");
	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "DELETE FROM `gangtags` WHERE `id` = '%d'", i);
	mysql_tquery(MainPipeline, szMiscArray, "GangTag_OnDelete", "ii", iPlayerID, i);
	return 1;
}

forward GangTag_OnDelete(iPlayerID, i);
public GangTag_OnDelete(iPlayerID, i)
{
	if(mysql_errno()) return SendClientMessage(iPlayerID, COLOR_GRAD1, "Something went wrong. Please try again later.");
	DestroyDynamicObject(arrGangTags[i][gt_iObjectID]);
	DestroyDynamic3DTextLabel(arrGangTags[i][gt_iTextID]);
	Iter_Remove(GangTags, i);
	format(szMiscArray, sizeof(szMiscArray), "You have successfully deleted gang tag ID: %d", i);
	SendClientMessage(iPlayerID, COLOR_YELLOW, szMiscArray);
	return 1;
}

forward GangTag_OnCleanTag(iPlayerID, i);
public GangTag_OnCleanTag(iPlayerID, i)
{
	TogglePlayerControllable(iPlayerID, 1);
	ClearAnimationsEx(iPlayerID);
	GameTextForPlayer(iPlayerID, "~g~Cleaned!", 3000, 3);
	GangTag_Save(iPlayerID, i, "-", 0);
	return 1;
}

stock GetGangTags(iPlayerID)
{
	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "SELECT * FROM `gangtags` WHERE 1");
	mysql_tquery(MainPipeline, szMiscArray, "OnGetGangTags", "i", iPlayerID);
}

forward OnGetGangTags(iPlayerID);
public OnGetGangTags(iPlayerID)
{
	new iRows;
	szMiscArray = "Group Name(ID)\tText\n";
	cache_get_row_count(iRows);
	if(iRows > 0)
	{
		new idx,
			i,
			szResult[MAX_GANGTAGS_LEN];

		while(idx < iRows)
		{
			cache_get_value_name(idx,  "text", szResult);
			cache_get_value_name_int(idx, "gangid", i);
			format(szMiscArray, sizeof(szMiscArray), "%s(%d) %s (%d)\t%s\n", szMiscArray, idx, arrGroupData[i][g_szGroupName], i, szResult);
			idx++;
		}
		ShowPlayerDialogEx(iPlayerID, DIALOG_GANGTAGS_LIST, DIALOG_STYLE_TABLIST_HEADERS, "Gang Tags | List", szMiscArray, "Select", "");
		return 1;
	}
	return SendClientMessage(iPlayerID, COLOR_GRAD1, "There are no gang tags in the database.");
}

CMD:gangtaghelp(playerid, params[])
{
	SendClientMessage(playerid, COLOR_GREEN, "______________________________");
	SendClientMessage(playerid, COLOR_GRAD1, "Gang Tags | Commands");
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1 || PlayerInfo[playerid][pGangModerator] > 0) SendClientMessage(playerid, COLOR_LIGHTRED, "[ADM] /createtagpoint | /edittagpoint | /deletetagpoint | /rehashgangtags");
	SendClientMessage(playerid, COLOR_GRAD1, "/tag | /cleantag");
	SendClientMessage(playerid, COLOR_GREEN, "______________________________");
	return 1;
}

IsAStreetSweeper(playerid) {

	if(PlayerInfo[playerid][pJob] == 15 || PlayerInfo[playerid][pJob2] == 15 || arrGroupData[PlayerInfo[playerid][pMember]][g_iGroupType] == 8) return 1;
	return 0;
}

CMD:cleantag(playerid)
{
	if(IsAStreetSweeper(playerid) || strfind(PlayerInfo[playerid][pPrisonReason], "[IC]", true) != -1) {
		new Float:gtPos[3];
		for(new i; i < MAX_GANGTAGS; ++i)
		{
			GetDynamicObjectPos(arrGangTags[i][gt_iObjectID], gtPos[0], gtPos[1], gtPos[2]);
			if(IsPlayerInRangeOfPoint(playerid, 5.0, gtPos[0], gtPos[1], gtPos[2]))
			{
				TogglePlayerControllable(playerid, 0);
				ApplyAnimation(playerid, "SPRAYCAN", "spraycan_fire", 4.1, 1, 1, 1, 1, 0, 0);
				GameTextForPlayer(playerid, "~y~Cleaning...", 5000, 3);
				SetTimerEx("GangTag_OnCleanTag", 15000, false, "ii", playerid, i);
				return 1;
			}
		}
		return SendClientMessage(playerid, COLOR_GRAD1, "You must be near a sprayed wall to clean it.");
	}
	else SendClientMessage(playerid, COLOR_GRAD1, "You must be a street sweeper or other cleaning company to use this command.");
	return 1;
}

CMD:tag(playerid, params[])
{
	if(GetPVarType(playerid, PVAR_GANGTAGTEXT))
	{
		DeletePVar(playerid, PVAR_GANGTAGTEXT);
		ClearAnimationsEx(playerid);
		TogglePlayerControllable(playerid, 1);
		GameTextForPlayer(playerid, "~r~Cancelled!", 5000, 3);
		return 1;
	}
	if(!IsACriminal(playerid)) return SendClientMessage(playerid, COLOR_GRAD1, "You must be in a gang to use this command.");
	if(PlayerInfo[playerid][pRank] == 0) return SendClientMessage(playerid, COLOR_GRAD1, "You need to be at least rank 1 to tag.");
	if(GetPlayerWeapon(playerid) != 41) return SendClientMessage(playerid, COLOR_GRAD1, "You need a spray can to tag a wall.");
	new Float:gtPos[3];
	for(new i; i < MAX_GANGTAGS; ++i)
	{
		GetDynamicObjectPos(arrGangTags[i][gt_iObjectID], gtPos[0], gtPos[1], gtPos[2]);
		if(IsPlayerInRangeOfPoint(playerid, 5.0, gtPos[0], gtPos[1], gtPos[2]))
		{
			SetPVarInt(playerid, PVAR_GANGTAGID, i);
			TogglePlayerControllable(playerid, 0);
			ApplyAnimation(playerid, "SPRAYCAN", "spraycan_fire", 4.1, 1, 1, 1, 1, 0, 0);
			ShowPlayerDialogEx(playerid, DIALOG_GANGTAGS_INPUT, DIALOG_STYLE_INPUT, "Gang Tag Point | Insert text", "Insert the text you would like to spray on the wall", "Spray", "");
			return 1;
		}
	}
	SendClientMessage(playerid, COLOR_GRAD1, "You are not near a tag point.");
	return 1;
}

CMD:gangtags(playerid)
{
	if(PlayerInfo[playerid][pAdmin] > 1 || PlayerInfo[playerid][pGangModerator] > 0) GetGangTags(playerid);
	else SendClientMessage(playerid, COLOR_GRAD1, "You are not authorized to use this command.");
	return 1;
}

CMD:rehashgangtags(playerid)
{
	if(PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pGangModerator] > 0) GangTag_Load();
	else SendClientMessage(playerid, COLOR_GRAD1, "You are not authorized to use this command.");
	return 1;
}

CMD:createtagpoint(playerid)
{
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1 || PlayerInfo[playerid][pGangModerator] > 0)
	{
		if(Iter_Count(GangTags) == MAX_GANGTAGS) return SendClientMessage(playerid, COLOR_GRAD1, "You cannot create more gang tag points.");
		GangTag_Create(playerid);
	}
	else SendClientMessage(playerid, COLOR_GRAD1, "You are not authorized to use this command.");
	return 1;
}

CMD:edittagpoint(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pGangModerator] == 2)
	{
		new i;
		if(sscanf(params, "d", i)) return SendClientMessage(playerid, COLOR_GRAD1, "Usage: /edittag [ID]");
		SetPVarInt(playerid, PVAR_GANGTAGEDITING, i);
		EditDynamicObject(playerid, arrGangTags[i][gt_iObjectID]);
	}
	else SendClientMessage(playerid, COLOR_GRAD1, "You are not authorized to use this command.");
	return 1;
}

CMD:deletetagpoint(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pGangModerator] == 2)
	{
		new i;
		if(sscanf(params, "d", i)) return SendClientMessage(playerid, COLOR_GRAD1, "Usage: /deletetag [ID]");
		GangTag_Delete(playerid, i);
	}
	else SendClientMessage(playerid, COLOR_GRAD1, "You are not authorized to use this command.");
	return 1;
}

CMD:erasetag(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1 || PlayerInfo[playerid][pGangModerator] == 2)
    {
        new i;
        if(sscanf(params, "d", i)) return SendClientMessage(playerid, COLOR_GRAD1, "Usage: /erasetag [ID]");
        GangTag_Save(playerid, i, "Cheeky Nandos", 0);
        return 1;
    }
    else SendClientMessage(playerid, COLOR_GRAD1, "You are not authorized to use this command.");
    return 1;
}

stock GangTag_IntColor(color)
{
	if(color == 0) return color;
	new rgba = 0xFF + (color * 256);
	return rgba >>> 8 | rgba << 24;
}