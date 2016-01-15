/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Storage System

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

stock ShowStorageEquipDialog(playerid)
{
	if(gPlayerLogged{playerid} != 1) return SendClientMessageEx(playerid, COLOR_WHITE, "You are not logged in!");

	new dialogstring[256];
	new epstring[][] = { "Unequipped", "Equipped", "Not Owned" };

	for(new i = 0; i < 3; i++)
	{
		format(dialogstring, sizeof(dialogstring), "%s%s", dialogstring, storagetype[i+1]);
		if(StorageInfo[playerid][i][sStorage] != 1) format(dialogstring, sizeof(dialogstring), "%s (%s)\n", dialogstring, epstring[2]);
		else format(dialogstring, sizeof(dialogstring), "%s (%s)\n", dialogstring, epstring[StorageInfo[playerid][i][sAttached]]);
	}

	ShowPlayerDialogEx(playerid, STORAGEEQUIP, DIALOG_STYLE_LIST, "Storage - Equip/Unequip", dialogstring, "Select", "Exit");
	return 1;
}

/*stock ShowStorageDialog(playerid, fromplayerid, fromstorageid, itemid, amount, price, special)
{
	new titlestring[128], dialogstring[512];

	SetPVarInt(playerid, "Storage_transaction", 1); // Prevent double transactions.
	SetPVarInt(playerid, "Storage_fromplayerid", fromplayerid);
	SetPVarInt(playerid, "Storage_fromstorageid", fromstorageid);
	SetPVarInt(playerid, "Storage_itemid", itemid);
	SetPVarInt(playerid, "Storage_amount", amount);
	SetPVarInt(playerid, "Storage_price", price);
	SetPVarInt(playerid, "Storage_special", special);

	if(price == -1) format(titlestring, sizeof(titlestring), "Where do you want to store %d %s?", amount, itemtype[itemid]);
	else format(titlestring, sizeof(titlestring), "You are buying %d %s for %d", amount, itemtype[itemid], price);

	switch(itemid)
	{
		case 1:
		{
			format(dialogstring, sizeof(dialogstring), "Hand/Pocket - ($%d)\n", PlayerInfo[playerid][pCash]);
			for(new i = 0; i < 3; i++)
			{
				if(StorageInfo[playerid][i][sAttached] == 1)
				{
					format(dialogstring, sizeof(dialogstring), "%s(%s) - ($%d/$%d)\n", dialogstring, storagetype[i+1], StorageInfo[playerid][i][sCash], limits[i+1][0]);
				}
			}

			//format(dialogstring, sizeof(dialogstring), "Hand/Pocket - ($%d)\nBag - ($%d/$%d)\nBackpack - ($%d/$%d)\nBriefcase - ($%d/$%d)",
				//PlayerInfo[playerid][pCash],
				//StorageInfo[playerid][0][sCash],
				//bbackpacklimit[itemid-1],
				//StorageInfo[playerid][1][sCash],
				//backpacklimit[itemid-1],
				//StorageInfo[playerid][2][sCash],
				//briefcaselimit[itemid-1]
			//);
		}
		case 2:
		{
			format(dialogstring, sizeof(dialogstring), "Hand/Pocket - (%d)\n", PlayerInfo[playerid][pPot]);
			for(new i = 0; i < 3; i++)
			{
				if(StorageInfo[playerid][i][sAttached] == 1)
				{
					format(dialogstring, sizeof(dialogstring), "%s(%s) - (%d/%d)\n", dialogstring, storagetype[i+1], StorageInfo[playerid][i][sPot], limits[i+1][0]);
				}
			}

			//format(dialogstring, sizeof(dialogstring), "Hand/Pocket - (%d/%d)\nBag - (%d/%d)\nBackpack - (%d/%d)\nBriefcase - (%d/%d)",
				//PlayerInfo[playerid][pPot],
				//onhandlimit[itemid-1],
				//StorageInfo[playerid][0][sPot],
				//bbackpacklimit[itemid-1],
				//StorageInfo[playerid][1][sPot],
				//backpacklimit[itemid-1],
				//StorageInfo[playerid][2][sPot],
				//briefcaselimit[itemid-1]
			//);
		}
		case 3:
		{
			format(dialogstring, sizeof(dialogstring), "Hand/Pocket - ($%d)\n", PlayerInfo[playerid][pCrack]);
			for(new i = 0; i < 3; i++)
			{
				if(StorageInfo[playerid][i][sAttached] == 1)
				{
					format(dialogstring, sizeof(dialogstring), "%s(%s) - (%d/%d)\n", dialogstring, storagetype[i+1], StorageInfo[playerid][i][sCrack], limits[i+1][0]);
				}
			}

			//format(dialogstring, sizeof(dialogstring), "Hand/Pocket - (%d/%d)\nBag - (%d/%d)\nBackpack - (%d/%d)\nBriefcase - (%d/%d)",
				//PlayerInfo[playerid][pCrack],
				//onhandlimit[itemid-1],
				//StorageInfo[playerid][0][sCrack],
				//bbackpacklimit[itemid-1],
				//StorageInfo[playerid][1][sCrack],
				//backpacklimit[itemid-1],
				//StorageInfo[playerid][2][sCrack],
				//briefcaselimit[itemid-1]
			//);
		}
		case 4:
		{
			format(dialogstring, sizeof(dialogstring), "Hand/Pocket - (%d)\n", PlayerInfo[playerid][pMats]);
			for(new i = 0; i < 3; i++)
			{
				if(StorageInfo[playerid][i][sAttached] == 1)
				{
					format(dialogstring, sizeof(dialogstring), "%s(%s) - (%d/%d)\n", dialogstring, storagetype[i+1], StorageInfo[playerid][i][sMats], limits[i+1][3]);
				}
			}

			//format(dialogstring, sizeof(dialogstring), "Hand/Pocket - (%d/%d)\nBag - (%d/%d)\nBackpack - (%d/%d)\nBriefcase - (%d/%d)",
				//PlayerInfo[playerid][pMats],
				//onhandlimit[itemid-1],
				//StorageInfo[playerid][0][sMats],
				//bbackpacklimit[itemid-1],
				//StorageInfo[playerid][1][sMats],
				//backpacklimit[itemid-1],
				//StorageInfo[playerid][2][sMats],
				//briefcaselimit[itemid-1]
			//);
		}
	}

	ShowPlayerDialogEx(playerid, STORAGESTORE, DIALOG_STYLE_LIST, titlestring, dialogstring, "Choose", "Cancel");
}

stock DeathDrop(playerid)
{
	new storageid;
	new bool:itemEquipped = false;
	for(new i = 0; i < 3; i++)
	{
		if(StorageInfo[playerid][i][sAttached] == 1) {
			storageid = i;
			if(storageid != 0) itemEquipped = true; // Bag is exempted from death drops.
		}
	}

	if(itemEquipped == true)
	{

		new rand = random(101);

		switch (PlayerInfo[playerid][pDonateRank])
		{
			case 0: // Normal (50 Percent)
			{
				if(rand > 0 && rand <= 50) {
					StorageInfo[playerid][storageid][sCash] = 0;
					StorageInfo[playerid][storageid][sPot] = 0;
					StorageInfo[playerid][storageid][sCrack] = 0;
					StorageInfo[playerid][storageid][sMats] = 0;

					return SendClientMessageEx(playerid, COLOR_RED, "You have lost all items within your storage device.");
				}
				else return SendClientMessageEx(playerid, COLOR_YELLOW, "Luck is on your side today, you didn't lose any items within your storage device.");
			}
			case 1: // BVIP (40 Percent)
			{
				if(rand > 0 && rand <= 40) {
					StorageInfo[playerid][storageid][sCash] = 0;
					StorageInfo[playerid][storageid][sPot] = 0;
					StorageInfo[playerid][storageid][sCrack] = 0;
					StorageInfo[playerid][storageid][sMats] = 0;

					return SendClientMessageEx(playerid, COLOR_RED, "You have lost all items within your storage device.");
				}
				else return SendClientMessageEx(playerid, COLOR_YELLOW, "Luck is on your side today, you didn't lose any items within your storage device.");
			}
			case 2: // SVIP (30 Percent)
			{
				if(rand > 0 && rand <= 30) {
					StorageInfo[playerid][storageid][sCash] = 0;
					StorageInfo[playerid][storageid][sPot] = 0;
					StorageInfo[playerid][storageid][sCrack] = 0;
					StorageInfo[playerid][storageid][sMats] = 0;

					return SendClientMessageEx(playerid, COLOR_RED, "You have lost all items within your storage device.");
				}
				else return SendClientMessageEx(playerid, COLOR_YELLOW, "Luck is on your side today, you didn't lose any items within your storage device.");
			}
			case 3: // GVIP (20 Percent)
			{
				if(rand > 0 && rand <= 20) {
					StorageInfo[playerid][storageid][sCash] = 0;
					StorageInfo[playerid][storageid][sPot] = 0;
					StorageInfo[playerid][storageid][sCrack] = 0;
					StorageInfo[playerid][storageid][sMats] = 0;

					return SendClientMessageEx(playerid, COLOR_RED, "You have lost all items within your storage device.");
				}
				else return SendClientMessageEx(playerid, COLOR_YELLOW, "Luck is on your side today, you didn't lose any items within your storage device.");
			}
			case 4: // PVIP (No Chance)
			{
				return SendClientMessageEx(playerid, COLOR_YELLOW, "Since you are Platinum VIP, you lose nothing from storage device.");
			}
			case 5: // Moderator (No Chance)
			{
				return SendClientMessageEx(playerid, COLOR_YELLOW, "Since you are (Moderator) Platinum VIP, you lose nothing from storage device.");
			}
		}
	}
	return 1;
}

// Doc Usage:
// playerid - Person Reciving the Item's Amount. (Who is storing the amount)
// storageid - PlayerID's storage index. (Where to store sending amount)
// fromplayerid - Person Giving the Item's Amount. (Notice: Use -1 if from a non-player, script-based etc.).
// fromstorageid - FromStorageID's storage index. (Notice: Use -1 if from a non-player, script-based etc.)
// itemid - ItemID index that is tradeing, used for both. (What is storing)
// amount - The amount of ItemID that is tradeing, used for both. (What amount is storing)
// price - The price of the transaction (in pCash), sent to playerid from sender. (Notice: Use -1 if no price is required)
// special - Set this to 1 if function is being used by skills or other things. (Notice: Use -1 if no special is required)

// ItemIDs:
// 0 - Nothing
// 1 - Cash
// 2 - Pot
// 3 - Crack
// 4 - Materials

// StorageIDs:
// 0 - Pocket/OnHand
// 1 - Bag
// 2 - Backpack
// 3 - Briefcase
*/

stock TransferStorage(playerid, storageid, fromplayerid, fromstorageid, itemid, amount, price, special)
{
	if(playerid == fromplayerid)
	{
		return SendClientMessageEx(playerid, COLOR_WHITE, "ERROR! You cannot transfer from yourself to yourself");
	}

	storageid=0; fromstorageid=0; //temp
	//printf("TransferStorage(playerid=%d, storageid=%d, fromplayerid=%d, fromstorageid=%d, itemid=%d, amount=%d, price=%d, special=%d)", playerid, storageid, fromplayerid, fromstorageid, itemid, amount, price, special);

	if(GetPVarInt(playerid, "Storage_transaction") == 1)
	{
		if(fromplayerid != -1 && fromstorageid != -1) {
			SendClientMessageEx(fromplayerid, COLOR_WHITE, "Player is busy with an existing transaction.");
		}
		return 0;
	}

	new string[128];

	// Disable Prices for Cash Transfers
	if(price != -1 && itemid == 1) price = -1;

	// Ask the player where to store
	if(storageid == -1)
	{
		//UNCOMMENT WHEN RE RELEASE
		//ShowStorageDialog(playerid, fromplayerid, fromstorageid, itemid, amount, price, special);
		return 0;
	}

	// Check if such item is equipped.
	if(storageid > 0 && storageid < 4)
	{
		if(StorageInfo[playerid][storageid-1][sAttached] == 0)
		{
			format(string, sizeof(string), "You don't have the %s equipped!", storagetype[storageid]);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			return 0;
		}
	}

	if(fromplayerid != -1 && fromstorageid != -1)
	{
		if(!IsPlayerConnected(fromplayerid)) return 0;
		if(amount < 0) return 0;

		if(fromstorageid > 0 && fromstorageid < 4)
		{
			if(StorageInfo[fromplayerid][fromstorageid-1][sAttached] == 0)
			{
				format(string, sizeof(string), "You don't have the %s equipped!", storagetype[fromstorageid]);
				SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
				return 0;
			}
		}
	}

    if(special == 1 && itemid == 2) // Pot Special "Selling"
	{
		TurfWars_TurfTax(PotOffer[playerid], "cannabis", PotPrice[playerid]);

        GivePlayerCash(PotOffer[playerid], PotPrice[playerid]);
		GivePlayerCash(playerid, -PotPrice[playerid]);

  		if(PlayerInfo[PotOffer[playerid]][pDoubleEXP] > 0)
		{
			format(string, sizeof(string), "You have gained 2 drug dealer skill points instead of 1. You have %d hours left on the Double EXP token.", PlayerInfo[PotOffer[playerid]][pDoubleEXP]);
			SendClientMessageEx(PotOffer[playerid], COLOR_YELLOW, string);
			PlayerInfo[PotOffer[playerid]][pDrugsSkill] += 2;
		}
		else
		{
			PlayerInfo[PotOffer[playerid]][pDrugsSkill] += 1;
		}

        if(PlayerInfo[PotOffer[playerid]][pDrugsSkill] == 50)
        { SendClientMessageEx(PotOffer[playerid], COLOR_YELLOW, "* Your Drug Dealer Skill is now Level 2, you can buy more Grams and Cheaper."); }
        else if(PlayerInfo[PotOffer[playerid]][pDrugsSkill] == 100)
        { SendClientMessageEx(PotOffer[playerid], COLOR_YELLOW, "* Your Drug Dealer Skill is now Level 3, you can buy more Grams and Cheaper."); }
        else if(PlayerInfo[PotOffer[playerid]][pDrugsSkill] == 200)
        { SendClientMessageEx(PotOffer[playerid], COLOR_YELLOW, "* Your Drug Dealer Skill is now Level 4, you can buy more Grams and Cheaper."); }
        else if(PlayerInfo[PotOffer[playerid]][pDrugsSkill] == 400)
        { SendClientMessageEx(PotOffer[playerid], COLOR_YELLOW, "* Your Drug Dealer Skill is now Level 5, you can buy more Grams and Cheaper."); }
        OnPlayerStatsUpdate(playerid);
        OnPlayerStatsUpdate(PotOffer[playerid]);
		PotOffer[playerid] = INVALID_PLAYER_ID;
		PotStorageID[playerid] = -1;
        PotPrice[playerid] = 0;
        PotGram[playerid] = 0;

	}
	if(special == 1 && itemid == 3) // Crack Special "Selling"
	{
		TurfWars_TurfTax(CrackOffer[playerid], "Crack", CrackPrice[playerid]);

        GivePlayerCash(CrackOffer[playerid], CrackPrice[playerid]);
		GivePlayerCash(playerid, -CrackPrice[playerid]);

		if(PlayerInfo[CrackOffer[playerid]][pDoubleEXP] > 0)
		{
			format(string, sizeof(string), "You have gained 2 drug dealer skill points instead of 1. You have %d hours left on the Double EXP token.", PlayerInfo[CrackOffer[playerid]][pDoubleEXP]);
			SendClientMessageEx(CrackOffer[playerid], COLOR_YELLOW, string);
			PlayerInfo[CrackOffer[playerid]][pDrugsSkill] += 2;
		}
		else
		{
			PlayerInfo[CrackOffer[playerid]][pDrugsSkill] += 1;
		}

        PlayerInfo[playerid][pCrack] += CrackGram[playerid];
        PlayerInfo[CrackOffer[playerid]][pCrack] -= CrackGram[playerid];
        if(PlayerInfo[CrackOffer[playerid]][pDrugsSkill] == 50)
        { SendClientMessageEx(CrackOffer[playerid], COLOR_YELLOW, "* Your Drug Dealer Skill is now Level 2, you can buy more Grams and Cheaper."); }
        else if(PlayerInfo[CrackOffer[playerid]][pDrugsSkill] == 100)
		{ SendClientMessageEx(CrackOffer[playerid], COLOR_YELLOW, "* Your Drug Dealer Skill is now Level 3, you can buy more Grams and Cheaper."); }
        else if(PlayerInfo[CrackOffer[playerid]][pDrugsSkill] == 200)
        { SendClientMessageEx(CrackOffer[playerid], COLOR_YELLOW, "* Your Drug Dealer Skill is now Level 4, you can buy more Grams and Cheaper."); }
        else if(PlayerInfo[CrackOffer[playerid]][pDrugsSkill] == 400)
        { SendClientMessageEx(CrackOffer[playerid], COLOR_YELLOW, "* Your Drug Dealer Skill is now Level 5, you can buy more Grams and Cheaper."); }
		OnPlayerStatsUpdate(playerid);
        OnPlayerStatsUpdate(CrackOffer[playerid]);
		CrackOffer[playerid] = INVALID_PLAYER_ID;
		CrackStorageID[playerid] = -1;
        CrackPrice[playerid] = 0;
        CrackGram[playerid] = 0;
	}
	if(special == 2 && itemid == 2) // Pot Special "Getting"
	{
		new mypoint = -1;
		for (new i=0; i<MAX_POINTS; i++)
		{
			if (IsPlayerInRangeOfPoint(playerid, 3.0, Points[i][Pointx], Points[i][Pointy], Points[i][Pointz]) && Points[i][Type] == 3)
			{
				new myvw = GetPlayerVirtualWorld(playerid);
				if(myvw == Points[i][pointVW])
				{
					mypoint = i;
				}	
			}
		}

		if(PlayerInfo[playerid][pDonateRank] < 1)
		{
			Points[mypoint][Stock] -= amount;
			format(string, sizeof(string), " POT/OPIUM AVAILABLE: %d/1000.", Points[mypoint][Stock]);
			UpdateDynamic3DTextLabelText(Points[mypoint][TextLabel], COLOR_YELLOW, string);
		}
		for(new i = 0; i < MAX_GROUPS; i++)
		{
			if(strcmp(Points[mypoint][Owner], arrGroupData[i][g_szGroupName], true) == 0)
			{
				arrGroupData[i][g_iBudget] += price/2;
			}
		}
	}
	if(special == 2 && itemid == 3) // Crack Special "Getting"
	{
		new mypoint = -1;
		for (new i=0; i<MAX_POINTS; i++)
		{
			if (IsPlayerInRangeOfPoint(playerid, 3.0, Points[i][Pointx], Points[i][Pointy], Points[i][Pointz]) && Points[i][Type] == 4)
			{
				new myvw = GetPlayerVirtualWorld(playerid);
				if(myvw == Points[i][pointVW])
				{
					mypoint = i;
				}	
			}
		}
		if(PlayerInfo[playerid][pDonateRank] < 1)
		{
			Points[mypoint][Stock] -= amount;
			format(string, sizeof(string), " CRACK AVAILABLE: %d/500.", Points[mypoint][Stock]);
			UpdateDynamic3DTextLabelText(Points[mypoint][TextLabel], COLOR_YELLOW, string);
		}
		for(new i = 0; i < MAX_GROUPS; i++)
		{
			if(strcmp(Points[mypoint][Owner], arrGroupData[i][g_szGroupName], true) == 0)
			{
				arrGroupData[i][g_iBudget] += price/2;
			}
		}
	}
	if(special == 2 && itemid == 4) // Materials Special "Getting"
	{
		DeletePVar(playerid, "Packages");
		DeletePVar(playerid, "MatDeliver");
		DisablePlayerCheckpoint(playerid);
	}
	if(special == 4 && itemid == 1) // House Withdraw - Cash
	{
		new houseid = GetPVarInt(playerid, "Special_HouseID");
		DeletePVar(playerid, "Special_HouseID");

		HouseInfo[houseid][hSafeMoney] -= amount;
	}
	if(special == 4 && itemid == 2) // House Withdraw - Pot
	{
		new houseid = GetPVarInt(playerid, "Special_HouseID");
		DeletePVar(playerid, "Special_HouseID");

		HouseInfo[houseid][hPot] -= amount;
	}
	if(special == 4 && itemid == 3) // House Withdraw - Crack
	{
		new houseid = GetPVarInt(playerid, "Special_HouseID");
		DeletePVar(playerid, "Special_HouseID");

		HouseInfo[houseid][hCrack] -= amount;
	}
	if(special == 4 && itemid == 4) // House Withdraw - Mats
	{
		new houseid = GetPVarInt(playerid, "Special_HouseID");
		DeletePVar(playerid, "Special_HouseID");

		HouseInfo[houseid][hMaterials] -= amount;
	}

	switch(storageid)
	{
		case 0: // Pocket or On Hand
		{
			if(itemid == 1)
			{
				// Check if Sending Player has sufficient amount.
				if(fromplayerid != -1 && fromstorageid != -1)
				{
					if(fromstorageid == 0)
					{
						if(PlayerInfo[fromplayerid][pCash] < amount)
						{
							format(string, sizeof(string), "You do not have sufficient amount to give $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}
					else
					{
						if(StorageInfo[fromplayerid][fromstorageid-1][sCash] < amount)
						{
							format(string, sizeof(string), "You do not have sufficient amount to give $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}

					if(fromstorageid == 0) PlayerInfo[fromplayerid][pCash] -= amount;
					else StorageInfo[fromplayerid][fromstorageid-1][sCash] -= amount;
				}
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				PlayerInfo[playerid][pCash] += amount;
				OnPlayerStatsUpdate(playerid);
				if(fromplayerid != -1) {
        			OnPlayerStatsUpdate(fromplayerid);
        		}
				format(string, sizeof(string), "$%d has been transfered to your Pocket ($%d).", amount, PlayerInfo[playerid][pCash]);
				SendClientMessage(playerid, COLOR_WHITE, string);

				if(fromplayerid != -1 && fromstorageid != -1 && playerid != fromplayerid) {
					format(string, sizeof(string), "$%d has been transfered from your %s to %s's %s.", amount, storagetype[fromstorageid], GetPlayerNameEx(playerid), storagetype[storageid]);
					SendClientMessage(fromplayerid, COLOR_WHITE, string);

					PlayerPlaySound(fromplayerid, 1052, 0.0, 0.0, 0.0);
					format(string, sizeof(string), "* %s takes out some %s from their %s, and hands it to %s.", GetPlayerNameEx(fromplayerid), itemtype[itemid], storagetype[fromstorageid], GetPlayerNameEx(playerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

					if(PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[fromplayerid][pAdmin] >= 2)
					{
						format(string, sizeof(string), "[Admin] %s(%d) (IP:%s) has given $%s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), GetPlayerIpEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid));
						Log("logs/adminpay.log", string);
						format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s has given $%s %s to %s", GetPlayerNameEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid));
						if(!strcmp(GetPlayerIpEx(playerid),  GetPlayerIpEx(fromplayerid), true)) strcat(string, " (1)");
						ABroadCast(COLOR_YELLOW, string, 4);
					}
					else
					{
						format(string, sizeof(string), "%s(%d) (IP:%s) has given $%s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), GetPlayerIpEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid));
						Log("logs/pay.log", string);
						format(string, sizeof(string), "%s (IP:%s) has given $%s %s to %s (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerIpEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerIpEx(playerid));
						if(amount >= 100000 && PlayerInfo[fromplayerid][pLevel] <= 3 && itemid == 1) ABroadCast(COLOR_YELLOW, string, 2);
						if(amount >= 1000000 && itemid == 1)	ABroadCast(COLOR_YELLOW,string,2);
					}
				}
				return 1;
			}
			if(itemid == 2 && (PlayerInfo[playerid][pPot] + amount <= onhandlimit[itemid-1]))
			{
				// Check if Sending Player has sufficient amount.
				if(fromplayerid != -1 && fromstorageid != -1)
				{
					if(fromstorageid == 0)
					{
						if(PlayerInfo[fromplayerid][pPot] < amount)
						{
							format(string, sizeof(string), "You do not have sufficient amount to give $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}
					else
					{
						if(StorageInfo[fromplayerid][fromstorageid-1][sPot] < amount)
						{
							format(string, sizeof(string), "You do not have sufficient amount to give $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}

					if(fromstorageid == 0) PlayerInfo[fromplayerid][pPot] -= amount;
					else StorageInfo[fromplayerid][fromstorageid-1][sPot] -= amount;
				}
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				PlayerInfo[playerid][pPot] += amount;
				//format(string, sizeof(string), "%d Pot has been transfered to your Pocket (%d/%d).", amount, PlayerInfo[playerid][pPot], onhandlimit[itemid-1]);
				format(string, sizeof(string), "%d Pot has been transfered to your Pocket (%d).", amount, PlayerInfo[playerid][pPot]);
				SendClientMessage(playerid, COLOR_WHITE, string);

				if(fromplayerid != -1 && fromstorageid != -1 && playerid != fromplayerid) {
					format(string, sizeof(string), "%d Pot has been transfered from your %s to %s's %s.", amount, storagetype[fromstorageid], GetPlayerNameEx(playerid), storagetype[storageid]);
					SendClientMessage(fromplayerid, COLOR_WHITE, string);

					PlayerPlaySound(fromplayerid, 1052, 0.0, 0.0, 0.0);
					format(string, sizeof(string), "* %s takes out some %s from their %s, and hands it to %s.", GetPlayerNameEx(fromplayerid), itemtype[itemid], storagetype[fromstorageid], GetPlayerNameEx(playerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

					if(PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[fromplayerid][pAdmin] >= 2)
					{
						format(string, sizeof(string), "[Admin] %s(%d) (IP:%s) has given %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), GetPlayerIpEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid));
						Log("logs/adminpay.log", string);
						format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s has given %s %s to %s", GetPlayerNameEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid));
						if(!strcmp(GetPlayerIpEx(playerid),  GetPlayerIpEx(fromplayerid), true)) strcat(string, " (1)");
						ABroadCast(COLOR_YELLOW, string, 4);
					}
					else
					{
						format(string, sizeof(string), "%s(%d) (IP:%s) has given %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), GetPlayerIpEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid));
						Log("logs/pay.log", string);
						format(string, sizeof(string), "%s (IP:%s) has given %s %s to %s (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerIpEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerIpEx(playerid));
						if(amount >= 100000 && PlayerInfo[fromplayerid][pLevel] <= 3 && itemid == 1) ABroadCast(COLOR_YELLOW, string, 2);
						if(amount >= 1000000 && itemid == 1)	ABroadCast(COLOR_YELLOW,string,2);
					}
				}
				return 1;
			}
			if(itemid == 3 && (PlayerInfo[playerid][pCrack] + amount <= onhandlimit[itemid-1]))
			{
				// Check if Sending Player has sufficient amount.
				if(fromplayerid != -1 && fromstorageid != -1)
				{
					if(fromstorageid == 0)
					{
						if(PlayerInfo[fromplayerid][pCrack] < amount)
						{
							format(string, sizeof(string), "You do not have sufficient amount to give $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}
					else
					{
						if(StorageInfo[fromplayerid][fromstorageid-1][sCrack] < amount)
						{
							format(string, sizeof(string), "You do not have sufficient amount to give $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}

					if(fromstorageid == 0) PlayerInfo[fromplayerid][pCrack] -= amount;
					else StorageInfo[fromplayerid][fromstorageid-1][sCrack] -= amount;
				}
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				PlayerInfo[playerid][pCrack] += amount;
				//format(string, sizeof(string), "%d Crack has been transfered to your Pocket (%d/%d).", amount, PlayerInfo[playerid][pCrack], onhandlimit[itemid-1]);
				format(string, sizeof(string), "%d Crack has been transfered to your Pocket (%d).", amount, PlayerInfo[playerid][pCrack]);
				SendClientMessage(playerid, COLOR_WHITE, string);

				if(fromplayerid != -1 && fromstorageid != -1 && playerid != fromplayerid) {
					format(string, sizeof(string), "%d Crack has been transfered from your %s to %s's %s.", amount, storagetype[fromstorageid], GetPlayerNameEx(playerid), storagetype[storageid]);
					SendClientMessage(fromplayerid, COLOR_WHITE, string);

					PlayerPlaySound(fromplayerid, 1052, 0.0, 0.0, 0.0);
					format(string, sizeof(string), "* %s takes out some %s from their %s, and hands it to %s.", GetPlayerNameEx(fromplayerid), itemtype[itemid], storagetype[fromstorageid], GetPlayerNameEx(playerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

					if(PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[fromplayerid][pAdmin] >= 2)
					{
						format(string, sizeof(string), "[Admin] %s(%d) (IP:%s) has given %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), GetPlayerIpEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid));
						Log("logs/adminpay.log", string);
						format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s has given %s %s to %s", GetPlayerNameEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid));
						if(!strcmp(GetPlayerIpEx(playerid),  GetPlayerIpEx(fromplayerid), true)) strcat(string, " (1)");
						ABroadCast(COLOR_YELLOW, string, 4);
					}
					else
					{
						format(string, sizeof(string), "%s(%d) (IP:%s) has given %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), GetPlayerIpEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid));
						Log("logs/pay.log", string);
						format(string, sizeof(string), "%s (IP:%s) has given %s %s to %s (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerIpEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerIpEx(playerid));
						if(amount >= 100000 && PlayerInfo[fromplayerid][pLevel] <= 3 && itemid == 1) ABroadCast(COLOR_YELLOW, string, 2);
						if(amount >= 1000000 && itemid == 1)	ABroadCast(COLOR_YELLOW,string,2);
					}
				}
				return 1;
			}
			if(itemid == 4 && (PlayerInfo[playerid][pMats] + amount <= onhandlimit[itemid-1]))
			{
				// Check if Sending Player has sufficient amount.
				if(fromplayerid != -1 && fromstorageid != -1)
				{
					if(fromstorageid == 0)
					{
						if(PlayerInfo[fromplayerid][pMats] < amount)
						{
							format(string, sizeof(string), "You do not have sufficient amount to give %d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}
					else
					{
						if(StorageInfo[fromplayerid][fromstorageid-1][sMats] < amount)
						{
							format(string, sizeof(string), "You do not have sufficient amount to give %d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}

					if(fromstorageid == 0) PlayerInfo[fromplayerid][pMats] -= amount;
					else StorageInfo[fromplayerid][fromstorageid-1][sMats] -= amount;
				}
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				PlayerInfo[playerid][pMats] += amount;
				//format(string, sizeof(string), "%d Materials has been transfered to your Pocket (%d/%d).", amount, PlayerInfo[playerid][pMats], onhandlimit[itemid-1]);
				format(string, sizeof(string), "%d Materials has been transfered to your Pocket (%d).", amount, PlayerInfo[playerid][pMats]);
				SendClientMessage(playerid, COLOR_WHITE, string);

				if(fromplayerid != -1 && fromstorageid != -1 && playerid != fromplayerid) {
					format(string, sizeof(string), "%d Materials has been transfered from your %s to %s's %s.", amount, storagetype[fromstorageid], GetPlayerNameEx(playerid), storagetype[storageid]);
					SendClientMessage(fromplayerid, COLOR_WHITE, string);

					PlayerPlaySound(fromplayerid, 1052, 0.0, 0.0, 0.0);
					format(string, sizeof(string), "* %s takes out some %s from their %s, and hands it to %s.", GetPlayerNameEx(fromplayerid), itemtype[itemid], storagetype[fromstorageid], GetPlayerNameEx(playerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

					new ipplayerid[16], ipfromplayerid[16];
					GetPlayerIp(playerid, ipplayerid, sizeof(ipplayerid));
					GetPlayerIp(fromplayerid, ipfromplayerid, sizeof(ipfromplayerid));

					if(PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[fromplayerid][pAdmin] >= 2)
					{
						format(string, sizeof(string), "[Admin] %s(%d) (IP:%s) has given %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ipplayerid);
						Log("logs/adminpay.log", string);
						format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s has given %s %s to %s", GetPlayerNameEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid));
						if(!strcmp(GetPlayerIpEx(playerid),  GetPlayerIpEx(fromplayerid), true)) strcat(string, " (1)");
						ABroadCast(COLOR_YELLOW, string, 4);
					}
					else
					{
						format(string, sizeof(string), "%s(%d) (IP:%s) has given %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ipplayerid);
						Log("logs/pay.log", string);
						format(string, sizeof(string), "%s (IP:%s) has given %s %s to %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						if(amount >= 100000 && PlayerInfo[fromplayerid][pLevel] <= 3 && itemid == 1) ABroadCast(COLOR_YELLOW, string, 2);
						if(amount >= 1000000 && itemid == 1)	ABroadCast(COLOR_YELLOW,string,2);
					}
				}
				return 1;
			}
			/*if(itemid == 4)
			{
				SendClientMessageEx(playerid, COLOR_WHITE, "You need at least a Bag to be able to store Materials.");
				return 0;
			}*/

			if(itemid == 1) format(string, sizeof(string), "Unable to transfer $%d to %s ($%d).", amount, storagetype[storageid], PlayerInfo[playerid][pCash]);
			else if(itemid == 2) format(string, sizeof(string), "Unable to transfer %d %s to %s (%d/%d).", amount, itemtype[itemid], storagetype[storageid], PlayerInfo[playerid][pPot], onhandlimit[itemid-1]);
			else if(itemid == 3) format(string, sizeof(string), "Unable to transfer %d %s to %s (%d/%d).", amount, itemtype[itemid], storagetype[storageid], PlayerInfo[playerid][pCrack], onhandlimit[itemid-1]);
			else if(itemid == 4) format(string, sizeof(string), "Unable to transfer %d %s to %s (%d/%d).", amount, itemtype[itemid], storagetype[storageid], PlayerInfo[playerid][pMats], onhandlimit[itemid-1]);

			SendClientMessageEx(playerid, COLOR_WHITE, string);
		}
		case 1: // Bag
		{
			if(StorageInfo[playerid][0][sStorage] == 0)
			{
				SendClientMessageEx(playerid, COLOR_WHITE, "You do not own a Bag. You may purchase one at a 24/7 store.");
				return 0;
			}

			if(itemid == 1 && (StorageInfo[playerid][0][sCash] + amount <= bbackpacklimit[itemid-1]))
			{
				// Check if Sending Player has sufficient amount.
				if(fromplayerid != -1 && fromstorageid != -1)
				{
					if(fromstorageid == 0)
					{
						if(PlayerInfo[fromplayerid][pCash] < amount)
						{
							format(string, sizeof(string), "You do not have sufficient amount to give $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}
					else
					{
						if(StorageInfo[fromplayerid][fromstorageid-1][sCash] < amount)
						{
							format(string, sizeof(string), "You do not have sufficient amount to give $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}

					if(fromstorageid == 0) PlayerInfo[fromplayerid][pCash] -= amount;
					else StorageInfo[fromplayerid][fromstorageid-1][sCash] -= amount;
				}
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				StorageInfo[playerid][0][sCash] += amount;
				format(string, sizeof(string), "$%d has been transfered to your Bag ($%d/$%d).", amount, StorageInfo[playerid][0][sCash], bbackpacklimit[itemid-1]);
				SendClientMessage(playerid, COLOR_WHITE, string);

				if(fromplayerid != -1 && fromstorageid != -1 && playerid != fromplayerid) {
					format(string, sizeof(string), "$%d has been transfered from your %s to %s's %s.", amount, storagetype[fromstorageid], GetPlayerNameEx(playerid), storagetype[storageid]);
					SendClientMessage(fromplayerid, COLOR_WHITE, string);

					PlayerPlaySound(fromplayerid, 1052, 0.0, 0.0, 0.0);
					format(string, sizeof(string), "* %s takes out some %s from their %s, and hands it to %s.", GetPlayerNameEx(fromplayerid), itemtype[itemid], storagetype[fromstorageid], GetPlayerNameEx(playerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

					new ipplayerid[16], ipfromplayerid[16];
					GetPlayerIp(playerid, ipplayerid, sizeof(ipplayerid));
					GetPlayerIp(fromplayerid, ipfromplayerid, sizeof(ipfromplayerid));

					if(PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[fromplayerid][pAdmin] >= 2)
					{
						format(string, sizeof(string), "[Admin] %s(%d) (IP:%s) has given %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ipplayerid);
						Log("logs/adminpay.log", string);
						format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s has given %s %s to %s", GetPlayerNameEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid));
						if(!strcmp(GetPlayerIpEx(playerid),  GetPlayerIpEx(fromplayerid), true)) strcat(string, " (1)");
						ABroadCast(COLOR_YELLOW, string, 4);
					}
					else
					{
						format(string, sizeof(string), "%s(%d) (IP:%s) has given %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ipplayerid);
						Log("logs/pay.log", string);
						format(string, sizeof(string), "%s (IP:%s) has given %s %s to %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						if(amount >= 100000 && PlayerInfo[fromplayerid][pLevel] <= 3 && itemid == 1) ABroadCast(COLOR_YELLOW, string, 2);
						if(amount >= 1000000 && itemid == 1)	ABroadCast(COLOR_YELLOW,string,2);
					}
				}
				return 1;
			}
			if(itemid == 2 && (StorageInfo[playerid][0][sPot] + amount <= bbackpacklimit[itemid-1]))
			{
				// Check if Sending Player has sufficient amount.
				if(fromplayerid != -1 && fromstorageid != -1)
				{
					if(fromstorageid == 0)
					{
						if(PlayerInfo[fromplayerid][pPot] < amount)
						{
							format(string, sizeof(string), "You do not have sufficient amount to give $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}
					else
					{
						if(StorageInfo[fromplayerid][fromstorageid-1][sPot] < amount)
						{
							format(string, sizeof(string), "You do not have sufficient amount to give $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}

					if(fromstorageid == 0) PlayerInfo[fromplayerid][pPot] -= amount;
					else StorageInfo[fromplayerid][fromstorageid-1][sPot] -= amount;
				}
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				StorageInfo[playerid][0][sPot] += amount;
				format(string, sizeof(string), "%d Pot has been transfered to your Bag (%d/%d).", amount, StorageInfo[playerid][0][sPot], bbackpacklimit[itemid-1]);
				SendClientMessage(playerid, COLOR_WHITE, string);

				if(fromplayerid != -1 && fromstorageid != -1 && playerid != fromplayerid) {
					format(string, sizeof(string), "%d Pot has been transfered from your %s to %s's %s.", amount, storagetype[fromstorageid], GetPlayerNameEx(playerid), storagetype[storageid]);
					SendClientMessage(fromplayerid, COLOR_WHITE, string);

					PlayerPlaySound(fromplayerid, 1052, 0.0, 0.0, 0.0);
					format(string, sizeof(string), "* %s takes out some %s from their %s, and hands it to %s.", GetPlayerNameEx(fromplayerid), itemtype[itemid], storagetype[fromstorageid], GetPlayerNameEx(playerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

					new ipplayerid[16], ipfromplayerid[16];
					GetPlayerIp(playerid, ipplayerid, sizeof(ipplayerid));
					GetPlayerIp(fromplayerid, ipfromplayerid, sizeof(ipfromplayerid));

					if(PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[fromplayerid][pAdmin] >= 2)
					{
						format(string, sizeof(string), "[Admin] %s(%d) (IP:%s) has given %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ipplayerid);
						Log("logs/adminpay.log", string);
						format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s has given %s %s to %s", GetPlayerNameEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid));
						if(!strcmp(GetPlayerIpEx(playerid),  GetPlayerIpEx(fromplayerid), true)) strcat(string, " (1)");
						ABroadCast(COLOR_YELLOW, string, 4);
					}
					else
					{
						format(string, sizeof(string), "%s(%d) (IP:%s) has given %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ipplayerid);
						Log("logs/pay.log", string);
						format(string, sizeof(string), "%s (IP:%s) has given %s %s to %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						if(amount >= 100000 && PlayerInfo[fromplayerid][pLevel] <= 3 && itemid == 1) ABroadCast(COLOR_YELLOW, string, 2);
						if(amount >= 1000000 && itemid == 1)	ABroadCast(COLOR_YELLOW,string,2);
					}
				}
				return 1;
			}
			if(itemid == 3 && (StorageInfo[playerid][0][sCrack] + amount <= bbackpacklimit[itemid-1]))
			{
				// Check if Sending Player has sufficient amount.
				if(fromplayerid != -1 && fromstorageid != -1)
				{
					if(fromstorageid == 0)
					{
						if(PlayerInfo[fromplayerid][pCrack] < amount)
						{
							format(string, sizeof(string), "You do not have sufficient amount to give $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}
					else
					{
						if(StorageInfo[fromplayerid][fromstorageid-1][sCrack] < amount)
						{
							format(string, sizeof(string), "You do not have sufficient amount to give $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}

					if(fromstorageid == 0) PlayerInfo[fromplayerid][pCrack] -= amount;
					else StorageInfo[fromplayerid][fromstorageid-1][sCrack] -= amount;
				}
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				StorageInfo[playerid][0][sCrack] += amount;
				format(string, sizeof(string), "%d Crack has been transfered to your Bag (%d/%d).", amount, StorageInfo[playerid][0][sCrack], bbackpacklimit[itemid-1]);
				SendClientMessage(playerid, COLOR_WHITE, string);

				if(fromplayerid != -1 && fromstorageid != -1 && playerid != fromplayerid) {
					format(string, sizeof(string), "%d Crack has been transfered from your %s to %s's %s.", amount, storagetype[fromstorageid], GetPlayerNameEx(playerid), storagetype[storageid]);
					SendClientMessage(fromplayerid, COLOR_WHITE, string);

					PlayerPlaySound(fromplayerid, 1052, 0.0, 0.0, 0.0);
					format(string, sizeof(string), "* %s takes out some %s from their %s, and hands it to %s.", GetPlayerNameEx(fromplayerid), itemtype[itemid], storagetype[fromstorageid], GetPlayerNameEx(playerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

					new ipplayerid[16], ipfromplayerid[16];
					GetPlayerIp(playerid, ipplayerid, sizeof(ipplayerid));
					GetPlayerIp(fromplayerid, ipfromplayerid, sizeof(ipfromplayerid));

					if(PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[fromplayerid][pAdmin] >= 2)
					{
						format(string, sizeof(string), "[Admin] %s(%d) (IP:%s) has given %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ipplayerid);
						Log("logs/adminpay.log", string);
						format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s has given %s %s to %s", GetPlayerNameEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid));
						if(!strcmp(GetPlayerIpEx(playerid),  GetPlayerIpEx(fromplayerid), true)) strcat(string, " (1)");
						ABroadCast(COLOR_YELLOW, string, 4);
					}
					else
					{
						format(string, sizeof(string), "%s(%d) (IP:%s) has given %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ipplayerid);
						Log("logs/pay.log", string);
						format(string, sizeof(string), "%s (IP:%s) has given %s %s to %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						if(amount >= 100000 && PlayerInfo[fromplayerid][pLevel] <= 3 && itemid == 1) ABroadCast(COLOR_YELLOW, string, 2);
						if(amount >= 1000000 && itemid == 1)	ABroadCast(COLOR_YELLOW,string,2);
					}
				}
				return 1;
			}
			if(itemid == 4 && (StorageInfo[playerid][0][sMats] + amount <= bbackpacklimit[itemid-1]))
			{
				// Check if Sending Player has sufficient amount.
				if(fromplayerid != -1 && fromstorageid != -1)
				{
					if(fromstorageid == 0)
					{
						if(PlayerInfo[fromplayerid][pMats] < amount)
						{
							format(string, sizeof(string), "You do not have sufficient amount to give $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}
					else
					{
						if(StorageInfo[fromplayerid][fromstorageid-1][sMats] < amount)
						{
							format(string, sizeof(string), "You do not have sufficient amount to give $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}

					if(fromstorageid == 0) PlayerInfo[fromplayerid][pMats] -= amount;
					else StorageInfo[fromplayerid][fromstorageid-1][sMats] -= amount;
				}
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				StorageInfo[playerid][0][sMats] += amount;
				format(string, sizeof(string), "%d Materials has been transfered to your Bag (%d/%d).", amount, StorageInfo[playerid][0][sMats], bbackpacklimit[itemid-1]);
				SendClientMessage(playerid, COLOR_WHITE, string);

				if(fromplayerid != -1 && fromstorageid != -1 && playerid != fromplayerid) {
					format(string, sizeof(string), "%d Materials has been transfered from your %s to %s's %s.", amount, storagetype[fromstorageid], GetPlayerNameEx(playerid), storagetype[storageid]);
					SendClientMessage(fromplayerid, COLOR_WHITE, string);

					PlayerPlaySound(fromplayerid, 1052, 0.0, 0.0, 0.0);
					format(string, sizeof(string), "* %s takes out some %s from their %s, and hands it to %s.", GetPlayerNameEx(fromplayerid), itemtype[itemid], storagetype[fromstorageid], GetPlayerNameEx(playerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

					new ipplayerid[16], ipfromplayerid[16];
					GetPlayerIp(playerid, ipplayerid, sizeof(ipplayerid));
					GetPlayerIp(fromplayerid, ipfromplayerid, sizeof(ipfromplayerid));

					if(PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[fromplayerid][pAdmin] >= 2)
					{
						format(string, sizeof(string), "[Admin] %s(%d) (IP:%s) has given %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ipplayerid);
						Log("logs/adminpay.log", string);
						format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s has given %s %s to %s", GetPlayerNameEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid));
						if(!strcmp(GetPlayerIpEx(playerid),  GetPlayerIpEx(fromplayerid), true)) strcat(string, " (1)");
						ABroadCast(COLOR_YELLOW, string, 4);
					}
					else
					{
						format(string, sizeof(string), "%s(%d) (IP:%s) has given %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ipplayerid);
						Log("logs/pay.log", string);
						format(string, sizeof(string), "%s (IP:%s) has given %s %s to %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						if(amount >= 100000 && PlayerInfo[fromplayerid][pLevel] <= 3 && itemid == 1) ABroadCast(COLOR_YELLOW, string, 2);
						if(amount >= 1000000 && itemid == 1)	ABroadCast(COLOR_YELLOW,string,2);
					}
				}
				return 1;
			}

			if(itemid == 1) format(string, sizeof(string), "Unable to transfer $%d to %s ($%d/$%d).", amount, storagetype[storageid], StorageInfo[playerid][0][sCash], bbackpacklimit[itemid-1]);
			else if(itemid == 2) format(string, sizeof(string), "Unable to transfer %d %s to %s (%d/%d).", amount, itemtype[itemid], storagetype[storageid], StorageInfo[playerid][0][sPot], bbackpacklimit[itemid-1]);
			else if(itemid == 3) format(string, sizeof(string), "Unable to transfer %d %s to %s (%d/%d).", amount, itemtype[itemid], storagetype[storageid], StorageInfo[playerid][0][sCrack], bbackpacklimit[itemid-1]);
			else if(itemid == 4) format(string, sizeof(string), "Unable to transfer %d %s to %s (%d/%d).", amount, itemtype[itemid], storagetype[storageid], StorageInfo[playerid][0][sMats], bbackpacklimit[itemid-1]);
			SendClientMessageEx(playerid, COLOR_WHITE, string);

		}
		case 2: // Backpack
		{
			if(StorageInfo[playerid][1][sStorage] == 0)
			{
				SendClientMessageEx(playerid, COLOR_WHITE, "You do not own a Backpack. You may purchase one on our E-Store.");
				return 0;
			}

			if(itemid == 1 && (StorageInfo[playerid][1][sCash] + amount <= backpacklimit[itemid-1]))
			{
				// Check if Sending Player has sufficient amount.
				if(fromplayerid != -1 && fromstorageid != -1)
				{
					if(fromstorageid == 0)
					{
						if(PlayerInfo[fromplayerid][pCash] < amount)
						{
							format(string, sizeof(string), "You do not have sufficient amount to give $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}
					else
					{
						if(StorageInfo[fromplayerid][fromstorageid-1][sCash] < amount)
						{
							format(string, sizeof(string), "You do not have sufficient amount to give $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}

					if(fromstorageid == 0) PlayerInfo[fromplayerid][pCash] -= amount;
					else StorageInfo[fromplayerid][fromstorageid-1][sCash] -= amount;
				}
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				StorageInfo[playerid][1][sCash] += amount;
				format(string, sizeof(string), "$%d has been transfered to your Backpack ($%d/$%d).", amount, StorageInfo[playerid][1][sCash], backpacklimit[itemid-1]);
				SendClientMessage(playerid, COLOR_WHITE, string);

				if(fromplayerid != -1 && fromstorageid != -1 && playerid != fromplayerid) {
					format(string, sizeof(string), "$%d has been transfered from your %s to %s's %s.", amount, storagetype[fromstorageid], GetPlayerNameEx(playerid), storagetype[storageid]);
					SendClientMessage(fromplayerid, COLOR_WHITE, string);

					PlayerPlaySound(fromplayerid, 1052, 0.0, 0.0, 0.0);
					format(string, sizeof(string), "* %s takes out some %s from their %s, and hands it to %s.", GetPlayerNameEx(fromplayerid), itemtype[itemid], storagetype[fromstorageid], GetPlayerNameEx(playerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

					new ipplayerid[16], ipfromplayerid[16];
					GetPlayerIp(playerid, ipplayerid, sizeof(ipplayerid));
					GetPlayerIp(fromplayerid, ipfromplayerid, sizeof(ipfromplayerid));

					if(PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[fromplayerid][pAdmin] >= 2)
					{
						format(string, sizeof(string), "[Admin] %s(%d) (IP:%s) has given %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ipplayerid);
						Log("logs/adminpay.log", string);
						format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s has given %s %s to %s", GetPlayerNameEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid));
						if(!strcmp(GetPlayerIpEx(playerid),  GetPlayerIpEx(fromplayerid), true)) strcat(string, " (1)");
						ABroadCast(COLOR_YELLOW, string, 4);
					}
					else
					{
						format(string, sizeof(string), "%s(%d) (IP:%s) has given %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ipplayerid);
						Log("logs/pay.log", string);
						format(string, sizeof(string), "%s (IP:%s) has given %s %s to %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						if(amount >= 100000 && PlayerInfo[fromplayerid][pLevel] <= 3 && itemid == 1) ABroadCast(COLOR_YELLOW, string, 2);
						if(amount >= 1000000 && itemid == 1)	ABroadCast(COLOR_YELLOW,string,2);
					}
				}
				return 1;
			}
			if(itemid == 2 && (StorageInfo[playerid][1][sPot] + amount <= backpacklimit[itemid-1]))
			{
				// Check if Sending Player has sufficient amount.
				if(fromplayerid != -1 && fromstorageid != -1)
				{
					if(fromstorageid == 0)
					{
						if(PlayerInfo[fromplayerid][pPot] < amount)
						{
							format(string, sizeof(string), "You do not have sufficient amount to give $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}
					else
					{
						if(StorageInfo[fromplayerid][fromstorageid-1][sPot] < amount)
						{
							format(string, sizeof(string), "You do not have sufficient amount to give $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}

					if(fromstorageid == 0) PlayerInfo[fromplayerid][pPot] -= amount;
					else StorageInfo[fromplayerid][fromstorageid-1][sPot] -= amount;
				}
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				StorageInfo[playerid][1][sPot] += amount;
				format(string, sizeof(string), "%d Pot has been transfered to your Backpack (%d/%d).", amount, StorageInfo[playerid][1][sPot], backpacklimit[itemid-1]);
				SendClientMessage(playerid, COLOR_WHITE, string);

				if(fromplayerid != -1 && fromstorageid != -1 && playerid != fromplayerid) {
					format(string, sizeof(string), "%d Pot has been transfered from your %s to %s's %s.", amount, storagetype[fromstorageid], GetPlayerNameEx(playerid), storagetype[storageid]);
					SendClientMessage(fromplayerid, COLOR_WHITE, string);

					PlayerPlaySound(fromplayerid, 1052, 0.0, 0.0, 0.0);
					format(string, sizeof(string), "* %s takes out some %s from their %s, and hands it to %s.", GetPlayerNameEx(fromplayerid), itemtype[itemid], storagetype[fromstorageid], GetPlayerNameEx(playerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

					new ipplayerid[16], ipfromplayerid[16];
					GetPlayerIp(playerid, ipplayerid, sizeof(ipplayerid));
					GetPlayerIp(fromplayerid, ipfromplayerid, sizeof(ipfromplayerid));

					if(PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[fromplayerid][pAdmin] >= 2)
					{
						format(string, sizeof(string), "[Admin] %s(%d) (IP:%s) has given %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ipplayerid);
						Log("logs/adminpay.log", string);
						format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s has given %s %s to %s", GetPlayerNameEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid));
						if(!strcmp(GetPlayerIpEx(playerid),  GetPlayerIpEx(fromplayerid), true)) strcat(string, " (1)");
						ABroadCast(COLOR_YELLOW, string, 4);
					}
					else
					{
						format(string, sizeof(string), "%s(%d) (IP:%s) has given %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ipplayerid);
						Log("logs/pay.log", string);
						format(string, sizeof(string), "%s (IP:%s) has given %s %s to %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						if(amount >= 100000 && PlayerInfo[fromplayerid][pLevel] <= 3 && itemid == 1) ABroadCast(COLOR_YELLOW, string, 2);
						if(amount >= 1000000 && itemid == 1)	ABroadCast(COLOR_YELLOW,string,2);
					}
				}
				return 1;
			}
			if(itemid == 3 && (StorageInfo[playerid][1][sCrack] + amount <= backpacklimit[itemid-1]))
			{
				// Check if Sending Player has sufficient amount.
				if(fromplayerid != -1 && fromstorageid != -1)
				{
					if(fromstorageid == 0)
					{
						if(PlayerInfo[fromplayerid][pCrack] < amount)
						{
							format(string, sizeof(string), "You do not have sufficient amount to give $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}
					else
					{
						if(StorageInfo[fromplayerid][fromstorageid-1][sCrack] < amount)
						{
							format(string, sizeof(string), "You do not have sufficient amount to give $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}

					if(fromstorageid == 0) PlayerInfo[fromplayerid][pCrack] -= amount;
					else StorageInfo[fromplayerid][fromstorageid-1][sCrack] -= amount;
				}
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				StorageInfo[playerid][1][sCrack] += amount;
				format(string, sizeof(string), "%d Crack has been transfered to your Backpack (%d/%d).", amount, StorageInfo[playerid][1][sCrack], backpacklimit[itemid-1]);
				SendClientMessage(playerid, COLOR_WHITE, string);

				if(fromplayerid != -1 && fromstorageid != -1 && playerid != fromplayerid) {
					format(string, sizeof(string), "%d Crack has been transfered from your %s to %s's %s.", amount, storagetype[fromstorageid], GetPlayerNameEx(playerid), storagetype[storageid]);
					SendClientMessage(fromplayerid, COLOR_WHITE, string);

					PlayerPlaySound(fromplayerid, 1052, 0.0, 0.0, 0.0);
					format(string, sizeof(string), "* %s takes out some %s from their %s, and hands it to %s.", GetPlayerNameEx(fromplayerid), itemtype[itemid], storagetype[fromstorageid], GetPlayerNameEx(playerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

					new ipplayerid[16], ipfromplayerid[16];
					GetPlayerIp(playerid, ipplayerid, sizeof(ipplayerid));
					GetPlayerIp(fromplayerid, ipfromplayerid, sizeof(ipfromplayerid));

					if(PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[fromplayerid][pAdmin] >= 2)
					{
						format(string, sizeof(string), "[Admin] %s(%d) (IP:%s) has given %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ipplayerid);
						Log("logs/adminpay.log", string);
						format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s has given %s %s to %s", GetPlayerNameEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid));
						if(!strcmp(GetPlayerIpEx(playerid),  GetPlayerIpEx(fromplayerid), true)) strcat(string, " (1)");
						ABroadCast(COLOR_YELLOW, string, 4);
					}
					else
					{
						format(string, sizeof(string), "%s(%d) (IP:%s) has given %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ipplayerid);
						Log("logs/pay.log", string);
						format(string, sizeof(string), "%s (IP:%s) has given %s %s to %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						if(amount >= 100000 && PlayerInfo[fromplayerid][pLevel] <= 3 && itemid == 1) ABroadCast(COLOR_YELLOW, string, 2);
						if(amount >= 1000000 && itemid == 1)	ABroadCast(COLOR_YELLOW,string,2);
					}
				}
				return 1;
			}
			if(itemid == 4 && (StorageInfo[playerid][1][sMats] + amount <= backpacklimit[itemid-1]))
			{
				// Check if Sending Player has sufficient amount.
				if(fromplayerid != -1 && fromstorageid != -1)
				{
					if(fromstorageid == 0)
					{
						if(PlayerInfo[fromplayerid][pMats] < amount)
						{
							format(string, sizeof(string), "You do not have sufficient amount to give $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}
					else
					{
						if(StorageInfo[fromplayerid][fromstorageid-1][sMats] < amount)
						{
							format(string, sizeof(string), "You do not have sufficient amount to give $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}

					if(fromstorageid == 0) PlayerInfo[fromplayerid][pMats] -= amount;
					else StorageInfo[fromplayerid][fromstorageid-1][sMats] -= amount;
				}
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				StorageInfo[playerid][1][sMats] += amount;
				format(string, sizeof(string), "%d Materials has been transfered to your Backpack (%d/%d).", amount, StorageInfo[playerid][1][sMats], backpacklimit[itemid-1]);
				SendClientMessage(playerid, COLOR_WHITE, string);

				if(fromplayerid != -1 && fromstorageid != -1 && playerid != fromplayerid) {
					format(string, sizeof(string), "%d Materials has been transfered from your %s to %s's %s.", amount, storagetype[fromstorageid], GetPlayerNameEx(playerid), storagetype[storageid]);
					SendClientMessage(fromplayerid, COLOR_WHITE, string);

					PlayerPlaySound(fromplayerid, 1052, 0.0, 0.0, 0.0);
					format(string, sizeof(string), "* %s takes out some %s from their %s, and hands it to %s.", GetPlayerNameEx(fromplayerid), itemtype[itemid], storagetype[fromstorageid], GetPlayerNameEx(playerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

					new ipplayerid[16], ipfromplayerid[16];
					GetPlayerIp(playerid, ipplayerid, sizeof(ipplayerid));
					GetPlayerIp(fromplayerid, ipfromplayerid, sizeof(ipfromplayerid));

					if(PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[fromplayerid][pAdmin] >= 2)
					{
						format(string, sizeof(string), "[Admin] %s(%d) (IP:%s) has given %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ipplayerid);
						Log("logs/adminpay.log", string);
						format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s has given %s %s to %s", GetPlayerNameEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid));
						if(!strcmp(GetPlayerIpEx(playerid),  GetPlayerIpEx(fromplayerid), true)) strcat(string, " (1)");
						ABroadCast(COLOR_YELLOW, string, 4);
					}
					else
					{
						format(string, sizeof(string), "%s(%d) (IP:%s) has given %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ipplayerid);
						Log("logs/pay.log", string);
						format(string, sizeof(string), "%s (IP:%s) has given %s %s to %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						if(amount >= 100000 && PlayerInfo[fromplayerid][pLevel] <= 3 && itemid == 1) ABroadCast(COLOR_YELLOW, string, 2);
						if(amount >= 1000000 && itemid == 1)	ABroadCast(COLOR_YELLOW,string,2);
					}
				}
				return 1;
			}
			if(itemid == 1) format(string, sizeof(string), "Unable to transfer $%d to %s ($%d/$%d).", amount, storagetype[storageid], StorageInfo[playerid][1][sCash], backpacklimit[itemid-1]);
			else if(itemid == 2) format(string, sizeof(string), "Unable to transfer %d %s to %s (%d/%d).", amount, itemtype[itemid], storagetype[storageid], StorageInfo[playerid][1][sPot], backpacklimit[itemid-1]);
			else if(itemid == 3) format(string, sizeof(string), "Unable to transfer %d %s to %s (%d/%d).", amount, itemtype[itemid], storagetype[storageid], StorageInfo[playerid][1][sCrack], backpacklimit[itemid-1]);
			else if(itemid == 4) format(string, sizeof(string), "Unable to transfer %d %s to %s (%d/%d).", amount, itemtype[itemid], storagetype[storageid], StorageInfo[playerid][1][sMats], backpacklimit[itemid-1]);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
		}
		case 3: // Briefcase
		{
			if(StorageInfo[playerid][2][sStorage] == 0)
			{
				SendClientMessageEx(playerid, COLOR_WHITE, "You do not own a Briefcase. You may purchase one on our E-Store.");
				return 0;
			}

			if(itemid == 1 && (StorageInfo[playerid][2][sCash] + amount <= briefcaselimit[itemid-1]))
			{
				// Check if Sending Player has sufficient amount.
				if(fromplayerid != -1 && fromstorageid != -1)
				{
					if(fromstorageid == 0)
					{
						if(PlayerInfo[fromplayerid][pCash] < amount)
						{
							format(string, sizeof(string), "You do not have sufficient amount to give $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}
					else
					{
						if(StorageInfo[fromplayerid][fromstorageid-1][sCash] < amount)
						{
							format(string, sizeof(string), "You do not have sufficient amount to give $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}

					if(fromstorageid == 0) PlayerInfo[fromplayerid][pCash] -= amount;
					else StorageInfo[fromplayerid][fromstorageid-1][sCash] -= amount;
				}
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				StorageInfo[playerid][2][sCash] += amount;
				format(string, sizeof(string), "$%d has been transfered to your Briefcase ($%d/$%d).", amount, StorageInfo[playerid][2][sCash], briefcaselimit[itemid-1]);
				SendClientMessage(playerid, COLOR_WHITE, string);

				if(fromplayerid != -1 && fromstorageid != -1 && playerid != fromplayerid) {
					format(string, sizeof(string), "$%d has been transfered from your %s to %s's %s.", amount, storagetype[fromstorageid], GetPlayerNameEx(playerid), storagetype[storageid]);
					SendClientMessage(fromplayerid, COLOR_WHITE, string);

					PlayerPlaySound(fromplayerid, 1052, 0.0, 0.0, 0.0);
					format(string, sizeof(string), "* %s takes out some %s from their %s, and hands it to %s.", GetPlayerNameEx(fromplayerid), itemtype[itemid], storagetype[fromstorageid], GetPlayerNameEx(playerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

					new ipplayerid[16], ipfromplayerid[16];
					GetPlayerIp(playerid, ipplayerid, sizeof(ipplayerid));
					GetPlayerIp(fromplayerid, ipfromplayerid, sizeof(ipfromplayerid));

					if(PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[fromplayerid][pAdmin] >= 2)
					{
						format(string, sizeof(string), "[Admin] %s(%d) (IP:%s) has given %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ipplayerid);
						Log("logs/adminpay.log", string);
						format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s has given %s %s to %s", GetPlayerNameEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid));
						if(!strcmp(GetPlayerIpEx(playerid),  GetPlayerIpEx(fromplayerid), true)) strcat(string, " (1)");
						ABroadCast(COLOR_YELLOW, string, 4);
					}
					else
					{
						format(string, sizeof(string), "%s(%d) (IP:%s) has given %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ipplayerid);
						Log("logs/pay.log", string);
						format(string, sizeof(string), "%s (IP:%s) has given %s %s to %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						if(amount >= 100000 && PlayerInfo[fromplayerid][pLevel] <= 3 && itemid == 1) ABroadCast(COLOR_YELLOW, string, 2);
						if(amount >= 1000000 && itemid == 1)	ABroadCast(COLOR_YELLOW,string,2);
					}
				}
				return 1;
			}
			if(itemid == 2 && (StorageInfo[playerid][2][sPot] + amount <= briefcaselimit[itemid-1]))
			{
				// Check if Sending Player has sufficient amount.
				if(fromplayerid != -1 && fromstorageid != -1)
				{
					if(fromstorageid == 0)
					{
						if(PlayerInfo[fromplayerid][pPot] < amount)
						{
							format(string, sizeof(string), "You do not have sufficient amount to give %d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}
					else
					{
						if(StorageInfo[fromplayerid][fromstorageid-1][sPot] < amount)
						{
							format(string, sizeof(string), "You do not have sufficient amount to give %d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}

					if(fromstorageid == 0) PlayerInfo[fromplayerid][pPot] -= amount;
					else StorageInfo[fromplayerid][fromstorageid-1][sPot] -= amount;
				}
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				StorageInfo[playerid][2][sPot] += amount;
				format(string, sizeof(string), "%d Pot has been transfered to your Briefcase (%d/%d).", amount, StorageInfo[playerid][2][sPot], briefcaselimit[itemid-1]);
				SendClientMessage(playerid, COLOR_WHITE, string);

				if(fromplayerid != -1 && fromstorageid != -1 && playerid != fromplayerid) {
					format(string, sizeof(string), "%d Pot has been transfered from your %s to %s's %s.", amount, storagetype[fromstorageid], GetPlayerNameEx(playerid), storagetype[storageid]);
					SendClientMessage(fromplayerid, COLOR_WHITE, string);

					PlayerPlaySound(fromplayerid, 1052, 0.0, 0.0, 0.0);
					format(string, sizeof(string), "* %s takes out some %s from their %s, and hands it to %s.", GetPlayerNameEx(fromplayerid), itemtype[itemid], storagetype[fromstorageid], GetPlayerNameEx(playerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

					new ipplayerid[16], ipfromplayerid[16];
					GetPlayerIp(playerid, ipplayerid, sizeof(ipplayerid));
					GetPlayerIp(fromplayerid, ipfromplayerid, sizeof(ipfromplayerid));

					if(PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[fromplayerid][pAdmin] >= 2)
					{
						format(string, sizeof(string), "[Admin] %s(%d) (IP:%s) has given %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ipplayerid);
						Log("logs/adminpay.log", string);
						format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s has given %s %s to %s", GetPlayerNameEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid));
						if(!strcmp(GetPlayerIpEx(playerid),  GetPlayerIpEx(fromplayerid), true)) strcat(string, " (1)");
						ABroadCast(COLOR_YELLOW, string, 4);
					}
					else
					{
						format(string, sizeof(string), "%s(%d) (IP:%s) has given %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ipplayerid);
						Log("logs/pay.log", string);
						format(string, sizeof(string), "%s (IP:%s) has given %s %s to %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						if(amount >= 100000 && PlayerInfo[fromplayerid][pLevel] <= 3 && itemid == 1) ABroadCast(COLOR_YELLOW, string, 2);
						if(amount >= 1000000 && itemid == 1)	ABroadCast(COLOR_YELLOW,string,2);
					}
				}
				return 1;
			}
			if(itemid == 3 && (StorageInfo[playerid][2][sCrack] + amount <= briefcaselimit[itemid-1]))
			{
				// Check if Sending Player has sufficient amount.
				if(fromplayerid != -1 && fromstorageid != -1)
				{
					if(fromstorageid == 0)
					{
						if(PlayerInfo[fromplayerid][pCrack] < amount)
						{
							format(string, sizeof(string), "You do not have sufficient amount to give %d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}
					else
					{
						if(StorageInfo[fromplayerid][fromstorageid-1][sCrack] < amount)
						{
							format(string, sizeof(string), "You do not have sufficient amount to give %d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}

					if(fromstorageid == 0) PlayerInfo[fromplayerid][pCrack] -= amount;
					else StorageInfo[fromplayerid][fromstorageid-1][sCrack] -= amount;
				}
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				StorageInfo[playerid][2][sCrack] += amount;
				format(string, sizeof(string), "%d Crack has been transfered to your Briefcase. (%d/%d)", amount, StorageInfo[playerid][2][sCrack], briefcaselimit[itemid-1]);
				SendClientMessage(playerid, COLOR_WHITE, string);

				if(fromplayerid != -1 && fromstorageid != -1 && playerid != fromplayerid) {
					format(string, sizeof(string), "%d Crack has been transfered from your %s to %s's %s.", amount, storagetype[fromstorageid], GetPlayerNameEx(playerid), storagetype[storageid]);
					SendClientMessage(fromplayerid, COLOR_WHITE, string);

					PlayerPlaySound(fromplayerid, 1052, 0.0, 0.0, 0.0);
					format(string, sizeof(string), "* %s takes out some %s from their %s, and hands it to %s.", GetPlayerNameEx(fromplayerid), itemtype[itemid], storagetype[fromstorageid], GetPlayerNameEx(playerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

					new ipplayerid[16], ipfromplayerid[16];
					GetPlayerIp(playerid, ipplayerid, sizeof(ipplayerid));
					GetPlayerIp(fromplayerid, ipfromplayerid, sizeof(ipfromplayerid));

					if(PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[fromplayerid][pAdmin] >= 2)
					{
						format(string, sizeof(string), "[Admin] %s(%d) (IP:%s) has given %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ipplayerid);
						Log("logs/adminpay.log", string);
						format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s has given %s %s to %s", GetPlayerNameEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid));
						if(!strcmp(GetPlayerIpEx(playerid),  GetPlayerIpEx(fromplayerid), true)) strcat(string, " (1)");
						ABroadCast(COLOR_YELLOW, string, 4);
					}
					else
					{
						format(string, sizeof(string), "%s(%d) (IP:%s) has given %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ipplayerid);
						Log("logs/pay.log", string);
						format(string, sizeof(string), "%s (IP:%s) has given %s %s to %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						if(amount >= 100000 && PlayerInfo[fromplayerid][pLevel] <= 3 && itemid == 1) ABroadCast(COLOR_YELLOW, string, 2);
						if(amount >= 1000000 && itemid == 1)	ABroadCast(COLOR_YELLOW,string,2);
					}
				}
				return 1;
			}
			if(itemid == 4 && (StorageInfo[playerid][2][sMats] + amount <= briefcaselimit[itemid-1]))
			{
				// Check if Sending Player has sufficient amount.
				if(fromplayerid != -1 && fromstorageid != -1)
				{
					if(fromstorageid == 0)
					{
						if(PlayerInfo[fromplayerid][pMats] < amount)
						{
							format(string, sizeof(string), "You do not have sufficient amount to give $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}
					else
					{
						if(StorageInfo[fromplayerid][fromstorageid-1][sMats] < amount)
						{
							format(string, sizeof(string), "You do not have sufficient amount to give $%d %s.", amount, itemtype[itemid]);
							SendClientMessageEx(fromplayerid, COLOR_WHITE, string);
							return 0;
						}
					}

					if(fromstorageid == 0) PlayerInfo[fromplayerid][pMats] -= amount;
					else StorageInfo[fromplayerid][fromstorageid-1][sMats] -= amount;
				}
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				StorageInfo[playerid][2][sMats] += amount;
				format(string, sizeof(string), "%d Materials has been transfered to your Briefcase (%d/%d).", amount, StorageInfo[playerid][2][sMats], briefcaselimit[itemid-1]);
				SendClientMessage(playerid, COLOR_WHITE, string);

				if(fromplayerid != -1 && fromstorageid != -1 && playerid != fromplayerid) {
					format(string, sizeof(string), "%d Materials has been transfered from your %s to %s's %s.", amount, storagetype[fromstorageid], GetPlayerNameEx(playerid), storagetype[storageid]);
					SendClientMessage(fromplayerid, COLOR_WHITE, string);

					PlayerPlaySound(fromplayerid, 1052, 0.0, 0.0, 0.0);
					format(string, sizeof(string), "* %s takes out some %s from their %s, and hands it to %s.", GetPlayerNameEx(fromplayerid), itemtype[itemid], storagetype[fromstorageid], GetPlayerNameEx(playerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

					new ipplayerid[16], ipfromplayerid[16];
					GetPlayerIp(playerid, ipplayerid, sizeof(ipplayerid));
					GetPlayerIp(fromplayerid, ipfromplayerid, sizeof(ipfromplayerid));

					if(PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[fromplayerid][pAdmin] >= 2)
					{
						format(string, sizeof(string), "[Admin] %s(%d) (IP:%s) has given %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ipplayerid);
						Log("logs/adminpay.log", string);
						format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s has given %s %s to %s", GetPlayerNameEx(fromplayerid), number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid));
						if(!strcmp(GetPlayerIpEx(playerid),  GetPlayerIpEx(fromplayerid), true)) strcat(string, " (1)");
						ABroadCast(COLOR_YELLOW, string, 4);
					}
					else
					{
						format(string, sizeof(string), "%s(%d) (IP:%s) has given %s %s to %s(%d) (IP:%s)", GetPlayerNameEx(fromplayerid), GetPlayerSQLId(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ipplayerid);
						Log("logs/pay.log", string);
						format(string, sizeof(string), "%s (IP:%s) has given %s %s to %s (IP:%s)", GetPlayerNameEx(fromplayerid), ipfromplayerid, number_format(amount), itemtype[itemid], GetPlayerNameEx(playerid), ipplayerid);
						if(amount >= 100000 && PlayerInfo[fromplayerid][pLevel] <= 3 && itemid == 1) ABroadCast(COLOR_YELLOW, string, 2);
						if(amount >= 1000000 && itemid == 1)	ABroadCast(COLOR_YELLOW,string,2);
					}
				}
				return 1;
			}

			if(itemid == 1) format(string, sizeof(string), "Unable to transfer $%d to %s ($%d/$%d).", amount, storagetype[storageid], StorageInfo[playerid][2][sCash], briefcaselimit[itemid-1]);
			else if(itemid == 2) format(string, sizeof(string), "Unable to transfer %d %s to %s (%d/%d).", amount, itemtype[itemid], storagetype[storageid], StorageInfo[playerid][2][sPot], briefcaselimit[itemid-1]);
			else if(itemid == 3) format(string, sizeof(string), "Unable to transfer %d %s to %s (%d/%d).", amount, itemtype[itemid], storagetype[storageid], StorageInfo[playerid][2][sCrack], briefcaselimit[itemid-1]);
			else if(itemid == 4) format(string, sizeof(string), "Unable to transfer %d %s to %s (%d/%d).", amount, itemtype[itemid], storagetype[storageid], StorageInfo[playerid][2][sMats], briefcaselimit[itemid-1]);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
		}
	}
	return 0;
}

stock ShowInventory(playerid,targetid)
{
	if(IsPlayerConnected(targetid))
	{
		new resultline[1024], header[64], pnumber[20];
		if(PlayerInfo[targetid][pPnumber] == 0) pnumber = "None"; else format(pnumber, sizeof(pnumber), "%d", PlayerInfo[targetid][pPnumber]);

		new totalwealth;
		totalwealth = PlayerInfo[targetid][pAccount] + GetPlayerCash(targetid);
		if(PlayerInfo[targetid][pPhousekey] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[targetid][pPhousekey]][hOwnerID] == GetPlayerSQLId(targetid)) totalwealth += HouseInfo[PlayerInfo[targetid][pPhousekey]][hSafeMoney];
		if(PlayerInfo[targetid][pPhousekey2] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[targetid][pPhousekey2]][hOwnerID] == GetPlayerSQLId(targetid)) totalwealth += HouseInfo[PlayerInfo[targetid][pPhousekey2]][hSafeMoney];
		if(PlayerInfo[targetid][pPhousekey3] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[targetid][pPhousekey3]][hOwnerID] == GetPlayerSQLId(targetid)) totalwealth += HouseInfo[PlayerInfo[targetid][pPhousekey3]][hSafeMoney];
		
		SetPVarInt(playerid, "ShowInventory", targetid);
		format(header, sizeof(header), "Showing Inventory of %s", GetPlayerNameEx(targetid));
		format(resultline, sizeof(resultline),"Total Wealth: $%s\n\
		Cash: $%s\n\
		Bank: $%s\n\
		Phone Number: %s\n\
		Radio Frequency: %dkhz\n\
		VIP Tokens: %s\n\
		Paintball Tokens: %s\n\
		EXP Tokens: %s\n\
		EXP Hours: %s\n\
		Event Tokens: %s\n\
		Materials: %s\n\
		Crack: %s\n\
		Pot: %s\n\
		Heroin: %s\n\
		Crates: %s\n\
		Paper: %s\n\
		Rope: %s\n\
		Cigars: %s\n\
		Sprunk Cans: %s\n\
		Spraycans: %s\n\
		Screwdrivers: %s\n\
		SMSLog: %d\n\
		Wristwatch: %d\n\
		Surveillance: %d\n\
		Tire: %d",
		number_format(totalwealth),
		number_format(GetPlayerCash(targetid)),
		number_format(PlayerInfo[targetid][pAccount]),
		pnumber,
		PlayerInfo[targetid][pRadioFreq],
		number_format(PlayerInfo[targetid][pTokens]),
		number_format(PlayerInfo[targetid][pPaintTokens]),
		number_format(PlayerInfo[targetid][pEXPToken]),
		number_format(PlayerInfo[targetid][pDoubleEXP]),
		number_format(PlayerInfo[targetid][pEventTokens]),
		number_format(PlayerInfo[targetid][pMats]),
		number_format(PlayerInfo[targetid][p_iDrug][5]),
		number_format(PlayerInfo[targetid][p_iDrug][1]),
		number_format(PlayerInfo[targetid][p_iDrug][3]),
		number_format(PlayerInfo[targetid][pCrates]),
		number_format(PlayerInfo[targetid][pPaper]),
		number_format(PlayerInfo[targetid][pRope]),
		number_format(PlayerInfo[targetid][pCigar]),
		number_format(PlayerInfo[targetid][pSprunk]),
		number_format(PlayerInfo[targetid][pSpraycan]),
		number_format(PlayerInfo[targetid][pScrewdriver]),
		PlayerInfo[targetid][pSmslog],
		PlayerInfo[targetid][pWristwatch],
		PlayerInfo[targetid][pSurveillance],
		PlayerInfo[targetid][pTire]);
		format(resultline, sizeof(resultline),"%s\n\
		Tool Box Usages: %d\n\
		Crowbar: %d\n\
		Gold Giftbox Tokens: %s",
		resultline,
		PlayerInfo[targetid][pToolBox],
		PlayerInfo[targetid][pCrowBar],
		number_format(PlayerInfo[targetid][pGoldBoxTokens]));
		ShowPlayerDialogEx(playerid, DISPLAY_INV, DIALOG_STYLE_MSGBOX, header, resultline, "Next Page", "Close");
	}
	return 1;
}

stock FindGunInVehicleForPlayer(ownerid, slot, playerid)
{
	new
		i = 0;
	while (i < (PlayerVehicleInfo[ownerid][slot][pvWepUpgrade] + 1) && (!PlayerVehicleInfo[ownerid][slot][pvWeapons][i] || PlayerInfo[playerid][pGuns][GetWeaponSlot(PlayerVehicleInfo[ownerid][slot][pvWeapons][i])] == PlayerVehicleInfo[ownerid][slot][pvWeapons][i]))
	{
		i++;
	}
	if (i == (PlayerVehicleInfo[ownerid][slot][pvWepUpgrade] + 1)) return -1;
	return i;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	szMiscArray[0] = 0;
	switch(dialogid)
	{
		case DISPLAY_INV:
		{
			new targetid = GetPVarInt(playerid, "ShowInventory");
			if(IsPlayerConnected(targetid))
			{
				if(response)
				{
					new resultline[1024], header[64];

					format(header, sizeof(header), "Showing Inventory of %s", GetPlayerNameEx(targetid));
					format(resultline, sizeof(resultline),"Lock: %d\n\
					First Aid Kit: %d\n\
					RC Cam: %d\n\
					Receiver: %d\n\
					GPS: %d\n\
					Bug Sweep: %d\n\
					Firework: %d\n\
					Boombox: %d\n\
					Mailbox: %d\n\
					Metal Detector: %d\n\
					Energy Bars: %d\n\
					House Sale Sign: %d\n\
					Fuel Canisters: %d\n\
					Jump Starts: %d\n\
					Restricted Car Colors: %d\n\
					Restricted Skins: %d\n\
					Rim Kits: %d\n\
					1 month PVIP Voucher: %d\n\
					Checks: %s\n\
					Additional Vehicle Slots: %s\n\
					Additional Toy Slots: %s",
					PlayerInfo[targetid][pLock],
					PlayerInfo[targetid][pFirstaid],
					PlayerInfo[targetid][pRccam],
					PlayerInfo[targetid][pReceiver],
					PlayerInfo[targetid][pGPS],
					PlayerInfo[targetid][pSweep],
					PlayerInfo[targetid][pFirework],
					PlayerInfo[targetid][pBoombox],
					PlayerInfo[targetid][pMailbox],
					PlayerInfo[targetid][pMetalDetector],
					PlayerInfo[targetid][mInventory][4],
					PlayerInfo[playerid][mInventory][6],
					PlayerInfo[playerid][mInventory][7],
					PlayerInfo[playerid][mInventory][8],
					PlayerInfo[playerid][mInventory][9],
					PlayerInfo[playerid][mInventory][13],
					PlayerInfo[targetid][pRimMod],
					PlayerInfo[targetid][pPVIPVoucher],
					number_format(PlayerInfo[targetid][pChecks]),
					number_format(PlayerInfo[targetid][pVehicleSlot]),
					number_format(PlayerInfo[targetid][pToySlot]));
					if(zombieevent) format(resultline, sizeof(resultline), "%s\nCure Vials: %d\nScrap Metal: %d\n.50 Cal Ammo: %d\nAntibiotic Injections: %d\nSurvivor Kits: %d\nFuel Can: %d%% Fuel", resultline, PlayerInfo[targetid][pVials], PlayerInfo[targetid][mInventory][16], PlayerInfo[targetid][mInventory][17], PlayerInfo[targetid][mPurchaseCount][18], PlayerInfo[targetid][mInventory][19], PlayerInfo[targetid][zFuelCan]);
					ShowPlayerDialogEx(playerid, DISPLAY_INV2, DIALOG_STYLE_MSGBOX, header, resultline, "First Page", "Close");
				}
				else DeletePVar(playerid, "ShowInventory");
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GRAD1, "The player you were checking has logged out.");
				DeletePVar(playerid, "ShowInventory");
				return 1;
			}
		}
		case DISPLAY_INV2:
		{
			new targetid = GetPVarInt(playerid, "ShowInventory");
			if(IsPlayerConnected(targetid))
			{
				if(response)
				{
					ShowInventory(playerid, targetid);
				}
				else DeletePVar(playerid, "ShowInventory");
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GRAD1, "The player you were checking has logged out.");
				DeletePVar(playerid, "ShowInventory");
				return 1;
			}
		}
	}
	return 1;
}

/*CMD:storagehelp(playerid, params[])
{
	SendClientMessageEx(playerid, COLOR_GREEN,"_______________________________________");
    SendClientMessageEx(playerid, COLOR_WHITE,"*** HELP *** - type a command for more infomation.");
    SendClientMessageEx(playerid, COLOR_GRAD3,"*** STORAGE *** /(vs)viewstorage /(es)equipstorage /personalwithdraw /personaldeposit /storagegive");
	SendClientMessageEx(playerid, COLOR_GRAD3,"*** STORAGE *** /transferstorage");
    return 1;
}*/

CMD:inv(playerid, params[]) {
	return cmd_inventory(playerid, params);
}

CMD:inventory(playerid, params[])
{
	if(gPlayerLogged{playerid} != 0) ShowInventory(playerid, playerid);
	return 1;
}

CMD:trunkput(playerid, params[])
{
	if(GetPVarType(playerid, "IsInArena"))
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this right now, you are in an arena!");
		return 1;
	}
	if(GetPVarInt( playerid, "EventToken") != 0)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You can't use this while you're in an event.");
		return 1;
	}
	if(IsPlayerInAnyVehicle(playerid)) { SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this while being inside the vehicle!"); return 1; }
	if(GetPVarInt(playerid, "EMSAttempt") != 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can't use this command!");

	new string[128], weaponchoice[32], slot;
	if(sscanf(params, "s[32]D(0)", weaponchoice, slot)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /trunkput [weapon/drugs] [slot]");

	new pvid = -1, Float: x, Float: y, Float: z;

	for(new d = 0 ; d < MAX_PLAYERVEHICLES; d++)
	{
		if(PlayerVehicleInfo[playerid][d][pvId] != INVALID_PLAYER_VEHICLE_ID) GetVehiclePos(PlayerVehicleInfo[playerid][d][pvId], x, y, z);
		if(IsPlayerInRangeOfPoint(playerid, 3.0, x, y, z))
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

	new Float: Health;
	GetHealth(playerid, Health);
	if(Health < 80.0) return SendClientMessageEx(playerid,COLOR_GREY,"You cannot store weapons or drugs in a car when your health lower than 80.");
	if (GetPVarInt(playerid, "GiveWeaponTimer") > 0)
	{
		format(string, sizeof(string), "   You must wait %d seconds before depositing another weapon.", GetPVarInt(playerid, "GiveWeaponTimer"));
		SendClientMessageEx(playerid,COLOR_GREY,string);
		return 1;
	}

	if(strcmp(weaponchoice, "drugs", true) == 0) {
		Drugs_ShowTrunkMenu(playerid, pvid, 1);
		return 1;
	}
	
	new maxslots = PlayerVehicleInfo[playerid][pvid][pvWepUpgrade]+1;
	if(slot > maxslots)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "Invalid slot.");
		return 1;
	}

	if( PlayerVehicleInfo[playerid][pvid][pvWeapons][slot-1] != 0)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You have a weapon stored in that slot already.");
		return 1;
	}

	new weapon;
	if(strcmp(weaponchoice, "sdpistol", true, strlen(weaponchoice)) == 0)
	{
		if(pTazer{playerid} == 1) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot store a tazer!");
		if( PlayerInfo[playerid][pGuns][2] == 23 && PlayerInfo[playerid][pAGuns][2] == 0 )
		{
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have deposited a silenced pistol into your car gun locker.");
			weapon = PlayerInfo[playerid][pGuns][2];
			format(string,sizeof(string), "* %s deposited their silenced pistol in their car safe.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
		}
	}
	else if(strcmp(weaponchoice, "9mm", true, strlen(weaponchoice)) == 0)
	{
		if( PlayerInfo[playerid][pGuns][2] == 22 && PlayerInfo[playerid][pAGuns][2] == 0 )
		{
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have deposited a 9mm in your car gun locker.");
			weapon = PlayerInfo[playerid][pGuns][2];
			format(string,sizeof(string), "* %s deposited their 9mm in their car safe.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
		}
	}
	else if(strcmp(weaponchoice, "deagle", true, strlen(weaponchoice)) == 0)
	{
		if( PlayerInfo[playerid][pGuns][2] == 24 && PlayerInfo[playerid][pAGuns][2] == 0 )
		{
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have deposited a Desert Eagle in your car gun locker.");
			weapon = PlayerInfo[playerid][pGuns][2];
			format(string,sizeof(string), "* %s deposited their Desert Eagle in their car safe.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
		}
	}
	else if(strcmp(weaponchoice, "shotgun", true, strlen(weaponchoice)) == 0)
	{
		if( PlayerInfo[playerid][pGuns][3] == 25 && PlayerInfo[playerid][pAGuns][3] == 0 )
		{
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have deposited a shotgun in your car gun locker.");
			weapon = PlayerInfo[playerid][pGuns][3];
			format(string,sizeof(string), "* %s deposited their Shotgun in their car safe.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
		}
	}
	else if(strcmp(weaponchoice, "spas12", true, strlen(weaponchoice)) == 0)
	{
		if( PlayerInfo[playerid][pGuns][3] == 27 && PlayerInfo[playerid][pAGuns][3] == 0 )
		{
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have deposited a combat shotgun in your car gun locker.");
			weapon = PlayerInfo[playerid][pGuns][3];
			format(string,sizeof(string), "* %s deposited their Combat Shotgun in their car safe.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
		}
	}
	else if(strcmp(weaponchoice, "mp5", true, strlen(weaponchoice)) == 0)
	{
		if( PlayerInfo[playerid][pGuns][4] == 29 && PlayerInfo[playerid][pAGuns][4] == 0 )
		{
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have deposited an MP5 in your car gun locker.");
			weapon = PlayerInfo[playerid][pGuns][4];
			format(string,sizeof(string), "* %s deposited their MP5 in their car safe.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
		}
	}

	else if(strcmp(weaponchoice, "ak47", true, strlen(weaponchoice)) == 0)
	{
		if( PlayerInfo[playerid][pGuns][5] == 30 && PlayerInfo[playerid][pAGuns][5] == 0 )
		{
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have deposited an AK-47 in your car gun locker.");
			weapon = PlayerInfo[playerid][pGuns][5];
			format(string,sizeof(string), "* %s deposited their AK-47 in their car safe.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
		}
	}
	else if(strcmp(weaponchoice, "m4", true, strlen(weaponchoice)) == 0)
	{
		if( PlayerInfo[playerid][pGuns][5] == 31 && PlayerInfo[playerid][pAGuns][5] == 0 )
		{
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have deposited an M4 in your car gun locker.");
			weapon = PlayerInfo[playerid][pGuns][5];
			format(string,sizeof(string), "* %s deposited their M4 in their car safe.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
		}
	}
	else if(strcmp(weaponchoice, "rifle", true, strlen(weaponchoice)) == 0)
	{
		if( PlayerInfo[playerid][pGuns][6] == 33 && PlayerInfo[playerid][pAGuns][6] == 0 )
		{
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have deposited a rifle in your car gun locker.");
			weapon = PlayerInfo[playerid][pGuns][6];
			format(string,sizeof(string), "* %s deposited their rifle in their car safe.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
		}
	}
	else if(strcmp(weaponchoice, "sniper", true, strlen(weaponchoice)) == 0)
	{
		if( PlayerInfo[playerid][pGuns][6] == 34 && PlayerInfo[playerid][pAGuns][6] == 0 )
		{
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have deposited a sniper rifle in your car gun locker.");
			weapon = PlayerInfo[playerid][pGuns][6];
			format(string,sizeof(string), "* %s deposited their sniper rifle in their car safe.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
		}
	}
	else if(strcmp(weaponchoice, "golfclub", true, strlen(weaponchoice)) == 0)
	{
		if( PlayerInfo[playerid][pGuns][1] == 2 && PlayerInfo[playerid][pAGuns][1] == 0 )
		{
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have deposited a golf club in your car gun locker.");
			weapon = PlayerInfo[playerid][pGuns][1];
			format(string,sizeof(string), "* %s deposited their golf club in their car safe.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
		}
	}
	else if(strcmp(weaponchoice, "baseballbat", true, strlen(weaponchoice)) == 0)
	{
		if( PlayerInfo[playerid][pGuns][1] == 5 && PlayerInfo[playerid][pAGuns][1] == 0 )
		{
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have deposited a baseball bat in your car gun locker.");
			weapon = PlayerInfo[playerid][pGuns][1];
			format(string,sizeof(string), "* %s deposited their baseball bat in their car safe.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
		}
	}
	else if(strcmp(weaponchoice, "shovel", true, strlen(weaponchoice)) == 0)
	{
		if( PlayerInfo[playerid][pGuns][1] == 6 && PlayerInfo[playerid][pAGuns][1] == 0 )
		{
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have deposited a shovel in your car gun locker.");
			weapon = PlayerInfo[playerid][pGuns][1];
			format(string,sizeof(string), "* %s deposited their shovel in their car safe.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
		}
	}
	else if(strcmp(weaponchoice, "poolcue", true, strlen(weaponchoice)) == 0)
	{
		if( PlayerInfo[playerid][pGuns][1] == 7 && PlayerInfo[playerid][pAGuns][1] == 0 )
		{
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have deposited a pool cue in your car gun locker.");
			weapon = PlayerInfo[playerid][pGuns][1];
			format(string,sizeof(string), "* %s deposited their pool cue in their car safe.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
		}
	}
	else if(strcmp(weaponchoice, "katana", true, strlen(weaponchoice)) == 0)
	{
		if( PlayerInfo[playerid][pGuns][1] == 8 && PlayerInfo[playerid][pAGuns][1] == 0 )
		{
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have deposited a katana in your car gun locker.");
			weapon = PlayerInfo[playerid][pGuns][1];
			format(string,sizeof(string), "* %s deposited their katana in their car safe.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
		}
	}
	else if(strcmp(weaponchoice, "cane", true, strlen(weaponchoice)) == 0)
	{
		if( PlayerInfo[playerid][pGuns][10] == 15 && PlayerInfo[playerid][pAGuns][1] == 0 )
		{
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have deposited a cane in your car gun locker.");
			weapon = PlayerInfo[playerid][pGuns][10];
			format(string,sizeof(string), "* %s deposited their cane in their car safe.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
		}
	}
	else if(strcmp(weaponchoice, "flowers", true, strlen(weaponchoice)) == 0)
	{
		if( PlayerInfo[playerid][pGuns][10] == 14 && PlayerInfo[playerid][pAGuns][1] == 0 )
		{
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have deposited flowers in your car gun locker.");
			weapon = PlayerInfo[playerid][pGuns][10];
			format(string,sizeof(string), "* %s deposited their flowers in their car safe.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
		}
	}
	else if(strcmp(weaponchoice, "parachute", true, strlen(weaponchoice)) == 0)
	{
		if( PlayerInfo[playerid][pGuns][11] == 46 && PlayerInfo[playerid][pAGuns][1] == 0 )
		{
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have deposited a parachute in your car gun locker.");
			weapon = PlayerInfo[playerid][pGuns][11];
			format(string,sizeof(string), "* %s deposited their parachute in their car safe.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
		}
	}
	else if(strcmp(weaponchoice, "dildo", true, strlen(weaponchoice)) == 0)
	{
		if( PlayerInfo[playerid][pGuns][10] == 10 && PlayerInfo[playerid][pAGuns][1] == 0 )
		{
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have deposited a dildo in your car gun locker.");
			weapon = PlayerInfo[playerid][pGuns][10];
			format(string,sizeof(string), "* %s deposited their dildo in their car safe.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
		}
	}	
	else { SendClientMessageEx(playerid,COLOR_GREY,"   Invalid weapon name!"); return 1; }
	if(weapon == 0) return SendClientMessageEx(playerid, COLOR_GREY, "You don't have that weapon.");
	if(PlayerVehicleInfo[playerid][pvid][pvWeapons][slot-1] == 0)
	{
		PlayerVehicleInfo[playerid][pvid][pvWeapons][slot-1] = weapon;
		RemovePlayerWeapon(playerid, weapon);
		g_mysql_SaveVehicle(playerid, pvid);
	}
	return 1;
}

CMD:trunktake(playerid, params[]) {
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this while you're inside a vehicle.");
	if(PlayerInfo[playerid][pAccountRestricted] != 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "Your account is restricted!");
	else if(GetPVarType(playerid, "IsInArena")) return SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this right now, you are in an arena!");
	else if(GetPVarInt( playerid, "EventToken") != 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use this while you're in an event.");
	else if(PlayerInfo[playerid][pConnectHours] < 2 || PlayerInfo[playerid][pWRestricted] > 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "You cannot use this as you are currently restricted from possessing weapons!");
	else if(GetPVarInt(playerid, "GiveWeaponTimer") >= 1)
	{
		new szMessage[59];
		format(szMessage, sizeof(szMessage), "   You must wait %d seconds before getting another weapon.", GetPVarInt(playerid, "GiveWeaponTimer"));
		return SendClientMessageEx(playerid, COLOR_GREY, szMessage);
	}

	new
		Float: fVehPos[3],
		iWeaponSlot = strval(params);

	for(new d = 0 ; d < MAX_PLAYERVEHICLES; d++) {
		if(PlayerVehicleInfo[playerid][d][pvId] != INVALID_PLAYER_VEHICLE_ID) {
			GetVehiclePos(PlayerVehicleInfo[playerid][d][pvId], fVehPos[0], fVehPos[1], fVehPos[2]);
			if(IsPlayerInRangeOfPoint(playerid, 4.0, fVehPos[0], fVehPos[1], fVehPos[2])) {
				if(isnull(params)) {

					new
						szMessage[64];

					format(szMessage, sizeof(szMessage), "*** %s's %s Safe ***", GetPlayerNameEx(playerid), GetVehicleName(PlayerVehicleInfo[playerid][d][pvId]));
					SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
					for(new s = 0; s < 3; s++) if(PlayerVehicleInfo[playerid][d][pvWeapons][s] != 0) {

						new
							szWeapon[16];

						GetWeaponName(PlayerVehicleInfo[playerid][d][pvWeapons][s], szWeapon, sizeof(szWeapon));
						format(szMessage, sizeof(szMessage), "Slot %d: %s", s+1, szWeapon);
						SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
					}
					return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /trunktake [drugs/slot]");
				}
				else if(GetVehicleModel(PlayerVehicleInfo[playerid][d][pvId]) == 481 || GetVehicleModel(PlayerVehicleInfo[playerid][d][pvId]) == 509) {
					return SendClientMessageEx(playerid,COLOR_GREY,"That vehicle doesn't have a trunk.");
				}

				new
					engine, lights, alarm, doors, bonnet, boot, objective;

				GetVehicleParamsEx(PlayerVehicleInfo[playerid][d][pvId], engine, lights, alarm, doors, bonnet, boot, objective);

				if(boot == VEHICLE_PARAMS_OFF || boot == VEHICLE_PARAMS_UNSET) {
					return SendClientMessageEx(playerid, COLOR_GRAD3, "You can't take weapons from the trunk if it's closed! /car trunk to open it.");
				}

				if(strcmp(params, "drugs", true) == 0) {
					Drugs_ShowTrunkMenu(playerid, d, 0);
					return 1;
				}

				if(!(1 <= iWeaponSlot <= PlayerVehicleInfo[playerid][d][pvWepUpgrade] + 1)) {
					return SendClientMessageEx(playerid, COLOR_GREY, "Invalid slot specified.");
				}
				else if(PlayerVehicleInfo[playerid][d][pvWeapons][iWeaponSlot - 1] != 0) {
					new
						szWeapon[16],
						szMessage[128];

					GetWeaponName(PlayerVehicleInfo[playerid][d][pvWeapons][iWeaponSlot - 1], szWeapon, sizeof(szWeapon));
					GivePlayerValidWeapon(playerid, PlayerVehicleInfo[playerid][d][pvWeapons][iWeaponSlot - 1], 0);
					PlayerVehicleInfo[playerid][d][pvWeapons][iWeaponSlot - 1] = 0;
					g_mysql_SaveVehicle(playerid, d);

					format(szMessage, sizeof(szMessage), "You have withdrawn a %s from your car gun locker.", szWeapon);
					SendClientMessageEx(playerid, COLOR_WHITE, szMessage);

					format(szMessage, sizeof(szMessage), "* %s has withdrawn a %s from their car safe.", GetPlayerNameEx(playerid), szWeapon);
					return ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				}
				else return SendClientMessageEx(playerid, COLOR_WHITE, "You don't have a weapon stored in that slot.");
			}
		}
	}
	return SendClientMessageEx(playerid,COLOR_GREY,"You are not near any vehicle that you own.");
}

CMD:storegun(playerid, params[])
{
	if(Homes[playerid] > 0)
	{
		if(GetPVarType(playerid, "IsInArena")) return SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this right now, you are in an arena!");
		if(GetPVarInt( playerid, "EventToken") != 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use this while you're in an event.");
		if(GetPVarType(playerid, "PlayerCuffed") || GetPVarType(playerid, "Injured") || GetPVarType(playerid, "IsFrozen")) return SendClientMessage(playerid, COLOR_GRAD2, "You can't do that at this time!");
		new string[128], weaponchoice[32], slot;
		if(sscanf(params, "s[32]d", weaponchoice, slot)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /storegun [weapon] [slot]");

		for(new i; i < MAX_HOUSES; i++)
		{
			if(GetPlayerSQLId(playerid) == HouseInfo[i][hOwnerID] && IsPlayerInRangeOfPoint(playerid, 50, HouseInfo[i][hInteriorX], HouseInfo[i][hInteriorY], HouseInfo[i][hInteriorZ]) && GetPlayerVirtualWorld(playerid) == HouseInfo[i][hIntVW] && GetPlayerInterior(playerid) == HouseInfo[i][hIntIW])
			{
				if (GetPVarInt(playerid, "GiveWeaponTimer") > 0)
				{
					format(string, sizeof(string), "   You must wait %d seconds before depositing another weapon.", GetPVarInt(playerid, "GiveWeaponTimer"));
					SendClientMessageEx(playerid,COLOR_GREY,string);
					return 1;
				}

				new maxslots = HouseInfo[i][hGLUpgrade];
				if(slot > maxslots)
				{
					SendClientMessageEx(playerid, COLOR_GREY, "Invalid slot.");
					return 1;
				}

				if( HouseInfo[i][hWeapons][slot-1] != 0)
				{
					SendClientMessageEx(playerid, COLOR_GREY, "You have a weapon stored in that slot already.");
					return 1;
				}

				new weapon;
				if(strcmp(weaponchoice, "sdpistol", true, strlen(weaponchoice)) == 0)
				{
					if( PlayerInfo[playerid][pGuns][2] == 23 && PlayerInfo[playerid][pAGuns][2] == 0 )
					{
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have deposited a silenced pistol into your gun locker.");
						weapon = PlayerInfo[playerid][pGuns][2];
						format(string,sizeof(string), "* %s deposited their silenced pistol in their house safe.", GetPlayerNameEx(playerid));
						ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
						SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
					}
				}
				else if(strcmp(weaponchoice, "deagle", true, strlen(weaponchoice)) == 0)
				{
					if( PlayerInfo[playerid][pGuns][2] == 24 && PlayerInfo[playerid][pAGuns][2] == 0 )
					{
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have deposited a Desert Eagle in your gun locker.");
						weapon = PlayerInfo[playerid][pGuns][2];
						format(string,sizeof(string), "* %s deposited their Desert Eagle in their house safe.", GetPlayerNameEx(playerid));
						ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
						SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
					}
				}
				else if(strcmp(weaponchoice, "shotgun", true, strlen(weaponchoice)) == 0)
				{
					if( PlayerInfo[playerid][pGuns][3] == 25 && PlayerInfo[playerid][pAGuns][3] == 0 )
					{
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have deposited a shotgun in your gun locker.");
						weapon = PlayerInfo[playerid][pGuns][3];
						format(string,sizeof(string), "* %s deposited their Shotgun in their house safe.", GetPlayerNameEx(playerid));
						ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
						SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
					}
				}
				else if(strcmp(weaponchoice, "spas12", true, strlen(weaponchoice)) == 0)
				{
					if( PlayerInfo[playerid][pGuns][3] == 27 && PlayerInfo[playerid][pAGuns][3] == 0 )
					{
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have deposited a combat shotgun in your gun locker.");
						weapon = PlayerInfo[playerid][pGuns][3];
						format(string,sizeof(string), "* %s deposited their Combat Shotgun in their house safe.", GetPlayerNameEx(playerid));
						ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
						SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
					}
				}
				else if(strcmp(weaponchoice, "mp5", true, strlen(weaponchoice)) == 0)
				{
					if( PlayerInfo[playerid][pGuns][4] == 29 && PlayerInfo[playerid][pAGuns][4] == 0 )
					{
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have deposited an MP5 in your gun locker.");
						weapon = PlayerInfo[playerid][pGuns][4];
						format(string,sizeof(string), "* %s deposited their MP5 in their house safe.", GetPlayerNameEx(playerid));
						ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
						SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
					}
				}
				else if(strcmp(weaponchoice, "ak47", true, strlen(weaponchoice)) == 0)
				{
					if( PlayerInfo[playerid][pGuns][5] == 30 && PlayerInfo[playerid][pAGuns][5] == 0 )
					{
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have deposited an AK-47 in your gun locker.");
						weapon = PlayerInfo[playerid][pGuns][5];
						format(string,sizeof(string), "* %s deposited their AK-47 in their house safe.", GetPlayerNameEx(playerid));
						ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
						SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
					}
				}
				else if(strcmp(weaponchoice, "m4", true, strlen(weaponchoice)) == 0)
				{
					if( PlayerInfo[playerid][pGuns][5] == 31 && PlayerInfo[playerid][pAGuns][5] == 0 )
					{
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have deposited an M4 in your gun locker.");
						weapon = PlayerInfo[playerid][pGuns][5];
						format(string,sizeof(string), "* %s deposited their M4 in their house safe.", GetPlayerNameEx(playerid));
						ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
						SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
					}
				}
				else if(strcmp(weaponchoice, "rifle", true, strlen(weaponchoice)) == 0)
				{
					if( PlayerInfo[playerid][pGuns][6] == 33 && PlayerInfo[playerid][pAGuns][6] == 0 )
					{
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have deposited a rifle in your gun locker.");
						weapon = PlayerInfo[playerid][pGuns][6];
						format(string,sizeof(string), "* %s deposited their rifle in their house safe.", GetPlayerNameEx(playerid));
						ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
						SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
					}
				}
				else if(strcmp(weaponchoice, "sniper", true, strlen(weaponchoice)) == 0)
				{
					if( PlayerInfo[playerid][pGuns][6] == 34 && PlayerInfo[playerid][pAGuns][6] == 0 )
					{
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have deposited a sniper rifle in your gun locker.");
						weapon = PlayerInfo[playerid][pGuns][6];
						format(string,sizeof(string), "* %s deposited their sniper rifle in their house safe.", GetPlayerNameEx(playerid));
						ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
						SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
					}
				}
				else if(strcmp(weaponchoice, "uzi", true, strlen(weaponchoice)) == 0)
				{
					if( PlayerInfo[playerid][pGuns][4] == 28 && PlayerInfo[playerid][pAGuns][4] == 0 )
					{
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have deposited an uzi in your gun locker.");
						weapon = PlayerInfo[playerid][pGuns][4];
						format(string,sizeof(string), "* %s deposited their uzi in their house safe.", GetPlayerNameEx(playerid));
						ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
						SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
					}
				}
				else if(strcmp(weaponchoice, "tec9", true, strlen(weaponchoice)) == 0)
				{
					if( PlayerInfo[playerid][pGuns][4] == 32 && PlayerInfo[playerid][pAGuns][4] == 0 )
					{
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have deposited a tec9 in your gun locker.");
						weapon = PlayerInfo[playerid][pGuns][4];
						format(string,sizeof(string), "* %s deposited their tec9 in their house safe.", GetPlayerNameEx(playerid));
						ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
						SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
					}
				}
				if(weapon == 0) return SendClientMessageEx(playerid, COLOR_GREY, "You don't have that weapon.");
				if(HouseInfo[i][hWeapons][slot-1] == 0)
				{
					HouseInfo[i][hWeapons][slot-1] = weapon;
					RemovePlayerWeapon(playerid, weapon);
					SaveHouse(i);
					return 1;
				}
				else { SendClientMessageEx(playerid,COLOR_GREY,"   Invalid weapon name!"); return 1; }
			}
		}
		SendClientMessageEx(playerid, COLOR_GREY, "You're not in a house that you own.");
	}
	else return SendClientMessageEx(playerid, COLOR_GREY, "You don't own a house.");
	return 1;
}

CMD:getgun(playerid, params[])
{
	if(Homes[playerid] > 0)
	{
		new string[128], slot;

		for(new i; i < MAX_HOUSES; i++)
		{
			if(GetPlayerSQLId(playerid) == HouseInfo[i][hOwnerID] && IsPlayerInRangeOfPoint(playerid, 50, HouseInfo[i][hInteriorX], HouseInfo[i][hInteriorY], HouseInfo[i][hInteriorZ]) && GetPlayerVirtualWorld(playerid) == HouseInfo[i][hIntVW] && GetPlayerInterior(playerid) == HouseInfo[i][hIntIW])
			{
				if(PlayerInfo[playerid][pConnectHours] < 2 || PlayerInfo[playerid][pWRestricted] > 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "You cannot use this as you are currently restricted from possessing weapons!");

				if(sscanf(params, "d", slot))
				{
					new weaponname[50];
					SendClientMessageEx(playerid, COLOR_GREEN, "________________________________________________");
					format(string, sizeof(string), "*** %s's Safe ***", GetPlayerNameEx(playerid));
					SendClientMessageEx(playerid, COLOR_WHITE, string);
					for(new s = 0; s < 5; s++)
					{
						if( HouseInfo[i][hWeapons][s] != 0 )
						{
							GetWeaponName(HouseInfo[i][hWeapons][s], weaponname, sizeof(weaponname));
							format(string, sizeof(string), "Slot %d: %s", s+1, weaponname);
							SendClientMessageEx(playerid, COLOR_WHITE, string);
						}
					}
					SendClientMessageEx(playerid, COLOR_GREEN, "________________________________________________");
					SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /getgun [slot]");
					return 1;
				}

				if (GetPVarInt(playerid, "GiveWeaponTimer") > 0)
				{
					format(string, sizeof(string), "   You must wait %d seconds before getting another weapon.", GetPVarInt(playerid, "GiveWeaponTimer"));
					SendClientMessageEx(playerid,COLOR_GREY,string);
					return 1;
				}
				new maxslots = HouseInfo[i][hGLUpgrade];
				if(slot > maxslots)
				{
					SendClientMessageEx(playerid, COLOR_GREY, "Invalid slot.");
					return 1;
				}

				if(HouseInfo[i][hWeapons][slot-1] != 0)
				{
					new weaponname[50];
					GetWeaponName(HouseInfo[i][hWeapons][slot-1], weaponname, sizeof(weaponname));
					GivePlayerValidWeapon(playerid, HouseInfo[i][hWeapons][slot-1], 0);
					HouseInfo[i][hWeapons][slot-1] = 0;
					if(strcmp(weaponname, "silenced pistol", true, strlen(weaponname)) == 0)
					{
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have withdrawn a silenced pistol from your gun locker.");
						format(string,sizeof(string), "* %s has withdrawn a silenced pistol from their house safe.", GetPlayerNameEx(playerid));
						ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
						SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
					}
					if(strcmp(weaponname, "desert eagle", true, strlen(weaponname)) == 0)
					{
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have withdrawn a Desert Eagle from your gun locker.");
						format(string,sizeof(string), "* %s has withdrawn a Desert Eagle from their house safe.", GetPlayerNameEx(playerid));
						ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
						SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
					}
					if(strcmp(weaponname, "shotgun", true, strlen(weaponname)) == 0)
					{
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have withdrawn a shotgun from your gun locker.");
						format(string,sizeof(string), "* %s has withdrawn a shotgun from their house safe.", GetPlayerNameEx(playerid));
						ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
						SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
					}
					if(strcmp(weaponname, "combat shotgun", true, strlen(weaponname)) == 0)
					{
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have withdrawn a combat shotgun from your gun locker.");
						format(string,sizeof(string), "* %s has withdrawn a combat shotgun from their house safe.", GetPlayerNameEx(playerid));
						ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
						SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
					}
					if(strcmp(weaponname, "mp5", true, strlen(weaponname)) == 0)
					{
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have withdrawn an MP5 from your gun locker.");
						format(string,sizeof(string), "* %s has withdrawn an MP5 from their house safe.", GetPlayerNameEx(playerid));
						ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
						SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
					}
					if(strcmp(weaponname, "ak47", true, strlen(weaponname)) == 0)
					{
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have withdrawn an AK-47 from your gun locker.");
						format(string,sizeof(string), "* %s has withdrawn an AK-47 from their house safe.", GetPlayerNameEx(playerid));
						ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
						SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
					}
					if(strcmp(weaponname, "m4", true, strlen(weaponname)) == 0)
					{
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have withdrawn an M4 from your gun locker.");
						format(string,sizeof(string), "* %s has withdrawn an M4 from their house safe.", GetPlayerNameEx(playerid));
						ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
						SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
					}
					if(strcmp(weaponname, "rifle", true, strlen(weaponname)) == 0)
					{
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have withdrawn a rifle from your gun locker.");
						format(string,sizeof(string), "* %s has withdrawn a rifle from their house safe.", GetPlayerNameEx(playerid));
						ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
						SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
					}
					if(strcmp(weaponname, "sniper rifle", true, strlen(weaponname)) == 0)
					{
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have withdrawn a sniper rifle from your gun locker.");
						SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
						format(string,sizeof(string), "* %s has withdrawn a sniper rifle from their house safe.", GetPlayerNameEx(playerid));
						ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
					}
					if(strcmp(weaponname, "micro smg", true, strlen(weaponname)) == 0)
					{
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have withdrawn an uzi from your gun locker.");
						SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
						format(string,sizeof(string), "* %s has withdrawn an uzi from their house safe.", GetPlayerNameEx(playerid));
						ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
					}
					if(strcmp(weaponname, "tec9", true, strlen(weaponname)) == 0)
					{
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have withdrawn an uzi from your gun locker.");
						SetPVarInt(playerid, "GiveWeaponTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
						format(string,sizeof(string), "* %s has withdrawn an uzi from their house safe.", GetPlayerNameEx(playerid));
						ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
					}
					SaveHouse(i);
					return 1;
				}
				else
				{
					SendClientMessageEx(playerid, COLOR_WHITE, "You don't have a weapon stored in that slot.");
					return 1;
				}
			}
		}
		SendClientMessageEx(playerid, COLOR_GREY, "You're not in a house that you own.");
	}
	else return SendClientMessageEx(playerid, COLOR_GREY, "You don't own a house.");
	return 1;
}


CMD:hwithdraw(playerid, params[])
{
	if(Homes[playerid] > 0)
	{
		for(new i; i < MAX_HOUSES; i++)
		{
			if(GetPlayerSQLId(playerid) == HouseInfo[i][hOwnerID] && IsPlayerInRangeOfPoint(playerid, 50, HouseInfo[i][hInteriorX], HouseInfo[i][hInteriorY], HouseInfo[i][hInteriorZ]) && GetPlayerVirtualWorld(playerid) == HouseInfo[i][hIntVW] && GetPlayerInterior(playerid) == HouseInfo[i][hIntIW])
			{
				new itemid, amount, string[128];

				if(sscanf(params, "dd", itemid, amount))
				{
					SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /hwithdraw [itemid] [amount]");
					SendClientMessageEx(playerid, COLOR_GREY, "ItemIDs: (1) Cash - (2) Pot - (3) Crack - (4) Materials - (5) Heroin");
					return 1;
				}
				if(itemid < 1 || itemid > 5) {
					SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /hwithdraw [itemid] [amount]");
					SendClientMessageEx(playerid, COLOR_GREY, "ItemIDs: (1) Cash - (2) Pot - (3) Crack - (4) Materials - (5) Heroin");
					return 1;
				}

				if(amount < 1) return SendClientMessageEx(playerid, COLOR_WHITE, "You can't withdraw less than 1.");

				switch(itemid)
				{
					case 1: // Cash
					{
						if(HouseInfo[i][hSafeMoney] >= amount)
						{
							HouseInfo[i][hSafeMoney] -= amount;
							GivePlayerCash(playerid, amount);
							OnPlayerStatsUpdate(playerid);
							SaveHouse(i);
							format(string, sizeof(string), "You have withdrawn $%d from your house safe.", amount);
							SendClientMessageEx(playerid, COLOR_WHITE, string);
							format(string, sizeof(string), "%s (SQL: %d) has withdrawn $%d from their house (ID: %d) safe.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), amount, i);
							Log("logs/hsafe.log", string);
							return 1;
						}
						else return SendClientMessageEx(playerid, COLOR_WHITE, "You do not have enough to withdraw!");
					}
					case 2: // Pot
					{
						if(HouseInfo[i][hPot] >= amount)
						{
							HouseInfo[i][hPot] -= amount;
							PlayerInfo[playerid][p_iDrug][1] += amount;
							OnPlayerStatsUpdate(playerid);
							SaveHouse(i);
							format(string, sizeof(string), "You have withdrawn %d pot from your house safe.", amount);
							SendClientMessageEx(playerid, COLOR_WHITE, string);
							format(string, sizeof(string), "%s (SQL: %d) has withdrawn %d pot from their house (ID: %d) safe.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), amount, i);
							Log("logs/hsafe.log", string);
							return 1;
						}
						else return SendClientMessageEx(playerid, COLOR_WHITE, "You do not have enough to withdraw!");
					}
					case 3: // Crack
					{
						if(HouseInfo[i][hCrack] >= amount)
						{
							HouseInfo[i][hCrack] -= amount;
							PlayerInfo[playerid][p_iDrug][5] += amount;
							OnPlayerStatsUpdate(playerid);
							SaveHouse(i);
							format(string, sizeof(string), "You have withdrawn %d crack from your house safe.", amount);
							SendClientMessageEx(playerid, COLOR_WHITE, string);
							format(string, sizeof(string), "%s (SQL: %d) has withdrawn %d crack from their house (ID: %d) safe.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), amount, i);
							Log("logs/hsafe.log", string);
							return 1;
						}
						else return SendClientMessageEx(playerid, COLOR_WHITE, "You do not have enough to withdraw!");
					}
					case 4: // Materials
					{
						if(HouseInfo[i][hMaterials] >= amount)
						{
							HouseInfo[i][hMaterials] -= amount;
							PlayerInfo[playerid][pMats] += amount;
							OnPlayerStatsUpdate(playerid);
							SaveHouse(i);
							format(string, sizeof(string), "You have withdrawn %d materials from your house safe.", amount);
							SendClientMessageEx(playerid, COLOR_WHITE, string);
							format(string, sizeof(string), "%s (SQL: %d) has withdrawn %d materials from their house (ID: %d) safe.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), amount, i);
							Log("logs/hsafe.log", string);
							return 1;
						}
						else return SendClientMessageEx(playerid, COLOR_WHITE, "You do not have enough to withdraw!");
					}
					case 5: // Heroin
					{
						if(HouseInfo[i][hHeroin] >= amount)
						{
							HouseInfo[i][hHeroin] -= amount;
							PlayerInfo[playerid][p_iDrug][3] += amount;
							OnPlayerStatsUpdate(playerid);
							SaveHouse(i);
							format(string, sizeof(string), "You have withdrawn %d heroin from your house safe.", amount);
							SendClientMessageEx(playerid, COLOR_WHITE, string);
							format(string, sizeof(string), "%s (SQL: %d) has withdrawn %d heroin from their house (ID: %d) safe.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), amount, i);
							Log("logs/hsafe.log", string);
							return 1;
						}
						else return SendClientMessageEx(playerid, COLOR_WHITE, "You do not have enough to withdraw!");
					}
				}
			}
		}
		SendClientMessageEx(playerid, COLOR_GREY, "You're not in a house that you own.");
	}
	else return SendClientMessageEx(playerid, COLOR_GREY, "You don't own a house.");
	return 1;
}

CMD:hdeposit(playerid, params[])
{
	if(Homes[playerid] > 0)
	{
		for(new i; i < MAX_HOUSES; i++)
		{
			if(GetPlayerSQLId(playerid) == HouseInfo[i][hOwnerID] && IsPlayerInRangeOfPoint(playerid, 50, HouseInfo[i][hInteriorX], HouseInfo[i][hInteriorY], HouseInfo[i][hInteriorZ]) && GetPlayerVirtualWorld(playerid) == HouseInfo[i][hIntVW] && GetPlayerInterior(playerid) == HouseInfo[i][hIntIW])
			{
				new string[128], itemid, amount;

				if(sscanf(params, "dd", itemid, amount))
				{
					SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /hdeposit [itemid] [amount]");
					SendClientMessageEx(playerid, COLOR_GREY, "ItemIDs: (1) Cash - (2) Pot - (3) Crack - (4) Materials - (5) Heroin");
					return 1;
				}
				if(itemid < 1 || itemid > 5) {
					SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /hdeposit [itemid] [amount]");
					SendClientMessageEx(playerid, COLOR_GREY, "ItemIDs: (1) Cash - (2) Pot - (3) Crack - (4) Materials - (5) Heroin");
					return 1;
				}

				if(amount < 1) return SendClientMessageEx(playerid, COLOR_WHITE, "You can't deposit less than 1.");
				switch(itemid)
				{
					case 1: // Cash
					{
						if(PlayerInfo[playerid][pCash] >= amount) PlayerInfo[playerid][pCash] -= amount;
						else return SendClientMessageEx(playerid, COLOR_WHITE, "You do not have enough to deposit!");

						HouseInfo[i][hSafeMoney] += amount;
						format(string, sizeof(string), "You have deposited $%d to your house's safe.", amount);
						SendClientMessageEx(playerid, COLOR_WHITE, string);
						OnPlayerStatsUpdate(playerid);
						SaveHouse(i);
						format(string, sizeof(string), "%s (SQL: %d) has deposited $%d into their house (ID: %d) safe.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), amount, i);
						Log("logs/hsafe.log", string);
						return 1;
					}
					case 2: // Pot
					{
						if(PlayerInfo[playerid][p_iDrug][1] >= amount) PlayerInfo[playerid][p_iDrug][1] -= amount;
						else return SendClientMessageEx(playerid, COLOR_WHITE, "You do not have enough to deposit!");

						HouseInfo[i][hPot] += amount;
						format(string, sizeof(string), "You have deposited %d Pot to your house's safe.", amount);
						SendClientMessageEx(playerid, COLOR_WHITE, string);
						OnPlayerStatsUpdate(playerid);
						SaveHouse(i);
						format(string, sizeof(string), "%s (SQL: %d) has deposited %d pot into their house (ID: %d) safe.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), amount, i);
						Log("logs/hsafe.log", string);
						return 1;
					}
					case 3: // Crack
					{
						if(PlayerInfo[playerid][p_iDrug][5] >= amount) PlayerInfo[playerid][p_iDrug][5] -= amount;
						else return SendClientMessageEx(playerid, COLOR_WHITE, "You do not have enough to deposit!");

						HouseInfo[i][hCrack] += amount;
						format(string, sizeof(string), "You have deposited %d Crack to your house's safe.", amount);
						SendClientMessageEx(playerid, COLOR_WHITE, string);
						OnPlayerStatsUpdate(playerid);
						SaveHouse(i);
						format(string, sizeof(string), "%s (SQL: %d) has deposited %d crack into their house (ID: %d) safe.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), amount, i);
						Log("logs/hsafe.log", string);
						return 1;
					}
					case 4: // Materials
					{
						if(PlayerInfo[playerid][pMats] >= amount) PlayerInfo[playerid][pMats] -= amount;
						else return SendClientMessageEx(playerid, COLOR_WHITE, "You do not have enough to deposit!");

						HouseInfo[i][hMaterials] += amount;
						format(string, sizeof(string), "You have deposited %d Materials to your house's safe.", amount);
						SendClientMessageEx(playerid, COLOR_WHITE, string);
						OnPlayerStatsUpdate(playerid);
						SaveHouse(i);
						format(string, sizeof(string), "%s (SQL: %d) has deposited %d materials into their house (ID: %d) safe.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), amount, i);
						Log("logs/hsafe.log", string);
						return 1;
					}
					case 5: // Heroin
					{
						if(PlayerInfo[playerid][p_iDrug][3] >= amount) PlayerInfo[playerid][p_iDrug][3] -= amount;
						else return SendClientMessageEx(playerid, COLOR_WHITE, "You do not have enough to deposit!");

						HouseInfo[i][hHeroin] += amount;
						format(string, sizeof(string), "You have deposited %d Heroin to your house's safe.", amount);
						SendClientMessageEx(playerid, COLOR_WHITE, string);
						OnPlayerStatsUpdate(playerid);
						SaveHouse(i);
						format(string, sizeof(string), "%s (SQL: %d) has deposited %d heroin into their house (ID: %d) safe.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), amount, i);
						Log("logs/hsafe.log", string);
						return 1;
					}
				}
			}
		}
		SendClientMessageEx(playerid, COLOR_GREY, "You're not in a house that you own.");
	}
	else return SendClientMessageEx(playerid, COLOR_GREY, "You don't own a house.");
	return 1;
}

CMD:hammodeposit(playerid, params[]) {

	if(Homes[playerid] > 0)
	{
		new iItemID,
			iAmount; 

		if(sscanf(params, "ii", iItemID, iAmount) || !(0 <= iItemID < 5)) {
			SendClientMessageEx(playerid, COLOR_GRAD2, "USAGE: /hammodeposit [choice] [amount]");
			return SendClientMessageEx(playerid, COLOR_GREY, "Available names: 9mm (0), 7.62x51 (1), .50cal (2), 7.62x39 (3), 12-gauge (4)");
		}
		for(new houseid, i = 0; i < 3; i++)
		{
			if(i == 0) houseid = PlayerInfo[playerid][pPhousekey];
			if(i == 1) houseid = PlayerInfo[playerid][pPhousekey2];
			if(i == 2) houseid = PlayerInfo[playerid][pPhousekey3];
			if(houseid != INVALID_HOUSE_ID && HouseInfo[houseid][hOwnerID] == GetPlayerSQLId(playerid) && IsPlayerInRangeOfPoint(playerid, 50, HouseInfo[houseid][hInteriorX], HouseInfo[houseid][hInteriorY], HouseInfo[houseid][hInteriorZ]) && GetPlayerVirtualWorld(playerid) == HouseInfo[houseid][hIntVW] && GetPlayerInterior(playerid) == HouseInfo[houseid][hIntIW])
			{
				szMiscArray[0] = 0;
				if(!(0 < iAmount <= arrAmmoData[playerid][awp_iAmmo][iItemID])) return SendClientMessageEx(playerid, COLOR_GRAD2, "You are trying to deposit more than you have!");
				if(HouseInfo[houseid][hAmmo][iItemID] + iAmount > 800) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can only store a maximum of 800 rounds of each type.");

				HouseInfo[houseid][hAmmo][iItemID] += iAmount;
				arrAmmoData[playerid][awp_iAmmo][iItemID] -= iAmount;

				format(szMiscArray, sizeof(szMiscArray), "You have deposited %d rounds into your house's safe.", iAmount);
				SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
				SaveHouse(houseid);

				format(szMiscArray, sizeof(szMiscArray), "%s (SQL: %d) has deposited %d (%d) rounds into their house (ID: %d) safe.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pId], iAmount, iItemID, houseid);
				Log("logs/hsafe.log", szMiscArray);
				return 1;
			}
		}
		SendClientMessageEx(playerid, COLOR_GREY, "You're not in a house that you own.");
	}
	else SendClientMessageEx(playerid, COLOR_GREY, "You don't own a house.");
	return 1;
}

CMD:hammowithdraw(playerid, params[]) {

	if(Homes[playerid] > 0)
	{
		new iItemID,
			iAmount; 

		if(sscanf(params, "ii", iItemID, iAmount) || !(0 <= iItemID < 5)) {
			SendClientMessageEx(playerid, COLOR_GRAD2, "USAGE: /hammowithdraw [choice] [amount]");
			return SendClientMessageEx(playerid, COLOR_GREY, "Available names: 9mm (0), 7.62x51 (1), .50cal (2), 7.62x39 (3), 12-gauge (4)");
		}
		for(new houseid, i = 0; i < 3; i++)
		{
			if(i == 0) houseid = PlayerInfo[playerid][pPhousekey];
			if(i == 1) houseid = PlayerInfo[playerid][pPhousekey2];
			if(i == 2) houseid = PlayerInfo[playerid][pPhousekey3];
			if(houseid != INVALID_HOUSE_ID && HouseInfo[houseid][hOwnerID] == GetPlayerSQLId(playerid) && IsPlayerInRangeOfPoint(playerid, 50, HouseInfo[houseid][hInteriorX], HouseInfo[houseid][hInteriorY], HouseInfo[houseid][hInteriorZ]) && GetPlayerVirtualWorld(playerid) == HouseInfo[houseid][hIntVW] && GetPlayerInterior(playerid) == HouseInfo[houseid][hIntIW]) {

				szMiscArray[0] = 0;
				if(!(0 < iAmount <= HouseInfo[houseid][hAmmo][iItemID])) return SendClientMessageEx(playerid, COLOR_GRAD2, "You are trying to withdraw more than you have!");
				if(arrAmmoData[playerid][awp_iAmmo][iItemID] + iAmount > GetMaxAmmoAllowed(playerid, iItemID)) return SendClientMessageEx(playerid, COLOR_GRAD2, "You cannot carry that much on you!");

				HouseInfo[houseid][hAmmo][iItemID] -= iAmount;
				arrAmmoData[playerid][awp_iAmmo][iItemID] += iAmount;

				format(szMiscArray, sizeof(szMiscArray), "You have withdrawn %d rounds from your house's safe.", iAmount);
				SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
				SaveHouse(houseid);

				format(szMiscArray, sizeof(szMiscArray), "%s (SQL: %d) has withdrawn %d (%d) rounds from their house (ID: %d) safe.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pId], iAmount, iItemID, houseid);
				Log("logs/hsafe.log", szMiscArray);
				return 1;
			}
		}
		SendClientMessageEx(playerid, COLOR_GREY, "You're not in a house that you own.");
	}
	else SendClientMessageEx(playerid, COLOR_GREY, "You don't own a house.");
	return 1;
}

CMD:hbalance(playerid, params[])
{
	if(Homes[playerid] > 0)
	{
		for(new i; i < MAX_HOUSES; i++)
		{
			if(GetPlayerSQLId(playerid) == HouseInfo[i][hOwnerID] && IsPlayerInRangeOfPoint(playerid, 50, HouseInfo[i][hInteriorX], HouseInfo[i][hInteriorY], HouseInfo[i][hInteriorZ]) && GetPlayerVirtualWorld(playerid) == HouseInfo[i][hIntVW] && GetPlayerInterior(playerid) == HouseInfo[i][hIntIW])
			{
				new string[128];
				SendClientMessageEx(playerid, COLOR_GREEN, "|___________________________________ House Safe ___________________________________|");
				format(string, sizeof(string), "Cash: $%s | Pot: %s | Crack: %s | Materials: %s | Heroin: %s", number_format(HouseInfo[i][hSafeMoney]), number_format(HouseInfo[i][hPot]), number_format(HouseInfo[i][hCrack]), number_format(HouseInfo[i][hMaterials]), number_format(HouseInfo[i][hHeroin]));
				SendClientMessageEx(playerid, COLOR_WHITE, string);

				for(new j = 0; j != MAX_AMMO_TYPES; j++)
				{
					format(szMiscArray, sizeof(szMiscArray), "%s: %i / 800 rounds", GetAmmoName(j), HouseInfo[i][hAmmo][j]);
					SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
				}
				
				SendClientMessageEx(playerid, COLOR_GREEN, "|__________________________________________________________________________________|");
				return 1;
			}
		}
		SendClientMessageEx(playerid, COLOR_GREY, "You're not in a house that you own.");
	}
	else return SendClientMessageEx(playerid, COLOR_GREY, "You don't own a house.");
	return 1;
}

CMD:closet(playerid, params[])
{
	if(Homes[playerid] > 0)
	{
		for(new i; i < MAX_HOUSES; i++)
		{
			if(GetPlayerSQLId(playerid) == HouseInfo[i][hOwnerID] && IsPlayerInRangeOfPoint(playerid, 50, HouseInfo[i][hInteriorX], HouseInfo[i][hInteriorY], HouseInfo[i][hInteriorZ]) && GetPlayerVirtualWorld(playerid) == HouseInfo[i][hIntVW] && GetPlayerInterior(playerid) == HouseInfo[i][hIntIW])
			{
				if(HouseInfo[i][hClosetX] != 0)
				{
					if(IsPlayerInRangeOfPoint(playerid, 3.0, HouseInfo[i][hClosetX], HouseInfo[i][hClosetY], HouseInfo[i][hClosetZ]))
					{
						return DisplaySkins(playerid);
					}
					else return SendClientMessageEx(playerid, COLOR_GREY, "You aren't near your closet!");
				}
				else return SendClientMessageEx(playerid, COLOR_GREY, "You don't own a closet in this house!");
			}
		}
		SendClientMessageEx(playerid, COLOR_GREY, "You're not in a house that you own.");
	}
	else return SendClientMessageEx(playerid, COLOR_GREY, "You don't own a house.");
	return 1;
}

CMD:closetadd(playerid, params[])
{
	if(Homes[playerid] > 0)
	{
		for(new i; i < MAX_HOUSES; i++)
		{
			if(GetPlayerSQLId(playerid) == HouseInfo[i][hOwnerID] && IsPlayerInRangeOfPoint(playerid, 50, HouseInfo[i][hInteriorX], HouseInfo[i][hInteriorY], HouseInfo[i][hInteriorZ]) && GetPlayerVirtualWorld(playerid) == HouseInfo[i][hIntVW] && GetPlayerInterior(playerid) == HouseInfo[i][hIntIW])
			{
				if(HouseInfo[i][hClosetX] != 0)
				{
					if(IsPlayerInRangeOfPoint(playerid, 3.0, HouseInfo[i][hClosetX], HouseInfo[i][hClosetY], HouseInfo[i][hClosetZ]))
					{
						CountSkins(playerid);
						if((PlayerInfo[playerid][pDonateRank] <= 0 && PlayerInfo[playerid][pSkins] <= 10) || (PlayerInfo[playerid][pDonateRank] > 0 && PlayerInfo[playerid][pSkins] <= 25))
						{
							new string[128];
							new skinid = GetPlayerSkin(playerid);
							AddSkin(playerid, skinid);
							format(string, sizeof(string), "You have added skin ID %d to your closet.", skinid);
							SendClientMessageEx(playerid, COLOR_WHITE, string);
							return 1;
						}
						else return SendClientMessageEx(playerid, COLOR_GREY, "Your closet doesn't have anymore space for clothes!");
					}
					else return SendClientMessageEx(playerid, COLOR_GREY, "You aren't near your closet!");
				}
				else return SendClientMessageEx(playerid, COLOR_GREY, "You don't own a closet in this house!");
			}
		}
		SendClientMessageEx(playerid, COLOR_GREY, "You're not in a house that you own.");
	}
	else return SendClientMessageEx(playerid, COLOR_GREY, "You don't own a house.");
	return 1;
}

CMD:closetremove(playerid, params[])
{
	if(Homes[playerid] > 0)
	{
		for(new i; i < MAX_HOUSES; i++)
		{
			if(GetPlayerSQLId(playerid) == HouseInfo[i][hOwnerID] && IsPlayerInRangeOfPoint(playerid, 50, HouseInfo[i][hInteriorX], HouseInfo[i][hInteriorY], HouseInfo[i][hInteriorZ]) && GetPlayerVirtualWorld(playerid) == HouseInfo[i][hIntVW] && GetPlayerInterior(playerid) == HouseInfo[i][hIntIW])
			{
				if(HouseInfo[i][hClosetX] != 0)
				{
					if(IsPlayerInRangeOfPoint(playerid, 3.0, HouseInfo[i][hClosetX], HouseInfo[i][hClosetY], HouseInfo[i][hClosetZ]))
					{
						new query[128];
						format(query, sizeof(query), "SELECT `skinid` FROM `house_closet` WHERE playerid = %d ORDER BY `skinid` ASC", GetPlayerSQLId(playerid));
						mysql_function_query(MainPipeline, query, true, "SkinQueryFinish", "ii", playerid, Skin_Query_Delete);
						return 1;
					}
					else return SendClientMessageEx(playerid, COLOR_GREY, "You aren't near your closet!");
				}
				else return SendClientMessageEx(playerid, COLOR_GREY, "You don't own a closet in this house!");
			}
		}
		SendClientMessageEx(playerid, COLOR_GREY, "You're not in a house that you own.");
	}
	else return SendClientMessageEx(playerid, COLOR_GREY, "You don't own a house.");
	return 1;
}

CMD:drop(playerid, params[])
{
	new string[128], choice[32];
	if(sscanf(params, "s[32]", choice))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /drop [name]");
		SendClientMessageEx(playerid, COLOR_GREY, "Available names: Weapons, Pot, Materials, Packages, Crates, Radio, Pizza, Syringes, Backpack, Phone");
		return 1;
	}
	else if(strcmp(choice,"backpack",true) == 0)
	{
		if(PlayerInfo[playerid][pBackpack] > 0)
		{
			ShowPlayerDialogEx(playerid, DIALOG_BDROP, DIALOG_STYLE_MSGBOX, "Drop Backpack Confirmation", "{FFFFFF}Are you sure you would like to drop your backpack?\n{FF8000}Note{FFFFFF}: This will {FF0000}permanently{FFFFFF} remove the backpack and all of its contents!", "Yes", "No");
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "You do not have a backpack!");
		}
	}
	else if(strcmp(choice,"syringes",true) == 0)
	{
		if(PlayerInfo[playerid][pSyringes] > 0)
		{
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			format(string, sizeof(string), "You have dropped %d syringes.", PlayerInfo[playerid][pSyringes]);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			PlayerInfo[playerid][pSyringes] = 0;
			format(string, sizeof(string), "* %s has thrown away their syringes.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "You are not carrying any syringes to throw away!");
		}
	}

	else if(strcmp(choice,"materials",true) == 0)
	{
		if(PlayerInfo[playerid][pMats] > 0)
		{
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			format(string, sizeof(string), "You have dropped %d materials.", PlayerInfo[playerid][pMats]);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			format(string, sizeof(string), "* %s has thrown away their materials.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			PlayerInfo[playerid][pMats] = 0;
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "You are not carrying any materials to throw away!");
		}
	}
	else if(strcmp(choice,"radio",true) == 0)
	{
		if(PlayerInfo[playerid][pRadio] != 0)
		{
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			format(string, sizeof(string), "* %s has thrown away their portable radio.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			PlayerInfo[playerid][pRadio] = 0;
			PlayerInfo[playerid][pRadioFreq] = 0;
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "You are not carrying a portable radio to throw away!");
		}
	}
	else if(strcmp(choice,"weapons",true) == 0)
	{
		if(GetPVarType(playerid, "IsInArena"))
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this right now, you are in an arena!");
			return 1;
		}
		if(GetPVarInt( playerid, "EventToken") != 0)
		{
			SendClientMessageEx(playerid, COLOR_GREY, "You can't use this while you're in an event.");
			return 1;
		}
		PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
		ResetPlayerWeaponsEx(playerid);
		format(string, sizeof(string), "* %s has thrown away their Weapons.", GetPlayerNameEx(playerid));
		ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	}
	else if(strcmp(choice,"packages",true) == 0)
	{
		if(GetPVarInt(playerid, "Packages") > 0)
		{
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			format(string, sizeof(string), "* %s has thrown away their material packages.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			DeletePVar(playerid, "Packages");
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "You are not carrying any material packages to throw away!");
		}
	}
	else if(strcmp(choice,"crates",true) == 0)
	{
		if(PlayerInfo[playerid][pCrates] > 0)
		{
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			format(string, sizeof(string), "* %s has thrown away their drug crates.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			PlayerInfo[playerid][pCrates] = 0;
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "You are not carrying any drug crates to throw away!");
		}
	}
	else if(strcmp(choice,"pizza",true) == 0)
	{
		if(GetPVarType(playerid, "Pizza"))
		{
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			format(string, sizeof(string), "* %s has thrown away their pizza delivery.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
            DeletePVar(playerid, "Pizza");
			DeletePVar(playerid, "pizzaTimer");
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "You are not delivering any pizzas!");
		}
	}
	else if(strcmp(choice,"phone", true) == 0)
	{
		if(PlayerInfo[playerid][pPnumber] != 0)
		{
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			format(string, sizeof(string), "* %s throws away their phone.", GetPlayerNameEx(playerid));
			ProxChatBubble(playerid, string);
			PlayerInfo[playerid][pPnumber] = 0;
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "You don't have a phone.");
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /drop [name]");
		SendClientMessageEx(playerid, COLOR_GREY, "Available names: Weapons, Pot, Materials, Packages, Crates, Radio");
	}
	return 1;
}

CMD:show(playerid, params[])
{
	new string[128], giveplayerid, choice[32];
	if(sscanf(params, "us[32]", giveplayerid, choice))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /show [player] [name]");
		SendClientMessageEx(playerid, COLOR_GREY, "Available names: Pot, Crack, Heroin, Materials");
		return 1;
	}

	if(giveplayerid == playerid)
	{
	    SendClientMessageEx(playerid, COLOR_GREY, "You can not show this to yourself!");
		return 1;
	}

	if(IsPlayerConnected(giveplayerid))
	{
		if(giveplayerid != INVALID_PLAYER_ID)
		{
			if (!ProxDetectorS(5.0, playerid, giveplayerid))
			{
				SendClientMessageEx(playerid, COLOR_GREY, "That person isn't near you.");
				return 1;
			}

			if (strcmp(choice, "materials", true) == 0)
			{
			    new amount = PlayerInfo[playerid][pMats];
			    if(amount < 1)
			    {
			        SendClientMessageEx(playerid, COLOR_GREY, "You do not have any materials!");
					return 1;
			    }
				format(string, sizeof(string), "%s has shown you their %d Materials.",  GetPlayerNameEx(playerid), amount);
				SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);

				format(string, sizeof(string), "You have shown %s your %d Materials.", GetPlayerNameEx(giveplayerid), amount);
				SendClientMessageEx(playerid, COLOR_GRAD2, string);

				format(string, sizeof(string), "* %s has shown %s some Materials.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
				ProxDetector(10.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				return 1;
			}
			if (strcmp(choice, "pot", true) == 0)
			{
			    new amount = PlayerInfo[playerid][pPot];
			    if(amount < 1)
			    {
			        SendClientMessageEx(playerid, COLOR_GREY, "You do not have any pot!");
					return 1;
			    }
				format(string, sizeof(string), "%s has shown you their %d grams of pot.",  GetPlayerNameEx(playerid), amount);
				SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);

				format(string, sizeof(string), "You have shown %s your %d grams of pot.", GetPlayerNameEx(giveplayerid), amount);
				SendClientMessageEx(playerid, COLOR_GRAD2, string);

				format(string, sizeof(string), "* %s has shown %s some Pot.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
				ProxDetector(10.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				return 1;
			}
			if (strcmp(choice, "crack", true) == 0)
			{
			    new amount = PlayerInfo[playerid][pCrack];
			    if(amount < 1)
			    {
			        SendClientMessageEx(playerid, COLOR_GREY, "You do not have any crack!");
					return 1;
			    }
				format(string, sizeof(string), "%s has shown you their %d grams of crack.",  GetPlayerNameEx(playerid), amount);
				SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);

				format(string, sizeof(string), "You have shown %s your %d grams of crack.", GetPlayerNameEx(giveplayerid), amount);
				SendClientMessageEx(playerid, COLOR_GRAD2, string);

				format(string, sizeof(string), "* %s has shown %s some Crack.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
				ProxDetector(10.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				return 1;
			}
   			if (strcmp(choice, "heroin", true) == 0)
			{
			    new amount = PlayerInfo[playerid][pHeroin];
			    if(amount < 1)
			    {
			        SendClientMessageEx(playerid, COLOR_GREY, "You do not have any heroin!");
					return 1;
			    }
				format(string, sizeof(string), "%s has shown you their %d milligrams of heroin.",  GetPlayerNameEx(playerid), amount);
				SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);

				format(string, sizeof(string), "You have shown %s your %d milligrams of heroin.", GetPlayerNameEx(giveplayerid), amount);
				SendClientMessageEx(playerid, COLOR_GRAD2, string);

				format(string, sizeof(string), "* %s has shown %s some heroin.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
				ProxDetector(10.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				return 1;
			}
		}
	}
	return 1;
}

CMD:sell(playerid, params[])
{
	new string[128], giveplayerid, choice[32], amount, price;
    if(sscanf(params, "us[32]dd", giveplayerid, choice, amount, price))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /sell [player] [name] [amount] [price]");
		SendClientMessageEx(playerid, COLOR_GREY, "Available names: Pot, Crack, Materials, Firework, Syringes, Rawopium, Heroin, RimKit, Carvoucher, PVIPVoucher");
		return 1;
	}
	if(PlayerCuffed[playerid] >= 1 || PlayerInfo[playerid][pHospital] > 0) return SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this right now.");
	if(GetPVarInt(playerid, "WatchingTV")) return SendClientMessageEx(playerid, COLOR_GREY, "You can not do this while watching TV!");
	if(price < 50000) return SendClientMessageEx(playerid, COLOR_GREY, "Price can't be lower than $50,000. Use /give for deals below the scam limit.");
	if(price > 500000000) return SendClientMessageEx(playerid, COLOR_GREY, "Price can't be lower than $50,000. Use /give for deals below the scam limit.");
	if(price > 100000000) 
	{
		format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s is trying to sell %s to %s for $%d.", GetPlayerNameEx(playerid), choice, GetPlayerNameEx(giveplayerid), price);
		ABroadCast(COLOR_YELLOW, string, 2);
	}
	if(amount < 1) return SendClientMessageEx(playerid, COLOR_GREY, "Amount cannot be below 1.");
	if(!IsPlayerConnected(giveplayerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid player specified.");
	if(playerid == giveplayerid) return SendClientMessageEx(playerid, COLOR_GREY, "You can't sell to yourself!");
	if(!ProxDetectorS(8.0, playerid, giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "That person isn't near you.");

    else if (strcmp(choice, "rimkit", true) == 0)
	{
		if(amount > PlayerInfo[playerid][pRimMod])
			return SendClientMessageEx(playerid, COLOR_GREY, " You don't have that many rim kits.");

		format(string, sizeof(string), "* You offered %s to buy %d rim kits for $%s.", GetPlayerNameEx(giveplayerid), amount, number_format(price));
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
		format(string, sizeof(string), "* %s wants to sell you %d rim kits for $%s, (type /accept rimkit) to buy.", GetPlayerNameEx(playerid), amount, number_format(price));
		SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
	 	SetPVarInt(giveplayerid, "RimOffer", playerid);
	 	SetPVarInt(giveplayerid, "RimPrice", price);
	 	SetPVarInt(giveplayerid, "RimCount", amount);
	 	SetPVarInt(giveplayerid, "RimSeller_SQLId", GetPlayerSQLId(playerid));
	}
	else if (strcmp(choice, "pvipvoucher", true) == 0)
	{
		if(amount > PlayerInfo[playerid][pPVIPVoucher])
			return SendClientMessageEx(playerid, COLOR_GREY, " You don't have that many 1 month PVIP Vouchers.");

		format(string, sizeof(string), "* You offered %s to buy %d 1 month PVIP Voucher(s) for $%s.", GetPlayerNameEx(giveplayerid), amount, number_format(price));
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
		format(string, sizeof(string), "* %s wants to sell you %d 1 month PVIP Voucher(s) for $%s, (type /accept pvipvoucher) to buy.", GetPlayerNameEx(playerid), amount, number_format(price));
		SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
	 	SetPVarInt(giveplayerid, "PVIPVoucherOffer", playerid);
	 	SetPVarInt(giveplayerid, "PVIPVoucherPrice", price);
	 	SetPVarInt(giveplayerid, "PVIPVoucherCount", amount);
	 	SetPVarInt(giveplayerid, "PVIPVoucherSeller_SQLId", GetPlayerSQLId(playerid));
	}
	return 1;

}
