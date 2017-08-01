#include <YSI\y_hooks>

/*
BRIEFING (TIM)

Jingles I have a very important update that if possible I would like pushed to the top of the list. 
There needs to be a booth at city hall players can sell their weapons back to the government. 
Gov leaders need to be able to set a buyback price for each gun and I would prefer a command that lets 
this stay in place and government leaders can do a command to start/stop the program. 

I want all sales to be logged as well so government can issue these weapons to factions in the future, 
and a counter made with the total sales of each gun. Also make it so if they set the price to 0 it wont allow players \
to sell that gun. Make the money come out of the government vault as well. Thanks!
*/

new arrWeaponCosts[47]; // array to store the costs in (NOTE: 46 has the open/close value!!)

new GovArmsPoint;

hook OnGameModeInit()
{
	GovGuns_Streamer();
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	switch(dialogid)
	{
		case DIALOG_GOVGUN_MAIN:
		{
			if(response) switch(listitem)
			{
				case 0: return mysql_tquery(MainPipeline, "SELECT * FROM `govgunsales` WHERE 1", "GovGuns_OnShowSales", "i", playerid); 
				case 1:
				{
					GovGuns_EditPrices(playerid);
				}
				case 2:
				{
					szMiscArray[0] = 0;
					switch(arrWeaponCosts[46])
					{
						case 0:
						{
							arrWeaponCosts[46] = 1;
							format(szMiscArray, sizeof(szMiscArray), "%s has opened the Government Arms Center.", GetPlayerNameEx(playerid));
							SendGroupMessage(arrGroupData[PlayerInfo[playerid][pMember]][g_iGroupType], DEPTRADIO, szMiscArray);
							return 1;
						}
						default:
						{
							arrWeaponCosts[46] = 0;
							format(szMiscArray, sizeof(szMiscArray), "%s has closed the Government Arms Center.", GetPlayerNameEx(playerid));
							SendGroupMessage(arrGroupData[PlayerInfo[playerid][pMember]][g_iGroupType], DEPTRADIO, szMiscArray);
							return 1;
						}
					}
				}
			}
		}
		case DIALOG_GOVGUN_EDITPRICE:
		{
			if(response)
			{
				szMiscArray[0] = 0;
				new wepid = ListItemTrackId[playerid][listitem];
				SetPVarInt(playerid, "_GovGun", wepid);
				format(szMiscArray, sizeof(szMiscArray), "Edit the purchase price of the {00FFFF}%s {FFFFFF}\n\n Current purchase price: $%s", Weapon_ReturnName(wepid), number_format(arrWeaponCosts[wepid]));
				return ShowPlayerDialogEx(playerid, DIALOG_GOVGUN_EDITPRICE2, DIALOG_STYLE_INPUT, "Government Arms | Edit Weapon Price", szMiscArray, "Proceed", "Cancel");
			}
		}
		case DIALOG_GOVGUN_SELL:
		{
			if(response)
			{
				szMiscArray[0] = 0;
				new wepid = ListItemTrackId[playerid][listitem];
				SetPVarInt(playerid, "_GovGun", wepid);
				format(szMiscArray, sizeof(szMiscArray), "Are you sure you want to sell your %s for: {FF0000}$%s{FFFFFF}?", Weapon_ReturnName(wepid), number_format(arrWeaponCosts[wepid]));
				return ShowPlayerDialogEx(playerid, DIALOG_GOVGUN_SELL2, DIALOG_STYLE_MSGBOX, "Government Arms | Sell Gun", szMiscArray, "Sell", "Cancel");
			}
		}
		case DIALOG_GOVGUN_EDITPRICE2:
		{
			if(response)
			{
				szMiscArray[0] = 0;
				new wepid = GetPVarInt(playerid, "_GovGun");
				arrWeaponCosts[wepid] = strval(inputtext);
				mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "UPDATE `govgunsales` SET `wepprice` = %d WHERE `wepid` = %d", strval(inputtext), wepid);
				mysql_tquery(MainPipeline, szMiscArray, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
				format(szMiscArray, sizeof(szMiscArray), "You have edited the %s's price to: {FFFFFF}$%s", Weapon_ReturnName(wepid), number_format(arrWeaponCosts[wepid]));
				SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
				DeletePVar(playerid, "_GovGun");
				return GovGuns_EditPrices(playerid);
			}
		}
		case DIALOG_GOVGUN_SELL2:
		{
			if(response)
			{
				szMiscArray[0] = 0;
				new iGroupID;
				for(iGroupID = 0; iGroupID < MAX_GROUPS; ++iGroupID)
				{
					if(arrGroupData[iGroupID][g_iGroupType] == 5) break;
				}
				new wepid = GetPVarInt(playerid, "_GovGun");
				if(arrGroupData[iGroupID][g_iBudget] < arrWeaponCosts[wepid]) return SendClientMessageEx(playerid, COLOR_GRAD1, "The government doesn't have enough funds to pay you.");
				GivePlayerCash(playerid, arrWeaponCosts[wepid]);
				RemovePlayerWeapon(playerid, wepid);
				arrGroupData[iGroupID][g_iBudget] -= arrWeaponCosts[wepid];
	            format(szMiscArray, sizeof(szMiscArray), "%s sold their %s at a cost of $%d to %s's budget fund.",GetPlayerNameEx(playerid), Weapon_ReturnName(wepid), arrWeaponCosts[wepid], arrGroupData[iGroupID][g_szGroupName]);
				GroupPayLog(iGroupID, szMiscArray);
				szMiscArray[0] = 0; // unsure if this is needed.
				format(szMiscArray, sizeof(szMiscArray), "You have sold your %s for {FFFFFF}$%s", Weapon_ReturnName(wepid), number_format(arrWeaponCosts[wepid]));
				SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
				szMiscArray[0] = 0;
				mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "UPDATE `govgunsales` SET `wepsales` = `wepsales` + 1 WHERE `wepid` = %d", wepid);
				mysql_tquery(MainPipeline, szMiscArray, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
				szMiscArray[0] = 0;
				format(szMiscArray, sizeof(szMiscArray), "%s sells their %s to the government.", GetPlayerNameEx(playerid), Weapon_ReturnName(wepid));
				ProxDetector(8.0, playerid, szMiscArray, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
				DeletePVar(playerid, "_GovGun");
				return 1;
			}
		}
		case DIALOG_GOVGUNS_SALES:
		{
			return GovGuns_MainMenu(playerid);
		}
		case ARMS_MENU: {
			if(!response) return SendClientMessageEx(playerid, COLOR_GREY, "You have left the government arms center.");

			switch(listitem) {
				case 0: {
					
					if(!response) return ShowArmsMenu(playerid);

					new szWeaponName[32],
						iCount, iAmmo, iWepID;

					if(!IsPlayerInRangeOfPoint(playerid, 5.0, 1464.3099, -1747.5853, 15.6267)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You aren't at the government arms point at City Hall in Los Santos.");
					if(arrWeaponCosts[46] == 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "The government arms center is currently closed.");
					szMiscArray = "Name\tSale Price\n";
					for(new i; i < 12; ++i) {
						
						GetPlayerWeaponData(playerid, i, iWepID, iAmmo);
						if(PlayerInfo[playerid][pGuns][i] == iWepID && GovGuns_IsSelling(iWepID)) {
							ListItemTrackId[playerid][iCount] = iWepID;
							szWeaponName = Weapon_ReturnName(iWepID);
							format(szMiscArray, sizeof(szMiscArray), "%s%s\t$%s\n", szMiscArray, szWeaponName, number_format(arrWeaponCosts[iWepID]));
							iCount++;
						}
					}
					if(iCount == 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "You do not have any weapons that you can sell to the government.");
					ShowPlayerDialogEx(playerid, DIALOG_GOVGUN_SELL, DIALOG_STYLE_TABLIST_HEADERS, "Government Arms | Sell Gun", szMiscArray, "Cancel", "Sell");	
				}
				case 1: {

					if(!response) return ShowArmsMenu(playerid);

					if(PlayerInfo[playerid][pGunLic] > gettime()) return SendClientMessageEx(playerid, COLOR_GRAD2, "You already have a valid gun license");

					ShowPlayerDialogEx(playerid, APPLY_GUN_LIC, DIALOG_STYLE_MSGBOX, 
						"Gun License Application", 
						"You are about to apply for a gun license\nYou will have a background check for crimes for the last 3 weeks\nThis process will cost $100,000", 
						"Apply", 
						"Cancel"
					);
				}
			}
		}
	}
	return 0;
}

GovGuns_MainMenu(playerid)
{
	szMiscArray[0] = 0;
	switch(arrWeaponCosts[46])
	{
		case 0: szMiscArray = "{FF0000}Closed";
		case 1: szMiscArray = "{00FF00}Open";
	}
	format(szMiscArray, sizeof(szMiscArray), "List purchases\nEdit purchase prices\nOpen/Close Center (currently: %s{FFFFFF})", szMiscArray);
	return ShowPlayerDialogEx(playerid, DIALOG_GOVGUN_MAIN, DIALOG_STYLE_LIST, "Government Arms Center | Main Menu", szMiscArray, "Select", "");
}

GovGuns_LoadCosts()
{
	mysql_tquery(MainPipeline, "SELECT * FROM `govgunsales` WHERE 1", "GovGuns_OnLoadCosts", "");
	return 1;
}

GovGuns_Streamer()
{
	CreateDynamicObject(3430, 1464.40723, -1750.29785, 15.8659,   0.00000, 0.00000, 300.33374);
	CreateDynamic3DTextLabel("Government Arms Center\n{DDDDDD}Press ~k~~CONVERSATION_YES~ to access the menu", COLOR_YELLOW, 1464.3186,-1747.9330,15.9453, 8.0);
	GovArmsPoint = CreateDynamicSphere(1464.3186,-1747.9330,15.445, 5.00);
}

GovGuns_IsSellingEdit(i)
{
	switch(i)
	{
		case 22 .. 34: return 1; // enter IDs of weapons that are enabled for sale.
	}
	return 0;
}

GovGuns_IsSelling(i)
{
	switch(i)
	{
		case 22 .. 34: if(arrWeaponCosts[i] > 0) return 1; // enter IDs of weapons that are enabled for sale.
	}
	return 0;
}


GovGuns_EditPrices(playerid)
{
	szMiscArray[0] = 0;
	new iCount;
	szMiscArray = "Name\tPurchase Price\n";
	for(new i; i < 46; ++i)
	{
		if(GovGuns_IsSellingEdit(i)) 
		{
			ListItemTrackId[playerid][iCount] = i;
			format(szMiscArray, sizeof(szMiscArray), "%s%s\t$%s\n", szMiscArray, Weapon_ReturnName(i), number_format(arrWeaponCosts[i]));
			iCount++;
		}
	}
	return ShowPlayerDialogEx(playerid, DIALOG_GOVGUN_EDITPRICE, DIALOG_STYLE_TABLIST_HEADERS, "Government Arms | Edit Purchase Price", szMiscArray, "Edit", "Cancel");		
}

forward GovGuns_OnLoadCosts();
public GovGuns_OnLoadCosts()
{
	new iRows, iCount;
	cache_get_row_count(iRows);
	while(iCount < iRows) 
	{
		cache_get_value_name_int(iCount, "wepprice", arrWeaponCosts[iCount]);
		iCount++;
	}
	printf("[Gov Weapon Prices] Loaded %i Weapons", iCount);
	return 1;
}

forward GovGuns_OnShowSales(playerid);
public GovGuns_OnShowSales(playerid)
{
	new iRows, iCount;
	cache_get_row_count(iRows);
	if(!iRows) return SendClientMessageEx(playerid, COLOR_GRAD1, "Something went wrong. Please try again later.");
	szMiscArray = "Name\tSold\n";
	while(iCount < iRows) 
	{
		if(GovGuns_IsSellingEdit(iCount))
		{
			new value;
			format(szMiscArray, sizeof(szMiscArray), "%s%s\t%spc\n", szMiscArray, Weapon_ReturnName(iCount), number_format(cache_get_value_name_int(iCount, "wepsales", value)));
		}
		iCount++;
	}
	return ShowPlayerDialogEx(playerid, DIALOG_GOVGUNS_SALES, DIALOG_STYLE_TABLIST_HEADERS, "Government Arms | Sales", szMiscArray, "<<", "");
}

CMD:govarms(playerid, params[])
{
	if(IsAGovernment(playerid) && PlayerInfo[playerid][pMember] == PlayerInfo[playerid][pLeader])
	{
		GovGuns_MainMenu(playerid);
	}
	else SendClientMessageEx(playerid, COLOR_GRAD1, "You are not a leader in the government.");
	return 1;
}

/*CMD:sellgovgun(playerid, params[])
{
	szMiscArray[0] = 0;
	new szWeaponName[32],
		iCount, iAmmo, iWepID;
	if(!IsPlayerInRangeOfPoint(playerid, 5.0, 1464.3099, -1747.5853, 15.6267)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You aren't at the government arms point at City Hall in Los Santos.");
	if(arrWeaponCosts[46] == 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "The government arms center is currently closed.");
	szMiscArray = "Name\tSale Price\n";
	for(new i; i < 12; ++i)
	{
		GetPlayerWeaponData(playerid, i, iWepID, iAmmo);
		if(PlayerInfo[playerid][pGuns][i] == iWepID && GovGuns_IsSelling(iWepID))
		{
			ListItemTrackId[playerid][iCount] = iWepID;
			szWeaponName = Weapon_ReturnName(iWepID);
			format(szMiscArray, sizeof(szMiscArray), "%s%s\t$%s\n", szMiscArray, szWeaponName, number_format(arrWeaponCosts[iWepID]));
			iCount++;
		}
	}
	if(iCount == 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "You do not have any weapons that you can sell to the government.");
	ShowPlayerDialogEx(playerid, DIALOG_GOVGUN_SELL, DIALOG_STYLE_TABLIST_HEADERS, "Government Arms | Sell Gun", szMiscArray, "Cancel", "Sell");
	return 1;
}*/

ShowArmsMenu(playerid) {
		
	szMiscArray[0] = 0;

	format(szMiscArray, sizeof(szMiscArray), "{FF8000}** {C2A2DA}%s approaches the ATM, typing in their PIN.", GetPlayerNameEx(playerid));
	SetPlayerChatBubble(playerid, szMiscArray, COLOR_PURPLE, 15.0, 5000);

	ShowPlayerDialogEx(playerid, ARMS_MENU, DIALOG_STYLE_LIST, "Arms Menu", "Sell gun to gov\nFirearm License", "Select", "Cancel");

	return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {

	if(newkeys & KEY_YES && IsPlayerInDynamicArea(playerid, GovArmsPoint)) {
		ShowArmsMenu(playerid);
	}
	return 1;
}