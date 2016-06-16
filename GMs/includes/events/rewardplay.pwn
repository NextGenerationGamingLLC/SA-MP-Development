/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

					Reward Play System

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

CMD:rewards(playerid, params[]) {
	new string[128];
	SendClientMessageEx(playerid, COLOR_GREEN, "Reward Information:");
	format(string, sizeof(string), "Total Reward Hours: %d", floatround(PlayerInfo[playerid][pRewardHours]));
	SendClientMessageEx(playerid, COLOR_YELLOW, string);
	format(string, sizeof(string), "Chances in #FallIntoFun Prize Drawing: %d", PlayerInfo[playerid][pRewardDrawChance]);
	SendClientMessageEx(playerid, COLOR_YELLOW, string);
	format(string, sizeof(string), "Gold Giftbox Tokens: %d", PlayerInfo[playerid][pGoldBoxTokens]);
	SendClientMessageEx(playerid, COLOR_YELLOW, string);
	if(!iRewardBox)
	{
		SendClientMessageEx(playerid, COLOR_RED, "Note: The gold gift box is currently disabled.");
	}
	return 1;
}

CMD:goldgiftbox(playerid, params[]) {
	if(PlayerInfo[playerid][pAdmin] >= 1337) switch(iRewardBox) {
	    case 0: {

	        new
				Float: fPos[3],
				szMessage[64];

			GetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]);
			iRewardObj = CreateDynamicObject(19055, fPos[0], fPos[1], fPos[2], 0.0, 0.0, 0.0, .streamdistance = 100.0);
			tRewardText = CreateDynamic3DTextLabel("Gold Reward Gift Box\n{FFFFFF}/getrewardgift{F3FF02} to claim your gift!", COLOR_YELLOW, fPos[0], fPos[1], fPos[2], 10.0, .testlos = 1, .streamdistance = 50.0);
			iRewardBox = true;

			format(szMessage, sizeof szMessage, "AdmCmd: %s has placed the reward gift box.", GetPlayerNameEx(playerid));
			ABroadCast(COLOR_LIGHTRED, szMessage, 2);
			Misc_Save();
		}
	    default: {
	        new
	            szMessage[64];

	        iRewardBox = false;
	        DestroyDynamic3DTextLabel(tRewardText);
			DestroyDynamicObject(iRewardObj);

			format(szMessage, sizeof szMessage, "AdmCmd: %s has removed the reward gift box.", GetPlayerNameEx(playerid));
			ABroadCast(COLOR_LIGHTRED, szMessage, 2);
			Misc_Save();
	    }
	}
	return 1;
}

CMD:rewardplay(playerid, params[]) {
	if(PlayerInfo[playerid][pAdmin] >= 1337) switch(iRewardPlay) {
		case 0: {

			new
				szMessage[64];

			iRewardPlay = true;

			format(szMessage, sizeof szMessage, "AdmCmd: %s has enabled Reward Play.", GetPlayerNameEx(playerid));
			ABroadCast(COLOR_LIGHTRED, szMessage, 2);
			Misc_Save();
		}
		default: {

			new
				szMessage[64];

			format(szMessage, sizeof szMessage, "AdmCmd: %s has disabled Reward Play.", GetPlayerNameEx(playerid));
			ABroadCast(COLOR_LIGHTRED, szMessage, 2);

			iRewardPlay = false;
			Misc_Save();
		}
	}
	return 1;
}

CMD:getrewardgift(playerid, params[]) {
	if(iRewardBox) {
		if(IsPlayerInRangeOfDynamicObject(playerid, iRewardObj, 5.0)) {
			if(PlayerInfo[playerid][pGoldBoxTokens] >= 1) {

				--PlayerInfo[playerid][pGoldBoxTokens];

				new
					szMessage[128];

				switch(random(10)) {
					case 0..6: switch(random(7)) { // 70%
						case 0:
						{
							GivePlayerCash(playerid, 500000);
							SendClientMessageEx(playerid, COLOR_GRAD2, " Congratulations - you have won $500,000!");
							format(szMessage, sizeof(szMessage), "* %s was just gifted $500,000, enjoy!", GetPlayerNameEx(playerid));
							ProxDetector(30.0, playerid, szMessage, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
						}
						case 1:
						{
							PlayerInfo[playerid][pMats] += 20000;
							SendClientMessageEx(playerid, COLOR_GRAD2, " Congratulations - you have won 20,000 materials!");
							format(szMessage, sizeof(szMessage), "* %s was just gifted 20,000 materials, enjoy!", GetPlayerNameEx(playerid));
							ProxDetector(30.0, playerid, szMessage, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
						}
						case 2:
						{
							PlayerInfo[playerid][pExp] += 10;
							SendClientMessageEx(playerid, COLOR_GRAD2, " Congratulations - you have won 10 respect points!");
							format(szMessage, sizeof(szMessage), "* %s was just gifted 10 respect points, enjoy!", GetPlayerNameEx(playerid));
							ProxDetector(30.0, playerid, szMessage, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
						}
						case 3:
						{
							SendClientMessageEx(playerid, COLOR_GRAD2, " Congratulations - you have won one free car!");
							SendClientMessageEx(playerid, COLOR_CYAN, " 1 Car Voucher has been added to your account.");
							SendClientMessageEx(playerid, COLOR_GRAD2, " Note you may access your voucher(s) with /myvouchers");
							PlayerInfo[playerid][pVehVoucher]++;

							format(szMessage, sizeof(szMessage), "AdmCmd: %s(%d) was just gifted by the system and he won one free car", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid));
							Log("logs/gifts.log", szMessage);
							format(szMessage, sizeof(szMessage), "{AA3333}AdmWarning{FFFF00}: %s was just gifted by the system and he won one free car.", GetPlayerNameEx(playerid));
							ABroadCast(COLOR_YELLOW, szMessage, 4);
							format(szMessage, sizeof(szMessage), "* %s was just gifted one free car, enjoy!", GetPlayerNameEx(playerid));
							ProxDetector(30.0, playerid, szMessage, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
						}
						case 4:
						{
							PlayerInfo[playerid][pSVIPVoucher]++;
							SendClientMessageEx(playerid, COLOR_GRAD2, " Congratulations - you have won one month of Silver VIP!");
							SendClientMessageEx(playerid, COLOR_CYAN, " 1 Silver VIP Voucher has been added to your account.");
							SendClientMessageEx(playerid, COLOR_GRAD2, " Note you may access your voucher(s) with /myvouchers");
							format(szMessage, sizeof(szMessage), "{AA3333}AdmWarning{FFFF00}: %s has won one month of Silver VIP.", GetPlayerNameEx(playerid));
							ABroadCast(COLOR_YELLOW, szMessage, 2);
							format(szMessage, sizeof(szMessage), "* %s was just gifted one month of Silver VIP, enjoy!", GetPlayerNameEx(playerid));
							ProxDetector(30.0, playerid, szMessage, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
						}
						case 5:
						{
							PlayerInfo[playerid][pTokens] += 50;
							SendClientMessageEx(playerid, COLOR_GRAD2, " Congratulations - you have won 50 VIP tokens!");
							format(szMessage, sizeof(szMessage), "* %s was just gifted 50 VIP tokens, enjoy!", GetPlayerNameEx(playerid));
							ProxDetector(30.0, playerid, szMessage, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
						}
						default:
						{
							SendClientMessageEx(playerid, COLOR_GRAD2, " Congratulations - you have won a Free Laser Pointer!");
							format(szMessage, sizeof(szMessage), "* %s was just gifted a Free Laser Pointer, enjoy!", GetPlayerNameEx(playerid));
							ProxDetector(30.0, playerid, szMessage, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
							new icount = GetPlayerToySlots(playerid);
							for(new v = 0; v < icount; v++)
							{
								if(PlayerToyInfo[playerid][v][ptModelID] == 0)
								{
									PlayerToyInfo[playerid][v][ptModelID] = 18643;
									PlayerToyInfo[playerid][v][ptBone] = 6;
									PlayerToyInfo[playerid][v][ptPosX] = 0.0;
									PlayerToyInfo[playerid][v][ptPosY] = 0.0;
									PlayerToyInfo[playerid][v][ptPosZ] = 0.0;
									PlayerToyInfo[playerid][v][ptRotX] = 0.0;
									PlayerToyInfo[playerid][v][ptRotY] = 0.0;
									PlayerToyInfo[playerid][v][ptRotZ] = 0.0;
									PlayerToyInfo[playerid][v][ptScaleX] = 1.0;
									PlayerToyInfo[playerid][v][ptScaleY] = 1.0;
									PlayerToyInfo[playerid][v][ptScaleZ] = 1.0;
									PlayerToyInfo[playerid][v][ptTradable] = 1;
									
									g_mysql_NewToy(playerid, v);
									return 1;
								}
							}
							
							for(new i = 0; i < MAX_PLAYERTOYS; i++)
							{
								if(PlayerToyInfo[playerid][i][ptModelID] == 0)
								{
									PlayerToyInfo[playerid][i][ptModelID] = 18643;
									PlayerToyInfo[playerid][i][ptBone] = 6;
									PlayerToyInfo[playerid][i][ptPosX] = 0.0;
									PlayerToyInfo[playerid][i][ptPosY] = 0.0;
									PlayerToyInfo[playerid][i][ptPosZ] = 0.0;
									PlayerToyInfo[playerid][i][ptRotX] = 0.0;
									PlayerToyInfo[playerid][i][ptRotY] = 0.0;
									PlayerToyInfo[playerid][i][ptRotZ] = 0.0;
									PlayerToyInfo[playerid][i][ptScaleX] = 1.0;
									PlayerToyInfo[playerid][i][ptScaleY] = 1.0;
									PlayerToyInfo[playerid][i][ptScaleZ] = 1.0;
									PlayerToyInfo[playerid][i][ptTradable] = 1;
									PlayerToyInfo[playerid][i][ptSpecial] = 1;
									
									SendClientMessageEx(playerid, COLOR_GRAD1, "Due to you not having any available slots, we've temporarily gave you an additional slot to use/sell/trade your laser.");
									SendClientMessageEx(playerid, COLOR_RED, "Note: Please take note that after selling the laser, the temporarily additional toy slot will be removed.");
									break;
								}	
							}
						}
					}
					case 7, 8: switch(random(3)) {// 20%
						case 0:
						{

							format(szMessage, sizeof(szMessage), "AdmCmd: %s(%d) was just gifted by the system and he won a free house", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid));
							Log("logs/gifts.log", szMessage);
							format(szMessage, sizeof(szMessage), "{AA3333}AdmWarning{FFFF00}: %s was just gifted by the system and he won a free house.", GetPlayerNameEx(playerid));
							ABroadCast(COLOR_YELLOW, szMessage, 2);
							SendClientMessageEx(playerid, COLOR_GRAD2, " Congratulations - you have won a free house!");
							SendClientMessageEx(playerid, COLOR_GRAD2, " Note: This rare reward may take up to 48 hours to be rewarded.");
							AddFlag(playerid, INVALID_PLAYER_ID, "Free House (Gift)");
							format(szMessage, sizeof(szMessage), "* %s was just gifted a free house, enjoy!", GetPlayerNameEx(playerid));
							ProxDetector(30.0, playerid, szMessage, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
						}
						case 1:
						{
							PlayerInfo[playerid][pTokens] += 150;
							SendClientMessageEx(playerid, COLOR_GRAD2, " Congratulations - you have won 150 VIP tokens!");
							format(szMessage, sizeof(szMessage), "* %s was just gifted 150 VIP tokens, enjoy!", GetPlayerNameEx(playerid));
							ProxDetector(30.0, playerid, szMessage, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
						}
						default:
						{

							format(szMessage, sizeof(szMessage), "AdmCmd: %s(%d) was just gifted by the system and he won a set of neons", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid));
							Log("logs/gifts.log", szMessage);
							format(szMessage, sizeof(szMessage), "{AA3333}AdmWarning{FFFF00}: %s was just gifted by the system and he won a free set of neons.", GetPlayerNameEx(playerid));
							ABroadCast(COLOR_YELLOW, szMessage, 2);
							SendClientMessageEx(playerid, COLOR_GRAD2, " Congratulations - you have won a free set of neons!");
							SendClientMessageEx(playerid, COLOR_GRAD2, " Note: This rare reward may take up to 48 hours to be rewarded.");
							AddFlag(playerid, INVALID_PLAYER_ID, "Free set of neons (Gift)");
							format(szMessage, sizeof(szMessage), "* %s was just gifted a free set of neons, enjoy!", GetPlayerNameEx(playerid));
							ProxDetector(30.0, playerid, szMessage, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
						}

					}
					default:
					{ // 10%
						new gift = Random(1, 6);
						if(gift >= 1 && gift <= 3)
						{
							if(RimMod > 0) // Rim Kit
							{
								PlayerInfo[playerid][pRimMod]++;
								RimMod--;
								g_mysql_SaveMOTD();

								format(szMessage, sizeof(szMessage), "AdmWarning: %s(%d) was just gifted by the system and he won a rim modification kit. (%d left)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), RimMod);

								Log("logs/gifts.log", szMessage);
								format(szMessage, sizeof(szMessage), "* %s was just gifted a rim modification kit, enjoy! Only %d kits left.", GetPlayerNameEx(playerid), RimMod);
								ProxDetector(30.0, playerid, szMessage, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
							}
							else
							{
								gift = 5;
							}
						}
						else if(gift == 4) //
						{
							if(CarVoucher > 0)
							{
								PlayerInfo[playerid][pCarVoucher]++;
								CarVoucher--;
								g_mysql_SaveMOTD();

								format(szMessage, sizeof(szMessage), "AdmWarning: %s(%d) was just gifted by the system and he won a restricted car voucher. (%d left)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), CarVoucher);

								Log("logs/gifts.log", szMessage);
								format(szMessage, sizeof(szMessage), "* %s was just gifted a restricted car voucher, enjoy! Only %d car vouchers left.", GetPlayerNameEx(playerid), CarVoucher);
								ProxDetector(30.0, playerid, szMessage, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
								SendClientMessageEx(playerid, COLOR_CYAN, " 1 Restricted Car Voucher has been added to your account.");
								SendClientMessageEx(playerid, COLOR_GRAD2, " Note you may access your voucher(s) with /myvouchers");
							}
							else gift = 5;
						}
						if(gift == 5)
						{
							PlayerInfo[playerid][pGVIPVoucher]++;
							SendClientMessageEx(playerid, COLOR_GRAD2, " Congratulations - you have won one month of Gold VIP!");
							SendClientMessageEx(playerid, COLOR_CYAN, " 1 Gold VIP Voucher has been added to your account.");
							SendClientMessageEx(playerid, COLOR_GRAD2, " Note you may access your voucher(s) with /myvouchers");
							format(szMessage, sizeof(szMessage), "{AA3333}AdmWarning{FFFF00}: %s has won one month of Gold VIP.", GetPlayerNameEx(playerid));
							ABroadCast(COLOR_YELLOW, szMessage, 2);
							format(szMessage, sizeof(szMessage), "* %s was just gifted one month of Gold VIP, enjoy!", GetPlayerNameEx(playerid));
							ProxDetector(30.0, playerid, szMessage, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
						}
					}
				}
			}
			else SendClientMessage(playerid, COLOR_GREY, "You have no Gold Box Gift tokens.");
		}
		else SendClientMessage(playerid, COLOR_GREY, "You're not near the Gold Box.");
	}
	else SendClientMessage(playerid, COLOR_GREY, "Reward Playing is currently not in effect.");
	return 1;
}