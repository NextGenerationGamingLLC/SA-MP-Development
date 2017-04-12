/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

				Next Generation Gaming, LLC
	(created by Next Generation Gaming Development Team)

	Developers:
		- Dom
		- Jingles
		- Miguel
		
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

#define GANG_CRATE_COST 150000

#define MAX_CRATE_GUNS 30
#define MAX_CRATE_DRUGS 200
#define MAX_GANG_SIMUL_CRATES 2


CreateGCrate(playerid, iGroupID) {
	
	szMiscArray[0] = 0;

	for(new i = 0; i < MAX_GANG_CRATES; ++i) {
		if(arrGCrateData[i][gcr_isLoaded] == 0) {
			format(szMiscArray, sizeof(szMiscArray), "UPDATE `gCrates` SET `iGroupID` = %d, `9mm` = '0', `sdpistol` = '0', `deagle` = '0', `uzi` = '0', `tec9` = '0', \
				`mp5` = '0', `m4` = '0', `ak47` = '0', `rifle` = '0', `sniper` = '0', `shotty` = '0', `sawnoff` = '0', `spas` = '0', \
				`pot` = '0', `crack` = '0', `meth` = '0', `ecstasy` = '0', `heroin` = '0' WHERE `iCrateID` = %d", iGroupID, i+1);
			return mysql_tquery(MainPipeline, szMiscArray, true, "OnCreateGCrate", "iii", playerid, iGroupID, i);
		}
	}
	SendClientMessageEx(playerid, COLOR_GRAD1, "There are no more crate slots available. Please try again at a later moment.");
	return 1;
}

forward OnCheckGCrates(playerid, iGroupID);
public OnCheckGCrates(playerid, iGroupID) {

	if(cache_get_row_count() == MAX_GANG_SIMUL_CRATES) return SendClientMessageEx(playerid, COLOR_WHITE, "You have reached the maximum of 2 unprocessed gang crates.");
	else CreateGCrate(playerid, iGroupID);
	return 1;
}

forward OnCreateGCrate(playerid, iGroupID, iCrateID);
public OnCreateGCrate(playerid, iGroupID, iCrateID) {

	new
		Float:fTemp[3],
		iVW,
		iInt;
	szMiscArray[0] = 0;
	
	// log the crate purchase
	format(szMiscArray, sizeof(szMiscArray), "[GANG CRATE] [Gang: %s (ID: %i)] [Name: %s]", arrGroupData[iGroupID][g_szGroupName], iGroupID, GetPlayerNameEx(playerid));
	Log("logs/gangcrates.log", szMiscArray);
	
	GetPlayerPos(playerid, fTemp[0], fTemp[1], fTemp[2]);
	iVW = GetPlayerVirtualWorld(playerid);
	iInt = GetPlayerInterior(playerid);

	arrGCrateData[iCrateID][gcr_iObject] = CreateDynamicObject(964, fTemp[0], fTemp[1], fTemp[2]-0.95, 0,0,0, .worldid = iVW, .interiorid = iInt);
	
	format(szMiscArray, sizeof(szMiscArray), "Gang Crate ID: %d\nDropped by: %s\n%s", iCrateID, GetPlayerNameEx(playerid), arrGroupData[iGroupID][g_szGroupName]);
	arrGCrateData[iCrateID][gcr_iLabel] = CreateDynamic3DTextLabel(szMiscArray, COLOR_GREEN, fTemp[0], fTemp[1], fTemp[2], 5.0, _, _, 1, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), _, 20.0);
	arrGroupData[iGroupID][g_iBudget] -= GANG_CRATE_COST;
	arrGCrateData[iCrateID][gcr_isLoaded] = 1;
	return 1;
}

DeleteGCrate(playerid, iCrateID) {
	format(szMiscArray, sizeof(szMiscArray), "UPDATE `gCrates` SET `iGroupID` = '255' WHERE `iCrateID` = %i", iCrateID+1);
	return mysql_tquery(MainPipeline, szMiscArray, false, "OnDeleteGCrate", "ii", playerid, iCrateID);
}

forward OnDeleteGCrate(playerid, iCrateID);
public OnDeleteGCrate(playerid, iCrateID)
{
	if(IsValidDynamicObject(arrGCrateData[iCrateID][gcr_iObject]))
		DestroyDynamicObject(arrGCrateData[iCrateID][gcr_iObject]);
	if(IsValidDynamic3DTextLabel(arrGCrateData[iCrateID][gcr_iLabel]))
		DestroyDynamic3DTextLabel(arrGCrateData[iCrateID][gcr_iLabel]);

	arrGCrateData[iCrateID][gcr_iObject] = INVALID_OBJECT_ID;
	arrGCrateData[iCrateID][gcr_iLabel] = Text3D:-1;
	arrGCrateData[iCrateID][gcr_isLoaded] = 0;
	//format(szMiscArray, sizeof szMiscArray, "You have successfully destroyed gang crate ID %i.", iCrateID);
	//SendClientMessageEx(playerid, COLOR_GRAD1, szMiscArray);
	return 1;
}

LoadGCrates() {
	format(szMiscArray, sizeof(szMiscArray), "SELECT * FROM `gCrates`");
	return mysql_tquery(MainPipeline, szMiscArray, true, "OnLoadGCrates", "");
}

forward OnLoadGCrates();
public OnLoadGCrates() {
	new
		iFields,
		iRows,
		iCount,
		iGroupID,
		iCrateID;

	cache_get_data(iRows, iFields, MainPipeline);
	while(iCount < iRows) {

		iGroupID = cache_get_field_content_int(iCount, "iGroupID", MainPipeline);
		if(!(0 <= iGroupID < MAX_GROUPS)) break;
		iCrateID = cache_get_field_content_int(iCount, "iCrateID", MainPipeline);
		iCrateID--; // Mysql starts at 1. Have the game's idx start at 0.
		SpawnGCrateAtGroup(iGroupID, iCrateID);
		iCount++;
	}
	printf("[Gang Crates] Loaded %i Gang Crates", iCount);
	return 1;
}


SaveGCrate(iCrateID, iGroupID) {
	format(szMiscArray, sizeof(szMiscArray), "UPDATE `gCrates` SET `iGroupID` = %d WHERE `iCrateID` = %d", iGroupID, iCrateID+1);
	mysql_tquery(MainPipeline, szMiscArray, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	return 1;
}


ShowGCrateItems(iPlayerID, iCrateID, itemid = -1) {

	szMiscArray[0] = 0;
	
	format(szMiscArray, sizeof(szMiscArray), "SELECT * FROM `gCrates` WHERE `iCrateID` = '%d' LIMIT 1", iCrateID+1);
	return mysql_tquery(MainPipeline, szMiscArray, true, "OnShowGCrateItems", "iii", iPlayerID, iCrateID, itemid);
}

forward OnShowGCrateItems(iPlayerID, iCrateID, itemid);
public OnShowGCrateItems(iPlayerID, iCrateID, itemid) {

	szMiscArray[0] = 0;

	new 
		iRows,
		iFields, 
		iCount;

	cache_get_data(iRows, iFields, MainPipeline);
	
	while(iCount < iRows) {
		
		szMiscArray[3999] 	= 	cache_get_field_content_int(iCount, "iCrateID", MainPipeline);
		szMiscArray[4000] 	= 	cache_get_field_content_int(iCount, "iGroupID", MainPipeline);
		szMiscArray[4001] 	= 	cache_get_field_content_int(iCount, "9mm", MainPipeline);
		szMiscArray[4002] 	= 	cache_get_field_content_int(iCount, "sdpistol", MainPipeline);
		szMiscArray[4003] 	= 	cache_get_field_content_int(iCount, "deagle", MainPipeline);
		szMiscArray[4004] 	= 	cache_get_field_content_int(iCount, "uzi", MainPipeline);
		szMiscArray[4005] 	= 	cache_get_field_content_int(iCount, "tec9", MainPipeline);
		szMiscArray[4006] 	= 	cache_get_field_content_int(iCount, "mp5", MainPipeline);
		szMiscArray[4007] 	= 	cache_get_field_content_int(iCount, "m4", MainPipeline);
		szMiscArray[4008] 	= 	cache_get_field_content_int(iCount, "ak47", MainPipeline);
		szMiscArray[4009] 	= 	cache_get_field_content_int(iCount, "rifle", MainPipeline);
		szMiscArray[4010] 	= 	cache_get_field_content_int(iCount, "sniper", MainPipeline);
		szMiscArray[4011] 	= 	cache_get_field_content_int(iCount, "shotty", MainPipeline);
		szMiscArray[4012] 	= 	cache_get_field_content_int(iCount, "sawnoff", MainPipeline);
		szMiscArray[4013] 	= 	cache_get_field_content_int(iCount, "spas", MainPipeline);
		szMiscArray[4014] 	= 	cache_get_field_content_int(iCount, "pot", MainPipeline);
		szMiscArray[4015] 	= 	cache_get_field_content_int(iCount, "crack", MainPipeline);
		szMiscArray[4016] 	= 	cache_get_field_content_int(iCount, "meth", MainPipeline);
		szMiscArray[4017] 	= 	cache_get_field_content_int(iCount, "ecstasy", MainPipeline);
		szMiscArray[4018] 	= 	cache_get_field_content_int(iCount, "heroin", MainPipeline);
		iCount++;
	}
	if(PlayerInfo[iPlayerID][pMember] != szMiscArray[4000]) return SendClientMessageEx(iPlayerID, COLOR_GRAD2, "This crate does not belong to your group.");
	if(itemid != -1) {

		return szMiscArray[4000+itemid];
	}

	else if(itemid == -1) {
		format(szMiscArray, sizeof(szMiscArray), "Item\tAmount\n\
			9mm \t%d\n\
			Silenced 9mm\t%d\n\
			Desert Eagle\t%d\n\
			UZI\t%d\n\
			Tec-9\t%d\n\
			MP5\t%d\n\
			M4\t%d\n\
			AK47\t%d\n\
			Country Rifle\t%d\n\
			Sniper Rifle\t%d\n\
			Pump-Action Shotgun\t%d\n\
			Sawn-off Shotguns\t%d\n\
			Spas-12\t%d\n\
			Pot\t%d\n\
			Crack\t%d\n\
			Meth\t%d\n\
			Ecstasy\t%d\n\
			Heroin\t%d",
			szMiscArray[4001],
			szMiscArray[4002],
			szMiscArray[4003],
			szMiscArray[4004],
			szMiscArray[4005],
			szMiscArray[4006],
			szMiscArray[4007],
			szMiscArray[4008],
			szMiscArray[4009],
			szMiscArray[4010],
			szMiscArray[4011],
			szMiscArray[4012],
			szMiscArray[4013],
			szMiscArray[4014],
			szMiscArray[4015],
			szMiscArray[4016],
			szMiscArray[4017],
			szMiscArray[4018]
		);
		ShowPlayerDialogEx(iPlayerID, DIALOG_GANG_CRATE1, DIALOG_STYLE_TABLIST_HEADERS, "Gang Shipment Stock Preparation", szMiscArray, "Select", "Cancel");
		SetPVarInt(iPlayerID, "GCTransferTo", iCrateID);
	}

	return 1;
}

forward OnCheckGCrateItems(iPlayerID, iCrateID, itemid, szGCItem[], iAmount);
public OnCheckGCrateItems(iPlayerID, iCrateID, itemid, szGCItem[], iAmount) {

	new
		iRows, 
		iFields,
		iCount,
		iCurrentAmount;

	cache_get_data(iRows, iFields, MainPipeline);

	while(iCount < iRows) {
		iCurrentAmount = cache_get_field_content_int(iCount, szGCItem, MainPipeline);
		++iCount;
	}
	if(iAmount > iCurrentAmount)
	{
		return SendClientMessage(iPlayerID, COLOR_GRAD1, "You are trying to transfer more than there is!");
	}
	format(szMiscArray, sizeof(szMiscArray), "UPDATE `gCrates` SET `%s` = '%d' - '%d' WHERE `iCrateID` = '%d'",
		szGCItem,
		iCurrentAmount,
		iAmount, 
		iCrateID+1
	);
	mysql_tquery(MainPipeline, szMiscArray, true, "OnTransferItemFromCrate", "iiii", iPlayerID, itemid, iAmount, iCrateID);
	return 1;
}

/*
CountLockerGuns(iGroupID, iWeaponID) {

	szMiscArray[0] = 0;

	format(szMiscArray, sizeof(szMiscArray), "SELECT * FROM `gWeaponsNew` WHERE `Group_ID` = '%d' AND `Weapon_ID` = '%d'", iGroupID, iWeaponID);
	return mysql_tquery(MainPipeline, szMiscArray, true, "OnCountLockerGuns", "ii", iGroupID, iWeaponID);
}

forward OnCountLockerGuns(iGroupID, iWeaponID);
public OnCountLockerGuns(iGroupID, iWeaponID) {

	szMiscArray[0] = 0;

	new 
		iRows = cache_get_row_count();
	return iRows;
}*/

forward OnPlayerCountLockerGuns(iPlayerID, iGroupID, iWeaponID, iAmount, itemid, iCrateID);
public OnPlayerCountLockerGuns(iPlayerID, iGroupID, iWeaponID, iAmount, itemid, iCrateID) {


	szMiscArray[0] = 0;

	new iRows,
		iFields,
		tempWep[3],
		iCount;

	cache_get_data(iRows, iFields, MainPipeline);
	valstr(tempWep, iWeaponID);
	iCount = cache_get_field_content_int(0, tempWep, MainPipeline);
	if(iCount < iAmount) SendClientMessage(iPlayerID, COLOR_GRAD1, "You are trying to transfer more than there is!");
	else {
		
		format(szMiscArray, sizeof(szMiscArray), "SELECT `%s` FROM `gCrates` WHERE `iCrateID` = '%d'", GetGCItemSQLFldName(itemid), iCrateID+1);
		mysql_tquery(MainPipeline, szMiscArray, true, "OnTransferItemToCrate", "iiii", iPlayerID, itemid, iAmount, iCrateID);
	}
	return 1;
}

ShowGCrates(iPlayerID) {

	szMiscArray[0] = 0;
	
	format(szMiscArray, sizeof(szMiscArray), "SELECT * FROM `gCrates` WHERE `iGroupID` != 255");
	return mysql_tquery(MainPipeline, szMiscArray, true, "OnShowGCrates", "i", iPlayerID);
}

forward OnShowGCrates(iPlayerID);
public OnShowGCrates(iPlayerID) {

	szMiscArray[0] = 0;

	new 
		iRows,
		iFields, 
		iCount;

	cache_get_data(iRows, iFields, MainPipeline);
	if(!iRows) return SendClientMessageEx(iPlayerID, COLOR_WHITE, "There are no spawned gang crates.");
	while(iCount < iRows) {
		
		szMiscArray[3999] 	= 	cache_get_field_content_int(iCount, "iCrateID", MainPipeline);
		szMiscArray[4000] 	= 	cache_get_field_content_int(iCount, "iGroupID", MainPipeline);
		format(szMiscArray, sizeof(szMiscArray), "%s\n(ID: %i) %s",
			szMiscArray,
			szMiscArray[3999],
			arrGroupData[szMiscArray[4000]][g_szGroupName]
		);
		iCount++;
	}
	ShowPlayerDialogEx(iPlayerID, DIALOG_ADM_GCRATES, DIALOG_STYLE_LIST, "Gang Crates", szMiscArray, "Select", "Cancel");
	return 1;
}

GetItemNameFromIdx(itemid) {
	new szReturn[24];

	switch(itemid) {
		case 0: szReturn = "9mm";
		case 1: szReturn = "Silenced 9mm";
		case 2: szReturn = "Desert Eagle";
		case 3: szReturn = "UZI";
		case 4: szReturn = "Tec-9";
		case 5: szReturn = "MP5";
		case 6: szReturn = "M4";
		case 7: szReturn = "Ak-47";
		case 8: szReturn = "Country Rifle";
		case 9: szReturn = "Sniper Rifle";
		case 10: szReturn = "Pump-Action Shotgun";
		case 11: szReturn = "Sawn-Off Shotgun";
		case 12: szReturn = "Spas-12";
		case 13: szReturn = "Pot";
		case 14: szReturn = "Crack";
		case 15: szReturn = "Meth";
		case 16: szReturn = "Ecstasy";
		case 17: szReturn = "Heroin";
	}
	return szReturn;
}

GetGCItemSQLFldName(itemid) {
	new szReturn[24];
	switch(itemid) {

		case 0:  szReturn ="9mm";
		case 1:  szReturn ="sdpistol";
		case 2:  szReturn ="deagle";
		case 3:  szReturn ="uzi";
		case 4:  szReturn ="tec9";
		case 5:  szReturn ="mp5";
		case 6:  szReturn ="m4";
		case 7:  szReturn ="ak47";
		case 8:  szReturn ="rifle";
		case 9:  szReturn ="sniper";
		case 10: szReturn ="shotty";
		case 11: szReturn ="sawnoff";
		case 12: szReturn ="spas";
		case 13: szReturn ="pot";
		case 14: szReturn ="crack";
		case 15: szReturn ="meth";
		case 16: szReturn ="ecstasy";
		case 17: szReturn ="heroin";
	}
	return szReturn;
}

GetWepIDFromGCIdx(itemid) {

	switch(itemid) {
		case 0:  return WEAPON_COLT45;
		case 1:  return WEAPON_SILENCED;
		case 2:  return WEAPON_DEAGLE;
		case 3:  return WEAPON_UZI;
		case 4:  return WEAPON_TEC9;
		case 5:  return WEAPON_MP5;
		case 6:  return WEAPON_M4;
		case 7:  return WEAPON_AK47;
		case 8:  return WEAPON_RIFLE;
		case 9:  return WEAPON_SNIPER;
		case 10: return WEAPON_SHOTGUN;
		case 11: return WEAPON_SAWEDOFF;
		case 12: return WEAPON_SHOTGSPA;
		default: return 0;
	}
	return 0;
}

SpawnGCrateAtGroup(iGroupID, iCrateID) {
	
	szMiscArray[0] = 0;
	arrGCrateData[iCrateID][gcr_iObject] = CreateDynamicObject(964, arrGroupData[iGroupID][g_fCratePos][0], arrGroupData[iGroupID][g_fCratePos][1], arrGroupData[iGroupID][g_fCratePos][2]-0.95, 0.0, 0.0, 0.0);
	
	format(szMiscArray, sizeof(szMiscArray), "Gang Crate ID: %d\n%s", iCrateID, arrGroupData[iGroupID][g_szGroupName]);
	arrGCrateData[iCrateID][gcr_iLabel] = CreateDynamic3DTextLabel(szMiscArray, COLOR_GREEN, arrGroupData[iGroupID][g_fCratePos][0], arrGroupData[iGroupID][g_fCratePos][1], arrGroupData[iGroupID][g_fCratePos][2], 5.0);
	arrGCrateData[iCrateID][gcr_isLoaded] = 1;
	return 1;
}

IsPlayerNearGCrate(playerid, i) {

	new 
		Float:fTemp[3];

	if(IsValidDynamicObject(arrGCrateData[i][gcr_iObject])) {
		GetDynamicObjectPos(arrGCrateData[i][gcr_iObject], fTemp[0], fTemp[1], fTemp[2]);
		if(IsPlayerInRangeOfPoint(playerid, 6.0, fTemp[0], fTemp[1], fTemp[2])) {
			return 1;
		}
	}
	return 0;
}

/* 
	-->WITHDRAWING FROM LOCKER

	TransferItemToCrate

		-> Check if there is sufficient of the item in the locker before transfering. 
			-> Is it a weapon? 
				->Run query to remove from locker 
				->Run another query to increase crate quantity.
			-> Is it ammo or drugs?
				->Decrease var 
				->Run query to increase crate quantity. 

	->WITHDRAWING FROM CRATE (ShowGCrateItems)

	TransferItemFromCrate

		-> Is there sufficient of the item in the crate before transfering?
			->Is it a weapon?
				->Run query to remove from crate.
				->Use add locker weapon function.
			->Is it ammo or drugs?
				->Run query to remove from crate
				->Increase var 

*/

TransferItemFromCrate(playerid, itemid, iAmount, iCrateID) {
	new szGCItem[24];
	szGCItem = GetGCItemSQLFldName(itemid);

	format(szMiscArray, sizeof(szMiscArray), "SELECT `%s` FROM `gCrates` WHERE `iCrateID` = '%d'", szGCItem, iCrateID+1);
	mysql_tquery(MainPipeline, szMiscArray, true, "OnCheckGCrateItems", "iiisi", playerid, iCrateID, itemid, szGCItem, iAmount);
	return 1;
}


forward OnTransferItemFromCrate(playerid, itemid, iAmount, iCrateID);
public OnTransferItemFromCrate(playerid, itemid, iAmount,  iCrateID) {

	szMiscArray[0] = 0;

	new	iGroupID = PlayerInfo[playerid][pMember],
		iLoad = GetGVarInt("GCrateLoad", iCrateID);

	switch(itemid) {
		case 0 .. 12: {
			for(new i = 0; i < iAmount; i++) { 
				SetGVarInt("GCrateLoad", iLoad-1, iCrateID);
				AddGroupSafeWeapon(INVALID_PLAYER_ID, iGroupID, GetWepIDFromGCIdx(itemid)); 
			}
		}
		case 13: arrGroupData[iGroupID][g_iDrugs][0] += iAmount; // pot
		case 14: arrGroupData[iGroupID][g_iDrugs][1] += iAmount; // crack 	
		case 15: arrGroupData[iGroupID][g_iDrugs][2] += iAmount; // meth
		case 16: arrGroupData[iGroupID][g_iDrugs][3] += iAmount; // ecstasy
		case 17: arrGroupData[iGroupID][g_iDrugs][4] += iAmount; // heroin
	}
	return 1;
}

TransferItemToCrate(playerid, itemid, iAmount, iCrateID) {


	szMiscArray[0] = 0;

	new	iGroupID = PlayerInfo[playerid][pMember],
		iLoad = GetGVarInt("GCrateLoad", iCrateID);

	switch(itemid) {
		case 0 .. 12: {
			new 
				iWeaponID = GetWepIDFromGCIdx(itemid);

			if(iLoad +1 > MAX_CRATE_GUNS) return SendClientMessageEx(playerid, COLOR_GRAD2, "You cannot store anymore guns in this crate.");

			SetGVarInt("GCrateLoad", iLoad+1, iCrateID);
			format(szMiscArray, sizeof(szMiscArray), "SELECT `%d` FROM `gWeaponsNew` WHERE `Group_ID` = '%d'", iWeaponID, iGroupID+1);
			mysql_tquery(MainPipeline, szMiscArray, true, "OnPlayerCountLockerGuns", "iiiiii", playerid, iGroupID, iWeaponID, iAmount, itemid, iCrateID);
		}
		case 13: { // Pot
			if(0 < arrGroupData[iGroupID][g_iDrugs][0] < iAmount) return SendClientMessageEx(playerid, COLOR_GRAD2, "You are trying to transfer more than there is!");
		}
		case 14: { // Crack 
			if(0 < arrGroupData[iGroupID][g_iDrugs][1] < iAmount) return SendClientMessageEx(playerid, COLOR_GRAD2, "You are trying to transfer more than there is!");
		}
		case 15: { // Meth
			if(0 < arrGroupData[iGroupID][g_iDrugs][2] < iAmount) return SendClientMessageEx(playerid, COLOR_GRAD2, "You are trying to transfer more than there is!");
		}
		case 16: { // Ecstasy
			if(0 < arrGroupData[iGroupID][g_iDrugs][3] < iAmount) return SendClientMessageEx(playerid, COLOR_GRAD2, "You are trying to transfer more than there is!");
		}
		case 17: { // Heroin
			if(0 < arrGroupData[iGroupID][g_iDrugs][4] < iAmount) return SendClientMessageEx(playerid, COLOR_GRAD2, "You are trying to transfer more than there is!");
		}
	}

	if(itemid > 12) {

		format(szMiscArray, sizeof(szMiscArray), "SELECT `%s` FROM `gCrates` WHERE `iCrateID` = '%d'", GetGCItemSQLFldName(itemid), iCrateID+1);
		mysql_tquery(MainPipeline, szMiscArray, true, "OnTransferItemToCrate", "iiii", playerid, itemid, iAmount, iCrateID);
	}
	return 1;
}

forward OnTransferItemToCrate(playerid, itemid, iAmount, iCrateID);
public OnTransferItemToCrate(playerid, itemid, iAmount,  iCrateID) {

	szMiscArray[0] = 0;

	new 
		iRows,
		iFields,
		iCount,
		iTemp;

	cache_get_data(iRows, iFields, MainPipeline);

	szMiscArray = GetGCItemSQLFldName(itemid);

	while(iCount < iRows) {

		iTemp = cache_get_field_content_int(iCount, szMiscArray, MainPipeline);
		++iCount;
	}

	format(szMiscArray, sizeof(szMiscArray), "UPDATE `gCrates` SET `%s` = '%d' WHERE `iCrateID` = '%d'", szMiscArray, iTemp + iAmount, iCrateID+1);
	mysql_tquery(MainPipeline, szMiscArray, false, "OnFinalizeItemTransfer", "iiii", playerid, itemid, iAmount, iCrateID);
	return 1;
}

forward OnFinalizeItemTransfer(playerid, itemid, iAmount, iCrateID);
public OnFinalizeItemTransfer(playerid, itemid, iAmount, iCrateID) {

	new 
		iGroupID = PlayerInfo[playerid][pMember];

	switch(itemid) {
		case 0 .. 12: for(new i = 0; i < iAmount; i++) { WithdrawGroupSafeWeapon(INVALID_PLAYER_ID, iGroupID, GetWepIDFromGCIdx(itemid)); }
		case 13: arrGroupData[iGroupID][g_iDrugs][0] -= iAmount; // pot
		case 14: arrGroupData[iGroupID][g_iDrugs][1] -= iAmount; // crack 	
		case 15: arrGroupData[iGroupID][g_iDrugs][2] -= iAmount; // meth
		case 16: arrGroupData[iGroupID][g_iDrugs][3] -= iAmount; // ecstasy
		case 17: arrGroupData[iGroupID][g_iDrugs][4] -= iAmount; // heroin
			
	}
	return 1;
}

DeliverGCCrate(playerid, iGroupID, iCrateID) {

	szMiscArray[0] = 0;

	format(szMiscArray, sizeof(szMiscArray), "SELECT * FROM `gCrates` WHERE `iCrateID` = '%d'", iCrateID+1);
	mysql_tquery(MainPipeline, szMiscArray, true, "OnDeliverGCCrate", "iii", playerid, iGroupID, iCrateID);

	return 1;
}

forward OnDeliverGCCrate(playerid, iGroupID, iCrateID);
public OnDeliverGCCrate(playerid, iGroupID, iCrateID) {

	szMiscArray[0] = 0;

	new
		iRows, 
		iFields,
		iCount;

	cache_get_data(iRows, iFields, MainPipeline);

	while(iCount < iRows) {

		szMiscArray[4001] 	= 	cache_get_field_content_int(iCount, "9mm", MainPipeline);
		szMiscArray[4002] 	= 	cache_get_field_content_int(iCount, "sdpistol", MainPipeline);
		szMiscArray[4003] 	= 	cache_get_field_content_int(iCount, "deagle", MainPipeline);
		szMiscArray[4004] 	= 	cache_get_field_content_int(iCount, "uzi", MainPipeline);
		szMiscArray[4005] 	= 	cache_get_field_content_int(iCount, "tec9", MainPipeline);
		szMiscArray[4006] 	= 	cache_get_field_content_int(iCount, "mp5", MainPipeline);
		szMiscArray[4007] 	= 	cache_get_field_content_int(iCount, "m4", MainPipeline);
		szMiscArray[4008] 	= 	cache_get_field_content_int(iCount, "ak47", MainPipeline);
		szMiscArray[4009] 	= 	cache_get_field_content_int(iCount, "rifle", MainPipeline);
		szMiscArray[4010] 	= 	cache_get_field_content_int(iCount, "sniper", MainPipeline);
		szMiscArray[4011] 	= 	cache_get_field_content_int(iCount, "shotty", MainPipeline);
		szMiscArray[4012] 	= 	cache_get_field_content_int(iCount, "sawnoff", MainPipeline);
		szMiscArray[4013] 	= 	cache_get_field_content_int(iCount, "spas", MainPipeline);
		szMiscArray[4014] 	= 	cache_get_field_content_int(iCount, "pot", MainPipeline);
		szMiscArray[4015] 	= 	cache_get_field_content_int(iCount, "crack", MainPipeline);
		szMiscArray[4016] 	= 	cache_get_field_content_int(iCount, "meth", MainPipeline);
		szMiscArray[4017] 	= 	cache_get_field_content_int(iCount, "ecstasy", MainPipeline);
		szMiscArray[4018] 	= 	cache_get_field_content_int(iCount, "heroin", MainPipeline);

		++iCount;
	}

	if(szMiscArray[4001] != 0) /*for(new i = 0; i < szMiscArray[4001]; i++)*/ AddGroupSafeWeapon(INVALID_PLAYER_ID, iGroupID, WEAPON_COLT45, szMiscArray[4001]);
	if(szMiscArray[4002] != 0) /*for(new i = 0; i < szMiscArray[4002]; i++)*/ AddGroupSafeWeapon(INVALID_PLAYER_ID, iGroupID, WEAPON_SILENCED, szMiscArray[4002]);
	if(szMiscArray[4003] != 0) /*for(new i = 0; i < szMiscArray[4003]; i++)*/ AddGroupSafeWeapon(INVALID_PLAYER_ID, iGroupID, WEAPON_DEAGLE, szMiscArray[4003]);
	if(szMiscArray[4004] != 0) /*for(new i = 0; i < szMiscArray[4004]; i++)*/ AddGroupSafeWeapon(INVALID_PLAYER_ID, iGroupID, WEAPON_UZI, szMiscArray[4004]);
	if(szMiscArray[4005] != 0) /*for(new i = 0; i < szMiscArray[4005]; i++)*/ AddGroupSafeWeapon(INVALID_PLAYER_ID, iGroupID, WEAPON_TEC9, szMiscArray[4005]);
	if(szMiscArray[4006] != 0) /*for(new i = 0; i < szMiscArray[4006]; i++)*/ AddGroupSafeWeapon(INVALID_PLAYER_ID, iGroupID, WEAPON_MP5, szMiscArray[4006]);
	if(szMiscArray[4007] != 0) /*for(new i = 0; i < szMiscArray[4007]; i++)*/ AddGroupSafeWeapon(INVALID_PLAYER_ID, iGroupID, WEAPON_M4, szMiscArray[4007]);
	if(szMiscArray[4008] != 0) /*for(new i = 0; i < szMiscArray[4008]; i++)*/ AddGroupSafeWeapon(INVALID_PLAYER_ID, iGroupID, WEAPON_AK47, szMiscArray[4008]);
	if(szMiscArray[4009] != 0) /*for(new i = 0; i < szMiscArray[4009]; i++)*/ AddGroupSafeWeapon(INVALID_PLAYER_ID, iGroupID, WEAPON_RIFLE, szMiscArray[4009]);
	if(szMiscArray[4010] != 0) /*for(new i = 0; i < szMiscArray[4010]; i++)*/ AddGroupSafeWeapon(INVALID_PLAYER_ID, iGroupID, WEAPON_SNIPER, szMiscArray[4010]);
	if(szMiscArray[4011] != 0) /*for(new i = 0; i < szMiscArray[4011]; i++)*/ AddGroupSafeWeapon(INVALID_PLAYER_ID, iGroupID, WEAPON_SHOTGUN, szMiscArray[4011]);
	if(szMiscArray[4012] != 0) /*for(new i = 0; i < szMiscArray[4012]; i++)*/ AddGroupSafeWeapon(INVALID_PLAYER_ID, iGroupID, WEAPON_SAWEDOFF, szMiscArray[4012]);
	if(szMiscArray[4013] != 0) /*for(new i = 0; i < szMiscArray[4013]; i++)*/ AddGroupSafeWeapon(INVALID_PLAYER_ID, iGroupID, WEAPON_SHOTGSPA, szMiscArray[4013]);

	arrGroupData[iGroupID][g_iDrugs][0] += szMiscArray[4014];
	arrGroupData[iGroupID][g_iDrugs][1] += szMiscArray[4016];
	arrGroupData[iGroupID][g_iDrugs][2] += szMiscArray[4017];
	arrGroupData[iGroupID][g_iDrugs][3] += szMiscArray[4018];

	DeleteGCrate(playerid, iCrateID);
	SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully delivered the crate to your locker.");

	return 1;
}

ShowGCrateTransferMenu(playerid, itemid, transfertype, stage = 0) {

	szMiscArray[0] = 0; 

	//SetPVarInt(playerid, "TransferItem", itemid);

	switch(stage) {
		case 0: {
			ShowPlayerDialogEx(playerid, DIALOG_GANG_CRATE2, DIALOG_STYLE_LIST, "Please select an action!", "Withdraw from crate\nDeposit into crate", "Select", "Cancel");
		}

		case 1: {

			switch(transfertype) {
				case 0: { // withdraw
					format(szMiscArray, sizeof(szMiscArray), "Please input the quantity of %s you wish to withdraw!", GetItemNameFromIdx(itemid));
					ShowPlayerDialogEx(playerid, GCRATE_TRANSFER_WITHDRAW, DIALOG_STYLE_INPUT, "Withdraw item from crate!", szMiscArray, "Select", "Cancel");

				}
				case 1: { //deposit
					format(szMiscArray, sizeof(szMiscArray), "Please input the quantity of %s you wish to deposit!", GetItemNameFromIdx(itemid));
					ShowPlayerDialogEx(playerid, GCRATE_TRANSFER_DEPOSIT, DIALOG_STYLE_INPUT, "Deposit item into crate!", szMiscArray, "Select", "Cancel");
				}
			}
		}
	}

	return 1;
}


hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	szMiscArray[0] = 0;

	switch(dialogid) {
		case DIALOG_GANG_CRATE1: {
			if(response) {
				
				//if(listitem < 13) return SendClientMessageEx(playerid, COLOR_RED, "This feature has been disabled. You can now transfer weapons via your locker!");
				SetPVarInt(playerid, "TransferItem", listitem);
				ShowGCrateTransferMenu(playerid, listitem, 0, 0);	
			}		
		}
		case DIALOG_GANG_CRATE2: {
			
			if(response) {
				new 
					litemid = GetPVarInt(playerid, "TransferItem");

				ShowGCrateTransferMenu(playerid, litemid, listitem, 1);
			}
		}		
		case PURCHASE_GANG_CRATE: {
			new iGroupID = PlayerInfo[playerid][pMember];
			
			if(response) {
				if(arrGroupData[iGroupID][g_iBudget] < 150000) return SendClientMessageEx(playerid, COLOR_GRAD2, "Your group does not have sufficient funds to create a crate!");
				format(szMiscArray, sizeof(szMiscArray), "SELECT * FROM `gCrates` WHERE `iGroupID` = %d", iGroupID);
				mysql_tquery(MainPipeline, szMiscArray, true, "OnCheckGCrates", "ii", playerid, iGroupID);	
			}
			
		}
		case GCRATE_TRANSFER_DEPOSIT: {
			
			if(response) {
				if(strval(inputtext) < 1 || !IsNumeric(inputtext)) return SendClientMessage(playerid, COLOR_GRAD1, "You specified an invalid amount.");
				new 
					iAmount = strval(inputtext),
					iItem = GetPVarInt(playerid, "TransferItem"),
					iCrateID = GetPVarInt(playerid, "GCTransferTo");
				TransferItemToCrate(playerid, iItem, iAmount, iCrateID);
				DeletePVar(playerid, "TransferItem");
				DeletePVar(playerid, "GCTransferTo");
			}

		}	
		case GCRATE_TRANSFER_WITHDRAW: {
			
			if(response) {
				if(strval(inputtext) < 1 || !IsNumeric(inputtext)) return SendClientMessage(playerid, COLOR_GRAD1, "You specified an invalid amount.");
				new iAmount = strval(inputtext);

				TransferItemFromCrate(playerid, GetPVarInt(playerid, "TransferItem"), iAmount, GetPVarInt(playerid, "GCTransferTo"));
				DeletePVar(playerid, "TransferItem");
				DeletePVar(playerid, "GCTransferTo");
			}
		}
	}
	return 0;
}

CMD:purchasegcrate(playerid, params[]) {

	if(!GCrates_Permission(playerid)) return SendClientMessage(playerid, COLOR_GRAD2, "You cannot use this command.");
	ShowPlayerDialogEx(playerid, PURCHASE_GANG_CRATE, DIALOG_STYLE_MSGBOX, "Purchase Gang Crate", 
		"Are you sure you wish to purchase a gang crate?\nThis will cost your gang $150,000!\n\
		If so, make sure you are in a place where a vehicle can access your crate!", 
		"Create Crate", "Cancel"
	);
	return 1;
}

GCrates_Permission(playerid)
{
	new iGroupID = PlayerInfo[playerid][pMember];
	if(PlayerInfo[playerid][pLeader] == iGroupID && (arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_CRIMINAL || arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_CONTRACT)) return 1;
	if(PlayerInfo[playerid][pAdmin] > 1) return 1;
	return 0;
}

CMD:preparegcrate(playerid, params[]) {

	szMiscArray[0] = 0;
	if(!GCrates_Permission(playerid)) return SendClientMessage(playerid, COLOR_GRAD2, "You cannot use this command.");
	new 
		iCrateID;

	if(sscanf(params, "i", iCrateID)) return SendClientMessageEx(playerid, COLOR_GRAD2, "USAGE: /preparegcrate [crateid]");
	if(!IsValidDynamicObject(arrGCrateData[iCrateID][gcr_iObject])) return SendClientMessageEx(playerid, COLOR_GRAD2, "Invalid crate ID.");

	new 
		Float:fTemp[3];

	GetDynamicObjectPos(arrGCrateData[iCrateID][gcr_iObject], fTemp[0], fTemp[1], fTemp[2]);
	if(IsPlayerInRangeOfPoint(playerid, 10.0, fTemp[0], fTemp[1], fTemp[2])) {

		ShowGCrateItems(playerid, iCrateID);
	}
	else SendClientMessage(playerid, COLOR_GRAD1, "You are not near the crate.");

	return 1;
}



CMD:gloadforklift(playerid, params[]) {

	if(!GCrates_Permission(playerid)) return SendClientMessage(playerid, COLOR_GRAD2, "You cannot use this command.");
	new iVehID = GetPlayerVehicleID(playerid),
		iCrateID;
	
	if(sscanf(params, "d", iCrateID)) return SendClientMessageEx(playerid, COLOR_GRAD2, "USAGE: /gloadforklift [crateid]");
	if(IsPlayerNearGCrate(playerid, iCrateID) == 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not near that gang crate.");
	if(GetVehicleModel(iVehID) != 530) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not in a forklift.");
	if(CrateVehicleLoad[iVehID][vForkLoaded]) return SendClientMessageEx(playerid, COLOR_GRAD1, "You already have a crate on your forklift.");
	CrateVehicleLoad[iVehID][vForkLoaded] = 1;
	CrateVehicleLoad[iVehID][vCrateID][0] = iCrateID;
	DestroyDynamicObject(arrGCrateData[iCrateID][gcr_iObject]);
	arrGCrateData[iCrateID][gcr_iObject] = CreateDynamicObject(964,-1077.59997559,4274.39990234,3.40000010,0.00000000,0.00000000,0.00000000);
	AttachDynamicObjectToVehicle(arrGCrateData[iCrateID][gcr_iObject], iVehID, 0, 0.9, 0, 0, 0, 0);
	DestroyDynamic3DTextLabel(arrGCrateData[iCrateID][gcr_iLabel]);
	format(szMiscArray, sizeof(szMiscArray), "Gang Crate ID: %d\n%s", iCrateID, arrGroupData[PlayerInfo[playerid][pMember]][g_szGroupName]);
	arrGCrateData[iCrateID][gcr_iLabel] = CreateDynamic3DTextLabel(szMiscArray, COLOR_GREEN, 0.0, 0.0, 0.0, 5.0, INVALID_PLAYER_ID, iVehID);
	return 1;
}

CMD:gunloadforklift(playerid, params[])
{
	if(!GCrates_Permission(playerid)) return SendClientMessage(playerid, COLOR_GRAD2, "You cannot use this command.");
	new iVehID = GetPlayerVehicleID(playerid),
		iCrateID,
		Float:fTemp[3];
	if(GetVehicleModel(iVehID) != 530) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not in a forklift.");
	if(!CrateVehicleLoad[iVehID][vForkLoaded]) return SendClientMessage(playerid, COLOR_GRAD1, "You do not have a crate on your forklift.");
	iCrateID = CrateVehicleLoad[iVehID][vCrateID][0];
	CrateVehicleLoad[iVehID][vForkLoaded] = 0;
	DestroyDynamicObject(arrGCrateData[iCrateID][gcr_iObject]);
	DestroyDynamic3DTextLabel(arrGCrateData[iCrateID][gcr_iLabel]);
	GetPlayerPos(playerid, fTemp[0], fTemp[1], fTemp[2]);
	new iVW = GetPlayerVirtualWorld(playerid),
		iInt = GetPlayerInterior(playerid);
	GetXYInFrontOfPlayer(playerid, fTemp[0], fTemp[1], 2.0);
	arrGCrateData[iCrateID][gcr_iObject] = CreateDynamicObject(964, fTemp[0], fTemp[1], fTemp[2]-0.88, 0,0,0, .worldid = iVW, .interiorid = iInt);
	format(szMiscArray, sizeof(szMiscArray), "Gang Crate ID: %d\nDropped by: %s\n%s", iCrateID, GetPlayerNameEx(playerid), arrGroupData[PlayerInfo[playerid][pMember]][g_szGroupName]);
	arrGCrateData[iCrateID][gcr_iLabel] = CreateDynamic3DTextLabel(szMiscArray, COLOR_GREEN, fTemp[0], fTemp[1], fTemp[2], 5.0);
	return 1;
}

/*
hook OnVehicleDeath(vehicleid, killerid)
{
	if(CrateVehicleLoad[vehicleid][vForkLoaded]) if(IsValidDynamicObject(arrGCrateData[CrateVehicleLoad[vehicleid][vCrateID][0]][gcr_iObject])) DestroyDynamicObject(arrGCrateData[CrateVehicleLoad[vehicleid][vCrateID][0]][gcr_iObject]);
}

hook OnVehicleSpawn(vehicleid)
{
	if(CrateVehicleLoad[vehicleid][vForkLoaded]) if(IsValidDynamicObject(arrGCrateData[CrateVehicleLoad[vehicleid][vCrateID][0]][gcr_iObject])) DestroyDynamicObject(arrGCrateData[CrateVehicleLoad[vehicleid][vCrateID][0]][gcr_iObject]);
}*/

CMD:gloadcrate(playerid, params[]) {
	if(!GCrates_Permission(playerid)) return SendClientMessage(playerid, COLOR_GRAD2, "You cannot use this command.");
	szMiscArray[0] = 0;
	
	new 
		iVehID = GetPlayerVehicleID(playerid),
		iLoadVehID = GetClosestCar(playerid, iVehID, 6.0),
		iCrateID,
		iVehModelID = GetVehicleModel(iVehID);

	if(IsABike(iLoadVehID)) return SendClientMessageEx(playerid, COLOR_GRAD1, "Crates cannot be loaded onto bikes.");
	
	if(DynVehicleInfo[DynVeh[iLoadVehID]][gv_igID] == INVALID_GROUP_ID) SendClientMessageEx(playerid, COLOR_YELLOW, "This vehicle is not owned by a group!");
	if(iVehModelID != 530) return SendClientMessageEx(playerid, COLOR_WHITE, "You are not in a forklift.");
	if(sscanf(params, "d", iCrateID)) return SendClientMessageEx(playerid, COLOR_GRAD2, "USAGE: /gloadcrate [crateid]");
	if(CrateVehicleLoad[iVehID][vCrateID][0] != iCrateID) return SendClientMessageEx(playerid, COLOR_WHITE, "You do not have that crate on your forklift");
	if(iLoadVehID == INVALID_VEHICLE_ID) return SendClientMessageEx(playerid, COLOR_WHITE, "You are not near a vehicle.");
	if(CrateVehicleLoad[iLoadVehID][vForkLoaded])return SendClientMessageEx(playerid, COLOR_GRAD1, "There is a crate in that vehicle already!");
	DestroyDynamicObject(arrGCrateData[iCrateID][gcr_iObject]);
	DestroyDynamic3DTextLabel(arrGCrateData[iCrateID][gcr_iLabel]);
	format(szMiscArray, sizeof(szMiscArray), "Gang Crate ID: %d\n%s", iCrateID, arrGroupData[DynVehicleInfo[DynVeh[iLoadVehID]][gv_igID]][g_szGroupName]);
	arrGCrateData[iCrateID][gcr_iLabel] = CreateDynamic3DTextLabel(szMiscArray, COLOR_GREEN, 0.0, 0.0, 0.0, 5.0, INVALID_PLAYER_ID, iLoadVehID);
	format(szMiscArray, sizeof(szMiscArray), "You have successfully stored the crate into %s's %s", arrGroupData[DynVehicleInfo[DynVeh[iLoadVehID]][gv_igID]][g_szGroupName], VehicleName[GetVehicleModel(iLoadVehID)-400]);
	SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
	CrateVehicleLoad[iVehID][vForkLoaded] = 0;
	CrateVehicleLoad[iLoadVehID][vForkLoaded] = 1;
	CrateVehicleLoad[iLoadVehID][vCrateID][0] = iCrateID;
	SaveGCrate(iCrateID, DynVehicleInfo[DynVeh[iLoadVehID]][gv_igID]);
	Streamer_Update(playerid);
	return 1;
}

CMD:gunloadcrate(playerid, params[])
{
	if(!GCrates_Permission(playerid)) return SendClientMessage(playerid, COLOR_GRAD2, "You cannot use this command.");
	szMiscArray[0] = 0;
	new iVehID = GetPlayerVehicleID(playerid),
		iGVehID = GetClosestCar(playerid, iVehID, 6.0),
		iVehModelID = GetVehicleModel(iVehID);

	if(DynVehicleInfo[DynVeh[iGVehID]][gv_igID] == INVALID_GROUP_ID) SendClientMessageEx(playerid, COLOR_YELLOW, "This vehicle is not owned by a group!");
	if(iVehModelID != 530) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not in a forklift.");
	// if(iGVehID == INVALID_VEHICLE_ID || arrGroupData[DynVehicleInfo[DynVeh[iGVehID]][gv_igID]][g_iGroupType] != GROUP_TYPE_CRIMINAL || arrGroupData[DynVehicleInfo[DynVeh[iGVehID]][gv_igID]][g_iGroupType] != GROUP_TYPE_CONTRACT) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not near a gang vehicle.");
	if(CrateVehicleLoad[iVehID][vForkLoaded]) return SendClientMessageEx(playerid, COLOR_GRAD1, "You already have a crate on your forklift.");
	if(CrateVehicleLoad[iGVehID][vForkLoaded])
	{
		new iCrateID = CrateVehicleLoad[iGVehID][vCrateID][0];
		CrateVehicleLoad[iVehID][vCrateID][0] = iCrateID;
		CrateVehicleLoad[iGVehID][vForkLoaded] = 0;
		CrateVehicleLoad[iVehID][vForkLoaded] = 1;
		arrGCrateData[iCrateID][gcr_iObject] = CreateDynamicObject(964,-1077.59997559,4274.39990234,3.40000010,0.00000000,0.00000000,0.00000000);
		AttachDynamicObjectToVehicle(arrGCrateData[iCrateID][gcr_iObject], iVehID, 0, 0.9, 0, 0, 0, 0);
		DestroyDynamic3DTextLabel(arrGCrateData[iCrateID][gcr_iLabel]);
		format(szMiscArray, sizeof(szMiscArray), "Gang Crate ID: %d\n%s", iCrateID, arrGroupData[PlayerInfo[playerid][pMember]][g_szGroupName]);
		arrGCrateData[iCrateID][gcr_iLabel] = CreateDynamic3DTextLabel(szMiscArray, COLOR_GREEN, 0.0, 0.0, 0.0, 5.0, INVALID_PLAYER_ID, iVehID);
		format(szMiscArray, sizeof(szMiscArray), "You have successfully taken a crate from %s' %s.", arrGroupData[DynVehicleInfo[DynVeh[iGVehID]][gv_igID]][g_szGroupName], VehicleName[iGVehID-400]);
		SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
	}
	else SendClientMessageEx(playerid, COLOR_WHITE, "This vehicle does not have any crates stored.");
	return 1;
}


CMD:gdelivercrate(playerid, params[]) 
{
	new iGroupID = PlayerInfo[playerid][pMember],
		iVehID = GetPlayerVehicleID(playerid);
	if(arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_CRIMINAL || arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_CONTRACT) {
		new Float:fTemp[3];
		GetPlayerPos(playerid, fTemp[0], fTemp[1], fTemp[2]);
		for(new i; i < MAX_GROUPS; i++)
		{
			if(IsPlayerInRangeOfPoint(playerid, 6.0, arrGroupData[i][g_fCratePos][0], arrGroupData[i][g_fCratePos][1], arrGroupData[i][g_fCratePos][2]) && arrGroupData[i][g_iGroupType] == GROUP_TYPE_CRIMINAL)
			{
				if(CrateVehicleLoad[iVehID][vForkLoaded])
				{
					for(new ix = 0; ix < sizeof(CrateInfo); ix++)
					{
						if(CrateInfo[ix][InVehicle] == iVehID)
						{
	    		    		SetPVarInt(playerid, "CrateGuns_CID", ix);
						}
					}
					//DeliverGCCrate(playerid, iGroupID, CrateVehicleLoad[iVehID][vCrateID][0]);
					ShowPlayerDialogEx(playerid, DIALOG_GDELIVER_CRATE, DIALOG_STYLE_LIST, "Weapon - Quantity for Gang Deposit", "Desert Eagle - 13\nSPAS-12 - 5\nMP5 - 10\nM4A1 - 5\nAK-47 - 10\nSniper Rifle - 5\nShotgun - 17\n9mm - 50", "Select", "Cancel");
					break;
				}
				else SendClientMessageEx(playerid, COLOR_GRAD1, "Your vehicle does not have a crate stored.");
				break;
			}
		}
	}
	else SendClientMessageEx(playerid, COLOR_GRAD1, "You are not in a gang.");
	return 1;
}


CMD:gdelivergangcrate(playerid, params[]) 
{
	if(!GCrates_Permission(playerid)) return SendClientMessage(playerid, COLOR_GRAD2, "You cannot use this command.");
	new iGroupID = PlayerInfo[playerid][pMember],
		iVehID = GetPlayerVehicleID(playerid);
	if(arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_CRIMINAL || arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_CONTRACT) {
		new Float:fTemp[3];
		GetPlayerPos(playerid, fTemp[0], fTemp[1], fTemp[2]);
		if(IsPlayerInRangeOfPoint(playerid, 6.0, arrGroupData[iGroupID][g_fCratePos][0], arrGroupData[iGroupID][g_fCratePos][1], arrGroupData[iGroupID][g_fCratePos][2]))
		{
			if(CrateVehicleLoad[iVehID][vForkLoaded])
			{
				CrateVehicleLoad[iVehID][vForkLoaded] = 0;
				DeliverGCCrate(playerid, iGroupID, CrateVehicleLoad[iVehID][vCrateID][0]);
				return 1;
			}
			else SendClientMessageEx(playerid, COLOR_GRAD1, "Your vehicle does not have a crate stored.");
		}
		else SendClientMessageEx(playerid, COLOR_GRAD1, "You are not near your group's crate delivery point.");
	}
	else SendClientMessageEx(playerid, COLOR_GRAD1, "You are not in a gang.");
	return 1;
}

CMD:gdestroycrate(playerid, params[])
{
	if(IsACop(playerid))
	{
		new 
			Float:fTemp[3],
			iCrateID;
		if(sscanf(params, "d", iCrateID)) return SendClientMessage(playerid, COLOR_GRAD1, "Usage: /gdestroycrate [crateid]");
        GetDynamicObjectPos(arrGCrateData[iCrateID][gcr_iObject], fTemp[0], fTemp[1], fTemp[2]);
		if(IsPlayerInRangeOfPoint(playerid, 7.0, fTemp[0], fTemp[1], fTemp[2])) {
			DeleteGCrate(playerid, iCrateID);
			Streamer_Update(playerid);
		}		
	}
	else SendClientMessageEx(playerid, COLOR_GRAD2, "You are not a cop.");
	return 1;
}

CMD:agcrates(playerid, params[]) {

	szMiscArray[0] = 0;
	if(PlayerInfo[playerid][pAdmin] >= 1337)
		ShowGCrates(playerid);
	return 1;
}

CMD:adestroygcrate(playerid, params[]) {
	szMiscArray[0] = 0;
	new iCrateID;
	if(sscanf(params, "d", iCrateID)) return SendClientMessageEx(playerid, COLOR_WHITE, "Usage: /adestroygcrate [Crate ID]");
	DeleteGCrate(playerid, iCrateID);
	return 1;
}

CMD:gcratehelp(playerid, params[]) {

	SendClientMessageEx(playerid, COLOR_WHITE, "*** GANG CRATES *** /purchasegcrate /preparegcrate /gloadforklift /gunloadforklift /gloadcrate /gunloadcrate /gdelivercrate /gdelivergangcrate");
	if(IsACop(playerid)) SendClientMessageEx(playerid, COLOR_WHITE, "*** GANG CRATES (LEO) ***  /gdestroycrate");
	if(PlayerInfo[playerid][pAdmin] >= 2) SendClientMessageEx(playerid, COLOR_WHITE, "*** GANG CRATES (ADMIN) *** /agcrates /adestroygcrate");

	return 1;
}