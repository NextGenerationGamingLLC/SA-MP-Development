/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Business System

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

CMD:businessdate(playerid, params[]) {
	new giveplayerid;
	if(PlayerInfo[playerid][pAdmin] < 2)
	{
	    giveplayerid = playerid;
	}
	else
	{
	    if(sscanf(params, "u", giveplayerid)) giveplayerid = playerid;
	}
	if(IsValidBusinessID(PlayerInfo[playerid][pBusiness]))
	{
	    new string[128];
	    new datestring[32];
		datestring = date(Businesses[PlayerInfo[giveplayerid][pBusiness]][bMonths], 4);
		if(Businesses[PlayerInfo[giveplayerid][pBusiness]][bMonths] == 0) format(string, sizeof(string), "* Your business subscription is not set to expire.");
		else format(string, sizeof(string), "* Your business subscription expires on %s.", datestring);
	    SendClientMessageEx(playerid, COLOR_VIP, string);
	}
	else SendClientMessageEx(playerid, COLOR_GRAD2, "You don't have a business subscription.");
	return 1;
}

CMD:businesshelp(playerid, params[])
{
    SendClientMessageEx(playerid, COLOR_GREEN,"_______________________________________");
    SendClientMessageEx(playerid, COLOR_WHITE,"*** BUSINESS HELP *** - type a command for more infomation.");
	SendClientMessageEx(playerid, COLOR_GRAD3,"*** BUSINESS *** /buybizlevel /binvite /buninvite /bouninvite /bgiverank /resign /bsafe");
	SendClientMessageEx(playerid, COLOR_GRAD3,"*** BUSINESS *** /binventory /offeritem /resupply /checkresupply /cancelresupply /minrank");
	SendClientMessageEx(playerid, COLOR_GRAD3,"*** BUSINESS *** /employeepayset /employeeautopay /editgasprice /editprices /bizlock");
	SendClientMessageEx(playerid, COLOR_GRAD3,"*** BUSINESS *** /bauto /bonline /bpanic /b(iz)r(adio)");
	if(IsValidBusinessID(PlayerInfo[playerid][pBusiness]))
	{
		if(Businesses[PlayerInfo[playerid][pBusiness]][bType] == BUSINESS_TYPE_NEWCARDEALERSHIP || Businesses[PlayerInfo[playerid][pBusiness]][bType] == BUSINESS_TYPE_OLDCARDEALERSHIP) {
			SendClientMessageEx(playerid, COLOR_GRAD3, "*** BUSINESS *** /editcarprice /editcarspawn");
		}
		else if(Businesses[PlayerInfo[playerid][pBusiness]][bType] == BUSINESS_TYPE_GUNSHOP) {
		    SendClientMessageEx(playerid, COLOR_GRAD3, "*** BUSINESS *** /offergun /addmat(erial)s");
		}
		else if(Businesses[PlayerInfo[playerid][pBusiness]][bType] == BUSINESS_TYPE_STORE) {
		    SendClientMessageEx(playerid, COLOR_GRAD3, "*** BUSINESS *** /offeritem /editprices");
		}
		else if (Businesses[PlayerInfo[playerid][pBusiness]][bType] == BUSINESS_TYPE_BAR || Businesses[PlayerInfo[playerid][pBusiness]][bType] == BUSINESS_TYPE_CLUB || Businesses[PlayerInfo[playerid][pBusiness]][bType] == BUSINESS_TYPE_RESTAURANT) {
	        SendClientMessageEx(playerid, COLOR_GRAD3, "*** BUSINESS *** /offermenu");
	    }
	}
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pShopTech] > 0 || PlayerInfo[playerid][pBM] > 0)
	{
		SendClientMessageEx(playerid, COLOR_GRAD3, "*** BIZ ADMIN *** /bedit /bname (ST) /bnext (ST) /bnear (ST) /gotobiz (ST) /goinbiz (ST)");
		SendClientMessageEx(playerid, COLOR_GRAD3, "*** BIZ ADMIN *** /deletegaspump /asellbiz /creategaspump /editgaspump");
	}
    return 1;
}

CMD:bhelp(playerid, params[]) {
	return cmd_businesshelp(playerid, params);
}

CMD:bonline(playerid, params[]) {
	new iBusinessID = PlayerInfo[playerid][pBusiness];
    if((0 <= iBusinessID < MAX_BUSINESSES) && PlayerInfo[playerid][pBusinessRank] >= Businesses[iBusinessID][bMinInviteRank])
	{
		new szDialog[1024];
		//foreach(new i: Player)
		for(new i = 0; i < MAX_PLAYERS; ++i)
		{
			if(IsPlayerConnected(i))
			{
				if(PlayerInfo[i][pBusiness] == PlayerInfo[playerid][pBusiness] && (PlayerInfo[i][pTogReports] == 1 || PlayerInfo[i][pAdmin] < 2))
				{
					format(szDialog, sizeof(szDialog), "%s\n* %s (%s)", szDialog, GetPlayerNameEx(i), GetBusinessRankName(PlayerInfo[i][pBusinessRank]));
				}
			}	
		}
		if(!isnull(szDialog)) {
		    strdel(szDialog, 0, 1);
			ShowPlayerDialog(playerid, 0, DIALOG_STYLE_LIST, "Online Members", szDialog, "Select", "Cancel");
		}
		else SendClientMessageEx(playerid, COLOR_GREY, "No members are online at this time.");
    }
	else SendClientMessageEx(playerid, COLOR_GREY, "Only business leaders may use this command.");
    return 1;
}

CMD:buy(playerid, params[])
{
   	if (!IsAt247(playerid)) {
        SendClientMessageEx(playerid, COLOR_GRAD2, "   You are not in a 24/7!");
        return 1;
    }

	new iBusiness = InBusiness(playerid);

    if (Businesses[iBusiness][bAutoSale]) {
		if (Businesses[iBusiness][bInventory] < 1) {
			SendClientMessageEx(playerid, COLOR_WHITE, "This store does not have any items at the moment!");
			return 1;
		}
		if (!Businesses[iBusiness][bStatus]) {
			SendClientMessageEx(playerid, COLOR_WHITE, "This store is closed!");
			return 1;
		}
	} else return SendClientMessageEx(playerid, COLOR_WHITE, "You need to interact with the business employees to buy.");

	DisplayItemPricesDialog(iBusiness, playerid);

    return 1;
}

CMD:beginswimming(playerid, params[])
{
	if (!IsAtGym(playerid))
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "  You are not in a gym!");
		return 1;
	}

	new iBusiness = InBusiness(playerid);
	if(CheckPointCheck(playerid))
	{
	    return SendClientMessageEx(playerid, COLOR_GRAD2, "You must kill your current checkpoint first. (/killcheckpoint)");
	}
	if (Businesses[iBusiness][bGymType] != 1)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "  You can not /beginswimming in this type of gym!");
		return 1;
	}

	if (GetPVarInt(playerid, "_BoxingQueue") == 1)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "  You must leave the boxing queue first! (/leaveboxing)");
		return 1;
	}

	if (GetPVarInt(playerid, "_SwimmingActivity") >= 1)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "  You are already swimming! Use /stopswimming first.");
		return 1;
	}

	SetPVarInt(playerid, "_SwimmingActivity", 1);
	SetPlayerCheckpoint(playerid, 2892.5071, -2261.9607, 1.4645, 2.0);
	SendClientMessageEx(playerid, COLOR_WHITE, "Proceed to the first checkpoint to begin exercising.");
	SendClientMessageEx(playerid, COLOR_WHITE, "Type /stopswimming to exit your current activity.");
	if(!PlayerInfo[playerid][mCooldown][4] && !PlayerInfo[playerid][pShopNotice])
	{
		PlayerTextDrawSetString(playerid, MicroNotice[playerid], ShopMsg[10]);
		PlayerTextDrawShow(playerid, MicroNotice[playerid]);
		SetTimerEx("HidePlayerTextDraw", 10000, false, "ii", playerid, _:MicroNotice[playerid]);
	}
	return 1;
}

CMD:stopswimming(playerid, params[])
{
	if (!IsAtGym(playerid))
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "  You are not in a gym!");
		return 1;
	}

	if (GetPVarInt(playerid, "_SwimmingActivity") < 1)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "  You are not swimming!");
		return 1;
	}

	DeletePVar(playerid, "_SwimmingActivity");
	DisablePlayerCheckpoint(playerid);

	SendClientMessageEx(playerid, COLOR_GREY, "You have stopped exercising.");

	return 1;
}

CMD:joinboxing(playerid, params[])
{
	if (!IsAtGym(playerid))
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "  You are not in a gym!");
		return 1;
	}

	new iBusiness = InBusiness(playerid);
	if (Businesses[iBusiness][bGymType] != 1)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "  You can not /joinboxing in this type of gym!");
		return 1;
	}

	if (GetPVarInt(playerid, "_SwimmingActivity") >= 1)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "  You must stop swimming first! (/stopswimming)");
		return 1;
	}

	if (GetPVarInt(playerid, "_BoxingQueue") == 1)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "  You are already in the boxing queue!");
		return 1;
	}

	if (GetPVarInt(playerid, "_BoxingFight") != 0)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "  You are already in a boxing match!");
		return 1;
	}

	SetPVarInt(playerid, "_BoxingQueue", 1);
	SetPVarInt(playerid, "_BoxingQueueTick", 1);

	SendClientMessageEx(playerid, COLOR_WHITE, "You have joined the boxing queue.");

	return 1;
}

CMD:leaveboxing(playerid, params[])
{
	if (!IsAtGym(playerid))
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "  You are not in a gym!");
		return 1;
	}

	if (GetPVarInt(playerid, "_BoxingQueue") != 1)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "  You are not in the boxing queue.");
		return 1;
	}

	DeletePVar(playerid, "_BoxingQueue");
	DeletePVar(playerid, "_BoxingQueueTick");

	SendClientMessageEx(playerid, COLOR_WHITE, "You have left the boxing queue.");

	return 1;
}

CMD:beginparkour(playerid, params[])
{
	if (!IsAtGym(playerid))
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "  You are not in a gym!");
		return 1;
	}

	new iBusiness = InBusiness(playerid);
	if (Businesses[iBusiness][bGymType] != 1)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "  You can not /beginparkour in this type of gym!");
		return 1;
	}

	if (GetPVarInt(playerid, "_BikeParkourStage") != 0)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "  You are already participating in that activity!");
		return 1;
	}

	new bool:available = false;
	new pos;

	for (new it = 0; it < 9; ++it)
	{
		if (Businesses[iBusiness][bGymBikePlayers][it] == INVALID_PLAYER_ID)
		{
			available = true;
			Businesses[iBusiness][bGymBikePlayers][it] = playerid;
			pos = it;
			break;
		}
	}

	if (available == false)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "  Too many people are on this track, try again later.");
		return 1;
	}

	SendClientMessage(playerid, COLOR_WHITE, "Proceed to the pickup point to collect your bike.");
	SetPVarInt(playerid, "_BikeParkourStage", 1);
	SetPVarInt(playerid, "_BikeParkourSlot", pos);
	new pickup = CreateDynamicPickup(1318, 23, 2833.8757, -2256.8293, 95.9497, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
	SetPVarInt(playerid, "_BikeParkourPickup", pickup);
	if(!PlayerInfo[playerid][mCooldown][4] && !PlayerInfo[playerid][pShopNotice])
	{
		PlayerTextDrawSetString(playerid, MicroNotice[playerid], ShopMsg[10]);
		PlayerTextDrawShow(playerid, MicroNotice[playerid]);
		SetTimerEx("HidePlayerTextDraw", 10000, false, "ii", playerid, _:MicroNotice[playerid]);
	}
	return 1;
}

CMD:leaveparkour(playerid, params[])
{
	if (!IsAtGym(playerid))
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "  You are not in a gym!");
		return 1;
	}

	if (GetPVarInt(playerid, "_BikeParkourStage") == 0)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "  You are not participating in that activity.");
		return 1;
	}

	new iBusiness = InBusiness(playerid);
	Businesses[iBusiness][bGymBikePlayers][GetPVarInt(playerid, "_BikeParkourSlot")] = INVALID_PLAYER_ID;

	SendClientMessageEx(playerid, COLOR_WHITE, "You have left the biking activity.");

	new vehicle = Businesses[iBusiness][bGymBikeVehicles][GetPVarInt(playerid, "_BikeParkourSlot")];

	if (vehicle != INVALID_VEHICLE_ID)
	{
		DestroyVehicle(vehicle);
		Businesses[iBusiness][bGymBikeVehicles][GetPVarInt(playerid, "_BikeParkourSlot")] = INVALID_VEHICLE_ID;
	}

	DeletePVar(playerid, "_BikeParkourStage");
	DeletePVar(playerid, "_BikeParkourSlot");

	new pickup = GetPVarInt(playerid, "_BikeParkourPickup");
	if (pickup != 0)
	{
		DestroyDynamicPickup(pickup);
		DeletePVar(playerid, "_BikeParkourPickup");
	}

	return 1;
}

CMD:bauto(playerid, params[])
{
   	new
	   iBusiness = PlayerInfo[playerid][pBusiness],
	   iRank     = PlayerInfo[playerid][pBusinessRank];

	if (iBusiness != INVALID_BUSINESS_ID && iRank >= 5)
	{
	    new iType = Businesses[iBusiness][bType];
	    if (iType == BUSINESS_TYPE_GASSTATION || iType == BUSINESS_TYPE_STORE || iType == BUSINESS_TYPE_CLOTHING) {
			if (Businesses[iBusiness][bAutoSale])	{
				Businesses[iBusiness][bAutoSale] = 0;
				SendClientMessageEx(playerid, COLOR_WHITE, "You have toggled off the automatic sales mode!");
				SaveBusiness(iBusiness);
			}
			else {
				Businesses[iBusiness][bAutoSale] = 1;
		       	SendClientMessageEx(playerid, COLOR_WHITE, "You have toggled on the automatic sales mode!");
		       	SendClientMessageEx(playerid, COLOR_GREY, "Note that this will cause decrease in profits!");
		       	SaveBusiness(iBusiness);
			}
	    }  else SendClientMessageEx(playerid, COLOR_WHITE, "Command not available for your business type!");
	} else SendClientMessageEx(playerid, COLOR_WHITE, "Only business owners can use this command!");
	return 1;
}

CMD:shop(playerid, params[])
{

	new iBusiness = InBusiness(playerid);

   	if (iBusiness == INVALID_BUSINESS_ID || Businesses[iBusiness][bType] != BUSINESS_TYPE_SEXSHOP) {
        SendClientMessageEx(playerid, COLOR_GRAD2, "You are not in a sex shop!");
        return 1;
    }
    if (Businesses[iBusiness][bAutoSale]) {
		if (Businesses[iBusiness][bInventory] < 1) {
		    SendClientMessageEx(playerid, COLOR_WHITE, "This sex shop does not have any items at the moment!");
		    return 1;
		}
		if (!Businesses[iBusiness][bStatus]) {
		    SendClientMessageEx(playerid, COLOR_WHITE, "This sex shop is closed!");
		    return 1;
		}
	} else return SendClientMessageEx(playerid, COLOR_WHITE, "You need to interact with the business employees to buy.");

	DisplayItemPricesDialog(iBusiness, playerid);

    return 1;
}

CMD:refuel(playerid, params[])
{
	new zyear, zmonth, zday;
	getdate(zyear, zmonth, zday);
	if(zombieevent || (zmonth == 10 && zday == 31) || (zmonth == 11 && zday == 1)) return SendClientMessageEx(playerid, -1, "You can't use Gas Stations during the Zombie Event!");
    if (GetPVarType(playerid, "Refueling"))
	{
	    SetPVarInt(playerid, "Refueling", -1);
	}
	else
	{

	    new vehicleid = GetPlayerVehicleID(playerid);

		new
			iBusinessID,
			iPumpID;

		GetClosestGasPump(playerid, iBusinessID, iPumpID);

		if (iBusinessID == INVALID_BUSINESS_ID) return SendClientMessageEx(playerid, COLOR_RED, "You're not at a fuel station.");
		if (!IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_RED, "You are not in a vehicle.");
		if (!Businesses[iBusinessID][bStatus]) return SendClientMessageEx(playerid, COLOR_RED, "This fuel station is closed.");
		if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessageEx(playerid, COLOR_RED, "You're not the driver.");
		if (IsVIPcar(vehicleid)) return SendClientMessageEx(playerid, COLOR_RED, "This is a vehicle from the VIP garage and it has already unlimited amount of fuel.");
		if (IsFamedVeh(vehicleid)) return SendClientMessageEx(playerid, COLOR_RED, "This is a vehicle from the Famed garage and it has already unlimited amount of fuel.");
		if (IsAdminSpawnedVehicle(vehicleid)) return SendClientMessageEx(playerid, COLOR_RED, "This is an admin-spawned vehicle and it has already unlimited amount of fuel.");
	    new engine,lights,alarm,doors,bonnet,boot,objective;
    	GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
	    if(engine == VEHICLE_PARAMS_ON) return SendClientMessageEx(playerid, COLOR_RED, "You need to shut off the engine before filling up (/car engine).");
     	if (Businesses[iBusinessID][GasPumpGallons][iPumpID] == 0.0) return SendClientMessageEx(playerid, COLOR_RED, "No gas left in the gas station tank.");
	    if (!IsRefuelableVehicle(vehicleid)) return SendClientMessageEx(playerid,COLOR_RED,"This vehicle does not need fuel.");
	    if (VehicleFuel[vehicleid] >= 100.0) return SendClientMessageEx(playerid, COLOR_RED, "This vehicle's tank is already full.");
	    if (Businesses[iBusinessID][GasPumpVehicleID][iPumpID] > 0) return SendClientMessageEx(playerid, COLOR_RED, "This gas pump is occupied.");

       	SendClientMessageEx(playerid, COLOR_WHITE, "Refueling your vehicle's tank, please wait.");
       	SendClientMessageEx(playerid, COLOR_YELLOW, "Type /refuel again to stop refueling.");

		SetPVarInt(playerid, "Refueling", vehicleid);
       	Businesses[iBusinessID][GasPumpSaleGallons][iPumpID] = 0;
       	Businesses[iBusinessID][GasPumpSalePrice][iPumpID] = 0;
       	Businesses[iBusinessID][GasPumpVehicleID][iPumpID] = vehicleid;
       	Businesses[iBusinessID][GasPumpTimer][iPumpID] = SetTimerEx("GasPumpSaleTimer", 200, true, "iii", playerid, iBusinessID, iPumpID);
	}
	return 1;
}
