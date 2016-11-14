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

stock ShowVouchers(playerid, targetid)
{
	if(IsPlayerConnected(targetid))
	{
		new szDialog[1024], szTitle[MAX_PLAYER_NAME+9];
		SetPVarInt(playerid, "WhoIsThis", targetid);
		
		format(szTitle, sizeof(szTitle), "%s Vouchers", GetPlayerNameEx(targetid));
		format(szDialog, sizeof(szDialog), "Car Voucher(s):\t\t\t{18F0F0}%d\nSilver VIP Voucher(s):\t\t{18F0F0}%d\nGold VIP Voucher(s):\t\t{18F0F0}%d\n1 month PVIP Voucher(s):\t{18F0F0}%d\nRestricted Car Voucher(s):\t{18F0F0}%d\nGift Reset Voucher(s):\t\t{18F0F0}%d\n" \
		"Priority Advert Voucher(s):\t{18F0F0}%d\n7 Days SVIP Voucher(s): \t{18F0F0}%d\n7 Days GVIP Voucher(s):\t{18F0F0}%d\n",
		PlayerInfo[targetid][pVehVoucher], PlayerInfo[targetid][pSVIPVoucher], PlayerInfo[targetid][pGVIPVoucher], PlayerInfo[targetid][pPVIPVoucher], PlayerInfo[targetid][pCarVoucher], PlayerInfo[targetid][pGiftVoucher], PlayerInfo[targetid][pAdvertVoucher], PlayerInfo[targetid][pSVIPExVoucher], PlayerInfo[targetid][pGVIPExVoucher]);
		ShowPlayerDialogEx(playerid, DIALOG_VOUCHER, DIALOG_STYLE_LIST, szTitle, szDialog, "Select", "Close");
	}
	return 1;
}	

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	szMiscArray[0] = 0;
	switch(dialogid)
	{
		case DIALOG_VOUCHER:
		{
			if(response)
			{
				new playeridd = GetPVarInt(playerid, "WhoIsThis");
				switch(listitem)
				{

					case 0: // Car Voucher
					{
						if(PlayerInfo[playerid][pAdmin] >= 4 && PlayerInfo[playerid][pTogReports] == 0 || PlayerInfo[playerid][pTogReports] == 0 && PlayerInfo[playerid][pASM] >= 1)
						{
							SetPVarInt(playerid, "voucherdialog", 1);
							return ShowPlayerDialogEx(playerid, DIALOG_VOUCHERADMIN, DIALOG_STYLE_INPUT, "Voucher System", "Please enter how many would you like to give to this player.", "Enter", "Cancel");
						}
						else if(PlayerInfo[playeridd][pVehVoucher] > 0 && (playerid == playeridd))
						{
							SetPVarInt(playerid, "voucherdialog", 1);
							return ShowPlayerDialogEx(playerid, DIALOG_VOUCHER2, DIALOG_STYLE_MSGBOX, "Voucher System", "Are you sure you want to use your car voucher?", "Yes", "No");
						}
						else if(PlayerInfo[playeridd][pVehVoucher] < 1)
						{
							if(PlayerInfo[playerid][pAdmin] >= 4 && PlayerInfo[playerid][pTogReports] == 0 || PlayerInfo[playerid][pTogReports] == 0 && PlayerInfo[playerid][pASM] >= 1)
							{
								SetPVarInt(playerid, "voucherdialog", 1);
								return ShowPlayerDialogEx(playerid, DIALOG_VOUCHERADMIN, DIALOG_STYLE_INPUT, "Voucher System", "Please enter how many would you like to give to this player.", "Enter", "Cancel");
							}
							else 
							{
								new szDialog[128];
								format(szDialog, sizeof(szDialog), "%s does not have any car vouchers.", GetPlayerNameEx(GetPVarInt(playerid, "WhoIsThis")));
								ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Voucher System", szDialog, "Close", "");
								DeletePVar(playerid, "WhoIsThis");
							}	
						}	
					}
					case 1: // SVIP Voucher
					{
						if(PlayerInfo[playerid][pAdmin] >= 4 && PlayerInfo[playerid][pTogReports] == 0 || PlayerInfo[playerid][pTogReports] == 0 && PlayerInfo[playerid][pASM] >= 1)
						{
							SetPVarInt(playerid, "voucherdialog", 2);
							return ShowPlayerDialogEx(playerid, DIALOG_VOUCHERADMIN, DIALOG_STYLE_INPUT, "Voucher System", "Please enter how many would you like to give to this player.", "Enter", "Cancel");
						}
						else if(PlayerInfo[playeridd][pSVIPVoucher] > 0 && (playerid == playeridd))
						{
							SetPVarInt(playerid, "voucherdialog", 2);
							return ShowPlayerDialogEx(playerid, DIALOG_VOUCHER2, DIALOG_STYLE_MSGBOX, "Voucher System", "Are you sure you want to use your Silver VIP voucher?", "Yes", "No");
						}
						else if(PlayerInfo[playeridd][pSVIPVoucher] < 1)
						{
							if(PlayerInfo[playerid][pAdmin] >= 4 && PlayerInfo[playerid][pTogReports] == 0 || PlayerInfo[playerid][pTogReports] == 0 && PlayerInfo[playerid][pASM] >= 1)
							{
								SetPVarInt(playerid, "voucherdialog", 2);
								return ShowPlayerDialogEx(playerid, DIALOG_VOUCHERADMIN, DIALOG_STYLE_INPUT, "Voucher System", "Please enter how many would you like to give to this player.", "Enter", "Cancel");
							}
							else 
							{
								new szDialog[128];
								format(szDialog, sizeof(szDialog), "%s does not have any Silver VIP vouchers.", GetPlayerNameEx(GetPVarInt(playerid, "WhoIsThis")));
								ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Voucher System", szDialog, "Close", "");
								DeletePVar(playerid, "WhoIsThis");
							}	
						}	
					}
					case 2: // GVIP Voucher
					{
						if(PlayerInfo[playerid][pAdmin] >= 4 && PlayerInfo[playerid][pTogReports] == 0 || PlayerInfo[playerid][pTogReports] == 0 && PlayerInfo[playerid][pASM] >= 1) 
						{
							SetPVarInt(playerid, "voucherdialog", 3);
							return ShowPlayerDialogEx(playerid, DIALOG_VOUCHERADMIN, DIALOG_STYLE_INPUT, "Voucher System", "Please enter how many would you like to give to this player.", "Enter", "Cancel");
						}
						else if(PlayerInfo[playeridd][pGVIPVoucher] > 0 && (playerid == playeridd))
						{
							SetPVarInt(playerid, "voucherdialog", 3);
							return ShowPlayerDialogEx(playerid, DIALOG_VOUCHER2, DIALOG_STYLE_MSGBOX, "Voucher System", "Are you sure you want to use your Gold VIP voucher?", "Yes", "No");
						}
						else if(PlayerInfo[playeridd][pGVIPVoucher] < 1)
						{
							if(PlayerInfo[playerid][pAdmin] >= 4 && PlayerInfo[playerid][pTogReports] == 0 || PlayerInfo[playerid][pTogReports] == 0 && PlayerInfo[playerid][pASM] >= 1)
							{
								SetPVarInt(playerid, "voucherdialog", 3);
								return ShowPlayerDialogEx(playerid, DIALOG_VOUCHERADMIN, DIALOG_STYLE_INPUT, "Voucher System", "Please enter how many would you like to give to this player.", "Enter", "Cancel");
							}
							else 
							{
								new szDialog[128];
								format(szDialog, sizeof(szDialog), "%s does not have any Gold VIP vouchers.", GetPlayerNameEx(playeridd));
								ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Voucher System", szDialog, "Close", "");
								DeletePVar(playerid, "WhoIsThis");
							}	
						}	
					}
					case 3: // PVIP Voucher
					{
						if(playerid != playeridd) return 1;
						if(PlayerInfo[playeridd][pPVIPVoucher] < 1) 
						{
							new szDialog[128];
							format(szDialog, sizeof(szDialog), "%s does not have any 1 month PVIP Vouchers.", GetPlayerNameEx(playeridd));
							DeletePVar(playerid, "WhoIsThis");
							return ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Voucher System", szDialog, "Close", "");
						}
						
						if(PlayerInfo[playerid][pDonateRank] >= 4) return SendClientMessageEx(playerid, COLOR_GRAD1, "You already have Platinum VIP+, you may sell this voucher with /sellvoucher."), DeletePVar(playerid, "WhoIsThis");
						
						ShowPlayerDialogEx(playerid, DIALOG_PVIPVOUCHER, DIALOG_STYLE_MSGBOX, "1 month PVIP Voucher", "You will be made Platinum VIP after use of this voucher.", "Confirm", "Cancel");	
					}
					case 4: // Restricted Car Voucher
					{
						if(playerid != playeridd) return 1;
						
						if(ShopClosed == 1) return SendClientMessageEx(playerid, COLOR_GREY, "The shop is currently closed.");
						
						if(PlayerInfo[playeridd][pCarVoucher] < 1) 
						{
							new szDialog[128];
							format(szDialog, sizeof(szDialog), "%s does not have any Restriced Car vouchers.", GetPlayerNameEx(playeridd));
							DeletePVar(playerid, "WhoIsThis");
							return ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Voucher System", szDialog, "Close", "");
						}
						if(!IsPlayerInDynamicArea(playerid, NGGShop) && GetPlayerVirtualWorld(playerid) != 1) return SendClientMessageEx(playerid, COLOR_GRAD2, "You must be at NGG's shop to redeem this voucher.");
						ShowModelSelectionMenu(playerid, CarList3, "Car Shop");
					}
					case 5: // Gift Reset Voucher
					{
						if((PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pHR] >= 1) && PlayerInfo[playerid][pTogReports] == 0)
						{
							SetPVarInt(playerid, "voucherdialog", 4);
							return ShowPlayerDialogEx(playerid, DIALOG_VOUCHERADMIN, DIALOG_STYLE_INPUT, "Voucher System", "Please enter how many would you like to give to this player.", "Enter", "Cancel");
						}
						else if(PlayerInfo[playeridd][pGiftVoucher] > 0 && (playerid == playeridd))
						{
							SetPVarInt(playerid, "voucherdialog", 4);
							return ShowPlayerDialogEx(playerid, DIALOG_VOUCHER2, DIALOG_STYLE_MSGBOX, "Voucher System", "Are you sure you want to use your Gift Reset Voucher?", "Yes", "No");
						}
						else if(PlayerInfo[playeridd][pGiftVoucher] < 1)
						{
							if((PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pHR] >= 1) && PlayerInfo[playerid][pTogReports] == 0)
							{
								SetPVarInt(playerid, "voucherdialog", 4);
								return ShowPlayerDialogEx(playerid, DIALOG_VOUCHERADMIN, DIALOG_STYLE_INPUT, "Voucher System", "Please enter how many would you like to give to this player.", "Enter", "Cancel");
							}
							else 
							{
								new szDialog[128];
								format(szDialog, sizeof(szDialog), "%s does not have any Gift Reset vouchers.", GetPlayerNameEx(playeridd));
								ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Voucher System", szDialog, "Close", "");
								DeletePVar(playerid, "WhoIsThis");
							}	
						}	
					}
					case 6: // Priority Advertisement Voucher
					{
						if(PlayerInfo[playerid][pAdmin] >= 4 && PlayerInfo[playerid][pTogReports] == 0 || PlayerInfo[playerid][pTogReports] == 0 && PlayerInfo[playerid][pASM] >= 1)
						{
							SetPVarInt(playerid, "voucherdialog", 5);
							return ShowPlayerDialogEx(playerid, DIALOG_VOUCHERADMIN, DIALOG_STYLE_INPUT, "Voucher System", "Please enter how many would you like to give to this player.", "Enter", "Cancel");
						}
						else if(PlayerInfo[playeridd][pAdvertVoucher] > 0 && (playerid == playeridd))
						{
							return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot use your voucher through here, you will be prompt a dialog while in the advertisement menu to use this voucher.");
						}
						else if(PlayerInfo[playeridd][pAdvertVoucher] < 1)
						{
							if(PlayerInfo[playerid][pAdmin] >= 4 && PlayerInfo[playerid][pTogReports] == 0 || PlayerInfo[playerid][pTogReports] == 0 && PlayerInfo[playerid][pASM] >= 1)
							{
								SetPVarInt(playerid, "voucherdialog", 5);
								return ShowPlayerDialogEx(playerid, DIALOG_VOUCHERADMIN, DIALOG_STYLE_INPUT, "Voucher System", "Please enter how many would you like to give to this player.", "Enter", "Cancel");
							}
							else 
							{
								new szDialog[128];
								format(szDialog, sizeof(szDialog), "%s does not have any Priority Advertisement vouchers.", GetPlayerNameEx(playeridd));
								ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Voucher System", szDialog, "Close", "");
								DeletePVar(playerid, "WhoIsThis");
							}	
						}	
					}
					case 7: // 7 Days Silver VIP
					{
						if(PlayerInfo[playerid][pAdmin] >= 4 && PlayerInfo[playerid][pTogReports] == 0 || PlayerInfo[playerid][pTogReports] == 0 && PlayerInfo[playerid][pASM] >= 1)
						{
							SetPVarInt(playerid, "voucherdialog", 6);
							return ShowPlayerDialogEx(playerid, DIALOG_VOUCHERADMIN, DIALOG_STYLE_INPUT, "Voucher System", "Please enter how many would you like to give to this player.", "Enter", "Cancel");
						}
						else if(PlayerInfo[playeridd][pSVIPExVoucher] > 0 && (playerid == playeridd))
						{
							SetPVarInt(playerid, "voucherdialog", 5);
							return ShowPlayerDialogEx(playerid, DIALOG_VOUCHER2, DIALOG_STYLE_MSGBOX, "Voucher System", "Are you sure you want to use your 7 Days Silver VIP voucher?", "Yes", "No");
						}
						else if(PlayerInfo[playeridd][pSVIPExVoucher] < 1)
						{
							if(PlayerInfo[playerid][pAdmin] >= 4 && PlayerInfo[playerid][pTogReports] == 0 || PlayerInfo[playerid][pTogReports] == 0 && PlayerInfo[playerid][pASM] >= 1)
							{
								SetPVarInt(playerid, "voucherdialog", 6);
								return ShowPlayerDialogEx(playerid, DIALOG_VOUCHERADMIN, DIALOG_STYLE_INPUT, "Voucher System", "Please enter how many would you like to give to this player.", "Enter", "Cancel");
							}
							else 
							{
								new szDialog[128];
								format(szDialog, sizeof(szDialog), "%s does not have any 7 Days Silver VIP vouchers.", GetPlayerNameEx(playeridd));
								ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Voucher System", szDialog, "Close", "");
								DeletePVar(playerid, "WhoIsThis");
							}	
						}	
					}
					case 8: // 7 Days Gold VIP
					{
						if(PlayerInfo[playerid][pAdmin] >= 4 && PlayerInfo[playerid][pTogReports] == 0 || PlayerInfo[playerid][pTogReports] == 0 && PlayerInfo[playerid][pASM] >= 1)
						{
							SetPVarInt(playerid, "voucherdialog", 7);
							return ShowPlayerDialogEx(playerid, DIALOG_VOUCHERADMIN, DIALOG_STYLE_INPUT, "Voucher System", "Please enter how many would you like to give to this player.", "Enter", "Cancel");
						}
						else if(PlayerInfo[playeridd][pGVIPExVoucher] > 0 && (playerid == playeridd))
						{
							SetPVarInt(playerid, "voucherdialog", 6);
							return ShowPlayerDialogEx(playerid, DIALOG_VOUCHER2, DIALOG_STYLE_MSGBOX, "Voucher System", "Are you sure you want to use your 7 Days Gold VIP voucher?", "Yes", "No");
						}
						else if(PlayerInfo[playeridd][pGVIPExVoucher] < 1)
						{
							if(PlayerInfo[playerid][pAdmin] >= 4 && PlayerInfo[playerid][pTogReports] == 0 || PlayerInfo[playerid][pTogReports] == 0 && PlayerInfo[playerid][pASM] >= 1)
							{
								SetPVarInt(playerid, "voucherdialog", 7);
								return ShowPlayerDialogEx(playerid, DIALOG_VOUCHERADMIN, DIALOG_STYLE_INPUT, "Voucher System", "Please enter how many would you like to give to this player.", "Enter", "Cancel");
							}
							else 
							{
								new szDialog[128];
								format(szDialog, sizeof(szDialog), "%s does not have any 7 Days Gold VIP vouchers.", GetPlayerNameEx(playeridd));
								ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Voucher System", szDialog, "Close", "");
								DeletePVar(playerid, "WhoIsThis");
							}	
						}	
					}
				}
			} 
		}		
		case DIALOG_VOUCHERADMIN:
		{
			if(response)
			{
				if(!isnull(inputtext))
				{
					if(IsNumeric(inputtext))
					{
						if(!IsPlayerConnected(GetPVarInt(playerid, "WhoIsThis"))) return SendClientMessageEx(playerid, COLOR_GRAD1, "This player has disconnected from the server.");
						if(strval(inputtext) < 1) return DeletePVar(playerid, "voucherdialog"), DeletePVar(playerid, "WhoIsThis"), SendClientMessageEx(playerid, COLOR_GRAD1, "You can't give less than 1 voucher.");
						if(GetPVarInt(playerid,	"voucherdialog") == 1) // Car Voucher
						{
							new targetid = GetPVarInt(playerid, "WhoIsThis"), 
								amount = strval(inputtext),
								szString[128];
								
							PlayerInfo[targetid][pVehVoucher] += amount;
							format(szString, sizeof(szString), "You have given %s %d car voucher(s).", GetPlayerNameEx(targetid), amount);
							SendClientMessageEx(playerid, COLOR_CYAN, szString);
							format(szString, sizeof(szString), "You have been given %d car voucher(s) by %s.", amount, GetPlayerNameEx(playerid));
							SendClientMessageEx(targetid, COLOR_CYAN, szString);
							format(szString, sizeof(szString), "%s has given %s(%d) %d car voucher(s).", GetPlayerNameEx(playerid), GetPlayerNameEx(targetid), GetPlayerSQLId(targetid), amount);
							Log("logs/vouchers.log", szString);
						}
						if(GetPVarInt(playerid,	"voucherdialog") == 2) // SVIP Voucher
						{
							new targetid = GetPVarInt(playerid, "WhoIsThis"), 
								amount = strval(inputtext),
								szString[128];
								
							PlayerInfo[targetid][pSVIPVoucher] += amount;
							format(szString, sizeof(szString), "You have given %s %d Silver VIP voucher(s).", GetPlayerNameEx(targetid), amount);
							SendClientMessageEx(playerid, COLOR_CYAN, szString);
							format(szString, sizeof(szString), "You have been given %d Silver VIP voucher(s) by %s.", amount, GetPlayerNameEx(playerid));
							SendClientMessageEx(targetid, COLOR_CYAN, szString);
							format(szString, sizeof(szString), "%s has given %s(%d) %d Silver VIP voucher(s).", GetPlayerNameEx(playerid), GetPlayerNameEx(targetid), GetPlayerSQLId(targetid), amount);
							Log("logs/vouchers.log", szString);
						}
						if(GetPVarInt(playerid,	"voucherdialog") == 3) // GVIP Voucher
						{
							new targetid = GetPVarInt(playerid, "WhoIsThis"), 
								amount = strval(inputtext),
								szString[128];
								
							PlayerInfo[targetid][pGVIPVoucher] += amount;
							format(szString, sizeof(szString), "You have given %s %d Gold VIP voucher(s).", GetPlayerNameEx(targetid), amount);
							SendClientMessageEx(playerid, COLOR_CYAN, szString);
							format(szString, sizeof(szString), "You have been given %d Gold VIP voucher(s) by %s.", amount, GetPlayerNameEx(playerid));
							SendClientMessageEx(targetid, COLOR_CYAN, szString);
							format(szString, sizeof(szString), "%s has given %s(%d) %d Gold VIP voucher(s).", GetPlayerNameEx(playerid), GetPlayerNameEx(targetid), GetPlayerSQLId(targetid), amount);
							Log("logs/vouchers.log", szString);
						}
						if(GetPVarInt(playerid, "voucherdialog") == 4) // Gift Reset Voucher
						{
							new targetid = GetPVarInt(playerid, "WhoIsThis"),
								amount = strval(inputtext),
								szString[128];
							PlayerInfo[targetid][pGiftVoucher] += amount;
							format(szString, sizeof(szString), "You have given %s %d Gift Reset voucher(s).", GetPlayerNameEx(targetid), amount);
							SendClientMessageEx(playerid, COLOR_CYAN, szString);
							format(szString, sizeof(szString), "You have been given %d Gift Reset voucher(s) by %s.", amount, GetPlayerNameEx(playerid));
							SendClientMessageEx(targetid, COLOR_CYAN, szString);
							format(szString, sizeof(szString), "[Admin] %s(IP:%s) has given %s(%d)(IP:%s) %d free gift reset voucher(s).", GetPlayerNameEx(playerid), GetPlayerIpEx(playerid), GetPlayerNameEx(targetid), GetPlayerSQLId(targetid), GetPlayerIpEx(targetid), amount);
							Log("logs/adminrewards.log", szString);	
						}
						if(GetPVarInt(playerid, "voucherdialog") == 5) // Priority Advertisement Voucher
						{
							new targetid = GetPVarInt(playerid, "WhoIsThis"),
								amount = strval(inputtext),
								szString[128];
							PlayerInfo[targetid][pAdvertVoucher] += amount;
							format(szString, sizeof(szString), "You have given %s %d Priority Advertisement voucher(s).", GetPlayerNameEx(targetid), amount);
							SendClientMessageEx(playerid, COLOR_CYAN, szString);
							format(szString, sizeof(szString), "You have been given %d Priority Advertisement voucher(s) by %s.", amount, GetPlayerNameEx(playerid));
							SendClientMessageEx(targetid, COLOR_CYAN, szString);
							format(szString, sizeof(szString), "[Admin] %s(IP:%s) has given %s(%d)(IP:%s) %d free Priority Advertisement voucher(s).", GetPlayerNameEx(playerid), GetPlayerIpEx(playerid), GetPlayerNameEx(targetid), GetPlayerSQLId(targetid), GetPlayerIpEx(targetid), amount);
							Log("logs/vouchers.log", szString);	
						}
						if(GetPVarInt(playerid, "voucherdialog") == 6) // 7 Days Silver VIP Voucher
						{
							new targetid = GetPVarInt(playerid, "WhoIsThis"),
								amount = strval(inputtext),
								szString[128];
							PlayerInfo[targetid][pSVIPExVoucher] += amount;
							format(szString, sizeof(szString), "You have given %s %d 7 Days Silver VIP voucher(s).", GetPlayerNameEx(targetid), amount);
							SendClientMessageEx(playerid, COLOR_CYAN, szString);
							format(szString, sizeof(szString), "You have been given %d 7 Days Silver VIP voucher(s) by %s.", amount, GetPlayerNameEx(playerid));
							SendClientMessageEx(targetid, COLOR_CYAN, szString);
							format(szString, sizeof(szString), "[Admin] %s(IP:%s) has given %s(%d)(IP:%s) %d free 7 Days Silver VIP voucher(s).", GetPlayerNameEx(playerid), GetPlayerIpEx(playerid), GetPlayerNameEx(targetid), GetPlayerSQLId(targetid), GetPlayerIpEx(targetid), amount);
							Log("logs/vouchers.log", szString);	
						}
						if(GetPVarInt(playerid, "voucherdialog") == 7) // 7 Days Gold VIP Voucher
						{
							new targetid = GetPVarInt(playerid, "WhoIsThis"),
								amount = strval(inputtext),
								szString[128];
							PlayerInfo[targetid][pGVIPExVoucher] += amount;
							format(szString, sizeof(szString), "You have given %s %d 7 Days Gold VIP voucher(s).", GetPlayerNameEx(targetid), amount);
							SendClientMessageEx(playerid, COLOR_CYAN, szString);
							format(szString, sizeof(szString), "You have been given %d 7 Days Gold VIP voucher(s) by %s.", amount, GetPlayerNameEx(playerid));
							SendClientMessageEx(targetid, COLOR_CYAN, szString);
							format(szString, sizeof(szString), "[Admin] %s(IP:%s) has given %s(%d)(IP:%s) %d free 7 Days Gold VIP voucher(s).", GetPlayerNameEx(playerid), GetPlayerIpEx(playerid), GetPlayerNameEx(targetid), GetPlayerSQLId(targetid), GetPlayerIpEx(targetid), amount);
							Log("logs/vouchers.log", szString);	
						}
					}
					else ShowPlayerDialogEx(playerid, DIALOG_VOUCHERADMIN, DIALOG_STYLE_INPUT, "Voucher System - {FF0000}That's not a number", "Please enter how many would you like to give to this player.", "Enter", "Cancel");
				}	
				else ShowPlayerDialogEx(playerid, DIALOG_VOUCHERADMIN, DIALOG_STYLE_INPUT, "Voucher System ", "Please enter how many would you like to give to this player.", "Enter", "Cancel");	
			}
			DeletePVar(playerid, "voucherdialog");
			DeletePVar(playerid, "WhoIsThis");
		}										
		case DIALOG_VOUCHER2:
		{
			if(response) // Clicked "Use"
			{	
				if(PlayerInfo[playerid][pJailTime] > 0)
				{
					DeletePVar(playerid, "voucherdialog");
					DeletePVar(playerid, "WhoIsThis");
					return SendClientMessageEx(playerid, COLOR_GRAD2, "You cannot use this command while being in jail/prison.");
				}
				if(GetPVarInt(playerid, "voucherdialog") == 1) // Car Voucher
				{
					if(GetPlayerInterior(playerid) != 0 || !IsPlayerInDynamicArea(playerid, NGGShop)) 
					{
						DeletePVar(playerid, "voucherdialog");
						DeletePVar(playerid, "WhoIsThis");
						if(GetPlayerInterior(playerid) != 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "You cannot use this while being inside an interior.");
						if(!IsPlayerInDynamicArea(playerid, NGGShop) && GetPlayerVirtualWorld(playerid) != 1) return SendClientMessageEx(playerid, COLOR_GRAD2, "You must be at NGG's shop to redeem this voucher.");
					}
					else
					{
						return ShowModelSelectionMenu(playerid, CarList2, "Car Voucher Selection");
					}
				}
				if(GetPVarInt(playerid, "voucherdialog") == 2) // SVIP Voucher
				{
					if(PlayerInfo[playerid][pDonateRank] >= 2)
					{
						DeletePVar(playerid, "voucherdialog");
						DeletePVar(playerid, "WhoIsThis");
						return SendClientMessageEx(playerid, COLOR_GRAD2, "Your VIP Level is already set to Silver+");
					}
					if(PlayerInfo[playerid][pSVIPVoucher] <= 0) return DeletePVar(playerid, "voucherdialog"), DeletePVar(playerid, "WhoIsThis"), SendClientMessageEx(playerid, COLOR_GREY, "You don't have a SVIP Voucher.");
					PlayerInfo[playerid][pSVIPVoucher]--;
					PlayerInfo[playerid][pDonateRank] = 2;
					PlayerInfo[playerid][pTempVIP] = 0;
					PlayerInfo[playerid][pBuddyInvited] = 0;
					PlayerInfo[playerid][pVIPSellable] = 0;
					PlayerInfo[playerid][pVIPExpire] = gettime()+2592000*1;
					if(PlayerInfo[playerid][pVIPM] == 0)
					{
						PlayerInfo[playerid][pVIPM] = VIPM;
						VIPM++;
					}
					LoadPlayerDisabledVehicles(playerid);
					new playerip[32];
					GetPlayerIp(playerid, playerip, sizeof(playerip));
					format(szMiscArray, sizeof(szMiscArray), "AdmCmd: Server (Voucher System) has set %s's VIP level to Silver (2).", GetPlayerNameEx(playerid));
					ABroadCast(COLOR_LIGHTRED, szMiscArray, 4);
					format(szMiscArray, sizeof(szMiscArray), "You have successfully used one of your Silver VIP voucher(s), you have %d Silver VIP voucher(s) left.", PlayerInfo[playerid][pSVIPVoucher]);
					SendClientMessageEx(playerid, COLOR_CYAN, szMiscArray);
					SendClientMessageEx(playerid, COLOR_GRAD2, "** Note: Your Silver VIP will expire in 30 days.");

					format(szMiscArray, sizeof(szMiscArray), "AdmCmd: Server (Voucher System) has set %s's(%d) (IP:%s) VIP level to Silver (2) (Voucher Left: %d)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), playerip, PlayerInfo[playerid][pSVIPVoucher]);
					Log("logs/vouchers.log", szMiscArray);
					OnPlayerStatsUpdate(playerid);
				}
				if(GetPVarInt(playerid, "voucherdialog") == 3) // GVIP Voucher - Not renewable
				{
					if(PlayerInfo[playerid][pDonateRank] >= 3)
					{
						DeletePVar(playerid, "voucherdialog");
						DeletePVar(playerid, "WhoIsThis");
						return SendClientMessageEx(playerid, COLOR_GRAD2, "Your VIP Level is already set to Gold+");
					}
					if(PlayerInfo[playerid][pGVIPVoucher] <= 0) return DeletePVar(playerid, "voucherdialog"), DeletePVar(playerid, "WhoIsThis"), SendClientMessageEx(playerid, COLOR_GREY, "You don't have a GVIP Voucher.");
					PlayerInfo[playerid][pGVIPVoucher]--;
					PlayerInfo[playerid][pDonateRank] = 3;
					PlayerInfo[playerid][pTempVIP] = 0;
					PlayerInfo[playerid][pBuddyInvited] = 0;
					PlayerInfo[playerid][pVIPSellable] = 0;
					PlayerInfo[playerid][pVIPExpire] = gettime()+2592000*1;
					if(PlayerInfo[playerid][pVIPM] == 0)
					{
						PlayerInfo[playerid][pVIPM] = VIPM;
						VIPM++;
					}
					LoadPlayerDisabledVehicles(playerid);
					new playerip[32];
					GetPlayerIp(playerid, playerip, sizeof(playerip));
					format(szMiscArray, sizeof(szMiscArray), "AdmCmd: Server (Voucher System) has set %s's VIP level to Gold (3).", GetPlayerNameEx(playerid));
					ABroadCast(COLOR_LIGHTRED, szMiscArray, 4);
					format(szMiscArray, sizeof(szMiscArray), "You have successfully used one of your Gold VIP voucher(s), you have %d Gold VIP voucher(s) left.", PlayerInfo[playerid][pGVIPVoucher]);
					SendClientMessageEx(playerid, COLOR_CYAN, szMiscArray);
					SendClientMessageEx(playerid, COLOR_GRAD2, "** Note: Your Gold VIP will expire in 30 days.");

					format(szMiscArray, sizeof(szMiscArray), "AdmCmd: Server (Voucher System) has set %s's(%d) (IP:%s) VIP level to Gold (3) (Voucher Left: %d)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), playerip, PlayerInfo[playerid][pGVIPVoucher]);
					Log("logs/vouchers.log", szMiscArray);
					OnPlayerStatsUpdate(playerid);
				}
				if(GetPVarInt(playerid, "voucherdialog") == 4) // Gift Reset Voucher
				{
					if(PlayerInfo[playerid][pGiftTime] <= 0)
					{
						DeletePVar(playerid, "voucherdialog");
						DeletePVar(playerid, "WhoIsThis");
						return SendClientMessageEx(playerid, COLOR_GRAD2, "You're already able to to receive a gift from the giftbox or the safe.");
					}
					if(PlayerInfo[playerid][pGiftVoucher] <= 0) return DeletePVar(playerid, "voucherdialog"), DeletePVar(playerid, "WhoIsThis"), SendClientMessageEx(playerid, COLOR_GREY, "You don't have a Gift Reset Voucher.");
					PlayerInfo[playerid][pGiftVoucher]--;
					PlayerInfo[playerid][pGiftTime] = 0;
					new playerip[32];
					GetPlayerIp(playerid, playerip, sizeof(playerip));
					format(szMiscArray, sizeof(szMiscArray), "You have successfully used one of your Gift Reset voucher(s), you have %d Gift Reset voucher(s) left.", PlayerInfo[playerid][pGiftVoucher]);
					SendClientMessageEx(playerid, COLOR_CYAN, szMiscArray);
					SendClientMessageEx(playerid, COLOR_GRAD2, "** Note: You may now get another gift.");
					format(szMiscArray, sizeof(szMiscArray), "%s(%d)(IP:%s) has used a Gift Reset Voucher. (Vouchers Left: %d)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), playerip, PlayerInfo[playerid][pGiftVoucher]);
					Log("logs/vouchers.log", szMiscArray);	
					OnPlayerStatsUpdate(playerid);
				}
				if(GetPVarInt(playerid, "voucherdialog") == 5) // 7 Days Silver VIP
				{
					if(PlayerInfo[playerid][pDonateRank] >= 2)
					{
						DeletePVar(playerid, "voucherdialog");
						DeletePVar(playerid, "WhoIsThis");
						return SendClientMessageEx(playerid, COLOR_GRAD2, "Your VIP Level is already set to Silver+");
					}
					if(PlayerInfo[playerid][pSVIPExVoucher] <= 0) return DeletePVar(playerid, "voucherdialog"), DeletePVar(playerid, "WhoIsThis"), SendClientMessageEx(playerid, COLOR_GREY, "You don't have a 7 Day Silver VIP Voucher.");
					PlayerInfo[playerid][pSVIPExVoucher]--;
					PlayerInfo[playerid][pDonateRank] = 2;
					PlayerInfo[playerid][pTempVIP] = 0;
					PlayerInfo[playerid][pBuddyInvited] = 0;
					PlayerInfo[playerid][pVIPSellable] = 1;
					PlayerInfo[playerid][pVIPExpire] = gettime()+604800*1;
					if(PlayerInfo[playerid][pVIPM] == 0)
					{
						PlayerInfo[playerid][pVIPM] = VIPM;
						VIPM++;
					}
					LoadPlayerDisabledVehicles(playerid);
					new playerip[32];
					GetPlayerIp(playerid, playerip, sizeof(playerip));
					format(szMiscArray, sizeof(szMiscArray), "AdmCmd: Server (Voucher System) has set %s's VIP level to Silver (7 Days)(3).", GetPlayerNameEx(playerid));
					ABroadCast(COLOR_LIGHTRED, szMiscArray, 4);
					format(szMiscArray, sizeof(szMiscArray), "You have successfully used one of your 7 Days Silver VIP voucher(s), you have %d 7 Days Silver VIP voucher(s) left.", PlayerInfo[playerid][pSVIPExVoucher]);
					SendClientMessageEx(playerid, COLOR_CYAN, szMiscArray);
					SendClientMessageEx(playerid, COLOR_GRAD2, "** Note: Your Silver VIP will expire in 7 days.");

					format(szMiscArray, sizeof(szMiscArray), "AdmCmd: Server (Voucher System) has set %s's(%d) (IP:%s) VIP level to Silver (7 Days)(3) (Voucher Left: %d)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), playerip, PlayerInfo[playerid][pSVIPExVoucher]);
					Log("logs/vouchers.log", szMiscArray);
					OnPlayerStatsUpdate(playerid);
				}
				if(GetPVarInt(playerid, "voucherdialog") == 6) // 7 Days Gold VIP
				{
					if(PlayerInfo[playerid][pDonateRank] >= 3)
					{
						DeletePVar(playerid, "voucherdialog");
						DeletePVar(playerid, "WhoIsThis");
						return SendClientMessageEx(playerid, COLOR_GRAD2, "Your VIP Level is already set to Gold+");
					}
					if(PlayerInfo[playerid][pGVIPExVoucher] <= 0) return DeletePVar(playerid, "voucherdialog"), DeletePVar(playerid, "WhoIsThis"), SendClientMessageEx(playerid, COLOR_GREY, "You don't have a 7 Day Gold VIP Voucher.");
					PlayerInfo[playerid][pGVIPExVoucher]--;
					PlayerInfo[playerid][pDonateRank] = 3;
					PlayerInfo[playerid][pTempVIP] = 0;
					PlayerInfo[playerid][pBuddyInvited] = 0;
					PlayerInfo[playerid][pVIPSellable] = 1;
					PlayerInfo[playerid][pVIPExpire] = gettime()+604800*1;
					if(PlayerInfo[playerid][pVIPM] == 0)
					{
						PlayerInfo[playerid][pVIPM] = VIPM;
						VIPM++;
					}
					LoadPlayerDisabledVehicles(playerid);
					new playerip[32];
					GetPlayerIp(playerid, playerip, sizeof(playerip));
					format(szMiscArray, sizeof(szMiscArray), "AdmCmd: Server (Voucher System) has set %s's VIP level to Gold (7 Days)(3).", GetPlayerNameEx(playerid));
					ABroadCast(COLOR_LIGHTRED, szMiscArray, 4);
					format(szMiscArray, sizeof(szMiscArray), "You have successfully used one of your 7 Days Gold VIP voucher(s), you have %d 7 Days Gold VIP voucher(s) left.", PlayerInfo[playerid][pGVIPExVoucher]);
					SendClientMessageEx(playerid, COLOR_CYAN, szMiscArray);
					SendClientMessageEx(playerid, COLOR_GRAD2, "** Note: Your Gold VIP will expire in 7 days.");

					format(szMiscArray, sizeof(szMiscArray), "AdmCmd: Server (Voucher System) has set %s's(%d) (IP:%s) VIP level to Gold (7 Days)(3) (Voucher Left: %d)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), playerip, PlayerInfo[playerid][pGVIPExVoucher]);
					Log("logs/vouchers.log", szMiscArray);
					OnPlayerStatsUpdate(playerid);
				}
			}
			DeletePVar(playerid, "voucherdialog");
			DeletePVar(playerid, "WhoIsThis");
		}
	}
	return 0;
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
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1) return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not authorized to use this command!");
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
	if(GetPVarType(buyer, "buyingVoucher")) return SendClientMessageEx(playerid, COLOR_GRAD1, "This player is already buying another voucher, please try again later.");
	
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
		format(string, sizeof(string), "%s has offered to sell you %d 1 month PVIP Voucher(s) for $%s - Type /accept voucher or /denyvoucher.", GetPlayerNameEx(playerid), amount, number_format(price));
		SendClientMessageEx(buyer, COLOR_LIGHTBLUE, string);
		format(string, sizeof(string), "You have offered %s %d 1 month PVIP Voucher(s) for $%s, please wait until he accept/decline the offer.", GetPlayerNameEx(buyer), amount, number_format(price));
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
	if(GetPVarType(playerid, "buyingVoucher"))
	{
		new string[128];
		format(string, sizeof(string), "* %s has declined your voucher offer.", GetPlayerNameEx(playerid));
		SendClientMessageEx(GetPVarInt(playerid, "sellerVoucher"), COLOR_LIGHTBLUE, string);
		format(string, sizeof(string), "* You have declined %s voucher offer.", GetPlayerNameEx(GetPVarInt(playerid, "sellerVoucher")));
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
		DeletePVar(playerid, "priceVoucher");
		DeletePVar(playerid, "amountVoucher");
		DeletePVar(playerid, "buyingVoucher");
		DeletePVar(playerid, "sellerVoucher");
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD1, "No-one has offered you any vouchers.");
	return 1;
}		

CMD:voucherhelp(playerid, params[])
{
	SetPVarInt(playerid, "HelpResultCat0", 10);
	Help_ListCat(playerid, DIALOG_HELPCATOTHER1);
	return 1;
}

CMD:ovoucherhelp(playerid, params[])
{
	SendClientMessageEx(playerid, COLOR_GRAD1, "** Player Commands: /myvouchers /denyvoucher /accept voucher");
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1)
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "** Admin Commands: /checkvouchers");
	}
	return 1;
}
//end of the voucher commands