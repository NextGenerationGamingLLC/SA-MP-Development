/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Admin System

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

CMD:hhc(playerid, params[]) {
	return cmd_hhcheck(playerid, params);
}

CMD:hhcheck(playerid, params[])
{
	new string[128], giveplayerid;
	if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /hhcheck [player]");

	if(IsPlayerConnected(giveplayerid))
	{
		if(PlayerInfo[playerid][pAdmin] >= 3)
		{
		    if(HHcheckFloats[giveplayerid][0] != 0)
		    {
		        SendClientMessageEx(playerid, COLOR_WHITE, "That player is currently being checked for health hacks!");
		        return 1;
		    }
			if(PlayerInfo[giveplayerid][pAdmin] >= PlayerInfo[playerid][pAdmin] && giveplayerid != playerid)
			{
				SendClientMessageEx(playerid, COLOR_WHITE, "You can't perform this action on an equal or higher level administrator.");
				return 1;
			}
   			if(playerTabbed[giveplayerid] != 0)
   			{
      			SendClientMessageEx(playerid, COLOR_WHITE, "That player is currently alt-tabbed!");
		        return 1;
   			}
			if(HHcheckUsed != 0)
		    {
		        SendClientMessageEx(playerid, COLOR_WHITE, "The health hack check is being used by another admin, please try again in a moment!");
		        return 1;
		    }

   			HHcheckUsed = 1;

        	format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s has initiated a health hack check on %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
        	ABroadCast(COLOR_YELLOW, string, 2);

  			format(string, sizeof(string), "Checking %s for health hacks, please wait....", GetPlayerNameEx(giveplayerid));
		    SendClientMessageEx(playerid, COLOR_YELLOW, string);

			GetPlayerHealth(giveplayerid, HHcheckFloats[giveplayerid][0]);
			GetPlayerArmour(giveplayerid, HHcheckFloats[giveplayerid][1]);
			GetPlayerPos(giveplayerid, HHcheckFloats[giveplayerid][2], HHcheckFloats[giveplayerid][3], HHcheckFloats[giveplayerid][4]);
			GetPlayerFacingAngle(giveplayerid, HHcheckFloats[giveplayerid][5]);
			HHcheckVW[giveplayerid] = GetPlayerVirtualWorld(giveplayerid);
			HHcheckInt[giveplayerid] = GetPlayerInterior(giveplayerid);

			DeletePVar(giveplayerid, "IsFrozen");
			TogglePlayerControllable(giveplayerid, 1);

            SetPlayerCameraPos(giveplayerid, 785.1896,1692.6887,5.2813);
			SetPlayerCameraLookAt(giveplayerid, 785.1896,1692.6887,0);
            SetPlayerVirtualWorld(giveplayerid, 0);
		    SetPlayerInterior(giveplayerid, 1);
		    SetPlayerHealth(giveplayerid, 100);
		    RemoveArmor(giveplayerid);
			SetPlayerPos(giveplayerid, -1400.994873, 106.899650, 1032.273437);
			SetPlayerFacingAngle(giveplayerid, 90.66);
			CreateExplosion(-1400.994873, 106.899650 , 1032.273437, 8, 20);

			SetTimerEx("HealthHackCheck", 1250, 0, "dd", playerid, giveplayerid);
		}
		else SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use that command.");
	}
	else SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid player specified.");
	return 1;
}

CMD:id(playerid, params[]) {
	if(isnull(params)) {
		return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /id [player name]");
	}

	new
		szMessage[128],
		szPlayerName[MAX_PLAYER_NAME],
		iTargetID = strval(params);

	if(IsNumeric(params) && IsPlayerConnected(strval(params)))
	{
	    if(PlayerInfo[playerid][pAdmin] >= 2) format(szMessage, sizeof szMessage, "%s (ID: %d) - (Level: %d) - (Ping: %d) - (FPS: %d)", GetPlayerNameEx(iTargetID), iTargetID, PlayerInfo[iTargetID][pLevel], GetPlayerPing(iTargetID), pFPS[iTargetID]);
		else format(szMessage, sizeof szMessage, "%s (ID: %d) - (Level: %d) - (Ping: %d)", GetPlayerNameEx(iTargetID), iTargetID, PlayerInfo[iTargetID][pLevel], GetPlayerPing(iTargetID));
		return SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
	}
	else if(strlen(params) < 3) {
		return SendClientMessageEx(playerid, COLOR_GREY, "Input at least 3 characters to search.");
	}
	//else foreach(new i: Player)
	else for(new i = 0; i < MAX_PLAYERS; ++i)
	{
		if(IsPlayerConnected(i))
		{
			GetPlayerName(i, szPlayerName, sizeof szPlayerName);
			if(strfind(szPlayerName, params, true) != -1) {
				if(PlayerInfo[playerid][pAdmin] >= 2) format(szMessage, sizeof szMessage, "%s (ID: %d) - (Level: %d) - (Ping: %d) - (FPS: %d)", GetPlayerNameEx(i), i, PlayerInfo[i][pLevel], GetPlayerPing(i), pFPS[i]);
				else format(szMessage, sizeof szMessage, "%s (ID: %d) - (Level: %d) - (Ping: %d)", GetPlayerNameEx(i), i, PlayerInfo[i][pLevel], GetPlayerPing(i));
				SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
			}
		}	
	}
	return 1;
}

CMD:near(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 2)
	{
		new radius, string[128];
		if(sscanf(params, "d", radius)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /near [radius]");
		if(radius < 1 || radius > 100) return SendClientMessageEx(playerid, COLOR_GREY, "Radius must be higher than 0 and lower than 100!");

		format(string, sizeof(string), "Players within a %d block radius", radius);
		SendClientMessageEx(playerid, COLOR_GRAD5, string);
        //foreach(new i: Player)
		for(new i = 0; i < MAX_PLAYERS; ++i)
		{
			if(IsPlayerConnected(i))
			{
				if(i != playerid && ProxDetectorS(radius, playerid, i))
				{
					format(string, sizeof(string), "%s (ID: %d - Level: %d)", GetPlayerNameEx(i), i, PlayerInfo[i][pLevel]);
					SendClientMessageEx(playerid, COLOR_WHITE, string);
				}
			}	
        }
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	return 1;
}

CMD:givegun(playerid, params[])
{
    if (PlayerInfo[playerid][pAdmin] >= 4) {
        new sstring[128], playa, gun;

        if(sscanf(params, "ud", playa, gun)) {
            SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /givegun [player] [weaponid]");
            SendClientMessageEx(playerid, COLOR_GREEN, "_______________________________________");
            SendClientMessageEx(playerid, COLOR_GRAD4, "(1)Brass Knuckles (2)Golf Club (3)Nite Stick (4)Knife (5)Baseball Bat (6)Shovel (7)Pool Cue (8)Katana (9)Chainsaw");
            SendClientMessageEx(playerid, COLOR_GRAD4, "(10)Purple Dildo (11)Small White Vibrator (12)Large White Vibrator (13)Silver Vibrator (14)Flowers (15)Cane (16)Frag Grenade");
            SendClientMessageEx(playerid, COLOR_GRAD3, "(17)Tear Gas (18)Molotov Cocktail (21)Jetpack (22)9mm (23)Silenced 9mm (24)Desert Eagle (25)Shotgun (26)Sawnoff Shotgun");
            SendClientMessageEx(playerid, COLOR_GRAD4, "(27)Combat Shotgun (28)Micro SMG (Mac 10) (29)SMG (MP5) (30)AK-47 (31)M4 (32)Tec9 (33)Rifle (34)Sniper Rifle");
            SendClientMessageEx(playerid, COLOR_GRAD4, "(35)Rocket Launcher (36)HS Rocket Launcher (37)Flamethrower (38)Minigun (39)Satchel Charge (40)Detonator");
            SendClientMessageEx(playerid, COLOR_GRAD4, "(41)Spraycan (42)Fire Extinguisher (43)Camera (44)Nightvision Goggles (45)Infared Goggles (46)Parachute");
            SendClientMessageEx(playerid, COLOR_GREEN, "_______________________________________");
            return 1;
        }

        format(sstring, sizeof(sstring), "You have given %s gun ID %d!",GetPlayerNameEx(playa),gun);
        if(gun < 1||gun > 47)
            { SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid weapon ID!"); return 1; }
        if(IsPlayerConnected(playa)) 
		{	
            if((PlayerInfo[playa][pConnectHours] < 2 || PlayerInfo[playa][pWRestricted] > 0) && gun != 46 && gun != 43) return SendClientMessageEx(playerid, COLOR_GRAD2, "That person is currently restricted from carrying weapons");
			if(PlayerInfo[playa][pAccountRestricted] != 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot do this to someone that has his account restricted!");
		    if(playa != INVALID_PLAYER_ID && gun <= 20 || gun >= 22) {
                PlayerInfo[playa][pAGuns][GetWeaponSlot(gun)] = gun;
                GivePlayerValidWeapon(playa, gun, 60000);
                SendClientMessageEx(playerid, COLOR_GRAD1, sstring);
            }
            else if(playa != INVALID_PLAYER_ID && gun == 21) {
                JetPack[playa] = 1;
                SetPlayerSpecialAction(playa, SPECIAL_ACTION_USEJETPACK);
                SendClientMessageEx(playerid, COLOR_GRAD1, sstring);
            }
        }
    }
    else {
        SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
    }
    return 1;
}

CMD:jetpack(playerid, params[])
{
	new string[128], plo;
	if((PlayerInfo[playerid][pAdmin] >= 2) && sscanf(params, "u", plo)) {
        JetPack[playerid] = 1;
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USEJETPACK);
        return 1;
    }
	else if(PlayerInfo[playerid][pAdmin] >= 4 && !sscanf(params, "u", plo))
	{
		if (IsPlayerConnected(plo))
		{
			if(plo != INVALID_PLAYER_ID)
			{
				SendClientMessageEx(plo, COLOR_GRAD1, "Enjoy your new jetpack!");
				JetPack[plo] = 1;
				SetPlayerSpecialAction(plo, SPECIAL_ACTION_USEJETPACK);
				format(string, sizeof(string), "AdmCmd: %s has received a jetpack from %s", GetPlayerNameEx(plo), GetPlayerNameEx(playerid));
				SendClientMessageToAllEx(COLOR_LIGHTRED, string);
				format(string, sizeof(string), "[Admin] %s (IP:%s) has given %s(%d) (IP:%s) a Jetpack.", GetPlayerNameEx(playerid), GetPlayerIpEx(playerid), GetPlayerNameEx(plo), GetPlayerSQLId(plo), GetPlayerIpEx(plo));
				Log("logs/admingive.log", string);
			}
		}
		else return SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid player specified.");
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
    return 1;
}

CMD:sethp(playerid, params[])
{
	new string[128], playa, health;
	if(sscanf(params, "ud", playa, health)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /sethp [player] [health]");
	if(PlayerInfo[playa][pJailTime] >= 1) return SendClientMessage(playerid, COLOR_WHITE, "You can't set a OOC Prisoner Health!");
	if((PlayerInfo[playa][pAdmin] >= PlayerInfo[playerid][pAdmin]) && playa != playerid) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot use this command on the same/greater level admin than you!");
	if(PlayerInfo[playerid][pAdmin] >= 4) {
		if(IsPlayerConnected(playa)) {
			if(playa != INVALID_PLAYER_ID)
			{
				SetPlayerHealth(playa, health);
				format(string, sizeof(string), "You have set %s's health to %d.", GetPlayerNameEx(playa), health);
				SendClientMessageEx(playerid, COLOR_WHITE, string);
			}
		}
		else return SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid player specified.");
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	return 1;
}

CMD:setmyhp(playerid, params[])
{
    new string[128], health;
    if(sscanf(params, "d", health)) {
        SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /setmyhp [health]");
        return 1;
    }
    if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pUndercover] >= 1) {
        SetPlayerHealth(playerid, health);
        format(string, sizeof(string), "You have set your health to %d.", health);
        SendClientMessageEx(playerid, COLOR_WHITE, string);
    }
    else {
        SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
    }
    return 1;
}

CMD:setarmor(playerid, params[])
{
    new string[128], playa, health;
    if(sscanf(params, "ud", playa, health))
	{
        SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /setarmor [player] [armor]");
        return 1;
    }
    if (PlayerInfo[playerid][pAdmin] >= 4)
	{
        if(IsPlayerConnected(playa))
		{
            if(playa != INVALID_PLAYER_ID)
			{
                SetPlayerArmor(playa, health);
                format(string, sizeof(string), "You have set %s's armor to %d.", GetPlayerNameEx(playa), health);
                SendClientMessageEx(playerid, COLOR_WHITE, string);
            }
        }
    }
    else
	{
        SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
    }
    return 1;
}

CMD:hackwarnings(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 2) {
		//foreach(new i: Player)
		for(new i = 0; i < MAX_PLAYERS; ++i)
		{
			if(IsPlayerConnected(i))
			{
				if(GetPVarType(i, "ArmorWarning"))
				{
					new Float: armor, szMessage[128];
					GetPlayerArmour(i, armor);
					if(armor > CurrentArmor[i])
					{
						format(szMessage, sizeof(szMessage), "%s (ID: %i, Level: %d) - Armor Hacking - Recorded: %f - Current: %f", GetPlayerNameEx(i), i, PlayerInfo[i][pLevel], CurrentArmor[i], armor);
						SendClientMessage(playerid, COLOR_WHITE, szMessage);
					}
				}
			}	
		}
	}
	return 1;
}

CMD:setmyarmor(playerid, params[])
{
    new string[128], armor;
    if(sscanf(params, "d", armor))
	{
        SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /setmyarmor [amount]");
        return 1;
    }
    if (PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pUndercover] >= 1)
	{
        SetPlayerArmor(playerid, armor);
        format(string, sizeof(string), "You have set your armor to %d.", armor);
        SendClientMessageEx(playerid, COLOR_WHITE, string);
    }
    else
	{
        SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
    }
    return 1;
}

CMD:setarmorall(playerid, params[])
{
    new armor;
    if(sscanf(params, "d", armor)) {
        SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /setarmorall [armor]");
        return 1;
    }

    if (PlayerInfo[playerid][pAdmin] >= 1337) {
        //foreach(new i: Player)
		for(new i = 0; i < MAX_PLAYERS; ++i)
		{
			if(IsPlayerConnected(i))
			{
				SetPlayerArmor(i, armor);
			}	
        }
    }

    else {
        SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
    }
    return 1;
}

CMD:savecfgs(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 1337) {
        SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use that command.");
        return 1;
    }
    SendClientMessageEx(playerid, COLOR_WHITE, "* Saving CFG Files..");
    SaveTurfWars();
    SaveFamilies();
    SendClientMessageEx(playerid, COLOR_WHITE, "* Done");
    return 1;
}


CMD:loadcfgs(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 1337) {
        SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use that command.");
        return 1;
    }
    SendClientMessageEx(playerid, COLOR_WHITE, "* Reloading CFG Files..");
    g_mysql_LoadMOTD();
	// Local Configs
	Misc_Load();
    SendClientMessageEx(playerid, COLOR_WHITE, "* Done");
    return 1;
}

CMD:admins(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 2) {
        SendClientMessageEx(playerid, COLOR_GRAD1, "Admins Online:");
        //foreach(new i: Player)
		for(new i = 0; i < MAX_PLAYERS; ++i)
		{
			if(IsPlayerConnected(i))
			{
				if(PlayerInfo[i][pAdmin] >= 2 && PlayerInfo[i][pAdmin] <= PlayerInfo[playerid][pAdmin]) {
					new string[128], tdate[11], thour[9], i_timestamp[3];
					getdate(i_timestamp[0], i_timestamp[1], i_timestamp[2]);
					format(tdate, sizeof(tdate), "%d-%02d-%02d", i_timestamp[0], i_timestamp[1], i_timestamp[2]);
					format(thour, sizeof(thour), "%02d:00:00", hour);

					if(PlayerInfo[playerid][pAdmin] >= 4)
					{
						if(PlayerInfo[i][pAdmin] == 2) format(string, sizeof(string), "%s{BFC0C2}: %s (RTH: %d | RT: %d)", GetStaffRank(i), GetPlayerNameEx(i), ReportHourCount[i], ReportCount[i]);
						else if(PlayerInfo[i][pAdmin] == 3) format(string, sizeof(string), "%s{BFC0C2}: %s (RTH: %d | RT: %d)", GetStaffRank(i), GetPlayerNameEx(i), ReportHourCount[i], ReportCount[i]);
						else if(PlayerInfo[i][pAdmin] == 4) format(string, sizeof(string), "%s{BFC0C2}: %s (RTH: %d | RT: %d)", GetStaffRank(i), GetPlayerNameEx(i), ReportHourCount[i], ReportCount[i]);
						else if(PlayerInfo[i][pAdmin] == 1337) format(string, sizeof(string), "%s{BFC0C2}: %s (RTH: %d | RT: %d)", GetStaffRank(i), GetPlayerNameEx(i), ReportHourCount[i], ReportCount[i]);
						else if(PlayerInfo[i][pAdmin] == 1338) format(string, sizeof(string), "%s{BFC0C2}: %s (RTH: %d | RT: %d)", GetStaffRank(i), GetPlayerNameEx(i), ReportHourCount[i], ReportCount[i]);
						else if(PlayerInfo[i][pAdmin] == 99999) format(string, sizeof(string), "%s{BFC0C2}: %s (RTH: %d | RT: %d)", GetStaffRank(i), GetPlayerNameEx(i), ReportHourCount[i], ReportCount[i]);
						else format(string, sizeof(string), "%s{BFC0C2}: %s", GetStaffRank(i), PlayerInfo[i][pAdmin], GetPlayerNameEx(i));
					}
					else
					{
						if(PlayerInfo[i][pAdmin] == 2) format(string, sizeof(string), "%s{BFC0C2}: %s", GetStaffRank(i), GetPlayerNameEx(i));
						else if(PlayerInfo[i][pAdmin] == 3) format(string, sizeof(string), "%s{BFC0C2}: %s", GetStaffRank(i), GetPlayerNameEx(i));
						else if(PlayerInfo[i][pAdmin] == 4) format(string, sizeof(string), "%s{BFC0C2}: %s", GetStaffRank(i), GetPlayerNameEx(i));
						else if(PlayerInfo[i][pAdmin] == 1337) format(string, sizeof(string), "%s{BFC0C2}: %s", GetStaffRank(i), GetPlayerNameEx(i));
						else if(PlayerInfo[i][pAdmin] == 1338) format(string, sizeof(string), "%s{BFC0C2}: %s", GetStaffRank(i), GetPlayerNameEx(i));
						else if(PlayerInfo[i][pAdmin] == 99999) format(string, sizeof(string), "%s{BFC0C2}: %s", GetStaffRank(i), GetPlayerNameEx(i));
						else format(string, sizeof(string), "%s{BFC0C2}: %s", PlayerInfo[i][pAdmin], GetPlayerNameEx(i));
					}

					if(PlayerInfo[i][pBanAppealer] == 1) strcat(string, " [BA]");
					if(PlayerInfo[i][pBanAppealer] == 2) strcat(string, " [DOBA]");
					if(PlayerInfo[i][pShopTech] == 1) strcat(string, " [ST]");
					if(PlayerInfo[i][pShopTech] == 2) strcat(string, " [SST]");
					if(PlayerInfo[i][pShopTech] == 3) strcat(string, " [DOCR]");
					if(PlayerInfo[i][pUndercover] == 1) strcat(string, " [UC]");
					if(PlayerInfo[i][pUndercover] == 2) strcat(string, " [DOSO]");
					if(PlayerInfo[i][pFactionModerator] == 1) strcat(string, " [FMOD]");
					if(PlayerInfo[i][pFactionModerator] == 2) strcat(string, " [DOFM]");
					if(PlayerInfo[i][pGangModerator] == 1) strcat(string, " [GMOD]");
					if(PlayerInfo[i][pGangModerator] == 2) strcat(string, " [DOGM]");
					if(PlayerInfo[i][pTogReports]) strcat(string, " [SPEC MODE]");
					if(PlayerInfo[i][pPR] == 1) strcat(string, " [PR]");
					if(PlayerInfo[i][pPR] == 2) strcat(string, " [DOPR]");
					if(PlayerInfo[i][pHR] >= 1) strcat(string, " [HR]");
					if(PlayerInfo[i][pAP] >= 1) strcat(string, " [AP]");
					if(PlayerInfo[i][pWatchdog] == 4) strcat(string, " [DoRPI]");
					if(PlayerInfo[i][pSecurity] >= 1) strcat(string, " [Sec]");
					if(PlayerInfo[i][pBM] == 1) strcat(string, " [BM]");
					if(PlayerInfo[i][pBM] == 2) strcat(string, " [DOBM]");
					SendClientMessageEx(playerid, COLOR_GRAD2, string);
				}
			}	
        }
    }
    else {
        SendClientMessageEx(playerid, COLOR_GRAD1, "If you have questions regarding gameplay or the server, use /requesthelp or /newb");
        SendClientMessageEx(playerid, COLOR_GRAD1, "If you see a player breaking rules or need Admin assistance, use /report");
    }
    return 1;
}

CMD:dn(playerid, params[])
{
    if (PlayerInfo[playerid][pAdmin] >= 2)
	{
        new Float:slx, Float:sly, Float:slz;
		GetPlayerPos(playerid, slx, sly, slz);
		if (GetPlayerState(playerid) == 2)
		{
			new tmpcar = GetPlayerVehicleID(playerid);
			SetVehiclePos(tmpcar, slx, sly, slz-2);
			fVehSpeed[playerid] = 0.0;
		}
		else
		{
			SetPlayerPos(playerid, slx, sly, slz-2);
		}
        return 1;
    }
    else
	{
        SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
    }
    return 1;
}

CMD:up(playerid, params[])
{
    if (PlayerInfo[playerid][pAdmin] >= 2)
	{
        new Float:slx, Float:sly, Float:slz;
        GetPlayerPos(playerid, slx, sly, slz);
		if (GetPlayerState(playerid) == 2)
		{
			new tmpcar = GetPlayerVehicleID(playerid);
			SetVehiclePos(tmpcar, slx, sly, slz+5);
			fVehSpeed[playerid] = 0.0;
		}
		else
		{
			SetPlayerPos(playerid, slx, sly, slz+5);
		}
        return 1;
    }
    else
	{
        SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
    }
    return 1;
}

CMD:fly(playerid, params[])
{
    if (PlayerInfo[playerid][pAdmin] >= 2) {
        new Float:px, Float:py, Float:pz, Float:pa;
        GetPlayerFacingAngle(playerid,pa);
        if(pa >= 0.0 && pa <= 22.5) {             //n1
            GetPlayerPos(playerid, px, py, pz);
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, px, py+30, pz+5);
				fVehSpeed[playerid] = 0.0;
			}
			else
			{
				SetPlayerPos(playerid, px, py+30, pz+5);
			}
        }
        if(pa >= 332.5 && pa < 0.0) {             //n2
            GetPlayerPos(playerid, px, py, pz);
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, px, py+30, pz+5);
				fVehSpeed[playerid] = 0.0;
			}
			else
			{
				SetPlayerPos(playerid, px, py+30, pz+5);
			}
        }
        if(pa >= 22.5 && pa <= 67.5) {            //nw
            GetPlayerPos(playerid, px, py, pz);
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, px-15, py+15, pz+5);
				fVehSpeed[playerid] = 0.0;
			}
			else
			{
				SetPlayerPos(playerid, px-15, py+15, pz+5);
			}
        }
        if(pa >= 67.5 && pa <= 112.5) {           //w
            GetPlayerPos(playerid, px, py, pz);
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, px-30, py, pz+5);
				fVehSpeed[playerid] = 0.0;
			}
			else
			{
				SetPlayerPos(playerid, px-30, py, pz+5);
			}
        }
        if(pa >= 112.5 && pa <= 157.5) {          //sw
            GetPlayerPos(playerid, px, py, pz);
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, px-15, py-15, pz+5);
				fVehSpeed[playerid] = 0.0;
			}
			else
			{
				SetPlayerPos(playerid, px-15, py-15, pz+5);
			}
        }
        if(pa >= 157.5 && pa <= 202.5) {          //s
            GetPlayerPos(playerid, px, py, pz);
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, px, py-30, pz+5);
				fVehSpeed[playerid] = 0.0;
			}
			else
			{
				SetPlayerPos(playerid, px, py-30, pz+5);
			}
        }
        if(pa >= 202.5 && pa <= 247.5) {          //se
            GetPlayerPos(playerid, px, py, pz);
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, px+15, py-15, pz+5);
				fVehSpeed[playerid] = 0.0;
			}
			else
			{
				SetPlayerPos(playerid, px+15, py-15, pz+5);
			}
        }
        if(pa >= 247.5 && pa <= 292.5) {          //e
            GetPlayerPos(playerid, px, py, pz);
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, px+30, py, pz+5);
				fVehSpeed[playerid] = 0.0;
			}
			else
			{
				SetPlayerPos(playerid, px+30, py, pz+5);
			}
        }
        if(pa >= 292.5 && pa <= 332.5) {          //e
            GetPlayerPos(playerid, px, py, pz);
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, px+15, py+15, pz+5);
				fVehSpeed[playerid] = 0.0;
			}
			else
			{
				SetPlayerPos(playerid, px+15, py+15, pz+5);
			}
        }
    }
    else {
        SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
    }
    return 1;
}

CMD:lt(playerid, params[])
{
    if (PlayerInfo[playerid][pAdmin] >= 2)
	{
        new Float:slx, Float:sly, Float:slz;
        GetPlayerPos(playerid, slx, sly, slz);
		if (GetPlayerState(playerid) == 2)
		{
			new tmpcar = GetPlayerVehicleID(playerid);
			SetVehiclePos(tmpcar, slx-2, sly, slz);
			fVehSpeed[playerid] = 0.0;
		}
		else
		{
			SetPlayerPos(playerid, slx-2, sly, slz);
		}
        return 1;
    }
    else
	{
        SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
    }
    return 1;
}

CMD:rt(playerid, params[])
{
    if (PlayerInfo[playerid][pAdmin] >= 2)
	{
        new Float:slx, Float:sly, Float:slz;
        GetPlayerPos(playerid, slx, sly, slz);
		if (GetPlayerState(playerid) == 2)
		{
			new tmpcar = GetPlayerVehicleID(playerid);
			SetVehiclePos(tmpcar, slx+2, sly, slz);
			fVehSpeed[playerid] = 0.0;
		}
		else
		{
			SetPlayerPos(playerid, slx+2, sly, slz);
		}
        return 1;
    }
    else
	{
        SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
    }
    return 1;
}

CMD:fd(playerid, params[])
{
    if (PlayerInfo[playerid][pAdmin] >= 2)
	{
        new Float:slx, Float:sly, Float:slz;
        GetPlayerPos(playerid, slx, sly, slz);
		if (GetPlayerState(playerid) == 2)
		{
			new tmpcar = GetPlayerVehicleID(playerid);
			SetVehiclePos(tmpcar, slx, sly+2, slz);
			fVehSpeed[playerid] = 0.0;
		}
		else
		{
			SetPlayerPos(playerid, slx, sly+2, slz);
		}
        return 1;
    }
    else
	{
        SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
    }
    return 1;
}

CMD:bk(playerid, params[])
{
    if (PlayerInfo[playerid][pAdmin] >= 2)
	{
        new Float:slx, Float:sly, Float:slz;
        GetPlayerPos(playerid, slx, sly, slz);
		if (GetPlayerState(playerid) == 2)
		{
			new tmpcar = GetPlayerVehicleID(playerid);
			SetVehiclePos(tmpcar, slx, sly-2, slz);
			fVehSpeed[playerid] = 0.0;
		}
		else
		{
			SetPlayerPos(playerid, slx, sly-2, slz);
		}
        return 1;
    }
    else
	{
        SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
    }
    return 1;
}

CMD:mjail(playerid, params[]) {
	if(PlayerInfo[playerid][pAdmin] == 1 || PlayerInfo[playerid][pHelper] >= 2) {

		new
			iTargetID,
			szReason[64];

		if(sscanf(params, "us[64]", iTargetID, szReason)) {
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /mjail [player] [reason]");
		}
		else if(IsPlayerConnected(iTargetID)) {
			if(PlayerInfo[iTargetID][pAdmin] == 1) {
				return SendClientMessageEx(playerid, COLOR_WHITE, "You can't perform this action on moderators.");
			}
			if(PlayerInfo[iTargetID][pAdmin] > PlayerInfo[playerid][pAdmin]) {
				return SendClientMessageEx(playerid, COLOR_WHITE, "You can't perform this action on administrators.");
			}
			if(PlayerInfo[iTargetID][pHelper] >= 2) {
				return SendClientMessageEx(playerid, COLOR_WHITE, "You can't perform this action on community advisors.");
			}
            if(PlayerInfo[iTargetID][pJailTime] > 0) {
			    return SendClientMessageEx(playerid, COLOR_GREY, "You can't perform this action on someone in jail already.");
			}
			if(GetPVarInt(iTargetID, "IsInArena") >= 0) LeavePaintballArena(iTargetID, GetPVarInt(iTargetID, "IsInArena"));

			new
				szMessage[128];
			if(GetPVarInt(iTargetID, "Injured") == 1)
			{
				KillEMSQueue(iTargetID);
				ClearAnimations(iTargetID);
			}
			ResetPlayerWeaponsEx(iTargetID);

			PhoneOnline[iTargetID] = 1;
			PlayerInfo[iTargetID][pJailTime] = 20*60;
			SetPVarInt(iTargetID, "_rAppeal", gettime()+60);
			SetPlayerInterior(iTargetID, 1);
			PlayerInfo[iTargetID][pInt] = 1;
        	SetPlayerHealth(iTargetID, 0x7FB00000);
			new rand = random(sizeof(OOCPrisonSpawns));
			Streamer_UpdateEx(iTargetID, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2]);
			SetPlayerPos(iTargetID, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2]);
			SetPlayerSkin(iTargetID, 50);

			PlayerInfo[iTargetID][pVW] = 0;
			SetPlayerVirtualWorld(iTargetID, 0);
			SetPlayerColor(iTargetID, TEAM_APRISON_COLOR);

			Player_StreamPrep(iTargetID, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2], FREEZE_TIME);

			format(szMessage, sizeof(szMessage), "AdmCmd: %s has been jailed by %s, reason: %s", GetPlayerNameEx(iTargetID), GetPlayerNameEx(playerid), szReason);
			SendClientMessageToAllEx(COLOR_LIGHTRED, szMessage);

			format(szMessage, sizeof(szMessage), "AdmCmd: %s(%d) has been jailed by %s(%d), reason: %s", GetPlayerNameEx(iTargetID), GetPlayerSQLId(iTargetID), GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), szReason);
			Log("logs/moderator.log", szMessage);

			format(szMessage, sizeof(szMessage), "You have been jailed by Server Moderator %s for 20 minutes for violation of server rules.", GetPlayerNameEx(playerid));
			SendClientMessageEx(iTargetID, COLOR_LIGHTBLUE, szMessage);

			format(szMessage, sizeof(szMessage), "Reason: %s", szReason);
			SendClientMessageEx(iTargetID, COLOR_LIGHTBLUE, szMessage);

            format(szReason, sizeof(szReason), "[OOC] %s", szReason);
			strcpy(PlayerInfo[iTargetID][pPrisonedBy], GetPlayerNameEx(playerid), MAX_PLAYER_NAME);
			strcpy(PlayerInfo[iTargetID][pPrisonReason], szReason, 128);
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
		}
	}
	return 1;
}

CMD:prisoners(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 2)
 	{
  		new Count;
		new string[128];

		SendClientMessageEx(playerid, COLOR_WHITE, "----------------------------------------");
  		SendClientMessageEx(playerid, COLOR_WHITE, "Name | Prisoned By | Time Left | Reason");

		//foreach(new i: Player)
		for(new i = 0; i < MAX_PLAYERS; ++i)
		{
			if(IsPlayerConnected(i))
			{
				if(PlayerInfo[i][pJailTime] >= 1)
				{
					if(strlen(PlayerInfo[i][pPrisonReason]) >= 1 && strlen(PlayerInfo[i][pPrisonedBy]) >= 1)
					{
							Count++;
							format(string, sizeof(string), "%s (%d) | %s | %s | %s", GetPlayerNameEx(i), i, PlayerInfo[i][pPrisonedBy], TimeConvert(PlayerInfo[i][pJailTime]), PlayerInfo[i][pPrisonReason]);
							SendClientMessageEx(playerid, COLOR_GREY, string);
					}
					else
					{
						format(string, sizeof(string), "%s (%d) | Unavailable | %s | Unavailable", GetPlayerNameEx(i), i, TimeConvert(PlayerInfo[i][pJailTime]));
						SendClientMessageEx(playerid, COLOR_GREY, string);
					}
				}
			}	
      	}
      	SendClientMessageEx(playerid, COLOR_WHITE, "----------------------------------------");
	}
	return 1;
}

CMD:noooc(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 3)
	{
		if (!noooc)
		{
			noooc = 1;
			SendClientMessageToAllEx(COLOR_GRAD2, "   OOC chat channel disabled by an Admin!");
		}
		else
		{
			noooc = 0;
			SendClientMessageToAllEx(COLOR_GRAD2, "   OOC chat channel enabled by an Admin!");
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	}
	return 1;
}

CMD:togstaff(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 1 || PlayerInfo[playerid][pDonateRank] == 5 || PlayerInfo[playerid][pWatchdog] >= 1)
	{
		if (!advisorchat[playerid])
		{
			advisorchat[playerid] = 1;
			SendClientMessageEx(playerid, COLOR_GRAD2, "   You can now see the /staff chat!");
		}
		else
		{
			advisorchat[playerid] = 0;
			SendClientMessageEx(playerid, COLOR_GRAD2, "   You will not see the /staff chat anymore!");
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREY, "   You are not allowed to use this command!");
		return 1;
	}
	return 1;
}

CMD:vehname(playerid, params[]) {

	if(PlayerInfo[playerid][pAdmin] >= 2) {

		SendClientMessageEx(playerid, COLOR_YELLOW, "--------------------------------------------------------------------------------------------------------------------------------");
		SendClientMessageEx(playerid, COLOR_WHITE, "Vehicle Search:");

		new
			string[128];

		if(isnull(params)) return SendClientMessageEx(playerid, COLOR_GREY, "No keyword specified.");
		if(!params[2]) return SendClientMessageEx(playerid, COLOR_GREY, "Search keyword too short.");

		for(new v; v < sizeof(VehicleName); v++) {
			if(strfind(VehicleName[v], params, true) != -1) {

				if(isnull(string)) format(string, sizeof(string), "%s (ID %d)", VehicleName[v], v+400);
				else format(string, sizeof(string), "%s | %s (ID %d)", string, VehicleName[v], v+400);
			}
		}

		if(!string[0]) SendClientMessageEx(playerid, COLOR_GREY, "No results found.");
		else if(string[127]) SendClientMessageEx(playerid, COLOR_GREY, "Too many results found.");
		else SendClientMessageEx(playerid, COLOR_WHITE, string);

		SendClientMessageEx(playerid, COLOR_YELLOW, "--------------------------------------------------------------------------------------------------------------------------------");
	}
	return 1;
}

CMD:mstats(playerid, params[]) {
	if(PlayerInfo[playerid][pAdmin] < 4) {
		SendClientMessageEx(playerid, COLOR_GREY, "You're not authorised to use this command.");
		return 1;
	}
	else {
	    new stats[256];
		mysql_stat(stats, MainPipeline);
		SendClientMessageEx(playerid, COLOR_GREEN,"___________________________________________________________________________________________________");
		SendClientMessageEx(playerid, COLOR_GREY, stats);
		SendClientMessageEx(playerid, COLOR_GREEN,"___________________________________________________________________________________________________");
		#if defined SHOPAUTOMATED
		mysql_stat(stats, ShopPipeline);
		SendClientMessageEx(playerid, COLOR_GREEN,"___________________________________________________________________________________________________");
		SendClientMessageEx(playerid, COLOR_GREY, stats);
		SendClientMessageEx(playerid, COLOR_GREEN,"___________________________________________________________________________________________________");
		#endif
	}
	return 1;
}

CMD:netstats(playerid, params[]) {
	if(gPlayerLogged{playerid} != 0) {
		new strStats[401], szTitle[64];
		GetPlayerNetworkStats(playerid, strStats, sizeof(strStats));
		format(szTitle, sizeof(szTitle), "Network Stats (ID: %d) - %s", playerid, GetPlayerNameEx(playerid));
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, szTitle, strStats, "Close", "");
	}
	return 1;
}

CMD:anetstats(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] < 2) {
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
		return 1;
	}

	new giveplayerid, strStats[401], szTitle[64];
	if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /anetstats [player]");

	if(gPlayerLogged{giveplayerid} != 0) {
		GetPlayerNetworkStats(giveplayerid, strStats, sizeof(strStats));
		format(szTitle, sizeof(szTitle), "Network Stats (ID: %d) - %s", giveplayerid, GetPlayerNameEx(giveplayerid));
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, szTitle, strStats, "Close", "");
	}
	return 1;
}

// Testing Commands
CMD:playsound(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 1337) return SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use this command!");

	new id, soundid;

	if(sscanf(params, "ud", id, soundid))
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /playsound [player] [soundid]");
        return 1;
	}
	else
	{
		PlayerPlaySound(id, soundid, 0, 0, 0);
	}
	return 1;
}

CMD:aobject(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 1337) return SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use this command!");

	new id, objectid, bone, Float:offsetx, Float:offsety, Float:offsetz, Float:rotx, Float:roty, Float:rotz, Float:scalex, Float:scaley, Float:scalez;

	if(sscanf(params, "uddfffffffff", id, objectid, bone, offsetx, offsety, offsetz, rotx, roty, rotz, scalex, scaley, scalez))
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /aobject [player] [objectid] [bone] [offx] [offy] [offz] [rotx] [roty] [rotz] [scax] [scay] [scaz]");
        return 1;
	}
	else
	{
		if(IsPlayerAttachedObjectSlotUsed(id, 8)) RemovePlayerAttachedObject(id, 8);
		SetPlayerAttachedObject(id, 8, objectid, bone, offsetx, offsety, offsetz, rotx, roty, rotz, scalex, scaley, scalez);
		new string[256];
		format(string, sizeof(string), "%s has given %s(%d) object ID %d with /aobject", GetPlayerNameEx(playerid), GetPlayerNameEx(id), GetPlayerSQLId(id), objectid);
		Log("logs/toys.log", string);
	}
	return 1;
}

CMD:robject(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 1337) return SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use this command!");

	new id;
	if(sscanf(params, "u", id))
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /robject [player]");
        return 1;
	}
	else
	{
		if(IsPlayerAttachedObjectSlotUsed(id, 9)) RemovePlayerAttachedObject(id, 9);
	}
	return 1;
}

CMD:wepreset(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 3)
	{
	    new string[75 + (MAX_PLAYER_NAME * 2)], giveplayerid;
		if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /wepreset [player]");
		if(IsPlayerConnected(giveplayerid))
		{
		    if(PlayerInfo[giveplayerid][pWRestricted] > 0)
		    {
		        PlayerInfo[giveplayerid][pWRestricted] = 0;
		        format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s reset %s's (ID:%d) weapon restriction timer.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), giveplayerid);
		        ABroadCast(COLOR_YELLOW, string, 2);
		    }
		    else
		    {
		        SendClientMessageEx(playerid, COLOR_WHITE, "Their weapons are not restricted!");
			}
		}
		else
		{
		    SendClientMessageEx(playerid, COLOR_GRAD2, "Invalid player specified.");
		}
	}
	return 1;
}

CMD:watch(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 2)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You're not authorised to use this command.");
		return 1;
	}
	if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "You can not do this while spectating.");
		return 1;
	}
	if(isnull(params))
	{
	    // VIP gold room needs to be fixed
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /watch [location] (or /watch off)");
		SendClientMessageEx(playerid, COLOR_GRAD2, "General locations: gym, lspd, allsaints, countygen, grove, tgb, bank, motel, cityhall, mall");
        SendClientMessageEx(playerid, COLOR_GRAD2, "VIP locations: lsvip, sfvip, loungeview1, loungeview2, goldlounge, vipgarage");
        SendClientMessageEx(playerid, COLOR_GRAD2, "Point locations: mp1, df, mf1, dh, mp2, cl, mf2, sfd, ffc");
	}

	new Float: Pos[3], int, vw;

	// SAVING INITIAL POSITION TO TELEPORT BACK TO LATER
	if(!(strcmp(params, "off", true) == 0) && GetPVarFloat(playerid, "WatchLastx") == 0 && GetPVarFloat(playerid, "WatchLasty") == 0 && GetPVarFloat(playerid, "WatchLastz") == 0 && GetPVarInt(playerid, "WatchLastVW") == 0 && GetPVarInt(playerid, "WatchLastInt") == 0)
	{
	GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
	vw = GetPlayerVirtualWorld(playerid);
	int = GetPlayerInterior(playerid);

	SetPVarFloat(playerid, "WatchLastx", Pos[0]);
	SetPVarFloat(playerid, "WatchLasty", Pos[1]);
	SetPVarFloat(playerid, "WatchLastz", Pos[2]);
	SetPVarInt(playerid, "WatchLastInt", int);
	SetPVarInt(playerid, "WatchLastVW", vw);
	}

	// GENERAL LOCATIONS
	if(strcmp(params, "gym", true) == 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You are now watching Ganton gym.");
		SetPlayerPos(playerid, 2212.61, -1730.57, -80.0);
		SetPlayerInterior(playerid, 0);
		PlayerInfo[playerid][pInt] = 0;
		SetPlayerVirtualWorld(playerid, 0);
		PlayerInfo[playerid][pVW] = 0;
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 2208.67, -1733.71, 27.48);
		SetPlayerCameraLookAt(playerid, 2225.25, -1723.1, 13.56);
	}
	else if(strcmp(params, "lspd", true) == 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You are now watching the LSPD.");
		SetPlayerPos(playerid, 1504.23, -1700.17, -80.0);
		SetPlayerInterior(playerid, 0);
		PlayerInfo[playerid][pInt] = 0;
		SetPlayerVirtualWorld(playerid, 0);
		PlayerInfo[playerid][pVW] = 0;
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 1500.21, -1691.75, 38.38);
		SetPlayerCameraLookAt(playerid, 1541.46, -1676.17, 13.55);
	}
	else if(strcmp(params, "allsaints", true) == 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You are now watching All Saints General Hospital.");
		SetPlayerPos(playerid, 1201.12, -1324, -80.0);
		SetPlayerInterior(playerid, 0);
		PlayerInfo[playerid][pInt] = 0;
		SetPlayerVirtualWorld(playerid, 0);
		PlayerInfo[playerid][pVW] = 0;
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 1207.39, -1294.71, 24.61);
		SetPlayerCameraLookAt(playerid, 1181.72, -1322.65, 13.58);
	}
	else if(strcmp(params, "countygen", true) == 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You are now watching County General Hospital.");
		SetPlayerPos(playerid, 1989.24, -1461.38, -80.0);
		SetPlayerInterior(playerid, 0);
		PlayerInfo[playerid][pInt] = 0;
		SetPlayerVirtualWorld(playerid, 0);
		PlayerInfo[playerid][pVW] = 0;
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 1981.79, -1461.55, 31.93);
		SetPlayerCameraLookAt(playerid, 2021.23, -1427.48, 13.97);
	}
	else if(strcmp(params, "grove", true) == 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You are now watching Grove Street.");
		SetPlayerPos(playerid, 2489.09, -1669.88, -80.0);
		SetPlayerInterior(playerid, 0);
		PlayerInfo[playerid][pInt] = 0;
		SetPlayerVirtualWorld(playerid, 0);
		PlayerInfo[playerid][pVW] = 0;
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 2459.82, -1652.68, 26.45);
		SetPlayerCameraLookAt(playerid, 2489.09, -1669.88, 13.34);
	}
	else if(strcmp(params, "tgb", true) == 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You are now watching Ten Green Bottles.");
		SetPlayerPos(playerid, 2319.09, -1650.90, -80.0);
		SetPlayerInterior(playerid, 0);
		PlayerInfo[playerid][pInt] = 0;
		SetPlayerVirtualWorld(playerid, 0);
		PlayerInfo[playerid][pVW] = 0;
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 2336.31, -1664.76, 24.98);
		SetPlayerCameraLookAt(playerid, 2319.09, -1650.90, 14.16);
	}
	else if(strcmp(params, "bank", true) == 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You are now watching the Los Santos bank.");
		SetPlayerPos(playerid, 1466.24, -1023.05, -80.0);
		SetPlayerInterior(playerid, 0);
		PlayerInfo[playerid][pInt] = 0;
		SetPlayerVirtualWorld(playerid, 0);
		PlayerInfo[playerid][pVW] = 0;
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 1502.28, -1044.47, 31.19);
		SetPlayerCameraLookAt(playerid, 1466.24, -1023.05, 23.83);
	}
	else if(strcmp(params, "motel", true) == 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You are now watching Jefferson motel.");
		SetPlayerPos(playerid, 2215.73, -1163.39, -80.0);
		SetPlayerInterior(playerid, 0);
		PlayerInfo[playerid][pInt] = 0;
		SetPlayerVirtualWorld(playerid, 0);
		PlayerInfo[playerid][pVW] = 0;
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 2203.05, -1152.81, 37.03);
		SetPlayerCameraLookAt(playerid, 2215.73, -1163.39, 25.73);
	}
	else if(strcmp(params, "cityhall", true) == 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You are now watching Los Santos City Hall.");
		SetPlayerPos(playerid, 1478.936035, -1746.446655, -80.0);
		SetPlayerInterior(playerid, 0);
		PlayerInfo[playerid][pInt] = 0;
		SetPlayerVirtualWorld(playerid, 0);
		PlayerInfo[playerid][pVW] = 0;
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 1447.461669, -1717.788085, 44.047473);
		SetPlayerCameraLookAt(playerid, 1478.936035, -1746.446655, 14.347633);
	}
	else if(strcmp(params, "mall", true) == 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You are now watching Los Santos Mall.");
		SetPlayerPos(playerid, 1127.245483, -1451.613891, -80.0);
		SetPlayerInterior(playerid, 0);
		PlayerInfo[playerid][pInt] = 0;
		SetPlayerVirtualWorld(playerid, 0);
		PlayerInfo[playerid][pVW] = 0;
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 1092.614868, -1499.197998, 42.018226);
		SetPlayerCameraLookAt(playerid, 1127.245483, -1451.613891, 15.796875);
	}


	// VIP LOCATIONS
	else if(strcmp(params, "lsvip", true) == 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You are now watching the Los Santos VIP entrance.");
		SetPlayerPos(playerid, 1809.888427, -1570.615844, -80.0);
		SetPlayerInterior(playerid, 0);
		PlayerInfo[playerid][pInt] = 0;
		SetPlayerVirtualWorld(playerid, 0);
		PlayerInfo[playerid][pVW] = 0;
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 1861.195190, -1533.169677, 33.800296);
		SetPlayerCameraLookAt(playerid, 1809.888427, -1570.615844, 13.465585);
	}
	else if(strcmp(params, "sfvip", true) == 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You are now watching the San Fierro VIP entrance.");
		SetPlayerPos(playerid, -2437.302490, 508.727020, -80.0);
		SetPlayerInterior(playerid, 0);
		PlayerInfo[playerid][pInt] = 0;
		SetPlayerVirtualWorld(playerid, 0);
		PlayerInfo[playerid][pVW] = 0;
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, -2410.812011, 488.762603, 40.148445);
		SetPlayerCameraLookAt(playerid, -2437.302490, 508.727020, 29.933441);
	}
	else if(strcmp(params, "loungeview1", true) == 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You are now watching the VIP Lounge.");
		SetPlayerPos(playerid, 2526.647949, 1431.128417, 7754.650390);
		SetPlayerInterior(playerid, 1);
		PlayerInfo[playerid][pInt] = 1;
		SetPlayerVirtualWorld(playerid, 0);
		PlayerInfo[playerid][pVW] = 0;
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 2572.895996, 1424.583007, 7705.613769);
		SetPlayerCameraLookAt(playerid, 2555.148681, 1407.475708, 7699.584472);
	}
	else if(strcmp(params, "loungeview2", true) == 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You are now watching the VIP Lounge.");
		SetPlayerPos(playerid, 2526.647949, 1431.128417, 7754.650390);
		SetPlayerInterior(playerid, 1);
		PlayerInfo[playerid][pInt] = 1;
		SetPlayerVirtualWorld(playerid, 0);
		PlayerInfo[playerid][pVW] = 0;
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 2488.598388, 1419.864868, 7703.525390);
		SetPlayerCameraLookAt(playerid, 2519.420410, 1418.585693, 7697.718261);
	}
	else if(strcmp(params, "goldlounge", true) == 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You are now watching the VIP Gold+ Lounge.");
  		SetPlayerPos(playerid, 2864.634277, 2290.584960, 1272.007568);
		SetPlayerInterior(playerid, 1);
		PlayerInfo[playerid][pInt] = 1;
		SetPlayerVirtualWorld(playerid, 0);
		PlayerInfo[playerid][pVW] = 0;
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid,2787.102050, 2392.162841, 1243.898681);
		SetPlayerCameraLookAt(playerid,2801.281982, 2404.575683, 1240.531127);
	}
	else if(strcmp(params, "vipgarage", true) == 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You are now watching the VIP Garage.");
  		SetPlayerPos(playerid, -4412.440429, 867.361694, -80.0);
		SetPlayerInterior(playerid, 0);
		PlayerInfo[playerid][pInt] = 0;
		SetPlayerVirtualWorld(playerid, 0);
		PlayerInfo[playerid][pVW] = 0;
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, -4437.200683, 870.038269, 989.548767);
		SetPlayerCameraLookAt(playerid, -4412.440429, 867.361694, 986.708435);
	}


	// Points (mp1, df, mf1, dh, mp2, cl, mf2, sfd, ffc)
	else if(strcmp(params, "mp1", true) == 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You are now watching Materials Pickup 1.");
  		SetPlayerPos(playerid, 1423.773437, -1320.386962, -80.0);
		SetPlayerInterior(playerid, 0);
		PlayerInfo[playerid][pInt] = 0;
		SetPlayerVirtualWorld(playerid, 0);
		PlayerInfo[playerid][pVW] = 0;
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 1411.689941, -1352.002929, 24.477527);
		SetPlayerCameraLookAt(playerid, 1423.773437, -1320.386962, 13.554687);
	}
	else if(strcmp(params, "df", true) == 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You are now watching Drug Factory.");
  		SetPlayerPos(playerid, 2206.402587, 1582.398681, -80.0);
		SetPlayerInterior(playerid, 1);
		PlayerInfo[playerid][pInt] = 1;
		SetPlayerVirtualWorld(playerid, 0);
		PlayerInfo[playerid][pVW] = 0;
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 2222.844482, 1590.667968, 1002.612915);
		SetPlayerCameraLookAt(playerid, 2206.402587, 1582.398681, 999.976562);
	}
	else if(strcmp(params, "mf1", true) == 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You are now watching Materials Factory 1.");
  		SetPlayerPos(playerid, 2172.315185, -2263.781250, -80.0);
		SetPlayerInterior(playerid, 0);
		PlayerInfo[playerid][pInt] = 0;
		SetPlayerVirtualWorld(playerid, 0);
		PlayerInfo[playerid][pVW] = 0;
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 2206.363769, -2262.568359, 24.240808);
		SetPlayerCameraLookAt(playerid, 2172.315185, -2263.781250, 13.335824);
	}
	else if(strcmp(params, "dh", true) == 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You are now watching the Drug House.");
  		SetPlayerPos(playerid, 323.577026, 1118.344116, -80.0);
		SetPlayerInterior(playerid, 5);
		PlayerInfo[playerid][pInt] = 5;
		SetPlayerVirtualWorld(playerid, 371);
		PlayerInfo[playerid][pVW] = 371;
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 316.387817, 1123.946289, 1085.046020);
		SetPlayerCameraLookAt(playerid, 323.577026, 1118.344116, 1083.882812);
	}
	else if(strcmp(params, "mp2", true) == 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You are now watching Materials Pickup 2.");
  		SetPlayerPos(playerid, 2390.212402, -2008.328491, -80.0);
		SetPlayerInterior(playerid, 0);
		PlayerInfo[playerid][pInt] = 0;
		SetPlayerVirtualWorld(playerid, 0);
		PlayerInfo[playerid][pVW] = 0;
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 2410.285644, -2013.919433, 21.716161);
		SetPlayerCameraLookAt(playerid, 2390.212402, -2008.328491, 13.553703);
	}
	else if(strcmp(params, "cl", true) == 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You are now watching Crack Lab.");
  		SetPlayerPos(playerid, 2346.013916, -1185.367065, -80.0);
		SetPlayerInterior(playerid, 5);
		PlayerInfo[playerid][pInt] = 5;
		SetPlayerVirtualWorld(playerid, 371);
		PlayerInfo[playerid][pVW] = 371;
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 2342.012207, -1180.969848, 1029.412353);
		SetPlayerCameraLookAt(playerid, 2346.013916, -1185.367065, 1027.976562);
	}
	else if(strcmp(params, "mf2", true) == 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You are now watching Materials Factory 2.");
  		SetPlayerPos(playerid, 2282.298828, -1110.143798, -80.0);
		SetPlayerInterior(playerid, 0);
		PlayerInfo[playerid][pInt] = 0;
		SetPlayerVirtualWorld(playerid, 0);
		PlayerInfo[playerid][pVW] = 0;
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, 2306.088623, -1133.968627, 52.929584);
		SetPlayerCameraLookAt(playerid, 2282.298828, -1110.143798, 37.976562);
	}
	else if(strcmp(params, "sfd", true) == 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You are now watching the San Fierro Docks.");
  		SetPlayerPos(playerid, -1576.488159, 50.301193, -80.0);
		SetPlayerInterior(playerid, 0);
		PlayerInfo[playerid][pInt] = 0;
		SetPlayerVirtualWorld(playerid, 0);
		PlayerInfo[playerid][pVW] = 0;
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, -1569.082153, 96.206344, 34.091339);
		SetPlayerCameraLookAt(playerid, -1576.488159, 50.301193, 17.328125);
	}
	else if(strcmp(params, "ffc", true) == 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You are now watching Fossil Fuel Company.");
  		SetPlayerPos(playerid, -2139.215087, -248.235076, -80.0);
		SetPlayerInterior(playerid, 0);
		PlayerInfo[playerid][pInt] = 0;
		SetPlayerVirtualWorld(playerid, 0);
		PlayerInfo[playerid][pVW] = 0;
		TogglePlayerControllable(playerid,0);
		SetPlayerCameraPos(playerid, -2170.527832, -246.948257, 40.965312);
		SetPlayerCameraLookAt(playerid, -2139.215087, -248.235076, 36.515625);
	}


	// OFF
	else if(strcmp(params, "off", true) == 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You are no longer watching any area.");
		SetPlayerPos(playerid, GetPVarFloat(playerid, "WatchLastx"), GetPVarFloat(playerid, "WatchLasty"), GetPVarFloat(playerid, "WatchLastz"));
		SetPlayerVirtualWorld(playerid, GetPVarInt(playerid, "WatchLastVW"));
		PlayerInfo[playerid][pVW] = GetPVarInt(playerid, "WatchLastVW");
		SetPlayerInterior(playerid, GetPVarInt(playerid, "WatchLastInt"));
		PlayerInfo[playerid][pInt] = GetPVarInt(playerid, "WatchLastInt");
		SetPlayerFacingAngle(playerid, 270.0);
		SetCameraBehindPlayer(playerid);
		TogglePlayerControllable(playerid,1);
		DeletePVar(playerid,"WatchLastx");
		DeletePVar(playerid,"WatchLasty");
		DeletePVar(playerid,"WatchLastz");
		DeletePVar(playerid,"WatchLastVW");
		DeletePVar(playerid,"WatchLastInt");
	}
	return 1;
}

CMD:goto(playerid, params[])
{
    if(EventKernel[EventCreator] == playerid || PlayerInfo[playerid][pAdmin] >= 2)
	{
		if(isnull(params))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /goto [location]");
			SendClientMessageEx(playerid, COLOR_GRAD1, "Locations 1: LS,SF,LV,RC,ElQue,Bayside,LSVIP,SFVIP,LVVIP,Famed,MHC,stadium1");
			SendClientMessageEx(playerid, COLOR_GRAD2, "Locations 2: stadium2,stadium3,stadium4,int1,mark,mark2,sfairport,dillimore,cave,doc,bank,mall,allsaints");
			SendClientMessageEx(playerid, COLOR_GRAD3, "Locations 3: countygen,cracklab,gym,rodeo,flint,idlewood,fbi,island,demorgan,doc,icprison,oocprison");
			SendClientMessageEx(playerid, COLOR_GRAD4, "Locations 4: garagesm,garagemed,garagelg,garagexlg,glenpark,palomino,nggshop");
			return 1;
		}
		if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
		{
			SendClientMessageEx(playerid, COLOR_GRAD2, "You can not do this while spectating.");
			return 1;
		}
		if(strcmp(params,"glenpark",true) == 0 || strcmp(params,"gp",true) == 0)
		{
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 2012.500366, -1264.768554, 23.547389);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[playerid] = 0.0;
			}
			else
			{
				SetPlayerPos(playerid, 1986.69, -1300.49, 25.03);
			}
			SendClientMessageEx(playerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(playerid,0);
			PlayerInfo[playerid][pInt] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;
		}
		if(strcmp(params,"palomino",true) == 0 || strcmp(params,"pc",true) == 0)
		{
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 2229.485351, -63.457298, 26.134857);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[playerid] = 0.0;
			}
			else
			{
				SetPlayerPos(playerid, 2231.578613, -48.729660, 26.484375);
			}
			SendClientMessageEx(playerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(playerid,0);
			PlayerInfo[playerid][pInt] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;
		}
		if(strcmp(params,"nggshop",true) == 0)
		{
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 2930.920410, -1429.603637, 10.675988);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[playerid] = 0.0;
			}
			else
			{
				SetPlayerPos(playerid, 2957.967041, -1459.404541, 10.809198);
			}
			SendClientMessageEx(playerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(playerid,0);
			PlayerInfo[playerid][pInt] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;
		}
		if(strcmp(params,"ls",true) == 0)
		{
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 1529.6,-1691.2,13.3);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[playerid] = 0.0;
			}
			else
			{
				SetPlayerPos(playerid, 1529.6,-1691.2,13.3);
			}
			SendClientMessageEx(playerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(playerid,0);
			PlayerInfo[playerid][pInt] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;
		}
		else if(strcmp(params,"garagexlg",true) == 0)
		{
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar,1111.0139,1546.9510,5290.2793);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[playerid] = 0.0;
			}
			else
			{
				SetPlayerPos(playerid, 1111.0139,1546.9510,5290.2793);
			}
			SendClientMessageEx(playerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(playerid,0);
			PlayerInfo[playerid][pInt] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;
		}
		else if(strcmp(params,"garagelg",true) == 0)
		{
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar,1192.8501,1540.0295,5290.2871);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[playerid] = 0.0;
			}
			else
			{
				SetPlayerPos(playerid, 1192.8501,1540.0295,5290.2871);
			}
			SendClientMessageEx(playerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(playerid,0);
			PlayerInfo[playerid][pInt] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;
		}
		else if(strcmp(params,"garagemed",true) == 0)
		{
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar,1069.1473,1582.1029,5290.2529);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[playerid] = 0.0;
			}
			else
			{
				SetPlayerPos(playerid, 1069.1473,1582.1029,5290.2529);
			}
			SendClientMessageEx(playerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(playerid,0);
			PlayerInfo[playerid][pInt] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;
		}
		else if(strcmp(params,"garagesm",true) == 0)
		{
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar,1198.1407,1589.2153,5290.2871);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[playerid] = 0.0;
			}
			else
			{
				SetPlayerPos(playerid, 1198.1407,1589.2153,5290.2871);
			}
			SendClientMessageEx(playerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(playerid,0);
			PlayerInfo[playerid][pInt] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;
		}
		else if(strcmp(params,"cave",true) == 0)
		{
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, -1993.01, -1580.44, 86.39);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[playerid] = 0.0;
			}
			else
			{
				SetPlayerPos(playerid, -1993.01, -1580.44, 86.39);
			}
			SendClientMessageEx(playerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(playerid,0);
			PlayerInfo[playerid][pInt] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;
		}
		else if(strcmp(params,"sfairport",true) == 0)
		{
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, -1412.5375,-301.8998,14.1411);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[playerid] = 0.0;
			}
			else
			{
				SetPlayerPos(playerid, -1412.5375,-301.8998,14.1411);
			}
			SendClientMessageEx(playerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(playerid,0);
			PlayerInfo[playerid][pInt] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;
		}
		else if(strcmp(params,"sf",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, -1605.0,720.0,12.0);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[playerid] = 0.0;
			}
			else
			{
				SetPlayerPos(playerid, -1605.0,720.0,12.0);
			}
			SendClientMessageEx(playerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(playerid,0);
			PlayerInfo[playerid][pInt] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;
		}
		else if(strcmp(params,"lv",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 1699.2, 1435.1, 10.7);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[playerid] = 0.0;
			}
			else
			{
				SetPlayerPos(playerid, 1699.2,1435.1, 10.7);
			}
			SendClientMessageEx(playerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(playerid,0);
			PlayerInfo[playerid][pInt] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;

		}
		else if(strcmp(params,"island",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, -1081.0,4297.9,4.4);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[playerid] = 0.0;
			}
			else
			{
				SetPlayerPos(playerid, -1081.0,4297.9,4.4);
			}
			SendClientMessageEx(playerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(playerid,0);
			PlayerInfo[playerid][pInt] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;

		}
		else if(strcmp(params,"cracklab",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 2348.2871, -1146.8298, 27.3183);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[playerid] = 0.0;
			}
			else
			{
				SetPlayerPos(playerid, 2348.2871, -1146.8298, 27.3183);
			}
			SendClientMessageEx(playerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(playerid,0);
			PlayerInfo[playerid][pInt] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;

		}
		else if(strcmp(params,"bank",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 1487.91, -1030.60, 23.66);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[playerid] = 0.0;
			}
			else
			{
				SetPlayerPos(playerid, 1487.91, -1030.60, 23.66);
			}
			SendClientMessageEx(playerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(playerid,0);
			PlayerInfo[playerid][pInt] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;

		}
		else if(strcmp(params,"allsaints",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 1192.78, -1292.68, 13.38);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[playerid] = 0.0;
			}
			else
			{
				SetPlayerPos(playerid, 1192.78, -1292.68, 13.38);
			}
			SendClientMessageEx(playerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(playerid,0);
			PlayerInfo[playerid][pInt] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;

		}
		else if(strcmp(params,"countygen",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 2000.05, -1409.36, 16.99);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[playerid] = 0.0;
			}
			else
			{
				SetPlayerPos(playerid, 2000.05, -1409.36, 16.99);
			}
			SendClientMessageEx(playerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(playerid,0);
			PlayerInfo[playerid][pInt] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;

		}
		else if(strcmp(params,"gym",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 2227.60, -1674.89, 14.62);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[playerid] = 0.0;
			}
			else
			{
				SetPlayerPos(playerid, 2227.60, -1674.89, 14.62);
			}
			SendClientMessageEx(playerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(playerid,0);
			PlayerInfo[playerid][pInt] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;

   		}
		else if(strcmp(params,"fbi",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 344.77,-1526.08,33.28);
				fVehSpeed[playerid] = 0.0;
			}
			else
			{
				SetPlayerPos(playerid, 344.77,-1526.08,33.28);
			}
			SendClientMessageEx(playerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(playerid,0);
			PlayerInfo[playerid][pInt] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;

		}
  		else if(strcmp(params,"rc",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 1253.70, 343.73, 19.41);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[playerid] = 0.0;
			}
			else
			{
				SetPlayerPos(playerid, 1253.70, 343.73, 19.41);
			}
			SendClientMessageEx(playerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(playerid,0);
			PlayerInfo[playerid][pInt] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;

   		}
     	else if(strcmp(params,"lsvip",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 1810.39, -1601.15, 13.54);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[playerid] = 0.0;
			}
			else
			{
				SetPlayerPos(playerid, 1810.39, -1601.15, 13.54);
			}
			SendClientMessageEx(playerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(playerid,0);
			PlayerInfo[playerid][pInt] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;
		}
     	else if(strcmp(params,"sfvip",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, -2433.63, 511.45, 30.38);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[playerid] = 0.0;
			}
			else
			{
				SetPlayerPos(playerid, -2433.63, 511.45, 30.38);
			}
			SendClientMessageEx(playerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(playerid,0);
			PlayerInfo[playerid][pInt] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;
		}
       	else if(strcmp(params,"lvvip",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 1875.7731, 1366.0796, 16.8998);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[playerid] = 0.0;
			}
			else
			{
				SetPlayerPos(playerid, 1875.7731, 1366.0796, 16.8998);
			}
			SendClientMessageEx(playerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(playerid,0);
			PlayerInfo[playerid][pInt] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;
		}
		else if(strcmp(params,"demorgan",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 112.67, 1917.55, 18.72);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[playerid] = 0.0;
			}
			else
			{
				SetPlayerPos(playerid, 112.67, 1917.55, 18.72);
			}
			SendClientMessageEx(playerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(playerid,0);
			PlayerInfo[playerid][pInt] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;

		}
		else if(strcmp(params,"icprison",true) == 0)
		{
			Player_StreamPrep(playerid, 558.1121,1458.6663,6000.4712, FREEZE_TIME);
			SetPlayerInterior(playerid,1);
			PlayerInfo[playerid][pInt] = 1;
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;
			SendClientMessageEx(playerid, COLOR_GRAD1, "   You have been teleported!");
		}
		else if(strcmp(params, "doc", true) == 0)
		{
			SetPlayerPos(playerid, -2029.2322, -78.3302, 35.3203);
			SetPlayerInterior(playerid, 0);
			PlayerInfo[playerid][pInt] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;
			SendClientMessageEx(playerid, COLOR_GRAD1, "   You have been teleported!");
		}
		else if(strcmp(params,"oocprison",true) == 0)
		{
			Player_StreamPrep(playerid, -1158.285644, 2894.152343, 9993.131835, FREEZE_TIME);
			SetPlayerInterior(playerid,1);
			PlayerInfo[playerid][pInt] = 1;
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;
			SendClientMessageEx(playerid, COLOR_GRAD1, "   You have been teleported!");

		}
		else if(strcmp(params,"stadium1",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, -1424.93, -664.59, 1059.86);
				LinkVehicleToInterior(tmpcar, 4);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[playerid] = 0.0;
			}
			else
			{
				SetPlayerPos(playerid, -1424.93, -664.59, 1059.86);
			}
			SendClientMessageEx(playerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(playerid,4);
			PlayerInfo[playerid][pInt] = 4;
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;

		}
		else if(strcmp(params,"stadium2",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, -1395.96, -208.20, 1051.28);
				LinkVehicleToInterior(tmpcar, 7);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[playerid] = 0.0;
			}
			else
			{
				SetPlayerPos(playerid, -1395.96, -208.20, 1051.28);
			}
			SendClientMessageEx(playerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(playerid,7);
			PlayerInfo[playerid][pInt] = 7;
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;

		}
		else if(strcmp(params,"stadium3",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, -1410.72, 1591.16, 1052.53);
				LinkVehicleToInterior(tmpcar, 14);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[playerid] = 0.0;
			}
			else
			{
				SetPlayerPos(playerid, -1410.72, 1591.16, 1052.53);
			}
			SendClientMessageEx(playerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(playerid,14);
			PlayerInfo[playerid][pInt] = 14;
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;

		}
		else if(strcmp(params,"stadium4",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, -1394.20, 987.62, 1023.96);
				LinkVehicleToInterior(tmpcar, 15);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[playerid] = 0.0;
    		}
			else
			{
				SetPlayerPos(playerid, -1394.20, 987.62, 1023.96);
			}
			SendClientMessageEx(playerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(playerid,15);
			PlayerInfo[playerid][pInt] = 15;
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;

		}
		else if(strcmp(params,"int1",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 1416.107000,0.268620,1000.926000);
				LinkVehicleToInterior(tmpcar, 1);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[playerid] = 0.0;
			}
			else
			{
				SetPlayerPos(playerid, 1416.107000,0.268620,1000.926000);
			}
			SendClientMessageEx(playerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(playerid,1);
			PlayerInfo[playerid][pInt] = 1;
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;

		}
		else if(strcmp(params,"mark",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, GetPVarFloat(playerid, "tpPosX1"), GetPVarFloat(playerid, "tpPosY1"), GetPVarFloat(playerid, "tpPosZ1"));
				LinkVehicleToInterior(tmpcar, GetPVarInt(playerid, "tpInt1"));
			}
			else
			{
				SetPlayerPos(playerid, GetPVarFloat(playerid, "tpPosX1"), GetPVarFloat(playerid, "tpPosY1"), GetPVarFloat(playerid, "tpPosZ1"));
			}
			SetPlayerInterior(playerid, GetPVarInt(playerid, "tpInt1"));
			SendClientMessageEx(playerid, COLOR_GRAD1, "   You have been teleported!");
		}
		else if(strcmp(params,"mark2",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, GetPVarFloat(playerid, "tpPosX2"), GetPVarFloat(playerid, "tpPosY2"), GetPVarFloat(playerid, "tpPosZ2"));
				LinkVehicleToInterior(tmpcar, GetPVarInt(playerid, "tpInt2"));
			}
			else
			{
				SetPlayerPos(playerid, GetPVarFloat(playerid, "tpPosX2"), GetPVarFloat(playerid, "tpPosY2"), GetPVarFloat(playerid, "tpPosZ2"));
			}
			SetPlayerInterior(playerid, GetPVarInt(playerid, "tpInt2"));
			SendClientMessageEx(playerid, COLOR_GRAD1, "   You have been teleported!");
		}
		else if(strcmp(params,"mall",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 1133.71,-1464.52,15.77);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[playerid] = 0.0;
			}
			else
			{
				SetPlayerPos(playerid, 1133.71,-1464.52,15.77);
			}
			SendClientMessageEx(playerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(playerid,0);
			PlayerInfo[playerid][pInt] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;

		}
		else if(strcmp(params,"elque",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, -1446.5997,2608.4478,55.8359);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[playerid] = 0.0;
			}
			else
			{
				SetPlayerPos(playerid, -1446.5997,2608.4478,55.8359);
			}
			SendClientMessageEx(playerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(playerid,0);
			PlayerInfo[playerid][pInt] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;

		}
		else if(strcmp(params,"bayside",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, -2465.1348,2333.6572,4.8359);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[playerid] = 0.0;
			}
			else
			{
				SetPlayerPos(playerid, -2465.1348,2333.6572,4.8359);
			}
			SendClientMessageEx(playerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(playerid,0);
			PlayerInfo[playerid][pInt] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;

		}
		else if(strcmp(params,"dillimore",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 634.9734, -594.6402, 16.3359);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[playerid] = 0.0;
			}
			else
			{
				SetPlayerPos(playerid, 634.9734, -594.6402, 16.3359);
			}
			SendClientMessageEx(playerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(playerid,0);
			PlayerInfo[playerid][pInt] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;
		}
		else if(strcmp(params,"famed",true) == 0)
		{
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 1020.29, -1129.06, 23.87);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[playerid] = 0.0;
			}
			else
			{
				SetPlayerPos(playerid, 1020.29, -1129.06, 23.87);
			}
			SendClientMessageEx(playerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(playerid,0);
			PlayerInfo[playerid][pInt] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;
		}
		else if(strcmp(params,"rodeo",true) == 0)
		{
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 587.0106,-1238.3374,17.8049);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[playerid] = 0.0;
			}
			else
			{
				SetPlayerPos(playerid, 587.0106,-1238.3374,17.8049);
			}
			SendClientMessageEx(playerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(playerid,0);
			PlayerInfo[playerid][pInt] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;
		}
		else if(strcmp(params,"flint",true) == 0)
		{
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, -108.1058,-1172.5293,2.8906);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[playerid] = 0.0;
			}
			else
			{
				SetPlayerPos(playerid, -108.1058,-1172.5293,2.8906);
			}
			SendClientMessageEx(playerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(playerid,0);
			PlayerInfo[playerid][pInt] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;
		}
		else if(strcmp(params,"idlewood",true) == 0)
		{
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 1955.1357,-1796.8896,13.5469);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[playerid] = 0.0;
			}
			else
			{
				SetPlayerPos(playerid, 1955.1357,-1796.8896,13.5469);
			}
			SendClientMessageEx(playerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(playerid,0);
			PlayerInfo[playerid][pInt] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;
		}
		else if(strcmp(params,"mhc",true) == 0)
		{
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				Player_StreamPrep(playerid, 1700.2124, 1461.1771, 1145.7766, FREEZE_TIME);
				SetVehiclePos(tmpcar, 1700.2124, 1461.1771, 1145.7766);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[playerid] = 0.0;
			}
			else
			{
				Player_StreamPrep(playerid, 1649.7531, 1463.1614, 1151.9687, FREEZE_TIME);
			}
			SendClientMessageEx(playerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(playerid,0);
			PlayerInfo[playerid][pInt] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;
		}
	}
	else if(PlayerInfo[playerid][pWatchdog] >= 2)
	{
		if(isnull(params)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /goto (MHC/LV)");
		if(strcmp(params,"mhc",true) == 0)
		{
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				Player_StreamPrep(playerid, 1700.2124, 1461.1771, 1145.7766, FREEZE_TIME);
				SetVehiclePos(tmpcar, 1700.2124, 1461.1771, 1145.7766);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[playerid] = 0.0;
			}
			else
			{
				Player_StreamPrep(playerid, 1649.7531, 1463.1614, 1151.9687, FREEZE_TIME);
			}
			SendClientMessageEx(playerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(playerid,0);
			PlayerInfo[playerid][pInt] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;
		}
		else if(strcmp(params,"lv",true) == 0)
		{
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 1699.2, 1435.1, 10.7);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[playerid] = 0.0;
			}
			else
			{
				SetPlayerPos(playerid, 1699.2,1435.1, 10.7);
			}
			SendClientMessageEx(playerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(playerid,0);
			PlayerInfo[playerid][pInt] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;

		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	}
	return 1;
}

CMD:sendto(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 2)
	{
		new string[128], location[32], giveplayerid;
		if(sscanf(params, "s[32]u", location, giveplayerid))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /sendto [location] [player]");
			SendClientMessageEx(playerid, COLOR_GRAD1, "Locations 1: LS,SF,LV,RC,ElQue,Bayside,LSVIP,SFVIP,LVVIP,MHC,Famed,stadium1");
			SendClientMessageEx(playerid, COLOR_GRAD2, "Locations 2: stadium2,stadium3,stadium4,int1,mark,mark2,sfairport,dillimore,cave,doc,bank,mall,allsaints");
			SendClientMessageEx(playerid, COLOR_GRAD3, "Locations 3: countygen,cracklab,gym,rodeo,flint,idlewood,fbi,island,demorgan,doc,icprison,oocprison");
			SendClientMessageEx(playerid, COLOR_GRAD3, "Locations 4: glenpark, palomino, nggshop");
			return 1;
		}
		if(PlayerInfo[giveplayerid][pAdmin] >= PlayerInfo[playerid][pAdmin])
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "You can't perform this action on an equal or higher level administrator.");
			return 1;
		}
		if (!IsPlayerConnected(giveplayerid))
		{
			SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid player specified.");
			return 1;
		}
		if(GetPlayerState(giveplayerid) == PLAYER_STATE_SPECTATING)
		{
			SendClientMessageEx(playerid, COLOR_GRAD2, "This person is currently in spectate mode.");
			return 1;
		}
		if(GetPVarInt(giveplayerid, "IsInArena") >= 0)
		{
		    SetPVarInt(playerid, "tempPBP", giveplayerid);
		    format(string, sizeof(string), "%s (ID: %d) is currently in an active Paintball game.\n\nDo you want to force this player out?", GetPlayerNameEx(giveplayerid), giveplayerid);
		    ShowPlayerDialog(playerid, PBFORCE, DIALOG_STYLE_MSGBOX, "Paintball", string, "Yes", "No");
		    return 1;
		}
		if(strcmp(location,"glenpark",true) == 0 || strcmp(location,"gp",true) == 0)
		{
			if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, 2012.500366, -1264.768554, 23.547389);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, 1986.69, -1300.49, 25.03);
			}
			format(string, sizeof(string), " You have sent %s to Glen Park.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;
		}
		if(strcmp(location,"palomino",true) == 0 || strcmp(location,"pc",true) == 0)
		{
			if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, 2229.485351, -63.457298, 26.134857);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, 2231.578613, -48.729660, 26.484375);
			}
			format(string, sizeof(string), " You have sent %s to Palomino Creek.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;
		}
		if(strcmp(location,"nggshop",true) == 0)
		{
			if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, 2930.920410, -1429.603637, 10.675988);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, 2957.967041, -1459.404541, 10.809198);
			}
			format(string, sizeof(string), " You have sent %s to the NGG Shop.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;
		}
		if(strcmp(location,"ls",true) == 0)
		{
			if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, 1529.6,-1691.2,13.3);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, 1529.6,-1691.2,13.3);
			}
			format(string, sizeof(string), " You have sent %s to Los Santos.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;
		}
		else if(strcmp(location,"cave",true) == 0)
		{
			if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, -1993.01, -1580.44, 86.39);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, -1993.01, -1580.44, 86.39);
			}
			format(string, sizeof(string), " You have sent %s to crate cave.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;
		}
  		else if(strcmp(location, "sfairport", true) == 0)
		{
			if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, -1412.5375, -301.8998, 14.1411);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, -1412.5375,-301.8998,14.1411);
			}
			format(string, sizeof(string), " You have sent %s to SF Airport.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;
		}
		else if(strcmp(location, "doc", true) == 0)
		{
			if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, -2029.2322, -78.3302, 35.3203);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid,-2029.2322, -78.3302, 35.32034);
			}
			format(string, sizeof(string), " You have sent %s to DoC.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;
		}
		else if(strcmp(location, "cracklab", true) == 0)
		{
			if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, 2348.2871, -1146.8298, 27.3183);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, 2348.2871, -1146.8298, 27.3183);
			}
			format(string, sizeof(string), " You have sent %s to Crack Lab.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;
		}
		else if(strcmp(location,"sf",true) == 0)
		{
		 	if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, -1605.0,720.0,12.0);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, -1605.0,720.0,12.0);
			}
			format(string, sizeof(string), " You have sent %s to San Fierro.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;
		}
		else if(strcmp(location,"dillimore",true) == 0)
		{
			if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, 634.9734, -594.6402, 16.3359);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, 634.9734, -594.6402, 16.3359);
			}
			format(string, sizeof(string), " You have sent %s to Dillimore.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;
		}
		else if(strcmp(location,"lv",true) == 0)
		{
		 	if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, 1699.2, 1435.1, 10.7);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, 1699.2,1435.1, 10.7);
			}
			format(string, sizeof(string), " You have sent %s to Las Venturas.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;

		}
		else if(strcmp(location,"island",true) == 0)
		{
		 	if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, -1081.0,4297.9,4.4);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, -1081.0,4297.9,4.4);
			}
			format(string, sizeof(string), " You have sent %s to the Crate Island.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;

		}
		else if(strcmp(location,"bank",true) == 0)
		{
		 	if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, 1487.91, -1030.60, 23.66);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, 1487.91, -1030.60, 23.66);
			}
			format(string, sizeof(string), " You have sent %s to the bank.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;

		}
		else if(strcmp(location,"allsaints",true) == 0)
		{
		 	if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, 1192.78, -1292.68, 13.38);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, 1192.78, -1292.68, 13.38);
			}
			format(string, sizeof(string), " You have sent %s to All Saints.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;

		}
		else if(strcmp(location,"countygen",true) == 0)
		{
		 	if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, 2000.05, -1409.36, 16.99);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, 2000.05, -1409.36, 16.99);
			}
			format(string, sizeof(string), " You have sent %s to County General.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;

		}
		else if(strcmp(location,"gym",true) == 0)
		{
		 	if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, 2227.60, -1674.89, 14.62);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, 2227.60, -1674.89, 14.62);
			}
			format(string, sizeof(string), " You have sent %s to Ganton Gym.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;

   		}
		else if(strcmp(location,"fbi",true) == 0)
		{
		 	if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, 344.77,-1526.08,33.28);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, 344.77,-1526.08,33.28);
			}
			format(string, sizeof(string), " You have sent %s to the FBI HQ.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;

		}
  		else if(strcmp(location,"rc",true) == 0)
		{
		 	if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, 1253.70, 343.73, 19.41);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, 1253.70, 343.73, 19.41);
			}
			format(string, sizeof(string), " You have sent %s to Red County.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;

   		}
     	else if(strcmp(location,"lsvip",true) == 0)
		{
		 	if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, 1810.39, -1601.15, 13.54);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, 1810.39, -1601.15, 13.54);
			}
			format(string, sizeof(string), " You have sent %s to LS VIP.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;
		}
     	else if(strcmp(location,"sfvip",true) == 0)
		{
		 	if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, -2433.63, 511.45, 30.38);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, -2433.63, 511.45, 30.38);
			}
			format(string, sizeof(string), " You have sent %s to SF VIP.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;
		}
       	else if(strcmp(location,"lvvip",true) == 0)
		{
		 	if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, 1875.7731, 1366.0796, 16.8998);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, 1875.7731, 1366.0796, 16.8998);
			}
			format(string, sizeof(string), " You have sent %s to LV VIP.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;
		}
		else if(strcmp(location,"demorgan",true) == 0)
		{
		 	if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, 112.67, 1917.55, 18.72);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, 112.67, 1917.55, 18.72);
			}
			format(string, sizeof(string), " You have sent %s to DeMorgan.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;

		}
		else if(strcmp(location,"icprison",true) == 0)
		{
			if(PlayerInfo[giveplayerid][pJailTime] > 0)
			{
				SetPlayerInterior(giveplayerid, 10);
				new rand = random(sizeof(DocPrison));
				SetPlayerFacingAngle(giveplayerid, 0);
				SetPlayerPos(giveplayerid, DocPrison[rand][0], DocPrison[rand][1], DocPrison[rand][2]);
				PhoneOnline[giveplayerid] = 1;
				PlayerInfo[giveplayerid][pWantedLevel] = 0;
				SetPlayerToTeamColor(giveplayerid);
				SetPlayerWantedLevel(giveplayerid, 0);
				PlayerInfo[giveplayerid][pVW] = 0;
				SetPlayerVirtualWorld(giveplayerid, 0);
				SetPlayerToTeamColor(giveplayerid);
				Player_StreamPrep(giveplayerid, DocPrison[rand][0], DocPrison[rand][1], DocPrison[rand][2], FREEZE_TIME);
			}
			else
			{
				Player_StreamPrep(giveplayerid, -2069.76, -200.05, 991.53, FREEZE_TIME);
				SetPlayerInterior(giveplayerid,10);
				PlayerInfo[giveplayerid][pInt] = 10;
				SetPlayerVirtualWorld(giveplayerid, 0);
				PlayerInfo[giveplayerid][pVW] = 0;
			}
			format(string, sizeof(string), " You have sent %s to IC prison.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");

		}
		else if(strcmp(location,"oocprison",true) == 0)
		{
			if(PlayerInfo[giveplayerid][pJailTime] > 0)
			{
				SetPlayerInterior(giveplayerid,1);
				PlayerInfo[giveplayerid][pInt] = 1;
				ResetPlayerWeaponsEx(giveplayerid);
				PlayerInfo[giveplayerid][pWantedLevel] = 0;
				SetPlayerWantedLevel(giveplayerid, 0);
				PhoneOnline[giveplayerid] = 1;
				new rand = random(sizeof(OOCPrisonSpawns));
				Streamer_UpdateEx(giveplayerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2]);
				SetPlayerPos(giveplayerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2]);
				SetPlayerSkin(giveplayerid, 50);
				SetPlayerColor(giveplayerid, TEAM_APRISON_COLOR);
				Player_StreamPrep(giveplayerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2], FREEZE_TIME);
			}
			else
			{
				Player_StreamPrep(giveplayerid, -1158.285644, 2894.152343, 9993.131835, FREEZE_TIME);
				SetPlayerInterior(giveplayerid,1);
				PlayerInfo[giveplayerid][pInt] = 1;
				SetPlayerVirtualWorld(giveplayerid, 0);
				PlayerInfo[giveplayerid][pVW] = 0;
			}
			format(string, sizeof(string), " You have sent %s to OOC prison.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");

		}
		else if(strcmp(location,"stadium1",true) == 0)
		{
		 	if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, -1424.93, -664.59, 1059.86);
				LinkVehicleToInterior(tmpcar, 4);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, -1424.93, -664.59, 1059.86);
			}
			format(string, sizeof(string), " You have sent %s to Stadium 1.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(playerid,4);
			PlayerInfo[giveplayerid][pInt] = 4;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;

		}
		else if(strcmp(location,"stadium2",true) == 0)
		{
		 	if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, -1395.96, -208.20, 1051.28);
				LinkVehicleToInterior(tmpcar, 7);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, -1395.96, -208.20, 1051.28);
			}
			format(string, sizeof(string), " You have sent %s to Stadium 2.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(playerid,7);
			PlayerInfo[giveplayerid][pInt] = 7;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;

		}
		else if(strcmp(location,"stadium3",true) == 0)
		{
		 	if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, -1410.72, 1591.16, 1052.53);
				LinkVehicleToInterior(tmpcar, 14);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, -1410.72, 1591.16, 1052.53);
			}
			format(string, sizeof(string), " You have sent %s to Stadium 3.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(playerid,14);
			PlayerInfo[giveplayerid][pInt] = 14;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;

		}
		else if(strcmp(location,"stadium4",true) == 0)
		{
		 	if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, -1394.20, 987.62, 1023.96);
				LinkVehicleToInterior(tmpcar, 15);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
    		}
			else
			{
				SetPlayerPos(giveplayerid, -1394.20, 987.62, 1023.96);
			}
			format(string, sizeof(string), " You have sent %s to Stadium 4.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(playerid,15);
			PlayerInfo[giveplayerid][pInt] = 15;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;

		}
		else if(strcmp(location,"int1",true) == 0)
		{
		 	if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, 1416.107000,0.268620,1000.926000);
				LinkVehicleToInterior(tmpcar, 1);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, 1416.107000,0.268620,1000.926000);
			}
			format(string, sizeof(string), " You have sent %s to Int 1.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(playerid,1);
			PlayerInfo[giveplayerid][pInt] = 1;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;

		}
		else if(strcmp(location,"mark",true) == 0)
		{
		 	if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, GetPVarFloat(playerid, "tpPosX1"), GetPVarFloat(playerid, "tpPosY1"), GetPVarFloat(playerid, "tpPosZ1"));
				LinkVehicleToInterior(tmpcar, GetPVarInt(playerid, "tpInt1"));
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, GetPVarFloat(playerid, "tpPosX1"), GetPVarFloat(playerid, "tpPosY1"), GetPVarFloat(playerid, "tpPosZ1"));
			}
			format(string, sizeof(string), " You have sent %s to your first marked position.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SetPlayerInterior(playerid, GetPVarInt(playerid, "tpInt1"));
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
		}
		else if(strcmp(location,"mark2",true) == 0)
		{
		 	if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, GetPVarFloat(playerid, "tpPosX2"), GetPVarFloat(playerid, "tpPosY2"), GetPVarFloat(playerid, "tpPosZ2"));
				LinkVehicleToInterior(tmpcar, GetPVarInt(playerid, "tpInt2"));
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, GetPVarFloat(playerid, "tpPosX2"), GetPVarFloat(playerid, "tpPosY2"), GetPVarFloat(playerid, "tpPosZ2"));
			}
			format(string, sizeof(string), " You have sent %s to your second marked position.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SetPlayerInterior(playerid, GetPVarInt(playerid, "tpInt2"));
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
		}
		else if(strcmp(location,"mall",true) == 0)
		{
		 	if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, 1133.71,-1464.52,15.77);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, 1133.71,-1464.52,15.77);
			}
			format(string, sizeof(string), " You have sent %s to the mall.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;

		}
		else if(strcmp(location,"elque",true) == 0)
		{
		 	if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, -1446.5997,2608.4478,55.8359);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, -1446.5997,2608.4478,55.8359);
			}
			format(string, sizeof(string), " You have sent %s to El Quebrados.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;

		}
		else if(strcmp(location,"bayside",true) == 0)
		{
		 	if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, -2465.1348,2333.6572,4.8359);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, -2465.1348,2333.6572,4.8359);
			}
			format(string, sizeof(string), " You have sent %s to Bayside.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;
		}
		else if(strcmp(location,"famed",true) == 0)
		{
			if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, 1020.29, -1129.06, 23.87);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, 1020.29, -1129.06, 23.87);
			}
			format(string, sizeof(string), " You have sent %s to the Famed HQ.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;
		}
		else if(strcmp(location,"rodeo",true) == 0)
		{
			if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, 587.0106,-1238.3374,17.8049);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, 587.0106,-1238.3374,17.8049);
			}
			format(string, sizeof(string), " You have sent %s to Rodeo.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;
		}
		else if(strcmp(location,"flint",true) == 0)
		{
			if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, -108.1058,-1172.5293,2.8906);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, -108.1058,-1172.5293,2.8906);
			}
			format(string, sizeof(string), " You have sent %s to Flint County Gas Station.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;
		}
		else if(strcmp(location,"idlewood",true) == 0)
		{
			if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				SetVehiclePos(tmpcar, 1955.1357,-1796.8896,13.5469);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				SetPlayerPos(giveplayerid, 1955.1357,-1796.8896,13.5469);
			}
			format(string, sizeof(string), " You have sent %s to Idlewood Gas Station.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;
		}
		else if(strcmp(location,"mhc",true) == 0)
		{
			if (GetPlayerState(giveplayerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(giveplayerid);
				Player_StreamPrep(giveplayerid, 1700.2124, 1461.1771, 1145.7766, FREEZE_TIME);
				SetVehiclePos(tmpcar, 1700.2124, 1461.1771, 1145.7766);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[giveplayerid] = 0.0;
			}
			else
			{
				Player_StreamPrep(giveplayerid, 1649.7531, 1463.1614, 1151.9687, FREEZE_TIME);
			}
			format(string, sizeof(string), " You have sent %s to the Mile High Club.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			SendClientMessageEx(giveplayerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(giveplayerid,0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	}
	return 1;
}

CMD:bigears(playerid, params[])
{
    if( PlayerInfo[playerid][pAdmin] >= 2) {
        ShowPlayerDialog(playerid, BIGEARS, DIALOG_STYLE_LIST, "Please choose an item to proceed", "Global Chat\nOOC Chat\nIC Chat\nFaction Chat\nFamily Chat\nPlayer\nPrivate Messages\nDisable Bigears", "Select", "Cancel");
    }
    return 1;
}

CMD:clearall(playerid, params[])
{
    if (PlayerInfo[playerid][pAdmin] >= 1338) {
        //foreach(new i: Player)
		for(new i = 0; i < MAX_PLAYERS; ++i)
		{
			if(IsPlayerConnected(i))
			{
				PlayerInfo[i][pWantedLevel] = 0;
				SetPlayerToTeamColor(i);
				SetPlayerWantedLevel(i, 0);
				ClearCrimes(i);
			}	
        }
        SendClientMessageEx(playerid,COLOR_GRAD1, "You have cleared everyone's Wanted Level.");
    }
    else {
        SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
    }
    return 1;
}

CMD:savechars(playerid, params[])
{
    if (PlayerInfo[playerid][pAdmin] >= 4) {
        SaveEventPoints();
        mysql_SaveCrates();
        SendClientMessageEx(playerid, COLOR_YELLOW, "All Crates Saved successfully.");
        SaveAllAccountsUpdate();
		//g_mysql_DumpAccounts();
        SendClientMessageEx(playerid, COLOR_YELLOW, "Update Process Started - Wait for Account Saving Finish Confirmation.");
        SaveHouses();
        SendClientMessageEx(playerid, COLOR_YELLOW, "House saving process started.");
    }
    else {
        SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use that command.");
    }
    return 1;
}

CMD:setcolor(playerid, params[])
{
    if (PlayerInfo[playerid][pAdmin] >= 1337)
	{
        ShowPlayerDialog(playerid, COLORMENU, DIALOG_STYLE_LIST, "Color Menu", "Blue\nBlack\nRed\nOrange\nPink\nPurple\nGreen\nYellow\nWhite\nOOC Prisoner Orange", "Select", "Cancel");
    }
    else
	{
        SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
    }
    return 1;
}

CMD:mark(playerid, params[])
{
    if (PlayerInfo[playerid][pAdmin] >= 2) {

		new
			Float: f_PlayerPos[3];

		GetPlayerPos(playerid, f_PlayerPos[0], f_PlayerPos[1], f_PlayerPos[2]);
		SetPVarFloat(playerid, "tpPosX1", f_PlayerPos[0]);
		SetPVarFloat(playerid, "tpPosY1", f_PlayerPos[1]);
		SetPVarFloat(playerid, "tpPosZ1", f_PlayerPos[2]);

		SetPVarInt(playerid, "tpInt1", GetPlayerInterior(playerid));
        SendClientMessageEx(playerid, COLOR_GRAD1, "Teleporter destination set!");
    }
    else {
        SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
    }
    return 1;
}

CMD:mark2(playerid, params[])
{
    if (PlayerInfo[playerid][pAdmin] >= 2) {

		new
			Float: f_PlayerPos[3];

		GetPlayerPos(playerid, f_PlayerPos[0], f_PlayerPos[1], f_PlayerPos[2]);
		SetPVarFloat(playerid, "tpPosX2", f_PlayerPos[0]);
		SetPVarFloat(playerid, "tpPosY2", f_PlayerPos[1]);
		SetPVarFloat(playerid, "tpPosZ2", f_PlayerPos[2]);

		SetPVarInt(playerid, "tpInt2", GetPlayerInterior(playerid));
        SendClientMessageEx(playerid, COLOR_GRAD1, "Teleporter destination set!");
    }
    else {
        SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
    }
    return 1;
}

CMD:gotojet(playerid, params[])
{
    if (PlayerInfo[playerid][pAdmin] >= 3) {
        if (GetPlayerState(playerid) == 2) {
            new tmpcar = GetPlayerVehicleID(playerid);
            SetVehiclePos(tmpcar, 1.71875, 30.4062, 1200.34);
        }
        else {
            SetPlayerPos(playerid, 1.71875, 30.4062, 1200.34);
        }
        SetPlayerInterior(playerid,1);
        SendClientMessageEx(playerid, COLOR_GRAD1, "   You have been teleported!");
    }
    else {
        SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
    }
    return 1;
}

CMD:god(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 2 && PlayerInfo[playerid][pWatchdog] < 2) return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not authorized to use this command!");
	{
		new Float:health, Float:armor;
	    if(GetPVarType(playerid, "pGodMode"))
	    {
			health = GetPVarFloat(playerid, "pPreGodHealth");
			SetPlayerHealth(playerid,health);
			armor = GetPVarFloat(playerid, "pPreGodArmor");
			SetPlayerArmor(playerid, armor);
			DeletePVar(playerid, "pGodMode");
			DeletePVar(playerid, "pPreGodHealth");
			DeletePVar(playerid, "pPreGodArmor");
			SendClientMessage(playerid, COLOR_WHITE, "God mode disabled");
		}
		else
		{
			GetPlayerHealth(playerid,health);
			SetPVarFloat(playerid, "pPreGodHealth", health);
			GetPlayerArmour(playerid,armor);
			SetPVarFloat(playerid, "pPreGodArmor", armor);
		    SetPlayerHealth(playerid, 0x7FB00000);
		    SetPlayerArmor(playerid, 0x7FB00000);
		    SetPVarInt(playerid, "pGodMode", 1);
		    SendClientMessage(playerid, COLOR_WHITE, "God mode enabled");
		}
    }
	return 1;
}

CMD:damagecheck(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 2) return SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use that command.");
	if(GetPVarType(playerid, "_dCheck")) {
		DeletePVar(playerid, "_dCheck");
		SendClientMessageEx(playerid, COLOR_WHITE, "You have stopped damagecheck.");
		return 1;
	}	
	new pID;
	if(sscanf(params, "u", pID)) return SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /damagecheck [playerid]");
	if(!IsPlayerConnected(pID)) return SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");
	new string[64];
	SetPVarInt(playerid, "_dCheck", pID);
	format(string, sizeof(string), "You will now see all the damage that %s takes/gives.", GetPlayerNameEx(pID));
	SendClientMessageEx(playerid, COLOR_WHITE, string);
	if(GetPVarInt(pID, "usingfirstaid") == 1) SendClientMessageEx(playerid, COLOR_ORANGE, "Note{ffffff}: Player is currently using a first aid kit.");
	return 1;
}

CMD:lastshot(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 2) return SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use that command.");
	new pID;
	if(sscanf(params, "u", pID)) return SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /lastshot [playerid]");
	if(!IsPlayerConnected(pID)) return SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");
	if(aLastShot[pID] == INVALID_PLAYER_ID) return SendClientMessageEx(playerid, COLOR_GREY, "Player was not shot yet.");
	new string[128];
	format(string, sizeof(string), "%s was last shot by %s (ID: %d).",GetPlayerNameEx(pID), GetPlayerNameEx(aLastShot[pID]), aLastShot[pID]);
	SendClientMessageEx(playerid, COLOR_YELLOW, string);
	return 1;
}

CMD:healnear(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 4) {
		new string[128], radius, count;
		if(sscanf(params, "d", radius)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /healnear [radius]");
		if(radius < 1 || radius > 100)
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "Radius must be higher than 0 and lower than 100!");
			return 1;
		}
		//foreach(new i: Player)
		for(new i = 0; i < MAX_PLAYERS; ++i)
		{
			if(IsPlayerConnected(i))
			{
				if(ProxDetectorS(radius, playerid, i)) {
					SetPlayerHealth(i, 100);
					count++;
				}
			}	
        }
        format(string, sizeof(string), "You have healed everyone (%d) nearby.", count);
        SendClientMessageEx(playerid, COLOR_WHITE, string);
    }
    return 1;
}

CMD:armornear(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 4) {
		new string[128], radius, count;
		if(sscanf(params, "d", radius)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /armornear [radius]");
		if(radius < 1 || radius > 100)
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "Radius must be higher than 0 and lower than 100!");
			return 1;
		}
        //foreach(new i: Player)
		for(new i = 0; i < MAX_PLAYERS; ++i)
		{
			if(IsPlayerConnected(i))
			{
				if(ProxDetectorS(radius, playerid, i)) {
					SetPlayerArmor(i, 100);
					count++;
				}
			}	
        }
        format(string, sizeof(string), "You have given armor to everyone (%d) nearby.", count);
        SendClientMessageEx(playerid, COLOR_WHITE, string);
    }
    return 1;
}

CMD:fixveh(playerid, params[])
{
    if(IsPlayerConnected(playerid)) {
        if(PlayerInfo[playerid][pAdmin] < 4) {
            SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
            return 1;
        }
        if(IsPlayerInAnyVehicle(playerid)) {
            new Float:vrot;
            GetVehicleZAngle(GetPlayerVehicleID(playerid), vrot);
            SetVehicleZAngle(GetPlayerVehicleID(playerid), vrot);
            RepairVehicle(GetPlayerVehicleID(playerid));
			Vehicle_Armor(GetPlayerVehicleID(playerid));
            SendClientMessageEx(playerid, COLOR_GREY, "   Vehicle Fixed!");
        }
    }
    return 1;
}


CMD:fixvehall(playerid, params[])
{
    if(IsPlayerConnected(playerid)) {
        if(PlayerInfo[playerid][pAdmin] < 4) {
            SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
            return 1;
        }
        for(new v = 0; v < MAX_VEHICLES; v++) {
            RepairVehicle(v);
			Vehicle_Armor(v);
        }
        SendClientMessageEx(playerid, COLOR_GREY, "   All vehicles fixed!");
    }
    return 1;
}


CMD:destroycars(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 4) {
        SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
        return 1;
    }
    for(new i = 0; i < sizeof(CreatedCars); i++) {
        if(CreatedCars[i] != INVALID_VEHICLE_ID) {
            DestroyVehicle(CreatedCars[i]);
            CreatedCars[i] = INVALID_VEHICLE_ID;
        }
    }
    SendClientMessageEx(playerid, COLOR_GREY, "   Created vehicles destroyed!");
    return 1;
}

CMD:announcem(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 1337) {
        SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use this command.");
        return 1;
    }
	restarting = 1;
    SetTimer( "Maintenance", 30000, false );
    SendClientMessageToAllEx(COLOR_LIGHTBLUE, "* The server will be going down in 30 seconds for Scheduled Maintenance.");
    //foreach(new i: Player)
	for(new i = 0; i < MAX_PLAYERS; ++i)
	{
		if(IsPlayerConnected(i))
		{
			GameTextForPlayer(i, "~y~Scheduled Maintenance Alert", 5000, 6);
		}	
    }
    return 1;
}

CMD:rehashall(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 1337)
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
		return 1;
	}

	RehashHouses();
	RehashDynamicDoors();
	RehashDynamicMapIcons();
	return 1;
}

CMD:levelones(playerid, params[]) {
	if(PlayerInfo[playerid][pAdmin] >= 2)
	{
		new szNoobs[156], zone[MAX_ZONE_NAME], search[MAX_ZONE_NAME], hours;
		SendClientMessageEx(playerid, COLOR_WHITE, "Listing level ones...");
		if(!sscanf(params, "d", hours)) 
		{
			foreach(new i: Player)
			{
				if(gPlayerLogged{playerid} > 0 && PlayerInfo[i][pLevel] == 1 && PlayerInfo[i][pConnectHours] == hours && PlayerInfo[i][pAdmin] == 0)
				{
					GetPlayer3DZone(i, zone, sizeof(zone));
					format(szNoobs, sizeof(szNoobs), "* %s (ID %i) (Hours %i) - Location: %s", GetPlayerNameEx(i), i, PlayerInfo[i][pConnectHours], zone);
					SendClientMessageEx(playerid, COLOR_WHITE, szNoobs);
				}
			}
		}
		else if(!sscanf(params, "s[28]", search)) 
		{
			foreach(new i: Player)
			{
				if(gPlayerLogged{playerid} > 0 && PlayerInfo[i][pLevel] == 1 && PlayerInfo[i][pAdmin] == 0)
				{
					GetPlayer3DZone(i, zone, sizeof(zone));
					if(strcmp(search, zone, true) == 0 && !isnull(zone)) // null check, as strcmp returns 0 if empty.
					{
						format(szNoobs, sizeof(szNoobs), "* %s (ID %i) (Hours %i) - Location: %s", GetPlayerNameEx(i), i, PlayerInfo[i][pConnectHours], zone);
						SendClientMessageEx(playerid, COLOR_WHITE, szNoobs);
					}
				}
			}
		}
		else 
		{
			foreach(new i: Player)
			{
				if(gPlayerLogged{playerid} > 0 && PlayerInfo[i][pLevel] == 1 && PlayerInfo[i][pAdmin] == 0)
				{
					GetPlayer3DZone(i, zone, sizeof(zone));
					format(szNoobs, sizeof(szNoobs), "* %s (ID %i) (Hours %i) - Location: %s", GetPlayerNameEx(i), i, PlayerInfo[i][pConnectHours], zone);
					SendClientMessageEx(playerid, COLOR_WHITE, szNoobs);
				}
			}
		}
	}
	return 1;
}

CMD:paused(playerid, params[]) {
    if(PlayerInfo[playerid][pAdmin] >= 2) {

    	new
			szMessage[42 + MAX_PLAYER_NAME];

	    SendClientMessageEx(playerid,COLOR_WHITE,"Listing all paused players...");
	    //foreach(new i: Player)
		for(new i = 0; i < MAX_PLAYERS; ++i)
		{
			if(IsPlayerConnected(i))
			{
				if(playerTabbed[i] != 0) {

					if(playerTabbed[i] > 60) format(szMessage, sizeof(szMessage), "* %s (ID %d), tabbed for %d minutes.", GetPlayerNameEx(i), i, playerTabbed[i] / 60);
					else format(szMessage, sizeof(szMessage), "* %s (ID %d), tabbed for %d seconds.", GetPlayerNameEx(i), i, playerTabbed[i]);

					if(PlayerInfo[i][pAdmin] >= 2) SendClientMessageEx(playerid,COLOR_RED, szMessage);
					else SendClientMessageEx(playerid,COLOR_GREY, szMessage);
				}
			}	
		}
   	}
    else SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use this command.");
	return 1;
}

CMD:afk(playerid, params[]) {
    if(PlayerInfo[playerid][pAdmin] >= 2) {

    	new
			szMessage[36 + MAX_PLAYER_NAME];

	    SendClientMessageEx(playerid,COLOR_WHITE,"Listing all AFK players...");
	    //foreach(new i: Player)
		for(new i = 0; i < MAX_PLAYERS; ++i)
		{
			if(IsPlayerConnected(i))
			{
				if(playerAFK[i] != 0 && playerAFK[i] > 60) {
					format(szMessage,sizeof(szMessage),"* %s (ID %d), AFK for %d minutes.", GetPlayerNameEx(i), i, playerAFK[i] / 60);
					if(PlayerInfo[i][pAdmin] >= 2) SendClientMessageEx(playerid,COLOR_RED,szMessage);
					else SendClientMessageEx(playerid,COLOR_GREY,szMessage);
				}
			}	
  		}
   	}
    else SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use this command.");
	return 1;
}
