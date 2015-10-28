/* Anti-Chat v2.0
	[###] Jingles
*/

#define 			HACKTIMER_INTERVAL 			5000
#define 			CARSURFING					0

ptask HackCheck[HACKTIMER_INTERVAL](playerid) {

	if(AC_IsPlayerSurfing(playerid)) AC_Process(playerid, CARSURFING);
}

AC_Process(playerid, processid) {

	szMiscArray[0] = 0;
	switch(processid) {

		case CARSURFING: {

			new Float:fPos[3];
			GetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]);
			SetPlayerPos(playerid, fPos[0] + 1.0, fPos[1] + 1.0, fPos[2]);
			PlayAnimEx(playerid, "PED", "BIKE_fallR", 4.1, 0, 1, 1, 1, 0, 1);
			szMiscArray = "[SYSTEM]: Car Surfing detected.:";
		}
	}

	format(szMiscArray, sizeof(szMiscArray), "%s %s (ID: %d)", szMiscArray, GetPlayerNameExt(playerid), playerid);
	SendClientMessageEx(playerid, COLOR_LIGHTRED, szMiscArray);
	return 1;
}

AC_IsPlayerSurfing(playerid)
{
	if(zombieevent) return 0;
	new iVehID = GetPlayerSurfingVehicleID(playerid);
	if(iVehID == INVALID_VEHICLE_ID) return 0;
	switch(GetVehicleModel(iVehID)) {

		case 403, 406, 422, 433, 443, 446, 452, 453, 454, 455, 470, 472, 473, 478, 484, 493, 500, 514, 515, 525, 543, 554, 578, 595, 605, 607: return 0;
		case 417, 423, 416, 425, 427, 431, 437, 447, 469, 487, 488, 497, 508, 528, 537, 538, 449, 548, 563, 56, 570, 577, 590, 592, 490: return 0; // often modded vehicles
	}
	return 1;
}