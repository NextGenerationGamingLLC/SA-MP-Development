/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Vehicle Functions

				Next Generation Gaming, LLC
	(created by Next Generation Gaming Development Team)
					
	* Copyright (c) 2014, Next Generation Gaming, LLC
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

CMD:carhelp(playerid, params[])
{
    SendClientMessageEx(playerid, COLOR_GREEN,"_______________________________________");
    SendClientMessageEx(playerid, COLOR_WHITE,"*** CAR OWNERSHIP HELP *** - type a command for more infomation.");
    SendClientMessageEx(playerid, COLOR_GRAD3,"*** CAR OWNERSHIP *** /lock /pvlock /park /parktrailer /unmodcar /deletecar /sellmycar /trackcar");
    SendClientMessageEx(playerid, COLOR_GRAD3,"*** CAR OWNERSHIP *** /dmvmenu /givekeys /carkeys /trunkput /trunktake /car /refuel");
    return 1;
}

CMD:car(playerid, params[])
{
	new string[128];
	if(isnull(params))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /car [name]");
		SendClientMessageEx(playerid, COLOR_GREY, "Available names: Status, Engine, Lights, Trunk, Hood, Fuel, Windows");
		return 1;
	}
	if(strcmp(params, "engine", true) == 0 && IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		new engine,lights,alarm,doors,bonnet,boot,objective,vehicleid;
		vehicleid = GetPlayerVehicleID(playerid);
		if(GetVehicleModel(vehicleid) == 481 || GetVehicleModel(vehicleid) == 509 || GetVehicleModel(vehicleid) == 510 || DynVeh[vehicleid] != -1 && DynVehicleInfo[DynVeh[vehicleid]][gv_iType] == 1 && GetVehicleModel(vehicleid) == 592) return SendClientMessageEx(playerid,COLOR_WHITE,"This command can't be used in this vehicle.");
		if(WheelClamp{vehicleid}) return SendClientMessageEx(playerid,COLOR_WHITE,"(( This vehicle has a wheel camp on its front tire, you will not be able to drive away with it. ))");

		GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
		if(engine == VEHICLE_PARAMS_ON)
		{
			SetVehicleEngine(vehicleid, playerid);
			format(string, sizeof(string), "{FF8000}** {C2A2DA}%s turns the key in the ignition and the engine stops.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		}
		else if((engine == VEHICLE_PARAMS_OFF || engine == VEHICLE_PARAMS_UNSET))
		{
			if (GetPVarInt(playerid, "Refueling")) return SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this while refueling.");
			format(string, sizeof(string), "{FF8000}** {C2A2DA}%s turns the key in the ignition and the engine starts.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			SendClientMessageEx(playerid, COLOR_WHITE, "Vehicle engine starting, please wait...");
			SetTimerEx("SetVehicleEngine", 1000, 0, "dd",  vehicleid, playerid);
		}
	}
	else if(strcmp(params, "lights", true) == 0 && IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(GetVehicleModel(vehicleid) == 481 || GetVehicleModel(vehicleid) == 509 || GetVehicleModel(vehicleid) == 510) return SendClientMessageEx(playerid,COLOR_WHITE,"This command can't be used in this vehicle.");
		SetVehicleLights(vehicleid, playerid);
	}
	else if(strcmp(params, "hood", true) == 0 && IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			new vehicleid = GetPlayerVehicleID(playerid);
			if(GetVehicleModel(vehicleid) == 481 || GetVehicleModel(vehicleid) == 509 || GetVehicleModel(vehicleid) == 510 || IsAPlane(vehicleid) || IsABike(vehicleid))
			{
				return SendClientMessageEx(playerid,COLOR_WHITE,"This command can't be used in this vehicle.");
			}
			SetVehicleHood(vehicleid, playerid);
		}
		else if(!IsPlayerInAnyVehicle(playerid))
		{
			new closestcar = GetClosestCar(playerid);
			if(IsPlayerInRangeOfVehicle(playerid, closestcar, 5.0))
			{
				if(GetVehicleModel(closestcar) == 481 || GetVehicleModel(closestcar) == 509 || GetVehicleModel(closestcar) == 510 || IsAPlane(closestcar) || IsABike(closestcar))
				{
					return SendClientMessageEx(playerid,COLOR_WHITE,"This command can't be used on this vehicle.");
				}
				SetVehicleHood(closestcar, playerid);
			}
		}
	}
	else if(strcmp(params, "trunk", true) == 0)
  	{
		if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			new vehicleid = GetPlayerVehicleID(playerid);
			if(GetVehicleModel(vehicleid) == 481 || GetVehicleModel(vehicleid) == 509 || GetVehicleModel(vehicleid) == 510)
			{
				return SendClientMessageEx(playerid,COLOR_WHITE,"This command can't be used in this vehicle.");
			}
			SetVehicleTrunk(vehicleid, playerid);
		}
		else if(!IsPlayerInAnyVehicle(playerid))
		{
			new closestcar = GetClosestCar(playerid);
			if(IsPlayerInRangeOfVehicle(playerid, closestcar, 5.0))
			{
				if(GetVehicleModel(closestcar) == 481 || GetVehicleModel(closestcar) == 509 || GetVehicleModel(closestcar) == 510)
				{
					return SendClientMessageEx(playerid,COLOR_WHITE,"This command can't be used on this vehicle.");
				}
				SetVehicleTrunk(closestcar, playerid);
			}
		}
	}
	else if(strcmp(params, "fuel", true) == 0 && IsPlayerInAnyVehicle(playerid))
	{
		if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			new vehicleid = GetPlayerVehicleID(playerid);
			new engine,lights,alarm,doors,bonnet,boot,objective,enginestatus[4],lightstatus[4];
			GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
			if(!IsRefuelableVehicle(vehicleid)) return SendClientMessageEx(playerid,COLOR_RED,"This vehicle doesn't need fuel.");
			if(engine != VEHICLE_PARAMS_ON) strcpy(enginestatus, "OFF", 4);
			else strcpy(enginestatus, "ON", 3);
			if(lights != VEHICLE_PARAMS_ON) strcpy(lightstatus, "OFF", 4);
			else strcpy(lightstatus, "ON", 3);

			if (IsVIPcar(vehicleid) || IsAdminSpawnedVehicle(vehicleid) || IsFamedVeh(vehicleid)) format(string, sizeof(string), "Engine: %s | Lights: %s | Fuel: Unlimited",enginestatus,lightstatus);
			else format(string, sizeof(string), "Engine: %s | Lights: %s | Fuel: %.1f%s",enginestatus,lightstatus, VehicleFuel[vehicleid], "%");
			SendClientMessageEx(playerid, COLOR_WHITE, string);
		}
	}
	else if(strcmp(params, "status", true) == 0)
	{
		if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			new vehicleid = GetPlayerVehicleID(playerid), slot = GetPlayerVehicle(playerid, vehicleid);
			new engine,lights,alarm,doors,bonnet,boot,objective,enginestatus[4],lightstatus[4];
			GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
			if(!IsRefuelableVehicle(vehicleid)) return SendClientMessageEx(playerid,COLOR_RED,"This vehicle doesn't need fuel.");
			if(engine != VEHICLE_PARAMS_ON) strcpy(enginestatus, "OFF", 4);
			else strcpy(enginestatus, "ON", 3);
			if(lights != VEHICLE_PARAMS_ON) strcpy(lightstatus, "OFF", 4);
			else strcpy(lightstatus, "ON", 3);
			if (IsVIPcar(vehicleid) || IsAdminSpawnedVehicle(vehicleid) || IsFamedVeh(vehicleid)) format(string, sizeof(string), "Engine: %s | Lights: %s | Fuel: Unlimited | Windows: %s",enginestatus,lightstatus,(CrateVehicleLoad[GetPlayerVehicleID(playerid)][vCarWindows] == 0) ? ("Up") : ("Down"));
			else if(slot != -1) format(string, sizeof(string), "Engine: %s | Lights: %s | Fuel: %.1f percent | Windows: %s | Lock Durability: %d/5",enginestatus,lightstatus, VehicleFuel[vehicleid], (CrateVehicleLoad[GetPlayerVehicleID(playerid)][vCarWindows] == 0) ? ("Up") : ("Down"), PlayerVehicleInfo[playerid][slot][pvLocksLeft]);
			else format(string, sizeof(string), "Engine: %s | Lights: %s | Fuel: %.1f percent | Windows: %s",enginestatus,lightstatus, VehicleFuel[vehicleid], (CrateVehicleLoad[GetPlayerVehicleID(playerid)][vCarWindows] == 0) ? ("Up") : ("Down"));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
		}
	}
	else if(strcmp(params, "windows", true) == 0 && IsPlayerInAnyVehicle(playerid) && !IsABike(GetPlayerVehicleID(playerid)) && !IsABoat(GetPlayerVehicleID(playerid)))
	{
	    if(CrateVehicleLoad[GetPlayerVehicleID(playerid)][vCarWindows])
	    {
	    	CrateVehicleLoad[GetPlayerVehicleID(playerid)][vCarWindows] = 0;
			format(string, sizeof(string), "{FF8000}** {C2A2DA}%s winds their windows up.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	    }
	    else {
            CrateVehicleLoad[GetPlayerVehicleID(playerid)][vCarWindows] = 1;
			format(string, sizeof(string), "{FF8000}** {C2A2DA}%s winds their windows down.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	    }
	}
	return 1;
}

CMD:window(playerid, params[])
{
	new string[128];
    if(InsidePlane[playerid] != INVALID_VEHICLE_ID && GetPVarInt(playerid, "InsideCar") ==0)
	{
        if(GetPlayerInterior(playerid) != 0)
		{
            new
                Float: fSpecPos[6];

            GetPlayerPos(playerid, fSpecPos[0], fSpecPos[1], fSpecPos[2]);
            GetPlayerFacingAngle(playerid, fSpecPos[3]);
            GetPlayerHealth(playerid, fSpecPos[4]);
            GetPlayerArmour(playerid, fSpecPos[5]);

            SetPVarFloat(playerid, "air_Xpos", fSpecPos[0]);
            SetPVarFloat(playerid, "air_Ypos", fSpecPos[1]);
            SetPVarFloat(playerid, "air_Zpos", fSpecPos[2]);
            SetPVarFloat(playerid, "air_Rpos", fSpecPos[3]);
            SetPVarFloat(playerid, "air_HP", fSpecPos[4]);
            SetPVarFloat(playerid, "air_Arm", fSpecPos[5]);
            SetPVarInt(playerid, "air_Int", GetPlayerInterior(playerid));
            SetPVarInt(playerid, "air_Mode", 1);

            SetPlayerInterior(playerid, 0);
            SetPlayerVirtualWorld(playerid, 0);
            TogglePlayerSpectating(playerid, 1);
            PlayerSpectateVehicle(playerid, InsidePlane[playerid]);

            format(string, sizeof(string), "* %s glances out the window.", GetPlayerNameEx(playerid));
            ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
        }
        else TogglePlayerSpectating(playerid, 0);
    }
    return 1;
}

CMD:lock(playerid, params[])
{
   	if(PlayerInfo[playerid][pLock] == 1)
	{
 		if(IsPlayerInAnyVehicle(playerid))
   		{
			if(PlayerInfo[playerid][pLockCar] != GetPlayerVehicleID(playerid) && PlayerInfo[playerid][pLockCar] != INVALID_VEHICLE_ID) return SendClientMessageEx(playerid, COLOR_GRAD2, "You don't have a lock for this vehicle!");
   			if(GetPlayerVehicleSeat(playerid) != 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "Can't lock vehicles as a passenger!");
   			new v = -1;
   			//foreach(new i: Player)
			for(new i = 0; i < MAX_PLAYERS; ++i)
			{
				if(IsPlayerConnected(i))
				{
					v = GetPlayerVehicle(i, GetPlayerVehicleID(playerid));
					if(v != -1) return SendClientMessageEx(playerid, COLOR_GRAD2, "Can't lock player-owned vehicles!");
				}	
			}
   			if(PlayerInfo[playerid][pLockCar] == INVALID_VEHICLE_ID) PlayerInfo[playerid][pLockCar] = GetPlayerVehicleID(playerid);
      		if(LockStatus{GetPlayerVehicleID(playerid)} == 0)
        	{
				LockStatus{GetPlayerVehicleID(playerid)} = 1;
    			GameTextForPlayer(playerid, "~r~locked", 1000, 6);
       			PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
          		vehicle_lock_doors(PlayerInfo[playerid][pLockCar]);
      		}
        	else
	        {
				LockStatus{GetPlayerVehicleID(playerid)} = 0;
   				vehicle_unlock_doors(PlayerInfo[playerid][pLockCar]);
      			GameTextForPlayer(playerid, "~g~unlocked", 1000, 6);
        		PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
 	        }
   		}
	    else
	    {
     		new Float: x, Float: y, Float: z;
       		GetVehiclePos(PlayerInfo[playerid][pLockCar], x, y, z);
        	if(IsPlayerInRangeOfPoint(playerid, 4.0, x, y, z))
        	{
         		if(LockStatus{PlayerInfo[playerid][pLockCar]} == 0)
           		{
            		vehicle_lock_doors(PlayerInfo[playerid][pLockCar]);
            		GameTextForPlayer(playerid, "~r~locked", 1000, 6);
	            	PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
 	            }
 	            else
 	            {
	            	vehicle_unlock_doors(PlayerInfo[playerid][pLockCar]);
	            	GameTextForPlayer(playerid, "~g~unlocked", 1000, 6);
	            	PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
          		}
   	        }
   	        else
   	        {
            	SendClientMessageEx(playerid, COLOR_GRAD2, "You are not near your vehicle!");
	            return 1;
   	        }
       	}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, " You do not have a lock!");
		return 1;
 	}
	return 1;
}

CMD:vstorage(playerid, params[])
{
	if(PlayerTied[playerid] != 0 || PlayerCuffed[playerid] != 0 || PlayerInfo[playerid][pJailTime] > 0 || GetPVarInt(playerid, "Injured")) return SendClientMessageEx(playerid, COLOR_GRAD2, "You cannot do this at this time.");
	if(PlayerInfo[playerid][pFreezeCar] == 0 || PlayerInfo[playerid][pAdmin] >= 2)
	{
		new vstring[4096], icount = GetPlayerVehicleSlots(playerid);
		new szCarLocation[MAX_ZONE_NAME];
		for(new i, iModelID; i < icount; i++)
		{
			if((iModelID = PlayerVehicleInfo[playerid][i][pvModelId] - 400) >= 0) 
			{
				Get3DZone(PlayerVehicleInfo[playerid][i][pvPosX], PlayerVehicleInfo[playerid][i][pvPosY], PlayerVehicleInfo[playerid][i][pvPosZ], szCarLocation, sizeof(szCarLocation));
				if(PlayerVehicleInfo[playerid][i][pvImpounded]) {
					format(vstring, sizeof(vstring), "%s\n%s (impounded) | Location: DMV", vstring, VehicleName[iModelID]);
				}
				else if(PlayerVehicleInfo[playerid][i][pvDisabled]) {
					format(vstring, sizeof(vstring), "%s\n%s (disabled) | Location: Unknown", vstring, VehicleName[iModelID]);
				}
				else if(!PlayerVehicleInfo[playerid][i][pvSpawned]) {
					format(vstring, sizeof(vstring), "%s\n%s (stored)", vstring, VehicleName[iModelID]);
				}
				else format(vstring, sizeof(vstring), "%s\n%s (spawned) | Location: %s", vstring, VehicleName[iModelID], szCarLocation);
			}
			else strcat(vstring, "\nEmpty");
		}
		format(vstring, sizeof(vstring), "%s\n{40FFFF}Additional Vehicle Slot {FFD700}(Credits: %s){A9C4E4}", vstring, number_format(ShopItems[23][sItemPrice]));
		ShowPlayerDialog(playerid, VEHICLESTORAGE, DIALOG_STYLE_LIST, "Vehicle storage", vstring, "(De)spawn", "Cancel");
	}
	else { return SendClientMessageEx(playerid, COLOR_GRAD2, "Your vehicle assets have been frozen by the Judiciary.  Consult your local courthouse to have this cleared"); }
	return 1;
}

CMD:trackcar(playerid, params[])
{
    if(GetPVarType(playerid, "RentedVehicle")) {
        ShowPlayerDialog(playerid, TRACKCAR2, DIALOG_STYLE_LIST, "Vehicle GPS Tracking", "Rented Vehicle\nOwned Vehicles", "Track", "Cancel");
	}
	else
	{
		new vstring[4096], icount = GetPlayerVehicleSlots(playerid);
		new szCarLocation[MAX_ZONE_NAME];
		for(new i, iModelID; i < icount; i++) 
		{
			if((iModelID = PlayerVehicleInfo[playerid][i][pvModelId] - 400) >= 0)
			{
				Get3DZone(PlayerVehicleInfo[playerid][i][pvPosX], PlayerVehicleInfo[playerid][i][pvPosY], PlayerVehicleInfo[playerid][i][pvPosZ], szCarLocation, sizeof(szCarLocation));
				if(PlayerVehicleInfo[playerid][i][pvImpounded]) {
					format(vstring, sizeof(vstring), "%s\n%s (impounded) | Location: DMV", vstring, VehicleName[iModelID]);
				}
				else if(PlayerVehicleInfo[playerid][i][pvDisabled]) {
					format(vstring, sizeof(vstring), "%s\n%s (disabled) | Location: Unknown", vstring, VehicleName[iModelID]);
				}
				else if(!PlayerVehicleInfo[playerid][i][pvSpawned]) {
					format(vstring, sizeof(vstring), "%s\n%s (stored)", vstring, VehicleName[iModelID]);
				}
				else format(vstring, sizeof(vstring), "%s\n%s | Location: %s", vstring, VehicleName[iModelID], szCarLocation);
			}
		}
		ShowPlayerDialog(playerid, TRACKCAR, DIALOG_STYLE_LIST, "Vehicle GPS Tracking", vstring, "Track", "Cancel");
	}
	return 1;
}

CMD:unmodcar(playerid, params[]) {
	for(new d = 0; d < MAX_PLAYERVEHICLES; d++) if(IsPlayerInVehicle(playerid, PlayerVehicleInfo[playerid][d][pvId])) {
		new modList[512], string[16];
		new count = 0;
		for(new f = 0; f < MAX_MODS; f++) if(GetVehicleComponentInSlot(PlayerVehicleInfo[playerid][d][pvId], f) != 0) {
			if(f != 9 && f != 7 && f != 8) {
				format(modList, sizeof(modList), "%s\n%s - %s", modList, partType(f), partName(GetVehicleComponentInSlot(PlayerVehicleInfo[playerid][d][pvId], f)));
			}
			else format(modList, sizeof(modList), "%s\n%s", modList, partType(f));

			format(string, sizeof(string), "partList%d", count);
			SetPVarInt(playerid, string, GetVehicleComponentInSlot(PlayerVehicleInfo[playerid][d][pvId], f));
			count++;
		}
		if (count == 0)
		{
			SendClientMessageEx(playerid, COLOR_GREY, " This vehicle does not have any modifications.");
			return 1;
		}
		format(modList, sizeof(modList), "%s\nAll", modList);
		format(string, sizeof(string), "partList%d", count);
		SetPVarInt(playerid, string, 999);
		count++;
		SetPVarInt(playerid, "modCount", count);
		return ShowPlayerDialog(playerid, UNMODCARMENU, DIALOG_STYLE_LIST, "Remove Modifications", modList, "Select", "Cancel");
	}
	SendClientMessageEx(playerid, COLOR_GREY, " You need to be inside a vehicle that you own.");
 	return 1;
}

CMD:deletecar(playerid, params[])
{
	new vstring[1024], icount = GetPlayerVehicleSlots(playerid);
	for(new i, iModelID; i < icount; i++) {
		if((iModelID = PlayerVehicleInfo[playerid][i][pvModelId] - 400) >= 0)
		{
			if(PlayerVehicleInfo[playerid][i][pvImpounded]) format(vstring, sizeof(vstring), "%s\n%s (impounded)", vstring, VehicleName[iModelID]);
			else if(PlayerVehicleInfo[playerid][i][pvDisabled]) format(vstring, sizeof(vstring), "%s\n%s (disabled)", vstring, VehicleName[iModelID]);
			else if(!PlayerVehicleInfo[playerid][i][pvSpawned]) format(vstring, sizeof(vstring), "%s\n%s (stored)", vstring, VehicleName[iModelID]);
			else format(vstring, sizeof(vstring), "%s\n%s", vstring, VehicleName[iModelID]);
		}
		else strcat(vstring, "\nEmpty");
	}
	return ShowPlayerDialog(playerid, DIALOG_DELETECAR, DIALOG_STYLE_LIST, "Delete Vehicle", vstring, "Delete", "Cancel");
}

CMD:parktrailer(playerid, params[]) {
	for(new i = 0, Float: fVehiclePos[4], iVehicleID; i != MAX_PLAYERVEHICLES; ++i) switch(GetVehicleModel((iVehicleID = PlayerVehicleInfo[playerid][i][pvId]))) {
		case 435, 450, 584, 591, 606, 607, 608, 610, 611: {
			GetVehiclePos(iVehicleID, fVehiclePos[0], fVehiclePos[1], fVehiclePos[2]);
			if(IsPlayerInRangeOfPoint(playerid, 10.0, fVehiclePos[0], fVehiclePos[1], fVehiclePos[2])) {

				new
					szMessage[64];

				GetVehicleZAngle(iVehicleID, fVehiclePos[3]);
				UpdatePlayerVehicleParkPosition(playerid, i, fVehiclePos[0], fVehiclePos[1], fVehiclePos[2], fVehiclePos[3], 1000.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));

				format(szMessage, sizeof szMessage, "* %s has parked their trailer.", GetPlayerNameEx(playerid));
				return ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
			}
		}
	}
	return 1;
}

CMD:park(playerid, params[])
{
	new
		iVehicle = GetPlayerVehicleID(playerid),
		iBusiness = GetCarBusiness(iVehicle),
		Float: XYZ[4];

    if(iVehicle == GetPVarInt(playerid, "RentedVehicle"))
	{
	    new Float:x, Float:y, Float:z, Float:health;
		GetVehicleHealth(iVehicle, health);
  		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessageEx(playerid, COLOR_GREY, "You must be in the driver seat.");
		if(health < 800) return SendClientMessageEx(playerid, COLOR_GREY, " Your vehicle is too damaged to park it.");
		if(PlayerInfo[playerid][pLockCar] == GetPlayerVehicleID(playerid)) PlayerInfo[playerid][pLockCar] = INVALID_VEHICLE_ID;
		GetPlayerPos(playerid, x, y, z);

		SetTimerEx("ParkRentedVehicle", 1000, false, "iiifff", playerid, iVehicle, GetVehicleModel(iVehicle), x, y, z);
		SendClientMessageEx (playerid, COLOR_YELLOW, "Do not move to have your vehicle parked!");
		return 1;
	}
	if (iVehicle != 0 && iBusiness != INVALID_BUSINESS_ID)
	{
	 	if (iBusiness != PlayerInfo[playerid][pBusiness]) return SendClientMessageEx(playerid, COLOR_WHITE, "You're not authorized to park this vehicle.");
		new
			iSlot = GetBusinessCarSlot(iVehicle);

		GetVehiclePos(iVehicle, XYZ[0], XYZ[1], XYZ[2]);
		GetVehicleZAngle(iVehicle, XYZ[3]);

		Businesses[iBusiness][bParkPosX][iSlot] = XYZ[0];
		Businesses[iBusiness][bParkPosY][iSlot] = XYZ[1];
		Businesses[iBusiness][bParkPosZ][iSlot] = XYZ[2];
		Businesses[iBusiness][bParkAngle][iSlot] = XYZ[3];

		DestroyVehicle(Businesses[iBusiness][bVehID][iSlot]);
		Businesses[iBusiness][bVehID][iSlot] = CreateVehicle(Businesses[iBusiness][bModel][iSlot], Businesses[iBusiness][bParkPosX][iSlot], Businesses[iBusiness][bParkPosY][iSlot], Businesses[iBusiness][bParkPosZ][iSlot],
		Businesses[iBusiness][bParkAngle][iSlot], 0, 0, -1);

        SaveDealershipVehicle(iBusiness, iSlot);
		SendClientMessageEx(playerid, COLOR_WHITE, "You've parked this vehicle.");
		return 1;
	}

	if(PlayerInfo[playerid][pVehicleKeysFrom] != INVALID_PLAYER_ID)
	{
		new ownerid = PlayerInfo[playerid][pVehicleKeysFrom];
		if(IsPlayerConnected(ownerid))
		{
			new d = PlayerInfo[playerid][pVehicleKeys];
			if(IsPlayerInVehicle(playerid, PlayerVehicleInfo[ownerid][d][pvId]))
			{
				if(PlayerVehicleInfo[ownerid][d][pvBeingPickLocked] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot park this vehicle at the moment.");
			    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessageEx(playerid, COLOR_GREY, "You must be in the driver seat.");
				new Float:x, Float:y, Float:z, Float:health;
				GetVehicleHealth(PlayerVehicleInfo[ownerid][d][pvId], health);
				if(health < 800) return SendClientMessageEx(playerid, COLOR_GREY, " Your vehicle is too damaged to park it.");
				if(PlayerInfo[playerid][pLockCar] == GetPlayerVehicleID(playerid)) PlayerInfo[playerid][pLockCar] = INVALID_VEHICLE_ID;

                GetPlayerPos(playerid, x, y, z);
                SetTimerEx("ParkVehicle", 1000, false, "iiiifff", playerid, ownerid, PlayerVehicleInfo[ownerid][d][pvId], d, x, y, z);
                SendClientMessageEx (playerid, COLOR_YELLOW, "Do not move to have your vehicle parked!");
				return 1;
			}
		}
	}
	for(new d = 0 ; d < MAX_PLAYERVEHICLES; d++)
	{
		if(IsPlayerInVehicle(playerid, PlayerVehicleInfo[playerid][d][pvId]))
		{
			if(PlayerVehicleInfo[playerid][d][pvBeingPickLocked] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot park this vehicle at the moment.");
			if(WheelClamp{PlayerVehicleInfo[playerid][d][pvId]}) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot park this vehicle at the moment.");
			new Float:x, Float:y, Float:z, Float:health;
			GetVehicleHealth(PlayerVehicleInfo[playerid][d][pvId], health);
            if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessageEx(playerid, COLOR_GREY, "You must be in the driver seat.");
			if(health < 800) return SendClientMessageEx(playerid, COLOR_GREY, " Your vehicle is too damaged to park it.");
			if(PlayerInfo[playerid][pLockCar] == GetPlayerVehicleID(playerid)) PlayerInfo[playerid][pLockCar] = INVALID_VEHICLE_ID;
			GetPlayerPos(playerid, x, y, z);

   			SetTimerEx("ParkVehicle", 1000, false, "iiiifff", playerid, INVALID_PLAYER_ID, PlayerVehicleInfo[playerid][d][pvId], d, x, y, z);
      		SendClientMessageEx (playerid, COLOR_YELLOW, "Do not move to have your vehicle parked!");
			return 1;
		}
	}
	SendClientMessageEx(playerid, COLOR_GREY, "You need to be inside a vehicle that you own.");
	return 1;
}

CMD:carkeys(playerid, params[])
{
    new vstring[4096], iValidVehicles;
	for(new i=0; i<MAX_PLAYERVEHICLES; i++)
	{
	    if(PlayerVehicleInfo[playerid][i][pvId] != INVALID_PLAYER_VEHICLE_ID) {
	        if(PlayerVehicleInfo[playerid][i][pvAllowedPlayerId] != INVALID_PLAYER_ID) {
				format(vstring, sizeof(vstring), "%s\n%s | Keys: %s", vstring, VehicleName[PlayerVehicleInfo[playerid][i][pvModelId] - 400], GetPlayerNameEx(PlayerVehicleInfo[playerid][i][pvAllowedPlayerId])), ++iValidVehicles;
			}
			else {
                format(vstring, sizeof(vstring), "%s\n%s | Keys: No-one", vstring, VehicleName[PlayerVehicleInfo[playerid][i][pvModelId] - 400]);
			}
		}
        else if((PlayerVehicleInfo[playerid][i][pvImpounded] == 1 || PlayerVehicleInfo[playerid][i][pvSpawned] == 0) && PlayerVehicleInfo[playerid][i][pvModelId] != 0) {
            format(vstring, sizeof(vstring), "%s\n%s | Keys: Unavailable", vstring, VehicleName[PlayerVehicleInfo[playerid][i][pvModelId] - 400]);
		}
        else {
			format(vstring, sizeof(vstring), "%s\nEmpty", vstring);
		}
	}
	if(iValidVehicles != 0)
	{
		ShowPlayerDialog(playerid, REMOVEKEYS, DIALOG_STYLE_LIST, "Please select a vehicle.", vstring, "Remove Keys", "Cancel");
	}
	else
	{
	    SendClientMessageEx(playerid, COLOR_GRAD2, "You don't have any keys given out.");
	}
	return 1;
}

CMD:sb(playerid, params[]) return cmd_seatbelt(playerid, params);

CMD:seatbelt(playerid, params[])
{
    if(IsPlayerInAnyVehicle(playerid) == 0)
	{
        SendClientMessageEx(playerid, COLOR_GRAD2, "You are not in a vehicle!");
        return 1;
    }
	new string[60 + MAX_PLAYER_NAME];
    if(IsPlayerInAnyVehicle(playerid) == 1 && Seatbelt[playerid] == 0)
	{
        Seatbelt[playerid] = 1;
        if(IsABike(GetPlayerVehicleID(playerid)))
		{
            format(string, sizeof(string), "{FF8000}** {C2A2DA}%s reaches for their helmet, and puts it on.", GetPlayerNameEx(playerid));
            SendClientMessageEx(playerid, COLOR_WHITE, "You have put on your helmet.");
        }
        else
		{
            format(string, sizeof(string), "{FF8000}** {C2A2DA}%s reaches for their seatbelt, and buckles it up.", GetPlayerNameEx(playerid));
            SendClientMessageEx(playerid, COLOR_WHITE, "You have put on your seatbelt.");
        }

    }
    else if(IsPlayerInAnyVehicle(playerid) == 1 && Seatbelt[playerid] == 1)
	{
        Seatbelt[playerid] = 0;
        if(IsABike(GetPlayerVehicleID(playerid)))
		{
            format(string, sizeof(string), "{FF8000}** {C2A2DA}%s reaches for their helmet, and takes it off.", GetPlayerNameEx(playerid));
            SendClientMessageEx(playerid, COLOR_WHITE, "You have taken off your helmet.");
        }
        else
		{
            format(string, sizeof(string), "{FF8000}** {C2A2DA}%s reaches for their seatbelt, and unbuckles it.", GetPlayerNameEx(playerid));
            SendClientMessageEx(playerid, COLOR_WHITE, "You have taken off your seatbelt.");
        }
    }
    ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
    return 1;
}

CMD:cb(playerid, params[]) return cmd_checkbelt(playerid, params);

CMD:checkbelt(playerid, params[])
{
	new giveplayerid;
	if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /checkbelt [player]");

    if(GetPlayerState(giveplayerid) == PLAYER_STATE_ONFOOT)
	{
        SendClientMessageEx(playerid,COLOR_GREY,"That person is not in any vehicle!");
        return 1;
    }
    if (ProxDetectorS(9.0, playerid, giveplayerid))
	{
		new string[128];
        new stext[4];
        if(Seatbelt[giveplayerid] == 0) { stext = "off"; }
        else { stext = "on"; }
        if(IsABike(GetPlayerVehicleID(playerid)))
		{
            format(string, sizeof(string), "%s's helmet is currently %s." , GetPlayerNameEx(giveplayerid) , stext);
            SendClientMessageEx(playerid,COLOR_WHITE,string);

            format(string, sizeof(string), "* %s looks at %s, checking to see if they are wearing a helmet.", GetPlayerNameEx(playerid),GetPlayerNameEx(giveplayerid));
            ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
        }
        else
		{
            format(string, sizeof(string), "%s's seat belt is currently %s." , GetPlayerNameEx(giveplayerid) , stext);
            SendClientMessageEx(playerid,COLOR_WHITE,string);

            format(string, sizeof(string), "* %s peers through the window at %s, checking to see if they are wearing a seatbelt.", GetPlayerNameEx(playerid),GetPlayerNameEx(giveplayerid));
            ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
        }
    }
    else { SendClientMessageEx(playerid, COLOR_GREY, "You are not around that player!"); }
    return 1;
}

CMD:givekeys(playerid, params[])
{
	new
		giveplayerid;

    if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /givekeys [player]");
    if(IsPlayerConnected(giveplayerid))
	{
        if(playerid == giveplayerid) return 1;
        if (ProxDetectorS(4.0, playerid, giveplayerid))
		{
            new
				iValidVehicles,
				vstring[4096];

			for(new i; i < MAX_PLAYERVEHICLES; i++) if(PlayerVehicleInfo[playerid][i][pvModelId] >= 400)
			{
				if(PlayerVehicleInfo[playerid][i][pvImpounded] == 1)
					format(vstring, sizeof(vstring), "%s\n%s (impounded)", vstring, VehicleName[PlayerVehicleInfo[playerid][i][pvModelId] - 400]);

				else if(PlayerVehicleInfo[playerid][i][pvDisabled] == 1)
					format(vstring, sizeof(vstring), "%s\n%s (disabled)", vstring, VehicleName[PlayerVehicleInfo[playerid][i][pvModelId] - 400]);

				else if(PlayerVehicleInfo[playerid][i][pvSpawned] == 0)
					format(vstring, sizeof(vstring), "%s\n%s (stored)", vstring, VehicleName[PlayerVehicleInfo[playerid][i][pvModelId] - 400]);

				else
					format(vstring, sizeof(vstring), "%s\n%s", vstring, VehicleName[PlayerVehicleInfo[playerid][i][pvModelId] - 400]), ++iValidVehicles;
			}
			else strcat(vstring, "\nEmpty");
            if(iValidVehicles != 0)
			{
                GiveKeysTo[playerid] = giveplayerid;
                ShowPlayerDialog(playerid, GIVEKEYS, DIALOG_STYLE_LIST, "Please select a vehicle.", vstring, "Give Keys", "Cancel");
            }
            else
			{
                SendClientMessageEx(playerid, COLOR_GRAD2, "You don't have any vehicles for which you can give out keys.");
            }
        }
        else
		{
            SendClientMessageEx(playerid, COLOR_GRAD1, "You're not close enough to that player.");
        }
    }
    return 1;
}

CMD:sellmycar(playerid, params[])
{
	if(restarting) return SendClientMessageEx(playerid, COLOR_GRAD2, "Transactions are currently disabled due to the server being restarted for maintenance.");
    if(PlayerInfo[playerid][pFreezeCar] == 1)
    {
   		return SendClientMessageEx(playerid, COLOR_WHITE, "ERROR: Your car assets are frozen, you cannot sell a car!");
	}
    for(new d = 0 ; d < MAX_PLAYERVEHICLES; d++)
	{
        if(IsPlayerInVehicle(playerid, PlayerVehicleInfo[playerid][d][pvId]))
 		{
			if(PlayerInfo[playerid][pBackpack] > 0 && PlayerInfo[playerid][pBStoredV] == PlayerVehicleInfo[playerid][d][pvSlotId] && !GetPVarInt(playerid, "confirmvehsell")) 
			{
				SetPVarInt(playerid, "confirmvehsell", 1);
				return SendClientMessageEx(playerid, COLOR_WHITE, "ERROR: You have a backpack stored in this car, withdraw it first or you will loose it, please confirm!");
			}
            new Float:health;
            GetVehicleHealth(PlayerVehicleInfo[playerid][d][pvId], health);
            if(PlayerInfo[playerid][pLevel] == 1)
			{
                SendClientMessageEx(playerid, COLOR_GREY, "You have to be level 2 or higher to be able to sell vehicles.");
                return 1;
            }
            if(health < 500) return SendClientMessageEx(playerid, COLOR_GREY, " Your vehicle is too damaged to sell it.");

            new string[144], giveplayerid, price, alarmstring[9], lockstring[11], worklockstring[10];
			if(sscanf(params, "ud", giveplayerid, price)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /sellmycar [player] [price]");

            if(price < 1 || price > 1000000000) return SendClientMessageEx(playerid, COLOR_GREY, "Price must be higher than 0 and less than 1,000,000,000.");
            if(PlayerInfo[giveplayerid][pLevel] == 1)
			{
                SendClientMessageEx(playerid, COLOR_GREY, "The person has to be Level 2 or higher to be able to sell vehicles to them.");
                return 1;
            }
            if(playerid == giveplayerid)
			{
                SendClientMessageEx(playerid, COLOR_GREY, "You can not use this command on yourself.");
                return 1;
            }
            if(IsRestrictedVehicle(PlayerVehicleInfo[playerid][d][pvModelId]))
            {
                SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to sell this restricted vehicle.");
                return 1;
            }
			if(gettime()-GetPVarInt(playerid, "LastTransaction") < 60)
			{
				SendClientMessageEx(playerid, COLOR_GRAD2, "You can only sell a car once every 60 seconds, please wait!");
				return 1;
			}
			if(PlayerVehicleInfo[playerid][d][pvTicket] > 0)
			{
			    SendClientMessageEx(playerid, COLOR_GREY, "Your vehicle currently has unpaid tickets, you need to pay them before selling.");
			    return 1;
			}
            if(!IsPlayerConnected(giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "Player is currently not connected to the server.");
            if (ProxDetectorS(8.0, playerid, giveplayerid))
		 	{
		 	    if(PlayerInfo[giveplayerid][pFreezeCar] == 1)
	 		    {
	            	SendClientMessageEx(giveplayerid, COLOR_WHITE, "ERROR: Your car assets are frozen, you cannot buy a car!");
	            	SendClientMessageEx(playerid, COLOR_WHITE, "ERROR: Their car assets are frozen, they cannot buy a car!");
	            	return 1;
				}
				SetPVarInt(playerid, "LastTransaction", gettime());
                VehicleOffer[giveplayerid] = playerid;
                VehicleId[giveplayerid] = d;
                VehiclePrice[giveplayerid] = price;
				switch(PlayerVehicleInfo[playerid][d][pvAlarm]) {
					case 1: alarmstring = "Standard";
					case 2: alarmstring = "Deluxe";
					default: alarmstring = "no";
				}
				switch(PlayerVehicleInfo[playerid][d][pvLock]) {
					case 2: lockstring = "Electronic";
					case 3: lockstring = "Industrial";
					default: lockstring = "no";
				}
				if(PlayerVehicleInfo[playerid][d][pvLocksLeft] < 1) worklockstring = "(Broken)";
				format(string, sizeof(string), "* You offered %s to buy this %s with %s Alarm & %s%s Lock for $%s.", GetPlayerNameEx(giveplayerid), GetVehicleName(PlayerVehicleInfo[playerid][d][pvId]), alarmstring, worklockstring, lockstring, number_format(price));
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
				format(string, sizeof(string), "* %s has offered you their %s (VID: %d) with %s Alarm & %s%s Lock for $%s, (type /accept car) to buy.", GetPlayerNameEx(playerid), GetVehicleName(PlayerVehicleInfo[playerid][d][pvId]), PlayerVehicleInfo[playerid][d][pvId], alarmstring, worklockstring, lockstring, number_format(price));
				SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
				DeletePVar(playerid, "confirmvehsell");
                return 1;
            }
            else
			{
                SendClientMessageEx(playerid, COLOR_GREY, "That person is not near you.");
                return 1;
            }
        }
    }
    SendClientMessageEx(playerid, COLOR_GREY, " You need to be inside a vehicle that you own.");
    return 1;
}

CMD:pvlock(playerid, params[])
{
    new Float: x, Float: y, Float: z;
    if(PlayerInfo[playerid][pVehicleKeysFrom] != INVALID_PLAYER_ID)
	{
        new ownerid = PlayerInfo[playerid][pVehicleKeysFrom];
        if(IsPlayerConnected(ownerid))
		{
            new d = PlayerInfo[playerid][pVehicleKeys];
            if(PlayerVehicleInfo[ownerid][d][pvId] != INVALID_PLAYER_VEHICLE_ID) GetVehiclePos(PlayerVehicleInfo[ownerid][d][pvId], x, y, z);
            if(IsPlayerInRangeOfPoint(playerid, 3.0, x, y, z))
			{
                if(PlayerVehicleInfo[ownerid][d][pvLock] > 0)
				{
					if(PlayerVehicleInfo[ownerid][d][pvLocksLeft] <= 0) {
						SendClientMessageEx(playerid, COLOR_GREY, "The lock has been damaged as result of a lock pick!");
						return 1;
					}
					if(PlayerVehicleInfo[ownerid][d][pvBeingPickLocked]) {
						SendClientMessageEx(playerid, COLOR_GREY, "This vehicle cannot be locked/unlocked right now.");
						return 1;
					}
                    if(PlayerVehicleInfo[ownerid][d][pvLocked] == 0)
					{
                        GameTextForPlayer(playerid,"~r~Vehicle Locked!",5000,6);
                        PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
                        PlayerVehicleInfo[ownerid][d][pvLocked] = 1;
                        LockPlayerVehicle(ownerid, PlayerVehicleInfo[ownerid][d][pvId], PlayerVehicleInfo[ownerid][d][pvLock]);
                        return 1;
                    }
                    else
					{
                        GameTextForPlayer(playerid,"~g~Vehicle Unlocked!",5000,6);
                        PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
                        PlayerVehicleInfo[ownerid][d][pvLocked] = 0;
                        UnLockPlayerVehicle(ownerid, PlayerVehicleInfo[ownerid][d][pvId], PlayerVehicleInfo[ownerid][d][pvLock]);
                        return 1;
                    }
                }
                else
				{
                    SendClientMessageEx(playerid, COLOR_GREY, " You don't have a lock system installed on this vehicle.");
					return 1;
                }
            }
        }
    }
    for(new d = 0 ; d < MAX_PLAYERVEHICLES; d++)
    {
        if(PlayerVehicleInfo[playerid][d][pvId] != INVALID_PLAYER_VEHICLE_ID) GetVehiclePos(PlayerVehicleInfo[playerid][d][pvId], x, y, z);
        if(IsPlayerInRangeOfPoint(playerid, 3.0, x, y, z))
		{
			if(PlayerVehicleInfo[playerid][d][pvLocksLeft] <= 0) {
				SendClientMessageEx(playerid, COLOR_GREY, "The lock has been damaged as result of a lock pick, please buy a new one!");
				return 1;
			}
			if(PlayerVehicleInfo[playerid][d][pvBeingPickLocked]) {
				SendClientMessageEx(playerid, COLOR_GREY, "This vehicle cannot be locked/unlocked right now.");
				return 1;
			}
            if(PlayerVehicleInfo[playerid][d][pvLock] > 0 && PlayerVehicleInfo[playerid][d][pvLocked] == 0)
			{
                GameTextForPlayer(playerid,"~r~Vehicle Locked!",5000,6);
                PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
                PlayerVehicleInfo[playerid][d][pvLocked] = 1;
                LockPlayerVehicle(playerid, PlayerVehicleInfo[playerid][d][pvId], PlayerVehicleInfo[playerid][d][pvLock]);
                return 1;
            }
            else if(PlayerVehicleInfo[playerid][d][pvLock] > 0 && PlayerVehicleInfo[playerid][d][pvLocked] == 1)
			{
                GameTextForPlayer(playerid,"~g~Vehicle Unlocked!",5000,6);
                PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
                PlayerVehicleInfo[playerid][d][pvLocked] = 0;
                UnLockPlayerVehicle(playerid, PlayerVehicleInfo[playerid][d][pvId], PlayerVehicleInfo[playerid][d][pvLock]);
                return 1;

            }
            SendClientMessageEx(playerid, COLOR_GREY, " You don't have a lock system installed on this vehicle.");
            return 1;
        }
    }
    SendClientMessageEx(playerid, COLOR_GREY, " You are not near any vehicle that you own.");
    return 1;
}

CMD:vehid(playerid, params[])
{
    if(IsPlayerInAnyVehicle(playerid))
    {
		new string[128];
    	new idcar = GetPlayerVehicleID(playerid);
		format(string, sizeof(string), "* Vehicle Name: %s | Vehicle Model:%d | Vehicle ID: %d.",GetVehicleName(idcar), GetVehicleModel(idcar), idcar);
		SendClientMessageEx(playerid, COLOR_GREY, string);
	}
	return 1;
}

CMD:rc(playerid, params[])
{
	#if defined zombiemode
	if(zombieevent == 1 && GetPVarType(playerid, "pIsZombie")) return SendClientMessageEx(playerid, COLOR_GREY, "Zombies can't use this.");
	#endif
	new ccar = GetClosestCar(playerid);
	if(IsARC(ccar) && IsPlayerInRangeOfVehicle(playerid, ccar, 5.0))
	{
		if(IsPlayerInVehicle(playerid,ccar))
		{
			new Float:vehPos[3];
			GetVehiclePos(ccar,vehPos[0], vehPos[1], vehPos[2]);
			SetPlayerPos(playerid,vehPos[0], vehPos[1]+0.5, vehPos[2]+0.5);
		}
		else if(!IsPlayerInAnyVehicle(playerid))
		{
			//foreach(new i: Player)
			for(new i = 0; i < MAX_PLAYERS; ++i)
			{
				if(IsPlayerConnected(i))
				{
					new v = GetPlayerVehicle(i, ccar);
					if(v != -1 && PlayerVehicleInfo[i][v][pvLocked] == 0)
					{
						new Float:playerPos[3];
						GetPlayerPos(playerid,playerPos[0],playerPos[1],playerPos[2]);
						SetPlayerPos(playerid,playerPos[0],playerPos[1],playerPos[2]-500);
						IsPlayerEntering{playerid} = true;
						PutPlayerInVehicle(playerid, ccar, 0);
					}
				}	
			}
		}
	}
	return 1;
}

CMD:lastcar(playerid, params[]) return cmd_oldcar(playerid, params);

CMD:oldcar(playerid, params[])
{
	new string[128];
	if(!gLastCar[playerid]) return SendClientMessageEx(playerid, COLOR_GREY, "You have not driven a vehicle yet.");
	format(string, sizeof(string), "Your last driven vehicle was a %s (Model: %d -- ID: %d)", GetVehicleName(gLastCar[playerid]), GetVehicleModel(gLastCar[playerid]), gLastCar[playerid]);
	SendClientMessageEx(playerid, COLOR_GREY, string);
	return 1;
}

CMD:userimkit(playerid, params[])
{
	if(PlayerInfo[playerid][pRimMod] == 0)
	    return SendClientMessageEx(playerid, COLOR_GREY, "You don't have any rim modification kits.");

    if(!IsPlayerInAnyVehicle(playerid))
 		return SendClientMessageEx(playerid, COLOR_GREY, "You aren't in a vehicle.");


    if(InvalidModCheck(GetVehicleModel(GetPlayerVehicleID(playerid)), 1025))
	{
 		for(new d = 0 ; d < MAX_PLAYERVEHICLES; d++)
		{
			if(IsPlayerInVehicle(playerid, PlayerVehicleInfo[playerid][d][pvId]))
			{
				ShowPlayerDialog(playerid, DIALOG_RIMMOD, DIALOG_STYLE_LIST, "Rim Modification Kit", "Offroad\nShadow\nMega\nRimshine\nWires\nClassic\nTwist\nCutter\nSwitch\nGrove\nImport\nDollar\nTrance\nAtomic\nAhab\nVirtual\nAccess", "Select", "Exit");
				return 1;
			}
		}
		SendClientMessageEx(playerid, COLOR_GREY, "You need to be inside a vehicle that you own.");
		return 1;
	}
	else
	{
	    SendClientMessageEx(playerid, COLOR_GREY, "This vehicle can't be modded.");
	}

	return 1;
}

CMD:eject(playerid, params[])
{
	new State;
	if(IsPlayerInAnyVehicle(playerid))
	{
		State=GetPlayerState(playerid);
		if(State!=PLAYER_STATE_DRIVER)
		{
			SendClientMessageEx(playerid,COLOR_GREY,"   You can only eject people as the driver!");
			return 1;
		}

		new string[128], giveplayerid;
		if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /eject [player]");

		new test;
		test = GetPlayerVehicleID(playerid);
		if(IsPlayerConnected(giveplayerid))
		{
			if(giveplayerid != INVALID_PLAYER_ID)
			{
				if(giveplayerid == playerid) { SendClientMessageEx(playerid, COLOR_GREY, "You cannot Eject yourself!"); return 1; }
				if(IsPlayerInVehicle(giveplayerid,test))
				{
					if(GetPVarInt(giveplayerid, "EMSAttempt") != 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can't eject patients!");
					format(string, sizeof(string), "* You have thrown %s out of the car.", GetPlayerNameEx(giveplayerid));
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "* You have been thrown out the car by %s.", GetPlayerNameEx(playerid));
					SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
					RemovePlayerFromVehicle(giveplayerid);
					new Float:slx, Float:sly, Float:slz;
					GetPlayerPos(giveplayerid, slx, sly, slz);
					SetPlayerPos(giveplayerid, slx, sly+3, slz+1);
					format(string, sizeof(string), "* %s has ejected %s from the vehicle.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				}
				else
				{
					SendClientMessageEx(playerid, COLOR_GREY, "   That person is not in your Car!");
					return 1;
				}
			}
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, " Invalid ID/Name!");
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREY, "   You need to be in a Vehicle to use this!");
	}
	return 1;
}