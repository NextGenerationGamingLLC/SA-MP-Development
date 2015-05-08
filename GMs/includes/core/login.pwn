stock SetPlayerJoinCamera(playerid)
{
	new randcamera = Random(1,9);
	switch(randcamera)
	{
		case 1: // Gym
		{
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid,2229.4968,-1722.0701,13.5625);
			SetPlayerPos(playerid,2211.1460,-1748.3909,-10.0);
			SetPlayerCameraPos(playerid,2211.1460,-1748.3909,29.3744);
			SetPlayerCameraLookAt(playerid,2229.4968,-1722.0701,13.5625);
		}
		case 2: // Paintball Arena
		{
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid,1295.6960,-1422.5111,14.9596);
			SetPlayerPos(playerid,1283.8524,-1385.5304,-10.0);
			SetPlayerCameraPos(playerid,1283.8524,-1385.5304,25.8896);
			SetPlayerCameraLookAt(playerid,1295.6960,-1422.5111,14.9596);
		}
		case 3: // LSPD
		{
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid,1554.3381,-1675.5692,16.1953);
			SetPlayerPos(playerid,1514.7783,-1700.2913,-10.0);
			SetPlayerCameraPos(playerid,1514.7783,-1700.2913,36.7506);
			SetPlayerCameraLookAt(playerid,1554.3381,-1675.5692,16.1953);
		}
		case 4: // SaC HQ (Gang HQ)
		{
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid,655.5394,-1867.2231,5.4609);
			SetPlayerPos(playerid,655.5394,-1867.2231,-10.0);
			SetPlayerCameraPos(playerid,699.7435,-1936.7568,24.8646);
			SetPlayerCameraLookAt(playerid,655.5394,-1867.2231,5.4609);

		}
		case 5: // Fishing Pier
		{
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid,370.0804,-2087.8767,7.8359);
			SetPlayerPos(playerid,370.0804,-2087.8767,-10.0);
			SetPlayerCameraPos(playerid,423.3802,-2067.7915,29.8605);
			SetPlayerCameraLookAt(playerid,370.0804,-2087.8767,7.8359);
		}
		case 6: // VIP
		{
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid,1797.3397,-1578.3440,14.0798);
			SetPlayerPos(playerid,1797.3397,-1578.3440,-10.0);
			SetPlayerCameraPos(playerid,1832.1698,-1600.1538,32.2877);
			SetPlayerCameraLookAt(playerid,1797.3397,-1578.3440,14.0798);
		}
		case 7: // All Saints
		{
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid,1175.5581,-1324.7922,18.1610);
			SetPlayerPos(playerid, 1188.4574,-1309.2242,-10.0);
			SetPlayerCameraPos(playerid,1188.4574,-1309.2242,13.5625+6.0);
			SetPlayerCameraLookAt(playerid,1175.5581,-1324.7922,18.1610);
		}
		case 8: // Unity
		{
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid,1716.1129,-1880.0715,22.0264);
			SetPlayerPos(playerid,1716.1129,-1880.0715,-10.0);
			SetPlayerCameraPos(playerid,1755.0413,-1824.8710,20.2100);
			SetPlayerCameraLookAt(playerid,1716.1129,-1880.0715,22.0264);
		}
	}
	return 1;
}

stock ShowMainMenuDialog(playerid, frame)
{
	new titlestring[64];
	new string[512];

	switch(frame)
	{
		case 1:
		{
			format(titlestring, sizeof(titlestring), "{3399FF}Login - %s", GetPlayerNameEx(playerid));
			format(string, sizeof(string), "{FFFFFF}Welcome to Next Generation Roleplay, %s.\n\nThe name that you are using is registered, please enter a password to login:", GetPlayerNameEx(playerid));
			ShowPlayerDialog(playerid,MAINMENU,DIALOG_STYLE_PASSWORD,titlestring,string,"Login","Exit");
		}
		case 2:
		{
			format(titlestring, sizeof(titlestring), "{3399FF}Register - %s", GetPlayerNameEx(playerid));
			format(string, sizeof(string), "{FFFFFF}Welcome to Next Generation Roleplay, %s.\n\n{FFFFFF}You may {AA3333}register {FFFFFF}an account by entering a desired password here:", GetPlayerNameEx(playerid));
			if(PassComplexCheck) strcat(string, "\n\n- You can't select a password that's below 8 or above 64 characters\n\
			- Your password must contain a combination of letters, numbers and special characters.\n\
			- Invalid Character: %");
			ShowPlayerDialog(playerid,MAINMENU2,DIALOG_STYLE_PASSWORD,titlestring,string,"Register","Exit");
		}
		case 3:
		{
			format(titlestring, sizeof(titlestring), "{3399FF}Login - %s", GetPlayerNameEx(playerid));
			format(string, sizeof(string), "{FFFFFF}Invalid Password!\n\nWelcome to Next Generation Roleplay, %s.\n\nThe name that you are using is registered, please enter a password to login:", GetPlayerNameEx(playerid));
			ShowPlayerDialog(playerid,MAINMENU,DIALOG_STYLE_PASSWORD,titlestring,string,"Login","Exit");
		}
		case 4:
		{
			format(titlestring, sizeof(titlestring), "{3399FF}Account Locked - %s", GetPlayerNameEx(playerid));
			format(string, sizeof(string), "{FFFFFF}Our database indicates that %s is currently logged in, if this is a mistake please contact a tech administrator.", GetPlayerNameEx(playerid));
			ShowPlayerDialog(playerid,MAINMENU3,DIALOG_STYLE_MSGBOX,titlestring,string,"Exit","");
		}
	}
	return 1;
}

stock SafeLogin(playerid, type)
{
	switch(type)
	{
		case 1: // Account Exists
		{
			ShowMainMenuDialog(playerid, 1);
		}
		case 2: // No Account Exists
		{
			if(!IsValidName(GetPlayerNameExt(playerid)))
			{
			    SetPVarString(playerid, "KickNonRP", GetPlayerNameEx(playerid));
			    SetTimerEx("KickNonRP", 3000, false, "i", playerid);
			}
			else
			{
			    ShowMainMenuDialog(playerid, 2);
			}
		}
	}

	return 1;
}

stock InvalidNameCheck(playerid) {

	new
		arrForbiddenNames[][] = {
			"com1", "com2", "com3", "com4",
			"com5", "com6", "com7", "com8",
			"com9", "lpt4", "lpt5", "lpt6",
			"lpt7", "lpt8", "lpt9", "nul",
			"clock$", "aux", "prn", "con",
			"InvalidNick"
	    };

	new i = 0;
	while(i < sizeof(arrForbiddenNames)) if(strcmp(arrForbiddenNames[i++], GetPlayerNameExt(playerid), true) == 0) {
		SetPlayerName(playerid, "InvalidNick");
		SendClientMessage(playerid, COLOR_RED, "You have been kicked & logged for using a forbidden username.");
		SetTimerEx("KickEx", 1000, 0, "i", playerid);
		return 0;

	}
	return 1;
}

stock ShowMainMenuGUI(playerid)
{
	InsideMainMenu{playerid} = true;
	MainMenuUpdateForPlayer(playerid);

	TextDrawShowForPlayer(playerid, MainMenuTxtdraw[0]);
	TextDrawShowForPlayer(playerid, MainMenuTxtdraw[1]);
	TextDrawShowForPlayer(playerid, MainMenuTxtdraw[2]);
	TextDrawShowForPlayer(playerid, MainMenuTxtdraw[3]);
	TextDrawShowForPlayer(playerid, MainMenuTxtdraw[4]);
	TextDrawShowForPlayer(playerid, MainMenuTxtdraw[5]);
	TextDrawShowForPlayer(playerid, MainMenuTxtdraw[6]);
	TextDrawShowForPlayer(playerid, MainMenuTxtdraw[9]);
	TextDrawShowForPlayer(playerid, MainMenuTxtdraw[10]);
}

stock HideMainMenuGUI(playerid)
{
	InsideMainMenu{playerid} = false;

	TextDrawHideForPlayer(playerid, MainMenuTxtdraw[0]);
	TextDrawHideForPlayer(playerid, MainMenuTxtdraw[1]);
	TextDrawHideForPlayer(playerid, MainMenuTxtdraw[2]);
	TextDrawHideForPlayer(playerid, MainMenuTxtdraw[3]);
	TextDrawHideForPlayer(playerid, MainMenuTxtdraw[4]);
	TextDrawHideForPlayer(playerid, MainMenuTxtdraw[5]);
	TextDrawHideForPlayer(playerid, MainMenuTxtdraw[6]);
	TextDrawHideForPlayer(playerid, MainMenuTxtdraw[9]);
	TextDrawHideForPlayer(playerid, MainMenuTxtdraw[10]);
}

CheckPasswordComplexity(const password[])
{
	if(!(8 <= strlen(password) <= 64)) return 0;
	new i = 0, containsletters, containsnumbers, containsspecial;
	while(password[i] != '\0')
	{
		if('a' <= password[i] <= 'z') containsletters = 1;
		else if('A' <= password[i] <= 'Z') containsletters = 1;
		else if('0' <= password[i] <= '9') containsnumbers = 1;
		// !"#$%&'()*+,-./ :;<=>?@[\]^_`  {|}~
		else if(33 <= password[i] <= 47 || 58 <= password[i] <= 64 || 91 <= password[i] <= 96 || 123 <= password[i] <= 126) containsspecial = 1;
		if(containsletters && containsnumbers && containsspecial) break;
		i++;
	}
	if(!containsletters || !containsnumbers || !containsspecial) return 0;
	return 1;
}

forward LoginCheck(playerid);
public LoginCheck(playerid)
{
	if(gPlayerLogged{playerid} == 0 && IsPlayerConnected(playerid))
	{
		new string[128];
		format(string, sizeof(string), "%s(%d) [%s] has timed out of the login screen.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid));
		Log("logs/security.log", string);
		SendClientMessage(playerid, COLOR_WHITE, "SERVER: Login timeout - you must login within 60 seconds!");
		ShowPlayerDialog(playerid, -1, DIALOG_STYLE_MSGBOX, "", "", "", "");
		SetTimerEx("KickEx", 1000, 0, "i", playerid);
	}
	return 1;
}

stock ShowLoginDialogs(playerid, index)
{
	new string[128];
	switch(index)
	{
		case 0:
		{
			ShowPlayerDialog(playerid, DIALOG_CHANGEPASS2, DIALOG_STYLE_INPUT, "Password Change Required!", "Please enter a new password for your account.", "Change", "Exit" );
			if(PassComplexCheck) ShowPlayerDialog(playerid, DIALOG_CHANGEPASS2, DIALOG_STYLE_INPUT, "Password Change Required!", "Please enter a new password for your account.\n\n\
			- You can't select a password that's below 8 or above 64 characters\n\
			- Your password must contain a combination of letters, numbers and special characters.\n\
			- Invalid Character: %", "Change", "Exit" );
		}
		case 1: ShowPlayerDialog(playerid, REGISTERMONTH, DIALOG_STYLE_LIST, "{FF0000}Which month was your character born?", "January\nFebruary\nMarch\nApril\nMay\nJune\nJuly\nAugust\nSeptember\nOctober\nNovember\nDecember", "Submit", "");
		case 4: ShowPlayerDialog(playerid, PMOTDNOTICE, DIALOG_STYLE_MSGBOX, "Notice", pMOTD, "Dismiss", "");
		case 5:
		{
			format(string, sizeof(string), "You have recieved {FFD700}%s{A9C4E4} credits! Use /shophelp for more information.", number_format(PlayerInfo[playerid][pReceivedCredits]));
			ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Credits Received!", string, "Close", "");

			new szLog[128];
			format(szLog, sizeof(szLog), "[ISSUED] [User: %s(%i)] [IP: %s] [Credits: %s]", GetPlayerNameEx(playerid), PlayerInfo[playerid][pId], GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pReceivedCredits]));
			Log("logs/logincredits.log", szLog), print(szLog);

			PlayerInfo[playerid][pReceivedCredits] = 0;
		}
	}
	return 1;
}