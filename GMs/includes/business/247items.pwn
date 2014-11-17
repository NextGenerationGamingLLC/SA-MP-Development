/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						24/7 Items

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

// Going to add these to 24-7 later

/*
CMD:blindfold(playerid, params[]) {
	return cmd_bf(playerid, params);
}

CMD:bf(playerid, params[])
{
	new string[128], giveplayerid;
	if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /(b)lind(f)old [player]");

	if(IsPlayerConnected(giveplayerid))
	{
        if(PlayerInfo[playerid][pMember] == 8 || PlayerInfo[playerid][pLeader] == 8)
		{
	        if(ProxDetectorS(6.0, playerid, giveplayerid))
			{
                new vehicle = GetPlayerVehicleID(playerid);
                if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == 2 && IsPlayerInVehicle(giveplayerid, vehicle))
				{
                    if(GetPVarInt(giveplayerid, "BlindFolded") == 0) {
		    	        if(giveplayerid == playerid) { SendClientMessageEx(playerid, COLOR_GREY, "You may not blindfold yourself."); return 1; }
	  			        format(string, sizeof(string), "%s has placed a blindfold over your eyes, your vision has been blocked.", GetPlayerNameEx(playerid));
				        SendClientMessageEx(giveplayerid, COLOR_WHITE, string);
				        format(string, sizeof(string), "You have placed a blindfold over %s's eyes.", GetPlayerNameEx(giveplayerid));
				        SendClientMessageEx(playerid, COLOR_WHITE, string);
				        format(string, sizeof(string), "* %s has placed a blindfold over %s's eyes.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
				        ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				        TextDrawShowForPlayer(giveplayerid, BFText);
				        SetPVarInt(giveplayerid, "BlindFolded", 1);
				    }
     			    else {
		    	        if(giveplayerid == playerid) { SendClientMessageEx(playerid, COLOR_GREY, " You may not un-blindfold yourself !"); return 1; }
	  			        format(string, sizeof(string), "%s has removed the blindfold from over your eyes !", GetPlayerNameEx(playerid));
				        SendClientMessageEx(giveplayerid, COLOR_WHITE, string);
				        format(string, sizeof(string), " ** You have removed the blindfold from over %s's eyes.", GetPlayerNameEx(giveplayerid));
				        SendClientMessageEx(playerid, COLOR_WHITE, string);
				        format(string, sizeof(string), "* %s has removed a blindfold from over %s's eyes.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
				        ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				        TextDrawHideForPlayer(giveplayerid, BFText);
				        DeletePVar(giveplayerid, "BlindFolded");
    			    }
    		    }
    		    else
    		    {
        		    SendClientMessageEx(playerid, COLOR_GREY, "You must be the driver in order to use this command.");
    			    return 1;
			    }
		    }
		    else
		    {
			    SendClientMessageEx(playerid, COLOR_GREY, " That person is not in-range of you.");
			    return 1;
		    }
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, " You are not allowed to use this command.");
			return 1;
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");
		return 1;
	}
    return 1;
}
*/

CMD:tie(playerid, params[])
{
	if(PlayerInfo[playerid][pRope] > 0)
	{
		new string[128], giveplayerid;
		if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /tie [player]");

		if(IsPlayerConnected(giveplayerid))
		{
			if(PlayerTied[giveplayerid] > 0)
			{
				SendClientMessageEx(playerid, COLOR_GREY, "   person already Tied!");
				return 1;
			}
			if(PlayerCuffed[giveplayerid] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can't tie a cuffed/tazed player.");
			if(PlayerInfo[giveplayerid][pJailTime] > 0)
			{
				SendClientMessageEx(playerid, COLOR_WHITE, "You can't tie a prisoned player." );
				return 1;
			}
			if( PlayerInfo[playerid][pRope] == 0 )
			{
				SendClientMessageEx( playerid, COLOR_WHITE, "You don't have any rope left." );
			}
			else
			{
				if (ProxDetectorS(8.0, playerid, giveplayerid))
				{
					new car = GetPlayerVehicleID(playerid);
					if(giveplayerid == playerid) { SendClientMessageEx(playerid, COLOR_GREY, "You cannot tie up yourself!"); return 1; }
					if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == 2 && IsPlayerInVehicle(giveplayerid, car))
					{
						if(PlayerCuffed[giveplayerid] == 1 || PlayerCuffed[giveplayerid] == 2) {
							SendClientMessageEx(playerid, COLOR_GRAD2, "You can't do this right now.");
							return 1;
						}

						format(string, sizeof(string), "* You were tied up by %s.", GetPlayerNameEx(playerid));
						SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
						format(string, sizeof(string), "* You tied %s up.", GetPlayerNameEx(giveplayerid));
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
						switch( PlayerInfo[giveplayerid][pSex] ) {
							case 1: format(string, sizeof(string), "* %s ties %s up, so he won't go anywhere.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
							case 2: format(string, sizeof(string), "* %s ties %s up, so she won't go anywhere.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
						}
						ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
						GameTextForPlayer(giveplayerid, "~r~Tied", 2500, 3);
						SetPVarInt(giveplayerid, "IsFrozen", 1);
						TogglePlayerControllable(giveplayerid, 0);
						PlayerTied[giveplayerid] = 1;
						PlayerInfo[playerid][pRope]--;
					}
					else
					{
						SendClientMessageEx(playerid, COLOR_GREY, "   person not in your Car, or you are not the Driver!");
						return 1;
					}
				}
				else
				{
					SendClientMessageEx(playerid, COLOR_GREY, "That person isn't near you.");
					return 1;
				}
			}

		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");
			return 1;
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREY, "   You don't have a Rope!");
	}
	return 1;
}

CMD:untie(playerid, params[])
{
	new string[128], giveplayerid;
	if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /untie [player]");

	if(IsPlayerConnected(giveplayerid))
	{
		if (ProxDetectorS(8.0, playerid, giveplayerid))
		{
			if(giveplayerid == playerid) { SendClientMessageEx(playerid, COLOR_GREY, "You cannot Untie yourself!"); return 1; }
			if(PlayerCuffed[giveplayerid] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can't untie a cuffed/tazed player.");
			if(PlayerTied[giveplayerid])
			{
				DeletePVar(giveplayerid, "IsFrozen");
				format(string, sizeof(string), "* You were untied by %s.", GetPlayerNameEx(playerid));
				SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
				format(string, sizeof(string), "* You untied %s.", GetPlayerNameEx(giveplayerid));
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
				GameTextForPlayer(giveplayerid, "~g~Untied", 2500, 3);
				TogglePlayerControllable(giveplayerid, 1);
				PlayerTied[giveplayerid] = 0;
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GREY, "   That person isn't Tied up!");
				return 1;
			}
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "That person isn't near you.");
			return 1;
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");
		return 1;
	}
	return 1;
}

CMD:usesprunk(playerid, params[])
{
	if(GetPVarInt(playerid, "IsInArena") >= 0) return SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this while being in an arena!");
	if(HungerPlayerInfo[playerid][hgInEvent] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "   You cannot do this while being in the Hunger Games Event!");
    #if defined zombiemode
	if(zombieevent == 1 && GetPVarType(playerid, "pIsZombie")) return SendClientMessageEx(playerid, COLOR_GREY, "Zombies can't use this.");
	#endif
	if(PlayerInfo[playerid][pSprunk] > 0)
	{
		if(GetPVarInt(playerid, "UsingSprunk") == 1) return SendClientMessageEx(playerid, COLOR_GRAD1, "You're already drinking a sprunk can.");
		if( PlayerCuffed[playerid] >= 1 || GetPVarInt(playerid, "Injured") == 1 || PlayerInfo[playerid][pHospital] > 0)
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this right now.");
			return 1;
		}

		if(IsPlayerInAnyVehicle(playerid))
		{
			if(IsABike(GetPlayerVehicleID(playerid)))
			{
				SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this on a bike.");
				return 1;
			}
		}
		new string[128];
		SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DRINK_SPRUNK);
		format(string, sizeof(string), "* %s opens a can of sprunk.", GetPlayerNameEx(playerid));
		ProxDetector(15.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		SetPVarInt(playerid, "UsingSprunk", 1);
		SetPVarInt(playerid, "DrinkCooledDown", 1);
		PlayerInfo[playerid][pSprunk]--;
		return 1;
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You don't have any sprunk, buy some from the 24/7!");
		return 1;
	}
}

CMD:usecigar(playerid, params[])
{
	if(PlayerInfo[playerid][pCigar] > 0)
	{
		if( PlayerCuffed[playerid] >= 1 || GetPVarInt(playerid, "Injured") == 1 || PlayerInfo[playerid][pHospital] > 0)
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this right now.");
			return 1;
		}
		new string[128];
		SetPlayerSpecialAction(playerid,SPECIAL_ACTION_SMOKE_CIGGY);
		format(string, sizeof(string), "* %s takes out a cigar and lights it.", GetPlayerNameEx(playerid));
		ProxDetector(15.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		PlayerInfo[playerid][pCigar]--;
		return 1;
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You don't have any cigars, buy some from the 24/7!");
		return 1;
	}
}

CMD:paintcar(playerid, params[]) {
	new iPaintID;
	if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD2, "You're not in a vehicle.");
	if(PlayerInfo[playerid][pSpraycan] == 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "Your spraycan is empty.");
	if(sscanf(params, "i", iPaintID)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /paintcar [0-6] (3 to remove a paintjob)");
	if(!(0 <= iPaintID <= 6)) return SendClientMessageEx(playerid, COLOR_GRAD2, "The specified paint job ID must be between 0 and 6.");
	
	for(new i = 0; i < MAX_PLAYERVEHICLES; i++)
	{
		if(IsPlayerInVehicle(playerid, PlayerVehicleInfo[playerid][i][pvId]))
		{
			PlayerVehicleInfo[playerid][i][pvPaintJob] = iPaintID;
			ChangeVehiclePaintjob(PlayerVehicleInfo[playerid][i][pvId], iPaintID);
			PlayerInfo[playerid][pSpraycan]--;
			g_mysql_SaveVehicle(playerid, i);
			return SendClientMessageEx(playerid, COLOR_GRAD2, "You have successfully applied a paint job to your vehicle.");
		}
	}
	for(new i = 0; i < sizeof(VIPVehicles); i++)
	{
		if(IsPlayerInVehicle(playerid, VIPVehicles[i]))
		{
			ChangeVehiclePaintjob(VIPVehicles[i], iPaintID);
			PlayerInfo[playerid][pSpraycan]--;
			return SendClientMessageEx(playerid, COLOR_GRAD2, "You have successfully applied a paint job to this vehicle.");		
		}
	}
	for(new i = 0; i < sizeof(FamedVehicles); i++)
	{
		if(IsPlayerInVehicle(playerid, FamedVehicles[i]))
		{
			ChangeVehiclePaintjob(FamedVehicles[i], iPaintID);
			PlayerInfo[playerid][pSpraycan]--;
			return SendClientMessageEx(playerid, COLOR_GRAD2, "You have successfully applied a paint job to this vehicle.");
		}
	}	
	SendClientMessageEx(playerid, COLOR_GREY, "You can't spray other people's vehicles.");
	return 1;
}

/*CMD:buylock(playerid, params[])
{
    if(IsAt247(playerid))
	{
	    ShowPlayerDialog(playerid, DIALOG_CDLOCKBUY, DIALOG_STYLE_LIST, "24/7", "Alarm Lock		$10000\nElectric Lock		$500000\nIndustrial Lock		$50000", "Buy", "Cancel");
		return 1;
	}
	else
	{
	    SendClientMessageEx(playerid, COLOR_GRAD2, "   You are not in a 24-7 !");
	}
	return 1;
}*/
