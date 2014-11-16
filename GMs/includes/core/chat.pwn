/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Chat System

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

CMD:togooc(playerid, params[])
{
	if (!gOoc[playerid])
	{
		gOoc[playerid] = 1;
		SendClientMessageEx(playerid, COLOR_GRAD2, "You have disabled global OOC chat.");
	}
	else
	{
		gOoc[playerid] = 0;
		SendClientMessageEx(playerid, COLOR_GRAD2, "You have enabled global OOC chat.");
	}
	return 1;
}

CMD:togwhisper(playerid, params[])
{
	if (!HidePM[playerid])
	{
		HidePM[playerid] = 1;
		SendClientMessageEx(playerid, COLOR_GRAD2, "You have disabled whisper chat.");
	}
	else
	{
		HidePM[playerid] = 0;
		SendClientMessageEx(playerid, COLOR_GRAD2, "You have enabled whisper chat.");
	}
	return 1;
}

CMD:me(playerid, params[])
{
	if(PlayerInfo[playerid][pJailTime] && strfind(PlayerInfo[playerid][pPrisonReason], "[OOC]", true) != -1) return SendClientMessageEx(playerid, COLOR_GREY, "OOC prisoners are restricted to only speak in /b");
	if(isnull(params)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /me [action]");
	new string[128];
	format(string, sizeof(string), "{FF8000}* {C2A2DA}%s %s", GetPlayerNameEx(playerid), params);
	ProxDetectorWrap(playerid, string, 92, 30.0, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
	return 1;
}

CMD:whisper(playerid, params[]) {
	return cmd_w(playerid, params);
}

CMD:w(playerid, params[])
{
	if(PlayerInfo[playerid][pJailTime] && strfind(PlayerInfo[playerid][pPrisonReason], "[OOC]", true) != -1) return SendClientMessageEx(playerid, COLOR_GREY, "OOC prisoners are restricted to only speak in /b");
	new giveplayerid, whisper[128];

	if(gPlayerLogged{playerid} == 0)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You're not logged in.");
		return 1;
	}
	if(sscanf(params, "us[128]", giveplayerid, whisper))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: (/w)hisper [player] [text]");
		return 1;
	}
	if(WatchingTV[playerid] != 0 && PlayerInfo[playerid][pAdmin] < 2)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "You can't do this while watching TV.");
		return 1;
	}
	if (IsPlayerConnected(giveplayerid))
	{
		if(HidePM[giveplayerid] > 0 && PlayerInfo[playerid][pAdmin] < 2)
		{
			SendClientMessageEx(playerid, COLOR_GREY, "That person is blocking whispers!");
			return 1;
		}
		new giveplayer[MAX_PLAYER_NAME], sendername[MAX_PLAYER_NAME], string[128];
		sendername = GetPlayerNameEx(playerid);
		giveplayer = GetPlayerNameEx(giveplayerid);
		if(giveplayerid == playerid)
		{
			if(PlayerInfo[playerid][pSex] == 1) format(string, sizeof(string), "* %s mutters something to himself.", GetPlayerNameEx(playerid));
			else format(string, sizeof(string), "* %s mutters something to herself.", GetPlayerNameEx(playerid));
			return ProxDetector(5.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		}
		if(ProxDetectorS(5.0, playerid, giveplayerid) || PlayerInfo[playerid][pAdmin] >= 2)
		{
		    //foreach(new i: Player)
			for(new i = 0; i < MAX_PLAYERS; ++i)
			{
				if(IsPlayerConnected(i))
				{
					if(GetPVarInt(i, "BigEar") == 6 && (GetPVarInt(i, "BigEarPlayer") == playerid || GetPVarInt(i, "BigEarPlayer")  == giveplayerid))
					{
						format(string, sizeof(string), "(BE)%s(ID %d) whispers to %s(ID %d): %s", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(giveplayerid), giveplayerid, whisper);
						SendClientMessageWrap(i, COLOR_YELLOW, 92, string);
					}
				}	
			}

			format(string, sizeof(string), "%s (ID %d) whispers to you: %s", GetPlayerNameEx(playerid), playerid, whisper);
			SendClientMessageWrap(giveplayerid, COLOR_YELLOW, 92, string);

			format(string, sizeof(string), "You whispered to %s: %s", GetPlayerNameEx(giveplayerid),whisper);
			SendClientMessageWrap(playerid, COLOR_YELLOW, 92, string);
			return 1;
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "That person isn't near you.");
		}
		return 1;
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid player specified.");
	}
	return 1;
}

CMD:do(playerid, params[])
{
	if(gPlayerLogged{playerid} == 0)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You're not logged in.");
		return 1;
	}
	if(PlayerInfo[playerid][pJailTime] && strfind(PlayerInfo[playerid][pPrisonReason], "[OOC]", true) != -1) return SendClientMessageEx(playerid, COLOR_GREY, "OOC prisoners are restricted to only speak in /b");
	if(isnull(params)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /do [action]");
	else if(strlen(params) > 120) return SendClientMessageEx(playerid, COLOR_GREY, "The specified message must not be longer than 120 characters in length.");
	new
		iCount,
		iPos,
		iChar;

	while((iChar = params[iPos++])) {
		if(iChar == '@') iCount++;
	}
	if(iCount >= 5) {
		return SendClientMessageEx(playerid, COLOR_GREY, "The specified message must not contain more than 4 '@' symbols.");
	}

	new string[150];
	format(string, sizeof(string), "* %s (( %s ))", params, GetPlayerNameEx(playerid));
	ProxDetectorWrap(playerid, string, 92, 30.0, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
	return 1;
}

CMD:ooc(playerid, params[])
{
	if(gPlayerLogged{playerid} == 0)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You're not logged in.");
		return 1;
	}
	if ((noooc) && PlayerInfo[playerid][pAdmin] < 2 && EventKernel[EventCreator] != playerid)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "   The OOC channel has been disabled by an Admin!");
		return 1;
	}
	if(gOoc[playerid])
	{
		SendClientMessageEx(playerid, TEAM_CYAN_COLOR, "   You have disabled OOC Chat, re-enable with /togooc!");
		return 1;
	}
	if(isnull(params)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: (/o)oc [ooc chat]");

	if(PlayerInfo[playerid][pAdmin] == 1)
	{
		new string[128];
		format(string, sizeof(string), "(( Moderator %s: %s ))", GetPlayerNameEx(playerid), params);
		OOCOff(COLOR_OOC,string);
	}
	else if(PlayerInfo[playerid][pAdmin] >= 2)
	{
		new string[128];
		format(string, sizeof(string), "(( %s %s: %s ))", GetAdminRankName(PlayerInfo[playerid][pAdmin]), GetPlayerNameEx(playerid), params);
		OOCOff(COLOR_OOC,string);
	}
	else if(PlayerInfo[playerid][pHelper] >= 2)
	{
		new string[128];
		format(string, sizeof(string), "(( Community Advisor %s: %s ))", GetPlayerNameEx(playerid), params);
		OOCOff(COLOR_OOC,string);
		return 1;
	}
	else if(PlayerInfo[playerid][pAdmin] < 1 && PlayerInfo[playerid][pHelper] <= 2)
	{
		new string[128];
		format(string, sizeof(string), "(( %s: %s ))", GetPlayerNameEx(playerid), params);
		OOCOff(COLOR_OOC,string);
		return 1;
	}
	return 1;
}

CMD:o(playerid, params[]) 
{
	return SendClientMessageEx(playerid, COLOR_GRAD1, "/o has been renamed to /ooc to prevent typos.");
}

CMD:shout(playerid, params[]) {
	return cmd_s(playerid, params);
}

CMD:s(playerid, params[])
{
	if(PlayerInfo[playerid][pJailTime] && strfind(PlayerInfo[playerid][pPrisonReason], "[OOC]", true) != -1) return SendClientMessageEx(playerid, COLOR_GREY, "OOC prisoners are restricted to only speak in /b");
	if(gPlayerLogged{playerid} == 0)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You're not logged in.");
		return 1;
	}

	if(isnull(params)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: (/s)hout [shout chat]");
	new string[128];
	format(string, sizeof(string), "(shouts) %s!", params);
	SetPlayerChatBubble(playerid,string,COLOR_WHITE,60.0,5000);
	format(string, sizeof(string), "%s shouts: %s!", GetPlayerNameEx(playerid), params);
	ProxDetector(30.0, playerid, string,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_FADE1,COLOR_FADE2, 1);
	return 1;
}

CMD:low(playerid, params[]) {
	return cmd_l(playerid, params);
}

CMD:l(playerid, params[])
{
	if(gPlayerLogged{playerid} == 0)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You're not logged in.");
		return 1;
	}
	if(PlayerInfo[playerid][pJailTime] && strfind(PlayerInfo[playerid][pPrisonReason], "[OOC]", true) != -1) return SendClientMessageEx(playerid, COLOR_GREY, "OOC prisoners are restricted to only speak in /b");
	if(isnull(params)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: (/l)ow [close chat]");

	new string[128];
	format(string, sizeof(string), "%s says quietly: %s", GetPlayerNameEx(playerid), params);
	ProxDetector(5.0, playerid, string,COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5, 1);
	format(string, sizeof(string), "(quietly) %s", params);
	SetPlayerChatBubble(playerid,string,COLOR_WHITE,5.0,5000);
	return 1;
}

CMD:b(playerid, params[])
{
	if(gPlayerLogged{playerid} == 0)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You're not logged in.");
		return 1;
	}
	if(isnull(params)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /b [local ooc chat]");
	new string[128];
	format(string, sizeof(string), "%s: (( %s ))", GetPlayerNameEx(playerid), params);
	ProxDetector(20.0, playerid, string,COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5);

	//foreach(new i: Player)
	for(new i = 0; i < MAX_PLAYERS; ++i)
	{
		if(IsPlayerConnected(i))
		{
			if(PlayerInfo[i][pAdmin] > 1 && GetPVarInt(i, "BigEar") == 2)
			{
				new szAntiprivacy[128];
				format(szAntiprivacy, sizeof(szAntiprivacy), "(BE) %s: %s", GetPlayerNameEx(playerid), params);
				SendClientMessageEx(i, COLOR_FADE1, szAntiprivacy);
			}
		}	
	}
	return 1;
}
