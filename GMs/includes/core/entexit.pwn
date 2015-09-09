#include <YSI\y_hooks>

/* 	Jingles:

	DDoor / Houses / Businesses pickup model rework.
	Enter/exit by pressing F/Enter or using /enter or /exit.

	Put:
	CreateDynamicDoor_int(doorid); under stock CreateDynamicDoor(doorid);
	CreateHouse_int(houseid) under stock CreateHouse(houseid);
	CreateBusiness_int(businessid) under stock CreateBusiness(businessid);

	And it'll hopefully work like a charm! :)
*/

#define 		ENTRANCE_SHORTCUT		KEY_NO


new g_iEntranceID[MAX_PLAYERS],
	g_iEntranceAID[MAX_PLAYERS];

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {

	if(newkeys & ENTRANCE_SHORTCUT) Process_Entrance(playerid);
	return 1;
}

CMD:enter(playerid)
{
	// SendClientMessage(playerid, COLOR_RED, "/enter is deprecated. Use ~k~~CONVERSATION_NO~ instead.");
	Process_Entrance(playerid);
	return 1;
}

CMD:exit(playerid)
{
	// SendClientMessage(playerid, COLOR_RED, "/exit is deprecated. Use ~k~~CONVERSATION_NO~ instead.");
	Process_Entrance(playerid);
	return 1;
}

Process_Entrance(playerid) {
	if(IsPlayerInAnyDynamicArea(playerid))
	{
		new areaid[1];
		GetPlayerDynamicAreas(playerid, areaid); //Assign nearest areaid
		new i = GetIDFromArea(areaid[0]);

		//printf("DEBUG: Area %d was detected as a door area: ID: %d, VW: %d, Int: %d.", areaid[0], i, Streamer_GetIntData(STREAMER_TYPE_AREA, areaid[0], E_STREAMER_WORLD_ID), Streamer_GetIntData(STREAMER_TYPE_AREA, areaid[0], E_STREAMER_INTERIOR_ID));
		g_iEntranceAID[playerid] = areaid[0];
		g_iEntranceID[playerid] = i;

		if(i < sizeof(iVehExits)) {
			if(iVehExits[i] == areaid[0]) {
				SetPVarInt(playerid, "VEHA_ID", i);
			}
		}
		if(i < MAX_VEHICLES) {
			if(iVehEnterAreaID[i] == areaid[0]) {
				//printf("DEBUG: Area %d was detected as a vehicle area.", areaid[0]);
				SetPVarInt(playerid, "VEHA_ID", i);
			}
		}
	}
	if(g_iEntranceID[playerid] > -1 && GetPlayerState(playerid) != PLAYER_STATE_ENTER_VEHICLE_DRIVER) {
		
		Enter_Door(playerid, g_iEntranceID[playerid], g_iEntranceAID[playerid]);
	}
	if(!IsPlayerInAnyVehicle(playerid)) {

		if(GetPVarType(playerid, "VEHA_ID")) {

			Vehicle_Enter(playerid, GetPVarInt(playerid, "VEHA_ID"));
			return 1;
		}
		if(InsidePlane[playerid] != INVALID_VEHICLE_ID) {

			if(GetPVarType(playerid, "VEHA_ID")) {

				Vehicle_Exit(playerid);
				return 1;
			}
		}
	}
	return 1;
}


/* public OnPlayerEnterDynamicArea(playerid, areaid) {

	// printf("DEBUG: %d entered area %d", playerid, areaid);
	new i = GetIDFromArea(areaid);

	// printf("DEBUG: Area %d was detected as a door area: ID: %d, VW: %d, Int: %d.", areaid, i, Streamer_GetIntData(STREAMER_TYPE_AREA, areaid, E_STREAMER_WORLD_ID), Streamer_GetIntData(STREAMER_TYPE_AREA, areaid, E_STREAMER_INTERIOR_ID));
	g_iEntranceAID[playerid] = areaid;
	g_iEntranceID[playerid] = i;

	if(i < sizeof(iVehExits)) {
		if(iVehExits[i] == areaid) {
			SetPVarInt(playerid, "VEHA_ID", i);
		}
	}
	if(i < MAX_VEHICLES) {
		if(iVehEnterAreaID[i] == areaid) {
			// printf("DEBUG: Area %d was detected as a vehicle area.", areaid);
			SetPVarInt(playerid, "VEHA_ID", i);
		}
	}
	return 1;
} */

public OnPlayerLeaveDynamicArea(playerid, areaid)
{
	// printf("DEBUG: %d left area %d.", playerid, areaid);
	DeletePVar(playerid, "VEHA_ID");
	ENT_DelVar(playerid);
	return 1;
}

ENT_DelVar(playerid)
{
	g_iEntranceID[playerid] = -1;
	g_iEntranceAID[playerid] = -1;
}

GetIDFromArea(areaid) {

	// printf("DEBUG: AreaID %d was retrieved.", areaid);
	new iAssignData = Streamer_GetIntData(STREAMER_TYPE_AREA, areaid, E_STREAMER_EXTRA_ID);
	// printf("DEBUG: AreaID %d was assigned extra id %d", areaid, iAssignData);
	return iAssignData;
}

Enter_Door(playerid, i, areaid = - 1)
{
	// printf("DEBUG: Enter_Door triggered - Player %d, DoorID: %d, Door sVW: %d, Door sInt: %d", playerid, i, DDoorsInfo[i][ddInteriorVW], DDoorsInfo[i][ddInteriorInt]);
	if(g_iEntranceAID[playerid] == -1 || g_iEntranceID[playerid] == -1) return 1;
	ENT_DelVar(playerid);
	if(!GetPVarType(playerid, "StreamPrep"))
	{
		if(areaid == DDoorsInfo[i][ddAreaID])
		{
			DDoor_Enter(playerid, i);
			return 1;
		}
		if(areaid == DDoorsInfo[i][ddAreaID_int])
		{
			DDoor_Exit(playerid, i);
			return 1;
		}
		if(areaid == GarageInfo[i][gar_AreaID])
		{
			Garage_Enter(playerid, i);
			return 1;
		}
		if(areaid == GarageInfo[i][gar_AreaID_int])
		{
			Garage_Exit(playerid, i);
			return 1;
		}
		if(areaid == HouseInfo[i][hAreaID][0]) 
		{
			House_Enter(playerid, i);
			return 1;
	    }
		if(areaid == HouseInfo[i][hAreaID][1])
		{
			House_Exit(playerid, i);
			return 1;
		}
		if(areaid == Businesses[i][bAreaID][0]) 
		{
			Business_Enter(playerid, i);
			return 1;
	    }
		if(areaid == Businesses[i][bAreaID][1])
		{
			Business_Exit(playerid, i);
			return 1;
		}
		if(areaid == iVehExits[0] || areaid == iVehExits[1] || areaid == iVehExits[2]) {
			Vehicle_Exit(playerid);
			return 1;
		}
		
	}
	return 1;
}

Vehicle_Enter(playerid, i) {

	ClearAnimations(playerid);

	switch(GetVehicleModel(i)) {

		case 508: { // Journey
			SetPlayerPos(playerid, 2820.2109,1527.8270,-48.9141+2500);
			Player_StreamPrep(playerid,2820.2109,1527.8270,-48.9141+2500, FREEZE_TIME);
			SetPlayerFacingAngle(playerid, 270.0);
			PlayerInfo[playerid][pInt] = 1;
			SetPlayerInterior(playerid, 1);
		}
		case 519: { // Shamal
			SetPlayerPos(playerid, 2.509036, 23.118730, 1199.593750);
			SetPlayerFacingAngle(playerid, 82.14);
			PlayerInfo[playerid][pInt] = 1;
			SetPlayerInterior(playerid, 1);
		}
		case 553: { // Nevada
			SetPlayerPos(playerid, 315.9396, 973.2628, 1961.5985);
			SetPlayerFacingAngle(playerid, 2.7);
			PlayerInfo[playerid][pInt] = 9;
			SetPlayerInterior(playerid, 9);
		}
	}

	SetCameraBehindPlayer(playerid);
	PlayerInfo[playerid][pVW] = i;
	SetPlayerVirtualWorld(playerid, i);
	InsidePlane[playerid] = i;
	SetPVarInt(playerid, "InsideCar", 1);
	return 1;
}

Vehicle_Exit(playerid) {
 	
 	if(!IsAPlane(InsidePlane[playerid]) && !GetPVarType(playerid, "InsideCar")) {
	    PlayerInfo[playerid][pAGuns][GetWeaponSlot(46)] = 46;
	    GivePlayerValidWeapon(playerid, 46, 60000);
	    SetPlayerPos(playerid, 0.000000, 0.000000, 420.000000); // lol nick
	}
	else {

	    new Float:X, Float:Y, Float:Z;
	    GetVehiclePos(InsidePlane[playerid], X, Y, Z);
	    
		if(!IsAPlane(PlayerInfo[playerid][pVW]))
		{
			SetPlayerPos(playerid, X-1.00, Y+1.00, Z);
			Player_StreamPrep(playerid, X-1.00, Y+1.00,Z, FREEZE_TIME);
		}
		else
		{
			SetPlayerPos(playerid, X-2.7912, Y+3.2304, Z);
			Player_StreamPrep(playerid, X-2.7912,Y+3.2304,Z, FREEZE_TIME);
			if(Z > 50.0) {
				PlayerInfo[playerid][pAGuns][GetWeaponSlot(46)] = 46;
				GivePlayerValidWeapon(playerid, 46, 60000);
			}
		}
	}
	new iTemp = Streamer_GetIntData(STREAMER_TYPE_AREA, iVehEnterAreaID[PlayerInfo[playerid][pVW]], E_STREAMER_WORLD_ID);
	DeletePVar(playerid, "InsideCar");
	PlayerInfo[playerid][pVW] = iTemp;
	SetPlayerVirtualWorld(playerid, iTemp);
	PlayerInfo[playerid][pInt] = 0;
	SetPlayerInterior(playerid, 0);
	InsidePlane[playerid] = INVALID_VEHICLE_ID;
	return 1;
}

DDoor_Enter(playerid, i)
{
	if(DDoorsInfo[i][ddVIP] > 0 && PlayerInfo[playerid][pDonateRank] < DDoorsInfo[i][ddVIP]) 
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "You can not enter, you are not a high enough VIP level.");
		return 1;
	}
	
	if(DDoorsInfo[i][ddFamed] > 0 && PlayerInfo[playerid][pFamed] < DDoorsInfo[i][ddFamed]) {
		SendClientMessageEx(playerid, COLOR_GRAD2, "You can not enter, you're not a high enough famed level.");
		return 1;
	}

	if(DDoorsInfo[i][ddDPC] > 0 && PlayerInfo[playerid][pRewardHours] < 150) {
		SendClientMessageEx(playerid, COLOR_GRAD2, "You can not enter, you are not a Dedicated Player.");
		return 1;
	}

	if(DDoorsInfo[i][ddAllegiance] > 0) {
		if(arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance] != DDoorsInfo[i][ddAllegiance]) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can not enter, this door is nation restricted.");
		else if(PlayerInfo[playerid][pRank] < DDoorsInfo[i][ddRank]) return SendClientMessageEx(playerid, COLOR_GRAD2, "You are not high enough rank to enter this door.");
	}

	if(DDoorsInfo[i][ddGroupType] > 0) {
		if(arrGroupData[PlayerInfo[playerid][pMember]][g_iGroupType] != DDoorsInfo[i][ddGroupType] && arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance] != DDoorsInfo[i][ddAllegiance]) {
			return SendClientMessageEx(playerid, COLOR_GRAD2, "You can not enter, this door is faction restricted.");
		}
		else if(PlayerInfo[playerid][pRank] < DDoorsInfo[i][ddRank]) return SendClientMessageEx(playerid, COLOR_GRAD2, "You are not high enough rank to enter this door.");
	}

	if(DDoorsInfo[i][ddFaction] != INVALID_GROUP_ID) {
		if(PlayerInfo[playerid][pMember] != DDoorsInfo[i][ddFaction]) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can not enter, this door is faction restricted.");
		else if(PlayerInfo[playerid][pRank] < DDoorsInfo[i][ddRank]) return SendClientMessageEx(playerid, COLOR_GRAD2, "You are not high enough rank to enter this door.");
	}

	if(DDoorsInfo[i][ddAdmin] > 0 && PlayerInfo[playerid][pAdmin] < DDoorsInfo[i][ddAdmin]) {
		SendClientMessageEx(playerid, COLOR_GRAD2, "You can not enter, you are not a high enough admin level.");
		return 1;
	}

	if(DDoorsInfo[i][ddWanted] > 0 && PlayerInfo[playerid][pWantedLevel] != 0) {
		SendClientMessageEx(playerid, COLOR_GRAD2, "You can not enter, this door restricts those with wanted levels.");
		return 1;
	}

	if(DDoorsInfo[i][ddLocked] == 1) {
		return SendClientMessageEx(playerid, COLOR_GRAD2, "This door is currently locked.");
	}

	PlayerInfo[playerid][pInt] = DDoorsInfo[i][ddInteriorInt];
	SetPlayerInterior(playerid,DDoorsInfo[i][ddInteriorInt]);
	PlayerInfo[playerid][pVW] = DDoorsInfo[i][ddInteriorVW];
	SetPlayerVirtualWorld(playerid, DDoorsInfo[i][ddInteriorVW]);
	
	if(DDoorsInfo[i][ddVehicleAble] > 0 && GetPlayerState(playerid) == PLAYER_STATE_DRIVER) {

		new iVeh = GetPlayerVehicleID(playerid);
		SetVehiclePos(iVeh, DDoorsInfo[i][ddInteriorX],DDoorsInfo[i][ddInteriorY],DDoorsInfo[i][ddInteriorZ]);
		SetVehicleZAngle(iVeh, DDoorsInfo[i][ddInteriorA]);
		SetVehicleVirtualWorld(iVeh, DDoorsInfo[i][ddInteriorVW]);
		LinkVehicleToInterior(iVeh, DDoorsInfo[i][ddInteriorInt]);
		if(IsValidDynamicArea(iVehEnterAreaID[iVeh])) {
			Streamer_SetIntData(STREAMER_TYPE_AREA, iVehEnterAreaID[iVeh], E_STREAMER_WORLD_ID, iVeh);
		}
		if(GetPVarInt(playerid, "tpForkliftTimer") > 0)
		{
			SetPVarInt(playerid, "tpJustEntered", 1);
			new Float: pX, Float: pY, Float: pZ;
			GetPlayerPos(playerid, pX, pY, pZ);
			SetPVarFloat(playerid, "tpForkliftX", pX);
			SetPVarFloat(playerid, "tpForkliftY", pY);
			SetPVarFloat(playerid, "tpForkliftZ", pZ);
		}
		if(DynVeh[GetPlayerVehicleID(playerid)] != -1)
		{
			new vw[1];
			vw[0] = GetVehicleVirtualWorld(GetPlayerVehicleID(playerid));
			if(DynVehicleInfo[DynVeh[GetPlayerVehicleID(playerid)]][gv_iAttachedObjectModel][0] != INVALID_OBJECT_ID)
			{
				Streamer_SetArrayData(STREAMER_TYPE_OBJECT, DynVehicleInfo[DynVeh[GetPlayerVehicleID(playerid)]][gv_iAttachedObjectID][0], E_STREAMER_WORLD_ID, vw[0]);

			}
			if(DynVehicleInfo[DynVeh[GetPlayerVehicleID(playerid)]][gv_iAttachedObjectModel][1] != INVALID_OBJECT_ID)
			{
				Streamer_SetArrayData(STREAMER_TYPE_OBJECT, DynVehicleInfo[DynVeh[GetPlayerVehicleID(playerid)]][gv_iAttachedObjectID][1], E_STREAMER_WORLD_ID, vw[0]);

			}
		}
		foreach(new passenger : Player)
		{
			if(passenger != playerid)
			{
				if(IsPlayerInVehicle(passenger, GetPlayerVehicleID(playerid)))
				{
					SetPlayerInterior(passenger,DDoorsInfo[i][ddInteriorInt]);
					PlayerInfo[passenger][pInt] = DDoorsInfo[i][ddInteriorInt];
					PlayerInfo[passenger][pVW] = DDoorsInfo[i][ddInteriorVW];
					SetPlayerVirtualWorld(passenger, DDoorsInfo[i][ddInteriorVW]);
				}
			}
		}
	}
	else {
		SetPlayerPos(playerid,DDoorsInfo[i][ddInteriorX],DDoorsInfo[i][ddInteriorY],DDoorsInfo[i][ddInteriorZ]);
		SetPlayerFacingAngle(playerid,DDoorsInfo[i][ddInteriorA]);
		SetCameraBehindPlayer(playerid);
	}
	if(DDoorsInfo[i][ddCustomInterior]) Player_StreamPrep(playerid, DDoorsInfo[i][ddInteriorX],DDoorsInfo[i][ddInteriorY],DDoorsInfo[i][ddInteriorZ], FREEZE_TIME);
	return 1;
}

DDoor_Exit(playerid, i)
{
	SetPlayerInterior(playerid,DDoorsInfo[i][ddExteriorInt]);
	PlayerInfo[playerid][pInt] = DDoorsInfo[i][ddExteriorInt];
	SetPlayerVirtualWorld(playerid, DDoorsInfo[i][ddExteriorVW]);
	PlayerInfo[playerid][pVW] = DDoorsInfo[i][ddExteriorVW];
	SetPlayerToTeamColor(playerid);
	if(DDoorsInfo[i][ddVehicleAble] > 0 && GetPlayerState(playerid) == PLAYER_STATE_DRIVER) {
		SetVehiclePos(GetPlayerVehicleID(playerid), DDoorsInfo[i][ddExteriorX],DDoorsInfo[i][ddExteriorY],DDoorsInfo[i][ddExteriorZ]);
		SetVehicleZAngle(GetPlayerVehicleID(playerid), DDoorsInfo[i][ddExteriorA]);
		SetVehicleVirtualWorld(GetPlayerVehicleID(playerid), DDoorsInfo[i][ddExteriorVW]);
		LinkVehicleToInterior(GetPlayerVehicleID(playerid), DDoorsInfo[i][ddExteriorInt]);
		if(GetPVarInt(playerid, "tpForkliftTimer") > 0)
		{
			SetPVarInt(playerid, "tpJustEntered", 1);
			new Float: pX, Float: pY, Float: pZ;
			GetPlayerPos(playerid, pX, pY, pZ);
			SetPVarFloat(playerid, "tpForkliftX", pX);
			SetPVarFloat(playerid, "tpForkliftY", pY);
			SetPVarFloat(playerid, "tpForkliftZ", pZ);
		}
		if(DynVeh[GetPlayerVehicleID(playerid)] != -1)
		{
			new vw[1];
			vw[0] = GetVehicleVirtualWorld(GetPlayerVehicleID(playerid));
			if(DynVehicleInfo[DynVeh[GetPlayerVehicleID(playerid)]][gv_iAttachedObjectModel][0] != INVALID_OBJECT_ID)
			{
				Streamer_SetArrayData(STREAMER_TYPE_OBJECT, DynVehicleInfo[DynVeh[GetPlayerVehicleID(playerid)]][gv_iAttachedObjectID][0], E_STREAMER_WORLD_ID, vw[0]);

			}
			if(DynVehicleInfo[DynVeh[GetPlayerVehicleID(playerid)]][gv_iAttachedObjectModel][1] != INVALID_OBJECT_ID)
			{
				Streamer_SetArrayData(STREAMER_TYPE_OBJECT, DynVehicleInfo[DynVeh[GetPlayerVehicleID(playerid)]][gv_iAttachedObjectID][1], E_STREAMER_WORLD_ID, vw[0]);

			}
		}
		foreach(new passenger: Player)
		{
			if(passenger != playerid)
			{
				if(IsPlayerInVehicle(passenger, GetPlayerVehicleID(playerid)))
				{
					SetPlayerInterior(passenger,DDoorsInfo[i][ddExteriorInt]);
					PlayerInfo[passenger][pInt] = DDoorsInfo[i][ddExteriorInt];
					PlayerInfo[passenger][pVW] = DDoorsInfo[i][ddExteriorVW];
					SetPlayerVirtualWorld(passenger, DDoorsInfo[i][ddExteriorVW]);
				}
			}
		}
	}
	else {
		SetPlayerPos(playerid,DDoorsInfo[i][ddExteriorX],DDoorsInfo[i][ddExteriorY],DDoorsInfo[i][ddExteriorZ]);
		SetPlayerFacingAngle(playerid, DDoorsInfo[i][ddExteriorA]);
		SetCameraBehindPlayer(playerid);
	}
	if(DDoorsInfo[i][ddCustomExterior]) Player_StreamPrep(playerid, DDoorsInfo[i][ddExteriorX],DDoorsInfo[i][ddExteriorY],DDoorsInfo[i][ddExteriorZ], FREEZE_TIME);
	if(GetPVarType(playerid, "BusinessesID")) DeletePVar(playerid, "BusinessesID");
	return 1;
}

House_Enter(playerid, i)
{
	if(PlayerInfo[playerid][pPhousekey] == i || PlayerInfo[playerid][pPhousekey2] == i || HouseInfo[i][hLock] == 0 || PlayerInfo[playerid][pRenting] == i) {
		SetPlayerInterior(playerid,HouseInfo[i][hIntIW]);
		PlayerInfo[playerid][pInt] = HouseInfo[i][hIntIW];
		PlayerInfo[playerid][pVW] = HouseInfo[i][hIntVW];
		SetPlayerVirtualWorld(playerid,HouseInfo[i][hIntVW]);
		SetPlayerPos(playerid,HouseInfo[i][hInteriorX],HouseInfo[i][hInteriorY],HouseInfo[i][hInteriorZ]);
		SetPlayerFacingAngle(playerid,HouseInfo[i][hInteriorA]);
		SetCameraBehindPlayer(playerid);
		GameTextForPlayer(playerid, "~w~Welcome Home", 5000, 1);
		if(HouseInfo[i][hCustomInterior] == 1) Player_StreamPrep(playerid, HouseInfo[i][hInteriorX],HouseInfo[i][hInteriorY],HouseInfo[i][hInteriorZ], FREEZE_TIME);
	}
	else GameTextForPlayer(playerid, "~r~Locked", 5000, 1);
	return 1;
}

House_Exit(playerid, i)
{
	SetPlayerInterior(playerid,0);
	PlayerInfo[playerid][pInt] = 0;
	SetPlayerPos(playerid,HouseInfo[i][hExteriorX],HouseInfo[i][hExteriorY],HouseInfo[i][hExteriorZ]);
	SetPlayerFacingAngle(playerid, HouseInfo[i][hExteriorA]);
	SetCameraBehindPlayer(playerid);
	SetPlayerVirtualWorld(playerid, HouseInfo[i][hExtVW]);
	PlayerInfo[playerid][pVW] = HouseInfo[i][hExtVW];
	PlayerInfo[playerid][pInt] = HouseInfo[i][hExtIW];
	SetPlayerInterior(playerid, HouseInfo[i][hExtIW]);
	if(HouseInfo[i][hCustomExterior]) Player_StreamPrep(playerid, HouseInfo[i][hExteriorX],HouseInfo[i][hExteriorY],HouseInfo[i][hExteriorZ], FREEZE_TIME);
	return 1;	
}

Business_Enter(playerid, i)
{
	if(Businesses[i][bExtPos][1] == 0.0) return SendClientMessageEx(playerid, COLOR_WHITE, "You cannot enter this business.");
	if(Businesses[i][bStatus]) {
		if (Businesses[i][bType] == BUSINESS_TYPE_GYM)
		{
			if (Businesses[i][bGymEntryFee] > 0 && PlayerInfo[playerid][pCash] < Businesses[i][bGymEntryFee])
			{
				GameTextForPlayer(playerid, "~r~You need more money to enter this gym", 5000, 1);
				return 1;
			}
		}
		SetPVarInt(playerid, "BusinessesID", i);

		if(Businesses[i][bVW] == 0) SetPlayerVirtualWorld(playerid, BUSINESS_BASE_VW + i), PlayerInfo[playerid][pVW] = BUSINESS_BASE_VW + i;
		else SetPlayerVirtualWorld(playerid, Businesses[i][bVW]), PlayerInfo[playerid][pVW] = Businesses[i][bVW];


		SetPlayerInterior(playerid,Businesses[i][bInt]);
		SetPlayerPos(playerid,Businesses[i][bIntPos][0],Businesses[i][bIntPos][1],Businesses[i][bIntPos][2]);
		SetPlayerFacingAngle(playerid, Businesses[i][bIntPos][3]);
		SetCameraBehindPlayer(playerid);
		PlayerInfo[playerid][pInt] = Businesses[i][bInt];
		if(Businesses[i][bCustomInterior]) Player_StreamPrep(playerid, Businesses[i][bIntPos][0], Businesses[i][bIntPos][1], Businesses[i][bIntPos][2], FREEZE_TIME);

		if (Businesses[i][bType] == BUSINESS_TYPE_GYM)
		{
			new string[50];
			format(string, sizeof(string), "You entered a gym and were charged $%i.", Businesses[i][bGymEntryFee]);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			GivePlayerCash(playerid, -Businesses[i][bGymEntryFee]);
			Businesses[i][bSafeBalance] += Businesses[i][bGymEntryFee];

			if (Businesses[i][bGymType] == 1)
			{
				SendClientMessageEx(playerid, COLOR_WHITE, "Type /beginswimming to start using the swimming pool.");
				SendClientMessageEx(playerid, COLOR_WHITE, "Type /joinboxing to join the boxing queue.");
			}
			else if (Businesses[i][bGymType] == 2)
			{
				SendClientMessageEx(playerid, COLOR_WHITE, "Type /beginparkour to begin the bike parkour track.");
			}
		}
	}
	else GameTextForPlayer(playerid, "~r~Closed", 5000, 1);
	return 1;
}

Business_Exit(playerid, i)
{
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 0);
	SetPlayerPos(playerid,Businesses[i][bExtPos][0],Businesses[i][bExtPos][1],Businesses[i][bExtPos][2]);
	SetPlayerFacingAngle(playerid, Businesses[i][bExtPos][3]);
	SetCameraBehindPlayer(playerid);
	PlayerInfo[playerid][pInt] = 0;
	PlayerInfo[playerid][pVW] = 0;
	DeletePVar(playerid, "BusinessesID");
	if(Businesses[i][bCustomExterior]) Player_StreamPrep(playerid, Businesses[i][bExtPos][0], Businesses[i][bExtPos][1], Businesses[i][bExtPos][2], FREEZE_TIME);
	return 1;
}

Garage_Enter(playerid, i) {

	if(GarageInfo[i][gar_Locked] == 1) return SendClientMessageEx(playerid, COLOR_GRAD2, "This garage is currently locked.");
	PlayerInfo[playerid][pVW] = GarageInfo[i][gar_InteriorVW];
	SetPlayerVirtualWorld(playerid, GarageInfo[i][gar_InteriorVW]);
	SetPlayerInterior(playerid, 1);
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		SetVehiclePos(GetPlayerVehicleID(playerid), GarageInfo[i][gar_InteriorX], GarageInfo[i][gar_InteriorY], GarageInfo[i][gar_InteriorZ]);
		SetVehicleZAngle(GetPlayerVehicleID(playerid), GarageInfo[i][gar_InteriorA]);
		SetVehicleVirtualWorld(GetPlayerVehicleID(playerid), GarageInfo[i][gar_InteriorVW]);
		LinkVehicleToInterior(GetPlayerVehicleID(playerid), 1);
		if(GetPVarInt(playerid, "tpForkliftTimer") > 0)
		{
			SetPVarInt(playerid, "tpJustEntered", 1);
			new Float: pX, Float: pY, Float: pZ;
			GetPlayerPos(playerid, pX, pY, pZ);
			SetPVarFloat(playerid, "tpForkliftX", pX);
			SetPVarFloat(playerid, "tpForkliftY", pY);
			SetPVarFloat(playerid, "tpForkliftZ", pZ);
		}
		if(GetPVarInt(playerid, "tpDeliverVehTimer") > 0) SetPVarInt(playerid, "tpJustEntered", 1);
		if(DynVeh[GetPlayerVehicleID(playerid)] != -1)
		{
			new vw[1];
			vw[0] = GetVehicleVirtualWorld(GetPlayerVehicleID(playerid));
			if(DynVehicleInfo[DynVeh[GetPlayerVehicleID(playerid)]][gv_iAttachedObjectModel][0] != INVALID_OBJECT_ID)
			{
				Streamer_SetArrayData(STREAMER_TYPE_OBJECT, DynVehicleInfo[DynVeh[GetPlayerVehicleID(playerid)]][gv_iAttachedObjectID][0], E_STREAMER_WORLD_ID, vw[0]);
			}
			if(DynVehicleInfo[DynVeh[GetPlayerVehicleID(playerid)]][gv_iAttachedObjectModel][1] != INVALID_OBJECT_ID)
			{
				Streamer_SetArrayData(STREAMER_TYPE_OBJECT, DynVehicleInfo[DynVeh[GetPlayerVehicleID(playerid)]][gv_iAttachedObjectID][1], E_STREAMER_WORLD_ID, vw[0]);
			}
		}
		foreach(new passenger : Player)
		{
			if(passenger != playerid)
			{
				if(IsPlayerInVehicle(passenger, GetPlayerVehicleID(playerid)))
				{
					SetPlayerInterior(passenger, 1);
					PlayerInfo[passenger][pInt] = 1;
					PlayerInfo[passenger][pVW] = GarageInfo[i][gar_InteriorVW];
					SetPlayerVirtualWorld(passenger, GarageInfo[i][gar_InteriorVW]);
				}
			}
		}
	}
	else
	{
		SetPlayerPos(playerid, GarageInfo[i][gar_InteriorX], GarageInfo[i][gar_InteriorY], GarageInfo[i][gar_InteriorZ]);
		SetPlayerFacingAngle(playerid, GarageInfo[i][gar_InteriorA]);
		SetCameraBehindPlayer(playerid);
	}
	Player_StreamPrep(playerid, GarageInfo[i][gar_InteriorX], GarageInfo[i][gar_InteriorY], GarageInfo[i][gar_InteriorZ], FREEZE_TIME);
	return 1;
}

Garage_Exit(playerid, i) {
	SetPlayerInterior(playerid, GarageInfo[i][gar_ExteriorInt]);
	PlayerInfo[playerid][pInt] = GarageInfo[i][gar_ExteriorInt];
	SetPlayerVirtualWorld(playerid, GarageInfo[i][gar_ExteriorVW]);
	PlayerInfo[playerid][pVW] = GarageInfo[i][gar_ExteriorVW];
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		SetVehiclePos(GetPlayerVehicleID(playerid), GarageInfo[i][gar_ExteriorX], GarageInfo[i][gar_ExteriorY], GarageInfo[i][gar_ExteriorZ]);
		SetVehicleZAngle(GetPlayerVehicleID(playerid), GarageInfo[i][gar_ExteriorA]);
		SetVehicleVirtualWorld(GetPlayerVehicleID(playerid), GarageInfo[i][gar_ExteriorVW]);
		LinkVehicleToInterior(GetPlayerVehicleID(playerid), GarageInfo[i][gar_ExteriorInt]);
		if(GetPVarInt(playerid, "tpForkliftTimer") > 0)
		{
			SetPVarInt(playerid, "tpJustEntered", 1);
			new Float: pX, Float: pY, Float: pZ;
			GetPlayerPos(playerid, pX, pY, pZ);
			SetPVarFloat(playerid, "tpForkliftX", pX);
			SetPVarFloat(playerid, "tpForkliftY", pY);
			SetPVarFloat(playerid, "tpForkliftZ", pZ);
		}
		if(DynVeh[GetPlayerVehicleID(playerid)] != -1)
		{
			new vw[1];
			vw[0] = GetVehicleVirtualWorld(GetPlayerVehicleID(playerid));
			if(DynVehicleInfo[DynVeh[GetPlayerVehicleID(playerid)]][gv_iAttachedObjectModel][0] != INVALID_OBJECT_ID)
			{
				Streamer_SetArrayData(STREAMER_TYPE_OBJECT, DynVehicleInfo[DynVeh[GetPlayerVehicleID(playerid)]][gv_iAttachedObjectID][0], E_STREAMER_WORLD_ID, vw[0]);
			}
			if(DynVehicleInfo[DynVeh[GetPlayerVehicleID(playerid)]][gv_iAttachedObjectModel][1] != INVALID_OBJECT_ID)
			{
				Streamer_SetArrayData(STREAMER_TYPE_OBJECT, DynVehicleInfo[DynVeh[GetPlayerVehicleID(playerid)]][gv_iAttachedObjectID][1], E_STREAMER_WORLD_ID, vw[0]);
			}
		}
		foreach(new passenger : Player)
		{
			if(passenger != playerid)
			{
				if(IsPlayerInVehicle(passenger, GetPlayerVehicleID(playerid)))
				{
					SetPlayerInterior(passenger,GarageInfo[i][gar_ExteriorInt]);
					PlayerInfo[passenger][pInt] = GarageInfo[i][gar_ExteriorInt];
					PlayerInfo[passenger][pVW] = GarageInfo[i][gar_ExteriorVW];
					SetPlayerVirtualWorld(passenger, GarageInfo[i][gar_ExteriorVW]);
				}
			}
		}
	}
	else 
	{
		SetPlayerPos(playerid, GarageInfo[i][gar_ExteriorX], GarageInfo[i][gar_ExteriorY], GarageInfo[i][gar_ExteriorZ]);
		SetPlayerFacingAngle(playerid, GarageInfo[i][gar_ExteriorA]);
		SetCameraBehindPlayer(playerid);
	}
	if(GarageInfo[i][gar_CustomExterior]) Player_StreamPrep(playerid, GarageInfo[i][gar_ExteriorX], GarageInfo[i][gar_ExteriorY], GarageInfo[i][gar_ExteriorZ], FREEZE_TIME);
	return 1;
}