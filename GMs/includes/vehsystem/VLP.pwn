/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						VLP System

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

UpdateVLPTextDraws(playerid, vehicleid, TYPE = 0) {
	new tdMessage[9 + MAX_ZONE_NAME], tdCarLocation[MAX_ZONE_NAME], Float:CarPos[3];
	GetVehiclePos(vehicleid, CarPos[0], CarPos[1], CarPos[2]);
	Get3DZone(CarPos[0], CarPos[1], CarPos[2], tdCarLocation, sizeof(tdCarLocation));
	format(tdMessage, sizeof(tdMessage), "%s Robbery", tdCarLocation);
	PlayerTextDrawSetString(playerid, VLPTextDraws[playerid][0], tdMessage);
	switch(TYPE) {
		case 0: {
			PlayerTextDrawSetString(playerid, VLPTextDraws[playerid][0], "Attempting to lock pick vehicle");
			format(tdMessage, sizeof(tdMessage), "%s", ConvertTimeS(GetPVarInt(playerid, "LockPickCountdown"), 1));
			PlayerTextDrawSetString(playerid, VLPTextDraws[playerid][3], tdMessage);
		}
		case 1: {
			PlayerTextDrawSetString(playerid, VLPTextDraws[playerid][0], "Attempting to crack the trunk");
			format(tdMessage, sizeof(tdMessage), "%s", ConvertTimeS(GetPVarInt(playerid, "CrackTrunkCountdown"), 1));
			PlayerTextDrawSetString(playerid, VLPTextDraws[playerid][3], tdMessage);
		}
		case 2: {
			PlayerTextDrawSetString(playerid, VLPTextDraws[playerid][0], "Deliver Vehicle");
			format(tdMessage, sizeof(tdMessage), "00:%d", GetPVarInt(playerid, "DeliveringVehicleTime"));
			PlayerTextDrawSetString(playerid, VLPTextDraws[playerid][3], tdMessage);
		}
	}
}

DestroyVLPTextDraws(playerid) {
	for(new i = 0; i < 4; i++)
		PlayerTextDrawDestroy(playerid, VLPTextDraws[playerid][i]);
}

//Vehicle Lock Pick Textdraws
/*CreateVLPTextDraws(playerid)
{
	VLPTextDraws[playerid][0] = CreatePlayerTextDraw(playerid, 638.264770, 390.386749, "Attempting to lock pick vehicle");
	PlayerTextDrawLetterSize(playerid, VLPTextDraws[playerid][0], 0.449999, 1.600000);
	PlayerTextDrawTextSize(playerid, VLPTextDraws[playerid][0], 342.399902, -321.813293);
	PlayerTextDrawAlignment(playerid, VLPTextDraws[playerid][0], 3);
	PlayerTextDrawColor(playerid, VLPTextDraws[playerid][0], 41215);
	PlayerTextDrawUseBox(playerid, VLPTextDraws[playerid][0], true);
	PlayerTextDrawBoxColor(playerid, VLPTextDraws[playerid][0], 77);
	PlayerTextDrawSetShadow(playerid, VLPTextDraws[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, VLPTextDraws[playerid][0], 1);
	PlayerTextDrawBackgroundColor(playerid, VLPTextDraws[playerid][0], 154);
	PlayerTextDrawFont(playerid, VLPTextDraws[playerid][0], 3);
	PlayerTextDrawSetProportional(playerid, VLPTextDraws[playerid][0], 1);

	VLPTextDraws[playerid][1] = CreatePlayerTextDraw(playerid, 638.464538, 411.413299, "Location");
	PlayerTextDrawLetterSize(playerid, VLPTextDraws[playerid][1], 0.449999, 1.600000);
	PlayerTextDrawTextSize(playerid, VLPTextDraws[playerid][1], -585.599975, 212.053375);
	PlayerTextDrawAlignment(playerid, VLPTextDraws[playerid][1], 3);
	PlayerTextDrawColor(playerid, VLPTextDraws[playerid][1], -1805713409);
	PlayerTextDrawUseBox(playerid, VLPTextDraws[playerid][1], true);
	PlayerTextDrawBoxColor(playerid, VLPTextDraws[playerid][1], 77);
	PlayerTextDrawSetShadow(playerid, VLPTextDraws[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, VLPTextDraws[playerid][1], 1);
	PlayerTextDrawBackgroundColor(playerid, VLPTextDraws[playerid][1], 255);
	PlayerTextDrawFont(playerid, VLPTextDraws[playerid][1], 3);
	PlayerTextDrawSetProportional(playerid, VLPTextDraws[playerid][1], 1);

	VLPTextDraws[playerid][2] = CreatePlayerTextDraw(playerid, 572.635070, 432.238861, "Please wait:");
	PlayerTextDrawLetterSize(playerid, VLPTextDraws[playerid][2], 0.449999, 1.600000);
	PlayerTextDrawTextSize(playerid, VLPTextDraws[playerid][2], -585.599975, 212.053375);
	PlayerTextDrawAlignment(playerid, VLPTextDraws[playerid][2], 3);
	PlayerTextDrawColor(playerid, VLPTextDraws[playerid][2], -1);
	PlayerTextDrawUseBox(playerid, VLPTextDraws[playerid][2], true);
	PlayerTextDrawBoxColor(playerid, VLPTextDraws[playerid][2], 77);
	PlayerTextDrawSetShadow(playerid, VLPTextDraws[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, VLPTextDraws[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, VLPTextDraws[playerid][2], 255);
	PlayerTextDrawFont(playerid, VLPTextDraws[playerid][2], 3);
	PlayerTextDrawSetProportional(playerid, VLPTextDraws[playerid][2], 1);

	VLPTextDraws[playerid][3] = CreatePlayerTextDraw(playerid, 607.519653, 432.095947, "00:12");
	PlayerTextDrawLetterSize(playerid, VLPTextDraws[playerid][3], 0.449999, 1.600000);
	PlayerTextDrawTextSize(playerid, VLPTextDraws[playerid][3], 172.000000, -70.933380);
	PlayerTextDrawAlignment(playerid, VLPTextDraws[playerid][3], 2);
	PlayerTextDrawColor(playerid, VLPTextDraws[playerid][3], 104202495);
	PlayerTextDrawUseBox(playerid, VLPTextDraws[playerid][3], true);
	PlayerTextDrawBoxColor(playerid, VLPTextDraws[playerid][3], 77);
	PlayerTextDrawSetShadow(playerid, VLPTextDraws[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, VLPTextDraws[playerid][3], 1);
	PlayerTextDrawBackgroundColor(playerid, VLPTextDraws[playerid][3], 51);
	PlayerTextDrawFont(playerid, VLPTextDraws[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, VLPTextDraws[playerid][3], 1);
}*/

/*ShowVLPTextDraws(playerid, vehicleid, TYPE = 0) {
	CreateVLPTextDraws(playerid);
	new tdMessage[9 + MAX_ZONE_NAME], tdCarLocation[MAX_ZONE_NAME], Float:CarPos[3];
	GetVehiclePos(vehicleid, CarPos[0], CarPos[1], CarPos[2]);
	Get3DZone(CarPos[0], CarPos[1], CarPos[2], tdCarLocation, sizeof(tdCarLocation));
	format(tdMessage, sizeof(tdMessage), "%s", tdCarLocation);
	PlayerTextDrawSetString(playerid, VLPTextDraws[playerid][1], tdMessage);
	switch(TYPE) {
		case 0: {
			PlayerTextDrawSetString(playerid, VLPTextDraws[playerid][0], "Attempting to lock pick vehicle");
			format(tdMessage, sizeof(tdMessage), "%s", ConvertTimeS(GetPVarInt(playerid, "LockPickCountdown"), 1));
			PlayerTextDrawSetString(playerid, VLPTextDraws[playerid][3], tdMessage);
		}
		case 1: {
			PlayerTextDrawSetString(playerid, VLPTextDraws[playerid][0], "Attempting to crack the trunk");
			format(tdMessage, sizeof(tdMessage), "%s", ConvertTimeS(GetPVarInt(playerid, "CrackTrunkCountdown"), 1));
			PlayerTextDrawSetString(playerid, VLPTextDraws[playerid][3], tdMessage);
		}
		case 2: {
			PlayerTextDrawSetString(playerid, VLPTextDraws[playerid][0], "Deliver Vehicle");
			format(tdMessage, sizeof(tdMessage), "00:%d", GetPVarInt(playerid, "DeliveringVehicleTime"));
			PlayerTextDrawSetString(playerid, VLPTextDraws[playerid][3], tdMessage);
		}
	}
	for(new i = 0; i < 4; i++)
		PlayerTextDrawShow(playerid, VLPTextDraws[playerid][i]);
}*/

CMD:pickvehicle(playerid, params[])
{
	return cmd_pickveh(playerid, params);
}

CMD:pickveh(playerid, params[])
{
	/*
	new szMessage[150], Float: vehSize[3], Float: Pos[3], Float:a, success;

	if(gettime() < PlayerInfo[playerid][pLockPickTime]) {
		format(szMessage, sizeof(szMessage), "You must wait %s in order to attempt another lock pick.", ConvertTimeS(PlayerInfo[playerid][pLockPickTime] - gettime()));
		return SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
	}
	if(GetPVarType(playerid, "AttemptingLockPick")) return SendClientMessageEx(playerid, COLOR_WHITE, "You are already attempting a lockpick, please wait.");
	if(GetPVarType(playerid, "DeliveringVehicleTime")) return SendClientMessageEx(playerid, COLOR_WHITE, "Deliver the vehicle you lock picked first or wait some time.");
	if(!PlayerInfo[playerid][pToolBox]) return SendClientMessageEx(playerid, COLOR_WHITE, "You need a Tool Box in order to lock pick a vehicle, get one from a Craftsman.");
	if(!PlayerInfo[playerid][pScrewdriver]) return SendClientMessageEx(playerid, COLOR_WHITE, "You need a Screwdriver in order to lock pick a vehicle, get one from a Craftsman.");
	
	if(GetPVarType(playerid, "PlayerCuffed") || GetPVarInt(playerid, "pBagged") >= 1 || GetPVarType(playerid, "Injured") || GetPVarType(playerid, "IsFrozen") || GetPVarType(playerid, "IsInArena") || GetPVarInt( playerid, "EventToken") || IsPlayerInAnyVehicle(playerid) || HungerPlayerInfo[playerid][hgInEvent])
		return SendClientMessage(playerid, COLOR_GRAD2, "You can't do that at this time!");
		
	
	new vehicleid = GetClosestCar(playerid);
	if(IsAPlane(vehicleid) || IsWeaponizedVehicle(GetVehicleModel(vehicleid)) || IsABike(vehicleid))
		return SendClientMessageEx(playerid,COLOR_GREY,"(( You can't pick lock this vehicle. ))");
	for(new d = 0 ; d < MAX_PLAYERVEHICLES; d++)
		if(PlayerVehicleInfo[playerid][d][pvId] == vehicleid) return SendClientMessageEx(playerid,COLOR_GREY,"You cannot lock pick any vehicle that you own.");
	for(new i = 1; i < sizeof(ParkingMeterInformation); i++)
		if(ParkingMeterInformation[i][AssignedVehicle] == vehicleid) return SendClientMessageEx(playerid,COLOR_GREY,"You cannot lock pick any vehicle that is attached to a parking meter.");
	
	GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_SIZE, vehSize[0], vehSize[1], vehSize[2]);
	GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_FRONTSEAT, Pos[0], Pos[1], Pos[2]);
	GetVehicleRelativePos(vehicleid, Pos[0], Pos[1], Pos[2], Pos[0]+((vehSize[0] / 2)-(vehSize[0])), Pos[1], 0.0);
	if(IsPlayerInRangeOfPoint(playerid, 1.0, Pos[0], Pos[1], Pos[2])) {
		foreach(new i: Player)  
		{
			new v = GetPlayerVehicle(i, vehicleid);
			if(v != -1) {
				if(PlayerVehicleInfo[i][v][pvLock] == 0 || PlayerVehicleInfo[i][v][pvLocksLeft] <= 0)
					return SendClientMessageEx(playerid, COLOR_WHITE, "ERROR: You can't pick lock vehicles that don't have a lock.");
				if(IsABike(PlayerVehicleInfo[i][v][pvModelId])) return SendClientMessageEx(playerid, COLOR_WHITE, "ERROR: You can't pick lock bikes.");
				if(PlayerVehicleInfo[i][v][pvBeingPickLocked] > 0)
					return SendClientMessageEx(playerid, COLOR_WHITE, "ERROR: This vehicle is already being lock picked.");
				if(PlayerVehicleInfo[i][v][pvAllowedPlayerId] == playerid)
					return SendClientMessageEx(playerid, COLOR_WHITE, "ERROR: You can't pick lock vehicles that you have the keys of them.");
				new status, waittime, vipperk, randskill = random(100);
				switch(PlayerInfo[playerid][pDonateRank]) {
					case 1: vipperk = 5;
					case 2: vipperk = 10;
					case 3, 4, 5: vipperk = 15;
				}
				switch(PlayerInfo[playerid][pCarLockPickSkill]) {
					case 0 .. 49: if(0 <= randskill < (25+vipperk)) waittime = 180, status = 1; //Success
					case 50 .. 124: if(0 <= randskill < (35+vipperk)) waittime = 170, status = 1; //Success
					case 125 .. 224: if(0 <= randskill < (45+vipperk)) waittime = 160, status = 1; //Success
					case 225 .. 349: if(0 <= randskill < (55+vipperk)) waittime = 150, status = 1; //Success
					default: if(0 <= randskill < (65+vipperk)) waittime = 130, status = 1; //Success
				}
				format(szMessage, sizeof(szMessage), "* %s attempts to pick lock a nearby vehicle.", GetPlayerNameEx(playerid));
				ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				PlayerInfo[playerid][pLockPickTime] = gettime() + 10;
				if(status) {
					SetPVarInt(playerid, "AttemptingLockPick", 1);
					SetPVarInt(playerid, "LockPickCountdown", waittime);
					SetPVarInt(playerid, "LockPickTotalTime", waittime);
					SetPVarInt(playerid, "LockPickVehicle", vehicleid);
					SetPVarInt(playerid, "LockPickPlayer", i);
					DeletePVar(playerid, "TrunkAlreadyCracked");
					
					PlayerVehicleInfo[i][v][pvBeingPickLocked] = 1;
					PlayerVehicleInfo[i][v][pvBeingPickLockedBy] = playerid;
					SendClientMessageEx(playerid, COLOR_PURPLE, "(( You've successfully managed to start pick locking this vehicle, you are now attempting to break into it. /stoplockpick ))");
					SendClientMessageEx(playerid, COLOR_YELLOW, "Warning{FFFFFF}: Please stay still, if you move or get shot you may fail lock picking the vehicle.");
					ShowVLPTextDraws(playerid, vehicleid);
					GetVehicleZAngle(vehicleid, a);
					SetPlayerFacingAngle(playerid, a-90);
					ApplyAnimation(playerid, "COP_AMBIENT", "Copbrowse_loop", 4.1, 1, 0, 0, 0, 0, 1);
					new ip[MAX_PLAYER_NAME], ip2[MAX_PLAYER_NAME];
					GetPlayerIp(playerid, ip, sizeof(ip));
					GetPlayerIp(i, ip2, sizeof(ip2));
					format(szMessage, sizeof(szMessage), "[LOCK PICK] %s(%d) (IP:%s) is attempting to lock pick a %s(VID:%d Slot %d) owned by %s(IP:%s)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ip, GetVehicleName(PlayerVehicleInfo[i][v][pvId]), PlayerVehicleInfo[playerid][v][pvId], v, GetPlayerNameEx(i), ip2);
					Log("logs/playervehicle.log", szMessage);
				}
				else {
					SendClientMessageEx(playerid, COLOR_PURPLE, "(( Your attempt to lock pick this vehicle failed! Try again or move on. ))");
				}
				success = 1;
				break;
			}
		}
		if(!success) {
			return SendClientMessageEx(playerid, COLOR_WHITE, "This vehicle is not available to be pick locked.");
		}
	}
	else {
		return SendClientMessageEx(playerid, COLOR_WHITE, "You need to be next to the drivers door in order to lock pick it.");
	}
	*/
	SendClientMessageEx(playerid, COLOR_WHITE, "This command has been disabled temporaly disabled due to an unknown issue.");
	SendClientMessageEx(playerid, COLOR_WHITE, "Please do not report about this being disabled, we are testing something.");
	return 1;
}
CMD:cracktrunk(playerid, params[])
{
	/*
	if(PlayerInfo[playerid][pWRestricted] || PlayerInfo[playerid][pConnectHours] < 2) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot use this command while having a weapon restriction.");
	new szMessage[150], Float: x, Float: y, Float: z;

	if(gettime() < PlayerInfo[playerid][pLockPickTime]) {
		format(szMessage, sizeof(szMessage), "You must wait %s in order to attempt another crack trunk.", ConvertTimeS(PlayerInfo[playerid][pLockPickTime] - gettime()));
		return SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
	}
	if(!PlayerInfo[playerid][pToolBox]) return SendClientMessageEx(playerid, COLOR_WHITE, "You need a Tool Box in order to lock pick a vehicle, get one from a Craftsman.");
	if(!PlayerInfo[playerid][pCrowBar]) return SendClientMessageEx(playerid, COLOR_WHITE, "You need a Crow Bar in order to crack this trunk, get one from a Craftsman.");
	if(!PlayerInfo[playerid][pScrewdriver]) return SendClientMessageEx(playerid, COLOR_WHITE, "You need a Screwdriver in order to lock pick a vehicle, get one from a Craftsman.");
	if(GetPVarType(playerid, "TrunkAlreadyCracked")) return SendClientMessageEx(playerid, COLOR_WHITE, "You already cracked the trunk of this vehicle.");
	
	if(GetPVarType(playerid, "PlayerCuffed") || GetPVarInt(playerid, "pBagged") >= 1 || GetPVarType(playerid, "Injured") || GetPVarType(playerid, "IsFrozen") || GetPVarType(playerid, "IsInArena")  || GetPVarInt( playerid, "EventToken") || IsPlayerInAnyVehicle(playerid) || HungerPlayerInfo[playerid][hgInEvent])
		return SendClientMessage(playerid, COLOR_GRAD2, "You can't do that at this time!");
		
		
	new vehicleid = GetClosestCar(playerid);
	
	GetPosBehindVehicle(vehicleid, x, y, z, 1.0);
	if(IsPlayerInRangeOfPoint(playerid, 1.0, x, y, z) && GetPVarInt(playerid, "LockPickVehicle") == vehicleid) {
		if(GetPVarType(playerid, "AttemptingCrackTrunk")) return SendClientMessageEx(playerid, COLOR_WHITE, "You are already attempting to crack a trunk, please wait for the trunk to be opened.");
		if(!GetPVarType(playerid, "DeliveringVehicleTime")) return SendClientMessageEx(playerid, COLOR_WHITE, "You can't open this trunk yet.");
		new status, randskill = random(100);
		switch(PlayerInfo[playerid][pCarLockPickSkill]) {
			case 0 .. 49: if(0 <= randskill < 25) status = 1; //Success
			case 50 .. 124: if(0 <= randskill < 35) status = 1; //Success
			case 125 .. 224: if(0 <= randskill < 45)status = 1; //Success
			case 225 .. 349: if(0 <= randskill < 55) status = 1; //Success
			default: if(0 <= randskill < 65) status = 1; //Success
		}
		format(szMessage, sizeof(szMessage), "* %s is attempting to crack the vehicle's trunk with his crowbar.", GetPlayerNameEx(playerid));
		ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		PlayerInfo[playerid][pLockPickTime] = gettime() + 10;
		if(status) {
			SetPVarInt(playerid, "AttemptingCrackTrunk", 1);
			SetPVarInt(playerid, "CrackTrunkCountdown", 60);
			
			SendClientMessageEx(playerid, COLOR_PURPLE, "(( You're now cracking this vehicle's trunk with your crowbar, please wait. /stopcracking ))");
			SendClientMessageEx(playerid, COLOR_YELLOW, "Warning{FFFFFF}: Please stay still, if you move or get shot you may fail cracking this vehicle trunk.");
			ShowVLPTextDraws(playerid, vehicleid, 1);
			GetVehicleZAngle(vehicleid, z);
			SetPlayerFacingAngle(playerid, z);
			ApplyAnimation(playerid, "COP_AMBIENT", "Copbrowse_loop", 4.1, 1, 0, 0, 0, 0, 1);
			if(GetPVarType(playerid, "LockPickVehicleSQLId")) {
				new ip[MAX_PLAYER_NAME];
				GetPlayerIp(playerid, ip, sizeof(ip));
				format(szMessage, sizeof(szMessage), "[LOCK PICK] %s(%d) (IP:%s) is attempting to crack trunk a %s(VID:%d SQLId: %d) owned by %s(Offline SQLId: %d)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ip, GetVehicleName(GetPVarInt(playerid, "LockPickVehicle")), GetPVarInt(playerid, "LockPickVehicle"), GetPVarInt(playerid, "LockPickVehicleSQLId"), GetPlayerNameEx(GetPVarInt(playerid, "LockPickPlayer")), GetPVarInt(playerid, "LockPickPlayerSQLId"));
				Log("logs/playervehicle.log", szMessage);
			}
			else {
				new ip[MAX_PLAYER_NAME], ip2[MAX_PLAYER_NAME], v = GetPlayerVehicle(GetPVarInt(playerid, "LockPickPlayer"), GetPVarInt(playerid, "LockPickVehicle"));
				GetPlayerIp(playerid, ip, sizeof(ip));
				GetPlayerIp(GetPVarInt(playerid, "LockPickPlayer"), ip2, sizeof(ip2));
				format(szMessage, sizeof(szMessage), "[LOCK PICK] %s(%d) (IP:%s) is attempting to crack trunk a %s(VID:%d Slot %d) owned by %s(IP:%s SQLId: %d)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ip, GetVehicleName(PlayerVehicleInfo[GetPVarInt(playerid, "LockPickPlayer")][v][pvId]), PlayerVehicleInfo[GetPVarInt(playerid, "LockPickPlayer")][v][pvId], v, GetPlayerNameEx(GetPVarInt(playerid, "LockPickPlayer")), ip2, GetPlayerSQLId(GetPVarInt(playerid, "LockPickPlayer")));
				Log("logs/playervehicle.log", szMessage);
			}
		}
		else {
			SendClientMessageEx(playerid, COLOR_PURPLE, "(( Your attempt to crack this vehicle's trunk failed! Try again or move on. ))");
		}
	}
	else {
		return SendClientMessageEx(playerid, COLOR_WHITE, "You need to be at the back of the car that you lock picked.");
	}*/
	SendClientMessageEx(playerid, COLOR_WHITE, "This command has been disabled temporaly disabled due to an unknown issue.");
	SendClientMessageEx(playerid, COLOR_WHITE, "Please do not report about this being disabled, we are testing something.");
	return 1;
}

CMD:stoplockpick(playerid, params[])
{
	if(GetPVarType(playerid, "AttemptingLockPick")) {
		DeletePVar(playerid, "AttemptingLockPick");
		DeletePVar(playerid, "LockPickCountdown");
		DeletePVar(playerid, "LockPickTotalTime");
		if(GetPVarType(playerid, "LockPickVehicleSQLId")) {
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
		DeletePVar(playerid, "LockPickVehicle");
		DeletePVar(playerid, "LockPickPlayer");
		DestroyVLPTextDraws(playerid);
		ClearAnimationsEx(playerid, 1);
		SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully prevented yourself from this lock pick.");
	}
	return 1;
}

CMD:stopcracking(playerid, params[])
{
	if(GetPVarType(playerid, "AttemptingCrackTrunk")) {
		DeletePVar(playerid, "AttemptingCrackTrunk");
		DeletePVar(playerid, "CrackTrunkCountdown");
		DestroyVLPTextDraws(playerid);
		ClearAnimationsEx(playerid, 1);
		SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully prevented yourself from this lock pick.");
	}
	return 1;
}

DeliverVehicleTimer(i)
{
	szMiscArray[0] = 0;
	if(GetPVarType(i, "DeliveringVehicleTime")) {
		new Float: x,
			Float: y,
			Float: z,
			int = GetPlayerInterior(i),
			ownerid = GetPVarInt(i, "LockPickPlayer");
		GetVehiclePos(GetPVarInt(i, "LockPickVehicle"), x, y, z);
		if(GetPVarInt(i, "DeliveringVehicleTime") < gettime() || !IsPlayerInRangeOfPoint(i, 50.0, x, y, z) && int == 0) {
			SendClientMessageEx(i, COLOR_YELLOW, "You failed to deliver the vehicle, the vehicle has been restored.");
			if(GetPVarType(i, "LockPickVehicleSQLId")) 
			{
				mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "UPDATE `vehicles` SET `pvFuel` = %0.5f WHERE `id` = '%d' AND `sqlID` = '%d'", VehicleFuel[GetPVarInt(i, "LockPickVehicle")], GetPVarInt(i, "LockPickVehicleSQLId"), GetPVarInt(i, "LockPickPlayerSQLId"));
				mysql_tquery(MainPipeline, szMiscArray, "OnQueryFinish", "ii", SENDDATA_THREAD, i);
				DeletePVar(i, "LockPickVehicleSQLId");
				DeletePVar(i, "LockPickPlayerSQLId");
				DeletePVar(i, "LockPickPlayerName");
			}
			else {
				new slot = GetPlayerVehicle(GetPVarInt(i, "LockPickPlayer"), GetPVarInt(i, "LockPickVehicle"));
				--PlayerCars;
				VehicleSpawned[ownerid]--;
				PlayerVehicleInfo[ownerid][slot][pvBeingPickLocked] = 0;
				PlayerVehicleInfo[ownerid][slot][pvBeingPickLockedBy] = INVALID_PLAYER_ID;
				PlayerVehicleInfo[ownerid][slot][pvAlarmTriggered] = 0;
				PlayerVehicleInfo[ownerid][slot][pvSpawned] = 0;
				PlayerVehicleInfo[ownerid][slot][pvFuel] = VehicleFuel[GetPVarInt(i, "LockPickVehicle")];
				GetVehicleHealth(PlayerVehicleInfo[ownerid][slot][pvId], PlayerVehicleInfo[ownerid][slot][pvHealth]);
				PlayerVehicleInfo[ownerid][slot][pvId] = INVALID_PLAYER_VEHICLE_ID;
				g_mysql_SaveVehicle(ownerid, slot);
			}
			
			DestroyVehicle(GetPVarInt(i, "LockPickVehicle"));
			
			DisablePlayerCheckpoint(i);
			DeletePVar(i, "DeliveringVehicleTime");
			DeletePVar(i, "LockPickVehicle");
			DeletePVar(i, "LockPickPlayer");
		}
	}
}