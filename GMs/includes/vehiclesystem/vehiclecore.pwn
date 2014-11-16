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