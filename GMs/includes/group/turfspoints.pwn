/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

					Turfs / Points System

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

CMD:turfinfo(playerid, params[])
{
    if(GetPlayerTurfWarsZone(playerid) != -1) {
        new string[128];
        new tw = GetPlayerTurfWarsZone(playerid);
        format(string,sizeof(string),"|___________ (ID: %d) %s ___________|",tw,TurfWars[tw][twName]);
        SendClientMessageEx(playerid, COLOR_GREEN, string);
        if(TurfWars[tw][twOwnerId] != -1) {
            format(string,sizeof(string),"Owner: %s.",FamilyInfo[TurfWars[tw][twOwnerId]][FamilyName]);
        }
        else {
            format(string,sizeof(string),"Owner: Vacant.");
        }
        SendClientMessageEx(playerid, COLOR_WHITE, string);
        format(string,sizeof(string),"Vulnerable: %d Hours.",TurfWars[tw][twVulnerable]);
        SendClientMessageEx(playerid, COLOR_WHITE, string);
        format(string,sizeof(string),"Locked: %d.",TurfWars[tw][twLocked]);
        SendClientMessageEx(playerid, COLOR_WHITE, string);
        format(string,sizeof(string),"Active: %d.",TurfWars[tw][twActive]);
        SendClientMessageEx(playerid, COLOR_WHITE, string);
        if(TurfWars[tw][twActive] != 0) {
            format(string,sizeof(string),"Time Left: %d Secs.",TurfWars[tw][twTimeLeft]);
            SendClientMessageEx(playerid, COLOR_WHITE, string);
            if(TurfWars[tw][twAttemptId] == -2) {
                format(string,sizeof(string),"Takeover Faction: Law Enforcement.");
                SendClientMessageEx(playerid, COLOR_WHITE, string);
            }
            else {
                format(string,sizeof(string),"Takeover Family: %s.",FamilyInfo[TurfWars[tw][twAttemptId]][FamilyName]);
                SendClientMessageEx(playerid, COLOR_WHITE, string);
            }
        }
        switch(TurfWars[tw][twSpecial]) {
            case 1:
            {
                format(string,sizeof(string),"Special Perks: Extortion.");
            }
            default:
            {
                format(string,sizeof(string),"Special Perks: None.");
            }
        }
        SendClientMessageEx(playerid, COLOR_WHITE, string);
    }
    else {
        SendClientMessageEx(playerid, COLOR_WHITE, "You are not in a turf!");
    }
    return 1;
}

CMD:savetwpos(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] > 3 || PlayerInfo[playerid][pGangModerator] >= 1) {
        new string[128];
        new tw = GetPVarInt(playerid, "EditingTurfs");
        new stage = GetPVarInt(playerid, "EditingTurfsStage");
        new Float:x, Float: y, Float: z;
        new Float:tminx, Float: tminy, Float: tmaxx, Float: tmaxy;
        GetPlayerPos(playerid, x, y, z);
        if(stage == -1) {
            SendClientMessageEx(playerid, COLOR_GRAD2, "You are not editing any Turf Dimensions right now!");
            return 1;
        }
        else {
            switch(stage) {
                case 1:
                {
                    SetPVarFloat(playerid, "EditingTurfsMinX", x);
                    format(string,sizeof(string),"X=%f, Y=%f, Z=%f",x,y,z);
                    SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully edited Turf West Wall.");
                    SendClientMessageEx(playerid, COLOR_GRAD2, string);
                    SendClientMessageEx(playerid, COLOR_WHITE, "Goto a location and type (/savetwpos) to edit the South Wall.");
                    SetPVarInt(playerid, "EditingTurfsStage", 2);
                }
                case 2:
                {
                    SetPVarFloat(playerid, "EditingTurfsMinY", y);
                    format(string,sizeof(string),"X=%f, Y=%f, Z=%f",x,y,z);
                    SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully edited Turf South Wall.");
                    SendClientMessageEx(playerid, COLOR_GRAD2, string);
                    SendClientMessageEx(playerid, COLOR_WHITE, "Goto a location and type (/savetwpos) to edit the East Wall.");
                    SetPVarInt(playerid, "EditingTurfsStage", 3);
                }
                case 3:
                {
                    SetPVarFloat(playerid, "EditingTurfsMaxX", x);
                    format(string,sizeof(string),"X=%f, Y=%f, Z=%f",x,y,z);
                    SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully edited Turf East Wall.");
                    SendClientMessageEx(playerid, COLOR_GRAD2, string);
                    SendClientMessageEx(playerid, COLOR_WHITE, "Goto a location and type (/savetwpos) to edit the North Wall.");
                    SetPVarInt(playerid, "EditingTurfsStage", 4);
                }
                case 4:
                {
                    SetPVarFloat(playerid, "EditingTurfsMaxY", y);
                    format(string,sizeof(string),"X=%f, Y=%f, Z=%f",x,y,z);
                    SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully edited Turf North Wall.");
                    SendClientMessageEx(playerid, COLOR_GRAD2, string);
                    format(string,sizeof(string),"You have successfully re-created (TurfID: %d) %s.",tw,TurfWars[tw][twName]);
                    SendClientMessageEx(playerid, COLOR_WHITE, string);
                    SetPVarInt(playerid, "EditingTurfsStage", -1);

                    DestroyTurfWarsZone(tw);

                    tminx = GetPVarFloat(playerid, "EditingTurfsMinX");
                    tminy = GetPVarFloat(playerid, "EditingTurfsMinY");
                    tmaxx = GetPVarFloat(playerid, "EditingTurfsMaxX");
                    tmaxy = GetPVarFloat(playerid, "EditingTurfsMaxY");

                    TurfWars[tw][twMinX] = tminx;
                    TurfWars[tw][twMinY] = tminy;
                    TurfWars[tw][twMaxX] = tmaxx;
                    TurfWars[tw][twMaxY] = tmaxy;

                    SetPVarFloat(playerid, "EditingTurfsMinX", 0.0);
                    SetPVarFloat(playerid, "EditingTurfsMinY", 0.0);
                    SetPVarFloat(playerid, "EditingTurfsMaxX", 0.0);
                    SetPVarFloat(playerid, "EditingTurfsMaxY", 0.0);

                    CreateTurfWarsZone(1,tw);
                    ShowPlayerDialog(playerid,TWEDITTURFSMENU,DIALOG_STYLE_LIST,"Turf Wars - Edit Turfs Menu:","Edit Dimensions...\nEdit Owners...\nEdit Vulnerable Time...\nEdit Locked...\nEdit Perks...\nReset War...\nDestroy Turf","Select","Back");
                }
            }
        }
    }
    else {
        SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use this command!");
    }
    return 1;
}

CMD:twmenu(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] > 3 || PlayerInfo[playerid][pGangModerator] >= 1)
	{
        ShowPlayerDialog(playerid,TWADMINMENU,DIALOG_STYLE_LIST,"Turf Wars - Admin Menu:","Edit Turfs...\nEdit Family Colors...","Select","Exit");
    }
    else
	{
        SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use this command!");
    }
    return 1;
}

CMD:turfs(playerid, params[])
{
    if(turfWarsRadar[playerid] == 0) {
        SendClientMessageEx(playerid, COLOR_WHITE, "You have enabled the Turf Minimap Radar.");
        ShowTurfWarsRadar(playerid);
    }
    else {
        SendClientMessageEx(playerid, COLOR_WHITE, "You have disabled the Turf Minimap Radar.");
        HideTurfWarsRadar(playerid);
    }
    return 1;
}

CMD:shutdown(playerid, params[])
{
    if(IsACop(playerid)) {
        new string[128];
        new tw = GetPlayerTurfWarsZone(playerid);
        new rank = PlayerInfo[playerid][pRank];
        if(rank < 3) {
            SendClientMessageEx(playerid, COLOR_GRAD2, "You have to be at least Rank 3 to shutdown turfs!");
            return 1;
        }
        if(tw != -1) {
            if(TurfWars[tw][twLocked] == 1) {
                SendClientMessageEx(playerid, COLOR_GRAD2, "The turf is currently locked by a admin, you can not shutdown the turf!");
                return 1;
            }
            if(TurfWars[tw][twVulnerable] == 0) {
                if(TurfWars[tw][twActive] == 0) {
                    SendClientMessageEx(playerid, COLOR_GRAD2, "The turf isn't in a active turf war, you have no reason to shutdown the turf!");
                }
                else {
                    new count = 0;
                    if(TurfWars[tw][twAttemptId] == -2) {
                        SendClientMessageEx(playerid, COLOR_GRAD2, "The LEO Factions are already attempting to shutdown the turf war!");
                        return 1;
                    }

                    //foreach(new i: Player)
					for(new i = 0; i < MAX_PLAYERS; ++i)
					{
						if(IsPlayerConnected(i))
						{
							if(TurfWars[tw][twAttemptId] == PlayerInfo[i][pFMember]) {
								if(GetPlayerTurfWarsZone(i) == tw) {
									count++;
								}
							}
						}	
                    }
                    if(count != 0) {
                        format(string,sizeof(string),"There is still %d Attacking Members on the Turf, you must get rid of them before shuting down!",count);
                        SendClientMessageEx(playerid, COLOR_GRAD2, string);
                    }
                    else {
                        ShutdownTurfWarsZone(tw);
                    }
                }
            }
            else {
                SendClientMessageEx(playerid, COLOR_GRAD2, "This turf is currently not vulnerable, you are unable to shutdown!");
                SendClientMessageEx(playerid, COLOR_GRAD1, "If you are in FBI, You must contact a admin to lock down the turf with a IC Casefile.");
            }
        }
        else {
            SendClientMessageEx(playerid, COLOR_GRAD2, "You have to be in a turf to be able to shutdown turfs!");
        }
    }
    else {
        SendClientMessageEx(playerid, COLOR_GRAD2, "You are not in a LEO Faction, you can not shutdown turfs!");
    }
	return 1;
}


CMD:claim(playerid, params[])
{
	if(servernumber == 2)
	{
	    SendClientMessage(playerid, COLOR_WHITE, "This command is disabled!");
	    return 1;
	}
    new string[128];
    new tw = GetPlayerTurfWarsZone(playerid);
    new family = PlayerInfo[playerid][pFMember];
    new rank = PlayerInfo[playerid][pRank];
    if(family == INVALID_FAMILY_ID) {
        SendClientMessageEx(playerid, COLOR_GRAD2, "You are not in a family/gang, you can not claim turfs!");
        return 1;
    }
    if(rank < 5) {
        SendClientMessageEx(playerid, COLOR_GRAD2, "You have to be at least Rank 5 to claim turfs!");
        return 1;
    }
    if(FamilyInfo[family][FamilyTurfTokens] < 12) {
        SendClientMessageEx(playerid, COLOR_GRAD2, "Your family/gang does not have any turf claim tokens, please wait at least 12 hours.");
        return 1;
    }
    if(tw != -1) {
        if(TurfWars[tw][twLocked] == 1) {
            SendClientMessageEx(playerid, COLOR_GRAD2, "The turf is currently locked by a admin, you can not claim it!");
            return 1;
        }
        if(TurfWars[tw][twVulnerable] == 0) {
            if(TurfWars[tw][twActive] == 0) {
                if(TurfWars[tw][twOwnerId] == family) {
                    SendClientMessageEx(playerid, COLOR_GRAD2, "Your family/gang already owns this turf, you are unable to claim it!");
                    return 1;
                }
                new count = 0;
                //foreach(new i: Player)
				for(new i = 0; i < MAX_PLAYERS; ++i)
				{
					if(IsPlayerConnected(i))
					{
						if(family == PlayerInfo[i][pFMember] && PlayerInfo[i][pAccountRestricted] != 1) {
							if(GetPlayerTurfWarsZone(i) == tw) {
								count++;
							}
						}
					}	
                }

                if(count > 2) {
                    FamilyInfo[family][FamilyTurfTokens] -= 12;
                    TakeoverTurfWarsZone(family, tw);
                }
                else {
                    SendClientMessageEx(playerid, COLOR_GRAD2, "You need at least 3 of your family/gang members on the turf, to be able to claim it!");
                }
            }
            else {
                new count = 0;
                new leocount = 0;
                if(TurfWars[tw][twAttemptId] == family) {
                    SendClientMessageEx(playerid, COLOR_GRAD2, "You are already attempting to capture this turf!");
                    return 1;
                }

                //foreach(new i: Player)
				for(new i = 0; i < MAX_PLAYERS; ++i)
				{
					if(IsPlayerConnected(i))
					{
						if(TurfWars[tw][twAttemptId] == PlayerInfo[i][pFMember]) {
							if(GetPlayerTurfWarsZone(i) == tw) {
								count++;
							}
						}
						if(TurfWars[tw][twAttemptId] == -2) {
							if(IsACop(i)) {
								if(GetPlayerTurfWarsZone(i) == tw) {
									leocount++;
								}
							}
						}
					}	
                }

                if(count == 0 && leocount == 0) {
                    if(family != TurfWars[tw][twOwnerId]) {
                        FamilyInfo[family][FamilyTurfTokens] -= 12;
                    }
                    //foreach(new i: Player)
					for(new i = 0; i < MAX_PLAYERS; ++i)
					{
						if(IsPlayerConnected(i))
						{
							if(PlayerInfo[i][pGangModerator] >= 1) {
								format(string,sizeof(string),"%s has attempted to takeover turf %d for family %s",GetPlayerNameEx(playerid),tw,FamilyInfo[family][FamilyName]);
								SendClientMessageEx(i,COLOR_YELLOW,string);
							}
						}	
                    }
                    TakeoverTurfWarsZone(family, tw);
                }
                else {
                    if(leocount == 0) {
                        format(string,sizeof(string),"There is still %d Attacking Members on the Turf, you must get rid of them before reclaiming!",count);
                        SendClientMessageEx(playerid, COLOR_GRAD2, string);
                    }
                    else {
                        format(string,sizeof(string),"There is still %d Officers on the Turf, you must get rid of them before reclaiming!",leocount);
                        SendClientMessageEx(playerid, COLOR_GRAD2, string);
                    }
                }
            }
        }
        else {
            SendClientMessageEx(playerid, COLOR_GRAD2, "This turf is currently not vulnerable, you are unable to claim it!");
        }
    }
    else {
        SendClientMessageEx(playerid, COLOR_GRAD2, "You have to be in a turf to be able to claim turfs!");
    }

    if(turfWarsRadar[playerid] == 0) {
        ShowTurfWarsRadar(playerid);
    }
    return 1;
}

CMD:setcapping(playerid, params[]) {
	if(PlayerInfo[playerid][pAdmin] >= 4) {
		if(isnull(params)) {
			return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /setcapping [ping]");
		}

		new
			iPingas = strval(params);

		if(!(250 <= iPingas <= 1000)) {
			return SendClientMessageEx(playerid, COLOR_WHITE, "The specified ping limit can not be lower than 250 or higher than 1000.");
		}

		new
			szMessage[58 + MAX_PLAYER_NAME];

		format(szMessage, sizeof(szMessage), "AdmCmd: %s has adjusted the /capture ping limit to %d.", GetPlayerNameEx(playerid), iPingas);
		ABroadCast(COLOR_LIGHTRED, szMessage, 4);
		pointpinglimit = iPingas;
	}
	return 1;
}

CMD:gotofpoint(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] > 2) 
	{
		new points, string[128];
		if(sscanf(params, "d", points)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /gotofpoint [pointid]");
		if(points < 1 || points > 9) return SendClientMessageEx(playerid, COLOR_GREY, "Invalid point id!");
		
		SetPlayerPos(playerid, Points[points][Pointx], Points[points][Pointy], Points[points][Pointz]), SetPlayerVirtualWorld(playerid, Points[points][pointVW]);
		format(string, sizeof(string), "You have teleported to family point %d", points);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
	}
	else return SendClientMessageEx(playerid, COLOR_GREY, "You're not authorized to use this command!");
	return 1;
}	
CMD:capture(playerid, params[])
{
    if(servernumber == 2)
	{
	    SendClientMessage(playerid, COLOR_WHITE, "This command is disabled!");
	    return 1;
	}
	new string[128];
	new myvw = GetPlayerVirtualWorld(playerid);

	new mypoint = -1;
	if(GetPVarInt(playerid,"Injured") == 1)
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, " You can not capture while injured!");
		return 1;
	}
	if (PlayerInfo[playerid][pFMember] == INVALID_FAMILY_ID || PlayerInfo[playerid][pRank] < 5)
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, " You are not high rank enough to capture!");
		return 1;
	}
	for (new i=0; i<MAX_POINTS; i++)
	{
		if (IsPlayerInRangeOfPoint(playerid, 1.0, Points[i][Pointx], Points[i][Pointy], Points[i][Pointz]))
		{
			if(myvw == Points[i][pointVW])
			{
				mypoint = i;
			}
		}		
	}
	if (mypoint == -1)
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, " You are not at the capture place!");
		return 1;
	}
	if (Points[mypoint][Vulnerable] > 0)
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, " This point is not ready for takeover.");
		return 1;
	}
	if (Points[mypoint][TimeToClaim])
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, " This point is already being captured!");
		return 1;
	}
	if(GetPlayerPing(playerid) > pointpinglimit)
	{
		format(string,sizeof(string), " You can not capture with %d+ ping!", pointpinglimit);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		return 1;
	}
	format(string,sizeof(string), " %s is attempting to capture the point (VW: %d).", GetPlayerNameEx(playerid), Points[mypoint][pointVW]);
	ProxDetector(70.0, playerid, string, COLOR_RED,COLOR_RED,COLOR_RED,COLOR_RED,COLOR_RED);
	GetPlayerPos(playerid, Points[mypoint][Capturex], Points[mypoint][Capturey], Points[mypoint][Capturez]);

	Points[mypoint][ClaimerId] = playerid;
	Points[mypoint][TimeToClaim] = 1;
	Points[mypoint][TimeLeft] = 10;
	SetTimerEx("ProgressTimer", 1000, 0, "d", mypoint);
	return 1;
}

CMD:points(playerid, params[])
{
	new string[128];

	for(new i; i < MAX_POINTS; i++)
	{
		if (Points[i][Type] >= 0)
		{
			if(Points[i][pointID] != 0)
			{
				format(string, sizeof(string), "Point ID: %d | Name: %s | Owner: %s | Captured By: %s | Hours: %d",
				Points[i][pointID], Points[i][Name],Points[i][Owner],Points[i][CapperName],Points[i][Vulnerable]);
				SendClientMessageEx(playerid, COLOR_WHITE, string);
			}
		}
	}
	return 1;
}

CMD:pointtime(playerid, params[])
{
	new point, string[128];
	if(sscanf(params, "i", point)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /pointtime [pointid]");
	
	if(point < 1 || point > 9) return SendClientMessageEx(playerid, COLOR_GRAD2, "Invalid ID!");
	
	if(Points[point-1][TakeOverTimerStarted])
	{
		if(Points[point-1][TakeOverTimer] > 0)
		{
			format(string, sizeof(string), "Time left until fully captured: %d minutes.", Points[point-1][TakeOverTimer]);
			SendClientMessageEx(playerid, COLOR_YELLOW, string);
		}
		else return SendClientMessageEx(playerid, COLOR_GRAD2, "This point is not being captured at the moment.");
	}	
	else return SendClientMessageEx(playerid, COLOR_GRAD2, "This point is not being captured at the moment.");
	return 1;
}

CMD:pedit(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pGangModerator] >= 2)
	{
		new string[128], hours;
		if(sscanf(params, "d", hours))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /pedit [hours]");
			SendClientMessageEx(playerid, COLOR_GREY, "HINT: Stand close to a point to set the hours.");
			return 1;
		}

		for(new h = 0; h < sizeof(Points); h++)
		{
			if(IsPlayerInRangeOfPoint(playerid, 3.0, Points[h][Pointx], Points[h][Pointy], Points[h][Pointz]))
			{
				if(hours < 1|| hours > 24)
				{
					SendClientMessageEx(playerid, COLOR_GREY, "You can not set the point time lower than 1 or higher than 24!");
				}
				else if(hours >= 1|| hours <= 24)
				{
					format(string, sizeof(string), "You have set this point's time to %d hours !", hours);
					Points[h][Vulnerable] = hours;
					SendClientMessageEx(playerid, COLOR_WHITE, string);
					UpdatePoints();
				}
			}
		}
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use this command.");
	return 1;
}

CMD:pointfix(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pGangModerator] >= 2)
	{
		for(new h = 0; h < sizeof(Points); h++)
		{
			if(IsPlayerInRangeOfPoint(playerid, 3.0, Points[h][Pointx], Points[h][Pointy], Points[h][Pointz]))
			{
				Points[h][TimeToClaim] = 0;
				SendClientMessageEx(playerid, COLOR_WHITE, "You have fixed the point, players can now attempt to capture the point!");
				UpdatePoints();
				return 1;
			}
		}
		SendClientMessageEx(playerid, COLOR_GREY, "Error: You need to stand close to the capture point to fix it.");
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use this command!");
	return 1;
}