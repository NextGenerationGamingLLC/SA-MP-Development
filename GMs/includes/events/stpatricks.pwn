new bool:StPatricksShop = false;

CMD:togstpatricksshop(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] > 1337 || PlayerInfo[playerid][pPR] == 2 || PlayerInfo[playerid][pShopTech] == 3)
	{
		if(!StPatricksShop)
			StPatricksShop = true, SendClientMessageEx(playerid, COLOR_RED, "You have toggled the St Patrick's Day shop on. It will now be available to players.");
		else
			StPatricksShop = false, SendClientMessageEx(playerid, COLOR_RED, "You have toggled the St Patrick's Day shop off. It will not be available to players.");
	}
	return 1;
}

CMD:stpatricksshop(playerid, params[])
{
	if(StPatricksShop == false) return SendClientMessageEx(playerid, COLOR_GREY, "The shop is currently closed.");
	if(!IsAtClothingStore(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You aren't at a clothes shop.");
	if(!GetPVarInt(playerid, "PinConfirmed")) return PinLogin(playerid);
	new beerList[] = {1543, 1544, 1484, 1486};
	ShowModelSelectionMenuEx(playerid, beerList, sizeof(beerList), "St Patrick's Day Shop", 0317, 0.0, 0.0, 180.0);
	return 1;
}

#include <YSI\y_hooks>
hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	if(dialogid == DIALOG_STPATRICKSSHOP)
	{
		if(!response) return DeletePVar(playerid, "StPatrickToy");
		szMiscArray[0] = 0;
		if(PlayerInfo[playerid][pCredits] < 150)
			return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");
		GivePlayerCredits(playerid, -150, 1);
		new name[24] = "None";
		for(new i; i < sizeof(HoldingObjectsAll); i++)
		{
			if(HoldingObjectsAll[i][holdingmodelid] == GetPVarInt(playerid, "StPatrickToy"))
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
				PlayerToyInfo[playerid][v][ptModelID] = GetPVarInt(playerid, "StPatrickToy");
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
				DeletePVar(playerid, "StPatrickToy");
				return 1;
			}
		}
		
		for(new i = 0; i < MAX_PLAYERTOYS; i++)
		{
			if(PlayerToyInfo[playerid][i][ptModelID] == 0)
			{
				PlayerToyInfo[playerid][i][ptModelID] = GetPVarInt(playerid, "StPatrickToy");
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
				DeletePVar(playerid, "StPatrickToy");
				break;
			}
		}
	}
	return 0;
}

//Created By AlexR - March 12, 2013 - v2.3.800
enum cP
{
	Float:cpPos[3],
	cpVW,
	cpInt
}

new const CharmPoints[][cP] = {
	{{-220.42, 1405.93, 27.76}, 1, 18},
	{{381.34, -188.12, 1000.63}, 1, 17},
	{{307.02, -142.24, 1004.06}, 1, 7},
	{{1221.35, 8.90, 1001.33}, 1, 2},
	{{2236.19, 1679.04, 1008.35}, 1, 1}
};
new ActiveCharmPoint = -1;
new ActiveCharmPointPickup = -1;
new Text3D:ActiveCharmPoint3DText;

new CharmMainTimer = 0;
new CharmReloadTimer = 0;

RemoveCharmPoint()
{
	if (ActiveCharmPoint == -1)
		return;

	if (IsValidDynamicPickup(ActiveCharmPointPickup))
	{
		DestroyDynamicPickup(ActiveCharmPointPickup);
		ActiveCharmPointPickup = -1;
	}

	if (IsValidDynamic3DTextLabel(ActiveCharmPoint3DText))
	{
		DestroyDynamic3DTextLabel(ActiveCharmPoint3DText);
	}

	// DON'T RESET ActiveCharmPoint
	// IT IS USED TO MAKE SURE NO POINT IS PICKED TWICE!
}

SelectCharmPoint()
{
	new rand = random(sizeof(CharmPoints));

	while (rand == ActiveCharmPoint) // force new point
	{
		rand = random(sizeof(CharmPoints));
	}

	if (ActiveCharmPoint != -1)
	{
		if (IsValidDynamicPickup(ActiveCharmPointPickup))
		{
			DestroyDynamicPickup(ActiveCharmPointPickup);
			ActiveCharmPointPickup = -1;
		}

		if (IsValidDynamic3DTextLabel(ActiveCharmPoint3DText))
		{
			DestroyDynamic3DTextLabel(ActiveCharmPoint3DText);
		}
	}

	ActiveCharmPointPickup = CreateDynamicPickup(1274, 23, CharmPoints[rand][cpPos][0], CharmPoints[rand][cpPos][1], CharmPoints[rand][cpPos][2], .worldid = CharmPoints[rand][cpVW], .interiorid =  CharmPoints[rand][cpInt]);
	ActiveCharmPoint3DText = CreateDynamic3DTextLabel("Collect your Lucky Charm tokens!\n/claimtokens", 0x37A621FF, CharmPoints[rand][cpPos][0], CharmPoints[rand][cpPos][1], CharmPoints[rand][cpPos][2] + 1.0, 100.0, .worldid = CharmPoints[rand][cpVW], .interiorid =  CharmPoints[rand][cpInt]);
	ActiveCharmPoint = rand;
	printf("%d(%d %d) %f %f %f %d %d", ActiveCharmPoint, ActiveCharmPointPickup, _:ActiveCharmPoint3DText, CharmPoints[rand][cpPos][0], CharmPoints[rand][cpPos][1], CharmPoints[rand][cpPos][2], CharmPoints[rand][cpVW], CharmPoints[rand][cpInt]);
}

stock IsPlayerInRangeOfCharm(playerid)
{
	if (ActiveCharmPoint == -1 || !IsValidDynamicPickup(ActiveCharmPointPickup))
		return false;

	new Float:x, Float:y, Float:z;
	x = CharmPoints[ActiveCharmPoint][cpPos][0];
	y = CharmPoints[ActiveCharmPoint][cpPos][1];
	z = CharmPoints[ActiveCharmPoint][cpPos][2];
	
	if (GetPlayerVirtualWorld(playerid) == CharmPoints[ActiveCharmPoint][cpVW] && GetPlayerInterior(playerid) == CharmPoints[ActiveCharmPoint][cpInt] && IsPlayerInRangeOfPoint(playerid, 1.0, x, y, z))
		return true;
	return false;
}

CMD:gotocharmpoint(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1)
	{
		SetPlayerPos(playerid, CharmPoints[ActiveCharmPoint][cpPos][0], CharmPoints[ActiveCharmPoint][cpPos][1], CharmPoints[ActiveCharmPoint][cpPos][2]);
		SetPlayerVirtualWorld(playerid, CharmPoints[ActiveCharmPoint][cpVW]);
		SetPlayerInterior(playerid, CharmPoints[ActiveCharmPoint][cpInt]);
	}
	return 1;
}

CMD:claimtokens(playerid, params[])
{
	if (IsPlayerInRangeOfCharm(playerid))
	{
		if (gettime() >= PlayerInfo[playerid][pLastCharmReceived] + 3600)
		{
			SendClientMessageEx(playerid, 0x37A621FF, "You collected 5 tokens!");
			PlayerInfo[playerid][pLastCharmReceived] = gettime();
			PlayerInfo[playerid][pEventTokens] += 5;
			return 1;
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GRAD2, "You have already received a charm from that point!");
			return 1;
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "You are not near the charm point!");
	}
	return 1;
}

CharmTimer()
{
	if (CharmReloadTimer == 0 && ++CharmMainTimer == 1800)
	{
		RemoveCharmPoint();
	}

	if (CharmMainTimer >= 1800)
	{
		if (++CharmReloadTimer == 5400)
		{
			SelectCharmPoint();
			CharmReloadTimer = 0;
			CharmMainTimer = 0;
		}
	}
}

CMD:claimtokeninfo(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1) return 1;
	szMiscArray[0] = 0;
	format(szMiscArray, sizeof(szMiscArray), "PointID: %d PickupID: %d 3DTextID: %d X: %f Y: %f Z: %f VW: %d Int: %d", ActiveCharmPoint, ActiveCharmPointPickup, _:ActiveCharmPoint3DText, CharmPoints[ActiveCharmPoint][cpPos][0], CharmPoints[ActiveCharmPoint][cpPos][1], CharmPoints[ActiveCharmPoint][cpPos][2], CharmPoints[ActiveCharmPoint][cpVW], CharmPoints[ActiveCharmPoint][cpInt]);
	SendClientMessageEx(playerid, -1, szMiscArray);
	format(szMiscArray, sizeof(szMiscArray), "MainTimer: %d ReloadTimer: %d PlayerLastCharmReceived: %d", CharmMainTimer, CharmReloadTimer, PlayerInfo[playerid][pLastCharmReceived]);
	SendClientMessageEx(playerid, -1, szMiscArray);
	return 1;
}