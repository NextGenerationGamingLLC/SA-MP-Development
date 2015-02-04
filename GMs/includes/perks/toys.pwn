/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Toy System

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

stock CompleteToyTrade(playerid)
{
	new string[156],
		sellerid = GetPVarInt(playerid, "ttSeller"),
		name[24],
		toyid = GetPVarInt(sellerid, "ttToy");
				
	for(new i;i<sizeof(HoldingObjectsAll);i++)
	{
		if(HoldingObjectsAll[i][holdingmodelid] == toyid)
		{
			format(name, sizeof(name), "(%s)", HoldingObjectsAll[i][holdingmodelname]);
		}
	}
	if(toyid != 0 && (strcmp(name, "None", true) == 0))
	{
		format(name, sizeof(name), "(ID: %d)", toyid);
	}
	
	new icount = GetPlayerToySlots(playerid);
	
	if(!toyCountCheck(playerid))
	{
		format(string, sizeof(string), "%s has declined the toy offer. (no free toy slots)", GetPlayerNameEx(playerid));
		SendClientMessageEx(sellerid, COLOR_GREY, string);
		SendClientMessageEx(playerid, COLOR_GREY, "You don't have any free toy slots.");
		SetPVarInt(GetPVarInt(playerid, "ttSeller"), "ttBuyer", INVALID_PLAYER_ID);
		SetPVarInt(GetPVarInt(playerid, "ttSeller"), "ttCost", 0);
		SetPVarInt(playerid, "ttSeller", INVALID_PLAYER_ID);
					
		HideTradeToysGUI(playerid);
		return 1;
	}	
	
	if(GetPlayerCash(playerid) < GetPVarInt(sellerid, "ttCost"))
	{
		format(string, sizeof(string), "%s has declined the toy offer. (Not enough money)", GetPlayerNameEx(playerid));
		SendClientMessageEx(sellerid, COLOR_GREY, string);
		SendClientMessageEx(playerid, COLOR_GREY, "You do not have enough money on you.");
		SetPVarInt(GetPVarInt(playerid, "ttSeller"), "ttBuyer", INVALID_PLAYER_ID);
		SetPVarInt(GetPVarInt(playerid, "ttSeller"), "ttCost", 0);
		SetPVarInt(playerid, "ttSeller", INVALID_PLAYER_ID);
				
		HideTradeToysGUI(playerid);
		return 1;
	}	
		
	GivePlayerCash(playerid, -GetPVarInt(sellerid, "ttCost"));
	GivePlayerCash(sellerid, GetPVarInt(sellerid, "ttCost"));
	
	for(new i = 0; i < icount; i++)
	{
		if(!PlayerToyInfo[playerid][i][ptModelID]) 
		{
			PlayerToyInfo[playerid][i][ptModelID] = toyid;
			PlayerToyInfo[playerid][i][ptBone] = 1; // Doesn't need to be accurate, you can let the player choose.
			PlayerToyInfo[playerid][i][ptPosX] = 1.0;
			PlayerToyInfo[playerid][i][ptPosY] = 1.0;
			PlayerToyInfo[playerid][i][ptPosZ] = 1.0;
			PlayerToyInfo[playerid][i][ptRotX] = 0.0;
			PlayerToyInfo[playerid][i][ptRotY] = 0.0;
			PlayerToyInfo[playerid][i][ptRotZ] = 0.0;
			PlayerToyInfo[playerid][i][ptScaleX] = 1.0;
			PlayerToyInfo[playerid][i][ptScaleY] = 1.0;
			PlayerToyInfo[playerid][i][ptScaleZ] = 1.0;
			PlayerToyInfo[playerid][i][ptTradable] = 1;
			
			if(PlayerToyInfo[sellerid][GetPVarInt(sellerid, "ttToySlot")][ptSpecial] == 1) 
			{
				PlayerToyInfo[playerid][i][ptSpecial] = 0;
			}
			else
				PlayerToyInfo[playerid][i][ptSpecial] = PlayerToyInfo[sellerid][GetPVarInt(sellerid, "ttToySlot")][ptSpecial];
			if(PlayerToyInfo[playerid][i][ptSpecial] == 2)
			{
				PlayerToyInfo[playerid][i][ptBone] = 2;
				PlayerToyInfo[playerid][i][ptPosX] = 0.07;
				PlayerToyInfo[playerid][i][ptPosY] = 0.0;
				PlayerToyInfo[playerid][i][ptPosZ] = 0.0;
				PlayerToyInfo[playerid][i][ptRotX] = 88.0;
				PlayerToyInfo[playerid][i][ptRotY] = 75.0;
				PlayerToyInfo[playerid][i][ptRotZ] = 0.0;
				PlayerToyInfo[playerid][i][ptScaleX] = 0.0;
				PlayerToyInfo[playerid][i][ptScaleY] = 0.0;
				PlayerToyInfo[playerid][i][ptScaleZ] = 0.0;
			}
			// Seller	
			format(string, sizeof(string), "DELETE FROM `toys` WHERE `id` = '%d'", PlayerToyInfo[sellerid][GetPVarInt(sellerid, "ttToySlot")][ptID]);
			mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "ii", SENDDATA_THREAD, sellerid);
				
			g_mysql_NewToy(playerid, i);
			break;
		}	
	}
	
	PlayerToyInfo[sellerid][GetPVarInt(sellerid, "ttToySlot")][ptID] = 0;
	PlayerToyInfo[sellerid][GetPVarInt(sellerid, "ttToySlot")][ptModelID] = 0;
	PlayerToyInfo[sellerid][GetPVarInt(sellerid, "ttToySlot")][ptBone] = 0;
	PlayerToyInfo[sellerid][GetPVarInt(sellerid, "ttToySlot")][ptSpecial] = 0;
	
	OnPlayerStatsUpdate(playerid);
	OnPlayerStatsUpdate(sellerid);
			
	format(string, sizeof(string), "%s has accepted your offer and purchased your toy for $%s. %s", GetPlayerNameEx(playerid), number_format(GetPVarInt(sellerid, "ttCost")), name);
	SendClientMessageEx(sellerid, COLOR_LIGHTBLUE, string);
	format(string, sizeof(string), "You have accepted %s's offer and purchased the toy for $%s. %s", GetPlayerNameEx(sellerid), number_format(GetPVarInt(sellerid, "ttCost")), name);
	SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	format(string, sizeof(string), "[S %s(%d)][IP %s][B %s(%d)][IP %s][P $%s][T: %s(%d)]", GetPlayerNameEx(sellerid), GetPlayerSQLId(sellerid), GetPlayerIpEx(sellerid),
	GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(GetPVarInt(sellerid, "ttCost")), name, toyid);
	Log("logs/toys.log", string);
			
	SetPVarInt(GetPVarInt(playerid, "ttSeller"), "ttSeller", INVALID_PLAYER_ID);
	SetPVarInt(GetPVarInt(playerid, "ttSeller"), "ttBuyer", INVALID_PLAYER_ID);
	SetPVarInt(GetPVarInt(playerid, "ttSeller"), "ttCost", 0);
	SetPVarInt(playerid, "ttSeller", INVALID_PLAYER_ID);
			
	HideTradeToysGUI(playerid);
	return 1;
}

stock ShowEditMenu(playerid)
{
	new
		iIndex = GetPVarInt(playerid, "ToySlot");

	new toys = 99999;			
	for(new i; i < 10; i++)
	{
		if(PlayerHoldingObject[playerid][i] == iIndex)
		{
			toys = i;
			if(IsPlayerAttachedObjectSlotUsed(playerid, toys))
			{
				PlayerHoldingObject[playerid][i] = 0;
				if(!PlayerInfo[playerid][pBEquipped]) RemovePlayerAttachedObject(playerid, toys);
			}
			break;
		}
	}	
	if(PlayerToyInfo[playerid][iIndex][ptScaleX] == 0) {
		PlayerToyInfo[playerid][iIndex][ptScaleX] = 1.0;
		PlayerToyInfo[playerid][iIndex][ptScaleY] = 1.0;
		PlayerToyInfo[playerid][iIndex][ptScaleZ] = 1.0;
	}
	if(IsPlayerInAnyVehicle(playerid) && PlayerToyInfo[playerid][iIndex][ptSpecial] == 2)
		return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Edit your toy", "You cannot edit toys while you are inside a vehicle!", "Okay", "");
	new toycount = GetFreeToySlot(playerid);
	if(toycount == -1) return SendClientMessageEx(playerid, COLOR_GRAD1, "You currently have 10 objects attached, please deattach an object.");
	if(toycount == 9 && PlayerInfo[playerid][pBEquipped]) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot attach an object to slot 10 since you have a backpack equipped.");
	PlayerHoldingObject[playerid][toycount] = iIndex;
	SetPlayerAttachedObject(playerid, toycount, PlayerToyInfo[playerid][iIndex][ptModelID],
	PlayerToyInfo[playerid][iIndex][ptBone], PlayerToyInfo[playerid][iIndex][ptPosX],
	PlayerToyInfo[playerid][iIndex][ptPosY], PlayerToyInfo[playerid][iIndex][ptPosZ],
	PlayerToyInfo[playerid][iIndex][ptRotX], PlayerToyInfo[playerid][iIndex][ptRotY],
	PlayerToyInfo[playerid][iIndex][ptRotZ], PlayerToyInfo[playerid][iIndex][ptScaleX],
	PlayerToyInfo[playerid][iIndex][ptScaleY], PlayerToyInfo[playerid][iIndex][ptScaleZ]);

    new stringg[128];
    format(stringg, sizeof(stringg), "Bone (%s)\nOffset", HoldingBones[PlayerToyInfo[playerid][iIndex][ptBone]]);
 	ShowPlayerDialog(playerid, EDITTOYS2, DIALOG_STYLE_LIST, "Toy Menu: Edit", stringg, "Select", "Cancel");
	return 1;
}

stock FindFreeAttachedObjectSlot(playerid)
{
	new index;
 	while (index < MAX_PLAYER_ATTACHED_OBJECTS && IsPlayerAttachedObjectSlotUsed(playerid, index))
	{
		index++;
	}
	if (index == MAX_PLAYER_ATTACHED_OBJECTS) return -1;
	return index;
}

toyCountCheck(playerid) {

	new
		iCount = GetPlayerToyCount(playerid),
		special = GetSpecialPlayerToyCount(playerid);
	if(iCount >= 10 + PlayerInfo[playerid][pToySlot] + special) return 0;
	return 1;
}

GetPlayerToyCount(playerid)
{
	new toys = 0;
	for(new i = 0; i < MAX_PLAYERTOYS; i++) if(PlayerToyInfo[playerid][i][ptModelID]) ++toys;
	return toys;
}

GetSpecialPlayerToyCount(playerid)
{
	new toys = 0;
	for(new i = 0; i < MAX_PLAYERTOYS; i++) if(PlayerToyInfo[playerid][i][ptSpecial] != 0) ++toys;
	return toys;
}

GetSpecialPlayerToyCountEx(playerid, special)
{
	new toys = 0;
	for(new i = 0; i < MAX_PLAYERTOYS; i++) if(PlayerToyInfo[playerid][i][ptSpecial] == special) ++toys;
	return toys;
}

/* GetSpecialFuncPlayerToyCount(playerid)
{
	new toys = 0;
	for(new i = 0; i < MAX_PLAYERTOYS; i++) if(PlayerToyInfo[playerid][i][ptSpecial] > 1) ++toys;
	return toys;
} */	

GetFreeToySlot(playerid)
{
	for(new i = 0; i < 10; i++) {
		if(PlayerHoldingObject[playerid][i] == 0) {
			return i;
		}
	}
	return -1;
}

GetPlayerToySlots(playerid)
{
	new special =  GetSpecialPlayerToyCount(playerid);
	return PlayerInfo[playerid][pToySlot] + 10 + special;
}

stock player_remove_vip_toys(iTargetID)
{
	if(PlayerInfo[iTargetID][pDonateRank] >= 3) return 1;
	else for(new iToyIter; iToyIter < MAX_PLAYER_ATTACHED_OBJECTS; ++iToyIter) {
		for(new LoopRapist; LoopRapist < sizeof(HoldingObjectsCop); ++LoopRapist) {
			if(HoldingObjectsCop[LoopRapist][holdingmodelid] == PlayerToyInfo[iTargetID][iToyIter][ptModelID]) {
				PlayerToyInfo[iTargetID][iToyIter][ptModelID] = 0;
				PlayerToyInfo[iTargetID][iToyIter][ptBone] = 0;
				PlayerToyInfo[iTargetID][iToyIter][ptPosX] = 0.0;
				PlayerToyInfo[iTargetID][iToyIter][ptPosY] = 0.0;
				PlayerToyInfo[iTargetID][iToyIter][ptPosZ] = 0.0;
				PlayerToyInfo[iTargetID][iToyIter][ptPosX] = 0.0;
				PlayerToyInfo[iTargetID][iToyIter][ptPosY] = 0.0;
				PlayerToyInfo[iTargetID][iToyIter][ptPosZ] = 0.0;
				if(IsPlayerAttachedObjectSlotUsed(iTargetID, iToyIter)) RemovePlayerAttachedObject(iTargetID, iToyIter);

				g_mysql_SaveToys(iTargetID, iToyIter);
			}
		}
	}
	SendClientMessageEx(iTargetID, COLOR_WHITE, "All accessories/toys that were property of your former employer have been removed.");
	return 1;
}

CMD:shopvest(playerid, params[])
{
	if (PlayerInfo[playerid][pShopTech] < 1 && PlayerInfo[playerid][pAdmin] < 1338)
	{
		SendClientMessageEx(playerid, COLOR_GREY, " You are not allowed to use this command.");
		return 1;
	}

	new string[128], giveplayerid, slot, invoice[64];
	if(sscanf(params, "uds[64]", giveplayerid, slot, invoice)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /shopvest [player] [slot(0-9)] [invoice #]");

	PlayerToyInfo[giveplayerid][slot][ptModelID] = 19142;
	PlayerToyInfo[giveplayerid][slot][ptBone] = 1;
	PlayerToyInfo[giveplayerid][slot][ptTradable] = 1;
	g_mysql_NewToy(giveplayerid, slot);
	format(string, sizeof(string), "You have been given a police vest in slot %d, use /toys to manage it", slot);
	SendClientMessageEx(giveplayerid, COLOR_LIGHTGREEN, string);
	format(string, sizeof(string), "You have given %s a police vest in slot %d", GetPlayerNameEx(giveplayerid), slot);
	SendClientMessageEx(playerid, COLOR_LIGHTGREEN, string);
	format(string, sizeof(string), "[SHOPVEST] %s has given %s(%d) a police vest toy - Invoice %s", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), invoice);
	Log("logs/shoplog.log", string);

	g_mysql_SaveToys(giveplayerid, slot);
	return 1;
}

CMD:listtoys(playerid, params[]) {
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pShopTech] >= 1) {

		new
			giveplayerid, stringg[4096], string[64];

		if(sscanf(params, "u", giveplayerid)) {
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /listtoys [player]");
		}
		else if(IsPlayerConnected(giveplayerid))
		{
			new icount = GetPlayerToySlots(giveplayerid);
		    for(new x;x<icount;x++)
			{
				new name[24] = "None";

				for(new i;i<sizeof(HoldingObjectsAll);i++)
				{
					if(HoldingObjectsAll[i][holdingmodelid] == PlayerToyInfo[giveplayerid][x][ptModelID])
					{
						format(name, sizeof(name), "%s", HoldingObjectsAll[i][holdingmodelname]);
						break;
					}
				}
				if(PlayerToyInfo[giveplayerid][x][ptModelID] != 0 && (strcmp(name, "None", true) == 0))
				{
				    format(name, sizeof(name), "ID: %d", PlayerToyInfo[giveplayerid][x][ptModelID]);
				}
				format(stringg, sizeof(stringg), "%s(%d) %s (Bone: %s%s)\n", stringg, x, name, HoldingBones[PlayerToyInfo[giveplayerid][x][ptBone]], (PlayerToyInfo[giveplayerid][x][ptSpecial] > 1) ? (", Special") : (""));
			}
			format(string, sizeof(string), "Listing %s's Toys - Select a Slot", GetPlayerNameEx(giveplayerid));
			ShowPlayerDialog(playerid, LISTTOYS_DELETETOY, DIALOG_STYLE_LIST, string, stringg, "Delete", "Cancel");
			SetPVarInt(playerid, "listtoys_giveplayerid", giveplayerid);
		}
		else SendClientMessageEx(playerid, COLOR_GRAD2, "Invalid player specified.");
	}
	return 1;
}

CMD:shoplaser(playerid, params[])
{
	if (PlayerInfo[playerid][pShopTech] < 1 && PlayerInfo[playerid][pAdmin] < 1338)
	{
		SendClientMessageEx(playerid, COLOR_GREY, " You are not allowed to use this command.");
		return 1;
	}

	new string[128], giveplayerid, slot, color[32], invoice[64];
	if(sscanf(params, "udss[64]", giveplayerid, slot, color, invoice)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /shoplaser [player] [slot(0-9)] [red/green/orange/yellow/pink/blue] [invoice #]");

	if(strcmp(color,"red",true) == 0)
	{
		PlayerToyInfo[giveplayerid][slot][ptModelID] = 18643;
		PlayerToyInfo[giveplayerid][slot][ptBone] = 6;
		PlayerToyInfo[giveplayerid][slot][ptTradable] = 1;
		g_mysql_NewToy(giveplayerid, slot);
	}
	else if(strcmp(color,"green",true) == 0)
	{
		PlayerToyInfo[giveplayerid][slot][ptModelID] = 19083;
		PlayerToyInfo[giveplayerid][slot][ptBone] = 6;
		PlayerToyInfo[giveplayerid][slot][ptTradable] = 1;
		g_mysql_NewToy(giveplayerid, slot);
	}
	else if(strcmp(color,"orange",true) == 0)
	{
		PlayerToyInfo[giveplayerid][slot][ptModelID] = 19082;
		PlayerToyInfo[giveplayerid][slot][ptBone] = 6;
		PlayerToyInfo[giveplayerid][slot][ptTradable] = 1;
		g_mysql_NewToy(giveplayerid, slot);
	}
	else if(strcmp(color,"yellow",true) == 0)
	{
		PlayerToyInfo[giveplayerid][slot][ptModelID] = 19084;
		PlayerToyInfo[giveplayerid][slot][ptBone] = 6;
		PlayerToyInfo[giveplayerid][slot][ptTradable] = 1;
		g_mysql_NewToy(giveplayerid, slot);
	}
	else if(strcmp(color,"pink",true) == 0)
	{
		PlayerToyInfo[giveplayerid][slot][ptModelID] = 19081;
		PlayerToyInfo[giveplayerid][slot][ptBone] = 6;
		PlayerToyInfo[giveplayerid][slot][ptTradable] = 1;
		g_mysql_NewToy(giveplayerid, slot);
	}
	else if(strcmp(color,"blue",true) == 0)
	{
		PlayerToyInfo[giveplayerid][slot][ptModelID] = 19080;
		PlayerToyInfo[giveplayerid][slot][ptBone] = 6;
		PlayerToyInfo[giveplayerid][slot][ptTradable] = 1;
		g_mysql_NewToy(giveplayerid, slot);
	}
	format(string, sizeof(string), "You have been given a %s laser in slot %d, use /toys to manage it", color, slot);
	SendClientMessageEx(giveplayerid, COLOR_LIGHTGREEN, string);
	format(string, sizeof(string), "You have given %s a %s laser in slot %d", GetPlayerNameEx(giveplayerid), color, slot);
	SendClientMessageEx(playerid, COLOR_LIGHTGREEN, string);
	format(string, sizeof(string), "[SHOPLASER] %s has given %s(%d) a laser toy - Invoice %s", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), invoice);
	Log("logs/shoplog.log", string);

	g_mysql_SaveToys(giveplayerid, slot);
	return 1;
}

CMD:giveobject(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 1338)
	{
		new string[1024], giveplayerid, object;
		if(sscanf(params, "ud", giveplayerid, object)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /giveobject [player] [object]");
		if(!IsPlayerConnected(giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified");
		
		SetPVarInt(playerid, "giveplayeridtoy", giveplayerid);
		SetPVarInt(playerid, "toyid", object);
		new icount = GetPlayerToySlots(giveplayerid);
		for(new x;x<icount;x++)
		{
		    new name[24];
		    format(name, sizeof(name), "None");

			for(new i;i<sizeof(HoldingObjectsAll);i++)
			{
				if(HoldingObjectsAll[i][holdingmodelid] == PlayerToyInfo[giveplayerid][x][ptModelID])
		        {
          			format(name, sizeof(name), "%s", HoldingObjectsAll[i][holdingmodelname]);
				}
			}
			if(PlayerToyInfo[giveplayerid][x][ptModelID] != 0 && (strcmp(name, "None", true) == 0))
			{
			    format(name, sizeof(name), "ID: %d", PlayerToyInfo[giveplayerid][x][ptModelID]);
			}
			format(string, sizeof(string), "%s(%d) %s (Bone: %s)\n", string, x, name, HoldingBones[PlayerToyInfo[giveplayerid][x][ptBone]]);
		}
   		ShowPlayerDialog(playerid, GIVETOY, DIALOG_STYLE_LIST, "Select a slot", string, "Select", "Cancel");
	}
	else {
		return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not authorized to use this command!");
	}	
	return 1;	
}		

CMD:shopobject(playerid, params[])
{
	if(PlayerInfo[playerid][pShopTech] >= 1)
	{
		ShowPlayerDialog(playerid, SHOPOBJECT_ORDERID, DIALOG_STYLE_INPUT, "Shop Objects - Order ID", "Please enter the Order ID", "OK", "Cancel");
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
		return 1;
	}
	return 1;
}

CMD:buytoys(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 4, 2787.095947, 2390.353027, 1240.531127) || IsPlayerInRangeOfPoint(playerid, 4, 1774.7533, 1422.6665, 2013.4979) || IsPlayerInRangeOfPoint(playerid, 4, 775.0900, 1742.4900, 1938.3800))
	{
		if(PlayerInfo[playerid][pDonateRank] < 3)
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "* You are not a Gold or Platinum VIP!");
		}
		else
		{
			ShowPlayerDialog( playerid, BUYTOYSGOLD, DIALOG_STYLE_MSGBOX, "Toy Store", "Welcome to the VIP toy store! Here you can buy accessories to attach to your player.\n\nFirst, we will choose a slot to store the toy in.","Continue", "Cancel" );
		}
	}
	else
	{
		new biz = InBusiness(playerid);
	   	if (biz == INVALID_BUSINESS_ID || Businesses[biz][bType] != BUSINESS_TYPE_CLOTHING) {
	        SendClientMessageEx(playerid, COLOR_GRAD2, "   You are not in a clothing shop!");
	        return 1;
	    }
		if (Businesses[biz][bInventory] < 1) {
	    	SendClientMessageEx(playerid, COLOR_GRAD2, "   Store does not have any clothes!");
		    return 1;
		}
		if (!Businesses[biz][bStatus]) {
		    SendClientMessageEx(playerid, COLOR_GRAD2, "   This clothing store is closed!");
		    return 1;
		}
		ShowPlayerDialog( playerid, BUYTOYS, DIALOG_STYLE_MSGBOX, "Toy Store", "Welcome to the toy store! Here you can buy accessories to attach to your player.\n\nFirst, we will choose a slot to store the toy in.","Continue", "Cancel" );
	}
	return 1;
}

CMD:toyhelp(playerid, params[])
{
	SendClientMessageEx(playerid, COLOR_GREEN,"_______________________________________");
	SendClientMessageEx(playerid, COLOR_WHITE,"*** TOY HELP ***");
	SendClientMessageEx(playerid, COLOR_GRAD3,"To buy a toy, go to any clothing store and type {AA3333}/buytoys");
	SendClientMessageEx(playerid, COLOR_GRAD3,"To attach/dettach, edit, or delete a toy type {AA3333}/toys");
	SendClientMessageEx(playerid, COLOR_GRAD3,"To quickly attach all your toys, type {AA3333}/wat");
	SendClientMessageEx(playerid, COLOR_GRAD3,"To quickly detach all your toys, type {AA3333}/dat");
	SendClientMessageEx(playerid, COLOR_GRAD3,"To quickly attach a specfic toy slot, type {AA3333}/wt [toyslot]");
	SendClientMessageEx(playerid, COLOR_GRAD3,"To quickly detach a specfic toy slot, type {AA3333}/dt [toyslot]");
	return 1;
}

CMD:toys(playerid, params[])
{
	if(GetPVarInt(playerid, "EventToken" ) == 1) return SendClientMessageEx(playerid, COLOR_GRAD2, "You cannot use this command while in an event.");
	ShowPlayerDialog( playerid, TOYS, DIALOG_STYLE_LIST, "Toy Menu", "Attach/Dettach a Toy\nEdit a Toy\nDelete a Toy","Select", "Cancel" );
	return 1;
}

CMD:wt(playerid, params[])
{
	new toyslot;
	if(sscanf(params, "d", toyslot)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /wt [toyslot]");

	if(toyslot < 1 || toyslot > MAX_PLAYERTOYS+1) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /wt [toyslot]");
	if(GetPVarInt(playerid, "EventToken" ) == 1) return SendClientMessageEx(playerid, COLOR_GRAD2, "You cannot use this command while in an event.");

	for(new i; i < 10; i++)
	{
		if(PlayerHoldingObject[playerid][i] == toyslot)
		{
			if(IsPlayerAttachedObjectSlotUsed(playerid, i))
			{
				return 1;
			}
		}
	}
	// Toy Slot is -1 since players see their toys list starting off from 1
	if(PlayerToyInfo[playerid][toyslot-1][ptScaleX] == 0) {
		PlayerToyInfo[playerid][toyslot-1][ptScaleX] = 1.0;
		PlayerToyInfo[playerid][toyslot-1][ptScaleY] = 1.0;
		PlayerToyInfo[playerid][toyslot-1][ptScaleZ] = 1.0;
	}

	if(PlayerToyInfo[playerid][toyslot-1][ptModelID] != 0 && PlayerToyInfo[playerid][toyslot-1][ptSpecial] != 2)
	{
		new toycount = GetFreeToySlot(playerid);
		if(PlayerInfo[playerid][pBEquipped] && toycount == 9) return SendClientMessageEx(playerid, COLOR_GRAD2, "You cannot use attach this toy since you have your backpack equipped.");
		PlayerHoldingObject[playerid][toycount] = toyslot;
		SetPlayerAttachedObject(playerid, toycount,
			PlayerToyInfo[playerid][toyslot-1][ptModelID],
			PlayerToyInfo[playerid][toyslot-1][ptBone],
			PlayerToyInfo[playerid][toyslot-1][ptPosX],
			PlayerToyInfo[playerid][toyslot-1][ptPosY],
			PlayerToyInfo[playerid][toyslot-1][ptPosZ],
			PlayerToyInfo[playerid][toyslot-1][ptRotX],
			PlayerToyInfo[playerid][toyslot-1][ptRotY],
			PlayerToyInfo[playerid][toyslot-1][ptRotZ],
			PlayerToyInfo[playerid][toyslot-1][ptScaleX],
			PlayerToyInfo[playerid][toyslot-1][ptScaleY],
			PlayerToyInfo[playerid][toyslot-1][ptScaleZ]
		);
	}
	return 1;
}

CMD:dt(playerid, params[])
{
	new toyslot;
	if(sscanf(params, "d", toyslot)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /dt [toyslot]");

	if(toyslot < 1 || toyslot > MAX_PLAYERTOYS) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /dt [toyslot]");


	for(new i; i < 10; i++)
	{
		if(PlayerHoldingObject[playerid][i] == toyslot)
		{
			if(IsPlayerAttachedObjectSlotUsed(playerid, i))
			{
				if(i == 9 && PlayerInfo[playerid][pBEquipped] || PlayerToyInfo[playerid][toyslot-1][ptSpecial] == 2) 
					break;
				RemovePlayerAttachedObject(playerid, i);
				PlayerHoldingObject[playerid][i] = 0;
				break;
			}
		}	
	}
	return 1;
}

CMD:wat(playerid, params[])
{
	if(GetPVarInt(playerid, "EventToken" ) == 1) return SendClientMessageEx(playerid, COLOR_GRAD2, "You cannot use this command while in an event.");
	new count = 0;
	SendClientMessageEx(playerid, COLOR_WHITE, "* Attached max toys allowed.");
	for(new x;x<MAX_PLAYERTOYS;x++)
	{
		if(PlayerToyInfo[playerid][x][ptScaleX] == 0) {
			PlayerToyInfo[playerid][x][ptScaleX] = 1.0;
			PlayerToyInfo[playerid][x][ptScaleY] = 1.0;
			PlayerToyInfo[playerid][x][ptScaleZ] = 1.0;
		}
		if(PlayerToyInfo[playerid][x][ptModelID] != 0 && PlayerToyInfo[playerid][x][ptSpecial] != 2) 
		{
			if(x == 9 && PlayerInfo[playerid][pBEquipped]) 
				break;
			SetPlayerAttachedObject(playerid, x, PlayerToyInfo[playerid][x][ptModelID], PlayerToyInfo[playerid][x][ptBone], PlayerToyInfo[playerid][x][ptPosX], PlayerToyInfo[playerid][x][ptPosY], PlayerToyInfo[playerid][x][ptPosZ], PlayerToyInfo[playerid][x][ptRotX], PlayerToyInfo[playerid][x][ptRotY], PlayerToyInfo[playerid][x][ptRotZ], PlayerToyInfo[playerid][x][ptScaleX], PlayerToyInfo[playerid][x][ptScaleY], PlayerToyInfo[playerid][x][ptScaleZ]),
			PlayerHoldingObject[playerid][count] = x;
			count++;
		}
		if(count == 10)
			break;
	}
	return 1;
}

CMD:dat(playerid, params[])
{
	SendClientMessageEx(playerid, COLOR_WHITE, "* Deattached all toys.");
	for(new i; i < 10; i++)
	{
		if(IsPlayerAttachedObjectSlotUsed(playerid, i) && PlayerToyInfo[playerid][PlayerHoldingObject[playerid][i]][ptSpecial] != 2) 
		{
			if(i == 9 && PlayerInfo[playerid][pBEquipped]) 
				break;
			PlayerHoldingObject[playerid][i] = 0;
			RemovePlayerAttachedObject(playerid, i);
		}
	}
    return 1;
}

CMD:selltoy(playerid, params[])
{
	new string[1000], name[24], targetid, cost;
	if(GetPVarInt(playerid, "ttBuyer") != INVALID_PLAYER_ID) return SendClientMessageEx(playerid, COLOR_GREY, "You're already trading with someone else.");
	if(GetPVarInt(playerid, "IsInArena") >= 0) return SendClientMessageEx(playerid,COLOR_GREY,"You cannot do this while being in an arena!");
   	if(GetPVarInt( playerid, "EventToken") != 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use this while you're in an event.");
	if(PlayerCuffed[playerid] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use this while being cuffed.");
    if(WatchingTV[playerid] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can not do this while watching TV!");
    if(PlayerInfo[playerid][pJailTime] > 0) return SendClientMessageEx(playerid,COLOR_GREY,"You can not do this while in jail or prison!");
    if(IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot do this right now.");
	if(sscanf(params, "ud", targetid, cost)) return SendClientMessageEx(playerid, COLOR_GRAD1, "USAGE: /selltoy [playerid] [price]");
	if(!IsPlayerConnected(targetid)) return SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");
	if(targetid == playerid) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot use this command on yourself.");
	if(!ProxDetectorS(5.0, playerid, targetid)) return SendClientMessageEx(playerid, COLOR_GREY, "This player is not near you.");
	if(InsideTradeToys[targetid] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "This person is currently trading at the moment, please try again later.");
	if(cost < 1 || cost > 1000000000) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot sell a toy for less than $1.");
	SetPVarInt(targetid, "ttSeller", playerid);
	SetPVarInt(playerid, "ttBuyer", targetid);
	SetPVarInt(playerid, "ttCost", cost);
	
	new icount = GetPlayerToySlots(playerid);
	for(new x;x<icount;x++)
	{
		format(name, sizeof(name), "None");
		for(new i;i<sizeof(HoldingObjectsAll);i++)
		{
			if(HoldingObjectsAll[i][holdingmodelid] == PlayerToyInfo[playerid][x][ptModelID])
			{
				format(name, sizeof(name), "%s", HoldingObjectsAll[i][holdingmodelname]);
			}
		}
		if(PlayerToyInfo[playerid][x][ptModelID] != 0 && (strcmp(name, "None", true) == 0))
		{
			format(name, sizeof(name), "ID: %d", PlayerToyInfo[playerid][x][ptModelID]);
		}
		format(string, sizeof(string), "%s(%d) %s\n", string, x+1, name);
	}	
	ShowPlayerDialog(playerid, SELLTOY, DIALOG_STYLE_LIST, "Select a toy to sell", string, "Sell", "Cancel"); // x+1 since toys list starts off from 1 (From players view)
	return 1;
}	
