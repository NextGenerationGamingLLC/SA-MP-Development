/*
	Shipment System by Dom 
*/

#include <YSI\y_hooks>

#define MAX_SHIPMENT_POINTS		4
new SHIPMENT_MATS_NEEDED = 60;

#define SHIPMENT_TYPE_ARMS 		1
#define SHIPMENT_TYPE_DRUGS		2

enum eGangShipmentData {
	gs_iStock = 0,
	gs_iVehicle = INVALID_VEHICLE_ID
}

new arrGangShipmentData[MAX_SHIPMENT_POINTS][eGangShipmentData];

new Float:arrShipPositions[2][3] = {
	{-1450.52, 1506.85, 0.0}, // large container ship with stairs
	{-2329.41, 1524.87, 0.75} // container ship nearer to Gant Bridge 
};

new Float:arrDeliverPositions[MAX_SHIPMENT_POINTS][3] = {
	{-2686.3425,-2196.2932,-0.7420}, // Whetstone - Chilliad Beach
	{-1722.5935,230.6965,-0.6083}, // SF Docks
	{1490.8795,-2782.3191,-0.5242}, // LSI Beach
	{2960.0776,-538.0289,-0.0771} // east beach 
};

new Float:arrShipmentTrucks[MAX_SHIPMENT_POINTS][3] = {
	{-2650.3557,-2260.4309,6.7077},  // Whetstone - Chilliad Beach
	{-1725.7112,219.3324,3.6448}, // SF Docks
	{1491.5762,-2759.0896,4.0944}, // LSI Beach
	{2912.3601,-554.3483,11.1824} // east beach 
};

CMD:gshipmentstocks(playerid, params[]) {
	if(PlayerInfo[playerid][pAdmin] < 3) return SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use this command.");

	szMiscArray[0] = 0; 
	format(szMiscArray, sizeof(szMiscArray), "Stock needed: %d", SHIPMENT_MATS_NEEDED);
	SendClientMessage(playerid, COLOR_WHITE, szMiscArray);
	for(new i = 0; i < MAX_SHIPMENT_POINTS; i++) {
		format(szMiscArray, sizeof(szMiscArray), "%s: %i", GetStockPointName(i), arrGangShipmentData[i][gs_iStock]);
		SendClientMessage(playerid, COLOR_WHITE, szMiscArray);
	}

	return 1;
}

LoadShipment(playerid) {
	
	SetPVarInt(playerid, "LoadShipmentTime", 5);
	TogglePlayerControllable(playerid, 0);
	SetPVarInt(playerid, "IsFrozen", 1);
	SetTimerEx("OnLoadShipment", 1000, false, "i", playerid);
	return 1;
}

DeliverShipment(playerid, iShipmentPoint) {
	
	arrGangShipmentData[iShipmentPoint][gs_iStock]++;

	new 
		iShipmentType = ReturnShipmentType(iShipmentPoint);

	szMiscArray[0] = 0;

	GivePlayerCash(playerid, 20000);
	SendClientMessage(playerid, COLOR_WHITE, "You have been given $20,000 for completing your assigned delivery.");

	DeletePVar(playerid, "DeliveringShipment");
	DeletePVar(playerid, "ShipmentCallActive");

	ClearCheckpoint(playerid);

	if(arrGangShipmentData[iShipmentPoint][gs_iStock] >= SHIPMENT_MATS_NEEDED) {
		arrGangShipmentData[iShipmentPoint][gs_iVehicle] = CreateVehicle(482, arrShipmentTrucks[iShipmentPoint][0], arrShipmentTrucks[iShipmentPoint][1], arrShipmentTrucks[iShipmentPoint][2], 0, random(128), random(128), 60 * 5);
		arrGangShipmentData[iShipmentPoint][gs_iStock] -= SHIPMENT_MATS_NEEDED;
		foreach(new i : Player) {
			if((0 <= PlayerInfo[i][pMember] < MAX_GROUPS) && arrGroupData[PlayerInfo[i][pMember]][g_iCrimeType] == iShipmentType) {
				format(szMiscArray, sizeof(szMiscArray), "{FF0000}Alert: {FFFFFF}An unknown shipment has been delivered to %s", GetStockPointName(iShipmentPoint));
				SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
			}
		}
	}
	g_mysql_SaveMOTD();
	return 1;
}	

GenerateShipmentStock(iGroupID, iShipmentType) {

	switch(iShipmentType) {

		case SHIPMENT_TYPE_ARMS: {
			
			switch(random(4)) {
				case 0: {
					for(new i = 0; i < 5; i++) AddGroupSafeWeapon(INVALID_PLAYER_ID, iGroupID, WEAPON_SILENCED); // 5 sdpistol 
					for(new i = 0; i < 20; i++) AddGroupSafeWeapon(INVALID_PLAYER_ID, iGroupID, WEAPON_DEAGLE); // 20 deagles
					for(new i = 0; i < 5; i++) AddGroupSafeWeapon(INVALID_PLAYER_ID, iGroupID, WEAPON_SHOTGUN); // 5 pump action shotguns
					for(new i = 0; i < 6; i++) AddGroupSafeWeapon(INVALID_PLAYER_ID, iGroupID, WEAPON_AK47); // 6 aks
					for(new i = 0; i < 3; i++) AddGroupSafeWeapon(INVALID_PLAYER_ID, iGroupID, WEAPON_M4); // 3 m4s
					for(new i = 0; i < 3; i++) AddGroupSafeWeapon(INVALID_PLAYER_ID, iGroupID, WEAPON_SHOTGSPA); // 3 spas-12s
				} 
				case 1: {
					for(new i = 0; i < 7; i++) AddGroupSafeWeapon(INVALID_PLAYER_ID, iGroupID, WEAPON_COLT45); // 7 colt 45
					for(new i = 0; i < 8; i++) AddGroupSafeWeapon(INVALID_PLAYER_ID, iGroupID, WEAPON_DEAGLE); // 8 deagles
					for(new i = 0; i < 4; i++) AddGroupSafeWeapon(INVALID_PLAYER_ID, iGroupID, WEAPON_SHOTGUN); // 4 pump action shotgun
					for(new i = 0; i < 8; i++) AddGroupSafeWeapon(INVALID_PLAYER_ID, iGroupID, WEAPON_UZI); // 8 UZI
					for(new i = 0; i < 4; i++) AddGroupSafeWeapon(INVALID_PLAYER_ID, iGroupID, WEAPON_AK47); // 4 ak47s
					for(new i = 0; i < 4; i++) AddGroupSafeWeapon(INVALID_PLAYER_ID, iGroupID, WEAPON_SNIPER); // 4 snipe rifles
				}
				case 2: {
					for(new i = 0; i < 7; i++) AddGroupSafeWeapon(INVALID_PLAYER_ID, iGroupID, WEAPON_SILENCED); // 7 sd pistol
					for(new i = 0; i < 9; i++) AddGroupSafeWeapon(INVALID_PLAYER_ID, iGroupID, WEAPON_DEAGLE); // 9 deagles
					for(new i = 0; i < 4; i++) AddGroupSafeWeapon(INVALID_PLAYER_ID, iGroupID, WEAPON_SHOTGUN); // 4 pump action shotty
					for(new i = 0; i < 8; i++) AddGroupSafeWeapon(INVALID_PLAYER_ID, iGroupID, WEAPON_TEC9); // 8 UZI
					for(new i = 0; i < 4; i++) AddGroupSafeWeapon(INVALID_PLAYER_ID, iGroupID, WEAPON_AK47); // 4 ak47s
					for(new i = 0; i < 1; i++) AddGroupSafeWeapon(INVALID_PLAYER_ID, iGroupID, WEAPON_SNIPER); // 1 sniper rifles
				}
				case 3: {
					for(new i = 0; i < 3; i++) AddGroupSafeWeapon(INVALID_PLAYER_ID, iGroupID, WEAPON_MP5); // 3 MP5s
					for(new i = 0; i < 8; i++) AddGroupSafeWeapon(INVALID_PLAYER_ID, iGroupID, WEAPON_DEAGLE); // 8 deagles
					for(new i = 0; i < 3; i++) AddGroupSafeWeapon(INVALID_PLAYER_ID, iGroupID, WEAPON_M4); // 3 m4s
					for(new i = 0; i < 3; i++) AddGroupSafeWeapon(INVALID_PLAYER_ID, iGroupID, WEAPON_RIFLE); // 3 rifles
					for(new i = 0; i < 4; i++) AddGroupSafeWeapon(INVALID_PLAYER_ID, iGroupID, WEAPON_SHOTGSPA); // 4 spas 12s
					for(new i = 0; i < 3; i++) AddGroupSafeWeapon(INVALID_PLAYER_ID, iGroupID, WEAPON_SAWEDOFF); // 3 sawnoffs	
				}
			}
			if(arrGroupData[iGroupID][g_iAmmo][0] + 3000 <= 10000) arrGroupData[iGroupID][g_iAmmo][0] += 3000; else arrGroupData[iGroupID][g_iAmmo][0] += (10000 - arrGroupData[iGroupID][g_iAmmo][0]);
			if(arrGroupData[iGroupID][g_iAmmo][1] + 3000 <= 10000) arrGroupData[iGroupID][g_iAmmo][1] += 3000; else arrGroupData[iGroupID][g_iAmmo][1] += (10000 - arrGroupData[iGroupID][g_iAmmo][1]);
			if(arrGroupData[iGroupID][g_iAmmo][2] + 3000 <= 10000) arrGroupData[iGroupID][g_iAmmo][2] += 3000; else arrGroupData[iGroupID][g_iAmmo][2] += (10000 - arrGroupData[iGroupID][g_iAmmo][2]);
			if(arrGroupData[iGroupID][g_iAmmo][3] + 3000 <= 10000) arrGroupData[iGroupID][g_iAmmo][3] += 3000; else arrGroupData[iGroupID][g_iAmmo][3] += (10000 - arrGroupData[iGroupID][g_iAmmo][3]);
			if(arrGroupData[iGroupID][g_iAmmo][4] + 3000 <= 10000) arrGroupData[iGroupID][g_iAmmo][4] += 3000; else arrGroupData[iGroupID][g_iAmmo][4] += (10000 - arrGroupData[iGroupID][g_iAmmo][4]);
		}

		case SHIPMENT_TYPE_DRUGS: {
			
			arrGroupData[iGroupID][g_iCrack] += Random(200, 600);
			arrGroupData[iGroupID][g_iPot] += Random(250, 700);
			arrGroupData[iGroupID][g_iHeroin] += Random(250, 650);
		}
	}

	return 1;
}

ReturnShipmentType(iShipmentPoint) {
	
	switch(iShipmentPoint) {
		case 0, 1: return SHIPMENT_TYPE_ARMS;
		case 2, 3: return SHIPMENT_TYPE_DRUGS;
	}
	return -1;
}

GetStockPointName(iShipmentPoint) {
	
	new szReturn[20];
	switch(iShipmentPoint) {
		case 0: szReturn = "Whetstone Beach";
		case 1: szReturn = "San Fierro Docks";
		case 2: szReturn = "Los Santos Airport";
		case 3: szReturn = "East Beach";
	}
	return szReturn;
}


IsAGangShipmentTruck(iCarID) {
	
	for(new v = 0; v < MAX_SHIPMENT_POINTS; v++) {
	    if(iCarID == arrGangShipmentData[v][gs_iVehicle]) return 1;
	}
	return 0;
}
 
forward ShipmentConvo(playerid, iStage);
public ShipmentConvo(playerid, iStage) {
	
	switch(iStage) {
		case 1: {
			SendClientMessageEx(playerid, COLOR_YELLOW, "(cellphone) Unknown Caller says: Ayo ese I've got a job for ya.");
			SetTimerEx("ShipmentConvo", 3000, false, "ii", playerid, 2);
		}

		case 2: {
			SendClientMessageEx(playerid, COLOR_YELLOW, "(cellphone) Unknown Caller says: I need an overseas shipment taken care of homie.");
			SendClientMessageEx(playerid, COLOR_YELLOW, "(cellphone) Unknown Caller says: Can I trust you with my shit?");
			SetTimerEx("ShipmentConvo", 5000, false, "ii", playerid, 3);
		}

		case 3: {
			SendClientMessageEx(playerid, COLOR_YELLOW, "(cellphone) Unknown Caller says: I'm sending you the coordinates right now.");
			SendClientMessageEx(playerid, COLOR_YELLOW, "(cellphone) Unknown Caller says: Get a boat and head over there ASAP!");
			SendClientMessageEx(playerid,  COLOR_GRAD2, "   They hung up.");


			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Get a boat and head to the location marked on your minimap.");

			new rand = random(2);

			SetPlayerCheckpoint(playerid, arrShipPositions[rand][0], arrShipPositions[rand][1], arrShipPositions[rand][2], 4);
			gPlayerCheckpointStatus[playerid] = CHECKPOINT_LOADSHIPMENT;
		}

	}

	return 1;
}

forward OnLoadShipment(playerid);
public OnLoadShipment(playerid) {
	
	new iLoadTime = GetPVarInt(playerid, "LoadShipmentTime"); 

	szMiscArray[0] = 0;
	SetPVarInt(playerid, "LoadShipmentTime", iLoadTime - 1);

	format(szMiscArray, sizeof(szMiscArray), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~%d seconds left", iLoadTime - 1);
	GameTextForPlayer(playerid, szMiscArray, 1100, 3);

	if(iLoadTime > 0) return SetTimerEx("OnLoadShipment", 1000, false, "i", playerid);

	new rand = random(4);
	SetPlayerCheckpoint(playerid, arrDeliverPositions[rand][0], arrDeliverPositions[rand][1], arrDeliverPositions[rand][2], 4);
	SetPVarInt(playerid, "DeliveringShipment", 1);
	gPlayerCheckpointStatus[playerid] = CHECKPOINT_DELIVERSHIPMENT;

	SendClientMessageEx(playerid, COLOR_YELLOW, "Follow your way to the marker to deliver your shipment.");

	DeletePVar(playerid, "LoadShipmentTime");
	DeletePVar(playerid, "IsFrozen");
	TogglePlayerControllable(playerid, 1);

	return 1;
}

hook OnPlayerEnterCheckpoint(playerid) {
	
	switch(gPlayerCheckpointStatus[playerid]) {
		case CHECKPOINT_LOADSHIPMENT: {
			if(IsABoat(GetPlayerVehicleID(playerid))) {
				if(GetPVarType(playerid, "ShipmentCallActive") == 1) {
					for(new i = 0; i < MAX_SHIPMENT_POINTS; i++) {
						if(IsPlayerInRangeOfPoint(playerid, 5.0, arrShipPositions[i][0], arrShipPositions[i][1], arrShipPositions[i][2]))
							return LoadShipment(playerid);
					}
				}
			}
			else SendClientMessageEx(playerid, COLOR_WHITE, "You must be in a boat");
		}
		
		case CHECKPOINT_DELIVERSHIPMENT: {
			
			if(IsABoat(GetPlayerVehicleID(playerid))) {
				if(GetPVarType(playerid, "DeliveringShipment") == 1) {
					for(new i = 0; i < MAX_SHIPMENT_POINTS; i++) {
						if(IsPlayerInRangeOfPoint(playerid, 5.0, arrDeliverPositions[i][0], arrDeliverPositions[i][1], arrDeliverPositions[i][2]))
							return DeliverShipment(playerid, i);
					}
				}
			}
			else SendClientMessageEx(playerid, COLOR_WHITE, "You must be in a boat");
		}
	}
	return 1;
}

CMD:delivershipment(playerid, params[]) {
	
	new iVehID = GetPlayerVehicleID(playerid);
	new iGroupID = PlayerInfo[playerid][pMember];
	szMiscArray[0] = 0;
	if(!IsACriminal(playerid)) return SendClientMessageEx(playerid, COLOR_WHITE, "You are not in a criminal organization.");
	if(!IsAGangShipmentTruck(iVehID)) return SendClientMessageEx(playerid, COLOR_WHITE, "You are not in a shipment truck!");
	if(IsPlayerInRangeOfPoint(playerid, 5.0, arrGroupData[iGroupID][g_fCratePos][0], arrGroupData[iGroupID][g_fCratePos][1], arrGroupData[iGroupID][g_fCratePos][2])) {
		
		for(new v = 0; v < MAX_SHIPMENT_POINTS; v++) 	{
	   		if(iVehID == arrGangShipmentData[v][gs_iVehicle]) {
	   			new iShipmentType = ReturnShipmentType(v);
	   			if(iShipmentType == arrGroupData[iGroupID][g_iCrimeType]) {
					RemovePlayerFromVehicle(playerid);
	   				GenerateShipmentStock(iGroupID, iShipmentType);
	   				DestroyVehicle(iVehID);
					arrGangShipmentData[v][gs_iVehicle] = INVALID_VEHICLE_ID;
	   				SendClientMessageEx(playerid, COLOR_WHITE, "You have delivered your shipment to your group.");
	   				format(szMiscArray, sizeof(szMiscArray), "%s has delivered a shipment.", GetPlayerNameEx(playerid));
	   				GroupLog(iGroupID, szMiscArray);
	   				break; 
	   			}
	   		}
	   	}	
	}
	return 1;
}

CMD:editshipment(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 99999) return SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use this command.");
	new val;
	if(sscanf(params, "d", val) || val <= 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "USAGE: /editshipment [value]");
	format(szMiscArray, sizeof(szMiscArray), "You have edited the mats needed for gang shipments to: %d (Previously: %d)", val, SHIPMENT_MATS_NEEDED);
	SendClientMessageEx(playerid, COLOR_GRAD2, szMiscArray);
	format(szMiscArray, sizeof(szMiscArray), "%s has edited the mats needed for gang shipments to: %d (Previously: %d)", val, SHIPMENT_MATS_NEEDED);
	Log("logs/admin.log", szMiscArray);
	SHIPMENT_MATS_NEEDED = val;
	g_mysql_SaveMOTD();
	return 1;
}

forward LoadGangShipmentData(i);
public LoadGangShipmentData(i)
{
	szMiscArray[0] = 0;
	for(new j = 0; j != MAX_SHIPMENT_POINTS; j++)
	{
		format(szMiscArray, sizeof(szMiscArray), "gs_iStock%d", j);
		arrGangShipmentData[j][gs_iStock] = cache_get_field_content_int(i, szMiscArray, MainPipeline);
	}
	SHIPMENT_MATS_NEEDED = cache_get_field_content_int(i, "SHIPMENT_MATS_NEEDED", MainPipeline);
}

forward SaveGangShipmentData(size, query[]);
public SaveGangShipmentData(size, query[])
{
	szMiscArray[0] = 0;
	for(new j = 0; j != MAX_SHIPMENT_POINTS; j++)
		format(szMiscArray, sizeof(szMiscArray), "%s`gs_iStock%d` = '%d', ", szMiscArray, j, arrGangShipmentData[j][gs_iStock]);
	format(query, size, "%s, %s `SHIPMENT_MATS_NEEDED` = '%d',", query, szMiscArray, SHIPMENT_MATS_NEEDED);
}