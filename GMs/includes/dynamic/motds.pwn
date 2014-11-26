/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

					Dynamic MOTD System

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

CMD:motd(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 1337)
    {
		if(isnull(params)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /motd [message]");
		new string[128];
    	format(string, sizeof(string), "AdmCmd: %s has changed the global motd to: %s.", GetPlayerNameEx(playerid), params);
		ABroadCast( COLOR_LIGHTRED, string, 4);
		format(GlobalMOTD, sizeof(GlobalMOTD), "%s", params);
		SendClientMessageEx(playerid, COLOR_WHITE, "You've adjusted the Global MOTD.");
		g_mysql_SaveMOTD();
	}
	return 1;
}

CMD:amotd(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 1337)
    {
		if(isnull(params)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /amotd [message]");
		new string[128];
		format(AdminMOTD, sizeof(AdminMOTD), "%s", params);
		format(string, sizeof(string), "AdmCmd: %s has changed the admin motd to: %s.", GetPlayerNameEx(playerid), params);
		ABroadCast( COLOR_LIGHTRED, string, 4);
		SendClientMessageEx(playerid, COLOR_WHITE, "You've adjusted the Admin MOTD.");
		g_mysql_SaveMOTD();
	}
	return 1;
}

CMD:vipmotd(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 1337)
    {
		if(isnull(params)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /vipmotd [message]");
		new string[128];
		format(VIPMOTD, sizeof(VIPMOTD), "%s", params);
		format(string, sizeof(string), "AdmCmd: %s has changed the VIP motd to: %s.", GetPlayerNameEx(playerid), params);
		ABroadCast( COLOR_LIGHTRED, string, 4);
		SendClientMessageEx(playerid, COLOR_WHITE, "You've adjusted the VIP MOTD.");
		g_mysql_SaveMOTD();
	}
	return 1;
}

CMD:cmotd(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pHelper] >= 4 || PlayerInfo[playerid][pPR] > 0)
    {
		if(isnull(params)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /cmotd [message]");
		new string[128];
		format(CAMOTD, sizeof(CAMOTD), "%s", params);
		if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pPR] > 0)
		{
			format(string, sizeof(string), "AdmCmd: %s has changed the Community Advisor motd to: %s.", GetPlayerNameEx(playerid), params);
			ABroadCast( COLOR_LIGHTRED, string, 4);
		}
		else if(PlayerInfo[playerid][pHelper] >= 4)
		{
		    format(string, sizeof(string), "CACmd: %s has changed the Community Advisor motd to: %s.", GetPlayerNameEx(playerid), params);
			CBroadCast( COLOR_YELLOW, string, 2);
		}
		SendClientMessageEx(playerid, COLOR_WHITE, "You've adjusted the Community Advisor MOTD.");
		g_mysql_SaveMOTD();
	}
	return 1;
}

CMD:pmotd(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 99999 || PlayerInfo[playerid][pShopTech] >= 3 || PlayerInfo[playerid][pPR] >= 2)
    {
		if(isnull(params)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /pmotd [message/off]");
		new string[128];
		if(strcmp(params, "off", true) == 0)
		{
		    format(pMOTD, sizeof(pMOTD), "");
		    format(string, sizeof(string), "AdmCmd: %s has turned off the Global MOTD", GetPlayerNameEx(playerid));
			ABroadCast( COLOR_LIGHTRED, string, 4);

			SendClientMessageEx(playerid, COLOR_WHITE, "You've adjusted the pMOTD.");
			g_mysql_SaveMOTD();
			return 1;
		}
		format(pMOTD, sizeof(pMOTD), "%s", params);

		format(string, sizeof(string), "AdmCmd: %s has changed the global motd to: %s.", GetPlayerNameEx(playerid), params);
		ABroadCast( COLOR_LIGHTRED, string, 4);

		SendClientMessageEx(playerid, COLOR_WHITE, "You've adjusted the pMOTD.");
		g_mysql_SaveMOTD();
	}
	return 1;
}

CMD:gmotd(playerid, params[])
{
	new iGroupID = PlayerInfo[playerid][pLeader];
	if (0 <= iGroupID < MAX_GROUPS) {
		if (!isnull(params)) {
		    strcpy(arrGroupData[iGroupID][g_szGroupMOTD], params, 128);
			SendClientMessageEx(playerid, COLOR_WHITE, "You've adjusted the group MOTD.");
			SaveGroup(iGroupID);
			new string[256];
			format(string,sizeof(string),"%s (%d) has changed MOTD for %s to: %s", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), arrGroupData[iGroupID][g_szGroupName], params);
			GroupLog(iGroupID, string);
		} else SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /gmotd [message]");
	} else SendClientMessageEx(playerid, COLOR_GREY, "Only group leaders may use this command.");
	return 1;
}

CMD:fmotd(playerid, params[])
{
	if(PlayerInfo[playerid][pFMember] == INVALID_FAMILY_ID) return SendClientMessageEx(playerid, COLOR_GREY, "You aren't in a family.");
	if(PlayerInfo[playerid][pRank] < 5) return SendClientMessageEx(playerid, COLOR_GREY, "   You do not have a high enough rank to use this command!");
	new string[128], slot, family = PlayerInfo[playerid][pFMember];
	if(sscanf(params, "ds[128]", slot, string)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /fmotd [slot] [family MOTD text]");
	if(strlen(string) > 128) return SendClientMessageEx( playerid, COLOR_GRAD1, "That MOTD is too long, please refrain from using more than 128 characters." );
	if(1 <= slot <= 3)
	{
		new file[32], month, day, year ;
		getdate(year,month,day);
		strmid(FamilyMOTD[family][slot-1], string, 0, strlen(string), 128);
		SaveFamilies();
		format(string, sizeof(string), "%s adjusted %s's MOTD (slot %d) to %s", GetPlayerNameEx(playerid), FamilyInfo[family][FamilyName], slot, string);
		format(file, sizeof(file), "family_logs/%d/%d-%02d-%02d.log", family, year, month, day);
		Log(file, string);
		format(string, sizeof(string),"You've adjusted your family's MOTD in slot %d.", slot);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD2, "Slot ID Must be between 1 and 3!");
	return 1;
}

CMD:viewmotd(playerid, params[])
{
	new string[128], option[16];
	if(sscanf(params, "s[16]", option)) 
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /viewmotd [option]");
		strcat(string, "Available Options: global, player");
		if(PlayerInfo[playerid][pDonateRank] >= 1) strcat(string, ", vip");
		if(PlayerInfo[playerid][pFMember] != INVALID_FAMILY_ID) strcat(string, ", family");
		if(PlayerInfo[playerid][pMember] != INVALID_GROUP_ID) strcat(string, ", group");
		if(PlayerInfo[playerid][pHelper] >= 1) strcat(string, ", advisor");
		if(PlayerInfo[playerid][pAdmin] > 1) strcat(string, ", admin");
		return SendClientMessageEx(playerid, COLOR_WHITE, string);
	}
	if(strcmp(option, "global", true) == 0) return SendClientMessageEx(playerid, COLOR_YELLOW, GlobalMOTD);
	if(strcmp(option, "player", true) == 0) return SendClientMessageEx(playerid, COLOR_YELLOW, pMOTD);
	if(strcmp(option, "vip", true) == 0 && PlayerInfo[playerid][pDonateRank] >= 1) return SendClientMessageEx(playerid, COLOR_VIP, VIPMOTD);
	if(strcmp(option, "family", true) == 0 && PlayerInfo[playerid][pFMember] != INVALID_FAMILY_ID)
	{
		new fam = PlayerInfo[playerid][pFMember];
		SendClientMessageEx(playerid, COLOR_WHITE, "Family MOTD's:");
		for(new i = 1; i <= 3; i++)
		{
			format(string, sizeof(string), "%d: %s", i, FamilyMOTD[fam][i-1]);
			SendClientMessageEx(playerid, COLOR_YELLOW, string);
		}
	}
	if(strcmp(option, "group", true) == 0 && PlayerInfo[playerid][pMember] != INVALID_GROUP_ID)
		return SendClientMessageEx(playerid, arrGroupData[PlayerInfo[playerid][pMember]][g_hDutyColour] * 256 + 255, arrGroupData[PlayerInfo[playerid][pMember]][g_szGroupMOTD]);
	if(strcmp(option, "advisor", true) == 0 && PlayerInfo[playerid][pHelper] >= 1) return SendClientMessageEx(playerid, TEAM_AZTECAS_COLOR, CAMOTD);
	if(strcmp(option, "admin", true) == 0 && PlayerInfo[playerid][pAdmin] > 1) return SendClientMessageEx(playerid, COLOR_YELLOW, AdminMOTD);
	return 1;
}
