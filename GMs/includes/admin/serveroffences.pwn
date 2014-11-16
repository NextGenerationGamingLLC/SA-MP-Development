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

CMD:kos(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 3)
	{
		new giveplayerid, string[128], time, fine = 0;
		if(!sscanf(params, "u", giveplayerid))
		{
			if(PlayerInfo[playerid][pAdmin] <= PlayerInfo[giveplayerid][pAdmin])
			{
				SendClientMessageEx(playerid, COLOR_GRAD2, "You can't perform this action on an equal or higher level administrator.");
				return 1;
			}

			if(!IsPlayerConnected(giveplayerid))
			{
				SendClientMessageEx(playerid, COLOR_GRAD2, "That player is not connected.");
				return 1;
			}

			SetPlayerArmedWeapon(giveplayerid, 0);

			if(GetPVarInt(giveplayerid, "IsInArena") >= 0)
				 LeavePaintballArena(giveplayerid, GetPVarInt(giveplayerid, "IsInArena"));

			new playerlevel = PlayerInfo[giveplayerid][pLevel];
			new totalwealth = PlayerInfo[giveplayerid][pAccount] + GetPlayerCash(giveplayerid);
			if(PlayerInfo[giveplayerid][pPhousekey] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[giveplayerid][pPhousekey]][hOwnerID] == GetPlayerSQLId(giveplayerid)) totalwealth += HouseInfo[PlayerInfo[giveplayerid][pPhousekey]][hSafeMoney];
			if(PlayerInfo[giveplayerid][pPhousekey2] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[giveplayerid][pPhousekey2]][hOwnerID] == GetPlayerSQLId(giveplayerid)) totalwealth += HouseInfo[PlayerInfo[giveplayerid][pPhousekey2]][hSafeMoney];
			if(PlayerInfo[giveplayerid][pPhousekey3] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[giveplayerid][pPhousekey3]][hOwnerID] == GetPlayerSQLId(giveplayerid)) totalwealth += HouseInfo[PlayerInfo[giveplayerid][pPhousekey3]][hSafeMoney];
			
			if(totalwealth > 0 && playerlevel > 5)
			{
				fine = 10*totalwealth/100;
			}
			if(fine > 0) {
				GivePlayerCash(giveplayerid, -fine);
			}

			if(playerlevel <= 5) time = 30;
			else if(playerlevel > 5 && playerlevel < 10) time = 60;
			else time = 120; // level is greater than 10
						
			if(playerlevel >= 10)  PlayerInfo[giveplayerid][pWarns] += 1;
			if(PlayerInfo[giveplayerid][pWarns] >= 3)
			{
				new ip[32];
				GetPlayerIp(giveplayerid,ip,sizeof(ip));
				format(string, sizeof(string), "AdmCmd: %s(%d) (IP: %s) was banned (/kos) by %s (had 3 Warnings), reason: Killing on Sight", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), ip, GetPlayerNameEx(playerid));
				Log("logs/ban.log", string);
				format(string, sizeof(string), "AdmCmd: %s was banned by %s (had 3 Warnings), reason: Killing on Sight", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid));
				SendClientMessageToAllEx(COLOR_LIGHTRED, string);
				if(fine > 0) {
					format(string, sizeof(string), "You have been fined $%s (10 percent of your total wealth).", number_format(fine));
					SendClientMessageEx(giveplayerid, COLOR_LIGHTRED, string);
					format(string, sizeof(string), "AdmCmd: %s(%d) was fined $%s by %s (/kos).", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), number_format(fine), GetPlayerNameEx(playerid));
					Log("logs/admin.log", string);
				}
				StaffAccountCheck(giveplayerid, GetPlayerIpEx(giveplayerid));
				PlayerInfo[giveplayerid][pBanned] = 1;
				AddBan(playerid, giveplayerid, "Player had 3 warnings");
				MySQLBan(GetPlayerSQLId(giveplayerid), ip, "Third Warning (KoS)", 1,GetPlayerNameEx(playerid));
				SetTimerEx("KickEx", 1000, 0, "i", giveplayerid);
				return 1;
			}
			if(GetPVarInt(giveplayerid, "Injured") == 1)
			{
				KillEMSQueue(giveplayerid);
				ClearAnimations(giveplayerid);
			}
			if(GetPVarInt(giveplayerid, "IsInArena") >= 0) LeavePaintballArena(giveplayerid, GetPVarInt(giveplayerid, "IsInArena"));
			GameTextForPlayer(giveplayerid, "~w~Welcome to ~n~~r~Fort DeMorgan", 5000, 3);
			ResetPlayerWeaponsEx(giveplayerid);
			format(string, sizeof(string), "AdmCmd: %s(%d) has been prisoned (/kos) by %s, reason: Killing on Sight ", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), GetPlayerNameEx(playerid));
			Log("logs/admin.log", string);
			format(string, sizeof(string), "AdmCmd: %s has been prisoned by %s, reason: Killing on Sight", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid));
    		SendClientMessageToAllEx(COLOR_LIGHTRED, string);
			StaffAccountCheck(giveplayerid, GetPlayerIpEx(giveplayerid));
			PlayerInfo[giveplayerid][pWantedLevel] = 0;
			SetPlayerWantedLevel(giveplayerid, 0);
			PlayerInfo[giveplayerid][pJailTime] = time*60;
			SetPVarInt(giveplayerid, "_rAppeal", gettime()+60);			
			strcpy(PlayerInfo[giveplayerid][pPrisonReason], "[OOC][PRISON][/KOS]", 128);
			strcpy(PlayerInfo[giveplayerid][pPrisonedBy], GetPlayerNameEx(playerid), MAX_PLAYER_NAME);
			PhoneOnline[giveplayerid] = 1;
			SetPlayerInterior(giveplayerid, 1);
			SetPlayerHealth(giveplayerid, 0x7FB00000);
			PlayerInfo[giveplayerid][pInt] = 1;
			new rand = random(sizeof(OOCPrisonSpawns));
			Streamer_UpdateEx(giveplayerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2]);
			SetPlayerPos(giveplayerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2]);
			SetPlayerSkin(giveplayerid, 50);
			SetPlayerColor(giveplayerid, TEAM_APRISON_COLOR);
			Player_StreamPrep(giveplayerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2], FREEZE_TIME);

			if(time == 30) format(string, sizeof(string), "You have been prisoned for Killing on Sight - you will be prisoned for 30 minutes.");
			else if(time == 60) format(string, sizeof(string), "You have been prisoned for Killing on Sight - you will be prisoned for 1 hour.");
			else format(string, sizeof(string), "You have been prisoned for Killing on Sight - you will be prisoned for 2 hours.");
			SendClientMessageEx(giveplayerid, COLOR_LIGHTRED, string);
			
			if(fine > 0) {
				format(string, sizeof(string), "You have been fined $%s (10 percent of your total wealth).", number_format(fine));
				SendClientMessageEx(giveplayerid, COLOR_LIGHTRED, string);
				format(string, sizeof(string), "AdmCmd: %s(%d) was fined $%s by %s (/kos).", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), number_format(fine), GetPlayerNameEx(playerid));
				Log("logs/admin.log", string);
			}	
			
			if(PlayerInfo[giveplayerid][pAccountRestricted] == 1)
			{
				new ip[32];
				GetPlayerIp(giveplayerid,ip,sizeof(ip));
				format(string, sizeof(string), "AdmCmd: %s(%d) (IP: %s) was banned by %s (Punished while restricted), reason: KoS", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), ip, GetPlayerNameEx(playerid));
				Log("logs/ban.log", string);
				format(string, sizeof(string), "AdmCmd: %s was banned by %s (Punished while restricted), reason: KoS", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid));
				SendClientMessageToAllEx(COLOR_LIGHTRED, string);
				PlayerInfo[giveplayerid][pBanned] = 1;
				AddBan(playerid, giveplayerid, "Punished while account restricted");
				MySQLBan(GetPlayerSQLId(giveplayerid), ip, "Punished while account restricted - KoS", 1, GetPlayerNameEx(playerid));
				SetTimerEx("KickEx", 1000, 0, "i", giveplayerid);
				return true;
			}
			
			if(giveplayerid == GetPVarInt(playerid, "PendingAction2"))
			{
				if(AlertTime[GetPVarInt(playerid, "PendingAction3")] != 0)
				{
					if(GetPVarInt(playerid, "PendingAction") == 3) // KoS
					{
						format(string, sizeof(string), "You have taken action on %s after processing a Killing on Sight Alert, we've automatically issued 3 points to the player.", GetPlayerNameEx(giveplayerid));
						SendClientMessageEx(playerid, COLOR_CYAN, string);
						
						AddNonRPPoint(giveplayerid, 3, gettime()+2592000, "Killing on Sight", playerid, 0);
						PlayerInfo[giveplayerid][pNonRPMeter] += 3;

						SendClientMessageEx(giveplayerid, COLOR_CYAN, "The server has automatically issued you 3 Non RP Points for Killing on Sight.");
						
						format(string, sizeof(string), "%s(%d) has been issued 3 Non RP Points for Revenge Killing.", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid));
						Log("logs/nonrppoints.log", string);
					}
					
					if(PlayerInfo[giveplayerid][pNonRPMeter] >= 15)
					{
						format(string, sizeof(string), "%s(%i) Account Restriction", GetPlayerNameEx(giveplayerid), giveplayerid);
						SendReportToQue(playerid, string, 4, GetPlayerPriority(playerid));
						SetPVarInt(playerid, "AccountRestrictionReport", 1);
						SetPVarInt(playerid, "AccountRestID", giveplayerid);
					}
				}
			}
			
			DeletePVar(playerid, "PendingAction");
			DeletePVar(playerid, "PendingAction2");
			if(AlertTime[GetPVarInt(playerid, "PendingAction3")] != 0) AlertTime[GetPVarInt(playerid, "PendingAction3")] = 0;
			DeletePVar(playerid, "PendingAction3");
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /kos [playerid]");
			SendClientMessageEx(playerid, COLOR_GREY, "Note: Depending on the player level, this will issue up to 2 hours, a warning, and a 10 percent fine.");
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use this command!");
	}
	return 1;
}

CMD:skos(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pUndercover] > 0)
	{
		new giveplayerid, string[128], time, fine = 0;
		if(!sscanf(params, "u", giveplayerid))
		{
			if(PlayerInfo[playerid][pAdmin] <= PlayerInfo[giveplayerid][pAdmin])
			{
				SendClientMessageEx(playerid, COLOR_GRAD2, "You can't perform this action on an equal or higher level administrator.");
				return 1;
			}

			if(!IsPlayerConnected(giveplayerid))
			{
				SendClientMessageEx(playerid, COLOR_GRAD2, "That player is not connected.");
				return 1;
			}

			SetPlayerArmedWeapon(giveplayerid, 0);

			if(GetPVarInt(giveplayerid, "IsInArena") >= 0)
				 LeavePaintballArena(giveplayerid, GetPVarInt(giveplayerid, "IsInArena"));

			new playerlevel = PlayerInfo[giveplayerid][pLevel];
			new totalwealth = PlayerInfo[giveplayerid][pAccount] + GetPlayerCash(giveplayerid);
			if(PlayerInfo[giveplayerid][pPhousekey] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[giveplayerid][pPhousekey]][hOwnerID] == GetPlayerSQLId(giveplayerid)) totalwealth += HouseInfo[PlayerInfo[giveplayerid][pPhousekey]][hSafeMoney];
			if(PlayerInfo[giveplayerid][pPhousekey2] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[giveplayerid][pPhousekey2]][hOwnerID] == GetPlayerSQLId(giveplayerid)) totalwealth += HouseInfo[PlayerInfo[giveplayerid][pPhousekey2]][hSafeMoney];

			if(totalwealth > 0 && playerlevel > 5) // above 5 gets a fine
			{
				fine = 10*totalwealth/100;
			}
			if(fine > 0) {
				GivePlayerCash(giveplayerid, -fine);
			}	

			if(playerlevel <= 5) time = 30;
			else if(playerlevel > 5 && playerlevel < 10) time = 60;
			else time = 120; // level is greater than 10
						
			if(playerlevel >= 10)  PlayerInfo[giveplayerid][pWarns] += 1;
			if(PlayerInfo[giveplayerid][pWarns] >= 3)
			{
				new ip[32];
				GetPlayerIp(giveplayerid,ip,sizeof(ip));
				format(string, sizeof(string), "AdmCmd: %s(%d) (IP: %s) was banned (/skos) by %s (had 3 Warnings), reason: Killing on Sight", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), ip, GetPlayerNameEx(playerid));
				Log("logs/ban.log", string);
				format(string, sizeof(string), "AdmCmd: %s was banned by %s (had 3 Warnings), reason: Killing on Sight", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid));
				ABroadCast(COLOR_LIGHTRED, string, 2);
				if(fine > 0) {
					format(string, sizeof(string), "You have been fined $%s (10 percent of your total wealth).", number_format(fine));
					SendClientMessageEx(giveplayerid, COLOR_LIGHTRED, string);
					format(string, sizeof(string), "AdmCmd: %s(%d) was fined $%s by %s (/skos).", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), number_format(fine), GetPlayerNameEx(playerid));
					Log("logs/admin.log", string);
				}
				StaffAccountCheck(giveplayerid, GetPlayerIpEx(giveplayerid));
				PlayerInfo[giveplayerid][pBanned] = 1;
				AddBan(playerid, giveplayerid, "Player had 3 warnings");
				MySQLBan(GetPlayerSQLId(giveplayerid), ip, "Third Warning (KoS)", 1,GetPlayerNameEx(playerid));
				SetTimerEx("KickEx", 1000, 0, "i", giveplayerid);
				return 1;
			}
			if(GetPVarInt(giveplayerid, "Injured") == 1)
			{
				KillEMSQueue(giveplayerid);
				ClearAnimations(giveplayerid);
			}
			if(GetPVarInt(giveplayerid, "IsInArena") >= 0) LeavePaintballArena(giveplayerid, GetPVarInt(giveplayerid, "IsInArena"));
			GameTextForPlayer(giveplayerid, "~w~Welcome to ~n~~r~Fort DeMorgan", 5000, 3);
			ResetPlayerWeaponsEx(giveplayerid);
			format(string, sizeof(string), "AdmCmd: %s(%d) has been silent prisoned (/skos) by %s, reason: Killing on Sight ", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), GetPlayerNameEx(playerid));
			Log("logs/admin.log", string);
			format(string, sizeof(string), "AdmCmd: %s has been prisoned by an Admin, reason: Killing on Sight", GetPlayerNameEx(giveplayerid));
    		SendClientMessageToAllEx(COLOR_LIGHTRED, string);
			StaffAccountCheck(giveplayerid, GetPlayerIpEx(giveplayerid));
			PlayerInfo[giveplayerid][pWantedLevel] = 0;
			SetPlayerWantedLevel(giveplayerid, 0);
			PlayerInfo[giveplayerid][pJailTime] = time*60;
			SetPVarInt(giveplayerid, "_rAppeal", gettime()+60);			
			strcpy(PlayerInfo[giveplayerid][pPrisonReason], "[OOC][PRISON][/SKOS]", 128);
			strcpy(PlayerInfo[giveplayerid][pPrisonedBy], GetPlayerNameEx(playerid), MAX_PLAYER_NAME);
			PhoneOnline[giveplayerid] = 1;
			SetPlayerInterior(giveplayerid, 1);
			SetPlayerHealth(giveplayerid, 0x7FB00000);
			PlayerInfo[giveplayerid][pInt] = 1;
			new rand = random(sizeof(OOCPrisonSpawns));
			Streamer_UpdateEx(giveplayerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2]);
			SetPlayerPos(giveplayerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2]);
			SetPlayerSkin(giveplayerid, 50);
			SetPlayerColor(giveplayerid, TEAM_APRISON_COLOR);
			Player_StreamPrep(giveplayerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2], FREEZE_TIME);

			if(time == 30) format(string, sizeof(string), "You have been prisoned for Killing on Sight - you will be prisoned for 30 minutes.");
			else if(time == 60) format(string, sizeof(string), "You have been prisoned for Killing on Sight - you will be prisoned for 1 hour.");
			else format(string, sizeof(string), "You have been prisoned for Killing on Sight - you will be prisoned for 2 hours.");
			SendClientMessageEx(giveplayerid, COLOR_LIGHTRED, string);
			
			if(fine > 0) {
				format(string, sizeof(string), "You have been fined $%s (10 percent of your total wealth).", number_format(fine));
				SendClientMessageEx(giveplayerid, COLOR_LIGHTRED, string);
				format(string, sizeof(string), "AdmCmd: %s(%d) was fined $%s by %s (/skos).", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), number_format(fine), GetPlayerNameEx(playerid));
				Log("logs/admin.log", string);
			}	
			
			if(PlayerInfo[giveplayerid][pAccountRestricted] == 1)
			{
				new ip[32];
				GetPlayerIp(giveplayerid,ip,sizeof(ip));
				format(string, sizeof(string), "AdmCmd: %s(%d) (IP: %s) was banned by an Admin (Punished while restricted), reason: KoS", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), ip);
				Log("logs/ban.log", string);
				format(string, sizeof(string), "AdmCmd: %s was banned by an Admin (Punished while restricted), reason: KoS", GetPlayerNameEx(giveplayerid));
				SendClientMessageToAllEx(COLOR_LIGHTRED, string);
				PlayerInfo[giveplayerid][pBanned] = 1;
				AddBan(playerid, giveplayerid, "Punished while account restricted");
				MySQLBan(GetPlayerSQLId(giveplayerid), ip, "Punished while account restricted - KoS", 1, GetPlayerNameEx(playerid));
				SetTimerEx("KickEx", 1000, 0, "i", giveplayerid);
				return true;
			}
			
			if(giveplayerid == GetPVarInt(playerid, "PendingAction2"))
			{
				if(AlertTime[GetPVarInt(playerid, "PendingAction3")] != 0)
				{
					if(GetPVarInt(playerid, "PendingAction") == 3) // KoS
					{
						format(string, sizeof(string), "You have taken action on %s after processing a Killing on Sight Alert, we've automatically issued 3 points to the player.", GetPlayerNameEx(giveplayerid));
						SendClientMessageEx(playerid, COLOR_CYAN, string);
						
						AddNonRPPoint(giveplayerid, 3, gettime()+2592000, "Killing on Sight", playerid, 0);
						PlayerInfo[giveplayerid][pNonRPMeter] += 3;

						SendClientMessageEx(giveplayerid, COLOR_CYAN, "The server has automatically issued you 3 Non RP Points for Killing on Sight.");
						
						format(string, sizeof(string), "%s(%d) has been issued 3 Non RP Points for Revenge Killing.", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid));
						Log("logs/nonrppoints.log", string);
					}
					
					if(PlayerInfo[giveplayerid][pNonRPMeter] >= 15)
					{
						format(string, sizeof(string), "%s(%i) Account Restriction", GetPlayerNameEx(giveplayerid), giveplayerid);
						SendReportToQue(playerid, string, 4, GetPlayerPriority(playerid));
						SetPVarInt(playerid, "AccountRestrictionReport", 1);
						SetPVarInt(playerid, "AccountRestID", giveplayerid);
					}
				}
			}
			
			DeletePVar(playerid, "PendingAction");
			DeletePVar(playerid, "PendingAction2");
			if(AlertTime[GetPVarInt(playerid, "PendingAction3")] != 0) AlertTime[GetPVarInt(playerid, "PendingAction3")] = 0;
			DeletePVar(playerid, "PendingAction3");
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /skos [playerid]");
			SendClientMessageEx(playerid, COLOR_GREY, "Note: Depending on the player level, this will issue up to 2 hours, a warning, and a 10 percent fine.");
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use this command!");
	}
	return 1;
}

CMD:pg(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 3)
	{
		new giveplayerid, string[128], time;
		if(!sscanf(params, "u", giveplayerid))
		{
			if(PlayerInfo[playerid][pAdmin] <= PlayerInfo[giveplayerid][pAdmin])
			{
				SendClientMessageEx(playerid, COLOR_GRAD2, "You can't perform this action on an equal or higher level administrator.");
				return 1;
			}

			if(!IsPlayerConnected(giveplayerid))
			{
				SendClientMessageEx(playerid, COLOR_GRAD2, "That player is not connected.");
				return 1;
			}

			SetPlayerArmedWeapon(giveplayerid, 0);

			if(GetPVarInt(giveplayerid, "IsInArena") >= 0)
			{
				LeavePaintballArena(giveplayerid, GetPVarInt(giveplayerid, "IsInArena"));
			}

			new playerlevel = PlayerInfo[giveplayerid][pLevel];
			
			if(playerlevel <= 5) time = 15;
			else time = 60;
						
			if(playerlevel > 5)  PlayerInfo[giveplayerid][pWarns] += 1;
			if(PlayerInfo[giveplayerid][pWarns] >= 3)
			{
				new ip[32];
				GetPlayerIp(giveplayerid,ip,sizeof(ip));
				format(string, sizeof(string), "AdmCmd: %s(%d) (IP: %s) was banned (/pg) by %s (had 3 Warnings), reason: Powergaming", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), ip, GetPlayerNameEx(playerid));
				Log("logs/ban.log", string);
				format(string, sizeof(string), "AdmCmd: %s was banned by %s (had 3 Warnings), reason: Powergaming", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid));
				SendClientMessageToAllEx(COLOR_LIGHTRED, string);
				StaffAccountCheck(giveplayerid, GetPlayerIpEx(giveplayerid));
				PlayerInfo[giveplayerid][pBanned] = 1;
				AddBan(playerid, giveplayerid, "Player had 3 warnings");
				MySQLBan(GetPlayerSQLId(giveplayerid), ip, "Third Warning (PG)", 1,GetPlayerNameEx(playerid));
				SetTimerEx("KickEx", 1000, 0, "i", giveplayerid);
				return 1;
			}

			if(GetPVarInt(giveplayerid, "Injured") == 1)
			{
				KillEMSQueue(giveplayerid);
				ClearAnimations(giveplayerid);
			}

			if(GetPVarInt(giveplayerid, "IsInArena") >= 0) LeavePaintballArena(giveplayerid, GetPVarInt(giveplayerid, "IsInArena"));
			GameTextForPlayer(giveplayerid, "~w~Welcome to ~n~~r~Fort DeMorgan", 5000, 3);
			ResetPlayerWeaponsEx(giveplayerid);
			format(string, sizeof(string), "AdmCmd: %s(%d) has been prisoned by %s, reason: Powergaming", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), GetPlayerNameEx(playerid));
			Log("logs/admin.log", string);
			format(string, sizeof(string), "AdmCmd: %s has been prisoned by %s, reason: Powergaming", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid));
    		SendClientMessageToAllEx(COLOR_LIGHTRED, string);
			StaffAccountCheck(giveplayerid, GetPlayerIpEx(giveplayerid));
			PlayerInfo[giveplayerid][pWantedLevel] = 0;
			SetPlayerWantedLevel(giveplayerid, 0);
			PlayerInfo[giveplayerid][pJailTime] = time*60;
			SetPVarInt(giveplayerid, "_rAppeal", gettime()+60);			
			strcpy(PlayerInfo[giveplayerid][pPrisonReason], "[OOC][PRISON][/PG]", 128);
			strcpy(PlayerInfo[giveplayerid][pPrisonedBy], GetPlayerNameEx(playerid), MAX_PLAYER_NAME);
			PhoneOnline[giveplayerid] = 1;
			SetPlayerInterior(giveplayerid, 1);
			SetPlayerHealth(giveplayerid, 0x7FB00000);
			PlayerInfo[giveplayerid][pInt] = 1;
			new rand = random(sizeof(OOCPrisonSpawns));
			Streamer_UpdateEx(giveplayerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2]);
			SetPlayerPos(giveplayerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2]);
			SetPlayerSkin(giveplayerid, 50);
			SetPlayerColor(giveplayerid, TEAM_APRISON_COLOR);
			Player_StreamPrep(giveplayerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2], FREEZE_TIME);

			if(time == 15) format(string, sizeof(string), "You have been prisoned for Powergaming - you will be prisoned for 15 minutes.");
			else format(string, sizeof(string), "You have been prisoned for Powergaming - you will be prisoned for 1 hour.");
			SendClientMessageEx(giveplayerid, COLOR_LIGHTRED, string);	
			
			if(PlayerInfo[giveplayerid][pAccountRestricted] == 1)
			{
				new ip[32];
				GetPlayerIp(giveplayerid,ip,sizeof(ip));
				format(string, sizeof(string), "AdmCmd: %s(%d) (IP: %s) was banned by %s (Punished while restricted), reason: PG", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), ip, GetPlayerNameEx(playerid));
				Log("logs/ban.log", string);
				format(string, sizeof(string), "AdmCmd: %s was banned by %s (Punished while restricted), reason: PG", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid));
				SendClientMessageToAllEx(COLOR_LIGHTRED, string);
				PlayerInfo[giveplayerid][pBanned] = 1;
				AddBan(playerid, giveplayerid, "Punished while account restricted");
				MySQLBan(GetPlayerSQLId(giveplayerid), ip, "Punished while account restricted - PG", 1, GetPlayerNameEx(playerid));
				SetTimerEx("KickEx", 1000, 0, "i", giveplayerid);
				return true;
			}
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /pg [playerid]");
			SendClientMessageEx(playerid, COLOR_GREY, "Note: Depending on the player level, this will issue up to 1 hour prison, and a warning.");
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use this command!");
	}
	return 1;
}

CMD:spg(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pUndercover] > 0)
	{
		new giveplayerid, string[128], time;
		if(!sscanf(params, "u", giveplayerid))
		{
			if(PlayerInfo[playerid][pAdmin] <= PlayerInfo[giveplayerid][pAdmin])
			{
				SendClientMessageEx(playerid, COLOR_GRAD2, "You can't perform this action on an equal or higher level administrator.");
				return 1;
			}

			if(!IsPlayerConnected(giveplayerid))
			{
				SendClientMessageEx(playerid, COLOR_GRAD2, "That player is not connected.");
				return 1;
			}

			SetPlayerArmedWeapon(giveplayerid, 0);

			if(GetPVarInt(giveplayerid, "IsInArena") >= 0)
			{
				LeavePaintballArena(giveplayerid, GetPVarInt(giveplayerid, "IsInArena"));
			}

			new playerlevel = PlayerInfo[giveplayerid][pLevel];
			
			if(playerlevel <= 5) time = 15;
			else time = 60;
						
			if(playerlevel > 5)  PlayerInfo[giveplayerid][pWarns] += 1;
			if(PlayerInfo[giveplayerid][pWarns] >= 3)
			{
				new ip[32];
				GetPlayerIp(giveplayerid,ip,sizeof(ip));
				format(string, sizeof(string), "AdmCmd: %s(%d) (IP: %s) was banned (/spg) by %s (had 3 Warnings), reason: Powergaming", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), ip, GetPlayerNameEx(playerid));
				Log("logs/ban.log", string);
				format(string, sizeof(string), "AdmCmd: %s was banned by %s (had 3 Warnings), reason: Powergaming", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid));
				ABroadCast(COLOR_LIGHTRED, string, 2);
				StaffAccountCheck(giveplayerid, GetPlayerIpEx(giveplayerid));
				PlayerInfo[giveplayerid][pBanned] = 1;
				AddBan(playerid, giveplayerid, "Player had 3 warnings");
				MySQLBan(GetPlayerSQLId(giveplayerid), ip, "Third Warning (PG)", 1,GetPlayerNameEx(playerid));
				SetTimerEx("KickEx", 1000, 0, "i", giveplayerid);
				return 1;
			}

			if(GetPVarInt(giveplayerid, "Injured") == 1)
			{
				KillEMSQueue(giveplayerid);
				ClearAnimations(giveplayerid);
			}

			if(GetPVarInt(giveplayerid, "IsInArena") >= 0) LeavePaintballArena(giveplayerid, GetPVarInt(giveplayerid, "IsInArena"));
			GameTextForPlayer(giveplayerid, "~w~Welcome to ~n~~r~Fort DeMorgan", 5000, 3);
			ResetPlayerWeaponsEx(giveplayerid);
			format(string, sizeof(string), "AdmCmd: %s(%d) has been silent prisoned (/spg) by %s, reason: Powergaming", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), GetPlayerNameEx(playerid));
			Log("logs/admin.log", string);
			format(string, sizeof(string), "AdmCmd: %s has been prisoned by an Admin, reason: Powergaming", GetPlayerNameEx(giveplayerid));
    		SendClientMessageToAllEx(COLOR_LIGHTRED, string);
			StaffAccountCheck(giveplayerid, GetPlayerIpEx(giveplayerid));
			PlayerInfo[giveplayerid][pWantedLevel] = 0;
			SetPlayerWantedLevel(giveplayerid, 0);
			PlayerInfo[giveplayerid][pJailTime] = time*60;
			SetPVarInt(giveplayerid, "_rAppeal", gettime()+60);			
			strcpy(PlayerInfo[giveplayerid][pPrisonReason], "[OOC][PRISON][/SPG]", 128);
			strcpy(PlayerInfo[giveplayerid][pPrisonedBy], GetPlayerNameEx(playerid), MAX_PLAYER_NAME);
			PhoneOnline[giveplayerid] = 1;
			SetPlayerInterior(giveplayerid, 1);
			SetPlayerHealth(giveplayerid, 0x7FB00000);
			PlayerInfo[giveplayerid][pInt] = 1;
			new rand = random(sizeof(OOCPrisonSpawns));
			Streamer_UpdateEx(giveplayerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2]);
			SetPlayerPos(giveplayerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2]);
			SetPlayerSkin(giveplayerid, 50);
			SetPlayerColor(giveplayerid, TEAM_APRISON_COLOR);
			Player_StreamPrep(giveplayerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2], FREEZE_TIME);

			if(time == 15) format(string, sizeof(string), "You have been prisoned for Powergaming - you will be prisoned for 15 minutes.");
			else format(string, sizeof(string), "You have been prisoned for Powergaming - you will be prisoned for 1 hour.");
			SendClientMessageEx(giveplayerid, COLOR_LIGHTRED, string);	
			
			if(PlayerInfo[giveplayerid][pAccountRestricted] == 1)
			{
				new ip[32];
				GetPlayerIp(giveplayerid,ip,sizeof(ip));
				format(string, sizeof(string), "AdmCmd: %s(%d) (IP: %s) was banned by an Admin (Punished while restricted), reason: PG", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), ip);
				Log("logs/ban.log", string);
				format(string, sizeof(string), "AdmCmd: %s was banned by an Admin (Punished while restricted), reason: PG", GetPlayerNameEx(giveplayerid));
				SendClientMessageToAllEx(COLOR_LIGHTRED, string);
				PlayerInfo[giveplayerid][pBanned] = 1;
				AddBan(playerid, giveplayerid, "Punished while account restricted");
				MySQLBan(GetPlayerSQLId(giveplayerid), ip, "Punished while account restricted - PG", 1, GetPlayerNameEx(playerid));
				SetTimerEx("KickEx", 1000, 0, "i", giveplayerid);
				return true;
			}
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /spg [playerid]");
			SendClientMessageEx(playerid, COLOR_GREY, "Note: Depending on the player level, this will issue up to 1 hour prison, and a warning.");
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use this command!");
	}
	return 1;
}

CMD:mg(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 3)
	{
		new giveplayerid, string[128], time;
		if(!sscanf(params, "u", giveplayerid))
		{
			if(PlayerInfo[playerid][pAdmin] <= PlayerInfo[giveplayerid][pAdmin])
			{
				SendClientMessageEx(playerid, COLOR_GRAD2, "You can't perform this action on an equal or higher level administrator.");
				return 1;
			}

			if(!IsPlayerConnected(giveplayerid))
			{
				SendClientMessageEx(playerid, COLOR_GRAD2, "That player is not connected.");
				return 1;
			}

			SetPlayerArmedWeapon(giveplayerid, 0);

			if(GetPVarInt(giveplayerid, "IsInArena") >= 0)
			{
				LeavePaintballArena(giveplayerid, GetPVarInt(giveplayerid, "IsInArena"));
			}

			new playerlevel = PlayerInfo[giveplayerid][pLevel];
			
			if(playerlevel <= 5) time = 15;
			else time = 60;

			if(GetPVarInt(giveplayerid, "Injured") == 1)
			{
				KillEMSQueue(giveplayerid);
				ClearAnimations(giveplayerid);
			}

			if(GetPVarInt(giveplayerid, "IsInArena") >= 0) LeavePaintballArena(giveplayerid, GetPVarInt(giveplayerid, "IsInArena"));
			GameTextForPlayer(giveplayerid, "~w~Welcome to ~n~~r~Fort DeMorgan", 5000, 3);
			ResetPlayerWeaponsEx(giveplayerid);
			format(string, sizeof(string), "AdmCmd: %s(%d) has been prisoned (/mg) by %s, reason: Metagaming", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), GetPlayerNameEx(playerid));
			Log("logs/admin.log", string);
			format(string, sizeof(string), "AdmCmd: %s has been prisoned by %s, reason: Metagaming", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid));
    		SendClientMessageToAllEx(COLOR_LIGHTRED, string);
			StaffAccountCheck(giveplayerid, GetPlayerIpEx(giveplayerid));
			PlayerInfo[giveplayerid][pWantedLevel] = 0;
			SetPlayerWantedLevel(giveplayerid, 0);
			PlayerInfo[giveplayerid][pJailTime] = time*60;
			SetPVarInt(giveplayerid, "_rAppeal", gettime()+60);			
			strcpy(PlayerInfo[giveplayerid][pPrisonReason], "[OOC][PRISON][/MG]", 128);
			strcpy(PlayerInfo[giveplayerid][pPrisonedBy], GetPlayerNameEx(playerid), MAX_PLAYER_NAME);
			PhoneOnline[giveplayerid] = 1;
			SetPlayerInterior(giveplayerid, 1);
			SetPlayerHealth(giveplayerid, 0x7FB00000);
			PlayerInfo[giveplayerid][pInt] = 1;
			new rand = random(sizeof(OOCPrisonSpawns));
			Streamer_UpdateEx(giveplayerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2]);
			SetPlayerPos(giveplayerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2]);
			SetPlayerSkin(giveplayerid, 50);
			SetPlayerColor(giveplayerid, TEAM_APRISON_COLOR);
			Player_StreamPrep(giveplayerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2], FREEZE_TIME);

			if(time == 15) format(string, sizeof(string), "You have been prisoned for Metagaming - you will be prisoned for 15 minutes.");
			else format(string, sizeof(string), "You have been prisoned for Metagaming - you will be prisoned for 1 hour.");
			SendClientMessageEx(giveplayerid, COLOR_LIGHTRED, string);	
			
			if(PlayerInfo[giveplayerid][pAccountRestricted] == 1)
			{
				new ip[32];
				GetPlayerIp(giveplayerid,ip,sizeof(ip));
				format(string, sizeof(string), "AdmCmd: %s(%d) (IP: %s) was banned by %s (Punished while restricted), reason: MG", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), ip, GetPlayerNameEx(playerid));
				Log("logs/ban.log", string);
				format(string, sizeof(string), "AdmCmd: %s was banned by %s (Punished while restricted), reason: MG", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid));
				SendClientMessageToAllEx(COLOR_LIGHTRED, string);
				PlayerInfo[giveplayerid][pBanned] = 1;
				AddBan(playerid, giveplayerid, "Punished while account restricted");
				MySQLBan(GetPlayerSQLId(giveplayerid), ip, "Punished while account restricted - MG", 1, GetPlayerNameEx(playerid));
				SetTimerEx("KickEx", 1000, 0, "i", giveplayerid);
				return true;
			}
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /mg [playerid]");
			SendClientMessageEx(playerid, COLOR_GREY, "Note: Depending on the player level, this will issue up to a 1 hour prison.");
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use this command!");
	}
	return 1;
}

CMD:smg(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pUndercover] > 0)
	{
		new giveplayerid, string[128], time;
		if(!sscanf(params, "u", giveplayerid))
		{
			if(PlayerInfo[playerid][pAdmin] <= PlayerInfo[giveplayerid][pAdmin])
			{
				SendClientMessageEx(playerid, COLOR_GRAD2, "You can't perform this action on an equal or higher level administrator.");
				return 1;
			}

			if(!IsPlayerConnected(giveplayerid))
			{
				SendClientMessageEx(playerid, COLOR_GRAD2, "That player is not connected.");
				return 1;
			}

			SetPlayerArmedWeapon(giveplayerid, 0);

			if(GetPVarInt(giveplayerid, "IsInArena") >= 0)
			{
				LeavePaintballArena(giveplayerid, GetPVarInt(giveplayerid, "IsInArena"));
			}

			new playerlevel = PlayerInfo[giveplayerid][pLevel];
			
			if(playerlevel <= 5) time = 15;
			else time = 60;

			if(GetPVarInt(giveplayerid, "Injured") == 1)
			{
				KillEMSQueue(giveplayerid);
				ClearAnimations(giveplayerid);
			}

			if(GetPVarInt(giveplayerid, "IsInArena") >= 0) LeavePaintballArena(giveplayerid, GetPVarInt(giveplayerid, "IsInArena"));
			GameTextForPlayer(giveplayerid, "~w~Welcome to ~n~~r~Fort DeMorgan", 5000, 3);
			ResetPlayerWeaponsEx(giveplayerid);
			format(string, sizeof(string), "AdmCmd: %s(%d) has been silent prisoned (/smg) by %s, reason: Metagaming", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), GetPlayerNameEx(playerid));
			Log("logs/admin.log", string);
			format(string, sizeof(string), "AdmCmd: %s has been prisoned by an Admin, reason: Metagaming", GetPlayerNameEx(giveplayerid));
    		SendClientMessageToAllEx(COLOR_LIGHTRED, string);
			StaffAccountCheck(giveplayerid, GetPlayerIpEx(giveplayerid));
			PlayerInfo[giveplayerid][pWantedLevel] = 0;
			SetPlayerWantedLevel(giveplayerid, 0);
			PlayerInfo[giveplayerid][pJailTime] = time*60;
			SetPVarInt(giveplayerid, "_rAppeal", gettime()+60);			
			strcpy(PlayerInfo[giveplayerid][pPrisonReason], "[OOC][PRISON][/SMG]", 128);
			strcpy(PlayerInfo[giveplayerid][pPrisonedBy], GetPlayerNameEx(playerid), MAX_PLAYER_NAME);
			PhoneOnline[giveplayerid] = 1;
			SetPlayerInterior(giveplayerid, 1);
			SetPlayerHealth(giveplayerid, 0x7FB00000);
			PlayerInfo[giveplayerid][pInt] = 1;
			new rand = random(sizeof(OOCPrisonSpawns));
			Streamer_UpdateEx(giveplayerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2]);
			SetPlayerPos(giveplayerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2]);
			SetPlayerSkin(giveplayerid, 50);
			SetPlayerColor(giveplayerid, TEAM_APRISON_COLOR);
			Player_StreamPrep(giveplayerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2], FREEZE_TIME);

			if(time == 15) format(string, sizeof(string), "You have been prisoned for Metagaming - you will be prisoned for 15 minutes.");
			else format(string, sizeof(string), "You have been prisoned for Metagaming - you will be prisoned for 1 hour.");
			SendClientMessageEx(giveplayerid, COLOR_LIGHTRED, string);	
			
			if(PlayerInfo[giveplayerid][pAccountRestricted] == 1)
			{
				new ip[32];
				GetPlayerIp(giveplayerid,ip,sizeof(ip));
				format(string, sizeof(string), "AdmCmd: %s(%d) (IP: %s) was banned by an Admin (Punished while restricted), reason: MG", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), ip);
				Log("logs/ban.log", string);
				format(string, sizeof(string), "AdmCmd: %s was banned by an Admin (Punished while restricted), reason: MG", GetPlayerNameEx(giveplayerid));
				SendClientMessageToAllEx(COLOR_LIGHTRED, string);
				PlayerInfo[giveplayerid][pBanned] = 1;
				AddBan(playerid, giveplayerid, "Punished while account restricted");
				MySQLBan(GetPlayerSQLId(giveplayerid), ip, "Punished while account restricted - MG", 1, GetPlayerNameEx(playerid));
				SetTimerEx("KickEx", 1000, 0, "i", giveplayerid);
				return true;
			}
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /smg [playerid]");
			SendClientMessageEx(playerid, COLOR_GREY, "Note: Depending on the player level, this will issue up to a 1 hour prison.");
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use this command!");
	}
	return 1;
}

CMD:nonrp(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 3)
	{
		new giveplayerid, string[128], time;
		if(!sscanf(params, "u", giveplayerid))
		{
			if(PlayerInfo[playerid][pAdmin] <= PlayerInfo[giveplayerid][pAdmin])
			{
				SendClientMessageEx(playerid, COLOR_GRAD2, "You can't perform this action on an equal or higher level administrator.");
				return 1;
			}

			if(!IsPlayerConnected(giveplayerid))
			{
				SendClientMessageEx(playerid, COLOR_GRAD2, "That player is not connected.");
				return 1;
			}

			SetPlayerArmedWeapon(giveplayerid, 0);

			if(GetPVarInt(giveplayerid, "IsInArena") >= 0)
			{
				LeavePaintballArena(giveplayerid, GetPVarInt(giveplayerid, "IsInArena"));
			}

			new playerlevel = PlayerInfo[giveplayerid][pLevel];
			
			if(playerlevel <= 5) time = 30;
			else if(playerlevel > 5 && playerlevel < 10) time = 60;
			else time = 120;

			if(PlayerInfo[giveplayerid][pMember] >= 0 || PlayerInfo[giveplayerid][pLeader] >= 0)
			{
				format(string, sizeof(string), "Administrator %s has group-kicked (/nonrp) %s (%d) from %s (%d)", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), arrGroupData[PlayerInfo[giveplayerid][pMember]][g_szGroupName], PlayerInfo[giveplayerid][pMember]+1);
				GroupLog(PlayerInfo[giveplayerid][pMember], string);
				format(string, sizeof(string), "You have been faction-kicked as a result of your prison.");
				SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
				PlayerInfo[giveplayerid][pDuty] = 0;
				PlayerInfo[giveplayerid][pMember] = INVALID_GROUP_ID;
				PlayerInfo[giveplayerid][pRank] = INVALID_RANK;
				PlayerInfo[giveplayerid][pLeader] = INVALID_GROUP_ID;
				PlayerInfo[giveplayerid][pDivision] = INVALID_DIVISION;
				strcpy(PlayerInfo[giveplayerid][pBadge], "None", 9);
				player_remove_vip_toys(giveplayerid);
				pTazer{giveplayerid} = 0;
				time = 120;
			}

			if(PlayerInfo[giveplayerid][pFMember] != INVALID_FAMILY_ID )
			{
				PlayerInfo[giveplayerid][pGangWarn] += 1;
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have been issued a gang warning as a result of your prison.");
				if(PlayerInfo[giveplayerid][pGangWarn] >= 3)
				{
					format(string, sizeof(string), "AdmCmd: %s(%d) was banned from gangs (/nonrp) by %s (had 3 Gang Warnings), reason: Non-RP Behaviour", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), GetPlayerNameEx(playerid));
					Log("logs/admin.log", string);
					format(string, sizeof(string), "AdmCmd: %s was banned from gangs by %s (had 3 Gang Warnings), reason: Non-RP Behaviour", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid));
					ABroadCast(COLOR_LIGHTRED, string, 2);
					format(string, sizeof(string), "You have been banned from gangs by %s (had 3 Gang Warnings), reason: Non-RP Behaviour", GetPlayerNameEx(playerid));
					SendClientMessageEx(giveplayerid, COLOR_LIGHTRED, string);
					PlayerInfo[giveplayerid][pFMember] = INVALID_FAMILY_ID;
					PlayerInfo[giveplayerid][pRank] = 0;
					PlayerInfo[giveplayerid][pGangWarn] = 3; // just to make sure?
				}
				time = 120;
			}
						
			if(playerlevel >= 10 || PlayerInfo[giveplayerid][pMember] != INVALID_GROUP_ID || PlayerInfo[giveplayerid][pLeader] != INVALID_GROUP_ID || PlayerInfo[giveplayerid][pFMember] != INVALID_FAMILY_ID) 
				PlayerInfo[giveplayerid][pWarns] += 1;
			
			if(PlayerInfo[giveplayerid][pWarns] >= 3)
			{
				new ip[32];
				GetPlayerIp(giveplayerid,ip,sizeof(ip));
				format(string, sizeof(string), "AdmCmd: %s(%d) (IP: %s) was banned (/nonrp) by %s (had 3 Warnings), reason: Non-RP Behaviour", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), ip, GetPlayerNameEx(playerid));
				Log("logs/ban.log", string);
				format(string, sizeof(string), "AdmCmd: %s was banned by %s (had 3 Warnings), reason: Non-RP Behaviour", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid));
				SendClientMessageToAllEx(COLOR_LIGHTRED, string);
				StaffAccountCheck(giveplayerid, GetPlayerIpEx(giveplayerid));
				PlayerInfo[giveplayerid][pBanned] = 1;
				AddBan(playerid, giveplayerid, "Player had 3 warnings");
				MySQLBan(GetPlayerSQLId(giveplayerid), ip, "Third Warning (PG)", 1,GetPlayerNameEx(playerid));
				SetTimerEx("KickEx", 1000, 0, "i", giveplayerid);
				return 1;
			}

			if(GetPVarInt(giveplayerid, "Injured") == 1)
			{
				KillEMSQueue(giveplayerid);
				ClearAnimations(giveplayerid);
			}

			if(GetPVarInt(giveplayerid, "IsInArena") >= 0) LeavePaintballArena(giveplayerid, GetPVarInt(giveplayerid, "IsInArena"));
			GameTextForPlayer(giveplayerid, "~w~Welcome to ~n~~r~Fort DeMorgan", 5000, 3);
			ResetPlayerWeaponsEx(giveplayerid);
			format(string, sizeof(string), "AdmCmd: %s(%d) has been prisoned (/nonrp) by %s, reason: Non-RP Behaviour", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), GetPlayerNameEx(playerid));
			Log("logs/admin.log", string);
			format(string, sizeof(string), "AdmCmd: %s has been prisoned by %s, reason: Non-RP Behaviour", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid));
    		SendClientMessageToAllEx(COLOR_LIGHTRED, string);
			StaffAccountCheck(giveplayerid, GetPlayerIpEx(giveplayerid));
			PlayerInfo[giveplayerid][pWantedLevel] = 0;
			SetPlayerWantedLevel(giveplayerid, 0);
			PlayerInfo[giveplayerid][pJailTime] = time*60;
			SetPVarInt(giveplayerid, "_rAppeal", gettime()+60);			
			strcpy(PlayerInfo[giveplayerid][pPrisonReason], "[OOC][PRISON][/NONRP]", 128);
			strcpy(PlayerInfo[giveplayerid][pPrisonedBy], GetPlayerNameEx(playerid), MAX_PLAYER_NAME);
			PhoneOnline[giveplayerid] = 1;
			SetPlayerInterior(giveplayerid, 1);
			SetPlayerHealth(giveplayerid, 0x7FB00000);
			PlayerInfo[giveplayerid][pInt] = 1;
			new rand = random(sizeof(OOCPrisonSpawns));
			Streamer_UpdateEx(giveplayerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2]);
			SetPlayerPos(giveplayerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2]);
			SetPlayerSkin(giveplayerid, 50);
			SetPlayerColor(giveplayerid, TEAM_APRISON_COLOR);
			Player_StreamPrep(giveplayerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2], FREEZE_TIME);

			switch(time)
			{
				case 30: format(string, sizeof(string), "You have been prisoned for Non-RP Behaviour - you will be prisoned for 30 minutes.");
				case 60: format(string, sizeof(string), "You have been prisoned for Non-RP Behaviour - you will be prisoned for 1 hour.");
				case 120: format(string, sizeof(string), "You have been prisoned for Non-RP Behaviour - you will be prisoned for 2 hours.");
			}
			SendClientMessageEx(giveplayerid, COLOR_LIGHTRED, string);	
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /nonrp [playerid]");
			SendClientMessageEx(playerid, COLOR_GREY, "Note: Depending on the player level, this will issue up to 2 hours prison, a warning, and a groupkick/gangwarn.");
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use this command!");
	}
	return 1;
}

CMD:snonrp(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pUndercover] > 0)
	{
		new giveplayerid, string[128], time;
		if(!sscanf(params, "u", giveplayerid))
		{
			if(PlayerInfo[playerid][pAdmin] <= PlayerInfo[giveplayerid][pAdmin])
			{
				SendClientMessageEx(playerid, COLOR_GRAD2, "You can't perform this action on an equal or higher level administrator.");
				return 1;
			}

			if(!IsPlayerConnected(giveplayerid))
			{
				SendClientMessageEx(playerid, COLOR_GRAD2, "That player is not connected.");
				return 1;
			}

			SetPlayerArmedWeapon(giveplayerid, 0);

			if(GetPVarInt(giveplayerid, "IsInArena") >= 0)
			{
				LeavePaintballArena(giveplayerid, GetPVarInt(giveplayerid, "IsInArena"));
			}

			new playerlevel = PlayerInfo[giveplayerid][pLevel];
			
			if(playerlevel <= 5) time = 30;
			else if(playerlevel > 5 && playerlevel < 10) time = 60;
			else time = 120;

			if(PlayerInfo[giveplayerid][pMember] >= 0 || PlayerInfo[giveplayerid][pLeader] >= 0)
			{
				format(string, sizeof(string), "Administrator %s has group-kicked (/snonrp) %s (%d) from %s (%d)", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), arrGroupData[PlayerInfo[giveplayerid][pMember]][g_szGroupName], PlayerInfo[giveplayerid][pMember]+1);
				GroupLog(PlayerInfo[giveplayerid][pMember], string);
				format(string, sizeof(string), "You have been faction-kicked as a result of your prison.");
				SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
				PlayerInfo[giveplayerid][pDuty] = 0;
				PlayerInfo[giveplayerid][pMember] = INVALID_GROUP_ID;
				PlayerInfo[giveplayerid][pRank] = INVALID_RANK;
				PlayerInfo[giveplayerid][pLeader] = INVALID_GROUP_ID;
				PlayerInfo[giveplayerid][pDivision] = INVALID_DIVISION;
				strcpy(PlayerInfo[giveplayerid][pBadge], "None", 9);
				player_remove_vip_toys(giveplayerid);
				pTazer{giveplayerid} = 0;
				time = 120;
			}

			if(PlayerInfo[giveplayerid][pFMember] != INVALID_FAMILY_ID )
			{
				PlayerInfo[giveplayerid][pGangWarn] += 1;
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have been issued a gang warning as a result of your prison.");
				if(PlayerInfo[giveplayerid][pGangWarn] >= 3)
				{
					format(string, sizeof(string), "AdmCmd: %s(%d) was banned from gangs (/nonrp) by %s (had 3 Gang Warnings), reason: Non-RP Behaviour", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), GetPlayerNameEx(playerid));
					Log("logs/admin.log", string);
					format(string, sizeof(string), "AdmCmd: %s was banned from gangs by %s (had 3 Gang Warnings), reason: Non-RP Behaviour", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid));
					ABroadCast(COLOR_LIGHTRED, string, 2);
					format(string, sizeof(string), "You have been banned from gangs by an Admin (had 3 Gang Warnings), reason: Non-RP Behaviour");
					SendClientMessageEx(giveplayerid, COLOR_LIGHTRED, string);
					PlayerInfo[giveplayerid][pFMember] = INVALID_FAMILY_ID;
					PlayerInfo[giveplayerid][pRank] = 0;
					PlayerInfo[giveplayerid][pGangWarn] = 3; // just to make sure?
				}
				time = 120;
			}
						
			if(playerlevel >= 10 || PlayerInfo[giveplayerid][pMember] != INVALID_GROUP_ID || PlayerInfo[giveplayerid][pLeader] != INVALID_GROUP_ID || PlayerInfo[giveplayerid][pFMember] != INVALID_FAMILY_ID) 
				PlayerInfo[giveplayerid][pWarns] += 1;
			
			if(PlayerInfo[giveplayerid][pWarns] >= 3)
			{
				new ip[32];
				GetPlayerIp(giveplayerid,ip,sizeof(ip));
				format(string, sizeof(string), "AdmCmd: %s(%d) (IP: %s) was banned (/snonrp) by %s (had 3 Warnings), reason: Non-RP Behaviour", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), ip, GetPlayerNameEx(playerid));
				Log("logs/ban.log", string);
				format(string, sizeof(string), "AdmCmd: %s was banned by %s (had 3 Warnings), reason: Non-RP Behaviour", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid));
				ABroadCast(COLOR_LIGHTRED, string, 2);
				StaffAccountCheck(giveplayerid, GetPlayerIpEx(giveplayerid));
				PlayerInfo[giveplayerid][pBanned] = 1;
				AddBan(playerid, giveplayerid, "Player had 3 warnings");
				MySQLBan(GetPlayerSQLId(giveplayerid), ip, "Third Warning (PG)", 1,GetPlayerNameEx(playerid));
				SetTimerEx("KickEx", 1000, 0, "i", giveplayerid);
				return 1;
			}

			if(GetPVarInt(giveplayerid, "Injured") == 1)
			{
				KillEMSQueue(giveplayerid);
				ClearAnimations(giveplayerid);
			}

			if(GetPVarInt(giveplayerid, "IsInArena") >= 0) LeavePaintballArena(giveplayerid, GetPVarInt(giveplayerid, "IsInArena"));
			GameTextForPlayer(giveplayerid, "~w~Welcome to ~n~~r~Fort DeMorgan", 5000, 3);
			ResetPlayerWeaponsEx(giveplayerid);
			format(string, sizeof(string), "AdmCmd: %s(%d) has been prisoned (/snonrp) by %s, reason: Non-RP Behaviour", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), GetPlayerNameEx(playerid));
			Log("logs/admin.log", string);
			format(string, sizeof(string), "AdmCmd: %s has been prisoned by an Admin, reason: Non-RP Behaviour", GetPlayerNameEx(giveplayerid));
    		SendClientMessageToAllEx(COLOR_LIGHTRED, string);
			StaffAccountCheck(giveplayerid, GetPlayerIpEx(giveplayerid));
			PlayerInfo[giveplayerid][pWantedLevel] = 0;
			SetPlayerWantedLevel(giveplayerid, 0);
			PlayerInfo[giveplayerid][pJailTime] = time*60;
			SetPVarInt(giveplayerid, "_rAppeal", gettime()+60);			
			strcpy(PlayerInfo[giveplayerid][pPrisonReason], "[OOC][PRISON][/SNONRP]", 128);
			strcpy(PlayerInfo[giveplayerid][pPrisonedBy], GetPlayerNameEx(playerid), MAX_PLAYER_NAME);
			PhoneOnline[giveplayerid] = 1;
			SetPlayerInterior(giveplayerid, 1);
			SetPlayerHealth(giveplayerid, 0x7FB00000);
			PlayerInfo[giveplayerid][pInt] = 1;
			new rand = random(sizeof(OOCPrisonSpawns));
			Streamer_UpdateEx(giveplayerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2]);
			SetPlayerPos(giveplayerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2]);
			SetPlayerSkin(giveplayerid, 50);
			SetPlayerColor(giveplayerid, TEAM_APRISON_COLOR);
			Player_StreamPrep(giveplayerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2], FREEZE_TIME);

			if(time == 30) format(string, sizeof(string), "You have been prisoned for Non-RP Behaviour - you will be prisoned for 30 minutes.");
			else if(time == 60) format(string, sizeof(string), "You have been prisoned for Non-RP Behaviour - you will be prisoned for 1 hour.");
			else format(string, sizeof(string), "You have been prisoned for Non-RP Behaviour - you will be prisoned for 2 hours.");
			SendClientMessageEx(giveplayerid, COLOR_LIGHTRED, string);	
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /snonrp [playerid]");
			SendClientMessageEx(playerid, COLOR_GREY, "Note: Depending on the player level, this will issue up to 2 hours prison, a warning, and a groupkick/gangwarn.");
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use this command!");
	}
	return 1;
}

CMD:dm(playerid, params[])
{
    if( PlayerInfo[playerid][pAdmin] >= 3)
	{
	    new string[128], giveplayerid;
		if(sscanf(params, "u", giveplayerid)) {
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /dm [player]");
			SendClientMessageEx(playerid, COLOR_GREY, "NOTE: This command issues a 2 hours prison sentence, 1 warning, a 10 percent fine and a 4 hours weapon restriction.");
			return 1;
		}	
		if(IsPlayerConnected(giveplayerid))
		{
		    if(PlayerInfo[giveplayerid][pAdmin] > 1)
		    {
		        return SendClientMessageEx(playerid, COLOR_WHITE, "You cannot do this to other administrators!");
			}
			
			new fine = 0;
			new totalwealth = PlayerInfo[giveplayerid][pAccount] + GetPlayerCash(giveplayerid);
			if(PlayerInfo[giveplayerid][pPhousekey] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[giveplayerid][pPhousekey]][hOwnerID] == GetPlayerSQLId(giveplayerid)) totalwealth += HouseInfo[PlayerInfo[giveplayerid][pPhousekey]][hSafeMoney];
			if(PlayerInfo[giveplayerid][pPhousekey2] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[giveplayerid][pPhousekey2]][hOwnerID] == GetPlayerSQLId(giveplayerid)) totalwealth += HouseInfo[PlayerInfo[giveplayerid][pPhousekey2]][hSafeMoney];
			if(PlayerInfo[giveplayerid][pPhousekey3] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[giveplayerid][pPhousekey3]][hOwnerID] == GetPlayerSQLId(giveplayerid)) totalwealth += HouseInfo[PlayerInfo[giveplayerid][pPhousekey3]][hSafeMoney];
			
			if(totalwealth > 0)
			{
				fine = 10*totalwealth/100;
			}
			if(fine > 0) {
				GivePlayerCash(giveplayerid, -fine);
			}	

			//foreach(new i: Player)
			
			for(new i = 0; i < MAX_PLAYERS; ++i)
			{
				if(IsPlayerConnected(i))
				{
					if(GetPVarInt(i, "pWatchdogWatching") == giveplayerid) {
						SendClientMessage(i, COLOR_WHITE, "You have stopped DM Watching.");
						GettingSpectated[Spectate[i]] = INVALID_PLAYER_ID;
						Spectating[i] = 0;
						Spectate[i] = INVALID_PLAYER_ID;
						SetPVarInt(i, "SpecOff", 1 );
						TogglePlayerSpectating(i, false);
						SetCameraBehindPlayer(i);
						DeletePVar(i, "pWatchdogWatching");
					}
				}	
			}
						
			PlayerInfo[giveplayerid][pWarns] += 1;
			if(PlayerInfo[giveplayerid][pWarns] >= 3)
			{
				new ip[32];
				GetPlayerIp(giveplayerid,ip,sizeof(ip));
				format(string, sizeof(string), "AdmCmd: %s(%d) (IP: %s) was banned by %s (had 3 Warnings), reason: Deathmatching", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), ip, GetPlayerNameEx(playerid));
				Log("logs/ban.log", string);
				format(string, sizeof(string), "AdmCmd: %s was banned by %s (had 3 Warnings), reason: Deathmatching", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid));
				SendClientMessageToAllEx(COLOR_LIGHTRED, string);
				if(fine > 0) {
					format(string, sizeof(string), "You have been fined $%s (10 percent of your total wealth).", number_format(fine));
					SendClientMessageEx(giveplayerid, COLOR_LIGHTRED, string);
					format(string, sizeof(string), "AdmCmd: %s(%d) was fined $%s by %s (/dm).", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), number_format(fine), GetPlayerNameEx(playerid));
					Log("logs/admin.log", string);
				}
				StaffAccountCheck(giveplayerid, GetPlayerIpEx(giveplayerid));
				PlayerInfo[giveplayerid][pBanned] = 1;
				AddBan(playerid, giveplayerid, "Player had 3 warnings");
				MySQLBan(GetPlayerSQLId(giveplayerid), ip, "Third Warning (DM)", 1,GetPlayerNameEx(playerid));
				SetTimerEx("KickEx", 1000, 0, "i", giveplayerid);
				return 1;
			}
			if(GetPVarInt(giveplayerid, "Injured") == 1)
			{
				KillEMSQueue(giveplayerid);
				ClearAnimations(giveplayerid);
			}
			if(GetPVarInt(giveplayerid, "IsInArena") >= 0) LeavePaintballArena(giveplayerid, GetPVarInt(giveplayerid, "IsInArena"));
			GameTextForPlayer(giveplayerid, "~w~Welcome to ~n~~r~Fort DeMorgan", 5000, 3);
			ResetPlayerWeaponsEx(giveplayerid);
			format(string, sizeof(string), "AdmCmd: %s(%d) has been prisoned by %s, reason: Deathmatching ", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), GetPlayerNameEx(playerid));
			Log("logs/admin.log", string);
			format(string, sizeof(string), "AdmCmd: %s has been prisoned by %s, reason: Deathmatching", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid));
    		SendClientMessageToAllEx(COLOR_LIGHTRED, string);
			StaffAccountCheck(giveplayerid, GetPlayerIpEx(giveplayerid));
			PlayerInfo[giveplayerid][pWantedLevel] = 0;
			SetPlayerWantedLevel(giveplayerid, 0);
			PlayerInfo[giveplayerid][pJailTime] = 120*60;
			SetPVarInt(giveplayerid, "_rAppeal", gettime()+60);			
			strcpy(PlayerInfo[giveplayerid][pPrisonReason], "[OOC][PRISON][/DM]", 128);
			strcpy(PlayerInfo[giveplayerid][pPrisonedBy], GetPlayerNameEx(playerid), MAX_PLAYER_NAME);
			PhoneOnline[giveplayerid] = 1;
			SetPlayerInterior(giveplayerid, 1);
			SetPlayerHealth(giveplayerid, 0x7FB00000);
			PlayerInfo[giveplayerid][pInt] = 1;
			new rand = random(sizeof(OOCPrisonSpawns));
			Streamer_UpdateEx(giveplayerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2]);
			SetPlayerPos(giveplayerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2]);
			SetPlayerSkin(giveplayerid, 50);
			SetPlayerColor(giveplayerid, TEAM_APRISON_COLOR);
			Player_StreamPrep(giveplayerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2], FREEZE_TIME);

			PlayerInfo[giveplayerid][pWRestricted] = 4;
			SendClientMessageEx(giveplayerid, COLOR_LIGHTRED, "You have been prisoned for Death Matching - you will be prisoned for two hours, warned and your weapons restricted for 4 hours.");
			if(fine > 0) {
				format(string, sizeof(string), "You have been fined $%s (10 percent of your total wealth).", number_format(fine));
				SendClientMessageEx(giveplayerid, COLOR_LIGHTRED, string);
				format(string, sizeof(string), "AdmCmd: %s(%d) was fined $%s by %s (/dm).", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), number_format(fine), GetPlayerNameEx(playerid));
				Log("logs/admin.log", string);
			}	
			
			if(giveplayerid == GetPVarInt(playerid, "PendingAction2"))
			{
				if(AlertTime[GetPVarInt(playerid, "PendingAction3")] != 0)
				{
					if(GetPVarInt(playerid, "PendingAction") == 1) // DM
					{
						format(string, sizeof(string), "You have taken action on %s after processing a Deathmatching Alert, we've automatically issued 5 points to the player.", GetPlayerNameEx(giveplayerid));
						SendClientMessageEx(playerid, COLOR_CYAN, string);
						
						AddNonRPPoint(giveplayerid, 5, gettime()+2592000, "Deathmatching", playerid, 0);
						PlayerInfo[giveplayerid][pNonRPMeter] += 5;

						SendClientMessageEx(giveplayerid, COLOR_CYAN, "The server has automatically issued you 5 Non RP Points for Deathmatching.");
						
						format(string, sizeof(string), "%s(%d) has been issued 5 Non RP Points for Deathmatching.", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid));
						Log("logs/nonrppoints.log", string);
					}
				}
			}
			
			DeletePVar(playerid, "PendingAction");
			DeletePVar(playerid, "PendingAction2");
			if(AlertTime[GetPVarInt(playerid, "PendingAction3")] != 0) AlertTime[GetPVarInt(playerid, "PendingAction3")] = 0;
			DeletePVar(playerid, "PendingAction3");
		}
		else
		{
		    SendClientMessageEx(playerid, COLOR_GRAD2, "Invalid player specified.");
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use that command.");
	}
	return 1;
}

CMD:sdm(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pUndercover] >= 1)
	{
	    new string[128], giveplayerid;
		if(sscanf(params, "u", giveplayerid)) {
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /sdm [player]");
			SendClientMessageEx(playerid, COLOR_GREY, "NOTE: This command issues a 2 hours prison sentence, 1 warning, a 10 percent fine and a 4 hours weapon restriction.");
			return 1;
		}	
		if(IsPlayerConnected(giveplayerid))
	 	{
		    if(PlayerInfo[giveplayerid][pAdmin] > 1) return SendClientMessageEx(playerid, COLOR_WHITE, "You cannot do this to other administrators!");
			
			new fine = 0;
			new totalwealth = PlayerInfo[giveplayerid][pAccount] + GetPlayerCash(giveplayerid);
			if(PlayerInfo[giveplayerid][pPhousekey] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[giveplayerid][pPhousekey]][hOwnerID] == GetPlayerSQLId(giveplayerid)) totalwealth += HouseInfo[PlayerInfo[giveplayerid][pPhousekey]][hSafeMoney];
			if(PlayerInfo[giveplayerid][pPhousekey2] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[giveplayerid][pPhousekey2]][hOwnerID] == GetPlayerSQLId(giveplayerid)) totalwealth += HouseInfo[PlayerInfo[giveplayerid][pPhousekey2]][hSafeMoney];
			if(PlayerInfo[giveplayerid][pPhousekey3] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[giveplayerid][pPhousekey3]][hOwnerID] == GetPlayerSQLId(giveplayerid)) totalwealth += HouseInfo[PlayerInfo[giveplayerid][pPhousekey3]][hSafeMoney];
			
			if(totalwealth > 0)
			{
				fine = 10*totalwealth/100;
			}
			if(fine > 0) {
				GivePlayerCash(giveplayerid, -fine);
			}	

			PlayerInfo[giveplayerid][pWarns] += 1;
			if(PlayerInfo[giveplayerid][pWarns] >= 3)
			{
				new ip[32];
				GetPlayerIp(giveplayerid,ip,sizeof(ip));
				format(string, sizeof(string), "AdmCmd: %s(%d) (IP: %s) was banned by %s (had 3 Warnings), reason: DM", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), ip, GetPlayerNameEx(playerid));
				Log("logs/ban.log", string);
				format(string, sizeof(string), "AdmCmd: %s was banned by %s (had 3 Warnings), reason: DM", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid));
				ABroadCast(COLOR_LIGHTRED, string, 2);
				if(fine > 0) {
					format(string, sizeof(string), "You have been fined $%s (10 percent of your total wealth).", number_format(fine));
					SendClientMessageEx(giveplayerid, COLOR_LIGHTRED, string);
					format(string, sizeof(string), "AdmCmd: %s(%d) was fined $%s by %s (/dm).", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), number_format(fine), GetPlayerNameEx(playerid));
					Log("logs/admin.log", string);
				}	
				StaffAccountCheck(giveplayerid, GetPlayerIpEx(giveplayerid));
				PlayerInfo[giveplayerid][pBanned] = 1;
				AddBan(playerid, giveplayerid, "Player had 3 warnings");
				MySQLBan(GetPlayerSQLId(giveplayerid),ip, "Third Warning (DM)", 1,GetPlayerNameEx(playerid));
				SetTimerEx("KickEx", 1000, 0, "i", giveplayerid);
				return 1;
			}
			if(GetPVarInt(giveplayerid, "Injured") == 1)
			{
				KillEMSQueue(giveplayerid);
				ClearAnimations(giveplayerid);
			}
			if(GetPVarInt(giveplayerid, "IsInArena") >= 0) LeavePaintballArena(giveplayerid, GetPVarInt(giveplayerid, "IsInArena"));
			GameTextForPlayer(giveplayerid, "~w~Welcome to ~n~~r~Fort DeMorgan", 5000, 3);
			ResetPlayerWeaponsEx(giveplayerid);
			format(string, sizeof(string), "AdmCmd: %s(%d) has been silent prisoned (/sdm) by %s, reason: DM ", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), GetPlayerNameEx(playerid));
			Log("logs/admin.log", string);
			format(string, sizeof(string), "AdmCmd: %s has been silent prisoned (/sdm) by %s, reason: DM", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid));
   			ABroadCast(COLOR_LIGHTRED, string, 2);
			StaffAccountCheck(giveplayerid, GetPlayerIpEx(giveplayerid));
			PlayerInfo[giveplayerid][pWantedLevel] = 0;
			SetPlayerWantedLevel(giveplayerid, 0);
			PlayerInfo[giveplayerid][pJailTime] = 120*60;
			SetPVarInt(giveplayerid, "_rAppeal", gettime()+60);			
			strcpy(PlayerInfo[giveplayerid][pPrisonReason], "[OOC][PRISON][/SDM]", 128);
			strcpy(PlayerInfo[giveplayerid][pPrisonedBy], GetPlayerNameEx(playerid), MAX_PLAYER_NAME);
			PhoneOnline[giveplayerid] = 1;
			SetPlayerInterior(giveplayerid, 1);
			SetPlayerHealth(giveplayerid, 0x7FB00000);
			PlayerInfo[giveplayerid][pInt] = 1;
			new rand = random(sizeof(OOCPrisonSpawns));
			Streamer_UpdateEx(giveplayerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2]);
			SetPlayerPos(giveplayerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2]);
			SetPlayerSkin(giveplayerid, 50);
			SetPlayerColor(giveplayerid, TEAM_APRISON_COLOR);
			Player_StreamPrep(giveplayerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2], FREEZE_TIME);

			PlayerInfo[giveplayerid][pWRestricted] = 4;
			SendClientMessageEx(giveplayerid, COLOR_LIGHTRED, "You have been prisoned for Death Matching - you will be prisoned for two hours, warned and your weapons restricted for 4 hours.");
			if(fine > 0) {
				format(string, sizeof(string), "You have been fined $%s (10 percent of your total wealth).", number_format(fine));
				SendClientMessageEx(giveplayerid, COLOR_LIGHTRED, string);
				format(string, sizeof(string), "AdmCmd: %s(%d) was fined $%s by %s (/dm).", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), number_format(fine), GetPlayerNameEx(playerid));
				Log("logs/admin.log", string);
			}	
			
			if(giveplayerid == GetPVarInt(playerid, "PendingAction2"))
			{
				if(AlertTime[GetPVarInt(playerid, "PendingAction3")] != 0)
				{
					if(GetPVarInt(playerid, "PendingAction") == 1) // DM
					{
						format(string, sizeof(string), "You have taken action on %s after processing a Deathmatching Alert, we've automatically issued 5 points to the player.", GetPlayerNameEx(giveplayerid));
						SendClientMessageEx(playerid, COLOR_CYAN, string);
						
						AddNonRPPoint(giveplayerid, 5, gettime()+2592000, "Deathmatching", playerid, 0);
						PlayerInfo[giveplayerid][pNonRPMeter] += 5;

						SendClientMessageEx(giveplayerid, COLOR_CYAN, "The server has automatically issued you 5 Non RP Points for Deathmatching.");
						
						format(string, sizeof(string), "%s(%d) has been issued 5 Non RP Points for Deathmatching.", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid));
						Log("logs/nonrppoints.log", string);
					}
				}
			}
			
			DeletePVar(playerid, "PendingAction");
			DeletePVar(playerid, "PendingAction2");
			if(AlertTime[GetPVarInt(playerid, "PendingAction3")] != 0) AlertTime[GetPVarInt(playerid, "PendingAction3")] = 0;
			DeletePVar(playerid, "PendingAction3");
		}
		else
		{
		    SendClientMessageEx(playerid, COLOR_GRAD2, "Invalid player specified.");
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use that command.");
	}	return 1;
}
