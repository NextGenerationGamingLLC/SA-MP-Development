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

#if defined event_chancegambler
CMD:togchancegambler(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 1338 || PlayerInfo[playerid][pPR] >= 2)
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
		ShowPlayerDialog(playerid, DIALOG_ROLL, DIALOG_STYLE_MSGBOX, "Chance Gambler! - All or Nothing","You must roll a number greater than 4 to double your chances.", "Roll", "Cancel");
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
	if(PlayerInfo[playerid][pPR] >= 2 || PlayerInfo[playerid][pAdmin] >= 1338)
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
		ShowPlayerDialog(playerid, DIALOG_FIFMENU, DIALOG_STYLE_LIST, "Fall Into Fun Menu", FIFString, "Select", "Cancel");
	}
	return 1;
}