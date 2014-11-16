/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Crate System

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

CMD:crates(playerid, params[]) {
	new iGroupID = PlayerInfo[playerid][pMember];
	if((0 <= iGroupID <= MAX_GROUPS) && PlayerInfo[playerid][pRank] >= arrGroupData[iGroupID][g_iCrateIsland])
	{
	    new string[128], zone[64];
	    format(string, sizeof(string), "List of Crates to be delivered (MAX IN PRODUCTION: %d):", MAXCRATES);
	    SendClientMessage(playerid, COLOR_GREEN, string);
	    for(new i = 0; i < sizeof(CrateInfo); i++)
	    {
	        if(CrateInfo[i][crActive])
	        {
				if(CrateInfo[i][InVehicle] == INVALID_VEHICLE_ID)
				{
				    GetDynamicObjectPos(CrateInfo[i][crObject], CrateInfo[i][crX],CrateInfo[i][crY],CrateInfo[i][crZ]);
				}
				else
				{
					GetVehiclePos(CrateInfo[i][InVehicle],CrateInfo[i][crX],CrateInfo[i][crY],CrateInfo[i][crZ]);
					CrateInfo[i][crVW] = GetVehicleVirtualWorld(CrateInfo[i][InVehicle]);
				}
	            if(CrateInfo[i][crInt] != 0 || CrateInfo[i][crVW] != 0 || CrateInfo[i][crZ] > 500)
	            {
	                format(zone, sizeof(zone), "*Weak Signal* (( Garage / Interior ))");
	            }
	            else Get3DZone(CrateInfo[i][crX],CrateInfo[i][crY],CrateInfo[i][crZ],zone, sizeof(zone));
	        	format(string, sizeof(string), "Crate Serial Number: #%d  Location: %s  In a Vehicle: %s", i, zone,(CrateInfo[i][InVehicle] != INVALID_VEHICLE_ID) ? ("Yes") : ("No"));
	        	SendClientMessageEx(playerid, COLOR_GRAD2, string);
	       	}
	    }
	}
	else
	{
	    SendClientMessageEx(playerid, COLOR_GRAD2, " You do not have access to this information. ");
	}
	return 1;
}

CMD:destroycrate(playerid, params[]) {
	if(IsACop(playerid))
	{
	    if(servernumber == 2)
		{
		    SendClientMessage(playerid, COLOR_WHITE, "This command is disabled!");
		    return 1;
		}
	    new string[128], CrateFound;
	    new Float:cX, Float: cY, Float: cZ;
		for(new i = 0; i < sizeof(CrateInfo); i++)
	    {
	    	if(CrateInfo[i][crActive])
	    	{
	    		GetDynamicObjectPos(CrateInfo[i][crObject], cX, cY, cZ);
	    		if(IsPlayerInRangeOfPoint(playerid, 5.0, cX, cY, cZ))
	    		{
	    		    DestroyDynamicObject(CrateInfo[i][crObject]);
	    		    DestroyDynamic3DTextLabel(CrateInfo[i][crLabel]);
	    		    CrateInfo[i][crActive] = 0;
	    		    CrateInfo[i][InVehicle] = INVALID_VEHICLE_ID;
				    CrateInfo[i][crObject] = INVALID_OBJECT_ID;
				    CrateInfo[i][crX] = 0;
				    CrateInfo[i][crY] = 0;
				    CrateInfo[i][crZ] = 0;
					CrateFound = 1;
					mysql_SaveCrates();
					break;
	    		}
	    	}
	    }
	    if(!CrateFound) return SendClientMessageEx(playerid, COLOR_GRAD2, "You're not near any crates!");
		format(string, sizeof(string), "* %s seizes the weapon crate.", GetPlayerNameEx(playerid));
		ProxDetector(25.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	}
	else
	{
	    SendClientMessageEx(playerid, COLOR_GRAD2, " You are not authorized. ");
	}
	return 1;
}

CMD:adestroycrate(playerid, params[]) {
	if(PlayerInfo[playerid][pAdmin] >= 4)
	{
	    if(servernumber == 2)
		{
		    SendClientMessage(playerid, COLOR_WHITE, "This command is disabled!");
		    return 1;
		}
	    new i;
	    if(sscanf(params, "d", i)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /adestroycrate [crate id]");
		if(i < 0 || i > MAX_CRATES) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /adestroycrate [crate id]");
	    new string[128];
    	if(CrateInfo[i][crActive])
    	{
		    DestroyDynamicObject(CrateInfo[i][crObject]);
		    DestroyDynamic3DTextLabel(CrateInfo[i][crLabel]);
		    CrateInfo[i][crActive] = 0;
		    CrateInfo[i][InVehicle] = INVALID_VEHICLE_ID;
		    CrateInfo[i][crObject] = INVALID_OBJECT_ID;
		    CrateInfo[i][crX] = 0;
		    CrateInfo[i][crY] = 0;
		    CrateInfo[i][crZ] = 0;
		    format(string, sizeof(string), "* You have destroyed crate id %d.", i);
			SendClientMessage(playerid, COLOR_GRAD2, string);
			mysql_SaveCrates();
			return 1;
    	}
	    else {
			return SendClientMessageEx(playerid, COLOR_GRAD2, "That crate isn't active!");
		}
	}
	else
	{
	    SendClientMessageEx(playerid, COLOR_GRAD2, " You are not authorized.");
	}
	return 1;
}

CMD:gotocrate(playerid, params[]) {
	if(PlayerInfo[playerid][pAdmin] >= 4)
	{
	    new i;
	    if(sscanf(params, "d", i)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /gotocrate [crate id]");
		if(i < 0 || i > MAX_CRATES) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /gotocrate [crate id]");
    	if(CrateInfo[i][crActive])
    	{
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, CrateInfo[i][crX],CrateInfo[i][crY],CrateInfo[i][crZ]);
				LinkVehicleToInterior(tmpcar, CrateInfo[i][crInt]);
				SetVehicleVirtualWorld(tmpcar, CrateInfo[i][crVW]);
				fVehSpeed[playerid] = 0.0;
			}
			else
			{
				SetPlayerPos(playerid, CrateInfo[i][crX],CrateInfo[i][crY],CrateInfo[i][crZ]);
			}
			SendClientMessageEx(playerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(playerid,CrateInfo[i][crInt]);
			PlayerInfo[playerid][pInt] = CrateInfo[i][crInt];
			SetPlayerVirtualWorld(playerid, CrateInfo[i][crVW]);
			PlayerInfo[playerid][pVW] = CrateInfo[i][crVW];
			return 1;
    	}
	    else return SendClientMessageEx(playerid, COLOR_GRAD2, "That crate isn't active!");
	}
	else
	{
	    SendClientMessageEx(playerid, COLOR_GRAD2, " You are not authorized.");
	}
	return 1;
}

CMD:cargo(playerid, params[]) {
	new vehicleid = GetPlayerVehicleID(playerid);
	new string[128];
	if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD2, "You're not in a vehicle.");
	if((DynVeh[vehicleid] != -1 && DynVehicleInfo[DynVeh[vehicleid]][gv_iType] == 1))
	{
	    format(string, sizeof(string), "Loaded Cargo: (Capacity: %d)", DynVehicleInfo[DynVeh[vehicleid]][gv_iLoadMax]);
	    SendClientMessage(playerid, COLOR_GREEN, string);
	    if(GetVehicleModel(vehicleid) == 592)
	    {
	 	    for(new i = 0; i < 6; i++)
		    {
		        if(CrateVehicleLoad[vehicleid][vCrateID][i] != -1)
		        {
		            if(CrateInfo[CrateVehicleLoad[vehicleid][vCrateID][i]][InVehicle] == vehicleid)
		            {
						format(string, sizeof(string), "Crate SN: #%d  High Grade Materials: %d", CrateVehicleLoad[vehicleid][vCrateID][i], CrateInfo[CrateVehicleLoad[vehicleid][vCrateID][i]][GunQuantity]);
						SendClientMessage(playerid, COLOR_GRAD2, string);
					}
					else
					{
					    printf("Bugged crate ID %d deleted from vehicle id %d automatically via %s",  CrateVehicleLoad[vehicleid][vCrateID][i], vehicleid, GetPlayerNameEx(playerid));
					    CrateVehicleLoad[vehicleid][vCrateID][i] = -1;
					}
		        }
		    }
		}
		else
		{
		    for(new i = 0; i < DynVehicleInfo[DynVeh[vehicleid]][gv_iLoadMax]; i++)
		    {
		        if(CrateVehicleLoad[vehicleid][vCrateID][i] != -1)
		        {
		            if(CrateInfo[CrateVehicleLoad[vehicleid][vCrateID][i]][InVehicle] == vehicleid)
		            {
						format(string, sizeof(string), "Crate SN: #%d  High Grade Materials: %d", CrateVehicleLoad[vehicleid][vCrateID][i], CrateInfo[CrateVehicleLoad[vehicleid][vCrateID][i]][GunQuantity]);
						SendClientMessage(playerid, COLOR_GRAD2, string);
					}
					else
					{
					    printf("Bugged crate ID %d deleted from vehicle id %d automatically via %s",  CrateVehicleLoad[vehicleid][vCrateID][i], vehicleid, GetPlayerNameEx(playerid));
					    CrateVehicleLoad[vehicleid][vCrateID][i] = -1;
					}
				}
		    }
		}
	}
	else
	{
	    return SendClientMessageEx(playerid, COLOR_GRAD2, "You aren't in a designated Armored Truck or Plane.");
	}
	return 1;
}

CMD:delivercrate(playerid, params[])
{
    if(servernumber == 2)
	{
	    SendClientMessage(playerid, COLOR_WHITE, "This command is disabled!");
	    return 1;
	}
	new vehicleid = GetPlayerVehicleID(playerid);
	if(DynVeh[vehicleid] != -1 && DynVehicleInfo[DynVeh[vehicleid]][gv_iType] == 1)
	{
	    for(new group; group < MAX_GROUPS; group++)
	    {

		    if(IsPlayerInRangeOfPoint(playerid, 6, arrGroupData[group][g_fCratePos][0], arrGroupData[group][g_fCratePos][1], arrGroupData[group][g_fCratePos][2]))
		    {
		        if(arrGroupData[group][g_iLockerStock] >= MAX_LOCKER_STOCK)
		        {
		            SendClientMessageEx(playerid, COLOR_GRAD2, "This locker is at full capacity and does not require a delivery.");
		            return 1;
		        }
		        if(arrGroupData[group][g_iBudget] < floatround(CRATE_COST * 1.2))
		        {
		            SendClientMessageEx(playerid, COLOR_GRAD2, "This agency cannot afford a crate delivery.");
		            return 1;
		        }
		        if(arrGroupData[group][g_iCratesOrder] == 0)
		        {
		            SendClientMessageEx(playerid, COLOR_GRAD2, "This agency has not placed any crate orders.");
		            return 1;
		        }
		        if(arrGroupData[group][g_iLockerCostType] != 0)
		        {
		            SendClientMessageEx(playerid, COLOR_GRAD2, "This agency is not accepting crate deliveries.");
		            return 1;
		        }
				for(new i = 0; i < DynVehicleInfo[DynVeh[vehicleid]][gv_iLoadMax]; i++)
			    {
			        if(CrateVehicleLoad[vehicleid][vCrateID][i] != -1)
			        {
			            TogglePlayerControllable(playerid, 0);
			            SetTimerEx("DeliverCrate", 1000, 0, "d", playerid);
			            SetPVarInt(playerid, "dc_CrateFound", 1);
			            SetPVarInt(playerid, "delivercratecrateid", CrateVehicleLoad[vehicleid][vCrateID][i]);
                        SetPVarInt(playerid, "DeliverCrateTime", 8);
                        SetPVarInt(playerid, "SecuricarID", vehicleid);
                        SetPVarInt(playerid, "dc_GroupID", group);
                        SetPVarInt(playerid, "dc_i", i);
						break;
			        }
			    }
				break;
		    }
		}
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD2, "You're not in a cargo certified vehicle.");
	return 1;
}

CMD:loadcrate(playerid, params[]) {
	new vehicleid = GetPlayerVehicleID(playerid);
	if(GetVehicleModel(vehicleid) == 530)
	{
		if(CrateVehicleLoad[vehicleid][vForkLoaded])
		{
		    new TruckFound, FreeSlot;
		    TruckFound = INVALID_VEHICLE_ID;
		    FreeSlot = -1;
		    new Float:vx, Float:vy, Float:vz;
		    for(new i = 0; i < sizeof(DynVehicleInfo); i++)
		    {
		        GetPosBehindVehicle(DynVehicleInfo[i][gv_iSpawnedID], vx, vy, vz, -2);
				if(IsPlayerInRangeOfPoint(playerid, 6, vx, vy, vz))
		        {
		            if(DynVehicleInfo[i][gv_iType] == 1 && DynVehicleInfo[i][gv_iSpawnedID] != vehicleid && GetVehicleModel(DynVehicleInfo[i][gv_iSpawnedID]) != 592)
		            {
						TruckFound = DynVehicleInfo[i][gv_iSpawnedID];
						break;
				    }
		        }
		    }
		    if(TruckFound != INVALID_VEHICLE_ID)
		    {
		        new iDvSlotID = DynVeh[TruckFound];
			    for(new i = 0; i < DynVehicleInfo[iDvSlotID][gv_iLoadMax]; i++)
			    {
			        if(CrateVehicleLoad[TruckFound][vCrateID][i] == -1)
			        {
						FreeSlot = i;
						break;
			        }
			    }
			}
			if(TruckFound == INVALID_VEHICLE_ID) return SendClientMessageEx(playerid, COLOR_GRAD2, "You're not near a Loaded Crate Vehicle!");
			if(FreeSlot == -1) return SendClientMessageEx(playerid, COLOR_GRAD2, "The truck is fully loaded!");
		    DestroyDynamicObject(CrateVehicleLoad[vehicleid][vForkObject]);
		    CrateVehicleLoad[vehicleid][vForkLoaded] = 0;
		    CrateVehicleLoad[vehicleid][vForkObject] = INVALID_OBJECT_ID;
			CrateVehicleLoad[TruckFound][vCrateID][FreeSlot] = CrateVehicleLoad[vehicleid][vCrateID][0];
			CrateInfo[CrateVehicleLoad[TruckFound][vCrateID][FreeSlot]][InVehicle] = TruckFound;
		    CrateVehicleLoad[vehicleid][vCrateID][0] = -1;
		    SendClientMessageEx(playerid, COLOR_GRAD2, "You loaded a crate onto the vehicle!");
		}
		else
		{
		    return SendClientMessageEx(playerid, COLOR_GRAD2, "You don't have a crate loaded!");
		}
	}
	else
	{
	    return SendClientMessageEx(playerid, COLOR_GRAD2, "You're not in a forklift!");
	}
	return 1;
}

CMD:unloadcrate(playerid, params[]) {
	new vehicleid = GetPlayerVehicleID(playerid);
	if(GetVehicleModel(vehicleid) == 530)
	{
		if(!CrateVehicleLoad[vehicleid][vForkLoaded])
		{
		    new TruckFound, UsedSlot;
		    TruckFound = INVALID_VEHICLE_ID;
		    UsedSlot = -1;
		    new Float:vx, Float:vy, Float:vz;
		    for(new i = 0; i < sizeof(DynVehicleInfo); i++)
		    {
		        GetPosBehindVehicle(DynVehicleInfo[i][gv_iSpawnedID], vx, vy, vz, -2);
				if(IsPlayerInRangeOfPoint(playerid, 6, vx, vy, vz))
		        {
		            if(DynVehicleInfo[i][gv_iType] == 1 && DynVehicleInfo[i][gv_iSpawnedID] != vehicleid && GetVehicleModel(DynVehicleInfo[i][gv_iSpawnedID]) != 592)
		            {
						TruckFound = DynVehicleInfo[i][gv_iSpawnedID];
						break;
				    }
		        }
		    }
		    if(TruckFound != INVALID_VEHICLE_ID)
		    {
		        new iDvSlotID = DynVeh[TruckFound];
			    for(new i = 0; i < DynVehicleInfo[iDvSlotID][gv_iLoadMax]; i++)
			    {
			        if(CrateVehicleLoad[TruckFound][vCrateID][i] != -1)
			        {
			            if(CrateInfo[CrateVehicleLoad[TruckFound][vCrateID][i]][InVehicle] == TruckFound)
			            {
							UsedSlot = i;
							break;
						}
						else
						{
						    CrateVehicleLoad[TruckFound][vCrateID][i] = -1;
						}
			        }
			    }
			}
			if(TruckFound == INVALID_VEHICLE_ID) return SendClientMessageEx(playerid, COLOR_GRAD2, "You're not near a Loaded Crate Vehicle!");
			if(UsedSlot == -1) return SendClientMessageEx(playerid, COLOR_GRAD2, "The Truck is empty!");
		    CrateVehicleLoad[vehicleid][vForkLoaded] = 1;
		    CrateInfo[CrateVehicleLoad[TruckFound][vCrateID][UsedSlot]][InVehicle] = vehicleid;
		    CrateVehicleLoad[vehicleid][vCrateID][0] = CrateVehicleLoad[TruckFound][vCrateID][UsedSlot];
		    CrateVehicleLoad[vehicleid][vForkObject] = CreateDynamicObject(964,-1077.59997559,4274.39990234,3.40000010,0.00000000,0.00000000,0.00000000);
			AttachDynamicObjectToVehicle(CrateVehicleLoad[vehicleid][vForkObject], vehicleid, 0, 0.9, 0, 0, 0, 0);
			CrateVehicleLoad[TruckFound][vCrateID][UsedSlot] = -1;
		    SendClientMessageEx(playerid, COLOR_GRAD2, "You've unloaded a crate from the vehicle!");
		}
		else
		{

		    SendClientMessageEx(playerid, COLOR_GRAD2, "Unload your forklift first!");
		    return 1;

		}
	}
	else
	{
	    return SendClientMessageEx(playerid, COLOR_GRAD2, "You're not in a forklift!");
	}
	return 1;
}

CMD:loadplane(playerid, params[]) {
	new vehicleid = GetPlayerVehicleID(playerid);
	if(GetVehicleModel(vehicleid) == 530)
	{
		if(CrateVehicleLoad[vehicleid][vForkLoaded])
		{
		    new PlaneFound, FreeSlot;
		    PlaneFound = INVALID_VEHICLE_ID;
		    FreeSlot = -1;
		    new Float:vx, Float:vy, Float:vz;
		    for(new i = 0; i < sizeof(DynVehicleInfo); i++)
		    {
		        if(DynVehicleInfo[i][gv_iSpawnedID] != INVALID_VEHICLE_ID) { GetPosBehindVehicle(DynVehicleInfo[i][gv_iSpawnedID], vx, vy, vz, -8); }
		        else continue;
				if(IsPlayerInRangeOfPoint(playerid, 6, vx, vy, vz))
		        {
		            if(GetVehicleModel(DynVehicleInfo[i][gv_iSpawnedID]) == 592 && DynVehicleInfo[i][gv_iType] == 1)
		            {
						PlaneFound = DynVehicleInfo[i][gv_iSpawnedID];
						break;
				    }
		        }
		    }
		    if(PlaneFound != INVALID_VEHICLE_ID)
		    {
			    for(new i = 0; i < 6; i++)
			    {
			        if(CrateVehicleLoad[PlaneFound][vCrateID][i] == -1)
			        {
						FreeSlot = i;
						break;
			        }
			    }
			}
			if(PlaneFound == INVALID_VEHICLE_ID) return SendClientMessageEx(playerid, COLOR_GRAD2, "You're not near a plane!");
			if(FreeSlot == -1) return SendClientMessageEx(playerid, COLOR_GRAD2, "The Plane is fully loaded!");
		    DestroyDynamicObject(CrateVehicleLoad[vehicleid][vForkObject]);
		    CrateVehicleLoad[vehicleid][vForkLoaded] = 0;
		    CrateVehicleLoad[vehicleid][vForkObject] = INVALID_OBJECT_ID;
			CrateVehicleLoad[PlaneFound][vCrateID][FreeSlot] = CrateVehicleLoad[vehicleid][vCrateID][0];
			CrateInfo[CrateVehicleLoad[PlaneFound][vCrateID][FreeSlot]][InVehicle] = PlaneFound;
		    CrateVehicleLoad[vehicleid][vCrateID][0] = -1;
		    SendClientMessageEx(playerid, COLOR_GRAD2, "You loaded a crate onto the plane!");
		}
		else
		{
		    return SendClientMessageEx(playerid, COLOR_GRAD2, "You don't have a crate loaded!");
		}
	}
	else
	{
	    return SendClientMessageEx(playerid, COLOR_GRAD2, "You're not in a forklift!");
	}
	return 1;
}

CMD:planeinfo(playerid, params[]) {
    new PlaneFound, string[128];
    PlaneFound = INVALID_VEHICLE_ID;
    new Float:vx, Float:vy, Float:vz;
    for(new i = 0; i < sizeof(DynVehicleInfo); i++)
    {
        GetPosBehindVehicle(DynVehicleInfo[i][gv_iSpawnedID], vx, vy, vz, -8);
		if(IsPlayerInRangeOfPoint(playerid, 10, vx, vy, vz))
        {
            if(GetVehicleModel(DynVehicleInfo[i][gv_iSpawnedID]) == 592 && DynVehicleInfo[i][gv_iType] == 1)
            {
				PlaneFound = DynVehicleInfo[i][gv_iSpawnedID];
				format(string, sizeof(string), "Plane ID: %d Cargo Information", PlaneFound);
				SendClientMessage(playerid, COLOR_GREEN, string);
				break;
		    }
        }
    }
    if(PlaneFound != INVALID_VEHICLE_ID)
    {
	    for(new i = 0; i < 6; i++)
	    {
			format(string, sizeof(string), "Cargo Slot %d Crate SN %d",i, CrateVehicleLoad[PlaneFound][vCrateID][i]);
			SendClientMessage(playerid, COLOR_GRAD2, string);
	    }
	}
	if(PlaneFound == INVALID_VEHICLE_ID) return SendClientMessageEx(playerid, COLOR_GRAD2, "You're not near a plane!");
	return 1;
}

CMD:unloadplane(playerid, params[]) {
	new vehicleid = GetPlayerVehicleID(playerid);
	if(GetVehicleModel(vehicleid) == 530)
	{
		if(!CrateVehicleLoad[vehicleid][vForkLoaded])
		{
		    new PlaneFound, UsedSlot;
		    PlaneFound = INVALID_VEHICLE_ID;
		    UsedSlot = -1;
		    new Float:vx, Float:vy, Float:vz;
		    for(new i = 0; i < sizeof(DynVehicleInfo); i++)
		    {
		        GetPosBehindVehicle(DynVehicleInfo[i][gv_iSpawnedID], vx, vy, vz, -8);
				if(IsPlayerInRangeOfPoint(playerid, 6, vx, vy, vz))
		        {
		            if(GetVehicleModel(DynVehicleInfo[i][gv_iSpawnedID]) == 592 && DynVehicleInfo[i][gv_iType] == 1)
		            {
						PlaneFound = DynVehicleInfo[i][gv_iSpawnedID];
						break;
				    }
		        }
		    }
		    if(PlaneFound != INVALID_VEHICLE_ID)
		    {
			    for(new i = 0; i < 6; i++)
			    {
					if(CrateVehicleLoad[PlaneFound][vCrateID][i] != -1)
					{
			            if(CrateInfo[CrateVehicleLoad[PlaneFound][vCrateID][i]][InVehicle] == PlaneFound)
			            {
							UsedSlot = i;
							break;
						}
						else
						{
						    printf("Bugged crate ID %d deleted from vehicle id %d automatically via %s",  CrateVehicleLoad[PlaneFound][vCrateID][i], PlaneFound, GetPlayerNameEx(playerid));
						    CrateVehicleLoad[PlaneFound][vCrateID][i] = -1;
						}
					}
			    }
			}
			if(PlaneFound == INVALID_VEHICLE_ID) return SendClientMessageEx(playerid, COLOR_GRAD2, "You're not near a plane!");
			if(UsedSlot == -1) return SendClientMessageEx(playerid, COLOR_GRAD2, "The Plane is empty!");
		    CrateVehicleLoad[vehicleid][vForkLoaded] = 1;
		    CrateInfo[CrateVehicleLoad[PlaneFound][vCrateID][UsedSlot]][InVehicle] = vehicleid;
		    CrateVehicleLoad[vehicleid][vCrateID][0] = CrateVehicleLoad[PlaneFound][vCrateID][UsedSlot];
		    CrateVehicleLoad[vehicleid][vForkObject] = CreateDynamicObject(964,-1077.59997559,4274.39990234,3.40000010,0.00000000,0.00000000,0.00000000);
			AttachDynamicObjectToVehicle(CrateVehicleLoad[vehicleid][vForkObject], vehicleid, 0, 0.9, 0, 0, 0, 0);
			CrateVehicleLoad[PlaneFound][vCrateID][UsedSlot] = -1;
		    SendClientMessageEx(playerid, COLOR_GRAD2, "You've unloaded a crate from the plane!");
		}
		else
		{

		    SendClientMessageEx(playerid, COLOR_GRAD2, "Unload your forklift first!");
		    return 1;

		}
	}
	else
	{
	    return SendClientMessageEx(playerid, COLOR_GRAD2, "You're not in a forklift!");
	}
	return 1;
}

CMD:loadforklift(playerid, params[]) {
	new vehicleid = GetPlayerVehicleID(playerid);
	if(GetVehicleModel(vehicleid) == 530)
	{
	    new string[128];
		if(servernumber == 2)
		{
		    SendClientMessage(playerid, COLOR_WHITE, "This command is disabled!");
		    return 1;
		}
		if(PlayerInfo[playerid][pConnectHours] < 25)
	    {
			format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s has attempted to load a crate with only %d playing hours.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pConnectHours]);
			ABroadCast(COLOR_YELLOW, string, 4);
	        return SendClientMessage(playerid, COLOR_GRAD2, " You've not played long enough to do this!");
	    }
		if(!CrateVehicleLoad[vehicleid][vForkLoaded])
		{
		    new CrateFound;
		    //if(IsPlayerInRangeOfPoint(playerid, 5, -2114.1, -1723.5, 11984.5))
			if(IsPlayerInRangeOfPoint(playerid, 5, -2136.0332,-1572.6605,3551.0564))
		    {
				Streamer_Update(playerid);
		        if(CountCrates() < MAXCRATES)
		        {
		            if(Tax < CRATE_COST)
		            {
		                SendClientMessageEx(playerid, COLOR_GRAD2, "The San Andreas Government cannot afford this crate");
		                return 1;
		            }
		            if(LoadForkliftStatus)
		            {
		                SendClientMessageEx(playerid, COLOR_GRAD2, "A Crate is already being loaded.");
		                return 1;
		            }
		            if(GetPVarInt(playerid, "LoadForkliftTime") > 0)
		            {
		                SendClientMessageEx(playerid, COLOR_WHITE, "You are currently loading your forklift!");
						return 1;
		            }
		            if(Streamer_IsItemVisible(playerid, STREAMER_TYPE_OBJECT, CrateLoad))
		            {
		                LoadForkliftStatus = 1;
		                SetPVarInt(playerid, "LoadForkliftTime", 5);
		                SetPVarInt(playerid, "ForkliftID", vehicleid);
						if(PlayerInfo[playerid][pSpeedo])
						{
							PlayerInfo[playerid][pSpeedo] = 0;
							SetPVarInt(playerid, "Speedo", 1);
						}
		                SetTimerEx("LoadForklift", 1000, 0, "d", playerid);
						TogglePlayerControllable(playerid, 0);
					    CrateFound = 1;
					}
					else return SendClientMessage(playerid, COLOR_GRAD2, " Please wait.  There is another crate in production. ");
				}
				else return SendClientMessage(playerid, COLOR_GRAD2, " This facility is at full capacity.  Please wait for the current outstanding crates to be delivered.");
			}
			else
			{
			    new Float:cX, Float: cY, Float: cZ;
				for(new i = 0; i < sizeof(CrateInfo); i++)
			    {
			    	if(CrateInfo[i][crActive])
			    	{
			    		GetDynamicObjectPos(CrateInfo[i][crObject], cX, cY, cZ);
			    		if(IsPlayerInRangeOfPoint(playerid, 5.0, cX, cY, cZ))
			    		{
			    		    DestroyDynamicObject(CrateInfo[i][crObject]);
			    		    CrateInfo[i][InVehicle] = vehicleid;
			    		    CrateVehicleLoad[vehicleid][vCrateID][0] = i;
			    		    CrateVehicleLoad[vehicleid][vForkLoaded] = 1;
						    CrateVehicleLoad[vehicleid][vForkObject] = CreateDynamicObject(964,-1077.59997559,4274.39990234,3.40000010,0.00000000,0.00000000,0.00000000);
							AttachDynamicObjectToVehicle(CrateVehicleLoad[vehicleid][vForkObject], vehicleid, 0, 0.9, 0, 0, 0, 0);
							DestroyDynamic3DTextLabel(CrateInfo[i][crLabel]);
							CrateFound = 1;
							Streamer_Update(playerid);
							new Float: pX, Float: pY, Float: pZ;
							GetPlayerPos(playerid, pX, pY, pZ);
							SetPVarFloat(playerid, "tpForkliftX", pX);
					 		SetPVarFloat(playerid, "tpForkliftY", pY);
					  		SetPVarFloat(playerid, "tpForkliftZ", pZ);
							SetPVarInt(playerid, "tpForkliftTimer", 80);
							SetPVarInt(playerid, "tpForkliftID", GetPlayerVehicleID(playerid));
							SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_CRATETIMER);
							break;
			    		}
			    	}
			    }
			}
			if(!CrateFound) return SendClientMessageEx(playerid, COLOR_GRAD2, "You're not near any crates!");

		}
		else
		{
		    new Float: vX, Float: vY, Float: vZ;
		    GetVehiclePos(vehicleid, vX, vY, vZ);
		    GetXYInFrontOfPlayer(playerid, vX, vY, 2);
		    DestroyDynamicObject(CrateVehicleLoad[vehicleid][vForkObject]);
		    CrateVehicleLoad[vehicleid][vForkObject] = INVALID_OBJECT_ID;
		    CrateVehicleLoad[vehicleid][vForkLoaded] = 0;
		    CrateVehicleLoad[vehicleid][vCrateID][0] = -1;
		    for(new i = 0; i < sizeof(CrateInfo); i++)
		    {
				if(CrateInfo[i][InVehicle] == vehicleid)
				{
					if(CrateInfo[i][crActive])
					{
					    CrateInfo[i][InVehicle] = INVALID_VEHICLE_ID;
					    CrateInfo[i][crX] = vX;
					    CrateInfo[i][crY] = vY;
					    CrateInfo[i][crZ] = vZ-0.8;
					    CrateInfo[i][crVW] = GetPlayerVirtualWorld(playerid);
					    CrateInfo[i][crInt] = GetPlayerInterior(playerid);
					    GetPlayerName(playerid, CrateInfo[i][crPlacedBy], MAX_PLAYER_NAME);
					    CrateInfo[i][crObject] = CreateDynamicObject(964,vX,vY,vZ-0.8,0.00000000,0.00000000,0.00000000, CrateInfo[i][crVW], CrateInfo[i][crInt]);
					    format(string, sizeof(string), "Serial Number: #%d\n High Grade Materials: %d/50\n (( Dropped by: %s ))", i, CrateInfo[i][GunQuantity], CrateInfo[i][crPlacedBy]);
					    CrateInfo[i][crLabel] = CreateDynamic3DTextLabel(string, COLOR_ORANGE, CrateInfo[i][crX],CrateInfo[i][crY],CrateInfo[i][crZ]+1, 10.0, _, _, 1, CrateInfo[i][crVW], CrateInfo[i][crInt], _, 20.0);
						Streamer_Update(playerid);
	                    mysql_SaveCrates();
						break;
					}
					else return SendClientMessageEx(playerid, COLOR_GRAD2, "The crate has vanished!");
				}
		    }
		    SendClientMessageEx(playerid, COLOR_GRAD2, " Crate unloaded onto the ground!");
		    return 1;

		}
	}
	else
	{
	    return SendClientMessageEx(playerid, COLOR_GRAD2, "You're not in a forklift!");
	}
	return 1;
}

CMD:cratelimit(playerid, params[]) {
	if(PlayerInfo[playerid][pMember] == INVALID_GROUP_ID) return 1;
	new iGroupID = PlayerInfo[playerid][pMember];
    if(servernumber == 2)
	{
	    SendClientMessage(playerid, COLOR_WHITE, "This command is disabled!");
	    return 1;
	}
    if(PlayerInfo[playerid][pRank] >= arrGroupData[iGroupID][g_iCrateIsland])
    {
		new string[128];
		new moneys;
	    if(sscanf(params, "d", moneys)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /cratelimit [5-50] (Limits the total production of crates)");
		if(moneys < 5 || moneys > MAX_CRATES) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /cratelimit [5-50] (Limits the total production of crates)");
		MAXCRATES = moneys;
		format(string, sizeof(string), "* You have restricted weapon crate production to %d", moneys);
		SendClientMessageEx(playerid, COLOR_YELLOW, string);
		format(string, sizeof(string), "** %s has restricted weapon crate production to %d", GetPlayerNameEx(playerid), moneys);
		for(new i = 0; i < MAX_PLAYERS; ++i)
		{
			if(IsPlayerConnected(i))
			{
				iGroupID = PlayerInfo[i][pMember];
				if( (0 <= iGroupID < MAX_GROUPS) && PlayerInfo[i][pRank] >= arrGroupData[iGroupID][g_iCrateIsland] )
				{
					if(arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance] == arrGroupData[iGroupID][g_iAllegiance])
					{
						SendClientMessageEx(i, DEPTRADIO, string);
					}
				}
			}	
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, " Only the SAAS has the authority to do this! ");
	}
	return 1;
}

CMD:igps(playerid, params[]) {
	return cmd_islandgps(playerid, params);
}

CMD:islandgps(playerid, params[]) {
	new vehicleid = GetPlayerVehicleID(playerid);
	if(DynVeh[vehicleid] != -1 && DynVehicleInfo[DynVeh[vehicleid]][gv_iType] == 1 && IsAPlane(vehicleid) || IsACop(playerid))
	{
	    SetPVarInt(playerid,"igps", 1);
		DisablePlayerCheckpoint(playerid);
		SetPlayerCheckpoint(playerid, -1173.3702,4491.6836,4.4765, 15.0);
	}
	else
	{
	    return SendClientMessageEx(playerid, COLOR_GRAD2, " You do not have access to the GPS co-ordinates");
	}
	return 1;
}

CMD:announcetakeoff(playerid, params[]) {
	new engine,lights,alarm,doors,bonnet,boot,objective,vehicleid, callsign[24], string[128], zone[64],
	Float:X, Float:Y, Float:Z;
	GetPlayerPos(playerid, X, Y, Z);
	vehicleid = GetPlayerVehicleID(playerid);
	if(DynVeh[vehicleid] != -1 && DynVehicleInfo[DynVeh[vehicleid]][gv_iType] == 1 && GetVehicleModel(vehicleid) == 592)
	{
		format(callsign, sizeof(callsign), "SANAN%d", vehicleid);
	    Get3DZone(X, Y, Z,zone, sizeof(zone));
 		GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
	    if(!IsInRangeOfPoint(-1105.8833,4428.3745,4.4000, X, Y, Z, 800.0) && (engine == VEHICLE_PARAMS_OFF || engine == VEHICLE_PARAMS_UNSET))
	    {
			if((engine == VEHICLE_PARAMS_OFF || engine == VEHICLE_PARAMS_UNSET))
			{
				format(string, sizeof(string), "** Pilot %s: Tower, %s requesting permission to take off from %s, over. **", GetPlayerNameEx(playerid), callsign, zone);
				SendGroupMessage(1, DEPTRADIO, string);
				if(!IsACop(playerid)) SendClientMessage(playerid, DEPTRADIO, string);
		        format(string, sizeof(string), "** Air Traffic Control: %s, you are cleared for takeoff, over. **", callsign);
				SendGroupMessage(1, DEPTRADIO, string);
				if(!IsACop(playerid)) SendClientMessage(playerid, DEPTRADIO, string);
				SendClientMessageEx(playerid, COLOR_WHITE, "Vehicle engine starting, please wait...[10 seconds]");
				SetTimerEx("SetVehicleEngine", 10000, 0, "dd",  vehicleid, playerid);
			}
		}
		else if(engine == VEHICLE_PARAMS_ON)
		{
			SetVehicleEngine(vehicleid, playerid);
		}
		else
		{
		    format(string, sizeof(string), "** Pilot %s: Tower, %s ready for takeoff, over. **", GetPlayerNameEx(playerid), callsign);
			SendGroupMessage(1, DEPTRADIO, string);
			if(!IsACop(playerid)) SendClientMessage(playerid, DEPTRADIO, string);
	        format(string, sizeof(string), "** Air Traffic Control: %s, denied takeoff. Island is under lockdown, over. **", callsign);
			SendGroupMessage(1, DEPTRADIO, string);
			if(!IsACop(playerid)) SendClientMessage(playerid, DEPTRADIO, string);
		}
	}
	return 1;
}

CMD:cgun(playerid, params[]) {
    if(servernumber == 2)
	{
	    SendClientMessage(playerid, COLOR_WHITE, "This command is disabled!");
	    return 1;
	}
	if(IsPlayerInAnyVehicle(playerid))
	{
	    return SendClientMessageEx(playerid, COLOR_GRAD2, "You can't reach into the crate from inside your vehicle! ");
	}
    new Float:cX, Float: cY, Float: cZ, CrateFound;
	for(new i = 0; i < sizeof(CrateInfo); i++)
    {
    	if(CrateInfo[i][crActive])
    	{
    		GetDynamicObjectPos(CrateInfo[i][crObject], cX, cY, cZ);
    		if(IsPlayerInRangeOfPoint(playerid, 3.0, cX, cY, cZ))
    		{
		        if(IsInRangeOfPoint(-1105.8833,4428.3745,4.4000, CrateInfo[i][crX],CrateInfo[i][crY],CrateInfo[i][crZ], 1000.0))
			    {
			        return SendClientMessageEx(playerid, COLOR_GRAD2, "ERROR:  This crate has been sealed shut by the Crate Island's security system! ");
			    }
    		    if(CrateInfo[i][GunQuantity] < 1)
    		    {
    		        SendClientMessageEx(playerid, COLOR_GRAD2, "The crate is empty! ");
    		        DestroyDynamicObject(CrateInfo[i][crObject]);
    		        DestroyDynamic3DTextLabel(CrateInfo[i][crLabel]);
	    		    CrateInfo[i][crActive] = 0;
	    		    CrateInfo[i][InVehicle] = INVALID_VEHICLE_ID;
				    CrateInfo[i][crObject] = 0;
				    CrateInfo[i][crX] = 0;
				    CrateInfo[i][crY] = 0;
				    CrateInfo[i][crZ] = 0;
					CrateFound = 1;
					mysql_SaveCrates();
					break;
    		    }
    		    else
    		    {
	    		    SetPVarInt(playerid, "CrateGuns_CID", i);
	    		    ShowPlayerDialog(playerid, CRATE_GUNMENU, DIALOG_STYLE_LIST, "Select a gun from the Crate",	"Desert Eagle - 4 HG Mats\nSPAS-12 - 8 HG Mats\nMP5 - 5 HG Mats\nM4A1 - 6 HG Mats\nAK-47 - 5 HG Mats\nSniper Rifle - 5 HG Mats\nShotgun - 3 HG Mats\n9mm - 1 HG Mats", "Select", "Cancel");
					CrateFound = 1;
					break;
				}
    		}
    	}
    }
    if(!CrateFound)
    {
    	SendClientMessageEx(playerid, COLOR_GRAD2, "You're not near a crate! ");
    }
    return 1;
}

/*CMD:lockdown(playerid, params[]) {
	new iGroupID = PlayerInfo[playerid][pMember];
    if(PlayerInfo[playerid][pRank] >= arrGroupData[iGroupID][g_iCrateIsland])
    {
		new string[128];
		if(IslandGateStatus == 0)
		{
		    MoveDynamicObject(IslandGate, -1083.90002441,4289.70019531,7.59999990, 0.5);
		    foreach(new i: Player)
		    {
		        if(IsPlayerInRangeOfPoint(i, 500, -1083.90002441,4289.70019531,7.59999990))
		        {
		            SendClientMessageEx(i, COLOR_YELLOW, " UNAUTHORISED INTRUDERS!! LOCKDOWN SEQUENCE INITIATED!!");
					PlayAudioStreamForPlayer(i, "http://sampweb.ng-gaming.net/brendan/siren.mp3", -1083.90002441,4289.70019531,7.59999990, 500, 1);
		        }
		    }
			format(string, sizeof(string), "** %s has initiated a lockdown sequence at the Weapons Manufacturing Facility. **", GetPlayerNameEx(playerid));
			SendGroupMessage(1, DEPTRADIO, string);
			IslandGateStatus = gettime();
			IslandThreatElimTimer = SetTimer("IslandThreatElim", 1800000, 0);
		}
		else
		{
		    SendClientMessageEx(playerid, COLOR_GRAD2, " The facility is already locked down! ");
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, " Only the SAAS has the authority to do this! ");
	}
	return 1;
}

CMD:alockdown(playerid, params[]) {
    if(PlayerInfo[playerid][pAdmin] >= 4)
    {
        new string[128];
		if(IslandGateStatus == 0)
		{
		    MoveDynamicObject(IslandGate, -1083.90002441,4289.70019531,7.59999990, 0.5);
		    //foreach(new i: Player)
			for(new i = 0; i < MAX_PLAYERS; ++i)
			{
				if(IsPlayerConnected(i))
				{
					if(IsPlayerInRangeOfPoint(i, 500, -1083.90002441,4289.70019531,7.59999990))
					{
						SendClientMessageEx(i, COLOR_YELLOW, "** MEGAPHONE **  UNAUTHORISED INTRUDERS!! LOCKDOWN SEQUENCE INITIATED!!");
						PlayAudioStreamForPlayer(i, "http://sampweb.ng-gaming.net/brendan/siren.mp3", -1083.90002441,4289.70019531,7.59999990, 500, 1);
					}
				}	
		    }
		  	format(string, sizeof(string), "** %s has initiated a lockdown sequence at the Weapons Manufacturing Facility. **", GetPlayerNameEx(playerid));
			SendGroupMessage(1, DEPTRADIO, string);
			IslandGateStatus = gettime();
			IslandThreatElimTimer = SetTimer("IslandThreatElim", 900000, 0);
		}
		else
		{
		    KillTimer(IslandThreatElimTimer);
		    IslandThreatElim();
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD3, " You're not authorised to use this command! ");
	}
	return 1;
}*/