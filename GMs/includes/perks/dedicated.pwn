/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Dedicated System

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

/** Austin's Dedicated Player System **/

CMD:dp(playerid, params[]) 
{
	if(PlayerInfo[playerid][pAdmin] < 4 && !PlayerInfo[playerid][pDedicatedPlayer]) return SendClientMessageEx(playerid, COLOR_GRAD2, "You are not a Dedicated player.");
	if(PlayerInfo[playerid][pDedicatedEnabled] != 1) return SendClientMessageEx(playerid, COLOR_GRAD2, "You must enable Dedicated chat before using it. (/togdp)");
	if(PlayerInfo[playerid][pDedicatedMuted] != 0 || PlayerInfo[playerid][pDedicatedWarn] != 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "You are currently muted from the Dedicated chat.");
	if(GetPVarInt(playerid, "LastDPChat") > gettime()) return SendClientMessageEx(playerid, COLOR_GRAD2, "You must wait 5 seconds between messages.");
	new szMessage[128];
	if(sscanf(params, "s[128", szMessage)) return SendClientMessageEx(playerid, COLOR_GRAD2, "USAGE: /dp [message]");
	format(szMessage, sizeof(szMessage), "%s %s: %s", GetDPRankName(playerid), GetPlayerNameEx(playerid), szMessage);
	SendDedicatedMessage(0x2FC660FF, szMessage);
	SetPVarInt(playerid, "LastDPChat", gettime()+5);
	return 1;
}

CMD:togdp(playerid, params[])
{
	if(PlayerInfo[playerid][pDedicatedPlayer] > 0 || PlayerInfo[playerid][pAdmin] >= 4)
	{
		if(PlayerInfo[playerid][pDedicatedEnabled] == 0) 
		{
			PlayerInfo[playerid][pDedicatedEnabled] = 1;
			SendClientMessageEx(playerid, COLOR_WHITE, "You have enabled the Dedicated chat.");
		}
		else 
		{
			PlayerInfo[playerid][pDedicatedEnabled] = 0;
			SendClientMessageEx(playerid, COLOR_WHITE, "You have disabled Dedicated chat and will no longer recieve messages.");
		}
	}
	else 
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "You are not a Dedicated player.");
	}
	return 1;
}

CMD:dpplate(playerid, params[])
{
	if(PlayerInfo[playerid][pDedicatedPlayer] < 1)
		return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not a Dedicated player!");
		
	new string[128], Float: vHealth, inpveh;
	if(IsPlayerConnected(playerid))
	{
	    if(isnull(params))
	        return SendClientMessageEx(playerid, COLOR_GREY, "Usage: /dpplate [dp/superdp/remove]");

		inpveh = false;
	    for(new d = 0 ; d < MAX_PLAYERVEHICLES; d++)
	    {
     		if(IsPlayerInVehicle(playerid, PlayerVehicleInfo[playerid][d][pvId]))
       		{
				GetVehicleHealth(PlayerVehicleInfo[playerid][d][pvId], vHealth);
				inpveh = 1;
	                
    			if(vHealth < 800)
       				return SendClientMessageEx(playerid, COLOR_LIGHTRED, "Please repair your vehicle before replacing your plate.");
       				
    			if(strcmp(params, "dp", true) == 0)
    			{
    			    format(string, sizeof(string), "{2FC660}DEDICATED");
   			    	format(PlayerVehicleInfo[playerid][d][pvPlate], 32, "%s", string);
    			    SendClientMessageEx(playerid, COLOR_WHITE, "Your vehicle will now appear with the Dedicated Player Plate, parking your vehicle momentarily...");
					cmd_park(playerid, ""); 
	            }
	            else if(strcmp(params, "superdp", true) == 0)
	            {
	                if(PlayerInfo[playerid][pDedicatedPlayer] < 2) return SendClientMessageEx(playerid, COLOR_GRAD2, "You're not a high enough Dedicated player for this plate.");
                    format(string, sizeof(string), "{2FC660}SUPERDP");
					format(PlayerVehicleInfo[playerid][d][pvPlate], 32, "%s", string);
    			    SendClientMessageEx(playerid, COLOR_WHITE, "Your vehicle will now appear with the Super Dedicated Player Plate.");
					cmd_park(playerid, ""); 
	            }
	            else if(strcmp(params, "remove", true) == 0)
	            {
					PlayerVehicleInfo[playerid][d][pvPlate] = 0;
    			    SendClientMessageEx(playerid, COLOR_WHITE, "Your vehicle will now appear with the default plate.");
					cmd_park(playerid, "");
	            }
	            else
	            {
	                SendClientMessageEx(playerid, COLOR_GREY, "Usage: /dpplate [dp/superdp/remove]");
	            }
			}
		}
		
		if(inpveh == 0) SendClientMessageEx(playerid, COLOR_GRAD2, "You're not inside a vehicle that you own!");
	}
	return 1;
}

CMD:dpwarn(playerid, params[])
{
	new giveplayerid, reason[24], string[164];
	if(PlayerInfo[playerid][pDedicatedPlayer] >= 3 || PlayerInfo[playerid][pAdmin] >= 4) 
	{
		if(!sscanf(params, "us[24]", giveplayerid, reason))
		{
			if(!IsPlayerConnected(giveplayerid))
				return SendClientMessageEx(playerid, COLOR_GREY, "That person is not connected.");
			if(PlayerInfo[giveplayerid][pDedicatedMuted] != 0) 
				return SendClientMessageEx(playerid, COLOR_GREY, "That person is muted from the chat.");
			if(PlayerInfo[giveplayerid][pDedicatedWarn] > 0)
				return SendClientMessageEx(playerid, COLOR_GREY, "That person is already serving a warning.");
			
			format(string, sizeof(string), "AdmCmd: %s has temporarily muted %s from Dedicated chat, reason: %s", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), reason);
			ABroadCast(COLOR_LIGHTRED, string, 4);
			SendDedicatedMessage(COLOR_LIGHTRED, string);
			Log("logs/dedicated.log", string);

			format(string, sizeof(string), "You have been warned from the Dedicated chat by %s, reason: %s", GetPlayerNameEx(playerid), reason);
			SendClientMessageEx(giveplayerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_WHITE, "This action lasts for two hours. To appeal, please visit our forums: www.ng-gaming.net/forums");

			PlayerInfo[giveplayerid][pDedicatedWarn] = 120;
		}	
		else
		{
			SendClientMessageEx(playerid, COLOR_GRAD1, "Usage: /dpwarn [playerid] [reason]");
		}
	}	
	else 
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use this command.");
	}
	return 1;
}

CMD:setdedicated(playerid, params[])
{
    if(PlayerInfo[playerid][pDedicatedPlayer] >= 4 || PlayerInfo[playerid][pAdmin] >= 1337)
    {
        new string[128], targetid, level;
	    if(sscanf(params, "ui", targetid, level)) 
	    {
			SendClientMessageEx(playerid, COLOR_GRAD1, "Usage: /setdedicated [player] [level]");
			SendClientMessageEx(playerid, COLOR_GRAD2, "(1) Dedicated - (2) Super Dedicated - (3) DP Mod - (4) DP Associate");
			return 1;
		}

		if(IsPlayerConnected(targetid))
		{
		    if(targetid != INVALID_PLAYER_ID)
		    {
			    if(PlayerInfo[targetid][pDedicatedPlayer] > PlayerInfo[playerid][pDedicatedPlayer])
			        return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot use this command on this person!");

				PlayerInfo[targetid][pDedicatedPlayer] = level;
				format(string, sizeof(string), "AdmCmd: %s has set %s Dedicated level to %d.", GetPlayerNameEx(playerid), GetPlayerNameEx(targetid), level);
				ABroadCast(COLOR_LIGHTRED, string, 4);
				SendDedicatedMessage(COLOR_LIGHTRED, string);
				Log("logs/dedicated.log", string);
			}
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid player specified.");
		} 
	}
	else 
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You're not authorized to use this command!");
	}
	return 1;
}

CMD:osetdedicated(playerid, params[])
{
    if(PlayerInfo[playerid][pDedicatedPlayer] >= 4 || PlayerInfo[playerid][pAdmin] >= 4)
    {
        new string[128], pname[MAX_PLAYER_NAME], level;
	    if(sscanf(params, "s[32]i", pname, level))
			return SendClientMessageEx(playerid, COLOR_WHITE, "Usage: /osetdedicated [player] [level]");

        new targetid = ReturnUser(pname);
		if(IsPlayerConnected(targetid))
		{
		    SendClientMessageEx(playerid, COLOR_WHITE, "This player is connected, please use /setdedicated.");
		}
		else 
		{
		    new
				szQuery[128],
				szPlayerName[MAX_PLAYER_NAME];

			mysql_escape_string(pname, szPlayerName);		
			SetPVarInt(playerid, "Offline_Dedicated", level);
			SetPVarString(playerid, "Offline_DName", szPlayerName);
			
            format(szQuery, sizeof(szQuery), "SELECT `pDedicatedPlayer` FROM `accounts` WHERE `Username` = '%s'", szPlayerName);
 			mysql_function_query(MainPipeline, szQuery, true, "OnQueryFinish", "iii", OFFLINE_DEDICATED_THREAD, playerid, g_arrQueryHandle{playerid});
 			
 			format(string, sizeof(string), "Attempting to offline set %s account to level %d Dedicated.", szPlayerName, level);
 			SendClientMessageEx(playerid, COLOR_WHITE, string);
 		}
 	}
 	else 
 	{
 		SendClientMessageEx(playerid, COLOR_GRAD1, "You're not authorized to use this command!");
 	}
 	return 1;
}

CMD:dpmute(playerid, params[])
{
	if(PlayerInfo[playerid][pDedicatedPlayer] >= 3 || PlayerInfo[playerid][pAdmin] >= 4)
	{
	    new string[128], targetid, reason[64];
	    if(sscanf(params, "us[64]", targetid, reason))
			return SendClientMessageEx(playerid, COLOR_GRAD1, "Usage: /dpmute [player] [reason]");

		if(IsPlayerConnected(targetid))
		{
		    if(PlayerInfo[targetid][pDedicatedMuted] == 0)
		    {
		        if(targetid != INVALID_PLAYER_ID)
		        {
			        if(PlayerInfo[targetid][pDedicatedPlayer] > PlayerInfo[playerid][pDedicatedPlayer] && PlayerInfo[playerid][pAdmin] <= 0 || PlayerInfo[targetid][pAdmin] > PlayerInfo[playerid][pAdmin])
		 				return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot use this command on this person!");

					PlayerInfo[targetid][pDedicatedMuted] = 1;
					format(string, sizeof(string), "You were muted from the Dedicated chat by %s, reason: %s. You may appeal this mute at www.ng-gaming.net/forums", GetPlayerNameEx(playerid), reason);
					SendClientMessageEx(targetid, COLOR_GRAD2, string);
					format(string, sizeof(string), "AdmCmd: %s has muted %s from the Dedicated chat, reason: %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(targetid), reason);
					ABroadCast(COLOR_LIGHTRED, string, 4);
					SendClientMessageEx(playerid, COLOR_LIGHTRED, string);
					Log("logs/dedicated.log", string);
				}
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GRAD1, "This person is already muted from the Dedicated chat!");
			}
		}
		else 
		{
			SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid player specified.");
		}
	}
	else 
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You're not authorized to use this command!");
	}
	return 1;
}

CMD:dpunmute(playerid, params[])
{
	if(PlayerInfo[playerid][pDedicatedPlayer] >= 3 || PlayerInfo[playerid][pAdmin] >= 4)
	{
	    new string[128], targetid, reason[64];
	    if(sscanf(params, "us[64]", targetid, reason))
			return SendClientMessageEx(playerid, COLOR_GRAD1, "Usage: /dpunmute [player] [reason]");

		if(IsPlayerConnected(targetid))
		{
		    if(PlayerInfo[targetid][pDedicatedMuted] == 1)
		    {
		        if(targetid != INVALID_PLAYER_ID)
		        {
			        //if(PlayerInfo[targetid][pDedicatedPlayer] > PlayerInfo[playerid][pDedicatedPlayer] || PlayerInfo[targetid][pAdmin] > PlayerInfo[playerid][pAdmin])
		 			//	return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot use this command on this person!");

					PlayerInfo[targetid][pDedicatedMuted] = 0;
					format(string, sizeof(string), "You were unmuted from the Dedicated chat by %s, reason: %s.", GetPlayerNameEx(playerid), reason);
					SendClientMessageEx(targetid, COLOR_GRAD2, string);
					format(string, sizeof(string), "AdmCmd: %s has unmuted %s from the Dedicated chat, reason: %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(targetid), reason);
					ABroadCast(COLOR_LIGHTRED, string, 4);
					SendClientMessageEx(playerid, COLOR_LIGHTRED, string);
					Log("logs/dedicated.log", string);
				}
			}
			else 
			{  
				SendClientMessageEx(playerid, COLOR_GRAD1, "This person is not muted from the Dedicated chat!");
			}
		}
		else 
		{ 
			SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid player specified.");
		}
	}
	else 
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You're not authorized to use this command!");
	}
	return 1;
}

CMD:dedicatedplayers(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pDedicatedPlayer] >= 4)
	{
		new string[1024];
		foreach(new i : Player)
		{
			if(PlayerInfo[i][pDedicatedPlayer] >= 1)
			{
				format(string, sizeof(string), "%s\nLevel %d Dedicated %s", string, PlayerInfo[i][pDedicatedPlayer], GetPlayerNameEx(i));
			}
		}
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_LIST, "Online Dedicated Players", string, "Close", "");
	}
	else
	{
		 SendClientMessageEx(playerid, COLOR_GRAD1, "You're not authorized to use this command!");
	}
	return 1;
}

CMD:dpdraw(playerid, params[]) 
{
    if(PlayerInfo[playerid][pDedicatedPlayer] >= 4 || PlayerInfo[playerid][pAdmin] >= 1338) 
    {

		new
			arr_Winners[MAX_PLAYERS],
			iWinCount,
			iBroadcast;

		if(sscanf(params, "d", iBroadcast)) 
		{
			SendClientMessageEx(playerid, COLOR_GRAD1, "Usage: /dpdraw [broadcast(0-1)]");
			return 1;
		}

		foreach(new i: Player)
		{
			if(PlayerInfo[i][pDedicatedPlayer] > 0) arr_Winners[iWinCount++] = i;
		}

		if(iWinCount > 0) 
		{

			new
				iWinrar = arr_Winners[random(iWinCount)],
				szMessage[128];

			if(iBroadcast == 1) 
			{
				format(szMessage, sizeof(szMessage), "%s was just randomly selected! Congratulations! (Dedicated Player Draw)", GetPlayerNameEx(iWinrar));
				SendDedicatedMessage(COLOR_WHITE, szMessage);
			}
			else 
			{
				format(szMessage, sizeof(szMessage), "%s (ID %d) was randomly selected (/dpdraw).", GetPlayerNameEx(iWinrar), iWinrar);
				SendClientMessageEx(playerid, COLOR_YELLOW, szMessage);
				ABroadCast(COLOR_YELLOW, szMessage, 1338);
			}
			format(szMessage, sizeof(szMessage), "%s has used /dpdraw and %s won.", GetPlayerNameEx(playerid), GetPlayerNameEx(iWinrar));
			Log("logs/dedicated.log", szMessage);
		}
		else 
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "Nobody online can win!");
		}
	}
	return 1;
}