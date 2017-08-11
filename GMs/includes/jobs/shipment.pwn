/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Shipment System

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

#include <YSI\y_hooks>

forward HijackTruck(playerid);
public HijackTruck(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);
  	new business = TruckDeliveringTo[vehicleid];

	SetPVarInt(playerid, "LoadTruckTime", GetPVarInt(playerid, "LoadTruckTime")-1);
	new string[128];
	format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~%d seconds left", GetPVarInt(playerid, "LoadTruckTime"));
	GameTextForPlayer(playerid, string, 1100, 3);
	if(GetPVarInt(playerid, "LoadTruckTime") > 0) SetTimerEx("HijackTruck", 1000, 0, "d", playerid);

	if(GetPVarInt(playerid, "LoadTruckTime") <= 0)
	{
		DeletePVar(playerid, "IsFrozen");
		TogglePlayerControllable(playerid, 1);
  		DeletePVar(playerid, "LoadTruckTime");

        if(!IsPlayerInVehicle(playerid, vehicleid))
        {
			TruckUsed[playerid] = INVALID_VEHICLE_ID;
			gPlayerCheckpointStatus[playerid] = CHECKPOINT_NONE;
 			DisablePlayerCheckpoint(playerid);
            SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* You failed to hijack the shipment.");
			return 1;
        }


		foreach(new i: Player)
		{
			if(TruckUsed[i] == vehicleid)
			{
				DeletePVar(i, "LoadTruckTime");
				TruckUsed[i] = INVALID_VEHICLE_ID;
				DisablePlayerCheckpoint(i);
				gPlayerCheckpointStatus[i] = CHECKPOINT_NONE;
				SendClientMessageEx(i, COLOR_WHITE, "Your shipment delivery has failed. Your shipment was Hijacked.");
			}
		}	

  		TruckUsed[playerid] = vehicleid;
  		if(!IsABoat(vehicleid))
  		{
			new route = TruckRoute[vehicleid];
			SetPVarInt(playerid, "TruckDeliver", TruckContents{vehicleid});
			switch(TruckContents{vehicleid}) {
			    case 0: {
			        if(business != INVALID_BUSINESS_ID)
			        {
						format(string, sizeof(string), "You hijacked a shipment of %s", GetInventoryType(TruckDeliveringTo[vehicleid]));
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);

				        SetPlayerCheckpoint(playerid, Businesses[business][bSupplyPos][0], Businesses[business][bSupplyPos][1], Businesses[business][bSupplyPos][2], 10.0);
					}
				}
				case 1: {
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"You hijacked a shipment of food & beverages.");
					SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 5);
				}
				case 2:
				{
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"You hijacked a shipment of clothing.");
					SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 5);
				}
				case 3:
				{
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"You hijacked a shipment of materials.");
					SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 5);
				}
				case 4:
				{
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* You hijacked a shipment of stolen 24/7 items - watch out for law enforcement!");
					SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 5);
				}
				case 5:
				{
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* You hijacked a shipment of weapons - watch out for law enforcement!");
					SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 5);
				}
				case 6:
				{
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"You hijacked a shipment of drugs - watch out for law enforcement!");
					SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 5);
				}
				case 7:
				{
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"You hijacked a shipment of illegal materials - watch out for law enforcement!");
					SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 5);
				}
			}
			SendClientMessageEx(playerid, COLOR_REALRED, "WARNING: Watch out for Truck hijackers, they can hijack your truck and get away with the goods.");
		}
		else
		{
		    SetPVarInt(playerid, "TruckDeliver", TruckContents{vehicleid});
			new route = TruckRoute[vehicleid];
			switch(TruckContents{vehicleid}) {
				case 1: {
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"You hijacked a shipment of food & beverages.");
					SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 5);
				}
				case 2:
				{
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"You hijacked a shipment of clothing.");
					SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 5);
				}
				case 3:
				{
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"You hijacked a shipment of materials.");
					SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 5);
				}
				case 4:
				{
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* You hijacked a shipment of stolen 24/7 items - watch out for law enforcement!");
					SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 5);
				}
				case 5:
				{
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* You hijacked a shipment of weapons - watch out for law enforcement!");
					SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 5);
				}
				case 6:
				{
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"You hijacked a shipment of drugs - watch out for law enforcement!");
					SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 5);
				}
				case 7:
				{
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"You hijacked a shipment of illegal materials - watch out for law enforcement!");
					SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 5);
				}
				default: return SendClientMessageEx(playerid, COLOR_GRAD2, "This vehicle is not loaded with hijackable goods.");
			}
			SendClientMessageEx(playerid, COLOR_REALRED, "WARNING: Watch out for boat hijackers, they can hijack your boat and get away with the goods.");
		}
		SendClientMessageEx(playerid, COLOR_WHITE, "Deliver the goods to the specified location (see checkpoint on radar).");
	}
	return 1;
}

forward LoadTruckOld(playerid);
public LoadTruckOld(playerid)
{
    SetPVarInt(playerid, "LoadTruckTime", GetPVarInt(playerid, "LoadTruckTime")-1);
	new string[128];
	format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~%d seconds left", GetPVarInt(playerid, "LoadTruckTime"));
	GameTextForPlayer(playerid, string, 1100, 3);

	if(GetPVarInt(playerid, "LoadTruckTime") > 0) SetTimerEx("LoadTruckOld", 1000, 0, "d", playerid);

	if(GetPVarInt(playerid, "LoadTruckTime") <= 0)
	{
		DeletePVar(playerid, "LoadTruckTime");
		DeletePVar(playerid, "IsFrozen");
		TogglePlayerControllable(playerid, 1);

  		new vehicleid = GetPlayerVehicleID(playerid);
  		new truckdeliver = GetPVarInt(playerid, "TruckDeliver");
  		TruckContents{vehicleid} = truckdeliver;
  		TruckUsed[playerid] = vehicleid;
  		if(!IsABoat(vehicleid))
  		{
	  		new route = random(sizeof(TruckerDropoffs));
	  		TruckRoute[vehicleid] = route;
			// 1 = food and bev
			// 2 = clothing
			// 3 = legal mats
			// 4 = 24/7 items
			// 5 = weapons
			// 6 = illegal drugs
			// 7 = illegal materials
			if(truckdeliver == 1)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Your Truck was filled with food & beverages.");
				SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 5);
			}
			else if(truckdeliver == 2)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Your Truck was filled with clothing.");
				SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 5);
			}
			else if(truckdeliver == 3)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Your Truck was filled with materials.");
				SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 5);
			}
			else if(truckdeliver == 4)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Your Truck was filled with 24/7 items.");
				SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 5);
			}
			else if(truckdeliver == 5)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Your Truck was filled with weapons.");
				SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 5);
			}
			else if(truckdeliver == 6)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Your Truck was filled with drugs.");
				SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 5);
			}
			else if(truckdeliver == 7)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Your Truck was filled with illegal materials.");
				SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 5);
			}
			SendClientMessageEx(playerid, COLOR_REALRED, "WARNING: Watch out for Truck hijackers, they can hijack your truck and get away with the goods.");
		}
		else
		{
			new route = random(sizeof(BoatDropoffs));
	  		TruckRoute[vehicleid] = route;

			if(truckdeliver == 1)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Your Boat was filled with food & beverages.");
				SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 5);
			}
			else if(truckdeliver == 2)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Your Boat was filled with clothing.");
				SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 5);
			}
			else if(truckdeliver == 3)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Your Boat was filled with materials.");
				SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 5);
			}
			else if(truckdeliver == 4)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Your Boat was filled with 24/7 items.");
				SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 5);
			}
			else if(truckdeliver == 5)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Your Boat was filled with weapons.");
				SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 5);
			}
			else if(truckdeliver == 6)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Your Boat was filled with drugs.");
				SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 5);
			}
			else if(truckdeliver == 7)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Your Boat was filled with illegal materials.");
				SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 5);
			}
			SendClientMessageEx(playerid, COLOR_REALRED, "WARNING: Watch out for boat hijackers, they can hijack your boat and get away with the goods.");
		}
		if(truckdeliver >= 5)
		{
			SendClientMessageEx(playerid, COLOR_REALRED, "WARNING #2: You are transporting illegal goods so watch out for law enforcement.");
		}
		SendClientMessageEx(playerid, COLOR_WHITE, "HINT: Deliver the goods to the specified location (see checkpoint on radar).");
		SetPVarInt(playerid, "tpTruckRunTimer", 30);
		SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_TPTRUCKRUNTIMER);
	}
	return 1;
}

forward LoadTruck(playerid);
public LoadTruck(playerid)
{
    SetPVarInt(playerid, "LoadTruckTime", GetPVarInt(playerid, "LoadTruckTime")-1);
	new string[128];
	format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~%d seconds left", GetPVarInt(playerid, "LoadTruckTime"));
	GameTextForPlayer(playerid, string, 1100, 3);

	if(GetPVarInt(playerid, "LoadTruckTime") > 0) SetTimerEx("LoadTruck", 1000, 0, "d", playerid);

	if(GetPVarInt(playerid, "LoadTruckTime") <= 0)
	{
		DeletePVar(playerid, "LoadTruckTime");
		DeletePVar(playerid, "IsFrozen");
		TogglePlayerControllable(playerid, 1);

  		new vehicleid = GetPlayerVehicleID(playerid);
  		new business = TruckDeliveringTo[vehicleid];
  		TruckUsed[playerid] = vehicleid;


		gPlayerCheckpointStatus[playerid] = CHECKPOINT_DELIVERY;

		format(string, sizeof(string), "* Your Truck was filled with %s", GetInventoryType(business));
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);

        SetPlayerCheckpoint(playerid, Businesses[business][bSupplyPos][0], Businesses[business][bSupplyPos][1], Businesses[business][bSupplyPos][2], 10.0);

		SendClientMessageEx(playerid, COLOR_WHITE, "HINT: Deliver the goods to the specified location (see checkpoint on radar).");
		SendClientMessageEx(playerid, COLOR_REALRED, "WARNING: Watch out for truck hijackers, they can hijack your truck and get away with the goods.");

		if (Businesses[business][bType] == BUSINESS_TYPE_GUNSHOP)
		{
			SendClientMessageEx(playerid, COLOR_REALRED, "WARNING #2: You are transporting illegal goods so watch out for law enforcement.");
		}
		else if (Businesses[business][bType] == BUSINESS_TYPE_GASSTATION)
		{
		  	new Float:x, Float:y, Float:z, Float:ang;
		  	SetVehiclePos(vehicleid, -1570.9833,96.7547,4.1442);
		  	SetVehicleZAngle(vehicleid, 136.18);
		    GetPlayerPos(playerid, x, y, z);
		    GetVehicleZAngle(vehicleid, ang);
		    new iTrailer = CreateVehicle(584, x, y, z+1, ang, -1, -1, 1000);
		    SetPVarInt(playerid, "Gas_TrailerID", iTrailer);
			SetTimerEx("AttachGasTrailer", 500, false, "ii", iTrailer, vehicleid);
		}
		/*else if (Businesses[business][bType] == BUSINESS_TYPE_NEWCARDEALERSHIP)
		{
			new iModel, iSlot;
		    for (new i; i < MAX_BUSINESS_DEALERSHIP_VEHICLES; i++)
		    {
			    if (Businesses[business][DealershipVehOrder][i]) {
					iModel = Businesses[business][bModel][i];
					iSlot = i;
	 			}
		    }
			new Float: fVehPos[4];
			GetVehiclePos(vehicleid, fVehPos[0], fVehPos[1], fVehPos[2]);
			GetVehicleZAngle(vehicleid, fVehPos[3]);
			new iDeliveredVeh = CreateVehicle(iModel, fVehPos[0], fVehPos[1], fVehPos[2] + 3, fVehPos[3], 1, 1, -1);
			SetVehicleZAngle(iDeliveredVeh, fVehPos[3]);
			vehicle_lock_doors(iDeliveredVeh);

			SetPVarInt(playerid, "CarryingVehicle", iDeliveredVeh);
			SetPVarInt(playerid, "CarryingSlot", iSlot);
		} */
		SetPVarInt(playerid, "tpTruckRunTimer", floatround(GetPlayerDistanceFromPoint(playerid, Businesses[business][bSupplyPos][0], Businesses[business][bSupplyPos][1], Businesses[business][bSupplyPos][2]) / 100));
		SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_TPTRUCKRUNTIMER);
	}
	return 1;
}

stock DisplayOrders(playerid)
{
	new szDialog[2048];
	for (new i, j; i < MAX_BUSINESSES; i++)
	{
	    if (Businesses[i][bOrderState] == 1)
	    {
	        if(Businesses[i][bType] > 0)
	        {
		    	format(szDialog, sizeof(szDialog), "%s%s\t%s\n", szDialog, Businesses[i][bName], GetInventoryType(i));
				ListItemTrackId[playerid][j++] = i;
			}
		}
	}

	if (!szDialog[0] || IsABoat(GetPlayerVehicleID(playerid)))
	{

		/*ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Error", "No jobs available right now. Try again later.", "OK", "");
		TogglePlayerControllable(playerid, 1);
		DeletePVar(playerid, "IsFrozen"); */
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 456 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 414 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 413 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 440 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 482 || IsABoat(GetPlayerVehicleID(playerid)))
		{
			ShowPlayerDialogEx(playerid,DIALOG_LOADTRUCKOLD,DIALOG_STYLE_LIST,"What do you want to transport?","{00F70C}Legal goods {FFFFFF}(no risk but also no bonuses)\n{FF0606}Illegal goods {FFFFFF}(risk of getting caught but a bonus)","Select","Cancel");
		}
		else
		{
			ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Error", "No jobs available for this type of truck right now. Try again later.", "OK", "");
			TogglePlayerControllable(playerid, 1);
			DeletePVar(playerid, "IsFrozen");
		}
	}
	else
	{
	    ShowPlayerDialogEx(playerid, DIALOG_LOADTRUCK, DIALOG_STYLE_LIST, "Available Orders", szDialog, "Take", "Close");
	}
	return 1;
}

IsAtTruckDeliveryPoint(playerid)
{
	for(new i = 0; i < sizeof(TruckerDropoffs); i++)
	{
		if(IsPlayerInRangeOfPoint(playerid, 6, TruckerDropoffs[i][PosX], TruckerDropoffs[i][PosY], TruckerDropoffs[i][PosZ])) {
		    return 1;
		}
	}
	for(new i = 0; i < sizeof(BoatDropoffs); i++)
	{
		if(IsPlayerInRangeOfPoint(playerid, 6, BoatDropoffs[i][PosX], BoatDropoffs[i][PosY], BoatDropoffs[i][PosZ])) {
		    return 1;
		}
	}
	return false;
}

CancelTruckDelivery(playerid)
{
	new vehicleid = GetPlayerVehicleID(playerid);
	if(TruckDeliveringTo[TruckUsed[playerid]] != INVALID_BUSINESS_ID)
	{
		if(Businesses[TruckDeliveringTo[TruckUsed[playerid]]][bType] == BUSINESS_TYPE_GASSTATION)
		{
			DestroyVehicle(GetPVarInt(playerid, "Gas_TrailerID"));
			DeletePVar(playerid, "Gas_TrailerID");
		}
		Businesses[TruckDeliveringTo[TruckUsed[playerid]]][bOrderState] = 1;
		SaveBusiness(TruckDeliveringTo[TruckUsed[playerid]]);
	}
	if(1 <= TruckUsed[playerid] <= MAX_VEHICLES){
		TruckDeliveringTo[TruckUsed[playerid]] = INVALID_BUSINESS_ID, TruckContents{TruckUsed[playerid]} = 0;
	}
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		if(IsATruckerCar(vehicleid)) SetVehicleToRespawn(vehicleid);
	}
	gPlayerCheckpointStatus[playerid] = CHECKPOINT_NONE;
	TruckUsed[playerid] = INVALID_VEHICLE_ID;
 	DisablePlayerCheckpoint(playerid);
 	DeletePVar(playerid, "TruckDeliver");
	return 1;
}

CMD:checkcargo(playerid, params[])
{
	if(PlayerInfo[playerid][pJob] != 20 && PlayerInfo[playerid][pJob2] != 20 && PlayerInfo[playerid][pJob3] != 20 && !IsACop(playerid))
	{
        SendClientMessageEx(playerid, COLOR_GRAD2, "You are not a Shipment Contractor or a Cop!");
        return 1;
	}

	new carid = GetPlayerVehicleID(playerid);
 	new closestcar = GetClosestCar(playerid, carid);
  	if(IsPlayerInRangeOfVehicle(playerid, closestcar, 6.0) && IsATruckerCar(closestcar))
	{
		if(IsPlayerInAnyVehicle(playerid))
		{
			SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot search the contents of this vehicle while inside a vehicle.");
			return 1;
		}
		new engine,lights,alarm,doors,bonnet,boot,objective;
		GetVehicleParamsEx(closestcar,engine,lights,alarm,doors,bonnet,boot,objective);
		if(boot == VEHICLE_PARAMS_OFF || boot == VEHICLE_PARAMS_UNSET)
		{
			SendClientMessageEx(playerid, COLOR_GRAD1, "The vehicle's trunk must be opened in order to search it.");
			return 1;
		}

		new string[128];

     	SendClientMessageEx(playerid, COLOR_GREEN,"_______________ SHIPMENT CONTRACTOR LOAD SHEET _______________");
		if(IsPlayerInVehicle(playerid, closestcar))
  		{
    		SendClientMessageEx(playerid, COLOR_WHITE, "There is a person in that truck. In order to check the content of the truck, the driver must be removed.");
      		return 1;
		}
		new iTruckContents = TruckContents{closestcar};
		new truckcontentname[50];
		if(iTruckContents == 1)
		{ format(truckcontentname, sizeof(truckcontentname), "{00F70C}Food & beverages");}
		else if(iTruckContents == 2)
		{ format(truckcontentname, sizeof(truckcontentname), "{00F70C}Clothing"); }
		else if(iTruckContents == 3)
		{ format(truckcontentname, sizeof(truckcontentname), "{00F70C}Legal materials"); }
		else if(iTruckContents == 4)
		{ format(truckcontentname, sizeof(truckcontentname), "{00F70C}24/7 items"); }
		else if(iTruckContents == 5)
		{ format(truckcontentname, sizeof(truckcontentname), "{FF0606}Illegal weapons"); }
		else if(iTruckContents == 6)
		{ format(truckcontentname, sizeof(truckcontentname), "{FF0606}Illegal drugs"); }
		else if(iTruckContents == 7)
		{ format(truckcontentname, sizeof(truckcontentname), "{FF0606}Illegal materials"); }
		format(string, sizeof(string), "Vehicle registration: %s (%d)", GetVehicleName(closestcar), closestcar);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		if(iTruckContents == 0)
		{ format(truckcontentname, sizeof(truckcontentname), "%s",  GetInventoryType(TruckDeliveringTo[closestcar])); }
		format(string, sizeof(string), "Content: %s", truckcontentname);
		SendClientMessageEx(playerid, COLOR_WHITE, string);

		if(IsACop(playerid))
		{
			SendClientMessageEx(playerid, COLOR_YELLOW, "To remove the illegal goods, type /clearcargo near the truck.");
		}

		if(PlayerInfo[playerid][pJob] == 20 || PlayerInfo[playerid][pJob2] == 20 || PlayerInfo[playerid][pJob3] == 20)
		{
			if(TruckDeliveringTo[closestcar] > 0 && TruckUsed[playerid] == INVALID_VEHICLE_ID)
			{
				SendClientMessageEx(playerid, COLOR_YELLOW, "To deliver the goods, type /hijackcargo as the driver.");
			}
			else if(TruckUsed[playerid] == INVALID_VEHICLE_ID)
			{
				SendClientMessageEx(playerid, COLOR_YELLOW, "To get goods, type /loadshipment as the driver.");
			}
			else if(TruckUsed[playerid] == closestcar && gPlayerCheckpointStatus[playerid] == CHECKPOINT_RETURNTRUCK)
			{
				SendClientMessageEx(playerid, COLOR_YELLOW, "This is your Shipment Transport Vehicle. You have not returned it to the docks yet for your pay.");
			}
			else if(TruckUsed[playerid] == closestcar)
			{
				SendClientMessageEx(playerid, COLOR_YELLOW, "This is your Shipment Transport Vehicle. You have not delivered your goods yet.");
			}
			else if(TruckUsed[playerid] != INVALID_VEHICLE_ID)
			{
				SendClientMessageEx(playerid, COLOR_YELLOW, "You are already on another delivery. Type /cancel shipment to cancel that delivery.");
			}
		}
     	SendClientMessageEx(playerid, COLOR_GREEN,"_________________________________________________________");
    }
	else
	{
 		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not near a Shipment Transport Vehicle.");
 	}
    return 1;
}

CMD:hijackcargo(playerid, params[])
{
	if(PlayerInfo[playerid][pJob] == 20 || PlayerInfo[playerid][pJob2] == 20 || PlayerInfo[playerid][pJob3] == 20)
	{
	    new vehicleid = GetPlayerVehicleID(playerid);
	    if(IsATruckerCar(vehicleid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	    {
     		if(!CheckPointCheck(playerid))
	        {
         		if(GetPVarInt(playerid, "LoadTruckTime") > 0)
	            {
	                SendClientMessageEx(playerid, COLOR_WHITE, "You are currently loading your Truck!");
					return 1;
	            }
	            if(TruckUsed[playerid] != INVALID_VEHICLE_ID)
	            {
	                SendClientMessageEx(playerid, COLOR_WHITE, "You are already on another delivery, type /cancel shipment to cancel that delivery.");
					return 1;
	            }
				if(TruckDeliveringTo[vehicleid] == 0 && TruckContents{vehicleid} == 0)
				{
				    SendClientMessageEx(playerid, COLOR_WHITE, "This Truck is empty, it does not contain any goods!");
				    return 1;
				}
				if(IsPlayerInRangeOfPoint(playerid, 65, -1572.767822, 81.137527, 3.554687))
				{
				    SendClientMessageEx(playerid, COLOR_WHITE, "You can not hijack when that close to the San Fierro Docks!");
					return 1;
				}
				if(!IsABoat(vehicleid))
				{
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* You are now attempting to hijack the truck, please wait....");
				} 
				else 
				{
					if(PlayerInfo[playerid][pTruckSkill] >= 200)
					{
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* You are now attempting to hijack the boat, please wait....");
					}
					else return SendClientMessageEx(playerid, COLOR_WHITE, "Water shipments are restricted to Level 4+ Shipment Contracter.");
				}

				TogglePlayerControllable(playerid, 0);
				SetPVarInt(playerid, "IsFrozen", 1);

				SetPVarInt(playerid, "LoadTruckTime", 10);
				SetTimerEx("HijackTruck", 1000, 0, "dd", playerid);
	        }
	        else return SendClientMessageEx(playerid, COLOR_WHITE, "Please ensure that your current checkpoint is destroyed first (you either have material packages, or another existing checkpoint).");
	    }
	    else return SendClientMessageEx(playerid, COLOR_GREY, "You are not driving a Shipment Transport Vehicle!");
	}
	else return SendClientMessageEx(playerid, COLOR_GREY, "You are not a Shipment Contractor!");
	return 1;
}

CMD:loadshipment(playerid, params[])
{
	if(PlayerInfo[playerid][pJob] == 20 || PlayerInfo[playerid][pJob2] == 20 || PlayerInfo[playerid][pJob3] == 20)
	{
	    new vehicleid = GetPlayerVehicleID(playerid);
	    if(IsATruckerCar(vehicleid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	    {
	        if(!CheckPointCheck(playerid))
	        {
	            if(GetPVarInt(playerid, "LoadTruckTime") > 0)
	            {
	                SendClientMessageEx(playerid, COLOR_WHITE, "You are currently loading the Shipment!");
					return 1;
	            }
	            if(TruckUsed[playerid] != INVALID_VEHICLE_ID)
	            {
	                SendClientMessageEx(playerid, COLOR_WHITE, "You are already on another delivery, type /cancel shipment to cancel that delivery.");
					return 1;
	            }
				if(TruckContents{vehicleid} != 0)
				{
				    return SendClientMessageEx(playerid, COLOR_GRAD2, "That vehicle is already loaded.");
				}
				if(TruckDeliveringTo[vehicleid] != INVALID_BUSINESS_ID && TruckContents{vehicleid} == 0)
				{
				    return SendClientMessageEx(playerid, COLOR_GRAD2, "That vehicle is already loaded.");
				}
				if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 440 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 413) // Level Three Vehicle Check
				{
					if(PlayerInfo[playerid][pTruckSkill] < 100) 
					{
						return SendClientMessageEx(playerid, COLOR_GRAD2, "Only level 3 Shipment Contractors may use this vehicle.");
					}
				}
				if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 482) // Level Five Vehicle Check
				{
					if(PlayerInfo[playerid][pTruckSkill] < 400)  
					{
						return SendClientMessageEx(playerid, COLOR_GRAD2, "Only level 5 Shipment Contractors may use this vehicle.");
					}
				}
	            if(!IsABoat(vehicleid))
	            {
		            SetPlayerCheckpoint(playerid,-1572.767822, 81.137527, 3.554687, 4);
		            GameTextForPlayer(playerid, "~w~Waypoint set ~r~San Fierro Docks", 5000, 1);
		            SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Pick up some goods to transport with your Truck at San Fierro Docks (see checkpoint on radar).");
				}
				else
				{
					if(PlayerInfo[playerid][pTruckSkill] >= 200)
					{
						SetPlayerCheckpoint(playerid,2098.6543,-104.3568,-0.4820, 4);
						GameTextForPlayer(playerid, "~w~Waypoint set ~r~Palamino Docks", 5000, 1);
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Pick up some goods to transport with your Boat at Palamino Docks (see checkpoint on radar).");
					}
					else return SendClientMessageEx(playerid, COLOR_WHITE, "Water shipments are restricted to Level 4+ Shipment Contracter.");
				}
				gPlayerCheckpointStatus[playerid] = CHECKPOINT_LOADTRUCK;
	        }
	        else return SendClientMessageEx(playerid, COLOR_WHITE, "Please ensure that your current checkpoint is destroyed first (you either have material packages, or another existing checkpoint).");
	    }
	    else return SendClientMessageEx(playerid, COLOR_GREY, "You are not driving a Shipment Transport Vehicle!");
	}
	else return SendClientMessageEx(playerid, COLOR_GREY, "You are not a Shipment Contractor!");
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	switch(dialogid) {
		case D_TRUCKDELIVER_WEPCHOICE: {

			if(!response) {
				
				switch(PlayerInfo[playerid][pTruckSkill]) {
					case 0 .. 49: GivePlayerValidWeapon(playerid, WEAPON_COLT45);
					case 50 .. 100: ShowPlayerDialogEx(playerid, D_TRUCKDELIVER_WEPCHOICE, DIALOG_STYLE_LIST, "Select your reward", "9mm\nShotgun", "Select", "");
					case 101 .. 200: ShowPlayerDialogEx(playerid, D_TRUCKDELIVER_WEPCHOICE, DIALOG_STYLE_LIST, "Select your reward", "9mm\nShotgun\nMP5", "Select", "");
					case 201 .. 400: ShowPlayerDialogEx(playerid, D_TRUCKDELIVER_WEPCHOICE, DIALOG_STYLE_LIST, "Select your reward", "9mm\nShotgun\nMP5\nDeagle", "Select", "");
					case 401: ShowPlayerDialogEx(playerid, D_TRUCKDELIVER_WEPCHOICE, DIALOG_STYLE_LIST, "Select your reward", "9mm\nShotgun\nMP5\nDeagle\nAK-47", "Select", "");
					default: ShowPlayerDialogEx(playerid, D_TRUCKDELIVER_WEPCHOICE, DIALOG_STYLE_LIST, "Select your reward", "9mm\nShotgun\nMP5\nDeagle\nAK-47", "Select", "");
				}
				return 1;
			}
			else {
				switch(listitem) {
					case 0: GivePlayerValidWeapon(playerid, WEAPON_COLT45);
					case 1: GivePlayerValidWeapon(playerid, WEAPON_SHOTGUN);
					case 2: GivePlayerValidWeapon(playerid, WEAPON_MP5);
					case 3: GivePlayerValidWeapon(playerid, WEAPON_DEAGLE);
					case 4: GivePlayerValidWeapon(playerid, WEAPON_AK47);
				}
				return 1;
			}
		}
	}
	return 0;
}