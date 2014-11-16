/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						LEA Group Type

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

CMD:placekit(playerid, params[]) {
	if(IsACop(playerid) || IsAMedic(playerid) || IsAGovernment(playerid) || IsATowman(playerid))
	{
		if(IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this while being inside the vehicle!");
		if(GetPVarInt(playerid, "EMSAttempt") != 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can't use this command!");
		if(!GetPVarInt(playerid, "MedVestKit")) return SendClientMessageEx(playerid, COLOR_GRAD1, "You aren't carrying a kit.");
		new choice[9];
		if(sscanf(params, "s[9]", choice))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /placekit [name]");
			SendClientMessageEx(playerid, COLOR_GREY, "Available names: Car, Backpack");
			return 1;
		}
		new string[128];
		if(strcmp(choice, "Car", true)  == 0)
		{
			new vehicleid = GetClosestCar(playerid, INVALID_VEHICLE_ID, 10.0);
			if( vehicleid != INVALID_VEHICLE_ID && GetDistanceToCar(playerid, vehicleid) < 10 )
			{
				if(!IsABike(vehicleid) && !IsAPlane(vehicleid)) {
					new engine,lights,alarm,doors,bonnet,boot,objective;
					GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
					if(boot == VEHICLE_PARAMS_OFF || boot == VEHICLE_PARAMS_UNSET)
					{
						SendClientMessageEx(playerid, COLOR_GRAD1, "The vehicle's trunk must be opened in order to place it.");
						return 1;
					}
				}
				if(CrateVehicleLoad[vehicleid][vCarVestKit] == 2)
				{
					return SendClientMessageEx(playerid, COLOR_GRAD1, "This vehicle already has two kits loaded.");
				}
				format(string, sizeof(string), "{FF8000}** {C2A2DA}%s leans in to the trunk and places a Kevlar Vest & First Aid Kit inside.", GetPlayerNameEx(playerid));
				SendClientMessageEx(playerid, COLOR_WHITE, "You have loaded the Med Kit in to the Vehicle Trunk. /usekit to use it.");
				ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				SetPVarInt(playerid, "MedVestKit", 0);
				CrateVehicleLoad[vehicleid][vCarVestKit] += 1;
			}
			else return SendClientMessageEx(playerid, COLOR_GRAD2, "You are not near any vehicle.");
		}
		else if(strcmp(choice, "Backpack", true)  == 0)
		{
			if(PlayerInfo[playerid][pBackpack] > 0 && PlayerInfo[playerid][pBEquipped])
			{
				if(PlayerInfo[playerid][pBItems][5] > 0 && PlayerInfo[playerid][pBackpack] == 1)
				{
					return SendClientMessageEx(playerid, COLOR_GRAD1, "Your backpack size only lets you store 1 med kit.");
				}
				else if(PlayerInfo[playerid][pBItems][5] > 1 && PlayerInfo[playerid][pBackpack] == 2)
				{
					return SendClientMessageEx(playerid, COLOR_GRAD1, "Your backpack size only lets you store 2 med kit.");
				}
				else if(PlayerInfo[playerid][pBItems][5] > 2 && PlayerInfo[playerid][pBackpack] == 3)
				{
					return SendClientMessageEx(playerid, COLOR_GRAD1, "Your backpack size only lets you store 3 med kit.");
				}
				format(string, sizeof(string), "{FF8000}** {C2A2DA}%s opens a backpack and places a Kevlar Vest & First Aid Kit inside.", GetPlayerNameEx(playerid));
				SendClientMessageEx(playerid, COLOR_WHITE, "You have loaded the Med Kit in to your backpack. /usekit to use it.");
				ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				SetPVarInt(playerid, "MedVestKit", 0);
				PlayerInfo[playerid][pBItems][5] += 1;
			}
			else return SendClientMessageEx(playerid, COLOR_GRAD2, "You don't have a backpack Equipped, if you want to buy one type /miscshop.");
		}
		else 
		{
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /placekit [name]");
			SendClientMessageEx(playerid, COLOR_GREY, "Available names: Car, Backpack");
			return 1;
		}
	}
	return 1;
}

CMD:usekit(playerid, params[]) {
	if(IsACop(playerid) || IsAMedic(playerid) || IsAGovernment(playerid) || IsATowman(playerid))
	{
		if(GetPVarInt(playerid, "IsInArena") >= 0) return SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this while being in an arena!");
		if(IsPlayerInAnyVehicle(playerid)) { SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this while being inside the vehicle!"); return 1; }
		if(GetPVarInt(playerid, "EMSAttempt") != 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can't use this command!");
		new string[128];
		new vehicleid = GetClosestCar(playerid, INVALID_VEHICLE_ID, 10.0);
		if(vehicleid != INVALID_VEHICLE_ID && GetDistanceToCar(playerid, vehicleid) < 10)
		{
		    if(CrateVehicleLoad[vehicleid][vCarVestKit] > 0)
		    {
		    	if(!IsABike(vehicleid) && !IsAPlane(vehicleid)) {
					new engine,lights,alarm,doors,bonnet,boot,objective;
					GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
					if(boot == VEHICLE_PARAMS_OFF || boot == VEHICLE_PARAMS_UNSET)
					{
						SendClientMessageEx(playerid, COLOR_GRAD1, "The vehicle's trunk must be opened in order to search it.");
						return 1;
					}
				}
		        format(string, sizeof(string), "{FF8000}** {C2A2DA}%s leans in to the trunk and takes out a Kevlar Vest & First Aid Kit.", GetPlayerNameEx(playerid));
            	SendClientMessageEx(playerid, COLOR_WHITE, "You have used the Med Kit from the Vehicle Trunk.");
            	ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				SetPlayerHealth(playerid, 100);
				SetPlayerArmor(playerid, 100);
            	CrateVehicleLoad[vehicleid][vCarVestKit] -= 1;
				return 1;
		    }
			else return SendClientMessageEx(playerid, COLOR_GRAD1, "There are no med kits available in this vehicle."); 
		}
		else if(IsBackpackAvailable(playerid))
		{
			if(PlayerInfo[playerid][pBackpack] > 0 && PlayerInfo[playerid][pBEquipped])
			{
				if(PlayerInfo[playerid][pBItems][5] > 0)
				{
					if(GetPVarInt(playerid, "BackpackMedKit") == 1) {
						return SendClientMessageEx(playerid, COLOR_GRAD2, "You have already requested to use a medic kit.");
					}
					else 
					{
						defer FinishMedKit(playerid);
						SetPVarInt(playerid, "BackpackMedKit", 1);
						ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0, 1);
						format(string, sizeof(string), "{FF8000}** {C2A2DA}%s opens a backpack and takes out a Kevlar Vest & First Aid Kit inside.", GetPlayerNameEx(playerid));
						SendClientMessageEx(playerid, COLOR_WHITE, "You are taking a Med Kit from your backpack, please wait.");
						ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
					}
				}
				else return SendClientMessageEx(playerid, COLOR_GRAD1, "There are no med kits available in your backpack.");
			}
			else return SendClientMessageEx(playerid, COLOR_GRAD1, "You have no kits inside your backpack.");
		}
		else return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not near a vehicle or have a backup equipped!");
	}
	return 1;
}

CMD:searchcar(playerid, params[])
{
    new string[128];
    if (!IsACop(playerid))
	{
        SendClientMessageEx(playerid, COLOR_GREY, "   You are not a law enforcement officer!");
        return 1;
    }
    if(GetPVarInt(playerid, "Injured") != 0) {
		SendClientMessageEx (playerid, COLOR_GRAD2, "You cannot do this at this time.");
		return 1;
	}
    new carid = GetPlayerVehicleID(playerid);
    new closestcar = GetClosestCar(playerid,carid);
    if(!IsPlayerInRangeOfVehicle(playerid, closestcar, 9.0))
	{
        SendClientMessageEx(playerid,COLOR_GREY,"You are not near any vehicles.");
        return 1;
    }
	if(!IsABike(closestcar) && !IsAPlane(closestcar)) {
		new engine,lights,alarm,doors,bonnet,boot,objective;
		GetVehicleParamsEx(closestcar,engine,lights,alarm,doors,bonnet,boot,objective);
		if(boot == VEHICLE_PARAMS_OFF || boot == VEHICLE_PARAMS_UNSET)
		{
			SendClientMessageEx(playerid, COLOR_GRAD1, "The vehicle's trunk must be opened in order to search it.");
			return 1;
		}
	}
    //foreach(new i: Player)
	for(new i = 0; i < MAX_PLAYERS; ++i)
	{
		if(IsPlayerConnected(i))
		{
			new v = GetPlayerVehicle(i, closestcar);
			if(v != -1)
			{
				string[0] = 0;
				for(new x = 0; x < 3; x++)
				{
					if(PlayerVehicleInfo[i][v][pvWeapons][x] != 0)
					{
						new
							szWep[20];

						GetWeaponName(PlayerVehicleInfo[i][v][pvWeapons][x], szWep, sizeof(szWep));
						if(isnull(string)) format(string, sizeof(string), "* Trunk contains: %s", szWep);
						else format(string, sizeof(string), "%s, %s", string, szWep);
					}
				}
				if(!isnull(string)) {
					SendClientMessageEx(playerid, COLOR_WHITE, string);
					if(CrateVehicleLoad[closestcar][vCarVestKit]) {
						SendClientMessageEx(playerid, COLOR_WHITE, "* Trunk contains:");
						SendClientMessageEx(playerid, COLOR_WHITE, "* Kevlar Vest.");
						SendClientMessageEx(playerid, COLOR_WHITE, "* First Aid Kit.");
					}
				}
				else SendClientMessageEx(playerid, COLOR_WHITE, "* Trunk contains: nothing.");
			}
		}	
    }
    if(isnull(string))
    {
        if(CrateVehicleLoad[closestcar][vCarVestKit] > 0) {
            new str[84];
            SendClientMessageEx(playerid, COLOR_WHITE, "* Trunk contains:");
            format(str, sizeof(str), "* Kevlar Vest (x%d).", CrateVehicleLoad[closestcar][vCarVestKit]);
            SendClientMessageEx(playerid, COLOR_WHITE, str);
            format(str, sizeof(str), "* First Aid Kit(x%d).", CrateVehicleLoad[closestcar][vCarVestKit]);
            SendClientMessageEx(playerid, COLOR_WHITE, str);
		}
		else SendClientMessageEx(playerid, COLOR_WHITE, "* Trunk contains: nothing.");
    }
    return 1;
}

CMD:takecarweapons(playerid, params[])
{
    if (!IsACop(playerid))
	{
        SendClientMessageEx(playerid,COLOR_GREY,"You're not a law enforcement officer.");
        return 1;
    }
    new carid = GetPlayerVehicleID(playerid);
    new closestcar = GetClosestCar(playerid,carid);
    if(!IsPlayerInRangeOfVehicle(playerid, closestcar, 9.0))
	{
        SendClientMessageEx(playerid,COLOR_GREY,"You are not near any vehicles.");
        return 1;
    }
	new engine,lights,alarm,doors,bonnet,boot,objective;
	GetVehicleParamsEx(closestcar,engine,lights,alarm,doors,bonnet,boot,objective);
	if(boot == VEHICLE_PARAMS_OFF || boot == VEHICLE_PARAMS_UNSET)
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "The vehicle's trunk must be opened in order to search it.");
		return 1;
	}
    //foreach(new i: Player)
	for(new i = 0; i < MAX_PLAYERS; ++i)
	{
		if(IsPlayerConnected(i))
		{
			new v = GetPlayerVehicle(i, closestcar);
			if(v != -1)
			{
				if (!PlayerVehicleInfo[i][v][pvWeapons][0] && !PlayerVehicleInfo[i][v][pvWeapons][1] && !PlayerVehicleInfo[i][v][pvWeapons][2])
				{
					SendClientMessageEx(playerid, COLOR_WHITE,  "No weapons in the trunk.");
					return 1;
				}
				else
				{
					PlayerVehicleInfo[i][v][pvWeapons][0] = 0;
					PlayerVehicleInfo[i][v][pvWeapons][1] = 0;
					PlayerVehicleInfo[i][v][pvWeapons][2] = 0;
					SendClientMessageEx(playerid, COLOR_WHITE,  "All weapons have been removed from this vehicle.");
					new string[MAX_PLAYER_NAME + 44];
					format(string, sizeof(string), "* %s has taken the weapons away from the trunk.", GetPlayerNameEx(playerid));
					ProxDetector(20.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
					return 1;
				}
			}
		}	
    }
    return 1;
}

CMD:mdc(playerid, params[])
{
    if(IsMDCPermitted(playerid))
	{
        if(IsPlayerInAnyVehicle(playerid))
		{
            ShowPlayerDialog(playerid, MDC_MAIN, DIALOG_STYLE_LIST, "MDC - Logged in", "*Civilian Information\n*Find LEO\n*Law Enforcement Agencies\n*MDC Message\n*SMS", "OK", "Cancel");
            ConnectedToPC[playerid] = 1337;
        }
        else SendClientMessageEx(playerid, COLOR_GREY, "You are not in a vehicle.");
    }
    return 1;
}

CMD:clearcargo(playerid, params[])
{
	if(!IsACop(playerid))
	{
        SendClientMessageEx(playerid, COLOR_GRAD2, "You are not a law enforcement officer!");
        return 1;
	}

	new carid = GetPlayerVehicleID(playerid);
 	new closestcar = GetClosestCar(playerid, carid);
  	if(IsPlayerInRangeOfVehicle(playerid, closestcar, 6.0) && IsATruckerCar(closestcar))
	{
		if(IsPlayerInAnyVehicle(playerid))
		{
		    SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot clear the cargo while inside of a vehicle.");
		    return 1;
		}
		if(TruckContents{closestcar} == 0)
		{
		 	if(TruckDeliveringTo[closestcar] != INVALID_BUSINESS_ID && (Businesses[TruckDeliveringTo[closestcar]][bType] != BUSINESS_TYPE_GASSTATION || Businesses[TruckDeliveringTo[closestcar]][bType] == BUSINESS_TYPE_NEWCARDEALERSHIP))
			{
				SendClientMessageEx(playerid, COLOR_WHITE, "You cannot take the content away.");
				return 1;
			}
		}
		new truckcontentname[50];
		new iTruckContents = TruckContents{closestcar};
		if(iTruckContents >= 0 && iTruckContents < 5)
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "There are no illegal items in that Vehicle.");
			return 1;
		}
		else if(TruckDeliveringTo[closestcar] == INVALID_BUSINESS_ID && iTruckContents == 0)
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "There are no illegal items in that Vehicle.");
			return 1;
		}
		if(iTruckContents == 5)
		{ format(truckcontentname, sizeof(truckcontentname), "{FF0606}illegal weapons"); }
		else if(iTruckContents == 6)
		{ format(truckcontentname, sizeof(truckcontentname), "{FF0606}illegal drugs"); }
		else if(iTruckContents == 7)
		{ format(truckcontentname, sizeof(truckcontentname), "{FF0606}illegal materials"); }
		else format(truckcontentname, sizeof(truckcontentname), "{FF0606}illegal materials");
 		//foreach(new i: Player)
		for(new i = 0; i < MAX_PLAYERS; ++i)
		{
			if(IsPlayerConnected(i))
			{
				if(TruckUsed[i] == closestcar)
				{
					TruckUsed[i] = INVALID_VEHICLE_ID;
					TruckDeliveringTo[closestcar] = INVALID_BUSINESS_ID;
					TruckContents{closestcar} = 0;
					TruckRoute[closestcar] = 0;
					DisablePlayerCheckpoint(i);
					gPlayerCheckpointStatus[i] = CHECKPOINT_NONE;
					DeletePVar(i, "TruckDeliver");
					SendClientMessageEx(i, COLOR_WHITE, "Your delivery has failed. Law enforcement has confiscated the illegal goods.");
				}
			}	
		}
		new string[128];
		format(string, sizeof(string), "You removed the %s {FFFFFF}from the Vehicle.", truckcontentname);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "* %s has taken the illegal items from the Vehicle.", GetPlayerNameEx(playerid));
		ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
    }
   	else
	{
 		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not near a Shipment Transport Vehicle.");
 	}
    return 1;
}