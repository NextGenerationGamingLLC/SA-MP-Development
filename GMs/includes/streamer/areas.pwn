#include <YSI\y_hooks>

#define 	STREAMER_AREATYPE_DOOR 			(500)
#define 	STREAMER_AREATYPE_HOUSE 		(501)
#define 	STREAMER_AREATYPE_BUSINESS		(502)
#define 	STREAMER_AREATYPE_GARAGE		(503)
#define 	STREAMER_AREATYPE_PLAYERAREA	(504)


new ParachuteArea;

hook OnGameModeInit() {

	print("[Streamer] Loading Dynamic Areas...");

	iVehExits[0] = CreateDynamicSphere(3.6661,23.0627,1199.6012, 3.0);
	iVehExits[1] = CreateDynamicSphere(2820.2109,1527.8270,-48.9141+2500, 3.0);
	iVehExits[2] = CreateDynamicSphere(315.6100,1028.6777,1948.5518, 3.0);

	Streamer_SetIntData(STREAMER_TYPE_AREA, iVehExits[0], E_STREAMER_EXTRA_ID, 0);
	Streamer_SetIntData(STREAMER_TYPE_AREA, iVehExits[1], E_STREAMER_EXTRA_ID, 1);
	Streamer_SetIntData(STREAMER_TYPE_AREA, iVehExits[2], E_STREAMER_EXTRA_ID, 2);

	ParachuteArea = CreateDynamicSphere(1544.2,-1353.4,329.4, 2.0);
	
	return 1;
}

hook OnPlayerEnterDynamicArea(playerid, areaid) {

	if(areaid == ParachuteArea) GivePlayerValidWeapon(playerid, 46);
	return 1;
}