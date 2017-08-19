/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Find the Flag Event

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

// Load the result live, this way i can display them on the CP live :)
#include <YSI\y_hooks>

CMD:flaghelp(playerid, params[])
{
    SendClientMessageEx(playerid, COLOR_GREEN,"_______________________________________");
    SendClientMessageEx(playerid, COLOR_WHITE,"*** FLAG HELP *** - type a command for more infomation.");
	SendClientMessageEx(playerid, COLOR_GRAD3,"*** FLAG HELP *** /flagshop");
    return 1;
}

CMD:flagshop(playerid, params[]) {
	if(PlayerInfo[playerid][pAdmin] > 1) return SendClientMessageEx(playerid, COLOR_RED, "ERROR: Administrators can't access the flag store!");
	ShowFlagShop(playerid);
	return 1;
}

stock ShowFlagShop(playerid) {
	new title[54];
	szMiscArray[0] = 0;
	format(title, sizeof(title), "Flag Shop - Flag Credits: %s", number_format(PlayerInfo[playerid][pFlagCredits]));
	Dialog_Show(playerid, flag_shop, DIALOG_STYLE_TABLIST_HEADERS, title,
	"Item\tCost\n\
	Gift Reset\t2\n\
	Custom Car Voucher\t6\n\
	House Interior Change\t6\n\
	Bronze VIP 1 Month\t12\n\
	Silver VIP 1 Month\t20\n\
	Gold VIP 2 Month\t35\n\
	Platinum VIP 1 Month\t40", 
	"Select", "Go Back");
	return 1;
}

Dialog:flag_shop(playerid, response, listitem, inputtext[]) {
	szMiscArray[0] = 0;
	if(response) {
		SetPVarInt(playerid, "FlagItem", listitem);
		switch(listitem) {
			case 0: {
				if(PlayerInfo[playerid][pFlagCredits] < 2) return SendClientMessageEx(playerid, COLOR_GRAD3, "You need 2 flag credits to purchase a gift reset."), ShowFlagShop(playerid);
				format(szMiscArray, sizeof(szMiscArray), "Item: Gift Reset\nDescription: Ability to reset your gift timer.\nYour Flag Credits: %d\nCost: {FFD700}2{A9C4E4}\nFlag Credits Left: %d", PlayerInfo[playerid][pFlagCredits], (PlayerInfo[playerid][pFlagCredits]-2));
				return Dialog_Show(playerid, IssueFlagOrder, DIALOG_STYLE_MSGBOX, "Confirm Order", szMiscArray, "Select", "Go Back");
			}
			case 1: {
				if(PlayerInfo[playerid][pFlagCredits] < 6) return SendClientMessageEx(playerid, COLOR_GRAD3, "You need 6 flag credits to purchase a custom car voucher."), ShowFlagShop(playerid);
				format(szMiscArray, sizeof(szMiscArray), "Item: Gift Reset\nDescription: Ability to get a personal vehicle from /myvouchers.\nYour Flag Credits: %d\nCost: {FFD700}6{A9C4E4}\nFlag Credits Left: %d", PlayerInfo[playerid][pFlagCredits], (PlayerInfo[playerid][pFlagCredits]-6));
				return Dialog_Show(playerid, IssueFlagOrder, DIALOG_STYLE_MSGBOX, "Confirm Order", szMiscArray, "Select", "Go Back");
			}
			case 2: {
				if(PlayerInfo[playerid][pFlagCredits] < 6) return SendClientMessageEx(playerid, COLOR_GRAD3, "You need 6 flag credits to purchase a house interior change."), ShowFlagShop(playerid);
				format(szMiscArray, sizeof(szMiscArray), "Item: House Interior Change\nDescription: Ability to change your house interior (Account Flag).\nYour Flag Credits: %d\nCost: {FFD700}6{A9C4E4}\nFlag Credits Left: %d", PlayerInfo[playerid][pFlagCredits], (PlayerInfo[playerid][pFlagCredits]-6));
				return Dialog_Show(playerid, IssueFlagOrder, DIALOG_STYLE_MSGBOX, "Confirm Order", szMiscArray, "Select", "Go Back");
			}
			case 3: {
				if(PlayerInfo[playerid][pFlagCredits] < 12) return SendClientMessageEx(playerid, COLOR_GRAD3, "You need 12 flag credits to purchase bronze VIP. (1 month)."), ShowFlagShop(playerid);
				format(szMiscArray, sizeof(szMiscArray), "Item: Bronze VIP (1 Month)\nDescription: Item is non-transferable. (Account Flag)\nYour Flag Credits: %d\nCost: {FFD700}12{A9C4E4}\nFlag Credits Left: %d", PlayerInfo[playerid][pFlagCredits], (PlayerInfo[playerid][pFlagCredits]-12));
				return Dialog_Show(playerid, IssueFlagOrder, DIALOG_STYLE_MSGBOX, "Confirm Order", szMiscArray, "Select", "Go Back");
			}
			case 4: {
				if(PlayerInfo[playerid][pFlagCredits] < 20) return SendClientMessageEx(playerid, COLOR_GRAD3, "You need 20 flag credits to purchase silver VIP. (1 month)."), ShowFlagShop(playerid);
				format(szMiscArray, sizeof(szMiscArray), "Item: Silver VIP (1 Month)\nDescription: Item is non-transferable. (Account Flag)\nYour Flag Credits: %d\nCost: {FFD700}20{A9C4E4}\nFlag Credits Left: %d", PlayerInfo[playerid][pFlagCredits], (PlayerInfo[playerid][pFlagCredits]-20));
				return Dialog_Show(playerid, IssueFlagOrder, DIALOG_STYLE_MSGBOX, "Confirm Order", szMiscArray, "Select", "Go Back");
			}
			case 5: {
				if(PlayerInfo[playerid][pFlagCredits] < 35) return SendClientMessageEx(playerid, COLOR_GRAD3, "You need 35 flag credits to purchase gold VIP. (2 month)."), ShowFlagShop(playerid);
				format(szMiscArray, sizeof(szMiscArray), "Item: Gold VIP (2 Month)\nDescription: Item is non-transferable. (Account Flag)\nYour Flag Credits: %d\nCost: {FFD700}35{A9C4E4}\nFlag Credits Left: %d", PlayerInfo[playerid][pFlagCredits], (PlayerInfo[playerid][pFlagCredits]-35));
				return Dialog_Show(playerid, IssueFlagOrder, DIALOG_STYLE_MSGBOX, "Confirm Order", szMiscArray, "Select", "Go Back");
			}
			case 6: {
				if(PlayerInfo[playerid][pFlagCredits] < 40) return SendClientMessageEx(playerid, COLOR_GRAD3, "You need 40 flag credits to purchase platinum VIP. (1 month)."), ShowFlagShop(playerid);
				format(szMiscArray, sizeof(szMiscArray), "Item: Platinum VIP (1 Month)\nDescription: Item is non-transferable. (Account Flag)\nYour Flag Credits: %d\nCost: {FFD700}40{A9C4E4}\nFlag Credits Left: %d", PlayerInfo[playerid][pFlagCredits], (PlayerInfo[playerid][pFlagCredits]-40));
				return Dialog_Show(playerid, IssueFlagOrder, DIALOG_STYLE_MSGBOX, "Confirm Order", szMiscArray, "Select", "Go Back");
			}
		}
	}
	return 1;
}

Dialog:IssueFlagOrder(playerid, response, listitem, inputtext[]) {
	szMiscArray[0] = 0;
	if(!GetPVarType(playerid, "FlagItem")) return 1;
	if(response) {
		switch(GetPVarInt(playerid, "FlagItem")) {
			case 0: {
				format(szMiscArray, sizeof(szMiscArray), "%s has purchased a Gift Reset Voucher (Cost: 2 | Credit Left: %d)", GetPlayerNameEx(playerid), (PlayerInfo[playerid][pFlagCredits]-2));
				Log("logs/flagevent.log", szMiscArray);
				PlayerInfo[playerid][pFlagCredits] -= 2;
				PlayerInfo[playerid][pGiftVoucher] += 1;
				SendClientMessageEx(playerid, COLOR_WHITE, "You have purchased a gift reset voucher you can access it via \"/myvouchers\".");
			}
			case 1: {
				format(szMiscArray, sizeof(szMiscArray), "%s has purchased a Custom Car Voucher (Cost: 6 | Credit Left: %d)", GetPlayerNameEx(playerid), (PlayerInfo[playerid][pFlagCredits]-6));
				Log("logs/flagevent.log", szMiscArray);
				PlayerInfo[playerid][pFlagCredits] -= 6;
				PlayerInfo[playerid][pVehVoucher] += 1;
				SendClientMessageEx(playerid, COLOR_WHITE, "You have purchased a gift reset voucher you can access it via \"/myvouchers\".");
			}
			case 2: {
				format(szMiscArray, sizeof(szMiscArray), "%s has purchased a House Interior Change (Cost: 6 | Credit Left: %d)", GetPlayerNameEx(playerid), (PlayerInfo[playerid][pFlagCredits]-6));
				Log("logs/flagevent.log", szMiscArray);
				PlayerInfo[playerid][pFlagCredits] -= 6;
				AddFlag(playerid, INVALID_PLAYER_ID, "[Flag Event] House Interior Change | NT");
				SendClientMessageEx(playerid, COLOR_WHITE, "You have purchased a house interior change (Flagged to your account) you can claim it via \"/report > Prize Claim\".");
			}
			case 3: {
				format(szMiscArray, sizeof(szMiscArray), "%s has purchased a Bronze VIP (1 Month) (Cost: 12 | Credit Left: %d)", GetPlayerNameEx(playerid), (PlayerInfo[playerid][pFlagCredits]-12));
				Log("logs/flagevent.log", szMiscArray);
				PlayerInfo[playerid][pFlagCredits] -= 12;
				AddFlag(playerid, INVALID_PLAYER_ID, "[Flag Event] Bronze VIP (1 Month) | NT");
				SendClientMessageEx(playerid, COLOR_WHITE, "You have purchased a Bronze VIP (1 Month) (Flagged to your account) you can claim it via \"/report > Prize Claim\".");
				SendClientMessageEx(playerid, COLOR_WHITE, "This item can only be claimed to you and cannot be sold to another player.");
			}
			case 4: {
				format(szMiscArray, sizeof(szMiscArray), "%s has purchased a Silver VIP (1 Month) (Cost: 20 | Credit Left: %d)", GetPlayerNameEx(playerid), (PlayerInfo[playerid][pFlagCredits]-20));
				Log("logs/flagevent.log", szMiscArray);
				PlayerInfo[playerid][pFlagCredits] -= 20;
				AddFlag(playerid, INVALID_PLAYER_ID, "[Flag Event] Silver VIP (1 Month) | NT");
				SendClientMessageEx(playerid, COLOR_WHITE, "You have purchased a Silver VIP (1 Month) (Flagged to your account) you can claim it via \"/report > Prize Claim\".");
				SendClientMessageEx(playerid, COLOR_WHITE, "This item can only be claimed to you and cannot be sold to another player.");
			}
			case 5: {
				format(szMiscArray, sizeof(szMiscArray), "%s has purchased a Gold VIP (2 Month) (Cost: 35 | Credit Left: %d)", GetPlayerNameEx(playerid), (PlayerInfo[playerid][pFlagCredits]-35));
				Log("logs/flagevent.log", szMiscArray);
				PlayerInfo[playerid][pFlagCredits] -= 35;
				AddFlag(playerid, INVALID_PLAYER_ID, "[Flag Event] Gold VIP (2 Month) | NT");
				SendClientMessageEx(playerid, COLOR_WHITE, "You have purchased a Gold VIP (2 Month) (Flagged to your account) you can claim it via \"/report > Prize Claim\".");
				SendClientMessageEx(playerid, COLOR_WHITE, "This item can only be claimed to you and cannot be sold to another player.");
			}
			case 6: {
				format(szMiscArray, sizeof(szMiscArray), "%s has purchased a Gold VIP (2 Month) (Cost: 40 | Credit Left: %d)", GetPlayerNameEx(playerid), (PlayerInfo[playerid][pFlagCredits]-40));
				Log("logs/flagevent.log", szMiscArray);
				PlayerInfo[playerid][pFlagCredits] -= 40;
				AddFlag(playerid, INVALID_PLAYER_ID, "[Flag Event] Platinum VIP (1 Month) | NT");
				SendClientMessageEx(playerid, COLOR_WHITE, "You have purchased a Platinum VIP (1 Month) (Flagged to your account) you can claim it via \"/report > Prize Claim\".");
				SendClientMessageEx(playerid, COLOR_WHITE, "This item can only be claimed to you and cannot be sold to another player.");
			}
		}
		DeletePVar(playerid, "FlagItem");
	} else {
		DeletePVar(playerid, "FlagItem");
		ShowFlagShop(playerid);
	}
	return 1;
}