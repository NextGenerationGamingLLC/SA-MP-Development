#include <YSI\y_hooks>

LoadParkingMeters()
{
	print("[LoadParkingMeters] Loading data from database...");
	mysql_tquery(MainPipeline, "SELECT * FROM parking_meters", "OnLoadParkingMeters", "");
	return 1;
}

RebuildParkingMeter(meterid)
{
	new string[256];
	if(IsValidDynamicObject(ParkingMeterInformation[meterid][ParkingMeterObject])) DestroyDynamicObject(ParkingMeterInformation[meterid][ParkingMeterObject]);
	if(IsValidDynamic3DTextLabel(ParkingMeterInformation[meterid][ParkingMeterText])) DestroyDynamic3DTextLabel(ParkingMeterInformation[meterid][ParkingMeterText]);
	if(ParkingMeterInformation[meterid][MeterActive] == 1)
	{
		format(string, sizeof(string), "{FFFFFF}Parking Meter {AFAFAF}(ID: %d)\n{FFFFFF}Meter Rate: {AFAFAF}$%s Per 5 Minutes\n{FFFFFF}Current Vehicle: {AFAFAF}Vacant\n{FFFFFF}Time Remaining: {AFAFAF}N/A", meterid, number_format(ParkingMeterInformation[meterid][MeterRate]));
		ParkingMeterInformation[meterid][ParkingMeterObject] = CreateDynamicObject(1270, ParkingMeterInformation[meterid][MeterPosition][0], ParkingMeterInformation[meterid][MeterPosition][1], ParkingMeterInformation[meterid][MeterPosition][2], ParkingMeterInformation[meterid][MeterPosition][3], ParkingMeterInformation[meterid][MeterPosition][4], ParkingMeterInformation[meterid][MeterPosition][5], 0, 0);
		ParkingMeterInformation[meterid][ParkingMeterText] = CreateDynamic3DTextLabel(string, COLOR_WHITE, ParkingMeterInformation[meterid][MeterPosition][0], ParkingMeterInformation[meterid][MeterPosition][1], ParkingMeterInformation[meterid][MeterPosition][2] + 0.5, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
	}
	return 1;
}

RemoveVehicleFromMeter(vehicleid)
{
	for(new i = 1; i < sizeof(ParkingMeterInformation); i ++) if(ParkingMeterInformation[i][MeterActive] == 1 && ParkingMeterInformation[i][AssignedVehicle] == vehicleid) ParkingMeterInformation[i][PaymentExpiry] = 0;
	return 1;
}

SaveParkingMeter(meterid)
{
	new string[1500];
	mysql_format(MainPipeline, string, sizeof(string), "UPDATE `parking_meters` SET `MeterActive`=%d, `MeterRate`=%d, `MeterRange`=%f, \
	`MeterPosition0`=%f, `MeterPosition1`=%f, `MeterPosition2`=%f, `MeterPosition3`=%f, `MeterPosition4`=%f, `MeterPosition5`=%f, \
	`ParkedPosition0`=%f, `ParkedPosition1`=%f, `ParkedPosition2`=%f, `ParkedPosition3`=%f WHERE `MeterID`=%d",
	ParkingMeterInformation[meterid][MeterActive], ParkingMeterInformation[meterid][MeterRate], ParkingMeterInformation[meterid][MeterRange],
	ParkingMeterInformation[meterid][MeterPosition][0], ParkingMeterInformation[meterid][MeterPosition][1], ParkingMeterInformation[meterid][MeterPosition][2],
	ParkingMeterInformation[meterid][MeterPosition][3], ParkingMeterInformation[meterid][MeterPosition][4], ParkingMeterInformation[meterid][MeterPosition][5],
	ParkingMeterInformation[meterid][ParkedPosition][0], ParkingMeterInformation[meterid][ParkedPosition][1],
	ParkingMeterInformation[meterid][ParkedPosition][2], ParkingMeterInformation[meterid][ParkedPosition][3], meterid+1);
	mysql_tquery(MainPipeline, string, "OnQueryFinish", "i", SENDDATA_THREAD);
	return 1;
}

GetNearestParkingMeter(playerid)
{
	if(GetPlayerInterior(playerid) != 0 || GetPlayerVirtualWorld(playerid) != 0) return -1;
	new meterid, Float:distance[2];
	meterid = -1;
	distance[0] = 1000000.0;
	for(new i = 0; i < sizeof(ParkingMeterInformation); i ++) 
	{
		if(ParkingMeterInformation[i][MeterActive] == 1 && IsPlayerInRangeOfPoint(playerid, ParkingMeterInformation[i][MeterRange], ParkingMeterInformation[i][MeterPosition][0], ParkingMeterInformation[i][MeterPosition][1], ParkingMeterInformation[i][MeterPosition][2]))
		{
			distance[1] = GetPlayerDistanceFromPoint(playerid, ParkingMeterInformation[i][MeterPosition][0], ParkingMeterInformation[i][MeterPosition][1], ParkingMeterInformation[i][MeterPosition][2]);
			if(distance[1] < distance[0])
			{
				distance[0] = distance[1];
				meterid = i;
			}
		}
	}
	return meterid;
}

strmatch(string1[], string2[], bool:casesensitive = false)
{
	if((strcmp(string1, string2, casesensitive, strlen(string2)) == 0) && (strlen(string2) == strlen(string1))) return true;
	return false;
}

hook OnPlayerConnect(playerid)
{
	EditingMeterID[playerid] = 0;
	return 1;
}

hook OnVehicleDeath(vehicleid)
{
	RemoveVehicleFromMeter(vehicleid);
	return 1;
}

hook OnVehicleSpawn(vehicleid)
{
	RemoveVehicleFromMeter(vehicleid);
	return 1;
}

hook OnGameModeInit()
{
	for(new i = 1; i < sizeof(ParkingMeterInformation); i ++)
	{
		ParkingMeterInformation[i][AssignedVehicle] = INVALID_VEHICLE_ID;
		ParkingMeterInformation[i][PaymentExpiry] = 0;
	}
	return 1;
}

task ParkingMeters[30000]()
{
	new time, string[256];
	for(new i = 1; i < sizeof(ParkingMeterInformation); i ++)
	{
		if(ParkingMeterInformation[i][MeterActive] == 1 && ParkingMeterInformation[i][AssignedVehicle] != INVALID_VEHICLE_ID)
		{
			if(!IsValidVehicle(ParkingMeterInformation[i][AssignedVehicle]) || gettime() >= ParkingMeterInformation[i][PaymentExpiry])
			{
				ParkingMeterInformation[i][AssignedVehicle] = INVALID_VEHICLE_ID;
				ParkingMeterInformation[i][PaymentExpiry] = 0;
				RebuildParkingMeter(i);
			}
			else if(IsValidVehicle(ParkingMeterInformation[i][AssignedVehicle]) && gettime() < ParkingMeterInformation[i][PaymentExpiry])
			{
				time = ParkingMeterInformation[i][PaymentExpiry] - gettime();
				if(time < 60) format(string, sizeof(string), "Less Than 1 Minute");
				else if(time >= 60) format(string, sizeof(string), "%s Minute(s)", number_format(time / 60));
				format(string, sizeof(string), "{FFFFFF}Parking Meter {AFAFAF}(ID: %d)\n{FFFFFF}Meter Rate: {AFAFAF}$%s Per 5 Minutes\n{FFFFFF}Current Vehicle: {AFAFAF}%s\n{FFFFFF}Time Remaining: {AFAFAF}%s", i, number_format(ParkingMeterInformation[i][MeterRate]), VehicleName[GetVehicleModel(ParkingMeterInformation[i][AssignedVehicle]) - 400], string);
				UpdateDynamic3DTextLabelText(ParkingMeterInformation[i][ParkingMeterText], COLOR_WHITE, string);
				if(GetVehicleDistanceFromPoint(ParkingMeterInformation[i][AssignedVehicle], ParkingMeterInformation[i][ParkedPosition][0], ParkingMeterInformation[i][ParkedPosition][1], ParkingMeterInformation[i][ParkedPosition][2]) > 5.0)
				{
					SetVehiclePos(ParkingMeterInformation[i][AssignedVehicle], ParkingMeterInformation[i][ParkedPosition][0], ParkingMeterInformation[i][ParkedPosition][1], ParkingMeterInformation[i][ParkedPosition][2]);
					SetVehicleZAngle(ParkingMeterInformation[i][AssignedVehicle], ParkingMeterInformation[i][ParkedPosition][3]);
				}
			}
		}
	}
	return 1;
}

forward OnLoadParkingMeters();
public OnLoadParkingMeters()
{
	new rows, index, string[32];
	cache_get_row_count(rows);
	while(index < rows)
	{
		cache_get_value_name_int(index, "MeterActive", ParkingMeterInformation[index][MeterActive]);
		cache_get_value_name_int(index, "MeterRate", ParkingMeterInformation[index][MeterRate]); 
		cache_get_value_name_float(index, "MeterRange", ParkingMeterInformation[index][MeterRange]); 
		for(new i = 0; i < 6; i ++)
		{
			format(string, sizeof(string), "MeterPosition%d", i);
			cache_get_value_name_float(index, string, ParkingMeterInformation[index][MeterPosition][i]);
			if(i < 4)
			{
				format(string, sizeof(string), "ParkedPosition%d", i);
				cache_get_value_name_float(index, string, ParkingMeterInformation[index][ParkedPosition][i]);
			}
		}
		if(ParkingMeterInformation[index][MeterActive] == 1) RebuildParkingMeter(index);
		index ++;
	}
	switch(index)
	{
		case 0: print("[Parking Meters] No parking meters loaded.");
		default: printf("[Parking Meters] Loaded %d parking meters.", index);
	}
	return 1;
}

CMD:parkingmeterhelp(playerid, params[])
{
	SendClientMessageEx(playerid, COLOR_WHITE, "** PARKING METER COMMANDS **");
	SendClientMessageEx(playerid, COLOR_GREY, "/rentmeter - Allows you to rent the nearest parking meter.");
	SendClientMessageEx(playerid, COLOR_GREY, "/renewmeter - Allows you to renew the nearest parking meter.");
	SendClientMessageEx(playerid, COLOR_GREY, "/meterstatus - Returns information in regards to the status of the nearest parking meter.");
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "** Admin commands **");
		SendClientMessageEx(playerid, COLOR_GREY, "» /createmeter [Rate] [Range] - Creates a new parking meter at your current position.");
		SendClientMessageEx(playerid, COLOR_GREY, "» /setmeterrate [Meter ID] [Rate] - Changes the specified parking meter's rate.");
		SendClientMessageEx(playerid, COLOR_GREY, "» /setmeterrange [Meter ID] [Range] - Changes the specified parking meter's range.");
		SendClientMessageEx(playerid, COLOR_GREY, "» /gotometer [Meter ID] - Allows you to teleport to a parking meter.");
		SendClientMessageEx(playerid, COLOR_GREY, "» /editmeterposition [Meter ID] [Type] - Allows you to edit the parking meter or parked position of a parking meter.");
		SendClientMessageEx(playerid, COLOR_GREY, "» /deletemeter [Meter ID] - Allows you to delete a parking meter.");
		SendClientMessageEx(playerid, COLOR_GREY, "» /reloadmeters - Allows you reload all parking meters (rebuilds existing parking meters).");
	}
	return 1;
}

CMD:meterhelp(playerid, params[]) return cmd_parkingmeterhelp(playerid, params);

CMD:meterstatus(playerid, params[])
{
	new meterid, string[128];
	meterid = GetNearestParkingMeter(playerid);
	if(meterid == -1 || !IsPlayerInRangeOfPoint(playerid, 2.0, ParkingMeterInformation[meterid][MeterPosition][0], ParkingMeterInformation[meterid][MeterPosition][1], ParkingMeterInformation[meterid][MeterPosition][2])) return SendClientMessageEx(playerid, COLOR_GREY, "You are not in range of a parking meter.");
	format(string, sizeof(string), "** PARKING METER STATUS - METER ID %d: **", meterid);
	SendClientMessageEx(playerid, COLOR_WHITE, string);
	format(string, sizeof(string), "» Rate per five minutes: $%s.", number_format(ParkingMeterInformation[meterid][MeterRate]));
	SendClientMessageEx(playerid, COLOR_GREY, string);
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1)
	{
		format(string, sizeof(string), "» Range: %0.3f meters.", ParkingMeterInformation[meterid][MeterRange]);
		SendClientMessageEx(playerid, COLOR_GREY, string);
	}
	switch(ParkingMeterInformation[meterid][AssignedVehicle])
	{
		case INVALID_VEHICLE_ID: return SendClientMessageEx(playerid, COLOR_GREY, "» Current vehicle: Unoccupied and vacant.");
		default:
		{
			format(string, sizeof(string), "» Current vehicle: %s (ID: %d).", VehicleName[GetVehicleModel(ParkingMeterInformation[meterid][AssignedVehicle]) - 400], ParkingMeterInformation[meterid][AssignedVehicle]);
			SendClientMessageEx(playerid, COLOR_GREY, string);
			return 1;
		}
	}
	return 1;
}

CMD:rentmeter(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessageEx(playerid, COLOR_GREY, "You must be the driver of a vehicle to rent a parking meter.");
	new vehicleid, engine, lights, alarm, doors, bonnet, boot, objective, meterid, string[128];
	meterid = GetNearestParkingMeter(playerid);
	if(meterid == -1) return SendClientMessageEx(playerid, COLOR_GREY, "You are not in range of a parking meter.");
	if(ParkingMeterInformation[meterid][AssignedVehicle] != INVALID_VEHICLE_ID) return SendClientMessageEx(playerid, COLOR_GREY, "This parking meter is already occupied. To add more time and renew it, use (/renewmeter).");
	if(IsTrailerAttachedToVehicle(vehicleid)) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot rent a parking meter with a trailer attached to your vehicle.");
	vehicleid = GetPlayerVehicleID(playerid);
	switch(GetVehicleModel(vehicleid)) 
	{ 
		case 403, 406, 407, 408, 409, 414, 416, 417, 423, 425, 427, 428, 430, 431, 432, 433, 435, 437, 443, 444, 446, 447, 449, 450, 452, 453, 454, 455, 456, 460, 464, 465, 469, 
		472, 473, 476, 484, 486, 487, 488, 493, 497, 498, 499, 501, 511, 512, 513, 514, 515, 519, 520, 524, 532, 537, 538, 544, 548, 553, 556, 557, 563, 564, 569, 570, 577, 578, 
		584, 588, 590, 591, 592, 593, 594, 595, 606, 607, 608, 609, 610, 611: return SendClientMessageEx(playerid, COLOR_GREY, "You cannot rent a parking meter with this vehicle."); 
	}
	if(GetPlayerCash(playerid) < ParkingMeterInformation[meterid][MeterRate])
	{
		format(string, sizeof(string), "You cannot afford the initial down payment for this parking meter ($%s).", number_format(ParkingMeterInformation[meterid][MeterRate]));
		SendClientMessageEx(playerid, COLOR_GREY, string);
		return 1;
	}
	ParkingMeterInformation[meterid][AssignedVehicle] = vehicleid;
	ParkingMeterInformation[meterid][PaymentExpiry] = gettime() + 300;
	GivePlayerCash(playerid, -ParkingMeterInformation[meterid][MeterRate]);
	Tax += ParkingMeterInformation[meterid][MeterRate];
	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	if(engine == VEHICLE_PARAMS_ON)
	{
		SetVehicleEngine(vehicleid, playerid);
		format(string, sizeof(string), "{FF8000}** {C2A2DA}%s turns the key in the ignition and the engine stops.", GetPlayerNameEx(playerid));
		ProxDetector(30.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
	}
	format(string, sizeof(string), "You have rented this parking meter for $%s. You have been given five minutes.", number_format(ParkingMeterInformation[meterid][MeterRate]));
	SendClientMessageEx(playerid, COLOR_WHITE, string);
	format(string, sizeof(string), "To add more time to this parking meter, use (/renewmeter). Meter rate: $%s per five minutes.", number_format(ParkingMeterInformation[meterid][MeterRate]));
	SendClientMessageEx(playerid, COLOR_WHITE, string);
	ParkingMeters();
	return 1;
}

CMD:renewmeter(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return SendClientMessageEx(playerid, COLOR_GREY, "You must be on foot to renew a parking meter.");
	new meterid, string[128];
	meterid = GetNearestParkingMeter(playerid);
	if(meterid == -1 || !IsPlayerInRangeOfPoint(playerid, 2.0, ParkingMeterInformation[meterid][MeterPosition][0], ParkingMeterInformation[meterid][MeterPosition][1], ParkingMeterInformation[meterid][MeterPosition][2])) return SendClientMessageEx(playerid, COLOR_GREY, "You are not in range of a parking meter.");
	if(ParkingMeterInformation[meterid][AssignedVehicle] == INVALID_VEHICLE_ID) return SendClientMessageEx(playerid, COLOR_GREY, "This parking meter is not currently occupied by a vehicle.");
	if(GetPlayerCash(playerid) < ParkingMeterInformation[meterid][MeterRate])
	{
		format(string, sizeof(string), "You cannot afford the renewal payment for this parking meter ($%s).", number_format(ParkingMeterInformation[meterid][MeterRate]));
		SendClientMessageEx(playerid, COLOR_GREY, string);
		return 1;
	}
	if(ParkingMeterInformation[meterid][PaymentExpiry] - gettime() >= 1800) return SendClientMessageEx(playerid, COLOR_GREY, "This parking meter cannot be renewed at this time (time exceed maximum amount).");
	ParkingMeterInformation[meterid][PaymentExpiry] += 300;
	GivePlayerCash(playerid, -ParkingMeterInformation[meterid][MeterRate]);
	Tax += ParkingMeterInformation[meterid][MeterRate];
	format(string, sizeof(string), "You have renewed this parking meter by five minutes for $%s.", number_format(ParkingMeterInformation[meterid][MeterRate]));
	SendClientMessageEx(playerid, COLOR_WHITE, string);
	format(string, sizeof(string), "{FF8000}** {C2A2DA}%s takes out some money, depositing it into the parking meter.", GetPlayerNameEx(playerid));
	ProxDetector(30.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
	ParkingMeters();
	return 1;
}

CMD:editmeterposition(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1) return SendClientMessageEx(playerid, COLOR_GREY, "You are unauthorized to use this command.");
	if(GetPlayerInterior(playerid) != 0 || GetPlayerVirtualWorld(playerid) != 0) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot use this command inside an interior or virtual world.");
	new meterid, vehicleid, Float:position[4], name[10], string[128];
	if(sscanf(params, "ds[10]", meterid, name)) return SendClientMessageEx(playerid, COLOR_GREY, "[USAGE]: /editmeterposition [Meter ID] [Type (Meter, Parked, ToMe)]");
	if(meterid <= 0 || meterid >= MAX_PARKING_METERS)
	{
		format(string, sizeof(string), "The specified parking meter ID must be between 1 and %s.", number_format(MAX_PARKING_METERS - 1));
		SendClientMessageEx(playerid, COLOR_GREY, string);
		return 1;
	}
	if(ParkingMeterInformation[meterid][MeterActive] == 0) return SendClientMessageEx(playerid, COLOR_GREY, "The specified parking meter isn't currently active.");
	if(strlen(name) < 4 || strlen(name) > 6) return SendClientMessageEx(playerid, COLOR_GREY, "Invalid parking meter type specified. Types: Meter, Parked, ToMe.");
	if(!strmatch(name, "Meter", true) && !strmatch(name, "Parked", true)&& !strmatch(name, "ToMe", true)) return SendClientMessageEx(playerid, COLOR_GREY, "Invalid parking meter type specified. Types: Meter, Parked, ToMe.");
	if(strmatch(name, "Meter", true))
	{
		EditingMeterID[playerid] = meterid;
		EditDynamicObject(playerid, ParkingMeterInformation[meterid][ParkingMeterObject]);
		format(string, sizeof(string), "You are now editing the position of parking meter ID %d.", meterid);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		return 1;
	}
	switch(GetPlayerState(playerid))
	{
		case PLAYER_STATE_ONFOOT:
		{
			GetPlayerPos(playerid, position[0], position[1], position[2]);
			GetPlayerFacingAngle(playerid, position[3]);
		}
		case PLAYER_STATE_DRIVER, PLAYER_STATE_PASSENGER:
		{
			vehicleid = GetPlayerVehicleID(playerid);
			GetVehiclePos(vehicleid, position[0], position[1], position[2]);
			GetVehicleZAngle(vehicleid, position[3]);
		}
	}
	if(strmatch(name, "Parked", true))
	{
		for(new i = 0; i < 4; i ++) ParkingMeterInformation[meterid][ParkedPosition][i] = position[i];
		SaveParkingMeter(meterid);
		RebuildParkingMeter(meterid);
		format(string, sizeof(string), "You have updated the parked position of parking meter ID %d.", meterid);
		SendClientMessageEx(playerid, COLOR_YELLOW, string);
		format(string, sizeof(string), "%s updated the parked position of parking meter ID %d to %0.3f, %0.3f, %0.3f, %0.3f.", GetPlayerNameEx(playerid), meterid, position[0], position[1], position[2], position[3]);
		Log("logs/admin.log", string);
		return 1;
	}
	if(strmatch(name, "ToMe", true))
	{
		for(new i = 0; i < 3; i ++) ParkingMeterInformation[meterid][MeterPosition][i] = position[i];
		ParkingMeterInformation[meterid][MeterPosition][3] = 0.0;
		ParkingMeterInformation[meterid][MeterPosition][4] = 0.0;
		ParkingMeterInformation[meterid][MeterPosition][5] = position[3];
		SaveParkingMeter(meterid);
		RebuildParkingMeter(meterid);
		format(string, sizeof(string), "You have updated the position of parking meter ID %d.", meterid);
		SendClientMessageEx(playerid, COLOR_YELLOW, string);
		format(string, sizeof(string), "%s updated the position of parking meter ID %d to %0.3f, %0.3f, %0.3f, %0.3f, %0.3f, %0.3f.", GetPlayerNameEx(playerid), meterid, position[0], position[1], position[2], 0.0, 0.0, position[3]);
		Log("logs/admin.log", string);
		return 1;
	}
	return 1;
}

CMD:createmeter(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1) return SendClientMessageEx(playerid, COLOR_GREY, "You are unauthorized to use this command.");
	if(GetPlayerInterior(playerid) != 0 || GetPlayerVirtualWorld(playerid) != 0) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot use this command inside an interior or virtual world.");
	new rate, meterid, Float:range, Float:position[4], string[128];
	if(sscanf(params, "df", rate, range)) return SendClientMessageEx(playerid, COLOR_GREY, "[USAGE]: /createmeter [Rate] [Range]");
	if(rate < 1 || rate > 250000) return SendClientMessageEx(playerid, COLOR_GREY, "The specified rate cannot be under $1 or over $250,000.");
	if(range < 3.5 || range > 25.0) return SendClientMessageEx(playerid, COLOR_GREY, "The specified range cannot be under 3.5 meters or over 25 meters.");
	meterid = -1;
	for(new i = 1; i < sizeof(ParkingMeterInformation); i ++)
	{
		if(ParkingMeterInformation[i][MeterActive] == 0)
		{
			meterid = i;
			break;
		}
	}
	if(meterid == -1)
	{
		format(string, sizeof(string), "The maximum amount of parking meters has been created (%s).", number_format(MAX_PARKING_METERS));
		SendClientMessageEx(playerid, COLOR_GREY, string);
		return 1;
	}
	GetPlayerPos(playerid, position[0], position[1], position[2]);
	GetPlayerFacingAngle(playerid, position[3]);
	ParkingMeterInformation[meterid][MeterActive] = 1;
	ParkingMeterInformation[meterid][MeterRate] = rate;
	ParkingMeterInformation[meterid][MeterRange] = range;
	for(new i = 0; i < 3; i ++)
	{
		ParkingMeterInformation[meterid][MeterPosition][i] = position[i];
		ParkingMeterInformation[meterid][ParkedPosition][i] = position[i];
	}
	ParkingMeterInformation[meterid][MeterPosition][3] = 0.0;
	ParkingMeterInformation[meterid][MeterPosition][4] = 0.0;
	ParkingMeterInformation[meterid][MeterPosition][5] = position[3];
	ParkingMeterInformation[meterid][ParkedPosition][3] = position[3];
	SaveParkingMeter(meterid);
	RebuildParkingMeter(meterid);
	format(string, sizeof(string), "You have created parking meter ID %d with a rate of $%s and a range of %0.3f meters.", meterid, number_format(rate), range);
	SendClientMessageEx(playerid, COLOR_CYAN, string);
	format(string, sizeof(string), "%s created parking meter ID %d with a rate of $%s and a range of %0.3f meters.", GetPlayerNameEx(playerid), meterid, number_format(rate), range);
	Log("logs/admin.log", string);
	return 1;
}

CMD:setmeterrange(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1) return SendClientMessageEx(playerid, COLOR_GREY, "You are unauthorized to use this command.");
	new meterid, Float:range, string[128];
	if(sscanf(params, "df", meterid, range)) return SendClientMessageEx(playerid, COLOR_GREY, "[USAGE]: /setmeterrange [Meter ID] [Range]");
	if(meterid <= 0 || meterid >= MAX_PARKING_METERS)
	{
		format(string, sizeof(string), "The specified parking meter ID must be between 1 and %s.", number_format(MAX_PARKING_METERS - 1));
		SendClientMessageEx(playerid, COLOR_GREY, string);
		return 1;
	}
	if(ParkingMeterInformation[meterid][MeterActive] == 0) return SendClientMessageEx(playerid, COLOR_GREY, "The specified parking meter isn't currently active.");
	if(range < 3.5 || range > 25.0) return SendClientMessageEx(playerid, COLOR_GREY, "The specified range cannot be under 3.5 meters or over 25 meters.");
	if(ParkingMeterInformation[meterid][MeterRange] == range)
	{
		format(string, sizeof(string), "The specified parking meter's range is already %0.3f meters.", range);
		SendClientMessageEx(playerid, COLOR_GREY, string);
		return 1;
	}
	ParkingMeterInformation[meterid][MeterRange] = range;
	SaveParkingMeter(meterid);
	format(string, sizeof(string), "You have set parking meter ID %d's range to %0.3f meters.", meterid, range);
	SendClientMessageEx(playerid, COLOR_YELLOW, string);
	format(string, sizeof(string), "%s set parking meter ID %d's range to %0.3f meters.", meterid, range);
	Log("logs/admin.log", string);
	return 1;
}

CMD:setmeterrate(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1) return SendClientMessageEx(playerid, COLOR_GREY, "You are unauthorized to use this command.");
	new meterid, rate, string[128];
	if(sscanf(params, "dd", meterid, rate)) return SendClientMessageEx(playerid, COLOR_GREY, "[USAGE]: /setmeterrate [Meter ID] [Rate]");
	if(meterid <= 0 || meterid >= MAX_PARKING_METERS)
	{
		format(string, sizeof(string), "The specified parking meter ID must be between 1 and %s.", number_format(MAX_PARKING_METERS - 1));
		SendClientMessageEx(playerid, COLOR_GREY, string);
		return 1;
	}
	if(ParkingMeterInformation[meterid][MeterActive] == 0) return SendClientMessageEx(playerid, COLOR_GREY, "The specified parking meter isn't currently active.");
	if(rate < 1 || rate > 250000) return SendClientMessageEx(playerid, COLOR_GREY, "The specified rate cannot be under $1 or over $250,000.");
	if(ParkingMeterInformation[meterid][MeterRate] == rate)
	{
		format(string, sizeof(string), "The specified parking meter's rate is already $%s.", number_format(rate));
		SendClientMessageEx(playerid, COLOR_GREY, string);
		return 1;
	}
	ParkingMeterInformation[meterid][MeterRate] = rate;
	SaveParkingMeter(meterid);
	format(string, sizeof(string), "You have set parking meter ID %d's rate to $%s.", meterid, number_format(rate));
	SendClientMessageEx(playerid, COLOR_YELLOW, string);
	format(string, sizeof(string), "%s set parking meter ID %d's rate to $%s.", meterid, number_format(rate));
	Log("logs/admin.log", string);
	RebuildParkingMeter(meterid);
	return 1;
}

CMD:deletemeter(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1) return SendClientMessageEx(playerid, COLOR_GREY, "You are unauthorized to use this command.");
	new meterid, string[128];
	if(sscanf(params, "d", meterid)) return SendClientMessageEx(playerid, COLOR_GREY, "[USAGE]: /deletemeter [Meter ID]");
	if(meterid <= 0 || meterid >= MAX_PARKING_METERS)
	{
		format(string, sizeof(string), "The specified parking meter ID must be between 1 and %s.", number_format(MAX_PARKING_METERS - 1));
		SendClientMessageEx(playerid, COLOR_GREY, string);
		return 1;
	}
	if(ParkingMeterInformation[meterid][MeterActive] == 0) return SendClientMessageEx(playerid, COLOR_GREY, "The specified parking meter isn't currently active.");
	ParkingMeterInformation[meterid][MeterActive] = 0;
	ParkingMeterInformation[meterid][MeterRate] = 0;
	ParkingMeterInformation[meterid][MeterRange] = 0;
	for(new i = 0; i < 6; i ++)
	{
		if(i < 4) ParkingMeterInformation[meterid][ParkedPosition][i] = 0.0;
		ParkingMeterInformation[meterid][MeterPosition][i] = 0.0;
	}
	if(IsValidDynamicObject(ParkingMeterInformation[meterid][ParkingMeterObject])) DestroyDynamicObject(ParkingMeterInformation[meterid][ParkingMeterObject]);
	if(IsValidDynamic3DTextLabel(ParkingMeterInformation[meterid][ParkingMeterText])) DestroyDynamic3DTextLabel(ParkingMeterInformation[meterid][ParkingMeterText]);
	SaveParkingMeter(meterid);
	format(string, sizeof(string), "You have deleted parking meter ID %d.", meterid);
	SendClientMessageEx(playerid, COLOR_GREY, string);
	format(string, sizeof(string), "%s deleted parking meter ID %d.", GetPlayerNameEx(playerid), meterid);
	Log("logs/admin.log", string);
	return 1;
}

CMD:gotometer(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1) return SendClientMessageEx(playerid, COLOR_GREY, "You are unauthorized to use this command.");
	new meterid, string[128];
	if(sscanf(params, "d", meterid)) return SendClientMessageEx(playerid, COLOR_GREY, "[USAGE]: /gotometer [Meter ID]");
	if(meterid <= 0 || meterid >= MAX_PARKING_METERS)
	{
		format(string, sizeof(string), "The specified parking meter ID must be between 1 and %s.", number_format(MAX_PARKING_METERS - 1));
		SendClientMessageEx(playerid, COLOR_GREY, string);
		return 1;
	}
	if(ParkingMeterInformation[meterid][MeterActive] == 0) return SendClientMessageEx(playerid, COLOR_GREY, "The specified parking meter isn't currently active.");
	SetPlayerInterior(playerid, 0);
	PlayerInfo[playerid][pInt] = 0;
	SetPlayerVirtualWorld(playerid, 0);
	PlayerInfo[playerid][pVW] = 0;
	SetPlayerPos(playerid, ParkingMeterInformation[meterid][MeterPosition][0], ParkingMeterInformation[meterid][MeterPosition][1], ParkingMeterInformation[meterid][MeterPosition][2]);
	SetPlayerFacingAngle(playerid, ParkingMeterInformation[meterid][MeterPosition][5]);
	format(string, sizeof(string), "You have teleported to parking meter ID %d.", meterid);
	SendClientMessageEx(playerid, COLOR_YELLOW, string);
	format(string, sizeof(string), "%s teleported to parking meter ID %d.", GetPlayerNameEx(playerid), meterid);
	Log("logs/admin.log", string);
	return 1;
}

CMD:reloadmeters(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1) return SendClientMessageEx(playerid, COLOR_GREY, "You are unauthorized to use this command.");
	new string[128], count;
	for(new i = 1; i < sizeof(ParkingMeterInformation); i ++)
	{
		RebuildParkingMeter(i);
		if(ParkingMeterInformation[i][MeterActive] == 1) count ++;
	}
	format(string, sizeof(string), "All parking meters have been reloaded (%s were rebuilt).", number_format(count));
	SendClientMessageEx(playerid, COLOR_YELLOW, string);
	format(string, sizeof(string), "%s reloaded all parking meters (%s rebuilt).", GetPlayerNameEx(playerid), number_format(count));
	Log("logs/admin.log", string);
	return 1;
}