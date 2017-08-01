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

#include <YSI\y_hooks>

#if defined zombiemode
stock SpawnZombie(playerid)
{
	new Float:maxdis, Float:dis, tpto;
	maxdis=9999.9;
	SetPlayerSkin(playerid, 134);
	SetHealth(playerid, 200);
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 0);
	for(new x;x<sizeof(ZombieSpawns);x++)
	{
        dis = GetPointDistanceToPoint(ZombieSpawns[x][0], ZombieSpawns[x][1], ZombieSpawns[x][2], GetPVarFloat(playerid,"MedicX"), GetPVarFloat(playerid,"MedicY"), GetPVarFloat(playerid,"MedicZ"));
        if((dis < maxdis) && (dis > 50.0))
        {
            tpto=x;
            maxdis=dis;
        }
	}
	SetPlayerPos(playerid, ZombieSpawns[tpto][0], ZombieSpawns[tpto][1], ZombieSpawns[tpto][2]);
	SetPlayerFacingAngle(playerid, ZombieSpawns[tpto][3]);
	ClearAnimationsEx(playerid);
	return 1;
}

stock MakeZombie(playerid)
{
    new Float:X, Float:Y, Float:Z, string[128];
    GetPlayerPos(playerid, X, Y, Z);

    if(IsPlayerConnected(GetPVarInt(playerid, "pZombieBiter")))
	{
		mysql_format(MainPipeline, string, sizeof(string), "INSERT INTO zombiekills (id,num) VALUES (%d,1) ON DUPLICATE KEY UPDATE num = num + 1", GetPlayerSQLId(GetPVarInt(playerid, "pZombieBiter")));
		mysql_tquery(MainPipeline, string, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
		DeletePVar(playerid, "pZombieBiter");
	}

	SendClientMessageEx(playerid, COLOR_RED, "You are now a zombie - use /bite to bite people!");
 	SetPVarInt(playerid, "pIsZombie", 1);
  	DeletePVar(playerid, "pZombieBit");
   	SetPlayerToTeamColor(playerid);

	SetHealth(playerid, 200);
	SetPlayerSkin(playerid, 134);

	ResetPlayerWeaponsEx(playerid);

 	//SendAudioToRange(70, 100, X, Y, Z, 30); RESCRIPT NEW SOUND

 	mysql_format(MainPipeline, string, sizeof(string), "INSERT INTO `zombie` (`id`) VALUES ('%d')", GetPlayerSQLId(playerid));
	mysql_tquery(MainPipeline, string, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
	return 1;
}

stock UnZombie(playerid)
{
	DeletePVar(playerid, "pIsZombie");
  	DeletePVar(playerid, "pZombieBit");
  	SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);
   	SetPlayerToTeamColor(playerid);
	SetHealth(playerid, 100);
	new string[64];
	mysql_format(MainPipeline, string, sizeof(string), "DELETE FROM `zombie` WHERE `id`='%d'", GetPlayerSQLId(playerid));
	mysql_tquery(MainPipeline, string, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
	return 1;
}
#endif

#if defined zombiemode
forward OnZombieCheck(playerid);
public OnZombieCheck(playerid)
{
	if(IsPlayerConnected(playerid))
	{
 		new rows;
   		cache_get_row_count(rows);
		if(rows)
		{
			MakeZombie(playerid);
		}
	}
	return 1;
}
#endif

forward ScrapMetal(playerid, vehicleid);
public ScrapMetal(playerid, vehicleid)
{
	PlayerInfo[playerid][mInventory][16]--;
	new Float:vHP;
	GetVehicleHealth(vehicleid, vHP);
	SetVehicleHealth(vehicleid, vHP+500.0);
	new string[128];
	format(string, sizeof(string), "%s has added scrap metal to their vehicle.", GetPlayerNameEx(playerid));
	ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	SendClientMessage(playerid, COLOR_WHITE, "Your have applied scrap metal to your vehicle giving it +500HP!");
	PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
	ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0, 1);
	format(string, sizeof(string), "[ZSCRAPMETAL] %s(%d) used a Scrap Metal. Left: %d", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), PlayerInfo[playerid][mInventory][16]);
	Log("logs/micro.log", string);
	DeletePVar(playerid, "zscrapmetal");
	return 1;
}

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
    	foreach(new i: Player) SyncMinTime(i);
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
	        zombieevent=1;
	        foreach(new i: Player)
			{
				PlayerInfo[i][pVials]++;
				SetPlayerWeaponsEx(playerid);
			}	
	        //SendAudioToRange(70, 100, 0.0, 0.0, 0.0, 10000); RESCRIPT NEW SOUND
			SendGroupMessage(GROUP_TYPE_MEDIC, TEAM_MED_COLOR, "Attention FDSA, the zombie event has started, you can now use /curevirus to cure the virus");
	        SendClientMessageEx(playerid, COLOR_WHITE, "You have enabled zombie mode.");
	        mysql_tquery(MainPipeline, "DELETE FROM zombie", "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
	    }
	    else
	    {
	        zombieevent=0;
			SendRconCommand("unloadfs zombie_mapping");
	        foreach(new i: Player) SyncMinTime(i);
			SetWeather(5);
			mysql_tquery(MainPipeline, "DELETE FROM zombie", "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
			foreach(Player, i)
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
			foreach(Player, i)
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
					GetHealth(i, hp);
					SetHealth(i, hp - 30);
					SetPVarInt(i, "pZombieBit", 1);
					SetPVarInt(i, "pZombieBiter", playerid);
					SetPVarInt(i, "LastBiteTime", gettime()+15);

					mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray),"INSERT INTO `zombiekills` (`id`,`name`,`num`) VALUES ('%d', '%s', 1) ON DUPLICATE KEY UPDATE `num` = `num` + 1", PlayerInfo[playerid][pId], GetPlayerNameEx(playerid));
					mysql_tquery(MainPipeline, szMiscArray, "","");

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
			foreach(Player, i)
			{
			    if((GetPVarInt(i, "EventToken") == 1) && !GetPVarType(i, "pEventZombie"))
			    {
				    if(IsPlayerInRangeOfPoint(i, 2, X, Y, Z))
				    {
						new Float:hp, string[128];
						GetHealth(i, hp);
						SetHealth(i, hp-20);
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

  		mysql_format(MainPipeline, string, sizeof(string), "INSERT INTO zombieheals (id,num) VALUES (%d,1) ON DUPLICATE KEY UPDATE num = num + 1", GetPlayerSQLId(playerid));
		mysql_tquery(MainPipeline, string, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
	}
	return 1;
}
#endif

/*
// Changed to give an you instead of this. (15 hours playing time during this time)
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
							ShowPlayerDialogEx( playerid, DIALOG_SHOPTOTRESET, DIALOG_STYLE_MSGBOX, "Reset Gift Timer", string, "Purchase", "Exit" );
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
}*/

CMD:prezombie(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 1337 && PlayerInfo[playerid][pShopTech] < 3) return SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use that command.");
	if(prezombie)
	{
		prezombie = 0;
		SendClientMessageEx(playerid, -1, "You have successfully disabled the pre-zombie event sale.");
	}
	else
	{
		prezombie = 1;
		SendClientMessageEx(playerid, -1, "You have successfully enabled the pre-zombie event sale.");
	}
	return 1;
}

CMD:zfuelcan(playerid, params[])
{
	new zyear, zmonth, zday;
	getdate(zyear, zmonth, zday);
	if(!zombieevent && !(zmonth == 10 && zday == 31) && !(zmonth == 11 && zday == 1)) return SendClientMessageEx(playerid, COLOR_GREY, "There is currently no active Zombie Event!");
	if(!PlayerInfo[playerid][zFuelCan]) return SendClientMessage(playerid, COLOR_GREY, "You do not have a Fuel Can in your inventory!");
	if(GetPVarInt(playerid, "fuelcan") == 2) return 1;
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You can not use your fuel can while inside the vehicle.");
	if(GetPVarInt(playerid, "EventToken")) return SendClientMessageEx(playerid, COLOR_GRAD1, "You can't use this while in an event.");
	if(GetPVarType(playerid, "PlayerCuffed") || GetPVarInt(playerid, "pBagged") >= 1 || GetPVarType(playerid, "Injured") || GetPVarType(playerid, "IsFrozen")) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can't do that at this time!");
	new closestcar = GetClosestCar(playerid);
	if(!IsPlayerInRangeOfVehicle(playerid, closestcar, 10.0)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not close enough to any vehicle.");
	new string[72];
	format(string, sizeof(string), "%s begins refilling their vehicle with a fuel can.", GetPlayerNameEx(playerid));
	ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	ApplyAnimation(playerid, "SCRATCHING", "scdldlp", 4.0, 1, 0, 0, 0, 0, 1);
	SetTimerEx("FuelCan", 10000, false, "iii", playerid, closestcar, PlayerInfo[playerid][zFuelCan]);
	SetPVarInt(playerid, "fuelcan", 2);
	GameTextForPlayer(playerid, "~w~Refueling...", 10000, 3);
	return 1;
}

CMD:zscrapmetal(playerid, params[])
{
	new zyear, zmonth, zday;
	getdate(zyear, zmonth, zday);
	if(!zombieevent && !(zmonth == 10 && zday == 31) && !(zmonth == 11 && zday == 1)) return SendClientMessageEx(playerid, COLOR_GREY, "There is currently no active Zombie Event!");
	if(!PlayerInfo[playerid][mInventory][16]) return SendClientMessageEx(playerid, COLOR_GREY, "You do not have any Scrap Metal in your inventory, visit /microshop to purchase.");
	if(GetPVarInt(playerid, "zscrapmetal") == 1) return 1;
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You can not use this while inside the vehicle.");
	if(GetPVarInt(playerid, "EventToken")) return SendClientMessageEx(playerid, COLOR_GRAD1, "You can't use this while in an event.");
	if(GetPVarType(playerid, "PlayerCuffed") || GetPVarInt(playerid, "pBagged") >= 1 || GetPVarType(playerid, "Injured") || GetPVarType(playerid, "IsFrozen")) return SendClientMessage(playerid, COLOR_GRAD2, "You can't do that at this time!");
	new closestcar = GetClosestCar(playerid);
	if(!IsPlayerInRangeOfVehicle(playerid, closestcar, 10.0)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not close enough to any vehicle.");
	new Float:vHP;
	GetVehicleHealth(closestcar, vHP);
	if(vHP > 5000) return SendClientMessageEx(playerid, -1, "You cannot add scrapmetal when your vehicle's health is over 5000 HP!");
	new string[71];
	format(string, sizeof(string), "%s begins to apply scrap metal to their vehicle.", GetPlayerNameEx(playerid));
	ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	ApplyAnimation(playerid, "COP_AMBIENT", "Copbrowse_loop", 4.1, 1, 0, 0, 0, 0, 1);
	SetTimerEx("ScrapMetal", 6000, false, "ii", playerid, closestcar);
	SetPVarInt(playerid, "zscrapmetal", 1);
	GameTextForPlayer(playerid, "~w~Applying...", 6000, 3);
	return 1;
}

CMD:z50cal(playerid, params[])
{
	if(!zombieevent) return SendClientMessageEx(playerid, COLOR_GREY, "There is currently no active Zombie Event!");
	if(!PlayerInfo[playerid][mInventory][17]) return SendClientMessageEx(playerid, COLOR_GREY, "You do not have any .50 Caliber Ammo in your inventory, visit /microshop to purchase.");
	if((GetPlayerWeapon(playerid) != 33 || PlayerInfo[playerid][pGuns][6] != 33) && (GetPlayerWeapon(playerid) != 34 || PlayerInfo[playerid][pGuns][6] != 34)) return SendClientMessageEx(playerid, COLOR_GREY, "You can only load a rifle or sniper rifle with .50 cal ammo.");
	if(!GetPVarType(playerid, "z50Cal"))
	{
		SendClientMessageEx(playerid, -1, "You have loaded a .50 Caliber bullet into your weapon.");
		SetPVarInt(playerid, "z50Cal", 1);
	}
	else
	{
		SendClientMessageEx(playerid, -1, "You have unloaded a .50 Caliber bullet from your weapon.");
		DeletePVar(playerid, "z50Cal");
	}
	ApplyAnimation(playerid, "RIFLE", "RIFLE_load", 4.0, 0, 0, 0, 0, 0, 1);
	return 1;
}

CMD:zinject(playerid, params[])
{
	if(!zombieevent) return SendClientMessageEx(playerid, COLOR_GREY, "There is currently no active Zombie Event!");
	if(!PlayerInfo[playerid][mPurchaseCount][18]) return SendClientMessageEx(playerid, COLOR_GREY, "You do not have any Antibiotic Injections in your inventory, visit /microshop to purchase.");
	if(PlayerInfo[playerid][mInventory][18]) return SendClientMessageEx(playerid, COLOR_GREY, "You currently have a active antibiotic in your bloodstream!");
	PlayerInfo[playerid][mPurchaseCount][18]--;
	PlayerInfo[playerid][mInventory][18] = 3;
	SendClientMessageEx(playerid, -1, "You have injected your self with a antibiotic! You will be immune from 3 zombie bites!");
	return 1;
}

CMD:zopenkit(playerid, params[])
{
	new zyear, zmonth, zday;
	getdate(zyear, zmonth, zday);
	if(!zombieevent && !(zmonth == 10 && zday == 31) && !(zmonth == 11 && zday == 1)) return SendClientMessageEx(playerid, COLOR_GREY, "There is currently no active Zombie Event!");
	if(!PlayerInfo[playerid][mInventory][19]) return SendClientMessageEx(playerid, COLOR_GREY, "You do not have any Survivor Kits in your inventory, visit /microshop to purchase.");
	new string[128], rand = random(75);
	switch(rand)
	{
		case 0 .. 24://1 Scrap Metal & 2 Bullets
		{
			PlayerInfo[playerid][mInventory][16]++;
			PlayerInfo[playerid][mInventory][17] += 2;
			SendClientMessageEx(playerid, -1, "You found 1 Scrap Metal & 2 .50 Cal Bullets in your kit! Use /zscrapmetal and /z50cal to use your items.");
			format(string, sizeof(string), "[ZOPEKIT] %s found 1 Scrap Metal & 2 .50 Cal Bullets in their kit!", GetPlayerNameEx(playerid));
		}
		case 25 .. 49://5 Bullets & 2 Antibiotic Injection
		{
			PlayerInfo[playerid][mInventory][17] += 5;
			PlayerInfo[playerid][mPurchaseCount][18] += 2;
			SendClientMessageEx(playerid, -1, "You found 5 .50 Cal Bullets & 2 Antibiotic Injections in your kit! Use /z50cal and /zinject to use your items.");
			format(string, sizeof(string), "[ZOPEKIT] %s found 5 .50 Cal Bullets & 2 Antibiotic Injections in their kit!", GetPlayerNameEx(playerid));
		}
		case 50 .. 74://2 Engine Repair Kits & 1 Scrap Metal, 1 Antibiotic Injection
		{
			PlayerInfo[playerid][mInventory][8] += 2;
			PlayerInfo[playerid][mInventory][16]++;
			PlayerInfo[playerid][mPurchaseCount][18]++;
			SendClientMessageEx(playerid, -1, "You found 2 Engine Repair Kits, 1 Scrap Metal & 1 Antibiotic Injection in your kit! Use /jumpstart /zscrapmetal and /zinject to use your items.");
			format(string, sizeof(string), "[ZOPEKIT] %s found 2 Engine Repair Kits, 1 Scrap Metal & 1 Antibiotic Injection in their kit!", GetPlayerNameEx(playerid));
		}
	}
	Log("logs/micro.log", string);
	PlayerInfo[playerid][mInventory][19]--;
	return 1;
}

CMD:givez(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1) return SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use this command!");
	new target, option[11], amount;
	if(sscanf(params, "us[11]d", target, option, amount) || amount <= 0) return SendClientMessageEx(playerid, -1, "USAGE: /givez [player] [option] [amount]"), SendClientMessageEx(playerid, -1, "Available Options: jumpstart, fuelcan, scrapmetal, 50cal, inject, kit");
	if(!IsPlayerConnected(target)) return SendClientMessageEx(playerid, COLOR_GREY, "That player is not connected.");
	new string[128];
	if(!strcmp(option, "jumpstart", true))
	{
		PlayerInfo[playerid][mInventory][8] += amount;
		format(string, sizeof(string), "You have given %s %d Jump Start(s).", GetPlayerNameEx(target), amount);
		SendClientMessageEx(playerid, -1, string);
		format(string, sizeof(string), "%s has given you %d Jump Start(s). /jumpstart to use this item.", GetPlayerNameEx(playerid), amount);
		SendClientMessageEx(target, -1, string);
		format(string, sizeof(string), "[GIVEZ] %s has given %s(%d) %d Jump Start(s).", GetPlayerNameEx(playerid), GetPlayerNameEx(target), GetPlayerSQLId(target), amount);
	}
	if(!strcmp(option, "fuelcan", true))
	{
		if(amount != 25 && amount != 50 && amount != 75) return SendClientMessageEx(playerid, -1, "Valid Amounts for fuel cans are 25, 50 and 75.");
		PlayerInfo[target][zFuelCan] = amount;
		format(string, sizeof(string), "You have given %s a fuelcan with %d fuel.", GetPlayerNameEx(target), amount);
		SendClientMessageEx(playerid, -1, string);
		format(string, sizeof(string), "%s has given you a fuelcan with %d fuel. /zfuelcan to use this item.", GetPlayerNameEx(playerid), amount);
		SendClientMessageEx(target, -1, string);
		format(string, sizeof(string), "[GIVEZ] %s has given %s(%d) a fuelcan with %d fuel.", GetPlayerNameEx(playerid), GetPlayerNameEx(target), GetPlayerSQLId(target), amount);
	}
	if(!strcmp(option, "scrapmetal", true))
	{
		PlayerInfo[target][mInventory][16] += amount;
		format(string, sizeof(string), "You have given %s %d Scrap Metal(s).", GetPlayerNameEx(target), amount);
		SendClientMessageEx(playerid, -1, string);
		format(string, sizeof(string), "%s has given you %d Scrap Metal(s). /zscrapmetal to use this item.", GetPlayerNameEx(playerid), amount);
		SendClientMessageEx(target, -1, string);
		format(string, sizeof(string), "[GIVEZ] %s has given %s(%d) %d Scrap Metal(s).", GetPlayerNameEx(playerid), GetPlayerNameEx(target), GetPlayerSQLId(target), amount);
	}
	if(!strcmp(option, "50cal", true))
	{
		PlayerInfo[target][mInventory][17] += amount;
		format(string, sizeof(string), "You have given %s %d .50 Caliber Bullet(s).", GetPlayerNameEx(target), amount);
		SendClientMessageEx(playerid, -1, string);
		format(string, sizeof(string), "%s has given you %d .50 Caliber Bullet(s). /z50cal to use this item.", GetPlayerNameEx(playerid), amount);
		SendClientMessageEx(target, -1, string);
		format(string, sizeof(string), "[GIVEZ] %s has given %s(%d) %d .50 Caliber Bullet(s).", GetPlayerNameEx(playerid), GetPlayerNameEx(target), GetPlayerSQLId(target), amount);
	}
	if(!strcmp(option, "inject", true))
	{
		PlayerInfo[target][mPurchaseCount][18] += amount;
		format(string, sizeof(string), "You have given %s %d Antibiotic Injection(s).", GetPlayerNameEx(target), amount);
		SendClientMessageEx(playerid, -1, string);
		format(string, sizeof(string), "%s has given you %d Antibiotic Injection(s). /zinject to use this item.", GetPlayerNameEx(playerid), amount);
		SendClientMessageEx(target, -1, string);
		format(string, sizeof(string), "[GIVEZ] %s has given %s(%d) %d Antibiotic Injection(s).", GetPlayerNameEx(playerid), GetPlayerNameEx(target), GetPlayerSQLId(target), amount);
	}
	if(!strcmp(option, "kit", true))
	{
		PlayerInfo[target][mInventory][19] += amount;
		format(string, sizeof(string), "You have given %s %d Survivor Kit(s).", GetPlayerNameEx(target), amount);
		SendClientMessageEx(playerid, -1, string);
		format(string, sizeof(string), "%s has given you %d Survivor Kit(s). /zopenkit to use this item.", GetPlayerNameEx(playerid), amount);
		SendClientMessageEx(target, -1, string);
		format(string, sizeof(string), "[GIVEZ] %s has given %s(%d) %d Survivor Kit(s).", GetPlayerNameEx(playerid), GetPlayerNameEx(target), GetPlayerSQLId(target), amount);
	}
	Log("logs/micro.log", string);
	return 1;
}

CMD:zscores(playerid, params[]) {

	if(!zombieevent) return SendClientMessageEx(playerid, COLOR_GREY, "The zombie event is not active!");
	ShowPlayerDialogEx(playerid, DIALOG_ZSCORES, DIALOG_STYLE_LIST, "Zombie Scores", "Human Kills\nZombie Infections\nLongest Surviving\nLongest Zombies", "Select", "Cancel");
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	switch(dialogid) {

		case DIALOG_ZSCORES: {

			if(!response) return 1;

			ShowZombieScoreBoard(playerid, listitem);
		}
	}
	return 0;
}

ShowZombieScoreBoard(iPlayerID, iScoreType) {

	switch(iScoreType) {
		case 0: {
			mysql_tquery(MainPipeline, "SELECT * FROM `humankills` ORDER BY `num` DESC LIMIT 5", "OnShowZombieScoreBoard", "ii", iPlayerID, iScoreType);
		}
		case 1: {
			mysql_tquery(MainPipeline, "SELECT * FROM `zombiekills` ORDER BY `num` DESC LIMIT 5", "OnShowZombieScoreBoard", "ii", iPlayerID, iScoreType);
		}
		case 2: {
			mysql_tquery(MainPipeline, "SELECT * FROM `humansurvivor` ORDER BY `num` DESC LIMIT 5", "OnShowZombieScoreBoard", "ii", iPlayerID, iScoreType);
		}
		case 3: {
			mysql_tquery(MainPipeline, "SELECT * FROM `zombiesurvivor` ORDER BY `num` DESC LIMIT 5", "OnShowZombieScoreBoard", "ii", iPlayerID, iScoreType);
		}
	}
	return 1;
}

forward OnShowZombieScoreBoard(iPlayerID, iScoreType);
public OnShowZombieScoreBoard(iPlayerID, iScoreType) {

	new 
		iRows,
		iCount,
		iNumb,
		szTempName[MAX_PLAYER_NAME];
	szMiscArray[0] = 0;
	cache_get_row_count(iRows);

	switch(iScoreType) {
		case 0: szMiscArray = "Name\tKills";
		case 1: szMiscArray = "Name\tKills";
		case 2: szMiscArray = "Name\tTime";
		case 3: szMiscArray = "Name\tTime";
	}

	while(iCount < iRows) {

		cache_get_value_name(iCount, "name", szTempName);
		cache_get_value_name_int(iCount, "num", iNumb);
		switch(iScoreType) {
			case 0, 1: format(szMiscArray, sizeof(szMiscArray), "%s\n%s\t%d", szMiscArray, szTempName, iNumb);
			case 2, 3: format(szMiscArray, sizeof(szMiscArray), "%s\n%s\t%s", szMiscArray, szTempName, ConvertTimeS(iNumb));
		}

		iCount++; 
	}
	
	switch(iScoreType) {
		case 0, 2: ShowPlayerDialogEx(iPlayerID, DIALOG_NOTHING, DIALOG_STYLE_TABLIST_HEADERS, "Survivor Scoreboard", szMiscArray, "Close", "");
		case 1, 3: ShowPlayerDialogEx(iPlayerID, DIALOG_NOTHING, DIALOG_STYLE_TABLIST_HEADERS, "Zombie Scoreboard", szMiscArray, "Close", "");
	}
	

	return 1;
}

SaveZombieStats(i) {
	new iSSurvive = GetPVarInt(i, "iSAliveTick");
	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "INSERT INTO `humansurvivor` (`id`,`name`,`num`) VALUES ('%d', '%s', '%d') ON DUPLICATE KEY UPDATE `num` = `num` + '%d'", PlayerInfo[i][pId], GetPlayerNameEx(i), iSSurvive, iSSurvive);
	mysql_tquery(MainPipeline, szMiscArray, "OnSaveZombieStats", "ii", i, 0);
}

forward OnSaveZombieStats(iPlayerID, iStage);
public OnSaveZombieStats(iPlayerID, iStage) {

	switch(iStage) {
			
		case 0: {
			new iZSurvive = GetPVarInt(iPlayerID, "iZAliveTick");
			mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "INSERT INTO `zombiesurvivor` (`id`,`name`,`num`) VALUES ('%d', '%s', '%d') ON DUPLICATE KEY UPDATE `num` = `num` + '%d'", PlayerInfo[iPlayerID][pId], GetPlayerNameEx(iPlayerID), iZSurvive, iZSurvive);
			mysql_tquery(MainPipeline, szMiscArray, "OnSaveZombieStats", "ii", iPlayerID, 1);
		}

		case 1: {
			SetPVarInt(iPlayerID, "iSAliveTick", 0);
			SetPVarInt(iPlayerID, "iZAliveTick", 0);
			format(szMiscArray, sizeof(szMiscArray), "Saved zombie stats for %s (%d)", GetPlayerNameEx(iPlayerID), iPlayerID);
			print(szMiscArray);
		}
			
	}


	return 1;
}


hook OnPlayerConnect(playerid) {
	
	if(zombieevent) {
		DeletePVar(playerid, "iZAliveTick");
		DeletePVar(playerid, "iSAliveTick");
	}

	return 1;
}

hook OnPlayerDisconnect(playerid, reason) {

	if(zombieevent) SaveZombieStats(playerid);
	return 1;
}

ptask ZombieTick[1000](i) { 

	if(zombieevent) {

		//if(PlayerInfo[i][pAdmin] >= 2) return 1;

		if(GetPVarType(i, "pIsZombie")) {
			new iZSurvive = GetPVarInt(i, "iZAliveTick");
			SetPVarInt(i, "iZAliveTick", iZSurvive+1);
		}
		if(!GetPVarType(i, "pIsZombie")) {
			new iSSurvive = GetPVarInt(i, "iSAliveTick");
			SetPVarInt(i, "iSAliveTick", iSSurvive+1);
		}
	}
}