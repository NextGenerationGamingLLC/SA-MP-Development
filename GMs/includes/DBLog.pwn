#include <YSI\y_hooks>

new DB:db_iHandle;

hook OnGameModeInit() {
	
	db_iHandle = db_open("logs.db");

	return 1;
}

hook OnGameModeExit() {
	db_close(db_iHandle);
}


DBLog(iPlayerID, iTargetID = INVALID_PLAYER_ID, szLogTable[], szLogText[]) {

	format(szMiscArray, sizeof(szMiscArray), "INSERT INTO `%s` (`Timestamp`,`PlayerID`,`TargetID`,`LogText`) VALUES (%d, %d, %d, %s)", szLogTable, gettime(), PlayerInfo[iPlayerID][pId], PlayerInfo[iTargetID][pId], szLogText);
	db_free_result(db_query(db_iHandle, szMiscArray));
	printf("%s",szMiscArray);

	return 1;
}

/*GroupDBLog(iGroupID, iPlayerID, szLogTable[], szLogText) {

	format(szMiscArray, sizeof(szMiscArray), "INSERT INTO `%s` (`Timestamp`,`GroupID`, `PlayerID`,`LogText`) VALUES (UNIX_TIMESTAMP(), '%d','%d', '%s')", szLogTable, iGroupID, PlayerInfo[iPlayerID][pId], szLogText);
	db_free_result(db_query(db_iHandle, szMiscArray));

	return 1;
}*/

	