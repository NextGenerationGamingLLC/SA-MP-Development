/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

				  Accept / Cancel Commands

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

CMD:accept(playerid, params[])
{
	if(restarting) return SendClientMessageEx(playerid, COLOR_GRAD2, "Transactions are currently disabled due to the server being restarted for maintenance.");
	new szMessage[256];
	new string[128];
	new sendername[MAX_PLAYER_NAME];
	new giveplayer[MAX_PLAYER_NAME];
	new giveplayerid;
	if(HungerPlayerInfo[playerid][hgInEvent] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "   You cannot do this while being in the Hunger Games Event!");
    if(IsPlayerConnected(playerid)) {
        if(isnull(params)) {
            SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /accept [name]");
            SendClientMessageEx(playerid, COLOR_GREY, "Available names: Sex, Mats, Crack, Cannabis, Weapon, Craft, Repair, Lawyer, Bodyguard, Job, Live, Refill");
            SendClientMessageEx(playerid, COLOR_GREY, "Available names: Firework, Group, Boxing, Medic, Mechanic, Ticket, Car, Death, Backpack");
            SendClientMessageEx(playerid, COLOR_GREY, "Available names: Business, Item, Offer, Heroin, Rawopium, Syringes, Rimkit, Voucher, Kiss, RenderAid, Frisk");
            return 1;
        }
		if(strcmp(params, "door", true) == 0)
		{
			new target, fine, count;
			target = INVALID_PLAYER_ID;
			foreach(new i: Player)
			{
				if(gPlayerLogged{i} == 1 && DDSalePendingAdmin[i] == false && DDSalePendingPlayer[i] == true && DDSaleTarget[i] == playerid)
				{
					target = i;
					count ++;
					if(count > 1) break;
				}
			}
			if(target == INVALID_PLAYER_ID) return SendClientMessageEx(playerid, COLOR_GREY, "You do not have an active dynamic door sale offer.");
			if(count > 1)
			{
				foreach(new i : Player) if(gPlayerLogged{i} == 1 && DDSaleTarget[i] == playerid) ClearDoorSaleVariables(i);
				SendClientMessageEx(playerid, COLOR_GREY, "An error occurred, please try making your transaction again.");
				return 1;
			}
			if(GetPlayerCash(playerid) < DDSalePrice[target])
			{
				format(string, sizeof(string), "You do not have enough money for this transaction ($%s).", number_format(DDSalePrice[target]));
				SendClientMessageEx(playerid, COLOR_GREY, string);
				return 1;
			}
			fine = CalculatePercentage(DDSalePrice[target], 10, 1000000);
			if(GetPlayerCash(target) < fine)
			{
				format(string, sizeof(string), "%s does not have the sufficient funds for the transfer fine ($%s).", GetPlayerNameEx(target), number_format(fine));
				SendClientMessageEx(playerid, COLOR_GREY, string);
				return 1;
			}
			stop DDSaleTimer[target];
			DDSalePendingAdmin[target] = true;
			DDSalePendingPlayer[target] = false;
			format(string, sizeof(string), "You have accepted %s's dynamic door sale offer for $%s.", GetPlayerNameEx(target), number_format(DDSalePrice[target]));
			SendClientMessageEx(playerid, COLOR_GREEN, string);
			SendClientMessageEx(playerid, COLOR_GREEN, "Server administration will now review the request before it is processed.");
			format(string, sizeof(string), "%s accepted your dynamic door sale offer for $%s.", GetPlayerNameEx(playerid), number_format(DDSalePrice[target]));
			SendClientMessageEx(target, COLOR_GREEN, string);
			SendClientMessageEx(target, COLOR_GREEN, "Server administration will now review the request before it is processed.");
			format(string, sizeof(string), "[New Dynamic Door Sale Request]: (ID: %d) %s.", target, GetPlayerNameEx(target));
			ABroadCast(COLOR_LIGHTRED, string, 4);
			return 1;
		}
		else if(strcmp(params, "renderaid", true) == 0)
		{
			if(!GetPVarType(playerid, "Injured")) return SendClientMessageEx(playerid, COLOR_GRAD2, "You are not in a injured state.");
			if(!GetPVarType(playerid, "renderaid")) return SendClientMessageEx(playerid, COLOR_GRAD2, "No one has offered you assistance!");
			new target = GetPVarInt(playerid, "renderaid");
			if(!IsPlayerConnected(target)) return SendClientMessageEx(playerid, COLOR_GRAD2, "The person who offered you assistance is no longer online.");
			new Float:pos[3];
			GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
			if(!IsPlayerInRangeOfPoint(target, 5.0, pos[0], pos[1], pos[2])) return SendClientMessageEx(playerid, COLOR_GRAD2, "You are not near the person who offered you assistance.");
			if(GetPVarInt(target, "MedVestKit") != 1)
				return SendClientMessageEx(target, COLOR_GRAD2, "You aren't carrying a kit."), SendClientMessageEx(playerid, COLOR_GRAD2, "The player was unable to assist you as they no longer have a med kit.");
			ApplyAnimation(target, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0, 1);
			SetHealth(playerid, 100);
			format(string, sizeof(string), "{FF8000}** {C2A2DA}%s renders aid to %s.", GetPlayerNameEx(target), GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			DeletePVar(playerid, "renderaid");
			DeletePVar(target, "MedVestKit");
		}
		else if(strcmp(params, "weapon", true) == 0)
		{
			if(!GetPVarType(playerid, "pSellGunID") || GetPVarInt(playerid, "pSellGunID") == INVALID_PLAYER_ID) return SendClientMessageEx(playerid, COLOR_GRAD2, "No one has offered you a gun!");

			new id = GetPVarInt(playerid, "pSellGunID");

			if(PlayerInfo[id][pMats] < GetPVarInt(playerid, "pSellGunMats")) 
			{
				SendClientMessage(id, COLOR_WHITE, "You do not have enough materials to sell this item!");
				return SendClientMessage(playerid, COLOR_WHITE, "The seller no longer has enough materials to sell this item!");
			}

			new weapon[16];
			GetWeaponName(GetPVarInt(playerid, "pSellGun"), weapon, sizeof(weapon));

			PlayerInfo[id][pMats] -= GetPVarInt(playerid, "pSellGunMats");
			GivePlayerValidWeapon(playerid, GetPVarInt(playerid, "pSellGun"));

  			if(PlayerInfo[id][pDoubleEXP] > 0)
			{
				SendClientMessageEx(id, COLOR_YELLOW, "You have gained 2 skill points instead of 1. You have %d hours left on the Double EXP token.", PlayerInfo[id][pDoubleEXP]);
   				PlayerInfo[id][pArmsSkill] += (GetPVarInt(playerid, "pSellGunXP")*2);
			}
			else
			{
  				PlayerInfo[id][pArmsSkill] += GetPVarInt(playerid, "pSellGunXP");
			}

			format(szMiscArray, sizeof(szMiscArray), "%s crafts a %s from their materials, handing it to %s.", GetPlayerNameEx(id), weapon, GetPlayerNameEx(playerid)); 
			ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0); // Just a little 'classic' feel to it. -Winterfield
			PlayerPlaySound(id, 1052, 0.0, 0.0, 0.0);

			DeletePVar(playerid, "pSellGun");
			DeletePVar(playerid, "pSellGunID");
			DeletePVar(playerid, "pSellGunMats");
			DeletePVar(playerid, "pSellGunXP");
		}
        else if(strcmp(params, "valentine", true) == 0)
		{
	        if (!GetPVarType(playerid, "kissvaloffer")) {
       	 		return SendClientMessageEx(playerid, COLOR_GREY, "No one has offered you a valentine!");
			}
			if (GetPVarInt(playerid,"kissvalsqlid") != GetPlayerSQLId(GetPVarInt(playerid, "kissvaloffer"))) {
				return SendClientMessageEx(playerid, COLOR_GREY, "Inviter has disconnected.");
			}
			new Float: ppFloats[3], targetid;
			targetid = GetPVarInt(playerid, "kissvaloffer");
			GetPlayerPos(targetid, ppFloats[0], ppFloats[1], ppFloats[2]);

			if(!IsPlayerInRangeOfPoint(playerid, 2, ppFloats[0], ppFloats[1], ppFloats[2]) || Spectating[targetid] > 0)
			{
				SendClientMessageEx(playerid, COLOR_GREY, "You're too far away!");
				DeletePVar(playerid, "kissvaloffer");
	      		DeletePVar(playerid, "kissvalsqlid");
				DeletePVar(targetid, "kissvalstyle");
				return 1;
			}
			if(PlayerInfo[playerid][pGiftTime] > 0)
			{
				format(string, sizeof(string),"Item: Reset Gift Timer\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[17][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[17][sItemPrice]));
				ShowPlayerDialogEx( playerid, DIALOG_SHOPGIFTRESET, DIALOG_STYLE_MSGBOX, "Reset Gift Timer", string, "Purchase", "Exit" );
				SendClientMessageEx(playerid, COLOR_GRAD2, "You have already received a gift in the last 5 hours!");
				SendClientMessageEx(targetid, COLOR_GRAD2, "Your requested valentine cannot accept.");
				DeletePVar(playerid, "kissvaloffer");
	      		DeletePVar(playerid, "kissvalsqlid");
				DeletePVar(targetid, "kissvalstyle");
				return 1;
			}
			else if(PlayerInfo[targetid][pGiftTime] > 0)
			{
				SendClientMessageEx(playerid, COLOR_GRAD2, "That player has already received a gift in the last 5 hours!");
				DeletePVar(playerid, "kissvaloffer");
	      		DeletePVar(playerid, "kissvalsqlid");
				DeletePVar(targetid, "kissvalstyle");
				return 1;
			}
			ClearAnimationsEx(playerid);
			ClearAnimationsEx(targetid);
			PlayerFacePlayer( playerid, targetid );
			switch(GetPVarInt(targetid,"kissvalstyle")) {
				case 1:
				{
					ApplyAnimation( playerid, "KISSING", "Playa_Kiss_01", 4.1, 0, 0, 0, 0, 0, 1);
					ApplyAnimation( targetid, "KISSING", "Playa_Kiss_01", 4.1, 0, 0, 0, 0, 0, 1);
				}
				case 2:
				{
					ApplyAnimation( playerid, "KISSING", "Playa_Kiss_02", 4.1, 0, 0, 0, 0, 0, 1);
					ApplyAnimation( targetid, "KISSING", "Playa_Kiss_02", 4.1, 0, 0, 0, 0, 0, 1);
				}
				case 3:
				{
					ApplyAnimation( playerid, "KISSING", "Playa_Kiss_03", 4.1, 0, 0, 0, 0, 0, 1);
					ApplyAnimation( targetid, "KISSING", "Playa_Kiss_03", 4.1, 0, 0, 0, 0, 0, 1);
				}
				case 4:
				{
					ApplyAnimation( playerid, "KISSING", "Grlfrd_Kiss_01", 4.1, 0, 0, 0, 0, 0, 1);
					ApplyAnimation( targetid, "KISSING", "Grlfrd_Kiss_01", 4.1, 0, 0, 0, 0, 0, 1);
				}
				case 5:
				{
					ApplyAnimation( playerid, "KISSING", "Grlfrd_Kiss_02", 4.1, 0, 0, 0, 0, 0, 1);
					ApplyAnimation( targetid, "KISSING", "Grlfrd_Kiss_02", 4.1, 0, 0, 0, 0, 0, 1);
				}
				case 6:
				{
					ApplyAnimation( playerid, "KISSING", "Grlfrd_Kiss_03", 4.1, 0, 0, 0, 0, 0, 1);
					ApplyAnimation( targetid, "KISSING", "Grlfrd_Kiss_03", 4.1, 0, 0, 0, 0, 0, 1);
				}
			}
			format(string, sizeof(string), "* %s has given %s a kiss.", GetPlayerNameEx(playerid), GetPlayerNameEx(targetid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			GiftPlayer(MAX_PLAYERS, playerid);
			GiftPlayer(MAX_PLAYERS, targetid);
   			DeletePVar(playerid, "kissvaloffer");
      		DeletePVar(playerid, "kissvalsqlid");
			DeletePVar(targetid, "kissvalstyle");
   		}
		else if(strcmp(params, "business", true) == 0)
		{
	        if (!GetPVarType(playerid, "Business_Inviter")) {
       	 		return SendClientMessageEx(playerid, COLOR_GREY, "No one has invited you to join a business!");
			}
			if (PlayerInfo[playerid][pBusiness] != INVALID_BUSINESS_ID) {
				return SendClientMessageEx(playerid, COLOR_GREY, "You are already in another business. You must first resign before accepting this offer.");
			}
			if (GetPVarInt(playerid,"Business_InviterSQLId") != GetPlayerSQLId(GetPVarInt(playerid, "Business_Inviter"))) {
				return SendClientMessageEx(playerid, COLOR_GREY, "Inviter has disconnected.");
			}
			PlayerInfo[playerid][pBusiness] = GetPVarInt(playerid, "Business_Invited");
			PlayerInfo[playerid][pBusinessRank] = 0;
            format(string, sizeof(string), "* You have accepted the invitation and joined %s, you were invited by %s.", Businesses[GetPVarInt(playerid, "Business_Invited")][bName], GetPlayerNameEx(GetPVarInt(playerid, "Business_Inviter")));
            SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
            format(string, sizeof(string), "* %s has accepted your invitation and joined %s", GetPlayerNameEx(playerid),Businesses[GetPVarInt(playerid, "Business_Invited")][bName]);
            SendClientMessageEx(GetPVarInt(playerid, "Business_Inviter"), COLOR_LIGHTBLUE, string);
			format(string, sizeof(string), "%s(%d) has accepted %s's(%d) invite to join %s", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerNameEx(GetPVarInt(playerid, "Business_Inviter")), GetPlayerSQLId(GetPVarInt(playerid, "Business_Inviter")), Businesses[GetPVarInt(playerid, "Business_Invited")][bName]);
			Log("logs/business.log", string);
   			DeletePVar(playerid, "Business_Inviter");
      		DeletePVar(playerid, "Business_Invited");
   		}
        else if(strcmp(params, "gun", true) == 0)
		{
			if (!GetPVarType(playerid, "Business_WeapOfferer"))	{
		        return SendClientMessageEx(playerid, COLOR_GREY, "No one has offered you a weapon!");
			}
		    new offerer = GetPVarInt(playerid, "Business_WeapOfferer"), business = PlayerInfo[offerer][pBusiness];
			if (GetPlayerSQLId(offerer) != GetPVarInt(playerid, "Business_WeapOffererSQLId")) {
   				return SendClientMessage(playerid, COLOR_GRAD2, "The offerer has disconnected!");
			}
            if(!ProxDetectorS(5.0, playerid, offerer)) {
       	        SendClientMessageEx(playerid, COLOR_GREY, "The seller is not near you!");
       	        return 1;
            }
		    if(GetPVarType(playerid, "IsInArena")) {
				SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this while being in an arena!");
				return 1;
			}
		    if (GetPlayerCash(playerid) < GetPVarInt(playerid, "Business_WeapPrice")) {
			    SendClientMessageEx(playerid, COLOR_GREY, "You can't afford the weapon");
			    return 1;
		    }
		    if (Businesses[business][bInventory] < GetWeaponParam(GetPVarInt(playerid, "Business_WeapType"), WeaponMats)) {
				SendClientMessage(playerid, COLOR_GRAD2, "Shop doesnt have mats anymore");
				return 1;
		    }
			if(GetPVarType(playerid, "PlayerCuffed") || GetPVarInt(playerid, "pBagged") >= 1 || GetPVarType(playerid, "Injured") || GetPVarType(playerid, "IsFrozen")) {
   				SendClientMessage(playerid, COLOR_GRAD2, "You can't do that at this time!");
   				return 1;
			}

		    Businesses[business][bTotalSales]++;
		    Businesses[business][bLevelProgress]++;
		    Businesses[business][bSafeBalance] += TaxSale(GetPVarInt(playerid, "Business_WeapPrice"));
  			GivePlayerCash(playerid, -GetPVarInt(playerid, "Business_WeapPrice"));
		    Businesses[business][bInventory] -= GetWeaponParam(GetPVarInt(playerid, "Business_WeapType"), WeaponMats);
		    SaveBusiness(business);

            format(string, sizeof(string), "   You have sold %s a %s.", GetPlayerNameEx(playerid),Weapon_ReturnName(GetPVarInt(playerid, "Business_WeapType")));
            SendClientMessageEx(offerer, COLOR_GRAD1, string);
            format(string, sizeof(string), "   You have recieved a %s from %s.", Weapon_ReturnName(GetPVarInt(playerid, "Business_WeapType")), GetPlayerNameEx(offerer));
            SendClientMessageEx(playerid, COLOR_GRAD1, string);
            PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
            PlayerPlaySound(offerer, 1052, 0.0, 0.0, 0.0);
            format(string, sizeof(string), "* %s creates a gun from materials and sells it to %s.", GetPlayerNameEx(offerer), GetPlayerNameEx(playerid));
            ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
            GivePlayerValidWeapon(playerid,GetPVarInt(playerid, "Business_WeapType"));

			format(string, sizeof(string), "%s %s(%d) (IP: %s) has sold a %s to %s(%d) (IP: %s) for $%d in %s (%d)", GetBusinessRankName(PlayerInfo[offerer][pBusinessRank]), GetPlayerNameEx(offerer), GetPlayerSQLId(offerer), GetPlayerIpEx(offerer), Weapon_ReturnName(GetPVarInt(playerid, "Business_WeapType")), GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), GetPVarInt(playerid, "Business_WeapPrice"), Businesses[business][bName], business);
			Log("logs/business.log", string);

  		    DeletePVar(playerid, "Business_WeapPrice");
		    DeletePVar(playerid, "Business_WeapType");
		    DeletePVar(playerid, "Business_WeapOfferer");
		    DeletePVar(playerid, "Business_WeapOffererSQLId");
		}

        else if(strcmp(params, "item", true) == 0) {

			if (!GetPVarType(playerid, "Business_ItemOfferer")) {
		        SendClientMessageEx(playerid, COLOR_GREY, "No one has offered you a item!");
		        return 1;
			}

		    new offerer = GetPVarInt(playerid, "Business_ItemOfferer");
		    new item = GetPVarInt(playerid, "Business_ItemType");
		    new price = GetPVarInt(playerid, "Business_ItemPrice");
			new business = InBusiness(playerid);

			if (business == INVALID_BUSINESS_ID)
			{
				SendClientMessage(playerid, COLOR_GRAD2, "You are not in the business interior");
   				return 1;
			}
			if (GetPlayerSQLId(offerer) != GetPVarInt(playerid, "Business_ItemOffererSQLId")) {
   				SendClientMessage(playerid, COLOR_GRAD2, "The offerer has disconnected!");
   				return 1;
			}
		    if (GetPlayerCash(playerid) < price) {
			    SendClientMessageEx(playerid, COLOR_GREY, "You can't afford the item!");
			    return 1;
		    }
			if (!Businesses[business][bItemPrices][item]) {
			    SendClientMessageEx(playerid, COLOR_GRAD4, "Item is not for sale anymore.");
			    return 1;
			}
		 	if (Businesses[business][bInventory] < 1) {
	   	 		SendClientMessageEx(playerid, COLOR_GRAD2, "Store does not have any items anymore!");
	   	 		return 1;
			}
			if (GetPVarInt(playerid, "Business_ItemPrice") != Businesses[business][bItemPrices][item]) {
			    SendClientMessageEx(playerid, COLOR_GRAD4, "Purchase failed because the price for this item has changed.");
			    return 1;
			}

			if(item == ITEM_ILOCK || item == ITEM_SCALARM || item == ITEM_ELOCK)
   			{
      			if(Businesses[business][bInventory] >= StoreItemCost[item][ItemValue])
	        	{

					SetPVarInt(playerid, "lockcost", price);
     				SetPVarInt(playerid, "businessid", business);
	        		SetPVarInt(playerid, "item", item);
		        	SetPVarInt(playerid, "playersold", item);
			        GivePlayerStoreItem(playerid, 1, business, item+1, price);
				}
				else return SendClientMessageEx(playerid, COLOR_GRAD2, "The store does not have enough stock for that item!");
    		}
  			else GivePlayerStoreItem(playerid, 1, business, item+1, price);
		}


        else if(strcmp(params, "vehicle", true) == 0) {

		    new offerer = GetPVarInt(playerid, "Business_VehicleOfferer");
		    new price = GetPVarInt(playerid, "Business_VehiclePrice");
		    new slot = GetPVarInt(playerid, "Business_VehicleSlot");
		    new businessid = PlayerInfo[offerer][pBusiness];

			if (!GetPVarType(playerid, "Business_VehicleOfferer")) {
		        SendClientMessageEx(playerid, COLOR_GREY, "No one has offered you a vehicle!");
		        return 1;
			}

			if (GetPlayerSQLId(offerer) != GetPVarInt(playerid, "Business_VehicleOffererSQLId")) {
   				SendClientMessage(playerid, COLOR_GRAD2, "The offerer has disconnected!");
   				return 1;
			}
		    if (GetPlayerCash(playerid) < price) {
			    SendClientMessageEx(playerid, COLOR_GREY, "You can't afford the vehicle!");
			    return 1;
		    }

            new playervehicleid = GetPlayerFreeVehicleId(playerid);

			if(!vehicleCountCheck(playerid)) {
				return SendClientMessage(playerid, COLOR_GRAD2, "You can't own any more vehicles.");
			}
			if(!vehicleSpawnCountCheck(playerid)) {
				return SendClientMessage(playerid, COLOR_GRAD2, "You have too many vehicles spawned - store one first.");
			}
            PlayerVehicleInfo[playerid][playervehicleid][pvId] = Businesses[businessid][bVehID][slot];
            PlayerVehicleInfo[playerid][playervehicleid][pvModelId] = Businesses[businessid][bModel][slot];
            PlayerVehicleInfo[playerid][playervehicleid][pvPosX] = Businesses[businessid][bParkPosX][slot];
            PlayerVehicleInfo[playerid][playervehicleid][pvPosY] = Businesses[businessid][bParkPosY][slot];
            PlayerVehicleInfo[playerid][playervehicleid][pvPosZ] = Businesses[businessid][bParkPosZ][slot];
            PlayerVehicleInfo[playerid][playervehicleid][pvPosAngle] = Businesses[businessid][bParkAngle][slot];
            PlayerVehicleInfo[playerid][playervehicleid][pvSpawned] = 1;
            Businesses[businessid][DealershipVehStock][slot] = 0;
            VehicleSpawned[playerid]++;

		    g_mysql_SaveVehicle(playerid, playervehicleid);

    		Businesses[businessid][bSafeBalance] += TaxSale(GetPVarInt(playerid, "Business_ItemPrice"));
			GivePlayerCash(playerid, -GetPVarInt(playerid, "Business_VehiclePrice"));
			if (PlayerInfo[playerid][pBusiness] != PlayerInfo[offerer][pBusiness]) Businesses[businessid][bLevelProgress]++;
			SaveBusiness(businessid);
			OnPlayerStatsUpdate(playerid);
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);

			DeletePVar(playerid, "Business_VehiclePrice");
			DeletePVar(playerid, "Business_VehicleOfferer");
			DeletePVar(playerid, "Business_VehicleOffererSQLId");
			DeletePVar(playerid, "Business_VehicleSlot");
        }
        else if(strcmp(params, "death", true) == 0) {
            if(GetPVarInt(playerid, "Injured") == 1) {

            	if(GetPVarInt(playerid, "InjuredWait") > gettime())
            		return SendClientMessageEx(playerid, COLOR_GRAD2, "Please wait 5 seconds before accepting death.");

                SendClientMessageEx(playerid, COLOR_WHITE, "You gave up hope and fell unconscious, you were immediately sent to the hospital.");
                KillEMSQueue(playerid);
                ResetPlayerWeaponsEx(playerid);
                SpawnPlayer(playerid);
            }
            else SendClientMessageEx(playerid, COLOR_GREY, "   You are not injured, you can't do this right now!");
        }
        else if(strcmp(params, "car", true) == 0) {
            if(VehicleOffer[playerid] != INVALID_PLAYER_ID) {
                if(IsPlayerConnected(VehicleOffer[playerid])) {
                    if(GetPlayerCash(playerid) > VehiclePrice[playerid]) {
                        if(IsPlayerInVehicle(VehicleOffer[playerid], PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvId])) {
                            if(!ProxDetectorS(8.0, VehicleOffer[playerid], playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You are not near the car dealer");
                            new playervehicleid = GetPlayerFreeVehicleId(playerid);

			 				if(!vehicleCountCheck(playerid)) {
								return SendClientMessage(playerid, COLOR_GRAD2, "You can't own any more vehicles.");
							}
   							if(!vehicleSpawnCountCheck(playerid)) {
								return SendClientMessage(playerid, COLOR_GRAD2, "You have too many vehicles spawned - store one first.");
							}
							if(PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvBeingPickLocked])
								return SendClientMessage(playerid, COLOR_GRAD2, "There was an error while trying to sell this vehicle.");

                            new ip[32], ipex[32];
                            GetPlayerIp(playerid, ip, sizeof(ip));
                            GetPlayerIp(VehicleOffer[playerid], ipex, sizeof(ipex));
                            format(szMessage, sizeof(szMessage), "[CAR] %s(%d) (IP: %s) has paid $%s to %s(%d) for the %s (IP: %s)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ip, number_format(VehiclePrice[playerid]), GetPlayerNameEx(VehicleOffer[playerid]), GetPlayerSQLId(VehicleOffer[playerid]), GetVehicleName(PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvId]), ipex);
                            Log("logs/pay.log", szMessage);

                            format(szMiscArray, sizeof(szMiscArray), "[CARSALE][$%s] %s(%d) bought a %s from %s(%d)", number_format(VehiclePrice[playerid]), GetPlayerNameEx(playerid), playerid, GetVehicleName(PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvId]), GetPlayerNameEx(VehicleOffer[playerid]), VehicleOffer[playerid]);
                            ABroadCast(COLOR_YELLOW, szMiscArray, 2);

                            GetPlayerName(VehicleOffer[playerid], giveplayer, sizeof(giveplayer));
                            GetPlayerName(playerid, sendername, sizeof(sendername));
                            format(szMessage, sizeof(szMessage), "* You bought the %s for $%s, from %s. (Check /carhelp for more help)", GetVehicleName(PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvId]), number_format(VehiclePrice[playerid]), giveplayer);
                            SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
                            format(szMessage, sizeof(szMessage), "* You sold your %s to %s for $%s.",GetVehicleName(PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvId]), sendername, number_format(VehiclePrice[playerid]));
                            SendClientMessageEx(VehicleOffer[playerid], COLOR_LIGHTBLUE, szMessage);
							GivePlayerCashEx(playerid, TYPE_ONHAND, -VehiclePrice[playerid]);

							if(IsWeaponizedVehicle(PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvModelId]))
							{
								new fine = GetPVarInt(VehicleOffer[playerid], "WepVehSaleFine");
								GivePlayerCashEx(VehicleOffer[playerid], TYPE_ONHAND, VehiclePrice[playerid] - fine);

								format(szMessage, sizeof(szMessage), "* You have been fined %s for this transaction", number_format(fine));
                            	SendClientMessageEx(VehicleOffer[playerid], COLOR_LIGHTBLUE, szMessage);

								DeletePVar(VehicleOffer[playerid], "WepVehSalePlayer");
								DeletePVar(VehicleOffer[playerid], "WepVehSaleVehicle");
								DeletePVar(VehicleOffer[playerid], "WepVehSalePrice");
								DeletePVar(VehicleOffer[playerid], "WepVehSaleFine");
							}
							else GivePlayerCashEx(VehicleOffer[playerid], TYPE_ONHAND, VehiclePrice[playerid]);

                            /*GivePlayerCash( VehicleOffer[playerid], VehiclePrice[playerid] );
                            GivePlayerCash(playerid, -VehiclePrice[playerid]);*/
                            RemovePlayerFromVehicle(VehicleOffer[playerid]);
                            new Float:slx, Float:sly, Float:slz;
                            GetPlayerPos(VehicleOffer[playerid], slx, sly, slz);
                            SetPlayerPos(VehicleOffer[playerid], slx, sly, slz+2);
							if(PlayerInfo[VehicleOffer[playerid]][pBackpack] > 0 && PlayerInfo[VehicleOffer[playerid]][pBStoredV] == PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvSlotId])
							{
								PlayerInfo[VehicleOffer[playerid]][pBackpack] = 0;
								PlayerInfo[VehicleOffer[playerid]][pBEquipped] = 0;
								PlayerInfo[VehicleOffer[playerid]][pBStoredV] = INVALID_PLAYER_VEHICLE_ID;
								PlayerInfo[VehicleOffer[playerid]][pBStoredH] = INVALID_HOUSE_ID;
								SendClientMessageEx(VehicleOffer[playerid], COLOR_WHITE, "You have lost your backpack since you did not withdraw it");

							}
                            PlayerVehicleInfo[playerid][playervehicleid][pvId] = PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvId];
                            PlayerVehicleInfo[playerid][playervehicleid][pvModelId] = PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvModelId];
                            PlayerVehicleInfo[playerid][playervehicleid][pvPosX] = PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvPosX];
                            PlayerVehicleInfo[playerid][playervehicleid][pvPosY] = PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvPosY];
                            PlayerVehicleInfo[playerid][playervehicleid][pvPosZ] = PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvPosZ];
                            PlayerVehicleInfo[playerid][playervehicleid][pvPosAngle] = PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvPosAngle];
                            PlayerVehicleInfo[playerid][playervehicleid][pvLock] = PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvLock];
                            PlayerVehicleInfo[playerid][playervehicleid][pvLocked] = PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvLocked];
                            PlayerVehicleInfo[playerid][playervehicleid][pvPaintJob] = PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvPaintJob];
                            PlayerVehicleInfo[playerid][playervehicleid][pvColor1] = PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvColor1];
                            PlayerVehicleInfo[playerid][playervehicleid][pvColor2] = PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvColor2];
                            PlayerVehicleInfo[playerid][playervehicleid][pvAllowedPlayerId] = PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvAllowedPlayerId];
                            PlayerVehicleInfo[playerid][playervehicleid][pvPark] = PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvPark];
                            PlayerVehicleInfo[playerid][playervehicleid][pvVW] = PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvVW];
                            PlayerVehicleInfo[playerid][playervehicleid][pvInt] = PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvInt];
							PlayerVehicleInfo[playerid][playervehicleid][pvAlarm] = PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvAlarm];
							PlayerVehicleInfo[playerid][playervehicleid][pvLocksLeft] = PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvLocksLeft];
							PlayerVehicleInfo[playerid][playervehicleid][pvWeapons][0] = 0;
							PlayerVehicleInfo[playerid][playervehicleid][pvWeapons][1] = 0;
							PlayerVehicleInfo[playerid][playervehicleid][pvWeapons][2] = 0;
							PlayerVehicleInfo[playerid][playervehicleid][pvPlate] = 0;
							PlayerVehicleInfo[playerid][playervehicleid][pvTicket] = 0;
                            PlayerVehicleInfo[playerid][playervehicleid][pvSpawned] = 1;
							PlayerVehicleInfo[playerid][playervehicleid][pvAlarmTriggered] = 0;
							PlayerVehicleInfo[playerid][playervehicleid][pvBeingPickLocked] = 0;
							PlayerVehicleInfo[playerid][playervehicleid][pvLastLockPickedBy] = 0;
                            VehicleSpawned[playerid]++;
                            for(new m = 0; m < MAX_MODS; m++) {
                                PlayerVehicleInfo[playerid][playervehicleid][pvMods][m] = PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvMods][m];
                            }

        					mysql_format(MainPipeline, szMessage, sizeof(szMessage), "INSERT INTO `vehicles` (`sqlID`) VALUES ('%d')", GetPlayerSQLId(playerid));
							mysql_tquery(MainPipeline, szMessage, "OnQueryCreateVehicle", "ii", playerid, playervehicleid);

							mysql_format(MainPipeline, szMessage, sizeof(szMessage), "DELETE FROM `vehicles` WHERE `id` = '%d'", PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvSlotId]);
							mysql_tquery(MainPipeline, szMessage, "OnQueryFinish", "ii", SENDDATA_THREAD, VehicleOffer[playerid]);

							PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvSlotId] = 0;
                            PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvId] = 0;
                            PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvModelId] = 0;
                            PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvPosX] = 0.0;
                            PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvPosY] = 0.0;
                            PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvPosZ] = 0.0;
                            PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvPosAngle] = 0.0;
                            PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvLock] = 0;
							PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvLocksLeft] = 0;
                            PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvLocked] = 0;
                            PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvPaintJob] = -1;
                            PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvColor1] = 0;
							PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvImpounded] = 0;
                            PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvColor2] = 0;
                            PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvAllowedPlayerId] = INVALID_PLAYER_ID;
                            PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvPark] = 0;
                            PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvSpawned] = 0;
                            PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvVW] = 0;
                            PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvInt] = 0;
							PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvWeapons][0] = 0;
							PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvWeapons][1] = 0;
							PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvWeapons][2] = 0;
							PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvPlate] = 0;
							PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvTicket] = 0;
							PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvAlarm] = 0;
							PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvAlarmTriggered] = 0;
							PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvBeingPickLocked] = 0;
							PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvLastLockPickedBy] = 0;
                            VehicleSpawned[VehicleOffer[playerid]]--;
                            for(new m = 0; m < MAX_MODS; m++) {
                                PlayerVehicleInfo[VehicleOffer[playerid]][VehicleId[playerid]][pvMods][m] = 0;
                            }

                            VehicleOffer[playerid] = INVALID_PLAYER_ID;
                            VehiclePrice[playerid] = 0;
                            return 1;
                        }
                        else {
                            SendClientMessageEx(playerid, COLOR_GREY, "   The Car Dealer is not in the offered car!");
                            return 1;
                        }
                    }
                    else {
                        SendClientMessageEx(playerid, COLOR_GREY, "   You can't afford the car!");
                        return 1;
                    }
                }
                return 1;
            }
            else {
                SendClientMessageEx(playerid, COLOR_GREY, "   Nobody offered to buy a car!");
                return 1;
            }
        }
        else if(strcmp(params, "house", true) == 0)
		{
            if(HouseOffer[playerid] != INVALID_PLAYER_ID)
			{
                if(IsPlayerConnected(HouseOffer[playerid]))
				{
                    if(HouseInfo[House[playerid]][hOwnerID] != GetPlayerSQLId(HouseOffer[playerid])) return SendClientMessageEx(playerid, COLOR_GREY, "They don't own that house.");
					if(House[playerid] == INVALID_HOUSE_ID) return SendClientMessageEx(playerid, COLOR_RED, "Error: No house specified.");
                    if(GetPlayerCash(playerid) > HousePrice[playerid])
					{
						if(PlayerInfo[HouseOffer[playerid]][pBackpack] > 0 && PlayerInfo[HouseOffer[playerid]][pBStoredH] == HouseInfo[House[playerid]][hSQLId])
						{
							PlayerInfo[HouseOffer[playerid]][pBackpack] = 0;
							PlayerInfo[HouseOffer[playerid]][pBEquipped] = 0;
							PlayerInfo[HouseOffer[playerid]][pBStoredV] = INVALID_PLAYER_VEHICLE_ID;
							PlayerInfo[HouseOffer[playerid]][pBStoredH] = INVALID_HOUSE_ID;
							SendClientMessageEx(HouseOffer[playerid], COLOR_WHITE, "You have lost your backpack since you did not withdraw it");
						}
                        ClearHouse(House[playerid]);
                        HouseInfo[House[playerid]][hLock] = 1;
                        format(HouseInfo[House[playerid]][hOwnerName], 128, "Nobody");
						HouseInfo[House[playerid]][hOwnerID] = -1;
                        sendername = GetPlayerNameEx(HouseOffer[playerid]);
                        PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
                        format(szMessage, sizeof(szMessage), "~w~Congratulations~n~ You have sold your property for ~n~~g~$%d", HousePrice[playerid]);
                        GameTextForPlayer(HouseOffer[playerid], szMessage, 4000, 3);
                        if(House[playerid] == PlayerInfo[HouseOffer[playerid]][pPhousekey])
						{
							PlayerInfo[HouseOffer[playerid]][pPhousekey] = INVALID_HOUSE_ID;
							PlayerInfo[playerid][pPhousekey] = House[playerid];
						}
                        else if(House[playerid] == PlayerInfo[HouseOffer[playerid]][pPhousekey2])
						{
							PlayerInfo[HouseOffer[playerid]][pPhousekey2] = INVALID_HOUSE_ID;
							PlayerInfo[playerid][pPhousekey2] = House[playerid];
						}
						else if(House[playerid] == PlayerInfo[HouseOffer[playerid]][pPhousekey3])
						{
							PlayerInfo[HouseOffer[playerid]][pPhousekey3] = INVALID_HOUSE_ID;
							PlayerInfo[playerid][pPhousekey3] = House[playerid];
						}
						Homes[HouseOffer[playerid]]--;
						Homes[playerid]++;
                        GivePlayerCash(HouseOffer[playerid],HousePrice[playerid]);
						OnPlayerStatsUpdate(HouseOffer[playerid]);

						HouseInfo[House[playerid]][hOwnerID] = GetPlayerSQLId(playerid);
                        HouseInfo[House[playerid]][hOwned] = 1;
                        GetPlayerName(playerid, sendername, sizeof(sendername));
                        strmid(HouseInfo[House[playerid]][hOwnerName], sendername, 0, strlen(sendername), 255);
                        GivePlayerCash(playerid,-HousePrice[playerid]);
                        SendClientMessageEx(playerid, COLOR_WHITE, "Congratulations on your new purchase!");
                        SendClientMessageEx(playerid, COLOR_WHITE, "Type /help to review the property help section!");
                        SaveHouse(House[playerid]);
                        OnPlayerStatsUpdate(playerid);
						ReloadHouseText(House[playerid]);

                        new ip[32], ipex[32];
                        GetPlayerIp(HouseOffer[playerid], ip, sizeof(ip));
                        GetPlayerIp(playerid, ipex, sizeof(ipex));
                        format(szMessage,sizeof(szMessage),"%s(%d) (IP: %s) has sold their house (ID %d) to %s(%d) (IP: %s) for $%s.", GetPlayerNameEx(HouseOffer[playerid]), GetPlayerSQLId(HouseOffer[playerid]), ip, House[playerid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ipex, number_format(HousePrice[playerid]));
                        Log("logs/house.log", szMessage);

                        HouseOffer[playerid] = INVALID_PLAYER_ID;
                        HousePrice[playerid] = 0;
                        House[playerid] = INVALID_HOUSE_ID;
						return 1;
                    }
                    else
					{
                        SendClientMessageEx(playerid, COLOR_GREY, "   You can't afford the house!");
                        HouseOffer[playerid] = INVALID_PLAYER_ID;
                        HousePrice[playerid] = 0;
                        House[playerid] = INVALID_HOUSE_ID;
                        return 1;
                    }
                }
				else return SendClientMessageEx(playerid, COLOR_GREY, "   The seller has disconnected!");
            }
            else return SendClientMessageEx(playerid, COLOR_GREY, "   Nobody offered to buy a house!");
        }
        else if(strcmp(params, "handshake", true) == 0) {
            new
                Count;

            foreach(new i: Player)
			{
				if(GetPVarType(i, "shrequest") && GetPVarInt(i, "shrequest") == playerid) {
					new
						Float: ppFloats[3];

					GetPlayerPos(i, ppFloats[0], ppFloats[1], ppFloats[2]);

					if(!IsPlayerInRangeOfPoint(playerid, 5, ppFloats[0], ppFloats[1], ppFloats[2]) || Spectating[i] > 0) {
						Count++;
						SendClientMessageEx(playerid, COLOR_WHITE, "You're too far away. You can't accept the handshake right now.");
					}
					else {
						switch(GetPVarInt(i, "shstyle")) {
							case 1:
							{
								Count++;
								PlayerFacePlayer( playerid, i );
								ApplyAnimation( playerid, "GANGS", "hndshkaa", 4.0, 1, 1, 1, 0, 1000 );
								ApplyAnimation( i, "GANGS", "hndshkaa", 4.0, 1, 1, 1, 0, 1000 );
								DeletePVar(i, "shrequest");
								format(szMessage, sizeof(szMessage), "* %s has shook hands with %s.", GetPlayerNameEx(i), GetPlayerNameEx(playerid));
								ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
								DeletePVar(i, "shstyle");
							}
							case 2:
							{
								Count++;
								PlayerFacePlayer( playerid, i );
								ApplyAnimation( playerid, "GANGS", "hndshkba", 4.0, 1, 1, 1, 0, 1000 );
								ApplyAnimation( i, "GANGS", "hndshkba", 4.0, 1, 1, 1, 0, 1000 );
								DeletePVar(i, "shrequest");
								format(szMessage, sizeof(szMessage), "* %s has shook hands with %s.", GetPlayerNameEx(i), GetPlayerNameEx(playerid));
								ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
								DeletePVar(i, "shstyle");
							}
							case 3:
							{
								Count++;
								PlayerFacePlayer( playerid, i );
								ApplyAnimation( playerid, "GANGS", "hndshkca", 4.0, 1, 1, 1, 0, 1000 );
								ApplyAnimation( i, "GANGS", "hndshkca", 4.0, 1, 1, 1, 0, 1000 );
								DeletePVar(i, "shrequest");
								format(szMessage, sizeof(szMessage), "* %s has shook hands with %s.", GetPlayerNameEx(i), GetPlayerNameEx(playerid));
								ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
								DeletePVar(i, "shstyle");
							}
							case 4:
							{
								Count++;
								PlayerFacePlayer( playerid, i );
								ApplyAnimation( playerid, "GANGS", "hndshkcb", 4.0, 1, 1, 1, 0, 1000 );
								ApplyAnimation( i, "GANGS", "hndshkca", 4.0, 1, 1, 1, 0, 1000 );
								DeletePVar(i, "shrequest");
								format(szMessage, sizeof(szMessage), "* %s has shook hands with %s.", GetPlayerNameEx(i), GetPlayerNameEx(playerid));
								ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
								DeletePVar(i, "shstyle");
							}
							case 5:
							{
								Count++;
								PlayerFacePlayer( playerid, i );
								ApplyAnimation( playerid, "GANGS", "hndshkda", 4.0, 1, 1, 1, 0, 1000 );
								ApplyAnimation( i, "GANGS", "hndshkca", 4.0, 1, 1, 1, 0, 1000 );
								DeletePVar(i, "shrequest");
								format(szMessage, sizeof(szMessage), "* %s has shook hands with %s.", GetPlayerNameEx(i), GetPlayerNameEx(playerid));
								ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
								DeletePVar(i, "shstyle");
							}
							case 6:
							{
								Count++;
								PlayerFacePlayer( playerid, i );
								ApplyAnimation( playerid, "GANGS","hndshkfa_swt", 4.0, 1, 1, 1, 0, 2600 );
								ApplyAnimation( i, "GANGS","hndshkfa_swt", 4.0, 1, 1, 1, 0, 2600 );
								DeletePVar(i, "shrequest");
								format(szMessage, sizeof(szMessage), "* %s has shook hands with %s.", GetPlayerNameEx(i), GetPlayerNameEx(playerid));
								ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
								DeletePVar(i, "shstyle");
							}
							case 7:
							{
								Count++;
								PlayerFacePlayer( playerid, i );
								ApplyAnimation( playerid, "GANGS", "prtial_hndshk_01", 4.0, 1, 1, 1, 0, 1250 );
								ApplyAnimation( i, "GANGS", "prtial_hndshk_01", 4.0, 1, 1, 1, 0, 1250 );
								DeletePVar(i, "shrequest");
								format(szMessage, sizeof(szMessage), "* %s has shook hands with %s.", GetPlayerNameEx(i), GetPlayerNameEx(playerid));
								ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
								DeletePVar(i, "shstyle");
							}
							case 8:
							{
								Count++;
								PlayerFacePlayer( playerid, i );
								ApplyAnimation( playerid, "GANGS", "prtial_hndshk_biz_01", 3.7, 1, 1, 1, 0, 2200 );
								ApplyAnimation( i, "GANGS", "prtial_hndshk_biz_01", 3.5, 1, 1, 1, 0, 2200 );
								DeletePVar(i, "shrequest");
								format(szMessage, sizeof(szMessage), "* %s has shook hands with %s.", GetPlayerNameEx(i), GetPlayerNameEx(playerid));
								ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
								DeletePVar(i, "shstyle");
							}
						}
					}
				}
            }
            if(Count == 0) return SendClientMessageEx(playerid, COLOR_WHITE, "You don't have any pending handshake requests.");
            return 1;
        }
		else if(strcmp(params, "rflteam",true) == 0) {
			if(!GetPVarType(playerid, "RFLTeam_Invite")) return SendClientMessageEx(playerid, COLOR_GREY, "Nobody offered you to join a team.");
			new team = GetPVarInt(playerid, "RFLTeam_Team");
			giveplayerid = GetPVarInt(playerid, "RFLTeam_Inviter");
			DeletePVar(playerid, "RFLTeam_Invite");
			DeletePVar(playerid, "RFLTeam_Team");
			DeletePVar(playerid, "RFLTeam_Inviter");
			PlayerInfo[playerid][pRFLTeam] = team;
			RFLInfo[team][RFLmembers] +=1;
			format(szMessage, sizeof(szMessage), "* You are now part of %s's team. You may now use /rflhelp.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
			format(szMessage, sizeof(szMessage), "* %s has accepted your invite.", GetPlayerNameEx(playerid));
			SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, szMessage);
			if( GetPVarInt( playerid, "EventToken" ) == 1 ) {
				if( EventKernel[ EventStatus ] == 1 || EventKernel[ EventStatus ] == 2 ) {
					if(EventKernel[EventType] == 3) {
						new Float:X, Float:Y, Float:Z;
						GetPlayerPos( playerid, X, Y, Z );
						format(szMessage, sizeof(szMessage), "Team: %s", RFLInfo[team][RFLname]);
						RFLTeamN3D[playerid] = CreateDynamic3DTextLabel(szMessage,0x008080FF,X,Y,Z,10.0,.attachedplayer = playerid, .worldid = GetPlayerVirtualWorld(playerid));
					}
				}
			}
			OnPlayerStatsUpdate(playerid);
			SaveRelayForLifeTeam(team);
		}
        else if(strcmp(params, "invite", true) == 0)
		{
            if(hInviteOffer[playerid] != INVALID_PLAYER_ID)
			{
                if(IsPlayerConnected(hInviteOffer[playerid]))
				{
	                if(CheckPointCheck(playerid)) return SendClientMessageEx(playerid, COLOR_WHITE, "Please ensure that your current checkpoint is destroyed first (you either have material packages, or another existing checkpoint).");
                    format(szMessage, sizeof(szMessage), "* You have accepted %s's house invite, a checkpoint has been set to their house.", GetPlayerNameEx(hInviteOffer[playerid]));
                    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
                    format(szMessage, sizeof(szMessage), "* %s has accepted your house invite.", GetPlayerNameEx(playerid));
                    SendClientMessageEx(hInviteOffer[playerid], COLOR_LIGHTBLUE, szMessage);
					DisablePlayerCheckpoint(playerid);
                    SetPlayerCheckpoint(playerid, HouseInfo[hInviteHouse[playerid]][hExteriorX], HouseInfo[hInviteHouse[playerid]][hExteriorY], HouseInfo[hInviteHouse[playerid]][hExteriorZ], 4.0);
                    gPlayerCheckpointStatus[playerid] = CHECKPOINT_HOME;
					SetPVarInt(playerid, "hInviteHouse", hInviteHouse[playerid]);
                    hInviteOffer[playerid] = INVALID_PLAYER_ID;
					hInviteHouse[playerid] = INVALID_HOUSE_ID;
                    return 1;
                }
                else
				{
                    hInviteOffer[playerid] = INVALID_PLAYER_ID;
                    hInviteHouse[playerid] = INVALID_HOUSE_ID;
                    SendClientMessageEx(playerid, COLOR_GREY, "The person who sent you a house invite has disconnected.");
                }
            }
            else return SendClientMessageEx(playerid, COLOR_GREY, "Nobody sent you a house invite.");
            return 1;
        }
        /*else if(strcmp(params, "divorce", true) == 0) {
            if(DivorceOffer[playerid] != INVALID_PLAYER_ID) {
                if(IsPlayerConnected(DivorceOffer[playerid])) {
                    if(ProxDetectorS(10.0, playerid, DivorceOffer[playerid])) {
                        GetPlayerName(DivorceOffer[playerid], giveplayer, sizeof(giveplayer));
                        GetPlayerName(playerid, sendername, sizeof(sendername));
                        format(szMessage, sizeof(szMessage), "* You have signed the divorce papers from %s, you are now single again.", giveplayer);
                        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
                        format(szMessage, sizeof(szMessage), "* %s has signed the divorce papers, you are now single again.", sendername);
                        SendClientMessageEx(DivorceOffer[playerid], COLOR_LIGHTBLUE, szMessage);
                        ClearMarriage(playerid);
                        ClearMarriage(DivorceOffer[playerid]);
                        PlayerInfo[playerid][pPhousekey] = INVALID_HOUSE_ID;
                        return 1;
                    }
                    else {
                        SendClientMessageEx(playerid, COLOR_GREY, "   The person that sent you the Divorce Papers is not near you!");
                        return 1;
                    }
                }
            }
            else {
                SendClientMessageEx(playerid, COLOR_GREY, "Nobody sent you any divorce papers.");
                return 1;
            }
        }*/
        else if(strcmp(params, "group", true) == 0) {
            if(GetPVarType(playerid, "Group_Inviter")) {

    			new
					iInviter = GetPVarInt(playerid, "Group_Inviter"),
					iGroupID = PlayerInfo[iInviter][pLeader],
					iRank = PlayerInfo[iInviter][pRank];

				if (PlayerInfo[playerid][pCSFBanned]) {
					if (arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_LEA || arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_MEDIC)	{
						SendClientMessageEx(playerid, COLOR_WHITE, "You are unable to accept this group invite, as you're banned from civil service groups. Contact a member of DGA.");
						DeletePVar(playerid, "Group_Invite");
						DeletePVar(iInviter, "Group_Invited");
						return 1;
					}
				}

                if(IsPlayerConnected(iInviter) && GetPVarInt(iInviter, "Group_Invited") == playerid && 0 <= iGroupID < MAX_GROUPS) {
					PlayerInfo[playerid][pMember] = iGroupID;
					PlayerInfo[playerid][pRank] = 0;
					PlayerInfo[playerid][pDivision] = INVALID_DIVISION;
					strcpy(PlayerInfo[playerid][pBadge], "None", 9);
					arrGroupData[iGroupID][g_iMemberCount]++;

					format(szMessage, sizeof szMessage, "You have accepted %s %s's invite, and are now a member of %s.", arrGroupRanks[iGroupID][iRank], GetPlayerNameEx(iInviter), arrGroupData[iGroupID][g_szGroupName]);
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);

					format(szMessage, sizeof szMessage, "%s accepted your group invite.", GetPlayerNameEx(playerid));
					SendClientMessageEx(iInviter, COLOR_LIGHTBLUE, szMessage);

					format(szMessage, sizeof szMessage, "%s (%d) accepted %s %s's (%d) invite to join %s (%d).", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), arrGroupRanks[iGroupID][iRank], GetPlayerNameEx(iInviter), GetPlayerSQLId(iInviter), arrGroupData[iGroupID][g_szGroupName], iGroupID + 1);
					GroupLog(iGroupID, szMessage);

					DeletePVar(playerid, "Group_Invite");
					DeletePVar(iInviter, "Group_Invited");
                }
				else SendClientMessageEx(playerid, COLOR_GREY, "The person offering you an invite has disconnected.");
            }
            else SendClientMessageEx(playerid, COLOR_GREY, "Nobody has offered you a group invite.");
        }
        else if(strcmp(params, "witness", true) == 0) {
            if(MarryWitnessOffer[playerid] != INVALID_PLAYER_ID) {
                if(IsPlayerConnected(MarryWitnessOffer[playerid])) {
                    if(ProxDetectorS(10.0, playerid, MarryWitnessOffer[playerid])) {
                        GetPlayerName(MarryWitnessOffer[playerid], giveplayer, sizeof(giveplayer));
                        GetPlayerName(playerid, sendername, sizeof(sendername));
                        format(szMessage, sizeof(szMessage), "* You have accepted %s's request to be their marriage witness.", giveplayer);
                        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
                        format(szMessage, sizeof(szMessage), "* %s has accepted your request to be your marriage witness.", sendername);
                        SendClientMessageEx(MarryWitnessOffer[playerid], COLOR_LIGHTBLUE, szMessage);
                        MarryWitness[MarryWitnessOffer[playerid]] = playerid;
                        MarryWitnessOffer[playerid] = INVALID_PLAYER_ID;
                        return 1;
                    }
                    else {
                        SendClientMessageEx(playerid, COLOR_GREY, "   The person that requested you to be their marriage witness is not near you!");
                        return 1;
                    }
                }
            }
            else {
                SendClientMessageEx(playerid, COLOR_GREY, "   No-one asked you to be their marriage witness!");
                return 1;
            }
        }
        else if(strcmp(params, "marriage", true) == 0) {
            if(ProposeOffer[playerid] != INVALID_PLAYER_ID) {
                if(IsPlayerConnected(ProposeOffer[playerid])) {
                    if(ProxDetectorS(10.0, playerid, ProposeOffer[playerid])) {
                        if(MarryWitness[ProposeOffer[playerid]] == INVALID_PLAYER_ID) {
                            SendClientMessageEx(playerid, COLOR_GREY, "   The proposer doesn't have a marriage witness!");
                            return 1;
                        }
                        if(IsPlayerConnected(MarryWitness[ProposeOffer[playerid]])) {
                            if(ProxDetectorS(12.0, ProposeOffer[playerid], MarryWitness[ProposeOffer[playerid]])) {
                                if(IsPlayerInRangeOfPoint(playerid, 10.0, 1963.9612, -369.1851, 1093.7289)) {
                                    GetPlayerName(ProposeOffer[playerid], giveplayer, sizeof(giveplayer));
                                    GetPlayerName(playerid, sendername, sizeof(sendername));
                                    format(szMessage, sizeof(szMessage), "* You have accepted %s's request to be your husband.", giveplayer);
                                    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
                                    format(szMessage, sizeof(szMessage), "* %s has accepted your request to be your wife.", sendername);
                                    SendClientMessageEx(ProposeOffer[playerid], COLOR_LIGHTBLUE, szMessage);
                                    format(szMessage, sizeof(szMessage), "Priest: %s, do you take %s as your lovely husband? (Type 'yes', as anything else will reject the marriage.)", sendername, giveplayer);
                                    SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
                                    MarriageCeremoney[playerid] = 1;
									if(GetPVarInt(ProposeOffer[playerid], "marriagelastname") == 1)
									{
										ShowPlayerDialogEx(playerid, DIALOG_MARRIAGE, DIALOG_STYLE_MSGBOX, "Marriage Last Name",
										"As your spouse decided to keep their last name you have the option to keep your last name or use your spouse's.\n\
										Please use the buttons below to make your decision.", "Keep", "Use Their's");
									}
									if(GetPVarInt(ProposeOffer[playerid], "marriagelastname") == 2)
									{
										SendClientMessageEx(playerid, -1, "Your spouse decided to use your last name.");
									}
                                    ProposedTo[ProposeOffer[playerid]] = playerid;
                                    GotProposedBy[playerid] = ProposeOffer[playerid];
                                    MarryWitness[ProposeOffer[playerid]] = INVALID_PLAYER_ID;
                                    ProposeOffer[playerid] = INVALID_PLAYER_ID;
                                    return 1;
                                }
                                else {
                                    SendClientMessageEx(playerid, COLOR_GREY, "   You are not at the church!");
                                    return 1;
                                }
                            }
                            else {
                                SendClientMessageEx(playerid, COLOR_GREY, "   The marriage witness is not near your proposer!");
                                return 1;
                            }
                        }
                        return 1;
                    }
                    else {
                        SendClientMessageEx(playerid, COLOR_GREY, "   The person that proposed to you is not near you!");
                        return 1;
                    }
                }
            }
            else {
                SendClientMessageEx(playerid, COLOR_GREY, "   Nobody proposed to you!");
                return 1;
            }
        }
        else if(strcmp(params, "ticket", true) == 0) {
            if(TicketOffer[playerid] != INVALID_PLAYER_ID) {
                if(IsPlayerConnected(TicketOffer[playerid])) {
                    if (ProxDetectorS(5.0, playerid, TicketOffer[playerid])) {
                        if(GetPlayerCash(playerid) >= TicketMoney[playerid]) {
                            //new ip[32], ipex[32];
                            //GetPlayerIp(playerid, ip, sizeof(ip));
                            //GetPlayerIp(TicketOffer[playerid], ipex, sizeof(ipex));
                            //format(szMessage, sizeof(szMessage), "[FACTION TICKET] %s (IP: %s) has paid $%d to %s (IP: %s)", GetPlayerNameEx(playerid), ip, TicketMoney[playerid], GetPlayerNameEx(TicketOffer[playerid]), ipex);
                            // Log("logs/pay.log", szMessage);
                            format(szMessage, sizeof(szMessage), "* You have paid the ticket of $%d to %s.", TicketMoney[playerid], GetPlayerNameEx(TicketOffer[playerid]));
                            SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
                            format(szMessage, sizeof(szMessage), "* %s has paid your ticket of $%d.", GetPlayerNameEx(playerid), TicketMoney[playerid]);
                            SendClientMessageEx(TicketOffer[playerid], COLOR_LIGHTBLUE, szMessage);
                            format(szMessage, sizeof(szMessage), "* %s has paid the ticket.", GetPlayerNameEx(playerid));
                            ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
                            GivePlayerCash(playerid, - TicketMoney[playerid]);
                            new money = floatround(TicketMoney[playerid] / 3), iGroupID = PlayerInfo[TicketOffer[playerid]][pMember];
                            Tax += money;
                            arrGroupData[iGroupID][g_iBudget] += money;
                            GetPVarString(playerid, "ticketreason", szMiscArray, sizeof(szMiscArray));
                            new str[128];
			                format(str, sizeof(str), "%s has paid %s's ticket of $%d [Reason: %s] and $%d has been sent to %s's budget fund.", GetPlayerNameEx(playerid), GetPlayerNameEx(TicketOffer[playerid]), TicketMoney[playerid], szMiscArray, money, arrGroupData[iGroupID][g_szGroupName]);
							GroupPayLog(iGroupID, str);
                            TicketOffer[playerid] = INVALID_PLAYER_ID;
                            TicketMoney[playerid] = 0;
                            DeletePVar(playerid, "ticketreason");
                            if(GetPlayerCash(playerid) < 1) GivePlayerCash(playerid, 0);
                            return 1;
                        }
                    }
                    else {
                        SendClientMessageEx(playerid, COLOR_GREY, "   The officer is not near you!");
                        return 1;
                    }
                }
            }
            else {
                SendClientMessageEx(playerid, COLOR_GREY, "   No-one offered you a ticket!");
                return 1;
            }
        }
		else if(strcmp(params, "boxing", true) == 0) {
            if(BoxOffer[playerid] != INVALID_PLAYER_ID) {
                if(IsPlayerConnected(BoxOffer[playerid])) {
                    new points;
                    new mypoints;
                    GetPlayerName(BoxOffer[playerid], giveplayer, sizeof(giveplayer));
                    GetPlayerName(playerid, sendername, sizeof(sendername));
                    new level = PlayerInfo[BoxOffer[playerid]][pBoxSkill];
                    if(level >= 0 && level <= 50) { points = 40; }
                    else if(level >= 51 && level <= 100) { points = 50; }
                    else if(level >= 101 && level <= 200) { points = 60; }
                    else if(level >= 201 && level <= 400) { points = 70; }
                    else if(level >= 401) { points = 80; }
                    if(PlayerInfo[playerid][pJob] == 12 || PlayerInfo[playerid][pJob2] == 12 || PlayerInfo[playerid][pJob3] == 12) {
                        new clevel = PlayerInfo[playerid][pBoxSkill];
                        if(clevel >= 0 && clevel <= 50) { mypoints = 40; }
                        else if(clevel >= 51 && clevel <= 100) { mypoints = 50; }
                        else if(clevel >= 101 && clevel <= 200) { mypoints = 60; }
                        else if(clevel >= 201 && clevel <= 400) { mypoints = 70; }
                        else if(clevel >= 401) { mypoints = 80; }
                    }
                    else {
                        mypoints = 30;
                    }
                    format(szMessage, sizeof(szMessage), "* You have accepted the Boxing Challenge from %s, and will fight with %d Health.",giveplayer,mypoints);
                    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
                    format(szMessage, sizeof(szMessage), "* %s has accepted your Boxing Challenge Request, you will fight with %d Health.",sendername,points);
                    SendClientMessageEx(BoxOffer[playerid], COLOR_LIGHTBLUE, szMessage);
                    if(IsPlayerInRangeOfPoint(playerid,20.0,758.98, -60.32, 1000.78) || IsPlayerInRangeOfPoint(BoxOffer[playerid],20.0,758.98, -60.32, 1000.78)) {
                        ResetPlayerWeapons(playerid);
                        ResetPlayerWeapons(BoxOffer[playerid]);
                        SetHealth(playerid, mypoints);
                        SetHealth(BoxOffer[playerid], points);
                        SetPlayerInterior(playerid, 7); SetPlayerInterior(BoxOffer[playerid], 7);
                        SetPlayerPos(playerid, 768.94, -70.87, 1001.56); SetPlayerFacingAngle(playerid, 131.8632);
                        SetPlayerPos(BoxOffer[playerid], 764.35, -66.48, 1001.56); SetPlayerFacingAngle(BoxOffer[playerid], 313.1165);
                        TogglePlayerControllable(playerid, 0); TogglePlayerControllable(BoxOffer[playerid], 0);
                        GameTextForPlayer(playerid, "~r~Waiting", 3000, 1); GameTextForPlayer(BoxOffer[playerid], "~r~Waiting", 3000, 1);
                        new name[MAX_PLAYER_NAME];
                        new dszMessage[MAX_PLAYER_NAME];
                        new wszMessage[MAX_PLAYER_NAME];
                        GetPlayerName(playerid, name, sizeof(name));
                        format(dszMessage, sizeof(dszMessage), "%s", name);
                        strmid(wszMessage, dszMessage, 0, strlen(dszMessage), 255);
                        if(strcmp(Titel[TitelName] ,wszMessage, true ) == 0 ) {
                            format(szMessage, sizeof(szMessage), "Boxing News: Boxing Champion %s will fight VS %s, in 60 seconds (Grove Street Gym).",  sendername, giveplayer);
                            ProxDetector(30.0, playerid, szMessage, COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE);
                            TBoxer = playerid;
                            BoxDelay = 60;
                        }
                        GetPlayerName(BoxOffer[playerid], name, sizeof(name));
                        format(dszMessage, sizeof(dszMessage), "%s", name);
                        strmid(wszMessage, dszMessage, 0, strlen(dszMessage), 255);
                        if(strcmp(Titel[TitelName] ,wszMessage, true ) == 0 ) {
                            format(szMessage, sizeof(szMessage), "Boxing News: Boxing Champion %s will fight VS %s, in 60 seconds (Grove Street Gym).",  giveplayer, sendername);
                            ProxDetector(30.0, playerid, szMessage, COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE);
                            TBoxer = BoxOffer[playerid];
                            BoxDelay = 60;
                        }
                        BoxWaitTime[playerid] = 1; BoxWaitTime[BoxOffer[playerid]] = 1;
                        if(BoxDelay < 1) { BoxDelay = 20; }
                        InRing = 1;
                        Boxer1 = BoxOffer[playerid];
                        Boxer2 = playerid;
                        PlayerBoxing[playerid] = 1;
                        PlayerBoxing[BoxOffer[playerid]] = 1;
                        BoxOffer[playerid] = INVALID_PLAYER_ID;
                        return 1;
                    }
                    ResetPlayerWeapons(playerid);
                    ResetPlayerWeapons(BoxOffer[playerid]);
                    SetHealth(playerid, mypoints);
                    SetHealth(BoxOffer[playerid], points);
                    SetPlayerInterior(playerid, 5); SetPlayerInterior(BoxOffer[playerid], 5);
                    SetPlayerPos(playerid, 762.9852,2.4439,1001.5942); SetPlayerFacingAngle(playerid, 131.8632);
                    SetPlayerPos(BoxOffer[playerid], 758.7064,-1.8038,1001.5942); SetPlayerFacingAngle(BoxOffer[playerid], 313.1165);
                    TogglePlayerControllable(playerid, 0); TogglePlayerControllable(BoxOffer[playerid], 0);
                    GameTextForPlayer(playerid, "~r~Waiting", 3000, 1); GameTextForPlayer(BoxOffer[playerid], "~r~Waiting", 3000, 1);
                    new name[MAX_PLAYER_NAME];
                    new dszMessage[MAX_PLAYER_NAME];
                    new wszMessage[MAX_PLAYER_NAME];
                    GetPlayerName(playerid, name, sizeof(name));
                    format(dszMessage, sizeof(dszMessage), "%s", name);
                    strmid(wszMessage, dszMessage, 0, strlen(dszMessage), 255);
                    if(strcmp(Titel[TitelName] ,wszMessage, true ) == 0 ) {
                        format(szMessage, sizeof(szMessage), "Boxing News: Boxing Champion %s will fight VS %s, in 60 seconds (Grove Street Gym).",  sendername, giveplayer);
                        ProxDetector(30.0, playerid, szMessage, COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE);
                        TBoxer = playerid;
                        BoxDelay = 60;
                    }
                    GetPlayerName(BoxOffer[playerid], name, sizeof(name));
                    format(dszMessage, sizeof(dszMessage), "%s", name);
                    strmid(wszMessage, dszMessage, 0, strlen(dszMessage), 255);
                    if(strcmp(Titel[TitelName] ,wszMessage, true ) == 0 ) {
                        format(szMessage, sizeof(szMessage), "Boxing News: Boxing Champion %s will fight VS %s, in 60 seconds (Grove Street Gym).",  giveplayer, sendername);
                        ProxDetector(30.0, playerid, szMessage, COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE);
                        TBoxer = BoxOffer[playerid];
                        BoxDelay = 60;
                    }
                    BoxWaitTime[playerid] = 1; BoxWaitTime[BoxOffer[playerid]] = 1;
                    if(BoxDelay < 1) { BoxDelay = 20; }
                    InRing = 1;
                    Boxer1 = BoxOffer[playerid];
                    Boxer2 = playerid;
                    PlayerBoxing[playerid] = 1;
                    PlayerBoxing[BoxOffer[playerid]] = 1;
                    BoxOffer[playerid] = INVALID_PLAYER_ID;
                    return 1;
                }
                return 1;
            }
            else {
                SendClientMessageEx(playerid, COLOR_GREY, "   No-one offered you a Boxing Challenge!");
                return 1;
            }
        }
                                                  // accept taxi
   /*     else if(strcmp(params,"taxi",true) == 0) {
            if(TransportDuty[playerid] != 1) {
                SendClientMessageEx(playerid, COLOR_GREY, "   You are not a Taxi Driver!");
                return 1;
            }
            if(TaxiCallTime[playerid] > 0) {
                SendClientMessageEx(playerid, COLOR_GREY, "   You have already accepted a taxi call!");
                return 1;
            }
            if(TaxiCall != INVALID_PLAYER_ID) {
                if(IsPlayerConnected(TaxiCall)) {
                	if(taxitime[TaxiCall] == 1 && PlayerInfo[playerid][pMember] != 10 && PlayerInfo[playerid][pLeader] != 10)
					{
					    return SendClientMessageEx(playerid, COLOR_GREY, "You must wait 20 seconds before accepting this call! To recieve priority, join the Taxi Company!");
					}
                    GetPlayerName(playerid, sendername, sizeof(sendername));
                    GetPlayerName(TaxiCall, giveplayer, sizeof(giveplayer));
                    format(szMessage, sizeof(szMessage), "* You have accepted the taxi call from %s, you will see the marker until you have reached it.",giveplayer);
                    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
                    new zone[MAX_ZONE_NAME];
					GetPlayer3DZone(TaxiCall, zone, sizeof(zone));
					format(szMessage, sizeof(szMessage), "* %s can be found at %s.", GetPlayerNameEx(TaxiCall), zone);
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
                    format(szMessage, sizeof(szMessage), "* Taxi Driver %s has accepted your Taxi Call; please wait at your current position.",sendername);
                    SendClientMessageEx(TaxiCall, COLOR_LIGHTBLUE, szMessage);
                    GameTextForPlayer(playerid, "~w~Taxi Caller~n~~r~Go to the red marker.", 5000, 1);
                    TaxiCallTime[playerid] = 1;
                    TaxiAccepted[playerid] = TaxiCall;
                    TaxiCall = INVALID_PLAYER_ID;
                    return 1;
                }
            }
            else {
                SendClientMessageEx(playerid, COLOR_GREY, "   Nobody called for a taxi yet!");
                return 1;
            }
        }
        else if(strcmp(params, "bus", true) == 0) {
            if(TransportDuty[playerid] != 2) {
                SendClientMessageEx(playerid, COLOR_GREY, "   You are not a bus driver!");
                return 1;
            }
            if(BusCallTime[playerid] > 0) {
                SendClientMessageEx(playerid, COLOR_GREY, "   You have already accepted a bus call!");
                return 1;
            }
            if(BusCall != INVALID_PLAYER_ID) {
                if(IsPlayerConnected(BusCall)) {
                    if(CheckPointCheck(playerid)) {
                        SendClientMessageEx(playerid, COLOR_WHITE, "Please ensure that your current checkpoint is destroyed first (you either have material packages, or another existing checkpoint).");
                        return 1;
                    }
                    GetPlayerName(playerid, sendername, sizeof(sendername));
                    GetPlayerName(BusCall, giveplayer, sizeof(giveplayer));
                    format(szMessage, sizeof(szMessage), "* You have accepted the Bus Call from %s, you will see the marker untill you have reached it.",giveplayer);
                    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
                    new zone[MAX_ZONE_NAME];
					GetPlayer3DZone(BusCall, zone, sizeof(zone));
					format(szMessage, sizeof(szMessage), "* %s can be found at %s.", GetPlayerNameEx(BusCall), zone);
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
                    format(szMessage, sizeof(szMessage), "* Bus Driver %s has accepted your bus call; please wait at your current position.",sendername);
                    SendClientMessageEx(BusCall, COLOR_LIGHTBLUE, szMessage);
                    new Float:X,Float:Y,Float:Z;
                    GetPlayerPos(BusCall, X, Y, Z);
                    SetPlayerCheckpoint(playerid, X, Y, Z, 5);
                    GameTextForPlayer(playerid, "~w~Bus Caller~n~~r~Goto redmarker", 5000, 1);
                    BusCallTime[playerid] = 1;
                    BusAccepted[playerid] = BusCall;
                    BusCall = INVALID_PLAYER_ID;
                    return 1;
                }
            }
            else {
                SendClientMessageEx(playerid, COLOR_GREY, "   No-one called for a Bus yet!");
                return 1;
            }
        }*/
        else if(strcmp(params, "medic", true) == 0) {
            if(IsAMedic(playerid)) {
                if(MedicCallTime[playerid] > 0) {
                    SendClientMessageEx(playerid, COLOR_GREY, "   You have already accepted a Medic Call!");
                    return 1;
                }
                if(CheckPointCheck(playerid)) {
                    SendClientMessageEx(playerid, COLOR_WHITE, "Please ensure that your current checkpoint is destroyed first (you either have material packages, or another existing checkpoint).");
                    return 1;
                }
                if(MedicCall != INVALID_PLAYER_ID) {
                    if(IsPlayerConnected(MedicCall)) {
                        GetPlayerName(playerid, sendername, sizeof(sendername));
                        GetPlayerName(MedicCall, giveplayer, sizeof(giveplayer));
                        format(szMessage, sizeof(szMessage), "* You have accepted the Medic Call from %s.",giveplayer);
                        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
                        // SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* After the 45 Seconds the red marker will dissapear.");
                        format(szMessage, sizeof(szMessage), "* Medic %s has accepted your Medic Call please wait at your current Position.",sendername);
                        SendClientMessageEx(MedicCall, COLOR_LIGHTBLUE, szMessage);
                        new Float:X,Float:Y,Float:Z;
                        GetPlayerPos(MedicCall, X, Y, Z);
                        SetPlayerCheckpoint(playerid, X, Y, Z, 5);
                        new zone[MAX_ZONE_NAME];
                        GetPlayer3DZone(MedicCall, zone, sizeof(zone));
                        format(szMessage, sizeof(szMessage), "HINT: %s is located in %s", GetPlayerNameEx(MedicCall), zone);
                        SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
                        MedicCallTime[playerid] = 1;
                        MedicAccepted[playerid] = MedicCall;
                        MedicCall = INVALID_PLAYER_ID;
                        return 1;
                    }
                }
                else {
                    SendClientMessageEx(playerid, COLOR_GREY, "   No-one called for a Medic yet!");
                    return 1;
                }
            }
            else {
                SendClientMessageEx(playerid, COLOR_GREY, "   You are not a Medic!");
                return 1;
            }
        }
        else if(strcmp(params, "mechanic", true) == 0) {
            if(PlayerInfo[playerid][pJob] != 7 && PlayerInfo[playerid][pJob2] != 7 && PlayerInfo[playerid][pJob3] != 7) {
                SendClientMessageEx(playerid, COLOR_GREY, "   You are not a Car Mechanic!");
                return 1;
            }
            if(MechanicCallTime[playerid] > 0) {
                SendClientMessageEx(playerid, COLOR_GREY, "   You have already accepted a Mechanic Call!");
                return 1;
            }
            if(CheckPointCheck(playerid)) {
                SendClientMessageEx(playerid, COLOR_WHITE, "Please ensure that your current checkpoint is destroyed first (you either have material packages, or another existing checkpoint).");
                return 1;
            }
            if(MechanicCall != INVALID_PLAYER_ID) {
                if(IsPlayerConnected(MechanicCall)) {
                    if(playerid == MechanicCall) return 1;
                    GetPlayerName(playerid, sendername, sizeof(sendername));
                    GetPlayerName(MechanicCall, giveplayer, sizeof(giveplayer));
                    format(szMessage, sizeof(szMessage), "* You have accepted the Mechanic Call from %s, you have 30 seconds to get there.",giveplayer);
                    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
                    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* After the 30 Seconds the red marker will dissapear.");
                    format(szMessage, sizeof(szMessage), "* Car Mechanic %s has accepted your Mechanic Call, please wait at your current position.",sendername);
                    SendClientMessageEx(MechanicCall, COLOR_LIGHTBLUE, szMessage);
                    new Float:X,Float:Y,Float:Z;
                    GetPlayerPos(MechanicCall, X, Y, Z);
                    SetPlayerCheckpoint(playerid, X, Y, Z, 5);
                    GameTextForPlayer(playerid, "~w~Mechanic Caller~n~~r~Go to the red marker", 5000, 1);
                    MechanicCallTime[playerid] = 1;
                    MechanicCall = INVALID_PLAYER_ID;
                    return 1;
                }
            }
            else {
                SendClientMessageEx(playerid, COLOR_GREY, "   No-one called for a Car Mechanic yet!");
                return 1;
            }
        }
        else if(strcmp(params, "live", true) == 0) {
            if(LiveOffer[playerid] != INVALID_PLAYER_ID) {
                if(IsPlayerConnected(LiveOffer[playerid])) {
                    if (ProxDetectorS(5.0, playerid, LiveOffer[playerid])) {
                        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You are frozen till the Live Conversation ends.");
                        SendClientMessageEx(LiveOffer[playerid], COLOR_LIGHTBLUE, "* You are frozen till the Live Conversation ends (use /live again).");
                        TogglePlayerControllable(playerid, 0);
                        TogglePlayerControllable(LiveOffer[playerid], 0);
						SetPVarInt(playerid, "IsLive", 1);
						SetPVarInt(LiveOffer[playerid], "IsLive", 1);
                        TalkingLive[playerid] = LiveOffer[playerid];
                        TalkingLive[LiveOffer[playerid]] = playerid;
                        LiveOffer[playerid] = INVALID_PLAYER_ID;
                        return 1;
                    }
                    else {
                        SendClientMessageEx(playerid, COLOR_GREY, "   You are to far away from the News Reporter!");
                        return 1;
                    }
                }
                return 1;
            }
            else {
                SendClientMessageEx(playerid, COLOR_GREY, "   No-one gave you a Live Conversation offer!");
                return 1;
            }
        }
        else if(strcmp(params, "lawyer", true) == 0) {
            if(sscanf(params, "u", giveplayerid))
            {
                SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /accept lawyer [player]");
                return 1;
            }
            if (IsACop(playerid)) {
                if(IsPlayerConnected(giveplayerid)) {
                    if(giveplayerid != INVALID_PLAYER_ID) {
                        if(PlayerInfo[giveplayerid][pJob] == 2 || PlayerInfo[giveplayerid][pJob2] == 2 || PlayerInfo[giveplayerid][pJob3] == 2) {
                            GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
                            GetPlayerName(playerid, sendername, sizeof(sendername));
                            format(szMessage, sizeof(szMessage), "* You allowed %s to free a Jailed Person.", giveplayer);
                            SendClientMessageEx(playerid, COLOR_LIGHTBLUE,szMessage);
                            format(szMessage, sizeof(szMessage), "* Officer %s approved (allowed) you to free a Jailed Person. (use /free)", sendername);
                            SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE,szMessage);
                            ApprovedLawyer[giveplayerid] = 1;
                            return 1;
                        }
                    }
                }
                return 1;
            }
            else {
                SendClientMessageEx(playerid, COLOR_GREY, "Invalid action! (You are no cop / person is not a Lawyer / Bad ID)");
                return 1;
            }
        }
        else if(strcmp(params, "bodyguard", true) == 0) {
        	if(GetPVarType(playerid, "IsInArena")) return SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this while being in an arena!");
            if(GuardOffer[playerid] != INVALID_PLAYER_ID) {
                if(GetPlayerCash(playerid) > GuardPrice[playerid]) {
                    if(IsPlayerConnected(GuardOffer[playerid])) {
                        if(ProxDetectorS(6.0, playerid, GuardOffer[playerid])) {
                            new Float:armour;
                            GetArmour(playerid, armour);
                            if(armour >= 50) {
                                SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You already have a vest!");
                                return 1;
                            }
                            new ip[32], ipex[32];
                            GetPlayerIp(playerid, ip, sizeof(ip));
                            GetPlayerIp(GuardOffer[playerid], ipex, sizeof(ipex));
                            //format(szMessage, sizeof(szMessage), "[BODYGUARD] %s (IP:%s) has paid $%d to %s (IP:%s)", GetPlayerNameEx(playerid), ip, GuardPrice[playerid], GetPlayerNameEx(GuardOffer[playerid]), ipex);
                            // Log("logs/pay.log", szMessage);

                            if(GuardPrice[playerid] >= 25000 && (PlayerInfo[GuardOffer[playerid]][pLevel] <= 3 || PlayerInfo[playerid][pLevel] <= 3)) {
                                format(szMessage, sizeof(szMessage), "%s (IP:%s) has guarded %s (IP:%s) $%d in this session.", GetPlayerNameEx(playerid), ip, GetPlayerNameEx(GuardOffer[playerid]), ipex, GuardPrice[playerid]);
                                // Log("logs/pay.log", szMessage);
                                ABroadCast(COLOR_YELLOW, szMessage, 2);
                            }

                            SetArmour(playerid, 50);
                            GetPlayerName(GuardOffer[playerid], giveplayer, sizeof(giveplayer));
                            GetPlayerName(playerid, sendername, sizeof(sendername));
                            format(szMessage, sizeof(szMessage), "* You accepted the protection for $%d from %s.",GuardPrice[playerid],GetPlayerNameEx(GuardOffer[playerid]));
                            SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
                            format(szMessage, sizeof(szMessage), "* %s accepted your protection, and the $%d was added to your money.",GetPlayerNameEx(playerid),GuardPrice[playerid]);
                            SendClientMessageEx(GuardOffer[playerid], COLOR_LIGHTBLUE, szMessage);
                            GivePlayerCash(GuardOffer[playerid], GuardPrice[playerid]);
                            GivePlayerCash(playerid, -GuardPrice[playerid]);
                            ExtortionTurfsWarsZone(GuardOffer[playerid], 2, GuardPrice[playerid]);
                            GuardOffer[playerid] = INVALID_PLAYER_ID;
                            GuardPrice[playerid] = 0;
                            return 1;
                        }
                        else {
                            SendClientMessageEx(playerid, COLOR_GRAD2, "You are not near the person offering you guard!");
                            return 1;
                        }
                    }
                    return 1;
                }
                else {
                    SendClientMessageEx(playerid, COLOR_GREY, "   You can't afford the Protection!");
                    return 1;
                }
            }
            else {
                SendClientMessageEx(playerid, COLOR_GREY, "   No-one offered you any Protection!");
                return 1;
            }
        }
        else if(strcmp(params, "defense", true) == 0) {
            if(DefendOffer[playerid] != INVALID_PLAYER_ID) {
                if(GetPlayerCash(playerid) > DefendPrice[playerid]) {
                    if(IsPlayerConnected(DefendOffer[playerid])) {
                        /*new ip[32], ipex[32];
                        GetPlayerIp(playerid, ip, sizeof(ip));
                        GetPlayerIp(DefendOffer[playerid], ipex, sizeof(ipex));
                        format(szMessage, sizeof(szMessage), "[LAWYER] %s (IP:%s) has paid $%d to %s (IP:%s)", GetPlayerNameEx(playerid), ip, DefendPrice[playerid], GetPlayerNameEx(DefendOffer[playerid]), ipex);
                        Log("logs/pay.log", szMessage);*/
                        PlayerInfo[playerid][pWantedLevel]--;
                        SetPlayerWantedLevel(playerid, PlayerInfo[playerid][pWantedLevel]);
                        SetPlayerToTeamColor(playerid);
                        giveplayer = GetPlayerNameEx(DefendOffer[playerid]);
                        sendername = GetPlayerNameEx(playerid);
                        format(szMessage, sizeof(szMessage), "* You accepted the Defense for $%d from Lawyer %s.",DefendPrice[playerid],giveplayer);
                        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
                        format(szMessage, sizeof(szMessage), "* %s accepted your Defense, and the $%d was added to your money.",sendername,DefendPrice[playerid]);
                        SendClientMessageEx(DefendOffer[playerid], COLOR_LIGHTBLUE, szMessage);
                        GivePlayerCash( DefendOffer[playerid],DefendPrice[playerid]);
                        GivePlayerCash(playerid, -DefendPrice[playerid]);
                        DefendOffer[playerid] = INVALID_PLAYER_ID;
                        DefendPrice[playerid] = 0;
                        return 1;
                    }
                    return 1;
                }
                else {
                    SendClientMessageEx(playerid, COLOR_GREY, "   You can't afford the Protection!");
                    return 1;
                }
            }
            else {
                SendClientMessageEx(playerid, COLOR_GREY, "   No-one offered you any Protection!");
                return 1;
            }
        }
        else if(strcmp(params, "appeal", true) == 0) {
            if(AppealOffer[playerid] != INVALID_PLAYER_ID) {
                if(IsPlayerConnected(AppealOffer[playerid])) {
                    AppealOfferAccepted[playerid] = 1;
                    giveplayer = GetPlayerNameEx(AppealOffer[playerid]);
                    sendername = GetPlayerNameEx(playerid);
                    format(szMessage, sizeof(szMessage), "* You accepted the appeal from Lawyer %s.",giveplayer);
                    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
                    format(szMessage, sizeof(szMessage), "* %s accepted your appeal, a message to the Judicial System has been sent, please wait at the courtroom.",sendername);
                    SendClientMessageEx(AppealOffer[playerid], COLOR_LIGHTBLUE, szMessage);
                    return 1;
                }
                return 1;
            }
            else {
                SendClientMessageEx(playerid, COLOR_GREY, "   No-one offered you any Protection!");
                return 1;
            }
        }
 	    else if(strcmp(params, "rimkit", true) == 0) {
        	if (GetPVarType(playerid, "RimOffer")) {
	            if(GetPlayerCash(playerid) > GetPVarInt(playerid, "RimPrice")) {
	            	if(IsPlayerConnected(GetPVarInt(playerid, "RimOffer"))) {
	            		if (GetPVarInt(playerid, "RimSeller_SQLId") != GetPlayerSQLId(GetPVarInt(playerid, "RimOffer")))
						{
			                return SendClientMessageEx(playerid, COLOR_GREY, "The other person has disconnected.");
						}
						if(PlayerInfo[GetPVarInt(playerid, "RimOffer")][pRimMod] < GetPVarInt(playerid, "RimCount"))	{
							SendClientMessageEx(playerid,COLOR_GREY, "That person does not have that number of rim kits anymore!");
							return 1;
						}
	                    GivePlayerCash(playerid, -GetPVarInt(playerid, "RimPrice"));
	                    GivePlayerCash(GetPVarInt(playerid, "RimOffer"), GetPVarInt(playerid, "RimPrice"));
						GetPlayerName(GetPVarInt(playerid, "RimOffer"), giveplayer, sizeof(giveplayer));
	                    format(szMessage, sizeof(szMessage), "* You bought %d rim kits for $%d from %s.",GetPVarInt(playerid, "RimCount"),GetPVarInt(playerid, "RimPrice"),giveplayer);
	                    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
	                    GetPlayerName(playerid, sendername, sizeof(sendername));
	                    format(szMessage, sizeof(szMessage), "* %s has bought your %d rim kits, $%d was added to your money.",sendername,GetPVarInt(playerid, "RimCount"),GetPVarInt(playerid, "RimPrice"));
	                    SendClientMessageEx(GetPVarInt(playerid, "RimOffer"), COLOR_LIGHTBLUE, szMessage);
	                    PlayerInfo[GetPVarInt(playerid, "RimOffer")][pRimMod] -= GetPVarInt(playerid, "RimCount");
	                    PlayerInfo[playerid][pRimMod] += GetPVarInt(playerid, "RimCount");

                        format(szMessage, sizeof(szMessage), "%s(%d) (IP:%s) has bought (%d) rim kits for $%s from %s(%d) (IP:%s)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), GetPVarInt(playerid, "RimCount"), number_format(GetPVarInt(playerid, "RimPrice")),  GetPlayerNameEx(GetPVarInt(playerid, "RimOffer")), GetPlayerSQLId(GetPVarInt(playerid, "RimOffer")), GetPlayerIpEx(GetPVarInt(playerid, "RimOffer")));
						Log("logs/pay.log", szMessage);

						OnPlayerStatsUpdate(playerid);
						OnPlayerStatsUpdate(GetPVarInt(playerid, "RimOffer"));

	                    DeletePVar(playerid, "RimOffer");
	                    DeletePVar(playerid, "RimPrice");
	                    DeletePVar(playerid, "RimCount");
                    	DeletePVar(playerid, "RimSeller_SQLId");
	                    return 1;
	  				}
	     		}
	      		else
				{
	            	SendClientMessageEx(playerid, COLOR_GREY, "You can't afford that many rim kits!");
	                return 1;
	        	}
       		}
			else
			{
        		SendClientMessageEx(playerid, COLOR_GREY, "No-one offered you any rim kits!");
			}
 	    }
		else if(strcmp(params, "voucher", true) == 0)
		{
			if(!GetPVarType(playerid, "buyingVoucher")) return SendClientMessageEx(playerid, COLOR_GRAD2, "No-one has offered you any vouchers.");

			new sellerid = GetPVarInt(playerid, "sellerVoucher"),
				price = GetPVarInt(playerid, "priceVoucher"),
				amount = GetPVarInt(playerid, "amountVoucher");

			DeletePVar(playerid, "sellVoucher");
			DeletePVar(playerid, "priceVoucher");
			DeletePVar(playerid, "amountVoucher");
			if(GetPlayerCash(playerid) > price)
			{
				if(IsPlayerConnected(sellerid))
				{
					if(GetPVarInt(playerid, "SQLID_Voucher") != GetPlayerSQLId(sellerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "The seller has disconnected.");
					if(GetPVarInt(playerid, "buyingVoucher") == 1) // Car Voucher
					{
						if(PlayerInfo[sellerid][pVehVoucher] < amount) return SendClientMessageEx(playerid, COLOR_GRAD1, "The seller does not have that many anymore.");

						GivePlayerCash(playerid, -price);
						GivePlayerCash(sellerid, price);
						format(szMessage, sizeof(szMessage), "* You have bought %d Car Voucher(s) for $%s from %s.", amount, number_format(price), GetPlayerNameEx(sellerid));
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
						format(szMessage, sizeof(szMessage), "* %s has bought %d Car Voucher(s) from you, $%s was added to your money.", GetPlayerNameEx(playerid), amount, number_format(price));
						SendClientMessageEx(sellerid, COLOR_LIGHTBLUE, szMessage);
						format(szMessage, sizeof(szMessage), "%s(%d) (IP:%s) has bought (%d) Car Voucher(s) for $%s from %s(%d) (IP:%s)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), amount, number_format(price),  GetPlayerNameEx(sellerid), GetPlayerSQLId(sellerid), GetPlayerIpEx(sellerid));
						Log("logs/pay.log", szMessage);
						PlayerInfo[playerid][pVehVoucher] += amount;
						PlayerInfo[sellerid][pVehVoucher] -= amount;

						OnPlayerStatsUpdate(playerid);
						OnPlayerStatsUpdate(sellerid);

						DeletePVar(playerid, "buyingVoucher");
						return 1;
					}
					if(GetPVarInt(playerid, "buyingVoucher") == 2) // Silver VIP Voucher
					{
						if(PlayerInfo[sellerid][pSVIPVoucher] < amount) return SendClientMessageEx(playerid, COLOR_GRAD1, "The seller does not have that many anymore.");

						GivePlayerCash(playerid, -price);
						GivePlayerCash(sellerid, price);
						format(szMessage, sizeof(szMessage), "* You have bought %d Silver VIP Voucher(s) for $%s from %s.", amount, number_format(price), GetPlayerNameEx(sellerid));
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
						format(szMessage, sizeof(szMessage), "* %s has bought %d Silver VIP Voucher(s) from you, $%s was added to your money.", GetPlayerNameEx(playerid), amount, number_format(price));
						SendClientMessageEx(sellerid, COLOR_LIGHTBLUE, szMessage);
						format(szMessage, sizeof(szMessage), "%s(%d) (IP:%s) has bought (%d) Silver VIP Voucher(s) for $%s from %s(%d) (IP:%s)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), amount, number_format(price),  GetPlayerNameEx(sellerid), GetPlayerSQLId(sellerid), GetPlayerIpEx(sellerid));
						Log("logs/pay.log", szMessage);
						PlayerInfo[playerid][pSVIPVoucher] += amount;
						PlayerInfo[sellerid][pSVIPVoucher] -= amount;

						OnPlayerStatsUpdate(playerid);
						OnPlayerStatsUpdate(sellerid);

						DeletePVar(playerid, "buyingVoucher");
						return 1;
					}
					if(GetPVarInt(playerid, "buyingVoucher") == 3) // Gold VIP Voucher
					{
						if(PlayerInfo[sellerid][pGVIPVoucher] < amount) return SendClientMessageEx(playerid, COLOR_GRAD1, "The seller does not have that many anymore.");

						GivePlayerCash(playerid, -price);
						GivePlayerCash(sellerid, price);
						format(szMessage, sizeof(szMessage), "* You have bought %d Gold VIP Voucher(s) for $%s from %s.", amount, number_format(price), GetPlayerNameEx(sellerid));
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
						format(szMessage, sizeof(szMessage), "* %s has bought %d Gold VIP Voucher(s) from you, $%s was added to your money.", GetPlayerNameEx(playerid), amount, number_format(price));
						SendClientMessageEx(sellerid, COLOR_LIGHTBLUE, szMessage);
						format(szMessage, sizeof(szMessage), "%s(%d) (IP:%s) has bought (%d) Gold VIP Voucher(s) for $%s from %s(%d) (IP:%s)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), amount, number_format(price),  GetPlayerNameEx(sellerid), GetPlayerSQLId(sellerid), GetPlayerIpEx(sellerid));
						Log("logs/pay.log", szMessage);
						PlayerInfo[playerid][pGVIPVoucher] += amount;
						PlayerInfo[sellerid][pGVIPVoucher] -= amount;

						OnPlayerStatsUpdate(playerid);
						OnPlayerStatsUpdate(sellerid);

						DeletePVar(playerid, "buyingVoucher");
						return 1;
					}
					if(GetPVarInt(playerid, "buyingVoucher") == 4) // 1 month PVIP Voucher
					{
						if(PlayerInfo[sellerid][pPVIPVoucher] < amount) return SendClientMessageEx(playerid, COLOR_GRAD1, "The seller does not have that many anymore.");

						GivePlayerCash(playerid, -price);
						GivePlayerCash(sellerid, price);
						format(szMessage, sizeof(szMessage), "* You have bought %d 1 month PVIP Voucher(s) for $%s from %s.", amount, number_format(price), GetPlayerNameEx(sellerid));
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
						format(szMessage, sizeof(szMessage), "* %s has bought %d 1 month PVIP Voucher(s) from you, $%s was added to your money.", GetPlayerNameEx(playerid), amount, number_format(price));
						SendClientMessageEx(sellerid, COLOR_LIGHTBLUE, szMessage);
						format(szMessage, sizeof(szMessage), "%s(%d) (IP:%s) has bought (%d) 1 month PVIP Voucher(s) for $%s from %s(%d) (IP:%s)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), amount, number_format(price),  GetPlayerNameEx(sellerid), GetPlayerSQLId(sellerid), GetPlayerIpEx(sellerid));
						Log("logs/pay.log", szMessage);
						PlayerInfo[playerid][pPVIPVoucher] += amount;
						PlayerInfo[sellerid][pPVIPVoucher] -= amount;

						OnPlayerStatsUpdate(playerid);
						OnPlayerStatsUpdate(sellerid);

						DeletePVar(playerid, "buyingVoucher");
						return 1;
					}
					if(GetPVarInt(playerid, "buyingVoucher") == 5) // Restricted Car Voucher
					{
						if(PlayerInfo[sellerid][pCarVoucher] < amount) return SendClientMessageEx(playerid, COLOR_GRAD1, "The seller does not have that many anymore.");

						GivePlayerCash(playerid, -price);
						GivePlayerCash(sellerid, price);
						format(szMessage, sizeof(szMessage), "* You have bought %d Restricted Car Voucher(s) for $%s from %s.", amount, number_format(price), GetPlayerNameEx(sellerid));
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
						format(szMessage, sizeof(szMessage), "* %s has bought %d Restricted Car Voucher(s) from you, $%s was added to your money.", GetPlayerNameEx(playerid), amount, number_format(price));
						SendClientMessageEx(sellerid, COLOR_LIGHTBLUE, szMessage);
						format(szMessage, sizeof(szMessage), "%s(%d) (IP:%s) has bought (%d) Restricted Car Voucher(s) for $%s from %s(%d) (IP:%s)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), amount, number_format(price),  GetPlayerNameEx(sellerid), GetPlayerSQLId(sellerid), GetPlayerIpEx(sellerid));
						Log("logs/pay.log", szMessage);
						PlayerInfo[playerid][pCarVoucher] += amount;
						PlayerInfo[sellerid][pCarVoucher] -= amount;

						OnPlayerStatsUpdate(playerid);
						OnPlayerStatsUpdate(sellerid);

						DeletePVar(playerid, "buyingVoucher");
						return 1;
					}
					if(GetPVarInt(playerid, "buyingVoucher") == 6) // Priority Advertisement Voucher
					{
						if(PlayerInfo[sellerid][pAdvertVoucher] < amount) return SendClientMessageEx(playerid, COLOR_GRAD1, "The seller does not have that many anymore.");

						GivePlayerCash(playerid, -price);
						GivePlayerCash(sellerid, price);
						format(szMessage, sizeof(szMessage), "* You have bought %d Priority Advertisement Voucher(s) for $%s from %s.", amount, number_format(price), GetPlayerNameEx(sellerid));
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
						format(szMessage, sizeof(szMessage), "* %s has bought %d Priority Advertisement Voucher(s) from you, $%s was added to your money.", GetPlayerNameEx(playerid), amount, number_format(price));
						SendClientMessageEx(sellerid, COLOR_LIGHTBLUE, szMessage);
						format(szMessage, sizeof(szMessage), "%s(%d) (IP:%s) has bought (%d) Priority Advertisement Voucher(s) for $%s from %s(%d) (IP:%s)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), amount, number_format(price),  GetPlayerNameEx(sellerid), GetPlayerSQLId(sellerid), GetPlayerIpEx(sellerid));
						Log("logs/pay.log", szMessage);
						PlayerInfo[playerid][pAdvertVoucher] += amount;
						PlayerInfo[sellerid][pAdvertVoucher] -= amount;

						OnPlayerStatsUpdate(playerid);
						OnPlayerStatsUpdate(sellerid);

						DeletePVar(playerid, "buyingVoucher");
						return 1;
					}
					if(GetPVarInt(playerid, "buyingVoucher") == 7) // 7 Days Silver VIP
					{
						if(PlayerInfo[sellerid][pSVIPExVoucher] < amount) return SendClientMessageEx(playerid, COLOR_GRAD1, "The seller does not have that many anymore.");

						GivePlayerCash(playerid, -price);
						GivePlayerCash(sellerid, price);
						format(szMessage, sizeof(szMessage), "* You have bought %d 7 Days Silver VIP Voucher(s) for $%s from %s.", amount, number_format(price), GetPlayerNameEx(sellerid));
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
						format(szMessage, sizeof(szMessage), "* %s has bought %d 7 Days Silver VIP Voucher(s) from you, $%s was added to your money.", GetPlayerNameEx(playerid), amount, number_format(price));
						SendClientMessageEx(sellerid, COLOR_LIGHTBLUE, szMessage);
						format(szMessage, sizeof(szMessage), "%s(%d) (IP:%s) has bought (%d) 7 Day Silver VIP Voucher(s) for $%s from %s(%d) (IP:%s)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), amount, number_format(price),  GetPlayerNameEx(sellerid), GetPlayerSQLId(sellerid), GetPlayerIpEx(sellerid));
						Log("logs/pay.log", szMessage);
						PlayerInfo[playerid][pSVIPExVoucher] += amount;
						PlayerInfo[sellerid][pSVIPExVoucher] -= amount;

						OnPlayerStatsUpdate(playerid);
						OnPlayerStatsUpdate(sellerid);

						DeletePVar(playerid, "buyingVoucher");
						return 1;
					}
					if(GetPVarInt(playerid, "buyingVoucher") == 8) // 7 Days Gold VIP
					{
						if(PlayerInfo[sellerid][pGVIPExVoucher] < amount) return SendClientMessageEx(playerid, COLOR_GRAD1, "The seller does not have that many anymore.");

						GivePlayerCash(playerid, -price);
						GivePlayerCash(sellerid, price);
						format(szMessage, sizeof(szMessage), "* You have bought %d 7 Days Gold VIP Voucher(s) for $%s from %s.", amount, number_format(price), GetPlayerNameEx(sellerid));
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
						format(szMessage, sizeof(szMessage), "* %s has bought %d 7 Days Gold VIP Voucher(s) from you, $%s was added to your money.", GetPlayerNameEx(playerid), amount, number_format(price));
						SendClientMessageEx(sellerid, COLOR_LIGHTBLUE, szMessage);
						format(szMessage, sizeof(szMessage), "%s(%d) (IP:%s) has bought (%d) 7 Days Gold VIP Voucher(s) for $%s from %s(%d) (IP:%s)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), amount, number_format(price),  GetPlayerNameEx(sellerid), GetPlayerSQLId(sellerid), GetPlayerIpEx(sellerid));
						Log("logs/pay.log", szMessage);
						PlayerInfo[playerid][pGVIPExVoucher] += amount;
						PlayerInfo[sellerid][pGVIPExVoucher] -= amount;

						OnPlayerStatsUpdate(playerid);
						OnPlayerStatsUpdate(sellerid);

						DeletePVar(playerid, "buyingVoucher");
						return 1;
					}
				}
				else return SendClientMessageEx(playerid, COLOR_GRAD2, "No-One has offered you any vouchers.");
			}
			else return SendClientMessageEx(playerid, COLOR_GRAD2, "You do not have enough money.");
		}
        else if(strcmp(params,"craft",true) == 0) {
            if(CraftOffer[playerid] != INVALID_PLAYER_ID) {
                if(IsPlayerConnected(CraftOffer[playerid])) {
                    if (ProxDetectorS(5.0, playerid, CraftOffer[playerid])) {
                        if(PlayerInfo[playerid][pHospital] > 0) {
                            SendClientMessageEx(playerid, COLOR_GREY, "You can't spawn a weapon whilst in Hospital.");
                            return 1;
                        }

                        if(PlayerInfo[CraftOffer[playerid]][pMats] < CraftMats[playerid]) {

                        	CraftOffer[playerid] = INVALID_PLAYER_ID;
                       		CraftId[playerid] = 0;
                        	CraftMats[playerid] = 0;
                        	return SendClientMessageEx(playerid, COLOR_GREY, "The crafter does not have enough materials.");
                        }

                        if(IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD2, "Please exit the vehicle, before using this command.");
						if(CraftId[playerid] == 17)
						{
							if(PlayerInfo[playerid][pPhousekey] == INVALID_HOUSE_ID && PlayerInfo[playerid][pPhousekey2] == INVALID_HOUSE_ID && PlayerInfo[playerid][pPhousekey3] == INVALID_HOUSE_ID)
							{
								SendClientMessageEx(playerid, COLOR_GREY, "You don't own a house!");
								SendClientMessageEx(CraftOffer[playerid], COLOR_GREY, "The buyer doesn't own a house!");
								return 1;
							}
							if((IsPlayerInRangeOfPoint(playerid, 50.0, HouseInfo[PlayerInfo[playerid][pPhousekey]][hInteriorX], HouseInfo[PlayerInfo[playerid][pPhousekey]][hInteriorY], HouseInfo[PlayerInfo[playerid][pPhousekey]][hInteriorZ]) && GetPlayerVirtualWorld(playerid) == HouseInfo[PlayerInfo[playerid][pPhousekey]][hIntVW] && GetPlayerInterior(playerid) == HouseInfo[PlayerInfo[playerid][pPhousekey]][hIntIW]) &&
							(IsPlayerInRangeOfPoint(CraftOffer[playerid], 50.0, HouseInfo[PlayerInfo[playerid][pPhousekey]][hInteriorX], HouseInfo[PlayerInfo[playerid][pPhousekey]][hInteriorY], HouseInfo[PlayerInfo[playerid][pPhousekey]][hInteriorZ]) && GetPlayerVirtualWorld(CraftOffer[playerid]) == HouseInfo[PlayerInfo[playerid][pPhousekey]][hIntVW] && GetPlayerInterior(CraftOffer[playerid]) == HouseInfo[PlayerInfo[playerid][pPhousekey]][hIntIW]))
							{
							}
							else if((IsPlayerInRangeOfPoint(playerid, 50.0, HouseInfo[PlayerInfo[playerid][pPhousekey2]][hInteriorX], HouseInfo[PlayerInfo[playerid][pPhousekey2]][hInteriorY], HouseInfo[PlayerInfo[playerid][pPhousekey2]][hInteriorZ]) && GetPlayerVirtualWorld(playerid) == HouseInfo[PlayerInfo[playerid][pPhousekey2]][hIntVW] && GetPlayerInterior(playerid) == HouseInfo[PlayerInfo[playerid][pPhousekey2]][hIntIW]) &&
							(IsPlayerInRangeOfPoint(CraftOffer[playerid], 50.0, HouseInfo[PlayerInfo[playerid][pPhousekey2]][hInteriorX], HouseInfo[PlayerInfo[playerid][pPhousekey2]][hInteriorY], HouseInfo[PlayerInfo[playerid][pPhousekey2]][hInteriorZ]) && GetPlayerVirtualWorld(CraftOffer[playerid]) == HouseInfo[PlayerInfo[playerid][pPhousekey2]][hIntVW] && GetPlayerInterior(CraftOffer[playerid]) == HouseInfo[PlayerInfo[playerid][pPhousekey2]][hIntIW]))
							{
							}
							else if((IsPlayerInRangeOfPoint(playerid, 50.0, HouseInfo[PlayerInfo[playerid][pPhousekey3]][hInteriorX], HouseInfo[PlayerInfo[playerid][pPhousekey3]][hInteriorY], HouseInfo[PlayerInfo[playerid][pPhousekey3]][hInteriorZ]) && GetPlayerVirtualWorld(playerid) == HouseInfo[PlayerInfo[playerid][pPhousekey3]][hIntVW] && GetPlayerInterior(playerid) == HouseInfo[PlayerInfo[playerid][pPhousekey3]][hIntIW]) &&
							(IsPlayerInRangeOfPoint(CraftOffer[playerid], 50.0, HouseInfo[PlayerInfo[playerid][pPhousekey3]][hInteriorX], HouseInfo[PlayerInfo[playerid][pPhousekey3]][hInteriorY], HouseInfo[PlayerInfo[playerid][pPhousekey3]][hInteriorZ]) && GetPlayerVirtualWorld(CraftOffer[playerid]) == HouseInfo[PlayerInfo[playerid][pPhousekey3]][hIntVW] && GetPlayerInterior(CraftOffer[playerid]) == HouseInfo[PlayerInfo[playerid][pPhousekey3]][hIntIW]))
							{
							}
							else
							{
								SendClientMessageEx(playerid, COLOR_GREY, "The craftsman is not inside of your house!");
								SendClientMessageEx(CraftOffer[playerid], COLOR_GREY, "You are not inside of the buyer's house!");
								return 1;
							}
						}
                        new weaponname[50];
                        format(weaponname, 50, "%s", CraftName[playerid]);
                        switch(CraftId[playerid]) {
                            case 1:
                            {
                                PlayerInfo[playerid][pScrewdriver]++;
                                SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "/sellgun");
                            }
                            case 2:
                            {
                                PlayerInfo[playerid][pSmslog]++;
                                SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "/smslog");
                            }
                            case 3:
                            {
                                PlayerInfo[playerid][pWristwatch]++;
                                SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "/wristwatch");
                            }
                            case 4:
                            {
                                PlayerInfo[playerid][pSurveillance]++;
                                SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "/(p)lace(c)amera /(s)ee(c)amera /(d)estroy(c)amera");
                            }
                            case 5:
                            {
                                PlayerInfo[playerid][pTire]++;
                                SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "/repair");
                            }
                            case 6:
                            {
                                PlayerInfo[playerid][pLock]=1;
                                SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "/lock");
                            }
                            case 7:
                            {
                                PlayerInfo[playerid][pFirstaid]++;
                                SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "/firstaid");
                            }
                            case 8:
                            {
                                GivePlayerValidWeapon(playerid, 43);
                            }
                            case 9:
                            {
                                PlayerInfo[playerid][pRccam]++;
                                SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "/rccam");
                            }
                            case 10:
                            {
                                PlayerInfo[playerid][pReceiver]++;
                                SetPVarInt(playerid, "pReceiverMLeft", 4);
                                SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You will receive the next four department radio messages.");
                            }
                            case 11:
                            {
                                PlayerInfo[playerid][pGPS] = 1;
                                SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "/gps");
                            }
                            case 12:
                            {
                                PlayerInfo[playerid][pSweep]++;
                                PlayerInfo[playerid][pSweepLeft] = 3;
                                SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "/sweep");
                            }
                            case 13:
                            {
                                GivePlayerValidWeapon(playerid, 46);
                            }
							case 14:
							{

								if(PlayerInfo[playerid][pTreasureSkill] >=0 && PlayerInfo[playerid][pTreasureSkill] <= 24) PlayerInfo[playerid][pMetalDetector] += 25;
								else if(PlayerInfo[playerid][pTreasureSkill] >=25 && PlayerInfo[playerid][pTreasureSkill] <= 149) PlayerInfo[playerid][pMetalDetector] += 50;
								else if(PlayerInfo[playerid][pTreasureSkill] >=150 && PlayerInfo[playerid][pTreasureSkill] <= 299) PlayerInfo[playerid][pMetalDetector] += 75;
								else if(PlayerInfo[playerid][pTreasureSkill] >=300 && PlayerInfo[playerid][pTreasureSkill] <= 599) PlayerInfo[playerid][pMetalDetector] += 100;
								else if(PlayerInfo[playerid][pTreasureSkill] >=600) PlayerInfo[playerid][pMetalDetector] += 125;
								SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "/search");
							}
                            case 15:
                            {
                                PlayerInfo[playerid][pMailbox]++;
                                SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Type /placemailbox where you want mailbox to be at.");
                            }
							case 16:
							{
								if(PlayerInfo[playerid][pSyringes] < 3) {
									PlayerInfo[playerid][pSyringes]++;
									SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "/usedrug heroin");
								}
								else
								{
						    		SendClientMessageEx(playerid, COLOR_GREY, "You can't hold anymore syringes.");
						    		return 1;
								}
							}
							case 17:
							{
								if(IsPlayerInRangeOfPoint(playerid, 50.0, HouseInfo[PlayerInfo[playerid][pPhousekey]][hInteriorX], HouseInfo[PlayerInfo[playerid][pPhousekey]][hInteriorY], HouseInfo[PlayerInfo[playerid][pPhousekey]][hInteriorZ]) && IsPlayerInRangeOfPoint(CraftOffer[playerid], 50.0, HouseInfo[PlayerInfo[playerid][pPhousekey]][hInteriorX], HouseInfo[PlayerInfo[playerid][pPhousekey]][hInteriorY], HouseInfo[PlayerInfo[playerid][pPhousekey]][hInteriorZ]))
								{
									GetPlayerPos(playerid, HouseInfo[PlayerInfo[playerid][pPhousekey]][hClosetX], HouseInfo[PlayerInfo[playerid][pPhousekey]][hClosetY], HouseInfo[PlayerInfo[playerid][pPhousekey]][hClosetZ]);
									if(IsValidDynamic3DTextLabel(HouseInfo[PlayerInfo[playerid][pPhousekey]][hClosetTextID])) DestroyDynamic3DTextLabel(Text3D:HouseInfo[PlayerInfo[playerid][pPhousekey]][hClosetTextID]);
									HouseInfo[PlayerInfo[playerid][pPhousekey]][hClosetTextID] = CreateDynamic3DTextLabel("Closet\n/closet to use", 0xFFFFFF88, HouseInfo[PlayerInfo[playerid][pPhousekey]][hClosetX], HouseInfo[PlayerInfo[playerid][pPhousekey]][hClosetY], HouseInfo[PlayerInfo[playerid][pPhousekey]][hClosetZ]+0.5,10.0, .testlos = 1, .worldid = HouseInfo[PlayerInfo[playerid][pPhousekey]][hIntVW], .interiorid = HouseInfo[PlayerInfo[playerid][pPhousekey]][hIntIW], .streamdistance = 10.0);
									SaveHouse(PlayerInfo[playerid][pPhousekey]);
									SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "/closet(add/remove)");
								}
								else if(IsPlayerInRangeOfPoint(playerid, 50.0, HouseInfo[PlayerInfo[playerid][pPhousekey2]][hInteriorX], HouseInfo[PlayerInfo[playerid][pPhousekey2]][hInteriorY], HouseInfo[PlayerInfo[playerid][pPhousekey2]][hInteriorZ]) && IsPlayerInRangeOfPoint(CraftOffer[playerid], 50.0, HouseInfo[PlayerInfo[playerid][pPhousekey2]][hInteriorX], HouseInfo[PlayerInfo[playerid][pPhousekey2]][hInteriorY], HouseInfo[PlayerInfo[playerid][pPhousekey2]][hInteriorZ]))
								{
									GetPlayerPos(playerid, HouseInfo[PlayerInfo[playerid][pPhousekey2]][hClosetX], HouseInfo[PlayerInfo[playerid][pPhousekey2]][hClosetY], HouseInfo[PlayerInfo[playerid][pPhousekey2]][hClosetZ]);
									if(IsValidDynamic3DTextLabel(HouseInfo[PlayerInfo[playerid][pPhousekey2]][hClosetTextID])) DestroyDynamic3DTextLabel(Text3D:HouseInfo[PlayerInfo[playerid][pPhousekey2]][hClosetTextID]);
									HouseInfo[PlayerInfo[playerid][pPhousekey2]][hClosetTextID] = CreateDynamic3DTextLabel("Closet\n/closet to use", 0xFFFFFF88, HouseInfo[PlayerInfo[playerid][pPhousekey2]][hClosetX], HouseInfo[PlayerInfo[playerid][pPhousekey2]][hClosetY], HouseInfo[PlayerInfo[playerid][pPhousekey2]][hClosetZ]+0.5,10.0, .testlos = 1, .worldid = HouseInfo[PlayerInfo[playerid][pPhousekey2]][hIntVW], .interiorid = HouseInfo[PlayerInfo[playerid][pPhousekey2]][hIntIW], .streamdistance = 10.0);
									SaveHouse(PlayerInfo[playerid][pPhousekey2]);
									SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "/closet(add/remove)");
								}
								else if(IsPlayerInRangeOfPoint(playerid, 50.0, HouseInfo[PlayerInfo[playerid][pPhousekey3]][hInteriorX], HouseInfo[PlayerInfo[playerid][pPhousekey3]][hInteriorY], HouseInfo[PlayerInfo[playerid][pPhousekey3]][hInteriorZ]) && IsPlayerInRangeOfPoint(CraftOffer[playerid], 50.0, HouseInfo[PlayerInfo[playerid][pPhousekey3]][hInteriorX], HouseInfo[PlayerInfo[playerid][pPhousekey3]][hInteriorY], HouseInfo[PlayerInfo[playerid][pPhousekey3]][hInteriorZ]))
								{
									GetPlayerPos(playerid, HouseInfo[PlayerInfo[playerid][pPhousekey3]][hClosetX], HouseInfo[PlayerInfo[playerid][pPhousekey3]][hClosetY], HouseInfo[PlayerInfo[playerid][pPhousekey3]][hClosetZ]);
									if(IsValidDynamic3DTextLabel(HouseInfo[PlayerInfo[playerid][pPhousekey3]][hClosetTextID])) DestroyDynamic3DTextLabel(Text3D:HouseInfo[PlayerInfo[playerid][pPhousekey3]][hClosetTextID]);
									HouseInfo[PlayerInfo[playerid][pPhousekey3]][hClosetTextID] = CreateDynamic3DTextLabel("Closet\n/closet to use", 0xFFFFFF88, HouseInfo[PlayerInfo[playerid][pPhousekey3]][hClosetX], HouseInfo[PlayerInfo[playerid][pPhousekey3]][hClosetY], HouseInfo[PlayerInfo[playerid][pPhousekey3]][hClosetZ]+0.5,10.0, .testlos = 1, .worldid = HouseInfo[PlayerInfo[playerid][pPhousekey3]][hIntVW], .interiorid = HouseInfo[PlayerInfo[playerid][pPhousekey3]][hIntIW], .streamdistance = 10.0);
									SaveHouse(PlayerInfo[playerid][pPhousekey3]);
									SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "/closet(add/remove)");
								}
							}
							case 18:
							{
								PlayerInfo[playerid][pToolBox] += 15;
								SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Type /pickveh(icle) in any car to attempt to lock pick it.");
							}
							case 19:
							{
								PlayerInfo[playerid][pCrowBar] += 25;
								SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Type /cracktrunk in any car that you already lock picked to attempt to open the trunk.");
							}
							case 20: GivePlayerValidWeapon(playerid, WEAPON_FLOWER);
							case 21: GivePlayerValidWeapon(playerid, WEAPON_BRASSKNUCKLE);
							case 22: GivePlayerValidWeapon(playerid, WEAPON_BAT);
							case 23: GivePlayerValidWeapon(playerid, WEAPON_CANE);
							case 24: GivePlayerValidWeapon(playerid, WEAPON_SHOVEL);
							case 25: GivePlayerValidWeapon(playerid, WEAPON_POOLSTICK);
							case 26: GivePlayerValidWeapon(playerid, WEAPON_KATANA);
							case 27: GivePlayerValidWeapon(playerid, WEAPON_DILDO);
							case 28: GivePlayerValidWeapon(playerid, WEAPON_SPRAYCAN);
							case 29: {
								PlayerInfo[playerid][pRimMod]++;
								SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Type /userimkit as a mechanic in any car to modify your rims.");
							}
                        }
                        format(szMessage, sizeof(szMessage), "   You have given %s, a %s.", GetPlayerNameEx(playerid),weaponname);
                        PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
                        SendClientMessageEx(CraftOffer[playerid], COLOR_GRAD1, szMessage);
                        format(szMessage, sizeof(szMessage), "   You have recieved a %s from %s.", weaponname, GetPlayerNameEx(CraftOffer[playerid]));
                        SendClientMessageEx(playerid, COLOR_GRAD1, szMessage);
                        PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
                        format(szMessage, sizeof(szMessage), "* %s created something from Materials, and hands it to %s.", GetPlayerNameEx(CraftOffer[playerid]), GetPlayerNameEx(playerid));
                        ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
                        new ip[32], ipex[32];
                        GetPlayerIp(playerid, ip, sizeof(ip));
                        GetPlayerIp(CraftOffer[playerid], ipex, sizeof(ipex));
                        format(szMessage, sizeof(szMessage), "[CRAFTSMAN DEAL] %s(%d) (IP: %s) has bought a %s from %s(%d) (IP: %s)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ip, weaponname, GetPlayerNameEx(CraftOffer[playerid]), GetPlayerSQLId(CraftOffer[playerid]), ipex);
                        Log("logs/sell.log", szMessage);
                        PlayerInfo[CraftOffer[playerid]][pMats] -= CraftMats[playerid];
                        PlayerInfo[CraftOffer[playerid]][pArmsSkill]++;
                        CraftOffer[playerid] = INVALID_PLAYER_ID;
                        CraftId[playerid] = 0;
                        CraftMats[playerid] = 0;
                        return 1;
                    }
                    else {
                        SendClientMessageEx(playerid, COLOR_GRAD2, "You need to be the near the person that is selling you the weapon !");
                        return 1;
                    }
                }
                return 1;
            }
            else {
                SendClientMessageEx(playerid, COLOR_GREY, "   No-one offered you a craft!");
                return 1;
            }
        }
		else if(strcmp(params,"contract",true) == 0) {
			if(HitOffer[playerid] != INVALID_PLAYER_ID) {
				if(HitToGet[playerid] != INVALID_PLAYER_ID) {
					if(IsPlayerConnected(HitToGet[playerid])) {
						format(szMessage, sizeof(szMessage), "* %s has accepted the contract to kill %s.", GetPlayerNameEx(playerid),GetPlayerNameEx(HitToGet[playerid]));
						SendClientMessageEx(HitOffer[playerid], COLOR_LIGHTBLUE, szMessage);
						format(szMessage, sizeof(szMessage), "* You have accepted the contract to kill %s, you will recieve $%d when completed.", GetPlayerNameEx(HitToGet[playerid]), PlayerInfo[HitToGet[playerid]][pHeadValue]);
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
						format(szMessage, sizeof(szMessage), "%s has been assigned to the contract on %s, for $%d.", GetPlayerNameEx(playerid), GetPlayerNameEx(HitToGet[playerid]),  PlayerInfo[HitToGet[playerid]][pHeadValue]);
						foreach(new i: Player) if(IsAHitman(i)) SendClientMessage(i, COLOR_YELLOW, szMessage);
						//SendClientMessage(playerid, COLOR_LIGHTBLUE, "Hit accepted.  Wait 15 seconds for the final go ahead from the Agency.");
						//SetPVarInt(playerid, "HitCooldown", 15);
						GoChase[playerid] = HitToGet[playerid];
						GetChased[HitToGet[playerid]] = playerid;
						GotHit[HitToGet[playerid]] = 1;
						HitToGet[playerid] = INVALID_PLAYER_ID;
						HitOffer[playerid] = INVALID_PLAYER_ID;
						return 1;
					}
					else {
						HitToGet[playerid] = INVALID_PLAYER_ID;
						HitOffer[playerid] = INVALID_PLAYER_ID;
						return 1;
					}
				}
			}
			else {
				SendClientMessageEx(playerid, COLOR_GREY, "   No-one offered you a contract!");
				return 1;
			}
		}
        else if(strcmp(params,"sex",true) == 0) {
            if(SexOffer[playerid] != INVALID_PLAYER_ID) {
                if(GetPlayerCash(playerid) > SexPrice[playerid]) {
                    if (IsPlayerConnected(SexOffer[playerid])) {
                        new Car = GetPlayerVehicleID(playerid);
                        if(IsPlayerInAnyVehicle(playerid) && IsPlayerInVehicle(SexOffer[playerid], Car)) {
                            GetPlayerName(SexOffer[playerid], giveplayer, sizeof(giveplayer));
                            GetPlayerName(playerid, sendername, sizeof(sendername));
                            format(szMessage, sizeof(szMessage), "* You had sex with Whore %s, for $%s.", giveplayer, number_format(SexPrice[playerid]));
                            SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
                            format(szMessage, sizeof(szMessage), "* %s had sex with you. You have earned $%d.", sendername, SexPrice[playerid]);
                            SendClientMessageEx(SexOffer[playerid], COLOR_LIGHTBLUE, szMessage);

                            new ip[32], ipex[32];
                            GetPlayerIp(playerid, ip, sizeof(ip));
                            GetPlayerIp(SexOffer[playerid], ipex, sizeof(ipex));
                            format(szMessage, sizeof(szMessage), "[SEX] %s(%d) (IP:%s) had sex with %s(%d) (IP:%s) for %d.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ip, GetPlayerNameEx(SexOffer[playerid]), GetPlayerSQLId(SexOffer[playerid]), ipex, SexPrice[playerid]);
                            Log("logs/sell.log", szMessage);

                            if(SexPrice[playerid] >= 25000 && (PlayerInfo[SexOffer[playerid]][pLevel] <= 3 || PlayerInfo[playerid][pLevel] <= 3)) {
                                format(szMessage, sizeof(szMessage), "%s(%d) (IP:%s) had sex with %s(%d) (IP:%s) for $%s in this session.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ip, GetPlayerNameEx(SexOffer[playerid]), GetPlayerSQLId(SexOffer[playerid]), ipex, number_format(SexPrice[playerid]));
                                Log("logs/sell.log", szMessage);
                                format(szMessage, sizeof(szMessage), "%s (IP:%s) had sex with %s (IP:%s) for $%s in this session.", GetPlayerNameEx(playerid), ip, GetPlayerNameEx(SexOffer[playerid]), ipex, number_format(SexPrice[playerid]));
                                ABroadCast(COLOR_YELLOW, szMessage, 2);
                            }

                            ExtortionTurfsWarsZone(SexOffer[playerid], 6, SexPrice[playerid]);
                            GivePlayerCash(SexOffer[playerid], SexPrice[playerid]);
                            GivePlayerCash(playerid, -SexPrice[playerid]);

  							if(PlayerInfo[SexOffer[playerid]][pDoubleEXP] > 0)
							{
								format(szMessage, sizeof(szMessage), "You have gained 2 whore skill points instead of 1. You have %d hours left on the Double EXP token.", PlayerInfo[SexOffer[playerid]][pDoubleEXP]);
								SendClientMessageEx(SexOffer[playerid], COLOR_YELLOW, szMessage);
   								PlayerInfo[SexOffer[playerid]][pSexSkill] += 2;
							}
							else
							{
  								PlayerInfo[SexOffer[playerid]][pSexSkill] += 1;
							}

                            if(PlayerInfo[SexOffer[playerid]][pSexSkill] == 50) {
                                SendClientMessageEx(SexOffer[playerid], COLOR_YELLOW, "* Your Sex Skill is now Level 2, you offer better Sex (health) and less chance on STI.");
                            }
                            else if(PlayerInfo[SexOffer[playerid]][pSexSkill] == 100) {
                                SendClientMessageEx(SexOffer[playerid], COLOR_YELLOW, "* Your Sex Skill is now Level 3, you offer better Sex (health) and less chance on STI.");
                            }
                            else if(PlayerInfo[SexOffer[playerid]][pSexSkill] == 200) {
                                SendClientMessageEx(SexOffer[playerid], COLOR_YELLOW, "* Your Sex Skill is now Level 4, you offer better Sex (health) and less chance on STI.");
                            }
                            else if(PlayerInfo[SexOffer[playerid]][pSexSkill] == 400) {
                                SendClientMessageEx(SexOffer[playerid], COLOR_YELLOW, "* Your Sex Skill is now Level 5, you offer better Sex (health) and less chance on STI.");
                            }

                            if(!GetPVarType(playerid, "STD")) {
                                if(Condom[playerid] == 0) {
                                    new Float:health;
                                    new level = PlayerInfo[SexOffer[playerid]][pSexSkill];
                                    if(level >= 0 && level <= 50) {
                                        GetHealth(playerid, health);
                                        if(health < 100) {
                                            if(health > 90) {
                                                SetHealth(playerid, 100);
                                            }
                                            else {
                                                SetHealth(playerid, health + 10.0);
                                            }
                                        }
                                        new rand = random(sizeof(STD1));
                                        SetPVarInt(playerid, "STD", STD1[rand]);
                                        SetPVarInt(SexOffer[playerid], "STD", STD1[rand]);
                                        if(STD1[rand] == 0) {
                                            SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You got 10 Health + no STI while having Sex."); SendClientMessageEx(SexOffer[playerid], COLOR_LIGHTBLUE, "* You haven't got a STI while having Sex.");
                                        }
                                        else if(STD1[rand] == 1) { SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You got 10 Health and Chlamydia because of unsafe sex."); SendClientMessageEx(SexOffer[playerid], COLOR_LIGHTBLUE, "* You received Chlamydia because of unsafe sex."); }
                                        else if(STD1[rand] == 2) { SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You got 10 Health and Gonorrhea because of unsafe sex."); SendClientMessageEx(SexOffer[playerid], COLOR_LIGHTBLUE, "* You received Gonorrhea because of unsafe sex."); }
                                        else if(STD1[rand] == 3) { SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You got 10 Health and Syphilis because of unsafe sex."); SendClientMessageEx(SexOffer[playerid], COLOR_LIGHTBLUE, "* You received Syphilis because of unsafe sex."); }
                                    }
                                    else if(level >= 51 && level <= 100) {
                                        GetHealth(playerid, health);
                                        if(health < 100) {
                                            if(health > 80) {
                                                SetHealth(playerid, 100);
                                            }
                                            else {
                                                SetHealth(playerid, health + 20.0);
                                            }
                                        }
                                        new rand = random(sizeof(STD2));
                                        SetPVarInt(playerid, "STD", STD2[rand]);
                                        SetPVarInt(SexOffer[playerid], "STD", STD2[rand]);
                                        if(STD2[rand] == 0) { SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You got 20 Health + no STD while having Sex."); SendClientMessageEx(SexOffer[playerid], COLOR_LIGHTBLUE, "* You haven't got a STI while having Sex."); }
                                        else if(STD2[rand] == 1) { SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You got 20 Health and Chlamydia because of unsafe sex."); SendClientMessageEx(SexOffer[playerid], COLOR_LIGHTBLUE, "* You received Chlamydia because of unsafe sex."); }
                                        else if(STD2[rand] == 2) { SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You got 20 Health and Gonorrhea because of unsafe sex."); SendClientMessageEx(SexOffer[playerid], COLOR_LIGHTBLUE, "* You received Gonorrhea because of unsafe sex."); }
                                        else if(STD2[rand] == 3) { SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You got 20 Health and Syphilis because of unsafe sex."); SendClientMessageEx(SexOffer[playerid], COLOR_LIGHTBLUE, "* You received Syphilis because of unsafe sex."); }
                                    }
                                    else if(level >= 101 && level <= 200) {
                                        GetHealth(playerid, health);
                                        if(health < 100) {
                                            if(health > 70) {
                                                SetHealth(playerid, 100);
                                            }
                                            else {
                                                SetHealth(playerid, health + 30.0);
                                            }
                                        }
                                        new rand = random(sizeof(STD3));
                                        SetPVarInt(playerid, "STD", STD3[rand]);
                                        SetPVarInt(SexOffer[playerid], "STD", STD3[rand]);
                                        if(STD3[rand] == 0) { SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You got 30 Health + no STI while having Sex."); SendClientMessageEx(SexOffer[playerid], COLOR_LIGHTBLUE, "* You haven't got a STI while having Sex."); }
                                        else if(STD3[rand] == 1) { SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You got 30 Health and Chlamydia because of unsafe sex."); SendClientMessageEx(SexOffer[playerid], COLOR_LIGHTBLUE, "* You received Chlamydia because of unsafe sex."); }
                                        else if(STD3[rand] == 2) { SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You got 30 Health and Gonorrhea because of unsafe sex."); SendClientMessageEx(SexOffer[playerid], COLOR_LIGHTBLUE, "* You received Gonorrhea because of unsafe sex."); }
                                        else if(STD3[rand] == 3) { SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You got 30 Health and Syphilis because of unsafe sex."); SendClientMessageEx(SexOffer[playerid], COLOR_LIGHTBLUE, "* You received Syphilis because of unsafe sex."); }
                                    }
                                    else if(level >= 201 && level <= 400) {
                                        GetHealth(playerid, health);
                                        if(health < 100) {
                                            if(health > 60) {
                                                SetHealth(playerid, 100);
                                            }
                                            else {
                                                SetHealth(playerid, health + 40.0);
                                            }
                                        }
                                        new rand = random(sizeof(STD4));
                                        SetPVarInt(playerid, "STD", STD4[rand]);
                                        SetPVarInt(SexOffer[playerid], "STD", STD4[rand]);
                                        if(STD4[rand] == 0) { SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You got 40 Health + no STI while having Sex."); SendClientMessageEx(SexOffer[playerid], COLOR_LIGHTBLUE, "* You haven't got a STI while having Sex."); }
                                        else if(STD4[rand] == 1) { SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You got 40 Health and Chlamydia because of unsafe sex."); SendClientMessageEx(SexOffer[playerid], COLOR_LIGHTBLUE, "* You received Chlamydia because of unsafe sex."); }
                                        else if(STD4[rand] == 2) { SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You got 40 Health and Gonorrhea because of unsafe sex."); SendClientMessageEx(SexOffer[playerid], COLOR_LIGHTBLUE, "* You received Gonorrhea because of unsafe sex."); }
                                        else if(STD4[rand] == 3) { SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You got 40 Health and Syphilis because of unsafe sex."); SendClientMessageEx(SexOffer[playerid], COLOR_LIGHTBLUE, "* You received Syphilis because of unsafe sex."); }
                                    }
                                    else if(level >= 401) {
                                        GetHealth(playerid, health);
                                        if(health > 50) {
                                            SetHealth(playerid, 100);
                                        }
                                        else {
                                            SetHealth(playerid, health + 50.0);
                                        }
                                        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Your sex skill level was high enough to give them a lot of health and no STD.");
                                        SendClientMessageEx(SexOffer[playerid], COLOR_LIGHTBLUE, "* The whore's sex skill level was high enough to give you a lot of health and no STD.");
                                    }
                                }
                                else {
                                    SendClientMessageEx(SexOffer[playerid], COLOR_LIGHTBLUE, "* The person used a Condom.");
                                    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You used a Condom.");
                                    Condom[playerid] --;
                                }
                            }
                            else {
                                SendClientMessageEx(SexOffer[playerid], COLOR_LIGHTBLUE, "* That person was already infected with a STD, can't get another one.");
								SexOffer[playerid] = INVALID_PLAYER_ID;
                                return 1;
                            }
                            SexOffer[playerid] = INVALID_PLAYER_ID;
                            return 1;
                        }
                        else {
                            SendClientMessageEx(playerid, COLOR_GREY, "   You or the Whore are not both in a Car!");
                            return 1;
                        }
                    }                             //Connected or not
                    return 1;
                }
                else {
                    SendClientMessageEx(playerid, COLOR_GREY, "   You can't afford the Sex!");
                    return 1;
                }
            }
            else {
                SendClientMessageEx(playerid, COLOR_GREY, "   No sex has been offered!");
                return 1;
            }
        }
        else if(strcmp(params,"repair",true) == 0) {
            if(RepairOffer[playerid] != INVALID_PLAYER_ID) {
                if(GetPlayerCash(playerid) > RepairPrice[playerid]) {
                    if(IsPlayerInAnyVehicle(playerid)) {
                        if(IsPlayerConnected(RepairOffer[playerid])) {
                            RepairCar[playerid] = GetPlayerVehicleID(playerid);
                            RepairVehicle(RepairCar[playerid]);
							Vehicle_Armor(RepairCar[playerid]);
                            PlayerInfo[RepairOffer[playerid]][pTire]--;

                            GivePlayerCash(RepairOffer[playerid], RepairPrice[playerid]);
                            GivePlayerCash(playerid, -RepairPrice[playerid]);
                            new ip[32], ipex[32];
                            GetPlayerIp(playerid, ip, sizeof(ip));
                            GetPlayerIp(RepairOffer[playerid], ipex, sizeof(ipex));
                            format(szMessage, sizeof(szMessage), "%s(%d) (IP:%s) has repaired the vehicle from %s(%d) (IP:%s) for $%d", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ip, GetPlayerNameEx(RepairOffer[playerid]), GetPlayerSQLId(RepairOffer[playerid]), ipex, RepairPrice[playerid]);
                            Log("logs/sell.log", szMessage);
                            format(szMessage, sizeof(szMessage), "* %s has repaired %s's vehicle.", GetPlayerNameEx(RepairOffer[playerid]), GetPlayerNameEx(playerid));
                            ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
                            format(szMessage, sizeof(szMessage), "* You repaired your car for $%d by Car Mechanic %s.",RepairPrice[playerid],GetPlayerNameEx(RepairOffer[playerid]));
                            SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);

                            if(RepairPrice[playerid] >= 25000 && (PlayerInfo[RepairOffer[playerid]][pLevel] <= 3 || PlayerInfo[RepairOffer[playerid]][pLevel] <= 3)) {
                                format(szMessage, sizeof(szMessage), "%s(%d) (IP:%s) has repaired %s(%d) (IP:%s) $%d in this session.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ip, GetPlayerNameEx(RepairOffer[playerid]), GetPlayerSQLId(RepairOffer[playerid]), ipex, RepairPrice[playerid]);
                                Log("logs/sell.log", szMessage);
								format(szMessage, sizeof(szMessage), "%s (IP:%s) has repaired %s (IP:%s) $%d in this session.", GetPlayerNameEx(playerid), ip, GetPlayerNameEx(RepairOffer[playerid]), ipex, RepairPrice[playerid]);
                                ABroadCast(COLOR_YELLOW, szMessage, 2);
                            }

                            format(szMessage, sizeof(szMessage), "* You fixed %s's car, the $%d has been added to your money on hand!",GetPlayerNameEx(playerid),RepairPrice[playerid]);
                            SendClientMessageEx(RepairOffer[playerid], COLOR_LIGHTBLUE, szMessage);

   							if(PlayerInfo[RepairOffer[playerid]][pDoubleEXP] > 0)
							{
								format(szMessage, sizeof(szMessage), "You have gained 2 mechanic skill points instead of 1. You have %d hours left on the Double EXP token.", PlayerInfo[RepairOffer[playerid]][pDoubleEXP]);
								SendClientMessageEx(RepairOffer[playerid], COLOR_YELLOW, szMessage);
   								PlayerInfo[RepairOffer[playerid]][pMechSkill] += 2;
							}
							else
							{
								PlayerInfo[RepairOffer[playerid]][pMechSkill] += 1;
							}

                            RepairOffer[playerid] = INVALID_PLAYER_ID;
                            RepairPrice[playerid] = 0;
                            return 1;
                        }
                        return 1;
                    }
                    return 1;
                }
                else {
                    SendClientMessageEx(playerid, COLOR_GREY, "   You can't afford the Repair!");
                    return 1;
                }
            }
            else {
                SendClientMessageEx(playerid, COLOR_GREY, "   No-one offered you to Repair your Car!");
                return 1;
            }
        }
        else if(strcmp(params,"refill",true) == 0) {
            if(RefillOffer[playerid] != INVALID_PLAYER_ID) {
                if(GetPlayerCash(playerid) > RefillPrice[playerid]) {
                    if(IsPlayerInAnyVehicle(playerid)) {
                        if(IsPlayerConnected(RefillOffer[playerid])) {

	      					if(!ProxDetectorS(8.0, RefillOffer[playerid], playerid))
		  					{
								return SendClientMessageEx(playerid, COLOR_GREY, "You are not near the mechanic.");
							}
                            new Float:fueltogive;
                            new level = PlayerInfo[RefillOffer[playerid]][pMechSkill];
                            if(level >= 0 && level < 50) { fueltogive = 2.0; }
                            else if(level >= 50 && level < 100) { fueltogive = 4.0; }
                            else if(level >= 100 && level < 200) { fueltogive = 6.0; }
                            else if(level >= 200 && level < 400) { fueltogive = 8.0; }
                            else if(level >= 400) { fueltogive = 10.0; }
                            GetPlayerName(RefillOffer[playerid], giveplayer, sizeof(giveplayer));
                            GetPlayerName(playerid, sendername, sizeof(sendername));
                            new vehicleid = GetPlayerVehicleID(playerid);
                            VehicleFuel[vehicleid] = floatadd(VehicleFuel[vehicleid], fueltogive);
                            if(VehicleFuel[vehicleid] > 100.0) VehicleFuel[vehicleid] = 100.0;
                            for(new vehicleslot = 0; vehicleslot < MAX_PLAYERVEHICLES; vehicleslot++)
							{
								if(IsPlayerInVehicle(playerid, PlayerVehicleInfo[playerid][vehicleslot][pvId]))
								{
									if(vehicleslot != -1) {
										mysql_format(MainPipeline, szMessage, sizeof(szMessage), "UPDATE `vehicles` SET `pvFuel` = %0.5f WHERE `id` = '%d'", VehicleFuel[vehicleid], PlayerVehicleInfo[playerid][vehicleslot][pvSlotId]);
										mysql_tquery(MainPipeline, szMessage, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
									}
								}
							}
                            GivePlayerCash(RefillOffer[playerid], RefillPrice[playerid]);
                            GivePlayerCash(playerid, -RefillPrice[playerid]);
                            new ip[32], ipex[32];
                            GetPlayerIp(playerid, ip, sizeof(ip));
                            GetPlayerIp(RefillOffer[playerid], ipex, sizeof(ipex));
                            format(szMessage, sizeof(szMessage), "%s(%d) (IP:%s) has refilled the vehicle from %s(%d) (IP:%s) for $%d", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ip, GetPlayerNameEx(RefillOffer[playerid]), GetPlayerSQLId(RefillOffer[playerid]), ipex, RefillPrice[playerid]);
							Log("logs/sell.log", szMessage);
                            format(szMessage, sizeof(szMessage), "* %s has refilled %s's vehicle.", GetPlayerNameEx(RefillOffer[playerid]), GetPlayerNameEx(playerid));
                           	ProxChatBubble(playerid, szMessage);
                            // ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
                            format(szMessage, sizeof(szMessage), "* You have added %.2f fuel to your car for $%d by Car Mechanic %s.",fueltogive,RefillPrice[playerid],GetPlayerNameEx(RefillOffer[playerid]));
                            SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
                            format(szMessage, sizeof(szMessage), "* You added %.2f fuel to %s's car, the $%d has been added to your money on hand!",fueltogive,GetPlayerNameEx(playerid),RefillPrice[playerid]);
                            SendClientMessageEx(RefillOffer[playerid], COLOR_LIGHTBLUE, szMessage);

 							if(PlayerInfo[RefillOffer[playerid]][pDoubleEXP] > 0)
							{
								format(szMessage, sizeof(szMessage), "You have gained 2 mechanic skill points instead of 1. You have %d hours left on the Double EXP token.", PlayerInfo[RefillOffer[playerid]][pDoubleEXP]);
								SendClientMessageEx(RefillOffer[playerid], COLOR_YELLOW, szMessage);
   								PlayerInfo[RefillOffer[playerid]][pMechSkill] += 2;
							}
							else
							{
								PlayerInfo[RefillOffer[playerid]][pMechSkill] += 1;
							}

                            if(RefillPrice[playerid] >= 30000 && (PlayerInfo[playerid][pLevel] <= 3 || PlayerInfo[RefillOffer[playerid]][pLevel] <= 3)) {
                                format(szMessage, sizeof(szMessage), "%s(%d) (IP:%s) has refueled %s(%d) (IP:%s) $%d in this session.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ip, GetPlayerNameEx(RefillOffer[playerid]), GetPlayerSQLId(RefillOffer[playerid]), ipex, RefillPrice[playerid]);
                                Log("logs/sell.log", szMessage);
								format(szMessage, sizeof(szMessage), "%s (IP:%s) has refueled %s (IP:%s) $%d in this session.", GetPlayerNameEx(playerid), ip, GetPlayerNameEx(RefillOffer[playerid]), ipex, RefillPrice[playerid]);
                                ABroadCast(COLOR_YELLOW, szMessage, 2);
                            }

                            RefillOffer[playerid] = INVALID_PLAYER_ID;
                            RefillPrice[playerid] = 0;
                            return 1;
                        }
                        return 1;
                    }
                    return 1;
                }
                else {
                    SendClientMessageEx(playerid, COLOR_GREY, "   You can't afford the refill!");
                    return 1;
                }
            }
            else {
                SendClientMessageEx(playerid, COLOR_GREY, "   No-one offered you to refill your Car!");
                return 1;
            }
        }
		else if(strcmp(params, "backpack", true) == 0) {
			if(GetPVarType(playerid, "sellbackpack") && IsPlayerConnected(GetPVarInt(playerid, "sellbackpack")))
			{
				if(GetPlayerCash(playerid) > GetPVarInt(playerid, "sellbackpackprice"))
				{
					if(PlayerInfo[GetPVarInt(playerid, "sellbackpack")][pBackpack] < 1)	{
						SendClientMessageEx(playerid,COLOR_GREY, "That person does not have a backpack anymore!");
						return 1;
					}
					new btype[8];
					if(PlayerHoldingObject[playerid][9] != 0 || IsPlayerAttachedObjectSlotUsed(playerid, 9))
						RemovePlayerAttachedObject(playerid, 9), PlayerHoldingObject[playerid][9] = 0;
					switch(PlayerInfo[GetPVarInt(playerid, "sellbackpack")][pBackpack])
					{
						case 1:
						{
							btype = "Small";
							SetPlayerAttachedObject(playerid, 9, 371, 1, -0.002, -0.140999, -0.01, 8.69999, 88.8, -8.79993, 1.11, 0.963);
						}
						case 2:
						{
							btype = "Medium";
							SetPlayerAttachedObject(playerid, 9, 371, 1, -0.002, -0.140999, -0.01, 8.69999, 88.8, -8.79993, 1.11, 0.963);
						}
						case 3:
						{
							btype = "Large";
							SetPlayerAttachedObject(playerid, 9, 3026, 1, -0.254999, -0.109, -0.022999, 10.6, -1.20002, 3.4, 1.265, 1.242, 1.062);
						}
					}
					GivePlayerCash(playerid, -GetPVarInt(playerid, "sellbackpackprice"));
					GivePlayerCash(GetPVarInt(playerid, "sellbackpack"), GetPVarInt(playerid, "sellbackpackprice"));
					format(szMessage, sizeof(szMessage), "* You bought a %s Backpack for $%s from %s.",btype,number_format(GetPVarInt(playerid, "sellbackpackprice")),GetPlayerNameEx(GetPVarInt(playerid, "sellbackpack")));
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);
					format(szMessage, sizeof(szMessage), "* %s has bought your %s Backpack, $%s was added to your money.",GetPlayerNameEx(playerid),btype, number_format(GetPVarInt(playerid, "sellbackpackprice")));
					SendClientMessageEx(GetPVarInt(playerid, "sellbackpack"), COLOR_LIGHTBLUE, szMessage);


					PlayerInfo[playerid][pBackpack] = PlayerInfo[GetPVarInt(playerid, "sellbackpack")][pBackpack];
					PlayerInfo[playerid][pBEquipped] = 1;
					PlayerInfo[playerid][pBStoredH] = INVALID_HOUSE_ID;
					PlayerInfo[playerid][pBStoredV] = INVALID_PLAYER_VEHICLE_ID;
					RemovePlayerAttachedObject(GetPVarInt(playerid, "sellbackpack"), 9);

					PlayerInfo[GetPVarInt(playerid, "sellbackpack")][pBackpack] = 0;
					PlayerInfo[GetPVarInt(playerid, "sellbackpack")][pBEquipped] = 0;
					PlayerInfo[GetPVarInt(playerid, "sellbackpack")][pBStoredH] = INVALID_HOUSE_ID;
					PlayerInfo[GetPVarInt(playerid, "sellbackpack")][pBStoredV] = INVALID_PLAYER_VEHICLE_ID;
					for(new i = 0; i < 10; i++)
					{
						PlayerInfo[GetPVarInt(playerid, "sellbackpack")][pBItems][i] = 0;
					}

					format(szMessage, sizeof(szMessage), "%s(%d) (IP:%s) has bought %s Backpack for $%s from %s(%d) (IP:%s)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), btype, number_format(GetPVarInt(playerid, "sellbackpackprice")),  GetPlayerNameEx(GetPVarInt(playerid, "sellbackpack")), GetPlayerSQLId(GetPVarInt(playerid, "sellbackpack")), GetPlayerIpEx(GetPVarInt(playerid, "sellbackpack")));
					Log("logs/pay.log", szMessage);
					Log("logs/backpack.log", szMessage);

					OnPlayerStatsUpdate(playerid);
					OnPlayerStatsUpdate(GetPVarInt(playerid, "sellbackpack"));
					DeletePVar(GetPVarInt(playerid, "sellbackpack"), "sellingbackpack");
					DeletePVar(playerid, "sellbackpack");
					DeletePVar(playerid, "sellbackpackprice");
					return 1;
	     		}
	      		else
				{
	            	SendClientMessageEx(playerid, COLOR_GREY, "You can't afford the backpack!");
					DeletePVar(playerid, "sellbackpack");
	                DeletePVar(playerid, "sellbackpackprice");
	                return 1;
	        	}
			}
		}
        return 1;
    }                                             //not connected
    return 1;
}

CMD:cancel(playerid, params[])
{
	new string[128], choice[32];
	if(sscanf(params, "s[32]", choice))
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "|__________________ Cancel __________________|");
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /cancel [name]");
		SendClientMessageEx(playerid, COLOR_GREY, "Available names: Sex, Mats, Cannabis, Crack, Weapon, Craft, Repair, Lawyer, Bodyguard, Live, Refill, Car, Boxing");
		SendClientMessageEx(playerid, COLOR_GREY, "Available names: Taxi, Bus, Medic, Mechanic, Ticket, Witness, Marriage, Drink, House, Shipment, Help, Firstaid, Garbage");
		SendClientMessageEx(playerid, COLOR_GREY, "Available names: FoodOffer, RenderAid, DrugRun");
		if(PlayerInfo[playerid][pTut] != -1) SendClientMessageEx(playerid, COLOR_GREY, "Special: objectives");
		if(IsAHitman(playerid)) { SendClientMessageEx(playerid, COLOR_GREY, "Special: contract"); }
		SendClientMessageEx(playerid, COLOR_WHITE, "|____________________________________________|");
		return 1;
	}

	if(strcmp(choice, "objectives", true) == 0 && PlayerInfo[playerid][pTut] >= 15)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "-----------------------------");
		SendClientMessageEx(playerid, COLOR_WHITE, "You have canceled the objectives tutorial. Welcome to Next Generation Gaming!");
		SendClientMessageEx(playerid, COLOR_GREY, "-----------------------------");
		PlayerInfo[playerid][pTut] = -1;
		DisablePlayerCheckpoint(playerid);
	}

	if(strcmp(choice, "door", true) == 0)
	{
		if(gPlayerLogged{playerid} == 0) return SendClientMessageEx(playerid, COLOR_GREY, "You are not logged into your account.");
		if(DDSalePendingAdmin[playerid] == false && DDSalePendingPlayer[playerid] == false) return SendClientMessageEx(playerid, COLOR_GREY, "You do not have a pending dynamic door sale.");
		ClearDoorSaleVariables(playerid);
	}
	else if(strcmp(choice,"renderaid",true) == 0) DeletePVar(playerid, "renderaid");
	else if(strcmp(choice,"sex",true) == 0) {
		if(GetPVarType(playerid, "SexOfferTo")) {
			SexOffer[GetPVarInt(playerid, "SexOfferTo")] = INVALID_PLAYER_ID;
			SexPrice[GetPVarInt(playerid, "SexOfferTo")] = 0;
			DeletePVar(playerid, "SexOfferTo");
		}
		else {
			SexOffer[playerid] = INVALID_PLAYER_ID; SexPrice[playerid] = 0;
		}
	}
	else if(strcmp(choice,"craft",true) == 0) { CraftOffer[playerid] = INVALID_PLAYER_ID; CraftId[playerid] = 0; }
	else if(strcmp(choice,"repair",true) == 0) {
		if(GetPVarType(playerid, "RepairOfferTo")) {
			RepairOffer[GetPVarInt(playerid, "RepairOfferTo")] = INVALID_PLAYER_ID;
			RepairPrice[GetPVarInt(playerid, "RepairOfferTo")] = 0;
			RepairCar[GetPVarInt(playerid, "RepairOfferTo")] = 0;
			DeletePVar(playerid, "RepairOfferTo");
		}
		else {
			RepairOffer[playerid] = INVALID_PLAYER_ID; RepairPrice[playerid] = 0; RepairCar[playerid] = 0;
		}
	}
	else if(strcmp(choice,"lawyer",true) == 0) { WantLawyer[playerid] = 0; CallLawyer[playerid] = 0; }
	else if(strcmp(choice,"bodyguard",true) == 0) { GuardOffer[playerid] = INVALID_PLAYER_ID; GuardPrice[playerid] = 0; }
	else if(strcmp(choice,"live",true) == 0) { LiveOffer[playerid] = INVALID_PLAYER_ID; }
	else if(strcmp(choice,"refill",true) == 0) { RefillOffer[playerid] = INVALID_PLAYER_ID; RefillPrice[playerid] = 0; }
	else if(strcmp(choice,"car",true) == 0) { VehicleOffer[playerid] = INVALID_PLAYER_ID; VehiclePrice[playerid] = 0; VehicleId[playerid] = -1; }
	else if(strcmp(choice,"house",true) == 0) { HouseOffer[playerid] = INVALID_PLAYER_ID; HousePrice[playerid] = 0; House[playerid] = 0; }
	else if(strcmp(choice,"boxing",true) == 0) { BoxOffer[playerid] = INVALID_PLAYER_ID; }
	else if(strcmp(choice,"witness",true) == 0) { MarryWitnessOffer[playerid] = INVALID_PLAYER_ID; }
	else if(strcmp(choice,"marriage",true) == 0) { DeletePVar(ProposeOffer[playerid], "marriagelastname"), ProposeOffer[playerid] = INVALID_PLAYER_ID, DeletePVar(playerid, "marriagelastname"); }
	//else if(strcmp(choice,"divorce",true) == 0) { DivorceOffer[playerid] = INVALID_PLAYER_ID; }
	else if(strcmp(choice,"drink",true) == 0) { DrinkOffer[playerid] = INVALID_PLAYER_ID; }
	else if(strcmp(choice,"firstaid",true) == 0)
	{
		if(GetPVarInt(playerid, "usingfirstaid"))
		{
			KillTimer(GetPVarInt(playerid, "firstaid5"));
			SetPVarInt(playerid, "usingfirstaid", 0);
		}
	}
	else if(strcmp(choice,"drugrun",true) == 0)
	{
		if(GetPVarInt(playerid, "pDrugRun"))
		{
			Player_KillCheckPoint(playerid);
			DeletePVar(playerid, "pDrugRun");
			DeletePVar(playerid, "pDrugBoat");
			DeletePVar(playerid, "pPotPackages");
			DeletePVar(playerid, "pCrackPackages");
			DeletePVar(playerid, "pMethPackages");
			DeletePVar(playerid, "pEcstasyPackages");
		}
	}
	else if(strcmp(choice,"shipment",true) == 0)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(vehicleid == 0) return SendClientMessageEx(playerid, COLOR_WHITE, "You need to be in a valid vehicle.");
 		DeletePVar(playerid, "LoadTruckTime");
		DeletePVar(playerid, "TruckDeliver");

		TruckContents{vehicleid} = 0;
		if((0 <= TruckDeliveringTo[vehicleid] < MAX_BUSINESSES)) Businesses[TruckDeliveringTo[vehicleid]][bOrderState] = 0;
		TruckDeliveringTo[vehicleid] = INVALID_BUSINESS_ID;

		TruckUsed[playerid] = INVALID_VEHICLE_ID;
		gPlayerCheckpointStatus[playerid] = CHECKPOINT_NONE;
 		DisablePlayerCheckpoint(playerid);
	}
	else if(strcmp(choice,"garbage",true) == 0)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(vehicleid == 0) return SendClientMessageEx(playerid, COLOR_WHITE, "You need to be in a valid vehicle.");
 		DeletePVar(playerid, "pGarbageRun");
		DeletePVar(playerid, "pGarbageStage");

 		DisablePlayerCheckpoint(playerid);
	}
	else if(strcmp(choice,"help", true) == 0)
	{
	    if(GetPVarInt(playerid, "COMMUNITY_ADVISOR_REQUEST") == 1)
	    {
		    DeletePVar(playerid, "COMMUNITY_ADVISOR_REQUEST");
			DeletePVar(playerid, "HelpTime");
			DeletePVar(playerid, "HelpReason");
		}
		else {
		    SendClientMessageEx(playerid, COLOR_GRAD2, "You did not requested help.");
		    return 1;
		}
	}
	else if(strcmp(choice,"contract",true) == 0)
	{
		if(GoChase[playerid] != INVALID_PLAYER_ID || HitToGet[playerid] != INVALID_PLAYER_ID) {
			new Float:health;
			GetHealth(playerid, health);
			new hpint = floatround( health, floatround_round );
			if (hpint >=  80)
			{
				HitToGet[playerid] = INVALID_PLAYER_ID;
				HitOffer[playerid] = INVALID_PLAYER_ID;
				GetChased[GoChase[playerid]] = INVALID_PLAYER_ID;
				GotHit[GoChase[playerid]] = 0;
				GoChase[playerid] = INVALID_PLAYER_ID;
				DeletePVar(playerid, "HitCooldown");
			}
			else return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot cancel a contract with less than 80 percent health!");

		}
		else return SendClientMessageEx(playerid, COLOR_GRAD1, "You don't have an active contract!");
	}
	else if(strcmp(choice,"ticket",true) == 0) { TicketOffer[playerid] = INVALID_PLAYER_ID; TicketMoney[playerid] = 0; }
	else if(strcmp(choice,"medic",true) == 0) { if(IsPlayerConnected(MedicCall)) { if(MedicCall == playerid) { MedicCall = INVALID_PLAYER_ID; } else { SendClientMessageEx(playerid, COLOR_GREY, "   You are not the current Caller!"); return 1; } } }
	else if(strcmp(choice,"mechanic",true) == 0) { if(IsPlayerConnected(MechanicCall)) { if(MechanicCall == playerid) { MechanicCall = INVALID_PLAYER_ID; } else { SendClientMessageEx(playerid, COLOR_GREY, "   You are not the current Caller!"); return 1; } } }
	else if(strcmp(choice,"help",true) == 0) { if(GetPVarInt(playerid, "COMMUNITY_ADVISOR_REQUEST")) { DeletePVar(playerid, "COMMUNITY_ADVISOR_REQUEST"); } else { SendClientMessageEx(playerid, COLOR_GREY, "   You are not the current Caller!"); return 1; } }
	else if(strcmp(choice,"taxi",true) == 0)
	{
		if(TransportDuty[playerid] == 1 && TaxiCallTime[playerid] > 0)
		{
			GameTextForPlayer(TaxiAccepted[playerid], "~w~Taxi Driver~n~~r~Canceled the call", 5000, 1);
			DeletePVar(TaxiAccepted[playerid], "TaxiCall");
			TaxiAccepted[playerid] = INVALID_PLAYER_ID;
			GameTextForPlayer(playerid, "~w~You have~n~~r~Canceled the call", 5000, 1);
			TaxiCallTime[playerid] = 0;
			DisablePlayerCheckpoint(playerid);
		}
		else
		{
			if(GetPVarInt(playerid, "TaxiCall")) DeletePVar(playerid, "TaxiCall");
			else {
				foreach(new i: Player)
				{
					if(TaxiAccepted[i] != INVALID_PLAYER_ID && TaxiAccepted[i] == playerid)
					{
							GameTextForPlayer(i, "~w~Taxi Caller~n~~r~Canceled the call", 5000, 1);
							TaxiCallTime[i] = 0;
							DeletePVar(TaxiAccepted[i], "TaxiCall");
							TaxiAccepted[i] = INVALID_PLAYER_ID;
							DisablePlayerCheckpoint(i);
					}
				}
			}
		}
	}
	else if(strcmp(choice,"bus",true) == 0)
	{
		if(TransportDuty[playerid] == 2 && BusCallTime[playerid] > 0)
		{
			GameTextForPlayer(BusAccepted[playerid], "~w~Bus Driver~n~~r~Canceled the call", 5000, 1);
			DeletePVar(BusAccepted[playerid], "BusCall");
			BusAccepted[playerid] = INVALID_PLAYER_ID;
			GameTextForPlayer(playerid, "~w~You have~n~~r~Canceled the call", 5000, 1);
			BusCallTime[playerid] = 0;
			DisablePlayerCheckpoint(playerid);
		}
		else
		{
			foreach(new i: Player)
			{
				if(BusAccepted[i] != INVALID_PLAYER_ID && BusAccepted[i] == playerid)
				{
					GameTextForPlayer(i, "~w~Bus Caller~n~~r~Canceled the call", 5000, 1);
					BusCallTime[i] = 0;
					DeletePVar(BusAccepted[i], "BusCall");
					BusAccepted[i] = INVALID_PLAYER_ID;
					DisablePlayerCheckpoint(i);
				}
			}
		}
	}
	else if(strcmp(choice,"foodoffer",true) == 0) {
		new offeredTo = GetPVarInt(playerid, "OfferedMealTo");
		DeletePVar(offeredTo, "OfferedMeal");
		DeletePVar(offeredTo, "OfferedMealBy");
		DeletePVar(playerid, "OfferingMeal");
		DeletePVar(playerid, "OfferedMealTo");
	}
	else { return 1; }
	format(string, sizeof(string), "* You have canceled: %s.", choice);
	SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	return 1;
}

timer Cooldown_Mechanic[10000](playerid) {
	DeletePVar(playerid, "MCH_CLDWN");
}

CMD:refill(playerid, params[])
{
	if(PlayerInfo[playerid][pJob] != 7 && PlayerInfo[playerid][pJob2] != 7 && PlayerInfo[playerid][pJob3] != 7)
	{
		return SendClientMessageEx(playerid, COLOR_GREY, "You're not a mechanic.");
	}

	new string[128];
	if(gettime() < PlayerInfo[playerid][pMechTime])
	{
		format(string, sizeof(string), "You must wait %d seconds!", PlayerInfo[playerid][pMechTime]-gettime());
		return SendClientMessageEx(playerid, COLOR_GRAD1,string);
	}
	new giveplayerid, money;
	if(sscanf(params, "ud", giveplayerid, money)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /refill [player] [price]");

	if(!(money >= 1 && money < 100000))
	{
		return SendClientMessageEx(playerid, COLOR_GREY, "Invalid price specified - can't be lower than 1 or higher than $99,999.");
	}
	if(IsPlayerConnected(giveplayerid))
	{
		if(ProxDetectorS(8.0, playerid, giveplayerid) && IsPlayerInAnyVehicle(giveplayerid))
		{

			new Float: fueltogive;
			switch(PlayerInfo[playerid][pMechSkill])
			{
			case 0 .. 49: fueltogive = 2.0;
			case 50 .. 99: fueltogive = 4.0;
			case 100 .. 199: fueltogive = 6.0;
			case 200 .. 399: fueltogive = 8.0;
			default: fueltogive = 10.0;
			}
			if(giveplayerid == playerid)
			{
				if(PlayerInfo[playerid][pMechSkill] >= 400)
				{
					if(GetPVarType(playerid, "MCH_CLDWN")) return SendClientMessageEx(playerid, COLOR_GRAD1, "You can't refill so fast!");

					SetPVarInt(playerid, "MCH_CLDWN", 1);
					defer Cooldown_Mechanic(playerid);

					new vehicleid = GetPlayerVehicleID(playerid);
					VehicleFuel[vehicleid] = VehicleFuel[vehicleid] + fueltogive;
					if(VehicleFuel[vehicleid] > 100.0) VehicleFuel[vehicleid] = 100.0;
					format(string, sizeof(string), "* %s has refilled their vehicle.", GetPlayerNameEx(playerid));
					ProxChatBubble(playerid, string);
					// ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
					format(string, sizeof(string), "* You added %.2f fuel to your car.",fueltogive);
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
					for(new vehicleslot = 0; vehicleslot < MAX_PLAYERVEHICLES; vehicleslot++)
					{
						if(IsPlayerInVehicle(playerid, PlayerVehicleInfo[playerid][vehicleslot][pvId]))
						{
							if(vehicleslot != -1) {
								mysql_format(MainPipeline, string, sizeof(string), "UPDATE `vehicles` SET `pvFuel` = %0.5f WHERE `id` = '%d'", VehicleFuel[vehicleid], PlayerVehicleInfo[playerid][vehicleslot][pvSlotId]);
								mysql_tquery(MainPipeline, string, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
							}
						}
					}
					return 1;
				}
				SendClientMessageEx(playerid, COLOR_GREY, "You can't offer a refill to yourself."); return 1;
			}
			format(string, sizeof(string), "* You offered %s to add %.2f fuel to their car for $%d.",GetPlayerNameEx(giveplayerid),fueltogive,money);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
			format(string, sizeof(string), "* Car Mechanic %s wants to add %.2f fuel to your car for $%d, type /accept refill to accept.",GetPlayerNameEx(playerid),fueltogive,money);
			SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
			PlayerInfo[playerid][pMechTime] = gettime()+60;
			RefillOffer[giveplayerid] = playerid;
			RefillPrice[giveplayerid] = money;
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "That person is not near you, or isn't in a car.");
		}
	}
	else SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");
	return 1;
}

CMD:repair(playerid, params[])
{
	if(PlayerInfo[playerid][pJob] != 7 && PlayerInfo[playerid][pJob2] != 7 && PlayerInfo[playerid][pJob3] != 7)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "   You are not a Car Mechanic!");
		return 1;
	}
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You can not repair while inside the vehicle.");

	new string[128];
	if(gettime() < PlayerInfo[playerid][pMechTime])
	{
		format(string, sizeof(string), "You must wait %d seconds!", PlayerInfo[playerid][pMechTime]-gettime());
		SendClientMessageEx(playerid, COLOR_GRAD1,string);
		return 1;
	}
	if(GetPVarInt(playerid, "EventToken")) {
		return SendClientMessageEx(playerid, COLOR_GRAD1, "You can't use this while in an event.");
	}
	new giveplayerid, money;
	if(sscanf(params, "ud", giveplayerid, money)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /repair [player] [price]");

	if(PlayerInfo[playerid][pTire] > 0)
	{
		if(money < 1 || money > 10000) { SendClientMessageEx(playerid, COLOR_GREY, "   Price not lower then $1 or above $10,000!"); return 1; }
		if(IsPlayerConnected(giveplayerid))
		{
			if(giveplayerid != INVALID_PLAYER_ID)
			{
			    new closestcar = GetClosestCar(playerid);

	  			if(IsPlayerInRangeOfVehicle(playerid, closestcar, 8.0))
	  			{
					if(ProxDetectorS(8.0, playerid, giveplayerid)&& IsPlayerInAnyVehicle(giveplayerid))
					{
						if(giveplayerid == playerid) { SendClientMessageEx(playerid, COLOR_GREY, "   Can't do that!"); return 1; }
	                    if(!IsABike(closestcar) && !IsAPlane(closestcar))
						{
							new engine,lights,alarm,doors,bonnet,boot,objective;
							GetVehicleParamsEx(closestcar,engine,lights,alarm,doors,bonnet,boot,objective);
							if(bonnet == VEHICLE_PARAMS_OFF || bonnet == VEHICLE_PARAMS_UNSET)
							{
								SendClientMessageEx(playerid, COLOR_GRAD1, "The vehicle hood must be opened in order to repair it.");
								return 1;
							}
						}
						format(string, sizeof(string), "* You offered %s to fix their car for $%d .",GetPlayerNameEx(giveplayerid),money);
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
						format(string, sizeof(string), "* Car Mechanic %s wants to repair your car for $%d, (type /accept repair) to accept.",GetPlayerNameEx(playerid),money);
						SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
						PlayerInfo[playerid][pMechTime] = gettime()+60;
						SetPVarInt(playerid, "RepairOfferTo", giveplayerid);
						RepairOffer[giveplayerid] = playerid;
						RepairPrice[giveplayerid] = money;
					}
					else
					{
						SendClientMessageEx(playerid, COLOR_GREY, "   That person is not near you / not in a car.");
					}
				}
				else
				{
				    SendClientMessageEx(playerid, COLOR_GREY, "   You are not near any vehicle.");
				}
			}
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "   That person is offline.");
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREY, "   You do not have any tires, buy one from a craftsman.");
	}
	return 1;
}
