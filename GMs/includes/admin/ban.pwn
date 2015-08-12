CreateBan(iBanCreator, iBanned, iPlayerID = INVALID_PLAYER_ID, szIPAddress[], szReason[], iLength) {
	
	// SPECIFY INVALID ID for iBanCreator for System Bans
	// SPECIFY INVALID ID for iBanned when banning IP Addresses

	// iBanCreator - IG Player ID of the Ban Creator 
	// iBanned = SQL ID of the player to be banned
	// iPlayerID = IG player ID of the person to be banned
	// szIPAddress = IP Address to be banned

	szMiscArray[0] = 0;

	format(szMiscArray, sizeof(szMiscArray), "INSERT INTO `ban` (`bannedid`, `creatorid`, `IP`, `reason`, `createdate`, `liftdate`, `active`) \
		VALUES ('%d', '%d', '%s', '%s', UNIX_TIMESTAMP(), TIMETSTAMPADD(MONTH, %d, UNIX_TIMESTAMP) 1",
		iBanned, PlayerInfo[iBanCreator][pId], szIPAddress, szReason, iLength);
	
	mysql_function_query(MainPipeline, szMiscArray, false, "OnCreateBan", "iisisi", PlayerInfo[iBanCreator][pId], iPlayerID, szIPAddress, iBanned, szReason, iLength);

	return 1;
}

forward OnCreateBan(iBanCreator, iPlayerID, szIPAddress, iBanned, szReason, iLength);
public OnCreateBan(iBanCreator, iPlayerID, szIPAddress, iBanned, szReason, iLength) {

	szMiscArray[0]; 

	if(!mysql_errno(MainPipeline)) {

		
		if(iPlayerID != INVALID_PLAYER_ID) {

			format(szMiscArray, sizeof(szMiscArray), "AdmCmd: %s was banned by %s (%s)", GetPlayerNameEx(iPlayerID), GetPlayerNameEx(iBanCreator), szReason);
			ABroadCast(COLOR_LIGHTRED, szMiscArray, 2);
			SendClientMessageEx(iPlayerID, COLOR_LIGHTRED, szMiscArray);
			return SetTimerEx("KickEx", 1000, 0, "i", i);

			// to add - loop through and check IPs logged in as well
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

	szMiscArray[0] = 0;

	format(szMiscArray, sizeof(szMiscArray), "UPDATE `ban` SET `active` = 0 WHERE `bannedid` = '%d' OR `szIPAddress` = '%s'");
	mysql_function_query(MainPipeline, szMiscArray, true, "OnRemoveBan", "iis", iRemover, iBanned, szIPAddress);

	return 1;

}

forward OnRemoveBan(iRemover, iBanned, szIPAddress);
public OnRemoveBan(iRemover, iBanned, szIPAddress) {

	szMiscArray[0] = 0;

	if(!mysql_errno(MainPipeline)) {

		new iRows = cache_affected_rows(MainPipeline);

		if(!iRows) return SendClientMessageEx(iRemover, COLOR_YELLOW, "No bans matching that criteria were found");
		else {

			format(szMiscArray, sizeof(szMiscArray), "%d ban records updated.", iRows);
			SendClientMessageEx(iRemover, COLOR_WHITE, szMiscArray);
			
			//format(szMiscArray, sizeof(szMiscArray), "%s has unbanned %s."); // WIP
		}
	}
	else SendClientMessageEx(iRemover, COLOR_YELLOW, "There was an issue removing that ban ...");

	return 1;
}

CheckBan(iPlayerID) {

	szMiscArray[0] = 0;

	format(szMiscArray, sizeof(szMiscArray), "SELECT * FROM `")
}