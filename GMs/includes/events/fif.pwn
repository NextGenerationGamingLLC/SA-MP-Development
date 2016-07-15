/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

					Fall into Fun Event

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

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	switch(dialogid)
	{
		case DIALOG_FIFMENU:
		{
			if(!response) return 1;
			if(PlayerInfo[playerid][pPR] < 2 && PlayerInfo[playerid][pAdmin] < 1338) return 1;
			switch(listitem)
			{
				case 0:
				{
					if(FIFEnabled == 0)
					{
						FIFEnabled = 1; 
						SendClientMessageEx(playerid, COLOR_WHITE, "You have enabled the Fall Into Fun hours.");
						if(IsValidDynamicPickup(FIFPickup)) DestroyDynamicPickup(FIFPickup);
						if(IsValidDynamic3DTextLabel(FIFText)) DestroyDynamic3DTextLabel(FIFText);
						FIFPickup = CreateDynamicPickup(1239, 23, FIFGamble[0], FIFGamble[1], FIFGamble[2], 0);
						FIFText = CreateDynamic3DTextLabel("Chance Gambler\n/gamblechances to risk all of your chances or double them", COLOR_RED, FIFGamble[0], FIFGamble[1], FIFGamble[2]+0.5,10.0);
					}
					else if(FIFEnabled == 1)
					{
						FIFEnabled = 0; 
						SendClientMessageEx(playerid, COLOR_WHITE, "You have disabled the Fall Into Fun hours.");
						if(IsValidDynamicPickup(FIFPickup)) DestroyDynamicPickup(FIFPickup);
						if(IsValidDynamic3DTextLabel(FIFText)) DestroyDynamic3DTextLabel(FIFText);
					}
				}
				case 1:
				{
					switch(FIFType)
					{
						case 1:
						{
							ShowPlayerDialogEx(playerid, DIALOG_FIFMENU2, DIALOG_STYLE_LIST, "FIF Mode Edit", "{00FF00}Normal Mode (1 chance / 3 hours){FFFFFF}\nDouble Mode (2 chances / 3 hours)\nTriple Mode(3 chances / 3 hours)", "Select", "Cancel");
						}
						case 2:
						{
							ShowPlayerDialogEx(playerid, DIALOG_FIFMENU2, DIALOG_STYLE_LIST, "FIF Mode Edit", "Normal Mode (1 chance / 3 hours)\n{00FF00}Double Mode (2 chances / 3 hours){FFFFFF}\nTriple Mode(3 chances / 3 hours)", "Select", "Cancel");
						}
						case 3:
						{
							ShowPlayerDialogEx(playerid, DIALOG_FIFMENU2, DIALOG_STYLE_LIST, "FIF Mode Edit", "Normal Mode (1 chance / 3 hours)\nDouble Mode (2 chances / 3 hours)\n{00FF00}Triple Mode(3 chances / 3 hours){FFFFFF}", "Select", "Cancel");
						}
					}
				}
				case 2:
				{
					if(FIFGP3 == 0)
					{
						FIFGP3 = 1;
						SendClientMessageEx(playerid, COLOR_WHITE, "Gold & Platinum VIP x3 Enabled.");
					}
					else
					{
						FIFGP3 = 0;
						SendClientMessageEx(playerid, COLOR_WHITE, "Gold & Platinum VIP x3 Disabled.");
					}
				}
				case 3:
				{
					if(FIFTimeWarrior == 0)
					{
						FIFTimeWarrior = 1;
						SendClientMessageEx(playerid, COLOR_WHITE, "Time Warrior Enabled.");
					}
					else
					{
						FIFTimeWarrior = 0;
						SendClientMessageEx(playerid, COLOR_WHITE, "Time Warrior Disabled.");
					}
				}
				case 4:
				{
					if(FIFGThurs == 0)
					{
						FIFGThurs = 1;
						SendClientMessageEx(playerid, COLOR_WHITE, "Golden Thursday Enabled.");
					}
					else
					{
						FIFGThurs = 0;
						SendClientMessageEx(playerid, COLOR_WHITE, "Golden Thursday Disabled.");
					}
				}
				case 5:
				{
					GetPlayerPos(playerid, FIFGamble[0], FIFGamble[1], FIFGamble[2]);
					if(IsValidDynamicPickup(FIFPickup)) DestroyDynamicPickup(FIFPickup);
					if(IsValidDynamic3DTextLabel(FIFText)) DestroyDynamic3DTextLabel(FIFText);
					FIFPickup = CreateDynamicPickup(1239, 23, FIFGamble[0], FIFGamble[1], FIFGamble[2], -1, -1, -1, 100.0);
					FIFText = CreateDynamic3DTextLabel("Chance Gambler\n/gamblechances to risk all of your chances or double them", COLOR_RED, FIFGamble[0], FIFGamble[1], FIFGamble[2]+0.5,10.0);  
					SendClientMessageEx(playerid, COLOR_WHITE, "FIF Gamble Position Updated");
				}
			}
			Misc_Save();
		}
		case DIALOG_FIFMENU2:
		{
			if(!response) return 1;
			if(PlayerInfo[playerid][pPR] < 2 && PlayerInfo[playerid][pAdmin] < 1338) return 1;
			switch(listitem)
			{
				case 0:
				{
					FIFType = 1;
					SendClientMessageEx(playerid, COLOR_WHITE, "FIF Mode set to x1");
				}
				case 1:
				{
					FIFType = 2;
					SendClientMessageEx(playerid, COLOR_WHITE, "FIF Mode set to x2");
				}
				case 2:
				{
					FIFType = 3;
					SendClientMessageEx(playerid, COLOR_WHITE, "FIF Mode set to x3");
				}
			}
			Misc_Save();
		}
	}
	return 0;
}

#if defined event_chancegambler
CMD:togchancegambler(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pPR] >= 2)
	{
		if(chancegambler == 0)
		{
			chancegambler = 1;
			SendClientMessageEx(playerid, COLOR_WHITE, "You have enabled the chance gambler event.");
		}
		else
		{
			chancegambler = 0;
			SendClientMessageEx(playerid, COLOR_WHITE, "You have disabled the chance gambler event.");
		}
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD2, "You're not authorized to use this command.");
	return 1;
}

CMD:gamblechances(playerid, params[])
{
	if(FIFEnabled == 1)
	{
		new iChances = FIFInfo[playerid][FIFChances];
		if(iChances < 1)
			return SendClientMessageEx(playerid, COLOR_GREY, "You don't have any chances to gamble.");
		if(!IsPlayerInRangeOfPoint(playerid, 20, FIFGamble[0], FIFGamble[1], FIFGamble[2]))
			return SendClientMessageEx(playerid, COLOR_GREY, "You aren't at the chance gambler location.");
		ShowPlayerDialogEx(playerid, DIALOG_ROLL, DIALOG_STYLE_MSGBOX, "Chance Gambler! - All or Nothing","You must roll a number greater than 4 to double your chances.", "Roll", "Cancel");
	}
	else return 0;
	return 1;
}
#endif
 
CMD:chances(playerid, params[])
{
	if(chancegambler == 1)
	{
		new szMessage[128],
			iChances = PlayerInfo[playerid][pRewardDrawChance] / 3;
		format(szMessage, sizeof(szMessage), "Chances: %d", iChances);
		SendClientMessageEx(playerid, COLOR_CYAN, szMessage);
	}
	else return 0;
	return 1;
}

CMD:fifmenu(playerid, params[])
{
	if(PlayerInfo[playerid][pPR] >= 2 || PlayerInfo[playerid][pAdmin] >= 1337)
	{
		new FIFString[256];
		if(FIFEnabled == 0)
		{
			format(FIFString, sizeof(FIFString), "{00FF00}Enable Fall Into Fun{FFFFFF}\nSet Hour Type");
		}
		else 
		{
			format(FIFString, sizeof(FIFString), "{B70000}Disable Fall Into Fun{FFFFFF}\nSet Hour Type");
		}
		if(FIFGP3 == 0)
		{
			format(FIFString, sizeof(FIFString), "%s\n{00FF00}Enable GVIP & PVIP x3{FFFFFF}", FIFString);
		}
		else
		{
			format(FIFString, sizeof(FIFString), "%s\n{B70000}Enable GVIP & PVIP x3{FFFFFF}", FIFString);
	
		}
		if(FIFTimeWarrior == 0)
		{
			format(FIFString, sizeof(FIFString), "%s\n{00FF00}Enable Time Warrior{FFFFFF}", FIFString);
		}
		else
		{
			format(FIFString, sizeof(FIFString), "%s\n{B70000}Disable Time Warrior{FFFFFF}", FIFString);
	
		}
		if(FIFGThurs == 0)
		{
			format(FIFString, sizeof(FIFString), "%s\n{00FF00}Enable Golden Thursday{FFFFFF}", FIFString);
		}
		else
		{
			format(FIFString, sizeof(FIFString), "%s\n{B70000}Disable Golden Thursday{FFFFFF}", FIFString);
	
		}
		format(FIFString,sizeof(FIFString), "%s\nSet Chance Gambler Position", FIFString);
		ShowPlayerDialogEx(playerid, DIALOG_FIFMENU, DIALOG_STYLE_LIST, "Fall Into Fun Menu", FIFString, "Select", "Cancel");
	}
	return 1;
}

CMD:festivalload(playerid, params[]) {

	if(PlayerInfo[playerid][pAdmin] < 1338) return 1;

	if(!GetGVarType("FallLoaded")) {
		SendRconCommand("loadfs FallFestival2014");
		SendRconCommand("loadfs FallFestival2014mapping");
		SendClientMessageEx(playerid, COLOR_GREY, "Fall Festival Loaded");
		SetGVarInt("FallLoaded", 1);
	}
	else {
		SendRconCommand("unloadfs FallFestival2014");
		SendRconCommand("unloadfs FallFestival2014mapping");
		SendClientMessageEx(playerid, COLOR_GREY, "Fall Festival unloaded");
		DeleteGVar("FallLoaded");
	}


	return 1;
}