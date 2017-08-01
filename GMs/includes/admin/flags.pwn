/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Flag System

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

CMD:viewflags(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 2)
	{
		new string[128];

		SendClientMessageEx(playerid, COLOR_YELLOW, "Player Flag Count List (/viewflag [player] to view):");
		new fCounter;
		foreach(new i: Player)
		{
			if(PlayerInfo[i][pFlagged] > 0)
			{
				format(string, sizeof(string), "%s(%d) Flag Count: %d.",GetPlayerNameEx(i),i,PlayerInfo[i][pFlagged]);
				SendClientMessageEx(playerid, COLOR_GRAD1, string);
				fCounter += 1;
			}
		}	
		if(fCounter <= 0)
		{
			SendClientMessageEx(playerid, COLOR_GRAD1, "None.");
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	}
	return 1;
}

CMD:viewflag(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 2)
	{
		new giveplayerid;
	    if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /viewflag [player]");
	    if(IsPlayerConnected(giveplayerid))
	    {
			DisplayFlags(playerid, giveplayerid);
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	}
	return 1;
}

CMD:oflag(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] >= 2)
	{
		new string[128], query[256], name[MAX_PLAYER_NAME], reason[64], month, day, year;
		if(sscanf(params, "s[24]s[64]", name, reason)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /oflag [player name] [reason]");
		getdate(year,month,day);

    	new giveplayerid = ReturnUser(name);
        if(IsPlayerConnected(giveplayerid))
		{
			AddFlag(giveplayerid, playerid, reason);
			SendClientMessage(playerid, COLOR_WHITE, "The person is online and has been flagged!");
			format(string, sizeof(string), "AdmCmd: %s was flagged by %s, reason: %s.", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid), reason);
			ABroadCast(COLOR_LIGHTRED, string, 2);

			format(string, sizeof(string), "%s was flagged by %s (%s).", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid), reason);
			Log("logs/flags.log", string);
		}
		else
		{
			new tmpReason[64], tmpName[24];
			mysql_escape_string(reason, tmpReason);
			mysql_escape_string(name, tmpName);
			SetPVarString(playerid, "OnAddFlag", tmpName);
			SetPVarString(playerid, "OnAddFlagReason", tmpReason);

			mysql_format(MainPipeline, query, sizeof(query), "SELECT id FROM `accounts` WHERE `Username`='%s'", tmpName);
			mysql_tquery(MainPipeline, query, "FlagQueryFinish", "iii", playerid, INVALID_PLAYER_ID, Flag_Query_Offline);

			format(string, sizeof(string), "Attempting to append %s's flag...", tmpName);
			SendClientMessageEx(playerid, COLOR_YELLOW, string);
		}
		return 1;
	}
	return 1;
}



CMD:flag(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] >= 2)
	{
		new string[128], giveplayerid, reason[64];
		if(sscanf(params, "us[64]", giveplayerid, reason)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /flag [player] [reason]");

		if(IsPlayerConnected(giveplayerid))
		{
			AddFlag(giveplayerid, playerid, reason);
			format(string, sizeof(string), "AdmCmd: %s was flagged by %s, reason: %s.", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid), reason);
			ABroadCast(COLOR_LIGHTRED, string, 2);

			format(string, sizeof(string), "%s was flagged by %s (%s).", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid), reason);
			Log("logs/flags.log", string);
			return 1;
		}
	}
	else SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid player specified.");
	return 1;
}

CMD:transferflag(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 2) return 1;
	new to, from, flagid;
	if(sscanf(params, "iuu", flagid, to, from)) return SendClientMessageEx(playerid, COLOR_GRAD2, "USAGE: /transferflag [flag] [to] [from]");
	if(!IsPlayerConnected(to)) return SendClientMessageEx(playerid, COLOR_GRAD2, "ERROR: That player is not connected (to)");
	if(!IsPlayerConnected(from)) return SendClientMessageEx(playerid, COLOR_GRAD2, "ERROR: That player is not connected (from)");
	if(to == from) return SendClientMessageEx(playerid, COLOR_GRAD2, "ERROR: You cannot transfer to the same person");
	new query[128];
	mysql_format(MainPipeline, query, sizeof(query), "SELECT id, flag, issuer, time, type FROM `flags` WHERE `fid` = %i", flagid);
	mysql_tquery(MainPipeline, query, "OnRequestTransferFlag", "iiii", playerid, flagid, to, from);
	return 1;
}

CMD:aviewflag(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 2) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	new giveplayerid;
	if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /aviewflag [player]");
	if(!IsPlayerConnected(giveplayerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "Error: Player is not connected!");
	return DisplayFlags(playerid, giveplayerid, 2);
}

CMD:aflag(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 2) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	new giveplayerid, reason[64];
	if(sscanf(params, "us[64]", giveplayerid, reason)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /aflag [player] [reason]");
	if(!IsPlayerConnected(giveplayerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid player specified.");
	AddFlag(giveplayerid, playerid, reason, 2);
	new string[128];
	format(string, sizeof(string), "AdmCmd: %s was admin flagged by %s, reason: %s.", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid), reason);
	ABroadCast(COLOR_LIGHTRED, string, 2);
	format(string, sizeof(string), "[AFLAG] %s was admin flagged by %s (%s).", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid), reason);
	Log("logs/flags.log", string);
	return 1;
}

CMD:deleteflag(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 2) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	return ShowPlayerDialogEx(playerid, FLAG_DELETE, DIALOG_STYLE_INPUT, "FLAG DELETION", "Which flag would you like to delete?", "Delete Flag", "Close");
}