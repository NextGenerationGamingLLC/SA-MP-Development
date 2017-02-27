/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

					Server Offences System

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

CMD:prison(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[playerid][pWatchdog] >= 2)
	{
		new giveplayerid, minutes, reason[64];
		if(sscanf(params, "uds[64]", giveplayerid, minutes, reason)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /prison [player] [minutes] [reason]");

		if(giveplayerid != INVALID_PLAYER_ID)
		{
			if((PlayerInfo[giveplayerid][pAdmin] && PlayerInfo[giveplayerid][pAdmin] >= PlayerInfo[playerid][pAdmin]) || (PlayerInfo[playerid][pAdmin] == 1 && PlayerInfo[giveplayerid][pWatchdog] >= 2)) return SendClientMessageEx(playerid, COLOR_WHITE, "You can't perform this action on an equal or higher level administrator.");
			if(PrisonPlayer(playerid, giveplayerid, reason, minutes, .custom=1) == 0) return 1;
		}
	}
	else SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	return 1;
}

CMD:reverse(playerid, params[])
{
	new string[128], reason[24], giveplayerid;
	if(PlayerInfo[playerid][pAdmin] >= 1 || PlayerInfo[playerid][pHelper] >= 2 || PlayerInfo[playerid][pWatchdog] >= 2) {
		if(!sscanf(params, "us[24]", giveplayerid, reason)) {
			if(!IsPlayerConnected(giveplayerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid player.");
			if(GetPlayerSQLId(playerid) != PlayerInfo[giveplayerid][pJailedInfo][0] && PlayerInfo[playerid][pAdmin] < 3 && PlayerInfo[playerid][pASM] < 1)
				return SendClientMessageEx(playerid, COLOR_WHITE, "You have not acted against this person, therefor you can not reverse any actions for them.");
			if(PlayerInfo[giveplayerid][pJailTime] == 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "You cannot do this to someone not currently prisoned.");
			if(PlayerInfo[playerid][pAdmin] == 1 || PlayerInfo[playerid][pHelper] >= 2 || (PlayerInfo[playerid][pWatchdog] >= 2 && PlayerInfo[playerid][pAdmin] < 3)) {
				SetPVarInt(playerid, "ReverseReport", 1);
				SetPVarInt(playerid, "ReverseID", giveplayerid);
				SetPVarString(playerid, "ReverseReason", reason);
				SendReportToQue(playerid, "Reverse Report", 2, 4);
				SendClientMessageEx(playerid, COLOR_WHITE, "Please wait for an administrator to review your request.");
				return 1;
			}

			if(PlayerInfo[giveplayerid][pJailedInfo][1] > 0) GivePlayerCash(giveplayerid, PlayerInfo[giveplayerid][pJailedInfo][1]);
			if(PlayerInfo[giveplayerid][pJailedInfo][3] == 1) PlayerInfo[giveplayerid][pWarns]--;
			if(PlayerInfo[giveplayerid][pJailedInfo][4] > 0) PlayerInfo[giveplayerid][pWRestricted] = 0;
			format(string, 128, "AdmCmd: %s(%d) has been released from prison (/reverse) by %s, reason: %s", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), GetPlayerNameEx(playerid), reason);
			Log("logs/admin.log", string);
			format(string, 128, "AdmCmd: %s has been released from prison by %s, reason: %s", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid), reason);
			SendClientMessageToAllEx(COLOR_LIGHTRED, string);

			PhoneOnline[giveplayerid] = 0;
			//PlayerInfo[giveplayerid][pWantedLevel] = 0;
			PlayerInfo[giveplayerid][pBeingSentenced] = 0;
			SetPlayerToTeamColor(giveplayerid);
			SetHealth(giveplayerid, 100);
			//SetPlayerWantedLevel(giveplayerid, 0);
			PlayerInfo[giveplayerid][pJailTime] = 0;
			SetPlayerPos(giveplayerid, 1529.6,-1691.2,13.3);
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;
			strcpy(PlayerInfo[giveplayerid][pPrisonReason], "None", 128);
			SetPlayerToTeamColor(giveplayerid);
			for(new x = 0; x < 12; x++) GivePlayerValidWeapon(giveplayerid, PlayerInfo[giveplayerid][pJailedWeapons][x]);
			for(new y = 0; y < 5; y++) PlayerInfo[giveplayerid][pJailedInfo][y] = 0;
			for(new z = 0; z < 12; z++) PlayerInfo[giveplayerid][pJailedWeapons][z] = 0;
			SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, "Your punishment has been reversed by the administrator who jailed you.");
		}
		else SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /reverse [playerid] [reason]");
	}
	else SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use this command.");
	return 1;
}

CMD:dprison(playerid, params[])
{
	if((PlayerInfo[playerid][pAdmin] >= 2 && (PlayerInfo[playerid][pFactionModerator] > 0 || PlayerInfo[playerid][pGangModerator] > 0 ||
	PlayerInfo[playerid][pBM] > 0)) || PlayerInfo[playerid][pAdmin] >= 1337) {
		new giveplayerid, mintues;
		if(!sscanf(params, "ud", giveplayerid, mintues)) {
			if(PlayerInfo[giveplayerid][pAdmin] >= 2 || PlayerInfo[giveplayerid][pWatchdog] >= 2) return SendClientMessageEx(playerid, COLOR_WHITE, "You cannot use this on admins or watchdogs!");
			if(mintues > 120) return SendClientMessageEx(playerid, COLOR_WHITE, "Time cannot be above 120 minutes.");
			if(PrisonPlayer(playerid, giveplayerid, "Violation of DGA Policies", .time=mintues, .custom=1) == 0) return 1;
		}
		else SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /dprison [playerid] [time]");
	}
	else SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use this command!");
	return 1;
}

PrisonPlayer(playerid, giveplayerid, reason[], time=0, silent=0, custom=0)
{
	new string[128], shortreason[5], jailtime, twarn, warn, fine, nonrp;
	new rand = random(sizeof(OOCPrisonSpawns));

	// Reset.
	PlayerInfo[giveplayerid][pJailedInfo][0] = PlayerInfo[playerid][pId];
	PlayerInfo[giveplayerid][pJailedInfo][1] = 0;
	PlayerInfo[giveplayerid][pJailedInfo][2] = 0;
	PlayerInfo[giveplayerid][pJailedInfo][3] = 0;
	PlayerInfo[giveplayerid][pJailedInfo][4] = 0;

	for(new i = 0; i < 12; i++) PlayerInfo[giveplayerid][pJailedWeapons][i] = 0;

	if(time > 0) jailtime = time;

	if(!strcmp(reason, "Deathmatching", true) && !custom) {
		strcpy(shortreason, "DM", 5);
		if(!time) {
			new hours = PlayerInfo[giveplayerid][pConnectHours];
			if(hours > 2 && hours <= 24) {
				PlayerInfo[giveplayerid][pWRestricted] = 4;
				jailtime = 30;
				twarn = 1;
			}
			else if(hours > 24 && hours <= 72) {
				PlayerInfo[giveplayerid][pWRestricted] = 8;
				PlayerInfo[giveplayerid][pWarns] += 1;
				jailtime = 60;
				warn = 1;
				fine = 15;
			}
			else if(hours > 72 && hours <= 140) {
				PlayerInfo[giveplayerid][pWRestricted] = 12;
				PlayerInfo[giveplayerid][pWarns] += 1;
				warn = 1;
				jailtime = 90;
				fine = 15;
			}
			else if(hours > 140) {
				PlayerInfo[giveplayerid][pWRestricted] = 16;
				PlayerInfo[giveplayerid][pWarns] += 1;
				warn = 1;
				jailtime = 120;
				fine = 15;
			}
		}
	}
	else if(!strcmp(reason, "Revenge Killing", true) && !custom) {
		strcpy(shortreason, "RK", 5);
		if(!time) {
			new hours = PlayerInfo[giveplayerid][pConnectHours];
			if(hours > 2 && hours <= 24) {
				PlayerInfo[giveplayerid][pWRestricted] = 2;
				jailtime = 30;
				twarn = 1;
			}
			else if(hours > 24 && hours <= 72) {
				PlayerInfo[giveplayerid][pWRestricted] = 4;
				PlayerInfo[giveplayerid][pWarns] += 1;
				jailtime = 60;
				warn = 1;
				fine = 10;
			}
			else if(hours > 72 && hours <= 140) {
				PlayerInfo[giveplayerid][pWRestricted] = 6;
				PlayerInfo[giveplayerid][pWarns] += 1;
				warn = 1;
				jailtime = 90;
				fine = 10;
			}
			else if(hours > 140) {
				PlayerInfo[giveplayerid][pWRestricted] = 8;
				PlayerInfo[giveplayerid][pWarns] += 1;
				warn = 1;
				jailtime = 120;
				fine = 10;
			}
		}
	}
	else if(!strcmp(reason, "Non-Roleplay Behaviour", true) && !custom) {
		strcpy(shortreason, "NONRP", 5);
		if(!time) {
			new hours = PlayerInfo[giveplayerid][pConnectHours];
			if(hours > 2 && hours <= 24) {
				twarn = 1;
				jailtime = 30;
			}
			else if(hours > 24 && hours <= 72) {
				twarn = 1;
				jailtime = 60;
				fine = 10;
			}
			else if(hours > 72 && hours <= 140) {
				twarn = 1;
				jailtime = 90;
				fine = 10;
			}
			else if(hours > 140) {
				jailtime = 120;
				fine = 10;
			}
		}
	}
	else if(!strcmp(reason, "Metagaming", true) && !custom) {
		strcpy(shortreason, "MG", 5);
		if(!time) {
			new hours = PlayerInfo[giveplayerid][pConnectHours];
			if(hours > 2 && hours <= 24) {
				jailtime = 15;
				twarn = 1;
			}
			else if(hours > 24 && hours <= 72) {
				jailtime = 30;
				twarn = 1;
			}
			else if(hours > 72 && hours <= 140) {
				jailtime = 45;
			}
			else if(hours > 140) {
				jailtime = 60;
			}
		}
	}
	else if(!strcmp(reason, "Powergaming", true) && !custom) {
		strcpy(shortreason, "PG", 5);
		if(!time) {
			new hours = PlayerInfo[giveplayerid][pConnectHours];
			if(hours > 2 && hours <= 24) {
				jailtime = 15;
				twarn = 1;
			}
			else if(hours > 24 && hours <= 72) {
				jailtime = 30;
				twarn = 1;
				fine = 10;
			}
			else if(hours > 72 && hours <= 140) {
				jailtime = 45;
				fine = 10;
			}
			else if(hours > 140) {
				jailtime = 60;
				fine = 10;
			}
		}
	}
	else if(!strcmp(reason, "Killing On Sight", true) && !custom) {
		strcpy(shortreason, "KOS", 5);
		if(!time) {
			new hours = PlayerInfo[giveplayerid][pConnectHours];
			if(hours > 2 && hours <= 24) {
				PlayerInfo[giveplayerid][pWRestricted] = 2;
				jailtime = 30;
				twarn = 1;
			}
			else if(hours > 24 && hours <= 72) {
				PlayerInfo[giveplayerid][pWRestricted] = 4;
				PlayerInfo[giveplayerid][pWarns] += 1;
				jailtime = 60;
				warn = 1;
				fine = 10;
			}
			else if(hours > 72 && hours <= 140) {
				PlayerInfo[giveplayerid][pWRestricted] = 8;
				PlayerInfo[giveplayerid][pWarns] += 1;
				warn = 1;
				jailtime = 90;
				fine = 10;
			}
			else if(hours > 140) {
				PlayerInfo[giveplayerid][pWRestricted] = 12;
				PlayerInfo[giveplayerid][pWarns] += 1;
				warn = 1;
				jailtime = 120;
				fine = 10;
			}
		}
	}

	PlayerInfo[giveplayerid][pJailedInfo][2] = jailtime;
	if(!custom) {
		PlayerInfo[giveplayerid][pJailedInfo][4] = PlayerInfo[giveplayerid][pWRestricted];
		PlayerInfo[giveplayerid][pJailedInfo][3] = warn;
	}
	for(new x = 0; x < 12; x++) PlayerInfo[giveplayerid][pJailedWeapons][x] = PlayerInfo[giveplayerid][pGuns][x];
	ResetPlayerWeaponsEx(giveplayerid);

	if(fine > 0) {
		new totalwealth = PlayerInfo[giveplayerid][pAccount] + GetPlayerCash(giveplayerid);
		if(PlayerInfo[giveplayerid][pPhousekey] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[giveplayerid][pPhousekey]][hOwnerID] == GetPlayerSQLId(giveplayerid)) totalwealth += HouseInfo[PlayerInfo[giveplayerid][pPhousekey]][hSafeMoney];
		if(PlayerInfo[giveplayerid][pPhousekey2] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[giveplayerid][pPhousekey2]][hOwnerID] == GetPlayerSQLId(giveplayerid)) totalwealth += HouseInfo[PlayerInfo[giveplayerid][pPhousekey2]][hSafeMoney];
		if(PlayerInfo[giveplayerid][pPhousekey3] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[giveplayerid][pPhousekey3]][hOwnerID] == GetPlayerSQLId(giveplayerid)) totalwealth += HouseInfo[PlayerInfo[giveplayerid][pPhousekey3]][hSafeMoney];
		if(totalwealth > 0) fine = fine*totalwealth/100;
		if(fine > 0) {
			GivePlayerCash(giveplayerid, -fine);
			PlayerInfo[giveplayerid][pJailedInfo][1] = fine;
		}
	}

	if(PlayerInfo[giveplayerid][pAccountRestricted] == 1) {
		CreateBan(playerid, PlayerInfo[giveplayerid][pId], giveplayerid, PlayerInfo[giveplayerid][pIP], "Punished Whilst Restricted", 14);
		return 0;
	}

	if(PlayerInfo[giveplayerid][pWarns] >= 3) {
		PlayerInfo[playerid][pWarns] = 0;
		CreateBan(playerid, PlayerInfo[giveplayerid][pId], giveplayerid, PlayerInfo[giveplayerid][pIP], "3 Warnings", 14);
		return 0;
	}

	if(GetPVarInt(giveplayerid, "Injured") == 1) {
		KillEMSQueue(giveplayerid);
		ClearAnimationsEx(giveplayerid);
	}

	if(GetPVarType(giveplayerid, "IsInArena")) LeavePaintballArena(giveplayerid, GetPVarInt(giveplayerid, "IsInArena"));
	if(silent) format(string, 128, "AdmCmd: %s has been prisoned by an admin, reason: %s", GetPlayerNameEx(giveplayerid), reason);
	else format(string, 128, "AdmCmd: %s has been prisoned by %s, reason: %s", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid), reason);
	SendClientMessageToAllEx(COLOR_LIGHTRED, string);
	StaffAccountCheck(giveplayerid, GetPlayerIpEx(giveplayerid));
	//PlayerInfo[giveplayerid][pWantedLevel] = 0;
	//SetPlayerWantedLevel(giveplayerid, 0);
	PlayerInfo[giveplayerid][pJailTime] = jailtime*60;
	SetPVarInt(giveplayerid, "_rAppeal", gettime()+60);
	if(!custom) format(PlayerInfo[giveplayerid][pPrisonReason], 128, "[OOC][PRISON][%s]", shortreason);
	else format(PlayerInfo[giveplayerid][pPrisonReason], 128, "[OOC][PRISON][ADM] %s", reason);
	strcpy(PlayerInfo[giveplayerid][pPrisonedBy], GetPlayerNameEx(playerid), MAX_PLAYER_NAME);
	PhoneOnline[giveplayerid] = 1;
	SetPlayerInterior(giveplayerid, 1);
	SetHealth(giveplayerid, 0x7FB00000);
	PlayerInfo[giveplayerid][pInt] = 1;
	Streamer_UpdateEx(giveplayerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2]);
	SetPlayerPos(giveplayerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2]);
	SetPlayerSkin(giveplayerid, 50);
	SetPlayerColor(giveplayerid, TEAM_APRISON_COLOR);
	Player_StreamPrep(giveplayerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2], FREEZE_TIME);

	if(silent) format(string, 128, "You have been prisoned by an admin for %d minutes, reason: %s.", jailtime, reason);
	else format(string, 128, "You have been prisoned by %s for %d minutes, reason: %s.", GetPlayerNameEx(playerid), jailtime, reason);
	SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);

	if(fine > 0) {
		format(string, 128, "You have been fined a total of $%s for this action", number_format(fine));
		SendClientMessageEx(giveplayerid, COLOR_WHITE, string);
	}

	if(twarn) {
		SendClientMessageEx(giveplayerid, COLOR_LIGHTRED, "WARNING: As your hours, not level, progress, the punishments increase. Please mind the rules.");
	}

	format(szMiscArray, sizeof(szMiscArray), "AdmCmd: %s(%d) has been prisoned by %s, reason: %s (F:%s|W:%d|WR:%d|NonRP:%d)", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), GetPlayerNameEx(playerid), reason, number_format(fine), warn, PlayerInfo[giveplayerid][pWRestricted], nonrp);
	Log("logs/admin.log", szMiscArray);
	DeletePVar(playerid, "PendingAction");
	DeletePVar(playerid, "PendingAction2");
	if(AlertTime[GetPVarInt(playerid, "PendingAction3")] != 0) AlertTime[GetPVarInt(playerid, "PendingAction3")] = 0;
	DeletePVar(playerid, "PendingAction3");
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	new string[128];
	if(dialogid == DIALOG_REVERSE) {
		new rPlayerID = GetPVarInt(playerid, "ReverseFromID");
		new releasedID = GetPVarInt(rPlayerID, "ReverseID");
		if(response) {
			if(PlayerInfo[releasedID][pJailedInfo][1] > 0) GivePlayerCash(releasedID, PlayerInfo[releasedID][pJailedInfo][1]);
			if(PlayerInfo[releasedID][pJailedInfo][3] == 1) PlayerInfo[releasedID][pWarns]--;
			format(string, 128, "AdmCmd: %s(%d) has been released from prison (/reverse) by %s, reason: Reversed (%s)", GetPlayerNameEx(releasedID), GetPlayerSQLId(releasedID), GetPlayerNameEx(playerid), GetPlayerNameEx(rPlayerID));
			Log("logs/admin.log", string);
			format(string, 128, "AdmCmd: %s has been released from prison by %s, reason: Reversed (%s)", GetPlayerNameEx(releasedID), GetPlayerNameEx(playerid), GetPlayerNameEx(rPlayerID));
			SendClientMessageToAllEx(COLOR_LIGHTRED, string);
			//PlayerInfo[releasedID][pWantedLevel] = 0;
			PlayerInfo[releasedID][pBeingSentenced] = 0;
			SetPlayerToTeamColor(releasedID);
			SetHealth(releasedID, 100);
			//SetPlayerWantedLevel(releasedID, 0);
			PlayerInfo[releasedID][pJailTime] = 0;
			SetPlayerPos(releasedID, 1529.6,-1691.2,13.3);
			SetPlayerInterior(releasedID,0);
			PlayerInfo[releasedID][pInt] = 0;
			SetPlayerVirtualWorld(releasedID, 0);
			PlayerInfo[releasedID][pVW] = 0;
			strcpy(PlayerInfo[releasedID][pPrisonReason], "None", 128);
			SetPlayerToTeamColor(releasedID);
			for(new x = 0; x < 12; x++) GivePlayerValidWeapon(releasedID, PlayerInfo[releasedID][pJailedWeapons][x]);
			for(new y = 0; y < 5; y++) PlayerInfo[releasedID][pJailedInfo][y] = 0;
			for(new z = 0; z < 12; z++) PlayerInfo[releasedID][pJailedWeapons][z] = 0;
			SendClientMessageEx(releasedID, COLOR_LIGHTBLUE, "Your punishment has been reversed by the administrator who jailed you.");
		}
		else {
			format(string, 128, "Administrator %s has denied your request to reverse your action.", GetPlayerNameEx(playerid));
			SendClientMessageEx(rPlayerID, COLOR_RED, string);
		}
		DeletePVar(playerid, "ReverseFromID");
		DeletePVar(rPlayerID, "ReverseReason");
		DeletePVar(rPlayerID, "ReverseID");
	}
	return 0;
}
