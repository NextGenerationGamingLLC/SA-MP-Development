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

#include <YSI\y_hooks>


hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	switch(dialogid) {

		case DIALOG_ADO: {

			if(!response) return DeletePVar(playerid, "actionstring");

			new iTargetID = ListItemTrackId[playerid][listitem],
				szMessage[150];

			GetPVarString(playerid, "actionstring", szMessage, sizeof(szMessage));
			SetPVarInt(iTargetID, "actionplayer", playerid);
			format(szMiscArray, sizeof(szMiscArray), " ** Sent: {C2A2DA}%s attempts to %s", GetPlayerNameEx(playerid), szMessage);
			SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
			format(szMiscArray, sizeof(szMiscArray), " * > Action request sent to: %s. Awaiting response...", GetPlayerNameEx(iTargetID));
			SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);

			format(szMiscArray, sizeof(szMiscArray), "Sender: %s\n\nAction: %s (( %s ))\n\n\
				Select 'Accept' to accept the action.\n\
				Select 'Deny' to deny the action. You will need to provide a reason.", GetPlayerNameExt(playerid), szMessage, GetPlayerNameExt(playerid));
			ShowPlayerDialogEx(iTargetID, DIALOG_ADO2, DIALOG_STYLE_MSGBOX, "Incoming Action Request", szMiscArray, "Accept", "Deny");
		}
		case DIALOG_ADO2: {

			if(!response) {

				return ShowPlayerDialogEx(playerid, DIALOG_ADO3, DIALOG_STYLE_INPUT, "Action Denied", "Please provide a reason for denying the action request", "Submit", "Cancel");
			}
			new iActionID = GetPVarInt(playerid, "actionplayer");
			GetPVarString(iActionID, "actionstring", szMiscArray, sizeof(szMiscArray));
			format(szMiscArray, sizeof(szMiscArray), "* %s (( %s ))", szMiscArray, GetPlayerNameExt(iActionID));
			ProxDetectorWrap(playerid, szMiscArray, 92, 30.0, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
			DeletePVar(iActionID, "actionstring");
			DeletePVar(playerid, "actionplayer");

		}
		case DIALOG_ADO3: {

			new iActionID = GetPVarInt(playerid, "actionplayer");
			format(szMiscArray, sizeof(szMiscArray), " * %s denied the action.", GetPlayerNameExt(iActionID));
			SendClientMessage(iActionID, COLOR_PURPLE, szMiscArray);
			format(szMiscArray, sizeof(szMiscArray), " * Reason: %s.", inputtext);
			SendClientMessage(iActionID, COLOR_YELLOW, szMiscArray);
			SendClientMessage(playerid, COLOR_PURPLE, "You denied the action.");
			format(szMiscArray, sizeof(szMiscArray), " * Reason: %s.", inputtext);
			SendClientMessage(playerid, COLOR_YELLOW, szMiscArray);
			DeletePVar(iActionID, "actionstring");
			DeletePVar(playerid, "actionplayer");
		}
	}
	return 1;
}

hook OnPlayerConnect(playerid) {

	for(new i; i < MAX_CHATSETS; ++i) PlayerInfo[playerid][pToggledChats][i] = 0;
	for(new i; i < MAX_CHATSETS; ++i) PlayerInfo[playerid][pChatbox][i] = 0;
	DeletePVar(playerid, "actionplayer");
	DeletePVar(playerid, "actionstring");
	return 1;
}

/*
stock SendClientMessageEx(playerid, color, string[])
{
	if(InsideMainMenu{playerid} == 1 || InsideTut{playerid} == 1 || ActiveChatbox[playerid] == 0)
		return 0;

	else SendClientMessage(playerid, color, string);
	return 1;
}
*/

// Test with SendClientMessageEx
stock SendClientMessageEx(playerid, color, msg[], va_args<>)
{
        new string[128];
        if(InsideMainMenu{playerid} == 1 || InsideTut{playerid} == 1 || ActiveChatbox[playerid] == 0)
                return 0;
        else {
                va_format(string, sizeof(string), msg, va_start<3>);
                SendClientMessage(playerid, color, string);
        }
        return 1;
}
stock SendClientMessageToAllEx(color, string[])
{
	foreach(new i: Player)
	{
		if(InsideMainMenu{i} == 1 || InsideTut{i} == 1 || ActiveChatbox[i] == 0) {}
		else {

			SendClientMessage(i, color, string);
		}
	}	
	return 1;
}

/*
CMD:togchatbox2(playerid, params[]) {

	if(PlayerInfo[playerid][pToggledChats][19]) {
		
		for(new i; i < sizeof(TD_ChatBox); ++i) PlayerTextDrawShow(playerid, TD_ChatBox[i]);
		PlayerInfo[playerid][pToggledChats][19] = 0;
	}
	else {
		
		for(new i; i < sizeof(TD_ChatBox); ++i) PlayerTextDrawHide(playerid, TD_ChatBox[i]);
		PlayerInfo[playerid][pToggledChats][19] = 1;
	}
	return 1;
}
*/

stock SendClientMessageWrap(playerid, color, width, string[])
{
	if(strlen(string) > width)
	{
		new firstline[128], secondline[128];
		strmid(firstline, string, 0, 88);
		strmid(secondline, string, 88, 128);
		format(firstline, sizeof(firstline), "%s...", firstline);
		format(secondline, sizeof(secondline), "...%s", secondline);
		ChatTrafficProcess(playerid, color, firstline, 3);
		ChatTrafficProcess(playerid, color, secondline, 3);
	}
	else ChatTrafficProcess(playerid, color, string, 3);
}
	
stock ClearChatbox(playerid)
{
	for(new i = 0; i < 50; i++) {
		SendClientMessage(playerid, COLOR_WHITE, "");
	}
	return 1;
}

stock OOCOff(color,string[])
{
	foreach(new i: Player)
	{
		if(!gOoc[i]) {
			SendClientMessageEx(i, color, string);
		}
	}	
}

stock RadioBroadCast(playerid, string[])
{
	foreach(new i: Player)
	{
		if(PlayerInfo[i][pRadioFreq] == PlayerInfo[playerid][pRadioFreq] && PlayerInfo[i][pRadio] >= 1 && gRadio{i} != 0)
		{
			format(szMiscArray, sizeof(szMiscArray), "** Radio (%d kHz) ** %s: %s", PlayerInfo[playerid][pRadioFreq], GetPlayerNameEx(playerid), string);
			ChatTrafficProcess(i, PUBLICRADIO_COLOR, szMiscArray, 5);
			format(szMiscArray, sizeof(szMiscArray), "(radio) %s", string);
			SetPlayerChatBubble(playerid, szMiscArray, COLOR_WHITE, 15.0, 5000);
		}
	}	
}

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

CMD:me(playerid, params[])
{
	if(PlayerInfo[playerid][pJailTime] && strfind(PlayerInfo[playerid][pPrisonReason], "[OOC]", true) != -1) return SendClientMessageEx(playerid, COLOR_GREY, "OOC prisoners are restricted to only speak in /b");
	if(isnull(params)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /me [action]");
	new string[255];
	format(string, sizeof(string), "{FF8000}* {C2A2DA}%s %s", GetPlayerNameEx(playerid), params);
	if(PlayerInfo[playerid][pIsolated] != 0) ProxDetector(5.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
	else ProxDetector(30.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
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
	if(GetPVarType(playerid, "WatchingTV") && PlayerInfo[playerid][pAdmin] < 2)
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
		if(ProxDetectorS(5.0, playerid, giveplayerid) || PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[playerid][pWatchdog] == 2)
		{
		    foreach(new i: Player)
			{
				if(GetPVarInt(i, "BigEar") == 6 && (GetPVarInt(i, "BigEarPlayer") == playerid || GetPVarInt(i, "BigEarPlayer")  == giveplayerid))
				{
					format(string, sizeof(string), "(BE)%s(ID %d) whispers to %s(ID %d): %s", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(giveplayerid), giveplayerid, whisper);
					SendClientMessageWrap(i, COLOR_YELLOW, 92, string);
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
	if(PlayerInfo[playerid][pIsolated] != 0) ProxDetectorWrap(playerid, string, 92, 5.0, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
	else ProxDetectorWrap(playerid, string, 92, 30.0, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
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
	else if(PlayerInfo[playerid][pHelper] >= 1)
	{
		new string[128];
		format(string, sizeof(string), "(( Advisor %s: %s ))", GetPlayerNameEx(playerid), params);
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
	if(PlayerInfo[playerid][pIsolated] != 0) ProxDetector(5.0, playerid, string,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_FADE1,COLOR_FADE2, 1); // addition for prison system
	else ProxDetector(30.0, playerid, string,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_FADE1,COLOR_FADE2, 1);
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
	if(GetPVarType(playerid, "WatchingTV")) return SendClientMessage(playerid, COLOR_GRAD1, "You can't use this command while watching TV.");
	new string[128];
	format(string, sizeof(string), "%s: (( %s ))", GetPlayerNameEx(playerid), params);
	
	if(PlayerInfo[playerid][pIsolated] != 0) ProxDetector(5.0, playerid, string,COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5);
	else ProxDetector(20.0, playerid, string,COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5, 1, 2, 1);

	foreach(new i: Player)
	{
		if(PlayerInfo[i][pAdmin] > 1 && GetPVarInt(i, "BigEar") == 2)
		{
			new szAntiprivacy[128];
			format(szAntiprivacy, sizeof(szAntiprivacy), "(BE) %s: %s", GetPlayerNameEx(playerid), params);
			ChatTrafficProcess(i, COLOR_FADE1, szAntiprivacy, 2);
		}
	}	
	return 1;
}

CMD:accent(playerid, params[])
{
	new accent;
	if(sscanf(params, "d", accent))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /accent [accent ID]");
		SendClientMessageEx(playerid, COLOR_GRAD2, "Available Accents: Normal [1], British [2], Japanese [3], Asian [4], Scottish [6], Irish [7], Russian [8]");
		SendClientMessageEx(playerid, COLOR_GRAD2, "Available Accents: American [9], Spanish [10], Southern [11], Italian [13], Gangsta [14], Australian [15], Arabic [16]");
		SendClientMessageEx(playerid, COLOR_GRAD2, "Available Accents: Balkan [17], Canadian [18], Jamaican [19], Israeli [20], Dutch [21], Brazilian [22], German [23], Turkish [24]");
		SendClientMessageEx(playerid, COLOR_GRAD2, "Available Accents: Kiwi [25], French [26], Korean [27], Thai [28], Swedish [29], Danish [30], Norwegian [31]");
		return 1;
	}

	switch(accent)
	{
		case 1:
		{
			PlayerInfo[playerid][pAccent] = 1;
			SendClientMessageEx(playerid, COLOR_WHITE, "You will now speak in the Normal accent, use /accent to change it." );
		}
		case 2:
		{
			PlayerInfo[playerid][pAccent] = 2;
			SendClientMessageEx(playerid, COLOR_WHITE, "You will now speak in the British accent, use /accent to change it." );
		}
		case 3:
		{
			PlayerInfo[playerid][pAccent] = 3;
			SendClientMessageEx(playerid, COLOR_WHITE, "You will now speak in the Japanese accent, use /accent to change it." );
		}
		case 4:
		{
			PlayerInfo[playerid][pAccent] = 4;
			SendClientMessageEx(playerid, COLOR_WHITE, "You will now speak in the Chinese accent, use /accent to change it." );
		}
		case 5:
		{
			PlayerInfo[playerid][pAccent] = 5;
			SendClientMessageEx(playerid, COLOR_WHITE, "You will now speak in the Korean accent, use /accent to change it." );
		}
		case 6:
		{
			PlayerInfo[playerid][pAccent] = 6;
			SendClientMessageEx(playerid, COLOR_WHITE, "You will now speak in the Scottish accent, use /accent to change it." );
		}
		case 7:
		{
			PlayerInfo[playerid][pAccent] = 7;
			SendClientMessageEx(playerid, COLOR_WHITE, "You will now speak in the Irish accent, use /accent to change it." );
		}
		case 8:
		{
			PlayerInfo[playerid][pAccent] = 8;
			SendClientMessageEx(playerid, COLOR_WHITE, "You will now speak in the Russian accent, use /accent to change it." );
		}
		case 9:
		{
			PlayerInfo[playerid][pAccent] = 9;
			SendClientMessageEx(playerid, COLOR_WHITE, "You will now speak in the American accent, use /accent to change it." );
		}
		case 10:
		{
			PlayerInfo[playerid][pAccent] = 10;
			SendClientMessageEx(playerid, COLOR_WHITE, "You will now speak in the Spanish accent, use /accent to change it." );
		}
		case 11:
		{
			PlayerInfo[playerid][pAccent] = 11;
			SendClientMessageEx(playerid, COLOR_WHITE, "You will now speak in the Texan accent, use /accent to change it." );
		}
		case 12:
		{
			PlayerInfo[playerid][pAccent] = 12;
			SendClientMessageEx(playerid, COLOR_WHITE, "You will now speak in the Cuban accent, use /accent to change it." );
		}
		case 13:
		{
			PlayerInfo[playerid][pAccent] = 13;
			SendClientMessageEx(playerid, COLOR_WHITE, "You will now speak in the Italian accent, use /accent to change it." );
		}
		case 14:
		{
			PlayerInfo[playerid][pAccent] = 14;
			SendClientMessageEx(playerid, COLOR_WHITE, "You will now speak in the Gangsta accent, use /accent to change it." );
		}
		case 15:
		{
			PlayerInfo[playerid][pAccent] = 15;
			SendClientMessageEx(playerid, COLOR_WHITE, "You will now speak in the Australian accent, use /accent to change it." );
		}
		case 16:
		{
			PlayerInfo[playerid][pAccent] = 16;
			SendClientMessageEx(playerid, COLOR_WHITE, "You will now speak in the Arabic accent, use /accent to change it." );
		}
		case 17:
		{
			PlayerInfo[playerid][pAccent] = 17;
			SendClientMessageEx(playerid, COLOR_WHITE, "You will now speak in the Balkan accent, use /accent to change it." );
		}
		case 18:
		{
			PlayerInfo[playerid][pAccent] = 18;
			SendClientMessageEx(playerid, COLOR_WHITE, "You will now speak in the Canadian accent, use /accent to change it." );
		}
		case 19:
		{
			PlayerInfo[playerid][pAccent] = 19;
			SendClientMessageEx(playerid, COLOR_WHITE, "You will now speak in the Jamaican accent, use /accent to change it." );
		}
		case 20:
		{
			PlayerInfo[playerid][pAccent] = 20;
			SendClientMessageEx(playerid, COLOR_WHITE, "You will now speak in the Israeli accent, use /accent to change it." );
		}
		case 21:
	    {
	        PlayerInfo[playerid][pAccent] = 21;
			SendClientMessageEx(playerid, COLOR_WHITE, "You will now speak in the Dutch accent, use /accent to change it." );
	    }
		case 22:
	    {
	        PlayerInfo[playerid][pAccent] = 22;
			SendClientMessageEx(playerid, COLOR_WHITE, "You will now speak in the Brazilian accent, use /accent to change it." );
	    }
   		case 23:
	    {
	        PlayerInfo[playerid][pAccent] = 23;
			SendClientMessageEx(playerid, COLOR_WHITE, "You will now speak in the German accent, use /accent to change it." );
	    }
	    case 24:
	    {
	        PlayerInfo[playerid][pAccent] = 24;
			SendClientMessageEx(playerid, COLOR_WHITE, "You will now speak in the Turkish accent, use /accent to change it." );
	    } 
		case 25:
	    {
	        PlayerInfo[playerid][pAccent] = 25;
			SendClientMessageEx(playerid, COLOR_WHITE, "You will now speak in the Kiwi accent, use /accent to change it." );
	    }
		case 26:
	    {
	        PlayerInfo[playerid][pAccent] = 26;
			SendClientMessageEx(playerid, COLOR_WHITE, "You will now speak in the French accent, use /accent to change it." );
	    }
		case 27:
	    {
	        PlayerInfo[playerid][pAccent] = 27;
			SendClientMessageEx(playerid, COLOR_WHITE, "You will now speak in the Korean accent, use /accent to change it." );
	    }
		case 28:
	    {
	        PlayerInfo[playerid][pAccent] = 28;
			SendClientMessageEx(playerid, COLOR_WHITE, "You will now speak in the Thai accent, use /accent to change it." );
	    }
		case 29:
		{
			PlayerInfo[playerid][pAccent] = 29;
			SendClientMessageEx(playerid, COLOR_WHITE, "You will now speak in the Swedish accent, use /accent to change it." );
		}
		case 30:
		{
			PlayerInfo[playerid][pAccent] = 30;
			SendClientMessageEx(playerid, COLOR_WHITE, "You will now speak in the Danish accent, use /accent to change it." );
		}
		case 31:
		{
			PlayerInfo[playerid][pAccent] = 31;
			SendClientMessageEx(playerid, COLOR_WHITE, "You will now speak in the Norwegian accent, use /accent to change it." );
		}
	}
	return 1;
}

CMD:pr(playerid, params[])
{
	if(PlayerInfo[playerid][pJailTime] && strfind(PlayerInfo[playerid][pPrisonReason], "[OOC]", true) != -1) return SendClientMessageEx(playerid, COLOR_GREY, "OOC prisoners are restricted to only speak in /b");
	if(PlayerInfo[playerid][pRadio] == 1)
	{
		if(isnull(params))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /pr [chat]");
			SendClientMessageEx(playerid, COLOR_GRAD2, "HINT: Type /setfreq to set the frequency of your portable radio.");
			return 1;
		}
		if(PlayerInfo[playerid][pRadioFreq] >= 1 || PlayerInfo[playerid][pRadioFreq] <= -1)
		{
			if(PlayerTied[playerid] != 0 || PlayerCuffed[playerid] != 0 || PlayerCuffed[playerid] != 0 || PlayerInfo[playerid][pJailTime] > 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "You cannot do this at this time.");
			RadioBroadCast(playerid, params);
			return 1;
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GRAD2, "The frequency of your radio is set to 0, you can not broadcast over that frequency.");
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "You do not have a portable radio!");
	}
	return 1;
}

CMD:setfreq(playerid, params[])
{
	new string[128], frequency;
	if(sscanf(params, "d", frequency))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /setfreq [frequency]");
		SendClientMessageEx(playerid, COLOR_GRAD2, "HINT: Set the frequency of your radio to 0 if you don't want to hear anything.");
		return 1;
	}

	if(frequency > 9999999 || frequency < -9999999) { SendClientMessageEx(playerid, COLOR_GREY, "Frequency can not be lower than -9999999 or higher than 9999999!"); return 1; }
	if (PlayerInfo[playerid][pRadio] == 1)
	{
		PlayerInfo[playerid][pRadioFreq] = frequency;
		format(string, sizeof(string), "You have set the frequency of your portable radio to %d khz.",frequency);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "You do not have a portable radio!");
	}
	return 1;
}


ChatTrafficProcess(playerid, color, szString[], chattype) {

	if(PlayerInfo[playerid][pToggledChats][chattype] == 0) SendClientMessageEx(playerid, color, szString);
	return 1;
	/*
	if(PlayerInfo[playerid][pChatbox][chattype] > 0 && PlayerInfo[playerid][pToggledChats][19] == 0) { // if Secondary Chatbox is not active, route all chat to normal chatbox.

		if(chattype == 1) return SendClientMessageEx(playerid, color, szString); // temp bug fix for /news.
		if(chattype == 16) return SendClientMessageEx(playerid, color, szString); // temp bug fix for /staff.

		ChatBoxProcess(playerid, color, szString);
	}
	else SendClientMessageEx(playerid, color, szString);
	return 1;
	*/
}

ProxChatBubble(playerid, szString[]) {

	SetPlayerChatBubble(playerid, szString, COLOR_PURPLE, 15.0, 5000);
	//format(szString, 128, "{FF8000}> {C2A2DA}%s", szString);
	SendClientMessageEx(playerid, COLOR_PURPLE, szString);
}

/*
new MessageStr[MAX_PLAYERS][11][128],
	MessageColor[MAX_PLAYERS][11];

ChatBoxProcess(playerid, hColor, szText[]) {

	if(PlayerInfo[playerid][pToggledChats][19] == 1) return 1;

	new iSize = sizeof(TD_ChatBox) - 1;

	for(new line = 1; line < sizeof(TD_ChatBox); line++)
	{
    	PlayerTextDrawHide(playerid, TD_ChatBox[line]);
    	if(line < iSize)
		{
		    MessageStr[playerid][line] = MessageStr[playerid][line+1];
    		MessageColor[playerid][line] = MessageColor[playerid][line+1];
    		PlayerTextDrawSetString(playerid, TD_ChatBox[line], MessageStr[playerid][line]);
 		}
	}
	format(MessageStr[playerid][iSize], 128, "... %s", szText);
	PlayerTextDrawSetString(playerid, TD_ChatBox[9], MessageStr[playerid][iSize]);
	MessageColor[playerid][iSize] = hColor;
	for(new line = 1; line < sizeof(TD_ChatBox); line++)
	{
		PlayerTextDrawColor(playerid, TD_ChatBox[line], MessageColor[playerid][line]);
     	PlayerTextDrawShow(playerid, TD_ChatBox[line]);
	}
	return 1;
}
*/

/*
ChatBoxProcess(playerid, hColor, szText[]) {

	if(PlayerInfo[playerid][pToggledChats][19] == 1) return 1;

	new PVarID[5];

	for(new i = 10; i > 1; --i) {

		format(PVarID, sizeof(PVarID), "CB%d", i - 1);
		GetPVarString(playerid, PVarID, szMiscArray, sizeof(szMiscArray));
		ChatBoxColor[playerid][i] = ChatBoxColor[playerid][i - 1];
		if(!isnull(szMiscArray)) PlayerTextDrawColor(playerid, TD_ChatBox[i], ChatBoxColor[playerid][i]);
		PlayerTextDrawSetString(playerid, TD_ChatBox[i], szMiscArray);
		PlayerTextDrawShow(playerid, TD_ChatBox[i]);

		format(PVarID, sizeof(PVarID), "CB%d", i);
		SetPVarString(playerid, PVarID, szMiscArray);

	}
	SetPVarString(playerid, "CB1", szText);
	ChatBoxColor[playerid][1] = hColor;
	PlayerTextDrawColor(playerid, TD_ChatBox[1], hColor);
	PlayerTextDrawSetString(playerid, TD_ChatBox[1], szText);
	PlayerTextDrawShow(playerid, TD_ChatBox[1]);
	return 1;
}
*/

CMD:ame(playerid, params[])
{
	if(PlayerInfo[playerid][pJailTime] && strfind(PlayerInfo[playerid][pPrisonReason], "[OOC]", true) != -1) return SendClientMessageEx(playerid, COLOR_GREY, "OOC prisoners are restricted to only speak in /b");
	if(isnull(params)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /ame [action]");
	new string[128];
	format(string, sizeof(string), "%s %s", GetPlayerNameEx(playerid), params);
	SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 15.0, 5000);
	format(string, sizeof(string), "{FF8000}> {C2A2DA}%s", params);
	SendClientMessageEx(playerid, COLOR_PURPLE, string);
	return 1;
}

CMD:lme(playerid, params[])
{
	if(PlayerInfo[playerid][pJailTime] && strfind(PlayerInfo[playerid][pPrisonReason], "[OOC]", true) != -1) return SendClientMessageEx(playerid, COLOR_GREY, "OOC prisoners are restricted to only speak in /b");
	if(isnull(params)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /lme [action]");
	new string[128];
	format(string, sizeof(string), "{FF8000}* {C2A2DA}%s %s", GetPlayerNameEx(playerid), params);
	ProxDetectorWrap(playerid, string, 92, 15, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
	return 1;
}

CMD:ldo(playerid, params[])
{
	if(PlayerInfo[playerid][pJailTime] && strfind(PlayerInfo[playerid][pPrisonReason], "[OOC]", true) != -1) return SendClientMessageEx(playerid, COLOR_GREY, "OOC prisoners are restricted to only speak in /b");
	if(isnull(params)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /ldo [action]");
	else if(strlen(params) > 120) return SendClientMessageEx(playerid, COLOR_GREY, "The specified message must not be longer than 120 characters in length.");
	new
		iCount,
		iPos,
		iChar;
	while((iChar = params[iPos++])) if(iChar == '@') iCount++;
	if(iCount >= 5) return SendClientMessageEx(playerid, COLOR_GREY, "The specified message must not contain more than 4 '@' symbols.");

	new string[150];
	format(string, sizeof(string), "* %s (( %s ))", params, GetPlayerNameEx(playerid));
	ProxDetectorWrap(playerid, string, 92, 15.0, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
	return 1;
}

CMD:resetexamine(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1) return 1;
	new target;
	if(sscanf(params, "u", target)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /resetexamine [playerid]");
	if(!IsPlayerConnected(target)) return SendClientMessageEx(playerid, COLOR_GREY, "Error: Player is not connected!");
	format(PlayerInfo[target][pExamineDesc], 256, "None");
	return SendClientMessageEx(playerid, COLOR_GREY, "You have successfully reset their examine description.");
}

CMD:se(playerid, params[]) return cmd_setexamine(playerid, params);
CMD:setexamine(playerid, params[]) return ShowPlayerDialogEx(playerid, DIALOG_SETEXAMINE, DIALOG_STYLE_INPUT, "Examine Description", "Please enter a description of yourself.\nExample: appears to be a white male, 6' 3 ..etc", "Set", "Cancel");

CMD:examine(playerid, params[])
{
	new target;
	if(sscanf(params, "u", target)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /examine [playerid]");
	if(!IsPlayerConnected(target)) return SendClientMessageEx(playerid, COLOR_GREY, "Error: Player is not connected!");
	if(!ProxDetectorS(5.0, playerid, target) && PlayerInfo[playerid][pAdmin] < 2) return SendClientMessageEx(playerid, COLOR_GREY, "That person isn't near you.");
	if(!strlen(PlayerInfo[target][pExamineDesc]) || !strcmp(PlayerInfo[target][pExamineDesc], "None", true)) return SendClientMessageEx(playerid, COLOR_GREY, "That person doesn't have a description set.");
	if(strlen(PlayerInfo[target][pExamineDesc]) > 101)
	{
		new firstline[128], secondline[128];
		strmid(firstline, PlayerInfo[target][pExamineDesc], 0, 101);
		strmid(secondline, PlayerInfo[target][pExamineDesc], 101, 128);
		format(firstline, sizeof(firstline), "* %s %s", GetPlayerNameEx(target), firstline);
		format(secondline, sizeof(secondline), "...%s", secondline);
		SendClientMessageEx(playerid, COLOR_PURPLE, firstline);
		SendClientMessageEx(playerid, COLOR_PURPLE, secondline);
	}
	else
	{
		new string[128];
		format(string, sizeof(string), "* %s %s", GetPlayerNameEx(target), PlayerInfo[target][pExamineDesc]);
		SendClientMessageEx(playerid, COLOR_PURPLE, string);
	}
	return 1;
}