/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Boxing System

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

/*CMD:setchamp(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 4)
	{
		new string[128], giveplayerid;
		if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /setchamp [player]");

		if(IsPlayerConnected(giveplayerid))
		{
			new giveplayer[MAX_PLAYER_NAME];
			GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
			new nstring[MAX_PLAYER_NAME];
			format(nstring, sizeof(nstring), "%s", giveplayer);
			strmid(Titel[TitelName], nstring, 0, strlen(nstring), 255);
			Titel[TitelWins] = PlayerInfo[giveplayerid][pWins];
			Titel[TitelLoses] = PlayerInfo[giveplayerid][pLoses];
			Misc_Save();
			format(string, sizeof(string), "* You have made %s the new Boxing Champion.", giveplayer);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);

		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");
			return 1;
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	}
	return 1;
}*/

CMD:boxstats(playerid, params[])
{
	if(PlayerInfo[playerid][pJob] != 12 && PlayerInfo[playerid][pJob2] != 12 && PlayerInfo[playerid][pJob3] != 12)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "   You are not a Boxer!");
		return 1;
	}

	new string[128], ttext[20];//Title
	new clevel = PlayerInfo[playerid][pBoxSkill];
	if(clevel >= 0 && clevel <= 50) { ttext = "Beginner"; }
	else if(clevel >= 51 && clevel <= 200) { ttext = "Amateur"; }
	else if(clevel >= 201 && clevel <= 400) { ttext = "Professional"; }
	new ntext[20];//NickName
	new level = PlayerInfo[playerid][pWins];
	if(level > 0 && PlayerInfo[playerid][pLoses] == 0)
	{
		ntext = "Undefeated";
	}
	else
	{
		if(level >= 0 && level <= 10) { ntext = "Newcomer"; }
		else if(level >= 11 && level <= 20) { ntext = "Touchy Fist"; }
		else if(level >= 21 && level <= 30) { ntext = "Nut Cracker"; }
		else if(level >= 31 && level <= 40) { ntext = "Tommygun"; }
		else if(level >= 41 && level <= 50) { ntext = "Skull Breaker"; }
		else if(level >= 51 && level <= 60) { ntext = "Light Speed"; }
		else if(level >= 61 && level <= 70) { ntext = "Unbroken Warrior"; }
		else if(level >= 71) { ntext = "Itallion Stallion"; }
	}
	SendClientMessageEx(playerid, COLOR_WHITE, "|__________________ Boxing Records __________________|");
	format(string, sizeof(string), "| Current Champion: %s, with [%d] Winnings and [%d] Losses.", Titel[TitelName],Titel[TitelWins],Titel[TitelLoses]);
	SendClientMessageEx(playerid, COLOR_GREY, string);
	format(string, sizeof(string), "| Current Title: %s.", ttext);
	SendClientMessageEx(playerid, COLOR_GREY, string);
	format(string, sizeof(string), "| Current NickName: %s.", ntext);
	SendClientMessageEx(playerid, COLOR_GREY, string);
	format(string, sizeof(string), "| Total Wins: %d.", PlayerInfo[playerid][pWins]);
	SendClientMessageEx(playerid, COLOR_GREY, string);
	format(string, sizeof(string), "| Total Losses: %d.", PlayerInfo[playerid][pLoses]);
	SendClientMessageEx(playerid, COLOR_GREY, string);
	SendClientMessageEx(playerid, COLOR_WHITE, "|____________________________________________________|");
	return 1;
}

CMD:train(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 3.0, 757.3734,5.7227,1000.7012) || IsPlayerInRangeOfPoint(playerid, 3.0, 758.43,-78.0,1000.65) || IsPlayerInRangeOfPoint(playerid, 3.0, 2903.371826, -2254.517333, 7.244657))
	{
		if(PlayerInfo[playerid][pDonateRank] >= 1)
		{
			ShowPlayerDialogEx(playerid, FIGHTMENU, DIALOG_STYLE_LIST, "Fighting Moves", "Boxing		$40000\nElbow		$40000\nKneehead	$40000\nKung-Fu	$40000\nGrabKick	$40000\nNormal", "Learn", "Cancel");
		}
		else
		{
			ShowPlayerDialogEx(playerid, FIGHTMENU, DIALOG_STYLE_LIST, "Fighting Moves", "Boxing		$50000\nElbow		$50000\nKneehead	$50000\nKung-Fu	$50000\nGrabKick	$50000\nNormal", "Learn", "Cancel");
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, " You are not at the learning area! (Inside gym)");
	}
	return 1;
}

CMD:fight(playerid, params[])
{
	if(PlayerInfo[playerid][pJob] != 12 && PlayerInfo[playerid][pJob2] != 12 && PlayerInfo[playerid][pJob3] != 12)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "   You are not a Boxer!");
		return 1;
	}
	if(InRing > 0)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "   There is already a Fight going on, wait for it to Finish!");
		return 1;
	}
	if(PlayerBoxing[playerid] > 0)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "   You are already Fighting!");
		return 1;
	}

	new string[128], giveplayerid;
	if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /fight [player]");

	if(IsPlayerConnected(giveplayerid))
	{
		if (ProxDetectorS(8.0, playerid, giveplayerid))
		{
			if(IsPlayerInRangeOfPoint(playerid,20.0,765.9343,0.2761,1000.7173) || IsPlayerInRangeOfPoint(playerid,20.0,768.48, -73.66, 1000.57))
			{
				if(giveplayerid == playerid) { SendClientMessageEx(playerid, COLOR_GREY, "You cannot Box with yourself!"); return 1; }
				format(string, sizeof(string), "* You offered a Boxing Challenge to %s.", GetPlayerNameEx(giveplayerid));
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
				format(string, sizeof(string), "* Boxer %s wants to Fight with you (type /accept boxing) to accept.", GetPlayerNameEx(playerid));
				SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
				BoxOffer[giveplayerid] = playerid;
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GRAD2," You are not at the Gym!");
				return 1;
			}
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "That person isn't near you.");
			return 1;
		}

	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");
		return 1;
	}
	return 1;
}
