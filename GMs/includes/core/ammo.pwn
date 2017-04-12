/* Ammo Module

	Written by Dom 

*/

#include <YSI\y_hooks>

GetAmmoType(iWeaponID)
{
	switch(iWeaponID)
	{
		case WEAPON_SILENCED, WEAPON_COLT45, WEAPON_UZI, WEAPON_MP5, WEAPON_TEC9: return 0;
		case WEAPON_M4, WEAPON_SNIPER, WEAPON_RIFLE, WEAPON_AK47: return 1;
		case WEAPON_DEAGLE: return 2;
		case WEAPON_SHOTGUN, WEAPON_SAWEDOFF, WEAPON_SHOTGSPA: return 3;
		//case WEAPON_SHOTGUN, WEAPON_SAWEDOFF, WEAPON_SHOTGSPA: return 4;
		default: return -1;
	}
	return -1;
}

GetAmmoName(ammoType)
{
	new ammo[30];
	switch(ammoType)
	{
		case 0: ammo = "Pistol Ammo";
		case 1: ammo = "Rifle Ammo";
		case 2: ammo = "Deagle Ammo";
		case 3: ammo = "Shotgun Ammo";
		//case 4: ammo = "12-gauge";
		default: ammo = "";
	}
	return ammo;
}

SyncPlayerAmmo(playerid, iWeaponID)
{
	if(iWeaponID == WEAPON_SPRAYCAN || iWeaponID == WEAPON_CAMERA || iWeaponID == WEAPON_FIREEXTINGUISHER) return SetPlayerAmmo(playerid, iWeaponID, 99999);
	if(iWeaponID == WEAPON_MOLTOV || iWeaponID == WEAPON_GRENADE || iWeaponID == WEAPON_GRENADE) return SetPlayerAmmo(playerid, iWeaponID, 5);
	new iAmmoType = GetAmmoType(iWeaponID);
	if(GetPVarInt(playerid, "IsInArena") || GetPVarInt(playerid, "EventToken") != 0 || pTazer{playerid} != 0 || zombieevent) return 1;
	if(iAmmoType != -1)
	{
		if(arrAmmoData[playerid][awp_iAmmo][iAmmoType] > GetMaxAmmoAllowed(playerid, iAmmoType) && (PlayerInfo[playerid][pTogReports] == 1 || PlayerInfo[playerid][pAdmin] < 2))
			arrAmmoData[playerid][awp_iAmmo][iAmmoType] = GetMaxAmmoAllowed(playerid, iAmmoType);
		SetPlayerAmmo(playerid, iWeaponID, arrAmmoData[playerid][awp_iAmmo][iAmmoType]);
		//format(szMiscArray, sizeof(szMiscArray), "[debug] SyncPlayerAmmo - Values: ID %d - (iWeaponID) %d - (Ammo Type) %d", playerid, iWeaponID, iAmmoType);
		//SendClientMessageToAll(COLOR_WHITE, szMiscArray);
		//printf("[debug] SyncPlayerAmmo - Values: (playerid) %d - (iWeaponID) %d - (Ammo Type) %d", playerid, iWeaponID, iAmmoType);
	}
	return 1;
}

ResetVIPAmmoCount()
{
	foreach(new i : Player)
	{
		PlayerInfo[i][pVIPGuncount] = 0;
	}
	mysql_tquery(MainPipeline, "UPDATE `accounts` SET `VIPGunsCount` = '0'", false, "", "");
	return 1;
}

GetMaxAmmoAllowed(playerid, iAmmoType) {
 
    new
    	iSkinID = GetPlayerSkin(playerid);
           
    switch(iAmmoType) {
        case 0: { // Pistol Ammo
            if(iSkinID == 285 || iSkinID == 287)
                return 460;
                   
            switch(PlayerInfo[playerid][pDonateRank]) {
                case 0, 1: return 220;
                case 2: return 280;  
                case 3: return 340;
                default: return 340;
            }
        }
        case 1: { // Rifle Ammo
            if(iSkinID == 285 || iSkinID == 287)
                return 900;
                   
            switch(PlayerInfo[playerid][pDonateRank]) {
                case 0, 1: return 600;
                case 2: return 660;  
                case 3: return 800;
                default: return 800;
            }
        }
        case 2: { // Deagle Ammo
            if(iSkinID == 285 || iSkinID == 287)
                return 350;
                   
            switch(PlayerInfo[playerid][pDonateRank]) {
                case 0, 1: return 120;
                case 2: return 170;  
                case 3: return 230;
                default: return 230;
            }
        } 
        case 3: { // Shotgun Ammo
            if(iSkinID == 285 || iSkinID == 287)
                return 210;
                   
            switch(PlayerInfo[playerid][pDonateRank]) {
                case 0, 1: return 90;
                case 2: return 120;  
                case 3: return 150;
                default: return 180;
            }
        }/*
        case 4: { // 12 gauge
            if(iSkinID == 285 || iSkinID == 287)
                return 160;
                   
            switch(PlayerInfo[playerid][pDonateRank]) {
                case 0, 1: return 60;
                case 2: return 80;  
                case 3: return 100;
                default: return 120;
            }
        }*/
    }
    return 0;
}

ShowAmmunationDialog(playerid)
{
	return ShowPlayerDialogEx(playerid, DIALOG_AMMUNATION_MAIN, DIALOG_STYLE_LIST, "Ammunation Menu", "Weapons\nAmmo", "Select", "Cancel");
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	szMiscArray[0] = 0;
	switch(dialogid)
	{
		case DIALOG_AMMUNATION_MAIN:
		{
			if(!response) 
				return SendClientMessageEx(playerid, COLOR_YELLOW, "Thank you for shopping at Ammunation! Come again!");

			switch(listitem)
			{
				case 0: { // weapons
					format(szMiscArray, sizeof(szMiscArray), "Weapon\tPrice\n9mm Pistol\t$%s\nPump Shotgun\t$%s\nDeagle\t$%s", number_format(GunPrices[0]), number_format(GunPrices[1]), number_format(GunPrices[2]));
					ShowPlayerDialogEx(playerid, DIALOG_AMMUNATION_GUNS, DIALOG_STYLE_TABLIST_HEADERS, "Ammunation Menu - Weapons", szMiscArray, "Select", "Back");
				}
				case 1: {// ammo
					format(szMiscArray, sizeof(szMiscArray), "Ammo Type\tPrice\nPistol Ammo\t$%s\nShotgun Ammo\t$%s\nDeagle Ammo\t$%s\nRifle Ammo\t$%s", number_format(GunPrices[3]), number_format(GunPrices[4]), number_format(GunPrices[5]), number_format(GunPrices[6]));
					ShowPlayerDialogEx(playerid, DIALOG_AMMUNATION_AMMO, DIALOG_STYLE_TABLIST_HEADERS, "Ammunation Menu - Ammo", szMiscArray, "Select", "Back");
				} 
			}
		}
		case DIALOG_AMMUNATION_GUNS:
		{
			if(PlayerInfo[playerid][pGunLic] < gettime())
				return SendClientMessageEx(playerid, COLOR_GREY, "You must have an active license to purchase guns from a gun-shop!");
			if(!response)
				return ShowAmmunationDialog(playerid);

			switch(listitem)
			{
				case 0: // 9mm Pistol
				{
					new iWeaponMats = GetWeaponParam(WEAPON_COLT45, WeaponMats);
					new business = InBusiness(playerid);

					if(PlayerInfo[playerid][pCash] < GunPrices[0]) return SendClientMessageEx(playerid, COLOR_WHITE, "You do not have enough money!");
					if(Businesses[business][bInventory] < iWeaponMats) return SendClientMessageEx(playerid, COLOR_WHITE, "The business has run out of stock");
					
					Businesses[business][bInventory] -= iWeaponMats;
					Businesses[business][bTotalSales]++;
		   			Businesses[business][bLevelProgress]++;
		   			Businesses[business][bSafeBalance] += TaxSale(GunPrices[0]);

		   			SaveBusiness(business);
					
					GivePlayerCash(playerid, -GunPrices[0]);
					GivePlayerValidWeapon(playerid, WEAPON_COLT45, 0);

					format(szMiscArray, sizeof(szMiscArray), "%s has purchased 9mm pistol for $%s at %s", GetPlayerNameEx(playerid), number_format(GunPrices[0]), Businesses[business][bName]);
					SendClientMessageEx(playerid, -1, szMiscArray);
					Log("logs/business.log", szMiscArray);
				}
				case 1: // Pump Shotgun 
				{
					new iWeaponMats = GetWeaponParam(WEAPON_SHOTGUN, WeaponMats);
					new business = InBusiness(playerid);

					if(PlayerInfo[playerid][pCash] < GunPrices[1]) return SendClientMessageEx(playerid, COLOR_WHITE, "You do not have enough money!");
					if(Businesses[business][bInventory] < iWeaponMats) return SendClientMessageEx(playerid, COLOR_WHITE, "The business has run out of stock");
					
					Businesses[business][bInventory] -= iWeaponMats;
					Businesses[business][bTotalSales]++;
		   			Businesses[business][bLevelProgress]++;
		   			Businesses[business][bSafeBalance] += TaxSale(GunPrices[1]);

		   			SaveBusiness(business);
					
					GivePlayerCash(playerid, -GunPrices[1]);
					GivePlayerValidWeapon(playerid, WEAPON_SHOTGUN, 0);

					format(szMiscArray, sizeof(szMiscArray), "%s has purchased shotgun for $%s at %s", GetPlayerNameEx(playerid), number_format(GunPrices[1]), Businesses[business][bName]);
					SendClientMessageEx(playerid, -1, szMiscArray);
					Log("logs/business.log", szMiscArray);
				}
				case 2: // Deagle
				{
					new iWeaponMats = GetWeaponParam(WEAPON_DEAGLE, WeaponMats);
					new business = InBusiness(playerid);

					if(PlayerInfo[playerid][pCash] < GunPrices[2]) return SendClientMessageEx(playerid, COLOR_WHITE, "You do not have enough money!");
					if(Businesses[business][bInventory] < iWeaponMats) return SendClientMessageEx(playerid, COLOR_WHITE, "The business has run out of stock");
					
					Businesses[business][bInventory] -= iWeaponMats;
					Businesses[business][bTotalSales]++;
		   			Businesses[business][bLevelProgress]++;
		   			Businesses[business][bSafeBalance] += TaxSale(GunPrices[2]);

		   			SaveBusiness(business);
					
					GivePlayerCash(playerid, -GunPrices[2]);
					GivePlayerValidWeapon(playerid, WEAPON_DEAGLE, 0);

					format(szMiscArray, sizeof(szMiscArray), "%s has purchased deagle for $%s at %s", GetPlayerNameEx(playerid), number_format(GunPrices[2]), Businesses[business][bName]);
					SendClientMessageEx(playerid, -1, szMiscArray);
					Log("logs/business.log", szMiscArray);
				}
			}
		}
		case DIALOG_AMMUNATION_AMMO:
		{
			if(!response)
				return ShowAmmunationDialog(playerid);
			
			switch(listitem)
			{
				case 0: // Pistol Ammo
				{
					new business = InBusiness(playerid);

					if(PlayerInfo[playerid][pCash] < GunPrices[3]) return SendClientMessage(playerid, COLOR_WHITE, "You do not have enough money on you.");
					if(Businesses[business][bInventory] < (GunPrices[3]/1000)) return SendClientMessageEx(playerid, COLOR_WHITE, "The business has run out of stock");
					if((arrAmmoData[playerid][awp_iAmmo][0] + 60) > GetMaxAmmoAllowed(playerid, 0)) return SendClientMessageEx(playerid, COLOR_WHITE, "You cannot carry any more magazines on you.");
					

					Businesses[business][bInventory] -= (GunPrices[3]/1000);
					Businesses[business][bTotalSales]++;
		   			Businesses[business][bLevelProgress]++;
		   			Businesses[business][bSafeBalance] += TaxSale(GunPrices[3]);

		   			SaveBusiness(business);
					
					GivePlayerCash(playerid, -GunPrices[3]);
					arrAmmoData[playerid][awp_iAmmo][0] += 60;
					
					for(new i = 0; i < 12; i++) {
						SyncPlayerAmmo(playerid, PlayerInfo[playerid][pGuns][i]);
					}

					format(szMiscArray, sizeof(szMiscArray), "%s has purchased Pistol Ammo for $%s at %s", GetPlayerNameEx(playerid), number_format(GunPrices[3]), Businesses[business][bName]);
					SendClientMessageEx(playerid, -1, szMiscArray);
					Log("logs/business.log", szMiscArray);
				}
				case 1: // Shotgun Ammo
				{
					new business = InBusiness(playerid);

					if(PlayerInfo[playerid][pCash] < GunPrices[4]) return SendClientMessage(playerid, COLOR_WHITE, "You do not have enough money on you.");
					if(Businesses[business][bInventory] < (GunPrices[4]/1000)) return SendClientMessageEx(playerid, COLOR_WHITE, "The business has run out of stock");
					if((arrAmmoData[playerid][awp_iAmmo][3] + 40) > GetMaxAmmoAllowed(playerid, 3)) return SendClientMessageEx(playerid, COLOR_WHITE, "You cannot carry any more magazines on you.");
					

					Businesses[business][bInventory] -= (GunPrices[4]/1000);
					Businesses[business][bTotalSales]++;
		   			Businesses[business][bLevelProgress]++;
		   			Businesses[business][bSafeBalance] += TaxSale(GunPrices[4]);

		   			SaveBusiness(business);
					
					GivePlayerCash(playerid, -GunPrices[4]);
					arrAmmoData[playerid][awp_iAmmo][3] += 40;

					for(new i = 0; i < 12; i++) {
						SyncPlayerAmmo(playerid, PlayerInfo[playerid][pGuns][i]);
					}

					format(szMiscArray, sizeof(szMiscArray), "%s has purchased Shotgun ammo for $%s at %s", GetPlayerNameEx(playerid), number_format(GunPrices[4]), Businesses[business][bName]);
					SendClientMessageEx(playerid, -1, szMiscArray);
					Log("logs/business.log", szMiscArray);
				}
				case 2: // Deagle ammo
				{
					new business = InBusiness(playerid);

					if(PlayerInfo[playerid][pCash] < GunPrices[5]) return SendClientMessage(playerid, COLOR_WHITE, "You do not have enough money on you.");
					if(Businesses[business][bInventory] < (GunPrices[5]/1000)) return SendClientMessageEx(playerid, COLOR_WHITE, "The business has run out of stock");
					if((arrAmmoData[playerid][awp_iAmmo][2] + 30) > GetMaxAmmoAllowed(playerid, 2)) return SendClientMessageEx(playerid, COLOR_WHITE, "You cannot carry any more magazines on you.");
					

					Businesses[business][bInventory] -= (GunPrices[5]/1000);
					Businesses[business][bTotalSales]++;
		   			Businesses[business][bLevelProgress]++;
		   			Businesses[business][bSafeBalance] += TaxSale(GunPrices[5]);

		   			SaveBusiness(business);
					
					GivePlayerCash(playerid, -GunPrices[5]);
					arrAmmoData[playerid][awp_iAmmo][2] += 30;

					for(new i = 0; i < 12; i++) {
						SyncPlayerAmmo(playerid, PlayerInfo[playerid][pGuns][i]);
					}

					format(szMiscArray, sizeof(szMiscArray), "%s has purchased Deagle Ammo for $%s at %s", GetPlayerNameEx(playerid), number_format(GunPrices[5]), Businesses[business][bName]);
					SendClientMessageEx(playerid, -1, szMiscArray);
					Log("logs/business.log", szMiscArray);
				}
				case 3: // Rifle ammo
				{
					new business = InBusiness(playerid);

					if(PlayerInfo[playerid][pCash] < GunPrices[6]) return SendClientMessage(playerid, COLOR_WHITE, "You do not have enough money on you.");
					if(Businesses[business][bInventory] < (GunPrices[6]/1000)) return SendClientMessageEx(playerid, COLOR_WHITE, "The business has run out of stock");
					if((arrAmmoData[playerid][awp_iAmmo][1] + 50) > GetMaxAmmoAllowed(playerid, 1)) return SendClientMessageEx(playerid, COLOR_WHITE, "You cannot carry any more magazines on you.");
					

					Businesses[business][bInventory] -= (GunPrices[6]/1000);
					Businesses[business][bTotalSales]++;
		   			Businesses[business][bLevelProgress]++;
		   			Businesses[business][bSafeBalance] += TaxSale(GunPrices[6]);

		   			SaveBusiness(business);
					
					GivePlayerCash(playerid, -GunPrices[6]);
					arrAmmoData[playerid][awp_iAmmo][1] += 50;

					for(new i = 0; i < 12; i++) {
						SyncPlayerAmmo(playerid, PlayerInfo[playerid][pGuns][i]);
					}

					format(szMiscArray, sizeof(szMiscArray), "%s has purchased Rifle Ammo for $%s at %s", GetPlayerNameEx(playerid), number_format(GunPrices[6]), Businesses[business][bName]);
					SendClientMessageEx(playerid, -1, szMiscArray);
					Log("logs/business.log", szMiscArray);
				}
			}
		}
	}
	return 0;
}

CMD:issuegl(playerid, params[]) return cmd_issuegunlicense(playerid, params);
CMD:issuegunlicense(playerid, params[])
{
	if((0 <= PlayerInfo[playerid][pLeader] < MAX_GROUPS) && arrGroupData[PlayerInfo[playerid][pLeader]][g_iGroupType] == GROUP_TYPE_GOV)
	{
		new iTargetID;

		szMiscArray[0] = 0;

		if(sscanf(params, "u", iTargetID)) return SendClientMessageEx(playerid, COLOR_GRAD2, "USAGE: /issuegunlicense [playerid]");

		PlayerInfo[iTargetID][pGunLic] = gettime() + (86400*30);

		format(szMiscArray, sizeof(szMiscArray), "%s has renewed %s's gun license.", GetPlayerNameEx(playerid), GetPlayerNameEx(iTargetID));

		foreach(new i : Player)
			if((0 <= PlayerInfo[i][pMember] < MAX_GROUPS) && arrGroupData[PlayerInfo[i][pMember]][g_iGroupType] == GROUP_TYPE_GOV)
				SendClientMessageEx(i, COLOR_RED, szMiscArray);

		format(szMiscArray, sizeof(szMiscArray), "%s(%d) (%s) has issued %s(%d) (%s) a gun license.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), GetPlayerNameEx(iTargetID), GetPlayerSQLId(iTargetID),  GetPlayerIpEx(iTargetID));
		Log("logs/licenses.log", szMiscArray);
	}
	else SendClientMessageEx(playerid, COLOR_WHITE, "You are not authorized to use this command!");
	return 1;
}

CMD:buygun(playerid, params[])
{
	new business = InBusiness(playerid);

	if(business == INVALID_BUSINESS_ID || Businesses[business][bType] != BUSINESS_TYPE_GUNSHOP) return SendClientMessageEx(playerid, COLOR_WHITE, "You are not at a gunshop!");
	if(PlayerInfo[playerid][pConnectHours] < 8) return SendClientMessageEx(playerid, COLOR_WHITE, "You have not played enough to obtain a weapon!");

	ShowAmmunationDialog(playerid);

	return 1;
}

CMD:loadammo(playerid, params[])
{
	new iVehID = GetPlayerVehicleID(playerid);
	new iGroupID = PlayerInfo[playerid][pMember];

	szMiscArray[0] = 0;
	
	if(DynVeh[iVehID] == -1 || DynVehicleInfo[DynVeh[iVehID]][gv_iType] != 2) return SendClientMessageEx(playerid, COLOR_WHITE, "This vehicle cannot be loaded with Ammo.");
	if(DynVehicleInfo[DynVeh[iVehID]][gv_iAmmoLoaded] > 0) return SendClientMessageEx(playerid, COLOR_WHITE, "This vehicle has already been loaded with ammo."); 
	if(0 <= iGroupID < MAX_GROUPS && (arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_GOV || arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_LEA))
	{
		for(new i = 0; i < MAX_BUSINESSES; i++)
		{
			if(IsPlayerInRangeOfPoint(playerid, 5.0, Businesses[i][bSupplyPos][0], Businesses[i][bSupplyPos][1], Businesses[i][bSupplyPos][2]) && Businesses[i][bType] == BUSINESS_TYPE_GUNSHOP)
			{
				DynVehicleInfo[DynVeh[iVehID]][gv_iAmmoLoaded] = 1;
				arrGroupData[iGroupID][g_iBudget] -= 400000;
				Businesses[i][bSafeBalance] += TaxSale(400000);

				SendClientMessageEx(playerid, COLOR_WHITE, "You have loaded ammo into your vehicle. Deliver it back to your HQ. ");

				format(szMiscArray, sizeof(szMiscArray), "%s has paid $400,000 for an ammo crate resupply at %s (%d).", GetPlayerNameEx(playerid), Businesses[i][bName], i);
				Log("logs/business.log", szMiscArray);

				format(szMiscArray, sizeof(szMiscArray), "%s has paid $400,000 for an ammo crate resupply.", GetPlayerNameEx(playerid));
				GroupLog(iGroupID, szMiscArray);
				break;
			}
		}
	}
	else SendClientMessageEx(playerid, COLOR_WHITE, "You must be a LEO to use this command");
	return 1;
}

CMD:deliverammo(playerid, params[])
{
	new iVehID = GetPlayerVehicleID(playerid);
	new iGroupID = PlayerInfo[playerid][pMember];

	szMiscArray[0] = 0;

	if(DynVeh[iVehID] == -1 || DynVehicleInfo[DynVeh[iVehID]][gv_iType] != 2) return SendClientMessageEx(playerid, COLOR_WHITE, "This vehicle is not designated to ammo transportation.");
	if(DynVehicleInfo[DynVeh[iVehID]][gv_iAmmoLoaded] == 0) return SendClientMessageEx(playerid, COLOR_WHITE, "This vehicle does not have any ammo in it."); 
	if(0 <= iGroupID < MAX_GROUPS && (arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_GOV || arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_LEA))
	{
		for(new i = 0; i < MAX_GROUPS; i++)
		{
			if(IsPlayerInRangeOfPoint(playerid, 6, arrGroupData[i][g_fCratePos][0], arrGroupData[i][g_fCratePos][1], arrGroupData[i][g_fCratePos][2]))
			{
				if(arrGroupData[i][g_iAmmo][0] + 5000 <= 50000) arrGroupData[i][g_iAmmo][0] += 5000; else arrGroupData[i][g_iAmmo][0] += (50000 - arrGroupData[i][g_iAmmo][0]);
				if(arrGroupData[i][g_iAmmo][1] + 5000 <= 50000) arrGroupData[i][g_iAmmo][1] += 5000; else arrGroupData[i][g_iAmmo][1] += (50000 - arrGroupData[i][g_iAmmo][1]);
				if(arrGroupData[i][g_iAmmo][2] + 5000 <= 50000) arrGroupData[i][g_iAmmo][2] += 5000; else arrGroupData[i][g_iAmmo][2] += (50000 - arrGroupData[i][g_iAmmo][2]);
				if(arrGroupData[i][g_iAmmo][3] + 5000 <= 50000) arrGroupData[i][g_iAmmo][3] += 5000; else arrGroupData[i][g_iAmmo][3] += (50000 - arrGroupData[i][g_iAmmo][3]);
				//if(arrGroupData[i][g_iAmmo][4] + 5000 <= 10000) arrGroupData[i][g_iAmmo][4] += 5000; else arrGroupData[i][g_iAmmo][4] += (10000 - arrGroupData[i][g_iAmmo][4]);

				DynVehicleInfo[DynVeh[iVehID]][gv_iAmmoLoaded] = 0;

				format(szMiscArray, sizeof(szMiscArray), "%s delivered an ammo crate.", GetPlayerNameEx(playerid));
				GroupLog(iGroupID, szMiscArray);

				SendClientMessageEx(playerid, COLOR_WHITE, "You have delivered ammo to your HQ. ");
				break;
			}
		}
	}
	return 1;
}

ListAmmo(playerid, targetid)
{
	szMiscArray[0] = 0;
	SendClientMessageEx(playerid, COLOR_GREEN,"_______________________________________");
	
	format(szMiscArray, sizeof(szMiscArray), "Ammo on %s:", GetPlayerNameEx(targetid));
	SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);

	for(new i = 0; i != MAX_AMMO_TYPES; i++)
	{
		format(szMiscArray, sizeof(szMiscArray), "%s: %i / %i rounds", GetAmmoName(i), arrAmmoData[targetid][awp_iAmmo][i], GetMaxAmmoAllowed(targetid, i));
		SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
	}

	SendClientMessageEx(playerid, COLOR_GREEN,"_______________________________________");
	return 1;
}

CMD:myammo(playerid, params[]) return ListAmmo(playerid, playerid);

CMD:seeammo(playerid, params[]) {
	if(PlayerInfo[playerid][pAdmin] < 2) return SendClientMessageEx(playerid, COLOR_WHITE, "You cannot use this command!");
	new target;
	if(sscanf(params, "u", target)) return SendClientMessageEx(playerid, COLOR_GRAD2, "USAGE: /seeammo [playerid]");
	if(!IsPlayerConnected(target)) return SendClientMessageEx(playerid, COLOR_GRAD2, "That player is not connected");
	return ListAmmo(playerid, target);
}

CMD:setammo(playerid, params[]) {
	szMiscArray[0] = 0;
	new 
		iTargetID,
		iAmmoType,
		iAmount;

	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1) return SendClientMessageEx(playerid, COLOR_WHITE, "You cannot use this command!");
	if(sscanf(params, "uii", iTargetID, iAmmoType, iAmount)) return SendClientMessageEx(playerid, COLOR_GRAD2, "USAGE: /setammo [playerid] [type (0 - 3)] [amount]");
	if(!IsPlayerConnected(iTargetID)) return SendClientMessageEx(playerid, COLOR_GRAD2, "That player is not connected.");
	if(iAmount < 1) return SendClientMessageEx(playerid, COLOR_GRAD2, "The amount cannot be less than 1.");	

	format(szMiscArray, sizeof(szMiscArray), "You have given %s %i ammo (type:%i)", GetPlayerNameEx(iTargetID), iAmount, iAmmoType);
	SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
	
	format(szMiscArray, sizeof(szMiscArray), "%s(%s) has given %s(%d) (%s) %i ammo (type:%i)", GetPlayerNameEx(playerid), GetPlayerIpEx(playerid), GetPlayerNameEx(iTargetID), GetPlayerSQLId(iTargetID), GetPlayerIpEx(iTargetID), iAmount, iAmmoType);
	Log("logs/admingive.log", szMiscArray);
	arrAmmoData[iTargetID][awp_iAmmo][iAmmoType] = iAmount;
	return 1;
}

CMD:rld(playerid, params[]) {
	if(GetPVarInt(playerid, "Injured") || PlayerCuffed[playerid] > 0 || GetPVarInt(playerid, "IsInArena") || GetPVarInt(playerid, "EventToken") != 0 || PlayerInfo[playerid][pHospital] > 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "You cannot do this right now!");
	
	for(new i = 0; i < 12; i++)
	{
		GivePlayerWeapon(playerid, PlayerInfo[playerid][pGuns][i], 1);
		SyncPlayerAmmo(playerid, PlayerInfo[playerid][pGuns][i]);
	}
	ApplyAnimation(playerid, "PYTHON", "python_reload", 4.0, 0, 0, 0, 0, 0, 1);
	return 1;
}

CMD:vipgunsleft(playerid, params[]) {
	
	szMiscArray[0] = 0;
	if(PlayerInfo[playerid][pDonateRank] < 1) return SendClientMessageEx(playerid, COLOR_GRAD2, "You are not a VIP member.");

	switch(PlayerInfo[playerid][pDonateRank]) {
		case 4: format(szMiscArray, sizeof(szMiscArray), "%s has %d VIP gun withdraws left today!", GetPlayerNameEx(playerid), 8-PlayerInfo[playerid][pVIPGuncount]);
		default: format(szMiscArray, sizeof(szMiscArray), "%s has %d VIP gun withdraws left today!", GetPlayerNameEx(playerid), 4-PlayerInfo[playerid][pVIPGuncount]);
	}
	
	SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
	return 1;
}

CMD:editgsprices(playerid, params[]) {

	szMiscArray[0] = 0;

	new 
		choice[32], 
		amount;

	if(PlayerInfo[playerid][pAdmin] < 1337) return SendClientMessageEx(playerid, COLOR_WHITE, "You are not authorized to use that command!");

	if(sscanf(params, "s[32]d", choice, amount)) {
		SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /editgsprices [choice] [amount]"); 
		SendClientMessageEx(playerid, COLOR_WHITE, "Available choices: colt45, shotgun, deagle, pistolm, shotgunm, deaglem, riflem");
		format(szMiscArray, sizeof(szMiscArray), "colt45: $%s | shotgun: $%s | Deagle: $%s | Pistol Ammo: $%s | Shotgun Ammo: $%s | Deagle Ammo: $%s | Rifle Ammo: %s", number_format(GunPrices[0]), number_format(GunPrices[1]), number_format(GunPrices[2]), number_format(GunPrices[3]), number_format(GunPrices[4]), number_format(GunPrices[5]), number_format(GunPrices[6]));
		return SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
	}
	if(strcmp(choice, "colt45", true) == 0) {
		GunPrices[0] = amount; 
		format(szMiscArray, sizeof(szMiscArray), "%s has changed the colt45 price to $%s", GetPlayerNameEx(playerid), number_format(amount));
		Log("logs/business.log", szMiscArray);
		g_mysql_SaveMOTD();
	}
	if(strcmp(choice, "shotgun", true) == 0) {
		GunPrices[1] = amount; 
		format(szMiscArray, sizeof(szMiscArray), "%s has changed the shotgun price to $%s", GetPlayerNameEx(playerid), number_format(amount));
		Log("logs/business.log", szMiscArray);
		g_mysql_SaveMOTD();
	}
	if(strcmp(choice, "deagle", true) == 0) {
		GunPrices[2] = amount; 
		format(szMiscArray, sizeof(szMiscArray), "%s has changed the deagle price to $%s", GetPlayerNameEx(playerid), number_format(amount));
		Log("logs/business.log", szMiscArray);
		g_mysql_SaveMOTD();
	}
	if(strcmp(choice, "pistolm", true) == 0) {
		GunPrices[3] = amount; 
		format(szMiscArray, sizeof(szMiscArray), "%s has changed the Pistol Ammo price to $%s", GetPlayerNameEx(playerid), number_format(amount));
		Log("logs/business.log", szMiscArray);
		g_mysql_SaveMOTD();
	}
	if(strcmp(choice, "shotgunm", true) == 0) {
		GunPrices[4] = amount; 
		format(szMiscArray, sizeof(szMiscArray), "%s has changed the Shotgun Ammo price to $%s", GetPlayerNameEx(playerid), number_format(amount));
		Log("logs/business.log", szMiscArray);
		g_mysql_SaveMOTD();
	}
	if(strcmp(choice, "deaglem", true) == 0) {
		GunPrices[5] = amount; 
		format(szMiscArray, sizeof(szMiscArray), "%s has changed the Deagle Ammo price to $%s", GetPlayerNameEx(playerid), number_format(amount));
		Log("logs/business.log", szMiscArray);
		g_mysql_SaveMOTD();
	}
	if(strcmp(choice, "riflem", true) == 0) {
		GunPrices[6] = amount; 
		format(szMiscArray, sizeof(szMiscArray), "%s has changed the Rifle Ammo price to $%s", GetPlayerNameEx(playerid), number_format(amount));
		Log("logs/business.log", szMiscArray);
		g_mysql_SaveMOTD();
	}
	g_mysql_SaveMOTD();
	return 1;
}
/*
CMD:ammohelp(playerid, params[]) {

	SendClientMessageEx(playerid, COLOR_WHITE, "*** AMMO *** /rld /myammo /buygun");
	if((0 <= PlayerInfo[playerid][pLeader] < MAX_GROUPS) && arrGroupData[PlayerInfo[playerid][pLeader]][g_iGroupType] ==  GROUP_TYPE_GOV) SendClientMessageEx(playerid, COLOR_WHITE, "*** AMMO (GOV) *** /issuegunlicense");
	if(IsACop(playerid)) SendClientMessageEx(playerid, COLOR_WHITE, "*** AMMO (LEO) *** /loadammo /deliverammo");
	if(PlayerInfo[playerid][pDonateRank] > 2) SendClientMessageEx(playerid, COLOR_WHITE, "*** AMMO (VIP) *** /vipgunsleft");
	if(PlayerInfo[playerid][pAdmin] > 4) SendClientMessageEx(playerid, COLOR_WHITE, "*** AMMO (ADMIN) *** /editgsprices /setammo");

	return 1;
}
*/

/*CMD:oissuegl(playerid, params[]) return cmd_oissuegunlicense(playerid, params);
CMD:oissuegunlicense(playerid, params[])
{
	if((0 <= PlayerInfo[playerid][pLeader] < MAX_GROUPS) && arrGroupData[PlayerInfo[playerid][pLeader]][g_iGroupType] == GROUP_TYPE_GOV)
	{
		szMiscArray[0] = 0;
		new TargetName[MAX_PLAYERS];
		if(sscanf(params, "s[24]", TargetName)) return SendClientMessageEx(playerid, COLOR_GRAD2, "USAGE: /oissuegunlicense [playerid]");
		if(IsPlayerConnected(ReturnUser(TargetName))) return cmd_issuegunlicense(playerid, params);

		new PlayerName[MAX_PLAYERS];
		mysql_escape_string(TargetName, PlayerName);
		
		format(szMiscArray, sizeof(szMiscArray), "Attempting to offline issue %s a gun license.", PlayerName);
		SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
		SendClientMessageEx(playerid, COLOR_YELLOW, "Please wait...");
		
		format(szMiscArray, sizeof(szMiscArray), "SELECT `id`, `IP` FROM `accounts` WHERE `Username` = '%s'", PlayerName);
 		mysql_tquery(MainPipeline, szMiscArray, true, "OnOfflineGunLicense", "iis", playerid, 1, PlayerName);
	}
	else SendClientMessageEx(playerid, COLOR_WHITE, "You are not authorized to use this command!");
	return 1;
}*/

CMD:orevokegl(playerid, params[]) return cmd_orevokegunlicense(playerid, params);
CMD:orevokegunlicense(playerid, params[])
{
	if((0 <= PlayerInfo[playerid][pLeader] < MAX_GROUPS) && arrGroupData[PlayerInfo[playerid][pLeader]][g_iGroupType] == GROUP_TYPE_GOV || PlayerInfo[playerid][pLeader] == 1)
	{
		szMiscArray[0] = 0;
		new TargetName[MAX_PLAYERS];
		if(sscanf(params, "s[24]", TargetName)) return SendClientMessageEx(playerid, COLOR_GRAD2, "USAGE: /orevokegunlicense [playerid]");
		if(IsPlayerConnected(ReturnUser(TargetName))) return cmd_issuegunlicense(playerid, params);

		new PlayerName[MAX_PLAYERS];
		mysql_escape_string(TargetName, PlayerName);
		
		format(szMiscArray, sizeof(szMiscArray), "Attempting to offline revoke %s a gun license.", PlayerName);
		SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
		SendClientMessageEx(playerid, COLOR_YELLOW, "Please wait...");
		
		format(szMiscArray, sizeof(szMiscArray), "SELECT `id`, `IP` FROM `accounts` WHERE `Username` = '%s'", PlayerName);
 		mysql_tquery(MainPipeline, szMiscArray, true, "OnOfflineGunLicense", "iis", playerid, 0, PlayerName);
	}
	else SendClientMessageEx(playerid, COLOR_WHITE, "You are not authorized to use this command!");
	return 1;
}

/*forward OnOfflineGunLicense(playerid, task, name[]);
public OnOfflineGunLicense(playerid, task, name[])
{
	if(cache_get_row_count(MainPipeline) == 0)
		return SendClientMessageEx(playerid, COLOR_RED, "Error - This account does not exist.");

	format(szMiscArray, sizeof(szMiscArray), "UPDATE `accounts` SET `GunLic` = %d WHERE `Username` = '%s'", task, name);
	mysql_tquery(MainPipeline, szMiscArray, false, "OnQueryFinish", "i", SENDDATA_THREAD);

	format(szMiscArray, sizeof(szMiscArray), "%s has offline %s %s a gun license.", GetPlayerNameEx(playerid), task ? ("issued"):("revoked"), name);
	foreach(new i : Player)
		if((0 <= PlayerInfo[i][pMember] < MAX_GROUPS) && arrGroupData[PlayerInfo[i][pMember]][g_iGroupType] == GROUP_TYPE_GOV)
			SendClientMessageEx(i, COLOR_RED, szMiscArray);
	new ip_address[16];
	cache_get_field_content(0, "IP", ip_address, MainPipeline);
	format(szMiscArray, sizeof(szMiscArray), "%s(%d) (%s) has offline %s %s(%d) (%s) a gun license.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), task ? ("issued"):("revoked"), name, cache_get_field_content_int(0, "id"), ip_address);
	Log("logs/licenses.log", szMiscArray);
	return 1;
}*/

ShowAmmoDialog(playerid, dialogid, title[], arr[])
{
	szMiscArray[0] = 0;
	strcat(szMiscArray, "Ammo Type\tAmount\n");
	for(new i = 0; i != MAX_AMMO_TYPES; i++)
	{
		format(szMiscArray, sizeof(szMiscArray), "%s%s\t%d\n", szMiscArray, GetAmmoName(i), arr[i]);
	}
	return ShowPlayerDialogEx(playerid, dialogid, DIALOG_STYLE_TABLIST_HEADERS, title, szMiscArray, "Select", "Cancel");
}