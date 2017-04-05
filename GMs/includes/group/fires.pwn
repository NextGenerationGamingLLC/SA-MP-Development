/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Fire System

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

#include <YSI\y_hooks>

#define			MAX_FIRES				100
#define			MAX_FIRE_HEALTH			1000
#define 		MAX_FIRE_AREAS			3
#define 		MAX_FIRE_TYPES			3
#define 		DEFAULT_FDSA_REQUIRED	1

new iGlobalZoneAreas[MAX_FIRE_AREAS];

new Float:fire_fRandomLocations[10][3] = {
	
	{1381.2661, -1088.7556, 27.3906},
	{823.4922, -1102.9449, 25.7891},
	{1112.0642, -1370.0339, 13.9844},
	{1789.2281, -1384.4358, 15.7578},
	{2101.0112, -1359.6780, 23.9844},
	{2351.9951, -1419.2737, 24.0000},
	{2151.0457, -1808.0161, 13.5464},
	{2326.3098, -1897.3530, 13.6172},
	{2357.0618, -1990.4791, 13.5469},
	{1730.1848, -2335.4980, 13.5469}
};

/*
task FireTask[60000]() { // 300000

	new iFDSAOnline;
	foreach(new i: Player) {

		if(IsAMedic(i)) iFDSAOnline++;
	}
	if(iFDSAOnline >= DEFAULT_FDSA_REQUIRED) {
	
		if(random(100) < 10) CreateTypeFire(random(MAX_FIRE_TYPES));
	}
}
*/

hook OnGameModeInit() {

	iGlobalZoneAreas[0] = CreateDynamicRectangle(gMainZones[0][SAZONE_AREA][0], gMainZones[0][SAZONE_AREA][1], gMainZones[0][SAZONE_AREA][3], gMainZones[0][SAZONE_AREA][4]); // Los Santos
	iGlobalZoneAreas[1] = CreateDynamicRectangle(gMainZones[6][SAZONE_AREA][0], gMainZones[6][SAZONE_AREA][1], gMainZones[6][SAZONE_AREA][3], gMainZones[6][SAZONE_AREA][4]); // Red County
	iGlobalZoneAreas[2] = CreateDynamicRectangle(gMainZones[7][SAZONE_AREA][0], gMainZones[7][SAZONE_AREA][1], gMainZones[7][SAZONE_AREA][3], gMainZones[7][SAZONE_AREA][4]); // Flint County
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	switch(dialogid) {

		case DIALOG_FIRES: {

			SetPlayerPos(playerid, arrFires[ListItemTrackId[playerid][listitem]][fire_fPos][0],
				arrFires[ListItemTrackId[playerid][listitem]][fire_fPos][1], arrFires[ListItemTrackId[playerid][listitem]][fire_fPos][2]);
		}
	}
	return 0;
}

stock CreateTypeFire(iTypeID) {

	new iTargetID;
	switch(iTypeID) {

		case 0: { // Houses

			iTargetID = Fire_GetRandomValidID(iTypeID);
			if(iTargetID != -1) {

				new szLocation[MAX_ZONE_NAME];
				CreateStructureFire(HouseInfo[iTargetID][hExteriorX], HouseInfo[iTargetID][hExteriorY], HouseInfo[iTargetID][hExteriorZ], HouseInfo[iTargetID][hExtVW]);
				CreateStructureFire(HouseInfo[iTargetID][hInteriorX], HouseInfo[iTargetID][hInteriorY], HouseInfo[iTargetID][hInteriorZ], HouseInfo[iTargetID][hIntVW]);
				arrFires[iTargetID][fire_iTypeID] = iTypeID;
				Get3DZone(HouseInfo[iTargetID][hExteriorX], HouseInfo[iTargetID][hExteriorY], HouseInfo[iTargetID][hExteriorZ], szLocation, sizeof(szLocation));
				format(szMiscArray, sizeof(szMiscArray), "** There was a fire reported somewhere in %s.", szLocation);
				SendGroupMessage(GROUP_TYPE_MEDIC, COLOR_LIGHTRED, szMiscArray);
			}
		}
		case 1: { // Businesses

			iTargetID = Fire_GetRandomValidID(iTypeID);
			if(iTargetID != -1) {

				new szLocation[MAX_ZONE_NAME];
				CreateStructureFire(Businesses[iTargetID][bExtPos][0], Businesses[iTargetID][bExtPos][1], Businesses[iTargetID][bExtPos][2], 0);
				CreateStructureFire(Businesses[iTargetID][bIntPos][0], Businesses[iTargetID][bIntPos][1], Businesses[iTargetID][bIntPos][2], Businesses[iTargetID][bVW]);
				arrFires[iTargetID][fire_iTypeID] = iTypeID;
				Get3DZone(Businesses[iTargetID][bExtPos][0], Businesses[iTargetID][bExtPos][1], Businesses[iTargetID][bExtPos][2], szLocation, sizeof(szLocation));
				format(szMiscArray, sizeof(szMiscArray), "** There was a fire reported somewhere in %s.", szLocation);
				SendGroupMessage(GROUP_TYPE_MEDIC, COLOR_LIGHTRED, szMiscArray);
			}
		}
		case 2: { // Random

			new szLocation[MAX_ZONE_NAME];
			iTargetID = random(sizeof(fire_fRandomLocations));
			CreateStructureFire(fire_fRandomLocations[iTargetID][0], fire_fRandomLocations[iTargetID][1], fire_fRandomLocations[iTargetID][2], 0);
			arrFires[iTargetID][fire_iTypeID] = iTypeID;
			Get3DZone(fire_fRandomLocations[iTargetID][0], fire_fRandomLocations[iTargetID][1], fire_fRandomLocations[iTargetID][2], szLocation, sizeof(szLocation));
			format(szMiscArray, sizeof(szMiscArray), "** There was a fire reported somewhere in %s.", szLocation);
			SendGroupMessage(GROUP_TYPE_MEDIC, COLOR_LIGHTRED, szMiscArray);
		}
	}
}

stock Fire_GetRandomValidID(iTypeID) {

	new iCheckID,
		iTargetID = -1,
		iZoneArea = random(MAX_FIRE_AREAS),
		iAttempts;

	switch(iTypeID) {

		case 0: {

			while(iCheckID != iTargetID) {
				iTargetID = random(MAX_HOUSES);
				if(HouseInfo[iTargetID][hExteriorX] != 0.0 && HouseInfo[iTargetID][hExteriorZ] < 100 && IsPointInDynamicArea(iGlobalZoneAreas[iZoneArea], HouseInfo[iTargetID][hExteriorX], HouseInfo[iTargetID][hExteriorY], HouseInfo[iTargetID][hExteriorZ])) {

					iCheckID = iTargetID;
				}
				iAttempts++;
				if(iAttempts >= MAX_HOUSES) break;
			}
		}
		case 1: {

			while(iCheckID != iTargetID) {

				iTargetID = random(MAX_BUSINESSES);
				if(Businesses[iTargetID][bExtPos][0] != 0.0 && HouseInfo[iTargetID][hExteriorZ] < 100 && IsPointInDynamicArea(iGlobalZoneAreas[iZoneArea], Businesses[iTargetID][bExtPos][0], Businesses[iTargetID][bExtPos][1], Businesses[iTargetID][bExtPos][2])) {
					
					iCheckID = iTargetID;
				}
				iAttempts++;
				if(iAttempts >= MAX_BUSINESSES) break;
			}
		}
	}
	return iTargetID;
}

CreateStructureFire(Float:FirePosX, Float:FirePosY, Float:FirePosZ, VW) {

	if(iServerFires < MAX_FIRES) {

		new next = GetAvailableFireSlot();
		arrFires[next][fire_iObjectID] = CreateDynamicObject(18691, FirePosX, FirePosY, FirePosZ - 1.5, 0,0,0, VW, .streamdistance = 300);
		arrFires[next][fire_iAreaID] = CreateDynamicSphere(FirePosX, FirePosY, FirePosZ, 3.0, VW);

		arrFires[next][fire_fPos][0] = FirePosX;
		arrFires[next][fire_fPos][1] = FirePosY;
		arrFires[next][fire_fPos][2] = FirePosZ;

		// Streamer_SetIntData(STREAMER_TYPE_OBJECT, arrFires[next][fire_iObjectID], E_STREAMER_EXTRA_ID, next);
		Streamer_SetIntData(STREAMER_TYPE_AREA, arrFires[next][fire_iAreaID], E_STREAMER_EXTRA_ID, next);
		
		arrFires[next][fire_iHealth] = MAX_FIRE_HEALTH;

		format(szMiscArray, sizeof(szMiscArray), "%d/%d\nID%d", arrFires[next][fire_iHealth], MAX_FIRE_HEALTH, next);
		arrFires[next][fire_iTextID] = CreateDynamic3DTextLabel(szMiscArray, 0xFFFFFFFFF, FirePosX, FirePosY, FirePosZ, 20, .worldid = VW);
		++iServerFires;
	}
}

DeleteStructureFire(iFireID) {

	if(!IsValidDynamicObject(arrFires[iFireID][fire_iObjectID])) return 1;
	else DestroyDynamicObject(arrFires[iFireID][fire_iObjectID]), arrFires[iFireID][fire_iObjectID] = -1;
	if(IsValidDynamic3DTextLabel(arrFires[iFireID][fire_iTextID])) DestroyDynamic3DTextLabel(arrFires[iFireID][fire_iTextID]), arrFires[iFireID][fire_iTextID] = Text3D:-1;
	if(IsValidDynamicArea(arrFires[iFireID][fire_iAreaID])) DestroyDynamicArea(arrFires[iFireID][fire_iAreaID]);
	if(iServerFires) --iServerFires;
	return 1;
}

IsValidStructureFire(iFireID) {

	if(IsValidDynamicObject(arrFires[iFireID][fire_iObjectID])) return true;
	else return false;
}

GetAvailableFireSlot() {

	for(new i; i < MAX_FIRES; i++) {

		if(!IsValidDynamicObject(arrFires[i][fire_iObjectID])) return i;
	}
	return -1;
}

GetFireType(iTypeID) {

	new szResult[32];
	switch(iTypeID) {

		case 0: szResult = "House Fire";
		case 1: szResult = "Business Fire";
		case 2: szResult = "Random Fire";
		default: szResult = "Admin Fire";
	}
	return szResult;
}

hook OnPlayerUpdate(playerid) {

	new newkeys, dir1, dir2;
	GetPlayerKeys(playerid, newkeys, dir1, dir2);
	
	if(ActiveKey(KEY_FIRE)) {

		if(GetPlayerWeapon(playerid) == WEAPON_FIREEXTINGUISHER) {

			new n;
			for(n = 0; n < MAX_FIRES; n++) {

				if(IsValidStructureFire(n))	{

					if(IsPlayerAimingAt(playerid, arrFires[n][fire_fPos][0], arrFires[n][fire_fPos][1], arrFires[n][fire_fPos][2], 1) \
					&& IsPlayerInRangeOfPoint(playerid, 4, arrFires[n][fire_fPos][0], arrFires[n][fire_fPos][1], arrFires[n][fire_fPos][2])) {

						arrFires[n][fire_iHealth] -=2;
						format(szMiscArray, sizeof(szMiscArray), "%d/%d\nID%d", arrFires[n][fire_iHealth], MAX_FIRE_HEALTH, n);
						UpdateDynamic3DTextLabelText(arrFires[n][fire_iTextID], 0xFFFFFFFF, szMiscArray);

						if(arrFires[n][fire_iHealth] <=0) {

							DeleteStructureFire(n);
						}
					}
				}
			}
		}
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 407 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 601) {

			new n;
			for(n = 0; n < MAX_FIRES; n++) {

				if(IsValidStructureFire(n)) {

					if(IsPlayerAimingAt(playerid, arrFires[n][fire_fPos][0], arrFires[n][fire_fPos][1], arrFires[n][fire_fPos][2], 3) \
					&& IsPlayerInRangeOfPoint(playerid, 20, arrFires[n][fire_fPos][0], arrFires[n][fire_fPos][1], arrFires[n][fire_fPos][2])) {

						arrFires[n][fire_iHealth] -=5;
						format(szMiscArray, sizeof(szMiscArray), "%d/%d\nID%d", arrFires[n][fire_iHealth], MAX_FIRE_HEALTH, n);
						UpdateDynamic3DTextLabelText(arrFires[n][fire_iTextID], 0xFFFFFFFF, szMiscArray);
						if(arrFires[n][fire_iHealth] <=0)
						{
							DeleteStructureFire(n);
						}
					}
				}
			}
		}
	}
	return 1;
}

hook OnPlayerEnterDynamicArea(playerid, areaid) {

	new i = Streamer_GetIntData(STREAMER_TYPE_AREA, areaid, E_STREAMER_EXTRA_ID);
	if(0 <= i < MAX_FIRES) {
		if(arrFires[i][fire_iAreaID] == areaid) OnEnterFire(playerid, i);
	}
	return 1;
}

hook OnPlayerLeaveDynamicArea(playerid, areaid) {

	new i = Streamer_GetIntData(STREAMER_TYPE_AREA, areaid, E_STREAMER_EXTRA_ID);
	if(0 <= i < MAX_FIRES) {
		if(arrFires[i][fire_iAreaID] == areaid) DeletePVar(playerid, "pInFire");
	}
	return 1;
}

forward OnEnterFire(i, fireid);
public OnEnterFire(i, fireid) {

	new
		Float:oX, Float:oY, Float:oZ;
		
	if(GetPVarType(i, "pGodMode")) return 1;
	if(IsValidStructureFire(fireid)) {

		if(!GetPVarType(i, "pInFire")) SetTimerEx("Fire_HealthTimer", 1000, false, "i", i);
		SetPVarInt(i, "pInFire", 1);
	}
	return 1;
}

forward Fire_HealthTimer(playerid);
public Fire_HealthTimer(playerid) {

	new Float:ftempHP;
	GetHealth(playerid, ftempHP);
	if(GetPlayerSkin(playerid) == 277 || GetPlayerSkin(playerid) == 278 || GetPlayerSkin(playerid) == 279) SetHealth(playerid, ftempHP - 5);
	else SetHealth(playerid, ftempHP - 20);

	if(GetPVarType(playerid, "pInFire")) SetTimerEx("Fire_HealthTimer", 1000, false, "i", playerid);
	return 1;
}

CMD:fires(playerid, params[]) {

	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1 && PlayerInfo[playerid][pGangModerator] < 1 && PlayerInfo[playerid][pFactionModerator] < 1) return 1;
	if(GetPVarInt(playerid, "FireStart") != 1) {

		SetPVarInt(playerid, "FireStart", 1);
		SendClientMessageEx(playerid, COLOR_GREY, "You are now in fire creation mode");
		SendClientMessageEx(playerid, COLOR_GREY, "Please use a weapon and shoot whereever you wish to create a fire");
	}
	else {

		SendClientMessageEx(playerid, COLOR_GREY, "You have exited fire creation mode and are no longer able to create fires");
		DeletePVar(playerid, "FireStart");
	}
	return 1;
}

CMD:destroyfire(playerid, params[]) {

	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1 && PlayerInfo[playerid][pGangModerator] < 1 && PlayerInfo[playerid][pFactionModerator] < 1) return 1;
	new fire;
	if(sscanf(params, "d", fire)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /destroyfire [fireid]");
	if(!(0 <= fire <= MAX_FIRES)) return SendClientMessageEx(playerid, COLOR_GREY, "Invalid Fire ID!");
	DeleteStructureFire(fire);
	return 1;
}

CMD:destroyfires(playerid, params[]) {

	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1 && PlayerInfo[playerid][pGangModerator] < 2 && PlayerInfo[playerid][pFactionModerator] < 2) return 1;
	for(new i; i < MAX_FIRES; i++) {

		DeleteStructureFire(i);
	}
	SendClientMessageEx(playerid, COLOR_GRAD1, "You removed all the server's fires.");
	return 1;
}

CMD:gotofire(playerid, params[]) {

	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1 && PlayerInfo[playerid][pGangModerator] < 1 && PlayerInfo[playerid][pFactionModerator] < 1) return 1;
	new fire,
		Float:fPos[3];
	if(sscanf(params, "d", fire)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /gotofire [fireid]");
	if(!(0 <= fire <= MAX_FIRES)) return SendClientMessageEx(playerid, COLOR_GREY, "Invalid Fire ID!");
	if(!IsValidStructureFire(fire)) return SendClientMessageEx(playerid, COLOR_GREY, "Fire has not been created!");
	GetDynamicObjectPos(arrFires[fire][fire_iObjectID], fPos[0], fPos[1], fPos[2]);
	SetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]);
	return 1;
}

CMD:setfstrength(playerid, params[]) {

	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1 && PlayerInfo[playerid][pGangModerator] < 1 && PlayerInfo[playerid][pFactionModerator] < 1) return 1;
	new fire, strength;
	if(sscanf(params, "dd", fire, strength)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /setfstrength [fireid] [strength]");
	if(!(0 <= fire <= MAX_FIRES)) return SendClientMessageEx(playerid, COLOR_GREY, "Invalid Fire ID!");
	if(!IsValidStructureFire(fire)) return SendClientMessageEx(playerid, COLOR_GREY, "Fire has not been created!");
	arrFires[fire][fire_iHealth] = strength;
	return 1;
}

CMD:viewfires(playerid, params[]) {

	if(!IsAdminLevel(playerid, ADMIN_GENERAL, 1)) return 1;

	new x,
		szLocation[MAX_ZONE_NAME];

	szMiscArray[0] = 0;
	for(new i; i < iServerFires; ++i) {

		if(IsValidDynamicObject(arrFires[i][fire_iObjectID])) {
			
			Get3DZone(arrFires[i][fire_fPos][0], arrFires[i][fire_fPos][1], arrFires[i][fire_fPos][2], szLocation, sizeof(szLocation));
			format(szMiscArray, sizeof(szMiscArray), "%s\nFire %d | Strength: %d | Type: %s | Location: %s", szMiscArray,
				i, arrFires[i][fire_iHealth], GetFireType(arrFires[i][fire_iTypeID]), szLocation);
			ListItemTrackId[playerid][x] = i;
			x++;
		}
	}
	if(!x) SendClientMessageEx(playerid, COLOR_GRAD1, "There are no fires.");
	else ShowPlayerDialogEx(playerid, DIALOG_FIRES, DIALOG_STYLE_LIST, "Fires", szMiscArray, "Teleport", "Cancel");
	return 1;
}