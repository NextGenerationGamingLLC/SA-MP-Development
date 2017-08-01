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

	---- NOTES ----

	Since there is no "Official DMV" leaders can access their storage it'll work the same way as a player owned vehicle
	but vehicles that contain crates CANNOT be de-spawned, also vehicle health is also saved along with fuel to prevent abuse.

	If the vehicle has been impounded the payments can be made from the storage. (Nation will be taken into account for which GOV gets the payment).
	Price will be determined down to the playing hours of said player and not level.
*/
#include <YSI\y_hooks>

new CrateVehTotal = 0;

new VehDelivering[MAX_CRATE_VEHCILES];

hook OnGameModeInit() {
	for(new i = 0; i < MAX_CRATE_VEHCILES; ++i) {
		VehDelivering[i] = 0;
		CrateVehicle[i][cvForkObject] = -1;
		CrateVehicle[i][cvSpawnID] = INVALID_VEHICLE_ID;
		CrateVehicle[i][cvId] = -1;
		CrateVehicle[i][cvModel] = 0;
		CrateVehicle[i][cvColor][0] = 0;
		CrateVehicle[i][cvColor][1] = 0;
		CrateVehicle[i][cvGroupID] = -1;
		CrateVehicle[i][cvRank] = -1;
		CrateVehicle[i][cvSpawned] = 0;
		CrateVehicle[i][cvDisabled] = 0;
		CrateVehicle[i][cvImpound] = 0;
		CrateVehicle[i][cvTickets] = 0;
		CrateVehicle[i][cvMaxHealth] = 1000;
		CrateVehicle[i][cvHealth] = 1000;
		CrateVehicle[i][cvFuel] = 100;
		CrateVehicle[i][cvType] = 0;
		for(new p = 0; p < 4; p++) CrateVehicle[i][cvPos][p] = 0.0;
		CrateVehicle[i][cvInt] = 0;
		CrateVehicle[i][cvVw] = 0;
		CrateVehicle[i][cvCrateMax] = 0;
		CrateVehicle[i][cvCrate] = -1;
		CrateVehicle[i][cvCrateLoad] = 0;
	}
	return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate) {
	new carid;
	if(newstate == PLAYER_STATE_DRIVER) {
		if((carid = IsDynamicCrateVehicle(GetPlayerVehicleID(playerid))) != -1) {
			if(PlayerInfo[playerid][pAdmin] > 3 || PlayerInfo[playerid][pASM] > 0 || PlayerInfo[playerid][pFactionModerator] > 0) {
				if(ValidGroup(CrateVehicle[carid][cvGroupID])) {
					SendClientMessageEx(playerid, COLOR_YELLOW, "This crate vehicle belongs to %s", arrGroupData[CrateVehicle[carid][cvGroupID]][g_szGroupName]);
				}
			} else {
				if(ValidGroup(CrateVehicle[carid][cvGroupID])) {
					if(PlayerInfo[playerid][pMember] != CrateVehicle[carid][cvGroupID]) {
						SendClientMessageEx(playerid, COLOR_GREY, "You need to be apart of %s to drive this vehicle!", arrGroupData[CrateVehicle[carid][cvGroupID]][g_szGroupName]);
						return RemovePlayerFromVehicle(playerid);
					}
					if(0 <= CrateVehicle[carid][cvRank] < MAX_GROUP_RANKS && (PlayerInfo[playerid][pRank] < CrateVehicle[carid][cvRank])) {
						SendClientMessageEx(playerid, COLOR_GREY, "You need to be rank %s (%d) or above to drive this vehicle!", arrGroupRanks[CrateVehicle[carid][cvGroupID]][CrateVehicle[carid][cvRank]], CrateVehicle[carid][cvRank]);
						return RemovePlayerFromVehicle(playerid);
					}
				}
				if(!ValidGroup(CrateVehicle[carid][cvGroupID]) && !ValidGroup(PlayerInfo[playerid][pMember])) {
					SendClientMessageEx(playerid, COLOR_GREY, "You must be in a group to use this vehicle.");
					return RemovePlayerFromVehicle(playerid);
				}
			}
			if(CreateCount(carid) > 0) SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* There are %d crate(s) stored in this vehicle.", CreateCount(carid));
		}
	}
	return 1;
}

hook OnPlayerEnterVehicle(playerid, vehicleid, ispassenger) {
	new carid;
	if(!ispassenger) {
		if((carid = IsDynamicCrateVehicle(vehicleid)) != -1) {
			new Float:pos[3];
			if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1 && PlayerInfo[playerid][pFactionModerator] < 5) {
				if(ValidGroup(CrateVehicle[carid][cvGroupID])) {
					if(PlayerInfo[playerid][pMember] != CrateVehicle[carid][cvGroupID]) {
						GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
						SetPlayerPos(playerid, pos[0], pos[1], pos[2]+1.3);
						PlayerPlaySound(playerid, 1130, pos[0], pos[1], pos[2]+1.3);
						SendClientMessageEx(playerid, COLOR_GREY, "You need to be apart of %s to use this vehicle!", arrGroupData[CrateVehicle[carid][cvGroupID]][g_szGroupName]);
						return 1;
					}
				}
				if(!ValidGroup(CrateVehicle[carid][cvGroupID]) && !ValidGroup(PlayerInfo[playerid][pMember])) {
					GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
					SetPlayerPos(playerid, pos[0], pos[1], pos[2]+1.3);
					PlayerPlaySound(playerid, 1130, pos[0], pos[1], pos[2]+1.3);
					SendClientMessageEx(playerid, COLOR_GREY, "You must be in a group to use this vehicle.");
					return 1;
				}
			}
		}
	}
	return 1;
}

hook OnVehicleDeath(vehicleid, killerid) {
	new carid;
	if((carid = IsDynamicCrateVehicle(vehicleid)) != -1) {
		if(CreateCount(carid) > 0) AnnounceRespawn(CrateVehicle[carid][cvGroupID], "destroyed", carid, CreateCount(carid)), DestroyCratesInVeh(carid);
		if(CrateVehicle[carid][cvCrate] != -1) DestroyCrate(CrateVehicle[carid][cvCrate]);
	}
	return 1;
}

hook OnVehicleSpawn(vehicleid) {
	new carid;
	if((carid = IsDynamicCrateVehicle(vehicleid)) != -1) {
		if(CreateCount(carid) > 0) AnnounceRespawn(CrateVehicle[carid][cvGroupID], "respawned", carid, CreateCount(carid)), DestroyCratesInVeh(carid);
		if(CrateVehicle[carid][cvCrate] != -1) DestroyCrate(CrateVehicle[carid][cvCrate]);
		SpawnCrateVeh(carid);
	}
	return 1;
}

forward AnnounceRespawn(group, type[], veh, amount);
public AnnounceRespawn(group, type[], veh, amount) {
	if(ValidGroup(group)) {
		new string[128];
		format(string, sizeof(string), "** Vehicle %s was %s %d crate(s) were destroyed. **", VehicleName[CrateVehicle[veh][cvModel] - 400], type, amount);
		foreach(new i: Player) {
			if(PlayerInfo[i][pMember] == group && GetPVarInt(i, "OOCRadioTogged") == 0) {
				ChatTrafficProcess(i, arrGroupData[group][g_hOOCColor] * 256 + 255, string, 11);
			}
		}
	}
	return 1;
}

forward LoadDynamicCrateVehicles();
public LoadDynamicCrateVehicles()
{
	printf("[LoadDynamicCrateVehicles] Loading data from database...");
    mysql_tquery(MainPipeline, "SELECT * FROM `crate_vehicles`", "OnLoadDynamicCrateVehciles", "");
    return 1;
}

forward OnLoadDynamicCrateVehciles();
public OnLoadDynamicCrateVehciles() {
	szMiscArray[0] = 0;
	new i, rows, sqlid;
	cache_get_row_count(rows);
	while(i < rows)
	{
		cache_get_value_name_int(i, "id", sqlid);
		if(i < MAX_CRATE_VEHCILES) {
			CrateVehicle[i][cvId] = sqlid;
			cache_get_value_name_int(i, "vModel", CrateVehicle[i][cvModel]);
			cache_get_value_name_int(i, "vColor1", CrateVehicle[i][cvColor][0]);
			cache_get_value_name_int(i, "vColor2", CrateVehicle[i][cvColor][1]);
			cache_get_value_name_int(i, "vGroup", CrateVehicle[i][cvGroupID]);
			cache_get_value_name_int(i, "vRank", CrateVehicle[i][cvRank]);
			cache_get_value_name_int(i, "vSpawned", CrateVehicle[i][cvSpawned]);
			cache_get_value_name_int(i, "vDisabled", CrateVehicle[i][cvDisabled]);
			cache_get_value_name_int(i, "vImpound", CrateVehicle[i][cvImpound]);
			cache_get_value_name_int(i, "vTickets", CrateVehicle[i][cvTickets]);
			cache_get_value_name_float(i, "vMaxHealth", CrateVehicle[i][cvMaxHealth]);
			cache_get_value_name_float(i, "vHealth", CrateVehicle[i][cvHealth]);
			cache_get_value_name_float(i, "vFuel", CrateVehicle[i][cvFuel]);
			cache_get_value_name_int(i, "vType", CrateVehicle[i][cvType]);
			cache_get_value_name_float(i, "vPosX", CrateVehicle[i][cvPos][0]);
			cache_get_value_name_float(i, "vPosY", CrateVehicle[i][cvPos][1]);
			cache_get_value_name_float(i, "vPosZ", CrateVehicle[i][cvPos][2]);
			cache_get_value_name_float(i, "vRotZ", CrateVehicle[i][cvPos][3]);
			cache_get_value_name_int(i, "vInt", CrateVehicle[i][cvInt]);
			cache_get_value_name_int(i, "vVw", CrateVehicle[i][cvVw]);
			cache_get_value_name_int(i, "vCrateMax", CrateVehicle[i][cvCrateMax]);
			cache_get_value_name_int(i, "vCrate", CrateVehicle[i][cvCrate]);
			cache_get_value_name_int(i, "FirstDrop", CrateVehicle[i][cvCrateLoad]);
			if(400 <= CrateVehicle[i][cvModel] < 612) {
				if(!IsWeaponizedVehicle(CrateVehicle[i][cvModel])) {
					SpawnCrateVeh(i);
				}
			}
			++CrateVehTotal;
		} else {
			mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "DELETE FROM `crate_vehicles` WHERE `id` = %d", sqlid);
			mysql_tquery(MainPipeline, szMiscArray, "OnQueryFinish", "i", SENDDATA_THREAD);
			printf("SQL ID %d exceeds Max Dynamic Crate Vehicles", sqlid);
		}
		i++;
	}
	if(CrateVehTotal > 0) printf("[LoadDynamicCrateVehicles] %d dynamic crate vehicles have been loaded.", i);
	else printf("[LoadDynamicCrateVehicles] No dynamic crate vehicles have been loaded.");
	return 1;
}

stock SaveCrateVehicle(id) {
	new query[2048];

	if(CrateVehicle[id][cvSpawnID] != INVALID_VEHICLE_ID) {
		GetVehicleHealth(CrateVehicle[id][cvSpawnID], CrateVehicle[id][cvHealth]);
		if(CrateVehicle[id][cvHealth] < 350) CrateVehicle[id][cvHealth] = 350;
		CrateVehicle[id][cvFuel] = VehicleFuel[CrateVehicle[id][cvSpawnID]];
	}
	format(query, 2048, "UPDATE `crate_vehicles` SET ");
	SaveInteger(query, "crate_vehicles", id+1, "vModel", CrateVehicle[id][cvModel]);
	SaveInteger(query, "crate_vehicles", id+1, "vColor1", CrateVehicle[id][cvColor][0]);
	SaveInteger(query, "crate_vehicles", id+1, "vColor2", CrateVehicle[id][cvColor][1]);
	SaveInteger(query, "crate_vehicles", id+1, "vGroup", CrateVehicle[id][cvGroupID]);
	SaveInteger(query, "crate_vehicles", id+1, "vRank", CrateVehicle[id][cvRank]);
	SaveInteger(query, "crate_vehicles", id+1, "vSpawned", CrateVehicle[id][cvSpawned]);
	SaveInteger(query, "crate_vehicles", id+1, "vDisabled", CrateVehicle[id][cvDisabled]);
	SaveInteger(query, "crate_vehicles", id+1, "vImpound", CrateVehicle[id][cvImpound]);
	SaveInteger(query, "crate_vehicles", id+1, "vTickets", CrateVehicle[id][cvTickets]);
	SaveFloat(query, "crate_vehicles", id+1, "vMaxHealth", CrateVehicle[id][cvMaxHealth]);
	SaveFloat(query, "crate_vehicles", id+1, "vHealth", CrateVehicle[id][cvHealth]);
	SaveFloat(query, "crate_vehicles", id+1, "vFuel", CrateVehicle[id][cvFuel]);
	SaveFloat(query, "crate_vehicles", id+1, "vPosX", CrateVehicle[id][cvPos][0]);
	SaveFloat(query, "crate_vehicles", id+1, "vPosY", CrateVehicle[id][cvPos][1]);
	SaveFloat(query, "crate_vehicles", id+1, "vPosZ", CrateVehicle[id][cvPos][2]);
	SaveFloat(query, "crate_vehicles", id+1, "vRotZ", CrateVehicle[id][cvPos][3]);
	SaveInteger(query, "crate_vehicles", id+1, "vInt", CrateVehicle[id][cvInt]);
	SaveInteger(query, "crate_vehicles", id+1, "vVw", CrateVehicle[id][cvVw]);
	SaveInteger(query, "crate_vehicles", id+1, "vCrateMax", CrateVehicle[id][cvCrateMax]);
	SaveInteger(query, "crate_vehicles", id+1, "vCrate", CrateVehicle[id][cvCrate]);
	SaveInteger(query, "crate_vehicles", id+1, "FirstDrop", CrateVehicle[id][cvCrateLoad]);
	SQLUpdateFinish(query, "crate_vehicles", id+1);
	return 1;
}

forward SpawnCrateVeh(vehid);
public SpawnCrateVeh(vehid) {
	szMiscArray[0] = 0;
	if(!(0 <= vehid < MAX_CRATE_VEHCILES)) return 1;
    if(!(400 <= CrateVehicle[vehid][cvModel] < 612)) return 1;

	if(CrateVehicle[vehid][cvSpawnID] != INVALID_VEHICLE_ID) {
		DestroyVehicle(CrateVehicle[vehid][cvSpawnID]);
		CrateVehicle[vehid][cvSpawnID] = INVALID_VEHICLE_ID;
	}
	CrateVehCheck(vehid);
	if(!CrateVehicle[vehid][cvSpawned] || CrateVehicle[vehid][cvDisabled] || CrateVehicle[vehid][cvImpound]) return 1;
	CrateVehicle[vehid][cvSpawnID] = CreateVehicle(CrateVehicle[vehid][cvModel], CrateVehicle[vehid][cvPos][0], CrateVehicle[vehid][cvPos][1], CrateVehicle[vehid][cvPos][2], CrateVehicle[vehid][cvPos][3], CrateVehicle[vehid][cvColor][0], CrateVehicle[vehid][cvColor][1], -1, 0);
	if(CrateVehicle[vehid][cvHealth] > CrateVehicle[vehid][cvMaxHealth]) CrateVehicle[vehid][cvHealth] = CrateVehicle[vehid][cvMaxHealth];
	if(CrateVehicle[vehid][cvHealth] < 350) CrateVehicle[vehid][cvHealth] = 350;
	SetVehicleHealth(CrateVehicle[vehid][cvSpawnID], CrateVehicle[vehid][cvHealth]);
	SetVehicleVirtualWorld(CrateVehicle[vehid][cvSpawnID], CrateVehicle[vehid][cvVw]);
	LinkVehicleToInterior(CrateVehicle[vehid][cvSpawnID], CrateVehicle[vehid][cvInt]);
	if(CrateVehicle[vehid][cvFuel] > 100) CrateVehicle[vehid][cvFuel] = 100;
	VehicleFuel[CrateVehicle[vehid][cvSpawnID]] = CrateVehicle[vehid][cvFuel];
	SetVehicleNumberPlate(CrateVehicle[vehid][cvSpawnID], "Crates v2.0");
	return 1;
}

forward CrateVehCheck(vehid);
public CrateVehCheck(vehid) {
	new box;
	if(IsValidDynamicObject(CrateVehicle[vehid][cvForkObject])) DestroyDynamicObject(CrateVehicle[vehid][cvForkObject]), CrateVehicle[vehid][cvForkObject] = -1;
	CheckCrateInVeh(vehid);
	if((box = CrateVehicle[vehid][cvCrate]) == -1) return 1;

	if(!IsValidCrate(box)) {
		CrateVehicle[vehid][cvCrate] = -1;
		return 1;
	}
	if(CrateBox[box][cbOnVeh] != vehid) {
		CrateVehicle[vehid][cvCrate] = -1;
		DestroyCrate(box);
		SaveCrateVehicle(vehid);
		return 1;
	}
	if(!CrateVehicle[vehid][cvSpawned] || CrateVehicle[vehid][cvImpound] || CrateVehicle[vehid][cvDisabled]) {
		return DestroyCrate(CrateVehicle[vehid][cvCrate]);
	}
	CrateVehicle[vehid][cvForkObject] = CreateDynamicObject(964,-1077.59997559,4274.39990234,3.40000010,0.00000000,0.00000000,0.00000000);
	AttachDynamicObjectToVehicle(CrateVehicle[vehid][cvForkObject], CrateVehicle[vehid][cvSpawnID], 0, 0.9, -0.2, 0, 0, 0);
	return 1;
}

forward CheckCrateInVeh(veh);
public CheckCrateInVeh(veh) {
	for(new b = 0; b < MAX_CRATES; b++) {
		if(CrateBox[b][cbInVeh] == veh) {
			if(!CrateVehicle[veh][cvSpawned] || CrateVehicle[veh][cvImpound] || CrateVehicle[veh][cvDisabled]) {
				DestroyCrate(b);
			}
		}
	}
	return 1;
}

forward DestroyCratesInVeh(veh);
public DestroyCratesInVeh(veh) {
	for(new b = 0; b < MAX_CRATES; b++) {
		if(CrateBox[b][cbInVeh] == veh) {
			DestroyCrate(b);
		}
	}
	return 1;
}

forward IsDynamicCrateVehicle(vehicleid);
public IsDynamicCrateVehicle(vehicleid) {
    for(new v = 0; v < MAX_CRATE_VEHCILES; v++)
    {
        if(CrateVehicle[v][cvSpawnID] == vehicleid)
        {
            return v;
        }
    }
    return -1;
}

CMD:cvcreate(playerid, params[]) {
	szMiscArray[0] = 0;
	new iVehicle, iColors[2], Float:vpos[4];
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pFactionModerator] < 1) return SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use this command!");
	if(CrateVehTotal >= MAX_CRATE_VEHCILES) return SendClientMessageEx(playerid, COLOR_GREY, "Your unable to create anymore crate vehicles the limit has been reached! (Max: %d)", MAX_CRATE_VEHCILES);
	if(sscanf(params, "dD(0)D(0)", iVehicle, iColors[0], iColors[1])) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /cvcreate [model ID] [color 1] [color 2]");
	if(!(400 <= iVehicle < 612)) return SendClientMessageEx(playerid, COLOR_GREY, "Invalid vehicle model ID specified!");
	if(IsATrain(iVehicle)) return SendClientMessageEx(playerid, COLOR_GREY, "Trains cannot be spawned during runtime.");
	if(IsWeaponizedVehicle(iVehicle)) return SendClientMessageEx(playerid, COLOR_GREY, "You're unable to create weaponized vehicles as a crate vehicle!");
	if(!(0 <= iColors[0] <= 255 && 0 <= iColors[1] <= 255)) return SendClientMessageEx(playerid, COLOR_GREY, "Invalid color specified (IDs start at 0, and end at 255).");

	GetPlayerPos(playerid, vpos[0], vpos[1], vpos[2]);
	GetPlayerFacingAngle(playerid, vpos[3]);
	for(new i = 0; i < MAX_CRATE_VEHCILES; i++) {
		if(CrateVehicle[i][cvModel] == 0) {
	        mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "INSERT INTO `crate_vehicles` (`vModel`, `vColor1`, `vColor2`, `vPosX`, `vPosY`, `vPosZ`, `vRotZ`) VALUES (%d, %d, %d, %0.5f, %0.5f, %0.5f, %0.5f)", iVehicle, iColors[0], iColors[1], vpos[0], vpos[1], vpos[2], vpos[3]);
			//mysql_tquery(MainPipeline, szMiscArray, false, "OnQueryFinish", "i", SENDDATA_THREAD);
			mysql_tquery(MainPipeline, szMiscArray, "OnCrateVehicle", "iiiffffii", playerid, i, iVehicle, vpos[0], vpos[1], vpos[2], vpos[3], iColors[0], iColors[1]);
			/*CrateVehicle[i][cvModel] = iVehicle;
			CrateVehicle[i][cvPos][0] = vpos[0];
			CrateVehicle[i][cvPos][1] = vpos[1];
			CrateVehicle[i][cvPos][2] = vpos[2];
			CrateVehicle[i][cvPos][3] = vpos[3];
			CrateVehicle[i][cvVw] = GetPlayerVirtualWorld(playerid);
			CrateVehicle[i][cvInt] = GetPlayerInterior(playerid);
			CrateVehicle[i][cvColor][0] = iColors[0];
			CrateVehicle[i][cvColor][1] = iColors[1];
			CrateVehicle[i][cvSpawned] = 1;
			SaveCrateVehicle(i);
			SpawnCrateVeh(i);
			++CrateVehTotal;*/
			break;
		}
	}
	return 1;
}

forward OnCrateVehicle(playerid, i, veh, Float:pos1, Float:pos2, Float:pos3, Float:pos4, color1, color2);
public OnCrateVehicle(playerid, i, veh, Float:pos1, Float:pos2, Float:pos3, Float:pos4, color1, color2) {
	CrateVehicle[i][cvId] = cache_insert_id();
	CrateVehicle[i][cvModel] = veh;
	CrateVehicle[i][cvPos][0] = pos1;
	CrateVehicle[i][cvPos][1] = pos2;
	CrateVehicle[i][cvPos][2] = pos3;
	CrateVehicle[i][cvPos][3] = pos4;
	CrateVehicle[i][cvVw] = GetPlayerVirtualWorld(playerid);
	CrateVehicle[i][cvInt] = GetPlayerInterior(playerid);
	CrateVehicle[i][cvColor][0] = color1;
	CrateVehicle[i][cvColor][1] = color2;
	CrateVehicle[i][cvSpawned] = 1;
	SaveCrateVehicle(i);
	SpawnCrateVeh(i);
	++CrateVehTotal;
	SendClientMessageEx(playerid, COLOR_WHITE, "You have created a %s as a dynamic crate vehicle. (Slots Left: %d)", VehicleName[veh - 400], (MAX_CRATE_VEHCILES - CrateVehTotal));
	format(szMiscArray, sizeof(szMiscArray), "%s has created a dynamic crate vehicle (Name: %s | Model: %d)", GetPlayerNameEx(playerid), VehicleName[veh - 400], veh);
	Log("logs/cvspawn.log", szMiscArray);
	return 1;
}

CMD:cvstorage(playerid, params[])
{
	szMiscArray[0] = 0;
	if(PlayerInfo[playerid][pAdmin] > 3 || PlayerInfo[playerid][pASM] > 0 || PlayerInfo[playerid][pFactionModerator] > 0) {
		new group;
		if(sscanf(params, "i", group)) return SendClientMessageEx(playerid, COLOR_GREY, "Usage: /cvstorage [groupid]");
		if(group != -1) {
			if(!ValidGroup(group)) return SendClientMessageEx(playerid, COLOR_GREY, "Invalid group ID specified (0 - 39) | -1 will list vehicle not owned!");
		}
		ListVehicles(playerid, group);
	}
	else {
		if(!IsGroupLeader(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You need to be a group leader to use this command!");
		if(!IsPlayerInRangeOfPoint(playerid, 100.0, arrGroupData[PlayerInfo[playerid][pMember]][g_fGaragePos][0], arrGroupData[PlayerInfo[playerid][pMember]][g_fGaragePos][1], arrGroupData[PlayerInfo[playerid][pMember]][g_fGaragePos][2])) return SendClientMessageEx(playerid, COLOR_GREY, "You're not in range of your garage!"); 
		ListVehicles(playerid, PlayerInfo[playerid][pMember]);
	}
	return 1;
}

stock ListVehicles(playerid, group) {
	szMiscArray[0] = 0;
	new title[64];
	SetPVarInt(playerid, "CarGroup", group);
	if(group != -1) format(title, sizeof(title), "Crate Vehicles: {%s}%s", Group_NumToDialogHex(arrGroupData[group][g_hDutyColour]), arrGroupData[group][g_szGroupName]);
	else format(title, sizeof(title), "Crate Vehicles: Unowned");
	format(szMiscArray, sizeof(szMiscArray), "Vehicle\tStatus\tVehicle ID\tTickets\n");
	for(new i; i < MAX_CRATE_VEHCILES; i++)
	{
		new iModelID = CrateVehicle[i][cvModel];
		if(400 <= iModelID < 612 && CrateVehicle[i][cvGroupID] == group)
		{
			if(CrateVehicle[i][cvDisabled]) {
				format(szMiscArray, sizeof(szMiscArray), "%s(%d) %s\tDisabled\t--\t$%s\n", szMiscArray, i, VehicleName[iModelID - 400], number_format(CrateVehicle[i][cvTickets]));
			}
			else if(CrateVehicle[i][cvImpound]) {
				format(szMiscArray, sizeof(szMiscArray), "%s(%d) %s\tImpounded\t--\t$%s\n", szMiscArray, i, VehicleName[iModelID - 400], number_format(CrateVehicle[i][cvTickets]));
			}
			else if(CrateVehicle[i][cvSpawnID] != INVALID_VEHICLE_ID) {
				format(szMiscArray, sizeof(szMiscArray), "%s(%d) %s\tSpawned\t%d\t$%s\n", szMiscArray, i, VehicleName[iModelID - 400], CrateVehicle[i][cvSpawnID], number_format(CrateVehicle[i][cvTickets]));
			}
			else if(CrateVehicle[i][cvSpawnID] == INVALID_VEHICLE_ID) {
				format(szMiscArray, sizeof(szMiscArray), "%s(%d) %s\tStored\t--\t$%s\n", szMiscArray, i, VehicleName[iModelID - 400], number_format(CrateVehicle[i][cvTickets]));
			}
		}
	}
	if(strlen(szMiscArray) == 34) {
		Dialog_Show(playerid, -1, DIALOG_STYLE_LIST, title, "This group doesn't own any vehicles!", "Close", "");
	}
	else {
		Dialog_Show(playerid, cvstorage, DIALOG_STYLE_TABLIST_HEADERS, title, szMiscArray, "Manage", "Close");
	}
	return 1;
}


Dialog:cvstorage(playerid, response, listitem, inputtext[]) {
	if(response) {
		new stpos = strfind(inputtext, "(");
	    new fpos = strfind(inputtext, ")");
	    new caridstr[6], carid;
	    strmid(caridstr, inputtext, stpos+1, fpos);
	    carid = strval(caridstr);
	    SetPVarInt(playerid, "CvStorageID", carid);
	    CarOptions(playerid);
	} else {
		DeletePVar(playerid, "CarGroup");
	}
	return 1;
}

stock CarOptions(playerid) {
	szMiscArray[0] = 0;
	new title[64];
	if(!GetPVarType(playerid, "CvStorageID") && !GetPVarType(playerid, "CarGroup")) return 1;
	format(title, sizeof(title), "Vehicle: %s", VehicleName[CrateVehicle[GetPVarInt(playerid, "CvStorageID")][cvModel] - 400]);
    if(PlayerInfo[playerid][pAdmin] > 3 || PlayerInfo[playerid][pASM] > 0 || PlayerInfo[playerid][pFactionModerator] > 0) {
    	format(szMiscArray, sizeof(szMiscArray),
    		"%s Vehicle\n\
    		Remove Tickets ($%s)\n\
    		%s Vehicle\n\
    		%s Vehicle\n\
    		Refuel Vehicle\n\
    		Delete Vehicle",
    		(CrateVehicle[GetPVarInt(playerid, "CvStorageID")][cvSpawned]) ? ("Despawn") : ("Spawn"),
    		number_format(CrateVehicle[GetPVarInt(playerid, "CvStorageID")][cvTickets]),
    		(CrateVehicle[GetPVarInt(playerid, "CvStorageID")][cvImpound]) ? ("Release") : ("Impound"),
    		(CrateVehicle[GetPVarInt(playerid, "CvStorageID")][cvDisabled]) ? ("Enable") : ("Disable")
    	);
    	Dialog_Show(playerid, veh_options, DIALOG_STYLE_LIST, title, szMiscArray, "Select", "Go Back");
    } else {
    	if(!IsGroupLeader(playerid)) return SendClientMessageEx(playerid, COLOR_RED, "ERROR: Your not a group leader!");
    	new price[28], tickets[28];

    	if(CrateVehicle[GetPVarInt(playerid, "CvStorageID")][cvImpound]) {
    		format(tickets, sizeof(tickets), "--");
    		format(price, sizeof(price), "Cost: $%s", number_format(200000 + CrateVehicle[GetPVarInt(playerid, "CvStorageID")][cvTickets]));
		} else {
			format(tickets, sizeof(tickets), "$%s", number_format(CrateVehicle[GetPVarInt(playerid, "CvStorageID")][cvTickets]));
			format(price, sizeof(price), "--");
		}
    	format(szMiscArray, sizeof(szMiscArray),
    		"%s Vehicle\n\
    		Pay Tickets (%s)\n\
    		Release Vehicle (%s)",
    		(CrateVehicle[GetPVarInt(playerid, "CvStorageID")][cvSpawned]) ? ("Despawn") : ("Spawn"),
    		tickets,
    		price
    	);
    	Dialog_Show(playerid, veh_options, DIALOG_STYLE_LIST, title, szMiscArray, "Select", "Go Back");
    }
	return 1;
}

Dialog:veh_options(playerid, response, listitem, inputtext[]) {
	szMiscArray[0] = 0;
	if(!GetPVarType(playerid, "CvStorageID") && !GetPVarType(playerid, "CarGroup")) return 1;
	if(response) {
		new veh, carid = GetPVarInt(playerid, "CvStorageID"), Float:vHealth;
		switch(listitem) {
			case 0: {
				if((veh = CrateVehicle[carid][cvSpawnID]) != INVALID_VEHICLE_ID) {
				 	if((!IsVehicleOccupied(veh) || IsPlayerInVehicle(playerid, veh)) && !IsVehicleInTow(veh)) {
					 	if(CreateCount(carid) > 0) return SendClientMessageEx(playerid, COLOR_GREY, "Unable to despawn %s (Veh id: %d) as it's carrying crates.", VehicleName[CrateVehicle[carid][cvModel] - 400], veh);
			    		GetVehicleHealth(veh, vHealth);
						if(vHealth < 800) return SendClientMessageEx(playerid, COLOR_GREY, "This vehicle is too damaged to be stored.");
						CrateVehicle[carid][cvHealth] = vHealth;
						CrateVehicle[carid][cvFuel] = VehicleFuel[veh];
						DestroyVehicle(veh);
						CrateVehicle[carid][cvSpawned] = 0;
						CrateVehicle[carid][cvSpawnID] = INVALID_VEHICLE_ID;
						CrateVehCheck(carid);
						SaveCrateVehicle(carid);
						SendClientMessageEx(playerid, COLOR_WHITE, "You have stored your group crate vehicle (%s)", VehicleName[CrateVehicle[carid][cvModel] - 400]);
					} else {
						SendClientMessageEx(playerid, COLOR_GRAD1, "Unable to despawn %s (Veh id: %d) as it's currently being occupied.", VehicleName[CrateVehicle[carid][cvModel] - 400], veh);
					}
				} else {
	    			if(CrateVehicle[carid][cvDisabled]) return SendClientMessageEx(playerid, COLOR_GRAD1, "An administrator has disabled this vehicle, your unable to spawn it."), CarOptions(playerid);
	    			if(CrateVehicle[carid][cvImpound]) return SendClientMessageEx(playerid, COLOR_GRAD1, "Vehicle has been impounded; You'll need to release the vehicle before you can spawn it."), CarOptions(playerid);
				 	CrateVehicle[carid][cvSpawned] = 1;
				 	SpawnCrateVeh(carid);
				 	SaveCrateVehicle(carid);
				 	SendClientMessageEx(playerid, COLOR_WHITE, "You have spawned the group crate vehicle (%s)", VehicleName[CrateVehicle[carid][cvModel] - 400]);
				}
				return CarOptions(playerid);
			}
			case 1: {
				if(PlayerInfo[playerid][pAdmin] > 3 || PlayerInfo[playerid][pASM] > 0 || PlayerInfo[playerid][pFactionModerator] > 0) {
					if(!ValidGroup(CrateVehicle[carid][cvGroupID])) return SendClientMessageEx(playerid, COLOR_GRAD2, "Unowned vehicles can't receive tickets so there's nothing to reset."), CarOptions(playerid);
					if(!CrateVehicle[carid][cvTickets]) return SendClientMessageEx(playerid, COLOR_GRAD2, "The vehicle has no tickets that you can remove."), CarOptions(playerid);
					format(szMiscArray, sizeof(szMiscArray), "%s removed all outstanding tickets ($%s) on vehicle %s (Veh id: %d | Group Owner: %s)", GetPlayerNameEx(playerid), number_format(CrateVehicle[carid][cvTickets]), VehicleName[CrateVehicle[carid][cvModel] - 400], CrateVehicle[carid][cvModel], arrGroupData[CrateVehicle[carid][cvGroupID]][g_szGroupName]);
					Log("logs/cratevehicle.log", szMiscArray);
					CrateVehicle[carid][cvTickets] = 0;
					SaveCrateVehicle(carid);
					format(szMiscArray, sizeof(szMiscArray), "* Your %s tickets have been removed by an administrator.", VehicleName[CrateVehicle[carid][cvModel] - 400]);
					foreach(new i: Player) {
						if(PlayerInfo[i][pLeader] == CrateVehicle[carid][cvGroupID]) {
							ChatTrafficProcess(i, arrGroupData[CrateVehicle[carid][cvGroupID]][g_hRadioColour] * 256 + 255, szMiscArray, 12);
						}
					}
					SendClientMessageEx(playerid, COLOR_YELLOW, "You have removed all vehicle tickets on the vehicle.");
					return CarOptions(playerid);
				} else {
					if(!CrateVehicle[carid][cvTickets]) return SendClientMessageEx(playerid, COLOR_GRAD2, "The vehicle has no outstanding tickets that needs paying."), CarOptions(playerid);
					if(GetGroupBudget(GetPVarInt(playerid, "CarGroup")) < CrateVehicle[carid][cvTickets]) return SendClientMessageEx(playerid, COLOR_GRAD2, "You group needs $%s to pay for the tickets.", number_format(CrateVehicle[carid][cvTickets])), CarOptions(playerid);
					SetGroupBudget(GetPVarInt(playerid, "CarGroup"), -CrateVehicle[carid][cvTickets]);
					SaveGroup(GetPVarInt(playerid, "CarGroup"));
					format(szMiscArray, sizeof(szMiscArray), "%s has paid total of $%s for all outstanding vehicle tickets on the %s", GetPlayerNameEx(playerid), number_format(CrateVehicle[carid][cvTickets]), VehicleName[CrateVehicle[carid][cvModel] - 400]);
					GroupPayLog(GetPVarInt(playerid, "CarGroup"), szMiscArray);
					CrateVehicle[carid][cvTickets] = 0;
					SaveCrateVehicle(carid);
					foreach(new i: Player) {
						if(PlayerInfo[i][pLeader] == CrateVehicle[carid][cvGroupID]) {
							ChatTrafficProcess(i, arrGroupData[CrateVehicle[carid][cvGroupID]][g_hRadioColour] * 256 + 255, szMiscArray, 12);
						}
					}
					return CarOptions(playerid);
				}
			}
			case 2: {
				if(PlayerInfo[playerid][pAdmin] > 3 || PlayerInfo[playerid][pASM] > 0 || PlayerInfo[playerid][pFactionModerator] > 0) {
					if(!ValidGroup(CrateVehicle[carid][cvGroupID])) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can't impound/release a vehicle that isn't owned by a group!"), CarOptions(playerid);
					if(!CrateVehicle[carid][cvImpound]) {
						if(CrateVehicle[carid][cvSpawnID] != INVALID_VEHICLE_ID) {
							GetVehicleHealth(CrateVehicle[carid][cvSpawnID], vHealth);
							CrateVehicle[carid][cvHealth] = vHealth;
							CrateVehicle[carid][cvFuel] = VehicleFuel[CrateVehicle[carid][cvSpawnID]];
							if(CreateCount(carid) > 0) AnnounceRespawn(CrateVehicle[carid][cvGroupID], "impounded by an admin", carid, CreateCount(carid));
							DestroyVehicle(CrateVehicle[carid][cvSpawnID]);
							CrateVehicle[carid][cvSpawned] = 0;
							CrateVehicle[carid][cvSpawnID] = INVALID_VEHICLE_ID;
						}
						CrateVehicle[carid][cvImpound] = 1;
						CrateVehCheck(carid);
						SaveCrateVehicle(carid);
						format(szMiscArray, sizeof(szMiscArray), "* Your %s has been impounded by an admin you can recover it from your garage. (( /cvstorage ))", VehicleName[CrateVehicle[carid][cvModel] - 400]);
						foreach(new i: Player) {
							if(PlayerInfo[i][pLeader] == CrateVehicle[carid][cvGroupID]) {
								ChatTrafficProcess(i, arrGroupData[CrateVehicle[carid][cvGroupID]][g_hRadioColour] * 256 + 255, szMiscArray, 12);
							}
						}
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You have impounded %s's %s.", arrGroupData[CrateVehicle[carid][cvGroupID]][g_szGroupName], VehicleName[CrateVehicle[carid][cvModel] - 400]);
						format(szMiscArray, sizeof(szMiscArray), "%s has impounded %s. (Veh id: %d | Owner: %s)", GetPlayerNameEx(playerid), VehicleName[CrateVehicle[carid][cvModel] - 400], CrateVehicle[carid][cvModel], arrGroupData[CrateVehicle[carid][cvGroupID]][g_szGroupName]);
						Log("logs/cratevehicle.log", szMiscArray);
						return CarOptions(playerid);
					} else {
						CrateVehicle[carid][cvImpound] = 0;
						CrateVehicle[carid][cvTickets] = 0;
				 		CrateVehicle[carid][cvSpawned] = 1;
				 		SpawnCrateVeh(carid);
				 		SaveCrateVehicle(carid);
						format(szMiscArray, sizeof(szMiscArray), "* Your %s has been released by an admin and has been parked at it's location.", VehicleName[CrateVehicle[carid][cvModel] - 400]);
						foreach(new i: Player) {
							if(PlayerInfo[i][pLeader] == CrateVehicle[carid][cvGroupID]) {
								ChatTrafficProcess(i, arrGroupData[CrateVehicle[carid][cvGroupID]][g_hRadioColour] * 256 + 255, szMiscArray, 12);
							}
						}
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You have released %s's %s.", arrGroupData[CrateVehicle[carid][cvGroupID]][g_szGroupName], VehicleName[CrateVehicle[carid][cvModel] - 400]);
						format(szMiscArray, sizeof(szMiscArray), "%s has released vehicle %s. (Veh id: %d | Owner: %s)", GetPlayerNameEx(playerid), VehicleName[CrateVehicle[carid][cvModel] - 400], CrateVehicle[carid][cvModel], arrGroupData[CrateVehicle[carid][cvGroupID]][g_szGroupName]);
						Log("logs/cratevehicle.log", szMiscArray);
						return CarOptions(playerid);
					}
				}
				else {
					if(!CrateVehicle[carid][cvImpound]) return SendClientMessageEx(playerid, COLOR_GRAD2, "Your %s hasn't been impounded!", VehicleName[CrateVehicle[carid][cvModel] - 400]), CarOptions(playerid);
					new cost = (200000 + CrateVehicle[GetPVarInt(playerid, "CvStorageID")][cvTickets]);
					if(GetGroupBudget(GetPVarInt(playerid, "CarGroup")) < cost) return SendClientMessageEx(playerid, COLOR_GRAD2, "Your group can't afford the $%s to release this vehicle.", number_format(cost)), CarOptions(playerid);
					SetGroupBudget(GetPVarInt(playerid, "CarGroup"), -cost);
					SaveGroup(GetPVarInt(playerid, "CarGroup"));
					format(szMiscArray, sizeof(szMiscArray), "%s has paid $%s to release vehicle %s from the impound.", GetPlayerNameEx(playerid), number_format(cost), VehicleName[CrateVehicle[carid][cvModel] - 400]);
					GroupPayLog(GetPVarInt(playerid, "CarGroup"), szMiscArray);
					CrateVehicle[carid][cvImpound] = 0;
					CrateVehicle[carid][cvTickets] = 0;
			 		CrateVehicle[carid][cvSpawned] = 1;
			 		SpawnCrateVeh(carid);
			 		SaveCrateVehicle(carid);
					format(szMiscArray, sizeof(szMiscArray), "* Your %s has been released from the impound by %s and has been parked at it's location.", VehicleName[CrateVehicle[carid][cvModel] - 400], GetPlayerNameEx(playerid));
					foreach(new i: Player) {
						if(PlayerInfo[i][pLeader] == CrateVehicle[carid][cvGroupID]) {
							ChatTrafficProcess(i, arrGroupData[CrateVehicle[carid][cvGroupID]][g_hRadioColour] * 256 + 255, szMiscArray, 12);
						}
					}
					return CarOptions(playerid);
				}
			}
			case 3: {
				if(PlayerInfo[playerid][pAdmin] > 3 || PlayerInfo[playerid][pASM] > 0 || PlayerInfo[playerid][pFactionModerator] > 0) {
					if(!CrateVehicle[carid][cvDisabled]) {
						if(CrateVehicle[carid][cvSpawnID] != INVALID_VEHICLE_ID) {
							GetVehicleHealth(CrateVehicle[carid][cvSpawnID], vHealth);
							CrateVehicle[carid][cvHealth] = vHealth;
							CrateVehicle[carid][cvFuel] = VehicleFuel[CrateVehicle[carid][cvSpawnID]];
							if(CreateCount(carid) > 0) AnnounceRespawn(CrateVehicle[carid][cvGroupID], "disabled by an admin", carid, CreateCount(carid));
							DestroyVehicle(CrateVehicle[carid][cvSpawnID]);
							CrateVehicle[carid][cvSpawned] = 0;
							CrateVehicle[carid][cvSpawnID] = INVALID_VEHICLE_ID;
						}
						CrateVehicle[carid][cvDisabled] = 1;
						CrateVehCheck(carid);
						SaveCrateVehicle(carid);
						if(ValidGroup(CrateVehicle[carid][cvGroupID])) {
							format(szMiscArray, sizeof(szMiscArray), "* Your %s has been disabled by an admin you'll be unable to use the vehicle.", VehicleName[CrateVehicle[carid][cvModel] - 400]);
							foreach(new i: Player) {
								if(PlayerInfo[i][pLeader] == CrateVehicle[carid][cvGroupID]) {
									ChatTrafficProcess(i, arrGroupData[CrateVehicle[carid][cvGroupID]][g_hRadioColour] * 256 + 255, szMiscArray, 12);
								}
							}
							SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You have disabled %s's %s.", arrGroupData[CrateVehicle[carid][cvGroupID]][g_szGroupName], VehicleName[CrateVehicle[carid][cvModel] - 400]);
							format(szMiscArray, sizeof(szMiscArray), "%s has disabled vehicle %s (Veh id: %d | Owner: %s)", GetPlayerNameEx(playerid), VehicleName[CrateVehicle[carid][cvModel] - 400], CrateVehicle[carid][cvModel], arrGroupData[CrateVehicle[carid][cvGroupID]][g_szGroupName]);
						}
						else SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You have disabled the %s. (Not owned by any group).", VehicleName[CrateVehicle[carid][cvModel] - 400]), format(szMiscArray, sizeof(szMiscArray), "%s has re-enabled vehicle %s (Veh id: %d | Owner: N/A)", GetPlayerNameEx(playerid), VehicleName[CrateVehicle[carid][cvModel] - 400], CrateVehicle[carid][cvModel]);
						Log("logs/cratevehicle.log", szMiscArray);
						return CarOptions(playerid);
					} else {
						CrateVehicle[carid][cvDisabled] = 0;
				 		CrateVehicle[carid][cvSpawned] = 1;
				 		SpawnCrateVeh(carid);
				 		SaveCrateVehicle(carid);
						if(ValidGroup(CrateVehicle[carid][cvGroupID])) {
							format(szMiscArray, sizeof(szMiscArray), "* Your %s has been re-enabled by an admin it has been parked at it's location.", VehicleName[CrateVehicle[carid][cvModel] - 400]);
							foreach(new i: Player) {
								if(PlayerInfo[i][pLeader] == CrateVehicle[carid][cvGroupID]) {
									ChatTrafficProcess(i, arrGroupData[CrateVehicle[carid][cvGroupID]][g_hRadioColour] * 256 + 255, szMiscArray, 12);
								}
							}
							SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You have re-enabled %s's %s it has been spawned at it's location.", arrGroupData[CrateVehicle[carid][cvGroupID]][g_szGroupName], VehicleName[CrateVehicle[carid][cvModel] - 400]);
							format(szMiscArray, sizeof(szMiscArray), "%s has re-enabled vehicle %s (Veh id: %d | Owner: %s)", GetPlayerNameEx(playerid), VehicleName[CrateVehicle[carid][cvModel] - 400], CrateVehicle[carid][cvModel], arrGroupData[CrateVehicle[carid][cvGroupID]][g_szGroupName]);
						}
						else SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You have re-enabled the %s it has been spawned at it's location. (Not owned by any group).", VehicleName[CrateVehicle[carid][cvModel] - 400]), format(szMiscArray, sizeof(szMiscArray), "%s has re-enabled vehicle %s (Veh id: %d | Owner: N/A)", GetPlayerNameEx(playerid), VehicleName[CrateVehicle[carid][cvModel] - 400], CrateVehicle[carid][cvModel]);
						Log("logs/cratevehicle.log", szMiscArray);
						return CarOptions(playerid);
					}
				}
			}
			case 4: {
				if(PlayerInfo[playerid][pAdmin] > 3 || PlayerInfo[playerid][pASM] > 0 || PlayerInfo[playerid][pFactionModerator] > 0) {
					if(CrateVehicle[carid][cvSpawnID] == INVALID_VEHICLE_ID) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can't add fuel to a vehicle that isn't spawned!"), CarOptions(playerid);
					if(VehicleFuel[CrateVehicle[carid][cvSpawnID]] >= 100) return SendClientMessageEx(playerid, COLOR_GRAD2, "The vehicle already has max fuel; You can't add anymore."), CarOptions(playerid);
					VehicleFuel[CrateVehicle[carid][cvSpawnID]] = 100;
					SendClientMessageEx(playerid, COLOR_YELLOW, "You have restored the %ss fuel back to 100.", VehicleName[CrateVehicle[carid][cvModel] - 400]);
					if(ValidGroup(CrateVehicle[carid][cvGroupID])) {
						format(szMiscArray, sizeof(szMiscArray), "%s has refuled vehicle %s (Veh id: %d | Owner: %s)", GetPlayerNameEx(playerid), VehicleName[CrateVehicle[carid][cvModel] - 400], CrateVehicle[carid][cvModel], arrGroupData[CrateVehicle[carid][cvGroupID]][g_szGroupName]);
					}
					else format(szMiscArray, sizeof(szMiscArray), "%s has refuled vehicle %s (Veh id: %d | Owner: %s)", GetPlayerNameEx(playerid), VehicleName[CrateVehicle[carid][cvModel] - 400], CrateVehicle[carid][cvModel]);
					Log("logs/cratevehicle.log", szMiscArray);
					return CarOptions(playerid);
				}
			}
			case 5: {
				if(PlayerInfo[playerid][pAdmin] > 3 || PlayerInfo[playerid][pASM] > 0 || PlayerInfo[playerid][pFactionModerator] > 0) {
					format(szMiscArray, sizeof(szMiscArray), "Are you sure you want to delete the %s?", VehicleName[CrateVehicle[carid][cvModel] - 400]);
					Dialog_Show(playerid, confirm_delete_veh, DIALOG_STYLE_MSGBOX, "Are you sure?", szMiscArray, "Yes", "No");
				}
			}
		}
	} else {
		DeletePVar(playerid, "CvStorageID");
		ListVehicles(playerid, GetPVarInt(playerid, "CarGroup"));
	}
	return 1;
}

Dialog:confirm_delete_veh(playerid, response, listitem, inputtext[]) {
	if(!GetPVarType(playerid, "CvStorageID") && !GetPVarType(playerid, "CarGroup")) return 1;
	if(response) {
		if(PlayerInfo[playerid][pAdmin] > 3 || PlayerInfo[playerid][pASM] > 0 || PlayerInfo[playerid][pFactionModerator] > 0) {
			DeleteCrateVehicle(playerid, GetPVarInt(playerid, "CvStorageID"));
			DeletePVar(playerid, "CvStorageID");
			ListVehicles(playerid, GetPVarInt(playerid, "CarGroup"));
		}
	} else {
		CarOptions(playerid);
	}
	return 1;
}

stock DeleteCrateVehicle(playerid, veh) {
	szMiscArray[0] = 0;
	if(CrateVehicle[veh][cvSpawnID] != INVALID_VEHICLE_ID) {
		if(CreateCount(veh) > 0) AnnounceRespawn(CrateVehicle[veh][cvGroupID], "deleted by an admin", veh, CreateCount(veh));
		DestroyVehicle(CrateVehicle[veh][cvSpawnID]);
		CrateVehicle[veh][cvSpawned] = 0;
		CrateVehicle[veh][cvSpawnID] = INVALID_VEHICLE_ID;
	}
	CrateVehCheck(veh);
	if(ValidGroup(CrateVehicle[veh][cvGroupID])) {
		format(szMiscArray, sizeof(szMiscArray), "* Your %s has been deleted by an administrator.", VehicleName[CrateVehicle[veh][cvModel] - 400]);
		foreach(new i: Player) {
			if(PlayerInfo[i][pLeader] == CrateVehicle[veh][cvGroupID]) {
				ChatTrafficProcess(i, arrGroupData[CrateVehicle[veh][cvGroupID]][g_hRadioColour] * 256 + 255, szMiscArray, 12);
			}
		}
		SendClientMessageEx(playerid, COLOR_YELLOW, "You have deleted the vehicle %s. (Owned by: %s)", VehicleName[CrateVehicle[veh][cvModel] - 400], arrGroupData[CrateVehicle[veh][cvGroupID]][g_szGroupName]);
		format(szMiscArray, sizeof(szMiscArray), "%s has deleted vehicle %s (Veh id: %d | Owner: %s)", GetPlayerNameEx(playerid), VehicleName[CrateVehicle[veh][cvModel] - 400], CrateVehicle[veh][cvModel], arrGroupData[CrateVehicle[veh][cvGroupID]][g_szGroupName]);
	}
	else SendClientMessageEx(playerid, COLOR_YELLOW, "You have deleted the vehicle %s. (Not Owned)", VehicleName[CrateVehicle[veh][cvModel] - 400]), format(szMiscArray, sizeof(szMiscArray), "%s has deleted vehicle %s (Veh id: %d | Owner: N/A)", GetPlayerNameEx(playerid), VehicleName[CrateVehicle[veh][cvModel] - 400], CrateVehicle[veh][cvModel]);
	Log("logs/cratevehicle.log", szMiscArray);

    mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "DELETE FROM `crate_vehicles` WHERE `id` = %d", CrateVehicle[veh][cvId]);
	mysql_tquery(MainPipeline, szMiscArray, "OnQueryFinish", "i", SENDDATA_THREAD);

	VehDelivering[veh] = 0;
	CrateVehicle[veh][cvForkObject] = -1;
	CrateVehicle[veh][cvSpawnID] = INVALID_VEHICLE_ID;
	CrateVehicle[veh][cvId] = -1;
	CrateVehicle[veh][cvModel] = 0;
	CrateVehicle[veh][cvColor][0] = 0;
	CrateVehicle[veh][cvColor][1] = 0;
	CrateVehicle[veh][cvGroupID] = -1;
	CrateVehicle[veh][cvRank] = -1;
	CrateVehicle[veh][cvSpawned] = 0;
	CrateVehicle[veh][cvDisabled] = 0;
	CrateVehicle[veh][cvImpound] = 0;
	CrateVehicle[veh][cvTickets] = 0;
	CrateVehicle[veh][cvMaxHealth] = 1000;
	CrateVehicle[veh][cvHealth] = 1000;
	CrateVehicle[veh][cvFuel] = 100;
	CrateVehicle[veh][cvType] = 0;
	for(new p = 0; p < 4; p++) CrateVehicle[veh][cvPos][p] = 0.0;
	CrateVehicle[veh][cvInt] = 0;
	CrateVehicle[veh][cvVw] = 0;
	CrateVehicle[veh][cvCrateMax] = 0;
	CrateVehicle[veh][cvCrate] = -1;
	CrateVehicle[veh][cvCrateLoad] = 0;
	--CrateVehTotal;
	return 1;
}

CMD:cvedit(playerid, params[]) {
	if(PlayerInfo[playerid][pAdmin] > 3 || PlayerInfo[playerid][pASM] > 0 || PlayerInfo[playerid][pFactionModerator] > 0) {
		szMiscArray[0] = 0;
		new choice[32], vehid, value, cveh;
		if(sscanf(params, "is[32]D(-1)", vehid, choice, value))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /crate [vehid] [name] [value]");
			SendClientMessageEx(playerid, COLOR_GREY, "Names: model, col1, col2, groupid, rank, maxhealth, loadmax, disable, delete");
			SendClientMessageEx(playerid, COLOR_GREY, "Names: refuel");
			SendClientMessageEx(playerid, COLOR_GREY, "NOTE: Setting groupid to -1 will allow any group to access vehicle.");
			return 1;
		}
		if((cveh = IsDynamicCrateVehicle(vehid)) == -1) return SendClientMessageEx(playerid, COLOR_GREY, "The selected vehicle isn't a crate vehicle!");
		if(strcmp(choice, "model", true) == 0) {
			if(!(400 <= value < 612)) return SendClientMessageEx(playerid, COLOR_GREY, "Invalid vehicle model ID specified!");
			CrateVehicle[cveh][cvModel] = value;
			SaveCrateVehicle(cveh);
			SpawnCrateVeh(cveh);
			SendClientMessageEx(playerid, COLOR_WHITE, "Vehicle has been changed to %s", VehicleName[value - 400]);
		}
		else if(strcmp(choice, "col1", true) == 0) {
			if(!(0 <= value <= 255)) return SendClientMessageEx(playerid, COLOR_GRAD2, "Invalid color specified (IDs start at 0, and end at 255).");
			CrateVehicle[cveh][cvColor][0] = value;
			SaveCrateVehicle(cveh);
			SpawnCrateVeh(cveh);
			SendClientMessageEx(playerid, COLOR_WHITE, "You have modified the color (1) of the crate vehicle.");
		}
		else if(strcmp(choice, "col2", true) == 0) {
			if(!(0 <= value <= 255)) return SendClientMessageEx(playerid, COLOR_GRAD2, "Invalid color specified (IDs start at 0, and end at 255).");
			CrateVehicle[cveh][cvColor][1] = value;
			SaveCrateVehicle(cveh);
			SpawnCrateVeh(cveh);
			SendClientMessageEx(playerid, COLOR_WHITE, "You have modified the color (2) of the crate vehicle.");
		}
		else if(strcmp(choice, "groupid", true) == 0) {
			if(value != -1 && !ValidGroup(value)) return SendClientMessageEx(playerid, COLOR_GREY, "Invalid Group ID! (0 - 39) | No Group = -1");
			CrateVehicle[cveh][cvGroupID] = value;
			if(value == -1) CrateVehicle[cveh][cvRank] = -1;
			SaveCrateVehicle(cveh);
			if(value != -1) {
				SendClientMessageEx(playerid, COLOR_WHITE, "You have assigned the vehicle to %s.", arrGroupData[value][g_szGroupName]);
			} else {
				SendClientMessageEx(playerid, COLOR_WHITE, "You have assigned the vehicle to be accessed by any group member!");
			}
		}
		else if(strcmp(choice, "rank", true) == 0) {
			if(value != -1 && !(0 <= value < 10)) return SendClientMessageEx(playerid, COLOR_GREY, "Invalid Rank ID! (0 - 9) | No Rank = -1");
			CrateVehicle[cveh][cvRank] = value;
			SaveCrateVehicle(cveh);
			if(value != -1) {
				SendClientMessageEx(playerid, COLOR_WHITE, "You have assigned the vehicle to only allow rank %d and above.", value);
			} else {
				SendClientMessageEx(playerid, COLOR_WHITE, "You have removed the rank restriction on this vehicle!");
			}
		}
		else if(strcmp(choice, "maxhealth", true) == 0) {
			if(value < 1000) return SendClientMessageEx(playerid, COLOR_GREY, "You can't set the vehicle max health lower than 1,000!");
			CrateVehicle[cveh][cvMaxHealth] = value;
			SaveCrateVehicle(cveh);
			SendClientMessageEx(playerid, COLOR_WHITE, "You have set the vehicle max health to %s", number_format(value));
		}
		else if(strcmp(choice, "loadmax", true) == 0) {
			if(value < 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can't set load max below 0; Set it to 0 to disable!");
			CrateVehicle[cveh][cvCrateMax] = value;
			SaveCrateVehicle(cveh);
			SendClientMessageEx(playerid, COLOR_WHITE, "You set the vehicle crate load max to %d", value);
		}
		else if(strcmp(choice, "disable", true) == 0) {
			new Float:vHealth;
			if(!CrateVehicle[cveh][cvDisabled]) {
				if(CrateVehicle[cveh][cvSpawnID] != INVALID_VEHICLE_ID) {
					GetVehicleHealth(CrateVehicle[cveh][cvSpawnID], vHealth);
					CrateVehicle[cveh][cvHealth] = vHealth;
					CrateVehicle[cveh][cvFuel] = VehicleFuel[CrateVehicle[cveh][cvSpawnID]];
					if(CreateCount(cveh) > 0) AnnounceRespawn(CrateVehicle[cveh][cvGroupID], "disabled by an admin", cveh, CreateCount(cveh));
					DestroyVehicle(CrateVehicle[cveh][cvSpawnID]);
					CrateVehicle[cveh][cvSpawned] = 0;
					CrateVehicle[cveh][cvSpawnID] = INVALID_VEHICLE_ID;
				}
				CrateVehicle[cveh][cvDisabled] = 1;
				CrateVehCheck(cveh);
				SaveCrateVehicle(cveh);
				if(ValidGroup(CrateVehicle[cveh][cvGroupID])) {
					format(szMiscArray, sizeof(szMiscArray), "* Your %s has been disabled by an admin you'll be unable to use the vehicle.", VehicleName[CrateVehicle[cveh][cvModel] - 400]);
					foreach(new i: Player) {
						if(PlayerInfo[i][pLeader] == CrateVehicle[cveh][cvGroupID]) {
							ChatTrafficProcess(i, arrGroupData[CrateVehicle[cveh][cvGroupID]][g_hRadioColour] * 256 + 255, szMiscArray, 12);
						}
					}
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You have impounded %s's %s.", arrGroupData[CrateVehicle[cveh][cvGroupID]][g_szGroupName], VehicleName[CrateVehicle[cveh][cvModel] - 400]);
					format(szMiscArray, sizeof(szMiscArray), "%s has disabled vehicle %s (Veh id: %d | Owner: %s)", GetPlayerNameEx(playerid), VehicleName[CrateVehicle[cveh][cvModel] - 400], CrateVehicle[cveh][cvModel], arrGroupData[CrateVehicle[cveh][cvGroupID]][g_szGroupName]);
				}
				else SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You have disabled the %s. (Not owned by any group).", VehicleName[CrateVehicle[cveh][cvModel] - 400]), format(szMiscArray, sizeof(szMiscArray), "%s has re-enabled vehicle %s (Veh id: %d | Owner: N/A)", GetPlayerNameEx(playerid), VehicleName[CrateVehicle[cveh][cvModel] - 400], CrateVehicle[cveh][cvModel]);
				Log("logs/cratevehicle.log", szMiscArray);
			}
			else SendClientMessageEx(playerid, COLOR_GRAD2, "This vehicle can't be disabled!");
		}
		else if(strcmp(choice, "delete", true) == 0) {
			DeleteCrateVehicle(playerid, cveh);
		}
		else SendClientMessageEx(playerid, COLOR_GREY, "Invalid choice selected!");
	} else {
		SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use this command!");
	}
	return 1;
}

CMD:cvpark(playerid, params[]) {
	new veh, string[128];
	if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD2, "You need to be in a vehicle that you want to park!");
	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessageEx(playerid, COLOR_RED, "You're not in the driver seat!");
	if((veh = IsDynamicCrateVehicle(GetPlayerVehicleID(playerid))) == -1) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can't park this vehicle!");
	if(PlayerInfo[playerid][pAdmin] > 3 || PlayerInfo[playerid][pASM] > 0 || PlayerInfo[playerid][pFactionModerator] > 0 || IsGroupLeader(playerid) && PlayerInfo[playerid][pMember] == CrateVehicle[veh][cvGroupID]) {
		GetVehiclePos(GetPlayerVehicleID(playerid), CrateVehicle[veh][cvPos][0], CrateVehicle[veh][cvPos][1], CrateVehicle[veh][cvPos][2]);
		GetVehicleZAngle(GetPlayerVehicleID(playerid), CrateVehicle[veh][cvPos][3]);
		CrateVehicle[veh][cvVw] = GetPlayerVirtualWorld(playerid);
		CrateVehicle[veh][cvInt] = GetPlayerInterior(playerid);
		SendClientMessageEx(playerid, COLOR_WHITE, "You have parked the %s in a new location.", VehicleName[CrateVehicle[veh][cvModel] - 400]);
		SaveCrateVehicle(veh);
		SurfingCheck(GetPlayerVehicleID(playerid));
		SpawnCrateVeh(veh);
		IsPlayerEntering{playerid} = true;
		PutPlayerInVehicle(playerid, GetPlayerVehicleID(playerid), 0);
		SetPlayerArmedWeapon(playerid, 0);
		format(string, sizeof(string), "* %s has parked the %s.", GetPlayerNameEx(playerid), VehicleName[CrateVehicle[veh][cvModel] - 400]);
		ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	}
	else SendClientMessageEx(playerid, COLOR_GRAD2, "You can't park vehicles that doesn't belong to your group!");
	return 1;
}

CMD:cvcheck(playerid, params[]) {
	if(ValidGroup(PlayerInfo[playerid][pMember]) || PlayerInfo[playerid][pAdmin] > 1) {
		new Float:vPos[3], VehFound = -1;
		for(new i = 0; i < MAX_CRATE_VEHCILES; i++) {
			if(CrateVehicle[i][cvSpawnID] != INVALID_VEHICLE_ID) {
				GetPosBehindVehicle(CrateVehicle[i][cvSpawnID], vPos[0], vPos[1], vPos[2], (IsAPlane(CrateVehicle[i][cvSpawnID]) ? -8 : 0));
				if(IsPlayerInRangeOfPoint(playerid, (IsAPlane(CrateVehicle[i][cvSpawnID]) ? 6 : 2), vPos[0], vPos[1], vPos[2])) {
					VehFound = i; // Do not use the vehicle ID as we store the array ID for the validation since vehicles do not store "spawn id".
					break;
				}
			}
		}
		if(VehFound == -1) return SendClientMessageEx(playerid, COLOR_GRAD2, "You're not near any designated vehicles that can store crates.");
		if(CrateVehicle[VehFound][cvCrateMax] < 1) return SendClientMessageEx(playerid, COLOR_GRAD3, "The vehicle \"%s\" can't contain any crates.", VehicleName[CrateVehicle[VehFound][cvModel] - 400]);
		if(VehDelivering[VehFound]) return SendClientMessageEx(playerid, COLOR_GRAD3, "This vehicle is currently unloading crates - Please Wait!");
		if(!CreateCount(VehFound)) return SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* There is no crates stored in the %s", VehicleName[CrateVehicle[VehFound][cvModel] - 400]);
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* The %s is currently carrying %d crates.", VehicleName[CrateVehicle[VehFound][cvModel] - 400], CreateCount(VehFound));
	}
	else SendClientMessageEx(playerid, COLOR_GRAD2, "You must be apart of a group to use this command!"); 
	return 1;
}

CMD:cvstatus(playerid, params[]) {
	if(PlayerInfo[playerid][pAdmin] > 3 || PlayerInfo[playerid][pASM] > 0 || PlayerInfo[playerid][pFactionModerator] > 0) {
		new vehicleid, veh;
		if(sscanf(params, "i", vehicleid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /cvstatus [vehicleid]");
		if((veh = IsDynamicCrateVehicle(vehicleid)) != -1) {
			new string[128], Float:vHealth;
			GetVehicleHealth(vehicleid, vHealth);
			format(string,sizeof(string),"|___________ Crate Vehicle Status (ID: %d | Slot ID: %d) ___________|", vehicleid, veh);
			SendClientMessageEx(playerid, COLOR_GREEN, string);
			format(string, sizeof(string), "X: %f | Y: %f | Z: %f | VW: %d | Int: %d | Model: %d  Maxhealth: %.1f", CrateVehicle[veh][cvPos][0], CrateVehicle[veh][cvPos][1], CrateVehicle[veh][cvPos][2], CrateVehicle[veh][cvVw], CrateVehicle[veh][cvInt], CrateVehicle[veh][cvModel], CrateVehicle[veh][cvMaxHealth]);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			if(ValidGroup(CrateVehicle[veh][cvGroupID])) {
				format(string, sizeof(string), "Group: %s (%d) | Rank: %d | Tickets: $%s | LoadMax: %d", arrGroupData[CrateVehicle[veh][cvGroupID]][g_szGroupName], CrateVehicle[veh][cvGroupID], CrateVehicle[veh][cvRank], number_format(CrateVehicle[veh][cvTickets]), CrateVehicle[veh][cvCrateMax]);
			} else {
				format(string, sizeof(string), "Group: -- | Rank: -- | Tickets: -- | LoadMax: %d", CrateVehicle[veh][cvCrateMax]);
			}
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			format(string, sizeof(string), "Crates: %d | Health: %.1f | Fuel: %.1f percent", CreateCount(veh), vHealth, VehicleFuel[vehicleid]);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
		}
		else {
			SendClientMessageEx(playerid, COLOR_GREY, "The selected vehicle isn't a crate vehicle!");
		}
	} else {
		SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use this command!");
	}
	return 1;
}

CMD:cvrespawn(playerid, params[]) {
	szMiscArray[0] = 0;
	if(PlayerInfo[playerid][pAdmin] > 3 || PlayerInfo[playerid][pASM] > 0 || PlayerInfo[playerid][pFactionModerator] > 0) {
		if(isnull(params)) return SendClientMessageEx(playerid, COLOR_GREY, "Usage: /cvrespawn [Group/All]");
		if(strcmp(params, "all", true) == 0) {
			for(new v = 0; v < MAX_CRATE_VEHCILES; v++) {
				if(CrateVehicle[v][cvSpawnID] != INVALID_VEHICLE_ID) {
					if(!IsVehicleOccupied(CrateVehicle[v][cvSpawnID]) && !CreateCount(v)) {
						SpawnCrateVeh(v);
					}
				}
			}
			format(szMiscArray, sizeof(szMiscArray), "{AA3333}AdmWarning{FFFF00}: %s has respawned all dynamic crate vehicles loaded on the server.", GetPlayerNameEx(playerid));
			ABroadCast(COLOR_YELLOW, szMiscArray, 2);
			format(szMiscArray, sizeof(szMiscArray), "Administrator %s has respawned all dynamic crate vehicles loaded on the server.", GetPlayerNameEx(playerid));
			Log("logs/admin.log", szMiscArray);
		} else {
			if(strval(params) != -1) {
				if(!IsNumeric(params)) return SendClientMessageEx(playerid, COLOR_GRAD2, "Invalid input, please ensure it's a number!");
				if(!ValidGroup(strval(params))) return SendClientMessageEx(playerid, COLOR_GRAD2, "Invalid group ID (0 - %d only)", MAX_GROUPS);
				format(szMiscArray, sizeof(szMiscArray), "** Respawning all dynamic group crate vehicles...");
				foreach(new i: Player) {
					if(PlayerInfo[i][pMember] == strval(params)) {
						SendClientMessageEx(i, arrGroupData[strval(params)][g_hRadioColour] * 256 + 255, szMiscArray);
					}
				}
			}
			for(new v = 0; v < MAX_CRATE_VEHCILES; v++) {
				if(CrateVehicle[v][cvSpawnID] != INVALID_VEHICLE_ID && CrateVehicle[v][cvGroupID] == strval(params)) {
					if(!IsVehicleOccupied(CrateVehicle[v][cvSpawnID]) && !CreateCount(v)) {
						SpawnCrateVeh(v);
					}
				}
			}
			if(strval(params) != -1) {
				format(szMiscArray, sizeof(szMiscArray), "{AA3333}AdmWarning{FFFF00}: %s has respawned %s's dynamic crate vehicles.", GetPlayerNameEx(playerid), arrGroupData[strval(params)][g_szGroupName]);
				ABroadCast(COLOR_YELLOW, szMiscArray, 2);
				format(szMiscArray, sizeof(szMiscArray), "Administrator %s has respawned %s's (%d) dynamic crate vehicles.", GetPlayerNameEx(playerid), arrGroupData[strval(params)][g_szGroupName], strval(params));
				Log("logs/admin.log", szMiscArray);
			}
			else {
				format(szMiscArray, sizeof(szMiscArray), "{AA3333}AdmWarning{FFFF00}: %s has respawned unowned dynamic crate vehicles.", GetPlayerNameEx(playerid));
				ABroadCast(COLOR_YELLOW, szMiscArray, 2);
				format(szMiscArray, sizeof(szMiscArray), "Administrator %s has respawned unowned (-1) dynamic crate vehicles.", GetPlayerNameEx(playerid));
				Log("logs/admin.log", szMiscArray);
			}
		}

	}
	return 1;
}