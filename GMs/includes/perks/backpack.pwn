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

#include <YSI\y_hooks>

stock IsBackpackAvailable(playerid)
{
	#if defined zombiemode
		if(zombieevent == 1 && GetPVarType(playerid, "pIsZombie"))
			return 0;
	#endif
	if(GetPVarType(playerid, "PlayerCuffed") || GetPVarType(playerid, "Injured") || GetPVarType(playerid, "IsFrozen") || GetPVarInt(playerid, "EMSAttempt") != 0 || HungerPlayerInfo[playerid][hgInEvent] != 0 || PlayerInfo[playerid][pHospital] > 0 || PlayerInfo[playerid][pAccountRestricted] != 0)
		return 0;
	if(GetPVarType(playerid, "IsInArena") || GetPVarInt( playerid, "EventToken") != 0 || IsPlayerInAnyVehicle(playerid) || GetPVarType(playerid, "AttemptingLockPick") || GetPVarInt(playerid, "WatchingTV") || PlayerInfo[playerid][pJailTime] > 0 || !PlayerInfo[playerid][pBEquipped])
		return 0;

	return 1;
}

stock GetBackpackFreeSlotGun(playerid) {
	new slot;
	for(new g = 6; g < 11; g++)
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
	new dgTitle[128],
		string[15];

	szMiscArray[0] = 0;
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
			format(szMiscArray, sizeof(szMiscArray), "Food ({FFF94D}%d Meals{FFFFFF})\nNarcotics ({FFF94D}%d Grams{FFFFFF})\nGuns\nEnergy Bars ({FFF94D}%d Bars{FFFFFF})", PlayerInfo[playerid][pBItems][0], GetBackpackNarcoticsGrams(playerid), PlayerInfo[playerid][pBItems][11]);
			if(PlayerInfo[playerid][pBItems][5] != 0 && (IsACop(playerid) || IsAMedic(playerid) || IsAGovernment(playerid) || IsATowman(playerid))) format(szMiscArray, sizeof(szMiscArray), "%s\nMedic & Kevlar Vest Kits ({FFF94D}%d{FFFFFF})",szMiscArray, PlayerInfo[playerid][pBItems][5]);
			ShowPlayerDialogEx(playerid, DIALOG_OBACKPACK, DIALOG_STYLE_LIST, dgTitle, szMiscArray, "Select", "Cancel");
		}
		case DIALOG_BFOOD: {
			ShowPlayerDialogEx(playerid, DIALOG_BFOOD, DIALOG_STYLE_MSGBOX, dgTitle, "Are you sure you want to use this meal now?", "Confirm", "Cancel");
		}
		case DIALOG_BMEDKIT: {
			ShowPlayerDialogEx(playerid, DIALOG_BMEDKIT, DIALOG_STYLE_MSGBOX, dgTitle, "Are you sure you want to use this Medical & Kevlar Vest kit now?", "Confirm", "Cancel");
		}
		case DIALOG_BNARCOTICS: {

			for(new i; i < sizeof(Drugs); ++i) {

				format(szMiscArray, sizeof(szMiscArray), "%s%s({FFF94D}%d{A9C4E4} Grams)\n", szMiscArray, Drugs[i], PlayerInfo[playerid][pBDrugs][i]);
			}
			ShowPlayerDialogEx(playerid, DIALOG_BNARCOTICS, DIALOG_STYLE_LIST, dgTitle, szMiscArray, "Select", "Cancel");
		}
		case DIALOG_BNARCOTICS2: {
			new pbi = GetPVarInt(playerid, "pbitemindex");
			format(dgTitle, sizeof(dgTitle), "{FFF94D}%d{A9C4E4} Grams of %s ({B20400}%d{A9C4E4} Total Grams)", PlayerInfo[playerid][pBDrugs][pbi], Drugs[pbi], GetBackpackNarcoticsGrams(playerid));
			ShowPlayerDialogEx(playerid, DIALOG_BNARCOTICS2, DIALOG_STYLE_LIST, dgTitle, "Withdraw\nDeposit", "Select", "Cancel");
		}
		case DIALOG_BNARCOTICS3: {
			new pbi = GetPVarInt(playerid, "pbitemindex");

			format(dgTitle, sizeof(dgTitle), "{FFF94D}%d{A9C4E4} Grams of %s({B20400}%d{A9C4E4} Total Grams)\n", PlayerInfo[playerid][pBDrugs][pbi], Drugs[pbi], GetBackpackNarcoticsGrams(playerid));
			format(szMiscArray, sizeof(szMiscArray), "%s\nEnter the amount to %s                                                        ", extramsg, (GetPVarInt(playerid, "bnwd")) ? ("deposit") : ("withdraw"));
			ShowPlayerDialogEx(playerid, DIALOG_BNARCOTICS3, DIALOG_STYLE_INPUT, dgTitle, szMiscArray, "Select", "Cancel");
		}

		case DIALOG_BGUNS: {
			new weapname[20], itemcount;
			for(new i = 6; i < 11; i++)
			{
				if(PlayerInfo[playerid][pBItems][i] > 0)
				{
					GetWeaponName(PlayerInfo[playerid][pBItems][i], weapname, sizeof(weapname));
					format(szMiscArray, sizeof(szMiscArray), "%s%s (%i)\n", szMiscArray, weapname, i);
					format(string, sizeof(string), "ListItem%dSId", itemcount);
					SetPVarInt(playerid, string, i);
					itemcount++;
				}
			}
			SetPVarInt(playerid, "DepositGunId", itemcount);
			strcat(szMiscArray, "Deposit a weapon");
			ShowPlayerDialogEx(playerid, DIALOG_BGUNS, DIALOG_STYLE_LIST, dgTitle, szMiscArray, "Select", "Cancel");
		}
		case DIALOG_ENERGYBARS: {
			DeletePVar(playerid, "bnwd");
			ShowPlayerDialogEx(playerid, DIALOG_ENERGYBARS, DIALOG_STYLE_LIST, dgTitle, "Withdraw\nDeposit", "Select", "Cancel");
		}
		case DIALOG_ENERGYBARS*2: {
			format(dgTitle, sizeof(dgTitle), "{FFF94D}%d {02B0F5}Energy Bars%s", (GetPVarInt(playerid, "bnwd")) ? PlayerInfo[playerid][mInventory][4]:PlayerInfo[playerid][pBItems][11], (GetPVarInt(playerid, "bnwd")) ? (" on hand"):(""));
			format(szMiscArray, sizeof(szMiscArray), "%s\nEnter the amount to %s:", extramsg, (GetPVarInt(playerid, "bnwd")) ? ("deposit") : ("withdraw"));
			ShowPlayerDialogEx(playerid, DIALOG_ENERGYBARS, DIALOG_STYLE_INPUT, dgTitle, szMiscArray, "Select", "Cancel");
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
	for(new i; i < sizeof(Drugs); ++i) grams += PlayerInfo[playerid][pBDrugs][i];
	return grams;
}

stock GetBackpackIngredientsGrams(playerid) {

	new grams;
	for(new i; i < sizeof(szIngredients); ++i) grams += PlayerInfo[playerid][pBIngredients][i];
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

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	switch(dialogid)
	{
		case DIALOG_OBACKPACK: {
			if(response) {
				if(!IsBackpackAvailable(playerid)) {
					DeletePVar(playerid, "BackpackOpen"), DeletePVar(playerid, "BackpackProt"), SendClientMessageEx(playerid, COLOR_GREY, "You cannot use your backpack at this moment.");
					return 1;
				}
				switch(listitem) {
					case 0: { // Food
						if(PlayerInfo[playerid][pBItems][0] > 0) {
							ShowBackpackMenu(playerid, DIALOG_BFOOD, "- {02B0F5}Confirm meal use");
						}
						else {
							ShowBackpackMenu(playerid, DIALOG_OBACKPACK, "- {A80000}You don't have any meals");
						}
					}
					case 1: { // Narcotics
						ShowBackpackMenu(playerid, DIALOG_BNARCOTICS, "- {02B0F5}Select a narcotic");
					}
					case 2: { // Guns
						if(PlayerInfo[playerid][pWRestricted] || PlayerInfo[playerid][pAccountRestricted]) return SendClientMessageEx(playerid, COLOR_GRAD2, "You cannot use this option while being restricted.");
						ShowBackpackMenu(playerid, DIALOG_BGUNS, "- {02B0F5}Select a weapon");
					}
					case 3: { // Energy Bars
						ShowBackpackMenu(playerid, DIALOG_ENERGYBARS, "- {02B0F5}Energy Bars");
					}
					case 4: { // Med Kits
						if(PlayerInfo[playerid][pBItems][5] > 0) {
							ShowBackpackMenu(playerid, DIALOG_BMEDKIT, "- {02B0F5}Confirm med kit use");
						}
						else {
							ShowBackpackMenu(playerid, DIALOG_OBACKPACK, "- {A80000}You don't have any med kits");
						}
					}
				}
			}
			else {
				DeletePVar(playerid, "BackpackProt");
				DeletePVar(playerid, "BackpackOpen");
			}
		}
		case DIALOG_BFOOD: {
			if(response) {
				if(!IsBackpackAvailable(playerid)) {
					DeletePVar(playerid, "BackpackOpen"), DeletePVar(playerid, "BackpackProt"), SendClientMessageEx(playerid, COLOR_GREY, "You cannot use your backpack at this moment.");
					return 1;
				}
				if(GetPVarInt(playerid, "BackpackMeal") == 1) {
					ShowBackpackMenu(playerid, DIALOG_OBACKPACK, "- {A80000}You're already using a meal.");
				}
				else
				{
					defer FinishMeal(playerid);
					SetPVarInt(playerid, "BackpackMeal", 1);
					ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0, 1);
					format(szMiscArray, sizeof(szMiscArray), "{FF8000}** {C2A2DA}%s opens a backpack and takes out a Full Meal.", GetPlayerNameEx(playerid));
					SendClientMessageEx(playerid, COLOR_WHITE, "You are taking the Meal from your backpack, please wait.");
					ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				}
			}
			else {
				ShowBackpackMenu(playerid, DIALOG_OBACKPACK, "");
			}
		}
		case DIALOG_BMEDKIT: {
			if(response && (IsACop(playerid) || IsAMedic(playerid) || IsAGovernment(playerid))) {
				if(!IsBackpackAvailable(playerid)) {
					DeletePVar(playerid, "BackpackOpen"), DeletePVar(playerid, "BackpackProt"), SendClientMessageEx(playerid, COLOR_GREY, "You cannot use your backpack at this moment.");
					return 1;
				}
				if(GetPVarInt(playerid, "BackpackMedKit") == 1) {
					ShowBackpackMenu(playerid, DIALOG_OBACKPACK, "- {A80000}You're already using a med kit.");
				}
				else
				{
					defer FinishMedKit(playerid);
					SetPVarInt(playerid, "BackpackMedKit", 1);
					ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0, 1);
					format(szMiscArray, sizeof(szMiscArray), "{FF8000}** {C2A2DA}%s opens a backpack and takes out a Kevlar Vest & First Aid Kit inside.", GetPlayerNameEx(playerid));
					SendClientMessageEx(playerid, COLOR_WHITE, "You are taking the Med Kit from your backpack, please wait.");
					ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				}
			}
			else {
				ShowBackpackMenu(playerid, DIALOG_OBACKPACK, "");
			}
		}
		case DIALOG_BNARCOTICS: {
			if(response) {
				if(!IsBackpackAvailable(playerid)) {
					DeletePVar(playerid, "BackpackOpen"), DeletePVar(playerid, "BackpackProt"), SendClientMessageEx(playerid, COLOR_GREY, "You cannot use your backpack at this moment.");
					return 1;
				}
				SetPVarInt(playerid, "pbitemindex", listitem);
				ShowBackpackMenu(playerid, DIALOG_BNARCOTICS2, "");
			}
			else {
				ShowBackpackMenu(playerid, DIALOG_OBACKPACK, "");
			}
		}
		case DIALOG_BNARCOTICS2: {
			if(response) {
				if(!IsBackpackAvailable(playerid)) {
					DeletePVar(playerid, "BackpackOpen"), DeletePVar(playerid, "BackpackProt"), SendClientMessageEx(playerid, COLOR_GREY, "You cannot use your backpack at this moment.");
					return 1;
				}
				SetPVarInt(playerid, "bnwd", listitem);
				ShowBackpackMenu(playerid, DIALOG_BNARCOTICS3, "");
			}
			else {
				ShowBackpackMenu(playerid, DIALOG_BNARCOTICS, "- {02B0F5}Select a narcotic");
			}
		}
		case DIALOG_BNARCOTICS3: {
			if(response) {
				if(!IsBackpackAvailable(playerid)) {
					DeletePVar(playerid, "BackpackOpen"), DeletePVar(playerid, "BackpackProt"), SendClientMessageEx(playerid, COLOR_GREY, "You cannot use your backpack at this moment.");
					return 1;
				}

				new pbi = GetPVarInt(playerid, "pbitemindex");
				if(GetPVarInt(playerid, "bnwd")) {
					new namount, maxgrams, dInfo[135];
					if(sscanf(inputtext, "d", namount)) return ShowBackpackMenu(playerid, DIALOG_BNARCOTICS3, "{B20400}Wrong input{A9C4E4}");
					if(namount < 1) return ShowBackpackMenu(playerid, DIALOG_BNARCOTICS3, "{B20400}Wrong input{A9C4E4}\nYou cannot put the amount less than 1");
					switch(PlayerInfo[playerid][pBackpack]) {
						case 1: maxgrams = 40;
						case 2: maxgrams = 100;
						case 3: maxgrams = 250;
					}
					if(namount > (maxgrams-GetBackpackNarcoticsGrams(playerid)))
					{
						format(dInfo, sizeof(dInfo), "{B20400}Wrong input, you can only store %d grams{A9C4E4}\nGrams available to store left {FFF600}%d{A9C4E4}\nEnter the amount to deposit", maxgrams, maxgrams-GetBackpackNarcoticsGrams(playerid));
						ShowBackpackMenu(playerid, DIALOG_BNARCOTICS3, dInfo);
						return 1;
					}

					if(PlayerInfo[playerid][pDrugs][pbi] >= namount) PlayerInfo[playerid][pDrugs][pbi] -= namount;
					else return ShowBackpackMenu(playerid, DIALOG_BNARCOTICS3, "{B20400}Wrong input{A9C4E4}\nYou don't have that that amount of grams.");

					PlayerInfo[playerid][pBDrugs][pbi] += namount;
					format(szMiscArray, sizeof(szMiscArray), "You have deposited %d grams of %s in your backpack.", namount, Drugs[pbi]);
					SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
					new ip[MAX_PLAYER_NAME];
					GetPlayerIp(playerid, ip, sizeof(ip));
					format(szMiscArray, sizeof(szMiscArray), "[DRUGS] %s(%d) (IP:%s) deposited %d grams of %s (%d grams Total) [BACKPACK %d]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ip, namount, Drugs[pbi], PlayerInfo[playerid][pDrugs][pbi], PlayerInfo[playerid][pBackpack]);
					Log("logs/backpack.log", szMiscArray);
					ShowBackpackMenu(playerid, DIALOG_BNARCOTICS, "- {02B0F5}Select a narcotic");
				}
				else {
					new namount, dInfo[135];
					if(sscanf(inputtext, "d", namount)) return ShowBackpackMenu(playerid, DIALOG_BNARCOTICS3, "{B20400}Wrong input{A9C4E4}");
					if(namount < 1) return ShowBackpackMenu(playerid, DIALOG_BNARCOTICS3, "{B20400}Wrong input{A9C4E4}\nYou cannot put the amount less than 1");
					if(namount > PlayerInfo[playerid][pBDrugs][pbi])
					{
						format(dInfo, sizeof(dInfo), "{B20400}Wrong input, you only have %d grams of %s{A9C4E4}\nGrams trying to withdraw {FFF600}%d{A9C4E4}\nEnter the amount to deposit", PlayerInfo[playerid][pBDrugs][pbi], Drugs[pbi], namount);
						ShowBackpackMenu(playerid, DIALOG_BNARCOTICS3, dInfo);
						return 1;
					}
					PlayerInfo[playerid][pBDrugs][pbi] -= namount;
					PlayerInfo[playerid][pDrugs][pbi] += namount;
					format(szMiscArray, sizeof(szMiscArray), "You have withdrawn %d grams of %s in your backpack.", namount, Drugs[pbi]);
					SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
					new ip[MAX_PLAYER_NAME];
					GetPlayerIp(playerid, ip, sizeof(ip));
					format(szMiscArray, sizeof(szMiscArray), "[DRUGS] %s(%d) (IP:%s) withdrawn %d grams of %s (%d grams Total) [BACKPACK %d]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ip, namount, Drugs[pbi], PlayerInfo[playerid][pBDrugs][pbi], PlayerInfo[playerid][pBackpack]);
					Log("logs/backpack.log", szMiscArray);
					ShowBackpackMenu(playerid, DIALOG_BNARCOTICS, "- {02B0F5}Select a narcotic");
				}
			}
			else {
				ShowBackpackMenu(playerid, DIALOG_BNARCOTICS2, "");
			}
		}
		case DIALOG_BGUNS: {
			if(response) {
				if(!IsBackpackAvailable(playerid)) {
					DeletePVar(playerid, "BackpackOpen"), DeletePVar(playerid, "BackpackProt"), SendClientMessageEx(playerid, COLOR_GREY, "You cannot use your backpack at this moment.");
					return 1;
				}
				new szDialog[130], weapname[20];
				if(listitem == GetPVarInt(playerid, "DepositGunId")) {
					switch(PlayerInfo[playerid][pBackpack]) {
						case 1: {
							new myweapons[2], itemcount;
							GetPlayerWeaponData(playerid, 1, myweapons[0], myweapons[1]);
							if(myweapons[0] > 0 && myweapons[0] != 9 && myweapons[0] != 4 && PlayerInfo[playerid][pGuns][1] == myweapons[0] && PlayerInfo[playerid][pAGuns][1] == 0)
							{
								GetWeaponName(myweapons[0], weapname, sizeof(weapname));
								format(szDialog, sizeof(szDialog), "%s%s (%d)\n", szDialog, weapname, myweapons[0]);
								format(szMiscArray, sizeof(szMiscArray), "ListItem%dWId", itemcount);
								SetPVarInt(playerid, szMiscArray, myweapons[0]);
								itemcount++;
							}
							GetPlayerWeaponData(playerid, 10, myweapons[0], myweapons[1]);
							if(myweapons[0] > 0 && PlayerInfo[playerid][pGuns][10] == myweapons[0] && PlayerInfo[playerid][pAGuns][10] == 0)
							{
								GetWeaponName(myweapons[0], weapname, sizeof(weapname));
								format(szDialog, sizeof(szDialog), "%s%s (%d)\n", szDialog, weapname, myweapons[0]);
								format(szMiscArray, sizeof(szMiscArray), "ListItem%dWId", itemcount);
								SetPVarInt(playerid, szMiscArray, myweapons[0]);
								itemcount++;
							}
							GetPlayerWeaponData(playerid, 2, myweapons[0], myweapons[1]);
							if(myweapons[0] > 0 && pTazer{playerid} == 0 && PlayerInfo[playerid][pGuns][2] == myweapons[0] && PlayerInfo[playerid][pAGuns][2] == 0)
							{
								GetWeaponName(myweapons[0], weapname, sizeof(weapname));
								format(szDialog, sizeof(szDialog), "%s%s (%d)\n", szDialog, weapname, myweapons[0]);
								format(szMiscArray, sizeof(szMiscArray), "ListItem%dWId", itemcount);
								SetPVarInt(playerid, szMiscArray, myweapons[0]);
								itemcount++;
							}
							if(strlen(szDialog) > 0) ShowPlayerDialogEx(playerid, DIALOG_BGUNS2, DIALOG_STYLE_LIST, "Select a weapon to deposit", szDialog, "Select", "Cancel");
							else {
								ShowBackpackMenu(playerid, DIALOG_BGUNS, "- {02B0F5}Select a weapon - No guns to store");
							}
						}
						case 2, 3: {
							new myweapons[2], itemcount;
							GetPlayerWeaponData(playerid, 1, myweapons[0], myweapons[1]);
							if(myweapons[0] > 0 && myweapons[0] != 9 && myweapons[0] != 4 && PlayerInfo[playerid][pGuns][1] == myweapons[0] && PlayerInfo[playerid][pAGuns][1] == 0)
							{
								GetWeaponName(myweapons[0], weapname, sizeof(weapname));
								format(szDialog, sizeof(szDialog), "%s%s (%d)\n", szDialog, weapname, myweapons[0]);
								format(szMiscArray, sizeof(szMiscArray), "ListItem%dWId", itemcount);
								SetPVarInt(playerid, szMiscArray, myweapons[0]);
								itemcount++;
							}
							GetPlayerWeaponData(playerid, 10, myweapons[0], myweapons[1]);
							if(myweapons[0] > 0 && PlayerInfo[playerid][pGuns][10] == myweapons[0] && PlayerInfo[playerid][pAGuns][10] == 0)
							{
								GetWeaponName(myweapons[0], weapname, sizeof(weapname));
								format(szDialog, sizeof(szDialog), "%s%s (%d)\n", szDialog, weapname, myweapons[0]);
								format(szMiscArray, sizeof(szMiscArray), "ListItem%dWId", itemcount);
								SetPVarInt(playerid, szMiscArray, myweapons[0]);
								itemcount++;
							}
							GetPlayerWeaponData(playerid, 2, myweapons[0], myweapons[1]);
							if(myweapons[0] > 0 && pTazer{playerid} == 0 && PlayerInfo[playerid][pGuns][2] == myweapons[0] && PlayerInfo[playerid][pAGuns][2] == 0)
							{
								GetWeaponName(myweapons[0], weapname, sizeof(weapname));
								format(szDialog, sizeof(szDialog), "%s%s (%d)\n", szDialog, weapname, myweapons[0]);
								format(szMiscArray, sizeof(szMiscArray), "ListItem%dWId", itemcount);
								SetPVarInt(playerid, szMiscArray, myweapons[0]);
								itemcount++;
							}
							GetPlayerWeaponData(playerid, 3, myweapons[0], myweapons[1]);
							if(myweapons[0] > 0 && PlayerInfo[playerid][pGuns][3] == myweapons[0] && PlayerInfo[playerid][pAGuns][3] == 0)
							{
								GetWeaponName(myweapons[0], weapname, sizeof(weapname));
								format(szDialog, sizeof(szDialog), "%s%s (%d)\n", szDialog, weapname, myweapons[0]);
								format(szMiscArray, sizeof(szMiscArray), "ListItem%dWId", itemcount);
								SetPVarInt(playerid, szMiscArray, myweapons[0]);
								itemcount++;
							}
							GetPlayerWeaponData(playerid, 4, myweapons[0], myweapons[1]);
							if(myweapons[0] > 0 && PlayerInfo[playerid][pGuns][4] == myweapons[0] && PlayerInfo[playerid][pAGuns][4] == 0)
							{
								GetWeaponName(myweapons[0], weapname, sizeof(weapname));
								format(szDialog, sizeof(szDialog), "%s%s (%d)\n", szDialog, weapname, myweapons[0]);
								format(szMiscArray, sizeof(szMiscArray), "ListItem%dWId", itemcount);
								SetPVarInt(playerid, szMiscArray, myweapons[0]);
								itemcount++;
							}
							GetPlayerWeaponData(playerid, 5, myweapons[0], myweapons[1]);
							if(myweapons[0] > 0 && PlayerInfo[playerid][pGuns][5] == myweapons[0] && PlayerInfo[playerid][pAGuns][5] == 0)
							{
								GetWeaponName(myweapons[0], weapname, sizeof(weapname));
								format(szDialog, sizeof(szDialog), "%s%s (%d)\n", szDialog, weapname, myweapons[0]);
								format(szMiscArray, sizeof(szMiscArray), "ListItem%dWId", itemcount);
								SetPVarInt(playerid, szMiscArray, myweapons[0]);
								itemcount++;
							}
							GetPlayerWeaponData(playerid, 6, myweapons[0], myweapons[1]);
							if(myweapons[0] > 0 && PlayerInfo[playerid][pGuns][6] == myweapons[0] && PlayerInfo[playerid][pAGuns][6] == 0)
							{
								GetWeaponName(myweapons[0], weapname, sizeof(weapname));
								format(szDialog, sizeof(szDialog), "%s%s (%d)\n", szDialog, weapname, myweapons[0]);
								format(szMiscArray, sizeof(szMiscArray), "ListItem%dWId", itemcount);
								SetPVarInt(playerid, szMiscArray, myweapons[0]);
								itemcount++;
							}
							if(strlen(szDialog) > 0) ShowPlayerDialogEx(playerid, DIALOG_BGUNS2, DIALOG_STYLE_LIST, "Select a weapon to deposit", szDialog, "Select", "Cancel");
							else {
								ShowBackpackMenu(playerid, DIALOG_BGUNS, "- {02B0F5}Select a weapon - No guns to store");
							}
						}
					}
				}
				else {

					format(szMiscArray, sizeof(szMiscArray), "ListItem%dSId", listitem);
					new slot = GetPVarInt(playerid, szMiscArray);
					if(PlayerInfo[playerid][pBItems][slot] > 0) {

						new aWeapons[13][2];

						for(new i; i < 13; ++i) {
							GetPlayerWeaponData(playerid, i, aWeapons[i][0], aWeapons[i][1]);
							if(aWeapons[i][0] == PlayerInfo[playerid][pBItems][slot]) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are already carrying this weapon.");
						}

						GetWeaponName(PlayerInfo[playerid][pBItems][slot], weapname, sizeof(weapname));
						GivePlayerValidWeapon(playerid, PlayerInfo[playerid][pBItems][slot]);

						DeletePVar(playerid, szMiscArray);

						format(szMiscArray, sizeof(szMiscArray), "You have withdrawn a %s from your backpack.", weapname);
						SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);

						format(szMiscArray, sizeof(szMiscArray), "* %s has withdrawn a %s from their backpack.", GetPlayerNameEx(playerid), weapname);
						ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
						new ip[MAX_PLAYER_NAME];
						GetPlayerIp(playerid, ip, sizeof(ip));
						format(szMiscArray, sizeof(szMiscArray), "[WEAPONS] %s(%d) (IP:%s) withdrawn a %s(%d) [BACKPACK %d]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ip, weapname, PlayerInfo[playerid][pBItems][slot], PlayerInfo[playerid][pBackpack]);
						Log("logs/backpack.log", szMiscArray);
						PlayerInfo[playerid][pBItems][slot] = 0;
						ShowBackpackMenu(playerid, DIALOG_BGUNS, "- {02B0F5}Select a weapon");
						return 1;
					}
				}
			}
			else {
				ShowBackpackMenu(playerid, DIALOG_OBACKPACK, "");
			}
		}
		case DIALOG_BGUNS2: {
			if(response) {
				if(!IsBackpackAvailable(playerid)) {
					DeletePVar(playerid, "BackpackOpen"), DeletePVar(playerid, "BackpackProt"), SendClientMessageEx(playerid, COLOR_GREY, "You cannot use your backpack at this moment.");
					return 1;
				}
				new handguns, primguns, wbid, slot = GetBackpackFreeSlotGun(playerid), weapname[32];
				for(new i = 6; i < 11; i++) {
					if(PlayerInfo[playerid][pBItems][i] > 0) {
						if(IsWeaponHandgun(PlayerInfo[playerid][pBItems][i])) handguns++;
						else if(IsWeaponPrimary(PlayerInfo[playerid][pBItems][i])) primguns++;
					}
				}
				switch(PlayerInfo[playerid][pBackpack]) {
					case 1: {
						format(szMiscArray, sizeof(szMiscArray), "ListItem%dWId", listitem);
						wbid = GetPVarInt(playerid, szMiscArray);
						if(handguns > 1 || primguns > 0 || IsWeaponPrimary(wbid)) {
							ShowBackpackMenu(playerid, DIALOG_BGUNS, "- {02B0F5}You can only carry 2 handguns");
							return 1;
						}
						if(slot != 0 && PlayerInfo[playerid][pGuns][GetWeaponSlot(wbid)] == wbid && PlayerInfo[playerid][pAGuns][GetWeaponSlot(wbid)] == 0) {
							RemovePlayerWeapon(playerid, wbid);
							PlayerInfo[playerid][pBItems][slot] = wbid;
							GetWeaponName(wbid, weapname, sizeof(weapname));
							format(szMiscArray, sizeof(szMiscArray), "You have deposited a %s inside your backpack.", weapname);
							SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);

							format(szMiscArray, sizeof(szMiscArray), "* %s has deposited a %s inside their backpack.", GetPlayerNameEx(playerid), weapname);
							ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
							new ip[MAX_PLAYER_NAME];
							GetPlayerIp(playerid, ip, sizeof(ip));
							format(szMiscArray, sizeof(szMiscArray), "[WEAPONS] %s(%d) (IP:%s) deposited a %s(%d) in slot %d [BACKPACK %d]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ip, weapname, wbid, slot, PlayerInfo[playerid][pBackpack]);
							Log("logs/backpack.log", szMiscArray);
							ShowBackpackMenu(playerid, DIALOG_BGUNS, "- {02B0F5}Select a weapon");
							return 1;
						}
						else {
							ShowBackpackMenu(playerid, DIALOG_BGUNS, "- {02B0F5}Select a weapon ERROR");
						}
					}
					case 2: {
						format(szMiscArray, sizeof(szMiscArray), "ListItem%dWId", listitem);
						wbid = GetPVarInt(playerid, szMiscArray);
						if((handguns >= 2 && IsWeaponHandgun(wbid)) || (IsWeaponPrimary(wbid) && primguns >= 1) || (handguns >= 2 && primguns >= 1)) {
							ShowBackpackMenu(playerid, DIALOG_BGUNS, "- {02B0F5}You can only carry 2 handguns and 1 primary");
							return 1;
						}
						if(slot != 0 && PlayerInfo[playerid][pGuns][GetWeaponSlot(wbid)] == wbid && PlayerInfo[playerid][pAGuns][GetWeaponSlot(wbid)] == 0) {
							RemovePlayerWeapon(playerid, wbid);
							PlayerInfo[playerid][pBItems][slot] = wbid;
							GetWeaponName(wbid, weapname, sizeof(weapname));
							format(szMiscArray, sizeof(szMiscArray), "You have deposited a %s inside your backpack.", weapname);
							SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);

							format(szMiscArray, sizeof(szMiscArray), "* %s has deposited a %s inside their backpack.", GetPlayerNameEx(playerid), weapname);
							ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
							new ip[MAX_PLAYER_NAME];
							GetPlayerIp(playerid, ip, sizeof(ip));
							format(szMiscArray, sizeof(szMiscArray), "[WEAPONS] %s(%d) (IP:%s) deposited a %s(%d) in slot %d [BACKPACK %d]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ip, weapname, wbid, slot, PlayerInfo[playerid][pBackpack]);
							Log("logs/backpack.log", szMiscArray);
							ShowBackpackMenu(playerid, DIALOG_BGUNS, "- {02B0F5}Select a weapon");
							return 1;
						}
						else {
							ShowBackpackMenu(playerid, DIALOG_BGUNS, "- Select a weapon ERROR");
						}
					}
					case 3: {
						format(szMiscArray, sizeof(szMiscArray), "ListItem%dWId", listitem);
						wbid = GetPVarInt(playerid, szMiscArray);
						if((handguns >= 2 && primguns >= 3) || (primguns >= 3 && IsWeaponPrimary(wbid)) || (handguns >= 2 && IsWeaponHandgun(wbid))) {
							ShowBackpackMenu(playerid, DIALOG_BGUNS, "- You can only carry 2 handguns and 3 primary");
							return 1;
						}
						if(slot != 0 && PlayerInfo[playerid][pGuns][GetWeaponSlot(wbid)] == wbid && PlayerInfo[playerid][pAGuns][GetWeaponSlot(wbid)] == 0) {
							RemovePlayerWeapon(playerid, wbid);
							PlayerInfo[playerid][pBItems][slot] = wbid;
							GetWeaponName(wbid, weapname, sizeof(weapname));
							format(szMiscArray, sizeof(szMiscArray), "You have deposited a %s inside your backpack.", weapname);
							SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);

							format(szMiscArray, sizeof(szMiscArray), "* %s has deposited a %s inside their backpack.", GetPlayerNameEx(playerid), weapname);
							ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
							new ip[MAX_PLAYER_NAME];
							GetPlayerIp(playerid, ip, sizeof(ip));
							format(szMiscArray, sizeof(szMiscArray), "[WEAPONS] %s(%d) (IP:%s) deposited a %s(%d) in slot %d [BACKPACK %d]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ip, weapname, wbid, slot, PlayerInfo[playerid][pBackpack]);
							Log("logs/backpack.log", szMiscArray);
							ShowBackpackMenu(playerid, DIALOG_BGUNS, "- Select a weapon");
							return 1;
						}
						else {
							ShowBackpackMenu(playerid, DIALOG_BGUNS, "- Select a weapon ERROR");
						}
					}
				}
			}
			else {
				ShowBackpackMenu(playerid, DIALOG_BGUNS, "- Select a weapon");
			}
		}
		case DIALOG_BMEALSTORE: {
			if(response) {
				PlayerInfo[playerid][pBItems][0]++;
				format(szMiscArray,sizeof(szMiscArray),"* You have stored a Full Meal in your backpack(%d meals).",PlayerInfo[playerid][pBItems][0]);
				SendClientMessage(playerid, COLOR_GRAD2, szMiscArray);
			}
			else {
				if (PlayerInfo[playerid][pFitness] >= 5)
					PlayerInfo[playerid][pFitness] -= 5;
				else
					PlayerInfo[playerid][pFitness] = 0;
				SetHealth(playerid, 100.0);
			}
		}
		case DIALOG_BDROP:
		{
			if(!response) return SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully cancelled dropping your backpack.");
			if(PlayerInfo[playerid][pBackpack] > 0)
			{
				new choice[7];
				switch(PlayerInfo[playerid][pBackpack])
				{
					case 1: choice = "Small";
					case 2: choice = "Medium";
					case 3: choice = "Large";
				}
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				format(szMiscArray, sizeof(szMiscArray), "You have dropped your %s Backpack.", choice);
				SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
				RemovePlayerAttachedObject(playerid, 9);
				PlayerInfo[playerid][pBackpack] = 0;
				PlayerInfo[playerid][pBEquipped] = 0;
				PlayerInfo[playerid][pBStoredH] = INVALID_HOUSE_ID;
				PlayerInfo[playerid][pBStoredV] = INVALID_PLAYER_VEHICLE_ID;
				for(new i = 0; i < 10; i++)
				{
					PlayerInfo[playerid][pBItems][i] = 0;
				}
				format(szMiscArray, sizeof(szMiscArray), "* %s has thrown away their backpack.", GetPlayerNameEx(playerid));
				ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				new ip[MAX_PLAYER_NAME];
				GetPlayerIp(playerid, ip, sizeof(ip));
				format(szMiscArray, sizeof(szMiscArray), "[DROP] %s(%d) (IP:%s) has thrown away his %s Backpack", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), choice);
				Log("logs/backpack.log", szMiscArray);
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GREY, "You do not have a backpack!");
			}
		}
	}
	return 0;
}

CMD:sellbackpack(playerid, params[])
{
	if(PlayerInfo[playerid][pBackpack] > 0)
	{
		if(!PlayerInfo[playerid][pBEquipped]) return SendClientMessageEx(playerid, COLOR_GREY, "You are are not wearing your backpack, you can wear it with /bwear.");
		if(!IsBackpackAvailable(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot use your backpack at this moment.");
		if(GetPVarType(playerid, "IsInArena")) return SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this right now, you are in an arena!");
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

			for(new i; i < sizeof(Drugs); ++i) {

				if(PlayerInfo[giveplayerid][pBDrugs][i] > 0) {

					format(string, sizeof(string), "(Backpack) %d grams of %s.", PlayerInfo[giveplayerid][pBDrugs][i], Drugs[i]);
					SendClientMessageEx(playerid, COLOR_GREY, string);
				}
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

			for(new i; i < sizeof(Drugs); ++i) {

				if(PlayerInfo[giveplayerid][pBDrugs][i] > 0) {

					format(string, sizeof(string), "(Backpack) %d grams of %s.", PlayerInfo[giveplayerid][pBDrugs][i], Drugs[i]);
					SendClientMessageEx(playerid, COLOR_GREY, string);
				}
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
		SendClientMessageEx(playerid, COLOR_YELLOW, "ITEMS: [All drugs - see /mydrugs], Guns, Meals");
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

			new iDrugID = GetDrugID(item);
			if(iDrugID != -1) {

				format(string, sizeof(string), "* You have taken away %s's %s from their backpack.", GetPlayerNameEx(giveplayerid), Drugs[iDrugID]);
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
				format(string, sizeof(string), "* Officer %s has taken away your %s from your backpack.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), Drugs[iDrugID]);
				SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
				format(string, sizeof(string), "* Officer %s has taken away %s's %s from their backpack.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), Drugs[iDrugID]);
				ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				PlayerInfo[giveplayerid][pBDrugs][iDrugID] = 0;
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
		if(GetPVarType(playerid, "IsInArena")) return SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this right now, you are in an arena!");
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
			if(PlayerHoldingObject[playerid][9] != 0 || IsPlayerAttachedObjectSlotUsed(playerid, 9))
				RemovePlayerAttachedObject(playerid, 9), PlayerHoldingObject[playerid][9] = 0;
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
				if(PlayerHoldingObject[playerid][9] != 0 || IsPlayerAttachedObjectSlotUsed(playerid, 9))
					RemovePlayerAttachedObject(playerid, 9), PlayerHoldingObject[playerid][9] = 0;
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
		if(GetPVarType(playerid, "IsInArena")) return SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this right now, you are in an arena!");
		if(GetPVarInt(playerid, "EventToken") != 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use this while you're in an event.");
		if(IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this while being inside the vehicle!");
		if(GetPVarInt(playerid, "EMSAttempt") != 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can't use this command!");
		new Float: Health;
		GetHealth(playerid, Health);
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
		if(dr_iPlayerTimeStamp[playerid] > gettime() - 60) return SendClientMessageEx(playerid, COLOR_GRAD1, "You have been injured in the last minute");
		if(!IsBackpackAvailable(playerid)) {
			SendClientMessageEx(playerid, COLOR_GREY, "You cannot use your backpack at this moment.");
			return 1;
		}
		new string[122];
		if(GetPVarInt(playerid, "BackpackDisabled") > 0)
		{
			format(string, sizeof(string), "You have recently taken damage during the backpack menu, your backpack is disabled for %d second(s)", GetPVarInt(playerid, "BackpackDisabled"));
			SendClientMessageEx(playerid, COLOR_GREY, string);
			return 1;
		}
		ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0, 1);
		format(string, sizeof(string), "{FF8000}** {C2A2DA}%s lays down and opens a backpack.", GetPlayerNameEx(playerid));
		SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 15.0, 5000);
		// ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		SetPVarInt(playerid, "BackpackProt", 1);
		SetPVarInt(playerid, "BackpackOpen", 1);

		ShowBackpackMenu(playerid, DIALOG_OBACKPACK, "");
	}
	return 1;
}

CMD:backpackhelp(playerid, params[])
{
	SetPVarInt(playerid, "HelpResultCat0", 2);
	Help_ListCat(playerid, DIALOG_HELPCATOTHER1);
	return 1;
}

CMD:obackpackhelp(playerid, params[]) {

	szMiscArray[0] = 0;
	format(szMiscArray, sizeof(szMiscArray), "Item: Small Backpack\nFood Storage: 1 Meals\nNarcotics Storage: 40 Grams\nFirearms Storage: 2 Weapons(Handguns only)\nCost: {FFD700}%s{A9C4E4}\n\n", number_format(ShopItems[36][sItemPrice]));
	format(szMiscArray, sizeof(szMiscArray), "%sItem: Medium Backpack\nFood Storage: 4 Meals\nNarcotics Storage: 100 Grams\nFirearms Storage: 3 Weapons(2 Handguns & 1 Primary)\nCost: {FFD700}%s{A9C4E4}\n\n", szMiscArray, number_format(ShopItems[37][sItemPrice]));
	format(szMiscArray, sizeof(szMiscArray), "%sItem: Large Backpack\nFood Storage: 5 Meals\nNarcotics Storage: 250 Grams\nFirearms Storage: 5 Weapons(2 Handguns & 3 Primary)\nCost: {FFD700}%s{A9C4E4}\n\n\n", szMiscArray, number_format(ShopItems[38][sItemPrice]));
	format(szMiscArray, sizeof(szMiscArray), "%sCommands available: /bstore /bwear /bopen /sellbackpack /drop backpack (/miscshop to buy one with credits)", szMiscArray);

	ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Backpack Information", szMiscArray, "Exit", "");
    return 1;
}
