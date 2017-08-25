/*
				 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
				| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
				| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
				| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
				| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
				| $$\  $$$| $$  \ $$        | $$  \ $$| $$
				| $$ \  $$|  $$$$$$/        | $$  | $$| $$
				|__/  \__/ \______/         |__/  |__/|__/

//-------------------------[OnDialogResponse.PWN]--------------------------------


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

// This is the first hooked OnDialogResponse. It's used to check dialog spoofing.
hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
	if(dialogid != iLastDialogID[playerid]) {
		if(dialogid != DIALOG_FS_ELEVATOR1 && dialogid != DIALOG_FS_ELEVATOR2) { // For dialogs called from filterscripts.
			if(PlayerInfo[playerid][pAdmin] == 99999 || dialogid == 32700) return 1;
	    	SendClientMessageEx(playerid, COLOR_LIGHTRED, "[SYSTEM] Please delete your dialog CLEO.");
	    	SetTimerEx("KickEx", 1000, 0, "i", playerid);
	    }
	}
    iLastDialogID[playerid] = -1;
    return 0;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	if(dialogid == DIALOG_DISABLED) return ShowPlayerDialogEx(playerid, DIALOG_DISABLED, DIALOG_STYLE_MSGBOX, "Account Disabled - Visit http://www.ng-gaming.net/forums", "Your account has been disabled as it has been inactive for more than six months.\nPlease visit the forums and post an Administrative Request to begin the process to reactivate your account.", "Okay", "");
	new sendername[MAX_PLAYER_NAME];
	new string[256];
	szMiscArray[0] = 0;

	// Crash Bug Fix
	if(strfind(inputtext, "%", true) != -1)
	{
		if(dialogid == MAINMENU) ShowMainMenuDialog(playerid, 1);
		if(dialogid == MAINMENU2) ShowMainMenuDialog(playerid, 2);
		if(dialogid == DIALOG_CHANGEPASS2) ShowLoginDialogs(playerid, 0);
		SendClientMessage(playerid, COLOR_GREY, "Invalid Character, please try again.");
		return 1;
	}
	if(strfind(inputtext, "UPDATE", true) != -1 || strfind(inputtext, "SELECT", true) != -1 || strfind(inputtext, "DROP", true) != -1 || strfind(inputtext, "INSERT", true) != -1 || strfind(inputtext, "SLEEP", true) != -1)
	{
		new logstirng[400];
		format(logstirng, sizeof(logstirng), "%s | Dialog ID: %d | SQL ID: %d", inputtext, dialogid, PlayerInfo[playerid][pId]);
		Log("logs/fquery.log", logstirng);
	}
	if(RegistrationStep[playerid] != 0)
	{
		if(dialogid == REGISTERSEX)
		{
			if(response)
			{
				if(listitem == 0)
				{
					PlayerInfo[playerid][pSex] = 1;
					SendClientMessageEx(playerid, COLOR_YELLOW2, "Alright, so you're a male.");
					ShowPlayerDialogEx(playerid, REGISTERMONTH, DIALOG_STYLE_LIST, "{FF0000}Which month was your character born?", "January\nFebruary\nMarch\nApril\nMay\nJune\nJuly\nAugust\nSeptember\nOctober\nNovember\nDecember", "Submit", "");
					RegistrationStep[playerid] = 2;
				}
				else
				{
					PlayerInfo[playerid][pSex] = 2;
					SendClientMessageEx(playerid, COLOR_YELLOW2, "Alright, so you're a female.");
					ShowPlayerDialogEx(playerid, REGISTERMONTH, DIALOG_STYLE_LIST, "{FF0000}Which month was your character born?", "January\nFebruary\nMarch\nApril\nMay\nJune\nJuly\nAugust\nSeptember\nOctober\nNovember\nDecember", "Submit", "");
					RegistrationStep[playerid] = 2;
				}
			}
			else ShowPlayerDialogEx(playerid, REGISTERSEX, DIALOG_STYLE_LIST, "{FF0000}Is your character male or female?", "Male\nFemale", "Submit", "");
		}
	}
	if(RegistrationStep[playerid] != 0 || strcmp(PlayerInfo[playerid][pBirthDate], "0000-00-00", true) == 0)
	{
		if(dialogid == REGISTERMONTH)
		{
			if(response)
			{
				new month = listitem+1;
				SetPVarInt(playerid, "RegisterMonth", month);

				new lastdate, stringdiag[410];
				if(listitem == 0 || listitem == 2 || listitem == 4 || listitem == 6 || listitem == 7 || listitem == 9 || listitem == 11) lastdate = 32;
				else if(listitem == 3 || listitem == 5 || listitem == 8 || listitem == 10) lastdate = 31;
				else lastdate = 29;
				for(new x = 1; x < lastdate; x++)
				{
					format(stringdiag, sizeof(stringdiag), "%s%d\n", stringdiag, x);
				}
				ShowPlayerDialogEx(playerid, REGISTERDAY, DIALOG_STYLE_LIST, "{FF0000}Which day was your character born?", stringdiag, "Submit", "");
			}
			else ShowPlayerDialogEx(playerid, REGISTERMONTH, DIALOG_STYLE_LIST, "{FF0000}Which month was your character born?", "January\nFebruary\nMarch\nApril\nMay\nJune\nJuly\nAugust\nSeptember\nOctober\nNovember\nDecember", "Submit", "");
		}
		else if(dialogid == REGISTERDAY)
		{
			if(response)
			{
				new setday = listitem+1;
				SetPVarInt(playerid, "RegisterDay", setday);

				new month, day, year, stringdiag[600];
				getdate(year,month,day);
				new startyear = year-100;
				for(new x = startyear; x < year; x++)
				{
					format(stringdiag, sizeof(stringdiag), "%s%d\n", stringdiag, x);
				}
				ShowPlayerDialogEx(playerid, REGISTERYEAR, DIALOG_STYLE_LIST, "{FF0000}Which year was your character born?", stringdiag, "Submit", "");
			}
			else ShowPlayerDialogEx(playerid, REGISTERMONTH, DIALOG_STYLE_LIST, "{FF0000}Which month was your character born?", "January\nFebruary\nMarch\nApril\nMay\nJune\nJuly\nAugust\nSeptember\nOctober\nNovember\nDecember", "Submit", "");
		}
		else if(dialogid == REGISTERYEAR)
		{
			new month, day, year, stringdiag[600];
			getdate(year,month,day);
			new startyear = year-100;
			if(response)
			{
				new setyear = listitem+startyear;
				format(PlayerInfo[playerid][pBirthDate], 11, "%d-%02d-%02d", setyear, GetPVarInt(playerid, "RegisterMonth"), GetPVarInt(playerid, "RegisterDay"));
				DeletePVar(playerid, "RegisterMonth");
				DeletePVar(playerid, "RegisterDay");
				if(RegistrationStep[playerid] != 0)
				{
					ShowPlayerDialogEx(playerid, REGISTERREF, DIALOG_STYLE_INPUT, "{FF0000}Next Generation Roleplay Referral System", "Have you been referred to our server by one of our players?\nIf so, please enter the player name below.\n\nIf you haven't been referred by anyone, you may press the skip button.\n\n{FF0000}Note: You must enter the player name with a underscore (Example: FirstName_LastName)", "Enter", "Skip");
				}
				else return SendClientMessageEx(playerid, COLOR_LIGHTRED, "Your birthdate has been successfully set.");
			}
			else
			{
				for(new x = startyear; x < year; x++)
				{
					format(stringdiag, sizeof(stringdiag), "%s%d\n", stringdiag, x);
				}
				ShowPlayerDialogEx(playerid, REGISTERYEAR, DIALOG_STYLE_LIST, "{FF0000}Which year was your character born?", stringdiag, "Submit", "");
			}
		}
		else if(dialogid == REGISTERREF)
		{
			if(response)
			{
				if(IsNumeric(inputtext))
				{
					ShowPlayerDialogEx(playerid, REGISTERREF, DIALOG_STYLE_INPUT, "{FF0000}Error - Invalid Roleplay Name", "That is not a roleplay name\nPlease enter a proper roleplay name.\n\nExample: FirstName_LastName", "Enter", "Skip");
					return 1;
				}
				if(strfind(inputtext, "_", true) == -1)
				{
					ShowPlayerDialogEx(playerid, REGISTERREF, DIALOG_STYLE_INPUT, "{FF0000}Error - Invalid Roleplay Name", "That is not a roleplay name\nPlease enter a proper roleplay name.\n\nExample: FirstName_LastName", "Enter", "Skip");
					return 1;
				}
				if(strlen(inputtext) > 20)
				{
					ShowPlayerDialogEx(playerid, REGISTERREF, DIALOG_STYLE_INPUT, "{FF0000}Error - Invalid Roleplay Name", "That name is too long\nPlease shorten the name.\n\nExample: FirstName_LastName (20 Characters Max)", "Enter", "Skip");
					return 1;
				}
				if(strcmp(inputtext, GetPlayerNameExt(playerid), true) == 0)
				{
					ShowPlayerDialogEx(playerid, REGISTERREF, DIALOG_STYLE_INPUT, "{FF0000}Error", "You can't add yourself as a referrer.\nPlease enter the referrer name or press 'Skip'.\n\nExample: FirstName_LastName (20 Characters Max)", "Enter", "Skip");
					return 1;
				}
				for(new sz = 0; sz < strlen(inputtext); sz++)
				{
					if(inputtext[sz] == ' ')
					{
						ShowPlayerDialogEx(playerid, REGISTERREF, DIALOG_STYLE_INPUT, "{FF0000}Error - Invalid Roleplay Name", "That is not a roleplay name\nPlease enter a proper roleplay name.\n\nExample: FirstName_LastName", "Enter", "Skip");
						return 1;
					}
				}

				new
					szQuery[128], szEscape[MAX_PLAYER_NAME];

				mysql_escape_string(inputtext, szEscape);

				format(PlayerInfo[playerid][pReferredBy], MAX_PLAYER_NAME, "%s", szEscape);

				mysql_format(MainPipeline, szQuery, sizeof(szQuery), "SELECT `Username` FROM `accounts` WHERE `Username` = '%s'", szEscape);
				mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "iii", MAIN_REFERRAL_THREAD, playerid, g_arrQueryHandle{playerid});
			}
			else {
				PlayerInfo[playerid][pTut]++;
				AdvanceTutorial(playerid);
				format(string, sizeof(string), "Nobody");
				strmid(PlayerInfo[playerid][pReferredBy], string, 0, strlen(string), MAX_PLAYER_NAME);
				SendClientMessageEx(playerid, COLOR_LIGHTRED, "Thanks for filling in all the information, now you can proceed to the tutorial!");
				//Tutorial_Start(playerid);
				RegistrationStep[playerid] = 3;
				SetPlayerVirtualWorld(playerid, 0);
				ClearChatbox(playerid);
				TutStep[playerid] = 1;
				//ShowTutGUIBox(playerid);
				if(fexist("NoTutorial.h"))
				{
					//ShowTutGUIFrame(playerid, 23);
					//TutStep[playerid] = 23;
				}
				/*else
				{
					ShowTutGUIFrame(playerid, 1);
					TutStep[playerid] = 1;
				}*/
				Streamer_UpdateEx(playerid, 1607.0160,-1510.8218,207.4438);
				SetPlayerPos(playerid, 1607.0160,-1510.8218,-10.0);
				SetPlayerCameraPos(playerid, 1850.1813,-1765.7552,81.9271);
				SetPlayerCameraLookAt(playerid, 1607.0160,-1510.8218,207.4438);
			}
		}
	}
	switch(dialogid)
	{
		case DIALOG_911PICKLOCK: if(response)
		{
			new Float: carPos[3];
			if(PlayerVehicleInfo[playerid][listitem][pvId] > INVALID_PLAYER_VEHICLE_ID) {
				if(PlayerVehicleInfo[playerid][listitem][pvAlarmTriggered]) {
					GetVehiclePos(PlayerVehicleInfo[playerid][listitem][pvId], carPos[0], carPos[1], carPos[2]);
					new zone[MAX_ZONE_NAME], mainzone[MAX_ZONE_NAME];
					Get3DZone(carPos[0], carPos[1], carPos[2], zone, sizeof(zone));
					Get2DMainZone(carPos[0], carPos[1], mainzone, sizeof(mainzone));
					format(string, sizeof(string), "Your vehicle is located in %s(%s).", zone, mainzone);
					SendClientMessageEx(playerid, COLOR_YELLOW, string);
					format(string, sizeof(string), "Suspected Vehicle Burglary, %s(%d)", GetVehicleName(PlayerVehicleInfo[playerid][listitem][pvId]), PlayerVehicleInfo[playerid][listitem][pvId]);
					SendCallToQueue(playerid, string, zone, mainzone, 4, PlayerVehicleInfo[playerid][listitem][pvId]);
					SetPVarInt(playerid, "Has911Call", 1);
					SendClientMessageEx(playerid, TEAM_CYAN_COLOR, "Dispatch: We have alerted all units in the area.");
					SendClientMessageEx(playerid, TEAM_CYAN_COLOR, "Thank you for reporting this incident");
				}
				else {
					SetPVarInt(playerid, "ConfirmReport", listitem);
					ShowPlayerDialogEx(playerid, DIALOG_911PICKLOCK2, DIALOG_STYLE_MSGBOX, "{FFFB00}Warning - Confirmation Required", "Are you sure you want to report this Vehicle Burglary?\nYour alarm has not yet been triggered for this vehicle.\nPlease have in mind that it is a Vehicle Burglary {FF8400}In Progress", "Confirm", "Cancel");
				}
			}
			else if(PlayerVehicleInfo[playerid][listitem][pvImpounded]) SendClientMessageEx(playerid, COLOR_WHITE, "You can not report an impounded vehicle. If you wish to reclaim it, do so at the DMV in Dillimore.");
			else if(PlayerVehicleInfo[playerid][listitem][pvDisabled] == 1) SendClientMessageEx(playerid, COLOR_WHITE, "You can not report a disabled vehicle. It is disabled due to your VIP level (vehicle restrictions).");
			else if(PlayerVehicleInfo[playerid][listitem][pvSpawned] == 0) SendClientMessageEx(playerid, COLOR_WHITE, "You can not report a stored vehicle. Use /vstorage to spawn it.");
			else SendClientMessageEx(playerid, COLOR_WHITE, "You can not track a non-existent vehicle.");
		}
		case DIALOG_911PICKLOCK2: {
			if(response) {
				new Float: carPos[3];
				GetVehiclePos(PlayerVehicleInfo[playerid][listitem][pvId], carPos[0], carPos[1], carPos[2]);
				new zone[MAX_ZONE_NAME], mainzone[MAX_ZONE_NAME];
				Get3DZone(carPos[0], carPos[1], carPos[2], zone, sizeof(zone));
				Get2DMainZone(carPos[0], carPos[1], mainzone, sizeof(mainzone));
				format(string, sizeof(string), "Your vehicle is located in %s(%s).", zone, mainzone);
				SendClientMessageEx(playerid, COLOR_YELLOW, string);
				format(string, sizeof(string), "Suspected Vehicle Burglary, %s(%d)", GetVehicleName(PlayerVehicleInfo[playerid][listitem][pvId]), PlayerVehicleInfo[playerid][listitem][pvId]);
				SendCallToQueue(playerid, string, zone, mainzone, 4, PlayerVehicleInfo[playerid][listitem][pvId]);
				SetPVarInt(playerid, "Has911Call", 1);
				SendClientMessageEx(playerid, TEAM_CYAN_COLOR, "Dispatch: We have alerted all units in the area.");
				SendClientMessageEx(playerid, TEAM_CYAN_COLOR, "Thank you for reporting this incident");
			}
			DeletePVar(playerid, "ConfirmReport");
		}

		case DIALOG_NATION_CHECK:
		{
			if(response) {
				PlayerInfo[playerid][pNation] = listitem;
				switch(listitem) {
					case 0: SendClientMessageEx(playerid, COLOR_GRAD1, "You are now a citizen of San Andreas.");
					case 1: SendClientMessageEx(playerid, COLOR_GRAD1, "You are now a citizen of New Robada.");
				}
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GRAD1, "You did not provide a response, picking a random nation for you...");
				new rand = random(2);
				PlayerInfo[playerid][pNation] = rand;
				switch(rand) {
					case 0: SendClientMessageEx(playerid, COLOR_GRAD1, "You are now a citizen of San Andreas.");
					case 1: SendClientMessageEx(playerid, COLOR_GRAD1, "You are now a citizen of New Robada.");
				}
			}
		}

		case BIGEARS3:
		{
			if(response) {
				new group = ListItemTrackId[playerid][listitem];
				if (arrGroupData[group][g_iGroupType] == GROUP_TYPE_CONTRACT && PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1)
				{
					SendClientMessage(playerid, COLOR_WHITE, "Only Senior Admins+ are allowed to use this feature.");
					return 1;
				}
				SetPVarInt(playerid, "BigEar", 5);
				SetPVarInt(playerid, "BigEarOOCGroup", group);
			}
			else ShowPlayerDialogEx(playerid, BIGEARS, DIALOG_STYLE_LIST, "Please choose an item to proceed", "Global Chat\nOOC Chat\nIC Chat\nFaction Chat\nGroup OOC Chat\nPlayer\nPrivate Messages\nDisable Bigears", "Select", "Cancel");
		}
		case BIGEARS: if(response) switch(listitem) {
			case 0: {
				SetPVarInt(playerid, "BigEar", 1);
				SendClientMessage(playerid, COLOR_WHITE, "You have selected the Global Chat, you can now see all the messages server-wide.");
			}
			case 1: {
				SetPVarInt(playerid, "BigEar", 2);
				SendClientMessage(playerid, COLOR_WHITE, "You have selected the OOC Chat, you can now see all the OOC(/b) messages server-wide.");
			}
			case 2: {
				SetPVarInt(playerid, "BigEar", 3);
				SendClientMessage(playerid, COLOR_WHITE, "You have selected the IC Chat, you can now see all the IC(Includes /me's & /do's) messages server-wide.");
			}
			case 3: {
				Group_ListGroups(playerid, BIGEARS2);
			}
			case 4: {
				Group_ListGroups(playerid, BIGEARS3);
			}
			case 5: {
				ShowPlayerDialogEx(playerid, BIGEARS4, DIALOG_STYLE_INPUT, "{3399FF}Big Ears Player", "Please type in the name or the Id of the person you want to use the Big Ears function", "Select", "Back");
			}
			case 6: {
				ShowPlayerDialogEx(playerid, BIGEARS5, DIALOG_STYLE_INPUT, "{3399FF}Big Ears | Private Messages", "Please type in the name or the Id of the person you want to use the Big Ears function", "Select", "Back");
			}
			case 7: {
				DeletePVar(playerid, "BigEar");
				DeletePVar(playerid, "BigEarGroup");
				DeletePVar(playerid, "BigEarPlayer");
				DeletePVar(playerid, "BigEarOOCGroup");
				DeletePVar(playerid, "BigEarPM");
				DeletePVar(playerid, "BigEarPlayerPM");
				rBigEarT[playerid] = 0;
				SendClientMessage(playerid, COLOR_WHITE, "You have disabled the bigears feature, you no longer see anything on your screen.");
			}
		}
		case BIGEARS4: {
			if(response) {
				new giveplayerid;
				if(sscanf(inputtext, "u", giveplayerid) || PlayerInfo[giveplayerid][pAdmin] > PlayerInfo[playerid][pAdmin]) {
					ShowPlayerDialogEx(playerid, BIGEARS4, DIALOG_STYLE_INPUT, "{3399FF}Big Ears Player", "Error - Please type in the name or the Id of the person you want to use the Big Ears function", "Select", "Back");
					return 1;
				}
				SetPVarInt(playerid, "BigEar", 6);
				SetPVarInt(playerid, "BigEarPlayer", giveplayerid);
				SendClientMessageEx(playerid, COLOR_WHITE, "You can now see all the messages from this player.");
			}
			else ShowPlayerDialogEx(playerid, BIGEARS, DIALOG_STYLE_LIST, "Please choose an item to proceed", "Global Chat\nOOC Chat\nIC Chat\nFaction Chat\nGroup OOC Chat\nPlayer\nPrivate Messages\nDisable Bigears", "Select", "Cancel");
		}
		case BIGEARS5: {
			if(response) {
				new giveplayerid, szString[128];
				if(sscanf(inputtext, "u", giveplayerid) || PlayerInfo[giveplayerid][pAdmin] > PlayerInfo[playerid][pAdmin]) {
					ShowPlayerDialogEx(playerid, BIGEARS5, DIALOG_STYLE_INPUT, "{3399FF}Big Ears | Private Messages", "Error - Please type in the name or the Id of the person you want to use the Big Ears function", "Select", "Back");
					return 1;
				}
				SetPVarInt(playerid, "BigEarPM", 1);
				SetPVarInt(playerid, "BigEarPlayerPM", giveplayerid);
				format(szString, sizeof(szString), "You will now receive all private messages from %s", GetPlayerNameEx(giveplayerid));
				SendClientMessageEx(playerid, COLOR_WHITE, szString);
			}
			else ShowPlayerDialogEx(playerid, BIGEARS, DIALOG_STYLE_LIST, "Please choose an item to proceed", "Global Chat\nOOC Chat\nIC Chat\nFaction Chat\nGroup OOC Chat\nPlayer\nPrivate Messages\nDisable Bigears", "Select", "Cancel");
		}
		case BIGEARS2: {
			if(response) {
				new group = ListItemTrackId[playerid][listitem];
				if (arrGroupData[group][g_iGroupType] == GROUP_TYPE_CONTRACT && PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1)
				{
					SendClientMessage(playerid, COLOR_WHITE, "Only Senior Admins+ are allowed to use this feature.");
					return 1;
				}
				SetPVarInt(playerid, "BigEar", 4);
				SetPVarInt(playerid, "BigEarGroup", group);
			}
			else ShowPlayerDialogEx(playerid, BIGEARS, DIALOG_STYLE_LIST, "Please choose an item to proceed", "Global Chat\nOOC Chat\nIC Chat\nFaction Chat\nGroup OOC Chat\nPlayer\nPrivate Messages\nDisable Bigears", "Select", "Cancel");
		}
		case DIALOG_DELETECAR:
		{
			if(response)
			{
				if(GetPVarType(playerid, "vDel")) {

					new
						i = GetPVarInt(playerid, "vDel");

					if(PlayerVehicleInfo[playerid][i][pvId] != INVALID_PLAYER_VEHICLE_ID && !PlayerVehicleInfo[playerid][i][pvImpounded] && PlayerVehicleInfo[playerid][i][pvSpawned]) {

						switch(PlayerVehicleInfo[playerid][i][pvModelId]) {
							case 519, 553, 508: {
								if(IsValidDynamicArea(iVehEnterAreaID[PlayerVehicleInfo[playerid][i][pvId]])) DestroyDynamicArea(iVehEnterAreaID[PlayerVehicleInfo[playerid][i][pvId]]);
							}
						}

						DestroyVehicle(PlayerVehicleInfo[playerid][i][pvId]);
						--PlayerCars;
						VehicleSpawned[playerid]--;
					}
					if(PlayerVehicleInfo[playerid][i][pvTicket] != 0)
					{
						GivePlayerCash(playerid, -PlayerVehicleInfo[playerid][i][pvTicket]);
						OnPlayerStatsUpdate(playerid);
						format(string, sizeof(string), "Your vehicle had active tickets on it. You have been charged the amount of the tickets ($%s).", number_format(PlayerVehicleInfo[playerid][i][pvTicket]));
						SendClientMessageEx(playerid, COLOR_WHITE, string);
					}

					format(szMiscArray, sizeof(szMiscArray), "[DELETECAR] %s (IP: %s) (SQLID: %d) has deleted their %s (%d) (SQLID: %d).", GetPlayerNameEx(playerid), GetPlayerIpEx(playerid), GetPlayerSQLId(playerid), VehicleName[PlayerVehicleInfo[playerid][i][pvModelId] - 400], PlayerVehicleInfo[playerid][i][pvModelId], PlayerVehicleInfo[playerid][i][pvSlotId]);
					Log("logs/playervehicle.log", szMiscArray);

					PlayerVehicleInfo[playerid][i][pvId] = 0;
					PlayerVehicleInfo[playerid][i][pvModelId] = 0;
					PlayerVehicleInfo[playerid][i][pvPosX] = 0.0;
					PlayerVehicleInfo[playerid][i][pvPosY] = 0.0;
					PlayerVehicleInfo[playerid][i][pvPosZ] = 0.0;
					PlayerVehicleInfo[playerid][i][pvPosAngle] = 0.0;
					PlayerVehicleInfo[playerid][i][pvLock] = 0;
					PlayerVehicleInfo[playerid][i][pvLocksLeft] = 0;
					PlayerVehicleInfo[playerid][i][pvLocked] = 0;
					PlayerVehicleInfo[playerid][i][pvPaintJob] = -1;
					PlayerVehicleInfo[playerid][i][pvColor1] = 0;
					PlayerVehicleInfo[playerid][i][pvColor2] = 0;
					PlayerVehicleInfo[playerid][i][pvPrice] = 0;
					PlayerVehicleInfo[playerid][i][pvTicket] = 0;
					for(new j = 0; j < 3; j++)
					{
						PlayerVehicleInfo[playerid][i][pvWeapons][j] = 0;
					}
					PlayerVehicleInfo[playerid][i][pvImpounded] = 0;
					PlayerVehicleInfo[playerid][i][pvSpawned] = 0;
					PlayerVehicleInfo[playerid][i][pvVW] = 0;
					PlayerVehicleInfo[playerid][i][pvInt] = 0;
					PlayerVehicleInfo[playerid][i][pvAlarm] = 0;
					PlayerVehicleInfo[playerid][i][pvAlarmTriggered] = 0;
					PlayerVehicleInfo[playerid][i][pvBeingPickLocked] = 0;
					if(PlayerVehicleInfo[playerid][i][pvAllowedPlayerId] != INVALID_PLAYER_ID)
					{
						PlayerInfo[PlayerVehicleInfo[playerid][i][pvAllowedPlayerId]][pVehicleKeys] = INVALID_PLAYER_VEHICLE_ID;
						PlayerInfo[PlayerVehicleInfo[playerid][i][pvAllowedPlayerId]][pVehicleKeysFrom] = INVALID_PLAYER_ID;
						PlayerVehicleInfo[playerid][i][pvAllowedPlayerId] = INVALID_PLAYER_ID;
					}
					GiveKeysTo[playerid] = INVALID_PLAYER_ID;
					DeletePVar(playerid, "vDel");

					new query[128];
					mysql_format(MainPipeline, query, sizeof(query), "DELETE FROM `vehicles` WHERE `id` = '%d'", PlayerVehicleInfo[playerid][i][pvSlotId]);
					mysql_tquery(MainPipeline, query, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);

					PlayerVehicleInfo[playerid][i][pvSlotId] = 0;

					return SendClientMessageEx(playerid, COLOR_WHITE, "Your vehicle has been permanently deleted.");
				}

				new
					szDialogStr[256];

				SetPVarInt(playerid, "vDel", listitem);
				if(PlayerVehicleInfo[playerid][listitem][pvTicket] != 0) format(szDialogStr, sizeof(szDialogStr), "{FFFFFF}Your {FF0000}%s{FFFFFF} will be {FF0000}permanently deleted{FFFFFF}.\n\n{FF0000}This vehicle currently has active tickets.\n{FFFFFF}You will be fined {FF0000}$%s{FFFFFF} upon vehicle deletion.\n\nYou may now confirm or cancel the deletion.", VehicleName[PlayerVehicleInfo[playerid][listitem][pvModelId] - 400], number_format(PlayerVehicleInfo[playerid][listitem][pvTicket]));
				else format(szDialogStr, sizeof(szDialogStr), "{FFFFFF}Your {FF0000}%s{FFFFFF} will be {FF0000}permanently deleted{FFFFFF}.\n\nYou may now confirm or cancel the deletion.", VehicleName[PlayerVehicleInfo[playerid][listitem][pvModelId] - 400]);
				return ShowPlayerDialogEx(playerid, DIALOG_DELETECAR, DIALOG_STYLE_MSGBOX, "Delete Vehicle", szDialogStr, "Delete", "Cancel");
			}
			else return DeletePVar(playerid, "vDel");
		}
	}
	if(dialogid == RCPINTRO)
	{
		if (response)
		{
			new msgstring[218];
			format(msgstring,sizeof(msgstring),"\tThere are stages you follow in order to make a checkpoint;\n1.- Adjusting the position of the checkpoint.\n2.- Confirm the position of the checkpoint.\n3.- Set the checkpoint size.\n4.- Set the checkpoint type.");
			ShowPlayerDialogEx(playerid,RCPINTRO2,DIALOG_STYLE_MSGBOX,"Race Checkpoints Introduction",msgstring,"Start","Cancel");
		}
		else
		{
			format(string,sizeof(string),"Create a checkpoint...\nEdit an existing checkpoint\nRemove checkpoint preview");
			ShowPlayerDialogEx(playerid,RCPCHOOSE,DIALOG_STYLE_LIST,"Race Checkpoints Configuration",string,"Okay","I'm done!");
			ConfigEventCPId[playerid] = 0;
			ConfigEventCPs[playerid][1] = 0;
		}
	}
	if(dialogid == RCPINTRO2)
	{
		if (response)
		{
			format(string,sizeof(string),"Create a checkpoint...\nEdit an existing checkpoint\nRemove checkpoint preview");
			ShowPlayerDialogEx(playerid,RCPCHOOSE,DIALOG_STYLE_LIST,"Race Checkpoints Configuration",string,"Okay","I'm done!");
			ConfigEventCPId[playerid] = 0;
			ConfigEventCPs[playerid][1] = 0;
		}
	}
	if(dialogid == RCPCHOOSE)
	{
		if (response && ConfigEventCPs[playerid][0] == 1)
		{
			if(listitem == 0) // Create a checkpoint
			{
				if(ConfigEventCPs[playerid][1] != 0) return SendClientMessageEx(playerid, COLOR_RED, "ERROR: You cannot create a new checkpoint since you are editing an existing one.");
				if(ConfigEventCPId[playerid] >= 20) {
					ConfigEventCPs[playerid][0] = 0;
					ConfigEventCPs[playerid][1] = 0;
					ConfigEventCPId[playerid] = 0;
					return SendClientMessageEx(playerid, COLOR_RED, "ERROR: You cannot create a new checkpoint since you have reached the checkpoint limit(20).");
				}
				new i;
				for(i = 0; i < 20; i++)
				{
					if(EventRCPU[i] == 0) break;
				}
				if(i >= 20) {
					ConfigEventCPs[playerid][0] = 0;
					ConfigEventCPs[playerid][1] = 0;
					ConfigEventCPId[playerid] = 0;
					return SendClientMessageEx(playerid, COLOR_RED, "ERROR: You cannot create a new checkpoint since you have reached the checkpoint limit(20).");
				}
				ConfigEventCPId[playerid] = i;
				ConfigEventCPs[playerid][1] = 1;
				ConfigEventCPs[playerid][2] = 1;
				SendClientMessageEx(playerid, COLOR_WHITE, "You are now creating a new checkpoint, you need to choose the position where the checkpoint will be at.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "NOTE: Once you are done and have the right place please press the fire button to save the position.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "NOTE: You can also cancel this action by pressing the AIM button.");
			}
			else if(listitem == 1) // Edit an existing checkpoint IN PROCESS
			{
				if(ConfigEventCPs[playerid][1] != 0) return SendClientMessageEx(playerid, COLOR_RED, "ERROR: You cannot edit a checkpoint since you are editing an existing one.");
				new bigstring[798], totalrcps;
				for(new i = 0; i < 20; i++)
				{
					if(EventRCPU[i] > 0) {
						switch(EventRCPT[i]) {
							case 1:
							{
								format(bigstring, sizeof(bigstring), "%s(RCPID:%i) Start Checkpoint", bigstring, i+1);
								format(bigstring, sizeof(bigstring), "%s\n", bigstring);
							}
							case 2:
							{
								format(bigstring, sizeof(bigstring), "%s(RCPID:%i) Normal Checkpoint", bigstring, i+1);
								format(bigstring, sizeof(bigstring), "%s\n", bigstring);
							}
							case 3:
							{
								format(bigstring, sizeof(bigstring), "%s(RCPID:%i) Watering Station Checkpoint", bigstring, i+1);
								format(bigstring, sizeof(bigstring), "%s\n", bigstring);
							}
							case 4:
							{
								format(bigstring, sizeof(bigstring), "%s(RCPID:%i) Finish Checkpoint", bigstring, i+1);
								format(bigstring, sizeof(bigstring), "%s\n", bigstring);
							}
							default:
							{
								format(bigstring, sizeof(bigstring), "%s(RCPID:%i) No Checkpoint type", bigstring, i+1);
								format(bigstring, sizeof(bigstring), "%s\n", bigstring);
							}
						}
						ListItemRCPId[playerid][totalrcps] = i;
						totalrcps++;
					}
				}
				if(totalrcps == 0) return SendClientMessageEx(playerid, COLOR_RED, "ERROR: No checkpoints have been created.");
				ShowPlayerDialogEx(playerid, RCPEDITMENU, DIALOG_STYLE_LIST,"Please choose a checkpoint to edit:", bigstring, "Edit", "Cancel");
			}
			else if(listitem == 2) // Remove view of checkpoint
			{
				DisablePlayerCheckpoint(playerid);
				SendClientMessageEx(playerid, COLOR_WHITE, "You have disabled your race checkpoints.");
			}
		}
	}
	if(dialogid == RCPEDITMENU)
	{
		ConfigEventCPs[playerid][2] = 0;
		ConfigEventCPId[playerid] = ListItemRCPId[playerid][listitem];
		ConfigEventCPs[playerid][1] = 0;
		DisablePlayerCheckpoint(playerid);
		if(EventRCPT[ConfigEventCPId[playerid]] == 1) {
			SetPlayerCheckpoint(playerid, EventRCPX[ConfigEventCPId[playerid]], EventRCPY[ConfigEventCPId[playerid]], EventRCPZ[ConfigEventCPId[playerid]], EventRCPS[ConfigEventCPId[playerid]]);
		}
		else if(EventRCPT[ConfigEventCPId[playerid]] == 4) {
			SetPlayerCheckpoint(playerid, EventRCPX[ConfigEventCPId[playerid]], EventRCPY[ConfigEventCPId[playerid]], EventRCPZ[ConfigEventCPId[playerid]], EventRCPS[ConfigEventCPId[playerid]]);
		}
		else {
			SetPlayerCheckpoint(playerid, EventRCPX[ConfigEventCPId[playerid]], EventRCPY[ConfigEventCPId[playerid]], EventRCPZ[ConfigEventCPId[playerid]], EventRCPS[ConfigEventCPId[playerid]]);
		}
		format(string,sizeof(string),"Checkpoint Edit(ID:%d)", ConfigEventCPId[playerid]);
		ShowPlayerDialogEx(playerid,RCPEDITMENU2,DIALOG_STYLE_LIST,string,"Edit position\nEdit size\nEdit type\nView checkpoint","Okay","I'm done!");
	}
	if(dialogid == RCPEDITMENU2)
	{
		if (response)
		{
			if(listitem == 0) // Edit position
			{
				ConfigEventCPs[playerid][1] = 1;
				SendClientMessageEx(playerid, COLOR_WHITE, "You are now creating editing this checkpoint's position, you need to choose the position where the checkpoint will be at.");
				SendClientMessageEx(playerid, COLOR_WHITE, "NOTE: Press the FIRE button to save the position. You can cancel this action by pressing the AIM button.");
			}
			else if(listitem == 1) // edit size
			{
				ConfigEventCPs[playerid][1] = 3;
				format(string,sizeof(string),"Race Checkpoint %d Size", ConfigEventCPId[playerid]);
				ShowPlayerDialogEx(playerid,RCPSIZE,DIALOG_STYLE_INPUT,string,"Please choose the size of the checkpoint.\nRecommended size: 5.0","Ok","Cancel");
			}
			else if(listitem == 2) // edit type
			{
				ConfigEventCPs[playerid][1] = 4;
				ShowPlayerDialogEx(playerid,RCPTYPE,DIALOG_STYLE_LIST,"Race Checkpoints Type List","1.- Start checkpoint\n2.- Normal checkpoint\n3.- Watering Station\n4.- Finish checkpoint","Okay","Cancel");
			}
			else if(listitem == 3) // view checkpoint
			{
				if(EventRCPT[ConfigEventCPId[playerid]] == 1) {
					SetPlayerCheckpoint(playerid, EventRCPX[ConfigEventCPId[playerid]], EventRCPY[ConfigEventCPId[playerid]], EventRCPZ[ConfigEventCPId[playerid]], EventRCPS[ConfigEventCPId[playerid]]);
				}
				else if(EventRCPT[ConfigEventCPId[playerid]] == 4) {
					SetPlayerCheckpoint(playerid, EventRCPX[ConfigEventCPId[playerid]], EventRCPY[ConfigEventCPId[playerid]], EventRCPZ[ConfigEventCPId[playerid]], EventRCPS[ConfigEventCPId[playerid]]);
				}
				else {
					SetPlayerCheckpoint(playerid, EventRCPX[ConfigEventCPId[playerid]], EventRCPY[ConfigEventCPId[playerid]], EventRCPZ[ConfigEventCPId[playerid]], EventRCPS[ConfigEventCPId[playerid]]);
				}
				SetPlayerPos(playerid, EventRCPX[ConfigEventCPId[playerid]], EventRCPY[ConfigEventCPId[playerid]], EventRCPZ[ConfigEventCPId[playerid]]);
				SendClientMessageEx(playerid, COLOR_WHITE, "You now have a view of this checkpoint, you are inside of the checkpoint, step outside to see it.");
			}
		}
	}
	if(dialogid == RCPTYPE)
	{
		if (response && ConfigEventCPs[playerid][0] == 1)
		{
			if(listitem == 0) // Start checkpoint
			{
				EventRCPT[ConfigEventCPId[playerid]] = 1;
				DisablePlayerCheckpoint(playerid);
				ConfigEventCPs[playerid][1] = 0;
				ConfigEventCPs[playerid][0] = 0;
				SetPlayerCheckpoint(playerid, EventRCPX[ConfigEventCPId[playerid]], EventRCPY[ConfigEventCPId[playerid]], EventRCPZ[ConfigEventCPId[playerid]], EventRCPS[ConfigEventCPId[playerid]]);
			}
			else if(listitem == 1) // Normal Checkpoint
			{
				EventRCPT[ConfigEventCPId[playerid]] = 2;
				DisablePlayerCheckpoint(playerid);
				ConfigEventCPs[playerid][1] = 0;
				ConfigEventCPs[playerid][0] = 0;
				SetPlayerCheckpoint(playerid, EventRCPX[ConfigEventCPId[playerid]], EventRCPY[ConfigEventCPId[playerid]], EventRCPZ[ConfigEventCPId[playerid]], EventRCPS[ConfigEventCPId[playerid]]);
			}
			else if(listitem == 2) // Watering Checkpoint
			{
				EventRCPT[ConfigEventCPId[playerid]] = 3;
				DisablePlayerCheckpoint(playerid);
				ConfigEventCPs[playerid][1] = 0;
				ConfigEventCPs[playerid][0] = 0;
				SetPlayerCheckpoint(playerid, EventRCPX[ConfigEventCPId[playerid]], EventRCPY[ConfigEventCPId[playerid]], EventRCPZ[ConfigEventCPId[playerid]], EventRCPS[ConfigEventCPId[playerid]]);
			}
			else if(listitem == 3) // Finish Checkpoint
			{
				EventRCPT[ConfigEventCPId[playerid]] = 4;
				DisablePlayerCheckpoint(playerid);
				ConfigEventCPs[playerid][1] = 0;
				ConfigEventCPs[playerid][0] = 0;
				SetPlayerCheckpoint(playerid, EventRCPX[ConfigEventCPId[playerid]], EventRCPY[ConfigEventCPId[playerid]], EventRCPZ[ConfigEventCPId[playerid]], EventRCPS[ConfigEventCPId[playerid]]);
			}
		}
	}
	if(dialogid == RCPSIZE)
	{
		if(response && ConfigEventCPs[playerid][0] == 1)
		{
			if(strlen(inputtext) < 1)
			{
				format(string,sizeof(string),"Race Checkpoint %d Size", ConfigEventCPId[playerid]);
				ShowPlayerDialogEx(playerid,RCPSIZE,DIALOG_STYLE_INPUT,string,"Please type a number for the size of the checkpoint","Ok","Cancel");
				return 1;
			}
			new Float: rcpsize;
			rcpsize = floatstr(inputtext);
			if(rcpsize < 1.0 && rcpsize > 15.0) return 1;
			EventRCPS[ConfigEventCPId[playerid]] = rcpsize;
			SendClientMessage(playerid, COLOR_WHITE, "Successfully changed the size, updating preview...");
			/*if(EventRCPT[ConfigEventCPId[playerid]] == 1) {
				DisablePlayerCheckpoint(playerid);
				SetPlayerCheckpoint(playerid, EventRCPX[ConfigEventCPId[playerid]], EventRCPY[ConfigEventCPId[playerid]], EventRCPZ[ConfigEventCPId[playerid]], EventRCPS[ConfigEventCPId[playerid]]);
			}
			else if(EventRCPT[ConfigEventCPId[playerid]] == 4) {
				DisablePlayerCheckpoint(playerid);
				SetPlayerCheckpoint(playerid, EventRCPX[ConfigEventCPId[playerid]], EventRCPY[ConfigEventCPId[playerid]], EventRCPZ[ConfigEventCPId[playerid]], EventRCPS[ConfigEventCPId[playerid]]);
			}*/
			DisablePlayerCheckpoint(playerid);
			if(ConfigEventCPs[playerid][2] == 1) {
				ConfigEventCPs[playerid][1] = 4;
				ShowPlayerDialogEx(playerid,RCPTYPE,DIALOG_STYLE_LIST,"Race Checkpoints Type List","1.- Start checkpoint\n2.- Normal checkpoint\n3.- Watering Station\n4.- Finish checkpoint","Okay","Cancel");
			}
			else
			{
				 SetTimerEx("RFLCheckpointu", 1000, false, "i", playerid);
				//SetPlayerCheckpoint(playerid, EventRCPX[ConfigEventCPId[playerid]], EventRCPY[ConfigEventCPId[playerid]], EventRCPZ[ConfigEventCPId[playerid]], EventRCPS[ConfigEventCPId[playerid]]);
			}
		}
	}
	if(dialogid == UNMODCARMENU)
	{
		if (response)
		{
			new count = GetPVarInt(playerid, "modCount");
			new d;
			for(new z = 0 ; z < MAX_PLAYERVEHICLES; z++)
			{
				if(IsPlayerInVehicle(playerid, PlayerVehicleInfo[playerid][z][pvId]))
				{
					d = z;
					break;
				}
			}
			for (new i = 0; i < count; i++)
			{
				if(listitem == i)
				{
					format(string, sizeof(string), "partList%i", i);
					new partID = GetPVarInt(playerid, string);
					if (partID == 999)
					{
						for(new f = 0 ; f < MAX_MODS; f++)
						{
							SetPVarInt(playerid, "unMod", 1);
							RemoveVehicleComponent(PlayerVehicleInfo[playerid][d][pvId], GetVehicleComponentInSlot(PlayerVehicleInfo[playerid][d][pvId], f));
							PlayerVehicleInfo[playerid][d][pvMods][f] = 0;
						}
						SendClientMessageEx(playerid, COLOR_WHITE, "All modifications have been removed from your vehicle.");
						return 1;
					}
					SetPVarInt(playerid, "unMod", 1);
					RemoveVehicleComponent(GetPlayerVehicleID(playerid), partID);
					if(GetVehicleComponentType(partID) == 3) {
						PlayerVehicleInfo[playerid][d][pvMods][14] = 0;
					}
					PlayerVehicleInfo[playerid][d][pvMods][GetVehicleComponentType(partID)] = 0;
					SendClientMessageEx(playerid, COLOR_WHITE, "The modification you requested has been removed.");
					return 1;
				}
			}
		}
	}

	if(dialogid == 7954) // Report tips
	{
		ShowPlayerDialogEx(playerid,7955,DIALOG_STYLE_MSGBOX,"Report tips","Tips when reporting:\n- Report what you need, not who you need.\n- Be specific, report exactly what you need.\n- Do not make false reports.\n- Do not flame admins.\n- Report only for in-game items.\n- For shop orders use the /shoporder command","Close", "");
	}
	#if defined SHOPAUTOMATED
	if(dialogid == DIALOG_SHOPORDER)
	{
		if(response)
		{
			if(strlen(inputtext) < 1 || strlen(inputtext) > 6)
			{
				ShowPlayerDialogEx(playerid, DIALOG_SHOPERROR, DIALOG_STYLE_MSGBOX, "Shop Order","ERROR: The shop order ID must be no longer than 6 characters and no lower than 1 character.", "Retry", "Cancel");
				return 1;
			}
			if(!IsNumeric(inputtext))
			{
				ShowPlayerDialogEx(playerid, DIALOG_SHOPERROR, DIALOG_STYLE_MSGBOX, "Shop Order","ERROR: The shop order ID must be a numerical value.", "Retry", "Cancel");
				return 1;
			}
			new orderid = strval(inputtext);
			if(orderid == 0)
			{
				ShowPlayerDialogEx(playerid, DIALOG_SHOPERROR, DIALOG_STYLE_MSGBOX, "Shop Order","ERROR: The shop order ID can not be 0.", "Retry", "Cancel");
				return 1;
			}
			ShowNoticeGUIFrame(playerid, 6);
			PlayerInfo[playerid][pOrder] = orderid;

			new query[384];
			format(query, sizeof(query), "\
			SELECT p.order_product_id, p.order_id, p.name, p.quantity, h.order_status_id, o.email, o.ip \
			FROM betazorder_product p \
			LEFT JOIN betazorder_history h ON h.order_id = p.order_id AND h.order_history_id = (SELECT max(order_history_id) FROM betazorder_history WHERE p.order_id = order_id) \
			LEFT JOIN betazorder o ON o.order_id = p.order_id \
			WHERE p.order_id = %d", orderid);
			mysql_tquery(ShopPipeline, query, true, "OnShopOrder", "i", playerid);

			SetPVarInt(playerid, "ShopOrderTimer", 60); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_SHOPORDERTIMER);
		}
	}

	if(dialogid == DIALOG_SHOPORDEREMAIL)
	{
		if(response)
		{
			new email[256];
			GetPVarString(playerid, "ShopEmailVerify", email, sizeof(email));
			if(!isnull(inputtext) && strcmp(inputtext, email, true) == 0)
			{
				ShowNoticeGUIFrame(playerid, 6);
				new query[384];
				format(query, sizeof(query), "\
				SELECT p.order_product_id, p.order_id, p.name, p.quantity, p.delivered, h.order_status_id \
				FROM betazorder_product p \
				LEFT JOIN betazorder_history h ON h.order_id = p.order_id AND h.order_history_id = (SELECT max(order_history_id) FROM betazorder_history WHERE p.order_id = order_id) \
				LEFT JOIN betazorder o ON o.order_id = p.order_id \
				WHERE p.order_id = %d", PlayerInfo[playerid][pOrder]);
				mysql_tquery(ShopPipeline, query, true, "OnShopOrderEmailVer", "i", playerid);
			}
			else
			{
				//ERROR ASK FURTHER HELP
				ShowPlayerDialogEx(playerid, 0, DIALOG_STYLE_MSGBOX, "Shop Order Error", "We were unable to verify that e-mail to that order, would you like further assistance from a shop technician?", "Yes", "No");
			}
		}
	}

	if(dialogid == DIALOG_SHOPORDER2)
	{
		if(response)
		{
			ShowNoticeGUIFrame(playerid, 6);
			new query[256];
			format(query, sizeof(query), "SELECT * FROM `shop` WHERE `order_id`=%d", PlayerInfo[playerid][pOrder]);
			mysql_tquery(ShopPipeline, query, true, "OnShopOrder2", "ii", playerid, listitem);
		}
	}

	if(dialogid == DIALOG_SHOPDELIVER)
	{
		if(response)
		{
			switch(GetPVarInt(playerid, "DShop_product_id"))
			{
				case 69: //Custom car
				{
					new carstring[5012];
					for(new x;x<sizeof(VehicleNameShop);x++)
					{
						format(carstring, sizeof(carstring), "%s%d - %s\n", carstring, VehicleNameShop[x][svehicleid], VehicleNameShop[x][svehiclename]);
					}
					ShowPlayerDialogEx(playerid, DIALOG_SHOPDELIVERCAR, DIALOG_STYLE_LIST, "Shop Car Delivery", carstring, "Select Car", "Cancel");
				}
			}
		}
	}

	if(dialogid == DIALOG_SHOPDELIVERCAR)
	{
		if(response)
		{
			new dialogstring[256], name[64];
			GetPVarString(playerid, "DShop_name", name, sizeof(name));
			SetPVarInt(playerid, "DShop_listitem", listitem);
			format(dialogstring, sizeof(dialogstring), "You are about to redeem: %s\nOrder ID: %d\nWith vehicle: %s (ID %d)\n\nAre you sure?", name, GetPVarInt(playerid, "DShop_order_id"), VehicleNameShop[listitem][svehicleid], VehicleNameShop[listitem][svehiclename]);
			ShowPlayerDialogEx(playerid, DIALOG_SHOPDELIVERCAR2, DIALOG_STYLE_MSGBOX, "Shop Car Delivery", dialogstring, "Reedem", "Cancel");
		}
	}

	if(dialogid == DIALOG_SHOPDELIVERCAR2)
	{
		if(response)
		{
			if(!vehicleCountCheck(playerid))
			{
				ShowPlayerDialogEx(playerid, 0, DIALOG_STYLE_MSGBOX, "Error", "You can't have any more vehicles, you own too many!", "OK", "");
			}
			else if(!vehicleSpawnCountCheck(playerid))
			{
				ShowPlayerDialogEx(playerid, 0, DIALOG_STYLE_MSGBOX, "Error", "You have too many vehicles spawned, you must store one first.", "OK", "");
			}
			else
			{
				new Float: arr_fPlayerPos[4];
				listitem = GetPVarInt(playerid, "DShop_listitem");

				GetPlayerPos(playerid, arr_fPlayerPos[0], arr_fPlayerPos[1], arr_fPlayerPos[2]);
				GetPlayerFacingAngle(playerid, arr_fPlayerPos[3]);
				CreatePlayerVehicle(playerid, GetPlayerFreeVehicleId(playerid), VehicleNameShop[listitem][svehicleid], arr_fPlayerPos[0], arr_fPlayerPos[1], arr_fPlayerPos[2], arr_fPlayerPos[3], 0, 0, 2000000, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));

				format(string, sizeof(string), "[shoporder] created a %s (%d) for %s(%d) (invoice %s).", GetVehicleName(VehicleNameShop[listitem][svehicleid]), VehicleNameShop[listitem][svehicleid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPVarInt(playerid, "DShop_order_id"));
				Log("logs/shoplog.log", string);
			}
		}
	}
	#else
	if(dialogid == DIALOG_SHOPORDER)
	{
		if(response)
		{
			if(strlen(inputtext) < 1 || strlen(inputtext) > 6)
			{
				ShowPlayerDialogEx(playerid, DIALOG_SHOPERROR, DIALOG_STYLE_MSGBOX, "Shop Order","ERROR: The shop order ID must be no longer than 6 characters and no lower than 1 character.", "Retry", "Cancel");
				return 1;
			}
			if(!IsNumeric(inputtext))
			{
				ShowPlayerDialogEx(playerid, DIALOG_SHOPERROR, DIALOG_STYLE_MSGBOX, "Shop Order","ERROR: The shop order ID must be a numerical value.", "Retry", "Cancel");
				return 1;
			}
			new orderid = strval(inputtext);
			if(orderid == 0)
			{
				ShowPlayerDialogEx(playerid, DIALOG_SHOPERROR, DIALOG_STYLE_MSGBOX, "Shop Order","ERROR: The shop order ID can not be 0.", "Retry", "Cancel");
				return 1;
			}
			PlayerInfo[playerid][pOrder] = orderid;

			SetPVarInt(playerid, "ShopOrderTimer", 60); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_SHOPORDERTIMER);

			format(string, sizeof(string), "shop.ng-gaming.net/idcheck.php?id=%d", orderid);
			HTTP(playerid, HTTP_GET, string, "", "HttpCallback_ShopIDCheck");
		}
	}
	#endif
	if(dialogid == DIALOG_SHOPERROR)
	{
		if(response)
		{
			ShowPlayerDialogEx(playerid, DIALOG_SHOPORDER, DIALOG_STYLE_INPUT, "Shop Order", "This is for shop orders from http://shop.ng-gaming.net\n\nIf you do not have a shop order then please cancel this dialog box now.\n\nWarning: Abuse of this feature may result to an indefinite block from this command.\n\nPlease enter your shop order ID (if you do not know it put 1):", "Submit", "Cancel" );
		}
	}
	if(dialogid == DIALOG_SHOPERROR2)
	{
		if(response)
		{
			ShowPlayerDialogEx(playerid, DIALOG_SHOPSENT, DIALOG_STYLE_INPUT, "Shop Order", "", "Submit", "Cancel" );
		}
	}
	if(dialogid == PMOTDNOTICE && 1 <= PlayerInfo[playerid][pDonateRank] <= 3 && (PlayerInfo[playerid][pVIPExpire] - 86400 < gettime()))
	{
		ShowPlayerDialogEx(playerid, VIP_EXPIRES, DIALOG_STYLE_MSGBOX, "VIP Expiration!", "Your VIP expires in less than a day - renew today at shop.ng-gaming.net!", "OK", "");
	}
	else if(dialogid == PMOTDNOTICE || dialogid == VIP_EXPIRES)
	{
		SetPVarInt(playerid, "ViewedPMOTD", 1);
		if(PlayerInfo[playerid][pReceivedCredits] != 0) ShowLoginDialogs(playerid, 5);
	}
	if(dialogid == DIALOG_LOADTRUCK)
	{
		if(response)
		{
			new iBusiness = ListItemTrackId[playerid][listitem];
			if (Businesses[iBusiness][bOrderState] != 1) {
				SendClientMessageEx(playerid, COLOR_WHITE, "That order cannot be taken anymore (either taken by another Shipment Contractor or the business has cancelled it)");
				return 1;
			}
			new iTruckModel = GetVehicleModel(GetPlayerVehicleID(playerid));
			if (iTruckModel != 443 && Businesses[iBusiness][bType] == BUSINESS_TYPE_NEWCARDEALERSHIP) {
				SendClientMessageEx(playerid, COLOR_WHITE, "You need to be driving a Packer in order to accept orders from car dealerships.");
				TogglePlayerControllable(playerid, 1);
				DeletePVar(playerid, "IsFrozen");
				return 1;
			}
			if (iTruckModel != 514 && Businesses[iBusiness][bType] == BUSINESS_TYPE_GASSTATION) {
				SendClientMessageEx(playerid, COLOR_WHITE, "You need to be driving a tank truck in order to accept orders from gas stations.");
				TogglePlayerControllable(playerid, 1);
				DeletePVar(playerid, "IsFrozen");
				return 1;
			}
			if ((iTruckModel == 443 || iTruckModel == 514) && Businesses[iBusiness][bType] != BUSINESS_TYPE_NEWCARDEALERSHIP && Businesses[iBusiness][bType] != BUSINESS_TYPE_GASSTATION)
			{
				SendClientMessageEx(playerid, COLOR_WHITE, "You need to be driving a regular truck (i.e not packer or tank truck) in order to accept orders from this type of business.");
				TogglePlayerControllable(playerid, 1);
				DeletePVar(playerid, "IsFrozen");
				return 1;
			}
			Businesses[iBusiness][bOrderState] = 2;
			TruckDeliveringTo[GetPlayerVehicleID(playerid)] = iBusiness;
			SaveBusiness(iBusiness);
			format(string,sizeof(string),"* Please wait a moment while the vehicle is being loaded with %s...", GetInventoryType(iBusiness));
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
			SetPVarInt(playerid, "LoadTruckTime", 10);
			SetTimerEx("LoadTruck", 1000, 0, "d", playerid);
		}
		else
		{
			DeletePVar(playerid, "IsFrozen");
			TogglePlayerControllable(playerid, 1);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You canceled the loading of the shipment, type /loadshipment to try again.");
		}
	}
	if((dialogid == BUYTOYSCOP) && response)
	{
		szMiscArray[0] = 0;
		new icount = GetPlayerToySlots(playerid);
		for(new x;x<icount;x++)
		{
			new name[24] = "None";

			for(new i;i<sizeof(HoldingObjectsAll);i++)
			{
				if(HoldingObjectsAll[i][holdingmodelid] == PlayerToyInfo[playerid][x][ptModelID])
				{
					format(name, sizeof(name), "%s", HoldingObjectsAll[i][holdingmodelname]);
				}
			}
			if(PlayerToyInfo[playerid][x][ptModelID] != 0 && (strcmp(name, "None", true) == 0))
			{
				format(name, sizeof(name), "ID: %d", PlayerToyInfo[playerid][x][ptModelID]);
			}
			format(szMiscArray, sizeof(szMiscArray), "%s(%d) %s (Bone: %s)\n", szMiscArray, x, name, HoldingBones[PlayerToyInfo[playerid][x][ptBone]]);
		}
		ShowPlayerDialogEx(playerid, BUYTOYSCOP2, DIALOG_STYLE_LIST, "Select a Slot", szMiscArray, "Select", "Cancel");
	}

	if((dialogid == BUYTOYSCOP2) && response)
	{
		/*
		if(listitem >= 5 && PlayerInfo[playerid][pDonateRank] < 1 || listitem >= 5 && PlayerInfo[playerid][pBuddyInvited] == 1) return SendClientMessageEx(playerid, COLOR_WHITE, "* You must be a Bronze VIP + to use that slot!");
		if(listitem >= 8 && PlayerInfo[playerid][pDonateRank] < 2) return SendClientMessageEx(playerid, COLOR_WHITE, "* You must be a Silver VIP + to use that slot!");
		if(listitem >= 9 && PlayerInfo[playerid][pDonateRank] < 3) return SendClientMessageEx(playerid, COLOR_WHITE, "* You must be a Gold VIP + to use that slot!");
		if(listitem >= 10 && PlayerInfo[playerid][pDonateRank] < 4) return SendClientMessageEx(playerid, COLOR_WHITE, "* You must be a Platinum VIP + to use that slot!");
		*/

		if(!toyCountCheck(playerid)) return SendClientMessageEx(playerid, COLOR_YELLOW, "* You cannot hold anymore toys.");

		if(PlayerToyInfo[playerid][listitem][ptModelID] != 0) return SendClientMessageEx(playerid, COLOR_YELLOW, "* You already have something in that slot. Delete it with /toys");

		SetPVarInt(playerid, "ToySlot", listitem);

		new stringg[1024];
		for(new x;x<sizeof(HoldingObjectsCop);x++)
		{
			format(stringg, sizeof(stringg), "%s%s ($%d)\n", stringg, HoldingObjectsCop[x][holdingmodelname], HoldingObjectsCop[x][holdingprice]);
		}
		ShowPlayerDialogEx(playerid, BUYTOYSCOP3, DIALOG_STYLE_LIST, "Select an Item", stringg, "Buy", "Cancel");
	}
	if((dialogid == BUYTOYSCOP3) && response)
	{
		if(GetPlayerCash(playerid) < HoldingObjectsCop[listitem][holdingprice])
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "* You can't afford that!");
		}
		else
		{
			GivePlayerCash(playerid, -HoldingObjectsCop[listitem][holdingprice]);
			PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptModelID] = HoldingObjectsCop[listitem][holdingmodelid];

			new modelid = PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptModelID];
			if((modelid >= 19006 && modelid <= 19035) || (modelid >= 19138 && modelid <= 19140))
			{
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = 2;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosX] = 0.9;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosZ] = 0.35;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotX] = 90.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotY] = 90.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotZ] = 0.0;
			}
			else if(modelid >= 18891 && modelid <= 18910)
			{
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = 2;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosX] = 0.15;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosZ] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotX] = 90.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotY] = 180.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotZ] = 90.0;
			}
			else if(modelid >= 18926 && modelid <= 18935)
			{
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = 2;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosX] = 0.1;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosZ] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotX] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotZ] = 0.0;
			}
			else if(modelid >= 18911 && modelid <= 18920)
			{
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = 2;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosX] = 0.1;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosY] = 0.035;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosZ] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotX] = 90.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotY] = 180.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotZ] = 90.0;
			}
			else if(modelid == 19078 || modelid == 19078)
			{
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = 16;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosX] = 0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosY] = 0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosZ] = 0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotX] = 180.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotY] = 180.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotZ] = 0.0;
			}
			else if((modelid >= 18641 && modelid <= 18644) || (modelid >= 19080 && modelid <= 19084) || modelid == 18890)
			{
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = 6;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosX] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosZ] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotX] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotZ] = 0.0;
			}
			else
			{
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = 2;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosX] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosZ] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotX] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotZ] = 0.0;
			}
			PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptScaleX] = 1.0;
			PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptScaleY] = 1.0;
			PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptScaleZ] = 1.0;
			PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptTradable] = 0;

			g_mysql_NewToy(playerid, GetPVarInt(playerid, "ToySlot"));

			format(string, sizeof(string), "* You have purchased %s for $%d (Slot: %d)", HoldingObjectsCop[listitem][holdingmodelname], HoldingObjectsCop[listitem][holdingprice], GetPVarInt(playerid, "ToySlot"));
			SendClientMessageEx(playerid, COLOR_RED, string);
			SendClientMessageEx(playerid, COLOR_WHITE, "HINT: Use /toys to wear/edit this");
		}
	}
	if((dialogid == BUYTOYSGOLD) && response)
	{
		if(PlayerInfo[playerid][pDonateRank] < 3) return SendClientMessageEx(playerid, COLOR_WHITE, "* You must be a Gold VIP +");
		new icount = GetPlayerToySlots(playerid);
		for(new x;x<icount;x++)
		{
			new name[24] = "None";

			for(new i;i<sizeof(HoldingObjectsAll);i++)
			{
				if(HoldingObjectsAll[i][holdingmodelid] == PlayerToyInfo[playerid][x][ptModelID])
				{
					format(name, sizeof(name), "%s", HoldingObjectsAll[i][holdingmodelname]);
				}
			}
			if(PlayerToyInfo[playerid][x][ptModelID] != 0 && (strcmp(name, "None", true) == 0))
			{
				format(name, sizeof(name), "ID: %d", PlayerToyInfo[playerid][x][ptModelID]);
			}
			format(szMiscArray, sizeof(szMiscArray), "%s(%d) %s (Bone: %s)\n", szMiscArray, x, name, HoldingBones[PlayerToyInfo[playerid][x][ptBone]]);
		}
		ShowPlayerDialogEx(playerid, BUYTOYSGOLD2, DIALOG_STYLE_LIST, "Select a Slot", szMiscArray, "Select", "Cancel");
	}

	if((dialogid == BUYTOYSGOLD2) && response)
	{
		if(PlayerInfo[playerid][pDonateRank] < 3) return SendClientMessageEx(playerid, COLOR_WHITE, "* You must be a Gold VIP +");

		if(!toyCountCheck(playerid)) return SendClientMessageEx(playerid, COLOR_YELLOW, "* You cannot hold anymore toys.");

		if(PlayerToyInfo[playerid][listitem][ptModelID] != 0) return SendClientMessageEx(playerid, COLOR_YELLOW, "* You already have something in that slot. Delete it with /toys");

		SetPVarInt(playerid, "ToySlot", listitem);

		for(new x;x<sizeof(HoldingObjectsAll);x++)
		{
			format(szMiscArray, sizeof(szMiscArray), "%s%s ($%d)\n", szMiscArray, HoldingObjectsAll[x][holdingmodelname], HoldingObjectsAll[x][holdingprice]);
		}
		ShowPlayerDialogEx(playerid, BUYTOYSGOLD3, DIALOG_STYLE_LIST, "Select an Item", szMiscArray, "Buy", "Cancel");
	}
	if((dialogid == BUYTOYSGOLD3) && response)
	{
		if(PlayerInfo[playerid][pDonateRank] < 3) return SendClientMessageEx(playerid, COLOR_WHITE, "* You must be a Gold VIP +");

		if(GetPlayerCash(playerid) < HoldingObjectsAll[listitem][holdingprice])
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "* You can't afford that!");
		}
		else
		{
			GivePlayerCash(playerid, -HoldingObjectsAll[listitem][holdingprice]);
			PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptModelID] = HoldingObjectsAll[listitem][holdingmodelid];

			new modelid = PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptModelID];
			if((modelid >= 19006 && modelid <= 19035) || (modelid >= 19138 && modelid <= 19140))
			{
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = 2;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosX] = 0.9;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosZ] = 0.35;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotX] = 90.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotY] = 90.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotZ] = 0.0;
			}
			else if(modelid >= 18891 && modelid <= 18910)
			{
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = 2;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosX] = 0.15;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosZ] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotX] = 90.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotY] = 180.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotZ] = 90.0;
			}
			else if(modelid >= 18926 && modelid <= 18935)
			{
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = 2;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosX] = 0.1;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosZ] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotX] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotZ] = 0.0;
			}
			else if(modelid >= 18911 && modelid <= 18920)
			{
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = 2;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosX] = 0.1;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosY] = 0.035;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosZ] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotX] = 90.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotY] = 180.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotZ] = 90.0;
			}
			else if(modelid == 19078 || modelid == 19078)
			{
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = 16;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosX] = 0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosY] = 0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosZ] = 0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotX] = 180.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotY] = 180.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotZ] = 0.0;
			}
			else if((modelid >= 18641 && modelid <= 18644) || (modelid >= 19080 && modelid <= 19084) || modelid == 18890)
			{
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = 6;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosX] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosZ] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotX] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotZ] = 0.0;
			}
			else
			{
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = 2;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosX] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosZ] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotX] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotZ] = 0.0;
			}
			PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptScaleX] = 1.0;
			PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptScaleY] = 1.0;
			PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptScaleZ] = 1.0;
			PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptTradable] = 0;

			g_mysql_NewToy(playerid, GetPVarInt(playerid, "ToySlot"));

			format(string, sizeof(string), "* You have purchased %s for $%d (Slot: %d)", HoldingObjectsAll[listitem][holdingmodelname], HoldingObjectsAll[listitem][holdingprice], GetPVarInt(playerid, "ToySlot"));
			SendClientMessageEx(playerid, COLOR_RED, string);
			SendClientMessageEx(playerid, COLOR_WHITE, "HINT: Use /toys to wear/edit this");

		}
	}
	if((dialogid == BUYTOYS) && response)
	{
		szMiscArray[0] = 0;
		new icount = GetPlayerToySlots(playerid);
		for(new x;x<icount;x++)
		{
			new name[24];
			format(name, sizeof(name), "None");

			for(new i;i<sizeof(HoldingObjectsAll);i++)
			{
				if(HoldingObjectsAll[i][holdingmodelid] == PlayerToyInfo[playerid][x][ptModelID])
				{
					format(name, sizeof(name), "%s", HoldingObjectsAll[i][holdingmodelname]);
				}
			}
			if(PlayerToyInfo[playerid][x][ptModelID] != 0 && (strcmp(name, "None", true) == 0))
			{
				format(name, sizeof(name), "ID: %d", PlayerToyInfo[playerid][x][ptModelID]);
			}
			format(szMiscArray, sizeof(szMiscArray), "%s(%d) %s (Bone: %s)\n", szMiscArray, x, name, HoldingBones[PlayerToyInfo[playerid][x][ptBone]]);
		}
		ShowPlayerDialogEx(playerid, BUYTOYS2, DIALOG_STYLE_LIST, "Select a Slot", szMiscArray, "Select", "Cancel");
	}
	if((dialogid == BUYTOYS2) && response)
	{
		/*
		if(listitem >= 5 + PlayerInfo[playerid][pToySlot] && PlayerInfo[playerid][pDonateRank] < 1 || listitem >= 5 + PlayerInfo[playerid][pToySlot] && PlayerInfo[playerid][pBuddyInvited] == 1) return SendClientMessageEx(playerid, COLOR_WHITE, "* You must be a Bronze VIP + to use that slot!");
		if(listitem >= 8 + PlayerInfo[playerid][pToySlot] && PlayerInfo[playerid][pDonateRank] < 2) return SendClientMessageEx(playerid, COLOR_WHITE, "* You must be a Silver VIP + to use that slot!");
		if(listitem >= 9 + PlayerInfo[playerid][pToySlot] && PlayerInfo[playerid][pDonateRank] < 3) return SendClientMessageEx(playerid, COLOR_WHITE, "* You must be a Gold VIP + to use that slot!");
		if(listitem >= 10 + PlayerInfo[playerid][pToySlot] && PlayerInfo[playerid][pDonateRank] < 4) return SendClientMessageEx(playerid, COLOR_WHITE, "* You must be a Platinum VIP + to use that slot!");
		*/

		if(!toyCountCheck(playerid)) return SendClientMessageEx(playerid, COLOR_YELLOW, "* You cannot hold anymore toys.");

		if(PlayerToyInfo[playerid][listitem][ptModelID] != 0) return SendClientMessageEx(playerid, COLOR_YELLOW, "* You already have something in that slot. Delete it with /toys");

		SetPVarInt(playerid, "ToySlot", listitem);

		new stringg[5000];
		for(new x;x<sizeof(HoldingObjects);x++)
		{
			format(stringg, sizeof(stringg), "%s%s ($%d)\n", stringg, HoldingObjects[x][holdingmodelname], HoldingObjects[x][holdingprice]);
		}
		ShowPlayerDialogEx(playerid, BUYTOYS3, DIALOG_STYLE_LIST, "Select an Item", stringg, "Buy", "Cancel");
	}
	if((dialogid == BUYTOYS3) && response)
	{
		if(GetPlayerCash(playerid) < HoldingObjects[listitem][holdingprice])
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "* You can't afford that!");
		}
		else
		{
			GivePlayerCash(playerid, -HoldingObjects[listitem][holdingprice]);
			PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptModelID] = HoldingObjects[listitem][holdingmodelid];

			new modelid = PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptModelID];
			if((modelid >= 19006 && modelid <= 19035) || (modelid >= 19138 && modelid <= 19140))
			{
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = 2;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosX] = 0.9;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosZ] = 0.35;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotX] = 90.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotY] = 90.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotZ] = 0.0;
			}
			else if(modelid >= 18891 && modelid <= 18910)
			{
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = 2;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosX] = 0.15;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosZ] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotX] = 90.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotY] = 180.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotZ] = 90.0;
			}
			else if(modelid >= 18926 && modelid <= 18935)
			{
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = 2;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosX] = 0.1;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosZ] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotX] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotZ] = 0.0;
			}
			else if(modelid >= 18911 && modelid <= 18920)
			{
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = 2;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosX] = 0.1;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosY] = 0.035;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosZ] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotX] = 90.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotY] = 180.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotZ] = 90.0;
			}
			else if(modelid == 19078 || modelid == 19078)
			{
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = 16;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosX] = 0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosY] = 0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosZ] = 0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotX] = 180.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotY] = 180.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotZ] = 0.0;
			}
			else if((modelid >= 18641 && modelid <= 18644) || (modelid >= 19080 && modelid <= 19084) || modelid == 18890)
			{
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = 6;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosX] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosZ] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotX] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotZ] = 0.0;
			}
			else
			{
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = 2;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosX] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosZ] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotX] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotZ] = 0.0;
			}
			PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptScaleX] = 1.0;
			PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptScaleY] = 1.0;
			PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptScaleZ] = 1.0;
			PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptTradable] = 1;

			g_mysql_NewToy(playerid, GetPVarInt(playerid, "ToySlot"));

			format(string, sizeof(string), "* You have purchased %s for $%d (Slot: %d)", HoldingObjects[listitem][holdingmodelname], HoldingObjects[listitem][holdingprice], GetPVarInt(playerid, "ToySlot"));
			SendClientMessageEx(playerid, COLOR_RED, string);
			SendClientMessageEx(playerid, COLOR_WHITE, "HINT: Use /toys to wear/edit this");
		}
	}
	if((dialogid == TOYS) && response)
	{
		szMiscArray[0] = 0;
		new icount = GetPlayerToySlots(playerid);
		for(new x;x<icount;x++)
		{
			new name[24];
			format(name, sizeof(name), "None");

			for(new i;i<sizeof(HoldingObjectsAll);i++)
			{
				if(HoldingObjectsAll[i][holdingmodelid] == PlayerToyInfo[playerid][x][ptModelID])
				{
					format(name, sizeof(name), "%s", HoldingObjectsAll[i][holdingmodelname]);
				}
			}
			if(PlayerToyInfo[playerid][x][ptModelID] != 0 && (strcmp(name, "None", true) == 0))
			{
				format(name, sizeof(name), "ID: %d", PlayerToyInfo[playerid][x][ptModelID]);
			}
			format(szMiscArray, sizeof(szMiscArray), "%s(%d) %s (Bone: %s)\n", szMiscArray, x+1, name, HoldingBones[PlayerToyInfo[playerid][x][ptBone]]); // x+1 Since the toys list starts of from 1( As players see it )
		}
		format(szMiscArray, sizeof(szMiscArray), "%s\n{40FFFF}Additional Toy Slot {FFD700}(Credits: %s){A9C4E4}", szMiscArray, number_format(ShopItems[28][sItemPrice]));
		switch(listitem) {
			case 0:
				ShowPlayerDialogEx(playerid, WEARTOY, DIALOG_STYLE_LIST, "Select a Toy", szMiscArray, "Select", "Cancel");
			case 1:
				ShowPlayerDialogEx(playerid, EDITTOYS, DIALOG_STYLE_LIST, "Select a Toy", szMiscArray, "Select", "Cancel");
			case 2:
				ShowPlayerDialogEx(playerid, DELETETOY, DIALOG_STYLE_LIST, "Select a Toy", szMiscArray, "Delete", "Cancel");
		}
	}

	if((dialogid == EDITTOYS) && response)
	{
		/*new toycount = GetFreeToySlot(playerid);
		if(toycount >= 10) return SendClientMessageEx(playerid, COLOR_GRAD1, "You currently have 10 objects attached, please deattach an object.");*/
		if(listitem >= GetPlayerToySlots(playerid))
		{
			new szstring[128];
			SetPVarInt(playerid, "MiscShop", 8);
			format(szstring, sizeof(szstring), "Additional Toy Slot\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[28][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[28][sItemPrice]));
			return ShowPlayerDialogEx(playerid, DIALOG_MISCSHOP2, DIALOG_STYLE_MSGBOX, "Additional Toy Slot", szstring, "Purchase", "Cancel");
		}
		else if(PlayerToyInfo[playerid][listitem][ptModelID] == 0 && listitem < GetPlayerToySlots(playerid))
		{
			ShowPlayerDialogEx(playerid, 0, DIALOG_STYLE_MSGBOX, "Edit your toy", "Woops! You don't have anything to edit in that slot.", "Okay", "");
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "{AA3333}HINT:{FFFF00} Position your camera differently to better see where your editing.");
			SetPVarInt(playerid, "ToySlot", listitem);
			ShowEditMenu(playerid);
		}
	}
	if((dialogid == EDITTOYS2)) {
		if(response) switch(listitem) {
			case 0: ShowPlayerDialogEx(playerid, EDITTOYSBONE, DIALOG_STYLE_LIST, "Select a Bone", "Spine\nHead\nLeft upper arm\nRight upper arm\nLeft hand\nRight hand\nLeft thigh\nRight thigh\nLeft foot\nRight foot\nRight calf\nLeft calf\nLeft forearm\nRight forearm\nLeft clavicle\nRight clavicle\nNeck\nJaw", "Select", "Cancel");
			case 1:
			{
				for(new i; i < 10; i++)
				{
					if(PlayerHoldingObject[playerid][i] == GetPVarInt(playerid, "ToySlot"))
					{
						EditAttachedObject(playerid, i);
						break;
					}
				}
				SendClientMessage(playerid, COLOR_WHITE, "HINT: Hold {8000FF}~k~~PED_SPRINT~ {FFFFAA}to move your camera, press escape to cancel");
			}
			case 2:
			{
				new szstring[128];
				if(PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptAutoAttach] == -2) format(szstring, sizeof(szstring), "Select an auto-attach option (Currently Disabled)");
				else if(PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptAutoAttach] == -1) format(szstring, sizeof(szstring), "Select an auto-attach option (Currently: All Skins)");
				else format(szstring, sizeof(szstring), "Select an auto-attach option (Currently: Skin %d)", GetPlayerSkin(playerid));
				ShowPlayerDialogEx(playerid, EDITTOYSAUTOATTACH, DIALOG_STYLE_LIST, szstring, "Attach to any skin\nAttach to current skin\nDisable auto-attachment", "Select", "Cancel");
			}
		}
		else
		{
			szMiscArray[0] = 0;
			new icount = GetPlayerToySlots(playerid);
			if(PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptSpecial] == 2) for(new i; i < 10; i++) {
				if(PlayerHoldingObject[playerid][i] == GetPVarInt(playerid, "ToySlot")) {
					PlayerHoldingObject[playerid][i] = 0;
					RemovePlayerAttachedObject(playerid, i);
					SendClientMessageEx(playerid, COLOR_GRAD1, "You may only wear this toy with /helmet.");
					break;
				}
			}
			for(new x;x<icount;x++)
			{
				new name[24];
				format(name, sizeof(name), "None");

				for(new i;i<sizeof(HoldingObjectsAll);i++)
				{
					if(HoldingObjectsAll[i][holdingmodelid] == PlayerToyInfo[playerid][x][ptModelID])
					{
						format(name, sizeof(name), "%s", HoldingObjectsAll[i][holdingmodelname]);
					}
				}
				if(PlayerToyInfo[playerid][x][ptModelID] != 0 && (strcmp(name, "None", true) == 0))
				{
					format(name, sizeof(name), "ID: %d", PlayerToyInfo[playerid][x][ptModelID]);
				}
				format(szMiscArray, sizeof(szMiscArray), "%s(%d) %s (Bone: %s)\n", szMiscArray, x+1, name, HoldingBones[PlayerToyInfo[playerid][x][ptBone]]); // x+1 since toys list starts off from 1 (From players view)
			}
			format(szMiscArray, sizeof(szMiscArray), "%s\n{40FFFF}Additional Toy Slot {FFD700}(Credits: %s){A9C4E4}", szMiscArray, number_format(ShopItems[28][sItemPrice]));
			ShowPlayerDialogEx(playerid, EDITTOYS, DIALOG_STYLE_LIST, "Select a Toy", szMiscArray, "Select", "Cancel");
		}
	}
	if(dialogid == EDITTOYSBONE)
	{
		if(response)
		{
			if(PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptSpecial] == 2)
				SendClientMessageEx(playerid, COLOR_GRAD2, "This toy is limited to be attached to the head only.");
			else {
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = listitem+1;
				g_mysql_SaveToys(playerid,GetPVarInt(playerid, "ToySlot"));
			}
		}
		ShowEditMenu(playerid);
	}
	if(dialogid == EDITTOYSAUTOATTACH)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptAutoAttach] = -1;
					g_mysql_SaveToys(playerid,GetPVarInt(playerid, "ToySlot"));
				}
				case 1:
				{
					PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptAutoAttach] = GetPlayerSkin(playerid);
					g_mysql_SaveToys(playerid,GetPVarInt(playerid, "ToySlot"));
				}
				case 2:
				{
					PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptAutoAttach] = -2;
					g_mysql_SaveToys(playerid,GetPVarInt(playerid, "ToySlot"));
				}
			}
		}
		ShowEditMenu(playerid);
	}
	if(dialogid == SELLTOY)
	{
		if(response)
		{
			new buyerid = GetPVarInt(playerid, "ttBuyer"),
				cost = GetPVarInt(playerid, "ttCost");
			if(PlayerToyInfo[playerid][listitem][ptModelID] == 0) {
				DeletePVar(buyerid, "ttSeller");
				DeletePVar(playerid, "ttCost");
				DeletePVar(playerid, "ttBuyer");
				ShowPlayerDialogEx(playerid, 0, DIALOG_STYLE_MSGBOX, "Sell your toy", "Woops! You don't have anything to sell from that slot.", "Okay", "");
			}
			if(PlayerToyInfo[playerid][listitem][ptTradable] == 0) {
				SendClientMessageEx(playerid, COLOR_GREY, "This toy isn't tradable.");
				DeletePVar(buyerid, "ttSeller");
				DeletePVar(playerid, "ttCost");
				return DeletePVar(playerid, "ttBuyer");
			}
			if(!IsPlayerAttachedObjectSlotUsed(playerid, listitem))
			{
				new szmessage[128], name[24],
					toyid = PlayerToyInfo[playerid][listitem][ptModelID];
				format(name, sizeof(name), "None");
				for(new i;i<sizeof(HoldingObjectsAll);i++)
				{
					if(HoldingObjectsAll[i][holdingmodelid] == toyid)
					{
						format(name, sizeof(name), "(%s)", HoldingObjectsAll[i][holdingmodelname]);
					}
				}
				if(PlayerToyInfo[playerid][listitem][ptModelID] != 0 && (strcmp(name, "None", true) == 0))
				{
					format(name, sizeof(name), "(ID: %d)", toyid);
				}
				format(szmessage, sizeof(szmessage), "You have offered %s to purchase your toy. %s", GetPlayerNameEx(buyerid), name);
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szmessage);
				SetPVarInt(playerid, "ttToy", toyid);
				SetPVarInt(playerid, "ttToySlot", listitem);
				PrepTradeToysGUI(buyerid, playerid, cost, toyid);
			}
			else {
				SendClientMessageEx(playerid, COLOR_GREY, "You currently have this toy attached, please deattach it and try again.");
				DeletePVar(buyerid, "ttSeller");
				DeletePVar(playerid, "ttCost");
				DeletePVar(playerid, "ttSeller");
			}
		}
		else
		{
			SetPVarInt(playerid, "ttSeller", INVALID_PLAYER_ID);
			SetPVarInt(playerid, "ttCost", 0);
			SetPVarInt(playerid, "ttSeller", INVALID_PLAYER_ID);
		}
	}
	if(dialogid == CONFIRMSELLTOY)
	{
		if(response) {
			CompleteToyTrade(playerid);
		}
		else {

			format(szMiscArray, sizeof(szMiscArray), "%s has declined the toy offer.", GetPlayerNameEx(playerid));
			SendClientMessageEx(GetPVarInt(playerid, "ttSeller"), COLOR_GREY, szMiscArray);
			SendClientMessageEx(playerid, COLOR_GREY, "You have declined the toy offer.");
			DeletePVar(GetPVarInt(playerid, "ttSeller"), "ttBuyer");
			DeletePVar(GetPVarInt(playerid, "ttSeller"), "ttCost");
			DeletePVar(playerid, "ttSeller");

			HideTradeToysGUI(playerid);
		}
	}
	if((dialogid == WEARTOY) && response)
	{
		//if(PlayerToyInfo[playerid][listitem][ptModelID] == 0)
		if(listitem >= GetPlayerToySlots(playerid))
		{
			SetPVarInt(playerid, "MiscShop", 8);
			format(szMiscArray, sizeof(szMiscArray), "Additional Toy Slot\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[28][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[28][sItemPrice]));
			return ShowPlayerDialogEx(playerid, DIALOG_MISCSHOP2, DIALOG_STYLE_MSGBOX, "Additional Toy Slot", szMiscArray, "Purchase", "Cancel");
		}
		else if(PlayerToyInfo[playerid][listitem][ptModelID] == 0 && listitem < GetPlayerToySlots(playerid))
		{
			ShowPlayerDialogEx(playerid, 0, DIALOG_STYLE_MSGBOX, "Wear your toy", "Woops! You don't have anything to wear from that slot.", "Okay", "");
		}
		else if(PlayerToyInfo[playerid][listitem][ptSpecial] == 2)
		{
			ShowPlayerDialogEx(playerid, 0, DIALOG_STYLE_MSGBOX, "Wear your toy", "You may only wear this toy with /helmet.", "Okay", "");
		}
		else
		{
			new toys = 99999;
			for(new i; i < 10; i++)
			{
				if(PlayerHoldingObject[playerid][i] == listitem)
				{
					toys = i;
					break;
				}
			}
			if(IsPlayerAttachedObjectSlotUsed(playerid, toys))
			{
				new name[24];
				format(name, sizeof(name), "None");

				for(new i;i<sizeof(HoldingObjectsAll);i++)
				{
					if(HoldingObjectsAll[i][holdingmodelid] == PlayerToyInfo[playerid][listitem][ptModelID])
					{
						format(name, sizeof(name), "%s", HoldingObjectsAll[i][holdingmodelname]);
					}
				}
				format(string, sizeof(string), "Successfully dettached %s (Bone: %s) (Slot: %d)", name, HoldingBones[PlayerToyInfo[playerid][listitem][ptBone]], listitem);
				SendClientMessageEx(playerid, COLOR_RED, string);
				RemovePlayerAttachedObject(playerid, toys);
				for(new i; i < 10; i++)
				{
					if(PlayerHoldingObject[playerid][i] == listitem)
					{
						PlayerHoldingObject[playerid][i] = 0;
						break;
					}
				}
			}
			else AttachToy(playerid, listitem);
		}
	}

	if((dialogid == DELETETOY) && response)
	{
		new toys = 99999;
		for(new i; i < 10; i++)
		{
			if(PlayerHoldingObject[playerid][i] == listitem)
			{
				toys = i;
				if(IsPlayerAttachedObjectSlotUsed(playerid, toys))
				{
					PlayerHoldingObject[playerid][i] = 0;
					RemovePlayerAttachedObject(playerid, toys);
				}
				break;
			}
		}

		new szQuery[128];
		mysql_format(MainPipeline, szQuery, sizeof(szQuery), "DELETE FROM `toys` WHERE `id` = '%d'", PlayerToyInfo[playerid][listitem][ptID]);
		mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
		PlayerToyInfo[playerid][listitem][ptID] = 0;
		PlayerToyInfo[playerid][listitem][ptModelID] = 0;
		PlayerToyInfo[playerid][listitem][ptBone] = 0;
		if(PlayerToyInfo[playerid][listitem][ptSpecial] != 0)
		{
			PlayerToyInfo[playerid][listitem][ptSpecial] = 0;
		}

		format(string, sizeof(string), "You have deleted your toy in slot %d.", listitem);
		ShowPlayerDialogEx(playerid, 0, DIALOG_STYLE_MSGBOX, "Toy Menu", string, "OK", "");
	}

	if((dialogid == LAELEVATORPASS) && response)
	{
		listitem = GetPVarInt(playerid, "ElevatorFloorPick");
		if(FloorRequestedBy[listitem] != INVALID_PLAYER_ID || IsFloorInQueue(listitem))
			GameTextForPlayer(playerid, "~r~The floor is already in the queue", 3500, 4);
		else if(DidPlayerRequestElevator(playerid))
			GameTextForPlayer(playerid, "~r~You already requested the elevator", 3500, 4);
		else
		{
			if(strfind(inputtext, "hats", true) == 0 && IsAHitman(playerid))
			{
				CallElevator(playerid, 20);
			}
			else if(strfind(inputtext, LAElevatorFloorData[1][listitem], true) == 0)
			{
				CallElevator(playerid, listitem);
			}
			else
			{
				GameTextForPlayer(playerid, "~r~Invalid Password", 3500, 4);
			}
		}
	}
	if((dialogid == LAELEVATOR) && response)
	{
		if(FloorRequestedBy[listitem] != INVALID_PLAYER_ID || IsFloorInQueue(listitem))
			GameTextForPlayer(playerid, "~r~The floor is already in the queue", 3500, 4);
		else if(DidPlayerRequestElevator(playerid))
			GameTextForPlayer(playerid, "~r~You already requested the elevator", 3500, 4);
		else
		{
			if(strlen(LAElevatorFloorData[1][listitem]) > 0)
			{
				SetPVarInt(playerid, "ElevatorFloorPick", listitem);
				ShowPlayerDialogEx(playerid, LAELEVATORPASS, DIALOG_STYLE_INPUT, "Elevator", "Enter the password for this level", "Enter", "Cancel");
			}
			else
			{
				CallElevator(playerid, listitem);
			}
		}
		return 1;
	}
	if((dialogid == AUDIO_URL) && response) // /audiourl
	{
		if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1)
		{
			new range = GetPVarInt(playerid, "aURLrange");
			new Float:aX, Float:aY, Float:aZ;
			GetPlayerPos(playerid, aX, aY, aZ);
			//SendAudioURLToRange(inputtext,aX,aY,aZ,range);
			format(audiourlurl, sizeof(audiourlurl), "%s", inputtext);
			SetGVarInt("MusicArea", CreateDynamicSphere(aX, aY, aZ, range, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid)));


			if(range > 100)
			{
				format(string,sizeof(string),"{AA3333}AdmWarning{FFFF00}: %s has placed url %s - Range: %d.",GetPlayerNameEx(playerid),inputtext,range);
				ABroadCast(COLOR_YELLOW, string, 4);
				format(string, sizeof(string),"Use /audiostopurl to stop playback");
				SendClientMessage(playerid, COLOR_YELLOW, string);
			}
			else
			{
				format(string,sizeof(string),"You have placed url %s - Range: %d",inputtext,range);
				SendClientMessage(playerid, COLOR_YELLOW, string);
				format(string, sizeof(string),"Use /audiostopurl to stop playback");
				SendClientMessage(playerid, COLOR_YELLOW, string);
			}
		}
	}

	/*if(dialogid == DIALOG_NUMBER_PLATE_CHOSEN) {
		if(response == 1) {
			for(new i = 0; i < MAX_PLAYERVEHICLES; i++) {
				if(listitem == i) {
					if(PlayerInfo[playerid][pDonateRank] > 0) {
						new
							tmpSz_NumPlate[32];

						GetPVarString(playerid, "szNumPS", tmpSz_NumPlate, sizeof(tmpSz_NumPlate));
						RegisterVehicleNumberPlate(PlayerVehicleInfo[playerid][i][pvId], tmpSz_NumPlate);
						SetPVarInt(playerid, "Cash", PlayerInfo[playerid][pCash]-80000);
						strcpy(PlayerVehicleInfo[playerid][i][pvNumberPlate], tmpSz_NumPlate, 32);
						SendClientMessageEx(playerid, COLOR_WHITE, "Your registration plate has successfully been configured.");
					}
					else {
						new
							tmpSz_NumPlate[32];

						GetPVarString(playerid, "szNumPS", tmpSz_NumPlate, sizeof(tmpSz_NumPlate));
						RegisterVehicleNumberPlate(PlayerVehicleInfo[playerid][i][pvId], tmpSz_NumPlate);
						strcpy(PlayerVehicleInfo[playerid][i][pvNumberPlate], tmpSz_NumPlate, 32);
						SetPVarInt(playerid, "Cash", PlayerInfo[playerid][pCash]-100000);
						SendClientMessageEx(playerid, COLOR_WHITE, "Your registration plate has successfully been configured.");
					}

					return 1;
				}
			}
		}
	}*/

	if(dialogid == DIALOG_NUMBER_PLATE) {
		if(response) {
			if(strlen(inputtext) < 1 || strlen(inputtext) > 8) {
				SendClientMessageEx(playerid, COLOR_WHITE, "{AA3333}ERROR:{FFFF00} You can only have a number plate that consists of 1-8 characters.");
			}
			else {
				if(strfind("XMT", inputtext, true) != -1) {
					SendClientMessageEx(playerid, COLOR_WHITE, "{AA3333}ERROR:{FFFF00} You cannot use the term \"XMT\" in your registration plate.");
					return 1;
				}

				SetPVarString(playerid, "szNumPS", inputtext);

				new
					vstring[1024]; // ew, another 4096 bytes of memory down the drain

				for(new i = 0; i < MAX_PLAYERVEHICLES; i++)
				{
					if(PlayerVehicleInfo[playerid][i][pvId] != INVALID_PLAYER_VEHICLE_ID)
					{
						format(vstring, sizeof(vstring), "%s\n%s", vstring, GetVehicleName(PlayerVehicleInfo[playerid][i][pvId]));
					}
					else
					{
						format(vstring, sizeof(vstring), "%s\nEmpty", vstring);
					}
				}

				ShowPlayerDialogEx(playerid, DIALOG_NUMBER_PLATE_CHOSEN, DIALOG_STYLE_LIST, "Registration plate selection", vstring, "Select", "Cancel");
			}
		}

		/*if(PlayerInfo[playerid][pDonateRank] > 0) {
			PlayerInfo[playerid][pMoney] -= 80000;
			SendClientMessageEx(playerid, COLOR_WHITE, "Your new number plate has been configured!");
			RegisterVehicleNumberPlate();
		}
		else {
			PlayerInfo[playerid][pMoney] -= 100000;
			SendClientMessageEx(playerid, COLOR_WHITE, "Your new number plate has been configured!");
			RegisterVehicleNumberPlate();
		}*/
	}
	if(dialogid == NMUTE)
	{
		if(response == 1)
		{
			switch(listitem)
			{
				case 0: // Jailtime
				{
					if(PlayerInfo[playerid][pNMuteTotal] < 4)
					{
						if(GetPVarType(playerid, "IsInArena"))
						{
							LeavePaintballArena(playerid, GetPVarInt(playerid, "IsInArena"));
						}
						PlayerInfo[playerid][pNMute] = 0;
						ResetPlayerWeaponsEx(playerid);
						PlayerInfo[playerid][pJailTime] += PlayerInfo[playerid][pNMuteTotal]*15*60;
						strcpy(PlayerInfo[playerid][pPrisonReason], "[OOC] NMute Prison", 128);
						PhoneOnline[playerid] = 1;
						SetPlayerInterior(playerid, 1);
						PlayerInfo[playerid][pInt] = 1;
						new rand = random(sizeof(OOCPrisonSpawns));
						Streamer_UpdateEx(playerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2]);
						SetPlayerPos(playerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2]);
						SetPlayerSkin(playerid, 50);
						SetPlayerColor(playerid, TEAM_APRISON_COLOR);
						Player_StreamPrep(playerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2], FREEZE_TIME);
					}
					else if(PlayerInfo[playerid][pNMuteTotal] >= 4 || PlayerInfo[playerid][pNMuteTotal] < 7)
					{
						if(GetPVarType(playerid, "IsInArena"))
						{
							LeavePaintballArena(playerid, GetPVarInt(playerid, "IsInArena"));
						}
						PlayerInfo[playerid][pNMute] = 0;
						GameTextForPlayer(playerid, "~w~Welcome to ~n~~r~Fort DeMorgan", 5000, 3);
						ResetPlayerWeaponsEx(playerid);
						PlayerInfo[playerid][pJailTime] += PlayerInfo[playerid][pNMuteTotal]*15*60;
						PhoneOnline[playerid] = 1;
						SetPlayerInterior(playerid, 1);
						PlayerInfo[playerid][pInt] = 1;
						new rand = random(sizeof(OOCPrisonSpawns));
						Streamer_UpdateEx(playerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2]);
						SetPlayerPos(playerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2]);
						SetPlayerSkin(playerid, 50);
						SetPlayerColor(playerid, TEAM_APRISON_COLOR);
						Player_StreamPrep(playerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2], FREEZE_TIME);
					}
					strcpy(PlayerInfo[playerid][pPrisonReason], "[OOC][NEWB-UNMUTE]", 128);
					format(string,sizeof(string),"{AA3333}AdmWarning{FFFF00}: %s is serving %d Minutes in Jail/Prison for Newbie Unmute.",GetPlayerNameEx(playerid),PlayerInfo[playerid][pNMuteTotal]*15);
					ABroadCast(COLOR_YELLOW,string,2);
				}
				case 1: // Fine
				{
					new playername[MAX_PLAYER_NAME];
					GetPlayerName(playerid, playername, sizeof(playername));

					new totalwealth = PlayerInfo[playerid][pAccount] + GetPlayerCash(playerid);
					if(PlayerInfo[playerid][pPhousekey] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[playerid][pPhousekey]][hOwnerID] == GetPlayerSQLId(playerid)) totalwealth += HouseInfo[PlayerInfo[playerid][pPhousekey]][hSafeMoney];
					if(PlayerInfo[playerid][pPhousekey2] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[playerid][pPhousekey2]][hOwnerID] == GetPlayerSQLId(playerid)) totalwealth += HouseInfo[PlayerInfo[playerid][pPhousekey2]][hSafeMoney];
					if(PlayerInfo[playerid][pPhousekey3] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[playerid][pPhousekey3]][hOwnerID] == GetPlayerSQLId(playerid)) totalwealth += HouseInfo[PlayerInfo[playerid][pPhousekey3]][hSafeMoney];

					new fine = 10 * totalwealth / 100;
					if(GetPlayerCash(playerid) < fine || totalwealth < 0)
					{
						format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s has declined the Newbie Unmute (Insufficient Funds).", GetPlayerNameEx(playerid));
						ABroadCast(COLOR_YELLOW, string, 2);
						return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot afford an unmute!");
					}

					format(string,sizeof(string),"{AA3333}AdmWarning{FFFF00}: %s has paid a $%d fine for Newbie Chat Unmute.",GetPlayerNameEx(playerid),fine);
					GivePlayerCash(playerid,-fine);
					ABroadCast(COLOR_YELLOW,string,2);
					PlayerInfo[playerid][pNMute] = 0;
				}
			}
		}
		else
		{
			format(string,sizeof(string),"{AA3333}AdmWarning{FFFF00}: %s has canceled punishment for Newbie Chat Unmute.",GetPlayerNameEx(playerid));
			ABroadCast(COLOR_YELLOW,string,2);
		}
	}
	if(dialogid == ADMUTE)
	{
		if(response == 1)
		{
			switch(listitem)
			{
				case 0: // Jailtime
				{
					if(PlayerInfo[playerid][pADMuteTotal] < 4)
					{
						if(GetPVarType(playerid, "IsInArena"))
						{
							LeavePaintballArena(playerid, GetPVarInt(playerid, "IsInArena"));
						}
						PlayerInfo[playerid][pADMute] = 0;
						ResetPlayerWeaponsEx(playerid);
						PlayerInfo[playerid][pJailTime] += PlayerInfo[playerid][pADMuteTotal]*15*60;
						PhoneOnline[playerid] = 1;
						SetPlayerInterior(playerid, 1);
						PlayerInfo[playerid][pInt] = 1;
						new rand = random(sizeof(OOCPrisonSpawns));
						Streamer_UpdateEx(playerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2]);
						SetPlayerPos(playerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2]);
						SetPlayerSkin(playerid, 50);
						SetPlayerColor(playerid, TEAM_APRISON_COLOR);
						Player_StreamPrep(playerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2], FREEZE_TIME);
					}
					else if(PlayerInfo[playerid][pADMuteTotal] >= 4 || PlayerInfo[playerid][pADMuteTotal] < 7)
					{
						if(GetPVarType(playerid, "IsInArena"))
						{
							LeavePaintballArena(playerid, GetPVarInt(playerid, "IsInArena"));
						}
						PlayerInfo[playerid][pADMute] = 0;
						GameTextForPlayer(playerid, "~w~Welcome to ~n~~r~Fort DeMorgan", 5000, 3);
						ResetPlayerWeaponsEx(playerid);
						PlayerInfo[playerid][pJailTime] += PlayerInfo[playerid][pADMuteTotal]*15*60;
						PhoneOnline[playerid] = 1;
						SetPlayerInterior(playerid, 1);
						PlayerInfo[playerid][pInt] = 1;
						new rand = random(sizeof(OOCPrisonSpawns));
						Streamer_UpdateEx(playerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2]);
						SetPlayerPos(playerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2]);
						SetPlayerSkin(playerid, 50);
						SetPlayerColor(playerid, TEAM_APRISON_COLOR);
						Player_StreamPrep(playerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2], FREEZE_TIME);
					}
					strcpy(PlayerInfo[playerid][pPrisonReason], "[OOC][AD-UNMUTE]", 128);
					format(string,sizeof(string),"{AA3333}AdmWarning{FFFF00}: %s is serving %d Minutes in Jail/Prison for Advertisement Unmute.",GetPlayerNameEx(playerid),PlayerInfo[playerid][pADMuteTotal]*15);
					ABroadCast(COLOR_YELLOW,string,2);
				}
				case 1: // Fine
				{
					new playername[MAX_PLAYER_NAME];
					GetPlayerName(playerid, playername, sizeof(playername));

					new totalwealth = PlayerInfo[playerid][pAccount] + GetPlayerCash(playerid);
					if(PlayerInfo[playerid][pPhousekey] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[playerid][pPhousekey]][hOwnerID] == GetPlayerSQLId(playerid)) totalwealth += HouseInfo[PlayerInfo[playerid][pPhousekey]][hSafeMoney];
					if(PlayerInfo[playerid][pPhousekey2] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[playerid][pPhousekey2]][hOwnerID] == GetPlayerSQLId(playerid)) totalwealth += HouseInfo[PlayerInfo[playerid][pPhousekey2]][hSafeMoney];
					if(PlayerInfo[playerid][pPhousekey3] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[playerid][pPhousekey3]][hOwnerID] == GetPlayerSQLId(playerid)) totalwealth += HouseInfo[PlayerInfo[playerid][pPhousekey3]][hSafeMoney];

					new fine = 10 * totalwealth / 100;
					if(GetPlayerCash(playerid) < fine)
					{
						format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s has declined the Advertisement Unmute (Insufficient Funds).", GetPlayerNameEx(playerid));
						ABroadCast(COLOR_YELLOW, string, 2);
						return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot afford an unmute!");
					}

					PlayerInfo[playerid][pADMute] = 0;
					format(string,sizeof(string),"{AA3333}AdmWarning{FFFF00}: %s has paid a $%d fine for Advertisement Unmute.",GetPlayerNameEx(playerid),fine);
					GivePlayerCash(playerid,-fine);
					ABroadCast(COLOR_YELLOW,string,2);
				}
			}
		}
		else
		{
			format(string,sizeof(string),"{AA3333}AdmWarning{FFFF00}: %s has canceled punishment for Advertisement Unmute.",GetPlayerNameEx(playerid));
			ABroadCast(COLOR_YELLOW,string,2);
		}
	}
	if(dialogid == RTONEMENU) // Ringtone Menu
	{
		if(response == 1)
		{
			switch(listitem)
			{
				case 0:
				{
					PlayerInfo[playerid][pRingtone] = 1;
					//SendAudioToPlayer(playerid, 51, 100);
				}
				case 1:
				{
					PlayerInfo[playerid][pRingtone] = 2;
					//SendAudioToPlayer(playerid, 52, 100);
				}
				case 2:
				{
					PlayerInfo[playerid][pRingtone] = 3;
					//SendAudioToPlayer(playerid, 53, 100);
				}
				case 3:
				{
					PlayerInfo[playerid][pRingtone] = 4;
					//SendAudioToPlayer(playerid, 54, 100);
				}
				case 4:
				{
					PlayerInfo[playerid][pRingtone] = 5;
					//SendAudioToPlayer(playerid, 55, 100);
				}
				case 5:
				{
					PlayerInfo[playerid][pRingtone] = 6;
					//SendAudioToPlayer(playerid, 56, 100);
				}
				case 6:
				{
					PlayerInfo[playerid][pRingtone] = 7;
					//SendAudioToPlayer(playerid, 57, 100);
				}
				case 7:
				{
					PlayerInfo[playerid][pRingtone] = 8;
					//SendAudioToPlayer(playerid, 58, 100);
				}
				case 8:
				{
					PlayerInfo[playerid][pRingtone] = 9;
					//SendAudioToPlayer(playerid, 59, 100);
				}
				case 9:
				{
					PlayerInfo[playerid][pRingtone] = 0;
				}
			}
			RemovePlayerAttachedObject(playerid, 8);
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
		}
	}
	if(dialogid == MAINMENU || dialogid == MAINMENU2)
	{
		if(response == 0)
		{
			SendClientMessage(playerid, COLOR_RED, "SERVER: You have been kicked out automatically.");
			SetTimerEx("KickEx", 1000, 0, "i", playerid);
		}
		else if(dialogid == MAINMENU)
		{
			if(!isnull(inputtext) && strlen(inputtext) <= 64 && gPlayerLogged{playerid} == 0)
			{
				SetPVarString(playerid, "PassAuth", inputtext);
				g_mysql_AccountLoginCheck(playerid);
			}
			else
			{
				ShowMainMenuDialog(playerid, 1);
			}
		}
		else if(dialogid == MAINMENU2)
		{
			if(PassComplexCheck && CheckPasswordComplexity(inputtext) != 1) return ShowMainMenuDialog(playerid, 2);
			if(!isnull(inputtext) && strlen(inputtext) <= 64)
			{
				SetPVarString(playerid, "PassAuth", inputtext);
				g_mysql_CreateAccount(playerid, inputtext);
			}
			else ShowMainMenuDialog(playerid, 2);
		}
		return 1;
	}
	if(dialogid == MAINMENU3)
	{
		Kick(playerid);
	}
	if (dialogid == ELEVATOR3 && response)
	{
		if (listitem == 0)
		{
			SetPlayerPos(playerid, 1564.8, -1666.2, 28.3);
			SetPlayerInterior(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;
			SetPlayerVirtualWorld(playerid, 0);
		}
		else
		{
			SetPlayerPos(playerid, 1568.6676, -1689.9708, 6.2188);
			SetPlayerInterior(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;
			SetPlayerVirtualWorld(playerid, 0);
		}
	}
	if (dialogid == ELEVATOR && response)
	{
		if (listitem == 0)
		{
			SetPlayerPos(playerid, 276.0980, 122.1232, 1004.6172);
			SetPlayerInterior(playerid, 10);
			PlayerInfo[playerid][pVW] = 133337;
			SetPlayerVirtualWorld(playerid, 133337);
		}
		else
		{
			SetPlayerPos(playerid, 1568.6676, -1689.9708, 6.2188);
			SetPlayerInterior(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;
			SetPlayerVirtualWorld(playerid, 0);
		}
	}
	if (dialogid == ELEVATOR2 && response)
	{
		if (listitem == 0)
		{
			SetPlayerPos(playerid, 1564.8, -1666.2, 28.3);
			SetPlayerInterior(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;
			SetPlayerVirtualWorld(playerid, 0);
		}
		else
		{
			SetPlayerPos(playerid, 276.0980, 122.1232, 1004.6172);
			SetPlayerInterior(playerid, 10);
			PlayerInfo[playerid][pVW] = 133337;
			SetPlayerVirtualWorld(playerid, 133337);
		}
	}
	if(dialogid == VIPNUMMENU)
	{
		if(response)
		{
			new numberstr = -abs(strval(inputtext));
			if(!(1 < strlen(inputtext) < 9) || strval(inputtext) == 0) { return ShowPlayerDialogEx(playerid, VIPNUMMENU, DIALOG_STYLE_INPUT, "Error", "The phone number can only be between 2 and 8 digits long. Please input a new number below", "Submit", "Cancel"); }

			new query[128];
			new numb[16];
			format(numb, sizeof(numb), "%d", numberstr);
			new checkmon = GetPlayerCash(playerid);
			if(PlayerInfo[playerid][pPnumber] == numberstr)
			{
				SendClientMessageEx(playerid,COLOR_GREY," Cannot change to your existing number");
				return 1;
			}
			if(strlen(numb) == 2) return ShowPlayerDialogEx(playerid, VIPNUMMENU, DIALOG_STYLE_INPUT, "Error", "The phone number can only be between 2 and 10 digits long. Please input a new number below", "Submit", "Cancel");
			if(strlen(numb) == 3)
			{
				new iCheck = abs(checkmon * 30/100);
				if(GetPlayerCash(playerid) <= iCheck)
			   	{
			   		SendClientMessageEx(playerid, COLOR_WHITE, "You don't have enough money for the phone number!");
			   		return 1;
			   	}
				if(GetPlayerCash(playerid) >= 1000000)
				{
					SetPVarInt(playerid, "WantedPh", numberstr);
					SetPVarInt(playerid, "CurrentPh", PlayerInfo[playerid][pPnumber]);
					SetPVarInt(playerid, "PhChangeCost", iCheck);
					mysql_format(MainPipeline, query, sizeof(query), "SELECT `Username` FROM `accounts` WHERE `PhoneNr` = '%d'", numberstr);
					mysql_tquery(MainPipeline, query, "OnPhoneNumberCheck", "ii", playerid, 1);
					return 1;
				}
				else if(GetPlayerCash(playerid) >= 300000 && GetPlayerCash(playerid) < 1000000)
				{
					SetPVarInt(playerid, "WantedPh", numberstr);
					SetPVarInt(playerid, "CurrentPh", PlayerInfo[playerid][pPnumber]);
					SetPVarInt(playerid, "PhChangeCost", 300000);
					mysql_format(MainPipeline, query, sizeof(query), "SELECT `Username` FROM `accounts` WHERE `PhoneNr` = '%d'",numberstr);
					mysql_tquery(MainPipeline, query, "OnPhoneNumberCheck", "ii", playerid, 1);
					return 1;
				}
				else
				{
					SendClientMessageEx(playerid,COLOR_GREY," You do not have enough money to purchase a negative 2 digit number, try again.");
					return 1;
				}
			}
			else if(strlen(numb) == 4)
			{
				new iCheck = abs(checkmon * 20/100);
				if(GetPlayerCash(playerid) <= iCheck)
			   	{
			   		SendClientMessageEx(playerid, COLOR_WHITE, "You don't have enough money for the phone number!");
			   		return 1;
			   	}
				if(GetPlayerCash(playerid) >= 1000000)
				{
					SetPVarInt(playerid, "WantedPh", numberstr);
					SetPVarInt(playerid, "CurrentPh", PlayerInfo[playerid][pPnumber]);
					SetPVarInt(playerid, "PhChangeCost", iCheck);
					mysql_format(MainPipeline, query, sizeof(query), "SELECT `Username` FROM `accounts` WHERE `PhoneNr` = '%d'",numberstr);
					mysql_tquery(MainPipeline, query, "OnPhoneNumberCheck", "ii", playerid, 1);
					return 1;
				}
				else if(GetPlayerCash(playerid) >= 200000 && GetPlayerCash(playerid) < 1000000)
				{
					SetPVarInt(playerid, "WantedPh", numberstr);
					SetPVarInt(playerid, "CurrentPh", PlayerInfo[playerid][pPnumber]);
					SetPVarInt(playerid, "PhChangeCost", 200000);
					mysql_format(MainPipeline, query, sizeof(query), "SELECT `Username` FROM `accounts` WHERE `PhoneNr` = '%d'",numberstr);
					mysql_tquery(MainPipeline, query, "OnPhoneNumberCheck", "ii", playerid, 1);
					return 1;
				}
				else
				{
					SendClientMessageEx(playerid,COLOR_GREY," You do not have enough money to purchase a negative 3 digit number, try again.");
					return 1;
				}
			}
			else if(strlen(numb) >= 5 && strlen(numb) <= 9)
			{
				new iCheck = abs(checkmon * 10/100);
				if(GetPlayerCash(playerid) <= iCheck)
			   	{
			   		SendClientMessageEx(playerid, COLOR_WHITE, "You don't have enough money for the phone number!");
			   		return 1;
			   	}
				if(GetPlayerCash(playerid) >= 500000)
				{
					SetPVarInt(playerid, "WantedPh", numberstr);
					SetPVarInt(playerid, "CurrentPh", PlayerInfo[playerid][pPnumber]);
					SetPVarInt(playerid, "PhChangeCost", iCheck);
					mysql_format(MainPipeline, query, sizeof(query), "SELECT `Username` FROM `accounts` WHERE `PhoneNr` = '%d'",numberstr);
					mysql_tquery(MainPipeline, query, "OnPhoneNumberCheck", "ii", playerid, 1);
					return 1;
				}
				else if(GetPlayerCash(playerid) >= 50000 && GetPlayerCash(playerid) < 500000)
				{
					SetPVarInt(playerid, "WantedPh", numberstr);
					SetPVarInt(playerid, "CurrentPh", PlayerInfo[playerid][pPnumber]);
					SetPVarInt(playerid, "PhChangeCost", 50000);
					mysql_format(MainPipeline, query, sizeof(query), "SELECT `Username` FROM `accounts` WHERE `PhoneNr` = '%d'",numberstr);
					mysql_tquery(MainPipeline, query, "OnPhoneNumberCheck", "ii", playerid, 1);
					return 1;
				}
				else
				{
					SendClientMessageEx(playerid,COLOR_GREY," You do not have enough money to purchase a negative 2 digit number, try again.");
					return 1;
				}
			}
			else return SendClientMessageEx(playerid,COLOR_GREY," Unable to change your number!");
		}
		else
		{
			SendClientMessageEx(playerid,COLOR_GREY," You chose not to change numbers.");
		}

	}
	if(dialogid == VIPNUMMENU2)
	{
		if(response)
		{
			SendClientMessageEx(playerid, COLOR_GREEN, "________________________________________________");
			SendClientMessageEx(playerid, COLOR_YELLOW, "Phone number is not being used, updating your phone number.");
			format(string,sizeof(string),"You have changed numbers from %d, to %d, and it cost $%s", GetPVarInt(playerid, "CurrentPh"), GetPVarInt(playerid, "WantedPh"), number_format(GetPVarInt(playerid, "PhChangeCost")));
			SendClientMessageEx(playerid,COLOR_GREY,string);
			PlayerInfo[playerid][pPnumber] = GetPVarInt(playerid, "WantedPh");
			new iCost = abs(GetPVarInt(playerid, "PhChangeCost"));
			GivePlayerCash(playerid, -iCost);
			mysql_format(MainPipeline, string, sizeof(string), "UPDATE `accounts` SET `PhoneNr` = %d WHERE `id` = '%d'", PlayerInfo[playerid][pPnumber], GetPlayerSQLId(playerid));
			mysql_tquery(MainPipeline, string, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
			DeletePVar(playerid, "PhChangerId");
			DeletePVar(playerid, "WantedPh");
			DeletePVar(playerid, "PhChangeCost");
			DeletePVar(playerid, "CurrentPh");
		}
		else
		{
			SendClientMessageEx(playerid,COLOR_GREY," You chose not to change numbers.");
			DeletePVar(playerid, "PhChangerId");
			DeletePVar(playerid, "WantedPh");
			DeletePVar(playerid, "PhChangeCost");
			DeletePVar(playerid, "CurrentPh");
		}
	}
	/*if(dialogid == RENTMENU)
	{
		if(response)
			{
				switch(listitem)
					{
					case 0://15 Minutes
						{
							if(GetPlayerCash(playerid) < 1000)
								{
									SendClientMessageEx(playerid, COLOR_GRAD1, "You don't have enough money!");
									RemovePlayerFromVehicle(playerid);
									new Float:slx, Float:sly, Float:slz;
									GetPlayerPos(playerid, slx, sly, slz);
									SetPlayerPos(playerid, slx, sly, slz+1.2);
									TogglePlayerControllable(playerid,1);
								}
							else
								{
									GivePlayerCash(playerid,-1000);
									gBike[playerid] = 3;
									gBikeRenting[playerid] = 1;
									TogglePlayerControllable(playerid, 1);
									SendClientMessageEx(playerid,COLOR_GREY," You have rented a bike for 15 minutes, enjoy!");
									SetPVarInt(playerid, "RentTime", SetTimerEx("RentTimer", (1000*60)*15, true, "d", playerid));
								}
						}
					case 1: // 30 minutes
						{
						   if(GetPlayerCash(playerid) < 2000)
								{
									SendClientMessageEx(playerid, COLOR_GRAD1, "You don't have enough money!");
									RemovePlayerFromVehicle(playerid);
									new Float:slx, Float:sly, Float:slz;
									GetPlayerPos(playerid, slx, sly, slz);
									SetPlayerPos(playerid, slx, sly, slz+1.2);
									TogglePlayerControllable(playerid,1);
								}
							else
							{
								GivePlayerCash(playerid,-2000);
								gBike[playerid] = 6;
								gBikeRenting[playerid] = 1;
								TogglePlayerControllable(playerid, 1);
								SendClientMessageEx(playerid,COLOR_GREY," You have rented a bike for 30 minutes, enjoy!");
								SetPVarInt(playerid, "RentTime", SetTimerEx("RentTimer", (1000*60)*30, true, "d", playerid));
							}
						}
					case 2: // 1 hour
						{
							if(GetPlayerCash(playerid) < 4000)
								{
									SendClientMessageEx(playerid, COLOR_GRAD1, "You don't have enough money!");
									RemovePlayerFromVehicle(playerid);
									new Float:slx, Float:sly, Float:slz;
									GetPlayerPos(playerid, slx, sly, slz);
									SetPlayerPos(playerid, slx, sly, slz+1.2);
									TogglePlayerControllable(playerid,1);
								}
							else
							{
								GivePlayerCash(playerid,-4000);
								gBike[playerid] = 12;
								gBikeRenting[playerid] = 1;
								TogglePlayerControllable(playerid, 1);
								SendClientMessageEx(playerid,COLOR_GREY," You have rented a bike for an hour, enjoy!");
								SetPVarInt(playerid, "RentTime", SetTimerEx("RentTimer", (1000*60)*60, true, "d", playerid));
							}
						}
					}
			}
		if(!response)
		{
			RemovePlayerFromVehicle(playerid);
			new Float:slx, Float:sly, Float:slz;
			GetPlayerPos(playerid, slx, sly, slz);
			SetPlayerPos(playerid, slx, sly, slz+1.2);
			TogglePlayerControllable(playerid,1);
			SendClientMessageEx(playerid,COLOR_GREY," You may only use these bikes if you rent one.");
		}

	}*/

	if(dialogid == 1348)
	{
		if(response)
		{
			new
				Float: carPosF[3],
				miscid = GetPVarInt(playerid, "playeraffectedcarTP"),
				v = ListItemTrackId[playerid][listitem];
			GetVehiclePos(PlayerVehicleInfo[miscid][v][pvId], carPosF[0], carPosF[1], carPosF[2]);
			SetPlayerVirtualWorld(playerid,GetVehicleVirtualWorld(PlayerVehicleInfo[miscid][v][pvId]));
			SetPlayerPos(playerid, carPosF[0], carPosF[1], carPosF[2]);
		}
	}
	if(dialogid == GOTOPLAYERCAR)
	{
		if(response == 1)
		{
			for(new i = 0; i < MAX_PLAYERVEHICLES; i++)
			{
				if(listitem == i)
				{
					new Float: carPos[3], id = GetPVarInt(playerid, "playeraffectedcarTP");
					if(PlayerVehicleInfo[id][i][pvId] > INVALID_PLAYER_VEHICLE_ID)
					{
						GetVehiclePos(PlayerVehicleInfo[id][i][pvId], carPos[0], carPos[1], carPos[2]);
						SetPlayerVirtualWorld(playerid,GetVehicleVirtualWorld(PlayerVehicleInfo[id][i][pvId]));
						SetPlayerInterior(playerid,0);
						SetPlayerPos(playerid, carPos[0], carPos[1], carPos[2]);
					}
					else
					{
						SendClientMessageEx(playerid, COLOR_WHITE, "You can not teleport to an empty, disabled or impounded slot.");
					}
				}
			}
		}
	}
	if(dialogid == VEHICLESTORAGE && response) {

		//if(!(400 <= PlayerVehicleInfo[playerid][listitem][pvModelId] <= 611))
		//printf("DEBUG: listitem: %d, Vehicle Slots: %d", listitem, GetPlayerVehicleSlots(playerid));
		if(listitem == GetPlayerVehicleSlots(playerid)) {
			new szstring[128];
			SetPVarInt(playerid, "MiscShop", 7);
			format(szstring, sizeof(szstring), "Additional Vehicle Slot\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[23][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[23][sItemPrice]));
			return ShowPlayerDialogEx(playerid, DIALOG_MISCSHOP2, DIALOG_STYLE_MSGBOX, "Purchase a additional vehicle slot", szstring, "Purchase", "Cancel");
		}

		if(PlayerVehicleInfo[playerid][listitem][pvSpawned]) {

			new
				iVehicleID = PlayerVehicleInfo[playerid][listitem][pvId];

			if((!IsVehicleOccupied(iVehicleID) || IsPlayerInVehicle(playerid, iVehicleID)) && !IsVehicleInTow(iVehicleID) && !PlayerVehicleInfo[playerid][listitem][pvBeingPickLocked]) {

				new
					Float: vehiclehealth;

				GetVehicleHealth(iVehicleID, vehiclehealth);

				if(vehiclehealth < 800) {
					SendClientMessageEx(playerid, COLOR_WHITE, "This vehicle is too damaged to be stored.");
				}
				else if (GetPVarInt(playerid, "Refueling") == PlayerVehicleInfo[playerid][listitem][pvId])
					SendClientMessageEx(playerid, COLOR_WHITE, "You can not store a vehicle while it is being refueled.");
				else if (WheelClamp{PlayerVehicleInfo[playerid][listitem][pvId]})
					SendClientMessageEx(playerid, COLOR_WHITE, "You can not store this vehicle at this moment.");
				else {
					--PlayerCars;
					VehicleSpawned[playerid]--;
					PlayerVehicleInfo[playerid][listitem][pvSpawned] = 0;
					PlayerVehicleInfo[playerid][listitem][pvFuel] = VehicleFuel[iVehicleID];
					GetVehicleHealth(PlayerVehicleInfo[playerid][listitem][pvId], PlayerVehicleInfo[playerid][listitem][pvHealth]);
					DestroyVehicle(iVehicleID);
					if(IsValidDynamicArea(iVehEnterAreaID[iVehicleID])) DestroyDynamicArea(iVehEnterAreaID[iVehicleID]);
					PlayerVehicleInfo[playerid][listitem][pvId] = INVALID_PLAYER_VEHICLE_ID;
					g_mysql_SaveVehicle(playerid, listitem);

					new vstring[128];
					format(vstring, sizeof(vstring), "You have stored your %s. The vehicle has been despawned.", VehicleName[PlayerVehicleInfo[playerid][listitem][pvModelId] - 400]);
					SendClientMessageEx(playerid, COLOR_WHITE, vstring);
					CheckPlayerVehiclesForDesync(playerid);
				}
			}
			else SendClientMessageEx(playerid, COLOR_WHITE, "This vehicle is currently occupied - it cannot be despawned right now.");
		}
		else if(PlayerVehicleInfo[playerid][listitem][pvImpounded]) {
			SendClientMessageEx(playerid, COLOR_WHITE, "You can not spawn an impounded vehicle. If you wish to reclaim it, do so at the DMV in Dillimore.");
		}
		else if(PlayerVehicleInfo[playerid][listitem][pvDisabled]) {
			SendClientMessageEx(playerid, COLOR_WHITE, "You can not spawn a disabled vehicle. It is disabled due to your VIP level (vehicle restrictions).");
		}
		else if((PlayerInfo[playerid][pRVehRestricted] > gettime() || PlayerVehicleInfo[playerid][listitem][pvRestricted] > gettime()) && IsRestrictedVehicle(PlayerVehicleInfo[playerid][listitem][pvModelId]))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to spawn this restricted vehicle.");
		}
		else if(!PlayerVehicleInfo[playerid][listitem][pvSpawned]) {
			if(PlayerInfo[playerid][pDonateRank] == 0 && VehicleSpawned[playerid] >= 2) {
				SendClientMessageEx(playerid, COLOR_GREY, "As non-VIP you can only have 2 vehicles spawned. You must store a vehicle in order to spawn another one.");
			}
			else if(PlayerInfo[playerid][pDonateRank] == 1 && VehicleSpawned[playerid] >= 2) {
				SendClientMessageEx(playerid, COLOR_GREY, "As Bronze VIP you can only have 2 vehicles spawned. You must store a vehicle in order to spawn another one.");
			}
			else if(PlayerInfo[playerid][pDonateRank] == 2 && VehicleSpawned[playerid] >= 2) {
				SendClientMessageEx(playerid, COLOR_GREY, "As Silver VIP you can only have 2 vehicles spawned. You must store a vehicle in order to spawn another one.");
			}
			else if(PlayerInfo[playerid][pDonateRank] == 3 && VehicleSpawned[playerid] >= 3) {
				SendClientMessageEx(playerid, COLOR_GREY, "As Gold VIP you can only have 3 vehicles spawned. You must store a vehicle in order to spawn another one.");
			}
			else if(PlayerInfo[playerid][pDonateRank] == 4 && VehicleSpawned[playerid] >= 5) {
				SendClientMessageEx(playerid, COLOR_GREY, "As Platinum VIP you can only have 5 vehicles spawned. You must store a vehicle in order to spawn another one.");
			}
			else if(!(0 <= PlayerInfo[playerid][pDonateRank] <= 4)) {
				SendClientMessageEx(playerid, COLOR_GREY, "You have an invalid VIP level.");
			}
			else if((PlayerVehicleInfo[playerid][listitem][pvModelId]) < 400) {
				SendClientMessageEx(playerid, COLOR_GREY, "The vehicle slot is empty.");
			}
			else {

				new
					iVeh = CreateVehicle(PlayerVehicleInfo[playerid][listitem][pvModelId], PlayerVehicleInfo[playerid][listitem][pvPosX], PlayerVehicleInfo[playerid][listitem][pvPosY], (PlayerVehicleInfo[playerid][listitem][pvModelId] == 460) ? PlayerVehicleInfo[playerid][listitem][pvPosZ]+5 : PlayerVehicleInfo[playerid][listitem][pvPosZ], PlayerVehicleInfo[playerid][listitem][pvPosAngle],PlayerVehicleInfo[playerid][listitem][pvColor1], PlayerVehicleInfo[playerid][listitem][pvColor2], -1);

				SetVehicleVirtualWorld(iVeh, PlayerVehicleInfo[playerid][listitem][pvVW]);
				LinkVehicleToInterior(iVeh, PlayerVehicleInfo[playerid][listitem][pvInt]);

				switch(GetVehicleModel(iVeh)) {
					case 519, 553, 508: {
						iVehEnterAreaID[iVeh] = CreateDynamicSphere(PlayerVehicleInfo[playerid][listitem][pvPosX]+2, PlayerVehicleInfo[playerid][listitem][pvPosY], PlayerVehicleInfo[playerid][listitem][pvPosZ], 4, GetVehicleVirtualWorld(iVeh));
						AttachDynamicAreaToVehicle(iVehEnterAreaID[iVeh], iVeh);
						// Streamer_SetIntData(STREAMER_TYPE_AREA, iVehEnterAreaID[iVeh], E_STREAMER_EXTRA_ID, iVeh);
					}
				}

				++PlayerCars;
				VehicleSpawned[playerid]++;
				PlayerVehicleInfo[playerid][listitem][pvSpawned] = 1;
				PlayerVehicleInfo[playerid][listitem][pvId] = iVeh;
				if(PlayerVehicleInfo[playerid][listitem][pvLocked] == 1) LockPlayerVehicle(playerid, iVeh, PlayerVehicleInfo[playerid][listitem][pvLock]);
				LoadPlayerVehicleMods(playerid, listitem);
				g_mysql_SaveVehicle(playerid, listitem);

				new vstring[64];
				format(vstring, sizeof(vstring), "You have taken your %s out of storage.", VehicleName[PlayerVehicleInfo[playerid][listitem][pvModelId] - 400]);
				SendClientMessageEx(playerid, COLOR_WHITE, vstring);
				CheckPlayerVehiclesForDesync(playerid);
				Vehicle_ResetData(iVeh);
				VehicleFuel[iVeh] = PlayerVehicleInfo[playerid][listitem][pvFuel];
				new zyear, zmonth, zday;
				getdate(zyear, zmonth, zday);
				if(zombieevent || (zmonth == 10 && zday == 31) || (zmonth == 11 && zday == 1)) SetVehicleHealth(iVeh, PlayerVehicleInfo[playerid][listitem][pvHealth]);
				if (VehicleFuel[iVeh] > 100.0) VehicleFuel[iVeh] = 100.0;

				if(PlayerVehicleInfo[playerid][listitem][pvCrashFlag] == 1 && PlayerVehicleInfo[playerid][listitem][pvCrashX] != 0.0)
				{
					SetVehiclePos(iVeh, PlayerVehicleInfo[playerid][listitem][pvCrashX], PlayerVehicleInfo[playerid][listitem][pvCrashY], PlayerVehicleInfo[playerid][listitem][pvCrashZ]);
					SetVehicleZAngle(iVeh, PlayerVehicleInfo[playerid][listitem][pvCrashAngle]);
					SetVehicleVirtualWorld(iVeh, PlayerVehicleInfo[playerid][listitem][pvCrashVW]);
					PlayerVehicleInfo[playerid][listitem][pvCrashFlag] = 0;
					PlayerVehicleInfo[playerid][listitem][pvCrashVW] = 0;
					PlayerVehicleInfo[playerid][listitem][pvCrashX] = 0.0;
					PlayerVehicleInfo[playerid][listitem][pvCrashY] = 0.0;
					PlayerVehicleInfo[playerid][listitem][pvCrashZ] = 0.0;
					PlayerVehicleInfo[playerid][listitem][pvCrashAngle] = 0.0;
					SendClientMessageEx(playerid, COLOR_WHITE, "Your vehicle has been restored to it's last known location from your previous timeout.");
				}
			}
		}
		else SendClientMessageEx(playerid, COLOR_WHITE, "You can not spawn a non-existent vehicle.");
	}
	if(dialogid == ADMIN_VEHCHECK && response) {
		if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1) { return SendClientMessage(playerid, COLOR_GRAD2, "You are not authorized");  }
		new giveplayerid = GetPVarInt(playerid, "vehcheck_giveplayerid");
		if(!IsPlayerConnected(giveplayerid)) { return SendClientMessage(playerid, COLOR_GRAD2, "The person has disconnected"); }
		new	iVehicleID = PlayerVehicleInfo[giveplayerid][listitem][pvId];
		new model;
		model = PlayerVehicleInfo[giveplayerid][listitem][pvModelId];
		PlayerVehicleInfo[giveplayerid][listitem][pvId] = 0;
		PlayerVehicleInfo[giveplayerid][listitem][pvModelId] = 0;
		PlayerVehicleInfo[giveplayerid][listitem][pvPosX] = 0.0;
		PlayerVehicleInfo[giveplayerid][listitem][pvPosY] = 0.0;
		PlayerVehicleInfo[giveplayerid][listitem][pvPosZ] = 0.0;
		PlayerVehicleInfo[giveplayerid][listitem][pvPosAngle] = 0.0;
		PlayerVehicleInfo[giveplayerid][listitem][pvLock] = 0;
		PlayerVehicleInfo[giveplayerid][listitem][pvLocksLeft] = 0;
		PlayerVehicleInfo[giveplayerid][listitem][pvLocked] = 0;
		PlayerVehicleInfo[giveplayerid][listitem][pvPaintJob] = -1;
		PlayerVehicleInfo[giveplayerid][listitem][pvColor1] = 0;
		PlayerVehicleInfo[giveplayerid][listitem][pvImpounded] = 0;
		PlayerVehicleInfo[giveplayerid][listitem][pvColor2] = 0;
		PlayerVehicleInfo[giveplayerid][listitem][pvAllowedPlayerId] = INVALID_PLAYER_ID;
		PlayerVehicleInfo[giveplayerid][listitem][pvPark] = 0;
		PlayerVehicleInfo[giveplayerid][listitem][pvVW] = 0;
		PlayerVehicleInfo[giveplayerid][listitem][pvInt] = 0;
		PlayerVehicleInfo[giveplayerid][listitem][pvAlarm] = 0;
		PlayerVehicleInfo[giveplayerid][listitem][pvAlarmTriggered] = 0;
		PlayerVehicleInfo[giveplayerid][listitem][pvBeingPickLocked] = 0;
		PlayerVehicleInfo[giveplayerid][listitem][pvBeingPickLockedBy] = INVALID_PLAYER_ID;
		PlayerVehicleInfo[giveplayerid][listitem][pvLastLockPickedBy] = 0;
		if(PlayerVehicleInfo[giveplayerid][listitem][pvSpawned])
		{
			PlayerVehicleInfo[giveplayerid][iVehicleID][pvSpawned] = 0;
			DestroyVehicle(iVehicleID);
			PlayerVehicleInfo[playerid][listitem][pvId] = INVALID_PLAYER_VEHICLE_ID;
			VehicleSpawned[giveplayerid]--;

		}
		DestroyPlayerVehicle(giveplayerid, listitem);
		for(new m = 0; m < MAX_MODS; m++)
		{
			PlayerVehicleInfo[giveplayerid][listitem][pvMods][m] = 0;
		}
		format(string, sizeof(string), "AdmCmd: Admin %s has deleted one of %s's(%d) vehicles (VehModel:%d)", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), model);
		Log("logs/admin.log", string);
		format(string, sizeof(string), "AdmCmd: Admin %s has deleted one of %s's vehicles (VehModel:%d)", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), model);
		ABroadCast(COLOR_YELLOW, string, 4);

		format(string, sizeof(string), "* Admin %s has deleted one of your vehicles.", GetPlayerNameEx(playerid));
		SendClientMessageEx(giveplayerid, COLOR_YELLOW, string);

		format(string, sizeof(string), "* You have deleted one of %s's vehicles.", GetPlayerNameEx(giveplayerid));
		SendClientMessageEx(playerid, COLOR_YELLOW, string);

	}
	if(dialogid == TRACKCAR2)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new Float: carPos[3];
					GetVehiclePos(GetPVarInt(playerid, "RentedVehicle"), carPos[0], carPos[1], carPos[2]);
					if(CheckPointCheck(playerid))
					{
						SendClientMessageEx(playerid, COLOR_WHITE, "Please ensure that your current checkpoint is destroyed first (you either have material packages, or another existing checkpoint).");
					}
					else
					{
						SetPVarInt(playerid, "TrackCar", 1);
						new zone[MAX_ZONE_NAME];
						Get3DZone(carPos[0], carPos[1], carPos[2], zone, sizeof(zone));
						format(string, sizeof(string), "Your vehicle is located in %s.", zone);
						SendClientMessageEx(playerid, COLOR_YELLOW, string);
						SetPlayerCheckpoint(playerid, carPos[0], carPos[1], carPos[2], 15.0);
						SendClientMessageEx(playerid, COLOR_WHITE, "Hint: Make your way to the checkpoint to find your vehicle!");
					}
				}
				case 1:
				{
					new vstring[1024];
					new szCarLocation[MAX_ZONE_NAME];
					for(new i, iModelID; i < MAX_PLAYERVEHICLES; i++)
					{
						if((iModelID = PlayerVehicleInfo[playerid][i][pvModelId] - 400) >= 0)
						{
							Get3DZone(PlayerVehicleInfo[playerid][i][pvPosX], PlayerVehicleInfo[playerid][i][pvPosY], PlayerVehicleInfo[playerid][i][pvPosZ], szCarLocation, sizeof(szCarLocation));
							if(PlayerVehicleInfo[playerid][i][pvImpounded]) {
								format(vstring, sizeof(vstring), "%s\n%s (impounded) | Location: DMV", vstring, VehicleName[iModelID]);
							}
							else if(PlayerVehicleInfo[playerid][i][pvDisabled]) {
								format(vstring, sizeof(vstring), "%s\n%s (disabled) | Location: Unknown", vstring, VehicleName[iModelID]);
							}
							else if(!PlayerVehicleInfo[playerid][i][pvSpawned]) {
								format(vstring, sizeof(vstring), "%s\n%s (stored)", vstring, VehicleName[iModelID]);
							}
							else format(vstring, sizeof(vstring), "%s\n%s | Location: %s", vstring, VehicleName[iModelID], szCarLocation);
						}
						else strcat(vstring, "\nEmpty");
					}
					ShowPlayerDialogEx(playerid, TRACKCAR, DIALOG_STYLE_LIST, "Vehicle GPS Tracking", vstring, "Track", "Cancel");
				}
			}
		}
	}
	if(dialogid == TRACKCAR && response) {
		new Float: carPos[3];
		if(PlayerVehicleInfo[playerid][listitem][pvId] > INVALID_PLAYER_VEHICLE_ID)
		{
			GetVehiclePos(PlayerVehicleInfo[playerid][listitem][pvId], carPos[0], carPos[1], carPos[2]);
			if(CheckPointCheck(playerid))
			{
				SendClientMessageEx(playerid, COLOR_WHITE, "Please ensure that your current checkpoint is destroyed first (you either have material packages, or another existing checkpoint).");
			}
			else
			{
				SetPVarInt(playerid, "TrackCar", 1);
				new zone[MAX_ZONE_NAME];
				Get3DZone(carPos[0], carPos[1], carPos[2], zone, sizeof(zone));
				format(string, sizeof(string), "Your vehicle is located in %s.", zone);
				SendClientMessageEx(playerid, COLOR_YELLOW, string);
				SetPlayerCheckpoint(playerid, carPos[0], carPos[1], carPos[2], 15.0);
				SendClientMessageEx(playerid, COLOR_WHITE, "Hint: Make your way to the checkpoint to find your vehicle!");
			}
		}
		else if(PlayerVehicleInfo[playerid][listitem][pvImpounded]) SendClientMessageEx(playerid, COLOR_WHITE, "You can not track an impounded vehicle. If you wish to reclaim it, do so at the DMV in Dillimore.");
		else if(PlayerVehicleInfo[playerid][listitem][pvDisabled] == 1) SendClientMessageEx(playerid, COLOR_WHITE, "You can not track a disabled vehicle. It is disabled due to your VIP level (vehicle restrictions).");
		else if(PlayerVehicleInfo[playerid][listitem][pvSpawned] == 0) SendClientMessageEx(playerid, COLOR_WHITE, "You can not track a stored vehicle. Use /vstorage to spawn it.");
		else SendClientMessageEx(playerid, COLOR_WHITE, "You can not track a non-existent vehicle.");
	}
	if(dialogid == DV_STORAGE && response) {
		new stpos = strfind(inputtext, "(");
		new fpos = strfind(inputtext, ")");
		new caridstr[6], carid;
		strmid(caridstr, inputtext, stpos+1, fpos);
		carid = strval(caridstr);
		if(DynVehicleInfo[carid][gv_iSpawnedID] != INVALID_VEHICLE_ID && !DynVehicleInfo[carid][gv_iDisabled])
		{
			if((!IsVehicleOccupied(DynVehicleInfo[carid][gv_iSpawnedID]) || IsPlayerInVehicle(playerid, DynVehicleInfo[carid][gv_iSpawnedID])) && !IsVehicleInTow(DynVehicleInfo[carid][gv_iSpawnedID]))
			{
				new Float: vHealth;
				GetVehicleHealth(DynVehicleInfo[carid][gv_iSpawnedID], vHealth);

				if(vHealth < 800)
					return SendClientMessageEx(playerid, COLOR_GRAD1, "This vehicle is too damaged to be stored.");

				if(!IsPlayerInRangeOfVehicle(playerid, DynVehicleInfo[carid][gv_iSpawnedID], 9.0) && !IsWeaponizedVehicle(DynVehicleInfo[carid][gv_iModel]))
					return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not near the vehicle.");

				DestroyVehicle(DynVehicleInfo[carid][gv_iSpawnedID]);
				DynVeh[DynVehicleInfo[carid][gv_iSpawnedID]] = -1;
				DynVehicleInfo[carid][gv_iDisabled] = 2;
				DynVehicleInfo[carid][gv_iSpawnedID] = INVALID_VEHICLE_ID;
				for(new i = 0; i != MAX_DV_OBJECTS; i++)
				{
					if(DynVehicleObjInfo[carid][i][gv_iAttachedObjectID] != INVALID_OBJECT_ID)
					{
						DestroyDynamicObject(DynVehicleObjInfo[carid][i][gv_iAttachedObjectID]);
						DynVehicleObjInfo[carid][i][gv_iAttachedObjectID] = INVALID_OBJECT_ID;
					}
				}
				new szstring[128];
				format(szstring, sizeof(szstring), "You have stored your dynamic group vehicle (%s)", VehicleName[DynVehicleInfo[carid][gv_iModel] - 400]);
				SendClientMessageEx(playerid, COLOR_WHITE, szstring);
			}
			else
				return SendClientMessageEx(playerid, COLOR_GRAD1, "This vehicle is currently occupied.");
		}
		else if(DynVehicleInfo[carid][gv_iDisabled] == 1) SendClientMessageEx(playerid, COLOR_WHITE, "You can not spawn a repo'd vehicle. Please see /grepocars to buy it back.");
		else {
			DynVehicleInfo[carid][gv_iDisabled] = 0;
			DynVeh_Spawn(carid);
			new szstring[128];
			format(szstring, sizeof(szstring), "You have spawned your dynamic group vehicle (%s)", VehicleName[DynVehicleInfo[carid][gv_iModel] - 400]);
			SendClientMessageEx(playerid, COLOR_WHITE, szstring);
		}
	}
	if(dialogid == DV_TRACKCAR && response) {
		new stpos = strfind(inputtext, "(");
		new fpos = strfind(inputtext, ")");
		new caridstr[6], carid;
		strmid(caridstr, inputtext, stpos+1, fpos);
		carid = strval(caridstr);
		new Float: carPos[3];
		GetVehiclePos(DynVehicleInfo[carid][gv_iSpawnedID], carPos[0], carPos[1], carPos[2]);
		if(DynVehicleInfo[carid][gv_iSpawnedID] != INVALID_VEHICLE_ID)
		{
			if(CheckPointCheck(playerid))
			{
				SendClientMessageEx(playerid, COLOR_WHITE, "Please ensure that your current checkpoint is destroyed first (you either have material packages, or another existing checkpoint).");
			}
			else
			{
				SetPVarInt(playerid, "DV_TrackCar", 1);
				new zone[MAX_ZONE_NAME];
				Get3DZone(carPos[0], carPos[1], carPos[2], zone, sizeof(zone));
				format(string, sizeof(string), "Your vehicle is located in %s.", zone);
				SendClientMessageEx(playerid, COLOR_YELLOW, string);
				SetPlayerCheckpoint(playerid, carPos[0], carPos[1], carPos[2], 15.0);
				SendClientMessageEx(playerid, COLOR_WHITE, "Hint: Make your way to the checkpoint to find your vehicle!");
				if(carPos[2] > 500.0)
				{
					SendClientMessageEx(playerid, COLOR_WHITE, "Note: This vehicle may be parked in a garage or interior!");
				}
			}
		}
		else if(DynVehicleInfo[carid][gv_iDisabled] == 1) SendClientMessageEx(playerid, COLOR_WHITE, "You can not track a repo'd vehicle. Please see /grepocars to buy it back.");
		else if(DynVehicleInfo[carid][gv_iDisabled] == 2) SendClientMessageEx(playerid, COLOR_WHITE, "You can not track a stored vehicle. Use /dvstorage to restore.");
		else SendClientMessageEx(playerid, COLOR_WHITE, "You can not track a non-existent vehicle.");
	}
	// --------------------------------------------------------------------------------------------------
	if(dialogid == VIPWEPSMENU)
	{
		if(!response) return 1;
		if(PlayerInfo[playerid][pDonateRank] < 3 && PlayerInfo[playerid][pTokens] == 0)
		{
			SendClientMessageEx(playerid, COLOR_YELLOW, "VIP: You do not have any tokens!");
			return 1;
		}
		if(PlayerInfo[playerid][pConnectHours] < 2 || PlayerInfo[playerid][pWRestricted] > 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "You cannot use this as you are currently restricted from possessing weapons!");
		//if(!CanGetVIPWeapon(playerid) && (listitem < 4 || listitem == 8)) return SendClientMessageEx(playerid, COLOR_WHITE, "You can no longer withdraw anymore VIP weapons today, wait until tomorrow!");
		switch( listitem )
		{
			case 0:
			{

				if(PlayerInfo[playerid][pDonateRank] < 3)
				{
					if(PlayerInfo[playerid][pTokens] < 3)
					{
						SendClientMessageEx(playerid, COLOR_YELLOW, "VIP: You do not have enough tokens for this.");
						return 1;
					}
					PlayerInfo[playerid][pTokens] -= 3;
					format(string, sizeof(string), "VIP: You have traded 3 tokens for a Desert Eagle, you now have %d token(s).", PlayerInfo[playerid][pTokens]);
					SendClientMessageEx(playerid, COLOR_YELLOW, string);
				}
				GivePlayerValidWeapon(playerid, 24);
				PlayerInfo[playerid][pVIPGuncount]++;
			}
			case 1:
			{

				if(PlayerInfo[playerid][pDonateRank] < 3)
				{
					if(PlayerInfo[playerid][pTokens] < 2)
					{
						SendClientMessageEx(playerid, COLOR_YELLOW, "VIP: You do not have enough tokens for this.");
						return 1;
					}
					PlayerInfo[playerid][pTokens] -= 2;
					format(string, sizeof(string), "VIP: You have traded 2 tokens for a shotgun, you now have %d token(s).", PlayerInfo[playerid][pTokens]);
					SendClientMessageEx(playerid, COLOR_YELLOW, string);
				}
				GivePlayerValidWeapon(playerid, 25);
				PlayerInfo[playerid][pVIPGuncount]++;
			}
			case 2:
			{
				if(PlayerInfo[playerid][pDonateRank] < 3)
				{
					if(PlayerInfo[playerid][pTokens] < 3)
					{
						SendClientMessageEx(playerid, COLOR_YELLOW, "VIP: You do not have enough tokens for this.");
						return 1;
					}
					PlayerInfo[playerid][pTokens] -= 3;
					format(string, sizeof(string), "VIP: You have traded 3 tokens for an MP5, you now have %d token(s).", PlayerInfo[playerid][pTokens]);
					SendClientMessageEx(playerid, COLOR_YELLOW, string);
				}
				GivePlayerValidWeapon(playerid, 29);
				PlayerInfo[playerid][pVIPGuncount]++;
			}
			case 3:
			{
				if(PlayerInfo[playerid][pDonateRank] < 3)
				{
					if(PlayerInfo[playerid][pTokens] > 1)
					{
						PlayerInfo[playerid][pTokens] -= 2;
						format(string, sizeof(string), "VIP: You have traded 2 tokens for a silenced pistol, you now have %d token(s).", PlayerInfo[playerid][pTokens]);
						SendClientMessageEx(playerid, COLOR_YELLOW, string);
					}
					else
					{
						SendClientMessageEx(playerid, COLOR_YELLOW, "VIP: You do not have enough tokens for this.");
						return 1;
					}
				}
				GivePlayerValidWeapon(playerid, 23);
				PlayerInfo[playerid][pVIPGuncount]++;
			}
			case 4:
			{
				if(PlayerInfo[playerid][pDonateRank] < 3)
				{
					if(PlayerInfo[playerid][pTokens] > 0)
					{
						PlayerInfo[playerid][pTokens] -= 1;
						format(string, sizeof(string), "VIP: You have traded a token for a golf club, you now have %d token(s).", PlayerInfo[playerid][pTokens]);
						SendClientMessageEx(playerid, COLOR_YELLOW, string);
					}
					else
					{
						SendClientMessageEx(playerid, COLOR_YELLOW, "VIP: You do not have enough tokens for this.");
						return 1;
					}
				}
				GivePlayerValidWeapon(playerid, 2);
				PlayerInfo[playerid][pVIPGuncount]++;
			}
			case 5:
			{
				if(PlayerInfo[playerid][pDonateRank] < 3)
				{
					if(PlayerInfo[playerid][pTokens] > 0)
					{
						PlayerInfo[playerid][pTokens] -= 1;
						format(string, sizeof(string), "VIP: You have traded a token for a baseball bat, you now have %d token(s).", PlayerInfo[playerid][pTokens]);
						SendClientMessageEx(playerid, COLOR_YELLOW, string);
					}
					else
					{
						SendClientMessageEx(playerid, COLOR_YELLOW, "VIP: You do not have enough tokens for this.");
						return 1;
					}
				}
				GivePlayerValidWeapon(playerid, 5);
			}
			case 6:
			{
				if(PlayerInfo[playerid][pDonateRank] < 3)
				{
					if(PlayerInfo[playerid][pTokens] > 0)
					{
						PlayerInfo[playerid][pTokens] -= 1;
						format(string, sizeof(string), "VIP: You have traded a token for a dildo, you now have %d token(s).", PlayerInfo[playerid][pTokens]);
						SendClientMessageEx(playerid, COLOR_YELLOW, string);
					}
					else
					{
						SendClientMessageEx(playerid, COLOR_YELLOW, "VIP: You do not have enough tokens for this.");
						return 1;
					}
				}
				GivePlayerValidWeapon(playerid, 10);
				PlayerInfo[playerid][pVIPGuncount]++;
			}
			case 7:
			{
				if(PlayerInfo[playerid][pDonateRank] < 3)
				{
					if(PlayerInfo[playerid][pTokens] > 0)
					{
						PlayerInfo[playerid][pTokens] -= 1;
						format(string, sizeof(string), "VIP: You have traded a token for a sword, you now have %d token(s).", PlayerInfo[playerid][pTokens]);
						SendClientMessageEx(playerid, COLOR_YELLOW, string);
					}
					else
					{
						SendClientMessageEx(playerid, COLOR_YELLOW, "VIP: You do not have enough tokens for this.");
						return 1;
					}
				}
				GivePlayerValidWeapon(playerid, 8);
			}
			case 8:
			{
				if(PlayerInfo[playerid][pDonateRank] < 3)
				{
					if(PlayerInfo[playerid][pTokens] > 1)
					{
						PlayerInfo[playerid][pTokens] -= 2;
						format(string, sizeof(string), "VIP: You have traded 2 tokens for a 9mm, you now have %d token(s).", PlayerInfo[playerid][pTokens]);
						SendClientMessageEx(playerid, COLOR_YELLOW, string);
					}
					else
					{
						SendClientMessageEx(playerid, COLOR_YELLOW, "VIP: You do not have enough tokens for this.");
						return 1;
					}
				}
				GivePlayerValidWeapon(playerid, 22);
				PlayerInfo[playerid][pVIPGuncount]++;
			}
		}
	}
	if( dialogid == 3497) //famed change skin
	{
		new skinid = strval(inputtext);
		if(response)
		{
			if(skinid < 1 || skinid > 299)
			{
				SendClientMessageEx(playerid, COLOR_GREY, "That skin ID is invalid, the range of available skin IDs are 1-299 !");
				ShowPlayerDialogEx( playerid, 3497, DIALOG_STYLE_INPUT, "Skin Selection","Please enter a valid Skin ID!", "Wear", "Cancel" );
				return 1;
			}
			if(PlayerInfo[playerid][pFamed] == 1)
			{
				if(GetPlayerCash(playerid) < 3000)
				{
					SendClientMessageEx(playerid, COLOR_GREY, "You do not have $3,000 on you.");
					ShowPlayerDialogEx(playerid, 3497, DIALOG_STYLE_INPUT, "Famed Skin Selection","Please enter a Skin ID!\n\n{FF0000}Note: Skin changes are $3,000 for Old School.", "Change", "Cancel" );
					return 1;
				}
				GivePlayerCash(playerid, -3000);
			}
			if(PlayerInfo[playerid][pFamed] == 2)
			{
				if(GetPlayerCash(playerid) < 1500)
				{
					SendClientMessageEx(playerid, COLOR_GREY, "You do not have $1,500 on you.");
					ShowPlayerDialogEx(playerid, 3497, DIALOG_STYLE_INPUT, "Famed Skin Selection","Please enter a Skin ID!\n\n{FF0000}Note: Skin changes are $1,500 for Chartered Old School.", "Change", "Cancel" );
					return 1;
				}
				GivePlayerCash(playerid, -1500);
			}
			SendClientMessageEx(playerid, COLOR_YELLOW, "Famed Locker: You have changed your clothes.");
			PlayerInfo[playerid][pModel] = skinid;
			SetPlayerSkin(playerid, skinid);
		}
		else return 0;
		return 1;
	}
	if(dialogid == 3498) //Famed Weapon Locker
	{
		if(!response) return SendClientMessageEx(playerid, COLOR_GRAD2, "You exited the famed locker.");
		if(PlayerInfo[playerid][pConnectHours] < 2 || PlayerInfo[playerid][pWRestricted] > 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "You cannot use this as you are currently restricted from possessing weapons!");

		switch(listitem)
		{
			case 0: //Deagle
			{
				GivePlayerValidWeapon(playerid, 24);
				SendClientMessageEx(playerid, COLOR_YELLOW, "[Famed Locker] You have taken a Desert Eagle from the famed locker.");
			}
			case 1: //MP5
			{
				GivePlayerValidWeapon(playerid, 29);
				SendClientMessageEx(playerid, COLOR_YELLOW, "[Famed Locker] You have taken a Semi-Automatic MP5 from the famed locker.");
			}
			case 2: //Shotgun
			{
				GivePlayerValidWeapon(playerid, 25);
				SendClientMessageEx(playerid, COLOR_YELLOW, "[Famed Locker] You have taken a Pump Shotgun from the famed locker.");
			}
			case 3: //Rifle
			{
				GivePlayerValidWeapon(playerid, 33);
				SendClientMessageEx(playerid, COLOR_YELLOW, "[Famed Locker] You have taken a County Rifle from the famed locker.");
			}
			case 4: //SD Pistol
			{
				GivePlayerValidWeapon(playerid, 23);
				SendClientMessageEx(playerid, COLOR_YELLOW, "[Famed Locker] You have taken a Silenced Pistol from the famed locker.");
			}
			case 5: //Katana
			{
				GivePlayerValidWeapon(playerid, 8);
				SendClientMessageEx(playerid, COLOR_YELLOW, "[Famed Locker] You have taken a Japanese Katana from the famed locker.");
			}
			case 6: //Purple Dildo
			{
				GivePlayerValidWeapon(playerid, 10);
				SendClientMessageEx(playerid, COLOR_YELLOW, "[Famed Locker] You have taken a Purple Dildo from the famed locker.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "[Famed Locker] Have Fun...");
			}
			case 7: //White Dildo
			{
				GivePlayerValidWeapon(playerid, 11);
				SendClientMessageEx(playerid, COLOR_YELLOW, "[Famed Locker] You have taken a White Dildo from the famed locker.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "[Famed Locker] Have Fun...");
			}
			case 8: //Big Vibrator
			{
				GivePlayerValidWeapon(playerid, 12);
				SendClientMessageEx(playerid, COLOR_YELLOW, "[Famed Locker] You have taken a Big Vibrator from the famed locker.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "[Famed Locker] Have Fun...");
			}
			case 9: //Silver Vibrator
			{
				GivePlayerValidWeapon(playerid, 13);
				SendClientMessageEx(playerid, COLOR_YELLOW, "[Famed Locker] You have taken a Silver Vibrator from the famed locker.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "[Famed Locker] Have Fun...");
			}
		}
	}
	else if(dialogid == DIALOG_CHANGEPASS2)
	{
		if(!response || strlen(inputtext) == 0) return ShowLoginDialogs(playerid, 0);
		if(response)
		{
			if(PassComplexCheck && CheckPasswordComplexity(inputtext) != 1) return ShowLoginDialogs(playerid, 0);
			if(strlen(inputtext) > 64) return ShowLoginDialogs(playerid, 0), SendClientMessageEx(playerid, COLOR_GREY, "You can't select a password that's above 64 characters.");
			if(!strcmp(PlayerInfo[playerid][pLastPass], inputtext, true)) return ShowLoginDialogs(playerid, 0), SendClientMessageEx(playerid, COLOR_RED, "There was an issue with processing your request.");
			new
				szBuffer[129],
				szQuery[256],
				salt[11];

			SetPVarString(playerid, "PassChange", inputtext);
			randomString(salt);
			format(szQuery, sizeof(szQuery), "%s%s", inputtext, salt);
			WP_Hash(szBuffer, sizeof(szBuffer), szQuery);
			mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `accounts` SET `Key` = '%s', `Salt` = '%s' WHERE `id` = '%i'", szBuffer, salt, PlayerInfo[playerid][pId]);
			mysql_tquery(MainPipeline, szQuery, "OnPlayerChangePass", "i", playerid);
			SendClientMessageEx(playerid, COLOR_YELLOW, "Processing your request...");

			if(strcmp(PlayerInfo[playerid][pBirthDate], "0000-00-00", true) == 0 && PlayerInfo[playerid][pTut] != 0) ShowLoginDialogs(playerid, 1);
			else if(pMOTD[0] && GetPVarInt(playerid, "ViewedPMOTD") != 1) ShowLoginDialogs(playerid, 4);
			else if(PlayerInfo[playerid][pReceivedCredits] != 0) ShowLoginDialogs(playerid, 5);
		}
	}
	else if( dialogid == DIALOG_CHANGEPASS )
	{
		if(!response || strlen(inputtext) == 0) return SendClientMessageEx(playerid, COLOR_WHITE, "You have prevented yourself from changing your password." );
		if(response)
		{
			if(PassComplexCheck && CheckPasswordComplexity(inputtext) != 1) return ShowPlayerDialogEx(playerid, DIALOG_CHANGEPASS, DIALOG_STYLE_INPUT, "Password Change", "Please enter a new password for your account.\n\n\
				- You can't select a password that's below 8 or above 64 characters\n\
				- Your password must contain a combination of letters, numbers and special characters.\n\
				- Invalid Character: %", "Change", "Exit" );
			if(strlen(inputtext) > 64) return SendClientMessageEx(playerid, COLOR_WHITE, "You can't select a password that's above 64 characters.");
			if(!strcmp(PlayerInfo[playerid][pLastPass], inputtext, true)) return SendClientMessageEx(playerid, COLOR_RED, "There was an issue with processing your request.");
			new
				szBuffer[129],
				szQuery[256],
				salt[11];

			SetPVarString(playerid, "PassChange", inputtext);
			randomString(salt);
			format(szQuery, sizeof(szQuery), "%s%s", inputtext, salt);
			WP_Hash(szBuffer, sizeof(szBuffer), szQuery);

			mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `accounts` SET `Key` = '%s', `Salt` = '%s' WHERE `id` = '%i'", szBuffer, salt, PlayerInfo[playerid][pId]);
			mysql_tquery(MainPipeline, szQuery, "OnPlayerChangePass", "i", playerid);
			SendClientMessageEx(playerid, COLOR_YELLOW, "Processing your request...");
		}
	}
	else if(dialogid == DIALOG_NAMECHANGE)
	{
		if(!response || strlen(inputtext) == 0) return SendClientMessageEx(playerid, COLOR_WHITE, "You have prevented yourself from changing your name." );
		if(strlen(inputtext) > 20)
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "You can't select a name that's above 20 characters.");
		}
		else
		{
			if(strlen(inputtext) >= 1)
			{
				if(!response)
				{
					SendClientMessageEx(playerid, COLOR_WHITE, "You have prevented yourself from changing your name." );
				}
				else
				{
					if(!IsValidName(inputtext)) return SendClientMessageEx(playerid, COLOR_WHITE, "Name change rejected. Please choose a name in the correct format: Firstname_Lastname.");


					/*new namechangecost;
					namechangecost = (PlayerInfo[playerid][pLevel]) * 15000;

					if(PlayerInfo[playerid][pDonateRank] >= 3)
					{
						namechangecost = 90*namechangecost/100;
					}*/
					DeletePVar(playerid, "marriagelastname");
					new tmpName[MAX_PLAYER_NAME];
					mysql_escape_string(inputtext, tmpName);
					if(strcmp(inputtext, tmpName, false) != 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "Unacceptable characters used in namechange, try again");
					if((0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS) && (PlayerInfo[playerid][pRank] >= arrGroupData[PlayerInfo[playerid][pMember]][g_iFreeNameChange] && (PlayerInfo[playerid][pDivision] == arrGroupData[PlayerInfo[playerid][pMember]][g_iFreeNameChangeDiv] || arrGroupData[PlayerInfo[playerid][pMember]][g_iFreeNameChangeDiv] == INVALID_DIVISION)))
					{
						if(GetPVarType(playerid, "HasReport")) {
							SendClientMessageEx(playerid, COLOR_GREY, "You can only have 1 active report at a time. (/cancelreport)");
							return 1;
						}
						new String[128];
						SetPVarInt(playerid, "RequestingNameChange", 1);
						SetPVarString(playerid, "NewNameRequest", inputtext);
						SetPVarInt(playerid, "NameChangeCost", 0);
						new playername[MAX_PLAYER_NAME];
						GetPlayerName(playerid, playername, sizeof(playername));
						format( String, sizeof( String ), "You have requested a namechange from %s to %s at no cost, please wait until an admin approves it.", playername, inputtext);
						SendClientMessageEx( playerid, COLOR_YELLOW, String );
						SendReportToQue(playerid, "Name Change Request", 2, 4);
						return 1;
					}
					if(PlayerInfo[playerid][pAdmin] == 1 && PlayerInfo[playerid][pSMod] > 0)
					{
						if(GetPVarType(playerid, "HasReport")) {
							SendClientMessageEx(playerid, COLOR_GREY, "You can only have 1 active report at a time. (/cancelreport)");
							return 1;
						}
						new String[128];
						SetPVarInt(playerid, "RequestingNameChange", 1);
						SetPVarString(playerid, "NewNameRequest", inputtext);
						new playername[MAX_PLAYER_NAME];
						GetPlayerName(playerid, playername, sizeof(playername));
						format( String, sizeof( String ), "You have requested a namechange from %s to %s at no cost (Senior Mod), please wait until an admin approves it.", playername, inputtext);
						SendClientMessageEx( playerid, COLOR_YELLOW, String );
						SendReportToQue(playerid, "Name Change Request", 2, 4);
						return 1;
					}
					if(gettime() >= PlayerInfo[playerid][pNextNameChange])
					{
						if(GetPVarType(playerid, "HasReport")) return SendClientMessageEx(playerid, COLOR_GREY, "You can only have 1 active report at a time. (/cancelreport)");
						new String[128];
						SetPVarInt(playerid, "RequestingNameChange", 1);
						SetPVarString(playerid, "NewNameRequest", inputtext);
						SetPVarInt(playerid, "NameChangeCost", 1);
						new playername[MAX_PLAYER_NAME];
						GetPlayerName(playerid, playername, sizeof(playername));
						format( String, sizeof( String ), "You have requested a namechange from %s to %s for free, please wait until an admin approves it.", playername, inputtext);
						SendClientMessageEx( playerid, COLOR_YELLOW, String );
						SendReportToQue(playerid, "Name Change Request", 2, 4);
						return 1;
					}
					/*
					if(PlayerInfo[playerid][pCredits] >= ShopItems[40][sItemPrice])
					{
						if(GetPVarType(playerid, "HasReport")) return SendClientMessageEx(playerid, COLOR_GREY, "You can only have 1 active report at a time. (/cancelreport)");
						new String[128];
						SetPVarInt(playerid, "RequestingNameChange", 1);
						SetPVarString(playerid, "NewNameRequest", inputtext);
						SetPVarInt(playerid, "NameChangeCost", 2);
						new playername[MAX_PLAYER_NAME];
						GetPlayerName(playerid, playername, sizeof(playername));
						format( String, sizeof( String ), "You have requested a namechange from %s to %s for %s credits, please wait until a General Admin approves it.", playername, inputtext, number_format(ShopItems[40][sItemPrice]));
						SendClientMessageEx( playerid, COLOR_YELLOW, String );
						SendReportToQue(playerid, "Name Change Request (Credits)", 2, 4);
						return 1;
					}

					else
					{
						SendClientMessageEx(playerid, COLOR_GRAD2, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");
					}
					*/
					new namechangecost;
					switch(PlayerInfo[playerid][pLevel])
					{
						case 1: namechangecost = 10000;
						case 2: namechangecost = 15000;
						case 3: namechangecost = 20000;
						default: namechangecost = (PlayerInfo[playerid][pLevel]-3)*50000;
					}
					if(PlayerInfo[playerid][pCash] >= namechangecost)
					{
						if(GetPVarType(playerid, "HasReport")) return SendClientMessageEx(playerid, COLOR_GREY, "You can only have 1 active report at a time. (/cancelreport)");
						SetPVarInt(playerid, "RequestingNameChange", 1);
						SetPVarString(playerid, "NewNameRequest", inputtext);
						SetPVarInt(playerid, "NameChangeCost", namechangecost);
						SendClientMessageEx(playerid, COLOR_YELLOW, "You have requested a namechange from %s to %s for $%s, please wait until an admin approves it.", GetPlayerNameExt(playerid), inputtext, number_format(namechangecost));
						SendReportToQue(playerid, "Name Change Request (Cash)", 2, 4);
						return 1;
					}

					else
					{
						SendClientMessageEx(playerid, COLOR_GRAD2, "You don't have enough money for a name change.");
					}
				}
			}
			else
			{
				SendClientMessageEx( playerid, COLOR_WHITE, "Your name must be longer than 1 character." );
			}
		}
	}
	else if( dialogid == DIALOG_NAMECHANGE2 )
	{
		if(!response || strlen(inputtext) == 0) return Kick(playerid);
		if(strlen(inputtext) >= 20)
		{
			SendClientMessageEx( playerid, COLOR_WHITE, "You can't select a name that's above 20 characters." );
			ShowPlayerDialogEx( playerid, DIALOG_NAMECHANGE2, DIALOG_STYLE_INPUT, "Free name change","This is a roleplay server where you must have a name in this format: Firstname_Lastname.\nFor example: John_Smith or Jimmy_Johnson\n\nAn admin has offered you to change your name to the correct format for free. Please enter your desired name below.\n\nNote: If you press cancel you will be kicked from the server.", "Change", "Cancel" );
		}
		else
		{
			if( strlen(inputtext) >= 1 )
			{
				if(!response)
				{
					ShowPlayerDialogEx( playerid, DIALOG_NAMECHANGE2, DIALOG_STYLE_INPUT, "Free name change","This is a roleplay server where you must have a name in this format: Firstname_Lastname.\nFor example: John_Smith or Jimmy_Johnson\n\nAn admin has offered you to change your name to the correct format for free. Please enter your desired name below.\n\nNote: If you press cancel you will be kicked from the server.", "Change", "Cancel" );
				}
				else
				{
					for(new i = 0; i < strlen( inputtext ); i++)
					{
						if (inputtext[i] == ' ')
						{
							SendClientMessageEx(playerid, COLOR_WHITE, "Please use the '_'(underscore) instead of the ' '(space)");
							ShowPlayerDialogEx( playerid, DIALOG_NAMECHANGE2, DIALOG_STYLE_INPUT, "Free name change","This is a roleplay server where you must have a name in this format: Firstname_Lastname.\nFor example: John_Smith or Jimmy_Johnson\n\nAn admin has offered you to change your name to the correct format for free. Please enter your desired name below.\n\nNote: If you press cancel you will be kicked from the server.", "Change", "Cancel" );
							return 1;
						}
					}
					if( strfind( inputtext, "_", true) == -1 )
					{
						SendClientMessageEx( playerid, COLOR_WHITE, "Name change rejected. Please choose a name in the correct format: Firstname_Lastname." );
						ShowPlayerDialogEx( playerid, DIALOG_NAMECHANGE2, DIALOG_STYLE_INPUT, "Free name change","This is a roleplay server where you must have a name in this format: Firstname_Lastname.\nFor example: John_Smith or Jimmy_Johnson\n\nAn admin has offered you to change your name to the correct format for free. Please enter your desired name below.\n\nNote: If you press cancel you will be kicked from the server.", "Change", "Cancel" );
						return 1;
					}
					else
					{
						if(GetPVarType(playerid, "HasReport")) {
							SendClientMessageEx(playerid, COLOR_GREY, "You can only have 1 active report at a time. (/cancelreport)");
							return 1;
						}
						new String[128];
						DeletePVar(playerid, "marriagelastname");
						SetPVarInt(playerid, "RequestingNameChange", 1);
						SetPVarString(playerid, "NewNameRequest", inputtext);
						SetPVarInt(playerid, "NameChangeCost", 0);
						new playername[MAX_PLAYER_NAME];
						GetPlayerName(playerid, playername, sizeof(playername));
						format( String, sizeof( String ), "You have requested a namechange from %s to %s please wait until an admin approves it.", playername, inputtext);
						SendClientMessageEx( playerid, COLOR_YELLOW, String );
						// format( String, sizeof( String ), "{AA3333}AdmWarning{FFFF00}: %s (ID %d) requested a name change to %s for free (non-RP name) - /approvename %d (accept), or /denyname %d (deny).", playername, playerid, inputtext, playerid, playerid);
						// ABroadCast( COLOR_YELLOW, String, 3 );
						SendReportToQue(playerid, "Name Change Request", 2, 4);
						return 1;
					}
				}
			}
			else
			{
				SendClientMessageEx( playerid, COLOR_WHITE, "Your name must be longer than 1 character." );
				ShowPlayerDialogEx( playerid, DIALOG_NAMECHANGE2, DIALOG_STYLE_INPUT, "Free name change","This is a roleplay server where you must have a name in this format: Firstname_Lastname.\nFor example: John_Smith or Jimmy_Johnson\n\nAn admin has offered you to change your name to the correct format for free. Please enter your desired name below.\n\nNote: If you press cancel you will be kicked from the server.", "Change", "Cancel" );
			}
		}
	}
	if(dialogid == DIALOG_CDLOCKMENU)
	{
		if(response)
		{
			if(GetPVarInt(playerid, "lockmenu") == 1)
			{
				new pvid;
				if (IsNumeric(inputtext))
				{
					pvid = strval(inputtext)-1;
					if(PlayerVehicleInfo[playerid][pvid][pvId] == INVALID_PLAYER_VEHICLE_ID)
					{
						SendClientMessageEx(playerid, COLOR_GRAD4, "ERROR: You don't have a vehicle in this slot.");
						DeletePVar(playerid, "lockmenu");
						return 1;
					}
					if(PlayerVehicleInfo[playerid][pvid][pvAlarm] == 1)
					{
						SendClientMessageEx(playerid, COLOR_GRAD4, "ERROR: You already have this item installed on this vehicle.");
						DeletePVar(playerid, "lockmenu");
						return 1;
					}
					SendClientMessageEx(playerid, COLOR_GRAD4, "	You have purchased a standard car alarm!");
					SendClientMessageEx(playerid, COLOR_YELLOW, "HINT: Your alarm will now activate and alert you when someone tries to steal your car.");
					PlayerVehicleInfo[playerid][pvid][pvAlarm] = 1;
					g_mysql_SaveVehicle(playerid, pvid);
					DeletePVar(playerid, "lockmenu");
					new iBusiness = GetPVarInt(playerid, "businessid");
					new cost = GetPVarInt(playerid, "lockcost");
					new iItem = GetPVarInt(playerid, "item")-1;
					Businesses[iBusiness][bInventory]-= StoreItemCost[iItem][ItemValue];
					Businesses[iBusiness][bTotalSales]++;
					Businesses[iBusiness][bSafeBalance] += TaxSale(cost);
					//if(penalty) Businesses[iBusiness][bSafeBalance] -= floatround(cost * BIZ_PENALTY);
					GivePlayerCash(playerid, -cost);
					if (PlayerInfo[playerid][pBusiness] != InBusiness(playerid)) Businesses[iBusiness][bLevelProgress]++;
					SaveBusiness(iBusiness);
					PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
					/*if (PlayerInfo[playerid][pDonateRank] >= 1)
					{
						format(string,sizeof(string),"VIP: You have received 20 percent off this product. Instead of paying $%s, you paid $%s.", number_format(Businesses[iBusiness][bItemPrices][iItem]), number_format(cost));
						SendClientMessageEx(playerid, COLOR_YELLOW, string);
					}*/
					format(string,sizeof(string),"%s(%d) (IP: %s) has bought a Standard Car Alarm in %s (%d) for $%s.",GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), Businesses[iBusiness][bName], iBusiness, number_format(cost));
					Log("logs/business.log", string);
					format(string,sizeof(string),"* You have purchased a Standard Car Alarm from %s for $%s.", Businesses[iBusiness][bName], number_format(cost));
					SendClientMessage(playerid, COLOR_GRAD2, string);
					new playersold = GetPVarInt(playerid, "playersold");
					if(playersold)
					{
						DeletePVar(playerid, "Business_ItemType");
						DeletePVar(playerid, "Business_ItemPrice");
						DeletePVar(playerid, "Business_ItemOfferer");
						DeletePVar(playerid, "Business_ItemOffererSQLId");
					}
				}
			}
			else if(GetPVarInt(playerid, "lockmenu") == 4)
			{
				new pvid;
				if (IsNumeric(inputtext))
				{
					pvid = strval(inputtext)-1;
					if(PlayerVehicleInfo[playerid][pvid][pvId] == INVALID_PLAYER_VEHICLE_ID)
					{
						SendClientMessageEx(playerid, COLOR_GRAD4, "ERROR: You don't have a vehicle in this slot.");
						DeletePVar(playerid, "lockmenu");
						return 1;
					}
					if(PlayerVehicleInfo[playerid][pvid][pvAlarm] == 2)
					{
						SendClientMessageEx(playerid, COLOR_GRAD4, "ERROR: You already have this item installed & working on this vehicle.");
						DeletePVar(playerid, "lockmenu");
						return 1;
					}
					PlayerVehicleInfo[playerid][pvid][pvAlarm] = 2;
					g_mysql_SaveVehicle(playerid, pvid);
					DeletePVar(playerid, "lockmenu");
					GivePlayerCredits(playerid, -ShopItems[39][sItemPrice], 1);
					printf("Price39: %d", ShopItems[39][sItemPrice]);

					AmountSold[39]++;
					AmountMade[39] += ShopItems[39][sItemPrice];

					new szQuery[128];
					mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold39` = '%d', `AmountMade39` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[39], AmountMade[39]);
					mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "i", SENDDATA_THREAD);

					format(string, sizeof(string), "You have purchased a Deluxe Car Alarm for %s credits.", number_format(ShopItems[39][sItemPrice]));
					SendClientMessageEx(playerid, COLOR_CYAN, string);
					SendClientMessageEx(playerid, COLOR_YELLOW, "HINT: Your alarm will now activate and alert you when someone tries to steal your car.");

					format(string, sizeof(string), "[Deluxe Car Alarm] [User: %s(%i)] [IP: %s] [Credits: %s] [Price: %s]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[39][sItemPrice]));
					Log("logs/credits.log", string), print(string);
				}
			}
			else if(GetPVarInt(playerid, "lockmenu") == 2)
			{
				new pvid;
				if (IsNumeric(inputtext))
				{
					pvid = strval(inputtext)-1;
					if(PlayerVehicleInfo[playerid][pvid][pvId] == INVALID_PLAYER_VEHICLE_ID)
					{
						SendClientMessageEx(playerid, COLOR_GRAD4, "ERROR: You don't have a vehicle in this slot.");
						SetPVarInt(playerid, "lockmenu", 0);
						return 1;
					}
					if(PlayerVehicleInfo[playerid][pvid][pvLocksLeft] > 0 && PlayerVehicleInfo[playerid][pvid][pvLock] == 2)
					{
						SendClientMessageEx(playerid, COLOR_GRAD4, "ERROR: You already have this item installed & working on this vehicle.");
						DeletePVar(playerid, "lockmenu");
						return 1;
					}
					format(string, sizeof(string), "   You have purchased an electronic lock!");
					SendClientMessageEx(playerid, COLOR_GRAD4, string);
					SendClientMessageEx(playerid, COLOR_YELLOW, "HINT: You can now use /pvlock to lock your car.");
					UnLockPlayerVehicle(playerid, PlayerVehicleInfo[playerid][pvid][pvId], PlayerVehicleInfo[playerid][pvid][pvLock]);
					PlayerVehicleInfo[playerid][pvid][pvLock] = 2;
					PlayerVehicleInfo[playerid][pvid][pvLocksLeft] = 5;
					g_mysql_SaveVehicle(playerid, pvid);
					DeletePVar(playerid, "lockmenu");
					new iBusiness = GetPVarInt(playerid, "businessid");
					new cost = GetPVarInt(playerid, "lockcost");
					new iItem = GetPVarInt(playerid, "item")-1;
					Businesses[iBusiness][bInventory]-= StoreItemCost[iItem][ItemValue];
					Businesses[iBusiness][bTotalSales]++;
					Businesses[iBusiness][bSafeBalance] += TaxSale(cost);
					//if(penalty) Businesses[iBusiness][bSafeBalance] -= floatround(cost * BIZ_PENALTY);
					GivePlayerCash(playerid, -cost);
					if (PlayerInfo[playerid][pBusiness] != InBusiness(playerid)) Businesses[iBusiness][bLevelProgress]++;
					SaveBusiness(iBusiness);
					PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
					/*if (PlayerInfo[playerid][pDonateRank] >= 1)
					{
						format(string,sizeof(string),"VIP: You have received 20 percent off this product. Instead of paying $%s, you paid $%s.", number_format(Businesses[iBusiness][bItemPrices][iItem]), number_format(cost));
						SendClientMessageEx(playerid, COLOR_YELLOW, string);
					}*/
					format(string,sizeof(string),"%s(%d) (IP: %s) has bought a Electronic Lock in %s (%d) for $%s.",GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), Businesses[iBusiness][bName], iBusiness, number_format(cost));
					Log("logs/business.log", string);
					format(string,sizeof(string),"* You have purchased a Electronic Lock from %s for $%s.", Businesses[iBusiness][bName], number_format(cost));
					SendClientMessage(playerid, COLOR_GRAD2, string);
					new playersold = GetPVarInt(playerid, "playersold");
					if(playersold)
					{
						DeletePVar(playerid, "Business_ItemType");
						DeletePVar(playerid, "Business_ItemPrice");
						DeletePVar(playerid, "Business_ItemOfferer");
						DeletePVar(playerid, "Business_ItemOffererSQLId");
					}
				}
			}
			else if(GetPVarInt(playerid, "lockmenu") == 3)
			{
				new pvid;
				if (IsNumeric(inputtext))
				{
					pvid = strval(inputtext)-1;
					if(PlayerVehicleInfo[playerid][pvid][pvId] == INVALID_PLAYER_VEHICLE_ID)
					{
						SendClientMessageEx(playerid, COLOR_GRAD4, "ERROR: You don't have a vehicle in this slot.");
						SetPVarInt(playerid, "lockmenu", 0);
						return 1;
					}
					if(PlayerVehicleInfo[playerid][pvid][pvLocksLeft] > 0 && PlayerVehicleInfo[playerid][pvid][pvLock] == 3)
					{
						SendClientMessageEx(playerid, COLOR_GRAD4, "ERROR: You already have this item installed & working on this vehicle.");
						DeletePVar(playerid, "lockmenu");
						return 1;
					}
					format(string, sizeof(string), "   You have Purchased an industrial lock!");
					SendClientMessageEx(playerid, COLOR_GRAD4, string);
					SendClientMessageEx(playerid, COLOR_YELLOW, "HINT: You can now use /pvlock to lock your car.");
					PlayerVehicleInfo[playerid][pvid][pvLock] = 3;
					PlayerVehicleInfo[playerid][pvid][pvLocksLeft] = 5;
					g_mysql_SaveVehicle(playerid, pvid);
					DeletePVar(playerid, "lockmenu");
					new iBusiness = GetPVarInt(playerid, "businessid");
					new cost = GetPVarInt(playerid, "lockcost");
					new iItem = GetPVarInt(playerid, "item")-1;
					Businesses[iBusiness][bInventory]-= StoreItemCost[iItem][ItemValue];
					Businesses[iBusiness][bTotalSales]++;
					Businesses[iBusiness][bSafeBalance] += TaxSale(cost);
					//if(penalty) Businesses[iBusiness][bSafeBalance] -= floatround(cost * BIZ_PENALTY);
					GivePlayerCash(playerid, -cost);
					if (PlayerInfo[playerid][pBusiness] != InBusiness(playerid)) Businesses[iBusiness][bLevelProgress]++;
					SaveBusiness(iBusiness);
					PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
					/*if (PlayerInfo[playerid][pDonateRank] >= 1)
					{
						format(string,sizeof(string),"VIP: You have received 20 percent off this product. Instead of paying $%s, you paid $%s.", number_format(Businesses[iBusiness][bItemPrices][iItem]), number_format(cost));
						SendClientMessageEx(playerid, COLOR_YELLOW, string);
					}*/
					format(string,sizeof(string),"%s(%d) (IP: %s) has bought a Industrial Lock in %s (%d) for $%s.",GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), Businesses[iBusiness][bName], iBusiness, number_format(cost));
					Log("logs/business.log", string);
					format(string,sizeof(string),"* You have purchased a Industrial Lock from %s for $%s.",Businesses[iBusiness][bName], number_format(cost));
					SendClientMessage(playerid, COLOR_GRAD2, string);
					new playersold = GetPVarInt(playerid, "playersold");
					if(playersold)
					{
						DeletePVar(playerid, "Business_ItemType");
						DeletePVar(playerid, "Business_ItemPrice");
						DeletePVar(playerid, "Business_ItemOfferer");
						DeletePVar(playerid, "Business_ItemOffererSQLId");
					}
				}
			}
		}
	}
	if(dialogid == DIALOG_LOCKER_OS)
	{
		if(!response) return SendClientMessageEx(playerid, COLOR_GRAD2, "You have exited the locker.");

		if(listitem == 0)
		{
			new Float:health;
			GetHealth(playerid, health);
			new hpint = floatround( health, floatround_round );
			if( hpint >= 100 )
			{
				SendClientMessageEx(playerid, COLOR_GREY, "You already have full health.");
				return 1;
			}
			else {
				SetHealth(playerid, 100);
				SendClientMessageEx(playerid, COLOR_YELLOW, "[Famed Locker] You have used a first aid kit, you now have 100.0 HP.");
			}
		}
		if(listitem == 1)
		{
			new Float:armour;
			GetArmour(playerid, armour);
			if(armour >= 100)
			{
				SendClientMessageEx(playerid, COLOR_GREY, "You already have full armor.");
				return 1;
			}
			else if(GetPlayerCash(playerid) < 10000)
			{
				SendClientMessageEx(playerid, COLOR_GREY,"You don't have $10000");
				return 1;
			}
			else {
				GivePlayerCash(playerid, -10000);
				SetArmour(playerid, 100);
				SendClientMessageEx(playerid, COLOR_YELLOW, "[Famed Locker] You paid $10000 for a kevlar vest.");
			}
		}
		if(listitem == 2)
		{
			ShowPlayerDialogEx(playerid, 3497, DIALOG_STYLE_INPUT, "Famed Skin Selection","Please enter a Skin ID!\n\nNote: Skin changes are free for famed members.", "Change", "Cancel" );
		}
		if(listitem == 3)
		{
			ShowPlayerDialogEx(playerid, 7484, DIALOG_STYLE_LIST, "Job Center", "Detective\nLawyer\nWhore\nDrugs Dealer\nBodyguard\nMechanic\nArms Dealer\nBoxer\nDrugs Smuggler\nTaxi Driver\nCraftsman\nBartender\nShipment Contractor\nPizza Boy", "Proceed", "Cancel");
		}
	}
	if(dialogid == DIALOG_LOCKER_COS)
	{
		if(!response) return SendClientMessageEx(playerid, COLOR_GRAD2, "You have exited the locker.");

		if(listitem == 0)
		{
			new Float:health;
			GetHealth(playerid, health);
			new hpint = floatround( health, floatround_round );
			if( hpint >= 100 )
			{
				SendClientMessageEx(playerid, COLOR_GREY, "You already have full health.");
				return 1;
			}
			else {
				SetHealth(playerid, 100);
				SendClientMessageEx(playerid, COLOR_YELLOW, "[Famed Locker] You have used a first aid kit, you now have 100.0 HP.");
			}
		}
		if(listitem == 1)
		{
			new Float:armour;
			GetArmour(playerid, armour);
			if(armour >= 100)
			{
				SendClientMessageEx(playerid, COLOR_GREY, "You already have full armor.");
				return 1;
			}
			else if(GetPlayerCash(playerid) < 5000)
			{
				SendClientMessageEx(playerid, COLOR_GREY,"You don't have $5000");
				return 1;
			}
			else {
				GivePlayerCash(playerid, -5000);
				SetArmour(playerid, 100);
				SendClientMessageEx(playerid, COLOR_YELLOW, "[Famed Locker] You paid $5000 for a kevlar vest.");
			}
		}
		if(listitem == 2)
		{
			ShowPlayerDialogEx(playerid, 3497, DIALOG_STYLE_INPUT, "Famed Skin Selection","Please enter a Skin ID!\n\nNote: Skin changes are free for famed members.", "Change", "Cancel" );
		}
		if(listitem == 3)
		{
			ShowPlayerDialogEx(playerid, 7484, DIALOG_STYLE_LIST, "Job Center", "Detective\nLawyer\nWhore\nDrugs Dealer\nBodyguard\nMechanic\nArms Dealer\nBoxer\nDrugs Smuggler\nTaxi Driver\nCraftsman\nBartender\nShipment Contractor\nPizza Boy", "Proceed", "Cancel");
		}
	}
	if(dialogid == DIALOG_LOCKER_FAMED)
	{
		if(!response) return SendClientMessageEx(playerid, COLOR_GRAD2, "You have exited the locker.");

		if(listitem == 0)
		{
			new Float:health;
			GetHealth(playerid, health);
			new hpint = floatround(health, floatround_round);
			if(hpint >= 100)
			{
				SendClientMessageEx(playerid, COLOR_GREY, "You already have full health.");
				return 1;
			}
			else {
				SetHealth(playerid, 100);
				SendClientMessageEx(playerid, COLOR_YELLOW, "[Famed Locker] You have used a first aid kit, you now have 100.0 HP.");
			}
		}
		if(listitem == 1)
		{
			new Float:armour;
			GetArmour(playerid, armour);
			if(armour >= 100)
			{
				SendClientMessageEx(playerid, COLOR_GREY, "You already have full armor.");
				return 1;
			}
			else {
				SetArmour(playerid, 100);
				SendClientMessageEx(playerid, COLOR_YELLOW, "[Famed Locker] You have received a Kevlar Vest free of charge.");
			}
		}
		if(listitem == 2)
		{
			if(PlayerInfo[playerid][pAccountRestricted] != 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "Your account is restricted!");
			ShowPlayerDialogEx(playerid, 3498, DIALOG_STYLE_LIST, "Famed Weapon Inventory", "Desert Eagle (Free)\nSemi-Automatic MP5 (Free)\nPump Shotgun (Free)\nCounty Rifle (Free)\nSilenced Pistol (Free)\nJapanese Katana (Free)\nPurple Dildo (Free)\nWhite Dildo (Free)\nBig Vibrator (Free)\nSilver Vibrator (Free)\n", "Take", "Cancel");
		}
		if(listitem == 3)
		{
			ShowPlayerDialogEx(playerid, 3497, DIALOG_STYLE_INPUT, "Famed Skin Selection", "Please enter a Skin ID!\n\nNote: Skin changes are free for famed members.", "Change", "Cancel" );
		}
		if(listitem == 4)
		{
			ShowPlayerDialogEx(playerid, 7484, DIALOG_STYLE_LIST, "Job Center", "Detective\nLawyer\nWhore\nDrugs Dealer\nBodyguard\nMechanic\nArms Dealer\nBoxer\nDrugs Smuggler\nTaxi Driver\nCraftsman\nBartender\nShipment Contractor\nPizza Boy", "Proceed", "Cancel");
		}
		if(listitem == 5)
		{
			if(!response) return SendClientMessageEx(playerid, COLOR_GRAD2, "You have exited the famed locker.");

			if(PlayerInfo[playerid][pWantedLevel] >= 6)
				return SendClientMessageEx(playerid, COLOR_YELLOW, "You cannot use this as Most Wanted!");

			if(PlayerInfo[playerid][pJailTime] > 0)
			{
				SendClientMessageEx(playerid, COLOR_YELLOW, "You cannot do this at this time.");
				format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s has attempted to change his name tag color to famed while in jail/prison.", GetPlayerNameEx(playerid));
				ABroadCast(COLOR_YELLOW, string, 2);
				return 1;
			}

			if(GetPVarInt(playerid, "famedTag") == 0)
			{
				SetPlayerColor(playerid, COLOR_FAMED);
				SendClientMessageEx(playerid, COLOR_YELLOW, "[Famed Locker] Your name color will now appear as famed.");
				SetPVarInt(playerid, "famedTag", 1);
				return 1;
			}
			else {
				SetPlayerToTeamColor(playerid);
				SendClientMessageEx(playerid, COLOR_YELLOW, "[Famed Locker] Your name color will now appear as normal.");
				SetPVarInt(playerid, "famedTag", 0);
			}
		}
	}
	if(dialogid == 7483) // VIP Locker /viplocker
	{
		if(response)
		{
			if(!IsPlayerInRangeOfPoint(playerid, 7.0, 2555.747314, 1404.106079, 7699.584472) && !IsPlayerInRangeOfPoint(playerid, 7.0, 1832.0533, 1380.7281, 1464.3822) && !IsPlayerInRangeOfPoint(playerid, 7.0, 772.4844, 1715.7213, 1938.0391) && !IsPlayerInRangeOfPoint(playerid, 7.0, 1378.0017, 1747.4668, 927.3564)) SendClientMessageEx(playerid, COLOR_GRAD1, "You're not at a VIP Locker.");
			if(listitem == 0)
			{
				new Float:health;
				GetHealth(playerid, health);
				new hpint = floatround( health, floatround_round );
				if( hpint >= 100 )
				{
					SendClientMessageEx(playerid, COLOR_GREY, "You already have full health.");
					return 1;
				}

				SetHealth(playerid, 100);
				SendClientMessageEx(playerid, COLOR_YELLOW, "VIP: You have used a first aid kit, you now have 100.0 HP.");
			}
			if(listitem == 1)
			{
				new Float:armour;
				GetArmour(playerid, armour);
				if(armour >= 100)
				{
					SendClientMessageEx(playerid, COLOR_GREY, "You already have full armor.");
					return 1;
				}
				if(PlayerInfo[playerid][pDonateRank] == 1)
				{
					if(GetPlayerCash(playerid) < 15000)
					{
						SendClientMessageEx(playerid, COLOR_GREY,"You can't afford the $15000!");
						return 1;
					}
					GivePlayerCash(playerid, -15000);
					SetArmour(playerid, 100);
					SendClientMessageEx(playerid, COLOR_YELLOW, "VIP: You paid $15000 for a kevlar vest.");
				}
				else if(PlayerInfo[playerid][pDonateRank] == 2)
				{
					if(GetPlayerCash(playerid) < 10000)
					{
						SendClientMessageEx(playerid, COLOR_GREY,"You can't afford the $10000!");
						return 1;
					}
					GivePlayerCash(playerid, -10000);
					SetArmour(playerid, 100);
					SendClientMessageEx(playerid, COLOR_YELLOW, "VIP: You paid $10000 for a kevlar vest.");
				}
				if(PlayerInfo[playerid][pDonateRank] >= 3)
				{
					SetArmour(playerid, 100);
					SetPVarInt(playerid, "Armor", 1);
				}
			}
			if(listitem == 2)
			{
				if(PlayerInfo[playerid][pAccountRestricted] != 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "Your account is restricted!");
				if(PlayerInfo[playerid][pDonateRank] >= 1)
				{
					switch(PlayerInfo[playerid][pDonateRank])
					{
						case 1, 2: ShowPlayerDialogEx(playerid, VIPWEPSMENU, DIALOG_STYLE_LIST, "VIP Weapons", "Desert Eagle (3)\nShotgun (2)\nMP5 (3)\nSilenced Pistol (2)\nGolf Club (1)\nBat (1)\nDildo (1)\nSword (1)\n9mm (2)", "Select", "Cancel");
						default: ShowPlayerDialogEx(playerid, VIPWEPSMENU, DIALOG_STYLE_LIST, "VIP Weapons", "Desert Eagle\nShotgun\nMP5\nSilenced Pistol\nGolf Club\nBat\nDildo\nSword\n9mm", "Select", "Cancel");
					}
				}
				else
				{
					SendClientMessageEx(playerid, COLOR_YELLOW, "VIP: You must be a VIP member to access the gun lockers.");
				}
			}
			if(listitem == 3)
			{
				if(PlayerInfo[playerid][pDonateRank] >= 2)
				{
					ShowModelSelectionMenu(playerid, SkinList, "Change your clothes.");
				}
				else
				{
					SendClientMessageEx(playerid, COLOR_YELLOW, "VIP: You must be at least Silver VIP to access the clothes corner. In the clothes corner you can get ANY skin.");
				}
			}
			if(listitem == 4)
			{
				if(PlayerInfo[playerid][pDonateRank] >= 2)
				{
					ShowPlayerDialogEx(playerid, 7484, DIALOG_STYLE_LIST, "VIP: Job Center", "Detective\nLawyer\nWhore\nDrugs Dealer\nBodyguard\nMechanic\nArms Dealer\nBoxer\nDrugs Smuggler\nTaxi Driver\nCraftsman\nBartender\nShipment Contractor\nPizza Boy", "Proceed", "Cancel");
				}
				else
				{
					SendClientMessageEx(playerid, COLOR_YELLOW, "VIP: You must be at least Silver VIP to access the job center.");
				}
			}
			if(listitem == 5)
			{
				ShowPlayerDialogEx(playerid, 7486, DIALOG_STYLE_LIST, "VIP: VIP Color", "On\nOff", "Proceed", "Cancel");
			}
		}
	}
	if(dialogid == 7484) //This is now the default dialog for job centers in any lockers AKA VIP & Famed
	{
		if(!response) return DeletePVar(playerid, "m_Item");
		switch(listitem)
		{
			case 0: // Detective
			{
				SetPVarInt(playerid, "jobSelection", 1);
			}
			case 1: // Lawyer
			{
				SetPVarInt(playerid, "jobSelection", 2);
			}
			case 2: // Whore
			{
				SetPVarInt(playerid, "jobSelection", 3);
			}
			case 3: // Drugs Dealer
			{
				//SetPVarInt(playerid, "jobSelection", 4);
			}
			case 4: // Bodyguard
			{
				SetPVarInt(playerid, "jobSelection", 8);
				if(GetPVarInt(playerid, "m_Item") == 1) SetPVarInt(playerid, "jobSelection", 7);
			}
			case 5: // Mechanic
			{
				SetPVarInt(playerid, "jobSelection", 7);
				if(GetPVarInt(playerid, "m_Item") == 1) SetPVarInt(playerid, "jobSelection", 9);
			}
			case 6: // Arms Dealer
			{
				SetPVarInt(playerid, "jobSelection", 9);
				if(GetPVarInt(playerid, "m_Item") == 1) SetPVarInt(playerid, "jobSelection", 12);
			}
			case 7: // Boxer
			{
				SetPVarInt(playerid, "jobSelection", 12);
				if(GetPVarInt(playerid, "m_Item") == 1) SetPVarInt(playerid, "jobSelection", 20);
			}
			case 8: // Drugs Smuggler
			{
				SetPVarInt(playerid, "jobSelection", 14);
			}
			case 9: // Taxi Driver
			{
				SetPVarInt(playerid, "jobSelection", 17);
			}
			case 10: // Craftsman
			{
				SetPVarInt(playerid, "jobSelection", 18);
			}
			case 11: // Bartender
			{
				SetPVarInt(playerid, "jobSelection", 19);
			}
			case 12: // Trucker
			{
				SetPVarInt(playerid, "jobSelection", 20);
			}
			case 13: // Pizza Boy
			{
				SetPVarInt(playerid, "jobSelection", 21);
			}
		}
		if(GetPVarInt(playerid, "m_Item") == 1)
		{
			if(GetJobLevel(playerid, GetPVarInt(playerid, "jobSelection")) == 5) return SendClientMessageEx(playerid, COLOR_GRAD2, "Your skill level for this job is already at its highest.");
			format(string, sizeof(string), "Item: %s - %s\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", mItemName[1], GetJobName(GetPVarInt(playerid, "jobSelection")), number_format(PlayerInfo[playerid][pCredits]), number_format(MicroItems[1]), number_format(PlayerInfo[playerid][pCredits]-MicroItems[1]));
			return ShowPlayerDialogEx(playerid, DIALOG_MICROSHOP3, DIALOG_STYLE_MSGBOX, "Micro Shop", string, "Purchase", "Cancel");
		}
		if(GetPVarType(playerid, "m_Item") && GetPVarInt(playerid, "m_Item") == 0) strcat(string, "Micro Shop: Change a Job"); else strcat(string, "Locker: Job Center");
		if(PlayerInfo[playerid][pFamed] > 0 && PlayerInfo[playerid][pDonateRank] < 3)
		{
			ShowPlayerDialogEx(playerid, 7485, DIALOG_STYLE_LIST, string, "Job Slot 1\nJob Slot 2", "Proceed", "Cancel");
		}
		else if(PlayerInfo[playerid][pDonateRank] == 2)
		{
			ShowPlayerDialogEx(playerid, 7485, DIALOG_STYLE_LIST, string, "Job Slot 1\nJob Slot 2", "Proceed", "Cancel");
		}
		else if(PlayerInfo[playerid][pDonateRank] >= 3)
		{
			ShowPlayerDialogEx(playerid, 7485, DIALOG_STYLE_LIST, string, "Job Slot 1\nJob Slot 2\nJob Slot 3", "Proceed", "Cancel");
		}
		else ShowPlayerDialogEx(playerid, 7485, DIALOG_STYLE_LIST, string, "Job Slot 1", "Proceed", "Cancel");
	}
	if(dialogid == 7485)
	{
		if(!response) return DeletePVar(playerid, "m_Item");
		if(GetPVarType(playerid, "m_Item") && GetPVarInt(playerid, "m_Item") == 0)
		{
			SetPVarInt(playerid, "m_Response", listitem);
			format(string, sizeof(string), "Item: %s - %s\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", mItemName[0], GetJobName(GetPVarInt(playerid, "jobSelection")), number_format(PlayerInfo[playerid][pCredits]), number_format(MicroItems[0]), number_format(PlayerInfo[playerid][pCredits]-MicroItems[0]));
			return ShowPlayerDialogEx(playerid, DIALOG_MICROSHOP3, DIALOG_STYLE_MSGBOX, "Micro Shop", string, "Purchase", "Cancel");
		}
		switch(listitem)
		{
			case 0:
			{
				PlayerInfo[playerid][pJob] = GetPVarInt(playerid, "jobSelection");
				SendClientMessageEx(playerid, COLOR_YELLOW, "You have changed your first job!");
			}
			case 1:
			{
				PlayerInfo[playerid][pJob2] = GetPVarInt(playerid, "jobSelection");
				SendClientMessageEx(playerid, COLOR_YELLOW, "You have changed your second job!");
			}
			case 2:
			{
				PlayerInfo[playerid][pJob3] = GetPVarInt(playerid, "jobSelection");
				SendClientMessageEx(playerid, COLOR_YELLOW, "You have changed your third job!");
			}
		}
	}
	if(dialogid == 7486)
	{
		if(!response) return 1;

		if(PlayerInfo[playerid][pWantedLevel] >= 6)
		{
			SendClientMessageEx(playerid, COLOR_YELLOW, "You cannot use this as Most Wanted!");
			return 1;
		}
		if(PlayerInfo[playerid][pJailTime] > 0)
		{
			SendClientMessageEx(playerid, COLOR_YELLOW, "You cannot do this at this time.");
			format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s has attempted to change to VIP color while jailed.", GetPlayerNameEx(playerid));
			ABroadCast(COLOR_YELLOW, string, 2);
			return 1;
		}
		switch(listitem)
		{
			case 0:
			{
				SetPlayerColor(playerid, COLOR_VIP);
				SendClientMessageEx(playerid, COLOR_YELLOW, "You have turned on your VIP Name Color!");
			}
			case 1:
			{
				SetPlayerToTeamColor(playerid);
				SendClientMessageEx(playerid, COLOR_YELLOW, "You have turned off your VIP Name Color!");
			}
		}
	}
	if(dialogid == RESTAURANTMENU)
	{
		new pvar[25];
		if (response)
		{
			new iBusiness = InBusiness(playerid);

			format(pvar, sizeof(pvar), "Business_MenuItemPrice%d", listitem);
			new iPrice = GetPVarInt(playerid, pvar);
			format(pvar, sizeof(pvar), "Business_MenuItem%d", listitem);
			new iItem = GetPVarInt(playerid, pvar);
			new cost = (PlayerInfo[playerid][pDonateRank] >= 1) ? (floatround(iPrice * 0.8)) : (iPrice);

			if (!iPrice) {
				SendClientMessageEx(playerid, COLOR_GRAD4, "Item is not for sale anymore.");
			}
			else if (Businesses[iBusiness][bInventory] < 1) {
				SendClientMessageEx(playerid, COLOR_GRAD2, "Store does not have any items anymore!");
			}
			else if (iPrice != Businesses[iBusiness][bItemPrices][iItem]) {
				SendClientMessageEx(playerid, COLOR_GRAD4, "Purchase failed because the price for this item has changed.");
			}
			else if (GetPlayerCash(playerid) < cost) {
				SendClientMessageEx(playerid, COLOR_GRAD4, "You can't afford this item!");
			}
			else {
				format(pvar, sizeof(pvar), "Business_MenuItem%d", listitem);
				Businesses[iBusiness][bInventory]--;
				Businesses[iBusiness][bTotalSales]++;
				Businesses[iBusiness][bSafeBalance] += TaxSale(cost);
				//Businesses[iBusiness][bSafeBalance] -= floatround(cost * BIZ_PENALTY);
				GivePlayerCash(playerid, -cost);
				if (PlayerInfo[playerid][pBusiness] != InBusiness(playerid)) Businesses[iBusiness][bLevelProgress]++;
				SaveBusiness(iBusiness);
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				if (PlayerInfo[playerid][pDonateRank] >= 1)
				{
					format(string,sizeof(string),"VIP: You have received 20 percent off this product. Instead of paying $%s, you paid $%s.", number_format(Businesses[iBusiness][bItemPrices][listitem]), number_format(cost));
					SendClientMessageEx(playerid, COLOR_YELLOW, string);
				}
				format(string,sizeof(string),"%s(%d) (IP: %s) has bought a %s in %s (%d) for $%d.",GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid),RestaurantItems[iItem], Businesses[iBusiness][bName], iBusiness, cost);
				Log("logs/business.log", string);
				format(string,sizeof(string),"* You have purchased a %s from %s for $%d.",RestaurantItems[iItem],Businesses[iBusiness][bName], cost);
				SendClientMessage(playerid, COLOR_GRAD2, string);

				printf("%s\n%i", RestaurantItems[iItem], iItem);
				if (strcmp("Starter Meal", RestaurantItems[iItem]) == 0) // starter
				{
					if (PlayerInfo[playerid][pFitness] >= 3)
						PlayerInfo[playerid][pFitness] -= 3;
					else
						PlayerInfo[playerid][pFitness] = 0;
				}
				if (strcmp("Full Meal", RestaurantItems[iItem]) == 0) // full meal
				{
					switch(PlayerInfo[playerid][pBackpack]) {
						case 1: if(PlayerInfo[playerid][pBItems][0] < 1 && PlayerInfo[playerid][pBEquipped]) {
							ShowPlayerDialogEx(playerid, DIALOG_BMEALSTORE, DIALOG_STYLE_MSGBOX, "Eat or Store", "You can store this full meal inside your backpack or you can eat it right now", "Store", "Eat");
							return 1;
						}
						case 2: if(PlayerInfo[playerid][pBItems][0] < 4 && PlayerInfo[playerid][pBEquipped]) {
							ShowPlayerDialogEx(playerid, DIALOG_BMEALSTORE, DIALOG_STYLE_MSGBOX, "Eat or Store", "You can store this full meal inside your backpack or you can eat it right now", "Store", "Eat");
							return 1;
						}
						case 3: if(PlayerInfo[playerid][pBItems][0] < 5 && PlayerInfo[playerid][pBEquipped]) {
							ShowPlayerDialogEx(playerid, DIALOG_BMEALSTORE, DIALOG_STYLE_MSGBOX, "Eat or Store", "You can store this full meal inside your backpack or you can eat it right now", "Store", "Eat");
							return 1;
						}
					}
				}

				SetHealth(playerid, 100.0);
			}
		}
		for (new i; i <= 13; i++)
		{
			format(pvar,sizeof(pvar),"Business_MenuItem%d", i);
			DeletePVar(playerid, pvar);
			format(pvar,sizeof(pvar),"Business_MenuItemPrice%d", i);
			DeletePVar(playerid, pvar);
		}
	}
	if (dialogid == RESTAURANTMENU2)
	{
		if (response)
		{
			new business = InBusiness(playerid);
			if (GetPlayerCash(playerid) < Businesses[business][bItemPrices][listitem])
			{
				return SendClientMessageEx(playerid, COLOR_GRAD4, "You don't have the cash for this item!");
			}
			GivePlayerCash(playerid, -Businesses[business][bItemPrices][listitem]);
			Businesses[business][bSafeBalance] += TaxSale(Businesses[business][bItemPrices][listitem]);
			Businesses[business][bTotalSales]++;
			Businesses[business][bTotalProfits] += Businesses[business][bItemPrices][listitem];

			new buf[128];
			format(buf, sizeof(buf), "You have purchased a '%s'.", RestaurantItems[listitem]);
			SendClientMessageEx(playerid, COLOR_GRAD4, buf);
		}

		return 1;
	}
	if(dialogid == STOREMENU)
	{
		new pvar[25];
		if (response)
		{
			new iBusiness = InBusiness(playerid);

			format(pvar, sizeof(pvar), "Business_MenuItemPrice%d", listitem);
			new iPrice = GetPVarInt(playerid, pvar);
			format(pvar, sizeof(pvar), "Business_MenuItem%d", listitem);
			new iItem = GetPVarInt(playerid, pvar);
			new cost = (PlayerInfo[playerid][pDonateRank] >= 1) ? (floatround(iPrice * 0.8)) : (iPrice);

			if (!iPrice) {
				SendClientMessageEx(playerid, COLOR_GRAD4, "Item is not for sale anymore.");
			}
			else if (Businesses[iBusiness][bInventory] < 1) {
				SendClientMessageEx(playerid, COLOR_GRAD2, "Store does not have any items anymore!");
			}
			else if (iPrice != Businesses[iBusiness][bItemPrices][iItem-1]) {
				SendClientMessageEx(playerid, COLOR_GRAD4, "Purchase failed because the price for this item has changed.");
			}
			else if (GetPlayerCash(playerid) < cost) {
				SendClientMessageEx(playerid, COLOR_GRAD4, "You can't afford this item!");
			}
			else {
				format(pvar, sizeof(pvar), "Business_MenuItem%d", listitem);
				if(iItem == ITEM_ILOCK || iItem == ITEM_SCALARM || iItem == ITEM_ELOCK)
				{
					if(Businesses[iBusiness][bInventory] >= StoreItemCost[iItem-1][ItemValue])
					{
						SetPVarInt(playerid, "lockcost", cost);
						SetPVarInt(playerid, "businessid", iBusiness);
						SetPVarInt(playerid, "item", iItem);
						SetPVarInt(playerid, "penalty", 1);
						GivePlayerStoreItem(playerid, 0, iBusiness, iItem, cost);
					}
					else return SendClientMessageEx(playerid, COLOR_GRAD2, "The store does not have enough stock for that item!");
				}
				else
				{
					GivePlayerStoreItem(playerid, 0, iBusiness, iItem, cost);
				}
			}
		}
		for (new i; i < sizeof(StoreItems); i++)
		{
			format(pvar,sizeof(pvar),"Business_MenuItem%d", i);
			DeletePVar(playerid, pvar);
			format(pvar,sizeof(pvar),"Business_MenuItemPrice%d", i);
			DeletePVar(playerid, pvar);
		}
	}
	if(dialogid == SHOPMENU)
	{
		if(response)
		{
			new biz = InBusiness(playerid);
			if (GetPlayerCash(playerid) < Businesses[biz][bItemPrices][listitem])
			{
				return SendClientMessageEx(playerid, COLOR_GRAD4, "You don't have the cash for this item!");
			}
			Businesses[biz][bTotalSales]++;
			Businesses[biz][bSafeBalance] += TaxSale(Businesses[biz][bItemPrices][listitem]);
			GivePlayerCash(playerid, -Businesses[biz][bItemPrices][listitem]);

			switch (listitem)
			{
				case 0:
				{
					GivePlayerValidWeapon(playerid, WEAPON_DILDO);
					SendClientMessageEx(playerid, COLOR_GRAD4, "Purple Dildo purchased, you can now pleasure yourself.");
				}
				case 1:
				{
					GivePlayerValidWeapon(playerid, WEAPON_VIBRATOR);
					SendClientMessageEx(playerid, COLOR_GRAD4, "Short Vibrator purchased, you can now pleasure yourself.");
				}
				case 2:
				{
					GivePlayerValidWeapon(playerid, WEAPON_VIBRATOR2);
					SendClientMessageEx(playerid, COLOR_GRAD4, "Long Vibrator purchased, you can now pleasure yourself.");
				}
				case 3:
				{
					GivePlayerValidWeapon(playerid, WEAPON_DILDO2);
					SendClientMessageEx(playerid, COLOR_GRAD4, "White Dildo purchased, you can now pleasure yourself.");
				}
			}
		}
		return 1;
	}
	if(dialogid == GIVEKEYS)
	{
		if(response)
		{
			if(PlayerVehicleInfo[playerid][listitem][pvId] == INVALID_PLAYER_VEHICLE_ID) {
				SendClientMessageEx(playerid, COLOR_GRAD2, "You can't give out keys to a non-existent, impounded vehicle or stored vehicle.");
				GiveKeysTo[playerid] = INVALID_PLAYER_ID;
				return 1;
			}
			if(PlayerVehicleInfo[playerid][listitem][pvAllowedPlayerId] != INVALID_PLAYER_ID)
			{
				SendClientMessageEx(playerid, COLOR_GRAD2, "You already gave someone the keys of this car.");
				GiveKeysTo[playerid] = INVALID_PLAYER_ID;
				return 1;
			}
			if(PlayerInfo[GiveKeysTo[playerid]][pVehicleKeysFrom] != INVALID_PLAYER_ID)
			{
				SendClientMessageEx(playerid, COLOR_GRAD2, "That person already has keys from a different car.");
				GiveKeysTo[playerid] = INVALID_PLAYER_ID;
				return 1;
			}
			PlayerVehicleInfo[playerid][listitem][pvAllowedPlayerId] = GiveKeysTo[playerid];
			PlayerInfo[GiveKeysTo[playerid]][pVehicleKeys] = listitem;
			PlayerInfo[GiveKeysTo[playerid]][pVehicleKeysFrom] = playerid;
			format(string, sizeof(string), "%s has given you the keys for their %s.", GetPlayerNameEx(playerid), GetVehicleName(PlayerVehicleInfo[playerid][listitem][pvId]));
			SendClientMessageEx(GiveKeysTo[playerid], COLOR_GRAD2, string);
			format(string, sizeof(string), "You gave %s the keys for your %s.", GetPlayerNameEx(GiveKeysTo[playerid]), GetVehicleName(PlayerVehicleInfo[playerid][listitem][pvId]));
			SendClientMessageEx(playerid, COLOR_GRAD2, string);
			GiveKeysTo[playerid] = INVALID_PLAYER_ID;
		}
	}
	if(dialogid == REMOVEKEYS)
	{
		if(response)
		{
			if(PlayerVehicleInfo[playerid][listitem][pvId] == INVALID_PLAYER_VEHICLE_ID) {
				SendClientMessageEx(playerid, COLOR_GRAD2, "You can't remove the keys of a non-existent, impounded vehicle or stored vehicle.");
				return 1;
			}
			if(PlayerVehicleInfo[playerid][listitem][pvAllowedPlayerId] != PlayerVehicleInfo[playerid][listitem][pvAllowedPlayerId])
			{
				SendClientMessageEx(playerid, COLOR_GRAD2, "This person doesn't have the keys of this car.");
				return 1;
			}
			if(PlayerVehicleInfo[playerid][listitem][pvAllowedPlayerId] == INVALID_PLAYER_ID)
			{
				SendClientMessageEx(playerid, COLOR_GRAD2, "You have not given anyone the keys for this car.");
				return 1;
			}
			if (ProxDetectorS(4.0, playerid, PlayerVehicleInfo[playerid][listitem][pvAllowedPlayerId])) {
				PlayerInfo[PlayerVehicleInfo[playerid][listitem][pvAllowedPlayerId]][pVehicleKeys] = INVALID_PLAYER_VEHICLE_ID;
				PlayerInfo[PlayerVehicleInfo[playerid][listitem][pvAllowedPlayerId]][pVehicleKeysFrom] = INVALID_PLAYER_ID;
				format(string, sizeof(string), "%s has taken the keys of their %s.", GetPlayerNameEx(playerid), GetVehicleName(PlayerVehicleInfo[playerid][listitem][pvId]));
				SendClientMessageEx(PlayerVehicleInfo[playerid][listitem][pvAllowedPlayerId], COLOR_GRAD2, string);
				format(string, sizeof(string), "You took the keys of your %s from %s.", GetVehicleName(PlayerVehicleInfo[playerid][listitem][pvId]),GetPlayerNameEx(PlayerVehicleInfo[playerid][listitem][pvAllowedPlayerId]));
				SendClientMessageEx(playerid, COLOR_GRAD2, string);
				PlayerVehicleInfo[playerid][listitem][pvAllowedPlayerId] = INVALID_PLAYER_ID;
			}
			else
				return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not close enough to that player.");
		}
	}
	if(dialogid == MPSPAYTICKETSCOP)
	{
		if(response)
		{
			new
				szMessage[128],
				iTargetID = GetPVarInt(playerid, "vRel");

			if(PlayerVehicleInfo[iTargetID][listitem][pvTicket]) {
				format(szMessage, sizeof(szMessage), "You have paid the $%s ticket on %s's %s.", number_format(PlayerVehicleInfo[iTargetID][listitem][pvTicket]), GetPlayerNameEx(iTargetID), VehicleName[PlayerVehicleInfo[iTargetID][listitem][pvModelId] - 400]);
				SendClientMessageEx(playerid, COLOR_GRAD2, szMessage);

				format(szMessage, sizeof(szMessage), "%s has paid all tickets on your %s (%i).", GetPlayerNameEx(playerid), VehicleName[PlayerVehicleInfo[iTargetID][listitem][pvModelId] - 400], PlayerVehicleInfo[iTargetID][listitem][pvTicket]);
				SendClientMessageEx(iTargetID, COLOR_LIGHTBLUE, szMessage);
				PlayerVehicleInfo[iTargetID][listitem][pvTicket] = 0;
				g_mysql_SaveVehicle(iTargetID, listitem);
			}
			else if(PlayerVehicleInfo[iTargetID][listitem][pvImpounded])
			{
				format(szMessage, sizeof(szMessage), "You have released %s's %s.", GetPlayerNameEx(iTargetID), VehicleName[PlayerVehicleInfo[iTargetID][listitem][pvModelId] - 400]);
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);

				format(szMessage, sizeof(szMessage), "%s has released your %s from the impound. (/vstorage to spawn it)", GetPlayerNameEx(playerid), VehicleName[PlayerVehicleInfo[iTargetID][listitem][pvModelId] - 400]);
				SendClientMessageEx(iTargetID, COLOR_LIGHTBLUE, szMessage);

				format(szMessage, sizeof(szMessage), "HQ: %s has released %s's %s from the impound.", GetPlayerNameEx(playerid), GetPlayerNameEx(iTargetID), VehicleName[PlayerVehicleInfo[iTargetID][listitem][pvModelId] - 400]);
				SendGroupMessage(GROUP_TYPE_LEA, RADIO, szMessage);
				SendGroupMessage(GROUP_TYPE_TOWING, RADIO, szMessage);

				new rand = random(sizeof(DMVRelease));
				PlayerVehicleInfo[iTargetID][listitem][pvImpounded] = 0;
				PlayerVehicleInfo[iTargetID][listitem][pvSpawned] = 0;
				PlayerVehicleInfo[iTargetID][listitem][pvPosX] = DMVRelease[rand][0];
				PlayerVehicleInfo[iTargetID][listitem][pvPosY] = DMVRelease[rand][1];
				PlayerVehicleInfo[iTargetID][listitem][pvPosZ] = DMVRelease[rand][2];
				PlayerVehicleInfo[iTargetID][listitem][pvPosAngle] = 180.000;
				PlayerVehicleInfo[iTargetID][listitem][pvTicket] = 0;
				g_mysql_SaveVehicle(iTargetID, listitem);
			}
			else SendClientMessageEx(playerid, COLOR_GRAD2, "This vehicle either does not exist, or does not need to be released or have its tickets paid.");
		}
		return 1;
	}
	if(dialogid == MPSPAYTICKETS)
	{
		if(response)
		{
			new
				szMessage[128];

			if(PlayerInfo[playerid][pWantedLevel] != 0)
			{
				format(szMessage, sizeof(szMessage), "%s has attempted to pay/release their vehicles with %i active warrants.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pWantedLevel]);
				SendGroupMessage(GROUP_TYPE_LEA, DEPTRADIO, szMessage);
				return SendClientMessageEx(playerid, COLOR_YELLOW, "The police has been warned that you are wanted, and are on their way.");
			}
			if(PlayerVehicleInfo[playerid][listitem][pvTicket] && PlayerVehicleInfo[playerid][listitem][pvImpounded] == 0) {
				if(GetPlayerCash(playerid) < PlayerVehicleInfo[playerid][listitem][pvTicket]) {
					return SendClientMessageEx(playerid, COLOR_GRAD2, "You don't have enough money on you to pay the ticket.");
				}
				GivePlayerCash(playerid, -PlayerVehicleInfo[playerid][listitem][pvTicket]);
				Tax += PlayerVehicleInfo[playerid][listitem][pvTicket];
				SpeedingTickets += PlayerVehicleInfo[playerid][listitem][pvTicket];
				for(new z; z < MAX_GROUPS; z++)
				{
					if(arrGroupData[z][g_iAllegiance] == 1)
					{
						if(arrGroupData[z][g_iGroupType] == GROUP_TYPE_GOV)
						{
							new str[128];
							format(str, sizeof(str), "%s has paid some vehicle tickets adding $%s to the vault.", GetPlayerNameEx(playerid), number_format((PlayerVehicleInfo[playerid][listitem][pvTicket] / 100) * 30));
							GroupPayLog(z, str);
							break;
						}
					}
				}
				Misc_Save();
				format(szMessage, sizeof(szMessage), "You have paid the $%s ticket on your %s.", number_format(PlayerVehicleInfo[playerid][listitem][pvTicket]), VehicleName[PlayerVehicleInfo[playerid][listitem][pvModelId] - 400]);
				SendClientMessageEx(playerid, COLOR_GRAD2, szMessage);
				PlayerVehicleInfo[playerid][listitem][pvTicket] = 0;
				g_mysql_SaveVehicle(playerid, listitem);
			}
			else if(PlayerVehicleInfo[playerid][listitem][pvImpounded]) {

				new
					iCost = (PlayerVehicleInfo[playerid][listitem][pvPrice] / 20) + PlayerVehicleInfo[playerid][listitem][pvTicket] + (PlayerInfo[playerid][pLevel] * 3000);

				if(GetPlayerCash(playerid) < iCost) {
					return SendClientMessage(playerid, COLOR_GRAD2, "You don't have enough money on you.");
				}


				format(szMessage, sizeof(szMessage), "You have released your %s for $%i.", VehicleName[PlayerVehicleInfo[playerid][listitem][pvModelId] - 400], iCost);
				SendClientMessage(playerid, COLOR_LIGHTBLUE, szMessage);
				GivePlayerCash(playerid, -iCost);
				Tax += iCost;
				SpeedingTickets += iCost;

				for(new z; z < MAX_GROUPS; z++)
				{
					if(arrGroupData[z][g_iAllegiance] == 0 || arrGroupData[z][g_iAllegiance] == 1)
					{
						if(arrGroupData[z][g_iGroupType] == GROUP_TYPE_GOV)
						{
							new str[128];
							format(str, sizeof(str), "%s has paid some vehicle tickets adding $%s to the vault.", GetPlayerNameEx(playerid), number_format((iCost / 100) * 30));
							GroupPayLog(z, str);
							break;
						}
					}
				}

				Misc_Save();

				new rand = random(sizeof(DMVRelease));
				PlayerVehicleInfo[playerid][listitem][pvPosX] = DMVRelease[rand][0];
				PlayerVehicleInfo[playerid][listitem][pvPosY] = DMVRelease[rand][1];
				PlayerVehicleInfo[playerid][listitem][pvPosZ] = DMVRelease[rand][2];

				PlayerVehicleInfo[playerid][listitem][pvImpounded] = 0;
				PlayerVehicleInfo[playerid][listitem][pvSpawned] = 0;
				PlayerVehicleInfo[playerid][listitem][pvPosAngle] = 180.000;
				PlayerVehicleInfo[playerid][listitem][pvTicket] = 0;
				SendClientMessageEx(playerid, COLOR_WHITE, "Your vehicle has been released, type /vstorage to spawn it.");
				g_mysql_SaveVehicle(playerid, listitem);
			}
			else SendClientMessage(playerid, COLOR_GRAD2, "This vehicle either does not exist, or does not need to be released or have its tickets paid.");
		}
		return 1;
	}
	if(dialogid == REPORTSMENU)
	{
		if(response)
		{
			if(CancelReport[playerid] == listitem) return 1;
			new reportid = ListItemReportId[playerid][listitem];
			if(Reports[reportid][BeingUsed] == 0)
			{
				SendClientMessageEx(playerid, COLOR_GREY, "   That report ID is not being used!");
				return 1;
			}
			if(!IsPlayerConnected(Reports[reportid][ReportFrom]))
			{
				SendClientMessageEx(playerid, COLOR_GREY, "   The reporter has disconnected !");
				Reports[reportid][ReportFrom] = INVALID_PLAYER_ID;
				Reports[reportid][BeingUsed] = 0;
				return 1;
			}
			format(string, sizeof(string), "AdmCmd: %s has accepted the report from %s (ID: %i RID: %i).", GetPlayerNameEx(playerid), GetPlayerNameEx(Reports[reportid][ReportFrom]), Reports[reportid][ReportFrom], reportid);
			ABroadCast(COLOR_ORANGE, string, 2);
			AddReportToken(playerid); // Report Tokens
			if(PlayerInfo[playerid][pAdmin] == 1)
			{
				SendClientMessageEx(Reports[reportid][ReportFrom], COLOR_WHITE, "An admin has accepted your report and is reviewing it, you can /reply to send messages to the admin reviewing your report.");
			}
			else
			{
				format(string, sizeof(string), "%s has accepted your report and is reviewing it, you can /reply to send messages to the admin reviewing your report.", GetPlayerNameEx(playerid));
				SendClientMessageEx(Reports[reportid][ReportFrom], COLOR_WHITE, string);
			}
			PlayerInfo[playerid][pAcceptReport]++;
			ReportCount[playerid]++;
			ReportHourCount[playerid]++;
			Reports[reportid][ReplyTimerr] = SetTimerEx("ReplyTimer", 30000, 0, "d", reportid);
			Reports[reportid][CheckingReport] = playerid;
			//Reports[reportid][ReportFrom] = INVALID_PLAYER_ID;
			Reports[reportid][BeingUsed] = 0;
			Reports[reportid][TimeToExpire] = 0;
			//strmid(Reports[reportid][Report], "None", 0, 4, 4);
		}
		else
		{
			if(CancelReport[playerid] == listitem) return 1;
			new reportid = ListItemReportId[playerid][listitem];
			if(Reports[reportid][BeingUsed] == 0)
			{
				SendClientMessageEx(playerid, COLOR_GREY, "   That report ID is not being used!");
				return 1;
			}
			if(!IsPlayerConnected(Reports[reportid][ReportFrom]))
			{
				SendClientMessageEx(playerid, COLOR_GREY, "   The reporter has disconnected !");
				Reports[reportid][ReportFrom] = INVALID_PLAYER_ID;
				Reports[reportid][BeingUsed] = 0;
				return 1;
			}
			format(string, sizeof(string), "AdmCmd: %s has trashed the report from %s (RID: %i).", GetPlayerNameEx(playerid), GetPlayerNameEx(Reports[reportid][ReportFrom]), reportid);
			ABroadCast(COLOR_ORANGE, string, 2);
			if(PlayerInfo[playerid][pAdmin] == 1)
			{
				SendClientMessageEx(Reports[reportid][ReportFrom], COLOR_WHITE, "An admin has marked your report invalid. It will not be reviewed.");
			}
			else
			{
				format(string, sizeof(string), "%s has marked your report invalid. It will not be reviewed.", GetPlayerNameEx(playerid));
				SendClientMessageEx(Reports[reportid][ReportFrom], COLOR_WHITE, string);
			}
			PlayerInfo[playerid][pTrashReport]++;
			Reports[reportid][ReportFrom] = INVALID_PLAYER_ID;
			Reports[reportid][BeingUsed] = 0;
			Reports[reportid][TimeToExpire] = 0;
			new reportdialog[2048], itemid = 0;
			for(new i = 0; i < MAX_REPORTS; i++)
			{
				if(Reports[i][BeingUsed] == 1 && itemid < 40)
				{
					ListItemReportId[playerid][itemid] = i;
					itemid++;
					if(strlen((Reports[i][Report])) > 92)
					{
						new firstline[128], secondline[128];
						strmid(firstline, Reports[i][Report], 0, 88);
						strmid(secondline, Reports[i][Report], 88, 128);
						format(reportdialog, sizeof(reportdialog), "%s%s(ID:%i) | Report: %s", reportdialog, GetPlayerNameEx(Reports[i][ReportFrom]), Reports[i][ReportFrom], i, firstline);
						format(reportdialog, sizeof(reportdialog), "%s%s", reportdialog, secondline);
						ListItemReportId[playerid][itemid] = i;
						itemid++;
					}
					else format(reportdialog, sizeof(reportdialog), "%s%s(ID:%i) | Report: %s", reportdialog, GetPlayerNameEx(Reports[i][ReportFrom]), Reports[i][ReportFrom], i, (Reports[i][Report]));

					format(reportdialog, sizeof(reportdialog), "%s\n", reportdialog);
				}
			}
			CancelReport[playerid] = itemid;
			format(reportdialog, sizeof(reportdialog), "%s\n", reportdialog);
			format(reportdialog, sizeof(reportdialog), "%sCancel Reports", reportdialog);
			//SendClientMessageEx(playerid, COLOR_GREEN, "___________________________________________________");
			ShowPlayerDialogEx(playerid, REPORTSMENU, DIALOG_STYLE_LIST, "Reports", reportdialog, "Accept", "Trash");
			//strmid(Reports[reportid][Report], "None", 0, 4, 4);
		}
	}

	if(dialogid == COLORMENU)
	{
		if(response)
		{
			if(listitem == 0)
			{
				SetPlayerColor(playerid,COLOR_DBLUE);
				SendClientMessageEx(playerid, COLOR_DBLUE, "Your color has been set to Blue!");
			}
			if(listitem == 1)
			{
				SetPlayerColor(playerid,COLOR_BLACK);
				SendClientMessageEx(playerid, COLOR_BLACK, "Your color has been set to Black!");
			}
			if(listitem == 2)
			{
				SetPlayerColor(playerid,COLOR_RED);
				SendClientMessageEx(playerid, COLOR_RED, "Your color has been set to Red!");
			}
			if(listitem == 3)
			{
				SetPlayerColor(playerid,TEAM_ORANGE_COLOR);
				SendClientMessageEx(playerid, TEAM_ORANGE_COLOR, "Your color has been set to Orange!");
			}
			if(listitem == 4)
			{
				SetPlayerColor(playerid,COLOR_PINK);
				SendClientMessageEx(playerid, COLOR_PINK, "Your color has been set to Pink!");
			}
			if(listitem == 5)
			{
				SetPlayerColor(playerid,COLOR_PURPLE);
				SendClientMessageEx(playerid, COLOR_PURPLE, "Your color has been set to Purple!");
			}
			if(listitem == 6)
			{
				SetPlayerColor(playerid,COLOR_GREEN);
				SendClientMessageEx(playerid, COLOR_GREEN, "Your color has been set to Green!");
			}
			if(listitem == 7)
			{
				SetPlayerColor(playerid,COLOR_YELLOW);
				SendClientMessageEx(playerid, COLOR_YELLOW, "Your color has been set to Yellow!");
			}
			if(listitem == 8)
			{
				SetPlayerColor(playerid,COLOR_WHITE);
				SendClientMessageEx(playerid, COLOR_WHITE, "Your color has been set to White!");
			}
			if(listitem == 9)
			{
				SetPlayerColor(playerid,TEAM_APRISON_COLOR);
				SendClientMessageEx(playerid, COLOR_WHITE, "Your color has been set to OOC Prisoner Orange!");
			}
		}
	}

	if(dialogid == FIGHTMENU)
	{
		if(response)
		{
			if(GetPlayerCash(playerid) >= 50000)
			{
				if(listitem == 0)
				{
					PlayerInfo[playerid][pFightStyle] = FIGHT_STYLE_BOXING;
					SetPlayerFightingStyle (playerid, FIGHT_STYLE_BOXING);
					SendClientMessageEx(playerid, COLOR_WHITE, " You are now using the boxing fighting style!");

					if(PlayerInfo[playerid][pDonateRank] >= 1)
					{
						GivePlayerCash(playerid, -40000);
						SendClientMessageEx(playerid, COLOR_YELLOW, "VIP: You have received 20 percent off this product. Instead of paying $50000, you paid $40000.");
					}
					else
					{
						GivePlayerCash(playerid, -50000);
					}
				}
				if(listitem == 1)
				{
					PlayerInfo[playerid][pFightStyle] = FIGHT_STYLE_ELBOW;
					SetPlayerFightingStyle (playerid, FIGHT_STYLE_ELBOW);
					SendClientMessageEx(playerid, COLOR_WHITE, " You are now using the elbow fighting style!");

					if(PlayerInfo[playerid][pDonateRank] >= 1)
					{
						GivePlayerCash(playerid, -40000);
						SendClientMessageEx(playerid, COLOR_YELLOW, "VIP: You have received 20 percent off this product. Instead of paying $50000, you paid $40000.");
					}
					else
					{
						GivePlayerCash(playerid, -50000);
					}
				}
				if(listitem == 2)
				{
					PlayerInfo[playerid][pFightStyle] = FIGHT_STYLE_KNEEHEAD;
					SetPlayerFightingStyle (playerid, FIGHT_STYLE_KNEEHEAD);
					SendClientMessageEx(playerid, COLOR_WHITE, " You are now using the kneehead fighting style!");

					if(PlayerInfo[playerid][pDonateRank] >= 1)
					{
						GivePlayerCash(playerid, -40000);
						SendClientMessageEx(playerid, COLOR_YELLOW, "VIP: You have received 20 percent off this product. Instead of paying $50000, you paid $40000.");
					}
					else
					{
						GivePlayerCash(playerid, -50000);
					}
				}
				if(listitem == 3)
				{
					PlayerInfo[playerid][pFightStyle] = FIGHT_STYLE_KUNGFU;
					SetPlayerFightingStyle (playerid, FIGHT_STYLE_KUNGFU);
					SendClientMessageEx(playerid, COLOR_WHITE, " You are now using the kungfu fighting style!");

					if(PlayerInfo[playerid][pDonateRank] >= 1)
					{
						GivePlayerCash(playerid, -40000);
						SendClientMessageEx(playerid, COLOR_YELLOW, "VIP: You have received 20 percent off this product. Instead of paying $50000, you paid $40000.");
					}
					else
					{
						GivePlayerCash(playerid, -50000);
					}
				}
				if(listitem == 4)
				{
					PlayerInfo[playerid][pFightStyle] = FIGHT_STYLE_GRABKICK;
					SetPlayerFightingStyle (playerid, FIGHT_STYLE_GRABKICK);
					SendClientMessageEx(playerid, COLOR_WHITE, " You are now using the grabkick fighting style!");

					if(PlayerInfo[playerid][pDonateRank] >= 1)
					{
						GivePlayerCash(playerid, -40000);
						SendClientMessageEx(playerid, COLOR_YELLOW, "VIP: You have received 20 percent off this product. Instead of paying $50000, you paid $40000.");
					}
					else
					{
						GivePlayerCash(playerid, -50000);
					}
				}
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GREY, " You do not have the cash for that!");
				return 1;
			}

			if(listitem == 5)
			{
				PlayerInfo[playerid][pFightStyle] = FIGHT_STYLE_NORMAL;
				SetPlayerFightingStyle (playerid, FIGHT_STYLE_NORMAL);
				SendClientMessageEx(playerid, COLOR_WHITE, " You are now using the normal fighting style!");
				return 1;
			}
		}
	}
	if(dialogid == DIALOG_LICENSE_BUY && response) // LICENSE BUY DIALOG ~Brian
	{
		switch (listitem)
		{
			/*case 0:
			{
				if(PlayerInfo[playerid][pCarLic] == 0)
				{
					if(GetPlayerCash(playerid) < 5000)
					{
						SendClientMessageEx(playerid, COLOR_GREY, "You can not afford to buy a driver's license.");
						return 1;
					}
					GivePlayerCash(playerid,-5000);
					PlayerInfo[playerid][pCarLic] = 1;
					SendClientMessageEx(playerid, COLOR_GREY, "You have successfully acquired a driver's license.");
				}
				else SendClientMessageEx(playerid, COLOR_GREY, "You already have a driver's license.");
			}*/
			case 0:
			{
				if(PlayerInfo[playerid][pBoatLic] == 0)
				{
					if(GetPlayerCash(playerid) < 5000)
					{
						SendClientMessageEx(playerid, COLOR_GREY, "You can not afford to buy a boating license.");
						return 1;
					}
					GivePlayerCash(playerid,-5000);
					PlayerInfo[playerid][pBoatLic] = 1;
					SendClientMessageEx(playerid, COLOR_GREY, "You have successfully acquired a boating license.");
				}
				else SendClientMessageEx(playerid, COLOR_GREY, "You already have a boating license.");
			}
			case 1:
			{
				if(PlayerInfo[playerid][pFlyLic] == 0)
				{
					if(PlayerInfo[playerid][pLevel] >=2)
					{
						if(GetPlayerCash(playerid) < 25000)
						{
							SendClientMessageEx(playerid, COLOR_GREY, "You can not afford to buy a pilot's license.");
							return 1;
						}
						GivePlayerCash(playerid,-25000);
						PlayerInfo[playerid][pFlyLic] = 1;
						SendClientMessageEx(playerid, COLOR_GREY, "You have successfully acquired a pilot license; you will now be able to pilot aircraft.");
					}
					else SendClientMessageEx(playerid, COLOR_GREY, "You must be level 2 or above to acquire a pilot license.");
				}
				else SendClientMessageEx(playerid, COLOR_GREY, "You already have a pilot license.");
			}
			case 2:
			{
				if(PlayerInfo[playerid][pTaxiLicense] == 0)
				{
					if(GetPlayerCash(playerid) < 35000)
					{
						SendClientMessageEx(playerid, COLOR_GREY, "You can not afford to buy a taxi license.");
						return 1;
					}
					GivePlayerCash(playerid,-35000);
					PlayerInfo[playerid][pTaxiLicense] = 1;
					SendClientMessageEx(playerid, COLOR_GREY, "You have successfully acquired a taxi license; you will be able to use /fare in any vehicle, and accept calls for taxis.");
				}
				else SendClientMessageEx(playerid, COLOR_GREY, "You already have a taxi license.");
			}
		}
	}
	if(dialogid == MDC_MAIN && response)
	{
		if(!IsMDCPermitted(playerid)) return SendClientMessageEx(playerid, COLOR_LIGHTBLUE, " Login Failed. You are not permitted to use the MDC!");
		switch( listitem )
		{
			case 0:
			{
				ShowPlayerDialogEx(playerid, MDC_CIVILIANS, DIALOG_STYLE_LIST, "MDC - Logged in | Civilian Options", "*Check Record\n*View Arrest Reports\n*Licenses\n*Warrants\n*Issue Warrant\n*BOLO\n*Create BOLO\n*Delete", "OK", "Cancel");
			}
			case 1: ShowPlayerDialogEx(playerid, MDC_SUSPECT, DIALOG_STYLE_INPUT, "MDC - Register Suspect", "Please enter (a part of) the name of the suspect to register them.", "OK", "Cancel");
			case 2: ShowPlayerDialogEx(playerid, G_LOCKER_CLEARSUSPECT, DIALOG_STYLE_INPUT, arrGroupData[PlayerInfo[playerid][pMember]][g_szGroupName]," Who would you like to clear?","Clear","Return");
			case 3:	ShowPlayerDialogEx(playerid, MDC_VEHICLE, DIALOG_STYLE_INPUT, "MDC - Vehicle Registrations", "Please enter (a part of) the name of the person to check their active vehicle registrations.", "OK", "Cancel");
			case 4:
			{
				ShowPlayerDialogEx(playerid, MDC_FIND, DIALOG_STYLE_INPUT, "MDC - Logged in | LEO GPS Location", "Enter the Law Enforcment Official's Name or ID No.", "Enter", "Cancel");
			}
			case 5:
			{
				new groups[1024], item;
				for (new i; i < MAX_GROUPS; i++)
				{
					if (arrGroupData[i][g_szGroupName][0] && arrGroupData[i][g_iGroupType] == GROUP_TYPE_LEA && arrGroupData[i][g_iAllegiance] == arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance])
					{
						format(groups, sizeof(groups), "%s*%s\n", groups, arrGroupData[i][g_szGroupName]);
						ListItemTrackId[playerid][item++] = i;
					}
					ShowPlayerDialogEx(playerid, MDC_MEMBERS, DIALOG_STYLE_LIST, "MDC - Logged in | Agency List", groups, "OK", "Cancel");
				}
			}
			case 6: ShowPlayerDialogEx(playerid, MDC_MESSAGE, DIALOG_STYLE_INPUT, "MDC - Logged In | MDC Message", "Enter recipient's Name or ID No.", "OK", "Cancel");
			case 7: ShowPlayerDialogEx(playerid, MDC_SMS, DIALOG_STYLE_INPUT, "MDC - Logged In | SMS", "Enter recipient's phone number.", "OK", "Cancel");
		}
	}
	if(dialogid == MDC_SUSPECT) return cmd_su(playerid, inputtext);
	if(dialogid == MDC_VEHICLE) return cmd_vmdc(playerid, inputtext);
	if(dialogid == MDC_VLOOKUP) return cmd_vlookup(playerid, inputtext);
	if(dialogid == MDC_FIND && response)
	{
		new giveplayerid;
		if(!IsMDCPermitted(playerid)) return SendClientMessageEx(playerid, COLOR_LIGHTBLUE, " Login Failed. You are not permitted to use the MDC!");
		if(sscanf(inputtext, "u", giveplayerid))
		{
			ShowPlayerDialogEx(playerid, MDC_FIND, DIALOG_STYLE_INPUT, "MDC - Logged in | LEO GPS Location", "Enter the Law Enforcment Official's Name or ID No.", "Enter", "Cancel");
			return 1;
		}

		if(IsPlayerConnected(giveplayerid))
		{
			if(giveplayerid != INVALID_PLAYER_ID)
			{
				if(giveplayerid == playerid)
				{
					ShowPlayerDialogEx(playerid, MDC_FIND, DIALOG_STYLE_INPUT, "MDC - Logged in | ERROR", "ERROR: You cannot find yourself.\nEnter the Law Enforcment Official's Name or ID No.", "Enter", "Cancel");

					return 1;
				}
				if(IsACop(giveplayerid) && arrGroupData[PlayerInfo[giveplayerid][pMember]][g_iAllegiance] == arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance])
				{
					SetPlayerMarkerForPlayer(playerid,giveplayerid,FIND_COLOR);
					FindingPlayer[playerid] = giveplayerid;
					FindTime[playerid] = 1;
					FindTimePoints[playerid] = 30;
				}
				else
				{
					SendClientMessageEx(playerid, COLOR_GRAD2, " You can only track other cops!");
				}
			}
		}
	}
	if(dialogid == MDC_CIVILIANS && response)
	{ //"*Check Record\n*View Arrest Reports\n*Licenses\n*Warrants\n*Issue Warrant\n*BOLO\n*Create BOLO\n*Delete"
		new WarrantString[512];
		if(!IsMDCPermitted(playerid)) return SendClientMessageEx(playerid, COLOR_LIGHTBLUE, " Login Failed. You are not permitted to use the MDC!");
		if(News[hTaken6] == 1)
		{
			format(string, sizeof(string), "%s :: Officer: %s\n", News[hAdd6], News[hContact6]);
			strcat(WarrantString, string, sizeof(WarrantString));
		}
		if(News[hTaken7] == 1)
		{
			format(string, sizeof(string), "%s :: Officer: %s\n", News[hAdd7], News[hContact7]);
			strcat(WarrantString, string, sizeof(WarrantString));
		}
		if(News[hTaken8] == 1)
		{
			format(string, sizeof(string), "%s :: Officer: %s\n", News[hAdd8], News[hContact8]);
			strcat(WarrantString, string, sizeof(WarrantString));
		}
		if(News[hTaken9] == 1)
		{
			format(string, sizeof(string), "%s :: Officer: %s\n", News[hAdd9], News[hContact9]);
			strcat(WarrantString, string, sizeof(WarrantString));
		}
		if(News[hTaken10] == 1)
		{
			format(string, sizeof(string), "%s :: Officer: %s\n", News[hAdd10], News[hContact10]);
			strcat(WarrantString, string, sizeof(WarrantString));
		}
		if(News[hTaken11] == 1)
		{
			format(string, sizeof(string), "%s :: Officer: %s\n", News[hAdd11], News[hContact11]);
			strcat(WarrantString, string, sizeof(WarrantString));
		}
		if(News[hTaken12] == 1)
		{
			format(string, sizeof(string), "%s :: Officer: %s\n", News[hAdd12], News[hContact12]);
			strcat(WarrantString, string, sizeof(WarrantString));
		}
		if(News[hTaken13] == 1)
		{
			format(string, sizeof(string), "%s :: Officer: %s\n", News[hAdd13], News[hContact13]);
			strcat(WarrantString, string, sizeof(WarrantString));
		}
		if(strlen(WarrantString) == 0)
		{
			strcat(WarrantString, "No Warrants at this time.", sizeof(WarrantString));
		}
		switch(listitem)
		{
			case 0: ShowPlayerDialogEx(playerid, MDC_CHECK, DIALOG_STYLE_INPUT, "MDC - Logged in | Records Check", "Enter the Person's Name or ID No.", "Enter", "Cancel");
			case 1: ShowPlayerDialogEx(playerid, MDC_REPORTS, DIALOG_STYLE_INPUT, "MDC - Logged in | Reports Check", "Enter the Person's Name or ID No.", "Enter", "Cancel");
			case 2: ShowPlayerDialogEx(playerid, MDC_LICENSES, DIALOG_STYLE_INPUT, "MDC - Logged in | License Check", "Enter the Person's Name or ID No.", "Enter", "Cancel");
			case 3: ShowPlayerDialogEx(playerid, MDC_WARRANTS, DIALOG_STYLE_LIST, "MDC - Logged in | Warrant List", WarrantString, "Enter", "Cancel");
			case 4: ShowPlayerDialogEx(playerid, MDC_ISSUE_SLOT, DIALOG_STYLE_LIST, "MDC - Logged in | Which Slot would you like to use?", "1\n2\n3\n4\n5\n6\n7\n8", "Enter", "Cancel");
			case 5:
			{
				new BOLOString[512];
				if(News[hTaken14] == 1)
				{
					format(string, sizeof(string), "%s :: Officer: %s\n", News[hAdd14], News[hContact14]);
					strcat(BOLOString, string, sizeof(BOLOString));
				}
				if(News[hTaken15] == 1)
				{
					format(string, sizeof(string), "%s :: Officer: %s\n", News[hAdd15], News[hContact15]);
					strcat(BOLOString, string, sizeof(BOLOString));
				}
				if(News[hTaken16] == 1)
				{
					format(string, sizeof(string), "%s :: Officer: %s\n", News[hAdd16], News[hContact16]);
					strcat(BOLOString, string, sizeof(BOLOString));
				}
				if(News[hTaken17] == 1)
				{
					format(string, sizeof(string), "%s :: Officer: %s\n", News[hAdd17], News[hContact17]);
					strcat(BOLOString, string, sizeof(BOLOString));
				}
				if(News[hTaken18] == 1)
				{
					format(string, sizeof(string), "%s :: Officer: %s\n", News[hAdd18], News[hContact18]);
					strcat(BOLOString, string, sizeof(BOLOString));
				}
				if(News[hTaken19] == 1)
				{
					format(string, sizeof(string), "%s :: Officer: %s\n", News[hAdd19], News[hContact19]);
					strcat(BOLOString, string, sizeof(BOLOString));
				}
				if(News[hTaken20] == 1)
				{
					format(string, sizeof(string), "%s :: Officer: %s\n", News[hAdd20], News[hContact20]);
					strcat(BOLOString, string, sizeof(BOLOString));
				}
				if(News[hTaken21] == 1)
				{
					format(string, sizeof(string), "%s :: Officer: %s\n", News[hAdd21], News[hContact21]);
					strcat(BOLOString, string, sizeof(BOLOString));
				}
				if(strlen(BOLOString) == 0)
				{
					strcat(BOLOString, "No BOLOs at this time.", sizeof(BOLOString));
				}
				ShowPlayerDialogEx(playerid, MDC_BOLOLIST, DIALOG_STYLE_LIST, "MDC - Logged In | BOLO List", BOLOString, "OK", "Cancel");
			}
			case 6:
			{
				ShowPlayerDialogEx(playerid, MDC_BOLO_SLOT, DIALOG_STYLE_LIST, "MDC - Logged in | Which Slot would you like to use?", "1\n2\n3\n4\n5\n6\n7\n8", "Enter", "Cancel");
			}
			case 7:
			{
				ShowPlayerDialogEx(playerid, MDC_DELETE, DIALOG_STYLE_LIST, "MDC - Logged In | Delete", "*BOLO\n*Warrant", "OK", "Cancel");
			}
		}

	}
	if(dialogid == MDC_MEMBERS && response)
	{
		if(!IsMDCPermitted(playerid)) return SendClientMessageEx(playerid, COLOR_LIGHTBLUE, " Login Failed. You are not permitted to use the MDC!");
		new MemberString[1024], giveplayer[MAX_PLAYER_NAME], badge[11];
		new rank[GROUP_MAX_RANK_LEN], division[GROUP_MAX_DIV_LEN], employer[GROUP_MAX_NAME_LEN];
		new group = ListItemTrackId[playerid][listitem];
		foreach(new i: Player)
		{
			if(PlayerInfo[i][pMember] == group)
			{
				if(strcmp(PlayerInfo[i][pBadge], "None", true) != 0) format(badge, sizeof(badge), "[%s] ", PlayerInfo[i][pBadge]);
				GetPlayerGroupInfo(i, rank, division, employer);
				giveplayer = GetPlayerNameEx(i);
				format(string, sizeof(string), "* %s%s (%s) %s Ph: %d\n", badge, rank, division,  giveplayer, PlayerInfo[i][pPnumber]);
				strcat(MemberString, string, sizeof(MemberString));
			}
		}
		if(strlen(MemberString) == 0)
		{
			strcat(MemberString, "No Members online at this time.", sizeof(MemberString));
		}
		format(string, sizeof(string), "MDC - Logged in | %s Members", arrGroupData[group][g_szGroupName]);
		ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_LIST, string, MemberString, "Select", "Cancel");
	}
	if(dialogid == MDC_WARRANTS && response)
	{
		if(!IsMDCPermitted(playerid)) return SendClientMessageEx(playerid, COLOR_LIGHTBLUE, " Login Failed. You are not permitted to use the MDC!");
		ShowPlayerDialogEx(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "MDC - Logged in | Warrants", inputtext, "OK", "Back");
	}
	if(dialogid == MDC_BOLOLIST && response)
	{
		if(!IsMDCPermitted(playerid)) return SendClientMessageEx(playerid, COLOR_LIGHTBLUE, " Login Failed. You are not permitted to use the MDC!");
		ShowPlayerDialogEx(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "MDC - Logged in | BOLO Hot Sheet", inputtext, "OK", "Back");
	}
/*	if(dialogid == MDC_CHECK && response)
	{
		if(!IsMDCPermitted(playerid)) return SendClientMessageEx(playerid, COLOR_LIGHTBLUE, " Login Failed. You are not permitted to use the MDC!");
		new giveplayerid = ReturnUser(inputtext);
		new HistoryString[1024];
		new giveplayer[MAX_PLAYER_NAME];
		giveplayer = GetPlayerNameEx(giveplayerid);
		if(giveplayerid != INVALID_PLAYER_ID)
		{
			format(string, sizeof(string), "Name : %s\n", GetPlayerNameEx(giveplayerid));
			strcat(HistoryString, string, sizeof(HistoryString));
			format(string, sizeof(string), "Crime : %s\n", PlayerCrime[giveplayerid][pAccusedof]);
			strcat(HistoryString, string, sizeof(HistoryString));
			format(string, sizeof(string), "Claimant : %s\n", PlayerCrime[giveplayerid][pVictim]);
			strcat(HistoryString, string, sizeof(HistoryString));
			format(string, sizeof(string), "Reported : %s\n", PlayerCrime[giveplayerid][pAccusing]);
			strcat(HistoryString, string, sizeof(HistoryString));
			format(string, sizeof(string), "Accused : %s\n", PlayerCrime[giveplayerid][pBplayer]);
			strcat(HistoryString, string, sizeof(HistoryString));
			if(PlayerInfo[giveplayerid][pProbationTime] != 0)
			{
				format(string, sizeof(string), "Probation : %d minutes left\n", PlayerInfo[giveplayerid][pProbationTime]);
				strcat(HistoryString, string, sizeof(HistoryString));
			}
			for(new i=0; i<MAX_PLAYERVEHICLES; i++)
			{
				if(PlayerVehicleInfo[giveplayerid][i][pvTicket] != 0)
				{
					format(string, sizeof(string), "Vehicle registration: %d | Vehicle Name: %s | Ticket: $%d.\n",PlayerVehicleInfo[giveplayerid][i][pvId],GetVehicleName(PlayerVehicleInfo[giveplayerid][i][pvId]),PlayerVehicleInfo[giveplayerid][i][pvTicket]);
					strcat(HistoryString, string, sizeof(HistoryString));
				}
			}
			ShowPlayerDialogEx(playerid, MDC_END_ID, DIALOG_STYLE_LIST, "MDC - Logged in | Criminal History", HistoryString, "OK", "Cancel");
			format(string, sizeof(string), "** DISPATCH: %s has run a check for warrants on %s **", GetPlayerNameEx(playerid), giveplayer);
			SendRadioMessage(1, COLOR_DBLUE, string);
			SendRadioMessage(2, COLOR_DBLUE, string);
			SendRadioMessage(3, COLOR_DBLUE, string);
			return 1;
		}
		else
		{
			ShowPlayerDialogEx(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "MDC - Logged in | ERROR ", "There is no record of that person.", "OK", "Cancel");
			return 1;
		}
	}*/
	if(dialogid == MDC_REPORTS && response)
	{
		if(!IsMDCPermitted(playerid)) return SendClientMessageEx(playerid, COLOR_LIGHTBLUE, " Login Failed. You are not permitted to use the MDC!");
		new giveplayerid = ReturnUser(inputtext);
		if(giveplayerid != INVALID_PLAYER_ID)
		{
			DisplayReports(playerid, giveplayerid);
			format(string, sizeof(string), "* %s has run a check for arrest reports on %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
			foreach(new i: Player)
			{
				if(PlayerInfo[playerid][pToggledChats][12] == 0)
				{
					if(PlayerInfo[i][pMember] == PlayerInfo[playerid][pMember] && PlayerInfo[playerid][pRank] >= arrGroupData[PlayerInfo[i][pMember]][g_iRadioAccess]) {
						ChatTrafficProcess(i, arrGroupData[PlayerInfo[i][pMember]][g_hRadioColour] * 256 + 255, string, 12);
					}
				}
			}
			//SendGroupMessage(GROUP_TYPE_LEA, COLOR_DBLUE, string);
			return 1;
		}
		else
		{
			ShowPlayerDialogEx(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "MDC - Logged in | ERROR ", "There is no record of that person.", "OK", "Cancel");
			return 1;
		}
	}
	if(dialogid == MDC_SHOWREPORTS && response)
	{
		new stpos = strfind(inputtext, "(");
		new fpos = strfind(inputtext, ")");
		new reportidstr[6], repid;
		strmid(reportidstr, inputtext, stpos+1, fpos);
		repid = strval(reportidstr);
		return DisplayReport(playerid, repid);
	}
	if(dialogid == DIALOG_JFINECONFIRM)
	{
		if(response)
		{
			SetPVarInt(playerid, "jGroup", listitem);
			format(string, sizeof(string), "Are you sure you want to send a portion of the fine to %s?", arrGroupData[listitem][g_szGroupName]);
			ShowPlayerDialogEx(playerid, DIALOG_JFINE, DIALOG_STYLE_MSGBOX, "Judge Fine - Confirm", string, "Confirm", "Cancel");
		}
		else {
			DeletePVar(playerid, "jGroup");
			DeletePVar(playerid, "jfined");
			DeletePVar(playerid, "judgefine");
			DeletePVar(playerid, "jreason");
			SendClientMessageEx(playerid, COLOR_GRAD2, "Fine Cancelled - retype the judge fine command to start again.");
		}
	}
	if(dialogid == DIALOG_JFINE)
	{
		if(response)
		{
			new iGroupID = GetPVarInt(playerid, "jGroup");
			new giveplayerid = GetPVarInt(playerid, "jfined");
			new judgefine = GetPVarInt(playerid, "judgefine");
			new reason[64];
			GetPVarString(playerid, "jreason", reason, 64);
			new Judicial, Group, Gov;
			GivePlayerCash(giveplayerid, -judgefine);
			Judicial = floatround( judgefine * 0.10 ); // Judicials cut - 10%
			Group = floatround ( judgefine * 0.6);  // Arresting Groups Cut - 60%
			Gov = floatround ( judgefine * 0.10);  //  Government cut = 10%
			// 20% Deleted from economy
			Tax += Gov;
			arrGroupData[PlayerInfo[playerid][pMember]][g_iBudget] += Judicial;
			arrGroupData[iGroupID][g_iBudget] += Group;
			new str[128];
			format(str, sizeof(str), "%s has been fined by $%s by Judge %s.  $%s has been sent to the %s Vault.",GetPlayerNameEx(giveplayerid), number_format(judgefine), GetPlayerNameEx(playerid), number_format(Judicial), arrGroupData[PlayerInfo[playerid][pMember]][g_szGroupName]);
			GroupPayLog(PlayerInfo[playerid][pMember], str);
			format(str, sizeof(str), "%s has been fined by $%s by Judge %s.  $%s has been sent to the %s Vault.",GetPlayerNameEx(giveplayerid), number_format(judgefine), GetPlayerNameEx(playerid), number_format(Group), arrGroupData[iGroupID][g_szGroupName]);
			GroupPayLog(iGroupID, str);
			for(new z; z < MAX_GROUPS; z++)
			{
				if(arrGroupData[z][g_iAllegiance] == 1)
				{
					if(arrGroupData[z][g_iGroupType] == GROUP_TYPE_GOV)
					{
						format(str, sizeof(str), "%s has been fined by $%s by Judge %s.  $%s has been sent to the SA Government Vault.",GetPlayerNameEx(giveplayerid), number_format(judgefine), GetPlayerNameEx(playerid), number_format(Gov));
						GroupPayLog(z, str);
						break;
					}
				}
			}
			format(string, sizeof(string), "You have fined %s $%s, reason: %s", GetPlayerNameEx(giveplayerid), number_format(judgefine), reason);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			format(string, sizeof(string), "You have been fined $%s by %s, reason: %s", number_format(judgefine), GetPlayerNameEx(playerid), reason);
			SendClientMessageEx(giveplayerid, COLOR_WHITE, string);
			format(string, sizeof(string), "%s has been fined $%s by Judge %s.  Commission has been sent to %s.", GetPlayerNameEx(giveplayerid), number_format(judgefine), GetPlayerNameEx(playerid), arrGroupData[iGroupID][g_szGroupName]);
			ABroadCast( COLOR_YELLOW, string, 2);
			format(string, sizeof(string), "%s(%d) has been fined $%s by Judge %s(%d).  Commission has been sent to %s.", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), number_format(judgefine), GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), arrGroupData[iGroupID][g_szGroupName]);
			Log("logs/rpspecial.log", string);
		}
	}
	if(dialogid == DIALOG_ARRESTREPORT)
	{
		if(response)
		{
			new moneys = GetPVarInt(playerid, "Arrest_Price"), time = GetPVarInt(playerid, "Arrest_Time"),
				bail = GetPVarInt(playerid, "Arrest_Bail"), bailprice = 15000000, // STATIC BAIL. GetPVarInt(playerid, "Arrest_BailPrice"),
				suspect = GetPVarInt(playerid, "Arrest_Suspect"), arresttype = GetPVarInt(playerid, "Arrest_Type");
			if(strlen(inputtext) < 30 || strlen(inputtext) > 128)
			{
				format(szMiscArray, sizeof(szMiscArray), "Please write a brief arrest report on how %s acted during the arrest.\n\nThis report must be at least 30 characters and no more than 128.", GetPlayerNameEx(suspect));
				return ShowPlayerDialogEx(playerid, DIALOG_ARRESTREPORT, DIALOG_STYLE_INPUT, "Arrest Report", szMiscArray, "Submit", "");
			}
			switch(arresttype)
			{
				case 0, 1: { //arrest
					if(bail && bailprice > 0)
					{
						format(string, sizeof(string), "You have been given the option to post bail. Your bail is set at $%s. (/bail)", number_format(bailprice));
						SendClientMessageEx(suspect, COLOR_RED, string);
						PlayerInfo[suspect][pBailPrice] = bailprice;
					}
					format(string, sizeof(string), "* You have sent %s to the Local PD Jail.", GetPlayerNameEx(suspect));
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
					GivePlayerCash(suspect, -moneys);
					new money = floatround(moneys / 3), iGroupID = PlayerInfo[playerid][pMember];
					arrGroupData[iGroupID][g_iBudget] += money;
					new str[164];
					format(str, sizeof(str), "%s has been arrested by %s for %d minutes and fined $%d. $%d has been sent to %s's budget fund.",GetPlayerNameEx(suspect), GetPlayerNameEx(playerid),time, moneys, money, arrGroupData[iGroupID][g_szGroupName]);
					GroupPayLog(iGroupID, str);
					for(new z; z < MAX_GROUPS; z++)
					{
						if(arrGroupData[iGroupID][g_iAllegiance] == 1)
						{
							if(arrGroupData[z][g_iAllegiance] == 1)
							{
								if(arrGroupData[z][g_iGroupType] == GROUP_TYPE_GOV)
								{
									Tax += money;
									format(str, sizeof(str), "%s has been arrested by %s and fined $%d. $%d has been sent to the SA Government Vault.",GetPlayerNameEx(suspect), GetPlayerNameEx(playerid), moneys, money);
									GroupPayLog(z, str);
									break;
								}
							}
						}
						else if(arrGroupData[z][g_iAllegiance] == 2)
						{
							if(arrGroupData[z][g_iAllegiance] == 2)
							{
								if(arrGroupData[z][g_iGroupType] == GROUP_TYPE_GOV)
								{
									TRTax += money;
									format(str, sizeof(str), "%s has been arrested by %s and fined $%d. $%d has been sent to the NE Government Vault.",GetPlayerNameEx(suspect), GetPlayerNameEx(playerid), moneys, money);
									GroupPayLog(z, str);
									break;
								}
							}
						}
					}
					ResetPlayerWeaponsEx(suspect);
					SetPlayerInterior(suspect, ArrestPoints[GetArrestPointID(playerid)][jailInt]);
					//new rand = random(sizeof(LSPDJailSpawns));
					//SetPlayerFacingAngle(suspect, LSPDJailSpawns[rand][3]);
					//SetPlayerPos(suspect, LSPDJailSpawns[rand][0], LSPDJailSpawns[rand][1], LSPDJailSpawns[rand][2]);
					switch(random(2)) {
						case 0: {
							SetPlayerPos(suspect, ArrestPoints[GetArrestPointID(playerid)][JailPos1][0], ArrestPoints[GetArrestPointID(playerid)][JailPos1][1], ArrestPoints[GetArrestPointID(playerid)][JailPos1][2]);
							Player_StreamPrep(suspect, ArrestPoints[GetArrestPointID(playerid)][JailPos1][0], ArrestPoints[GetArrestPointID(playerid)][JailPos1][1], ArrestPoints[GetArrestPointID(playerid)][JailPos1][2], FREEZE_TIME);
						}
						case 1: {
							SetPlayerPos(suspect, ArrestPoints[GetArrestPointID(playerid)][JailPos2][0], ArrestPoints[GetArrestPointID(playerid)][JailPos2][1], ArrestPoints[GetArrestPointID(playerid)][JailPos2][2]);
							Player_StreamPrep(suspect, ArrestPoints[GetArrestPointID(playerid)][JailPos2][0], ArrestPoints[GetArrestPointID(playerid)][JailPos2][1], ArrestPoints[GetArrestPointID(playerid)][JailPos2][2], FREEZE_TIME);
						}
					}
					SetPVarInt(suspect, "ArrestPoint", (GetArrestPointID(playerid) + 1));
					if(PlayerInfo[suspect][pDonateRank] >= 2)
					{
						PlayerInfo[suspect][pJailTime] = ((time*60)*75)/100;
					}
					else
					{
						PlayerInfo[suspect][pJailTime] = time * 60;
					}
					if(PlayerInfo[suspect][pJailTime] > 7200) PlayerInfo[suspect][pJailTime] = 7200;
					DeletePVar(suspect, "IsFrozen");
					PhoneOnline[suspect] = 1;
					PlayerInfo[suspect][pArrested] += 1;
					SetPlayerFree(suspect,playerid, "was arrested");
					PlayerInfo[suspect][pWantedLevel] = 0;
					SetPlayerToTeamColor(suspect);
					SetPlayerWantedLevel(suspect, 0);
					WantLawyer[suspect] = 1;
					TogglePlayerControllable(suspect, 1);
					ClearAnimationsEx(suspect);
					SetPlayerSpecialAction(suspect, SPECIAL_ACTION_NONE);
					PlayerCuffed[suspect] = 0;
					DeletePVar(suspect, "PlayerCuffed");
					PlayerCuffedTime[suspect] = 0;
					SetPlayerInterior(suspect, ArrestPoints[GetArrestPointID(playerid)][jailInt]);
					PlayerInfo[suspect][pInt] = ArrestPoints[GetArrestPointID(playerid)][jailVW];
					PlayerInfo[suspect][pVW] = ArrestPoints[GetArrestPointID(playerid)][jailVW];
					SetPlayerVirtualWorld(suspect, ArrestPoints[GetArrestPointID(playerid)][jailVW]);
					strcpy(PlayerInfo[suspect][pPrisonedBy], GetPlayerNameEx(playerid), MAX_PLAYER_NAME);
					strcpy(PlayerInfo[suspect][pPrisonReason], "[IC] EBCF", 128);
					SetPlayerToTeamColor(suspect);
					SetHealth(suspect, 100);
				}
				case 2: { // /docarrest
					format(string, sizeof(string), "* You have sent %s to DoC.", GetPlayerNameEx(suspect));
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
					GivePlayerCash(suspect, -moneys);
					new money = floatround(moneys / 3), iGroupID = PlayerInfo[playerid][pMember];
					arrGroupData[iGroupID][g_iBudget] += money;
					new str[164];
					format(str, sizeof(str), "%s has been arrested by %s for %d minutes and fined $%d. $%d has been sent to %s's budget fund.",GetPlayerNameEx(suspect), GetPlayerNameEx(playerid),time, moneys, money, arrGroupData[iGroupID][g_szGroupName]);
					GroupPayLog(iGroupID, str);
					for(new z; z < MAX_GROUPS; z++)
					{
						if(arrGroupData[iGroupID][g_iAllegiance] == 1)
						{
							if(arrGroupData[z][g_iAllegiance] == 1)
							{
								if(arrGroupData[z][g_iGroupType] == GROUP_TYPE_GOV)
								{
									Tax += money;
									format(str, sizeof(str), "%s has been arrested by %s and fined $%d. $%d has been sent to the SA Government Vault.",GetPlayerNameEx(suspect), GetPlayerNameEx(playerid), moneys, money);
									GroupPayLog(z, str);
									break;
								}
							}
						}
						else if(arrGroupData[z][g_iAllegiance] == 2)
						{
							if(arrGroupData[z][g_iAllegiance] == 2)
							{
								if(arrGroupData[z][g_iGroupType] == GROUP_TYPE_GOV)
								{
									TRTax += money;
									format(str, sizeof(str), "%s has been arrested by %s and fined $%d. $%d has been sent to the NE Government Vault.",GetPlayerNameEx(suspect), GetPlayerNameEx(playerid), moneys, money);
									GroupPayLog(z, str);
									break;
								}
							}
						}
					}
					ResetPlayerWeaponsEx(suspect);
					SetPlayerInterior(suspect, 1);
					PlayerInfo[suspect][pInt] = 1;
					SetPlayerFacingAngle(suspect, 0);
					if(PlayerInfo[suspect][pDonateRank] >= 2)
					{
						PlayerInfo[suspect][pJailTime] = ((time*60)*75)/100;
					}
					else
					{
						PlayerInfo[suspect][pJailTime] = time * 60;
					}
					if(PlayerInfo[suspect][pJailTime] > 7200) PlayerInfo[suspect][pJailTime] = 7200;
					DeletePVar(suspect, "IsFrozen");
					PhoneOnline[suspect] = 1;
					PlayerInfo[suspect][pArrested] += 1;
					SetPlayerFree(suspect,playerid, "was arrested");
					PlayerInfo[suspect][pWantedLevel] = 0;
					SetPlayerToTeamColor(suspect);
					SetPlayerWantedLevel(suspect, 0);
					WantLawyer[suspect] = 1;
					TogglePlayerControllable(suspect, 1);
					ClearAnimationsEx(suspect);
					SetPlayerSpecialAction(suspect, SPECIAL_ACTION_NONE);
					PlayerCuffed[suspect] = 0;
					DeletePVar(suspect, "PlayerCuffed");
					PlayerCuffedTime[suspect] = 0;
					PlayerInfo[suspect][pVW] = 0;
					SetPlayerVirtualWorld(suspect, 0);
					SetHealth(suspect, 100);
					strcpy(PlayerInfo[suspect][pPrisonedBy], GetPlayerNameEx(playerid), MAX_PLAYER_NAME);
					strcpy(PlayerInfo[suspect][pPrisonReason], "[IC] DMCF Arrest", 128);
					SetPlayerToTeamColor(suspect);
					SetHealth(suspect, 100);
					new randcell = random(29);
					PlayerInfo[suspect][pPrisonCell] = randcell;
					SpawnPlayerInPrisonCell(suspect, randcell);
				}
				case 3: // doc judge arrest
				{
					format(string, sizeof(string), "* You have sentenced %s at the DoC courthouse.", GetPlayerNameEx(suspect));
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
					GivePlayerCash(suspect, -moneys);
					new money = floatround(moneys / 3), iGroupID = PlayerInfo[playerid][pMember];
					arrGroupData[iGroupID][g_iBudget] += money;
					new str[164];
					format(str, sizeof(str), "%s has been arrested by %s for %d minutes and fined $%d. $%d has been sent to %s's budget fund.",GetPlayerNameEx(suspect), GetPlayerNameEx(playerid),time, moneys, money, arrGroupData[iGroupID][g_szGroupName]);
					GroupPayLog(iGroupID, str);
					for(new z; z < MAX_GROUPS; z++)
					{
						if(arrGroupData[iGroupID][g_iAllegiance] == 1)
						{
							if(arrGroupData[z][g_iAllegiance] == 1)
							{
								if(arrGroupData[z][g_iGroupType] == GROUP_TYPE_GOV)
								{
									Tax += money;
									format(str, sizeof(str), "%s has been arrested by %s and fined $%d. $%d has been sent to the SA Government Vault.",GetPlayerNameEx(suspect), GetPlayerNameEx(playerid), moneys, money);
									GroupPayLog(z, str);
									break;
								}
							}
						}
						else if(arrGroupData[z][g_iAllegiance] == 2)
						{
							if(arrGroupData[z][g_iAllegiance] == 2)
							{
								if(arrGroupData[z][g_iGroupType] == GROUP_TYPE_GOV)
								{
									TRTax += money;
									format(str, sizeof(str), "%s has been arrested by %s and fined $%d. $%d has been sent to the NE Government Vault.",GetPlayerNameEx(suspect), GetPlayerNameEx(playerid), moneys, money);
									GroupPayLog(z, str);
									break;
								}
							}
						}
					}
					if(PlayerInfo[suspect][pDonateRank] >= 2)
					{
						PlayerInfo[suspect][pJailTime] = ((time*60)*75)/100;
					}
					else
					{
						PlayerInfo[suspect][pJailTime] = time * 60;
					}
					PhoneOnline[suspect] = 1;
					PlayerInfo[suspect][pArrested] += 1;
					SetPlayerFree(suspect,playerid, "was arrested");
					PlayerInfo[suspect][pWantedLevel] = 0;
					SetPlayerToTeamColor(suspect);
					SetPlayerWantedLevel(suspect, 0);
					SetPVarInt(playerid, "pTut", 0);
					strcpy(PlayerInfo[suspect][pPrisonedBy], GetPlayerNameEx(playerid), MAX_PLAYER_NAME);
					strcpy(PlayerInfo[suspect][pPrisonReason], "[IC][JUDGE] EBCF Arrest", 128);
					SetPlayerToTeamColor(suspect);
				}
			}
			new iAllegiance;
			if((0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS))
			{
				iAllegiance = arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance];
			}
			else iAllegiance = 1;
			mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "INSERT INTO `arrestreports` (`copid`, `suspectid`, `shortreport`, `origin`) VALUES ('%d', '%d', '%e', '%d')", GetPlayerSQLId(playerid), GetPlayerSQLId(suspect), inputtext, iAllegiance);
			mysql_tquery(MainPipeline, szMiscArray, "OnQueryFinish", "i", SENDDATA_THREAD);
			format(szMiscArray, sizeof(szMiscArray), "You have arrested %s for %d minutes with a fine of $%s", GetPlayerNameEx(suspect), time, number_format(moneys));
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMiscArray);
			PlayerInfo[suspect][pWantedJailFine] = 0;
			PlayerInfo[suspect][pWantedJailTime] = 0;
			Prison_SetPlayerSkin(suspect);
			for(new x;x<MAX_PLAYERTOYS;x++) {
				if(IsPlayerAttachedObjectSlotUsed(suspect, x))
				{
					if(x == 9 && PlayerInfo[suspect][pBEquipped])
						break;
					RemovePlayerAttachedObject(suspect, x);
				}
			}
			for(new i; i < 10; i++) {
				PlayerHoldingObject[suspect][i] = 0;
			}
			DeletePVar(suspect, "jailcuffs");
			DeletePVar(playerid, "Arrest_Price");
			DeletePVar(playerid, "Arrest_Time");
			DeletePVar(playerid, "Arrest_Bail");
			DeletePVar(playerid, "Arrest_BailPrice");
			DeletePVar(playerid, "Arrest_Suspect");
		}
	}
	if(dialogid == MDC_CHECK && response)
	{
		if(!IsMDCPermitted(playerid)) return SendClientMessageEx(playerid, COLOR_LIGHTBLUE, " Login Failed. You are not permitted to use the MDC!");
		new giveplayerid = ReturnUser(inputtext);
		if(giveplayerid != INVALID_PLAYER_ID)
		{
			DisplayCrimes(playerid, giveplayerid);
			format(string, sizeof(string), "* %s has run a check for warrants on %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
			foreach(new i: Player)
			{
				if(PlayerInfo[playerid][pToggledChats][12] == 0)
				{
					if(PlayerInfo[i][pMember] == PlayerInfo[playerid][pMember] && PlayerInfo[playerid][pRank] >= arrGroupData[PlayerInfo[i][pMember]][g_iRadioAccess]) {
						ChatTrafficProcess(i, arrGroupData[PlayerInfo[i][pMember]][g_hRadioColour] * 256 + 255, string, 12);
					}
				}
			}
			//SendGroupMessage(GROUP_TYPE_LEA, COLOR_DBLUE, string);
			return 1;
		}
		else
		{
			ShowPlayerDialogEx(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "MDC - Logged in | ERROR ", "There is no record of that person.", "OK", "Cancel");
			return 1;
		}
	}
	if(dialogid == MDC_LICENSES && response)
	{
		if(!IsMDCPermitted(playerid)) return SendClientMessageEx(playerid, COLOR_LIGHTBLUE, " Login Failed. You are not permitted to use the MDC!");
		new giveplayerid;
		if(sscanf(inputtext, "u", giveplayerid))
		{
			ShowPlayerDialogEx(playerid, MDC_LICENSES, DIALOG_STYLE_INPUT, "MDC - Logged in | License Check", "Enter the Person's Name or ID No.", "Enter", "Cancel");
			return 1;
		}
		if(IsPlayerConnected(giveplayerid))
		{
			if(giveplayerid != INVALID_PLAYER_ID)
			{
				new LicenseString[256], giveplayer[MAX_PLAYER_NAME];
				GetPlayerName(playerid, sendername, sizeof(sendername));
				GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
				format(string, sizeof(string), "   Name: %s\n", giveplayer);
				strcat(LicenseString, string, sizeof(LicenseString));
				format(string, sizeof(string), "-Drivers License: %s%s.\n", !PlayerInfo[giveplayerid][pCarLic] ? ("Not Passed"):("Expires: "), !PlayerInfo[giveplayerid][pCarLic] ? (""):date(PlayerInfo[giveplayerid][pCarLic], 1));
				strcat(LicenseString, string, sizeof(LicenseString));
				format(string, sizeof(string), "-Flying License: %s.\n", PlayerInfo[giveplayerid][pFlyLic] ? ("Passed"):("Not Passed"));
				strcat(LicenseString, string, sizeof(LicenseString));
				format(string, sizeof(string), "-Sailing License: %s.\n", PlayerInfo[giveplayerid][pBoatLic] ? ("Passed"):("Not Passed"));
				strcat(LicenseString, string, sizeof(LicenseString));
				format(string, sizeof(string), "-Weapon License: %s.\n", PlayerInfo[giveplayerid][pGunLic] ? ("Passed"):("Not Passed"));
				strcat(LicenseString, string, sizeof(LicenseString));
				ShowPlayerDialogEx(playerid, MDC_END_ID, DIALOG_STYLE_LIST, "MDC - Logged in | Criminal History", LicenseString, "OK", "Cancel");
				format(string, sizeof(string), "* %s has ran a license check on %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
				foreach(new i: Player)
				{
					if(PlayerInfo[playerid][pToggledChats][12] == 0)
					{
						if(PlayerInfo[i][pMember] == PlayerInfo[playerid][pMember] && PlayerInfo[playerid][pRank] >= arrGroupData[PlayerInfo[i][pMember]][g_iRadioAccess]) {
							ChatTrafficProcess(i, arrGroupData[PlayerInfo[i][pMember]][g_hRadioColour] * 256 + 255, string, 12);
						}
					}
				}
				return 1;
			}
			else return ShowPlayerDialogEx(playerid, MDC_LICENSES, DIALOG_STYLE_INPUT, "MDC - Logged in | Error!", "ERROR: Invalid Name or ID No.\nEnter the Person's Name or ID No.", "Enter", "Cancel");
		}
		else return ShowPlayerDialogEx(playerid, MDC_LICENSES, DIALOG_STYLE_INPUT, "MDC - Logged in | Error!", "ERROR: Invalid Name or ID No.\nEnter the Person's Name or ID No.", "Enter", "Cancel");
	}
	if(dialogid == MDC_MESSAGE && response)
	{
		if(!IsMDCPermitted(playerid)) return SendClientMessageEx(playerid, COLOR_LIGHTBLUE, " Login Failed. You are not permitted to use the MDC!");
		new giveplayerid;
		if(sscanf(inputtext, "u", giveplayerid))
		{
			return ShowPlayerDialogEx(playerid, MDC_MESSAGE, DIALOG_STYLE_INPUT, "MDC - Logged In | Error!", "ERROR: Invalid Recipient\nEnter recipient's Name or ID No.", "OK", "Cancel");
		}
		if (IsPlayerConnected(giveplayerid))
		{
			if(giveplayerid != INVALID_PLAYER_ID)
			{
				format(string, sizeof(string), " Enter your message to %s ", GetPlayerNameEx(giveplayerid));
				ShowPlayerDialogEx(playerid, MDC_MESSAGE_2, DIALOG_STYLE_INPUT, "MDC - Logged In | MDC Message", string, "OK", "Cancel");
				SetPVarInt(playerid, "MDCMessageRecipient", giveplayerid);
			}
			else  return ShowPlayerDialogEx(playerid, MDC_MESSAGE, DIALOG_STYLE_INPUT, "MDC - Logged In | Error!", "ERROR: Invalid Recipient\nEnter recipient's Name or ID No.", "OK", "Cancel");
		}
		else return ShowPlayerDialogEx(playerid, MDC_MESSAGE, DIALOG_STYLE_INPUT, "MDC - Logged In | Error!", "ERROR: Invalid Recipient\nEnter recipient's Name or ID No.", "OK", "Cancel");
	}
	if(dialogid == MDC_SMS && response)
	{
		if(isnull(inputtext) || strval(inputtext) == 0)
		{
			return ShowPlayerDialogEx(playerid, MDC_SMS, DIALOG_STYLE_INPUT, "MDC - Logged In | Error!", "ERROR: Invalid Phone Number\nEnter Recipient's Phone Number", "OK", "Cancel");
		}
		new phonenumb = strval(inputtext);
		format(string, sizeof(string), " Enter your message to %d ", phonenumb);
		ShowPlayerDialogEx(playerid, MDC_SMS_2, DIALOG_STYLE_INPUT, "MDC - Logged In | SMS Message", string, "OK", "Cancel");
		SetPVarInt(playerid, "SMSMessageRecipient", phonenumb);
	}
	if(dialogid == MDC_MESSAGE_2 && response)
	{
		new giveplayerid = GetPVarInt(playerid, "MDCMessageRecipient");
		if(giveplayerid == INVALID_PLAYER_ID) return ShowPlayerDialogEx(playerid, MDC_MESSAGE, DIALOG_STYLE_INPUT, "MDC - Logged In | Error!", "ERROR: Invalid Recipient\nEnter recipient's Name or ID No.", "OK", "Cancel");
		if(giveplayerid == playerid)
		{
			ShowPlayerDialogEx(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "MDC - Logged in | ERROR ", "You cannot send messages to yourself!", "OK", "Cancel");
			return 1;
		}
		if(ConnectedToPC[giveplayerid] == 1337 || IsPlayerInAnyVehicle(giveplayerid))
		{
			if(!IsMDCPermitted(giveplayerid))
			{
				return ShowPlayerDialogEx(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "MDC - Logged in | ERROR ", "That person is not logged into the MDC.", "OK", "Cancel");
			}
			if(!strlen(inputtext))
			{
				return ShowPlayerDialogEx(playerid, MDC_MESSAGE_2, DIALOG_STYLE_INPUT, "MDC - Logged In | Error!", "ERROR: You must type a message!\nEnter Recipient's Name or ID No.", "OK", "Cancel");
			}
			format(string, sizeof(string), "MDC Message sent to %s:\n%s", GetPlayerNameEx(giveplayerid), inputtext);
			ShowPlayerDialogEx(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "MDC - Logged in | Message Sent! ", string, "OK", "Cancel");
			if(ConnectedToPC[giveplayerid] == 1337)
			{
				format(string, sizeof(string), "MDC Message from %s:\n%s", GetPlayerNameEx(playerid), inputtext);
				ShowPlayerDialogEx(giveplayerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "MDC - Logged in | New Message!", string, "OK", "Cancel");
				format(string, sizeof(string), "MDC Message from %s: %s", GetPlayerNameEx(playerid), inputtext);
				SendClientMessageEx(giveplayerid, COLOR_YELLOW, string);
			}
			else
			{
				format(string, sizeof(string), "MDC Message from %s:\n%s", GetPlayerNameEx(playerid), inputtext);
				ShowPlayerDialogEx(giveplayerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "MDC - Logged in | New Message! ", string, "OK", "Cancel");
			}
		}
		else
		{
			ShowPlayerDialogEx(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "MDC - Logged in | ERROR ", "That officer is not logged into the MDC.", "OK", "Cancel");
			return 1;
		}
		return 1;
	}
	if(dialogid == MDC_SMS_2 && response)
	{
		new phonenumb = GetPVarInt(playerid, "SMSMessageRecipient");
		if(!strlen(inputtext))
		{
			return ShowPlayerDialogEx(playerid, MDC_SMS_2, DIALOG_STYLE_INPUT, "MDC - Logged In | Error!", "ERROR: You must type a message!\nEnter Recipient's Phone Number", "OK", "Cancel");
		}
		if(phonenumb == 555)
		{
			if(strcmp("yes", inputtext, true) == 0) {
				SendClientMessageEx(playerid, COLOR_WHITE, "Text Message Delivered.");
				SendClientMessageEx(playerid, COLOR_YELLOW, "SMS: I have no idea what you're talking about, Sender: MOLE (555)");
				//SendAudioToPlayer(playerid, 47, 100);
				RingTone[playerid] = 20;
				return 0;
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_YELLOW, "SMS: A simple 'yes' will do, Sender: MOLE (555)");
				//SendAudioToPlayer(playerid, 47, 100);
				RingTone[playerid] = 20;
				//ChatLog(string);
				return 0;
			}
		}
		foreach(new i: Player)
		{
			if(PlayerInfo[i][pPnumber] == phonenumb && phonenumb != 0)
			{
				if(PhoneOnline[i] > 0)
				{
					SendClientMessageEx(playerid, COLOR_GREY, "That player's phone is switched off.");
					return 1;
				}
				format(string, sizeof(string), "SMS: %s, Sender: %s (Ph: %d)", inputtext, GetPlayerNameEx(playerid),PlayerInfo[playerid][pPnumber]);
				GetPlayerName(i, sendername, sizeof(sendername));
				ShowPlayerDialogEx(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "MDC - Logged in | Message Sent! ", string, "OK", "Cancel");
				SendClientMessageEx(i, COLOR_YELLOW, string);
				return 1;
			}
		}
		ShowPlayerDialogEx(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "MDC - Logged in | Message Delivery Failed! ", "Message Delivery Failed. Try Again", "OK", "Cancel");
	}
	if(dialogid == MDC_BOLO && response)
	{
		new x_nr = GetPVarInt(playerid, "BOLOISSUESLOT");
		if(x_nr == 1)
		{
			if(News[hTaken14] == 0)
			{
				GetPlayerName(playerid, sendername, sizeof(sendername));
				if(strlen(inputtext) < 9) { ShowPlayerDialogEx(playerid, MDC_BOLO, DIALOG_STYLE_INPUT, "MDC - Logged in | ERROR", "ERROR: Must Be 9+ characters\nEnter BOLO Details", "Enter", "Cancel"); return 1; }
				format(string, sizeof(string), "%s",inputtext); strmid(News[hAdd14], string, 0, strlen(string), 255);
				format(string, sizeof(string), "%s",sendername); strmid(News[hContact14], string, 0, strlen(string), 255);
				News[hTaken14] = 1;
				ShowPlayerDialogEx(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "MDC - Logged in | Success! ","* You placed details for a BOLO on the MDC -BOLO\nto see the current BOLO List browse to BOLO when logged in to the mdc", "OK", "Back");
				SendGroupMessage(GROUP_TYPE_LEA, COLOR_LIGHTBLUE, "** MDC: Details for a BOLO have been updated.");
				return 1;
			}
			else
			{
				ShowPlayerDialogEx(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "MDC - Logged in | Error! ", "Spot 1 is already Taken!", "OK", "Back");
				return 1;
			}
		}
		if(x_nr == 2)
		{
			if(News[hTaken15] == 0)
			{
				GetPlayerName(playerid, sendername, sizeof(sendername));
				if(strlen(inputtext) < 9) { ShowPlayerDialogEx(playerid, MDC_BOLO, DIALOG_STYLE_INPUT, "MDC - Logged in | ERROR", "ERROR: Must Be 9+ characters\nEnter BOLO Details", "Enter", "Cancel"); return 1; }
				format(string, sizeof(string), "%s",inputtext); strmid(News[hAdd15], string, 0, strlen(string), 255);
				format(string, sizeof(string), "%s",sendername); strmid(News[hContact15], string, 0, strlen(string), 255);
				News[hTaken15] = 1;
				ShowPlayerDialogEx(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "MDC - Logged in | Success! ","* You placed details for a BOLO on the MDC -BOLO\nto see the current BOLO List browse to BOLO when logged in to the mdc", "OK", "Back");
				SendGroupMessage(GROUP_TYPE_LEA, COLOR_LIGHTBLUE, "** MDC: Details for a BOLO have been updated.");
				return 1;
			}
			else
			{
				ShowPlayerDialogEx(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "MDC - Logged in | Error! ", "Spot 2 is already Taken!", "OK", "Back");
				return 1;
			}
		}
		if(x_nr == 3)
		{
			if(News[hTaken16] == 0)
			{
				GetPlayerName(playerid, sendername, sizeof(sendername));
				if(strlen(inputtext) < 9) { ShowPlayerDialogEx(playerid, MDC_BOLO, DIALOG_STYLE_INPUT, "MDC - Logged in | ERROR", "ERROR: Must Be 9+ characters\nEnter BOLO Details", "Enter", "Cancel"); return 1; }
				format(string, sizeof(string), "%s",inputtext); strmid(News[hAdd16], string, 0, strlen(string), 255);
				format(string, sizeof(string), "%s",sendername); strmid(News[hContact16], string, 0, strlen(string), 255);
				News[hTaken16] = 1;
				ShowPlayerDialogEx(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "MDC - Logged in | Success! ","* You placed details for a BOLO on the MDC -BOLO\nto see the current BOLO List browse to BOLO when logged in to the mdc", "OK", "Back");
				SendGroupMessage(GROUP_TYPE_LEA, COLOR_LIGHTBLUE, "** MDC: Details for a BOLO have been updated.");
				return 1;
			}
			else
			{
				ShowPlayerDialogEx(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "MDC - Logged in | Error! ", "Spot 3 is already Taken!", "OK", "Back");
				return 1;
			}
		}
		if(x_nr == 4)
		{
			if(News[hTaken17] == 0)
			{
				GetPlayerName(playerid, sendername, sizeof(sendername));
				if(strlen(inputtext) < 9) { ShowPlayerDialogEx(playerid, MDC_BOLO, DIALOG_STYLE_INPUT, "MDC - Logged in | ERROR", "ERROR: Must Be 9+ characters\nEnter BOLO Details", "Enter", "Cancel"); return 1; }
				format(string, sizeof(string), "%s",inputtext); strmid(News[hAdd17], string, 0, strlen(string), 255);
				format(string, sizeof(string), "%s",sendername); strmid(News[hContact17], string, 0, strlen(string), 255);
				News[hTaken17] = 1;
				ShowPlayerDialogEx(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "MDC - Logged in | Success! ","* You placed details for a BOLO on the MDC -BOLO\nto see the current BOLO List browse to BOLO when logged in to the mdc", "OK", "Back");
				SendGroupMessage(GROUP_TYPE_LEA, COLOR_LIGHTBLUE, "** MDC: Details for a BOLO have been updated.");
				return 1;
			}
			else
			{
				ShowPlayerDialogEx(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "MDC - Logged in | Error! ", "Spot 4 is already Taken!", "OK", "Back");
				return 1;
			}
		}
		if(x_nr == 5)
		{
			if(News[hTaken18] == 0)
			{
				GetPlayerName(playerid, sendername, sizeof(sendername));
				if(strlen(inputtext) < 9) { ShowPlayerDialogEx(playerid, MDC_BOLO, DIALOG_STYLE_INPUT, "MDC - Logged in | ERROR", "ERROR: Must Be 9+ characters\nEnter BOLO Details", "Enter", "Cancel"); return 1; }
				format(string, sizeof(string), "%s",inputtext); strmid(News[hAdd18], string, 0, strlen(string), 255);
				format(string, sizeof(string), "%s",sendername); strmid(News[hContact18], string, 0, strlen(string), 255);
				News[hTaken18] = 1;
				ShowPlayerDialogEx(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "MDC - Logged in | Success! ","* You placed details for a BOLO on the MDC -BOLO\nto see the current BOLO List browse to BOLO when logged in to the mdc", "OK", "Back");
				SendGroupMessage(GROUP_TYPE_LEA, COLOR_LIGHTBLUE, "** MDC: Details for a BOLO have been updated.");
				return 1;
			}
			else
			{
				ShowPlayerDialogEx(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "MDC - Logged in | Error! ", "Spot 5 is already Taken!", "OK", "Back");
				return 1;
			}
		}
		if(x_nr == 6)
		{
			if(News[hTaken19] == 0)
			{
				GetPlayerName(playerid, sendername, sizeof(sendername));
				if(strlen(inputtext) < 9) { ShowPlayerDialogEx(playerid, MDC_BOLO, DIALOG_STYLE_INPUT, "MDC - Logged in | ERROR", "ERROR: Must Be 9+ characters\nEnter BOLO Details", "Enter", "Cancel"); return 1; }
				format(string, sizeof(string), "%s",inputtext); strmid(News[hAdd19], string, 0, strlen(string), 255);
				format(string, sizeof(string), "%s",sendername); strmid(News[hContact19], string, 0, strlen(string), 255);
				News[hTaken19] = 1;
				ShowPlayerDialogEx(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "MDC - Logged in | Success! ","* You placed details for a BOLO on the MDC -BOLO\nto see the current BOLO List browse to BOLO when logged in to the mdc", "OK", "Back");
				SendGroupMessage(GROUP_TYPE_LEA, COLOR_LIGHTBLUE, "** MDC: Details for a BOLO have been updated.");
				return 1;
			}
			else
			{
				ShowPlayerDialogEx(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "MDC - Logged in | Error! ", "Spot 6 is already Taken!", "OK", "Back");
				return 1;
			}
		}
		if(x_nr == 7)
		{
			if(News[hTaken20] == 0)
			{
				GetPlayerName(playerid, sendername, sizeof(sendername));
				if(strlen(inputtext) < 9) { ShowPlayerDialogEx(playerid, MDC_BOLO, DIALOG_STYLE_INPUT, "MDC - Logged in | ERROR", "ERROR: Must Be 9+ characters\nEnter BOLO Details", "Enter", "Cancel"); return 1; }
				format(string, sizeof(string), "%s",inputtext); strmid(News[hAdd20], string, 0, strlen(string), 255);
				format(string, sizeof(string), "%s",sendername); strmid(News[hContact20], string, 0, strlen(string), 255);
				News[hTaken20] = 1;
				ShowPlayerDialogEx(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "MDC - Logged in | Success! ","* You placed details for a BOLO on the MDC -BOLO\nto see the current BOLO List browse to BOLO when logged in to the mdc", "OK", "Back");
				SendGroupMessage(GROUP_TYPE_LEA, COLOR_LIGHTBLUE, "** MDC: Details for a BOLO have been updated.");
				return 1;
			}
			else
			{
				ShowPlayerDialogEx(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "MDC - Logged in | Error! ", "Spot 7 is already Taken!", "OK", "Back");
				return 1;
			}
		}
		if(x_nr == 8)
		{
			if(News[hTaken21] == 0)
			{
				GetPlayerName(playerid, sendername, sizeof(sendername));
				if(strlen(inputtext) < 9) { ShowPlayerDialogEx(playerid, MDC_BOLO, DIALOG_STYLE_INPUT, "MDC - Logged in | ERROR", "ERROR: Must Be 9+ characters\nEnter BOLO Details", "Enter", "Cancel"); return 1; }
				format(string, sizeof(string), "%s",inputtext); strmid(News[hAdd21], string, 0, strlen(string), 255);
				format(string, sizeof(string), "%s",sendername); strmid(News[hContact21], string, 0, strlen(string), 255);
				News[hTaken21] = 1;
				ShowPlayerDialogEx(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "MDC - Logged in | Success! ","* You placed details for a BOLO on the MDC -BOLO\nto see the current BOLO List browse to BOLO when logged in to the mdc", "OK", "Back");
				SendGroupMessage(GROUP_TYPE_LEA, COLOR_LIGHTBLUE, "** MDC: Details for a BOLO have been updated.");
				return 1;
			}
			else
			{
				ShowPlayerDialogEx(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "MDC - Logged in | Error! ", "Spot 8 is already Taken!", "OK", "Back");
				return 1;
			}
		}
	}
	if(dialogid == MDC_BOLO_SLOT && response)
	{
		SetPVarInt(playerid, "BOLOISSUESLOT", listitem + 1);
		ShowPlayerDialogEx(playerid, MDC_BOLO, DIALOG_STYLE_INPUT, "MDC - Logged in | Issue Warrant", "Enter BOLO Details", "Enter", "Cancel");
	}
	if(dialogid == MDC_ISSUE_SLOT && response)
	{
		SetPVarInt(playerid, "ISSUESLOT", listitem + 1);
		ShowPlayerDialogEx(playerid, MDC_ISSUE, DIALOG_STYLE_INPUT, "MDC - Logged in | Issue Warrant", "Enter Arrest Warrant Details", "Enter", "Cancel");
	}
	if(dialogid == MDC_END_ID && response)
	{
		ShowPlayerDialogEx(playerid, MDC_MAIN, DIALOG_STYLE_LIST, "MDC - Logged in", "*Civilian Information\n*Register Suspect\n*Clear Suspect\n*Vehicle registrations\n*Find LEO\n*Law Enforcement Agencies\n*MDC Message\n*SMS", "OK", "Cancel");
	}
	if(dialogid == MDC_ISSUE && response)
	{
		new x_nr = GetPVarInt(playerid, "ISSUESLOT");
		if(x_nr == 1)
		{
			if(News[hTaken6] == 0)
			{
				GetPlayerName(playerid, sendername, sizeof(sendername));
				if(strlen(inputtext) < 9) { ShowPlayerDialogEx(playerid, MDC_ISSUE, DIALOG_STYLE_INPUT, "MDC - Logged in | ERROR", "ERROR: Must Be 9+ characters\nEnter Arrest Warrant Details", "Enter", "Cancel"); return 1; }
				format(string, sizeof(string), "%s",inputtext); strmid(News[hAdd6], string, 0, strlen(string), 255);
				format(string, sizeof(string), "%s",sendername); strmid(News[hContact6], string, 0, strlen(string), 255);
				News[hTaken6] = 1;
				ShowPlayerDialogEx(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "MDC - Logged in | Success! ","* You placed details for an arrest warrant on the MDC -Warrants\nto see the current Warrants browse to Warrants when logged in to the mdc", "OK", "Back");
				SendGroupMessage(GROUP_TYPE_LEA, COLOR_LIGHTBLUE, "** MDC: Details for an arrest warrant have been updated.");
				return 1;
			}
			else
			{
				ShowPlayerDialogEx(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "MDC - Logged in | Error! ", "Spot 1 is already Taken!", "OK", "Back");
				return 1;
			}
		}
		if(x_nr == 2)
		{
			if(News[hTaken7] == 0)
			{
				GetPlayerName(playerid, sendername, sizeof(sendername));
				if(strlen(inputtext) < 9) { ShowPlayerDialogEx(playerid, MDC_ISSUE, DIALOG_STYLE_INPUT, "MDC - Logged in | ERROR", "ERROR: Must Be 9+ characters\nEnter Arrest Warrant Details", "Enter", "Cancel"); return 1; }
				format(string, sizeof(string), "%s",inputtext); strmid(News[hAdd7], string, 0, strlen(string), 255);
				format(string, sizeof(string), "%s",sendername); strmid(News[hContact7], string, 0, strlen(string), 255);
				News[hTaken7] = 1;
				ShowPlayerDialogEx(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "MDC - Logged in | Success! ","* You placed details for an arrest warrant on the MDC -Warrants\nto see the current Warrants browse to Warrants when logged in to the mdc", "OK", "Back");
				SendGroupMessage(GROUP_TYPE_LEA, COLOR_LIGHTBLUE, "** MDC: Details for an arrest warrant have been updated.");
				return 1;
			}
			else
			{
				ShowPlayerDialogEx(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "MDC - Logged in | Error! ", "Spot 2 is already Taken!", "OK", "Back");
				return 1;
			}
		}
		if(x_nr == 3)
		{
			if(News[hTaken8] == 0)
			{
				GetPlayerName(playerid, sendername, sizeof(sendername));
				if(strlen(inputtext) < 9) { ShowPlayerDialogEx(playerid, MDC_ISSUE, DIALOG_STYLE_INPUT, "MDC - Logged in | ERROR", "ERROR: Must Be 9+ characters\nEnter Arrest Warrant Details", "Enter", "Cancel"); return 1; }
				format(string, sizeof(string), "%s",inputtext); strmid(News[hAdd8], string, 0, strlen(string), 255);
				format(string, sizeof(string), "%s",sendername); strmid(News[hContact8], string, 0, strlen(string), 255);
				News[hTaken8] = 1;
				ShowPlayerDialogEx(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "MDC - Logged in | Success! ","* You placed details for an arrest warrant on the MDC -Warrants\nto see the current Warrants browse to Warrants when logged in to the mdc", "OK", "Back");
				SendGroupMessage(GROUP_TYPE_LEA, COLOR_LIGHTBLUE, "** MDC: Details for an arrest warrant have been updated.");
				return 1;
			}
			else
			{
				ShowPlayerDialogEx(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "MDC - Logged in | Error! ", "Spot 3 is already Taken!", "OK", "Back");
				return 1;
			}
		}
		if(x_nr == 4)
		{
			if(News[hTaken9] == 0)
			{
				GetPlayerName(playerid, sendername, sizeof(sendername));
				if(strlen(inputtext) < 9) { ShowPlayerDialogEx(playerid, MDC_ISSUE, DIALOG_STYLE_INPUT, "MDC - Logged in | ERROR", "ERROR: Must Be 9+ characters\nEnter Arrest Warrant Details", "Enter", "Cancel"); return 1; }
				format(string, sizeof(string), "%s",inputtext); strmid(News[hAdd9], string, 0, strlen(string), 255);
				format(string, sizeof(string), "%s",sendername); strmid(News[hContact9], string, 0, strlen(string), 255);
				News[hTaken9] = 1;
				ShowPlayerDialogEx(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "MDC - Logged in | Success! ","* You placed details for an arrest warrant on the MDC -Warrants\nto see the current Warrants browse to Warrants when logged in to the mdc", "OK", "Back");
				SendGroupMessage(GROUP_TYPE_LEA, COLOR_LIGHTBLUE, "** MDC: Details for an arrest warrant have been updated.");
				return 1;
			}
			else
			{
				ShowPlayerDialogEx(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "MDC - Logged in | Error! ", "Spot 4 is already Taken!", "OK", "Back");
				return 1;
			}
		}
		if(x_nr == 5)
		{
			if(News[hTaken10] == 0)
			{
				GetPlayerName(playerid, sendername, sizeof(sendername));
				if(strlen(inputtext) < 9) { ShowPlayerDialogEx(playerid, MDC_ISSUE, DIALOG_STYLE_INPUT, "MDC - Logged in | ERROR", "ERROR: Must Be 9+ characters\nEnter Arrest Warrant Details", "Enter", "Cancel"); return 1; }
				format(string, sizeof(string), "%s",inputtext); strmid(News[hAdd10], string, 0, strlen(string), 255);
				format(string, sizeof(string), "%s",sendername); strmid(News[hContact10], string, 0, strlen(string), 255);
				News[hTaken10] = 1;
				ShowPlayerDialogEx(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "MDC - Logged in | Success! ","* You placed details for an arrest warrant on the MDC -Warrants\nto see the current Warrants browse to Warrants when logged in to the mdc", "OK", "Back");
				SendGroupMessage(GROUP_TYPE_LEA, COLOR_LIGHTBLUE, "** MDC: Details for an arrest warrant have been updated.");
				return 1;
			}
			else
			{
				ShowPlayerDialogEx(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "MDC - Logged in | Error! ", "Spot 5 is already Taken!", "OK", "Back");
				return 1;
			}
		}
		if(x_nr == 6)
		{
			if(News[hTaken11] == 0)
			{
				GetPlayerName(playerid, sendername, sizeof(sendername));
				if(strlen(inputtext) < 9) { ShowPlayerDialogEx(playerid, MDC_ISSUE, DIALOG_STYLE_INPUT, "MDC - Logged in | ERROR", "ERROR: Must Be 9+ characters\nEnter Arrest Warrant Details", "Enter", "Cancel"); return 1; }
				format(string, sizeof(string), "%s",inputtext); strmid(News[hAdd11], string, 0, strlen(string), 255);
				format(string, sizeof(string), "%s",sendername); strmid(News[hContact11], string, 0, strlen(string), 255);
				News[hTaken11] = 1;
				ShowPlayerDialogEx(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "MDC - Logged in | Success! ","* You placed details for an arrest warrant on the MDC -Warrants\nto see the current Warrants browse to Warrants when logged in to the mdc", "OK", "Back");
				SendGroupMessage(GROUP_TYPE_LEA, COLOR_LIGHTBLUE, "** MDC: Details for an arrest warrant have been updated.");
				return 1;
			}
			else
			{
				ShowPlayerDialogEx(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "MDC - Logged in | Error! ", "Spot 6 is already Taken!", "OK", "Back");
				return 1;
			}
		}
		if(x_nr == 7)
		{
			if(News[hTaken12] == 0)
			{
				GetPlayerName(playerid, sendername, sizeof(sendername));
				if(strlen(inputtext) < 9) { ShowPlayerDialogEx(playerid, MDC_ISSUE, DIALOG_STYLE_INPUT, "MDC - Logged in | ERROR", "ERROR: Must Be 9+ characters\nEnter Arrest Warrant Details", "Enter", "Cancel"); return 1; }
				format(string, sizeof(string), "%s",inputtext); strmid(News[hAdd12], string, 0, strlen(string), 255);
				format(string, sizeof(string), "%s",sendername); strmid(News[hContact12], string, 0, strlen(string), 255);
				News[hTaken12] = 1;
				ShowPlayerDialogEx(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "MDC - Logged in | Success! ","* You placed details for an arrest warrant on the MDC -Warrants\nto see the current Warrants browse to Warrants when logged in to the mdc", "OK", "Back");
				SendGroupMessage(GROUP_TYPE_LEA, COLOR_LIGHTBLUE, "** MDC: Details for an arrest warrant have been updated.");
				return 1;
			}
			else
			{
				ShowPlayerDialogEx(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "MDC - Logged in | Error! ", "Spot 7 is already Taken!", "OK", "Back");
				return 1;
			}
		}
		if(x_nr == 8)
		{
			if(News[hTaken13] == 0)
			{
				GetPlayerName(playerid, sendername, sizeof(sendername));
				if(strlen(inputtext) < 9) { ShowPlayerDialogEx(playerid, MDC_ISSUE, DIALOG_STYLE_INPUT, "MDC - Logged in | ERROR", "ERROR: Must Be 9+ characters\nEnter Arrest Warrant Details", "Enter", "Cancel"); return 1; }
				format(string, sizeof(string), "%s",inputtext); strmid(News[hAdd13], string, 0, strlen(string), 255);
				format(string, sizeof(string), "%s",sendername); strmid(News[hContact13], string, 0, strlen(string), 255);
				News[hTaken13] = 1;
				ShowPlayerDialogEx(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "MDC - Logged in | Success! ","* You placed details for an arrest warrant on the MDC -Warrants\nto see the current Warrants browse to Warrants when logged in to the mdc", "OK", "Back");
				SendGroupMessage(GROUP_TYPE_LEA, COLOR_LIGHTBLUE, "** MDC: Details for an arrest warrant have been updated.");
				return 1;
			}
			else
			{
				ShowPlayerDialogEx(playerid, MDC_END_ID, DIALOG_STYLE_MSGBOX, "MDC - Logged in | Error! ", "Spot 8 is already Taken!", "OK", "Back");
				return 1;
			}
		}
	}
	if(dialogid == MDC_DELETE && response)
	{
		if(listitem == 0)
		{
			ShowPlayerDialogEx(playerid, MDC_DEL_BOLO, DIALOG_STYLE_LIST, "MDC - Logged in | Which BOLO Slot would you like to delete?", "1\n2\n3\n4\n5\n6\n7\n8\nALL", "Enter", "Cancel");
		}
		if(listitem == 1)
		{
			ShowPlayerDialogEx(playerid, MDC_DEL_WARRANT, DIALOG_STYLE_LIST, "MDC - Logged in | Which Warrant Slot would you like to delete?", "1\n2\n3\n4\n5\n6\n7\n8\nALL", "Enter", "Cancel");
		}
	}
	if(dialogid == MDC_DEL_BOLO && response)
	{
		new string1[MAX_PLAYER_NAME];
		if(isnull(inputtext))
		{
			ShowPlayerDialogEx(playerid, MDC_DEL_WARRANT, DIALOG_STYLE_LIST, "MDC - Logged in | Which Warrant Slot would you like to delete?", "1\n2\n3\n4\n5\n6\n7\n8\nALL", "Enter", "Cancel");
			return 1;
		}
		if(strcmp(inputtext, "1") == 0)
		{
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd14], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact14], string1, 0, strlen(string1), 255);
			News[hTaken14] = 0;
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You deleted details for Be on the Lookout (1) from the MDC -BOLO.");
			return 1;
		}
		else if(strcmp(inputtext, "2") == 0)
		{
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd15], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact15], string1, 0, strlen(string1), 255);
			News[hTaken15] = 0;
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You deleted details for Be on the Lookout (2) from the MDC -BOLO.");
			return 1;
		}
		else if(strcmp(inputtext, "3") == 0)
		{
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd16], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact16], string1, 0, strlen(string1), 255);
			News[hTaken16] = 0;
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You deleted details for Be on the Lookout (3) from the MDC -BOLO.");
			return 1;
		}
		else if(strcmp(inputtext, "4") == 0)
		{
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd17], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact17], string1, 0, strlen(string1), 255);
			News[hTaken17] = 0;
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You deleted details for Be on the Lookout (4) from the MDC -BOLO.");
			return 1;
		}
		else if(strcmp(inputtext, "5") == 0)
		{
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd18], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact18], string1, 0, strlen(string1), 255);
			News[hTaken18] = 0;
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You deleted details for Be on the Lookout (5) from the MDC -BOLO.");
			return 1;
		}
		else if(strcmp(inputtext, "6") == 0)
		{
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd19], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact19], string1, 0, strlen(string1), 255);
			News[hTaken19] = 0;
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You deleted details for Be on the Lookout (6) from the MDC -BOLO.");
			return 1;
		}
		else if(strcmp(inputtext, "7") == 0)
		{
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd20], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact20], string1, 0, strlen(string1), 255);
			News[hTaken20] = 0;
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You deleted details for Be on the Lookout (7) from the MDC -BOLO.");
			return 1;
		}
		else if(strcmp(inputtext, "8") == 0)
		{
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd21], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact21], string1, 0, strlen(string1), 255);
			News[hTaken21] = 0;
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You deleted details for Be on the Lookout (8) from the MDC -BOLO.");
			return 1;
		}
		else if(strcmp(inputtext,"all",true) == 0)
		{
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd14], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact14], string1, 0, strlen(string1), 255);
			News[hTaken14] = 0;
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd15], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact15], string1, 0, strlen(string1), 255);
			News[hTaken15] = 0;
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd16], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact16], string1, 0, strlen(string1), 255);
			News[hTaken16] = 0;
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd17], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact17], string1, 0, strlen(string1), 255);
			News[hTaken17] = 0;
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd18], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact18], string1, 0, strlen(string1), 255);
			News[hTaken18] = 0;
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd19], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact19], string1, 0, strlen(string1), 255);
			News[hTaken19] = 0;
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd20], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact20], string1, 0, strlen(string1), 255);
			News[hTaken20] = 0;
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd21], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact21], string1, 0, strlen(string1), 255);
			News[hTaken21] = 0;
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You deleted all the details for Be on the Lookout from the MDC -BOLO.");
			return 1;
		}
	}
	if(dialogid == MDC_DEL_WARRANT && response)
	{
		new string1[MAX_PLAYER_NAME];
		if(isnull(inputtext))
		{
			ShowPlayerDialogEx(playerid, MDC_DEL_WARRANT, DIALOG_STYLE_LIST, "MDC - Logged in | Which Warrant Slot would you like to delete?", "1\n2\n3\n4\n5\n6\n7\n8\nALL", "Enter", "Cancel");
			return 1;
		}
		if(strcmp(inputtext,"1",true) == 0)
		{
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd6], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact6], string1, 0, strlen(string1), 255);
			News[hTaken6] = 0;
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You deleted details for Arrest Warrant (1) from the MDC -Warrants.");
			return 1;
		}
		else if(strcmp(inputtext,"2",true) == 0)
		{
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd7], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact7], string1, 0, strlen(string1), 255);
			News[hTaken7] = 0;
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You deleted details for Arrest Warrant (2) from the MDC -Warrants.");
			return 1;
		}
		else if(strcmp(inputtext,"3",true) == 0)
		{
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd8], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact8], string1, 0, strlen(string1), 255);
			News[hTaken8] = 0;
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You deleted details for Arrest Warrant (3) from the MDC -Warrants.");
			return 1;
		}
		else if(strcmp(inputtext,"4",true) == 0)
		{
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd9], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact9], string1, 0, strlen(string1), 255);
			News[hTaken9] = 0;
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You deleted details for Arrest Warrant (4) from the MDC -Warrants.");
			return 1;
		}
		else if(strcmp(inputtext,"5",true) == 0)
		{
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd10], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact10], string1, 0, strlen(string1), 255);
			News[hTaken10] = 0;
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You deleted details for Arrest Warrant (5) from the MDC -Warrants.");
			return 1;
		}
		else if(strcmp(inputtext,"6",true) == 0)
		{
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd11], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact11], string1, 0, strlen(string1), 255);
			News[hTaken11] = 0;
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You deleted details for Arrest Warrant (6) from the MDC -Warrants.");
			return 1;
		}
		else if(strcmp(inputtext,"7",true) == 0)
		{
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd12], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact12], string1, 0, strlen(string1), 255);
			News[hTaken12] = 0;
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You deleted details for Arrest Warrant (7) from the MDC -Warrants.");
			return 1;
		}
		else if(strcmp(inputtext,"8",true) == 0)
		{
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd13], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact13], string1, 0, strlen(string1), 255);
			News[hTaken13] = 0;
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You deleted details for Arrest Warrant (8) from the MDC -Warrants.");
			return 1;
		}
		else if(strcmp(inputtext,"all",true) == 0)
		{
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd6], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact6], string1, 0, strlen(string1), 255);
			News[hTaken6] = 0;
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd7], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact7], string1, 0, strlen(string1), 255);
			News[hTaken7] = 0;
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd8], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact8], string1, 0, strlen(string1), 255);
			News[hTaken8] = 0;
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd9], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact9], string1, 0, strlen(string1), 255);
			News[hTaken9] = 0;
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd10], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact10], string1, 0, strlen(string1), 255);
			News[hTaken10] = 0;
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd11], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact11], string1, 0, strlen(string1), 255);
			News[hTaken11] = 0;
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd12], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact12], string1, 0, strlen(string1), 255);
			News[hTaken12] = 0;
			format(string, sizeof(string), "Nothing"); strmid(News[hAdd13], string, 0, strlen(string), 255);
			format(string1, sizeof(string1), "No-one");	strmid(News[hContact13], string1, 0, strlen(string1), 255);
			News[hTaken13] = 0;
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You deleted all the details for Arrest Warrants from the MDC -Warrants.");
			return 1;
		}
	}
	if(dialogid == MDC_LOGOUT && response)
	{
	}
	if(dialogid == MDC_CREATE && response)
	{
	}
	if( (dialogid >= MDC_START_ID && dialogid <= MDC_END_ID) && !response)
	{
		if(dialogid == MDC_MAIN)
		{
			ConnectedToPC[playerid] = 0;
		}
		else
		{
			ShowPlayerDialogEx(playerid, MDC_MAIN, DIALOG_STYLE_LIST, "MDC - Logged in", "*Civilian Information\n*Register Suspect\n*Clear Suspect\n*Vehicle registrations\n*Find LEO\n*Law Enforcement Agencies\n*MDC Message\n*SMS", "OK", "Cancel");
		}
	}
	if((dialogid == SELLVIP))
	{
		new
			iTargetID = GetPVarInt(playerid, "VIPSell"),
			iPrice = GetPVarInt(playerid, "VIPCost"),
			logstring[156];

		if(response)
		{

			if(!IsPlayerConnected(iTargetID)) return SendClientMessageEx(playerid, COLOR_GREY, "The other person has disconnected.");
			new iTargetName[MAX_PLAYER_NAME];
			GetPVarString(playerid, "VIPSeller", iTargetName, sizeof(iTargetName));
			if(strcmp(iTargetName, GetPlayerNameEx(iTargetID)) != 0) {
				return SendClientMessageEx(playerid, COLOR_GREY, "The other person has disconnected.");
			}
			new	viptype[7];
			if(GetPlayerCash(playerid) >= iPrice)
			{
				if(PlayerInfo[iTargetID][pDonateRank] == 3)
				{
					PlayerInfo[iTargetID][pGVip] = 0;
					PlayerInfo[playerid][pGVip] = 1;
				}
				//Player buying the VIP
				GivePlayerCash(playerid, -GetPVarInt(playerid, "VIPCost"));
				PlayerInfo[playerid][pDonateRank] = PlayerInfo[iTargetID][pDonateRank];
				PlayerInfo[playerid][pVIPExpire] = PlayerInfo[iTargetID][pVIPExpire];
				PlayerInfo[playerid][pTempVIP] = 0;
				PlayerInfo[playerid][pBuddyInvited] = 0;
				PlayerInfo[playerid][pVIPSellable] = 0;

				LoadPlayerDisabledVehicles(iTargetID);

				if(PlayerInfo[playerid][pVIPM] != 0)
				{
					PlayerInfo[playerid][pVIPMO] = PlayerInfo[playerid][pVIPM];
				}
				PlayerInfo[playerid][pVIPM] = PlayerInfo[iTargetID][pVIPM];

				// person selling the vip
				GivePlayerCash(iTargetID, GetPVarInt(playerid, "VIPCost"));
				PlayerInfo[iTargetID][pDonateRank] = 0;
				PlayerInfo[iTargetID][pVIPExpire] = 0;
				PlayerInfo[iTargetID][pVIPMO] = PlayerInfo[iTargetID][pVIPM];
				PlayerInfo[iTargetID][pVIPM] = 0;
				switch(PlayerInfo[playerid][pDonateRank])
				{
					case 1: viptype = "Bronze";
					case 2: viptype = "Silver";
					case 3: viptype = "Gold";
					default: viptype = "Error";
				}
				format(string, sizeof(string), "You have purchased %s VIP from %s for $%d which will expire on %s.", viptype, GetPlayerNameEx(iTargetID), iPrice, date(PlayerInfo[playerid][pVIPExpire], 2));
				SendClientMessage(playerid, COLOR_WHITE, string);
				format(string, sizeof(string), "You have sold your %s VIP to %s for $%d.", viptype, GetPlayerNameEx(playerid), iPrice);
				SendClientMessage(iTargetID, COLOR_WHITE, string);
				new iYear, iMonth, iDay, szIP[16], szIP2[16];
				getdate(iYear, iMonth, iDay);
				GetPlayerIp(iTargetID, szIP, sizeof(szIP));
				GetPlayerIp(playerid, szIP2, sizeof(szIP2));
				format(logstring, sizeof(logstring), "[SELLVIP] %s(%d) (IP:%s) has sold %s VIP to %s(%d) (IP:%s) for $%d. (VIPM: %d) - (%d/%d/%d)", GetPlayerNameEx(iTargetID), GetPlayerSQLId(iTargetID), szIP, viptype, GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), szIP2, iPrice, PlayerInfo[playerid][pVIPM], iMonth,iDay,iYear);
				Log("logs/shoplog.log", logstring);

				PlayerInfo[playerid][pVIPSold] = gettime() + 7200;
				PlayerInfo[iTargetID][pVIPSold] = gettime() + 7200;
			}
			else
			{
				SendClientMessage(playerid, COLOR_GREY, "You don't have enough cash to purchase it!");
				SendClientMessage(iTargetID, COLOR_GREY, "He did not have enough cash to purchase it!");
			}
			DeletePVar(playerid, "VIPSell");
			DeletePVar(playerid, "VIPCost");
		}
		else
		{
			format(string, sizeof(string), "You have declined the offer to purchase VIP from %s.", GetPlayerNameEx(iTargetID));
			SendClientMessage(playerid, COLOR_WHITE, string);
			format(string, sizeof(string), "%s has declined the offer to purchase VIP.", GetPlayerNameEx(playerid));
			SendClientMessage(iTargetID, COLOR_WHITE, string);
			DeletePVar(playerid, "VIPSell");
			DeletePVar(playerid, "VIPCost");
		}
		return 1;
	}
	if((dialogid == DRINKDIALOG))
	{
		if(response)
		{
			ShowPlayerDialogEx(playerid, TIPDIALOG, DIALOG_STYLE_INPUT, "Tipping the Bartender", "How much would you like to tip the bartender for their service?", "OK", "Cancel");
		}
		else
		{
			DrinkOffer[playerid] = INVALID_PLAYER_ID;
		}
	}
	if((dialogid == TIPDIALOG))
	{
		if(response)
		{
			if(GetPlayerCash(playerid) >= strval(inputtext))
			{
				if(strval(inputtext) < 0 || strval(inputtext) > 10000)
				{
					return ShowPlayerDialogEx(playerid, TIPDIALOG, DIALOG_STYLE_INPUT, "Tipping the Bartender", "Must be above $0 or below $10,000.\nHow much would you like to tip the bartender for their service?", "OK", "Cancel");
				}
				format(string, sizeof(string), "** %s gives %s a tip for their service.", GetPlayerNameEx(playerid), GetPlayerNameEx(DrinkOffer[playerid]));
				ProxDetector(15.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				format(string, sizeof(string), "* %s has given you a tip of $%d for your service.", GetPlayerNameEx(playerid), strval(inputtext));
				SendClientMessageEx(DrinkOffer[playerid], COLOR_LIGHTBLUE, string);
				GivePlayerCash(DrinkOffer[playerid], strval(inputtext));
				GivePlayerCash(playerid, -strval(inputtext));

				new ip[32], ipex[32];
				GetPlayerIp(playerid, ip, sizeof(ip));
				GetPlayerIp(DrinkOffer[playerid], ipex, sizeof(ipex));

				if(strval(inputtext) >= 25000 && (PlayerInfo[DrinkOffer[playerid]][pLevel] <= 3 || PlayerInfo[playerid][pLevel] <= 3 ))
				{
					format(string, sizeof(string), "%s(%d) (IP:%s) has tipped %s(%d) (IP:%s) $%s in this session.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ip, GetPlayerNameEx(DrinkOffer[playerid]), GetPlayerSQLId(DrinkOffer[playerid]), ipex, number_format(strval(inputtext)));
					Log("logs/pay.log", string);
					format(string, sizeof(string), "%s (IP:%s) has tipped %s (IP:%s) $%s in this session.", GetPlayerNameEx(playerid), ip, GetPlayerNameEx(DrinkOffer[playerid]), ipex, number_format(strval(inputtext)));
					ABroadCast(COLOR_YELLOW, string, 2);
				}

				DrinkOffer[playerid] = INVALID_PLAYER_ID;
			}
		}
		else
		{
			DrinkOffer[playerid] = INVALID_PLAYER_ID;
		}
	}
	else if(dialogid == INTERACTMAIN)
	{
		if(response)
		{
			new name[MAX_PLAYER_NAME+8];
			GetPVarString(playerid, "pInteractName", name, sizeof(name));
			if(listitem == 0)
			{
				ShowPlayerDialogEx(playerid, INTERACTPAY, DIALOG_STYLE_INPUT, name, "Input an amount to pay", "Pay", "Cancel");
			}
			else if(listitem == 1)
			{
				ShowPlayerDialogEx(playerid, INTERACTGIVE, DIALOG_STYLE_LIST, name, "Cannabis\nCrack\nMaterials\nFirework\nHeroin\nRawOpium\nSyringes\nOpiumSeeds\nSprunk", "Select", "Cancel");
			}
		}
		else
		{
			DeletePVar(playerid, "pInteractName");
			DeletePVar(playerid, "pInteractID");
		}
	}
	else if(dialogid == INTERACTPAY)
	{
		if(response)
		{
			new params[24];
			format(params, sizeof(params), "%d %d", GetPVarInt(playerid, "pInteractID"), strval(inputtext));
			DeletePVar(playerid, "pInteractName");
			DeletePVar(playerid, "pInteractID");
			return cmd_pay(playerid, params);
		}
		else
		{
			DeletePVar(playerid, "pInteractName");
			DeletePVar(playerid, "pInteractID");
		}
	}
	else if(dialogid == INTERACTGIVE)
	{
		if(response)
		{
			new name[MAX_PLAYER_NAME+8];
			SetPVarInt(playerid, "pInteractGiveType", listitem);
			GetPVarString(playerid, "pInteractName", name, sizeof(name));
			ShowPlayerDialogEx(playerid, INTERACTGIVE2, DIALOG_STYLE_INPUT, name, "Input an amount to give", "Give", "Cancel");
		}
		else
		{
			DeletePVar(playerid, "pInteractName");
			DeletePVar(playerid, "pInteractID");
		}
	}
	/*else if(dialogid == INTERACTGIVE2)
	{
		if(response)
		{
			new params[24];
			switch(GetPVarInt(playerid, "pInteractGiveType"))
			{
				case 0: format(params, sizeof(params), "%d pot %d", GetPVarInt(playerid, "pInteractID"), strval(inputtext));
				case 1: format(params, sizeof(params), "%d crack %d", GetPVarInt(playerid, "pInteractID"), strval(inputtext));
				case 2: format(params, sizeof(params), "%d materials %d", GetPVarInt(playerid, "pInteractID"), strval(inputtext));
				case 3: format(params, sizeof(params), "%d firework %d", GetPVarInt(playerid, "pInteractID"), strval(inputtext));
				case 4: format(params, sizeof(params), "%d heroin %d", GetPVarInt(playerid, "pInteractID"), strval(inputtext));
				case 5: format(params, sizeof(params), "%d rawopium %d", GetPVarInt(playerid, "pInteractID"), strval(inputtext));
				case 6: format(params, sizeof(params), "%d syringes %d", GetPVarInt(playerid, "pInteractID"), strval(inputtext));
				case 7: format(params, sizeof(params), "%d opiumseeds %d", GetPVarInt(playerid, "pInteractID"), strval(inputtext));
				case 8: format(params, sizeof(params), "%d sprunk %d", GetPVarInt(playerid, "pInteractID"), strval(inputtext));
				case 9: format(params, sizeof(params), "%d ammo1 %d", GetPVarInt(playerid, "pInteractID"), strval(inputtext));
				case 10: format(params, sizeof(params), "%d ammo2 %d", GetPVarInt(playerid, "pInteractID"), strval(inputtext));
				case 11: format(params, sizeof(params), "%d ammo3 %d", GetPVarInt(playerid, "pInteractID"), strval(inputtext));
				case 12: format(params, sizeof(params), "%d ammo4 %d", GetPVarInt(playerid, "pInteractID"), strval(inputtext));
				case 13: format(params, sizeof(params), "%d ammo5 %d", GetPVarInt(playerid, "pInteractID"), strval(inputtext));
			}
			DeletePVar(playerid, "pInteractName");
			DeletePVar(playerid, "pInteractID");
			DeletePVar(playerid, "pInteractGive");
			return cmd_give(playerid, params);
		}
		else
		{
			DeletePVar(playerid, "pInteractName");
			DeletePVar(playerid, "pInteractID");
			DeletePVar(playerid, "pInteractGive");
		}
	}*/
	else if(dialogid == DMRCONFIRM)
	{
		if(response)
		{
			new giveplayerid = GetPVarInt(playerid, "pDMReport");
			SetPVarInt(playerid, "_rAutoM", 5);
			SetPVarInt(playerid, "_rRepID", giveplayerid);			format(string, sizeof(string), "You have successfully reported %s.", GetPlayerNameEx(giveplayerid));
			SendClientMessage(playerid, COLOR_WHITE, string);

			if(PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[playerid][pSMod] == 1) mysql_format(MainPipeline, string, sizeof(string), "INSERT INTO dm_watchdog (id,reporter,timestamp,superwatch) VALUES (%d,%d,%d,1)", GetPlayerSQLId(giveplayerid), GetPlayerSQLId(playerid), gettime());
			else mysql_format(MainPipeline, string, sizeof(string), "INSERT INTO dm_watchdog (id,reporter,timestamp) VALUES (%d,%d,%d)", GetPlayerSQLId(giveplayerid), GetPlayerSQLId(playerid), gettime());
			mysql_tquery(MainPipeline, string, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);

			format(string, sizeof(string), "%s(%i) Deathmatching (last shot: %i seconds ago)", GetPlayerNameEx(giveplayerid), giveplayerid, gettime() - ShotPlayer[giveplayerid][playerid]);
			SendReportToQue(playerid, string, 2, 1);

			ShotPlayer[giveplayerid][playerid] = 0;

			SetPVarInt(playerid, "AlertedThisPlayer", giveplayerid);
			SetPVarInt(playerid, "AlertType", 1);
			AlertTime[playerid] = 300;
		}
		else
		{
			SendClientMessage(playerid, COLOR_GRAD2, "DM Report Cancelled");
		}
		DeletePVar(playerid, "pDMReport");
	}
	else if(dialogid == SHOPOBJECT_ORDERID)
	{
		if(response)
		{
			SetPVarString(playerid, "shopobject_orderid", inputtext);
			ShowPlayerDialogEx(playerid, SHOPOBJECT_GIVEPLAYER, DIALOG_STYLE_INPUT, "Shop Objects - player ID", "Please enter the player ID", "OK", "Cancel");
		}
	}
	else if(dialogid == SHOPOBJECT_GIVEPLAYER)
	{
		if(response)
		{
			SetPVarString(playerid, "shopobject_giveplayerid", inputtext);
			new stringg[1024];
			for(new x;x<sizeof(HoldingObjectsShop);x++)
			{
				format(stringg, sizeof(stringg), "%s%s\n", stringg, HoldingObjectsShop[x][holdingmodelname]);
			}
			ShowPlayerDialogEx(playerid, SHOPOBJECT_OBJECTID, DIALOG_STYLE_LIST, "Shop Objects - Object ID", stringg, "Select", "Cancel");
		}
	}
	else if(dialogid == SHOPOBJECT_OBJECTID)
	{
		if(response)
		{
			new giveplayerid;
			new str[MAX_PLAYER_NAME];
			GetPVarString(playerid, "shopobject_giveplayerid", str, MAX_PLAYER_NAME);
			sscanf(str, "u", giveplayerid);
			new stringg[512], icount = GetPlayerToySlots(giveplayerid);
			if(!IsPlayerConnected(giveplayerid) || giveplayerid == INVALID_PLAYER_ID)
			{
				ShowPlayerDialogEx(playerid, SHOPOBJECT_GIVEPLAYER, DIALOG_STYLE_INPUT, "Shop Objects - player ID", "ERROR: That person is not connected \nPlease re-enter the player ID", "OK", "Cancel");
				return 1;
			}
			SetPVarInt(playerid, "shopobject_objectid", listitem);
			for(new x;x<icount;x++)
			{
				new name[24] = "None";

				for(new i;i<sizeof(HoldingObjectsAll);i++)
				{
					if(HoldingObjectsAll[i][holdingmodelid] == PlayerToyInfo[giveplayerid][x][ptModelID])
					{
						format(name, sizeof(name), "%s", HoldingObjectsAll[i][holdingmodelname]);
					}
				}

				format(stringg, sizeof(stringg), "%s(%d) %s (Bone: %s)\n", stringg, x, name, HoldingBones[PlayerToyInfo[giveplayerid][x][ptBone]]);
			}
			ShowPlayerDialogEx(playerid, SHOPOBJECT_TOYSLOT, DIALOG_STYLE_LIST, "Shop Objects - Select a Slot", stringg, "Select", "Cancel");
		}
	}
	else if(dialogid == SHOPOBJECT_TOYSLOT)
	{
		if(response)
		{
			new stringg[128];
			new giveplayerid;
			new str[MAX_PLAYER_NAME];
			GetPVarString(playerid, "shopobject_giveplayerid", str, MAX_PLAYER_NAME);
			sscanf(str, "u", giveplayerid);
			new object = HoldingObjectsShop[GetPVarInt(playerid, "shopobject_objectid")][holdingmodelid];
			new slot = listitem;
			new invoice[64];
			GetPVarString(playerid, "shopobject_orderid", invoice, sizeof(invoice));
			if(!IsPlayerConnected(giveplayerid) || giveplayerid == INVALID_PLAYER_ID)
			{
				ShowPlayerDialogEx(playerid, SHOPOBJECT_GIVEPLAYER, DIALOG_STYLE_INPUT, "Shop Objects - player ID", "ERROR: That person is not connected \nPlease re-enter the player ID", "OK", "Cancel");
				return 1;
			}
			if(!toyCountCheck(giveplayerid)) return SendClientMessageEx(playerid, COLOR_GRAD2, "This player does not have enough free slots");

			format(stringg, sizeof(stringg), "You have given %s object %d in slot %d", GetPlayerNameEx(giveplayerid), object, slot);
			ShowPlayerDialogEx(playerid, SHOPOBJECT_SUCCESS, DIALOG_STYLE_MSGBOX, "Shop Objects - Success", stringg, "OK", "");
			SendClientMessageEx(giveplayerid, COLOR_WHITE, "You have received a new /toys from the shop!");
			format(string, sizeof(string), "[SHOPOBJECTS] %s gave %s(%d) object %d in slot %d - Invoice %s", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), object, slot, invoice);
			PlayerToyInfo[giveplayerid][slot][ptModelID] = object;
			PlayerToyInfo[giveplayerid][slot][ptBone] = 1;
			PlayerToyInfo[giveplayerid][slot][ptTradable] = 1;
			g_mysql_NewToy(giveplayerid, slot);
			Log("logs/shoplog.log", string);
		}
	}
	else if(dialogid == LISTTOYS_DELETETOY)
	{
		if(response)
		{
			if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1)
			{
				return SendClientMessageEx(playerid, COLOR_GRAD2, "You're not authorized to do that");
			}
			new giveplayerid = GetPVarInt(playerid, "listtoys_giveplayerid");
			SetPVarInt(playerid, "listitem_toyslot", listitem);
			format(string, sizeof(string), "Are you sure you want to delete %s's toy (Model ID: %d) from slot %d?", GetPlayerNameEx(giveplayerid), PlayerToyInfo[giveplayerid][listitem][ptModelID], listitem+1);
			ShowPlayerDialogEx(playerid, LISTTOYS_DELETETOYCONFIRM, DIALOG_STYLE_MSGBOX, "Delete Toy - Are you sure?", string, "Yes", "No");
		}
	}
	else if(dialogid == LISTTOYS_DELETETOYCONFIRM)
	{
		if(response)
		{
			new stringg[128], szQuery[128], giveplayerid = GetPVarInt(playerid, "listtoys_giveplayerid"), slot = GetPVarInt(playerid, "listitem_toyslot");
			new object =  PlayerToyInfo[giveplayerid][slot][ptModelID];
			if(!IsPlayerConnected(giveplayerid) || giveplayerid == INVALID_PLAYER_ID)
			{
				ShowPlayerDialogEx(playerid, SHOPOBJECT_GIVEPLAYER, DIALOG_STYLE_MSGBOX, "Delete Toy - Player ID", "ERROR: That player is not connected", "OK", "");
				return 1;
			}
			new toys = 99999;
			for(new i; i < 10; i++)
			{
				if(PlayerHoldingObject[giveplayerid][i] == slot)
				{
					toys = i;
					if(IsPlayerAttachedObjectSlotUsed(giveplayerid, toys))
					{
						PlayerHoldingObject[giveplayerid][i] = 0;
						RemovePlayerAttachedObject(giveplayerid, toys);
					}
					break;
				}
			}
			format(stringg, sizeof(stringg), "You have deleted %s's object %d in slot %d", GetPlayerNameEx(giveplayerid), object, slot+1);
			ShowPlayerDialogEx(playerid, SHOPOBJECT_SUCCESS, DIALOG_STYLE_MSGBOX, "Delete Toy - Success", stringg, "OK", "");
			format(stringg, sizeof(stringg), "Admin %s has deleted your toy (obj model: %d) from slot %d.", GetPlayerNameEx(playerid), object, slot);
			SendClientMessageEx(giveplayerid, COLOR_WHITE, stringg);
			format(string, sizeof(string), "[TOYDELETE] %s deleted %s's(%d) object %d in slot %d", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), object, slot);
			mysql_format(MainPipeline, szQuery, sizeof(szQuery), "DELETE FROM `toys` WHERE `id` = %d", PlayerToyInfo[giveplayerid][slot][ptID]);
			mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "ii", SENDDATA_THREAD, giveplayerid);
			PlayerToyInfo[giveplayerid][slot][ptModelID] = 0;
			PlayerToyInfo[giveplayerid][slot][ptBone] = 0;
			PlayerToyInfo[giveplayerid][slot][ptSpecial] = 0;
			Log("logs/toydelete.log", string);
		}
	}
	else if(dialogid == MDC_SHOWCRIMES)
	{
		if(response)
		{
			ShowPlayerDialogEx(playerid, MDC_CIVILIANS, DIALOG_STYLE_LIST, "MDC - Logged in | Civilian Options", "*Check Record\n*View Arrest Reports\n*Licenses\n*Warrants\n*Issue Warrant\n*BOLO\n*Create BOLO\n*Delete", "OK", "Cancel");
		}
	}
	else if(dialogid == FLAG_LIST)
	{
		if(response)
		{
			if(!IsPlayerConnected(GetPVarInt(playerid, "viewingflags"))) return SendClientMessage(playerid, -1, "The player whos flags you were managing is no longer connected!");
			if(!GetPVarType(playerid, "ManageFlagID"))
			{
				new stpos = strfind(inputtext, "(");
				new fpos = strfind(inputtext, ")");
				new fid[11];
				strmid(fid, inputtext, stpos+5, fpos);
				SetPVarInt(playerid, "ManageFlagID", strval(fid));
				format(string, sizeof(string), "Managing FlagID: %d", GetPVarInt(playerid, "ManageFlagID"));
				return ShowPlayerDialogEx(playerid, FLAG_LIST, DIALOG_STYLE_LIST, string, "View\nTransfer\nDelete", "Select", "Close");
			}
			else
			{
				if(listitem == -1)
				{
					new target;
					if(sscanf(inputtext, "u", target)) return ShowPlayerDialogEx(playerid, FLAG_LIST, DIALOG_STYLE_INPUT, "FLAG TRANSFER", "Who do you want to transfer the flag to?", "Select", "Cancel");
					if(GetPVarInt(playerid, "viewingflags") == target) return SendClientMessageEx(playerid, COLOR_GRAD2, "ERROR: You cannot transfer to the same person!");
					if(!IsPlayerConnected(target)) return ShowPlayerDialogEx(playerid, FLAG_LIST, DIALOG_STYLE_INPUT, "FLAG TRANSFER - ERROR", "Player is not connected!\nWho do you want to transfer the flag to?", "Select", "Cancel");
					mysql_format(MainPipeline, string, sizeof(string), "SELECT id, flag, issuer, time, type FROM `flags` WHERE `fid` = %i", GetPVarInt(playerid, "ManageFlagID"));
					mysql_tquery(MainPipeline, string, "OnRequestTransferFlag", "iiii", playerid, GetPVarInt(playerid, "ManageFlagID"), target, GetPVarInt(playerid, "viewingflags"));
				}
				if(listitem == 0)
				{
					mysql_format(MainPipeline, string, sizeof(string), "SELECT fid, issuer, flag, time FROM `flags` WHERE fid = %d", GetPVarInt(playerid, "ManageFlagID"));
					mysql_tquery(MainPipeline, string, "FlagQueryFinish", "iii", playerid, GetPVarInt(playerid, "viewingflags"), 0);
				}
				if(listitem == 1)
				{
					ShowPlayerDialogEx(playerid, FLAG_LIST, DIALOG_STYLE_INPUT, "FLAG TRANSFER", "Who do you want to transfer the flag to?", "Select", "Cancel");
				}
				if(listitem == 2)
				{
					mysql_format(MainPipeline, string, sizeof(string), "SELECT flag, issuer, time, type FROM `flags` WHERE `fid` = %i", GetPVarInt(playerid, "ManageFlagID"));
					mysql_tquery(MainPipeline, string, "OnRequestDeleteFlag", "ii", playerid, GetPVarInt(playerid, "ManageFlagID"));
				}
			}
		}
	}
	else if(dialogid == FLAG_DELETE)
	{
		if(response)
		{
			new flagid;
			if(sscanf(inputtext, "d", flagid)) return ShowPlayerDialogEx(playerid, FLAG_DELETE, DIALOG_STYLE_INPUT, "FLAG DELETION", "Which flag would you like to delete?", "Delete Flag", "Close");
			new query[128];
			mysql_format(MainPipeline, query, sizeof(query), "SELECT flag, issuer, time, type FROM `flags` WHERE `fid` = %i", flagid);
			mysql_tquery(MainPipeline, query, "OnRequestDeleteFlag", "ii", playerid, flagid);
		}
	}
	else if(dialogid == FLAG_DELETE2)
	{
		if(response)
		{
			new flagid = GetPVarInt(playerid, "Flag_Delete_ID");
			DeleteFlag(flagid, playerid);
			SendClientMessageEx(playerid, COLOR_YELLOW, " Flag deleted successfully ");
		}
	}
	else if(dialogid == SKIN_LIST)
	{
		if(response)
		{
			new query[128];
			SetPVarInt(playerid, "closetchoiceid", listitem);
			mysql_format(MainPipeline, query, sizeof(query), "SELECT `skinid` FROM `house_closet` WHERE playerid = %d ORDER BY `skinid` ASC", GetPlayerSQLId(playerid));
			mysql_tquery(MainPipeline, query, "SkinQueryFinish", "ii", playerid, Skin_Query_ID);
		}
	}
	else if(dialogid == SKIN_CONFIRM)
	{
		if(response)
		{
			PlayerInfo[playerid][pModel] = GetPVarInt(playerid, "closetskinid");
			DeletePVar(playerid, "closetchoiceid");
			DeletePVar(playerid, "closetskinid");
		}
		else
		{
			SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);
			DeletePVar(playerid, "closetchoiceid");
			DeletePVar(playerid, "closetskinid");
			DisplaySkins(playerid);
		}
	}
	else if(dialogid == SKIN_DELETE)
	{
		if(response)
		{
			new query[128];
			SetPVarInt(playerid, "closetchoiceid", listitem);
			mysql_format(MainPipeline, query, sizeof(query), "SELECT `id`, `skinid` FROM `house_closet` WHERE playerid = %d ORDER BY `skinid` ASC", GetPlayerSQLId(playerid));
			mysql_tquery(MainPipeline, query, "SkinQueryFinish", "ii", playerid, Skin_Query_Delete_ID);
		}
	}
	else if(dialogid == SKIN_DELETE2)
	{
		if(response)
		{
			DeleteSkin(GetPVarInt(playerid, "closetskinid"));
			DeletePVar(playerid, "closetchoiceid");
			DeletePVar(playerid, "closetskinid");
			SendClientMessageEx(playerid, COLOR_WHITE, "Clothes removed successfully!");
		}
		else
		{
			DeletePVar(playerid, "closetchoiceid");
			DeletePVar(playerid, "closetskinid");
			DisplaySkins(playerid);
		}
	}
	else if(dialogid == NATION_APP_LIST)
	{
		if(response)
		{
			ShowPlayerDialogEx(playerid, NATION_APP_CHOOSE, DIALOG_STYLE_MSGBOX, "Nation Applications", "What would you like to do with this application?", "Accept", "Deny");
			SetPVarInt(playerid, "Nation_App_ID", listitem);
		}
	}
	else if(dialogid == NATION_APP_CHOOSE)
	{
		if(response)
		{
			switch(arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance])
			{
				case 1: mysql_tquery(MainPipeline, "SELECT `id`, `playerid`, `name` FROM `nation_queue` WHERE `nation` = 0 AND `status` = 1 ORDER BY `id` ASC", "NationAppFinish", "ii", playerid, AcceptApp);
				case 2: mysql_tquery(MainPipeline, "SELECT `id`, `playerid`, `name` FROM `nation_queue` WHERE `nation` = 1 AND `status` = 1 ORDER BY `id` ASC", "NationAppFinish", "ii", playerid, AcceptApp);
			}
		}
		else
		{
			switch(arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance])
			{
				case 1: mysql_tquery(MainPipeline, "SELECT `id`, `playerid`, `name` FROM `nation_queue` WHERE `nation` = 0 AND `status` = 1 ORDER BY `id` ASC", "NationAppFinish", "ii", playerid, DenyApp);
				case 2: mysql_tquery(MainPipeline, "SELECT `id`, `playerid`, `name` FROM `nation_queue` WHERE `nation` = 1 AND `status` = 1 ORDER BY `id` ASC", "NationAppFinish", "ii", playerid, DenyApp);
			}
		}
	}
	else if(dialogid == DIALOG_911MENU)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: ShowPlayerDialogEx(playerid, DIALOG_911EMERGENCY, DIALOG_STYLE_INPUT, "911 Emergency Services", "Please describe the emergency.", "Enter", "End Call");
				case 1: ShowPlayerDialogEx(playerid, DIALOG_911MEDICAL, DIALOG_STYLE_INPUT, "911 Emergency Services", "Please describe your medical emergency.", "Enter", "End Call");
				case 2: ShowPlayerDialogEx(playerid, DIALOG_911POLICE, DIALOG_STYLE_INPUT, "911 Emergency Services", "Please describe why you require police assistance.", "Enter", "End Call");
				case 3: ShowPlayerDialogEx(playerid, DIALOG_911TOWING, DIALOG_STYLE_INPUT, "911 Emergency Services", "Please describe why you require towing services.", "Enter", "End Call");
				case 4: {
					szMiscArray[0] = 0;
					new icount = GetPlayerVehicleSlots(playerid);
					new szCarLocation[MAX_ZONE_NAME];
					for(new i, iModelID; i < icount; i++)
					{
						if((iModelID = PlayerVehicleInfo[playerid][i][pvModelId] - 400) >= 0)
						{
							Get3DZone(PlayerVehicleInfo[playerid][i][pvPosX], PlayerVehicleInfo[playerid][i][pvPosY], PlayerVehicleInfo[playerid][i][pvPosZ], szCarLocation, sizeof(szCarLocation));
							if(PlayerVehicleInfo[playerid][i][pvImpounded]) {
								format(szMiscArray, sizeof(szMiscArray), "%s\n%s (impounded) | Location: DMV", szMiscArray, VehicleName[iModelID]);
							}
							else if(PlayerVehicleInfo[playerid][i][pvDisabled]) {
								format(szMiscArray, sizeof(szMiscArray), "%s\n%s (disabled) | Location: Unknown", szMiscArray, VehicleName[iModelID]);
							}
							else if(!PlayerVehicleInfo[playerid][i][pvSpawned]) {
								format(szMiscArray, sizeof(szMiscArray), "%s\n%s (stored) | Location: %s", szMiscArray, VehicleName[iModelID], szCarLocation);
							}
							else {
								if(PlayerVehicleInfo[playerid][i][pvAlarmTriggered]) format(szMiscArray, sizeof(szMiscArray), "%s\n%s (alarm triggered) | Location: %s", szMiscArray, VehicleName[iModelID], szCarLocation);
								else format(szMiscArray, sizeof(szMiscArray), "%s\n%s | Location: %s", szMiscArray, VehicleName[iModelID], szCarLocation);
							}
						}
					}
					ShowPlayerDialogEx(playerid, DIALOG_911PICKLOCK, DIALOG_STYLE_LIST, "Vehicle Burglary Report", szMiscArray, "Track", "Cancel");
				}
				case 5: ShowPlayerDialogEx(playerid, DIALOG_911FIRE, DIALOG_STYLE_INPUT, "911 Emergency Services", "Please describe why you require the fire bridgade.", "Enter", "End Call");
			}
		}
	}
	else if(dialogid == DIALOG_911EMERGENCY)
	{
		if(response)
		{
			new zone[MAX_ZONE_NAME], mainzone[MAX_ZONE_NAME];
			if(strlen(inputtext) < 4) return ShowPlayerDialogEx(playerid, DIALOG_911EMERGENCY, DIALOG_STYLE_INPUT, "911 Emergency Services", "Sorry, I don't quite understand. What is the emergency you are experiencing?", "Enter", "End Call");
			else
			{
				GetPlayer2DZone(playerid, zone, MAX_ZONE_NAME);
				GetPlayerMainZone(playerid, mainzone, MAX_ZONE_NAME);
				SendCallToQueue(playerid, inputtext, zone, mainzone, 0);
				SetPVarInt(playerid, "Has911Call", 1);
				SendClientMessageEx(playerid, TEAM_CYAN_COLOR, "Dispatch: We have alerted all units in the area.");
				SendClientMessageEx(playerid, TEAM_CYAN_COLOR, "Thank you for reporting this incident");
			}
		}
	}
	else if(dialogid == DIALOG_911MEDICAL)
	{
		if(response)
		{
			new zone[MAX_ZONE_NAME], mainzone[MAX_ZONE_NAME];
			if(strlen(inputtext) < 4) return ShowPlayerDialogEx(playerid, DIALOG_911MEDICAL, DIALOG_STYLE_INPUT, "911 Emergency Services", "Sorry, I don't quite understand. What is the medical emergency you are experiencing?", "Enter", "End Call");
			else
			{
				GetPlayer2DZone(playerid, zone, MAX_ZONE_NAME);
				GetPlayerMainZone(playerid, mainzone, MAX_ZONE_NAME);
				SendCallToQueue(playerid, inputtext, zone, mainzone, 1);
				SetPVarInt(playerid, "Has911Call", 1);
				SendClientMessageEx(playerid, TEAM_CYAN_COLOR, "Dispatch: We have alerted all units in the area.");
				SendClientMessageEx(playerid, TEAM_CYAN_COLOR, "Thank you for reporting this incident");
			}
		}
	}
	else if(dialogid == DIALOG_911POLICE)
	{
		if(response)
		{
			new zone[MAX_ZONE_NAME], mainzone[MAX_ZONE_NAME];
			if(strlen(inputtext) < 4) return ShowPlayerDialogEx(playerid, DIALOG_911POLICE, DIALOG_STYLE_INPUT, "911 Emergency Services", "Sorry, I don't quite understand. Why are you needing police assistance?", "Enter", "End Call");
			else
			{
				GetPlayer2DZone(playerid, zone, MAX_ZONE_NAME);
				GetPlayerMainZone(playerid, mainzone, MAX_ZONE_NAME);
				SendCallToQueue(playerid, inputtext, zone, mainzone, 2);
				SetPVarInt(playerid, "Has911Call", 1);
				SendClientMessageEx(playerid, TEAM_CYAN_COLOR, "Dispatch: We have alerted all units in the area.");
				SendClientMessageEx(playerid, TEAM_CYAN_COLOR, "Thank you for reporting this incident");
			}
		}
	}
	else if(dialogid == DIALOG_911TOWING)
	{
		if(response)
		{
			new zone[MAX_ZONE_NAME], mainzone[MAX_ZONE_NAME];
			if(strlen(inputtext) < 4) return ShowPlayerDialogEx(playerid, DIALOG_911TOWING, DIALOG_STYLE_INPUT, "911 Emergency Services", "Sorry, I don't quite understand. Why do you need towing assistance?", "Enter", "End Call");
			else
			{
				GetPlayer2DZone(playerid, zone, MAX_ZONE_NAME);
				GetPlayerMainZone(playerid, mainzone, MAX_ZONE_NAME);
				SendCallToQueue(playerid, inputtext, zone, mainzone, 3);
				SetPVarInt(playerid, "Has911Call", 1);
				SendClientMessageEx(playerid, TEAM_CYAN_COLOR, "Dispatch: We have alerted all units in the area.");
				SendClientMessageEx(playerid, TEAM_CYAN_COLOR, "Thank you for reporting this incident");
			}
		}
	}
	else if(dialogid == DIALOG_911FIRE)
	{
		if(response)
		{
			new zone[MAX_ZONE_NAME], mainzone[MAX_ZONE_NAME];
			if(strlen(inputtext) < 4) return ShowPlayerDialogEx(playerid, DIALOG_911FIRE, DIALOG_STYLE_INPUT, "911 Emergency Services", "Sorry, I don't quite understand. Why do you need assistance?", "Enter", "End Call");
			else
			{
				GetPlayer2DZone(playerid, zone, MAX_ZONE_NAME);
				GetPlayerMainZone(playerid, mainzone, MAX_ZONE_NAME);
				SendCallToQueue(playerid, inputtext, zone, mainzone, 5);
				SetPVarInt(playerid, "Has911Call", 1);
				SendClientMessageEx(playerid, TEAM_CYAN_COLOR, "Dispatch: We have alerted all units in the area.");
				SendClientMessageEx(playerid, TEAM_CYAN_COLOR, "Thank you for reporting this incident");
			}
		}
	}
	else if(dialogid == DIALOG_HOTLINE)
	{
		if(response)
		{
			new zone[MAX_ZONE_NAME], mainzone[MAX_ZONE_NAME];

			if(strlen(inputtext) < 4) {

				if(GetPVarType(playerid, "BUSICALL")) {

					new i = GetPVarInt(playerid, "BUSICALL");
					format(szMiscArray, sizeof(szMiscArray), "%s's Landline | %d", Businesses[i][bName], Businesses[i][bPhoneNr]);
				}
				else {

					new i = GetPVarInt(playerid, "GRPCALL");
					format(szMiscArray, sizeof(szMiscArray), "{%s}%s's Hotline", Group_NumToDialogHex(arrGroupData[i][g_hDutyColour]), arrGroupData[i][g_szGroupName]);
				}
				return ShowPlayerDialogEx(playerid, DIALOG_HOTLINE, DIALOG_STYLE_INPUT, szMiscArray, "I'm sorry, may I have a bit more information.", "Enter", "End Call");
			}
			else
			{
				GetPlayer2DZone(playerid, zone, MAX_ZONE_NAME);
				GetPlayerMainZone(playerid, mainzone, MAX_ZONE_NAME);
				if(GetPVarType(playerid, "GRPCALL")) SendCallToQueue(playerid, inputtext, zone, mainzone, 6);
				if(GetPVarType(playerid, "BUSICALL")) SendCallToQueue(playerid, inputtext, zone, mainzone, 7);
				SetPVarInt(playerid, "Has911Call", 1);
				SendClientMessageEx(playerid, TEAM_CYAN_COLOR, "Autoanswer: Thank you for calling our land line.");
				SendClientMessageEx(playerid, TEAM_CYAN_COLOR, "We will be with you shortly.");
			}
		}
	}
	else if(dialogid == DIALOG_SUSPECTMENU)
	{
		if(response)
		{
			if(strcmp(inputtext, "Other (Not Listed)", true) == 0)
			{
				return ShowPlayerDialogEx(playerid, DIALOG_SUSPECTMENU, DIALOG_STYLE_INPUT, "Specify a crime", "Please specify a crime", "Submit", "Cancel");
			}
			if(strlen(inputtext) <= 3)
			{
				return ShowPlayerCrimeDialog(playerid);
			}
			if(inputtext[0] == '-')
			{
				return ShowPlayerCrimeDialog(playerid);
			}
			new iTargetID = GetPVarInt(playerid, "suspect_TargetID");
			new
				szMessage[128];
			++PlayerInfo[iTargetID][pCrimes];
			new crimeid = -1;
			for(new i; i < sizeof(SuspectCrimes); i++)
			{
				if(strcmp(inputtext, SuspectCrimes[i]) == 0)
				{
					crimeid = i;
					break;
				}
			}
			if(crimeid != -1)
			{
				PlayerInfo[iTargetID][pWantedLevel] += SuspectCrimeInfo[crimeid][1];
			}
			else PlayerInfo[iTargetID][pWantedLevel] += 1;
			if(PlayerInfo[iTargetID][pWantedLevel] > 6)
			{
				PlayerInfo[iTargetID][pWantedLevel] = 6;
			}
			SetPlayerWantedLevel(iTargetID, PlayerInfo[iTargetID][pWantedLevel]);
			if(PlayerInfo[iTargetID][pConnectHours] < 32)
			{
				PlayerInfo[iTargetID][pWantedJailTime] += SuspectCrimeInfo[crimeid][2]/10;
				PlayerInfo[iTargetID][pWantedJailFine] += SuspectCrimeInfo[crimeid][3]/10;
			}
			else
			{
				PlayerInfo[iTargetID][pWantedJailTime] += SuspectCrimeInfo[crimeid][2];
				PlayerInfo[iTargetID][pWantedJailFine] += SuspectCrimeInfo[crimeid][3];
			}
			new szCountry[10], szCrime[128];
			if(arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance] == 1)
			{
				format(szCountry, sizeof(szCountry), "[SA] ");
			}
			else if(arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance] == 2)
			{
				format(szCountry, sizeof(szCountry), "[NE] ");
			}
			strcat(szCrime, szCountry);
			strcat(szCrime, inputtext);
			AddCrime(playerid, iTargetID, szCrime);

			format(szMessage, sizeof(szMessage), "You've commited a crime ( %s ). Reporter: %s.", szCrime, GetPlayerNameEx(playerid));
			SendClientMessageEx(iTargetID, COLOR_LIGHTRED, szMessage);

			format(szMessage, sizeof(szMessage), "Current wanted level: %d", PlayerInfo[iTargetID][pWantedLevel]);
			SendClientMessageEx(iTargetID, COLOR_YELLOW, szMessage);

			foreach(new i: Player)
			{
				if(IsACop(i) && arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance] == arrGroupData[PlayerInfo[i][pMember]][g_iAllegiance]) {
					format(szMessage, sizeof(szMessage), "HQ: All units APB (reporter: %s)",GetPlayerNameEx(playerid));
					SendClientMessageEx(i, TEAM_BLUE_COLOR, szMessage);
					format(szMessage, sizeof(szMessage), "HQ: Crime: %s, suspect: %s", szCrime, GetPlayerNameEx(iTargetID));
					SendClientMessageEx(i, TEAM_BLUE_COLOR, szMessage);
				}
			}
			PlayerInfo[iTargetID][pDefendTime] = 60;
		}
	}
	else if(dialogid == DIALOG_REPORTMENU)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: //Deathmatch
				{
					if(PlayerInfo[playerid][pJailTime] > 0) {
						SendClientMessage(playerid, COLOR_GREY, "You can't report while in prison.");
					}
					else {
						ShowPlayerDialogEx(playerid, DIALOG_REPORTDM, DIALOG_STYLE_INPUT, "Report player - Deathmatch", "Enter the name or ID of the player.", "Enter", "Cancel");
					}
				}
				case 1: //Falling
				{
					if(gettime() - LastShot[playerid] < 20)
					{
						SendClientMessageEx(playerid, COLOR_GREY, "You have been hurt in the last 20 seconds, abusing this system will result in a temporary ban.");
					}
					else
					{
						new
							Message[128];

						TogglePlayerControllable(playerid, 0);
						SetPVarInt(playerid, "IsFrozen", 1);
						SetPVarInt(playerid, "_rAutoM", 5);
						SetPVarInt(playerid, "_rRepID", playerid);
						format(Message, sizeof(Message), "{AA3333}AdmWarning{FFFF00}: %s (ID %d) has been frozen. (Falling Report)", GetPlayerNameEx(playerid), playerid);
						ABroadCast(COLOR_YELLOW, Message, 2);
						SendReportToQue(playerid, "Falling (Player Frozen)", 2, GetPlayerPriority(playerid));
						SendClientMessageEx(playerid, COLOR_WHITE, "A report has been sent to the available admins, you have been frozen.");
					}
				}
				case 2: //Hacking
				{
					ShowPlayerDialogEx(playerid, DIALOG_REPORTHACK, DIALOG_STYLE_INPUT, "Report player - Hacking", "Enter the name or ID of the player.", "Enter", "Cancel");
				}
				case 3: //Chicken Running
				{
					ShowPlayerDialogEx(playerid, DIALOG_REPORTCR, DIALOG_STYLE_INPUT, "Report player - Chicken Running", "Enter the name or ID of the player.", "Enter", "Cancel");
				}
				case 4: //Car Ramming
				{
					ShowPlayerDialogEx(playerid, DIALOG_REPORTCARRAM, DIALOG_STYLE_INPUT, "Report player - Car Ramming", "Enter the name or ID of the player.", "Enter", "Cancel");
				}
				case 5: //Power Gaming
				{
					ShowPlayerDialogEx(playerid, DIALOG_REPORTPG, DIALOG_STYLE_INPUT, "Report player - Power Gaming", "Enter the name or ID of the player.", "Enter", "Cancel");
				}
				case 6: //Meta Gaming
				{
					ShowPlayerDialogEx(playerid, DIALOG_REPORTMG, DIALOG_STYLE_INPUT, "Report player - Meta Gaming", "Enter the name or ID of the player.", "Enter", "Cancel");
				}
				case 7: //Gun Discharge Exploits
				{
					ShowPlayerDialogEx(playerid, DIALOG_REPORTGDE, DIALOG_STYLE_INPUT, "Report player - Gun Discharge Exploits", "Enter the name or ID of the player.", "Enter", "Cancel");
				}
				case 8: //Spamming
				{
					ShowPlayerDialogEx(playerid, DIALOG_REPORTSPAM, DIALOG_STYLE_INPUT, "Report player - Spamming", "Enter the name or ID of the player.", "Enter", "Cancel");
				}
				case 9: //Money Farming
				{
					ShowPlayerDialogEx(playerid, DIALOG_REPORTMF, DIALOG_STYLE_INPUT, "Report player - Money Farming", "Enter the name or ID of the player.", "Enter", "Cancel");
				}
				case 10: //Ban Evader
				{
					ShowPlayerDialogEx(playerid, DIALOG_REPORTBANEVADE, DIALOG_STYLE_INPUT, "Report player - Ban Evader", "Enter the name or ID of the player.", "Enter", "Cancel");
				}
				case 11: //General Exploits
				{
					ShowPlayerDialogEx(playerid, DIALOG_REPORTGE, DIALOG_STYLE_INPUT, "Report player - General Exploits", "Enter the name or ID of the player.", "Enter", "Cancel");
				}
				case 12: //Releasing Hitman Names
				{
					ShowPlayerDialogEx(playerid, DIALOG_REPORTRHN, DIALOG_STYLE_INPUT, "Report player - Releasing Hitman Names", "Enter the name or ID of the player.", "Enter", "Cancel");
				}
				case 13: //Running/Swimming Man Exploit
				{
					ShowPlayerDialogEx(playerid, DIALOG_REPORTRSE, DIALOG_STYLE_INPUT, "Report player - Running/Swimming Man Exploit", "Enter the name or ID of the player.", "Enter", "Cancel");
				}
				case 14: //Car Surfing
				{
					ShowPlayerDialogEx(playerid, DIALOG_REPORTCARSURF, DIALOG_STYLE_INPUT, "Report player - Car Surfing", "Enter the name or ID of the player.", "Enter", "Cancel");
				}
				case 15: //NonRp Behavior
				{
					ShowPlayerDialogEx(playerid, DIALOG_REPORTNRPB, DIALOG_STYLE_INPUT, "Report player - NonRP Behavior", "Enter the name or ID of the player.", "Enter", "Cancel");
				}
				case 16: //Next Page
				{
					ShowPlayerDialogEx(playerid, DIALOG_REPORTMENU2, DIALOG_STYLE_LIST, "Report Menu [2/2]", "Revenge Killing\nOOC Hit\nServer Advertising\nNonRP Name\nOther/Freetext (PVIP Only)\nHouse Move\nAppeal Admin Action\nPrize Claim\nShop Issue\nNot Listed Here\nRequest CA\nRequest Unmute\nPrevious Page","Select", "Exit");
				}
			}
		}
	}
	else if(dialogid == DIALOG_REPORTMENU2)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: //Revenge Killing
				{
					ShowPlayerDialogEx(playerid, DIALOG_REPORTRK, DIALOG_STYLE_INPUT, "Report player - Revenge Killing", "Enter the name or ID of the player.", "Enter", "Cancel");
				}
				case 1: //OOC Hit
				{
					ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "OOC Hit", "{FFFFFF}OOC Hits are to be handled on the forums. (Player Complaint)\n\n                 ng-gaming.net/forums", "Close", "");
				}
				case 2: //Server Advertising
				{
					ShowPlayerDialogEx(playerid, DIALOG_REPORTSA, DIALOG_STYLE_INPUT, "Report player - Server Advertising", "Enter the name or ID of the player.", "Enter", "Cancel");
				}
				case 3: //Non RP Name
				{
					ShowPlayerDialogEx(playerid, DIALOG_REPORTNRPN, DIALOG_STYLE_INPUT, "Report player - Non-RP Name", "Enter the name or ID of the player.", "Enter", "Cancel");
				}
				case 4: //Other/Freetext (PVip Only!!)
				{
					if(PlayerInfo[playerid][pDonateRank] >= 4) {
						ShowPlayerDialogEx(playerid, DIALOG_REPORTFREE, DIALOG_STYLE_INPUT,"Other / Free Text","Enter the message you want to send to the admin team.","Send","Cancel");
					}
					else {
						SendClientMessageEx(playerid, COLOR_GREY, "This is a Platinum VIP feature only.");
					}
				}
				case 5: //House Move
				{
					SendReportToQue(playerid, "House Move", 4, GetPlayerPriority(playerid));
					SendClientMessageEx(playerid, COLOR_WHITE, "Your house move request has been sent to the current available admins.");
				}
				case 6: //Appeal Admin Action
				{
					if(gettime() < GetPVarInt(playerid, "_rAppeal")) return SendClientMessageEx(playerid, COLOR_GREY, "You need to wait at least 60 seconds before appealing an admin action.");
					SendReportToQue(playerid,"Appeal Admin Action", 4, GetPlayerPriority(playerid));
					SendClientMessageEx(playerid, COLOR_WHITE, "Your Appeal Admin Action report has been sent to the current available admins.");
				}
				case 7: //Prize Claim
				{
					if(PlayerInfo[playerid][pFlagged] == 0) {
						SendClientMessageEx(playerid, COLOR_GREY, "You do not have any prize claims pending. (Not Flagged)");
						return 1;
					}
					else
					{
						SendReportToQue(playerid, "Prize Claim", 4, 5);
						SendClientMessageEx(playerid, COLOR_WHITE, "Your Prize Claim report has been sent to the current available admins.");
					}
				}
				case 8: //Shop Issue
				{
					ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Shop Issue", "{FFFFFF}You can use /shophelp for additional information.", "Close", "");
				}
				case 9: //Not Listed Here
				{
					ShowPlayerDialogEx(playerid, DIALOG_REPORTNOTLIST, DIALOG_STYLE_INPUT,"Not Listed","Using this category will receive a slower response from the admin team, please consider using the most appropriate category for a faster response.","Send","Cancel");
				}
				case 10: // Request CA
				{
					if(PlayerInfo[playerid][pRHMutes] >= 4 || PlayerInfo[playerid][pRHMuteTime] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "You are currently banned from requesting help.");
					if(JustReported[playerid] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "Wait 10 seconds after sending a next request!");
					JustReported[playerid]=10;
					format(string, sizeof(string), "** %s(%i) is requesting help, reason: Report Menu. (type /accepthelp %i)", GetPlayerNameEx(playerid), playerid, playerid);
					SendDutyAdvisorMessage(TEAM_AZTECAS_COLOR, string);
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You have requested help from a Advisor, wait for a reply.");
					SetPVarInt( playerid, "COMMUNITY_ADVISOR_REQUEST", 1 );
					SetPVarInt( playerid, "HelpTime", 5);
					SetPVarString( playerid, "HelpReason", "Report Menu");
					SetTimerEx( "HelpTimer", 60000, 0, "d", playerid);
				}
				case 11: //Request Unmute
				{
					if(gettime()-GetPVarInt(playerid, "UnmuteTime") < 300) {
						SendClientMessageEx(playerid, COLOR_GREY, "You must wait at least 5 minutes before requesting an unmute.");
						return 1;
					}
					ShowPlayerDialogEx(playerid, DIALOG_UNMUTE, DIALOG_STYLE_LIST, "Requesting Unmute", "Ad Unmute\nNewbie Unmute", "Select", "Exit");
				}
				case 12: //Previous Page
				{
					ShowPlayerDialogEx(playerid, DIALOG_REPORTMENU, DIALOG_STYLE_LIST, "Report Menu [1/2]", "Deathmatch\nHacking\nRevenge Killing\nChicken Running\nCar Ramming\nPower Gaming\nMeta Gaming\nGun Discharge Exploits (QS/CS)\nSpamming\nMoney Farming\nBan Evader\nGeneral Exploits\nReleasing Hitman Names\nRunning Man Exploiter\nCar Surfing\nNonRP Behavior\nNext Page","Select", "Exit");
				}
			}
		}
	}
	else if(dialogid == DIALOG_UNMUTE)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(PlayerInfo[playerid][pADMute] == 0) return SendClientMessageEx(playerid, COLOR_GREY, "You are not muted from /ads.");
					SetPVarInt(playerid, "_rAutoM", 1);
					SendReportToQue(playerid, "Ad Unmute", 2, GetPlayerPriority(playerid));
					SendClientMessageEx(playerid, COLOR_WHITE, "Your report has been sent to the current available admins.");
				}
				case 1:
				{
					if(PlayerInfo[playerid][pNMute] == 0) return SendClientMessageEx(playerid, COLOR_GREY, "You are not muted from /newb.");
					SetPVarInt(playerid, "_rAutoM", 2);
					SendReportToQue(playerid, "Newbie Unmute", 2, GetPlayerPriority(playerid));
					SendClientMessageEx(playerid, COLOR_WHITE, "Your report has been sent to the current available admins.");
				}
			}
		}
	}
	else if(dialogid == DIALOG_REPORTDM)
	{
		if(response)
		{
			new
				Player;

			if(sscanf(inputtext, "u", Player)) {
				ShowPlayerDialogEx(playerid, DIALOG_REPORTDM, DIALOG_STYLE_INPUT, "Report player - Deathmatch", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
				return 1;
			}
			if(!IsPlayerConnected(Player)) {
				ShowPlayerDialogEx(playerid, DIALOG_REPORTDM, DIALOG_STYLE_INPUT, "Report player - Deathmatch", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
			}
			if(PlayerInfo[playerid][pDMRMuted] != 0) return SendClientMessage(playerid, COLOR_GRAD2, "You are blocked from submitting DM reports.");
			//if(PlayerInfo[playerid][pLevel] < 2) return SendClientMessage(playerid, COLOR_GRAD2, "You must be level 2 to use this command.");
			if(playerid == Player) return SendClientMessage(playerid, COLOR_GREY, "You can't use this command on yourself!");

			if(PlayerInfo[Player][pAdmin] >= 2 && PlayerInfo[Player][pTogReports] != 1) return SendClientMessage(playerid, COLOR_GREY, "You can't use this command on admins!");
			if(gettime() - ShotPlayer[Player][playerid] < 300)
			{
				SetPVarInt(playerid, "pDMReport", Player);
				ShowPlayerDialogEx(playerid, DMRCONFIRM, DIALOG_STYLE_MSGBOX, "DM Report", "You personally witnessed the reported player death matching within the last 60 seconds. Abuse of this command could result in a temporary ban.", "Confirm", "Cancel");
			}
			else
			{
				SendClientMessage(playerid, COLOR_WHITE, "You have not been shot by that person or have already reported them in the last 5 minutes.");
				SendClientMessage(playerid, COLOR_WHITE, "As a reminder, abuse of this system could lead to punishment up to a temporary ban.");
			}
		}
	}
	else if(dialogid == DIALOG_REPORTRK)
	{
		if(response)
		{
			new
				Player,
				Message[128];

			if(sscanf(inputtext, "u", Player)) {
				ShowPlayerDialogEx(playerid, DIALOG_REPORTRK, DIALOG_STYLE_INPUT, "Report player - Revenge Killing", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
				return 1;
			}
			else if(!IsPlayerConnected(Player)) {
				ShowPlayerDialogEx(playerid, DIALOG_REPORTRK, DIALOG_STYLE_INPUT, "Report player - Revenge Killing", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
			}
			else if(Player == playerid) {
				SendClientMessage(playerid, COLOR_GREY, "You can't submit a report on yourself.");
			}
			else {
				SetPVarInt(playerid, "_rAutoM", 4);
				SetPVarInt(playerid, "_rRepID", Player);
				format(Message, sizeof(Message), "%s(%i) Revenge Killing", GetPlayerNameEx(Player), Player);
				SendReportToQue(playerid, Message, 2, GetPlayerPriority(playerid));
				format(Message, sizeof(Message), "You have submitted a report on %s for Revenge Killing. It has been sent to all available admins.", GetPlayerNameEx(Player));
				SendClientMessageEx(playerid, COLOR_WHITE, Message);
				SetPVarInt(playerid, "AlertedThisPlayer", Player);
				SetPVarInt(playerid, "AlertType", 2);
				AlertTime[playerid] = 300;
			}
		}
	}
	else if(dialogid == DIALOG_REPORTCR)
	{
		if(response)
		{
			new
				Player,
				Message[128];

			if(sscanf(inputtext, "u", Player)) {
				ShowPlayerDialogEx(playerid, DIALOG_REPORTCR, DIALOG_STYLE_INPUT, "Report player - Chicken Running", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
				return 1;
			}
			else if(!IsPlayerConnected(Player)) {
				ShowPlayerDialogEx(playerid, DIALOG_REPORTCR, DIALOG_STYLE_INPUT, "Report player - Chicken Running", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
			}
			else if(Player == playerid) {
				SendClientMessage(playerid, COLOR_GREY, "You can't submit a report on yourself.");
			}
			else {
				SetPVarInt(playerid, "_rAutoM", 5);
				SetPVarInt(playerid, "_rRepID", Player);
				format(Message, sizeof(Message), "%s(%i) Chicken Running", GetPlayerNameEx(Player), Player);
				SendReportToQue(playerid,Message, 2, GetPlayerPriority(playerid));
				format(Message, sizeof(Message), "You have submitted a report on %s for Chicken Running. It has been sent to all available admins.", GetPlayerNameEx(Player));
				SendClientMessageEx(playerid, COLOR_WHITE, Message);
			}
		}
	}
	else if(dialogid == DIALOG_REPORTCARRAM)
	{
		if(response)
		{
			new
				Player,
				Message[128];

			if(sscanf(inputtext, "u", Player)) {
				ShowPlayerDialogEx(playerid, DIALOG_REPORTCARRAM, DIALOG_STYLE_INPUT, "Report player - Car Ramming", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
				return 1;
			}
			else if(!IsPlayerConnected(Player)) {
				ShowPlayerDialogEx(playerid, DIALOG_REPORTCARRAM, DIALOG_STYLE_INPUT, "Report player - Car Ramming", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
			}
			else if(Player == playerid) {
				SendClientMessage(playerid, COLOR_GREY, "You can't submit a report on yourself.");
			}
			else {
				SetPVarInt(playerid, "_rAutoM", 5);
				SetPVarInt(playerid, "_rRepID", Player);
				format(Message, sizeof(Message), "%s(%i) Car Ramming", GetPlayerNameEx(Player), Player);
				SendReportToQue(playerid,Message, 2, GetPlayerPriority(playerid));
				format(Message, sizeof(Message), "You have submitted a report on %s for Car Ramming. It has been sent to all available admins.", GetPlayerNameEx(Player));
				SendClientMessageEx(playerid, COLOR_WHITE, Message);
				SetPVarInt(playerid, "AlertedThisPlayer", Player);
				SetPVarInt(playerid, "AlertType", 4);
				AlertTime[playerid] = 300;
			}
		}
	}
	else if(dialogid == DIALOG_REPORTPG)
	{
		if(response)
		{
			new
				Player,
				Message[128];

			if(sscanf(inputtext, "u", Player)) {
				ShowPlayerDialogEx(playerid, DIALOG_REPORTPG, DIALOG_STYLE_INPUT, "Report player - Power Gaming", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
				return 1;
			}
			else if(!IsPlayerConnected(Player)) {
				ShowPlayerDialogEx(playerid, DIALOG_REPORTPG, DIALOG_STYLE_INPUT, "Report player - Power Gaming", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
			}
			else if(Player == playerid) {
				SendClientMessage(playerid, COLOR_GREY, "You can't submit a report on yourself.");
			}
			else {
				SetPVarInt(playerid, "_rAutoM", 5);
				SetPVarInt(playerid, "_rRepID", Player);
				format(Message, sizeof(Message), "%s(%i) Power Gaming", GetPlayerNameEx(Player), Player);
				SendReportToQue(playerid,Message, 2, GetPlayerPriority(playerid));
				format(Message, sizeof(Message), "You have submitted a report on %s for Power Gaming. It has been sent to all available admins.", GetPlayerNameEx(Player));
				SendClientMessageEx(playerid, COLOR_WHITE, Message);
			}
		}
	}
	else if(dialogid == DIALOG_REPORTMG)
	{
		if(response)
		{
			new
				Player,
				Message[128];

			if(sscanf(inputtext, "u", Player)) {
				ShowPlayerDialogEx(playerid, DIALOG_REPORTMG, DIALOG_STYLE_INPUT, "Report player - Meta Gaming", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
				return 1;
			}
			else if(!IsPlayerConnected(Player)) {
				ShowPlayerDialogEx(playerid, DIALOG_REPORTMG, DIALOG_STYLE_INPUT, "Report player - Meta Gaming", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
			}
			else if(Player == playerid) {
				SendClientMessage(playerid, COLOR_GREY, "You can't submit a report on yourself.");
			}
			else {
				SetPVarInt(playerid, "_rAutoM", 6);
				SetPVarInt(playerid, "_rRepID", Player);
				format(Message, sizeof(Message), "%s(%i) Meta Gaming", GetPlayerNameEx(Player), Player);
				SendReportToQue(playerid,Message, 2, GetPlayerPriority(playerid));
				format(Message, sizeof(Message), "You have submitted a report on %s for Meta Gaming. It has been sent to all available admins.", GetPlayerNameEx(Player));
				SendClientMessageEx(playerid, COLOR_WHITE, Message);
			}
		}
	}
	else if(dialogid == DIALOG_REPORTSPAM)
	{
		if(response && !GetPVarType(playerid, "HasReport"))
		{
			new
				Player,
				Message[128];

			if(sscanf(inputtext, "u", Player)) {
				ShowPlayerDialogEx(playerid, DIALOG_REPORTSPAM, DIALOG_STYLE_INPUT, "Report player - Spamming", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
				return 1;
			}
			else if(!IsPlayerConnected(Player)) {
				ShowPlayerDialogEx(playerid, DIALOG_REPORTSPAM, DIALOG_STYLE_INPUT, "Report player - Spamming", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
			}
			else if(Player == playerid) {
				SendClientMessage(playerid, COLOR_GREY, "You can't submit a report on yourself.");
			}
			else {
				SetPVarInt(playerid, "_rAutoM", 6);
				SetPVarInt(playerid, "_rRepID", Player);
				format(Message, sizeof(Message), "%s(%i) Spamming", GetPlayerNameEx(Player), Player);
				SendReportToQue(playerid,Message, 2, GetPlayerPriority(playerid));
				format(Message, sizeof(Message), "You have submitted a report on %s for Spamming. It has been sent to all available admins.", GetPlayerNameEx(Player));
				SendClientMessageEx(playerid, COLOR_WHITE, Message);
				SetPVarInt(playerid, "AlertedThisPlayer", Player);
				SetPVarInt(playerid, "AlertType", 6);
				AlertTime[playerid] = 300;
			}
		}
	}
	else if(dialogid == DIALOG_REPORTGDE)
	{
		if(response && !GetPVarType(playerid, "HasReport"))
		{
			new
				Player,
				Message[128];

			if(sscanf(inputtext, "u", Player)) {
				ShowPlayerDialogEx(playerid, DIALOG_REPORTGDE, DIALOG_STYLE_INPUT, "Report player - Gun Discharge Exploits", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
				return 1;
			}
			else if(!IsPlayerConnected(Player)) {
				ShowPlayerDialogEx(playerid, DIALOG_REPORTGDE, DIALOG_STYLE_INPUT, "Report player - Gun Discharge Exploits", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
			}
			else if(Player == playerid) {
				SendClientMessage(playerid, COLOR_GREY, "You can't submit a report on yourself.");
			}
			else {
				SetPVarInt(playerid, "_rAutoM", 5);
				SetPVarInt(playerid, "_rRepID", Player);
				format(Message, sizeof(Message), "%s(%i) Gun Discharge Exploits", GetPlayerNameEx(Player), Player);
				SendReportToQue(playerid,Message, 2, GetPlayerPriority(playerid));
				format(Message, sizeof(Message), "You have submitted a report on %s for Gun Discharge Exploits. It has been sent to all available admins.", GetPlayerNameEx(Player));
				SendClientMessageEx(playerid, COLOR_WHITE, Message);
				SetPVarInt(playerid, "AlertedThisPlayer", Player);
				SetPVarInt(playerid, "AlertType", 7);
				AlertTime[playerid] = 300;
			}
		}
	}
	else if(dialogid == DIALOG_REPORTHACK)
	{
		if(response && !GetPVarType(playerid, "HasReport"))
		{
			new
				Player,
				Message[128];

			if(sscanf(inputtext, "u", Player)) {
				ShowPlayerDialogEx(playerid, DIALOG_REPORTHACK, DIALOG_STYLE_INPUT, "Report player - Hacking", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
				return 1;
			}
			else if(!IsPlayerConnected(Player)) {
				ShowPlayerDialogEx(playerid, DIALOG_REPORTHACK, DIALOG_STYLE_INPUT, "Report player - Hacking", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
			}
			else if(Player == playerid) {
				SendClientMessage(playerid, COLOR_GREY, "You can't submit a report on yourself.");
			}
			else {
				SetPVarInt(playerid, "_rAutoM", 5);
				SetPVarInt(playerid, "_rRepID", Player);
				format(Message, sizeof(Message), "%s(%i) Hacking", GetPlayerNameEx(Player), Player);
				SendReportToQue(playerid,Message, 2, 2);
				format(Message, sizeof(Message), "You have submitted a report on %s for Hacking. It has been sent to all available admins.", GetPlayerNameEx(Player));
				SendClientMessageEx(playerid, COLOR_WHITE, Message);
			}
		}
	}
	else if(dialogid == DIALOG_REPORTMF)
	{
		if(response && !GetPVarType(playerid, "HasReport"))
		{
			new
				Player,
				Message[128];

			if(sscanf(inputtext, "u", Player)) {
				ShowPlayerDialogEx(playerid, DIALOG_REPORTMF, DIALOG_STYLE_INPUT, "Report player - Money Farming", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
				return 1;
			}
			else if(!IsPlayerConnected(Player)) {
				ShowPlayerDialogEx(playerid, DIALOG_REPORTMF, DIALOG_STYLE_INPUT, "Report player - Money Farming", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
			}
			else if(Player == playerid) {
				SendClientMessage(playerid, COLOR_GREY, "You can't submit a report on yourself.");
			}
			else {
				format(Message, sizeof(Message), "%s(%i) Money Farming", GetPlayerNameEx(Player), Player);
				SendReportToQue(playerid,Message, 2, GetPlayerPriority(playerid));
				format(Message, sizeof(Message), "You have submitted a report on %s for Money Farming. It has been sent to all available admins.", GetPlayerNameEx(Player));
				SendClientMessageEx(playerid, COLOR_WHITE, Message);
			}
		}
	}
	else if(dialogid == DIALOG_REPORTSA)
	{
		if(response && !GetPVarType(playerid, "HasReport"))
		{
			new
				Player,
				Message[128];

			if(sscanf(inputtext, "u", Player)) {
				ShowPlayerDialogEx(playerid, DIALOG_REPORTSA, DIALOG_STYLE_INPUT, "Report player - Server Advertising", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
				return 1;
			}
			else if(!IsPlayerConnected(Player)) {
				ShowPlayerDialogEx(playerid, DIALOG_REPORTSA, DIALOG_STYLE_INPUT, "Report player - Server Advertising", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
			}
			else if(Player == playerid) {
				SendClientMessage(playerid, COLOR_GREY, "You can't submit a report on yourself.");
			}
			else {
				SetPVarInt(playerid, "_rAutoM", 6);
				SetPVarInt(playerid, "_rRepID", Player);
				format(Message, sizeof(Message), "%s(%i) Server Advertising", GetPlayerNameEx(Player), Player);
				SendReportToQue(playerid,Message, 2, 2);
				format(Message, sizeof(Message), "You have submitted a report on %s for Server Advertising. It has been sent to all available admins.", GetPlayerNameEx(Player));
				SendClientMessageEx(playerid, COLOR_WHITE, Message);
			}
		}
	}
	else if(dialogid == DIALOG_REPORTNRPN)
	{
		if(response && !GetPVarType(playerid, "HasReport"))
		{
			new
				Player,
				Message[128];

			if(sscanf(inputtext, "u", Player)) {
				ShowPlayerDialogEx(playerid, DIALOG_REPORTNRPN, DIALOG_STYLE_INPUT, "Report player - NonRP Name", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
				return 1;
			}
			else if(!IsPlayerConnected(Player)) {
				ShowPlayerDialogEx(playerid, DIALOG_REPORTNRPN, DIALOG_STYLE_INPUT, "Report player - NonRP Name", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
			}
			else if(Player == playerid) {
				SendClientMessage(playerid, COLOR_GREY, "You can't submit a report on yourself.");
			}
			else {
				SetPVarInt(playerid, "_rAutoM", 3);
				SetPVarInt(playerid, "_rRepID", Player);
				format(Message, sizeof(Message), "%s(%i) NonRP Name", GetPlayerNameEx(Player), Player);
				SendReportToQue(playerid,Message, 2, GetPlayerPriority(playerid));
				format(Message, sizeof(Message), "You have submitted a report on %s for NonRP Name. It has been sent to all available admins.", GetPlayerNameEx(Player));
				SendClientMessageEx(playerid, COLOR_WHITE, Message);
				SetPVarInt(playerid, "AlertedThisPlayer", Player);
				SetPVarInt(playerid, "AlertType", 8);
				AlertTime[playerid] = 300;
			}
		}
	}
	else if(dialogid == DIALOG_REPORTBANEVADE)
	{
		if(response && !GetPVarType(playerid, "HasReport"))
		{
			new
				Player,
				Message[128];

			if(sscanf(inputtext, "u", Player)) {
				ShowPlayerDialogEx(playerid, DIALOG_REPORTBANEVADE, DIALOG_STYLE_INPUT, "Report player - Ban Evader", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
				return 1;
			}
			else if(!IsPlayerConnected(Player)) {
				ShowPlayerDialogEx(playerid, DIALOG_REPORTBANEVADE, DIALOG_STYLE_INPUT, "Report player - Ban Evader", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
			}
			else if(Player == playerid) {
				SendClientMessage(playerid, COLOR_GREY, "You can't submit a report on yourself.");
			}
			else {
				format(Message, sizeof(Message), "%s(%i) Ban Evader", GetPlayerNameEx(Player), Player);
				SendReportToQue(playerid,Message, 2, GetPlayerPriority(playerid));
				format(Message, sizeof(Message), "You have submitted a report on %s for Ban Evader. It has been sent to all available admins.", GetPlayerNameEx(Player));
				SendClientMessageEx(playerid, COLOR_WHITE, Message);
			}
		}
	}
	else if(dialogid == DIALOG_REPORTGE)
	{
		if(response && !GetPVarType(playerid, "HasReport"))
		{
			new
				Player,
				Message[128];

			if(sscanf(inputtext, "u", Player)) {
				ShowPlayerDialogEx(playerid, DIALOG_REPORTGE, DIALOG_STYLE_INPUT, "Report player - General Exploits", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
				return 1;
			}
			else if(!IsPlayerConnected(Player)) {
				ShowPlayerDialogEx(playerid, DIALOG_REPORTGE, DIALOG_STYLE_INPUT, "Report player - General Exploits", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
			}
			else if(Player == playerid) {
				SendClientMessage(playerid, COLOR_GREY, "You can't submit a report on yourself.");
			}
			else {
				SetPVarInt(playerid, "_rAutoM", 5);
				SetPVarInt(playerid, "_rRepID", Player);
				format(Message, sizeof(Message), "%s(%i) General Exploits", GetPlayerNameEx(Player), Player);
				SendReportToQue(playerid,Message, 2, GetPlayerPriority(playerid));
				format(Message, sizeof(Message), "You have submitted a report on %s for General Exploits. It has been sent to all available admins.", GetPlayerNameEx(Player));
				SendClientMessageEx(playerid, COLOR_WHITE, Message);
			}
		}
	}
	else if(dialogid == DIALOG_REPORTRHN)
	{
		if(response && !GetPVarType(playerid, "HasReport"))
		{
			new
				Player,
				Message[128];

			if(sscanf(inputtext, "u", Player)) {
				ShowPlayerDialogEx(playerid, DIALOG_REPORTRHN, DIALOG_STYLE_INPUT, "Report player - Releasing Hitman Names", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
				return 1;
			}
			else if(!IsPlayerConnected(Player)) {
				ShowPlayerDialogEx(playerid, DIALOG_REPORTRHN, DIALOG_STYLE_INPUT, "Report player - Releasing Hitman Names", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
			}
			else if(Player == playerid) {
				SendClientMessage(playerid, COLOR_GREY, "You can't submit a report on yourself.");
			}
			else {
				format(Message, sizeof(Message), "%s(%i) Releasing Hitman Names", GetPlayerNameEx(Player), Player);
				SendReportToQue(playerid,Message, 2, GetPlayerPriority(playerid));
				format(Message, sizeof(Message), "You have submitted a report on %s for Releasing Hitman Names. It has been sent to all available admins.", GetPlayerNameEx(Player));
				SendClientMessageEx(playerid, COLOR_WHITE, Message);
			}
		}
	}
	else if(dialogid == DIALOG_REPORTRSE)
	{
		if(response && !GetPVarType(playerid, "HasReport"))
		{
			new
				Player,
				Message[128];

			if(sscanf(inputtext, "u", Player)) {
				ShowPlayerDialogEx(playerid, DIALOG_REPORTRSE, DIALOG_STYLE_INPUT, "Report player - Running/Swimming Man Exploit", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
				return 1;
			}
			else if(!IsPlayerConnected(Player)) {
				ShowPlayerDialogEx(playerid, DIALOG_REPORTRSE, DIALOG_STYLE_INPUT, "Report player - Running/Swimming Man Exploit", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
			}
			else if(Player == playerid) {
				SendClientMessage(playerid, COLOR_GREY, "You can't submit a report on yourself.");
			}
			else {
				SetPVarInt(playerid, "_rAutoM", 5);
				SetPVarInt(playerid, "_rRepID", Player);
				format(Message, sizeof(Message), "%s(%i) Running/Swimming Man Exploit", GetPlayerNameEx(Player), Player);
				SendReportToQue(playerid,Message, 2, GetPlayerPriority(playerid));
				format(Message, sizeof(Message), "You have submitted a report on %s for Running/Swimming Man Exploit. It has been sent to all available admins.", GetPlayerNameEx(Player));
				SendClientMessageEx(playerid, COLOR_WHITE, Message);
			}
		}
	}
	else if(dialogid == DIALOG_REPORTCARSURF)
	{
		if(response && !GetPVarType(playerid, "HasReport"))
		{
			new
				Player,
				Message[128];

			if(sscanf(inputtext, "u", Player)) {
				ShowPlayerDialogEx(playerid, DIALOG_REPORTCARSURF, DIALOG_STYLE_INPUT, "Report player - Car Surfing", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
				return 1;
			}
			else if(!IsPlayerConnected(Player)) {
				ShowPlayerDialogEx(playerid, DIALOG_REPORTCARSURF, DIALOG_STYLE_INPUT, "Report player - Car Surfing", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
			}
			else if(Player == playerid) {
				SendClientMessage(playerid, COLOR_GREY, "You can't submit a report on yourself.");
			}
			else {
				SetPVarInt(playerid, "_rAutoM", 5);
				SetPVarInt(playerid, "_rRepID", Player);
				format(Message, sizeof(Message), "%s(%i) Car Surfing", GetPlayerNameEx(Player), Player);
				SendReportToQue(playerid,Message, 2, GetPlayerPriority(playerid));
				format(Message, sizeof(Message), "You have submitted a report on %s for Car Surfing. It has been sent to all available admins.", GetPlayerNameEx(Player));
				SendClientMessageEx(playerid, COLOR_WHITE, Message);
				SetPVarInt(playerid, "AlertedThisPlayer", Player);
				SetPVarInt(playerid, "AlertType", 10);
				AlertTime[playerid] = 300;
			}
		}
	}
	else if(dialogid == DIALOG_REPORTNRPB)
	{
		if(response && !GetPVarType(playerid, "HasReport"))
		{
			new
				Player;

			if(sscanf(inputtext, "u", Player)) {
				ShowPlayerDialogEx(playerid, DIALOG_REPORTNRPB, DIALOG_STYLE_INPUT, "Report player - NonRP Behavior", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
				return 1;
			}
			else if(!IsPlayerConnected(Player)) {
				ShowPlayerDialogEx(playerid, DIALOG_REPORTNRPB, DIALOG_STYLE_INPUT, "Report player - NonRP Behavior", "(Error - Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");
			}
			else if(Player == playerid) {
				SendClientMessage(playerid, COLOR_GREY, "You can't submit a report on yourself.");
			}
			else {
				SetPVarInt(playerid, "NRPB", Player);
				ShowPlayerDialogEx(playerid, DIALOG_REPORTNRPB2, DIALOG_STYLE_INPUT,"Report player - NonRP Behavior","Explain what the person is doing.","Send","Cancel");
			}
		}
	}
	else if(dialogid == DIALOG_REPORTNRPB2)
	{
		if(response == 1 && !GetPVarType(playerid, "HasReport"))
		{
			if(isnull(inputtext)) return ShowPlayerDialogEx(playerid, DIALOG_REPORTNRPB2, DIALOG_STYLE_INPUT,"Report player - NonRP Behavior","Explain what the person is doing.","Send","Cancel");

			new
				Message[128],
				Player;

			Player = GetPVarInt(playerid, "NRPB");
			SetPVarInt(playerid, "_rAutoM", 5);
			SetPVarInt(playerid, "_rRepID", Player);
			format(Message, sizeof(Message), "%s(%i), %s (nonrp behavior)", GetPlayerNameEx(Player), Player, inputtext);
			SendReportToQue(playerid, Message, 2, GetPlayerPriority(playerid));
			format(Message, sizeof(Message), "You have submitted a report on %s for NonRP Behavior. It has been sent to all available admins.", GetPlayerNameEx(Player));
			SendClientMessageEx(playerid, COLOR_WHITE, Message);
			DeletePVar(playerid, "NRPB");
			SetPVarInt(playerid, "AlertedThisPlayer", Player);
			SetPVarInt(playerid, "AlertType", 11);
			AlertTime[playerid] = 300;
		}
		else {
			DeletePVar(playerid, "NRPB");
		}
	}
	else if(dialogid == DIALOG_REPORTFREE)
	{
		if(response == 1 && !GetPVarType(playerid, "HasReport"))
		{
			if(isnull(inputtext)) {
				ShowPlayerDialogEx(playerid, DIALOG_REPORTFREE, DIALOG_STYLE_INPUT,"Other / Free Text","(Error - No Message) Enter the message you want to send to the admin team.","Send","Cancel");
			}

			SendReportToQue(playerid, inputtext, 2, GetPlayerPriority(playerid));
			SendClientMessageEx(playerid, COLOR_WHITE, "Your message has been sent to the admin team.");
		}
	}
	else if(dialogid == DIALOG_REPORTNOTLIST)
	{
		if(response == 1 && !GetPVarType(playerid, "HasReport"))
		{
			if(isnull(inputtext)) {
				ShowPlayerDialogEx(playerid, DIALOG_REPORTNOTLIST, DIALOG_STYLE_INPUT,"Not Listed","(Error - No Message) Using this category will receive a slower response from the admin team, please consider using the most appropriate category for a faster response","Send","Cancel");
			}

			SetPVarString(playerid, "ReportNotList", inputtext);

			ShowPlayerDialogEx(playerid, DIALOG_REPORTNOTLIST2, DIALOG_STYLE_MSGBOX, "Not Listed", "Are you sure your report doesn't fit under any other report categories?", "Yes", "No");
		}
	}
	else if(dialogid == DIALOG_REPORTNOTLIST2)
	{
		if(response == 1 && !GetPVarType(playerid, "HasReport"))
		{
			new Message[128];

			GetPVarString(playerid, "ReportNotList", Message, sizeof(Message));
			SendReportToQue(playerid, Message, 2, 5);
			SendClientMessageEx(playerid, COLOR_WHITE, "Your message has been sent to the admin team.");
		}
	}
	else if(dialogid == DIALOG_SPEAKTOADMIN)
	{
		if(response == 1)
		{
			if(isnull(inputtext)) {
				ShowPlayerDialogEx(playerid, DIALOG_REPORTNOTLIST, DIALOG_STYLE_INPUT,"Other / Free Text","(Error - No Message) Using this category will receive a slower response from the admin team, please consider using the most appropriate category for a faster response","Send","Cancel");
			}

			SetPVarString(playerid, "ReportNotList", inputtext);

			ShowPlayerDialogEx(playerid, DIALOG_REPORTNOTLIST2, DIALOG_STYLE_MSGBOX, "Other / Free Text", "Are you sure you need to contact an admin?", "Yes", "No");
		}
	}
	else if(dialogid == DIALOG_REPORTNAME)
	{
		new
			Player;

		Player = GetPVarInt(playerid, "NameChange");

		if(GetPVarInt(Player, "RequestingNameChange") == 0)
		{
			SendClientMessageEx(playerid, COLOR_GREY, "That person isn't requesting a namechange!");
			return 1;
		}
		if(response == 1)
		{
			new newname[MAX_PLAYER_NAME], tmpName[24];
			GetPVarString(Player, "NewNameRequest", newname, MAX_PLAYER_NAME);
			mysql_escape_string(newname, tmpName);
			SetPVarString(Player, "NewNameRequest", tmpName);

			mysql_format(MainPipeline, string, sizeof(string), "SELECT `Username` FROM `accounts` WHERE `Username`='%s'", tmpName);
			mysql_tquery(MainPipeline, string, "OnApproveName", "ii", playerid, Player);

		}
		else
		{
			SendClientMessageEx(Player,COLOR_YELLOW," Your name change request has been denied.");
			format(string, sizeof(string), " You have denied %s's name change request.", GetPlayerNameEx(Player));
			SendClientMessageEx(playerid,COLOR_YELLOW,string);
			format(string, sizeof(string), "%s has denied %s's name change request",GetPlayerNameEx(playerid),GetPlayerNameEx(Player));
			ABroadCast(COLOR_YELLOW, string, 3);
			SetPVarInt(Player, "LastNameChange", gettime());
			DeletePVar(Player, "RequestingNameChange");
		}
	}
	else if(dialogid == DIALOG_REPORTTEAMNAME)
	{
		new
			Player;

		Player = GetPVarInt(playerid, "RFLNameChange");

		if(GetPVarInt(Player, "RFLNameRequest") == 0)
		{
			SendClientMessageEx(playerid, COLOR_GREY, "That person isn't requesting a namechange!");
			return 1;
		}
		if(response == 1)
		{
			new newname[25], tmpName[25], query[128];
			GetPVarString(Player, "NewRFLName", newname, MAX_PLAYER_NAME);
			mysql_escape_string(newname, tmpName);
			SetPVarString(Player, "NewRFLName", tmpName);
			mysql_format(MainPipeline, query, sizeof(query), "SELECT `name` FROM `rflteams` WHERE `name` = '%s'", tmpName);
			mysql_tquery(MainPipeline, query, "OnCheckRFLName", "ii", playerid, Player);
		}
		else
		{
			SendClientMessageEx(Player,COLOR_YELLOW," Your team name change request has been denied.");
			format(string, sizeof(string), " You have denied %s's team name change request.", GetPlayerNameEx(Player));
			SendClientMessageEx(playerid,COLOR_YELLOW,string);
			format(string, sizeof(string), "%s has denied %s's team name change request",GetPlayerNameEx(playerid),GetPlayerNameEx(Player));
			ABroadCast(COLOR_YELLOW, string, 3);
			DeletePVar(Player, "RFLNameRequest");
			DeletePVar(playerid, "RFLNameChange");
			DeletePVar(Player, "NewRFLName");
		}
	}
	else if(dialogid == DIALOG_DEDICATEDPLAYER)
	{
		if(response)
		{
			new
				szName[MAX_PLAYER_NAME],
				szDialogStr[260],
				szFileStr[32],
				iPos,
				iCount = 0,
				iTime = gettime() - 5184000,
				File: fDedicated = fopen("RewardDedicated.cfg", io_read);

			GetPVarString(playerid, "DedicatedPlayer", szName, sizeof(szName));

			while(fread(fDedicated, szFileStr)) {
				iPos = strfind(szFileStr, "|");

				if(strval(szFileStr[iPos + 1]) > iTime && iCount == 0 && strcmp(szFileStr, szName, false, strlen(szName))==0 ) {
					szFileStr[iPos] = 0;
					strcat(szDialogStr, szFileStr);
					iCount++;

					strcat(szDialogStr, "\n");
				}
				else if(iCount > 0)
				{
					szFileStr[iPos] = 0;
					strcat(szDialogStr, szFileStr);
					iCount++;
					if(iCount == 10) {
						SetPVarString(playerid, "DedicatedPlayer", szFileStr);
						printf("%s - Dedicated Player", szFileStr);
						break;
					}
					strcat(szDialogStr, "\n");
				}
			}
			fclose(fDedicated);
			//szDialogStr[strlen(szDialogStr) - 1] = 0;
			if(iCount == 10)
			{
				ShowPlayerDialogEx(playerid, DIALOG_DEDICATEDPLAYER, DIALOG_STYLE_LIST, "Dedicated Players (over 150 Reward Hours)", szDialogStr, "Next", "Exit");
			}
			else
			{
				ShowPlayerDialogEx(playerid, 0, DIALOG_STYLE_LIST, "Dedicated Players (over 150 Reward Hours)", szDialogStr, "Exit", "");
			}
			return 1;
		}
	}

	else if (dialogid == DIALOG_POSTAMP && response)
	{

		switch (listitem) {
			case REGULAR_MAIL: {
				SetPVarInt(playerid, "LetterTime", 240);
				SetPVarInt(playerid, "LetterCost", 100);
			}
			case PRIORITY_MAIL: {
				SetPVarInt(playerid, "LetterTime", 120);
				SetPVarInt(playerid, "LetterCost", 250);
			}
			case PREMIUM_MAIL: {
				if (PlayerInfo[playerid][pDonateRank] < 3) {
					return SendClientMessageEx(playerid, COLOR_GREY, "You need to be at least Gold VIP for sending Premium Mail.");
				}
				else {
					SetPVarInt(playerid, "LetterCost", 500);
					SetPVarInt(playerid, "LetterNotify", 1);
				}
			}
			case GOVERNMENT_MAIL:  {
				if (!IsAGovernment(playerid) && !IsACop(playerid) && !IsAJudge(playerid)) {
					return SendClientMessageEx(playerid, COLOR_GREY, " Only Government agencies can use Government Mail! ");
				}
				if (PlayerInfo[playerid][pRank] < 4) {
					return SendClientMessageEx(playerid, COLOR_GREY, " Only rank 4 or higher can do this.");
				}
				SetPVarInt(playerid, "LetterTime", 60);
				SetPVarInt(playerid, "LetterCost", 500);
				SetPVarInt(playerid, "LetterNotify", 1);
				SetPVarInt(playerid, "LetterGov", 1);
			}
			default:
				return 1;
		}

		if (listitem != GOVERNMENT_MAIL && GetPlayerCash(playerid) < GetPVarInt(playerid, "LetterCost")) {
			DeletePVar(playerid, "LetterTime");
			DeletePVar(playerid, "LetterCost");
			return SendClientMessageEx(playerid, COLOR_GREY, "You can't afford the stamp.");
		}

		ShowPlayerDialogEx(playerid, DIALOG_PORECEIVER, DIALOG_STYLE_INPUT, "Recipient", "{FFFFFF}Please type the name of the recipient (online or offline)", "Next", "Cancel");

		return 1;

	}

	else if (dialogid == DIALOG_PORECEIVER && response)
	{

		if (!strlen(inputtext)) {
			ShowPlayerDialogEx(playerid, DIALOG_PORECEIVER, DIALOG_STYLE_INPUT, "Recipient", "{FF3333}Error: {FFFFFF}Recipient Name Not Entered!\n\nPlease type the name of the recipient (online or offline)", "Next", "Cancel");
			return 1;
		}

		if (strlen(inputtext) > 20) {
			ShowPlayerDialogEx(playerid, DIALOG_PORECEIVER, DIALOG_STYLE_INPUT, "Recipient", "{FF3333}Error: {FFFFFF}Recipient Name Too Long!\n\nPlease type the name of the recipient (online or offline)", "Next", "Cancel");
			return 1;
		}

		if (strcmp(inputtext, GetPlayerNameExt(playerid), true) == 0) {
			ShowPlayerDialogEx(playerid, DIALOG_PORECEIVER, DIALOG_STYLE_INPUT, "Recipient", "{FF3333}Error: {FFFFFF}Invalid Recipient! - Can't send to yourself!\n\nPlease type the name of the recipient (online or offline)", "Next", "Cancel");
			return 1;
		}

		SetPVarString(playerid, "LetterRecipientName", inputtext);

		new giveplayer = ReturnUser(inputtext);
		if(giveplayer == INVALID_PLAYER_ID)
		{
			new szQuery[256];
			mysql_format(MainPipeline, szQuery, sizeof(szQuery), "SELECT `id`, `AdminLevel`, `TogReports` FROM `accounts` WHERE `Username` = '%e'", inputtext);
			mysql_tquery(MainPipeline, szQuery, "RecipientLookupFinish", "i", playerid);
		}
		else
		{
			if(PlayerInfo[giveplayer][pAdmin] >= 2 && PlayerInfo[giveplayer][pTogReports] != 1)
			{
				ShowPlayerDialogEx(playerid, DIALOG_PORECEIVER, DIALOG_STYLE_INPUT, "Recipient", "{FF3333}Error: {FFFFFF}You can't send a letter to admins!\n\nPlease type the name of the recipient (online or offline)", "Next", "Cancel");
			}
			else
			{
				SetPVarInt(playerid, "LetterRecipient", GetPlayerSQLId(giveplayer));
				ShowPlayerDialogEx(playerid, DIALOG_POMESSAGE, DIALOG_STYLE_INPUT, "Send Letter", "{FFFFFF}Please type the message.", "Send", "Cancel");
			}
		}
		return 1;
	}

	else if (dialogid == DIALOG_POMESSAGE && response)
	{

		if (PlayerInfo[playerid][pAdmin] < 2 && CheckServerAd(inputtext)) {
			format(string,sizeof(string),"Warning: %s may be server advertising via mail: '%s'.", GetPlayerNameEx(playerid),inputtext);
			ABroadCast(COLOR_RED, string, 2);
			format(string,sizeof(string),"Warning: %s(%d) may be server advertising via mail: '%s'.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), inputtext);
			Log("logs/hack.log", string);
			return 1;
		}

		new query[512], rec[MAX_PLAYER_NAME];

		if (strlen(inputtext) == 0) {
			ShowPlayerDialogEx(playerid, DIALOG_POMESSAGE, DIALOG_STYLE_INPUT, "Send Letter", "{FF3333}Error: {FFFFFF}Message Not Entered!\n\nPlease type the message.", "Send", "Cancel");
			return 1;
		}
		if (strlen(inputtext) > 128) return 1; // Apparently not possible, but just in case

		if (!GetPVarType(playerid, "LetterGov")) {
			if (GetPlayerCash(playerid) < GetPVarInt(playerid, "LetterCost")) {
				return SendClientMessageEx(playerid, COLOR_GREY, "You can't afford the stamp.");
			}
			GivePlayerCash(playerid, -GetPVarInt(playerid, "LetterCost"));
		}
		else {
			DeletePVar(playerid, "LetterGov");
			if (Tax < 500) return SendClientMessageEx(playerid, COLOR_WHITE, "No government funds are available for stamp.");
			Tax -= 500;
			Misc_Save();
		}

		mysql_format(MainPipeline, query,sizeof(query),	"INSERT INTO `letters` (`Sender_Id`, `Receiver_Id`, `Date`, `Message`, `Delivery_Min`, `Notify`) VALUES (%d, %d, NOW(), '%e', %d, %d)", GetPlayerSQLId(playerid), GetPVarInt(playerid, "LetterRecipient"), inputtext, GetPVarInt(playerid, "LetterTime"), GetPVarInt(playerid, "LetterNotify"));
		mysql_tquery(MainPipeline, query, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);

		GetPVarString(playerid, "LetterRecipientName", rec, MAX_PLAYER_NAME);
		if (GetPVarInt(playerid, "LetterTime") == 0)
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "Your letter has been sent. It will be delivered immediately.");
			new xid=ReturnUser(rec);
			if (xid != INVALID_PLAYER_ID)
			{
				if (PlayerInfo[xid][pDonateRank] >= 4 && HasMailbox(xid))
				{
					SendClientMessageEx(xid, COLOR_YELLOW, "A letter has just been delivered to your mailbox.");
					SetPVarInt(xid, "UnreadMails", 1);
				}
			}
		}
		else
		{
			format(string, sizeof(string), "Your letter has been sent. It will be delivered in %d hour(s).", GetPVarInt(playerid, "LetterTime") / 60);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
		}

		PlayerInfo[playerid][pPaper]--;
		DeletePVar(playerid, "LetterCost");
		DeletePVar(playerid, "LetterTime");
		DeletePVar(playerid, "LetterRecipient");
		DeletePVar(playerid, "LetterNotify");
		SetPVarInt(playerid, "MailTime", 30);

		new szLog[256];
		format(szLog, sizeof(szLog), "%s(%d) has sent mail to %s: %s", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), rec, inputtext);
		Log("logs/mail.log", szLog);

		return 1;

	}

	else if (dialogid == DIALOG_POMAILS && response)
	{
		SetPVarInt(playerid, "ReadingMail", ListItemTrackId[playerid][listitem]);
		DisplayMailDetails(playerid, ListItemTrackId[playerid][listitem]);
	}

	else if (dialogid == DIALOG_PODETAIL)
	{

		if (response) // Back
		{
			DisplayMails(playerid);
		}
		else // Trash
		{
			new query[64];
			mysql_format(MainPipeline, query, sizeof(query), "DELETE FROM `letters` WHERE `ID` = %i", GetPVarInt(playerid, "ReadingMail"));
			mysql_tquery(MainPipeline, query, "OnQueryFinish", "i", SENDDATA_THREAD);
			ShowPlayerDialogEx(playerid, DIALOG_POTRASHED, DIALOG_STYLE_MSGBOX, "Info", "You've trashed your mail.", "Back", "Close");
		}
		DeletePVar(playerid, "ReadingMail");
		return 1;
	}

	else if (dialogid == DIALOG_POTRASHED && response)
	{

		DisplayMails(playerid);
		return 1;

	}

	else if (dialogid == DIALOG_STOREPRICES)
	{
		if (!response || (GetPVarInt(playerid, "EditingBusiness") != PlayerInfo[playerid][pBusiness]) || (GetPVarInt(playerid, "EditingBusiness") != InBusiness(playerid)) || PlayerInfo[playerid][pBusinessRank] != 5) {
			DeletePVar(playerid, "EditingBusiness");
		}
		else {
			format(string, sizeof(string), "{FFFFFF}Enter the new sale price for %s\n(Items with the price of $0 will not be for sale)", StoreItems[listitem]);
			ShowPlayerDialogEx(playerid, DIALOG_STOREITEMPRICE, DIALOG_STYLE_INPUT, "Edit Price", string, "Okay", "Cancel");
			SetPVarInt(playerid, "EditingStoreItem", listitem);
		}
		return 1;
	}

	else if (dialogid == DIALOG_BARPRICE)
	{
		if (!response || (GetPVarInt(playerid, "EditingBusiness") != PlayerInfo[playerid][pBusiness]) || (GetPVarInt(playerid, "EditingBusiness") != InBusiness(playerid)) || PlayerInfo[playerid][pBusinessRank] != 5) {
			DeletePVar(playerid, "EditingBusiness");
		}
		else {
			format(string, sizeof(string), "{FFFFFF}Enter the new sale price for %s\n(Items with the price of $0 will not be for sale)", Drinks[listitem]);
			ShowPlayerDialogEx(playerid, DIALOG_BARPRICE2, DIALOG_STYLE_INPUT, "Edit Price", string, "Okay", "Cancel");
			SetPVarInt(playerid, "EditingStoreItem", listitem);
		}
		return 1;
	}
	else if(dialogid == DIALOG_SEXSHOP)
	{
		if (!response || (GetPVarInt(playerid, "EditingBusiness") != PlayerInfo[playerid][pBusiness]) || (GetPVarInt(playerid, "EditingBusiness") != InBusiness(playerid)) || PlayerInfo[playerid][pBusinessRank] != 5) {
			DeletePVar(playerid, "EditingBusiness");
		}
		else {
			format(string, sizeof(string), "{FFFFFF}Enter the new sale price for %s\n(Items with the price of $0 will not be for sale)", Drinks[listitem]);
			ShowPlayerDialogEx(playerid, DIALOG_SEXSHOP2, DIALOG_STYLE_INPUT, "Edit Price", string, "Okay", "Cancel");
			SetPVarInt(playerid, "EditingStoreItem", listitem);
		}
		return 1;
	}
	else if (dialogid == DIALOG_RESTAURANT)
	{
		if (!response || (GetPVarInt(playerid, "EditingBusiness") != PlayerInfo[playerid][pBusiness]) || (GetPVarInt(playerid, "EditingBusiness") != InBusiness(playerid)) || PlayerInfo[playerid][pBusinessRank] != 5)
		{
			DeletePVar(playerid, "EditingBusiness");
		}
		else
		{
			format(string, sizeof(string), "{FFFFFF}Enter the new sale price for %s\n(Items with the price of $0 will not be for sale)", RestaurantItems[listitem]);
			ShowPlayerDialogEx(playerid, DIALOG_RESTAURANT2, DIALOG_STYLE_INPUT, "Edit Price", string, "Okay", "Cancel");
			SetPVarInt(playerid, "EditingStoreItem", listitem);
		}
	}
	else if (dialogid == DIALOG_SEXSHOP2)
	{

		if (PlayerInfo[playerid][pBusiness] != GetPVarInt(playerid, "EditingBusiness") || (GetPVarInt(playerid, "EditingBusiness") != InBusiness(playerid)) || PlayerInfo[playerid][pBusinessRank] != 5) {
			DeletePVar(playerid, "EditingStoreItem");
			DeletePVar(playerid, "EditingBusiness");
			return 1;
		}

		new iBusiness = PlayerInfo[playerid][pBusiness];

		if (response) {
			new iPrice = strval(inputtext), item = GetPVarInt(playerid, "EditingStoreItem");

			if (iPrice < 0 || iPrice > 500000) {
				format(string, sizeof(string), "{FF0000}Error: {DDDDDD}Price is out of range{FFFFFF}\n\nEnter the new sale price for %s", Drinks[item]);
				ShowPlayerDialogEx(playerid, DIALOG_STOREITEMPRICE, DIALOG_STYLE_INPUT, "Edit Price", string, "Okay", "Cancel");
				return 1;
			}

			format(string,sizeof(string), "%s price has been set to $%s!", SexItems[item], number_format(iPrice));
			Businesses[iBusiness][bItemPrices][item] = iPrice;
			SaveBusiness(iBusiness);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			format(string, sizeof(string), "%s %s(%d) (IP: %s) has set the %s price to %s in %s ($%d)", GetBusinessRankName(PlayerInfo[playerid][pBusinessRank]), GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), SexItems[item], number_format(iPrice), Businesses[iBusiness][bName], iBusiness);
			new szDialog[302];
			for (new i = 0; i <= 13; i++) format(szDialog, sizeof(szDialog), "%s%s  ($%s)\n", szDialog, SexItems[i], number_format(Businesses[iBusiness][bItemPrices][i]));
			ShowPlayerDialogEx(playerid, DIALOG_BARPRICE, DIALOG_STYLE_LIST, "Edit Business Prices", szDialog, "Okay", "Cancel");
			Log("logs/business.log", string);
		}
		DeletePVar(playerid, "EditingStoreItem");
		return 1;
	}
	else if (dialogid == DIALOG_RESTAURANT2)
	{
		if (PlayerInfo[playerid][pBusiness] != GetPVarInt(playerid, "EditingBusiness") || (GetPVarInt(playerid, "EditingBusiness") != InBusiness(playerid)) || PlayerInfo[playerid][pBusinessRank] != 5)
		{
			DeletePVar(playerid, "EditingStoreItem");
			DeletePVar(playerid, "EditingBusiness");
			return 1;
		}

		new business = PlayerInfo[playerid][pBusiness];

		if (response)
		{
			new price = strval(inputtext), item = GetPVarInt(playerid, "EditingStoreItem");

			if (price < 0 || price > 500000)
			{
				format(string, sizeof(string), "{FF0000}Error: {DDDDDD}Price is out of range{FFFFFF}\n\nEnter the new sale price for %s", RestaurantItems[item]);
				ShowPlayerDialogEx(playerid, DIALOG_RESTAURANT2, DIALOG_STYLE_INPUT, "Edit Price", string, "Okay", "Cancel");
				return 1;
			}

			format(string,sizeof(string), "%s price has been set to $%s!", RestaurantItems[item], number_format(price));
			Businesses[business][bItemPrices][item] = price;
			SaveBusiness(business);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			format(string, sizeof(string), "%s %s(%d) (IP: %s) has set the %s price to %s in %s ($%d)", GetBusinessRankName(PlayerInfo[playerid][pBusinessRank]), GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), RestaurantItems[item], number_format(price), Businesses[business][bName], business);
			new szDialog[302];
			for (new i = 0; i <= 13; i++) format(szDialog, sizeof(szDialog), "%s%s  ($%s)\n", szDialog, RestaurantItems[i], number_format(Businesses[business][bItemPrices][i]));
			ShowPlayerDialogEx(playerid, DIALOG_RESTAURANT, DIALOG_STYLE_LIST, "Edit Business Prices", szDialog, "Okay", "Cancel");
			Log("logs/business.log", string);
		}

		DeletePVar(playerid, "EditingStoreItem");
		return 1;
	}
	else if (dialogid == DIALOG_BARPRICE2)
	{

		if (PlayerInfo[playerid][pBusiness] != GetPVarInt(playerid, "EditingBusiness") || (GetPVarInt(playerid, "EditingBusiness") != InBusiness(playerid)) || PlayerInfo[playerid][pBusinessRank] != 5) {
			DeletePVar(playerid, "EditingStoreItem");
			DeletePVar(playerid, "EditingBusiness");
			return 1;
		}

		new iBusiness = PlayerInfo[playerid][pBusiness];

		if (response) {
			new iPrice = strval(inputtext), item = GetPVarInt(playerid, "EditingStoreItem");

			if (iPrice < 0 || iPrice > 500000) {
				format(string, sizeof(string), "{FF0000}Error: {DDDDDD}Price is out of range{FFFFFF}\n\nEnter the new sale price for %s", Drinks[item]);
				ShowPlayerDialogEx(playerid, DIALOG_STOREITEMPRICE, DIALOG_STYLE_INPUT, "Edit Price", string, "Okay", "Cancel");
				return 1;
			}

			format(string,sizeof(string), "%s price has been set to $%s!", Drinks[item], number_format(iPrice));
			Businesses[iBusiness][bItemPrices][item] = iPrice;
			SaveBusiness(iBusiness);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			format(string, sizeof(string), "%s %s(%d) (IP: %s) has set the %s price to $%s in %s (%d)", GetBusinessRankName(PlayerInfo[playerid][pBusinessRank]), GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), Drinks[item], number_format(iPrice), Businesses[iBusiness][bName], iBusiness);
			new szDialog[302];
			for (new i = 0; i <= 13; i++) format(szDialog, sizeof(szDialog), "%s%s  ($%s)\n", szDialog, Drinks[i], number_format(Businesses[iBusiness][bItemPrices][i]));
			ShowPlayerDialogEx(playerid, DIALOG_BARPRICE, DIALOG_STYLE_LIST, "Edit Business Prices", szDialog, "Okay", "Cancel");
			Log("logs/business.log", string);
		}
		DeletePVar(playerid, "EditingStoreItem");
		return 1;
	}
	else if (dialogid == DIALOG_STOREITEMPRICE)
	{

		if (PlayerInfo[playerid][pBusiness] != GetPVarInt(playerid, "EditingBusiness") || (GetPVarInt(playerid, "EditingBusiness") != InBusiness(playerid)) || PlayerInfo[playerid][pBusinessRank] != 5) {
			DeletePVar(playerid, "EditingStoreItem");
			DeletePVar(playerid, "EditingBusiness");
			return 1;
		}

		new iBusiness = PlayerInfo[playerid][pBusiness];

		if (response) {
			new iPrice = strval(inputtext), item = GetPVarInt(playerid, "EditingStoreItem");

			if (iPrice < 0 || iPrice > 500000) {
				format(string, sizeof(string), "{FF0000}Error: {DDDDDD}Price is out of range{FFFFFF}\n\nEnter the new sale price for %s", StoreItems[item]);
				ShowPlayerDialogEx(playerid, DIALOG_STOREITEMPRICE, DIALOG_STYLE_INPUT, "Edit Price", string, "OK", "Cancel");
				return 1;
			}

			format(string,sizeof(string), "%s price has been set to $%s!", StoreItems[item], number_format(iPrice));
			Businesses[iBusiness][bItemPrices][item] = iPrice;
			SaveBusiness(iBusiness);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			format(string, sizeof(string), "%s %s(%d) (IP: %s) has set the %s price to $%s in %s (%d)", GetBusinessRankName(PlayerInfo[playerid][pBusinessRank]), GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), StoreItems[item], number_format(iPrice), Businesses[iBusiness][bName], iBusiness);
			new szDialog[912];
			for (new i = 0; i < sizeof(StoreItems); i++) format(szDialog, sizeof(szDialog), "%s%s  ($%s) (Cost of Good: $%s)\n", szDialog, StoreItems[i], number_format(Businesses[iBusiness][bItemPrices][i]), number_format(floatround(StoreItemCost[i][ItemValue] * BUSINESS_ITEMS_COST)));
			ShowPlayerDialogEx(playerid, DIALOG_STOREPRICES, DIALOG_STYLE_LIST, "Edit 24/7 Prices", szDialog, "OK", "Cancel");
			Log("logs/business.log", string);
		}
		DeletePVar(playerid, "EditingStoreItem");
		return 1;
	}
	else if(dialogid == DIALOG_STORECLOTHINGPRICE)
	{
		new iBusiness = PlayerInfo[playerid][pBusiness];

		if (PlayerInfo[playerid][pBusiness] != GetPVarInt(playerid, "EditingBusiness") || (GetPVarInt(playerid, "EditingBusiness") != InBusiness(playerid)) || PlayerInfo[playerid][pBusinessRank] != 5) {
			DeletePVar(playerid, "EditingStoreItem");
			DeletePVar(playerid, "EditingBusiness");
			return 1;
		}

		if (response) {
			new iPrice = strval(inputtext);

			if (iPrice < 0 || iPrice > 500000) {
				ShowPlayerDialogEx(playerid, DIALOG_STORECLOTHINGPRICE, DIALOG_STYLE_INPUT, "Edit Price", "{FF0000}Error: {DDDDDD}Price is out of range{FFFFFF}\n\nEnter the new sale price for clothing", "Okay", "Cancel");
				return 1;
			}

			format(string,sizeof(string), "Clothing price has been set to $%s!", number_format(iPrice));
			Businesses[iBusiness][bItemPrices][0] = iPrice;
			SaveBusiness(iBusiness);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			format(string, sizeof(string), "%s %s(%d) (IP: %s) has set the %s price to $%s in %s (%d)", GetBusinessRankName(PlayerInfo[playerid][pBusinessRank]), GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), "clothing", number_format(iPrice), Businesses[iBusiness][bName], iBusiness);
			Log("logs/business.log", string);
		}

		DeletePVar(playerid, "EditingStoreItem");
	}
	else if (dialogid == DIALOG_GUNPRICES)
	{
		if (!response || (GetPVarInt(playerid, "EditingBusiness") != PlayerInfo[playerid][pBusiness]) || (GetPVarInt(playerid, "EditingBusiness") != InBusiness(playerid)) || PlayerInfo[playerid][pBusinessRank] != 5) {
			DeletePVar(playerid, "EditingBusiness");
		}
		else {
			format(string, sizeof(string), "{FFFFFF}Enter the new sale price for %s\n(Items with the price of $0 will not be for sale)", GetWeaponNameEx(Weapons[listitem][WeaponId]));
			ShowPlayerDialogEx(playerid, DIALOG_GUNSHOPPRICE, DIALOG_STYLE_INPUT, "Edit Price", string, "Okay", "Cancel");
			SetPVarInt(playerid, "EditingStoreItem", listitem);
		}
		return 1;
	}
	else if(dialogid == DIALOG_GUNSHOPPRICE)
	{
		if (PlayerInfo[playerid][pBusiness] != GetPVarInt(playerid, "EditingBusiness") || (GetPVarInt(playerid, "EditingBusiness") != InBusiness(playerid)) || PlayerInfo[playerid][pBusinessRank] != 5) {
			DeletePVar(playerid, "EditingStoreItem");
			DeletePVar(playerid, "EditingBusiness");
			return 1;
		}

		new iBusiness = PlayerInfo[playerid][pBusiness];

		if (response) {
			new iPrice = strval(inputtext), item = GetPVarInt(playerid, "EditingStoreItem");

			if (iPrice < 0 || iPrice > 500000) {
				format(string, sizeof(string), "{FF0000}Error: {DDDDDD}Price is out of range{FFFFFF}\n\nEnter the new sale price for %s", StoreItems[item]);
				ShowPlayerDialogEx(playerid, DIALOG_GUNSHOPPRICE, DIALOG_STYLE_INPUT, "Edit Price", string, "OK", "Cancel");
				return 1;
			}

			format(string,sizeof(string), "%s price has been set to $%s!", GetWeaponNameEx(Weapons[item][WeaponId]), number_format(iPrice));
			Businesses[iBusiness][bItemPrices][item] = iPrice;
			SaveBusiness(iBusiness);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			format(string, sizeof(string), "%s %s(%d) (IP: %s) has set the %s price to $%s in %s (%d)", GetBusinessRankName(PlayerInfo[playerid][pBusinessRank]), GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), GetWeaponParam(item, WeaponId), number_format(iPrice), Businesses[iBusiness][bName], iBusiness);
			new szDialog[512];
			for (new i = 0; i < sizeof(Weapons); i++) format(szDialog, sizeof(szDialog), "%s%s  ($%s)\n", szDialog, GetWeaponNameEx(Weapons[i][WeaponId]), number_format(Businesses[iBusiness][bItemPrices][i]));
			ShowPlayerDialogEx(playerid, DIALOG_GUNPRICES, DIALOG_STYLE_LIST, "Edit Gun Store Prices", szDialog, "OK", "Cancel");
			Log("logs/business.log", string);
		}
		DeletePVar(playerid, "EditingStoreItem");
		return 1;
	}
	else if (dialogid == DIALOG_GASPRICE)
	{
		if (!response || (GetPVarInt(playerid, "EditingBusiness") != PlayerInfo[playerid][pBusiness]) || PlayerInfo[playerid][pBusinessRank] != 5) {
		}
		else {
			new szSaleText[148], Float:price = floatstr(inputtext);
			if (price < 1 || price > 5000) return SendClientMessageEx(playerid, COLOR_WHITE, "Price can't be lower than $1 or higher than $5,000");
			Businesses[PlayerInfo[playerid][pBusiness]][bGasPrice] = price;
			for (new i; i < MAX_BUSINESS_GAS_PUMPS; i++)
			{
				format(szSaleText,sizeof(szSaleText),"Price Per Gallon: $%.2f\nThis Sale: $%.2f\nGallons: %.3f\nGas Available: %.2f/%.2f gallons", price, Businesses[PlayerInfo[playerid][pBusiness]][GasPumpSalePrice][i], Businesses[PlayerInfo[playerid][pBusiness]][GasPumpSaleGallons][i], Businesses[PlayerInfo[playerid][pBusiness]][GasPumpGallons][i], Businesses[PlayerInfo[playerid][pBusiness]][GasPumpCapacity][i]);
				UpdateDynamic3DTextLabelText(Businesses[PlayerInfo[playerid][pBusiness]][GasPumpSaleTextID][i], COLOR_YELLOW, szSaleText);
			}
			SaveBusiness(PlayerInfo[playerid][pBusiness]);
			format(string, sizeof(string), "Gallon price has been set to %.2f!", price);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			format(string, sizeof(string), "%s(%d) (IP: %s) has set the gas price to %f in %s", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), price, Businesses[PlayerInfo[playerid][pBusiness]][bName]);
			Log("logs/business.log", string);
		}
		DeletePVar(playerid, "EditingBusiness");
		return 1;
	}

	else if (dialogid == DIALOG_SWITCHGROUP && response)
	{

		if (!(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1 || PlayerInfo[playerid][pFactionModerator] >= 1)) return 1;

		new
			iGroupID = listitem;

		if(arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_CONTRACT) {
			return SendClientMessage(playerid, COLOR_WHITE, "You can't switch to a contract agency with this command.");
		}

		format(string, sizeof(string), "You have switched to group ID %d (%s).", iGroupID+1, arrGroupData[iGroupID][g_szGroupName]);
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
		PlayerInfo[playerid][pMember] = iGroupID;
		PlayerInfo[playerid][pRank] = Group_GetMaxRank(iGroupID);
		PlayerInfo[playerid][pLeader] = -1;
	}

	else if (dialogid == DIALOG_MAKELEADER && response)
	{
		if (PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1 || PlayerInfo[playerid][pFactionModerator] >= 2)
		{
			new
				iGroupID = listitem,
				iTargetID = GetPVarInt(playerid, "MakingLeader");

			if(!arrGroupData[iGroupID][g_szGroupName][0]) { return SendClientMessageEx(playerid, COLOR_GREY, "This group has not been properly set up yet."); }

			PlayerInfo[iTargetID][pLeader] = iGroupID;
			PlayerInfo[iTargetID][pMember] = iGroupID;
			PlayerInfo[iTargetID][pRank] = Group_GetMaxRank(iGroupID);
			PlayerInfo[iTargetID][pDivision] = -1;
			format(string, sizeof(string), "You have been made the leader of the %s by Administrator %s.", arrGroupData[iGroupID][g_szGroupName], GetPlayerNameEx(playerid));
			SendClientMessageEx(iTargetID, COLOR_LIGHTBLUE, string);
			format(string, sizeof(string), "You have made %s the leader of the %s.", GetPlayerNameEx(iTargetID), arrGroupData[iGroupID][g_szGroupName]);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
			format(string, sizeof(string), "%s (%d) has made %s (%d) the leader of the %s.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerNameEx(iTargetID), GetPlayerSQLId(iTargetID), arrGroupData[iGroupID][g_szGroupName]);
			GroupLog(iGroupID, string);
		}
		else SendClientMessageEx(playerid, COLOR_GRAD2, "You do not have access to this.");
	}
	else if (dialogid == DIALOG_HBADGE && response)
	{

		if (!IsAHitman(playerid)) return 1;

		new	iGroupID = listitem;

		if(!arrGroupData[iGroupID][g_szGroupName][0]) { return SendClientMessageEx(playerid, COLOR_GREY, "This group has not been properly set up yet."); }

		switch(listitem)
		{
			case 0..20: {
				format(string, sizeof(string), "You have set your badge to %s", arrGroupData[iGroupID][g_szGroupName]);
				SendClientMessageEx(playerid, COLOR_WHITE, string);
				SetPlayerColor(playerid, arrGroupData[iGroupID][g_hDutyColour] * 256);
				SetPVarInt(playerid, "HitmanBadgeColour", arrGroupData[iGroupID][g_hDutyColour] * 256);
			}
			default: {
				SendClientMessageEx(playerid, COLOR_GREY, "Invalid group specified.");
			}
		}
	}
	else if(dialogid == DIALOG_CDBUY)
	{
		// Account Eating Bug Fix
		if(!IsPlayerInAnyVehicle(playerid))
		{
			TogglePlayerControllable(playerid, 1);
			SendClientMessageEx(playerid,COLOR_GRAD2,"You need to be in the vehicle you wish to purchase.");
			return 1;
		}

		new vehicleid = GetPlayerVehicleID(playerid);
		new playervehicleid = GetPlayerFreeVehicleId(playerid);
		new v = GetBusinessCarSlot(vehicleid);
		new d = GetCarBusiness(vehicleid);
		if(response)
		{
			if(!vehicleCountCheck(playerid))
			{
				TogglePlayerControllable(playerid, 1);
 				RemovePlayerFromVehicle(playerid);
 				new Float:slx, Float:sly, Float:slz;
 				GetPlayerPos(playerid, slx, sly, slz);
 				SetPlayerPos(playerid, slx, sly, slz+1.2);
				return SendClientMessageEx(playerid, COLOR_GREY, "ERROR: You cannot own any additional vehicles. You may purchase additional vehicle slots through /vstorage.");
			}

			if(Businesses[d][bPurchaseX] == 0.0 && Businesses[d][bPurchaseY] == 0.0 && Businesses[d][bPurchaseZ] == 0.0)
			{
				SendClientMessageEx(playerid, COLOR_GRAD1, "ERROR: The owner of this Car Dealership hasn't set the purchased vehicles spawn point.");
				RemovePlayerFromVehicle(playerid);
				new Float:slx, Float:sly, Float:slz;
				GetPlayerPos(playerid, slx, sly, slz);
				SetPlayerPos(playerid, slx, sly, slz+1.2);
				TogglePlayerControllable(playerid, 1);
				return 1;
			}

			new randcolor1 = Random(0, 126);
			new randcolor2 = Random(0, 126);
			SetPlayerPos(playerid, Businesses[d][bParkPosX][v], Businesses[d][bParkPosY][v], Businesses[d][bParkPosZ][v]+2);
			TogglePlayerControllable(playerid, 1);
			new cost;
			if(PlayerInfo[playerid][pDonateRank] < 1)
			{
				cost = Businesses[d][bPrice][v];
				if(PlayerInfo[playerid][pCash] < cost)
				{
					SendClientMessageEx(playerid, COLOR_GRAD1, "ERROR: You don't have enough money to buy this.");
					RemovePlayerFromVehicle(playerid);
					new Float:slx, Float:sly, Float:slz;
					GetPlayerPos(playerid, slx, sly, slz);
					SetPlayerPos(playerid, slx, sly, slz+1.2);
					return 1;
				}

				format(string, sizeof(string), " Thank you for buying at %s.", Businesses[d][bName]);
				SendClientMessageEx(playerid, COLOR_GRAD1, string);
				PlayerInfo[playerid][pCash] -= cost;
				cost = Businesses[d][bPrice][v] / 100 * 15;
				Businesses[d][bSafeBalance] += TaxSale( cost );
			}
			else
			{
				cost = Businesses[d][bPrice][v];
				if(PlayerInfo[playerid][pCash] < cost)
				{
					SendClientMessageEx(playerid, COLOR_GRAD1, "ERROR: You don't have enough money to buy this.");
					RemovePlayerFromVehicle(playerid);
					new Float:slx, Float:sly, Float:slz;
					GetPlayerPos(playerid, slx, sly, slz);
					SetPlayerPos(playerid, slx, sly, slz+1.2);
					return 1;
				}

				format(string, sizeof(string), " Thank you for buying at %s.",Businesses[d][bName]);
				SendClientMessageEx(playerid, COLOR_GRAD1, string);
				PlayerInfo[playerid][pCash] -= cost;
				cost = Businesses[d][bPrice][v] / 100 * 15;
				Businesses[d][bSafeBalance] += TaxSale( cost );
			}
			if(PlayerInfo[playerid][pTut] == 15)
			{
				PlayerInfo[playerid][pCarLic] = gettime() + (86400); // temp 1 day license
				PlayerInfo[playerid][pTut]++;
				AdvanceTutorial(playerid);
			}
			Businesses[d][bInventory]--;
			Businesses[d][bTotalSales]++;
			IsPlayerEntering{playerid} = true;
			new car = CreatePlayerVehicle(playerid, playervehicleid, Businesses[d][bModel][v], Businesses[d][bPurchaseX], Businesses[d][bPurchaseY], Businesses[d][bPurchaseZ], Businesses[d][bPurchaseAngle], randcolor1, randcolor2, cost, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
			PutPlayerInVehicle(playerid, car, 0);
			SaveBusiness(d);
			format(string, sizeof(string), "%s(%d) has purchased a %s(%d) from %s for $%s", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), VehicleName[Businesses[d][bModel][v] - 400], Businesses[d][bModel][v], Businesses[d][bName], number_format(Businesses[d][bPrice][v]));
			Log("logs/dealership.log", string);
		}
		else
		{
			RemovePlayerFromVehicle(playerid);
			new Float:slx, Float:sly, Float:slz;
			GetPlayerPos(playerid, slx, sly, slz);
			SetPlayerPos(playerid, slx, sly, slz+1.2);
			TogglePlayerControllable(playerid, 1);
			return 1;
		}
	}
	else if(dialogid == DIALOG_LOADTRUCKOLD) // TRUCKER JOB LOAD TRUCK
	{
		if(response)
		{
			if(listitem == 0) // Legal goods
			{

				ShowPlayerDialogEx(playerid, DIALOG_LOADTRUCKL, DIALOG_STYLE_LIST, "What do you want to transport?","{00F70C}Food & beverages\n{00F70C}Clothing\n{00F70C}Materials\n{00F70C}24/7 Items", "Select", "Cancel");
			}
			if(listitem == 1) // Illegal goods
			{
				new level = PlayerInfo[playerid][pTruckSkill];
				if(level >= 0 && level <= 50)
				{
					ShowPlayerDialogEx(playerid, DIALOG_LOADTRUCKI, DIALOG_STYLE_LIST, "What do you want to transport?","{FF0606}Weapons 		{FFFFFF}(Level 1 Bonus: Free 9mm)\n{FF0606}Drugs 			{FFFFFF}(Level 1 Bonus: Free 2 Cannabis, 1 crack)\n{FF0606}Illegal materials  	{FFFFFF}(Level 1 Bonus: Free 100 materials)", "Select", "Cancel");
				}
				else if(level >= 51 && level <= 100)
				{
					ShowPlayerDialogEx(playerid, DIALOG_LOADTRUCKI, DIALOG_STYLE_LIST, "What do you want to transport?","{FF0606}Weapons 		{FFFFFF}(Level 2 Bonus: Free Shotgun)\n{FF0606}Drugs 			{FFFFFF}(Level 2 Bonus: Free 4 Cannabis, 2 crack)\n{FF0606}Illegal materials  	{FFFFFF}(Level 2 Bonus: Free 200 materials)", "Select", "Cancel");
				}
				else if(level >= 101 && level <= 200)
				{
					ShowPlayerDialogEx(playerid, DIALOG_LOADTRUCKI, DIALOG_STYLE_LIST, "What do you want to transport?","{FF0606}Weapons 		{FFFFFF}(Level 3 Bonus: Free MP5)\n{FF0606}Drugs 			{FFFFFF}(Level 3 Bonus: Free 6 Cannabis, 3 crack)\n{FF0606}Illegal materials  	{FFFFFF}(Level 3 Bonus: Free 400 materials)", "Select", "Cancel");
				}
				else if(level >= 201 && level <= 400)
				{
					ShowPlayerDialogEx(playerid, DIALOG_LOADTRUCKI, DIALOG_STYLE_LIST, "What do you want to transport?","{FF0606}Weapons 		{FFFFFF}(Level 4 Bonus: Free Deagle)\n{FF0606}Drugs 			{FFFFFF}(Level 4 Bonus: Free 8 Cannabis, 4 crack)\n{FF0606}Illegal materials  	{FFFFFF}(Level 4 Bonus: Free 600 materials)", "Select", "Cancel");
				}
				else if(level >= 401)
				{
					ShowPlayerDialogEx(playerid, DIALOG_LOADTRUCKI, DIALOG_STYLE_LIST, "What do you want to transport?","{FF0606}Weapons 		{FFFFFF}(Level 5 Bonus: Free AK-47)\n{FF0606}Drugs 			{FFFFFF}(Level 5 Bonus: Free 10 Cannabis, 5 crack)\n{FF0606}Illegal materials  	{FFFFFF}(Level 5 Bonus: Free 1000 materials)", "Select", "Cancel");
				}
			}
		}
		else
		{
			DeletePVar(playerid, "IsFrozen");
			TogglePlayerControllable(playerid, 1);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You canceled the loading of the shipment, type /loadshipment to try again.");
		}
	}

	else if(dialogid == DIALOG_LOADTRUCKL) // TRUCKER JOB LEGAL GOODS
	{
		if(response)
		{

			if(listitem == 0) // Food & beverages
			{
				SetPVarInt(playerid, "TruckDeliver", 1);
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Please wait a moment while the vehicle is being loaded with food & beverages....");
			}
			if(listitem == 1) // Clothing
			{
				SetPVarInt(playerid, "TruckDeliver", 2);
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Please wait a moment while the vehicle is being loaded with clothing....");
			}
			if(listitem == 2) // Materials
			{
				SetPVarInt(playerid, "TruckDeliver", 3);
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Please wait a moment while the vehicle is being loaded with materials....");
			}
			if(listitem == 3) // 24/7 Items
			{
				SetPVarInt(playerid, "TruckDeliver", 4);
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Please wait a moment while the vehicle is being loaded with 24/7 items....");
			}
			SetPVarInt(playerid, "LoadType", 1);
			SetPVarInt(playerid, "LoadTruckTime", 10);
			SetTimerEx("LoadTruckOld", 1000, 0, "d", playerid);
		}
		else
		{
			DeletePVar(playerid, "IsFrozen");
			TogglePlayerControllable(playerid, 1);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You canceled the loading of the shipment, type /loadshipment to try again.");
		}
	}

	else if(dialogid == DIALOG_LOADTRUCKI) // TRUCKER JOB ILLEGAL GOODS
	{
		if(response)
		{
			// 1 = food and bev
			// 2 = clothing
			// 3 = legal mats
			// 4 = 24/7 items
			// 5 = weapons
			// 6 = illegal drugs
			// 7 = illegal materials
			//new level = PlayerInfo[playerid][pTruckSkill];
			if(listitem == 0) // Weapons
			{
				SetPVarInt(playerid, "TruckDeliver", 5);
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Please wait a moment while the vehicle is being loaded with weapons....");
			}
			if(listitem == 1) // Drugs
			{
				SetPVarInt(playerid, "TruckDeliver", 6);
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Please wait a moment while the vehicle is being loaded with drugs....");
			}
			if(listitem == 2) // Illegal materials
			{
				SetPVarInt(playerid, "TruckDeliver", 7);
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Please wait a moment while the vehicle is being loaded with illegal materials....");
			}
			SetPVarInt(playerid, "LoadType", 1);
			SetPVarInt(playerid, "LoadTruckTime", 10);
			SetTimerEx("LoadTruckOld", 1000, 0, "d", playerid);
		}
		else
		{
			DeletePVar(playerid, "IsFrozen");
			TogglePlayerControllable(playerid, 1);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You canceled the loading of the shipment, type /loadshipment to try again.");
		}
	}
	else if(dialogid == DIALOG_ADMINAUCTIONS)
	{
		if(response) {
			SetPVarInt(playerid, "AuctionItem", listitem);
			ShowPlayerDialogEx(playerid, DIALOG_ADMINAUCTIONS2, DIALOG_STYLE_LIST, "Edit Auction", "Auction Enabled\nAuction Item Description\nAuction Expiration\nStarting Bid\nIncease Increment", "Select", "Exit");
		}
	}
	else if(dialogid == DIALOG_ADMINAUCTIONS2)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					ShowPlayerDialogEx(playerid, DIALOG_ADMINAUCTIONS3, DIALOG_STYLE_LIST, "Edit Auction Enabled", "Enabled\nDisabled", "Select", "Exit");
				}
				case 1:
				{
					ShowPlayerDialogEx(playerid, DIALOG_ADMINAUCTIONS4, DIALOG_STYLE_INPUT, "Edit Auction Item Description", "Enter below the item description for the auction.","Change","Exit");
				}
				case 2:
				{
					ShowPlayerDialogEx(playerid, DIALOG_ADMINAUCTIONS5, DIALOG_STYLE_INPUT, "Edit Auction Expiration", "Enter the amount of minutes you want the auction to last for.","Change","Exit");
				}
				case 3:
				{
					ShowPlayerDialogEx(playerid, DIALOG_ADMINAUCTIONS6, DIALOG_STYLE_INPUT, "Edit Auction Starting Bid", "Enter the starting bid amount.","Change","Exit");
				}
				case 4:
				{
					ShowPlayerDialogEx(playerid, DIALOG_ADMINAUCTIONS7, DIALOG_STYLE_INPUT, "Edit Auction Increase Increment", "Enter the increase increment amount.","Change","Exit");
				}
			}
		}
	}
	else if(dialogid == DIALOG_ADMINAUCTIONS3)
	{
		if(response) {

			new
				AuctionItem = GetPVarInt(playerid, "AuctionItem"),
				szMessage[128];

			if(listitem == 0)
			{
				if(Auctions[AuctionItem][Expires] == 0) {
					SendClientMessageEx(playerid, COLOR_GREY, "Before you can start an auction you must set the expiration time.");
					return 1;
				}
				format(szMessage, sizeof(szMessage), "%s(%d) (IP:%s) has edited auction %i enabled to 1 (Enabled)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), AuctionItem);
				Log("logs/adminauction.log", szMessage);
				Auctions[AuctionItem][InProgress] = 1;
				Auctions[AuctionItem][Timer] = SetTimerEx("EndAuction", 60000, true, "i", AuctionItem);
				SendClientMessageEx(playerid, COLOR_WHITE, "Auction has been enabled, people can start biding.");
			}
			else
			{
				KillTimer(Auctions[AuctionItem][Timer]);
				format(szMessage, sizeof(szMessage), "%s(%d) (IP:%s) has edited auction %i enabled to 0 (disabled)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), AuctionItem);
				Log("logs/adminauction.log", szMessage);
				Auctions[AuctionItem][InProgress] = 0;
				SendClientMessageEx(playerid, COLOR_WHITE, "Auction has been disabled.");
			}
			SaveAuction(AuctionItem);
			DeletePVar(playerid, "AuctionItem");
		}
	}
	else if(dialogid == DIALOG_ADMINAUCTIONS4)
	{
		if(response)
		{
			new
				AuctionItem = GetPVarInt(playerid, "AuctionItem"),
				szMessage[128];

			if(isnull(inputtext))
			{
				ShowPlayerDialogEx(playerid, DIALOG_ADMINAUCTIONS4, DIALOG_STYLE_INPUT, "Edit Auction Item Description", "Enter below the item description for the auction.","Change","Exit");
				return 1;
			}
			if(strlen(inputtext) > 64)
			{
				SendClientMessageEx(playerid, COLOR_GREY, "The item description can't be longer then 64 characters.");
				ShowPlayerDialogEx(playerid, DIALOG_ADMINAUCTIONS4, DIALOG_STYLE_INPUT, "Edit Auction Item Description", "Enter below the item description for the auction.","Change","Exit");
				return 1;
			}
			format(szMessage, sizeof(szMessage), "%s(%d) (IP:%s) has edited auction %i item description to %s", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), AuctionItem, inputtext);
			Log("logs/adminauction.log", szMessage);
			format(Auctions[AuctionItem][BiddingFor], 64, inputtext);
			SaveAuction(AuctionItem);
			DeletePVar(playerid, "AuctionItem");
			SendClientMessageEx(playerid, COLOR_WHITE, "You have adjusted the auction item description.");
		}
	}
	else if(dialogid == DIALOG_ADMINAUCTIONS5)
	{
		if(response) {
			new
				Time = strval(inputtext),
				AuctionItem = GetPVarInt(playerid, "AuctionItem"),
				szMessage[128];

			if(Time < 0) {
				ShowPlayerDialogEx(playerid, DIALOG_ADMINAUCTIONS5, DIALOG_STYLE_INPUT, "Edit Auction Expiration", "Enter the amount of minutes you want the auction to last for.","Change","Exit");
				SendClientMessageEx(playerid, COLOR_GREY, "The time can't be below 0.");
				return 1;
			}
			format(szMessage, sizeof(szMessage), "%s(%d) (IP:%s) has edited auction %i expire time to %i", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), AuctionItem, Time);
			Log("logs/adminauction.log", szMessage);
			Auctions[AuctionItem][Expires] = Time;
			SaveAuction(AuctionItem);
			DeletePVar(playerid, "AuctionItem");
			SendClientMessageEx(playerid, COLOR_WHITE, "You have adjusted the auction expiration time.");
		}
	}
	else if(dialogid == DIALOG_ADMINAUCTIONS6)
	{
		if(response) {
			new
				Time = strval(inputtext),
				AuctionItem = GetPVarInt(playerid, "AuctionItem"),
				szMessage[128];

			if(Time < 0) {
				ShowPlayerDialogEx(playerid, DIALOG_ADMINAUCTIONS6, DIALOG_STYLE_INPUT, "Edit Auction Starting Bid", "Enter the starting bid amount.","Change","Exit");
				SendClientMessageEx(playerid, COLOR_GREY, "The starting bid can't be below 0.");
				return 1;
			}
			format(szMessage, sizeof(szMessage), "%s(%d) (IP:%s) has edited auction %i starting bid to %i", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), AuctionItem, Time );
			Log("logs/adminauction.log", szMessage);
			Auctions[AuctionItem][Bid] = Time;
			SaveAuction(AuctionItem);
			DeletePVar(playerid, "AuctionItem");
			SendClientMessageEx(playerid, COLOR_WHITE, "You have adjusted the bid starting amount.");
		}
	}
	else if(dialogid == DIALOG_ADMINAUCTIONS7)
	{
		if(response) {
			new
				Time = strval(inputtext),
				AuctionItem = GetPVarInt(playerid, "AuctionItem"),
				szMessage[128];

			if(Time < 0) {
				ShowPlayerDialogEx(playerid, DIALOG_ADMINAUCTIONS7, DIALOG_STYLE_INPUT, "Edit Auction Increase Increment", "Enter the increase increment amount.","Change","Exit");
				SendClientMessageEx(playerid, COLOR_GREY, "The increase increment amount can't be below 0.");
				return 1;
			}
			format(szMessage, sizeof(szMessage), "%s(%d) (IP:%s) has edited auction %i increment to %i", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), AuctionItem, Time );
			Log("logs/adminauction.log", szMessage);

			Auctions[AuctionItem][Increment] = Time;
			SaveAuction(AuctionItem);
			DeletePVar(playerid, "AuctionItem");
			SendClientMessageEx(playerid, COLOR_WHITE, "You have adjusted the increase increment amount.");
		}
	}
	else if(dialogid == DIALOG_AUCTIONS)
	{
		if(response) {

			if(Auctions[listitem][InProgress] == 1) {

				new
					szInfo[200];

				format(szInfo, sizeof(szInfo), "{00BFFF}Item: {FFFFFF}%s\n\n{00BFFF}Current Bid: {FFFFFF}$%i\n\n{00BFFF}Bidder: {FFFFFF}%s\n\n{00BFFF}Expires: {FFFFFF}%s", Auctions[listitem][BiddingFor], Auctions[listitem][Bid], Auctions[listitem][Wining], Auctions[listitem][Expires]);
				ShowPlayerDialogEx(playerid, DIALOG_AUCTIONS2, DIALOG_STYLE_MSGBOX, "{00BFFF}Auction Information", szInfo, "Bid", "Exit");
				SetPVarInt(playerid, "AuctionItem", listitem);
			}
			else SendClientMessageEx(playerid, COLOR_GREY, "That auction isn't currently available.");
		}
	}
	else if(dialogid == DIALOG_AUCTIONS2)
	{
		if(response) {

			new
				AuctionItem = GetPVarInt(playerid, "AuctionItem");
			if(Auctions[AuctionItem][InProgress] == 1) {

				new
					szInfo[128];

				format(szInfo, sizeof(szInfo), "You are bidding on %s. The current bid is $%i, to place a bid it must be higher then the current one.", Auctions[AuctionItem][BiddingFor], Auctions[AuctionItem][Bid]);
				ShowPlayerDialogEx(playerid, DIALOG_AUCTIONS3, DIALOG_STYLE_INPUT, "Auction - Bidding",szInfo,"Place Bid","Exit");
			}
			else {

				SendClientMessageEx(playerid, COLOR_GREY, "That auction isn't currently available.");
				DeletePVar(playerid, "AuctionItem");
			}
		}
	}
	else if(dialogid == DIALOG_AUCTIONS3)
	{
		if(response) {

			new
				BidPlaced = strval(inputtext),
				AuctionItem = GetPVarInt(playerid, "AuctionItem");

			if(GetPlayerCash(playerid) < BidPlaced) {
				SendClientMessageEx(playerid, COLOR_GREY, "You can't bid money you don't have.");
				return 1;
			}
			if(BidPlaced < 1) {
				SendClientMessageEx(playerid, COLOR_GREY, "You can't place a bid under $1.");
				return 1;
			}
			if(BidPlaced < Auctions[AuctionItem][Bid]+Auctions[AuctionItem][Increment]) {
				new szMessage[128];
				format(szMessage, sizeof(szMessage), "You need to bid at least %i over the current bid of %i.", Auctions[AuctionItem][Increment], Auctions[AuctionItem][Bid]);
				SendClientMessageEx(playerid, COLOR_GREY, szMessage);
				return 1;
			}

			if(Auctions[AuctionItem][InProgress] == 1) {
				if(BidPlaced > Auctions[AuctionItem][Bid]) {
					SetPVarInt(playerid, "BidPlaced", BidPlaced);
					HigherBid(playerid);
				}
				else SendClientMessageEx(playerid, COLOR_GREY, "That bid is to low, a higher amount is needed to place the bid.");
			}
			else SendClientMessageEx(playerid, COLOR_GREY, "That auction isn't currently available.");
		}
	}
	if(dialogid == DIALOG_CGAMESADMINMENU)
	{
		if(response) {
			switch(listitem)
			{
				case 0:
				{
					ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSELECTPOKER);
				}
				case 1:
				{
				}
				case 2:
				{
					ShowCasinoGamesMenu(playerid, DIALOG_CGAMESCREDITS);
				}
			}
		}
	}
	if(dialogid == DIALOG_CGAMESSELECTPOKER)
	{
		if(response) {
			SetPVarInt(playerid, "tmpEditPokerTableID", listitem+1);
			ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSETUPPOKER);
		} else {
			ShowCasinoGamesMenu(playerid, DIALOG_CGAMESADMINMENU);
		}
	}
	if(dialogid == DIALOG_CGAMESSETUPPOKER)
	{
		if(response) {
			new tableid = GetPVarInt(playerid, "tmpEditPokerTableID")-1;

			if(PokerTable[tableid][pkrPlaced] == 0) {
				switch(listitem)
				{
					case 0: // Place Poker Table
					{
						new szString[128];
						format(szString, sizeof(szString), "Press '{3399FF}~k~~PED_SPRINT~{FFFFFF}' to place poker table.");
						SendClientMessage(playerid, COLOR_WHITE, szString);

						SetPVarInt(playerid, "tmpPlacePokerTable", 1);
					}
				}
			} else {
				switch(listitem)
				{
					case 0: // Edit Poker Table
					{
						SetPVarFloat(playerid, "tmpPkrX", PokerTable[tableid][pkrX]);
						SetPVarFloat(playerid, "tmpPkrY", PokerTable[tableid][pkrY]);
						SetPVarFloat(playerid, "tmpPkrZ", PokerTable[tableid][pkrZ]);
						SetPVarFloat(playerid, "tmpPkrRX", PokerTable[tableid][pkrRX]);
						SetPVarFloat(playerid, "tmpPkrRY", PokerTable[tableid][pkrRY]);
						SetPVarFloat(playerid, "tmpPkrRZ", PokerTable[tableid][pkrRZ]);

						EditObject(playerid, PokerTable[tableid][pkrObjectID]);

						new szString[128];
						format(szString, sizeof(szString), "You have selected Poker Table %d, You may now customize it's position/rotation.", tableid);
						SendClientMessage(playerid, COLOR_WHITE, szString);
					}
					case 1: // Destroy Poker Table
					{
						DestroyPokerTable(tableid);

						new szString[64];
						format(szString, sizeof(szString), "You have deleted Poker Table %d.", tableid);
						SendClientMessage(playerid, COLOR_WHITE, szString);

						ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSELECTPOKER);
					}
				}
			}
		} else {
			ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSELECTPOKER);
		}
	}
	if(dialogid == DIALOG_CGAMESCREDITS)
	{
		ShowCasinoGamesMenu(playerid, DIALOG_CGAMESADMINMENU);
	}
	if(dialogid == DIALOG_CGAMESSETUPPGAME)
	{
		if(response) {
			switch(listitem)
			{
				case 0: // Buy-In Max
				{
					ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSETUPPGAME2);
				}
				case 1: // Buy-In Min
				{
					ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSETUPPGAME3);
				}
				case 2: // Blind
				{
					ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSETUPPGAME4);
				}
				case 3: // Limit
				{
					ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSETUPPGAME5);
				}
				case 4: // Password
				{
					ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSETUPPGAME6);
				}
				case 5: // Round Delay
				{
					ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSETUPPGAME7);
				}
				case 6: // Start Game
				{
					ShowCasinoGamesMenu(playerid, DIALOG_CGAMESBUYINPOKER);
				}
			}
		} else {
			LeavePokerTable(playerid);
		}
	}
	if(dialogid == DIALOG_CGAMESSETUPPGAME2)
	{
		if(response) {
			if(strval(inputtext) < 1 || strval(inputtext) > 10000) {
				return ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSETUPPGAME2);
			}

			if(strval(inputtext) <= PokerTable[GetPVarInt(playerid, "pkrTableID")-1][pkrBuyInMin]) {
				return ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSETUPPGAME2);
			}

			PokerTable[GetPVarInt(playerid, "pkrTableID")-1][pkrBuyInMax] = strval(inputtext);
			return ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSETUPPGAME);
		} else {
			return ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSETUPPGAME);
		}
	}
	if(dialogid == DIALOG_CGAMESSETUPPGAME3)
	{
		if(response) {
			if(strval(inputtext) < 1 || strval(inputtext) > 10000) {
				return ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSETUPPGAME3);
			}

			if(strval(inputtext) >= PokerTable[GetPVarInt(playerid, "pkrTableID")-1][pkrBuyInMax]) {
				return ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSETUPPGAME3);
			}

			PokerTable[GetPVarInt(playerid, "pkrTableID")-1][pkrBuyInMin] = strval(inputtext);
			return ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSETUPPGAME);
		} else {
			return ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSETUPPGAME);
		}
	}
	if(dialogid == DIALOG_CGAMESSETUPPGAME4)
	{
		if(response) {
			if(strval(inputtext) < 1 || strval(inputtext) > 10000) {
				return ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSETUPPGAME4);
			}

			PokerTable[GetPVarInt(playerid, "pkrTableID")-1][pkrBlind] = strval(inputtext);
			return ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSETUPPGAME);
		} else {
			return ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSETUPPGAME);
		}
	}
	if(dialogid == DIALOG_CGAMESSETUPPGAME5)
	{
		if(response) {
			if(strval(inputtext) < 2 || strval(inputtext) > 6) {
				return ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSETUPPGAME5);
			}

			PokerTable[GetPVarInt(playerid, "pkrTableID")-1][pkrLimit] = strval(inputtext);
			return ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSETUPPGAME);
		} else {
			return ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSETUPPGAME);
		}
	}
	if(dialogid == DIALOG_CGAMESSETUPPGAME6)
	{
		if(response) {
			new tableid = GetPVarInt(playerid, "pkrTableID")-1;
			strmid(PokerTable[tableid][pkrPass], inputtext, 0, strlen(inputtext), 32);
			return ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSETUPPGAME);
		} else {
			ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSETUPPGAME);
		}
	}
	if(dialogid == DIALOG_CGAMESSETUPPGAME7)
	{
		if(response) {
			if(strval(inputtext) < 15 || strval(inputtext) > 120) {
				return ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSETUPPGAME7);
			}

			PokerTable[GetPVarInt(playerid, "pkrTableID")-1][pkrSetDelay] = strval(inputtext);
			return ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSETUPPGAME);
		} else {
			return ShowCasinoGamesMenu(playerid, DIALOG_CGAMESSETUPPGAME);
		}
	}
	if(dialogid == DIALOG_CGAMESBUYINPOKER)
	{
		if(response) {
			if(strval(inputtext) < PokerTable[GetPVarInt(playerid, "pkrTableID")-1][pkrBuyInMin] || strval(inputtext) > PokerTable[GetPVarInt(playerid, "pkrTableID")-1][pkrBuyInMax] || strval(inputtext) > GetPlayerCash(playerid)) {
				return ShowCasinoGamesMenu(playerid, DIALOG_CGAMESBUYINPOKER);
			}

			PokerTable[GetPVarInt(playerid, "pkrTableID")-1][pkrActivePlayers]++;
			SetPVarInt(playerid, "pkrChips", GetPVarInt(playerid, "pkrChips")+strval(inputtext));
			//SetPVarInt(playerid, "cgChips", GetPVarInt(playerid, "cgChips")-strval(inputtext));

			GivePlayerCashEx(playerid, TYPE_ONHAND, -strval(inputtext));

			format(string, sizeof(string), "%s(%d) (IP:%s) has bought in with the amount of $%s (%d)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(GetPVarInt(playerid, "pkrChips")), GetPVarInt(playerid, "pkrTableID")-1);
			Log("logs/poker.log", string);

			if(PokerTable[GetPVarInt(playerid, "pkrTableID")-1][pkrActive] == 3 && PokerTable[GetPVarInt(playerid, "pkrTableID")-1][pkrRound] == 0 && PokerTable[GetPVarInt(playerid, "pkrTableID")-1][pkrDelay] >= 6) {
				SetPVarInt(playerid, "pkrStatus", 1);
			}
			else if(PokerTable[GetPVarInt(playerid, "pkrTableID")-1][pkrActive] < 3) {
				SetPVarInt(playerid, "pkrStatus", 1);
			}

			if(PokerTable[GetPVarInt(playerid, "pkrTableID")-1][pkrActive] == 1 && GetPVarInt(playerid, "pkrRoomLeader")) {
				PokerTable[GetPVarInt(playerid, "pkrTableID")-1][pkrActive] = 2;
				SelectTextDraw(playerid, COLOR_YELLOW);
			}
		} else {
			return LeavePokerTable(playerid);
		}
	}
	if(dialogid == DIALOG_CGAMESCALLPOKER)
	{
		if(response) {
			new tableid = GetPVarInt(playerid, "pkrTableID")-1;

			new actualBet = PokerTable[tableid][pkrActiveBet]-GetPVarInt(playerid, "pkrCurrentBet");

			if(actualBet > GetPVarInt(playerid, "pkrChips")) {
				PokerTable[tableid][pkrPot] += GetPVarInt(playerid, "pkrChips");
				SetPVarInt(playerid, "pkrChips", 0);
				SetPVarInt(playerid, "pkrCurrentBet", PokerTable[tableid][pkrActiveBet]);
			} else {
				PokerTable[tableid][pkrPot] += actualBet;
				SetPVarInt(playerid, "pkrChips", GetPVarInt(playerid, "pkrChips")-actualBet);
				SetPVarInt(playerid, "pkrCurrentBet", PokerTable[tableid][pkrActiveBet]);
			}

			SetPVarString(playerid, "pkrStatusString", "Call");
			PokerRotateActivePlayer(tableid);

			ApplyAnimation(playerid, "CASINO", "cards_raise", 4.1, 0, 1, 1, 1, 1, 1);
		}

		DeletePVar(playerid, "pkrActionChoice");
	}
	if(dialogid == DIALOG_CGAMESRAISEPOKER)
	{
		if(response) {
			new tableid = GetPVarInt(playerid, "pkrTableID")-1;

			new actualRaise = strval(inputtext)-GetPVarInt(playerid, "pkrCurrentBet");

			if(strval(inputtext) >= PokerTable[tableid][pkrActiveBet]+PokerTable[tableid][pkrBlind]/2 && strval(inputtext) <= GetPVarInt(playerid, "pkrCurrentBet")+GetPVarInt(playerid, "pkrChips")) {
				PokerTable[tableid][pkrPot] += actualRaise;
				PokerTable[tableid][pkrActiveBet] = strval(inputtext);
				SetPVarInt(playerid, "pkrChips", GetPVarInt(playerid, "pkrChips")-actualRaise);
				SetPVarInt(playerid, "pkrCurrentBet", PokerTable[tableid][pkrActiveBet]);

				SetPVarString(playerid, "pkrStatusString", "Raise");

				PokerTable[tableid][pkrRotations] = 0;
				PokerRotateActivePlayer(tableid);

				ApplyAnimation(playerid, "CASINO", "cards_raise", 4.1, 0, 1, 1, 1, 1, 1);
			} else {
				ShowCasinoGamesMenu(playerid, DIALOG_CGAMESRAISEPOKER);
			}
		}

		DeletePVar(playerid, "pkrActionChoice");
	}
	if(dialogid == DIALOG_CHARGEPLAYER)
	{
		if(response)
		{
			if(PlayerInfo[playerid][pCredits] < GetPVarInt(playerid, "FineAmount"))
				return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to be fined.");

			new reason[60];
			GetPVarString(playerid, "FineReason", reason, 60);
			format(string, sizeof(string), "AdmCmd: %s(%d) was fined %s credits by %s, reason: %s", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), number_format(GetPVarInt(playerid, "FineAmount")), GetPlayerNameEx(GetPVarInt(playerid, "FineBy")), reason);
			Log("logs/admin.log", string);

			format(string, sizeof(string), "[CHARGEPLAYER] [User: %s(%i)] [IP: %s] [Credits: %s] [Charged: %s]", GetPlayerNameEx(playerid), PlayerInfo[playerid][pId], GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]),  number_format(GetPVarInt(playerid, "FineAmount")));
			Log("logs/credits.log", string);

			GivePlayerCredits(playerid, -GetPVarInt(playerid, "FineAmount"), 1);

			format(string, sizeof(string), "You were charged %s credits for %s by %s.", number_format(GetPVarInt(playerid, "FineAmount")), reason, GetPlayerNameEx(GetPVarInt(playerid, "FineBy")));
			SendClientMessageEx(playerid, COLOR_CYAN, string);

			format(string, sizeof(string), "You charged %s %s credits for %s.", GetPlayerNameEx(playerid), number_format(GetPVarInt(playerid, "FineAmount")), reason);
			SendClientMessageEx(GetPVarInt(playerid, "FineBy"), COLOR_CYAN, string);
		}
		else
		{
			SendClientMessageEx(GetPVarInt(playerid, "FineBy"), COLOR_CYAN, "The player has declined the charge.");
		}
		DeletePVar(playerid, "FineAmount");
		DeletePVar(playerid, "FineBy");
		DeletePVar(playerid, "FineReason");
	}
	if(dialogid == DIALOG_EDITSHOPMENU)
	{
		if(response)
		{
			if(listitem == 0)
			{
				new shopstring[4500];
				format(shopstring, sizeof(shopstring),
				"Gold VIP (Credits: %s)\n\
				Gold VIP Renewal (Credits: %s)\n\
				Silver VIP (Credits: %s)\n\
				Bronze VIP (Credits: %s)\n\
				Toys (Credits: %s)\n\
				Vehicles (Credits: %s)\n\
				Poker Table (Credits: %s)\n\
				Boombox (Credits: %s)", number_format(ShopItems[0][sItemPrice]), number_format(ShopItems[1][sItemPrice]), number_format(ShopItems[2][sItemPrice]), number_format(ShopItems[3][sItemPrice]), number_format(ShopItems[4][sItemPrice]),
				 number_format(ShopItems[5][sItemPrice]), number_format(ShopItems[6][sItemPrice]), number_format(ShopItems[7][sItemPrice]));

				format(shopstring, sizeof(shopstring), "%s\n\
				Paintball Tokens (Credits %s)\n\
				EXP Token (Credits: %s)\n\
				Fireworks x5 (Credits: %s)\n\
				Renewal Regular (Credits: %s)\n\
				Renewal Standard (Credits: %s)\n\
				Renewal Premium (Credits: %s)\n\
				House (Credits: %s)\n\
				House Interior Change (Credits: %s)\n\
				House Move (Credits: %s)\n\
				(Micro) Reset Gift Timer (Credits: %s)",shopstring, number_format(ShopItems[8][sItemPrice]), number_format(ShopItems[9][sItemPrice]), number_format(ShopItems[10][sItemPrice]),
				number_format(ShopItems[11][sItemPrice]), number_format(ShopItems[12][sItemPrice]), number_format(ShopItems[13][sItemPrice]), number_format(ShopItems[14][sItemPrice]),
				 number_format(ShopItems[15][sItemPrice]), number_format(ShopItems[16][sItemPrice]), number_format(ShopItems[17][sItemPrice]));
				format(shopstring, sizeof(shopstring),
				"%s\n(Micro) Advanced Healthcare (Credits: %s)\n\
				(Micro) Super Advanced Healthcare (Credits: %s)\n\
				(Micro) Rent a Car (Credits: %s)\n\
				Platinum VIP (Credits: %s)\n\
				Custom License Plate (Credits: %s)\n\
				Additional Vehicle Slot (Credits: %s)", shopstring, number_format(ShopItems[18][sItemPrice]), number_format(ShopItems[19][sItemPrice]), number_format(ShopItems[20][sItemPrice]),
				 number_format(ShopItems[21][sItemPrice]), number_format(ShopItems[22][sItemPrice]), number_format(ShopItems[23][sItemPrice]));
				format(shopstring, sizeof(shopstring),
				"%s\nGarage - Small (Credits: %s)\n\
				Garage - Medium (Credits: %s)\n\
				Garage - Large (Credits: %s)\n\
				Garage - Extra Large (Credits: %s)\n\
				Additional Toy Slot (Credits: %s)\n\
				Hunger Voucher (Credits: %s)\n\
				Spawn at Gold VIP+ room (Credits: %s)", shopstring, number_format(ShopItems[24][sItemPrice]), number_format(ShopItems[25][sItemPrice]), number_format(ShopItems[26][sItemPrice]),
				number_format(ShopItems[27][sItemPrice]), number_format(ShopItems[28][sItemPrice]), number_format(ShopItems[29][sItemPrice]), number_format(ShopItems[30][sItemPrice]));
				format(shopstring, sizeof(shopstring),
				"%s\n\
				Restricted Last Name (NEW) (Credits: %s)\n\
				Restricted Last Name (CHANGE) (Credits: %s)\n\
				Custom User Title (NEW) (Credits: %s)\n\
				Custom User Title (CHANGE) (Credits: %s)\n\
				Teamspeak User Channel (Credits: %s)\n\
				Small Backpack (Credits: %s)\n\
				Medium Backpack (Credits: %s)\n\
				Large Backpack (Credits: %s)\n\
				Deluxe Car Alarm (Credits: %s)\n\
				Name Changes (Credits: %s)\n\
				Furniture Pack - Bronze (Credits: %s)\n\
				Furniture Pack - Silver (Credits: %s)\n\
				Furniture Pack - Gold (Credits: %s)",
				shopstring, number_format(ShopItems[31][sItemPrice]), number_format(ShopItems[32][sItemPrice]), number_format(ShopItems[33][sItemPrice]), number_format(ShopItems[34][sItemPrice]),
				number_format(ShopItems[35][sItemPrice]),number_format(ShopItems[36][sItemPrice]),number_format(ShopItems[37][sItemPrice]),number_format(ShopItems[38][sItemPrice]),number_format(ShopItems[39][sItemPrice]), number_format(ShopItems[40][sItemPrice]),
				number_format(ShopItems[41][sItemPrice]), number_format(ShopItems[42][sItemPrice]), number_format(ShopItems[43][sItemPrice]));
				ShowPlayerDialogEx(playerid, DIALOG_EDITSHOP, DIALOG_STYLE_LIST, "Edit Shop Prices", shopstring, "Edit", "Exit");
			}
			if(listitem == 1)
			{
				ShowPlayerDialogEx(playerid, DIALOG_EDITSHOPBUSINESS, DIALOG_STYLE_LIST, "Edit Business Shop", "Add Business\nEdit Business\nView Businesses Sold", "Select", "Exit");
			}
			if(listitem == 2)
			{
				for(new i; i < MAX_MICROITEMS; i++)
				{
					format(szMiscArray, sizeof(szMiscArray), "%s\n%s (Credits: %s)", szMiscArray, mItemName[i], number_format(MicroItems[i]));
				}
				ShowPlayerDialogEx(playerid, DIALOG_EDITMICROSHOP, DIALOG_STYLE_LIST, "Edit Micro Shop Prices", szMiscArray, "Edit", "Exit");
			}
		}
	}
	if(dialogid == DIALOG_EDITSHOP)
	{
		if(response) {
			new item[30];
			SetPVarInt(playerid, "EditingPrice", listitem);
			switch(listitem)
			{
				case 0: item = "Gold VIP";
				case 1: item = "Gold VIP Renewal";
				case 2: item = "Silver VIP";
				case 3: item = "Bronze VIP";
				case 4: item = "Toys";
				case 5: item = "Vehicles";
				case 6: item = "Poker Table";
				case 7: item = "Boombox";
				case 8: item = "Paintball Tokens";
				case 9: item = "EXP Token";
				case 10: item = "Fireworks x5";
				case 11: item = "Renewal Regular";
				case 12: item = "Renewal Standard";
				case 13: item = "Renewal Premium";
				case 14: item = "House";
				case 15: item = "House Interior Change";
				case 16: item = "House Move";
				case 17: item = "(Micro) Reset Gift Timer";
				case 18: item = "(Micro) Advanced Health Care";
				case 19: item = "(Micro) Super Health Care";
				case 20: item = "(Micro) Rent a Car";
				case 21: item = "Platinum VIP";
				case 22: item = "License Plate";
				case 23: item = "Additional Vehicle Slot";
				case 24: item = "Garage - Small";
				case 25: item = "Garage - Medium";
				case 26: item = "Garage - Large";
				case 27: item = "Garage - Extra Large";
				case 28: item = "Additional Toy Slot";
				case 29: item = "Hunger Voucher";
				case 30: item = "Spawn at Gold VIP+ room";
				case 31: item = "Restricted Last Name (NEW)";
				case 32: item = "Restricted Last Name (CHANGE)";
				case 33: item = "Custom User Title (NEW)";
				case 34: item = "Custom User Title (CHANGE)";
				case 35: item = "Teamspeak User Channel";
				case 36: item = "Small Backpack";
				case 37: item = "Medium Backpack";
				case 38: item = "Large Backpack";
				case 39: item = "Deluxe Car Alarm";
				case 40: item = "Name Changes";
				case 41: item = "Furniture Slots Pack - Bronze";
				case 42: item = "Furniture Slots Pack - Silver";
				case 43: item = "Furniture Slots Pack - Gold";
			}
			format(string, sizeof(string), "You are currently editing the price of %s. The current credit cost is %d.", item, ShopItems[listitem][sItemPrice]);
			ShowPlayerDialogEx(playerid, DIALOG_EDITSHOP2, DIALOG_STYLE_INPUT, "Editing Price", string, "Change", "Back");
		}
	}
	if(dialogid == DIALOG_EDITSHOP2)
	{
		if(response) {

			new
				Prices = strval(inputtext),
				item[30];

			switch(GetPVarInt(playerid, "EditingPrice"))
			{
				case 0: item = "Gold VIP";
				case 1: item = "Gold VIP Renewal";
				case 2: item = "Silver VIP";
				case 3: item = "Bronze VIP";
				case 4: item = "Toys";
				case 5: item = "Vehicles";
				case 6: item = "Poker Table";
				case 7: item = "Boombox";
				case 8: item = "Paintball Tokens";
				case 9: item = "EXP Token";
				case 10: item = "Fireworks x5";
				case 11: item = "Renewal Regular";
				case 12: item = "Renewal Standard";
				case 13: item = "Renewal Premium";
				case 14: item = "House";
				case 15: item = "House Interior Change";
				case 16: item = "House Move";
				case 17: item = "(Micro) Reset Gift Timer";
				case 18: item = "(Micro) Advanced Health Care";
				case 19: item = "(Micro) Super Health Care";
				case 20: item = "(Micro) Rent a Car";
				case 21: item = "Platinum VIP";
				case 22: item = "License Plate";
				case 23: item = "Additional Vehicle Slot";
				case 24: item = "Garage - Small";
				case 25: item = "Garage - Medium";
				case 26: item = "Garage - Large";
				case 27: item = "Garage - Extra Large";
				case 28: item = "Additional Toy Slot";
				case 29: item = "Hunger Voucher";
				case 30: item = "Spawn at Gold VIP+ room";
				case 31: item = "Restricted Last Name (NEW)";
				case 32: item = "Restricted Last Name (CHANGE)";
				case 33: item = "Custom User Title (NEW)";
				case 34: item = "Custom User Title (CHANGE)";
				case 35: item = "Teamspeak User Channel";
				case 36: item = "Small Backpack";
				case 37: item = "Medium Backpack";
				case 38: item = "Large Backpack";
				case 39: item = "Deluxe Car Alarm";
				case 40: item = "Name Changes";
				case 41: item = "Furniture Slots Pack - Bronze";
				case 42: item = "Furniture Slots Pack - Silver";
				case 43: item = "Furniture Slots Pack - Gold";
			}

			if(isnull(inputtext) || Prices <= 0) {
				format(string, sizeof(string), "The price can't be below 0.\n\nYou are currently editing the price of %s. The current credit cost is %d.", item, ShopItems[GetPVarInt(playerid, "EditingPrice")][sItemPrice]);
				ShowPlayerDialogEx(playerid, DIALOG_EDITSHOP2, DIALOG_STYLE_INPUT, "Editing Price", string, "Change", "Back");
			}
			else
			{
				SetPVarInt(playerid, "EditingPriceValue", Prices);

				format(string,sizeof(string),"Are you sure you want to edit the cost of %s?\n\nOld Cost: %d\nNew Cost: %d", item, ShopItems[GetPVarInt(playerid, "EditingPrice")][sItemPrice], Prices);
				ShowPlayerDialogEx(playerid, DIALOG_EDITSHOP3, DIALOG_STYLE_MSGBOX, "Confirmation", string, "Confirm", "Cancel");
				return 1;
			}
		}
		format(szMiscArray, sizeof(szMiscArray),
		"Gold VIP (Credits: %s)\n\
		Gold VIP Renewal (Credits: %s)\n\
		Silver VIP (Credits: %s)\n\
		Bronze VIP (Credits: %s)\n\
		Toys (Credits: %s)\n\
		Vehicles (Credits: %s)\n\
		Poker Table (Credits: %s)\n\
		Boombox (Credits: %s)", number_format(ShopItems[0][sItemPrice]), number_format(ShopItems[1][sItemPrice]), number_format(ShopItems[2][sItemPrice]), number_format(ShopItems[3][sItemPrice]), number_format(ShopItems[4][sItemPrice]),
		 number_format(ShopItems[5][sItemPrice]), number_format(ShopItems[6][sItemPrice]), number_format(ShopItems[7][sItemPrice]));

		format(szMiscArray, sizeof(szMiscArray), "%s\n\
		Paintball Tokens (Credits %s)\n\
		EXP Token (Credits: %s)\n\
		Fireworks x5 (Credits: %s)\n\
		Renewal Regular (Credits: %s)\n\
		Renewal Standard (Credits: %s)\n\
		Renewal Premium (Credits: %s)\n\
		House (Credits: %s)\n\
		House Interior Change (Credits: %s)\n\
		House Move (Credits: %s)\n\
		(Micro) Reset Gift Timer (Credits: %s)", szMiscArray, number_format(ShopItems[8][sItemPrice]), number_format(ShopItems[9][sItemPrice]), number_format(ShopItems[10][sItemPrice]),
		number_format(ShopItems[11][sItemPrice]), number_format(ShopItems[12][sItemPrice]), number_format(ShopItems[13][sItemPrice]), number_format(ShopItems[14][sItemPrice]), number_format(ShopItems[15][sItemPrice]),
		number_format(ShopItems[16][sItemPrice]), number_format(ShopItems[17][sItemPrice]));
		format(szMiscArray, sizeof(szMiscArray),
		"%s\n(Micro) Advanced Healthcare (Credits: %s)\n\
		(Micro) Super Advanced Healthcare (Credits: %s)\n\
		(Micro) Rent a Car (Credits: %s)\n\
		Platinum VIP (Credits: %s)\n\
		Custom License Plate (Credits: %s)\n\
		Additional Vehicle Slot (Credits: %s)", szMiscArray, number_format(ShopItems[18][sItemPrice]), number_format(ShopItems[19][sItemPrice]), number_format(ShopItems[20][sItemPrice]), number_format(ShopItems[21][sItemPrice]),
		 number_format(ShopItems[22][sItemPrice]), number_format(ShopItems[23][sItemPrice]));
		format(szMiscArray, sizeof(szMiscArray),
		"%s\nGarage - Small (Credits: %s)\n\
		Garage - Medium (Credits: %s)\n\
		Garage - Large (Credits: %s)\n\
		Garage - Extra Large (Credits: %s)\n\
		Additional Toy Slot (Credits: %s)\n\
		Hunger Voucher (Credits: %s)\n\
		Spawn at Gold VIP+ room (Credits: %s)", szMiscArray, number_format(ShopItems[24][sItemPrice]), number_format(ShopItems[25][sItemPrice]), number_format(ShopItems[26][sItemPrice]),
		number_format(ShopItems[27][sItemPrice]), number_format(ShopItems[28][sItemPrice]), number_format(ShopItems[29][sItemPrice]), number_format(ShopItems[30][sItemPrice]));
		format(szMiscArray, sizeof(szMiscArray),
		"%s\n\
		Restricted Last Name (NEW) (Credits: %s)\n\
		Restricted Last Name (CHANGE) (Credits: %s)\n\
		Custom User Title (NEW) (Credits: %s)\n\
		Custom User Title (CHANGE) (Credits: %s)\n\
		Teamspeak User Channel (Credits: %s)\n\
		Small Backpack (Credits: %s)\n\
		Medium Backpack (Credits: %s)\n\
		Large Backpack (Credits: %s)\n\
		Deluxe Car Alarm (Credits: %s)\n\
		Name Changes (Credits: %s)\n\
		Furniture Pack - Bronze (Credits: %s)\n\
		Furniture Pack - Silver (Credits: %s)\n\
		Furniture Pack - Gold (Credits: %s)",
		szMiscArray, number_format(ShopItems[31][sItemPrice]), number_format(ShopItems[32][sItemPrice]), number_format(ShopItems[33][sItemPrice]), number_format(ShopItems[34][sItemPrice]),
		number_format(ShopItems[35][sItemPrice]),number_format(ShopItems[36][sItemPrice]),number_format(ShopItems[37][sItemPrice]),number_format(ShopItems[38][sItemPrice]),number_format(ShopItems[39][sItemPrice]), number_format(ShopItems[40][sItemPrice]),
		number_format(ShopItems[41][sItemPrice]), number_format(ShopItems[42][sItemPrice]), number_format(ShopItems[43][sItemPrice]));
		ShowPlayerDialogEx(playerid, DIALOG_EDITSHOP, DIALOG_STYLE_LIST, "Edit Shop Prices", szMiscArray, "Edit", "Exit");
	}
	if(dialogid == DIALOG_EDITSHOP3)
	{
		if(response)
		{
			new item[30];
			switch(GetPVarInt(playerid, "EditingPrice"))
			{
				case 0: item = "Gold VIP";
				case 1: item = "Gold VIP Renewal";
				case 2: item = "Silver VIP";
				case 3: item = "Bronze VIP";
				case 4: item = "Toys";
				case 5: item = "Vehicles";
				case 6: item = "Poker Table";
				case 7: item = "Boombox";
				case 8: item = "Paintball Tokens";
				case 9: item = "EXP Token";
				case 10: item = "Fireworks x5";
				case 11: item = "Renewal Regular";
				case 12: item = "Renewal Standard";
				case 13: item = "Renewal Premium";
				case 14: item = "House";
				case 15: item = "House Interior Change";
				case 16: item = "House Move";
				case 17: item = "(Micro) Reset Gift Timer";
				case 18: item = "(Micro) Advanced Health Care";
				case 19: item = "(Micro) Super Health Care";
				case 20: item = "(Micro) Rent a Car";
				case 21: item = "Platinum VIP";
				case 22: item = "License Plate";
				case 23: item = "Additional Vehicle Slot";
				case 24: item = "Garage - Small";
				case 25: item = "Garage - Medium";
				case 26: item = "Garage - Large";
				case 27: item = "Garage - Extra Large";
				case 28: item = "Additional Toy Slot";
				case 29: item = "Hunger Voucher";
				case 30: item = "Spawn at Gold VIP+ room";
				case 31: item = "Restricted Last Name (NEW)";
				case 32: item = "Restricted Last Name (CHANGE)";
				case 33: item = "Custom User Title (NEW)";
				case 34: item = "Custom User Title (CHANGE)";
				case 35: item = "Teamspeak User Channel";
				case 36: item = "Small Backpack";
				case 37: item = "Medium Backpack";
				case 38: item = "Large Backpack";
				case 39: item = "Deluxe Car Alarm";
				case 40: item = "Name Changes";
				case 41: item = "Furniture Slots Pack - Bronze";
				case 42: item = "Furniture Slots Pack - Silver";
				case 43: item = "Furniture Slots Pack - Gold";
			}
			if(GetPVarInt(playerid, "EditingPriceValue") == 0)
				SetPVarInt(playerid, "EditingPriceValue", 999999);

			Price[GetPVarInt(playerid, "EditingPrice")] = GetPVarInt(playerid, "EditingPriceValue");
			ShopItems[GetPVarInt(playerid, "EditingPrice")][sItemPrice] = GetPVarInt(playerid, "EditingPriceValue");
			format(string, sizeof(string), "You have successfully edited the price of %s to %d.", item, GetPVarInt(playerid, "EditingPriceValue"));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			format(string, sizeof(string), "[EDITSHOPPRICES] [User: %s(%i)] [IP: %s] [%s] [Price: %s]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), item, number_format(ShopItems[GetPVarInt(playerid, "EditingPrice")][sItemPrice]));
			Log("logs/editshop.log", string), print(string);
			g_mysql_SavePrices();
			return 1;
		}
		DeletePVar(playerid, "EditingPrice");
		DeletePVar(playerid, "EditingPriceValue");
		SendClientMessageEx(playerid, COLOR_GREY, "You have canceled the price change.");
	}
	if(dialogid == DIALOG_ENTERPIN)
	{
		if(response)
		{
			if(isnull(inputtext) || strlen(inputtext) > 4 || !IsNumeric(inputtext))
			{
				ShowPlayerDialogEx(playerid, DIALOG_ENTERPIN, DIALOG_STYLE_INPUT, "Pin Number", "Enter your pin number to access credit shops.", "Confirm", "Exit");
				return 1;
			}

			SetPVarString(playerid, "PinNumber", inputtext);

			mysql_format(MainPipeline, string, sizeof(string), "SELECT `Pin` FROM `accounts` WHERE `Username` = '%e'", GetPlayerNameExt(playerid));
			mysql_tquery(MainPipeline, string, "OnPinCheck2", "i", playerid);

		}
	}
	if(dialogid == DIALOG_CREATEPIN)
	{
		if(response)
		{

			if(strlen(inputtext) > 4 || !IsNumeric(inputtext))
				return ShowPlayerDialogEx(playerid, DIALOG_CREATEPIN, DIALOG_STYLE_INPUT, "Pin Number", "Error: A pin must be numbers only, and have at least 4 digits. \nCreate a pin number so you can secure your account credits.", "Create", "Exit");

			if(GetPVarType(playerid, "ChangePin"))
			{
				if(isnull(inputtext))
					return ShowPlayerDialogEx(playerid, DIALOG_CREATEPIN, DIALOG_STYLE_INPUT, "Change Pin Number", "Enter a new pin number to change your current one.", "Change", "Cancel");
			}
			else
			{
				if(isnull(inputtext))
					return ShowPlayerDialogEx(playerid, DIALOG_CREATEPIN, DIALOG_STYLE_INPUT, "Pin Number", "Create a pin number so you can secure your account credits.", "Create", "Exit");
			}

			SetPVarString(playerid, "PinConfirm", inputtext);
			ShowPlayerDialogEx(playerid, DIALOG_CREATEPIN2, DIALOG_STYLE_INPUT, "Pin Number", "Enter your pin number again to confirm it.", "Create", "Exit");
		}
		else if(GetPVarType(playerid, "ChangePin")) DeletePVar(playerid, "ChangePin");
	}
	if(dialogid == DIALOG_VIEWSALE)
	{
		if(response)
		{
			mysql_format(MainPipeline, string, sizeof(string), "SELECT * FROM `sales` WHERE `id` = '%d'", Selected[playerid][listitem]);
			SetPVarInt(playerid, "checkingsale", Selected[playerid][listitem]);
			mysql_tquery(MainPipeline, string, "CheckSales2", "i", playerid);
		}
	}
	if(dialogid == DIALOG_VIEWSALE2)
	{
		if(response)
		{
			mysql_format(MainPipeline, string, sizeof(string), "SELECT * FROM `sales` WHERE `id` = '%d'", GetPVarInt(playerid, "checkingsale"));
			mysql_tquery(MainPipeline, string, "CheckSales3", "i", playerid);
		}
	}
	if(dialogid == DIALOG_CREATEPIN2)
	{
		if(response)
		{
			if(isnull(inputtext))
				return ShowPlayerDialogEx(playerid, DIALOG_CREATEPIN2, DIALOG_STYLE_INPUT, "Pin Number", "Enter your pin number again to confirm it.", "Create", "Exit");

			new confirm[128];
			GetPVarString(playerid, "PinConfirm", confirm, 128);
			if(strcmp(inputtext, confirm, true) != 0)
			{
				if(GetPVarType(playerid, "ChangePin"))
				{
					ShowPlayerDialogEx(playerid, DIALOG_CREATEPIN, DIALOG_STYLE_INPUT, "Pin Number", "Enter a new pin number to change your current one.", "Change", "Cancel");
				}
				else
				{
					ShowPlayerDialogEx(playerid, DIALOG_CREATEPIN, DIALOG_STYLE_INPUT, "Pin Number", "Error: Pin numbers did not match.\n\nCreate a pin number so you can secure your account credits.", "Create", "Exit");
				}
				DeletePVar(playerid, "PinConfirm");
			}
			else
			{
				format(string, sizeof(string), "Your new pin number is '%s.'", inputtext);
				SendClientMessageEx(playerid, COLOR_CYAN, string);

				new passbuffer[258];
				WP_Hash(passbuffer, sizeof(passbuffer), inputtext);

				new query[256];
				mysql_format(MainPipeline, query, sizeof(query), "UPDATE `accounts` SET `Pin`='%s' WHERE `id` = %d", passbuffer, GetPlayerSQLId(playerid));
				mysql_tquery(MainPipeline, query, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
				DeletePVar(playerid, "PinConfirm");
				DeletePVar(playerid, "ChangePin");
			}
		}
	}
	if(dialogid == DIALOG_MISCSHOP && response)
	{
		SetPVarInt(playerid, "MiscShop", listitem+1);
		switch(listitem)
		{
			case 0:
			{
				format(string, sizeof(string), "Item: Poker Table\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[6][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[6][sItemPrice]));
				ShowPlayerDialogEx(playerid, DIALOG_MISCSHOP2, DIALOG_STYLE_MSGBOX, "Misc Shop", string, "Purchase", "Cancel");
			}
			case 1:
			{
				format(string, sizeof(string), "Item: Boombox\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[7][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[7][sItemPrice]));
				ShowPlayerDialogEx(playerid, DIALOG_MISCSHOP2, DIALOG_STYLE_MSGBOX, "Misc Shop", string, "Purchase", "Cancel");
			}
			case 2:
			{
				format(string, sizeof(string), "Item: 100 Paintball Tokens\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]),number_format(ShopItems[8][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[8][sItemPrice]));
				ShowPlayerDialogEx(playerid, DIALOG_MISCSHOP2, DIALOG_STYLE_MSGBOX, "Misc Shop", string, "Purchase", "Cancel");
			}
			case 3:
			{
				format(string, sizeof(string), "Item: EXP Token\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]),number_format(ShopItems[9][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[9][sItemPrice]));
				ShowPlayerDialogEx(playerid, DIALOG_MISCSHOP2, DIALOG_STYLE_MSGBOX, "Misc Shop", string, "Purchase", "Cancel");
			}
			case 4:
			{
				format(string, sizeof(string), "Item: Fireworks x5\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]),number_format(ShopItems[10][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[10][sItemPrice]));
				ShowPlayerDialogEx(playerid, DIALOG_MISCSHOP2, DIALOG_STYLE_MSGBOX, "Misc Shop", string, "Purchase", "Cancel");
			}
			case 5:
			{
				format(string, sizeof(string), "Item: Custom License Plate\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]),number_format(ShopItems[22][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[22][sItemPrice]));
				ShowPlayerDialogEx(playerid, DIALOG_MISCSHOP2, DIALOG_STYLE_MSGBOX, "Misc Shop", string, "Purchase", "Cancel");
			}
			case 6:
			{
				SetPVarInt(playerid, "MiscShop", 10);
				format(string, sizeof(string), "Item: Restricted Last Name (NEW)\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]),number_format(ShopItems[31][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[31][sItemPrice]));
				ShowPlayerDialogEx(playerid, DIALOG_MISCSHOP2, DIALOG_STYLE_MSGBOX, "Misc Shop", string, "Purchase", "Cancel");
			}
			case 7:
			{
				SetPVarInt(playerid, "MiscShop", 11);
				format(string, sizeof(string), "Item: Restricted Last Name (CHANGE)\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]),number_format(ShopItems[32][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[32][sItemPrice]));
				ShowPlayerDialogEx(playerid, DIALOG_MISCSHOP2, DIALOG_STYLE_MSGBOX, "Misc Shop", string, "Purchase", "Cancel");
			}
			case 8:
			{
				SetPVarInt(playerid, "MiscShop", 12);
				format(string, sizeof(string), "Item: Custom User Title (NEW)\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]),number_format(ShopItems[33][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[33][sItemPrice]));
				ShowPlayerDialogEx(playerid, DIALOG_MISCSHOP2, DIALOG_STYLE_MSGBOX, "Misc Shop", string, "Purchase", "Cancel");
			}
			case 9:
			{
				SetPVarInt(playerid, "MiscShop", 13);
				format(string, sizeof(string), "Item: Custom User Title (CHANGE)\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]),number_format(ShopItems[34][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[34][sItemPrice]));
				ShowPlayerDialogEx(playerid, DIALOG_MISCSHOP2, DIALOG_STYLE_MSGBOX, "Misc Shop", string, "Purchase", "Cancel");
			}
			case 10:
			{
				SetPVarInt(playerid, "MiscShop", 14);
				format(string, sizeof(string), "Item: Teamspeak User Channel\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]),number_format(ShopItems[35][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[35][sItemPrice]));
				ShowPlayerDialogEx(playerid, DIALOG_MISCSHOP2, DIALOG_STYLE_MSGBOX, "Misc Shop", string, "Purchase", "Cancel");
			}
			case 11:
			{
				new bdialog[145];
				format(bdialog, sizeof(bdialog), "Small Backpack (Credits: {FFD700}%s{A9C4E4})\nMedium Backpack (Credits: {FFD700}%s{A9C4E4})\nLarge Backpack (Credits: {FFD700}%s{A9C4E4})",
				number_format(ShopItems[36][sItemPrice]), number_format(ShopItems[37][sItemPrice]), number_format(ShopItems[38][sItemPrice]));
				ShowPlayerDialogEx(playerid, DIALOG_BACKPACKS, DIALOG_STYLE_LIST, "Misc Shop", bdialog, "Select", "Cancel");
			}
			case 12:
			{
				SetPVarInt(playerid, "MiscShop", 18);
				format(string, sizeof(string), "Item: Deluxe Car Alarm\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]),number_format(ShopItems[39][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[39][sItemPrice]));
				ShowPlayerDialogEx(playerid, DIALOG_MISCSHOP2, DIALOG_STYLE_MSGBOX, "Misc Shop", string, "Purchase", "Cancel");
			}
		}
	}
	if(dialogid == DIALOG_BACKPACKS && response)
	{
		new bdialog[170];
		switch(listitem)
		{
			case 0:
			{
				SetPVarInt(playerid, "MiscShop", 15); // small backpack
				format(bdialog, sizeof(bdialog), "Item: Small Backpack\nFood Storage: 1 Meal\nNarcotics Storage: 30 Grams\nFirearms Storage: 1 Weapon\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]),number_format(ShopItems[36][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[36][sItemPrice]));
				ShowPlayerDialogEx(playerid, DIALOG_MISCSHOP2, DIALOG_STYLE_MSGBOX, "Misc Shop", bdialog, "Purchase", "Cancel");
			}
			case 1:
			{
				SetPVarInt(playerid, "MiscShop", 16); // med backpack
				format(bdialog, sizeof(bdialog), "Item: Medium Backpack\nFood Storage: 3 Meals\nNarcotics Storage: 50 Grams\nFirearms Storage: 2 Weapons\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]),number_format(ShopItems[37][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[37][sItemPrice]));
				ShowPlayerDialogEx(playerid, DIALOG_MISCSHOP2, DIALOG_STYLE_MSGBOX, "Misc Shop", bdialog, "Purchase", "Cancel");
			}
			case 2:
			{
				SetPVarInt(playerid, "MiscShop", 17); // large backpack
				format(bdialog, sizeof(bdialog), "Item: Large Backpack\nFood Storage: 5 Meals\nNarcotics Storage: 80 Grams\nFirearms Storage: 4 Weapons\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]),number_format(ShopItems[38][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[38][sItemPrice]));
				ShowPlayerDialogEx(playerid, DIALOG_MISCSHOP2, DIALOG_STYLE_MSGBOX, "Misc Shop", bdialog, "Purchase", "Cancel");
			}
		}
	}
	if(dialogid == DIALOG_MISCSHOP2 && response)
	{
		if(GetPVarInt(playerid, "MiscShop") == 1)
		{
			if(PlayerInfo[playerid][pCredits] < ShopItems[6][sItemPrice])
				return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			else if(PlayerInfo[playerid][pTable] == 1)
				return SendClientMessageEx(playerid, COLOR_GREY, "You already own a poker table.");

			else
			{
				AmountSold[6]++;
				AmountMade[6] += ShopItems[6][sItemPrice];
				//ShopItems[6][sSold]++;
				//ShopItems[6][sMade] += ShopItems[6][sItemPrice];
				new szQuery[128];
				mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold6` = '%d', `AmountMade6` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[6], AmountMade[6]);
				mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "i", SENDDATA_THREAD);

				GivePlayerCredits(playerid, -ShopItems[6][sItemPrice], 1);
				printf("Price6: %d", 250);
				PlayerInfo[playerid][pTable] = 1;

				format(string, sizeof(string), "[SHOPMISC] [User: %s(%i)] [IP: %s] [Credits: %s] [Pokertable] [Price: %s]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[6][sItemPrice]));
				Log("logs/credits.log", string), print(string);

				format(string, sizeof(string), "You have purchased a pokertable for %s credits.", number_format(ShopItems[6][sItemPrice]));
				SendClientMessageEx(playerid, COLOR_CYAN, string);
				DeletePVar(playerid, "MiscShop");
			}
		}
		else if(GetPVarInt(playerid, "MiscShop") == 2)
		{
			if(PlayerInfo[playerid][pCredits] < ShopItems[7][sItemPrice])
				return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			else if(PlayerInfo[playerid][pBoombox] == 1)
				return SendClientMessageEx(playerid, COLOR_GREY, "You already own a boombox.");

			else
			{
				AmountSold[7]++;
				AmountMade[7] += ShopItems[7][sItemPrice];
				//ShopItems[7][sSold]++;
				//ShopItems[7][sMade] += ShopItems[7][sItemPrice];
				new szQuery[128];
				mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold7` = '%d', `AmountMade7` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[7], AmountMade[7]);
				mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "i", SENDDATA_THREAD);

				GivePlayerCredits(playerid, -ShopItems[7][sItemPrice], 1);
				printf("Price7: %d", ShopItems[7][sItemPrice]);
				PlayerInfo[playerid][pBoombox] = 1;

				format(string, sizeof(string), "[SHOPMISC] [User: %s(%i)] [IP: %s] [Credits: %s] [Boombox] [Price: %s]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[7][sItemPrice]));
				Log("logs/credits.log", string), print(string);

				format(string, sizeof(string), "You have purchased a boombox for %s credits.", number_format(ShopItems[7][sItemPrice]));
				SendClientMessageEx(playerid, COLOR_CYAN, string);
				DeletePVar(playerid, "MiscShop");
			}
		}
		else if(GetPVarInt(playerid, "MiscShop") == 3)
		{
			if(PlayerInfo[playerid][pCredits] < ShopItems[8][sItemPrice])
				return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			AmountSold[8]++;
			AmountMade[8] += ShopItems[8][sItemPrice];
			//ShopItems[8][sSold]++;
			//ShopItems[8][sMade] += ShopItems[8][sItemPrice];
			new szQuery[128];
			mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold8` = '%d', `AmountMade8` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[8], AmountMade[8]);
			mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "i", SENDDATA_THREAD);

			GivePlayerCredits(playerid, -ShopItems[8][sItemPrice], 1);
			printf("Price8: %d", ShopItems[8][sItemPrice]);
			PlayerInfo[playerid][pPaintTokens] += 100;

			format(string, sizeof(string), "[SHOPMISC] [User: %s(%i)] [IP: %s] [Credits: %s] [100 Paintball Tokens] [Price: %s]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[8][sItemPrice]));
			Log("logs/credits.log", string), print(string);

			format(string, sizeof(string), "You have purchased 100 paintball tokens for %s credits.", number_format(ShopItems[8][sItemPrice]));
			SendClientMessageEx(playerid, COLOR_CYAN, string);
			DeletePVar(playerid, "MiscShop");
		}
		else if(GetPVarInt(playerid, "MiscShop") == 4)
		{
			if(PlayerInfo[playerid][pCredits] < ShopItems[9][sItemPrice])
				return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			AmountSold[9]++;
			AmountMade[9] += ShopItems[9][sItemPrice];
			//ShopItems[9][sSold]++;
			//ShopItems[9][sMade] += ShopItems[9][sItemPrice];
			new szQuery[128];
			mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold9` = '%d', `AmountMade9` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[9], AmountMade[9]);
			mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "i", SENDDATA_THREAD);

			GivePlayerCredits(playerid, -ShopItems[9][sItemPrice], 1);
			printf("Price9: %d", ShopItems[9][sItemPrice]);
			PlayerInfo[playerid][pEXPToken] += 1;

			format(string, sizeof(string), "[SHOPMISC] [User: %s(%i)] [IP: %s] [Credits: %s] [EXP Token] [Price: %s]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[9][sItemPrice]));
			Log("logs/credits.log", string), print(string);

			format(string, sizeof(string), "You have purchased a EXP Token for %s credits.", number_format(ShopItems[9][sItemPrice]));
			SendClientMessageEx(playerid, COLOR_CYAN, string);
			DeletePVar(playerid, "MiscShop");
		}
		else if(GetPVarInt(playerid, "MiscShop") == 5)
		{
			if(PlayerInfo[playerid][pCredits] < ShopItems[10][sItemPrice])
				return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			AmountSold[10]++;
			AmountMade[10] += ShopItems[10][sItemPrice];
			//ShopItems[10][sSold]++;
			//ShopItems[10][sMade] += ShopItems[10][sItemPrice];
			new szQuery[128];
			mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold10` = '%d', `AmountMade10` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[10], AmountMade[10]);
			mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "i", SENDDATA_THREAD);

			GivePlayerCredits(playerid, -ShopItems[10][sItemPrice], 1);
			printf("Price10: %d", ShopItems[10][sItemPrice]);
			PlayerInfo[playerid][pFirework] += 5;

			format(string, sizeof(string), "[SHOPMISC] [User: %s(%i)] [IP: %s] [Credits: %s] [Firework X5] [Price: %s]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[10][sItemPrice]));
			Log("logs/credits.log", string), print(string);

			format(string, sizeof(string), "You have purchased 5 fireworks for %s credits.", number_format(ShopItems[10][sItemPrice]));
			SendClientMessageEx(playerid, COLOR_CYAN, string);
			DeletePVar(playerid, "MiscShop");
		}
		else if(GetPVarInt(playerid, "MiscShop") == 6)
		{
			if(PlayerInfo[playerid][pCredits] < ShopItems[22][sItemPrice])
				return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			GivePlayerCredits(playerid, -ShopItems[22][sItemPrice], 1);
			printf("Price22: %d", ShopItems[22][sItemPrice]);

			AmountSold[22]++;
			AmountMade[22] += ShopItems[22][sItemPrice];
			//ShopItems[22][sSold]++;
			//ShopItems[22][sMade] += ShopItems[22][sItemPrice];
			new szQuery[128];
			mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold22` = '%d', `AmountMade22` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[22], AmountMade[22]);
			mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "i", SENDDATA_THREAD);

			AddFlag(playerid, INVALID_PLAYER_ID, "Purchased Custom License Plate (Credits)");
			SendReportToQue(playerid, "Custom License Plate (Credits)", 2, 2);
			format(string, sizeof(string), "You have purchased a custom license plate for %s credits.", number_format(ShopItems[22][sItemPrice]));
			SendClientMessageEx(playerid, COLOR_CYAN, string);
			SendClientMessageEx(playerid, COLOR_CYAN, "Contact a senior admin to have the custom license plate issued.");

			format(string, sizeof(string), "[Custom License Plate] [User: %s(%i)] [IP: %s] [Credits: %s] [Price: %s]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[22][sItemPrice]));
			Log("logs/credits.log", string), print(string);
		}
		else if(GetPVarInt(playerid, "MiscShop") == 7) // Vehicle Slots
		{
			if(PlayerInfo[playerid][pCredits] < ShopItems[23][sItemPrice])
				return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			GivePlayerCredits(playerid, -ShopItems[23][sItemPrice], 1);
			printf("Price23: %d", ShopItems[23][sItemPrice]);

			AmountSold[23]++;
			AmountMade[23] += ShopItems[23][sItemPrice];


			new szQuery[128];
			mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold23` = '%d', `AmountMade23` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[23], AmountMade[23]);
			mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "i", SENDDATA_THREAD);

			format(string, sizeof(string), "You have purchased a additional vehicle slot for %s credits.", number_format(ShopItems[23][sItemPrice]));
			SendClientMessageEx(playerid, COLOR_CYAN, string);
			PlayerInfo[playerid][pVehicleSlot] += 1;
			LoadPlayerDisabledVehicles(playerid);

			format(string, sizeof(string), "[Additional Vehicle Slot] [User: %s(%i)] [IP: %s] [Credits: %s] [Price: %s]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[23][sItemPrice]));
			Log("logs/credits.log", string), print(string);
		}
		else if(GetPVarInt(playerid, "MiscShop") == 8) // Toy Slots
		{
			if(PlayerInfo[playerid][pCredits] < ShopItems[28][sItemPrice])
				return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			GivePlayerCredits(playerid, -ShopItems[28][sItemPrice], 1);
			printf("Price28: %d", ShopItems[28][sItemPrice]);

			AmountSold[28]++;
			AmountMade[28] += ShopItems[28][sItemPrice];


			new szQuery[128];
			mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold28` = '%d', `AmountMade28` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[28], AmountMade[28]);
			mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "i", SENDDATA_THREAD);

			format(string, sizeof(string), "You have purchased a additional toy slot for %s credits.", number_format(ShopItems[28][sItemPrice]));
			SendClientMessageEx(playerid, COLOR_CYAN, string);
			PlayerInfo[playerid][pToySlot] += 1;
			LoadPlayerDisabledVehicles(playerid);

			format(string, sizeof(string), "[Additional Toy Slot] [User: %s(%i)] [IP: %s] [Credits: %s] [Price: %s]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[28][sItemPrice]));
			Log("logs/credits.log", string), print(string);
		}
		else if(GetPVarInt(playerid, "MiscShop") == 9) // Spawn at Gold VIP+ room
		{
			if(PlayerInfo[playerid][pCredits] < ShopItems[30][sItemPrice])
				return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			GivePlayerCredits(playerid, -ShopItems[30][sItemPrice], 1);
			printf("Price30: %d", ShopItems[30][sItemPrice]);

			AmountSold[30]++;
			AmountMade[30] += ShopItems[30][sItemPrice];


			new szQuery[128];
			mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold30` = '%d', `AmountMade30` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[30], AmountMade[30]);
			mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "i", SENDDATA_THREAD);

			format(string, sizeof(string), "You have purchased a spawn at the Gold VIP+ room, you will be able to use it after your next death.", number_format(ShopItems[30][sItemPrice]));
			SendClientMessageEx(playerid, COLOR_CYAN, string);

			PlayerInfo[playerid][pVIPSpawn] = 1;
			OnPlayerStatsUpdate(playerid);

			format(string, sizeof(string), "[Spawn at Gold VIP+ room] [User: %s(%i)] [IP: %s] [Credits: %s] [Price: %s]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[30][sItemPrice]));
			Log("logs/credits.log", string), print(string);
		}
		else if(GetPVarInt(playerid, "MiscShop") == 10) // Restricted Last Name (NEW)
		{
			if(PlayerInfo[playerid][pCredits] < ShopItems[31][sItemPrice])
				return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			GivePlayerCredits(playerid, -ShopItems[31][sItemPrice], 1);
			printf("Price31: %d", ShopItems[31][sItemPrice]);

			AmountSold[31]++;
			AmountMade[31] += ShopItems[31][sItemPrice];

			new szQuery[128];
			mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold31` = '%d', `AmountMade31` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[31], AmountMade[31]);
			mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "i", SENDDATA_THREAD);

			AddFlag(playerid, INVALID_PLAYER_ID, "Purchased Restricted Last Name (NEW) (Credits)");
			format(string, sizeof(string), "You have purchased a Restricted Last Name (NEW) for %s credits.", number_format(ShopItems[31][sItemPrice]));
			SendClientMessageEx(playerid, COLOR_CYAN, string);
			SendClientMessageEx(playerid, COLOR_GREY, "Contact a member of Customer Relations to have the Restricted Last Name (NEW) issued.");

			format(string, sizeof(string), "[Restricted Last Name (NEW)] [User: %s(%i)] [IP: %s] [Credits: %s] [Price: %s]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[31][sItemPrice]));
			Log("logs/credits.log", string), print(string);
		}
		else if(GetPVarInt(playerid, "MiscShop") == 11) // Restricted Last Name (CHANGE)
		{
			if(PlayerInfo[playerid][pCredits] < ShopItems[32][sItemPrice])
				return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			GivePlayerCredits(playerid, -ShopItems[32][sItemPrice], 1);
			printf("Price32: %d", ShopItems[32][sItemPrice]);

			AmountSold[32]++;
			AmountMade[32] += ShopItems[32][sItemPrice];

			new szQuery[128];
			mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold32` = '%d', `AmountMade32` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[32], AmountMade[32]);
			mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "i", SENDDATA_THREAD);

			AddFlag(playerid, INVALID_PLAYER_ID, "Purchased Restricted Last Name (CHANGE) (Credits)");
			format(string, sizeof(string), "You have purchased a Restricted Last Name (CHANGE) for %s credits.", number_format(ShopItems[32][sItemPrice]));
			SendClientMessageEx(playerid, COLOR_CYAN, string);
			SendClientMessageEx(playerid, COLOR_GREY, "Contact a member of Customer Relations to have the Restricted Last Name (CHANGED) issued.");

			format(string, sizeof(string), "[Restricted Last Name (CHANGE)] [User: %s(%i)] [IP: %s] [Credits: %s] [Price: %s]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[32][sItemPrice]));
			Log("logs/credits.log", string), print(string);
		}
		else if(GetPVarInt(playerid, "MiscShop") == 12) // Custom User Title (NEW)
		{
			if(PlayerInfo[playerid][pCredits] < ShopItems[33][sItemPrice])
				return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			GivePlayerCredits(playerid, -ShopItems[33][sItemPrice], 1);
			printf("Price33: %d", ShopItems[33][sItemPrice]);

			AmountSold[33]++;
			AmountMade[33] += ShopItems[33][sItemPrice];

			new szQuery[128];
			mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold33` = '%d', `AmountMade33` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[33], AmountMade[33]);
			mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "i", SENDDATA_THREAD);

			AddFlag(playerid, INVALID_PLAYER_ID, "Purchased Custom User Title (NEW) (Credits)");
			format(string, sizeof(string), "You have purchased a Custom User Title (NEW) for %s credits.", number_format(ShopItems[33][sItemPrice]));
			SendClientMessageEx(playerid, COLOR_CYAN, string);
			SendClientMessageEx(playerid, COLOR_GREY, "Contact a member of Customer Relations to have the Custom User Title (NEW) issued.");

			format(string, sizeof(string), "[Custom User Title (NEW)] [User: %s(%i)] [IP: %s] [Credits: %s] [Price: %s]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[33][sItemPrice]));
			Log("logs/credits.log", string), print(string);
		}
		else if(GetPVarInt(playerid, "MiscShop") == 13) // Custom User Title (CHANGE)
		{
			if(PlayerInfo[playerid][pCredits] < ShopItems[34][sItemPrice])
				return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			GivePlayerCredits(playerid, -ShopItems[34][sItemPrice], 1);
			printf("Price34: %d", ShopItems[34][sItemPrice]);

			AmountSold[34]++;
			AmountMade[34] += ShopItems[34][sItemPrice];

			new szQuery[128];
			mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold34` = '%d', `AmountMade34` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[34], AmountMade[34]);
			mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "i", SENDDATA_THREAD);

			AddFlag(playerid, INVALID_PLAYER_ID, "Purchased Custom User Title (CHANGE) (Credits)");
			format(string, sizeof(string), "You have purchased a Restricted Custom User Title (CHANGE) for %s credits.", number_format(ShopItems[34][sItemPrice]));
			SendClientMessageEx(playerid, COLOR_CYAN, string);
			SendClientMessageEx(playerid, COLOR_GREY, "Contact a member of Customer Relations to have the Custom User Title (CHANGE) issued.");

			format(string, sizeof(string), "[Custom User Title (CHANGE)] [User: %s(%i)] [IP: %s] [Credits: %s] [Price: %s]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[34][sItemPrice]));
			Log("logs/credits.log", string), print(string);
		}
		else if(GetPVarInt(playerid, "MiscShop") == 14) // Teamspeak User Channel
		{
			if(PlayerInfo[playerid][pCredits] < ShopItems[35][sItemPrice])
				return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			GivePlayerCredits(playerid, -ShopItems[35][sItemPrice], 1);
			printf("Price35: %d", ShopItems[35][sItemPrice]);

			AmountSold[35]++;
			AmountMade[35] += ShopItems[35][sItemPrice];

			new szQuery[128];
			mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold35` = '%d', `AmountMade35` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[35], AmountMade[35]);
			mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "i", SENDDATA_THREAD);

			AddFlag(playerid, INVALID_PLAYER_ID, "Purchased Teamspeak User Channel (Credits)");
			format(string, sizeof(string), "You have purchased a Teamspeak User Channel for %s credits.", number_format(ShopItems[35][sItemPrice]));
			SendClientMessageEx(playerid, COLOR_CYAN, string);
			SendClientMessageEx(playerid, COLOR_GREY, "Contact a member of Customer Relations to have the Teamspeak User Channel issued.");

			format(string, sizeof(string), "[Teamspeak User Channel] [User: %s(%i)] [IP: %s] [Credits: %s] [Price: %s]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[35][sItemPrice]));
			Log("logs/credits.log", string), print(string);
		}
		else if(GetPVarInt(playerid, "MiscShop") == 15) // Small Backpack
		{
			if(PlayerInfo[playerid][pBackpack] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can only purchase one backpack at a time, use /sellbackpack.");
			if(PlayerInfo[playerid][pCredits] < ShopItems[36][sItemPrice])
				return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			GivePlayerCredits(playerid, -ShopItems[36][sItemPrice], 1);
			printf("Price35: %d", ShopItems[36][sItemPrice]);

			AmountSold[36]++;
			AmountMade[36] += ShopItems[36][sItemPrice];

			new szQuery[128];
			mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold36` = '%d', `AmountMade36` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[36], AmountMade[36]);
			mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "i", SENDDATA_THREAD);
			if(PlayerHoldingObject[playerid][9] != 0 || IsPlayerAttachedObjectSlotUsed(playerid, 9))
				RemovePlayerAttachedObject(playerid, 9), PlayerHoldingObject[playerid][9] = 0;
			SetPlayerAttachedObject(playerid, 9, 371, 1, -0.002, -0.140999, -0.01, 8.69999, 88.8, -8.79993, 1.11, 0.963);

			PlayerInfo[playerid][pBEquipped] = 1;
			PlayerInfo[playerid][pBStoredV] = INVALID_PLAYER_VEHICLE_ID;
			PlayerInfo[playerid][pBStoredH] = INVALID_HOUSE_ID;

			PlayerInfo[playerid][pBackpack] = 1;
			format(string, sizeof(string), "You have purchased a Small Backpack for %s credits.", number_format(ShopItems[36][sItemPrice]));
			SendClientMessageEx(playerid, COLOR_CYAN, string);
			SendClientMessageEx(playerid, COLOR_GREY, "Use /backpackhelp to see the list of commands.");

			format(string, sizeof(string), "[Small Backpack] [User: %s(%i)] [IP: %s] [Credits: %s] [Price: %s]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[36][sItemPrice]));
			Log("logs/credits.log", string), print(string);
		}
		else if(GetPVarInt(playerid, "MiscShop") == 16) // Medium Backpack
		{
			if(PlayerInfo[playerid][pBackpack] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can only purchase one backpack at a time, use /sellbackpack.");
			if(PlayerInfo[playerid][pCredits] < ShopItems[37][sItemPrice])
				return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			GivePlayerCredits(playerid, -ShopItems[37][sItemPrice], 1);
			printf("Price35: %d", ShopItems[37][sItemPrice]);

			AmountSold[37]++;
			AmountMade[37] += ShopItems[37][sItemPrice];

			new szQuery[128];
			mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold37` = '%d', `AmountMade37` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[37], AmountMade[37]);
			mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "i", SENDDATA_THREAD);
			if(PlayerHoldingObject[playerid][9] != 0 || IsPlayerAttachedObjectSlotUsed(playerid, 9))
				RemovePlayerAttachedObject(playerid, 9), PlayerHoldingObject[playerid][9] = 0;
			SetPlayerAttachedObject(playerid, 9, 371, 1, -0.002, -0.140999, -0.01, 8.69999, 88.8, -8.79993, 1.11, 0.963);

			PlayerInfo[playerid][pBEquipped] = 1;
			PlayerInfo[playerid][pBStoredV] = INVALID_PLAYER_VEHICLE_ID;
			PlayerInfo[playerid][pBStoredH] = INVALID_HOUSE_ID;

			PlayerInfo[playerid][pBackpack] = 2;
			format(string, sizeof(string), "You have purchased a Medium Backpack for %s credits.", number_format(ShopItems[37][sItemPrice]));
			SendClientMessageEx(playerid, COLOR_CYAN, string);
			SendClientMessageEx(playerid, COLOR_GREY, "Use /backpackhelp to see the list of commands.");

			format(string, sizeof(string), "[Medium Backpack] [User: %s(%i)] [IP: %s] [Credits: %s] [Price: %s]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[37][sItemPrice]));
			Log("logs/credits.log", string), print(string);
		}
		else if(GetPVarInt(playerid, "MiscShop") == 17) // Large Backpack
		{
			if(PlayerInfo[playerid][pBackpack] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can only purchase one backpack at a time, use /sellbackpack.");
			if(PlayerInfo[playerid][pCredits] < ShopItems[38][sItemPrice])
				return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			GivePlayerCredits(playerid, -ShopItems[38][sItemPrice], 1);
			printf("Price35: %d", ShopItems[38][sItemPrice]);

			AmountSold[38]++;
			AmountMade[38] += ShopItems[38][sItemPrice];

			new szQuery[128];
			mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold38` = '%d', `AmountMade38` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[38], AmountMade[38]);
			mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "i", SENDDATA_THREAD);
			if(PlayerHoldingObject[playerid][9] != 0 || IsPlayerAttachedObjectSlotUsed(playerid, 9))
				RemovePlayerAttachedObject(playerid, 9), PlayerHoldingObject[playerid][9] = 0;
			SetPlayerAttachedObject(playerid, 9, 3026, 1, -0.254999, -0.109, -0.022999, 10.6, -1.20002, 3.4, 1.265, 1.242, 1.062);

			PlayerInfo[playerid][pBEquipped] = 1;
			PlayerInfo[playerid][pBStoredV] = INVALID_PLAYER_VEHICLE_ID;
			PlayerInfo[playerid][pBStoredH] = INVALID_HOUSE_ID;

			PlayerInfo[playerid][pBackpack] = 3;
			format(string, sizeof(string), "You have purchased a Large Backpack for %s credits.", number_format(ShopItems[38][sItemPrice]));
			SendClientMessageEx(playerid, COLOR_CYAN, string);
			SendClientMessageEx(playerid, COLOR_GREY, "Use /backpackhelp to see the list of commands.");

			format(string, sizeof(string), "[Large Backpack] [User: %s(%i)] [IP: %s] [Credits: %s] [Price: %s]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[38][sItemPrice]));
			Log("logs/credits.log", string), print(string);
		}
		else if(GetPVarInt(playerid, "MiscShop") == 18) // Deluxe Car Alarm
		{
			if(PlayerInfo[playerid][pCredits] < ShopItems[39][sItemPrice])
				return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			if(GetPlayerVehicleCount(playerid) != 0)
			{
				SetPVarInt(playerid, "lockmenu", 4);
				for(new i=0; i<MAX_PLAYERVEHICLES; i++)
				{
					if(PlayerVehicleInfo[playerid][i][pvId] != INVALID_PLAYER_VEHICLE_ID)
					{
						format(string, sizeof(string), "Vehicle %d | Name: %s.",i+1,GetVehicleName(PlayerVehicleInfo[playerid][i][pvId]));
						SendClientMessageEx(playerid, COLOR_WHITE, string);
					}
				}
				return ShowPlayerDialogEx(playerid, DIALOG_CDLOCKMENU, DIALOG_STYLE_INPUT, "24-7;"," Select a vehicle you wish to install this on:", "Select", "Cancel");
			}
			else return SendClientMessageEx(playerid, COLOR_WHITE, "You don't have any cars - where we can install this item?");
		}
		else if(GetPVarInt(playerid, "MiscShop") == 19) // Furniture Bronze
		{
			if(PlayerInfo[playerid][pCredits] < ShopItems[41][sItemPrice])
				return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			if(PlayerInfo[playerid][pFurnitureSlots] >= MAX_FURNITURE_SLOTS) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot buy anymore furniture slots.");
			PlayerInfo[playerid][pFurnitureSlots] += 25;
			if(PlayerInfo[playerid][pFurnitureSlots] > MAX_FURNITURE_SLOTS) {
				PlayerInfo[playerid][pFurnitureSlots] = MAX_FURNITURE_SLOTS;
				SendClientMessageEx(playerid, COLOR_GRAD1, "Your furniture slots have been maximized.");
			}
			format(szMiscArray, sizeof(szMiscArray), "You have purchased a Furniture Pack - Bronze for %s credits.", number_format(ShopItems[41][sItemPrice]));
			SendClientMessageEx(playerid, COLOR_CYAN, szMiscArray);
			SendClientMessageEx(playerid, COLOR_GREY, "Use /furniturehelp to see the list of commands.");

			format(szMiscArray, sizeof(szMiscArray), "[Furniture Pack - Bronze] [User: %s(%i)] [IP: %s] [Credits: %s] [Price: %s]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[41][sItemPrice]));
			Log("logs/credits.log", szMiscArray), print(szMiscArray);

			GivePlayerCredits(playerid, -ShopItems[41][sItemPrice], 1);
			printf("Price43: %d", ShopItems[41][sItemPrice]);

			AmountSold[41]++;
			AmountMade[41] += ShopItems[41][sItemPrice];

			mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "UPDATE `sales` SET `TotalSold41` = '%d', `AmountMade41` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[41], AmountMade[41]);
			mysql_tquery(MainPipeline, szMiscArray, "OnQueryFinish", "i", SENDDATA_THREAD);
		}
		else if(GetPVarInt(playerid, "MiscShop") == 20) // Furniture Bronze
		{
			if(PlayerInfo[playerid][pCredits] < ShopItems[42][sItemPrice])
				return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			if(PlayerInfo[playerid][pFurnitureSlots] >= MAX_FURNITURE_SLOTS) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot buy anymore furniture slots.");
			PlayerInfo[playerid][pFurnitureSlots] += 40;
			if(PlayerInfo[playerid][pFurnitureSlots] > MAX_FURNITURE_SLOTS) {
				PlayerInfo[playerid][pFurnitureSlots] = MAX_FURNITURE_SLOTS;
				SendClientMessageEx(playerid, COLOR_GRAD1, "Your furniture slots have been maximized.");
			}
			format(szMiscArray, sizeof(szMiscArray), "You have purchased a Furniture Pack - Silver for %s credits.", number_format(ShopItems[42][sItemPrice]));
			SendClientMessageEx(playerid, COLOR_CYAN, szMiscArray);
			SendClientMessageEx(playerid, COLOR_GREY, "Use /furniturehelp to see the list of commands.");

			format(szMiscArray, sizeof(szMiscArray), "[Furniture Pack - Silver] [User: %s(%i)] [IP: %s] [Credits: %s] [Price: %s]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[42][sItemPrice]));
			Log("logs/credits.log", szMiscArray), print(szMiscArray);

			GivePlayerCredits(playerid, -ShopItems[42][sItemPrice], 1);
			printf("Price43: %d", ShopItems[42][sItemPrice]);

			AmountSold[42]++;
			AmountMade[42] += ShopItems[42][sItemPrice];

			mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "UPDATE `sales` SET `TotalSold42` = '%d', `AmountMade42` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[42], AmountMade[42]);
			mysql_tquery(MainPipeline, szMiscArray, "OnQueryFinish", "i", SENDDATA_THREAD);
		}
		else if(GetPVarInt(playerid, "MiscShop") == 21) // Furniture Gold
		{
			if(PlayerInfo[playerid][pCredits] < ShopItems[43][sItemPrice])
				return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			if(PlayerInfo[playerid][pFurnitureSlots] >= MAX_FURNITURE_SLOTS) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot buy anymore furniture slots.");
			PlayerInfo[playerid][pFurnitureSlots] += 50;
			if(PlayerInfo[playerid][pFurnitureSlots] > MAX_FURNITURE_SLOTS) {
				PlayerInfo[playerid][pFurnitureSlots] = MAX_FURNITURE_SLOTS;
				SendClientMessageEx(playerid, COLOR_GRAD1, "Your furniture slots have been maximized.");
			}
			format(szMiscArray, sizeof(szMiscArray), "You have purchased a Furniture Pack - Gold for %s credits.", number_format(ShopItems[43][sItemPrice]));
			SendClientMessageEx(playerid, COLOR_CYAN, szMiscArray);
			SendClientMessageEx(playerid, COLOR_GREY, "Use /furniturehelp to see the list of commands.");

			format(szMiscArray, sizeof(szMiscArray), "[Furniture Pack] [User: %s(%i)] [IP: %s] [Credits: %s] [Price: %s]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[43][sItemPrice]));
			Log("logs/credits.log", szMiscArray), print(szMiscArray);

			GivePlayerCredits(playerid, -ShopItems[43][sItemPrice], 1);
			printf("Price43: %d", ShopItems[43][sItemPrice]);

			AmountSold[43]++;
			AmountMade[43] += ShopItems[43][sItemPrice];

			mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "UPDATE `sales` SET `TotalSold43` = '%d', `AmountMade43` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[43], AmountMade[43]);
			mysql_tquery(MainPipeline, szMiscArray, "OnQueryFinish", "i", SENDDATA_THREAD);
		}
	    DeletePVar(playerid, "MiscShop");
	}
	if(dialogid == DIALOG_SHOPHELPMENU)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: //VIP Shop
				{
					SetPVarInt(playerid, "ShopCheckpoint", listitem+1);
					ShowPlayerDialogEx(playerid, DIALOG_SHOPHELPMENU8, DIALOG_STYLE_MSGBOX, "VIP Shop", "To purchase Bronze VIP, Silver VIP or Gold VIP you use /vipshop at one of the VIP points located outside each VIP Club.\n You can renew your Gold VIP by using /vipshop however you need to make sure that you have renewable Gold VIP.\n You can read the benefits of VIP on the Shop Control Panel or listed within /vipshop.", "Checkpoint", "Exit");
				}
				case 1:
				{
					ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "House Shop", "To purchase a house, change your house interior, or buy a house move from the shop, you can use /houseshop anywhere. \nYou can read more information regarding houses on the Shop Control Panel.", "Exit", "");
				}
				case 2:
				{
					ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Business Shop", "Want to buy a business or renew your current one? Use the command /businessshop and this will allow you to purchase a business or renew your current one.\n It is important that you read the business rules on the forums and read more about businesses on the Shop Control Panel. Note: The Purchase Business will list the available businesses for sale at that time.", "Exit", "");
				}
				case 3:
				{
					ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Toy Shop", "To purchase a custom toy use /toyshop at a clothing shop. This allows you to see the selection of toys available and purchase one by simply clicking on it!\n After purchasing the toy will be put in your toy slot.", "Exit", "");
				}
				case 4:
				{
					ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Miscellaneous Shop", "To buy miscellaneous products such as poker tables and EXP tokens, visit any 24/7 business and use the /miscshop command.\n This will pop-up all the available miscellaneous products that are for sale. Keep an eye out as there are always new additions!", "Exit", "");
				}
				case 5:
				{
					ShowPlayerDialogEx(playerid, DIALOG_SHOPHELPMENU2, DIALOG_STYLE_MSGBOX, "Car Shop", "To purchase a custom car, you can use /carshop at locations from shipping docks and other locations.\n Using /carshop allows you to see the selection of cars available and purchase one by simply clicking on it!\n The car will be put into your car slot after you purchase.", "Checkpoint", "Exit");
				}
				case 6:
				{
					ShowPlayerDialogEx(playerid, DIALOG_SHOPHELPMENU3, DIALOG_STYLE_MSGBOX, "Plane Shop", "To purchase a custom car, you can use /carshop at locations from shipping docks and other locations.\n Using /carshop allows you to see the selection of cars available and purchase one by simply clicking on it!\n The car will be put into your car slot after you purchase.", "Checkpoint", "Exit");
				}
				case 7:
				{
					ShowPlayerDialogEx(playerid, DIALOG_SHOPHELPMENU5, DIALOG_STYLE_MSGBOX, "Boat Shop", "To purchase a custom car, you can use /carshop at locations from shipping docks and other locations.\n Using /carshop allows you to see the selection of cars available and purchase one by simply clicking on it!\n The car will be put into your car slot after you purchase.", "Checkpoint", "Exit");
				}
			}
		}
	}
	if(dialogid == DIALOG_SHOPHELPMENU8)
	{
		if(response)
		{
			 ShowPlayerDialogEx(playerid, DIALOG_SHOPHELPMENU9, DIALOG_STYLE_LIST, "Boat Shop Locater", "Los Santos\nSan Fierro\nLas Venturas", "Locate", "Cancel");
		}
	}
	if(dialogid == DIALOG_SHOPHELPMENU9)
	{
		if(response)
		{
			if(CheckPointCheck(playerid))
				return SendClientMessageEx(playerid, COLOR_WHITE, "Please ensure that your current checkpoint is destroyed first (you either have material packages, or another existing checkpoint).");

			SetPVarInt(playerid, "ShopCheckpoint", 1);
			switch(listitem)
			{
				case 0: SetPlayerCheckpoint(playerid, 1811.3344, -1569.4244, 13.4811, 5.0);
				case 1: SetPlayerCheckpoint(playerid, -2443.6013, 499.7480, 30.0906, 5.0);
				case 2: SetPlayerCheckpoint(playerid,  1934.1083, 1364.5004, 9.2578, 5.0);
			}
		}
	}
	if(dialogid == DIALOG_SHOPHELPMENU5)
	{
		if(response)
		{
			 ShowPlayerDialogEx(playerid, DIALOG_SHOPHELPMENU6, DIALOG_STYLE_LIST, "Boat Shop Locater", "Los Santos\nSan Fierro\nBayside", "Locate", "Cancel");
		}
	}
	if(dialogid == DIALOG_SHOPHELPMENU6)
	{
		if(response)
		{
			if(CheckPointCheck(playerid))
				return SendClientMessageEx(playerid, COLOR_WHITE, "Please ensure that your current checkpoint is destroyed first (you either have material packages, or another existing checkpoint).");

			SetPVarInt(playerid, "ShopCheckpoint", 1);
			switch(listitem)
			{
				case 0: SetPlayerCheckpoint(playerid, 723.1553, -1494.4547, 1.9343, 5.0);
				case 1: SetPlayerCheckpoint(playerid, -2975.8950, 505.1325, 2.4297, 5.0);
				case 2: SetPlayerCheckpoint(playerid, -2214.1636, 2422.4763, 2.496, 5.0);
			}
		}
	}
	if(dialogid == DIALOG_SHOPHELPMENU3)
	{
		if(response)
		{
			 ShowPlayerDialogEx(playerid, DIALOG_SHOPHELPMENU4, DIALOG_STYLE_LIST, "Plane Shop Locater", "Los Santos Airport\nLas Venturas Airport", "Locate", "Cancel");
		}
	}
	if(dialogid == DIALOG_SHOPHELPMENU4)
	{
		if(response)
		{
			if(CheckPointCheck(playerid))
				return SendClientMessageEx(playerid, COLOR_WHITE, "Please ensure that your current checkpoint is destroyed first (you either have material packages, or another existing checkpoint).");

			SetPVarInt(playerid, "ShopCheckpoint", 1);
			switch(listitem)
			{
				case 0: SetPlayerCheckpoint(playerid, 1891.9105, -2279.6174, 13.5469, 5.0);
				case 1: SetPlayerCheckpoint(playerid, 1632.0836, 1551.7365, 10.8061, 5.0);
			}
		}
	}
	if(dialogid == DIALOG_SHOPHELPMENU2)
	{
		if(response)
		{
			ShowPlayerDialogEx(playerid, DIALOG_SHOPHELPMENU7, DIALOG_STYLE_LIST, "Car Shop Locater", "Los Santos\nSan Fierro\nLas Venturas", "Locate", "Cancel");
		}
	}
	if(dialogid == DIALOG_SHOPHELPMENU7)
	{
		if(response)
		{
			if(CheckPointCheck(playerid))
				return SendClientMessageEx(playerid, COLOR_WHITE, "Please ensure that your current checkpoint is destroyed first (you either have material packages, or another existing checkpoint).");

			SetPVarInt(playerid, "ShopCheckpoint", 1);
			switch(listitem)
			{
				case 0: SetPlayerCheckpoint(playerid, 2280.5720, -2325.2490, 13.5469, 5.0);
				case 1: SetPlayerCheckpoint(playerid, -1731.1923, 127.4794, 3.2976, 5.0);
				case 2: SetPlayerCheckpoint(playerid, 1663.9569, 1628.5106, 10.8203, 5.0);
			}
		}
	}
	if(dialogid == DIALOG_RENTACAR)
	{
		if(response)
		{
			if(PlayerInfo[playerid][pCredits] < ShopItems[20][sItemPrice])
				return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			new
				szQuery[215];

			AmountSold[20]++;
			AmountMade[20] += ShopItems[20][sItemPrice];

			//ShopItems[20][sSold]++;
			//ShopItems[20][sMade] += ShopItems[20][sItemPrice];

			mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold20` = '%d', `AmountMade20` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[20], AmountMade[20]);
			mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "i", SENDDATA_THREAD);

			if(IsPlayerInRangeOfPoint(playerid, 4, 1102.8999, -1440.1669, 15.7969))
			{
				mysql_format(MainPipeline, szQuery, sizeof(szQuery), "INSERT INTO `rentedcars` (`sqlid`, `modelid`, `posx`, `posy`, `posz`, `posa`, `spawned`, `hours`) VALUES ('%d', '%d', '%f', '%f', '%f', '%f', '1', '180')", GetPlayerSQLId(playerid), GetPVarInt(playerid, "VehicleID"), 1060.4927,-1474.9323,13.1905,345.2816);
				mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "i", SENDDATA_THREAD);

				SetPVarInt(playerid, "RentedVehicle", CreateVehicle(GetPVarInt(playerid, "VehicleID"), 1060.4927, -1474.9323, 13.1905, 345.2816, random(128), random(128), 2000000));
			}
			else if(IsPlayerInRangeOfPoint(playerid, 4, 1796.0620, -1588.5571, 13.4951))
			{
				mysql_format(MainPipeline, szQuery, sizeof(szQuery), "INSERT INTO `rentedcars` (`sqlid`, `modelid`, `posx`, `posy`, `posz`, `posa`, `spawned`, `hours`) VALUES ('%d', '%d', '%f', '%f', '%f', '%f', '1', '180')", GetPlayerSQLId(playerid), GetPVarInt(playerid, "VehicleID"), 1787.6924, -1605.8617,13.1750, 76.7439);
				mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "i", SENDDATA_THREAD);

				SetPVarInt(playerid, "RentedVehicle", CreateVehicle(GetPVarInt(playerid, "VehicleID"), 1787.6924, -1605.8617, 13.1750, 76.7439, random(128), random(128), 2000000));
			}

			GivePlayerCredits(playerid, -ShopItems[20][sItemPrice], 1);
			printf("Price20: %d", ShopItems[20][sItemPrice]);
			IsPlayerEntering{playerid} = true;
			PutPlayerInVehicle(playerid, GetPVarInt(playerid, "RentedVehicle"), 0);

			format(szQuery, sizeof(szQuery), "[RentaCar] [User: %s(%i)] [IP: %s] [Model: %d] [Credits: %s] [Price: %s]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), GetPVarInt(playerid, "VehicleID"), number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[20][sItemPrice]));
			Log("logs/credits.log", szQuery), print(szQuery);

			format(szQuery, sizeof(szQuery), "[Rent a Car] You have rented a %s for %s credits, the vehicle will last 3 hours.", VehicleName[GetPVarInt(playerid, "VehicleID") - 400], number_format(ShopItems[20][sItemPrice]));
			SendClientMessageEx(playerid, COLOR_CYAN, szQuery);
			SendClientMessageEx(playerid, COLOR_CYAN, "Commands Available: /park, /stoprentacar, /trackcar");

			SetPVarInt(playerid, "RentedHours", 180);
			VehicleFuel[GetPVarInt(playerid, "RentedVehicle")] = 100;
		}
		DeletePVar(playerid, "VehicleID");
	}
	if(dialogid == DIALOG_CARSHOP)
	{
		if(response)
		{
			if(PlayerInfo[playerid][pCredits] < ShopItems[5][sItemPrice])
				return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			else if(!vehicleCountCheck(playerid))
				return ShowPlayerDialogEx(playerid, 0, DIALOG_STYLE_MSGBOX, "Error", "You can't have any more vehicles, you own too many!", "OK", "");

			else if(!vehicleSpawnCountCheck(playerid))
				return ShowPlayerDialogEx(playerid, 0, DIALOG_STYLE_MSGBOX, "Error", "You have too many vehicles spawned, you must store one first.", "OK", "");

			else
			{
				if(GetPVarType(playerid, "BoatShop"))
				{
					new createdcar;
					if(IsPlayerInRangeOfPoint(playerid, 4, -2214.1636, 2422.4763, 2.4961))
					{
						createdcar = CreatePlayerVehicle(playerid, GetPlayerFreeVehicleId(playerid), GetPVarInt(playerid, "VehicleID"), -2218.4795, 2424.9880, -0.3707, 314.4837, 0, 0, 2000000, 0, 0);
					}
					else if(IsPlayerInRangeOfPoint(playerid, 4, -2975.8950, 505.1325, 2.4297))
					{
						createdcar = CreatePlayerVehicle(playerid, GetPlayerFreeVehicleId(playerid), GetPVarInt(playerid, "VehicleID"), -2975.4841, 509.6216, -0.4241, 89.7179, 0, 0, 2000000, 0, 0);
					}
					else if(IsPlayerInRangeOfPoint(playerid, 4, 723.1553, -1494.4547, 1.9343))
					{
						createdcar = CreatePlayerVehicle(playerid, GetPlayerFreeVehicleId(playerid), GetPVarInt(playerid, "VehicleID"), 723.4292, -1505.4899, -0.4145, 180.4212, 0, 0, 2000000, 0, 0);
					}
					else if(IsPlayerInRangeOfPoint(playerid, 4, 2974.7520, -1462.9265, 2.8184))
					{
						createdcar = CreatePlayerVehicle(playerid, GetPlayerFreeVehicleId(playerid), GetPVarInt(playerid, "VehicleID"), 2996.4255, -1467.3026, 2.8184, 0, 0, 0, 2000000, 0, 0);
						DeletePVar(playerid, "ShopTP");
					}

					GivePlayerCredits(playerid, -ShopItems[5][sItemPrice], 1);
					printf("Price5: %d", ShopItems[5][sItemPrice]);
					IsPlayerEntering{playerid} = true;
					SetPlayerVirtualWorld(playerid, 0);
					PutPlayerInVehicle(playerid, createdcar, 0);
					AmountSold[5]++;
					AmountMade[5] += ShopItems[5][sItemPrice];
					//ShopItems[5][sSold]++;
					//ShopItems[5][sMade] += ShopItems[5][sItemPrice];
					new szQuery[128];
					mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold5` = '%d', `AmountMade5` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[5], AmountMade[5]);
					mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "i", SENDDATA_THREAD);

					new Float: arr_fPlayerPos[4];

					GetPlayerPos(playerid, arr_fPlayerPos[0], arr_fPlayerPos[1], arr_fPlayerPos[2]);
					GetPlayerFacingAngle(playerid, arr_fPlayerPos[3]);

					format(string, sizeof(string), "[CAR %i] [User: %s(%i)] [IP: %s] [Credits: %s] [Vehicle: %s] [Price: %s]", AmountSold[5], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), VehicleName[GetPVarInt(playerid, "VehicleID") - 400], number_format(ShopItems[5][sItemPrice]));
					Log("logs/credits.log", string), print(string);

					format(string, sizeof(string), "[Car Shop] You have purchased a %s for %s credits.", VehicleName[GetPVarInt(playerid, "VehicleID") - 400], number_format(ShopItems[5][sItemPrice]));
					SendClientMessageEx(playerid, COLOR_CYAN, string);
					DeletePVar(playerid, "BoatShop");
				}
				else
				{
					GivePlayerCredits(playerid, -ShopItems[5][sItemPrice], 1);
					printf("Price5: %d", ShopItems[5][sItemPrice]);

					AmountSold[5]++;
					AmountMade[5] += ShopItems[5][sItemPrice];
					//ShopItems[5][sSold]++;
					//ShopItems[5][sMade] += ShopItems[5][sItemPrice];

					new szQuery[128];
					mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold5` = '%d', `AmountMade5` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[5], AmountMade[5]);
					mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "i", SENDDATA_THREAD);

					new Float: arr_fPlayerPos[4], createdcar;

					GetPlayerPos(playerid, arr_fPlayerPos[0], arr_fPlayerPos[1], arr_fPlayerPos[2]);
					GetPlayerFacingAngle(playerid, arr_fPlayerPos[3]);
					if(IsPlayerInDynamicArea(playerid, NGGShop))
					{
						arr_fPlayerPos[0] = 2923.3220;
						arr_fPlayerPos[1] = -1276.6011;
						arr_fPlayerPos[2] = 10.9809;
						arr_fPlayerPos[3] = 11.4626;
						if(IsAPlane(GetPVarInt(playerid, "VehicleID"), 1))
						{
							arr_fPlayerPos[0] = 1937.1254;
							arr_fPlayerPos[1] = -2494.1057;
							arr_fPlayerPos[2] = 14.4581;
							arr_fPlayerPos[3] = 90.2559;
						}
						DeletePVar(playerid, "ShopTP");
					}
					createdcar = CreatePlayerVehicle(playerid, GetPlayerFreeVehicleId(playerid), GetPVarInt(playerid, "VehicleID"), arr_fPlayerPos[0], arr_fPlayerPos[1], arr_fPlayerPos[2], arr_fPlayerPos[3], 0, 0, 2000000, 0, 0);
					format(string, sizeof(string), "[CAR %i] [User: %s(%i)] [IP: %s] [Credits: %s] [Vehicle: %s] [Price: %s]", AmountSold[5], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), VehicleName[GetPVarInt(playerid, "VehicleID") - 400], number_format(ShopItems[5][sItemPrice]));
					Log("logs/credits.log", string), print(string);
					IsPlayerEntering{playerid} = true;
					SetPlayerVirtualWorld(playerid, 0);
					PutPlayerInVehicle(playerid, createdcar, 0);
					format(string, sizeof(string), "[Car Shop] You have purchased a %s for %s credits.", VehicleName[GetPVarInt(playerid, "VehicleID") - 400], number_format(ShopItems[5][sItemPrice]));
					SendClientMessageEx(playerid, COLOR_CYAN, string);
				}
			}
		}
		DeletePVar(playerid, "VehicleID");
	}
	if(dialogid == DIALOG_CARSHOP2)
	{
		if(response)
		{
			if(PlayerInfo[playerid][pCarVoucher] == 0)
				return SendClientMessageEx(playerid, COLOR_GREY, "You don't have a restricted vehicle voucher. ");

			else if(!vehicleCountCheck(playerid))
				return ShowPlayerDialogEx(playerid, 0, DIALOG_STYLE_MSGBOX, "Error", "You can't have any more vehicles, you own too many!", "OK", "");

			else if(!vehicleSpawnCountCheck(playerid))
				return ShowPlayerDialogEx(playerid, 0, DIALOG_STYLE_MSGBOX, "Error", "You have too many vehicles spawned, you must store one first.", "OK", "");

			else
			{
				PlayerInfo[playerid][pCarVoucher]--;
				new Float: arr_fPlayerPos[4], createdcar;
				GetPlayerPos(playerid, arr_fPlayerPos[0], arr_fPlayerPos[1], arr_fPlayerPos[2]);
				GetPlayerFacingAngle(playerid, arr_fPlayerPos[3]);
				createdcar = CreatePlayerVehicle(playerid, GetPlayerFreeVehicleId(playerid), GetPVarInt(playerid, "VehicleID"), arr_fPlayerPos[0], arr_fPlayerPos[1], arr_fPlayerPos[2], arr_fPlayerPos[3], 0, 0, 2000000, 0, 0);
				format(string, sizeof(string), "[CAR %i] [User: %s(%i)] [IP: %s] [Credits: %s] [Vehicle: %s] [Price: %s]", AmountSold[5], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), VehicleName[GetPVarInt(playerid, "VehicleID") - 400], number_format(ShopItems[5][sItemPrice]));
				Log("logs/carvoucher.log", string), print(string);
				IsPlayerEntering{playerid} = true;
				SetPlayerVirtualWorld(playerid, 0);
				PutPlayerInVehicle(playerid, createdcar, 0);
				format(string, sizeof(string), "[Car Shop] You have purchased a %s for 1 restricted car voucher.", VehicleName[GetPVarInt(playerid, "VehicleID") - 400]);
				SendClientMessageEx(playerid, COLOR_CYAN, string);
			}
		}
		DeletePVar(playerid, "VehicleID");
	}
	if(dialogid == DIALOG_EDITSHOPBUSINESS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: // Add Business
				{
					for (new i; i < sizeof(BusinessSales); i++)
					{
						if(BusinessSales[i][bAvailable] == 0)
						{
							SetPVarInt(playerid, "EditingSale", i);
							break;
						}
					}
					ShowPlayerDialogEx(playerid, DIALOG_EDITSHOPBUSINESS2, DIALOG_STYLE_INPUT, "Adding Business [1/4]","Enter the business ID you wish to sell.", "Next", "Cancel");
				}
				case 1: // Edit Business
				{
					new Count, szDialog[500];
					for (new i; i < sizeof(BusinessSales); i++)
					{
						if(BusinessSales[i][bAvailable] == 1 || BusinessSales[i][bAvailable] == 3)
						{
							format(szDialog, sizeof(szDialog), "%s\n(%d) %s | Type: %d | Credits: %s", szDialog, BusinessSales[i][bBusinessID], BusinessSales[i][bText],BusinessSales[i][bType], number_format(BusinessSales[i][bPrice]));
							Selected[playerid][Count] = i;
							Count++;
						}
					}
					ShowPlayerDialogEx(playerid, DIALOG_EDITSHOPBUSINESS8, DIALOG_STYLE_LIST, "Select business to edit.", szDialog, "Select", "Exit");
				}
				case 2: // View Businesses Sold
				{
					new Count, szDialog[500];
					for (new i; i < sizeof(BusinessSales); i++)
					{
						if(BusinessSales[i][bAvailable] == 2)
						{
							format(szDialog, sizeof(szDialog), "%s\n(Business ID: %d)%s | (Credits: %s) | Purchaser: %d", szDialog, BusinessSales[i][bBusinessID], BusinessSales[i][bText], number_format(BusinessSales[i][bPrice]), BusinessSales[i][bPurchased]);
							Selected[playerid][Count] = i;
							Count++;
						}
					}
					ShowPlayerDialogEx(playerid, DIALOG_EDITSHOPBUSINESS7, DIALOG_STYLE_LIST, "Businesses Purchased", szDialog, "Reset", "Exit");
				}
			}
		}
	}
	if(dialogid == DIALOG_EDITSHOPBUSINESS8)
	{
		if(response)
		{
			new szDialog[128];
			SetPVarInt(playerid, "BusinessList", listitem);
			format(szDialog, sizeof(szDialog), "Business ID: %d\nText: %s\nType: %d\nCredits: %s\nAvailable: %d", BusinessSales[Selected[playerid][listitem]][bBusinessID], BusinessSales[Selected[playerid][listitem]][bText],BusinessSales[Selected[playerid][listitem]][bType],
			number_format(BusinessSales[Selected[playerid][listitem]][bPrice]), BusinessSales[Selected[playerid][listitem]][bAvailable]);
			ShowPlayerDialogEx(playerid, DIALOG_EDITSHOPBUSINESS9, DIALOG_STYLE_LIST, "Select business to edit.", szDialog, "Reset", "Exit");
		}
	}
	if(dialogid == DIALOG_EDITSHOPBUSINESS9)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: // Business ID
				{
					ShowPlayerDialogEx(playerid, DIALOG_EDITSHOPBUSINESS10, DIALOG_STYLE_INPUT, "Editing Business","Enter the business ID you wish to sell.", "Submit", "Back");
				}
				case 1: // Text
				{
					ShowPlayerDialogEx(playerid, DIALOG_EDITSHOPBUSINESS11, DIALOG_STYLE_INPUT, "Editing Business","Enter the business description.", "Submit", "Back");
				}
				case 2: // Type
				{
					ShowPlayerDialogEx(playerid, DIALOG_EDITSHOPBUSINESS12, DIALOG_STYLE_INPUT, "Editing Business","Enter the type of the business. (1-3)", "Submit", "Back");
				}
				case 3: // Credits
				{
					ShowPlayerDialogEx(playerid, DIALOG_EDITSHOPBUSINESS13, DIALOG_STYLE_INPUT, "Editing Business","Enter the amount of credits needed to purchase the business.", "Submit", "Back");
				}
				case 4: // Available
				{
					if(BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bAvailable] == 1)
					{
						BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bAvailable] = 3;
						SendClientMessageEx(playerid, COLOR_CYAN, "That business is now unavailable for purchase.");
					}
					else
					{
						BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bAvailable] = 1;
						SendClientMessageEx(playerid, COLOR_CYAN, "That business is now available for purchase.");
					}
					new szDialog[128];
					format(szDialog, sizeof(szDialog), "Business ID: %d\nText: %s\nType: %d\nCredits: %s\nAvailable: %d", BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bBusinessID], BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bText],BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bType],
					number_format(BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bPrice]), BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bAvailable]);
					ShowPlayerDialogEx(playerid, DIALOG_EDITSHOPBUSINESS9, DIALOG_STYLE_LIST, "Select business to edit.", szDialog, "Select", "Exit");
				}
			}
		}
		else
		{
			SaveBusinessSale(Selected[playerid][GetPVarInt(playerid, "BusinessList")]);
			DeletePVar(playerid, "BusinessList");
		}
	}
	if(dialogid == DIALOG_EDITSHOPBUSINESS13)
	{
		if(response)
		{
			new BusinessID;
			if (sscanf(inputtext, "d", BusinessID))
				return ShowPlayerDialogEx(playerid, DIALOG_EDITSHOPBUSINESS13, DIALOG_STYLE_INPUT, "Editing Business","Enter the amount of credits needed to purchase the business.", "Submit", "Back");

			if(BusinessID < 0)
				return ShowPlayerDialogEx(playerid, DIALOG_EDITSHOPBUSINESS13, DIALOG_STYLE_INPUT, "Editing Business","Enter the amount of credits needed to purchase the business.", "Submit", "Back");

			new szDialog[128];
			BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bPrice] = BusinessID;
			format(szDialog, sizeof(szDialog), "Business ID: %d\nText: %s\nType: %d\nCredits: %s\nAvailable: %d", BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bBusinessID], BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bText],BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bType],
			number_format(BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bPrice]), BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bAvailable]);
			ShowPlayerDialogEx(playerid, DIALOG_EDITSHOPBUSINESS9, DIALOG_STYLE_LIST, "Select business to edit.", szDialog, "Select", "Exit");
		}
		else
		{
			new szDialog[128];
			format(szDialog, sizeof(szDialog), "Business ID: %d\nText: %s\nType: %d\nCredits: %s\nAvailable: %d", BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bBusinessID], BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bText],BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bType],
			number_format(BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bPrice]), BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bAvailable]);
			ShowPlayerDialogEx(playerid, DIALOG_EDITSHOPBUSINESS9, DIALOG_STYLE_LIST, "Select business to edit.", szDialog, "Select", "Exit");
		}
	}
	if(dialogid == DIALOG_EDITSHOPBUSINESS12)
	{
		if(response)
		{
			new BusinessID;
			if (sscanf(inputtext, "d", BusinessID))
				return ShowPlayerDialogEx(playerid, DIALOG_EDITSHOPBUSINESS12, DIALOG_STYLE_INPUT, "Editing Business","Enter the type of the business. (1-3)", "Submit", "Back");

			if(BusinessID < 1 || BusinessID > 3)
				return ShowPlayerDialogEx(playerid, DIALOG_EDITSHOPBUSINESS12, DIALOG_STYLE_INPUT, "Editing Business","Enter the type of the business. (1-3)", "Submit", "Back");

			new szDialog[128];
			BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bType] = BusinessID;
			format(szDialog, sizeof(szDialog), "Business ID: %d\nText: %s\nType: %d\nCredits: %s\nAvailable: %d", BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bBusinessID], BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bText],BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bType],
			number_format(BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bPrice]), BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bAvailable]);
			ShowPlayerDialogEx(playerid, DIALOG_EDITSHOPBUSINESS9, DIALOG_STYLE_LIST, "Select business to edit.", szDialog, "Select", "Exit");
		}
		else
		{
			new szDialog[128];
			format(szDialog, sizeof(szDialog), "Business ID: %d\nText: %s\nType: %d\nCredits: %s\nAvailable: %d", BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bBusinessID], BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bText],BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bType],
			number_format(BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bPrice]), BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bAvailable]);
			ShowPlayerDialogEx(playerid, DIALOG_EDITSHOPBUSINESS9, DIALOG_STYLE_LIST, "Select business to edit.", szDialog, "Select", "Exit");
		}
	}
	if(dialogid == DIALOG_EDITSHOPBUSINESS11)
	{
		if(response)
		{
			if(isnull(inputtext))
				return ShowPlayerDialogEx(playerid, DIALOG_EDITSHOPBUSINESS11, DIALOG_STYLE_INPUT, "Editing Business","Enter the business description.", "Submit", "Back");

			if(strlen(inputtext) > 128)
				return ShowPlayerDialogEx(playerid, DIALOG_EDITSHOPBUSINESS11, DIALOG_STYLE_INPUT, "Editing Business","Enter the business description.", "Submit", "Back");

			new szDialog[128];
			strcpy(BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bText], inputtext, 128);
			format(szDialog, sizeof(szDialog), "Business ID: %d\nText: %s\nType: %d\nCredits: %s\nAvailable: %d", BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bBusinessID], BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bText],BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bType],
			number_format(BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bPrice]), BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bAvailable]);
			ShowPlayerDialogEx(playerid, DIALOG_EDITSHOPBUSINESS9, DIALOG_STYLE_LIST, "Select business to edit.", szDialog, "Select", "Exit");
		}
		else
		{
			new szDialog[128];
			format(szDialog, sizeof(szDialog), "Business ID: %d\nText: %s\nType: %d\nCredits: %s\nAvailable: %d", BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bBusinessID], BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bText],BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bType],
			number_format(BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bPrice]), BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bAvailable]);
			ShowPlayerDialogEx(playerid, DIALOG_EDITSHOPBUSINESS9, DIALOG_STYLE_LIST, "Select business to edit.", szDialog, "Select", "Exit");
		}
	}
	if(dialogid == DIALOG_EDITSHOPBUSINESS10)
	{
		if(response)
		{
			new BusinessID;
			if (sscanf(inputtext, "d", BusinessID))
				return ShowPlayerDialogEx(playerid, DIALOG_EDITSHOPBUSINESS10, DIALOG_STYLE_INPUT, "Editing Business","Enter the business ID you wish to sell.", "Submit", "Back");

			if(!IsValidBusinessID(BusinessID))
				return ShowPlayerDialogEx(playerid, DIALOG_EDITSHOPBUSINESS10, DIALOG_STYLE_INPUT, "Editing Business","Enter the business ID you wish to sell.", "Submit", "Back");

			new szDialog[128];
			BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bBusinessID] = BusinessID;
			format(szDialog, sizeof(szDialog), "Business ID: %d\nText: %s\nType: %d\nCredits: %s\nAvailable: %d", BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bBusinessID], BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bText],BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bType],
			number_format(BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bPrice]), BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bAvailable]);
			ShowPlayerDialogEx(playerid, DIALOG_EDITSHOPBUSINESS9, DIALOG_STYLE_LIST, "Select business to edit.", szDialog, "Select", "Exit");
		}
		else
		{
			new szDialog[128];
			format(szDialog, sizeof(szDialog), "Business ID: %d\nText: %s\nType: %d\nCredits: %s\nAvailable: %d", BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bBusinessID], BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bText],BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bType],
			number_format(BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bPrice]), BusinessSales[Selected[playerid][GetPVarInt(playerid, "BusinessList")]][bAvailable]);
			ShowPlayerDialogEx(playerid, DIALOG_EDITSHOPBUSINESS9, DIALOG_STYLE_LIST, "Select business to edit.", szDialog, "Select", "Exit");
		}
	}
	if(dialogid == DIALOG_EDITSHOPBUSINESS7)
	{
		if(response)
		{
			if(BusinessSales[Selected[playerid][listitem]][bAvailable] == 2) {
				strcpy(BusinessSales[Selected[playerid][listitem]][bText], "None", 128);
				BusinessSales[Selected[playerid][listitem]][bBusinessID] = -1;
				BusinessSales[Selected[playerid][listitem]][bType] = 0;
				BusinessSales[Selected[playerid][listitem]][bAvailable] = 0;
				BusinessSales[Selected[playerid][listitem]][bPrice] = 0;
				SendClientMessageEx(playerid, COLOR_CYAN, "You have reset the business sale.");
			}
		}
	}
	if(dialogid == DIALOG_EDITSHOPBUSINESS2)
	{
		if(response)
		{
			new BusinessID;
			if (sscanf(inputtext, "d", BusinessID))
				return ShowPlayerDialogEx(playerid, DIALOG_EDITSHOPBUSINESS2, DIALOG_STYLE_INPUT, "Adding Business [1/4]","Enter the business ID you wish to sell.", "Next", "Cancel");

			if(!IsValidBusinessID(BusinessID))
				return ShowPlayerDialogEx(playerid, DIALOG_EDITSHOPBUSINESS2, DIALOG_STYLE_INPUT, "Adding Business [1/4]","Enter the business ID you wish to sell.", "Next", "Cancel");

			for (new i; i < sizeof(BusinessSales); i++)
			{
				if(BusinessSales[i][bBusinessID] == BusinessID)
				{
					SendClientMessageEx(playerid, COLOR_GREY, "That business ID is already in use.");
					return ShowPlayerDialogEx(playerid, DIALOG_EDITSHOPBUSINESS2, DIALOG_STYLE_INPUT, "Adding Business [1/4]","Enter the business ID you wish to sell.", "Next", "Cancel");
				}
			}
			BusinessSales[GetPVarInt(playerid, "EditingSale")][bBusinessID] = BusinessID;
			ShowPlayerDialogEx(playerid, DIALOG_EDITSHOPBUSINESS3, DIALOG_STYLE_INPUT, "Adding Business [2/4]", "Enter a description for the business.", "Next", "Cancel");
		}
		else
		{
			ShowPlayerDialogEx(playerid, DIALOG_EDITSHOPBUSINESS, DIALOG_STYLE_LIST, "Edit Business Shop", "Add Business\nEdit Business\nView Businesses Sold", "Select", "Exit");
		}
	}
	if(dialogid == DIALOG_EDITSHOPBUSINESS3)
	{
		if(response)
		{
			if(isnull(inputtext))
				return ShowPlayerDialogEx(playerid, DIALOG_EDITSHOPBUSINESS3, DIALOG_STYLE_INPUT, "Adding Business [2/4]", "Enter a description for the business.", "Next", "Cancel");

			if(strlen(inputtext) > 128)
				return ShowPlayerDialogEx(playerid, DIALOG_EDITSHOPBUSINESS3, DIALOG_STYLE_INPUT, "Adding Business [2/4]", "Enter a description for the business.", "Next", "Cancel");

			strcpy(BusinessSales[GetPVarInt(playerid, "EditingSale")][bText], inputtext, 128);
			ShowPlayerDialogEx(playerid, DIALOG_EDITSHOPBUSINESS4, DIALOG_STYLE_INPUT, "Adding Business [3/4]", "Enter the business type (1-3).", "Next", "Cancel");
		}
		else
		{
			ShowPlayerDialogEx(playerid, DIALOG_EDITSHOPBUSINESS, DIALOG_STYLE_LIST, "Edit Business Shop", "Add Business\nEdit Business\nView Businesses Sold", "Select", "Exit");
		}
	}
	if(dialogid == DIALOG_EDITSHOPBUSINESS4)
	{
		if(response)
		{
			new BusinessID;
			if (sscanf(inputtext, "d", BusinessID))
				return ShowPlayerDialogEx(playerid, DIALOG_EDITSHOPBUSINESS4, DIALOG_STYLE_INPUT, "Adding Business [3/4]", "Enter the business type (1-3).", "Next", "Cancel");

			if(BusinessID < 1 || BusinessID > 3)
				return ShowPlayerDialogEx(playerid, DIALOG_EDITSHOPBUSINESS4, DIALOG_STYLE_INPUT, "Adding Business [3/4]", "Enter the business type (1-3).", "Next", "Cancel");

			BusinessSales[GetPVarInt(playerid, "EditingSale")][bType] = BusinessID;
			ShowPlayerDialogEx(playerid, DIALOG_EDITSHOPBUSINESS5, DIALOG_STYLE_INPUT, "Adding Business [4/4]", "Enter the amount of credits needed to purchase this business.", "Next", "Cancel");
		}
		else
		{
			ShowPlayerDialogEx(playerid, DIALOG_EDITSHOPBUSINESS, DIALOG_STYLE_LIST, "Edit Business Shop", "Add Business\nEdit Business\nView Businesses Sold", "Select", "Exit");
		}
	}
	if(dialogid == DIALOG_EDITSHOPBUSINESS5)
	{
		if(response)
		{
			new BusinessID;
			if (sscanf(inputtext, "d", BusinessID))
				return ShowPlayerDialogEx(playerid, DIALOG_EDITSHOPBUSINESS5, DIALOG_STYLE_INPUT, "Adding Business [4/4]", "Enter the amount of credits needed to purchase this business.", "Next", "Cancel");

			if(BusinessID < 0)
				return ShowPlayerDialogEx(playerid, DIALOG_EDITSHOPBUSINESS5, DIALOG_STYLE_INPUT, "Adding Business [4/4]", "Enter the amount of credits needed to purchase this business.", "Next", "Cancel");

			BusinessSales[GetPVarInt(playerid, "EditingSale")][bPrice] = BusinessID;
			format(string, sizeof(string), "Business ID: %d\nBusiness Description: %s\nBusiness Type: %d\nBusiness Price: %d", BusinessSales[GetPVarInt(playerid, "EditingSale")][bBusinessID], BusinessSales[GetPVarInt(playerid, "EditingSale")][bText], BusinessSales[GetPVarInt(playerid, "EditingSale")][bType], BusinessSales[GetPVarInt(playerid, "EditingSale")][bPrice]);
			ShowPlayerDialogEx(playerid, DIALOG_EDITSHOPBUSINESS6, DIALOG_STYLE_MSGBOX, "Finalize Business Sale", string, "Submit Business", "Cancel");
		}
		else
		{
			ShowPlayerDialogEx(playerid, DIALOG_EDITSHOPBUSINESS, DIALOG_STYLE_LIST, "Edit Business Shop", "Add Business\nEdit Business\nView Businesses Sold", "Select", "Exit");
		}
	}
	if(dialogid == DIALOG_EDITSHOPBUSINESS6)
	{
		if(response)
		{
			format(string, sizeof(string), "[EDITBUSINESSSHOP] [User: %s(%i)] [IP: %s] [BusinessID: %d] [Description: %s] [Type: %d] [Price: %d]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), BusinessSales[GetPVarInt(playerid, "EditingSale")][bBusinessID], BusinessSales[GetPVarInt(playerid, "EditingSale")][bText], BusinessSales[GetPVarInt(playerid, "EditingSale")][bType], BusinessSales[GetPVarInt(playerid, "EditingSale")][bPrice]);
			Log("logs/editshop.log", string), print(string);

			ShowPlayerDialogEx(playerid, DIALOG_EDITSHOPBUSINESS, DIALOG_STYLE_LIST, "Edit Business Shop", "Add Business\nEdit Business\nView Businesses Sold", "Select", "Exit");
			SendClientMessageEx(playerid, COLOR_CYAN, "You have successfully submitted a business sale.");
			BusinessSales[GetPVarInt(playerid, "EditingSale")][bAvailable] = 1;
			SaveBusinessSale(GetPVarInt(playerid, "EditingSale"));
			DeletePVar(playerid, "EditingSale");
		}
		else
		{
			ShowPlayerDialogEx(playerid, DIALOG_EDITSHOPBUSINESS, DIALOG_STYLE_LIST, "Edit Business Shop", "Add Business\nEdit Business\nView Businesses Sold", "Select", "Exit");
		}
	}
	if(dialogid == DIALOG_SHOPBUSINESS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new szDialog[500], Count;
					for (new i; i < sizeof(BusinessSales); i++)
					{
						if(BusinessSales[i][bAvailable] == 1)
						{
							format(szDialog, sizeof(szDialog), "%s\n%s (Credits: %s)", szDialog, BusinessSales[i][bText], number_format(BusinessSales[i][bPrice]));
							Selected[playerid][Count] = i;
							Count++;
						}
					}
					if(Count != 0)
						ShowPlayerDialogEx(playerid, DIALOG_SHOPBUSINESS2, DIALOG_STYLE_LIST, "Businesses Shop", szDialog, "More Info", "Exit");
					else
						SendClientMessageEx(playerid, COLOR_GREY, "No businesses are currently available.");
				}
				case 1:
				{
					if(PlayerInfo[playerid][pBusiness] == INVALID_BUSINESS_ID || PlayerInfo[playerid][pBusinessRank] < 5)
						return SendClientMessageEx(playerid, COLOR_GREY, "You don't currently own a business.");

					if(Businesses[PlayerInfo[playerid][pBusiness]][bGrade] == 0)
						return SendClientMessageEx(playerid, COLOR_GREY, "An error has occured please contact the Director of Customer Relations.");

					ShowPlayerDialogEx(playerid, DIALOG_SHOPBUSINESS4, DIALOG_STYLE_LIST, "Select how many months you wish to renew for.", "1 Month\n2 Months\n3 Months\n4 Months\n5 Months\n6 Months\n7 Months\n8 Months\n9 Months\n10 Months\n11 Months\n1 Year", "Select", "Cancel");
				}
			}
		}
	}
	if(dialogid == DIALOG_SHOPBUSINESS4)
	{
		if(response)
		{
			new Prices;
			SetPVarInt(playerid, "BusinessMonths", listitem+1);
			switch (Businesses[PlayerInfo[playerid][pBusiness]][bGrade])
			{
				case 1: Prices = ShopItems[11][sItemPrice];
				case 2: Prices = ShopItems[12][sItemPrice];
				case 3: Prices = ShopItems[13][sItemPrice];
			}
			SetPVarInt(playerid, "BusinessPrice", (listitem+1)*Prices);
			format(string, sizeof(string),"Business Renew\nGrade: %d\nExpires: %d Month\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", Businesses[PlayerInfo[playerid][pBusiness]][bGrade],listitem+1, number_format(PlayerInfo[playerid][pCredits]), number_format(GetPVarInt(playerid, "BusinessPrice")), number_format(PlayerInfo[playerid][pCredits]-GetPVarInt(playerid, "BusinessPrice")));
			ShowPlayerDialogEx(playerid, DIALOG_SHOPBUSINESS5, DIALOG_STYLE_MSGBOX, "Purchase Business Renew", string, "Purchase", "Cancel");
		}
	}
	if(dialogid == DIALOG_SHOPBUSINESS5)
	{
		if(response)
		{
			if(PlayerInfo[playerid][pBusiness] == INVALID_BUSINESS_ID || PlayerInfo[playerid][pBusinessRank] < 5)
				return SendClientMessageEx(playerid, COLOR_GREY, "You don't currently own a business.");

			new Prices;
			Prices = GetPVarInt(playerid, "BusinessPrice");

			if(PlayerInfo[playerid][pCredits] < Prices)
				return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			if(!GetPVarType(playerid, "BusinessMonths"))
				return SendClientMessageEx(playerid, COLOR_GREY, "An error has occurred please try again.");

			new szQuery[128];
			switch (Businesses[PlayerInfo[playerid][pBusiness]][bGrade])
			{
				case 1:
				{
					AmountSold[11]++;
					AmountMade[11] += Prices;
					//ShopItems[11][sSold]++;
					//ShopItems[11][sMade] += Prices;
					mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold11` = '%d', `AmountMade11` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[11], AmountMade[11]);
				}
				case 2:
				{
					AmountSold[12]++;
					AmountMade[12] += Prices;
					//ShopItems[12][sSold]++;
					//ShopItems[12][sMade] += Prices;
					mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold12` = '%d', `AmountMade12` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[12], AmountMade[12]);
				}
				case 3:
				{
					AmountSold[13]++;
					AmountMade[13] += Prices;
					//ShopItems[13][sSold]++;
					//ShopItems[13][sMade] += Prices;
					mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold13` = '%d', `AmountMade13` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[13], AmountMade[13]);
				}
			}

			mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "i", SENDDATA_THREAD);

			new Months = GetPVarInt(playerid, "BusinessMonths");
			GivePlayerCredits(playerid, -Prices, 1);
			new stamp = Businesses[PlayerInfo[playerid][pBusiness]][bMonths];
			if(stamp-gettime() < 0)
			{
				Businesses[PlayerInfo[playerid][pBusiness]][bMonths] = (2592000*Months)+gettime()+259200;
			}
			else Businesses[PlayerInfo[playerid][pBusiness]][bMonths] = ((2592000*Months)+gettime()+259200)+stamp-gettime();

			format(string, sizeof(string), "[Business Renewal(%i)] [Months: %d] [User: %s(%i)] [IP: %s] [Credits: %s] [Price: %s] -- %d | %d",PlayerInfo[playerid][pBusiness], Months, GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(Prices), stamp, Businesses[PlayerInfo[playerid][pBusiness]][bMonths]);
			Log("logs/credits.log", string), print(string);

			format(string, sizeof(string), "You have successfully payed %s credits to renew your business for %d months.", number_format(Prices), Months);
			SendClientMessageEx(playerid, COLOR_CYAN, string);
		}
		DeletePVar(playerid, "BusinessMonths");
	}
	if(dialogid == DIALOG_SHOPBUSINESS2)
	{
		if(response)
		{
			format(string, sizeof(string),"Business: %s\nType: %d\nExpires: 1 Month\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", BusinessSales[Selected[playerid][listitem]][bText], BusinessSales[Selected[playerid][listitem]][bType], number_format(PlayerInfo[playerid][pCredits]), number_format(BusinessSales[Selected[playerid][listitem]][bPrice]), number_format(PlayerInfo[playerid][pCredits]-BusinessSales[Selected[playerid][listitem]][bPrice]));
			ShowPlayerDialogEx(playerid, DIALOG_SHOPBUSINESS3, DIALOG_STYLE_MSGBOX, "Purchase Business", string, "Purchase", "Cancel");
			SetPVarInt(playerid, "BusinessSaleID", BusinessSales[Selected[playerid][listitem]][bBusinessID]), SetPVarInt(playerid, "BusinessSale", Selected[playerid][listitem]);
		}
	}
	if(dialogid == DIALOG_SHOPBUSINESS3)
	{
		if(response)
		{
			if(PlayerInfo[playerid][pCredits] < BusinessSales[GetPVarInt(playerid, "BusinessSale")][bPrice])
				return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			if (PlayerInfo[playerid][pBusiness] != INVALID_BUSINESS_ID)
				return SendClientMessageEx(playerid, COLOR_GREY, "You already own a business.");

			if(BusinessSales[GetPVarInt(playerid, "BusinessSale")][bAvailable] != 1)
				return SendClientMessageEx(playerid, COLOR_GREY, "This business is not for sale anymore.");

			if (!IsValidBusinessID(GetPVarInt(playerid, "BusinessSaleID")))
				return SendClientMessageEx(playerid, COLOR_GRAD2, "An error has occurred.");

			BusinessSales[GetPVarInt(playerid, "BusinessSale")][bAvailable] = 2;
			GivePlayerCredits(playerid, -BusinessSales[GetPVarInt(playerid, "BusinessSale")][bPrice], 1);
			BusinessSales[GetPVarInt(playerid, "BusinessSale")][bPurchased] = GetPlayerSQLId(playerid);

			Businesses[GetPVarInt(playerid, "BusinessSaleID")][bOwner] = GetPlayerSQLId(playerid);
			strcpy(Businesses[GetPVarInt(playerid, "BusinessSaleID")][bOwnerName], GetPlayerNameEx(playerid), MAX_PLAYER_NAME);
			PlayerInfo[playerid][pBusiness] = GetPVarInt(playerid, "BusinessSaleID");
			PlayerInfo[playerid][pBusinessRank] = 5;
			Businesses[GetPVarInt(playerid, "BusinessSaleID")][bMonths] = (2592000*1)+gettime()+259200;

			format(string, sizeof(string), "You have purchased business %s (1 Month) for %s credits.", BusinessSales[GetPVarInt(playerid, "BusinessSale")][bText], number_format(BusinessSales[GetPVarInt(playerid, "BusinessSale")][bPrice]));
			SendClientMessageEx(playerid, COLOR_CYAN, string);
			SendClientMessageEx(playerid, COLOR_WHITE, "Type /help to review the business help section!");
			SaveBusiness(GetPVarInt(playerid, "BusinessSaleID"));
			OnPlayerStatsUpdate(playerid);
			RefreshBusinessPickup(GetPVarInt(playerid, "BusinessSaleID"));

			format(string,sizeof(string),"%s(%d) (IP: %s) has bought business ID %d for %d.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), GetPVarInt(playerid, "BusinessSale"), BusinessSales[GetPVarInt(playerid, "BusinessSale")][bPrice]);
			Log("logs/business.log", string);

			SaveBusinessSale(GetPVarInt(playerid, "BusinessSale"));

			format(string, sizeof(string), "[Business %i] [User: %s(%i)] [IP: %s] [Credits: %s] [Price: %s]",GetPVarInt(playerid, "BusinessSale"), GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(BusinessSales[GetPVarInt(playerid, "BusinessSale")][bPrice]));
			Log("logs/credits.log", string), print(string);

			for(new i = 0; i < MAX_BUSINESSSALES; i++) {
			   Selected[playerid][i] = 0;
			}
		}
		DeletePVar(playerid, "BusinessSaleID");
		DeletePVar(playerid, "BusinessSale");
	}
	if(dialogid == DIALOG_HOUSESHOP)
	{
		if(response)
		{
			new szDialog[180];
			switch(listitem)
			{
				case 0: // Purchase House
				{
					format(szDialog, sizeof(szDialog),"*You must contact a senior admin to have this issued.\n\n\nItem: House\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[14][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[14][sItemPrice]));
					ShowPlayerDialogEx( playerid, DIALOG_HOUSESHOP2, DIALOG_STYLE_MSGBOX, "House Shop", szDialog, "Purchase", "Cancel" );
				}
				case 1: // House Interior Change
				{
					format(szDialog, sizeof(szDialog),"*You must contact a senior admin to have this issued.\n\n\nItem: House Interior Change\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[15][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[15][sItemPrice]));
					ShowPlayerDialogEx( playerid, DIALOG_HOUSESHOP3, DIALOG_STYLE_MSGBOX, "House Shop", szDialog, "Purchase", "Cancel" );
				}
				case 2: // House Move
				{
					format(szDialog, sizeof(szDialog),"*You must contact a senior admin to have this issued.\n\n\nItem: House Move\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[16][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[16][sItemPrice]));
					ShowPlayerDialogEx( playerid, DIALOG_HOUSESHOP4, DIALOG_STYLE_MSGBOX, "House Shop", szDialog, "Purchase", "Cancel" );
				}
				case 3: // Small Garage
				{
					format(szDialog, sizeof(szDialog),"*You must contact a senior admin to have this issued.\n\n\nItem: Garage - Small\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[24][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[24][sItemPrice]));
					ShowPlayerDialogEx( playerid, DIALOG_HOUSESHOP5, DIALOG_STYLE_MSGBOX, "House Shop", szDialog, "Purchase", "Cancel" );
				}
				case 4: // Medium Garage
				{
					format(szDialog, sizeof(szDialog),"*You must contact a senior admin to have this issued.\n\n\nItem: Garage - Medium\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[25][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[25][sItemPrice]));
					ShowPlayerDialogEx( playerid, DIALOG_HOUSESHOP6, DIALOG_STYLE_MSGBOX, "House Shop", szDialog, "Purchase", "Cancel" );
				}
				case 5: // Large Garage
				{
					format(szDialog, sizeof(szDialog),"*You must contact a senior admin to have this issued.\n\n\nItem: Garage - Large\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[26][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[26][sItemPrice]));
					ShowPlayerDialogEx( playerid, DIALOG_HOUSESHOP7, DIALOG_STYLE_MSGBOX, "House Shop", szDialog, "Purchase", "Cancel" );
				}
				case 6: // Large Garage
				{
					format(szDialog, sizeof(szDialog),"*You must contact a senior admin to have this issued.\n\n\nItem: Garage - Extra Large\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[27][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[27][sItemPrice]));
					ShowPlayerDialogEx( playerid, DIALOG_HOUSESHOP8, DIALOG_STYLE_MSGBOX, "House Shop", szDialog, "Purchase", "Cancel" );
				}
			}
		}
	}
	if(dialogid == DIALOG_HOUSESHOP2)
	{
		if(response)
		{
			if(PlayerInfo[playerid][pCredits] < ShopItems[14][sItemPrice])
				return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			GivePlayerCredits(playerid, -ShopItems[14][sItemPrice], 1);
			printf("Price14: %d", ShopItems[14][sItemPrice]);
			AmountSold[14]++;
			AmountMade[14] += ShopItems[14][sItemPrice];
			//ShopItems[14][sSold]++;
			//ShopItems[14][sMade] += ShopItems[14][sItemPrice];
			new szQuery[128];
			mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold14` = '%d', `AmountMade14` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[14], AmountMade[14]);
			mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "i", SENDDATA_THREAD);

			AddFlag(playerid, INVALID_PLAYER_ID, "Purchased House (Credits)");
			SendReportToQue(playerid, "House (Credits)", 2, 2);
			format(string, sizeof(string), "You have purchased a house for %s credits.", number_format(ShopItems[14][sItemPrice]));
			SendClientMessageEx(playerid, COLOR_CYAN, string);
			SendClientMessageEx(playerid, COLOR_CYAN, "Contact a senior admin to have the house issued.");

			format(string, sizeof(string), "[House] [User: %s(%i)] [IP: %s] [Credits: %s] [Price: %s]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[14][sItemPrice]));
			Log("logs/credits.log", string), print(string);
		}
	}
	if(dialogid == DIALOG_HOUSESHOP3)
	{
		if(response)
		{
			if(PlayerInfo[playerid][pCredits] < ShopItems[15][sItemPrice])
				return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			GivePlayerCredits(playerid, -ShopItems[15][sItemPrice], 1);
			printf("Price15: %d", ShopItems[15][sItemPrice]);
			AmountSold[15]++;
			AmountMade[15] += ShopItems[15][sItemPrice];
			//ShopItems[15][sSold]++;
			//ShopItems[15][sMade] += ShopItems[15][sItemPrice];
			new szQuery[128];
			mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold15` = '%d', `AmountMade15` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[15], AmountMade[15]);
			mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "i", SENDDATA_THREAD);

			AddFlag(playerid, INVALID_PLAYER_ID, "Purchased House Interior Change (Credits)");
			SendReportToQue(playerid, "House Interior Change (Credits)", 2, 2);
			format(string, sizeof(string), "You have purchased a house interior change for %s credits.", number_format(ShopItems[15][sItemPrice]));
			SendClientMessageEx(playerid, COLOR_CYAN, string);
			SendClientMessageEx(playerid, COLOR_CYAN, "Contact a senior admin to have the house interior change issued.");

			format(string, sizeof(string), "[House Interior Change] [User: %s(%i)] [IP: %s] [Credits: %s] [Price: %s]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[15][sItemPrice]));
			Log("logs/credits.log", string), print(string);
		}
	}
	if(dialogid == DIALOG_HOUSESHOP4)
	{
		if(response)
		{
			if(PlayerInfo[playerid][pCredits] < ShopItems[16][sItemPrice])
				return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			GivePlayerCredits(playerid, -ShopItems[16][sItemPrice], 1);
			printf("Price16: %d", ShopItems[16][sItemPrice]);
			AmountSold[16]++;
			AmountMade[16] += ShopItems[16][sItemPrice];
			//ShopItems[16][sSold]++;
			//ShopItems[16][sMade] += ShopItems[16][sItemPrice];
			new szQuery[128];
			mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold16` = '%d', `AmountMade16` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[16], AmountMade[16]);
			mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "i", SENDDATA_THREAD);

			AddFlag(playerid, INVALID_PLAYER_ID, "Purchased House Move (Credits)");
			SendReportToQue(playerid, "House Move (Credits)", 2, 2);
			format(string, sizeof(string), "You have purchased a house move for %s credits.", number_format(ShopItems[16][sItemPrice]));
			SendClientMessageEx(playerid, COLOR_CYAN, string);
			SendClientMessageEx(playerid, COLOR_CYAN, "Contact a senior admin to have the house move issued.");

			format(string, sizeof(string), "[House Move] [User: %s(%i)] [IP: %s] [Credits: %s] [Price: %s]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[16][sItemPrice]));
			Log("logs/credits.log", string), print(string);
		}
	}
	if(dialogid == DIALOG_HOUSESHOP5)
	{
		if(response)
		{
			if(PlayerInfo[playerid][pCredits] < ShopItems[24][sItemPrice])
				return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			GivePlayerCredits(playerid, -ShopItems[24][sItemPrice], 1);
			printf("Price24: %d", ShopItems[24][sItemPrice]);
			AmountSold[24]++;
			AmountMade[24] += ShopItems[24][sItemPrice];

			new szQuery[128];
			mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold24` = '%d', `AmountMade24` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[24], AmountMade[24]);
			mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "i", SENDDATA_THREAD);

			GarageVW++;
			g_mysql_SaveMOTD();
			format(szQuery, sizeof(szQuery), "Garage - Small (VW: %d)", GarageVW);
			AddFlag(playerid, INVALID_PLAYER_ID, szQuery);

			SendReportToQue(playerid, szQuery, 2, 2);
			format(string, sizeof(string), "You have purchased a small garage for %s credits.", number_format(ShopItems[24][sItemPrice]));
			SendClientMessageEx(playerid, COLOR_CYAN, string);
			SendClientMessageEx(playerid, COLOR_CYAN, "Contact a senior admin to have the small garage issued.");

			format(string, sizeof(string), "[Garage - Small] [User: %s(%i)] [IP: %s] [Credits: %s] [Price: %s]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[24][sItemPrice]));
			Log("logs/credits.log", string), print(string);
		}
	}
	if(dialogid == DIALOG_HOUSESHOP6)
	{
		if(response)
		{
			if(PlayerInfo[playerid][pCredits] < ShopItems[25][sItemPrice])
				return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			GivePlayerCredits(playerid, -ShopItems[25][sItemPrice], 1);
			printf("Price25: %d", ShopItems[25][sItemPrice]);
			AmountSold[25]++;
			AmountMade[25] += ShopItems[25][sItemPrice];

			new szQuery[128];
			mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold25` = '%d', `AmountMade25` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[25], AmountMade[25]);
			mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "i", SENDDATA_THREAD);

			GarageVW++;
			g_mysql_SaveMOTD();
			format(szQuery, sizeof(szQuery), "Garage - Medium (VW: %d)", GarageVW);
			AddFlag(playerid, INVALID_PLAYER_ID, szQuery);

			SendReportToQue(playerid, szQuery, 2, 2);
			format(string, sizeof(string), "You have purchased a medium garage for %s credits.", number_format(ShopItems[25][sItemPrice]));
			SendClientMessageEx(playerid, COLOR_CYAN, string);
			SendClientMessageEx(playerid, COLOR_CYAN, "Contact a senior admin to have the medium garage issued.");

			format(string, sizeof(string), "[Garage - Medium] [User: %s(%i)] [IP: %s] [Credits: %s] [Price: %s]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[25][sItemPrice]));
			Log("logs/credits.log", string), print(string);
		}
	}
	if(dialogid == DIALOG_HOUSESHOP7)
	{
		if(response)
		{
			if(PlayerInfo[playerid][pCredits] < ShopItems[26][sItemPrice])
				return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			GivePlayerCredits(playerid, -ShopItems[26][sItemPrice], 1);
			printf("Price26: %d", ShopItems[26][sItemPrice]);
			AmountSold[26]++;
			AmountMade[26] += ShopItems[26][sItemPrice];

			new szQuery[128];
			mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold26` = '%d', `AmountMade26` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[26], AmountMade[26]);
			mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "i", SENDDATA_THREAD);

			GarageVW++;
			g_mysql_SaveMOTD();
			format(szQuery, sizeof(szQuery), "Garage - Large (VW: %d)", GarageVW);
			AddFlag(playerid, INVALID_PLAYER_ID, szQuery);

			SendReportToQue(playerid, szQuery, 2, 2);
			format(string, sizeof(string), "You have purchased a large garage for %s credits.", number_format(ShopItems[26][sItemPrice]));
			SendClientMessageEx(playerid, COLOR_CYAN, string);
			SendClientMessageEx(playerid, COLOR_CYAN, "Contact a senior admin to have the large garage issued.");

			format(string, sizeof(string), "[Garage - Large] [User: %s(%i)] [IP: %s] [Credits: %s] [Price: %s]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[26][sItemPrice]));
			Log("logs/credits.log", string), print(string);
		}
	}
	if(dialogid == DIALOG_HOUSESHOP8)
	{
		if(response)
		{
			if(PlayerInfo[playerid][pCredits] < ShopItems[27][sItemPrice])
				return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			GivePlayerCredits(playerid, -ShopItems[27][sItemPrice], 1);
			printf("Price27: %d", ShopItems[27][sItemPrice]);
			AmountSold[27]++;
			AmountMade[27] += ShopItems[27][sItemPrice];

			new szQuery[128];
			mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold27` = '%d', `AmountMade27` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[27], AmountMade[27]);
			mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "i", SENDDATA_THREAD);

			GarageVW++;
			g_mysql_SaveMOTD();
			format(szQuery, sizeof(szQuery), "Garage - Extra Large (VW: %d)", GarageVW);
			AddFlag(playerid, INVALID_PLAYER_ID, szQuery);

			SendReportToQue(playerid, szQuery, 2, 2);
			format(string, sizeof(string), "You have purchased a extra large garage for %s credits.", number_format(ShopItems[27][sItemPrice]));
			SendClientMessageEx(playerid, COLOR_CYAN, string);
			SendClientMessageEx(playerid, COLOR_CYAN, "Contact a senior admin to have the extra large garage issued.");

			format(string, sizeof(string), "[Garage - Extra Large] [User: %s(%i)] [IP: %s] [Credits: %s] [Price: %s]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[27][sItemPrice]));
			Log("logs/credits.log", string), print(string);
		}
	}
	if(dialogid == DIALOG_HEALTHCARE)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new szDialog[160];
					format(szDialog, sizeof(szDialog), "When spawning from the hospital you will spawn with full health, and will be served a full meal.\n\nCost per hospital visit: {FFD700}%s{A9C4E4}", number_format(ShopItems[18][sItemPrice]));
					ShowPlayerDialogEx(playerid, DIALOG_HEALTHCARE2, DIALOG_STYLE_MSGBOX, "Advanced Health Care" , szDialog, "Activate", "Exit");
				}
				case 1:
				{
					new szDialog[160];
					SetPVarInt(playerid, "HealthCare", 1);
					format(szDialog, sizeof(szDialog), "When spawning from the hospital you will spawn 80%% faster, with full health, and be served a full meal.\n\nCost per hospital visit: {FFD700}%s{A9C4E4}", number_format(ShopItems[19][sItemPrice]));
					ShowPlayerDialogEx(playerid, DIALOG_HEALTHCARE2, DIALOG_STYLE_MSGBOX, "Super Advanced Health Care" , szDialog, "Activate", "Exit");
				}
			}
		}
	}
	if(dialogid == DIALOG_HEALTHCARE2)
	{
		if(response)
		{
			if(!GetPVarType(playerid, "HealthCare")) // Advanced
			{
				PlayerInfo[playerid][pHealthCare] = 1;
				SendClientMessageEx(playerid, COLOR_CYAN, "You have enabled Advanced Health Care, type /togglehealthcare to disable it.");
			}
			else // Super Advanced
			{
				PlayerInfo[playerid][pHealthCare] = 2;
				SendClientMessageEx(playerid, COLOR_CYAN, "You have enabled Super Advanced Health Care, type /togglehealthcare to disable it.");
			}
		}
		DeletePVar(playerid, "HealthCare");
	}
	if(dialogid == DIALOG_VIPSHOP && response)
	{
		if(listitem == 0)
		{
			ShowPlayerDialogEx(playerid, DIALOG_VIPSHOP2, DIALOG_STYLE_LIST, "Select which VIP you want to purchase.", "Bronze\nSilver\nGold", "Select", "Cancel");
		}
		else
		{
			if(PlayerInfo[playerid][pGVip] == 0) {
				SendClientMessageEx(playerid, COLOR_GREY, "You have never purchased Gold VIP, so you can't renew it.");
			}
			else
			{
				ShowPlayerDialogEx(playerid, DIALOG_VIPSHOP3, DIALOG_STYLE_LIST, "Select how many months you wish to renew for.", "1 Month\n2 Months\n3 Months\n4 Months\n5 Months\n6 Months\n7 Months\n8 Months\n9 Months\n10 Months\n11 Months\n1 Year", "Select", "Cancel");
			}
		}
	}
	if(dialogid == DIALOG_VIPSHOP3 && response)
	{
		new Months = listitem+1;
		SetPVarInt(playerid, "VIPType", 3), SetPVarInt(playerid, "VIPPrice", ShopItems[1][sItemPrice]*Months), SetPVarInt(playerid, "VIPMonths", Months), SetPVarInt(playerid, "GoldRenewal", 1);
		format(string, sizeof(string),"Type: Gold VIP\nExpires: %d Month(s)\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", listitem+1, number_format(PlayerInfo[playerid][pCredits]), number_format(GetPVarInt(playerid, "VIPPrice")), number_format(PlayerInfo[playerid][pCredits]-GetPVarInt(playerid, "VIPPrice")));
		ShowPlayerDialogEx( playerid, DIALOG_PURCHASEVIP, DIALOG_STYLE_MSGBOX, "Gold VIP Renew", string, "Purchase", "Cancel" );
	}
	if(dialogid == DIALOG_VIPSHOP2 && response)
	{
		switch(listitem)
		{
			case 0:
			{
				new Message[520];
				Message = "Purple VIP name on the forums.\nVIP Forums Access\
				\nVIP Chat\nVIP Garage with access to all the most select cars on the map.\nVIP Lounge\nFirst Aid Station [HP Refills]\nGun Locker \nAbility to get Cannabis and Crack using the jobs without having to wait for refills at the Drug House.";
				strcat(Message, "\nPreferred Pricing on Cars from the Dealership [20% off]\n24/7 VIP Pricing [20% Off]\nFree ATM Use \nFree Checking \nInvites to VIP Only Parties\nMax Hourly Interest Increase: $100k per paycheck");
				ShowPlayerDialogEx(playerid, DIALOG_VIPBRONZE, DIALOG_STYLE_MSGBOX, "Bronze VIP Features" , Message, "Continue", "Cancel" );
			}
			case 1:
			{
				new Message[850];
				Message = "Purple VIP name on the forums. \n\
				VIP Forums Access \n\
				VIP Chat \n\
				VIP Garage with access to all the most select cars on the map. \n\
				VIP Lounge\n\
				First Aid Station [HP Refills] \n\
				Gun Locker \n\
				Ability to get Cannabis and Crack using the jobs without having to wait for refills at the Drug House. \n\
				Preferred Pricing on Cars from the Dealership [20% off] \n\
				24/7 VIP Pricing [20% Off]";

				strcat(Message, "\nFree ATM Use \n\
				Free Checking \n\
				Invites to VIP Only Parties \n\
				Caller ID \n\
				Ability to have 2 jobs. \n\
				Ability to own 3 additional cars. \n\
				Unrestricted Access to All Skins \n\
				Increased Interest Rate \n\
				Ability to purchase negative phone numbers. \n\
				Ability to purchase one time spawns at the Gold VIP+ room. \n\
				Auto Reply Text Messages \n\
				Priority Advertisements cost $125,000 \n\
				Weekly VIP Buddy Invites* [ability to invite a friend to use VIP Bronze Features for 3 hours]");

				ShowPlayerDialogEx(playerid, DIALOG_VIPSILVER, DIALOG_STYLE_MSGBOX, "Silver VIP Features" , Message, "Continue", "Cancel" );
			}
			case 2:
			{
				new Message[1000];
				Message = "Purple VIP name on the forums. \n\
				VIP Forums Access \n\
				Gold VIP Tag on TS. \n\
				VIP Chat \n\
				VIP Garage with access to all the most select cars on the map. \n\
				VIP Lounge\n\
				First Aid Station [HP Refills] \n\
				Gun Locker \n\
				Ability to get Cannabis and Crack using the jobs without having to wait for refills at the Drug House. \n\
				Preferred Pricing on Cars from the Dealership [20% off] \n\
				Full Health and Hunger after death \n\
				24/7 VIP Pricing [20% Off]";

				strcat(Message, "\nFree ATM Use \n\
				Free Checking \n\
				Invites to VIP Only Parties \n\
				Caller ID \n\
				Ability to have 3 jobs. \n\
				Ability to own 3 additional cars. \n\
				Unrestricted Access to All Skins \n\
				Increased Interest Rate \n\
				Ability to purchase negative phone numbers. \n\
				Priority Advertisements cost $100,000 \n\
				10 percent discount on NameChanges \n\
				Auto Reply Text Messages \n\
				Daily VIP Buddy Invites* [ability to invite a friend to use VIP Bronze Features for 3 hours]");

				strcat(Message, "\nx2 Paycheck on Birthday \n\
				One random Gift on Birthday \n\
				5 Percent discount on House/Gate/Door Moves \n\
				WAR option at Paintball");

				ShowPlayerDialogEx(playerid, DIALOG_VIPGOLD, DIALOG_STYLE_MSGBOX, "Gold VIP Features" , Message, "Continue", "Cancel" );
			}
		}
	}
	if(dialogid == DIALOG_VIPBRONZE && response)
	{
		ShowPlayerDialogEx(playerid, DIALOG_VIPBRONZE2, DIALOG_STYLE_LIST, "Select how many months you wish to renew for.", "1 Month\n2 Months\n3 Months\n4 Months\n5 Months\n6 Months\n7 Months\n8 Months\n9 Months\n10 Months\n11 Months\n1 Year", "Select", "Cancel");
	}
	if(dialogid == DIALOG_VIPBRONZE2 && response)
	{
		new Months = listitem+1;
		SetPVarInt(playerid, "VIPType", 1), SetPVarInt(playerid, "VIPPrice", ShopItems[3][sItemPrice]*Months), SetPVarInt(playerid, "VIPMonths", Months);
		format(string, sizeof(string),"Type: Bronze VIP\nExpires: %d Month(s)\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", listitem+1, number_format(PlayerInfo[playerid][pCredits]), number_format(GetPVarInt(playerid, "VIPPrice")), number_format(PlayerInfo[playerid][pCredits]-GetPVarInt(playerid, "VIPPrice")));
		ShowPlayerDialogEx( playerid, DIALOG_PURCHASEVIP, DIALOG_STYLE_MSGBOX, "Bronze VIP", string, "Purchase", "Cancel" );
	}
	if(dialogid == DIALOG_VIPSILVER && response)
	{
		ShowPlayerDialogEx(playerid, DIALOG_VIPSILVER2, DIALOG_STYLE_LIST, "Select how many months you wish to renew for.", "1 Month\n2 Months\n3 Months\n4 Months\n5 Months\n6 Months\n7 Months\n8 Months\n9 Months\n10 Months\n11 Months\n1 Year", "Select", "Cancel");
	}
	if(dialogid == DIALOG_VIPSILVER2 && response)
	{
		new Months = listitem+1;
		SetPVarInt(playerid, "VIPType", 2), SetPVarInt(playerid, "VIPPrice", ShopItems[2][sItemPrice]*Months), SetPVarInt(playerid, "VIPMonths", Months);
		format(string, sizeof(string),"Type: Silver VIP\nExpires: %d Month(s)\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", listitem+1, number_format(PlayerInfo[playerid][pCredits]), number_format(GetPVarInt(playerid, "VIPPrice")), number_format(PlayerInfo[playerid][pCredits]-GetPVarInt(playerid, "VIPPrice")));
		ShowPlayerDialogEx( playerid, DIALOG_PURCHASEVIP, DIALOG_STYLE_MSGBOX, "Silver VIP", string, "Purchase", "Cancel" );
	}
	if(dialogid == DIALOG_VIPGOLD && response)
	{
		SetPVarInt(playerid, "VIPMonths", 1), SetPVarInt(playerid, "VIPType", 3), SetPVarInt(playerid, "VIPPrice", ShopItems[0][sItemPrice]);
		format(string, sizeof(string),"Type: Gold VIP\nExpires: 1 Month\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]), number_format(GetPVarInt(playerid, "VIPPrice")), number_format(PlayerInfo[playerid][pCredits]-GetPVarInt(playerid, "VIPPrice")));
		ShowPlayerDialogEx( playerid, DIALOG_PURCHASEVIP, DIALOG_STYLE_MSGBOX, "Gold VIP", string, "Purchase", "Cancel" );
	}
	if(dialogid == DIALOG_PURCHASEVIP)
	{
		if(response)
		{
			if(PlayerInfo[playerid][pCredits] < GetPVarInt(playerid, "VIPPrice"))
				return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			if(PlayerInfo[playerid][pDonateRank] != 0)
				return SendClientMessageEx(playerid, COLOR_GREY, "You already have VIP, please wait for it to expire.");

			if(GetPVarType(playerid, "VIPType") != 1)
				return SendClientMessageEx(playerid, COLOR_GREY, "An error has occured, please try again.");


			PlayerInfo[playerid][pDonateRank] = GetPVarInt(playerid, "VIPType");
			PlayerInfo[playerid][pTempVIP] = 0;
			PlayerInfo[playerid][pBuddyInvited] = 0;
			PlayerInfo[playerid][pVIPSellable] = 0;

			if(PlayerInfo[playerid][pVIPM] == 0)
			{
				PlayerInfo[playerid][pVIPM] = VIPM;
				VIPM++;
			}

			if(GetPVarType(playerid, "VIPMonths"))
			{
				PlayerInfo[playerid][pVIPExpire] = (2592000*GetPVarInt(playerid, "VIPMonths"))+gettime();
			}
			else
			{
				PlayerInfo[playerid][pVIPExpire] = 2592000+gettime();
			}

			GivePlayerCredits(playerid, -GetPVarInt(playerid, "VIPPrice"), 1);

			if(GetPVarInt(playerid, "VIPType") == 3)
				PlayerInfo[playerid][pGVip] = 1;

			new VIPType[7];
			new szQuery[128];
			if(GetPVarType(playerid, "GoldRenewal"))
			{
				AmountSold[1]++;
				AmountMade[1] += GetPVarInt(playerid, "VIPPrice");
				VIPType = "Gold";
				//ShopItems[1][sMade] += GetPVarInt(playerid, "VIPPrice");
				mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold1` = '%d', `AmountMade1` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[1], AmountMade[1]);
				DeletePVar(playerid, "GoldRenewal");
			}
			else
			{
				switch(GetPVarInt(playerid, "VIPType")) {
					case 1:
					{
						VIPType = "Bronze";
						AmountSold[3]++;
						AmountMade[3] += GetPVarInt(playerid, "VIPPrice");
						//ShopItems[3][sSold]++;
						//ShopItems[3][sMade] += GetPVarInt(playerid, "VIPPrice");
						mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold3` = '%d', `AmountMade3` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[3], AmountMade[3]);
					}
					case 2:
					{
						VIPType = "Silver";
						AmountSold[2]++;
						AmountMade[2] += GetPVarInt(playerid, "VIPPrice");
						//ShopItems[2][sSold]++;
						//ShopItems[2][sMade] += GetPVarInt(playerid, "VIPPrice");
						mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold2` = '%d', `AmountMade2` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[2], AmountMade[2]);
					}
					case 3:
					{
						VIPType = "Gold";
						AmountSold[0]++;
						AmountMade[0] += GetPVarInt(playerid, "VIPPrice");
						//ShopItems[0][sSold]++;
						//ShopItems[0][sMade] += GetPVarInt(playerid, "VIPPrice");
						mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold0` = '%d', `AmountMade0` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[0], AmountMade[0]);
					}
				}
			}

			mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "i", SENDDATA_THREAD);

			format(string, sizeof(string), "You have purchased %s VIP (%d Month(s)) for %s credits.", VIPType,GetPVarInt(playerid, "VIPMonths"), number_format(GetPVarInt(playerid, "VIPPrice")));
			SendClientMessageEx(playerid, COLOR_CYAN, string);

			format(string, sizeof(string), "[VIP %i] [User: %s(%i)] [IP: %s] [Credits: %s] [VIP: %s(%d)] [Price: %s]", PlayerInfo[playerid][pVIPM], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), VIPType,GetPVarInt(playerid, "VIPMonths"), number_format(GetPVarInt(playerid, "VIPPrice")));
			Log("logs/credits.log", string), Log("logs/setvip.log", string), print(string);
		}
		DeletePVar(playerid, "VIPPrice");
		DeletePVar(playerid, "VIPMonths");
		DeletePVar(playerid, "VIPType");
	}
	if(dialogid == DIALOG_SHOPGIFTRESET)
	{
		if(response)
		{
			if(PlayerInfo[playerid][pCredits] < ShopItems[17][sItemPrice])
				return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			PlayerInfo[playerid][pGiftTime] = 0;

			GivePlayerCredits(playerid, -ShopItems[17][sItemPrice], 1);
			printf("Price18: %d", ShopItems[17][sItemPrice]);
			format(string, sizeof(string), "You have purchased gift timer reset for %s credits.", number_format(ShopItems[17][sItemPrice]));
			SendClientMessageEx(playerid, COLOR_CYAN, string);

			AmountSold[17]++;
			AmountMade[17] += ShopItems[17][sItemPrice];
			//ShopItems[17][sSold]++;
			//ShopItems[17][sMade] += ShopItems[17][sItemPrice];
			new szQuery[128];
			mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold17` = '%d', `AmountMade17` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[17], AmountMade[17]);
			mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "i", SENDDATA_THREAD);

			format(string, sizeof(string), "[GIFTTIMERRESET] [User: %s(%i)] [IP: %s] [Credits: %s] [Gift Timer Reset] [Price: %s]",GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[17][sItemPrice]));
			Log("logs/credits.log", string), print(string);
		}
	}
	if(dialogid == DIALOG_SHOPTOTRESET)
	{
		if(response)
		{
			if(PlayerInfo[playerid][pCredits] < 20)
				return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			PlayerInfo[playerid][pTrickortreat] = 0;

			GivePlayerCredits(playerid, -20, 1);
			format(string, sizeof(string), "You have purchased a Holiday timer reset for %s credits.", number_format(20));
			SendClientMessageEx(playerid, COLOR_CYAN, string);


			format(string, sizeof(string), "[GIFTTIMERRESET] [User: %s(%i)] [IP: %s] [Credits: %s] [Special Holiday Timer Reset] [Price: %s]",GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(20));
			Log("logs/zombiecure.log", string), print(string);
		}
	}
	if(dialogid == DIALOG_HALLOWEENSHOP)
	{
		if(response)
		{
			if(listitem == 0)
			{
				format(string, sizeof(string),"Item: Limited Edition Straw Hat\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]), number_format(150), number_format(PlayerInfo[playerid][pCredits]-150));
				ShowPlayerDialogEx( playerid, DIALOG_HALLOWEENSHOP1, DIALOG_STYLE_MSGBOX, "Thanksgiving Shop", string, "Purchase", "Exit" );
			}
			else
			{
				format(string, sizeof(string),"Item: Limited Edition Cluckin Bell Hat\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]), number_format(150), number_format(PlayerInfo[playerid][pCredits]-150));
				ShowPlayerDialogEx( playerid, DIALOG_HALLOWEENSHOP2, DIALOG_STYLE_MSGBOX, "Thanksgiving Shop", string, "Purchase", "Exit" );
			}
		}
	}
	if(dialogid == DIALOG_HALLOWEENSHOP1)
	{
		if(response)
		{
			if(PumpkinStock <= 0)
				return SendClientMessageEx(playerid, COLOR_GREY, "This limited item has sold out!");
			if(PlayerInfo[playerid][pCredits] < 150)
				return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			GivePlayerCredits(playerid, -150, 1);
			PumpkinStock--;
			format(string, sizeof(string), "You have purchased the Straw Hat toy for %s credits.", number_format(150));
			SendClientMessageEx(playerid, COLOR_CYAN, string);

			g_mysql_SaveAccount(playerid);
			g_mysql_SaveMOTD();

			format(string, sizeof(string), "[TOYSALE] [User: %s(%i)] [IP: %s] [Credits: %s] [Straw Hat] [Price: %s]",GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(150));
			Log("logs/zombiecure.log", string), print(string);

			new icount = GetPlayerToySlots(playerid);
			for(new v = 0; v < icount; v++)
			{
				if(PlayerToyInfo[playerid][v][ptModelID] == 0)
				{
					PlayerToyInfo[playerid][v][ptModelID] = 19553;
					PlayerToyInfo[playerid][v][ptBone] = 6;
					PlayerToyInfo[playerid][v][ptPosX] = 0.0;
					PlayerToyInfo[playerid][v][ptPosY] = 0.0;
					PlayerToyInfo[playerid][v][ptPosZ] = 0.0;
					PlayerToyInfo[playerid][v][ptRotX] = 0.0;
					PlayerToyInfo[playerid][v][ptRotY] = 0.0;
					PlayerToyInfo[playerid][v][ptRotZ] = 0.0;
					PlayerToyInfo[playerid][v][ptScaleX] = 1.0;
					PlayerToyInfo[playerid][v][ptScaleY] = 1.0;
					PlayerToyInfo[playerid][v][ptScaleZ] = 1.0;
					PlayerToyInfo[playerid][v][ptTradable] = 1;

					g_mysql_NewToy(playerid, v);
					return 1;
				}
			}

			for(new i = 0; i < MAX_PLAYERTOYS; i++)
			{
				if(PlayerToyInfo[playerid][i][ptModelID] == 0)
				{
					PlayerToyInfo[playerid][i][ptModelID] = 19553;
					PlayerToyInfo[playerid][i][ptBone] = 6;
					PlayerToyInfo[playerid][i][ptPosX] = 0.0;
					PlayerToyInfo[playerid][i][ptPosY] = 0.0;
					PlayerToyInfo[playerid][i][ptPosZ] = 0.0;
					PlayerToyInfo[playerid][i][ptRotX] = 0.0;
					PlayerToyInfo[playerid][i][ptRotY] = 0.0;
					PlayerToyInfo[playerid][i][ptRotZ] = 0.0;
					PlayerToyInfo[playerid][i][ptScaleX] = 1.0;
					PlayerToyInfo[playerid][i][ptScaleY] = 1.0;
					PlayerToyInfo[playerid][i][ptScaleZ] = 1.0;
					PlayerToyInfo[playerid][i][ptTradable] = 1;
					PlayerToyInfo[playerid][i][ptSpecial] = 1;

					g_mysql_NewToy(playerid, i);

					SendClientMessageEx(playerid, COLOR_GRAD1, "Due to you not having any available slots, we've temporarily gave you an additional slot to use/sell/trade your toy.");
					SendClientMessageEx(playerid, COLOR_RED, "Note: Please take note that after selling the toy, the temporarily additional toy slot will be removed.");
					break;
				}
			}

		}
	}
	if(dialogid == DIALOG_HALLOWEENSHOP2)
	{
		if(response)
		{
			if(PlayerInfo[playerid][pCredits] < 150)
				return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			GivePlayerCredits(playerid, -150, 1);
			format(string, sizeof(string), "You have purchased the Cluckin Bell Hat toy for %s credits.", number_format(150));
			SendClientMessageEx(playerid, COLOR_CYAN, string);

			g_mysql_SaveAccount(playerid);
			g_mysql_SaveMOTD();

			format(string, sizeof(string), "[TOYSALE] [User: %s(%i)] [IP: %s] [Credits: %s] [Cluckin Bell Hat] [Price: %s]",GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(60));
			Log("logs/zombiecure.log", string), print(string);

			new icount = GetPlayerToySlots(playerid);
			for(new v = 0; v < icount; v++)
			{
				if(PlayerToyInfo[playerid][v][ptModelID] == 0)
				{
					PlayerToyInfo[playerid][v][ptModelID] = 19137;
					PlayerToyInfo[playerid][v][ptBone] = 5;
					PlayerToyInfo[playerid][v][ptPosX] = 0.0;
					PlayerToyInfo[playerid][v][ptPosY] = 0.0;
					PlayerToyInfo[playerid][v][ptPosZ] = 0.0;
					PlayerToyInfo[playerid][v][ptRotX] = 0.0;
					PlayerToyInfo[playerid][v][ptRotY] = 0.0;
					PlayerToyInfo[playerid][v][ptRotZ] = 0.0;
					PlayerToyInfo[playerid][v][ptScaleX] = 1.0;
					PlayerToyInfo[playerid][v][ptScaleY] = 1.0;
					PlayerToyInfo[playerid][v][ptScaleZ] = 1.0;
					PlayerToyInfo[playerid][v][ptTradable] = 1;

					g_mysql_NewToy(playerid, v);
					return 1;
				}
			}

			for(new i = 0; i < MAX_PLAYERTOYS; i++)
			{
				if(PlayerToyInfo[playerid][i][ptModelID] == 0)
				{
					PlayerToyInfo[playerid][i][ptModelID] =  19137;
					PlayerToyInfo[playerid][i][ptBone] = 5;
					PlayerToyInfo[playerid][i][ptPosX] = 0.0;
					PlayerToyInfo[playerid][i][ptPosY] = 0.0;
					PlayerToyInfo[playerid][i][ptPosZ] = 0.0;
					PlayerToyInfo[playerid][i][ptRotX] = 0.0;
					PlayerToyInfo[playerid][i][ptRotY] = 0.0;
					PlayerToyInfo[playerid][i][ptRotZ] = 0.0;
					PlayerToyInfo[playerid][i][ptScaleX] = 1.0;
					PlayerToyInfo[playerid][i][ptScaleY] = 1.0;
					PlayerToyInfo[playerid][i][ptScaleZ] = 1.0;
					PlayerToyInfo[playerid][i][ptTradable] = 1;
					PlayerToyInfo[playerid][i][ptSpecial] = 1;

					g_mysql_NewToy(playerid, i);

					SendClientMessageEx(playerid, COLOR_GRAD1, "Due to you not having any available slots, we've temporarily gave you an additional slot to use/sell/trade your toy.");
					SendClientMessageEx(playerid, COLOR_RED, "Note: Please take note that after selling the toy, the temporarily additional toy slot will be removed.");
					break;
				}
			}

		}
	}
	if(dialogid == DIALOG_SHOPNEON && response)
	{
		switch(listitem)
		{
			case 0: SetPVarInt(playerid, "ToyID", 18647);
			case 1: SetPVarInt(playerid, "ToyID", 18648);
			case 2: SetPVarInt(playerid, "ToyID", 18649);
			case 3: SetPVarInt(playerid, "ToyID", 18650);
			case 4: SetPVarInt(playerid, "ToyID", 18651);
			case 5: SetPVarInt(playerid, "ToyID", 18652);
		}
		new stringg[512], icount = GetPlayerToySlots(playerid);
		for(new z;z<icount;z++)
		{
			new name[24];
			format(name, sizeof(name), "None");

			for(new i;i<sizeof(HoldingObjectsAll);i++)
			{
				if(HoldingObjectsAll[i][holdingmodelid] == PlayerToyInfo[playerid][z][ptModelID])
				{
					format(name, sizeof(name), "%s", HoldingObjectsAll[i][holdingmodelname]);
				}
			}

			format(stringg, sizeof(stringg), "%s(%d) %s (Bone: %s)\n", stringg, z, name, HoldingBones[PlayerToyInfo[playerid][z][ptBone]]);
		}
		ShowPlayerDialogEx(playerid, DIALOG_SHOPBUYTOYS, DIALOG_STYLE_LIST, "Select a Slot", stringg, "Select", "Cancel");
	}
	if(dialogid == DIALOG_SHOPBUYTOYS && response)
	{
		new name[24];
		for(new i;i<sizeof(HoldingObjectsShop);i++)
		{
			if(HoldingObjectsShop[i][holdingmodelid] == GetPVarInt(playerid, "ToyID"))
			{
				format(name, sizeof(name), "%s", HoldingObjectsShop[i][holdingmodelname]);
			}
		}
		format(string, sizeof(string), "Item: %s\n\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", name, number_format(PlayerInfo[playerid][pCredits]),number_format(ShopItems[4][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[4][sItemPrice]));
		ShowPlayerDialogEx(playerid, DIALOG_SHOPBUYTOYS2, DIALOG_STYLE_MSGBOX, "Toy Shop", string, "Purchase", "Cancel");
		SetPVarInt(playerid, "ToySlot", listitem);
	}
	if((dialogid == DIALOG_SHOPBUYTOYS2) && response)
	{
		if(PlayerInfo[playerid][pCredits] < ShopItems[4][sItemPrice])
		{
			SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits for that item. Purchase some credits at shop.ng-gaming.net");
		}
		else
		{
			if(!toyCountCheck(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You do not have enough toy slots, you may purchase more via /toys");

			if(PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptModelID] != 0) return SendClientMessageEx(playerid, COLOR_YELLOW, "* You already have something in that slot. Delete it with /toys");

			new name[24];
			for(new i;i<sizeof(HoldingObjectsShop);i++)
			{
				if(HoldingObjectsShop[i][holdingmodelid] == GetPVarInt(playerid, "ToyID"))
				{
					format(name, sizeof(name), "%s", HoldingObjectsShop[i][holdingmodelname]);
				}
			}

			GivePlayerCredits(playerid, -ShopItems[4][sItemPrice], 1);
			printf("Price4: %d", ShopItems[4][sItemPrice]);
			AmountSold[4]++;
			AmountMade[4] += ShopItems[4][sItemPrice];
			//ShopItems[4][sSold]++;
			//ShopItems[4][sMade] += ShopItems[4][sItemPrice];
			new szQuery[1024];
			mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSold4` = '%d', `AmountMade4` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[4], AmountMade[4]);
			mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "i", SENDDATA_THREAD);

			format(string, sizeof(string), "[TOY %i] [User: %s(%i)] [IP: %s] [Credits: %s] [Toy: %s] [Price: %s]", AmountSold[4], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), name, number_format(ShopItems[4][sItemPrice]));
			Log("logs/credits.log", string), print(string);

			PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptModelID] = GetPVarInt(playerid, "ToyID");

			new modelid = GetPVarInt(playerid, "ToyID");
			if((modelid >= 19006 && modelid <= 19035) || (modelid >= 19138 && modelid <= 19140))
			{
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = 2;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosX] = 0.9;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosZ] = 0.35;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotX] = 90.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotY] = 90.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotZ] = 0.0;
			}
			else if(modelid >= 18891 && modelid <= 18910)
			{
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = 2;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosX] = 0.15;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosZ] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotX] = 90.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotY] = 180.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotZ] = 90.0;
			}
			else if(modelid >= 18926 && modelid <= 18935)
			{
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = 2;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosX] = 0.1;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosZ] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotX] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotZ] = 0.0;
			}
			else if(modelid >= 18911 && modelid <= 18920)
			{
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = 2;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosX] = 0.1;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosY] = 0.035;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosZ] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotX] = 90.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotY] = 180.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotZ] = 90.0;
			}
			else if(modelid == 19078 || modelid == 19078)
			{
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = 16;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosX] = 0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosY] = 0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosZ] = 0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotX] = 180.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotY] = 180.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotZ] = 0.0;
			}
			else if((modelid >= 18641 && modelid <= 18644) || (modelid >= 19080 && modelid <= 19084) || modelid == 18890)
			{
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = 6;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosX] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosZ] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotX] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotZ] = 0.0;
			}
			else
			{
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptBone] = 2;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosX] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptPosZ] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotX] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotY] = 0.0;
				PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptRotZ] = 0.0;
			}
			PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptScaleX] = 1.0;
			PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptScaleY] = 1.0;
			PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptScaleZ] = 1.0;
			PlayerToyInfo[playerid][GetPVarInt(playerid, "ToySlot")][ptTradable] = 1;

			g_mysql_NewToy(playerid, GetPVarInt(playerid, "ToySlot"));

			format(string, sizeof(string), "You have purchased %s for %s credits. (Slot: %d)", name, number_format(ShopItems[4][sItemPrice]), GetPVarInt(playerid, "ToySlot"));
			SendClientMessageEx(playerid, COLOR_CYAN, string);
			SendClientMessageEx(playerid, COLOR_WHITE, "HINT: Use /toys to wear/edit this");
			DeletePVar(playerid, "ToyID"), DeletePVar(playerid, "ToySlot");
		}
	}
	if(dialogid == DIALOG_SELLCREDITS)
	{
		if(response)
		{
			if(GetPVarInt(GetPVarInt(playerid, "CreditsSeller"), "CreditsSeller") != playerid)
			{
				SendClientMessageEx(playerid, COLOR_GREY, "The other player has disconnected please try again.");
				DeletePVar(playerid, "CreditsOffer");
				DeletePVar(playerid, "CreditsAmount");
				DeletePVar(playerid, "CreditsSeller");
				DeletePVar(playerid, "CreditsFirstAmount");
				return 1;
			}
			if(PlayerInfo[GetPVarInt(playerid, "CreditsSeller")][pCredits] < GetPVarInt(playerid, "CreditsAmount"))
			{
				SendClientMessageEx(playerid, COLOR_GREY, "The seller didn't have enough credits.");
				SendClientMessageEx(GetPVarInt(playerid, "CreditsSeller"), COLOR_GREY, "You don't have enough credits.");
				DeletePVar(playerid, "CreditsOffer");
				DeletePVar(playerid, "CreditsAmount");
				DeletePVar(playerid, "CreditsSeller");
				DeletePVar(playerid, "CreditsFirstAmount");
				return 1;
			}
			if(GetPlayerCash(playerid) < GetPVarInt(playerid, "CreditsOffer"))
			{
				SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough money to accept the offer.");
				SendClientMessageEx(GetPVarInt(playerid, "CreditsSeller"), COLOR_GREY, "That player does not have enough money to accept your offer.");
				DeletePVar(playerid, "CreditsOffer");
				DeletePVar(playerid, "CreditsAmount");
				DeletePVar(playerid, "CreditsSeller");
				DeletePVar(playerid, "CreditsFirstAmount");
				return 1;
			}
			new szMessage[156];

			GivePlayerCash(playerid, -GetPVarInt(playerid, "CreditsOffer"));
			GivePlayerCash(GetPVarInt(playerid, "CreditsSeller"), GetPVarInt(playerid, "CreditsOffer"));

			GivePlayerCredits(playerid, GetPVarInt(playerid, "CreditsAmount"), 0);
			GivePlayerCredits(GetPVarInt(playerid, "CreditsSeller"), -GetPVarInt(playerid, "CreditsFirstAmount"), 0);

			AmountSold[21]++;
			AmountMade[21] += GetPVarInt(playerid, "CreditsFirstAmount")-GetPVarInt(playerid, "CreditsAmount");
			//ShopItems[21][sSold]++;
			//ShopItems[21][sMade] += GetPVarInt(playerid, "CreditsFirstAmount")-GetPVarInt(playerid, "CreditsAmount");

			mysql_format(MainPipeline, szMessage, sizeof(szMessage), "UPDATE `sales` SET `TotalSold21` = '%d', `AmountMade21` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[21], AmountMade[21]);
			mysql_tquery(MainPipeline, szMessage, "OnQueryFinish", "i", SENDDATA_THREAD);
			print(szMessage);

			format(szMessage, sizeof(szMessage), "You have accepted the offer of %s credits for $%s from %s.", number_format(GetPVarInt(playerid, "CreditsAmount")), number_format(GetPVarInt(playerid, "CreditsOffer")), GetPlayerNameEx(GetPVarInt(playerid, "CreditsSeller")));
			SendClientMessageEx(playerid, COLOR_CYAN, szMessage);

			format(szMessage, sizeof(szMessage), "%s has accepted your offer of %s credits for $%s.", GetPlayerNameEx(playerid), number_format(GetPVarInt(playerid, "CreditsAmount")), number_format(GetPVarInt(playerid, "CreditsOffer")));
			SendClientMessageEx(GetPVarInt(playerid, "CreditsSeller"), COLOR_CYAN, szMessage);

			format(szMessage, sizeof(szMessage), "[S %s(%d)][IP %s][B %s(%d)][IP %s][C %s][P $%s]", GetPlayerNameEx(GetPVarInt(playerid, "CreditsSeller")),GetPlayerSQLId(GetPVarInt(playerid, "CreditsSeller")), GetPlayerIpEx(GetPVarInt(playerid, "CreditsSeller")),
			GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(GetPVarInt(playerid, "CreditsAmount")), number_format(GetPVarInt(playerid, "CreditsOffer")));
			Log("logs/sellcredits.log", szMessage), print(szMessage);
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "You have declined the credits offer.");
			SendClientMessageEx(GetPVarInt(playerid, "CreditsSeller"), COLOR_GREY, "Your credits offer has been declined.");
		}
		DeletePVar(playerid, "CreditsOffer");
		DeletePVar(playerid, "CreditsAmount");
		DeletePVar(playerid, "CreditsSeller");
		DeletePVar(playerid, "CreditsFirstAmount");
	}
	if(dialogid == DIALOG_TACKLED)
	{
		if(response) // complying
		{
			SetPVarInt(playerid, "TackledResisting", 1);
		}
		else // resisting
		{
			SetPVarInt(playerid, "TackledResisting", 2);
			format(string, sizeof(string), "** %s struggles with %s, attempting to escape.", GetPlayerNameEx(playerid), GetPlayerNameEx(GetPVarInt(playerid, "IsTackled")));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		}
	}
	if(dialogid == DIALOG_RIMMOD)
	{
		if(response)
		{
			new szRims[24];
			switch(listitem)
			{
				case 0: SetPVarInt(playerid, "RimMod", 1025), szRims = "Offroad";
				case 1: SetPVarInt(playerid, "RimMod", 1073), szRims = "Shadow";
				case 2: SetPVarInt(playerid, "RimMod", 1074), szRims = "Mega";
				case 3: SetPVarInt(playerid, "RimMod", 1075), szRims = "Rimshine";
				case 4: SetPVarInt(playerid, "RimMod", 1076), szRims = "Wires";
				case 5: SetPVarInt(playerid, "RimMod", 1077), szRims = "Classic";
				case 6: SetPVarInt(playerid, "RimMod", 1078), szRims = "Twist";
				case 7: SetPVarInt(playerid, "RimMod", 1079), szRims = "Cutter";
				case 8: SetPVarInt(playerid, "RimMod", 1080), szRims = "Switch";
				case 9: SetPVarInt(playerid, "RimMod", 1081), szRims = "Grove";
				case 10: SetPVarInt(playerid, "RimMod", 1082), szRims = "Import";
				case 11: SetPVarInt(playerid, "RimMod", 1083), szRims = "Dollar";
				case 12: SetPVarInt(playerid, "RimMod", 1084), szRims = "Trance";
				case 13: SetPVarInt(playerid, "RimMod", 1085), szRims = "Atomic";
				case 14: SetPVarInt(playerid, "RimMod", 1096), szRims = "Ahab";
				case 15: SetPVarInt(playerid, "RimMod", 1097), szRims = "Virtual";
				case 16: SetPVarInt(playerid, "RimMod", 1098), szRims = "Access";
			}
			new szMessage[128];
			format(szMessage, 128, "You are about to place %s rims on this vehicle.", szRims);
			ShowPlayerDialogEx(playerid, DIALOG_RIMMOD2, DIALOG_STYLE_MSGBOX, "Confirm Rims", szMessage, "Confirm", "Deny");
		}
	}
	if(dialogid == DIALOG_RIMMOD2)
	{
		if(response)
		{
			if(PlayerInfo[playerid][pRimMod] == 0)
				return SendClientMessageEx(playerid, COLOR_GREY, "You don't have any rim modification kits.");

			if(IsRestrictedVehicle(GetVehicleModel(GetPlayerVehicleID(playerid)))) return SendClientMessageEx(playerid, COLOR_GREY, "This vehicle cannot have rims applied to it");

			if(InvalidModCheck(GetVehicleModel(GetPlayerVehicleID(playerid)), 1025))
			{
				for(new d = 0 ; d < MAX_PLAYERVEHICLES; d++)
				{
					if(IsPlayerInVehicle(playerid, PlayerVehicleInfo[playerid][d][pvId]))
					{
						new szLog[128];
						format(szLog, sizeof(szLog), "%s(%d) has modded his vehicle with rims %d", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPVarInt(playerid, "RimMod"));
						Log("logs/rimkit.log", szLog);
						SendClientMessageEx(playerid, COLOR_GREEN, "You have successfully installed rims.");
						PlayerInfo[playerid][pRimMod]--;

						AddVehicleComponent(GetPlayerVehicleID(playerid), GetPVarInt(playerid, "RimMod"));
						DeletePVar(playerid, "RimMod");
						UpdatePlayerVehicleMods(playerid, d);
						return 1;
					}
				}
				SendClientMessageEx(playerid, COLOR_GREY, "You need to be in your vehicle.");
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GREY, "That vehicle can't be modded with rims.");
			}
		}
	}
	if(dialogid == DIALOG_PVIPVOUCHER)
	{
		if(response)
		{
			PlayerInfo[playerid][pPVIPVoucher]--;
			PlayerInfo[playerid][pTotalCredits] = ShopItems[21][sItemPrice];

			PlayerInfo[playerid][pDonateRank] = 4;
			PlayerInfo[playerid][pVIPExpire] = gettime()+2592000*1;
			PlayerInfo[playerid][pTempVIP] = 0;
			PlayerInfo[playerid][pBuddyInvited] = 0;
			PlayerInfo[playerid][pVIPSellable] = 1;

			LoadPlayerDisabledVehicles(playerid);

			if(PlayerInfo[playerid][pVIPM] == 0)
			{
				PlayerInfo[playerid][pVIPM] = VIPM;
				VIPM++;
			}
			format(string, sizeof(string), "%s(%d) (IP: %s) has used a 1 month PVIP Voucher.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid));
			Log("logs/credits.log", string);
			format(string, sizeof(string), "AdmCmd: %s's VIP level to Platinum (4) by the server (1 Month)(voucher).", GetPlayerNameEx(playerid));

			ABroadCast(COLOR_LIGHTRED, string, 2);
			format(string, sizeof(string), "AdmCmd: %s's(%d) VIP level to Platinum (4) by the server (1 Month)(voucher).", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid));
			Log("logs/setvip.log", string), Log("logs/vouchers.log", string);

			format(string, sizeof(string), "You have been issued your Platinum VIP and have %d PVIP Voucher(s) left.", PlayerInfo[playerid][pPVIPVoucher]);
			SendClientMessageEx(playerid, COLOR_CYAN, string);
			SendClientMessageEx(playerid, COLOR_CYAN, "** Your 1 month PVIP Voucher will expire in 1 Month.");
			PlayerInfo[playerid][pArmsSkill] = 1200;

			new szQuery[128];
			mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `accounts` SET `TotalCredits`=%d WHERE `id` = %d", PlayerInfo[playerid][pTotalCredits], GetPlayerSQLId(playerid));
			mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
		}
	}
	if(dialogid == GIVETOY)
	{
		if(response)
		{
			new giveplayerid = GetPVarInt(playerid, "giveplayeridtoy"),
				toyid = GetPVarInt(playerid, "toyid"),
				stringg[128];
			if(!toyCountCheck(giveplayerid)) return SendClientMessageEx(playerid, COLOR_YELLOW, "* This player cannot hold anymore toys!");
			if(PlayerToyInfo[giveplayerid][listitem][ptModelID] != 0) return SendClientMessageEx(playerid, COLOR_YELLOW, "* This player already has something in that specified slot!");

			PlayerToyInfo[giveplayerid][listitem][ptModelID] = toyid;
			PlayerToyInfo[giveplayerid][listitem][ptBone] = 1;
			PlayerToyInfo[giveplayerid][listitem][ptTradable] = 1;
			PlayerToyInfo[giveplayerid][listitem][ptSpecial] = 0;
			format(stringg, sizeof(stringg), "You have given %s object %d", GetPlayerNameEx(giveplayerid), toyid);
			SendClientMessageEx(playerid, COLOR_YELLOW, stringg);
			SendClientMessageEx(giveplayerid, COLOR_WHITE, "You have received a new toy from an administrator!");
			format(stringg, sizeof(stringg), "%s has given %s(%d) object %d", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), toyid);
			Log("logs/toys.log", stringg);
			DeletePVar(playerid, "giveplayeridtoy");
			DeletePVar(playerid, "toyid");
			new v = listitem; // lazy
			g_mysql_NewToy(giveplayerid, v);
		}
	}
	if(dialogid == PBFORCE)
	{
		new giveplayerid = GetPVarInt(playerid, "tempPBP");
		DeletePVar(playerid, "tempPSP");
		if(response)
		{
			if(PlayerInfo[playerid][pAdmin] >= 2)
			{
				if(IsPlayerConnected(giveplayerid))
				{
					if(GetPVarType(giveplayerid, "IsInArena"))
					{
						LeavePaintballArena(giveplayerid, GetPVarInt(giveplayerid, "IsInArena"));
						format(string, sizeof(string), "You have forced %s out of paintball. You may now teleport this player.", GetPlayerNameEx(giveplayerid));
						SendClientMessageEx(playerid, COLOR_WHITE, string);
						format(string, sizeof(string), "You have been forced out of paintball by %s.", GetPlayerNameEx(playerid));
						SendClientMessageEx(giveplayerid, COLOR_WHITE, string);
					}
					else
					{
						SendClientMessageEx(playerid, COLOR_WHITE, "This user is not in an active paintball match.");
					}
				}
				else
				{
					SendClientMessageEx(playerid, COLOR_GRAD2, "This user has logged off.");
				}
			}
		}
		else
		{
			if(PlayerInfo[playerid][pAdmin] >= 2)
			{
				if(IsPlayerConnected(giveplayerid))
				{
					format(string, sizeof(string), "%s will remain in the paintball match.", GetPlayerNameEx(giveplayerid));
					SendClientMessageEx(playerid, COLOR_WHITE, string);
				}
				else
				{
					SendClientMessageEx(playerid, COLOR_GRAD2, "This user has logged off.");
				}
			}
		}
	}
	if(dialogid == DISPLAY_STATS)
	{
		new targetid = GetPVarInt(playerid, "ShowStats");
		if(IsPlayerConnected(targetid))
		{
			if(response)
			{
				new resultline[1024], header[64], pvtstring[256], adminstring[128], advisorstring[128];

				if (PlayerInfo[playerid][pAdmin] >= 2)
				{
					format(pvtstring, sizeof(pvtstring), "House: %d\nHouse 2: %d\nHouse 3: %d\nRenting: %d\nInt: %d\nVW: %d\nReal VW: %d\nJail: %d sec\nWJail: %d sec\nVIPM: %i\nGVIP: %i\nReward Hours: %.2f\n", PlayerInfo[targetid][pPhousekey], PlayerInfo[targetid][pPhousekey2], PlayerInfo[targetid][pPhousekey3], PlayerInfo[targetid][pRenting],
					GetPlayerInterior(targetid), PlayerInfo[targetid][pVW], GetPlayerVirtualWorld(targetid), PlayerInfo[targetid][pJailTime], PlayerInfo[targetid][pBeingSentenced], PlayerInfo[targetid][pVIPM], PlayerInfo[targetid][pGVip], PlayerInfo[targetid][pRewardHours]);
				}
				if(PlayerInfo[playerid][pAdmin] >= 4 && PlayerInfo[targetid][pAdmin] >= 2) format(adminstring, sizeof(adminstring), "Accepted Reports: %s\nTrashed Reports: %s\n", number_format(PlayerInfo[targetid][pAcceptReport]), number_format(PlayerInfo[targetid][pTrashReport]));
				if((PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pPR] >= 1 || PlayerInfo[playerid][pASM] >= 1) && PlayerInfo[targetid][pHelper] >= 2) format(advisorstring, sizeof(advisorstring), "Hours on Duty: %s\nAccepted Help Requests: %s\n", number_format(PlayerInfo[targetid][pDutyHours]), number_format(PlayerInfo[targetid][pAcceptedHelp]));

				format(header, sizeof(header), "Showing Statistics of %s", GetPlayerNameEx(targetid));
				format(resultline, sizeof(resultline),"{FFFFFF}Wanted Level: %d\n\
					Crimes: %s\n\
					Arrests: %s\n\
					Referrals: %s\n\
					Warnings: %s\n\
					Weapon Restriction: %s hour(s)\n\
					Gang Warnings: %s\n\
					Newbie Chat Mutes: %s\n\
					Advertisement Mutes: %s\n\
					Report Mutes: %s\n\
					%s\
					%s\
					%s",
					PlayerInfo[targetid][pWantedLevel],
					number_format(PlayerInfo[targetid][pCrimes]),
					number_format(PlayerInfo[targetid][pArrested]),
					number_format(PlayerInfo[targetid][pRefers]),
					number_format(PlayerInfo[targetid][pWarns]),
					number_format(PlayerInfo[targetid][pWRestricted]),
					number_format(PlayerInfo[targetid][pGangWarn]),
					number_format(PlayerInfo[targetid][pNMuteTotal]),
					number_format(PlayerInfo[targetid][pADMuteTotal]),
					number_format(PlayerInfo[targetid][pRMutedTotal]),
					pvtstring,
					advisorstring,
					adminstring);
				ShowPlayerDialogEx(playerid, DISPLAY_STATS2, DIALOG_STYLE_MSGBOX, header, resultline, "First Page", "Close");
			}
			else DeletePVar(playerid, "ShowStats");
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GRAD1, "The player you were checking has logged out.");
			DeletePVar(playerid, "ShowStats");
			return 1;
		}
	}
	if(dialogid == DISPLAY_STATS2)
	{
		new targetid = GetPVarInt(playerid, "ShowStats");
		if(IsPlayerConnected(targetid))
		{
			if(response)
			{
				ShowStats(playerid, targetid);
			}
			else DeletePVar(playerid, "ShowStats");
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GRAD1, "The player you were checking has logged out.");
			DeletePVar(playerid, "ShowStats");
			return 1;
		}
	}
	#if defined event_chancegambler
	if(dialogid == DIALOG_ROLL)
	{
		if(response)
		{
			if(FIFEnabled == 1)
			{
				new iNumber = Random(1, 11);
				if(iNumber > 4)
				{
					new szMessage[128];
					format(szMessage, sizeof(szMessage), "You have rolled %d and doubled your chances!", iNumber);
					SendClientMessageEx(playerid, COLOR_CYAN, szMessage);
					format(szMessage, sizeof(szMessage), "* %s has rolled %d and doubled his chances!", GetPlayerNameEx(playerid), iNumber);
					ProxDetector(30.0, playerid, szMessage, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
					FIFInfo[playerid][FIFChances] *= 2;
					format(szMessage, sizeof(szMessage), "%s (IP:%s) has doubled their chances. (Chances: %d)", GetPlayerNameEx(playerid), GetPlayerIpEx(playerid), FIFInfo[playerid][FIFChances]);
					Log("logs/gamblechances.log", szMessage);
				}
				else
				{
					new szMessage[128];
					format(szMessage, sizeof(szMessage), "* %s has rolled %d and lost it all!", GetPlayerNameEx(playerid), iNumber);
					ProxDetector(30.0, playerid, szMessage, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
					format(szMessage, sizeof(szMessage), "You have rolled %d and lost it all!", iNumber);
					SendClientMessageEx(playerid, COLOR_CYAN, szMessage);
					FIFInfo[playerid][FIFChances] = 0;
					format(szMessage, sizeof(szMessage), "%s (IP:%s) has lost it all. (Chances: %d)", GetPlayerNameEx(playerid), GetPlayerIpEx(playerid), FIFInfo[playerid][FIFChances]);
					Log("logs/gamblechances.log", szMessage);
				}
			}
		}
	}
	if(dialogid == DIALOG_HUNGERGAMES)
	{
		if(response)
		{
			if(PlayerInfo[playerid][pHungerVoucher] == 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "You do not have any Hunger Games Vouchers.");
			SendClientMessageEx(playerid, COLOR_CYAN, "You have used a Hunger Games Voucher and will have 100 HP instead of 50 for the event and will receive a free MP5.");
			PlayerInfo[playerid][pHungerVoucher]--;

			SetPVarInt(playerid, "HungerVoucher", 1);
		}
	}
	#endif
	if(dialogid == DIALOG_NRNCONFIRM)
	{
		if(response)
		{
			new playersz[5];
			GetPVarString(playerid, "nrn", playersz, 5);
			DeletePVar(playerid, "nrn");
			cmd_nrn(playerid, playersz);
		}
		else
		{
			DeletePVar(playerid, "nrn");
		}
	}
	if(dialogid == DIALOG_CONFIRMADP)
	{
		if(response)
		{
			new advert[256], reportid = GetPVarInt(playerid, "ReporterID");
			new szString[128], shared;
			GetPVarString(reportid, "PriorityAdText", advert, 128);
			if(isnull(advert) || !IsPlayerConnected(reportid))
			{
				DeletePVar(playerid, "ReporterID");
				DeletePVar(reportid, "PriorityAdText");
				DeletePVar(reportid, "RequestingAdP");
				DeletePVar(reportid, "AdvertVoucher");
				return SendClientMessageEx(playerid, -1, "There was a issue with the advertisement, the ad was empty and/or the player logged out.");
			}
			// Do not comment this out! This is needed to re-format the ad with the proper format - Nathan
			format(advert, sizeof(advert), "Advertisement: %s - contact: %s (%d)", advert, GetPlayerNameEx(reportid), PlayerInfo[reportid][pPnumber]);
			SendClientMessageEx(reportid, -1, "Your Priority Advertisement has been approved & published.");
			if(GetPVarInt(reportid, "AdvertVoucher") > 0)
			{
				SendClientMessageEx(reportid, COLOR_CYAN, "You have used 1 Priority Advertisement.");
				PlayerInfo[reportid][pAdvertVoucher]--;
			}
			else if(PlayerInfo[reportid][pFreeAdsLeft] > 0 && PlayerInfo[reportid][pDonateRank] >= 4)
			{
				PlayerInfo[reportid][pFreeAdsLeft]--;
				format(szString, sizeof(szString), "Platinum VIP: You have used a free advertisement, you have %d left for today.", PlayerInfo[reportid][pFreeAdsLeft]);
				SendClientMessageEx(reportid, COLOR_YELLOW, szString);
			}
			else if(PlayerInfo[reportid][pDonateRank] == 2)
			{
				GivePlayerCash(reportid, -125000);
				shared = 125000 / 3;
				SendClientMessageEx(reportid, COLOR_YELLOW, "VIP Discount: You have paid $125,000 for being Silver VIP.");
			}
			else if(PlayerInfo[reportid][pDonateRank] == 3)
			{
				GivePlayerCash(reportid, -100000);
				shared = 100000 / 3;
				SendClientMessageEx(reportid, COLOR_YELLOW, "VIP Discount: You have paid $100,000 for being Gold VIP.");
			}
			else if(PlayerInfo[reportid][pDonateRank] >= 4)
			{
				GivePlayerCash(reportid, -50000);
				shared = 50000 / 3;
				SendClientMessageEx(reportid, COLOR_YELLOW, "VIP Discount: You have paid $50,000 for being Platinum VIP.");
			}
			else
			{
				GivePlayerCash(reportid, -150000);
				shared = 150000 / 3;
			}
			iAdverTimer = gettime()+30;

			if(shared > 0)
			{
				for(new x; x < MAX_GROUPS; x++)
				{
					if(arrGroupData[x][g_iGroupType] == GROUP_TYPE_NEWS)
					{
						arrGroupData[x][g_iBudget] += shared;
					}
				}
			}

			foreach(new i: Player)
			{
				if(!gNews[i] && InsideMainMenu{i} != 1 && InsideTut{i} != 1 && ActiveChatbox[i] != 0) SendClientMessage(i, TEAM_GROVE_COLOR, advert);
			}
			format(advert, sizeof(advert), "%s -- (SQLID: %d) | Accepted by: %s -- (SQLID: %d)", advert, GetPlayerSQLId(reportid), GetPlayerNameEx(playerid), GetPlayerSQLId(playerid));
			Log("logs/pads.log", advert);

			/*if(Homes[reportid] > 0 && AdvertType[reportid] == 1 && !PlayerInfo[playerid][pShopNotice])
			{
				PlayerTextDrawSetString(reportid, MicroNotice[reportid], ShopMsg[6]);
				PlayerTextDrawShow(reportid, MicroNotice[reportid]);
				SetTimerEx("HidePlayerTextDraw", 10000, false, "ii", reportid, _:MicroNotice[reportid]);
			}*/

			DeletePVar(reportid, "PriorityAdText");
			DeletePVar(playerid, "ReporterID");
			DeletePVar(reportid, "RequestingAdP");
			DeletePVar(reportid, "AdvertVoucher");
		}
		else
		{
			SendClientMessageEx(GetPVarInt(playerid, "ReporterID"), -1, "Your priority advertisement has been denied.");
			szAdvert[GetPVarInt(playerid, "ReporterID")][0] = 0;
			DeletePVar(GetPVarInt(playerid, "ReporterID"), "PriorityAdText");
			DeletePVar(GetPVarInt(playerid, "ReporterID"), "AdvertVoucher");
			DeletePVar(GetPVarInt(playerid, "ReporterID"), "RequestingAdP");
			DeletePVar(playerid, "ReporterID");
		}
	}
	if(dialogid == DIALOG_GIFTBOX_INFO)
	{
		if(response)
		{
			return ShowPlayerDynamicGiftBox(playerid);
		}
	}
	if(dialogid == DIALOG_GIFTBOX_VIEW)
	{
		if(response)
		{
			if(PlayerInfo[playerid][pAdmin] < 99999 && PlayerInfo[playerid][pShopTech] < 3) return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not authorized to use this command!");
			switch(listitem)
			{
				case 1:
				{
					format(string, sizeof(string), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgVar[dgMoney][0], dgVar[dgMoney][1], dgVar[dgMoney][2], GetDynamicGiftBoxType(dgVar[dgMoney][3]));
					ShowPlayerDialogEx(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - Money", string, "Back", "");
				}
				case 2:
				{
					format(string, sizeof(string), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgVar[dgRimKit][0], dgVar[dgRimKit][1], dgVar[dgRimKit][2], GetDynamicGiftBoxType(dgVar[dgRimKit][3]));
					ShowPlayerDialogEx(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - Rimkit", string, "Back", "");
				}
				case 3:
				{
					format(string, sizeof(string), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgVar[dgFirework][0], dgVar[dgFirework][1], dgVar[dgFirework][2], GetDynamicGiftBoxType(dgVar[dgFirework][3]));
					ShowPlayerDialogEx(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - Firework", string, "Back", "");
				}
				case 4:
				{
					format(string, sizeof(string), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgVar[dgGVIP][0], dgVar[dgGVIP][1], dgVar[dgGVIP][2], GetDynamicGiftBoxType(dgVar[dgGVIP][3]));
					ShowPlayerDialogEx(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - 7 Day GVIP", string, "Back", "");
				}
				case 5:
				{
					format(string, sizeof(string), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgVar[dgGVIPEx][0], dgVar[dgGVIPEx][1], dgVar[dgGVIPEx][2], GetDynamicGiftBoxType(dgVar[dgGVIPEx][3]));
					ShowPlayerDialogEx(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - 1 Month GVIP", string, "Back", "");
				}
				case 6:
				{
					format(string, sizeof(string), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgVar[dgSVIP][0], dgVar[dgSVIP][1], dgVar[dgSVIP][2], GetDynamicGiftBoxType(dgVar[dgSVIP][3]));
					ShowPlayerDialogEx(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - 7 Day SVIP", string, "Back", "");
				}
				case 7:
				{
					format(string, sizeof(string), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgVar[dgSVIPEx][0], dgVar[dgSVIPEx][1], dgVar[dgSVIPEx][2], GetDynamicGiftBoxType(dgVar[dgSVIPEx][3]));
					ShowPlayerDialogEx(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - 1 Month SVIP", string, "Back", "");
				}
				case 8:
				{
					format(string, sizeof(string), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgVar[dgCarSlot][0], dgVar[dgCarSlot][1], dgVar[dgCarSlot][2], GetDynamicGiftBoxType(dgVar[dgCarSlot][3]));
					ShowPlayerDialogEx(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - Car Slot", string, "Back", "");
				}
				case 9:
				{
					format(string, sizeof(string), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgVar[dgToySlot][0], dgVar[dgToySlot][1], dgVar[dgToySlot][2], GetDynamicGiftBoxType(dgVar[dgToySlot][3]));
					ShowPlayerDialogEx(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - Toy Slot", string, "Back", "");
				}
				case 10:
				{
					format(string, sizeof(string), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgVar[dgArmor][0], dgVar[dgArmor][1], dgVar[dgArmor][2], GetDynamicGiftBoxType(dgVar[dgArmor][3]));
					ShowPlayerDialogEx(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - Armor", string, "Back", "");
				}
				case 11:
				{
					format(string, sizeof(string), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgVar[dgFirstaid][0], dgVar[dgFirstaid][1], dgVar[dgFirstaid][2], GetDynamicGiftBoxType(dgVar[dgFirstaid][3]));
					ShowPlayerDialogEx(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - Firstaid", string, "Back", "");
				}
				case 12:
				{
					format(string, sizeof(string), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgVar[dgDDFlag][0], dgVar[dgDDFlag][1], dgVar[dgDDFlag][2], GetDynamicGiftBoxType(dgVar[dgDDFlag][3]));
					ShowPlayerDialogEx(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - Dynamic Door Flag", string, "Back", "");
				}
				case 13:
				{
					format(string, sizeof(string), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgVar[dgGateFlag][0], dgVar[dgGateFlag][1], dgVar[dgGateFlag][2], GetDynamicGiftBoxType(dgVar[dgGateFlag][3]));
					ShowPlayerDialogEx(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - Dynamic Gate Flag", string, "Back", "");
				}
				case 14:
				{
					format(string, sizeof(string), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgVar[dgCredits][0], dgVar[dgCredits][1], dgVar[dgCredits][2], GetDynamicGiftBoxType(dgVar[dgCredits][3]));
					ShowPlayerDialogEx(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - Credits", string, "Back", "");
				}
				case 15:
				{
					format(string, sizeof(string), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgVar[dgPriorityAd][0], dgVar[dgPriorityAd][1], dgVar[dgPriorityAd][2], GetDynamicGiftBoxType(dgVar[dgPriorityAd][3]));
					ShowPlayerDialogEx(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - Priority Advertisement", string, "Back", "");
				}
				case 16:
				{
					format(string, sizeof(string), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgVar[dgHealthNArmor][0], dgVar[dgHealthNArmor][1], dgVar[dgHealthNArmor][2], GetDynamicGiftBoxType(dgVar[dgHealthNArmor][3]));
					ShowPlayerDialogEx(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - Health & Armor", string, "Back", "");
				}
				case 17:
				{
					format(string, sizeof(string), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgVar[dgGiftReset][0], dgVar[dgGiftReset][1], dgVar[dgGiftReset][2], GetDynamicGiftBoxType(dgVar[dgGiftReset][3]));
					ShowPlayerDialogEx(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - Gift Reset", string, "Back", "");
				}
				case 18:
				{
					format(string, sizeof(string), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgVar[dgMaterial][0], dgVar[dgMaterial][1], dgVar[dgMaterial][2], GetDynamicGiftBoxType(dgVar[dgMaterial][3]));
					ShowPlayerDialogEx(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - Material", string, "Back", "");
				}
				case 19:
				{
					format(string, sizeof(string), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgVar[dgWarning][0], dgVar[dgWarning][1], dgVar[dgWarning][2], GetDynamicGiftBoxType(dgVar[dgWarning][3]));
					ShowPlayerDialogEx(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - Warning", string, "Back", "");
				}
				case 20:
				{
					format(string, sizeof(string), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgVar[dgPot][0], dgVar[dgPot][1], dgVar[dgPot][2], GetDynamicGiftBoxType(dgVar[dgPot][3]));
					ShowPlayerDialogEx(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - Cannabis", string, "Back", "");
				}
				case 21:
				{
					format(string, sizeof(string), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgVar[dgCrack][0], dgVar[dgCrack][1], dgVar[dgCrack][2], GetDynamicGiftBoxType(dgVar[dgCrack][3]));
					ShowPlayerDialogEx(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - Crack", string, "Back", "");
				}
				case 22:
				{
					format(string, sizeof(string), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgVar[dgPaintballToken][0], dgVar[dgPaintballToken][1], dgVar[dgPaintballToken][2], GetDynamicGiftBoxType(dgVar[dgPaintballToken][3]));
					ShowPlayerDialogEx(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - Paintball Token", string, "Back", "");
				}
				case 23:
				{
					format(string, sizeof(string), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgVar[dgVIPToken][0], dgVar[dgVIPToken][1], dgVar[dgVIPToken][2], GetDynamicGiftBoxType(dgVar[dgVIPToken][3]));
					ShowPlayerDialogEx(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - VIP Token", string, "Back", "");
				}
				case 24:
				{
					format(string, sizeof(string), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgVar[dgRespectPoint][0], dgVar[dgRespectPoint][1], dgVar[dgRespectPoint][2], GetDynamicGiftBoxType(dgVar[dgRespectPoint][3]));
					ShowPlayerDialogEx(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - Respect Point", string, "Back", "");
				}
				case 25:
				{
					format(string, sizeof(string), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgVar[dgCarVoucher][0], dgVar[dgCarVoucher][1], dgVar[dgCarVoucher][2], GetDynamicGiftBoxType(dgVar[dgCarVoucher][3]));
					ShowPlayerDialogEx(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - Car Voucher", string, "Back", "");
				}
				case 26:
				{
					format(string, sizeof(string), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgVar[dgBuddyInvite][0], dgVar[dgBuddyInvite][1], dgVar[dgBuddyInvite][2], GetDynamicGiftBoxType(dgVar[dgBuddyInvite][3]));
					ShowPlayerDialogEx(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - Buddy Invite", string, "Back", "");
				}
				case 27:
				{
					format(string, sizeof(string), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgVar[dgLaser][0], dgVar[dgLaser][1], dgVar[dgLaser][2], GetDynamicGiftBoxType(dgVar[dgLaser][3]));
					ShowPlayerDialogEx(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - Laser", string, "Back", "");
				}
				case 28:
				{
					format(string, sizeof(string), "Enabled: %d\nStock: %d\nToy ID: %d\nGift Type: %s", dgVar[dgCustomToy][0], dgVar[dgCustomToy][1], dgVar[dgCustomToy][2], GetDynamicGiftBoxType(dgVar[dgCustomToy][3]));
					ShowPlayerDialogEx(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - Custom Toy", string, "Back", "");
				}
				case 29:
				{
					format(string, sizeof(string), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgVar[dgAdmuteReset][0], dgVar[dgAdmuteReset][1], dgVar[dgAdmuteReset][2], GetDynamicGiftBoxType(dgVar[dgAdmuteReset][3]));
					ShowPlayerDialogEx(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - Advertisement Mute Reset", string, "Back", "");
				}
				case 30:
				{
					format(string, sizeof(string), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgVar[dgNewbieMuteReset][0], dgVar[dgNewbieMuteReset][1], dgVar[dgNewbieMuteReset][2], GetDynamicGiftBoxType(dgVar[dgNewbieMuteReset][3]));
					ShowPlayerDialogEx(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - Newbie Mute Reset", string, "Back", "");
				}
				case 31:
				{
					format(string, sizeof(string), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgVar[dgRestrictedCarVoucher][0], dgVar[dgRestrictedCarVoucher][1], dgVar[dgRestrictedCarVoucher][2], GetDynamicGiftBoxType(dgVar[dgRestrictedCarVoucher][3]));
					ShowPlayerDialogEx(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - Restricted Car Voucher", string, "Back", "");
				}
				case 32:
				{
					format(string, sizeof(string), "Enabled: %d\nStock: %d\nGift Quantity: %d\nGift Type: %s", dgVar[dgPlatinumVIPVoucher][0], dgVar[dgPlatinumVIPVoucher][1], dgVar[dgPlatinumVIPVoucher][2], GetDynamicGiftBoxType(dgVar[dgPlatinumVIPVoucher][3]));
					ShowPlayerDialogEx(playerid, DIALOG_GIFTBOX_INFO, DIALOG_STYLE_MSGBOX, "Dynamic Giftbox - 1 month PVIP Voucher", string, "Back", "");
				}
				default: return true;
			}
		}
	}
	if(dialogid == DIALOG_VIPSPAWN)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SetPVarInt(playerid, "VIPSpawn", 1);
					SendClientMessageEx(playerid, COLOR_CYAN, "You have used your free spawn at the Gold VIP+ room, you will be spawned at Los Santos VIP in 60 seconds.");
				}
				case 1:
				{
					SetPVarInt(playerid, "VIPSpawn", 2);
					SendClientMessageEx(playerid, COLOR_CYAN, "You have used your free spawn at the Gold VIP+ room, you will be spawned at San Fierro VIP in 60 seconds.");
				}
				case 2:
				{
					SetPVarInt(playerid, "VIPSpawn", 3);
					SendClientMessageEx(playerid, COLOR_CYAN, "You have used your free spawn at the Gold VIP+ room, you will be spawned at Las Ventures VIP in 60 seconds.");
				}
				case 3:
				{
					SetPVarInt(playerid, "VIPSpawn", 4);
					SendClientMessageEx(playerid, COLOR_GREY, "You have not used your free spawn at the Gold VIP+ room this time.");
				}
			}
			SetPlayerSpawn(playerid);
		}
		else
		{
			SetPVarInt(playerid, "VIPSpawn", 4);
			SendClientMessageEx(playerid, COLOR_GREY, "You have not used your free spawn at Gold VIP+ room this time.");
			SetPlayerSpawn(playerid);
		}
	}
	if(dialogid == DIALOG_NONRPACTION)
	{
		if(response)
		{
			ResetPlayerWeaponsEx(GetPVarInt(playerid, "PendingAction4"));
			PlayerInfo[GetPVarInt(playerid, "PendingAction4")][pAccountRestricted] = 1;
			SendClientMessageEx(playerid, COLOR_RED, "You have restricted this player account.");
			PlayerTextDrawShow(GetPVarInt(playerid, "PendingAction4"), AccountRestriction[GetPVarInt(playerid, "PendingAction4")]);
			PlayerTextDrawShow(GetPVarInt(playerid, "PendingAction4"), AccountRestrictionEx[GetPVarInt(playerid, "PendingAction4")]);
			format(string, sizeof(string), "%s has restricted %s(%d) account", GetPlayerNameEx(playerid), GetPlayerNameEx(GetPVarInt(playerid, "PendingAction4")), GetPlayerSQLId(GetPVarInt(playerid, "PendingAction4")));
			Log("logs/restrictaccount.log", string);
			return DeletePVar(playerid, "PendingAction4");
		}
		else
		{
			DeletePVar(playerid, "PendingAction4");
			return SendClientMessageEx(playerid, COLOR_GRAD1, "You have decided to not restrict this player account.");
		}
	}
	if(dialogid == DIALOG_VIPJOB)
	{
		if(response && PlayerInfo[playerid][pDonateRank] >= 4 && PlayerInfo[playerid][pVIPJob] > 0)
		{
			switch(listitem)
			{
				case 0:
				{
					if(PlayerInfo[playerid][pDetSkill] >= 400)
					{
						SendClientMessageEx(playerid, COLOR_GREY, "Your skill level of this job is already the highest one.");
						return 1;
					}
					PlayerInfo[playerid][pDetSkill] = 400;
					SendClientMessageEx(playerid, COLOR_YELLOW, "Your Detective skill level has been set to 5.");
				}
				case 1:
				{
					if(PlayerInfo[playerid][pLawSkill] >= 400)
					{
						SendClientMessageEx(playerid, COLOR_GREY, "Your skill level of this job is already the highest one.");
						return 1;
					}
					PlayerInfo[playerid][pLawSkill] = 400;
					SendClientMessageEx(playerid, COLOR_YELLOW, "Your Lawyer skill level has been set to 5.");
				}
				case 2:
				{
					if(PlayerInfo[playerid][pSexSkill] >= 400)
					{
						SendClientMessageEx(playerid, COLOR_GREY, "Your skill level of this job is already the highest one.");
						return 1;
					}
					PlayerInfo[playerid][pSexSkill] = 400;
					SendClientMessageEx(playerid, COLOR_YELLOW, "Your Whore skill level has been set to 5.");
				}
				case 3:
				{
					return 1;
				}
				case 4:
				{
					if(PlayerInfo[playerid][pDrugSmuggler] >= 200)
					{
						SendClientMessageEx(playerid, COLOR_GREY, "Your skill level of this job is already the highest one.");
						return 1;
					}
					PlayerInfo[playerid][pDrugSmuggler] = 200;
					SendClientMessageEx(playerid, COLOR_YELLOW, "Your Drugs Smuggling skill level has been set to 5.");
				}
				case 5:
				{
					if(PlayerInfo[playerid][pArmsSkill] >= 1200)
					{
						SendClientMessageEx(playerid, COLOR_GREY, "Your skill level of this job is already the highest one.");
						return 1;
					}
					PlayerInfo[playerid][pArmsSkill] = 1200;
					SendClientMessageEx(playerid, COLOR_YELLOW, "Your Arms Dealer skill level has been set to 5.");
				}
				case 6:
				{
					if(PlayerInfo[playerid][pMechSkill] >= 400)
					{
						SendClientMessageEx(playerid, COLOR_GREY, "Your skill level of this job is already the highest one.");
						return 1;
					}
					PlayerInfo[playerid][pMechSkill] = 400;
					SendClientMessageEx(playerid, COLOR_YELLOW, "Your Car Mechanic skill level has been set to 5.");
				}
				case 7:
				{
					if(PlayerInfo[playerid][pBoxSkill] >= 400)
					{
						SendClientMessageEx(playerid, COLOR_GREY, "Your skill level of this job is already the highest one.");
						return 1;
					}
					PlayerInfo[playerid][pBoxSkill] = 400;
					SendClientMessageEx(playerid, COLOR_YELLOW, "Your Boxer skill level has been set to 5.");
				}
				case 8:
				{
					if(PlayerInfo[playerid][pFishSkill] >= 400)
					{
						SendClientMessageEx(playerid, COLOR_GREY, "Your skill level of this job is already the highest one.");
						return 1;
					}
					PlayerInfo[playerid][pFishSkill] = 400;
					SendClientMessageEx(playerid, COLOR_YELLOW, "Your Fishing skill level has been set to 5.");
				}
				case 9:
				{
					if(PlayerInfo[playerid][pTruckSkill] >= 401)
					{
						SendClientMessageEx(playerid, COLOR_GREY, "Your skill level of this job is already the highest one.");
						return 1;
					}
					PlayerInfo[playerid][pTruckSkill] = 401;
					SendClientMessageEx(playerid, COLOR_YELLOW, "Your Shipment Contractor skill level has been set to 5.");
				}
				/* case 10:
				{
					if(PlayerInfo[playerid][pTreasureSkill] >= 600)
					{
						SendClientMessageEx(playerid, COLOR_GREY, "Your skill level of this job is already the highest one.");
						return 1;
					}
					PlayerInfo[playerid][pTreasureSkill] = 600;
					SendClientMessageEx(playerid, COLOR_YELLOW, "Your Treasure Hunter skill level has been set to 5.");
				} */
				case 10:
				{
					if(PlayerInfo[playerid][pCarLockPickSkill] >= 350)
						return SendClientMessageEx(playerid, COLOR_GREY, "Your skill level of this job is already the highest one.");
					PlayerInfo[playerid][pCarLockPickSkill] = 350;
					SendClientMessageEx(playerid, COLOR_YELLOW, "Your Lock Picking skill level has been set to 5.");
				}
			}
			PlayerInfo[playerid][pVIPJob] = 0;
			OnPlayerStatsUpdate(playerid);
		}
	}
	if(dialogid == DIALOG_WDREPORT)
	{
		if(!response || strlen(inputtext) < 30)
		{
			format(string, sizeof(string), "Please write a brief report on what you watched %s do.\n * 30 characters min", GetPlayerNameEx(GetPVarInt(playerid, "SpectatingWatch")));
			return ShowPlayerDialogEx(playerid, DIALOG_WDREPORT, DIALOG_STYLE_INPUT, "Incident Report", string, "Submit", "");
		}
		new szQuery[256];
		mysql_format(MainPipeline, szQuery, sizeof(szQuery), "INSERT INTO `watchdog_reports` (reporter, report, reported, type, time) VALUES ('%d', '%e', '%d', '%d', UNIX_TIMESTAMP())", GetPlayerSQLId(playerid), inputtext, GetPlayerSQLId(GetPVarInt(playerid, "SpectatingWatch")), GetPVarInt(playerid, "WDReport"));
		mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
		SendClientMessageEx(playerid, COLOR_GRAD4, inputtext);
		SendClientMessageEx(playerid, COLOR_GRAD1, "Incident Report successfully submitted.");
	}
	if(dialogid == DIALOG_DGRAUTORESET)
	{
		if(!response && GetPVarType(playerid, "dgInputSel")) return cmd_dgedit(playerid, "autoreset");
		if(response)
		{
			if(listitem == 0)
			{
				SetPVarInt(playerid, "dgInputSel", 1);
				return ShowPlayerDialogEx(playerid, DIALOG_DGRAUTORESET, DIALOG_STYLE_INPUT, "Dynamic Giftbox Auto Reset - Timer", "Please enter a interval in minutes of when you want the giftbox to be automatically reset.", "Submit", "Close");
			}
			if(listitem == 1)
			{
				SetPVarInt(playerid, "dgInputSel", 2);
				return ShowPlayerDialogEx(playerid, DIALOG_DGRAUTORESET, DIALOG_STYLE_INPUT, "Dynamic Giftbox Auto Reset - Amount", "Please enter a amount to be added to empty items when the giftbox is automatically reset.", "Submit", "Close");
			}
			if(listitem == 2)
			{
				if(dgTimer != -1)
				{
					KillTimer(dgTimer);
					dgTimer = -1;
					SendClientMessage(playerid, -1, "You have successfully disabled the auto reset feature.");
				}
				else
				{
					if(!dynamicgift) return SendClientMessageEx(playerid, -1, "Giftbox has not been placed!");
					if(IsDynamicGiftBoxEnabled == false) return SendClientMessageEx(playerid, -1, "Dynamic Giftbox is currently disabled! /togdynamicgift to enable.");
					if(dgTimerTime <= 0 || dgAmount <= 0) return SendClientMessageEx(playerid, -1, "Invalid Settings!");
					dgTimer = SetTimer("DG_AutoReset", dgTimerTime*60000, true);
					format(string, sizeof(string), "You have enabled the auto reset feature. Settings: Timer: %d minute(s) | Amount: %d", dgTimerTime, dgAmount);
					SendClientMessageEx(playerid, -1, string);
				}
			}
			if(GetPVarInt(playerid, "dgInputSel") == 1)
			{
				new _time;
				if(sscanf(inputtext, "d", _time) || _time <= 0) return ShowPlayerDialogEx(playerid, DIALOG_DGRAUTORESET, DIALOG_STYLE_INPUT, "Dynamic Giftbox Auto Reset - Timer", "Please enter a interval in minutes of when you want the giftbox to be automatically reset.", "Submit", "Close");
				dgTimerTime = _time;
				format(string, sizeof(string), "You have set the auto reset timer to: %d minute(s).", dgTimerTime);
				SendClientMessageEx(playerid, -1, string);
			}
			if(GetPVarInt(playerid, "dgInputSel") == 2)
			{
				new _amount;
				if(sscanf(inputtext, "d", _amount) || _amount <= 0) return ShowPlayerDialogEx(playerid, DIALOG_DGRAUTORESET, DIALOG_STYLE_INPUT, "Dynamic Giftbox Auto Reset - Amount", "Please enter a amount to be added to empty items when the giftbox is automatically reset.", "Submit", "Close");
				dgAmount = _amount;
				format(string, sizeof(string), "You have set the auto reset amount to: %d.", dgAmount);
				SendClientMessageEx(playerid, -1, string);
			}
			return cmd_dgedit(playerid, "autoreset");
		}
	}
	if(dialogid == DIALOG_MARRIAGE)
	{
		if(response)
		{
			SetPVarInt(playerid, "marriagelastname", 1);
			SendClientMessageEx(playerid, -1, "You have chosen to keep your last name.");
		}
		else
		{
			SetPVarInt(playerid, "marriagelastname", 2);
			SendClientMessageEx(playerid, -1, "You have chosen to take your spouse's last name.");
		}
	}
	if(dialogid == FLAG_TRANSFER)
	{
		if(response)
		{
			GetPVarString(playerid, "FlagText", string, sizeof(string));
			DeleteFlag(GetPVarInt(playerid, "Flag_Transfer_ID"), playerid);
			format(string, sizeof(string), "%s [Transfered from: %s]", string, GetPlayerNameEx(GetPVarInt(playerid, "Flag_Transfer_From")));
			AddFlag(GetPVarInt(playerid, "Flag_Transfer_To"), playerid, string);
			format(string, sizeof(string), "You have successfully transferred FlagID: %d To: %s From: %s", GetPVarInt(playerid, "Flag_Transfer_ID"), GetPlayerNameEx(GetPVarInt(playerid, "Flag_Transfer_To")), GetPlayerNameEx(GetPVarInt(playerid, "Flag_Transfer_From")));
			SendClientMessageEx(playerid, -1, string);
			format(string, sizeof(string), "[TRANSFER] %s has transferred FlagID: %d To: %s(%d) From: %s(%d)", GetPlayerNameEx(playerid), GetPVarInt(playerid, "Flag_Transfer_ID"), GetPlayerNameEx(GetPVarInt(playerid, "Flag_Transfer_To")), GetPlayerSQLId(GetPVarInt(playerid, "Flag_Transfer_To")), GetPlayerNameEx(GetPVarInt(playerid, "Flag_Transfer_From")), GetPlayerSQLId(GetPVarInt(playerid, "Flag_Transfer_From")));
			Log("logs/flags.log", string);
			DeletePVar(playerid, "Flag_Transfer_ID");
			DeletePVar(playerid, "Flag_Transfer_To");
			DeletePVar(playerid, "Flag_Transfer_From");
			DeletePVar(playerid, "FlagText");
		}
		else
		{
			DeletePVar(playerid, "Flag_Transfer_ID");
			DeletePVar(playerid, "Flag_Transfer_To");
			DeletePVar(playerid, "Flag_Transfer_From");
			DeletePVar(playerid, "FlagText");
			SendClientMessageEx(playerid, -1, "You have cancelled yourself from transferring the flag!");
		}
	}
	if(dialogid == DIALOG_SETEXAMINE)
	{
		if(response)
		{
			if(isnull(inputtext)) return ShowPlayerDialogEx(playerid, DIALOG_SETEXAMINE, DIALOG_STYLE_INPUT, "Examine Description", "Please enter a description of yourself.\nExample: appears to be a white male, 6' 3 ..etc", "Set", "Cancel");
			format(PlayerInfo[playerid][pExamineDesc], 128, "%s", inputtext);
		}
		else
		{
			SendClientMessageEx(playerid, -1, "You have cancelled yourself from setting your examine description.");
		}
	}
	if(dialogid == DIALOG_HOLSTER && response)
	{
		if(listitem == 0)
		{
			GameTextForPlayer(playerid, "holstering", 1000, 6);
		}
		else
		{
			GameTextForPlayer(playerid, "unholstering", 1000, 6);
		}

		SetTimerEx("UnholsterWeapon", 1000, false, "ii", playerid, listitem);
	}
	if(dialogid == DIALOG_MICROSHOP)
	{
		if(response)
		{
			new stringg[512];
			if(listitem == 0)
			{
				format(stringg, sizeof(stringg), "%s (Credits: {FFD700}%s{FFFFFF})\n%s (Credits: {FFD700}%s{FFFFFF})\nDouble EXP Tokens (Credits: {FFD700}%s{FFFFFF})", mItemName[0], number_format(MicroItems[0]), mItemName[1], number_format(MicroItems[1]), number_format(ShopItems[9][sItemPrice]));
				ShowPlayerDialogEx(playerid, DIALOG_MICROSHOP2, DIALOG_STYLE_LIST, "Microtransaction Shop - Job & Experience", stringg, "Select", "Exit");
			}
			if(listitem == 1)
			{
				format(stringg, sizeof(stringg), "%s (Credits: {FFD700}%s{FFFFFF})\n%s (Credits: {FFD700}%s{FFFFFF})", mItemName[2], number_format(MicroItems[2]), mItemName[3], number_format(MicroItems[3]));
				ShowPlayerDialogEx(playerid, DIALOG_MICROSHOP2, DIALOG_STYLE_LIST, "Microtransaction Shop - VIP", stringg, "Select", "Exit");
			}
			if(listitem == 2)
			{
				format(stringg, sizeof(stringg), "%s (Credits: {FFD700}%s{FFFFFF})", mItemName[4], number_format(MicroItems[4]));
				ShowPlayerDialogEx(playerid, DIALOG_MICROSHOP2, DIALOG_STYLE_LIST, "Microtransaction Shop - Food", stringg, "Select", "Exit");
			}
			if(listitem == 3)
			{
				format(szMiscArray, sizeof(szMiscArray), "%s (Credits: {FFD700}%s{FFFFFF})\nHouse Move (Credits: {FFD700}%s{FFFFFF})\nHouse Interior Change (Credits: {FFD700}%s{FFFFFF})",
					mItemName[6], number_format(MicroItems[6]), number_format(ShopItems[16][sItemPrice]), number_format(ShopItems[15][sItemPrice]));

				format(szMiscArray, sizeof(szMiscArray), "%s\nFurniture Slots - Bronze Pack (25 slots) (Credits: {FFD700}%s{FFFFFF})\nFurniture Slots - Silver Pack (40 slots) (Credits: {FFD700}%s{FFFFFF})\n\
					Furniture Slots - Gold Pack (50 slots) (Credits: {FFD700}%s{FFFFFF})", szMiscArray, number_format(ShopItems[41][sItemPrice]), number_format(ShopItems[42][sItemPrice]), number_format(ShopItems[43][sItemPrice]));

				ShowPlayerDialogEx(playerid, DIALOG_MICROSHOP2, DIALOG_STYLE_LIST, "Microtransaction Shop - House", szMiscArray, "Select", "Exit");
			}
			if(listitem == 4)
			{
				format(stringg, sizeof(stringg), "%s (Credits: {FFD700}%s{FFFFFF})\n%s (Credits: {FFD700}%s{FFFFFF})\n%s (Credits: {FFD700}%s{FFFFFF})\nDeluxe Car Alarm (Credits: {FFD700}%s{FFFFFF})\nAdditional Vehicle Slots (Credits: {FFD700}%s{FFFFFF})",
				mItemName[7], number_format(MicroItems[7]), mItemName[8], number_format(MicroItems[8]), mItemName[9], number_format(MicroItems[9]), number_format(ShopItems[39][sItemPrice]), number_format(ShopItems[23][sItemPrice]));
				ShowPlayerDialogEx(playerid, DIALOG_MICROSHOP2, DIALOG_STYLE_LIST, "Microtransaction Shop - Vehicle", stringg, "Select", "Exit");
			}
			if(listitem == 5)
			{
				format(stringg, sizeof(stringg), "%s (Credits: {FFD700}%s{FFFFFF})\n%s (Credits: {FFD700}%s{FFFFFF})\n%s (Credits: {FFD700}%s{FFFFFF})\n%s (Credits: {FFD700}%s{FFFFFF})\
				\nFireworks x5 (Credits: {FFD700}%s{FFFFFF})\n100 Paintball Tokens (Credits: {FFD700}%s{FFFFFF})\nAdditional Toy Slots (Credits: {FFD700}%s{FFFFFF})\n%s (Credits: {FFD700}%s{FFFFFF})\n%s (Credits: {FFD700}%s{FFFFFF})",
				mItemName[10], number_format(MicroItems[10]), mItemName[12], number_format(MicroItems[12]), mItemName[13], number_format(MicroItems[13]), mItemName[5], number_format(MicroItems[5]), number_format(ShopItems[10][sItemPrice]),
				number_format(ShopItems[8][sItemPrice]), number_format(ShopItems[28][sItemPrice]), mItemName[14], number_format(MicroItems[14]), mItemName[15], number_format(MicroItems[15])/*, mItemName[11], number_format(MicroItems[11])*/);
				ShowPlayerDialogEx(playerid, DIALOG_MICROSHOP2, DIALOG_STYLE_LIST, "Microtransaction Shop - Miscellaneous", stringg, "Select", "Exit");
			}
			if(listitem == 6)
			{
				if(prezombie || zombieevent)
				{
					format(stringg, sizeof(stringg), "%s (Credits: {FFD700}%s{FFFFFF})\n%s (Credits: {FFD700}%s{FFFFFF})\n%s (Credits: {FFD700}%s{FFFFFF})\n%s (Credits: {FFD700}%s{FFFFFF})",
					mItemName[16], number_format(MicroItems[16]), mItemName[17], number_format(MicroItems[17]), mItemName[18], number_format(MicroItems[18]), mItemName[19], number_format(MicroItems[19]));
					ShowPlayerDialogEx(playerid, DIALOG_MICROSHOP2, DIALOG_STYLE_LIST, "Microtransaction Shop - Events", stringg, "Select", "Exit");
				}
				if(!strlen(stringg)) ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Microtransaction Shop - Events", "Nothing available to purchase at this time!", "Okay", "");
			}
			SetPVarInt(playerid, "m_listitem", listitem+1);
		}
	}
	if(dialogid == DIALOG_MICROSHOP2)
	{
		if(!response) return cmd_microshop(playerid, "");
		if(response)
		{
			new item;
			switch(GetPVarInt(playerid, "m_listitem")-1)
			{
				case 0://Job & Experience
				{
					if(listitem == 0) item = 0;
					if(listitem == 1) item = 1;
					if(listitem == 2) item = 100;//EXP Token
				}
				case 1://VIP
				{
					if(listitem == 0) item = 2;
					if(listitem == 1) item = 3;
				}
				case 2://Food
				{
					if(listitem == 0) item = 4;
				}
				case 3://House
				{
					if(listitem == 0) item = 6;
					if(listitem == 1) item = 101;//House Move
					if(listitem == 2) item = 102;//House Interior Change
					if(listitem == 3) item = 108;//Furniture Bronze Pack
					if(listitem == 4) item = 109;//Furniture Silver Pack
					if(listitem == 5) item = 110;//Furniture Gold Pack
				}
				case 4://Vehicle
				{
					if(listitem == 0) item = 7;
					if(listitem == 1) item = 8;
					if(listitem == 2) item = 9;
					if(listitem == 3) item = 103;//Deluxe Car Alarm
					if(listitem == 4) item = 104;//Additional Vehicle Slot
				}
				case 5://Misc
				{
					if(listitem == 0) item = 10;
					if(listitem == 1) item = 12;
					if(listitem == 2) item = 13;
					if(listitem == 3) item = 5;
					if(listitem == 4) item = 105;//Fireworks x5
					if(listitem == 5) item = 106;//100 Paintball Tokens
					if(listitem == 6) item = 107;//Additional Toy Slot
					if(listitem == 7) item = 14;
					if(listitem == 8) item = 15;
					//if(listitem == 9) item = 11; //Phone Change (TODO)
				}
				case 6://Event
				{
					if(listitem == 0) item = 16;
					if(listitem == 1) item = 17;
					if(listitem == 2) item = 18;
					if(listitem == 3) item = 19;
				}
			}
			if(item == 100)//EXP Token
			{
				SetPVarInt(playerid, "MiscShop", 4);
				format(string, sizeof(string), "Item: Double EXP Token\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[9][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[9][sItemPrice]));
				return ShowPlayerDialogEx(playerid, DIALOG_MISCSHOP2, DIALOG_STYLE_MSGBOX, "Micro Shop", string, "Purchase", "Cancel");
			}
			if(item == 101)//House Move
			{
				format(string, sizeof(string),"Item: House Move\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[16][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[16][sItemPrice]));
				return ShowPlayerDialogEx(playerid, DIALOG_HOUSESHOP4, DIALOG_STYLE_MSGBOX, "Micro Shop", string, "Purchase", "Cancel");
			}
			if(item == 102)//House Interior Change
			{
				format(string, sizeof(string),"Item: House Interior Change\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[15][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[15][sItemPrice]));
				return ShowPlayerDialogEx(playerid, DIALOG_HOUSESHOP3, DIALOG_STYLE_MSGBOX, "Micro Shop", string, "Purchase", "Cancel");
			}
			if(item == 103)//Deluxe Car Alarm
			{
				SetPVarInt(playerid, "MiscShop", 18);
				format(string, sizeof(string), "Item: Deluxe Car Alarm\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[39][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[39][sItemPrice]));
				return ShowPlayerDialogEx(playerid, DIALOG_MISCSHOP2, DIALOG_STYLE_MSGBOX, "Micro Shop", string, "Purchase", "Cancel");
			}
			if(item == 104)//Additional Vehicle Slot
			{
				SetPVarInt(playerid, "MiscShop", 7);
				format(string, sizeof(string), "Item: Additional Vehicle Slot\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[23][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[23][sItemPrice]));
				return ShowPlayerDialogEx(playerid, DIALOG_MISCSHOP2, DIALOG_STYLE_MSGBOX, "Micro Shop", string, "Purchase", "Cancel");
			}
			if(item == 105)//Fireworks x5
			{
				SetPVarInt(playerid, "MiscShop", 5);
				format(string, sizeof(string), "Item: Fireworks x5\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[10][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[10][sItemPrice]));
				return ShowPlayerDialogEx(playerid, DIALOG_MISCSHOP2, DIALOG_STYLE_MSGBOX, "Micro Shop", string, "Purchase", "Cancel");
			}
			if(item == 106)//100 Paintball Tokens
			{
				SetPVarInt(playerid, "MiscShop", 3);
				format(string, sizeof(string), "Item: 100 Paintball Tokens\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[8][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[8][sItemPrice]));
				return ShowPlayerDialogEx(playerid, DIALOG_MISCSHOP2, DIALOG_STYLE_MSGBOX, "Micro Shop", string, "Purchase", "Cancel");
			}
			if(item == 107)//Additional Toy Slot
			{
				SetPVarInt(playerid, "MiscShop", 8);
				format(string, sizeof(string), "Additional Toy Slot\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[28][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[28][sItemPrice]));
				return ShowPlayerDialogEx(playerid, DIALOG_MISCSHOP2, DIALOG_STYLE_MSGBOX, "Micro Shop", string, "Purchase", "Cancel");
			}
			if(item == 108)//Furniture Bronze
			{
				SetPVarInt(playerid, "MiscShop", 19);
				format(string, sizeof(string), "Furniture Pack - Bronze (25 slots)\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[41][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[41][sItemPrice]));
				return ShowPlayerDialogEx(playerid, DIALOG_MISCSHOP2, DIALOG_STYLE_MSGBOX, "Micro Shop", string, "Purchase", "Cancel");
			}
			if(item == 109)//Furniture Silver
			{
				SetPVarInt(playerid, "MiscShop", 20);
				format(string, sizeof(string), "Furniture Pack - Silver (40 slots)\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[42][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[42][sItemPrice]));
				return ShowPlayerDialogEx(playerid, DIALOG_MISCSHOP2, DIALOG_STYLE_MSGBOX, "Micro Shop", string, "Purchase", "Cancel");
			}
			if(item == 110)//Furniture Gold
			{
				SetPVarInt(playerid, "MiscShop", 21);
				format(string, sizeof(string), "Furniture Pack - Bronze (50 slots)\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[43][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[43][sItemPrice]));
				return ShowPlayerDialogEx(playerid, DIALOG_MISCSHOP2, DIALOG_STYLE_MSGBOX, "Micro Shop", string, "Purchase", "Cancel");
			}
			SetPVarInt(playerid, "m_Item", item);
			if(item == 0)//Change a Job
			{
				if(gettime() < PlayerInfo[playerid][mCooldown][item])
				{
					format(string, sizeof(string), "You have purchased this item 3 times in the past 24 hours, please wait %s to purchase it again.", ConvertTimeS(PlayerInfo[playerid][mCooldown][item]-gettime()));
					SendClientMessageEx(playerid, COLOR_GRAD2, string);
					return cmd_microshop(playerid, "");
				}
				PlayerInfo[playerid][mCooldown][item] = 0;
				return ShowPlayerDialogEx(playerid, 7484, DIALOG_STYLE_LIST, "Micro Shop: Job Center", "Detective\nLawyer\nWhore\nDrugs Dealer\nBodyguard\nMechanic\nArms Dealer\nBoxer\nDrugs Smuggler\nTaxi Driver\nCraftsman\nBartender\nShipment Contractor\nPizza Boy", "Proceed", "Cancel");
			}
			if(item == 1)//Job Boost
			{
				if(PlayerInfo[playerid][mPurchaseCount][item])
				{
					format(string, sizeof(string), "You currently have a active job boost, please wait for it to expire in %d minute(s) to purchase again.", PlayerInfo[playerid][mCooldown][item]);
					SendClientMessageEx(playerid, COLOR_GRAD2, string);
					return cmd_microshop(playerid, "");
				}
				return ShowPlayerDialogEx(playerid, 7484, DIALOG_STYLE_LIST, "Micro Shop: Job Boost", "Detective\nLawyer\nWhore\nDrugs Dealer\nMechanic\nArms Dealer\nBoxer\nShipment Contractor", "Proceed", "Cancel");
			}
			if(item == 2)//Buddy Invites Reset
			{
				if(PlayerInfo[playerid][pDonateRank] < 2) return SendClientMessageEx(playerid, COLOR_GRAD2, "You must be Silver VIP+ to purchase this item.");
				if(PlayerInfo[playerid][pBuddyInvites]) return SendClientMessageEx(playerid, COLOR_GRAD2, "You currently have Buddy Invites available, please use them before purchasing this item.");
				if(gettime() < PlayerInfo[playerid][mCooldown][item])
				{
					format(string, sizeof(string), "You have purchased this item in the past 24 hours, please wait %s to purchase it again.", ConvertTimeS(PlayerInfo[playerid][mCooldown][item]-gettime()));
					SendClientMessageEx(playerid, COLOR_GRAD2, string);
					return cmd_microshop(playerid, "");
				}
				PlayerInfo[playerid][mCooldown][item] = 0;
			}
			if(item == 3)//Buddy Invite Extension
			{
				if(!PlayerInfo[playerid][pBuddyInvited]) return SendClientMessageEx(playerid, COLOR_GRAD2, "You must be on a Buddy Invite to purchase this item.");
				if(gettime() < PlayerInfo[playerid][mCooldown][item])
				{
					format(string, sizeof(string), "You have purchased this item 3 times in the past 24 hours, please wait %s to purchase it again.", ConvertTimeS(PlayerInfo[playerid][mCooldown][item]-gettime()));
					SendClientMessageEx(playerid, COLOR_GRAD2, string);
					return cmd_microshop(playerid, "");
				}
				PlayerInfo[playerid][mCooldown][item] = 0;
			}
			if(item == 4)//Energy Bars
			{
				if(1 <= PlayerInfo[playerid][mInventory][4] <= 4)
				{
					format(string, sizeof(string), "You currently have %d energy bars on hand, they are sold in bulks of 4 which is also the max on hand.", PlayerInfo[playerid][mInventory][4]);
					SendClientMessageEx(playerid, COLOR_GRAD2, string);
					if(!PlayerInfo[playerid][pBackpack]) SendClientMessageEx(playerid, COLOR_GRAD2, "If you would like to be able to hold more, purchase a backpack via /miscshop");
					else SendClientMessageEx(playerid, COLOR_GRAD2, "As you have a backpack you can store your on hand energy bars and try again.");
					return 1;
				}
			}
			if(item == 6 && PlayerInfo[playerid][mInventory][item]) return SendClientMessageEx(playerid, COLOR_GRAD2, "You currently have a House Sale Sign in your inventory, please use it before purchasing another.");  //House Sale Sign
			if(item == 10)//Priority Ads
			{
				if(gettime() < PlayerInfo[playerid][mCooldown][item])
				{
					format(string, sizeof(string), "You have purchased this item 2 times in the past 24 hours, please wait %s to purchase it again.", ConvertTimeS(PlayerInfo[playerid][mCooldown][item]-gettime()));
					SendClientMessageEx(playerid, COLOR_GRAD2, string);
					return cmd_microshop(playerid, "");
				}
				PlayerInfo[playerid][mCooldown][item] = 0;
			}
			if(item == 12)//Quick Bank Access
			{
				if(PlayerInfo[playerid][mPurchaseCount][item])
				{
					format(string, sizeof(string), "You currently have a active Quick Bank Access, please wait for it to expire in %d minute(s) to purchase again.", PlayerInfo[playerid][mCooldown][item]);
					SendClientMessageEx(playerid, COLOR_GRAD2, string);
					return cmd_microshop(playerid, "");
				}
			}
			if(item == 13)//Restricted Skin
			{
				if(gettime() < PlayerInfo[playerid][mCooldown][item])
				{
					format(string, sizeof(string), "You have purchased this item 3 times in the past 24 hours, please wait %s to purchase it again.", ConvertTimeS(PlayerInfo[playerid][mCooldown][item]-gettime()));
					SendClientMessageEx(playerid, COLOR_GRAD2, string);
					return cmd_microshop(playerid, "");
				}
				PlayerInfo[playerid][mCooldown][item] = 0;
			}
			format(string, sizeof(string), "Item: %s\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", mItemName[item], number_format(PlayerInfo[playerid][pCredits]), number_format(MicroItems[item]), number_format(PlayerInfo[playerid][pCredits]-MicroItems[item]));
			ShowPlayerDialogEx(playerid, DIALOG_MICROSHOP3, DIALOG_STYLE_MSGBOX, "Micro Shop", string, "Purchase", "Cancel");
		}
	}
	if(dialogid == DIALOG_MICROSHOP3)
	{
		if(!response) return cmd_microshop(playerid, "");
		if(response)
		{
			new item = GetPVarInt(playerid, "m_Item");
			if(PlayerInfo[playerid][pCredits] < MicroItems[item]) return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");

			AmountSoldMicro[item]++;
			AmountMadeMicro[item] += MicroItems[item];
			new asString[128], amString[128];
			for(new m; m < MAX_MICROITEMS; m++)
			{
				format(asString, sizeof(asString), "%s%d", asString, AmountSoldMicro[m]);
				format(amString, sizeof(amString), "%s%d", amString, AmountMadeMicro[m]);
				if(m != MAX_MICROITEMS-1) strcat(asString, "|"), strcat(amString, "|");
			}
			new szQuery[512];
			mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `sales` SET `TotalSoldMicro` = '%s', `AmountMadeMicro` = '%s' WHERE `Month` > NOW() - INTERVAL 1 MONTH", asString, amString);
			mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "i", SENDDATA_THREAD);

			GivePlayerCredits(playerid, -MicroItems[item], 1);
			printf("MicroPrice%d: %d", item, MicroItems[item]);

			format(string, sizeof(string), "[MICROSHOP] [User: %s(%i)] [IP: %s] [Credits: %s] [%s] [Price: %s]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), mItemName[item], number_format(MicroItems[item]));
			Log("logs/micro.log", string), print(string);
			format(string, sizeof(string), "You have purchased \"%s\" for %s credits.", mItemName[item], number_format(MicroItems[item]));
			SendClientMessageEx(playerid, COLOR_CYAN, string);
			if(item == 0)//Change a Job
			{
				if(GetPVarInt(playerid, "m_Response") == 0) PlayerInfo[playerid][pJob] = GetPVarInt(playerid, "jobSelection"), SendClientMessageEx(playerid, COLOR_YELLOW, "You have changed your first job!");
				if(GetPVarInt(playerid, "m_Response") == 1) PlayerInfo[playerid][pJob2] = GetPVarInt(playerid, "jobSelection"), SendClientMessageEx(playerid, COLOR_YELLOW, "You have changed your second job!");
				if(GetPVarInt(playerid, "m_Response") == 2) PlayerInfo[playerid][pJob3] = GetPVarInt(playerid, "jobSelection"), SendClientMessageEx(playerid, COLOR_YELLOW, "You have changed your third job!");
				PlayerInfo[playerid][mInventory][item]++;
				if(++PlayerInfo[playerid][mPurchaseCount][item] == 3) PlayerInfo[playerid][mCooldown][item] = gettime()+86400, PlayerInfo[playerid][mPurchaseCount][item] = 0;
			}
			if(item == 1)//Job Boost
			{
				new skill;
				switch(GetPVarInt(playerid, "jobSelection"))
				{	//Point to enum
					case 1: skill = pInfo:pDetSkill;
					case 2: skill = pInfo:pLawSkill;
					case 3: skill = pInfo:pSexSkill;
					case 4: skill = pInfo:pDrugsSkill;
					case 7: skill = pInfo:pMechSkill;
					case 9: skill = pInfo:pArmsSkill;
					case 12: skill = pInfo:pBoxSkill;
					case 20: skill = pInfo:pTruckSkill;
				}
				PlayerInfo[playerid][mBoost][0] = GetPVarInt(playerid, "jobSelection");
				PlayerInfo[playerid][mBoost][1] = PlayerInfo[playerid][pInfo:skill];
				PlayerInfo[playerid][pInfo:skill] = 401;
				PlayerInfo[playerid][mPurchaseCount][item] = 1;//Set Active
				PlayerInfo[playerid][mCooldown][item] = 120;//2 Hours
				format(string, sizeof(string), "[JOBBOOST] %s(%d) Job: %s (%d) Skill: %d (%d)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetJobName(GetPVarInt(playerid, "jobSelection")), GetPVarInt(playerid, "jobSelection"), PlayerInfo[playerid][mBoost][1], GetJobLevel(playerid, GetPVarInt(playerid, "jobSelection")));
				Log("logs/micro.log", string);
				format(string, sizeof(string), "Job Boost for the %s job is now active and will expire in 60 minutes.", GetJobName(GetPVarInt(playerid, "jobSelection")));
				SendClientMessageEx(playerid, -1, string);
			}
			if(item == 2)//Buddy Invites Reset
			{
				PlayerInfo[playerid][pVIPInviteDay] = 0;
				PlayerInfo[playerid][pBuddyInvites] += 3;
				PlayerInfo[playerid][mCooldown][item] = gettime()+86400;
			}
			if(item == 3)//Buddy Invite Extension
			{
				PlayerInfo[playerid][pTempVIP] += 180;
				if(++PlayerInfo[playerid][mPurchaseCount][item] == 3) PlayerInfo[playerid][mCooldown][item] = gettime()+86400, PlayerInfo[playerid][mPurchaseCount][item] = 0;
			}
			if(item == 4)//Energy Bars
			{
				PlayerInfo[playerid][mInventory][item] += 4;
				SendClientMessageEx(playerid, -1, "To eat a energy bar type /eatbar");
			}
			if(item == 5)//Gift Reset Voucher
			{
				PlayerInfo[playerid][pGiftVoucher]++;
				SendClientMessageEx(playerid, -1, "Use /myvouchers to access your gift reset voucher.");
			}
			if(item == 6)//House Sale Sign
			{
				PlayerInfo[playerid][mInventory][item] = 1;
				SendClientMessageEx(playerid, -1, "To place down your sign type /placesign, To edit your sign type /editsign");
			}
			if(item == 7)//Fuel Canister
			{
				PlayerInfo[playerid][mInventory][item]++;
				SendClientMessageEx(playerid, -1, "To use a fuel can get near a vehicle and type /fuelcan");
			}
			if(item == 8)//Jump Start
			{
				PlayerInfo[playerid][mInventory][item]++;
				SendClientMessageEx(playerid, -1, "To jump start a vehicle type /jumpstart");
			}
			if(item == 9) //Restricted Car Colors
			{
				PlayerInfo[playerid][mInventory][item]++;
				SendClientMessageEx(playerid, -1, "To paint a vehicle a restricted car color type /rcarcolor");
			}
			if(item == 10)//Priority Ads
			{
				PlayerInfo[playerid][pAdvertVoucher] += 3;
				if(++PlayerInfo[playerid][mPurchaseCount][item] == 2) PlayerInfo[playerid][mCooldown][item] = gettime()+86400;
				SendClientMessageEx(playerid, -1, "3 Advertisement vouchers have been added to your account.");
			}
			if(item == 11)//Number Change
			{
				//TODO
			}
			if(item == 12)//Quick Bank Access
			{
				PlayerInfo[playerid][mPurchaseCount][item] = 1;
				PlayerInfo[playerid][mCooldown][item] = 15;
				SendClientMessageEx(playerid, -1, "You can now use /balance /withdraw /deposit /wiretransfer from anywhere for 15 minutes.");
			}
			if(item == 13)//Restricted Skin
			{
				PlayerInfo[playerid][mInventory][item]++;
				if(++PlayerInfo[playerid][mPurchaseCount][item] == 3) PlayerInfo[playerid][mCooldown][item] = gettime()+86400;
				SendClientMessageEx(playerid, -1, "Head over to a clothing store and select any restricted skin.");
			}
			if(item == 14) AddFlag(playerid, INVALID_PLAYER_ID, "Dynamic Door Move (Credits)"), SendReportToQue(playerid, "Dynamic Door Move (Credits)", 2, 2), SendClientMessageEx(playerid, COLOR_CYAN, "Contact a senior admin to have the Dynamic Door Move issued.");
			if(item == 15) AddFlag(playerid, INVALID_PLAYER_ID, "Dynamic Door Interior Change (Credits)"), SendReportToQue(playerid, "Dynamic Door Interior Change (Credits)", 2, 2), SendClientMessageEx(playerid, COLOR_CYAN, "Contact a senior admin to have the Dynamic Door Interior Change issued.");
			if(item == 16)
			{
				SendClientMessageEx(playerid, -1, "Type /zscrapmetal to boost the vehicle health by 500 HP!");
				PlayerInfo[playerid][mInventory][item]++;
			}
			if(item == 17)
			{
				SendClientMessageEx(playerid, -1, "Type /z50cal to use your .50 caliber ammo. Use the same command to toggle your .50 caliber ammo. This will only work for Rifles & Sniper Rifles");
				PlayerInfo[playerid][mInventory][item] += 15;
			}
			if(item == 18)
			{
				SendClientMessageEx(playerid, -1, "Type /zinject to use the antibiotic.");
				PlayerInfo[playerid][mPurchaseCount][item] += 3;
			}
			if(item == 19)
			{
				SendClientMessageEx(playerid, -1, "Type /zopenkit to open up the kit and see which variation of the Survivor kit you won.");
				PlayerInfo[playerid][mInventory][item]++;
			}
			DeletePVar(playerid, "m_listitem");
			DeletePVar(playerid, "m_Item");
			DeletePVar(playerid, "m_Response");
		}
	}
	if(dialogid == DIALOG_EDITMICROSHOP)
	{
		if(response)
		{
			if(!GetPVarType(playerid, "mEditingPrice"))
			{
				SetPVarInt(playerid, "mEditingPrice", listitem);
				format(string, sizeof(string), "You are currently editing the price of %s. The current credit cost is %s.", mItemName[listitem], number_format(MicroItems[listitem]));
				return ShowPlayerDialogEx(playerid, DIALOG_EDITMICROSHOP, DIALOG_STYLE_INPUT, "Editing Price", string, "Change", "Back");
			}
			else
			{
				if(!GetPVarType(playerid, "mEditingPriceValue"))
				{
					new price;
					if(sscanf(inputtext, "d", price) || price <= 0)
					{
						format(string, sizeof(string), "The price can't be below 1.\n\nYou are currently editing the price of %s. The current credit cost is %s.", mItemName[GetPVarInt(playerid, "mEditingPrice")], number_format(MicroItems[GetPVarInt(playerid, "mEditingPrice")]));
						return ShowPlayerDialogEx(playerid, DIALOG_EDITMICROSHOP, DIALOG_STYLE_INPUT, "Editing Price - Error", string, "Change", "Back");
					}
					else
					{
						SetPVarInt(playerid, "mEditingPriceValue", price);
						format(string,sizeof(string),"Are you sure you want to edit the cost of %s?\n\nOld Cost: %s\nNew Cost: %s", mItemName[GetPVarInt(playerid, "mEditingPrice")], number_format(MicroItems[GetPVarInt(playerid, "mEditingPrice")]), number_format(price));
						return ShowPlayerDialogEx(playerid, DIALOG_EDITMICROSHOP, DIALOG_STYLE_MSGBOX, "Confirmation", string, "Confirm", "Cancel");
					}
				}
				else
				{
					if(GetPVarInt(playerid, "mEditingPriceValue") == 0) SetPVarInt(playerid, "mEditingPriceValue", 999999);
					MicroItems[GetPVarInt(playerid, "mEditingPrice")] = GetPVarInt(playerid, "mEditingPriceValue");
					format(string, sizeof(string), "You have successfully edited the price of %s to %s.", mItemName[GetPVarInt(playerid, "mEditingPrice")], number_format(GetPVarInt(playerid, "mEditingPriceValue")));
					SendClientMessageEx(playerid, COLOR_WHITE, string);
					format(string, sizeof(string), "[EDITMICROSHOPPRICES] [User: %s(%i)] [IP: %s] [%s] [Price: %s]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), mItemName[GetPVarInt(playerid, "mEditingPrice")], number_format(MicroItems[GetPVarInt(playerid, "mEditingPrice")]));
					Log("logs/editshop.log", string), print(string);
					g_mysql_SavePrices();
					DeletePVar(playerid, "mEditingPrice");
					DeletePVar(playerid, "mEditingPriceValue");
				}
			}
		}
		else
		{
			if(GetPVarType(playerid, "mEditingPriceValue")) SendClientMessageEx(playerid, COLOR_GREY, "You have canceled the price change.");
			DeletePVar(playerid, "mEditingPrice");
			DeletePVar(playerid, "mEditingPriceValue");
		}
	}
	if(dialogid == DIALOG_WEPVEHSALE)
	{
		if(response)
		{
			new alarmstring[9], lockstring[11], worklockstring[10];
			new giveplayerid = GetPVarInt(playerid, "WepVehSalePlayer");
			new price = GetPVarInt(playerid, "WepVehSalePrice");
			new d = GetPVarInt(playerid, "WepVehSaleVehicle");
			new fine = GetPVarInt(playerid, "WepVehSaleFine");

			SetPVarInt(playerid, "LastTransaction", gettime());
            VehicleOffer[giveplayerid] = playerid;
            VehicleId[giveplayerid] = d;
            VehiclePrice[giveplayerid] = price;

			switch(PlayerVehicleInfo[playerid][d][pvAlarm]) {
				case 1: alarmstring = "Standard";
				case 2: alarmstring = "Deluxe";
				default: alarmstring = "no";
			}
			switch(PlayerVehicleInfo[playerid][d][pvLock]) {
				case 2: lockstring = "Electronic";
				case 3: lockstring = "Industrial";
				default: lockstring = "no";
			}

			if(PlayerVehicleInfo[playerid][d][pvLocksLeft] < 1) worklockstring = "(Broken)";
			format(string, sizeof(string), "* [WEPVEHICLE] You offered %s to buy this %s with %s Alarm & %s%s Lock for $%s with a %s fine.", GetPlayerNameEx(giveplayerid), GetVehicleName(PlayerVehicleInfo[playerid][d][pvId]), alarmstring, worklockstring, lockstring, number_format(price), number_format(fine));
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
			format(string, sizeof(string), "* [WEPVEHICLE] %s has offered you their %s (VID: %d) with %s Alarm & %s%s Lock for $%s, (type /accept car) to buy.", GetPlayerNameEx(playerid), GetVehicleName(PlayerVehicleInfo[playerid][d][pvId]), PlayerVehicleInfo[playerid][d][pvId], alarmstring, worklockstring, lockstring, number_format(price));
			SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
			DeletePVar(playerid, "confirmvehsell");
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "You have canceled the weaponized vehicle sale. You will not be fined.");
			DeletePVar(playerid, "WepVehSalePlayer");
			DeletePVar(playerid, "WepVehSaleVehicle");
			DeletePVar(playerid, "WepVehSalePrice");
			DeletePVar(playerid, "WepVehSaleFine");
		}
	}
	if(dialogid == DIALOG_REPORT_HSIGN)
	{
		new Player = GetPVarInt(playerid, "hSignTextChange");
		if(!GetPVarType(Player, "hSignRequest")) return SendClientMessageEx(playerid, COLOR_GREY, "That person isn't requesting a namechange!");
		if(response)
		{
			new desc[64], escapeDesc[66];
			GetPVarString(Player, "hSignRequestText", desc, 64);
			mysql_escape_string(desc, escapeDesc);
			format(HouseInfo[GetPVarInt(Player, "hSignRequest")][hSignDesc], 64, "%s", escapeDesc);
			SaveHouse(GetPVarInt(Player, "hSignRequest"));
			SendClientMessageEx(Player, COLOR_YELLOW, "Your house sale sign text has been approved.");
			format(string, sizeof(string), " You have approved %s's house sale sign text change on House ID: %d", GetPlayerNameEx(Player), GetPVarInt(Player, "hSignRequest"));
			SendClientMessageEx(playerid, COLOR_YELLOW, string);
			format(string, sizeof(string), "%s changed House ID: %d sale sign text to \"%s\", owned by: %s(%d)", GetPlayerNameEx(playerid), GetPVarInt(Player, "hSignRequest"), desc, GetPlayerNameEx(Player), GetPlayerSQLId(Player));
			Log("logs/house.log", string);
			format(string, sizeof(string), "%s has approved %s's house sale sign text on House ID: %d", GetPlayerNameEx(playerid), GetPlayerNameEx(Player), GetPVarInt(Player, "hSignRequest"));
			ABroadCast(COLOR_YELLOW, string, 2);
		}
		else
		{
			SendClientMessageEx(Player, COLOR_YELLOW, "Your request to modify your house sale sign text has been denied.");
			format(string, sizeof(string), " You have denied %s's house sale sign text modification request.", GetPlayerNameEx(Player));
			SendClientMessageEx(playerid,COLOR_YELLOW,string);
			format(string, sizeof(string), "%s has denied %s's house sale sign text modification request", GetPlayerNameEx(playerid), GetPlayerNameEx(Player));
			ABroadCast(COLOR_YELLOW, string, 2);
		}
		DeletePVar(Player, "hSignRequest");
		DeletePVar(Player, "hSignTextChange");
	}
	if(dialogid == DIALOG_ENERGYBARS)
	{
		if(response)
		{
			if(!IsBackpackAvailable(playerid)) {
				DeletePVar(playerid, "BackpackOpen"), DeletePVar(playerid, "BackpackProt"), SendClientMessageEx(playerid, COLOR_GREY, "You cannot use your backpack at this moment.");
				return 1;
			}
			if(!GetPVarType(playerid, "bnwd"))
			{
				SetPVarInt(playerid, "bnwd", listitem);
				return ShowBackpackMenu(playerid, DIALOG_ENERGYBARS*2, "");
			}
			new str[148];
			if(GetPVarInt(playerid, "bnwd"))//Deposit
			{
				new amount, maxbars;
				switch(PlayerInfo[playerid][pBackpack])
				{
					case 1: maxbars = 8;
					case 2: maxbars = 12;
					case 3: maxbars = 16;
				}
				if(sscanf(inputtext, "d", amount)) return ShowBackpackMenu(playerid, DIALOG_ENERGYBARS*2, "{B20400}Wrong input{A9C4E4}");
				if(amount < 1) return ShowBackpackMenu(playerid, DIALOG_ENERGYBARS*2, "{B20400}Wrong input{A9C4E4}\nYou cannot put the amount less than 1");
				if(amount > maxbars-PlayerInfo[playerid][pBItems][11])
				{
					format(str, sizeof(str), "{B20400}Wrong input, you can only store %d Energy Bars{A9C4E4}\nEnergy Bars available left to store {FFF600}%d{A9C4E4}", maxbars, maxbars-PlayerInfo[playerid][pBItems][11]);
					return ShowBackpackMenu(playerid, DIALOG_ENERGYBARS*2, str);
				}
				if(PlayerInfo[playerid][mInventory][4] >= amount) PlayerInfo[playerid][mInventory][4] -= amount;
				else return ShowBackpackMenu(playerid, DIALOG_ENERGYBARS*2, "{B20400}Wrong input{A9C4E4}\nYou don't have that many Energy Bars");
				PlayerInfo[playerid][pBItems][11] += amount;
				format(string, sizeof(string), "You have deposited %d energy bars in your backpack.", amount);
				SendClientMessageEx(playerid, COLOR_WHITE, string);
				format(string, sizeof(string), "[EBARS] %s(%d) (IP:%s) deposited %d energy bars (%d bars Total) [BACKPACK %d]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), amount, PlayerInfo[playerid][pBItems][11], PlayerInfo[playerid][pBackpack]);
				Log("logs/backpack.log", string);
			}
			else//Withdraw
			{
				new amount;
				if(sscanf(inputtext, "d", amount)) return ShowBackpackMenu(playerid, DIALOG_ENERGYBARS*2, "{B20400}Wrong input{A9C4E4}");
				if(amount < 1) return ShowBackpackMenu(playerid, DIALOG_ENERGYBARS*2, "{B20400}Wrong input{A9C4E4}\nYou cannot put the amount less than 1");
				if(amount > PlayerInfo[playerid][pBItems][11])
				{
					format(str, sizeof(str), "{B20400}Wrong input, you only have %d Energy Bars{A9C4E4}\nEnergy Bars trying to withdraw {FFF600}%d{A9C4E4}", PlayerInfo[playerid][pBItems][11], amount);
					return ShowBackpackMenu(playerid, DIALOG_ENERGYBARS*2, str);
				}
				PlayerInfo[playerid][pBItems][11] -= amount;
				PlayerInfo[playerid][mInventory][4] += amount;
				format(string, sizeof(string), "You have withdrawn %d energy bars from your backpack.", amount);
				SendClientMessageEx(playerid, COLOR_WHITE, string);
				format(string, sizeof(string), "[EBARS] %s(%d) (IP:%s) withdrawn %d energy bars (%d bars Total) [BACKPACK %d]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), amount, PlayerInfo[playerid][pBItems][11], PlayerInfo[playerid][pBackpack]);
				Log("logs/backpack.log", string);
			}
			ShowBackpackMenu(playerid, DIALOG_ENERGYBARS, "- {02B0F5}Energy Bars");
		}
		else
		{
			if(GetPVarType(playerid, "bnwd")) ShowBackpackMenu(playerid, DIALOG_ENERGYBARS, "- {02B0F5}Energy Bars");
			else ShowBackpackMenu(playerid, DIALOG_OBACKPACK, "");
		}
	}
	if(dialogid == DIALOG_MANAGECREDITS)
	{
		if(!response) return 1;
		SetPVarInt(playerid, "ManageCreditsDiag", listitem);
		switch(listitem) {
			case 0: {
				if(SellClosed)
					ShowPlayerDialogEx(playerid, DIALOG_MANAGECREDITS2, DIALOG_STYLE_MSGBOX, "Sale of Credits", "Would you like ENABLE the selling of credits?", "Okay", "Cancel");
				else
					ShowPlayerDialogEx(playerid, DIALOG_MANAGECREDITS2, DIALOG_STYLE_MSGBOX, "Sale of Credits", "Would you like DISABLE the selling of credits?", "Okay", "Cancel");
			}
			case 1: {
				if(!freeweekend)
					ShowPlayerDialogEx(playerid, DIALOG_MANAGECREDITS2, DIALOG_STYLE_MSGBOX, "Sale of Credits", "Would you like ENABLE the free weekend?", "Okay", "Cancel");
				else
					ShowPlayerDialogEx(playerid, DIALOG_MANAGECREDITS2, DIALOG_STYLE_MSGBOX, "Sale of Credits", "Would you like DISABLE the free weekend?", "Okay", "Cancel");
			}
			case 2: {
				if(!nonvipcredits)
					ShowPlayerDialogEx(playerid, DIALOG_MANAGECREDITS2, DIALOG_STYLE_MSGBOX, "Sale of Credits", "Would you like ENABLE the selling of credits for NON-VIPs?", "Okay", "Cancel");
				else
					ShowPlayerDialogEx(playerid, DIALOG_MANAGECREDITS2, DIALOG_STYLE_MSGBOX, "Sale of Credits", "Would you like DISABLE the selling of credits for NON-VIPs?", "Okay", "Cancel");
			}
		}
	}
	if(dialogid == DIALOG_MANAGECREDITS2)
	{
		if(!response) return 1;
		switch(GetPVarInt(playerid, "ManageCreditsDiag")) {
			case 0: {
				if(!SellClosed) SellClosed = 1, SendClientMessageEx(playerid, COLOR_WHITE, "Selling of credits disabled.");
				else SellClosed = 0, SendClientMessageEx(playerid, COLOR_WHITE, "Selling of credits enabled.");
			}
			case 1: {
				if(!freeweekend) freeweekend = 1, SendClientMessageEx(playerid, COLOR_WHITE, "Free weekend enabled.");
				else freeweekend = 0, SendClientMessageEx(playerid, COLOR_WHITE, "Free weekend disabled.");
			}
			case 2: {
				if(!nonvipcredits) nonvipcredits = 1, SendClientMessageEx(playerid, COLOR_WHITE, "Selling of credits for Non-VIPs enabled.");
				else nonvipcredits = 0, SendClientMessageEx(playerid, COLOR_WHITE, "Selling of credits for Non-VIPs disabled.");
			}
		}
	}
	if(dialogid == DIALOG_MEDIC_LIST) {
		if(response) Medic_GetPatient(playerid, ListItemTrackId[playerid][listitem]);
	}
	return 0;
}
