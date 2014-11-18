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
	for(new i = 0; i < MAX_PLAYERTOYS; i++) if(PlayerToyInfo[playerid][i][ptSpecial] == 1) ++toys;
	return toys;
}	

GetFreeToySlot(playerid)
{
	for(new i = 0; i < 11; i++) {
		if(i + 1 < 11) {
			if(PlayerHoldingObject[playerid][i+1] == 0) {
				return i+1;
			}
		}
		else {
			return -1;
		}
	}
	return -1;
}

GetPlayerToySlots(playerid)
{
	new special =  GetSpecialPlayerToyCount(playerid);
	return PlayerInfo[playerid][pToySlot] + 10 + special;
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
				format(stringg, sizeof(stringg), "%s(%d) %s (Bone: %s)\n", stringg, x, name, HoldingBones[PlayerToyInfo[giveplayerid][x][ptBone]]);
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

	if(toyslot < 1 || toyslot > 11 + PlayerInfo[playerid][pToySlot]) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /wt [toyslot]");
	if(GetPVarInt(playerid, "EventToken" ) == 1) return SendClientMessageEx(playerid, COLOR_GRAD2, "You cannot use this command while in an event.");

	for(new i; i < 11; i++)
	{
		if(PlayerHoldingObject[playerid][i] == toyslot)
		{
			if(IsPlayerAttachedObjectSlotUsed(playerid, i-1))
			{
				return 1;
			}
		}
	}
	
	if(PlayerToyInfo[playerid][toyslot-1][ptScaleX] == 0) {
		PlayerToyInfo[playerid][toyslot-1][ptScaleX] = 1.0;
		PlayerToyInfo[playerid][toyslot-1][ptScaleY] = 1.0;
		PlayerToyInfo[playerid][toyslot-1][ptScaleZ] = 1.0;
	}

	if(PlayerToyInfo[playerid][toyslot-1][ptModelID] != 0)
	{
		new toycount = GetFreeToySlot(playerid);
		if(PlayerInfo[playerid][pBEquipped] && toycount == 10) return SendClientMessageEx(playerid, COLOR_GRAD2, "You cannot use attach this toy since you have your backpack equipped.");
		PlayerHoldingObject[playerid][toycount] = toyslot;
		SetPlayerAttachedObject(playerid, toycount-1,
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

	if(toyslot < 1 || toyslot > 11 + PlayerInfo[playerid][pToySlot]) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /dt [toyslot]");


	for(new i; i < 11; i++)
	{
		if(PlayerHoldingObject[playerid][i] == toyslot)
		{
			if(IsPlayerAttachedObjectSlotUsed(playerid, i-1))
			{
				if(i == 10 && PlayerInfo[playerid][pBEquipped]) 
					break;
				RemovePlayerAttachedObject(playerid, i-1);
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
	SendClientMessageEx(playerid, COLOR_WHITE, "* Attached all toys below slot 10.");
	for(new x;x<MAX_PLAYERTOYS;x++)
	{
		count++;
		if(PlayerToyInfo[playerid][x][ptScaleX] == 0) {
			PlayerToyInfo[playerid][x][ptScaleX] = 1.0;
			PlayerToyInfo[playerid][x][ptScaleY] = 1.0;
			PlayerToyInfo[playerid][x][ptScaleZ] = 1.0;
		}
		if(PlayerToyInfo[playerid][x][ptModelID] != 0) 
		{
			if(x == 9 && PlayerInfo[playerid][pBEquipped]) 
				break;
			SetPlayerAttachedObject(playerid, x, PlayerToyInfo[playerid][x][ptModelID], PlayerToyInfo[playerid][x][ptBone], PlayerToyInfo[playerid][x][ptPosX], PlayerToyInfo[playerid][x][ptPosY], PlayerToyInfo[playerid][x][ptPosZ], PlayerToyInfo[playerid][x][ptRotX], PlayerToyInfo[playerid][x][ptRotY], PlayerToyInfo[playerid][x][ptRotZ], PlayerToyInfo[playerid][x][ptScaleX], PlayerToyInfo[playerid][x][ptScaleY], PlayerToyInfo[playerid][x][ptScaleZ]),
			PlayerHoldingObject[playerid][x+1] = x+1;
		}
		if(count == 10)
			break;
	}
	return 1;
}

CMD:dat(playerid, params[])
{
	SendClientMessageEx(playerid, COLOR_WHITE, "* Deattached all toys.");
	for(new x;x<MAX_PLAYERTOYS;x++) {
		if(IsPlayerAttachedObjectSlotUsed(playerid, x)) 
		{
			if(x == 9 && PlayerInfo[playerid][pBEquipped]) 
				break;
			RemovePlayerAttachedObject(playerid, x);
		}
	}
	for(new i; i < 11; i++)
	{
		PlayerHoldingObject[playerid][i] = 0;
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
		format(string, sizeof(string), "%s(%d) %s\n", string, x, name);
	}	
	ShowPlayerDialog(playerid, SELLTOY, DIALOG_STYLE_LIST, "Select a toy to sell", string, "Sell", "Cancel");
	return 1;
}	
