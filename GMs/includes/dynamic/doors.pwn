/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

					Dynamic Door System

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
hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	if(dialogid == DOORLOCK)
	{
		if(response)
		{
			new i = GetPVarInt(playerid, "Door");
			if(isnull(inputtext)) return SendClientMessage(playerid, COLOR_GREY, "You did not enter anything" );
			if(strlen(inputtext) > 24) return SendClientMessageEx(playerid, COLOR_GREY, "The password can not be greater than 24 characters.");
			if(strcmp(inputtext, DDoorsInfo[i][ddPass], true) == 0)
			{
				if(DDoorsInfo[i][ddLocked] == 0)
				{
					DDoorsInfo[i][ddLocked] = 1;
					SendClientMessageEx(playerid, COLOR_WHITE, "Password accepted, doors locked.");
				}
				else
				{
					DDoorsInfo[i][ddLocked] = 0;
					SendClientMessageEx(playerid, COLOR_WHITE, "Password accepted, doors unlocked.");
				}
				SaveDynamicDoor(i);
			}
			else SendClientMessageEx(playerid, COLOR_WHITE, "Password declined.");
		}
	}
	return 0;
}

stock CreateDynamicDoor(doorid)
{
	if(IsValidDynamicPickup(DDoorsInfo[doorid][ddPickupID])) DestroyDynamicPickup(DDoorsInfo[doorid][ddPickupID]);
	if(IsValidDynamicPickup(DDoorsInfo[doorid][ddPickupID_int])) DestroyDynamicPickup(DDoorsInfo[doorid][ddPickupID_int]);
	if(IsValidDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID])) DestroyDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID]);
	if(IsValidDynamicArea(DDoorsInfo[doorid][ddAreaID])) DestroyDynamicArea(DDoorsInfo[doorid][ddAreaID]);
	if(IsValidDynamicArea(DDoorsInfo[doorid][ddAreaID_int])) DestroyDynamicArea(DDoorsInfo[doorid][ddAreaID_int]);
	if(DDoorsInfo[doorid][ddExteriorX] == 0.0) return 1;
	new string[128];
	if(DDoorsInfo[doorid][ddType] != 0) format(string, sizeof(string), "%s | Owner: %s\nID: %d", DDoorsInfo[doorid][ddDescription], StripUnderscore(DDoorsInfo[doorid][ddOwnerName]), doorid);
	else format(string, sizeof(string), "%s\nID: %d", DDoorsInfo[doorid][ddDescription], doorid);

	switch(DDoorsInfo[doorid][ddColor])
	{
	    case -1:{ /* Disable 3d Textdraw */ }
	    case 1:{DDoorsInfo[doorid][ddTextID] = CreateDynamic3DTextLabel(string, COLOR_TWWHITE, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ]+1,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, DDoorsInfo[doorid][ddExteriorVW], DDoorsInfo[doorid][ddExteriorInt], -1);}
	    case 2:{DDoorsInfo[doorid][ddTextID] = CreateDynamic3DTextLabel(string, COLOR_TWPINK, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ]+1,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, DDoorsInfo[doorid][ddExteriorVW], DDoorsInfo[doorid][ddExteriorInt], -1);}
	    case 3:{DDoorsInfo[doorid][ddTextID] = CreateDynamic3DTextLabel(string, COLOR_TWRED, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ]+1,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, DDoorsInfo[doorid][ddExteriorVW], DDoorsInfo[doorid][ddExteriorInt], -1);}
	    case 4:{DDoorsInfo[doorid][ddTextID] = CreateDynamic3DTextLabel(string, COLOR_TWBROWN, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ]+1,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, DDoorsInfo[doorid][ddExteriorVW], DDoorsInfo[doorid][ddExteriorInt], -1);}
	    case 5:{DDoorsInfo[doorid][ddTextID] = CreateDynamic3DTextLabel(string, COLOR_TWGRAY, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ]+1,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, DDoorsInfo[doorid][ddExteriorVW], DDoorsInfo[doorid][ddExteriorInt], -1);}
	    case 6:{DDoorsInfo[doorid][ddTextID] = CreateDynamic3DTextLabel(string, COLOR_TWOLIVE, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ]+1,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, DDoorsInfo[doorid][ddExteriorVW], DDoorsInfo[doorid][ddExteriorInt], -1);}
	    case 7:{DDoorsInfo[doorid][ddTextID] = CreateDynamic3DTextLabel(string, COLOR_TWPURPLE, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ]+1,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, DDoorsInfo[doorid][ddExteriorVW], DDoorsInfo[doorid][ddExteriorInt], -1);}
	    case 8:{DDoorsInfo[doorid][ddTextID] = CreateDynamic3DTextLabel(string, COLOR_TWORANGE, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ]+1,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, DDoorsInfo[doorid][ddExteriorVW], DDoorsInfo[doorid][ddExteriorInt], -1);}
	    case 9:{DDoorsInfo[doorid][ddTextID] = CreateDynamic3DTextLabel(string, COLOR_TWAZURE, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ]+1,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, DDoorsInfo[doorid][ddExteriorVW], DDoorsInfo[doorid][ddExteriorInt], -1);}
	    case 10:{DDoorsInfo[doorid][ddTextID] = CreateDynamic3DTextLabel(string, COLOR_TWGREEN, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ]+1,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, DDoorsInfo[doorid][ddExteriorVW], DDoorsInfo[doorid][ddExteriorInt], -1);}
	    case 11:{DDoorsInfo[doorid][ddTextID] = CreateDynamic3DTextLabel(string, COLOR_TWBLUE, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ]+1,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, DDoorsInfo[doorid][ddExteriorVW], DDoorsInfo[doorid][ddExteriorInt], -1);}
	    case 12:{DDoorsInfo[doorid][ddTextID] = CreateDynamic3DTextLabel(string, COLOR_TWBLACK, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ]+1,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, DDoorsInfo[doorid][ddExteriorVW], DDoorsInfo[doorid][ddExteriorInt], -1);}
		default:{DDoorsInfo[doorid][ddTextID] = CreateDynamic3DTextLabel(string, COLOR_YELLOW, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ]+1,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, DDoorsInfo[doorid][ddExteriorVW], DDoorsInfo[doorid][ddExteriorInt], -1);}
	}

	switch(DDoorsInfo[doorid][ddPickupModel])
	{
	    case -1: { /* Disable Pickup */ }
		case 1:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1210, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
		case 2:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1212, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
		case 3:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1239, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
		case 4:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1240, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
		case 5:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1241, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
		case 6:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1242, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
		case 7:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1247, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
		case 8:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1248, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
		case 9:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1252, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
		case 10:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1253, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
		case 11:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1254, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
		case 12:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1313, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
		case 13:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1272, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
		case 14:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1273, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
		case 15:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1274, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
		case 16:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1275, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
		case 17:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1276, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
		case 18:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1277, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
		case 19:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1279, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
		case 20:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1314, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
		case 21:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1316, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
		case 22:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1317, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
		case 23:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1559, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
		case 24:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1582, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
		case 25:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(2894, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
	    default:
	    {
			DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1318, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);
	    }
	}

	DDoorsInfo[doorid][ddPickupID_int] = CreateDynamicPickup(1559, 23, DDoorsInfo[doorid][ddInteriorX], DDoorsInfo[doorid][ddInteriorY], DDoorsInfo[doorid][ddInteriorZ], DDoorsInfo[doorid][ddInteriorVW]);
	DDoorsInfo[doorid][ddAreaID] = CreateDynamicSphere(DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], 2.5, .worldid = DDoorsInfo[doorid][ddExteriorVW], .interiorid = DDoorsInfo[doorid][ddExteriorInt]);
	DDoorsInfo[doorid][ddAreaID_int] = CreateDynamicSphere(DDoorsInfo[doorid][ddInteriorX], DDoorsInfo[doorid][ddInteriorY], DDoorsInfo[doorid][ddInteriorZ], 2.5, .worldid = DDoorsInfo[doorid][ddInteriorVW], .interiorid = DDoorsInfo[doorid][ddInteriorInt]);

	Streamer_SetIntData(STREAMER_TYPE_AREA, DDoorsInfo[doorid][ddAreaID], E_STREAMER_EXTRA_ID, doorid);
	Streamer_SetIntData(STREAMER_TYPE_AREA, DDoorsInfo[doorid][ddAreaID_int], E_STREAMER_EXTRA_ID, doorid);

	format(szMiscArray, sizeof(szMiscArray), "[DDoor] Created Door: %d | Exterior Area ID: %d | Interior Area ID: %d", doorid, DDoorsInfo[doorid][ddAreaID], DDoorsInfo[doorid][ddAreaID_int]);
	Log("debug/door_ddoor.log", szMiscArray);
	return 1;
}

stock SaveDynamicDoor(doorid)
{
	new string[1024];

	mysql_format(MainPipeline, string, sizeof(string), "UPDATE `ddoors` SET \
		`Description`='%e', \
		`Owner`=%d, \
		`OwnerName`='%e', \
		`CustomInterior`=%d, \
		`ExteriorVW`=%d, \
		`ExteriorInt`=%d, \
		`InteriorVW`=%d, \
		`InteriorInt`=%d, \
		`ExteriorX`=%f, \
		`ExteriorY`=%f, \
		`ExteriorZ`=%f, \
		`ExteriorA`=%f, \
		`InteriorX`=%f, \
		`InteriorY`=%f, \
		`InteriorZ`=%f, \
		`InteriorA`=%f,",
		DDoorsInfo[doorid][ddDescription],
		DDoorsInfo[doorid][ddOwner],
		DDoorsInfo[doorid][ddOwnerName],
		DDoorsInfo[doorid][ddCustomInterior],
		DDoorsInfo[doorid][ddExteriorVW],
		DDoorsInfo[doorid][ddExteriorInt],
		DDoorsInfo[doorid][ddInteriorVW],
		DDoorsInfo[doorid][ddInteriorInt],
		DDoorsInfo[doorid][ddExteriorX],
		DDoorsInfo[doorid][ddExteriorY],
		DDoorsInfo[doorid][ddExteriorZ],
		DDoorsInfo[doorid][ddExteriorA],
		DDoorsInfo[doorid][ddInteriorX],
		DDoorsInfo[doorid][ddInteriorY],
		DDoorsInfo[doorid][ddInteriorZ],
		DDoorsInfo[doorid][ddInteriorA]
	);

	mysql_format(MainPipeline, string, sizeof(string), "%s \
		`CustomExterior`=%d, \
		`Type`=%d, \
		`Rank`=%d, \
		`VIP`=%d, \
		`Famed`=%d, \
		`DPC`=%d, \
		`Allegiance`=%d, \
		`GroupType`=%d, \
		`Faction`=%d, \
		`Admin`=%d, \
		`Wanted`=%d, \
		`VehicleAble`=%d, \
		`Color`=%d, \
		`PickupModel`=%d, \
		`Pass`='%e', \
		`Locked`=%d, \
		`LastLogin`=%d, \
		`Expire`=%d, \
		`Inactive`=%d, \
		`Ignore`=%d, \
		`Counter`=%d \
		WHERE `id`=%d",
		string,
		DDoorsInfo[doorid][ddCustomExterior],
		DDoorsInfo[doorid][ddType],
		DDoorsInfo[doorid][ddRank],
		DDoorsInfo[doorid][ddVIP],
		DDoorsInfo[doorid][ddFamed],
		DDoorsInfo[doorid][ddDPC],
		DDoorsInfo[doorid][ddAllegiance],
		DDoorsInfo[doorid][ddGroupType],
		DDoorsInfo[doorid][ddFaction],
		DDoorsInfo[doorid][ddAdmin],
		DDoorsInfo[doorid][ddWanted],
		DDoorsInfo[doorid][ddVehicleAble],
		DDoorsInfo[doorid][ddColor],
		DDoorsInfo[doorid][ddPickupModel],
		DDoorsInfo[doorid][ddPass],
		DDoorsInfo[doorid][ddLocked],
		DDoorsInfo[doorid][ddLastLogin],
		DDoorsInfo[doorid][ddExpire],
		DDoorsInfo[doorid][ddInactive],
		DDoorsInfo[doorid][ddIgnore],
		DDoorsInfo[doorid][ddCounter],
		doorid+1
	); // Array starts from zero, MySQL starts at 1 (this is why we are adding one).

	mysql_tquery(MainPipeline, string, "OnQueryFinish", "i", SENDDATA_THREAD);
}

stock LoadDynamicDoor(doorid)
{
	new string[128];
	mysql_format(MainPipeline, string, sizeof(string), "SELECT * FROM `ddoors` WHERE `id`=%d", doorid+1); // Array starts at zero, MySQL starts at 1.
	mysql_tquery(MainPipeline, string, "OnLoadDynamicDoor", "i", doorid);
}

stock LoadDynamicDoors()
{
	printf("[LoadDynamicDoors] Loading data from database...");
	mysql_tquery(MainPipeline, "SELECT * FROM `ddoors`", "OnLoadDynamicDoors", "");
}

forward OnLoadDynamicDoor(index);
public OnLoadDynamicDoor(index)
{
	new rows;
	cache_get_row_count(rows);

	for(new row; row < rows; row++)
	{
		cache_get_value_name_int(row, "id", DDoorsInfo[index][ddSQLId]);
		cache_get_value_name(row, "Description", DDoorsInfo[index][ddDescription], 128);
	 	cache_get_value_name_int(row, "Owner", DDoorsInfo[index][ddOwner]);
		cache_get_value_name(row, "OwnerName", DDoorsInfo[index][ddOwnerName], 42);
		cache_get_value_name_int(row, "CustomExterior", DDoorsInfo[index][ddCustomExterior]);
		cache_get_value_name_int(row, "CustomInterior", DDoorsInfo[index][ddCustomInterior]);
		cache_get_value_name_int(row, "ExteriorVW", DDoorsInfo[index][ddExteriorVW]); 
		cache_get_value_name_int(row, "ExteriorInt", DDoorsInfo[index][ddExteriorInt]); 
		cache_get_value_name_int(row, "InteriorVW", DDoorsInfo[index][ddInteriorVW]); 
		cache_get_value_name_int(row, "InteriorInt", DDoorsInfo[index][ddInteriorInt]);
		cache_get_value_name_float(row, "ExteriorX", DDoorsInfo[index][ddExteriorX]);
		cache_get_value_name_float(row, "ExteriorY", DDoorsInfo[index][ddExteriorY]);
		cache_get_value_name_float(row, "ExteriorZ", DDoorsInfo[index][ddExteriorZ]);
		cache_get_value_name_float(row, "ExteriorA", DDoorsInfo[index][ddExteriorA]);
		cache_get_value_name_float(row, "InteriorX", DDoorsInfo[index][ddInteriorX]);
		cache_get_value_name_float(row, "InteriorY", DDoorsInfo[index][ddInteriorY]);
		cache_get_value_name_float(row, "InteriorZ", DDoorsInfo[index][ddInteriorZ]);
		cache_get_value_name_float(row, "InteriorA", DDoorsInfo[index][ddInteriorA]);
		cache_get_value_name_int(row, "Type", DDoorsInfo[index][ddType]); 
		cache_get_value_name_int(row, "Rank", DDoorsInfo[index][ddRank]); 
		cache_get_value_name_int(row, "VIP", DDoorsInfo[index][ddVIP]); 
		cache_get_value_name_int(row, "Famed", DDoorsInfo[index][ddFamed]); 
		cache_get_value_name_int(row, "DPC", DDoorsInfo[index][ddDPC]); 
		cache_get_value_name_int(row, "Allegiance", DDoorsInfo[index][ddAllegiance]);
		cache_get_value_name_int(row, "GroupType", DDoorsInfo[index][ddGroupType]); 
		cache_get_value_name_int(row, "Faction", DDoorsInfo[index][ddFaction]); 
		cache_get_value_name_int(row, "Admin", DDoorsInfo[index][ddAdmin]); 
		cache_get_value_name_int(row, "Wanted", DDoorsInfo[index][ddWanted]); 
		cache_get_value_name_int(row, "VehicleAble", DDoorsInfo[index][ddVehicleAble]); 
		cache_get_value_name_int(row, "Color", DDoorsInfo[index][ddColor]); 
		cache_get_value_name_int(row, "PickupModel", DDoorsInfo[index][ddPickupModel]); 
		cache_get_value_name(row, "Pass", DDoorsInfo[index][ddPass], 24);
		cache_get_value_name_int(row, "Locked", DDoorsInfo[index][ddLocked]); 
		cache_get_value_name_int(row, "LastLogin", DDoorsInfo[index][ddLastLogin]);
		cache_get_value_name_int(row, "Expire", DDoorsInfo[index][ddExpire]);
		cache_get_value_name_int(row, "Inactive", DDoorsInfo[index][ddInactive]);
		cache_get_value_name_int(row, "Ignore", DDoorsInfo[index][ddIgnore]);
		cache_get_value_name_int(row, "Counter", DDoorsInfo[index][ddCounter]);
		if(DDoorsInfo[index][ddExteriorX] != 0.0) CreateDynamicDoor(index);
	}
	return 1;
}


forward OnLoadDynamicDoors();
public OnLoadDynamicDoors()
{
	new i, rows;
	cache_get_row_count(rows);

	while(i < rows)
	{
		/*DDoorsInfo[i][ddSQLId] = cache_get_field_content_int(i, "id", MainPipeline); 
		cache_get_field_content(i, "Description", DDoorsInfo[i][ddDescription], MainPipeline, 128);
		DDoorsInfo[i][ddOwner] = cache_get_field_content_int(i, "Owner", MainPipeline); 
		cache_get_field_content(i, "OwnerName", DDoorsInfo[i][ddOwnerName], MainPipeline, 42);
		DDoorsInfo[i][ddCustomExterior] = cache_get_field_content_int(i, "CustomExterior", MainPipeline); 
		DDoorsInfo[i][ddCustomInterior] = cache_get_field_content_int(i, "CustomInterior", MainPipeline); 
		DDoorsInfo[i][ddExteriorVW] = cache_get_field_content_int(i, "ExteriorVW", MainPipeline); 
		DDoorsInfo[i][ddExteriorInt] = cache_get_field_content_int(i, "ExteriorInt", MainPipeline); 
		DDoorsInfo[i][ddInteriorVW] = cache_get_field_content_int(i, "InteriorVW", MainPipeline); 
		DDoorsInfo[i][ddInteriorInt] = cache_get_field_content_int(i, "InteriorInt", MainPipeline); 
		DDoorsInfo[i][ddExteriorX] = cache_get_field_content_float(i, "ExteriorX", MainPipeline);
		DDoorsInfo[i][ddExteriorY] = cache_get_field_content_float(i, "ExteriorY", MainPipeline);
		DDoorsInfo[i][ddExteriorZ] = cache_get_field_content_float(i, "ExteriorZ", MainPipeline);
		DDoorsInfo[i][ddExteriorA] = cache_get_field_content_float(i, "ExteriorA", MainPipeline);
		DDoorsInfo[i][ddInteriorX] = cache_get_field_content_float(i, "InteriorX", MainPipeline);
		DDoorsInfo[i][ddInteriorY] = cache_get_field_content_float(i, "InteriorY", MainPipeline);
		DDoorsInfo[i][ddInteriorZ] = cache_get_field_content_float(i, "InteriorZ", MainPipeline);
		DDoorsInfo[i][ddInteriorA] = cache_get_field_content_float(i, "InteriorA", MainPipeline);
		DDoorsInfo[i][ddType] = cache_get_field_content_int(i, "Type",MainPipeline); 
		DDoorsInfo[i][ddRank] = cache_get_field_content_int(i, "Rank", MainPipeline); 
		DDoorsInfo[i][ddVIP] = cache_get_field_content_int(i, "VIP", MainPipeline); 
		DDoorsInfo[i][ddFamed] = cache_get_field_content_int(i, "Famed", MainPipeline); 
		DDoorsInfo[i][ddDPC] = cache_get_field_content_int(i, "DPC", MainPipeline); 
		DDoorsInfo[i][ddAllegiance] = cache_get_field_content_int(i, "Allegiance", MainPipeline); 
		DDoorsInfo[i][ddGroupType] = cache_get_field_content_int(i, "GroupType", MainPipeline); 
		DDoorsInfo[i][ddFaction] = cache_get_field_content_int(i, "Faction", MainPipeline); 
		DDoorsInfo[i][ddAdmin] = cache_get_field_content_int(i, "Admin", MainPipeline);
		DDoorsInfo[i][ddWanted] = cache_get_field_content_int(i, "Wanted", MainPipeline); 
		DDoorsInfo[i][ddVehicleAble] = cache_get_field_content_int(i, "VehicleAble", MainPipeline); 
		DDoorsInfo[i][ddColor] = cache_get_field_content_int(i, "Color", MainPipeline);
		DDoorsInfo[i][ddPickupModel] = cache_get_field_content_int(i, "PickupModel", MainPipeline); 
		cache_get_field_content(i, "Pass", DDoorsInfo[i][ddPass], MainPipeline, 24);
		DDoorsInfo[i][ddLocked] = cache_get_field_content_int(i, "Locked", MainPipeline); 
		DDoorsInfo[i][ddLastLogin] = cache_get_field_content_int(i, "LastLogin", MainPipeline);
		DDoorsInfo[i][ddExpire] = cache_get_field_content_int(i, "Expire", MainPipeline);
		DDoorsInfo[i][ddInactive] = cache_get_field_content_int(i, "Inactive", MainPipeline);
		DDoorsInfo[i][ddIgnore] = cache_get_field_content_int(i, "Ignore", MainPipeline);
		DDoorsInfo[i][ddCounter] = cache_get_field_content_int(i, "Counter", MainPipeline);
		if(DDoorsInfo[i][ddExteriorX] != 0.0) CreateDynamicDoor(i);*/
		LoadDynamicDoor(i);
		i++;
	}
	if(i > 0) printf("[LoadDynamicDoors] %d doors rehashed/loaded.", i);
	else printf("[LoadDynamicDoors] Failed to load any doors.");
	return 1;
}

stock SaveDynamicDoors()
{
	for(new i = 0; i < MAX_DDOORS; i++)
	{
		SaveDynamicDoor(i);
	}
	return 1;
}

stock RehashDynamicDoor(doorid)
{
	DestroyDynamicPickup(DDoorsInfo[doorid][ddPickupID]);
	if(IsValidDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID])) DestroyDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID]);
	DDoorsInfo[doorid][ddSQLId] = -1;
	DDoorsInfo[doorid][ddOwner] = -1;
	DDoorsInfo[doorid][ddCustomInterior] = 0;
	DDoorsInfo[doorid][ddExteriorVW] = 0;
	DDoorsInfo[doorid][ddExteriorInt] = 0;
	DDoorsInfo[doorid][ddInteriorVW] = 0;
	DDoorsInfo[doorid][ddInteriorInt] = 0;
	DDoorsInfo[doorid][ddExteriorX] = 0.0;
	DDoorsInfo[doorid][ddExteriorY] = 0.0;
	DDoorsInfo[doorid][ddExteriorZ] = 0.0;
	DDoorsInfo[doorid][ddExteriorA] = 0.0;
	DDoorsInfo[doorid][ddInteriorX] = 0.0;
	DDoorsInfo[doorid][ddInteriorY] = 0.0;
	DDoorsInfo[doorid][ddInteriorZ] = 0.0;
	DDoorsInfo[doorid][ddInteriorA] = 0.0;
	DDoorsInfo[doorid][ddCustomExterior] = 0;
	DDoorsInfo[doorid][ddType] = 0;
	DDoorsInfo[doorid][ddRank] = 0;
	DDoorsInfo[doorid][ddVIP] = 0;
	DDoorsInfo[doorid][ddAllegiance] = 0;
	DDoorsInfo[doorid][ddGroupType] = 0;
	DDoorsInfo[doorid][ddFaction] = 0;
	DDoorsInfo[doorid][ddAdmin] = 0;
	DDoorsInfo[doorid][ddWanted] = 0;
	DDoorsInfo[doorid][ddVehicleAble] = 0;
	DDoorsInfo[doorid][ddColor] = 0;
	DDoorsInfo[doorid][ddPickupModel] = 0;
	DDoorsInfo[doorid][ddLocked] = 0;
	LoadDynamicDoor(doorid);
}

stock RehashDynamicDoors()
{
	printf("[RehashDynamicDoors] Deleting dynamic doors from server...");
	for(new i = 0; i < MAX_DDOORS; i++)
	{
		RehashDynamicDoor(i);
	}
	//LoadDynamicDoors();
}

forward OnSetDDOwner(playerid, doorid);
public OnSetDDOwner(playerid, doorid)
{
	if(IsPlayerConnected(playerid))
	{
	    new rows;
	    new string[128], playername[MAX_PLAYER_NAME];
    	cache_get_row_count(rows);

    	if(rows)
    	{
			cache_get_value_name_int(0, "id", DDoorsInfo[doorid][ddOwner]);
			cache_get_value_name(0, "Username", playername, MAX_PLAYER_NAME);
			strcat((DDoorsInfo[doorid][ddOwnerName][0] = 0, DDoorsInfo[doorid][ddOwnerName]), playername, MAX_PLAYER_NAME);

			format(string, sizeof(string), "Successfully set the owner to %s.", playername);
			SendClientMessageEx(playerid, COLOR_WHITE, string);

			DestroyDynamicPickup(DDoorsInfo[doorid][ddPickupID]);
			if(IsValidDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID])) DestroyDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID]);
			CreateDynamicDoor(doorid);
			SaveDynamicDoor(doorid);
			format(string, sizeof(string), "%s has edited door ID %d's owner to %s (SQL ID: %d).", GetPlayerNameEx(playerid), doorid, playername, DDoorsInfo[doorid][ddOwner]);
			Log("logs/ddedit.log", string);
		}
		else SendClientMessageEx(playerid, COLOR_GREY, "That account name does not appear to exist.");
	}
	return 1;
}

CMD:changedoorpass(playerid, params[])
{
    for(new i = 0; i < sizeof(DDoorsInfo); i++) {
        if (IsPlayerInRangeOfPoint(playerid,3.0,DDoorsInfo[i][ddExteriorX], DDoorsInfo[i][ddExteriorY], DDoorsInfo[i][ddExteriorZ]) && PlayerInfo[playerid][pVW] == DDoorsInfo[i][ddExteriorVW] || IsPlayerInRangeOfPoint(playerid,3.0,DDoorsInfo[i][ddInteriorX], DDoorsInfo[i][ddInteriorY], DDoorsInfo[i][ddInteriorZ]) && PlayerInfo[playerid][pVW] == DDoorsInfo[i][ddInteriorVW])
		{
			new doorpass[24];
			if(sscanf(params, "s[24]", doorpass)) { SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /changedoorpass [pass]"); SendClientMessageEx(playerid, COLOR_WHITE, "To remove the password on the door set the password to 'none'."); return 1; }
        	if(DDoorsInfo[i][ddType] == 2 && DDoorsInfo[i][ddFaction] != INVALID_GROUP_ID && PlayerInfo[playerid][pLeader] == DDoorsInfo[i][ddFaction])
			{
				format(DDoorsInfo[i][ddPass], 24, "%s", doorpass);
				SendClientMessageEx(playerid, COLOR_WHITE, "You have changed the password of this door.");
				SaveDynamicDoor(i);
			}
			else if(DDoorsInfo[i][ddType] == 1 && DDoorsInfo[i][ddOwner] == GetPlayerSQLId(playerid))
			{
				format(DDoorsInfo[i][ddPass], 24, "%s", doorpass);
				SendClientMessageEx(playerid, COLOR_WHITE, "You have changed the password of this door.");
				SaveDynamicDoor(i);
			}
			else SendClientMessageEx(playerid, COLOR_GREY, "You cannot change the password on this lock.");
		}
	}
	return 1;
}

CMD:lockdoor(playerid, params[])
{
    for(new i = 0; i < sizeof(DDoorsInfo); i++) {
        if (IsPlayerInRangeOfPoint(playerid,3.0,DDoorsInfo[i][ddExteriorX], DDoorsInfo[i][ddExteriorY], DDoorsInfo[i][ddExteriorZ]) && PlayerInfo[playerid][pVW] == DDoorsInfo[i][ddExteriorVW] || IsPlayerInRangeOfPoint(playerid,3.0,DDoorsInfo[i][ddInteriorX], DDoorsInfo[i][ddInteriorY], DDoorsInfo[i][ddInteriorZ]) && PlayerInfo[playerid][pVW] == DDoorsInfo[i][ddInteriorVW])
		{
        	if(DDoorsInfo[i][ddType] == 2 && DDoorsInfo[i][ddFaction] != INVALID_GROUP_ID && PlayerInfo[playerid][pLeader] == DDoorsInfo[i][ddFaction])
			{
				if(DDoorsInfo[i][ddLocked] == 0) {
					
					DDoorsInfo[i][ddLocked] = 1;
					SendClientMessageEx(playerid, COLOR_WHITE, "This door has been locked.");
				}
				else if(DDoorsInfo[i][ddLocked] == 1)
				{
					DDoorsInfo[i][ddLocked] = 0;
					SendClientMessageEx(playerid, COLOR_GREY, "This door has been unlocked.");
				}
			}
			else if(DDoorsInfo[i][ddType] == 1 && DDoorsInfo[i][ddOwner] == GetPlayerSQLId(playerid))
			{
				if(DDoorsInfo[i][ddLocked] == 0)
				{
					DDoorsInfo[i][ddLocked] = 1;
					SendClientMessageEx(playerid, COLOR_WHITE, "This door has been locked.");
				}
				else if(DDoorsInfo[i][ddLocked] == 1)
				{
					DDoorsInfo[i][ddLocked] = 0;
					SendClientMessageEx(playerid, COLOR_GREY, "This door has been unlocked.");
				}
			}
			else SendClientMessageEx(playerid, COLOR_GREY, "You cannot lock this door.");
		}
	}
	return 1;
}

CMD:doorpass(playerid, params[])
{
    for(new i = 0; i < sizeof(DDoorsInfo); i++) {
        if (IsPlayerInRangeOfPoint(playerid,3.0,DDoorsInfo[i][ddExteriorX], DDoorsInfo[i][ddExteriorY], DDoorsInfo[i][ddExteriorZ]) && PlayerInfo[playerid][pVW] == DDoorsInfo[i][ddExteriorVW] || IsPlayerInRangeOfPoint(playerid,3.0,DDoorsInfo[i][ddInteriorX], DDoorsInfo[i][ddInteriorY], DDoorsInfo[i][ddInteriorZ]) && PlayerInfo[playerid][pVW] == DDoorsInfo[i][ddInteriorVW]) {
        	if(DDoorsInfo[i][ddPass] < 1)
                return SendClientMessageEx(playerid, COLOR_GREY, "This door isn't allowed to be locked");
         	if(strcmp(DDoorsInfo[i][ddPass], "None", true) == 0)
                return SendClientMessageEx(playerid, COLOR_GREY, "This door isn't allowed to be locked");

			ShowPlayerDialogEx(playerid, DOORLOCK, DIALOG_STYLE_INPUT, "Door Security","Enter the password for this door","Login","Cancel");
			SetPVarInt(playerid, "Door", i);
		}
	}
	return 1;
}

CMD:goindoor(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1 || PlayerInfo[playerid][pShopTech] >= 1)
	{
		new string[48], doornum;
		if(sscanf(params, "d", doornum)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /goindoor [doornumber]");

		if(doornum <= 0 || doornum >= MAX_DDOORS)
		{
			format(string, sizeof(string), "Door ID must be between 1 and %d.", MAX_DDOORS - 1);
			return SendClientMessageEx(playerid, COLOR_GREY, string);
		}

		SetPlayerInterior(playerid,DDoorsInfo[doornum][ddInteriorInt]);
		SetPlayerPos(playerid,DDoorsInfo[doornum][ddInteriorX],DDoorsInfo[doornum][ddInteriorY],DDoorsInfo[doornum][ddInteriorZ]);
		SetPlayerFacingAngle(playerid,DDoorsInfo[doornum][ddInteriorA]);
		PlayerInfo[playerid][pInt] = DDoorsInfo[doornum][ddInteriorInt];
		PlayerInfo[playerid][pVW] = DDoorsInfo[doornum][ddInteriorVW];
		SetPlayerVirtualWorld(playerid, DDoorsInfo[doornum][ddInteriorVW]);
		if(DDoorsInfo[doornum][ddCustomInterior]) Player_StreamPrep(playerid, DDoorsInfo[doornum][ddInteriorX],DDoorsInfo[doornum][ddInteriorY],DDoorsInfo[doornum][ddInteriorZ], FREEZE_TIME);
	}
	return 1;
}

CMD:gotodoor(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1 || PlayerInfo[playerid][pShopTech] >= 1)
	{
		new string[48], doornum;
		if(sscanf(params, "d", doornum)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /gotodoor [doornumber]");

		if(doornum <= 0 || doornum >= MAX_DDOORS)
		{
			format(string, sizeof(string), "Door ID must be between 1 and %d.", MAX_DDOORS - 1);
			return SendClientMessageEx(playerid, COLOR_GREY, string);
		}

		SetPlayerInterior(playerid,DDoorsInfo[doornum][ddExteriorInt]);
		SetPlayerPos(playerid,DDoorsInfo[doornum][ddExteriorX],DDoorsInfo[doornum][ddExteriorY],DDoorsInfo[doornum][ddExteriorZ]);
		SetPlayerFacingAngle(playerid,DDoorsInfo[doornum][ddExteriorA]);
		PlayerInfo[playerid][pInt] = DDoorsInfo[doornum][ddExteriorInt];
		SetPlayerVirtualWorld(playerid, DDoorsInfo[doornum][ddExteriorVW]);
		PlayerInfo[playerid][pVW] = DDoorsInfo[doornum][ddExteriorVW];
		if(DDoorsInfo[doornum][ddCustomExterior]) Player_StreamPrep(playerid, DDoorsInfo[doornum][ddExteriorX],DDoorsInfo[doornum][ddExteriorY],DDoorsInfo[doornum][ddExteriorZ], FREEZE_TIME);
	}
	return 1;
}

CMD:ddstatus(playerid, params[])
{
	new doorid;
	if(sscanf(params, "i", doorid))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /ddstatus [doorid]");
		return 1;
	}
	if (PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1 || PlayerInfo[playerid][pShopTech] >= 1)
	{
		new string[128];
		format(string,sizeof(string),"|___________ Door Status (ID: %d · Name: %s) ___________|", doorid, DDoorsInfo[doorid][ddDescription]);
		SendClientMessageEx(playerid, COLOR_GREEN, string);
		format(string, sizeof(string), "(Ext) X: %f | Y: %f | Z: %f | (Int) X: %f | Y: %f | Z: %f", DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddInteriorX], DDoorsInfo[doorid][ddInteriorY], DDoorsInfo[doorid][ddInteriorZ]);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "Pickup ID: %d | Custom Int: %d | Custom Ext: %d | Exterior VW: %d | Exterior Int: %d | Interior VW: %d | Interior Int: %d", DDoorsInfo[doorid][ddPickupID], DDoorsInfo[doorid][ddCustomInterior], DDoorsInfo[doorid][ddCustomExterior], DDoorsInfo[doorid][ddExteriorVW], DDoorsInfo[doorid][ddExteriorInt], DDoorsInfo[doorid][ddInteriorVW], DDoorsInfo[doorid][ddInteriorInt]);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "Type: %d | Rank: %d | VIP: %d | Allegiance: %d | Group Type: %d | Faction: %d | Admin: %d | Wanted: %d", DDoorsInfo[doorid][ddType], DDoorsInfo[doorid][ddRank], DDoorsInfo[doorid][ddVIP], DDoorsInfo[doorid][ddAllegiance], DDoorsInfo[doorid][ddGroupType], DDoorsInfo[doorid][ddFaction], DDoorsInfo[doorid][ddAdmin], DDoorsInfo[doorid][ddWanted]);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "Vehiclable: %d | Locked: %d | Password: %s", DDoorsInfo[doorid][ddVehicleAble], DDoorsInfo[doorid][ddLocked], DDoorsInfo[doorid][ddPass]);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	}
	return 1;
}

CMD:ddnear(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1 || PlayerInfo[playerid][pShopTech] >= 1)
	{
		new option;
		if(!sscanf(params, "d", option)) 
		{
			new string[64];
			format(string, sizeof(string), "* Listing all dynamic doors within 30 meters of you in VW %d...", option);
			SendClientMessageEx(playerid, COLOR_RED, string);
			for(new i, szMessage[128]; i < MAX_DDOORS; i++)
			{
				if(strcmp(DDoorsInfo[i][ddDescription], "None", true) != 0)
				{
					if(option == -1)
					{
						if(IsPlayerInRangeOfPoint(playerid, 30, DDoorsInfo[i][ddInteriorX], DDoorsInfo[i][ddInteriorY], DDoorsInfo[i][ddInteriorZ]))
						{
							format(szMessage, sizeof(szMessage), "(Interior) DDoor ID %d | %f from you | Interior: %d", i, GetPlayerDistanceFromPoint(playerid, DDoorsInfo[i][ddInteriorX], DDoorsInfo[i][ddInteriorY], DDoorsInfo[i][ddInteriorZ]), DDoorsInfo[i][ddInteriorInt]);
							SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
						}
						if(IsPlayerInRangeOfPoint(playerid, 30, DDoorsInfo[i][ddExteriorX], DDoorsInfo[i][ddExteriorY], DDoorsInfo[i][ddExteriorZ]))
						{
							format(szMessage, sizeof(szMessage), "(Exterior) DDoor ID %d | %f from you | Interior: %d", i, GetPlayerDistanceFromPoint(playerid, DDoorsInfo[i][ddExteriorX], DDoorsInfo[i][ddExteriorY], DDoorsInfo[i][ddExteriorZ]), DDoorsInfo[i][ddExteriorInt]);
							SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
						}
					}
					else
					{
						if(IsPlayerInRangeOfPoint(playerid, 30, DDoorsInfo[i][ddInteriorX], DDoorsInfo[i][ddInteriorY], DDoorsInfo[i][ddInteriorZ]) && DDoorsInfo[i][ddInteriorVW] == option)
						{
							format(szMessage, sizeof(szMessage), "(Interior) DDoor ID %d | %f from you | Interior: %d", i, GetPlayerDistanceFromPoint(playerid, DDoorsInfo[i][ddInteriorX], DDoorsInfo[i][ddInteriorY], DDoorsInfo[i][ddInteriorZ]), DDoorsInfo[i][ddInteriorInt]);
							SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
						}
						if(IsPlayerInRangeOfPoint(playerid, 30, DDoorsInfo[i][ddExteriorX], DDoorsInfo[i][ddExteriorY], DDoorsInfo[i][ddExteriorZ]) && DDoorsInfo[i][ddExteriorVW] == option)
						{
							format(szMessage, sizeof(szMessage), "(Exterior) DDoor ID %d | %f from you | Interior: %d", i, GetPlayerDistanceFromPoint(playerid, DDoorsInfo[i][ddExteriorX], DDoorsInfo[i][ddExteriorY], DDoorsInfo[i][ddExteriorZ]), DDoorsInfo[i][ddExteriorInt]);
							SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
						}
					}
				}
			}
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_RED, "* Listing all dynamic doors within 30 meters of you...");
			for(new i, szMessage[128]; i < MAX_DDOORS; i++)
			{
				if(strcmp(DDoorsInfo[i][ddDescription], "None", true) != 0)
				{
					if(IsPlayerInRangeOfPoint(playerid, 30, DDoorsInfo[i][ddInteriorX], DDoorsInfo[i][ddInteriorY], DDoorsInfo[i][ddInteriorZ]) && DDoorsInfo[i][ddInteriorVW] == GetPlayerVirtualWorld(playerid))
					{
						format(szMessage, sizeof(szMessage), "(Interior) DDoor ID %d | %f from you | Virtual World: %d | Interior: %d", i, GetPlayerDistanceFromPoint(playerid, DDoorsInfo[i][ddInteriorX], DDoorsInfo[i][ddInteriorY], DDoorsInfo[i][ddInteriorZ]), DDoorsInfo[i][ddInteriorVW], DDoorsInfo[i][ddInteriorInt]);
						SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
					}
					if(IsPlayerInRangeOfPoint(playerid, 30, DDoorsInfo[i][ddExteriorX], DDoorsInfo[i][ddExteriorY], DDoorsInfo[i][ddExteriorZ]) && DDoorsInfo[i][ddExteriorVW] == GetPlayerVirtualWorld(playerid))
					{
						format(szMessage, sizeof(szMessage), "(Exterior) DDoor ID %d | %f from you | Virtual World: %d | Interior: %d", i, GetPlayerDistanceFromPoint(playerid, DDoorsInfo[i][ddExteriorX], DDoorsInfo[i][ddExteriorY], DDoorsInfo[i][ddExteriorZ]), DDoorsInfo[i][ddExteriorVW], DDoorsInfo[i][ddExteriorInt]);
						SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
					}
				}
			}
		}
	}
	else
	{
	    SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use that command.");
	}
	return 1;
}

CMD:ddnext(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1 || PlayerInfo[playerid][pShopTech] >= 1)
	{
		SendClientMessageEx(playerid, COLOR_RED, "* Listing next available dynamic door...");
		for(new x;x<MAX_DDOORS;x++)
		{
		    if(DDoorsInfo[x][ddExteriorX] == 0.0) // If the door is at blueberry!
		    {
		        new string[128];
		        format(string, sizeof(string), "%d is available to use.", x);
		        SendClientMessageEx(playerid, COLOR_WHITE, string);
		        break;
			}
		}
	}
	else
	{
	    SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use that command.");
		return 1;
	}
	return 1;
}

CMD:ddname(playerid, params[]) {
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1 || PlayerInfo[playerid][pShopTech] >= 1)
	{
		new
			szName[128],
			iDoorID;

		if(sscanf(params, "ds[128]", iDoorID, szName)) {
			return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /ddname [doorid] [name]");
		}
		else if(!(0 <= iDoorID <= MAX_DDOORS)) {
			return SendClientMessageEx(playerid, COLOR_GREY, "Invalid door specified.");
		}
		else if(strfind(szName, "\r") != -1 || strfind(szName, "\n") != -1) {
			return SendClientMessageEx(playerid, COLOR_GREY, "Newline characters are forbidden.");
		}

		strcat((DDoorsInfo[iDoorID][ddDescription][0] = 0, DDoorsInfo[iDoorID][ddDescription]), szName, 128);
		SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully changed the name of this door.");

		DestroyDynamicPickup(DDoorsInfo[iDoorID][ddPickupID]);
		if(IsValidDynamic3DTextLabel(DDoorsInfo[iDoorID][ddTextID])) DestroyDynamic3DTextLabel(DDoorsInfo[iDoorID][ddTextID]);
		CreateDynamicDoor(iDoorID);
		SaveDynamicDoor(iDoorID);

		format(szName, sizeof(szName), "%s has edited door ID %d's name to %s.", GetPlayerNameEx(playerid), iDoorID, DDoorsInfo[iDoorID][ddDescription]);
		Log("logs/ddedit.log", szName);
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use that command.");
	return 1;
}

CMD:ddowner(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1 || PlayerInfo[playerid][pFactionModerator] >= 2 || PlayerInfo[playerid][pShopTech] >= 1)
	{
		new playername[MAX_PLAYER_NAME], doorid, szName[128];
		if(sscanf(params, "ds[24]", doorid, playername)) return SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /ddowner [door] [player name]");

		if(DDoorsInfo[doorid][ddType] != 1) return SendClientMessageEx(playerid, COLOR_GRAD1, "This door is not owned by a player!");
		new giveplayerid = ReturnUser(playername);
		if(PlayerInfo[giveplayerid][pLevel] == 1 && PlayerInfo[giveplayerid][pAdmin] < 2) return SendClientMessageEx(playerid, COLOR_RED, "You can't use /ddowner on level 1's");
		if(IsPlayerConnected(giveplayerid))
		{
			strcat((DDoorsInfo[doorid][ddOwnerName][0] = 0, DDoorsInfo[doorid][ddOwnerName]), GetPlayerNameEx(giveplayerid), 24);
			DDoorsInfo[doorid][ddOwner] = GetPlayerSQLId(giveplayerid);
			SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully changed the owner of this door.");

			DestroyDynamicPickup(DDoorsInfo[doorid][ddPickupID]);
			if(IsValidDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID])) DestroyDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID]);
			CreateDynamicDoor(doorid);
			SaveDynamicDoor(doorid);
			
			format(szName, sizeof(szName), "%s has edited door ID %d's owner to %s (SQL ID: %d).", GetPlayerNameEx(playerid), doorid, GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid));
			Log("logs/ddedit.log", szName);
		}
		else
		{
			new query[128], tmpName[24];

			mysql_escape_string(playername, tmpName);
			mysql_format(MainPipeline, query,sizeof(query), "SELECT `id`, `Username` FROM `accounts` WHERE `Username` = '%s'", tmpName);
			mysql_tquery(MainPipeline, query, "OnSetDDOwner", "ii", playerid, doorid);
		}
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command!");
	return 1;
}

CMD:ddpass(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1 && PlayerInfo[playerid][pShopTech] < 1) return SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use that command.");

	new string[128],
		doorid,
		doorpass[24];

	if(sscanf(params, "ds[24]", doorid, doorpass)) { SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /ddPass [doorid] [pass]"); SendClientMessageEx(playerid, COLOR_WHITE, "To remove the password on the door set the password to 'none' "); return 1; }
	format(DDoorsInfo[doorid][ddPass], 24, "%s", doorpass);
	SendClientMessageEx(playerid, COLOR_WHITE, "You have changed the password of that door.");
	SaveDynamicDoor(doorid);
	format(string, sizeof(string), "%s has edited DoorID %d's password to %s.", GetPlayerNameEx(playerid), doorid, doorpass);
	Log("logs/ddedit.log", string);
	return 1;
}

CMD:ddedit(playerid, params[])
{
 	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1 || PlayerInfo[playerid][pShopTech] >= 1)
	{
		new string[128], choice[32], doorid, amount;
		if(sscanf(params, "s[32]dD", choice, doorid, amount))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /ddedit [name] [doorid] [amount]");
			SendClientMessageEx(playerid, COLOR_GREY, "Available names: Exterior, Interior, CustomInterior, CustomExterior, Type, Rank, VIP, Famed");
			SendClientMessageEx(playerid, COLOR_GREY, "Allegiance, GroupType, Faction, Wanted, Admin, VehicleAble, Color, PickupModel, Delete");
			return 1;
		}

		if(doorid >= MAX_DDOORS)
		{
			SendClientMessageEx( playerid, COLOR_WHITE, "Invalid Door ID!");
			return 1;
		}

		if(strcmp(choice, "interior", true) == 0)
		{
			new Float:pos[3];
			GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
			format(szMiscArray, sizeof(szMiscArray), "%s has edited DoorID %d's Interior (B: %f, %f, %f | A: %f, %f, %f)", GetPlayerNameEx(playerid), doorid, DDoorsInfo[doorid][ddInteriorX], DDoorsInfo[doorid][ddInteriorY], DDoorsInfo[doorid][ddInteriorZ], pos[0], pos[1], pos[2]);
			Log("logs/ddedit.log", szMiscArray);
			GetPlayerPos(playerid, DDoorsInfo[doorid][ddInteriorX], DDoorsInfo[doorid][ddInteriorY], DDoorsInfo[doorid][ddInteriorZ]);
			GetPlayerFacingAngle(playerid, DDoorsInfo[doorid][ddInteriorA]);
			DDoorsInfo[doorid][ddInteriorInt] = GetPlayerInterior(playerid);
			DDoorsInfo[doorid][ddInteriorVW] = GetPlayerVirtualWorld(playerid);
			SendClientMessageEx(playerid, COLOR_WHITE, "You have changed the interior!");
			SaveDynamicDoor(doorid);
			CreateDynamicDoor(doorid);
			return 1;
		}
		else if(strcmp(choice, "custominterior", true) == 0)
		{
			if(DDoorsInfo[doorid][ddCustomInterior] == 0)
			{
				DDoorsInfo[doorid][ddCustomInterior] = 1;
				SendClientMessageEx(playerid, COLOR_WHITE, "Door set to custom interior!");
			}
			else
			{
				DDoorsInfo[doorid][ddCustomInterior] = 0;
				SendClientMessageEx(playerid, COLOR_WHITE, "Door set to normal (not custom) interior!");
			}
			SaveDynamicDoor(doorid);
			format(string, sizeof(string), "%s has edited DoorID %d's CustomInterior.", GetPlayerNameEx(playerid), doorid);
			Log("logs/ddedit.log", string);
			return 1;
		}
		else if(strcmp(choice, "customexterior", true) == 0)
		{
			if(DDoorsInfo[doorid][ddCustomExterior] == 0)
			{
				DDoorsInfo[doorid][ddCustomExterior] = 1;
				SendClientMessageEx(playerid, COLOR_WHITE, "Door set to custom exterior!");
			}
			else
			{
				DDoorsInfo[doorid][ddCustomExterior] = 0;
				SendClientMessageEx(playerid, COLOR_WHITE, "Door set to normal (not custom) exterior!");
			}
			SaveDynamicDoor(doorid);
			CreateDynamicDoor(doorid);
			format(string, sizeof(string), "%s has edited DoorID %d's CustomExterior.", GetPlayerNameEx(playerid), doorid);
			Log("logs/ddedit.log", string);
			return 1;
		}
		else if(strcmp(choice, "exterior", true) == 0)
		{
			new Float:pos[3];
			GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
			format(szMiscArray, sizeof(szMiscArray), "%s has edited DoorID %d's Exterior (B: %f, %f, %f | A: %f, %f, %f)", GetPlayerNameEx(playerid), doorid, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], pos[0], pos[1], pos[2]);
			Log("logs/ddedit.log", szMiscArray);
			GetPlayerPos(playerid, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ]);
			GetPlayerFacingAngle(playerid, DDoorsInfo[doorid][ddExteriorA]);
			DDoorsInfo[doorid][ddExteriorVW] = GetPlayerVirtualWorld(playerid);
			DDoorsInfo[doorid][ddExteriorInt] = GetPlayerInterior(playerid);
			SendClientMessageEx(playerid, COLOR_WHITE, "You have changed the exterior!");
			DestroyDynamicPickup(DDoorsInfo[doorid][ddPickupID]);
			if(IsValidDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID])) DestroyDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID]);
			SaveDynamicDoor(doorid);
			CreateDynamicDoor(doorid);
		}
		else if(strcmp(choice, "type", true) == 0)
		{
			DDoorsInfo[doorid][ddType] = amount;

			format(string, sizeof(string), "You have changed the type to %d.", amount);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			switch(DDoorsInfo[doorid][ddType])
			{
				case 1:
				{
					if(DDoorsInfo[doorid][ddOwner] != -1 && strcmp(DDoorsInfo[doorid][ddOwnerName], "Nobody", false) != 0)
					{
						DestroyDynamicPickup(DDoorsInfo[doorid][ddPickupID]);
						if(IsValidDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID])) DestroyDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID]);
					}
					else SendClientMessageEx(playerid, COLOR_GREY, "Use /ddowner to update the owner of this door.");
				}
				case 2:
				{
					if(DDoorsInfo[doorid][ddFaction] != INVALID_GROUP_ID)
					{
						DDoorsInfo[doorid][ddOwner] = -1;
						strcat((DDoorsInfo[doorid][ddOwnerName][0] = 0, DDoorsInfo[doorid][ddOwnerName]), arrGroupData[DDoorsInfo[doorid][ddFaction]][g_szGroupName], 42);
						DestroyDynamicPickup(DDoorsInfo[doorid][ddPickupID]);
						if(IsValidDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID])) DestroyDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID]);
					}
					else SendClientMessageEx(playerid, COLOR_GREY, "Use /ddedit faction to update the owner of this door.");
				}
				default:
				{
					strcat((DDoorsInfo[doorid][ddOwnerName][0] = 0, DDoorsInfo[doorid][ddOwnerName]), "Nobody", 42);
					DestroyDynamicPickup(DDoorsInfo[doorid][ddPickupID]);
					if(IsValidDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID])) DestroyDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID]);
				}
			}
			SaveDynamicDoor(doorid);
			CreateDynamicDoor(doorid);

			format(string, sizeof(string), "%s has edited DoorID %d's type.", GetPlayerNameEx(playerid), doorid);
			Log("logs/ddedit.log", string);
			return 1;
		}
		else if(strcmp(choice, "rank", true) == 0)
		{
			DDoorsInfo[doorid][ddRank] = amount;

			format(string, sizeof(string), "You have changed the rank to %d.", amount);
			SendClientMessageEx(playerid, COLOR_WHITE, string);

			SaveDynamicDoor(doorid);
			format(string, sizeof(string), "%s has edited DoorID %d's rank.", GetPlayerNameEx(playerid), doorid);
			Log("logs/ddedit.log", string);
			return 1;
		}
		else if(strcmp(choice, "vip", true) == 0)
		{
			DDoorsInfo[doorid][ddVIP] = amount;

			format(string, sizeof(string), "You have changed the VIP Level to %d.", amount);
			SendClientMessageEx(playerid, COLOR_WHITE, string);

			SaveDynamicDoor(doorid);
			format(string, sizeof(string), "%s has edited DoorID %d's VIP Level.", GetPlayerNameEx(playerid), doorid);
			Log("logs/ddedit.log", string);
			return 1;
		}
		else if(strcmp(choice, "famed", true) == 0)
		{
			DDoorsInfo[doorid][ddFamed] = amount;

			format(string, sizeof(string), "You have changed the Famed Level to %d.", amount);
			SendClientMessageEx(playerid, COLOR_WHITE, string);

			SaveDynamicDoor(doorid);
			format(string, sizeof(string), "%s has edited DoorID %d's Famed Level.", GetPlayerNameEx(playerid), doorid);
			Log("logs/ddedit.log", string);
			return 1;
		}
		else if(strcmp(choice, "dpc", true) == 0)
		{
			if(DDoorsInfo[doorid][ddDPC] == 0)
			{
				DDoorsInfo[doorid][ddDPC] = 1;
				SendClientMessageEx(playerid, COLOR_WHITE, "Door set to DPC!");
			}
			else
			{
				DDoorsInfo[doorid][ddDPC] = 0;
				SendClientMessageEx(playerid, COLOR_WHITE, "Door set to normal (no longer DPC)!");
			}
			SaveDynamicDoor(doorid);
			format(string, sizeof(string), "%s has set DoorID %d's DPC value.", GetPlayerNameEx(playerid), doorid);
			Log("logs/ddedit.log", string);
			return 1;
		}
		else if(strcmp(choice, "allegiance", true) == 0)
		{
			DDoorsInfo[doorid][ddAllegiance] = amount;

			format(string, sizeof(string), "You have changed the Allegiance to %d.", amount);
			SendClientMessageEx(playerid, COLOR_WHITE, string);

			SaveDynamicDoor(doorid);
			format(string, sizeof(string), "%s has edited DoorID %d's Allegiance to %d.", GetPlayerNameEx(playerid), doorid, amount);
			Log("logs/ddedit.log", string);
			return 1;
		}
		else if(strcmp(choice, "grouptype", true) == 0)
		{
			DDoorsInfo[doorid][ddGroupType] = amount;

			format(string, sizeof(string), "You have changed the Group Type to %d.", amount);
			SendClientMessageEx(playerid, COLOR_WHITE, string);

			SaveDynamicDoor(doorid);
			format(string, sizeof(string), "%s has edited DoorID %d's Group Type to %d.", GetPlayerNameEx(playerid), doorid, amount);
			Log("logs/ddedit.log", string);
			return 1;
		}
		else if(strcmp(choice, "faction", true) == 0)
		{
			DDoorsInfo[doorid][ddFaction] = amount-1;

			format(string, sizeof(string), "You have changed the Faction to %d.", amount);
			SendClientMessageEx(playerid, COLOR_WHITE, string);

			if(DDoorsInfo[doorid][ddType] == 2)
			{
				strcat((DDoorsInfo[doorid][ddOwnerName][0] = 0, DDoorsInfo[doorid][ddOwnerName]), arrGroupData[DDoorsInfo[doorid][ddFaction]][g_szGroupName], 42);
				DestroyDynamicPickup(DDoorsInfo[doorid][ddPickupID]);
				if(IsValidDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID])) DestroyDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID]);
				CreateDynamicDoor(doorid);
			}
			else
			{
				format(string, sizeof(string), "Use '/ddedit type %d 2' to update the owner of this door.", doorid);
				SendClientMessageEx(playerid, COLOR_GREY, string);
			}

			SaveDynamicDoor(doorid);
			format(string, sizeof(string), "%s has edited DoorID %d's Faction.", GetPlayerNameEx(playerid), doorid);
			Log("logs/ddedit.log", string);
			return 1;
		}
		else if(strcmp(choice, "admin", true) == 0)
		{
			DDoorsInfo[doorid][ddAdmin] = amount;

			format(string, sizeof(string), "You have changed the Admin Level to %d.", amount);
			SendClientMessageEx(playerid, COLOR_WHITE, string);

			SaveDynamicDoor(doorid);
			format(string, sizeof(string), "%s has edited DoorID %d's Admin Level.", GetPlayerNameEx(playerid), doorid);
			Log("logs/ddedit.log", string);
			return 1;
		}
		else if(strcmp(choice, "wanted", true) == 0)
		{
			DDoorsInfo[doorid][ddWanted] = amount;

			format(string, sizeof(string), "You have changed the Wanted to %d.", amount);
			SendClientMessageEx(playerid, COLOR_WHITE, string);

			SaveDynamicDoor(doorid);
			format(string, sizeof(string), "%s has edited DoorID %d's Wanted.", GetPlayerNameEx(playerid), doorid);
			Log("logs/ddedit.log", string);
			return 1;
		}
		else if(strcmp(choice, "vehicleable", true) == 0)
		{
			DDoorsInfo[doorid][ddVehicleAble] = amount;

			format(string, sizeof(string), "You have changed the VehicleAble to %d.", amount);
			SendClientMessageEx(playerid, COLOR_WHITE, string);

			SaveDynamicDoor(doorid);
			format(string, sizeof(string), "%s has edited DoorID %d's VehicleAble.", GetPlayerNameEx(playerid), doorid);
			Log("logs/ddedit.log", string);
			return 1;
		}
		else if(strcmp(choice, "color", true) == 0)
		{
			DDoorsInfo[doorid][ddColor] = amount;

			format(string, sizeof(string), "You have changed the Color to %d.", amount);
			SendClientMessageEx(playerid, COLOR_WHITE, string);

			DestroyDynamicPickup(DDoorsInfo[doorid][ddPickupID]);
			if(IsValidDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID])) DestroyDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID]);

			SaveDynamicDoor(doorid);
			CreateDynamicDoor(doorid);
			format(string, sizeof(string), "%s has edited DoorID %d's Color.", GetPlayerNameEx(playerid), doorid);
			Log("logs/ddedit.log", string);
			return 1;
		}
		else if(strcmp(choice, "pickupmodel", true) == 0)
		{
			DDoorsInfo[doorid][ddPickupModel] = amount;

			format(string, sizeof(string), "You have changed the PickupModel to %d.", amount);
			SendClientMessageEx(playerid, COLOR_WHITE, string);

			DestroyDynamicPickup(DDoorsInfo[doorid][ddPickupID]);
			if(IsValidDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID])) DestroyDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID]);

			SaveDynamicDoor(doorid);
			CreateDynamicDoor(doorid);
			format(string, sizeof(string), "%s has edited DoorID %d's PickupModel.", GetPlayerNameEx(playerid), doorid);
			Log("logs/ddedit.log", string);
			return 1;
		}
		else if(strcmp(choice, "delete", true) == 0)
		{
			if(strcmp(DDoorsInfo[doorid][ddDescription], "None", true) == 0) {
				format(string, sizeof(string), "DoorID %d does not exist.", doorid);
				SendClientMessageEx(playerid, COLOR_WHITE, string);
				return 1;
			}
			if(IsValidDynamicPickup(DDoorsInfo[doorid][ddPickupID])) DestroyDynamicPickup(DDoorsInfo[doorid][ddPickupID]);
			if(IsValidDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID])) DestroyDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID]);
			DDoorsInfo[doorid][ddDescription] = 0;
			DDoorsInfo[doorid][ddCustomInterior] = 0;
			DDoorsInfo[doorid][ddExteriorVW] = 0;
			DDoorsInfo[doorid][ddExteriorInt] = 0;
			DDoorsInfo[doorid][ddInteriorVW] = 0;
			DDoorsInfo[doorid][ddInteriorInt] = 0;
			DDoorsInfo[doorid][ddExteriorX] = 0;
			DDoorsInfo[doorid][ddExteriorY] = 0;
			DDoorsInfo[doorid][ddExteriorZ] = 0;
			DDoorsInfo[doorid][ddExteriorA] = 0;
			DDoorsInfo[doorid][ddInteriorX] = 0;
			DDoorsInfo[doorid][ddInteriorY] = 0;
			DDoorsInfo[doorid][ddInteriorZ] = 0;
			DDoorsInfo[doorid][ddInteriorA] = 0;
			DDoorsInfo[doorid][ddCustomExterior] = 0;
			DDoorsInfo[doorid][ddType] = 0;
			DDoorsInfo[doorid][ddRank] = 0;
			DDoorsInfo[doorid][ddVIP] = 0;
			DDoorsInfo[doorid][ddFamed] = 0;
			DDoorsInfo[doorid][ddDPC] = 0;
			DDoorsInfo[doorid][ddAllegiance] = 0;
			DDoorsInfo[doorid][ddGroupType] = 0;
			DDoorsInfo[doorid][ddFaction] = 0;
			DDoorsInfo[doorid][ddAdmin] = 0;
			DDoorsInfo[doorid][ddWanted] = 0;
			DDoorsInfo[doorid][ddVehicleAble] = 0;
			DDoorsInfo[doorid][ddColor] = 0;
			DDoorsInfo[doorid][ddPass] = 0;
			DDoorsInfo[doorid][ddLocked] = 0;
			SaveDynamicDoor(doorid);
			format(string, sizeof(string), "You have deleted DoorID %d.", doorid);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			format(string, sizeof(string), "%s has deleted DoorID %d.", GetPlayerNameEx(playerid), doorid);
			Log("logs/ddedit.log", string);
			return 1;
		}
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use that command.");
	return 1;
}

CMD:ddmove(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1) return SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use this command.");
	new doorid, giveplayerid, fee, minfee, choice[16];
	if(sscanf(params, "s[16]dudd", choice, doorid, giveplayerid, fee, minfee))
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /ddmove <Choice> <DoorID> <playerid> <Fine (Percent)> <min. fine>");
		SendClientMessageEx(playerid, COLOR_GREY, "Choice: Exterior | Interior");
		SendClientMessageEx(playerid, COLOR_GREY, "NOTE: Set fine as 0 if you don't want to fine this player.");
		return 1;
	}
	if(doorid >= MAX_DDOORS) return SendClientMessageEx( playerid, COLOR_WHITE, "Invalid Door ID!");
	new string[128];
	new totalwealth = PlayerInfo[giveplayerid][pAccount] + GetPlayerCash(giveplayerid);
	if(PlayerInfo[giveplayerid][pPhousekey] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[giveplayerid][pPhousekey]][hOwnerID] == GetPlayerSQLId(giveplayerid)) totalwealth += HouseInfo[PlayerInfo[giveplayerid][pPhousekey]][hSafeMoney];
	if(PlayerInfo[giveplayerid][pPhousekey2] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[giveplayerid][pPhousekey2]][hOwnerID] == GetPlayerSQLId(giveplayerid)) totalwealth += HouseInfo[PlayerInfo[giveplayerid][pPhousekey2]][hSafeMoney];
	if(PlayerInfo[giveplayerid][pPhousekey3] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[giveplayerid][pPhousekey3]][hOwnerID] == GetPlayerSQLId(giveplayerid)) totalwealth += HouseInfo[PlayerInfo[giveplayerid][pPhousekey3]][hSafeMoney];
	if(fee > 0)
	{
		fee = totalwealth / 100 * fee;
		if(PlayerInfo[giveplayerid][pDonateRank] == 3)
		{
			fee = fee / 100 * 95;
		}
		if(PlayerInfo[giveplayerid][pDonateRank] >= 4)
		{
			fee = fee / 100 * 85;
		}
	}
	if(strcmp(choice, "interior", true) == 0)
	{
		GetPlayerPos(playerid, DDoorsInfo[doorid][ddInteriorX], DDoorsInfo[doorid][ddInteriorY], DDoorsInfo[doorid][ddInteriorZ]);
		GetPlayerFacingAngle(playerid, DDoorsInfo[doorid][ddInteriorA]);
		DDoorsInfo[doorid][ddInteriorInt] = GetPlayerInterior(playerid);
		DDoorsInfo[doorid][ddInteriorVW] = GetPlayerVirtualWorld(playerid);
		SendClientMessageEx(playerid, COLOR_WHITE, "You have changed the interior!");
		SaveDynamicDoor(doorid);
		format(string, sizeof(string), "%s has edited DoorID %d's Interior.", GetPlayerNameEx(playerid), doorid);
		Log("logs/ddedit.log", string);
		if(minfee > fee && minfee > 0)
		{
			GivePlayerCashEx(giveplayerid, TYPE_ONHAND, -minfee);
			format(string, sizeof(string), "AdmCmd: %s(%d) was fined $%s by %s, reason: Dynamic Door Move", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), number_format(minfee), GetPlayerNameEx(playerid));
			Log("logs/admin.log", string);
			format(string, sizeof(string), "AdmCmd: %s was fined $%s by %s, reason: Dynamic Door Move", GetPlayerNameEx(giveplayerid), number_format(minfee), GetPlayerNameEx(playerid));
			SendClientMessageToAllEx(COLOR_LIGHTRED, string);
			
		}
		else if(fee > 0)
		{
			GivePlayerCashEx(giveplayerid, TYPE_ONHAND, -fee);
			format(string, sizeof(string), "AdmCmd: %s(%d) was fined $%s by %s, reason: Dynamic Door Move", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), number_format(fee), GetPlayerNameEx(playerid));
			Log("logs/admin.log", string);
			format(string, sizeof(string), "AdmCmd: %s was fined $%s by %s, reason: Dynamic Door Move", GetPlayerNameEx(giveplayerid), number_format(fee), GetPlayerNameEx(playerid));
			SendClientMessageToAllEx(COLOR_LIGHTRED, string);
		}
	}
	else if(strcmp(choice, "exterior", true) == 0)
	{
		GetPlayerPos(playerid, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ]);
		GetPlayerFacingAngle(playerid, DDoorsInfo[doorid][ddExteriorA]);
		DDoorsInfo[doorid][ddExteriorVW] = GetPlayerVirtualWorld(playerid);
		DDoorsInfo[doorid][ddExteriorInt] = GetPlayerInterior(playerid);
		SendClientMessageEx(playerid, COLOR_WHITE, "You have changed the exterior!");
		DestroyDynamicPickup(DDoorsInfo[doorid][ddPickupID]);
		if(IsValidDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID])) DestroyDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID]);
		SaveDynamicDoor(doorid);
		format(string, sizeof(string), "%s has edited DoorID %d's Exterior.", GetPlayerNameEx(playerid), doorid);
		Log("logs/ddedit.log", string);
		if(minfee > fee && minfee > 0)
		{
			GivePlayerCashEx(giveplayerid, TYPE_ONHAND, -minfee);
			format(string, sizeof(string), "AdmCmd: %s(%d) was fined $%s by %s, reason: Dynamic Door Move", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), number_format(minfee), GetPlayerNameEx(playerid));
			Log("logs/admin.log", string);
			format(string, sizeof(string), "AdmCmd: %s was fined $%s by %s, reason: Dynamic Door Move", GetPlayerNameEx(giveplayerid), number_format(minfee), GetPlayerNameEx(playerid));
			SendClientMessageToAllEx(COLOR_LIGHTRED, string);
		}
		else if(fee > 0)
		{
			GivePlayerCashEx(giveplayerid, TYPE_ONHAND, -fee);
			format(string, sizeof(string), "AdmCmd: %s(%d) was fined $%s by %s, reason: Dynamic Door Move", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), number_format(fee), GetPlayerNameEx(playerid));
			Log("logs/admin.log", string);
			format(string, sizeof(string), "AdmCmd: %s was fined $%s by %s, reason: Dynamic Door Move", GetPlayerNameEx(giveplayerid), number_format(fee), GetPlayerNameEx(playerid));
			SendClientMessageToAllEx(COLOR_LIGHTRED, string);
		}
	}
	CreateDynamicDoor(doorid);

	return 1;
}

forward DeleteDynamicDoor(doorid, adminid);
public DeleteDynamicDoor(doorid, adminid)
{
	format(DDoorsInfo[doorid][ddDescription], 128, "None");
	DDoorsInfo[doorid][ddOwner] = -1;
	format(DDoorsInfo[doorid][ddOwnerName], MAX_PLAYER_NAME, "Nobody");
	if(IsValidDynamicPickup(DDoorsInfo[doorid][ddPickupID])) DestroyDynamicPickup(DDoorsInfo[doorid][ddPickupID]), DDoorsInfo[doorid][ddPickupID] = -1;
	if(IsValidDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID])) DestroyDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID]), DDoorsInfo[doorid][ddTextID] = Text3D:-1;
	DDoorsInfo[doorid][ddCustomInterior] = 0;
	DDoorsInfo[doorid][ddExteriorVW] = 0;
	DDoorsInfo[doorid][ddExteriorInt] = 0;
	DDoorsInfo[doorid][ddInteriorVW] = 0;
	DDoorsInfo[doorid][ddInteriorInt] = 0;
	DDoorsInfo[doorid][ddExteriorX] = 0.0;
	DDoorsInfo[doorid][ddExteriorY] = 0.0;
	DDoorsInfo[doorid][ddExteriorZ] = 0.0;
	DDoorsInfo[doorid][ddExteriorA] = 0.0;
	DDoorsInfo[doorid][ddInteriorX] = 0.0;
	DDoorsInfo[doorid][ddInteriorY] = 0.0;
	DDoorsInfo[doorid][ddInteriorZ] = 0.0;
	DDoorsInfo[doorid][ddInteriorA] = 0.0;
	DDoorsInfo[doorid][ddCustomExterior] = 0;
	DDoorsInfo[doorid][ddType] = 0;
	DDoorsInfo[doorid][ddRank] = 0;
	DDoorsInfo[doorid][ddVIP] = 0;
	DDoorsInfo[doorid][ddFamed] = 0;
	DDoorsInfo[doorid][ddDPC] = 0;
	DDoorsInfo[doorid][ddAllegiance] = 0;
	DDoorsInfo[doorid][ddGroupType] = 0;
	DDoorsInfo[doorid][ddFaction] = 0;
	DDoorsInfo[doorid][ddAdmin] = 0;
	DDoorsInfo[doorid][ddWanted] = 0;
	DDoorsInfo[doorid][ddVehicleAble] = 0;
	DDoorsInfo[doorid][ddColor] = 0;
	DDoorsInfo[doorid][ddPickupModel] = 0;
	DDoorsInfo[doorid][ddPass][0] = 0;
	DDoorsInfo[doorid][ddLocked] = 0;
	DDoorsInfo[doorid][ddLastLogin] = 0;
	DDoorsInfo[doorid][ddExpire] = 0;
	DDoorsInfo[doorid][ddInactive] = 0;
	DDoorsInfo[doorid][ddIgnore] = 0;
	DDoorsInfo[doorid][ddCounter] = 0;
	SaveDynamicDoor(doorid);
	szMiscArray[0] = 0;
	format(szMiscArray, sizeof(szMiscArray), "%s has deleted door id %d", adminid != INVALID_PLAYER_ID ? GetPlayerNameEx(adminid) : ("(Inactive Player Resource System)"), doorid);
	Log("logs/ddedit.log", szMiscArray);
	return 1;
}