/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Marriage System

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

stock ClearMarriage(playerid)
{
	if(IsPlayerConnected(playerid)) {
		new string[MAX_PLAYER_NAME];
		format(string, sizeof(string), "Nobody");
		strmid(PlayerInfo[playerid][pMarriedName], string, 0, strlen(string), MAX_PLAYER_NAME);
		PlayerInfo[playerid][pMarriedID] = -1;
	}
	return 1;
}

CMD:divorce(playerid, params[])
{
	if(!IsAJudge(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not part of the Judicial System!");
	if(PlayerInfo[playerid][pRank] < 5) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command - only rank 5+ can do this.");
	new targets[2];
	if(sscanf(params, "uu", targets[0], targets[1])) return SendClientMessageEx(playerid, COLOR_GRAD1, "USAGE: /divorce [Part Of Name/ ID] [Part Of Name/ ID]");
	if(!IsPlayerConnected(targets[0]) || !IsPlayerConnected(targets[1])) return SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid player(s) specified.");
	if(strcmp(GetPlayerNameEx(targets[0]), PlayerInfo[targets[1]][pMarriedName], true) != 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "The two players specified aren't married to one another.");
	if(!ProxDetectorS(25.0, playerid, targets[0]) || !ProxDetectorS(25.0, playerid, targets[1])) return SendClientMessageEx(playerid, COLOR_GRAD1, "You aren't near the couple you are attempting to divorce.");
	ClearMarriage(targets[0]);
	ClearMarriage(targets[1]);
	szMiscArray[0] = 0;
	format(szMiscArray, sizeof(szMiscArray), "You have divorced %s and %s.", GetPlayerNameEx(targets[0]), GetPlayerNameEx(targets[1]));
	SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMiscArray);
	format(szMiscArray, sizeof(szMiscArray), "You have been divorced from %s by %s.", GetPlayerNameEx(targets[1]), GetPlayerNameEx(playerid));
	SendClientMessageEx(targets[0], COLOR_LIGHTBLUE, szMiscArray);
	format(szMiscArray, sizeof(szMiscArray), "You have been divorced from %s by %s.", GetPlayerNameEx(targets[0]), GetPlayerNameEx(playerid));
	SendClientMessageEx(targets[1], COLOR_LIGHTBLUE, szMiscArray);
	format(szMiscArray, sizeof(szMiscArray), "%s has divorced %s and %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(targets[0]), GetPlayerNameEx(targets[1]));
	GroupLog(PlayerInfo[playerid][pMember], szMiscArray);
	return 1;
}

/*CMD:divorce(playerid, params[])
{
	if(PlayerInfo[playerid][pMarriedID] == -1) return SendClientMessageEx(playerid, COLOR_GREY, "You're not married!");

	new string[128], giveplayerid;
	if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /divorce [player]");

	if(IsPlayerConnected(giveplayerid))
	{
		if (ProxDetectorS(8.0, playerid, giveplayerid))
		{
			new dstring[MAX_PLAYER_NAME];
			new wstring[MAX_PLAYER_NAME];
			new giveplayer[MAX_PLAYER_NAME];
			GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
			format(string, sizeof(string), "%s", giveplayer);
			strmid(wstring, string, 0, strlen(string), 24);
			format(string, sizeof(string), "%s", PlayerInfo[playerid][pMarriedName]);
			strmid(dstring, string, 0, strlen(string), 24);
			if(strcmp(dstring ,wstring, true ) == 0 )
			{
				format(string, sizeof(string), "* You've sent Divorce Papers to %s.", GetPlayerNameEx(giveplayerid));
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
				format(string, sizeof(string), "* %s just sent you their Divorce Papers (type /accept divorce) to accept.", GetPlayerNameEx(playerid));
				SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
				DivorceOffer[giveplayerid] = playerid;
				return 1;
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GREY, "   That person is not Married to you!");
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
}*/

CMD:adivorce(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 3)
	{
		new string[128], giveplayerid;
		if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /adivorce [player]");

		if(IsPlayerConnected(giveplayerid))
		{
			if(PlayerInfo[giveplayerid][pMarriedID] != -1)
			{
				foreach(new i: Player)
				{
					if(PlayerInfo[i][pMarriedID] == GetPlayerSQLId(giveplayerid)) ClearMarriage(i);
				}
				mysql_format(MainPipeline, string, sizeof(string), "UPDATE `accounts` SET `MarriedID` = -1 WHERE id = %d", PlayerInfo[giveplayerid][pMarriedID]);
				mysql_tquery(MainPipeline, string, "OnQueryFinish", "i", SENDDATA_THREAD);
			}
			ClearMarriage(giveplayerid);
			format(string, sizeof(string), "* You've admin divorced %s.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
			format(string, sizeof(string), "* You have been admin divorced by an admin.", GetPlayerNameEx(playerid));
			SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
			return 1;
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
		return 1;
	}
}

CMD:propose(playerid, params[])
{
	if(GetPlayerCash(playerid) < 100000) return SendClientMessageEx(playerid, COLOR_GREY, "   The marriage and reception costs $100,000!");
	if(PlayerInfo[playerid][pMarriedID] != -1) return SendClientMessageEx(playerid, COLOR_GREY, "   You're already married!");

	new string[128], giveplayerid;
	if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /propose [player]");

	if(IsPlayerConnected(giveplayerid))
	{
		if(PlayerInfo[giveplayerid][pMarriedID] != -1) return SendClientMessageEx(playerid, COLOR_GREY, "   That person is already married!");
		else if(MarryWitness[playerid] == giveplayerid || MarryWitnessOffer[giveplayerid] == playerid) return SendClientMessageEx(playerid, COLOR_GREY, "   You can't marry the witness!");

		if(ProxDetectorS(8.0, playerid, giveplayerid))
		{
			if(giveplayerid == playerid) { SendClientMessageEx(playerid, COLOR_GREY, "You cannot Propose to yourself!"); return 1; }
			format(string, sizeof(string), "* You proposed to %s.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
			format(string, sizeof(string), "* %s just proposed to you (type /accept marriage) to accept.", GetPlayerNameEx(playerid));
			SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
			ProposeOffer[giveplayerid] = playerid;
			ShowPlayerDialogEx(playerid, DIALOG_MARRIAGE, DIALOG_STYLE_MSGBOX, "Marriage Last Name", 
			"As the proposer you have the initial option to keep your last name or use your spouse's.\n\
			If you decide to keep your last name, your spouse will be given same option.\n\
			Please use the buttons below to make your decision.", "Keep", "Use Their's");
		}
		else return SendClientMessageEx(playerid, COLOR_GREY, "That person isn't near you.");

	}
	else return SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");
	return 1;
}

CMD:witness(playerid, params[])
{
	new string[128], giveplayerid;
	if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /witness [player]");

	if(IsPlayerConnected(giveplayerid))
	{
		if (ProxDetectorS(8.0, playerid, giveplayerid))
		{
			if(giveplayerid == playerid) { SendClientMessageEx(playerid, COLOR_GREY, "You cannot Propose to yourself!"); return 1; }
			if(ProposeOffer[giveplayerid] == playerid) { SendClientMessageEx(playerid, COLOR_GREY, "Your spouse can't be the marriage witness!"); return 1; }
			format(string, sizeof(string), "* You requested %s to be your Marriage Witness.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
			format(string, sizeof(string), "* %s just requested you to be their Marriage Witness (type /accept witness) to accept.", GetPlayerNameEx(playerid));
			SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
			MarryWitnessOffer[giveplayerid] = playerid;
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
