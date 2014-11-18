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

stock IsAt247(playerid)
{
    new iBusiness = InBusiness(playerid);
   	return (iBusiness != INVALID_BUSINESS_ID && (Businesses[iBusiness][bType] == BUSINESS_TYPE_STORE || Businesses[iBusiness][bType] == BUSINESS_TYPE_GASSTATION));
}

stock IsAtClothingStore(playerid)
{
    new iBusiness = InBusiness(playerid);
   	return (iBusiness != INVALID_BUSINESS_ID && Businesses[iBusiness][bType] == BUSINESS_TYPE_CLOTHING);
}

stock IsAtRestaurant(playerid)
{
	new iBusiness = InBusiness(playerid);
	return (iBusiness != INVALID_BUSINESS_ID && Businesses[iBusiness][bType] == BUSINESS_TYPE_RESTAURANT);
}

stock IsAtGym(playerid)
{
	new iBusiness = InBusiness(playerid);
	return (iBusiness != INVALID_BUSINESS_ID && Businesses[iBusiness][bType] == BUSINESS_TYPE_GYM);
}

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

CMD:eba(playerid, params[]) {
	return cmd_emergencybutton(playerid, params);
}

CMD:emergencybutton(playerid, params[]) {
	if(arrGroupData[PlayerInfo[playerid][pMember]][g_iGroupType] == 7 || arrGroupData[PlayerInfo[playerid][pLeader]][g_iGroupType] == 7) {
		new
	    	string[128],
			Location[MAX_ZONE_NAME];

        if( PlayerCuffed[ playerid ] >= 1 || PlayerInfo[ playerid ][ pJailTime ] > 0 || PlayerInfo[playerid][pHospital] > 0 || PlayerTied[playerid] > 0 ) {
			SendClientMessageEx( playerid, COLOR_WHITE, "You can't do this right now." );
		}

		GetPlayer2DZone(playerid, Location, MAX_ZONE_NAME);
	    //foreach(new i: Player)
		for(new i = 0; i < MAX_PLAYERS; ++i)
		{
			if(IsPlayerConnected(i))
			{
				if(IsACop(i)) {
					SendClientMessageEx(i, TEAM_BLUE_COLOR, "HQ: All Units APB: Reporter: Taxi Company Office");
					format(string, sizeof(string), "HQ: A distress signal is forwarded from the Taxi Company Office for %s at %s",GetPlayerNameEx(playerid), Location);
					SendClientMessageEx(i, TEAM_BLUE_COLOR, string);
				}
			}	
		}
		format(string, sizeof(string), "* An alarm engages in %s's taxi at %s. A message is dispatched to the Companies office.", GetPlayerNameEx(playerid), Location);
		SendTaxiMessage(TEAM_AZTECAS_COLOR, string);
		SendClientMessage(playerid, COLOR_WHITE, "You have pressed the emergency button, police have been informed.");
	}
	return 1;
}

CMD:editcarspawn(playerid, params[])
{
    if(PlayerInfo[playerid][pBusiness] == INVALID_BUSINESS_ID) {
		SendClientMessageEx(playerid, COLOR_GREY, "You don't own a business.");
	}
	else if(Businesses[PlayerInfo[playerid][pBusiness]][bType] != BUSINESS_TYPE_NEWCARDEALERSHIP && Businesses[PlayerInfo[playerid][pBusiness]][bType] != BUSINESS_TYPE_OLDCARDEALERSHIP) {
		SendClientMessageEx(playerid, COLOR_GREY, "You don't own a vehicle dealership.");
	}
	else if(!IsPlayerInRangeOfPoint(playerid, 20.0, Businesses[PlayerInfo[playerid][pBusiness]][bExtPos][0], Businesses[PlayerInfo[playerid][pBusiness]][bExtPos][1], Businesses[PlayerInfo[playerid][pBusiness]][bExtPos][2])) {
		SendClientMessageEx(playerid, COLOR_GREY, "The location needs to be near the business entrance.");
	}
	else if(PlayerInfo[playerid][pBusinessRank] < 5) {
		SendClientMessageEx(playerid, COLOR_GREY, "You aren't high enough rank to edit the car dealership.");
	}
	else {
		new Float: Positionsz[4];
		GetPlayerPos(playerid, Positionsz[0], Positionsz[1], Positionsz[2]);
		GetPlayerFacingAngle(playerid, Positionsz[3]);
		Businesses[PlayerInfo[playerid][pBusiness]][bPurchaseX] = Positionsz[0];
		Businesses[PlayerInfo[playerid][pBusiness]][bPurchaseY] = Positionsz[1];
		Businesses[PlayerInfo[playerid][pBusiness]][bPurchaseZ] = Positionsz[2];
		Businesses[PlayerInfo[playerid][pBusiness]][bPurchaseAngle] = Positionsz[3];
		SendClientMessageEx(playerid, COLOR_WHITE, "You have moved the vehicle purchase spawn location.");
		SaveDealershipSpawn(PlayerInfo[playerid][pBusiness]);
	}
	return 1;
}

CMD:entrancefee(playerid, params[])
{
    if(PlayerInfo[playerid][pBusiness] == INVALID_BUSINESS_ID) {
		return SendClientMessageEx(playerid, COLOR_GREY, "You don't own a business.");
	}
	else if(Businesses[PlayerInfo[playerid][pBusiness]][bType] != BUSINESS_TYPE_GYM) {
		return SendClientMessageEx(playerid, COLOR_GREY, "You don't own a gym.");
	}
	else if(!IsPlayerInRangeOfPoint(playerid, 5.0, Businesses[PlayerInfo[playerid][pBusiness]][bExtPos][0], Businesses[PlayerInfo[playerid][pBusiness]][bExtPos][1], Businesses[PlayerInfo[playerid][pBusiness]][bExtPos][2])) {
		return SendClientMessageEx(playerid, COLOR_GREY, "You need to be standing near the gym entrance.");
	}
	else {
		new amount;
		if(sscanf(params, "d", amount)) {
			return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /entrancefee [Price]");
		}
		else if(amount < 0 || amount > 10000) {
			return SendClientMessageEx(playerid, COLOR_GREY, "The price can't be set the price below $0 and above $10,000.");
		}

		else {
			new string[128];
			Businesses[PlayerInfo[playerid][pBusiness]][bGymEntryFee] = amount;
			format(string, sizeof(string), "You have set the gym entry fee to $%s.", number_format(amount));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			RefreshBusinessPickup(PlayerInfo[playerid][pBusiness]);
			SaveBusiness(PlayerInfo[playerid][pBusiness]);
		}
	}
	return 1;
}

CMD:editcarprice(playerid, params[])
{
    if(PlayerInfo[playerid][pBusiness] == INVALID_BUSINESS_ID) {
		SendClientMessageEx(playerid, COLOR_GREY, "You don't own a business.");
	}
	else if(Businesses[PlayerInfo[playerid][pBusiness]][bType] != BUSINESS_TYPE_NEWCARDEALERSHIP && Businesses[PlayerInfo[playerid][pBusiness]][bType] != BUSINESS_TYPE_OLDCARDEALERSHIP) {
		SendClientMessageEx(playerid, COLOR_GREY, "You don't own a vehicle dealership.");
	}
	else if(!IsPlayerInRangeOfPoint(playerid, 5.0, Businesses[PlayerInfo[playerid][pBusiness]][bExtPos][0], Businesses[PlayerInfo[playerid][pBusiness]][bExtPos][1], Businesses[PlayerInfo[playerid][pBusiness]][bExtPos][2])) {
		SendClientMessageEx(playerid, COLOR_GREY, "You need to be standing near the dealership entrance.");
	}
	else if(PlayerInfo[playerid][pBusinessRank] < Businesses[PlayerInfo[playerid][pBusiness]][bMinSupplyRank]) {
		SendClientMessageEx(playerid, COLOR_GREY, "You aren't high enough rank to edit the car dealership.");
	}
	else {
		new vehicleid, amount;
		if(sscanf(params, "dd", vehicleid, amount)) {
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /editcarprice [VehicleID] [Price]");
		}
		else if(PlayerInfo[playerid][pBusiness] != GetCarBusiness(vehicleid)) {
			SendClientMessageEx(playerid, COLOR_GREY, "That vehicle is not part of your dealership.");
		}
		else if(amount < 0) {
			SendClientMessageEx(playerid, COLOR_GREY, "The price can't be set below 0");
		}
		else {

 			new
				iSlot = GetBusinessCarSlot(vehicleid),
				Message[128];

			Businesses[PlayerInfo[playerid][pBusiness]][bPrice][iSlot] = amount;
			format(Message, sizeof(Message), "%s For Sale | Price: $%s", GetVehicleName(Businesses[PlayerInfo[playerid][pBusiness]][bVehID][iSlot]), number_format(Businesses[PlayerInfo[playerid][pBusiness]][bPrice][iSlot]));
            UpdateDynamic3DTextLabelText(Businesses[PlayerInfo[playerid][pBusiness]][bVehicleLabel][iSlot], COLOR_LIGHTBLUE, Message);
			format(Message, sizeof(Message), "%s price has been set to $%s", GetVehicleName(vehicleid), number_format(amount));
			SendClientMessageEx(playerid, COLOR_WHITE, Message);
			SaveDealershipVehicle(PlayerInfo[playerid][pBusiness], iSlot);
		}
	}
	return 1;
}

CMD:deletecdveh(playerid, params[]) {
	if(PlayerInfo[playerid][pAdmin] >= 4) {

		new
		    iBusiness,
			iVehicle;

		if(sscanf(params, "ii", iBusiness, iVehicle )) {
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /deletecdveh [business ID] [model id]");
		}
		else if(Businesses[iBusiness][bType] != BUSINESS_TYPE_NEWCARDEALERSHIP && Businesses[iBusiness][bType] != BUSINESS_TYPE_OLDCARDEALERSHIP) {
			SendClientMessageEx(playerid, COLOR_GRAD2, "Business is not a car dealership!");
		}
		else if(iBusiness != GetCarBusiness(iVehicle)) {
			SendClientMessageEx(playerid, COLOR_GREY, "That vehicle isn't a dealership vehicle.");
		}
		else {

			new
				ID = GetBusinessCarSlot(iVehicle);

			if(Businesses[iBusiness][bVehID][ID] != INVALID_VEHICLE_ID) {
			    if(IsValidDynamic3DTextLabel(Businesses[iBusiness][bVehicleLabel][ID])) DestroyDynamic3DTextLabel(Businesses[iBusiness][bVehicleLabel][ID]);
                DestroyVehicle(Businesses[iBusiness][bVehID][ID]);
               	Businesses[iBusiness][bModel][ID] = 0;
				Businesses[iBusiness][bParkPosX][ID] = 0;
  				Businesses[iBusiness][bParkPosY][ID] = 0;
			   	Businesses[iBusiness][bParkPosZ][ID] = 0;
		   	 	Businesses[iBusiness][bParkAngle][ID] = 0;
		   	 	Businesses[iBusiness][bVehID][ID] = 0;
		   	 	Businesses[iBusiness][bPrice][ID] = 0;
		   	 	SaveDealershipVehicle(iBusiness, ID);
	   	 		return 1;
       		}
			return SendClientMessageEx(playerid, COLOR_GREY, "The max number of vehicles for this business has been reached.");
		}
	}
	else SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	return 1;
}

CMD:createcdveh(playerid, params[]) {
	if(PlayerInfo[playerid][pAdmin] >= 4) {

		new
		    iBusiness,
			iVehicle,
			iColors[2];

		if(sscanf(params, "iiii", iBusiness, iVehicle, iColors[0], iColors[1])) {
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /createcdveh [business ID] [model id] [color 1] [color 2]");
		}
		else if(!(400 <= iVehicle <= 611)) {
			SendClientMessageEx(playerid, COLOR_GRAD2, "Invalid model specified (model IDs start at 400, and end at 611).");
		}
		else if(IsATrain(iVehicle)) {
			SendClientMessageEx(playerid, COLOR_GREY, "Trains cannot be spawned during runtime.");
		}
		else if(!(0 <= iColors[0] <= 255 && 0 <= iColors[1] <= 255)) {
			SendClientMessageEx(playerid, COLOR_GRAD2, "Invalid color specified (IDs start at 0, and end at 255).");
		}
		else if(Businesses[iBusiness][bType] != BUSINESS_TYPE_NEWCARDEALERSHIP && Businesses[iBusiness][bType] != BUSINESS_TYPE_OLDCARDEALERSHIP) {
			SendClientMessageEx(playerid, COLOR_GRAD2, "Business is not a car dealership!");
		}
		else {

			new
				Float: fVehPos[4], label[50];

			GetPlayerPos(playerid, fVehPos[0], fVehPos[1], fVehPos[2]);
			GetPlayerFacingAngle(playerid, fVehPos[3]);
			for (new i; i < MAX_BUSINESS_DEALERSHIP_VEHICLES; i++)
			{
				if (Businesses[iBusiness][bVehID][i] == 0) {
					Businesses[iBusiness][bVehID][i] = CreateVehicle(iVehicle, fVehPos[0], fVehPos[1], fVehPos[2], fVehPos[3], iColors[0], iColors[1], -1);
					VehicleFuel[Businesses[iBusiness][bVehID][i]] = 100.0;

					Businesses[iBusiness][bModel][i] = iVehicle;

				 	Businesses[iBusiness][bParkPosX][i] = fVehPos[0];
	  				Businesses[iBusiness][bParkPosY][i] = fVehPos[1];
				   	Businesses[iBusiness][bParkPosZ][i] = fVehPos[2];
			   	 	Businesses[iBusiness][bParkAngle][i] = fVehPos[3];

					format(label, sizeof(label), "%s For Sale | Price: $%s", GetVehicleName(Businesses[iBusiness][bVehID][i]), number_format(Businesses[iBusiness][bPrice][i]));
					Businesses[iBusiness][bVehicleLabel][i] = CreateDynamic3DTextLabel(label,COLOR_LIGHTBLUE,Businesses[iBusiness][bParkPosX][i], Businesses[iBusiness][bParkPosY][i], Businesses[iBusiness][bParkPosZ][i],8.0,INVALID_PLAYER_ID, Businesses[iBusiness][bVehID][i]);

					Businesses[iBusiness][DealershipVehStock][i] = 1;
					Vehicle_ResetData(Businesses[iBusiness][bVehID][i]);
					SaveDealershipVehicle(iBusiness, i);
					return 1;
				}
			}
			return SendClientMessageEx(playerid, COLOR_GREY, "The max number of vehicles for this business has been reached.");
		}
	}
	else SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	return 1;
}

CMD:switchbiz(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 3 || PlayerInfo[playerid][pBM] >= 1)
	{
		new string[128], bizid;
		if(sscanf(params, "d", bizid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /switchbiz [bizid]");
		if(bizid < 1 || bizid > MAX_BUSINESSES) return SendClientMessageEx(playerid, COLOR_WHITE, "Invalid business ID.");
		format(string, sizeof(string), "You have switched to business ID %d (%s).", bizid, Businesses[bizid][bName]);
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
		PlayerInfo[playerid][pBusinessRank] = 5;
		PlayerInfo[playerid][pBusiness] = bizid;
	}
	else return SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use this command");
	return 1;
}

CMD:brenewal(playerid, params[])
{
	if(PlayerInfo[playerid][pShopTech] >= 1)
	{
	    new
	        iType,
	        iOrderID,
	        iBusiness,
			szMessage[128],
			months;

		if(sscanf(params, "dddd", iBusiness, iType, months, iOrderID)) {
		    SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /brenewal [Business ID] [Type (1-3)] [Months] [OrderID]");
		}
		else if(!IsValidBusinessID(iBusiness)) {
		    SendClientMessageEx(playerid, COLOR_GREY, "Invalid business ID");
		}
		else {
		    Businesses[iBusiness][bMonths] = 259200+gettime()+(2592000*months);
			format(szMessage, sizeof(szMessage), "You have renewed business %i for %i months.", iBusiness, months);
			SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
			format(szMessage, sizeof(szMessage), "[BUSINESS RENEWAL] %s(%d) has renewed BusinessID %i, Type %i, Months %i, OrderID %i", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), iBusiness, iType, months, iOrderID);
			Log("logs/shoplog.log", szMessage);
			SaveBusiness(iBusiness);
		}
	}
	else
	{
	    SendClientMessage(playerid, COLOR_GREY, "You are not authorized to use that command.");
	}
	return 1;
}

CMD:shopbusiness(playerid, params[])
{
	if(PlayerInfo[playerid][pShopTech] < 1 && PlayerInfo[playerid][pBM] < 1)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use that command.");
		return 1;
	}

	new string[128], choice[32], businessid, amount, invoice[64];
	if(sscanf(params, "s[32]dDs[64]", choice, businessid, amount, invoice))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /shopbusiness [name] [business ID] [Amount] [invoice #]");
		SendClientMessageEx(playerid, COLOR_GREY, "Available names: Exterior, Interior, SupplyPoint, Price, Type, Inventory, InventoryCapacity, Delete");
		SendClientMessageEx(playerid, COLOR_GREY, "Available names: CustomInterior, CustomExterior, Months, VW, grade");
		return 1;
	}

	if (!IsValidBusinessID(businessid))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "Invalid business ID entered.");
		return 1;
	}
    if(!strcmp(choice, "grade", true))
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You have changed the grade on this business!");
		format(string, sizeof(string), "[SHOPBUSINESS] %s has changed BusinessID %d's Grade to %i", GetPlayerNameEx(playerid), businessid, amount);
		Businesses[businessid][bGrade] = amount;
		Log("logs/shoplog.log", string);
	}
    if(!strcmp(choice, "months", true))
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You have changed the months left on this business!");
		format(string, sizeof(string), "[SHOPBUSINESS] %s has changed BusinessID %d's Months to %i", GetPlayerNameEx(playerid), businessid, amount);
		Businesses[businessid][bMonths] = (2592000*amount)+gettime()+259200;
		Log("logs/shoplog.log", string);
	}
	else if(!strcmp(choice, "vw", true))
	{
		Businesses[businessid][bVW] = amount;
		SendClientMessageEx(playerid, COLOR_WHITE, "You have changed the VW!");
		format(string, sizeof(string), "[SHOPBUSINESS] %s has changed BusinessID %d's vw to %d", GetPlayerNameEx(playerid), businessid, amount);
		Log("logs/shoplog.log", string);
	}
	if(!strcmp(choice, "exterior", true))
	{
		GetPlayerPos(playerid, Businesses[businessid][bExtPos][0], Businesses[businessid][bExtPos][1], Businesses[businessid][bExtPos][2]);
		GetPlayerFacingAngle(playerid, Businesses[businessid][bExtPos][3]);
		SendClientMessageEx(playerid, COLOR_WHITE, "You have changed the exterior!");
		format(string, sizeof(string), "[SHOPBUSINESS] %s has changed BusinessID %d's Exterior to X:%f Y:%f Z:%f", GetPlayerNameEx(playerid), businessid, Businesses[businessid][bExtPos][0], Businesses[businessid][bExtPos][1],Businesses[businessid][bExtPos][2]);
		Log("logs/shoplog.log", string);
	}
	else if(!strcmp(choice, "interior", true))
	{
		GetPlayerPos(playerid, Businesses[businessid][bIntPos][0], Businesses[businessid][bIntPos][1], Businesses[businessid][bIntPos][2]);
		GetPlayerFacingAngle(playerid, Businesses[businessid][bIntPos][3]);
		Businesses[businessid][bInt] = GetPlayerInterior(playerid);
		SendClientMessageEx(playerid, COLOR_WHITE, "You have changed the interior!");
		format(string, sizeof(string), "[SHOPBUSINESS] %s has changed BusinessID %d's Interior to X:%f Y:%f Z:%f", GetPlayerNameEx(playerid), businessid, Businesses[businessid][bIntPos][0], Businesses[businessid][bIntPos][1],Businesses[businessid][bIntPos][2]);
		Log("logs/shoplog.log", string);
	}
	else if(strcmp(choice, "custominterior", true) == 0)
	{
		if(Businesses[businessid][bCustomInterior] == 0)
		{
			Businesses[businessid][bCustomInterior] = 1;
			SendClientMessageEx(playerid, COLOR_WHITE, "Business set to custom interior!");
		}
		else
		{
			Businesses[businessid][bCustomInterior] = 0;
			SendClientMessageEx(playerid, COLOR_WHITE, "Business set to normal (not custom) interior!");
		}
		format(string, sizeof(string), "[SHOPBUSINESS] %s has edited BusinessID %d's CustomInterior.", GetPlayerNameEx(playerid), businessid);
		Log("logs/shoplog.log", string);
		return 1;
	}
	else if(strcmp(choice, "customexterior", true) == 0)
	{
		if(Businesses[businessid][bCustomExterior] == 0)
		{
			Businesses[businessid][bCustomExterior] = 1;
			SendClientMessageEx(playerid, COLOR_WHITE, "Business set to custom exterior!");
		}
		else
		{
			Businesses[businessid][bCustomExterior] = 0;
			SendClientMessageEx(playerid, COLOR_WHITE, "Business set to normal (not custom) exterior!");
		}
		format(string, sizeof(string), "[SHOPBUSINESS] %s has edited BusinessID %d's CustomExterior.", GetPlayerNameEx(playerid), businessid);
		Log("logs/shoplog.log", string);
		return 1;
	}
	else if(!strcmp(choice, "supplypoint", true))
	{
		if(Businesses[businessid][bOrderState] == 2)
		{
			return SendClientMessageEx(playerid, COLOR_GREY, "You can't change the supply point when a delivery is on its way.");
		}
		GetPlayerPos(playerid, Businesses[businessid][bSupplyPos][0], Businesses[businessid][bSupplyPos][1], Businesses[businessid][bSupplyPos][2]);
		SendClientMessageEx(playerid, COLOR_WHITE, "You have edited the supply point!");
		format(string, sizeof(string), "[SHOPBUSINESS] %s has changed BusinessID %d's Supply Point to X:%f Y:%f Z:%f", GetPlayerNameEx(playerid), businessid, Businesses[businessid][bSupplyPos][0], Businesses[businessid][bSupplyPos][1],Businesses[businessid][bSupplyPos][2]);
		Log("logs/shoplog.log", string);
	}

	else if(!strcmp(choice, "price", true))
	{
		Businesses[businessid][bValue] = amount;
		format(string, sizeof(string), "You have set the business price to $%d.", amount);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "[SHOPBUSINESS] %s has changed BusinessID %d's Price to $%d.", GetPlayerNameEx(playerid), businessid, amount);
		Log("logs/shoplog.log", string);
	}

	else if(!strcmp(choice, "type", true))
	{
		if(Businesses[businessid][bOrderState] == 2)
		{
			return SendClientMessageEx(playerid, COLOR_GREY, "You can't change the business type when a delivery is on its way.");
		}
		Businesses[businessid][bType] = amount;
		format(string, sizeof(string), "You have set the business type to %s.", GetBusinessTypeName(amount));
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "[SHOPBUSINESS] %s has changed BusinessID %d's Type to %s (%d).", GetPlayerNameEx(playerid), businessid, GetBusinessTypeName(amount), amount);
		Log("logs/shoplog.log", string);
	}

	else if(!strcmp(choice, "inventory", true))
	{
		Businesses[businessid][bInventory] = amount;
		format(string, sizeof(string), "You have set the business inventory to %d.", amount);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "[SHOPBUSINESS] %s has changed BusinessID %d's Inventory to %d.", GetPlayerNameEx(playerid), businessid, amount);
		Log("logs/shoplog.log", string);
	}
	else if(!strcmp(choice, "InventoryCapacity", true))
	{
		Businesses[businessid][bInventoryCapacity] = amount;
		format(string, sizeof(string), "You have set the business inventory capacity to %d.", amount);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "[SHOPBUSINESS] %s has changed BusinessID %d's Inventory Capacity to %d.", GetPlayerNameEx(playerid), businessid, amount);
		Log("logs/shoplog.log", string);
	}

	else if(!strcmp(choice, "delete", true))
	{
		Businesses[businessid][bExtPos][0] = 0;
		Businesses[businessid][bExtPos][1] = 0;
		Businesses[businessid][bExtPos][2] = 0;
		Businesses[businessid][bName][0] = 0;
		Businesses[businessid][bType] = 0;
		format(string, sizeof(string), "You have deleted the business.", amount);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "[SHOPBUSINESS] %s has deleted BusinessID %d.", GetPlayerNameEx(playerid), businessid);
		Log("logs/bedit.log", string);
		//TODO IMPROVE
		for (new i; i < MAX_BUSINESS_GAS_PUMPS; i++) {
			DestroyDynamicGasPump(businessid, i);
		}
		for (new i; i < MAX_BUSINESS_DEALERSHIP_VEHICLES; i++) {
			DestroyVehicle(Businesses[businessid][bVehID][i]);
		}
	}

	RefreshBusinessPickup(businessid);
	SaveBusiness(businessid);
	Streamer_UpdateEx(playerid, Businesses[businessid][bExtPos][0], Businesses[businessid][bExtPos][1], Businesses[businessid][bExtPos][2]);
	return 1;
}

CMD:shopbusinessname(playerid, params[])
{
	if(PlayerInfo[playerid][pShopTech] < 1 && PlayerInfo[playerid][pBM] < 1)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use that command.");
		return 1;
	}

	new string[128], houseid, ownername, invoice[64];
	if(sscanf(params, "dus[64]", houseid, ownername, invoice)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /shopbusinessname [Business ID] [Player] [invoice]");

	if(!IsPlayerConnected(ownername)) {
    	return SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");
	}

	if(PlayerInfo[ownername][pBusiness] != INVALID_BUSINESS_ID) {
	    return SendClientMessageEx(playerid, COLOR_GREY, "That player already owns another business.");
	}

	Businesses[houseid][bOwner] = GetPlayerSQLId(ownername);
	strcpy(Businesses[houseid][bOwnerName], GetPlayerNameEx(ownername), MAX_PLAYER_NAME);
	PlayerInfo[ownername][pBusiness] = houseid;
	PlayerInfo[ownername][pBusinessRank] = 5;
	SaveBusiness(houseid);
	OnPlayerStatsUpdate(ownername);
	RefreshBusinessPickup(houseid);

	format(string, sizeof(string), "[SHOPBUSINESS] %s modified Owner on Business %d to %s(%d) - Invoice %s", GetPlayerNameEx(playerid), houseid, GetPlayerNameEx(ownername), GetPlayerSQLId(ownername), invoice);
	Log("logs/shoplog.log", string);
	return 1;
}

CMD:buyclothes(playerid, params[])
{
	new biz = InBusiness(playerid);

   	if (biz == INVALID_BUSINESS_ID || Businesses[biz][bType] != BUSINESS_TYPE_CLOTHING) {
        SendClientMessageEx(playerid, COLOR_GRAD2, "You are not in a clothing shop!");
        return 1;
    }
	if (Businesses[biz][bInventory] < 1) {
	    SendClientMessageEx(playerid, COLOR_GRAD2, "Store does not have any clothes!");
	    return 1;
	}
	if (!Businesses[biz][bStatus]) {
	    SendClientMessageEx(playerid, COLOR_GRAD2, "This clothing store is closed!");
	    return 1;
	}
    #if defined zombiemode
	if(zombieevent == 1 && GetPVarType(playerid, "pIsZombie")) return SendClientMessageEx(playerid, COLOR_GREY, "Zombies can't use this.");
	#endif
    new string[64];
    format(string, sizeof(string), "Note: Clothes changes cost %s", number_format(Businesses[biz][bItemPrices][0]));
    SetPVarInt(playerid, "SkinChangeCost", Businesses[biz][bItemPrices][0]);
	SendClientMessageEx(playerid, COLOR_YELLOW, string);
	if(PlayerInfo[playerid][mInventory][13] && PlayerInfo[playerid][pDonateRank] < 2) SendClientMessageEx(playerid, -1, "You have Restricted Skin tokens in your inventory, if you select a restricted skin you will use a token and no additional fees will come.");
	ShowModelSelectionMenu(playerid, SkinList, "Change your clothes.");
	return 1;
}

CMD:buybizlevel(playerid, params[])
{
	if (PlayerInfo[playerid][pBusiness] == INVALID_BUSINESS_ID || PlayerInfo[playerid][pBusinessRank] < 5)
	{
		return SendClientMessageEx(playerid, COLOR_GREY, "Only business owners can use this command.");
	}
	if (Businesses[PlayerInfo[playerid][pBusiness]][bLevel] >= 5)
	{
		return SendClientMessageEx(playerid, COLOR_GREY, "You cannot buy levels anymore.");
	}

	new newLevel = Businesses[PlayerInfo[playerid][pBusiness]][bLevel] + 1;
	new totalSales = Businesses[PlayerInfo[playerid][pBusiness]][bTotalSales];
	new totalProfits = Businesses[PlayerInfo[playerid][pBusiness]][bTotalProfits];

	if (newLevel == 2 && totalSales < 1000 && totalProfits < 300000)
		return SendClientMessageEx(playerid, COLOR_GREY, "This business does not have enough total sales/profits to purchase this uprgade!");
	else if (newLevel == 3 && totalSales < 5000 && totalProfits < 2000000)
		return SendClientMessageEx(playerid, COLOR_GREY, "This business does not have enough total sales/profits to purchase this uprgade!");
	else if (newLevel == 4 && totalSales < 15000 && totalProfits < 10000000)
		return SendClientMessageEx(playerid, COLOR_GREY, "This business does not have enough total sales/profits to purchase this uprgade!");

	new cost = Businesses[PlayerInfo[playerid][pBusiness]][bLevel] * 100000;
	if(Businesses[PlayerInfo[playerid][pBusiness]][bSafeBalance] < cost)
	{
		return SendClientMessageEx(playerid, COLOR_GREY, "The business does not have enough money in the safe to purchase this upgrade!");
	}
	Businesses[PlayerInfo[playerid][pBusiness]][bSafeBalance] -= cost;
	OnPlayerStatsUpdate(playerid);
	new string[128];
   	format(string, sizeof(string), "~g~BUSINESS LEVEL UP~n~~w~Current Level %d", ++Businesses[PlayerInfo[playerid][pBusiness]][bLevel]);
	PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);

    Businesses[PlayerInfo[playerid][pBusiness]][bLevelProgress] = 0;
    Businesses[PlayerInfo[playerid][pBusiness]][bInventoryCapacity] *= 2;
	if(IsBusinessGasAble(Businesses[PlayerInfo[playerid][pBusiness]][bType]))
	{
		for (new i; i < MAX_BUSINESS_GAS_PUMPS; i++)
		{
			Businesses[PlayerInfo[playerid][pBusiness]][GasPumpCapacity][i] *= 2;
		}
	}
    SaveBusiness(PlayerInfo[playerid][pBusiness]);

    return 1;
}
 
// Business Leadership Commands Start

CMD:binvite(playerid, params[]) {

	new iBusinessID = PlayerInfo[playerid][pBusiness];

	if((0 <= iBusinessID < MAX_BUSINESSES) && PlayerInfo[playerid][pBusinessRank] >= Businesses[iBusinessID][bMinInviteRank]) {

		new
			iTargetID,
			string[128];

		if(sscanf(params, "u", iTargetID)) {
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /binvite [player]");
		}
		else if(IsPlayerConnected(iTargetID)) {
		    if (iTargetID != playerid) {
				if(!(0 <= PlayerInfo[iTargetID][pBusiness] < MAX_BUSINESSES)) {

					SetPVarInt(iTargetID, "Business_Inviter", playerid);
					SetPVarInt(iTargetID, "Business_InviterSQLId", GetPlayerSQLId(playerid));
					SetPVarInt(iTargetID, "Business_Invited", iBusinessID);
					format(string, sizeof(string), "You have invited %s to join %s", GetPlayerNameEx(iTargetID), Businesses[iBusinessID][bName]);
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "%s %s has offered you a job at %s - type /accept business", GetBusinessRankName(PlayerInfo[playerid][pBusinessRank]), GetPlayerNameEx(playerid), Businesses[iBusinessID][bName]);
					SendClientMessageEx(iTargetID, COLOR_LIGHTBLUE, string);

					format(string, sizeof(string), "%s(%d) has invited %s(%d) to join %s", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerNameEx(iTargetID), GetPlayerSQLId(iTargetID), Businesses[iBusinessID][bName]);
					Log("logs/business.log", string);

				}
				else SendClientMessageEx(playerid, COLOR_GREY, "The person you're trying to invite is already in another business.");
			}
			else SendClientMessageEx(playerid, COLOR_GREY, "You cannot use this command on yourself.");
		}
		else SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid player specified.");
	}
	else SendClientMessageEx(playerid, COLOR_GRAD1, "Only authorized business employees may use this command.");
	return 1;
}

CMD:buninvite(playerid, params[]) {
	if(0 <= PlayerInfo[playerid][pBusiness] < MAX_BUSINESSES && PlayerInfo[playerid][pBusinessRank] >= Businesses[PlayerInfo[playerid][pBusiness]][bMinInviteRank]) {

		new
			iTargetID,
			iGroupID = PlayerInfo[playerid][pBusiness];

		if(sscanf(params, "u", iTargetID)) {
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /buninvite [player]");
		}
		else if(IsPlayerConnected(iTargetID)) {
			if(iGroupID == PlayerInfo[iTargetID][pBusiness]) {
				if(playerid == iTargetID) {
					SendClientMessageEx(playerid, COLOR_GREY, "You can't uninvite yourself.");
				}
				else if(PlayerInfo[playerid][pBusinessRank] > PlayerInfo[iTargetID][pBusinessRank]) {

					new
						szMessage[128],
						iRank = PlayerInfo[iTargetID][pBusinessRank];

					format(szMessage, sizeof(szMessage), "You have kicked %s from the business.", GetPlayerNameEx(iTargetID));
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
					format(szMessage, sizeof(szMessage), "* You have been kicked from the business by %s %s.", GetPlayerNameEx(playerid));
					SendClientMessageEx(iTargetID, COLOR_LIGHTBLUE, szMessage);
					format(szMessage, sizeof(szMessage), "%s(%d) uninvited %s(%d) from the %s as a rank %i.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerNameEx(iTargetID), GetPlayerSQLId(iTargetID), Businesses[PlayerInfo[iTargetID][pBusiness]][bName], iRank);
					Log("logs/business.log", szMessage);

					PlayerInfo[iTargetID][pBusiness] = INVALID_BUSINESS_ID;
					PlayerInfo[iTargetID][pBusinessRank] = 0;
					OnPlayerStatsUpdate(iTargetID);

				}
				else SendClientMessageEx(playerid, COLOR_GREY, "You can't do this to a person of equal or higher rank.");
			}
			else SendClientMessageEx(playerid, COLOR_GRAD1, "That person is not in your business.");
		}
		else SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid player specified.");
	}
	else SendClientMessageEx(playerid, COLOR_GRAD1, "Only authorized business employees may use this command.");
	return 1;
}



CMD:bouninvite(playerid, params[])
{
	new name[32], query[128];
	if (sscanf(params, "s[32]", name)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /bouninvite [account name]");
    if(PlayerInfo[playerid][pBusiness] == INVALID_BUSINESS_ID) {
		SendClientMessageEx(playerid, COLOR_GREY, "You don't own a business.");
		return 1;
	}
    if(PlayerInfo[playerid][pBusinessRank] != 5) {
		SendClientMessageEx(playerid, COLOR_GREY, "You don't own a business.");
		return 1;
	}
	format(query, sizeof(query), "UPDATE `accounts` SET `Business` = "#INVALID_BUSINESS_ID", `BusinessRank` = 0 WHERE `Username` = '%s' AND `Business` = %d", g_mysql_ReturnEscaped(name, MainPipeline), PlayerInfo[playerid][pBusiness]);
	mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	SendClientMessageEx(playerid, COLOR_GREY, "You have offline kicked that person.");
	return 1;
}

CMD:bgiverank(playerid, params[])
{
    new string[128], targetid, rank;
	if (PlayerInfo[playerid][pBusiness] == INVALID_BUSINESS_ID)
	{
		return SendClientMessageEx(playerid, COLOR_GREY, "You are not in a business!");
	}
	if(sscanf(params, "ud", targetid, rank)) {
		return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /bgiverank [player] [rank]");
	}
	else if (PlayerInfo[playerid][pBusinessRank] < Businesses[PlayerInfo[playerid][pBusiness]][bMinGiveRankRank]) {
		return SendClientMessageEx(playerid, COLOR_GREY, "Your rank is not high enough for promoting or demoting someone!");
	}
	else if (!IsPlayerConnected(targetid)) {
		return SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified!");
	}
	else if (playerid == targetid) {
		return SendClientMessageEx(playerid, COLOR_GREY, "You can not use this command on yourself!");
	}
	else if(PlayerInfo[playerid][pBusiness] != PlayerInfo[targetid][pBusiness]) {
		return SendClientMessageEx(playerid, COLOR_GREY, "That person is not in your business!");
	}
	else if (PlayerInfo[targetid][pBusinessRank] > PlayerInfo[playerid][pBusinessRank])	{
		return SendClientMessageEx(playerid, COLOR_GREY, "You can not use this command on that rank persons!");
	}
	else if(rank < 0 || rank > 5) {
		return SendClientMessageEx(playerid, COLOR_GREY, "Don't go below number 0 or above number 5!");
	}
	if (rank > PlayerInfo[targetid][pBusinessRank])	{
		format(string, sizeof(string), "* You have been promoted to a higher rank (%s) by %s.", GetBusinessRankName(rank), GetPlayerNameEx(playerid));
		SendClientMessageEx(targetid, COLOR_LIGHTBLUE, string);
	}
	else if (rank < PlayerInfo[targetid][pBusinessRank]) {
		format(string, sizeof(string), "* You have been demoted to a lower rank (%s) by %s.", GetBusinessRankName(rank), GetPlayerNameEx(playerid));
		SendClientMessageEx(targetid, COLOR_LIGHTBLUE, string);
	}
	else {
		SendClientMessageEx(playerid, COLOR_GREY, "That person already has rank");
	}
	PlayerInfo[targetid][pBusinessRank] = rank;
	format(string, sizeof(string), "* You have given %s rank %d.", GetPlayerNameEx(targetid), rank);
	SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	format(string, sizeof(string), "%s(%d) has given %s(%d) rank %i in %s", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerNameEx(targetid), GetPlayerSQLId(targetid), rank, Businesses[PlayerInfo[targetid][pBusiness]][bName]);
	Log("logs/business.log", string);
	return 1;
}

CMD:resign(playerid, params[])
{
	if (PlayerInfo[playerid][pBusiness] != INVALID_BUSINESS_ID)
	{
		new string[128];
		format(string, sizeof(string), "%s(%d) has resigned from their business as a rank %i", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), PlayerInfo[playerid][pBusinessRank]);
		Log("logs/business.log", string);
		PlayerInfo[playerid][pBusiness] = INVALID_BUSINESS_ID;
		PlayerInfo[playerid][pBusinessRank] = INVALID_RANK;
		return SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You have resigned from your business.");
	}
	else return SendClientMessageEx(playerid, COLOR_GREY, "You are not in a business!");
}

CMD:bsafe(playerid, params[])
{
    if(PlayerInfo[playerid][pBusiness] == INVALID_BUSINESS_ID) {
		SendClientMessageEx(playerid, COLOR_GREY, "You don't own a business.");
		return 1;
	}
	else if(!IsPlayerInRangeOfPoint(playerid, 25.0, Businesses[PlayerInfo[playerid][pBusiness]][bIntPos][0], Businesses[PlayerInfo[playerid][pBusiness]][bIntPos][1], Businesses[PlayerInfo[playerid][pBusiness]][bIntPos][2])) {
		SendClientMessageEx(playerid, COLOR_GREY, "You need to be inside your business to access your business safe.");
		return 1;
	}
	else if(PlayerInfo[playerid][pBusinessRank] < Businesses[PlayerInfo[playerid][pBusiness]][bMinSafeRank]) {
		SendClientMessageEx(playerid, COLOR_GREY, "You aren't high enough rank to access the business safe.");
		return 1;
	}
	else {
	    new choice[10], Amount, string[128];
	    if(sscanf(params, "s[10]D", choice, Amount)) {
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /bsafe [name] [amount]");
			SendClientMessageEx(playerid, COLOR_GREY, "Available names: Balance, Withdraw, Deposit");
			return 1;
		}
		else if(!strcmp(choice, "Balance", true))
		{
		    format(string, sizeof(string), "Business(%d) Safe Balance: $%s", PlayerInfo[playerid][pBusiness], number_format(Businesses[PlayerInfo[playerid][pBusiness]][bSafeBalance]));
		    SendClientMessageEx(playerid, COLOR_WHITE, string);
		}
		else if(Amount < 1) {
		    SendClientMessageEx(playerid, COLOR_GREY, "The amount can't be under 1.");
		    return 1;
		}
		else if(!strcmp(choice, "Withdraw", true))
		{
		    if(Businesses[PlayerInfo[playerid][pBusiness]][bSafeBalance] >= Amount) {
		    	format(string, sizeof(string), "You have withdrew $%s from your business safe.", number_format(Amount));
		    	SendClientMessageEx(playerid, COLOR_WHITE, string);
		    	Businesses[PlayerInfo[playerid][pBusiness]][bSafeBalance] -= Amount;
		    	format(string, sizeof(string), "Business(%d) Safe Balance: $%s", PlayerInfo[playerid][pBusiness], number_format(Businesses[PlayerInfo[playerid][pBusiness]][bSafeBalance]));
		    	SendClientMessageEx(playerid, COLOR_WHITE, string);
		    	format(string,sizeof(string),"%s(%d) (IP: %s) has withdrawn $%s from their business safe (BusinessID - %d)",GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(Amount), PlayerInfo[playerid][pBusiness]);
				Log("logs/business.log", string);
		   		GivePlayerCash(playerid, Amount);
		   		SaveBusiness(PlayerInfo[playerid][pBusiness]);
			}
			else {
			    SendClientMessageEx(playerid, COLOR_GREY, "You don't have that much in your business safe.");
			}
		}
		else if(!strcmp(choice, "Deposit", true))
		{
		    if(GetPlayerCash(playerid) >= Amount) {
		    	format(string, sizeof(string), "You have deposited $%s into your business safe.", number_format(Amount));
		    	SendClientMessageEx(playerid, COLOR_WHITE, string);
		    	Businesses[PlayerInfo[playerid][pBusiness]][bSafeBalance] += Amount;
		    	format(string, sizeof(string), "Business(%d) Safe Balance: $%s", PlayerInfo[playerid][pBusiness], number_format(Businesses[PlayerInfo[playerid][pBusiness]][bSafeBalance]));
		    	SendClientMessageEx(playerid, COLOR_WHITE, string);
		    	format(string,sizeof(string),"%s(%d) (IP: %s) has deposited $%s into their business safe (BusinessID - %d)",GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(Amount), PlayerInfo[playerid][pBusiness]);
				Log("logs/business.log", string);
		   		GivePlayerCash(playerid, -Amount);
		   		SaveBusiness(PlayerInfo[playerid][pBusiness]);
			}
			else {
			    SendClientMessageEx(playerid, COLOR_GREY, "You don't have that much cash on you.");
			}
		}
	}
	return 1;
}

// Business Admin Commands
CMD:bedit(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pBM] < 1)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use that command!");
		return 1;
	}

	new choice[32], businessid, amount, string[128];
	if(sscanf(params, "s[32]dD(0)", choice, businessid, amount))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /bedit [name] [businessid] [amount]");
		SendClientMessageEx(playerid, COLOR_GREY, "Available names: Exterior, Interior, SupplyPoint, Price, Type, Inventory, InventoryCapacity, SafeBalance, Delete");
		SendClientMessageEx(playerid, COLOR_GREY, "Available names: CustomInterior, CustomExterior, Months, GymEntryFee, GymType, VW, Grade");
		return 1;
	}

	if (!IsValidBusinessID(businessid))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "Invalid business ID entered.");
		return 1;
	}
	if(!strcmp(choice, "grade", true))
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You have changed the grade on this business!");
		format(string, sizeof(string), "%s has changed BusinessID %d's Grade to %i", GetPlayerNameEx(playerid), businessid, amount);
		Businesses[businessid][bGrade] = amount;
		Log("logs/bedit.log", string);
	}
    if(!strcmp(choice, "months", true))
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You have changed the months left on this business!");
		format(string, sizeof(string), "%s has changed BusinessID %d's Months to %i", GetPlayerNameEx(playerid), businessid, amount);
		Businesses[businessid][bMonths] = 2592000*amount+gettime()+259200;
		Log("logs/bedit.log", string);
	}
	else if(!strcmp(choice, "vw", true))
	{
		Businesses[businessid][bVW] = amount;
		SendClientMessageEx(playerid, COLOR_WHITE, "You have changed the VW!");
		format(string, sizeof(string), "%s has changed BusinessID %d's vw to %d", GetPlayerNameEx(playerid), businessid, amount);
		Log("logs/bedit.log", string);
	}
	if(!strcmp(choice, "exterior", true))
	{
		GetPlayerPos(playerid, Businesses[businessid][bExtPos][0], Businesses[businessid][bExtPos][1], Businesses[businessid][bExtPos][2]);
		GetPlayerFacingAngle(playerid, Businesses[businessid][bExtPos][3]);
		SendClientMessageEx(playerid, COLOR_WHITE, "You have changed the exterior!");
		format(string, sizeof(string), "%s has changed BusinessID %d's Exterior to X:%f Y:%f Z:%f", GetPlayerNameEx(playerid), businessid, Businesses[businessid][bExtPos][0], Businesses[businessid][bExtPos][1],Businesses[businessid][bExtPos][2]);
		Log("logs/bedit.log", string);
	}
	else if(!strcmp(choice, "interior", true))
	{
		GetPlayerPos(playerid, Businesses[businessid][bIntPos][0], Businesses[businessid][bIntPos][1], Businesses[businessid][bIntPos][2]);
		GetPlayerFacingAngle(playerid, Businesses[businessid][bIntPos][3]);
		Businesses[businessid][bInt] = GetPlayerInterior(playerid);
		SendClientMessageEx(playerid, COLOR_WHITE, "You have changed the interior!");
		format(string, sizeof(string), "%s has changed BusinessID %d's Interior to X:%f Y:%f Z:%f", GetPlayerNameEx(playerid), businessid, Businesses[businessid][bIntPos][0], Businesses[businessid][bIntPos][1],Businesses[businessid][bIntPos][2]);
		Log("logs/bedit.log", string);
	}
	else if(strcmp(choice, "custominterior", true) == 0)
	{
		if(Businesses[businessid][bCustomInterior] == 0)
		{
			Businesses[businessid][bCustomInterior] = 1;
			SendClientMessageEx(playerid, COLOR_WHITE, "Business set to custom interior!");
		}
		else
		{
			Businesses[businessid][bCustomInterior] = 0;
			SendClientMessageEx(playerid, COLOR_WHITE, "Business set to normal (not custom) interior!");
		}
		format(string, sizeof(string), "%s has edited BusinessID %d's CustomInterior.", GetPlayerNameEx(playerid), businessid);
		Log("logs/bedit.log", string);
		return 1;
	}
	else if(strcmp(choice, "customexterior", true) == 0)
	{
		if(Businesses[businessid][bCustomExterior] == 0)
		{
			Businesses[businessid][bCustomExterior] = 1;
			SendClientMessageEx(playerid, COLOR_WHITE, "Business set to custom exterior!");
		}
		else
		{
			Businesses[businessid][bCustomExterior] = 0;
			SendClientMessageEx(playerid, COLOR_WHITE, "Business set to normal (not custom) exterior!");
		}
		format(string, sizeof(string), "%s has edited BusinessID %d's CustomExterior.", GetPlayerNameEx(playerid), businessid);
		Log("logs/bedit.log", string);
		return 1;
	}
	else if(!strcmp(choice, "supplypoint", true))
	{
		if(Businesses[businessid][bOrderState] == 2)
		{
			return SendClientMessageEx(playerid, COLOR_GREY, "You can't change the supply point when a delivery is on its way.");
		}
		GetPlayerPos(playerid, Businesses[businessid][bSupplyPos][0], Businesses[businessid][bSupplyPos][1], Businesses[businessid][bSupplyPos][2]);
		SendClientMessageEx(playerid, COLOR_WHITE, "You have edited the supply point!");
		format(string, sizeof(string), "%s has changed BusinessID %d's Supply Point to X:%f Y:%f Z:%f", GetPlayerNameEx(playerid), businessid, Businesses[businessid][bSupplyPos][0], Businesses[businessid][bSupplyPos][1],Businesses[businessid][bSupplyPos][2]);
		Log("logs/bedit.log", string);
	}

	else if(!strcmp(choice, "price", true))
	{
		Businesses[businessid][bValue] = amount;
		format(string, sizeof(string), "You have set the business price to $%d.", amount);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "%s has changed BusinessID %d's Price to $%d.", GetPlayerNameEx(playerid), businessid, amount);
		Log("logs/bedit.log", string);
	}

	else if(!strcmp(choice, "type", true))
	{
		if(Businesses[businessid][bOrderState] == 2)
		{
			return SendClientMessageEx(playerid, COLOR_GREY, "You can't change the business type when a delivery is on its way.");
		}
		Businesses[businessid][bType] = amount;
		format(string, sizeof(string), "You have set the business type to %s.", GetBusinessTypeName(amount));
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "%s has changed BusinessID %d's Type to %s (%d).", GetPlayerNameEx(playerid), businessid, GetBusinessTypeName(amount), amount);
		Log("logs/bedit.log", string);
	}

	else if(!strcmp(choice, "inventory", true))
	{
		Businesses[businessid][bInventory] = amount;
		format(string, sizeof(string), "You have set the business inventory to %d.", amount);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "%s has changed BusinessID %d's Inventory to %d.", GetPlayerNameEx(playerid), businessid, amount);
		Log("logs/bedit.log", string);
	}
	else if(!strcmp(choice, "InventoryCapacity", true))
	{
		Businesses[businessid][bInventoryCapacity] = amount;
		format(string, sizeof(string), "You have set the business inventory capacity to %d.", amount);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "%s has changed BusinessID %d's Inventory Capacity to %d.", GetPlayerNameEx(playerid), businessid, amount);
		Log("logs/bedit.log", string);
	}

	else if(!strcmp(choice, "safebalance", true))
	{
		Businesses[businessid][bSafeBalance] = amount;
		format(string, sizeof(string), "You have set the business safe to %d.", amount);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "%s has changed BusinessID %d's safe to %d.", GetPlayerNameEx(playerid), businessid, amount);
		Log("logs/bedit.log", string);
	}

	else if (!strcmp(choice, "gymentryfee", true))
	{
		if (Businesses[businessid][bType] != BUSINESS_TYPE_GYM)
		{
			return SendClientMessageEx(playerid, COLOR_GRAD2, "Only Gyms can have entrance fees!");
		}

		Businesses[businessid][bGymEntryFee] = amount;
		format(string, sizeof(string), "You have set the gym entry fee to %i.", amount);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "%s has changed BusinessID %i's gym entry fee to %i.", GetPlayerNameEx(playerid), businessid, amount);
		Log("logs/bedit.log", string);
	}

	else if (!strcmp(choice, "gymtype", true))
	{
		if (Businesses[businessid][bType] != BUSINESS_TYPE_GYM)
		{
			return SendClientMessageEx(playerid, COLOR_GRAD2, "You can only use this command on a gym!");
		}

		if (amount == 1) // swimming pool & boxing arena
		{
			Businesses[businessid][bGymType] = amount;
		}
		else if (amount == 2) // bike parkour
		{
			Businesses[businessid][bGymType] = amount;
		}
		else
		{
			return SendClientMessageEx(playerid, COLOR_GRAD2, "Available types are: Swimming Pool / Boxing Arena(1) or Bike Parkour (2)");
		}

		format(string, sizeof(string), "You have the set the gym type to %i.", amount);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "%s has changed BusinessID %i's gym type to %i.", GetPlayerNameEx(playerid), businessid, amount);
		Log("logs/bedit.log", string);
	}

	else if(!strcmp(choice, "delete", true))
	{
		Businesses[businessid][bExtPos][0] = 0;
		Businesses[businessid][bExtPos][1] = 0;
		Businesses[businessid][bExtPos][2] = 0;
		Businesses[businessid][bName][0] = 0;
		Businesses[businessid][bType] = 0;
		format(string, sizeof(string), "You have deleted the business.", amount);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "%s has deleted BusinessID %d.", GetPlayerNameEx(playerid), businessid);
		Log("logs/bedit.log", string);
		//TODO IMPROVE
		for (new i; i < MAX_BUSINESS_GAS_PUMPS; i++) {
			DestroyDynamicGasPump(businessid, i);
		}
		for (new i; i < MAX_BUSINESS_DEALERSHIP_VEHICLES; i++) {
			DestroyVehicle(Businesses[businessid][bVehID][i]);
		}
	}

	RefreshBusinessPickup(businessid);
	SaveBusiness(businessid);
	Streamer_UpdateEx(playerid, Businesses[businessid][bExtPos][0], Businesses[businessid][bExtPos][1], Businesses[businessid][bExtPos][2]);

	return 1;
}

CMD:bname(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pShopTech] >= 1 || PlayerInfo[playerid][pBM] >= 1)
	{
		new name[40], businessid;

		if(sscanf(params, "ds[40]", businessid, name)) {
			return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /bname [business id] [name]");
		}
		else if (!IsValidBusinessID(businessid)) {
			return SendClientMessageEx(playerid, COLOR_GREY, "Invalid business specified.");
		}
		else if(strfind(name, "\r") != -1 || strfind(name, "\n") != -1) {
			return SendClientMessageEx(playerid, COLOR_GREY, "Newline characters are forbidden.");
		}

		strcpy(Businesses[businessid][bName], name, sizeof(name));
		SaveBusiness(businessid);
		SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully changed the name of this business.");
		RefreshBusinessPickup(businessid);

		new string[128];
		format(string, sizeof(string), "%s has edited business ID %d's name to %s.", GetPlayerNameEx(playerid), businessid, Businesses[businessid][bName]);
		Log("logs/bedit.log", string);
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use that command.");
	}

	return 1;
}

CMD:bnext(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pShopTech] >= 1 || PlayerInfo[playerid][pBM] >= 1)
	{
		SendClientMessageEx(playerid, COLOR_RED, "* Listing next available business...");
		for(new i; i<MAX_BUSINESSES;i++)
		{
		    if(Businesses[i][bType] == 0)
		    {
		        new string[128];
		        format(string, sizeof(string), "%d is available to use.", i);
		        SendClientMessageEx(playerid, COLOR_WHITE, string);
		        break;
			}
		}
	}
	else
	{
	    SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use that command.");
	}
	return 1;
}


CMD:bnear(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pShopTech] >= 1 || PlayerInfo[playerid][pBM] >= 1)
	{
		SendClientMessageEx(playerid, COLOR_RED, "* Listing businesses within 30 meters of you");
		for(new i;i<MAX_BUSINESSES;i++)
		{
			if(IsPlayerInRangeOfPoint(playerid, 30, Businesses[i][bExtPos][0], Businesses[i][bExtPos][1], Businesses[i][bExtPos][2]))
			{
			    new string[128];
		    	format(string, sizeof(string), "Business ID %d | %f from you", i, GetPlayerDistanceFromPoint(playerid,Businesses[i][bExtPos][0], Businesses[i][bExtPos][1], Businesses[i][bExtPos][2]));
		    	SendClientMessageEx(playerid, COLOR_WHITE, string);
			}
		}
	}
	else
	{
	    SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use that command.");
	}
	return 1;
}

CMD:gotobiz(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pShopTech] >= 1 || PlayerInfo[playerid][pBM] >= 1)
	{
		new id;
		if(sscanf(params, "d", id)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /gotobiz [business id]");
		if(!IsValidBusinessID(id)) return SendClientMessageEx(playerid, COLOR_GREY, "Invalid business ID specified.");
		if (Businesses[id][bExtPos][0] == 0.0) return SendClientMessageEx(playerid, COLOR_GREY, "No exterior set for this business.");
		GameTextForPlayer(playerid, "~w~Teleporting", 5000, 1);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		PlayerInfo[playerid][pInt] = 0;
		PlayerInfo[playerid][pVW] = 0;
		SetPlayerPos(playerid,Businesses[id][bExtPos][0],Businesses[id][bExtPos][1],Businesses[id][bExtPos][2]);
		SetPlayerFacingAngle(playerid,Businesses[id][bExtPos][3]);
	}
	else
	{
	    SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use that command.");
	}
	return 1;
}


CMD:goinbiz(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pShopTech] >= 1 || PlayerInfo[playerid][pBM] >= 1)
	{
		new id;
		if(sscanf(params, "d", id)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /goinbiz [businessid]");
		if(!IsValidBusinessID(id)) return SendClientMessageEx(playerid, COLOR_GREY, "Invalid business ID specified.");
		if (Businesses[id][bExtPos][0] == 0.0) return SendClientMessageEx(playerid, COLOR_GREY, "No interior set for this business.");
		SetPlayerInterior(playerid,Businesses[id][bInt]);
		SetPlayerPos(playerid,Businesses[id][bIntPos][0],Businesses[id][bIntPos][1],Businesses[id][bIntPos][2]);
		SetPlayerFacingAngle(playerid,Businesses[id][bIntPos][3]);
		SetPVarInt(playerid, "BusinessesID", id);
		if(Businesses[id][bVW] == 0) SetPlayerVirtualWorld(playerid, BUSINESS_BASE_VW + id), PlayerInfo[playerid][pVW] = BUSINESS_BASE_VW + id;
		else SetPlayerVirtualWorld(playerid, Businesses[id][bVW]), PlayerInfo[playerid][pVW] = Businesses[id][bVW];
	}
	else
	{
	    SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use that command.");
	}
	return 1;
}

CMD:asellbiz(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pBM] < 2) {
		return SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use that command.");
	}

	new string[128], biz;
	if(sscanf(params, "d", biz)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /asellbiz [business id]");

	Businesses[biz][bOwner] = -1;
	SaveBusiness(biz);
	RefreshBusinessPickup(biz);
	new ip[16];
	GetPlayerIp(playerid,ip,sizeof(ip));
	format(string,sizeof(string),"Administrator %s (IP: %s) has admin-sold business ID %d (was owned by %d).",GetPlayerNameEx(playerid),ip,biz,Businesses[biz][bOwner]);
	Log("logs/business.log", string);
	PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	format(string, sizeof(string), "~w~You have sold business %d.", biz);
	GameTextForPlayer(playerid, string, 10000, 3);
	//foreach(new j: Player) {
	for(new j = 0; j < MAX_PLAYERS; ++j)
	{
		if(IsPlayerConnected(j))
		{	
			if(PlayerInfo[j][pBusiness] == biz) 
			{
				PlayerInfo[j][pBusiness] = INVALID_BUSINESS_ID;
				PlayerInfo[j][pBusinessRank] = 0;
				SendClientMessageEx(playerid, COLOR_WHITE, "An admin has sold this business, your business stats have been reset.");
			}
		}	
	}

	format(string, sizeof(string), "UPDATE `accounts` SET `Business` = "#INVALID_BUSINESS_ID", `BusinessRank` = 0 WHERE `Business` = '%d'", biz);
	mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	return 1;
}

/*CMD:sellbiz(playerid, params[])
{
    if(PlayerInfo[playerid][pBusiness] == INVALID_BUSINESS_ID )
    {
        return SendClientMessageEx(playerid, COLOR_GREY, "You don't own a business!");
	}
	else if(PlayerInfo[playerid][pBusinessRank] < 5 && Businesses[PlayerInfo[playerid][pBusiness]][bOwner] != GetPlayerSQLId(playerid)) {
	    return SendClientMessageEx(playerid, COLOR_GREY, "You aren't the owner of the business.");
	}
    else if (IsPlayerInRangeOfPoint(playerid, 2.0, Businesses[PlayerInfo[playerid][pBusiness]][bExtPos][0], Businesses[PlayerInfo[playerid][pBusiness]][bExtPos][1], Businesses[PlayerInfo[playerid][pBusiness]][bExtPos][2]))
    {
        new i = PlayerInfo[playerid][pBusiness];

		PlayerInfo[playerid][pBusiness] = INVALID_BUSINESS_ID;
		PlayerInfo[playerid][pBusinessRank] = 0;
		GivePlayerCash(playerid,Businesses[i][bValue]);
		OnPlayerStatsUpdate(playerid);
		Businesses[i][bOwner] = -1;
		SaveBusiness(i);
		RefreshBusinessPickup(i);
		new string[128];
		format(string,sizeof(string),"%s (IP: %s) has sold business ID %d for $%d",GetPlayerNameEx(playerid),GetPlayerIpEx(playerid),i, Businesses[i][bValue]);
		Log("logs/business.log", string);
		PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
		format(string, sizeof(string), "~w~Congratulations~n~You have sold your business for ~n~~g~$%d", Businesses[i][bValue]);
		GameTextForPlayer(playerid, string, 10000, 3);
		foreach(new j: Player) {
			if(PlayerInfo[j][pBusiness] == i) {
				PlayerInfo[j][pBusiness] = INVALID_BUSINESS_ID;
				PlayerInfo[j][pBusinessRank] = 0;
				SendClientMessageEx(playerid, COLOR_WHITE, "The owner of the business you were a part of has sold his business.");
			}
		}

		format(string, sizeof(string), "UPDATE `accounts` SET `Business` = "#INVALID_BUSINESS_ID", `BusinessRank` = 0 WHERE `Business` = '%d'", i);
		mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);
		return 1;
    }
    else
    {
	    SendClientMessageEx(playerid, COLOR_WHITE, "You need to be at your business in order to sell it.");
	    return 1;
    }
}

CMD:buybiz(playerid, params[])
{
    if(PlayerInfo[playerid][pBusiness] != INVALID_BUSINESS_ID) return SendClientMessageEx(playerid, COLOR_GREY, "You already own a business!");
	for(new i = 0; i < sizeof(Businesses); i++)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 2.0, Businesses[i][bExtPos][0], Businesses[i][bExtPos][1], Businesses[i][bExtPos][2]))
	    {
	        if (Businesses[i][bOwner] >= 1)
	        {
	        	return SendClientMessageEx(playerid, COLOR_GREY, "This business is already owned!");
	        }
	        if (GetPlayerCash(playerid) < Businesses[i][bValue])
	        {
	        	return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough cash!");
	        }
			GivePlayerCash(playerid, -Businesses[i][bValue]);
			Businesses[i][bOwner] = GetPlayerSQLId(playerid);
			strcpy(Businesses[i][bOwnerName], GetPlayerNameEx(playerid), MAX_PLAYER_NAME);
			PlayerInfo[playerid][pBusiness] = i;
			PlayerInfo[playerid][pBusinessRank] = 5;
			SendClientMessageEx(playerid, COLOR_WHITE, "Congratulations on your new purchase!");
			SendClientMessageEx(playerid, COLOR_WHITE, "Type /help to review the business help section!");
			SaveBusiness(i);
			OnPlayerStatsUpdate(playerid);
			RefreshBusinessPickup(i);
			new string[128];
			format(string,sizeof(string),"%s (IP: %s) has bought business ID %d for $%d.", GetPlayerNameEx(playerid), GetPlayerIpEx(playerid), i, Businesses[i][bValue]);
			Log("logs/business.log", string);
			return 1;
	    }
	}
	return SendClientMessageEx(playerid, COLOR_WHITE, "You're not near a business!");
}
*/

CMD:creategaspump(playerid, params[])
{
    new string[128], iBusinessID;
    if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pBM] >= 1) {

		if(sscanf(params, "d", iBusinessID)) {
			return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /creategaspump [business id]");
		}
		else
		{
			if (GetFreeGasPumpID(iBusinessID) == INVALID_GAS_PUMP)
			return SendClientMessageEx(playerid, COLOR_GRAD1, "The maximum number of gas pumps has been reached for this business.");

			if (!(0 <= iBusinessID < MAX_BUSINESSES)) {
				return SendClientMessageEx(playerid, COLOR_GREY, "Invalid business specified.");
			}
		 	if (!Businesses[iBusinessID][bType]) {
		 		return SendClientMessageEx(playerid, COLOR_GREY, "Type of this business must have been set before using this command.");
		 	}
			if(!IsBusinessGasAble(Businesses[iBusinessID][bType])) {
		        return SendClientMessageEx(playerid, COLOR_GREY, "You can't create gas pumps for this type of business.");
		    }
		    if(!IsPlayerInRangeOfPoint(playerid, 150.0, Businesses[iBusinessID][bExtPos][0], Businesses[iBusinessID][bExtPos][1], Businesses[iBusinessID][bExtPos][2])) {
		        return SendClientMessageEx(playerid, COLOR_GREY, "You are too far away from the business.");
		    }
			new iPump = GetFreeGasPumpID(iBusinessID);
			Businesses[iBusinessID][GasPumpCapacity][iPump] = Businesses[iBusinessID][bLevel] * 100;
			CreateDynamicGasPump(playerid, iBusinessID, iPump);
			SaveBusiness(iBusinessID);

			format(string, sizeof(string), "%s has created a gas pump for %s (%d)", Businesses[iBusinessID][bName], iBusinessID);
			Log("logs/bedit.log", string);
			return 1;

		}
    } else return SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use this command.");
}

CMD:editgaspump(playerid, params[])
{
    new iBusinessID, iPumpID, szLog[128], szName[9], Float: fValue;
    if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pBM] < 1) {
        return SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use this command.");
    }

	if(sscanf(params, "dds[9]F(0)", iBusinessID, iPumpID, szName, fValue)) {
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /editgaspump [business id] [pump id] [name] [value]");
		SendClientMessageEx(playerid, COLOR_GREY, "Available Names: Capacity, Gas, Position");
	}

	if (!(0 <= iBusinessID < MAX_BUSINESSES))
	{
		return SendClientMessageEx(playerid, COLOR_GREY, "Invalid business specified.");
	}
	else if (!(0 <= iPumpID < MAX_BUSINESS_GAS_PUMPS))
	{
		return SendClientMessageEx(playerid, COLOR_GREY, "Invalid gas pump specified.");
	}
	else if(Businesses[iBusinessID][GasPumpVehicleID][iPumpID])
	{
		return SendClientMessageEx(playerid, COLOR_GREY, "You can't edit a gas pump while it is in use.");
	}

	if(!strcmp(szName, "position", true))
	{
	    if(!IsPlayerInRangeOfPoint(playerid, 150.0, Businesses[iBusinessID][bExtPos][0], Businesses[iBusinessID][bExtPos][1], Businesses[iBusinessID][bExtPos][2])) {
        	return SendClientMessageEx(playerid, COLOR_GREY, "You are far away from the business.");
    	}
    	format(szLog, sizeof(szLog), "%s has changed the position of pump %d for business %d", GetPlayerNameEx(playerid), iPumpID, iBusinessID);

		DestroyDynamicGasPump(iBusinessID, iPumpID);
		CreateDynamicGasPump(playerid, iBusinessID, iPumpID);
		SaveBusiness(iBusinessID);

	}
	else if(!strcmp(szName, "gas", true))
	{
	    if (fValue > Businesses[iBusinessID][GasPumpCapacity][iPumpID])
	    {
		    SendClientMessageEx(playerid, COLOR_GREY, "The value cannot be higher than the capacity!");
		    return 1;
	    }
		Businesses[iBusinessID][GasPumpGallons][iPumpID] = fValue;
		SendClientMessageEx(playerid, COLOR_WHITE, "You have edited the gas pump gas amount!");
		format(szLog, sizeof(szLog), "%s has changed the gas amount of pump %d for %s (%d) to %.2f", GetPlayerNameEx(playerid), iPumpID, Businesses[iBusinessID][bName], iBusinessID, fValue);
	}
	else if(!strcmp(szName, "capacity", true))
	{
		Businesses[iBusinessID][GasPumpCapacity][iPumpID] = fValue;
		SendClientMessageEx(playerid, COLOR_WHITE, "You have edited the gas pump capacity!");
		format(szLog, sizeof(szLog), "%s has changed the gas capacity of pump %d for %s (%d) to %.2f", GetPlayerNameEx(playerid), iPumpID, Businesses[iBusinessID][bName], iBusinessID, fValue);
	}

	SaveBusiness(iBusinessID);
	Log("logs/bedit.log", szLog);
	return 1;
}

CMD:deletegaspump(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pBM] < 1) {
        return SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use this command.");
    }
    new businessid, id, string[128];
	if(sscanf(params, "dd", businessid, id)) {
		return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /deletegaspump [business id] [pump id]");
	}
	if(!IsValidBusinessID(businessid) || id < 0 || id >= MAX_BUSINESS_GAS_PUMPS || Businesses[businessid][GasPumpPosX][id] == 0) {
		return SendClientMessageEx(playerid, COLOR_GREY, "No gas pump found with that ID.");
	}
	if(Businesses[businessid][GasPumpVehicleID][id]) {
		return SendClientMessageEx(playerid, COLOR_GREY, "You can't delete a gas pump while it is in use.");
	}

 	DestroyDynamicGasPump(businessid, id);
	Businesses[businessid][GasPumpPosX][id] = 0;
	Businesses[businessid][GasPumpPosY][id] = 0;
	Businesses[businessid][GasPumpPosZ][id] = 0;
	Businesses[businessid][GasPumpAngle][id] = 0;
	Businesses[businessid][GasPumpCapacity][id] = 0;
	Businesses[businessid][GasPumpGallons][id] = 0;
	Businesses[businessid][GasPumpSaleGallons][id] = 0;
	Businesses[businessid][GasPumpSalePrice][id] = 0;
	SaveBusiness(businessid);

    format(string, sizeof(string), "You have successfully deleted the gas pump %d for business %d.", id, businessid);
    SendClientMessageEx(playerid, COLOR_WHITE, string);

	format(string, sizeof(string), "Admin %s deleted a gas pump for business %d", businessid);
	Log("logs/bedit.log", string);

	return 1;
}

CMD:addmats(playerid, params[]) {
	return cmd_addmaterials(playerid, params);
}

CMD:addmaterials(playerid, params[])
{
    new	string[128], amount;
	if (PlayerInfo[playerid][pBusiness] == INVALID_BUSINESS_ID) {
		return SendClientMessageEx(playerid, COLOR_GREY, "You are not in a business!");
	}
	if (Businesses[PlayerInfo[playerid][pBusiness]][bType] != BUSINESS_TYPE_GUNSHOP) {
		return SendClientMessageEx(playerid, COLOR_GREY, "Command not available for this type of business.");
	}
	if(sscanf(params, "d", amount) || amount < 0) {
		return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /addmaterials [amount]");
	}
	if (amount > PlayerInfo[playerid][pMats]) {
		return SendClientMessageEx(playerid, COLOR_GREY, "You don't have that many materials.");
	}
	if (Businesses[PlayerInfo[playerid][pBusiness]][bInventory] + amount > Businesses[PlayerInfo[playerid][pBusiness]][bInventoryCapacity]) {
		return SendClientMessageEx(playerid, COLOR_GREY, "Inventory capacity exceeded.");
	}
	if (InBusiness(playerid) != PlayerInfo[playerid][pBusiness]) {
		return SendClientMessageEx(playerid, COLOR_GREY, "You must be inside the business.");
	}
	Businesses[PlayerInfo[playerid][pBusiness]][bInventory] += amount;
	PlayerInfo[playerid][pMats] -= amount;
	OnPlayerStatsUpdate(playerid);
	SaveBusiness(PlayerInfo[playerid][pBusiness]);
	SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You have successfully added materials to the business inventory!");
	format(string, sizeof(string), "INVENTORY: %d/%d materials", Businesses[PlayerInfo[playerid][pBusiness]][bInventory], Businesses[PlayerInfo[playerid][pBusiness]][bInventoryCapacity]);
	SendClientMessageEx(playerid, COLOR_WHITE, string);
	return 1;
}

CMD:offergun(playerid, params[])
{
	if (PlayerInfo[playerid][pBusiness] != INVALID_BUSINESS_ID && Businesses[PlayerInfo[playerid][pBusiness]][bType] != BUSINESS_TYPE_GUNSHOP)	{
		return SendClientMessageEx(playerid, COLOR_GREY, "You are not working for a gun store!");
	}
	new buyerid, weapon;
	if (sscanf(params, "uk<sweapon>", buyerid, weapon)) {
		return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /offergun [player] [weapon name]");
	}
	if (!IsPlayerConnected(buyerid)) {
		return SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified!");
	}
	if (playerid == buyerid) {
		return SendClientMessageEx(playerid, COLOR_GREY, "You can't offer a gun to yourself!");
	}
    if(!ProxDetectorS(5.0, playerid, buyerid)) {
    	return SendClientMessageEx(playerid, COLOR_GREY, "The customer is not near you!");
    }
	if (InBusiness(playerid) != PlayerInfo[playerid][pBusiness]) {
		return SendClientMessageEx(playerid, COLOR_GREY, "You are not inside the business!");
	}
	if(PlayerInfo[buyerid][pConnectHours] < 2 || PlayerInfo[buyerid][pWRestricted] > 0) {
		return SendClientMessageEx(playerid, COLOR_GREY, "That player is currently weapon restricted!");
	}	
	new b = InBusiness(playerid);
	if (Businesses[b][bInventory] < GetWeaponParam(weapon, WeaponMats)) {
		return SendClientMessageEx(playerid, COLOR_GREY, "Business inventory does not have enough materials for that weapon.");
	}
	if (Businesses[b][bInventory] < GetWeaponParam(weapon, WeaponMinLevel)) {
		return SendClientMessageEx(playerid, COLOR_GREY, "Business level is not high enough to sell that type of gun.");
 	}

	new price = GetWeaponPrice(PlayerInfo[playerid][pBusiness], weapon);

	new string[128];
	format(string, sizeof(string), "* You offered %s to buy a %s for $%s", GetPlayerNameEx(buyerid), Weapon_ReturnName(weapon), number_format(price));
    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
    format(string, sizeof(string), "* Employee %s offers you a %s for $%s (type /accept gun) to buy.", GetPlayerNameEx(playerid), Weapon_ReturnName(weapon), number_format(price));
    SendClientMessageEx(buyerid, COLOR_LIGHTBLUE, string);

	SetPVarInt(buyerid, "Business_WeapType", weapon);
	SetPVarInt(buyerid, "Business_WeapOfferer", playerid);
	SetPVarInt(buyerid, "Business_WeapOffererSQLId", GetPlayerSQLId(playerid));
	SetPVarInt(buyerid, "Business_WeapPrice", price);
	return 1;
}


CMD:offermenu(playerid, params[])
{
    new iBusiness = InBusiness(playerid);

   	if(iBusiness == INVALID_BUSINESS_ID || (Businesses[iBusiness][bType] != BUSINESS_TYPE_BAR && Businesses[iBusiness][bType] != BUSINESS_TYPE_CLUB && Businesses[iBusiness][bType] != BUSINESS_TYPE_RESTAURANT)) return SendClientMessageEx(playerid, COLOR_GRAD2, "   You are not in a bar, club or restaurant!");
	else if(Businesses[iBusiness][bInventory] < 1) return SendClientMessageEx(playerid, COLOR_GRAD2, "   Business does not have enough inventory!");

	new szDialog[512], pvar[25], line;

	if (Businesses[iBusiness][bType] == BUSINESS_TYPE_BAR || Businesses[iBusiness][bType] == BUSINESS_TYPE_CLUB)
	{
		for (new item; item < sizeof(Drinks); item++)
		{
			new cost = (PlayerInfo[playerid][pDonateRank] >= 1) ? (floatround(Businesses[iBusiness][bItemPrices][item] * 0.8)) : (Businesses[iBusiness][bItemPrices][item]);
			format(szDialog, sizeof(szDialog), "%s%s  ($%s)\n", szDialog, Drinks[item], number_format(cost));
			format(pvar, sizeof(pvar), "Business_MenuItem%d", line);
			SetPVarInt(playerid, pvar, item);
			format(pvar, sizeof(pvar), "Business_MenuItemPrice%d", line);
			SetPVarInt(playerid, pvar, Businesses[iBusiness][bItemPrices][item]);
			line++;
		}
	}
	else if(Businesses[iBusiness][bType] == BUSINESS_TYPE_RESTAURANT)
	{
		for (new item; item < sizeof(RestaurantItems); ++item)
		{
			new cost = (PlayerInfo[playerid][pDonateRank] >= 1) ? (floatround(Businesses[iBusiness][bItemPrices][item] * 0.8)) : (Businesses[iBusiness][bItemPrices][item]);
			format(szDialog, sizeof(szDialog), "%s%s  ($%s)\n", szDialog, RestaurantItems[item], number_format(cost));
			format(pvar, sizeof(pvar), "Business_MenuItem%d", line);
			SetPVarInt(playerid, pvar, item);
			format(pvar, sizeof(pvar), "Business_MenuItemPrice%d", line);
			SetPVarInt(playerid, pvar, Businesses[iBusiness][bItemPrices][item]);
			line++;
		}
	}

   	if(strlen(szDialog) == 0) SendClientMessageEx(playerid, COLOR_GRAD2, "   Store is not selling any items!");
    else ShowPlayerDialog(playerid, RESTAURANTMENU, DIALOG_STYLE_LIST, "Menu", szDialog, "Buy", "Cancel");
    return 1;
}

CMD:buyfood(playerid, params[])
{
	if (!IsAtRestaurant(playerid))
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "   You are not in a restaurant!");
		return 1;
	}

	new iBusiness = InBusiness(playerid);

	if (Businesses[iBusiness][bInventory] < 1) {
	    SendClientMessageEx(playerid, COLOR_GRAD2, "   Business does not have enough inventory!");
	    return 1;
	}

	if (!Businesses[iBusiness][bStatus])
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "This restaurant is closed!");
		return 1;
	}

	new szDialog[512], pvar[25], line;

	for (new item; item < sizeof(RestaurantItems); ++item)
	{
		format(szDialog, sizeof(szDialog), "%s%s  ($%s)\n", szDialog, RestaurantItems[item], number_format(Businesses[iBusiness][bItemPrices][item]));
		format(pvar, sizeof(pvar), "Business_MenuItem%d", line);
		SetPVarInt(playerid, pvar, item);
		format(pvar, sizeof(pvar), "Business_MenuItemPrice%d", line);
		SetPVarInt(playerid, pvar, Businesses[iBusiness][bItemPrices][item]);
		line++;
	}

	if (strlen(szDialog) == 0)
	{
        SendClientMessageEx(playerid, COLOR_GRAD2, "   Store is not selling any items!");
    }
    else
	{
    	ShowPlayerDialog(playerid, RESTAURANTMENU, DIALOG_STYLE_LIST, "Menu", szDialog, "Buy", "Cancel");
    }

	return 1;
}

CMD:bpanic(playerid, params[])
{
	if (PlayerInfo[playerid][pBusiness] == INVALID_BUSINESS_ID) {
		return SendClientMessageEx(playerid, COLOR_GREY, "You are not working for a business!");
	}
	if (PlayerInfo[playerid][pBusiness] != InBusiness(playerid)) {
		return SendClientMessageEx(playerid, COLOR_GREY, "You are not in the business interior!");
	}
	new string[128];
	if(GetPVarInt(playerid, "bizpanic") == 0)
	{
		format(string, sizeof(string), "** %s hits a small button.", GetPlayerNameEx(playerid));
		ProxDetector(15.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		format(string, sizeof(string), "* %s %s has hit the panic button at %s - /bizfind %d for a gps location.", GetBusinessRankName(PlayerInfo[playerid][pBusinessRank]), GetPlayerNameEx(playerid), Businesses[InBusiness(playerid)][bName], InBusiness(playerid));
		SendClientMessage(playerid, COLOR_GRAD2, "* The police have been notified that you require help. ");
		SetPVarInt(playerid, "bizpanic", 1);
	}
	else
	{
		format(string, sizeof(string), "** %s hits a small button.", GetPlayerNameEx(playerid));
		ProxDetector(15.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		format(string, sizeof(string), "* %s %s no longer requires help at %s.", GetBusinessRankName(PlayerInfo[playerid][pBusinessRank]), GetPlayerNameEx(playerid), Businesses[InBusiness(playerid)][bName]);
		SendClientMessage(playerid, COLOR_GRAD2, "* The police have been notified that you no longer require help. ");
		SetPVarInt(playerid, "bizpanic", 0);
	}
	//foreach(new i: Player)
	for(new i = 0; i < MAX_PLAYERS; ++i)
	{
		if(IsPlayerConnected(i))
		{	
			if(IsACop(i))
			{
				SetPlayerMarkerForPlayer(i, playerid, 0x2641FEAA);
				SendClientMessageEx(i, COLOR_LIGHTBLUE, string);
			}
		}	
	}
	return 1;
}

CMD:bizfind(playerid, params[])
{
	if(IsACop(playerid))
	{
	    new iBusinessID, string[128];
	    if(sscanf(params, "d", iBusinessID))
	    {
	        return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /bizfind [business id]");
	    }
		if(IsValidBusinessID(iBusinessID))
		{
		    if(Businesses[iBusinessID][bOwner])
		    {
                SetPVarInt(playerid,"bpanic", 1);
		        format(string, sizeof(string), "* Setting your GPS Waypoint to find %s", Businesses[iBusinessID][bName]);
 				SetPlayerCheckpoint(playerid, Businesses[iBusinessID][bExtPos][0], Businesses[iBusinessID][bExtPos][1], Businesses[iBusinessID][bExtPos][2], 4.0);
 				return 1;
			}
			return SendClientMessageEx(playerid, COLOR_GRAD2, " That business doesn't have an owner. ");
		}
		return SendClientMessageEx(playerid, COLOR_GRAD2, " Invalid Business ID.");
	}
	return SendClientMessageEx(playerid, COLOR_GRAD2, " You do not have access to the Business Directory. (Law Enforcement Only)");
}

CMD:binventory(playerid, params[])
{
	new
		string[128],
		iBusiness = PlayerInfo[playerid][pBusiness];
	if(iBusiness != INVALID_BUSINESS_ID)
	{
		SendClientMessageEx(playerid, COLOR_GREEN, "|_________ Business Inventory_________|");
		format(string, sizeof(string), "Amount: %d / Capacity: %d / Type: %s", Businesses[iBusiness][bInventory], Businesses[iBusiness][bInventoryCapacity], GetInventoryType(iBusiness));
		SendClientMessageEx(playerid, COLOR_WHITE, string);

		for (new i; i < MAX_BUSINESS_GAS_PUMPS; i++) {
			if (Businesses[iBusiness][GasPumpPosX][i] != 0.0) {
				format(string, sizeof(string), "Gas Tank %d:  %.2f gal / %.2f gal", i+1, Businesses[iBusiness][GasPumpGallons][i], Businesses[iBusiness][GasPumpCapacity][i]);
				SendClientMessageEx(playerid, COLOR_WHITE, string);
			}
		}
	}
	else SendClientMessage(playerid, COLOR_GRAD2, " You don't own or work for a business.");
	return 1;
}

CMD:offeritem(playerid, params[])
{
	new buyerid, item;
	if (PlayerInfo[playerid][pBusiness] == INVALID_BUSINESS_ID || Businesses[PlayerInfo[playerid][pBusiness]][bType] != BUSINESS_TYPE_STORE && Businesses[PlayerInfo[playerid][pBusiness]][bType] != BUSINESS_TYPE_GASSTATION) {
		return SendClientMessageEx(playerid, COLOR_GREY, "You are not working for a 24/7 store!");
	}
	if (sscanf(params, "uk<storeitem>", buyerid, item))	{
	    SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /offeritem [Player] [Item]");
	    SendClientMessageEx(playerid, COLOR_GREY, "Items - cellphone, phonebook, dice, condom, musicplayer, rope, cigar, sprunk, lock, spraycan, radio, camera, lotteryticket,");
	    return SendClientMessageEx(playerid, COLOR_GREY, "checkbook, paper, industriallock, elock, and standardcaralarm");
	}
	if (PlayerInfo[playerid][pBusiness] != InBusiness(playerid)) {
		return SendClientMessageEx(playerid, COLOR_GREY, "You are not in the business interior!");
	}
	if (Businesses[PlayerInfo[playerid][pBusiness]][bInventory] < 1) {
		return SendClientMessageEx(playerid, COLOR_GREY, "Business inventory has no items.");
	}
	if (!IsPlayerConnected(buyerid)) {
		return SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified!");
	}
	if (item == INVALID_STORE_ITEM)	{
		return SendClientMessageEx(playerid, COLOR_GREY, "Invalid item specified!");
	}
	if (!Businesses[PlayerInfo[playerid][pBusiness]][bItemPrices][item-1]) {
	    SendClientMessageEx(playerid, COLOR_GRAD4, "This item is not for sale.");
	    return 1;
	}
	if (playerid == buyerid) {
		return SendClientMessageEx(playerid, COLOR_GREY, "You can't offer an item to yourself!");
	}
    if(!ProxDetectorS(5.0, playerid, buyerid)) {
		return SendClientMessageEx(playerid, COLOR_GREY, "The customer is not near you!");
    }

	new string[128];
    format(string, sizeof(string), "* You offered %s to buy a %s.", GetPlayerNameEx(buyerid), StoreItems[item-1]);
    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
    format(string, sizeof(string), "* %s wants to sell you a %s for $%s (type /accept item to buy)", GetPlayerNameEx(playerid), StoreItems[item-1], number_format(Businesses[PlayerInfo[playerid][pBusiness]][bItemPrices][item-1]));
    SendClientMessageEx(buyerid, COLOR_LIGHTBLUE, string);

	SetPVarInt(buyerid, "Business_ItemType", item-1);
	SetPVarInt(buyerid, "Business_ItemPrice", Businesses[PlayerInfo[playerid][pBusiness]][bItemPrices][item-1]);
	SetPVarInt(buyerid, "Business_ItemOfferer", playerid);
	SetPVarInt(buyerid, "Business_ItemOffererSQLId", GetPlayerSQLId(playerid));

	return 1;
}

CMD:resupply(playerid, params[])
{
	new iBusiness = PlayerInfo[playerid][pBusiness];
	new amount;
	new string[128];
	new year, month, day;
	if (sscanf(params, "d", amount))
	{
		return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /resupply [amount]");
	}
	if (PlayerInfo[playerid][pBusiness] == INVALID_BUSINESS_ID) {
	    return SendClientMessageEx(playerid, COLOR_GREY, "You don't own a business.");
	}
	if (PlayerInfo[playerid][pBusinessRank] < Businesses[iBusiness][bMinSupplyRank]) {
		return SendClientMessageEx(playerid, COLOR_GREY, "Your rank is not high enough for placing resupply orders!");
	}
	if(amount < 1) { 
		return SendClientMessageEx(playerid, COLOR_GREY, "Resupply amount cannot be below 1.");
	}	
	if (Businesses[iBusiness][bOrderState] == 1) {
		return SendClientMessageEx(playerid, COLOR_WHITE, "You already have a pending order. Either cancel it or wait for it to be delivered before placing orders.");
	}
	if (Businesses[iBusiness][bOrderState] == 2) {
		return SendClientMessageEx(playerid, COLOR_WHITE, "You already have an order which is being delivered.");
	}
	if (Businesses[iBusiness][bSupplyPos][0] == 0.0) {
		return SendClientMessageEx(playerid, COLOR_GREY, "This business does not have a delivery point for Shipment Contractors.");
	}
	if (Businesses[iBusiness][bInventory] >= Businesses[iBusiness][bInventoryCapacity]) {
		return SendClientMessageEx(playerid, COLOR_GREY, "Inventory is already at full capacity.");
	}
	if(Businesses[iBusiness][bInventory] + amount > Businesses[iBusiness][bInventoryCapacity])
	{
	    return SendClientMessageEx(playerid, COLOR_GREY, "Your inventory does not have the capacity.");
	}
	if (Businesses[iBusiness][bSafeBalance] < floatround(amount * BUSINESS_ITEMS_COST)) {
	    format(string, sizeof(string), "Safe balance is not enough for this. ($%s)", number_format(floatround(amount * BUSINESS_ITEMS_COST)));
		return SendClientMessageEx(playerid, COLOR_GREY, string);
	}

	format(Businesses[iBusiness][bOrderBy], MAX_PLAYER_NAME, "%s", GetPlayerNameEx(playerid));
	getdate(year, month, day);
	format(Businesses[iBusiness][bOrderDate], 30, "%d-%02d-%02d %02d:%02d:%02d", year, month, day, hour, minuite, second);
	Businesses[iBusiness][bSafeBalance] -= floatround(amount * BUSINESS_ITEMS_COST);
	Businesses[iBusiness][bOrderAmount] = amount;
	Businesses[iBusiness][bOrderState] = 1;
	SaveBusiness(iBusiness);
	format(string, sizeof(string), "%s (IP: %s) has placed a resupply order for %s (%d)", GetPlayerNameEx(playerid), GetPlayerIpEx(playerid), Businesses[PlayerInfo[playerid][pBusiness]][bName], PlayerInfo[playerid][pBusiness]);
	Log("logs/business.log", string);
	format(string, sizeof(string), "* You have placed a resupply order for %s", Businesses[PlayerInfo[playerid][pBusiness]][bName]);
	SendClientMessage(playerid, COLOR_GRAD2, string);
	return 1;
}

CMD:checkresupply(playerid, params[])
{
	new iBusinessID = PlayerInfo[playerid][pBusiness];
	if((0 <= iBusinessID < MAX_BUSINESSES) && PlayerInfo[playerid][pBusinessRank] >= Businesses[iBusinessID][bMinSupplyRank])
	{
		new iOrderState = Businesses[iBusinessID][bOrderState];
		if (!iOrderState)
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "Your business has never placed a resupply order.");
			return 1;
		}
		else
		{
			new string[128];
			SendClientMessageEx(playerid, COLOR_GREEN, "|___________ Latest Resupply Order ___________|");
			format(string,sizeof(string), "Date/Time: %s -- Amount: %s -- Status: %s", Businesses[iBusinessID][bOrderDate], number_format(Businesses[iBusinessID][bOrderAmount]), GetSupplyState(iOrderState));
			//if (iOrderState == 2) format(string,sizeof(string), "%s {DDDDDD}(Truck Distance: %d)");
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			format(string,sizeof(string), "This order was submitted by %s", Businesses[iBusinessID][bOrderBy]);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			if (iOrderState == 1) SendClientMessageEx(playerid, COLOR_YELLOW, "You can use /cancelresupply to cancel this order.");
		}
	}
	else SendClientMessageEx(playerid, COLOR_GRAD1, "Only authorized business employees may use this command.");
	return 1;
}

CMD:cancelresupply(playerid, params[])
{
	if (PlayerInfo[playerid][pBusiness] == INVALID_BUSINESS_ID)	{
		return SendClientMessageEx(playerid, COLOR_GREY, "You are not in a business!");
	}
	else if (PlayerInfo[playerid][pBusinessRank] < Businesses[PlayerInfo[playerid][pBusiness]][bMinSupplyRank]) {
		return SendClientMessageEx(playerid, COLOR_GREY, "Your rank is not high enough for cancelling resupply orders!");
	}
	else {
		new orderstate = Businesses[PlayerInfo[playerid][pBusiness]][bOrderState];
		if (orderstate == 0) {
			return SendClientMessageEx(playerid, COLOR_WHITE, "Your business has never placed a resupply order.");
		}
		else if (orderstate == 2) {
		    //foreach(new i : Player)
			for(new i = 0; i < MAX_PLAYERS; ++i)
			{
				if(IsPlayerConnected(i))
				{			
					if(TruckDeliveringTo[GetPlayerVehicleID(i)] == PlayerInfo[playerid][pBusiness])
					{
						SendClientMessageEx(playerid, COLOR_WHITE, "You can't cancel an order while it is being shipped!");
						return 1;
					}
				}	
		    }
		    Businesses[PlayerInfo[playerid][pBusiness]][bSafeBalance] += floatround(Businesses[PlayerInfo[playerid][pBusiness]][bOrderAmount] * BUSINESS_ITEMS_COST);
		    Businesses[PlayerInfo[playerid][pBusiness]][bOrderState] = 4;
			SaveBusiness(PlayerInfo[playerid][pBusiness]);
			new string[128];
			format(string, sizeof(string), "%s(%d) (IP: %s) has cancelled the resupply order for %s (%d)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), Businesses[PlayerInfo[playerid][pBusiness]][bName], PlayerInfo[playerid][pBusiness]);
			Log("logs/business.log", string);
			format(string, sizeof(string), "You have cancelled your resupply order! A refund of $%s has been given.", number_format(floatround(Businesses[PlayerInfo[playerid][pBusiness]][bOrderAmount] * (BUSINESS_ITEMS_COST * 0.8))));
			return SendClientMessageEx(playerid, COLOR_WHITE, string);

		}
		else if (orderstate == 1) {
		    Businesses[PlayerInfo[playerid][pBusiness]][bSafeBalance] += floatround(Businesses[PlayerInfo[playerid][pBusiness]][bOrderAmount] * BUSINESS_ITEMS_COST);
		    Businesses[PlayerInfo[playerid][pBusiness]][bOrderState] = 4;
			SaveBusiness(PlayerInfo[playerid][pBusiness]);
			new string[128];
			format(string, sizeof(string), "%s(%d) (IP: %s) has cancelled the resupply order for %s (%d)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), Businesses[PlayerInfo[playerid][pBusiness]][bName], PlayerInfo[playerid][pBusiness]);
			Log("logs/business.log", string);
			format(string, sizeof(string), "You have cancelled your resupply order! A refund of $%s has been given.", number_format(floatround(Businesses[PlayerInfo[playerid][pBusiness]][bOrderAmount] * (BUSINESS_ITEMS_COST * 0.8))));
			return SendClientMessageEx(playerid, COLOR_WHITE, string);
		}
	}
	return 1;
}

CMD:minrank(playerid, params[])
{
	new rank, command[32];
	if (PlayerInfo[playerid][pBusiness] == INVALID_BUSINESS_ID || PlayerInfo[playerid][pBusinessRank] < 5)
	{
		return SendClientMessageEx(playerid, COLOR_GREY, "Only business owners can use this command.");
	}
	if (sscanf(params, "ds[32]", rank, command))
	{
		return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /minrank [rank] [invite/giverank/supply]");
	}
	if(rank < 0 || rank > 5)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "Don't go below number 0 or above number 5!");
	}
	if (strcmp(command, "invite", true) == 0) Businesses[PlayerInfo[playerid][pBusiness]][bMinInviteRank] = rank, SaveBusiness(PlayerInfo[playerid][pBusiness]);
	else if (strcmp(command, "giverank", true) == 0) Businesses[PlayerInfo[playerid][pBusiness]][bMinGiveRankRank] = rank, SaveBusiness(PlayerInfo[playerid][pBusiness]);
	else if (strcmp(command, "supply", true) == 0) Businesses[PlayerInfo[playerid][pBusiness]][bMinSupplyRank] = rank, SaveBusiness(PlayerInfo[playerid][pBusiness]);
	else return SendClientMessageEx(playerid, COLOR_GRAD2, "Invalid Permission Name");

	new string[128];
	format(string, sizeof(string), "You have set the minimum rank for %s to %d (%s)", command, rank, GetBusinessRankName(rank));
	SendClientMessageEx(playerid, COLOR_GREY, string);

	return 1;
}

CMD:br(playerid, params[])
{
	return cmd_bizradio(playerid, params);
}

CMD:togbiz(playerid, params[])
{
    if (!IsValidBusinessID(PlayerInfo[playerid][pBusiness])) return SendClientMessageEx(playerid, COLOR_GRAD2, "You're not an Employee of a Business!");
    else if(PlayerInfo[playerid][pBusiness] == INVALID_BUSINESS_ID) return SendClientMessageEx(playerid, COLOR_GRAD2, "You're not an Employee of a Business!");

    if(GetPVarInt(playerid, "BusinessRadio"))
    {
        DeletePVar(playerid, "BusinessRadio");
        SendClientMessageEx(playerid, COLOR_WHITE, "You have enabled business radio.");
    }
    else
    {
        SetPVarInt(playerid, "BusinessRadio", 1);
        SendClientMessageEx(playerid, COLOR_WHITE, "You have disabled business radio.");
    }
	return 1;
}

CMD:bizradio(playerid, params[])
{

	if(PlayerInfo[playerid][pJailTime] && strfind(PlayerInfo[playerid][pPrisonReason], "[OOC]", true) != -1) return SendClientMessageEx(playerid, COLOR_GREY, "OOC prisoners are restricted to only speak in /b");
	new
		string[128],
		iBusinessID = PlayerInfo[playerid][pBusiness],
		iRank = PlayerInfo[playerid][pBusinessRank];

	if (!IsValidBusinessID(iBusinessID)) return SendClientMessageEx(playerid, COLOR_GRAD2, "You're not an employee of a business!");
	else if(iBusinessID == INVALID_BUSINESS_ID) return SendClientMessageEx(playerid, COLOR_GRAD2, "You're not an employee of a business!");
	if(PlayerTied[playerid] != 0 || PlayerCuffed[playerid] != 0 || PlayerInfo[playerid][pJailTime] > 0 || GetPVarInt(playerid, "Injured")) return SendClientMessageEx(playerid, COLOR_GRAD2, "You cannot do this at this time.");
	if(isnull(params)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /b(iz)r(radio) [biz chat]");

	format(string, sizeof(string), "(radio) %s", params);
	SetPlayerChatBubble(playerid,string,COLOR_WHITE,15.0,5000);
	format(string, sizeof(string), "** (%d) %s %s: %s **", iRank, GetBusinessRankName(iRank), GetPlayerNameEx(playerid), params);
	//foreach(new i: Player) {
	for(new i = 0; i < MAX_PLAYERS; ++i)
	{
		if(IsPlayerConnected(i))
		{
			if (PlayerInfo[i][pBusiness] == iBusinessID && GetPVarInt(i, "BusinessRadio") != 1) SendClientMessageEx(i, COLOR_BR, string);
		}	
	}

	return 1;
}

CMD:employeepayset(playerid, params[])
{
	if (PlayerInfo[playerid][pBusiness] == INVALID_BUSINESS_ID || PlayerInfo[playerid][pBusinessRank] != 5)
	{
		return SendClientMessageEx(playerid, COLOR_GREY, "Not authorized to use this command!");
	}
	new rank, amount;
	if (sscanf(params, "dd", rank, amount))
	{
	    SendClientMessageEx(playerid, COLOR_RED, "Listing current paycheck amounts...");
	    for (new i, string[64]; i < 5; i++) {
	        format(string,sizeof(string), "Rank %d (%s): $%s", i, GetBusinessRankName(i), number_format(Businesses[PlayerInfo[playerid][pBusiness]][bRankPay][i]));
		    SendClientMessageEx(playerid, COLOR_WHITE, string);
	    }
		return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /employeepayset [rank] [amount]");
	}
	if (rank < 0 || rank > 4)
	{
		return SendClientMessageEx(playerid, COLOR_WHITE, "Invalid rank entered!");
   	}
	if (amount < 1 || amount > 100000)
	{
		return SendClientMessageEx(playerid, COLOR_WHITE, "Amount can't be lower than $1 or higher than $100,000!");
    }

	Businesses[PlayerInfo[playerid][pBusiness]][bRankPay][rank] = amount;
	SaveBusiness(PlayerInfo[playerid][pBusiness]);
    new string[128];
    format(string, sizeof(string), "You have set paycheck amount for rank %d (%s) to $%s", rank, GetBusinessRankName(rank), number_format(amount));
	SendClientMessageEx(playerid, COLOR_WHITE, string);
	format(string,sizeof(string),"%s(%d) has changed paycheck of rank %d to $%s for business %d", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), rank, number_format(amount), PlayerInfo[playerid][pBusiness]);
	Log("logs/business.log", string);

	return 1;
}


CMD:employeeautopay(playerid, params[])
{
	if (PlayerInfo[playerid][pBusiness] == INVALID_BUSINESS_ID || PlayerInfo[playerid][pBusinessRank] != 5)
	{
		return SendClientMessageEx(playerid, COLOR_GREY, "Not authorized to use this command!");
	}
	if (Businesses[PlayerInfo[playerid][pBusiness]][bAutoPay])
	{
		Businesses[PlayerInfo[playerid][pBusiness]][bAutoPay] = 0;
		SendClientMessageEx(playerid, COLOR_WHITE, "You have disabled paychecks for the business.");
		SaveBusiness(PlayerInfo[playerid][pBusiness]);
		return 1;
	}
 	else
	{
		Businesses[PlayerInfo[playerid][pBusiness]][bAutoPay] = 1;
		SendClientMessageEx(playerid, COLOR_WHITE, "You have enabled paychecks for the business.");
		SaveBusiness(PlayerInfo[playerid][pBusiness]);
		return 1;
	}
}

CMD:editgasprice(playerid, params[])
{
	if (PlayerInfo[playerid][pBusiness] != INVALID_BUSINESS_ID && PlayerInfo[playerid][pBusinessRank] >= 5 && IsBusinessGasAble(Businesses[PlayerInfo[playerid][pBusiness]][bType]))
	{
		ShowPlayerDialog(playerid, DIALOG_GASPRICE, DIALOG_STYLE_INPUT, "Edit Gas Price", "Enter the new price per 1 gallon (e.g. 4.52)", "OK", "Cancel");
		SetPVarInt(playerid, "EditingBusiness", PlayerInfo[playerid][pBusiness]);
	}
	else SendClientMessageEx(playerid, COLOR_GREY, "Your are not the owner of a gas station!");
	return 1;
}

CMD:editprices(playerid, params[])
{
	new
		iBusiness = PlayerInfo[playerid][pBusiness];

	if (iBusiness != INVALID_BUSINESS_ID)
	{
	    if(PlayerInfo[playerid][pBusinessRank] >= 5)
		{
			if(Businesses[iBusiness][bType] == BUSINESS_TYPE_STORE || Businesses[iBusiness][bType] == BUSINESS_TYPE_GASSTATION) {
	    		new szDialog[912];
				for (new i = 0; i < sizeof(StoreItems); i++) format(szDialog, sizeof(szDialog), "%s%s  ($%s) (Cost of Good: $%s)\n", szDialog, StoreItems[i], number_format(Businesses[iBusiness][bItemPrices][i]), number_format(floatround(StoreItemCost[i][ItemValue] * BUSINESS_ITEMS_COST)) );
				ShowPlayerDialog(playerid, DIALOG_STOREPRICES, DIALOG_STYLE_LIST, "Edit 24/7 Prices", szDialog, "Edit", "Cancel");
				SetPVarInt(playerid, "EditingBusiness", iBusiness);
			}

		    else if(Businesses[iBusiness][bType] == BUSINESS_TYPE_CLOTHING) {
		    	ShowPlayerDialog(playerid, DIALOG_STORECLOTHINGPRICE, DIALOG_STYLE_INPUT, "Edit Price", "{FFFFFF}Enter the new sale price for clothing\n(Items with the price of $0 will not be for sale)", "Okay", "Cancel");
                SetPVarInt(playerid, "EditingBusiness", iBusiness);
			}
			else if(Businesses[iBusiness][bType] == BUSINESS_TYPE_GUNSHOP) {
			    new szDialog[512];
				for (new i = 0; i < sizeof(Weapons); i++) format(szDialog, sizeof(szDialog), "%s%s  ($%s)\n", szDialog, GetWeaponNameEx(Weapons[i][WeaponId]), number_format(Businesses[iBusiness][bItemPrices][i]));
				ShowPlayerDialog(playerid, DIALOG_GUNPRICES, DIALOG_STYLE_LIST, "Edit Weapon Prices", szDialog, "Edit", "Cancel");
				SetPVarInt(playerid, "EditingBusiness", iBusiness);
			}
			else if(Businesses[iBusiness][bType] == BUSINESS_TYPE_BAR || Businesses[iBusiness][bType] == BUSINESS_TYPE_CLUB /*|| Businesses[iBusiness][bType] == BUSINESS_TYPE_RESTAURANT*/)
			{
			    new szDialog[512];
				for (new i; i < sizeof(Drinks); i++) format(szDialog, sizeof(szDialog), "%s%s  ($%s)\n", szDialog, Drinks[i], number_format(Businesses[iBusiness][bItemPrices][i]));
				ShowPlayerDialog(playerid, DIALOG_BARPRICE, DIALOG_STYLE_LIST, "Edit Business Prices", szDialog, "Edit", "Cancel");
				SetPVarInt(playerid, "EditingBusiness", iBusiness);
			}
			else if(Businesses[iBusiness][bType] == BUSINESS_TYPE_SEXSHOP)
			{
			    new szDialog[512];
				for (new i = 0; i < sizeof(SexItems); i++) format(szDialog, sizeof(szDialog), "%s%s  ($%s)\n", szDialog, SexItems[i], number_format(Businesses[iBusiness][bItemPrices][i]));
				ShowPlayerDialog(playerid, DIALOG_SEXSHOP, DIALOG_STYLE_LIST, "Edit Business Prices", szDialog, "Edit", "Cancel");
				SetPVarInt(playerid, "EditingBusiness", iBusiness);
			}
			else if (Businesses[iBusiness][bType] == BUSINESS_TYPE_RESTAURANT)
			{
				new buf[512];
				for (new i = 0; i < sizeof(RestaurantItems); ++i)
				{
					format(buf, sizeof(buf), "%s%s  ($%s)\n", buf, RestaurantItems[i], number_format(Businesses[iBusiness][bItemPrices][i]));
				}

				ShowPlayerDialog(playerid, DIALOG_RESTAURANT, DIALOG_STYLE_LIST, "Edit Business Prices", buf, "Edit", "Cancel");
				SetPVarInt(playerid, "EditingBusiness", iBusiness);
			}
		}
		else
		{
		    SendClientMessageEx(playerid, COLOR_GREY, "You aren't a store owner.");
		    return 1;
		}
	}
	else
	{
	    SendClientMessageEx(playerid, COLOR_WHITE, "You are not a store owner.");
	}
	return 1;
}

CMD:bizlock(playerid, params[])
{
	if(PlayerInfo[playerid][pBusiness] != INVALID_BUSINESS_ID && PlayerInfo[playerid][pBusinessRank] >= Businesses[PlayerInfo[playerid][pBusiness]][bMinDoorRank] &&
	IsPlayerInRangeOfPoint(playerid, 2.0, Businesses[PlayerInfo[playerid][pBusiness]][bExtPos][0], Businesses[PlayerInfo[playerid][pBusiness]][bExtPos][1], Businesses[PlayerInfo[playerid][pBusiness]][bExtPos][2]))
	{
		if(Businesses[PlayerInfo[playerid][pBusiness]][bStatus] == 1)
		{
			Businesses[PlayerInfo[playerid][pBusiness]][bStatus] = 0;
			new string[MAX_PLAYER_NAME + 28];
			format(string, sizeof(string), "* %s has locked the door.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		}
		else
		{
			Businesses[PlayerInfo[playerid][pBusiness]][bStatus] = 1;
			new string[MAX_PLAYER_NAME + 28];
			format(string, sizeof(string), "* %s has unlocked the door.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		}
		RefreshBusinessPickup(PlayerInfo[playerid][pBusiness]);
		Streamer_UpdateEx(playerid, Businesses[PlayerInfo[playerid][pBusiness]][bExtPos][0], Businesses[PlayerInfo[playerid][pBusiness]][bExtPos][1], Businesses[PlayerInfo[playerid][pBusiness]][bExtPos][2]);
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You are not near your business or not authorized.");
		return 1;
	}
	return 1;
}
