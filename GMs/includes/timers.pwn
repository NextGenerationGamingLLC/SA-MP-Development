/*
    	 		 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
				| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
				| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
				| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
				| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
				| $$\  $$$| $$  \ $$        | $$  \ $$| $$
				| $$ \  $$|  $$$$$$/        | $$  | $$| $$
				|__/  \__/ \______/         |__/  |__/|__/

//--------------------------------[TIMERS.PWN]--------------------------------


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
 
 // Timer Name: SkinDelay(playerid)
timer SkinDelay[1000](playerid)
{
	SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);

	// Attach Storage Objects
	for(new i = 0; i < 3; i++)
	{
		if(StorageInfo[playerid][i][sAttached] == 1)
		{
			switch(i)
			{
				case 0: // Bag
				{
					if(IsPlayerAttachedObjectSlotUsed(playerid, 9)) RemovePlayerAttachedObject(playerid, 9);
					SetPlayerAttachedObject(playerid, 9, 2919, 5, 0.25, 0, 0, 0, 270, 0, 0.2, 0.2, 0.2);
				}
				case 1: // Backpack
				{
					if(IsPlayerAttachedObjectSlotUsed(playerid, 9)) RemovePlayerAttachedObject(playerid, 9);
					SetPlayerAttachedObject(playerid, 9, 371, 1, 0.1, -0.1, 0, 0, 90, 0, 1, 1, 1);
				}
				case 2: // Briefcase
				{
					if(IsPlayerAttachedObjectSlotUsed(playerid, 9)) RemovePlayerAttachedObject(playerid, 9);
					SetPlayerAttachedObject(playerid, 9, 1210, 5, 0.3, 0.0, 0.0, 0.0, 270.0, 180.0, 1, 1, 1);
				}
			}
		}
	}
	return 1;
}

// Timer Name: NOPCheck(playerid)
timer NOPCheck[5000](playerid)
{
	if(GetPlayerState(playerid) != 2) NOPTrigger[playerid] = 0;
	new newcar = GetPlayerVehicleID(playerid);
	if(PlayerInfo[playerid][pAdmin] > 1 || GetPlayerState(playerid) != 2) return 1;
    else if(IsAPlane(newcar) && (PlayerInfo[playerid][pFlyLic] != 1)) ExecuteNOPAction(playerid);
    else if(IsAPizzaCar(newcar) && PlayerInfo[playerid][pJob] != 21 && PlayerInfo[playerid][pJob2] != 21 && PlayerInfo[playerid][pJob3] != 21) ExecuteNOPAction(playerid);
    else if(IsVIPcar(newcar) && PlayerInfo[playerid][pDonateRank] == 0) ExecuteNOPAction(playerid);
    else if(IsATruckerCar(newcar) && PlayerInfo[playerid][pJob] != 20 && PlayerInfo[playerid][pJob2] != 20 && PlayerInfo[playerid][pJob3] != 20) ExecuteNOPAction(playerid);
    else if(GetCarBusiness(newcar) != INVALID_BUSINESS_ID && PlayerInfo[playerid][pBusiness] != GetCarBusiness(newcar)) ExecuteNOPAction(playerid);
    else if(DynVeh[newcar] != -1)
	{
 		if(DynVehicleInfo[DynVeh[newcar]][gv_igID] != 0 && (PlayerInfo[playerid][pMember] != DynVehicleInfo[DynVeh[newcar]][gv_igID] || PlayerInfo[playerid][pLeader] != DynVehicleInfo[DynVeh[newcar]][gv_igID]) || DynVehicleInfo[DynVeh[newcar]][gv_ifID] != 0 && PlayerInfo[playerid][pFMember] != DynVehicleInfo[DynVeh[newcar]][gv_ifID] || DynVehicleInfo[DynVeh[newcar]][gv_irID] != 0 && PlayerInfo[playerid][pRank] < DynVehicleInfo[DynVeh[newcar]][gv_irID])
		{
  			ExecuteNOPAction(playerid);
		}
	}
	return 1;
}

/* Repeating Timers */

// Timer Name: AFKUpdate()
// TickRate: 10 Secs.
task AFKUpdate[10000]()
{
	if(Iter_Count(Player) > MAX_PLAYERS - 100)
	{
		//foreach(new i: Player)
		for(new i = 0; i < MAX_PLAYERS; ++i)
		{
			if(IsPlayerConnected(i))
			{
				if((playerTabbed[i] > 300 || playerAFK[i] > 300) && PlayerInfo[i][pShopTech] < 1 && PlayerInfo[i][pAdmin] < 4)
				{
					Kick(i);
				}
			}	
		}
	}
	return 1;
}

// Timer Name: SyncUp()
// TickRate: 1 Minute.
task SyncUp[60000]()
{
	static
		string[128];

	SyncTime();
	SyncMinTime();

	for(new i = 0; i < MAX_PLANTS; i++)
	{
    	if(IsValidDynamicObject(Plants[i][pObjectSpawned]))
		{
    	    if(Plants[i][pExpires] > gettime())
			{
				switch(Plants[i][pPlantType])
				{
				    case 1:
				    {
				        if(Plants[i][pGrowth] < 45)
						{
       						switch(Plants[i][pDrugsSkill])
							{
								case 0 .. 50: Plants[i][pGrowth] += 1;
								case 51 .. 100: Plants[i][pGrowth] += 2;
								case 101 .. 200: Plants[i][pGrowth] += 3;
								case 201 .. 400: Plants[i][pGrowth] += 4;
								default: Plants[i][pGrowth] += 5;
							}
						}
				    }
				    case 2:
				    {
				        if(Plants[i][pGrowth] < 120) Plants[i][pGrowth] += 1;
						if(Plants[i][pGrowth] == 120)
						{
						    DestroyDynamicObject(Plants[i][pObjectSpawned]);
						    Plants[i][pObjectSpawned] = CreateDynamicObject(862, Plants[i][pPos][0], Plants[i][pPos][1], Plants[i][pPos][2], 0.0, 0.0, 0.0, Plants[i][pVirtual], Plants[i][pInterior]);
							Plants[i][pGrowth] = 121;
							Plants[i][pObject] = 862;
							format(string, sizeof(string), "Opium plant (%d) is ready to be picked.", i);
							Log("logs/plant.log", string);
						}
					}
				}
			}
			else if(Plants[i][pExpires] == 0) { }
			else
			{
			    format(string, sizeof(string), "Plant (%d) has expired.", i);
				Log("logs/plant.log", string);
			    DestroyPlant(i);
			    SavePlant(i);
			}
		}
	}
	
	for(new i = 0; i < MAX_GANGTAGS; i++)
	{
		if(GangTags[i][gt_Time] > 0)
		{
			GangTags[i][gt_Time]--;
		}
	}

	//foreach(new i: Player)
	for(new i = 0; i < MAX_PLAYERS; ++i)
	{
		if(IsPlayerConnected(i))
		{
			if(GetPVarType(i, "RentedVehicle"))
			{
				if(GetPVarInt(i, "RentedHours") > 0)
				{
					SetPVarInt(i, "RentedHours", GetPVarInt(i, "RentedHours")-1);
					if(GetPVarInt(i, "RentedHours") == 0)
					{
						SendClientMessageEx(i, COLOR_CYAN, "Your rented vehicle has expired.");
						DestroyVehicle(GetPVarInt(i, "RentedVehicle"));

						format(string, sizeof(string), "DELETE FROM `rentedcars` WHERE `sqlid`= '%d'", GetPlayerSQLId(i));
						mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);

						DeletePVar(i, "RentedHours");
						DeletePVar(i, "RentedVehicle");
					}
					else if(GetPVarInt(i, "RentedHours") == 120 || GetPVarInt(i, "RentedHours") == 60)
					{
						format(string, sizeof(string), "%d minutes(s) remaining on your rented vehicle.", GetPVarInt(i, "RentedHours"));
						SendClientMessageEx(i, COLOR_CYAN, string);
					}
					format(string, sizeof(string), "UPDATE `rentedcars` SET `hours` = '%d' WHERE `sqlid` = '%d'",GetPVarInt(i, "RentedHours"), GetPlayerSQLId(i));
					mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);
				}
			}
			SetPlayerScore(i, PlayerInfo[i][pLevel]);
			if(PlayerInfo[i][pProbationTime] > 0 && !PlayerInfo[i][pBeingSentenced])
			{
				PlayerInfo[i][pProbationTime]--;
			}
			if(PlayerInfo[i][pBeingSentenced] > 1) {
				if(--PlayerInfo[i][pBeingSentenced] == 1)
				{
					TogglePlayerControllable(i, true);
					DeletePVar(i, "IsFrozen");
					//Frozen[i] = 0;
					SetPlayerPos(i, 1415.5137,-1702.2272,13.5395);
					SetPlayerFacingAngle(i, 240.0264);
					SendClientMessageEx(i, COLOR_WHITE, "No Judge has attended your pending trial, you are free!");
					PlayerInfo[i][pBeingSentenced] = 0;
				}
			}
			if(PlayerInfo[i][pGiftTime] > 0) {
				PlayerInfo[i][pGiftTime] -= 1;
			}
			if(PlayerInfo[i][pDefendTime] > 0) {
				PlayerInfo[i][pDefendTime] -= 1;
			}
			#if defined zombiemode
			if(GetPVarType(i, "pZombieBit"))
			{
				new Float:health;
				GetPlayerHealth(i, health);
				SetPlayerHealth(i, health - 10.0);
				SendClientMessageEx(i, COLOR_LIGHTBLUE, "* Lost 10 health due to virus.");
				SendClientMessageEx(i, COLOR_LIGHTBLUE, "* Seek a medic to cure you!");
			}
			#endif
			switch(GetPVarInt(i, "STD")) {
				case 1: {
					new Float: health;
					GetPlayerHealth(i, health);
					SetPlayerHealth(i, health - 5.0);
					SendClientMessageEx(i, COLOR_LIGHTBLUE, "* Lost 4 health due to STD.");
				}
				case 2: {
					new Float: health;
					GetPlayerHealth(i, health);
					SetPlayerHealth(i, health - 12.0);
					SendClientMessageEx(i, COLOR_LIGHTBLUE, "* Lost 8 health due to STD.");
				}
				case 3: {
					new Float: health;
					GetPlayerHealth(i, health);
					SetPlayerHealth(i, health - 20.0);
					SendClientMessageEx(i, COLOR_LIGHTBLUE, "* Lost 12 health due to STD.");
				}
			}
			if(GetPlayerCash(i) < 0) {
				if(!GetPVarType(i, "debtMsg")) {
					format(string, sizeof(string), "You're now in debt; you must repay the debt of $%s. If not, you will be arrested...", number_format(GetPlayerCash(i)));
					SendClientMessageEx(i, COLOR_LIGHTRED, string);
					SetPVarInt(i, "debtMsg", 1);
				}
			}
			else DeletePVar(i, "debtMsg");
		}	
	}
}

// Timer Name: SaveAccountsUpdate()
// TickRate: 5 Minutes.
task SaveAccountsUpdate[900000]()
{
	//foreach(new i: Player)
	for(new i = 0; i < MAX_PLAYERS; ++i)
	{
		if(IsPlayerConnected(i))
		{
			if(gPlayerLogged{i}) {
				SetPVarInt(i, "AccountSaving", 1);
				OnPlayerStatsUpdate(i);
				break; // We only need to save one person at a time.
			}
		}	
	}
}

// Timer Name: ProductionUpdate()
// TickRate: 5 Minutes.
task ProductionUpdate[300000]()
{
	// Dump Accounts to /accdump/ for Crash Recovery.
	// g_mysql_DumpAccounts();

	AdvisorMessage++;
	//foreach(new i: Player)
	for(new i = 0; i < MAX_PLAYERS; ++i)
	{
		if(IsPlayerConnected(i))
		{
			if(GetPVarInt(i, "ManualSave")) DeletePVar(i, "ManualSave");

			if(AdvisorMessage == 3 && Advisors > 0 && PlayerInfo[i][pLevel] < 4)
			{
				SendClientMessageEx(i, COLOR_LIGHTBLUE, "Need help? The Community Advisors are here to help you. (/requesthelp to get help)");
			}
			if(PlayerInfo[i][pConnectHours] < 2) {
				SendClientMessageEx(i, COLOR_LIGHTRED, "Due to an increase in new playing accounts being created for Death Matching, weapons for new players are restricted for the first two hours of game play.");
			}

			if(PlayerInfo[i][pFishes] >= 5) {
				if(FishCount[i] >= 3) PlayerInfo[i][pFishes] = 0;
				else ++FishCount[i];
			}
			if(PlayerDrunk[i] > 0) { PlayerDrunk[i] = 0; PlayerDrunkTime[i] = 0; GameTextForPlayer(i, "~p~Drunk effect~n~~w~Gone", 3500, 1); }
		}	
	}
	if(AdvisorMessage == 3) {
		AdvisorMessage = 0;
	}
	if(VIPGifts == 1) {
		if(VIPGiftsTimeLeft > 0)
		{
			VIPGiftsTimeLeft -= 5;
			if(VIPGiftsTimeLeft > 0)
			{
				new string[128];
				format(string, sizeof(string), "%s would like for you to come to Club VIP for free gifts and great times [%d minutes remains]", VIPGiftsName, VIPGiftsTimeLeft);
				SendVIPMessage(COLOR_LIGHTGREEN, string);
			}
		}
		else
		{
			VIPGiftsTimeLeft = 0;
			VIPGifts = 0;
			new string[128];
			format(string, sizeof(string), "Club VIP is no longer giving away free gifts. Thanks for coming!", VIPGiftsName, VIPGiftsTimeLeft);
			SendVIPMessage(COLOR_LIGHTGREEN, string);
		}
	}
	SaveFamilies();
}


// Timer Name: playerTabbedLoop()
// TickRate: 1 secs.
task playerTabbedLoop[1000]() {

	new
		iTick = gettime() - 1;

	//foreach(new x: Player)
	for(new x = 0; x < MAX_PLAYERS; ++x)
	{
		if(IsPlayerConnected(x))
		{
			if(1 <= GetPlayerState(x) <= 3) {
				if(playerTabbed[x] >= 1) {
					if(++playerTabbed[x] >= 1200 && PlayerInfo[x][pAdmin] < 2) {
						SendClientMessageEx(x, COLOR_WHITE, "You have been automatically kicked for alt-tabbing.");
						return Disconnect(x);
					}
				}
				else if(++playerSeconds[x] < iTick && playerTabbed[x] == 0) {
					playerTabbed[x] = 1;
				}
				else if((IsPlayerInRangeOfPoint(x, 2.0, PlayerPos[x][0], PlayerPos[x][1], PlayerPos[x][2]) || InsidePlane[x] != INVALID_PLAYER_ID) && ++playerLastTyped[x] >= 10) {
					if(++playerAFK[x] >= 1200 && PlayerInfo[x][pAdmin] < 2) {
						SendClientMessageEx(x, COLOR_WHITE, "You have been automatically kicked for idling.");
						return Disconnect(x);
					}
				}
				else playerAFK[x] = 0;
				GetPlayerPos(x, PlayerPos[x][0], PlayerPos[x][1], PlayerPos[x][2]);
			}
		}	
	}
	return 1;
}

// Timer Name: MoneyUpdate()
// TickRate: 1 secs.
task MoneyUpdate[1000]()
{
	for(new i = 0; i < MAX_ITEMS; i++)
	{
	    if(Price[i] != ShopItems[i][sItemPrice])
	    {
	        new string[128];
	        format(string, 128, "Item: %d - Price: %d - Reset: %d", i, ShopItems[i][sItemPrice], Price[i]);
	        Log("error.log", string);
	        ShopItems[i][sItemPrice] = Price[i];
	    }
	}

	new minuitet=minuite;
	gettime(hour,minuite,second);
	FixHour(hour);
	hour = shifthour;
	if(minuitet != minuite)
	{
		new tstring[7];
		if(minuite < 10)
		{
			format(tstring, sizeof(tstring), "%d:0%d", hour, minuite);
		}
		else
		{
			format(tstring, sizeof(tstring), "%d:%d", hour, minuite);
		}
		TextDrawSetString(WristWatch, tstring);
	}
	if(EventKernel[EventStatus] >= 2 && EventKernel[EventTime] > 0)
	{
    	if(--EventKernel[EventTime] <= 0) {
    	    //foreach(new i: Player)
			for(new i = 0; i < MAX_PLAYERS; ++i)
			{
				if(IsPlayerConnected(i))
				{
					if( GetPVarInt( i, "EventToken" ) == 1 )
					{
						if(EventKernel[EventType] == 3) {
							if(IsValidDynamic3DTextLabel(RFLTeamN3D[i])) {
								DestroyDynamic3DTextLabel(RFLTeamN3D[i]);
							}
							DisablePlayerCheckpoint(i);
						}
						ResetPlayerWeapons( i );
						SetPlayerWeapons(i);
						SetPlayerToTeamColor(i);
						SetPlayerSkin(i, PlayerInfo[i][pModel]);
						SetPlayerPos(i,EventFloats[i][1],EventFloats[i][2],EventFloats[i][3]);
						Player_StreamPrep(i, EventFloats[i][1],EventFloats[i][2],EventFloats[i][3], FREEZE_TIME);
						SetPlayerVirtualWorld(i, EventLastVW[i]);
						SetPlayerFacingAngle(i, EventFloats[i][0]);
						SetPlayerInterior(i,EventLastInt[i]);
						SetPlayerHealth(i, EventFloats[i][4]);
						if(EventFloats[i][5] > 0) {
							SetPlayerArmor(i, EventFloats[i][5]);
						}
						for(new d = 0; d < 6; d++)
						{
							EventFloats[i][d] = 0.0;
						}
						EventLastVW[i] = 0;
						EventLastInt[i] = 0;
						DeletePVar(i, "EventToken");
						SendClientMessageEx( i, COLOR_YELLOW, "You have been removed from the event as it has been terminated by the timer." );
					}
				}
			}
			EventKernel[ EventPositionX ] = 0;
			EventKernel[ EventPositionY ] = 0;
			EventKernel[ EventPositionZ ] = 0;
			EventKernel[ EventTeamPosX1 ] = 0;
			EventKernel[ EventTeamPosY1 ] = 0;
			EventKernel[ EventTeamPosZ1 ] = 0;
			EventKernel[ EventTeamPosX2 ] = 0;
			EventKernel[ EventTeamPosY2 ] = 0;
			EventKernel[ EventTeamPosZ2 ] = 0;
			EventKernel[ EventStatus ] = 0;
			EventKernel[ EventType ] = 0;
			EventKernel[ EventHealth ] = 0;
			EventKernel[ EventLimit ] = 0;
			EventKernel[ EventPlayers ] = 0;
			EventKernel[ EventWeapons ][0] = 0;
			EventKernel[ EventWeapons ][1] = 0;
			EventKernel[ EventWeapons ][2] = 0;
			EventKernel[ EventWeapons ][3] = 0;
			EventKernel[ EventWeapons ][4] = 0;
			for(new i = 0; i < 20; i++)
			{
			    EventRCPU[i] = 0;
			    EventRCPX[i] = 0.0;
			    EventRCPY[i] = 0.0;
			    EventRCPZ[i] = 0.0;
			    EventRCPS[i] = 0.0;
			    EventRCPT[i] = 0;
			}
			EventKernel[EventCreator] = INVALID_PLAYER_ID;
			EventKernel[VipOnly] = 0;
			EventKernel[EventJoinStaff] = 0;
			SendClientMessageToAllEx( COLOR_LIGHTBLUE, "* The event has been finished because the time limit has been reached." );
		}
	}
	//foreach(new i: Player)
	for(new i = 0; i < MAX_PLAYERS; ++i)
	{
		if(IsPlayerConnected(i))
		{
			if(gPlayerLogged{i})
			{
				if(IsSpawned[i] == 0) 
				{
					SpawnKick[i]++;
					if(SpawnKick[i] >= 120)
					{
						IsSpawned[i] = 1;
						SpawnKick[i] = 0;
						new string[128];
						SendClientMessageEx(i, COLOR_WHITE, "SERVER: You have been kicked for being AFK.");
						format(string, sizeof(string), " %s (ID: %d) (IP: %s) has been kicked for not being spawned over 2 minutes.", GetPlayerNameEx(i), i, GetPlayerIpEx(i));
						Log("logs/spawnafk.log", string);
						SetTimerEx("KickEx", 1000, 0, "i", i);
					}
				}
				if(IsSpawned[i] > 0 && SpawnKick[i] > 0)
				{
					SpawnKick[i] = 0;
				}
				if(GetPlayerPing(i) > MAX_PING)
				{
					if(playerTabbed[i] == 0)
					{
						if(GetPVarInt(i, "BeingKicked") != 1)
						{
							new
								string[89 + MAX_PLAYER_NAME], ping;
								
							ping = GetPlayerPing(i);
							if(ping != 65535) // Invalid Ping
							{
								format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s has just been kicked for %d ping (maximum: "#MAX_PING").", GetPlayerNameEx(i), ping);
								ABroadCast(COLOR_YELLOW, string, 2);
								SendClientMessageEx(i, COLOR_WHITE, "You have been kicked because your ping is higher than the maximum.");
								SetPVarInt(i, "BeingKicked", 1);
								SetTimerEx("KickEx", 1000, 0, "i", i);
							}
						}
					}
				}

				if(PlayerInfo[i][pBuddyInvited] == 1 && --PlayerInfo[i][pTempVIP] <= 0)
				{
					PlayerInfo[i][pTempVIP] = 0;
					PlayerInfo[i][pBuddyInvited] = 0;
					PlayerInfo[i][pDonateRank] = 0;
					SendClientMessageEx(i, COLOR_LIGHTBLUE, "Your temporary VIP subscription has expired.");
					SetPlayerToTeamColor(i);
				}
				if(rBigEarT[i] > 0) {
					rBigEarT[i]--;
					if(rBigEarT[i] == 0) {
						DeletePVar(i, "BigEar");
						DeletePVar(i, "BigEarPlayer");
						SendClientMessageEx(i, COLOR_WHITE, "Big Ears has been turned off.");
					}	
				}
				if(PlayerInfo[i][pTriageTime] != 0)
				{
					PlayerInfo[i][pTriageTime]--;
				}
				if(PlayerInfo[i][pTicketTime] != 0)
				{
					PlayerInfo[i][pTicketTime]--;
				}
				if(GetPVarInt(i, "InRangeBackup") > 0)
				{
					SetPVarInt(i, "InRangeBackup", GetPVarInt(i, "InRangeBackup")-1);
				}
				if(GetPVarType(i, "IsTackled"))
				{
					new copcount, string[128];
					//foreach(new j: Player)
					for(new j = 0; j < MAX_PLAYERS; ++j)
					{
						if(IsPlayerConnected(j))
						{
							if(ProxDetectorS(4.0, i, j) && IsACop(j) && j != i)
							{
								copcount++;
							}
						}	
					}
					if(copcount == 0 || !ProxDetectorS(5.0, i, GetPVarInt(i, "IsTackled")))
					{
						SendClientMessageEx(i, COLOR_GREEN, "You're able to escape due to the cops leaving you unrestrained.");
						ClearTackle(i);
					}
					if(GetPVarInt(i, "TackleCooldown") > 0)
					{
						if(IsPlayerConnected(GetPVarInt(i, "IsTackled")) && GetPVarInt(GetPVarInt(i, "IsTackled"), "Tackling") == i)
						{
							format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~r~%d", GetPVarInt(i, "TackleCooldown"));
							GameTextForPlayer(i, string, 1100, 3);
							SetPVarInt(i, "TackleCooldown", GetPVarInt(i, "TackleCooldown")-1);
							if(GetPVarInt(i, "TackledResisting") == 2 && copcount <= 3 && GetPVarInt(i, "TackleCooldown") < 12) // resisting
							{
								new escapechance = random(100);
								switch(escapechance)
								{
									case 35,40,22,72,11..16, 50..57, 62..65:
									{
										GameTextForPlayer(i, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~ESCAPE!", 10000, 3);
										SendClientMessageEx(i, COLOR_GREEN, "You're able to push the officer off you and escape.");
										format(string, sizeof(string), "** %s pushes %s aside and is able to escape.", GetPlayerNameEx(i), GetPlayerNameEx(GetPVarInt(i, "IsTackled")));
										ProxDetector(30.0, i, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
										TogglePlayerControllable(GetPVarInt(i, "IsTackled"), 0);
										ApplyAnimation(GetPVarInt(i, "IsTackled"), "SWEET", "Sweet_injuredloop", 4.0, 1, 1, 1, 1, 0, 1);
										SetTimerEx("CopGetUp", 2500, 0, "i", GetPVarInt(i, "IsTackled"));
										ClearTackle(i);
									}
								}
							}
						}
					}
					else
					{
						if(ProxDetectorS(5.0, i, GetPVarInt(i, "IsTackled")))
						{
							CopGetUp(GetPVarInt(i, "IsTackled"));
						}
						SetPVarInt(GetPVarInt(i, "IsTackled"), "CopTackleCooldown", 30);
						ShowPlayerDialog(i, -1, DIALOG_STYLE_LIST, "Close", "Close", "Close", "Close");
						ClearTackle(i);
					}
				}
				if(GetPVarInt(i, "CopTackleCooldown") > 0)
				{
					SetPVarInt(i, "CopTackleCooldown", GetPVarInt(i, "CopTackleCooldown")-1);
				}
				if(PlayerInfo[i][pCash] != GetPlayerMoney(i))
				{
					/*if((GetPlayerAnimationIndex(i) == 1660) && ((PlayerInfo[i][pCash] - GetPlayerMoney(i)) == 1))
					{
						new Float:hp;
						GetPlayerHealth(i, hp);
						if(hp + 35 >= 100.0) pSSHealth[i] = 100.0;
						else pSSHealth[i] = hp + 35.0;
					}*/
					ResetPlayerMoney(i);
					GivePlayerMoney(i, PlayerInfo[i][pCash]);
				}
				if(PlayerInfo[i][pGPS] > 0 && GetPVarType(i, "gpsonoff"))
				{
					new zone[28];
					GetPlayer3DZone(i, zone, MAX_ZONE_NAME);
					TextDrawSetString(GPS[i], zone);
				}
				if(GetPVarType(i, "Injured")) SetPlayerArmedWeapon(i, 0);
				if(GetPVarType(i, "IsFrozen")) TogglePlayerControllable(i, 0);
				if(PlayerCuffed[i] > 1) {
					SetPlayerHealth(i, 1000);
					SetPlayerArmor(i, GetPVarFloat(i, "cuffarmor"));
				}
				if(IsPlayerInAnyVehicle(i) && TruckUsed[i] != INVALID_VEHICLE_ID)
				{
					if(TruckUsed[i] == GetPlayerVehicleID(i) && GetPVarInt(i, "Gas_TrailerID") != 0)
					{
						if(Businesses[TruckDeliveringTo[TruckUsed[i]]][bType] == BUSINESS_TYPE_GASSTATION)
						{
							if(GetVehicleTrailer(GetPlayerVehicleID(i)) != GetPVarInt(i, "Gas_TrailerID"))
							{
								SetPVarInt(i, "GasWarnings", GetPVarInt(i, "GasWarnings") + 1);
								if(GetPVarInt(i, "GasWarnings") > 10)
								{
									CancelTruckDelivery(i);
									DeletePVar(i, "GasWarnings");
									SendClientMessageEx(i, COLOR_REALRED, "You have failed your delivery as you lost your load!");
								}
							}
						}
					}
				}
			}
		}	
	}
}

// Timer Name: SpecUpdate()
// TickRate: 3 secs.
/*task SpecUpdate[3000]()
{
	foreach(new i: Player)
	{
	    if(PlayerInfo[i][pAdmin] >= 2 || PlayerInfo[i][pHelper] >= 3 || PlayerInfo[i][pWatchdog] == 1)
	    {
		    if(Spectating[i] >= 1)
		    {
				if(Spectate[i] < 553)
				{
					new targetid = Spectate[ i ];
					if( !IsPlayerConnected( targetid ) )
					{
    					SendClientMessageEx( i, COLOR_WHITE, "The player you were spectating has left the server." );
			    		GettingSpectated[Spectate[i]] = INVALID_PLAYER_ID;
			    		Spectating[i] = 0;
						Spectate[i] = INVALID_PLAYER_ID;
						SetPVarInt(i, "SpecOff", 1 );
						TogglePlayerSpectating( i, false );
						SetCameraBehindPlayer(i);

						if(GetPVarType(i, "pWatchdogWatching")) DeletePVar(i, "pWatchdogWatching");
					}
				}
				if(Spectate[i] == 553)
				{
					TogglePlayerControllable(i, 1);
					TogglePlayerSpectating(i, 0);
					DeletePVar(i, "MedicBill");
					SpawnPlayer( i );
					Spectate[i] = INVALID_PLAYER_ID;
					Spectating[i] = 0;
				}
				if(Spectate[i] == 556)
				{
					SetPlayerToTeamColor(i);
					Spectate[i] = INVALID_PLAYER_ID;
				}
			}
		}
	}
}*/

// Timer Name: TurfWarsUpdate()
// TickRate: 1 secs.
task TurfWarsUpdate[1000]()
{
	for(new i = 0; i < MAX_TURFS; i++)
	{
	    if(TurfWars[i][twActive] == 1)
	    {
	        if(TurfWars[i][twTimeLeft] > 0)
	        {
	            TurfWars[i][twTimeLeft]--;
	        }
	        else
	        {
	            if(TurfWars[i][twAttemptId] != -1)
	            {
					CaptureTurfWarsZone(TurfWars[i][twAttemptId],i);
	            }
				TurfWars[i][twActive] = 0;
				//foreach(new x: Player)
				for(new x = 0; x < MAX_PLAYERS; ++x)
				{
					if(IsPlayerConnected(x))
					{
						if(turfWarsMiniMap[x] == 1)
						{
							turfWarsMiniMap[x] = 0;
							SetPlayerToTeamColor(x);
						}
					}	
				}
	        }
	    }
	}
}

// Timer Name: PaintballArenaUpdate()
// TickRate: 1 secs.
task PaintballArenaUpdate[1000]()
{
	for(new i = 0; i < MAX_ARENAS; i++)
	{
	    if(PaintBallArena[i][pbActive] == 1)
	    {
	        if(PaintBallArena[i][pbGameType] == 3)
	        {
	            if(PaintBallArena[i][pbFlagRedActive] == 1)
	            {
	                if(PaintBallArena[i][pbFlagRedActiveTime] <= 0)
	                {
	                    ResetFlagPaintballArena(i,1);
	                    PaintBallArena[i][pbFlagRedActiveTime] = 0;
	                }
	                PaintBallArena[i][pbFlagRedActiveTime]--;
	            }
	            if(PaintBallArena[i][pbFlagBlueActive] == 1)
	            {
	                if(PaintBallArena[i][pbFlagBlueActiveTime] <= 0)
	                {
	                    ResetFlagPaintballArena(i,2);
	                    PaintBallArena[i][pbFlagBlueActiveTime] = 0;
	                }
	                PaintBallArena[i][pbFlagBlueActiveTime]--;
	            }
	        }

	        // Inactive Players Check
	        if(PaintBallArena[i][pbPlayers] > 1)
	        {
				PaintBallArena[i][pbTimeLeft]--;
			}

			if(PaintBallArena[i][pbTimeLeft] == 300-1)
			{
			    SendPaintballArenaMessage(i, COLOR_YELLOW, "Five minutes left in this round!");
				//SendPaintballArenaSound(i, 1057);
				////SendPaintballArenaAudio(i, 5, 100);
			}

			if(PaintBallArena[i][pbTimeLeft] == 180)
			{
				SendPaintballArenaMessage(i, COLOR_YELLOW, "Three minutes left in this round!");
				//SendPaintballArenaSound(i, 1057);
				////SendPaintballArenaAudio(i, 4, 100);
			}
			if(PaintBallArena[i][pbTimeLeft] == 120)
			{
				SendPaintballArenaMessage(i, COLOR_YELLOW, "Two minutes left in this round!");
				//SendPaintballArenaSound(i, 1057);
				//SendPaintballArenaAudio(i, 3, 100);
			}
			if(PaintBallArena[i][pbTimeLeft] == 60)
			{
				SendPaintballArenaMessage(i, COLOR_YELLOW, "One minute left in this round!");
				//SendPaintballArenaSound(i, 1057);
				//SendPaintballArenaAudio(i, 2, 100);
			}
			if(PaintBallArena[i][pbTimeLeft] == 30)
			{
			    SendPaintballArenaMessage(i, COLOR_YELLOW, "30 seconds left in this round!");
			    //SendPaintballArenaSound(i, 1057);
			    //SendPaintballArenaAudio(i, 6, 100);
			}
			if(PaintBallArena[i][pbTimeLeft] == 12)
			{
			    SendPaintballArenaMessage(i, COLOR_RED, "Sudden death, 5 seconds left!");
			    //SendPaintballArenaSound(i, 1057);
			    //SendPaintballArenaAudio(i, 37, 100);
			}
			if(PaintBallArena[i][pbTimeLeft] == 7)
			{
			    SendPaintballArenaMessage(i, COLOR_YELLOW, "Round Over!");
			    //SendPaintballArenaSound(i, 1057);
			    //SendPaintballArenaAudio(i, 20, 100);
			}
			if(PaintBallArena[i][pbTimeLeft] >= 1 && PaintBallArena[i][pbTimeLeft] <= 7)
			{
			    //foreach(new p: Player)
				for(new p = 0; p < MAX_PLAYERS; ++p)
				{
					if(IsPlayerConnected(p))
					{
						new arenaid = GetPVarInt(p, "IsInArena");
						if(arenaid == i)
						{
							TogglePlayerControllable(p, 0);
							PaintballScoreboard(p, arenaid);
						}
					}	
			    }
			    //SendPaintballArenaSound(i, 1057);
			}
			if(PaintBallArena[i][pbTimeLeft] <= 0)
			{
			    new
					winnerid = SortWinnerPaintballScores(i),
					string[60 + MAX_PLAYER_NAME];

			    format(string, sizeof(string), "%s has won $%d from the Paintball Match, thanks for playing!",GetPlayerNameEx(winnerid),PaintBallArena[i][pbMoneyPool]);
			    GivePlayerCash(winnerid,PaintBallArena[i][pbMoneyPool]);
			    SendPaintballArenaMessage(i, COLOR_YELLOW, string);
			    //foreach(new p: Player)
				for(new p = 0; p < MAX_PLAYERS; ++p)
				{
					if(IsPlayerConnected(p))
					{
						new arenaid = GetPVarInt(p, "IsInArena");
						if(arenaid == i)
						{
							PaintballScoreboard(p, arenaid);
							TogglePlayerControllable(p, 1);
						}
					}	
			    }
			    //foreach(new p: Player)
				for(new p = 0; p < MAX_PLAYERS; ++p)
				{
					if(IsPlayerConnected(p))
					{
						new arenaid = GetPVarInt(p, "IsInArena");
						if(arenaid == i)
						{
							LeavePaintballArena(p, arenaid);
						}
					}	
			    }
			    ResetPaintballArena(i);
			}
	    }
	}
}

// Timer Name: EMSUpdate()
// TickRate: 5 secs.
task EMSUpdate[5000]()
{
	//foreach(new i: Player)
	for(new i = 0; i < MAX_PLAYERS; ++i)
	{
		if(IsPlayerConnected(i))
		{
			if(InsideTut{i} > 0)
			{
				if(gettime() - GetPVarInt(i, "pTutTime") > 20)
				{
					GameTextForPlayer(i, "~n~~n~~n~~n~~n~~n~~n~~n~~w~Press ~r~~k~~CONVERSATION_YES~~w~ to continue", 2000, 3);
				}
			}
			if(GetPVarType(i, "Injured"))
			{
				#if defined zombiemode
				if(zombieevent == 1 && GetPVarType(i, "pZombieBit"))
				{
					KillEMSQueue(i);
					ClearAnimations(i);
					MakeZombie(i);
				}
				#endif
				if(GetPVarInt(i, "EMSAttempt") != 0)
				{

					new Float:health;
					GetPlayerHealth(i,health);
					SetPlayerHealth(i, health-1);
					if(GetPVarInt(i, "EMSAttempt") == -1)
					{
						if(GetPlayerAnimationIndex(i) != 746) ClearAnimations(i), ApplyAnimation(i, "KNIFE", "KILL_Knife_Ped_Die", 4.0, 0, 1, 1, 1, 0, 1);
						if(!GetPVarType(i, "StreamPrep") && !IsPlayerInRangeOfPoint(i, 3.0, GetPVarFloat(i,"MedicX"), GetPVarFloat(i,"MedicY"), GetPVarFloat(i,"MedicZ")) && !GetPVarInt(i, "OnStretcher"))
						{
							SendClientMessageEx(i, COLOR_WHITE, "You fell unconscious, you were immediately sent to the hospital.");
							KillEMSQueue(i);
							SpawnPlayer(i);
						}
						GameTextForPlayer(i, "~r~Injured~n~~w~/accept death or /service ems", 5000, 3);
					}
					if(GetPVarInt(i, "EMSAttempt") == 1)
					{
						if(GetPlayerAnimationIndex(i) != 746) ClearAnimations(i), ApplyAnimation(i, "KNIFE", "KILL_Knife_Ped_Die", 4.0, 0, 1, 1, 1, 0, 1);
						if(!GetPVarType(i, "StreamPrep") && !IsPlayerInRangeOfPoint(i, 3.0, GetPVarFloat(i,"MedicX"), GetPVarFloat(i,"MedicY"), GetPVarFloat(i,"MedicZ")) && !GetPVarInt(i, "OnStretcher"))
						{
							SendClientMessageEx(i, COLOR_WHITE, "You fell unconscious, you were immediately sent to the hospital.");
							KillEMSQueue(i);
							SpawnPlayer(i);
						}
						GameTextForPlayer(i, "~r~Injured~n~~w~Waiting for EMS to Arrive...", 5000, 3);
					}
					if(GetPVarInt(i, "EMSAttempt") == 2)
					{
						if(!GetPVarType(i, "StreamPrep") && !IsPlayerInRangeOfPoint(i, 3.0, GetPVarFloat(i,"MedicX"), GetPVarFloat(i,"MedicY"), GetPVarFloat(i,"MedicZ")) && !GetPVarInt(i, "OnStretcher"))
						{
							SetPVarInt(i, "EMSWarns", GetPVarInt(i, "EMSWarns")+1);
							if(GetPVarInt(i, "EMSWarns") == 2)
							{
								SendClientMessageEx(i, COLOR_WHITE, "You fell unconscious, you were immediately sent to the hospital.");
								KillEMSQueue(i);
								SpawnPlayer(i);
								DeletePVar(i, "EMSWarns");
							}
						}
						GameTextForPlayer(i, "~g~Rescued~n~~w~Awaiting Treatment...", 5000, 3);
					}
					if(GetPVarInt(i, "EMSAttempt") == 3)
					{
						if(IsPlayerInAnyVehicle(i))
						{
							new ambmodel = GetPlayerVehicleID(i);
							if(IsAnAmbulance(ambmodel))
							{
								GameTextForPlayer(i, "~g~Rescued~n~~w~Waiting for EMS to take to Hospital...", 5000, 3);
							}
							else
							{
								SendClientMessageEx(i, COLOR_WHITE, "You fell unconscious due to no life support, you were immediately sent to the hospital.");
								KillEMSQueue(i);
								SpawnPlayer(i);
							}
						}
						else
						{
							SetPVarInt(i, "EMSWarnst", GetPVarInt(i, "EMSWarnst")+1);
							if(GetPVarInt(i, "EMSWarnst") == 2)
							{
								SendClientMessageEx(i, COLOR_WHITE, "You fell out of the vehicle, you were immediately sent to the hospital.");
								KillEMSQueue(i);
								SpawnPlayer(i);
								DeletePVar(i, "EMSWarnst");
							}
						}
					}

					GetPlayerHealth(i, health);
					if(health <= 5)
					{
						SendClientMessageEx(i, COLOR_WHITE, "You fell unconscious, you were immediately sent to the hospital.");
						KillEMSQueue(i);
						SpawnPlayer(i);
					}
				}
			}
		}	
	}
}

// Timer Name: ServerHeartbeat()
// TickRate: 1 secs.
task ServerHeartbeat[1000]() {
    if(++AdminWarning == 15) {
		for(new z = 0; z < MAX_REPORTS; z++)
		{
			if(Reports[z][BeingUsed] == 1)
			{
				if(Reports[z][ReportPriority] == 1 || Reports[z][ReportPriority] == 2)
				{
					ABroadCast(COLOR_LIGHTRED,"A priority report is pending.", 2, true);
					break;
				}
			}
		}
		AdminWarning = 0;
	}
    static string[128];
	//foreach(new i: Player)
	for(new i = 0; i < MAX_PLAYERS; ++i)
	{
		if(IsPlayerConnected(i))
		{
			if(playerTabbed[i] == 0) {
				switch(PlayerInfo[i][pLevel]) {
					case 0 .. 2: PlayerInfo[i][pPayCheck] += 1;
					case 3 .. 4: PlayerInfo[i][pPayCheck] += 2;
					case 5 .. 6: PlayerInfo[i][pPayCheck] += 3;
					case 7 .. 8: PlayerInfo[i][pPayCheck] += 4;
					case 9 .. 10: PlayerInfo[i][pPayCheck] += 5;
					case 11 .. 12: PlayerInfo[i][pPayCheck] += 6;
					case 13 .. 14: PlayerInfo[i][pPayCheck] += 7;
					case 15 .. 16: PlayerInfo[i][pPayCheck] += 8;
					case 17 .. 18: PlayerInfo[i][pPayCheck] += 9;
					case 19 .. 20: PlayerInfo[i][pPayCheck] += 10;
					default: PlayerInfo[i][pPayCheck] += 11;
				}
				if(++PlayerInfo[i][pConnectSeconds] >= 3600) {
					PayDay(i);
				}
			}

			if (GetPVarInt(i, "MailTime") > 0)
				SetPVarInt(i, "MailTime", GetPVarInt(i, "MailTime") - 1);
			else
				DeletePVar(i, "MailTime");

			if(PlayerInfo[i][pJudgeJailType] != 0 && PlayerInfo[i][pJudgeJailTime] > 0 && !PlayerInfo[i][pBeingSentenced]) PlayerInfo[i][pJudgeJailTime]--;
			if(PlayerInfo[i][pJudgeJailTime] <= 0 && PlayerInfo[i][pJudgeJailType] != 0) PlayerInfo[i][pJudgeJailType] = 0;
			if(playerTabbed[i] == 0) {
				if(PlayerInfo[i][pJailTime] > 0 && --PlayerInfo[i][pJailTime] <= 0) {
					if(strfind(PlayerInfo[i][pPrisonReason], "[IC]", true) != -1 || strfind(PlayerInfo[i][pPrisonReason], "[ISOLATE]", true) != -1) {
						SetPlayerInterior(i, 0);
						PlayerInfo[i][pInt] = 0;
						SetPlayerVirtualWorld(i, 0);
						PlayerInfo[i][pVW] = 0;
						SetPlayerPos(i, -2028.5829,-96.5533,35.1641);
					}
					else {
						SetPlayerInterior(i, 0);
						PlayerInfo[i][pInt] = 0;
						SetPlayerVirtualWorld(i, 0);
						PlayerInfo[i][pVW] = 0;
						SetPlayerPos(i, 1544.5059,-1675.5673,13.5585);
					}
					SetPlayerHealth(i, 100);
					PlayerInfo[i][pJailTime] = 0;
					PhoneOnline[i] = 0;
					SendClientMessageEx(i, COLOR_GRAD1,"   You have paid your debt to society.");
					GameTextForPlayer(i, "~g~Freedom~n~~w~Try to be a better citizen", 5000, 1);
					ClearCrimes(i);
					strcpy(PlayerInfo[i][pPrisonReason], "None", 128);
					SetPlayerToTeamColor(i);
				}
			}

			if(CommandSpamTimes[i] != 0)
			{
				CommandSpamTimes[i]--;
			}
			if(TextSpamTimes[i] != 0)
			{
				TextSpamTimes[i]--;
			}
			if(PlayerInfo[i][pRMuted] == 2) {
				PlayerInfo[i][pRMutedTime]--;
				if(PlayerInfo[i][pRMutedTime] <= 0) {
					PlayerInfo[i][pRMuted] = 0;
				}
			}
			if(PlayerInfo[i][pVMuted] == 2) {
				PlayerInfo[i][pVMutedTime]--;
				if(PlayerInfo[i][pVMutedTime] <= 0) {
					PlayerInfo[i][pVMuted] = 0;
				}
			}
			if(PlayerInfo[i][pRHMuteTime] > 0) {
				PlayerInfo[i][pRHMuteTime]--;
			}

			if(GetPVarType(i, "hFind"))
			{
				new Float:X, Float:Y, Float:Z, pID = GetPVarInt(i, "hFind");
				if(IsPlayerConnected(pID))
				{
					if(PhoneOnline[pID] == 0 && PlayerInfo[pID][pPnumber] != 0|| PlayerInfo[pID][pBugged] == PlayerInfo[i][pMember])
					{
						if(GetPlayerInterior(pID) != 0) {
							DeletePVar(i, "hFind");
							DisablePlayerCheckpoint(i);
							SendClientMessageEx(i, COLOR_GREY, "The signal is too weak to track (Interior).");
						}
						else {
							GetPlayerPos(pID, X, Y, Z);
							SetPlayerCheckpoint(i, X, Y, Z, 4.0);
						}
					}
					else
					{

						SendClientMessageEx(i, COLOR_GRAD2, "Your tracker has lost its signal.");
						DeletePVar(i, "hFind");
						DisablePlayerCheckpoint(i);
					}
				}
			}

			/*if(GetPVarType(i, "Backup"))
			{
				new Float:X, Float:Y, Float:Z, pID = GetPVarInt(i, "Backup");
				if(IsPlayerConnected(pID))
				{
					GetPlayerPos(pID, X, Y, Z);
					SetPlayerCheckpoint(i, X, Y, Z, 4.0);
				}
			}*/

			if(WantLawyer[i] >= 1)
			{
				CallLawyer[i] = 111;
				if(WantLawyer[i] == 1)
				{
					SendClientMessageEx(i, COLOR_LIGHTRED, "Do you want a Lawyer? (Type yes or no)");
				}
				WantLawyer[i] ++;
				if(WantLawyer[i] == 8)
				{
					SendClientMessageEx(i, COLOR_LIGHTRED, "Do you want a Lawyer? (Type yes or no)");
				}
				if(WantLawyer[i] == 15)
				{
					SendClientMessageEx(i, COLOR_LIGHTRED, "Do you want a Lawyer? (Type yes or no)");
				}
				if(WantLawyer[i] == 20)
				{
					SendClientMessageEx(i, COLOR_LIGHTRED, "There is no Lawyer available to you anymore, Jail Time started.");
					WantLawyer[i] = 0;
					CallLawyer[i] = 0;
				}
			}
			if(PlayerDrunk[i] >= 5)
			{
				PlayerDrunkTime[i] += 1;
				if(PlayerDrunkTime[i] == 8)
				{
					PlayerDrunkTime[i] = 0;

					if(IsPlayerInAnyVehicle(i))
					{
						if(GetPlayerState(i) == 2)
						{
							new Float:angle;
							GetPlayerFacingAngle(i, angle);
							SetVehicleZAngle(GetPlayerVehicleID(i), angle + random(10) - 5);
						}
					}
					else
					{
						ApplyAnimation(i,"PED", "WALK_DRUNK",4.0,0,1,0,0,0);
					}
				}
			}
			if(PlayerStoned[i] >= 3)
			{
				PlayerStoned[i] += 1;
				SetPlayerDrunkLevel(i, 40000);
				if(PlayerStoned[i] == 50)
				{
					PlayerStoned[i] = 0;
					SetPlayerDrunkLevel(i, 0);
					SendClientMessageEx(i, COLOR_GRAD1, " You are no longer stoned!");
				}
			}
			if(BoxWaitTime[i] > 0)
			{
				if(BoxWaitTime[i] >= BoxDelay)
				{
					BoxDelay = 0;
					BoxWaitTime[i] = 0;
					PlayerPlaySound(i, 1057, 0.0, 0.0, 0.0);
					GameTextForPlayer(i, "~g~Match Started", 5000, 1);
					TogglePlayerControllable(i, 1);
					RoundStarted = 1;
				}
				else
				{
					format(string, sizeof(string), "%d", BoxDelay - BoxWaitTime[i]);
					GameTextForPlayer(i, string, 1500, 6);
					BoxWaitTime[i] += 1;
				}
			}
			if(RoundStarted > 0)
			{
				if(PlayerBoxing[i] > 0)
				{
					new trigger = 0;
					new Lost = 0;
					new Float:angle;
					new Float:health;
					GetPlayerHealth(i, health);
					if(health < 12)
					{
						if(i == Boxer1) { Lost = 1; trigger = 1; }
						else if(i == Boxer2) { Lost = 2; trigger = 1; }
					}
					if(health < 28) { GetPlayerFacingAngle(i, angle); SetPlayerFacingAngle(i, angle + 85); }
					if(trigger)
					{
						new winner[MAX_PLAYER_NAME];
						new loser[MAX_PLAYER_NAME];
						new titel[MAX_PLAYER_NAME];
						if(Lost == 1)
						{
							if(IsPlayerConnected(Boxer1) && IsPlayerConnected(Boxer2))
							{
								if(IsPlayerInRangeOfPoint(Boxer1,25.0,768.48, -73.66, 1000.57) || IsPlayerInRangeOfPoint(Boxer2,25.0,768.48, -73.66, 1000.57))
								{
									SetPlayerPos(Boxer1, 768.48, -73.66, 1000.57); SetPlayerPos(Boxer2, 768.48, -73.66, 1000.57);
									SetPlayerInterior(Boxer1, 7); SetPlayerInterior(Boxer2, 7);
									GetPlayerName(Boxer1, loser, sizeof(loser));
									GetPlayerName(Boxer2, winner, sizeof(winner));
									SetPlayerWeapons(Boxer1);
									SetPlayerWeapons(Boxer2);
									if(PlayerInfo[Boxer1][pJob] == 12 || PlayerInfo[Boxer1][pJob2] == 12 || PlayerInfo[Boxer1][pJob3] == 12) { PlayerInfo[Boxer1][pLoses] += 1; }
									if(PlayerInfo[Boxer2][pJob] == 12 || PlayerInfo[Boxer2][pJob2] == 12 || PlayerInfo[Boxer2][pJob3] == 12) { PlayerInfo[Boxer2][pWins] += 1; }
									if(TBoxer != INVALID_PLAYER_ID)
									{
										if(IsPlayerConnected(TBoxer))
										{
											if(TBoxer != Boxer2)
											{
												if(PlayerInfo[Boxer2][pJob] == 12 || PlayerInfo[Boxer2][pJob2] == 12 || PlayerInfo[Boxer2][pJob3] == 12)
												{
													TBoxer = Boxer2;
													GetPlayerName(TBoxer, titel, sizeof(titel));
													new nstring[MAX_PLAYER_NAME];
													format(nstring, sizeof(nstring), "%s", titel);
													strmid(Titel[TitelName], nstring, 0, strlen(nstring), 255);
													Titel[TitelWins] = PlayerInfo[TBoxer][pWins];
													Titel[TitelLoses] = PlayerInfo[TBoxer][pLoses];
													Misc_Save();
													format(string, sizeof(string), "Boxing News: %s has Won the fight against Champion %s and is now the new Boxing Champion.",  titel, loser);
													ProxDetector(30.0, Boxer1, string, COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE);
												}
												else
												{
													SendClientMessageEx(Boxer2, COLOR_LIGHTBLUE, "* You would have been the Champion if you had the Boxer Job!");
												}
											}
											else
											{
												GetPlayerName(TBoxer, titel, sizeof(titel));
												format(string, sizeof(string), "Boxing News: Boxing Champion %s has Won the fight against %s.",  titel, loser);
												ProxDetector(30.0, Boxer1, string, COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE);
												Titel[TitelWins] = PlayerInfo[TBoxer][pWins];
												Titel[TitelLoses] = PlayerInfo[Boxer2][pLoses];
												Misc_Save();
											}
										}
									}//TBoxer
									format(string, sizeof(string), "* You have Lost the Fight against %s.", winner);
									SendClientMessageEx(Boxer1, COLOR_LIGHTBLUE, string);
									GameTextForPlayer(Boxer1, "~r~You lost", 3500, 1);
									format(string, sizeof(string), "* You have Won the Fight against %s.", loser);
									SendClientMessageEx(Boxer2, COLOR_LIGHTBLUE, string);
									GameTextForPlayer(Boxer2, "~r~You won", 3500, 1);
									if(GetPlayerHealth(Boxer1, health) < 20)
									{
										SendClientMessageEx(Boxer1, COLOR_LIGHTBLUE, "* You feel exhausted from the Fight, go eat somewhere.");
										SetPlayerHealth(Boxer1, 30.0);
									}
									else
									{
										SendClientMessageEx(Boxer1, COLOR_LIGHTBLUE, "* You feel perfect, even after the Fight.");
										SetPlayerHealth(Boxer1, 50.0);
									}
									if(GetPlayerHealth(Boxer2, health) < 20)
									{
										SendClientMessageEx(Boxer2, COLOR_LIGHTBLUE, "* You feel exhausted from the Fight, go eat somewhere.");
										SetPlayerHealth(Boxer2, 30.0);
									}
									else
									{
										SendClientMessageEx(Boxer2, COLOR_LIGHTBLUE, "* You feel perfect, even after the Fight.");
										SetPlayerHealth(Boxer2, 50.0);
									}
									GameTextForPlayer(Boxer1, "~g~Match Over", 5000, 1); GameTextForPlayer(Boxer2, "~g~Match Over", 5000, 1);
									if(PlayerInfo[Boxer2][pJob] == 12 || PlayerInfo[Boxer2][pJob2] == 12 || PlayerInfo[Boxer2][pJob3] == 12) { PlayerInfo[Boxer2][pBoxSkill] += 1; }
									PlayerBoxing[Boxer1] = 0;
									PlayerBoxing[Boxer2] = 0;
								}
								SetPlayerPos(Boxer1, 765.8433,3.2924,1000.7186); SetPlayerPos(Boxer2, 765.8433,3.2924,1000.7186);
								SetPlayerInterior(Boxer1, 5); SetPlayerInterior(Boxer2, 5);
								GetPlayerName(Boxer1, loser, sizeof(loser));
								GetPlayerName(Boxer2, winner, sizeof(winner));
								SetPlayerWeapons(Boxer1);
								SetPlayerWeapons(Boxer2);
								if(PlayerInfo[Boxer1][pJob] == 12 || PlayerInfo[Boxer1][pJob2] == 12 || PlayerInfo[Boxer1][pJob3] == 12) { PlayerInfo[Boxer1][pLoses] += 1; }
								if(PlayerInfo[Boxer2][pJob] == 12 || PlayerInfo[Boxer2][pJob2] == 12 || PlayerInfo[Boxer2][pJob3] == 12) { PlayerInfo[Boxer2][pWins] += 1; }
								if(TBoxer != INVALID_PLAYER_ID)
								{
									if(IsPlayerConnected(TBoxer))
									{
										if(TBoxer != Boxer2)
										{
											if(PlayerInfo[Boxer2][pJob] == 12 || PlayerInfo[Boxer2][pJob2] == 12 || PlayerInfo[Boxer2][pJob3] == 12)
											{
												TBoxer = Boxer2;
												GetPlayerName(TBoxer, titel, sizeof(titel));
												new nstring[MAX_PLAYER_NAME];
												format(nstring, sizeof(nstring), "%s", titel);
												strmid(Titel[TitelName], nstring, 0, strlen(nstring), 255);
												Titel[TitelWins] = PlayerInfo[TBoxer][pWins];
												Titel[TitelLoses] = PlayerInfo[TBoxer][pLoses];
												Misc_Save();
												format(string, sizeof(string), "Boxing News: %s has Won the fight against Champion %s and is now the new Boxing Champion.",  titel, loser);
												ProxDetector(30.0, Boxer1, string, COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE);
											}
											else
											{
												SendClientMessageEx(Boxer2, COLOR_LIGHTBLUE, "* You would have been the Champion if you had the Boxer Job!");
											}
										}
										else
										{
											GetPlayerName(TBoxer, titel, sizeof(titel));
											format(string, sizeof(string), "Boxing News: Boxing Champion %s has Won the fight against %s.",  titel, loser);
											ProxDetector(30.0, Boxer1, string, COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE);
											Titel[TitelWins] = PlayerInfo[TBoxer][pWins];
											Titel[TitelLoses] = PlayerInfo[Boxer2][pLoses];
											Misc_Save();
										}
									}
								}//TBoxer
								format(string, sizeof(string), "* You have Lost the Fight against %s.", winner);
								SendClientMessageEx(Boxer1, COLOR_LIGHTBLUE, string);
								GameTextForPlayer(Boxer1, "~r~You lost", 3500, 1);
								format(string, sizeof(string), "* You have Won the Fight against %s.", loser);
								SendClientMessageEx(Boxer2, COLOR_LIGHTBLUE, string);
								GameTextForPlayer(Boxer2, "~r~You won", 3500, 1);
								if(GetPlayerHealth(Boxer1, health) < 20)
								{
									SendClientMessageEx(Boxer1, COLOR_LIGHTBLUE, "* You feel exhausted from the Fight, go eat somewhere.");
									SetPlayerHealth(Boxer1, 30.0);
								}
								else
								{
									SendClientMessageEx(Boxer1, COLOR_LIGHTBLUE, "* You feel perfect, even after the Fight.");
									SetPlayerHealth(Boxer1, 50.0);
								}
								if(GetPlayerHealth(Boxer2, health) < 20)
								{
									SendClientMessageEx(Boxer2, COLOR_LIGHTBLUE, "* You feel exhausted from the Fight, go eat somewhere.");
									SetPlayerHealth(Boxer2, 30.0);
								}
								else
								{
									SendClientMessageEx(Boxer2, COLOR_LIGHTBLUE, "* You feel perfect, even after the Fight.");
									SetPlayerHealth(Boxer2, 50.0);
								}
								GameTextForPlayer(Boxer1, "~g~Match Over", 5000, 1); GameTextForPlayer(Boxer2, "~g~Match Over", 5000, 1);
								if(PlayerInfo[Boxer2][pJob] == 12 || PlayerInfo[Boxer2][pJob2] == 12 || PlayerInfo[Boxer2][pJob3] == 12) { PlayerInfo[Boxer2][pBoxSkill] += 1; }
								PlayerBoxing[Boxer1] = 0;
								PlayerBoxing[Boxer2] = 0;
							}
						}
						else if(Lost == 2)
						{
							if(IsPlayerConnected(Boxer1) && IsPlayerConnected(Boxer2))
							{
								if(IsPlayerInRangeOfPoint(Boxer1,25.0,768.48, -73.66, 1000.57) || IsPlayerInRangeOfPoint(Boxer2,25.0, 768.48, -73.66, 1000.57))
								{
									SetPlayerPos(Boxer1, 768.48, -73.66, 1000.57); SetPlayerPos(Boxer2, 768.48, -73.66, 1000.57);
									SetPlayerInterior(Boxer1, 7); SetPlayerInterior(Boxer2, 7);
									GetPlayerName(Boxer1, winner, sizeof(winner));
									GetPlayerName(Boxer2, loser, sizeof(loser));
									if(PlayerInfo[Boxer2][pJob] == 12 || PlayerInfo[Boxer2][pJob2] == 12 || PlayerInfo[Boxer2][pJob3] == 12) { PlayerInfo[Boxer2][pLoses] += 1; }
									if(PlayerInfo[Boxer1][pJob] == 12 || PlayerInfo[Boxer1][pJob2] == 12 || PlayerInfo[Boxer1][pJob3] == 12) { PlayerInfo[Boxer1][pWins] += 1; }
									if(TBoxer != INVALID_PLAYER_ID)
									{
										if(IsPlayerConnected(TBoxer))
										{
											if(TBoxer != Boxer1)
											{
												if(PlayerInfo[Boxer1][pJob] == 12 || PlayerInfo[Boxer1][pJob2] == 12 || PlayerInfo[Boxer1][pJob3] == 12)
												{
													TBoxer = Boxer1;
													GetPlayerName(TBoxer, titel, sizeof(titel));
													new nstring[MAX_PLAYER_NAME];
													format(nstring, sizeof(nstring), "%s", titel);
													strmid(Titel[TitelName], nstring, 0, strlen(nstring), 255);
													Titel[TitelWins] = PlayerInfo[TBoxer][pWins];
													Titel[TitelLoses] = PlayerInfo[TBoxer][pLoses];
													Misc_Save();
													format(string, sizeof(string), "Boxing News: %s has Won the fight against Champion %s and is now the new Boxing Champion.",  titel, loser);
													ProxDetector(30.0, Boxer1, string, COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE);
												}
												else
												{
													SendClientMessageEx(Boxer1, COLOR_LIGHTBLUE, "* You would have been the Champion if you had the Boxer Job!");
												}
											}
											else
											{
												GetPlayerName(TBoxer, titel, sizeof(titel));
												format(string, sizeof(string), "Boxing News: Boxing Champion %s has Won the fight against %s.",  titel, loser);
												ProxDetector(30.0, Boxer1, string, COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE);
												Titel[TitelWins] = PlayerInfo[TBoxer][pWins];
												Titel[TitelLoses] = PlayerInfo[Boxer1][pLoses];
												Misc_Save();
											}
										}
									}//TBoxer
									format(string, sizeof(string), "* You have Lost the Fight against %s.", winner);
									SendClientMessageEx(Boxer2, COLOR_LIGHTBLUE, string);
									GameTextForPlayer(Boxer2, "~r~You lost", 3500, 1);
									format(string, sizeof(string), "* You have Won the Fight against %s.", loser);
									SendClientMessageEx(Boxer1, COLOR_LIGHTBLUE, string);
									GameTextForPlayer(Boxer1, "~g~You won", 3500, 1);
									if(GetPlayerHealth(Boxer1, health) < 20)
									{
										SendClientMessageEx(Boxer1, COLOR_LIGHTBLUE, "* You feel exhausted from the Fight, go eat somewhere.");
										SetPlayerHealth(Boxer1, 30.0);
									}
									else
									{
										SendClientMessageEx(Boxer1, COLOR_LIGHTBLUE, "* You feel perfect, even after the Fight.");
										SetPlayerHealth(Boxer1, 50.0);
									}
									if(GetPlayerHealth(Boxer2, health) < 20)
									{
										SendClientMessageEx(Boxer2, COLOR_LIGHTBLUE, "* You feel exhausted from the Fight, go eat somewhere.");
										SetPlayerHealth(Boxer2, 30.0);
									}
									else
									{
										SendClientMessageEx(Boxer2, COLOR_LIGHTBLUE, "* You feel perfect, even after the Fight.");
										SetPlayerHealth(Boxer2, 50.0);
									}
									GameTextForPlayer(Boxer1, "~g~Match Over", 5000, 1); GameTextForPlayer(Boxer2, "~g~Match Over", 5000, 1);
									if(PlayerInfo[Boxer1][pJob] == 12 || PlayerInfo[Boxer1][pJob2] == 12 || PlayerInfo[Boxer1][pJob3] == 12) { PlayerInfo[Boxer1][pBoxSkill] += 1; }
									PlayerBoxing[Boxer1] = 0;
									PlayerBoxing[Boxer2] = 0;
								}
								SetPlayerPos(Boxer1, 768.48, -73.66, 1000.57); SetPlayerPos(Boxer2, 768.48, -73.66, 1000.57);
								SetPlayerInterior(Boxer1, 7); SetPlayerInterior(Boxer2, 7);
								GetPlayerName(Boxer1, winner, sizeof(winner));
								GetPlayerName(Boxer2, loser, sizeof(loser));
								if(PlayerInfo[Boxer2][pJob] == 12 || PlayerInfo[Boxer2][pJob2] == 12 || PlayerInfo[Boxer2][pJob3] == 12) { PlayerInfo[Boxer2][pLoses] += 1; }
								if(PlayerInfo[Boxer1][pJob] == 12 || PlayerInfo[Boxer1][pJob2] == 12 || PlayerInfo[Boxer1][pJob3] == 12) { PlayerInfo[Boxer1][pWins] += 1; }
								if(TBoxer != INVALID_PLAYER_ID)
								{
									if(IsPlayerConnected(TBoxer))
									{
										if(TBoxer != Boxer1)
										{
											if(PlayerInfo[Boxer1][pJob] == 12 || PlayerInfo[Boxer1][pJob2] == 12 || PlayerInfo[Boxer1][pJob3] == 12)
											{
												TBoxer = Boxer1;
												GetPlayerName(TBoxer, titel, sizeof(titel));
												new nstring[MAX_PLAYER_NAME];
												format(nstring, sizeof(nstring), "%s", titel);
												strmid(Titel[TitelName], nstring, 0, strlen(nstring), 255);
												Titel[TitelWins] = PlayerInfo[TBoxer][pWins];
												Titel[TitelLoses] = PlayerInfo[TBoxer][pLoses];
												Misc_Save();
												format(string, sizeof(string), "Boxing News: %s has Won the fight against Champion %s and is now the new Boxing Champion.",  titel, loser);
												ProxDetector(30.0, Boxer1, string, COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE);
											}
											else
											{
												SendClientMessageEx(Boxer1, COLOR_LIGHTBLUE, "* You would have been the Champion if you had the Boxer Job!");
											}
										}
										else
										{
											GetPlayerName(TBoxer, titel, sizeof(titel));
											format(string, sizeof(string), "Boxing News: Boxing Champion %s has Won the fight against %s.",  titel, loser);
											ProxDetector(30.0, Boxer1, string, COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE);
											Titel[TitelWins] = PlayerInfo[TBoxer][pWins];
											Titel[TitelLoses] = PlayerInfo[Boxer1][pLoses];
											Misc_Save();
										}
									}
								}//TBoxer
								format(string, sizeof(string), "* You have Lost the Fight against %s.", winner);
								SendClientMessageEx(Boxer2, COLOR_LIGHTBLUE, string);
								GameTextForPlayer(Boxer2, "~r~You lost", 3500, 1);
								format(string, sizeof(string), "* You have Won the Fight against %s.", loser);
								SendClientMessageEx(Boxer1, COLOR_LIGHTBLUE, string);
								GameTextForPlayer(Boxer1, "~g~You won", 3500, 1);
								if(GetPlayerHealth(Boxer1, health) < 20)
								{
									SendClientMessageEx(Boxer1, COLOR_LIGHTBLUE, "* You feel exhausted from the Fight, go eat somewhere.");
									SetPlayerHealth(Boxer1, 30.0);
								}
								else
								{
									SendClientMessageEx(Boxer1, COLOR_LIGHTBLUE, "* You feel perfect, even after the Fight.");
									SetPlayerHealth(Boxer1, 50.0);
								}
								if(GetPlayerHealth(Boxer2, health) < 20)
								{
									SendClientMessageEx(Boxer2, COLOR_LIGHTBLUE, "* You feel exhausted from the Fight, go eat somewhere.");
									SetPlayerHealth(Boxer2, 30.0);
								}
								else
								{
									SendClientMessageEx(Boxer2, COLOR_LIGHTBLUE, "* You feel perfect, even after the Fight.");
									SetPlayerHealth(Boxer2, 50.0);
								}
								GameTextForPlayer(Boxer1, "~g~Match Over", 5000, 1); GameTextForPlayer(Boxer2, "~g~Match Over", 5000, 1);
								if(PlayerInfo[Boxer1][pJob] == 12 || PlayerInfo[Boxer1][pJob2] == 12 || PlayerInfo[Boxer1][pJob3] == 12) { PlayerInfo[Boxer1][pBoxSkill] += 1; }
								PlayerBoxing[Boxer1] = 0;
								PlayerBoxing[Boxer2] = 0;
							}
						}
						InRing = 0;
						RoundStarted = 0;
						Boxer1 = INVALID_PLAYER_ID;
						Boxer2 = INVALID_PLAYER_ID;
						TBoxer = INVALID_PLAYER_ID;
						trigger = 0;
					}
				}
			}
			if(FindTime[i] >= 1)
			{
				if(FindTime[i] == FindTimePoints[i]) {
					FindTime[i] = 0;
					FindTimePoints[i] = 0;
					SetPlayerToTeamColor(FindingPlayer[i]);
					FindingPlayer[i] = -1;
					PlayerPlaySound(i, 1056, 0.0, 0.0, 0.0);
					GameTextForPlayer(i, "~r~RedMarker gone", 2500, 1);
				}
				else
				{
					format(string, sizeof(string), "%d", FindTimePoints[i] - FindTime[i]);
					GameTextForPlayer(i, string, 1500, 6);
					FindTime[i] += 1;
				}
			}
			if(CalledCops[i] >= 1)
			{
				if(CopsCallTime[i] < 1) { CopsCallTime[i] = 0; HidePlayerBeaconForCops(i); CalledCops[i] = 0; }
				else
				{
					CopsCallTime[i]--;
				}
			}
			if(CalledMedics[i] >= 1)
			{
				if(MedicsCallTime[i] < 1) { MedicsCallTime[i] = 0; HidePlayerBeaconForMedics(i); CalledMedics[i] = 0; }
				else
				{
					MedicsCallTime[i]--;
				}
			}
			if(JustReported[i] > 0)
			{
				JustReported[i]--;
			}
			if(TaxiCallTime[i] > 0)
			{
				if(TaxiAccepted[i] != INVALID_PLAYER_ID)
				{
					if(IsPlayerConnected(TaxiAccepted[i]))
					{
						new Float:X,Float:Y,Float:Z;
						GetPlayerPos(TaxiAccepted[i], X, Y, Z);
						SetPlayerCheckpoint(i, X, Y, Z, 5);
					}
				}
			}
			if(EMSCallTime[i] > 0)
			{
				if(EMSAccepted[i] != INVALID_PLAYER_ID)
				{
					if(IsPlayerConnected(EMSAccepted[i]))
					{
						new Float:X,Float:Y,Float:Z;
						GetPlayerPos(EMSAccepted[i], X, Y, Z);
						new zone[MAX_ZONE_NAME];
						Get3DZone(X, Y, Z, zone, sizeof(zone));
						format(string, sizeof(string), "Your patient is located in %s.", zone);
						SetPlayerCheckpoint(i, X, Y, Z, 5);
					}
				}
			}

			if(BusCallTime[i] > 0)
			{
				if(BusAccepted[i] != INVALID_PLAYER_ID)
				{
					if(IsPlayerConnected(BusAccepted[i]))
					{
						new Float:X,Float:Y,Float:Z;
						GetPlayerPos(BusAccepted[i], X, Y, Z);
						SetPlayerCheckpoint(i, X, Y, Z, 5);
					}
				}
			}
			if(MedicCallTime[i] > 0)
			{
				if(MedicCallTime[i] == 45) { MedicCallTime[i] = 0; DisablePlayerCheckpoint(i); PlayerPlaySound(i, 1056, 0.0, 0.0, 0.0); GameTextForPlayer(i, "~r~RedMarker gone", 2500, 1); }
				else
				{
					format(string, sizeof(string), "%d", 45 - MedicCallTime[i]);
					new Float:X,Float:Y,Float:Z;
					GetPlayerPos(MedicAccepted[i], X, Y, Z);
					SetPlayerCheckpoint(i, X, Y, Z, 5);
					GameTextForPlayer(i, string, 1500, 6);
					MedicCallTime[i] += 1;
				}
			}
			if(MechanicCallTime[i] > 0)
			{
				if(MechanicCallTime[i] == 30) { MechanicCallTime[i] = 0; DisablePlayerCheckpoint(i); PlayerPlaySound(i, 1056, 0.0, 0.0, 0.0); GameTextForPlayer(i, "~r~RedMarker gone", 2500, 1); }
				else
				{
					format(string, sizeof(string), "%d", 30 - MechanicCallTime[i]);
					GameTextForPlayer(i, string, 1500, 6);
					MechanicCallTime[i] += 1;
				}
			}
			if(PlayerCuffed[i] == 1)
			{
				if(PlayerCuffedTime[i] <= 0)
				{
					//Frozen[i] = 0;
					DeletePVar(i, "IsFrozen");
					TogglePlayerControllable(i, 1);
					PlayerCuffed[i] = 0;
					DeletePVar(i, "PlayerCuffed");
					PlayerCuffedTime[i] = 0;
					ClearAnimations(i);
					new Float:X, Float:Y, Float:Z;
					GetPlayerPos(i, X, Y, Z);
					SetPlayerPos(i, X, Y, Z);
				}
				else
				{
					PlayerCuffedTime[i] -= 1;
				}
			}
			if(PlayerCuffed[i] == 2)
			{
				if(PlayerCuffedTime[i] <= 0)
				{
					new Float:X, Float:Y, Float:Z;
					GetPlayerPos(i, X, Y, Z);
					new copinrange;
					//foreach(new j: Player)
					for(new j = 0; j < MAX_PLAYERS; ++j)
					{
						if(IsPlayerConnected(j))
						{
							if(IsPlayerInRangeOfPoint(j, 30, X, Y, Z) && IsACop(j))
							{
								copinrange = 1;
							}
						}	
					}

					if(copinrange == 0)
					{
						//Frozen[i] = 0;
						DeletePVar(i, "IsFrozen");
						GameTextForPlayer(i, "~r~You broke the Cuffs, you are free!", 2500, 3);
						TogglePlayerControllable(i, 1);
						PlayerCuffed[i] = 0;
						SetPlayerHealth(i, GetPVarFloat(i, "cuffhealth"));
						SetPlayerArmor(i, GetPVarFloat(i, "cuffarmor"));
						DeletePVar(i, "cuffhealth");
						DeletePVar(i, "PlayerCuffed");
						PlayerCuffedTime[i] = 0;
						SetPlayerSpecialAction(i, SPECIAL_ACTION_NONE);
						ClearAnimations(i);
					}
					else
					{
						PlayerCuffedTime[i] = 60;
					}
				}
				else
				{
					PlayerCuffedTime[i] -= 1;
				}
			}
			UpdateSpeedCamerasForPlayer(i);

			if (PlayerInfo[i][pAdmin] < 2 || HelpingNewbie[i] != INVALID_PLAYER_ID)
			{
				if (PlayerInfo[i][pHospital] == 0 && GetPVarInt(i, "Injured") != 1 && GetPVarInt(i, "IsFrozen") == 0 && GetPVarInt(i, "PlayerCuffed") == 0)
				{
					if (++PlayerInfo[i][pHungerTimer] >= 1800 && PlayerInfo[i][pHunger] > 0) // 30 minutes
					{
						PlayerInfo[i][pHungerTimer] = 0;
						PlayerInfo[i][pHunger] -= 8;
						if (PlayerInfo[i][pHunger] < 0)
							PlayerInfo[i][pHunger] = 0;

						if (PlayerInfo[i][pHunger] == 0)
						{
							SendClientMessageEx(i, COLOR_RED, "You hear your stomach rumble - you need to eat!");
						}
					}

					if(PlayerCuffed[i] == 0)
					{
						if (PlayerInfo[i][pHunger] == 0 && ++PlayerInfo[i][pHungerDeathTimer] >= 600) // 10 minutes
						{
							SendClientMessageEx(i, COLOR_RED, "You fall unconcious due to starvation.");
							SetPlayerHealth(i, 0);
							PlayerInfo[i][pHungerDeathTimer] = 0;
						}
					}
				}

				// update hunger text draw
				switch (PlayerInfo[i][pHunger])
				{
					case 80..100:
						PlayerTextDrawSetString(i, _hungerText[i], "Hunger: ~g~Bloated");
					case 40..79:
						PlayerTextDrawSetString(i, _hungerText[i], "Hunger: ~y~Satisfied");
					case 20..39:
						PlayerTextDrawSetString(i, _hungerText[i], "Hunger: ~y~Hungry");
					case 0..19:
						PlayerTextDrawSetString(i, _hungerText[i], "Hunger: ~r~Starving");
				}
			}

			if (GetPVarInt(i, "_BoxingQueue") == 1)
			{
				SetPVarInt(i, "_BoxingQueueTick", GetPVarInt(i, "_BoxingQueueTick") + 1);
				new tick = GetPVarInt(i, "_BoxingQueueTick");

				if (tick == 10)
				{
					SetPVarInt(i, "_BoxingQueueTick", 1);

					//foreach(new ii: Player)
					for(new ii = 0; ii < MAX_PLAYERS; ++ii)
					{
						if(IsPlayerConnected(ii))
						{
							if (GetPVarInt(ii, "_BoxingQueue") == 1 && i != ii)
							{
								new biz = InBusiness(i),
									biz2 = InBusiness(ii);

								if(biz == biz2)
								{
									if (Businesses[biz][bGymBoxingArena1][0] == INVALID_PLAYER_ID)
									{
										Businesses[biz][bGymBoxingArena1][0] = i;
										Businesses[biz][bGymBoxingArena1][1] = ii;

										DeletePVar(i, "_BoxingQueue");
										DeletePVar(i, "_BoxingQueueTick");
										DeletePVar(ii, "_BoxingQueue");
										DeletePVar(ii, "_BoxingQueueTick");

										SetPlayerPos(i, 2924.0735, -2293.3145, 8.0905);
										SetPlayerFacingAngle(i, 136.0062);
										SetPlayerPos(ii, 2920.4709, -2296.9460, 8.0905);
										SetPlayerFacingAngle(ii, 308.0462);

										new Float:health, Float:armour;

										GetPlayerHealth(i, health);
										GetPlayerArmour(i, armour);
										SetPVarFloat(i, "_BoxingCacheHP", health);
										SetPVarFloat(i, "_BoxingCacheArmour", armour);

										GetPlayerHealth(ii, health);
										GetPlayerHealth(ii, armour);
										SetPVarFloat(ii, "_BoxingCacheHP", health);
										SetPVarFloat(ii, "_BoxingCacheArmour", armour);

										SetPlayerHealth(i, 100.0);
										SetPlayerHealth(ii, 100.0);
										RemoveArmor(i);
										RemoveArmor(ii);

										ResetPlayerWeapons(i);
										ResetPlayerWeapons(ii);

										TogglePlayerControllable(i, 0);
										TogglePlayerControllable(ii, 0);

										SetPVarInt(i, "_BoxingFight", ii + 1);
										SetPVarInt(ii, "_BoxingFight", i + 1);
										SetPVarInt(i, "_BoxingFightCountdown", 4);

										new szString[128];
										format(szString, sizeof(szString), "You are now in a boxing match with %s.", GetPlayerNameEx(ii));
										SendClientMessageEx(i, COLOR_WHITE, szString);
										format(szString, sizeof(szString), "You are now in a boxing match with %s.", GetPlayerNameEx(i));
										SendClientMessageEx(ii, COLOR_WHITE, szString);
										break;
									}
									else if (Businesses[biz][bGymBoxingArena2][0] == INVALID_PLAYER_ID)
									{
										Businesses[biz][bGymBoxingArena2][0] = i;
										Businesses[biz][bGymBoxingArena2][1] = ii;

										DeletePVar(i, "_BoxingQueue");
										DeletePVar(i, "_BoxingQueueTick");
										DeletePVar(ii, "_BoxingQueue");
										DeletePVar(ii, "_BoxingQueueTick");

										SetPlayerPos(i, 2920.6958, -2257.4312, 8.0905);
										SetPlayerFacingAngle(i, 310.5444);
										SetPlayerPos(ii, 2924.3989, -2253.8279, 8.0905);
										SetPlayerFacingAngle(ii, 134.5329);

										new Float:health, Float:armour;

										GetPlayerHealth(i, health);
										GetPlayerArmour(i, armour);
										SetPVarFloat(i, "_BoxingCacheHP", health);
										SetPVarFloat(i, "_BoxingCacheArmour", armour);

										GetPlayerHealth(ii, health);
										GetPlayerHealth(ii, armour);
										SetPVarFloat(ii, "_BoxingCacheHP", health);
										SetPVarFloat(ii, "_BoxingCacheArmour", armour);

										ResetPlayerWeapons(i);
										ResetPlayerWeapons(ii);

										SetPlayerHealth(i, 100.0);
										SetPlayerHealth(ii, 100.0);
										RemoveArmor(i);
										RemoveArmor(ii);

										TogglePlayerControllable(i, 0);
										TogglePlayerControllable(ii, 0);

										SetPVarInt(i, "_BoxingFight", ii + 1);
										SetPVarInt(ii, "_BoxingFight", i + 1);
										SetPVarInt(i, "_BoxingFightCountdown", 4);

										new szString[128];
										format(szString, sizeof(szString), "You are now in a boxing match with %s.", GetPlayerNameEx(ii));
										SendClientMessageEx(i, COLOR_WHITE, szString);
										format(szString, sizeof(szString), "You are now in a boxing match with %s.", GetPlayerNameEx(i));
										SendClientMessageEx(ii, COLOR_WHITE, szString);
										break;
									}
									else // NO ARENA AVAILABLE
									{
									}
								}
							}
						}	
					}
				}
			}
			else if (GetPVarInt(i, "_BoxingFightCountdown") >= 1)
			{
				new countdown = GetPVarInt(i, "_BoxingFightCountdown");
				new ii = GetPVarInt(i, "_BoxingFight") - 1;

				if (countdown == 4)
				{
					SendClientMessageEx(i, COLOR_RED, "3..");
					SendClientMessageEx(ii, COLOR_RED, "3..");
					SetPVarInt(i, "_BoxingFightCountdown", 3);
				}
				else if (countdown == 3)
				{
					SendClientMessageEx(i, COLOR_RED, "2..");
					SendClientMessageEx(ii, COLOR_RED, "2..");
					SetPVarInt(i, "_BoxingFightCountdown", 2);
				}
				else if (countdown == 2)
				{
					SendClientMessageEx(i, COLOR_RED, "1..");
					SendClientMessageEx(ii, COLOR_RED, "1..");
					SetPVarInt(i, "_BoxingFightCountdown", 1);
				}
				else if (countdown == 1)
				{
					SendClientMessageEx(i, COLOR_RED, "Fight!");
					SendClientMessageEx(ii, COLOR_RED, "Fight!");
					DeletePVar(i, "_BoxingFightCountdown");
					TogglePlayerControllable(i, 1);
					TogglePlayerControllable(ii, 1);
				}
			}
			if (GetPVarInt(i, "_BoxingFightOver") != 0 && gettime() >= GetPVarInt(i, "_BoxingFightOver"))
			{
				if (GetPVarInt(i, "Injured") == 1)
				{
					KillEMSQueue(i);
					ClearAnimations(i);
					new biz = InBusiness(i);

					if (Businesses[biz][bGymBoxingArena1][0] == i || Businesses[biz][bGymBoxingArena1][1] == i) // first arena
					{
						Businesses[biz][bGymBoxingArena1][0] = INVALID_PLAYER_ID;
						Businesses[biz][bGymBoxingArena1][1] = INVALID_PLAYER_ID;
					}
					else if (Businesses[biz][bGymBoxingArena2][0] == i || Businesses[biz][bGymBoxingArena2][1] == i) // second arena
					{
						Businesses[biz][bGymBoxingArena2][0] = INVALID_PLAYER_ID;
						Businesses[biz][bGymBoxingArena2][1] = INVALID_PLAYER_ID;
					}
				}

				SetPlayerHealth(i, GetPVarFloat(i, "_BoxingCacheHP"));
				SetPlayerArmor(i, GetPVarFloat(i, "_BoxingCacheArmour"));
				DeletePVar(i, "_BoxingCacheHP");
				DeletePVar(i, "_BoxingCacheArmour");
				DeletePVar(i, "_BoxingFightOver");
				SetPlayerWeapons(i);
				SetPlayerPos(i, 2914.0706, -2263.0193, 7.2367);
			}
		}	
	}

	UpdateCarRadars();

/*	if (CharmReloadTimer == 0 && ++CharmMainTimer == 1800)
	{
		RemoveCharmPoint();
	}

	if (CharmMainTimer >= 1800)
	{
		if (++CharmReloadTimer == 5400)
		{
			SelectCharmPoint();
			CharmReloadTimer = 0;
			CharmMainTimer = 0;
		}
	} */
}

// Timer Name: ServerHeartbeatTwo()
// TickRate: 1 secs.
task ServerHeartbeatTwo[1000]() {

	//foreach(new i: Player)
	for(new i = 0; i < MAX_PLAYERS; ++i)
	{
		if(IsPlayerConnected(i))
		{
			if(IsPlayerInAnyVehicle(i)) {
				if(GetPlayerState(i) == PLAYER_STATE_DRIVER) SetPlayerArmedWeapon(i, 0);
				else if(PlayerInfo[i][pGuns][4] == 0) SetPlayerArmedWeapon(i, 0);
				else SetPlayerArmedWeapon(i, 29);
			}
			new Float:armor;
			GetPlayerArmour(i, armor);
			if((armor > CurrentArmor[i]) && PlayerInfo[i][pAdmin] < 2)
			{
				if(GetPVarType(i, "ArmorCheckAgain"))
				{
					if(gettime()-GetPVarInt(i, "ArmorCheckAgain") > 10)
					{
						if(gettime()-GetPVarInt(i, "ArmorWarningTime") > 300)
						{
							SetPVarInt(i, "ArmorWarningTime", gettime());
							SetPVarInt(i, "ArmorWarning", 1);
							DeletePVar(i, "ArmorCheckAgain");
							new string[128];
							format( string, sizeof( string ), "{AA3333}AdmWarning{FFFF00}: %s (ID %d) may possibly be armor hacking. (Recorded: %f - Current: %f) (1)", GetPlayerNameEx(i), i, CurrentArmor[i], armor);
							ABroadCast( COLOR_YELLOW, string, 2 );
							format(string, sizeof(string), "%s (ID %d) may possibly be armor hacking. (Recorded: %f - Current: %f) (1)", GetPlayerNameEx(i), i, CurrentArmor[i], armor);
							Log("logs/hack.log", string);
						}
					}
				}
				else
				{
					SetPVarInt(i, "ArmorCheckAgain", gettime());
				}
			}
			if(GetPlayerSpecialAction(i) == SPECIAL_ACTION_USEJETPACK && JetPack[i] == 0 && PlayerInfo[i][pAdmin] < 4)
			{
				new string[74 + MAX_PLAYER_NAME];
				format( string, sizeof( string ), "{AA3333}AdmWarning{FFFF00}: %s (ID %d) may possibly be jetpack hacking.", GetPlayerNameEx(i), i);
				ABroadCast( COLOR_YELLOW, string, 2 );
				format(string, sizeof(string), "%s (ID %d) may possibly be jetpack hacking.", GetPlayerNameEx(i), i);
				Log("logs/hack.log", string);
			}

			if( IsPlayerInRangeOfPoint( i, 2, 1544.2, -1353.4, 329.4 ) )
			{
				GivePlayerValidWeapon( i, 46, 9 );
			}
			if(GetPlayerState(i) == PLAYER_STATE_ONFOOT) for(new h = 0; h < sizeof(FamilyInfo); h++)
			{
				if(IsPlayerInRangeOfPoint(i, 2.0, FamilyInfo[h][FamilySafe][0], FamilyInfo[h][FamilySafe][1], FamilyInfo[h][FamilySafe][2]) && GetPlayerVirtualWorld(i) == FamilyInfo[h][FamilySafeVW] && GetPlayerInterior(i) == FamilyInfo[h][FamilySafeInt])
				{
					if(FamilyInfo[h][FamilyUSafe] == 1)
					{
						GameTextForPlayer(i, "~y~gang safe~w~~n~Type ~r~/safehelp~w~ for more information", 5000, 3);
					}
				}
			}

			for(new h = 0; h < sizeof(Points); h++)
			{
				if(IsPlayerInRangeOfPoint(i, 2.0, Points[h][Pointx], Points[h][Pointy], Points[h][Pointz]))
				{
					if(Points[h][Type] == 1 && !GetPVarType(i, "Packages"))
					{
						GameTextForPlayer(i, "~w~Type /getmats to purchase a ~n~~r~materials package", 5000, 5);
					}
					else if(Points[h][Type] == 3 && PlayerInfo[i][pPot] < 3)
					{
						GameTextForPlayer(i, "~w~/getseeds~n~~b~/getopiumseeds", 5000, 5);
					}
					else if(Points[h][Type] == 4)
					{
						GameTextForPlayer(i, "~w~Type /getcrack to purchase some ~r~crack", 5000, 5);
					}
					else if(Points[h][Type] == 5)
					{
						GameTextForPlayer(i, "~w~Type /getcrate to purchase a ~r~crate", 5000, 5);
					}
				}
			}

			if(CellTime[i] > 0 && 0 <= Mobile[i] < sizeof Mobile)
			{
				if (CellTime[i] == 60)
				{
					CellTime[i] = 1;
					if(Mobile[Mobile[i]] == i)
					{
						CallCost[i] += 10;
					}
				}
				CellTime[i]++;
				if (Mobile[Mobile[i]] == INVALID_PLAYER_ID && CellTime[i] == 5)
				{
					if(IsPlayerConnected(Mobile[i]))
					{
						new Float:rX, Float:rY, Float:rZ;
						GetPlayerPos(i, rX, rY, rZ);
						new string[18 + MAX_PLAYER_NAME];
						format(string, sizeof(string), "* %s's phone rings.", GetPlayerNameEx(Mobile[i]));
						RingTone[Mobile[i]] = 10;
						ProxDetector(30.0, Mobile[i], string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
					}
				}
			}

			if(CellTime[i] == 0 && CallCost[i] > 0)
			{
				new string[28];
				format(string, sizeof(string), "~w~The call cost~n~~r~$%d",CallCost[i]);
				GivePlayerCash(i, -CallCost[i]);
				GameTextForPlayer(i, string, 5000, 1);
				CallCost[i] = 0;
			}

			if(TransportDriver[i] != INVALID_PLAYER_ID)
			{
				if(GetPlayerVehicleID(i) != GetPlayerVehicleID(TransportDriver[i]) || !TransportDuty[TransportDriver[i]])
				{
					if(IsPlayerConnected(TransportDriver[i]))
					{
						TransportMoney[TransportDriver[i]] += TransportCost[i];
						TransportTime[TransportDriver[i]] = 0;
						TransportCost[TransportDriver[i]] = 0;
						new string[36];
						format(string, sizeof(string), "~w~Passenger left~n~~g~Earned $%d",TransportCost[i]);
						GameTextForPlayer(TransportDriver[i], string, 5000, 1);
						TransportDriver[i] = INVALID_PLAYER_ID;
					}
				}
				else if(TransportTime[i] >= 16)
				{
					TransportTime[i] = 1;
					if(TransportDriver[i] != INVALID_PLAYER_ID)
					{
						if(IsPlayerConnected(TransportDriver[i]))
						{
							TransportCost[i] += TransportValue[TransportDriver[i]];
							TransportCost[TransportDriver[i]] = TransportCost[i];
						}
					}
				}
				TransportTime[i] += 1;
				new string[24];
				format(string, sizeof(string), "~r~%d ~w~: ~g~$%d",TransportTime[i],TransportCost[i]);
				GameTextForPlayer(i, string, 15000, 6);
				if(TransportCost[i] > GetPlayerCash(i))
				{
					RemovePlayerFromVehicle(i);
					new Float:slx, Float:sly, Float:slz;
					GetPlayerPos(i, slx, sly, slz);
					SetPlayerPos(i, slx, sly, slz + 2);
					GameTextForPlayer(i, "~r~You're flat out of cash!", 4000, 4);
				}
			}

			if(GetVehicleModel(GetPlayerVehicleID(i)) != 594 && GetPVarType(i, "rccam")) {
				DestroyVehicle(GetPVarInt(i, "rcveh"));
				KillTimer(GetPVarInt(i, "rccamtimer"));
			}
		}
	}
}

// Timer Name: ServerMicrobeat()
// TickRate: 500ms
task ServerMicrobeat[500]() {

    static
		Float: fExpHealth,
		Float: fCurrentSpeed,
		Float: fVehicleHealth,
		iVehicle,
		//szSpeed[42],
		arrVehParams[7];

	//foreach(new i: Player)
	for(new i = 0; i < MAX_PLAYERS; ++i)
	{
		if(IsPlayerConnected(i))
		{
			if (_vhudVisible[i] == 1 && !IsPlayerInAnyVehicle(i))
			{
				HideVehicleHUDForPlayer(i);
			}

			switch(GetPlayerState(i)) {
				case PLAYER_STATE_DRIVER: {
					iVehicle = GetPlayerVehicleID(i);
					GetVehicleHealth(iVehicle, fVehicleHealth);
					fCurrentSpeed = player_get_speed(i);

					if(arr_Towing[i] != INVALID_VEHICLE_ID) {
						if(GetVehicleModel(arr_Towing[i]) && IsVehicleStreamedIn(arr_Towing[i], i)) AttachTrailerToVehicle(arr_Towing[i], iVehicle);
						else arr_Towing[i] = INVALID_VEHICLE_ID;
					}

					if(fCurrentSpeed >= 40 && 60 <= fCurrentSpeed)
					{
						if(PlayerInfo[i][pAdmin] <= 1) switch(Seatbelt[i]) {
							case 0: if((fVehSpeed[i] - fCurrentSpeed > 40.0) && (fVehHealth[i] - fExpHealth > 0)) GetPlayerHealth(i, fExpHealth), SetPlayerHealth(i, fExpHealth - (fVehSpeed[i] - fCurrentSpeed) / 1.6);
							default: if((fVehSpeed[i] - fCurrentSpeed > 40.0) && (fVehHealth[i] - fExpHealth > 0)) GetPlayerHealth(i, fExpHealth), SetPlayerHealth(i, fExpHealth - ((fVehSpeed[i] - fCurrentSpeed) / 3.2));
						}
					}
					else
					{
						if(PlayerInfo[i][pAdmin] <= 1) switch(Seatbelt[i]) {
							case 0: if((fVehSpeed[i] - fCurrentSpeed > 50.0) && (fVehHealth[i] - fExpHealth > 0)) GetPlayerHealth(i, fExpHealth), SetPlayerHealth(i, fExpHealth - (fVehSpeed[i] - fCurrentSpeed) / 0.8);
							default: if((fVehSpeed[i] - fCurrentSpeed > 50.0) && (fVehHealth[i] - fExpHealth > 0)) GetPlayerHealth(i, fExpHealth), SetPlayerHealth(i, fExpHealth - ((fVehSpeed[i] - fCurrentSpeed) / 1.6));
						}
					}

					fVehSpeed[i] = fCurrentSpeed;
					fVehHealth[i] = fVehicleHealth;

					if(fVehicleHealth < 350.0)
					{
						SetVehicleHealth(iVehicle, 251.0);
						GetVehicleParamsEx(iVehicle, arrVehParams[0], arrVehParams[1], arrVehParams[2], arrVehParams[3], arrVehParams[4], arrVehParams[5], arrVehParams[6]);
						if(arrVehParams[0] == VEHICLE_PARAMS_ON) SetVehicleParamsEx(iVehicle,VEHICLE_PARAMS_OFF, arrVehParams[1], arrVehParams[2], arrVehParams[3], arrVehParams[4], arrVehParams[5], arrVehParams[6]);
						GameTextForPlayer(i, "~r~Totalled!", 2500, 3);
						arr_Engine{iVehicle} = 0;
					}
					else if(PlayerInfo[i][pSpeedo] != 0 && FindTimePoints[i] == 0 && arr_Engine{iVehicle} == 1 && !GetPVarType(i, "LoadTruckTime")) {
						UpdateVehicleHUDForPlayer(i, floatround(VehicleFuel[iVehicle]), floatround(fCurrentSpeed));
					}
				}
				case PLAYER_STATE_PASSENGER: {

					iVehicle = GetPlayerVehicleID(i);
					GetVehicleHealth(iVehicle,fExpHealth);
					fCurrentSpeed = player_get_speed(i);
					if(PlayerInfo[i][pSpeedo] != 0) {
						UpdateVehicleHUDForPlayer(i, floatround(VehicleFuel[iVehicle]), floatround(fCurrentSpeed));
					}
					if(fCurrentSpeed >= 40 && 60 <= fCurrentSpeed)
					{
						if(PlayerInfo[i][pAdmin] <= 1) switch(Seatbelt[i]) {
							case 0: if((fVehSpeed[i] - fCurrentSpeed > 40.0) && (fVehHealth[i] - fExpHealth > 0)) GetPlayerHealth(i, fExpHealth), SetPlayerHealth(i, fExpHealth - (fVehSpeed[i] - fCurrentSpeed) / 1.6);
							default: if((fVehSpeed[i] - fCurrentSpeed > 40.0) && (fVehHealth[i] - fExpHealth > 0)) GetPlayerHealth(i, fExpHealth), SetPlayerHealth(i, fExpHealth - ((fVehSpeed[i] - fCurrentSpeed) / 3.2));
						}
					}
					else
					{
						if(PlayerInfo[i][pAdmin] <= 1) switch(Seatbelt[i]) {
							case 0: if((fVehSpeed[i] - fCurrentSpeed > 50.0) && (fVehHealth[i] - fExpHealth > 0)) GetPlayerHealth(i, fExpHealth), SetPlayerHealth(i, fExpHealth - (fVehSpeed[i] - fCurrentSpeed) / 0.8);
							default: if((fVehSpeed[i] - fCurrentSpeed > 50.0) && (fVehHealth[i] - fExpHealth > 0)) GetPlayerHealth(i, fExpHealth), SetPlayerHealth(i, fExpHealth - ((fVehSpeed[i] - fCurrentSpeed) / 1.6));
						}
					}

					fVehSpeed[i] = fCurrentSpeed;
					fVehHealth[i] = fExpHealth;
				}
			}
		}	
	}
}

// Timer Name: VehicleUpdate()
// TickRate: 60 secs.
task VehicleUpdate[60000]() {

    static engine,lights,alarm,doors,bonnet,boot,objective;
    for(new v = 0; v < MAX_VEHICLES; v++) if(GetVehicleModel(v) && GetVehicleModel(v) != 481 && GetVehicleModel(v) != 509 && GetVehicleModel(v) != 510) {
	    GetVehicleParamsEx(v,engine,lights,alarm,doors,bonnet,boot,objective);
	    if(engine == VEHICLE_PARAMS_ON) {
			if(arr_Engine{v} == 0) SetVehicleParamsEx(v,VEHICLE_PARAMS_OFF,lights,alarm,doors,bonnet,boot,objective);
			else if(!IsVIPcar(v) && !IsFamedVeh(v) && !IsATruckerCar(v) && VehicleFuel[v] > 0.0) {
				VehicleFuel[v] -= 1.0;
				if(VehicleFuel[v] <= 0.0) SetVehicleParamsEx(v,VEHICLE_PARAMS_OFF,lights,alarm,doors,bonnet,boot,objective);
			}
	    }
	}
}

// Task Name: hungerGames()
task hungerGames[1000]()
{	
	new string[128];
	if(hgActive)
	{
		if(hgCountdown > 0)
		{	
			hgCountdown--;
			
			format(string, sizeof(string), "Time left until start: %d", hgCountdown);
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if(HungerPlayerInfo[i][hgInEvent] == 1)
				{
					PlayerTextDrawSetString(i, HungerPlayerInfo[i][hgTimeLeftText], string);
				}
			}
			
			if(hgCountdown == 300)
			{
				SendClientMessageToAll(COLOR_LIGHTBLUE, "The Hunger Games Event will start in 5 minutes, type /joinhunger to participate.");
			}
			else if(hgCountdown == 60) 
			{
				SendClientMessageToAll(COLOR_LIGHTBLUE, "The Hunger Games Event will start in 1 minute, type /joinhunger to participate.");			
			}
			else if(hgCountdown == 30)
			{
				for(new i = 0; i < MAX_PLAYERS; i++)
				{
					if(HungerPlayerInfo[i][hgInEvent] == 1)
					{
						SendClientMessageEx(i, COLOR_LIGHTBLUE, "* The event will be starting in 30 seconds...");
						SendClientMessageEx(i, COLOR_LIGHTBLUE, "* Godmode will be disabled and backpacks will be spawned in 30 seconds.");
					}
				}
			}
		}
		else if(hgCountdown == 0 && hgActive == 1)
		{
			LoadHGBackpacks();
			hgActive = 2;
			
			format(string, sizeof(string), "Time left until start: %d", hgCountdown);
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if(HungerPlayerInfo[i][hgInEvent] == 1)
				{
					PlayerTextDrawSetString(i, HungerPlayerInfo[i][hgTimeLeftText], string);
					
					if(GetPVarInt(i, "HungerVoucher") == 1)
					{
						GivePlayerWeapon(i, 29, 60000);
						SetPlayerHealth(i, 100.0);
						DeletePVar(i, "HungerVoucher");
					}
					else
					{
						SetPlayerHealth(i, 50.0);
					}
	
					SendClientMessageEx(i, COLOR_LIGHTBLUE, "* Let the Hunger Games Begin!");
					GameTextForPlayer(i, "The Game is on!", 2000, 6);
					PlayerTextDrawHide(i, HungerPlayerInfo[i][hgTimeLeftText]);
					PlayerTextDrawHide(i, HungerPlayerInfo[i][hgLoadingText]);
				}
			}
		}
	}
	return true;
}

// Task Name: fpsCounterUpdate
task fpsCounterUpdate[500]()
{
	new string[64];
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(GetPVarInt(i, "FPSToggle") == 1)
		{
			format(string, sizeof(string), "%d", pFPS[i]);
			PlayerTextDrawSetString(i, pFPSCounter[i], string);
		}
	}
	return true;
}

// Timer Name: ShopItemQueue()
// TickRate: 30 Seconds
task ShopItemQueue[30000]()
{
	new string[128];
	//foreach(new i: Player)
	for(new i = 0; i < MAX_PLAYERS; ++i)
	{
		if(IsPlayerConnected(i))
		{
			format(string, sizeof(string), "SELECT * FROM `shop_orders` WHERE `user_id` = %d AND `status` = 0", GetPlayerSQLId(i));
			mysql_function_query(MainPipeline, string, true, "ExecuteShopQueue", "ii", i, 0);
			if(ShopToggle == 1)
			{
				format(string, sizeof(string), "SELECT * FROM `order_delivery_status` WHERE `player_id` = %d AND `status` = 0", GetPlayerSQLId(i));
				mysql_function_query(ShopPipeline, string, true, "ExecuteShopQueue", "ii", i, 1);
			}
		}
	}
}