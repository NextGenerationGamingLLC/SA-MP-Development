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

/*
new iBankVault;
task Bank_VaultCheck[60000 * 15]() {

	Bank_UpdateBank(iBankVault);
}


Bank_LoadBank() {
	// Current Main Server vault: 216.000.000.000. Above 32-bit int limit. Divide by 1000 from bigint column to get a readable number for SA:MP.
	mysql_tquery(MainPipeline, "SELECT money / 1000 FROM `bank` WHERE `id` = '1'", true, "Bank_OnLoadBank", "");
}

forward Bank_OnLoadBank();
public Bank_OnLoadBank() {

	new iRows,
		iFields;

	cache_get_data(iRows, iFields, MainPipeline);
	iBankVault = cache_get_field_content_int(0, "money / 1000", MainPipeline);
	print("[LS Bank] - Loaded all the $$$");
	return 1;
}
*/

Bank_UpdateBank(iAmount) {
	
	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "UPDATE `bank` SET `money` = money + %d WHERE `money` > 0", iAmount);
	mysql_tquery(MainPipeline, szMiscArray, "Bank_OnUpdateBank", "i", iAmount);
}

forward Bank_OnUpdateBank(iAmount);
public Bank_OnUpdateBank(iAmount) {

	new iRows;
	cache_get_row_count(iRows);

	if(iRows) {
		
		format(szMiscArray, sizeof(szMiscArray), "[LS BANK] Processed $%s", iAmount);
		Log("logs/bank.log", szMiscArray);
		
	}
	else Bank_Bankrupt();
	return 1;
}


forward Bank_FetchData(playerid);
public Bank_FetchData(playerid) {

	new iRows,
		szMoney[16];
	cache_get_row_count(iRows);
	
	if(iRows) {
		cache_get_value_name(0, "money", szMoney, sizeof(szMoney));

		format(szMiscArray, sizeof(szMiscArray), "[BANK]: Vault: {CCCCCC}$%s", szMoney);
		SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
	}
	return 1;
}



Bank_Bankrupt() {
	SetGVarInt("Bankrupt", 1);
}

Bank_TransferCheck(iAmount) {

	/*
	if((-2147483647 < iBankVault + iAmount < 2147483647)) {

		if(iBankVault > (iAmount * -1)) { // If you withdraw, the bank will always be happy.
			Bank_ProcessMoney(iAmount);
		}
		else Bank_UpdateBank(iAmount, 1);
	}
	else {
		Bank_UpdateBank(iAmount, 1);
	}
	if(GetGVarInt("Bankrupt")) return 0;
	*/

	if(GetGVarInt("Bankrupt")) {
		// SendClientMessageEx(playerid, COLOR_LIGHTRED, "[Bank]: We're terribly sorry, we are bankrupt.");
		// return 0;
		return 1;
	}
	else Bank_UpdateBank(iAmount);
	return 1;
}

/*
Bank_ProcessMoney(iAmount) {

	iBankVault += iAmount;
}
*/

CMD:bankvault(playerid, params[]) {

	if(!IsAdminLevel(playerid, ADMIN_SENIOR, 1)) return 1;
	mysql_tquery(MainPipeline, "SELECT `money` FROM `bank` WHERE `id` = '1'", "Bank_FetchData", "i", playerid);
	return 1;
}

CMD:resetbank(playerid, params[]) {
	if(!IsAdminLevel(playerid, ADMIN_SENIOR, 1)) return 1;
	mysql_tquery(MainPipeline, "UPDATE `bank` SET `money` = (SELECT SUM(`money`) FROM `accounts`) WHERE `id` = 1", "Bank_ResetVault", "i", playerid);
	return 1;
}

forward Bank_ResetVault(playerid);
public Bank_ResetVault(playerid) {

	if(mysql_errno(MainPipeline)) SendClientMessageEx(playerid, COLOR_GRAD1, "Something went wrong.");
	mysql_tquery(MainPipeline, "SELECT `money` FROM `bank` WHERE `id` = '1'", "Bank_FetchData", "i", playerid);
}

/*
CMD:updatevault(playerid, parmas[]) {
	if(!IsAdminLevel(playerid, ADMIN_HEAD, 1)) return 1;
	Bank_UpdateBank(iBankVault);
	SendClientMessageEx(playerid, COLOR_YELLOW, "[BANK]: You updated the bank vault, resetting the cash flow.");
	return 1;
}
*/

PayDay(i) {
	if(!gPlayerLogged{i}) return 1;
	new
		string[128],
		interest,
		pVIPTax,
		year,
		month,
		day;
		
	getdate(year, month, day);
	
 	if(PlayerInfo[i][pLevel] > 0 && (PlayerInfo[i][pTogReports] == 1 || PlayerInfo[i][pAdmin] < 2)) {
		if(GetPVarType(i, "debtMsg")) {
			if(GetPlayerCash(i) < 0 && PlayerInfo[i][pJailTime] < 1 && !IsACop(i) && PlayerInfo[i][pWantedLevel] < 6) {
				format(string,sizeof(string),"You're in debt $%s - find a way to pay back the money or you might get in trouble!", number_format(GetPlayerCash(i)));
				SendClientMessageEx(i, COLOR_LIGHTRED, string);
			}
			else DeletePVar(i, "debtMsg");
		}

		if(0 <= PlayerInfo[i][pRenting] < sizeof HouseInfo) {
			if(HouseInfo[PlayerInfo[i][pRenting]][hRentFee] > PlayerInfo[i][pAccount]) {
				PlayerInfo[i][pRenting] = INVALID_HOUSE_ID;
				SendClientMessageEx(i, COLOR_WHITE, "You have been evicted from your residence for failing to pay rent fees.");
			}
			else {
				if(!Bank_TransferCheck(-HouseInfo[PlayerInfo[i][pRenting]][hRentFee])) return 1;
				HouseInfo[PlayerInfo[i][pRenting]][hSafeMoney] += HouseInfo[PlayerInfo[i][pRenting]][hRentFee];
				PlayerInfo[i][pAccount] -= HouseInfo[PlayerInfo[i][pRenting]][hRentFee];
			}
		}
		if(PlayerInfo[i][pConnectSeconds] >= 3600) {
			if(GetPVarInt(i, "pBirthday") == 1) {
				PlayerInfo[i][pPayCheck] = PlayerInfo[i][pPayCheck] * 2;
			}
			if(GetPVarType(i, "AdvisorDuty")) {
				PlayerInfo[i][pDutyHours]++;
			}
			if(SpecTimer) AddSpecialToken(i);
			SendClientMessageEx(i, COLOR_WHITE, "________ BANK STATEMENT ________");
			if(PlayerInfo[i][pNation] == 0)
			{
				if(PlayerInfo[i][pDonateRank] < 4)
				{
					format(string, sizeof(string), "  Paycheck: $%s  |  SA Gov Tax: $%s (%d percent)", number_format(PlayerInfo[i][pPayCheck]), number_format((PlayerInfo[i][pPayCheck] / 100) * TaxValue), TaxValue);
					if(!Bank_TransferCheck((PlayerInfo[i][pPayCheck] / 100) * TaxValue)) return 1;
					PlayerInfo[i][pAccount] -= (PlayerInfo[i][pPayCheck] / 100) * TaxValue;
					Tax += (PlayerInfo[i][pPayCheck] / 100) * TaxValue;
				}
				else
				{
					pVIPTax = TaxValue - 15;
					if(pVIPTax < 0) { pVIPTax = 0; }
					format(string, sizeof(string), "  Paycheck: $%s  |  SA Gov Tax: $%s (%d percent) {FFFF00}(Platinum VIP: 15 percent off)", number_format(PlayerInfo[i][pPayCheck]), number_format((PlayerInfo[i][pPayCheck] / 100) * pVIPTax), pVIPTax);
					if(!Bank_TransferCheck((PlayerInfo[i][pPayCheck] / 100) * pVIPTax)) return 1;
					PlayerInfo[i][pAccount] -= (PlayerInfo[i][pPayCheck] / 100) * pVIPTax;
					Tax += (PlayerInfo[i][pPayCheck] / 100) * pVIPTax;
				}
			}
			else if(PlayerInfo[i][pNation] == 1)
			{
				if(PlayerInfo[i][pDonateRank] < 4)
				{
					format(string, sizeof(string), "  Paycheck: $%s  |  NE Gov Tax: $%s (%d percent)", number_format(PlayerInfo[i][pPayCheck]), number_format((PlayerInfo[i][pPayCheck] / 100) * TRTaxValue), TRTaxValue);	
					if(!Bank_TransferCheck((PlayerInfo[i][pPayCheck] / 100) * TRTaxValue)) return 1;
					PlayerInfo[i][pAccount] -= (PlayerInfo[i][pPayCheck] / 100) * TRTaxValue;
					TRTax += (PlayerInfo[i][pPayCheck] / 100) * TRTaxValue;
				}
				else
				{
					pVIPTax = TRTaxValue - 15;
					if(pVIPTax < 0) { pVIPTax = 0; }
					format(string, sizeof(string), "  Paycheck: $%s  |  NE Gov Tax: $%s (%d percent) {FFFF00}(Platinum VIP: 15 percent off)", number_format(PlayerInfo[i][pPayCheck]), number_format((PlayerInfo[i][pPayCheck] / 100) * pVIPTax), pVIPTax);	
					if(!Bank_TransferCheck((PlayerInfo[i][pPayCheck] / 100) * pVIPTax)) return 1;
					PlayerInfo[i][pAccount] -= (PlayerInfo[i][pPayCheck] / 100) * pVIPTax;
					TRTax += (PlayerInfo[i][pPayCheck] / 100) * pVIPTax;
				}
			}
			SendClientMessageEx(i, COLOR_GRAD1, string);
			interest = (PlayerInfo[i][pAccount] + 1) / 1000;

			switch(PlayerInfo[i][pDonateRank]) {
				case 0: {
					if(interest > 50000) interest = 50000;
					format(string, sizeof(string), "  Balance: $%s  |  Interest rate: 0.1 percent (50k max)", number_format(PlayerInfo[i][pAccount]));
					SendClientMessageEx(i, COLOR_GRAD1, string);
				}
				case 1: {
					if(interest > 100000) interest = 100000;
					format(string, sizeof(string), "  Balance: $%s  |  Interest rate: 0.1 percent {FFFF00}(Bronze VIP: 100k max)", number_format(PlayerInfo[i][pAccount]));
					SendClientMessageEx(i, COLOR_GRAD1, string);
				}
				case 2:	{
					if(interest > 150000) interest = 150000;
					format(string, sizeof(string), "  Balance: $%s  |  Interest rate: 0.1 percent {FFFF00}(Silver VIP: 150k max)", number_format(PlayerInfo[i][pAccount]));
					SendClientMessageEx(i, COLOR_GRAD1, string);
				}
				case 3: {
					if(interest > 200000) interest = 200000;
					format(string, sizeof(string), "  Balance: $%s  |  Interest rate: 0.1 percent {FFFF00}(Gold VIP: 200k max)", number_format(PlayerInfo[i][pAccount]));
					SendClientMessageEx(i, COLOR_GRAD1, string);
				}
				case 4, 5: {
					if(interest > 250000) interest = 250000;
					format(string, sizeof(string), "  Balance: $%s  |  Interest rate: 0.1 percent {FFFF00}(Platinum VIP: 250k max)", number_format(PlayerInfo[i][pAccount]));
					SendClientMessageEx(i, COLOR_GRAD1, string);
				}
			}
			if(PlayerInfo[i][pTaxiLicense] == 1) {
				PlayerInfo[i][pAccount] -= (PlayerInfo[i][pPayCheck] / 100) * 5;
				Tax += (PlayerInfo[i][pPayCheck] / 100) * 5;
				format(string, sizeof(string), "  Taxi licensing fee (5 percent): $%s", number_format((PlayerInfo[i][pPayCheck] / 100) * 5));
				SendClientMessageEx(i, COLOR_GRAD2, string);
			}
			for(new iGroupID; iGroupID < MAX_GROUPS; iGroupID++)
			{
				if(PlayerInfo[i][pNation] == 0)
				{
					if(arrGroupData[iGroupID][g_iAllegiance] == 1)
					{
						if(arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_GOV)
						{
							new str[128];
							if(PlayerInfo[i][pDonateRank] < 4) {
								format(str, sizeof(str), "%s has paid $%s in tax.", GetPlayerNameEx(i), number_format((PlayerInfo[i][pPayCheck] / 100) * TaxValue));
							} else {
								format(str, sizeof(str), "%s has paid $%s in tax.", GetPlayerNameEx(i), number_format((PlayerInfo[i][pPayCheck] / 100) * pVIPTax));
							}
							GroupPayLog(iGroupID, str);
						}
					}
				}
				else if (PlayerInfo[i][pNation] == 1)
				{
					if(arrGroupData[iGroupID][g_iAllegiance] == 2)
					{
						if(arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_GOV)
						{
							new str[128];
							if(PlayerInfo[i][pDonateRank] < 4) {
								format(str, sizeof(str), "%s has paid $%s in tax.", GetPlayerNameEx(i), number_format((PlayerInfo[i][pPayCheck] / 100) * TRTaxValue));
							} else {
								format(str, sizeof(str), "%s has paid $%s in tax.", GetPlayerNameEx(i), number_format((PlayerInfo[i][pPayCheck] / 100) * pVIPTax));
							}
							GroupPayLog(iGroupID, str);
						}
					}
				}
			}
			if(!Bank_TransferCheck(-interest)) return 1;
			PlayerInfo[i][pAccount] += interest;
			format(string, sizeof(string), "  Interest gained: $%s", number_format(interest));
			SendClientMessageEx(i, COLOR_GRAD3, string);
			SendClientMessageEx(i, COLOR_GRAD4, "______________________________________");
			format(string, sizeof(string), "  New balance: $%s  |  Rent paid: $%s", number_format(PlayerInfo[i][pAccount]), number_format((0 <= PlayerInfo[i][pRenting] < sizeof HouseInfo) ? (HouseInfo[PlayerInfo[i][pRenting]][hRentFee]) : (0)));
			SendClientMessageEx(i, COLOR_GRAD5, string);

			//GivePlayerCash(i, PlayerInfo[i][pPayCheck]);
			GivePlayerCashEx(i, TYPE_BANK, PlayerInfo[i][pPayCheck]);
			HourDedicatedPlayer(i);
			/*if(month == 12 && day == 5)
			{
				if(++PlayerInfo[i][pFallIntoFun] == 5)
				{
					if(PlayerInfo[i][pReceivedPrize] == 0)
					{
						PlayerInfo[i][pGVIPExVoucher] += 1;
						SendClientMessageEx(i, COLOR_LIGHTBLUE, "You have received a 7 day Gold VIP voucher for playing 5 hours.");
						PlayerInfo[i][pReceivedPrize] = 1;
					}
					PlayerInfo[i][pFallIntoFun] = 0;
				}
			}*/
			
			// Fall Into Fun - 100 HP every 5 paychecks
			/*PlayerInfo[i][pFallIntoFun]++;
			
			if(PlayerInfo[i][pFallIntoFun] == 5)
			{	
				new Float: health;
				GetHealth(i, health);
				
				if(health == 100)
				{
					PlayerInfo[i][pFirstaid]++;
					SendClientMessageEx(i, COLOR_LIGHTBLUE, "You have played for 5 hours and received a firstaid kit due to having 100 percent health already.");
					PlayerInfo[i][pFallIntoFun] = 0;
				}
				else 
				{
					SetHealth(i, 100.0);
					SendClientMessageEx(i, COLOR_LIGHTBLUE, "You have played for 5 hours and received 100 percent HP.");
					PlayerInfo[i][pFallIntoFun] = 0;
				}
			}*/
			PayGroupMember(i);
   			if (PlayerInfo[i][pBusiness] != INVALID_BUSINESS_ID) {
				if (Businesses[PlayerInfo[i][pBusiness]][bAutoPay] && PlayerInfo[i][pBusinessRank] >= 0 && PlayerInfo[i][pBusinessRank] < 5) {
				    if (Businesses[PlayerInfo[i][pBusiness]][bSafeBalance] < Businesses[PlayerInfo[i][pBusiness]][bRankPay][PlayerInfo[i][pBusinessRank]]) {
				    	SendClientMessageEx(i,COLOR_RED,"Business doesn't have enough cash for your pay.");
				    }
					else {
						//GivePlayerCash(i, Businesses[PlayerInfo[i][pBusiness]][bRankPay][PlayerInfo[i][pBusinessRank]]);
						GivePlayerCashEx(i, TYPE_BANK, Businesses[PlayerInfo[i][pBusiness]][bRankPay][PlayerInfo[i][pBusinessRank]]);
						Businesses[PlayerInfo[i][pBusiness]][bSafeBalance] -= Businesses[PlayerInfo[i][pBusiness]][bRankPay][PlayerInfo[i][pBusinessRank]];
						SaveBusiness(PlayerInfo[i][pBusiness]);
						format(string,sizeof(string),"  Business pay: $%s", number_format(Businesses[PlayerInfo[i][pBusiness]][bRankPay][PlayerInfo[i][pBusinessRank]]));
						SendClientMessageEx(i, COLOR_GRAD2, string);
					}
				}
			}
			
			GameTextForPlayer(i, "~y~PayDay~n~~w~Paycheck", 5000, 1);
			//SendAudioToPlayer(i, 63, 100);
			PlayerInfo[i][pConnectSeconds] = 0;
			PlayerInfo[i][pPayCheck] = 0;
			if(++PlayerInfo[i][pConnectHours] == 2) {
				SendClientMessageEx(i, COLOR_LIGHTRED, "You may now possess/use weapons!");
			}
			if(PlayerInfo[i][pDonateRank] > 0 && ++PlayerInfo[i][pPayDayHad] >= 5) {
				PlayerInfo[i][pExp]++;
				PlayerInfo[i][pPayDayHad] = 0;
			}
			// Auto Levels
			if(PlayerInfo[i][pAdmin] < 2) LevelCheck(i);
			
			// Zombie Halloween
			if(month == 10 && day == 30)
			{
				if(PlayerInfo[i][pFallIntoFun] < 4)
				{
					PlayerInfo[i][pFallIntoFun]++;
				}
				else {
					 PlayerInfo[i][pFallIntoFun] = 0;
					 PlayerInfo[i][pVials] += 1;
				}
			}	
			/*
			if((month == 12 && day == 24) || (month == 10 && day == 31))
			{
				if(PlayerInfo[i][pTrickortreat] > 0)
				{
					PlayerInfo[i][pTrickortreat]--;
				}
			}*/
			if(month == 10 && (day == 29 || day == 30 || day == 31))
			{
				++PlayerInfo[i][pTrickortreat];
				if(PlayerInfo[i][pTrickortreat] == 15) {
					GiveHtoy(i, 2590, "Scythe");
				}
				if(PlayerInfo[i][pTrickortreat] == 30) {
					GiveHtoy(i, 2907, "Zombie Torso");
				}
			}
			if(month == 5 && day == 25) //Memorial Day 2015
			{
				if(++PlayerInfo[i][pTrickortreat] == 3)
					SendClientMessageEx(i, -1, "You have been given 1 Double EXP Token for playing 3 hours!"), PlayerInfo[i][pEXPToken]++, PlayerInfo[i][pTrickortreat] = 0;
			}
			//Weekday Madness for Fall Into Fun event; re-using Trickortreat variable to check connected time
			/*if(month == 10 && (day == 9 || day == 16))
			{
				PlayerInfo[i][pRewardDrawChance] += 2;
			}
			else if(month == 10 && day == 19)
			{
				PlayerInfo[i][pRewardDrawChance] += 3;
			}
			else PlayerInfo[i][pRewardDrawChance]++;
			
			if(PlayerInfo[i][pDonateRank] >= 3 && month == 10 && day == 13)
			{
				PlayerInfo[i][pRewardDrawChance] += 3;
			}*/
			Misc_Save();
			if(iRewardPlay) {
				PlayerInfo[i][pRewardHours]++;
				if(floatround(PlayerInfo[i][pRewardHours]) % 16 == 0) {
					PlayerInfo[i][pGoldBoxTokens]++;
					SendClientMessage(i, COLOR_LIGHTBLUE, "You have received 1 Gold Giftbox token!  #FallIntoFun");
				}
				format(string, sizeof(string), "You currently have %d Reward Hours, please check /rewards for more information.", floatround(PlayerInfo[i][pRewardHours]));
				SendClientMessageEx(i, COLOR_YELLOW, string);
			}

			if(PlayerInfo[i][pDoubleEXP] > 0) {
				PlayerInfo[i][pDoubleEXP]--;
				format(string, sizeof(string), "You have gained 2 respect points instead of 1. You have %d hours left on the Double EXP token.", PlayerInfo[i][pDoubleEXP]);
				SendClientMessageEx(i, COLOR_YELLOW, string);
				PlayerInfo[i][pExp] += 2;
			}
			else PlayerInfo[i][pExp]++;

			if(GetPVarInt(i, "pBirthday") == 1) {
				SendClientMessageEx(i, COLOR_YELLOW, "Gold VIP: You have received x2 paycheck as a birthday gift!");
			}
			
			if(PlayerInfo[i][pWRestricted] > 0 && --PlayerInfo[i][pWRestricted] == 0) {
				SendClientMessageEx(i, COLOR_LIGHTRED, "Your weapons are no longer restricted!");
			}
			
			if(PlayerInfo[i][pShopNotice] > 0) PlayerInfo[i][pShopNotice]--;
			if(ShopReminder == 1 && PlayerInfo[i][pShopNotice] == 0)
			{
				PlayerInfo[i][pShopCounter]++;
				PlayerInfo[i][mShopCounter]++;
				/*if(PlayerInfo[i][pLevel] <= 5 && PlayerInfo[i][mShopCounter] == 3 || (PlayerInfo[i][pLevel] > 5 && PlayerInfo[i][mShopCounter] >= 4 && PlayerInfo[i][pCredits] >= 10))
				{
					PlayerTextDrawSetString(i, MicroNotice[i], ShopMsg[PlayerInfo[i][mNotice]]);
					PlayerTextDrawShow(i, MicroNotice[i]);
					SetTimerEx("HidePlayerTextDraw", 10000, false, "ii", i, _:MicroNotice[i]);
					if(++PlayerInfo[i][mNotice] > 3) PlayerInfo[i][mNotice] = 0;
					PlayerInfo[i][mShopCounter] = 0;
				}
				if(PlayerInfo[i][pLevel] <= 5 && PlayerInfo[i][pShopCounter] == 5 || PlayerInfo[i][pLevel] > 5 && PlayerInfo[i][pShopCounter] == 10)
				{
					format(string, sizeof(string), "Hey check this out, type: ~y~/nggshop");
					if(PlayerInfo[i][pConnectHours] >= 50)
					{
						strcat(string, "~w~~n~To disable this notice for 24 hours, type: ~y~/togshopnotice");
					}
					PlayerInfo[i][pShopCounter] = 0;
					PlayerTextDrawSetString(i, ShopNotice[i], string);
					PlayerTextDrawShow(i, ShopNotice[i]);
					SetTimerEx("HidePlayerTextDraw", 10000, false, "ii", i, _:ShopNotice[i]);
				}*/
			}
			if(FIFEnabled == 1)
			{
				FIFInfo[i][FIFHours] += 1;
				if((FIFInfo[i][FIFHours] % 3) == 0)
				{
					if(FIFGThurs == 1)
					{
						GThursChances += 1;
						if(GThursChances == 23)
						{
							PlayerInfo[i][pGVIPVoucher] += 1;
							SendClientMessageEx(i, COLOR_WHITE, "You have won a 1 Month Gold VIP Voucher for Fall Into Fun! To claim it, type /myvouchers.");
							GThursChances = 0;
							format(string, sizeof(string), "%s(%d) won a 1 Month GVIP Voucher", GetPlayerNameEx(i), GetPlayerSQLId(i));
							Log("logs/fif.log", string);
						}
					}
					if(FIFGP3 == 1 && PlayerInfo[i][pDonateRank] >= 3)
					{
						FIFInfo[i][FIFChances] += 3;
						format(string,sizeof(string), "You have earned 3 FIF Chances! You now have %d chances!", FIFInfo[i][FIFChances]);
						SendClientMessageEx(i, COLOR_WHITE, string);
						format(string, sizeof(string), "%s(%d) won 3 FIF Chances", GetPlayerNameEx(i), GetPlayerSQLId(i));
						Log("logs/fif.log", string);
					}
					else
					{
						switch(FIFType)
						{
							case 1:
							{
								FIFInfo[i][FIFChances] += 1;
								format(string,sizeof(string), "You have earned 1 FIF Chance! You now have %d chances!", FIFInfo[i][FIFChances]);
								SendClientMessageEx(i, COLOR_WHITE, string);
								format(string, sizeof(string), "%s(%d) won 1 FIF Chance.", GetPlayerNameEx(i), GetPlayerSQLId(i));
								Log("logs/fif.log", string);
							}
							case 2:
							{
								FIFInfo[i][FIFChances] += 2;
								format(string,sizeof(string), "You have earned 2 FIF Chance's! You now have %d chances!", FIFInfo[i][FIFChances]);
								SendClientMessageEx(i, COLOR_WHITE, string);
								format(string, sizeof(string), "%s(%d) won 2 FIF Chances.", GetPlayerNameEx(i), GetPlayerSQLId(i));
								Log("logs/fif.log", string);
							}
							case 3:
							{
								FIFInfo[i][FIFChances] += 3;
								format(string,sizeof(string), "You have earned 3 FIF Chance's! You now have %d chances!", FIFInfo[i][FIFChances]);
								SendClientMessageEx(i, COLOR_WHITE, string);
								format(string, sizeof(string), "%s(%d) won 3 FIF Chances.", GetPlayerNameEx(i), GetPlayerSQLId(i));
								Log("logs/fif.log", string);
							}
						}
					}
				}
				if(FIFTimeWarrior == 1)
				{
					if(FIFInfo[i][FIFHours] % 28 == 0)
					{
						PlayerInfo[i][pGoldBoxTokens] += 1;
						SendClientMessageEx(i, COLOR_WHITE, "You have won a Gold Box Token for Fall Into Fun! To claim it, type /getrewardgift.");
						format(string, sizeof(string), "%s(%d) won a Gold Box Token", GetPlayerNameEx(i), GetPlayerSQLId(i));
						Log("logs/fif.log", string);
					}
				}
				g_mysql_SaveFIF(i);
			}
			if(month == 4 && (day == 25 || day == 26)) // NGG B-Day 2015
			{
				SendClientMessageEx(i, -1, "You have earned 3 event tokens for playing 1 hour! Use /inv to view your total token amount.");
				PlayerInfo[i][pEventTokens] += 3;
			}
			CallLocalFunction("InactivityCounter", "i", i);
		}
		else SendClientMessageEx(i, COLOR_LIGHTRED, "* You haven't played long enough to obtain a paycheck.");
	}

	if (GetPVarType(i, "UnreadMails") && HasMailbox(i))
	{
		SendClientMessageEx(i, COLOR_YELLOW, "You have unread items in your mailbox");
	}
	return 1;
}

forward GiveHtoy(giveplayerid, toyid, name[]);
public GiveHtoy(giveplayerid, toyid, name[]) {
	new icount = GetPlayerToySlots(giveplayerid), success = 0, string[128];
	for(new v = 0; v < icount; v++)
	{
		if(PlayerToyInfo[giveplayerid][v][ptModelID] == 0)
		{
			PlayerToyInfo[giveplayerid][v][ptModelID] = toyid;
			PlayerToyInfo[giveplayerid][v][ptBone] = 6;
			PlayerToyInfo[giveplayerid][v][ptPosX] = 0.0;
			PlayerToyInfo[giveplayerid][v][ptPosY] = 0.0;
			PlayerToyInfo[giveplayerid][v][ptPosZ] = 0.0;
			PlayerToyInfo[giveplayerid][v][ptRotX] = 0.0;
			PlayerToyInfo[giveplayerid][v][ptRotY] = 0.0;
			PlayerToyInfo[giveplayerid][v][ptRotZ] = 0.0;
			PlayerToyInfo[giveplayerid][v][ptScaleX] = 1.0;
			PlayerToyInfo[giveplayerid][v][ptScaleY] = 1.0;
			PlayerToyInfo[giveplayerid][v][ptScaleZ] = 1.0;
			PlayerToyInfo[giveplayerid][v][ptTradable] = 1;
			
			g_mysql_NewToy(giveplayerid, v);
			success = 1;
			break;
		}
	}
	
	if(success == 0)
	{
		for(new i = 0; i < MAX_PLAYERTOYS; i++)
		{
			if(PlayerToyInfo[giveplayerid][i][ptModelID] == 0)
			{
				PlayerToyInfo[giveplayerid][i][ptModelID] = toyid;
				PlayerToyInfo[giveplayerid][i][ptBone] = 6;
				PlayerToyInfo[giveplayerid][i][ptPosX] = 0.0;
				PlayerToyInfo[giveplayerid][i][ptPosY] = 0.0;
				PlayerToyInfo[giveplayerid][i][ptPosZ] = 0.0;
				PlayerToyInfo[giveplayerid][i][ptRotX] = 0.0;
				PlayerToyInfo[giveplayerid][i][ptRotY] = 0.0;
				PlayerToyInfo[giveplayerid][i][ptRotZ] = 0.0;
				PlayerToyInfo[giveplayerid][i][ptScaleX] = 1.0;
				PlayerToyInfo[giveplayerid][i][ptScaleY] = 1.0;
				PlayerToyInfo[giveplayerid][i][ptScaleZ] = 1.0;
				PlayerToyInfo[giveplayerid][i][ptTradable] = 1;
				PlayerToyInfo[giveplayerid][i][ptSpecial] = 1;
				
				g_mysql_NewToy(giveplayerid, i); 
				
				SendClientMessageEx(giveplayerid, COLOR_GRAD1, "Due to you not having any available slots, we've temporarily gave you an additional slot to use/sell/trade your %s.", name);
				SendClientMessageEx(giveplayerid, COLOR_RED, "Note: Please take note that after selling the %s, the temporarily additional toy slot will be removed.", name);
				break;
			}	
		}
	}

	SendClientMessageEx(giveplayerid, COLOR_GRAD2, "For playing %d hours you have recived a %s!", PlayerInfo[giveplayerid][pTrickortreat], name);
	format(string, sizeof(string), "* %s was just gifted a %s!", GetPlayerNameEx(giveplayerid), name);
	ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
	format(string, sizeof(string), "* %s(%d) was just gifted a %s for playing %d hours during the zombie event.", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), name, PlayerInfo[giveplayerid][pTrickortreat]);
	Log("logs/giftbox.log", string), OnPlayerStatsUpdate(giveplayerid);
	return 1;
}

stock IsAtATM(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		if(IsPlayerInRangeOfPoint(playerid,3.0,2065.439453125, -1897.5510253906, 13.19670009613) || IsPlayerInRangeOfPoint(playerid,3.0,1497.7467041016, -1749.8747558594, 15.088212013245) || IsPlayerInRangeOfPoint(playerid,3.0,2093.5124511719, -1359.5474853516, 23.62727355957) || IsPlayerInRangeOfPoint(playerid,3.0,1155.6235351563, -1464.9141845703, 15.44321346283))
		{//ATMS
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,3.0,2139.4487304688, -1164.0811767578, 23.63508605957) || IsPlayerInRangeOfPoint(playerid,3.0,1482.7761230469, -1010.3353881836, 26.48664855957) || IsPlayerInRangeOfPoint(playerid,3.0,1482.7761230469, -1010.3353881836, 26.48664855957) || IsPlayerInRangeOfPoint(playerid,3.0,387.16552734375, -1816.0512695313, 7.4834146499634))
		{//ATMS
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,3.0,-24.385023117065, -92.001075744629, 1003.1897583008) || IsPlayerInRangeOfPoint(playerid,3.0,-31.811220169067, -58.106018066406, 1003.1897583008) || IsPlayerInRangeOfPoint(playerid,3.0,1212.7785644531, 2.451762676239, 1000.5647583008) || IsPlayerInRangeOfPoint(playerid,3.0,2324.4028320313, -1644.9445800781, 14.469946861267))
		{//ATMS
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,3.0,2228.39, -1707.78, 13.25) || IsPlayerInRangeOfPoint(playerid,3.0,651.19305419922, -520.48815917969, 15.978837013245) || IsPlayerInRangeOfPoint(playerid, 3.0, 45.78035736084, -291.80926513672, 1.5024013519287) || IsPlayerInRangeOfPoint(playerid,3.0,1275.7958984375, 368.31481933594, 19.19758605957) || IsPlayerInRangeOfPoint(playerid,3.0,2303.4577636719, -13.539554595947, 26.12727355957))/*End of Red County Random ATM's*/
		{//ATMS
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,3.0,294.80, -84.01, 1001.0) || /*Start of Red County Random ATM's*/IsPlayerInRangeOfPoint(playerid,3.0,691.08215332031, -618.5625, 15.978837013245) || IsPlayerInRangeOfPoint(playerid,3.0,173.23471069336, -155.07606506348, 1.2210245132446) || IsPlayerInRangeOfPoint(playerid,3.0,1260.8796386719, 209.30152893066, 19.19758605957) || IsPlayerInRangeOfPoint(playerid,3.0,2316.1015625, -88.522567749023, 26.12727355957))/*End of Red County Random ATM's*/
		{//ATMS
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,3.0,1311.0361,-1446.2249,0.2216))
		{//ATMS
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,3.0,2052.9246, -1660.6346, 13.1300) || IsPlayerInRangeOfPoint(playerid,3.0,-1980.6300,121.5300,27.3100))
		{
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,3.0,-2453.7600,754.8200,34.8000) || IsPlayerInRangeOfPoint(playerid,3.0,-2678.6201,-283.3400,6.8000))
		{
		    return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,5.0,519.8157,-2890.8601,4.4609))
		{
		    return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,5.0,2565.667480, 1406.839355, 7699.584472) || IsPlayerInRangeOfPoint(playerid, 5.0, 3265.30004883, -631.90002441, 8423.90039062) || IsPlayerInRangeOfPoint(playerid, 5.0, 1829.5000, 1391.0000, 1464.0000) || IsPlayerInRangeOfPoint(playerid, 5.0, 1755.8000, 1434.1000, 2013.4000))
		{// VIP Lounge ATM || Package Club Interior
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,5.0,-665.975341, -4033.334716, 20.779014) || IsPlayerInRangeOfPoint(playerid,5.0,-1619.9645996094,713.67535400391, 19995.501953125))
		{// Random Island ATM
			return 1;
		}
		// Famed Lounge
		else if(IsPlayerInRangeOfPoint(playerid, 3.0, 883.7170, 1442.4282, -82.3370))
		{
		    return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid, 3.0, 2926.9199, -1529.9800, 10.6900)) return 1; //NGG Shop
		else if(IsPlayerInRangeOfPoint(playerid, 3.0, 986.4434,2056.2480,1085.8531) || IsPlayerInRangeOfPoint(playerid, 3.0, 1014.1396,2060.8284,1085.8531) || IsPlayerInRangeOfPoint(playerid, 3.0, 1013.4720,2023.8784,1085.8531)) return 1; //Glen Park
		else if(IsPlayerInRangeOfPoint(playerid, 3.0, 1378.0894, 1740.0106, 927.3564)) return 1; //Olympics
	}
	return 0;
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
	else if(!(1 <= amount <= 99999999)) {
		SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot pay below $1, or above $99,999,999 at once.");
	}
	else if(gettime()-GetPVarInt(playerid, "LastTransaction") < 10) {
		SendClientMessageEx(playerid, COLOR_GRAD2, "You can only make a transaction once every 10 seconds, please wait!");
	}
	else if(PlayerInfo[playerid][pCash] < 0 || PlayerInfo[playerid][pAccount] < 0) {
		SendClientMessageEx(playerid, COLOR_GRAD1, "Your cash on-hand or in the bank is currently at a negative value!");
	}
	else if(2 <= PlayerInfo[playerid][pAdmin] <= 4 || 2 <= PlayerInfo[id][pAdmin] <= 4) return 1;
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
    if(monies < 1 || monies > 99999999)
	{
        SendClientMessageEx(playerid, COLOR_GRAD1, "   You can't write a check for under $1 or over $99,999,999!");
        return 1;
    }
	if(PlayerInfo[playerid][pCash] < 0 || PlayerInfo[playerid][pAccount] < 0)
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "Your cash on-hand or in the bank is currently at a negative value!");
	}
    if(PlayerInfo[playerid][pChecks] == 0)
	{
        SendClientMessageEx(playerid, COLOR_GRAD1, "   You must have a checkbook to write a check!");
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
			if(!Bank_TransferCheck(-monies)) return 1;
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
	new moneys;
	if(sscanf(params, "d", moneys)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /charity [amount]");
	if(moneys < 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "That is not enough.");
	if(GetPlayerCash(playerid) < moneys) return SendClientMessageEx(playerid, COLOR_GRAD1, "You don't have that much money.");
	GivePlayerCash(playerid, -moneys);

	format(szMiscArray, sizeof(szMiscArray), "%s, thank you for your donation of $%s.", GetPlayerNameEx(playerid), number_format(moneys));
	PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	SendClientMessageEx(playerid, COLOR_GRAD1, szMiscArray);
	format(szMiscArray, sizeof(szMiscArray), "[CHARITY] %s has donated $%s", GetPlayerNameEx(playerid), number_format(moneys));
	Log("logs/pay.log", szMiscArray);
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
