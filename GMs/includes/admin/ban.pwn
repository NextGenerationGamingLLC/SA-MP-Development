#include <YSI\y_hooks>

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	switch(dialogid) {

		case DIALOG_MONEYFARMING: {
			if(response) {
				if(strcmp(inputtext, "Ban All", true) == 0) {

					new szIP[16];
					GetPVarString(playerid, "MF_IP", szIP, sizeof(szIP));
					format(szMiscArray, sizeof(szMiscArray), "%s 90 Moneyfarming", szIP);
					cmd_banip(playerid, szMiscArray);
				}
			}
		}
	}
	return 0;
}


CreateBan(iBanCreator, iBanned, iPlayerID, szIPAddress[], szReason[], iLength, iSilentBan = 0, iPermBan = 0) {

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
		iBanned, iBanCreator == INVALID_PLAYER_ID ? INVALID_PLAYER_ID:PlayerInfo[iBanCreator][pId], szIPAddress, g_mysql_ReturnEscaped(szReason, MainPipeline), iLength);

	mysql_function_query(MainPipeline, szMiscArray, false, "OnCreateBan", "iisisiii", iBanCreator, iPlayerID, szIPAddress, iBanned, szReason, iLength, iSilentBan, iPermBan);

	return 1;
}

forward OnCreateBan(iBanCreator, iPlayerID, szIPAddress[], iBanned, szReason[], iLength, iSilentBan, iPermBan);
public OnCreateBan(iBanCreator, iPlayerID, szIPAddress[], iBanned, szReason[], iLength, iSilentBan, iPermBan) {
 
	new
		string[128];

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
			else if(iBanCreator != INVALID_PLAYER_ID && iPermBan == 0) {
				format(szMiscArray, sizeof(szMiscArray), "AdmCmd: %s was banned by %s (%s)", GetPlayerNameEx(iPlayerID), GetPlayerNameEx(iBanCreator), szReason);
			}
			else if(iBanCreator != INVALID_PLAYER_ID && iPermBan == 1) {
				format(szMiscArray, sizeof(szMiscArray), "AdmCmd: %s was permanently banned by %s (%s)", GetPlayerNameEx(iPlayerID), GetPlayerNameEx(iBanCreator), szReason);
			}

			if(!iSilentBan) {
				SendClientMessageToAllEx(COLOR_LIGHTRED, szMiscArray);
				SendClientMessageEx(iPlayerID, COLOR_LIGHTRED, szMiscArray);
			}
			else {
				format(string, sizeof(string), "[Silent] %s", szMiscArray);
				ABroadCast(COLOR_LIGHTRED, string, 2);
				SendClientMessageEx(iPlayerID, COLOR_LIGHTRED, szMiscArray);
			}
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


forward InitiateIPBan(iBanCreator, szReason[], iLength);
public InitiateIPBan(iBanCreator, szReason[], iLength) {

	new iRows,
		iFields,
		szIPAddress[16],
		szName[MAX_PLAYER_NAME],
		id,
		iCount;

	cache_get_data(iRows, iFields, MainPipeline);
	if(iRows) {
		while(iCount < iRows) {

			id = cache_get_field_content_int(iCount, "id", MainPipeline);
			cache_get_field_content(iCount, "IP", szIPAddress, MainPipeline);
			cache_get_field_content(iCount, "Username", szName, MainPipeline, MAX_PLAYER_NAME);
			SetPVarString(iBanCreator, "BanningName", szName);
			if(cache_get_field_content_int(iCount, "AdminLevel", MainPipeline) > PlayerInfo[iBanCreator][pAdmin]) {
				format(szMiscArray, sizeof(szMiscArray), "[SYSTEM]: Couldn't ban account ID %d (higher admin level than you).", id);
				SendClientMessageEx(iBanCreator, COLOR_GREY, szMiscArray);
			}
			else CreateBan(iBanCreator, id, INVALID_PLAYER_ID, szIPAddress, szReason, iLength);
			iCount++;
		}
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

	if(PlayerInfo[playerid][pAdmin] < 1337) return SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use this command");
	if(isnull(params)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /unbanip [ip]");

	RemoveBan(playerid, INVALID_PLAYER_ID, params);

	return 1;
}

CMD:unban(playerid, params[]) {

	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pBanAppealer] < 1 && PlayerInfo[playerid][pASM] < 1) return SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use this command");
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
		iLength,
		iSilentBan = 0;

	if(PlayerInfo[playerid][pAdmin] < 2) return SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use this command");
	if(sscanf(params, "udD(0)s[64]", iTargetID, iLength, iSilentBan, szReason)) {

		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /ban [playerid] [length in days] [silent(1=yes 2=no)] [reason]");
		SendClientMessageEx(playerid, COLOR_GREY, "** 1 = Yes, the ban will only broadcast to admins | 2 = No, the ban will be globally broadcasted **");
		return 1;
	}
	if(!IsPlayerConnected(iTargetID)) return SendClientMessageEx(playerid, COLOR_GREY, "That player is not connected");
	if(!(0 <= iSilentBan < 2)) {

		SendClientMessageEx(playerid, COLOR_GREY, "You must specify a value that is either 0 or 1");
		SendClientMessageEx(playerid, COLOR_GREY, "** 1 = Yes, the ban will only broadcast to admins | 2 = No, the ban will be globally broadcasted **");
		return 1;
	}
	if(PlayerInfo[playerid][pAdmin] < PlayerInfo[iTargetID][pAdmin]) return SendClientMessageEx(playerid, COLOR_GREY, "That player is a higher ranking admin than you");

	CreateBan(playerid, PlayerInfo[iTargetID][pId], iTargetID, GetPlayerIpEx(iTargetID), szReason, iLength, iSilentBan);

	return 1;
}

CMD:permban(playerid, params[]) {

	new
		iTargetID,
		szReason[64],
		iSilentBan = 0;

	if(PlayerInfo[playerid][pAdmin] < 1337) return SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use this command");
	if(sscanf(params, "us[64]D(0)", iTargetID, szReason, iSilentBan)) {

		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /permban [playerid] [reason] [silent(optional)]");
		SendClientMessageEx(playerid, COLOR_GREY, "** Acceptable values for silent are 0=No and 1=Yes, Default is 0 **");
		return 1;
	}
	if(!IsPlayerConnected(iTargetID)) return SendClientMessageEx(playerid, COLOR_GREY, "That player is not connected");
	if(!(0 <= iSilentBan < 2)) {

		SendClientMessageEx(playerid, COLOR_GREY, "You must specify a value that is either 0 or 1");
		SendClientMessageEx(playerid, COLOR_GREY, "** 1 = Yes, the ban will only broadcast to admins | 2 = No, the ban will be globally broadcasted **");
		return 1;
	}
	if(PlayerInfo[playerid][pAdmin] < PlayerInfo[iTargetID][pAdmin]) return SendClientMessageEx(playerid, COLOR_GREY, "That player is a higher ranking admin than you");

	CreateBan(playerid, PlayerInfo[iTargetID][pId], iTargetID, GetPlayerIpEx(iTargetID), szReason, 9999999, iSilentBan, 1);

	return 1;
}

CMD:hackban(playerid, params[]) {

	new
		iTargetID,
		iSilentBan = 0;

	if(PlayerInfo[playerid][pAdmin] < 2) return SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use this command");
	if(sscanf(params, "uD(0)", iTargetID, iSilentBan)) {

		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /hackban [playerid] [silent(optional)]");
		SendClientMessageEx(playerid, COLOR_GREY, "** Acceptable values for silent are 0=No and 1=Yes, Default is 0 **");
		return 1;
	}
	if(!IsPlayerConnected(iTargetID)) return SendClientMessageEx(playerid, COLOR_GREY, "That player is not connected");
	if(!(0 <= iSilentBan < 2)) {

		SendClientMessageEx(playerid, COLOR_GREY, "You must specify a value that is either 0 or 1");
		SendClientMessageEx(playerid, COLOR_GREY, "** 1 = Yes, the ban will only broadcast to admins | 2 = No, the ban will be globally broadcasted **");
		return 1;
	}
	if(PlayerInfo[playerid][pAdmin] < PlayerInfo[iTargetID][pAdmin]) return SendClientMessageEx(playerid, COLOR_GREY, "That player is a higher ranking admin than you");

	CreateBan(playerid, PlayerInfo[iTargetID][pId], iTargetID, GetPlayerIpEx(iTargetID), "Hacking", 180, iSilentBan);

	return 1;
}

CMD:saban(playerid, params[]) {

	new
		iTargetID,
		iSilentBan = 0;

	if(PlayerInfo[playerid][pAdmin] < 2) return SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use this command");
	if(sscanf(params, "uD(0)", iTargetID, iSilentBan)) {

		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /saban [playerid] [silent(optional)]");
		SendClientMessageEx(playerid, COLOR_GREY, "** Acceptable values for silent are 0=No and 1=Yes, Default is 0 **");
		return 1;
	}
	if(!IsPlayerConnected(iTargetID)) return SendClientMessageEx(playerid, COLOR_GREY, "That player is not connected");
	if(!(0 <= iSilentBan < 2)) {

		SendClientMessageEx(playerid, COLOR_GREY, "You must specify a value that is either 0 or 1");
		SendClientMessageEx(playerid, COLOR_GREY, "** 1 = Yes, the ban will only broadcast to admins | 2 = No, the ban will be globally broadcasted **");
		return 1;
	}
	if(PlayerInfo[playerid][pAdmin] < PlayerInfo[iTargetID][pAdmin]) return SendClientMessageEx(playerid, COLOR_GREY, "That player is a higher ranking admin than you");

	CreateBan(playerid, PlayerInfo[iTargetID][pId], iTargetID, GetPlayerIpEx(iTargetID), "Server Advertising", 180, iSilentBan);

	return 1;
}

CMD:moneyfarmban(playerid, params[]) {

	if(PlayerInfo[playerid][pAdmin] < 99999) return 1;
	new uPlayer;
	if(sscanf(params, "u", uPlayer)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /moneyfarmban [playerid / name]");
	format(szMiscArray, sizeof(szMiscArray), "SELECT `Username`, `IP`, `Money`, `Bank`, `SPos_x`, `SPos_y`, `SPos_z` FROM `accounts` WHERE `IP` = '%s'", GetPlayerIpEx(uPlayer));
	mysql_function_query(MainPipeline, szMiscArray, true, "OnCheckMoneyFarm", "is", playerid, GetPlayerIpEx(uPlayer));
	return 1;
}

forward OnCheckMoneyFarm(playerid, szIP[]);
public OnCheckMoneyFarm(playerid, szIP[]) {

	szMiscArray[0] = 0;
	new iRows,
		iFields,
		iCount,
		szTitle[48],
		szName[MAX_PLAYER_NAME],
		szZone[MAX_ZONE_NAME];

	cache_get_data(iRows, iFields, MainPipeline);
	while(iCount < iRows) {

		cache_get_field_content(iCount, "Username", szName, MainPipeline, MAX_PLAYER_NAME);
		cache_get_field_content(iCount, "IP", szIP, MainPipeline, 16);
		Get3DZone(cache_get_field_content_float(iCount, "SPos_x", MainPipeline),
			cache_get_field_content_float(iCount, "SPos_y", MainPipeline),
			cache_get_field_content_float(iCount, "SPos_z", MainPipeline),
			szZone, MAX_ZONE_NAME);
		
		format(szMiscArray, sizeof(szMiscArray), "%s\n%s - %s - Hand: $%s Bank: $%s - LastLocation: %s", szMiscArray, szName, szIP,
			number_format(cache_get_field_content_int(iCount, "Money", MainPipeline)), number_format(cache_get_field_content_int(iCount, "Bank", MainPipeline)), szZone);
		iCount++;
	}
	strcat(szMiscArray, "\n___________________\nBan All", sizeof(szMiscArray));
	SetPVarString(playerid, "MF_IP", szIP);
	format(szTitle, sizeof(szTitle), "%s - Moneyfarm check", szIP);
	ShowPlayerDialogEx(playerid, DIALOG_MONEYFARMING, DIALOG_STYLE_LIST, szTitle, szMiscArray, "Select", "<<");
}


CMD:banip(playerid, params[]) {

	new
		szIP[MAX_PLAYER_NAME],
		szReason[64],
		iLength;

	if(PlayerInfo[playerid][pAdmin] < 1337) return SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use this command");
	if(sscanf(params, "s[16]ds[64]", szIP, iLength, szReason)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /banip [ip] [length in days] [reason]");

	if(IsPlayerConnected(ReturnUserFromIP(szIP))) return SendClientMessageEx(playerid, COLOR_GREY, "That player is currently connected, use /ban.");

	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "SELECT `id`,`AdminLevel`,`IP` FROM `accounts` WHERE `IP` = '%e'", szIP);
	mysql_function_query(MainPipeline, szMiscArray, false, "InitiateIPBan","isi", playerid, szReason, iLength);

	return 1;
}


CMD:banaccount(playerid, params[]) {

	new
		szName[MAX_PLAYER_NAME],
		szReason[64],
		iLength;

	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pBanAppealer] < 2 && PlayerInfo[playerid][pASM] < 1) return SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use this command");
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
