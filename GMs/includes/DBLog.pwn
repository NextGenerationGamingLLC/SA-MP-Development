#include <YSI\y_hooks>

new DB:db_iHandle;

hook OnGameModeInit() {
	
	db_iHandle = db_open("logs.db");

	return 1;
}

hook OnGameModeExit() {
	db_close(db_iHandle);
}

/*
	This can be used for:
		-Admin
		-Admin Aution
		-Admin Give
		-Admin Pay
		-Auction
		-Ban
		-Backpack
		-Business Edit
		-Business
		-CLEO
		-Contracts
		-Credits
		-Crime
		-Dynamic Door Edit
		-Dealership
		-Dynamic Map Icon Edit
		-Dynamic Vehicle
		-Dynamic Vehicle Spawn
		-Edit Group
		-Faction 
		-Flag Move
		-Flags
		-Garage Edit
		-Gate Edit
		-Gifts
		-Government
		-Group
		-Hack
		-House Edit
		-House Safe
		-Kick
		-Licenses
		-Login Credits
		-Mail
		-Micro
		-Moderator
		-Mute
		-Priority Ad
		-Password
		-Pay
		-Plant
		-Player Vehicle
		-Pay N' Spray
		-Poker
		-Rapid Fire
		-RP Special
		-Sell Credits
		-Set VIP
		-Shpo Confirmed Orders
		-Shop
		-Shop Orders
		-s0biet
		-Speedcam
		-Stats
		-Text Label Edit
		-Toys
		-Toy Edit
		-Toy Delete
		-Undercover
		-VIP Name-changes
		-VIP Remove
		-Voucher

*/		
//DBLog(iPlayerID, iTargetID = INVALID_PLAYER_ID, szLogTable[], szLogText[]) {
DBLog(iPlayerID, iTargetID = INVALID_PLAYER_ID, szLogTable[], szLogText[]) {

	format(szMiscArray, sizeof(szMiscArray), "INSERT INTO `%s` (`Timestamp`,`PlayerID`,`TargetID`,`LogText`,`PlayerIP`,`TargetIP`) VALUES ('%d','%d','%d','%s','%s','%s')", szLogTable, gettime(), PlayerInfo[iPlayerID][pId], PlayerInfo[iTargetID][pId], szLogText, PlayerInfo[iPlayerID][pIP], PlayerInfo[iTargetID][pIP]);
	db_free_result(db_query(db_iHandle, szMiscArray));
	printf("%s",szMiscArray);

	return 1;
}

ChatDBLog(iPlayerID, szLogTable[], szLogText[]) {

	format(szMiscArray, sizeof(szMiscArray), "INSERT INTO `%s` (`Timestamp`,`PlayerID`,`LogText`,`PlayerIP`) VALUES ('%d','%d','%s','%s')", szLogTable, gettime(), PlayerInfo[iPlayerID][pId], szLogText, PlayerInfo[iPlayerID][pIP]);
	db_free_result(db_query(db_iHandle, szMiscArray));
	printf("%s",szMiscArray);

	return 1;
}

CasinoDBLog(iPlayerID, game[], amount, prize, num1, num2, num3) {

	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "INSERT INTO `cp_casino_log` (`Timestamp`, `PlayerID`, `game`, `amount`,`prize`,`num1`,`num2`,`num3`,`PlayerIP`) VALUES ('%d','%d','%s','%d','%d','%d','%d','%d','%s')", gettime(), PlayerInfo[iPlayerID][pId], game, amount, prize, num1, num2, num3, PlayerInfo[iPlayerID][pIP]);
	mysql_tquery(MainPipeline, szMiscArray, "OnQueryFinish", "i", SENDDATA_THREAD);
	//db_free_result(db_query(db_iHandle, szMiscArray));
	printf("%s",szMiscArray);

	return 1;
}

/*
PropertyDBLog(iPlayerID, iTargetID = INVALID_PLAYER_ID, PropertyID, szLogTable[], szLogText[]) {

	format(szMiscArray, sizeof(szMiscArray), "INSERT INTO `%s` (`Timestamp`,`PlayerID`,`PropertyID`,`LogText`,`PlayerIP`) VALUES ('%d','%d','%d','%s','%s')", szLogTable, gettime(), PlayerInfo[iPlayerID][pId], PropertyID, szLogText, PlayerInfo[iPlayerID][pIP]);
	db_free_result(db_query(db_iHandle, szMiscArray));
	printf("%s",szMiscArray);

	return 1;
}
*/

/*
	Function: GroupDBLog
	Parameters: 
		-iPlayerID - The player who's executing the item to be logged.
		-iTargetID - The player who's affected by the item being executed.
		-iGroupID  - The GroupID that will be affected (please note this can be a group, business, etc - use table specf.)
		-szLogTable - The name of the table you wish to log to (this is case sensitive).
		-szLogText - The text you wish to log.
		
		
*/
		/*
GroupDBLog(iPlayerID, iGroupID, szLogText) {

	format(szMiscArray, sizeof(szMiscArray),  "INSERT INTO `cp_log_group` (`Timestamp`,`GroupID`,`PlayerID`,`LogText`,`PlayerIP`) VALUES ('%d','%d','%d','%s','%s')", gettime(), iGroupID, PlayerInfo[iPlayerID][pId], szLogText, PlayerInfo[iPlayerID][pIP]);
	db_free_result(db_query(db_iHandle, szMiscArray));
	printf("%s",szMiscArray);

	return 1;
}
*/

/* 
	Function: ConectionDBLog
	Parameters: 
		-iPlayerID - The player who's connection you wish to log.

*/
ConnectionDBLog(iPlayerID) {

	format(szMiscArray, sizeof(szMiscArray), "INSERT INTO `Connections` (`Timestamp`,`PlayerID`,`PlayerIP`) VALUES ('%d', '%d', '%s')", gettime(), PlayerInfo[iPlayerID][pId], PlayerInfo[iPlayerID][pIP]);
	db_free_result(db_query(db_iHandle, szMiscArray));
	
	return 1;
}
