#include <YSI\y_hooks>

#define 	ITEM_DRUG			(0)
#define 	ITEM_MATS			(1)
#define 	ITEM_FIREWORK		(2)
#define 	ITEM_SYRINGES		(3)
#define 	ITEM_SPRUNKDRINK	(4)
#define 	ITEM_PBTOKENS		(5)
#define 	ITEM_WEAPON			(6)

#define 	INTERACT_AMOUNT			(10049)
#define 	INTERACT_MAIN 			(10050)
#define 	INTERACT_GIVE 			(10051)
#define 	DETAIN_SEAT 			(10052)
#define 	GIVE_TICKET				(10053)
#define 	HEAL_PLAYER				(10054)
#define 	TICKET_REASON			(10055)
#define 	PATIENT_SEAT			(10056)
#define 	INTERACT_WEAPON			(10057)
#define 	PAY_PLAYER				(10058)
#define 	INTERACT_SELL 			(10059)
#define 	INTERACT_SELLCONFIRM 	(10060)
#define 	INTERACT_DRUGS			(10061)
#define 	INTERACT_SELLCONFIRM2 	(10062)

#define 	INTERACT_PRESCRIBE		(10063)
#define 	INTERACT_PRESCRIBE1 	(10064)


Player_InteractMenu(playerid, giveplayerid, menu = 0) {

	// if(playerid == giveplayerid) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot interact with yourself.");

	szMiscArray[0] = 0;

	new szTitle[64];

	format(szTitle, sizeof(szTitle), "Interaction - %s", GetPlayerNameEx(giveplayerid));

	switch(menu) {
		case 0: {

			DeletePVar(giveplayerid, "Interact_Buying");
			DeletePVar(playerid, "Interact_SellPrice");
			DeletePVar(playerid, "Interact_Sell");
			DeletePVar(playerid, "Interact_SellGun");
			DeletePVar(playerid, "Interact_GiveItem");
			DeletePVar(playerid, "Interact_SellAmt");
			DeletePVar(playerid, "Interact_Drug");

			SetPVarInt(playerid, "Interact_Target", giveplayerid);

			format(szMiscArray, sizeof(szMiscArray), "Pay\nGive Item\nSell Item\nFrisk\nShow License");

			if(IsACop(playerid)) { // LEO-related interaction commands
				strcat(szMiscArray, "\nCuff\nDrag\nDetain\nTicket\nUncuff\nDrug Test\nConfiscate Drugs");
			}

			if(IsAMedic(playerid)) { // Medical-related commands.
				strcat(szMiscArray, "\nPrescribe Drug\nLoad Patient\nTriage\nHeal\nMove Patient\nDrug Test");
			}
			return ShowPlayerDialogEx(playerid, INTERACT_MAIN, DIALOG_STYLE_LIST, szTitle, szMiscArray, "Select", "Close");
		}
		case 1: {
			/*Ingredients\n\
			Pistol Ammo\t%d\n\
				Rifle Ammo\t%d\n\
				Deagle Ammo\t%d\n\
				Shotgun Ammo\t%d\n\*/
			format(szMiscArray, sizeof(szMiscArray), "Item\tCurrent Amount\n\
				Drugs\n\
				Materials\t%d\n\
				Fireworks\t%d\n\
				Syringes\t%d\n\
				Sprunk\t%d\n\
				PB Tokens\t%d\n\
				Weapon",
				PlayerInfo[playerid][pMats],
				PlayerInfo[playerid][pFirework],
				PlayerInfo[playerid][pSyringes],
				PlayerInfo[playerid][pSprunk],
				PlayerInfo[playerid][pPaintTokens]
			);
			return ShowPlayerDialogEx(playerid, INTERACT_GIVE, DIALOG_STYLE_TABLIST_HEADERS, szTitle, szMiscArray, "Select", "Back");
		}
		case 2: {
			new itemid = GetPVarInt(playerid, "Interact_GiveItem");

			if(GetPVarType(playerid, "Interact_Drug")) {
				format(szMiscArray, sizeof(szMiscArray), "How many pieces of %s do you want to give %s", Drugs[GetPVarInt(playerid, "Interact_Drug")], GetPlayerNameEx(giveplayerid));
			}
			else format(szMiscArray, sizeof(szMiscArray), "How much %s do you want to give %s", Item_Getname(itemid), GetPlayerNameEx(giveplayerid));
			return ShowPlayerDialogEx(playerid, INTERACT_AMOUNT, DIALOG_STYLE_INPUT, szTitle, szMiscArray, "Select", "Back");
		}
		case 3: {

			for(new g = 0; g < 12; g++)	{
				if(PlayerInfo[playerid][pGuns][g] != 0 && PlayerInfo[playerid][pAGuns][g] == 0) {
					format(szMiscArray, sizeof(szMiscArray), "%s\n%s(%i)", szMiscArray, Weapon_ReturnName(PlayerInfo[playerid][pGuns][g]), PlayerInfo[playerid][pGuns][g]);
				}
			}
			return ShowPlayerDialogEx(playerid, INTERACT_WEAPON, DIALOG_STYLE_LIST, szTitle, szMiscArray, "Give", "Back");
		}
		case 4: {
			new itemid = GetPVarInt(playerid, "Interact_GiveItem");
			new amount = GetPVarInt(playerid, "Interact_SellAmt");

			if(GetPVarType(playerid, "Interact_SellGun")) {
				new weaponid = GetPVarInt(playerid, "Interact_SellGun");

				format(szMiscArray, sizeof(szMiscArray), "How much do you want to sell %s to %s for?", ReturnWeaponName(weaponid), GetPlayerNameEx(giveplayerid));
			}
			if(GetPVarType(playerid, "Interact_Drug")) {

				new drugid = GetPVarInt(playerid, "Interact_Drug");

				format(szMiscArray, sizeof(szMiscArray), "How much do you want to sell %dg of %s to %s for?", amount, Drugs[drugid], GetPlayerNameEx(giveplayerid));
			}
			else format(szMiscArray, sizeof(szMiscArray), "How much do you want to sell %d %s to %s for?", amount, Item_Getname(itemid), GetPlayerNameEx(giveplayerid));

			return ShowPlayerDialogEx(playerid, INTERACT_SELL, DIALOG_STYLE_INPUT, szTitle, szMiscArray, "Sell", "Back");
		}

		case 5: {
			new itemid = GetPVarInt(playerid, "Interact_GiveItem");
			new amount = GetPVarInt(playerid, "Interact_SellAmt");
			new offerprice = GetPVarInt(playerid, "Interact_SellPrice");


			if(GetPVarType(playerid, "Interact_SellGun")) {

				new weaponid = GetPVarInt(playerid, "Interact_SellGun");

				format(szMiscArray, sizeof(szMiscArray), "[Interact]: You have offered %s to buy a %s for $%s", GetPlayerNameEx(giveplayerid), Item_Getname(itemid), number_format(offerprice));
				SendClientMessage(playerid, COLOR_LIGHTBLUE, szMiscArray);
				format(szMiscArray, sizeof(szMiscArray), "%s has offered you to buy a %s for $%s", GetPlayerNameEx(playerid), ReturnWeaponName(weaponid), number_format(offerprice));
			}
			else if(GetPVarType(playerid, "Interact_Drug")) {
				new drugid = GetPVarInt(playerid, "Interact_Drug");

				format(szMiscArray, sizeof(szMiscArray), "[Interact]: You have offered %s to buy %dg of %s {FFFFFF}for $%s", GetPlayerNameEx(giveplayerid), amount, Drugs[drugid], number_format(offerprice));
				SendClientMessage(playerid, COLOR_LIGHTBLUE, szMiscArray);
				format(szMiscArray, sizeof(szMiscArray), "%s has offered you to buy %dg of %s {FFFFFF}for $%s", GetPlayerNameEx(playerid), amount, Drugs[drugid], number_format(offerprice));
			}
			else {
				format(szMiscArray, sizeof(szMiscArray), "[Interact]: You have offered %s to buy %d %s for $%s", GetPlayerNameEx(giveplayerid), amount, Item_Getname(itemid), number_format(offerprice));
				SendClientMessage(playerid, COLOR_LIGHTBLUE, szMiscArray);
				format(szMiscArray, sizeof(szMiscArray), "%s has offered you to buy %d %s for $%s", GetPlayerNameEx(playerid), amount, Item_Getname(itemid), number_format(offerprice));
			}
			ShowPlayerDialogEx(giveplayerid, INTERACT_SELLCONFIRM, DIALOG_STYLE_MSGBOX, szTitle, szMiscArray, "Buy", "Reject");


		}
		case 6: {

			szMiscArray = "Drug\tAmount\n";
			for(new d; d < sizeof(Drugs); ++d) {

				format(szMiscArray, sizeof(szMiscArray), "%s%s\t%d\n", szMiscArray, Drugs[d], PlayerInfo[playerid][pDrugs][d]);
			}
			return ShowPlayerDialogEx(playerid, INTERACT_DRUGS, DIALOG_STYLE_TABLIST_HEADERS, szTitle, szMiscArray, "Select", "Back");
		}
	}

	return 1;
}

Player_GiveItem(playerid, giveplayerid, itemid, amount, saleprice = 0) {

	// amount in the case of giving weapons is the weapon id ...

	szMiscArray[0] = 0;

	if(amount <= 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot give nothing.");

	if(restarting) return SendClientMessageEx(playerid, COLOR_RED, "Server restart in progress, trading is disabled.");

	if(saleprice != 0 && (GetPlayerCash(giveplayerid) < saleprice || saleprice < 0)) return SendClientMessage(giveplayerid, COLOR_GRAD2, "You do not have enough money");

	switch(itemid) {

		case ITEM_DRUG: {

			new drugid = GetPVarInt(playerid, "Interact_Drug");
			if(PlayerInfo[playerid][pDrugs][drugid] < amount) return SendClientMessageEx(playerid, COLOR_WHITE, "You do not have that much.");

			if(amount + PlayerInfo[giveplayerid][pDrugs][drugid] > Player_MaxCapacity(giveplayerid, itemid)) {
				format(szMiscArray, sizeof(szMiscArray), "That player can only hold %d more of that item.", Player_LeftCapacity(giveplayerid, itemid));
				SendClientMessageEx(playerid, COLOR_GRAD2, szMiscArray);
				return Player_InteractMenu(playerid, giveplayerid);
			}

			PlayerInfo[giveplayerid][pDrugs][drugid] += amount;
			PlayerInfo[playerid][pDrugs][drugid] -= amount;

		}
		case ITEM_MATS: {

			if(PlayerInfo[playerid][pMats] < amount) return SendClientMessageEx(playerid, COLOR_WHITE, "You do not have that many materials.");

			if(amount + PlayerInfo[giveplayerid][pMats] > Player_MaxCapacity(giveplayerid, itemid)) {
				format(szMiscArray, sizeof(szMiscArray), "That player can only hold %d more of that item.", Player_LeftCapacity(giveplayerid, itemid));
				SendClientMessageEx(playerid, COLOR_GRAD2, szMiscArray);
				return Player_InteractMenu(playerid, giveplayerid);
			}

			PlayerInfo[giveplayerid][pMats] += amount;
			PlayerInfo[playerid][pMats] -= amount;
		}
		case ITEM_FIREWORK: {

			if(PlayerInfo[playerid][pFirework] < amount) return SendClientMessageEx(playerid, COLOR_WHITE, "You do not have that many fireworks.");

			if(amount + PlayerInfo[giveplayerid][pFirework] > Player_MaxCapacity(giveplayerid, itemid)) {
				format(szMiscArray, sizeof(szMiscArray), "That player can only hold %d more of that item.", Player_LeftCapacity(giveplayerid, itemid));
				SendClientMessageEx(playerid, COLOR_GRAD2, szMiscArray);
				return Player_InteractMenu(playerid, giveplayerid);
			}

			PlayerInfo[giveplayerid][pFirework] += amount;
			PlayerInfo[playerid][pFirework] -= amount;
		}
		case ITEM_SYRINGES: {

			if(PlayerInfo[playerid][pSyringes] < amount) return SendClientMessageEx(playerid, COLOR_WHITE, "You do not have that much syringes.");

			if(amount + PlayerInfo[giveplayerid][pSyringes] > Player_MaxCapacity(giveplayerid, itemid)) {
				format(szMiscArray, sizeof(szMiscArray), "That player can only hold %d more of that item.", Player_LeftCapacity(giveplayerid, itemid));
				SendClientMessageEx(playerid, COLOR_GRAD2, szMiscArray);
				return Player_InteractMenu(playerid, giveplayerid);
			}

			PlayerInfo[giveplayerid][pSyringes] += amount;
			PlayerInfo[playerid][pSyringes] -= amount;
		}
		case ITEM_SPRUNKDRINK: {

			if(PlayerInfo[playerid][pSprunk] < amount) return SendClientMessageEx(playerid, COLOR_WHITE, "You do not have that much sprunk soda.");

			if(amount + PlayerInfo[giveplayerid][pSprunk] > Player_MaxCapacity(giveplayerid, itemid)) {
				format(szMiscArray, sizeof(szMiscArray), "That player can only hold %d more of that item.", Player_LeftCapacity(giveplayerid, itemid));
				SendClientMessageEx(playerid, COLOR_GRAD2, szMiscArray);
				return Player_InteractMenu(playerid, giveplayerid);
			}

			PlayerInfo[giveplayerid][pSprunk] += amount;
			PlayerInfo[playerid][pSprunk] -= amount;

		}
		case ITEM_PBTOKENS: {

			if(PlayerInfo[playerid][pPaintTokens] < amount) return SendClientMessageEx(playerid, COLOR_WHITE, "You do not have that many PB tokens.");

			if(amount + PlayerInfo[giveplayerid][pPaintTokens] > Player_MaxCapacity(giveplayerid, itemid)) {
				format(szMiscArray, sizeof(szMiscArray), "That player can only hold %d more of that item.", Player_LeftCapacity(giveplayerid, itemid));
				SendClientMessageEx(playerid, COLOR_GRAD2, szMiscArray);
				return Player_InteractMenu(playerid, giveplayerid);
			}

			PlayerInfo[giveplayerid][pPaintTokens] += amount;
			PlayerInfo[playerid][pPaintTokens] -= amount;
		}
	}

	if(saleprice == 0) {

		format(szMiscArray, sizeof(szMiscArray), "You have given %s %d %s", GetPlayerNameEx(giveplayerid), amount, Item_Getname(itemid));
		SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);

		format(szMiscArray, sizeof(szMiscArray), "%s has given you %d %s", GetPlayerNameEx(playerid), amount, Item_Getname(itemid));
		SendClientMessageEx(giveplayerid, COLOR_WHITE, szMiscArray);

		format(szMiscArray, sizeof(szMiscArray), "%s hands %s some %s", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), Item_Getname(itemid));
		SetPlayerChatBubble(playerid, szMiscArray, COLOR_PURPLE, 5, 5000);

		format(szMiscArray, sizeof(szMiscArray), "%s(%d) (IP:%s) has given %d %s to %s(%d) (IP:%s)", GetPlayerNameEx(playerid), PlayerInfo[playerid][pId], PlayerInfo[playerid][pIP], amount, Item_Getname(itemid), GetPlayerNameEx(giveplayerid), PlayerInfo[giveplayerid][pId], PlayerInfo[giveplayerid][pIP]);
		Log("logs/pay.log", szMiscArray);

		format(szMiscArray, sizeof(szMiscArray), "gave %d %s.", amount, Item_Getname(itemid));
		DBLog(playerid, giveplayerid, "ItemTransfer", szMiscArray);
	}
	else {

		GivePlayerCash(playerid, saleprice);
		GivePlayerCash(giveplayerid, -saleprice);

		//TurfWars_TurfTax(giveplayerid, Item_Getname(itemid), saleprice); // Tax the buyer, not the seller.
		ExtortionTurfsWarsZone(playerid, 7, saleprice); // Back to taxing the seller. 

		format(szMiscArray, sizeof(szMiscArray), "You have sold %s %d %s for $%s", GetPlayerNameEx(giveplayerid), amount, Item_Getname(itemid), number_format(saleprice));
		SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);

		format(szMiscArray, sizeof(szMiscArray), "%s has sold you %d %s for $%s", GetPlayerNameEx(playerid), amount, Item_Getname(itemid), number_format(saleprice));
		SendClientMessageEx(giveplayerid, COLOR_WHITE, szMiscArray);

		format(szMiscArray, sizeof(szMiscArray), "%s hands %s some %s", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), Item_Getname(itemid));
		SetPlayerChatBubble(playerid, szMiscArray, COLOR_PURPLE, 5, 5000);

		format(szMiscArray, sizeof(szMiscArray), "%s(%d) (IP:%s) has sold %d %s $%s to %s(%d) (IP:%s)", GetPlayerNameEx(playerid), PlayerInfo[playerid][pId], PlayerInfo[playerid][pIP], amount, Item_Getname(itemid), number_format(saleprice), GetPlayerNameEx(giveplayerid), PlayerInfo[giveplayerid][pId], PlayerInfo[giveplayerid][pIP]);
		Log("logs/pay.log", szMiscArray);

		format(szMiscArray, sizeof(szMiscArray), "%d %s $%s.", amount, Item_Getname(itemid), number_format(saleprice));
		DBLog(playerid, giveplayerid, "ItemTransfer", szMiscArray);
	}

	return 1;
}

Player_MaxCapacity(playerid, itemid) {

	// planning on making this relative to a storage system in the future

	new iTemp = 0;

	switch(itemid) {
		case ITEM_MATS: iTemp = 1000000;
		case ITEM_FIREWORK: iTemp = 10;
		case ITEM_SYRINGES: iTemp = 20;
		case ITEM_SPRUNKDRINK: iTemp = 1;
		case ITEM_PBTOKENS: iTemp = 40;
		case ITEM_DRUG: {
			iTemp = GetMaxDrugsAllowed(GetPVarInt(playerid, "Interact_Drug"));
		}
	}
	return iTemp;
}

Player_LeftCapacity(playerid, itemid) {

	new
		iCapacity = Player_MaxCapacity(playerid, itemid);

	switch(itemid) {

		case ITEM_MATS: return (iCapacity - PlayerInfo[playerid][pMats]);
		case ITEM_FIREWORK: return (iCapacity - PlayerInfo[playerid][pFirework]);
		case ITEM_SYRINGES: return (iCapacity - PlayerInfo[playerid][pSyringes]);
		case ITEM_SPRUNKDRINK: return (iCapacity - PlayerInfo[playerid][pSprunk]);
		case ITEM_PBTOKENS: return (iCapacity - PlayerInfo[playerid][pPaintTokens]);
		case ITEM_DRUG: return (iCapacity - PlayerInfo[playerid][pDrugs][GetPVarInt(playerid, "Interact_Drug")]);
		default: return 0;
	}

	return 0;
}

Item_Getname(itemid) {

	new szTemp[18];

	switch(itemid) {
		case ITEM_MATS: szTemp = "materials";
		case ITEM_FIREWORK: szTemp = "fireworks";
		case ITEM_SYRINGES: szTemp = "syringes";
		case ITEM_SPRUNKDRINK: szTemp = "sprunk";
		case ITEM_PBTOKENS: szTemp = "paintball tokens";
	}
	return szTemp;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	switch(dialogid) {
		case INTERACT_MAIN: {

			if(!response) {
				return DeletePVar(playerid, "Interact_Target");
			}

			new giveplayerid = GetPVarInt(playerid, "Interact_Target");

			switch(listitem) {

				case 0: return Interact_PayPlayer(playerid, giveplayerid);
				case 1: return Player_InteractMenu(playerid, giveplayerid, 1);
				case 2: {
					SetPVarInt(playerid, "Interact_Sell", 1);
					return Player_InteractMenu(playerid, giveplayerid, 1);
				}
				case 3: return Interact_FriskPlayer(playerid, giveplayerid);
				case 4: return Interact_ShowLicenses(playerid, giveplayerid);
			}

			if(strcmp(inputtext, "Cuff") == 0) return Interact_CuffPlayer(playerid, giveplayerid);
			else if(strcmp(inputtext, "Drag") == 0) return Interact_DragPlayer(playerid, giveplayerid);
			else if(strcmp(inputtext, "Detain") == 0) return Interact_DetainPlayer(playerid, giveplayerid);
			else if(strcmp(inputtext, "Ticket") == 0) return Interact_GiveTicket(playerid, giveplayerid, "");
			else if(strcmp(inputtext, "Uncuff") == 0) return Interact_UncuffPlayer(playerid, giveplayerid);
			else if(strcmp(inputtext, "Drug Test") == 0) return SendClientMessageEx(playerid, COLOR_WHITE, "Drug tests have been disabled and will later be removed completely.");
			else if(strcmp(inputtext, "Confiscate Drugs") == 0) return Interact_TakeDrugs(playerid, giveplayerid);
			else if(strcmp(inputtext, "Prescribe Drug") == 0) return Interact_Prescribe(playerid, 0);
			else if(strcmp(inputtext, "Load Patient") == 0) Interact_LoadPatient(playerid, giveplayerid);
			else if(strcmp(inputtext, "Triage") == 0) return Interact_Triage(playerid, giveplayerid);
			else if(strcmp(inputtext, "Heal") == 0) return Interact_Heal(playerid, giveplayerid);
			else if(strcmp(inputtext, "Move Patient") == 0) return Interact_MovePatient(playerid, giveplayerid);
		}

		case INTERACT_GIVE: {

			new giveplayerid = GetPVarInt(playerid, "Interact_Target");

			if(!response) return Player_InteractMenu(playerid, giveplayerid, 0);
			if(strcmp(inputtext, "Drugs") == 0) return Player_InteractMenu(playerid, giveplayerid, 6);
			if(strcmp(inputtext, "Weapon") == 0) return Player_InteractMenu(playerid, giveplayerid, 3);

			SetPVarInt(playerid, "Interact_GiveItem", listitem);

			Player_InteractMenu(playerid, giveplayerid, 2);


		}

		case INTERACT_AMOUNT: {
			new giveplayerid = GetPVarInt(playerid, "Interact_Target");

			if(!response) return Player_InteractMenu(playerid, giveplayerid, 0);

			new
				amount = strval(inputtext),
				itemid = GetPVarInt(playerid, "Interact_GiveItem");

			if(amount < 1) {
				SendClientMessageEx(playerid, COLOR_RED, "You must offer an item greater than 0!");
				return Player_InteractMenu(playerid, giveplayerid, 0);
			}

			SetPVarInt(playerid, "Interact_SellAmt", amount);
			if(GetPVarType(playerid, "Interact_Sell")) {

				return Player_InteractMenu(playerid, giveplayerid, 4);
			}
			if(GetPVarType(playerid, "Interact_Drug")) {
				Interact_GivePlayerDrug(playerid, giveplayerid, GetPVarInt(playerid, "Interact_Drug"));
				return 1;
			}
			Player_GiveItem(playerid, giveplayerid, itemid, amount);
		}

		case DETAIN_SEAT: {

			new giveplayerid = GetPVarInt(playerid, "Interact_Target");

			if(!response) return Player_InteractMenu(playerid, giveplayerid, 0);

			new seatid = strval(inputtext);

			if(!(0 < seatid <= 3)) {
				SendClientMessageEx(playerid, COLOR_GRAD2, "Seat id must be between 1, 2 or 3.");
				return Interact_DetainPlayer(playerid, giveplayerid);
			}

			Interact_DetainPlayer(playerid, giveplayerid, seatid);
		}

		case GIVE_TICKET: {

			new giveplayerid = GetPVarInt(playerid, "Interact_Target");

			if(!response) return Player_InteractMenu(playerid, giveplayerid, 0);

			new amount = strval(inputtext);

			if(!(0 < amount <= 25000)) {
				SendClientMessageEx(playerid, COLOR_GRAD2, "Ticket price must be between $0 and $25,000.");
				return Interact_GiveTicket(playerid, giveplayerid, "");
			}


			SetPVarInt(playerid, "Ticket_Amount", amount);
			Interact_GiveTicket(playerid, giveplayerid, "", amount);
		}

		case TICKET_REASON: {

			new giveplayerid = GetPVarInt(playerid, "Interact_Target");

			if(!response) return Player_InteractMenu(playerid, giveplayerid, 0);

			new amount = GetPVarInt(playerid, "Ticket_Amount");

			Interact_GiveTicket(playerid, giveplayerid, inputtext, amount);
		}

		case PATIENT_SEAT: {

			new giveplayerid = GetPVarInt(playerid, "Interact_Target");

			if(!response) return Player_InteractMenu(playerid, giveplayerid, 0);

			new seatid = strval(inputtext);

			if(!(0 < seatid <= 3)) {
				SendClientMessageEx(playerid, COLOR_GRAD2, "Seat id must be between 1, 2 or 3.");
				return Interact_LoadPatient(playerid, giveplayerid);
			}

			Interact_LoadPatient(playerid, giveplayerid, seatid);
		}

		case PAY_PLAYER: {

			new giveplayerid = GetPVarInt(playerid, "Interact_Target");

			if(!response) return Player_InteractMenu(playerid, giveplayerid, 0);

			new amount = strval(inputtext);

			Interact_PayPlayer(playerid, giveplayerid, amount);
		}

		case INTERACT_WEAPON: {
			new giveplayerid = GetPVarInt(playerid, "Interact_Target");

			if(!response) return Player_InteractMenu(playerid, giveplayerid, 0);

			new stpos = strfind(inputtext, "(");
		    new fpos = strfind(inputtext, ")");
		    new idstr[4], id;
		    strmid(idstr, inputtext, stpos+1, fpos);
		    id = strval(idstr);

		    if(GetPVarType(playerid, "Interact_Sell")) {
				SetPVarInt(playerid, "Interact_SellGun", id);
				return Player_InteractMenu(playerid, giveplayerid, 4);
			}

		    Interact_GivePlayerValidWeapon(playerid, giveplayerid, id);
		}
		case INTERACT_DRUGS: {
			new giveplayerid = GetPVarInt(playerid, "Interact_Target");

			if(!response) return Player_InteractMenu(playerid, giveplayerid, 0);
			SetPVarInt(playerid, "Interact_GiveItem", ITEM_DRUG);
			SetPVarInt(playerid, "Interact_Drug", listitem);

			if(GetPVarType(playerid, "Interact_Sell")) {
				return Player_InteractMenu(playerid, giveplayerid, 2);
			}

			Player_InteractMenu(playerid, giveplayerid, 2);
		}
		case INTERACT_SELL: {

			new giveplayerid = GetPVarInt(playerid, "Interact_Target");

			if(!response) return Player_InteractMenu(playerid, giveplayerid, 0);

			new price = strval(inputtext);

			SetPVarInt(playerid, "Interact_SellPrice", price);
			SetPVarInt(giveplayerid, "Interact_Buying", playerid);

			Player_InteractMenu(playerid, giveplayerid, 5);

		}
		case INTERACT_SELLCONFIRM: {
			new buyingfrom = GetPVarInt(playerid, "Interact_Buying");

			if(!response) {
				SendClientMessageEx(playerid, COLOR_WHITE, "You have rejected the trade offer.");
				SendClientMessageEx(buyingfrom, COLOR_WHITE, "That person has rejected the trade offer.");

				DeletePVar(playerid, "Interact_Buying");
				DeletePVar(buyingfrom, "Interact_SellPrice");
				DeletePVar(buyingfrom, "Interact_Sell");
				DeletePVar(buyingfrom, "Interact_SellGun");
				DeletePVar(playerid, "Interact_Drug");
				DeletePVar(buyingfrom, "Interact_GiveItem");
				DeletePVar(buyingfrom, "Interact_SellAmt");
				return 1;
			}

			new itemid = GetPVarInt(buyingfrom, "Interact_GiveItem");
			new amount = GetPVarInt(buyingfrom, "Interact_SellAmt");
			new offerprice = GetPVarInt(buyingfrom, "Interact_SellPrice");
			
			if(GetPVarType(buyingfrom, "Interact_SellGun")) {

				new weaponid = GetPVarInt(buyingfrom, "Interact_SellGun");

				format(szMiscArray, sizeof(szMiscArray), "%s has offered you to buy a %s for $%s\n\nPlease confirm again if you really are sure you want to complete this transaction!", GetPlayerNameEx(buyingfrom), ReturnWeaponName(weaponid), number_format(offerprice));
			}
			else if(GetPVarType(buyingfrom, "Interact_Drug")) {
				new drugid = GetPVarInt(buyingfrom, "Interact_Drug");
				format(szMiscArray, sizeof(szMiscArray), "%s has offered you to buy %dg of %s {FFFFFF}for $%s\n\nPlease confirm again if you really are sure you want to complete this transaction!", GetPlayerNameEx(buyingfrom), amount, Drugs[drugid], number_format(offerprice));
			}
			else {
				format(szMiscArray, sizeof(szMiscArray), "%s has offered you to buy %d %s for $%s\n\nPlease confirm again if you really are sure you want to complete this transaction!", GetPlayerNameEx(playerid), amount, Item_Getname(itemid), number_format(offerprice));
			}			

			ShowPlayerDialogEx(playerid, INTERACT_SELLCONFIRM2, DIALOG_STYLE_MSGBOX, "Are you really sure?", szMiscArray, "Buy", "Reject");
		}
		case INTERACT_SELLCONFIRM2: {

			new buyingfrom = GetPVarInt(playerid, "Interact_Buying");

			if(!response) {
				SendClientMessageEx(playerid, COLOR_WHITE, "You have rejected the trade offer.");
				SendClientMessageEx(buyingfrom, COLOR_WHITE, "That person has rejected the trade offer.");

				DeletePVar(playerid, "Interact_Buying");
				DeletePVar(buyingfrom, "Interact_SellPrice");
				DeletePVar(buyingfrom, "Interact_Sell");
				DeletePVar(buyingfrom, "Interact_SellGun");
				DeletePVar(playerid, "Interact_Drug");
				DeletePVar(buyingfrom, "Interact_GiveItem");
				DeletePVar(buyingfrom, "Interact_SellAmt");
				return 1;
			}

			new price = GetPVarInt(buyingfrom, "Interact_SellPrice");

			if(GetPVarType(buyingfrom, "Interact_Sell")) {

				if(GetPVarType(buyingfrom, "Interact_SellGun")) {

					new weaponid = GetPVarInt(buyingfrom, "Interact_SellGun");
					if(PlayerInfo[buyingfrom][pGuns][GetWeaponSlot(weaponid)] == weaponid)
					{
						Interact_GivePlayerValidWeapon(buyingfrom, playerid, weaponid, price);
					}
				}
				else if(GetPVarType(buyingfrom, "Interact_Drug")) {

					new drugid = GetPVarInt(buyingfrom, "Interact_Drug");
					Interact_GivePlayerDrug(buyingfrom, playerid, drugid, price);
				}
				else {

					new itemid = GetPVarInt(buyingfrom, "Interact_GiveItem");
					new amount = GetPVarInt(buyingfrom, "Interact_SellAmt");

					Player_GiveItem(buyingfrom, playerid, itemid, amount, price);
				}
			}
			DeletePVar(playerid, "Interact_Buying");
			DeletePVar(buyingfrom, "Interact_SellPrice");
			DeletePVar(buyingfrom, "Interact_Sell");
			DeletePVar(buyingfrom, "Interact_SellGun");
			DeletePVar(buyingfrom, "Interact_GiveItem");
			DeletePVar(buyingfrom, "Interact_SellAmt");
		}
		case INTERACT_PRESCRIBE: {
			SetPVarString(playerid, "DR_PTYPE", inputtext);
			Interact_Prescribe(playerid, 1);
		}
		case INTERACT_PRESCRIBE1: {
			if(strval(inputtext) <= 0 || !IsNumeric(inputtext)) return SendClientMessage(playerid, COLOR_GRAD1, "You specified an invalid value.");
			SetPVarInt(playerid, "DR_PAM", strval(inputtext));
			Interact_ProcessPrescription(playerid);
		}
	}
	return 0;
}

Interact_GivePlayerValidWeapon(playerid, giveplayerid, weaponid, saleprice = 0) {

	if(PlayerInfo[giveplayerid][pGuns][GetWeaponSlot(weaponid)] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "That player already has a weapon in that slot");
	if(PlayerInfo[playerid][pGuns][GetWeaponSlot(weaponid)] != weaponid) return SendClientMessageEx(playerid, COLOR_GREY, "You don't have a weapon in your possession.");
	if(weaponid == WEAPON_KNIFE) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot give knives!");
	if(GetPVarType(giveplayerid, "IsInArena") || GetPVarInt(giveplayerid, "EventToken") != 0) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot do this right now!");
	if(PlayerInfo[giveplayerid][pConnectHours] < 2 || PlayerInfo[giveplayerid][pWRestricted] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "That person is currently restricted from carrying weapons");


	if(saleprice != 0 && (GetPlayerCash(giveplayerid) < saleprice || saleprice < 0)) return SendClientMessage(giveplayerid, COLOR_GRAD2, "You do not have enough money");
	PlayerInfo[playerid][pGuns][GetWeaponSlot(weaponid)] = 0;
	SetPlayerWeaponsEx(playerid);

	GivePlayerValidWeapon(giveplayerid, weaponid);

	if(saleprice != 0) {

		GivePlayerCash(playerid, saleprice);
		GivePlayerCash(giveplayerid, -saleprice);

		//TurfWars_TurfTax(giveplayerid, ReturnWeaponName(weaponid), saleprice);
		ExtortionTurfsWarsZone(playerid, 3, saleprice);

		format(szMiscArray, sizeof(szMiscArray), "You have sold %s a %s for $%s", GetPlayerNameEx(giveplayerid), ReturnWeaponName(weaponid), number_format(saleprice));
		SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);

		format(szMiscArray, sizeof(szMiscArray), "%s has sold you a %s $%s", GetPlayerNameEx(playerid), ReturnWeaponName(weaponid), number_format(saleprice));
		SendClientMessageEx(giveplayerid, COLOR_WHITE, szMiscArray);

		format(szMiscArray, sizeof(szMiscArray), "%s(%d) (IP:%s) has sold a %s for $%s to %s(%d) (IP:%s)", GetPlayerNameEx(playerid), PlayerInfo[playerid][pId], PlayerInfo[playerid][pIP], ReturnWeaponName(weaponid), number_format(saleprice), GetPlayerNameEx(giveplayerid), PlayerInfo[giveplayerid][pId], PlayerInfo[giveplayerid][pIP]);
		Log("logs/pay.log", szMiscArray);

		format(szMiscArray, sizeof(szMiscArray), "sold a %s for $%s.", ReturnWeaponName(weaponid), number_format(saleprice));
		DBLog(playerid, giveplayerid, "ItemTransfer", szMiscArray);
	}
	else {
		format(szMiscArray, sizeof(szMiscArray), "You have given %s a %s", GetPlayerNameEx(giveplayerid), ReturnWeaponName(weaponid));
		SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);

		format(szMiscArray, sizeof(szMiscArray), "%s has given you a %s", GetPlayerNameEx(playerid), ReturnWeaponName(weaponid));
		SendClientMessageEx(giveplayerid, COLOR_WHITE, szMiscArray);

		format(szMiscArray, sizeof(szMiscArray), "%s(%d) (IP:%s) has given a %s to %s(%d) (IP:%s)", GetPlayerNameEx(playerid), PlayerInfo[playerid][pId], PlayerInfo[playerid][pIP], ReturnWeaponName(weaponid), GetPlayerNameEx(giveplayerid), PlayerInfo[giveplayerid][pId], PlayerInfo[giveplayerid][pIP]);
		Log("logs/pay.log", szMiscArray);

		format(szMiscArray, sizeof(szMiscArray), "gave a %s.", ReturnWeaponName(weaponid));
		DBLog(playerid, giveplayerid, "ItemTransfer", szMiscArray);
	}

	format(szMiscArray, sizeof(szMiscArray), "%s gave %s a %s", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), ReturnWeaponName(weaponid));
	SetPlayerChatBubble(playerid, szMiscArray, COLOR_PURPLE, 10, 5000);


	return 1;
}

Interact_GivePlayerDrug(playerid, giveplayerid, drugid, saleprice = 0) {

	szMiscArray[0] = 0;

	new amount = GetPVarInt(playerid, "Interact_SellAmt");
	if(amount < 0) return 1;

	if(restarting) return SendClientMessageEx(playerid, COLOR_RED, "Server restart in progress, trading is disabled.");

	if(saleprice != 0 && (GetPlayerCash(giveplayerid) < saleprice || saleprice < 0)) return SendClientMessage(giveplayerid, COLOR_GRAD2, "You do not have enough money");

	if(PlayerInfo[playerid][pDrugs][drugid] < amount) return SendClientMessageEx(playerid, COLOR_WHITE, "You do not have that much.");

	if(amount + PlayerInfo[giveplayerid][pDrugs][drugid] > Player_MaxCapacity(giveplayerid, ITEM_DRUG)) {
		format(szMiscArray, sizeof(szMiscArray), "That player can only hold %d more of that item.", Player_LeftCapacity(giveplayerid, ITEM_DRUG));
		SendClientMessageEx(playerid, COLOR_GRAD2, szMiscArray);
		return Player_InteractMenu(playerid, giveplayerid);
	}

	PlayerInfo[giveplayerid][pDrugs][drugid] += amount;
	PlayerInfo[playerid][pDrugs][drugid] -= amount;
	//PlayerInfo[giveplayerid][pDrugsQuality][drugid] = PlayerInfo[playerid][pDrugsQuality][drugid];

	if(saleprice != 0) {

		GivePlayerCash(playerid, saleprice);
		GivePlayerCash(giveplayerid, -saleprice);

		//TurfWars_TurfTax(giveplayerid, Drugs[drugid], saleprice);
		ExtortionTurfsWarsZone(playerid, 1, saleprice);

		format(szMiscArray, sizeof(szMiscArray), "You have sold %s %dg of %s for $%s", GetPlayerNameEx(giveplayerid), amount, Drugs[drugid], number_format(saleprice));
		SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);

		format(szMiscArray, sizeof(szMiscArray), "%s has sold you %dg of %s for $%s", GetPlayerNameEx(playerid), amount, Drugs[drugid], number_format(saleprice));
		SendClientMessageEx(giveplayerid, COLOR_WHITE, szMiscArray);

		format(szMiscArray, sizeof(szMiscArray), "%s(%d) (IP:%s) has sold %dg of %s for $%s to %s(%d) (IP:%s)", GetPlayerNameEx(playerid), PlayerInfo[playerid][pId], PlayerInfo[playerid][pIP], amount, Drugs[drugid], number_format(saleprice), GetPlayerNameEx(giveplayerid), PlayerInfo[giveplayerid][pId], PlayerInfo[giveplayerid][pIP]);
		Log("logs/pay.log", szMiscArray);

		format(szMiscArray, sizeof(szMiscArray), "sold %dg of %s for $%s.", amount, Drugs[drugid], number_format(saleprice));
		DBLog(playerid, giveplayerid, "ItemTransfer", szMiscArray);
	}
	else {
		format(szMiscArray, sizeof(szMiscArray), "You have given %s %dg of %s", GetPlayerNameEx(giveplayerid), amount, Drugs[drugid]);
		SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);

		format(szMiscArray, sizeof(szMiscArray), "%s has given you %dg of %s", GetPlayerNameEx(playerid), amount, Drugs[drugid]);
		SendClientMessageEx(giveplayerid, COLOR_WHITE, szMiscArray);

		format(szMiscArray, sizeof(szMiscArray), "%s(%d) (IP:%s) has given %dg of %s to %s(%d) (IP:%s)", GetPlayerNameEx(playerid), PlayerInfo[playerid][pId], PlayerInfo[playerid][pIP], amount, Drugs[drugid], GetPlayerNameEx(giveplayerid), PlayerInfo[giveplayerid][pId], PlayerInfo[giveplayerid][pIP]);
		Log("logs/pay.log", szMiscArray);

		format(szMiscArray, sizeof(szMiscArray), "gave %dg of %s.", amount, Drugs[drugid]);
		DBLog(playerid, giveplayerid, "ItemTransfer", szMiscArray);
	}

	format(szMiscArray, sizeof(szMiscArray), "%s gave %s some %s", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), Drugs[drugid]);
	SetPlayerChatBubble(playerid, szMiscArray, COLOR_PURPLE, 10, 5000);
	return 1;
}

Interact_PayPlayer(playerid, giveplayerid, amount = -1) {


	if(amount == -1) {
		format(szMiscArray, sizeof(szMiscArray), "Please enter an amount to give %s.", GetPlayerNameEx(giveplayerid));
		return ShowPlayerDialogEx(playerid, PAY_PLAYER, DIALOG_STYLE_INPUT, "Pay Player", szMiscArray, "Pay", "");
	}
	else {

		if(!(0 < amount <= 250000)) return SendClientMessageEx(playerid, COLOR_WHITE, "Maximum amount is $250,000, minimum is $1");
		if (!ProxDetectorS(8.0, playerid, giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "That player is not near you.");

		if(PlayerInfo[playerid][pCash] < amount) return SendClientMessageEx(playerid, COLOR_GRAD1, "You do not have enough on you.");

		format(szMiscArray, sizeof(szMiscArray), "You have paid %s $%s", GetPlayerNameEx(giveplayerid), number_format(amount));
		SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
		format(szMiscArray, sizeof(szMiscArray), "You have been paid $%s by %s", number_format(amount), GetPlayerNameEx(playerid));
		SendClientMessageEx(giveplayerid, COLOR_WHITE, szMiscArray);

		GivePlayerCash(playerid, -amount);
		GivePlayerCash(giveplayerid, amount);

		format(szMiscArray, sizeof(szMiscArray), "%s(%d) (IP:%s) has paid %s to %s(%d) (IP:%s)", GetPlayerNameEx(playerid), PlayerInfo[playerid][pId], PlayerInfo[playerid][pIP], number_format(amount), GetPlayerNameEx(giveplayerid), PlayerInfo[giveplayerid][pId], PlayerInfo[giveplayerid][pIP]);
		Log("logs/pay.log", szMiscArray);
		format(szMiscArray, sizeof(szMiscArray), "has been paid $%s", number_format(amount));
		DBLog(playerid, giveplayerid, "Pay_Log", szMiscArray);
	}
	return 1;
}

Interact_CuffPlayer(playerid, giveplayerid) {
	if(GetPVarInt(playerid, "Injured") == 1 || PlayerCuffed[ playerid ] >= 1 || PlayerInfo[ playerid ][ pJailTime ] > 0 || PlayerInfo[playerid][pHospital] > 0)
		return SendClientMessageEx(playerid, COLOR_GREY, "You can't do this right now.");

	if(PlayerInfo[playerid][pHasCuff] < 1) return SendClientMessageEx(playerid, COLOR_WHITE, "You do not have any pair of cuffs on you!");

	new Float:health, Float:armor;
	if(!IsPlayerConnected(giveplayerid))
	if (!ProxDetectorS(8.0, playerid, giveplayerid))
	if(GetPVarInt(giveplayerid, "Injured") == 1) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot cuff someone in a injured state.");
	if(PlayerCuffed[giveplayerid] != 1 && GetPlayerSpecialAction(giveplayerid) != SPECIAL_ACTION_HANDSUP) return SendClientMessage(playerid, COLOR_WHITE, "That player is not restrained");

	if(PlayerInfo[giveplayerid][pConnectHours] < 32) SendClientMessageEx(giveplayerid, COLOR_WHITE, "If you logout now you will automatically be prisoned for 2+ hours!");

	format(szMiscArray, sizeof(szMiscArray), "* You have been handcuffed by %s.", GetPlayerNameEx(playerid));
	SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, szMiscArray);
	format(szMiscArray, sizeof(szMiscArray), "* You handcuffed %s, till uncuff.", GetPlayerNameEx(giveplayerid));
	SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMiscArray);
	format(szMiscArray, sizeof(szMiscArray), "* %s handcuffs %s, tightening the cuffs securely.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
	ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	GameTextForPlayer(giveplayerid, "~r~Cuffed", 2500, 3);
	TogglePlayerControllable(giveplayerid, 0);
	ClearAnimationsEx(giveplayerid);
	GetHealth(giveplayerid, health);
	GetArmour(giveplayerid, armor);
	SetPVarFloat(giveplayerid, "cuffhealth",health);
	SetPVarFloat(giveplayerid, "cuffarmor",armor);
	SetPlayerSpecialAction(giveplayerid, SPECIAL_ACTION_CUFFED);
	ApplyAnimation(giveplayerid,"ped","cower",1,1,0,0,0,0,1);
	PlayerCuffed[giveplayerid] = 2;
	SetPVarInt(giveplayerid, "PlayerCuffed", 2);
	SetPVarInt(giveplayerid, "IsFrozen", 1);
	//Frozen[giveplayerid] = 1;
	PlayerCuffedTime[giveplayerid] = 60;

	if(GetPVarType(giveplayerid, "IsTackled")) {
	    format(szMiscArray, sizeof(szMiscArray), "* %s removes a set of cuffs from his belt and attempts to cuff %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
		ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		SetTimerEx("CuffTackled", 4000, 0, "ii", playerid, giveplayerid);
	}
	return 1;
}

Interact_UncuffPlayer(playerid, giveplayerid) {

	if (!ProxDetectorS(8.0, playerid, giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "That player is not near you.");
	if(PlayerCuffed[giveplayerid]>1) {

		DeletePVar(giveplayerid, "IsFrozen");
		format(szMiscArray, sizeof(szMiscArray), "* You have been uncuffed by %s.", GetPlayerNameEx(playerid));
		SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, szMiscArray);
		format(szMiscArray, sizeof(szMiscArray), "* You uncuffed %s.", GetPlayerNameEx(giveplayerid));
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMiscArray);
		format(szMiscArray, sizeof(szMiscArray), "* %s has uncuffed %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
		ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		GameTextForPlayer(giveplayerid, "~g~Uncuffed", 2500, 3);
		TogglePlayerControllable(giveplayerid, 1);
		ClearAnimationsEx(giveplayerid);
		SetPlayerSpecialAction(giveplayerid, SPECIAL_ACTION_NONE);
		PlayerCuffed[giveplayerid] = 0;
        PlayerCuffedTime[giveplayerid] = 0;
        SetHealth(giveplayerid, GetPVarFloat(giveplayerid, "cuffhealth"));
        SetArmour(giveplayerid, GetPVarFloat(giveplayerid, "cuffarmor"));
        DeletePVar(giveplayerid, "cuffhealth");
		DeletePVar(giveplayerid, "PlayerCuffed");
		DeletePVar(giveplayerid, "jailcuffs");
	}
	else if(GetPVarInt(giveplayerid, "jailcuffs") == 1) {
		DeletePVar(giveplayerid, "IsFrozen");
		format(szMiscArray, sizeof(szMiscArray), "* You have been uncuffed by %s.", GetPlayerNameEx(playerid));
		SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, szMiscArray);
		format(szMiscArray, sizeof(szMiscArray), "* You uncuffed %s.", GetPlayerNameEx(giveplayerid));
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMiscArray);
		format(szMiscArray, sizeof(szMiscArray), "* %s has uncuffed %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
		ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		GameTextForPlayer(giveplayerid, "~g~Uncuffed", 2500, 3);
		ClearAnimationsEx(giveplayerid);
		SetPlayerSpecialAction(giveplayerid, SPECIAL_ACTION_NONE);
		DeletePVar(giveplayerid, "jailcuffs");
	}
	return 1;
}

/*Interact_DrugTest(playerid, giveplayerid) {

	new szTitle[128];

	format(szTitle, sizeof(szTitle), "_______ %s's Drug Test _______", GetPlayerNameEx(giveplayerid));

	szMiscArray = "Name\tLevel (CT)\n";

	for(new i; i < sizeof(Drugs); ++i) {

		if(PlayerInfo[giveplayerid][pDrugsTaken][i] > 0) format(szMiscArray, sizeof(szMiscArray), "%s%s \t Level: %d CT\n", szMiscArray, Drugs[i], PlayerInfo[giveplayerid][pDrugsTaken][i]);
		else format(szMiscArray, sizeof(szMiscArray), "%s%s \t Level: None\n", szMiscArray, Drugs[i]);
	}
	strcat(szMiscArray, "________________________________", sizeof(szMiscArray));

	ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_TABLIST_HEADERS, szTitle, szMiscArray, "<<", "");

	format(szMiscArray, sizeof(szMiscArray), "** %s has conducted a drug test on %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
	ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	return 1;
	return SendClientMessage(playerid, COLOR_WHITE, "This feature has been removed.");
}*/

Interact_TakeDrugs(playerid, giveplayerid) {

	for(new i; i < sizeof(Drugs); ++i) {

		PlayerInfo[giveplayerid][pDrugs][i] = 0;
		PlayerInfo[giveplayerid][pBDrugs][i] = 0;
	}

	format(szMiscArray, sizeof(szMiscArray), "** %s has confiscated %s's drugs.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
	ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	return 1;
}

Interact_ShowLicenses(playerid, giveplayerid) {

	if (!ProxDetectorS(8.0, playerid, giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "That player is not near you.");
	new text1[40], text2[20], text3[20], text4[20], text5[40];
	if(PlayerInfo[playerid][pCarLic] == 0) { text1 = "Not acquired"; }
	else { text1 = date(PlayerInfo[playerid][pCarLic], 1); }
	if(PlayerInfo[playerid][pFlyLic]) { text4 = "Acquired"; } else { text4 = "Not acquired"; }
	if(PlayerInfo[playerid][pBoatLic]) { text2 = "Acquired"; } else { text2 = "Not acquired"; }
	if(PlayerInfo[playerid][pTaxiLicense]) { text3 = "Acquired"; } else { text3 = "Not acquired"; }
	if(PlayerInfo[playerid][pGunLic] == 0) {text5 = "Not acquired"; }
	else {text5 = date(PlayerInfo[playerid][pGunLic], 1);}

	switch(PlayerInfo[playerid][pNation]) {
		case 0: SendClientMessageEx(giveplayerid, COLOR_WHITE, "** Citizen of San Andreas **");
		case 1: SendClientMessageEx(giveplayerid, COLOR_TR, "** Citizen of New Robada **");
		case 2: SendClientMessageEx(giveplayerid, COLOR_TR, "** No citizenship **");
	}
	format(szMiscArray, sizeof(szMiscArray), "Listing %s's licenses...", GetPlayerNameEx(playerid));
	SendClientMessageEx(giveplayerid, COLOR_WHITE, szMiscArray);
	format(szMiscArray, sizeof(szMiscArray), "Date of Birth: %s", PlayerInfo[playerid][pBirthDate]);
	SendClientMessageEx(giveplayerid, COLOR_WHITE, szMiscArray);
	format(szMiscArray, sizeof(szMiscArray), "** Driver's license: %s.", text1);
	SendClientMessageEx(giveplayerid, COLOR_GREY, szMiscArray);
	format(szMiscArray, sizeof(szMiscArray), "** Pilot license: %s.", text4);
	SendClientMessageEx(giveplayerid, COLOR_GREY, szMiscArray);
	format(szMiscArray, sizeof(szMiscArray), "** Boating license: %s.", text2);
	SendClientMessageEx(giveplayerid, COLOR_GREY, szMiscArray);
	format(szMiscArray, sizeof(szMiscArray), "** Taxi license: %s.", text3);
	SendClientMessageEx(giveplayerid, COLOR_GREY, szMiscArray);
	format(szMiscArray, sizeof(szMiscArray), "** SA Firearm license: %s.", text5);
	SendClientMessageEx(giveplayerid, COLOR_GREY, szMiscArray);
	format(szMiscArray, sizeof(szMiscArray), "* %s has shown their licenses to you.", GetPlayerNameEx(playerid));
	SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, szMiscArray);
	format(szMiscArray, sizeof(szMiscArray), "* You have shown your licenses to %s.", GetPlayerNameEx(giveplayerid));
	SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMiscArray);
	return 1;
}

Interact_FriskPlayer(playerid, giveplayerid) {

	if (!ProxDetectorS(8.0, playerid, giveplayerid)) return SendClientMessageEx(playerid, COLOR_WHITE, "You are not in range of that player");
	if(giveplayerid == playerid) { SendClientMessageEx(playerid, COLOR_GREY, "You cannot frisk yourself!"); return 1; }

	new packages = GetPVarInt(giveplayerid, "Packages");
	new crates = PlayerInfo[giveplayerid][pCrates];
	SendClientMessageEx(playerid, COLOR_GREEN, "_______________________________________");
	format(szMiscArray, sizeof(szMiscArray), "Listing pocket for %s.", GetPlayerNameEx(giveplayerid));
	SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
	SendClientMessageEx(playerid, COLOR_WHITE, "** Items **");
	if(PlayerInfo[giveplayerid][pMats] > 0)
	{
		format(szMiscArray, sizeof(szMiscArray), "(Pocket) %d materials.", PlayerInfo[giveplayerid][pMats]);
		SendClientMessageEx(playerid, COLOR_GREY, szMiscArray);
	}
	if(PlayerInfo[giveplayerid][pSyringes] > 0)
	{
		format(szMiscArray, sizeof(szMiscArray), "(Pocket) %d syringes.", PlayerInfo[giveplayerid][pSyringes]);
		SendClientMessageEx(playerid, COLOR_GREY, szMiscArray);
	}
    if(packages > 0)
	{
		format(szMiscArray, sizeof(szMiscArray), "(Pocket) %d material packages.", packages);
		SendClientMessageEx(playerid, COLOR_GREY, szMiscArray);
	}
	if(crates > 0)
	{
		format(szMiscArray, sizeof(szMiscArray), "(Pocket) %d drug crates.", crates);
		SendClientMessageEx(playerid, COLOR_GREY, szMiscArray);
	}

	SendClientMessageEx(playerid, COLOR_WHITE, "** Drugs **");
	for(new i = 0; i < sizeof(Drugs); i++) {

		if(PlayerInfo[giveplayerid][pDrugs][i] > 0) {
			format(szMiscArray, sizeof(szMiscArray), "%s: %dg", Drugs[i], PlayerInfo[giveplayerid][pDrugs][i]);
			SendClientMessageEx(playerid, COLOR_GRAD1, szMiscArray);
		}
	}

	if(Fishes[giveplayerid][pWeight1] > 0 || Fishes[giveplayerid][pWeight2] > 0 || Fishes[giveplayerid][pWeight3] > 0 || Fishes[giveplayerid][pWeight4] > 0 || Fishes[giveplayerid][pWeight5] > 0)
	{
		format(szMiscArray, sizeof(szMiscArray), "(Pocket) %d fish.", PlayerInfo[giveplayerid][pFishes]);
		SendClientMessageEx(playerid, COLOR_GREY, szMiscArray);
	}
	SendClientMessageEx(playerid, COLOR_WHITE, "** Misc **");
	if(PlayerInfo[giveplayerid][pPhoneBook] > 0) SendClientMessageEx(playerid, COLOR_GREY, "Phone book.");
	if(PlayerInfo[giveplayerid][pCDPlayer] > 0) SendClientMessageEx(playerid, COLOR_GREY, "Music player.");
	new weaponname[50];
	SendClientMessageEx(playerid, COLOR_WHITE, "** Weapons **");
	for (new i = 0; i < 12; i++)
	{
		if(PlayerInfo[giveplayerid][pGuns][i] > 0)
		{
			GetWeaponName(PlayerInfo[giveplayerid][pGuns][i], weaponname, sizeof(weaponname));
			format(szMiscArray, sizeof(szMiscArray), "Weapon: %s.", weaponname);
			SendClientMessageEx(playerid, COLOR_GRAD1, szMiscArray);
		}
	}
	SendClientMessageEx(playerid, COLOR_GREEN, "_______________________________________");

	format(szMiscArray, sizeof(szMiscArray), "* %s has frisked %s for any illegal items.", GetPlayerNameEx(playerid),GetPlayerNameEx(giveplayerid));
	ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	return 1;

}

Interact_DragPlayer(playerid, giveplayerid) {

	if(GetPVarInt(giveplayerid, "PlayerCuffed") != 2) return SendClientMessageEx(playerid, COLOR_WHITE, " The specified person is not cuffed !");

	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_WHITE, " You must be out of the vehicle to use this command.");
	if(GetPVarInt(giveplayerid, "BeingDragged") == 1) return SendClientMessageEx(playerid, COLOR_WHITE, " That person is already being dragged. ");

    new
    	Float:TempPos[3];

	GetPlayerPos(giveplayerid, TempPos[0], TempPos[1], TempPos[2]);
	if(!IsPlayerInRangeOfPoint(playerid, 5.0, TempPos[0], TempPos[1], TempPos[2])) return SendClientMessageEx(playerid, COLOR_GRAD2, " That suspect is not near you.");

	format(szMiscArray, sizeof(szMiscArray), "* %s is now dragging you.", GetPlayerNameEx(playerid));
	SendClientMessageEx(giveplayerid, COLOR_WHITE, szMiscArray);

	format(szMiscArray, sizeof(szMiscArray), "* You are now dragging %s, you may move them now.", GetPlayerNameEx(giveplayerid));
	SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);

	format(szMiscArray, sizeof(szMiscArray), "* %s grabs ahold of %s and begins to move them.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
	ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

	SendClientMessageEx(playerid, COLOR_WHITE, "You are now dragging the suspect, press the '{AA3333}FIRE{FFFFFF}' button to stop.");

	SetPVarInt(giveplayerid, "BeingDragged", 1);
	SetPVarInt(playerid, "DraggingPlayer", giveplayerid);
	SetTimerEx("DragPlayer", 1000, 0, "ii", playerid, giveplayerid);

	return 1;
}

Interact_DetainPlayer(playerid, giveplayerid, seatid = -1) {

	if(seatid == -1) {
		format(szMiscArray, sizeof(szMiscArray), "Please enter a seat id (1-3) to detain %s into.", GetPlayerNameEx(giveplayerid));
		return ShowPlayerDialogEx(playerid, DETAIN_SEAT, DIALOG_STYLE_INPUT, "Detain Player", szMiscArray, "Detain", "");
	}
	else {
		if(IsPlayerInAnyVehicle(giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "That person is in a car - get them out first.");
		if (!ProxDetectorS(8.0, playerid, giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You are not in range of that player!");
		if(PlayerCuffed[giveplayerid] != 2) return SendClientMessageEx(playerid, COLOR_GREY, "That player is not cuffed");

		new carid = gLastCar[playerid];
		if(!IsSeatAvailable(carid, seatid)) {
			SendClientMessageEx(playerid, COLOR_GREY, "That seatid is taken!");
			return Interact_DetainPlayer(playerid, giveplayerid);
		}

		new Float:pos[6];
		GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
		GetPlayerPos(giveplayerid, pos[3], pos[4], pos[5]);
		GetVehiclePos( carid, pos[0], pos[1], pos[2]);
		if (floatcmp(floatabs(floatsub(pos[0], pos[3])), 10.0) != -1 &&
				floatcmp(floatabs(floatsub(pos[1], pos[4])), 10.0) != -1 &&
				floatcmp(floatabs(floatsub(pos[2], pos[5])), 10.0) != -1) return false;
		format(szMiscArray, sizeof(szMiscArray), "* You were detained by %s .", GetPlayerNameEx(playerid));
		SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, szMiscArray);
		format(szMiscArray, sizeof(szMiscArray), "* You detained %s.", GetPlayerNameEx(giveplayerid));
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMiscArray);
		format(szMiscArray, sizeof(szMiscArray), "* %s throws %s in the vehicle.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
		ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		GameTextForPlayer(giveplayerid, "~r~Detained", 2500, 3);
		ClearAnimationsEx(giveplayerid);
		TogglePlayerControllable(giveplayerid, false);
		IsPlayerEntering{giveplayerid} = true;
		PutPlayerInVehicle(giveplayerid, carid, seatid);
	}
	return 1;
}

Interact_GiveTicket(playerid, giveplayerid, reason[], amount = -1) {
	if(amount == -1) {
		format(szMiscArray, sizeof(szMiscArray), "Please enter an amount to fine %s", GetPlayerNameEx(giveplayerid));
		return ShowPlayerDialogEx(playerid, GIVE_TICKET, DIALOG_STYLE_INPUT, "Ticket Player", szMiscArray, "Next", "");
	}
	if(isnull(reason)) {
		format(szMiscArray, sizeof(szMiscArray), "Please enter a fine reason for %s", GetPlayerNameEx(giveplayerid));
		return ShowPlayerDialogEx(playerid, TICKET_REASON, DIALOG_STYLE_INPUT, "Ticket Player", szMiscArray, "Issue", "");
	}
	else {
		if(!ProxDetectorS(8.0, playerid, giveplayerid)) return SendClientMessageEx(playerid, COLOR_GRAD2, "You are not in range of that player");

		format(szMiscArray, sizeof(szMiscArray), "* You gave %s a ticket costing $%d, reason: %s", GetPlayerNameEx(giveplayerid), amount, reason);
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMiscArray);
		format(szMiscArray, sizeof(szMiscArray), "* Officer %s has given you a ticket costing $%d, reason: %s", GetPlayerNameEx(playerid), amount, reason);
		SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, szMiscArray);
		format(szMiscArray, sizeof(szMiscArray), "* Officer %s writes up a ticket and gives it to %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
		ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, "* Type /accept ticket, to accept it.");
		TicketOffer[giveplayerid] = playerid;
		TicketMoney[giveplayerid] = amount;
	}
	return 1;
}

Interact_LoadPatient(playerid, giveplayerid, seatid = -1) {

	if(seatid == -1) {
		format(szMiscArray, sizeof(szMiscArray), "Please enter a seat id (1-3) to load %s into.", GetPlayerNameEx(giveplayerid));
		return ShowPlayerDialogEx(playerid, PATIENT_SEAT, DIALOG_STYLE_INPUT, "Load Patient", szMiscArray, "Load", "");
	}
	else {
		if(GetPVarInt(giveplayerid, "Injured") != 1) return SendClientMessageEx(playerid, COLOR_GREY, "That patient not injured - you can't load them.");
        if(IsPlayerInAnyVehicle(giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "That patient is inside a car - you can't load them.");
        if (!ProxDetectorS(8.0, playerid, giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You are not near that player.");

        new carid = gLastCar[playerid];
        if(!IsAnAmbulance(carid)) return SendClientMessageEx(playerid, COLOR_GREY, "Your last vehicle was not an ambulance.");
        if(IsVehicleOccupied(carid, seatid)) return SendClientMessageEx(playerid, COLOR_GREY, "That seat is occupied.");
		if(!IsPlayerInRangeOfVehicle(giveplayerid, carid, 10.0) || !IsPlayerInRangeOfVehicle(playerid, carid, 10.0)) return SendClientMessageEx(playerid, COLOR_GREY, "Both you and your patient must be near the ambulance.");

		format(szMiscArray, sizeof(szMiscArray), "* You were loaded by paramedic %s.", GetPlayerNameEx(playerid));
		SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, szMiscArray);
		format(szMiscArray, sizeof(szMiscArray), "* You loaded patient %s.", GetPlayerNameEx(giveplayerid));
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMiscArray);
		format(szMiscArray, sizeof(szMiscArray), "* %s loads %s in the %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), GetVehicleName(carid));
		ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		SetPVarInt(giveplayerid, "EMSAttempt", 3);
		ClearAnimationsEx(giveplayerid);
		IsPlayerEntering{giveplayerid} = true;
		PutPlayerInVehicle(giveplayerid,carid,seatid);
		TogglePlayerControllable(giveplayerid, false);
	}
	return 1;
}

Interact_Triage(playerid, giveplayerid) {
	if(PlayerInfo[playerid][pTriageTime] != 0)	return SendClientMessageEx(playerid, COLOR_GREY, "You must wait for 2 minutes to use this command.");
	if(!IsPlayerConnected(giveplayerid)) return SendClientMessageEx(playerid, COLOR_GRAD2, "That player is not connected.");
    if(!ProxDetectorS(5.0, playerid, giveplayerid)) return SendClientMessageEx(playerid, COLOR_GRAD2, "That player isn't near you!");

    new Float: health;
    GetHealth(giveplayerid, health);
    if(health >= 85) SetHealth(giveplayerid, 100);
	else SetHealth(giveplayerid, health+15.0);
    format(szMiscArray, sizeof(szMiscArray), "* %s has given %s 15 health.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
    ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	PlayerInfo[playerid][pTriageTime] = 120;
	return 1;
}

Interact_Heal(playerid, giveplayerid, healprice = -1) {

	if(healprice == -1) {
		format(szMiscArray, sizeof(szMiscArray), "Please enter a price that you wish to heal %d for.", GetPlayerNameEx(giveplayerid));
		return ShowPlayerDialogEx(playerid, HEAL_PLAYER, DIALOG_STYLE_INPUT, "Heal Player", szMiscArray, "Heal", "");
	}
	else {
		new Float:X, Float:Y, Float:Z;
		GetPlayerPos(giveplayerid, X, Y, Z);

		if(!IsPlayerInRangeOfPoint(playerid, 10, X, Y, Z)) return SendClientMessageEx(playerid, TEAM_GREEN_COLOR,"You are not near them!");

		new Float:tempheal;
		GetHealth(giveplayerid,tempheal);
		if(tempheal >= 100.0) return SendClientMessageEx(playerid, TEAM_GREEN_COLOR,"That person is fully healed.");

		format(szMiscArray, sizeof(szMiscArray), "You healed %s for $%d.", GetPlayerNameEx(giveplayerid),healprice);
		SendClientMessageEx(playerid, COLOR_PINK, szMiscArray);
		GivePlayerCash(playerid, healprice / 2);

		//Tax += healprice / 2;

		GivePlayerCash(giveplayerid, -healprice);
		SetHealth(giveplayerid, 100);

		PlayerPlaySound(playerid, 1150, 0.0, 0.0, 0.0);
		PlayerPlaySound(giveplayerid, 1150, 0.0, 0.0, 0.0);

		format(szMiscArray, sizeof(szMiscArray), "You have been healed to 100 health for $%d by %s.",healprice, GetPlayerNameEx(playerid));
		SendClientMessageEx(giveplayerid, TEAM_GREEN_COLOR,szMiscArray);

		if(GetPVarType(giveplayerid, "STD")){
			DeletePVar(giveplayerid, "STD");
			SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, "* You are no longer infected with a STD because of the medic's help.");
		}
	}
	return 1;
}

Interact_MovePatient(playerid, giveplayerid) {

	if(GetPVarInt(giveplayerid,"Injured") != 1) return SendClientMessageEx(playerid, COLOR_WHITE, "That player is not injured");

	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can't use this command while in a vehicle.");
	if(PlayerInfo[giveplayerid][pJailTime] > 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can't use this command on jailed players.");
	if(GetPVarInt(giveplayerid, "OnStretcher") == 1) return SendClientMessageEx(playerid, COLOR_GRAD2, "The person is already on a stretcher, you can't do this right now!");

	new Float:mX, Float:mY, Float:mZ;
	GetPlayerPos(giveplayerid, mX, mY, mZ);
	if(!IsPlayerInRangeOfPoint(playerid, 5.0, mX, mY, mZ)) return SendClientMessageEx(playerid, COLOR_GRAD2, "You have to be close to the patient to be able to move them!");

	SendClientMessageEx(playerid, COLOR_GRAD2, "You have 30 seconds to move to another location or you can either press the '{AA3333}FIRE{BFC0C2}' button.");
	format(szMiscArray, sizeof(szMiscArray), "* You have been put on a stretcher by %s.", GetPlayerNameEx(playerid));

	SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, szMiscArray);
	format(szMiscArray, sizeof(szMiscArray), "* You have put %s on a stretcher, you may move them now.", GetPlayerNameEx(giveplayerid));

	SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMiscArray);
	format(szMiscArray, sizeof(szMiscArray), "* %s puts %s on a stretcher, tightening the belts securely.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));

	ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

	SetPVarInt(giveplayerid, "OnStretcher", 1);
	SetPVarInt(playerid, "TickEMSMove", SetTimerEx("MoveEMS", 30000, false, "d", playerid));
	SetPVarInt(playerid, "MovingStretcher", giveplayerid);
	return 1;
}

Interact_Prescribe(playerid, stage = 0) {

	switch(stage) {

		case 0: {

			ShowPlayerDialogEx(playerid, DIALOG_STYLE_LIST, INTERACT_PRESCRIBE, "Type | Drug Prescription", "Demerol\n\
				Morphine\n\
				Haloperidol\n\
				Aspirin",
				"Select", "Cancel");
		}
		case 1: {

			ShowPlayerDialogEx(playerid, DIALOG_STYLE_INPUT, INTERACT_PRESCRIBE1, "Grams | Drug Prescription", "How many pieces would you like to prescribe?", "Prescribe", "Cancel");
		}
	}
	return 1;
}

Interact_ProcessPrescription(playerid) {

	new giveplayerid = GetPVarInt(playerid, "Interact_Target"),
		iAmount = GetPVarInt(playerid, "DR_PAM");

	GetPVarString(playerid, "DR_PTYPE", szMiscArray, sizeof(szMiscArray));
	new iDrugID = GetDrugID(szMiscArray);

	if(iAmount + PlayerInfo[giveplayerid][pDrugs][iDrugID] > Player_MaxCapacity(giveplayerid, ITEM_DRUG)) {
		format(szMiscArray, sizeof(szMiscArray), "That player can only hold %d more of that item.", Player_LeftCapacity(giveplayerid, ITEM_DRUG));
		SendClientMessageEx(playerid, COLOR_GRAD2, szMiscArray);
		return Player_InteractMenu(playerid, giveplayerid);
	}

	if(PlayerInfo[playerid][pDrugs][iDrugID] < iAmount) return SendClientMessage(playerid, COLOR_GRAD1, "You do not have enough of that on you.");
	format(szMiscArray, sizeof(szMiscArray), "You have prescribed %s %d pc of %s.", GetPlayerNameEx(giveplayerid), iAmount, szMiscArray);
	SendClientMessage(playerid, COLOR_GRAD2, szMiscArray);
	format(szMiscArray, sizeof(szMiscArray), "%s has prescribed you %d pc of %s.", GetPlayerNameEx(playerid), iAmount, szMiscArray);
	SendClientMessage(giveplayerid, COLOR_GRAD2, szMiscArray);
	PlayerInfo[playerid][pDrugs][iDrugID] += iAmount;
	return 1;
}

/*
	Concept is to introduce the ability to pickup items that have been dropped and have a player add it to their inventory.
	Also to centralize all posessions into a single dialog.
*/

/*Player_InventoryMenu(playerid) {

	return 1;
}

Player_InventoryAction(playerid) {

	return 1;
}

Player_DropItem(playerid) {

	return 1;
}*/

CMD:interact(playerid, params[]) {


	if(isnull(params)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /interact [playerid]");

	new giveplayerid = strval(params);
	if(playerid == giveplayerid) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot interact with yourself.");
	if(giveplayerid == INVALID_PLAYER_ID) return SendClientMessageEx(playerid, COLOR_GREY, "This player isn't online.");
	if(GetPVarInt(playerid, "Injured") == 1) return 1;
	if(!ProxDetectorS(8.0, playerid, giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "That player is not near you.");
	if(PlayerInfo[giveplayerid][pAdmin] >= 2 && !PlayerInfo[giveplayerid][pTogReports]) return SendClientMessageEx(playerid, COLOR_GREY, "That player is not near you.");
	Player_InteractMenu(playerid, giveplayerid);
	return 1;
}