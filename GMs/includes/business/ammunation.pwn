#include <YSI\y_hooks>

CMD:buygun(playerid, params[])
{
	szMiscArray[0] = 0;
	new business = InBusiness(playerid);

	if(business == INVALID_BUSINESS_ID || Businesses[business][bType] != BUSINESS_TYPE_GUNSHOP) return SendClientMessageEx(playerid, COLOR_WHITE, "You are not at a gunshop!");
	if(PlayerInfo[playerid][pConnectHours] < 8) return SendClientMessageEx(playerid, COLOR_WHITE, "You have not played enough to obtain a weapon!");

	format(szMiscArray, sizeof(szMiscArray), "Weapon\tPrice\n9mm Pistol\t$%s\nPump Shotgun\t$%s\nDeagle\t$%s", number_format(GunPrices[0]), number_format(GunPrices[1]), number_format(GunPrices[2]));
	ShowPlayerDialogEx(playerid, DIALOG_AMMUNATION_GUNS, DIALOG_STYLE_TABLIST_HEADERS, "Ammunation Menu - Weapons", szMiscArray, "Select", "Back");
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
		SendClientMessageEx(playerid, COLOR_WHITE, "Available choices: colt45, shotgun, deagle");
		format(szMiscArray, sizeof(szMiscArray), "colt45: $%s | shotgun: $%s | Deagle: $%s", number_format(GunPrices[0]), number_format(GunPrices[1]), number_format(GunPrices[2]));
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
	g_mysql_SaveMOTD();
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	szMiscArray[0] = 0;
	switch(dialogid)
	{
		case DIALOG_AMMUNATION_GUNS:
		{
			if(PlayerInfo[playerid][pGunLic] < gettime())
				return SendClientMessageEx(playerid, COLOR_GREY, "You must have an active license to purchase guns from a gun-shop!");
			if(!response)
				return 1;

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
					GivePlayerValidWeapon(playerid, WEAPON_COLT45);

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
					GivePlayerValidWeapon(playerid, WEAPON_SHOTGUN);

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
					GivePlayerValidWeapon(playerid, WEAPON_DEAGLE);

					format(szMiscArray, sizeof(szMiscArray), "%s has purchased deagle for $%s at %s", GetPlayerNameEx(playerid), number_format(GunPrices[2]), Businesses[business][bName]);
					SendClientMessageEx(playerid, -1, szMiscArray);
					Log("logs/business.log", szMiscArray);
				}
			}
		}
	}
	return 0;
}