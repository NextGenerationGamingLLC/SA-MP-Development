ClearCheckpoint(playerid) {
	TaxiAccepted[playerid] = INVALID_PLAYER_ID;
	EMSAccepted[playerid] = INVALID_PLAYER_ID;
	BusAccepted[playerid] = INVALID_PLAYER_ID;
	MedicAccepted[playerid] = INVALID_PLAYER_ID;
	MechanicCallTime[playerid] = 0;
	TaxiCallTime[playerid] = 0;
	BusCallTime[playerid] = 0;


	DeletePVar(playerid, "Smuggling");
	DeletePVar(playerid, "ShipmentCallActive");
	DeletePVar(playerid, "DV_TrackCar");
	DeletePVar(playerid, "TrackVehicleBurglary");
	DeletePVar(playerid, "pGarbageRun");
	DeletePVar(playerid, "pGarbageStage");
	DeletePVar(playerid, "pSellingFish");
	if(GetPVarType(playerid, "DeliveringVehicleTime")) {
		if(GetPVarType(playerid, "LockPickVehicleSQLId")) {
			new szQuery[128];
			mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `vehicles` SET `pvFuel` = %0.5f WHERE `id` = '%d' AND `sqlID` = '%d'", VehicleFuel[GetPVarInt(playerid, "LockPickVehicle")], GetPVarInt(playerid, "LockPickVehicleSQLId"), GetPVarInt(playerid, "LockPickPlayerSQLId"));
			mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
			DeletePVar(playerid, "LockPickVehicleSQLId");
			DeletePVar(playerid, "LockPickPlayerSQLId");
			DeletePVar(playerid, "LockPickPlayerName");
			DestroyVehicle(GetPVarInt(playerid, "LockPickVehicle"));
		}
		else {
			new slot = GetPlayerVehicle(GetPVarInt(playerid, "LockPickPlayer"), GetPVarInt(playerid, "LockPickVehicle"));
			PlayerVehicleInfo[GetPVarInt(playerid, "LockPickPlayer")][slot][pvBeingPickLocked] = 0;
			PlayerVehicleInfo[GetPVarInt(playerid, "LockPickPlayer")][slot][pvBeingPickLockedBy] = INVALID_PLAYER_ID;
		}
		DeletePVar(playerid, "DeliveringVehicleTime");
		DeletePVar(playerid, "LockPickVehicle");
		DeletePVar(playerid, "LockPickPlayer");
	}
    DeletePVar(playerid, "TrackCar");
	DeletePVar(playerid, "Pizza");
	DeletePVar(playerid, "Packages");
	DeletePVar(playerid, "hFind");
	DeletePVar(playerid, "pDTest");
	DeletePVar(playerid, "pDrugRun");
	DeletePVar(playerid, "GiftBoxCP");
	DisablePlayerCheckpoint(playerid);
	gPlayerCheckpointStatus[playerid] = CHECKPOINT_NONE;
	return;
}