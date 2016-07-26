// Area debugging
#include <YSI\y_hooks>

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {

	if(newkeys & KEY_YES) {

		new szAreas[10];
		GetPlayerDynamicAreas(playerid, szAreas, sizeof(szAreas));
		format(szMiscArray, sizeof(szMiscArray), "Areas: %d, %d, %d, %d, %d, %d, %d, %d, %d, %d,",
			szAreas[0], szAreas[1], szAreas[2], szAreas[3], szAreas[4], szAreas[5], szAreas[6], szAreas[7], szAreas[8], szAreas[9]);
		SendClientMessage(playerid, COLOR_YELLOW, szMiscArray);

		if(szAreas[0] != INVALID_STREAMER_ID) {
			for(new i; i < MAX_GROUP_LOCKERS; ++i) {
				
				if(szAreas[0] == arrGroupLockers[PlayerInfo[playerid][pMember]][i][g_iLockerAreaID]) {
					cmd_locker(playerid, "");
					format(szMiscArray, sizeof(szMiscArray), "AreaID: %d, Locker Area ID: %d", szAreas[0], arrGroupLockers[PlayerInfo[playerid][pMember]][i][g_iLockerAreaID]);
					SendClientMessage(playerid, COLOR_GRAD1, szMiscArray);
				}
			}
		}
	}
}

hook OnPlayerEnterDynamicArea(playerid, areaid)	{

	format(szMiscArray, sizeof(szMiscArray), "Entered area: %d", areaid);
	SendClientMessage(playerid, COLOR_YELLOW, szMiscArray);
}

hook OnPlayerLeaveDynamicArea(playerid, areaid)	{

	format(szMiscArray, sizeof(szMiscArray), "Left area: %d", areaid);
	SendClientMessage(playerid, COLOR_YELLOW, szMiscArray);
}