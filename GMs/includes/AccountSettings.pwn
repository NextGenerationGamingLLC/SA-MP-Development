#include <YSI\y_hooks>

#define ACCOUNT_SETTINGS	10020
#define ACCOUNT_TOGGLEMENU	10021

CMD:accountsettings(playerid, params[]) {

	ShowAccountSettings(playerid);

	return 1;
}

ShowAccountSettings(playerid, menu = 0) {
	
	if(!gPlayerLogged{playerid}) return SendClientMessageEx(playerid, COLOR_WHITE, " You must be logged in to use this.");

	szMiscArray[0] = 0;
	new szTitle[32];

	switch(menu) {

		case 0: { // main account settings menu
			format(szTitle, sizeof(szTitle), "Account Settings - %s", GetPlayerNameEx(playerid));
			format(szMiscArray, sizeof(szMiscArray), "Toggle Menu\nChange Account Email\nAccount Password\nChange Shop Pin");
			ShowPlayerDialog(playerid, ACCOUNT_SETTINGS, DIALOG_STYLE_LIST, szTitle, szMiscArray, "Select", "Cancel");
		}

		case 1: { // toggle menu
			
			format(szMiscArray, sizeof(szMiscArray), "Item\tStatus\n \
				{FFFFFF}---General---\t\n\
				{FFFFFF}Newbie Chat\t%s\n\
				{FFFFFF}News\t%s\n\
				{FFFFFF}OOC Chat\t%s\n\
				{FFFFFF}Whispers\t%s\n\
				{FFFFFF}ChatBox\t%s\n\
				{FFFFFF}Private Radio\t%s\n\
				{FFFFFF}Hunger Meter\t%s\n\
				{FFFFFF}Phone\t%s\n\
				{FFFFFF}Famed\t%s\n\
				{FFFFFF}VIP\t%s\n\
				{FFFFFF}---Groups---\t\n\
				{FFFFFF}Dept\t%s\n\
				{FFFFFF}OOC Group\t%s\n\
				{FFFFFF}Radio\t%s\n\
				{FFFFFF}Bug Chat\t%s\n\
				{FFFFFF}Biz Radio\t%s\n\
				{FFFFFF}--- Staff ---\t\n\
				{FFFFFF}Staff Chat\t%s\n\
				{FFFFFF}Community Advisor Chat\t%s\n\
				{FFFFFF}Watchdog Chat\t%s\n",
				(PlayerInfo[playerid][pNewbieTogged] == 1) ? ("{00FF00}On") : ("{FF0000}Off"),
				(gNews[playerid] == 1) ? ("{00FF00}On") : ("{FF0000}Off"),
				(gOoc[playerid] == 1) ? ("{00FF00}On") : ("{FF0000}Off"),
				(HidePM[playerid] == 1) ? ("{00FF00}On") : ("{FF0000}Off"),
				(ActiveChatbox[playerid] == 1) ? ("{00FF00}On") : ("{FF0000}Off"),
				(gRadio{playerid} == 1) ? ("{00FF00}On") : ("{FF0000}Off"),
				(_hungerTextVisible[playerid] == 1) ? ("{00FF00}On") : ("{FF0000}Off"),
				(PhoneOnline[playerid] == 1) ? ("{00FF00}On") : ("{FF0000}Off"),
				(PlayerInfo[playerid][pFamedTogged] == 1) ? ("{00FF00}On") : ("{FF0000}Off"),
				(PlayerInfo[playerid][pVIPTogged] == 1) ? ("{00FF00}On") : ("{FF0000}Off")
			);
		}

		case 2: { // account email 
			SendClientMessageEx(playerid, COLOR_WHITE, "   To be added.");
		}

		case 3: { // account password
			ShowPlayerDialog(playerid, DIALOG_CHANGEPASS, DIALOG_STYLE_INPUT, "Password Change", "Please enter your new password!", "Change", "Exit" );
		}

		case 4: { // shop pin
			
			if(GetPVarInt(playerid, "PinConfirmed")) {
			    SetPVarInt(playerid, "ChangePin", 1);
			    ShowPlayerDialog(playerid, DIALOG_CREATEPIN, DIALOG_STYLE_INPUT, "Change Pin Number", "Enter a new pin number to change your current one.", "Change", "Cancel");
			}
			else PinLogin(playerid);
		}
	}
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	switch(dialogid) {

		case ACCOUNT_SETTINGS: {

			if(!response) {
				return SendClientMessageEx(playerid, COLOR_WHITE, "   You are no longer editing your account settings");
			}

			switch(listitem) {

				case 0: {
					ShowAccountSettings(playerid, 1);
				}
				case 1: {
					ShowAccountSettings(playerid, 2);
				}
				case 2: {
					ShowAccountSettings(playerid, 3);
				}
				case 3: {
					ShowAccountSettings(playerid, 4);
				}
			}

		}

		case ACCOUNT_TOGGLEMENU: {
			case 0: // newbie chat
			case 1: // news chat 
			case 2: // OOC chat
			case 3: // whispers
			case 4: // chatbox
			case 5: // private radio
			case 6: // hunger meter
			case 7: // phone 
			case 8: // famed
			case 9: // VIP
			case 10: // dept 
			case 11: // OOC Group chat
			case 11: // radio chat
			case 12: // bug chat
			case 13: // biz radio
			case 14: // staff chat
			case 15: // CA Chat
			case 16: // Watchdogchat
		}
	}

	return 1;
}