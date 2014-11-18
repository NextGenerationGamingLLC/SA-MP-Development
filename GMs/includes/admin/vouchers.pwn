/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Vouchers System

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

stock ShowVouchers(playerid, targetid)
{
	if(IsPlayerConnected(targetid))
	{
		new szDialog[1024], szTitle[MAX_PLAYER_NAME+9];
		SetPVarInt(playerid, "WhoIsThis", targetid);
		
		format(szTitle, sizeof(szTitle), "%s Vouchers", GetPlayerNameEx(targetid));
		format(szDialog, sizeof(szDialog), "Car Voucher(s):\t\t\t{18F0F0}%d\nSilver VIP Voucher(s):\t\t{18F0F0}%d\nGold VIP Voucher(s):\t\t{18F0F0}%d\nPlatinum VIP Voucher(s):\t{18F0F0}%d\nRestricted Car Voucher(s):\t{18F0F0}%d\nGift Reset Voucher(s):\t\t{18F0F0}%d\n" \
		"Priority Advert Voucher(s):\t{18F0F0}%d\n7 Days SVIP Voucher(s): \t{18F0F0}%d\n7 Days GVIP Voucher(s):\t{18F0F0}%d\n",
		PlayerInfo[targetid][pVehVoucher], PlayerInfo[targetid][pSVIPVoucher], PlayerInfo[targetid][pGVIPVoucher], PlayerInfo[targetid][pPVIPVoucher], PlayerInfo[targetid][pCarVoucher], PlayerInfo[targetid][pGiftVoucher], PlayerInfo[targetid][pAdvertVoucher], PlayerInfo[targetid][pSVIPExVoucher], PlayerInfo[targetid][pGVIPExVoucher]);
		ShowPlayerDialog(playerid, DIALOG_VOUCHER, DIALOG_STYLE_LIST, szTitle, szDialog, "Select", "Close");
	}
	return 1;
}	

// Start of the voucher commands
CMD:myvouchers(playerid, params[])
{
	if(PlayerInfo[playerid][pJailTime] > 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot use this command while being in jail/prison.");
	
	ShowVouchers(playerid, playerid);
	return 1;
}

CMD:checkvouchers(playerid, params[])
{
	new targetid;
	if(PlayerInfo[playerid][pAdmin] < 4) return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not authorized to use this command!");
	if(sscanf(params, "u", targetid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /checkvouchers [player]");
	if(!IsPlayerConnected(targetid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid player specified.");
	
	ShowVouchers(playerid, targetid);
	return 1;
}		

CMD:sellvoucher(playerid, params[])
{
	new choice[32], amount, price, buyer;
    if(sscanf(params, "s[32]ddu", choice, amount, price, buyer))
	{
	    SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /sellvoucher [name] [amount] [price] [buyer]");
		SendClientMessageEx(playerid, COLOR_GREY, "Available names: CarVoucher, SilverVIP, GoldVIP, PVIP, RestrictedCar, Advert, 7DaySVIP, 7DayGVIP");
		return 1;
	}
	
	new Float: bPos[3];
	GetPlayerPos(buyer, bPos[0], bPos[1], bPos[2]);
	if(GetPlayerVirtualWorld(buyer) != GetPlayerVirtualWorld(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not near this player.");
	if(price < 1 || price > 99999999) return SendClientMessageEx(playerid, COLOR_GRAD1, "You must specify a price greater than $0 or less than $99,999,999.");
	if(amount < 1) return SendClientMessageEx(playerid, COLOR_GREY, "Invalid amount specified.");
	if(!IsPlayerConnected(buyer)) return SendClientMessageEx(playerid, COLOR_GRAD1, "This player isn't connected.");
	if(!IsPlayerInRangeOfPoint(playerid, 5.0, bPos[0], bPos[1], bPos[2])) return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not near this player.");
	if(GetPVarInt(playerid, "Injured") != 0 || PlayerCuffed[playerid] != 0 || PlayerInfo[playerid][pJailTime] > 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can't do that right now.");
	if(GetPVarInt(buyer, "Injured") != 0 || PlayerCuffed[buyer] != 0 || PlayerInfo[buyer][pJailTime] > 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can't offer a Prisoner or a Injured player a voucher.");
	if(GetPVarInt(buyer, "buyingVoucher") != INVALID_PLAYER_ID) return SendClientMessageEx(playerid, COLOR_GRAD1, "This player is already buying another voucher, please try again later.");
	
	new string[128];
	if(strcmp(choice, "carvoucher", true) == 0) 
	{
		if(amount > PlayerInfo[playerid][pVehVoucher]) return SendClientMessageEx(playerid, COLOR_GRAD1, "You do not have that much vouchers.");
		
		SetPVarInt(buyer, "priceVoucher", price);
		SetPVarInt(buyer, "amountVoucher", amount);
		SetPVarInt(buyer, "buyingVoucher", 1);
		SetPVarInt(buyer, "sellerVoucher", playerid);
		SetPVarInt(playerid, "buyerVoucher", buyer);
		format(string, sizeof(string), "%s has offered to sell you %d car voucher(s) for $%s - Type /accept voucher or /denyvoucher.", GetPlayerNameEx(playerid), amount, number_format(price));
		SendClientMessageEx(buyer, COLOR_LIGHTBLUE, string);
		format(string, sizeof(string), "You have offered %s %d car voucher(s) for $%s, please wait until he accept/decline the offer.", GetPlayerNameEx(buyer), amount, number_format(price));
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
		SetPVarInt(buyer, "SQLID_Voucher", GetPlayerSQLId(playerid));
	}
	else if(strcmp(choice, "silvervip", true) == 0) 
	{
		if(amount > PlayerInfo[playerid][pSVIPVoucher]) return SendClientMessageEx(playerid, COLOR_GRAD1, "You do not have that much vouchers.");
		
		SetPVarInt(buyer, "priceVoucher", price);
		SetPVarInt(buyer, "amountVoucher", amount);
		SetPVarInt(buyer, "buyingVoucher", 2);
		SetPVarInt(buyer, "sellerVoucher", playerid);
		SetPVarInt(playerid, "buyerVoucher", buyer);
		format(string, sizeof(string), "%s has offered to sell you %d Silver VIP voucher(s) for $%s - Type /accept voucher or /denyvoucher.", GetPlayerNameEx(playerid), amount, number_format(price));
		SendClientMessageEx(buyer, COLOR_LIGHTBLUE, string);
		format(string, sizeof(string), "You have offered %s %d Silver VIP voucher(s) for $%s, please wait until he accept/decline the offer.", GetPlayerNameEx(buyer), amount, number_format(price));
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
		SetPVarInt(buyer, "SQLID_Voucher", GetPlayerSQLId(playerid));
	}
	else if(strcmp(choice, "goldvip", true) == 0) 
	{
		if(amount > PlayerInfo[playerid][pGVIPVoucher]) return SendClientMessageEx(playerid, COLOR_GRAD1, "You do not have that much vouchers.");
		
		SetPVarInt(buyer, "priceVoucher", price);
		SetPVarInt(buyer, "amountVoucher", amount);
		SetPVarInt(buyer, "buyingVoucher", 3);
		SetPVarInt(buyer, "sellerVoucher", playerid);
		SetPVarInt(playerid, "buyerVoucher", buyer);
		format(string, sizeof(string), "%s has offered to sell you %d Gold VIP voucher(s) for $%s - Type /accept voucher or /denyvoucher.", GetPlayerNameEx(playerid), amount, number_format(price));
		SendClientMessageEx(buyer, COLOR_LIGHTBLUE, string);
		format(string, sizeof(string), "You have offered %s %d Gold VIP voucher(s) for $%s, please wait until he accept/decline the offer.", GetPlayerNameEx(buyer), amount, number_format(price));
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
		SetPVarInt(buyer, "SQLID_Voucher", GetPlayerSQLId(playerid));
	}
	else if(strcmp(choice, "pvip", true) == 0)
	{
		if(amount > PlayerInfo[playerid][pPVIPVoucher]) return SendClientMessageEx(playerid, COLOR_GRAD1, "You do not have that much vouchers.");

		SetPVarInt(buyer, "priceVoucher", price);
		SetPVarInt(buyer, "amountVoucher", amount);
		SetPVarInt(buyer, "buyingVoucher", 4);
		SetPVarInt(buyer, "sellerVoucher", playerid);
		SetPVarInt(playerid, "buyerVoucher", buyer);
		format(string, sizeof(string), "%s has offered to sell you %d Platinum VIP voucher(s) for $%s - Type /accept voucher or /denyvoucher.", GetPlayerNameEx(playerid), amount, number_format(price));
		SendClientMessageEx(buyer, COLOR_LIGHTBLUE, string);
		format(string, sizeof(string), "You have offered %s %d Platinum VIP voucher(s) for $%s, please wait until he accept/decline the offer.", GetPlayerNameEx(buyer), amount, number_format(price));
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	 	SetPVarInt(buyer, "SQLID_Voucher", GetPlayerSQLId(playerid));
	}
	else if(strcmp(choice, "restrictedcar", true) == 0)
	{
		if(amount > PlayerInfo[playerid][pCarVoucher]) return SendClientMessageEx(playerid, COLOR_GRAD1, "You do not have that much vouchers.");

		SetPVarInt(buyer, "priceVoucher", price);
		SetPVarInt(buyer, "amountVoucher", amount);
		SetPVarInt(buyer, "buyingVoucher", 5);
		SetPVarInt(buyer, "sellerVoucher", playerid);
		SetPVarInt(playerid, "buyerVoucher", buyer);
		format(string, sizeof(string), "%s has offered to sell you %d Restricted Car voucher(s) for $%s - Type /accept voucher or /denyvoucher.", GetPlayerNameEx(playerid), amount, number_format(price));
		SendClientMessageEx(buyer, COLOR_LIGHTBLUE, string);
		format(string, sizeof(string), "You have offered %s %d Restricted Car voucher(s) for $%s, please wait until he accept/decline the offer.", GetPlayerNameEx(buyer), amount, number_format(price));
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	 	SetPVarInt(buyer, "SQLID_Voucher", GetPlayerSQLId(playerid));
	}
	else if(strcmp(choice, "advert", true) == 0)
	{
		if(amount > PlayerInfo[playerid][pAdvertVoucher]) return SendClientMessageEx(playerid, COLOR_GRAD1, "You do not have that much vouchers.");

		SetPVarInt(buyer, "priceVoucher", price);
		SetPVarInt(buyer, "amountVoucher", amount);
		SetPVarInt(buyer, "buyingVoucher", 6);
		SetPVarInt(buyer, "sellerVoucher", playerid);
		SetPVarInt(playerid, "buyerVoucher", buyer);
		format(string, sizeof(string), "%s has offered to sell you %d Priority Advertisement voucher(s) for $%s - Type /accept voucher or /denyvoucher.", GetPlayerNameEx(playerid), amount, number_format(price));
		SendClientMessageEx(buyer, COLOR_LIGHTBLUE, string);
		format(string, sizeof(string), "You have offered %s %d Priority Advertisement voucher(s) for $%s, please wait until he accept/decline the offer.", GetPlayerNameEx(buyer), amount, number_format(price));
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	 	SetPVarInt(buyer, "SQLID_Voucher", GetPlayerSQLId(playerid));
	}
	else if(strcmp(choice, "7daysvip", true) == 0)
	{
		if(amount > PlayerInfo[playerid][pSVIPExVoucher]) return SendClientMessageEx(playerid, COLOR_GRAD1, "You do not have that much vouchers.");

		SetPVarInt(buyer, "priceVoucher", price);
		SetPVarInt(buyer, "amountVoucher", amount);
		SetPVarInt(buyer, "buyingVoucher", 7);
		SetPVarInt(buyer, "sellerVoucher", playerid);
		SetPVarInt(playerid, "buyerVoucher", buyer);
		format(string, sizeof(string), "%s has offered to sell you %d 7 Days Silver VIP voucher(s) for $%s - Type /accept voucher or /denyvoucher.", GetPlayerNameEx(playerid), amount, number_format(price));
		SendClientMessageEx(buyer, COLOR_LIGHTBLUE, string);
		format(string, sizeof(string), "You have offered %s %d 7 Days Silver VIP voucher(s) for $%s, please wait until he accept/decline the offer.", GetPlayerNameEx(buyer), amount, number_format(price));
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	 	SetPVarInt(buyer, "SQLID_Voucher", GetPlayerSQLId(playerid));
	}
	else if(strcmp(choice, "7daygvip", true) == 0)
	{
		if(amount > PlayerInfo[playerid][pGVIPExVoucher]) return SendClientMessageEx(playerid, COLOR_GRAD1, "You do not have that much vouchers.");

		SetPVarInt(buyer, "priceVoucher", price);
		SetPVarInt(buyer, "amountVoucher", amount);
		SetPVarInt(buyer, "buyingVoucher", 8);
		SetPVarInt(buyer, "sellerVoucher", playerid);
		SetPVarInt(playerid, "buyerVoucher", buyer);
		format(string, sizeof(string), "%s has offered to sell you %d 7 Days Gold VIP voucher(s) for $%s - Type /accept voucher or /denyvoucher.", GetPlayerNameEx(playerid), amount, number_format(price));
		SendClientMessageEx(buyer, COLOR_LIGHTBLUE, string);
		format(string, sizeof(string), "You have offered %s %d 7 Days Gold VIP voucher(s) for $%s, please wait until he accept/decline the offer.", GetPlayerNameEx(buyer), amount, number_format(price));
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	 	SetPVarInt(buyer, "SQLID_Voucher", GetPlayerSQLId(playerid));
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid choice.");
	return 1;
}	

CMD:denyvoucher(playerid, params[])
{
	if(GetPVarInt(playerid, "buyingVoucher") != INVALID_PLAYER_ID)
	{
		new string[128];
		format(string, sizeof(string), "* %s has declined your voucher offer.", GetPlayerNameEx(playerid));
		SendClientMessageEx(GetPVarInt(playerid, "sellerVoucher"), COLOR_LIGHTBLUE, string);
		format(string, sizeof(string), "* You have declined %s voucher offer.", GetPlayerNameEx(GetPVarInt(playerid, "sellerVoucher")));
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
		DeletePVar(playerid, "priceVoucher");
		DeletePVar(playerid, "amountVoucher");
		SetPVarInt(playerid, "buyingVoucher", INVALID_PLAYER_ID);
		SetPVarInt(playerid, "sellerVoucher", INVALID_PLAYER_ID);
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD1, "No-one has offered you any vouchers.");
	return 1;
}		

CMD:voucherhelp(playerid, params[])
{
	SendClientMessageEx(playerid, COLOR_GRAD1, "** Player Commands: /myvouchers /denyvoucher /accept voucher");
	if(PlayerInfo[playerid][pAdmin] >= 4)
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "** Admin Commands: /checkvouchers");
	}
	return 1;
}	
//end of the voucher commands