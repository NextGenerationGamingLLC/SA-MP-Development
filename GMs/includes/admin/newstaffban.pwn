/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

					Staff Ban System
					   Winterfield,
					   Westen

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

/* self notes & comments:

	- A player may be staff banned by a head admin or above, or a member of HR (pAdmin 1337 | pHR > 1).
	- Shane requested that we remove the pStaffBanned and instead use a separate table for quicker loading etc.
	- Staff banning and the removal of must also be able to be done offline.

	- For checking if a player is staff banned, there're one of two posibilities - retrieve from the table, or use an integer. Probably faster to use integer.

	- TODO:
		- /staffban
		- /unstaffban

		- /ostaffban
		- /ounstaffban

		- /staffbans

		- Alter /makeadmin or any commands like that so they cannot be made an admin if they are staff banned, a la blacklist system for HMA.
*/

stock IsStaffBanned(playerid)
{
	if(PlayerInfo[playerid][pStaffBanned]) return 1; 
	return 0;
}

CMD:staffban(playerid, params[])
{

	if(PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pHR] > 0)
	{
		new iTarget, szReason[128], iDays;
		if(sscanf(params, "ds[128]d", iTarget, szReason, iDays))
		{
			SendClientMessage(playerid, COLOR_GREY, "USAGE: /staffban [playerid] [reason] [duration (days)]");
			SendClientMessage(playerid, COLOR_GREY, "Players will automatically be unbanned after the duration has expired. To make a ban indefinite, set days as 0.");
			return 1;
		}

		if(!IsPlayerConnected(iTarget)) return SendClientMessage(playerid, COLOR_GRAD2, "That player is not connected.");

		if(PlayerInfo[iTarget][pAdmin] >= PlayerInfo[playerid][pAdmin] && PlayerInfo[playerid][pAdmin] != 99999) return SendClientMessage(playerid, COLOR_GRAD2, "You cannot perform this action on an equal or higher level administrator.");

		if(PlayerInfo[iTarget][pStaffBanned]) return SendClientMessage(playerid, COLOR_GRAD2, "That player is already staff banned.");

		// 7810 is the date just before 19 January 2038. Given that bans are specified in unix, anything above this goes above the max integer value. Crashes = :(
		if(iDays < 0 || iDays > 7810) return SendClientMessage(playerid, COLOR_GRAD2, "You have specified an invalid amount of days. Days must be between 0 and 7,810.");

		new iCreationDate, iExpireDate;
		iCreationDate = gettime();
		iExpireDate = gettime() + (iDays * 86400);

		if(iDays == 0) iExpireDate = 2147483640;

		mysql_format(MainPipeline, szMiscArray, sizeof szMiscArray, "INSERT INTO `staffbans` (`details`, `issuer`, `playerid`, `expiredate`, `created`) VALUES('%e', %d, %d, %d, %d)",
			szReason,  GetPlayerSQLId(playerid), GetPlayerSQLId(iTarget), iExpireDate, iCreationDate);

		// We have to make sure the query goes through before they can be staff banned.
		mysql_tquery(MainPipeline, szMiscArray, "OnlineStaffBan", "ddsdd", playerid, iTarget, szReason, iCreationDate, iDays);
	}
	else SendClientMessage(playerid, COLOR_GRAD2, "You're not authorised to use this command.");

	return 1;
}

CMD:unstaffban(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pHR] > 0)
	{
		new iTarget, szReason[128];
		if(sscanf(params, "ds[128]", iTarget, szReason)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /unstaffban [playerid] [reason]");

		if(!IsPlayerConnected(iTarget)) return SendClientMessage(playerid, COLOR_GRAD2, "That player is not connected.");

		if(!PlayerInfo[iTarget][pStaffBanned]) return SendClientMessage(playerid, COLOR_GRAD2, "That player is not staff banned.");

		mysql_format(MainPipeline, szMiscArray, sizeof szMiscArray, "UPDATE `staffbans` SET `status`=2 WHERE `playerid`=%d AND `status`=1", GetPlayerSQLId(iTarget));
		mysql_tquery(MainPipeline, szMiscArray, "RemoveStaffBan", "dds", playerid, iTarget, szReason);
	}
	else SendClientMessage(playerid, COLOR_GRAD2, "You're not authorised to use this command.");
	return 1;
}

CMD:ostaffban(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pHR] > 0)
	{
		new szTarget[MAX_PLAYER_NAME], szReason[128], iDays;
		if(sscanf(params, "s[24]s[128]d", szTarget, szReason, iDays)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /ostaffban [account name] [reason] [duration (in days)]");

		if(IsPlayerConnected(ReturnUser(szTarget))) return SendClientMessageEx(playerid, COLOR_GREY, "That player is currently connected, use /staffban.");

		if(iDays < 0 || iDays > 7810) return SendClientMessage(playerid, COLOR_GRAD2, "You have specified an invalid amount of days. Days must be between 0 and 7,810.");

		mysql_format(MainPipeline, szMiscArray,sizeof(szMiscArray),"UPDATE `accounts` SET `AdminLevel` = 0, `HR` = 0, `AP` = 0, `Security` = 0, `ShopTech` = 0, `FactionModerator` = 0, `GangModerator` = 0, \
			`Undercover` = 0, `BanAppealer` = 0, `Helper` = 0, `pVIPMod` = 0, `SecureIP` = '0.0.0.0', `SeniorModerator` = 0, `BanAppealer` = 0, `ShopTech` = 0, `StaffBanned` = 1 WHERE `Username`= '%s' AND `AdminLevel` < %d AND `StaffBanned` = 0", szTarget, PlayerInfo[playerid][pAdmin]);

		mysql_tquery(MainPipeline, szMiscArray, "OfflineStaffBan", "dssd", playerid, szTarget, szReason, iDays);

		for(new i = 0; i < MAX_PLAYER_NAME; i++) if(szTarget[i] == '_') szTarget[i] = ' '; // Remove the underscore, looks nicer for the person using the command.

		format(szMiscArray, sizeof szMiscArray, "Attempting to staff ban %s.", szTarget);
		SendClientMessage(playerid, COLOR_WHITE, szMiscArray);
	}
	else SendClientMessage(playerid, COLOR_GRAD2, "You're not authorised to use this command.");
	return 1;
}

CMD:ounstaffban(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pHR] > 0)
	{
		new szTarget[MAX_PLAYER_NAME];
		if(sscanf(params, "s[24]", szTarget)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /ounstaffban [account name]");

		if(IsPlayerConnected(ReturnUser(szTarget))) return SendClientMessageEx(playerid, COLOR_GREY, "That player is currently connected, use /unstaffban.");

		mysql_format(MainPipeline, szMiscArray,sizeof(szMiscArray),"UPDATE `accounts` SET `StaffBanned`=0 WHERE `Username`= '%s' AND `StaffBanned` = 1", szTarget, PlayerInfo[playerid][pAdmin]);

		mysql_tquery(MainPipeline, szMiscArray, "OfflineRemoveStaffBan", "ds", playerid, szTarget);

		for(new i = 0; i < MAX_PLAYER_NAME; i++) if(szTarget[i] == '_') szTarget[i] = ' '; // Remove the underscore, looks nicer for the person using the command.

		format(szMiscArray, sizeof szMiscArray, "Attempting to remove %s's staff ban.", szTarget);
		SendClientMessage(playerid, COLOR_WHITE, szMiscArray);
	}
	else SendClientMessage(playerid, COLOR_GRAD2, "You're not authorised to use this command.");
	return 1;
}

CMD:staffbans(playerid, params[])
{
	
	if(PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pHR] > 0)
	{
		SendClientMessage(playerid, COLOR_GREEN,"_______________________________________");
		SendClientMessage(playerid, COLOR_GRAD3, "List of online staff bans: ");
		foreach(new i: Player)
		{
			if(PlayerInfo[i][pStaffBanned] == 1) 
			{
				mysql_format(MainPipeline, szMiscArray, sizeof szMiscArray, "SELECT * FROM `staffbans` WHERE `playerid`=%d", GetPlayerSQLId(i));
				mysql_tquery(MainPipeline, szMiscArray, "DisplayStaffBan", "dd", playerid, i);
			}
		}

		SendClientMessage(playerid, COLOR_GREEN,"_______________________________________");
	}
	else SendClientMessage(playerid, COLOR_GRAD2, "You're not authorised to use this command.");
	return 1;
}

forward DisplayStaffBan(iPlayer, iBanned);
public DisplayStaffBan(iPlayer, iBanned)
{
	new szReason[128], iIssuedBy, iCreated, iExpire;
	new rows;
	cache_get_row_count(rows);

	if(rows > 0)
	{
		for(new row = 0; row < rows; row++)
		{
			cache_get_value_name(row, "details", szReason, 128);
			cache_get_value_name_int(row, "issuer", iIssuedBy);
			cache_get_value_name_int(row, "created", iCreated);
			cache_get_value_name_int(row, "expiredate", iExpire);
		}

		mysql_format(MainPipeline, szMiscArray, sizeof szMiscArray, "SELECT `Username` FROM `accounts` WHERE `id`=%d", iIssuedBy);
		mysql_tquery(MainPipeline, szMiscArray, "FetchIssuer", "ddsddd", iPlayer, iBanned, szReason, iIssuedBy, iCreated, iExpire);
	}
	return 1;
}

forward FetchIssuer(iPlayer, iBanned, szReason[], iIssuedBy, iCreated, iExpire);
public FetchIssuer(iPlayer, iBanned, szReason[], iIssuedBy, iCreated, iExpire)
{
	new rows;
	cache_get_row_count(rows);
	if(rows > 0)
	{
		new szUsername[MAX_PLAYER_NAME];

		for(new row = 0; row < rows; row++)
		{
			cache_get_value_name(row, "Username", szUsername, MAX_PLAYER_NAME);
		}

		format(szMiscArray, sizeof szMiscArray, "%s (ID: %d) banned by %s, reason: %s - expire date: %s", GetPlayerNameEx(iBanned), iBanned, szUsername, szReason, date(iExpire, 1));
		SendClientMessage(iPlayer, COLOR_GRAD1, szMiscArray);
	}
	return 1;
}

forward OfflineRemoveStaffBan(iIssuer, szTarget[]);
public OfflineRemoveStaffBan(iIssuer, szTarget[])
{
	if(!cache_affected_rows()) return SendClientMessage(iIssuer, COLOR_GRAD2, "There was an error removing the staff ban from that account.");

	mysql_format(MainPipeline, szMiscArray, sizeof szMiscArray, "SELECT `Username`, `id` FROM `accounts` WHERE `Username`='%s'", szTarget);
	mysql_tquery(MainPipeline, szMiscArray, "RetrieveTargetIDUnban", "ds", iIssuer, szTarget);
	return 1;
}

forward RetrieveTargetIDUnban(iIssuer, szTarget[]);
public RetrieveTargetIDUnban(iIssuer, szTarget[])
{
	new szUsername[MAX_PLAYER_NAME], iSQLID;

	new rows;
	cache_get_row_count(rows);
	if(rows > 0)
	{
		for(new row = 0; row < rows; row++)
		{
			cache_get_value_name(row, "Username", szUsername, MAX_PLAYER_NAME);
			cache_get_value_name_int(row, "id", iSQLID);
		}

		mysql_format(MainPipeline, szMiscArray, sizeof szMiscArray, "UPDATE `staffbans` SET `status`=2 WHERE `playerid`=%d AND `status`=1", iSQLID);
		mysql_tquery(MainPipeline, szMiscArray, "ProcessOfflineUnStaffBan", "dsd", iIssuer, szTarget, iSQLID);
	}
	else // Because we don't have their SQL ID we shouldn't log it, because we can't track who the staff ban belongs to.
	{
		format(szMiscArray, sizeof szMiscArray, "%s's staff ban was removed but the row in `staffbans` could not be removed.", szTarget);
		Log("logs/staffban.log", szMiscArray);
	}
	return 1;
}

forward ProcessOfflineUnStaffBan(iIssuer, szTarget[], iSQLID);
public ProcessOfflineUnStaffBan(iIssuer, szTarget[], iSQLID)
{
	if(!cache_affected_rows())
	{
		format(szMiscArray, sizeof szMiscArray, "%s was un-staff banned but the row could not be deleted from `staffbans`.", szTarget);
		Log("logs/staffban.log", szMiscArray);
		return 1;
	}

	// Inform the issuer.
	format(szMiscArray, sizeof szMiscArray, "You have successfully removed %s's staff ban.", szTarget);
	SendClientMessage(iIssuer, COLOR_GRAD1, szMiscArray);

	// Inform the admins.
	format(szMiscArray, sizeof szMiscArray, "{AA3333}AdmWarning{FFFF00}: %s has had their staff ban removed by %s (offline).", szTarget, GetPlayerNameEx(iIssuer));
	ABroadCast(COLOR_YELLOW, szMiscArray, 4);

	// Log it.
	format(szMiscArray, sizeof szMiscArray, "%s (%d) had their staff ban removed (offline) by %s (%d)", szTarget, iSQLID, GetPlayerNameEx(iIssuer), GetPlayerSQLId(iIssuer));
	Log("logs/staffban.log", szMiscArray);

	return 1;
}

forward OfflineStaffBan(iIssuer, szTarget[], szReason[], iDays);
public OfflineStaffBan(iIssuer, szTarget[], szReason[], iDays)
{
	if(!cache_affected_rows()) return SendClientMessage(iIssuer, COLOR_GRAD2, "There was an error offline staff banning that account.");

	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "SELECT `Username`, `id` FROM `accounts` WHERE `Username`='%s'", szTarget);
	mysql_tquery(MainPipeline, szMiscArray, "RetrieveTargetID", "dssd", iIssuer, szTarget, szReason, iDays);
	return 1;
}

forward RetrieveTargetID(iIssuer, szTarget[], szReason[], iDays);
public RetrieveTargetID(iIssuer, szTarget[], szReason[], iDays)
{
	new szUsername[MAX_PLAYER_NAME], iSQLID;

	new rows;
	cache_get_row_count(rows);
	if(rows > 0)
	{
		for(new row = 0; row < rows; row++)
		{
			cache_get_value_name(row, "Username", szUsername, MAX_PLAYER_NAME);
			cache_get_value_name_int(row, "id", iSQLID);
		}

		// Now we have their SQL ID we can insert into the table.
		new iCreationDate = gettime();
		new iExpireDate = gettime() + (iDays * 86400);

		if(iDays == 0) iExpireDate = 2147483640;

		mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "INSERT INTO `staffbans` (`details`, `issuer`, `playerid`, `expiredate`, `created`) VALUES('%e', %d, %d, %d, %d)",
			szReason,  GetPlayerSQLId(iIssuer), iSQLID, iExpireDate, iCreationDate);

		mysql_tquery(MainPipeline, szMiscArray, "ProcessOfflineStaffBan", "dssdd", iIssuer, szTarget, szReason, iDays, iSQLID);
	}
	else // Because we don't have their SQL ID we shouldn't log it, because we can't track who the staff ban belongs to.
	{
		format(szMiscArray, sizeof szMiscArray, "%s was staff banned but a row could not be added to `staffbans`.", szTarget);
		Log("logs/staffban.log", szMiscArray);
	}
	return 1;
}

forward ProcessOfflineStaffBan(iIssuer, szTarget[], szReason[], iDays, iSQLID);
public ProcessOfflineStaffBan(iIssuer, szTarget[], szReason[], iDays, iSQLID)
{
	if(!cache_affected_rows())
	{
		format(szMiscArray, sizeof szMiscArray, "%s was staff banned but a row could not be added to `staffbans`.", szTarget);
		Log("logs/staffban.log", szMiscArray);
		return 1;
	}

	if(iDays != 0)
	{
		// Inform the issuer.
		format(szMiscArray, sizeof szMiscArray, "You have successfully staff banned %s, reason: %s.", szTarget, szReason);
		SendClientMessage(iIssuer, COLOR_GRAD1, szMiscArray);

		// If the server is lagging then this may be off by about a second. Given the display isn't what is stored, it is not exactly important.
		format(szMiscArray, sizeof szMiscArray, "Unban Date: %s", date(gettime() + (iDays * 86400), 1));
		SendClientMessage(iIssuer, COLOR_GRAD1, szMiscArray);	

		// Inform the admins.
		format(szMiscArray, sizeof szMiscArray, "{AA3333}AdmWarning{FFFF00}: %s has been offline staff banned by %s, reason: %s.", szTarget, GetPlayerNameEx(iIssuer), szReason);
		ABroadCast(COLOR_YELLOW, szMiscArray, 4);

		// Log it.
		format(szMiscArray, sizeof szMiscArray, "%s (%d) was offline staff banned by %s (%d), reason: %s | Duration: %d days | Unban Date: %s", szTarget, iSQLID, GetPlayerNameEx(iIssuer), GetPlayerSQLId(iIssuer),
			szReason, iDays, date(gettime() + (iDays * 86400), 1));
		Log("logs/staffban.log", szMiscArray);
	}
	else
	{
		// Inform the issuer.
		format(szMiscArray, sizeof szMiscArray, "You have successfully staff banned %s indefinitely, reason: %s. ", szTarget, szReason);
		SendClientMessage(iIssuer, COLOR_GRAD1, szMiscArray);

		// Inform the admins.
		format(szMiscArray, sizeof szMiscArray, "{AA3333}AdmWarning{FFFF00}: %s has been staff banned by %s, reason: %s.", szTarget, GetPlayerNameEx(iIssuer), szReason);
		ABroadCast(COLOR_YELLOW, szMiscArray, 4);

		// Log it.
		format(szMiscArray, sizeof szMiscArray, "%s (%d) was staff banned by %s (%d), reason: %s | Duration: indefinite", szTarget, iSQLID, GetPlayerNameEx(iIssuer), GetPlayerSQLId(iIssuer), szReason);
		Log("logs/staffban.log", szMiscArray);
	}

	return 1;
}

forward RemoveStaffBan(iIssuer, iTarget, szReason[]);
public RemoveStaffBan(iIssuer, iTarget, szReason[])
{
	if(!cache_affected_rows()) return SendClientMessage(iIssuer, COLOR_GRAD2, "There was an error removing the staff ban from that account.");

	PlayerInfo[iTarget][pStaffBanned] = 0;

	// Inform the issuer.
	format(szMiscArray, sizeof szMiscArray, "You have successfully removed %s's staff ban, reason: %s.", GetPlayerNameEx(iTarget), szReason);
	SendClientMessage(iIssuer, COLOR_GRAD1, szMiscArray);

	// Inform the player.
	format(szMiscArray, sizeof szMiscArray, "Your staff ban was removed by %s, reason: %s.", GetPlayerNameEx(iIssuer), szReason);
	SendClientMessage(iTarget, COLOR_LIGHTRED, szMiscArray);

	// Inform the admins.
	format(szMiscArray, sizeof szMiscArray, "{AA3333}AdmWarning{FFFF00}: %s (ID %d) has had their staff ban removed by %s, reason: %s.", GetPlayerNameEx(iTarget), iTarget, GetPlayerNameEx(iIssuer), szReason);
	ABroadCast(COLOR_YELLOW, szMiscArray, 4);

	// Log it.
	format(szMiscArray, sizeof szMiscArray, "%s's (%d) staff ban was removed by %s (%d), reason: %s", GetPlayerNameEx(iTarget), GetPlayerSQLId(iTarget), GetPlayerNameEx(iIssuer), GetPlayerSQLId(iIssuer), szReason);
	Log("logs/staffban.log", szMiscArray);

	g_mysql_SaveAccount(iTarget);
	return 1;
}

forward OnlineStaffBan(iIssuer, iTarget, szReason[], iCreationDate, iDays);
public OnlineStaffBan(iIssuer, iTarget, szReason[], iCreationDate, iDays)
{
	if(!cache_affected_rows()) return SendClientMessage(iIssuer, COLOR_GRAD2, "There was an error staff banning that account.");
	
	// Main staff variables.
	PlayerInfo[iTarget][pAdmin] = 0;
	PlayerInfo[iTarget][pSMod] = 0;
	PlayerInfo[iTarget][pVIPMod] = 0;
	PlayerInfo[iTarget][pHelper] = 0;

	// Secondary tasks.
	PlayerInfo[iTarget][pFactionModerator] = 0;
	PlayerInfo[iTarget][pGangModerator] = 0;
	PlayerInfo[iTarget][pUndercover] = 0;
	PlayerInfo[iTarget][pBanAppealer] = 0;
	PlayerInfo[iTarget][pShopTech] = 0;
	PlayerInfo[iTarget][pPR] = 0;
	PlayerInfo[iTarget][pHR] = 0;
	PlayerInfo[iTarget][pSecurity] = 0;
	PlayerInfo[iTarget][pBM] = 0;
	PlayerInfo[iTarget][pASM] = 0;
	
	PlayerInfo[iTarget][pStaffBanned] = 1;

	if(iDays != 0)
	{
		// Inform the issuer.
		format(szMiscArray, sizeof szMiscArray, "You have successfully staff banned %s, reason: %s.", GetPlayerNameEx(iTarget), szReason);
		SendClientMessage(iIssuer, COLOR_GRAD1, szMiscArray);

		format(szMiscArray, sizeof szMiscArray, "Unban Date: %s", date(iCreationDate + (iDays * 86400), 1));
		SendClientMessage(iIssuer, COLOR_GRAD1, szMiscArray);	

		// Inform the player.
		format(szMiscArray, sizeof szMiscArray, "You have been staff banned by %s, reason: %s.", GetPlayerNameEx(iIssuer), szReason);
		SendClientMessage(iTarget, COLOR_LIGHTRED, szMiscArray);

		format(szMiscArray, sizeof szMiscArray, "Your unban date is %s.", date(iCreationDate + (iDays * 86400), 1));
		SendClientMessage(iTarget, COLOR_LIGHTRED, szMiscArray);

		// Inform the admins.
		format(szMiscArray, sizeof szMiscArray, "{AA3333}AdmWarning{FFFF00}: %s (ID %d) has been staff banned by %s, reason: %s.", GetPlayerNameEx(iTarget), iTarget, GetPlayerNameEx(iIssuer), szReason);
		ABroadCast(COLOR_YELLOW, szMiscArray, 4);

		// Log it.
		format(szMiscArray, sizeof szMiscArray, "%s (%d) was staff banned by %s (%d), reason: %s | Duration: %d days | Unban Date: %s", GetPlayerNameEx(iTarget), GetPlayerSQLId(iTarget), GetPlayerNameEx(iIssuer), GetPlayerSQLId(iIssuer),
			szReason, iDays, date(iCreationDate + (iDays * 86400), 1));
		Log("logs/staffban.log", szMiscArray);
	}
	else
	{
		// Inform the issuer.
		format(szMiscArray, sizeof szMiscArray, "You have successfully staff banned %s indefinitely, reason: %s. ", GetPlayerNameEx(iTarget), szReason);
		SendClientMessage(iIssuer, COLOR_GRAD1, szMiscArray);

		// Inform the player.
		format(szMiscArray, sizeof szMiscArray, "You have been staff banned indefinitely by %s, reason: %s.", GetPlayerNameEx(iIssuer), szReason);
		SendClientMessage(iTarget, COLOR_LIGHTRED, szMiscArray);

		// Inform the admins.
		format(szMiscArray, sizeof szMiscArray, "{AA3333}AdmWarning{FFFF00}: %s (ID %d) has been staff banned by %s, reason: %s.", GetPlayerNameEx(iTarget), iTarget, GetPlayerNameEx(iIssuer), szReason);
		ABroadCast(COLOR_YELLOW, szMiscArray, 4);

		// Log it.
		format(szMiscArray, sizeof szMiscArray, "%s (%d) was staff banned by %s (%d), reason: %s | Duration: indefinite", GetPlayerNameEx(iTarget), GetPlayerSQLId(iTarget), GetPlayerNameEx(iIssuer), GetPlayerSQLId(iIssuer), szReason);
		Log("logs/staffban.log", szMiscArray);
	}

	g_mysql_SaveAccount(iTarget);
	return 1;
}

