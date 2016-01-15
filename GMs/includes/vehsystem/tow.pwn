/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Towing System

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

CMD:tow(playerid, params[])
{
	if(IsPlayerInAnyVehicle(playerid))
	{
		new
			carid = GetPlayerVehicleID(playerid);

		if(IsATowTruck(carid))
		{
			new
				closestcar = GetClosestCar(playerid, carid);

			foreach(new i: Player)
			{
				if(arr_Towing[i] == closestcar || (GetPlayerVehicleID(i) == closestcar && GetPlayerState(i) == 2)) return SendClientMessageEx(playerid, COLOR_GREY, "You can't tow a vehicle which is occupied, or in tow.");
			}

			if(GetDistanceToCar(playerid,closestcar) <= 8 && !IsTrailerAttachedToVehicle(carid)) {
				foreach(new i: Player)
				{
					if(IsAPlane(closestcar) || IsABike(closestcar) || IsASpawnedTrain(closestcar) || IsATrain(closestcar) || IsAHelicopter(closestcar)) {
						return SendClientMessageEx(playerid, COLOR_GRAD2, "You cannot tow this type of vehicle.");
					}
					if(GetPlayerVehicle(i, closestcar) != -1) {

						new
							hKey;

						if(((hKey = PlayerInfo[i][pPhousekey]) != INVALID_HOUSE_ID) && IsPlayerInRangeOfPoint(playerid, 50.0, HouseInfo[hKey][hExteriorX], HouseInfo[hKey][hExteriorY], HouseInfo[hKey][hExteriorZ])
						||((hKey = PlayerInfo[i][pPhousekey2]) != INVALID_HOUSE_ID) && IsPlayerInRangeOfPoint(playerid, 50.0, HouseInfo[hKey][hExteriorX], HouseInfo[hKey][hExteriorY], HouseInfo[hKey][hExteriorZ])
						||((hKey = PlayerInfo[i][pPhousekey3]) != INVALID_HOUSE_ID) && IsPlayerInRangeOfPoint(playerid, 50.0, HouseInfo[hKey][hExteriorX], HouseInfo[hKey][hExteriorY], HouseInfo[hKey][hExteriorZ])) {
							return SendClientMessageEx(playerid, COLOR_GREY, "This vehicle doesn't need to be towed.");
						}
						RemoveVehicleFromMeter(closestcar);
						arr_Towing[playerid] = closestcar;
						SendClientMessageEx(playerid, COLOR_GRAD2, "This vehicle is available for impounding.");
						return AttachTrailerToVehicle(closestcar,carid);
					}
				}	
				SendClientMessageEx(playerid, COLOR_GRAD2, "This vehicle has no registration, it is available for impounding.");
				AttachTrailerToVehicle(closestcar,carid);
				arr_Towing[playerid] = closestcar;
				RemoveVehicleFromMeter(closestcar);
				return 1;
			}
		}
		else if(IsAAircraftTowTruck(carid)) //Tug
		{
			new
				closestcar = GetClosestCar(playerid, carid);
				
			foreach(new i: Player)
			{
				if(arr_Towing[i] == closestcar || (GetPlayerVehicleID(i) == closestcar && GetPlayerState(i) == 2)) return SendClientMessageEx(playerid, COLOR_GREY, "You can't tow a vehicle which is occupied, or in tow.");
			}
			
			if(GetDistanceToCar(playerid,closestcar) <= 8 && !IsTrailerAttachedToVehicle(carid))
			{
				foreach(new i: Player)
				{
					if(IsAPlane(closestcar))
					{
						if(GetPlayerVehicle(i, closestcar) != -1)
						{
							RemoveVehicleFromMeter(closestcar);
							arr_Towing[playerid] = closestcar;
							SendClientMessageEx(playerid, COLOR_GRAD2, "This vehicle is available for impounding.");
							return AttachTrailerToVehicle(closestcar,carid);
						}
					}
					else return SendClientMessageEx(playerid, COLOR_GRAD2, "You can only tow aircrafts with this vehicle!");
				}	
				SendClientMessageEx(playerid, COLOR_GRAD2, "This vehicle has no registration, it is available for impounding.");
				AttachTrailerToVehicle(closestcar,carid);
				arr_Towing[playerid] = closestcar;
				RemoveVehicleFromMeter(closestcar);
			}
		}
		else SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to tow with this vehicle.");
	}
	else SendClientMessageEx(playerid, COLOR_GRAD2, "You need to be inside a vehicle to use this command!");
	return 1;
}

CMD:untow(playerid, params[])
{
	if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You have unhooked the vehicle that you were towing.");
		arr_Towing[playerid] = INVALID_VEHICLE_ID;
		DetachTrailerFromVehicle(GetPlayerVehicleID(playerid));
	}
	else SendClientMessageEx(playerid, COLOR_GRAD1, "You are currently not towing anything.");
	return 1;
}