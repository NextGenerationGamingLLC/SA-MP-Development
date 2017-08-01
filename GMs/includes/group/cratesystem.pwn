/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

    	    		  Crate System (Re-done)
    			        by Shane Roberts

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

new 
	CrateBeingProcessed[MAX_CRATE_FACILITY],
	CrateBeingDelivered[MAX_GROUPS],
	CrateFacilityRaid[MAX_CRATE_FACILITY];

hook OnGameModeInit() {
	for(new i = 0; i < MAX_CRATE_FACILITY; i++) {
		AdminOpened[i] = 0; // Disable by default.
		CrateBeingProcessed[i] = 0;
		CrateFacility[i][cfTextID] = Text3D: -1;
		CrateFacility[i][cfPickupID] = -1;
		CrateFacility[i][cfMapIcon] = -1;
		CrateFacilityRaid[i] = 0;
	}
	for(new c = 0; c < MAX_CRATES; c++) {
		BeingMoved[c] = INVALID_PLAYER_ID;
		CrateBox[c][cbObject] = -1;
		CrateBox[c][cbTextID] = Text3D: -1;
	}
	return 1;
}

hook OnPlayerConnect(playerid) {
	CarryCrate[playerid] = -1;
	return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
	if(CarryCrate[playerid] != -1) {
		PlayerCarryCrate(playerid, CarryCrate[playerid], -1, 1);
	}
	return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
	if(IsKeyJustDown(KEY_FIRE, newkeys, oldkeys)) {
		if(CarryCrate[playerid] >= 0) {
			ApplyAnimation(playerid, "CARRY", "putdwn", 4.1, 0, 0, 0, 0, 0, 1);
			SetTimerEx("PlayerCarryCrate", 1000, false, "iiii", playerid, CarryCrate[playerid], -1, 1);
		}
	}
	return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate) {
	if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER) {
		if(CarryCrate[playerid] >= 0) {
			SendClientMessageEx(playerid, COLOR_GREY, "You can't be in any vehicles whilst carrying a crate!");
			return RemovePlayerFromVehicle(playerid);
		}
	}
	return 1;
}

hook OnPlayerEnterVehicle(playerid, vehicleid, ispassenger) {
	if(CarryCrate[playerid] >= 0) {
		new Float:pos[3];
		GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
		SetPlayerPos(playerid, pos[0], pos[1], pos[2]+1.3);
		PlayerPlaySound(playerid, 1130, pos[0], pos[1], pos[2]+1.3);
		SendClientMessageEx(playerid, COLOR_GREY, "You can't enter any vehicles whilst carrying a crate!");
		return 1;
	}
	return 1;
}

stock LoadCrateOrders() {
	mysql_tquery(MainPipeline, "SELECT * FROM `crate_orders`", "OnLoadCrateOrders", "");
}

forward OnLoadCrateOrders();
public OnLoadCrateOrders()
{
	new i, rows;
	cache_get_row_count(rows);

	while(i < rows)
	{
		if (!(0 <= i < MAX_GROUPS)) break;
		cache_get_value_name_int(i, "id", CrateOrder[i][coGroup]);
		cache_get_value_name_int(i, "Facility", CrateOrder[i][coFacility]);
		cache_get_value_name_int(i, "Crates", CrateOrder[i][coCrates]);
		cache_get_value_name_int(i, "PerCrate", CrateOrder[i][coPerCrate]);
		cache_get_value_name(i,  "OrderBy", CrateOrder[i][coOrderBy], MAX_PLAYER_NAME);
		cache_get_value_name_int(i, "Delivered", CrateOrder[i][coDelivered]);
		cache_get_value_name_int(i, "Status", CrateOrder[i][coStatus]);
		cache_get_value_name_int(i, "Time", CrateOrder[i][coTime]);
		i++;
	}
	return 1;
}

stock SaveOrder(i) {
	new query[2048];

	format(query, 2048, "UPDATE `crate_orders` SET ");
	SaveInteger(query, "crate_orders", i+1, "Facility", CrateOrder[i][coFacility]);
	SaveInteger(query, "crate_orders", i+1, "Crates", CrateOrder[i][coCrates]);
	SaveInteger(query, "crate_orders", i+1, "PerCrate", CrateOrder[i][coPerCrate]);
	SaveString(query, "crate_orders", i+1, "OrderBy", CrateOrder[i][coOrderBy]);
	SaveInteger(query, "crate_orders", i+1, "Delivered", CrateOrder[i][coDelivered]);
	SaveInteger(query, "crate_orders", i+1, "Status", CrateOrder[i][coStatus]);
	SaveInteger(query, "crate_orders", i+1, "Time", CrateOrder[i][coTime]);
	SQLUpdateFinish(query, "crate_orders", i+1);
	return 1;
}

stock LoadCrateBoxes()
{
	printf("[Dynamic Crate Boxes] Loading Dynamic Crate Boxes from the database, please wait...");
	mysql_tquery(MainPipeline, "SELECT * FROM `crates`", "OnLoadCrateBoxes", "");
}

forward OnLoadCrateBoxes();
public OnLoadCrateBoxes()
{
	new i, rows, number[16];
	cache_get_row_count(rows);

	while(i < rows)
	{
		cache_get_value_name_int(i, "Facility", CrateBox[i][cbFacility]);
		cache_get_value_name_int(i, "Group", CrateBox[i][cbGroup]);
		cache_get_value_name_float(i, "CrateX", CrateBox[i][cbPos][0]);
		cache_get_value_name_float(i, "CrateY", CrateBox[i][cbPos][1]);
		cache_get_value_name_float(i, "CrateZ", CrateBox[i][cbPos][2]);
		cache_get_value_name_int(i, "Int", CrateBox[i][cbInt]);
		cache_get_value_name_int(i, "InVehicle", CrateBox[i][cbInVeh]);
		cache_get_value_name_int(i, "OnVehicle", CrateBox[i][cbOnVeh]);
		cache_get_value_name_int(i, "VW", CrateBox[i][cbVw]);
		cache_get_value_name_int(i, "Materials", CrateBox[i][cbMats]);
		for(new w = 0; w < 16; w++) {
			format(number, sizeof(number), "Gun%d", w+1);
			cache_get_value_name_int(i, number, CrateBox[i][cbWep][w]);
			format(number, sizeof(number), "GunAmount%d", w+1);
			cache_get_value_name_int(i, number, CrateBox[i][cbWepAmount][w]);
		}
		cache_get_value_name(i,  "PlacedBy", CrateBox[i][cbPlacedBy], MAX_PLAYER_NAME);
		cache_get_value_name_int(i, "Lifespan", CrateBox[i][cbLifespan]);
		cache_get_value_name_int(i, "Transfer", CrateBox[i][cbTransfer]);
		cache_get_value_name_int(i, "DoorID", CrateBox[i][cbDoor]);
		cache_get_value_name_int(i, "DoorType", CrateBox[i][cbDoorType]);
		cache_get_value_name_int(i, "Price", CrateBox[i][cbPrice]);
		cache_get_value_name_int(i, "Paid", CrateBox[i][cbPaid]);
		cache_get_value_name_int(i, "Active", CrateBox[i][cbActive]);
		UpdateCrateBox(i);
		i++;
	}
	if(i > 0) printf("[Dynamic Crate Boxes] %d dynamic Crate Boxes have been loaded.", i);
	else printf("[Dynamic Crate Boxes] There are no dynamic crate boxes to load.");
	return 1;
}

stock UpdateCrateBox(id)
{
	new string[256];
	if(IsValidDynamicObject(CrateBox[id][cbObject])) DestroyDynamicObject(CrateBox[id][cbObject]), CrateBox[id][cbObject] = -1;
	if(IsValidDynamic3DTextLabel(CrateBox[id][cbTextID])) DestroyDynamic3DTextLabel(CrateBox[id][cbTextID]), CrateBox[id][cbTextID] = Text3D: -1;

	if(!CrateBox[id][cbActive] || CrateBox[id][cbInVeh] != -1) return 1;

	/*
	foreach(new p: Player) {
		if(CarryCrate[p] == id) return 1;
	}*/
	if(BeingMoved[id] != INVALID_PLAYER_ID) return 1;

	//if(CrateBox[id][cbOnVeh] != -1) return CrateVehCheck(CrateBox[id][cbOnVeh]);

	if(CrateBox[id][cbOnVeh] != -1) {
		if(CrateVehicle[CrateBox[id][cbOnVeh]][cvCrate] != id) return DestroyCrate(id);
	}
	if(CrateBox[id][cbGroup] != -1 && !ValidGroup(CrateBox[id][cbGroup])) return DestroyCrate(id);

	if(CrateBox[id][cbGroup] == -1) {
		format(string, sizeof(string), "{FFFF00}---- ID: {FF8000}%d\n{FFFF00}Time Remaining: {FF8000}00:00:00\n{FFFF00}Placed By: {FF8000}%s", id, CrateBox[id][cbPlacedBy]);
	} else {
		format(string, sizeof(string), "{FFFF00}ID: {FF8000}%d\n{FFFF00}Crate Owner: {FF8000}%s\n{FFFF00}Placed By: {FF8000}%s", id, arrGroupData[CrateBox[id][cbGroup]][g_szGroupName], CrateBox[id][cbPlacedBy]);
	}
	CrateBox[id][cbTextID] = CreateDynamic3DTextLabel(string, COLOR_YELLOW, CrateBox[id][cbPos][0], CrateBox[id][cbPos][1], CrateBox[id][cbPos][2]+1.5, 20.0, .testlos = 1, .worldid = CrateBox[id][cbVw], .interiorid = CrateBox[id][cbInt], .streamdistance = 20.0);
	CrateBox[id][cbObject] = CreateDynamicObject(964, CrateBox[id][cbPos][0], CrateBox[id][cbPos][1], CrateBox[id][cbPos][2], 0.00000000, 0.00000000, 0.00000000, CrateBox[id][cbVw], CrateBox[id][cbInt]);
	
	return 1;
}

stock SaveCrate(i) {
	new query[2048], wep[16];

	format(query, 2048, "UPDATE `crates` SET ");
	SaveInteger(query, "crates", i+1, "Facility", CrateBox[i][cbFacility]);
	SaveInteger(query, "crates", i+1, "Group", CrateBox[i][cbGroup]);
	SaveFloat(query, "crates", i+1, "CrateX", CrateBox[i][cbPos][0]);
	SaveFloat(query, "crates", i+1, "CrateY", CrateBox[i][cbPos][1]);
	SaveFloat(query, "crates", i+1, "CrateZ", CrateBox[i][cbPos][2]);
	SaveInteger(query, "crates", i+1, "Int", CrateBox[i][cbInt]);
	SaveInteger(query, "crates", i+1, "InVehicle", CrateBox[i][cbInVeh]);
	SaveInteger(query, "crates", i+1, "OnVehicle", CrateBox[i][cbOnVeh]);
	SaveInteger(query, "crates", i+1, "VW", CrateBox[i][cbVw]);
	SaveInteger(query, "crates", i+1, "Materials", CrateBox[i][cbMats]);
	for(new w = 0; w < 16; w++) {
		format(wep, sizeof(wep), "Gun%d", w+1);
		SaveInteger(query, "crates", i+1, wep, CrateBox[i][cbWep][w]);
		format(wep, sizeof(wep), "GunAmount%d", w+1);
		SaveInteger(query, "crates", i+1, wep, CrateBox[i][cbWepAmount][w]);
	}
	SaveString(query, "crates", i+1, "PlacedBy", CrateBox[i][cbPlacedBy]);
	SaveInteger(query, "crates", i+1, "Lifespan", CrateBox[i][cbLifespan]);
	SaveInteger(query, "crates", i+1, "Transfer", CrateBox[i][cbTransfer]);
	SaveInteger(query, "crates", i+1, "DoorID", CrateBox[i][cbDoor]);
	SaveInteger(query, "crates", i+1, "DoorType", CrateBox[i][cbDoorType]);
	SaveInteger(query, "crates", i+1, "Price", CrateBox[i][cbPrice]);
	SaveInteger(query, "crates", i+1, "Paid", CrateBox[i][cbPaid]);
	SaveInteger(query, "crates", i+1, "Active", CrateBox[i][cbActive]);
	SQLUpdateFinish(query, "crates", i+1);
	return 1;
}

stock LoadCrateFacilities()
{
	printf("[Dynamic Crate Facility] Loading Dynamic Crate Facilities from the database, please wait...");
	mysql_tquery(MainPipeline, "SELECT * FROM `crate_facility`", "OnLoadCrateFacilities", "");
}

forward OnLoadCrateFacilities();
public OnLoadCrateFacilities()
{
	new i, rows;
	cache_get_row_count(rows);

	while(i < rows)
	{
		cache_get_value_name_int(i, "id", CrateFacility[i][cfId]);
		cache_get_value_name(i, "Name", CrateFacility[i][cfName], 32);
		cache_get_value_name_int(i, "Group", CrateFacility[i][cfGroup]);
		cache_get_value_name_float(i, "Posx", CrateFacility[i][cfPos][0]);
		cache_get_value_name_float(i, "Posy", CrateFacility[i][cfPos][1]);
		cache_get_value_name_float(i, "Posz", CrateFacility[i][cfPos][2]);
		cache_get_value_name_float(i, "Posr", CrateFacility[i][cfPos][3]);
		cache_get_value_name_int(i, "Int", CrateFacility[i][cfInt]);
		cache_get_value_name_int(i, "Vw", CrateFacility[i][cfVw]);
		cache_get_value_name_int(i, "Prodmax", CrateFacility[i][cfProdMax]);
		cache_get_value_name_int(i, "ProdPrep", CrateFacility[i][cfProdPrep]);
		cache_get_value_name_int(i, "ProdReady", CrateFacility[i][cfProdReady]);
		cache_get_value_name_int(i, "ProdTimer", CrateFacility[i][cfProdTimer]);
		cache_get_value_name_int(i, "ProdStatus", CrateFacility[i][cfProdStatus]);
		cache_get_value_name_int(i, "ProdCost", CrateFacility[i][cfProdCost]);
		cache_get_value_name_int(i, "ProdMulti", CrateFacility[i][cfProdMulti]);
		cache_get_value_name_int(i, "RaidTimer", CrateFacility[i][cfRaidTimer]);
		cache_get_value_name_int(i, "Cooldown", CrateFacility[i][cfCooldown]);
		cache_get_value_name_int(i, "Raidable", CrateFacility[i][cfRaidable]);
		cache_get_value_name_int(i, "Active", CrateFacility[i][cfActive]);
		cache_get_value_name_int(i, "Timer", CrateFacility[i][cfTimer]);
		UpdateFacility(i);
		if(CrateFacility[i][cfRaidTimer] > 0) TriggerGates(i);
		i++;
	}
	if(i > 0) printf("[Dynamic Crate Facility] %d dynamic Crate Facilities have been loaded.", i);
	else printf("[Dynamic Crate Facility] No dynamic Crate Facilities have been loaded.");
	return 1;
}

stock UpdateFacility(id)
{
	new string[256];
	//964 box | 11 - Map Icon
	if(IsValidDynamicObject(CrateFacility[id][cfPickupID])) DestroyDynamicObject(CrateFacility[id][cfPickupID]), CrateFacility[id][cfPickupID] = -1;
	if(IsValidDynamic3DTextLabel(CrateFacility[id][cfTextID])) DestroyDynamic3DTextLabel(CrateFacility[id][cfTextID]), CrateFacility[id][cfTextID] = Text3D: -1;
	if(IsValidDynamicMapIcon(CrateFacility[id][cfMapIcon])) DestroyDynamicMapIcon(CrateFacility[id][cfMapIcon]), CrateFacility[id][cfMapIcon] = -1;

	if(CrateFacility[id][cfPos][0] == 0.0) return 1;

	CrateFacility[id][cfMapIcon] = CreateDynamicMapIcon(CrateFacility[id][cfPos][0], CrateFacility[id][cfPos][1], CrateFacility[id][cfPos][2], 11, 0, CrateFacility[id][cfVw], CrateFacility[id][cfInt], .streamdistance = 1000.0, .style = MAPICON_GLOBAL);
	// Box Object.
	CrateFacility[id][cfPickupID] = CreateDynamicObject(964, CrateFacility[id][cfPos][0], CrateFacility[id][cfPos][1], CrateFacility[id][cfPos][2], 0.00000000, 0.00000000, CrateFacility[id][cfPos][3], CrateFacility[id][cfVw], CrateFacility[id][cfInt]);
	format(string, sizeof(string), "{FFFF00}%s (ID: {1FBDFF}%d{FFFF00})\n{FFFF00}Crates Available: {1FBDFF}%d/%d", CrateFacility[id][cfName], id, CrateFacility[id][cfProdReady], CrateFacility[id][cfProdMax]);
	CrateFacility[id][cfTextID] = CreateDynamic3DTextLabel(string, COLOR_YELLOW, CrateFacility[id][cfPos][0], CrateFacility[id][cfPos][1], CrateFacility[id][cfPos][2]+1.5, 20.0, .testlos = 1, .worldid = CrateFacility[id][cfVw], .interiorid = CrateFacility[id][cfInt], .streamdistance = 20.0);
	return 1;
}

stock SaveFacility(i) {
	new query[2048];
	format(query, 2048, "UPDATE `crate_facility` SET ");
	SaveInteger(query, "crate_facility", i+1, "Group", CrateFacility[i][cfGroup]);
	SaveString(query, "crate_facility", i+1, "Name", CrateFacility[i][cfName]);
	SaveFloat(query, "crate_facility", i+1, "Posx", CrateFacility[i][cfPos][0]);
	SaveFloat(query, "crate_facility", i+1, "Posy", CrateFacility[i][cfPos][1]);
	SaveFloat(query, "crate_facility", i+1, "Posz", CrateFacility[i][cfPos][2]);
	SaveFloat(query, "crate_facility", i+1, "Posr", CrateFacility[i][cfPos][3]);
	SaveInteger(query, "crate_facility", i+1, "Int", CrateFacility[i][cfInt]);
	SaveInteger(query, "crate_facility", i+1, "Vw", CrateFacility[i][cfVw]);
	SaveInteger(query, "crate_facility", i+1, "Prodmax", CrateFacility[i][cfProdMax]);
	SaveInteger(query, "crate_facility", i+1, "ProdPrep", CrateFacility[i][cfProdPrep]);
	SaveInteger(query, "crate_facility", i+1, "ProdReady", CrateFacility[i][cfProdReady]);
	SaveInteger(query, "crate_facility", i+1, "ProdTimer", CrateFacility[i][cfProdTimer]);
	SaveInteger(query, "crate_facility", i+1, "ProdStatus", CrateFacility[i][cfProdStatus]);
	SaveInteger(query, "crate_facility", i+1, "ProdCost", CrateFacility[i][cfProdCost]);
	SaveInteger(query, "crate_facility", i+1, "ProdMulti", CrateFacility[i][cfProdMulti]);
	SaveInteger(query, "crate_facility", i+1, "RaidTimer", CrateFacility[i][cfRaidTimer]);
	SaveInteger(query, "crate_facility", i+1, "Cooldown", CrateFacility[i][cfCooldown]);
	SaveInteger(query, "crate_facility", i+1, "Raidable", CrateFacility[i][cfRaidable]);
	SaveInteger(query, "crate_facility", i+1, "Active", CrateFacility[i][cfActive]);
	SaveInteger(query, "crate_facility", i+1, "Timer", CrateFacility[i][cfTimer]);
	SQLUpdateFinish(query, "crate_facility", i+1);
	return 1;
}


task UpdateFacilityCrates[1000]()
{
	for(new i = 0; i < MAX_CRATE_FACILITY; i++)
	{
		if(CrateFacility[i][cfId] > 0 && CrateFacility[i][cfActive] == 1) {
			if(CrateFacility[i][cfProdPrep] > 0 && CrateFacility[i][cfProdStatus] == 1 && CrateFacility[i][cfProdTimer] > 0) {
				if(CrateFacility[i][cfTimer] > 0) CrateFacility[i][cfTimer]--;
				if(!CrateFacility[i][cfTimer]) {
					if(CrateFacility[i][cfProdReady] < CrateFacility[i][cfProdMax]) {
						++CrateFacility[i][cfProdReady];
						--CrateFacility[i][cfProdPrep];
						CrateFacility[i][cfTimer] = CrateFacility[i][cfProdTimer];
					}
				}
			}
			if(CrateFacility[i][cfRaidable]) {
				if((CrateFacility[i][cfCooldown] - 300) == gettime() && CrateFacility[i][cfRaidTimer] == 0) {
					CrateFacilityRaid[i] = 1;
					foreach(new g: Player) {
						if(PlayerInfo[g][pMember] == CrateFacility[i][cfGroup]) {
							SendClientMessageEx(g, COLOR_LIGHTRED, "%s: We're about to go into production mode be advised.", CrateFacility[i][cfName]);
							SendClientMessageEx(g, COLOR_YELLOW, "** You have 5 minutes to prepare for a facility raid. **");
						}
					}
				}
				if(CrateFacility[i][cfCooldown] < gettime() && CrateFacility[i][cfRaidTimer] == 0) {
					CrateFacility[i][cfRaidTimer] = gettime()+5400; // 1 hour 30 minutes
					CrateFacilityRaid[i] = 1; // Just incase an admin sets the raid time lower than 5 min interval
					SaveFacility(i);
					TriggerGates(i);
					foreach(new g: Player) {
						if(IsACriminal(g)) {
							SendClientMessageEx(g, COLOR_YELLOW, "SMS: Word on the street is that %s facility is processing crates!, Sender: Unknown.", CrateFacility[i][cfName]);
							SendClientMessageEx(g, COLOR_YELLOW, "** You have 1 hour 30 minutes to raid the facility before it goes into a cooldown. **");
						}
						if(PlayerInfo[g][pMember] == CrateFacility[i][cfGroup]) {
							SendClientMessageEx(g, COLOR_LIGHTRED, "%s: We're now processing crates!", CrateFacility[i][cfName]);
							SendClientMessageEx(g, COLOR_YELLOW, "** You have 1 hour 30 minutes to protect the facility before it goes into a cooldown. **");
						}
					}
				}
				if((CrateFacility[i][cfRaidTimer] - 300) == gettime() && CrateFacility[i][cfRaidTimer] != 0) {
					foreach(new g: Player) {
						if(IsACriminal(g)) {
							SendClientMessageEx(g, COLOR_YELLOW, "** You have 5 minutes remaining before all gates are closed! **", CrateFacility[i][cfName]);
						}
						if(PlayerInfo[g][pMember] == CrateFacility[i][cfGroup]) {
							SendClientMessageEx(g, COLOR_LIGHTRED, "%s: Crate production is nearly complete!", CrateFacility[i][cfName]);
							SendClientMessageEx(g, COLOR_YELLOW, "** You have 5 minutes remaining to protect the facility until the facility goes into lockdown. **");
						}
					}
				}
				if(CrateFacility[i][cfRaidTimer] < gettime() && CrateFacility[i][cfRaidTimer] != 0) {
					CrateFacility[i][cfCooldown] = gettime()+10800; // 3 hours
					CrateFacility[i][cfRaidTimer] = 0;
					CrateFacilityRaid[i] = 0;
					SaveFacility(i);
					TriggerGates(i, 0);
					foreach(new g: Player) {
						if(IsACriminal(g)) {
							SendClientMessageEx(g, COLOR_YELLOW, "SMS: %s facility is now on lockdown. (( Cooldown Period )), Sender: Unknown.", CrateFacility[i][cfName]);
							SendClientMessageEx(g, COLOR_YELLOW, "** You can no longer raid the facility, it'll be on cooldown for a random time period. **", CrateFacility[i][cfName]);
						}
						if(PlayerInfo[g][pMember] == CrateFacility[i][cfGroup]) {
							SendClientMessageEx(g, COLOR_LIGHTRED, "%s: Crate Production at this facility has finished!", CrateFacility[i][cfName]);
							SendClientMessageEx(g, COLOR_YELLOW, "** This facility can no longer be raided, it'll be on a cooldown period for a random amount of time. **");
						}
					}
				}
			}
		}
		if((CrateFacility[i][cfProdReady] >= CrateFacility[i][cfProdMax]) && CrateFacility[i][cfProdPrep] > 0) {
			CrateFacility[i][cfProdPrep] = 0;
		}
		FacilityBoxUpdate(i);
	}
	for(new c = 0; c < MAX_CRATES; c++)
	{
		if(CrateBox[c][cbActive] == 1 && CrateBox[c][cbFacility] != -1 && CrateBox[c][cbGroup] == -1) {
			if(CrateBox[c][cbLifespan] > 0) CrateBox[c][cbLifespan]--;
			if(!CrateBox[c][cbLifespan]) {
				DestroyCrate(c);
			}
			CrateBoxUpdate(c);
		}
	}
	foreach(new p: Player) {
		if(CarryCrate[p] >= 0) {
			if(PlayerHoldingObject[p][8] != 0 || IsPlayerAttachedObjectSlotUsed(p, 8))
				RemovePlayerAttachedObject(p, 8), PlayerHoldingObject[p][8] = 0;
			SetPlayerAttachedObject(p, 8, 964, 1, -0.071, 0.536, -0.026999, -2.19999, 87.1999, 0.699999, 0.479999, 0.538999, 0.419999);
			if(GetPlayerSpecialAction(p) != SPECIAL_ACTION_CARRY) SetPlayerSpecialAction(p, SPECIAL_ACTION_CARRY);
		}
		if(CarryCrate[p] >= 0) {
			if(PlayerInfo[p][pHospital] > 0 || PlayerInfo[p][pJailTime] > 0 || GetPVarType(p, "IsInArena") || GetPVarInt(p, "EventToken") != 0) {
				PlayerCarryCrate(p, CarryCrate[p], -1, 4);
			}
			if(PlayerCuffed[p] != 0 || GetPVarInt(p, "Injured") != 0) {
				PlayerCarryCrate(p, CarryCrate[p], -1, 5);
			}
		}
	}
}

forward CrateBoxUpdate(id);
public CrateBoxUpdate(id) {
	new string[256];
	if(IsValidDynamic3DTextLabel(CrateBox[id][cbTextID])) {
		format(string, sizeof(string), "{FFFF00}%s (ID: {FF8000}%d{FFFF00})\n{FFFF00}Time Remaining: {FF8000}%s\n{FFFF00}Placed By: {FF8000}%s\n{FFFF00}Materials: {FF8000}%d/50", CrateFacility[CrateBox[id][cbFacility]][cfName], id, TimeConvert(CrateBox[id][cbLifespan]), CrateBox[id][cbPlacedBy], CrateBox[id][cbMats]);
		//format(string, sizeof(string), "{FFFF00}ID: {FF8000}%d\n{FFFF00}Time Remaining: {FF8000}%s\n{FFFF00}Placed By: {FF8000}%s", id, TimeConvert(CrateBox[id][cbLifespan]), CrateBox[id][cbPlacedBy]);
		UpdateDynamic3DTextLabelText(CrateBox[id][cbTextID], COLOR_ORANGE, string);
	}
	return 1;
}

forward FacilityBoxUpdate(id);
public FacilityBoxUpdate(id) {
	new string[256];
	if(CrateFacility[id][cfActive] == 1) {
		if(CrateFacility[id][cfProdStatus] == 1 && CrateFacility[id][cfProdTimer] > 0) {
			if(CrateFacility[id][cfProdReady] < CrateFacility[id][cfProdMax] && CrateFacility[id][cfProdPrep] > 0) {
				format(string, sizeof(string), "{FFFF00}%s (ID: {FF8000}%d{FFFF00})\n{FFFF00}Crates Available: {FF8000}%d/%d\n{FFFF00}Next Production in: {FF8000}%s", CrateFacility[id][cfName], id, CrateFacility[id][cfProdReady], CrateFacility[id][cfProdMax], STimeConvert(CrateFacility[id][cfTimer]));
			}
			else if(CrateFacility[id][cfProdReady] < CrateFacility[id][cfProdMax] && CrateFacility[id][cfProdPrep] == 0) {
				format(string, sizeof(string), "{FFFF00}%s (ID: {FF8000}%d{FFFF00})\n{FFFF00}Crates Available: {FF8000}%d/%d\n{FFFF00}Production stopped all crates\nhave been exported.", CrateFacility[id][cfName], id, CrateFacility[id][cfProdReady], CrateFacility[id][cfProdMax]);
			}
			else format(string, sizeof(string), "{FFFF00}%s (ID: {FF8000}%d{FFFF00})\n{FFFF00}Crates Available: {FF8000}%d/%d", CrateFacility[id][cfName], id, CrateFacility[id][cfProdReady], CrateFacility[id][cfProdMax]);
		}
		else format(string, sizeof(string), "{FFFF00}%s (ID: {FF8000}%d{FFFF00})\n{FFFF00}Crates Available: {FF8000}%d/%d\n{FFFF00}Production has been paused\nno crates will be manufactured.", CrateFacility[id][cfName], id, CrateFacility[id][cfProdReady], CrateFacility[id][cfProdMax]);
	} else {
		format(string, sizeof(string), "{FFFF00}%s (ID: {FF8000}%d{FFFF00})\n{FFFF00}Production has been stopped.\nThis facility is currently closed.", CrateFacility[id][cfName], id);
	}
	UpdateDynamic3DTextLabelText(CrateFacility[id][cfTextID], COLOR_YELLOW, string);
	return 1;
}

stock FetchFacility(playerid, &facility, Float:range)
{
	facility = -1;
    for(new f = 0; f < MAX_CRATE_FACILITY; f++)
    {
 	    if(IsPlayerInRangeOfPoint(playerid,range,CrateFacility[f][cfPos][0], CrateFacility[f][cfPos][1], CrateFacility[f][cfPos][2]))
		{
			if(GetPlayerVirtualWorld(playerid) == CrateFacility[f][cfVw] && GetPlayerInterior(playerid) == CrateFacility[f][cfInt]) {
				facility = f;
			}
			break;
	    }
 	}
}

stock GetCrateBox(playerid, &box, Float:range)
{
	box = -1;
    for(new b = 0; b < MAX_CRATES; b++)
    {
    	if(BeingMoved[b] == INVALID_PLAYER_ID && CrateBox[b][cbOnVeh] == -1 && CrateBox[b][cbInVeh] == -1 && CrateBox[b][cbActive]) {
	 	    if(IsPlayerInRangeOfPoint(playerid,range,CrateBox[b][cbPos][0], CrateBox[b][cbPos][1], CrateBox[b][cbPos][2]))
			{
				if(GetPlayerVirtualWorld(playerid) == CrateBox[b][cbVw] && GetPlayerInterior(playerid) == CrateBox[b][cbInt]) {
					box = b;
				}
				break;
		    }
		}
 	}
}

// Used for tracking / transferring weapons from and to the locker
stock GetGroupCrate(playerid, &box) {
	box = -1;
    for(new b = 0; b < MAX_CRATES; b++)
    {
 	    if(PlayerInfo[playerid][pMember] == CrateBox[b][cbGroup])
		{
			box = b;
			break;
	    }
 	}
}

forward LoadForklift(playerid, facility, boxid, vehicle);
public LoadForklift(playerid, facility, boxid, vehicle) {
    szMiscArray[0] = 0;
	new string[128];
	SetPVarInt(playerid, "LoadForkliftTime", GetPVarInt(playerid, "LoadForkliftTime")-1);
	format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~%d seconds left", GetPVarInt(playerid, "LoadForkliftTime"));
	GameTextForPlayer(playerid, string, 1100, 3);

	if(GetPVarInt(playerid, "LoadForkliftTime") > 0) SetTimerEx("LoadForklift", 1000, 0, "iiii", playerid, facility, boxid, vehicle);

	if(GetPVarInt(playerid, "LoadForkliftTime") <= 0)
	{
		DeletePVar(playerid, "LoadForkliftTime");
		CrateBeingProcessed[facility] = 0;
		CrateBox[boxid][cbFacility] = -1;
		TogglePlayerControllable(playerid, 1);
		if(!ValidGroup(PlayerInfo[playerid][pMember])) {
			SendClientMessageEx(playerid, COLOR_GRAD2, "You failed to load the crate. You're no longer apart of a group!");
			return 1;
		}
 	    if(!IsPlayerInRangeOfPoint(playerid, 3.0, CrateFacility[facility][cfPos][0], CrateFacility[facility][cfPos][1], CrateFacility[facility][cfPos][2])) {
			SendClientMessageEx(playerid, COLOR_GRAD2, "You failed to load the crate. You're not in range of the facility!");
			return 1;
	    }
	    if(GetPlayerVirtualWorld(playerid) != CrateFacility[facility][cfVw] || GetPlayerInterior(playerid) != CrateFacility[facility][cfInt]) {
	    	SendClientMessageEx(playerid, COLOR_GRAD2, "You failed to load the crate. You're not in the same virtual/interior world.");
	    	return 1;
	    }
	    if(playerTabbed[playerid] != 0) {
	    	SendClientMessageEx(playerid, COLOR_GRAD2, "You failed to load the crate. You were alt-tabbed.");
	    	return 1;
	    }
	    if(IsACriminal(playerid)) CrateBox[boxid][cbPaid] = 1;
		if(!IsACriminal(playerid)) {
			if(CrateFacility[facility][cfProdCost] > 0) {
				if(PlayerInfo[playerid][pMember] != CrateFacility[facility][cfGroup]) {
					if(GetGroupBudget(PlayerInfo[playerid][pMember]) < CrateFacility[facility][cfProdCost]) return SendClientMessageEx(playerid, COLOR_GRAD1, "Your group doesn't have $%s to purcahse this crate!", number_format(CrateFacility[facility][cfProdCost]));
					SetGroupBudget(PlayerInfo[playerid][pMember], -CrateFacility[facility][cfProdCost]);
					CrateBox[boxid][cbPaid] = 1;
					format(string, sizeof(string), "%s has purchased a crate from the %s facility costing %s.", GetPlayerNameEx(playerid), CrateFacility[facility][cfName], number_format(CrateFacility[facility][cfProdCost]));
					GroupPayLog(PlayerInfo[playerid][pMember], string);
					if(CrateFacility[facility][cfGroup] == -1) {
						if(arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance] == 2) {
							TRTax += CrateFacility[facility][cfProdCost];
							format(string, sizeof(string), "%s has purchased a crate from an unowned facility in your nation adding $%s", arrGroupData[PlayerInfo[playerid][pMember]][g_szGroupName], number_format(CrateFacility[facility][cfProdCost]));
							GroupPayLog(8, string);
						} else {
							Tax += CrateFacility[facility][cfProdCost];
							format(string, sizeof(string), "%s has purchased a crate from an unowned facility in your nation adding $%s", arrGroupData[PlayerInfo[playerid][pMember]][g_szGroupName], number_format(CrateFacility[facility][cfProdCost]));
							GroupPayLog(5, string);
						}
					} else {
						SetGroupBudget(CrateFacility[facility][cfGroup], CrateFacility[facility][cfProdCost]);
						format(string, sizeof(string), "%s has purchased a crate from your facility adding $%s", arrGroupData[PlayerInfo[playerid][pMember]][g_szGroupName], number_format(CrateFacility[facility][cfProdCost]));
						GroupPayLog(CrateFacility[facility][cfGroup], string);
					}
					SendClientMessageEx(playerid, COLOR_YELLOW, "Your group has been charged %s for this crate!", number_format(CrateFacility[facility][cfProdCost]));
				}
				else {
					SendClientMessageEx(playerid, COLOR_YELLOW, "Your group will not be charged for this crate but if you deposit it into your locker payment is required!");
				}
			}
			SaveGroup(PlayerInfo[playerid][pMember]);
        	format(string, sizeof(string), "%s %s has manufactured a crate at %s facility.", arrGroupRanks[PlayerInfo[playerid][pMember]][PlayerInfo[playerid][pRank]], GetPlayerNameEx(playerid), CrateFacility[facility][cfName]);
          	GroupLog(PlayerInfo[playerid][pMember], string);
          	ABroadCast(COLOR_LIGHTRED, string, 2);
          	if(ValidGroup(CrateFacility[facility][cfGroup])) {
          		foreach(new i: Player) {
          			if(PlayerInfo[i][pMember] == CrateFacility[facility][cfGroup]) {
          				SendClientMessageEx(i, COLOR_LIGHTRED, "A crate has been manufactured at %s facility.", CrateFacility[facility][cfName]);
          			}
          		}
          	}
		}
		CrateBox[boxid][cbLifespan] = 7200;
		CrateBox[boxid][cbFacility] = facility;
		CrateBox[boxid][cbGroup] = -1;
		CrateBox[boxid][cbTransfer] = 1;
		CrateBox[boxid][cbOnVeh] = vehicle;
		CrateBox[boxid][cbPrice] = CrateFacility[facility][cfProdCost];
		CrateBox[boxid][cbMats] = 50;
		CrateBox[boxid][cbActive] = 1;
		CrateVehicle[vehicle][cvForkObject] = CreateDynamicObject(964,-1077.59997559,4274.39990234,3.40000010,0.00000000,0.00000000,0.00000000);
		AttachDynamicObjectToVehicle(CrateVehicle[vehicle][cvForkObject], CrateVehicle[vehicle][cvSpawnID], 0, 0.9, -0.2, 0, 0, 0);
		CrateVehicle[vehicle][cvCrate] = boxid;
		--CrateFacility[facility][cfProdReady];
		SaveCrate(boxid);
		SaveFacility(facility);
		SaveCrateVehicle(vehicle);
		Streamer_Update(playerid);
	}
	return 1;
}

forward PlayerCarryCrate(playerid, boxid, vehid, action);
public PlayerCarryCrate(playerid, boxid, vehid, action) {
	/*
	--- Action ---
	0 - Pickup from floor
	1 - Put on floor
	2 - Take from vehicle
	3 - Put in vehicle
	4-5 - Player went to busy mode (Events, Prison, Death etc..)
	*/
	if(action == 0) {
		SendClientMessageEx(playerid, COLOR_GRAD2, "Press the '{FFFF00}FIRE{BFC0C2}' button to place the crate on the floor");
		SendClientMessageEx(playerid, COLOR_GRAD2, "or you can use '{FFFF00}/crate store{BFC0C2}' to place it into the designated vehicle.");
		if(PlayerHoldingObject[playerid][8] != 0 || IsPlayerAttachedObjectSlotUsed(playerid, 8))
			RemovePlayerAttachedObject(playerid, 8), PlayerHoldingObject[playerid][8] = 0;
		SetPlayerAttachedObject(playerid, 8, 964, 1, -0.071, 0.536, -0.026999, -2.19999, 87.1999, 0.699999, 0.479999, 0.538999, 0.419999);
		if(GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_CARRY) SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
		CarryCrate[playerid] = boxid;
		BeingMoved[boxid] = playerid;
	}
	if(action == 1) {
		new Float: pcbPos[3];
		GetPlayerPos(playerid, pcbPos[0], pcbPos[1], pcbPos[2]);
		GetXYInFrontOfPlayer(playerid, pcbPos[0], pcbPos[1], 1);
		CrateBox[boxid][cbPos][0] = pcbPos[0];
		CrateBox[boxid][cbPos][1] = pcbPos[1];
		CrateBox[boxid][cbPos][2] = pcbPos[2]-1.0;
		CrateBox[boxid][cbInt] = GetPlayerInterior(playerid);
		CrateBox[boxid][cbVw] = GetPlayerVirtualWorld(playerid);
		CrateBox[boxid][cbPlacedBy] = GetPlayerNameEx(playerid);
		RemovePlayerAttachedObject(playerid, 8);
		PlayerHoldingObject[playerid][8] = 0;
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		CarryCrate[playerid] = -1;
		BeingMoved[boxid] = INVALID_PLAYER_ID;
		SaveCrate(boxid);
	}
	if(action == 2) {
		SendClientMessageEx(playerid, COLOR_GRAD2, "Press the '{FFFF00}FIRE{BFC0C2}' button to place the crate on the floor");
		SendClientMessageEx(playerid, COLOR_GRAD2, "or you can use '{FFFF00}/crate store{BFC0C2}' to place it into the designated vehicle.");
		if(PlayerHoldingObject[playerid][8] != 0 || IsPlayerAttachedObjectSlotUsed(playerid, 8))
			RemovePlayerAttachedObject(playerid, 8), PlayerHoldingObject[playerid][8] = 0;
		SetPlayerAttachedObject(playerid, 8, 964, 1, -0.071, 0.536, -0.026999, -2.19999, 87.1999, 0.699999, 0.479999, 0.538999, 0.419999);
		if(GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_CARRY) SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
		CrateBox[boxid][cbInVeh] = -1;
		CarryCrate[playerid] = boxid;
		BeingMoved[boxid] = playerid;
		format(szMiscArray, sizeof(szMiscArray), "* %s has unloaded a crate from the %s.", GetPlayerNameEx(playerid), GetVehicleName(CrateVehicle[vehid][cvSpawnID]));
		ProxDetector(25.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	}
	if(action == 3) {
		CrateBox[boxid][cbInVeh] = vehid;
		RemovePlayerAttachedObject(playerid, 8);
		PlayerHoldingObject[playerid][8] = 0;
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		CarryCrate[playerid] = -1;
		BeingMoved[boxid] = INVALID_PLAYER_ID;
		SaveCrate(boxid);
		format(szMiscArray, sizeof(szMiscArray), "* %s has loaded a crate into the %s.", GetPlayerNameEx(playerid), GetVehicleName(CrateVehicle[vehid][cvSpawnID]));
		ProxDetector(25.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	}
	if(action == 4 || action == 5) {
		if(action == 4) SendClientMessageEx(playerid, COLOR_YELLOW, "SMS: What do you think your doing?! I'll take that box from you as you seem busy to finish the job!, Sender: Unknown");
		if(action == 5) {
			SendClientMessageEx(playerid, COLOR_YELLOW, "SMS: You were prevented from carrying the crate it has been dropped!, Sender: Unknown");
			new Float: pcbPos[3];
			GetPlayerPos(playerid, pcbPos[0], pcbPos[1], pcbPos[2]);
			GetXYInFrontOfPlayer(playerid, pcbPos[0], pcbPos[1], 1);
			CrateBox[boxid][cbPos][0] = pcbPos[0];
			CrateBox[boxid][cbPos][1] = pcbPos[1];
			CrateBox[boxid][cbPos][2] = pcbPos[2]-1.0;
			CrateBox[boxid][cbInt] = GetPlayerInterior(playerid);
			CrateBox[boxid][cbVw] = GetPlayerVirtualWorld(playerid);
			CrateBox[boxid][cbPlacedBy] = GetPlayerNameEx(playerid);
			SaveCrate(boxid);
		}
		RemovePlayerAttachedObject(playerid, 8);
		PlayerHoldingObject[playerid][8] = 0;
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		CarryCrate[playerid] = -1;
		BeingMoved[boxid] = INVALID_PLAYER_ID;
	}
	UpdateCrateBox(boxid);
	Streamer_Update(playerid);
	return 1;
}

stock DestroyCrate(box) {
	// Is the box on a fork lift?
	if(CrateBox[box][cbOnVeh] != -1) {
		if(IsValidDynamicObject(CrateVehicle[CrateBox[box][cbOnVeh]][cvForkObject])) DestroyDynamicObject(CrateVehicle[CrateBox[box][cbOnVeh]][cvForkObject]);
		CrateVehicle[CrateBox[box][cbOnVeh]][cvCrate] = -1;
		CrateVehicle[CrateBox[box][cbOnVeh]][cvCrateLoad] = 0;
		SaveCrateVehicle(CrateBox[box][cbOnVeh]);
		CrateBox[box][cbOnVeh] = -1;
	}
	/*
	foreach(new p: Player) {
		if(CarryCrate[p] == box) {
			RemovePlayerAttachedObject(p, 8);
			PlayerHoldingObject[p][8] = 0;
			SetPlayerSpecialAction(p, SPECIAL_ACTION_NONE);
			CarryCrate[p] = -1;
			BeingMoved[box] = INVALID_PLAYER_ID;
		}
	}*/
	if(BeingMoved[box] != INVALID_PLAYER_ID) {
		RemovePlayerAttachedObject(BeingMoved[box], 8);
		PlayerHoldingObject[BeingMoved[box]][8] = 0;
		SetPlayerSpecialAction(BeingMoved[box], SPECIAL_ACTION_NONE);
		CarryCrate[BeingMoved[box]] = -1;
		BeingMoved[box] = INVALID_PLAYER_ID;
	}
	if(CrateBox[box][cbFacility] != -1) {
		++CrateFacility[CrateBox[box][cbFacility]][cfProdPrep];
	}
	CrateBox[box][cbFacility] = -1;
	CrateBox[box][cbGroup] = -1;
	CrateBox[box][cbPos][0] = 0.00000;
	CrateBox[box][cbPos][1] = 0.00000;
	CrateBox[box][cbPos][2] = 0.00000;
	CrateBox[box][cbInt] = 0;
	CrateBox[box][cbInVeh] = -1;
	CrateBox[box][cbOnVeh] = -1;
	CrateBox[box][cbVw] = 0;
	CrateBox[box][cbMats] = 0;
	for(new w = 0; w < 16; w++) {
		CrateBox[box][cbWep][w] = 0;
		CrateBox[box][cbWepAmount][w] = 0;
	}
	format(CrateBox[box][cbPlacedBy], MAX_PLAYER_NAME, "Unknown");
	CrateBox[box][cbLifespan] = 0;
	CrateBox[box][cbTransfer] = 0;
	CrateBox[box][cbDoor] = -1;
	CrateBox[box][cbDoorType] = -1;
	CrateBox[box][cbPrice] = 0;
	CrateBox[box][cbPaid] = 0;
	CrateBox[box][cbActive] = 0;
	SaveCrate(box);
	UpdateCrateBox(box);
	return 1;
}

stock IsValidCrate(box) {
	if((0 <= box < MAX_CRATES)) return 1;
	else return 0;
}

CMD:facility(playerid, params[]) {
	if(PlayerInfo[playerid][pAdmin] > 3 || PlayerInfo[playerid][pASM] > 0 || PlayerInfo[playerid][pFactionModerator] > 0) {
		szMiscArray[0] = 0;
		new choice[32], fac, value;
		if(sscanf(params, "s[32]iD(-1)", choice, fac, value))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /facility [name] [id]");
			SendClientMessageEx(playerid, COLOR_GREY, "Names: sync goto, raidable, info");
			SendClientMessageEx(playerid, COLOR_GREY, "EXTRA: There is only /cfedit if you want to edit a facility.");
			return 1;
		}
		if(!(0 <= fac < MAX_CRATE_FACILITY)) return SendClientMessageEx(playerid, COLOR_GREY, "Invalid Facility ID. (0 - %d)", MAX_CRATE_FACILITY-1);
		if(strcmp(choice, "sync", true) == 0) {
			if(!CrateFacility[fac][cfActive]) return SendClientMessageEx(playerid, COLOR_GREY, "That crate facility is not active!");
			SyncFacility(fac);
			SendClientMessageEx(playerid, COLOR_WHITE, "You have sycned the %s facility, if boxes are missing they'll be put into production.", CrateFacility[fac][cfName]);
			return 1;
		}
		else if(strcmp(choice, "goto", true) == 0) {
			if(CrateFacility[fac][cfPos][0] == 0.0) return SendClientMessageEx(playerid, COLOR_GREY, "Unable to go to facility as it's currently not being used!");
			SetPlayerInterior(playerid, CrateFacility[fac][cfInt]);
			SetPlayerPos(playerid, CrateFacility[fac][cfPos][0], CrateFacility[fac][cfPos][1], CrateFacility[fac][cfPos][2]+1.0);
			PlayerInfo[playerid][pInt] = CrateFacility[fac][cfInt];
			SetPlayerVirtualWorld(playerid, CrateFacility[fac][cfVw]);
			PlayerInfo[playerid][pVW] = CrateFacility[fac][cfVw];
			if(CrateFacility[fac][cfInt] > 0) Player_StreamPrep(playerid, CrateFacility[fac][cfPos][0], CrateFacility[fac][cfPos][1], CrateFacility[fac][cfPos][2]+1.0, FREEZE_TIME);
			SendClientMessageEx(playerid, COLOR_WHITE, "You have teleported to create facility %d.", fac);
			return 1;
		}
		else if(strcmp(choice, "raidable", true) == 0) {
			if(!CrateFacility[fac][cfActive]) return SendClientMessageEx(playerid, COLOR_GREY, "That crate facility is not active!");
			if(AdminOpened[fac]) {
				if(CrateFacility[fac][cfRaidTimer] == 0) TriggerGates(fac, 0);
	    		format(szMiscArray, sizeof(szMiscArray), "{AA3333}AdmWarning{FFFF00}: %s has made %s facility unable to be raided freely. (ID: %d)", GetPlayerNameEx(playerid), CrateFacility[fac][cfName], fac);
				SendClientMessageEx(playerid, COLOR_WHITE, "You have made %s facility unable to be raided freely.", CrateFacility[fac][cfName]);
				ABroadCast(COLOR_YELLOW, szMiscArray, 2);
				AdminOpened[fac] = 0;
			} else {
				TriggerGates(fac);
	    		format(szMiscArray, sizeof(szMiscArray), "{AA3333}AdmWarning{FFFF00}: %s has made %s facility able to be raided freely. (ID: %d)", GetPlayerNameEx(playerid), CrateFacility[fac][cfName], fac);
				SendClientMessageEx(playerid, COLOR_WHITE, "You have made %s facility able to be raided freely.", CrateFacility[fac][cfName]);
				ABroadCast(COLOR_YELLOW, szMiscArray, 2);
				AdminOpened[fac] = 1;
			}
			return 1;
		}
		else if(strcmp(choice, "info", true) == 0) {
			new crates = 0, group[32];
			for(new c = 0; c < MAX_CRATES; c++) {
				if(CrateBox[c][cbFacility] == fac) {
					++crates;
				}
			}

			if(CrateFacility[fac][cfGroup] != -1 && ValidGroup(CrateFacility[fac][cfGroup])) {
				format(group, sizeof(group), "%s", arrGroupData[CrateFacility[fac][cfGroup]][g_szGroupName]);
			} else {
				format(group, sizeof(group), "--");
			}
			SendClientMessageEx(playerid, COLOR_GREEN, "|___________ Facility Info (ID: %d) ___________|", fac);
			SendClientMessageEx(playerid, COLOR_WHITE, "X: %f | Y: %f | Z: %f | Int: %d | VW: %d | Active: %s", CrateFacility[fac][cfPos][0], CrateFacility[fac][cfPos][1], CrateFacility[fac][cfPos][2], CrateFacility[fac][cfInt], CrateFacility[fac][cfVw], (CrateFacility[fac][cfActive]) ? ("Yes") : ("No"));
			SendClientMessageEx(playerid, COLOR_WHITE, "Next Raid: %s | Raid Progress: %s | Raidable Status: %s", date(CrateFacility[fac][cfCooldown], 1), (CrateFacilityRaid[fac]) ? ("Active") : ("Not Ready"), (CrateFacility[fac][cfRaidable]) ? ("Active") : ("Disabled"));
			SendClientMessageEx(playerid, COLOR_WHITE, "Crates Ready: %d | Crates in production: %d | Crates in use: %d | Max Crates: %d", CrateFacility[fac][cfProdReady], CrateFacility[fac][cfProdPrep], crates, CrateFacility[fac][cfProdMax]);
			SendClientMessageEx(playerid, COLOR_WHITE, "Cost Per Crate: %s | Production status: %s", number_format(CrateFacility[fac][cfProdCost]), (CrateFacility[fac][cfProdStatus]) ? ("Active") : ("Paused"));
			SendClientMessageEx(playerid, COLOR_WHITE, "Owner: %s | Deliver Multiplier: %d", group, CrateFacility[fac][cfProdMulti]);
			return 1;
		}
		else SendClientMessageEx(playerid, COLOR_GREY, "Invalid name selected!");
	} else {
		SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use this command!");
	}
	return 1;
}

stock SyncFacility(id) {
	new total = 0;
	for(new c = 0; c < MAX_CRATES; c++) {
		if(CrateBox[c][cbFacility] == id) {
			++total;
		}
	}
	new ready = ((CrateFacility[id][cfProdReady] + CrateFacility[id][cfProdPrep]) + total);
	if(ready < 0) ready = CrateFacility[id][cfProdMax];
	if(CrateFacility[id][cfProdMax] != ready) {
		CrateFacility[id][cfProdPrep] = (CrateFacility[id][cfProdMax] - ready);
	}
	SaveFacility(id);
	return 1;
}

CMD:crate(playerid, params[]) {
	szMiscArray[0] = 0;
	new string[128], choice[32], box, crate;
	if(sscanf(params, "s[32]D(-1)", choice, crate))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /crate [name]");
		SendClientMessageEx(playerid, COLOR_GREY, "(On-Foot): Carry, Take, Contents, Seize");
		SendClientMessageEx(playerid, COLOR_GREY, "(Forklift): Load, Drop, Store");
		if(PlayerInfo[playerid][pAdmin] > 3) SendClientMessageEx(playerid, COLOR_GREY, "Administrator: Destroy, Spawn");
		return 1;
	}
	if(PlayerBusy(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can't do that right now.");
	if(strcmp(choice, "carry", true) == 0) {
		GetCrateBox(playerid, box, 2.0);
		if(box == -1) return SendClientMessageEx(playerid, COLOR_GREY, "You're not near any crate boxes to pickup!");
		if(CarryCrate[playerid] != -1) return SendClientMessageEx(playerid, COLOR_GRAD2, "you're currently carraying a crate either store or drop it before carrying another!");
		ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
		SetTimerEx("PlayerCarryCrate", 1000, false, "iiii", playerid, box, -1, 0);
		return 1;
	}
	else if(strcmp(choice, "contents", true) == 0) {
		new weaponname[32], title[24];
		GetCrateBox(playerid, box, 2.0);
		if(box == -1) return SendClientMessageEx(playerid, COLOR_GREY, "You're not in range of any crate boxes!");
		if(CrateBox[box][cbGroup] == -1) return SendClientMessageEx(playerid, COLOR_GREY, "This crate is not a transfer crate, use /cgun instead!");
		format(title, sizeof(title), "Crate Contents (ID: %d)", box);
		format(szMiscArray, sizeof(szMiscArray), "Weapon\tQuantity\n");
		for(new w = 0; w < 16; w++) {
			if(CrateBox[box][cbWep][w] > 0) {
				GetWeaponName(CrateBox[box][cbWep][w], weaponname, sizeof(weaponname));
				format(szMiscArray, sizeof(szMiscArray), "%s%s\t%s\n", szMiscArray, weaponname, number_format(CrateBox[box][cbWepAmount][w]));
			}
		}
		if(strlen(szMiscArray) == 16) format(szMiscArray, sizeof(szMiscArray), "%sThere are no weapons in this crate.", szMiscArray);
		Dialog_Show(playerid, -1, DIALOG_STYLE_TABLIST_HEADERS, title, szMiscArray, "Close", "");
		return 1;
	}
	else if(strcmp(choice, "load", true) == 0) {
		new facility, vehicleid = GetPlayerVehicleID(playerid), veh;
		FetchFacility(playerid, facility, 3.0);
		GetCrateBox(playerid, box, 3.0);
		if(!ValidGroup(PlayerInfo[playerid][pMember])) return SendClientMessage(playerid, COLOR_GRAD2, " You need to be apart of a group to use this command!");
		if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD2, "You need to be in a vehicle to do this!");
		if(GetVehicleModel(vehicleid) != 530) return SendClientMessageEx(playerid, COLOR_GRAD2, "You need to be in a forklift vehicle to load crates!");
		if((veh = IsDynamicCrateVehicle(vehicleid)) == -1) return SendClientMessageEx(playerid, COLOR_GRAD2, "You're not in the designated forklift vehicle for this operation!");
		if(CrateVehicle[veh][cvCrate] != -1) return SendClientMessageEx(playerid, COLOR_GRAD2, "There is already a crate loaded on the forklift!");
		if(facility != -1) {
			if(!CrateFacility[facility][cfActive]) return SendClientMessageEx(playerid, COLOR_GRAD1, "This facility is currently not in operation!");
			if(CrateFacility[facility][cfProdReady] < 1) return SendClientMessageEx(playerid, COLOR_GRAD1, "This facility has no crates available to load!");
			if(CrateBeingProcessed[facility] > 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "Please wait a crate is being procssed!");
			if(PlayerInfo[playerid][pConnectHours] < 25)
		    {
				format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s has attempted to load a crate with only %d playing hours.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pConnectHours]);
				ABroadCast(COLOR_YELLOW, string, 4);
		        return SendClientMessageEx(playerid, COLOR_GRAD2, " You've not played long enough in order to load crates!");
		    }
			if(IsACriminal(playerid)) {
				if(!CrateFacility[facility][cfRaidable]) return SendClientMessageEx(playerid, COLOR_GRAD1, "This facility can't be raided!");
				if(!AdminOpened[facility] && !CrateFacility[facility][cfRaidTimer]) return SendClientMessageEx(playerid, COLOR_GRAD1, "This facility is currently on cooldown from raids.");
			}
			for(new c = 0; c < MAX_CRATES; c++) {
				if(CrateBox[c][cbFacility] == -1) {
					CrateBeingProcessed[facility] = 1;
					CrateBox[c][cbFacility] = facility;
					SetPVarInt(playerid, "LoadForkliftTime", 5);
					SetTimerEx("LoadForklift", 1000, 0, "iiii", playerid, facility, c, veh);
					GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~5 seconds left", 1100, 3);
					TogglePlayerControllable(playerid, 0);
					break;
				}
			}
		}
		else if(box != -1) {
			CrateBox[box][cbOnVeh] = veh;
			CrateVehicle[veh][cvCrate] = box;
			format(string, sizeof(string), "* %s has loaded a crate onto the forklift.", GetPlayerNameEx(playerid));
			ProxDetector(25.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			SaveCrateVehicle(veh);
			SaveCrate(box);
			UpdateCrateBox(box);
			CrateVehCheck(veh);
		}
		else SendClientMessageEx(playerid, COLOR_GRAD2, "You're not near any crate boxes to load onto the forklift!");
		return 1;
	}
	else if(strcmp(choice, "store", true) == 0) {
		szMiscArray[0] = 0;
		new Float:vPos[3], inveh = GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet ,boot, objective, VehFound = -1, boxid;
		
		for(new i = 0; i < MAX_CRATE_VEHCILES; i++) {
			if(CrateVehicle[i][cvSpawnID] != INVALID_VEHICLE_ID) {
				GetPosBehindVehicle(CrateVehicle[i][cvSpawnID], vPos[0], vPos[1], vPos[2], (IsAPlane(CrateVehicle[i][cvSpawnID]) ? -8 : 0));
				if(IsPlayerInRangeOfPoint(playerid, (IsAPlane(CrateVehicle[i][cvSpawnID]) ? 6 : 2), vPos[0], vPos[1], vPos[2])) {
					if(CrateVehicle[i][cvSpawnID] != inveh) {
						VehFound = i; // Do not use the vehicle ID as we store the array ID for the validation since vehicles do not store "spawn id".
						break;
					}
				}
			}
		}
		if(VehFound == -1) return SendClientMessageEx(playerid, COLOR_GRAD2, "You're not near any designated vehicles that can store crates.");
		if(CrateVehicle[VehFound][cvCrateMax] < 1) return SendClientMessageEx(playerid, COLOR_GRAD3, "You can't store crates in this vehicle!");
		if(CreateCount(VehFound) >= CrateVehicle[VehFound][cvCrateMax]) return SendClientMessageEx(playerid, COLOR_GRAD3, "You can't store anymore crates in this vehicle it's at max capacity!");
		if(VehDelivering[VehFound]) return SendClientMessageEx(playerid, COLOR_GRAD3, "This vehicle is currently unloading crates - Please Wait!");
		GetVehicleParamsEx(CrateVehicle[VehFound][cvSpawnID], engine, lights, alarm, doors, bonnet, boot, objective);
		if(inveh > 0 && GetVehicleModel(inveh) == 530) { // Forklift -> Vehicle
			if(IsDynamicCrateVehicle(inveh) == -1) return SendClientMessageEx(playerid, COLOR_GRAD2, "Your not in the designated forklift vehicle!");
			if((boxid = CrateVehicle[IsDynamicCrateVehicle(inveh)][cvCrate]) == -1) return SendClientMessageEx(playerid, COLOR_GRAD2, "There is no crate loaded on the forklift!");
			if(GetVehicleModel(CrateVehicle[VehFound][cvSpawnID]) != 592 && GetVehicleModel(CrateVehicle[VehFound][cvSpawnID]) != 553 && IsAPlane(CrateVehicle[VehFound][cvSpawnID])) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can't store crates in this vehicle!");
			if(!IsAPlane(CrateVehicle[VehFound][cvSpawnID])) {
				if((boot == VEHICLE_PARAMS_OFF || boot == VEHICLE_PARAMS_UNSET)) return SendClientMessageEx(playerid, COLOR_GRAD3, "You can't load crates into a vehicle whilst the trunk is closed! - '/car trunk' to open it.");
			}
			CrateBox[boxid][cbInVeh] = VehFound;
			CrateBox[boxid][cbOnVeh] = -1;
			CrateBox[boxid][cbTransfer] = 0;
			CrateVehicle[IsDynamicCrateVehicle(inveh)][cvCrate] = -1;
			SaveCrateVehicle(IsDynamicCrateVehicle(inveh));
			SaveCrate(boxid);
			CrateVehCheck(IsDynamicCrateVehicle(inveh));
			UpdateCrateBox(boxid);
			Streamer_Update(playerid);
			format(szMiscArray, sizeof(szMiscArray), "* %s has loaded a crate into the %s.", GetPlayerNameEx(playerid), GetVehicleName(CrateVehicle[VehFound][cvSpawnID]));
			ProxDetector(25.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		}
		else if((boxid = CarryCrate[playerid]) != -1) { // Player -> Vehicle
			if(IsAPlane(CrateVehicle[VehFound][cvSpawnID])) return SendClientMessageEx(playerid, COLOR_GRAD2, "You need a forklift to load them into the plane!");
			if((boot == VEHICLE_PARAMS_OFF || boot == VEHICLE_PARAMS_UNSET)) return SendClientMessageEx(playerid, COLOR_GRAD3, "You can't load crates into the vehicle whilst the trunk is closed! - '/car trunk' to open it.");
			ApplyAnimation(playerid, "CARRY", "putdwn105", 4.1, 0, 0, 0, 0, 0, 1);
			SetTimerEx("PlayerCarryCrate", 700, false, "iiii", playerid, boxid, VehFound, 3);
		}
		else SendClientMessageEx(playerid, COLOR_GRAD2, "Your not in possession of any crates that you can store!");
		return 1;
	}
	else if(strcmp(choice, "take", true) == 0) {
		szMiscArray[0] = 0;
		new Float:vPos[3], inveh = GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet ,boot, objective, VehFound = -1;
		
		for(new i = 0; i < MAX_CRATE_VEHCILES; i++) {
			if(CrateVehicle[i][cvSpawnID] != INVALID_VEHICLE_ID) {
				GetPosBehindVehicle(CrateVehicle[i][cvSpawnID], vPos[0], vPos[1], vPos[2], (IsAPlane(CrateVehicle[i][cvSpawnID]) ? -8 : 0));
				if(IsPlayerInRangeOfPoint(playerid, (IsAPlane(CrateVehicle[i][cvSpawnID]) ? 6 : 2), vPos[0], vPos[1], vPos[2])) {
					if(CrateVehicle[i][cvSpawnID] != inveh) {
						VehFound = i; // Do not use the vehicle ID as we store the array ID for the validation since vehicles do not store "spawn id".
						break;
					}
				}
			}
		}
		if(VehFound == -1) return SendClientMessageEx(playerid, COLOR_GRAD2, "You're not near any designated vehicles that can transport crates!");
		if(!CreateCount(VehFound)) return SendClientMessageEx(playerid, COLOR_GRAD3, "There are no crates in the vehicle to take!");
		if(VehDelivering[VehFound]) return SendClientMessageEx(playerid, COLOR_GRAD3, "This vehicle is currently unloading crates - Please Wait!");
		GetVehicleParamsEx(CrateVehicle[VehFound][cvSpawnID], engine, lights, alarm, doors, bonnet, boot, objective);
		if(inveh > 0 && GetVehicleModel(inveh) == 530) { // Vehicle -> Forklift
			if(IsDynamicCrateVehicle(inveh) == -1) return SendClientMessageEx(playerid, COLOR_GRAD2, "You're not in the designated forklift vehicle to unload crates with!");
			if(CrateVehicle[IsDynamicCrateVehicle(inveh)][cvCrate] != -1) return SendClientMessageEx(playerid, COLOR_GRAD2, "There is already a crate loaded on the forklift!");
			if(!IsAPlane(CrateVehicle[VehFound][cvSpawnID])) {
				if((boot == VEHICLE_PARAMS_OFF || boot == VEHICLE_PARAMS_UNSET)) return SendClientMessageEx(playerid, COLOR_GRAD3, "You can't unload crates whilst the trunk is closed! - '/car trunk' to open it.");
			}
			for(new b = 0; b < MAX_CRATES; b++) {
				if(CrateBox[b][cbInVeh] == VehFound) {
					CrateBox[b][cbInVeh] = -1;
					CrateBox[b][cbOnVeh] = b;
					CrateVehicle[IsDynamicCrateVehicle(inveh)][cvCrate] = b;
					SaveCrateVehicle(IsDynamicCrateVehicle(inveh));
					SaveCrate(b);
					CrateVehCheck(IsDynamicCrateVehicle(inveh));
					UpdateCrateBox(b);
					Streamer_Update(playerid);
					format(szMiscArray, sizeof(szMiscArray), "* %s has unloaded a crate from the %s.", GetPlayerNameEx(playerid), GetVehicleName(CrateVehicle[VehFound][cvSpawnID]));
					ProxDetector(25.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
					break;
				}
			}
		}
		else if(CarryCrate[playerid] == -1) { // Player -> Vehicle
			if(IsAPlane(CrateVehicle[VehFound][cvSpawnID])) return SendClientMessageEx(playerid, COLOR_GRAD2, "You need a forklift to unload crates from planes!");
			if((boot == VEHICLE_PARAMS_OFF || boot == VEHICLE_PARAMS_UNSET)) return SendClientMessageEx(playerid, COLOR_GRAD3, "You can't unload crates whilst the trunk is closed! - '/car trunk' to open it.");
			for(new b = 0; b < MAX_CRATES; b++) {
				if(CrateBox[b][cbInVeh] == VehFound) {
					ApplyAnimation(playerid, "CARRY", "liftup105", 4.1, 0, 0, 0, 0, 0, 1);
					SetTimerEx("PlayerCarryCrate", 700, false, "iiii", playerid, b, VehFound, 2);
					break;
				}
			}
		}
		else SendClientMessageEx(playerid, COLOR_GRAD2, "You're already in possession of a crate!");
		return 1;
	}
	else if(strcmp(choice, "drop", true) == 0) {
		new vehicleid = GetPlayerVehicleID(playerid), veh, boxid, area;
		FetchFacility(playerid, area, 50.0);
		if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD2, "You need to be in a vehicle to do this!");
		if(GetVehicleModel(vehicleid) != 530) return SendClientMessageEx(playerid, COLOR_GRAD2, "You need to be a forklift to drop a crate!");
		if((veh = IsDynamicCrateVehicle(vehicleid)) == -1) return SendClientMessageEx(playerid, COLOR_GRAD2, "You're not in the designated vehicle for this operation!");
		if((boxid = CrateVehicle[veh][cvCrate]) == -1) return SendClientMessageEx(playerid, COLOR_GRAD2, "There is no crate attached to this forklift!");
		if(CrateBox[boxid][cbTransfer]) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can't drop the crate it must be loaded into a vehicle first!");
		if(area != -1) return SendClientMessageEx(playerid, COLOR_GRAD2, "Crates cannot be unloaded near crate facilities!");

	    new Float: vPos[3];
	    GetVehiclePos(vehicleid, vPos[0], vPos[1], vPos[2]);
	    GetXYInFrontOfPlayer(playerid, vPos[0], vPos[1], 2);
		CrateBox[boxid][cbOnVeh] = -1;
		CrateVehicle[veh][cvCrate] = -1;
		CrateBox[boxid][cbPos][0] = vPos[0];
		CrateBox[boxid][cbPos][1] = vPos[1];
		CrateBox[boxid][cbPos][2] = vPos[2]-0.8;
		CrateBox[boxid][cbInt] = GetPlayerInterior(playerid);
		CrateBox[boxid][cbVw] = GetPlayerVirtualWorld(playerid);
		CrateBox[boxid][cbPlacedBy] = GetPlayerNameEx(playerid);
		format(string, sizeof(string), "* %s has unloaded the crate from the forklift.", GetPlayerNameEx(playerid));
		ProxDetector(25.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		SaveCrateVehicle(veh);
		SaveCrate(boxid);
		CrateVehCheck(veh);
		UpdateCrateBox(boxid);
		Streamer_Update(playerid);
		return 1;
	}
	else if(strcmp(choice, "destroy", true) == 0 && PlayerInfo[playerid][pAdmin] > 3) {
		if(crate == -1) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /crate destroy [id]");
		if(0 <= crate < MAX_CRATES) {
			if(!CrateBox[crate][cbActive]) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can't destroy a crate that isn't active!");
			SendClientMessageEx(playerid, COLOR_WHITE, "You have destroyed crate ID: %d", crate);
			DestroyCrate(crate);
		}
		else SendClientMessageEx(playerid, COLOR_YELLOW, "Invalid crate ID - Can't be lower than 0 or higher than %d.", MAX_CRATES-1);
		return 1;
	}
	else if(strcmp(choice, "spawn", true) == 0 && PlayerInfo[playerid][pAdmin] > 3) {
		if(crate == -1) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /crate spawn [id]"), SendClientMessageEx(playerid, COLOR_GREY, "NOTE: The ID must be a facility ID not a crate ID!");
		if(0 <= crate < MAX_CRATE_FACILITY) {
			new Float: pcbPos[3];
			GetPlayerPos(playerid, pcbPos[0], pcbPos[1], pcbPos[2]);
			GetXYInFrontOfPlayer(playerid, pcbPos[0], pcbPos[1], 1);
			if(CrateFacility[crate][cfPos][0] != 0.0 && CrateFacility[crate][cfActive]) {
				if(CrateFacility[crate][cfProdReady] > 0) {
					for(new c = 0; c < MAX_CRATES; c++) {
						if(CrateBox[c][cbFacility] == -1 && CrateBox[c][cbGroup] == -1) {
							CrateBox[c][cbLifespan] = 7200;
							CrateBox[c][cbFacility] = crate;
							CrateBox[c][cbGroup] = -1;
							CrateBox[c][cbTransfer] = 0;
							CrateBox[c][cbPrice] = 0;
							CrateBox[c][cbMats] = 50;
							CrateBox[c][cbActive] = 1;
							--CrateFacility[crate][cfProdReady];
							CrateBox[c][cbPos][0] = pcbPos[0];
							CrateBox[c][cbPos][1] = pcbPos[1];
							CrateBox[c][cbPos][2] = pcbPos[2]-1.0;
							CrateBox[c][cbInt] = GetPlayerInterior(playerid);
							CrateBox[c][cbVw] = GetPlayerVirtualWorld(playerid);
							CrateBox[c][cbPlacedBy] = GetPlayerNameEx(playerid);
							CrateBox[c][cbPaid] = 1;
							SaveCrate(c);
							SaveFacility(crate);
							UpdateCrateBox(c);
							Streamer_Update(playerid);
							SendClientMessageEx(playerid, COLOR_WHITE, "You've spawned a crate at your position!");
							return 1;
						}
					}
					return SendClientMessageEx(playerid, COLOR_GRAD2, "ERROR: Unable to spawn crate as non are available!");
				} else {
					SendClientMessageEx(playerid, COLOR_GRAD2, "Error: Crate facility specified has crates available!");
				}
			} else {
				SendClientMessageEx(playerid, COLOR_GRAD2, "Error: Crate facility specified is either not in use or is not active!");
			}
		}
		else SendClientMessageEx(playerid, COLOR_YELLOW, "Invalid Facility ID - Can't be lower than 0 or higher than %d.", MAX_CRATE_FACILITY-1);
		return 1;
	}
	else if(strcmp(choice, "orders", true) == 0) {
		new fac;
		if(!ValidGroup(PlayerInfo[playerid][pMember])) return SendClientMessage(playerid, COLOR_GRAD2, "You need to be apart of a group to use this command!");
		GetFacility(PlayerInfo[playerid][pMember], fac);
		if(fac == -1) return SendClientMessage(playerid, COLOR_GRAD2, "Your group doesn't own a facility!");
		format(szMiscArray, sizeof(szMiscArray), "Group\tCrates (Total Cost)\tDelivered (Money Earned)\n");
		for(new o = 0; o < MAX_GROUPS; o++) {
			if(CrateOrder[o][coFacility] == fac && CrateOrder[o][coStatus] > 0) {
				format(szMiscArray, sizeof(szMiscArray), "%s%s\t%d ($%s)\t%d ($%s)\n", szMiscArray, arrGroupData[o][g_szGroupName], CrateOrder[o][coCrates], number_format((CrateOrder[o][coCrates] * CrateOrder[o][coPerCrate])), CrateOrder[o][coDelivered], number_format((CrateOrder[o][coDelivered] * CrateOrder[o][coPerCrate])));
			}
		}
		if(strlen(szMiscArray) == 51) return SendClientMessageEx(playerid, COLOR_LIGHTRED, "%s: There are no crate orders pending!", CrateFacility[fac][cfName]);
		Dialog_Show(playerid, -1, DIALOG_STYLE_TABLIST_HEADERS, "Crate Orders", szMiscArray, "Close", "");
	}
	else if(strcmp(choice, "seize", true) == 0) {
		new fac;
		GetCrateBox(playerid, box, 2.0);
		GetFacility(PlayerInfo[playerid][pMember], fac);
		if(fac == -1) return SendClientMessage(playerid, COLOR_GRAD2, "Your group doesn't own a facility!");
		if(CrateFacilityRaid[fac]) return SendClientMessage(playerid, COLOR_GRAD2, "Error: You can't use this command during a raid session.");
		if(box == -1) return SendClientMessageEx(playerid, COLOR_GREY, "You're not near any crate boxes to seize!");
		if(CrateBox[box][cbFacility] != fac) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can't seize a crate that doesn't belong to your facility!");
		DestroyCrate(box);
		format(szMiscArray, sizeof(szMiscArray), "* %s has seized a crate box!", GetPlayerNameEx(playerid));
		ProxDetector(25.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	}
	else SendClientMessageEx(playerid, COLOR_GRAD2, "Unknown choice selected!");
	return 1;
}

stock CreateCount(veh) {
	new amount = 0;
	for(new c = 0; c < MAX_CRATES; c++) {
		if(CrateBox[c][cbInVeh] == veh) {
			++amount;
		}
	}
	return amount;
}

CMD:cfnext(playerid, params[]) {
	if(PlayerInfo[playerid][pAdmin] > 3 || PlayerInfo[playerid][pASM] > 0 || PlayerInfo[playerid][pFactionModerator] > 0) {
		for(new f = 0; f < MAX_CRATE_FACILITY; f++) {
			if(CrateFacility[f][cfPos][0] == 0.0) {
				SendClientMessageEx(playerid, COLOR_YELLOW, "Next crate facility available for use: %d", f);
				break;
			}
		}
	}
	return 1;
}

CMD:gotocrate(playerid, params[]) {
	if(PlayerInfo[playerid][pAdmin] > 3 || PlayerInfo[playerid][pASM] > 0 || PlayerInfo[playerid][pFactionModerator] > 0) {
		new id, Float:pos[3];
		if(sscanf(params, "i", id)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /gotocrate [id]");
		if(!(0 <= id < MAX_CRATES)) return SendClientMessageEx(playerid, COLOR_GREY, "Invalid crate ID. (0 - %d)", MAX_CRATES-1);
		if(!CrateBox[id][cbActive]) return SendClientMessageEx(playerid, COLOR_GREY, "ERROR: The crate box isn't active.");
		/*
		foreach(new i: Player) {
			if(CarryCrate[i] == id) {
				GetPlayerPos(i, pos[0], pos[1], pos[2]);
				SetPlayerPos(playerid, pos[0], pos[1], pos[2]+1.0);
				SetPlayerInterior(playerid, GetPlayerInterior(i));
				PlayerInfo[playerid][pInt] = GetPlayerInterior(i);
				SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(i));
				PlayerInfo[playerid][pVW] = GetPlayerVirtualWorld(i);
				if(GetPlayerInterior(i) > 0) Player_StreamPrep(playerid, pos[0], pos[1], pos[2]+1.0, FREEZE_TIME);
				SendClientMessageEx(playerid, COLOR_WHITE, "You have teleported to crate %d.", id);
				return 1;
			}
		}*/
		if(BeingMoved[id] != INVALID_PLAYER_ID) {
			GetPlayerPos(BeingMoved[id], pos[0], pos[1], pos[2]);
			SetPlayerPos(playerid, pos[0], pos[1], pos[2]+1.0);
			SetPlayerInterior(playerid, GetPlayerInterior(BeingMoved[id]));
			PlayerInfo[playerid][pInt] = GetPlayerInterior(BeingMoved[id]);
			SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(BeingMoved[id]));
			PlayerInfo[playerid][pVW] = GetPlayerVirtualWorld(BeingMoved[id]);
			if(GetPlayerInterior(BeingMoved[id]) > 0) Player_StreamPrep(playerid, pos[0], pos[1], pos[2]+1.0, FREEZE_TIME);
			SendClientMessageEx(playerid, COLOR_WHITE, "You have teleported to crate %d. (It's currently being carried by %s)", id, GetPlayerNameEx(BeingMoved[id]));
			return 1;
		}
		if(CrateBox[id][cbInVeh] != -1) {
			GetVehiclePos(CrateVehicle[CrateBox[id][cbInVeh]][cvSpawnID], pos[0], pos[1], pos[2]);
			SetPlayerPos(playerid, pos[0], pos[1], pos[2]+1.0);
			SetPlayerInterior(playerid, CrateVehicle[CrateBox[id][cbInVeh]][cvInt]);
			PlayerInfo[playerid][pInt] =CrateVehicle[CrateBox[id][cbInVeh]][cvInt];
			SetPlayerVirtualWorld(playerid, CrateVehicle[CrateBox[id][cbInVeh]][cvVw]);
			PlayerInfo[playerid][pVW] = CrateVehicle[CrateBox[id][cbInVeh]][cvVw];	
			if(CrateVehicle[CrateBox[id][cbInVeh]][cvInt] > 0) Player_StreamPrep(playerid, pos[0], pos[1], pos[2]+1.0, FREEZE_TIME);
			SendClientMessageEx(playerid, COLOR_WHITE, "You have teleported to crate %d.", id);
			return 1;
		}
		if(CrateBox[id][cbOnVeh] != -1) {
			GetVehiclePos(CrateVehicle[CrateBox[id][cbOnVeh]][cvSpawnID], pos[0], pos[1], pos[2]);
			SetPlayerPos(playerid, pos[0], pos[1], pos[2]+1.0);
			SetPlayerInterior(playerid, CrateVehicle[CrateBox[id][cbOnVeh]][cvInt]);
			PlayerInfo[playerid][pInt] =CrateVehicle[CrateBox[id][cbOnVeh]][cvInt];
			SetPlayerVirtualWorld(playerid, CrateVehicle[id][cvVw]);
			PlayerInfo[playerid][pVW] = CrateVehicle[CrateBox[id][cbOnVeh]][cvVw];	
			if(CrateVehicle[CrateBox[id][cbOnVeh]][cvInt] > 0) Player_StreamPrep(playerid, pos[0], pos[1], pos[2]+1.0, FREEZE_TIME);
			SendClientMessageEx(playerid, COLOR_WHITE, "You have teleported to crate %d.", id);
			return 1;
		}
		SetPlayerPos(playerid, CrateBox[id][cbPos][0], CrateBox[id][cbPos][1], CrateBox[id][cbPos][2]+1.0);
		SetPlayerInterior(playerid, CrateBox[id][cbInt]);
		PlayerInfo[playerid][pInt] = CrateBox[id][cbInt];
		SetPlayerVirtualWorld(playerid, CrateBox[id][cbVw]);
		PlayerInfo[playerid][pVW] = CrateBox[id][cbVw];	
		if(CrateBox[id][cbInt] > 0) Player_StreamPrep(playerid, CrateBox[id][cbPos][0], CrateBox[id][cbPos][1], CrateBox[id][cbPos][2]+1.0, FREEZE_TIME);
		SendClientMessageEx(playerid, COLOR_WHITE, "You have teleported to crate %d.", id);
	}
	else SendClientMessageEx(playerid, COLOR_GREY, "Your are not authorized to use this command!");
	return 1;
}

CMD:cfname(playerid, params[]) {
	if(PlayerInfo[playerid][pAdmin] > 3 || PlayerInfo[playerid][pASM] > 0 || PlayerInfo[playerid][pFactionModerator] > 0) {
		new id, name[50];
		if(sscanf(params, "is[50]", id, name)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /cfname [facility] [name]");
		if(!(0 <= id < MAX_CRATE_FACILITY)) return SendClientMessageEx(playerid, COLOR_GREY, "Invalid facility ID.");
		if(!(0 < strlen(name) < 50)) return SendClientMessageEx(playerid, COLOR_GRAD2, "Name must be between 1 - 50 character long in length!");
		format(szMiscArray, sizeof(szMiscArray), "%s has set %d facility name from %s to %s.", GetPlayerNameEx(playerid), id, CrateFacility[id][cfName], name);
		strcpy(CrateFacility[id][cfName], name, 50);
		Log("logs/cfedit.log", szMiscArray);
		SendClientMessageEx(playerid, COLOR_WHITE, "You have set the facility name to %s.", name);
		SaveFacility(id);
		UpdateFacility(id);
	}
	else SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use this command!");
	return 1;
}

CMD:cfedit(playerid, params[]) {
	if(PlayerInfo[playerid][pAdmin] > 3 || PlayerInfo[playerid][pASM] > 0 || PlayerInfo[playerid][pFactionModerator] > 0) {
		new id, name[32], value;
		if(sscanf(params, "s[32]iD(-1)", name, id, value)) {
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /cfedit [name] [id] [value]");
			SendClientMessageEx(playerid, COLOR_GREY, "Names: pos, crates, timer, prodstatus, cost, active");
			SendClientMessageEx(playerid, COLOR_GREY, "Names: owner, raidable, multiplier, delete");
			return 1;
		}
		if(!(0 <= id < MAX_CRATE_FACILITY)) return SendClientMessageEx(playerid, COLOR_GREY, "Invalid facility ID.");
		if(strcmp(name, "pos", true) == 0) {
			new Float:pos[3];
			GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
			format(szMiscArray, sizeof(szMiscArray), "%s has moved %d crate facility (B: %f, %f, %f Int: %d, VW: %d | A: %f, %f, %f Int: %d, VW: %d)", GetPlayerNameEx(playerid), id, CrateFacility[id][cfPos][0], CrateFacility[id][cfPos][1], CrateFacility[id][cfPos][2], CrateFacility[id][cfInt], CrateFacility[id][cfVw], pos[0], pos[1], pos[2], GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
			Log("logs/cfedit.log", szMiscArray);
			CrateFacility[id][cfPos][0] = pos[0];
			CrateFacility[id][cfPos][1] = pos[1];
			CrateFacility[id][cfPos][2] = pos[2]-1.0;
			CrateFacility[id][cfInt] = GetPlayerInterior(playerid);
			CrateFacility[id][cfVw] = GetPlayerVirtualWorld(playerid);
			if(CrateFacility[id][cfCooldown] == 0) {
				CrateFacility[id][cfCooldown] = gettime()+10800;
			}
			SendClientMessageEx(playerid, COLOR_WHITE, "You have moved %d crate facility to your location!", id);
			SaveFacility(id);
			UpdateFacility(id);
			return 1;
		}
		else if(strcmp(name, "crates", true) == 0) {
			if(value < 1) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can't set the max production lower than 1!");
			if(value > GetMaxProduction()) return SendClientMessageEx(playerid, COLOR_GRAD2, "Your unable to set the production to %d as there's only %d slots left!", id, GetMaxProduction());
			format(szMiscArray, sizeof(szMiscArray), "%s has set %d facility max production from %d to %d.", GetPlayerNameEx(playerid), id, CrateFacility[id][cfProdMax], value);
			Log("logs/cfedit.log", szMiscArray);
			CrateFacility[id][cfProdMax] = value;
			if(CrateFacility[id][cfProdReady] > CrateFacility[id][cfProdMax]) {
				CrateFacility[id][cfProdReady] = value;
			}
			UpdateFacility(id);
			SaveFacility(id);
			SendClientMessageEx(playerid, COLOR_WHITE, "You have set crate facility %d to max production to %d", id, value);
			return 1;
		}
		else if(strcmp(name, "timer", true) == 0) {
			if(value == -1) return SendClientMessageEx(playerid, COLOR_GRAD2, "Specify in seconds how long a crate will take to be created.");
			if(value < 1) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can't set the max production timer lower than 1!");
			format(szMiscArray, sizeof(szMiscArray), "%s has set %d facility production timer from %d to %d seconds.", GetPlayerNameEx(playerid), id, CrateFacility[id][cfProdTimer], value);
			Log("logs/cfedit.log", szMiscArray);
			CrateFacility[id][cfProdTimer] = value;
			SaveFacility(id);
			SendClientMessageEx(playerid, COLOR_WHITE, "You have set crate facility %d production to %d seconds.", id, value);
			return 1;
		}
		else if(strcmp(name, "prodstatus", true) == 0) {
			if(value == -1) return SendClientMessageEx(playerid, COLOR_GRAD2, "0 - Disable | 1 - Active");
			if(!(0 <= value < 2)) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can only choose the following: 0 - Disable | 1 - Active");
			format(szMiscArray, sizeof(szMiscArray), "%s has set %d facility production status from %s to %s.", GetPlayerNameEx(playerid), id, (CrateFacility[id][cfProdStatus]) ? ("Active") : ("Paused"), (value) ? ("Active") : ("Disabled"));
			Log("logs/cfedit.log", szMiscArray);
			CrateFacility[id][cfProdStatus] = value;
			SaveFacility(id);
			SendClientMessageEx(playerid, COLOR_WHITE, "You have set crate facility %d production status to %s.", id, (value) ? ("Active") : ("Paused"));
			return 1;
		}
		else if(strcmp(name, "cost", true) == 0) {
			if(value < 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can't set the crate cost lower than 0!");
			format(szMiscArray, sizeof(szMiscArray), "%s has set %d facility production cost per crate from $%s to $%s.", GetPlayerNameEx(playerid), id, number_format(CrateFacility[id][cfProdCost]), number_format(value));
			Log("logs/cfedit.log", szMiscArray);
			CrateFacility[id][cfProdCost] = value;
			SaveFacility(id);
			SendClientMessageEx(playerid, COLOR_WHITE, "You have set the facility %d to cost $%s per crate.", id, number_format(value));
			return 1;
		}
		else if(strcmp(name, "active", true) == 0) {
			if(value == -1) return SendClientMessageEx(playerid, COLOR_GRAD2, "0 - Disable | 1 - Active");
			if(!(0 <= value < 2)) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can only choose the following: 0 - Disable | 1 - Active");
			format(szMiscArray, sizeof(szMiscArray), "%s has set %d facility status from %s to %s.", GetPlayerNameEx(playerid), id, (CrateFacility[id][cfActive]) ? ("Active") : ("Disabled"), (value) ? ("Active") : ("Disabled"));
			Log("logs/cfedit.log", szMiscArray);
			CrateFacility[id][cfActive] = value;
			SaveFacility(id);
			SendClientMessageEx(playerid, COLOR_WHITE, "You have set crate facility %d status to %s.", id, (value) ? ("Active") : ("Disabled"));
			return 1;
		}
		else if(strcmp(name, "cooldown", true) == 0) {
			if(CrateFacility[id][cfRaidTimer] != 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "ERROR: There is a raid on-going, try again after %s.", date(CrateFacility[id][cfRaidTimer], 1));
			if(value < 1) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can't set the cooldown lower than 1 second!");
			CrateFacility[id][cfCooldown] = gettime()+value;
			SaveFacility(id);
			SendClientMessageEx(playerid, COLOR_WHITE, "You have set crate facility %d cooldown to %d.", id, value);
			return 1;
		}
		else if(strcmp(name, "raid", true) == 0) {
			if(CrateFacility[id][cfRaidTimer] == 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "There is no raid on-going.");
			if(value < 1) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can't set the raid timer lower than 1 second!");
			CrateFacility[id][cfRaidTimer] = gettime()+value;
			SaveFacility(id);
			SendClientMessageEx(playerid, COLOR_WHITE, "You have set crate facility %d raid timer to %d.", id, value);
			return 1;
		}
		else if(strcmp(name, "multiplier", true) == 0) {
			if(value < 1) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can't set the crate multiplier lower than 1!");
			format(szMiscArray, sizeof(szMiscArray), "%s has set %d facility crate delivery multiplier from %d to %d.", GetPlayerNameEx(playerid), id, CrateFacility[id][cfProdMulti], value);
			Log("logs/cfedit.log", szMiscArray);
			CrateFacility[id][cfProdMulti] = value;
			SaveFacility(id);
			SendClientMessageEx(playerid, COLOR_WHITE, "You have set crate facility %d delivery multiplier to %d.", id, value);
			return 1;
		}
		else if(strcmp(name, "raidable", true) == 0) {
			if(!(0 <= value < 2)) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can only choose the following: 0 - Disable | 1 - Active");
			if(CrateFacility[id][cfRaidTimer] != 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "ERROR: There is a raid on-going, try again after %s.", date(CrateFacility[id][cfRaidTimer], 1));
			if(value && !CrateFacility[id][cfRaidable]) CrateFacility[id][cfCooldown] = gettime()+10800;
			format(szMiscArray, sizeof(szMiscArray), "%s has set %d facility raidable status from %s to %s.", GetPlayerNameEx(playerid), id, (CrateFacility[id][cfRaidable]) ? ("Active") : ("Disabled"), (value) ? ("Active") : ("Disabled"));
			Log("logs/cfedit.log", szMiscArray);
			CrateFacility[id][cfRaidable] = value;
			SaveFacility(id);
			SendClientMessageEx(playerid, COLOR_WHITE, "You have set crate facility %d raid status to %s.", id, (value) ? ("Active") : ("Disabled"));
			return 1;
		}
		else if(strcmp(name, "owner", true) == 0) {
			new fac;
			GetFacility(value, fac);
			if(value == -1) {
				if(CrateFacility[id][cfGroup] == -1) return SendClientMessageEx(playerid, COLOR_GRAD2, "No group is currently assigned to this facility!");
				format(szMiscArray, sizeof(szMiscArray), "%s has removed %s's ownership over %s facility (ID: %d).", GetPlayerNameEx(playerid), arrGroupData[CrateFacility[id][cfGroup]][g_szGroupName], CrateFacility[id][cfName], id);
				Log("logs/cfedit.log", szMiscArray);
				SendClientMessageEx(playerid, COLOR_YELLOW, "You have removed %s's ownership over %s facility (ID: %d).", arrGroupData[CrateFacility[id][cfGroup]][g_szGroupName], CrateFacility[id][cfName], id);
				DeleteOrder(id, "The crate facility ownership was removed.");
				CrateFacility[id][cfGroup] = -1;
			} else {
				if(!(0 <= value < MAX_GROUPS)) return SendClientMessageEx(playerid, COLOR_GRAD2, "Invalid group Id. (0 - %d)", MAX_GROUPS);
				if(CrateFacility[id][cfPos][0] == 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can't assign a group to facility %d it's currently not in use.", id);
				if(fac != -1) {
					format(szMiscArray, sizeof(szMiscArray), "%s was removed from %s facility (ID: %d) to prevent duplicate ownership.", arrGroupData[CrateFacility[fac][cfGroup]][g_szGroupName], CrateFacility[fac][cfName], fac);
					Log("logs/cfedit.log", szMiscArray);
					SendClientMessageEx(playerid, COLOR_YELLOW, "%s ownership was removed from %s facility (ID: %d) as they can only own 1 faciltiy at a time!", arrGroupData[CrateFacility[fac][cfGroup]][g_szGroupName], CrateFacility[fac][cfName], fac);
					DeleteOrder(fac, "The crate facility ownership was removed.");
					CrateFacility[fac][cfGroup] = -1;
				}
				CrateFacility[id][cfGroup] = value;
				format(szMiscArray, sizeof(szMiscArray), "%s has assigned %s's ownership over %s facility (ID: %d).", GetPlayerNameEx(playerid), arrGroupData[value][g_szGroupName], CrateFacility[id][cfName], id);
				Log("logs/cfedit.log", szMiscArray);
				SendClientMessageEx(playerid, COLOR_YELLOW, "You have assigned %s ownership over %s facility (ID: %d).", arrGroupData[value][g_szGroupName], CrateFacility[id][cfName], id);
			}
			return 1;
		}
		else if(strcmp(name, "delete", true) == 0) {
			if(CrateFacility[id][cfPos][0] == 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can't delete a non-active facility!");
			DeleteOrder(id, "Crate facility has been deleted.");
			for(new c = 0; c < MAX_CRATES; c++) {
				if(CrateBox[c][cbFacility] == id) {
					DestroyCrate(c);
				}
			}
			for(new g = 0; g < MAX_GATES; g++) {
				if(GateInfo[g][gFacility] == id) {
					GateInfo[g][gFacility] = -1;
					SaveGate(g);
				}
			}
			AdminOpened[id] = 0; // Disable by default.
			CrateBeingProcessed[id] = 0;
			format(CrateFacility[id][cfName], 4, "----");
			CrateFacility[id][cfGroup] = -1;
			CrateFacility[id][cfPos][0] = 0.00000;
			CrateFacility[id][cfPos][1] = 0.00000;
			CrateFacility[id][cfPos][2] = 0.00000;
			CrateFacility[id][cfPos][3] = 0.00000;
			CrateFacility[id][cfInt] = 0;
			CrateFacility[id][cfVw] = 0;
			CrateFacility[id][cfProdMax] = 0;
			CrateFacility[id][cfProdPrep] = 0;
			CrateFacility[id][cfProdReady] = 0;
			CrateFacility[id][cfProdTimer] = 0;
			CrateFacility[id][cfProdStatus] = 0;
			CrateFacility[id][cfProdCost] = 0;
			CrateFacility[id][cfProdMulti] = 1;
			CrateFacility[id][cfRaidTimer] = 0;
			CrateFacility[id][cfCooldown] = 0;
			CrateFacility[id][cfRaidable] = 1;
			CrateFacility[id][cfActive] = 0;
			CrateFacility[id][cfTimer] = 0;
			CrateFacilityRaid[id] = 0;
			UpdateFacility(id);
			SaveFacility(id);
			SendClientMessageEx(playerid, COLOR_WHITE, "You have deleted crate facility %d", id);
			format(szMiscArray, sizeof(szMiscArray), "%s has deleted facility id %d.", GetPlayerNameEx(playerid), id);
			Log("logs/cfedit.log", szMiscArray);
			return 1;
		}
		else SendClientMessageEx(playerid, COLOR_GREY, "Invalid name given.");
	}
	else SendClientMessageEx(playerid, COLOR_GREY, "Your are not authorized to use this command!");
	return 1;
}

stock DeleteOrder(facility, reason[]) {
	szMiscArray[0] = 0;
	for(new g = 0; g < MAX_GROUPS; g++) {
		if(CrateOrder[g][coFacility] == facility) {
			new refund = ((CrateOrder[g][coCrates] - CrateOrder[g][coDelivered]) * CrateOrder[g][coPerCrate]);
			foreach(new p: Player) {
				if(PlayerInfo[p][pMember] == CrateFacility[CrateOrder[g][coFacility]][cfGroup]) {
					SendClientMessageEx(p, COLOR_LIGHTRED, "%s order was auto canceled; %d/%d crates were delivered earning: $%s.", arrGroupData[g][g_szGroupName], CrateOrder[g][coDelivered], CrateOrder[g][coCrates], number_format(CrateOrder[g][coDelivered] * CrateOrder[g][coPerCrate]));
					SendClientMessageEx(p, COLOR_LIGHTRED, "Reason: %s", reason);
				}
				if(PlayerInfo[p][pLeader] == g) {
					SendClientMessageEx(p, COLOR_LIGHTRED, "* Your crate order was auto canceled; %d/%d crates were delivered costing: $%s", CrateOrder[g][coDelivered], CrateOrder[g][coCrates], number_format(CrateOrder[g][coDelivered] * CrateOrder[g][coPerCrate]));
					SendClientMessageEx(p, COLOR_LIGHTRED, "* $%s was refunded back into the vault for undelivered crates.", number_format(refund));
					SendClientMessageEx(p, COLOR_LIGHTRED, "* Reason: %s", reason);
				}
			}
			format(szMiscArray, sizeof(szMiscArray), "Your crate order was auto canceled ; %d/%d crates were delivered costing: $%s ($%s was refunded)", CrateOrder[g][coDelivered], CrateOrder[g][coCrates], number_format(CrateOrder[g][coDelivered] * CrateOrder[g][coPerCrate]), number_format(refund));
			format(szMiscArray, sizeof(szMiscArray), "%sReason: %s", szMiscArray, reason);
			GroupPayLog(g, szMiscArray);
			SetGroupBudget(g, refund);
			format(szMiscArray, sizeof(szMiscArray), "%s order was auto canceled; %d/%d crates were delivered adding: $%s.", arrGroupData[g][g_szGroupName], CrateOrder[g][coDelivered], CrateOrder[g][coCrates], number_format(CrateOrder[g][coDelivered] * CrateOrder[g][coPerCrate]), number_format(refund));
			format(szMiscArray, sizeof(szMiscArray), "%sReason: %s", szMiscArray, reason);
			GroupPayLog(CrateFacility[CrateOrder[g][coFacility]][cfGroup], szMiscArray);
			SetGroupBudget(CrateFacility[CrateOrder[g][coFacility]][cfGroup], (CrateOrder[g][coDelivered] * CrateOrder[g][coPerCrate]));
			ResetOrder(g);
			SaveGroup(g);
		}
	}
	return 1;
}

stock GetMaxProduction() {
	new total = 0;
	for(new f = 0; f < MAX_CRATE_FACILITY; f++) {
		total += CrateFacility[f][cfProdMax];
	}
	return (MAX_CRATES - total);
}

CMD:ordercrates(playerid, params[]) {
	new group = PlayerInfo[playerid][pMember];
	if(ValidGroup(group)) {
		if(!IsGroupLeader(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD2, "You need to be a group leader to order crates!");
		if(IsACriminal(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD2, "You're unable to order crates from any facility.");
		//if(CrateOrder[group][coFacility] != -1 && CrateOrder[group][coStatus] > 1 && CrateOrder[group][coTime] > gettime()) return SendClientMessageEx(playerid, COLOR_GRAD2, "Your order is currently being processed; You can cancel it after %s", date(CrateOrder[group][coTime], 1));
		if(!CrateOrder[group][coStatus]) {
			PrepOrder(playerid, group);
		} else {
			CancelOrder(playerid);
		}
	}
	else SendClientMessageEx(playerid, COLOR_GRAD2, "You need to be a group use this command!");
	return 1;
}

stock CancelOrder(playerid) {
	szMiscArray[0] = 0;
	if(!IsGroupLeader(playerid)) return 1;
	new group = PlayerInfo[playerid][pMember];
	new refund = ((CrateOrder[group][coCrates] - CrateOrder[group][coDelivered]) * CrateOrder[group][coPerCrate]);
	format(szMiscArray, sizeof(szMiscArray), "Are you sure you want to cancel the order you made at %s?\n", CrateFacility[CrateOrder[group][coFacility]][cfName]);
	format(szMiscArray, sizeof(szMiscArray), "%sPlease see transaction information below:\n\n", szMiscArray);
	format(szMiscArray, sizeof(szMiscArray), "%sCrates Ordered: %d\nTotal Cost: $%s\nCrates Delivered: %d\nTotal Spent: $%s\nOrdered By: %s\nTotal to Refund: $%s.\n\n", szMiscArray, CrateOrder[group][coCrates], number_format((CrateOrder[group][coCrates] * CrateOrder[group][coPerCrate])), CrateOrder[group][coDelivered], number_format((CrateOrder[group][coDelivered] * CrateOrder[group][coPerCrate])), CrateOrder[group][coOrderBy], number_format(refund));
	format(szMiscArray, sizeof(szMiscArray), "%sPress 'Confirm' to cancel further crates from being delivered.", szMiscArray, number_format(refund));
	return Dialog_Show(playerid, order_refund, DIALOG_STYLE_MSGBOX, "Cancel Order?", szMiscArray, "Confirm", "Exit");
}

Dialog:order_refund(playerid, response, listitem, inputtext[]) {
	if(!IsGroupLeader(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD2, "You need to be a group leader to order crates!");
	new group = PlayerInfo[playerid][pMember];
	if(response) {
		if(!CrateOrder[group][coStatus]) return SendClientMessageEx(playerid, COLOR_RED, "ERROR: You don't have any crate orders pending!");
		new refund = ((CrateOrder[group][coCrates] - CrateOrder[group][coDelivered]) * CrateOrder[group][coPerCrate]), type = (arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance] == 2) ? 8 : 5;
		if(CrateFacility[CrateOrder[group][coFacility]][cfGroup] == PlayerInfo[playerid][pMember]) {
			foreach(new p: Player) {
				if(PlayerInfo[p][pMember] == type) {
					SendClientMessageEx(p, COLOR_LIGHTRED, "%s has canceled their own order; %d/%d crates were delivered earning: $%s.", arrGroupData[group][g_szGroupName], CrateOrder[group][coDelivered], CrateOrder[group][coCrates], number_format(CrateOrder[group][coDelivered] * CrateOrder[group][coPerCrate]));
				}
				if(PlayerInfo[p][pLeader] == group) {
					SendClientMessageEx(p, COLOR_LIGHTRED, "* %s %s has canceled the crate order; %d/%d crates were delivered costing: $%s", arrGroupRanks[group][PlayerInfo[playerid][pRank]], GetPlayerNameEx(playerid), CrateOrder[group][coDelivered], CrateOrder[group][coCrates], number_format(CrateOrder[group][coDelivered] * CrateOrder[group][coPerCrate]));
					SendClientMessageEx(p, COLOR_LIGHTRED, "* $%s was refunded back into the vault for undelivered crates.", number_format(refund));
				}
			}
			format(szMiscArray, sizeof(szMiscArray), "%s %s has canceled the crate order; %d/%d crates were delivered costing: $%s ($%s was refunded)", arrGroupRanks[group][PlayerInfo[playerid][pRank]], GetPlayerNameEx(playerid), CrateOrder[group][coDelivered], CrateOrder[group][coCrates], number_format(CrateOrder[group][coDelivered] * CrateOrder[group][coPerCrate]), number_format(refund));
			GroupPayLog(group, szMiscArray);
			SetGroupBudget(group, refund);
			format(szMiscArray, sizeof(szMiscArray), "%s has canceled their crate order; %d/%d crates were delivered adding: $%s.", arrGroupData[group][g_szGroupName], CrateOrder[group][coDelivered], CrateOrder[group][coCrates], number_format(CrateOrder[group][coDelivered] * CrateOrder[group][coPerCrate]), number_format(refund));
			GroupPayLog(type, szMiscArray);
			SetGroupBudget(type, (CrateOrder[group][coDelivered] * CrateOrder[group][coPerCrate]));
		} else {
			foreach(new p: Player) {
				if(PlayerInfo[p][pMember] == CrateFacility[CrateOrder[group][coFacility]][cfGroup]) {
					SendClientMessageEx(p, COLOR_LIGHTRED, "%s has canceled their order; %d/%d crates were delivered earning: $%s.", arrGroupData[group][g_szGroupName], CrateOrder[group][coDelivered], CrateOrder[group][coCrates], number_format(CrateOrder[group][coDelivered] * CrateOrder[group][coPerCrate]));
				}
				if(PlayerInfo[p][pLeader] == group) {
					SendClientMessageEx(p, COLOR_LIGHTRED, "* %s %s has canceled the crate order; %d/%d crates were delivered costing: $%s", arrGroupRanks[group][PlayerInfo[playerid][pRank]], GetPlayerNameEx(playerid), CrateOrder[group][coDelivered], CrateOrder[group][coCrates], number_format(CrateOrder[group][coDelivered] * CrateOrder[group][coPerCrate]));
					SendClientMessageEx(p, COLOR_LIGHTRED, "* $%s was refunded back into the vault for undelivered crates.", number_format(refund));
				}
			}
			format(szMiscArray, sizeof(szMiscArray), "%s %s has canceled the crate order; %d/%d crates were delivered costing: $%s ($%s was refunded)", arrGroupRanks[group][PlayerInfo[playerid][pRank]], GetPlayerNameEx(playerid), CrateOrder[group][coDelivered], CrateOrder[group][coCrates], number_format(CrateOrder[group][coDelivered] * CrateOrder[group][coPerCrate]), number_format(refund));
			GroupPayLog(group, szMiscArray);
			SetGroupBudget(group, refund);
			format(szMiscArray, sizeof(szMiscArray), "%s has canceled their crate order; %d/%d crates were delivered adding: $%s.", arrGroupData[group][g_szGroupName], CrateOrder[group][coDelivered], CrateOrder[group][coCrates], number_format(CrateOrder[group][coDelivered] * CrateOrder[group][coPerCrate]), number_format(refund));
			GroupPayLog(CrateFacility[CrateOrder[group][coFacility]][cfGroup], szMiscArray);
			SetGroupBudget(CrateFacility[CrateOrder[group][coFacility]][cfGroup], (CrateOrder[group][coDelivered] * CrateOrder[group][coPerCrate]));
		}
		ResetOrder(group);
		SaveGroup(group);
	}
	return 1;
}

stock PrepOrder(playerid, group) {
	if(!IsGroupLeader(playerid)) return 1;
	new fname[32];
	szMiscArray[0] = 0;
	if(CrateOrder[group][coFacility] != -1) {
		format(fname, sizeof(fname), "%s", CrateFacility[CrateOrder[group][coFacility]][cfName]);
	} else {
		format(fname, sizeof(fname), "Not Selected");
	}

	format(szMiscArray, sizeof(szMiscArray),
		"{BBBBBB}Which facility?:\t{FFFFFF}%s\n\
		{BBBBBB}How many crates?:\t{FFFFFF}%s ($%s)\n\
		{40FFFF}How it works\n\
		{FFD700}Confirm Order",
		fname,
		number_format(CrateOrder[group][coCrates]), number_format((CrateOrder[group][coCrates] * CrateOrder[group][coPerCrate]))
	);
	return Dialog_Show(playerid, place_order, DIALOG_STYLE_TABLIST, "Place Order", szMiscArray, "Select", "Cancel");
}

Dialog:place_order(playerid, response, listitem, inputtext[]) {
	if(!IsGroupLeader(playerid)) return 1;
	if(response) {
		szMiscArray[0] = 0;
		new group = PlayerInfo[playerid][pMember];
		switch(listitem) {
			case 0: {
				ListFacility(playerid);
			}
			case 1: {
				if(CrateOrder[group][coFacility] == -1) return SendClientMessageEx(playerid, COLOR_GRAD2, "You must choose a facility to order crates from!"), PrepOrder(playerid, group);
				format(szMiscArray, sizeof(szMiscArray), "Please specify how many crates you'd like to order.\n\nPrice per crate: $%s", number_format(CrateFacility[CrateOrder[group][coFacility]][cfProdCost]));
				Dialog_Show(playerid, crate_total, DIALOG_STYLE_INPUT, "How many Crates would you like?", szMiscArray, "Ok", "Go Back");
			}
			case 2: {
				szMiscArray = "{FFFFFF}_______________________________________________________________________________________________________________________________________________________\n\n";
				strcat(szMiscArray, "{40FFFF}Information: How ordering crates works{FFFFFF}\n\n");
				strcat(szMiscArray, "When ordering crates you'll see an overview of which 'Facility' you would like to order from along with how much each crate will cost.\n");
				strcat(szMiscArray, "Once you've selected your facility of choice you'll be able to enter how many 'Crates' you would like (Max of 50 crates can be ordered at once)\n\n");
				strcat(szMiscArray, "You'll see how much in total it will charge your group in brackets once you've confirm your order the money will taken out the vault to pay\n");
				strcat(szMiscArray, "for each crate delivered, the price per crate will also locked so if the facility was to adjust the price your price per crate at the time of\n");
				strcat(szMiscArray, "ordering will not change! (This is to prevent abuse from facility owners)\n\n");
				strcat(szMiscArray, "You may cancel your order at any time by using /ordercrates again, when cancelling an order you'll see a transaction of how many were delivered\n");
				strcat(szMiscArray, "and how much money will be refunded back into your vault.\n\n");
				strcat(szMiscArray, "{FFFFFF}_______________________________________________________________________________________________________________________________________________________");
				Dialog_Show(playerid, how_crates_work, DIALOG_STYLE_MSGBOX, "How crate ordering works", szMiscArray, "Go Back", "");
			}
			case 3: {
				if(CrateOrder[group][coFacility] == -1) return SendClientMessageEx(playerid, COLOR_GRAD2, "ERROR: Facility selection is required!"), PrepOrder(playerid, group);
				if(CrateOrder[group][coCrates] < 1) return SendClientMessageEx(playerid, COLOR_GRAD2, "ERROR: You must select how many crates you'd like!"), PrepOrder(playerid, group);
				if(!CrateFacility[CrateOrder[group][coFacility]][cfActive] || CrateFacility[CrateOrder[group][coFacility]][cfGroup] == -1) return SendClientMessageEx(playerid, COLOR_GRAD2, "The selected facility is unaviliable to take orders!"), PrepOrder(playerid, group);
				if(CrateFacility[CrateOrder[group][coFacility]][cfProdCost] < 1) return SendClientMessageEx(playerid, COLOR_GRAD2, "The facility your trying to select hasn't got a production cost setup!"), PrepOrder(playerid, group);
				//if(CrateFacility[CrateOrder[group][coFacility]][cfGroup] == group) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can't order from your own facility; You can deliver them manually."), PrepOrder(playerid, group);
				new cost = (CrateOrder[group][coCrates] * CrateOrder[group][coPerCrate]);
				if(GetGroupBudget(group) < cost) return SendClientMessageEx(playerid, COLOR_RED, "ERROR: Your group can't afford that many crates!"), PrepOrder(playerid, group);
				if(ValidGroup(CrateOrder[group][coFacility])) {
					foreach(new p: Player) {
						if(PlayerInfo[p][pMember] == CrateFacility[CrateOrder[group][coFacility]][cfGroup]) {
							SendClientMessageEx(p, COLOR_LIGHTRED, "%s has placed an order for %d crates! (( /crate orders ))", arrGroupData[group][g_szGroupName], CrateOrder[group][coCrates]);
						}
						if(PlayerInfo[p][pLeader] == group) {
							SendClientMessageEx(p, COLOR_LIGHTRED, "%s %s has placed an order for %d crates at %s.", arrGroupRanks[group][PlayerInfo[playerid][pRank]], GetPlayerNameEx(playerid), CrateOrder[group][coCrates], CrateFacility[CrateOrder[group][coFacility]][cfName]);
						}
					}
				}
				CrateOrder[group][coOrderBy] = GetPlayerNameEx(playerid);
				CrateOrder[group][coStatus] = 1;
				SaveOrder(group);
				SetGroupBudget(group, -cost);
				SaveGroup(group);
				SendClientMessageEx(playerid, COLOR_WHITE, "You have placed an order for %d crates at %s costing $%s", CrateOrder[group][coCrates], CrateFacility[CrateOrder[group][coFacility]][cfName], number_format(cost));
				SendClientMessageEx(playerid, COLOR_WHITE, "$%s has been deducted from your group vault in preparation for the order.", number_format(cost));
				SendClientMessageEx(playerid, COLOR_YELLOW, "INFO: You can manage your order via the /ordercrates again.");
				format(szMiscArray, sizeof(szMiscArray), "%s %s has placed order for %d crates at %s costing $%s", arrGroupRanks[group][PlayerInfo[playerid][pRank]], GetPlayerNameEx(playerid), CrateOrder[group][coCrates], CrateFacility[CrateOrder[group][coFacility]][cfName], number_format(cost));
				GroupPayLog(group, szMiscArray);
			}
		}
	}
	return 1;
}

stock ListFacility(playerid) {
	if(!IsGroupLeader(playerid)) return 1;
	szMiscArray[0] = 0;
	format(szMiscArray, sizeof(szMiscArray), "Facility\tCost per crate\tActive\n");
	for(new f = 0; f < MAX_CRATE_FACILITY; f++) {
		format(szMiscArray, sizeof(szMiscArray), "%s%s\t$%s\t%s\n", szMiscArray, CrateFacility[f][cfName], number_format(CrateFacility[f][cfProdCost]), (CrateFacility[f][cfActive]) ? ("Yes") : ("No"));
	}
	return Dialog_Show(playerid, select_facility, DIALOG_STYLE_TABLIST_HEADERS, "Which Facility to use?", szMiscArray, "Select", "Go Back");
}

Dialog:select_facility(playerid, response, listitem, inputtext[]) {
	if(!IsGroupLeader(playerid)) return 1;
	new group = PlayerInfo[playerid][pMember];
	if(response) {
		if(!(0 <= listitem < MAX_CRATE_FACILITY)) return SendClientMessageEx(playerid, COLOR_RED, "ERROR - Something went wrong; Please try again!"), ListFacility(playerid);
		if(!CrateFacility[listitem][cfActive] || CrateFacility[listitem][cfGroup] == -1) return SendClientMessageEx(playerid, COLOR_GRAD2, "The facility your trying to select isn't available to take orders!"), ListFacility(playerid);
		if(CrateFacility[listitem][cfProdCost] < 1) return SendClientMessageEx(playerid, COLOR_GRAD2, "The facility your trying to select hasn't got a production cost setup!"), ListFacility(playerid);
		//if(CrateFacility[listitem][cfGroup] == group) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can't order from your own facility; You can deliver them manually."), ListFacility(playerid);
		CrateOrder[group][coFacility] = listitem;
		CrateOrder[group][coCrates] = 0;
		CrateOrder[group][coPerCrate] = 0;
		SendClientMessageEx(playerid, COLOR_WHITE, "You have selected to order crates from %s.", CrateFacility[listitem][cfName]);
		SaveOrder(group);
		PrepOrder(playerid, group);
	} else {
		PrepOrder(playerid, group);
	}
	return 1;
}

Dialog:crate_total(playerid, response, listitem, inputtext[]) {
	if(!IsGroupLeader(playerid)) return 1;
	new group = PlayerInfo[playerid][pMember];
	szMiscArray[0] = 0;
	if(response) {
		new total = strval(inputtext);
		if(!(0 < total < 51)) {
			format(szMiscArray, sizeof(szMiscArray), "{FFFFFF}Please specify how many crates you'd like to order.\n\nPrice per crate: $%s\n\n{FF0000}ERROR: You can only order between 1 to 50 crates at once!", number_format(CrateFacility[CrateOrder[group][coFacility]][cfProdCost]));
			Dialog_Show(playerid, crate_total, DIALOG_STYLE_INPUT, "How many Crates would you like?", szMiscArray, "Ok", "Go Back");
			return 1;
		}
		if(GetGroupBudget(group) < (CrateFacility[CrateOrder[group][coFacility]][cfProdCost] * total)) {
			format(szMiscArray, sizeof(szMiscArray), "{FFFFFF}Please specify how many crates you'd like to order.\n\nPrice per crate: $%s\n\n{FF0000}ERROR: Your group can't afford %s crates!\n{FFFFFF}Budget: $%s | Cost Amount: $%s", number_format(CrateFacility[CrateOrder[group][coFacility]][cfProdCost]), number_format(total), number_format(GetGroupBudget(group)), number_format(CrateFacility[CrateOrder[group][coFacility]][cfProdCost] * total));
			Dialog_Show(playerid, crate_total, DIALOG_STYLE_INPUT, "How many Crates would you like?", szMiscArray, "Ok", "Go Back");
			return 1;
		}
		CrateOrder[group][coCrates] = total;
		CrateOrder[group][coPerCrate] = CrateFacility[CrateOrder[group][coFacility]][cfProdCost];
		SaveOrder(group);
		SendClientMessageEx(playerid, COLOR_WHITE, "You have selected to order %d crates from %s.", total, CrateFacility[CrateOrder[group][coFacility]][cfName]);
		PrepOrder(playerid, group);
	} else {
		PrepOrder(playerid, group);
	}
	return 1;
}

Dialog:how_crates_work(playerid, response, listitem, inputtext[]) {
	if(!IsGroupLeader(playerid)) return 1;
	return PrepOrder(playerid, PlayerInfo[playerid][pMember]);
}

stock GetFacility(group, &fac) {
	fac = -1;
    for(new f = 0; f < MAX_CRATE_FACILITY; f++)
    {
 	    if(group == CrateFacility[f][cfGroup])
		{
			fac = f;
			break;
	    }
 	}
}

stock ResetOrder(group) {
	if(!ValidGroup(group)) return 1;
	CrateOrder[group][coFacility] = -1;
	CrateOrder[group][coCrates] = 0;
	CrateOrder[group][coPerCrate] = 0;
	CrateOrder[group][coDelivered] = 0;
	CrateOrder[group][coStatus] = 0;
	CrateOrder[group][coTime] = 0;
	SaveOrder(group);
	return 1;
}

stock GetDeliverPoint(playerid, &point, Float:range)
{
	point = -1;
    for(new d = 0; d < MAX_GROUPS; d++)
    {
 	    if(IsPlayerInRangeOfPoint(playerid, range, arrGroupData[d][g_fCratePos][0], arrGroupData[d][g_fCratePos][1], arrGroupData[d][g_fCratePos][2]))
		{
			point = d;
			break;
	    }
 	}
}

CMD:delivercrate(playerid, params[]) {
	new fac, veh, crates, point;
	if(!ValidGroup(PlayerInfo[playerid][pMember])) return SendClientMessage(playerid, COLOR_GRAD2, "You need to be apart of a group to use this command!");
	GetDeliverPoint(playerid, point, 6);
	GetFacility(PlayerInfo[playerid][pMember], fac);
	if(fac == -1) return SendClientMessage(playerid, COLOR_GRAD2, "You group doesn't own a crate facility, you can't process orders!");
	if((veh = IsDynamicCrateVehicle(GetPlayerVehicleID(playerid))) == -1) return SendClientMessageEx(playerid, COLOR_GRAD2, "You're not in the designated vehicle for this operation!");
	if(point == -1) return SendClientMessageEx(playerid, COLOR_GRAD2, "You're not near any crate delivery points!");
	if(CrateBeingDelivered[point]) return SendClientMessageEx(playerid, COLOR_GRAD2, "Someone else is currently delivering crates! - Please Wait.");
	if(CrateOrder[point][coFacility] != fac) return SendClientMessageEx(playerid, COLOR_GRAD2, "%s hasn't made any crate orders at your facility.", arrGroupData[point][g_szGroupName]);
	for(new c = 0; c < MAX_CRATES; c++) {
		if(CrateBox[c][cbActive]) {
			if(CrateBox[c][cbFacility] == fac && CrateBox[c][cbInVeh] == veh) {
				++crates;
			}
		}
	}
	if(!crates) return SendClientMessageEx(playerid, COLOR_GRAD2, "There are no crates from your facility in this vehicle to deliver!");
    CrateBeingDelivered[point] = 1;
    VehDelivering[veh] = 1;
    SetPVarInt(playerid, "DeliverCrateTime", 8);
    SetTimerEx("DeliverCrate", 1000, 0, "iiiii", playerid, fac, veh, point, crates);
	GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~8 seconds left", 1100, 3);
	TogglePlayerControllable(playerid, 0);
	return 1;
}

forward DeliverCrate(playerid, fac, veh, point, crates);
public DeliverCrate(playerid, fac, veh, point, crates) {
    szMiscArray[0] = 0;
	new string[128];
	SetPVarInt(playerid, "DeliverCrateTime", GetPVarInt(playerid, "DeliverCrateTime")-1);
	format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~%d seconds left", GetPVarInt(playerid, "DeliverCrateTime"));
	GameTextForPlayer(playerid, string, 1100, 3);

	if(GetPVarInt(playerid, "DeliverCrateTime") > 0) SetTimerEx("DeliverCrate", 1000, 0, "iiiii", playerid, fac, veh, point, crates);

	if(GetPVarInt(playerid, "DeliverCrateTime") < 1) {
		DeletePVar(playerid, "DeliverCrateTime");
		TogglePlayerControllable(playerid, 1);
		CrateBeingDelivered[point] = 0;
		VehDelivering[veh] = 0;
		if(!ValidGroup(PlayerInfo[playerid][pMember])) {
			SendClientMessageEx(playerid, COLOR_GRAD2, "You failed to deliver any crates. You're no longer apart of a group!");
			return 1;
		}
		if(IsDynamicCrateVehicle(GetPlayerVehicleID(playerid)) != veh) {
			SendClientMessageEx(playerid, COLOR_GRAD2, "You failed to deliver any crates, You're no longer in the vehicle that you were delivering from!");
			return 1;
		}
		if(PlayerInfo[playerid][pMember] != CrateFacility[fac][cfGroup]) {
			SendClientMessageEx(playerid, COLOR_GRAD2, "You failed to deliver any crates, Your group no longer owns the facility!");
			return 1;
		}
 	    if(!IsPlayerInRangeOfPoint(playerid, 6.0, arrGroupData[point][g_fCratePos][0], arrGroupData[point][g_fCratePos][1], arrGroupData[point][g_fCratePos][2])) {
			SendClientMessageEx(playerid, COLOR_GRAD2, "You failed to deliver any crates, You're no longer at the delivery point!");
			return 1;
	    }
	    if(playerTabbed[playerid] != 0) {
	    	SendClientMessageEx(playerid, COLOR_GRAD2, "You failed to deliver any crates, you were alt-tabbed.");
	    	return 1;
	    }
	    if(CrateOrder[point][coFacility] != fac) {
	    	SendClientMessageEx(playerid, COLOR_GRAD2, "You failed to deliver any crates, %s has canceled their order.", arrGroupData[point][g_szGroupName]);
	    	return 1;
	    }
	    CrateOrder[point][coDelivered] += crates;
	    if(CrateOrder[point][coDelivered] > CrateOrder[point][coCrates]) {
	    	crates = ((CrateOrder[point][coCrates] + crates) - CrateOrder[point][coDelivered]);
	    	CrateOrder[point][coDelivered] = CrateOrder[point][coCrates];
	    }
		if(CrateOrder[point][coDelivered] >= CrateOrder[point][coCrates]) {
			if(point == PlayerInfo[playerid][pMember]) {
				new type = (arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance] == 2) ? 8 : 5; 
				foreach(new p: Player) {
					if(PlayerInfo[p][pMember] == type) {
						SendClientMessageEx(p, COLOR_LIGHTRED, "* %s's own crate order has been completed; %d crates were delivered earning: $%s.", arrGroupData[point][g_szGroupName], CrateOrder[point][coCrates], number_format(CrateOrder[point][coCrates] * CrateOrder[point][coPerCrate]));
					}
					if(PlayerInfo[p][pLeader] == point) {
						SendClientMessageEx(p, COLOR_LIGHTRED, "* %s facility has completed your crate order; You can now submit a new order.", CrateFacility[fac][cfName]);
					}
				}
				SetGroupBudget(type, (CrateOrder[point][coCrates] * CrateOrder[point][coPerCrate]));
				format(szMiscArray, sizeof(szMiscArray), "%s's own crate order was sucesfully completed %d crates were delivered adding: $%s.", arrGroupData[point][g_szGroupName], CrateOrder[point][coCrates], number_format(CrateOrder[point][coCrates] * CrateOrder[point][coPerCrate]));
				GroupPayLog(type, szMiscArray);
				format(szMiscArray, sizeof(szMiscArray), "%s facility has successfully delivered all %d crates to your locker.", CrateFacility[fac][cfName], CrateOrder[point][coCrates]);
				CrateLog(point, szMiscArray);
			} else {
				foreach(new p: Player) {
					if(PlayerInfo[p][pMember] == CrateFacility[CrateOrder[point][coFacility]][cfGroup]) {
						SendClientMessageEx(p, COLOR_LIGHTRED, "* %s's crate order has been completed; %d crates were delivered earning: $%s.", arrGroupData[point][g_szGroupName], CrateOrder[point][coCrates], number_format(CrateOrder[point][coCrates] * CrateOrder[point][coPerCrate]));
					}
					if(PlayerInfo[p][pLeader] == point) {
						SendClientMessageEx(p, COLOR_LIGHTRED, "* %s facility has completed your crate order; You can now submit a new order.", CrateFacility[fac][cfName]);
					}
				}
				SetGroupBudget(CrateFacility[CrateOrder[point][coFacility]][cfGroup], (CrateOrder[point][coCrates] * CrateOrder[point][coPerCrate]));
				format(szMiscArray, sizeof(szMiscArray), "%s's crate order was sucesfully completed %d crates were delivered adding: $%s.", arrGroupData[point][g_szGroupName], CrateOrder[point][coCrates], number_format(CrateOrder[point][coCrates] * CrateOrder[point][coPerCrate]));
				GroupPayLog(CrateFacility[CrateOrder[point][coFacility]][cfGroup], szMiscArray);
				format(szMiscArray, sizeof(szMiscArray), "%s facility has successfully delivered all %d crates to your locker.", CrateFacility[fac][cfName], CrateOrder[point][coCrates]);
				CrateLog(point, szMiscArray);
			}
			SaveGroup(CrateFacility[CrateOrder[point][coFacility]][cfGroup]);
			ResetOrder(point);
		} else {
			format(szMiscArray, sizeof(szMiscArray), "%s has delivered %d crates to %s (Total delivered: %d/%d)", GetPlayerNameEx(playerid), crates, arrGroupData[point][g_szGroupName], CrateOrder[point][coDelivered], CrateOrder[point][coCrates]);
			CrateLog(CrateFacility[CrateOrder[point][coFacility]][cfGroup], szMiscArray);
			SendClientMessageEx(playerid, COLOR_LIGHTRED, "* You have delivered %d crates to %s; Total delivered: %d/%d", crates, arrGroupData[point][g_szGroupName], CrateOrder[point][coDelivered], CrateOrder[point][coCrates]);
		}
		SaveOrder(point);
	    for(new c = 0; c < MAX_CRATES; c++) {
	    	if(CrateBox[c][cbFacility] == fac && CrateBox[c][cbInVeh] == veh) {
	    		if(crates > 0) {
					arrGroupData[point][g_iLockerStock] += floatround(CrateBox[c][cbMats] * CrateFacility[CrateBox[c][cbFacility]][cfProdMulti]);
	    			DestroyCrate(c);
	    			--crates;
	    		}
	    	}
	    }
	    SaveWeapons(point);
	    if(CreateCount(veh) > 0) SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have %d crate(s) remaining that wasn't used for the delivery.", CreateCount(veh));
	}
	return 1;
}

CMD:cgun(playerid, params[]) {
	szMiscArray[0] = 0;
	new box, title[32];
	if(!ValidGroup(PlayerInfo[playerid][pMember])) return SendClientMessageEx(playerid, COLOR_GRAD1, "You need to be apart of a group to use this command!");
	if(PlayerInfo[playerid][pAccountRestricted] != 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "Your account is restricted!");
	if(PlayerInfo[playerid][pWRestricted] > 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "You can't take weapons out as you're currently weapon restricted!");
	if(PlayerBusy(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can't do that right now.");
	GetCrateBox(playerid, box, 2.0);
	if(box == -1) return SendClientMessageEx(playerid, COLOR_GREY, "You're not near any crate boxes.");
	if(CrateBox[box][cbGroup] != -1) return SendClientMessageEx(playerid, COLOR_GREY, "This is a transfer crate use \"/crate contents\" instead!");
	if(IsInRangeOfPoint(CrateFacility[CrateBox[box][cbFacility]][cfPos][0], CrateFacility[CrateBox[box][cbFacility]][cfPos][1], CrateFacility[CrateBox[box][cbFacility]][cfPos][2], CrateBox[box][cbPos][0], CrateBox[box][cbPos][1], CrateBox[box][cbPos][2], 500.0))
		return SendClientMessageEx(playerid, COLOR_GRAD2, "ERROR:  This crate has been sealed shut by the Crate Island's security system!");
	SetPVarInt(playerid, "Cgunbox", box);
	format(title, sizeof(title), "Crate Box Withdraw - Mats: %d", CrateBox[box][cbMats]);
	format(szMiscArray, sizeof(szMiscArray), "Weapon\tCost\n");
	for(new i = 0; i != MAX_GROUP_WEAPONS; ++i) {
		if(arrGroupData[PlayerInfo[playerid][pMember]][g_iLockerGuns][i]) {
			format(szMiscArray, sizeof szMiscArray, "%s\n%s\t%d", szMiscArray, Weapon_ReturnName(arrGroupData[PlayerInfo[playerid][pMember]][g_iLockerGuns][i]), arrGroupData[PlayerInfo[playerid][pMember]][g_iLockerCost][i]);
		}
		else strcat(szMiscArray, "\nEmpty\t--");
	}
	Dialog_Show(playerid, cgun_take, DIALOG_STYLE_TABLIST_HEADERS, title, szMiscArray, "Select", "Go Back");
	return 1;
}

Dialog:cgun_take(playerid, response, listitem, inputtext[]) {
	szMiscArray[0] = 0;
	if(!ValidGroup(PlayerInfo[playerid][pMember])) return 1;
	if(!GetPVarType(playerid, "Cgunbox")) return 1;
	new group = PlayerInfo[playerid][pMember], box;
	if(response) {
		GetCrateBox(playerid, box, 2.0); // Did someone pick it up? or did the player move?
		if(box == -1) return SendClientMessageEx(playerid, COLOR_GREY, "Crate box went out of reach - Please stay close to the crate box.");
		if(box != GetPVarInt(playerid, "Cgunbox")) return SendClientMessageEx(playerid, COLOR_RED, "ERROR: Box ID differs from accessed crate, please try again.");
		new GunID = arrGroupData[group][g_iLockerGuns][listitem];
		if(!GunID) return SendClientMessageEx(playerid, COLOR_WHITE, "Theres no weapon assigned to that slot!");
		if(CrateBox[box][cbMats] < arrGroupData[group][g_iLockerCost][listitem]) return SendClientMessageEx(playerid, COLOR_GRAD2, "There isn't enough materials in the crate for that weapon!");
		if(PlayerInfo[playerid][pGuns][GetWeaponSlot(GunID)] != GunID) {
			GivePlayerValidWeapon(playerid, GunID);
			CrateBox[box][cbMats] -= arrGroupData[group][g_iLockerCost][listitem];
			format(szMiscArray, sizeof(szMiscArray), "* %s reaches into the weapon crate box and takes out a %s.", GetPlayerNameEx(playerid), Weapon_ReturnName(GunID));
			ProxDetector(25.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			SaveCrate(box);
			CrateBoxUpdate(box);
			if(CrateBox[box][cbMats] < 1) DestroyCrate(box);
		} else {
			SendClientMessageEx(playerid, COLOR_RED, "You already have a %s on you!", Weapon_ReturnName(GunID));
		}
	}
	DeletePVar(playerid, "Cgunbox");
	return 1;
}

// Ignore gate status incase someone is opening a gate at the time of the gate timer.
stock TriggerGates(fac, status = 1) {
	for(new g = 0; g < MAX_GATES; g++) {
		if(GateInfo[g][gFacility] == fac) {
			if(status) {
				MoveDynamicObject(GateInfo[g][gGATE], GateInfo[g][gPosXM], GateInfo[g][gPosYM], GateInfo[g][gPosZM], GateInfo[g][gSpeed], GateInfo[g][gRotXM], GateInfo[g][gRotYM], GateInfo[g][gRotZM]);
				GateInfo[g][gStatus] = 1;
			} else {
				MoveDynamicObject(GateInfo[g][gGATE], GateInfo[g][gPosX], GateInfo[g][gPosY], GateInfo[g][gPosZ], GateInfo[g][gSpeed], GateInfo[g][gRotX], GateInfo[g][gRotY], GateInfo[g][gRotZ]);
				GateInfo[g][gStatus] = 0;
			}
		}
	}
	return 1;
}