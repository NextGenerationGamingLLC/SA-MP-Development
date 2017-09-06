/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Famed System

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

stock IsFamedVeh(carid)
{
	for(new i = 0; i < sizeof(FamedVehicles); i++)
	{
	    if(carid == FamedVehicles[i]) return 1;
	}
	return 0;
}

stock IsOSModel(carid)
{
	new Cars[] = {461, 559, 579, 426, 468};
	for(new i = 0; i < sizeof(Cars); i++)
	{
	    if(GetVehicleModel(carid) == Cars[i]) return 1;
	}
	return 0;
}

stock IsCOSModel(carid)
{
	new Cars[] = {560, 506, 411};
	for(new i = 0; i < sizeof(Cars); i++)
	{
	    if(GetVehicleModel(carid) == Cars[i]) return 1;
	}
	return 0;
}

stock IsFamedModel(carid)
{
	new Cars[] = {415, 522, 480, 541, 429, 558};
	for(new i = 0; i < sizeof(Cars); i++)
	{
	    if(GetVehicleModel(carid) == Cars[i]) return 1;
	}
	return 0;
}

stock GetFamedRankName(i)
{
	new string[128];
	switch(i)
	{
		case 1: 
		{
			format(string, sizeof(string), "Old-School");
		}
		case 2: 
		{
			format(string, sizeof(string), "Chartered Old-School");
		}
		case 3: 
		{
			format(string, sizeof(string), "Famed");
		}
		case 4: 
		{
			format(string, sizeof(string), "Famed Commissioner");
		}
		case 5: 
		{
			format(string, sizeof(string), "Famed Moderator");
		}
		case 6: 
		{
			format(string, sizeof(string), "Vice Famed Chairman");
		}
		case 7: 
		{
			format(string, sizeof(string), "Famed Chairman");
		}
		default:
		{
			format(string, sizeof(string), "Unknown");
		}
	}
	return string;
}

stock SendFamedMessage(color, string[])
{
	foreach(new i: Player)
	{
		if((PlayerInfo[i][pFamed] >= 1 || PlayerInfo[i][pAdmin] >= 4) && PlayerInfo[i][pToggledChats][8] == 0) {
			ChatTrafficProcess(i, color, string, 8);
		}
	}	
}

//======[Start of Famed Commands]=======

CMD:fc(playerid, params[]) {
	if(PlayerInfo[playerid][pFamed] >= 1 || PlayerInfo[playerid][pAdmin] >= 2) {
		if(PlayerInfo[playerid][pJailTime] && strfind(PlayerInfo[playerid][pPrisonReason], "[OOC]", true) != -1) return SendClientMessageEx(playerid, COLOR_GREY, "OOC prisoners are restricted to only speak in /b");
		if(isnull(params)) {
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /fc [message]");
		}
		else if(gettime() < GetPVarInt(playerid, "timeFamed")) {

			new
				szMessage[64];

			format(szMessage, sizeof(szMessage), "You must wait %d seconds before speaking again in this channel.", GetPVarInt(playerid, "timeFamed") - gettime());
			SendClientMessageEx(playerid, COLOR_GREY, szMessage);
		}
		else if(PlayerInfo[playerid][pToggledChats][8] == 1) {
		    SendClientMessageEx(playerid, COLOR_GREY, "You have the famed chat toggled - /togfamed to enable it.");
		}
		else if(PlayerInfo[playerid][pFMuted] != 0) {
			SendClientMessageEx(playerid, COLOR_GREY, "You are muted from the famed chat channel.");
		}
		else {

			new
				szMessage[128];

			if(PlayerInfo[playerid][pAdmin] > 2 && GetPVarInt(playerid, "Undercover") == 0)
			{
				format(szMessage, sizeof(szMessage), "** %s %s: %s", GetAdminRankName(PlayerInfo[playerid][pAdmin]), GetPlayerNameEx(playerid), params);
			}
			else if(GetPVarType(playerid, "Undercover") || PlayerInfo[playerid][pFamed] > 0)
			{
				format(szMessage, sizeof(szMessage), "** %s %s: %s", GetFamedRankName(PlayerInfo[playerid][pFamed]), GetPlayerNameEx(playerid), params);
			}
			SendFamedMessage(COLOR_FAMED, szMessage);
		}
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not a famed member!");
	return 1;
}

CMD:fmute(playerid, params[])
{
	if(PlayerInfo[playerid][pFamed] >= 4 || PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1)
	{
	    new string[128], targetid, reason[64];
	    if(sscanf(params, "us[64]", targetid, reason))
			return SendClientMessageEx(playerid, COLOR_GRAD1, "Usage: /fmute [player] [reason]");

		if(IsPlayerConnected(targetid))
		{
		    if(PlayerInfo[targetid][pFMuted] == 0)
		    {
		        if(targetid != INVALID_PLAYER_ID)
		        {
			        if((PlayerInfo[targetid][pFamed] > PlayerInfo[playerid][pFamed] &&  PlayerInfo[playerid][pAdmin] < 2) || PlayerInfo[targetid][pAdmin] > 1)
		 				return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot use this command on this person!");

					PlayerInfo[targetid][pFMuted] = 1;
					format(string, sizeof(string), "You were muted from the famed channel by %s, reason: %s. You may appeal this mute at www.ng-gaming.net/forums", GetPlayerNameEx(playerid), reason);
					SendClientMessageEx(targetid, COLOR_GRAD2, string);
					format(string, sizeof(string), "AdmCmd: %s has muted %s from the Famed Channel, reason: %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(targetid), reason);
					ABroadCast(COLOR_LIGHTRED, string, 2);
					SendClientMessageEx(playerid, COLOR_LIGHTRED, string);
					format(string, sizeof(string), "AdmCmd: %s has muted %s(%d) from the Famed Channel, reason: %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(targetid), GetPlayerSQLId(targetid), reason);
					Log("logs/admin.log", string);
				}
			}
			else return SendClientMessageEx(playerid, COLOR_GRAD1, "This person is already muted from the famed channel!");
		}
		else return SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid player specified.");
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not authorized to use this command!");
	return 1;
}

CMD:funmute(playerid, params[])
{
	if(PlayerInfo[playerid][pFamed] >= 4 || PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1)
	{
	    new string[128], targetid, reason[64];
	    if(sscanf(params, "us[64]", targetid, reason))
			return SendClientMessageEx(playerid, COLOR_GRAD1, "Usage: /funmute [player] [reason]");

		if(IsPlayerConnected(targetid))
		{
		    if(PlayerInfo[targetid][pFMuted] == 1)
		    {
		        if(targetid != INVALID_PLAYER_ID)
		        {
			        if(PlayerInfo[targetid][pFamed] > PlayerInfo[playerid][pFamed] || PlayerInfo[targetid][pAdmin] > PlayerInfo[playerid][pAdmin])
		 				return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot use this command on this person!");

					PlayerInfo[targetid][pFMuted] = 0;
					format(string, sizeof(string), "You were unmuted from the famed channel by %s, reason: %s.", GetPlayerNameEx(playerid), reason);
					SendClientMessageEx(targetid, COLOR_GRAD2, string);
					format(string, sizeof(string), "AdmCmd: %s has unmuted %s from the Famed Channel, reason: %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(targetid), reason);
					ABroadCast(COLOR_LIGHTRED, string, 2);
					SendClientMessageEx(playerid, COLOR_LIGHTRED, string);
					format(string, sizeof(string), "AdmCmd: %s has unmuted %s(%d) from the Famed Channel, reason: %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(targetid), GetPlayerSQLId(targetid), reason);
					Log("logs/admin.log", string);
				}
			}
			else return SendClientMessageEx(playerid, COLOR_GRAD1, "This person is not muted from the famed channel!");
		}
		else return SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid player specified.");
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not authorized to use this command!");
	return 1;
}

CMD:setfamed(playerid, params[])
{
    if(PlayerInfo[playerid][pFamed] >= 6 || PlayerInfo[playerid][pAdmin] >= 1337)
    {
        new string[128], targetid, level;
	    if(sscanf(params, "ui", targetid, level)) {
			SendClientMessageEx(playerid, COLOR_GRAD1, "Usage: /setfamed [player] [level]");
			SendClientMessageEx(playerid, COLOR_GRAD2, "(1) Old-School - (2) Chartered Old-School - (3) Famed - (4) Famed Commissioner");
			SendClientMessageEx(playerid, COLOR_GRAD2, "(5) Famed Moderator - (6) Vice-Chairman - (7) Chairman");
			return 1;
		}
		if(level > 7) return SendClientMessageEx(playerid, COLOR_GRAD2, "Valid Famed levels are 1-7.");
		if(IsPlayerConnected(targetid))
		{
		    if(targetid != INVALID_PLAYER_ID)
		    {
		
			    if(PlayerInfo[targetid][pFamed] > PlayerInfo[playerid][pFamed])
			        return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot use this command on this person!");

				PlayerInfo[targetid][pFamed] = level;
				format(string, sizeof(string), "AdmCmd: %s has set %s famed level to %d.", GetPlayerNameEx(playerid), GetPlayerNameEx(targetid), level);
				ABroadCast(COLOR_LIGHTRED, string, 2);
				SendFamedMessage(COLOR_LIGHTRED, string);
				format(string, sizeof(string), "AdmCmd: %s(%d) has set %s(%d) famed level to %d.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerNameEx(targetid), GetPlayerSQLId(targetid), level);
				Log("logs/setfamed.log", string);
				if(level == 0) format(string, sizeof(string), "Your famed level has been removed by %s.", GetPlayerNameEx(playerid));
				else format(string, sizeof(string), "Your famed level has been set to %s (%d) by %s.", GetFamedRankName(PlayerInfo[targetid][pFamed]), level, GetPlayerNameEx(playerid));
				SendClientMessageEx(targetid, COLOR_LIGHTBLUE, string);
			}
		}
		else return SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid player specified.");
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not authorized to use this command!");
	return 1;
}

CMD:osetfamed(playerid, params[])
{
    if(PlayerInfo[playerid][pFamed] >= 6 || PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1)
    {
        new string[128], pname[MAX_PLAYER_NAME], level;
	    if(sscanf(params, "s[32]i", pname, level))
			return SendClientMessageEx(playerid, COLOR_WHITE, "Usage: /osetfamed [player] [level]");

        new targetid = ReturnUser(pname);
		if(IsPlayerConnected(targetid))
		{
		    return SendClientMessageEx(playerid, COLOR_WHITE, "This player is connected, please use /setfamed");
		}
		else {
		    new
				szQuery[128],
				szPlayerName[MAX_PLAYER_NAME];

			mysql_escape_string(pname, szPlayerName);
			
			SetPVarInt(playerid, "Offline_Famed", level);
			SetPVarString(playerid, "Offline_Name", szPlayerName);
			
            mysql_format(MainPipeline, szQuery, sizeof(szQuery), "SELECT `Famed` FROM `accounts` WHERE `Username` = '%s'", szPlayerName);
 			mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "iii", OFFLINE_FAMED_THREAD, playerid, g_arrQueryHandle{playerid});
 			
 			format(string, sizeof(string), "Attempting to offline set %s account to level %d famed.", szPlayerName, level);
 			SendClientMessageEx(playerid, COLOR_WHITE, string);
 			SendClientMessageEx(playerid, COLOR_YELLOW, "Please wait...");
 		}
 	}
 	else return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not authorized to use this command!");
 	return 1;
}

CMD:flocker(playerid, params[]) {
	return cmd_famedlocker(playerid, params);
}	

CMD:famedlocker(playerid, params[]) {
    #if defined zombiemode
	if(zombieevent == 1 && GetPVarType(playerid, "pIsZombie")) return SendClientMessageEx(playerid, COLOR_GREY, "Zombies can't use this.");
	#endif
	if(IsPlayerInRangeOfPoint(playerid, 4.0, 900.5656, 1429.6812, -82.3250))
	{
	    switch(PlayerInfo[playerid][pFamed])
	    {
			case 0: SendClientMessageEx(playerid, COLOR_GRAD2, "You're not part of famed!");
			case 1: ShowPlayerDialogEx(playerid, DIALOG_LOCKER_OS, DIALOG_STYLE_LIST, "Old-School Locker", "First Aid Kit (Free)\nKevlar Vest ($10000)\nChange Skin ($3,000)\nJob Center", "Select", "Cancel");
			case 2: ShowPlayerDialogEx(playerid, DIALOG_LOCKER_COS, DIALOG_STYLE_LIST, "Chartered Old-School Locker", "First Aid Kit (Free)\nKevlar Vest ($5000)\nChange Skin ($1,500)\nJob Center", "Select", "Cancel");
			case 3: ShowPlayerDialogEx(playerid, DIALOG_LOCKER_FAMED, DIALOG_STYLE_LIST, "Famed Locker", "First Aid Kit (Free)\nKevlar Vest (Free)\nWeapons (Free)\nChange Skin (Free)\nJob Center\nFamed Color", "Select", "Cancel");
            case 4: ShowPlayerDialogEx(playerid, DIALOG_LOCKER_FAMED, DIALOG_STYLE_LIST, "Famed Commissioner Locker", "First Aid Kit (Free)\nKevlar Vest (Free)\nWeapons (Free)\nChange Skin (Free)\nJob Center\nFamed Color", "Select", "Cancel");
            case 5: ShowPlayerDialogEx(playerid, DIALOG_LOCKER_FAMED, DIALOG_STYLE_LIST, "Famed Moderator Locker", "First Aid Kit (Free)\nKevlar Vest (Free)\nWeapons (Free)\nChange Skin (Free)\nJob Center\nFamed Color", "Select", "Cancel");
            case 6: ShowPlayerDialogEx(playerid, DIALOG_LOCKER_FAMED, DIALOG_STYLE_LIST, "Famed Vice-Chairman Locker", "First Aid Kit (Free)\nKevlar Vest (Free)\nWeapons (Free)\nChange Skin (Free)\nJob Center\nFamed Color", "Select", "Cancel");
            case 7: ShowPlayerDialogEx(playerid, DIALOG_LOCKER_FAMED, DIALOG_STYLE_LIST, "Famed Chairman Locker", "First Aid Kit (Free)\nKevlar Vest (Free)\nWeapons (Free)\nChange Skin (Free)\nJob Center\nFamed Color", "Select", "Cancel");
		}
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not at the famed locker!");
	return 1;
}

CMD:famedplate(playerid, params[])
{
	if(PlayerInfo[playerid][pFamed] < 1)
		return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not part of famed!");
		
	new string[128], Float: vHealth, inpveh;
	if(IsPlayerConnected(playerid))
	{
	    if(isnull(params))
	        return SendClientMessageEx(playerid, COLOR_GREY, "Usage: /famedplate [os/cos/famed/remove]");

		inpveh = false;
	    for(new d = 0 ; d < MAX_PLAYERVEHICLES; d++)
	    {
     		if(IsPlayerInVehicle(playerid, PlayerVehicleInfo[playerid][d][pvId]))
       		{
				GetVehicleHealth(PlayerVehicleInfo[playerid][d][pvId], vHealth);
				inpveh = 1;
	                
    			if(vHealth < 800)
       				return SendClientMessageEx(playerid, COLOR_LIGHTRED, "Please repair your vehicle before replacing your plate.");
       				
    			if(strcmp(params, "os", true) == 0)
    			{
    			    format(string, sizeof(string), "{29942B}OLD-SCHOOL");
   			    	format(PlayerVehicleInfo[playerid][d][pvPlate], 32, "%s", string);
    			    SendClientMessageEx(playerid, COLOR_FAMED, "Your vehicle will now appear with the Old-School Plate, parking your vehicle momentarily...");
					cmd_park(playerid, params); //Save a few lines of code here xD
	            }
	            else if(strcmp(params, "cos", true) == 0)
	            {
	                if(PlayerInfo[playerid][pFamed] < 2) return SendClientMessageEx(playerid, COLOR_GRAD2, "You're not a high enough famed member for this plate, sorry.");
                    format(string, sizeof(string), "{F2B602}COS");
					format(PlayerVehicleInfo[playerid][d][pvPlate], 32, "%s", string);
    			    SendClientMessageEx(playerid, COLOR_FAMED, "Your vehicle will now appear with the Chartered Old-School Plate, parking your vehicle momentarily...");
					cmd_park(playerid, params); //Save a few lines of code here xD
	            }
	            else if(strcmp(params, "famed", true) == 0)
	            {
	                if(PlayerInfo[playerid][pFamed] < 3) return SendClientMessageEx(playerid, COLOR_GRAD2, "You're not a high enough famed member for this plate, sorry.");
                    format(string, sizeof(string), "{99FF00}FAMED");
					format(PlayerVehicleInfo[playerid][d][pvPlate], 32, "%s", string);
    			    SendClientMessageEx(playerid, COLOR_FAMED, "Your vehicle will now appear with the Famed Plate, parking your vehicle momentarily...");
					cmd_park(playerid, params); //Save a few lines of code here xD
	            }
	            else if(strcmp(params, "remove", true) == 0)
	            {
					PlayerVehicleInfo[playerid][d][pvPlate] = 0;
    			    SendClientMessageEx(playerid, COLOR_FAMED, "Your vehicle will now appear with the default plate, parking your vehicle momentarily...");
					cmd_park(playerid, params); //Save a few lines of code here xD
	            }
	            else
	                return SendClientMessageEx(playerid, COLOR_GREY, "Usage: /famedplate [os/cos/famed/remove]");
			}
		}
		
		if(inpveh == 0)
		    return SendClientMessageEx(playerid, COLOR_GRAD2, "You're not inside a vehicle that you own!");
	}
	return 1;
}

CMD:fmembers(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1 || PlayerInfo[playerid][pFamed] >= 1)
	{
		new string[2048];
		strcat(string, "Name\tRank", sizeof(string));
		foreach(new i: Player) 
		{
			if(PlayerInfo[i][pFamed] >= 1 && PlayerInfo[i][pTogReports] == 0)
			{
				new famedrank[64];
				switch(PlayerInfo[i][pFamed])
				{
					case 1: famedrank = "{228B22}Old-School\n";
					case 2: famedrank = "{FF7F00}Chartered Old-School\n";
					case 3: famedrank = "{ADFF2F}Famed\n";
					case 4: famedrank = "{8F00FF}Famed Commissioner\n";
					case 5: famedrank = "{8F00FF}Famed Moderator\n";
					case 6: famedrank = "{8F00FF}Famed Vice-Chairman\n";
					case 7: famedrank = "{8F00FF}Famed Chairman\n";
					default: famedrank = "Unknown";
				}
				format(string, sizeof(string), "%s\n{FFFFFF}%s\t%s", string, GetPlayerNameEx(i), famedrank);
			}	
		}
		ShowPlayerDialogEx(playerid, 0, DIALOG_STYLE_TABLIST_HEADERS, "Online Famed Members", string, "Close", "");
	}
	else
		return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not authorized to use this command!");
	return 1;
}