new bool:MemorialShop = false;

CMD:togmemorialshop(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] > 1337 || PlayerInfo[playerid][pPR] == 2 || PlayerInfo[playerid][pShopTech] == 3)
	{
		if(!MemorialShop)
			MemorialShop = true, SendClientMessageEx(playerid, COLOR_RED, "You have toggled the Memorial's Day shop on. It will now be available to players.");
		else
			MemorialShop = false, SendClientMessageEx(playerid, COLOR_RED, "You have toggled the Memorial's Day shop off. It will not be available to players.");
	}
	return 1;
}

CMD:memorialshop(playerid, params[])
{
	if(MemorialShop == false) return SendClientMessageEx(playerid, COLOR_GREY, "The shop is currently closed.");
	if(!IsAtClothingStore(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You aren't at a clothes shop.");
	if(!GetPVarInt(playerid, "PinConfirmed")) return PinLogin(playerid);
	new flagList[] = {2614, 11245};
	ShowModelSelectionMenuEx(playerid, flagList, sizeof(flagList), "Memorial's Day Shop", 0525, 0.0, 0.0, 180.0);
	return 1;
}

#include <YSI\y_hooks>
hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	if(dialogid == 0525)
	{
		if(!response) return DeletePVar(playerid, "MemorialToy");
		szMiscArray[0] = 0;
		if(PlayerInfo[playerid][pCredits] < 150)
			return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");
		GivePlayerCredits(playerid, -150, 1);
		new name[24] = "None";
		for(new i; i < sizeof(HoldingObjectsAll); i++)
		{
			if(HoldingObjectsAll[i][holdingmodelid] == GetPVarInt(playerid, "MemorialToy"))
			{
				format(name, sizeof(name), "%s", HoldingObjectsAll[i][holdingmodelname]);
				break;
			}
		}
		format(szMiscArray, sizeof(szMiscArray), "You have purchased the %s Toy for 150 credits.", name);
		SendClientMessageEx(playerid, COLOR_CYAN, szMiscArray);
		
		g_mysql_SaveAccount(playerid);
		
		format(szMiscArray, sizeof(szMiscArray), "[TOYSALE] [User: %s(%i)] [IP: %s] [Credits: %s] [%s] [Price: 150]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), name);
		Log("logs/toys.log", szMiscArray), print(szMiscArray);

		new icount = GetPlayerToySlots(playerid);
		for(new v = 0; v < icount; v++)
		{
			if(PlayerToyInfo[playerid][v][ptModelID] == 0)
			{
				PlayerToyInfo[playerid][v][ptModelID] = GetPVarInt(playerid, "MemorialToy");
				PlayerToyInfo[playerid][v][ptBone] = 5;
				PlayerToyInfo[playerid][v][ptPosX] = 0.0;
				PlayerToyInfo[playerid][v][ptPosY] = 0.0;
				PlayerToyInfo[playerid][v][ptPosZ] = 0.0;
				PlayerToyInfo[playerid][v][ptRotX] = 0.0;
				PlayerToyInfo[playerid][v][ptRotY] = 0.0;
				PlayerToyInfo[playerid][v][ptRotZ] = 0.0;
				PlayerToyInfo[playerid][v][ptScaleX] = 1.0;
				PlayerToyInfo[playerid][v][ptScaleY] = 1.0;
				PlayerToyInfo[playerid][v][ptScaleZ] = 1.0;
				PlayerToyInfo[playerid][v][ptTradable] = 1;
				
				g_mysql_NewToy(playerid, v);
				DeletePVar(playerid, "MemorialToy");
				return 1;
			}
		}
		
		for(new i = 0; i < MAX_PLAYERTOYS; i++)
		{
			if(PlayerToyInfo[playerid][i][ptModelID] == 0)
			{
				PlayerToyInfo[playerid][i][ptModelID] = GetPVarInt(playerid, "MemorialToy");
				PlayerToyInfo[playerid][i][ptBone] = 5;
				PlayerToyInfo[playerid][i][ptPosX] = 0.0;
				PlayerToyInfo[playerid][i][ptPosY] = 0.0;
				PlayerToyInfo[playerid][i][ptPosZ] = 0.0;
				PlayerToyInfo[playerid][i][ptRotX] = 0.0;
				PlayerToyInfo[playerid][i][ptRotY] = 0.0;
				PlayerToyInfo[playerid][i][ptRotZ] = 0.0;
				PlayerToyInfo[playerid][i][ptScaleX] = 1.0;
				PlayerToyInfo[playerid][i][ptScaleY] = 1.0;
				PlayerToyInfo[playerid][i][ptScaleZ] = 1.0;
				PlayerToyInfo[playerid][i][ptTradable] = 1;
				PlayerToyInfo[playerid][i][ptSpecial] = 1;
				
				g_mysql_NewToy(playerid, i); 
				
				SendClientMessageEx(playerid, COLOR_GRAD1, "Due to you not having any available slots, we've temporarily gave you an additional slot to use/sell/trade your toy.");
				SendClientMessageEx(playerid, COLOR_RED, "Note: Please take note that after selling the toy, the temporarily additional toy slot will be removed.");
				DeletePVar(playerid, "MemorialToy");
				break;
			}
		}
	}
	return 0;
}