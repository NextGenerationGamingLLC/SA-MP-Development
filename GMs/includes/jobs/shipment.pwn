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