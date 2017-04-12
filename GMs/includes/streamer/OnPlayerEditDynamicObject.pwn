/* 	The streamer is using a new version of sampGDK which conflicts with YSI's hooks library.
	Therefore, all of it is routed to a regular callback until a resolution is found.
*/

forward OnPlayerEditGate(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz);
public OnPlayerEditGate(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz) // Gate Editor Fix by Winterfield. DO NOT REMOVE.
{
    //printf("%i | %d | %d | %f | %f | %f | %f | %f | %f", playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz); // debug
    CallLocalFunction("OnPlayerEditDynamicObject", "iddffffff", playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz);
}

public OnPlayerEditObject(playerid, playerobject, objectid, response, Float:fX, Float:fY, Float:fZ, Float:fRotX, Float:fRotY, Float:fRotZ) {
	return 0;
}

forward OnPlayerEditDObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz);
public OnPlayerEditDObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz) // Object Editor Fix.
{
    //printf("%i | %d | %d | %f | %f | %f | %f | %f | %f", playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz); // debug
    CallLocalFunction("OnPlayerEditDynamicObject", "iddffffff", playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz);
}

public OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz) {
	
	// Under OnPlayerEditObject

	/*
	if(GetPVarInt(playerid, "_EditingSafeObjectID") == objectid)
	{
	    new iSafeID = GetPVarInt(playerid, "_EditingSafeID"),
				str[128];

	    if(response == EDIT_RESPONSE_FINAL) {
	        SafeData[iSafeID][g_fPos][0] = x;
			SafeData[iSafeID][g_fPos][1] = y;
			SafeData[iSafeID][g_fPos][2] = z;
			SafeData[iSafeID][g_fPos][3] = rx;
			SafeData[iSafeID][g_fPos][4] = ry;
			SafeData[iSafeID][g_fPos][5] = rz;
			processSafe(iSafeID);
			saveSafe(iSafeID);

			format(str, sizeof str, "You have edited the position of Safe ID %i.", iSafeID);
			SendClientMessageEx(playerid, COLOR_LIGHTRED, str);
	        DeletePVar(playerid, "_EditingSafeObjectID");
	    }
	    else if(response == EDIT_RESPONSE_CANCEL) {

	        format(str, sizeof str, "You have quit editing Safe ID %i.", iSafeID);
			SendClientMessageEx(playerid, COLOR_LIGHTRED, str);
	        DeletePVar(playerid, "_EditingSafeID");
	    }
	}
	*/

	if(GetPVarType(playerid, "DeployingTapeID"))
	{
	    new tid = GetPVarInt(playerid, "DeployingTapeID"), valid = 0;
	    if(response == EDIT_RESPONSE_FINAL || response == EDIT_RESPONSE_CANCEL)
	    {
	    	DeletePVar(playerid, "DeployingTapeID");
	        new Float:offsetX, Float:offsetY, Float:offsetZ;
	        
			offsetX = x - Tapes[tid][sX];
			offsetY = y - Tapes[tid][sY];
			offsetZ = z - Tapes[tid][sZ];
			
			if(offsetX <= 10.0 && offsetX >= -10.0)
			{
                if(offsetY <= 10.0 && offsetY >= -10.0)
				{
                    if(offsetZ <= 10.0 && offsetZ >= -10.0)
					{
                        Tapes[tid][sX] = x;
						Tapes[tid][sY] = y;
						Tapes[tid][sZ] = z;

						if(IsValidDynamicObject(Tapes[tid][sObjectID])) DestroyDynamicObject(Tapes[tid][sObjectID]);
						Tapes[tid][sObjectID] = CreateDynamicObject(19834, x, y, z, rx, ry, rz, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
						
						/*
						SetDynamicObjectPos(Tapes[tid][sObjectID], x, y, z);
						SetDynamicObjectPos(Tapes[tid][sObjectID], rx, ry, rz);
						*/

						format(szMiscArray, sizeof(szMiscArray), "Tape ID: %d's position has been edited successfully.", tid);
						SendClientMessage(playerid, COLOR_WHITE, szMiscArray);
						valid = 1;
					}
					else SendClientMessageEx(playerid, COLOR_GRAD2, "Maximum Z Offset exceeded. Please try again.");
				}
				else SendClientMessageEx(playerid, COLOR_GRAD2, "Maximum Y Offset exceeded. Please try again.");
			}
			else SendClientMessageEx(playerid, COLOR_GRAD2, "Maximum X Offset exceeded. Please try again.");

			
			if(!valid)
			{
			    DestroyDynamicObject(Tapes[tid][sObjectID]);
				Tapes[tid][sX] = 0;
				Tapes[tid][sY] = 0;
				Tapes[tid][sZ] = 0;
				Tapes[tid][sObjectID] = INVALID_OBJECT_ID;
				Tapes[tid][sDeployedBy] = INVALID_PLAYER_ID;
				Tapes[tid][sDeployedByStatus] = 0;
			}
	    }
	}
	if(GetPVarType(playerid, PVAR_FURNITURE_EDITING)) {

		switch(response) {

			case EDIT_RESPONSE_CANCEL: {

				new iModelID = Streamer_GetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_MODEL_ID);

				GetDynamicObjectPos(objectid, x, y, z);
				GetDynamicObjectRot(objectid, rx, ry, rz);
				SetDynamicObjectPos(objectid, x, y, z);
				SetDynamicObjectRot(objectid, rx, ry, rz);

				DeletePVar(playerid, "PX");
				DeletePVar(playerid, "PY");
				DeletePVar(playerid, "PZ");
				DeletePVar(playerid, "furnfirst");


				format(szMiscArray, sizeof(szMiscArray), "[Furniture]: You have cancelled placing the %s.", GetFurnitureName(iModelID));
				SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
				DeletePVar(playerid, PVAR_FURNITURE_EDITING);
				DeletePVar(playerid, PVAR_FURNITURE_SLOT);
				PlayerTextDrawSetPreviewModel(playerid, Furniture_PTD[playerid][0], PlayerInfo[playerid][pModel]);
				PlayerTextDrawSetPreviewRot(playerid, Furniture_PTD[playerid][0], 345.000000, 0.000000, 320.000000, 1.000000);
				PlayerTextDrawHide(playerid, Furniture_PTD[playerid][0]);
				PlayerTextDrawShow(playerid, Furniture_PTD[playerid][0]);
				SelectTextDraw(playerid, 0xF6FBFCFF);
			}
			case EDIT_RESPONSE_FINAL: {

				new iModelID = GetDynamicObjectModel(objectid),
					iSlotID = GetPVarInt(playerid, PVAR_FURNITURE_SLOT),
					iHouseID = GetHouseID(playerid);

				#define MAX_OBJECT_TEXTSLOTS 5
				new iTmpModel[MAX_OBJECT_TEXTSLOTS],
					szTXDName[MAX_OBJECT_TEXTSLOTS][32],
					szTextureName[MAX_OBJECT_TEXTSLOTS][32],
					iColor;

				for(new iIndex; iIndex < MAX_OBJECT_TEXTSLOTS; ++iIndex) {

					GetDynamicObjectMaterial(HouseInfo[iHouseID][hFurniture][iSlotID], iIndex, iTmpModel[iIndex], szTXDName[iIndex], szTextureName[iIndex], iColor, 32, 32);
					if(isnull(szTXDName[iIndex])) break;
				}

				if(IsValidFurniture(iHouseID, iSlotID, 1)) DestroyDynamicObject(HouseInfo[iHouseID][hFurniture][iSlotID]);
				HouseInfo[iHouseID][hFurniture][iSlotID] = CreateDynamicObject(iModelID, x, y, z, rx, ry, rz, HouseInfo[iHouseID][hIntVW]);

				for(new iIndex; iIndex < MAX_OBJECT_TEXTSLOTS; ++iIndex) {

					SetDynamicObjectMaterial(HouseInfo[iHouseID][hFurniture][iSlotID], iIndex, iTmpModel[iIndex], szTXDName[iIndex], szTextureName[iIndex], 0);
					if(isnull(szTXDName[iIndex])) break;
				}

				if(IsADoor(iModelID)) {

					new iLocalDoorArea = Streamer_GetIntData(STREAMER_TYPE_OBJECT, HouseInfo[iHouseID][hFurniture][iSlotID], E_STREAMER_EXTRA_ID),
						szData[3];

					if(IsValidDynamicArea(iLocalDoorArea)) DestroyDynamicArea(iLocalDoorArea);

					iLocalDoorArea = CreateDynamicSphere(x, y, z, 1.0, HouseInfo[iHouseID][hIntVW]);
					szData[0] = iHouseID;
					szData[1] = HouseInfo[iHouseID][hFurniture][iSlotID];
					szData[2] = 0;
					Streamer_SetArrayData(STREAMER_TYPE_AREA, iLocalDoorArea, E_STREAMER_EXTRA_ID, szData, sizeof(szData)); // Assign Object ID to Area.
				}
				Streamer_SetIntData(STREAMER_TYPE_OBJECT, HouseInfo[iHouseID][hFurniture][iSlotID], E_STREAMER_EXTRA_ID, iHouseID);

				mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "UPDATE `furniture` SET `x` = '%f', `y` = '%f', `z` = '%f', `rx` = '%f', `ry` = '%f', `rz` = '%f' \
					WHERE `houseid` = '%d' AND `slotid` = '%d'", x, y, z, rx, ry, rz, iHouseID, iSlotID);
				mysql_tquery(MainPipeline, szMiscArray, "OnEditFurniture", "");

				foreach(new i : Player) Streamer_Update(i);

				PlayerTextDrawSetPreviewModel(playerid, Furniture_PTD[playerid][0], PlayerInfo[playerid][pModel]);
				PlayerTextDrawSetPreviewRot(playerid, Furniture_PTD[playerid][0], 345.000000, 0.000000, 320.000000, 1.000000);
				PlayerTextDrawHide(playerid, Furniture_PTD[playerid][0]);
				PlayerTextDrawShow(playerid, Furniture_PTD[playerid][0]);
				
				format(szMiscArray, sizeof(szMiscArray), "[Furniture]: You have successfully placed the %s.", GetFurnitureName(iModelID));
				SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);

				DeletePVar(playerid, "furnfirst");
				DeletePVar(playerid, "PX");
				DeletePVar(playerid, "PY");
				DeletePVar(playerid, "PZ");
				DeletePVar(playerid, PVAR_FURNITURE_EDITING);
				DeletePVar(playerid, PVAR_FURNITURE_SLOT);
				// printf("%d, %d, %d, %f, %f, %f, %f, %f, %f", playerid, objectid, response, x, y, z, rx, ry, rz);
				// SelectTextDraw(playerid, 0xF6FBFCFF);
			}
		}
	}
	
	// Gates
	if(response == EDIT_RESPONSE_FINAL)
	{
		szMiscArray[0] = 0;
		if(GetPVarInt(playerid, "gEdit") == 1)
		{
			if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1 && PlayerInfo[playerid][pShopTech] < 1) return SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to perform this action!");
			new gateid = GetPVarInt(playerid, "EditingGateID");
			GateInfo[gateid][gPosX] = x;
			GateInfo[gateid][gPosY] = y;
			GateInfo[gateid][gPosZ] = z;
			GateInfo[gateid][gRotX] = rx;
			GateInfo[gateid][gRotY] = ry;
			GateInfo[gateid][gRotZ] = rz;
			CreateGate(gateid);
			SaveGate(gateid);
			format(szMiscArray, sizeof(szMiscArray), "You have finished editing the open position of Gate ID: %d", gateid);
			SendClientMessage(playerid, COLOR_WHITE, szMiscArray);
			DeletePVar(playerid, "gEdit");
			DeletePVar(playerid, "EditingGateID");
		}
		if(GetPVarInt(playerid, "gEdit") == 2)
		{
			if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1 && PlayerInfo[playerid][pShopTech] < 1) return SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to perform this action!");
			new gateid = GetPVarInt(playerid, "EditingGateID");
			GateInfo[gateid][gPosXM] = x;
			GateInfo[gateid][gPosYM] = y;
			GateInfo[gateid][gPosZM] = z;
			GateInfo[gateid][gRotXM] = rx;
			GateInfo[gateid][gRotYM] = ry;
			GateInfo[gateid][gRotZM] = rz;
			CreateGate(gateid);
			SaveGate(gateid);
			format(szMiscArray, sizeof(szMiscArray), "You have finished editing the closed position of Gate ID: %d", gateid);
			SendClientMessage(playerid, COLOR_WHITE, szMiscArray);
			DeletePVar(playerid, "gEdit");
			DeletePVar(playerid, "EditingGateID");
		}
	}
	if(response == EDIT_RESPONSE_CANCEL)
	{
		if(GetPVarType(playerid, "gEdit") == 1)
		{
			CreateGate(GetPVarInt(playerid, "EditingGateID"));
			DeletePVar(playerid, "gEdit");
			DeletePVar(playerid, "EditingGateID");
			SendClientMessage(playerid, COLOR_WHITE, "You have stopped yourself from editing the gate.");
		}
	}
	if(GetPVarType(playerid, PVAR_EMETDET))
	{
		new id = GetPVarInt(playerid, PVAR_EMETDET),
			iAssignData[2],
			Float:fPos[6];
		
		GetDynamicObjectPos(arrMetalDetector[id][metdet_iObjectID], fPos[0], fPos[1], fPos[2]);
		GetDynamicObjectRot(arrMetalDetector[id][metdet_iObjectID], fPos[3], fPos[4], fPos[5]);
		
		iAssignData[0] = Streamer_GetIntData(STREAMER_TYPE_OBJECT, arrMetalDetector[id][metdet_iObjectID], E_STREAMER_WORLD_ID);
		iAssignData[1] = Streamer_GetIntData(STREAMER_TYPE_OBJECT, arrMetalDetector[id][metdet_iObjectID], E_STREAMER_INTERIOR_ID);
		switch(response)
		{
			case EDIT_RESPONSE_FINAL:
			{
				SendClientMessageEx(playerid, COLOR_YELLOW, "You successfully edited the metal detector's position.");
				MetDet_Process(id, x, y, z, rx, ry, rz, iAssignData[0], iAssignData[1]);
				MetDet_SaveMetDet(id);
			}
			case EDIT_RESPONSE_CANCEL:
			{
				SetDynamicObjectPos(arrMetalDetector[id][metdet_iObjectID], fPos[0], fPos[1], fPos[2]);
				SetDynamicObjectRot(arrMetalDetector[id][metdet_iObjectID], fPos[3], fPos[4], fPos[5]);
				SendClientMessageEx(playerid, COLOR_GRAD1, "You have cancelled setting the metal detector's position.");
			}
		}
		DeletePVar(playerid, PVAR_EMETDET);
	}
	// Parking Meters
	if(EditingMeterID[playerid] != 0)
	{
		new string[128];
		switch(response)
		{
			case EDIT_RESPONSE_FINAL:
			{
				if(GetPlayerInterior(playerid) != 0 || GetPlayerVirtualWorld(playerid) != 0)
				{
					SendClientMessageEx(playerid, COLOR_GREY, "You cannot use this feature inside an interior or virtual world.");
					RebuildParkingMeter(EditingMeterID[playerid]);
					EditingMeterID[playerid] = 0;
					return 1;
				}
				ParkingMeterInformation[EditingMeterID[playerid]][MeterPosition][0] = x;
				ParkingMeterInformation[EditingMeterID[playerid]][MeterPosition][1] = y;
				ParkingMeterInformation[EditingMeterID[playerid]][MeterPosition][2] = z;
				ParkingMeterInformation[EditingMeterID[playerid]][MeterPosition][3] = rx;
				ParkingMeterInformation[EditingMeterID[playerid]][MeterPosition][4] = ry;
				ParkingMeterInformation[EditingMeterID[playerid]][MeterPosition][5] = rz;
				SaveParkingMeter(EditingMeterID[playerid]);
				RebuildParkingMeter(EditingMeterID[playerid]);
				format(string, sizeof(string), "You have updated the position of parking meter ID %d.", EditingMeterID[playerid]);
				SendClientMessageEx(playerid, COLOR_YELLOW, string);
				format(string, sizeof(string), "%s updated the position of parking meter ID %d to %0.3f, %0.3f, %0.3f, %0.3f, %0.3f, %0.3f.", GetPlayerNameEx(playerid), EditingMeterID[playerid], x, y, z, rx, ry, rz);
				Log("logs/admin.log", string);
				EditingMeterID[playerid] = 0;
				return 1;
			}
			case EDIT_RESPONSE_CANCEL:
			{
				format(string, sizeof(string), "You have cancelled editing the position of parking meter ID %d.", EditingMeterID[playerid]);
				SendClientMessageEx(playerid, COLOR_YELLOW, string);
				RebuildParkingMeter(EditingMeterID[playerid]);
				EditingMeterID[playerid] = 0;
				return 1;
			}
		}
		return 1;
	}
	new Float:fPos[6];
	GetDynamicObjectPos(objectid, fPos[0], fPos[1], fPos[2]);
	GetDynamicObjectRot(objectid, fPos[3], fPos[4], fPos[5]);
	if(GetPVarType(playerid, PVAR_GANGTAGEDITING))
	{
		switch(response)
		{
			case EDIT_RESPONSE_CANCEL:
			{
				SetDynamicObjectPos(objectid, fPos[0], fPos[1], fPos[2]);
				SetDynamicObjectRot(objectid, fPos[3], fPos[4], fPos[5]);
				DeletePVar(playerid, PVAR_GANGTAGEDITING);
				SendClientMessage(playerid, COLOR_GRAD1, "You cancelled editing the gang tag.");
				return 1;
			}
			case EDIT_RESPONSE_FINAL:
			{
				new i = GetPVarInt(playerid, PVAR_GANGTAGEDITING);
				if(IsValidDynamicObject(arrGangTags[i][gt_iObjectID])) DestroyDynamicObject(arrGangTags[i][gt_iObjectID]);
				arrGangTags[i][gt_iObjectID] = CreateDynamicObject(GANGTAGS_OBJECTID, x, y, z, rx, ry, rz);
				GangTag_AdmSave(playerid, i);
				return 1;
			}
		}
	}
	if(GetPVarType(playerid, "editingsign")) {
		if(response == EDIT_RESPONSE_FINAL)
		{
			new string[128];
			/*if(GetPVarInt(playerid, "Edit") == 2)
			{
				if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pGangModerator] < 1) return SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to perform this action!");
				new gangtag = GetPVarInt(playerid, "gt_ID");
				GangTags[gangtag][gt_PosX] = x;
				GangTags[gangtag][gt_PosY] = y;
				GangTags[gangtag][gt_PosZ] = z;
				GangTags[gangtag][gt_PosRX] = rx;
				GangTags[gangtag][gt_PosRY] = ry;
				GangTags[gangtag][gt_PosRZ] = rz;
				CreateGangTag(gangtag);
				format(string, sizeof(string), "You have edited the position of gang tag %d!", gangtag);
				SendClientMessageEx(playerid, COLOR_WHITE, string);
				format(string, sizeof(string), "%s has edited the position of gang tag %d.", GetPlayerNameEx(playerid), gangtag);
				Log("Logs/GangTags.log", string);
				DeletePVar(playerid, "gt_ID");
				DeletePVar(playerid, "gt_Edit");
				SaveGangTag(gangtag);
			}*/
			
			new h = GetPVarInt(playerid, "house");
			if(GetPointDistanceToPoint(HouseInfo[h][hExteriorX], HouseInfo[h][hExteriorY], HouseInfo[h][hExteriorZ], x, y, z) > 10)
				return SendClientMessageEx(playerid, COLOR_GREY, "Keep the sign within the checkpoint radius!"), EditDynamicObject(playerid, GetPVarInt(playerid, "signID"));
			HouseInfo[h][hSign][0] = x;
			HouseInfo[h][hSign][1] = y;
			HouseInfo[h][hSign][2] = z;
			HouseInfo[h][hSign][3] = rz;
			if(GetPVarInt(playerid, "editingsign") == 1)
			{
				HouseInfo[h][hSignExpire] = gettime()+86400;
				PlayerInfo[playerid][mInventory][6] = 0;
				if(IsValidDynamicObject(GetPVarInt(playerid, "signID"))) DestroyDynamicObject(GetPVarInt(playerid, "signID"));
				SendClientMessageEx(playerid, COLOR_GREY, "You have finished placing your house sale sign!");
				format(string, sizeof(string), "[PLACESIGN] %s has placed down their house sale sign at House ID: %d", GetPlayerNameEx(playerid), h);
			}
			if(GetPVarInt(playerid, "editingsign") == 2)
			{
				SendClientMessageEx(playerid, COLOR_GREY, "You have finished editing the position of your house sale sign!");
				format(string, sizeof(string), "[EDITSIGN] %s has edited the position of their house sale sign at House ID: %d", GetPlayerNameEx(playerid), h);
			}
			if(GetPVarInt(playerid, "editingsign") == 3)
			{
				SendClientMessageEx(playerid, COLOR_GREY, "You have finished editing the house sale sign!");
				format(string, sizeof(string), "[AEDITSIGN] %s has adjusted the position of the house sale sign placed at House ID: %d", GetPlayerNameEx(playerid), h);
			}
			Log("logs/house.log", string);
			CreateHouseSaleSign(h);
			SaveHouse(h);
			DeletePVar(playerid, "signID");
			DeletePVar(playerid, "house");
			DeletePVar(playerid, "editingsign");
			ClearCheckpoint(playerid);
		}
		if(response == EDIT_RESPONSE_CANCEL)
		{
			/*if(GetPVarInt(playerid, "gt_Edit") == 2)
			{
				new gangid = GetPVarInt(playerid, "gt_ID");
				SetDynamicObjectPos(GangTags[gangid][gt_Object], GangTags[gangid][gt_PosX], GangTags[gangid][gt_PosY], GangTags[gangid][gt_PosZ]);
				SetDynamicObjectRot(GangTags[gangid][gt_Object], GangTags[gangid][gt_PosRX], GangTags[gangid][gt_PosRY], GangTags[gangid][gt_PosRZ]);
				DeletePVar(playerid, "gt_Edit");
				DeletePVar(playerid, "gt_ID");
				SendClientMessageEx(playerid, COLOR_GREY, "You have stopped editing this gang tag!");
			}*/
	
			if(GetPVarInt(playerid, "editingsign") == 1 && IsValidDynamicObject(GetPVarInt(playerid, "signID"))) DestroyDynamicObject(GetPVarInt(playerid, "signID"));
			SendClientMessageEx(playerid, COLOR_GREY, "You have stopped yourself from placing down your House Sale Sign!");
			DeletePVar(playerid, "signID");
			DeletePVar(playerid, "house");
			DeletePVar(playerid, "editingsign");
			ClearCheckpoint(playerid);
		}
	}



	return 1;
}