/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

					New Turfs System
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

/* OUTLINE

	- Turfs can belong to ANY group.
	- Turf timers.
	- Use Streamer Areas + GangZones.
	- Add vulnerability.
	- Sale taxes.
	- Levels
	- Health
	- Health-dependant timers
	- Pre-defined turfs.
*/

#include <YSI\y_hooks>

// All player booleans variables go here to reduce memory:


new Text:TW_TextDraws[5];
new PlayerText:TW_PTextDraws[MAX_PLAYERS][6];

task TurfWars_Task[60000 * 30]() { // Every 10 minutes.

	mysql_tquery(MainPipeline, "SELECT `timestamp`, `shutdown` FROM `turfs` WHERE `vulnerable` = '0'", true, "TurfWars_OnTask", "");
}

hook OnGameModeInit() {

	for(new i; i < sizeof(arrTurfWarsBits); ++i) {
		arrTurfWars[i][tw_bVulnerable] = false;
		Bit_Off(arrTurfWarsBits[i], tw_bDisabled);
	}
	TurfWars_LoadGUI();
}

hook OnGameModeExit() {

	TextDrawHideForAll(TW_TextDraws[0]);
	TextDrawHideForAll(TW_TextDraws[1]);
	TextDrawHideForAll(TW_TextDraws[2]);
	TextDrawHideForAll(TW_TextDraws[3]);
	TextDrawHideForAll(TW_TextDraws[4]);
	TextDrawDestroy(TW_TextDraws[0]);
	TextDrawDestroy(TW_TextDraws[1]);
	TextDrawDestroy(TW_TextDraws[2]);
	TextDrawDestroy(TW_TextDraws[3]);
	TextDrawDestroy(TW_TextDraws[4]);
	return 1;
}

hook OnPlayerConnect(playerid) {
	TurfWars_GUI(playerid, false);
	TurfWars_LoadPGUI(playerid);
}

hook OnPlayerDisconnect(playerid, reason) {

	PlayerTextDrawHide(playerid, TW_PTextDraws[playerid][0]);
	PlayerTextDrawHide(playerid, TW_PTextDraws[playerid][1]);
	PlayerTextDrawHide(playerid, TW_PTextDraws[playerid][2]);
	PlayerTextDrawHide(playerid, TW_PTextDraws[playerid][3]);
	PlayerTextDrawHide(playerid, TW_PTextDraws[playerid][4]);
	PlayerTextDrawHide(playerid, TW_PTextDraws[playerid][5]);
	PlayerTextDrawDestroy(playerid, TW_PTextDraws[playerid][0]);
	PlayerTextDrawDestroy(playerid, TW_PTextDraws[playerid][1]);
	PlayerTextDrawDestroy(playerid, TW_PTextDraws[playerid][2]);
	PlayerTextDrawDestroy(playerid, TW_PTextDraws[playerid][3]);
	PlayerTextDrawDestroy(playerid, TW_PTextDraws[playerid][4]);
	PlayerTextDrawDestroy(playerid, TW_PTextDraws[playerid][5]);
}

hook OnPlayerEnterDynamicArea(playerid, areaid) {

	if(Bit_State(arrPlayerBits[playerid], pTurfRadar)) {

		// new iTurfID = Streamer_GetIntData(STREAMER_TYPE_AREA, areaid, E_STREAMER_EXTRA_ID);
		for(new i; i < MAX_TURFS; ++i) {
			if(areaid == arrTurfWars[i][tw_iAreaID]) {
				TurfWars_SyncGUI(playerid, i);
				if(i != 369) TurfWars_AddTraffic(i);
			}
		}
	}
}

hook OnPlayerDeath(playerid, killerid, reason) {

	/*
	if(GetPVarType(playerid, "TW_CapLeader")) {
		TurfWars_FinalizeCapture(GetPVarInt(playerid, "TW_CapLeader"), false);
	}
	*/
	TurfWars_AddDeath(playerid);
	defer TurfWars_CalcHealth(playerid);
}

timer TurfWars_CalcHealth[500](playerid) {

	new iTurfID = TurfWars_GetTurfID(playerid);
	if(GetGVarType("TW_Capturer", iTurfID) && PlayerInfo[playerid][pMember] != GetGVarInt("TW_Capturer", iTurfID)) {
		TurfWars_SetHealth(iTurfID, arrTurfWars[iTurfID][tw_iHealth] + 5);
	}
	if(GetGVarType("TW_Capturer", iTurfID) && PlayerInfo[playerid][pMember] == arrTurfWars[iTurfID][tw_iGroupID]) {
		TurfWars_SetHealth(iTurfID, arrTurfWars[iTurfID][tw_iHealth] - 5);
	}
}

TurfWars_AddDeath(playerid) {

	new iTurfID = TurfWars_GetTurfID(playerid);
	if(iTurfID != 369) arrTurfWars[iTurfID][tw_iDeaths]++;
}

TurfWars_AddTraffic(iTurfID) {

	if(iTurfID != 369) arrTurfWars[iTurfID][tw_iTraffic]++;
}

TurfWars_TurfTax(playerid, szType[], iAmount) {

	new iTurfID = TurfWars_GetTurfID(playerid);
	if(iAmount > 500000) SendClientMessageEx(playerid, COLOR_YELLOW, "[Turf] The tax you had to pay was larger than $500.000. You therefore only have to pay:");
	iAmount = 500000;
	if(iTurfID != 369 && arrTurfWars[iTurfID][tw_iGroupID] != INVALID_GROUP_ID && !Bit_State(arrTurfWarsBits[iTurfID], tw_bShutdown) &&
		PlayerInfo[playerid][pMember] != arrTurfWars[iTurfID][tw_iGroupID] && !Bit_State(arrTurfWarsBits[iTurfID], tw_bDisabled)) {

		new iTurfTax = iAmount * arrGroupData[arrTurfWars[iTurfID][tw_iGroupID]][g_iTurfTax] / 100;

		if(iTurfTax > 500000) iTurfTax = 500000;
		if(iTurfTax < 0) iTurfTax = 0;
		new oldbalance = arrGroupData[arrTurfWars[iTurfID][tw_iGroupID]][g_iBudget];
		szMiscArray[0] = 0;
		arrTurfWars[iTurfID][tw_iRevenue] += iTurfTax;
		arrGroupData[arrTurfWars[iTurfID][tw_iGroupID]][g_iBudget] += iTurfTax;
		format(szMiscArray, sizeof(szMiscArray), "[Turf]: {CCCCCC}You paid {EEEEEE}$%s {CCCCCC}turf tax {EEEEEE}(%d percent) {CCCCCC}for the {EEEEEE}%s {CCCCCC}you sold.",
			number_format(iTurfTax), arrGroupData[arrTurfWars[iTurfID][tw_iGroupID]][g_iTurfTax], szType, number_format(iTurfTax));
		SendClientMessageEx(playerid, COLOR_GREEN, szMiscArray);
		format(szMiscArray, sizeof(szMiscArray), "[GANG DEBUG] TURF TAX | GANG - %s, TURF TAX - %s, OLD GBALANCE - %s, NEW GBALANCE - %d.",
		arrGroupData[arrTurfWars[iTurfID][tw_iGroupID]][g_szGroupName], number_format(iTurfTax), number_format(oldbalance), number_format(arrGroupData[arrTurfWars[iTurfID][tw_iGroupID]][g_iBudget]));
		Log("logs/gangdebuglog.log", szMiscArray);
		GivePlayerCash(playerid, -iTurfTax);
	}
}

forward TurfWars_OnTask();
public TurfWars_OnTask() {

	new iRows,
		iFields,
		iCount,
		iTimeStamp,
		iShutDown;

	cache_get_data(iRows, iFields, MainPipeline);

	while(iCount < iRows) {

		iTimeStamp = cache_get_field_content_int(iCount, "timestamp", MainPipeline);
		iShutDown = cache_get_field_content_int(iCount, "shutdown", MainPipeline);
		if(gettime() > iTimeStamp) {
			if(iShutDown) {
				TurfWars_SendGroupMessage(arrTurfWars[iCount][tw_iGroupID], COLOR_GREEN, "[TURF]: Your turf is no longer shutdown.");
				Bit_Off(arrTurfWarsBits[iCount], tw_bShutdown);
			}
			arrTurfWars[iCount][tw_bVulnerable] = true;
			if(arrTurfWars[iCount][tw_iGroupID] != INVALID_GROUP_ID) {
				format(szMiscArray, sizeof(szMiscArray), "[TURF]: {FFFF00}%s (ID %d) has become vulnerable!", gSAZones[iCount][SAZONE_NAME], iCount);
				TurfWars_SendGroupMessage(arrTurfWars[iCount][tw_iGroupID], COLOR_GREEN, szMiscArray);
			}
			format(szMiscArray, sizeof(szMiscArray), "UPDATE `turfs` SET `vulnerable` = '1', `shutdown` = '0', `timestamp` = '0' WHERE `id` = '%d'", iCount);
			mysql_tquery(MainPipeline, szMiscArray, false, "OnQueryFinish", "i", SENDDATA_THREAD);
		}
		TurfWars_SaveTurf(iCount);
		iCount++;
	}
}

TurfWars_SaveAll() {

	for(new i; i < sizeof(gSAZones); ++i) TurfWars_SaveTurf(i);
}

TurfWars_SaveTurf(iTurfID) {
	format(szMiscArray, sizeof(szMiscArray), "UPDATE `turfs` SET `traffic` = %d, `deaths` = %d, `revenue` = %d, `turfmode` = '%d'  WHERE `id` = '%d'",
		arrTurfWars[iTurfID][tw_iTraffic], arrTurfWars[iTurfID][tw_iDeaths], arrTurfWars[iTurfID][tw_iRevenue],	Bit_State(arrTurfWarsBits[iTurfID], tw_bTurfMode), iTurfID);
	mysql_tquery(MainPipeline, szMiscArray, false, "OnQueryFinish", "i", SENDDATA_THREAD);
}

// gSAZones[i][SAZONE_AREA][0]

TurfWars_LoadData() {

	mysql_tquery(MainPipeline, "SELECT `linkedid`, `groupid`, `vulnerable`, `disabled`, `shutdown`, `health`, `level`, `headquarter`, `traffic`, `deaths`, `revenue`, `turfmode` FROM `turfs`", true, "TurfWars_OnLoadData", "");
}

forward TurfWars_OnLoadData();
public TurfWars_OnLoadData() {

	new iRows,
		iFields,
		iCount;

	cache_get_data(iRows, iFields, MainPipeline);

	while(iCount < iRows) {

		arrTurfWars[iCount][tw_iLinkedID] = cache_get_field_content_int(iCount, "linkedid", MainPipeline);
		arrTurfWars[iCount][tw_iGroupID] = cache_get_field_content_int(iCount, "groupid", MainPipeline);
		arrTurfWars[iCount][tw_iHealth] = cache_get_field_content_int(iCount, "health", MainPipeline);
		arrTurfWars[iCount][tw_iLevel] = cache_get_field_content_int(iCount, "level", MainPipeline);
		arrTurfWars[iCount][tw_iTraffic] = cache_get_field_content_int(iCount, "traffic", MainPipeline);
		arrTurfWars[iCount][tw_iDeaths] = cache_get_field_content_int(iCount, "deaths", MainPipeline);
		arrTurfWars[iCount][tw_iRevenue] = cache_get_field_content_int(iCount, "revenue", MainPipeline);
		if(cache_get_field_content_int(iCount, "vulnerable", MainPipeline)) arrTurfWars[iCount][tw_bVulnerable] = true; // Bit_On(arrTurfWarsBits[iCount], tw_bVulnerable);
		if(cache_get_field_content_int(iCount, "disabled", MainPipeline)) Bit_On(arrTurfWarsBits[iCount], tw_bDisabled);
		if(cache_get_field_content_int(iCount, "headquarter", MainPipeline)) Bit_On(arrTurfWarsBits[iCount], tw_bHeadquarter);
		if(cache_get_field_content_int(iCount, "shutdown", MainPipeline)) Bit_On(arrTurfWarsBits[iCount], tw_bShutdown);
		if(cache_get_field_content_int(iCount, "turfmode", MainPipeline)) Bit_On(arrTurfWarsBits[iCount], tw_bTurfMode);
		iCount++;
	}
	TurfWars_InitZones();
}

TurfWars_Rehash() {

	for(new i; i < sizeof(gSAZones); ++i) {
		if(IsValidDynamicArea(arrTurfWars[i][tw_iAreaID])) DestroyDynamicArea(arrTurfWars[i][tw_iAreaID]);
		GangZoneDestroy(arrTurfWars[i][tw_iGZoneID]);
	}
	TurfWars_LoadData();
}

TurfWars_InitZones() {

	// new j;

	for(new i; i < sizeof(gSAZones); ++i) {

		arrTurfWars[i][tw_iAreaID] = CreateDynamicRectangle(gSAZones[i][SAZONE_AREA][0], gSAZones[i][SAZONE_AREA][1], gSAZones[i][SAZONE_AREA][3], gSAZones[i][SAZONE_AREA][4], 0, 0);
		arrTurfWars[i][tw_iGZoneID] = GangZoneCreate(gSAZones[i][SAZONE_AREA][0], gSAZones[i][SAZONE_AREA][1], gSAZones[i][SAZONE_AREA][3], gSAZones[i][SAZONE_AREA][4]);

		/*
		format(szMiscArray, sizeof(szMiscArray), "INSERT INTO `turfs` (`zonename`, `minx`, `miny`, `maxx`, `maxy`) VALUES ('%s', '%f', '%f', '%f', '%f')",
			gSAZones[i][SAZONE_NAME], gSAZones[i][SAZONE_AREA][0], gSAZones[i][SAZONE_AREA][1], gSAZones[i][SAZONE_AREA][3], gSAZones[i][SAZONE_AREA][4]);

		mysql_tquery(MainPipeline, szMiscArray, false, "OnQueryFinish", "i", SENDDATA_THREAD);
		*/

		// if(strcmp(gSAZones[i][SAZONE_NAME], gSAZones[i-1][SAZONE_NAME], true)) j++;
		
		/*
		format(szMiscArray, sizeof(szMiscArray), "UPDATE `turfs` SET `linkedID` = '%d' WHERE `id` = '%d'", j, i + 1);
		mysql_tquery(MainPipeline, szMiscArray, false, "OnQueryFinish", "i", SENDDATA_THREAD);
		*/

		// arrTurfWars[i][tw_iLinkedID] = j;
		// Streamer_SetIntData(STREAMER_TYPE_AREA, arrTurfWars[i][tw_iAreaID], E_STREAMER_EXTRA_ID, i);
		printf("[TW] Created zone (%d): %s", i, gSAZones[i][SAZONE_NAME]);
	}
}

CMD:setturftax(playerid, params[]) {

	if(PlayerInfo[playerid][pMember] == INVALID_GROUP_ID) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not in a group.");
	if(PlayerInfo[playerid][pLeader] == INVALID_GROUP_ID) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not a group leader.");
	if(isnull(params)) return SendClientMessageEx(playerid, COLOR_GRAD1, "USAGE: /setturftax [percentage] (between 0 and 10)");
	new iTurfTax = strval(params);
	if(!(0 <= iTurfTax < 11)) return SendClientMessageEx(playerid, COLOR_GRAD1, "Enter a value between 0 and 10.");

	arrGroupData[PlayerInfo[playerid][pMember]][g_iTurfTax] = iTurfTax;
	format(szMiscArray, sizeof(szMiscArray), "[Turf]: {CCCCCC}%s set the turf tax to {FFFF00}%d%", GetPlayerNameEx(playerid), iTurfTax);
	TurfWars_SendGroupMessage(PlayerInfo[playerid][pMember], COLOR_GREEN, szMiscArray);
	return 1;
}

CMD:turflist(playerid, params[]) {

	szMiscArray[0] = 0;
	for(new i; i < sizeof(gMainZones) - 1; ++i) {

		format(szMiscArray, sizeof(szMiscArray), "%s%s\n", szMiscArray, gMainZones[i][SAZONE_NAME]);
	}
	ShowPlayerDialogEx(playerid, DIALOG_TURFS_AREA, DIALOG_STYLE_LIST, "Turf List | Choose Area", szMiscArray, "Select", "Cancel");
	return 1;
}

TurfWars_GetTurfCount(iTurfID, iGroupID) {

	new iMemberCount;
	foreach(new p : Player) {

		if(iGroupID == PlayerInfo[p][pMember]) { 
			if(TurfWars_GetTurfID(p) == iTurfID) iMemberCount++;
		}
	}
	return iMemberCount;
}

TurfWars_CapCheck(playerid, iTurfID) {

	new iCount,
		iCapID = GetGVarInt("TW_Capturer", iTurfID);

	if(GetGVarType("TW_Capturer", iTurfID) && arrGroupData[iCapID][g_iGroupType] == GROUP_TYPE_LEA) {
		foreach(new p : Player) {

			if(IsPlayerInDynamicArea(p, arrTurfWars[iTurfID][tw_iAreaID]) && !GetPVarInt(p, "Injured") && PlayerInfo[p][pMember] == iCapID) iCount++;
		}
		if(iCount == 0) return 1;
		format(szMiscArray, sizeof(szMiscArray), "[TURF]: {CCCCCC}There's {FFFF00}%d {CCCCCC}LEOs left on the turf.", iCount);
		SendClientMessageEx(playerid, COLOR_GREEN, szMiscArray);
	}
	else {
		foreach(new p : Player) {
			if(IsPlayerInDynamicArea(p, arrTurfWars[iTurfID][tw_iAreaID]) && !GetPVarInt(p, "Injured") && PlayerInfo[p][pMember] == arrTurfWars[iTurfID][tw_iGroupID] &&
				PlayerInfo[p][pMember] != PlayerInfo[playerid][pMember] && PlayerInfo[p][pMember] != INVALID_PLAYER_ID) iCount++;
		}
		if(iCount == 0) return 1;
		format(szMiscArray, sizeof(szMiscArray), "[TURF]: {CCCCCC}There's {FFFF00}%d {CCCCCC}gang members left on the turf.", iCount);
		SendClientMessageEx(playerid, COLOR_GREEN, szMiscArray);
	}
	return 0;
}

CMD:turfmode(playerid, params[]) {

	if(PlayerInfo[playerid][pAdmin] < 1337 || PlayerInfo[playerid][pGangModerator] < 2) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot use this command.");
	new iTurfID = TurfWars_GetTurfID(playerid);
	if(iTurfID == 369) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not in an editable turf.");
	
	if(Bit_State(arrTurfWarsBits[iTurfID], tw_bTurfMode)) {
		Bit_Off(arrTurfWarsBits[iTurfID], tw_bTurfMode);
		SendClientMessageEx(playerid, COLOR_GRAD1, "This turf is now unlinked.");
	}
	else {
		Bit_On(arrTurfWarsBits[iTurfID], tw_bTurfMode);
		SendClientMessageEx(playerid, COLOR_GRAD1, "This turf is now linked.");
	}
	return 1;
}

CMD:turfhelp(playerid, params[]) {

	SendClientMessageEx(playerid, COLOR_GREEN, "__________[Turf System]__________");
	SendClientMessageEx(playerid, COLOR_GRAD1, "/turfs | /turflist | /claim | /myturfs | /turfinfo | /turfstats | /upgradeturf | /healturf | /setturftax");
	if(IsACop(playerid)) SendClientMessageEx(playerid, COLOR_GRAD1, "[LEO] /shutdown");
	if(IsAdminLevel(playerid, ADMIN_SENIOR, 0)) SendClientMessageEx(playerid, COLOR_YELLOW, "[ADMIN]: /editturf | /turfmode (link/unlink them) | /rehashturfs");
	return 1;
}

CMD:rehashturfs(playerid, params[]) {

	if(!IsAdminLevel(playerid, ADMIN_HEAD)) return 1;
	TurfWars_Rehash();
	SendClientMessageEx(playerid, COLOR_GRAD1, "You reloaded all turfs in the server.");
	return 1;
}

CMD:claim(playerid, params[]) {

	if(!IsACriminal(playerid) && !IsAGovernment(playerid) && !IsMDCPermitted(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot claim turfs.");
	if(GetPVarType(playerid, "CapCheck")) {
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are already trying to claim a turf.");
		return 1;
	}
	if(PlayerInfo[playerid][pRank] < arrGroupData[PlayerInfo[playerid][pMember]][g_iTurfCapRank]) {
		return SendClientMessageEx(playerid, COLOR_GRAD2, "Your rank is not high enough to claim turfs!");
    }
	new iTurfID = TurfWars_GetTurfID(playerid);
	if(Bit_State(arrTurfWarsBits[iTurfID], tw_bDisabled)) return SendClientMessage(playerid, COLOR_GRAD1, "This turf is currently disabled.");
	if(Bit_State(arrTurfWarsBits[iTurfID], tw_bHeadquarter)) return SendClientMessage(playerid, COLOR_GRAD1, "This turf is a headquarter. You need special permissions to claim it.");
	if(arrTurfWars[iTurfID][tw_bVulnerable] == false) {
		format(szMiscArray, sizeof(szMiscArray), "This turf (ID %d) is not vulnerable.", iTurfID);
		return SendClientMessage(playerid, COLOR_GRAD1, szMiscArray);
	}

	if(TurfWars_GetTurfCount(iTurfID, PlayerInfo[playerid][pMember]) < 3 && !IsAdminLevel(playerid, ADMIN_SENIOR, 0)) {
		return SendClientMessageEx(playerid, COLOR_GRAD1, "You need at least 3 of your family/gang members on the turf to be able to claim it.");
	}
	foreach(new p : Player) if(GetPVarType(p, "CapCheck") && PlayerInfo[p][pMember] == PlayerInfo[playerid][pMember]) {
    	return SendClientMessageEx(playerid, COLOR_GRAD1, "Someone in your group is already capturing a turf.");
    }
    if(TurfWars_CapCheck(playerid, iTurfID) == 0) return 1;
	if(arrTurfWars[iTurfID][tw_iGroupID] != INVALID_GROUP_ID) {

		format(szMiscArray, sizeof(szMiscArray), "[TURF]: {FFFF00} %s is attempting to capture %s.", arrGroupData[PlayerInfo[playerid][pMember]][g_szGroupName], gSAZones[iTurfID][SAZONE_NAME]);
		foreach(new p : Player) {
			if(PlayerInfo[p][pMember] == arrTurfWars[iTurfID][tw_iGroupID]) SendClientMessageEx(p, COLOR_GREEN, szMiscArray);
		}
	}
	if(GetGVarType("TW_Capturer", iTurfID)) {

		if(GetGVarInt("TW_Capturer", iTurfID) == PlayerInfo[playerid][pMember]) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are already capturing this turf.");
		new iGroupID = GetGVarInt("TW_Capturer", iTurfID);
		format(szMiscArray, sizeof(szMiscArray), "[TURF]: {FFFF00}You are attempting to take a turf %s is capturing.", arrGroupData[iGroupID][g_szGroupName]);
		foreach(new p : Player) {
			if(PlayerInfo[p][pMember] == PlayerInfo[playerid][pMember]) SendClientMessageEx(p, COLOR_GREEN, szMiscArray);
		}
		format(szMiscArray, sizeof(szMiscArray), "[TURF]: {FFFF00}%s is attempting to take over the turf.", arrGroupData[PlayerInfo[playerid][pMember]][g_szGroupName]);
		foreach(new p : Player) {
			if(PlayerInfo[p][pMember] == iGroupID) SendClientMessageEx(p, COLOR_GREEN, szMiscArray);
		}
	}

	format(szMiscArray, sizeof(szMiscArray), "[TURF]: {FFFF00}%s is attempting to take over %s (ID %d).", GetPlayerNameEx(playerid), gSAZones[iTurfID][SAZONE_NAME], iTurfID);
	foreach(new p : Player) if(PlayerInfo[p][pMember] == PlayerInfo[playerid][pMember]) SendClientMessageEx(p, COLOR_GREEN, szMiscArray);
	SetPVarInt(playerid, "CapCheck", 1);
	SendClientMessageEx(playerid, COLOR_GRAD1, "You will start capturing the turf in 1 minute if you do not die or leave it.");
	if(arrTurfWars[iTurfID][tw_iGroupID] == INVALID_GROUP_ID) GangZoneShowForAll(arrTurfWars[iTurfID][tw_iGZoneID], 0xFFFFFF22);
	GangZoneFlashForAll(arrTurfWars[iTurfID][tw_iGZoneID], arrGroupData[PlayerInfo[playerid][pMember]][g_hDutyColour] * 256 + 170);
	defer TurfWars_Capture(playerid, iTurfID);
	return 1;	
}


CMD:shutdown(playerid, params[]) {

	if(!IsACop(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not an LEO.");
	if(PlayerInfo[playerid][pRank] < arrGroupData[PlayerInfo[playerid][pMember]][g_iTurfCapRank]) {
		return SendClientMessageEx(playerid, COLOR_GRAD2, "Your rank is not high enough to shutdown turfs!");
    }
    // for(new i; i < MAX_TURFS; ++i) if(GetGVarType("TW_Capturer", i) == PlayerInfo[playerid][pMember]) return SendClientMessageEx(playerid, COLOR_GRAD1, "Your group is already shutting down a turf.");
	new iTurfID = TurfWars_GetTurfID(playerid);
	if(Bit_State(arrTurfWarsBits[iTurfID], tw_bDisabled)) return SendClientMessage(playerid, COLOR_GRAD1, "This turf is currently disabled.");
	// if(!Bit_State(arrTurfWarsBits[iTurfID], tw_bVulnerable)) return SendClientMessage(playerid, COLOR_GRAD1, "This turf is not vulnerable.");
	if(arrTurfWars[iTurfID][tw_bVulnerable] == false || !GetGVarType("TW_Capturer", iTurfID)) {
		format(szMiscArray, sizeof(szMiscArray), "This turf (ID %d) is not in a turf war.", iTurfID);
		return SendClientMessage(playerid, COLOR_GRAD1, szMiscArray);
	}

	if(TurfWars_GetTurfCount(iTurfID, PlayerInfo[playerid][pMember]) < 3 && !IsAdminLevel(playerid, ADMIN_SENIOR, 0)) {
		return SendClientMessageEx(playerid, COLOR_GRAD1, "You need at least 3 of your members on the turf to be able to shut it down.");
	}
	if(GetGVarType("TW_Capturer", iTurfID)) {

		// if(GetGVarInt("TW_Capturer", iTurfID) == PlayerInfo[playerid][pMember]) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are already capturing this turf.");
		new iGroupID = GetGVarInt("TW_Capturer", iTurfID);
		if(arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_LEA) return SendClientMessageEx(playerid, COLOR_GRAD1, "Another Law Enforcement Agency is shutting down this turf.");
		format(szMiscArray, sizeof(szMiscArray), "[TURF] You are attempting to shutdown a turf %s is capturing.", arrGroupData[iGroupID][g_szGroupName]);
		foreach(new p : Player) {
			if(PlayerInfo[p][pMember] == PlayerInfo[playerid][pMember]) SendClientMessageEx(p, COLOR_GRAD1, szMiscArray);
		}
		format(szMiscArray, sizeof(szMiscArray), "[TURF]: %s is attempting to shutdown the turf.", arrGroupData[PlayerInfo[playerid][pMember]][g_szGroupName]);
		foreach(new p : Player) {
			if(PlayerInfo[p][pMember] == iGroupID) SendClientMessageEx(p, COLOR_GREEN, szMiscArray);
		}
	}
	SendClientMessageEx(playerid, COLOR_GRAD1, "You will start shutting down the turf in 1 minute if you do not die or leave it.");
	GangZoneFlashForAll(arrTurfWars[iTurfID][tw_iGZoneID],  arrGroupData[PlayerInfo[playerid][pMember]][g_hDutyColour] * 256 + 170);
	defer TurfWars_Capture(playerid, iTurfID);
	return 1;	
}

CMD:myturfs(playerid, params[]) {

	if(PlayerInfo[playerid][pLeader] == INVALID_GROUP_ID) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot capture turfs.");

	new iGroupID = PlayerInfo[playerid][pMember],
		iLastID,
		iTurfCount,
		iMyTurfs;

	szMiscArray[0] = 0;
	szMiscArray = "Turf\tHealth - Level\tTraffic - Deaths";
	for(new i; i < sizeof(gSAZones); ++i) {

		iTurfCount++;
		if(arrTurfWars[i][tw_iGroupID] == iGroupID) {

			iMyTurfs++;
			if(iLastID != arrTurfWars[i][tw_iLinkedID] || arrTurfWars[i][tw_iLinkedID] == 0) {

				if(arrTurfWars[i][tw_iLinkedID] != 0) iLastID = arrTurfWars[i][tw_iLinkedID];
				format(szMiscArray, sizeof(szMiscArray), "%s\n%s (ID %d)\t%dHP - LVL %d\t %dT - %dD",
					szMiscArray, gSAZones[i][SAZONE_NAME], iMyTurfs, arrTurfWars[i][tw_iHealth], arrTurfWars[i][tw_iLevel], arrTurfWars[i][tw_iTraffic], arrTurfWars[i][tw_iDeaths]);
				iMyTurfs = 0;
				iTurfCount = 0;
			}
		}
	}
	ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_TABLIST_HEADERS, "Turf List | Your Turfs", szMiscArray, "<<", "");
	return 1;
}

CMD:turfinfo(playerid, params[]) {

	if(GetPVarType(playerid, "TInfo")) {
		TurfWars_GUI(playerid, false);
		DeletePVar(playerid, "TInfo");
	}
	else {
		SetPVarInt(playerid, "TInfo", 1);
		TurfWars_GUI(playerid, true);
	}
	return 1;
}

CMD:turfs(playerid, params[])
{
	if(Bit_State(arrPlayerBits[playerid], pTurfRadar)) {
		SendClientMessageEx(playerid, COLOR_WHITE, "You have disabled the Turf Minimap Radar.");
		TurfWars_Toggle(playerid, false);
	}
	else {
		SendClientMessageEx(playerid, COLOR_WHITE, "You have enabled the Turf Minimap Radar.");
		TurfWars_Toggle(playerid, true);
	}
	return 1;
}

CMD:turfstats(playerid, params[]) {

	new iTurfID = TurfWars_GetTurfID(playerid);
	/*
	if(sscanf(params, "d", iTurfID)) {
   		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /turfinfo [ID]");
   		SendClientMessageEx(playerid, COLOR_GREY, "Help: /myturfs to list your turfs.");
   		return 1;
	}
	*/
	if(iTurfID == 369) return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not in a valid turf, or you're not synced (move to another turf and back).");
	if(arrTurfWars[iTurfID][tw_iGroupID] != PlayerInfo[playerid][pMember] &&
		!IsAdminLevel(playerid, ADMIN_SENIOR, 0)) return SendClientMessageEx(playerid, COLOR_GRAD1, "This turf doesn't belong to you.");
	
	format(szMiscArray, sizeof(szMiscArray), "%s {CCCCCC}- {FFFF00}Revenue: {CCCCCC}$%s - {FFFF00}Deaths: {CCCCCC}%d - {FFFF00}Traffic: {CCCCCC}%d",
		gSAZones[iTurfID][SAZONE_NAME],
		number_format(arrTurfWars[iTurfID][tw_iRevenue]),
		arrTurfWars[iTurfID][tw_iDeaths],
		arrTurfWars[iTurfID][tw_iTraffic]);
	SendClientMessage(playerid, COLOR_GREEN, szMiscArray);
	return 1;
}

CMD:turftime(playerid, params[]) {

	szMiscArray[0] = 0;
	// szMiscArray = "Name\tTime\n";

	new iSeconds,
		iMinutes;

	for(new i; i < MAX_TURFS; ++i) {

		if(GetGVarType("TW_Time", i)) {
			iSeconds = GetGVarInt("TW_Time", i);
			iMinutes = floatround(iSeconds / 60, floatround_floor);
			iSeconds = iSeconds - (iMinutes * 60);
			format(szMiscArray, sizeof(szMiscArray), "%s - {CCCCCC}%s - {FFFF00}%d:%02d {CCCCCC}minutes.", gSAZones[i][SAZONE_NAME], arrGroupData[GetGVarInt("TW_Capturer", i)][g_szGroupName], iMinutes, iSeconds);
			SendClientMessage(playerid, COLOR_GREEN, szMiscArray);
		}
	}
	// ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_TABLIST_HEADERS, "Point Time", szMiscArray, "<<", "");
	return 1;
}


TurfWars_SendGroupMessage(iGroupID, COLOR, szMessage[]) {

	if(iGroupID != INVALID_GROUP_ID) {

		foreach(new i : Player) {
			if(PlayerInfo[i][pMember] == iGroupID) {
				SendClientMessageEx(i, COLOR, szMessage);
			}
		}
	}
	return 1;
}

timer TurfWars_Capture[60000](playerid, iTurfID) {

	DeletePVar(playerid, "CapCheck");
	if(GetGVarType("TW_Capturer", iTurfID) && GetGVarInt("TW_Capturer", iTurfID) == PlayerInfo[playerid][pMember]) {
		return SendClientMessageEx(playerid, COLOR_GRAD1, "Someone else in your gang already claimed the turf.");
	}
	if(TurfWars_GetTurfID(playerid) != iTurfID || GetPVarType(playerid, "Injured")) {
		
		GangZoneFlashForAll(arrTurfWars[iTurfID][tw_iGZoneID],  arrGroupData[arrTurfWars[iTurfID][tw_iGroupID]][g_hDutyColour] * 256 + 170);
		return TurfWars_SendGroupMessage(PlayerInfo[playerid][pMember], COLOR_GREEN, "[TURF]: Your group failed to get a first hold of the turf.");
	}
	if(GetGVarType("TW_Capturer", iTurfID)) {

		format(szMiscArray, sizeof(szMiscArray), "[TURF]: %s has successfully taken a first hold of the turf you were capturing.", arrGroupData[PlayerInfo[playerid][pMember]][g_szGroupName]);
		TurfWars_SendGroupMessage(GetGVarInt("TW_Capturer", iTurfID), COLOR_GREEN, szMiscArray);
		if(arrTurfWars[iTurfID][tw_iHealth] < 20) arrTurfWars[iTurfID][tw_iHealth] = 20;
	}
	SetGVarInt("TW_Capturer", PlayerInfo[playerid][pMember], iTurfID);
	TurfWars_SendGroupMessage(PlayerInfo[playerid][pMember], COLOR_GREEN, "[TURF]: Your group managed to get a first hold of the turf.");
	SetPVarInt(playerid, "TW_CapLeader", 1);
	TurfWars_SyncGUI(INVALID_PLAYER_ID, iTurfID);
	TurfWars_MicroTimer(PlayerInfo[playerid][pMember], iTurfID);
	return 1;
}

timer TurfWars_MicroTimer[1000](iGroupID, iTurfID) {


	if(!GetGVarType("TW_Capturer", iTurfID) || GetGVarInt("TW_Capturer", iTurfID) != iGroupID)  {
		foreach(new p : Player) if(PlayerInfo[p][pMember] == iGroupID) TextDrawHideForPlayer(p, PointTime);
		return 1;
	}

	TurfWars_SetTime(iTurfID);
	new iSeconds = GetGVarInt("TW_Time", iTurfID),
		iMinutes = floatround(iSeconds / 60, floatround_floor);
	iSeconds = iSeconds - (iMinutes * 60);
	
	if(iMinutes < 1 && iSeconds < 1 && GetGVarType("TW_Critical", iTurfID)) {

		foreach(new p : Player) if (PlayerInfo[p][pMember] == iGroupID) TextDrawHideForPlayer(p, PointTime);
		TurfWars_FinalizeCapture(iTurfID, true);
		return 1;
	}
	format(szMiscArray, sizeof(szMiscArray), "%d:%02d", iMinutes, iSeconds);
	TextDrawSetString(PointTime, szMiscArray);
	foreach(new p : Player) {
		if(PlayerInfo[p][pMember] == iGroupID) {
			TextDrawShowForPlayer(p, PointTime);
		}
		else TextDrawHideForPlayer(p, PointTime);
	}
	defer TurfWars_MicroTimer(iGroupID, iTurfID);
	return 1;
}

TurfWars_SetTime(iTurfID) {

	new iSeconds = GetGVarInt("TW_Time", iTurfID);
	iSeconds--;
	if(GetGVarType("TW_Critical", iTurfID)) {

		SetGVarInt("TW_Time", iSeconds, iTurfID);
		if(iSeconds <= 0) TurfWars_FinalizeCapture(iTurfID, true);
		return 1;
	}
	if(arrTurfWars[iTurfID][tw_iGroupID] == GetGVarInt("TW_Capturer", iTurfID)) {
		SetGVarInt("TW_Time", 600, iTurfID);
		SetGVarInt("TW_Critical", 1, iTurfID);
		TurfWars_SendGroupMessage(GetGVarInt("TW_Capturer", iTurfID), COLOR_YELLOW, "[TURF]: You are securing your turf. In 10 minutes it will be secure.");
		return 1;
	}

	if(iSeconds % 20 == 0) {
		TurfWars_SetHealth(iTurfID, arrTurfWars[iTurfID][tw_iHealth] - 5);
		// iSeconds = arrTurfWars[iTurfID][tw_iHealth] * arrTurfWars[iTurfID][tw_iLevel] + 300;
	}

	if(iSeconds % 20 == 0 || iSeconds <= 0) iSeconds = 20 * floatround(arrTurfWars[iTurfID][tw_iHealth] / 5);
	if(arrTurfWars[iTurfID][tw_iHealth] <= 0) {
		arrTurfWars[iTurfID][tw_iHealth] = 0;
		TurfWars_SendGroupMessage(arrTurfWars[iTurfID][tw_iGroupID], COLOR_YELLOW, "[TURF]: Your turf's assets are destroyed. You have 5 minutes left to rescue it.");
		TurfWars_SendGroupMessage(GetGVarInt("TW_Capturer", iTurfID), COLOR_YELLOW, "[TURF]: You have destroyed the turf's assets. In 5 minutes it will be yours.");
		SetGVarInt("TW_Critical", 1, iTurfID);
		SetGVarInt("TW_Time", 300, iTurfID);
	}
	else SetGVarInt("TW_Time", iSeconds, iTurfID);
	return 1;
}

TurfWars_FinalizeCapture(iTurfID, bool:bState) {

	new iGroupID = GetGVarInt("TW_Capturer", iTurfID);
	GangZoneHideForAll(arrTurfWars[iTurfID][tw_iGZoneID]);
	switch(bState) {

		case true: {
			if(arrTurfWars[iTurfID][tw_iGroupID] == INVALID_GROUP_ID) TurfWars_SendGroupMessage(iGroupID, COLOR_YELLOW, "[TURF]: You have successfully taken over the turf.");
			else {
				if(arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_LEA) {

					format(szMiscArray, sizeof(szMiscArray), "[TURF]: You have successfully shutdown %s's turf. It will remain shutdown for 24 hours.", arrGroupData[arrTurfWars[iTurfID][tw_iGroupID]][g_szGroupName]);
					TurfWars_SendGroupMessage(GetGVarInt("TW_Capturer", iTurfID), COLOR_YELLOW, szMiscArray);
					format(szMiscArray, sizeof(szMiscArray), "[TURF]: %s has successfully shutdown your turf. It will remain shutdown for 24 hours.", arrGroupData[iGroupID][g_szGroupName]);	
					TurfWars_SendGroupMessage(arrTurfWars[iTurfID][tw_iGroupID], COLOR_YELLOW, szMiscArray);
					Bit_On(arrTurfWarsBits[iTurfID], tw_bShutdown);

					format(szMiscArray, sizeof(szMiscArray), "UPDATE `turfs` SET `vulnerable` = '0', `shutdown` = '1', `timestamp` = '%d' WHERE `id` = '%d'",
						gettime() + 21600, iTurfID);
					mysql_tquery(MainPipeline, szMiscArray, false, "OnQueryFinish", "i", SENDDATA_THREAD);
				}
				else {
					format(szMiscArray, sizeof(szMiscArray), "[TURF]: You have successfully taken over %s's turf.", arrGroupData[arrTurfWars[iTurfID][tw_iGroupID]][g_szGroupName]);
					TurfWars_SendGroupMessage(GetGVarInt("TW_Capturer", iTurfID), COLOR_YELLOW, szMiscArray);
					format(szMiscArray, sizeof(szMiscArray), "[TURF]: %s has successfully taken over your turf.", arrGroupData[iGroupID][g_szGroupName]);	
					TurfWars_SendGroupMessage(arrTurfWars[iTurfID][tw_iGroupID], COLOR_YELLOW, szMiscArray);
					
				}
			}
			if(arrGroupData[iGroupID][g_iGroupType] != GROUP_TYPE_LEA) {

				arrTurfWars[iTurfID][tw_iGroupID] = iGroupID;
				format(szMiscArray, sizeof(szMiscArray), "UPDATE `turfs` SET `groupid` = '%d', `vulnerable` = '0', `timestamp` = '%d' WHERE `id` = '%d'",
					iGroupID, gettime() + 21600, iTurfID);
				mysql_tquery(MainPipeline, szMiscArray, false, "OnQueryFinish", "i", SENDDATA_THREAD);
			}
			if(arrTurfWars[iTurfID][tw_iLevel] > 20) arrTurfWars[iTurfID][tw_iLevel] -= 10;
		}
		default: {

			format(szMiscArray, sizeof(szMiscArray), "UPDATE `turfs` SET `vulnerable` = '0', `timestamp` = '%d' WHERE `id` = '%d'",
				gettime() + 21600, iTurfID);
			mysql_tquery(MainPipeline, szMiscArray, false, "OnQueryFinish", "i", SENDDATA_THREAD);
			if(arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_LEA) {
				format(szMiscArray, sizeof(szMiscArray), "[TURF]: You have failed to shutdown %s's turf.", arrGroupData[arrTurfWars[iTurfID][tw_iGroupID]][g_szGroupName]);
				TurfWars_SendGroupMessage(GetGVarInt("TW_Capturer", iTurfID), COLOR_YELLOW, szMiscArray);
				format(szMiscArray, sizeof(szMiscArray), "[TURF]: %s has failed to shutdown your turf.", arrGroupData[GetGVarInt("TW_Capturer", iTurfID)][g_szGroupName]);	
				TurfWars_SendGroupMessage(arrTurfWars[iTurfID][tw_iGroupID], COLOR_YELLOW, szMiscArray);
			}
			else {
				format(szMiscArray, sizeof(szMiscArray), "[TURF]: You have failed to take over %s's turf.", arrGroupData[arrTurfWars[iTurfID][tw_iGroupID]][g_szGroupName]);
				TurfWars_SendGroupMessage(GetGVarInt("TW_Capturer", iTurfID), COLOR_YELLOW, szMiscArray);
				format(szMiscArray, sizeof(szMiscArray), "[TURF]: %s has failed to take over your turf.", arrGroupData[GetGVarInt("TW_Capturer", iTurfID)][g_szGroupName]);	
				TurfWars_SendGroupMessage(arrTurfWars[iTurfID][tw_iGroupID], COLOR_YELLOW, szMiscArray);
			}
			if(arrTurfWars[iTurfID][tw_iLevel] < 95) arrTurfWars[iTurfID][tw_iLevel] += 5;
		}
	}
	foreach(new p : Player) if(PlayerInfo[p][pMember] == GetGVarInt("TW_Capturer", iTurfID)) DeletePVar(p, "TW_CapLeader");
	arrTurfWars[iTurfID][tw_iHealth] = 50;
	// Bit_Off(arrTurfWarsBits[iTurfID], tw_bVulnerable);
	arrTurfWars[iTurfID][tw_bVulnerable] = false;
	TurfWars_SyncGUI(INVALID_PLAYER_ID, iTurfID);
	ResyncTurf(iTurfID);
	TurfWars_ResetVars(iTurfID);
}

TurfWars_ResetVars(iTurfID) {

	DeleteGVar("TW_Capturer", iTurfID);
	DeleteGVar("TW_Time", iTurfID);
	DeleteGVar("TW_Critical", iTurfID);
}

/*
To setup the SQL table.
CMD:turfcodes(playerid, params[]) {

	new i[9];
	i[0] = CreateDynamicRectangle(gMainZones[0][SAZONE_AREA][0],gMainZones[0][SAZONE_AREA][1], gMainZones[0][SAZONE_AREA][3], gMainZones[0][SAZONE_AREA][4]);
	i[1] = CreateDynamicRectangle(gMainZones[1][SAZONE_AREA][0],gMainZones[1][SAZONE_AREA][1], gMainZones[1][SAZONE_AREA][3], gMainZones[1][SAZONE_AREA][4]);
	i[2] = CreateDynamicRectangle(gMainZones[2][SAZONE_AREA][0],gMainZones[2][SAZONE_AREA][1], gMainZones[2][SAZONE_AREA][3], gMainZones[2][SAZONE_AREA][4]);
	i[3] = CreateDynamicRectangle(gMainZones[3][SAZONE_AREA][0],gMainZones[3][SAZONE_AREA][1], gMainZones[3][SAZONE_AREA][3], gMainZones[3][SAZONE_AREA][4]);
	i[4] = CreateDynamicRectangle(gMainZones[4][SAZONE_AREA][0],gMainZones[4][SAZONE_AREA][1], gMainZones[4][SAZONE_AREA][3], gMainZones[4][SAZONE_AREA][4]);
	i[5] = CreateDynamicRectangle(gMainZones[5][SAZONE_AREA][0],gMainZones[5][SAZONE_AREA][1], gMainZones[5][SAZONE_AREA][3], gMainZones[5][SAZONE_AREA][4]);
	i[6] = CreateDynamicRectangle(gMainZones[6][SAZONE_AREA][0],gMainZones[6][SAZONE_AREA][1], gMainZones[6][SAZONE_AREA][3], gMainZones[6][SAZONE_AREA][4]);
	i[7] = CreateDynamicRectangle(gMainZones[7][SAZONE_AREA][0],gMainZones[7][SAZONE_AREA][1], gMainZones[7][SAZONE_AREA][3], gMainZones[7][SAZONE_AREA][4]);
	i[8] = CreateDynamicRectangle(gMainZones[8][SAZONE_AREA][0],gMainZones[8][SAZONE_AREA][1], gMainZones[8][SAZONE_AREA][3], gMainZones[8][SAZONE_AREA][4]);

	for(new a; a < sizeof(gSAZones); ++a) {

		for(new b; b < 9; ++b) {
			if(IsPointInDynamicArea(i[b], gSAZones[a][SAZONE_AREA][0] + 1.0, gSAZones[a][SAZONE_AREA][1] + 1.0, gSAZones[a][SAZONE_AREA][2])) {
				format(szMiscArray, sizeof(szMiscArray), "UPDATE `turfs` SET `areacode` = '%d' WHERE `linkedid` = '%d'",
					b, arrTurfWars[a][tw_iLinkedID]);
				mysql_tquery(MainPipeline, szMiscArray, false, "OnQueryFinish", "i", SENDDATA_THREAD);
			}
		}
	}
	return 1;
}
*/

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	switch(dialogid) {

		case DIALOG_TURFS_AREA: {
			format(szMiscArray, sizeof(szMiscArray), "SELECT `id`, `linkedid`, `groupid`, `timestamp`, `vulnerable`, `shutdown`, `zonename` FROM `turfs` WHERE `areacode` = '%d'", listitem);
			mysql_tquery(MainPipeline, szMiscArray, true, "TurfWars_FetchData", "ii", playerid, listitem);
		}
		case DIALOG_TURFS_UPGRADE: {

			if(!response) SendClientMessageEx(playerid, COLOR_GRAD1, "You decided not to upgrade/heal your turf.");
			else {
				new iUpgrID = GetPVarInt(playerid, "TurfUpgr");
				DeletePVar(playerid, "TurfUpgr");
				if(iUpgrID == 0) {
					new iTurfID = GetPVarInt(playerid, "TurfID"),
						iHealth = Turf_GetMaxHealth(iTurfID);

					arrGroupData[PlayerInfo[playerid][pMember]][g_iMaterials] -= (arrTurfWars[iTurfID][tw_iLevel] * 5000) + 5000;
					arrTurfWars[iTurfID][tw_iLevel]++;
					arrTurfWars[iTurfID][tw_iHealth] += 50;
					if(arrTurfWars[iTurfID][tw_iHealth] > iHealth) arrTurfWars[iTurfID][tw_iHealth] = iHealth;
					format(szMiscArray, sizeof(szMiscArray), "[TURF]: {CCCCCC}Congratulations! You upgraded your turf to {FFFF00}level %d.", arrTurfWars[iTurfID][tw_iLevel]);
					TurfWars_SendGroupMessage(PlayerInfo[playerid][pMember], COLOR_YELLOW, szMiscArray);
					format(szMiscArray, sizeof(szMiscArray), "[TURF]: Your turf's max health is now %d", iHealth);
					TurfWars_SendGroupMessage(PlayerInfo[playerid][pMember], COLOR_GREEN, szMiscArray);
					SaveGroup(PlayerInfo[playerid][pMember]);
					format(szMiscArray, sizeof(szMiscArray), "UPDATE `turfs` SET `health` = '%d', `level` = '%d' WHERE `id` = '%d'", arrTurfWars[iTurfID][tw_iHealth], arrTurfWars[iTurfID][tw_iLevel], iTurfID);
					mysql_tquery(MainPipeline, szMiscArray, false, "OnQueryFinish", "i", SENDDATA_THREAD);
					Turf_SyncTurf(iTurfID);
				}
				else if(iUpgrID == 1) {
					new iTurfID = GetPVarInt(playerid, "TurfID"),
						iHealth = Turf_GetMaxHealth(iTurfID);

					arrGroupData[PlayerInfo[playerid][pMember]][g_iMaterials] -= (arrTurfWars[iTurfID][tw_iLevel] * 100) + 600;
					arrTurfWars[iTurfID][tw_iHealth] += 40;
					if(arrTurfWars[iTurfID][tw_iHealth] > iHealth) arrTurfWars[iTurfID][tw_iHealth] = iHealth;
					format(szMiscArray, sizeof(szMiscArray), "[TURF]: {CCCCCC}You healed your turf with {FFFF00}40 {CCCCCC}health for {FFFF00}%d {CCCCCC}materials.", (arrTurfWars[iTurfID][tw_iLevel] * 100) + 600);
					TurfWars_SendGroupMessage(PlayerInfo[playerid][pMember], COLOR_YELLOW, szMiscArray);
					SaveGroup(PlayerInfo[playerid][pMember]);
					format(szMiscArray, sizeof(szMiscArray), "UPDATE `turfs` SET `health` = '%d' WHERE `id` = '%d'", arrTurfWars[iTurfID][tw_iHealth], iTurfID);
					mysql_tquery(MainPipeline, szMiscArray, false, "OnQueryFinish", "i", SENDDATA_THREAD);
					Turf_SyncTurf(iTurfID);
				}
			}
			DeletePVar(playerid, "TurfID");
		}
	}
	return 0;
}

Turf_SyncTurf(iTurfID) {

	foreach(new p : Player) if(TurfWars_GetTurfID(p) == iTurfID) TurfWars_SyncGUI(p, iTurfID);
}

Turf_GetMaxHealth(iTurfID) {

	return (100 + (arrTurfWars[iTurfID][tw_iLevel] * 9));
}

forward TurfWars_FetchData(playerid, area);
public TurfWars_FetchData(playerid, area) {

	new iRows,
		iFields,
		iCount,
		iLastID,
		iTurfID,
		iLinkedID,
		szZoneName[MAX_ZONE_NAME],
		iGroupID,
		szGroup[GROUP_MAX_NAME_LEN],
		iTimeStamp,
		szTitle[24];

	cache_get_data(iRows, iFields, MainPipeline);
	if(!iRows) return SendClientMessageEx(playerid, COLOR_GRAD1, "There are no turfs.");

	szMiscArray[0] = 0;
	szMiscArray = "Turf\tOwned by\tTime left (minutes)";
	while(iCount < iRows) {

		iLinkedID = cache_get_field_content_int(iCount, "linkedid", MainPipeline);
		if(iLastID != iLinkedID || iLinkedID == 0) {

			if(iLinkedID != 0) iLastID = iLinkedID;
			cache_get_field_content(iCount, "zonename", szZoneName, MainPipeline);
			iGroupID = cache_get_field_content_int(iCount, "groupid", MainPipeline);
			iTurfID = cache_get_field_content_int(iCount, "id", MainPipeline);
			szGroup[0] = 0;
			switch(iGroupID) {

				case INVALID_GROUP_ID: szGroup = "Neutral";
				default: strcat(szGroup, arrGroupData[iGroupID][g_szGroupName], sizeof(szGroup));
			}
			iTimeStamp = (gettime() - cache_get_field_content_int(iCount, "timestamp", MainPipeline)) / 3600; // Calculate difference, then convert to hours.);
			if(cache_get_field_content_int(iCount, "vulnerable", MainPipeline) == 1) {

				format(szMiscArray, sizeof(szMiscArray), "%s\n{FFFF00}%s (%d)\t%s (%d)\t%d minutes{FFFFFF}",
					szMiscArray,
					szZoneName,
					iTurfID,
					szGroup,
					iGroupID,
					0);
			}
			else {
				format(szMiscArray, sizeof(szMiscArray), "%s\n%s (%d)\t%s (%d)\t%d hours",
					szMiscArray,
					szZoneName,
					iTurfID,
					szGroup,
					iGroupID,
					iTimeStamp);
			}		
		}
		iCount++;
	}
	format(szTitle, sizeof(szTitle), "%s | Turfs", gMainZones[area][SAZONE_NAME]);
	return ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_TABLIST_HEADERS, szTitle, szMiscArray, "<<", "");
}

CMD:editturf(playerid, params[]) {

	if(!IsAdminLevel(playerid, ADMIN_SENIOR) || PlayerInfo[playerid][pGangModerator] != 2) return 1;

	new szChoice[12],
		iTurfID,
		iValue,
		iChoiceID;

	if(sscanf(params, "s[12]dd", szChoice, iTurfID, iValue)) {
   		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /editturf [option] [ID] [value]");
   		SendClientMessageEx(playerid, COLOR_GREY, "Available options: Group (0 for neutral), Vulnerable, Disabled, Level, Health, Headquarter, Shutdown");
   		SendClientMessageEx(playerid, COLOR_GREY, "Help: /turflist to list all turfs.");
   		return 1;
	}
	if(strcmp(szChoice, "Group", true) == 0) iChoiceID = 0;
	else if(strcmp(szChoice, "Vulnerable", true) == 0) iChoiceID = 1;
	else if(strcmp(szChoice, "Disabled", true) == 0) iChoiceID = 2;
	else if(strcmp(szChoice, "Level", true) == 0) iChoiceID = 3;
	else if(strcmp(szChoice, "Health", true) == 0) iChoiceID = 4;
	else if(strcmp(szChoice, "Headquarter", true) == 0) iChoiceID = 5;
	else if(strcmp(szChoice, "Shutdown", true) == 0) iChoiceID = 6;
	else return SendClientMessage(playerid, COLOR_GRAD1, "You specified an invalid option.");
	TurfWars_SetValue(playerid, iTurfID, iChoiceID, iValue);
	TurfWars_SyncGUI(INVALID_PLAYER_ID, iTurfID);
	return 1;
}

CMD:upgradeturf(playerid, params[]) {

	if(PlayerInfo[playerid][pLeader] == INVALID_GROUP_ID) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not in a faction/gang leader.");
	new iTurfID = TurfWars_GetTurfID(playerid);
	if(arrTurfWars[iTurfID][tw_iGroupID] != PlayerInfo[playerid][pLeader]) return SendClientMessageEx(playerid, COLOR_GRAD1, "This turf does not belong to you.");
	if(GetGVarInt("TW_Capturer", iTurfID)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot level up the turf while it is being captured.");
	if(arrGroupData[PlayerInfo[playerid][pLeader]][g_iMaterials] < ((arrTurfWars[iTurfID][tw_iLevel] * 5000) + 5000)) {
		format(szMiscArray, sizeof(szMiscArray), "[TURF]: {CCCCCC}You need an additional {FFFF00}%d {CCCCCC}materials to upgrade the turf",
			((arrTurfWars[iTurfID][tw_iLevel] * 5000) + 5000) - arrGroupData[PlayerInfo[playerid][pLeader]][g_iMaterials]);
		TurfWars_SendGroupMessage(PlayerInfo[playerid][pLeader], COLOR_GREEN, szMiscArray);
	}
	else {
		SetPVarInt(playerid, "TurfID", iTurfID);
		SetPVarInt(playerid, "TurfUpgr", 0);
		format(szMiscArray, sizeof(szMiscArray), "Total cost: %d materials\n\nWould you like to upgrade your turf?",
			(arrTurfWars[iTurfID][tw_iLevel] * 5000) + 5000);
		ShowPlayerDialogEx(playerid, DIALOG_TURFS_UPGRADE, DIALOG_STYLE_MSGBOX, "Turf | Upgrade", szMiscArray, "Yes", "No");
	}
	return 1;
}

CMD:healturf(playerid, params[]) {

	if(PlayerInfo[playerid][pLeader] == INVALID_GROUP_ID) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not in a faction/gang leader.");
	new iTurfID = TurfWars_GetTurfID(playerid);
	if(arrTurfWars[iTurfID][tw_iGroupID] != PlayerInfo[playerid][pLeader]) return SendClientMessageEx(playerid, COLOR_GRAD1, "This turf does not belong to you.");
	if(GetGVarInt("TW_Capturer", iTurfID)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot heal the turf while it is being captured.");
	if(arrGroupData[PlayerInfo[playerid][pLeader]][g_iMaterials] < ((arrTurfWars[iTurfID][tw_iLevel] * 100) + 600)) {
		format(szMiscArray, sizeof(szMiscArray), "[TURF]: {CCCCCC}You need an additional {FFFF00}%d {CCCCCC}materials to heal the turf",
			((arrTurfWars[iTurfID][tw_iLevel] * 100) + 600) - arrGroupData[PlayerInfo[playerid][pLeader]][g_iMaterials]);
		TurfWars_SendGroupMessage(PlayerInfo[playerid][pLeader], COLOR_GREEN, szMiscArray);
	}
	else {
		SetPVarInt(playerid, "TurfID", iTurfID);
		SetPVarInt(playerid, "TurfUpgr", 1);
		format(szMiscArray, sizeof(szMiscArray), "Total cost: %d materials\n\nWould you like to heal your turf?",
			(arrTurfWars[iTurfID][tw_iLevel] * 100) + 600);
		ShowPlayerDialogEx(playerid, DIALOG_TURFS_UPGRADE, DIALOG_STYLE_MSGBOX, "Turf | Upgrade", szMiscArray, "Yes", "No");
	}
	return 1;
}

/*
TurfWars_GetLinkedID(i) {

	return arrTurfWars[i][tw_iLinkedID];
}
*/

TurfWars_SetValue(playerid, i, iChoice, iValue) {

	new szSQL[12];
	switch(iChoice) {

		case 0: { // group
			
			if(!(0 <= iValue < MAX_GROUPS)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You specified an invalid group ID.");
			szSQL = "groupid";
			iValue--; // Grouplist starts at 1 IG.
			if(Bit_State(arrTurfWarsBits[i], tw_bTurfMode)) {
				for(new j; j < MAX_TURFS; ++j) {
					if(arrTurfWars[i][tw_iLinkedID] == arrTurfWars[j][tw_iLinkedID]) arrTurfWars[j][tw_iGroupID] = iValue; // Groups start at 1 in /editgroup
				}
			}
			else arrTurfWars[i][tw_iGroupID] = iValue;
			ResyncTurf(i);
		}
		case 1: { // vulnverable
			if(!(0 <= iValue < 2)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You specified an invalid value.");
			szSQL = "vulnerable";
			if(Bit_State(arrTurfWarsBits[i], tw_bTurfMode)) {
				for(new j; j < MAX_TURFS; ++j) {
					if(arrTurfWars[i][tw_iLinkedID] == arrTurfWars[j][tw_iLinkedID]) {
						if(iValue == 0) arrTurfWars[j][tw_bVulnerable] = false; // Bit_Off(arrTurfWarsBits[j], tw_bVulnerable);
						else arrTurfWars[j][tw_bVulnerable] = true; // Bit_On(arrTurfWarsBits[j], tw_bVulnerable);
					}
				}				
			}
			else {
				if(iValue == 0) arrTurfWars[i][tw_bVulnerable] = false; // Bit_Off(arrTurfWarsBits[j], tw_bVulnerable);
				else arrTurfWars[i][tw_bVulnerable] = true; // Bit_On(arrTurfWarsBits[j], tw_bVulnerable);
			}
		}
		case 2: { // Disabled
			if(!(0 <= iValue < 2)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You specified an invalid value.");
			szSQL = "disabled";
			if(Bit_State(arrTurfWarsBits[i], tw_bTurfMode)) {
				for(new j; j < MAX_TURFS; ++j) {
					if(arrTurfWars[i][tw_iLinkedID] == arrTurfWars[j][tw_iLinkedID]) {
						if(iValue == 0) Bit_Off(arrTurfWarsBits[j], tw_bDisabled);
						else Bit_On(arrTurfWarsBits[j], tw_bDisabled);
					}
				}
			}
			else {
				if(iValue == 0) Bit_Off(arrTurfWarsBits[i], tw_bDisabled);
				else Bit_On(arrTurfWarsBits[i], tw_bDisabled);
			}
		}
		case 3: { // Level
			if(!(0 < iValue < 100)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You specified an invalid value.");
			szSQL = "level";
			if(Bit_State(arrTurfWarsBits[i], tw_bTurfMode)) {
				for(new j; j < MAX_TURFS; ++j) {
					if(arrTurfWars[i][tw_iLinkedID] == arrTurfWars[j][tw_iLinkedID]) {
						arrTurfWars[j][tw_iLevel] = iValue;
					}
				}
			}
			else arrTurfWars[i][tw_iLevel] = iValue;
		}
		case 4: { // Health
			if(!(0 <= iValue < 10000)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You specified an invalid value.");
			szSQL = "health";
			if(Bit_State(arrTurfWarsBits[i], tw_bTurfMode)) {
				for(new j; j < MAX_TURFS; ++j) {
					if(arrTurfWars[i][tw_iLinkedID] == arrTurfWars[j][tw_iLinkedID]) {
						arrTurfWars[j][tw_iHealth] = iValue;
					}
				}
			}
			else arrTurfWars[i][tw_iHealth] = iValue;
		}
		case 5: { // Headquarter
			if(!(0 <= iValue < 2)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You specified an invalid value.");
			szSQL = "headquarter";
			if(iValue == 0) Bit_Off(arrTurfWarsBits[i], tw_bHeadquarter);
			else Bit_On(arrTurfWarsBits[i], tw_bHeadquarter);
		}
		case 6: { // Shutdown
			if(!(0 <= iValue < 2)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You specified an invalid value.");
			szSQL = "shutdown";
			if(iValue == 0) Bit_Off(arrTurfWarsBits[i], tw_bShutdown);
			else Bit_On(arrTurfWarsBits[i], tw_bShutdown);
		}
	}
	if(Bit_State(arrTurfWarsBits[i], tw_bTurfMode)) {
		format(szMiscArray, sizeof(szMiscArray), "UPDATE `turfs` SET `%s` = '%d' WHERE `linkedid` = '%d'", szSQL, iValue, arrTurfWars[i][tw_iLinkedID]);
		mysql_tquery(MainPipeline, szMiscArray, false, "TurfWars_OnQueryFinish" , "ii", playerid, i);
	}
	else {
		format(szMiscArray, sizeof(szMiscArray), "UPDATE `turfs` SET `%s` = '%d' WHERE `id` = '%d'", szSQL, iValue, i + 1);
		mysql_tquery(MainPipeline, szMiscArray, false, "TurfWars_OnQueryFinish" , "ii", playerid, i);
	}
	return 1;
}

/*
TurfWars_EditTurf(playerid, i, szChoice[], iValue) {
	
	new szSQL[12];
	if(strcmp(szChoice, "Group", true) == 0) {

		iValue--; // Grouplist starts at 1 IG.
		if(!(0 <= iValue < MAX_GROUPS)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You specified an invalid group ID.");
		TurfWars_SetValue(i, 0, iValue);
		ResyncTurf(i);
		szSQL = "groupid";
	}
	if(strcmp(szChoice, "Vulnerable", true) == 0) {

		if(!(0 <= iValue < 2)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You specified an invalid value.");
		TurfWars_SetValue(i, 1, iValue);
		szSQL = "vulnerable";
	}
	if(strcmp(szChoice, "Disabled", true) == 0) {

		if(!(0 <= iValue < 2)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You specified an invalid value.");
		TurfWars_SetValue(i, 2, iValue);
		szSQL = "disabled";
	}
	format(szMiscArray, sizeof(szMiscArray), "UPDATE `turfs` SET `%s` = '%d' WHERE `linkedid` = '%d'", szSQL, iValue, arrTurfWars[i][tw_iLinkedID]);
	mysql_tquery(MainPipeline, szMiscArray, false, "TurfWars_OnQueryFinish" , "ii", playerid, i);
	return 1;
}
*/

forward TurfWars_OnQueryFinish(playerid, i);
public TurfWars_OnQueryFinish(playerid, i) {

	format(szMiscArray, sizeof(szMiscArray), "Successfully edited and saved Turf ID %d", i);
	SendClientMessageEx(playerid, COLOR_GRAD1, szMiscArray);
	return 1;
}

ResyncTurf(i) {

	foreach(new p : Player) {

		if(Bit_State(arrPlayerBits[p], pTurfRadar)) {

			for(new j; j < MAX_TURFS; ++j) {

				if(IsValidDynamicArea(arrTurfWars[j][tw_iAreaID])) {

					if(arrTurfWars[i][tw_iLinkedID] == arrTurfWars[j][tw_iLinkedID]) {

						GangZoneHideForPlayer(p, arrTurfWars[j][tw_iGZoneID]);
						if(arrTurfWars[j][tw_iGroupID] != -1) {

							GangZoneShowForPlayer(p, arrTurfWars[j][tw_iGZoneID], arrGroupData[arrTurfWars[j][tw_iGroupID]][g_hDutyColour] * 256 + 170);
						}
					}
				}
			}
		}
	}
}

TurfWars_Toggle(playerid, bool:bState) {

	// TurfWars_GUI(playerid, bState);
	if(bState) {

		Bit_On(arrPlayerBits[playerid], pTurfRadar);
		for(new i; i < MAX_TURFS; ++i) {

			if(IsValidDynamicArea(arrTurfWars[i][tw_iAreaID])) {

				if(Bit_State(arrTurfWarsBits[i], tw_bDisabled)) continue;
				if(arrTurfWars[i][tw_iGroupID] != -1) {
					GangZoneShowForPlayer(playerid, arrTurfWars[i][tw_iGZoneID], arrGroupData[arrTurfWars[i][tw_iGroupID]][g_hDutyColour] * 256 + 170);
				}
				else GangZoneShowForPlayer(playerid, arrTurfWars[i][tw_iGZoneID], 0xFFFFFF22);
			}
		}
	}
	else {

		Bit_Off(arrPlayerBits[playerid], pTurfRadar);
		for(new i; i < MAX_TURFS; ++i) {

			if(IsValidDynamicArea(arrTurfWars[i][tw_iAreaID])) {
				GangZoneHideForPlayer(playerid, arrTurfWars[i][tw_iGZoneID]);
			}
		}
	}
}

TurfWars_LoadPGUI(playerid) {

	TW_PTextDraws[playerid][0] = CreatePlayerTextDraw(playerid, 543.000000, 190.000000, ""); // Group Name
	PlayerTextDrawAlignment(playerid, TW_PTextDraws[playerid][0], 2);
	PlayerTextDrawBackgroundColor(playerid, TW_PTextDraws[playerid][0], 60);
	PlayerTextDrawFont(playerid, TW_PTextDraws[playerid][0], 1);
	PlayerTextDrawLetterSize(playerid, TW_PTextDraws[playerid][0], 0.180000, 0.899999);
	PlayerTextDrawColor(playerid, TW_PTextDraws[playerid][0], 16777215);
	PlayerTextDrawSetOutline(playerid, TW_PTextDraws[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, TW_PTextDraws[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, TW_PTextDraws[playerid][0], 0);

	TW_PTextDraws[playerid][1] = CreatePlayerTextDraw(playerid, 510.000000, 211.000000, ""); // Turf Health
	PlayerTextDrawBackgroundColor(playerid, TW_PTextDraws[playerid][1], 60);
	PlayerTextDrawFont(playerid, TW_PTextDraws[playerid][1], 1);
	PlayerTextDrawLetterSize(playerid, TW_PTextDraws[playerid][1], 0.180000, 0.899999);
	PlayerTextDrawColor(playerid, TW_PTextDraws[playerid][1], -56);
	PlayerTextDrawSetOutline(playerid, TW_PTextDraws[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, TW_PTextDraws[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, TW_PTextDraws[playerid][1], 0);

	TW_PTextDraws[playerid][2] = CreatePlayerTextDraw(playerid, 543.000000, 200.000000, ""); // Turf Name
	PlayerTextDrawAlignment(playerid, TW_PTextDraws[playerid][2], 2);
	PlayerTextDrawBackgroundColor(playerid, TW_PTextDraws[playerid][2], 60);
	PlayerTextDrawFont(playerid, TW_PTextDraws[playerid][2], 1);
	PlayerTextDrawLetterSize(playerid, TW_PTextDraws[playerid][2], 0.180000, 0.899999);
	PlayerTextDrawColor(playerid, TW_PTextDraws[playerid][2], -56);
	PlayerTextDrawSetOutline(playerid, TW_PTextDraws[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, TW_PTextDraws[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, TW_PTextDraws[playerid][2], 0);

	TW_PTextDraws[playerid][3] = CreatePlayerTextDraw(playerid, 530.000000, 210.000000, "hud:radar_enemyAttack");
	PlayerTextDrawBackgroundColor(playerid, TW_PTextDraws[playerid][3], 255);
	PlayerTextDrawFont(playerid, TW_PTextDraws[playerid][3], 4);
	PlayerTextDrawLetterSize(playerid, TW_PTextDraws[playerid][3], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid, TW_PTextDraws[playerid][3], -1);
	PlayerTextDrawSetOutline(playerid, TW_PTextDraws[playerid][3], 0);
	PlayerTextDrawSetProportional(playerid, TW_PTextDraws[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, TW_PTextDraws[playerid][3], 1);
	PlayerTextDrawUseBox(playerid, TW_PTextDraws[playerid][3], 1);
	PlayerTextDrawBoxColor(playerid, TW_PTextDraws[playerid][3], 255);
	PlayerTextDrawTextSize(playerid, TW_PTextDraws[playerid][3], 10.000000, 10.000000);
	PlayerTextDrawSetSelectable(playerid, TW_PTextDraws[playerid][3], 0);
	
	TW_PTextDraws[playerid][4] = CreatePlayerTextDraw(playerid, 571.000000, 211.000000, ""); // Turf Level
	PlayerTextDrawBackgroundColor(playerid, TW_PTextDraws[playerid][4], 60);
	PlayerTextDrawFont(playerid, TW_PTextDraws[playerid][4], 1);
	PlayerTextDrawLetterSize(playerid, TW_PTextDraws[playerid][4], 0.180000, 0.899999);
	PlayerTextDrawColor(playerid, TW_PTextDraws[playerid][4], -56);
	PlayerTextDrawSetOutline(playerid, TW_PTextDraws[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid, TW_PTextDraws[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, TW_PTextDraws[playerid][4], 0);

	TW_PTextDraws[playerid][5] = CreatePlayerTextDraw(playerid, 544.000000, 210.000000, "hud:radar_enemyAttack");
	PlayerTextDrawBackgroundColor(playerid, TW_PTextDraws[playerid][5], 255);
	PlayerTextDrawFont(playerid, TW_PTextDraws[playerid][5], 4);
	PlayerTextDrawLetterSize(playerid, TW_PTextDraws[playerid][5], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid, TW_PTextDraws[playerid][5], -1);
	PlayerTextDrawSetOutline(playerid, TW_PTextDraws[playerid][5], 0);
	PlayerTextDrawSetProportional(playerid, TW_PTextDraws[playerid][5], 1);
	PlayerTextDrawSetShadow(playerid, TW_PTextDraws[playerid][5], 1);
	PlayerTextDrawUseBox(playerid, TW_PTextDraws[playerid][5], 1);
	PlayerTextDrawBoxColor(playerid, TW_PTextDraws[playerid][5], 255);
	PlayerTextDrawTextSize(playerid, TW_PTextDraws[playerid][5], 10.000000, 10.000000);
	PlayerTextDrawSetSelectable(playerid, TW_PTextDraws[playerid][5], 0);
}

TurfWars_LoadGUI() {

	TW_TextDraws[0] = TextDrawCreate(544.000000, 180.000000, "-");
	TextDrawAlignment(TW_TextDraws[0], 2);
	TextDrawBackgroundColor(TW_TextDraws[0], 255);
	TextDrawFont(TW_TextDraws[0], 1);
	TextDrawLetterSize(TW_TextDraws[0], 0.500000, 4.499999);
	TextDrawColor(TW_TextDraws[0], 0);
	TextDrawSetOutline(TW_TextDraws[0], 0);
	TextDrawSetProportional(TW_TextDraws[0], 1);
	TextDrawSetShadow(TW_TextDraws[0], 0);
	TextDrawUseBox(TW_TextDraws[0], 1);
	TextDrawBoxColor(TW_TextDraws[0], 50);
	TextDrawTextSize(TW_TextDraws[0], 350.000000, 99.000000);
	TextDrawSetSelectable(TW_TextDraws[0], 0);

	TW_TextDraws[1]	 = TextDrawCreate(544.000000, 190.000000, "-");
	TextDrawAlignment(TW_TextDraws[1]	, 2);
	TextDrawBackgroundColor(TW_TextDraws[1]	, 255);
	TextDrawFont(TW_TextDraws[1]	, 1);
	TextDrawLetterSize(TW_TextDraws[1]	, 0.500000, 3.299999);
	TextDrawColor(TW_TextDraws[1]	, 0);
	TextDrawSetOutline(TW_TextDraws[1]	, 0);
	TextDrawSetProportional(TW_TextDraws[1]	, 1);
	TextDrawSetShadow(TW_TextDraws[1]	, 0);
	TextDrawUseBox(TW_TextDraws[1]	, 1);
	TextDrawBoxColor(TW_TextDraws[1]	, 50);
	TextDrawTextSize(TW_TextDraws[1]	, 350.000000, 99.000000);
	TextDrawSetSelectable(TW_TextDraws[1]	, 0);

	TW_TextDraws[2]	 = TextDrawCreate(515.000000, 179.000000, "TURF INFO");
	TextDrawBackgroundColor(TW_TextDraws[2]	, 60);
	TextDrawFont(TW_TextDraws[2]	, 2);
	TextDrawLetterSize(TW_TextDraws[2]	, 0.250000, 1.000000);
	TextDrawColor(TW_TextDraws[2]	, -926365496);
	TextDrawSetOutline(TW_TextDraws[2]	, 1);
	TextDrawSetProportional(TW_TextDraws[2]	, 1);
	TextDrawSetSelectable(TW_TextDraws[2]	, 0);

	TW_TextDraws[3] = TextDrawCreate(498.000000, 210.000000, "hud:radar_girlfriend");
	TextDrawBackgroundColor(TW_TextDraws[3], 255);
	TextDrawFont(TW_TextDraws[3], 4);
	TextDrawLetterSize(TW_TextDraws[3], 0.500000, 1.000000);
	TextDrawColor(TW_TextDraws[3], -1);
	TextDrawSetOutline(TW_TextDraws[3], 0);
	TextDrawSetProportional(TW_TextDraws[3], 1);
	TextDrawSetShadow(TW_TextDraws[3], 1);
	TextDrawUseBox(TW_TextDraws[3], 1);
	TextDrawBoxColor(TW_TextDraws[3], 255);
	TextDrawTextSize(TW_TextDraws[3], 10.000000, 10.000000);
	TextDrawSetSelectable(TW_TextDraws[3], 0);

	TW_TextDraws[4] = TextDrawCreate(559.000000, 210.000000, "LD_DRV:goboat");
	TextDrawBackgroundColor(TW_TextDraws[4], 255);
	TextDrawFont(TW_TextDraws[4], 4);
	TextDrawLetterSize(TW_TextDraws[4], 0.500000, 1.000000);
	TextDrawColor(TW_TextDraws[4], -1);
	TextDrawSetOutline(TW_TextDraws[4], 0);
	TextDrawSetProportional(TW_TextDraws[4], 1);
	TextDrawSetShadow(TW_TextDraws[4], 1);
	TextDrawUseBox(TW_TextDraws[4], 1);
	TextDrawBoxColor(TW_TextDraws[4], 255);
	TextDrawTextSize(TW_TextDraws[4], 10.000000, 10.000000);
	TextDrawSetSelectable(TW_TextDraws[4], 0);
}



TurfWars_GetTurfID(playerid) {

	new areaid[1];
	GetPlayerDynamicAreas(playerid, areaid);
	new iTurfID = Streamer_GetIntData(STREAMER_TYPE_AREA, areaid[0], E_STREAMER_EXTRA_ID);
	if(0 <= iTurfID < MAX_TURFS && areaid[0] == arrTurfWars[iTurfID][tw_iAreaID]) {
		return iTurfID;
	}
	iTurfID = GetPlayer2DTurf(playerid);
	if(iTurfID != 369) return iTurfID;
	return 369; // San Andreas Main Zone
}

TurfWars_GUI(playerid, bool:bState) {

	switch(bState) {

		case true: {

			TurfWars_SyncGUI(playerid, TurfWars_GetTurfID(playerid));
			
			TextDrawShowForPlayer(playerid, TW_TextDraws[0]);
			TextDrawShowForPlayer(playerid, TW_TextDraws[1]);
			TextDrawShowForPlayer(playerid, TW_TextDraws[2]);
			TextDrawShowForPlayer(playerid, TW_TextDraws[3]);
			TextDrawShowForPlayer(playerid, TW_TextDraws[4]);
			PlayerTextDrawShow(playerid, TW_PTextDraws[playerid][0]);
			PlayerTextDrawShow(playerid, TW_PTextDraws[playerid][1]);
			PlayerTextDrawShow(playerid, TW_PTextDraws[playerid][2]);
			PlayerTextDrawShow(playerid, TW_PTextDraws[playerid][3]);
			PlayerTextDrawShow(playerid, TW_PTextDraws[playerid][4]);
			PlayerTextDrawShow(playerid, TW_PTextDraws[playerid][5]);
		}
		default: {
			
			TextDrawHideForPlayer(playerid, TW_TextDraws[0]);
			TextDrawHideForPlayer(playerid, TW_TextDraws[1]);
			TextDrawHideForPlayer(playerid, TW_TextDraws[2]);
			TextDrawHideForPlayer(playerid, TW_TextDraws[3]);
			TextDrawHideForPlayer(playerid, TW_TextDraws[4]);
			
			PlayerTextDrawHide(playerid, TW_PTextDraws[playerid][0]);
			PlayerTextDrawHide(playerid, TW_PTextDraws[playerid][1]);
			PlayerTextDrawHide(playerid, TW_PTextDraws[playerid][2]);
			PlayerTextDrawHide(playerid, TW_PTextDraws[playerid][3]);
			PlayerTextDrawHide(playerid, TW_PTextDraws[playerid][4]);
			PlayerTextDrawHide(playerid, TW_PTextDraws[playerid][5]);
		}
	}
}

TurfWars_SetHealth(iTurfID, iHealth) {

	arrTurfWars[iTurfID][tw_iHealth] = iHealth;
	format(szMiscArray, sizeof(szMiscArray), "%d", arrTurfWars[iTurfID][tw_iHealth]);
	foreach(new p : Player) PlayerTextDrawSetString(p, TW_PTextDraws[p][1], szMiscArray);
}

TurfWars_SyncGUI(playerid, iTurfID) {

	szMiscArray[0] = 0;
	if(playerid == INVALID_PLAYER_ID) {

		foreach(new p : Player) {

			if(TurfWars_GetTurfID(p) != iTurfID) continue;
			if(Bit_State(arrTurfWarsBits[iTurfID], tw_bDisabled)) {

				TextDrawHideForPlayer(p, TW_TextDraws[3]);
				TextDrawHideForPlayer(p, TW_TextDraws[4]);
				PlayerTextDrawHide(p, TW_PTextDraws[p][1]);
				PlayerTextDrawHide(p, TW_PTextDraws[p][2]);
				PlayerTextDrawHide(p, TW_PTextDraws[p][3]);
				PlayerTextDrawHide(p, TW_PTextDraws[p][4]);
				PlayerTextDrawHide(p, TW_PTextDraws[p][5]);
				PlayerTextDrawColor(p, TW_PTextDraws[p][0], 0xEEEEEE88);
				format(szMiscArray, sizeof(szMiscArray), "Disabled (ID %d)", iTurfID);
				PlayerTextDrawSetString(p, TW_PTextDraws[p][0], szMiscArray);
				PlayerTextDrawHide(p, TW_PTextDraws[p][0]);
				PlayerTextDrawShow(p, TW_PTextDraws[p][0]);
				return 1;
			}
			// if(Bit_State(arrTurfWarsBits[iTurfID], tw_bVulnerable)) {
			if(GetGVarType("TW_Capturer", iTurfID)) {
				PlayerTextDrawSetString(p, TW_PTextDraws[p][3], "hud:radar_enemyAttack");
				PlayerTextDrawSetString(p, TW_PTextDraws[p][5], "hud:radar_Flag");
			}
			else if(arrTurfWars[iTurfID][tw_bVulnerable] == true) {

				PlayerTextDrawSetString(p, TW_PTextDraws[p][3], "hud:radar_enemyAttack");
				PlayerTextDrawSetString(p, TW_PTextDraws[p][5], "hud:radar_enemyAttack");
			}
			else {
				PlayerTextDrawSetString(p, TW_PTextDraws[p][3], "hud:radar_Flag");
				PlayerTextDrawSetString(p, TW_PTextDraws[p][5], "hud:radar_Flag");
			}

			if(arrTurfWars[iTurfID][tw_iGroupID] == INVALID_GROUP_ID) {
				PlayerTextDrawColor(p, TW_PTextDraws[p][0], 0xEEEEEE88);
				PlayerTextDrawSetString(p, TW_PTextDraws[p][0], "Neutral");
			}
			else {

				PlayerTextDrawColor(p, TW_PTextDraws[p][0], arrGroupData[arrTurfWars[iTurfID][tw_iGroupID]][g_hDutyColour] * 256 + 200);
				if(Bit_State(arrTurfWarsBits[iTurfID], tw_bHeadquarter)) {
					format(szMiscArray, sizeof(szMiscArray), "%s (HQ)", arrGroupData[arrTurfWars[iTurfID][tw_iGroupID]][g_szGroupName]);
				}
				else if(Bit_State(arrTurfWarsBits[iTurfID], tw_bShutdown)) {
					PlayerTextDrawColor(p, TW_PTextDraws[p][0], 0xDDDDDD88);
					format(szMiscArray, sizeof(szMiscArray), "%s (S)", arrGroupData[arrTurfWars[iTurfID][tw_iGroupID]][g_szGroupName]);
				}
				else strins(szMiscArray, arrGroupData[arrTurfWars[iTurfID][tw_iGroupID]][g_szGroupName], 0, sizeof(szMiscArray));
				PlayerTextDrawSetString(p, TW_PTextDraws[p][0], szMiscArray);
			}
			format(szMiscArray, sizeof(szMiscArray), "%s (ID %d)", gSAZones[iTurfID][SAZONE_NAME], iTurfID);
			PlayerTextDrawSetString(p, TW_PTextDraws[p][2], szMiscArray);
			format(szMiscArray, sizeof(szMiscArray), "%d", arrTurfWars[iTurfID][tw_iHealth]);
			PlayerTextDrawSetString(p, TW_PTextDraws[p][1], szMiscArray);
			format(szMiscArray, sizeof(szMiscArray), "%d", arrTurfWars[iTurfID][tw_iLevel]);
			PlayerTextDrawSetString(p, TW_PTextDraws[p][4], szMiscArray);

			PlayerTextDrawHide(p, TW_PTextDraws[p][0]);
			PlayerTextDrawShow(p, TW_PTextDraws[p][0]);
			PlayerTextDrawHide(p, TW_PTextDraws[p][1]);
			PlayerTextDrawShow(p, TW_PTextDraws[p][1]);
			PlayerTextDrawHide(p, TW_PTextDraws[p][2]);
			PlayerTextDrawShow(p, TW_PTextDraws[p][2]);
			PlayerTextDrawHide(p, TW_PTextDraws[p][3]);
			PlayerTextDrawShow(p, TW_PTextDraws[p][3]);
			PlayerTextDrawHide(p, TW_PTextDraws[p][4]);
			PlayerTextDrawShow(p, TW_PTextDraws[p][4]);
			PlayerTextDrawHide(p, TW_PTextDraws[p][5]);
			PlayerTextDrawShow(p, TW_PTextDraws[p][5]);

			TextDrawShowForPlayer(p, TW_TextDraws[3]);
			TextDrawShowForPlayer(p, TW_TextDraws[4]);
		}
	}
	else {
		if(!GetPVarType(playerid, "TInfo")) return 1;
		if(Bit_State(arrTurfWarsBits[iTurfID], tw_bDisabled)) {

			TextDrawHideForPlayer(playerid, TW_TextDraws[3]);
			TextDrawHideForPlayer(playerid, TW_TextDraws[4]);
			PlayerTextDrawHide(playerid, TW_PTextDraws[playerid][1]);
			PlayerTextDrawHide(playerid, TW_PTextDraws[playerid][2]);
			PlayerTextDrawHide(playerid, TW_PTextDraws[playerid][3]);
			PlayerTextDrawHide(playerid, TW_PTextDraws[playerid][4]);
			PlayerTextDrawHide(playerid, TW_PTextDraws[playerid][5]);
			PlayerTextDrawColor(playerid, TW_PTextDraws[playerid][0], 0xEEEEEE88);
			format(szMiscArray, sizeof(szMiscArray), "Disabled (ID %d)", iTurfID);
			PlayerTextDrawSetString(playerid, TW_PTextDraws[playerid][0], szMiscArray);
			PlayerTextDrawHide(playerid, TW_PTextDraws[playerid][0]);
			PlayerTextDrawShow(playerid, TW_PTextDraws[playerid][0]);
			return 1;
		}
		// if(Bit_State(arrTurfWarsBits[iTurfID], tw_bVulnerable)) {
		if(GetGVarType("TW_Capturer", iTurfID)) {
			PlayerTextDrawSetString(playerid, TW_PTextDraws[playerid][3], "hud:radar_enemyAttack");
			PlayerTextDrawSetString(playerid, TW_PTextDraws[playerid][5], "hud:radar_Flag");
		}
		else if(arrTurfWars[iTurfID][tw_bVulnerable] == true) {

			PlayerTextDrawSetString(playerid, TW_PTextDraws[playerid][3], "hud:radar_enemyAttack");
			PlayerTextDrawSetString(playerid, TW_PTextDraws[playerid][5], "hud:radar_enemyAttack");
		}
		else {
			PlayerTextDrawSetString(playerid, TW_PTextDraws[playerid][3], "hud:radar_Flag");
			PlayerTextDrawSetString(playerid, TW_PTextDraws[playerid][5], "hud:radar_Flag");
		}

		if(arrTurfWars[iTurfID][tw_iGroupID] == INVALID_GROUP_ID) {
			PlayerTextDrawColor(playerid, TW_PTextDraws[playerid][0], 0xEEEEEE88);
			PlayerTextDrawSetString(playerid, TW_PTextDraws[playerid][0], "Neutral");
		}
		else {

			PlayerTextDrawColor(playerid, TW_PTextDraws[playerid][0], arrGroupData[arrTurfWars[iTurfID][tw_iGroupID]][g_hDutyColour] * 256 + 200);
			if(Bit_State(arrTurfWarsBits[iTurfID], tw_bHeadquarter)) {
				format(szMiscArray, sizeof(szMiscArray), "%s (HQ)", arrGroupData[arrTurfWars[iTurfID][tw_iGroupID]][g_szGroupName]);
			}
			else strins(szMiscArray, arrGroupData[arrTurfWars[iTurfID][tw_iGroupID]][g_szGroupName], 0, sizeof(szMiscArray));
			PlayerTextDrawSetString(playerid, TW_PTextDraws[playerid][0], szMiscArray);
		}
		format(szMiscArray, sizeof(szMiscArray), "%s (ID %d)", gSAZones[iTurfID][SAZONE_NAME], iTurfID);
		PlayerTextDrawSetString(playerid, TW_PTextDraws[playerid][2], szMiscArray);
		format(szMiscArray, sizeof(szMiscArray), "%d", arrTurfWars[iTurfID][tw_iHealth]);
		PlayerTextDrawSetString(playerid, TW_PTextDraws[playerid][1], szMiscArray);
		format(szMiscArray, sizeof(szMiscArray), "%d", arrTurfWars[iTurfID][tw_iLevel]);
		PlayerTextDrawSetString(playerid, TW_PTextDraws[playerid][4], szMiscArray);

		PlayerTextDrawHide(playerid, TW_PTextDraws[playerid][0]);
		PlayerTextDrawShow(playerid, TW_PTextDraws[playerid][0]);
		PlayerTextDrawHide(playerid, TW_PTextDraws[playerid][1]);
		PlayerTextDrawShow(playerid, TW_PTextDraws[playerid][1]);
		PlayerTextDrawHide(playerid, TW_PTextDraws[playerid][2]);
		PlayerTextDrawShow(playerid, TW_PTextDraws[playerid][2]);
		PlayerTextDrawHide(playerid, TW_PTextDraws[playerid][3]);
		PlayerTextDrawShow(playerid, TW_PTextDraws[playerid][3]);
		PlayerTextDrawHide(playerid, TW_PTextDraws[playerid][4]);
		PlayerTextDrawShow(playerid, TW_PTextDraws[playerid][4]);
		PlayerTextDrawHide(playerid, TW_PTextDraws[playerid][5]);
		PlayerTextDrawShow(playerid, TW_PTextDraws[playerid][5]);

		TextDrawShowForPlayer(playerid, TW_TextDraws[3]);
		TextDrawShowForPlayer(playerid, TW_TextDraws[4]);
	}
	return 1;
}