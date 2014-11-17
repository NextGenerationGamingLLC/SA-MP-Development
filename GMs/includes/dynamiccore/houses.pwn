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

CMD:sellmyhouse(playerid, params[])
{
	if(servernumber == 2) return SendClientMessage(playerid, COLOR_WHITE, "This command is disabled!");
	if(Homes[playerid] > 0)
	{
		if(PlayerInfo[playerid][pFreezeHouse] == 1) return SendClientMessageEx(playerid, COLOR_WHITE, "ERROR: Your house assets are frozen, you cannot sell your house!");
		new string[128], giveplayerid, price;
		if(sscanf(params, "ud", giveplayerid, price)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /sellmyhouse [player] [price]");
		if(price < 1) return SendClientMessageEx(playerid, COLOR_GREY, "Price must be higher than 0.");
		if(!IsPlayerConnected(giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "Player is currently not connected to the server.");
		if(Homes[giveplayerid] >= MAX_OWNABLE_HOUSES && PlayerInfo[giveplayerid][pDonateRank] < 4) return SendClientMessageEx(playerid, COLOR_GREY, "They cannot own another home.");
		if(Homes[giveplayerid] >= 3) return SendClientMessageEx(playerid, COLOR_GREY, "They cannot own another home.");		
		if(PlayerInfo[giveplayerid][pFreezeHouse] == 1)
		{
			SendClientMessageEx(giveplayerid, COLOR_WHITE, "ERROR: Your house assets are frozen, you cannot buy a house!");
			SendClientMessageEx(playerid, COLOR_WHITE, "ERROR: Their house assets are frozen, you cannot sell them a house!");
			return 1;
		}

		for(new i; i < MAX_HOUSES; i++)
		{
			if(GetPlayerSQLId(playerid) == HouseInfo[i][hOwnerID] && IsPlayerInRangeOfPoint(playerid, 3.0, HouseInfo[i][hExteriorX], HouseInfo[i][hExteriorY], HouseInfo[i][hExteriorZ]) && GetPlayerVirtualWorld(playerid) == HouseInfo[i][hExtVW] && GetPlayerInterior(playerid) == HouseInfo[i][hExtIW])
			{
				if(PlayerInfo[giveplayerid][pLevel] >= HouseInfo[i][hLevel])
				{
					if(ProxDetectorS(8.0, playerid, giveplayerid) && GetPlayerVirtualWorld(giveplayerid) == HouseInfo[i][hExtVW] && GetPlayerInterior(giveplayerid) == HouseInfo[i][hExtIW])
					{
						if(PlayerInfo[playerid][pBackpack] > 0 && HouseInfo[i][hSQLId] == PlayerInfo[playerid][pBStoredH] && !GetPVarInt(playerid, "confirmhousell")) 
						{
							SetPVarInt(playerid, "confirmhousell", 1);
							return SendClientMessageEx(playerid, COLOR_WHITE, "ERROR: You have a backpack stored in this house, withdraw it first or you will loose it, please confirm!");
						}
						HouseOffer[giveplayerid] = playerid;
						HousePrice[giveplayerid] = price;
						House[giveplayerid] = i;
						format(string, sizeof(string), "* You offered %s to buy your house for $%s.", GetPlayerNameEx(giveplayerid), number_format(price));
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
						format(string, sizeof(string), "* %s has offered you their house for $%s, (type /accept house) to buy.", GetPlayerNameEx(playerid), number_format(price));
						SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
						DeletePVar(playerid, "confirmhousell");
						return 1;
					}
					else return SendClientMessageEx(playerid, COLOR_GREY, "That person is not near you.");
				}
				else return SendClientMessageEx(playerid, COLOR_GREY, "The person you are trying to sell your house to is not the appropriate level to buy this house.");
			}
		}
		SendClientMessageEx(playerid, COLOR_GREY, "You are not at a house that you own.");
	}
	else return SendClientMessageEx(playerid, COLOR_GREY, "You don't own a house.");
    return 1;
}

CMD:asellhouse(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] >= 1337)
	{
		new playername[MAX_PLAYER_NAME];
		GetPlayerName(playerid, playername, sizeof(playername));

		new string[128], house;
		if(sscanf(params, "d", house)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /asellhouse [houseid]");

		HouseInfo[house][hLock] = 1;
		new ip[32];
		GetPlayerIp(playerid,ip,sizeof(ip));
		format(string,sizeof(string),"Administrator %s (IP: %s) has admin-sold house ID %d (was owned by %s(%d)).", GetPlayerNameEx(playerid), ip, house, HouseInfo[house][hOwnerName], HouseInfo[house][hOwnerID]);
		Log("logs/house.log", string);
		ClearHouse(house);
		format( HouseInfo[house][hOwnerName], 128, "Nobody" );
		HouseInfo[house][hOwnerID] = -1;
		HouseInfo[house][hGLUpgrade] = 1;
		PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
		format(string, sizeof(string), "~w~You have sold house %d.", house);
		GameTextForPlayer(playerid, string, 10000, 3);
		SaveHouse(house);
		DestroyDynamicPickup(HouseInfo[house][hPickupID]);
		HouseInfo[house][hPickupID] = CreateDynamicPickup(1273, 23, HouseInfo[house][hExteriorX], HouseInfo[house][hExteriorY], HouseInfo[house][hExteriorZ], .worldid = HouseInfo[house][hExtVW], .interiorid = HouseInfo[house][hExtIW]);
		DestroyDynamic3DTextLabel(HouseInfo[house][hTextID]);
		format(string, sizeof(string), "This home is\n for sale!\n Description: %s\nCost: $%d\n Level: %d\n/buyhouse to buy it.",HouseInfo[house][hDescription],HouseInfo[house][hValue],HouseInfo[house][hLevel]);
		HouseInfo[house][hTextID] = CreateDynamic3DTextLabel( string, COLOR_GREEN, HouseInfo[house][hExteriorX], HouseInfo[house][hExteriorY], HouseInfo[house][hExteriorZ]+0.5, 10.0, .testlos = 1, .worldid = HouseInfo[house][hExtVW], .interiorid = HouseInfo[house][hExtIW], .streamdistance = 10.0);
		return 1;
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use that command.");
	}
	return 1;
}

CMD:goinhouse(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pShopTech] >= 1)
	{
		new string[48], housenum;
		if(sscanf(params, "d", housenum)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /goinhouse [housenumber]");

		if(housenum <= 0 || housenum >= MAX_HOUSES)
		{
			format(string, sizeof(string), "House ID must be between 1 and %d.", MAX_HOUSES - 1);
			return SendClientMessageEx(playerid, COLOR_GREY, string);
		}

		SetPlayerInterior(playerid,HouseInfo[housenum][hIntIW]);
		SetPlayerPos(playerid, HouseInfo[housenum][hInteriorX], HouseInfo[housenum][hInteriorY], HouseInfo[housenum][hInteriorZ]);
		GameTextForPlayer(playerid, "~w~Teleporting", 5000, 1);
		PlayerInfo[playerid][pInt] = HouseInfo[housenum][hIntIW];
		PlayerInfo[playerid][pVW] = HouseInfo[housenum][hIntVW];
  		SetPlayerVirtualWorld(playerid,HouseInfo[housenum][hIntVW]);
		if(HouseInfo[housenum][hCustomInterior] == 1) Player_StreamPrep(playerid, HouseInfo[housenum][hInteriorX],HouseInfo[housenum][hInteriorY],HouseInfo[housenum][hInteriorZ], FREEZE_TIME);
	}
	return 1;
}

CMD:gotohouse(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pShopTech] >= 1)
	{
		new string[48], housenum;
		if(sscanf(params, "d", housenum)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /gotohouse [housenumber]");

		if(housenum <= 0 || housenum >= MAX_HOUSES)
		{
			format(string, sizeof(string), "House ID must be between 1 and %d.", MAX_HOUSES - 1);
			return SendClientMessageEx(playerid, COLOR_GREY, string);
		}

		SetPlayerPos(playerid, HouseInfo[housenum][hExteriorX], HouseInfo[housenum][hExteriorY], HouseInfo[housenum][hExteriorZ]);
		PlayerInfo[playerid][pInt] = HouseInfo[housenum][hExtIW];
		SetPlayerInterior(playerid,HouseInfo[housenum][hExtIW]);
		PlayerInfo[playerid][pVW] = HouseInfo[housenum][hExtVW];
  		SetPlayerVirtualWorld(playerid,HouseInfo[housenum][hExtVW]);
		GameTextForPlayer(playerid, "~w~Teleporting", 5000, 1);
		SetPlayerInterior(playerid, 0);
		PlayerInfo[playerid][pInt] = 0;
	}
	return 1;
}

CMD:hnext(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pShopTech] >= 1)
	{
		SendClientMessageEx(playerid, COLOR_RED, "* Listing next available house...");
		for(new x;x<MAX_HOUSES;x++)
		{
		    if(HouseInfo[x][hExteriorX] == 0.0) // If the house is at blueberry!
		    {
		        new string[128];
		        format(string, sizeof(string), "%d is available to use.", x);
		        SendClientMessageEx(playerid, COLOR_WHITE, string);
		        break;
			}
		}
	}
	else
	{
	    SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use that command.");
		return 1;
	}
	return 1;
}

CMD:hname(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use that command.");
		return 1;
	}

	new string[128], houseid, ownername[24];
	if(sscanf(params, "ds[24]", houseid, ownername)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /hname [houseid] [name]");

	format(HouseInfo[houseid][hOwnerName], 24, "%s", ownername);
	format(string, sizeof(string), "You have set the house owner to %s", ownername);
	HouseInfo[houseid][hOwned] = 1;
	SendClientMessageEx(playerid, COLOR_WHITE, string);
	ReloadHouseText(houseid);
	SaveHouse(houseid);

	format(string, sizeof(string), "%s has edited HouseID %d's Owner to %s.", GetPlayerNameEx(playerid), houseid, ownername);
	Log("logs/hedit.log", string);

	return 1;
}

CMD:hedit(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pShopTech] < 1)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use that command.");
		return 1;
	}

	new string[128], choice[32], houseid, amount;
	if(sscanf(params, "s[32]dD", choice, houseid, amount))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /hedit [name] [houseid] [(Optional)amount]");
		SendClientMessageEx(playerid, COLOR_GREY, "Available names: Exterior, Interior, VW, CustomInterior, CustomExterior, Class (1-3), Level, Price, Delete");
		return 1;
	}

	if(strcmp(choice, "delete", true) == 0)
	{
		if(HouseInfo[houseid][hExteriorX] == 0.0) return SendClientMessageEx(playerid, COLOR_GRAD1, "This house does not exist!");
		// Do not reset the SQL ID as the house still exists but is not owned by any player and it isn't spawned
		HouseInfo[houseid][hOwned] = 0;
		HouseInfo[houseid][hLevel] = 0;
		HouseInfo[houseid][hCustomInterior] = 0;
		HouseInfo[houseid][hOwnerID] = -1;
		format(HouseInfo[houseid][hOwnerName], 128, "Nobody");
		HouseInfo[houseid][hExteriorX] = 0.0;
		HouseInfo[houseid][hExteriorY] = 0.0;
		HouseInfo[houseid][hExteriorZ] = 0.0;
		HouseInfo[houseid][hExteriorR] = 0.0;
		HouseInfo[houseid][hExteriorA] = 0.0;
		HouseInfo[houseid][hInteriorX] = 0.0;
		HouseInfo[houseid][hInteriorY] = 0.0;
		HouseInfo[houseid][hInteriorZ] = 0.0;
		HouseInfo[houseid][hInteriorR] = 0.0;
		HouseInfo[houseid][hInteriorA] = 0.0;
		HouseInfo[houseid][hExtIW] = 0;
		HouseInfo[houseid][hExtVW] = 0;
		HouseInfo[houseid][hIntIW] = 0;
		HouseInfo[houseid][hIntVW] = 0;
		HouseInfo[houseid][hLock] = 0;
		HouseInfo[houseid][hRentable] = 0;
		HouseInfo[houseid][hRentFee] = 0;
		HouseInfo[houseid][hValue] = 0;
		HouseInfo[houseid][hSafeMoney] = 0;
		HouseInfo[houseid][hPot] = 0;
		HouseInfo[houseid][hCrack] = 0;
		HouseInfo[houseid][hMaterials] = 0;
		HouseInfo[houseid][hHeroin] = 0;
		HouseInfo[houseid][hWeapons][0] = 0;
		HouseInfo[houseid][hWeapons][1] = 0;
		HouseInfo[houseid][hWeapons][2] = 0;
		HouseInfo[houseid][hWeapons][3] = 0;
		HouseInfo[houseid][hWeapons][4] = 0;
		HouseInfo[houseid][hGLUpgrade] = 0;
		if(IsValidDynamicPickup(HouseInfo[houseid][hPickupID])) DestroyDynamicPickup(HouseInfo[houseid][hPickupID]);
		if(IsValidDynamic3DTextLabel(HouseInfo[houseid][hTextID])) DestroyDynamic3DTextLabel(HouseInfo[houseid][hTextID]);
		HouseInfo[houseid][hCustomExterior] = 0;
		HouseInfo[houseid][hMailX] = 0.0;
		HouseInfo[houseid][hMailY] = 0.0;
		HouseInfo[houseid][hMailZ] = 0.0;
		HouseInfo[houseid][hMailA] = 0.0;
		HouseInfo[houseid][hMailType] = 0;
		if(IsValidDynamicObject(HouseInfo[houseid][hMailObjectId])) DestroyDynamicObject(HouseInfo[houseid][hMailObjectId]);
		if(IsValidDynamic3DTextLabel(HouseInfo[houseid][hMailTextID])) DestroyDynamic3DTextLabel(HouseInfo[houseid][hMailTextID]);
		HouseInfo[houseid][hClosetX] = 0.0;
		HouseInfo[houseid][hClosetY] = 0.0;
		HouseInfo[houseid][hClosetZ] = 0.0;
		if(IsValidDynamic3DTextLabel(HouseInfo[houseid][hClosetTextID])) DestroyDynamic3DTextLabel(HouseInfo[houseid][hClosetTextID]);
		SaveHouse(houseid);
		format(string, sizeof(string), "You have deleted house id %d.", houseid);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "%s has deleted house id %d", GetPlayerNameEx(playerid), houseid);
		Log("logs/hedit.log", string);
		return true;
	}
	else if(strcmp(choice, "interior", true) == 0)
	{
		new Float: Pos[3];
		GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
		format(string, sizeof(string), "%s has edited HouseID %d's Interior. (Before:  %f, %f, %f | After: %f, %f, %f)", GetPlayerNameEx(playerid), houseid, HouseInfo[houseid][hInteriorX], HouseInfo[houseid][hInteriorY], HouseInfo[houseid][hInteriorZ], Pos[0], Pos[1], Pos[2]);
		Log("logs/hedit.log", string);
		GetPlayerPos(playerid, HouseInfo[houseid][hInteriorX], HouseInfo[houseid][hInteriorY], HouseInfo[houseid][hInteriorZ]);
		GetPlayerFacingAngle(playerid, HouseInfo[houseid][hInteriorA]);
		HouseInfo[houseid][hIntIW] = GetPlayerInterior( playerid );
		HouseInfo[houseid][hIntVW] = houseid+6000;
		SendClientMessageEx( playerid, COLOR_WHITE, "You have changed the interior!" );
		SaveHouse(houseid);
		return 1;
	}
	else if(strcmp(choice, "custominterior", true) == 0)
	{
		if(HouseInfo[houseid][hCustomInterior] == 0)
		{
			HouseInfo[houseid][hCustomInterior] = 1;
			SendClientMessageEx( playerid, COLOR_WHITE, "House set to custom interior!" );
		}
		else
		{
			HouseInfo[houseid][hCustomInterior] = 0;
			SendClientMessageEx( playerid, COLOR_WHITE, "House set to normal (not custom) interior!" );
		}
		SaveHouse(houseid);

		format(string, sizeof(string), "%s has edited HouseID %d's Custom Interior.", GetPlayerNameEx(playerid), houseid);
		Log("logs/hedit.log", string);
		return 1;
	}
	else if(strcmp(choice, "customexterior", true) == 0)
	{
		if(HouseInfo[houseid][hCustomExterior] == 0)
		{
			HouseInfo[houseid][hCustomExterior] = 1;
			SendClientMessageEx( playerid, COLOR_WHITE, "House set to custom exterior!" );
		}
		else
		{
			HouseInfo[houseid][hCustomExterior] = 0;
			SendClientMessageEx( playerid, COLOR_WHITE, "House set to normal (not custom) exterior!" );
		}
		SaveHouse(houseid);

		format(string, sizeof(string), "%s has edited HouseID %d's Custom Exterior.", GetPlayerNameEx(playerid), houseid);
		Log("logs/hedit.log", string);
		return 1;
	}
	else if(strcmp(choice, "exterior", true) == 0)
	{
	    new Float: Pos[3];
		GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
		format(string, sizeof(string), "%s has edited HouseID %d's Exterior. (Before:  %f, %f, %f | After: %f, %f, %f)", GetPlayerNameEx(playerid), houseid,  HouseInfo[houseid][hExteriorX], HouseInfo[houseid][hExteriorY], HouseInfo[houseid][hExteriorZ], Pos[0], Pos[1], Pos[2]);
		Log("logs/hedit.log", string);
		GetPlayerPos(playerid, HouseInfo[houseid][hExteriorX], HouseInfo[houseid][hExteriorY], HouseInfo[houseid][hExteriorZ]);
		GetPlayerFacingAngle(playerid, HouseInfo[houseid][hExteriorA]);
		HouseInfo[houseid][hExtIW] = GetPlayerInterior(playerid);
		HouseInfo[houseid][hExtVW] = GetPlayerVirtualWorld(playerid);
		SendClientMessageEx( playerid, COLOR_WHITE, "You have changed the exterior!" );
		SaveHouse(houseid);
		ReloadHousePickup(houseid);
	}
	else if(strcmp(choice, "VW", true) == 0)
	{
		HouseInfo[houseid][hIntVW] = amount;

		format(string, sizeof(string), "You have changed the home's interior VW to %d.", amount);
		SendClientMessageEx(playerid, COLOR_WHITE, string);

		SaveHouse(houseid);
		format(string, sizeof(string), "%s has edited House ID %d's interior VW to %d.", GetPlayerNameEx(playerid), houseid, amount);
		Log("logs/hedit.log", string);
		return 1;
	}
	else if(strcmp(choice, "level", true) == 0)
	{
		HouseInfo[houseid][hLevel] = amount;
		format(string, sizeof(string), "You have set the house level to %d.", amount);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		ReloadHouseText(houseid);
		format(string, sizeof(string), "%s has edited HouseID %d's Level to %d.", GetPlayerNameEx(playerid), houseid, amount);
		Log("logs/hedit.log", string);
	}
	else if(strcmp(choice, "price", true) == 0)
	{
		HouseInfo[houseid][hValue] = amount;
		format(string, sizeof(string), "You have set the houses price to $%d.", amount );
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		ReloadHouseText(houseid);

		format(string, sizeof(string), "%s has edited HouseID %d's Price to $%d.", GetPlayerNameEx(playerid), amount);
		Log("logs/hedit.log", string);
	}
	else if(strcmp(choice, "class", true) == 0)
	{
		switch(amount)
		{
		case 1:
			{
				format(HouseInfo[houseid][hDescription], 128, "Low" );
				SendClientMessageEx(playerid, COLOR_WHITE, "You have set the house's class to 1 (Low)" );
			}
		case 2:
			{
				format(HouseInfo[houseid][hDescription], 128, "Medium" );
				SendClientMessageEx(playerid, COLOR_WHITE, "You have set the house's class to 2 (Medium)" );
			}
		case 3:
			{
				format(HouseInfo[houseid][hDescription], 128, "High" );
				SendClientMessageEx(playerid, COLOR_WHITE, "You have set the house's class to 3 (High)" );
			}
		}
		if(HouseInfo[houseid][hOwned] ==0)
		{
			format(string, sizeof(string), "This home is\n for sale!\n Description: %s\nCost: $%d\n Level: %d\nID: %d\nTo buy this house type /buyhouse",HouseInfo[houseid][hDescription],HouseInfo[houseid][hValue],HouseInfo[houseid][hLevel],houseid);
			UpdateDynamic3DTextLabelText(HouseInfo[houseid][hTextID], COLOR_GREEN, string);
		}

		format(string, sizeof(string), "%s has edited HouseID %d's Class to %d.", GetPlayerNameEx(playerid), houseid, amount);
		Log("logs/hedit.log", string);
	}
	SaveHouse(houseid);
	return 1;
}

CMD:shophouse(playerid, params[])
{
	if(PlayerInfo[playerid][pShopTech] < 1) return SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use that command.");
	/*if(!IsPlayerAdmin(playerid) || PlayerInfo[playerid][pAdmin] != 99999)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use that command.");
		return 1;
	}*/

	new string[128], choice[32], houseid, amount, invoice[64];
	if(sscanf(params, "s[32]dDs[64]", choice, houseid, amount, invoice))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /shophouse [name] [houseid] [amount] [invoice #]");
		SendClientMessageEx(playerid, COLOR_GREY, "Available names: Exterior, Interior, CustomInterior, Class (1-3), Level, Price");
		return 1;
	}

	if(strcmp(choice, "interior", true) == 0)
	{
		GetPlayerPos( playerid, HouseInfo[houseid][hInteriorX], HouseInfo[houseid][hInteriorY], HouseInfo[houseid][hInteriorZ] );
		HouseInfo[houseid][hIntIW] = GetPlayerInterior( playerid );
		HouseInfo[houseid][hIntVW] = houseid+6000;
		SendClientMessageEx( playerid, COLOR_WHITE, "You have changed the interior!" );
		SaveHouse(houseid);
		return 1;
	}
	else if(strcmp(choice, "custominterior", true) == 0)
	{
		if(HouseInfo[houseid][hCustomInterior] == 0)
		{
			HouseInfo[houseid][hCustomInterior] = 1;
			SendClientMessageEx( playerid, COLOR_WHITE, "House set to custom interior!" );
		}
		else
		{
			HouseInfo[houseid][hCustomInterior] = 0;
			SendClientMessageEx( playerid, COLOR_WHITE, "House set to normal (not custom) interior!" );
		}
		SaveHouse(houseid);
		return 1;
	}
	else if(strcmp(choice, "customexterior", true) == 0)
	{
		if(HouseInfo[houseid][hCustomExterior] == 0)
		{
			HouseInfo[houseid][hCustomExterior] = 1;
			SendClientMessageEx( playerid, COLOR_WHITE, "House set to custom exterior!" );
		}
		else
		{
			HouseInfo[houseid][hCustomExterior] = 0;
			SendClientMessageEx( playerid, COLOR_WHITE, "House set to normal (not custom) exterior!" );
		}
		SaveHouse(houseid);
		return 1;
	}
	else if(strcmp(choice, "exterior", true) == 0)
	{
		GetPlayerPos( playerid, HouseInfo[houseid][hExteriorX], HouseInfo[houseid][hExteriorY], HouseInfo[houseid][hExteriorZ] );
		HouseInfo[houseid][hExtIW] = GetPlayerInterior(playerid);
		HouseInfo[houseid][hExtVW] = GetPlayerVirtualWorld(playerid);
		SendClientMessageEx( playerid, COLOR_WHITE, "You have changed the exterior!" );
		SaveHouse(houseid);
		ReloadHousePickup(houseid);
	}
	else if(strcmp(choice, "level", true) == 0)
	{
		HouseInfo[houseid][hLevel] = amount;
		format(string, sizeof(string), "You have set the house level to %d.", amount);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		ReloadHouseText(houseid);
	}
	else if(strcmp(choice, "price", true) == 0)
	{
		HouseInfo[houseid][hValue] = amount;
		format(string, sizeof(string), "You have set the houses price to $%d.", amount );
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		ReloadHouseText(houseid);
	}
	else if(strcmp(choice, "class", true) == 0)
	{
		switch(amount)
		{
		case 1:
			{
				format(HouseInfo[houseid][hDescription], 128, "Low" );
				SendClientMessageEx(playerid, COLOR_WHITE, "You have set the house's class to 1 (Low)" );
			}
		case 2:
			{
				format(HouseInfo[houseid][hDescription], 128, "Medium" );
				SendClientMessageEx(playerid, COLOR_WHITE, "You have set the house's class to 2 (Medium)" );
			}
		case 3:
			{
				format(HouseInfo[houseid][hDescription], 128, "High" );
				SendClientMessageEx(playerid, COLOR_WHITE, "You have set the house's class to 3 (High)" );
			}
		}
		if(HouseInfo[houseid][hOwned] ==0)
		{
			format(string, sizeof(string), "This home is\n for sale!\n Description: %s\nCost: $%d\n Level: %d\nID: %d\nTo buy this house type /buyhouse",HouseInfo[houseid][hDescription],HouseInfo[houseid][hValue],HouseInfo[houseid][hLevel],houseid);
			UpdateDynamic3DTextLabelText(HouseInfo[houseid][hTextID], COLOR_GREEN, string);
		}
	}
	SaveHouse(houseid);
	format(string, sizeof(string), "[SHOPHOUSE] %s modified %s on house %d to %d - Invoice %s", GetPlayerNameEx(playerid), choice, houseid, amount, invoice);
	Log("logs/shoplog.log", string);
	return 1;
}

CMD:shophousename(playerid, params[])
{
	if(PlayerInfo[playerid][pShopTech] < 1)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use that command.");
		return 1;
	}

	new string[128], houseid, ownername[MAX_PLAYER_NAME], invoice[64];
	if(sscanf(params, "ds[24]s[64]", houseid, ownername, invoice)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /shophousename [houseid] [name] [invoice]");
	format(HouseInfo[houseid][hOwnerName], sizeof(ownername), "%s", ownername);
	format(string, sizeof(string), "You have set the house owner to %s", ownername);
	HouseInfo[houseid][hOwned] = 1;
	SendClientMessageEx(playerid, COLOR_WHITE, string);
	DestroyDynamicPickup(HouseInfo[houseid][hPickupID]);
	HouseInfo[houseid][hPickupID] = CreateDynamicPickup(1273, 23, HouseInfo[houseid][hExteriorX], HouseInfo[houseid][hExteriorY], HouseInfo[houseid][hExteriorZ], .worldid = HouseInfo[houseid][hExtVW], .interiorid = HouseInfo[houseid][hExtIW]);
	ReloadHouseText(houseid);

	SaveHouse(houseid);
	format(string, sizeof(string), "[SHOPHOUSE] %s modified Owner on house %d to %s - Invoice %s", GetPlayerNameEx(playerid), houseid, ownername, invoice);
	Log("logs/shoplog.log", string);
	return 1;
}

CMD:houseinvite(playerid, params[])
{
	if(Homes[playerid] > 0)
	{
		new giveplayerid, hstring[1024], title[64], zone[MAX_ZONE_NAME];
		if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /houseinvite [player]");
		if(gettime()-GetPVarInt(playerid, "LastHouseInvite") < 15) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can only use /houseinvite once every 15 seconds, please wait!");
		if(giveplayerid != INVALID_PLAYER_ID)
		{
			hInviteOfferTo[playerid] = giveplayerid;
			format(title, sizeof(title), "House Invite for %s", GetPlayerNameEx(giveplayerid));
			for(new i; i < MAX_HOUSES; i++)
			{
				if(GetPlayerSQLId(playerid) == HouseInfo[i][hOwnerID])
				{
					Get3DZone(HouseInfo[i][hExteriorX], HouseInfo[i][hExteriorY], HouseInfo[i][hExteriorZ], zone, MAX_ZONE_NAME);
					format(hstring, sizeof(hstring), "%s\nHouse ID %d - Location: %s", hstring, i, zone);
				}
			}
			ShowPlayerDialog(playerid, DIALOG_HOUSEINVITE, DIALOG_STYLE_LIST, title, hstring, "Select", "Cancel");
		}
		else return SendClientMessageEx(playerid, COLOR_GRAD2, "Invalid player specified.");
	}
	else return SendClientMessageEx(playerid, COLOR_GREY, "You don't own a house.");
	return 1;
}

CMD:hinvite(playerid, params[]) {
	return cmd_houseinvite(playerid, params);
}

CMD:setrentable(playerid, params[])
{
	if(Homes[playerid] > 0)
	{
		for(new i; i < MAX_HOUSES; i++)
		{
			if(GetPlayerSQLId(playerid) == HouseInfo[i][hOwnerID] && ((IsPlayerInRangeOfPoint(playerid, 5.0, HouseInfo[i][hExteriorX], HouseInfo[i][hExteriorY], HouseInfo[i][hExteriorZ]) && GetPlayerVirtualWorld(playerid) == HouseInfo[i][hExtVW] && GetPlayerInterior(playerid) == HouseInfo[i][hExtIW]) ||
			(IsPlayerInRangeOfPoint(playerid, 50, HouseInfo[i][hInteriorX], HouseInfo[i][hInteriorY], HouseInfo[i][hInteriorZ]) && GetPlayerVirtualWorld(playerid) == HouseInfo[i][hIntVW] && GetPlayerInterior(playerid) == HouseInfo[i][hIntIW])))
			{
				if(!HouseInfo[i][hRentable])
				{
					HouseInfo[i][hRentable] = 1;
					ReloadHouseText(i);
					return SendClientMessageEx(playerid, COLOR_WHITE, "This house is now rentable.");
				}
				else
				{
					HouseInfo[i][hRentable] = 0;
					ReloadHouseText(i);
					return SendClientMessageEx(playerid, COLOR_WHITE, "This house is no longer rentable." );
				}
			}
		}
		SendClientMessageEx(playerid, COLOR_GREY, "You're not at a house that you own.");
	}
	else return SendClientMessageEx(playerid, COLOR_GREY, "You don't own a house.");
	return 1;
}

CMD:setrent(playerid, params[])
{
	new string[128], fee;
	if(Homes[playerid] > 0)
	{
		for(new i; i < MAX_HOUSES; i++)
		{
			if(GetPlayerSQLId(playerid) == HouseInfo[i][hOwnerID] && ((IsPlayerInRangeOfPoint(playerid, 5.0, HouseInfo[i][hExteriorX], HouseInfo[i][hExteriorY], HouseInfo[i][hExteriorZ]) && GetPlayerVirtualWorld(playerid) == HouseInfo[i][hExtVW] && GetPlayerInterior(playerid) == HouseInfo[i][hExtIW]) ||
			(IsPlayerInRangeOfPoint(playerid, 50, HouseInfo[i][hInteriorX], HouseInfo[i][hInteriorY], HouseInfo[i][hInteriorZ]) && GetPlayerVirtualWorld(playerid) == HouseInfo[i][hIntVW] && GetPlayerInterior(playerid) == HouseInfo[i][hIntIW])))
			{
				if(sscanf(params, "d", fee)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /setrent [fee]");
				if(!(1 <= fee <= 10000)) return SendClientMessageEx(playerid, COLOR_WHITE, "Minimum rent is $1, maximum rent is $10,000.");
				else
				{
					HouseInfo[i][hRentFee] = fee;
					format(string, sizeof(string), "You have set your house's rent fee to $%s.", number_format(HouseInfo[i][hRentFee]));
					SendClientMessageEx(playerid, COLOR_WHITE, string);

					ReloadHouseText(i);
					return 1;
				}
			}
		}
		SendClientMessageEx(playerid, COLOR_GREY, "You're not at a house that you own.");
	}
	else return SendClientMessageEx(playerid, COLOR_GREY, "You don't own a house.");
	return 1;
}

CMD:evict(playerid, params[])
{
	new string[128], giveplayerid;
	if(Homes[playerid] > 0)
	{
		for(new i; i < MAX_HOUSES; i++)
		{
			if(GetPlayerSQLId(playerid) == HouseInfo[i][hOwnerID] && ((IsPlayerInRangeOfPoint(playerid, 5.0, HouseInfo[i][hExteriorX], HouseInfo[i][hExteriorY], HouseInfo[i][hExteriorZ]) && GetPlayerVirtualWorld(playerid) == HouseInfo[i][hExtVW] && GetPlayerInterior(playerid) == HouseInfo[i][hExtIW]) ||
			(IsPlayerInRangeOfPoint(playerid, 50, HouseInfo[i][hInteriorX], HouseInfo[i][hInteriorY], HouseInfo[i][hInteriorZ]) && GetPlayerVirtualWorld(playerid) == HouseInfo[i][hIntVW] && GetPlayerInterior(playerid) == HouseInfo[i][hIntIW])))
			{
				if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /evict [player]");
				if(IsPlayerConnected(giveplayerid))
				{
					if(giveplayerid == playerid) return SendClientMessageEx(playerid, COLOR_WHITE, "You can't evict yourself.");
					else if(PlayerInfo[giveplayerid][pRenting] == i)
					{
						format(string, sizeof(string), "%s has evicted you from their house.", GetPlayerNameEx(playerid));
						SendClientMessageEx(giveplayerid, COLOR_WHITE, string);

						format(string, sizeof(string), "You have evicted %s from your house.", GetPlayerNameEx(giveplayerid));
						SendClientMessageEx(playerid, COLOR_WHITE, string);

						PlayerInfo[giveplayerid][pRenting] = INVALID_HOUSE_ID;
						return 1;
					}
					else return SendClientMessageEx(playerid, COLOR_WHITE, "That person isn't renting at your house.");
				}
				else return SendClientMessageEx(playerid, COLOR_GRAD2, "Invalid player specified.");
			}
		}
		SendClientMessageEx(playerid, COLOR_GREY, "You're not at a house that you own.");
	}
	else return SendClientMessageEx(playerid, COLOR_GREY, "You don't own a house.");
	return 1;
}

CMD:evictall(playerid, params[])
{
	if(Homes[playerid] > 0)
	{
		for(new i; i < MAX_HOUSES; i++)
		{
			if(GetPlayerSQLId(playerid) == HouseInfo[i][hOwnerID] && ((IsPlayerInRangeOfPoint(playerid, 5.0, HouseInfo[i][hExteriorX], HouseInfo[i][hExteriorY], HouseInfo[i][hExteriorZ]) && GetPlayerVirtualWorld(playerid) == HouseInfo[i][hExtVW] && GetPlayerInterior(playerid) == HouseInfo[i][hExtIW]) ||
			(IsPlayerInRangeOfPoint(playerid, 50, HouseInfo[i][hInteriorX], HouseInfo[i][hInteriorY], HouseInfo[i][hInteriorZ]) && GetPlayerVirtualWorld(playerid) == HouseInfo[i][hIntVW] && GetPlayerInterior(playerid) == HouseInfo[i][hIntIW])))
			{
				new giveplayerid, string[56];
				//foreach(new p: Player)
				for(new p = 0; p < MAX_PLAYERS; ++p)
				{
					if(IsPlayerConnected(p))
					{
						if(PlayerInfo[p][pRenting] == i)
						{
							format(string, sizeof(string), "%s has evicted you from their house.", GetPlayerNameEx(playerid));
							SendClientMessageEx(p, COLOR_WHITE, string);
							PlayerInfo[p][pRenting] = INVALID_HOUSE_ID;
							++giveplayerid;
						}
					}	
				}
				format(string, sizeof(string), "%d online players have been evicted from your house.", giveplayerid);
				return SendClientMessageEx(playerid, COLOR_WHITE, string);
			}
		}
		SendClientMessageEx(playerid, COLOR_GREY, "You're not at a house that you own.");
	}
	else return SendClientMessageEx(playerid, COLOR_GREY, "You don't own a house.");
	return 1;
}

CMD:lockhouse(playerid, params[])
{
	if(PlayerInfo[playerid][pFreezeHouse] != 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot do this while having your assets frozen!");
	if(Homes[playerid] > 0)
	{
		for(new i; i < MAX_HOUSES; i++)
		{
			if(GetPlayerSQLId(playerid) == HouseInfo[i][hOwnerID] && ((IsPlayerInRangeOfPoint(playerid, 5.0, HouseInfo[i][hExteriorX], HouseInfo[i][hExteriorY], HouseInfo[i][hExteriorZ]) && GetPlayerVirtualWorld(playerid) == HouseInfo[i][hExtVW] && GetPlayerInterior(playerid) == HouseInfo[i][hExtIW]) ||
			(IsPlayerInRangeOfPoint(playerid, 5.0, HouseInfo[i][hInteriorX], HouseInfo[i][hInteriorY], HouseInfo[i][hInteriorZ]) && GetPlayerVirtualWorld(playerid) == HouseInfo[i][hIntVW] && GetPlayerInterior(playerid) == HouseInfo[i][hIntIW])))
			{
				new szMessage[30 + MAX_PLAYER_NAME];

				if(HouseInfo[i][hLock] == 1)
				{
					HouseInfo[i][hLock] = 0;
					format(szMessage, sizeof(szMessage), "* %s has unlocked their house.", GetPlayerNameEx(playerid));
					return ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				}
				else
				{
					HouseInfo[i][hLock] = 1;
					format(szMessage, sizeof(szMessage), "* %s has locked their house.", GetPlayerNameEx(playerid));
					return ProxDetector(30.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				}
			}
		}
		SendClientMessageEx(playerid, COLOR_GREY, "You're not at a house that you own.");
	}
	else return SendClientMessageEx(playerid, COLOR_GREY, "You don't own a house.");
	return 1;
}

CMD:hstatus(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pShopTech] < 1) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	new hid;
	if(sscanf(params, "i", hid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /hstatus [hid]");
	new string[128];
	format(string,sizeof(string),"|___________ House Status (ID: %d) (OwnerID: %d)___________|", hid, HouseInfo[hid][hOwnerID]);
	SendClientMessageEx(playerid, COLOR_GREEN, string);
	format(string, sizeof(string), "(Ext) X: %f | Y: %f | Z: %f | (Int) X: %f | Y: %f | Z: %f", HouseInfo[hid][hExteriorX], HouseInfo[hid][hExteriorY], HouseInfo[hid][hExteriorZ], HouseInfo[hid][hInteriorX], HouseInfo[hid][hInteriorY], HouseInfo[hid][hInteriorZ]);
	SendClientMessageEx(playerid, COLOR_WHITE, string);
	format(string, sizeof(string), "Custom Int: %d | Custom Ext: %d | Exterior VW: %d | Exterior Int: %d | Interior VW: %d | Interior Int: %d", HouseInfo[hid][hCustomInterior], HouseInfo[hid][hCustomExterior], HouseInfo[hid][hExtVW], HouseInfo[hid][hExtIW], HouseInfo[hid][hIntVW], HouseInfo[hid][hIntIW]);
	SendClientMessageEx(playerid, COLOR_WHITE, string);
	format(string, sizeof(string), "Money: %d | Pot: %d | Crack: %d | Heroin: %d | Materials: %d", HouseInfo[hid][hSafeMoney], HouseInfo[hid][hPot], HouseInfo[hid][hCrack], HouseInfo[hid][hHeroin], HouseInfo[hid][hMaterials]);
	SendClientMessageEx(playerid, COLOR_WHITE, string);
	format(string, sizeof(string), "Weapons - %d | %d | %d | %d | %d | GLUpgrade: %d", HouseInfo[hid][hWeapons][0], HouseInfo[hid][hWeapons][1], HouseInfo[hid][hWeapons][2], HouseInfo[hid][hWeapons][3], HouseInfo[hid][hWeapons][4], HouseInfo[hid][hGLUpgrade]);
	SendClientMessageEx(playerid, COLOR_WHITE, string);
	format(string, sizeof(string), "Mailbox - Type: %d | X: %f | Y: %f | Z: %f", HouseInfo[hid][hMailType], HouseInfo[hid][hMailX], HouseInfo[hid][hMailY], HouseInfo[hid][hMailZ]);
	SendClientMessageEx(playerid, COLOR_WHITE, string);
	format(string, sizeof(string), "Closet - X: %f | Y: %f | Z: %f", HouseInfo[hid][hClosetX], HouseInfo[hid][hClosetY], HouseInfo[hid][hClosetZ]);
	SendClientMessageEx(playerid, COLOR_WHITE, string);
	format(string, sizeof(string), "Sale Sign - X: %f | Y: %f | Z: %f", HouseInfo[hid][hSign][0], HouseInfo[hid][hSign][1], HouseInfo[hid][hSign][2]);
	SendClientMessageEx(playerid, COLOR_WHITE, string);
	format(string, sizeof(string), "Sale Sign - Description: %s | Expires in: %s", HouseInfo[hid][hSignDesc], (HouseInfo[hid][hSignExpire]) ? ConvertTimeS(HouseInfo[hid][hSignExpire]-gettime()):("None"));
	SendClientMessageEx(playerid, COLOR_WHITE, string);
	return 1;
}

CMD:hnear(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pShopTech] >= 1)
	{
		new option;
		if(!sscanf(params, "d", option)) 
		{
			new string[64];
			format(string, sizeof(string), "* Listing all houses within 30 meters of you in VW %d...", option);
			SendClientMessageEx(playerid, COLOR_RED, string);
			for(new i, szMessage[128]; i < MAX_HOUSES; i++)
			{
				if(IsPlayerInRangeOfPoint(playerid, 30, HouseInfo[i][hInteriorX], HouseInfo[i][hInteriorY], HouseInfo[i][hInteriorZ]) && HouseInfo[i][hIntVW] == option)
				{
					format(szMessage, sizeof(szMessage), "(Interior) House ID %d | %f from you | Interior: %d", i, GetPlayerDistanceFromPoint(playerid, HouseInfo[i][hInteriorX], HouseInfo[i][hInteriorY], HouseInfo[i][hInteriorZ]), HouseInfo[i][hIntIW]);
					SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
				}
				if(IsPlayerInRangeOfPoint(playerid, 30, HouseInfo[i][hExteriorX], HouseInfo[i][hExteriorY], HouseInfo[i][hExteriorZ]) && HouseInfo[i][hExtVW] == option)
				{
					format(szMessage, sizeof(szMessage), "(Exterior) House ID %d | %f from you | Interior: %d", i, GetPlayerDistanceFromPoint(playerid, HouseInfo[i][hExteriorX], HouseInfo[i][hExteriorY], HouseInfo[i][hExteriorZ]), HouseInfo[i][hExtIW]);
					SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
				}
			}
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_RED, "* Listing all houses within 30 meters of you...");
			for(new i, szMessage[128]; i < MAX_HOUSES; i++)
			{
				if(IsPlayerInRangeOfPoint(playerid, 30, HouseInfo[i][hInteriorX], HouseInfo[i][hInteriorY], HouseInfo[i][hInteriorZ]))
				{
					format(szMessage, sizeof(szMessage), "(Interior) House ID %d | %f from you | Virtual World: %d | Interior: %d", i, GetPlayerDistanceFromPoint(playerid, HouseInfo[i][hInteriorX], HouseInfo[i][hInteriorY], HouseInfo[i][hInteriorZ]), HouseInfo[i][hIntVW], HouseInfo[i][hIntIW]);
					SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
				}
				if(IsPlayerInRangeOfPoint(playerid, 30, HouseInfo[i][hExteriorX], HouseInfo[i][hExteriorY], HouseInfo[i][hExteriorZ]))
				{
					format(szMessage, sizeof(szMessage), "(Exterior) House ID %d | %f from you | Virtual World: %d | Interior: %d", i, GetPlayerDistanceFromPoint(playerid, HouseInfo[i][hExteriorX], HouseInfo[i][hExteriorY], HouseInfo[i][hExteriorZ]), HouseInfo[i][hExtVW], HouseInfo[i][hExtIW]);
					SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
				}
			}
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use that command.");
	}
	return 1;
}