/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

				Dynamic Housing System

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

CMD:househelp(playerid, params[])
{
    SendClientMessageEx(playerid, COLOR_GREEN,"_______________________________________");
    SendClientMessageEx(playerid, COLOR_WHITE,"*** HOUSE HELP *** - type a command for more infomation.");
    SendClientMessageEx(playerid, COLOR_GRAD3,"*** HOUSE *** /lockhouse /setrentable /setrent /evict /evictall /sellmyhouse /ringbell");
    SendClientMessageEx(playerid, COLOR_GRAD3,"*** HOUSE *** /hwithdraw /hdeposit /hbalance /getgun /storegun /closet(add/remove) /houseinvite");
    SendClientMessageEx(playerid, COLOR_GRAD3,"*** HOUSE *** /movegate /setgatepass /placemailbox /destroymailbox /getmail /sendmail");
    return 1;
}

CMD:renthelp(playerid, params[])
{
    SendClientMessageEx(playerid, COLOR_GREEN,"_______________________________________");
    SendClientMessageEx(playerid, COLOR_WHITE,"*** RENTING HELP *** - type a command for more infomation.");
    SendClientMessageEx(playerid, COLOR_GRAD3,"*** RENT *** /unrent /enter /exit /lock /home");
    return 1;
}

CMD:buyhouse(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 100.0, 1109.0, 1537.0, 5.0) && PlayerInfo[playerid][pAdmin] < 2) return SendClientMessage(playerid, COLOR_WHITE, "You cannot use this command in this area!");
    new string[128];
    new Float:oldposx, Float:oldposy, Float:oldposz;
    GetPlayerPos(playerid, oldposx, oldposy, oldposz);
    for(new h = 0; h < sizeof(HouseInfo); h++)
	{
        if(IsPlayerInRangeOfPoint(playerid, 2.0, HouseInfo[h][hExteriorX], HouseInfo[h][hExteriorY], HouseInfo[h][hExteriorZ]) && GetPlayerInterior(playerid) == HouseInfo[h][hExtIW] && GetPlayerVirtualWorld(playerid) == HouseInfo[h][hExtVW])
		{
		    if(PlayerInfo[playerid][pFreezeHouse] == 1) return SendClientMessageEx(playerid, COLOR_WHITE, "ERROR: Your house assets are frozen, you cannot buy a house!");
            if(HouseInfo[h][hOwned] == 0)
			{
                if(PlayerInfo[playerid][pLevel] < HouseInfo[h][hLevel])
				{
                    format(string, sizeof(string), "   You must be Level %d to purchase this!", HouseInfo[h][hLevel]);
                    SendClientMessageEx(playerid, COLOR_GRAD5, string);
                    return 1;
                }
				if(Homes[playerid] >= 2 && PlayerInfo[playerid][pDonateRank] < 4) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot own another home.");
				else if(Homes[playerid] >= 3 && PlayerInfo[playerid][pDonateRank] >= 4) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot own another home.");
				if(GetPlayerCash(playerid) > HouseInfo[h][hValue])
				{
					if(PlayerInfo[playerid][pPhousekey] == INVALID_HOUSE_ID) PlayerInfo[playerid][pPhousekey] = h;
					else if(PlayerInfo[playerid][pPhousekey2] == INVALID_HOUSE_ID) PlayerInfo[playerid][pPhousekey2] = h;
					else if(PlayerInfo[playerid][pPhousekey3] == INVALID_HOUSE_ID && PlayerInfo[playerid][pDonateRank] >= 4) PlayerInfo[playerid][pPhousekey3] = h;
					else return SendClientMessageEx(playerid, COLOR_GREY, "You have no free house slot left.");
					HouseInfo[h][hOwned] = 1;
					HouseInfo[h][hOwnerID] = GetPlayerSQLId(playerid);
					strcat((HouseInfo[h][hOwnerName][0] = 0, HouseInfo[h][hOwnerName]), GetPlayerNameEx(playerid), MAX_PLAYER_NAME);
					Homes[playerid]++;
					GivePlayerCash(playerid,-HouseInfo[h][hValue]);
					SetPlayerInterior(playerid,HouseInfo[h][hIntIW]);
					SetPlayerPos(playerid, HouseInfo[h][hInteriorX], HouseInfo[h][hInteriorY], HouseInfo[h][hInteriorZ]);
					GameTextForPlayer(playerid, "~w~Welcome Home~n~You can exit at any time by moving to this door and typing /exit.", 5000, 3);
					PlayerInfo[playerid][pInt] = HouseInfo[h][hIntIW];
					SendClientMessageEx(playerid, COLOR_WHITE, "Congratulations on your new purchase!");
					SendClientMessageEx(playerid, COLOR_WHITE, "Type /help to review the property help section!");
					SaveHouse(h);
					OnPlayerStatsUpdate(playerid);
					PlayerInfo[playerid][pVW] = HouseInfo[h][hIntVW];
					SetPlayerVirtualWorld(playerid,HouseInfo[h][hIntVW]);
					ReloadHouseText(h);
					format(string,sizeof(string),"%s(%d) (IP: %s) has bought house ID %d for $%d.",GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid),h,HouseInfo[h][hValue]);
					Log("logs/house.log", string);
					if(HouseInfo[h][hCustomInterior] == 1) Player_StreamPrep(playerid, HouseInfo[h][hInteriorX],HouseInfo[h][hInteriorY],HouseInfo[h][hInteriorZ], FREEZE_TIME);
					return 1;
				}
				else return SendClientMessageEx(playerid, COLOR_GREY, "   You don't have the cash for that!");
            }
            else return SendClientMessageEx(playerid, COLOR_GREY, "This house is owned.");
        }
    }
    return 1;
}

CMD:rentroom(playerid, params[])
{
    //new string[128];
    new Float:oldposx, Float:oldposy, Float:oldposz;
    new playername[MAX_PLAYER_NAME];
    GetPlayerName(playerid, playername, sizeof(playername));
    GetPlayerPos(playerid, oldposx, oldposy, oldposz);
    for(new h = 0; h < sizeof(HouseInfo); h++)
	{
        if(IsPlayerInRangeOfPoint(playerid, 2.0, HouseInfo[h][hExteriorX], HouseInfo[h][hExteriorY], HouseInfo[h][hExteriorZ]) && GetPlayerInterior(playerid) == HouseInfo[h][hExtIW] && GetPlayerVirtualWorld(playerid) == HouseInfo[h][hExtVW] && HouseInfo[h][hRentFee] >= 1)
		{
            if(!strcmp(HouseInfo[h][hOwnerName], "Nobody", true))
			{
                SendClientMessageEx( playerid, COLOR_WHITE, "You can't rent an unowned house." );
            }
            else
			{
                if(PlayerInfo[playerid][pPhousekey] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[playerid][pPhousekey]][hOwnerID] == GetPlayerSQLId(playerid))
				{
                    SendClientMessageEx(playerid, COLOR_WHITE, "   You already own a house, type /sellmyhouse if you want to rent this one.");
                    return 1;
                }
                if(GetPlayerCash(playerid) > HouseInfo[h][hRentFee])
				{
                    if( HouseInfo[h][hRentable] == 0 )
					{
                        SendClientMessageEx(playerid, COLOR_WHITE, "This house is not rentable.");
                        return 1;
                    }
                    else
					{
                        PlayerInfo[playerid][pRenting] = h;
                        GivePlayerCash(playerid,-HouseInfo[h][hRentFee]);
                        HouseInfo[h][hSafeMoney] = HouseInfo[h][hSafeMoney]+HouseInfo[h][hRentFee];
                        SetPlayerInterior(playerid,HouseInfo[h][hIntIW]);
                        SetPlayerPos(playerid,HouseInfo[h][hInteriorX],HouseInfo[h][hInteriorY],HouseInfo[h][hInteriorZ]);
                        GameTextForPlayer(playerid, "~w~Welcome Home~n~You can exit at any time by moving to this door and typing /exit.", 5000, 3);
                        PlayerInfo[playerid][pInt] = HouseInfo[h][hIntIW];
                        PlayerInfo[playerid][pVW] = HouseInfo[h][hIntVW];
                        SetPlayerVirtualWorld(playerid,HouseInfo[h][hIntVW]);
                        SendClientMessageEx(playerid, COLOR_WHITE, "Congratulations. You can enter and exit here any time you want.");
                        SendClientMessageEx(playerid, COLOR_WHITE, "Type /help to review the property help section.");
                        OnPlayerStatsUpdate(playerid);
                        //new ip[32];
                        //GetPlayerIp(playerid,ip,sizeof(ip));
                        //format(string,sizeof(string),"%s (IP: %s) has rented house ID %d (owned by %s) for $%d.",GetPlayerNameEx(playerid),ip,h,HouseInfo[h][hOwnerID],HouseInfo[h][hRentFee]);
                        //Log("logs/house.log", string);
						if(HouseInfo[h][hCustomInterior] == 1) Player_StreamPrep(playerid, HouseInfo[h][hInteriorX],HouseInfo[h][hInteriorY],HouseInfo[h][hInteriorZ], FREEZE_TIME);
                        return 1;
                    }
                }
                else
				{
                    SendClientMessageEx(playerid, COLOR_WHITE, "You don't have the cash for that.");
                    return 1;
                }
            }
        }
    }
    return 1;
}

CMD:unrent(playerid, params[])
{
    new playername[MAX_PLAYER_NAME];
    GetPlayerName(playerid, playername, sizeof(playername));
    if(PlayerInfo[playerid][pPhousekey] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[playerid][pPhousekey]][hOwnerID] == GetPlayerSQLId(playerid))
	{
        SendClientMessageEx(playerid, COLOR_WHITE, "   You own this house!");
        return 1;
    }
    if( PlayerInfo[playerid][pRenting] != INVALID_HOUSE_ID )
	{
        PlayerInfo[playerid][pRenting] = INVALID_HOUSE_ID;
        SendClientMessageEx(playerid, COLOR_WHITE, "You are now homeless.");
    }
    return 1;
}

CMD:ringbell(playerid, params[])
{
	for(new h; h < sizeof(HouseInfo); h++) if(IsPlayerInRangeOfPoint(playerid, 3.0, HouseInfo[h][hExteriorX], HouseInfo[h][hExteriorY], HouseInfo[h][hExteriorZ])) {

		new
			string[75 + MAX_PLAYER_NAME];

		//foreach(new i: Player)
		for(new i = 0; i < MAX_PLAYERS; ++i)
		{
			if(IsPlayerConnected(i))
			{
				if((IsPlayerInRangeOfPoint(i, 15.0, HouseInfo[h][hInteriorX], HouseInfo[h][hInteriorY], HouseInfo[h][hInteriorZ])) && GetPlayerVirtualWorld(i) == HouseInfo[h][hIntVW] && GetPlayerInterior(i) == HouseInfo[h][hIntIW]) {
					format(string,sizeof(string),"%s's doorbell rings.", StripUnderscore(HouseInfo[h][hOwnerName]));
					SendClientMessageEx(i,COLOR_PURPLE,string);
					GameTextForPlayer(i, "~n~~n~~n~~n~~n~~n~~n~~n~~w~The doorbell rings...", 4000,3);
					break;
				}
			}
		}
		format(string,sizeof(string),"* %s presses a button next to the door, ringing the doorbell of %s's house.", GetPlayerNameEx(playerid), StripUnderscore(HouseInfo[h][hOwnerName]));
		ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	}
	return 1;
}

CMD:home(playerid, params[])
{
	if(CheckPointCheck(playerid)) return SendClientMessageEx(playerid, COLOR_WHITE, "Please ensure that your current checkpoint is destroyed first (you either have material packages, or another existing checkpoint).");
	if(!Homes[playerid]) return SendClientMessageEx(playerid, COLOR_GRAD2, "You don't own a home!"), GameTextForPlayer(playerid, "~w~You are homeless", 5000, 1);
	new home;
	if(sscanf(params, "d", home) || !(1 <= home <= 3)) return SendClientMessageEx(playerid, COLOR_GRAD2, "USAGE: /home [1, 2 or 3]");
	switch(home)
	{
		case 1:
		{
			if(PlayerInfo[playerid][pPhousekey] == INVALID_HOUSE_ID) return SendClientMessageEx(playerid, COLOR_GRAD2, "You do not own a house in that slot.");
			SetPlayerCheckpoint(playerid,HouseInfo[PlayerInfo[playerid][pPhousekey]][hExteriorX], HouseInfo[PlayerInfo[playerid][pPhousekey]][hExteriorY], HouseInfo[PlayerInfo[playerid][pPhousekey]][hExteriorZ], 4.0);
			SetPVarInt(playerid, "hInviteHouse", PlayerInfo[playerid][pPhousekey]);
		}
		case 2:
		{
			if(PlayerInfo[playerid][pPhousekey2] == INVALID_HOUSE_ID) return SendClientMessageEx(playerid, COLOR_GRAD2, "You do not own a house in that slot.");
			SetPlayerCheckpoint(playerid,HouseInfo[PlayerInfo[playerid][pPhousekey2]][hExteriorX], HouseInfo[PlayerInfo[playerid][pPhousekey2]][hExteriorY], HouseInfo[PlayerInfo[playerid][pPhousekey2]][hExteriorZ], 4.0);
			SetPVarInt(playerid, "hInviteHouse", PlayerInfo[playerid][pPhousekey2]);
		}
		case 3:
		{
			if(PlayerInfo[playerid][pPhousekey3] == INVALID_HOUSE_ID) return SendClientMessageEx(playerid, COLOR_GRAD2, "You do not own a house in that slot.");
			SetPlayerCheckpoint(playerid,HouseInfo[PlayerInfo[playerid][pPhousekey3]][hExteriorX], HouseInfo[PlayerInfo[playerid][pPhousekey3]][hExteriorY], HouseInfo[PlayerInfo[playerid][pPhousekey3]][hExteriorZ], 4.0);
			SetPVarInt(playerid, "hInviteHouse", PlayerInfo[playerid][pPhousekey3]);
		}
	}
	GameTextForPlayer(playerid, "~w~Waypoint set ~r~Home", 5000, 1);
	gPlayerCheckpointStatus[playerid] = CHECKPOINT_HOME;
    return 1;
}
