CreateBan(iBanCreator, iBanned, iPlayerID, szIPAddress[], szReason[], iLength) {

	// SPECIFY INVALID ID for iBanCreator for System Bans
	// SPECIFY INVALID ID for iBanned when banning IP Addresses

	// iBanCreator - IG Player ID of the Ban Creator
	// iBanned = SQL ID of the player to be banned
	// iPlayerID = IG player ID of the person to be banned
	// szIPAddress = IP Address to be banned

	szMiscArray[0] = 0;

	if(iLength > 5000) iLength = 5000;

	format(szMiscArray, sizeof(szMiscArray), "INSERT INTO `ban` (`bannedid`, `creatorid`, `IP`, `reason`, `createdate`, `liftdate`, `active`) \
		VALUES ('%d', '%d', '%s', '%s', UNIX_TIMESTAMP(), UNIX_TIMESTAMP(DATE_ADD(CURDATE(),INTERVAL %d DAY)), 1)",
		iBanned, iBanCreator == INVALID_PLAYER_ID ? INVALID_PLAYER_ID:PlayerInfo[iBanCreator][pId], szIPAddress, szReason, iLength);

	mysql_function_query(MainPipeline, szMiscArray, false, "OnCreateBan", "iisisi", iBanCreator, iPlayerID, szIPAddress, iBanned, szReason, iLength);

	return 1;
}

forward OnCreateBan(iBanCreator, iPlayerID, szIPAddress[], iBanned, szReason[], iLength);
public OnCreateBan(iBanCreator, iPlayerID, szIPAddress[], iBanned, szReason[], iLength) {

	if(!mysql_errno(MainPipeline)) {


		if (iPlayerID == INVALID_PLAYER_ID) {
			szMiscArray[0] = 0;
			GetPVarString(iBanCreator, "BanningName", szMiscArray, MAX_PLAYER_NAME);
			DeletePVar(iBanCreator, "BanningName");
			format(szMiscArray, sizeof(szMiscArray), "AdmCmd: %s was offline banned by %s", szMiscArray, GetPlayerNameEx(iBanCreator));
			return ABroadCast(COLOR_LIGHTRED, szMiscArray, 2);
		}

		else if(iPlayerID != INVALID_PLAYER_ID && IsPlayerConnected(iPlayerID)) {

			if(iBanCreator == INVALID_PLAYER_ID) {
				format(szMiscArray, sizeof(szMiscArray), "AdmCmd: %s was auto-banned (%s)", GetPlayerNameEx(iPlayerID), szReason);
			}
			else if(iBanCreator != INVALID_PLAYER_ID) {
				format(szMiscArray, sizeof(szMiscArray), "AdmCmd: %s was banned by %s (%s)", GetPlayerNameEx(iPlayerID), GetPlayerNameEx(iBanCreator), szReason);
			}
			ABroadCast(COLOR_LIGHTRED, szMiscArray, 2);
			SendClientMessageEx(iPlayerID, COLOR_LIGHTRED, szMiscArray);
			return SetTimerEx("KickEx", 1000, false, "i", iPlayerID);
		}

		else {

			format(szMiscArray, sizeof(szMiscArray), "AdmCmd: %s has banned IP %s (%s)", GetPlayerNameEx(iBanCreator), szIPAddress, szReason);
			return ABroadCast(COLOR_LIGHTRED, szMiscArray, 2);

		}

	}
	else SendClientMessageEx(iBanCreator, COLOR_YELLOW, "There was an issue creating that ban ...");

	return 1;
}

RemoveBan(iRemover, iBanned, szIPAddress[]) {

	if(iBanned != INVALID_PLAYER_ID) {
		format(szMiscArray, sizeof(szMiscArray), "UPDATE `ban` SET `active` = 0 WHERE `bannedid` = '%d' OR `IP` = '%s'", iBanned, szIPAddress);
	}
	else {
		mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "UPDATE `ban` SET `active` = 0 WHERE `IP` = '%e'", szIPAddress);
	}

	mysql_function_query(MainPipeline, szMiscArray, true, "OnRemoveBan", "iis", iRemover, iBanned, szIPAddress);

	return 1;

}

forward OnRemoveBan(iRemover, iBanned, szIPAddress[]);
public OnRemoveBan(iRemover, iBanned, szIPAddress[]) {

	if(iRemover == INVALID_PLAYER_ID) return 1;
	if(!mysql_errno(MainPipeline)) {

		new iRows = cache_affected_rows(MainPipeline);

		if(!iRows) return SendClientMessageEx(iRemover, COLOR_YELLOW, "No bans matching that criteria were found");
		else {

			if(!isnull(szIPAddress)) {
				format(szMiscArray, sizeof(szMiscArray), "%s unbanned IP %s", GetPlayerNameEx(iRemover), szIPAddress);
				ABroadCast(COLOR_YELLOW, szMiscArray, 2);
				Log("logs/unbans.log", szMiscArray);
			}

			if(iBanned != INVALID_PLAYER_ID) {
				szMiscArray[0] = 0;
				GetPVarString(iRemover, "UnbanName", szMiscArray, MAX_PLAYER_NAME);
				DeletePVar(iRemover, "UnbanName");
				format(szMiscArray, sizeof(szMiscArray), "%s unbanned %s.", GetPlayerNameEx(iRemover), szMiscArray);
				ABroadCast(COLOR_YELLOW, szMiscArray, 2);
				Log("logs/unbans.log", szMiscArray);
			}

			format(szMiscArray, sizeof(szMiscArray), "%d ban records removed.", iRows);
			SendClientMessageEx(iRemover, COLOR_WHITE, szMiscArray);
		}
	}
	else SendClientMessageEx(iRemover, COLOR_YELLOW, "There was an issue removing that ban ...");

	return 1;
}

forward InitiateUnban(iRemover);
public InitiateUnban(iRemover) {

	new
		szIPAddress[16],
		id,
		iRows,
		iFields;

	cache_get_data(iRows, iFields, MainPipeline);

	if(cache_get_row_count(MainPipeline)) {

		id = cache_get_field_content_int(0, "id", MainPipeline);
		cache_get_field_content(0, "IP", szIPAddress, MainPipeline);
		return RemoveBan(iRemover, id, szIPAddress);
	}
	return 1;
}

forward InitiateOfflineBan(iBanCreator, szReason[], iLength);
public InitiateOfflineBan(iBanCreator, szReason[], iLength) {

	new
		szIPAddress[16],
		id;

	if(cache_get_row_count(MainPipeline)) {
		id = cache_get_field_content_int(0, "id", MainPipeline);
		cache_get_field_content(0, "IP", szIPAddress, MainPipeline);
		if(cache_get_field_content_int(0, "AdminLevel", MainPipeline) > PlayerInfo[iBanCreator][pAdmin]) {
			return SendClientMessageEx(iBanCreator, COLOR_GREY, "You cannot ban a player with a higher admin level than you.");
		}
		return CreateBan(iBanCreator, id, INVALID_PLAYER_ID, szIPAddress, szReason, iLength);
	}

	return 1;
}

CheckBan(iPlayerID) {

	format(szMiscArray, sizeof(szMiscArray), "SELECT * FROM `ban` WHERE `active` = '1' AND (`bannedid` = '%d' OR `IP` = '%s')", PlayerInfo[iPlayerID][pId], PlayerInfo[iPlayerID][pIP]);
	mysql_function_query(MainPipeline, szMiscArray, true, "OnCheckBan", "i", iPlayerID);
	return 1;
}

forward OnCheckBan(iPlayerID);
public OnCheckBan(iPlayerID) {

	if(cache_get_row_count(MainPipeline) > 0) {

		cache_get_field_content(0, "reason", szMiscArray, MainPipeline);
		new iDate = cache_get_field_content_int(0, "liftdate", MainPipeline);
		/*
		SendClientMessageEx(iPlayerID, COLOR_RED, "This account/IP is currently banned.");
		format(szMiscArray, sizeof(szMiscArray), "Reason: %s - Unban Time (Server Time): %s", szMiscArray, date(iDate, 1));
		SendClientMessage(iPlayerID, COLOR_RED, szMiscArray);
		SetTimerEx("KickEx", 1000, false, "i", iPlayerID);
		*/
		if(iDate > gettime()) {
			SendClientMessageEx(iPlayerID, COLOR_RED, "This account or IP is currently banned.");
			format(szMiscArray, sizeof(szMiscArray), "Reason: %s - Days left (GMT 0): %s", szMiscArray, date(iDate, 1));
			SendClientMessage(iPlayerID, COLOR_RED, szMiscArray);
			SetTimerEx("KickEx", 1000, false, "i", iPlayerID);
			return 1;
		}
		else {
			SendClientMessageEx(iPlayerID, COLOR_WHITE, "Your ban has expired. You have now been unbanned.");
			RemoveBan(INVALID_PLAYER_ID, PlayerInfo[iPlayerID][pId], PlayerInfo[iPlayerID][pIP]);
			return 1;
		}

	}

	return 1;
}

CMD:unbanip(playerid, params[]) {

	if(PlayerInfo[playerid][pAdmin] < 4) return SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use this command");
	if(isnull(params)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /unbanip [ip]");

	RemoveBan(playerid, INVALID_PLAYER_ID, params);

	return 1;
}

CMD:unban(playerid, params[]) {

	if(PlayerInfo[playerid][pAdmin] < 4) return SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use this command");
	if(isnull(params)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /unban [username]");

	//if(strfind(params, "_", true, 0) != -1) SendClientMessage(playerid, COLOR_GRAD1, "Please use an underscore as spaces for non-admin accounts.");
	SetPVarString(playerid, "UnbanName", params);

	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "SELECT `id`,`IP` FROM `accounts` WHERE `Username` = '%e' LIMIT 1", params);
	mysql_function_query(MainPipeline, szMiscArray, false, "InitiateUnban", "i", playerid);

	return 1;
}

CMD:ban(playerid, params[]) {

	new
		iTargetID,
		szReason[64],
		iLength;

	if(PlayerInfo[playerid][pAdmin] < 4) return SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use this command");
	if(sscanf(params, "uds[64]", iTargetID, iLength, szReason)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /ban [playerid] [length in days] [reason]");
	if(!IsPlayerConnected(iTargetID)) return SendClientMessageEx(playerid, COLOR_GREY, "That player is not connected");
	if(PlayerInfo[playerid][pAdmin] < PlayerInfo[iTargetID][pAdmin]) return SendClientMessageEx(playerid, COLOR_GREY, "That player is a higher ranking admin than you");

	CreateBan(playerid, PlayerInfo[iTargetID][pId], iTargetID, PlayerInfo[iTargetID][pIP], szReason, iLength);

	return 1;
}

CMD:hackban(playerid, params[]) {

	new
		iTargetID = strval(params);

	if(PlayerInfo[playerid][pAdmin] < 2) return SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use this command");
	if(isnull(params)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /hackban [playerid]");
	if(!IsPlayerConnected(iTargetID)) return SendClientMessageEx(playerid, COLOR_GREY, "That player is not connected");
	if(PlayerInfo[playerid][pAdmin] < PlayerInfo[iTargetID][pAdmin]) return SendClientMessageEx(playerid, COLOR_GREY, "That player is a higher ranking admin than you");

	CreateBan(playerid, PlayerInfo[iTargetID][pId], iTargetID, PlayerInfo[iTargetID][pIP], "Hacking", 180);

	return 1;
}

CMD:saban(playerid, params[]) {

	new
		iTargetID = strval(params);

	if(PlayerInfo[playerid][pAdmin] < 2) return SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use this command");
	if(isnull(params)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /saban [playerid]");
	if(!IsPlayerConnected(iTargetID)) return SendClientMessageEx(playerid, COLOR_GREY, "That player is not connected");
	if(PlayerInfo[playerid][pAdmin] < PlayerInfo[iTargetID][pAdmin]) return SendClientMessageEx(playerid, COLOR_GREY, "That player is a higher ranking admin than you");

	CreateBan(playerid, PlayerInfo[iTargetID][pId], iTargetID, PlayerInfo[iTargetID][pIP], "Server Advertising", 180);

	return 1;
}

CMD:banaccount(playerid, params[]) {

	new
		szName[MAX_PLAYER_NAME],
		szReason[64],
		iLength;

	if(PlayerInfo[playerid][pAdmin] < 4) return SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use this command");
	if(sscanf(params, "s[24]ds[64]", szName, iLength, szReason)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /banaccount [username] [length in days] [reason]");

	if(IsPlayerConnected(ReturnUser(szName))) return SendClientMessageEx(playerid, COLOR_GREY, "That player is currently connected, use /ban.");

	SetPVarString(playerid, "BanningName", szName);

	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "SELECT `id`,`AdminLevel`,`IP` FROM `accounts` WHERE `Username` = '%e' LIMIT 1", szName);
	mysql_function_query(MainPipeline, szMiscArray, false, "InitiateOfflineBan","isi", playerid, szReason, iLength);

	return 1;
}

CMD:oldunban(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pBanAppealer] >= 1)
	{
		new string[128], query[256], tmpName[24];
		if(isnull(params)) return SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /oldunban [player name]");

		mysql_escape_string(params, tmpName, MainPipeline);
		SetPVarString(playerid, "OnUnbanPlayer", tmpName);

		format(query, sizeof(query), "UPDATE `accounts` SET `Band`=0, `Warnings`=0, `Disabled`=0 WHERE `Username`='%s' AND `PermBand` < 3", tmpName);
		format(string, sizeof(string), "Attempting to unban %s...", tmpName);
		SendClientMessageEx(playerid, COLOR_YELLOW, string);
		mysql_function_query(MainPipeline, query, false, "OnUnbanPlayer", "i", playerid);

		format(query, sizeof(query), "SELECT `IP` FROM `accounts` WHERE `Username`='%s'", tmpName);
		mysql_function_query(MainPipeline, query, true, "OnUnbanIP", "i", playerid);
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command!");
	}
	return 1;
}
