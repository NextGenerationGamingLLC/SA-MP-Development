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

/** Austin's DP system **/


#include <YSI\y_hooks>

SendDedicatedMessage(color, string[])
{
	foreach(new i: Player) 
	{
		if((PlayerInfo[i][pDedicatedPlayer] > 0 || PlayerInfo[i][pAdmin] >= 4) && PlayerInfo[i][pDedicatedEnabled] == 1)
		{
			SendClientMessageEx(i, color, string);
		}
	}
}

HourDedicatedPlayer(playerid)
{
	new	thedate[3];	
	getdate(thedate[0], thedate[1], thedate[2]);
	PlayerInfo[playerid][pDedicatedHours]++;
	if(PlayerInfo[playerid][pDedicatedHours] >= 50 && PlayerInfo[playerid][pDedicatedPlayer] == 0)
	{
		if(PlayerInfo[playerid][pDedicatedPlayer] != 4) PlayerInfo[playerid][pDedicatedPlayer] = 1;
		SendClientMessageEx(playerid, COLOR_YELLOW, "Congratulations you are now a Tier 1 Dedicated Player!");
		format(szMiscArray, sizeof(szMiscArray), "%s has ascended to Tier 1 Dedicated Player after playing 50 hours!", GetPlayerNameEx(playerid));
		SendClientMessageToAll(-1, szMiscArray);
	}
	else if(PlayerInfo[playerid][pDedicatedHours] >= 75 && PlayerInfo[playerid][pDedicatedPlayer] == 1)
	{
		if(PlayerInfo[playerid][pDedicatedPlayer] != 4) PlayerInfo[playerid][pDedicatedPlayer] = 2;
		format(PlayerInfo[playerid][pDedicatedTimestamp], 11, "%d-%02d-%02d", thedate[0], thedate[1], thedate[2]);
		SendClientMessageEx(playerid, COLOR_YELLOW, "Congratulations you are now a Tier 2 Dedicated Player!");
		format(szMiscArray, sizeof(szMiscArray), "%s has ascended to Tier 2 Dedicated Player after playing 75 hours!", GetPlayerNameEx(playerid));
		SendClientMessageToAll(-1, szMiscArray);
	} 
	else if(PlayerInfo[playerid][pDedicatedHours] >= 90 && PlayerInfo[playerid][pDedicatedPlayer] == 2)
	{
		if(PlayerInfo[playerid][pDedicatedPlayer] != 4) PlayerInfo[playerid][pDedicatedPlayer] = 3;
		SendClientMessageEx(playerid, COLOR_YELLOW, "Congratulations you are now a Tier 3 Dedicated Player!");
		format(szMiscArray, sizeof(szMiscArray), "%s has ascended to Tier 3 Dedicated Player after playing 90 hours!.", GetPlayerNameEx(playerid));
		SendClientMessageToAll(-1, szMiscArray);	
	} 
}

DayDedicatedPlayer(playerid)
{
	new	thedate[3],
	    tdate[3];	
	getdate(thedate[0], thedate[1], thedate[2]);
	sscanf(PlayerInfo[playerid][pDedicatedTimestamp], "p<->iii", tdate[0], tdate[1], tdate[2]);
	if(tdate[2]+1 == thedate[2] && PlayerInfo[playerid][pDedicatedPlayer] >= 2)
	{
		GiftPlayer(MAX_PLAYERS, playerid);
		format(PlayerInfo[playerid][pDedicatedTimestamp], 11, "%d-%02d-%02d", thedate[0], thedate[1], thedate[2]);
		PlayerInfo[playerid][pGiftTime] = 0;
	} 
	/*
	else if(thedate[2] == 1 && thedate[1] != tdate[1])
	{
		SendClientMessageEx(playerid, COLOR_RED, "Dedicated: It's a new month your dedicated rank has been reset!");
		PlayerInfo[playerid][pDedicatedPlayer] = 0;
		PlayerInfo[playerid][pDedicatedHours] = 0;
	}
	*/
}


GetDPRankName(playerid)
{
	new rank[77];
	
	if(PlayerInfo[playerid][pAdmin] >= 4 && (PlayerInfo[playerid][pTogReports] == 1 || GetPVarType(playerid, "Undercover")))
	{
		rank = "Tier 1 Dedicated Player";
	}
	else if(PlayerInfo[playerid][pAdmin] >= 4 && PlayerInfo[playerid][pTogReports] == 0)
	{
		switch(PlayerInfo[playerid][pAdmin])
		{
			case 2: rank = "Junior Admin";
			case 3: rank = "General Admin";
			case 4: rank = "Senior Admin";
			case 1337: rank = "Head Admin";
			case 99999: rank = "Executive Admin";
		}
	}
	else 
	{
		switch(PlayerInfo[playerid][pDedicatedPlayer])
		{
			case 1: rank = "Tier 1 Dedicated Player";
			case 2: rank = "Tier 2 Dedicated Player";
			case 3: rank = "Tier 3 Dedicated Player";
			case 4: rank = "Dedicated Moderator";
		}
	}
	return rank;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(dialogid == DIALOG_LOCKER_DP1)
	{
		if(!response) return SendClientMessageEx(playerid, COLOR_GRAD2, "You have exited the locker.");
		if(!IsPlayerInRangeOfPoint(playerid, 4.0, 166.6046,-2001.0406,3499.6482))  return SendClientMessageEx(playerid, COLOR_GRAD2, "You are not near the DP Locker.");// Need co-ordinates
		if(listitem == 0)
		{
			new Float:health;
			GetHealth(playerid, health);
			new hpint = floatround( health, floatround_round );
			if( hpint >= 100 )
			{
				SendClientMessageEx(playerid, COLOR_GREY, "You already have full health.");
				return 1;
			}
			else {
				SetHealth(playerid, 100);
				SendClientMessageEx(playerid, COLOR_YELLOW, "[Dedicated Locker] You have used a first aid kit, you now have 100.0 HP.");
			}
		}
		if(listitem == 1)
		{
			new Float:armour;
			GetArmour(playerid, armour);
			if(armour >= 100)
			{
				SendClientMessageEx(playerid, COLOR_GREY, "You already have full armor.");
				return 1;
			}
			else if(GetPlayerCash(playerid) < 10000)
			{
				SendClientMessageEx(playerid, COLOR_GREY,"You don't have $10,000");
				return 1;
			}
			else 
			{
				GivePlayerCash(playerid, -10000);
				SetArmour(playerid, 100);
				SendClientMessageEx(playerid, COLOR_YELLOW, "[Dedicated Locker] You paid $10,000 for a kevlar vest.");
			}
		}
	}
	else if(dialogid == DIALOG_LOCKER_DP2)
	{
		if(!response) return SendClientMessageEx(playerid, COLOR_GRAD2, "You have exited the locker.");
		if(!IsPlayerInRangeOfPoint(playerid, 4.0, 166.6046,-2001.0406,3499.6482))  return SendClientMessageEx(playerid, COLOR_GRAD2, "You are not near the DP Locker.");// Need co-ordinates
		if(listitem == 0)
		{
			new Float:health;
			GetHealth(playerid, health);
			new hpint = floatround( health, floatround_round );
			if( hpint >= 100 )
			{
				SendClientMessageEx(playerid, COLOR_GREY, "You already have full health.");
				return 1;
			}
			else {
				SetHealth(playerid, 100);
				SendClientMessageEx(playerid, COLOR_YELLOW, "[Dedicated Locker] You have used a first aid kit, you now have 100.0 HP.");
			}
		}
		if(listitem == 1)
		{
			new Float:armour;
			GetArmour(playerid, armour);
			if(armour >= 100)
			{
				SendClientMessageEx(playerid, COLOR_GREY, "You already have full armor.");
				return 1;
			}
			else if(GetPlayerCash(playerid) < 5000 && PlayerInfo[playerid][pDedicatedPlayer] < 3)
			{
				SendClientMessageEx(playerid, COLOR_GREY,"You don't have $5,000");
				return 1;
			}
			else 
			{
				if(PlayerInfo[playerid][pDedicatedPlayer] < 3) GivePlayerCash(playerid, -5000);
				SetArmour(playerid, 100);
				if(PlayerInfo[playerid][pDedicatedPlayer] < 3)
				{
					SendClientMessageEx(playerid, COLOR_YELLOW, "[Dedicated Locker] You paid $5,000 for a kevlar vest.");
				}
				else
				{
					SendClientMessageEx(playerid, COLOR_YELLOW, "[Dedicated Locker] You take a kevlar vest from the locker.");
				}
			}
		}
		if(listitem == 2)
		{
			if(PlayerInfo[playerid][pAccountRestricted] != 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "Your account is restricted!");
			if(PlayerInfo[playerid][pWRestricted] > 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "You can't take weapons out as you're currently weapon restricted!");
			ShowPlayerDialogEx(playerid, DIALOG_DEDICATED_WEAPON, DIALOG_STYLE_LIST, "Dedicated Weapon Inventory", "Desert Eagle (Free)\nSemi-Automatic MP5 (Free)\nPump Shotgun (Free)", "Take", "Cancel");
		}
	}
	else if(dialogid == DIALOG_DEDICATED_WEAPON)
	{
		if(!response) return SendClientMessageEx(playerid, COLOR_GRAD2, "You have exited the locker.");
		if(!IsPlayerInRangeOfPoint(playerid, 4.0, 166.6046,-2001.0406,3499.6482))  return SendClientMessageEx(playerid, COLOR_GRAD2, "You are not near the DP Locker.");// Need co-ordinates
		switch(listitem)
		{
			case 0: //Deagle
			{
				GivePlayerValidWeapon(playerid, 24);
				SendClientMessageEx(playerid, COLOR_YELLOW, "[Dedicated Locker] You have taken a Desert Eagle from the locker.");
			}
			case 1: //MP5
			{
				GivePlayerValidWeapon(playerid, 29);
				SendClientMessageEx(playerid, COLOR_YELLOW, "[Dedicated Locker] You have taken a Semi-Automatic MP5 from the locker.");
			}
			case 2: //Shotgun
			{
				GivePlayerValidWeapon(playerid, 25);
				SendClientMessageEx(playerid, COLOR_YELLOW, "[Dedicated Locker] You have taken a Pump Shotgun from the locker.");
			}
		}

	}
	return 0;
}

/** Austin's Dedicated Player System **/

CMD:dp(playerid, params[]) 
{
	if(PlayerInfo[playerid][pJailTime] && strfind(PlayerInfo[playerid][pPrisonReason], "[OOC]", true) != -1) return SendClientMessageEx(playerid, COLOR_GREY, "OOC prisoners are restricted to only speak in /b");
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1 && !PlayerInfo[playerid][pDedicatedPlayer]) return SendClientMessageEx(playerid, COLOR_GRAD2, "You are not a Dedicated player.");
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
	if(PlayerInfo[playerid][pDedicatedPlayer] > 0 || PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1)
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

CMD:dplocker(playerid, params[])
{
	#if defined zombiemode
	if(zombieevent == 1 && GetPVarType(playerid, "pIsZombie")) return SendClientMessageEx(playerid, COLOR_GREY, "Zombies can't use this.");
	#endif
	if(IsPlayerInRangeOfPoint(playerid, 4.0, 166.6540, -2001.0413, 3499.6482)) // Need co-ordinates
	{
	    switch(PlayerInfo[playerid][pDedicatedPlayer])
	    {
			case 0: SendClientMessageEx(playerid, COLOR_GRAD2, "You're not a dedicated player!");
			case 1: ShowPlayerDialogEx(playerid, DIALOG_LOCKER_DP1, DIALOG_STYLE_LIST, "Dedicated Player 1", "First Aid Kit (Free)\nKevlar Vest ($10,000)", "Select", "Cancel");
			case 2: ShowPlayerDialogEx(playerid, DIALOG_LOCKER_DP2, DIALOG_STYLE_LIST, "Dedicated Player 2", "First Aid Kit (Free)\nKevlar Vest ($5,000)\nWeapons (Free)", "Select", "Cancel");
			default:  ShowPlayerDialogEx(playerid, DIALOG_LOCKER_DP2, DIALOG_STYLE_LIST, "Dedicated Player 3", "First Aid Kit (Free)\nKevlar Vest (Free)\nWeapons (Free)", "Select", "Cancel");
		}
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not at the dedicated locker!");
	return 1;
}
/*
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
*/
CMD:dpwarn(playerid, params[])
{
	new giveplayerid, reason[24], string[164];
	if(PlayerInfo[playerid][pDedicatedPlayer] >= 4 || PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1) 
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
    if(PlayerInfo[playerid][pAdmin] >= 1337)
    {
        new string[128], targetid, level;
	    if(sscanf(params, "ui", targetid, level)) 
	    {
			SendClientMessageEx(playerid, COLOR_GRAD1, "Usage: /setdedicated [player] [level]");
			SendClientMessageEx(playerid, COLOR_GRAD2, "(1) Tier 1 Dedicated - (2) Tier 2 Dedicated - (3) Tier 3 Dedicated 3 - (4) DP Moderator");
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
    if(PlayerInfo[playerid][pAdmin] >= 1337)
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
			
            mysql_format(MainPipeline, szQuery, sizeof(szQuery), "SELECT `pDedicatedPlayer` FROM `accounts` WHERE `Username` = '%s'", szPlayerName);
 			mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "iii", OFFLINE_DEDICATED_THREAD, playerid, g_arrQueryHandle{playerid});
 			
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
	if(PlayerInfo[playerid][pDedicatedPlayer] >= 4 || PlayerInfo[playerid][pAdmin] >= 4)
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
	if(PlayerInfo[playerid][pDedicatedPlayer] >= 4 || PlayerInfo[playerid][pAdmin] >= 4)
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
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pDedicatedPlayer] >= 4 || PlayerInfo[playerid][pASM] >= 1)
	{
		new string[1024];
		foreach(new i : Player)
		{
			if(PlayerInfo[i][pDedicatedPlayer] >= 1)
			{
				format(string, sizeof(string), "%s\nLevel %d Dedicated %s", string, PlayerInfo[i][pDedicatedPlayer], GetPlayerNameEx(i));
			}
		}
		ShowPlayerDialogEx(playerid, 0, DIALOG_STYLE_LIST, "Online Dedicated Players", string, "Close", "");
	}
	else
	{
		 SendClientMessageEx(playerid, COLOR_GRAD1, "You're not authorized to use this command!");
	}
	return 1;
}

CMD:dpdraw(playerid, params[]) 
{
    if(PlayerInfo[playerid][pDedicatedPlayer] >= 4 || PlayerInfo[playerid][pAdmin] >= 1337) 
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
