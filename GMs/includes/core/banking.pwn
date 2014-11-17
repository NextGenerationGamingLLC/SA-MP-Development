/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Banking System

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

CMD:cashchecks(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 15.0, 2308.7346, -11.0134, 26.7422))
 	{
  		SendClientMessageEx(playerid, COLOR_GREY, "You are not at the bank!");
    	return 1;
	}
 	if(PlayerInfo[playerid][pCheckCash] > 0)
    {
    	GivePlayerCash(playerid,PlayerInfo[playerid][pCheckCash]);
     	PlayerInfo[playerid][pCheckCash] = 0;
      	SendClientMessageEx(playerid, COLOR_GRAD1, "You have successfully deposited all of your checks.");
       	return 1;
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You did not have any undeposited checks on hand.");
	}
	return 1;
}

CMD:pay(playerid, params[])
{
	if(restarting) return SendClientMessageEx(playerid, COLOR_GRAD2, "Transactions are currently disabled due to the server being restarted for maintenance.");
	new id, storageid, amount;

	if(sscanf(params, "ud", id, amount)) {
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /pay [player] [amount]");
	}
	/*if(sscanf(params, "udd", id, storageid, amount)) {
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /pay [player] [storageid] [amount]");
		SendClientMessageEx(playerid, COLOR_GREY, "StorageIDs: (0) Pocket - (1) Equipped Storage Device");
		return 1;
	}

	if(storageid < 0 || storageid > 1) {
		SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /pay [player] [storageid] [amount]");
		SendClientMessageEx(playerid, COLOR_GREY, "StorageIDs: (0) Pocket - (1) Equipped Storage Device");
		return 1;
	}

	// Find the storageid of the storagedevice.
	if(storageid == 1) {
		new bool:itemEquipped = false;
		for(new i = 0; i < 3; i++)
		{
			if(StorageInfo[playerid][i][sAttached] == 1) {
				storageid = i+1;
				itemEquipped = true;
			}
		}
		if(itemEquipped == false) return SendClientMessageEx(playerid, COLOR_WHITE, "You don't have a storage device equipped!");
	}*/
	else if(!IsPlayerConnected(id)) {
		SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid player specified.");
	}
	else if(id == playerid) {
		SendClientMessageEx(playerid, COLOR_GREY, "You can not use this command on yourself!");
	}
	else if(amount > 1000 && PlayerInfo[playerid][pLevel] < 3) {
		SendClientMessageEx(playerid, COLOR_GRAD1, "You must be level 3 to pay over $1,000 at a time.");
	}
	else if(!(1 <= amount <= 100000)) {
		SendClientMessageEx(playerid, COLOR_GRAD1, "Don't go below $1, or above $100,000 at once.");
	}
	else if(gettime()-GetPVarInt(playerid, "LastTransaction") < 10) {
		SendClientMessageEx(playerid, COLOR_GRAD2, "You can only make a transaction once every 10 seconds, please wait!");
	}
	else if(PlayerInfo[playerid][pCash] < 0 || PlayerInfo[playerid][pAccount] < 0) {
		SendClientMessageEx(playerid, COLOR_GRAD1, "Your cash on-hand or in the bank is currently at a negative value!");
	}
	else if((2 <= PlayerInfo[playerid][pAdmin] < 4) || (2 <= PlayerInfo[id][pAdmin] <= 4)) return 1;
	else if(ProxDetectorS(5.0, playerid, id)) {
		TransferStorage(id, -1, playerid, storageid, 1, amount, -1, -1);
		OnPlayerStatsUpdate(playerid);
		OnPlayerStatsUpdate(id);
		SetPVarInt(playerid, "LastTransaction", gettime());
	}
	else SendClientMessageEx(playerid, COLOR_GREY, "That person isn't near you.");
	return 1;
}

CMD:writecheck(playerid, params[])
{
	new string[128], giveplayerid, monies, reason[64];
	if(sscanf(params, "uds[64]", giveplayerid, monies, reason)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /writecheck [Playerid/PartOfName] [Amount] [Reason]");

    if(!IsPlayerConnected(giveplayerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid player specified.");
    if(monies > 1000 && PlayerInfo[playerid][pLevel] < 3)
	{
        SendClientMessageEx(playerid, COLOR_GRAD1, "   You must be level 3 to write a check for greater then 1000$ !");
        return 1;
    }
    if(monies < 1 || monies > 100000)
	{
        SendClientMessageEx(playerid, COLOR_GRAD1, "   You can't write a check for under 1$ or over 100,000$ !");
        return 1;
    }
	if(PlayerInfo[playerid][pCash] < 0 || PlayerInfo[playerid][pAccount] < 0)
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "Your cash on-hand or in the bank is currently at a negative value!");
	}
    if(PlayerInfo[playerid][pChecks] == 0)
	{
        SendClientMessageEx(playerid, COLOR_GRAD1, "   You must have a checkbook to write a check !");
        return 1;
    }
    if(gettime()-GetPVarInt(playerid, "LastTransaction") < 10) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can only make a transaction once every 10 seconds, please wait!");
    if(strlen(reason) > 64) return SendClientMessageEx(playerid, COLOR_GRAD1, "Check details may not be longer than 64 characters in length.");
    if(giveplayerid == playerid) { SendClientMessageEx(playerid, COLOR_GREY, "You can't write a check to yourself!"); return 1; }
    if(ProxDetectorS(5.0, playerid, giveplayerid))
	{
     	new playermoney = PlayerInfo[playerid][pAccount];
      	if(monies > 0 && playermoney >= monies)
		{
			//GivePlayerCashEx(playerid, TYPE_BANK, -monies);
			//GivePlayerCashEx(giveplayerid, TYPE_BANK, monies);
			PlayerInfo[playerid][pAccount] = PlayerInfo[playerid][pAccount] - monies;
     		PlayerInfo[giveplayerid][pCheckCash] = PlayerInfo[giveplayerid][pCheckCash]+monies;
       		if(PlayerInfo[playerid][pDonateRank] == 0)
			{
   				new fee = (monies*8)/100;
       			GivePlayerCash(playerid, (0 - fee));
          		format(string, sizeof(string), "   You have written a check for $%d to %s (for %s) and have been charged an 8 percent fee.",monies,GetPlayerNameEx(giveplayerid),reason);
            	SendClientMessageEx(playerid, COLOR_GRAD1, string);
             	PlayerInfo[playerid][pChecks]--;
              	format(string, sizeof(string), "   You now have %d checks left.",PlayerInfo[playerid][pChecks]);
               	SendClientMessageEx(playerid, COLOR_GRAD1, string);
      		}
          	else
			{
   				format(string, sizeof(string), "   You have written a check for $%d to %s (for %s) and have not been charged the 8 percent fee.",monies,GetPlayerNameEx(giveplayerid),reason);
       			SendClientMessageEx(playerid, COLOR_GRAD1, string);
          		PlayerInfo[playerid][pChecks]--;
            	format(string, sizeof(string), "   You now have %d checks left.",PlayerInfo[playerid][pChecks]);
             	SendClientMessageEx(playerid, COLOR_GRAD1, string);
			}
   			format(string, sizeof(string), "   You have recieved a check for $%d from %s for: %s", monies,GetPlayerNameEx(playerid),reason);
      		SendClientMessageEx(giveplayerid, COLOR_GRAD1, string);
        	format(string, sizeof(string), "* %s takes out a checkbook, fills out a check and hands it to %s.",GetPlayerNameEx(playerid),GetPlayerNameEx(giveplayerid));
         	ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
          	PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
           	PlayerPlaySound(giveplayerid, 1052, 0.0, 0.0, 0.0);
           	SetPVarInt(playerid, "LastTransaction", gettime());

           	/*OnPlayerStatsUpdate(playerid);
			OnPlayerStatsUpdate(giveplayerid);*/

			new ip[32], ipex[32];
			GetPlayerIp(playerid, ip, sizeof(ip));
			GetPlayerIp(giveplayerid, ipex, sizeof(ipex));
 			format(string, sizeof(string), "[CHECK] %s(%d) (IP:%s) has paid $%s to %s(%d) (IP:%s)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ip, number_format(monies), GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), ipex);
  			Log("logs/pay.log", string);
		}
  		else
		{
  			SendClientMessageEx(playerid, COLOR_GRAD1, "   Invalid transaction amount, or you do not have enough money to give that much!");
     	}
	}
 	else
	{
 		SendClientMessageEx(playerid, COLOR_GREY, "That person isn't near you.");
   	}
    return 1;
}

CMD:charity(playerid, params[])
{
	new string[128], moneys;
	if(sscanf(params, "d", moneys)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /charity [amount]");

	if(moneys < 0)
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "That is not enough.");
		return 1;
	}
	if(GetPlayerCash(playerid) < moneys)
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You don't have that much money.");
		return 1;
	}
	GivePlayerCash(playerid, -moneys);
	format(string, sizeof(string), "%s, thank you for your donation of $%d.",GetPlayerNameEx(playerid), moneys);
	PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	SendClientMessageEx(playerid, COLOR_GRAD1, string);
	//Log("logs/pay.log", string);
	return 1;
}

CMD:awithdraw(playerid, params[])
{
	if(restarting) return SendClientMessageEx(playerid, COLOR_GRAD2, "Transactions are currently disabled due to the server being restarted for maintenance.");
	if(!IsAtATM(playerid))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "   You are not at an ATM!");
		return 1;
	}
    if(PlayerInfo[playerid][pFreezeBank] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "Your bank is currently frozen");
	new string[128], amount;
	if(sscanf(params, "d", amount))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /awithdraw [amount]");
		format(string, sizeof(string), "  You have $%d in your account.", PlayerInfo[playerid][pAccount]);
		SendClientMessageEx(playerid, COLOR_GRAD3, string);
		return 1;
	}

	if (amount > PlayerInfo[playerid][pAccount] || amount < 1)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "   You don't have that much!");
		return 1;
	}
	if(gettime()-GetPVarInt(playerid, "LastTransaction") < 10) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can only make a transaction once every 10 seconds, please wait!");
    SetPVarInt(playerid, "LastTransaction", gettime());
	if(PlayerInfo[playerid][pDonateRank] == 0)
	{
		new fee;
		fee = 3*amount/100;
		PlayerInfo[playerid][pAccount]=PlayerInfo[playerid][pAccount]-fee;
		format(string, sizeof(string), "-$%d money as a 3 percent fee.", fee);
		SendClientMessageEx(playerid, COLOR_GRAD2, string);
		if(((fee > 1000 && PlayerInfo[playerid][pLevel] <= 7) || (fee > 10000 && PlayerInfo[playerid][pLevel] >= 8)) && !PlayerInfo[playerid][pShopNotice])
		{
			PlayerTextDrawSetString(playerid, MicroNotice[playerid], ShopMsg[9]);
			PlayerTextDrawShow(playerid, MicroNotice[playerid]);
			SetTimerEx("HidePlayerTextDraw", 10000, false, "ii", playerid, _:MicroNotice[playerid]);
		}
	}
	PlayerInfo[playerid][pAccount]=PlayerInfo[playerid][pAccount]-amount;
	GivePlayerCash(playerid,amount);
	format(string, sizeof(string), "  You have withdrawn $%s from your account. Current balance: $%s ", number_format(amount), number_format(PlayerInfo[playerid][pAccount]));
	SendClientMessageEx(playerid, COLOR_YELLOW, string);
	OnPlayerStatsUpdate(playerid);
	return 1;
}

CMD:adeposit(playerid, params[])
{
	if(restarting) return SendClientMessageEx(playerid, COLOR_GRAD2, "Transactions are currently disabled due to the server being restarted for maintenance.");
	if(!IsAtATM(playerid))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "   You are not at an ATM!");
		return 1;
	}
    if(PlayerInfo[playerid][pFreezeBank] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "Your bank is currently frozen");
	new string[128], amount;
	if(sscanf(params, "d", amount))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /adeposit [amount]");
		format(string, sizeof(string), "  You have $%d in your account.", PlayerInfo[playerid][pAccount]);
		SendClientMessageEx(playerid, COLOR_GRAD3, string);
		return 1;
	}

	if (amount > GetPlayerCash(playerid) || amount < 1)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "   You don't have that much.");
		return 1;
	}
	if(gettime()-GetPVarInt(playerid, "LastTransaction") < 10) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can only make a transaction once every 10 seconds, please wait!");
    SetPVarInt(playerid, "LastTransaction", gettime());
	if(PlayerInfo[playerid][pDonateRank] == 0)
	{
		new fee;
		fee = 3*amount/100;
		PlayerInfo[playerid][pAccount]=PlayerInfo[playerid][pAccount]-fee;
		format(string, sizeof(string), "-$%d money (3 percent fee).", fee);
		SendClientMessageEx(playerid, COLOR_GRAD2, string);
		if(((fee > 1000 && PlayerInfo[playerid][pLevel] <= 7) || (fee > 10000 && PlayerInfo[playerid][pLevel] >= 8)) && !PlayerInfo[playerid][pShopNotice])
		{
			PlayerTextDrawSetString(playerid, MicroNotice[playerid], ShopMsg[9]);
			PlayerTextDrawShow(playerid, MicroNotice[playerid]);
			SetTimerEx("HidePlayerTextDraw", 10000, false, "ii", playerid, _:MicroNotice[playerid]);
		}
	}
	GivePlayerCash(playerid,-amount);
	new curfunds = PlayerInfo[playerid][pAccount];
	PlayerInfo[playerid][pAccount]=amount+PlayerInfo[playerid][pAccount];
	SendClientMessageEx(playerid, COLOR_WHITE, "|___ ATM STATEMENT ___|");
	format(string, sizeof(string), "  Old Balance: $%s", number_format(curfunds));
	SendClientMessageEx(playerid, COLOR_GRAD2, string);
	format(string, sizeof(string), "  Deposit: $%s", number_format(amount));
	SendClientMessageEx(playerid, COLOR_GRAD4, string);
	SendClientMessageEx(playerid, COLOR_GRAD6, "|-----------------------------------------|");
	format(string, sizeof(string), "  New Balance: $%s", number_format(PlayerInfo[playerid][pAccount]));
	SendClientMessageEx(playerid, COLOR_WHITE, string);
	OnPlayerStatsUpdate(playerid);
	return 1;
}

CMD:abalance(playerid, params[])
{
	if(!IsAtATM(playerid))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "   You are not at an ATM!");
		return 1;
	}
    if(PlayerInfo[playerid][pFreezeBank] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "Your bank is currently frozen");
	new string[128];
	format(string, sizeof(string), "  You have $%s in your account.", number_format(PlayerInfo[playerid][pAccount]));
	SendClientMessageEx(playerid, COLOR_YELLOW, string);
	return 1;
}

CMD:awiretransfer(playerid, params[])
{
	if(restarting) return SendClientMessageEx(playerid, COLOR_GRAD2, "Transactions are currently disabled due to the server being restarted for maintenance.");
	if(PlayerInfo[playerid][pLevel] < 3)
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "   You must be at least level 3!");
		return 1;
	}

	if(!IsAtATM(playerid))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "   You are not at an ATM!");
		return 1;
	}
	if(PlayerInfo[playerid][pCash] < 0 || PlayerInfo[playerid][pAccount] < 0)
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "Your cash on-hand or in the bank is currently at a negative value!");
		return 1;
	}
    if(PlayerInfo[playerid][pFreezeBank] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "Your bank is currently frozen");
    if(gettime()-GetPVarInt(playerid, "LastTransaction") < 10) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can only make a transaction once every 10 seconds, please wait!");
	new string[128], giveplayerid, amount;
	if(sscanf(params, "ud", giveplayerid, amount)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /awiretransfer [player] [amount]");

	if (IsPlayerConnected(giveplayerid))
	{
		if(giveplayerid != INVALID_PLAYER_ID)
		{
			if(gPlayerLogged{giveplayerid} == 0) return SendClientMessageEx(playerid, COLOR_GREY, "* The player you are trying to transfer money to is not logged in!");
			new playermoney = PlayerInfo[playerid][pAccount];
			if (amount > 0 && playermoney >= amount)
			{
				if(PlayerInfo[playerid][pDonateRank] == 0)
				{
					new fee;
					fee = 3*amount/100;
					PlayerInfo[playerid][pAccount]=PlayerInfo[playerid][pAccount]-fee;
					format(string, sizeof(string), "-$%d money (3 percent fee).", fee);
					SendClientMessageEx(playerid, COLOR_GRAD2, string);
					if(((fee > 1000 && PlayerInfo[playerid][pLevel] <= 7) || (fee > 10000 && PlayerInfo[playerid][pLevel] >= 8)) && !PlayerInfo[playerid][pShopNotice])
					{
						PlayerTextDrawSetString(playerid, MicroNotice[playerid], ShopMsg[9]);
						PlayerTextDrawShow(playerid, MicroNotice[playerid]);
						SetTimerEx("HidePlayerTextDraw", 10000, false, "ii", playerid, _:MicroNotice[playerid]);
					}
				}
				GivePlayerCashEx(playerid, TYPE_BANK, -amount);
				GivePlayerCashEx(giveplayerid, TYPE_BANK, amount);
				/*PlayerInfo[playerid][pAccount] -= amount;
				PlayerInfo[giveplayerid][pAccount] += amount;*/
				format(string, sizeof(string), "   You have transferred $%s to %s's account.", number_format(amount), GetPlayerNameEx(giveplayerid),giveplayerid);
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				SendClientMessageEx(playerid, COLOR_GRAD1, string);
				format(string, sizeof(string), "   $%s has been transferred to your bank account from %s.", number_format(amount), GetPlayerNameEx(playerid), playerid);
				SendClientMessageEx(giveplayerid, COLOR_GRAD1, string);
				new ip[32], ipex[32];
				GetPlayerIp(playerid, ip, sizeof(ip));
				GetPlayerIp(giveplayerid, ipex, sizeof(ipex));
				format(string, sizeof(string), "[ATM] %s(%d) (IP:%s) has transferred $%s to %s(%d) (IP:%s).", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ip, number_format(amount), GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), ipex);
				if(PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[giveplayerid][pAdmin] >= 2) Log("logs/adminpay.log", string); else Log("logs/pay.log", string);
				format(string, sizeof(string), "[ATM] %s (IP:%s) has transferred $%s to %s (IP:%s).", GetPlayerNameEx(playerid), ip, number_format(amount), GetPlayerNameEx(giveplayerid), ipex);
				if(amount >= 420000)
				{
					if(PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[giveplayerid][pAdmin] >= 2)
					{
						format(string, sizeof(string), "[ATM] %s has transferred $%s to %s", GetPlayerNameEx(playerid), number_format(amount), GetPlayerNameEx(giveplayerid));
						if(!strcmp(GetPlayerIpEx(playerid),  GetPlayerIpEx(giveplayerid), true)) strcat(string, " (1)");
						ABroadCast(COLOR_YELLOW,string, 4);
					}
					else ABroadCast(COLOR_YELLOW,string,2);
				}
				PlayerPlaySound(giveplayerid, 1052, 0.0, 0.0, 0.0);
				SetPVarInt(playerid, "LastTransaction", gettime());

				/*OnPlayerStatsUpdate(playerid);
				OnPlayerStatsUpdate(giveplayerid);*/
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GRAD1, "   Invalid transaction amount.");
			}
		}
	}
	else SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid player specified.");
	return 1;
}

CMD:withdraw(playerid, params[])
{
	if(restarting) return SendClientMessageEx(playerid, COLOR_GRAD2, "Transactions are currently disabled due to the server being restarted for maintenance.");
	if(PlayerInfo[playerid][mPurchaseCount][12] || (IsPlayerInRangeOfPoint(playerid, 15.0, 2308.7346, -11.0134, 26.7422) && GetPlayerVirtualWorld(playerid) != 0))
	{
		if(PlayerInfo[playerid][pFreezeBank] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "Your bank is currently frozen");
		new string[128], amount;
		
		if(sscanf(params, "d", amount))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /withdraw [amount]");
			format(string, sizeof(string), "  You have $%d in your account.", PlayerInfo[playerid][pAccount]);
			SendClientMessageEx(playerid, COLOR_GRAD3, string);
			return 1;
		}

		if (amount > PlayerInfo[playerid][pAccount] || amount < 1)
		{
			SendClientMessageEx(playerid, COLOR_GRAD2, "   You don't have that much!");
			return 1;
		}
		if(gettime()-GetPVarInt(playerid, "LastTransaction") < 10) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can only make a transaction once every 10 seconds, please wait!");
		SetPVarInt(playerid, "LastTransaction", gettime());
		GivePlayerCash(playerid,amount);
		PlayerInfo[playerid][pAccount]=PlayerInfo[playerid][pAccount]-amount;
		format(string, sizeof(string), "  You have withdrawn $%s from your account. Current balance: $%s ", number_format(amount), number_format(PlayerInfo[playerid][pAccount]));
		SendClientMessageEx(playerid, COLOR_YELLOW, string);
		OnPlayerStatsUpdate(playerid);
	}
	else SendClientMessageEx(playerid, COLOR_GREY, "You are not at the bank!");
	return 1;
}

CMD:deposit(playerid, params[])
{
	if(restarting) return SendClientMessageEx(playerid, COLOR_GRAD2, "Transactions are currently disabled due to the server being restarted for maintenance.");
	if(PlayerInfo[playerid][mPurchaseCount][12] || (IsPlayerInRangeOfPoint(playerid, 15.0, 2308.7346, -11.0134, 26.7422) && GetPlayerVirtualWorld(playerid) != 0))
	{
		if(PlayerInfo[playerid][pFreezeBank] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "Your bank is currently frozen");
		new string[128], amount;

		if(sscanf(params, "d", amount))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /deposit [amount]");
			format(string, sizeof(string), "  You have $%d in your account.", PlayerInfo[playerid][pAccount]);
			SendClientMessageEx(playerid, COLOR_GRAD3, string);
			return 1;
		}

		if (amount > GetPlayerCash(playerid) || amount < 1)
		{
			SendClientMessageEx(playerid, COLOR_GRAD2, "   You don't have that much.");
			return 1;
		}
		if(gettime()-GetPVarInt(playerid, "LastTransaction") < 10) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can only make a transaction once every 10 seconds, please wait!");
		SetPVarInt(playerid, "LastTransaction", gettime());
		GivePlayerCash(playerid,-amount);
		new curfunds = PlayerInfo[playerid][pAccount];
		PlayerInfo[playerid][pAccount]=amount+PlayerInfo[playerid][pAccount];
		SendClientMessageEx(playerid, COLOR_WHITE, "|___ BANK STATEMENT ___|");
		format(string, sizeof(string), "  Old Balance: $%s", number_format(curfunds));
		SendClientMessageEx(playerid, COLOR_GRAD2, string);
		format(string, sizeof(string), "  Deposit: $%s", number_format(amount));
		SendClientMessageEx(playerid, COLOR_GRAD4, string);
		SendClientMessageEx(playerid, COLOR_GRAD6, "|-----------------------------------------|");
		format(string, sizeof(string), "  New Balance: $%s", number_format(PlayerInfo[playerid][pAccount]));
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		OnPlayerStatsUpdate(playerid);
	}
	else SendClientMessageEx(playerid, COLOR_GREY, "You are not at the bank!");
	return 1;
}

CMD:balance(playerid, params[])
{
	if(PlayerInfo[playerid][mPurchaseCount][12] || (IsPlayerInRangeOfPoint(playerid, 15.0, 2308.7346, -11.0134, 26.7422) && GetPlayerVirtualWorld(playerid) != 0))
	{
		new string[128];
		if(PlayerInfo[playerid][pFreezeBank] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "Your bank is currently frozen");
		format(string, sizeof(string), "You have $%s in your account.", number_format(PlayerInfo[playerid][pAccount]));
		SendClientMessageEx(playerid, COLOR_YELLOW, string);
	}
	else SendClientMessageEx(playerid, COLOR_GREY, "You are not at the bank!");
	return 1;
}

CMD:wiretransfer(playerid, params[])
{
	if(restarting) return SendClientMessageEx(playerid, COLOR_GRAD2, "Transactions are currently disabled due to the server being restarted for maintenance.");
	if(PlayerInfo[playerid][pLevel] < 3) return SendClientMessageEx(playerid, COLOR_GRAD1, "   You must be at least level 3!");
	if(PlayerInfo[playerid][mPurchaseCount][12] || (IsPlayerInRangeOfPoint(playerid, 15.0, 2308.7346, -11.0134, 26.7422) && GetPlayerVirtualWorld(playerid) != 0))
	{
		if(PlayerInfo[playerid][pCash] < 0 || PlayerInfo[playerid][pAccount] < 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "Your cash on-hand or in the bank is currently at a negative value!");
		if(gettime()-GetPVarInt(playerid, "LastTransaction") < 10) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can only make a transaction once every 10 seconds, please wait!");
		if(PlayerInfo[playerid][pFreezeBank] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "Your bank is currently frozen");
		new string[128], giveplayerid, amount;
		if(sscanf(params, "ud", giveplayerid, amount)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /wiretransfer [player] [amount]");


		if (IsPlayerConnected(giveplayerid))
		{
			if(giveplayerid != INVALID_PLAYER_ID)
			{
				if(gPlayerLogged{giveplayerid} == 0) return SendClientMessageEx(playerid, COLOR_GREY, "* The player you are trying to transfer money to is not logged in!");
				new playermoney = PlayerInfo[playerid][pAccount] ;
				if (amount > 0 && playermoney >= amount)
				{
					GivePlayerCashEx(playerid, TYPE_BANK, -amount);
					GivePlayerCashEx(giveplayerid, TYPE_BANK, amount);
					/*PlayerInfo[playerid][pAccount] -= amount;
					PlayerInfo[giveplayerid][pAccount] += amount;*/
					format(string, sizeof(string), "   You have transferred $%s to %s's account.", number_format(amount), GetPlayerNameEx(giveplayerid),giveplayerid);
					PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
					SendClientMessageEx(playerid, COLOR_GRAD1, string);
					format(string, sizeof(string), "   You have recieved $%s to into your account from %s.", number_format(amount), GetPlayerNameEx(playerid), playerid);
					SendClientMessageEx(giveplayerid, COLOR_GRAD1, string);
					new ip[32], ipex[32];
					GetPlayerIp(playerid, ip, sizeof(ip));
					GetPlayerIp(giveplayerid, ipex, sizeof(ipex));
					format(string, sizeof(string), "[BANK] %s(%d) (IP:%s) has transferred $%s to %s(%d) (IP:%s).", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ip, number_format(amount), GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), ipex);
					if(PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[giveplayerid][pAdmin] >= 2) Log("logs/adminpay.log", string); else Log("logs/pay.log", string);
					format(string, sizeof(string), "[BANK] %s (IP:%s) has transferred $%s to %s(IP:%s).", GetPlayerNameEx(playerid), ip, number_format(amount), GetPlayerNameEx(giveplayerid), ipex);
					if(amount >= 500000)
					{
						if(PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[giveplayerid][pAdmin] >= 2)
						{
							format(string, sizeof(string), "[BANK] %s has transferred $%s to %s", GetPlayerNameEx(playerid), number_format(amount), GetPlayerNameEx(giveplayerid));
							if(!strcmp(GetPlayerIpEx(playerid),  GetPlayerIpEx(giveplayerid), true)) strcat(string, " (1)");
							ABroadCast(COLOR_YELLOW,string, 4);
						}
						else ABroadCast(COLOR_YELLOW,string,2);
					}
					PlayerPlaySound(giveplayerid, 1052, 0.0, 0.0, 0.0);
					SetPVarInt(playerid, "LastTransaction", gettime());
					/*OnPlayerStatsUpdate(playerid);
					OnPlayerStatsUpdate(giveplayerid);*/
				}
				else
				{
					SendClientMessageEx(playerid, COLOR_GRAD1, "   Invalid transaction amount.");
				}
			}
		}
		else SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid player specified.");
	}
	else SendClientMessageEx(playerid, COLOR_GREY, "You are not at the bank!");
	return 1;
}

CMD:nextpaycheck(playerid, params[])
{
	new string[128];
	format(string, sizeof(string), "Total Minutes since last Paycheck: %d  Approximate time until next Paycheck: %d", floatround(PlayerInfo[playerid][pConnectSeconds]/60), floatround((3600-PlayerInfo[playerid][pConnectSeconds]) / 60));
	SendClientMessageEx(playerid, COLOR_YELLOW, string);
	SendClientMessageEx(playerid, COLOR_GRAD2, "Please note that you will not accrue time if your game is paused.");
	return 1;
}
