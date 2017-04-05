/*
    	 		 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
				| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
				| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
				| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
				| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
				| $$\  $$$| $$  \ $$        | $$  \ $$| $$
				| $$ \  $$|  $$$$$$/        | $$  | $$| $$
				|__/  \__/ \______/         |__/  |__/|__/

//--------------------------------[IRC.PWN]--------------------------------


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
 
 //--------------------------------[ INITIATE/EXIT ]---------------------------

stock g_irc_Init()
{
	new fileString[128], File: fileHandle = fopen("irc.cfg", io_read);

	while(fread(fileHandle, fileString, sizeof(fileString))) {
		if(ini_GetValue(fileString, "SERVER", IRC_SERVER, sizeof(IRC_SERVER))) continue;
		if(ini_GetInt(fileString, "PORT", IRC_PORT)) continue;
		if(ini_GetInt(fileString, "SSL", IRC_SSL)) continue;
		if(ini_GetValue(fileString, "BOT_USERNAME", IRC_BOT_USERNAME, sizeof(IRC_BOT_USERNAME))) continue;
		if(ini_GetValue(fileString, "BOT_PASSWORD", IRC_BOT_PASSWORD, sizeof(IRC_BOT_PASSWORD))) continue;
		if(ini_GetValue(fileString, "BOT_MAIN_NICK", IRC_BOT_MAIN_NICK, sizeof(IRC_BOT_MAIN_NICK))) continue;
		if(ini_GetValue(fileString, "BOT_ALT_NICK", IRC_BOT_ALT_NICK, sizeof(IRC_BOT_ALT_NICK))) continue;
		if(ini_GetValue(fileString, "BOT_REALNAME", IRC_BOT_REALNAME, sizeof(IRC_BOT_REALNAME))) continue;
		if(ini_GetValue(fileString, "CHANNEL_ADMIN", IRC_CHANNEL_ADMIN, sizeof(IRC_CHANNEL_ADMIN))) continue;
		if(ini_GetValue(fileString, "CHANNEL_HEADADMIN", IRC_CHANNEL_HEADADMIN, sizeof(IRC_CHANNEL_HEADADMIN))) continue;
		if(ini_GetValue(fileString, "CHANNEL_ADMWARNINGS", IRC_CHANNEL_ADMWARNINGS, sizeof(IRC_CHANNEL_ADMWARNINGS))) continue;
		if(ini_GetValue(fileString, "CHANNEL_SERVERERRORS", IRC_CHANNEL_SERVERERRORS, sizeof(IRC_CHANNEL_SERVERERRORS))) continue;
	}
	fclose(fileHandle);
	print("[IRC] Starting Slack integration services...");
	BotID[0] = IRC_Connect(IRC_SERVER, IRC_PORT, IRC_BOT_MAIN_NICK, IRC_BOT_REALNAME, IRC_BOT_USERNAME, IRC_SSL, "", IRC_BOT_PASSWORD);
	return 1;
}

stock g_irc_Exit()
{
	print("[IRC] Stopping Slack integration services...");
	IRC_Quit(BotID[0], "IRC Bot disconnecting...");
	IRC_DestroyGroup(BotGroupID);
	return 1;
}

hook OnGameModeInit()
{
	g_irc_Init();
	return 1;
}

hook OnGameModeExit()
{
	g_irc_Exit();
	return 1;
}

public IRC_OnConnect(botid, ip[], port)
{
	printf("[IRC] OnConnect: Bot ID %d connected to %s:%d", botid, ip, port);
	ABroadCast(COLOR_GREEN, "Slack integration has started!", 99999);
	IRC_JoinChannel(botid, IRC_CHANNEL_ADMIN);
	IRC_JoinChannel(botid, IRC_CHANNEL_HEADADMIN);
	IRC_JoinChannel(botid, IRC_CHANNEL_SERVERERRORS);
	IRC_JoinChannel(botid, IRC_CHANNEL_ADMWARNINGS);
	IRC_AddToGroup(BotGroupID, botid);
	if(botid == BotID[0]) IRC_SetChannelTopic(botid, IRC_CHANNEL_ADMIN, AdminMOTD);
	return 1;
}

public IRC_OnDisconnect(botid, ip[], port, reason[])
{
	printf("[IRC] OnDisconnect: Bot ID %d disconnected from %s:%d (%s)", botid, ip, port, reason);
	ABroadCast(COLOR_TWRED, "Slack integration has stopped!", 99999);
	// Remove the bot from the group
	IRC_RemoveFromGroup(BotGroupID, botid);
	return 1;
}

public IRC_OnConnectAttempt(botid, ip[], port)
{
	printf("[IRC] OnConnectAttempt: Bot ID %d attempting to connect to %s:%d...", botid, ip, port);
	return 1;
}

public IRC_OnConnectAttemptFail(botid, ip[], port, reason[])
{
	printf("[IRC] OnConnectAttemptFail: Bot ID %d failed to connect to %s:%d (%s)", botid, ip, port, reason);
	return 1;
}

public IRC_OnJoinChannel(botid, channel[])
{
	printf("[IRC] OnJoinChannel: Bot ID %d joined channel %s", botid, channel);
	return 1;
}

public IRC_OnLeaveChannel(botid, channel[], message[])
{
	printf("[IRC] OnLeaveChannel: Bot ID %d left channel %s (%s)", botid, channel, message);
	return 1;
}

public IRC_OnInvitedToChannel(botid, channel[], invitinguser[], invitinghost[])
{
	printf("[IRC] OnInvitedToChannel: Bot ID %d invited to channel %s by %s (%s)", botid, channel, invitinguser, invitinghost);
	IRC_JoinChannel(botid, channel);
	return 1;
}

public IRC_OnKickedFromChannel(botid, channel[], oppeduser[], oppedhost[], message[])
{
	printf("[IRC] OnKickedFromChannel: Bot ID %d kicked by %s (%s) from channel %s (%s)", botid, oppeduser, oppedhost, channel, message);
	IRC_JoinChannel(botid, channel);
	return 1;
}

public IRC_OnUserDisconnect(botid, user[], host[], message[])
{
	printf("[IRC] OnUserDisconnect (Bot ID %d): User %s (%s) disconnected (%s)", botid, user, host, message);
	return 1;
}

public IRC_OnUserJoinChannel(botid, channel[], user[], host[])
{
	printf("[IRC] OnUserJoinChannel (Bot ID %d): User %s (%s) joined channel %s", botid, user, host, channel);
	return 1;
}

public IRC_OnUserLeaveChannel(botid, channel[], user[], host[], message[])
{
	printf("[IRC] OnUserLeaveChannel (Bot ID %d): User %s (%s) left channel %s (%s)", botid, user, host, channel, message);
	return 1;
}

public IRC_OnUserKickedFromChannel(botid, channel[], kickeduser[], oppeduser[], oppedhost[], message[])
{
	printf("[IRC] OnUserKickedFromChannel (Bot ID %d): User %s kicked by %s (%s) from channel %s (%s)", botid, kickeduser, oppeduser, oppedhost, channel, message);
}

public IRC_OnUserNickChange(botid, oldnick[], newnick[], host[])
{
	printf("[IRC] OnUserNickChange (Bot ID %d): User %s (%s) changed his/her nick to %s", botid, oldnick, host, newnick);
	return 1;
}

public IRC_OnUserSetChannelMode(botid, channel[], user[], host[], mode[])
{
	printf("[IRC] OnUserSetChannelMode (Bot ID %d): User %s (%s) on %s set mode: %s", botid, user, host, channel, mode);
	return 1;
}

public IRC_OnUserSetChannelTopic(botid, channel[], user[], host[], topic[])
{
	printf("[IRC] OnUserSetChannelTopic (Bot ID %d): User %s (%s) on %s set topic: %s", botid, user, host, channel, topic);
	return 1;
}

public IRC_OnUserSay(botid, recipient[], user[], host[], message[])
{
	new szMessage[128];
	printf("[IRC] OnUserSay (Bot ID %d): User %s (%s) sent message to %s: %s", botid, user, host, recipient, message);
	// Someone sent the bot a private message
	if(!strcmp(recipient, IRC_BOT_MAIN_NICK))
	{
		IRC_Say(botid, user, "You sent me a PM!");
	}
	else if(!strcmp(recipient, IRC_CHANNEL_ADMIN, true) && strcmp(user, "samp", true))
	{
		user[0] = toupper(user[0]);
		format(szMessage, sizeof(szMessage), "* [Slack] Administrator %s: %s", user, message);
		ABroadCast(COLOR_YELLOW, szMessage, 2, true, true);
	}
	else if(!strcmp(recipient, IRC_CHANNEL_HEADADMIN, true) && strcmp(user, "samp", true))
	{
		user[0] = toupper(user[0]);
		format(szMessage, sizeof(szMessage), "(PRIVATE) [Slack] Administrator %s: %s", user, message);
		ABroadCast(COLOR_GREEN, szMessage, 1337, true, true);
	}
	return 1;
}

public IRC_OnUserNotice(botid, recipient[], user[], host[], message[])
{
	printf("[IRC] OnUserNotice (Bot ID %d): User %s (%s) sent notice to %s: %s", botid, user, host, recipient, message);
	// Someone sent the bot a notice (probably a network service)
	if (!strcmp(recipient, IRC_BOT_MAIN_NICK))
	{
		IRC_Notice(botid, user, "You sent me a notice!");
	}
	return 1;
}

public IRC_OnUserRequestCTCP(botid, user[], host[], message[])
{
	printf("[IRC] OnUserRequestCTCP (Bot ID %d): User %s (%s) sent CTCP request: %s", botid, user, host, message);
	// Someone sent a CTCP VERSION request
	if (!strcmp(message, "VERSION"))
	{
		IRC_ReplyCTCP(botid, user, "VERSION SA-MP IRC Plugin v" #PLUGIN_VERSION "");
	}
	return 1;
}

public IRC_OnUserReplyCTCP(botid, user[], host[], message[])
{
	printf("[IRC] OnUserReplyCTCP (Bot ID %d): User %s (%s) sent CTCP reply: %s", botid, user, host, message);
	return 1;
}

public IRC_OnReceiveNumeric(botid, numeric, message[])
{
	// Check if the numeric is an error defined by RFC 1459/2812
	if (numeric >= 400 && numeric <= 599)
	{
		const ERR_NICKNAMEINUSE = 433;
		if (numeric == ERR_NICKNAMEINUSE)
		{
			// Check if the nickname is already in use
			if (botid == BotID[0])
			{
				IRC_ChangeNick(botid, IRC_BOT_ALT_NICK);
			}
		}
		printf("[IRC] OnReceiveNumeric (Bot ID %d): %d (%s)", botid, numeric, message);
	}
	return 1;
}

public IRC_OnReceiveRaw(botid, message[])
{
	new File:file;
	if (!fexist("irc_log.txt"))
	{
		file = fopen("irc_log.txt", io_write);
	}
	else
	{
		file = fopen("irc_log.txt", io_append);
	}
	if (file)
	{
		fwrite(file, message);
		fwrite(file, "\r\n");
		fclose(file);
	}
	return 1;
}

CMD:slack(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] == 99999)
	{
		new opt[8];

		if(sscanf(params, "s[8]", opt))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /slack [start/stop/restart]");
			return 1;
		}

		if(strcmp(opt, "start", true) == 0)
		{
			SendClientMessageEx(playerid, COLOR_GREEN, "Starting Slack integration services...");
			g_irc_Init();
		}
		else if(strcmp(opt, "stop", true) == 0)
		{
			SendClientMessageEx(playerid, COLOR_TWRED, "Stopping Slack integration services...");
		    g_irc_Exit();
		}
		else if(strcmp(opt, "restart", true) == 0)
		{
		    SendClientMessageEx(playerid, COLOR_TWRED, "Stopping Slack integration services...");
		    g_irc_Exit();
			SetTimerEx("IRC_Restart", 5000, false, "i", playerid);
		}
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use that command.");
	return 1;
}

forward IRC_Restart(playerid);
public IRC_Restart(playerid)
{
	SendClientMessageEx(playerid, COLOR_GREEN, "Starting Slack integration services...");
	g_irc_Init();
	return 1;
}