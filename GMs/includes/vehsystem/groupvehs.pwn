forward LoadDynamicGroupVehicles();
public LoadDynamicGroupVehicles()
{
	mysql_function_query(MainPipeline, "SELECT * FROM `groupvehs`", true, "DynVeh_QueryFinish", "ii", GV_QUERY_LOAD, 0);
	return 1;
}

forward DynVeh_QueryFinish(iType, iExtraID);
public DynVeh_QueryFinish(iType, iExtraID) {

	new
		iFields,
		iRows,
		iIndex,
		i = 0,
		sqlid,
		szResult[128];

	cache_get_data(iRows, iFields, MainPipeline);
	switch(iType) {
		case GV_QUERY_LOAD:
		{
		    format(szResult, sizeof(szResult), "UPDATE `groupvehs` SET `SpawnedID` = %d", INVALID_VEHICLE_ID);
			mysql_function_query(MainPipeline, szResult, false, "OnQueryFinish", "i", SENDDATA_THREAD);
			while((iIndex < iRows) && (iIndex < MAX_DYNAMIC_VEHICLES)) {
			    cache_get_field_content(iIndex, "id", szResult, MainPipeline); sqlid = strval(szResult);
				if((sqlid >= MAX_DYNAMIC_VEHICLES)) {// Array bounds check. Use it.
					format(szResult, sizeof(szResult), "DELETE FROM `groupvehs` WHERE `id` = %d", sqlid);
					mysql_function_query(MainPipeline, szResult, false, "OnQueryFinish", "i", SENDDATA_THREAD);
					return printf("SQL ID %d exceeds Max Dynamic Vehicles", sqlid);
				}
				cache_get_field_content(iIndex, "gID", szResult, MainPipeline); DynVehicleInfo[sqlid][gv_igID] = strval(szResult);
				cache_get_field_content(iIndex, "gDivID", szResult, MainPipeline); DynVehicleInfo[sqlid][gv_igDivID] = strval(szResult);
				cache_get_field_content(iIndex, "rID", szResult, MainPipeline); DynVehicleInfo[sqlid][gv_irID] = strval(szResult);
				cache_get_field_content(iIndex, "vModel", szResult, MainPipeline); DynVehicleInfo[sqlid][gv_iModel] = strval(szResult);
                switch(DynVehicleInfo[sqlid][gv_iModel]) {
					case 538, 537, 449, 590, 569, 570: {
					    DynVehicleInfo[sqlid][gv_iModel] = 0;
					}
				}
				cache_get_field_content(iIndex, "vPlate", DynVehicleInfo[sqlid][gv_iPlate], MainPipeline, 32);
				cache_get_field_content(iIndex, "vMaxHealth", szResult, MainPipeline); DynVehicleInfo[sqlid][gv_fMaxHealth] = floatstr(szResult);
				cache_get_field_content(iIndex, "vType", szResult, MainPipeline); DynVehicleInfo[sqlid][gv_iType] = strval(szResult);
				cache_get_field_content(iIndex, "vLoadMax", szResult, MainPipeline); DynVehicleInfo[sqlid][gv_iLoadMax] = strval(szResult);
				if(DynVehicleInfo[sqlid][gv_iLoadMax] > 6) {
                    DynVehicleInfo[sqlid][gv_iLoadMax] = 6;
				}
				cache_get_field_content(iIndex, "vCol1", szResult, MainPipeline); DynVehicleInfo[sqlid][gv_iCol1] = strval(szResult);
				cache_get_field_content(iIndex, "vCol2", szResult, MainPipeline); DynVehicleInfo[sqlid][gv_iCol2] = strval(szResult);
				cache_get_field_content(iIndex, "vX", szResult, MainPipeline); DynVehicleInfo[sqlid][gv_fX] = floatstr(szResult);
				cache_get_field_content(iIndex, "vY", szResult, MainPipeline); DynVehicleInfo[sqlid][gv_fY] = floatstr(szResult);
				cache_get_field_content(iIndex, "vZ", szResult, MainPipeline); DynVehicleInfo[sqlid][gv_fZ] = floatstr(szResult);
				cache_get_field_content(iIndex, "vVW", szResult, MainPipeline); DynVehicleInfo[sqlid][gv_iVW] = strval(szResult);
				cache_get_field_content(iIndex, "vInt", szResult, MainPipeline); DynVehicleInfo[sqlid][gv_iInt] = strval(szResult);
				cache_get_field_content(iIndex, "vDisabled", szResult, MainPipeline); DynVehicleInfo[sqlid][gv_iDisabled] = strval(szResult);
				cache_get_field_content(iIndex, "vRotZ", szResult, MainPipeline); DynVehicleInfo[sqlid][gv_fRotZ] = floatstr(szResult);
				cache_get_field_content(iIndex, "vUpkeep", szResult, MainPipeline); DynVehicleInfo[sqlid][gv_iUpkeep] = strval(szResult);
				DynVehicleInfo[sqlid][gv_iSiren] = cache_get_field_content_int(iIndex, "vSiren", MainPipeline);
				i = 1;
				while(i <= MAX_DV_OBJECTS) {
					format(szResult, sizeof szResult, "vAttachedObjectModel%i", i);
					cache_get_field_content(iIndex, szResult, szResult, MainPipeline); DynVehicleInfo[sqlid][gv_iAttachedObjectModel][i-1] = strval(szResult);
					format(szResult, sizeof szResult, "vObjectX%i", i);
					cache_get_field_content(iIndex, szResult, szResult, MainPipeline); DynVehicleInfo[sqlid][gv_fObjectX][i-1] = floatstr(szResult);
					format(szResult, sizeof szResult, "vObjectY%i", i);
					cache_get_field_content(iIndex, szResult, szResult, MainPipeline); DynVehicleInfo[sqlid][gv_fObjectY][i-1] = floatstr(szResult);
					format(szResult, sizeof szResult, "vObjectZ%i", i);
					cache_get_field_content(iIndex, szResult, szResult, MainPipeline); DynVehicleInfo[sqlid][gv_fObjectZ][i-1] = floatstr(szResult);
					format(szResult, sizeof szResult, "vObjectRX%i", i);
					cache_get_field_content(iIndex, szResult, szResult, MainPipeline); DynVehicleInfo[sqlid][gv_fObjectRX][i-1] = floatstr(szResult);
					format(szResult, sizeof szResult, "vObjectRY%i", i);
					cache_get_field_content(iIndex, szResult, szResult, MainPipeline); DynVehicleInfo[sqlid][gv_fObjectRY][i-1] = floatstr(szResult);
					format(szResult, sizeof szResult, "vObjectRZ%i", i);
					cache_get_field_content(iIndex, szResult, szResult, MainPipeline); DynVehicleInfo[sqlid][gv_fObjectRZ][i-1] = floatstr(szResult);
					i++;
				}
				i = 0;
				while(i < MAX_DV_MODS) {
					format(szResult, sizeof szResult, "vMod%i", i);
					cache_get_field_content(iIndex, szResult, szResult, MainPipeline); DynVehicleInfo[sqlid][gv_iMod][i++] = strval(szResult);
				}
				
				if(400 < DynVehicleInfo[sqlid][gv_iModel] < 612) {
					if(!IsWeaponizedVehicle(DynVehicleInfo[sqlid][gv_iModel])) {
						DynVeh_Spawn(iIndex);
						//printf("[DynVeh] Loaded Dynamic Vehicle %i.", iIndex);
						for(i = 0; i != MAX_DV_OBJECTS; i++)
						{
							if(DynVehicleInfo[sqlid][gv_iAttachedObjectModel][i] == 0 || DynVehicleInfo[sqlid][gv_iAttachedObjectModel][i] == INVALID_OBJECT_ID) {
								DynVehicleInfo[sqlid][gv_iAttachedObjectID][i] = INVALID_OBJECT_ID;
								DynVehicleInfo[sqlid][gv_iAttachedObjectModel][i] = INVALID_OBJECT_ID;
							}
						}
					} else {
						DynVehicleInfo[sqlid][gv_iSpawnedID] = INVALID_VEHICLE_ID;
					}	
				}
				iIndex++;
			}
		}
	}
	return 1;
}

DynVeh_Save(iDvSlotID) {
	if((iDvSlotID > MAX_DYNAMIC_VEHICLES)) // Array bounds check. Use it.
		return 0;

	new
		szQuery[2248],
		i = 0;

	format(szQuery, sizeof szQuery,
		"UPDATE `groupvehs` SET `SpawnedID`= '%d',`gID`= '%d',`gDivID`= '%d', `rID`='%d', `vModel`= '%d', \
		`vPlate` = '%s',`vMaxHealth`= '%.2f',`vType`= '%d',`vLoadMax`= '%d',`vCol1`= '%d',`vCol2`= '%d', \
		`vX`= '%.2f',`vY`= '%.2f',`vZ`= '%.2f',`vRotZ`= '%.2f', `vUpkeep` = '%d', `vVW` = '%d', `vDisabled` = '%d', \
		`vInt` = '%d', `vFuel` = '%.5f', `vSiren` = '%d'"
		, DynVehicleInfo[iDvSlotID][gv_iSpawnedID], DynVehicleInfo[iDvSlotID][gv_igID], DynVehicleInfo[iDvSlotID][gv_igDivID], DynVehicleInfo[iDvSlotID][gv_irID], DynVehicleInfo[iDvSlotID][gv_iModel],
		g_mysql_ReturnEscaped(DynVehicleInfo[iDvSlotID][gv_iPlate], MainPipeline), DynVehicleInfo[iDvSlotID][gv_fMaxHealth], DynVehicleInfo[iDvSlotID][gv_iType], DynVehicleInfo[iDvSlotID][gv_iLoadMax], DynVehicleInfo[iDvSlotID][gv_iCol1], DynVehicleInfo[iDvSlotID][gv_iCol2],
		DynVehicleInfo[iDvSlotID][gv_fX], DynVehicleInfo[iDvSlotID][gv_fY], DynVehicleInfo[iDvSlotID][gv_fZ], DynVehicleInfo[iDvSlotID][gv_fRotZ], DynVehicleInfo[iDvSlotID][gv_iUpkeep], DynVehicleInfo[iDvSlotID][gv_iVW], DynVehicleInfo[iDvSlotID][gv_iDisabled],
		DynVehicleInfo[iDvSlotID][gv_iInt], DynVehicleInfo[iDvSlotID][gv_fFuel], DynVehicleInfo[iDvSlotID][gv_iSiren]);

	for(i = 0; i != MAX_DV_OBJECTS; ++i) {
		format(szQuery, sizeof szQuery, "%s, `vAttachedObjectModel%i` = '%d'", szQuery, i+1, DynVehicleInfo[iDvSlotID][gv_iAttachedObjectModel][i]);
		format(szQuery, sizeof szQuery, "%s, `vObjectX%i` = '%.2f'", szQuery, i+1, DynVehicleInfo[iDvSlotID][gv_fObjectX][i]);
		format(szQuery, sizeof szQuery, "%s, `vObjectY%i` = '%.2f'", szQuery, i+1, DynVehicleInfo[iDvSlotID][gv_fObjectY][i]);
		format(szQuery, sizeof szQuery, "%s, `vObjectZ%i` = '%.2f'", szQuery, i+1, DynVehicleInfo[iDvSlotID][gv_fObjectZ][i]);
		format(szQuery, sizeof szQuery, "%s, `vObjectRX%i` = '%.2f'", szQuery, i+1, DynVehicleInfo[iDvSlotID][gv_fObjectRX][i]);
		format(szQuery, sizeof szQuery, "%s, `vObjectRY%i` = '%.2f'", szQuery, i+1, DynVehicleInfo[iDvSlotID][gv_fObjectRY][i]);
		format(szQuery, sizeof szQuery, "%s, `vObjectRZ%i` = '%.2f'", szQuery, i+1, DynVehicleInfo[iDvSlotID][gv_fObjectRZ][i]);
	}

	for(i = 0; i != MAX_DV_MODS; ++i) format(szQuery, sizeof szQuery, "%s, `vMod%d` = %i", szQuery, i, DynVehicleInfo[iDvSlotID][gv_iMod][i]);

	format(szQuery, sizeof szQuery, "%s WHERE `id` = %i", szQuery, iDvSlotID);
	return mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "ii", SENDDATA_THREAD, INVALID_PLAYER_ID);
}

stock DynVeh_Spawn(iDvSlotID, free = 0)
{
	if(!(0 <= iDvSlotID < MAX_DYNAMIC_VEHICLES)) return 1;
	new string[128];
	format(string, sizeof(string), "Attempting to spawn DV Slot ID %d", iDvSlotID);
	Log("logs/dvspawn.log", string);
	new tmpdv = INVALID_VEHICLE_ID;
	if(DynVehicleInfo[iDvSlotID][gv_iSpawnedID] != INVALID_VEHICLE_ID)
	{
		tmpdv = DynVeh[DynVehicleInfo[iDvSlotID][gv_iSpawnedID]];
		DynVeh[DynVehicleInfo[iDvSlotID][gv_iSpawnedID]] = -1;
	}
	if(DynVehicleInfo[iDvSlotID][gv_iSpawnedID] != INVALID_VEHICLE_ID) {
		if(tmpdv == iDvSlotID) {
			format(string, sizeof(string), "Destroying Vehicle ID %d for DV Slot %d",DynVehicleInfo[iDvSlotID][gv_iSpawnedID], iDvSlotID);
			Log("logs/dvspawn.log", string);
			DestroyVehicle(DynVehicleInfo[iDvSlotID][gv_iSpawnedID]);
			DynVehicleInfo[iDvSlotID][gv_iSpawnedID] = INVALID_VEHICLE_ID;
			for(new i = 0; i != MAX_DV_OBJECTS; i++)
			{
				if(DynVehicleInfo[iDvSlotID][gv_iAttachedObjectID][i] != INVALID_OBJECT_ID) {
					DestroyDynamicObject(DynVehicleInfo[iDvSlotID][gv_iAttachedObjectID][i]);
					DynVehicleInfo[iDvSlotID][gv_iAttachedObjectID][i] = INVALID_OBJECT_ID;
				}
			}
		}
	}
	if(!(400 < DynVehicleInfo[iDvSlotID][gv_iModel] < 612)) {
		format(string, sizeof(string), "Invalid Vehicle Model ID for DV Slot %d", iDvSlotID);
		Log("logs/dvspawn.log", string);
		return 1;
	}
	if(DynVehicleInfo[iDvSlotID][gv_iDisabled]) return 1;
	if(free == 0)
	{
		if(DynVehicleInfo[iDvSlotID][gv_igID] != INVALID_GROUP_ID && tmpdv != -1) {
			new iGroupID = DynVehicleInfo[iDvSlotID][gv_igID];
			if(arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_LEA || arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_MEDIC || arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_JUDICIAL || arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_TAXI)
			{
				if(arrGroupData[iGroupID][g_iBudget] >= floatround(DynVehicleInfo[iDvSlotID][gv_iUpkeep] / 2))
				{
					arrGroupData[iGroupID][g_iBudget] -= floatround(DynVehicleInfo[iDvSlotID][gv_iUpkeep] / 2);
					new str[128], file[32];
					format(str, sizeof(str), "Vehicle Slot ID %d RTB fee cost $%d to %s's budget fund.", iDvSlotID, floatround(DynVehicleInfo[iDvSlotID][gv_iUpkeep] / 2), arrGroupData[iGroupID][g_szGroupName]);
					new month, day, year;
					getdate(year,month,day);
					format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", iGroupID, month, day, year);
					Log(file, str);
				}
				else
				{
					DynVehicleInfo[iDvSlotID][gv_iDisabled] = 1;
					return 1;
				}
			}
		}
	}
	DynVehicleInfo[iDvSlotID][gv_iSpawnedID] = CreateVehicle(DynVehicleInfo[iDvSlotID][gv_iModel], DynVehicleInfo[iDvSlotID][gv_fX], DynVehicleInfo[iDvSlotID][gv_fY], DynVehicleInfo[iDvSlotID][gv_fZ], DynVehicleInfo[iDvSlotID][gv_fRotZ], DynVehicleInfo[iDvSlotID][gv_iCol1], DynVehicleInfo[iDvSlotID][gv_iCol2], VEHICLE_RESPAWN, DynVehicleInfo[iDvSlotID][gv_iSiren]);
	DynVeh_Save(iDvSlotID);
	format(string, sizeof(string), "Vehicle ID %d spawned for DV Slot %d",DynVehicleInfo[iDvSlotID][gv_iSpawnedID], iDvSlotID);
	Log("logs/dvspawn.log", string);
	SetVehicleHealth(DynVehicleInfo[iDvSlotID][gv_iSpawnedID], DynVehicleInfo[iDvSlotID][gv_fMaxHealth]);
	SetVehicleVirtualWorld(DynVehicleInfo[iDvSlotID][gv_iSpawnedID], DynVehicleInfo[iDvSlotID][gv_iVW]);
	LinkVehicleToInterior(DynVehicleInfo[iDvSlotID][gv_iSpawnedID], DynVehicleInfo[iDvSlotID][gv_iInt]);
	VehicleFuel[DynVehicleInfo[iDvSlotID][gv_iSpawnedID]] = DynVehicleInfo[iDvSlotID][gv_fFuel];
	DynVeh[DynVehicleInfo[iDvSlotID][gv_iSpawnedID]] = iDvSlotID;
	for(new i = 0; i != MAX_DV_OBJECTS; i++)
	{
		if(DynVehicleInfo[iDvSlotID][gv_iAttachedObjectModel][i] != INVALID_OBJECT_ID && DynVehicleInfo[iDvSlotID][gv_iAttachedObjectModel][i] != 0)
		{
			DynVehicleInfo[iDvSlotID][gv_iAttachedObjectID][i] = CreateDynamicObject(DynVehicleInfo[iDvSlotID][gv_iAttachedObjectModel][i],0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
			AttachDynamicObjectToVehicle(DynVehicleInfo[iDvSlotID][gv_iAttachedObjectID][i], DynVehicleInfo[iDvSlotID][gv_iSpawnedID], DynVehicleInfo[iDvSlotID][gv_fObjectX][i], DynVehicleInfo[iDvSlotID][gv_fObjectY][i], DynVehicleInfo[iDvSlotID][gv_fObjectZ][i], DynVehicleInfo[iDvSlotID][gv_fObjectRX][i], DynVehicleInfo[iDvSlotID][gv_fObjectRY][i], DynVehicleInfo[iDvSlotID][gv_fObjectRZ][i]);
		}
	}
	if(!isnull(DynVehicleInfo[iDvSlotID][gv_iPlate])) {
		SetVehicleNumberPlate(DynVehicleInfo[iDvSlotID][gv_iSpawnedID], DynVehicleInfo[iDvSlotID][gv_iPlate]);
	}
	Vehicle_ResetData(DynVehicleInfo[iDvSlotID][gv_iSpawnedID]);
	LoadGroupVehicleMods(DynVehicleInfo[iDvSlotID][gv_iSpawnedID]);
    return 1;
}

forward DynVeh_CreateDVQuery(playerid, model, col1, col2);
public DynVeh_CreateDVQuery(playerid, model, col1, col2)
{
	new
			iFields,
			iRows,
			sqlid,
			szResult[128];

	cache_get_data(iRows, iFields, MainPipeline);
	cache_get_field_content(0, "id", szResult, MainPipeline); sqlid = strval(szResult);
	DynVehicleInfo[sqlid][gv_iModel] = model;
	DynVehicleInfo[sqlid][gv_iCol1] = col1;
	DynVehicleInfo[sqlid][gv_iCol2] = col2;
	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(playerid, X, Y, Z);
	DynVehicleInfo[sqlid][gv_iVW] = GetPlayerVirtualWorld(playerid);
	DynVehicleInfo[sqlid][gv_iInt] = GetPlayerInterior(playerid);
	DynVehicleInfo[sqlid][gv_fX] = X+2;
	DynVehicleInfo[sqlid][gv_fY] = Y;
	DynVehicleInfo[sqlid][gv_fZ] = Z;
	DynVehicleInfo[sqlid][gv_igID] = INVALID_GROUP_ID;
	format(szResult, sizeof(szResult), "%s's DV Creation query has returned - attempting to spawn vehicle - SQL ID %d", GetPlayerNameEx(playerid), sqlid);
	Log("logs/dv.log", szResult);
	DynVeh_Save(sqlid);
	DynVeh_Spawn(sqlid);
	return 1;
}

stock UpdateGroupVehicleMods(groupvehicleid)
{
	if(GetVehicleModel(DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][gv_iSpawnedID])) {
		new carid = DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][gv_iSpawnedID];
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
		if(spoilers >= 1000)    DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][0] = spoilers;
		if(hood >= 1000)        DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][1] = hood;
		if(roof >= 1000)        DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][2] = roof;
		if(sideskirt1 >= 1000)  DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][3] = sideskirt1;
		if(lamps >= 1000)       DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][4] = lamps;
		if(nitro >= 1000)       DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][5] = nitro;
		if(exhaust >= 1000)     DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][6] = exhaust;
		if(wheels >= 1000)      DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][7] = wheels;
		if(stereo >= 1000)      DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][8] = stereo;
		if(hydraulics >= 1000)  DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][9] = hydraulics;
		if(frontbumper >= 1000) DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][10] = frontbumper;
		if(rearbumper >= 1000)  DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][11] = rearbumper;
		if(ventright >= 1000)   DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][12] = ventright;
		if(ventleft >= 1000)    DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][13] = ventleft;
		if(sideskirt2 >= 1000)  DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][14] = sideskirt2;

		DynVeh_Save(DynVeh[groupvehicleid]);
	}
}

stock LoadGroupVehicleMods(groupvehicleid)
{
	if(GetVehicleModel(DynVehicleInfo[DynVeh[groupvehicleid]][gv_iSpawnedID])) {

        /*if(strlen(PlayerVehicleInfo[playerid][groupvehicleid][pvPlate]) > 0)
		{
		    SetVehicleNumberPlate(PlayerVehicleInfo[playerid][groupvehicleid][pvId], PlayerVehicleInfo[playerid][groupvehicleid][pvPlate]);
		    SetVehiclePos(PlayerVehicleInfo[playerid][groupvehicleid][pvId], 9999.9, 9999.9, 9999.9);
		    SetVehiclePos(PlayerVehicleInfo[playerid][groupvehicleid][pvId], PlayerVehicleInfo[playerid][groupvehicleid][pvPosX], PlayerVehicleInfo[playerid][groupvehicleid][pvPosY], PlayerVehicleInfo[playerid][groupvehicleid][pvPosZ]);
		}*/

		/*if(PlayerVehicleInfo[playerid][groupvehicleid][pvPaintJob] != -1)
		{
			 ChangeVehiclePaintjob(PlayerVehicleInfo[playerid][groupvehicleid][pvId], PlayerVehicleInfo[playerid][groupvehicleid][pvPaintJob]);
			 ChangeVehicleColor(PlayerVehicleInfo[playerid][groupvehicleid][pvId], PlayerVehicleInfo[playerid][groupvehicleid][pvColor1], PlayerVehicleInfo[playerid][groupvehicleid][pvColor2]);
		}*/
		for(new m = 0; m < MAX_MODS; m++)
		{
		    if (DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][m] >= 1000  && DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][m] <= 1193)
		    {
				if (InvalidModCheck(GetVehicleModel(DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][gv_iSpawnedID]),DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][m]))
				{
					AddVehicleComponent(DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][gv_iSpawnedID], DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][m]);
				}
				else
				{
				    DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][m] = 0;
				}
			}
		}
	}
}