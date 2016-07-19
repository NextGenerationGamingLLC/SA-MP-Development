#include <YSI\y_hooks>

#define BANK					10004
#define BANK_AMOUNT 			10005
#define BANK_TRANSFER_TO		10006
#define BANK_TRANSFER_AMT		10007


// use the below for bank VWs so that all actors are created properly.
#define BANK_RODEO			1
#define BANK_MULLHOLLAND	2
#define BANK_SF				3
#define BANK_LV				4
#define BANK_DILLIMORE		5
#define BANK_LASBARANCAS	6

new Bankers[12];
new BankPoint[12];

LoadBanks() {

	// rodeo
	Bankers[0] = CreateActor(150, 2319.2590,-15.7090,26.7496, 90);
	Bankers[1] = CreateActor(150, 2319.1768,-7.2503,26.7496, 90);

	SetActorVirtualWorld(Bankers[0], BANK_RODEO);
	SetActorVirtualWorld(Bankers[1], BANK_RODEO);

	// mullholland
	Bankers[2] = CreateActor(150, 2319.2590,-15.7090,26.7496, 90);
	Bankers[3] = CreateActor(150, 2319.1768,-7.2503,26.7496, 90);

	SetActorVirtualWorld(Bankers[2], BANK_MULLHOLLAND);
	SetActorVirtualWorld(Bankers[3], BANK_MULLHOLLAND);

	// san fierro
	Bankers[4] = CreateActor(150, 2319.2590,-15.7090,26.7496, 90);
	Bankers[5] = CreateActor(150, 2319.1768,-7.2503,26.7496, 90);

	SetActorVirtualWorld(Bankers[4], BANK_SF);
	SetActorVirtualWorld(Bankers[5], BANK_SF);

	// las venturas
	Bankers[6] = CreateActor(150, 2319.2590,-15.7090,26.7496, 90);
	Bankers[7] = CreateActor(150, 2319.1768,-7.2503,26.7496, 90);

	SetActorVirtualWorld(Bankers[6], BANK_LV);
	SetActorVirtualWorld(Bankers[7], BANK_LV);

	// dillimore
	Bankers[8] = CreateActor(150, 2319.2590,-15.7090,26.7496, 90);
	Bankers[9] = CreateActor(150, 2319.1768,-7.2503,26.7496, 90);

	SetActorVirtualWorld(Bankers[8], BANK_DILLIMORE);
	SetActorVirtualWorld(Bankers[9], BANK_DILLIMORE);

	// las barrancas
	Bankers[10] = CreateActor(150, 2319.2590,-15.7090,26.7496, 90);
	Bankers[11] = CreateActor(150, 2319.1768,-7.2503,26.7496, 90);

	SetActorVirtualWorld(Bankers[10], BANK_LASBARANCAS);
	SetActorVirtualWorld(Bankers[11], BANK_LASBARANCAS);

	// pickups for interaction.
	BankPoint[0] = CreateDynamicSphere(2316.2263,-7.3651, 26.7422, 3.0);
	BankPoint[1] = CreateDynamicSphere(2316.4480,-15.4179,26.7422, 3.0);

	print("[Streamer] Bank System Loaded");

	return 1;


}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {

	if((newkeys & KEY_YES) && (IsPlayerInDynamicArea(playerid, BankPoint[0]) || IsPlayerInDynamicArea(playerid, BankPoint[1]))) {
		format(szMiscArray, sizeof(szMiscArray), "{FF8000}** {C2A2DA}%s approaches the banker and begins speaking with them.", GetPlayerNameEx(playerid));
		//ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		SetPlayerChatBubble(playerid, szMiscArray, COLOR_PURPLE, 15.0, 5000);
		ShowBankMenu(playerid);
	}
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	switch(dialogid) {

		case BANK: {
			
			if(!response) {
				TogglePlayerControllable(playerid, 1);
				return SendClientMessageEx(playerid, COLOR_YELLOW, "   You are no longer being attended by the banker.");
			}

			TogglePlayerControllable(playerid, 0);

			switch(listitem) {		
				case 0: ShowBankMenu(playerid, 1);
				case 1: ShowBankMenu(playerid, 2);
				case 2: ShowBankMenu(playerid, 3);
				case 3: {
		 	
				 	if(PlayerInfo[playerid][pCheckCash] > 0) {
				    	//GivePlayerCash(playerid,PlayerInfo[playerid][pCheckCash]);
				    	GivePlayerCashEx(playerid, TYPE_BANK, PlayerInfo[playerid][pCheckCash]);
				     	PlayerInfo[playerid][pCheckCash] = 0;
				      	SendClientMessageEx(playerid, COLOR_YELLOW, "  You have successfully cashed-in all your checks to your bank.");
				       	return ShowBankMenu(playerid);
					}		
					else {
						SendClientMessageEx(playerid, COLOR_YELLOW, "   You did not have any undeposited checks on hand.");
						return ShowBankMenu(playerid);
					}
				}
			}
		}

		case BANK_AMOUNT: {
			if(!response) {
				DeletePVar(playerid, "BankWithdraw");
				DeletePVar(playerid, "BankDeposit");
				return ShowBankMenu(playerid);
			}

			new 
				iAmount = strval(inputtext);

			if(GetPVarType(playerid, "BankWithdraw")) {
				
				if(iAmount < 1) {
					SendClientMessageEx(playerid, COLOR_WHITE, "  Negative amounts cannot be transfered!");
					return ShowBankMenu(playerid, 1);
				}

				if(iAmount > PlayerInfo[playerid][pAccount]) {
					SendClientMessageEx(playerid, COLOR_WHITE, "  You are trying to withdraw more than you have!");
					return ShowBankMenu(playerid, 1);
				}

				if(gettime()-GetPVarInt(playerid, "LastTransaction") < 10) {
					SendClientMessageEx(playerid, COLOR_GRAD2, "You can only make a transaction once every 10 seconds, please wait!");
					ShowBankMenu(playerid, 1);
				}
				SetPVarInt(playerid, "LastTransaction", gettime());
				
				if(!Bank_TransferCheck(-iAmount)) return 1;
				GivePlayerCash(playerid, iAmount);
				PlayerInfo[playerid][pAccount] -= iAmount;
				format(szMiscArray, sizeof(szMiscArray), "  You have withdrawn $%s from your account. ", number_format(iAmount));
				SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);

				if(PlayerInfo[playerid][pTut] == 16)
				{
					PlayerInfo[playerid][pTut]++;
					AdvanceTutorial(playerid);
				}

				OnPlayerStatsUpdate(playerid);

				DeletePVar(playerid, "BankWithdraw");

				return ShowBankMenu(playerid);
			}
			else if(GetPVarType(playerid, "BankDeposit")) {

				if(iAmount < 1) {
					SendClientMessageEx(playerid, COLOR_WHITE, "  Negative amounts cannot be transfered!");
					return ShowBankMenu(playerid, 2);
				}

				if(iAmount > GetPlayerCash(playerid)) {
					SendClientMessageEx(playerid, COLOR_WHITE, "  You are trying to deopsit more than you have!");
					return ShowBankMenu(playerid, 2);
				}

				if(gettime()-GetPVarInt(playerid, "LastTransaction") < 10) {
					SendClientMessageEx(playerid, COLOR_GRAD2, "You can only make a transaction once every 10 seconds, please wait!");
					ShowBankMenu(playerid, 2);
				}
				SetPVarInt(playerid, "LastTransaction", gettime());
				
				if(!Bank_TransferCheck(iAmount)) return 1;
				GivePlayerCash(playerid, -iAmount);
				PlayerInfo[playerid][pAccount] += iAmount; 
				format(szMiscArray, sizeof(szMiscArray), "  You have deposited $%s to your account. ", number_format(iAmount));
				SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);

				OnPlayerStatsUpdate(playerid);

				DeletePVar(playerid, "BankDeposit");

				return ShowBankMenu(playerid);
			}
		}

		case BANK_TRANSFER_TO: {
			
			if(!response) {
				return ShowBankMenu(playerid);
			}

			new id = strval(inputtext);
			
			if(!IsPlayerConnected(id) || !gPlayerLogged{id}) {
				SendClientMessageEx(playerid, COLOR_WHITE, "  The player you are trying to transfer to is not connected!");
				return ShowBankMenu(playerid, 3);
			}

			SetPVarInt(playerid, "BankTransferTo", id);
			return ShowBankMenu(playerid, 4);
		}

		case BANK_TRANSFER_AMT: {

			if(!response) {
				DeletePVar(playerid, "BankTransferTo");
				return ShowBankMenu(playerid, 3);
			}

			new 
				id = GetPVarInt(playerid, "BankTransferTo"),
				iAmount = strval(inputtext);


			if(restarting) {
				SendClientMessageEx(playerid, COLOR_GRAD2, "Transactions are currently disabled due to the server being restarted for maintenance.");
				return ShowBankMenu(playerid, 3);
			}
			if(PlayerInfo[playerid][pLevel] < 3) {
				SendClientMessageEx(playerid, COLOR_GRAD1, "   You must be at least level 3 to use this feature!");
				return ShowBankMenu(playerid, 3);
			}
			if(gettime()-GetPVarInt(playerid, "LastTransaction") < 10) {
				SendClientMessageEx(playerid, COLOR_GRAD2, "You can only make a transaction once every 10 seconds, please wait!");
				return ShowBankMenu(playerid, 3);
			}

			if(iAmount > PlayerInfo[playerid][pAccount] || iAmount < 0) return SendClientMessageEx(playerid, COLOR_WHITE, "You are trying to send more than you have!");

			// Use these as they update the MySQL Directly with less function calls
			GivePlayerCashEx(playerid, TYPE_BANK, -iAmount);
			GivePlayerCashEx(id, TYPE_BANK, iAmount);

			format(szMiscArray, sizeof(szMiscArray), "   You have transferred $%s to %s's account.", number_format(iAmount), GetPlayerNameEx(id));
			SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
			
			format(szMiscArray, sizeof(szMiscArray), "   $%s has been transferred to your bank account from %s.", number_format(iAmount), GetPlayerNameEx(playerid));
			SendClientMessageEx(id, COLOR_YELLOW, szMiscArray);

			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			PlayerPlaySound(id, 1052, 0.0, 0.0, 0.0);
				
				
			new ip[32], ipex[32];
			GetPlayerIp(playerid, ip, sizeof(ip));
			GetPlayerIp(id, ipex, sizeof(ipex));
			format(szMiscArray, sizeof(szMiscArray), "[Bank] %s(%d) (IP:%s) has transferred $%s to %s(%d) (IP:%s).", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ip, number_format(iAmount), GetPlayerNameEx(id), GetPlayerSQLId(id), ipex);
			if(PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[id][pAdmin] >= 2) Log("logs/adminpay.log", szMiscArray); else Log("logs/pay.log", szMiscArray);
			format(szMiscArray, sizeof(szMiscArray), "[Bank] %s (IP:%s) has transferred $%s to %s (IP:%s).", GetPlayerNameEx(playerid), ip, number_format(iAmount), GetPlayerNameEx(id), ipex);
			

			if(PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[id][pAdmin] >= 2) {
				format(szMiscArray, sizeof(szMiscArray), "[Bank] Admin %s has transferred $%s to %s", GetPlayerNameEx(playerid), number_format(iAmount), GetPlayerNameEx(id));
				if(!strcmp(GetPlayerIpEx(playerid),  GetPlayerIpEx(id), true)) strcat(szMiscArray, " (1)");
				ABroadCast(COLOR_YELLOW,szMiscArray, 4);
			}
			else ABroadCast(COLOR_YELLOW,szMiscArray,2);
			
			SetPVarInt(playerid, "LastTransaction", gettime());
			DeletePVar(playerid, "BankTransferTo");

			return ShowBankMenu(playerid);
		}
	}
	return 0;
}

ShowBankMenu(playerid, menu = 0) {

	new szTitle[48];

	szMiscArray[0] = 0;

	format(szTitle, sizeof(szTitle), "Bank Menu ($%s)", number_format(PlayerInfo[playerid][pAccount]));

	if(PlayerInfo[playerid][pFreezeBank] == 1) return ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, szTitle, "Your assets have been frozen! Contact judicial!", "Ok", "");

	switch(menu) {

		case 0: { // main menu
			ShowPlayerDialogEx(playerid, BANK, DIALOG_STYLE_LIST, szTitle, "Withdraw\nDeposit\nTransfer\nCash-in Checks", "Select", "Cancel");
		}

		case 1: { // iAmount withdraw
			ShowPlayerDialogEx(playerid, BANK_AMOUNT, DIALOG_STYLE_INPUT, szTitle, "Please input how much you wish to withdraw from your account.", "Withdraw", "Cancel");
			SetPVarInt(playerid, "BankWithdraw", 1);
		}

		case 2: { // iAmount deposit
			ShowPlayerDialogEx(playerid, BANK_AMOUNT, DIALOG_STYLE_INPUT, szTitle, "Please input how much you wish to deposit to your account.", "Deposit", "Cancel");
			SetPVarInt(playerid, "BankDeposit", 1);
		}

		case 3: { // transfer to
			ShowPlayerDialogEx(playerid, BANK_TRANSFER_TO, DIALOG_STYLE_INPUT, szTitle, "Please input the player id you wish to transfer money to.", "Next", "Cancel");
		}

		case 4: { // transfer iAmount
			format(szMiscArray, sizeof(szMiscArray), "Please input the amount you wish to transfer to {FF0000}%s", GetPlayerNameEx(GetPVarInt(playerid, "BankTransferTo")));
			ShowPlayerDialogEx(playerid, BANK_TRANSFER_AMT, DIALOG_STYLE_INPUT, szTitle, szMiscArray, "Transfer", "Cancel");
		}
	}

	return 1;
}