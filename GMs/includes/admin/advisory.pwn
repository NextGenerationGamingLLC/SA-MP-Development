/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Advisory System

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


stock SendAdvisorMessage(color, string[])
{
	//foreach(new i: Player)
	for(new i = 0; i < MAX_PLAYERS; ++i)
	{
		if(IsPlayerConnected(i))
		{
			if((PlayerInfo[i][pAdmin] >= 1 || PlayerInfo[i][pHelper] >= 2 || PlayerInfo[i][pDonateRank] == 5 || PlayerInfo[i][pWatchdog] >= 1) && advisorchat[i])
			{
				SendClientMessageEx(i, color, string);
			}
		}
	}
}

stock SendDutyAdvisorMessage(color, string[])
{
	//foreach(new i: Player)
	for(new i = 0; i < MAX_PLAYERS; ++i)
	{
		if(IsPlayerConnected(i))
		{
			if(PlayerInfo[i][pHelper] >= 2 && GetPVarInt(i, "AdvisorDuty") == 1) {
				SendClientMessageEx(i, color, string);
			}
		}	
	}
}

CMD:advisors(playerid, params[])
{
    new string[128];
    if(PlayerInfo[playerid][pHelper] >= 1) {
        SendClientMessageEx(playerid, COLOR_GRAD1, "Advisors Online:");
        //foreach(new i: Player)
		for(new i = 0; i < MAX_PLAYERS; ++i)
		{
			if(IsPlayerConnected(i))
			{
				new tdate[11], thour[9], i_timestamp[3];
				getdate(i_timestamp[0], i_timestamp[1], i_timestamp[2]);
				format(tdate, sizeof(tdate), "%d-%02d-%02d", i_timestamp[0], i_timestamp[1], i_timestamp[2]);
				format(thour, sizeof(thour), "%02d:00:00", hour);

				if(PlayerInfo[i][pHelper] != 0 && PlayerInfo[i][pHelper] <= PlayerInfo[playerid][pHelper]) {
					if(PlayerInfo[i][pHelper] == 1 && PlayerInfo[i][pAdmin] < 2) {
						format(string, sizeof(string), "** Helper: %s	(Requests This Hour: %d | Requests Today: %d)", GetPlayerNameEx(i), ReportHourCount[i], ReportCount[i]);
					}
					if(PlayerInfo[i][pHelper] == 2&&PlayerInfo[i][pAdmin]<2) {
						format(string, sizeof(string), "** Community Advisor: %s	(Requests This Hour: %d | Requests Today: %d)", GetPlayerNameEx(i), ReportHourCount[i], ReportCount[i]);
					}
					if(PlayerInfo[i][pHelper] == 3&&PlayerInfo[i][pAdmin]<2) {
						format(string, sizeof(string), "** Senior Advisor: %s	(Requests This Hour: %d | Requests Today: %d)", GetPlayerNameEx(i), ReportHourCount[i], ReportCount[i]);
					}
					if(PlayerInfo[i][pHelper] >= 4&&PlayerInfo[i][pAdmin]<2) {
						format(string, sizeof(string), "** Chief Advisor: %s	(Requests This Hour: %d | Requests Today: %d)", GetPlayerNameEx(i), ReportHourCount[i], ReportCount[i]);
					}
					SendClientMessageEx(playerid, COLOR_GRAD2, string);
				}
			}	
        }
    }
    else if(PlayerInfo[playerid][pAdmin] >= 2) {
        SendClientMessageEx(playerid, COLOR_GRAD1, "Advisors Online:");
        //foreach(new i: Player)
		for(new i = 0; i < MAX_PLAYERS; ++i)
		{
			if(IsPlayerConnected(i))
			{
				if(PlayerInfo[i][pHelper] >= 1) {
					new tdate[11], thour[9], i_timestamp[3];
					getdate(i_timestamp[0], i_timestamp[1], i_timestamp[2]);
					format(tdate, sizeof(tdate), "%d-%02d-%02d", i_timestamp[0], i_timestamp[1], i_timestamp[2]);
					format(thour, sizeof(thour), "%02d:00:00", hour);

					if(PlayerInfo[i][pHelper] == 1&&PlayerInfo[i][pAdmin]<2) {
						format(string, sizeof(string), "** Helper: %s	(Requests This Hour: %d | Requests Today: %d)", GetPlayerNameEx(i), ReportHourCount[i], ReportCount[i]);
					}
					if(PlayerInfo[i][pHelper] == 2&&PlayerInfo[i][pAdmin]<2) {
						if(GetPVarInt(i, "AdvisorDuty") == 1) {
							format(string, sizeof(string), "** Community Advisor: %s (On Duty)	(Requests This Hour: %d | Requests Today: %d)", GetPlayerNameEx(i), ReportHourCount[i], ReportCount[i]);
						}
						else {
							format(string, sizeof(string), "** Community Advisor: %s	(Requests This Hour: %d | Requests Today: %d)", GetPlayerNameEx(i), ReportHourCount[i], ReportCount[i]);
						}
					}
					if(PlayerInfo[i][pHelper] == 3&&PlayerInfo[i][pAdmin]<2) {
						if(GetPVarInt(i, "AdvisorDuty") == 1) {
							format(string, sizeof(string), "** Senior Advisor: %s (On Duty)	(Requests This Hour: %d | Requests Today: %d)", GetPlayerNameEx(i), ReportHourCount[i], ReportCount[i]);
						}
						else {
							format(string, sizeof(string), "** Senior Advisor: %s	(Requests This Hour: %d | Requests Today: %d)", GetPlayerNameEx(i), ReportHourCount[i], ReportCount[i]);
						}
					}
					if(PlayerInfo[i][pHelper] >= 4&&PlayerInfo[i][pAdmin]<2) {
						if(GetPVarInt(i, "AdvisorDuty") == 1) {
							format(string, sizeof(string), "** Chief Advisor: %s (On Duty)	(Requests This Hour: %d | Requests Today: %d)", GetPlayerNameEx(i), ReportHourCount[i], ReportCount[i]);
						}
						else {
							format(string, sizeof(string), "** Chief Advisor: %s	(Requests This Hour: %d | Requests Today: %d)", GetPlayerNameEx(i), ReportHourCount[i], ReportCount[i]);
						}
					}
					SendClientMessageEx(playerid, COLOR_GRAD2, string);
				}
			}	
        }
    }
    else {
        SendClientMessageEx(playerid, COLOR_GRAD1, "If you have questions regarding gameplay, or the server use /newb.");
        SendClientMessageEx(playerid, COLOR_GRAD1, "If you see suspicious happenings/players /report [id] [reason].");
    }
    return 1;
}

CMD:cduty(playerid, params[])
{
    if(PlayerInfo[playerid][pHelper] >= 2)
	{
        if(GetPVarInt(playerid, "AdvisorDuty") == 1)
		{
            SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You are now off duty as a Community Advisor and will not receive calls anymore.");
            DeletePVar(playerid, "AdvisorDuty");
            Advisors -= 1;
        }
        else
		{
            SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You are now on duty as a Community Advisor and will receive calls from people in need.");
            SetPVarInt(playerid, "AdvisorDuty", 1);
            Advisors += 1;
        }
    }
    else
	{
        SendClientMessageEx(playerid, COLOR_GRAD1, "   You are not a Community Advisor!");
    }
    return 1;
}

CMD:nonewbie(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 3 || PlayerInfo[playerid][pHelper] >= 4)
	{
		if (!nonewbie)
		{
			nonewbie = 1;
			SendClientMessageToAllEx(COLOR_GRAD2, "Newbie chat channel disabled by an Admin/Advisor!");
		}
		else
		{
			nonewbie = 0;
			SendClientMessageToAllEx(COLOR_GRAD2, "Newbie chat channel enabled by an Admin/Advisor!");
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	}
	return 1;
}

CMD:tognewbie(playerid, params[])
{
	if (PlayerInfo[playerid][pNewbieTogged] == 0)
	{
		PlayerInfo[playerid][pNewbieTogged] = 1;
		SendClientMessageEx(playerid, COLOR_GRAD2, "You have disabled newbie chat.");
	}
	else
	{
		PlayerInfo[playerid][pNewbieTogged] = 0;
		SendClientMessageEx(playerid, COLOR_GRAD2, "You have enabled newbie chat.");
	}
	return 1;
}

CMD:checkrequestcount(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pHelper] >= 3 || PlayerInfo[playerid][pPR] > 0)
	{
		new string[128], adminname[MAX_PLAYER_NAME], tdate[11];
		if(sscanf(params, "s[24]s[11]", adminname, tdate)) return SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /checkrequestcount [advisor name] [date (YYYY-MM-DD)]");
		new giveplayerid = ReturnUser(adminname);
		if(IsPlayerConnected(giveplayerid))
		{
			format(string, sizeof(string), "SELECT SUM(count) FROM `tokens_request` WHERE `playerid` = %d AND `date` = '%s'", GetPlayerSQLId(giveplayerid), tdate);
			mysql_function_query(MainPipeline, string, true, "QueryCheckCountFinish", "issi", playerid, GetPlayerNameEx(giveplayerid), tdate, 2);
			format(string, sizeof(string), "SELECT `count`, `hour` FROM `tokens_request` WHERE `playerid` = %d AND `date` = '%s' ORDER BY `hour` ASC", GetPlayerSQLId(giveplayerid), tdate);
			mysql_function_query(MainPipeline, string, true, "QueryCheckCountFinish", "issi", playerid, GetPlayerNameEx(giveplayerid), tdate, 3);
		}
		else
		{
			new tmpName[MAX_PLAYER_NAME];
			mysql_escape_string(adminname, tmpName);
			format(string, sizeof(string), "SELECT `id`, `Username` FROM `accounts` WHERE `Username` = '%s'", tmpName);
			mysql_function_query(MainPipeline, string, true, "QueryUsernameCheck", "isi", playerid, tdate, 1);
		}
    }
    return 1;
}

CMD:hlban(playerid, params[])
{
	if(IsPlayerConnected(playerid))
	{
		if(PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[playerid][pHelper] >= 1)
		{
			new string[128], giveplayerid;
			if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /hlban [player]");

			if(IsPlayerConnected(giveplayerid))
			{
				if(PlayerInfo[giveplayerid][pHelper] >= 1 || PlayerInfo[giveplayerid][pAdmin] >= 1)
				{
					SendClientMessageEx(playerid, COLOR_GREY, "You can not ban admins/advisors/helpers from the helper channel!");
					return 1;
				}
				if(PlayerInfo[giveplayerid][pHelpMute] == 0)
				{
					PlayerInfo[giveplayerid][pHelpMute] = 1;

					//foreach(new n: Player)
					for(new n = 0; n < MAX_PLAYERS; ++n)
					{
						if(IsPlayerConnected(n))
						{
							if(gHelp[n]== 0)
							{
								format(string, sizeof(string), "* %s has been banned from the helper channel by %s.", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid));
								SendClientMessageEx(n, COLOR_JOINHELPERCHAT, string);
							}
						}	
					}
					if(gHelp[playerid] != 0)
					{
						format(string, sizeof(string), "* %s has been banned from the helper channel by %s.", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid));
						SendClientMessageEx(playerid, COLOR_JOINHELPERCHAT, string);
					}
                    gHelp[giveplayerid] = 1;

					format(string, sizeof(string), "You have been banned from helper channel by %s.", GetPlayerNameEx(playerid));
					SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
					format(string, sizeof(string), "AdmCmd: %s(%d) was banned from /hl by %s(%d)", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), GetPlayerNameEx(playerid), GetPlayerSQLId(playerid));
					Log("logs/mute.log", string);
				}
				else
				{
					PlayerInfo[giveplayerid][pHelpMute] = 0;

					//foreach(new n: Player)
					for(new n = 0; n < MAX_PLAYERS; ++n)
					{
						if(IsPlayerConnected(n))
						{
							if (gHelp[n]==0)
							{
								format(string, sizeof(string), "* %s has been unbanned from the helper channel by %s.", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid));
								SendClientMessageEx(n, COLOR_JOINHELPERCHAT, string);
							}
						}	
					}
					if(gHelp[playerid] != 0)
					{
						format(string, sizeof(string), "* %s has been unbanned from the helper channel by %s.", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid));
						SendClientMessageEx(playerid, COLOR_JOINHELPERCHAT, string);
					}

					format(string, sizeof(string), "You have been unbanned from helper channel by %s.", GetPlayerNameEx(playerid));
					SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
					format(string, sizeof(string), "AdmCmd: %s(%d) was unbanned from /hl by %s(%d)", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), GetPlayerNameEx(playerid), GetPlayerSQLId(playerid));
					Log("logs/mute.log", string);
				}

			}
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
		}
	}
	return 1;
}

CMD:newb(playerid, params[])
{
	if(gPlayerLogged{playerid} == 0) return SendClientMessageEx(playerid, COLOR_GREY, "You're not logged in.");
	if(PlayerInfo[playerid][pJailTime] && strfind(PlayerInfo[playerid][pPrisonReason], "[OOC]", true) != -1) return SendClientMessageEx(playerid, COLOR_GREY, "OOC prisoners are restricted to only speak in /b");
	if(PlayerInfo[playerid][pTut] == 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can't do that at this time.");
	if((nonewbie) && PlayerInfo[playerid][pAdmin] < 2) return SendClientMessageEx(playerid, COLOR_GRAD2, "The newbie chat channel has been disabled by an administrator!");
	if(PlayerInfo[playerid][pNMute] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "You are muted from the newbie chat channel.");
	if(PlayerInfo[playerid][pNewbieTogged] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "You have the channel toggled, /tognewbie to re-enable!");

	new string[128];
	if(gettime() < NewbieTimer[playerid])
	{
		format(string, sizeof(string), "You must wait %d seconds before speaking again in this channel.", NewbieTimer[playerid]-gettime());
		SendClientMessageEx(playerid, COLOR_GREY, string);
		return 1;
	}

	if(isnull(params)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: (/newb)ie [text]");

	if(PlayerInfo[playerid][pHelper] < 1 && PlayerInfo[playerid][pAdmin] < 1)
	{
		NewbieTimer[playerid] = gettime()+60;
		format(string, sizeof(string), "** Newbie %s: %s", GetPlayerNameEx(playerid), params);
	}
	if(PlayerInfo[playerid][pWatchdog] >= 1)
	{
		NewbieTimer[playerid] = gettime()+30;
		format(string, sizeof(string), "** Watchdog %s: %s", GetPlayerNameEx(playerid), params);
	}
	if(PlayerInfo[playerid][pHelper] == 1 && PlayerInfo[playerid][pAdmin] < 2)
	{
		NewbieTimer[playerid] = gettime()+30;
		format(string, sizeof(string), "** Helper %s: %s", GetPlayerNameEx(playerid), params);
		ReportCount[playerid]++;
		ReportHourCount[playerid]++;
		AddCAReportToken(playerid); // Advisor Tokens
	}
	if(PlayerInfo[playerid][pAdmin] == 1)
	{
		NewbieTimer[playerid] = gettime()+30;
		if(PlayerInfo[playerid][pSMod] == 1) format(string, sizeof(string), "** Senior Moderator %s: %s", GetPlayerNameEx(playerid), params);
		else format(string, sizeof(string), "** Moderator %s: %s", GetPlayerNameEx(playerid), params);
	}
	if(PlayerInfo[playerid][pHelper] == 2 && PlayerInfo[playerid][pAdmin] < 2)
	{
		NewbieTimer[playerid] = gettime()+10;
		format(string, sizeof(string), "** Community Advisor %s: %s", GetPlayerNameEx(playerid), params);
	}
	if(PlayerInfo[playerid][pHelper] == 3 && PlayerInfo[playerid][pAdmin] < 2)
	{
		NewbieTimer[playerid] = gettime()+10;
		format(string, sizeof(string), "** Senior Advisor %s: %s", GetPlayerNameEx(playerid), params);
	}
	if(PlayerInfo[playerid][pHelper] >= 4 && PlayerInfo[playerid][pAdmin] < 2)
	{
		NewbieTimer[playerid] = gettime()+10;
		format(string, sizeof(string), "** Chief Advisor %s: %s", GetPlayerNameEx(playerid), params);
	}
	if(PlayerInfo[playerid][pAdmin] >= 2) format(string, sizeof(string), "** %s %s: %s", GetAdminRankName(PlayerInfo[playerid][pAdmin]), GetPlayerNameEx(playerid), params);
	//foreach(new n: Player)
	for(new n = 0; n < MAX_PLAYERS; ++n)
	{
		if(IsPlayerConnected(n))
		{
			if (PlayerInfo[n][pNewbieTogged] == 0)
			{
				SendClientMessageEx(n, COLOR_NEWBIE, string);
			}
		}	
	}
	return 1;
}

CMD:hl(playerid, params[])
{
	if(gPlayerLogged{playerid} == 0)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You're not logged in.");
		return 1;
	}
	if(PlayerInfo[playerid][pTut] == 0)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You can't do that at this time.");
		return 1;
	}

	if(PlayerInfo[playerid][pHelpMute] == 1)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You are banned from the helper channel.");
		return 1;
	}

	new string[128];
	if(gettime() < HelperTimer[playerid])
	{
		format(string, sizeof(string), "You must wait %d seconds before speaking again in this channel.", HelperTimer[playerid]-gettime());
		SendClientMessageEx(playerid, COLOR_GREY, string);
		return 1;
	}
	if(gHelp[playerid] == 1)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You are not in the helper channel, type /joinhelp.");
		return 1;
	}

	if(isnull(params)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: (/hl) [text]");

	if(PlayerInfo[playerid][pHelper]<1&&PlayerInfo[playerid][pAdmin] < 2)
	{
		HelperTimer[playerid] = gettime()+10;
	}
	else if(PlayerInfo[playerid][pHelper]==1&&PlayerInfo[playerid][pAdmin] < 2)
	{
		HelperTimer[playerid] = gettime()+5;
	}
	else if(PlayerInfo[playerid][pAdmin] == 1)
	{
		HelperTimer[playerid] = gettime()+5;
	}
	else if(PlayerInfo[playerid][pHelper]>=2&&PlayerInfo[playerid][pAdmin] < 2)
	{
		HelperTimer[playerid] = gettime()+5;
	}
	if(PlayerInfo[playerid][pHelper]<1&&PlayerInfo[playerid][pAdmin]<1)
	{
		format(string, sizeof(string), "** Question by %s: %s", GetPlayerNameEx(playerid), params);
	}
	if(PlayerInfo[playerid][pHelper] == 1&& PlayerInfo[playerid][pAdmin]<2)
	{
		format(string, sizeof(string), "** Helper %s: %s", GetPlayerNameEx(playerid), params);
	}
	if(PlayerInfo[playerid][pAdmin] == 1)
	{
		if(PlayerInfo[playerid][pSMod] == 1) format(string, sizeof(string), "** Senior Moderator %s: %s", GetPlayerNameEx(playerid), params);
		else format(string, sizeof(string), "** Moderator %s: %s", GetPlayerNameEx(playerid), params);
	}
	if(PlayerInfo[playerid][pHelper] == 2&&PlayerInfo[playerid][pAdmin]<2)
	{
		format(string, sizeof(string), "** Community Advisor %s: %s", GetPlayerNameEx(playerid), params);
	}
	if(PlayerInfo[playerid][pHelper] == 3&&PlayerInfo[playerid][pAdmin]<2)
	{
		format(string, sizeof(string), "** Senior Advisor %s: %s", GetPlayerNameEx(playerid), params);
	}
	if(PlayerInfo[playerid][pHelper] >= 4&&PlayerInfo[playerid][pAdmin]<2)
	{
		format(string, sizeof(string), "** Chief Advisor %s: %s", GetPlayerNameEx(playerid), params);
	}
	if(PlayerInfo[playerid][pAdmin] >= 2)
	{
		format(string, sizeof(string), "** Admin %s: %s", GetPlayerNameEx(playerid), params);
	}
	//foreach(new n: Player)
	for(new n = 0; n < MAX_PLAYERS; ++n)
	{
		if(IsPlayerConnected(n))
		{
			if (gHelp[n]==0)
			{
				SendClientMessageEx(n, COLOR_HELPERCHAT, string);
			}
		}	
	}
	return 1;
}

CMD:joinhelp(playerid, params[])
{
	if(gHelp[playerid] == 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You are already in the helper channel!");
		return 1;
	}
	if(gettime() < HlKickTimer[playerid])
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You have just been kicked, you can not rejoin yet!");
		return 1;
	}
	if(PlayerInfo[playerid][pHelpMute] == 1)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You are banned from the helper channel.");
		return 1;
	}
	SendClientMessageEx(playerid, COLOR_YELLOW, "You have joined the helper chat, type /hl to ask your question or /leavehelp to leave!");

	new string[128];
	//foreach(new n: Player)
	for(new n = 0; n < MAX_PLAYERS; ++n)
	{
		if(IsPlayerConnected(n))
		{
			if (gHelp[n]==0)
			{
				format(string, sizeof(string), "* %s has joined the helper channel.", GetPlayerNameEx(playerid));
				SendClientMessageEx(n, COLOR_JOINHELPERCHAT, string);
			}
		}	
	}
	gHelp[playerid] = 0;
	return 1;
}

CMD:leavehelp(playerid, params[])
{
	if(gHelp[playerid] == 1)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You are not in the helper channel!");
		return 1;
	}

	new string[128];
	//foreach(new n: Player)
	for(new n = 0; n < MAX_PLAYERS; ++n)
	{
		if(IsPlayerConnected(n))
		{
			if (gHelp[n]==0)
			{
				format(string, sizeof(string), "* %s has left the helper channel.", GetPlayerNameEx(playerid));
				SendClientMessageEx(n, COLOR_JOINHELPERCHAT, string);
			}
		}	
	}
	gHelp[playerid] = 1;
	return 1;
}

CMD:hlkick(playerid, params[])
{
	if (PlayerInfo[playerid][pHelper] >= 1 || PlayerInfo[playerid][pAdmin] >= 1){
		new giveplayerid;
		if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /hlkick [player]");
		if(!IsPlayerConnected(giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");
		if(gHelp[giveplayerid] == 1) return SendClientMessageEx(playerid, COLOR_WHITE, "That person is not in the helper channel!");
		if(PlayerInfo[giveplayerid][pHelper] >= 1 || PlayerInfo[giveplayerid][pAdmin] >= 2) return SendClientMessageEx(playerid, COLOR_GREY, "You can not kick admins/advisors from the helper channel!");
		new string[128];
		HlKickTimer[giveplayerid] = gettime()+120;
		format(string, sizeof(string), "* %s has been kicked from the helper channel by %s.", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid));
		//foreach(new n: Player) {
		for(new n = 0; n < MAX_PLAYERS; ++n)
		{
			if(IsPlayerConnected(n))
			{
				if (gHelp[n]==0) {
					SendClientMessageEx(n, COLOR_JOINHELPERCHAT, string);
				}
			}	
		}
		gHelp[giveplayerid] = 1;
	}
	else {
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	}
	return 1;
}

CMD:nunmute(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[playerid][pWatchdog] >= 2)
	{
		new string[128], giveplayerid;
		if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /nunmute [player]");

		if(IsPlayerConnected(giveplayerid))
		{
			if(PlayerInfo[giveplayerid][pNMute] == 1)
			{
				format(string, sizeof(string), "AdmCmd: %s(%d) was unmuted from speaking in /newb by %s.", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), GetPlayerNameEx(playerid));
				Log("logs/admin.log", string);
				format(string, sizeof(string), "AdmCmd: %s was unmuted from speaking in /newb by %s.", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid));
				ABroadCast(COLOR_LIGHTRED,string,2);
				PlayerInfo[giveplayerid][pNMute] = 0;
				PlayerInfo[giveplayerid][pNMuteTotal]--;
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_LIGHTRED,"That person is not muted from /newb!");
			}

		}
	}
	return 1;
}

CMD:nmute(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[playerid][pHelper] >= 2 || PlayerInfo[playerid][pSMod] == 1 || PlayerInfo[playerid][pWatchdog] >= 2)
	{
		new string[128], giveplayerid;
		if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /nmute [player]");

		if(IsPlayerConnected(giveplayerid))
		{
			if(PlayerInfo[giveplayerid][pAdmin] >= 1)
			{
				return SendClientMessageEx(playerid, COLOR_LIGHTRED, "You can't /nmute admins");
			}
			if(PlayerInfo[giveplayerid][pNMute] == 0)
			{
			    SetPVarInt(giveplayerid, "UnmuteTime", gettime());
				PlayerInfo[giveplayerid][pNMute] = 1;
				PlayerInfo[giveplayerid][pNMuteTotal] += 1;
				format(string, sizeof(string), "AdmCmd: %s(%d) was muted from speaking in /newb by %s(%d).", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), GetPlayerNameEx(playerid), GetPlayerSQLId(playerid));
				Log("logs/admin.log", string);
				format(string, sizeof(string), "AdmCmd: %s was muted from speaking in /newb by %s.", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid));
				ABroadCast(COLOR_LIGHTRED,string,2);
				if(PlayerInfo[giveplayerid][pNMuteTotal] > 6)
				{
					new playerip[32];
					GetPlayerIp(giveplayerid, playerip, sizeof(playerip));
					format(string, sizeof(string), "AdmCmd: %s(%d) (IP:%s) was banned by %s, reason: Excessive newbie chat mutes", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), playerip,GetPlayerNameEx(playerid));
					Log("logs/ban.log", string);
					format(string, sizeof(string), "AdmCmd: %s was banned, reason: Excessive newbie chat mutes.", GetPlayerNameEx(giveplayerid));
					SendClientMessageToAllEx(COLOR_LIGHTRED, string);
					PlayerInfo[giveplayerid][pBanned] = 1;
					AddBan(playerid, giveplayerid, "Excessive newbie chat mutes");
					MySQLBan(GetPlayerSQLId(giveplayerid),GetPlayerIpEx(giveplayerid),"Excessive newbie chat mutes", 1,GetPlayerNameEx(playerid));
					SetTimerEx("KickEx", 1000, 0, "i", giveplayerid);
				}

				if(PlayerInfo[playerid][pAdmin] == 1)
				{
					format(string, sizeof(string), "AdmCmd: %s was muted from speaking in /newb by an Admin.", GetPlayerNameEx(giveplayerid));
					SendDutyAdvisorMessage(TEAM_AZTECAS_COLOR, string);
					SendClientMessageEx(giveplayerid, COLOR_LIGHTRED, "You were just muted from Newbie Chat [/newb] by an Admin.");
				}
				else
				{
					format(string, sizeof(string), "AdmCmd: %s was muted from speaking in /newb by %s.", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid));
					SendDutyAdvisorMessage(TEAM_AZTECAS_COLOR, string);
					format(string, sizeof(string), "You were just muted from the newbie chat channel (/newb) by %s.", GetPlayerNameEx(playerid));
					SendClientMessageEx(giveplayerid, COLOR_LIGHTRED, string);
				}

				SendClientMessageEx(giveplayerid, COLOR_LIGHTRED, "Remember, the newbie chat channel is only for script/server related questions and may not be used for any other purpose, unless stated otherwise by an admin.");
				SendClientMessageEx(giveplayerid, COLOR_LIGHTRED, "If you wish to be unmuted, you will be fined or jailed. Future abuse could result in increased punishment. If you feel this was in error, contact a senior administrator.");

				format(string, sizeof(string), "AdmCmd: %s was just muted from using Newbie Chat [/newb] due to misuse.", GetPlayerNameEx(giveplayerid));
				SendClientMessageToAllEx(COLOR_LIGHTRED, string);
			}
			else
			{
				if(PlayerInfo[playerid][pAdmin] >= 2)
				{
					ShowNMuteFine(giveplayerid);
					format(string, sizeof(string), "You offered %s an unmute from /newb.", GetPlayerNameEx(giveplayerid));
					SendClientMessageEx(playerid, COLOR_LIGHTRED, string);
				}
				else
				{
					SendClientMessageEx(playerid, COLOR_GRAD1, "That person is currently muted. You are unable to unmute players from the newbie chat as a Community Advisor.");
				}
			}
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	}
	return 1;
}

CMD:makeadvisor(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pPR] > 0)
	{
		new string[128], giveplayerid, level;
		if(sscanf(params, "ud", giveplayerid, level)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /makeadvisor [player] [level(1-4)]");

		if(IsPlayerConnected(giveplayerid))
		{
			if(PlayerInfo[giveplayerid][pAdmin] >= 1)
			{
				SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot make admins community advisors!");
				return 1;
			}
			PlayerInfo[giveplayerid][pHelper] = level;
			switch(level)
			{
				case 1:
				{
					format(string, sizeof(string), "You have been made a Helper by %s", GetPlayerNameEx(playerid));
					SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "You have given Helper to %s", GetPlayerNameEx(giveplayerid));
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "%s(%d) has been made a Helper by %s(%d)", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), GetPlayerNameEx(playerid), GetPlayerSQLId(playerid));
					Log("logs/admin.log", string);
				}
				case 2:
				{
					format(string, sizeof(string), "You have been made a Community Advisor by %s", GetPlayerNameEx(playerid));
					SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "You have given Community Advisor to %s", GetPlayerNameEx(giveplayerid));
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "%s(%d) has been made a Community Advisor by %s(%d)", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), GetPlayerNameEx(playerid), GetPlayerSQLId(playerid));
					Log("logs/admin.log", string);
				}
				case 3:
				{
					format(string, sizeof(string), "You have been promoted to Senior Advisor by %s", GetPlayerNameEx(playerid));
					SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "You have promoted %s to Senior Advisor", GetPlayerNameEx(giveplayerid));
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "%s(%d) has been made a Senior Advisor by %s(%d)", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), GetPlayerNameEx(playerid), GetPlayerSQLId(playerid));
					Log("logs/admin.log", string);
				}
				case 4:
				{
					format(string, sizeof(string), "You have been promoted to Chief Advisor by %s", GetPlayerNameEx(playerid));
					SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "You have promoted %s to Chief Advisor", GetPlayerNameEx(giveplayerid));
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "%s(%d) has been made a Chief Advisor by %s(%d)", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), GetPlayerNameEx(playerid), GetPlayerSQLId(playerid));
					Log("logs/admin.log", string);
				}
			}
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	}
	return 1;
}

CMD:makehelper(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pHelper] >= 3 || PlayerInfo[playerid][pPR] > 0)
	{
		new string[128], giveplayerid;
		if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /makehelper [player]");

		if(IsPlayerConnected(giveplayerid))
		{
			if(PlayerInfo[giveplayerid][pAdmin] >= 1)
			{
				SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot make admins community advisors!");
				return 1;
			}
			PlayerInfo[giveplayerid][pHelper] = 1;
			format(string, sizeof(string), "You have been made a helper by %s", GetPlayerNameEx(playerid));
			SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
			format(string, sizeof(string), "You have made %s a helper.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	}
	return 1;
}

CMD:takeadvisor(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pHelper] >= 3 || PlayerInfo[playerid][pPR] > 0)
	{
		new string[128], giveplayerid;
		if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /takeadvisor [player]");

		if(IsPlayerConnected(giveplayerid))
		{
		    if(PlayerInfo[playerid][pHelper] == 3 && PlayerInfo[giveplayerid][pHelper] != 1) {
		        SendClientMessageEx(playerid, COLOR_GREY, "You can only remove helpers.");
		        return 1;
		    }
			if(PlayerInfo[giveplayerid][pHelper] != 0)
			{
				if(GetPVarType(playerid, "AdvisorDuty"))
				{
					DeletePVar(playerid, "AdvisorDuty");
					Advisors -= 1;
				}
				PlayerInfo[giveplayerid][pHelper] = 0;
				format(string, sizeof(string), "%s has kicked you out from the Community Advisor team.", GetPlayerNameEx(playerid));
				SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
				format(string, sizeof(string), "You took %s's Community Advisor rank.", GetPlayerNameEx(giveplayerid));
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
			}

		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	}
	return 1;
}

CMD:chelp(playerid, params[]) {
	return cmd_ch(playerid, params);
}

CMD:ch(playerid, params[])
{
	if (PlayerInfo[playerid][pHelper] >= 1)
	{
		SendClientMessageEx(playerid, COLOR_GREEN,"_______________________________________");
		SendClientMessageEx(playerid, COLOR_GRAD1, "*1* HELPER *** (/newb)ie /hlkick /hlban");
	}
	if (PlayerInfo[playerid][pHelper] >= 2) SendClientMessageEx(playerid, COLOR_GRAD1, "*2* COMMUNITY ADVISOR *** (/ca)dvisor /nmute /admute /cduty /accepthelp /rhmute(reset) /advisors /findnewb /showrequests");
	if (PlayerInfo[playerid][pHelper] >= 3) SendClientMessageEx(playerid, COLOR_GRAD1, "*3* SENIOR ADVISOR *** /requestevent /spec /makehelper /takeadvisor");
	if (PlayerInfo[playerid][pHelper] >= 4) SendClientMessageEx(playerid, COLOR_GRAD1, "*4* CHIEF ADVISOR *** /nonewbie /cmotd");
	if (PlayerInfo[playerid][pHelper] >= 1) SendClientMessageEx(playerid, COLOR_GREEN,"_______________________________________");
	return 1;
}

CMD:requesthelp(playerid, params[])
{
	if(Advisors < 1)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "   There are no Community Advisors On Duty at the moment, try again later!");
		return 1;
	}
	if(isnull(params))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /requesthelp [reason]");
		return 1;
	}

	new string[128];
	if(PlayerInfo[playerid][pLevel] < 4)
	{
		if(PlayerInfo[playerid][pRHMutes] >= 4 || PlayerInfo[playerid][pRHMuteTime] > 0)
		{
			SendClientMessageEx(playerid, COLOR_GREY, "You are currently banned from requesting help.");
			return 1;
		}
		if(JustReported[playerid] > 0)
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Wait 10 seconds after sending a next request!");
			return 1;
		}
		JustReported[playerid]=10;
		format(string, sizeof(string), "** %s(%i) is requesting help, reason: %s. (type /accepthelp %i)", GetPlayerNameEx(playerid), playerid, params, playerid);
		SendDutyAdvisorMessage(TEAM_AZTECAS_COLOR, string);
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You have requested help from a Community Advisor, wait for a reply.");
		SetPVarInt( playerid, "COMMUNITY_ADVISOR_REQUEST", 1 );
		SetPVarInt( playerid, "HelpTime", 5);
		SetPVarString( playerid, "HelpReason", params);
		SetTimerEx( "HelpTimer", 60000, 0, "d", playerid);
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "  You are not a newbie!");
	}
	return 1;
}

CMD:showrequests(playerid, params[])
{
	if(PlayerInfo[playerid][pHelper] >= 2)
	{
		new string[128], reason[64];
		SendClientMessageEx(playerid, COLOR_GREEN, "____________________ HELP REQUESTS _____________________");
		//foreach(new i: Player)
		for(new i = 0; i < MAX_PLAYERS; ++i)
		{
			if(IsPlayerConnected(i))
			{
				if(GetPVarInt(i, "COMMUNITY_ADVISOR_REQUEST"))
				{
					GetPVarString(i, "HelpReason", reason, 64);
					format(string, sizeof(string), "%s  | ID: %i | Reason: %s | Expires in: %i minutes.", GetPlayerNameEx(i), i, reason, GetPVarInt(i, "HelpTime"));
					SendClientMessageEx(playerid, COLOR_REPORT, string);
				}
			}	
		}
		SendClientMessageEx(playerid, COLOR_GREEN, "_________________________________________________________");
	}
	return 1;
}

CMD:rhmute(playerid, params[])
{
	if (PlayerInfo[playerid][pHelper] >= 2)
	{
		new string[128], giveplayerid;
		if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /rhmute [player]");

		if(IsPlayerConnected(giveplayerid))
		{
			if(PlayerInfo[giveplayerid][pRHMuteTime] == 0)
			{
			    if(PlayerInfo[giveplayerid][pRHMutes] == 0)
			    {
  					PlayerInfo[giveplayerid][pRHMutes] = 1;
					format(string, sizeof(string), "*** %s has given %s their first warning about help request abuse", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
					SendAdvisorMessage(COLOR_COMBINEDCHAT, string);

					ShowPlayerDialog(giveplayerid, 7954, DIALOG_STYLE_MSGBOX, "Help request abuse warning", "A Community Advisor has warned you not to abuse /requesthelp.\n\nNote that future abuse of /requesthelp could result in a mute from /requesthelp or loss of that privilege altogether.", "Next", "");

					format(string, sizeof(string), "AdmCmd: %s(%d) has given %s(%d) their first warning about help request abuse", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid));
					Log("logs/mute.log", string);

			    }
			    else if(PlayerInfo[giveplayerid][pRHMutes] == 1)
			    {
  					PlayerInfo[giveplayerid][pRHMutes] = 2;
					PlayerInfo[giveplayerid][pRHMuteTime] = 30*60;
					format(string, sizeof(string), "*** %s has temporarily blocked %s from using /requesthelp", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
					SendAdvisorMessage(COLOR_COMBINEDCHAT, string);

					ShowPlayerDialog(giveplayerid, 7954, DIALOG_STYLE_MSGBOX, "Temporarily blocked from /requesthelp", "You have been temporarily blocked from using /requesthelp\n\nAs this is the first time you have been blocked from requesting help, you will not be able to use /requesthelp for 30 minutes.\n\nTwo more mute will result in a total loss in privilege of the command.", "Next", "");

					format(string, sizeof(string), "AdmCmd: %s(d) was temporarily blocked from /requesthelp by %s(%d)", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), GetPlayerNameEx(playerid), GetPlayerSQLId(playerid));
					Log("logs/mute.log", string);
			    }
			    else if(PlayerInfo[giveplayerid][pRHMutes] == 2)
			    {
  					PlayerInfo[giveplayerid][pRHMutes] = 3;
					PlayerInfo[giveplayerid][pRHMuteTime] = 90*60;
					format(string, sizeof(string), "*** %s has temporarily blocked %s from using /requesthelp", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
					SendAdvisorMessage(COLOR_COMBINEDCHAT, string);

					ShowPlayerDialog(giveplayerid, 7954, DIALOG_STYLE_MSGBOX, "Temporarily blocked from /requesthelp", "You have been temporarily blocked from using /requesthelp\n\nAs this is the second time you have been blocked from requesting help, you will not be able to use /requesthelp for 1 hour and 30 minutes.\n\nOne more mute will result in a total loss in privilege of the command.", "Next", "");

					format(string, sizeof(string), "AdmCmd: %s(%d) was temporarily blocked from /requesthelp by %s(%d)", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), GetPlayerNameEx(playerid), GetPlayerSQLId(playerid));
					Log("logs/mute.log", string);
			    }
				else if(PlayerInfo[giveplayerid][pRHMutes] == 3)
			    {
  					PlayerInfo[giveplayerid][pRHMutes] = 4;
					format(string, sizeof(string), "*** %s has permanently blocked %s from using /requesthelp", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
					SendAdvisorMessage(COLOR_COMBINEDCHAT, string);

					ShowPlayerDialog(giveplayerid,7954,DIALOG_STYLE_MSGBOX, "Permanently blocked from /requesthelp", "You have been permanently blocked from using /requesthelp.\n\nYou will need to contact an Administrator via /report to appeal this.", "Next", "");

					format(string, sizeof(string), "AdmCmd: %s(%d) was permanently blocked from /requesthelp by %s(%d)", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), GetPlayerNameEx(playerid), GetPlayerSQLId(playerid));
					Log("logs/mute.log", string);
			    }
				DeletePVar(giveplayerid, "COMMUNITY_ADVISOR_REQUEST");
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GRAD2, "That person is already disabled from /requesthelp.");
			}
		}
		else return SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	}
	return 1;
}

CMD:rhmutereset(playerid, params[])
{
	if (PlayerInfo[playerid][pHelper] >= 2)
	{
		new string[128], giveplayerid, reason[64];
		if(sscanf(params, "us[64]", giveplayerid, reason)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /rhmutereset [player] [reason]");

		if(IsPlayerConnected(giveplayerid))
		{
			if(PlayerInfo[giveplayerid][pRHMutes] >= 2)
			{
				PlayerInfo[giveplayerid][pRHMutes]--;
				PlayerInfo[giveplayerid][pRHMuteTime] = 0;
				format(string, sizeof(string), "*** %s has unblocked %s from requesting help, reason: %s", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), reason);
				SendAdvisorMessage(COLOR_COMBINEDCHAT, string);
				SendClientMessageEx(giveplayerid, COLOR_GRAD2, "You have been unblocked from requesting help. You may now use the help request system again.");
				SendClientMessageEx(giveplayerid, COLOR_GRAD2, "Please accept our apologies for any error and inconvenience this may have caused.");
				format(string, sizeof(string), "AdmCmd: %s(%d) was unblocked from /requesthelp by %s(%d), reason: %s", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), reason);
				Log("logs/mute.log", string);
			}
			else
			{
			    SendClientMessageEx(playerid, COLOR_GRAD1, "That person is not blocked from requesting help!");
			}

		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	}
	return 1;
}

CMD:findnewb(playerid, params[])
{
	if(PlayerInfo[playerid][pHelper] < 2) {
        SendClientMessageEx(playerid, COLOR_GREY, "You are not a community advisor.");
	}
	else if(GetPVarInt(playerid, "AdvisorDuty") == 0) {
	    SendClientMessageEx(playerid, COLOR_GREY, "You are not on duty as a community advisor.");
	}
	else {
	    new Float: Pos[3][2], i[2], vw[2], Message[38 + MAX_PLAYER_NAME];
	    if(!GetPVarType(playerid, "HelpingSomeone")) {
     		//foreach(new x: Player)
			for(new x = 0; x < MAX_PLAYERS; ++x)
			{
				if(IsPlayerConnected(x))
				{
					if(PlayerInfo[x][pLevel] == 1 && PlayerInfo[x][pHelpedBefore] == 0) {
						GetPlayerPos(x, Pos[0][0], Pos[1][0], Pos[2][0]);
						GetPlayerPos(playerid, Pos[0][1], Pos[1][1], Pos[2][1]);
						vw[0] = GetPlayerVirtualWorld(x);
						i[0] = GetPlayerInterior(x);
						vw[1] = GetPlayerVirtualWorld(playerid);
						i[1] = GetPlayerInterior(playerid);

						SetPVarFloat(playerid, "AdvisorLastx", Pos[0][1]);
						SetPVarFloat(playerid, "AdvisorLasty", Pos[1][1]);
						SetPVarFloat(playerid, "AdvisorLastz", Pos[2][1]);
						SetPVarInt(playerid, "AdvisorLastInt", i[1]);
						SetPVarInt(playerid, "AdvisorLastVW", vw[1]);

						SetPlayerVirtualWorld(playerid, vw[0]);
						SetPlayerInterior(playerid, i[0]);
						SetPlayerPos(playerid, Pos[0][0], Pos[1][0]+2, Pos[2][0]);
						PlayerInfo[x][pHelpedBefore] = 1;
						SetPVarInt(playerid, "HelpingSomeone", 1);
						ShowPlayerDialog(x, 0, DIALOG_STYLE_MSGBOX, "Helper Alert", "A community advisor has just teleported to you. Feel free to ask him anything related to Next Generation Gaming that you may have issues/concerns with.", "Close", "");
						if(i[0] > 0 || vw[0] > 0) Player_StreamPrep(playerid, Pos[0][0], Pos[1][0], Pos[2][0], FREEZE_TIME);
						format(Message, sizeof(Message), "You have been teleported to newbie %s, retype the command to be teleported back.", GetPlayerNameEx(x));
						SendClientMessageEx(playerid, COLOR_WHITE, Message);
						break;
					}
				}	
			}
		}
		else
		{
		    DeletePVar(playerid, "HelpingSomeone");
			SetPlayerPos(playerid, GetPVarFloat(playerid, "AdvisorLastx"), GetPVarFloat(playerid, "AdvisorLasty"), GetPVarFloat(playerid, "AdvisorLastz"));
			SetPlayerVirtualWorld(playerid, GetPVarInt(playerid, "AdvisorLastVW"));
			SetPlayerInterior(playerid, GetPVarInt(playerid, "AdvisorLastInt"));
			if(GetPVarInt(playerid, "AdvisorLastInt") > 0 || GetPVarInt(playerid, "AdvisorLastVW") > 0) Player_StreamPrep(playerid, GetPVarFloat(playerid, "AdvisorLastx"), GetPVarFloat(playerid, "AdvisorLasty"), GetPVarFloat(playerid, "AdvisorLastz"), FREEZE_TIME);
			SendClientMessageEx(playerid, COLOR_WHITE, "You have been teleported back to your previous location.");
		}
	}
	return 1;
}

CMD:accepthelp(playerid, params[])
{
    if(PlayerInfo[playerid][pHelper] < 2) {
        SendClientMessageEx(playerid, COLOR_GREY, "You are not a community advisor.");
	}
	else if(HelpingNewbie[playerid] != INVALID_PLAYER_ID) {
	    SendClientMessageEx(playerid, COLOR_GREY, "You are already helping someone.");
	}
	else if(GetPVarInt(playerid, "AdvisorDuty") == 0) {
	    SendClientMessageEx(playerid, COLOR_GREY, "You are not on duty as a community advisor.");
	}
	else {

		new Player, string[128], Float:health, Float:armor;

		if(sscanf(params, "u", Player)) {
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /accepthelp [PlayerID]");
		}
		else if(Player == playerid) {
		    SendClientMessageEx(playerid, COLOR_GREY, "You can't accept a help request from yourself.");
		}
		else if(!IsPlayerConnected(Player)) {
			SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");
		}
		else if(GetPVarInt(Player, "COMMUNITY_ADVISOR_REQUEST") == 0) {
			SendClientMessageEx(playerid, COLOR_GREY, "That person doesn't need help.");
		}
		else {

		    format(string, sizeof(string), "* %s has accepted the help request from %s.",GetPlayerNameEx(playerid), GetPlayerNameEx(Player));
			SendDutyAdvisorMessage(TEAM_AZTECAS_COLOR, string);
			format(string, sizeof(string), "* You have accepted %s's help request, once you are done type /finishhelp to get back to your position.",GetPlayerNameEx(Player));
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
			format(string, sizeof(string), "* Advisor %s has accepted your help request.",GetPlayerNameEx(playerid));
			SendClientMessageEx(Player, COLOR_LIGHTBLUE, string);
			PlayerInfo[playerid][pAcceptedHelp]++;
			ReportCount[playerid]++;
			ReportHourCount[playerid]++;
			new Float: x, Float: y, Float: z, Float: r, i, vw;
			vw = GetPlayerVirtualWorld(playerid);
			i = GetPlayerInterior(playerid);
			GetPlayerPos(playerid, x, y, z);
			GetPlayerFacingAngle(playerid, r);
			SetPVarFloat(playerid, "AdvisorLastx", x);
			SetPVarFloat(playerid, "AdvisorLasty", y);
			SetPVarFloat(playerid, "AdvisorLastz", z);
			SetPVarFloat(playerid, "AdvisorLastr", r);
			SetPVarInt(playerid, "AdvisorLastInt", i);
			SetPVarInt(playerid, "AdvisorLastVW", vw);
			GetPlayerPos(Player, x, y, z);
			vw = GetPlayerVirtualWorld(Player);
			i = GetPlayerInterior(Player);
			SetPlayerPos(playerid, x, y+2, z);
			SetPlayerVirtualWorld(playerid, vw);
			SetPlayerInterior(playerid, i);
			GetPlayerHealth(playerid,health);
			SetPVarFloat(playerid, "pPreGodHealth", health);
			GetPlayerArmour(playerid,armor);
			SetPVarFloat(playerid, "pPreGodArmor", armor);
			SetPlayerHealth(playerid, 0x7FB00000);
		    SetPlayerArmor(playerid, 0x7FB00000);
		    SetPVarInt(playerid, "pGodMode", 1);
			if(i > 0 || vw > 0) Player_StreamPrep(playerid, x, y, z, FREEZE_TIME);
			HelpingNewbie[playerid] = Player;
			AddCAReportToken(playerid); // Advisor Tokens
			DeletePVar(Player, "COMMUNITY_ADVISOR_REQUEST");
			DeletePVar(Player, "HelpTime");
			return 1;

		}
	}
	return 1;
}

CMD:finishhelp(playerid, params[])
{
	if(HelpingNewbie[playerid] != INVALID_PLAYER_ID)
	{
		new string[128], Float:health, Float:armor;
		format(string, sizeof(string), "* %s has finished the help request from %s.",GetPlayerNameEx(playerid), GetPlayerNameEx(HelpingNewbie[playerid]));
		SendDutyAdvisorMessage(TEAM_AZTECAS_COLOR, string);
		SetPlayerPos(playerid, GetPVarFloat(playerid, "AdvisorLastx"), GetPVarFloat(playerid, "AdvisorLasty"), GetPVarFloat(playerid, "AdvisorLastz"));
		SetPlayerVirtualWorld(playerid, GetPVarInt(playerid, "AdvisorLastVW"));
		SetPlayerInterior(playerid, GetPVarInt(playerid, "AdvisorLastInt"));
		DeletePVar(playerid, "pGodMode");
		health = GetPVarFloat(playerid, "pPreGodHealth");
		SetPlayerHealth(playerid,health);
		armor = GetPVarFloat(playerid, "pPreGodArmor");
		if(armor > 0) {
			SetPlayerArmor(playerid,armor);
		}
		else
		{
			RemoveArmor(playerid);
		}
		DeletePVar(playerid, "pPreGodHealth");
		DeletePVar(playerid, "pPreGodArmor");
		if(GetPVarInt(playerid, "AdvisorLastInt") > 0 || GetPVarInt(playerid, "AdvisorLastVW") > 0) Player_StreamPrep(playerid, GetPVarFloat(playerid, "AdvisorLastx"), GetPVarFloat(playerid, "AdvisorLasty"), GetPVarFloat(playerid, "AdvisorLastz"), FREEZE_TIME);
		HelpingNewbie[playerid] = INVALID_PLAYER_ID;
		return 1;
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREY, "   You're not helping anyone!");
		return 1;
	}
}

CMD:togca(playerid, params[])
{
	if(PlayerInfo[playerid][pHelper] < 2 && PlayerInfo[playerid][pAdmin] < 2) return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not authorized to use this command!");
	if(GetPVarInt(playerid, "CAChat") == 1)
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "** You have disabled Community Advisor chat.");
		return SetPVarInt(playerid, "CAChat", 0);
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "** You have enabled Community Advisor chat.");
		return SetPVarInt(playerid, "CAChat", 1);
	}
}

CMD:ca(playerid, params[])
{
	if(PlayerInfo[playerid][pJailTime] && strfind(PlayerInfo[playerid][pPrisonReason], "[OOC]", true) != -1) return SendClientMessageEx(playerid, COLOR_GREY, "OOC prisoners are restricted to only speak in /b");
	if(PlayerInfo[playerid][pHelper] < 2 && PlayerInfo[playerid][pAdmin] < 2) return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not authorized to use this command!");
	if(GetPVarInt(playerid, "CAChat") == 0) return SendClientMessageEx(playerid, COLOR_GREY, "You have Community Advisor chat disabled - /togca to enable it.");
	if(isnull(params)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /ca [text]");
	new szMessage[128];
	if(PlayerInfo[playerid][pHelper] == 2) format(szMessage, sizeof(szMessage), "* Community Advisor %s: %s", GetPlayerNameEx(playerid), params);
	else if(PlayerInfo[playerid][pHelper] == 3) format(szMessage, sizeof(szMessage), "* Senior Advisor %s: %s", GetPlayerNameEx(playerid), params);
	else if(PlayerInfo[playerid][pHelper] >= 4) format(szMessage, sizeof(szMessage), "* Chief Advisor %s: %s", GetPlayerNameEx(playerid), params);
	else if(PlayerInfo[playerid][pAdmin] >= 2) format(szMessage, sizeof(szMessage), "* %s %s: %s", GetAdminRankName(PlayerInfo[playerid][pAdmin]), GetPlayerNameEx(playerid), params);
	else format(szMessage, sizeof(szMessage), "* Undefined Rank %s: %s", GetPlayerNameEx(playerid), params);	
	for(new i = 0; i < MAX_PLAYERS; ++i)
	{
		if(IsPlayerConnected(i))
		{
			if((PlayerInfo[i][pHelper] >= 2 || PlayerInfo[i][pAdmin] >= 2) && GetPVarInt(i, "CAChat") == 1)
			{
				SendClientMessageEx(i, 0x5288f3FF, szMessage);
			}
		}
	}
	return 1;
}