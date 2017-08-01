// g_mysql_SaveVehicle(int playerid, int slotid)
// Description: Saves a account's specified vehicle slot.
stock g_mysql_SaveVehicle(playerid, slotid)
{
	szMiscArray[0] = 0;
	printf("%s (%i) saving their %s (slot %i) (Model %i)...", GetPlayerNameEx(playerid), playerid, VehicleName[PlayerVehicleInfo[playerid][slotid][pvModelId] - 400], slotid, PlayerVehicleInfo[playerid][slotid][pvModelId]);

	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "UPDATE `vehicles` SET");
	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `pvPosX` = %0.5f,", szMiscArray, PlayerVehicleInfo[playerid][slotid][pvPosX]);
	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `pvPosY` = %0.5f,", szMiscArray, PlayerVehicleInfo[playerid][slotid][pvPosY]);
	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `pvPosZ` = %0.5f,", szMiscArray, PlayerVehicleInfo[playerid][slotid][pvPosZ]);
	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `pvPosAngle` = %0.5f,", szMiscArray, PlayerVehicleInfo[playerid][slotid][pvPosAngle]);
	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `pvLock` = %d,", szMiscArray, PlayerVehicleInfo[playerid][slotid][pvLock]);
	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `pvLocked` = %d,", szMiscArray, PlayerVehicleInfo[playerid][slotid][pvLocked]);
	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `pvPaintJob` = %d,", szMiscArray, PlayerVehicleInfo[playerid][slotid][pvPaintJob]);
	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `pvColor1` = %d,", szMiscArray, PlayerVehicleInfo[playerid][slotid][pvColor1]);
	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `pvColor2` = %d,", szMiscArray, PlayerVehicleInfo[playerid][slotid][pvColor2]);
	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `pvPrice` = %d,", szMiscArray, PlayerVehicleInfo[playerid][slotid][pvPrice]);
	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `pvWeapon0` = %d,", szMiscArray, PlayerVehicleInfo[playerid][slotid][pvWeapons][0]);
	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `pvWeapon1` = %d,", szMiscArray, PlayerVehicleInfo[playerid][slotid][pvWeapons][1]);
	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `pvWeapon2` = %d,", szMiscArray, PlayerVehicleInfo[playerid][slotid][pvWeapons][2]);
	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `pvLock` = %d,", szMiscArray, PlayerVehicleInfo[playerid][slotid][pvLock]);
	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `pvWepUpgrade` = %d,", szMiscArray, PlayerVehicleInfo[playerid][slotid][pvWepUpgrade]);
	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `pvFuel` = %0.5f,", szMiscArray, PlayerVehicleInfo[playerid][slotid][pvFuel]);
	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `pvImpound` = %d,", szMiscArray, PlayerVehicleInfo[playerid][slotid][pvImpounded]);
	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `pvDisabled` = %d,", szMiscArray, PlayerVehicleInfo[playerid][slotid][pvDisabled]);
	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `pvPlate` = '%e',", szMiscArray, PlayerVehicleInfo[playerid][slotid][pvPlate]);
	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `pvTicket` = %d,", szMiscArray, PlayerVehicleInfo[playerid][slotid][pvTicket]);
	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `pvRestricted` = %d,", szMiscArray, PlayerVehicleInfo[playerid][slotid][pvRestricted]);
	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `pvVW` = %d,", szMiscArray, PlayerVehicleInfo[playerid][slotid][pvVW]);
	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `pvInt` = %d,", szMiscArray, PlayerVehicleInfo[playerid][slotid][pvInt]);
	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `pvCrashFlag` = %d,", szMiscArray, PlayerVehicleInfo[playerid][slotid][pvCrashFlag]);
	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `pvCrashVW` = %d,", szMiscArray, PlayerVehicleInfo[playerid][slotid][pvCrashVW]);
	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `pvCrashX` = %0.5f,", szMiscArray, FormatFloat(PlayerVehicleInfo[playerid][slotid][pvCrashX]));
	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `pvCrashY` = %0.5f,", szMiscArray, FormatFloat(PlayerVehicleInfo[playerid][slotid][pvCrashY]));
	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `pvCrashZ` = %0.5f,", szMiscArray, FormatFloat(PlayerVehicleInfo[playerid][slotid][pvCrashZ]));
	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `pvCrashAngle` = %0.5f,", szMiscArray, FormatFloat(PlayerVehicleInfo[playerid][slotid][pvCrashAngle]));
	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `pvAlarm` = %d,", szMiscArray, PlayerVehicleInfo[playerid][slotid][pvAlarm]);
	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `pvLastLockPickedBy` = '%e',", szMiscArray, PlayerVehicleInfo[playerid][slotid][pvLastLockPickedBy]);
	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `pvLocksLeft` = %d,", szMiscArray, PlayerVehicleInfo[playerid][slotid][pvLocksLeft]);
	new zyear, zmonth, zday;
	getdate(zyear, zmonth, zday);
	if(zombieevent || (zmonth == 10 && zday == 31) || (zmonth == 11 && zday == 1)) format(szMiscArray, sizeof(szMiscArray), "%s `pvHealth` = %0.5f,", szMiscArray, PlayerVehicleInfo[playerid][slotid][pvHealth]);
	
	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s\
		`Pot` = %d,\
		`Crack` = %d,\
		`Meth` = %d,\
		`Ecstasy` = %d,\
		`Heroin` = %d,",
		szMiscArray,
		PlayerVehicleInfo[playerid][slotid][pvDrugs][0],
		PlayerVehicleInfo[playerid][slotid][pvDrugs][1],
		PlayerVehicleInfo[playerid][slotid][pvDrugs][2],
		PlayerVehicleInfo[playerid][slotid][pvDrugs][3],
		PlayerVehicleInfo[playerid][slotid][pvDrugs][4]);

	for(new m = 0; m < MAX_MODS; m++)
	{
		if(m == MAX_MODS-1)
		{
			mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `pvMod%d` = %d WHERE `id` = '%d'", szMiscArray, m, PlayerVehicleInfo[playerid][slotid][pvMods][m], PlayerVehicleInfo[playerid][slotid][pvSlotId]);
		}
		else
		{
			mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `pvMod%d` = %d,", szMiscArray, m, PlayerVehicleInfo[playerid][slotid][pvMods][m]);
		}
	}
    //print(szMiscArray);

	new szLog[128];
	format(szLog, sizeof(szLog), "[VEHICLESAVE] [User: %s(%i)] [Model: %d] [Vehicle ID: %d]", GetPlayerNameEx(playerid), PlayerInfo[playerid][pId], PlayerVehicleInfo[playerid][slotid][pvModelId], PlayerVehicleInfo[playerid][slotid][pvSlotId]);
	Log("logs/vehicledebug.log", szLog);
	
	mysql_tquery(MainPipeline, szMiscArray, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
}

stock CreatePlayerVehicle(playerid, playervehicleid, modelid, Float: x, Float: y, Float: z, Float: angle, color1, color2, price, VW, Int)
{
	szMiscArray[0] = 0;
	if(PlayerVehicleInfo[playerid][playervehicleid][pvId] == INVALID_PLAYER_VEHICLE_ID)
	{
 		VehicleSpawned[playerid]++;
	    PlayerCars++;
		PlayerVehicleInfo[playerid][playervehicleid][pvModelId] = modelid;
		PlayerVehicleInfo[playerid][playervehicleid][pvPosX] = x;
		PlayerVehicleInfo[playerid][playervehicleid][pvPosY] = y;
		PlayerVehicleInfo[playerid][playervehicleid][pvPosZ] = z;
		PlayerVehicleInfo[playerid][playervehicleid][pvPosAngle] = angle;
		PlayerVehicleInfo[playerid][playervehicleid][pvColor1] = color1;
		PlayerVehicleInfo[playerid][playervehicleid][pvColor2] = color2;
		PlayerVehicleInfo[playerid][playervehicleid][pvPark] = 1;
		PlayerVehicleInfo[playerid][playervehicleid][pvPrice] = price;
		for(new w = 0; w < 3; w++)
	    {
	    	PlayerVehicleInfo[playerid][playervehicleid][pvWeapons][w] = 0;
		}
		PlayerVehicleInfo[playerid][playervehicleid][pvWepUpgrade] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvImpounded] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvVW] = VW;
		PlayerVehicleInfo[playerid][playervehicleid][pvInt] = Int;
		PlayerVehicleInfo[playerid][playervehicleid][pvTicket] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvPlate] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvLock] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvLocksLeft] = 5;
        PlayerVehicleInfo[playerid][playervehicleid][pvLocked] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvAlarm] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvAlarmTriggered] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvBeingPickLocked] = 0;

		for(new m; m < sizeof(Drugs); ++m) PlayerVehicleInfo[playerid][playervehicleid][pvDrugs][m] = 0;
		
		for(new m = 0; m < MAX_MODS; m++)
	    {
	    	PlayerVehicleInfo[playerid][playervehicleid][pvMods][m] = 0;
		}
		new carcreated = CreateVehicle(modelid,x,y,z,angle,color1,color2,-1);
		SetVehicleVirtualWorld(carcreated, PlayerVehicleInfo[playerid][playervehicleid][pvVW]);
  		LinkVehicleToInterior(carcreated, PlayerVehicleInfo[playerid][playervehicleid][pvInt]);
		Vehicle_ResetData(carcreated);
		PlayerVehicleInfo[playerid][playervehicleid][pvId] = carcreated;
		PlayerVehicleInfo[playerid][playervehicleid][pvSpawned] = 1;
		PlayerVehicleInfo[playerid][playervehicleid][pvFuel] = 100.0;
		//SetVehicleNumberPlate(carcreated, PlayerVehicleInfo[playerid][playervehicleid][pvNumberPlate]);

        mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "INSERT INTO `vehicles` (`sqlID`) VALUES ('%d')", GetPlayerSQLId(playerid));
		mysql_tquery(MainPipeline, szMiscArray, "OnQueryCreateVehicle", "ii", playerid, playervehicleid);

		return carcreated;
	}
	return INVALID_PLAYER_VEHICLE_ID;
}

stock DestroyPlayerVehicle(playerid, playervehicleid)
{
	if(PlayerVehicleInfo[playerid][playervehicleid][pvModelId])
	{
	    VehicleSpawned[playerid]--;
	    PlayerCars--;
		
		switch(PlayerVehicleInfo[playerid][playervehicleid][pvModelId]) {
			case 519, 553, 508: {
				if(IsValidDynamicArea(iVehEnterAreaID[PlayerVehicleInfo[playerid][playervehicleid][pvId]])) DestroyDynamicArea(iVehEnterAreaID[PlayerVehicleInfo[playerid][playervehicleid][pvId]]);
			}
		}

		DestroyVehicle(PlayerVehicleInfo[playerid][playervehicleid][pvId]);
		PlayerVehicleInfo[playerid][playervehicleid][pvModelId] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvPosX] = 0.0;
		PlayerVehicleInfo[playerid][playervehicleid][pvPosY] = 0.0;
		PlayerVehicleInfo[playerid][playervehicleid][pvPosZ] = 0.0;
		PlayerVehicleInfo[playerid][playervehicleid][pvPosAngle] = 0.0;
		PlayerVehicleInfo[playerid][playervehicleid][pvPaintJob] = -1;
		PlayerVehicleInfo[playerid][playervehicleid][pvColor1] = 126;
		PlayerVehicleInfo[playerid][playervehicleid][pvColor2] = 126;
		PlayerVehicleInfo[playerid][playervehicleid][pvPrice] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvFuel] = 0.0;
		PlayerVehicleInfo[playerid][playervehicleid][pvImpounded] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvSpawned] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvVW] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvInt] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvTicket] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvWeapons][0] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvWeapons][1] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvWeapons][2] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvPlate] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvLock] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvLocksLeft] = 0;
        PlayerVehicleInfo[playerid][playervehicleid][pvLocked] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvAlarm] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvAlarmTriggered] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvBeingPickLocked] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvBeingPickLockedBy] = INVALID_PLAYER_ID;
		PlayerVehicleInfo[playerid][playervehicleid][pvLastLockPickedBy] = 0;
		VehicleFuel[PlayerVehicleInfo[playerid][playervehicleid][pvId]] = 0.0;
	    PlayerVehicleInfo[playerid][playervehicleid][pvId] = INVALID_PLAYER_VEHICLE_ID;
	    if(PlayerVehicleInfo[playerid][playervehicleid][pvAllowedPlayerId] != INVALID_PLAYER_ID)
	    {
	        PlayerInfo[PlayerVehicleInfo[playerid][playervehicleid][pvAllowedPlayerId]][pVehicleKeys] = INVALID_PLAYER_VEHICLE_ID;
	        PlayerInfo[PlayerVehicleInfo[playerid][playervehicleid][pvAllowedPlayerId]][pVehicleKeysFrom] = INVALID_PLAYER_ID;
	    	PlayerVehicleInfo[playerid][playervehicleid][pvAllowedPlayerId] = INVALID_PLAYER_ID;
		}
		for(new m; m < sizeof(Drugs); ++m) PlayerVehicleInfo[playerid][playervehicleid][pvDrugs][m] = 0;

		new query[60];
		mysql_format(MainPipeline, query, sizeof(query), "DELETE FROM `vehicles` WHERE `id` = '%d'", PlayerVehicleInfo[playerid][playervehicleid][pvSlotId]);
		mysql_tquery(MainPipeline, query, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
		PlayerVehicleInfo[playerid][playervehicleid][pvSlotId] = 0;

		//g_mysql_SaveVehicle(playerid, playervehicleid);
	}
}

stock LoadPlayerVehicles(playerid, logoff = 0) {
	for(new v = 0; v < MAX_PLAYERVEHICLES; v++) {
		if(PlayerVehicleInfo[playerid][v][pvBeingPickLocked] > 0 && logoff == 0) continue;
		if(vehicleSpawnCountCheck(playerid)) {
			if(PlayerVehicleInfo[playerid][v][pvModelId] >= 400) {
				if(PlayerVehicleInfo[playerid][v][pvSpawned] && !PlayerVehicleInfo[playerid][v][pvDisabled] && !PlayerVehicleInfo[playerid][v][pvImpounded]) {

					PlayerCars++;
					VehicleSpawned[playerid]++;
					new carcreated = CreateVehicle(PlayerVehicleInfo[playerid][v][pvModelId], PlayerVehicleInfo[playerid][v][pvPosX], PlayerVehicleInfo[playerid][v][pvPosY], PlayerVehicleInfo[playerid][v][pvPosZ], PlayerVehicleInfo[playerid][v][pvPosAngle],PlayerVehicleInfo[playerid][v][pvColor1], PlayerVehicleInfo[playerid][v][pvColor2], -1);

					SetVehicleVirtualWorld(carcreated, PlayerVehicleInfo[playerid][v][pvVW]);
  					LinkVehicleToInterior(carcreated, PlayerVehicleInfo[playerid][v][pvInt]);

  					switch(GetVehicleModel(carcreated)) {
						case 519, 553, 508: {
							iVehEnterAreaID[carcreated] = CreateDynamicSphere(PlayerVehicleInfo[playerid][v][pvPosX]+2, PlayerVehicleInfo[playerid][v][pvPosY], PlayerVehicleInfo[playerid][v][pvPosZ], 4, GetVehicleVirtualWorld(carcreated));
							AttachDynamicAreaToVehicle(iVehEnterAreaID[carcreated], carcreated);
							Streamer_SetIntData(STREAMER_TYPE_AREA, iVehEnterAreaID[carcreated], E_STREAMER_EXTRA_ID, carcreated);
						}
					}

					Vehicle_ResetData(carcreated);
					PlayerVehicleInfo[playerid][v][pvId] = carcreated;
					VehicleFuel[carcreated] = PlayerVehicleInfo[playerid][v][pvFuel];

					if(PlayerVehicleInfo[playerid][v][pvLocked]) {
						if(PlayerVehicleInfo[playerid][v][pvLocksLeft]) LockPlayerVehicle(playerid, carcreated, PlayerVehicleInfo[playerid][v][pvLock]);
						else PlayerVehicleInfo[playerid][v][pvLocked] = 0;
					}
					LoadPlayerVehicleMods(playerid, v);

					if(PlayerVehicleInfo[playerid][v][pvCrashFlag] == 1 && PlayerVehicleInfo[playerid][v][pvCrashX] != 0.0)
					{
						SetVehiclePos(carcreated, PlayerVehicleInfo[playerid][v][pvCrashX], PlayerVehicleInfo[playerid][v][pvCrashY], PlayerVehicleInfo[playerid][v][pvCrashZ]);
						SetVehicleZAngle(carcreated, PlayerVehicleInfo[playerid][v][pvCrashAngle]);
						SetVehicleVirtualWorld(carcreated, PlayerVehicleInfo[playerid][v][pvCrashVW]);
						PlayerVehicleInfo[playerid][v][pvCrashFlag] = 0;
						PlayerVehicleInfo[playerid][v][pvCrashVW] = 0;
						PlayerVehicleInfo[playerid][v][pvCrashX] = 0.0;
						PlayerVehicleInfo[playerid][v][pvCrashY] = 0.0;
						PlayerVehicleInfo[playerid][v][pvCrashZ] = 0.0;
						PlayerVehicleInfo[playerid][v][pvCrashAngle] = 0.0;
						SendClientMessageEx(playerid, COLOR_WHITE, "Your vehicles have been restored to their last known location from your previous timeout.");
					}
				}
				else if(PlayerVehicleInfo[playerid][v][pvSpawned] != 0) {
					PlayerVehicleInfo[playerid][v][pvSpawned] = 0;
				}
			}
			else if(PlayerVehicleInfo[playerid][v][pvImpounded] != 0) {
				PlayerVehicleInfo[playerid][v][pvImpounded] = 0;
			}
			else if(PlayerVehicleInfo[playerid][v][pvSpawned] != 0) {
				PlayerVehicleInfo[playerid][v][pvSpawned] = 0;
			}
		}
		else PlayerVehicleInfo[playerid][v][pvSpawned] = 0;
	}
	return 1;
}

stock UnloadPlayerVehicles(playerid, logoff = 0, reason = 0) {
	for(new v = 0; v < MAX_PLAYERVEHICLES; v++) if(PlayerVehicleInfo[playerid][v][pvId] != INVALID_PLAYER_VEHICLE_ID && !PlayerVehicleInfo[playerid][v][pvImpounded] && PlayerVehicleInfo[playerid][v][pvSpawned]) {
		if(PlayerVehicleInfo[playerid][v][pvBeingPickLocked] > 0 && logoff == 0) continue;
		if(WheelClamp{PlayerVehicleInfo[playerid][v][pvId]} && logoff == 1) {
			PlayerVehicleInfo[playerid][v][pvImpounded] = 1;
		}
		if(IsVehicleInTow(PlayerVehicleInfo[playerid][v][pvId]) && logoff == 1)
		{
			DetachTrailerFromVehicle(GetPlayerVehicleID(playerid));
			PlayerVehicleInfo[playerid][v][pvImpounded] = 1;
			SetVehiclePos(PlayerVehicleInfo[playerid][v][pvId], 0, 0, 0); // Attempted desync fix
		}
		GetVehicleHealth(PlayerVehicleInfo[playerid][v][pvId], PlayerVehicleInfo[playerid][v][pvHealth]);
		if(PlayerVehicleInfo[playerid][v][pvBeingPickLocked] > 0) {
			new extraid = PlayerVehicleInfo[playerid][v][pvBeingPickLockedBy];
			SetPVarInt(extraid, "LockPickVehicleSQLId", PlayerVehicleInfo[playerid][v][pvSlotId]);
			SetPVarInt(extraid, "LockPickPlayerSQLId", GetPlayerSQLId(playerid));
			SetPVarInt(extraid, "VLPLocksLeft", PlayerVehicleInfo[playerid][v][pvLocksLeft]);
			SetPVarInt(extraid, "VLPTickets", PlayerVehicleInfo[playerid][v][pvTicket]);
			SetPVarString(extraid, "LockPickPlayerName", GetPlayerNameEx(playerid));
			new szMessage[150], rsMessage[20];
			switch(reason){
				case 0: rsMessage = "timed out";
				case 1:	rsMessage = "logged off";
				case 2: rsMessage = "been kicked/banned";
			}
			format(szMessage, sizeof(szMessage), "The player (%s) that owns this vehicle (%s) has %s.", GetPlayerNameEx(playerid), GetVehicleName(PlayerVehicleInfo[playerid][v][pvId]), rsMessage);
			SendClientMessageEx(extraid, COLOR_YELLOW, szMessage);
			new ip2[MAX_PLAYER_NAME];
			GetPlayerIp(extraid, ip2, sizeof(ip2));
			SendClientMessageEx(extraid, COLOR_YELLOW, "(( The vehicle will de-spawn once you complete or fail the deliver. ))");
			format(szMessage, sizeof(szMessage), "[LOCK PICK] %s(%d) (IP:%s) has %s while his %s(VID:%d Slot %d) was lock picked by %s(IP:%s SQLId: %d)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), PlayerInfo[playerid][pIP], rsMessage, GetVehicleName(PlayerVehicleInfo[playerid][v][pvId]), PlayerVehicleInfo[playerid][v][pvId], v, GetPlayerNameEx(extraid), ip2, GetPlayerSQLId(extraid));
			Log("logs/playervehicle.log", szMessage);
			DeletePVar(extraid, "LockPickPlayer");
			PlayerVehicleInfo[playerid][v][pvBeingPickLocked] = 0;
			PlayerVehicleInfo[playerid][v][pvBeingPickLockedBy] = INVALID_PLAYER_ID;
		}
		else {
			if(LockStatus{PlayerVehicleInfo[playerid][v][pvId]} != 0) LockStatus{PlayerVehicleInfo[playerid][v][pvId]} = 0;

			switch(PlayerVehicleInfo[playerid][v][pvModelId]) {
				case 519, 553, 508: {
					if(IsValidDynamicArea(iVehEnterAreaID[PlayerVehicleInfo[playerid][v][pvId]])) DestroyDynamicArea(iVehEnterAreaID[PlayerVehicleInfo[playerid][v][pvId]]);
				}
			}

			DestroyVehicle(PlayerVehicleInfo[playerid][v][pvId]);
		}
		PlayerCars--;
		PlayerVehicleInfo[playerid][v][pvId] = INVALID_PLAYER_VEHICLE_ID;
		PlayerVehicleInfo[playerid][v][pvSpawned] = 0;
		if(PlayerVehicleInfo[playerid][v][pvAllowedPlayerId] != INVALID_PLAYER_ID)
		{
			PlayerInfo[PlayerVehicleInfo[playerid][v][pvAllowedPlayerId]][pVehicleKeys] = INVALID_PLAYER_VEHICLE_ID;
			PlayerInfo[PlayerVehicleInfo[playerid][v][pvAllowedPlayerId]][pVehicleKeysFrom] = INVALID_PLAYER_ID;
			PlayerVehicleInfo[playerid][v][pvAllowedPlayerId] = INVALID_PLAYER_ID;
		}
		g_mysql_SaveVehicle(playerid, v);
    }
	VehicleSpawned[playerid] = 0;
}

stock UpdatePlayerVehicleParkPosition(playerid, playervehicleid, Float:newx, Float:newy, Float:newz, Float:newangle, Float:health, VW, Int)
{
	if(PlayerVehicleInfo[playerid][playervehicleid][pvId] != INVALID_PLAYER_VEHICLE_ID && GetVehicleModel(PlayerVehicleInfo[playerid][playervehicleid][pvId]))
	{
		new Float:oldx, Float:oldy, Float:oldz, Float: oldfuel, arrDamage[4];
		oldx = PlayerVehicleInfo[playerid][playervehicleid][pvPosX];
		oldy = PlayerVehicleInfo[playerid][playervehicleid][pvPosY];
		oldz = PlayerVehicleInfo[playerid][playervehicleid][pvPosZ];

		if(oldx == newx && oldy == newy && oldz == newz) return 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvPosX] = newx;
		PlayerVehicleInfo[playerid][playervehicleid][pvPosY] = newy;
		PlayerVehicleInfo[playerid][playervehicleid][pvPosZ] = newz;
		PlayerVehicleInfo[playerid][playervehicleid][pvPosAngle] = newangle;
		PlayerVehicleInfo[playerid][playervehicleid][pvVW] = VW;
		PlayerVehicleInfo[playerid][playervehicleid][pvInt] = Int;
		oldfuel = VehicleFuel[PlayerVehicleInfo[playerid][playervehicleid][pvId]];
		UpdatePlayerVehicleMods(playerid, playervehicleid);
		GetVehicleDamageStatus(PlayerVehicleInfo[playerid][playervehicleid][pvId], arrDamage[0], arrDamage[1], arrDamage[2], arrDamage[3]);
		
		switch(PlayerVehicleInfo[playerid][playervehicleid][pvModelId]) {
			case 519, 553, 508: {
				if(IsValidDynamicArea(iVehEnterAreaID[PlayerVehicleInfo[playerid][playervehicleid][pvId]])) DestroyDynamicArea(iVehEnterAreaID[PlayerVehicleInfo[playerid][playervehicleid][pvId]]);
			}
		}

		DestroyVehicle(PlayerVehicleInfo[playerid][playervehicleid][pvId]);

		new carcreated = CreateVehicle(PlayerVehicleInfo[playerid][playervehicleid][pvModelId], PlayerVehicleInfo[playerid][playervehicleid][pvPosX], PlayerVehicleInfo[playerid][playervehicleid][pvPosY], PlayerVehicleInfo[playerid][playervehicleid][pvPosZ],
		PlayerVehicleInfo[playerid][playervehicleid][pvPosAngle],PlayerVehicleInfo[playerid][playervehicleid][pvColor1], PlayerVehicleInfo[playerid][playervehicleid][pvColor2], -1);
		SetVehicleVirtualWorld(carcreated, PlayerVehicleInfo[playerid][playervehicleid][pvVW]);
  		LinkVehicleToInterior(carcreated, PlayerVehicleInfo[playerid][playervehicleid][pvInt]);

  		switch(GetVehicleModel(carcreated)) {
			case 519, 553, 508: {
				iVehEnterAreaID[carcreated] = CreateDynamicSphere(PlayerVehicleInfo[playerid][playervehicleid][pvPosX]+2, PlayerVehicleInfo[playerid][playervehicleid][pvPosY], PlayerVehicleInfo[playerid][playervehicleid][pvPosZ], 2.0, GetVehicleVirtualWorld(carcreated));
				AttachDynamicAreaToVehicle(iVehEnterAreaID[carcreated], carcreated);
				Streamer_SetIntData(STREAMER_TYPE_AREA, iVehEnterAreaID[carcreated], E_STREAMER_EXTRA_ID, carcreated);
			}
		}
		PlayerVehicleInfo[playerid][playervehicleid][pvId] = carcreated;
		Vehicle_ResetData(carcreated);
		VehicleFuel[carcreated] = oldfuel;
		// SetVehicleNumberPlate(carcreated, PlayerVehicleInfo[playerid][playervehicleid][pvNumberPlate]);
		SetVehicleHealth(carcreated, health);
		if(PlayerVehicleInfo[playerid][playervehicleid][pvLocked] == 1) LockPlayerVehicle(playerid, PlayerVehicleInfo[playerid][playervehicleid][pvId], PlayerVehicleInfo[playerid][playervehicleid][pvLock]);
		LoadPlayerVehicleMods(playerid, playervehicleid);
		UpdateVehicleDamageStatus(PlayerVehicleInfo[playerid][playervehicleid][pvId], arrDamage[0], arrDamage[1], arrDamage[2], arrDamage[3]);

		g_mysql_SaveVehicle(playerid, playervehicleid);
		return 1;
	}
	return 0;
}

stock UpdatePlayerVehicleMods(playerid, playervehicleid)
{
	if(GetVehicleModel(PlayerVehicleInfo[playerid][playervehicleid][pvId]) && PlayerVehicleInfo[playerid][playervehicleid][pvImpounded] == 0 && PlayerVehicleInfo[playerid][playervehicleid][pvSpawned] == 1 && !PlayerVehicleInfo[playerid][playervehicleid][pvDisabled]) {
		new carid = PlayerVehicleInfo[playerid][playervehicleid][pvId];
		new exhaust, frontbumper, rearbumper, roof, spoilers, sideskirt1,
			sideskirt2, wheels, hydraulics, nitro, hood, lamps, stereo, ventright, ventleft;
		exhaust = GetVehicleComponentInSlot(carid, CARMODTYPE_EXHAUST);
		frontbumper = GetVehicleComponentInSlot(carid, CARMODTYPE_FRONT_BUMPER);
		rearbumper = GetVehicleComponentInSlot(carid, CARMODTYPE_REAR_BUMPER);
		roof = GetVehicleComponentInSlot(carid, CARMODTYPE_ROOF);
		spoilers = GetVehicleComponentInSlot(carid, CARMODTYPE_SPOILER);
		sideskirt1 = GetVehicleComponentInSlot(carid, CARMODTYPE_SIDESKIRT);
		sideskirt2 = GetVehicleComponentInSlot(carid, CARMODTYPE_SIDESKIRT);
		wheels = GetVehicleComponentInSlot(carid, CARMODTYPE_WHEELS);
		hydraulics = GetVehicleComponentInSlot(carid, CARMODTYPE_HYDRAULICS);
		nitro = GetVehicleComponentInSlot(carid, CARMODTYPE_NITRO);
		hood = GetVehicleComponentInSlot(carid, CARMODTYPE_HOOD);
		lamps = GetVehicleComponentInSlot(carid, CARMODTYPE_LAMPS);
		stereo = GetVehicleComponentInSlot(carid, CARMODTYPE_STEREO);
		ventright = GetVehicleComponentInSlot(carid, CARMODTYPE_VENT_RIGHT);
		ventleft = GetVehicleComponentInSlot(carid, CARMODTYPE_VENT_LEFT);
		if(spoilers >= 1000)    PlayerVehicleInfo[playerid][playervehicleid][pvMods][0] = spoilers;
		if(hood >= 1000)        PlayerVehicleInfo[playerid][playervehicleid][pvMods][1] = hood;
		if(roof >= 1000)        PlayerVehicleInfo[playerid][playervehicleid][pvMods][2] = roof;
		if(sideskirt1 >= 1000)  PlayerVehicleInfo[playerid][playervehicleid][pvMods][3] = sideskirt1;
		if(lamps >= 1000)       PlayerVehicleInfo[playerid][playervehicleid][pvMods][4] = lamps;
		if(nitro >= 1000)       PlayerVehicleInfo[playerid][playervehicleid][pvMods][5] = nitro;
		if(exhaust >= 1000)     PlayerVehicleInfo[playerid][playervehicleid][pvMods][6] = exhaust;
		if(wheels >= 1000)      PlayerVehicleInfo[playerid][playervehicleid][pvMods][7] = wheels;
		if(stereo >= 1000)      PlayerVehicleInfo[playerid][playervehicleid][pvMods][8] = stereo;
		if(hydraulics >= 1000)  PlayerVehicleInfo[playerid][playervehicleid][pvMods][9] = hydraulics;
		if(frontbumper >= 1000) PlayerVehicleInfo[playerid][playervehicleid][pvMods][10] = frontbumper;
		if(rearbumper >= 1000)  PlayerVehicleInfo[playerid][playervehicleid][pvMods][11] = rearbumper;
		if(ventright >= 1000)   PlayerVehicleInfo[playerid][playervehicleid][pvMods][12] = ventright;
		if(ventleft >= 1000)    PlayerVehicleInfo[playerid][playervehicleid][pvMods][13] = ventleft;
		if(sideskirt2 >= 1000)  PlayerVehicleInfo[playerid][playervehicleid][pvMods][14] = sideskirt2;

		g_mysql_SaveVehicle(playerid, playervehicleid);
	}
}

stock LoadPlayerVehicleMods(playerid, playervehicleid)
{
	if(GetVehicleModel(PlayerVehicleInfo[playerid][playervehicleid][pvId]) && PlayerVehicleInfo[playerid][playervehicleid][pvImpounded] == 0 && PlayerVehicleInfo[playerid][playervehicleid][pvSpawned] == 1) {

        if(strlen(PlayerVehicleInfo[playerid][playervehicleid][pvPlate]) > 0)
		{
		    SetVehicleNumberPlate(PlayerVehicleInfo[playerid][playervehicleid][pvId], PlayerVehicleInfo[playerid][playervehicleid][pvPlate]);
		    SetVehiclePos(PlayerVehicleInfo[playerid][playervehicleid][pvId], 9999.9, 9999.9, 9999.9);
		    SetVehiclePos(PlayerVehicleInfo[playerid][playervehicleid][pvId], PlayerVehicleInfo[playerid][playervehicleid][pvPosX], PlayerVehicleInfo[playerid][playervehicleid][pvPosY], PlayerVehicleInfo[playerid][playervehicleid][pvPosZ]);
		}

		if(PlayerVehicleInfo[playerid][playervehicleid][pvPaintJob] != -1)
		{
			 ChangeVehiclePaintjob(PlayerVehicleInfo[playerid][playervehicleid][pvId], PlayerVehicleInfo[playerid][playervehicleid][pvPaintJob]);
			 ChangeVehicleColor(PlayerVehicleInfo[playerid][playervehicleid][pvId], PlayerVehicleInfo[playerid][playervehicleid][pvColor1], PlayerVehicleInfo[playerid][playervehicleid][pvColor2]);
		}
		for(new m = 0; m < MAX_MODS; m++)
		{
		    if (PlayerVehicleInfo[playerid][playervehicleid][pvMods][m] >= 1000  && PlayerVehicleInfo[playerid][playervehicleid][pvMods][m] <= 1193)
		    {
				if (InvalidModCheck(GetVehicleModel(PlayerVehicleInfo[playerid][playervehicleid][pvId]),PlayerVehicleInfo[playerid][playervehicleid][pvMods][m]))
				{
					AddVehicleComponent(PlayerVehicleInfo[playerid][playervehicleid][pvId], PlayerVehicleInfo[playerid][playervehicleid][pvMods][m]);
				}
				else
				{
				    PlayerVehicleInfo[playerid][playervehicleid][pvMods][m] = 0;
				}
			}
		}
	}
}

LoadPlayerDisabledVehicles(playerid)
{
	new vehiclecount;
	switch(PlayerInfo[playerid][pDonateRank]) {
		case 0: {
			for(new v = 0; v < MAX_PLAYERVEHICLES; v++)
			{
				vehiclecount++;
				if(PlayerInfo[playerid][pVehicleSlot] + 6 <= vehiclecount) {
					PlayerVehicleInfo[playerid][v][pvDisabled] = 1;
				} else {
					PlayerVehicleInfo[playerid][v][pvDisabled] = 0;
				}	
			}
		}
		case 1: {
            for(new v = 0; v < MAX_PLAYERVEHICLES; v++)
			{
				vehiclecount++;
				if(PlayerInfo[playerid][pVehicleSlot] + 7 <= vehiclecount) {
					PlayerVehicleInfo[playerid][v][pvDisabled] = 1;
				} else {
					PlayerVehicleInfo[playerid][v][pvDisabled] = 0;
				}	
			}
		}
		case 2: {
            for(new v = 0; v < MAX_PLAYERVEHICLES; v++)
			{
				vehiclecount++;
				if(PlayerInfo[playerid][pVehicleSlot] + 8 <= vehiclecount) {
					PlayerVehicleInfo[playerid][v][pvDisabled] = 1;
				} else {
					PlayerVehicleInfo[playerid][v][pvDisabled] = 0;
				}	
			}
        }
		case 3: {
            for(new v = 0; v < MAX_PLAYERVEHICLES; v++)
			{
				vehiclecount++;
				if(PlayerInfo[playerid][pVehicleSlot] + 9 <= vehiclecount) {
					PlayerVehicleInfo[playerid][v][pvDisabled] = 1;
				} else {
					PlayerVehicleInfo[playerid][v][pvDisabled] = 0;
				}	
			}
        }
        default: {
        	for(new v = 0; v < MAX_PLAYERVEHICLES; v++)
			{
				vehiclecount++;
				if(PlayerInfo[playerid][pVehicleSlot] + 11 <= vehiclecount) {
					PlayerVehicleInfo[playerid][v][pvDisabled] = 1;
				} else {
					PlayerVehicleInfo[playerid][v][pvDisabled] = 0;
				}	
			}
        }
	}
	return 1;
}	

stock GetPlayerFreeVehicleId(playerid) {
	for(new i; i < MAX_PLAYERVEHICLES; ++i) {
		if(PlayerVehicleInfo[playerid][i][pvModelId] == 0) return i;
	}
	return -1;
}

stock GetPlayerVehicle(playerid, vehicleid)
{
    for(new v = 0; v < MAX_PLAYERVEHICLES; v++)
    {
        if(PlayerVehicleInfo[playerid][v][pvId] == vehicleid)
        {
            return v;
        }
    }
    return -1;
}

stock FindPlayerVehicleWithSQLId(ownerid, sqlid)
{
	new
		i = 0;
	while (i < MAX_PLAYERVEHICLES && PlayerVehicleInfo[ownerid][i][pvSlotId] != sqlid)
	{
		i++;
	}
	if (i == MAX_PLAYERVEHICLES) return -1;
	return i;
}

forward ParkVehicle(playerid, ownerid, vehicleid, d, Float:X, Float:Y, Float:Z);
public ParkVehicle(playerid, ownerid, vehicleid, d, Float:X, Float:Y, Float:Z)
{
	if(IsPlayerInRangeOfPoint(playerid, 1.0, X, Y, Z))
	{
	    new Float:x, Float:y, Float:z, Float:angle, Float:health, string[29 + (MAX_PLAYER_NAME * 2)];
	    GetVehicleHealth(vehicleid, health);
     	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessageEx(playerid, COLOR_GREY, "You must be in the driver seat.");
     	if(health < 800) return SendClientMessageEx(playerid, COLOR_GREY, " Your vehicle is too damaged to park it.");
		if(ownerid != INVALID_PLAYER_ID)
	    {
			GetVehiclePos(vehicleid, x, y, z);
			GetVehicleZAngle(vehicleid, angle);
			SurfingCheck(vehicleid);
			UpdatePlayerVehicleParkPosition(ownerid, d, x, y, z, angle, health, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
			IsPlayerEntering{playerid} = true;
			PutPlayerInVehicle(playerid, vehicleid, 0);
			SetPlayerArmedWeapon(playerid, 0);
			format(string, sizeof(string), "* %s has parked %s's vehicle.", GetPlayerNameEx(playerid), GetPlayerNameEx(ownerid));
		}
		else
		{
		    GetVehiclePos(vehicleid, x, y, z);
			GetVehicleZAngle(vehicleid, angle);
			SurfingCheck(vehicleid);
			UpdatePlayerVehicleParkPosition(playerid, d, x, y, z, angle, health, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
			IsPlayerEntering{playerid} = true;
			PutPlayerInVehicle(playerid, vehicleid, 0);
			SetPlayerArmedWeapon(playerid, 0);
			format(string, sizeof(string), "* %s has parked their vehicle.", GetPlayerNameEx(playerid), GetPlayerNameEx(ownerid));
		}
		ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	}
	else
	{
	    SendClientMessage(playerid, COLOR_WHITE, "Vehicle did not park because you moved!");
	}
	return 1;
}