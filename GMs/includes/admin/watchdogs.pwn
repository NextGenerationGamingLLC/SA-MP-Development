/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Watchdog System

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

CMD:nextwatch(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 2) return SendClientMessageEx(playerid, COLOR_GRAD1, "Please use /spec to avoid issues.");
	if(PlayerInfo[playerid][pWatchdog] >= 1)
	{
		if(GetPVarInt(playerid, "StartedWatching") == 0) return cmd_startwatch(playerid, params);
		
		if(gettime() >= GetPVarInt(playerid, "NextWatch")) return mysql_tquery(MainPipeline, "SELECT * FROM `nonrppoints` WHERE `active` = '1' ORDER BY `point` DESC", "WatchWatchlist", "i", playerid);
		else if(PlayerInfo[playerid][pWatchdog] >= 2) return mysql_tquery(MainPipeline, "SELECT * FROM `nonrppoints` WHERE `active` = '1' ORDER BY `point` DESC", "WatchWatchlist", "i", playerid);
		else
		{
			new string[60];
			format(string, sizeof(string), "You can't skip a player yet, you have to wait %d seconds!", GetPVarInt(playerid, "NextWatch")-gettime());
			return SendClientMessageEx(playerid, COLOR_GRAD1, string);
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You're not authorized to use this command!");
	}
	return true;
}

CMD:watchspec(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 2) return SendClientMessageEx(playerid, COLOR_GRAD1, "Please use /spec to avoid issues.");
	if(PlayerInfo[playerid][pWatchdog] >= 2)
	{
		new giveplayerid;
		if(GetPVarInt(playerid, "StartedWatching") == 1) return SendClientMessageEx(playerid, COLOR_GRAD1, "WATCHDOG: You already started watching.");
		if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "USAGE: /watchspec [player]");
		if(giveplayerid == playerid) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot spectate yourself!");
		if(PlayerInfo[giveplayerid][pWatchlist] == 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "This player is not on the watchlist!");
		
		SpectatePlayer(playerid, giveplayerid);
		SendClientMessageEx(playerid, -1, "WATCHDOG: You have started watching.");
		SetPVarInt(playerid, "SpectatingWatch", giveplayerid);
		SetPVarInt(playerid, "StartedWatching", 1);
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You're not authorized to use this command!");
	}
	return true;
}		

CMD:startwatch(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 2) return SendClientMessageEx(playerid, COLOR_GRAD1, "Please use /spec to avoid issues.");
	if(PlayerInfo[playerid][pWatchdog] >= 1)
	{
		if(GetPVarInt(playerid, "StartedWatching") == 1) return SendClientMessageEx(playerid, COLOR_GRAD1, "WATCHDOG: You already started watching.");
		if(gettime() >= GetPVarInt(playerid, "NextWatch")) return mysql_tquery(MainPipeline, "SELECT * FROM `nonrppoints` WHERE `active` = '1' ORDER BY `point` DESC", "WatchWatchlist", "i", playerid);
		else if(PlayerInfo[playerid][pWatchdog] >= 2) return mysql_tquery(MainPipeline, "SELECT * FROM `nonrppoints` WHERE `active` = '1' ORDER BY `point` DESC", "WatchWatchlist", "i", playerid);
		else
		{
			new string[60];
			format(string, sizeof(string), "You can't skip a player yet, you have to wait %d seconds!", GetPVarInt(playerid, "NextWatch")-gettime());
			return SendClientMessageEx(playerid, COLOR_GRAD1, string);
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You're not authorized to use this command!");
	}
	return true;
}

CMD:stopwatch(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 2) return SendClientMessageEx(playerid, COLOR_GRAD1, "Please use /spec to avoid issues.");
	if(PlayerInfo[playerid][pWatchdog] >= 1)
	{
		if(GetPVarInt(playerid, "StartedWatching") == 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "WATCHDOG: You aren't spectating anybody.");
		
		SetPVarInt(playerid, "StartedWatching", 0);
		if(Spectating[playerid] > 0)
		{
			SetPVarInt(GetPVarInt(playerid, "SpectatingWatch"), "BeingSpectated", 0);
			GettingSpectated[Spectate[playerid]] = INVALID_PLAYER_ID;
			Spectating[playerid] = 0;
			SpecTime[playerid] = 0;
			Spectate[playerid] = INVALID_PLAYER_ID;
			SetPVarInt(playerid, "SpecOff", 1 );
			TogglePlayerSpectating(playerid, false);
			SetCameraBehindPlayer(playerid);
			DeletePVar(playerid, "SpectatingWatch");
			SendClientMessageEx(playerid, -1, "WATCHDOG: You have stopped watching.");
		}
		else return SendClientMessageEx(playerid, COLOR_GRAD1, "WATCHDOG: You're not watching anybody.");
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You're not authorized to use this command!");
	}
	return true;
}

CMD:dmrmute(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] >= 3)
	{
		new string[128], giveplayerid;
		if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /dmrmute [player]");

		if(IsPlayerConnected(giveplayerid))
		{
			if(PlayerInfo[giveplayerid][pDMRMuted] == 0)
			{
			    PlayerInfo[giveplayerid][pDMRMuted] = 1;
				format(string, sizeof(string), "AdmCmd: %s has indefinitely blocked %s from submitting DM reports.",GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
				ABroadCast(COLOR_LIGHTRED,string,2);
				format(string, sizeof(string), "You have been blocked from submitting /dmreports by %s.", GetPlayerNameEx(playerid));
				SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
				format(string, sizeof(string), "AdmCmd: %s(%d) was blocked from /dmreport by %s", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), GetPlayerNameEx(playerid));
				Log("logs/mute.log", string);
			}
			else
			{
			    if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1) return SendClientMessageEx(playerid, COLOR_GREY, "You must be a senior admin to unmute others from submitting DM reports");
				PlayerInfo[giveplayerid][pDMRMuted] = 0;
				format(string, sizeof(string), "AdmCmd: %s has been re-allowed to submit DM reports by %s",GetPlayerNameEx(giveplayerid),GetPlayerNameEx(playerid));
				ABroadCast(COLOR_LIGHTRED,string,2);
				format(string, sizeof(string), "You have been re-allowed to submitting /dmreports again by %s.", GetPlayerNameEx(playerid));
				SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
				format(string, sizeof(string), "AdmCmd: %s(%d) was unblocked from /dmreport by %s", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), GetPlayerNameEx(playerid));
				Log("logs/mute.log", string);
			}
  }
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	}
	return 1;
}

CMD:dmreport(playerid, params[])
{
	if(PlayerInfo[playerid][pDMRMuted] != 0) return SendClientMessage(playerid, COLOR_GRAD2, "You are blocked from submitting DM reports.");
	new giveplayerid;
	if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_WHITE,"USAGE: /dmreport [playerid]");
	if(IsPlayerConnected(giveplayerid))
	{
		if(playerid == giveplayerid) return SendClientMessage(playerid, COLOR_WHITE, "You can't use this command on yourself!");
		if(PlayerInfo[giveplayerid][pAdmin] >= 2 && PlayerInfo[giveplayerid][pTogReports] != 1) return SendClientMessage(playerid, COLOR_WHITE, "You can't use this command on admins!");
		if(gettime() - ShotPlayer[giveplayerid][playerid] < 300)
	    {
			SetPVarInt(playerid, "pDMReport", giveplayerid);
			ShowPlayerDialogEx(playerid, DMRCONFIRM, DIALOG_STYLE_MSGBOX, "DM Report", "You personally witnessed the reported player death matching within the last 60 seconds. Abuse of this command could result in a temporary ban.", "Confirm", "Cancel");
		}
		else
		{
		    SendClientMessage(playerid, COLOR_WHITE, "You have not been shot by that person or have already reported them in the last 5 minutes.");
			SendClientMessage(playerid, COLOR_WHITE, "As a reminder, abuse of this system could lead to punishment up to a temporary ban.");
		}
	}
	return 1;
}


CMD:dmalert(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 2 && PlayerInfo[playerid][pAdmin] < 1338) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can't submit reports as an administrator.");
	if(PlayerInfo[playerid][pWatchdog] < 1) return SendClientMessageEx(playerid, COLOR_GRAD2, "You're not authorized to use this command!");
	if(!GetPVarType(playerid, "SpectatingWatch")) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can only use this command when you are spectating someone!");
	if(PlayerInfo[playerid][pRMuted] != 0) return ShowPlayerDialogEx(playerid,7955,DIALOG_STYLE_MSGBOX,"Report blocked","You are blocked from submitting any reports!\n\nTips when reporting:\n- Report what you need, not who you need.\n- Be specific, report exactly what you need.\n- Do not make false reports.\n- Do not flame admins.\n- Report only for in-game items.\n- For shop orders use the /shoporder command","Close", "");
	if(GetPVarType(playerid, "HasReport")) return SendClientMessageEx(playerid, COLOR_GREY, "You can only have 1 active report at a time.");
	JustReported[playerid]=25;
	new giveplayerid = GetPVarInt(playerid, "SpectatingWatch");
	new string[128];
	format(string, sizeof(string), "{FF0000}(DM Alert) %s (ID %d) is deathmatching.{FFFF91}", GetPlayerNameEx(giveplayerid), giveplayerid);
	SendReportToQue(playerid, string, 2, 1);
	SetPVarInt(playerid, "AlertedThisPlayer", giveplayerid);
	SetPVarInt(playerid, "AlertType", 1);
	AlertTime[playerid] = 300;
	foreach(new i : Player) if(PlayerInfo[i][pWatchdog] >= 1) SendClientMessageEx(i, COLOR_LIGHTBLUE, string);
	SendClientMessageEx(playerid, COLOR_YELLOW, "Your DM report message was sent to the Admins & Watchdogs.");
	SetPVarInt(playerid, "WDReport", 1);
	format(string, sizeof(string), "Please write a brief report on what you watched %s do.\n * 30 characters min", GetPlayerNameEx(giveplayerid));
	return ShowPlayerDialogEx(playerid, DIALOG_WDREPORT, DIALOG_STYLE_INPUT, "Incident Report - DM Alert", string, "Submit", "");
}

CMD:watchlistadd(playerid, params[])
{
	if(PlayerInfo[playerid][pWatchdog] >= 4 || PlayerInfo[playerid][pAdmin] >= 1337)
	{
		new points = 0, days, giveplayerid, string[128];
		if(sscanf(params, "ddI(0)", giveplayerid, days, points)) return SendClientMessageEx(playerid, COLOR_GRAD1, "USAGE: /watchlistadd [playerid] [days] [points (optional)]");
		
		if(IsPlayerConnected(giveplayerid))
		{
			if(PlayerInfo[giveplayerid][pAdmin] >= 2) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot put an administrator on the watchlist!");
			if(giveplayerid == playerid) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot put yourself on the watchlist!");
			if(days < 1 || days > 365) return SendClientMessageEx(playerid, COLOR_GRAD1, "Please specify an amount of days (1 to 365 Days).");
			if(points < 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid Points Specified!");
			if(PlayerInfo[giveplayerid][pWatchlist] == 1) return SendClientMessageEx(playerid, COLOR_GRAD1, "This player is already on the watchlist!");
			
			if(points > 0) AddNonRPPoint(giveplayerid, points, gettime()+2592000, "Manually Added", playerid, 1);
			PlayerInfo[giveplayerid][pWatchlist] = 1;
			PlayerInfo[giveplayerid][pNonRPMeter] += points;
			PlayerInfo[giveplayerid][pWatchlistTime] = gettime() + 86400 / days;
			
			format(string, sizeof(string), "You have manually added %s to the watchlist for %d days", GetPlayerNameEx(giveplayerid), days);
			SendClientMessageEx(playerid, COLOR_CYAN, string);
			
			format(string, sizeof(string), "%s has added %s(%d) to the watchlist", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid));
			Log("logs/watchlist.log", string);
		}
		else return SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid player specified!");
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not authorized to use this command!");
	return true;
}

CMD:watchlistremove(playerid, params[])
{
	if(PlayerInfo[playerid][pWatchdog] >= 4 || PlayerInfo[playerid][pAdmin] >= 1337)
	{
		new giveplayerid, string[128];
		if(sscanf(params, "d", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "USAGE: /watchlistremove [playerid]");
		
		if(IsPlayerConnected(giveplayerid))
		{
			if(PlayerInfo[giveplayerid][pAdmin] >= 2) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot perform this command on an administrator!");
			if(giveplayerid == playerid) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot perform this command on yourself!");
			if(PlayerInfo[giveplayerid][pWatchlist] == 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "This player is not on the watchlist!");
			
			PlayerInfo[giveplayerid][pWatchlist] = 0;
			PlayerInfo[giveplayerid][pWatchlistTime] = 0;
			
			format(string, sizeof(string), "You have removed %s from the watchlist.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_CYAN, string);
			
			format(string, sizeof(string), "%s has removed %s(%d) from the watchlist", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid));
			Log("logs/watchlist.log", string);
		}
		else return SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid player specified!");
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not authorized to use this command!");
	return true;
}

CMD:restrictaccount(playerid, params[])
{
	if(PlayerInfo[playerid][pWatchdog] >= 3 || PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1)
	{
		new giveplayerid, reason[64], string[128];
		if(sscanf(params, "ds[64]", giveplayerid, reason)) return SendClientMessageEx(playerid, COLOR_GRAD1, "USAGE: /restrictaccount [playerid] [reason]");
		
		if(IsPlayerConnected(giveplayerid))
		{
			if(PlayerInfo[giveplayerid][pAccountRestricted] == 1) return SendClientMessageEx(playerid, COLOR_GRAD1, "This player account is already restricted!");
			if(PlayerInfo[giveplayerid][pAdmin] >= 2) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot restrict an administrator account!");
			if(giveplayerid == playerid) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot restrict your own account!");
			
			PlayerInfo[giveplayerid][pAccountRestricted] = 1;
			ResetPlayerWeaponsEx(giveplayerid);
			format(string, sizeof(string), "You have restricted %s account.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_CYAN, string);
			format(string, sizeof(string), "Your account has been restricted by %s. You will not be able to drive a vehicle, give/take any damage or own any weapons", GetPlayerNameEx(playerid));
			SendClientMessageEx(giveplayerid, COLOR_CYAN, string);
			SendClientMessageEx(giveplayerid, COLOR_RED, "Note: To lift this restriction, please contact a member of the RP Improvement Team.");
			
			PlayerTextDrawShow(giveplayerid, AccountRestriction[giveplayerid]);
			PlayerTextDrawShow(giveplayerid, AccountRestrictionEx[giveplayerid]);
			
			format(string, sizeof(string), "AdmCmd: %s has restricted %s account, reason: %s", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), reason);
			ABroadCast(COLOR_LIGHTRED, string, 2);
			
			format(string, sizeof(string), "%s has restricted %s(%d) account, reason: %s", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), reason);
			Log("logs/restrictaccount.log", string);
		}
		else return SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid player specified.");
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not authorized to use this command!");
	return true;
}

CMD:unrestrictaccount(playerid, params[])
{
	if(PlayerInfo[playerid][pWatchdog] >= 3 || PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1)
	{
		new giveplayerid, string[128];
		if(sscanf(params, "d", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "USAGE: /unrestrictaccount [playerid]");
		
		if(IsPlayerConnected(giveplayerid))
		{
			if(PlayerInfo[giveplayerid][pAccountRestricted] == 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "This player account is not restricted!");
			if(PlayerInfo[giveplayerid][pAdmin] >= 2) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot unrestrict an administrator account!");
			if(giveplayerid == playerid) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot unrestrict your own account!");
			
			PlayerInfo[giveplayerid][pAccountRestricted] = 0;
			PlayerInfo[giveplayerid][pNonRPMeter] = 0; //fix for bug where non-rp points would remain after being unrestricted.
			
			format(string, sizeof(string), "You have unrestricted %s account.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_CYAN, string);
			format(string, sizeof(string), "Your account has been unrestricted by %s.", GetPlayerNameEx(playerid));
			SendClientMessageEx(giveplayerid, COLOR_CYAN, string);
			
			format(string, sizeof(string), "AdmCmd: %s has unrestricted %s account.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
			ABroadCast(COLOR_LIGHTRED, string, 2);
			
			PlayerTextDrawHide(giveplayerid, AccountRestriction[giveplayerid]);
			PlayerTextDrawHide(giveplayerid, AccountRestrictionEx[giveplayerid]);
			
			format(string, sizeof(string), "%s has unrestricted %s(%d) account", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid));
			Log("logs/restrictaccount.log", string);
		}
		else return SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid player specified.");
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not authorized to use this command!");
	return true;
}

CMD:watchdogs(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[playerid][pWatchdog] >= 1)
	{
		new string[128];
		SendClientMessageEx(playerid, COLOR_GRAD1, "Watchdogs Online:");
		foreach(new i : Player)
		{	
			if(PlayerInfo[i][pWatchdog] > 0)
			{
				if(PlayerInfo[i][pWatchdog] == 1) format(string, sizeof(string), "Watchdog %s (ID %i)", GetPlayerNameEx(i), i);
				else if(PlayerInfo[i][pWatchdog] == 2) format(string, sizeof(string), "Senior Watchdog %s (ID %i)", GetPlayerNameEx(i), i);
				else if(PlayerInfo[i][pWatchdog] == 3) format(string, sizeof(string), "RP Specialist %s (ID %i)", GetPlayerNameEx(i), i);
				else if(PlayerInfo[i][pWatchdog] == 4) format(string, sizeof(string), "Director of RP Improvement %s (ID %i)", GetPlayerNameEx(i), i);
				if((i == playerid || PlayerInfo[playerid][pWatchdog] >= 3) && PlayerInfo[i][pAdmin] < 2) format(string, sizeof(string), "%s (This Hour: %d | Today: %d)", string, WDReportHourCount[i], WDReportCount[i]);
				if(PlayerInfo[playerid][pToggledChats][17]) strcat(string, " (WD Chat Toggled)");
				SendClientMessageEx(playerid, COLOR_GRAD2, string);
			}
		}
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not authorized to use this command!");
	return true;
}

CMD:togwd(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 2 && PlayerInfo[playerid][pWatchdog] < 3) return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not authorized to use this command!");
	if(PlayerInfo[playerid][pToggledChats][17])
	{
		PlayerInfo[playerid][pToggledChats][17] = 0;
		SendClientMessageEx(playerid, COLOR_GRAD1, "** You have enabled the watchdog chat.");
	}
	else
	{
		PlayerInfo[playerid][pToggledChats][17] = 1;
		SendClientMessageEx(playerid, COLOR_GRAD1, "** You have disabled the watchdog chat.");
	}
	return 1;
}
		
CMD:wd(playerid, params[]) 
{
	if(PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[playerid][pWatchdog] >= 1) 
	{
		if(PlayerInfo[playerid][pWatchdog] < 3) PlayerInfo[playerid][pToggledChats][17] = 0;
		if(PlayerInfo[playerid][pToggledChats][17]) return SendClientMessageEx(playerid, COLOR_GREY, "You have watchdog chat disabled - /togwd to enable it.");
		if(!isnull(params)) 
		{
			szMiscArray[0] = 0;
			
			if(PlayerInfo[playerid][pAdmin] == 2) format(szMiscArray, sizeof(szMiscArray), "- Junior Admin %s: %s", GetPlayerNameEx(playerid), params);
			else if(PlayerInfo[playerid][pAdmin] == 3) format(szMiscArray, sizeof(szMiscArray), "- General Admin %s: %s", GetPlayerNameEx(playerid), params);
			else if(PlayerInfo[playerid][pAdmin] == 4) format(szMiscArray, sizeof(szMiscArray), "- Senior Admin %s: %s", GetPlayerNameEx(playerid), params);
			else if(PlayerInfo[playerid][pAdmin] == 1337) format(szMiscArray, sizeof(szMiscArray), "- Head Admin %s: %s", GetPlayerNameEx(playerid), params);
			else if(PlayerInfo[playerid][pAdmin] == 99999) format(szMiscArray, sizeof(szMiscArray), "- Executive Admin %s: %s", GetPlayerNameEx(playerid), params);
			else if(PlayerInfo[playerid][pWatchdog] == 1) format(szMiscArray, sizeof(szMiscArray), "** Watchdog %s: %s", GetPlayerNameEx(playerid), params);
			else if(PlayerInfo[playerid][pWatchdog] == 2) format(szMiscArray, sizeof(szMiscArray), "** Senior Watchdog %s: %s", GetPlayerNameEx(playerid), params);
			else if(PlayerInfo[playerid][pWatchdog] == 3) format(szMiscArray, sizeof(szMiscArray), "** RP Specialist %s: %s", GetPlayerNameEx(playerid), params);
			else if(PlayerInfo[playerid][pWatchdog] == 4) format(szMiscArray, sizeof(szMiscArray), "** Director of RP Improvement %s: %s", GetPlayerNameEx(playerid), params);
			else format(szMiscArray, sizeof(szMiscArray), "- Undefined Rank %s: %s", GetPlayerNameEx(playerid), params);

			foreach(new i : Player)
			{
				if((PlayerInfo[i][pAdmin] >= 2 || PlayerInfo[i][pWatchdog] >= 1) && PlayerInfo[playerid][pToggledChats][17] == 0)
				{
					ChatTrafficProcess(i, 0x2267F0FF, szMiscArray, 17);
				}
			}
		}
		else return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /wd [watchdog chat]");
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not authorized to use this command!");
	return true;
}

CMD:refer(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 2 && PlayerInfo[playerid][pAdmin] < 1338) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can't submit reports as an administrator.");
	new reason[100];
	if(PlayerInfo[playerid][pWatchdog] < 1) return SendClientMessageEx(playerid, COLOR_GRAD2, "You're not authorized to use this command!");
	if(!GetPVarType(playerid, "SpectatingWatch")) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can only use this command when you are spectating someone!");
	if(sscanf(params, "s[100]", reason)) return SendClientMessageEx(playerid, COLOR_GRAD1, "USAGE: /refer [details]");
	if(PlayerInfo[playerid][pRMuted] != 0) return ShowPlayerDialogEx(playerid,7955,DIALOG_STYLE_MSGBOX,"Report blocked","You are blocked from submitting any reports!\n\nTips when reporting:\n- Report what you need, not who you need.\n- Be specific, report exactly what you need.\n- Do not make false reports.\n- Do not flame admins.\n- Report only for in-game items.\n- For shop orders use the /shoporder command","Close", "");
 	if(GetPVarType(playerid, "HasReport")) return SendClientMessageEx(playerid, COLOR_GREY, "You can only have 1 active report at a time.");
	JustReported[playerid] = 25;
	new giveplayerid = GetPVarInt(playerid, "SpectatingWatch");
	new string[128];
	format(string, sizeof(string), "{FF0000}(Watchdog Alert) %s (ID %d) | Details: %s{FFFF91}", GetPlayerNameEx(giveplayerid), giveplayerid, reason);
	SendReportToQue(playerid, string, 2, 1);
	SetPVarInt(giveplayerid, "BeenAlerted", 1);
	SetPVarInt(playerid, "AlertedThisPlayer", giveplayerid);
	foreach(new i : Player) if(PlayerInfo[i][pWatchdog] >= 1) SendClientMessageEx(i, COLOR_LIGHTBLUE, string);
	SendClientMessageEx(playerid, COLOR_YELLOW, "Your Watch Dog Alert was sent to the Admins & Watchdogs.");
	SetPVarInt(playerid, "WDReport", 2);
	format(string, sizeof(string), "Please write a brief report on what you watched %s do.\n * 30 characters min", GetPlayerNameEx(giveplayerid));
	return ShowPlayerDialogEx(playerid, DIALOG_WDREPORT, DIALOG_STYLE_INPUT, "Incident Report - Refer", string, "Submit", "");
}

CMD:wdwhitelist(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pWatchdog] >= 4 || PlayerInfo[playerid][pASM] >= 1)
	{
		new string[128], query[256], giveplayer[MAX_PLAYER_NAME], ip[16];
		if(sscanf(params, "s[24]s[16]", giveplayer, ip))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /wdwhitelist [watchdog name] [IP]");
			return 1;
		}

		new tmpName[24], tmpIP[16];
		mysql_escape_string(giveplayer, tmpName);
		mysql_escape_string(ip, tmpIP);
		SetPVarString(playerid, "OnWDWhitelist", tmpName);

		mysql_format(MainPipeline, query, sizeof(query), "UPDATE `accounts` SET `SecureIP`='%s' WHERE `Username`='%s' AND `Watchdog` <= %d", tmpIP, tmpName, PlayerInfo[playerid][pWatchdog]);
		mysql_tquery(MainPipeline, query, "OnWDWhitelist", "i", playerid);

		format(string, sizeof(string), "Attempting to whitelist %s on %s's account...", tmpIP, tmpName);
		SendClientMessageEx(playerid, COLOR_YELLOW, string);
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not authorized to use this command!");
	return true;
}

CMD:watchlist(playerid, params[])
{
	if(PlayerInfo[playerid][pWatchdog] >= 1 || PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[playerid][pSMod] == 1)
	{
		if(FetchingWatchlist == 1) return SendClientMessageEx(playerid, COLOR_RED, "Please try again later, someone is already fetching the watchlist.");
		PublicSQLString = "";
		mysql_tquery(MainPipeline, "SELECT * FROM `nonrppoints` WHERE `active` = '1' AND `manual` = '1' ORDER BY `point` DESC", "FetchWatchlist", "i", playerid);
		
		SendClientMessageEx(playerid, COLOR_CYAN, "Fetching the watchlist...");
		FetchingWatchlist = 1;
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not authorized to use this command!");
	return true;
}

CMD:makewatchdog(playerid, params[])  {
	if(PlayerInfo[playerid][pAdmin] < 1337 && PlayerInfo[playerid][pWatchdog] < 3) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	new ivalue, iTargetID;
	if(sscanf(params, "ui", iTargetID, ivalue)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /makewatchdog [player] [level]");
	if(!IsPlayerConnected(iTargetID)) return SendClientMessageEx(playerid, COLOR_GRAD2, "Invalid player specified.");
	if(PlayerInfo[iTargetID][pHelper] >= 1) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot make Advisors Watchdogs!");
	if(PlayerInfo[iTargetID][pWatchdog] == ivalue) return SendClientMessageEx(playerid, COLOR_GREY, "This person already has this watchdog level.");
	if(PlayerInfo[playerid][pWatchdog] == 3 && ivalue >= 4) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot promote players to Watchdog Level 4+.");
	new szRank[128];
	switch(ivalue) {
		case 0: format(szRank, sizeof(szRank), "AdmCmd: %s has removed %s's watchdog rank.", GetPlayerNameEx(playerid), GetPlayerNameEx(iTargetID));
		case 1: format(szRank, sizeof(szRank), "AdmCmd: %s has made %s a Watchdog.", GetPlayerNameEx(playerid), GetPlayerNameEx(iTargetID));
		case 2: format(szRank, sizeof(szRank), "AdmCmd: %s has made %s a Senior Watchdog.", GetPlayerNameEx(playerid), GetPlayerNameEx(iTargetID));
		case 3: format(szRank, sizeof(szRank), "AdmCmd: %s has made %s a RP Specialist.", GetPlayerNameEx(playerid), GetPlayerNameEx(iTargetID));
		case 4: format(szRank, sizeof(szRank), "AdmCmd: %s has made %s the Director of RP Improvement.", GetPlayerNameEx(playerid), GetPlayerNameEx(iTargetID));
		default: format(szRank, sizeof(szRank), "AdmCmd: %s has made %s an undefined level watchdog.", GetPlayerNameEx(playerid), GetPlayerNameEx(iTargetID));
	}
	ABroadCast(COLOR_LIGHTRED, szRank, 2);
	switch(ivalue)
	{
		case 0: format(szRank, sizeof(szRank), "AdmCmd: %s(%d) has removed %s's(%d) watchdog rank.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerNameEx(iTargetID), GetPlayerSQLId(iTargetID));
		case 1: format(szRank, sizeof(szRank), "AdmCmd: %s(%d) has made %s(%d) a Watchdog.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerNameEx(iTargetID), GetPlayerSQLId(iTargetID));
		case 2: format(szRank, sizeof(szRank), "AdmCmd: %s(%d) has made %s(%d) a Senior Watchdog.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerNameEx(iTargetID), GetPlayerSQLId(iTargetID));
		case 3: format(szRank, sizeof(szRank), "AdmCmd: %s(%d) has made %s(%d) a RP Specialist.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerNameEx(iTargetID), GetPlayerSQLId(iTargetID));
		case 4: format(szRank, sizeof(szRank), "AdmCmd: %s(%d) has made %s(%d) the Director of RP Improvement.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerNameEx(iTargetID), GetPlayerSQLId(iTargetID));
		default: format(szRank, sizeof(szRank), "AdmCmd: %s(%d) has made %s(%d) an undefined level(%d) watchdog.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerNameEx(iTargetID), GetPlayerSQLId(iTargetID), ivalue);
	}

	PlayerInfo[iTargetID][pWatchdog] = ivalue;
	Log("logs/makewatchdog.log", szRank);

	switch(ivalue) {
		case 0: format(szRank, sizeof(szRank), "Your watchdog rank has been removed by %s.", GetPlayerNameEx(playerid));
		case 1: format(szRank, sizeof(szRank), "You have been made a Watchdog by %s.", GetPlayerNameEx(playerid));
		case 2: format(szRank, sizeof(szRank), "You have been made a Senior Watchdog by %s.", GetPlayerNameEx(playerid));
		case 3: format(szRank, sizeof(szRank), "You have been made a RP Specialist by %s.", GetPlayerNameEx(playerid));
		case 4: format(szRank, sizeof(szRank), "You have been made the Director of RP Improvement by %s.", GetPlayerNameEx(playerid));
		default: format(szRank, sizeof(szRank), "You have been made an undefined level watchdog by %s.", GetPlayerNameEx(playerid));
	}
	SendClientMessageEx(iTargetID, COLOR_LIGHTBLUE, szRank);

	switch(ivalue) {
		case 0: format(szRank, sizeof(szRank), "You have removed %s's watchdog rank.", GetPlayerNameEx(iTargetID));
		case 1: format(szRank, sizeof(szRank), "You have made %s a Watchdog.", GetPlayerNameEx(iTargetID));
		case 2: format(szRank, sizeof(szRank), "You have made %s a Senior Watchdog.", GetPlayerNameEx(iTargetID));
		case 3: format(szRank, sizeof(szRank), "You have made %s a RP Specialist.", GetPlayerNameEx(iTargetID));
		case 4: format(szRank, sizeof(szRank), "You have made %s the Director of RP Improvement.", GetPlayerNameEx(iTargetID));
		default: format(szRank, sizeof(szRank), "You have made %s an undefined level watchdog.", GetPlayerNameEx(iTargetID));
	}
	SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szRank);
	return 1;
}
