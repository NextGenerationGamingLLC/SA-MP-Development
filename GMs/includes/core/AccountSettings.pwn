#include <YSI\y_hooks>

#define ACCOUNT_SETTINGS	10020
#define ACCOUNT_TOGGLEMENU	10021
#define ACCOUNT_CHATBOX		10022

CMD:settings(playerid, params[]) {

	ShowAccountSettings(playerid);
	return 1;
}

ShowAccountSettings(playerid, menu = 0) {
	
	if(!gPlayerLogged{playerid}) return SendClientMessageEx(playerid, COLOR_WHITE, "You must be logged in to use this.");

	szMiscArray[0] = 0;
	new szTitle[32];

	switch(menu) {

		case 0: {
			format(szTitle, sizeof(szTitle), "Account Settings - %s", GetPlayerNameEx(playerid));
			format(szMiscArray, sizeof(szMiscArray), "Toggle Menu\nChange Account Email\nAccount Password\nChange Shop Pin");
			ShowPlayerDialogEx(playerid, ACCOUNT_SETTINGS, DIALOG_STYLE_LIST, szTitle, szMiscArray, "Select", "Cancel");
		}

		case 1: {
			
			format(szMiscArray, sizeof(szMiscArray), "Item\tStatus\n\
				{FFFFFF}---General---\t\n\
				{FFFFFF}NG:RP Phone Mod\t%s\n\
				{FFFFFF}Newbie Chat\t%s\n\
				{FFFFFF}News\t%s\n\
				{FFFFFF}OOC Chat\t%s\n\
				{FFFFFF}Whispers\t%s\n\
				{FFFFFF}First ChatBox\t%s\n\
				{FFFFFF}Private Radio\t%s\n\
				{FFFFFF}Phone\t%s\n\
				{FFFFFF}Famed\t%s\n\
				{FFFFFF}VIP\t%s\n",
				(PlayerInfo[playerid][pToggledChats][20] == 1) ? ("{00FF00}On") : ("{FF0000}Off"),
				(PlayerInfo[playerid][pToggledChats][0] == 0) ? ("{00FF00}On") : ("{FF0000}Off"),
				(PlayerInfo[playerid][pToggledChats][1] == 0) ? ("{00FF00}On") : ("{FF0000}Off"),
				(PlayerInfo[playerid][pToggledChats][2] == 0) ? ("{00FF00}On") : ("{FF0000}Off"),
				(PlayerInfo[playerid][pToggledChats][3] == 0) ? ("{00FF00}On") : ("{FF0000}Off"),
				(PlayerInfo[playerid][pToggledChats][4] == 0) ? ("{00FF00}On") : ("{FF0000}Off"),
				// (PlayerInfo[playerid][pToggledChats][19] == 0) ? ("{00FF00}On") : ("{FF0000}Off"),
				(PlayerInfo[playerid][pToggledChats][5] == 0) ? ("{00FF00}On") : ("{FF0000}Off"),
				(PlayerInfo[playerid][pToggledChats][6] == 0) ? ("{00FF00}On") : ("{FF0000}Off"),
				(PlayerInfo[playerid][pToggledChats][7] == 0) ? ("{00FF00}On") : ("{FF0000}Off"),
				(PlayerInfo[playerid][pToggledChats][8] == 0) ? ("{00FF00}On") : ("{FF0000}Off"),
				(PlayerInfo[playerid][pToggledChats][9] == 0) ? ("{00FF00}On") : ("{FF0000}Off")
			);
			format(szMiscArray, sizeof(szMiscArray), "%s\
				{FFFFFF}---Groups---\t\n\
				{FFFFFF}Dept\t%s\n\
				{FFFFFF}International\t%s\n\
				{FFFFFF}OOC Group\t%s\n\
				{FFFFFF}Radio\t%s\n\
				{FFFFFF}Bug Chat\t%s\n\
				{FFFFFF}Biz Radio\t%s\n\
				{FFFFFF}Point Messages\t%s\n\
				{FFFFFF}--- Staff ---\t\n\
				{FFFFFF}Staff Chat\t%s\n\
				{FFFFFF}Advisor Chat\t%s\n\
				{FFFFFF}Watchdog Chat\t%s\n",
				szMiscArray,
				(PlayerInfo[playerid][pToggledChats][10] == 0) ? ("{00FF00}On") : ("{FF0000}Off"),
				(PlayerInfo[playerid][pToggledChats][21] == 0) ? ("{00FF00}On") : ("{FF0000}Off"),
				(PlayerInfo[playerid][pToggledChats][11] == 0) ? ("{00FF00}On") : ("{FF0000}Off"),
				(PlayerInfo[playerid][pToggledChats][12] == 0) ? ("{00FF00}On") : ("{FF0000}Off"),
				(PlayerInfo[playerid][pToggledChats][13] == 0) ? ("{00FF00}On") : ("{FF0000}Off"),
				(PlayerInfo[playerid][pToggledChats][14] == 0) ? ("{00FF00}On") : ("{FF0000}Off"),
				(PlayerInfo[playerid][pToggledChats][15] == 0) ? ("{00FF00}On") : ("{FF0000}Off"),
				(PlayerInfo[playerid][pToggledChats][22] == 0) ? ("{00FF00}On") : ("{FF0000}Off"),
				(PlayerInfo[playerid][pToggledChats][16] == 0) ? ("{00FF00}On") : ("{FF0000}Off"),
				(PlayerInfo[playerid][pToggledChats][17] == 0) ? ("{00FF00}On") : ("{FF0000}Off"),
				(PlayerInfo[playerid][pToggledChats][18] == 0) ? ("{00FF00}On") : ("{FF0000}Off")
			);
			ShowPlayerDialogEx(playerid, ACCOUNT_TOGGLEMENU, DIALOG_STYLE_TABLIST_HEADERS, "Toggle Menu", szMiscArray, "Select", "Cancel");
		}
		case 2: {
			
			format(szMiscArray, sizeof(szMiscArray), "Item\tChatbox\n\
				---General---\t\n\
				Newbie Chat\t%d\n\
				News\t%d\n\
				OOC Chat\t%d\n\
				Whispers\t%d\n\
				Private Radio\t%d\n\
				Phone\t%d\n\
				Famed\t%d\n\
				VIP\t%d\n\
				---Groups---\t\n\
				Dept\t%d\n\
				OOC Group\t%d\n\
				Radio\t%d\n\
				Bug Chat\t%d\n\
				Biz Radio\t%d\n\
				--- Staff ---\t\n\
				Staff Chat\t%d\n\
				Advisor Chat\t%d\n\
				Watchdog Chat\t%d\n",
				PlayerInfo[playerid][pChatbox][0],
				PlayerInfo[playerid][pChatbox][1],
				PlayerInfo[playerid][pChatbox][2],
				PlayerInfo[playerid][pChatbox][3],
				PlayerInfo[playerid][pChatbox][5],
				PlayerInfo[playerid][pChatbox][7],
				PlayerInfo[playerid][pChatbox][8],
				PlayerInfo[playerid][pChatbox][9],
				PlayerInfo[playerid][pChatbox][10],
				PlayerInfo[playerid][pChatbox][11],
				PlayerInfo[playerid][pChatbox][12],
				PlayerInfo[playerid][pChatbox][13],
				PlayerInfo[playerid][pChatbox][14],
				PlayerInfo[playerid][pChatbox][15],
				PlayerInfo[playerid][pChatbox][16],
				PlayerInfo[playerid][pChatbox][17],
				PlayerInfo[playerid][pChatbox][18]
			);
			ShowPlayerDialogEx(playerid, ACCOUNT_CHATBOX, DIALOG_STYLE_TABLIST_HEADERS, "Chat Preferences", szMiscArray, "Select", "Cancel");
		}

		case 3: { // account email 
			ShowPlayerDialogEx(playerid, EMAIL_VALIDATION, DIALOG_STYLE_INPUT, "E-mail Registration", "Please enter a valid e-mail address to associate with your account.", "Submit", "");
		}

		case 4: { // account password
			ShowPlayerDialogEx(playerid, DIALOG_CHANGEPASS, DIALOG_STYLE_INPUT, "Password Change", "Please enter your new password!\nStaff members will never ask for your password!", "Change", "Exit" );
		}

		case 5: { // shop pin
			
			if(GetPVarInt(playerid, "PinConfirmed")) {
			    SetPVarInt(playerid, "ChangePin", 1);
			    ShowPlayerDialogEx(playerid, DIALOG_CREATEPIN, DIALOG_STYLE_INPUT, "Change Pin Number", "Enter a new pin number to change your current one.", "Change", "Cancel");
			}
			else PinLogin(playerid);
		}
	}
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	switch(dialogid) {

		case ACCOUNT_SETTINGS: {

			if(!response) {
				return 1;
			}

			switch(listitem) {

				case 0: {
					ShowAccountSettings(playerid, 1); // toggle settings
				}
				case 1: {
					ShowAccountSettings(playerid, 3); // account email
				}
				case 2: {
					ShowAccountSettings(playerid, 4);
				}
				case 3: {
					ShowAccountSettings(playerid, 5);
				}
				/*case 4: {
					ShowAccountSettings(playerid, 5);
				}*/
			}

		}

		case ACCOUNT_TOGGLEMENU: {
			
			if(!response) return ShowAccountSettings(playerid, 0);
			new id = -1;
			if(strcmp(inputtext, "NG:RP Phone Mod", true) == 0) id = 20;
			else if(strcmp(inputtext, "Newbie Chat", true) == 0) id = 0;
			else if(strcmp(inputtext, "News", true) == 0) id = 1;
			else if(strcmp(inputtext, "OOC Chat", true) == 0) id = 2;
			else if(strcmp(inputtext, "Whispers", true) == 0) id = 3;
			else if(strcmp(inputtext, "First ChatBox", true) == 0) id = 4;
			else if(strcmp(inputtext, "Secondary ChatBox", true) == 0) id = 19;
			else if(strcmp(inputtext, "Private Radio", true) == 0) id = 5;
			else if(strcmp(inputtext, "Phone", true) == 0) id = 7;
			else if(strcmp(inputtext, "Famed", true) == 0) id = 8;
			else if(strcmp(inputtext, "VIP", true) == 0) id = 9;
			else if(strcmp(inputtext, "Dept", true) == 0) id = 10;
			else if(strcmp(inputtext, "International", true) == 0) id = 21;
			else if(strcmp(inputtext, "OOC Group", true) == 0) id = 11;
			else if(strcmp(inputtext, "Radio", true) == 0) id = 12;
			else if(strcmp(inputtext, "Bug Chat", true) == 0) id = 13;
			else if(strcmp(inputtext, "Biz Radio", true) == 0) id = 14;
			else if(strcmp(inputtext, "Point Messages", true) == 0) id = 22;
			else if(strcmp(inputtext, "Staff Chat", true) == 0) id = 15;
			else if(strcmp(inputtext, "Advisor Chat", true) == 0) id = 16;
			else if(strcmp(inputtext, "Watchdog Chat", true) == 0) id = 17;
			// else if(strcmp(inputtext, "Admin", true) == 0) id = 18;
			if(id == -1) return ShowAccountSettings(playerid, 1);
			if(PlayerInfo[playerid][pToggledChats][id] == 0) {

				PlayerInfo[playerid][pToggledChats][id] = 1;
				switch(id) {

					case 7: PhoneOnline[playerid] = 1;
					case 15: advisorchat[playerid] = 0;
					case 19: for(new i; i < sizeof(TD_ChatBox); ++i) PlayerTextDrawHide(playerid, TD_ChatBox[i]);
				}
			}
			else {

				PlayerInfo[playerid][pToggledChats][id] = 0;
				switch(id) {
					case 7: PhoneOnline[playerid] = 0;
					case 15: advisorchat[playerid] = 1;
					case 19: for(new i; i < sizeof(TD_ChatBox); ++i) PlayerTextDrawShow(playerid, TD_ChatBox[i]);
				}
			}
			ShowAccountSettings(playerid, 1);
			return 1;
		}
		case ACCOUNT_CHATBOX: {

			if(!response) return DeletePVar(playerid, "ChatboxPref"), ShowAccountSettings(playerid, 0);
			if(GetPVarType(playerid, "ChatboxPref")) {

				if(0 > strval(inputtext) > 1) return DeletePVar(playerid, "ChatboxPref"), SendClientMessage(playerid, COLOR_GRAD1, "You specified an invalid value.");
				PlayerInfo[playerid][pChatbox][GetPVarInt(playerid, "ChatBoxPref")] = strval(inputtext);
				DeletePVar(playerid, "ChatboxPref");
				ShowAccountSettings(playerid, 2);
				return 1;
			}
			else {

				new id = -1;
				if(strcmp(inputtext, "Newbie Chat", true) == 0) id = 0;
				else if(strcmp(inputtext, "News", true) == 0) id = 1;
				else if(strcmp(inputtext, "OOC Chat", true) == 0) id = 2;
				else if(strcmp(inputtext, "Whispers", true) == 0) id = 3;
				else if(strcmp(inputtext, "Private Radio", true) == 0) id = 5;
				else if(strcmp(inputtext, "Phone", true) == 0) id = 7;
				else if(strcmp(inputtext, "Famed", true) == 0) id = 8;
				else if(strcmp(inputtext, "VIP", true) == 0) id = 9;
				else if(strcmp(inputtext, "Dept", true) == 0) id = 10;
				else if(strcmp(inputtext, "OOC Group", true) == 0) id = 11;
				else if(strcmp(inputtext, "Radio", true) == 0) id = 12;
				else if(strcmp(inputtext, "Bug Chat", true) == 0) id = 13;
				else if(strcmp(inputtext, "Biz Radio", true) == 0) id = 14;
				else if(strcmp(inputtext, "Staff Chat", true) == 0) id = 15;
				else if(strcmp(inputtext, "Advisor Chat", true) == 0) id = 16;
				else if(strcmp(inputtext, "Watchdog Chat", true) == 0) id = 17;
				if(id == -1) return ShowAccountSettings(playerid, 1);
				// else if(strcmp(inputtext, "Admin", true) == 0) id = 18;
				SetPVarInt(playerid, "ChatboxPref", id);
				ShowPlayerDialogEx(playerid, ACCOUNT_CHATBOX, DIALOG_STYLE_INPUT, "Chatbox Preferences", "In which chatbox would you like this chat channel?\n\nAvailable options: Main (0), Bottom Right (1).", "Select", "Cancel");
			}
		}
	}
	return 0;
}

CMD:tog(playerid, params[]) {
 
    if(isnull(params)) {
 
        SendClientMessageEx(playerid, COLOR_GRAD1, "USAGE: /tog [option]");
        SendClientMessageEx(playerid, COLOR_GRAD1, "OPTIONS: newbie | ooc | whisper | pr | phone | famed | vip | dept | gooc | radio | bug");
        SendClientMessageEx(playerid, COLOR_GRAD1, "OPTIONS: biz | staff | advisor | news | chatbox | advisor | points | rf");
        return 1;
    }
 
    new iChatID = -1, chatname[50];
    mysql_escape_string(params, chatname);
 
    if(strcmp(params, "newbie", true) == 0) iChatID = 0;
    else if(strcmp(params, "ooc", true) == 0) iChatID = 2;
    else if(strcmp(params, "whisper", true) == 0) iChatID = 3;
    else if(strcmp(params, "pr", true) == 0) iChatID = 5;
    else if(strcmp(params, "phone", true) == 0) iChatID = 7;
    else if(strcmp(params, "famed", true) == 0) iChatID = 8;
    else if(strcmp(params, "vip", true) == 0) iChatID = 9;
    else if(strcmp(params, "dept", true) == 0) iChatID = 10;
    else if(strcmp(params, "gooc", true) == 0) iChatID = 11;
    else if(strcmp(params, "radio", true) == 0) iChatID = 12;
    else if(strcmp(params, "bug", true) == 0) iChatID = 13;
    else if(strcmp(params, "biz", true) == 0) iChatID = 14;
    else if(strcmp(params, "staff", true) == 0) iChatID = 15;
    else if(strcmp(params, "advisor", true) == 0) iChatID = 16;
    else if(strcmp(params, "news", true) == 0) iChatID = 1;
    else if(strcmp(params, "chatbox", true) == 0) iChatID = 4;
    else if(strcmp(params, "advisor", true) == 0) iChatID = 16;
    else if(strcmp(params, "points", true) == 0) iChatID = 22;
    else if(strcmp(params, "rf", true) == 0) iChatID = 23;
 
    if(!(0 <= iChatID < MAX_CHATSETS)) return 1; // preventing OOB issues.
 
    if(PlayerInfo[playerid][pToggledChats][iChatID] == 0) {
 
        PlayerInfo[playerid][pToggledChats][iChatID] = 1;
        switch(iChatID) {
 
            case 7: PhoneOnline[playerid] = 1;
            case 15: advisorchat[playerid] = 0;
            case 19: for(new i; i < sizeof(TD_ChatBox); ++i) PlayerTextDrawHide(playerid, TD_ChatBox[i]);
            case 23: TextDrawHideForPlayer(playerid, TD_RepFam);
           
        }
        format(szMiscArray, sizeof(szMiscArray), "You have toggled %s off.", chatname);
        SendClientMessage(playerid, COLOR_GRAD1, szMiscArray);
    }
    else {
 
        PlayerInfo[playerid][pToggledChats][iChatID] = 0;
        switch(iChatID) {
            case 7: PhoneOnline[playerid] = 0;
            case 15: advisorchat[playerid] = 1;
            case 19: for(new i; i < sizeof(TD_ChatBox); ++i) PlayerTextDrawShow(playerid, TD_ChatBox[i]);
            case 23: if(GetPVarInt(playerid, "RepFam_TL")) TextDrawShowForPlayer(playerid, TD_RepFam);
        }
        format(szMiscArray, sizeof(szMiscArray), "You have toggled %s on.", chatname);
        SendClientMessage(playerid, COLOR_GRAD1, szMiscArray);
    }
    return 1;
}