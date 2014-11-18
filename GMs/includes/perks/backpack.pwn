/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Backpack System

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

stock IsBackpackAvailable(playerid)
{
	#if defined zombiemode
		if(zombieevent == 1 && GetPVarType(playerid, "pIsZombie")) 
			return 0;
	#endif
	if(GetPVarType(playerid, "PlayerCuffed") || GetPVarType(playerid, "Injured") || GetPVarType(playerid, "IsFrozen") || GetPVarInt(playerid, "EMSAttempt") != 0 || HungerPlayerInfo[playerid][hgInEvent] != 0 || PlayerInfo[playerid][pHospital] > 0 || PlayerInfo[playerid][pAccountRestricted] != 0) 
		return 0;
	if(GetPVarInt(playerid, "IsInArena") >= 0 || GetPVarInt( playerid, "EventToken") != 0 || IsPlayerInAnyVehicle(playerid) || GetPVarType(playerid, "AttemptingLockPick") || WatchingTV[playerid] != 0 || PlayerInfo[playerid][pJailTime] > 0 || !PlayerInfo[playerid][pBEquipped]) 
		return 0;
	
	return 1;
}

stock GetBackpackFreeSlotGun(playerid) {
	new slot;
	for(new g = 6; g < 10; g++)
	{
		
		if(PlayerInfo[playerid][pBItems][g] == 0)
		{
			slot = g;
			break;
		}
	}
	return slot;
}

ShowBackpackMenu(playerid, dialogid, extramsg[]) {
	new dgString[312],
		dgTitle[128],
		string[15];
	if(!IsBackpackAvailable(playerid)) {
		DeletePVar(playerid, "BackpackOpen"), DeletePVar(playerid, "BackpackProt"), SendClientMessageEx(playerid, COLOR_GREY, "You cannot use your backpack at this moment.");
		return 1;
	}
	if(!GetPVarType(playerid, "BackpackOpen") || !GetPVarType(playerid, "BackpackProt")) {
		DeletePVar(playerid, "BackpackOpen"), DeletePVar(playerid, "BackpackProt"), SendClientMessageEx(playerid, COLOR_GREY, "You cannot use your backpack at this moment.");
		return 1;
	}
		
	format(dgTitle, sizeof(dgTitle), "%s Items %s", GetBackpackName(PlayerInfo[playerid][pBackpack]), extramsg);
	switch(dialogid) {
		case DIALOG_OBACKPACK: {
			format(dgString, sizeof(dgString), "Food ({FFF94D}%d Meals{FFFFFF})\nNarcotics ({FFF94D}%d Grams{FFFFFF})\nGuns\nEnergy Bars ({FFF94D}%d Bars{FFFFFF})", PlayerInfo[playerid][pBItems][0], GetBackpackNarcoticsGrams(playerid), PlayerInfo[playerid][pBItems][11]);
			if(PlayerInfo[playerid][pBItems][5] != 0) format(dgString, sizeof(dgString), "%s\nMedic & Kevlar Vest Kits ({FFF94D}%d{FFFFFF})",dgString, PlayerInfo[playerid][pBItems][5]);
			ShowPlayerDialog(playerid, DIALOG_OBACKPACK, DIALOG_STYLE_LIST, dgTitle, dgString, "Select", "Cancel");
		}
		case DIALOG_BFOOD: {
			ShowPlayerDialog(playerid, DIALOG_BFOOD, DIALOG_STYLE_MSGBOX, dgTitle, "Are you sure you want to use this meal now?", "Confirm", "Cancel");
		}
		case DIALOG_BMEDKIT: {
			ShowPlayerDialog(playerid, DIALOG_BMEDKIT, DIALOG_STYLE_MSGBOX, dgTitle, "Are you sure you want to use this Medical & Kevlar Vest kit now?", "Confirm", "Cancel");
		}
		case DIALOG_BNARCOTICS: {
			format(dgString, sizeof(dgString), "Pot({FFF94D}%d{A9C4E4} Grams)\nCrack({FFF94D}%d{A9C4E4} Grams)\nHeroin({FFF94D}%d{A9C4E4} Grams)\nOpium({FFF94D}%d{A9C4E4} Grams)", PlayerInfo[playerid][pBItems][1], PlayerInfo[playerid][pBItems][2], PlayerInfo[playerid][pBItems][3], PlayerInfo[playerid][pBItems][4]);
			ShowPlayerDialog(playerid, DIALOG_BNARCOTICS, DIALOG_STYLE_LIST, dgTitle, dgString, "Select", "Cancel");
		}
		case DIALOG_BNARCOTICS2: {
			new pbi = GetPVarInt(playerid, "pbitemindex");
			switch(pbi) {
				case 1: format(dgTitle, sizeof(dgTitle), "{FFF94D}%d{A9C4E4} Grams of Pot({B20400}%d{A9C4E4} Total Grams)", PlayerInfo[playerid][pBItems][pbi], GetBackpackNarcoticsGrams(playerid));
				case 2: format(dgTitle, sizeof(dgTitle), "{FFF94D}%d{A9C4E4} Grams of Crack({B20400}%d{A9C4E4} Total Grams)", PlayerInfo[playerid][pBItems][pbi], GetBackpackNarcoticsGrams(playerid));
				case 3: format(dgTitle, sizeof(dgTitle), "{FFF94D}%d{A9C4E4} Grams of Heroin({B20400}%d{A9C4E4} Total Grams)", PlayerInfo[playerid][pBItems][pbi], GetBackpackNarcoticsGrams(playerid));
				case 4: format(dgTitle, sizeof(dgTitle), "{FFF94D}%d{A9C4E4} Grams of Raw Opium({B20400}%d{A9C4E4} Total Grams)", PlayerInfo[playerid][pBItems][pbi], GetBackpackNarcoticsGrams(playerid));
			}
			ShowPlayerDialog(playerid, DIALOG_BNARCOTICS2, DIALOG_STYLE_LIST, dgTitle, "Withdraw\nDeposit", "Select", "Cancel");
		}
		case DIALOG_BNARCOTICS3: {
			new pbi = GetPVarInt(playerid, "pbitemindex");
			switch(pbi) {
				case 1: format(dgTitle, sizeof(dgTitle), "{FFF94D}%d{A9C4E4} Grams of Pot({B20400}%d{A9C4E4} Total Grams)\n", PlayerInfo[playerid][pBItems][pbi], GetBackpackNarcoticsGrams(playerid));
				case 2: format(dgTitle, sizeof(dgTitle), "{FFF94D}%d{A9C4E4} Grams of Crack({B20400}%d{A9C4E4} Total Grams)\n", PlayerInfo[playerid][pBItems][pbi], GetBackpackNarcoticsGrams(playerid));
				case 3: format(dgTitle, sizeof(dgTitle), "{FFF94D}%d{A9C4E4} Grams of Heroin({B20400}%d{A9C4E4} Total Grams)\n", PlayerInfo[playerid][pBItems][pbi], GetBackpackNarcoticsGrams(playerid));
				case 4: format(dgTitle, sizeof(dgTitle), "{FFF94D}%d{A9C4E4} Grams of Raw Opium({B20400}%d{A9C4E4} Total Grams)\n", PlayerInfo[playerid][pBItems][pbi], GetBackpackNarcoticsGrams(playerid));
			}
			format(dgString, sizeof(dgString), "%s\nEnter the amount to %s                                                        ", extramsg, (GetPVarInt(playerid, "bnwd")) ? ("deposit") : ("withdraw"));
			ShowPlayerDialog(playerid, DIALOG_BNARCOTICS3, DIALOG_STYLE_INPUT, dgTitle, dgString, "Select", "Cancel");
		}
		
		case DIALOG_BGUNS: {
			new weapname[20], itemcount;
			for(new i = 6; i < 11; i++)
			{
				if(PlayerInfo[playerid][pBItems][i] > 0)
				{
					GetWeaponName(PlayerInfo[playerid][pBItems][i], weapname, sizeof(weapname));
					format(dgString, sizeof(dgString), "%s%s (%i)\n", dgString, weapname, i);
					format(string, sizeof(string), "ListItem%dSId", itemcount);
					SetPVarInt(playerid, string, i);
					itemcount++;
				}
			}
			SetPVarInt(playerid, "DepositGunId", itemcount);
			strcat(dgString, "Deposit a weapon");
			ShowPlayerDialog(playerid, DIALOG_BGUNS, DIALOG_STYLE_LIST, dgTitle, dgString, "Select", "Cancel");
		}
		case DIALOG_ENERGYBARS: {
			DeletePVar(playerid, "bnwd");
			ShowPlayerDialog(playerid, DIALOG_ENERGYBARS, DIALOG_STYLE_LIST, dgTitle, "Withdraw\nDeposit", "Select", "Cancel");
		}
		case DIALOG_ENERGYBARS*2: {
			format(dgTitle, sizeof(dgTitle), "{FFF94D}%d {02B0F5}Energy Bars%s", (GetPVarInt(playerid, "bnwd")) ? PlayerInfo[playerid][mInventory][4]:PlayerInfo[playerid][pBItems][11], (GetPVarInt(playerid, "bnwd")) ? (" on hand"):(""));
			format(dgString, sizeof(dgString), "%s\nEnter the amount to %s:", extramsg, (GetPVarInt(playerid, "bnwd")) ? ("deposit") : ("withdraw"));
			ShowPlayerDialog(playerid, DIALOG_ENERGYBARS, DIALOG_STYLE_INPUT, dgTitle, dgString, "Select", "Cancel");
		}
	}
	return 1;
}

stock GetBackpackName(backpackid) {
	new bpName[16];
	switch(backpackid) {
		case 1: bpName = "Small Backpack";
		case 2: bpName = "Medium Backpack";
		case 3: bpName = "Large Backpack";
	}
	return bpName;
}

stock GetBackpackNarcoticsGrams(playerid) {
	new grams;
	grams = PlayerInfo[playerid][pBItems][1];
	grams += PlayerInfo[playerid][pBItems][2];
	grams += PlayerInfo[playerid][pBItems][3];
	grams += PlayerInfo[playerid][pBItems][4];
	return grams;
}

stock CountBackpackGuns(playerid) {
	new count;
	for(new i = 6; i < 11); i++)
		if(PlayerInfo[playerid][pBItems][i] > 0)
			count++;
	return count;
}

CMD:shopbpack(playerid, params[]) {
	if(PlayerInfo[playerid][pShopTech] >= 1 || PlayerInfo[playerid][pAdmin] > 3) 
	{
		new playertogive, type, orderid;

		if(sscanf(params, "uii", playertogive, type, orderid)) {
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /shopbpack [player] [type] [orderid]");
			SendClientMessageEx(playerid, COLOR_WHITE, "Types: 1(Small Backpack), 2(Medium Backpack), 3(Large Backpack)");
		}
		else if(!(0 <= type <= 4)) {
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /shopbpack [player] [type] [orderid]");
			SendClientMessageEx(playerid, COLOR_WHITE, "Types: 1(Small Backpack), 2(Medium Backpack), 3(Large Backpack)");
		}
		else {

			new
				TypeName[7],
				szMessage[87];

			
			switch(type)
			{
				case 1: 
				{
					TypeName = "Small";
					SetPlayerAttachedObject(playertogive, 9, 371, 1, -0.002, -0.140999, -0.01, 8.69999, 88.8, -8.79993, 1.11, 0.963);
				}
				case 2: 
				{
					TypeName = "Medium";
					SetPlayerAttachedObject(playertogive, 9, 371, 1, -0.002, -0.140999, -0.01, 8.69999, 88.8, -8.79993, 1.11, 0.963);
				}
				case 3: 
				{
					TypeName = "Large";
					SetPlayerAttachedObject(playertogive, 9, 3026, 1, -0.254999, -0.109, -0.022999, 10.6, -1.20002, 3.4, 1.265, 1.242, 1.062);
				}
			}
			
			PlayerInfo[playertogive][pBackpack] = type;
			PlayerInfo[playertogive][pBEquipped] = 1;
			PlayerInfo[playertogive][pBStoredV] = INVALID_PLAYER_VEHICLE_ID;
			PlayerInfo[playertogive][pBStoredH] = INVALID_HOUSE_ID;
			format(szMessage, sizeof(szMessage), "You have successfully created a %s Backpack for %s (OrderID: %d).", TypeName, GetPlayerNameEx(playertogive), orderid);
			SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
			
			format(szMessage, sizeof(szMessage), "You now have a %s Backpack from %s (OrderID: %d).", TypeName, GetPlayerNameEx(playerid), orderid);
			SendClientMessageEx(playertogive, COLOR_WHITE, szMessage);
			
			SendClientMessageEx(playertogive, COLOR_GREY, "Use /backpackhelp to see the list of commands.");

			format(szMessage, sizeof(szMessage), "%s created a %s Backpack (%i) for %s(%d) (OrderID: %d).", GetPlayerNameEx(playerid), TypeName, type, GetPlayerNameEx(playertogive), GetPlayerSQLId(playertogive), orderid);
			Log("logs/shoplog.log", szMessage);
		}
	}
	else SendClientMessageEx(playerid, COLOR_GREY, " You are not allowed to use this command.");
    return 1;
}

CMD:sellbackpack(playerid, params[])
{
	if(PlayerInfo[playerid][pBackpack] > 0)
	{
		if(!PlayerInfo[playerid][pBEquipped]) return SendClientMessageEx(playerid, COLOR_GREY, "You are are not wearing your backpack, you can wear it with /bwear.");
		if(!IsBackpackAvailable(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot use your backpack at this moment.");
		if(GetPVarInt(playerid, "IsInArena") >= 0) return SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this right now, you are in an arena!");
		if(GetPVarInt( playerid, "EventToken") != 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use this while you're in an event.");
		if(IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this while being inside the vehicle!");
		if(GetPVarInt(playerid, "EMSAttempt") != 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can't use this command!");
		if(GetPVarInt(playerid, "sellingbackpack")) return SendClientMessageEx(playerid, COLOR_GRAD2, "You are already selling a backpack!");
		
		new string[128], giveplayerid, price, bptype[8];
		if(sscanf(params, "ui", giveplayerid, price)) {
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /sellbackpack [player] [price]");
			SendClientMessageEx(playerid, COLOR_YELLOW, "WARNING: /sellbackpack will automatically remove all your items currently in your backpack.");
			return 1;
		}
		if(price < 0) {
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /sellbackpack [player] [price]");
			SendClientMessageEx(playerid, COLOR_YELLOW, "WARNING: /sellbackpack will automatically remove all your items currently in your backpack.");
			return 1;
		}
		if(IsPlayerConnected(giveplayerid))
		{
			if(playerid == giveplayerid) return 1;
			if (ProxDetectorS(8.0, playerid, giveplayerid))
			{
				switch(PlayerInfo[playerid][pBackpack])
				{
					case 1: bptype = "Small";
					case 2: bptype = "Medium";
					case 3: bptype = "Large";
				}
				if(PlayerInfo[giveplayerid][pBackpack] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "That player already has a backpack!");
				SetPVarInt(giveplayerid, "sellbackpack", playerid);
				SetPVarInt(giveplayerid, "sellbackpackprice", price);
				SetPVarInt(playerid, "sellingbackpack", 1);
				format(string, sizeof(string), "* %s has offered you a %s Backpack for $%s. /accept backpack to get the backpack.", GetPlayerNameEx(playerid), bptype, number_format(price));
				SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
				format(string, sizeof(string), "* You have offered %s your %s Backpack for $%s.",GetPlayerNameEx(giveplayerid), bptype, number_format(price));
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
			}
			else
			{
				return SendClientMessageEx(playerid, COLOR_GREY, " That person is not near you!");
			}
		}
		else
		{
			return SendClientMessageEx(playerid, COLOR_GREY, " That person is not connected!");
		}
	}
	else return SendClientMessageEx(playerid, COLOR_GREY, "You do not own a backpack(Use /miscshop to get one with credits)");
	return 1;
}

CMD:listbitems(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] > 1 || PlayerInfo[playerid][pWatchdog] >= 2)
	{
		new string[128], giveplayerid;
		if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /listbitems [player]");

		if(IsPlayerConnected(giveplayerid))
		{
			if(PlayerInfo[giveplayerid][pBackpack] < 1) return SendClientMessageEx(playerid, COLOR_GREY, "That player does not have a backpack!");
			new btype[8], weaponname[50];
			switch(PlayerInfo[giveplayerid][pBackpack])
			{
				case 1: btype = "Small";
				case 2: btype = "Medium";
				case 3: btype = "Large";
			}
			SendClientMessageEx(playerid, COLOR_GREEN,"_______________________________________");
			format(string, sizeof(string), "*** %s' %s Backpack items...  ***", GetPlayerNameEx(giveplayerid), btype);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			if(PlayerInfo[giveplayerid][pBItems][0] > 0)
			{
				format(string, sizeof(string), "(Backpack) %d meals.", PlayerInfo[giveplayerid][pBItems][0]);
				SendClientMessageEx(playerid, COLOR_GREY, string);
			}
			
			if(PlayerInfo[giveplayerid][pBItems][1] > 0)
			{
				format(string, sizeof(string), "(Backpack) %d grams of pot.", PlayerInfo[giveplayerid][pBItems][1]);
				SendClientMessageEx(playerid, COLOR_GREY, string);
			}
			
			if(PlayerInfo[giveplayerid][pBItems][2] > 0)
			{
				format(string, sizeof(string), "(Backpack) %d grams of crack.", PlayerInfo[giveplayerid][pBItems][2]);
				SendClientMessageEx(playerid, COLOR_GREY, string);
			}
			
			if(PlayerInfo[giveplayerid][pBItems][3] > 0)
			{
				format(string, sizeof(string), "(Backpack) %d grams of heroin.", PlayerInfo[giveplayerid][pBItems][3]);
				SendClientMessageEx(playerid, COLOR_GREY, string);
			}
			
			if(PlayerInfo[giveplayerid][pBItems][4] > 0)
			{
				format(string, sizeof(string), "(Backpack) %d grams of raw opium.", PlayerInfo[giveplayerid][pBItems][4]);
				SendClientMessageEx(playerid, COLOR_GREY, string);
			}
			
			if(PlayerInfo[giveplayerid][pBItems][5] > 0)
			{
				format(string, sizeof(string), "(Backpack) %d Medical Kits.", PlayerInfo[giveplayerid][pBItems][5]);
				SendClientMessageEx(playerid, COLOR_GREY, string);
			}
			
			if(PlayerInfo[giveplayerid][pBItems][11] > 0)
			{
				format(string, sizeof(string), "(Backpack) %d Energy Bars.", PlayerInfo[giveplayerid][pBItems][11]);
				SendClientMessageEx(playerid, COLOR_GREY, string);
			}
			new sent;
			for (new i = 6; i < 11; i++)
			{
				if(PlayerInfo[giveplayerid][pBItems][i] > 0)
				{
					if(!sent) 
					{
						format(string, sizeof(string), "*** %s' %s Backpack weapons...  ***", GetPlayerNameEx(giveplayerid), btype);
						SendClientMessageEx(playerid, COLOR_WHITE, string);
						sent = 1;
					}
					GetWeaponName(PlayerInfo[giveplayerid][pBItems][i], weaponname, sizeof(weaponname));
					format(string, sizeof(string), "Weapon: %s.", weaponname);
					SendClientMessageEx(playerid, COLOR_GRAD1, string);
				}
			}
			SendClientMessageEx(playerid, COLOR_GREEN,"_______________________________________");
		}
		else SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid player specified.");
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	}
	return 1;
}

CMD:bsearch(playerid, params[])
{
	if(IsACop(playerid) || PlayerInfo[playerid][pJob] == 8 || PlayerInfo[playerid][pJob2] == 8 || PlayerInfo[playerid][pJob3] == 8)
	{
		new string[128], giveplayerid;
		if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /bsearch [player]");

		if(IsPlayerConnected(giveplayerid) && ProxDetectorS(8.0, playerid, giveplayerid))
		{
			if(giveplayerid == playerid) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot search yourself!");
			if(PlayerInfo[giveplayerid][pBEquipped] < 1) return SendClientMessageEx(playerid, COLOR_GREY, "That player is not wearing a backpack!");
			new btype[8], weaponname[50];
			switch(PlayerInfo[giveplayerid][pBackpack])
			{
				case 1: btype = "Small";
				case 2: btype = "Medium";
				case 3: btype = "Large";
			}
			SendClientMessageEx(playerid, COLOR_GREEN,"_______________________________________");
			format(string, sizeof(string), "*** %s' %s Backpack items...  ***", GetPlayerNameEx(giveplayerid), btype);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			if(PlayerInfo[giveplayerid][pBItems][0] > 0)
			{
				format(string, sizeof(string), "(Backpack) %d meals.", PlayerInfo[giveplayerid][pBItems][0]);
				SendClientMessageEx(playerid, COLOR_GREY, string);
			}
			
			if(PlayerInfo[giveplayerid][pBItems][1] > 0)
			{
				format(string, sizeof(string), "(Backpack) %d grams of pot.", PlayerInfo[giveplayerid][pBItems][1]);
				SendClientMessageEx(playerid, COLOR_GREY, string);
			}
			
			if(PlayerInfo[giveplayerid][pBItems][2] > 0)
			{
				format(string, sizeof(string), "(Backpack) %d grams of crack.", PlayerInfo[giveplayerid][pBItems][2]);
				SendClientMessageEx(playerid, COLOR_GREY, string);
			}
			
			if(PlayerInfo[giveplayerid][pBItems][3] > 0)
			{
				format(string, sizeof(string), "(Backpack) %d grams of heroin.", PlayerInfo[giveplayerid][pBItems][3]);
				SendClientMessageEx(playerid, COLOR_GREY, string);
			}
			
			if(PlayerInfo[giveplayerid][pBItems][4] > 0)
			{
				format(string, sizeof(string), "(Backpack) %d grams of raw opium.", PlayerInfo[giveplayerid][pBItems][4]);
				SendClientMessageEx(playerid, COLOR_GREY, string);
			}
			
			if(PlayerInfo[giveplayerid][pBItems][5] > 0)
			{
				format(string, sizeof(string), "(Backpack) %d Medical Kits.", PlayerInfo[giveplayerid][pBItems][5]);
				SendClientMessageEx(playerid, COLOR_GREY, string);
			}
			
			if(PlayerInfo[giveplayerid][pBItems][11] > 0)
			{
				format(string, sizeof(string), "(Backpack) %d Energy Bars.", PlayerInfo[giveplayerid][pBItems][11]);
				SendClientMessageEx(playerid, COLOR_GREY, string);
			}
			new sent;
			for (new i = 6; i < 11; i++)
			{
				if(PlayerInfo[giveplayerid][pBItems][i] > 0)
				{
					if(!sent) 
					{
						format(string, sizeof(string), "*** %s' %s Backpack weapons...  ***", GetPlayerNameEx(giveplayerid), btype);
						SendClientMessageEx(playerid, COLOR_WHITE, string);
						sent = 1;
					}
					GetWeaponName(PlayerInfo[giveplayerid][pBItems][i], weaponname, sizeof(weaponname));
					format(string, sizeof(string), "Weapon: %s.", weaponname);
					SendClientMessageEx(playerid, COLOR_GRAD1, string);
				}
			}
			SendClientMessageEx(playerid, COLOR_GREEN,"_______________________________________");
			format(string, sizeof(string), "* %s has searched %s's backpack for any illegal items.", GetPlayerNameEx(playerid),GetPlayerNameEx(giveplayerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		}
		else SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid player specified.");
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	}
	return 1;
}

CMD:bremove(playerid, params[])
{
    if (!IsACop(playerid))
	{
        SendClientMessageEx(playerid,COLOR_GREY,"You're not a law enforcement officer.");
        return 1;
    }
    new string[128], giveplayerid, item[6], bptype[8];
	if(sscanf(params, "us[6]", giveplayerid, item)) {
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /bremove [player] [item]");
		SendClientMessageEx(playerid, COLOR_YELLOW, "ITEMS: Pot, Crack, Heroin, Opium, Guns, Meals");
		return 1;
	}
	if(IsPlayerConnected(giveplayerid))
	{
		if(playerid == giveplayerid) return 1;
		if (ProxDetectorS(8.0, playerid, giveplayerid))
		{
			if(PlayerInfo[giveplayerid][pBEquipped] < 1 && PlayerInfo[giveplayerid][pBackpack] < 1) return SendClientMessageEx(playerid, COLOR_GREY, "That player is not wearing a backpack!");
			switch(PlayerInfo[playerid][pBackpack])
			{
				case 1: bptype = "Small";
				case 2: bptype = "Medium";
				case 3: bptype = "Large";
			}
			if(strcmp(item,"pot",true) == 0)
			{
				format(string, sizeof(string), "* You have taken away %s's pot from their backpack.", GetPlayerNameEx(giveplayerid));
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
				format(string, sizeof(string), "* Officer %s has taken away your pot from your backpack.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
				SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
				format(string, sizeof(string), "* Officer %s has taken away %s's pot from their backpack.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
				ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				PlayerInfo[giveplayerid][pBItems][1] = 0;
			}
			else if(strcmp(item,"crack",true) == 0)
			{
				format(string, sizeof(string), "* You have taken away %s's crack from their backpack.", GetPlayerNameEx(giveplayerid));
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
				format(string, sizeof(string), "* Officer %s has taken away your crack from your backpack.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
				SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
				format(string, sizeof(string), "* Officer %s has taken away %s's crack from their backpack.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
				ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				PlayerInfo[giveplayerid][pBItems][2] = 0;
			}
			else if(strcmp(item,"heroin",true) == 0)
			{
				format(string, sizeof(string), "* You have taken away %s's heroin from their backpack.", GetPlayerNameEx(giveplayerid));
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
				format(string, sizeof(string), "* Officer %s has taken away your heroin from your backpack.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
				SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
				format(string, sizeof(string), "* Officer %s has taken away %s's heroin from their backpack.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
				ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				PlayerInfo[giveplayerid][pBItems][3] = 0;
			}
			else if(strcmp(item,"opium",true) == 0)
			{
				format(string, sizeof(string), "* You have taken away %s's opium from their backpack.", GetPlayerNameEx(giveplayerid));
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
				format(string, sizeof(string), "* Officer %s has taken away your opium from your backpack.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
				SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
				format(string, sizeof(string), "* Officer %s has taken away %s's opium from their backpack.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
				ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				PlayerInfo[giveplayerid][pBItems][4] = 0;
			}
			else if(strcmp(item,"meals",true) == 0)
			{
				format(string, sizeof(string), "* You have taken away %s's meals from their backpack.", GetPlayerNameEx(giveplayerid));
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
				format(string, sizeof(string), "* Officer %s has taken away your meals from your backpack.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
				SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
				format(string, sizeof(string), "* Officer %s has taken away %s's meals from their backpack.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
				ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				PlayerInfo[giveplayerid][pBItems][0] = 0;
			}
			else if(strcmp(item,"guns",true) == 0)
			{
				format(string, sizeof(string), "* You have taken away %s's weapons from their backpack.", GetPlayerNameEx(giveplayerid));
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
				format(string, sizeof(string), "* Officer %s has taken away your weapons from your backpack.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
				SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
				format(string, sizeof(string), "* Officer %s has taken away %s's weapons from their backpack.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
				ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				for(new i = 6; i < 11; i++)
				{
					PlayerInfo[giveplayerid][pBItems][i] = 0;
				}
			}
		}
		else
		{
			return SendClientMessageEx(playerid, COLOR_GREY, " That person is not near you!");
		}
	}
	else
	{
		return SendClientMessageEx(playerid, COLOR_GREY, " That person is not connected!");
	}
    return 1;
}

CMD:bwear(playerid, params[])
{
	if(PlayerInfo[playerid][pBackpack] > 0)
	{
		if(!IsBackpackAvailable(playerid) && PlayerInfo[playerid][pBEquipped]) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot use your backpack at this moment.");
		if(GetPVarInt(playerid, "IsInArena") >= 0) return SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this right now, you are in an arena!");
		if(GetPVarInt( playerid, "EventToken") != 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use this while you're in an event.");
		if(IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this while being inside the vehicle!");
		if(GetPVarInt(playerid, "EMSAttempt") != 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can't use this command!");
		if(PlayerInfo[playerid][pBEquipped]) return SendClientMessageEx(playerid, COLOR_GREY, "You are already wearing your backpack, you can store it to your car/house with /bstore.");
		new string[128], btype[8], i = 0, Float: x, Float: y, Float: z, pvid = -1;
		if(PlayerInfo[playerid][pBStoredV] != INVALID_PLAYER_VEHICLE_ID)
		{
			for(i = 0 ; i < MAX_PLAYERVEHICLES; i++)
			{
				if(PlayerVehicleInfo[playerid][i][pvId] != INVALID_PLAYER_VEHICLE_ID && PlayerVehicleInfo[playerid][i][pvSlotId] == PlayerInfo[playerid][pBStoredV]) GetVehiclePos(PlayerVehicleInfo[playerid][i][pvId], x, y, z);
				if(IsPlayerInRangeOfPoint(playerid, 5.0, x, y, z)) 
				{
					pvid = i;
					break;
				}
			}
			if(pvid == -1) return SendClientMessageEx(playerid,COLOR_GREY,"You are not near the vehicle where the backpack is stored.");
			new engine,lights,alarm,doors,bonnet,boot,objective;
			GetVehicleParamsEx(PlayerVehicleInfo[playerid][pvid][pvId],engine,lights,alarm,doors,bonnet,boot,objective);
			if(boot == VEHICLE_PARAMS_OFF || boot == VEHICLE_PARAMS_UNSET) return SendClientMessageEx(playerid, COLOR_GRAD3, "You can't take/put stuff inside the trunk if it's closed!(/car trunk to open it)");
			if(PlayerHoldingObject[playerid][10] != 0 || IsPlayerAttachedObjectSlotUsed(playerid, 9)) 
				RemovePlayerAttachedObject(playerid, 9), PlayerHoldingObject[playerid][10] = 0;
			switch(PlayerInfo[playerid][pBackpack])
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
			format(string, sizeof(string), "You took your %s Backpack from your %s, use /bstore to store it.", btype, GetVehicleName(PlayerVehicleInfo[playerid][pvid][pvId]));
			SendClientMessageEx(playerid, COLOR_GREY, string);
			PlayerInfo[playerid][pBStoredV] = INVALID_PLAYER_VEHICLE_ID;
			PlayerInfo[playerid][pBEquipped] = 1;
			
			format(string, sizeof(string), "* %s has taken a backpack from their car trunk.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		}
		else if(PlayerInfo[playerid][pBStoredH] != INVALID_HOUSE_ID)
		{
			for(i = 0; i < MAX_HOUSES; i++)
			{
				if(HouseInfo[i][hSQLId] == PlayerInfo[playerid][pBStoredH]) 
				{
					pvid = i;
					break;
				}
			}
			if(IsPlayerInRangeOfPoint(playerid, 50, HouseInfo[pvid][hInteriorX], HouseInfo[pvid][hInteriorY], HouseInfo[pvid][hInteriorZ]) && GetPlayerVirtualWorld(playerid) == HouseInfo[pvid][hIntVW] && GetPlayerInterior(playerid) == HouseInfo[pvid][hIntIW])
			{
				if(PlayerHoldingObject[playerid][10] != 0 || IsPlayerAttachedObjectSlotUsed(playerid, 9)) 
					RemovePlayerAttachedObject(playerid, 9), PlayerHoldingObject[playerid][10] = 0;
				switch(PlayerInfo[playerid][pBackpack])
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
				format(string, sizeof(string), "You took your %s Backpack from your house, use /bstore to store it.", btype);
				SendClientMessageEx(playerid, COLOR_GREY, string);
				PlayerInfo[playerid][pBStoredH] = INVALID_HOUSE_ID;
				PlayerInfo[playerid][pBEquipped] = 1;
				
				format(string, sizeof(string), "* %s has taken a backpack from their house.", GetPlayerNameEx(playerid));
				ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				return 1;
			}
			else return SendClientMessageEx(playerid, COLOR_GREY, "You need to be inside the house you have stored your backpack!");
		}
	}
	else return SendClientMessageEx(playerid, COLOR_GREY, "You do not own a backpack(Use /miscshop to get one with credits)");
	return 1;
}

CMD:bstore(playerid, params[])
{
	if(PlayerInfo[playerid][pBackpack] > 0)
	{
		if(!PlayerInfo[playerid][pBEquipped]) return SendClientMessageEx(playerid, COLOR_GREY, "You are are not wearing your backpack, you can wear it with /bwear.");
		if(!IsBackpackAvailable(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot use your backpack at this moment.");
		if(GetPVarInt(playerid, "IsInArena") >= 0) return SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this right now, you are in an arena!");
		if(GetPVarInt(playerid, "EventToken") != 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use this while you're in an event.");
		if(IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this while being inside the vehicle!");
		if(GetPVarInt(playerid, "EMSAttempt") != 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can't use this command!");
		new Float: Health;
		GetPlayerHealth(playerid, Health);
		if(Health < 50.0) return SendClientMessageEx(playerid,COLOR_GREY,"You cannot store a backpack in a house/car when your health lower than 80.");
		
		new string[128], housecar[6];
		if(sscanf(params, "s[6]", housecar)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /bstore [house/car]");
		

		if(strcmp(housecar, "car", true, strlen(housecar)) == 0)
		{
			new pvid = -1, Float: x, Float: y, Float: z;

			for(new d = 0 ; d < MAX_PLAYERVEHICLES; d++)
			{
				if(PlayerVehicleInfo[playerid][d][pvId] != INVALID_PLAYER_VEHICLE_ID) GetVehiclePos(PlayerVehicleInfo[playerid][d][pvId], x, y, z);
				if(IsPlayerInRangeOfPoint(playerid, 5.0, x, y, z))
				{
					pvid = d;
					break;
				}
			}
			if(pvid == -1) return SendClientMessageEx(playerid,COLOR_GREY,"You are not near any vehicle that you own.");
			new engine,lights,alarm,doors,bonnet,boot,objective;
			GetVehicleParamsEx(PlayerVehicleInfo[playerid][pvid][pvId],engine,lights,alarm,doors,bonnet,boot,objective);
			if(boot == VEHICLE_PARAMS_OFF || boot == VEHICLE_PARAMS_UNSET) return SendClientMessageEx(playerid, COLOR_GRAD3, "You can't take/put stuff inside the trunk if it's closed!(/car trunk to open it)");
			if(GetVehicleModel(PlayerVehicleInfo[playerid][pvid][pvId]) == 481 || GetVehicleModel(PlayerVehicleInfo[playerid][pvid][pvId]) == 510)  return SendClientMessageEx(playerid,COLOR_GREY,"That vehicle doesn't have a trunk.");
			new btype[7];
			switch(PlayerInfo[playerid][pBackpack])
			{
				case 1: btype = "Small";
				case 2: btype = "Medium";
				case 3: btype = "Large";
			}
			format(string, sizeof(string), "You stored your %s Backpack in your %s, use /bwear to wear it.", btype, GetVehicleName(PlayerVehicleInfo[playerid][pvid][pvId]));
			SendClientMessageEx(playerid, COLOR_GREY, string);
			RemovePlayerAttachedObject(playerid, 9);
			PlayerInfo[playerid][pBEquipped] = 0;
			PlayerInfo[playerid][pBStoredV] = PlayerVehicleInfo[playerid][pvid][pvSlotId];
			format(string, sizeof(string), "* %s has stored a backpack in the trunk of their car.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			format(string, sizeof(string), "[TRUNK] %s(%d) (%s) stored their %s backpack in [SQLID:%d][SlotID:%d][ModelID:%d]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), btype, PlayerVehicleInfo[playerid][pvid][pvSlotId], pvid, PlayerVehicleInfo[playerid][pvid][pvModelId]);
			Log("logs/backpack.log", string);
		}
		else if(strcmp(housecar, "house", true, strlen(housecar)) == 0)
		{
			if(Homes[playerid] > 0)
			{
				new hid = -1;
				for(new i; i < MAX_HOUSES; i++)
				{
					if(GetPlayerSQLId(playerid) == HouseInfo[i][hOwnerID] && IsPlayerInRangeOfPoint(playerid, 50, HouseInfo[i][hInteriorX], HouseInfo[i][hInteriorY], HouseInfo[i][hInteriorZ]) && GetPlayerVirtualWorld(playerid) == HouseInfo[i][hIntVW] && GetPlayerInterior(playerid) == HouseInfo[i][hIntIW]) 
					{
						hid = i;
						break;
					}
				}
				if(hid == -1) return SendClientMessageEx(playerid, COLOR_GREY, "You're not in a house that you own.");
				new btype[7];
				switch(PlayerInfo[playerid][pBackpack])
				{
					case 1: btype = "Small";
					case 2: btype = "Medium";
					case 3: btype = "Large";
				}
				format(string, sizeof(string), "You stored your %s Backpack in your house, use /bwear to wear it.", btype);
				SendClientMessageEx(playerid, COLOR_GREY, string);
				RemovePlayerAttachedObject(playerid, 9);
				PlayerInfo[playerid][pBEquipped] = 0;
				PlayerInfo[playerid][pBStoredH] = HouseInfo[hid][hSQLId];
				format(string, sizeof(string), "* %s has stored a backpack in their house.", GetPlayerNameEx(playerid));
				ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				format(string, sizeof(string), "[HOUSE] %s(%d) (%s) stored his %s backpack in [HouseID:%d]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), btype, hid);
				Log("logs/backpack.log", string);
			}
			else return SendClientMessageEx(playerid, COLOR_GREY, "You don't own a house.");
		}
		else return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /bstore [house/car]");
	}
	else return SendClientMessageEx(playerid, COLOR_GREY, "You do not own a backpack(Use /miscshop to get one with credits)");
	return 1;
}


CMD:bopen(playerid, params[])
{
	if(PlayerInfo[playerid][pBackpack] > 0)
	{
		if(!IsBackpackAvailable(playerid)) {
			SendClientMessageEx(playerid, COLOR_GREY, "You cannot use your backpack at this moment.");
			return 1;
		}
		new string[122];
		ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0, 1);
		format(string, sizeof(string), "{FF8000}** {C2A2DA}%s lays down and opens a backpack.", GetPlayerNameEx(playerid));
		ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		SetPVarInt(playerid, "BackpackProt", 1);
		SetPVarInt(playerid, "BackpackOpen", 1);
		
		ShowBackpackMenu(playerid, DIALOG_OBACKPACK, "");
	}
	return 1;
}

CMD:backpackhelp(playerid, params[])
{
	new bdialog[565];
	format(bdialog, sizeof(bdialog), "Item: Small Backpack\nFood Storage: 1 Meals\nNarcotics Storage: 40 Grams\nFirearms Storage: 2 Weapons(Handguns only)\nCost: {FFD700}%s{A9C4E4}\n\n", number_format(ShopItems[36][sItemPrice]));
	format(bdialog, sizeof(bdialog), "%sItem: Medium Backpack\nFood Storage: 4 Meals\nNarcotics Storage: 100 Grams\nFirearms Storage: 3 Weapons(2 Handguns & 1 Primary)\nCost: {FFD700}%s{A9C4E4}\n\n", bdialog, number_format(ShopItems[37][sItemPrice]));
	format(bdialog, sizeof(bdialog), "%sItem: Large Backpack\nFood Storage: 5 Meals\nNarcotics Storage: 250 Grams\nFirearms Storage: 5 Weapons(2 Handguns & 3 Primary)\nCost: {FFD700}%s{A9C4E4}\n\n\n", bdialog, number_format(ShopItems[38][sItemPrice]));
	format(bdialog, sizeof(bdialog), "%sCommands available: /bstore /bwear /bopen /sellbackpack /drop backpack (/miscshop to buy one with credits)", bdialog);
	
	ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Backpack Information", bdialog, "Exit", "");
    return 1;
}
