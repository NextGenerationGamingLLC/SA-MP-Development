/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Zombies Event

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

#if defined zombiemode
CMD:zh(playerid, params[])
{
	return cmd_zombiehelp(playerid, params);
}

CMD:zombiehelp(playerid, params[])
{
	SendClientMessageEx(playerid, COLOR_GREY, "*** ZOMBIE HELP *** /buycure /bite /curevirus /getvials (For Medics)");
	SendClientMessageEx(playerid, COLOR_GREY, "*** ZOMBIE HELP *** /buycure - 20 Credits (5x)  /zinject - 40 Credits (3x) /zopenkit - 30 Credits (1x)");
	SendClientMessageEx(playerid, COLOR_GREY, "*** ZOMBIE HELP *** /z50cal - 20 Credits (14x bullets) /zscrapmetal - 10 Credits)");
	SendClientMessageEx(playerid, COLOR_GREY, "*** ZOMBIE HELP *** /bite /curevirus /getvials (For Medics)");
	if(PlayerInfo[playerid][pAdmin] >= 1337)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "*** ZOMBIE ADMIN ***: /zombieweather /zombieevent /makezombie /setvials /zombieannounce /unzombie");
	}
	return 1;
}

CMD:buycure(playerid, params[])
{
	if(IsAtDeliverPatientPoint(playerid))
	{
		if(gettime() - 900 > PlayerInfo[playerid][pBoughtCure] || PlayerInfo[playerid][pBoughtCure] == 0)
		{
			if(GetPVarInt(playerid, "PinConfirmed"))
			{
				if(PlayerInfo[playerid][pCredits] < 20)
					return SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough credits to purchase this item. Visit shop.ng-gaming.net to purchase credits.");
				
				

				new string[128];
				format(string, sizeof(string), "[BUYCURE] [User: %s(%i)] [IP: %s] [Credits: %s] [Zombie Cure] [Price: %s]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(20));
				Log("logs/zombiecure.log", string), print(string);

				GivePlayerCredits(playerid, -20, 1);

				PlayerInfo[playerid][pVials] += 5;
				PlayerInfo[playerid][pBoughtCure] = gettime();
				
				g_mysql_SaveAccount(playerid);
				
				format(string, sizeof(string), "[BUYCURE] [User: %s(%i)] [IP: %s] [Credits: %s] [Zombie Cure] [Price: %s]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(20));
				Log("logs/credits.log", string), print(string);

				format(string, sizeof(string), "You have purchased a vial of the cure for %s credits. Use it with /curevirus.", number_format(20));
				SendClientMessageEx(playerid, COLOR_CYAN, string);	
			}
			else
			{
				PinLogin(playerid);
			}
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GRAD2, "You must wait 15 minutes between purchasing cures!");
		}
	}
	else {
		return SendClientMessageEx(playerid, COLOR_GRAD2, "You must be at a hospital delivery point to purchase a cure!");
	}
	return 1;
}

CMD:zombieweather(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 1337)
	{
    	SetWeather(9);
    	SyncMinTime();
    	SendRconCommand("loadfs zombie_mapping");
    	SendClientMessageEx(playerid, COLOR_WHITE, "Zombie weather loaded.");
	}
	return 1;
}

//Zombie Event Commands
CMD:zombieevent(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 1337)
	{
	    if(zombieevent == 0)
	    {
	        //foreach(new i: Player)
			for(new i = 0; i < MAX_PLAYERS; ++i)
			{
				if(IsPlayerConnected(i))
				{
					PlayerInfo[i][pVials]++;
				}	
	        }
	        zombieevent=1;
	        //SendAudioToRange(70, 100, 0.0, 0.0, 0.0, 10000); RESCRIPT NEW SOUND
			SendGroupMessage(3, TEAM_MED_COLOR, "Attention FDSA, the zombie event has started, you can now use /curevirus to cure the virus");
	        SendClientMessageEx(playerid, COLOR_WHITE, "You have enabled zombie mode.");
	        mysql_function_query(MainPipeline, "DELETE FROM zombie", false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
	    }
	    else
	    {
	        zombieevent=0;
			SendRconCommand("unloadfs zombie_mapping");
	        SyncMinTime();
			SetWeather(5);
			mysql_function_query(MainPipeline, "DELETE FROM zombie", false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
			//foreach(Player, i)
			for(new i = 0; i < MAX_PLAYERS; ++i)
			{
			    UnZombie(i);
			}
	        SendClientMessageEx(playerid, COLOR_WHITE, "Nothing to see here, folks.");
		}
	}
	return 1;
}

CMD:zombieannounce(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 1337)
	{
	    if(zombieevent == 1)
	    {
	        //SendAudioToRange(65, 100, 0.0, 0.0, 0.0, 10000); RESCRIPT NEW SOUND
			SendClientMessageToAllEx(COLOR_WHITE, "|___________ Government News Announcement ___________|");
			SendClientMessageToAllEx(COLOR_DBLUE, "** Unknown Spokesman: Attention, attention. This is a government announcement.");
			SendClientMessageToAllEx(COLOR_DBLUE, "** Unknown Spokesman: A state of emergency has been declared by the President of San Andreas");
			SendClientMessageToAllEx(COLOR_DBLUE, "** Unknown Spokesman: The City of Los Santos has been quarantined under executive order 133B.");
			SendClientMessageToAllEx(COLOR_DBLUE, "** Unknown Spokesman: Please direct yourself to government services for assistance. May god help us all.");
	    }
	}
	return 1;
}

CMD:makezombie(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 1337)
	{
 		if(zombieevent == 1)
	    {
    		new giveplayerid;
			if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /makezombie [player]");
			MakeZombie(giveplayerid);
	    }
	}
	return 1;
}

CMD:getvials(playerid, params[])
{
	if(zombieevent == 1)
	{
		if(!IsAMedic(playerid) && PlayerInfo[playerid][pMember] != 11) return SendClientMessageEx(playerid, COLOR_GREY, "You aren't a Medic!");
		if(!IsAnAmbulance(GetPlayerVehicleID(playerid)) && GetVehicleModel(GetPlayerVehicleID(playerid)) != 470) return SendClientMessageEx(playerid, COLOR_GREY, "You aren't in an ambulance!");
		if(PlayerInfo[playerid][pVials] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "You already have vials.");
		new string[128];
		PlayerInfo[playerid][pVials] += 5;
		SendClientMessageEx(playerid, COLOR_GREEN, "You have received 5 vials.");
		format(string, sizeof(string), "* %s takes 5 vials from the vehicle.", GetPlayerNameEx(playerid));
		ProxDetector(5.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	}
	return 1;
}

CMD:setvials(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 1337)
	{
		new giveplayerid, vials;
		if(sscanf(params, "ui", giveplayerid, vials)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /setvials [player] [number]");
		if(vials < 0) return 1;
		new string[128];

		PlayerInfo[giveplayerid][pVials] += vials;
		format(string, sizeof(string), "You gave %s %d vials of the cure!", GetPlayerNameEx(giveplayerid), vials);
		SendClientMessageEx(playerid, COLOR_WHITE,string);
		format(string, sizeof(string), "You received %d vials of the cure - use them with /curevirus.", vials);
		SendClientMessageEx(giveplayerid, COLOR_WHITE,string);
	}
	return 1;
}

CMD:unzombie(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 1337)
	{
 		if(zombieevent == 1)
	    {
    		new giveplayerid;
			if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /unzombie [player]");
			SendClientMessageEx(playerid, COLOR_GREY, "Done!");
			UnZombie(giveplayerid);
	    }
	}
	return 1;
}

CMD:bite(playerid, params[])
{
	if(zombieevent == 1)
	{
		if(GetPVarType(playerid, "pIsZombie"))
		{
		    new Float:X, Float:Y, Float:Z;
		    GetPlayerPos(playerid, X, Y, Z);
			//foreach(Player, i)
			for(new i = 0; i < MAX_PLAYERS; ++i)
			{
			    if(!GetPVarType(i, "pIsZombie") && !IsPlayerInAnyVehicle(i) && IsPlayerInRangeOfPoint(i, 2, X, Y, Z))
			    {


					/*if(GetPVarType(i, "pZombieBit")) {
						return SendClientMessageEx(playerid, COLOR_GREY, "This player is already infected - find somebody else!");
					} */
					new Float:hp, string[128];
					if(GetPVarInt(i, "LastBiteTime"))
					{
						if(gettime() < GetPVarInt(i, "LastBiteTime"))
						{
			    			format(string, sizeof(string), "You must wait %d seconds before you can bite that player.", (GetPVarInt(i, "LastBiteTime") - gettime()));
			    			SendClientMessageEx(playerid, COLOR_GREY, string);
			    			return 1;
						}
					}
					if(PlayerInfo[i][mInventory][18])
					{
						PlayerInfo[i][mInventory][18]--;
						SetPVarInt(i, "LastBiteTime", gettime()+15);
						format(string, sizeof(string), "* %s clamps down onto %s's skin, biting into it.", GetPlayerNameEx(playerid), GetPlayerNameEx(i));
						ProxDetector(5.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
						SendClientMessageEx(i, COLOR_GREY, "You were not affected by the zombies bite due to the antibiotic in your bloodstream!");
						return SendClientMessageEx(playerid, COLOR_GREY, "They have a antibiotic in their bloodstream! Your bite had no effect on them!");
					}
					GetPlayerHealth(i, hp);
					SetPlayerHealth(i, hp - 30);
					SetPVarInt(i, "pZombieBit", 1);
					SetPVarInt(i, "pZombieBiter", playerid);
					SetPVarInt(i, "LastBiteTime", gettime()+15);

					SetPVarInt(playerid, "LastBiteID", i);
					SetPlayerToTeamColor(i);
					format(string, sizeof(string), "* %s clamps down onto %s's skin, biting into it.", GetPlayerNameEx(playerid), GetPlayerNameEx(i));
					ProxDetector(5.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
					SendClientMessageEx(i, COLOR_GREY, "Use /buycure to purchase a cure to heal yourself.");
					//SendAudioToRange(66, 100, X, Y, Z, 5); RESCRIPT NEW SOUND
					return 1;
			    }
			}
			SendClientMessageEx(playerid, COLOR_GREY, "No one is near you to bite!");
		}
	}
	else
	{
	    if(EventKernel[EventType] == 4 && (GetPVarInt(playerid, "EventToken") == 1) && GetPVarType(playerid, "pEventZombie"))
		{
		    new Float:X, Float:Y, Float:Z;
		    GetPlayerPos(playerid, X, Y, Z);
			//foreach(Player, i)
			for(new i = 0; i < MAX_PLAYERS; ++i)
			{
			    if((GetPVarInt(i, "EventToken") == 1) && !GetPVarType(i, "pEventZombie"))
			    {
				    if(IsPlayerInRangeOfPoint(i, 2, X, Y, Z))
				    {
						new Float:hp, string[128];
						GetPlayerHealth(i, hp);
						SetPlayerHealth(i, hp-20);
						format(string, sizeof(string), "* %s clamps down onto %s's skin, biting into it.", GetPlayerNameEx(playerid), GetPlayerNameEx(i));
						ProxDetector(5.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
						//SendAudioToRange(65, 100, X, Y, Z, 5);
						return 1;
				    }
				}
			}
			SendClientMessageEx(playerid, COLOR_GREY, "No one is near you to bite!");
		}
	}
	return 1;
}

CMD:curevirus(playerid, params[])
{
	if(zombieevent == 1 && PlayerInfo[playerid][pVials])
	{
		new giveplayerid, string[128];
		if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /curevirus [player]");
		if(!GetPVarType(giveplayerid, "pZombieBit")) return SendClientMessageEx(playerid, COLOR_GREY, "That person does not have the virus, or they're already a zombie!");
		new Float:X, Float:Y, Float:Z;
		GetPlayerPos(giveplayerid, X, Y, Z);
		if(!IsPlayerInRangeOfPoint(playerid, 5, X, Y, Z)) return SendClientMessageEx(playerid, COLOR_GREY, "You are not near that patient.");

		if(GetPVarInt(playerid, "pZombieHealTime"))
		{
			if(gettime() < GetPVarInt(playerid, "pZombieHealTime"))
			{
			    format(string, sizeof(string), "You must wait %d seconds before you can heal again.", (GetPVarInt(playerid, "pZombieHealTime") - gettime()));
			    SendClientMessageEx(playerid, COLOR_GREY, string);
			    return 1;
			}
		}

		format(string, sizeof(string), "* %s injects %s with an antidote.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
        ProxDetector(5.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

		DeletePVar(giveplayerid, "pZombieBit");
		SetPVarInt(playerid, "pZombieHealTime", gettime()+15);
		SetPlayerToTeamColor(giveplayerid);

		PlayerInfo[playerid][pVials]--;
		if(PlayerInfo[playerid][pVials] == 0)
		{
      		SendClientMessageEx(playerid, COLOR_GREY, "You've ran out of vials!");
		}
		else
		{
  			format(string, sizeof(string), "You now have %d vials left.", PlayerInfo[playerid][pVials]);
			SendClientMessageEx(playerid, COLOR_GREY, string);
		}

  		format(string, sizeof(string), "INSERT INTO zombieheals (id,num) VALUES (%d,1) ON DUPLICATE KEY UPDATE num = num + 1", GetPlayerSQLId(playerid));
		mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
	}
	return 1;
}
#endif

CMD:trickortreat(playerid, params[])
{
	new year, month, day, string[256];
	getdate(year, month, day);
	if(month == 10 && day == 31)
	{
		if(PlayerInfo[playerid][pConnectHours] > 2)
		{
			for(new i = 0; i < sizeof(HouseInfo); i++)
			{
				if (IsPlayerInRangeOfPoint(playerid,3,HouseInfo[i][hExteriorX], HouseInfo[i][hExteriorY], HouseInfo[i][hExteriorZ]))
				{
					if(PlayerInfo[playerid][pTrickortreat] == 0)
					{
						GiftPlayer(MAX_PLAYERS, playerid);
						switch(PlayerInfo[playerid][pDonateRank])
						{
							case 0, 1: PlayerInfo[playerid][pTrickortreat] = 5;
							case 2: PlayerInfo[playerid][pTrickortreat] = 4;
							case 3: PlayerInfo[playerid][pTrickortreat] = 3;
							case 4: PlayerInfo[playerid][pTrickortreat] = 2;
							case 5: PlayerInfo[playerid][pTrickortreat] = 2;
						}	
						return 1;
					}
					else
					{
						if(GetPVarInt(playerid, "PinConfirmed"))
						{
							format(string, sizeof(string),"Item: Reset Trick or Treat Timer\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]), number_format(20), number_format(PlayerInfo[playerid][pCredits]-20));
							ShowPlayerDialog( playerid, DIALOG_SHOPTOTRESET, DIALOG_STYLE_MSGBOX, "Reset Gift Timer", string, "Purchase", "Exit" );
							SendClientMessageEx(playerid, COLOR_GRAD2, "You have already trick or treated in the last few hours!");
							return 1;
						}
						else
						{
							PinLogin(playerid);
							SendClientMessageEx(playerid, COLOR_GRAD2, "You have already trick or treated in the last few hours!");
							return 1;
						}
					}
				}
			}
			SendClientMessageEx(playerid, COLOR_GREY, "You are not at a house. (green house icon)");
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "You have not played 2 hours.");
		}
	}
	else SendClientMessageEx(playerid, COLOR_GREY, "It isn't Halloween!");
	return 1;
}
