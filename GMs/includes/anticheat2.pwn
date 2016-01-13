/* Anti-Cheat v2.0
	[###] Jingles
*/

#include <YSI\y_hooks>

#define 			DIALOG_AC_MAIN				12015

#define 			HACKTIMER_INTERVAL 			5000
#define 			CARSURFING					0
#define 			NINJAJACK 					1
#define 			HEALTHARMORHACKS			2
#define 			DIALOGSPOOFING				3

new ac_iPlayerKeySpam[MAX_PLAYERS],
	// ac_iVehicleDriverID[MAX_PLAYERS],
	ac_iLastVehicleID[MAX_PLAYERS];

new bool:ac_ACToggle[6];

hook OnGameModeInit() {
	
	for(new i; i < sizeof(ac_ACToggle); ++i) ac_ACToggle[i] = false;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {

	if(newkeys == KEY_YES) ac_iPlayerKeySpam[playerid]++;
}

/*
hook OnPlayerEnterVehicle(playerid, vehicleid, ispassenger) {
	if(!ispassenger) ac_iVehicleDriverID[playerid] = GetDriverID(vehicleid);
}

hook OnPlayerStateChange(playerid, newstate, oldstate) {

	if(newstate == PLAYER_STATE_DRIVER) ac_iLastVehicleID[playerid] = GetPlayerVehicleID(playerid);
	if(oldstate == PLAYER_STATE_DRIVER && newstate == PLAYER_STATE_ONFOOT) defer AC_ResetPVars(playerid, 0);
}


hook OnPlayerDeath(playerid, killerid, reason) {

	new iKillerID = GetDriverID(ac_iLastVehicleID[playerid]),
		iKillerVehID = GetPlayerVehicleID(iKillerID);
	if(iKillerID != INVALID_PLAYER_ID) {
		if(ac_iVehicleDriverID[iKillerID] == playerid || (iKillerVehID == ac_iLastVehicleID[playerid] && iKillerVehID != INVALID_VEHICLE_ID)) {
			AC_Process(playerid, iKillerID, NINJAJACK);
		}
	}
}
*/

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	switch(dialogid) {

		case DIALOG_AC_MAIN: {
			if(response) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot turn anything on yet.");
			else return 1;

			/*
			if(ac_ACToggle[listitem]) {
				format(szMiscArray, sizeof(szMiscArray), "[SYSTEM] %s turned off the %s detection.", GetPlayerNameEx(playerid), AC_GetACName(listitem));
				ac_ACToggle[listitem] = false;
			}
			else {
				format(szMiscArray, sizeof(szMiscArray), "[SYSTEM] %s turned on the %s detection.", GetPlayerNameEx(playerid), AC_GetACName(listitem));
				ac_ACToggle[listitem] = true;
			}
			AC_SendAdminMessage(COLOR_LIGHTRED, szMiscArray);
			*/
		}
	}
	return 1;
}

ptask HackCheck[HACKTIMER_INTERVAL](playerid) {

	ac_iPlayerKeySpam[playerid] = 0;
	if(PlayerInfo[playerid][pAdmin] < 1) {
		if(IsSpawned[playerid] && gPlayerLogged{playerid} && playerTabbed[playerid] < 1) {
			if(ac_ACToggle[CARSURFING] && AC_IsPlayerSurfing(playerid)) AC_Process(playerid, INVALID_PLAYER_ID, CARSURFING);
			if(ac_ACToggle[HEALTHARMORHACKS] && AC_PlayerHealthArmor(playerid)) AC_Process(playerid, INVALID_PLAYER_ID, HEALTHARMORHACKS);
		}
	}
}

timer AC_ResetPVars[2000](playerid, processid) {

	switch(processid) {
		case 0: {
			ac_iLastVehicleID[playerid] = INVALID_VEHICLE_ID;
		}
		case 1: {
			DeletePVar(playerid, "PCMute");
		}
	}
	
	
}

stock GetDriverID(iVehID) {
	if(iVehID == INVALID_VEHICLE_ID) return INVALID_PLAYER_ID;
	foreach(new i : Player) {
		if(GetPlayerVehicleID(i) == iVehID && GetPlayerState(i) == PLAYER_STATE_DRIVER) return i;
	}
	return INVALID_PLAYER_ID;
}

stock AC_GetACName(i) {
	szMiscArray[0] = 0;
	switch(i) {
		case 0: szMiscArray = "Car Surfing";
		case 1: szMiscArray = "Ninja Jacking";
		case 2: szMiscArray = "Health Hacks";
		case 3: szMiscArray = "Dialog Spoofing";
	}
	return szMiscArray;
}

AC_FinePlayer(playerid, fineid) {

	switch(fineid) {
		case NINJAJACK: GivePlayerCash(playerid, -2000);
		case DIALOGSPOOFING: GivePlayerCash(playerid, -2000);
	}
}

timer AC_RevivePlayer[5000](playerid) {

	format(szMiscArray, sizeof(szMiscArray), "SYSTEM: %s(%d) has been revived by [SYSTEM]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerNameEx(playerid));
	Log("logs/system.log", szMiscArray);
	KillEMSQueue(playerid);
	ClearAnimations(playerid);
	SetHealth(playerid, 100);
}

AC_Process(playerid, killerid, processid) {

	new szString[128];
	szMiscArray[0] = 0;
	switch(processid) {

		case CARSURFING: {

			new Float:fPos[3];
			GetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]);
			SetPlayerPos(playerid, fPos[0] + 1.0, fPos[1] + 1.0, fPos[2]);
			PlayAnimEx(playerid, "PED", "BIKE_fallR", 4.1, 0, 1, 1, 1, 0, 1);
			szMiscArray = "[SYSTEM]: Please do not car surf.";
		}
		case NINJAJACK: {
			if(!ac_ACToggle[NINJAJACK]) return 1;
			defer AC_RevivePlayer(playerid);
			AC_FinePlayer(killerid, processid);
			SetTimerEx("KickEx", 1000, 0, "i", killerid);
			format(szMiscArray, sizeof(szMiscArray), "[SYSTEM]: %s was fined and kicked for ninja-jacking %s.", GetPlayerNameEx(killerid), GetPlayerNameEx(playerid));
			SendClientMessageToAllEx(COLOR_LIGHTRED, szMiscArray);
			szMiscArray = "[SYSTEM]: You will be revived from the ninja-jacking.";
			szString = "[SYSTEM]: You were fined $5000 and kicked for ninja-jacking.";
		}
		case HEALTHARMORHACKS: {
			AC_FinePlayer(playerid, processid);
			// SetTimerEx("KickEx", 1000, 0, "i", killerid);
			format(szMiscArray, sizeof(szMiscArray), "[SYSTEM]: %s was kicked for (plausibly!) health/armor hacking. Refrain from taking more action until fully tested.", GetPlayerNameEx(playerid));
			AC_SendAdminMessage(COLOR_LIGHTRED, szMiscArray);
			szMiscArray = "[SYSTEM]: You were kicked for plausibly health/armor hacking.";
		}
		/*
		case DIALOGSPOOFING: {
			if(!ac_ACToggle[DIALOGSPOOFING]) return 1;
			AC_FinePlayer(playerid, processid);
			SetTimerEx("KickEx", 1000, 0, "i", killerid);
			format(szMiscArray, sizeof(szMiscArray), "[SYSTEM]: %s was kicked for (plausibly!) dialog spoofing. Refrain from taking more action until fully tested.", GetPlayerNameEx(playerid));
			AC_SendAdminMessage(COLOR_LIGHTRED, szMiscArray);
			szMiscArray = "[SYSTEM]: You were kicked for plausibly dialog spoofing.";
		}
		*/
	}
	// format(szMiscArray, sizeof(szMiscArray), "%s %s (ID: %d)", szMiscArray, GetPlayerNameExt(playerid), playerid);
	SendClientMessageEx(playerid, COLOR_LIGHTRED, szMiscArray);
	if(killerid != INVALID_PLAYER_ID) SendClientMessageEx(killerid, COLOR_LIGHTRED, szString);
	return 1;
}

AC_SendAdminMessage(hColor, szMessage[]) {

	foreach(new i : Player) {
		if(PlayerInfo[i][pAdmin] > 0) SendClientMessageEx(i, hColor, szMessage);
	}
}

AC_IsPlayerSurfing(playerid) {

	if(zombieevent) return 0;
	if(PlayerInfo[playerid][pAdmin] >= 2) return 0;
	new iVehID = GetPlayerSurfingVehicleID(playerid);
	if(iVehID == INVALID_VEHICLE_ID) return 0;
	switch(GetVehicleModel(iVehID)) {

		case 403, 406, 422, 430, 433, 443, 446, 452, 453, 454, 455, 470, 472, 473, 478, 484, 493, 500, 514, 515, 525, 543, 554, 578, 595, 605, 607: return 0;
		case 417, 423, 416, 425, 427, 431, 437, 447, 469, 487, 488, 497, 508, 528, 537, 538, 449, 548, 563, 56, 570, 577, 590, 592, 490: return 0; // often modded vehicles
	}
	return 1;
}

AC_KeySpamCheck(playerid) {
	if(GetPVarType(playerid, "PCMute")) {
		SendClientMessageEx(playerid, COLOR_WHITE, "[SYSTEM]: You are currently blocked from using interaction keys.");
		return 0;
	}
	if(ac_iPlayerKeySpam[playerid] > 4) {
		SetPVarInt(playerid, "PCMute", 1);
		defer AC_ResetPVars[10000](playerid, 1);
		SendClientMessageEx(playerid, COLOR_LIGHTRED, "[SYSTEM]: You were muted for spamming an interaction key. Refrain from doing it again.");
		return 0;
	}
	return 1;
}

AC_PlayerHealthArmor(playerid) {

	if(GetPVarInt(playerid, "Injured") == 1) return 0;
	if(PlayerInfo[playerid][pHospital] > 0) return 0;

	new Float:fData[4];
	GetPlayerHealth(playerid, fData[0]);
	GetHealth(playerid, fData[1]);
	GetPlayerArmour(playerid, fData[2]);
	GetArmour(playerid, fData[3]);
	if(fData[1] < -40) {
		format(szMiscArray, sizeof(szMiscArray), "[SYSTEM (BETA)]: %s (%d) may be health hacking.", GetPlayerNameEx(playerid), playerid);
		AC_SendAdminMessage(COLOR_LIGHTRED, szMiscArray);
	}
	if(fData[0] > (fData[1] + 10.0) || fData[2] > (fData[3] + 10.0)) return 1;
	return 0;
}

CMD:system(playerid, params[]) {

	if(!IsAdminLevel(playerid, ADMIN_HEAD)) return 1;
	format(szMiscArray, sizeof(szMiscArray), "Detecting\tStatus\n\
		Car Surfing\t%s\n\
		Ninja Jacking\t%s\n\
		Health Hacks\t%s\n\
		Dialog Spoofing\t%s\n",
		(ac_ACToggle[CARSURFING] == true) ? ("{00FF00}On") : ("{FF0000}Off"),
		(ac_ACToggle[NINJAJACK] == true) ? ("{00FF00}On") : ("{FF0000}Off"),
		(ac_ACToggle[HEALTHARMORHACKS] == true) ? ("{00FF00}On") : ("{FF0000}Off"),
		(ac_ACToggle[DIALOGSPOOFING] == true) ? ("{00FF00}On") : ("{FF0000}Off"));
	ShowPlayerDialogEx(playerid, DIALOG_AC_MAIN, DIALOG_STYLE_TABLIST_HEADERS, "[SYSTEM]: Anti-Cheat", szMiscArray, "Select", "<<");
	return 1;
}