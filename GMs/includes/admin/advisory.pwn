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
stock CBroadCast(color,string[],level)
{
	foreach(new i: Player)
	{
		if (PlayerInfo[i][pHelper] >= level)
		{
			SendClientMessageEx(i, color, string);
			//printf("%s", string);
		}
	}
	return 1;
}

stock ShowNMuteFine(playerid)
{
	new playername[MAX_PLAYER_NAME];
	GetPlayerName(playerid, playername, sizeof(playername));

	new totalwealth = PlayerInfo[playerid][pAccount] + GetPlayerCash(playerid);
	if(PlayerInfo[playerid][pPhousekey] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[playerid][pPhousekey]][hOwnerID] == GetPlayerSQLId(playerid)) totalwealth += HouseInfo[PlayerInfo[playerid][pPhousekey]][hSafeMoney];
	if(PlayerInfo[playerid][pPhousekey2] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[playerid][pPhousekey2]][hOwnerID] == GetPlayerSQLId(playerid)) totalwealth += HouseInfo[PlayerInfo[playerid][pPhousekey2]][hSafeMoney];
	if(PlayerInfo[playerid][pPhousekey3] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[playerid][pPhousekey3]][hOwnerID] == GetPlayerSQLId(playerid)) totalwealth += HouseInfo[PlayerInfo[playerid][pPhousekey3]][hSafeMoney];

    new fine = 10*totalwealth/100;
	if(PlayerInfo[playerid][pNMuteTotal] < 4)
	{
		new string[64];
		format(string,sizeof(string),"Jail for %d Minutes\nCash Fine ($%d)",PlayerInfo[playerid][pNMuteTotal] * 15, fine);
		ShowPlayerDialogEx(playerid,NMUTE,DIALOG_STYLE_LIST,"Newbie Chat Unmute - Select your Punishment:",string,"Select","Cancel");
	}
	else if(PlayerInfo[playerid][pNMuteTotal] == 4) ShowPlayerDialogEx(playerid,NMUTE,DIALOG_STYLE_LIST,"Newbie Chat Unmute - Select your Punishment:","Prison for 1 Hour","Select","Cancel");
	else if(PlayerInfo[playerid][pNMuteTotal] == 5) ShowPlayerDialogEx(playerid,NMUTE,DIALOG_STYLE_LIST,"Newbie Chat Unmute - Select your Punishment:","Prison for 1 Hour and 15 Minutes","Select","Cancel");
	else if(PlayerInfo[playerid][pNMuteTotal] == 6) ShowPlayerDialogEx(playerid,NMUTE,DIALOG_STYLE_LIST,"Newbie Chat Unmute - Select your Punishment:","Prison for 1 Hour and 30 Minutes","Select","Cancel");
}

stock SendAdvisorMessage(color, string[])
{
	foreach(new i: Player)
	{
		if((PlayerInfo[i][pAdmin] >= 1 || PlayerInfo[i][pHelper] >= 2 || PlayerInfo[i][pVIPMod] || PlayerInfo[i][pWatchdog] >= 1) && advisorchat[i])
		{
			ChatTrafficProcess(i, color, string, 15);
		}
	}
}

stock SendDutyAdvisorMessage(color, string[])
{
	foreach(new i: Player)
	{
		if(PlayerInfo[i][pHelper] >= 2 && GetPVarInt(i, "AdvisorDuty") == 1)
		{
			SendClientMessageEx(i, color, string);
		}
	}
}

CMD:advisors(playerid, params[])
{
    new string[128];
    if(PlayerInfo[playerid][pHelper] >= 1)
    {
        SendClientMessageEx(playerid, COLOR_GRAD1, "Advisors Online:");
        foreach(new i: Player)
		{
			new tdate[11], thour[9], i_timestamp[3];
			getdate(i_timestamp[0], i_timestamp[1], i_timestamp[2]);
			format(tdate, sizeof(tdate), "%d-%02d-%02d", i_timestamp[0], i_timestamp[1], i_timestamp[2]);
			format(thour, sizeof(thour), "%02d:00:00", hour);

			if(PlayerInfo[i][pHelper] != 0 && PlayerInfo[i][pHelper] <= PlayerInfo[playerid][pHelper])
			{
				if(PlayerInfo[i][pHelper] == 1 && PlayerInfo[i][pAdmin] < 2) {
					format(string, sizeof(string), "** JA: %s	(Requests This Hour: %d | Requests Today: %d)", GetPlayerNameEx(i), ReportHourCount[i], ReportCount[i]);
				}
				if(PlayerInfo[i][pHelper] == 2&&PlayerInfo[i][pAdmin]<2) {
					format(string, sizeof(string), "** GA: %s	(Requests This Hour: %d | Requests Today: %d)", GetPlayerNameEx(i), ReportHourCount[i], ReportCount[i]);
				}
				if(PlayerInfo[i][pHelper] == 3&&PlayerInfo[i][pAdmin]<2) {
					format(string, sizeof(string), "** SA: %s	(Requests This Hour: %d | Requests Today: %d)", GetPlayerNameEx(i), ReportHourCount[i], ReportCount[i]);
				}
				if(PlayerInfo[i][pHelper] >= 4&&PlayerInfo[i][pAdmin]<2) {
					format(string, sizeof(string), "** CA: %s	(Requests This Hour: %d | Requests Today: %d)", GetPlayerNameEx(i), ReportHourCount[i], ReportCount[i]);
				}
				SendClientMessageEx(playerid, COLOR_GRAD2, string);
			}
		}
    }
    else if(PlayerInfo[playerid][pAdmin] >= 2) {
        SendClientMessageEx(playerid, COLOR_GRAD1, "Advisors Online:");
        foreach(new i: Player)
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
    else {
        SendClientMessageEx(playerid, COLOR_GRAD1, "If you have questions regarding gameplay, or the server use /newb.");
        SendClientMessageEx(playerid, COLOR_GRAD1, "If you see suspicious happenings/players /report [id] [reason].");
    }
    return 1;
}

CMD:caduty(playerid, params[])
{
    if(PlayerInfo[playerid][pHelper] >= 2)
	{
        if(GetPVarInt(playerid, "AdvisorDuty") == 1)
		{
            SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You are now off duty as a Advisor and will not receive calls anymore.");
            DeletePVar(playerid, "AdvisorDuty");
            Advisors -= 1;
        }
        else
		{
            SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You are now on duty as a Advisor and will receive calls from people in need.");
            SetPVarInt(playerid, "AdvisorDuty", 1);
            Advisors += 1;
        }
    }
    else
	{
        SendClientMessageEx(playerid, COLOR_GRAD1, "   You are not a Advisor!");
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

CMD:checkrequestcount(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1 || PlayerInfo[playerid][pHelper] >= 3 || PlayerInfo[playerid][pPR] > 0)
	{
		new string[128], adminname[MAX_PLAYER_NAME], tdate[11];
		if(sscanf(params, "s[24]s[11]", adminname, tdate)) return SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /checkrequestcount [advisor name] [date (YYYY-MM-DD)]");
		new giveplayerid = ReturnUser(adminname);
		if(IsPlayerConnected(giveplayerid))
		{
			mysql_format(MainPipeline, string, sizeof(string), "SELECT SUM(count) FROM `tokens_request` WHERE `playerid` = %d AND `date` = '%s'", GetPlayerSQLId(giveplayerid), tdate);
			mysql_tquery(MainPipeline, string, "QueryCheckCountFinish", "issi", playerid, GetPlayerNameEx(giveplayerid), tdate, 2);
			mysql_format(MainPipeline, string, sizeof(string), "SELECT `count`, `hour` FROM `tokens_request` WHERE `playerid` = %d AND `date` = '%s' ORDER BY `hour` ASC", GetPlayerSQLId(giveplayerid), tdate);
			mysql_tquery(MainPipeline, string, "QueryCheckCountFinish", "issi", playerid, GetPlayerNameEx(giveplayerid), tdate, 3);
		}
		else
		{
			new tmpName[MAX_PLAYER_NAME];
			mysql_escape_string(adminname, tmpName);
			mysql_format(MainPipeline, string, sizeof(string), "SELECT `id`, `Username` FROM `accounts` WHERE `Username` = '%s'", tmpName);
			mysql_tquery(MainPipeline, string, "QueryUsernameCheck", "isi", playerid, tdate, 1);
		}
    }
    return 1;
}

/*CMD:hlban(playerid, params[])
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

					foreach(new n: Player)
					{
						if(PlayerInfo[n][pToggledChats][0] == 0)
						{
							format(string, sizeof(string), "* %s has been banned from the helper channel by %s.", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid));
							SendClientMessageEx(n, COLOR_JOINHELPERCHAT, string);
						}
					}
					if(PlayerInfo[playerid][pToggledChats][0] != 0)
					{
						format(string, sizeof(string), "* %s has been banned from the helper channel by %s.", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid));
						SendClientMessageEx(playerid, COLOR_JOINHELPERCHAT, string);
					}
                    PlayerInfo[giveplayerid][pToggledChats][0] = 1;

					format(string, sizeof(string), "You have been banned from helper channel by %s.", GetPlayerNameEx(playerid));
					SendClientMessageEx(giveplayerid, COLOR_GRAD2, string);
					format(string, sizeof(string), "AdmCmd: %s(%d) was banned from /hl by %s(%d)", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), GetPlayerNameEx(playerid), GetPlayerSQLId(playerid));
					Log("logs/mute.log", string);
				}
				else
				{
					PlayerInfo[giveplayerid][pHelpMute] = 0;

					foreach(new n: Player)
					{
						if (PlayerInfo[n][pToggledChats][0] == 0)
						{
							format(string, sizeof(string), "* %s has been unbanned from the helper channel by %s.", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid));
							SendClientMessageEx(n, COLOR_JOINHELPERCHAT, string);
						}
					}
					if(PlayerInfo[playerid][pToggledChats][0] != 0)
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

CMD:hl(playerid, params[])
{
	if(gPlayerLogged{playerid} == 0) return SendClientMessageEx(playerid, COLOR_GREY, "You're not logged in.");
	if(PlayerInfo[playerid][pTut] == 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can't do that at this time.");
	if((nonewbie) && PlayerInfo[playerid][pAdmin] < 2) return SendClientMessageEx(playerid, COLOR_GRAD2, "The newbie chat channel has been disabled by an administrator!");
	if(PlayerInfo[playerid][pNMute] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "You are muted from the newbie chat channel.");
	if(PlayerInfo[playerid][pToggledChats][0]) return SendClientMessageEx(playerid, COLOR_GREY, "You have the channel toggled, /tog newbie to re-enable!");

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
		format(string, sizeof(string), "** Advisor %s: %s", GetPlayerNameEx(playerid), params);
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
	foreach(new n: Player)
	{
		ChatTrafficProcess(n, COLOR_HELPERCHAT, string, 0);
	}
	return 1;
}

CMD:joinhelp(playerid, params[])
{
	if(PlayerInfo[playerid][pToggledChats][0] == 0)
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

	foreach(new n : Player)
	{
		if(PlayerInfo[n][pToggledChats][0] == 0)
		{
			format(szMiscArray, sizeof(szMiscArray), "* %s has joined the helper channel.", GetPlayerNameEx(playerid));
			SendClientMessageEx(n, COLOR_JOINHELPERCHAT, szMiscArray);
		}
	}
	PlayerInfo[playerid][pToggledChats][0] = 0;
	return 1;
}

CMD:leavehelp(playerid, params[])
{
	if(PlayerInfo[playerid][pToggledChats][0] == 1)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You are not in the helper channel!");
		return 1;
	}

	format(szMiscArray, sizeof(szMiscArray), "* %s has left the helper channel.", GetPlayerNameEx(playerid));
	foreach(new n: Player) ChatTrafficProcess(n, COLOR_JOINHELPERCHAT, szMiscArray, 0);
	PlayerInfo[playerid][pToggledChats][0] = 1;
	return 1;
}

CMD:hlkick(playerid, params[])
{
	if (PlayerInfo[playerid][pHelper] >= 1 || PlayerInfo[playerid][pAdmin] >= 1){
		new giveplayerid;
		if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /hlkick [player]");
		if(!IsPlayerConnected(giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");
		if(PlayerInfo[giveplayerid][pToggledChats][0] == 1) return SendClientMessageEx(playerid, COLOR_WHITE, "That person is not in the helper channel!");
		if(PlayerInfo[giveplayerid][pHelper] >= 1 || PlayerInfo[giveplayerid][pAdmin] >= 2) return SendClientMessageEx(playerid, COLOR_GREY, "You can not kick admins/advisors from the helper channel!");
		new string[128];
		HlKickTimer[giveplayerid] = gettime()+120;
		format(string, sizeof(string), "* %s has been kicked from the helper channel by %s.", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid));
		foreach(new n: Player)
		{
			if(PlayerInfo[playerid][pToggledChats][0] == 0) {
				SendClientMessageEx(n, COLOR_JOINHELPERCHAT, string);
			}
		}
		PlayerInfo[giveplayerid][pToggledChats][0] = 1;
	}
	else {
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	}
	return 1;
}*/

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
					PlayerInfo[giveplayerid][pNMuteTotal] = 0;
					CreateBan(playerid, PlayerInfo[giveplayerid][pId], giveplayerid, PlayerInfo[giveplayerid][pIP], "Excessive Newb Mutes", 10);
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
					SendClientMessageEx(playerid, COLOR_GRAD1, "That person is currently muted. You are unable to unmute players from the newbie chat as a Advisor.");
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
	if (PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pPR] > 0 || PlayerInfo[playerid][pHelper] >= 3)
	{
		new string[128], giveplayerid, level;
		if(sscanf(params, "ud", giveplayerid, level)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /makeadvisor [player] [level(1-4)]");

		if(IsPlayerConnected(giveplayerid))
		{
			if(PlayerInfo[giveplayerid][pAdmin] > 1)
			{
				SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot make admins Advisors!");
				return 1;
			}
			if(PlayerInfo[playerid][pHelper] == 3 && level > 1) return SendClientMessageEx(playerid, COLOR_GREY, "You can only promote players to Helper!");
			if(PlayerInfo[playerid][pHelper] == 4 && level > 2) return SendClientMessageEx(playerid, COLOR_GREY, "You can only promote players to Helper/Community Advisor!");

			if(PlayerInfo[giveplayerid][pHelper] < level && PlayerInfo[giveplayerid][pHelper] >= PlayerInfo[playerid][pHelper] > 2) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot set someone's rank when they're the same as you!");

			if(PlayerInfo[giveplayerid][pStaffBanned] >= 1) return SendClientMessage(playerid, COLOR_WHITE, "That player is currently staff banned.");

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
				format(string, sizeof(string), "%s has kicked you out from the Advisor team.", GetPlayerNameEx(playerid));
				SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
				format(string, sizeof(string), "You took %s's Advisor rank.", GetPlayerNameEx(giveplayerid));
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
				format(string, sizeof(string), "%s(%d) has had their advisor removed by %s(%d)", GetPlayerNameEx(giveplayerid), PlayerInfo[giveplayerid][pId], GetPlayerNameEx(playerid), PlayerInfo[playerid][pId]);
				Log("logs/admin.log", string);

			}

		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	}
	return 1;
}

CMD:requesthelp(playerid, params[])
{
	if(Advisors < 1)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "   There are no Advisors On Duty at the moment, try again later!");
		return 1;
	}
	if(isnull(params))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /requesthelp [reason]");
		return 1;
	}

	new string[128];
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
	format(string, sizeof(string), "** %s (%i) is requesting help, reason: %s. (type /accepthelp %i)", GetPlayerNameEx(playerid), playerid, params, playerid);
	SendDutyAdvisorMessage(TEAM_AZTECAS_COLOR, string);
	SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You have requested help from a Advisor, wait for a reply.");
	SetPVarInt( playerid, "COMMUNITY_ADVISOR_REQUEST", 1 );
	SetPVarInt( playerid, "HelpTime", 5);
	SetPVarString( playerid, "HelpReason", params);
	SetTimerEx( "HelpTimer", 60000, 0, "d", playerid);
	return 1;
}

CMD:showrequests(playerid, params[])
{
	if(PlayerInfo[playerid][pHelper] >= 2 || PlayerInfo[playerid][pPR] || PlayerInfo[playerid][pAdmin] >= 2)
	{
		new string[128], reason[64];
		SendClientMessageEx(playerid, COLOR_GREEN, "____________________ HELP REQUESTS _____________________");
		foreach(new i: Player)
		{
			if(GetPVarInt(i, "COMMUNITY_ADVISOR_REQUEST"))
			{
				GetPVarString(i, "HelpReason", reason, 64);
				format(string, sizeof(string), "%s  | ID: %i | Reason: %s | Expires in: %i minutes.", GetPlayerNameEx(i), i, reason, GetPVarInt(i, "HelpTime"));
				SendClientMessageEx(playerid, COLOR_REPORT, string);
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

					ShowPlayerDialogEx(giveplayerid, 7954, DIALOG_STYLE_MSGBOX, "Help request abuse warning", "A Advisor has warned you not to abuse /requesthelp.\n\nNote that future abuse of /requesthelp could result in a mute from /requesthelp or loss of that privilege altogether.", "Next", "");

					format(string, sizeof(string), "AdmCmd: %s(%d) has given %s(%d) their first warning about help request abuse", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid));
					Log("logs/mute.log", string);

			    }
			    else if(PlayerInfo[giveplayerid][pRHMutes] == 1)
			    {
  					PlayerInfo[giveplayerid][pRHMutes] = 2;
					PlayerInfo[giveplayerid][pRHMuteTime] = 30*60;
					format(string, sizeof(string), "*** %s has temporarily blocked %s from using /requesthelp", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
					SendAdvisorMessage(COLOR_COMBINEDCHAT, string);

					ShowPlayerDialogEx(giveplayerid, 7954, DIALOG_STYLE_MSGBOX, "Temporarily blocked from /requesthelp", "You have been temporarily blocked from using /requesthelp\n\nAs this is the first time you have been blocked from requesting help, you will not be able to use /requesthelp for 30 minutes.\n\nTwo more mute will result in a total loss in privilege of the command.", "Next", "");

					format(string, sizeof(string), "AdmCmd: %s(d) was temporarily blocked from /requesthelp by %s(%d)", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), GetPlayerNameEx(playerid), GetPlayerSQLId(playerid));
					Log("logs/mute.log", string);
			    }
			    else if(PlayerInfo[giveplayerid][pRHMutes] == 2)
			    {
  					PlayerInfo[giveplayerid][pRHMutes] = 3;
					PlayerInfo[giveplayerid][pRHMuteTime] = 90*60;
					format(string, sizeof(string), "*** %s has temporarily blocked %s from using /requesthelp", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
					SendAdvisorMessage(COLOR_COMBINEDCHAT, string);

					ShowPlayerDialogEx(giveplayerid, 7954, DIALOG_STYLE_MSGBOX, "Temporarily blocked from /requesthelp", "You have been temporarily blocked from using /requesthelp\n\nAs this is the second time you have been blocked from requesting help, you will not be able to use /requesthelp for 1 hour and 30 minutes.\n\nOne more mute will result in a total loss in privilege of the command.", "Next", "");

					format(string, sizeof(string), "AdmCmd: %s(%d) was temporarily blocked from /requesthelp by %s(%d)", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), GetPlayerNameEx(playerid), GetPlayerSQLId(playerid));
					Log("logs/mute.log", string);
			    }
				else if(PlayerInfo[giveplayerid][pRHMutes] == 3)
			    {
  					PlayerInfo[giveplayerid][pRHMutes] = 4;
					format(string, sizeof(string), "*** %s has permanently blocked %s from using /requesthelp", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
					SendAdvisorMessage(COLOR_COMBINEDCHAT, string);

					ShowPlayerDialogEx(giveplayerid,7954,DIALOG_STYLE_MSGBOX, "Permanently blocked from /requesthelp", "You have been permanently blocked from using /requesthelp.\n\nYou will need to contact an Administrator via /report to appeal this.", "Next", "");

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

CMD:findnewb(playerid, params[]) {

	if(PlayerInfo[playerid][pHelper] < 2) {
        SendClientMessageEx(playerid, COLOR_GREY, "You are not a Advisor.");
	}
	else if(GetPVarInt(playerid, "AdvisorDuty") == 0) {
	    SendClientMessageEx(playerid, COLOR_GREY, "You are not on duty as a Advisor.");
	}
	else {
	    new Float: Pos[3][2], i[2], vw[2];
	    if(!GetPVarType(playerid, "HelpingSomeone")) {
     		foreach(new x: Player) {

				if(PlayerInfo[x][pLevel] == 1 && PlayerInfo[x][pHelpedBefore] == 0 && PlayerInfo[x][pAdmin] == 0 && PlayerInfo[x][pId] != PlayerInfo[playerid][pId]) {
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
					SetPlayerHealth(playerid, 999999);
					ShowPlayerDialogEx(x, 0, DIALOG_STYLE_MSGBOX, "Advisor Alert", "A Advisor has just teleported to you. Feel free to ask him anything related to Next Generation Gaming that you may have issues/concerns with.", "Close", "");
					if(i[0] > 0 || vw[0] > 0) Player_StreamPrep(playerid, Pos[0][0], Pos[1][0], Pos[2][0], FREEZE_TIME);
					format(szMiscArray, sizeof(szMiscArray), "You have been teleported to newbie %s, retype the command to be teleported back.", GetPlayerNameEx(x));
					SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
					break;
				}
			}
		}
		else
		{
		    DeletePVar(playerid, "HelpingSomeone");
			SetHealth(playerid, 100);
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
        SendClientMessageEx(playerid, COLOR_GREY, "You are not a Advisor.");
	}
	else if(HelpingNewbie[playerid] != INVALID_PLAYER_ID) {
	    SendClientMessageEx(playerid, COLOR_GREY, "You are already helping someone.");
	}
	else if(GetPVarInt(playerid, "AdvisorDuty") == 0) {
	    SendClientMessageEx(playerid, COLOR_GREY, "You are not on duty as a Advisor.");
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
			SetPlayerPos(playerid, x, y+2, z+0.75);
			SetPlayerVirtualWorld(playerid, vw);
			SetPlayerInterior(playerid, i);
			GetHealth(playerid,health);
			SetPVarFloat(playerid, "pPreGodHealth", health);
			GetArmour(playerid,armor);
			SetPVarFloat(playerid, "pPreGodArmor", armor);
			SetHealth(playerid, 0x7FB00000);
		    SetArmour(playerid, 0x7FB00000);
		    SetPVarInt(playerid, "pGodMode", 1);
			if(i > 0 || vw > 0) Player_StreamPrep(playerid, x, y, z, 6000);
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
		SetHealth(playerid,health);
		armor = GetPVarFloat(playerid, "pPreGodArmor");
		if(armor > 0) {
			SetArmour(playerid,armor);
		}
		else
		{
			RemoveArmor(playerid);
		}
		DeletePVar(playerid, "pPreGodHealth");
		DeletePVar(playerid, "pPreGodArmor");
		if(GetPVarType(playerid, "BusinessesID")) DeletePVar(playerid, "BusinessesID");
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
		PlayerInfo[playerid][pToggledChats][16] = 1;
		SendClientMessageEx(playerid, COLOR_GRAD1, "** You have disabled Advisor chat.");
		return SetPVarInt(playerid, "CAChat", 0);
	}
	else
	{
		PlayerInfo[playerid][pToggledChats][16] = 0;
		SendClientMessageEx(playerid, COLOR_GRAD1, "** You have enabled Advisor chat.");
		return SetPVarInt(playerid, "CAChat", 1);
	}
}

CMD:ca(playerid, params[])
{
	if(PlayerInfo[playerid][pJailTime] && strfind(PlayerInfo[playerid][pPrisonReason], "[OOC]", true) != -1) return SendClientMessageEx(playerid, COLOR_GREY, "OOC prisoners are restricted to only speak in /b");
	if(PlayerInfo[playerid][pHelper] < 1 && PlayerInfo[playerid][pAdmin] < 2) return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not authorized to use this command!");
	if(PlayerInfo[playerid][pToggledChats][16] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "You have Advisor chat disabled - /tog advisor or /settings to enable it.");
	if(isnull(params)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /ca [text]");
	if(strlen(params) >= 128)  return SendClientMessageEx(playerid, COLOR_GREY, "Your input was too long. ");
	szMiscArray[0] = 0;

	format(szMiscArray, sizeof(szMiscArray), "- %s %s: %s", GetStaffRank(playerid), GetPlayerNameEx(playerid), params);
	foreach(new i : Player)
	{
		if((PlayerInfo[i][pHelper] >= 1 || PlayerInfo[i][pAdmin] >= 2) && !PlayerInfo[playerid][pToggledChats][16])
		{
			ChatTrafficProcess(i, 0x5288f3FF, szMiscArray, 16);
		}
	}
	return 1;
}
