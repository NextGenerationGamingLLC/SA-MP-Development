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

/*
PropertyDBLog(iPlayerID, iTargetID = INVALID_PLAYER_ID, PropertyID, szLogTable[], szLogText[]) {

	format(szMiscArray, sizeof(szMiscArray), "INSERT INTO `%s` (`Timestamp`,`PlayerID`,`PropertyID`,`LogText`,`PlayerIP`) VALUES ('%d','%d','%d','%s','%s')", szLogTable, gettime(), PlayerInfo[iPlayerID][pId], PropertyID, szLogText, PlayerInfo[iPlayerID][pIP]);
	db_free_result(db_query(db_iHandle, szMiscArray));
	printf("%s",szMiscArray);

	return 1;
}


// 
GroupDBLog(iPlayerID, iTargetID = INVALID_PLAYER_ID, iGroupID, szLogTable[], szLogText) {

	format(szMiscArray, sizeof(szMiscArray),  "INSERT INTO `%s` (`Timestamp`,`GroupID`,`PlayerID`,`TargetID`,`LogText`,`PlayerIP`,`TargetIP`) VALUES ('%d','%d','%d','%d','%s','%s','%s')", szLogTable, gettime(), PlayerInfo[iPlayerID][pId], PlayerInfo[iTargetID][pId], szLogText, PlayerInfo[iPlayerID][pIP], PlayerInfo[iTargetID][pIP]);
	db_free_result(db_query(db_iHandle, szMiscArray));
	printf("%s",szMiscArray);

	return 1;
}*/