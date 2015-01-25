/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

				Dynamic PaynSpray System

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

forward PayNSpray(playerid, id, vehicleid);
public PayNSpray(playerid, id, vehicleid)
{
	if(DynVeh[vehicleid] != -1 && DynVehicleInfo[DynVeh[vehicleid]][gv_igID] != INVALID_GROUP_ID)
	{
		new iGroupID = DynVehicleInfo[DynVeh[vehicleid]][gv_igID];
		if(arrGroupData[iGroupID][g_iBudget] >= PayNSprays[id][pnsGroupCost])
		{
			arrGroupData[iGroupID][g_iBudget] -= PayNSprays[id][pnsGroupCost];
			new str[128], file[32];
			format(str, sizeof(str), "%s has repaired vehicle %d at a cost of $%s to %s's budget fund.", GetPlayerNameEx(playerid), GetPlayerVehicleID(playerid), number_format(PayNSprays[id][pnsGroupCost]), arrGroupData[iGroupID][g_szGroupName]);
			new month, day, year;
			getdate(year,month,day);
			format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", iGroupID, month, day, year);
			Log(file, str);
			SendClientMessageEx(playerid, COLOR_GREY, "This is a group vehicle and the repair cost has been paid by your agency.");
		}
		else
		{
			SendClientMessage(playerid, COLOR_WHITE, "Your agency does not have enough money in their funds to pay for this!");
			TogglePlayerControllable(playerid, 1);
			return 1;
		}
	}
	else
	{
		if(PlayerInfo[playerid][pCash] >= PayNSprays[id][pnsRegCost])
		{
			GivePlayerCash(playerid, -PayNSprays[id][pnsRegCost]);
		}
		else
		{
			SendClientMessage(playerid, COLOR_WHITE, "You don't have enough money to pay for this!");
			TogglePlayerControllable(playerid, 1);
			return 1;
		}
	}
	RepairVehicle(vehicleid);
	Vehicle_Armor(vehicleid);
	if(IsTrailerAttachedToVehicle(vehicleid))
	{
		RepairVehicle(GetVehicleTrailer(vehicleid));
		Vehicle_Armor(GetVehicleTrailer(vehicleid));
	}
	SendClientMessage(playerid, COLOR_WHITE, "Your vehicle has been repaired!");
	PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
	TogglePlayerControllable(playerid, 1);
	return 1;
}


CMD:pnsedit(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use that command.");
		return 1;
	}

	new string[128], choice[32], id, amount;
	if(sscanf(params, "s[32]dD", choice, id, amount))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /pnsedit [name] [id] [amount]");
		SendClientMessageEx(playerid, COLOR_GREY, "Available names: Position, GroupCost, RegCost, Delete");
		return 1;
	}

	if(id >= MAX_PAYNSPRAYS)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "Invalid Pay N' Spray ID!");
		return 1;
	}

	if(strcmp(choice, "position", true) == 0)
	{
		if(PayNSprays[id][pnsStatus] == 0)
		{
			PayNSprays[id][pnsStatus] = 1;
		}
		GetPlayerPos(playerid, PayNSprays[id][pnsPosX], PayNSprays[id][pnsPosY], PayNSprays[id][pnsPosZ]);
		PayNSprays[id][pnsInt] = GetPlayerInterior(playerid);
		PayNSprays[id][pnsVW] = GetPlayerVirtualWorld(playerid);
		format(string, sizeof(string), "You have changed the position on Pay N' Spray #%d.", id);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		DestroyDynamicPickup(PayNSprays[id][pnsPickupID]);
		DestroyDynamic3DTextLabel(PayNSprays[id][pnsTextID]);
		DestroyDynamicMapIcon(PayNSprays[id][pnsMapIconID]);
		format(string, sizeof(string), "/repaircar\nRepair Cost -- Regular: $%s | Faction: $%s\nID: %d", number_format(PayNSprays[id][pnsRegCost]), number_format(PayNSprays[id][pnsGroupCost]), id);
		PayNSprays[id][pnsTextID] = CreateDynamic3DTextLabel(string, COLOR_RED, PayNSprays[id][pnsPosX], PayNSprays[id][pnsPosY], PayNSprays[id][pnsPosZ]+0.5,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, PayNSprays[id][pnsVW], PayNSprays[id][pnsInt], -1);
		PayNSprays[id][pnsPickupID] = CreateDynamicPickup(1239, 23, PayNSprays[id][pnsPosX], PayNSprays[id][pnsPosY], PayNSprays[id][pnsPosZ], PayNSprays[id][pnsVW]);
		PayNSprays[id][pnsMapIconID] = CreateDynamicMapIcon(PayNSprays[id][pnsPosX], PayNSprays[id][pnsPosY], PayNSprays[id][pnsPosZ], 63, 0, PayNSprays[id][pnsVW], PayNSprays[id][pnsInt], -1, 500.0);
		SavePayNSpray(id);
		format(string, sizeof(string), "%s has edited Pay N' Spray ID %d's position.", GetPlayerNameEx(playerid), id);
		Log("logs/pnsedit.log", string);
		return 1;
	}
	else if(strcmp(choice, "groupcost", true) == 0)
	{
		if(PayNSprays[id][pnsStatus] == 0)
		{
			format(string, sizeof(string), "Pay N' Spray #%d does not exist.", id);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			return 1;
		}
		PayNSprays[id][pnsGroupCost] = amount;
		format(string, sizeof(string), "You have changed the group cost for Pay N' Spray #%d to $%s.", id, number_format(amount));
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		DestroyDynamic3DTextLabel(PayNSprays[id][pnsTextID]);
		format(string, sizeof(string), "/repaircar\nRepair Cost -- Regular: $%s | Faction: $%s\nID: %d", number_format(PayNSprays[id][pnsRegCost]), number_format(PayNSprays[id][pnsGroupCost]), id);
		PayNSprays[id][pnsTextID] = CreateDynamic3DTextLabel(string, COLOR_RED, PayNSprays[id][pnsPosX], PayNSprays[id][pnsPosY], PayNSprays[id][pnsPosZ]+0.5,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, PayNSprays[id][pnsVW], PayNSprays[id][pnsInt], -1);
		SavePayNSpray(id);
		format(string, sizeof(string), "%s has changed the group cost on Pay N' Spray ID %d to $%s.", GetPlayerNameEx(playerid), id, number_format(amount));
		Log("logs/pnsedit.log", string);
		return 1;
	}
	else if(strcmp(choice, "regcost", true) == 0)
	{
		if(PayNSprays[id][pnsStatus] == 0)
		{
			format(string, sizeof(string), "Pay N' Spray #%d does not exist.", id);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			return 1;
		}
		PayNSprays[id][pnsRegCost] = amount;
		format(string, sizeof(string), "You have changed the regular cost for Pay N' Spray #%d to $%s.", id, number_format(amount));
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		DestroyDynamic3DTextLabel(PayNSprays[id][pnsTextID]);
		format(string, sizeof(string), "/repaircar\nRepair Cost -- Regular: $%s | Faction: $%s\nID: %d", number_format(PayNSprays[id][pnsRegCost]), number_format(PayNSprays[id][pnsGroupCost]), id);
		PayNSprays[id][pnsTextID] = CreateDynamic3DTextLabel(string, COLOR_RED, PayNSprays[id][pnsPosX], PayNSprays[id][pnsPosY], PayNSprays[id][pnsPosZ]+0.5,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, PayNSprays[id][pnsVW], PayNSprays[id][pnsInt], -1);
		SavePayNSpray(id);
		format(string, sizeof(string), "%s has changed the regular cost on Pay N' Spray ID %d to $%s.", GetPlayerNameEx(playerid), id, number_format(amount));
		Log("logs/pnsedit.log", string);
		return 1;
	}
	else if(strcmp(choice, "delete", true) == 0)
	{
		if(PayNSprays[id][pnsStatus] == 0)
		{
			format(string, sizeof(string), "Pay N' Spray #%d does not exist.", id);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			return 1;
		}
   	  	DestroyDynamicPickup(PayNSprays[id][pnsPickupID]);
	    DestroyDynamic3DTextLabel(PayNSprays[id][pnsTextID]);
		DestroyDynamicMapIcon(PayNSprays[id][pnsMapIconID]);
		PayNSprays[id][pnsStatus] = 0;
		PayNSprays[id][pnsPosX] = 0.0;
		PayNSprays[id][pnsPosY] = 0.0;
		PayNSprays[id][pnsPosZ] = 0.0;
		PayNSprays[id][pnsVW] = 0;
		PayNSprays[id][pnsInt] = 0;
		PayNSprays[id][pnsGroupCost] = 0;
		PayNSprays[id][pnsRegCost] = 0;
		SavePayNSpray(id);
		format(string, sizeof(string), "You have deleted Pay N' Spray #%d.", id);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "%s has deleted Pay N' Spray ID %d.", GetPlayerNameEx(playerid), id);
		Log("logs/pnsedit.log", string);
		return 1;
	}
	return 1;
}

CMD:pnsstatus(playerid, params[])
{
	new id;
	if(sscanf(params, "i", id))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /pnsstatus [id]");
		return 1;
	}
	if (PlayerInfo[playerid][pAdmin] >= 4)
	{
		new string[128];
		format(string,sizeof(string),"|___________ Pay N' Spray Status (ID: %d) ___________|", id);
		SendClientMessageEx(playerid, COLOR_GREEN, string);
		format(string, sizeof(string), "[Position] X: %f | Y: %f | Z: %f | VW: %d | Int: %d", PayNSprays[id][pnsPosX], PayNSprays[id][pnsPosY], PayNSprays[id][pnsPosZ], PayNSprays[id][pnsVW], PayNSprays[id][pnsInt]);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "Group Cost: $%s | Regular Cost: $%s", number_format(PayNSprays[id][pnsGroupCost]), number_format(PayNSprays[id][pnsRegCost]));
		SendClientMessageEx(playerid, COLOR_WHITE, string);
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	}
	return 1;
}

CMD:pnsnext(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 4)
	{
		SendClientMessageEx(playerid, COLOR_RED, "* Listing next available Pay N' Spray...");
		for(new x = 0; x < MAX_PAYNSPRAYS; x++)
		{
			if(PayNSprays[x][pnsStatus] == 0)
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

CMD:gotopaynspray(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 4)
	{
		new id;
		if(sscanf(params, "d", id)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /gotopaynspray [id]");

		SetPlayerPos(playerid, PayNSprays[id][pnsPosX], PayNSprays[id][pnsPosY], PayNSprays[id][pnsPosZ]);
		SetPlayerInterior(playerid, PayNSprays[id][pnsInt]);
		PlayerInfo[playerid][pInt] = PayNSprays[id][pnsInt];
		SetPlayerVirtualWorld(playerid, PayNSprays[id][pnsVW]);
		PlayerInfo[playerid][pVW] = PayNSprays[id][pnsVW];
	}
	return 1;
}

CMD:repaircar(playerid, params[])
{
	new zyear, zmonth, zday;
	getdate(zyear, zmonth, zday);
	if(zombieevent || (zmonth == 10 && zday == 31) || (zmonth == 11 && zday == 1)) return SendClientMessageEx(playerid, -1, "You can't use Pay N' Spray's during the Zombie Event!");
	if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		for(new i; i < MAX_PAYNSPRAYS; i++)
		{
			if(IsPlayerInRangeOfPoint(playerid, 3.0, PayNSprays[i][pnsPosX], PayNSprays[i][pnsPosY], PayNSprays[i][pnsPosZ]) && GetPlayerVirtualWorld(playerid) == PayNSprays[i][pnsVW] && GetPlayerInterior(playerid) == PayNSprays[i][pnsInt])
			{
				if(PayNSprays[i][pnsStatus] > 0)
				{
					if(DynVeh[GetPlayerVehicleID(playerid)] != -1 && DynVehicleInfo[DynVeh[GetPlayerVehicleID(playerid)]][gv_igID] != INVALID_GROUP_ID)
					{
						new iGroupID = DynVehicleInfo[DynVeh[GetPlayerVehicleID(playerid)]][gv_igID];
						if(arrGroupData[iGroupID][g_iBudget] >= PayNSprays[i][pnsGroupCost])
						{
						}
						else return SendClientMessage(playerid, COLOR_WHITE, "Your agency does not have enough money in their funds to pay for this!");
					}
					else
					{
						if(PlayerInfo[playerid][pCash] >= PayNSprays[i][pnsRegCost])
						{
						}
						else return SendClientMessage(playerid, COLOR_WHITE, "You don't have enough money to pay for this!");
					}
					SetTimerEx("PayNSpray", 5000, false, "iii", playerid, i, GetPlayerVehicleID(playerid));
					TogglePlayerControllable(playerid, 0);
					GameTextForPlayer(playerid, "Repairing...", 5000, 5);
					return 1;
				}
			}
		}
		SendClientMessage(playerid, COLOR_WHITE, "You are not at a Pay N' Spray!");
	}
	else SendClientMessage(playerid, COLOR_WHITE, "You are not in a car!");
	return 1;
}

stock SavePayNSpray(id)
{
	new string[1024];
	format(string, sizeof(string), "UPDATE `paynsprays` SET \
		`Status`=%d, \
		`PosX`=%f, \
		`PosY`=%f, \
		`PosZ`=%f, \
		`VW`=%d, \
		`Int`=%d, \
		`GroupCost`=%d, \
		`RegCost`=%d WHERE `id`=%d",
		PayNSprays[id][pnsStatus],
		PayNSprays[id][pnsPosX],
		PayNSprays[id][pnsPosY],
		PayNSprays[id][pnsPosZ],
		PayNSprays[id][pnsVW],
		PayNSprays[id][pnsInt],
		PayNSprays[id][pnsGroupCost],
		PayNSprays[id][pnsRegCost],
		id
	);

	mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);
}

stock SavePayNSprays()
{
	for(new i = 0; i < MAX_PAYNSPRAYS; i++)
	{
		SavePayNSpray(i);
	}
	return 1;
}

stock RehashPayNSpray(id)
{
	DestroyDynamicPickup(PayNSprays[id][pnsPickupID]);
	DestroyDynamic3DTextLabel(PayNSprays[id][pnsTextID]);
	DestroyDynamicMapIcon(PayNSprays[id][pnsMapIconID]);
	PayNSprays[id][pnsSQLId] = -1;
	PayNSprays[id][pnsStatus] = 0;
	PayNSprays[id][pnsPosX] = 0.0;
	PayNSprays[id][pnsPosY] = 0.0;
	PayNSprays[id][pnsPosZ] = 0.0;
	PayNSprays[id][pnsVW] = 0;
	PayNSprays[id][pnsInt] = 0;
	PayNSprays[id][pnsGroupCost] = 0;
	PayNSprays[id][pnsRegCost] = 0;
	LoadPayNSpray(id);
}

stock RehashPayNSprays()
{
	printf("[RehashPayNSprays] Deleting Pay N' Sprays from server...");
	for(new i = 0; i < MAX_PAYNSPRAYS; i++)
	{
		RehashPayNSpray(i);
	}
	LoadPayNSprays();
}

stock LoadPayNSpray(id)
{
	new string[128];
	format(string, sizeof(string), "SELECT * FROM `paynsprays` WHERE `id`=%d", id);
	mysql_function_query(MainPipeline, string, true, "OnLoadPayNSprays", "i", id);
}

stock LoadPayNSprays()
{
	printf("[LoadPayNSprays] Loading data from database...");
	mysql_function_query(MainPipeline, "SELECT * FROM `paynsprays`", true, "OnLoadPayNSprays", "");
}

forward OnLoadPayNSpray(index);
public OnLoadPayNSpray(index)
{
	new rows, fields, tmp[128], string[128];
	cache_get_data(rows, fields, MainPipeline);

	for(new row; row < rows; row++)
	{
		cache_get_field_content(row, "id", tmp, MainPipeline);  PayNSprays[index][pnsSQLId] = strval(tmp);
		cache_get_field_content(row, "Status", tmp, MainPipeline); PayNSprays[index][pnsStatus] = strval(tmp);
		cache_get_field_content(row, "PosX", tmp, MainPipeline); PayNSprays[index][pnsPosX] = floatstr(tmp);
		cache_get_field_content(row, "PosY", tmp, MainPipeline); PayNSprays[index][pnsPosY] = floatstr(tmp);
		cache_get_field_content(row, "PosZ", tmp, MainPipeline); PayNSprays[index][pnsPosZ] = floatstr(tmp);
		cache_get_field_content(row, "VW", tmp, MainPipeline); PayNSprays[index][pnsVW] = strval(tmp);
		cache_get_field_content(row, "Int", tmp, MainPipeline); PayNSprays[index][pnsInt] = strval(tmp);
		cache_get_field_content(row, "GroupCost", tmp, MainPipeline); PayNSprays[index][pnsGroupCost] = strval(tmp);
		cache_get_field_content(row, "RegCost", tmp, MainPipeline); PayNSprays[index][pnsRegCost] = strval(tmp);
		if(PayNSprays[index][pnsStatus] > 0)
		{
			format(string, sizeof(string), "/repaircar\nRepair Cost -- Regular: $%s | Faction: $%s\nID: %d", number_format(PayNSprays[index][pnsRegCost]), number_format(PayNSprays[index][pnsGroupCost]), index);
			PayNSprays[index][pnsTextID] = CreateDynamic3DTextLabel(string, COLOR_RED, PayNSprays[index][pnsPosX], PayNSprays[index][pnsPosY], PayNSprays[index][pnsPosZ]+0.5,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, PayNSprays[index][pnsVW], PayNSprays[index][pnsInt], -1);
			PayNSprays[index][pnsPickupID] = CreateDynamicPickup(1239, 23, PayNSprays[index][pnsPosX], PayNSprays[index][pnsPosY], PayNSprays[index][pnsPosZ], PayNSprays[index][pnsVW]);
			PayNSprays[index][pnsMapIconID] = CreateDynamicMapIcon(PayNSprays[index][pnsPosX], PayNSprays[index][pnsPosY], PayNSprays[index][pnsPosZ], 63, 0, PayNSprays[index][pnsVW], PayNSprays[index][pnsInt], -1, 500.0);
		}
	}
	return 1;
}

forward OnLoadPayNSprays();
public OnLoadPayNSprays()
{
	new i, rows, fields, tmp[128], string[128];
	cache_get_data(rows, fields, MainPipeline);

	while(i < rows)
	{
		cache_get_field_content(i, "id", tmp, MainPipeline);  PayNSprays[i][pnsSQLId] = strval(tmp);
		cache_get_field_content(i, "Status", tmp, MainPipeline); PayNSprays[i][pnsStatus] = strval(tmp);
		cache_get_field_content(i, "PosX", tmp, MainPipeline); PayNSprays[i][pnsPosX] = floatstr(tmp);
		cache_get_field_content(i, "PosY", tmp, MainPipeline); PayNSprays[i][pnsPosY] = floatstr(tmp);
		cache_get_field_content(i, "PosZ", tmp, MainPipeline); PayNSprays[i][pnsPosZ] = floatstr(tmp);
		cache_get_field_content(i, "VW", tmp, MainPipeline); PayNSprays[i][pnsVW] = strval(tmp);
		cache_get_field_content(i, "Int", tmp, MainPipeline); PayNSprays[i][pnsInt] = strval(tmp);
		cache_get_field_content(i, "GroupCost", tmp, MainPipeline); PayNSprays[i][pnsGroupCost] = strval(tmp);
		cache_get_field_content(i, "RegCost", tmp, MainPipeline); PayNSprays[i][pnsRegCost] = strval(tmp);
		if(PayNSprays[i][pnsStatus] > 0)
		{
			if(PayNSprays[i][pnsPosX] != 0.0)
			{
				format(string, sizeof(string), "/repaircar\nRepair Cost -- Regular: $%s | Faction: $%s\nID: %d", number_format(PayNSprays[i][pnsRegCost]), number_format(PayNSprays[i][pnsGroupCost]), i);
				PayNSprays[i][pnsTextID] = CreateDynamic3DTextLabel(string, COLOR_RED, PayNSprays[i][pnsPosX], PayNSprays[i][pnsPosY], PayNSprays[i][pnsPosZ]+0.5,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, PayNSprays[i][pnsVW], PayNSprays[i][pnsInt], -1);
				PayNSprays[i][pnsPickupID] = CreateDynamicPickup(1239, 23, PayNSprays[i][pnsPosX], PayNSprays[i][pnsPosY], PayNSprays[i][pnsPosZ], PayNSprays[i][pnsVW]);
				PayNSprays[i][pnsMapIconID] = CreateDynamicMapIcon(PayNSprays[i][pnsPosX], PayNSprays[i][pnsPosY], PayNSprays[i][pnsPosZ], 63, 0, PayNSprays[i][pnsVW], PayNSprays[i][pnsInt], -1, 500.0);
			}
		}
		i++;
	}
}