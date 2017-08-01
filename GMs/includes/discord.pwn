/*
    	 		 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
				| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
				| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
				| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
				| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
				| $$\  $$$| $$  \ $$        | $$  \ $$| $$
				| $$ \  $$|  $$$$$$/        | $$  | $$| $$
				|__/  \__/ \______/         |__/  |__/|__/

//--------------------------------[DISCORD.PWN]--------------------------------


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

hook OnGameModeInit()
{
	DCC_Connect("MjUxODAwMTY4OTM5MjU3ODU2.C8Lhhg.PMIaZpEXgUE48jH9oDwLHYK_f7Y");
	print("[DCC] Connecting to Discord...");
	return 1;
}

stock SendDiscordMessage(channel, message[])
{
	if(betaserver == 0) {
		switch(channel)
		{
			// #admin
			case 0:
			{
				g_AdminChannelId = DCC_FindChannelById("251802213913985024");
				DCC_SendChannelMessage(g_AdminChannelId, message);
			}
			// #admin-warnings
			case 1:
			{
				g_AdminWarningsChannelId = DCC_FindChannelById("252214716544450560");
				DCC_SendChannelMessage(g_AdminWarningsChannelId, message);
			}
			// #headadmin
			case 2:
			{
				g_HeadAdminChannelId = DCC_FindChannelById("251802276677681162");
				DCC_SendChannelMessage(g_HeadAdminChannelId, message);
			}
			// #server-errors
			case 3:
			{
				g_ServerErrorsChannelId = DCC_FindChannelById("252214813818617866");
				DCC_SendChannelMessage(g_ServerErrorsChannelId, message);
			}
		}
	} else {
		switch(channel)
		{
			// #server-errors
			case 3:
			{
				g_ServerErrorsChannelId = DCC_FindChannelById("252214813818617866");
				DCC_SendChannelMessage(g_ServerErrorsChannelId, message);
			}
			default: {}
		}
	}
	return 1;
}

public DCC_OnChannelMessage(DCC_Channel:channel, const author[], const message[])
{
	if(betaserver == 0) {
		new channel_name[32], szMessage[128];
		DCC_GetChannelName(channel, channel_name);
		printf("[DCC] OnChannelMessage (Channel %s): Author %s sent message: %s", channel_name, author, message);
		if(!strcmp(channel_name, "admin", true) && strcmp(author, "SAMP-Bot", true))
		{
			format(szMessage, sizeof(szMessage), "* [Discord] Administrator %s: %s", author, message);
			ABroadCast(COLOR_YELLOW, szMessage, 2, true, true);
		}
		else if(!strcmp(channel_name, "headadmin", true) && strcmp(author, "SAMP-Bot", true))
		{
			format(szMessage, sizeof(szMessage), "(PRIVATE) [Discord] Administrator %s: %s", author, message);
			ABroadCast(COLOR_GREEN, szMessage, 1337, true, true);
		}
	}
	return 1;
}