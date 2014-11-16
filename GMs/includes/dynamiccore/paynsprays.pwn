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