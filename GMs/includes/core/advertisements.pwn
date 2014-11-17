/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

					Advertisements System

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

CMD:ad(playerid, params[])
{
	SendClientMessageEx(playerid, COLOR_WHITE, "The /ad command has been removed - use /ads or /advertisements.");
	return 1;
}

CMD:ads(playerid, params[]) {
	return cmd_advertisements(playerid, params);
}

CMD:advertisements(playerid, params[]) {
	if(gPlayerLogged{playerid} == 0) {
		SendClientMessageEx(playerid, COLOR_GREY, "You're not logged in.");
	}
	else if(GetPVarType(playerid, "Injured")) {
		SendClientMessageEx(playerid, COLOR_GREY, "You can't use advertisements while injured.");
	}
	else if(PlayerCuffed[playerid] != 0) {
		SendClientMessageEx(playerid, COLOR_GREY, "You can't use advertisements right now.");
	}
	else if(PlayerInfo[playerid][pJailTime] > 0) {
		SendClientMessageEx(playerid, COLOR_GREY, "You can't use advertisements while in jail.");
	}
	else ShowPlayerDialog(playerid, DIALOG_ADMAIN, DIALOG_STYLE_LIST, "Advertisements", "List Advertisements\nSearch Advertisements\nPlace Advertisement\nPlace Priority Advertisement", "Select", "Cancel");
	return 1;
}

CMD:adunmute(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[playerid][pWatchdog] >= 2)
	{
		new string[128], giveplayerid;
		if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /adunmute [player]");

		if(IsPlayerConnected(giveplayerid))
		{
			if(PlayerInfo[giveplayerid][pADMute] == 1)
			{
				if(PlayerInfo[giveplayerid][pJailTime] != 0)
				{
					SendClientMessageEx(playerid, COLOR_LIGHTRED, "You cannot offer someone in jail/prison an unmute!");
					SendClientMessageEx(giveplayerid, COLOR_LIGHTRED, "Sorry, you cannot be unmuted from /ad while you are in jail/prison.");
					return 1;
				}
				format(string, sizeof(string), "AdmCmd: %s(%d) was unmuted from /ad by %s.", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), GetPlayerNameEx(playerid));
				Log("logs/admin.log", string);
				format(string, sizeof(string), "AdmCmd: %s was unmuted from /ad by %s.", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid));
				ABroadCast(COLOR_LIGHTRED,string,2);
				PlayerInfo[giveplayerid][pADMute] = 0;
				PlayerInfo[giveplayerid][pADMuteTotal]--;
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_LIGHTRED,"That person is not muted from /newb!");
			}

		}
	}
	return 1;
}

CMD:admute(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[playerid][pHelper] >= 2 || PlayerInfo[playerid][pSMod] == 1 || PlayerInfo[playerid][pWatchdog] >= 2)
	{
		new string[128], giveplayerid;
		if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /admute [player]");

		if(IsPlayerConnected(giveplayerid))
		{
				if(PlayerInfo[giveplayerid][pAdmin] >= 2) return SendClientMessageEx(playerid, COLOR_LIGHTRED, "You can't /admute admins");
				if(PlayerInfo[giveplayerid][pADMute] == 0)
				{
				    SetPVarInt(giveplayerid, "UnmuteTime", gettime());
					PlayerInfo[giveplayerid][pADMute] = 1;
					PlayerInfo[giveplayerid][pADMuteTotal] += 1;
					format(string, sizeof(string), "AdmCmd: %s(%d) was muted from placing /ad's by %s(%d).", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), GetPlayerNameEx(playerid), GetPlayerSQLId(playerid));
					Log("logs/admin.log", string);
					format(string, sizeof(string), "AdmCmd: %s was muted from placing /ad's by %s.", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid));
					ABroadCast(COLOR_LIGHTRED,string,2);

					if(PlayerInfo[giveplayerid][pADMuteTotal] > 6)
					{
						new playerip[32];
						GetPlayerIp(giveplayerid, playerip, sizeof(playerip));
						format(string, sizeof(string), "AdmCmd: %s(%d) (IP:%s) was banned by %s, reason: Excessive advertisement mutes", GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), playerip,GetPlayerNameEx(playerid));
						Log("logs/ban.log", string);
						format(string, sizeof(string), "AdmCmd: %s was banned, reason: Excessive advertisement mutes.", GetPlayerNameEx(giveplayerid));
						SendClientMessageToAllEx(COLOR_LIGHTRED, string);
						PlayerInfo[giveplayerid][pBanned] = 1;
						new ip[32];
						GetPlayerIp(giveplayerid,ip,sizeof(ip));
						AddBan(playerid, giveplayerid, "Excessive advertisement mutes");
						MySQLBan(GetPlayerSQLId(giveplayerid),ip,"Excessive advertisement mutes", 1,GetPlayerNameEx(playerid));
						SetTimerEx("KickEx", 1000, 0, "i", giveplayerid);
					}

					if(PlayerInfo[playerid][pAdmin] == 1)
					{
						format(string, sizeof(string), "AdmCmd: %s was muted from placing /ad's by Admin.", GetPlayerNameEx(giveplayerid));
						SendDutyAdvisorMessage(TEAM_AZTECAS_COLOR, string);
						SendClientMessageEx(giveplayerid, COLOR_LIGHTRED, "You were just muted from Advertisements [/ads] by an Admin.");
					}
					else
					{
						format(string, sizeof(string), "AdmCmd: %s was muted from placing /ad's by %s.", GetPlayerNameEx(giveplayerid), GetPlayerNameEx(playerid));
						SendDutyAdvisorMessage(TEAM_AZTECAS_COLOR, string);
						format(string, sizeof(string), "You were just muted from the Advertisements (/ads) by %s.", GetPlayerNameEx(playerid));
						SendClientMessageEx(giveplayerid, COLOR_LIGHTRED, string);
					}

					SendClientMessageEx(giveplayerid, COLOR_LIGHTRED, "Remember, advertisements may only be used for IC purposes and may not be used for any other purpose, unless stated otherwise by an admin.");
					SendClientMessageEx(giveplayerid, COLOR_LIGHTRED, "If you wish to be unmuted, you will be fined or jailed. Future abuse could result in increased punishment. If you feel this was in error, contact a senior administrator.");

					format(string, sizeof(string), "AdmCmd: %s was just muted from using Advertisements [/ads] due to misuse.", GetPlayerNameEx(giveplayerid));
					SendClientMessageToAllEx(COLOR_LIGHTRED, string);
				}
				else
				{
					if(PlayerInfo[playerid][pAdmin] >= 2)
					{
						ShowAdMuteFine(giveplayerid);
						format(string, sizeof(string), "You offered %s an unmute from /ads.", GetPlayerNameEx(giveplayerid));
						SendClientMessageEx(playerid, COLOR_LIGHTRED, string);
					}
					else
					{
						SendClientMessageEx(playerid, COLOR_GRAD1, "That person is currently muted. You are unable to unmute players from advertisements as a Community Advisor.");
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

CMD:freeads(playerid, params[])
{
	if(PlayerInfo[playerid][pDonateRank] < 4) return SendClientMessageEx(playerid, COLOR_GREY, "You are not a Platinum VIP+");
	new string[128], days;
	ConvertTime(gettime() - PlayerInfo[playerid][pFreeAdsDay], .ctd=days);
	if(days >= 1)
	{
		PlayerInfo[playerid][pFreeAdsDay] = gettime();
		PlayerInfo[playerid][pFreeAdsLeft] = 3;
		SendClientMessageEx(playerid, COLOR_YELLOW, "* You still have 3 free ads left for today.");
	}	
	else if(PlayerInfo[playerid][pFreeAdsLeft] > 0)
	{
		format(string, sizeof(string), "* You still have %d free ads left for today.", PlayerInfo[playerid][pFreeAdsLeft]);
		SendClientMessageEx(playerid, COLOR_YELLOW, string);
	}
	else
	{
		new datestring[32];
		datestring = date(PlayerInfo[playerid][pFreeAdsDay]+86400, 3);
		format(string, sizeof(string), "* You have used all your free ads, you will need to wait until %s.", datestring);
		SendClientMessageEx(playerid, COLOR_YELLOW, string);
	}
	return 1;
}
