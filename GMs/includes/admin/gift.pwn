/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Gift System

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

forward GiftPlayer_(playerid, giveplayerid, gtype); // For use via CallRemoteFunction
public GiftPlayer_(playerid, giveplayerid, gtype) return GiftPlayer(playerid, giveplayerid, gtype);

stock GiftPlayer(playerid, giveplayerid, gtype = 2) // Default is the normal giftbox
{
	if(gtype == 1)
	{
		if(GetPVarInt(giveplayerid, "GiftFail") >= 20) 
		{ 
			new string[128];
			GivePlayerCash(giveplayerid, 20000);
			SendClientMessageEx(giveplayerid, COLOR_GRAD2, "Congratulations, you have won $20,000!");
			format(string, sizeof(string), "* %s was just gifted $20,000, enjoy!", GetPlayerNameEx(giveplayerid));
			ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
			format(string, sizeof(string), "* %s(%d) was just gifted $20,000, enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid));
			SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
			return true;
		}
		SetPVarInt(giveplayerid, "GiftFail", GetPVarInt(giveplayerid, "GiftFail")+1);
	}
	
	new string[128], value = 0;
	if(gtype == 1)
	{
		if(IsPlayerConnected(giveplayerid))
		{
			if(playerid != MAX_PLAYERS && PlayerInfo[playerid][pAdmin] < 2) return true;
			
			if(playerid != MAX_PLAYERS) return GiftPlayer(MAX_PLAYERS, giveplayerid, 1);
			
			new randgift = Random(0, 100);
			printf("randgift %d", randgift);
			switch(randgift)
			{
				case 0..50: // cat 1 - Common gifts
				{
					new randy = random(32);
					printf("cat 1 %d", randy);
					if(randy == 0)
					{
						if(dgVar[dgMoney][3] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgMoney][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgMoney][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						
						GivePlayerCash(giveplayerid, dgVar[dgMoney][2]);
						format(string, sizeof(string), "Congratulations, you have won $%s!", number_format(dgVar[dgMoney][2]));
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted $%s, enjoy!", GetPlayerNameEx(giveplayerid), number_format(dgVar[dgMoney][2]));
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgMoney][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted $%s, enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), number_format(dgVar[dgMoney][2]));
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 1)
					{
						if(dgVar[dgRimKit][3] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgRimKit][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgRimKit][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pRimMod] += dgVar[dgRimKit][2];
						format(string, sizeof(string), "Congratulations, you have won %d rimkit(s)!", dgVar[dgRimKit][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d rimkit(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgRimKit][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgRimKit][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d rimkit(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgRimKit][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 2)
					{
						if(dgVar[dgFirework][3] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgFirework][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgFirework][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pFirework] += dgVar[dgFirework][2];
						format(string, sizeof(string), "Congratulations, you have won %d firework(s)!", dgVar[dgFirework][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d firework(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgFirework][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgFirework][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d firework(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgFirework][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 3)
					{
						if(dgVar[dgGVIP][3] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgGVIP][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgGVIP][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pGVIPExVoucher] += dgVar[dgGVIP][2];
						format(string, sizeof(string), "Congratulations, you have won %d Seven day Gold VIP Voucher(s)!", dgVar[dgGVIP][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Seven day Gold VIP Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgGVIP][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgGVIP][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Seven day Gold VIP Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgGVIP][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 4)
					{
						if(dgVar[dgGVIPEx][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgGVIPEx][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgGVIPEx][3] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pGVIPVoucher] += dgVar[dgGVIPEx][2];
						format(string, sizeof(string), "Congratulations, you have won %d One Month Gold VIP Voucher(s)!", dgVar[dgGVIPEx][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d One Month Gold VIP Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgGVIPEx][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgGVIPEx][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d One Month Gold VIP Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgGVIPEx][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}

					if(randy == 5)
					{
						if(dgVar[dgSVIP][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgSVIP][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgSVIP][3] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pSVIPExVoucher] += dgVar[dgSVIP][2];
						format(string, sizeof(string), "Congratulations, you have won %d Seven day Silver VIP Voucher (s)!", dgVar[dgSVIP][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Seven day Silver VIP Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgSVIP][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgSVIP][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Seven day Silver VIP Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgSVIP][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 6)
					{
						if(dgVar[dgSVIPEx][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgSVIPEx][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgSVIPEx][3] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pSVIPVoucher] += dgVar[dgSVIPEx][2];
						format(string, sizeof(string), "Congratulations, you have won %d One Month Silver VIP Voucher(s)!", dgVar[dgSVIPEx][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d One Month Silver VIP Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgSVIPEx][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgSVIPEx][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d One Month Silver VIP Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgSVIPEx][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 7)
					{
						if(dgVar[dgCarSlot][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgCarSlot][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgCarSlot][3] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pVehicleSlot] += dgVar[dgCarSlot][2];
						format(string, sizeof(string), "Congratulations, you have won %d Car Slot(s)!", dgVar[dgCarSlot][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Car Slot(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgCarSlot][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgCarSlot][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Car Slot(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgCarSlot][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 8)
					{
						if(dgVar[dgToySlot][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgCarSlot][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgCarSlot][3] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pToySlot] += dgVar[dgToySlot][2];
						format(string, sizeof(string), "Congratulations, you have won %d Toy Slot(s)!", dgVar[dgToySlot][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Toy Slot(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgToySlot][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgToySlot][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Toy Slot(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgToySlot][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 9)
					{
						if(dgVar[dgArmor][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgArmor][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgArmor][3] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						
						new Float: armor;
						GetArmour(giveplayerid, armor);
						
						if(armor+dgVar[dgArmor][2] >= 100) return GiftPlayer(playerid, giveplayerid, 1);
						
						SetArmour(giveplayerid, armor + dgVar[dgArmor][2]);
						format(string, sizeof(string), "Congratulations, you have won %d Armour!", dgVar[dgArmor][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Armour, enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgArmor][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgArmor][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Armour, enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgArmor][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 10)
					{
						if(dgVar[dgFirstaid][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgFirstaid][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgFirstaid][3] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pFirstaid] += dgVar[dgFirstaid][2];
						format(string, sizeof(string), "Congratulations, you have won %d Firstaid(s)!", dgVar[dgFirstaid][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Firstaid(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgFirstaid][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgFirstaid][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Firstaid(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgFirstaid][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 11)
					{
						if(dgVar[dgDDFlag][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgDDFlag][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgDDFlag][3] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						
						AddFlag(giveplayerid, INVALID_PLAYER_ID, "Dynamic Gift Box: 1 Dynamic Door");
						
						format(string, sizeof(string), "Congratulations, you have won %d Dynamic Door Flag(s)!", dgVar[dgDDFlag][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Note: This prize may take up to 48 hours to be rewarded..");
						format(string, sizeof(string), "* %s was just gifted %d Dynamic Door Flag(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgDDFlag][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgDDFlag][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Dynamic Door Flag(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgDDFlag][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 12)
					{
						if(dgVar[dgGateFlag][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgGateFlag][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgGateFlag][3] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						
						AddFlag(giveplayerid, INVALID_PLAYER_ID, "Dynamic Gift Box: 1 Gate Gate");
						
						format(string, sizeof(string), "Congratulations, you have won %d Gate Flag(s)!", dgVar[dgGateFlag][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Note: This prize may take up to 48 hours to be rewarded..");
						format(string, sizeof(string), "* %s was just gifted %d Dynamic Gate Flag(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgGateFlag][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgGateFlag][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Dynamic Gate Flag(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgGateFlag][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 13)
					{
						if(dgVar[dgCredits][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgCredits][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgCredits][3] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						
						GivePlayerCredits(giveplayerid, dgVar[dgCredits][2], 1);
						format(string, sizeof(string), "Congratulations, you have won %d Credit(s)!", dgVar[dgCredits][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Credit(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgCredits][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgCredits][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Credit(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgCredits][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 14)
					{
						if(dgVar[dgPriorityAd][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgPriorityAd][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgPriorityAd][3] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pAdvertVoucher] += dgVar[dgPriorityAd][2];
						format(string, sizeof(string), "Congratulations, you have won %d Priority Advertisement Voucher(s)!", dgVar[dgPriorityAd][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Priority Advertisement Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgPriorityAd][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgPriorityAd][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Priority Advertisement Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgPriorityAd][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 15)
					{
						if(dgVar[dgHealthNArmor][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgHealthNArmor][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgHealthNArmor][3] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						
						SetHealth(giveplayerid, 100.0);
						SetArmour(giveplayerid, 100);
						format(string, sizeof(string), "Congratulations, you have won Full Health & Armor!");
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Full Health & Armor, enjoy!", GetPlayerNameEx(giveplayerid));
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgHealthNArmor][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Full Health & Armor, enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid));
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 16)
					{
						if(dgVar[dgGiftReset][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgGiftReset][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgGiftReset][3] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pGiftVoucher] += dgVar[dgGiftReset][2];
						format(string, sizeof(string), "Congratulations, you have won a %d Gift Reset Voucher(s)!", dgVar[dgGiftReset][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Gift Reset Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgGiftReset][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgGiftReset][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Gift Reset Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgGiftReset][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 17)
					{
						if(dgVar[dgMaterial][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgMaterial][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgMaterial][3] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pMats] += dgVar[dgMaterial][2];
						format(string, sizeof(string), "Congratulations, you have won a %d Material(s)!", dgVar[dgMaterial][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Material(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgMaterial][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgMaterial][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Material(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgMaterial][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 18)
					{
						if(dgVar[dgWarning][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgWarning][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgWarning][3] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						
						if(dgVar[dgWarning][2] > 3 || dgVar[dgWarning][2] < 0)
						{						
							if(PlayerInfo[giveplayerid][pWarns] == 0) return GiftPlayer(playerid, giveplayerid, 1);
							
							PlayerInfo[giveplayerid][pWarns] -= dgVar[dgWarning][2];
						}
						else
							return GiftPlayer(playerid, giveplayerid, 1);
							
						format(string, sizeof(string), "Congratulations, you have won a %d Warning(s) Removal!", dgVar[dgWarning][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Warning(s) Removal, enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgWarning][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgWarning][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Warning(s) Removal, enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgWarning][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 19)
					{
						if(dgVar[dgPot][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgPot][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgPot][3] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pDrugs][0] += dgVar[dgPot][2];
						format(string, sizeof(string), "Congratulations, you have won %d pot!", dgVar[dgPot][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d pot, enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgPot][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgPot][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d pot, enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgPot][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 20)
					{
						if(dgVar[dgCrack][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgCrack][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgCrack][3] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pDrugs][1] += dgVar[dgCrack][2];
						format(string, sizeof(string), "Congratulations, you have won %d Crack!", dgVar[dgCrack][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Crack, enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgCrack][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgCrack][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Crack, enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgCrack][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 21)
					{
						if(dgVar[dgPaintballToken][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgPaintballToken][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgPaintballToken][3] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(PlayerInfo[giveplayerid][pDonateRank] >= 4) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pPaintTokens] += dgVar[dgPaintballToken][2];
						format(string, sizeof(string), "Congratulations, you have won a %d Paintball Token(s)!", dgVar[dgPaintballToken][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Paintball Token(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgPaintballToken][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgPaintballToken][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Paintball Token(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgPaintballToken][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 22)
					{
						if(dgVar[dgVIPToken][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgVIPToken][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgVIPToken][3] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(PlayerInfo[giveplayerid][pDonateRank] >= 4) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pTokens] += dgVar[dgVIPToken][2];
						format(string, sizeof(string), "Congratulations, you have won a %d VIP Token(s)!", dgVar[dgVIPToken][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d VIP Token(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgVIPToken][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgVIPToken][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d VIP Token(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgVIPToken][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 23)
					{
						if(dgVar[dgRespectPoint][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgRespectPoint][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgRespectPoint][3] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pExp] += dgVar[dgRespectPoint][2];
						format(string, sizeof(string), "Congratulations, you have won a %d Respect Point(s)!", dgVar[dgRespectPoint][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Respect Point(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgRespectPoint][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgRespectPoint][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Respect Point(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgRespectPoint][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 24)
					{
						if(dgVar[dgCarVoucher][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgCarVoucher][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgCarVoucher][3] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pVehVoucher] += dgVar[dgCarVoucher][2];
						format(string, sizeof(string), "Congratulations, you have won a %d Car Voucher(s)!", dgVar[dgCarVoucher][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Car Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgCarVoucher][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgCarVoucher][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Car Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgCarVoucher][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 25)
					{
						if(dgVar[dgBuddyInvite][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgBuddyInvite][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgBuddyInvite][3] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(PlayerInfo[giveplayerid][pDonateRank] != 0) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pDonateRank] = 1;
						PlayerInfo[giveplayerid][pTempVIP] = 180;
						PlayerInfo[giveplayerid][pBuddyInvited] = 1;
						format(string, sizeof(string), "BUDDY INVITE: %s(%d) has been invited to VIP by System", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid));
						Log("logs/setvip.log", string);
					
						format(string, sizeof(string), "Congratulations, you have won a Buddy Invite!");
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted a BuddyInvite, enjoy!", GetPlayerNameEx(giveplayerid));
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgBuddyInvite][1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 26)
					{
						if(dgVar[dgLaser][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgLaser][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgLaser][3] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						
						new icount = GetPlayerToySlots(giveplayerid), success = 0;
						for(new v = 0; v < icount; v++)
						{
							if(PlayerToyInfo[giveplayerid][v][ptModelID] == 0)
							{
								PlayerToyInfo[giveplayerid][v][ptModelID] = 18643;
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
									PlayerToyInfo[giveplayerid][i][ptModelID] = 18643;
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
									
									SendClientMessageEx(giveplayerid, COLOR_GRAD1, "Due to you not having any available slots, we've temporarily gave you an additional slot to use/sell/trade your laser.");
									SendClientMessageEx(giveplayerid, COLOR_RED, "Note: Please take note that after selling the laser, the temporarily additional toy slot will be removed.");
									break;
								}	
							}
						}
					
						format(string, sizeof(string), "Congratulations, you have won a Laser!");
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted a Laser, enjoy!", GetPlayerNameEx(giveplayerid));
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgLaser][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted a Laser, enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid));
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 27)
					{
						if(dgVar[dgCustomToy][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgCustomToy][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgCustomToy][3] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						
						/*new icount = GetPlayerToySlots(giveplayerid), success = 0;
						for(new v = 0; v < icount; v++)
						{
							if(PlayerToyInfo[giveplayerid][v][ptModelID] == 0)
							{
								PlayerToyInfo[giveplayerid][v][ptModelID] = dgVar[dgCustomToy][2];
								PlayerToyInfo[giveplayerid][v][ptBone] = 1;
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
									PlayerToyInfo[giveplayerid][i][ptModelID] = dgVar[dgCustomToy][2];
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
									
									SendClientMessageEx(giveplayerid, COLOR_GRAD1, "Due to you not having any available slots, we've temporarily gave you an additional slot to use/sell/trade your custom toy.");
									SendClientMessageEx(giveplayerid, COLOR_RED, "Note: Please take note that after selling the custom toy, the temporarily additional toy slot will be removed.");
									break;
								}	
							}
						}*/

						AddFlag(giveplayerid, INVALID_PLAYER_ID, "[GIFTBOX] 1x Custom Toy");
					
						format(string, sizeof(string), "Congratulations, you have won a Custom Toy!");
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted a Custom Toy, enjoy!", GetPlayerNameEx(giveplayerid));
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgCustomToy][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted a Custom Toy, enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid));
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 28)
					{
						if(dgVar[dgAdmuteReset][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgAdmuteReset][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgAdmuteReset][3] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(PlayerInfo[giveplayerid][pADMuteTotal] == 0) return GiftPlayer(playerid, giveplayerid, 1);									
					
						PlayerInfo[giveplayerid][pADMuteTotal] -= dgVar[dgAdmuteReset][2];
						
						format(string, sizeof(string), "Congratulations, you have won %d Admute Reset(s)!", dgVar[dgAdmuteReset][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Admute Reset(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgAdmuteReset][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgAdmuteReset][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Admute Reset(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgAdmuteReset][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 29)
					{
						if(dgVar[dgNewbieMuteReset][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgNewbieMuteReset][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgNewbieMuteReset][3] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(PlayerInfo[giveplayerid][pNMuteTotal] == 0) return GiftPlayer(playerid, giveplayerid, 1);									
					
						PlayerInfo[giveplayerid][pNMuteTotal] -= dgVar[dgNewbieMuteReset][2];
						
						format(string, sizeof(string), "Congratulations, you have won %d Newbie Mute Reset(s)!", dgVar[dgNewbieMuteReset][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Newbie Mute Reset(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgNewbieMuteReset][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgNewbieMuteReset][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Newbie Mute Reset(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgNewbieMuteReset][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 30)
					{
						if(dgVar[dgRestrictedCarVoucher][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgRestrictedCarVoucher][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgRestrictedCarVoucher][3] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pCarVoucher] += dgVar[dgRestrictedCarVoucher][2];
						format(string, sizeof(string), "Congratulations, you have won a %d Restricted Car Voucher(s)!", dgVar[dgRestrictedCarVoucher][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Restricted Car Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgRestrictedCarVoucher][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgRestrictedCarVoucher][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Restricted Car Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgRestrictedCarVoucher][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 31)
					{
						if(dgVar[dgPlatinumVIPVoucher][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgPlatinumVIPVoucher][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgPlatinumVIPVoucher][3] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pPVIPVoucher] += dgVar[dgPlatinumVIPVoucher][2];
						format(string, sizeof(string), "Congratulations, you have won a %d 1 month PVIP Voucher(s)!", dgVar[dgPlatinumVIPVoucher][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d 1 month PVIP Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgPlatinumVIPVoucher][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgPlatinumVIPVoucher][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d 1 month PVIP Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgPlatinumVIPVoucher][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					else return SendClientMessageEx(giveplayerid, COLOR_RED, "Seems like the dynamic giftbox is empty, please try again.");
				}
				case 51..80: // cat 2 - Slightly more rare gifts
				{
					new randy = random(32);
					printf("cat 1 %d", randy);

					if(randy == 0)
					{
						if(dgVar[dgMoney][3] == 1) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgMoney][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgMoney][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						
						GivePlayerCash(giveplayerid, dgVar[dgMoney][2]);
						format(string, sizeof(string), "Congratulations, you have won $%s!", number_format(dgVar[dgMoney][2]));
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted $%s, enjoy!", GetPlayerNameEx(giveplayerid), number_format(dgVar[dgMoney][2]));
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgMoney][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted $%s, enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), number_format(dgVar[dgMoney][2]));
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 1)
					{
						if(dgVar[dgRimKit][3] == 1) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgRimKit][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgRimKit][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pRimMod] += dgVar[dgRimKit][2];
						format(string, sizeof(string), "Congratulations, you have won %d rimkit(s)!", dgVar[dgRimKit][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d rimkit(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgRimKit][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgRimKit][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d rimkit(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgRimKit][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 2)
					{
						if(dgVar[dgFirework][3] == 1) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgFirework][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgFirework][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pFirework] += dgVar[dgFirework][2];
						format(string, sizeof(string), "Congratulations, you have won %d firework(s)!", dgVar[dgFirework][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d firework(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgFirework][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgFirework][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d firework(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgFirework][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 3)
					{
						if(dgVar[dgGVIP][3] == 1) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgGVIP][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgGVIP][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pGVIPExVoucher] += dgVar[dgGVIP][2];
						format(string, sizeof(string), "Congratulations, you have won %d Seven day Gold VIP Voucher(s)!", dgVar[dgGVIP][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Seven day Gold VIP Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgGVIP][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgGVIP][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Seven day Gold VIP Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgGVIP][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 4)
					{
						if(dgVar[dgGVIPEx][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgGVIPEx][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgGVIPEx][3] == 1) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pGVIPVoucher] += dgVar[dgGVIPEx][2];
						format(string, sizeof(string), "Congratulations, you have won %d One Month Gold VIP Voucher(s)!", dgVar[dgGVIPEx][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d One Month Gold VIP Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgGVIPEx][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgGVIPEx][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d One Month Gold VIP Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgGVIPEx][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 5)
					{
						if(dgVar[dgSVIP][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgSVIP][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgSVIP][3] == 1) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pSVIPExVoucher] += dgVar[dgSVIP][2];
						format(string, sizeof(string), "Congratulations, you have won %d Seven day Silver VIP Voucher (s)!", dgVar[dgSVIP][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Seven day Silver VIP Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgSVIP][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgSVIP][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Seven day Silver VIP Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgSVIP][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 6)
					{
						if(dgVar[dgSVIPEx][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgSVIPEx][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgSVIPEx][3] == 1) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pSVIPVoucher] += dgVar[dgSVIPEx][2];
						format(string, sizeof(string), "Congratulations, you have won %d One Month Silver VIP Voucher(s)!", dgVar[dgSVIPEx][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d One Month Silver VIP Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgSVIPEx][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgSVIPEx][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d One Month Silver VIP Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgSVIPEx][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 7)
					{
						if(dgVar[dgCarSlot][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgCarSlot][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgCarSlot][3] == 1) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pVehicleSlot] += dgVar[dgCarSlot][2];
						format(string, sizeof(string), "Congratulations, you have won %d Car Slot(s)!", dgVar[dgCarSlot][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Car Slot(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgCarSlot][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgCarSlot][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Car Slot(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgCarSlot][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 8)
					{
						if(dgVar[dgToySlot][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgCarSlot][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgCarSlot][3] == 1) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pToySlot] += dgVar[dgToySlot][2];
						format(string, sizeof(string), "Congratulations, you have won %d Toy Slot(s)!", dgVar[dgToySlot][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Toy Slot(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgToySlot][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgToySlot][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Toy Slot(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgToySlot][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 9)
					{
						if(dgVar[dgArmor][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgArmor][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgArmor][3] == 1) return GiftPlayer(playerid, giveplayerid, 1);
						
						new Float: armor;
						GetArmour(giveplayerid, armor);
						
						if(armor+dgVar[dgArmor][2] >= 100) return GiftPlayer(playerid, giveplayerid, 1);
						
						SetArmour(giveplayerid, armor + dgVar[dgArmor][2]);
						format(string, sizeof(string), "Congratulations, you have won %d Armour!", dgVar[dgArmor][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Armour, enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgArmor][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgArmor][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Armour, enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgArmor][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 10)
					{
						if(dgVar[dgFirstaid][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgFirstaid][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgFirstaid][3] == 1) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pFirstaid] += dgVar[dgFirstaid][2];
						format(string, sizeof(string), "Congratulations, you have won %d Firstaid(s)!", dgVar[dgFirstaid][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Firstaid(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgFirstaid][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgFirstaid][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Firstaid(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgFirstaid][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 11)
					{
						if(dgVar[dgDDFlag][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgDDFlag][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgDDFlag][3] == 1) return GiftPlayer(playerid, giveplayerid, 1);
						
						AddFlag(giveplayerid, INVALID_PLAYER_ID, "Dynamic Gift Box: 1 Dynamic Door");
						
						format(string, sizeof(string), "Congratulations, you have won %d Dynamic Door Flag(s)!", dgVar[dgDDFlag][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Note: This prize may take up to 48 hours to be rewarded..");
						format(string, sizeof(string), "* %s was just gifted %d Dynamic Door Flag(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgDDFlag][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgDDFlag][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Dynamic Door Flag(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgDDFlag][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 12)
					{
						if(dgVar[dgGateFlag][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgGateFlag][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgGateFlag][3] == 1) return GiftPlayer(playerid, giveplayerid, 1);
						
						AddFlag(giveplayerid, INVALID_PLAYER_ID, "Dynamic Gift Box: 1 Dynamic Gate");
						
						format(string, sizeof(string), "Congratulations, you have won %d Dynamic Door Flag(s)!", dgVar[dgGateFlag][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Note: This prize may take up to 48 hours to be rewarded..");
						format(string, sizeof(string), "* %s was just gifted %d Dynamic Gate Flag(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgGateFlag][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgGateFlag][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Dynamic Gate Flag(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgGateFlag][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 13)
					{
						if(dgVar[dgCredits][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgCredits][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgCredits][3] == 1) return GiftPlayer(playerid, giveplayerid, 1);
						
						GivePlayerCredits(giveplayerid, dgVar[dgCredits][2], 1);
						format(string, sizeof(string), "Congratulations, you have won %d Credit(s)!", dgVar[dgCredits][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Credit(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgCredits][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgCredits][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Credit(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgCredits][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 14)
					{
						if(dgVar[dgPriorityAd][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgPriorityAd][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgPriorityAd][3] == 1) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pAdvertVoucher] += dgVar[dgPriorityAd][2];
						format(string, sizeof(string), "Congratulations, you have won %d Priority Advertisement Voucher(s)!", dgVar[dgPriorityAd][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Priority Advertisement Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgPriorityAd][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgPriorityAd][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Priority Advertisement Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgPriorityAd][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 15)
					{
						if(dgVar[dgHealthNArmor][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgHealthNArmor][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgHealthNArmor][3] == 1) return GiftPlayer(playerid, giveplayerid, 1);
						
						SetHealth(giveplayerid, 100.0);
						SetArmour(giveplayerid, 100);
						format(string, sizeof(string), "Congratulations, you have won Full Health & Armor!");
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Full Health & Armor, enjoy!", GetPlayerNameEx(giveplayerid));
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgHealthNArmor][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Full Health & Armor, enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid));
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 16)
					{
						if(dgVar[dgGiftReset][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgGiftReset][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgGiftReset][3] == 1) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pGiftVoucher] += dgVar[dgGiftReset][2];
						format(string, sizeof(string), "Congratulations, you have won a %d Gift Reset Voucher(s)!", dgVar[dgGiftReset][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Gift Reset Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgGiftReset][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgGiftReset][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Gift Reset Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgGiftReset][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 17)
					{
						if(dgVar[dgMaterial][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgMaterial][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgMaterial][3] == 1) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pMats] += dgVar[dgMaterial][2];
						format(string, sizeof(string), "Congratulations, you have won a %d Material(s)!", dgVar[dgMaterial][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Material(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgMaterial][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgMaterial][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Material(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgMaterial][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 18)
					{
						if(dgVar[dgWarning][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgWarning][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgWarning][3] == 1) return GiftPlayer(playerid, giveplayerid, 1);
						
						if(dgVar[dgWarning][2] > 3 || dgVar[dgWarning][2] < 0)
						{						
							if(PlayerInfo[giveplayerid][pWarns] == 0) return GiftPlayer(playerid, giveplayerid, 1);
							
							PlayerInfo[giveplayerid][pWarns] -= dgVar[dgWarning][2];
						}
						else
							return GiftPlayer(playerid, giveplayerid, 1);
							
						format(string, sizeof(string), "Congratulations, you have won a %d Warning(s) Removal!", dgVar[dgWarning][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Warning(s) Removal, enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgWarning][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgWarning][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Warning(s) Removal, enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgWarning][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 19)
					{
						if(dgVar[dgPot][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgPot][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgPot][3] == 1) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pDrugs][0] += dgVar[dgPot][2];
						format(string, sizeof(string), "Congratulations, you have won %d pot!", dgVar[dgPot][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d pot, enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgPot][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgPot][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d pot, enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgPot][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 20)
					{
						if(dgVar[dgCrack][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgCrack][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgCrack][3] == 1) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pDrugs][1] += dgVar[dgCrack][2];
						format(string, sizeof(string), "Congratulations, you have won %d Crack!", dgVar[dgCrack][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Crack, enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgCrack][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgCrack][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Crack, enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgCrack][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 21)
					{
						if(dgVar[dgPaintballToken][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgPaintballToken][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgPaintballToken][3] == 1) return GiftPlayer(playerid, giveplayerid, 1);
						if(PlayerInfo[giveplayerid][pDonateRank] >= 4) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pPaintTokens] += dgVar[dgPaintballToken][2];
						format(string, sizeof(string), "Congratulations, you have won a %d Paintball Token(s)!", dgVar[dgPaintballToken][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Paintball Token(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgPaintballToken][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgPaintballToken][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Paintball Token(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgPaintballToken][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 22)
					{
						if(dgVar[dgVIPToken][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgVIPToken][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgVIPToken][3] == 1) return GiftPlayer(playerid, giveplayerid, 1);
						if(PlayerInfo[giveplayerid][pDonateRank] >= 4) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pTokens] += dgVar[dgVIPToken][2];
						format(string, sizeof(string), "Congratulations, you have won a %d VIP Token(s)!", dgVar[dgVIPToken][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d VIP Token(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgVIPToken][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgVIPToken][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d VIP Token(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgVIPToken][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 23)
					{
						if(dgVar[dgRespectPoint][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgRespectPoint][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgRespectPoint][3] == 1) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pExp] += dgVar[dgRespectPoint][2];
						format(string, sizeof(string), "Congratulations, you have won a %d Respect Point(s)!", dgVar[dgRespectPoint][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Respect Point(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgRespectPoint][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgRespectPoint][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Respect Point(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgRespectPoint][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 24)
					{
						if(dgVar[dgCarVoucher][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgCarVoucher][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgCarVoucher][3] == 1) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pVehVoucher] += dgVar[dgCarVoucher][2];
						format(string, sizeof(string), "Congratulations, you have won a %d Car Voucher(s)!", dgVar[dgCarVoucher][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Car Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgCarVoucher][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgCarVoucher][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Car Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgCarVoucher][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 25)
					{
						if(dgVar[dgBuddyInvite][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgBuddyInvite][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgBuddyInvite][3] == 1) return GiftPlayer(playerid, giveplayerid, 1);
						if(PlayerInfo[giveplayerid][pDonateRank] != 0) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pDonateRank] = 1;
						PlayerInfo[giveplayerid][pTempVIP] = 180;
						PlayerInfo[giveplayerid][pBuddyInvited] = 1;
						format(string, sizeof(string), "BUDDY INVITE: %s(%d) has been invited to VIP by System", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid));
						Log("logs/setvip.log", string);
					
						format(string, sizeof(string), "Congratulations, you have won a Buddy Invite!");
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted a BuddyInvite, enjoy!", GetPlayerNameEx(giveplayerid));
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgBuddyInvite][1]--;
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 26)
					{
						if(dgVar[dgLaser][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgLaser][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgLaser][3] == 1) return GiftPlayer(playerid, giveplayerid, 1);
						
						new icount = GetPlayerToySlots(giveplayerid), success = 0;
						for(new v = 0; v < icount; v++)
						{
							if(PlayerToyInfo[giveplayerid][v][ptModelID] == 0)
							{
								PlayerToyInfo[giveplayerid][v][ptModelID] = 18643;
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
									PlayerToyInfo[giveplayerid][i][ptModelID] = 18643;
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
									
									SendClientMessageEx(giveplayerid, COLOR_GRAD1, "Due to you not having any available slots, we've temporarily gave you an additional slot to use/sell/trade your laser.");
									SendClientMessageEx(giveplayerid, COLOR_RED, "Note: Please take note that after selling the laser, the temporarily additional toy slot will be removed.");
									break;
								}	
							}
						}
					
						format(string, sizeof(string), "Congratulations, you have won a Laser!");
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted a Laser, enjoy!", GetPlayerNameEx(giveplayerid));
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgLaser][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted a Laser, enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid));
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 27)
					{
						if(dgVar[dgCustomToy][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgCustomToy][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgCustomToy][3] == 1) return GiftPlayer(playerid, giveplayerid, 1);
						
						new icount = GetPlayerToySlots(giveplayerid), success = 0;
						for(new v = 0; v < icount; v++)
						{
							if(PlayerToyInfo[giveplayerid][v][ptModelID] == 0)
							{
								PlayerToyInfo[giveplayerid][v][ptModelID] = dgVar[dgCustomToy][2];
								PlayerToyInfo[giveplayerid][v][ptBone] = 1;
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
									PlayerToyInfo[giveplayerid][i][ptModelID] = dgVar[dgCustomToy][2];
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
									
									SendClientMessageEx(giveplayerid, COLOR_GRAD1, "Due to you not having any available slots, we've temporarily gave you an additional slot to use/sell/trade your custom toy.");
									SendClientMessageEx(giveplayerid, COLOR_RED, "Note: Please take note that after selling the custom toy, the temporarily additional toy slot will be removed.");
									break;
								}	
							}
						}
					
						format(string, sizeof(string), "Congratulations, you have won a Custom Toy!");
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted a Custom Toy, enjoy!", GetPlayerNameEx(giveplayerid));
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgCustomToy][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted a Custom Toy, enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid));
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 28)
					{
						if(dgVar[dgAdmuteReset][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgAdmuteReset][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgAdmuteReset][3] == 1) return GiftPlayer(playerid, giveplayerid, 1);
						if(PlayerInfo[giveplayerid][pADMuteTotal] == 0) return GiftPlayer(playerid, giveplayerid, 1);									
					
						PlayerInfo[giveplayerid][pADMuteTotal] -= dgVar[dgAdmuteReset][2];
						
						format(string, sizeof(string), "Congratulations, you have won %d Admute Reset(s)!", dgVar[dgAdmuteReset][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Admute Reset(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgAdmuteReset][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgAdmuteReset][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Admute Reset(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgAdmuteReset][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 29)
					{
						if(dgVar[dgNewbieMuteReset][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgNewbieMuteReset][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgNewbieMuteReset][3] == 1) return GiftPlayer(playerid, giveplayerid, 1);
						if(PlayerInfo[giveplayerid][pNMuteTotal] == 0) return GiftPlayer(playerid, giveplayerid, 1);									
					
						PlayerInfo[giveplayerid][pNMuteTotal] -= dgVar[dgNewbieMuteReset][2];
						
						format(string, sizeof(string), "Congratulations, you have won %d Newbie Mute Reset(s)!", dgVar[dgNewbieMuteReset][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Newbie Mute Reset(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgNewbieMuteReset][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgNewbieMuteReset][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Newbie Mute Reset(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgNewbieMuteReset][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 30)
					{
						if(dgVar[dgRestrictedCarVoucher][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgRestrictedCarVoucher][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgRestrictedCarVoucher][3] == 1) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pCarVoucher] += dgVar[dgRestrictedCarVoucher][2];
						format(string, sizeof(string), "Congratulations, you have won a %d Restricted Car Voucher(s)!", dgVar[dgRestrictedCarVoucher][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Restricted Car Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgRestrictedCarVoucher][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgRestrictedCarVoucher][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Restricted Car Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgRestrictedCarVoucher][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 31)
					{
						if(dgVar[dgPlatinumVIPVoucher][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgPlatinumVIPVoucher][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgPlatinumVIPVoucher][3] == 1) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pPVIPVoucher] += dgVar[dgPlatinumVIPVoucher][2];
						format(string, sizeof(string), "Congratulations, you have won a %d 1 month PVIP Voucher(s)!", dgVar[dgPlatinumVIPVoucher][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d 1 month PVIP Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgPlatinumVIPVoucher][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgPlatinumVIPVoucher][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d 1 month PVIP Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgPlatinumVIPVoucher][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					else return SendClientMessageEx(giveplayerid, COLOR_RED, "Seems like the dynamic giftbox is empty, please try again.");
				}
				case 81..95: // cat 3 rarish
				{
					new randy = random(32);
					printf("cat 1 %d", randy);

					if(randy == 0)
					{
						if(dgVar[dgMoney][3] == 2) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgMoney][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgMoney][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						
						GivePlayerCash(giveplayerid, dgVar[dgMoney][2]);
						format(string, sizeof(string), "Congratulations, you have won $%s!", number_format(dgVar[dgMoney][2]));
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted $%s, enjoy!", GetPlayerNameEx(giveplayerid), number_format(dgVar[dgMoney][2]));
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgMoney][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted $%s, enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), number_format(dgVar[dgMoney][2]));
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 1)
					{
						if(dgVar[dgRimKit][3] == 2) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgRimKit][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgRimKit][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pRimMod] += dgVar[dgRimKit][2];
						format(string, sizeof(string), "Congratulations, you have won %d rimkit(s)!", dgVar[dgRimKit][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d rimkit(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgRimKit][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgRimKit][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d rimkit(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgRimKit][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 2)
					{
						if(dgVar[dgFirework][3] == 2) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgFirework][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgFirework][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pFirework] += dgVar[dgFirework][2];
						format(string, sizeof(string), "Congratulations, you have won %d firework(s)!", dgVar[dgFirework][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d firework(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgFirework][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgFirework][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d firework(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgFirework][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 3)
					{
						if(dgVar[dgGVIP][3] == 2) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgGVIP][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgGVIP][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pGVIPExVoucher] += dgVar[dgGVIP][2];
						format(string, sizeof(string), "Congratulations, you have won %d Seven day Gold VIP Voucher(s)!", dgVar[dgGVIP][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Seven day Gold VIP Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgGVIP][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgGVIP][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Seven day Gold VIP Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgGVIP][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 4)
					{
						if(dgVar[dgGVIPEx][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgGVIPEx][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgGVIPEx][3] == 2) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pGVIPVoucher] += dgVar[dgGVIPEx][2];
						format(string, sizeof(string), "Congratulations, you have won %d One Month Gold VIP Voucher(s)!", dgVar[dgGVIPEx][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d One Month Gold VIP Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgGVIPEx][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgGVIPEx][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d One Month Gold VIP Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgGVIPEx][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 5)
					{
						if(dgVar[dgSVIP][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgSVIP][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgSVIP][3] == 2) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pSVIPExVoucher] += dgVar[dgSVIP][2];
						format(string, sizeof(string), "Congratulations, you have won %d Seven day Silver VIP Voucher (s)!", dgVar[dgSVIP][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Seven day Silver VIP Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgSVIP][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgSVIP][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Seven day Silver VIP Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgSVIP][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 6)
					{
						if(dgVar[dgSVIPEx][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgSVIPEx][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgSVIPEx][3] == 2) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pSVIPVoucher] += dgVar[dgSVIPEx][2];
						format(string, sizeof(string), "Congratulations, you have won %d One Month Silver VIP Voucher(s)!", dgVar[dgSVIPEx][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d One Month Silver VIP Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgSVIPEx][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgSVIPEx][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d One Month Silver VIP Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgSVIPEx][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 7)
					{
						if(dgVar[dgCarSlot][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgCarSlot][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgCarSlot][3] == 2) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pVehicleSlot] += dgVar[dgCarSlot][2];
						format(string, sizeof(string), "Congratulations, you have won %d Car Slot(s)!", dgVar[dgCarSlot][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Car Slot(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgCarSlot][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgCarSlot][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Car Slot(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgCarSlot][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 8)
					{
						if(dgVar[dgToySlot][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgCarSlot][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgCarSlot][3] == 2) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pToySlot] += dgVar[dgToySlot][2];
						format(string, sizeof(string), "Congratulations, you have won %d Toy Slot(s)!", dgVar[dgToySlot][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Toy Slot(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgToySlot][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgToySlot][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Toy Slot(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgToySlot][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 9)
					{
						if(dgVar[dgArmor][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgArmor][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgArmor][3] == 2) return GiftPlayer(playerid, giveplayerid, 1);
						
						new Float: armor;
						GetArmour(giveplayerid, armor);
						
						if(armor+dgVar[dgArmor][2] >= 100) return GiftPlayer(playerid, giveplayerid, 1);
						
						SetArmour(giveplayerid, armor + dgVar[dgArmor][2]);
						format(string, sizeof(string), "Congratulations, you have won %d Armour!", dgVar[dgArmor][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Armour, enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgArmor][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgArmor][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Armour, enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgArmor][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 10)
					{
						if(dgVar[dgFirstaid][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgFirstaid][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgFirstaid][3] == 2) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pFirstaid] += dgVar[dgFirstaid][2];
						format(string, sizeof(string), "Congratulations, you have won %d Firstaid(s)!", dgVar[dgFirstaid][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Firstaid(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgFirstaid][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgFirstaid][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Firstaid(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgFirstaid][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 11)
					{
						if(dgVar[dgDDFlag][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgDDFlag][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgDDFlag][3] == 2) return GiftPlayer(playerid, giveplayerid, 1);
						
						AddFlag(giveplayerid, INVALID_PLAYER_ID, "Dynamic Gift Box: 1 Dynamic Door");
						
						format(string, sizeof(string), "Congratulations, you have won %d Dynamic Door Flag(s)!", dgVar[dgDDFlag][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Note: This prize may take up to 48 hours to be rewarded..");
						format(string, sizeof(string), "* %s was just gifted %d Dynamic Door Flag(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgDDFlag][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgDDFlag][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Dynamic Door Flag(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgDDFlag][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 12)
					{
						if(dgVar[dgGateFlag][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgGateFlag][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgGateFlag][3] == 2) return GiftPlayer(playerid, giveplayerid, 1);
						
						AddFlag(giveplayerid, INVALID_PLAYER_ID, "Dynamic Gift Box: 1 Dynamic Gate");
						
						format(string, sizeof(string), "Congratulations, you have won %d Dynamic Door Flag(s)!", dgVar[dgGateFlag][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Note: This prize may take up to 48 hours to be rewarded..");
						format(string, sizeof(string), "* %s was just gifted %d Dynamic Gate Flag(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgGateFlag][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgGateFlag][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Dynamic Gate Flag(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgGateFlag][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 13)
					{
						if(dgVar[dgCredits][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgCredits][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgCredits][3] == 2) return GiftPlayer(playerid, giveplayerid, 1);
						
						GivePlayerCredits(giveplayerid, dgVar[dgCredits][2], 1);
						format(string, sizeof(string), "Congratulations, you have won %d Credit(s)!", dgVar[dgCredits][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Credit(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgCredits][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgCredits][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Credit(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgCredits][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 14)
					{
						if(dgVar[dgPriorityAd][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgPriorityAd][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgPriorityAd][3] == 2) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pAdvertVoucher] += dgVar[dgPriorityAd][2];
						format(string, sizeof(string), "Congratulations, you have won %d Priority Advertisement Voucher(s)!", dgVar[dgPriorityAd][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Priority Advertisement Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgPriorityAd][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgPriorityAd][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Priority Advertisement Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgPriorityAd][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 15)
					{
						if(dgVar[dgHealthNArmor][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgHealthNArmor][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgHealthNArmor][3] == 2) return GiftPlayer(playerid, giveplayerid, 1);
						
						SetHealth(giveplayerid, 100.0);
						SetArmour(giveplayerid, 100);
						format(string, sizeof(string), "Congratulations, you have won Full Health & Armor!");
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Full Health & Armor, enjoy!", GetPlayerNameEx(giveplayerid));
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgHealthNArmor][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Full Health & Armor, enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid));
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 16)
					{
						if(dgVar[dgGiftReset][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgGiftReset][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgGiftReset][3] == 2) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pGiftVoucher] += dgVar[dgGiftReset][2];
						format(string, sizeof(string), "Congratulations, you have won a %d Gift Reset Voucher(s)!", dgVar[dgGiftReset][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Gift Reset Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgGiftReset][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgGiftReset][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Gift Reset Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgGiftReset][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 17)
					{
						if(dgVar[dgMaterial][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgMaterial][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgMaterial][3] == 2) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pMats] += dgVar[dgMaterial][2];
						format(string, sizeof(string), "Congratulations, you have won a %d Material(s)!", dgVar[dgMaterial][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Material(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgMaterial][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgMaterial][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Material(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgMaterial][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 18)
					{
						if(dgVar[dgWarning][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgWarning][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgWarning][3] == 2) return GiftPlayer(playerid, giveplayerid, 1);
						
						if(dgVar[dgWarning][2] > 3 || dgVar[dgWarning][2] < 0)
						{						
							if(PlayerInfo[giveplayerid][pWarns] == 0) return GiftPlayer(playerid, giveplayerid, 1);
							
							PlayerInfo[giveplayerid][pWarns] -= dgVar[dgWarning][2];
						}
						else
							return GiftPlayer(playerid, giveplayerid, 1);
							
						format(string, sizeof(string), "Congratulations, you have won a %d Warning(s) Removal!", dgVar[dgWarning][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Warning(s) Removal, enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgWarning][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgWarning][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Warning(s) Removal, enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgWarning][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 19)
					{
						if(dgVar[dgPot][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgPot][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgPot][3] == 2) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pDrugs][0] += dgVar[dgPot][2];
						format(string, sizeof(string), "Congratulations, you have won %d pot!", dgVar[dgPot][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d pot, enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgPot][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgPot][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d pot, enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgPot][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 20)
					{
						if(dgVar[dgCrack][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgCrack][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgCrack][3] == 2) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pDrugs][1] += dgVar[dgCrack][2];
						format(string, sizeof(string), "Congratulations, you have won %d Crack!", dgVar[dgCrack][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Crack, enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgCrack][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgCrack][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Crack, enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgCrack][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 21)
					{
						if(dgVar[dgPaintballToken][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgPaintballToken][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgPaintballToken][3] == 2) return GiftPlayer(playerid, giveplayerid, 1);
						if(PlayerInfo[giveplayerid][pDonateRank] >= 4) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pPaintTokens] += dgVar[dgPaintballToken][2];
						format(string, sizeof(string), "Congratulations, you have won a %d Paintball Token(s)!", dgVar[dgPaintballToken][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Paintball Token(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgPaintballToken][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgPaintballToken][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Paintball Token(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgPaintballToken][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 22)
					{
						if(dgVar[dgVIPToken][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgVIPToken][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgVIPToken][3] == 2) return GiftPlayer(playerid, giveplayerid, 1);
						if(PlayerInfo[giveplayerid][pDonateRank] >= 4) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pTokens] += dgVar[dgVIPToken][2];
						format(string, sizeof(string), "Congratulations, you have won a %d VIP Token(s)!", dgVar[dgVIPToken][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d VIP Token(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgVIPToken][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgVIPToken][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d VIP Token(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgVIPToken][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 23)
					{
						if(dgVar[dgRespectPoint][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgRespectPoint][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgRespectPoint][3] == 2) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pExp] += dgVar[dgRespectPoint][2];
						format(string, sizeof(string), "Congratulations, you have won a %d Respect Point(s)!", dgVar[dgRespectPoint][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Respect Point(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgRespectPoint][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgRespectPoint][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Respect Point(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgRespectPoint][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 24)
					{
						if(dgVar[dgCarVoucher][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgCarVoucher][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgCarVoucher][3] == 2) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pVehVoucher] += dgVar[dgCarVoucher][2];
						format(string, sizeof(string), "Congratulations, you have won a %d Car Voucher(s)!", dgVar[dgCarVoucher][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Car Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgCarVoucher][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgCarVoucher][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Car Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgCarVoucher][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 25)
					{
						if(dgVar[dgBuddyInvite][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgBuddyInvite][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgBuddyInvite][3] == 2) return GiftPlayer(playerid, giveplayerid, 1);
						if(PlayerInfo[giveplayerid][pDonateRank] != 0) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pDonateRank] = 1;
						PlayerInfo[giveplayerid][pTempVIP] = 180;
						PlayerInfo[giveplayerid][pBuddyInvited] = 1;
						format(string, sizeof(string), "BUDDY INVITE: %s(%d) has been invited to VIP by System", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid));
						Log("logs/setvip.log", string);					
						format(string, sizeof(string), "Congratulations, you have won a Buddy Invite!");
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted a BuddyInvite, enjoy!", GetPlayerNameEx(giveplayerid));
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgBuddyInvite][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted a BuddyInvite, enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid));
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 26)
					{
						if(dgVar[dgLaser][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgLaser][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgLaser][3] == 2) return GiftPlayer(playerid, giveplayerid, 1);
						
						new icount = GetPlayerToySlots(giveplayerid), success = 0;
						for(new v = 0; v < icount; v++)
						{
							if(PlayerToyInfo[giveplayerid][v][ptModelID] == 0)
							{
								PlayerToyInfo[giveplayerid][v][ptModelID] = 18643;
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
									PlayerToyInfo[giveplayerid][i][ptModelID] = 18643;
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
									
									SendClientMessageEx(giveplayerid, COLOR_GRAD1, "Due to you not having any available slots, we've temporarily gave you an additional slot to use/sell/trade your laser.");
									SendClientMessageEx(giveplayerid, COLOR_RED, "Note: Please take note that after selling the laser, the temporarily additional toy slot will be removed.");
									break;
								}	
							}
						}
					
						format(string, sizeof(string), "Congratulations, you have won a Laser!");
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted a Laser, enjoy!", GetPlayerNameEx(giveplayerid));
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgLaser][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted a Laser, enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid));
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 27)
					{
						if(dgVar[dgCustomToy][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgCustomToy][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgCustomToy][3] == 2) return GiftPlayer(playerid, giveplayerid, 1);
						
						new icount = GetPlayerToySlots(giveplayerid), success = 0;
						for(new v = 0; v < icount; v++)
						{
							if(PlayerToyInfo[giveplayerid][v][ptModelID] == 0)
							{
								PlayerToyInfo[giveplayerid][v][ptModelID] = dgVar[dgCustomToy][2];
								PlayerToyInfo[giveplayerid][v][ptBone] = 1;
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
									PlayerToyInfo[giveplayerid][i][ptModelID] = dgVar[dgCustomToy][2];
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
									
									SendClientMessageEx(giveplayerid, COLOR_GRAD1, "Due to you not having any available slots, we've temporarily gave you an additional slot to use/sell/trade your custom toy.");
									SendClientMessageEx(giveplayerid, COLOR_RED, "Note: Please take note that after selling the custom toy, the temporarily additional toy slot will be removed.");
									break;
								}	
							}
						}
					
						format(string, sizeof(string), "Congratulations, you have won a Custom Toy!");
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted a Custom Toy, enjoy!", GetPlayerNameEx(giveplayerid));
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgCustomToy][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted a Custom Toy, enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid));
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 28)
					{
						if(dgVar[dgAdmuteReset][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgAdmuteReset][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgAdmuteReset][3] == 2) return GiftPlayer(playerid, giveplayerid, 1);
						if(PlayerInfo[giveplayerid][pADMuteTotal] == 0) return GiftPlayer(playerid, giveplayerid, 1);									
					
						PlayerInfo[giveplayerid][pADMuteTotal] -= dgVar[dgAdmuteReset][2];
						
						format(string, sizeof(string), "Congratulations, you have won %d Admute Reset(s)!", dgVar[dgAdmuteReset][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Admute Reset(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgAdmuteReset][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgAdmuteReset][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Admute Reset(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgAdmuteReset][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 29)
					{
						if(dgVar[dgNewbieMuteReset][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgNewbieMuteReset][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgNewbieMuteReset][3] == 2) return GiftPlayer(playerid, giveplayerid, 1);
						if(PlayerInfo[giveplayerid][pNMuteTotal] == 0) return GiftPlayer(playerid, giveplayerid, 1);									
					
						PlayerInfo[giveplayerid][pNMuteTotal] -= dgVar[dgNewbieMuteReset][2];
						
						format(string, sizeof(string), "Congratulations, you have won %d Newbie Mute Reset(s)!", dgVar[dgNewbieMuteReset][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Newbie Mute Reset(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgNewbieMuteReset][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgNewbieMuteReset][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Newbie Mute Reset(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgNewbieMuteReset][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 30)
					{
						if(dgVar[dgRestrictedCarVoucher][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgRestrictedCarVoucher][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgRestrictedCarVoucher][3] == 2) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pCarVoucher] += dgVar[dgRestrictedCarVoucher][2];
						format(string, sizeof(string), "Congratulations, you have won a %d Restricted Car Voucher(s)!", dgVar[dgRestrictedCarVoucher][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Restricted Car Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgRestrictedCarVoucher][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgRestrictedCarVoucher][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Restricted Car Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgRestrictedCarVoucher][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 31)
					{
						if(dgVar[dgPlatinumVIPVoucher][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgPlatinumVIPVoucher][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgPlatinumVIPVoucher][3] == 2) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pPVIPVoucher] += dgVar[dgPlatinumVIPVoucher][2];
						format(string, sizeof(string), "Congratulations, you have won a %d 1 month PVIP Voucher(s)!", dgVar[dgPlatinumVIPVoucher][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d 1 month PVIP Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgPlatinumVIPVoucher][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgPlatinumVIPVoucher][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d 1 month PVIP Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgPlatinumVIPVoucher][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					else return SendClientMessageEx(giveplayerid, COLOR_RED, "Seems like the dynamic giftbox is empty, please try again.");			
				}
				case 96..100: // cat 4 super rare
				{
					new randy = random(32);
					printf("cat 1 %d", randy);

					if(randy == 0)
					{
						if(dgVar[dgMoney][3] == 3) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgMoney][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgMoney][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						
						GivePlayerCash(giveplayerid, dgVar[dgMoney][2]);
						format(string, sizeof(string), "Congratulations, you have won $%s!", number_format(dgVar[dgMoney][2]));
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted $%s, enjoy!", GetPlayerNameEx(giveplayerid), number_format(dgVar[dgMoney][2]));
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgMoney][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted $%s, enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), number_format(dgVar[dgMoney][2]));
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 1)
					{
						if(dgVar[dgRimKit][3] == 3) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgRimKit][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgRimKit][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pRimMod] += dgVar[dgRimKit][2];
						format(string, sizeof(string), "Congratulations, you have won %d rimkit(s)!", dgVar[dgRimKit][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d rimkit(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgRimKit][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgRimKit][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d rimkit(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgRimKit][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 2)
					{
						if(dgVar[dgFirework][3] == 3) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgFirework][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgFirework][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pFirework] += dgVar[dgFirework][2];
						format(string, sizeof(string), "Congratulations, you have won %d firework(s)!", dgVar[dgFirework][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d firework(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgFirework][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgFirework][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d firework(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgFirework][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 3)
					{
						if(dgVar[dgGVIP][3] == 3) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgGVIP][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgGVIP][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pGVIPExVoucher] += dgVar[dgGVIP][2];
						format(string, sizeof(string), "Congratulations, you have won %d Seven day Gold VIP Voucher(s)!", dgVar[dgGVIP][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Seven day Gold VIP Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgGVIP][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgGVIP][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Seven day Gold VIP Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgGVIP][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 4)
					{
						if(dgVar[dgGVIPEx][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgGVIPEx][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgGVIPEx][3] == 3) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pGVIPVoucher] += dgVar[dgGVIPEx][2];
						format(string, sizeof(string), "Congratulations, you have won %d One Month Gold VIP Voucher(s)!", dgVar[dgGVIPEx][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d One Month Gold VIP Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgGVIPEx][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgGVIPEx][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d One Month Gold VIP Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgGVIPEx][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 5)
					{
						if(dgVar[dgSVIP][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgSVIP][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgSVIP][3] == 3) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pSVIPExVoucher] += dgVar[dgSVIP][2];
						format(string, sizeof(string), "Congratulations, you have won %d Seven day Silver VIP Voucher (s)!", dgVar[dgSVIP][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Seven day Silver VIP Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgSVIP][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgSVIP][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Seven day Silver VIP Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgSVIP][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 6)
					{
						if(dgVar[dgSVIPEx][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgSVIPEx][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgSVIPEx][3] == 3) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pSVIPVoucher] += dgVar[dgSVIPEx][2];
						format(string, sizeof(string), "Congratulations, you have won %d One Month Silver VIP Voucher(s)!", dgVar[dgSVIPEx][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d One Month Silver VIP Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgSVIPEx][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgSVIPEx][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d One Month Silver VIP Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgSVIPEx][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 7)
					{
						if(dgVar[dgCarSlot][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgCarSlot][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgCarSlot][3] == 3) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pVehicleSlot] += dgVar[dgCarSlot][2];
						format(string, sizeof(string), "Congratulations, you have won %d Car Slot(s)!", dgVar[dgCarSlot][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Car Slot(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgCarSlot][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgCarSlot][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Car Slot(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgCarSlot][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 8)
					{
						if(dgVar[dgToySlot][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgCarSlot][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgCarSlot][3] == 3) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pToySlot] += dgVar[dgToySlot][2];
						format(string, sizeof(string), "Congratulations, you have won %d Toy Slot(s)!", dgVar[dgToySlot][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Toy Slot(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgToySlot][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgToySlot][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Toy Slot(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgToySlot][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 9)
					{
						if(dgVar[dgArmor][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgArmor][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgArmor][3] == 3) return GiftPlayer(playerid, giveplayerid, 1);
						
						new Float: armor;
						GetArmour(giveplayerid, armor);
						
						if(armor+dgVar[dgArmor][2] >= 100) return GiftPlayer(playerid, giveplayerid, 1);
						
						SetArmour(giveplayerid, armor + dgVar[dgArmor][2]);
						format(string, sizeof(string), "Congratulations, you have won %d Armour!", dgVar[dgArmor][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Armour, enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgArmor][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgArmor][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Armour, enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgArmor][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 10)
					{
						if(dgVar[dgFirstaid][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgFirstaid][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgFirstaid][3] == 3) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pFirstaid] += dgVar[dgFirstaid][2];
						format(string, sizeof(string), "Congratulations, you have won %d Firstaid(s)!", dgVar[dgFirstaid][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Firstaid(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgFirstaid][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgFirstaid][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Firstaid(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgFirstaid][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 11)
					{
						if(dgVar[dgDDFlag][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgDDFlag][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgDDFlag][3] == 3) return GiftPlayer(playerid, giveplayerid, 1);
						
						AddFlag(giveplayerid, INVALID_PLAYER_ID, "Dynamic Gift Box: 1 Dynamic Door");
						
						format(string, sizeof(string), "Congratulations, you have won %d Dynamic Door Flag(s)!", dgVar[dgDDFlag][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Note: This prize may take up to 48 hours to be rewarded..");
						format(string, sizeof(string), "* %s was just gifted %d Dynamic Door Flag(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgDDFlag][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgDDFlag][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Dynamic Door Flag(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgDDFlag][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 12)
					{
						if(dgVar[dgGateFlag][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgGateFlag][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgGateFlag][3] == 3) return GiftPlayer(playerid, giveplayerid, 1);
						
						AddFlag(giveplayerid, INVALID_PLAYER_ID, "Dynamic Gift Box: 1 Dynamic Gate");
						
						format(string, sizeof(string), "Congratulations, you have won %d Dynamic Door Flag(s)!", dgVar[dgGateFlag][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Note: This prize may take up to 48 hours to be rewarded..");
						format(string, sizeof(string), "* %s was just gifted %d Dynamic Gate Flag(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgGateFlag][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgGateFlag][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Dynamic Gate Flag(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgGateFlag][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 13)
					{
						if(dgVar[dgCredits][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgCredits][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgCredits][3] == 3) return GiftPlayer(playerid, giveplayerid, 1);
						
						GivePlayerCredits(giveplayerid, dgVar[dgCredits][2], 1);
						format(string, sizeof(string), "Congratulations, you have won %d Credit(s)!", dgVar[dgCredits][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Credit(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgCredits][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgCredits][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Credit(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgCredits][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 14)
					{
						if(dgVar[dgPriorityAd][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgPriorityAd][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgPriorityAd][3] == 3) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pAdvertVoucher] += dgVar[dgPriorityAd][2];
						format(string, sizeof(string), "Congratulations, you have won %d Priority Advertisement Voucher(s)!", dgVar[dgPriorityAd][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Priority Advertisement Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgPriorityAd][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgPriorityAd][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Priority Advertisement Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgPriorityAd][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 15)
					{
						if(dgVar[dgHealthNArmor][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgHealthNArmor][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgHealthNArmor][3] == 3) return GiftPlayer(playerid, giveplayerid, 1);
						
						SetHealth(giveplayerid, 100.0);
						SetArmour(giveplayerid, 100);
						format(string, sizeof(string), "Congratulations, you have won Full Health & Armor!");
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Full Health & Armor, enjoy!", GetPlayerNameEx(giveplayerid));
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgHealthNArmor][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Full Health & Armor, enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid));
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 16)
					{
						if(dgVar[dgGiftReset][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgGiftReset][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgGiftReset][3] == 3) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pGiftVoucher] += dgVar[dgGiftReset][2];
						format(string, sizeof(string), "Congratulations, you have won a %d Gift Reset Voucher(s)!", dgVar[dgGiftReset][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Gift Reset Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgGiftReset][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgGiftReset][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Gift Reset Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgGiftReset][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 17)
					{
						if(dgVar[dgMaterial][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgMaterial][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgMaterial][3] == 3) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pMats] += dgVar[dgMaterial][2];
						format(string, sizeof(string), "Congratulations, you have won a %d Material(s)!", dgVar[dgMaterial][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Material(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgMaterial][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgMaterial][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Material(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgMaterial][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 18)
					{
						if(dgVar[dgWarning][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgWarning][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgWarning][3] == 3) return GiftPlayer(playerid, giveplayerid, 1);
						
						if(dgVar[dgWarning][2] > 3 || dgVar[dgWarning][2] < 0)
						{						
							if(PlayerInfo[giveplayerid][pWarns] == 0) return GiftPlayer(playerid, giveplayerid, 1);
							
							PlayerInfo[giveplayerid][pWarns] -= dgVar[dgWarning][2];
						}
						else
							return GiftPlayer(playerid, giveplayerid, 1);
							
						format(string, sizeof(string), "Congratulations, you have won a %d Warning(s) Removal!", dgVar[dgWarning][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Warning(s) Removal, enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgWarning][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgWarning][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Warning(s) Removal, enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgWarning][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 19)
					{
						if(dgVar[dgPot][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgPot][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgPot][3] == 3) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pDrugs][0] += dgVar[dgPot][2];
						format(string, sizeof(string), "Congratulations, you have won %d pot!", dgVar[dgPot][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d pot, enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgPot][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgPot][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d pot, enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgPot][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 20)
					{
						if(dgVar[dgCrack][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgCrack][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgCrack][3] == 3) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pDrugs][1] += dgVar[dgCrack][2];
						format(string, sizeof(string), "Congratulations, you have won %d Crack!", dgVar[dgCrack][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Crack, enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgCrack][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgCrack][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Crack, enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgCrack][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 21)
					{
						if(dgVar[dgPaintballToken][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgPaintballToken][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgPaintballToken][3] == 3) return GiftPlayer(playerid, giveplayerid, 1);
						if(PlayerInfo[giveplayerid][pDonateRank] >= 4) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pPaintTokens] += dgVar[dgPaintballToken][2];
						format(string, sizeof(string), "Congratulations, you have won a %d Paintball Token(s)!", dgVar[dgPaintballToken][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Paintball Token(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgPaintballToken][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgPaintballToken][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Paintball Token(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgPaintballToken][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 22)
					{
						if(dgVar[dgVIPToken][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgVIPToken][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgVIPToken][3] == 3) return GiftPlayer(playerid, giveplayerid, 1);
						if(PlayerInfo[giveplayerid][pDonateRank] >= 4) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pTokens] += dgVar[dgVIPToken][2];
						format(string, sizeof(string), "Congratulations, you have won a %d VIP Token(s)!", dgVar[dgVIPToken][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d VIP Token(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgVIPToken][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgVIPToken][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d VIP Token(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgVIPToken][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 23)
					{
						if(dgVar[dgRespectPoint][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgRespectPoint][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgRespectPoint][3] == 3) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pExp] += dgVar[dgRespectPoint][2];
						format(string, sizeof(string), "Congratulations, you have won a %d Respect Point(s)!", dgVar[dgRespectPoint][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Respect Point(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgRespectPoint][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgRespectPoint][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Respect Point(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgRespectPoint][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 24)
					{
						if(dgVar[dgCarVoucher][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgCarVoucher][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgCarVoucher][3] == 3) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pVehVoucher] += dgVar[dgCarVoucher][2];
						format(string, sizeof(string), "Congratulations, you have won a %d Car Voucher(s)!", dgVar[dgCarVoucher][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Car Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgCarVoucher][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgCarVoucher][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Car Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgCarVoucher][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 25)
					{
						if(dgVar[dgBuddyInvite][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgBuddyInvite][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgBuddyInvite][3] == 3) return GiftPlayer(playerid, giveplayerid, 1);
						if(PlayerInfo[giveplayerid][pDonateRank] != 0) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pDonateRank] = 1;
						PlayerInfo[giveplayerid][pTempVIP] = 180;
						PlayerInfo[giveplayerid][pBuddyInvited] = 1;
						format(string, sizeof(string), "BUDDY INVITE: %s(%d) has been invited to VIP by System", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid));
						Log("logs/setvip.log", string);
					
						format(string, sizeof(string), "Congratulations, you have won a Buddy Invite!");
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted a BuddyInvite, enjoy!", GetPlayerNameEx(giveplayerid));
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgBuddyInvite][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted a BuddyInvite, enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid));
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 26)
					{
						if(dgVar[dgLaser][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgLaser][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgLaser][3] == 3) return GiftPlayer(playerid, giveplayerid, 1);
						
						new icount = GetPlayerToySlots(giveplayerid), success = 0;
						for(new v = 0; v < icount; v++)
						{
							if(PlayerToyInfo[giveplayerid][v][ptModelID] == 0)
							{
								PlayerToyInfo[giveplayerid][v][ptModelID] = 18643;
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
									PlayerToyInfo[giveplayerid][i][ptModelID] = 18643;
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
									
									SendClientMessageEx(giveplayerid, COLOR_GRAD1, "Due to you not having any available slots, we've temporarily gave you an additional slot to use/sell/trade your laser.");
									SendClientMessageEx(giveplayerid, COLOR_RED, "Note: Please take note that after selling the laser, the temporarily additional toy slot will be removed.");
									break;
								}	
							}
						}
					
						format(string, sizeof(string), "Congratulations, you have won a Laser!");
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted a Laser, enjoy!", GetPlayerNameEx(giveplayerid));
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgLaser][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted a Laser, enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid));
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 27)
					{
						if(dgVar[dgCustomToy][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgCustomToy][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgCustomToy][3] == 3) return GiftPlayer(playerid, giveplayerid, 1);
						
						new icount = GetPlayerToySlots(giveplayerid), success = 0;
						for(new v = 0; v < icount; v++)
						{
							if(PlayerToyInfo[giveplayerid][v][ptModelID] == 0)
							{
								PlayerToyInfo[giveplayerid][v][ptModelID] = dgVar[dgCustomToy][2];
								PlayerToyInfo[giveplayerid][v][ptBone] = 1;
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
									PlayerToyInfo[giveplayerid][i][ptModelID] = dgVar[dgCustomToy][2];
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
									
									SendClientMessageEx(giveplayerid, COLOR_GRAD1, "Due to you not having any available slots, we've temporarily gave you an additional slot to use/sell/trade your custom toy.");
									SendClientMessageEx(giveplayerid, COLOR_RED, "Note: Please take note that after selling the custom toy, the temporarily additional toy slot will be removed.");
									break;
								}	
							}
						}
					
						format(string, sizeof(string), "Congratulations, you have won a Custom Toy!");
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted a Custom Toy, enjoy!", GetPlayerNameEx(giveplayerid));
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgCustomToy][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted a Custom Toy, enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid));
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 28)
					{
						if(dgVar[dgAdmuteReset][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgAdmuteReset][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgAdmuteReset][3] == 3) return GiftPlayer(playerid, giveplayerid, 1);
						if(PlayerInfo[giveplayerid][pADMuteTotal] == 0) return GiftPlayer(playerid, giveplayerid, 1);									
					
						PlayerInfo[giveplayerid][pADMuteTotal] -= dgVar[dgAdmuteReset][2];
						
						format(string, sizeof(string), "Congratulations, you have won %d Admute Reset(s)!", dgVar[dgAdmuteReset][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Admute Reset(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgAdmuteReset][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgAdmuteReset][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Admute Reset(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgAdmuteReset][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 29)
					{
						if(dgVar[dgNewbieMuteReset][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgNewbieMuteReset][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgNewbieMuteReset][3] == 3) return GiftPlayer(playerid, giveplayerid, 1);
						if(PlayerInfo[giveplayerid][pNMuteTotal] == 0) return GiftPlayer(playerid, giveplayerid, 1);									
					
						PlayerInfo[giveplayerid][pNMuteTotal] -= dgVar[dgNewbieMuteReset][2];
						
						format(string, sizeof(string), "Congratulations, you have won %d Newbie Mute Reset(s)!", dgVar[dgNewbieMuteReset][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Newbie Mute Reset(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgNewbieMuteReset][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgNewbieMuteReset][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Newbie Mute Reset(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgNewbieMuteReset][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 30)
					{
						if(dgVar[dgRestrictedCarVoucher][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgRestrictedCarVoucher][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgRestrictedCarVoucher][3] == 3) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pCarVoucher] += dgVar[dgRestrictedCarVoucher][2];
						format(string, sizeof(string), "Congratulations, you have won a %d Restricted Car Voucher(s)!", dgVar[dgRestrictedCarVoucher][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d Restricted Car Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgRestrictedCarVoucher][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgRestrictedCarVoucher][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d Restricted Car Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgRestrictedCarVoucher][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					
					if(randy == 31)
					{
						if(dgVar[dgPlatinumVIPVoucher][1] == value) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgPlatinumVIPVoucher][0] == 0) return GiftPlayer(playerid, giveplayerid, 1);
						if(dgVar[dgPlatinumVIPVoucher][3] == 3) return GiftPlayer(playerid, giveplayerid, 1);
						
						PlayerInfo[giveplayerid][pPVIPVoucher] += dgVar[dgPlatinumVIPVoucher][2];
						format(string, sizeof(string), "Congratulations, you have won a %d 1 month PVIP Voucher(s)!", dgVar[dgPlatinumVIPVoucher][2]);
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
						format(string, sizeof(string), "* %s was just gifted %d 1 month PVIP Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), dgVar[dgPlatinumVIPVoucher][2]);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
						dgVar[dgPlatinumVIPVoucher][1]--;
						format(string, sizeof(string), "* %s(%d) was just gifted %d 1 month PVIP Voucher(s), enjoy!", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), dgVar[dgPlatinumVIPVoucher][2]);
						SetPVarInt(giveplayerid, "GiftFail", 0), PlayerInfo[giveplayerid][pGiftTime] = 300, Log("logs/giftbox.log", string), SaveDynamicGiftBox(), OnPlayerStatsUpdate(giveplayerid);
						return true;
					}
					else return SendClientMessageEx(giveplayerid, COLOR_RED, "Seems like the dynamic giftbox is empty, please try again.");			
				}
			}	
		}
		SaveDynamicGiftBox();
	}
	if(gtype == 2)
	{
		if(playerid == MAX_PLAYERS || PlayerInfo[playerid][pAdmin] >= 2)
		{
			new randgift = Random(1, 103);
			if(randgift >= 1 && randgift <= 83)
			{
				new gift = Random(1, 12);
				if(gift == 1)
				{
					if(PlayerInfo[giveplayerid][pConnectHours] < 2 || PlayerInfo[giveplayerid][pWRestricted] > 0) return GiftPlayer(playerid, giveplayerid);
					return GiftPlayer(playerid, giveplayerid);
					/* GivePlayerValidWeapon(giveplayerid, 27, 100);
					GivePlayerValidWeapon(giveplayerid, 24, 100);
					GivePlayerValidWeapon(giveplayerid, 31, 100);
					GivePlayerValidWeapon(giveplayerid, 34, 100);
					GivePlayerValidWeapon(giveplayerid, 29, 100);
					SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Congratulations - you have won a full weapon set!");
					format(string, sizeof(string), "* %s was just gifted a full weapon set, enjoy!", GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW); */
				}
				else if(gift == 2)
				{
					if(PlayerInfo[giveplayerid][pDonateRank] > 2) return GiftPlayer(playerid, giveplayerid);
					PlayerInfo[giveplayerid][pFirstaid]++;
					SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Congratulations - you have won a first aid kit!");
					format(string, sizeof(string), "* %s was just gifted a first aid kit, enjoy!", GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
				}
				else if(gift == 3)
				{
					PlayerInfo[giveplayerid][pMats] += 2000;
					SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Congratulations - you have won 2,000 materials!");
					format(string, sizeof(string), "* %s was just gifted 2,000 materials, enjoy!", GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
				}
				else if(gift == 4)
				{
					if(PlayerInfo[giveplayerid][pWarns] != 0)
					{
						PlayerInfo[giveplayerid][pWarns]--;
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Congratulations - you have won a single warning removal!");
						format(string, sizeof(string), "* %s was just gifted a single warning removal, enjoy!", GetPlayerNameEx(giveplayerid));
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
					}
					else
					{
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, "Random gift ended up in a removal of one warning - let's try again!");
						GiftPlayer(playerid, giveplayerid);
						return 1;
					}
				}
				else if(gift == 5)
				{
					PlayerInfo[giveplayerid][pDrugs][0] += 50;
					SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Congratulations - you have won 50 grams of pot!");
					format(string, sizeof(string), "* %s was just gifted 50 grams of pot, enjoy!", GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
				}
				else if(gift == 6)
				{
					PlayerInfo[giveplayerid][pDrugs][1] += 25;
					SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Congratulations - you have won 25 grams of crack!");
					format(string, sizeof(string), "* %s was just gifted 25 grams of crack, enjoy!", GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
				}
				else if(gift == 7)
				{
					GivePlayerCash(giveplayerid, 20000);
					SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Congratulations - you have won $20,000!");
					format(string, sizeof(string), "* %s was just gifted $20,000, enjoy!", GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
				}
				else if(gift == 8)
				{
					if(PlayerInfo[giveplayerid][pDonateRank] >= 4) return GiftPlayer(playerid, giveplayerid);
					PlayerInfo[giveplayerid][pPaintTokens] += 10;
					SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Congratulations - you have won 10 paintball tokens!");
					format(string, sizeof(string), "* %s was just gifted 10 paintball tokens, enjoy!", GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
				}
				else if(gift == 9)
				{
					if(PlayerInfo[giveplayerid][pDonateRank] < 1) return GiftPlayer(playerid, giveplayerid);
					if(PlayerInfo[giveplayerid][pDonateRank] >= 4) return GiftPlayer(playerid, giveplayerid);
					PlayerInfo[giveplayerid][pTokens] += 5;
					SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Congratulations - you have won 5 VIP tokens!");
					format(string, sizeof(string), "* %s was just gifted 5 VIP tokens, enjoy!", GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
				}
				else if(gift == 10)
				{
					PlayerInfo[giveplayerid][pFirework] += 2;
					SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Congratulations - you have won 2 Fireworks!");
					format(string, sizeof(string), "* %s was just gifted 2 Fireworks, enjoy!", GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
				}
				else if(gift == 11)
				{
					PlayerInfo[giveplayerid][pExp] += 5;
					SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Congratulations - you have won 5 Respect Points!");
					format(string, sizeof(string), "* %s was just gifted 5 Respect Points, enjoy!", GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
				}
			}
			else if(randgift > 83 && randgift <= 98)
			{
				new gift = Random(1, 9);
				if(gift == 1)
				{
					GivePlayerCash(giveplayerid, 150000);
					SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Congratulations - you have won $150,000!");
					format(string, sizeof(string), "* %s was just gifted $150,000, enjoy!", GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
				}
				else if(gift == 2)
				{
					PlayerInfo[giveplayerid][pMats] += 15000;
					SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Congratulations - you have won 15,000 materials!");
					format(string, sizeof(string), "* %s was just gifted 15,000 materials, enjoy!", GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
				}
				else if(gift == 3)
				{
					PlayerInfo[giveplayerid][pExp] += 10;
					SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Congratulations - you have won 10 respect points!");
					format(string, sizeof(string), "* %s was just gifted 10 respect points, enjoy!", GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
				}
				else if(gift == 4)
				{
					PlayerInfo[giveplayerid][pVehVoucher]++;
					SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Congratulations - you have won a free car!");
					SendClientMessageEx(giveplayerid, COLOR_CYAN, " 1 Car Voucher has been added to your account.");
					SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Note you may access your voucher(s) with /myvouchers");
					
					format(string, sizeof(string), "AdmCmd: %s(%d) was just gifted by the system and he won a free car", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid));
					Log("logs/gifts.log", string);
					format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s was just gifted by the system and he won a free car.", GetPlayerNameEx(giveplayerid));
					ABroadCast(COLOR_YELLOW, string, 4);
					format(string, sizeof(string), "* %s was just gifted a free car, enjoy!", GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
				}
				else if(gift == 5)
				{
					if(PlayerInfo[giveplayerid][pDonateRank] > 0)
					{
						if(PlayerInfo[giveplayerid][pDonateRank] >= 4) return GiftPlayer(playerid, giveplayerid);
						PlayerInfo[giveplayerid][pTokens] += 15;
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Congratulations - you have won 15 VIP tokens!");
						format(string, sizeof(string), "* %s was just gifted 15 VIP tokens, enjoy!", GetPlayerNameEx(giveplayerid));
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
					}
					else
					{
						PlayerInfo[giveplayerid][pDonateRank] = 1;
						PlayerInfo[giveplayerid][pTempVIP] = 180;
						PlayerInfo[giveplayerid][pBuddyInvited] = 1;
						format(string, sizeof(string), "You have been invited to become a Level 1 VIP for 3 hours. Enjoy!", GetPlayerNameEx(giveplayerid));
						SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
						format(string, sizeof(string), "BUDDY INVITE: %s(%d) has won a buddyinvite.", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid));
						Log("logs/setvip.log", string);
						format(string, sizeof(string), "* %s was just gifted 3 hours of VIP, enjoy!", GetPlayerNameEx(giveplayerid));
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
					}
				}
				else if(gift == 6)
				{
					SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Congratulations - you have won a Free Laser Pointer!");
					format(string, sizeof(string), "* %s was just gifted a Free Laser Pointer, enjoy!", GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
					new icount = GetPlayerToySlots(giveplayerid);
					for(new v = 0; v < icount; v++)
					{
						if(PlayerToyInfo[giveplayerid][v][ptModelID] == 0)
						{
							PlayerToyInfo[giveplayerid][v][ptModelID] = 18643;
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
							PlayerInfo[giveplayerid][pGiftTime] = 300;
							return 1;
						}
					}
					
					for(new i = 0; i < MAX_PLAYERTOYS; i++)
					{
						if(PlayerToyInfo[giveplayerid][i][ptModelID] == 0)
						{
							PlayerToyInfo[giveplayerid][i][ptModelID] = 18643;
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
							
							SendClientMessageEx(giveplayerid, COLOR_GRAD1, "Due to you not having any available slots, we've temporarily gave you an additional slot to use/sell/trade your laser.");
							SendClientMessageEx(giveplayerid, COLOR_RED, "Note: Please take note that after selling the laser, the temporarily additional toy slot will be removed.");
							break;
						}	
					}
					//AddFlag(giveplayerid, INVALID_PLAYER_ID, "Free Laser Pointer (Gift)");
					//SendClientMessageEx(giveplayerid, COLOR_GREY, "You have no empty toy slots, so you have been flagged for a free laser.");
				}
				else if(gift == 7)
				{
					if(PlayerInfo[giveplayerid][pADMuteTotal] < 1) return GiftPlayer(playerid, giveplayerid);
					PlayerInfo[giveplayerid][pADMuteTotal] = 0;
					SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Congratulations - you have won a Free Admute Reset!");
					format(string, sizeof(string), "* %s was just gifted a Free Admute Reset, enjoy!", GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
				}
				else if(gift == 8)
				{
					if(PlayerInfo[giveplayerid][pNMuteTotal] < 1) return GiftPlayer(playerid, giveplayerid);
					PlayerInfo[giveplayerid][pNMuteTotal] = 0;
					SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Congratulations - you have won a Free Nmute Reset!");
					format(string, sizeof(string), "* %s was just gifted a Free Nmute Reset, enjoy!", GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
				}
			}
			else if(randgift > 98 && randgift <= 100)
			{
				new gift = Random(1, 6);
				if(gift == 1 && PlayerInfo[giveplayerid][pDonateRank] <= 2) // Silver VIP can get it extended, I suppose
				{
					PlayerInfo[giveplayerid][pSVIPVoucher]++;
					SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Congratulations - you have won one month of Silver VIP!");
					SendClientMessageEx(giveplayerid, COLOR_CYAN, " 1 Silver VIP Voucher has been added to your account.");
					SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Note you may access your voucher(s) with /myvouchers");
					if(playerid == MAX_PLAYERS) {
						format(string, sizeof(string), "AdmCmd: %s(%d) was just gifted by the system and he won one month of Silver VIP.", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid));
						Log("logs/gifts.log", string);
						format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s was just gifted by the system and he won one month of Silver VIP.", GetPlayerNameEx(giveplayerid));
					}
					else {
						format(string, sizeof(string), "AdmCmd: %s has just gifted %s(%d) and he won one month of Silver VIP.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid));
						Log("logs/gifts.log", string);
						format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s has just gifted %s and he won one month of Silver VIP.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
					}
					ABroadCast(COLOR_YELLOW, string, 2);
					format(string, sizeof(string), "* %s was just gifted one month of Silver VIP, enjoy!", GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
				}
				else if(gift == 2)
				{

					format(string, sizeof(string), "AdmCmd: %s(%d) was just gifted by the system and he won a free house", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid));
					Log("logs/gifts.log", string);
					format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s was just gifted by the system and he won a free house.", GetPlayerNameEx(giveplayerid));
					ABroadCast(COLOR_YELLOW, string, 2);
					SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Congratulations - you have won a free house!");
					SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Note: This rare reward may take up to 48 hours to be rewarded.");
					AddFlag(giveplayerid, INVALID_PLAYER_ID, "Free House (Gift)");
					format(string, sizeof(string), "* %s was just gifted a free house, enjoy!", GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
				}
				else if(gift == 3)
				{
					if(PlayerInfo[giveplayerid][pDonateRank] < 1) return GiftPlayer(playerid, giveplayerid);
					if(PlayerInfo[giveplayerid][pDonateRank] >= 4) return GiftPlayer(playerid, giveplayerid);
					PlayerInfo[giveplayerid][pTokens] += 50;
					SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Congratulations - you have won 50 VIP tokens!");
					format(string, sizeof(string), "* %s was just gifted 50 VIP tokens, enjoy!", GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
				}
				else if(gift == 4)
				{

					GivePlayerCash(giveplayerid, 500000);
					SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Congratulations - you have won $500,000!");
					if(playerid == MAX_PLAYERS) {
						format(string, sizeof(string), "AdmCmd: %s(%d) was just gifted by the system and he won $500,000.", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid));
						Log("logs/gifts.log", string);
						format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s was just gifted by the system and he won $500,000.", GetPlayerNameEx(giveplayerid));
					}
					else {
						format(string, sizeof(string), "AdmCmd: %s has just gifted %s(%d) and he won $500,000.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid));
						Log("logs/gifts.log", string);
						format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s has just gifted %s and he won $500,000.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
					}
					ABroadCast(COLOR_YELLOW, string, 2);
					format(string, sizeof(string), "* %s was just gifted $500,000, enjoy!", GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
				}
				else if(gift == 5)
				{
					PlayerInfo[giveplayerid][pGVIPVoucher]++;
					SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Congratulations - you have won one month of Gold VIP!");
					SendClientMessageEx(giveplayerid, COLOR_CYAN, " 1 Gold VIP Voucher has been added to your account.");
					SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Note you may access your voucher(s) with /myvouchers");
					if(playerid == MAX_PLAYERS) {
						format(string, sizeof(string), "AdmCmd: %s(%d) was just gifted by the system and he won one month of Gold VIP.", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid));
						Log("logs/gifts.log", string);
						format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s was just gifted by the system and he won one month of Gold VIP.", GetPlayerNameEx(giveplayerid));
					}
					else {
						format(string, sizeof(string), "AdmCmd: %s has just gifted %s(%d) and he won one month of Gold VIP.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid));
						Log("logs/gifts.log", string);
						format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s has just gifted %s and he won one month of Gold VIP.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
					}
					ABroadCast(COLOR_YELLOW, string, 2);
					format(string, sizeof(string), "* %s was just gifted one month of Gold VIP, enjoy!", GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
				}
			}
			else if(randgift > 100 && randgift <= 103) // Rim Mod
			{
				new gift = Random(1, 10);
				if(gift >= 1 && gift <= 3)
				{
					if(RimMod > 0) // Rim Kit
					{
						PlayerInfo[giveplayerid][pRimMod]++;
						RimMod--;
						g_mysql_SaveMOTD();

						if(playerid == MAX_PLAYERS) {
							format(string, sizeof(string), "AdmCmd: %s(%d) was just gifted by the system and he won a rim modification kit. (%d left)", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), RimMod);
						}
						else {
							format(string, sizeof(string), "AdmCmd: %s has just gifted %s(%d) and he won a rim modification kit. (%d left)", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), RimMod);
						}

						Log("logs/gifts.log", string);
						format(string, sizeof(string), "* %s was just gifted a rim modification kit, enjoy! Only %d kits left.", GetPlayerNameEx(giveplayerid), RimMod);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
					}
					else
					{
						GiftPlayer(MAX_PLAYERS, giveplayerid);
						return 1;
					}
				}
				else if(gift == 4) //
				{
					if(CarVoucher > 0)
					{
						PlayerInfo[giveplayerid][pCarVoucher]++;
						CarVoucher--;
						g_mysql_SaveMOTD();

						if(playerid == MAX_PLAYERS) {
							format(string, sizeof(string), "AdmCmd: %s(%d) was just gifted by the system and he won a restricted car voucher. (%d left)", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), CarVoucher);
						}
						else {
							format(string, sizeof(string), "AdmCmd: %s has just gifted %s(%d) and he won a restricted car voucher. (%d left)", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), CarVoucher);
						}

						Log("logs/gifts.log", string);
						format(string, sizeof(string), "* %s was just gifted a restricted car voucher, enjoy! Only %d car vouchers left.", GetPlayerNameEx(giveplayerid), CarVoucher);
						ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
						SendClientMessageEx(giveplayerid, COLOR_CYAN, " 1 Restricted Car Voucher has been added to your account.");
						SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Note you may access your voucher(s) with /myvouchers");
					}
					else
					{
						GiftPlayer(MAX_PLAYERS, giveplayerid);
						return 1;
					}
				}
				else if(gift == 5) //
				{
					new gift2 = Random(1, 15);
					if(gift2 == 3)
					{
						if(PVIPVoucher > 0)
						{
							PlayerInfo[giveplayerid][pPVIPVoucher]++;
							PVIPVoucher--;
							g_mysql_SaveMOTD();
							
							if(playerid == MAX_PLAYERS)
							{
								format(string, sizeof(string), "AdmCmd: %s(%d) was just gifted by the system and he won a 1 month PVIP Voucher. (%d left)", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), PVIPVoucher);
							}
							else
							{
								format(string, sizeof(string), "AdmCmd: %s has just gifted %s(%d) and he won a 1 month PVIP Voucher. (%d left)", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), PVIPVoucher);
							}	
						
							Log("logs/gifts.log", string);
							format(string, sizeof(string), "* %s was just gifted a 1 month PVIP Voucher, enjoy! There are %d 1 month PVIP Vouchers left.", GetPlayerNameEx(giveplayerid), PVIPVoucher);
							ProxDetector(30.0, giveplayerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
							SendClientMessageEx(giveplayerid, COLOR_CYAN, " 1 1 month PVIP Voucher has been added to your account.");
							SendClientMessageEx(giveplayerid, COLOR_GRAD2, " Note you may access your voucher(s) with /myvouchers");
							
							SendClientMessageToAll(COLOR_WHITE, string);
						}
						else
						{
							GiftPlayer(MAX_PLAYERS, giveplayerid);
							return 1;
						}
					}
					else
					{
						GiftPlayer(MAX_PLAYERS, giveplayerid);
						return 1;
					}
				}
				else
				{
					GiftPlayer(MAX_PLAYERS, giveplayerid);
					return 1;
				}
			}
			PlayerInfo[giveplayerid][pGiftTime] = 300;
		}
	}
	return 1;
}

stock GetDynamicGiftBoxType(value)
{
	new string[128];
	if(value == 0)
		format(string, sizeof(string), "Less Common");
	else if(value == 1)
		format(string, sizeof(string), "Common");
	else if(value == 2)
		format(string, sizeof(string), "Rare");
	else if(value == 3)
		format(string, sizeof(string), "Super Rare");
	return string;
}

stock ShowPlayerDynamicGiftBox(playerid)
{
	szMiscArray[0] = 0;

	szMiscArray = "{1B7A3C}Giftbox Settings{FFFFFF}";
	if(dgVar[dgMoney][0] == 1)
		format(szMiscArray, sizeof(szMiscArray), "%s\n{00FF61}Money", szMiscArray);
	else
		format(szMiscArray, sizeof(szMiscArray), "%s\n{F2070B}Money", szMiscArray);
	if(dgVar[dgRimKit][0] == 1)
		format(szMiscArray, sizeof(szMiscArray), "%s\n{00FF61}Rimkit", szMiscArray);
	else
		format(szMiscArray, sizeof(szMiscArray), "%s\n{F2070B}Rimkit", szMiscArray);
	if(dgVar[dgFirework][0] == 1)
		format(szMiscArray, sizeof(szMiscArray), "%s\n{00FF61}Firework", szMiscArray);
	else
		format(szMiscArray, sizeof(szMiscArray), "%s\n{F2070B}Firework", szMiscArray);
	if(dgVar[dgGVIP][0] == 1)
		format(szMiscArray, sizeof(szMiscArray), "%s\n{00FF61}7 Days Gold VIP", szMiscArray);
	else
		format(szMiscArray, sizeof(szMiscArray), "%s\n{F2070B}7 Days Gold VIP", szMiscArray);
	if(dgVar[dgGVIPEx][0] == 1)
		format(szMiscArray, sizeof(szMiscArray), "%s\n{00FF61}1 Month Gold VIP", szMiscArray);
	else
		format(szMiscArray, sizeof(szMiscArray), "%s\n{F2070B}1 Month Gold VIP", szMiscArray);
	if(dgVar[dgSVIP][0] == 1)
		format(szMiscArray, sizeof(szMiscArray), "%s\n{00FF61}7 Days Silver VIP", szMiscArray);
	else
		format(szMiscArray, sizeof(szMiscArray), "%s\n{F2070B}7 Days Silver VIP", szMiscArray);
	if(dgVar[dgSVIPEx][0] == 1)
		format(szMiscArray, sizeof(szMiscArray), "%s\n{00FF61}1 Month Silver VIP", szMiscArray);
	else
		format(szMiscArray, sizeof(szMiscArray), "%s\n{F2070B}1 Month Silver VIP", szMiscArray);
	if(dgVar[dgCarSlot][0] == 1)
		format(szMiscArray, sizeof(szMiscArray), "%s\n{00FF61}Car Slot", szMiscArray);
	else
		format(szMiscArray, sizeof(szMiscArray), "%s\n{F2070B}Car Slot", szMiscArray);
	if(dgVar[dgToySlot][0] == 1)
		format(szMiscArray, sizeof(szMiscArray), "%s\n{00FF61}Toy Slot", szMiscArray);
	else
		format(szMiscArray, sizeof(szMiscArray), "%s\n{F2070B}Toy Slot", szMiscArray);
	if(dgVar[dgArmor][0] == 1)
		format(szMiscArray, sizeof(szMiscArray), "%s\n{00FF61}Full Armor", szMiscArray);
	else
		format(szMiscArray, sizeof(szMiscArray), "%s\n{F2070B}Full Armor", szMiscArray);
	if(dgVar[dgFirstaid][0] == 1)
		format(szMiscArray, sizeof(szMiscArray), "%s\n{00FF61}Firstaid", szMiscArray);
	else
		format(szMiscArray, sizeof(szMiscArray), "%s\n{F2070B}Firstaid", szMiscArray);
	if(dgVar[dgDDFlag][0] == 1)
		format(szMiscArray, sizeof(szMiscArray), "%s\n{00FF61}Dynamic Door Flag", szMiscArray);
	else
		format(szMiscArray, sizeof(szMiscArray), "%s\n{F2070B}Dynamic Door Flag", szMiscArray);
	if(dgVar[dgGateFlag][0] == 1)
		format(szMiscArray, sizeof(szMiscArray), "%s\n{00FF61}Dynamic Gate Flag", szMiscArray);
	else
		format(szMiscArray, sizeof(szMiscArray), "%s\n{F2070B}Dynamic Gate Flag", szMiscArray);
	if(dgVar[dgCredits][0] == 1)
		format(szMiscArray, sizeof(szMiscArray), "%s\n{00FF61}Credits", szMiscArray);
	else
		format(szMiscArray, sizeof(szMiscArray), "%s\n{F2070B}Credits", szMiscArray);
	if(dgVar[dgPriorityAd][0] == 1)
		format(szMiscArray, sizeof(szMiscArray), "%s\n{00FF61}Priority Ad", szMiscArray);
	else
		format(szMiscArray, sizeof(szMiscArray), "%s\n{F2070B}Priority Ad", szMiscArray);
	if(dgVar[dgHealthNArmor][0] == 1)
		format(szMiscArray, sizeof(szMiscArray), "%s\n{00FF61}Health & Armor", szMiscArray);
	else
		format(szMiscArray, sizeof(szMiscArray), "%s\n{F2070B}Health & Armor", szMiscArray);
	if(dgVar[dgGiftReset][0] == 1)
		format(szMiscArray, sizeof(szMiscArray), "%s\n{00FF61}Gift Reset", szMiscArray);
	else
		format(szMiscArray, sizeof(szMiscArray), "%s\n{F2070B}Gift Reset", szMiscArray);
	if(dgVar[dgMaterial][0] == 1)
		format(szMiscArray, sizeof(szMiscArray), "%s\n{00FF61}Material", szMiscArray);
	else
		format(szMiscArray, sizeof(szMiscArray), "%s\n{F2070B}Material", szMiscArray);
	if(dgVar[dgWarning][0] == 1)
		format(szMiscArray, sizeof(szMiscArray), "%s\n{00FF61}Warning", szMiscArray);
	else
		format(szMiscArray, sizeof(szMiscArray), "%s\n{F2070B}Warning", szMiscArray);
	if(dgVar[dgPot][0] == 1)
		format(szMiscArray, sizeof(szMiscArray), "%s\n{00FF61}Pot", szMiscArray);
	else
		format(szMiscArray, sizeof(szMiscArray), "%s\n{F2070B}Pot", szMiscArray);
	if(dgVar[dgCrack][0] == 1)
		format(szMiscArray, sizeof(szMiscArray), "%s\n{00FF61}Crack", szMiscArray);
	else
		format(szMiscArray, sizeof(szMiscArray), "%s\n{F2070B}Crack", szMiscArray);
	if(dgVar[dgPaintballToken][0] == 1)
		format(szMiscArray, sizeof(szMiscArray), "%s\n{00FF61}Paintball Token", szMiscArray);
	else
		format(szMiscArray, sizeof(szMiscArray), "%s\n{F2070B}Paintball Token", szMiscArray);
	if(dgVar[dgVIPToken][0] == 1)
		format(szMiscArray, sizeof(szMiscArray), "%s\n{00FF61}VIP Token", szMiscArray);
	else
		format(szMiscArray, sizeof(szMiscArray), "%s\n{F2070B}VIP Token", szMiscArray);
	if(dgVar[dgRespectPoint][0] == 1)
		format(szMiscArray, sizeof(szMiscArray), "%s\n{00FF61}Respect Point", szMiscArray);
	else
		format(szMiscArray, sizeof(szMiscArray), "%s\n{F2070B}Respect Point", szMiscArray);
	if(dgVar[dgCarVoucher][0] == 1)
		format(szMiscArray, sizeof(szMiscArray), "%s\n{00FF61}Car Voucher", szMiscArray);
	else
		format(szMiscArray, sizeof(szMiscArray), "%s\n{F2070B}Car Voucher", szMiscArray);
	if(dgVar[dgBuddyInvite][0] == 1)
		format(szMiscArray, sizeof(szMiscArray), "%s\n{00FF61}Buddy Invite", szMiscArray);
	else
		format(szMiscArray, sizeof(szMiscArray), "%s\n{F2070B}Buddy Invite", szMiscArray);
	if(dgVar[dgLaser][0] == 1)
		format(szMiscArray, sizeof(szMiscArray), "%s\n{00FF61}Laser", szMiscArray);
	else
		format(szMiscArray, sizeof(szMiscArray), "%s\n{F2070B}Laser", szMiscArray);
	if(dgVar[dgCustomToy][0] == 1)
		format(szMiscArray, sizeof(szMiscArray), "%s\n{00FF61}Custom Toy", szMiscArray);
	else
		format(szMiscArray, sizeof(szMiscArray), "%s\n{F2070B}Custom Toy", szMiscArray);
	if(dgVar[dgAdmuteReset][0] == 1)
		format(szMiscArray, sizeof(szMiscArray), "%s\n{00FF61}Advertisement Mute Reset", szMiscArray);
	else
		format(szMiscArray, sizeof(szMiscArray), "%s\n{F2070B}Advertisement Mute Reset", szMiscArray);
	if(dgVar[dgNewbieMuteReset][0] == 1)
		format(szMiscArray, sizeof(szMiscArray), "%s\n{00FF61}Newbie Mute Reset", szMiscArray);
	else
		format(szMiscArray, sizeof(szMiscArray), "%s\n{F2070B}Newbie Mute Reset", szMiscArray);
	if(dgVar[dgRestrictedCarVoucher][0] == 1)
		format(szMiscArray, sizeof(szMiscArray), "%s\n{00FF61}Restricted Car Voucher", szMiscArray);
	else
		format(szMiscArray, sizeof(szMiscArray), "%s\n{F2070B}Restricted Car Voucher", szMiscArray);
	if(dgVar[dgPlatinumVIPVoucher][0] == 1)
		format(szMiscArray, sizeof(szMiscArray), "%s\n{00FF61}1 month PVIP Voucher", szMiscArray);
	else
		format(szMiscArray, sizeof(szMiscArray), "%s\n{F2070B}1 month PVIP Voucher", szMiscArray);
		
	return ShowPlayerDialogEx(playerid, DIALOG_GIFTBOX_VIEW, DIALOG_STYLE_LIST, "Dynamic Giftbox", szMiscArray, "Select", "Close");
}

CMD:gifts(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 1337)
    {
     	if(Gifts == 0)
     	{
           	Gifts = 1;
			format(szMiscArray, sizeof(szMiscArray), "AdmCmd: %s has enabled the /gift command.", GetPlayerNameEx(playerid));
			ABroadCast(COLOR_LIGHTRED, szMiscArray, 1337 );
		}
		else
		{
		    Gifts = 0;
		   
	   		format(szMiscArray, sizeof(szMiscArray), "AdmCmd: %s has disabled the /gift command.", GetPlayerNameEx(playerid));
			ABroadCast( COLOR_LIGHTRED, szMiscArray, 1337 );
		}
	}
	return 1;
}

CMD:vipgifts(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 1337)
    {
     	if(VIPGifts == 0)
     	{
           	VIPGifts = 1;
			format(szMiscArray, sizeof(szMiscArray), "%s would like for you to come to Club VIP for free gifts and great times [20 minutes remains]", GetPlayerNameEx(playerid));
			SendVIPMessage(COLOR_LIGHTGREEN, szMiscArray);
			VIPGiftsTimeLeft = 20;
			format(VIPGiftsName, sizeof(VIPGiftsName), "%s", GetPlayerNameEx(playerid));
		}
		else
		{
		    VIPGifts = 0;
	   		format(szMiscArray, sizeof(szMiscArray), "AdmCmd: %s has disabled the /getgift command early", GetPlayerNameEx(playerid));
			ABroadCast( COLOR_LIGHTRED, szMiscArray, 1337 );
			format(szMiscArray, sizeof(szMiscArray), "Club VIP is no longer giving away free gifts. Thanks for coming!", VIPGiftsName, VIPGiftsTimeLeft);
			SendVIPMessage(COLOR_LIGHTGREEN, szMiscArray);
			VIPGiftsTimeLeft = 0;
		}
	}
	return 1;
}

CMD:resetgift(playerid, params[])
{
	new giveplayerid;
	if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /resetgift [player]");

    if(PlayerInfo[playerid][pAdmin] >= 1337)
	{
		if(IsPlayerConnected(giveplayerid))
		{
	   		if(PlayerInfo[giveplayerid][pGiftTime] > 0)
    		{
	    	    PlayerInfo[giveplayerid][pGiftTime] = 0;
	     	    format(szMiscArray, sizeof(szMiscArray), "%s's gift timer has been reset", GetPlayerNameEx(giveplayerid));
	     	    SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
   			}
   			else
   			{
	   		    SendClientMessageEx(playerid, COLOR_GRAD2, "That players gift timer is already on 0!");
			}
		}
		else
		{
   			SendClientMessageEx(playerid, COLOR_GRAD2, "That person is not connected.");
		}
	}
	return 1;
}

CMD:giftnear(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 1337)
	{
       	new range;
		if(sscanf(params, "d", range)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /giftnear [range]");

		if(range < 1)
		{
		    SendClientMessageEx(playerid, COLOR_WHITE, "The range can not be lower than 1.");
			return 1;
		}

        new count;
        foreach(new i: Player)
		{
			if(ProxDetectorS(range, playerid, i))
			{
				if(PlayerInfo[i][pGiftTime] <= 0)
				{
					GiftPlayer(playerid, i);
					count++;
				}
			}
		}	
        format(szMiscArray, sizeof(szMiscArray), "You have gifted everyone (%d) nearby.", count);
        SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
    }
    return 1;
}

CMD:resetgiftall(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 1337)
	{
		format(szMiscArray, sizeof(szMiscArray), "{AA3333}AdmWarning{FFFF00}: %s has reset everyone's gift timer.", GetPlayerNameEx(playerid));
		ABroadCast(COLOR_YELLOW, szMiscArray, 2);
		foreach(new i: Player)
		{
			PlayerInfo[i][pGiftTime] = 0;
		}
	}
	return 1;
}

CMD:gift(playerid, params[])
{
	new giveplayerid;
	if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /gift [player]");

    if(PlayerInfo[playerid][pAdmin] >= 2)
	{
 		if(Gifts == 1 || PlayerInfo[playerid][pAdmin] >= 1337)
   		{
			if(giveplayerid != INVALID_PLAYER_ID)
			{
			    if(PlayerInfo[giveplayerid][pGiftTime] > 0)
	           	{
	               	SendClientMessageEx(playerid, COLOR_GRAD2, "The person has already got a gift in the last 5 hours !");
					return 1;
	           	}
			    GiftPlayer(playerid, giveplayerid);
			}
			else
			{
			    SendClientMessageEx(playerid, COLOR_GRAD2, "That person is not connected.");
			}
		}
		else
		{
		    SendClientMessageEx(playerid, COLOR_GRAD2, "This command is not activated!");
		}
	}
	return 1;
}

CMD:giftall(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 1337)
    {
    	if(GiftAllowed || PlayerInfo[playerid][pAdmin] >= 99999)
     	{
      		format(szMiscArray, sizeof(szMiscArray), "{AA3333}AdmWarning{FFFF00}: %s has just sent a gift to all players.", GetPlayerNameEx(playerid));
			ABroadCast(COLOR_YELLOW, szMiscArray, 2);
			GiftAllowed = 0;
			foreach(new i: Player)
			{
				GiftPlayer(playerid, i);
			}	
		}
		else
		{
		    return SendClientMessageEx(playerid, COLOR_GRAD2, "This command has already been used, wait until the next paycheck!");
		}
	}
	return 1;
}

CMD:giftreset(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 1338) return SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use that command.");
	new giveplayerid;
	if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /giftreset [player]");
	if(!IsPlayerConnected(giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");
	if(PlayerInfo[giveplayerid][pGiftTime] == 0) return SendClientMessageEx(playerid, COLOR_GREY, "This player is already able to receive a gift.");
	format(szMiscArray, sizeof(szMiscArray), "{AA3333}AdmWarning{FFFF00}: %s has reset %s's gift timer.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
	ABroadCast(COLOR_YELLOW, szMiscArray, 2);
	PlayerInfo[giveplayerid][pGiftTime] = 0;
	return 1;
}

CMD:setcode(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] >= 99999 || PlayerInfo[playerid][pShopTech] >= 3)
	{
		new code[32], bypass;
		if (sscanf(params, "s[32]d", code, bypass))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Usage: /setcode <code> <bypass 0/1>");
			SendClientMessageEx(playerid, COLOR_GREY, "If code is 'off', the active code will be disabled.");
			return 1;
		}

		format(GiftCode, 32, code);
		GiftCodeBypass = bypass;
        g_mysql_SaveMOTD();
		mysql_tquery(MainPipeline, "UPDATE `accounts` SET `GiftCode` = 0;", "OnQueryFinish", "i", SENDDATA_THREAD);
		foreach(new i : Player)
		{
			if(PlayerInfo[i][pGiftCode] == 1)
				PlayerInfo[i][pGiftCode] = 0;
		}		


		if (strcmp(code, "off") == 0)
		{
			format(szMiscArray, sizeof(szMiscArray), "You have disabled the gift code.");
		}
		else
		{
			format(szMiscArray, sizeof(szMiscArray), "You have set the gift code to \"%s\".", code);
		}

		SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	}

	return 1;
}

CMD:giftcode(playerid, params[])
{
	if (isnull(params))
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "Usage: /giftcode <code>");
		return 1;
	}
	if(PlayerInfo[playerid][pLevel] < 3) {
		SendClientMessageEx(playerid, COLOR_GREY, "You must be at least level 3 to use this command.");
		return 1;
	}
	if (strcmp(GiftCode, "off") == 0)
	{
	    SendClientMessageEx(playerid, COLOR_GREY, "No gift codes are currently active.");
		return 1;
	}
	else
	{
	    if (strcmp(params, GiftCode) == 0)
		{
		    if(GiftCodeBypass > 0)
		    {
		        if(PlayerInfo[playerid][pGiftCode] == 0)
		        {
		            SendClientMessageEx(playerid, COLOR_WHITE, "The code you entered was valid!");
		        	PlayerInfo[playerid][pGiftCode] = 1;
		        	GiftPlayer(MAX_PLAYERS, playerid);
				}
				else
				{
				    SendClientMessageEx(playerid, COLOR_GREY, "You have already entered the gift code.");
				}
			}
			else
			{
			    if(PlayerInfo[playerid][pGiftTime] == 0)
			    {
					if(PlayerInfo[playerid][pGiftCode] == 0)
					{
					    SendClientMessageEx(playerid, COLOR_WHITE, "The code you entered was valid!");
			  			PlayerInfo[playerid][pGiftCode] = 1;
			  			GiftPlayer(MAX_PLAYERS, playerid);
					}
					else
					{
					    SendClientMessageEx(playerid, COLOR_GREY, "You have already entered the gift code.");
					}
			    }
			    else
			    {
			        SendClientMessageEx(playerid, COLOR_GREY, "You have already received a gift in the last 5 hours.");
			    }
			}
		}
		else
		{
		    SendClientMessageEx(playerid, COLOR_GREY, "You have entered a invalid gift code.");
		}
	}
	return 1;
}

CMD:dynamicgift(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 1337)
	{
		if(IsPlayerInAnyVehicle(playerid))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "You must be on foot to use this command.");
			return 1;
		}

		new string[128], Float:Position[4];
		if(dynamicgift == 0)
		{
			GetPlayerPos(playerid, Position[0], Position[1], Position[2]);
			GetPlayerFacingAngle(playerid, Position[3]);
			dynamicgift = CreateDynamicObject(19054, Position[0], Position[1], Position[2]-0.4, 0.0, 0.0, Position[3], -1, -1, -1, 200.0);
			dynamicgift3DText = CreateDynamic3DTextLabel("/getgift\nTo reach inside.",COLOR_YELLOW,Position[0], Position[1], Position[2]+0.25,8.0);
			SetPlayerPos(playerid, Position[0], Position[1], Position[2]+3);
			format(string, sizeof(string), "AdmCmd: %s has placed the dynamic gift.", GetPlayerNameEx(playerid));
			
			if(IsDynamicGiftBoxEnabled == true)
			{
				SendClientMessageEx(playerid, COLOR_RED, "Due to the Dynamic Giftbox being enabled, you may view the content inside the giftbox.");
				
				if(PlayerInfo[playerid][pAdmin] == 99999 || PlayerInfo[playerid][pShopTech] >= 3) 
				{
					SendClientMessageEx(playerid, COLOR_RED, "Note: You must fill up the giftbox with /dgedit.");
				}
				ShowPlayerDynamicGiftBox(playerid);
			}
			ABroadCast( COLOR_LIGHTRED, string, 1337);
		}
		else
		{
			DestroyDynamicObject(dynamicgift);
			dynamicgift = 0;
			DestroyDynamic3DTextLabel( Text3D:dynamicgift3DText );
			format(string, sizeof(string), "AdmCmd: %s has destroyed the dynamic gift.", GetPlayerNameEx(playerid));
			ABroadCast( COLOR_LIGHTRED, string, 1337);
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	}
	return 1;
}

CMD:nextgift(playerid, params[])
{
	new string[128];
	if(PlayerInfo[playerid][pGiftTime] < 1)
	{
		SendClientMessageEx(playerid, COLOR_YELLOW, "You're now able to receive a gift from the giftbox or the safe.");
	}
	else {	
		format(string, sizeof(string), "You will be able to receive a gift in %d minutes.", PlayerInfo[playerid][pGiftTime]);
		SendClientMessageEx(playerid, COLOR_YELLOW, string);
	}	
	return 1;
}

CMD:getgift(playerid, params[])
{
	new string[128], year, month, day;
	getdate(year, month, day);

	if(IsPlayerInRangeOfPoint(playerid, 3.0,2546.680908, 1403.430786, 7699.584472) || IsPlayerInRangeOfPoint(playerid, 3.0,1726.1000, 1370.1000, 1449.9000) || IsPlayerInRangeOfPoint(playerid, 3.0,1763.5000, 1432.5000, 2015.7000) || IsPlayerInRangeOfPoint(playerid, 3.0,772.4000, 1743.2000, 1938.8800))
	{
		if(PlayerInfo[playerid][pDonateRank] >= 1)
		{
			if(VIPGifts == 0 && PlayerInfo[playerid][pDonateRank] < 4)
			{
				SendClientMessageEx(playerid, COLOR_GRAD2, "The safe is locked!");
				return 1;
			}
			if(PlayerInfo[playerid][pGiftTime] > 0)
			{
			    format(string, sizeof(string),"Item: Reset Gift Timer\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[17][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[17][sItemPrice]));
	    		ShowPlayerDialogEx( playerid, DIALOG_SHOPGIFTRESET, DIALOG_STYLE_MSGBOX, "Reset Gift Timer", string, "Purchase", "Exit" );
				SendClientMessageEx(playerid, COLOR_GRAD2, "You have already received a gift in the last 5 hours!");
				return 1;
			}
			format(string, sizeof(string), "* %s reaches inside the safe with their eyes closed.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			GiftPlayer(MAX_PLAYERS, playerid);
		}
	}
	else if(dynamicgift != 0)
	{
		new Float:Position[3];
		GetDynamicObjectPos(dynamicgift, Position[0], Position[1], Position[2]);

		if(IsPlayerInRangeOfPoint(playerid, 5.0, Position[0], Position[1], Position[2]))
		{
			if(PlayerInfo[playerid][pLevel] >= 3)
			{
				if(PlayerInfo[playerid][pGiftTime] > 0 && (IsDynamicGiftBoxEnabled == false || (IsDynamicGiftBoxEnabled == true && !dgGoldToken)))
				{
				    format(string, sizeof(string),"Item: Reset Gift Timer\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[17][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[17][sItemPrice]));
	    			ShowPlayerDialogEx( playerid, DIALOG_SHOPGIFTRESET, DIALOG_STYLE_MSGBOX, "Reset Gift Timer", string, "Purchase", "Exit" );
					SendClientMessageEx(playerid, COLOR_GRAD2, "You have already received a gift in the last 5 hours!");
					return 1;
				}
				if(IsDynamicGiftBoxEnabled == true)
				{
					if(dgGoldToken)
					{
						if(!PlayerInfo[playerid][pGoldBoxTokens]) return SendClientMessageEx(playerid, COLOR_GREY, "You have no Gold Giftbox tokens!");
						PlayerInfo[playerid][pGoldBoxTokens]--;
					}
					GiftPlayer(MAX_PLAYERS, playerid, 1);
				}
				else if(IsDynamicGiftBoxEnabled == false)
				{
					GiftPlayer(MAX_PLAYERS, playerid);
				}
				format(string, sizeof(string), "* %s reaches inside the bag of gifts with their eyes closed.", GetPlayerNameEx(playerid));
				ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_WHITE, "* You must be at least level 3 to use this, sorry!");
			}
		}
	}
	return 1;
}

// Dynamic Giftbox
CMD:dgedit(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 99999 && PlayerInfo[playerid][pShopTech] < 3) return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not authorized to use this command!");
	new string[128], choice[32], type, amount, var;
	if(strcmp(params, "autoreset", true) == 0)
	{
		DeletePVar(playerid, "dgInputSel");
		format(string, sizeof(string), "Timer: %d min(s)\nAmount: %d\n%s", dgTimerTime, dgAmount, (dgTimer != -1)?("{FF0606}Disable"):("{00ff00}Enable"));
		return ShowPlayerDialogEx(playerid, DIALOG_DGRAUTORESET, DIALOG_STYLE_LIST, "Dynamic Giftbox Auto Reset - Select to modify", string, "Select", "Close");
	}
	if(sscanf(params, "s[32]dD", choice, type, amount))
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "Usage: /dgedit [choice] [type] [value]");
		SendClientMessageEx(playerid, COLOR_GRAD1, "Available Choices: Money, RimKit, Firework, 7DayGVIP, 1MonthGVIP, 7DaySVIP, 1MonthSVIP, CarSlot, ToySlot");
		SendClientMessageEx(playerid, COLOR_GRAD1, "Available Choices: FullArmor, Firstaid, DDFlag, GateFlag, Credits, PriorityAd, HealthNArmor, Giftreset, Material");
		SendClientMessageEx(playerid, COLOR_GRAD1, "Available Choices: Warning, Pot, Crack, PaintballToken, VIPToken, RespectPoint, CarVoucher, BuddyInvite, Laser");
		SendClientMessageEx(playerid, COLOR_GRAD1, "Available Choices: CustomToy, AdmuteReset, NewbieMuteReset, RestrictedCarVoucher, PlatVIPVoucher");
		SendClientMessageEx(playerid, COLOR_GRAD1, "Available Choices: AutoReset, UseGoldTokens");
		return SendClientMessageEx(playerid, COLOR_RED, "Available Types: 0 = Enable/Disable | 1 = Quantity available | 2 = Quantity Given | 3 = Category");
	}
	if(type < 0 || type > 3) 
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid Type!");
		return SendClientMessageEx(playerid, COLOR_RED, "Available Type: 0 = Enable/Disable | 1 = Quantity available | 2 = Quantity Given | 3 = Category");
	}
	if(amount < 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot choose an amount below 0!");
	if(strcmp(choice, "money", true) == 0) var = dgMoney;
	else if(strcmp(choice, "rimkit", true) == 0) var = dgRimKit;
	else if(strcmp(choice, "firework", true) == 0) var = dgFirework;
	else if(strcmp(choice, "7daygvip", true) == 0) var = dgGVIP;
	else if(strcmp(choice, "1monthgvip", true) == 0) var = dgGVIPEx;
	else if(strcmp(choice, "7daysvip", true) == 0) var = dgSVIPEx;
	else if(strcmp(choice, "1monthsvip", true) == 0) var = dgSVIP;
	else if(strcmp(choice, "carslot", true) == 0) var = dgCarSlot;
	else if(strcmp(choice, "toyslot", true) == 0) var = dgToySlot;
	else if(strcmp(choice, "fullarmor", true) == 0) var = dgArmor;
	else if(strcmp(choice, "firstaid", true) == 0) var = dgFirstaid;
	else if(strcmp(choice, "ddflag", true) == 0) var = dgDDFlag;
	else if(strcmp(choice, "gateflag", true) == 0) var = dgGateFlag;
	else if(strcmp(choice, "credits", true) == 0) var = dgCredits;
	else if(strcmp(choice, "priorityad", true) == 0) var = dgPriorityAd;
	else if(strcmp(choice, "healthnarmor", true) == 0) var = dgHealthNArmor;
	else if(strcmp(choice, "giftreset", true) == 0) var = dgGiftReset;
	else if(strcmp(choice, "material", true) == 0) var = dgMaterial;
	else if(strcmp(choice, "warning", true) == 0) var = dgWarning;
	else if(strcmp(choice, "pot", true) == 0) var = dgPot;
	else if(strcmp(choice, "crack", true) == 0) var = dgCrack;
	else if(strcmp(choice, "paintballtoken", true) == 0) var = dgPaintballToken;
	else if(strcmp(choice, "viptoken", true) == 0) var = dgVIPToken;
	else if(strcmp(choice, "respectpoint", true) == 0) var = dgRespectPoint;
	else if(strcmp(choice, "carvoucher", true) == 0) var = dgCarVoucher;
	else if(strcmp(choice, "buddyinvite", true) == 0) var = dgBuddyInvite;
	else if(strcmp(choice, "laser", true) == 0) var = dgLaser;
	else if(strcmp(choice, "customtoy", true) == 0) var = dgCustomToy;
	else if(strcmp(choice, "admutereset", true) == 0) var = dgAdmuteReset;
	else if(strcmp(choice, "newbiemutereset", true) == 0) var = dgNewbieMuteReset;
	else if(strcmp(choice, "restrictedcarvoucher", true) == 0) var = dgRestrictedCarVoucher;
	else if(strcmp(choice, "platvipvoucher", true) == 0) var = dgPlatinumVIPVoucher;
	else if(strcmp(choice, "autoreset", true) == 0) return cmd_dgedit(playerid, "autoreset");
	else if(strcmp(choice, "usegoldtokens", true) == 0)
	{
		if(dgGoldToken) dgGoldToken = 0, SendClientMessageEx(playerid, COLOR_WHITE, "You have disabled the use of a Gold Giftbox token to recieve a gift.");
		else dgGoldToken = 1, SendClientMessageEx(playerid, COLOR_WHITE, "You have enabled the use of a Gold Giftbox token to recieve a gift.");
		return 1;
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid Choice!");
	// Prepare the proper and approriate string
	switch(type)
	{
		case 0:
		{
			// Little check to make sure they're not inserting invalid values
			if(amount < 0 || amount > 1) return SendClientMessage(playerid, COLOR_RED, "0 = Disabled | 1 - Enabled");
			switch(amount)
			{
				case 0: format(string, sizeof(string), "You have disabled the gift.");
				case 1: format(string, sizeof(string), "You have enabled the gift.");
				default: return true;
			}
		}
		case 1:
		{
			format(string, sizeof(string), "You have set the gift quantity to %s.", number_format(amount));
		}
		case 2:
		{
			format(string, sizeof(string), "You have set the gift amount to %s.", number_format(amount));
		}
		case 3:
		{
			if(amount < 0 || amount > 3) return SendClientMessageEx(playerid, COLOR_RED, "0 = Common | 1 = Less Common | 2 = Rare | 3 = Super Rare");
			switch(amount)
			{
				case 0: format(string, sizeof(string), "You have set the category to Common.");
				case 1: format(string, sizeof(string), "You have set the category to Less Common.");
				case 2: format(string, sizeof(string), "You have set the category to Rare.");
				case 3: format(string, sizeof(string), "You have set the category to Super Rare.");
				default: return true;
			}
		}
		default: return true;
	}
	// Set the data to the variable
	dgVar[dgItems:var][type] = amount;
	// Save the GiftBox Stuff
	SaveDynamicGiftBox();
	// Send the client message
	SendClientMessageEx(playerid, COLOR_WHITE, string);
	return true;
}

CMD:viewgiftbox(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] == 99999 || PlayerInfo[playerid][pShopTech] >= 3)
	{
		ShowPlayerDynamicGiftBox(playerid);
	}
	else
		return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not an Executive Administrator!");
	return true;
}

CMD:togdynamicgift(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] == 99999 || PlayerInfo[playerid][pShopTech] >= 3)
	{
		if(IsDynamicGiftBoxEnabled == false)
		{
			IsDynamicGiftBoxEnabled = true;
			SendClientMessageEx(playerid, COLOR_WHITE, "You have enabled the Dynamic GiftBox, please use /dgedit to modify the giftbox items.");
		}
		else if(IsDynamicGiftBoxEnabled == true)
		{
			IsDynamicGiftBoxEnabled = false;
			SendClientMessageEx(playerid, COLOR_WHITE, "You have disabled the Dynamic Giftbox.");
		}
	}
	else
		return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not an Executive Administrator!");
	return true;
}

CMD:giftbox(playerid, params[])
{
	if(dynamicgift != 0)
	{
		new Float: pos[3];
		SendClientMessageEx(playerid, COLOR_YELLOW, "** There is currently a giftbox placed down and we have set a checkpoint to the location of the giftbox.");
		if(CheckPointCheck(playerid)) cmd_killcheckpoint(playerid, params); //If they have a checkpoint, just remove it
		DisablePlayerCheckpoint(playerid);
		GetDynamicObjectPos(dynamicgift, pos[0], pos[1], pos[2]);
		SetPlayerCheckpoint(playerid, pos[0], pos[1], pos[2], 5);
		SetPVarInt(playerid, "GiftBoxCP", 1);
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_YELLOW, "** There is currently no giftbox placed down.");
	}
	return true;
}