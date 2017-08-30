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


 // Timer Name: SkinDelay(playerid)
timer SkinDelay[1000](playerid)
{
	SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);

	// Attach Storage Objects
	if(PlayerInfo[playerid][pBackpack] > 0 && PlayerInfo[playerid][pBEquipped])
	{
		switch(PlayerInfo[playerid][pBackpack])
		{
			case 1: // Small
			{
				if(PlayerHoldingObject[playerid][9] != 0 || IsPlayerAttachedObjectSlotUsed(playerid, 9))
					RemovePlayerAttachedObject(playerid, 9), PlayerHoldingObject[playerid][9] = 0;
				SetPlayerAttachedObject(playerid, 9, 371, 1, -0.002, -0.140999, -0.01, 8.69999, 88.8, -8.79993, 1.11, 0.963);
				//PlayerInfo[playerid][pBEquipped] = 1;
			}
			case 2: // Med
			{
				if(PlayerHoldingObject[playerid][9] != 0 || IsPlayerAttachedObjectSlotUsed(playerid, 9))
					RemovePlayerAttachedObject(playerid, 9), PlayerHoldingObject[playerid][9] = 0;
				SetPlayerAttachedObject(playerid, 9, 371, 1, -0.002, -0.140999, -0.01, 8.69999, 88.8, -8.79993, 1.11, 0.963);
				//PlayerInfo[playerid][pBEquipped] = 1;
			}
			case 3: // Large
			{
				if(PlayerHoldingObject[playerid][9] != 0 || IsPlayerAttachedObjectSlotUsed(playerid, 9))
					RemovePlayerAttachedObject(playerid, 9), PlayerHoldingObject[playerid][9] = 0;
				SetPlayerAttachedObject(playerid, 9, 3026, 1, -0.254999, -0.109, -0.022999, 10.6, -1.20002, 3.4, 1.265, 1.242, 1.062);
				//PlayerInfo[playerid][pBEquipped] = 1;
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
 		if(DynVehicleInfo[DynVeh[newcar]][gv_igID] != 0 && (PlayerInfo[playerid][pMember] != DynVehicleInfo[DynVeh[newcar]][gv_igID] || PlayerInfo[playerid][pLeader] != DynVehicleInfo[DynVeh[newcar]][gv_igID])|| DynVehicleInfo[DynVeh[newcar]][gv_irID] != 0 && PlayerInfo[playerid][pRank] < DynVehicleInfo[DynVeh[newcar]][gv_irID])
		{
  			ExecuteNOPAction(playerid);
		}
	}
	return 1;
}


timer FinishMedKit[5000](playerid)
{
	if(GetPVarInt(playerid, "BackpackMedKit") == 1)
	{
		SetHealth(playerid, 100);
		SetArmour(playerid, 150);
		PlayerInfo[playerid][pBItems][5]--;
		SendClientMessageEx(playerid, COLOR_WHITE, "You have used the Med Kit from the backpack.");
		new ip[MAX_PLAYER_NAME];
		GetPlayerIp(playerid, ip, sizeof(ip));
		format(szMiscArray, sizeof(szMiscArray), "[MEDKIT] %s(%d) (IP:%s) used a medkit (%d Kits Total) [BACKPACK %d]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ip, PlayerInfo[playerid][pBItems][5], PlayerInfo[playerid][pBackpack]);
		Log("logs/backpack.log", szMiscArray);
		DeletePVar(playerid, "BackpackOpen"), DeletePVar(playerid, "BackpackProt");
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_RED, "You have taken damage or tried entering a car during the 5 seconds, therefore you couldn't use the Med Kit.");
		SetPVarInt(playerid, "BackpackDisabled", 60);
	}
	DeletePVar(playerid, "BackpackMedKit");
	return 1;
}

timer FinishMeal[5000](playerid)
{
	if(GetPVarInt(playerid, "BackpackMeal") == 1)
	{
		PlayerInfo[playerid][pBItems][0]--;
		format(szMiscArray, sizeof(szMiscArray),"* You have used a Full Meal from your backpack(%d remaining meals).",PlayerInfo[playerid][pBItems][0]);
		SendClientMessage(playerid, COLOR_GRAD2, szMiscArray);
		SetHealth(playerid, 100.0);

		new ip[MAX_PLAYER_NAME];
		GetPlayerIp(playerid, ip, sizeof(ip));
		format(szMiscArray, sizeof(szMiscArray), "[MEDKIT] %s(%d) (IP:%s) used a meal (%d Meals Total) [BACKPACK %d]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ip, PlayerInfo[playerid][pBItems][0], PlayerInfo[playerid][pBackpack]);
		Log("logs/backpack.log", szMiscArray);
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_RED, "You have taken damage or tried entering a car during the 5 seconds, therefore you couldn't use the Full Meal.");
		SetPVarInt(playerid, "BackpackDisabled", 120);
	}
	ShowBackpackMenu(playerid, DIALOG_OBACKPACK, "");
	DeletePVar(playerid, "BackpackMeal");
	return 1;
}

timer CheckVehiclesLeftSpawned[5000](playerid)
{
	foreach(new j: Player)
	{
		if(!GetPVarType(j, "LockPickVehicleSQLId")) return 1;
		if(GetPVarInt(j, "LockPickPlayerSQLId") == GetPlayerSQLId(playerid)) {
			new v = FindPlayerVehicleWithSQLId(playerid, GetPVarInt(j, "LockPickVehicleSQLId"));
			if(v != -1) {
				new szMessage[185];
				if(GetPVarType(j, "AttemptingLockPick")) PlayerVehicleInfo[playerid][v][pvBeingPickLocked] = 1;
				else if(GetPVarType(j, "DeliveringVehicleTime")) PlayerVehicleInfo[playerid][v][pvBeingPickLocked] = 2;
				SetPVarInt(j, "LockPickPlayer", playerid);
				PlayerVehicleInfo[playerid][v][pvBeingPickLockedBy] = j;
				++PlayerCars;
				VehicleSpawned[playerid]++;
				PlayerVehicleInfo[playerid][v][pvId] = GetPVarInt(j, "LockPickVehicle");
				PlayerVehicleInfo[playerid][v][pvSpawned] = 1;
				PlayerVehicleInfo[playerid][v][pvFuel] = VehicleFuel[GetPVarInt(j, "LockPickVehicle")];
				g_mysql_SaveVehicle(playerid, v);
				SendClientMessageEx(j, COLOR_GREY, "(( The player that owns this vehicle has logged back in! ))");
				new ip[MAX_PLAYER_NAME], ip2[MAX_PLAYER_NAME];
				GetPlayerIp(playerid, ip, sizeof(ip));
				GetPlayerIp(j, ip2, sizeof(ip2));
				format(szMessage, sizeof(szMessage), "[LOCK PICK] %s (IP:%s SQLId: %d) has logged back in while his %s(VID:%d Slot %d) was lock picked by %s(IP:%s SQLId:%d)", GetPlayerNameEx(playerid), ip, GetPlayerSQLId(playerid), GetVehicleName(PlayerVehicleInfo[playerid][v][pvId]), PlayerVehicleInfo[playerid][v][pvId], v, GetPlayerNameEx(j), ip2, GetPlayerSQLId(j));
				Log("logs/playervehicle.log", szMessage);
				DeletePVar(j, "LockPickVehicleSQLId");
				DeletePVar(j, "LockPickPlayerSQLId");
				DeletePVar(j, "LockPickPlayerName");
			}
			else SendClientMessageEx(j, COLOR_GREY, "Error on function FindPlayerVehicleWithSQLId");
		}
	}
	return 1;
}


/* Tasks - Optimized (Jingles) */

// Timer Name: ServerHeartbeat()
// TickRate: 1 secs.
task ServerHeartbeat[1000]() {

	arrGroupData[0][g_iDeptRadioAccess] = 0; // Temporary fix for LSPD's dept radio access.

    if(++AdminWarning == 15) {
		for(new z = 0; z < MAX_REPORTS; z++)
		{
			if(Reports[z][BeingUsed] == 1)
			{
				if(Reports[z][ReportPriority] == 1 || Reports[z][ReportPriority] == 2)
				{
					ABroadCast(COLOR_LIGHTRED,"A priority report is pending.", 2);
					break;
				}
			}
		}
		AdminWarning = 0;
	}
    UpdateCarRadars();
	//CharmTimer();
}

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
	            TurfWars[i][twVulnerable] = 12;
				ResetTurfWarsZone(1, i);
	        }
	    }
	    // SaveTurfWar(i);
	}
}

// Task Name: SyncTime()
// TickRate: 60 Secs
task SyncTime[60000]()
{
	PlantTimer();

	new reports, priority;
	for(new i=0;i<MAX_REPORTS;i++) { if(Reports[i][BeingUsed] == 1) reports++; if(Reports[i][ReportPriority] <= 2 && Reports[i][BeingUsed] == 1) priority++; }
	if(reports >= 5)
	{
		format(szMiscArray, 80, "There are currently %d reports pending. (%d priority)", reports, priority);
	 	ABroadCast(COLOR_LIGHTRED, szMiscArray, 2);
	}
	
	for(new i = 0; i < MAX_ITEMS; i++) // Moved from 1000 to 60000 check - Jingles
	{
	    if(Price[i] != ShopItems[i][sItemPrice])
	    {
	        format(szMiscArray, 128, "Item: %d - Price: %d - Reset: %d", i, ShopItems[i][sItemPrice], Price[i]);
	        Log("error.log", szMiscArray);
	        ShopItems[i][sItemPrice] = Price[i];
	    }
	}

	if(zombieevent) {

		foreach(new i: Player)  {
			SaveZombieStats(i);
		}
	}
	new tmphour, tmpminute, tmpsecond;
	gettime(tmphour, tmpminute, tmpsecond);
	FixHour(tmphour);
	tmphour = shifthour;

	if ((tmphour > ghour) || (tmphour == 0 && ghour == 23))
	{
		if(tmphour == 0 && ghour == 23)
		{
			//CallLocalFunction("InactiveResourceCheck", "");

			/*
			new month, day, year;
			getdate(year,month,day);
			if(month == 4 && (day == 25 || day == 26)) // NGG B-Day 2015
			{
				foreach(Player, i)
				{
					PlayerInfo[i][pReceivedPrize] = 0;
				}
				mysql_tquery(MainPipeline, "UPDATE `accounts` SET `ReceivedPrize` = 0", false, "OnQueryFinish", "i", SENDDATA_THREAD);
			}*/
		}
	    if(tmphour == 3 || tmphour == 6 || tmphour == 9 || tmphour == 12 || tmphour == 15 || tmphour == 18 || tmphour == 21 || tmphour == 0) PrepareLotto();
		else
		{
		    if(SpecLotto) {
		        format(szMiscArray, sizeof(szMiscArray), "Special Lottery: Remember to buy a lotto ticket at a 24/7. Next drawing is at %s. The total Jackpot is $%s", ConvertToTwelveHour(tmphour), number_format(Jackpot));
				SendClientMessageToAllEx(COLOR_WHITE, szMiscArray);
		        format(szMiscArray, sizeof(szMiscArray), "Special Prize: %s", LottoPrize);
				SendClientMessageToAllEx(COLOR_WHITE, szMiscArray);
		    }
		    else {
		    	format(szMiscArray, sizeof(szMiscArray), "Lottery: Remember to buy a lotto ticket at a 24/7. Next drawing is at %s. The total Jackpot is $%s", ConvertToTwelveHour(tmphour), number_format(Jackpot));
				SendClientMessageToAllEx(COLOR_WHITE, szMiscArray);
			}
		}
		for(new iGroupID; iGroupID < MAX_GROUPS; iGroupID++)
		{
			MemberCount(iGroupID);
			if(arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_GOV && arrGroupData[iGroupID][g_iAllegiance] == 1)
			{
				format(szMiscArray, sizeof(szMiscArray), "The tax vault is at $%s", number_format(Tax));
				GroupPayLog(iGroupID, szMiscArray);
			}
			else if(arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_GOV && arrGroupData[iGroupID][g_iAllegiance] == 2)
			{
				format(szMiscArray, sizeof(szMiscArray), "The tax vault is at $%s", number_format(TRTax));
				GroupPayLog(iGroupID, szMiscArray);
			}
			else
			{
				format(szMiscArray, sizeof(szMiscArray), "The faction vault is at $%s.", number_format(arrGroupData[iGroupID][g_iBudget]));
				GroupPayLog(iGroupID, szMiscArray);
			}
			if(arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_LEA || arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_MEDIC || arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_JUDICIAL || arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_TAXI || arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_TOWING)
			{
				if(arrGroupData[iGroupID][g_iBudgetPayment] > 0)
				{
					if(Tax > arrGroupData[iGroupID][g_iBudgetPayment] && arrGroupData[iGroupID][g_iAllegiance] == 1)
					{
						Tax -= arrGroupData[iGroupID][g_iBudgetPayment];
						arrGroupData[iGroupID][g_iBudget] += arrGroupData[iGroupID][g_iBudgetPayment];
						format(szMiscArray, sizeof(szMiscArray), "SA Gov Paid $%s to %s budget fund.", number_format(arrGroupData[iGroupID][g_iBudgetPayment]), arrGroupData[iGroupID][g_szGroupName]);
						GroupPayLog(iGroupID, szMiscArray);
						Misc_Save();
						SaveGroup(iGroupID);
						for(new z; z < MAX_GROUPS; z++)
						{
							if(arrGroupData[z][g_iAllegiance] == 1)
							{
								if(arrGroupData[z][g_iGroupType] == GROUP_TYPE_GOV)
								{
									format(szMiscArray, sizeof(szMiscArray), "SA Gov Paid $%s to %s budget fund.", number_format(arrGroupData[iGroupID][g_iBudgetPayment]), arrGroupData[iGroupID][g_szGroupName]);
									GroupPayLog(z, szMiscArray);
									break;
								}
							}
						}
					}
					else if(TRTax > arrGroupData[iGroupID][g_iBudgetPayment] && arrGroupData[iGroupID][g_iAllegiance] == 2)
					{
						TRTax -= arrGroupData[iGroupID][g_iBudgetPayment];
						arrGroupData[iGroupID][g_iBudget] += arrGroupData[iGroupID][g_iBudgetPayment];
						format(szMiscArray, sizeof(szMiscArray), "NE Gov Paid $%s to %s budget fund.", number_format(arrGroupData[iGroupID][g_iBudgetPayment]), arrGroupData[iGroupID][g_szGroupName]);
						GroupPayLog(iGroupID, szMiscArray);
						Misc_Save();
						SaveGroup(iGroupID);
						for(new z; z < MAX_GROUPS; z++)
						{
							if(arrGroupData[z][g_iAllegiance] == 2)
							{
								if(arrGroupData[z][g_iGroupType] == GROUP_TYPE_GOV)
								{
									format(szMiscArray, sizeof(szMiscArray), "NE Gov Paid $%s to %s budget fund.", number_format(arrGroupData[iGroupID][g_iBudgetPayment]), arrGroupData[iGroupID][g_szGroupName]);
									GroupPayLog(z, szMiscArray);
									break;
								}
							}
						}
					}
					else
					{
						format(szMiscArray, sizeof(szMiscArray), "Warning: The Government Vault has insufficient funds to fund %s.", arrGroupData[iGroupID][g_szGroupName]);
						SendGroupMessage(GROUP_TYPE_GOV, COLOR_RED, szMiscArray);
					}
				}
				for(new iDvSlotID = 0; iDvSlotID < MAX_DYNAMIC_VEHICLES; iDvSlotID++)
				{
					if(DynVehicleInfo[iDvSlotID][gv_igID] != INVALID_GROUP_ID && DynVehicleInfo[iDvSlotID][gv_igID] == iGroupID)
					{
						if(DynVehicleInfo[iDvSlotID][gv_iModel] != 0 && (400 < DynVehicleInfo[iDvSlotID][gv_iModel] < 612))
						{
							if(arrGroupData[iGroupID][g_iBudget] >= DynVehicleInfo[iDvSlotID][gv_iUpkeep])
							{
								arrGroupData[iGroupID][g_iBudget] -= DynVehicleInfo[iDvSlotID][gv_iUpkeep];
								format(szMiscArray, sizeof(szMiscArray), "Vehicle ID %d (Slot ID %d) Maintainence fee cost $%s to %s's budget fund.",DynVehicleInfo[iDvSlotID][gv_iSpawnedID], iDvSlotID, number_format(DynVehicleInfo[iDvSlotID][gv_iUpkeep]), arrGroupData[iGroupID][g_szGroupName]);
								GroupPayLog(iGroupID, szMiscArray);
							}
							else
							{
								DynVehicleInfo[iDvSlotID][gv_iDisabled] = 1;
								DynVeh_Save(iDvSlotID);
								DynVeh_Spawn(iDvSlotID);
							}
						}
					}
				}
				SaveGroup(iGroupID);
				for(new cratebox = 0; cratebox < MAX_CRATES; cratebox++) {
					if(CrateBox[cratebox][cbActive]) {
						SaveCrate(cratebox);
					}
				}
				for(new facility = 0; facility < MAX_CRATE_FACILITY; facility++) {
					if(CrateFacility[facility][cfActive]) {
						SyncFacility(facility);
					}
				}
			}
		}

		WeatherCalling += random(5) + 1;
		#if defined zombiemode
  		if(WeatherCalling > 20)
		{
  			WeatherCalling = 1;
	    	gWeather = random(19) + 1;
		    if(gWeather == 1 || gWeather == 8 || gWeather == 9) gWeather=1;
		}
		#else
		if(WeatherCalling > 20)
		{
 			WeatherCalling = 1;
   			gWeather = random(19) + 1;
   			gWeather = 1;
		    if(gWeather == 1 || gWeather == 8 || gWeather == 9) gWeather=1;

		}
		#endif

		ghour = tmphour;
		TotalUptime += 1;
		GiftAllowed = 1;

		new bmonth, bday, byear;
		new year, month, day;
		getdate(year, month, day);

		new ttTime = CalculateWorldGameTime(hour, minuite);

		format(szMiscArray, sizeof(szMiscArray), "The time is now %s. ((ST: %s))", ConvertToTwelveHour(ttTime), ConvertToTwelveHour(tmphour));
		SendClientMessageToAllEx(COLOR_WHITE, szMiscArray);
		new query[300];
		mysql_format(MainPipeline, query, sizeof(query), "SELECT b.shift, b.needs_%e, COUNT(DISTINCT s.id) as ShiftCount FROM cp_shift_blocks b LEFT JOIN cp_shifts s ON b.shift_id = s.shift_id AND s.date = '%d-%02d-%02d' AND s.status >= 2 AND s.type = 1 WHERE b.time_start = '%02d:00:00' AND b.type = 1 GROUP BY b.shift, b.needs_%e", GetWeekday(), year, month, day, tmphour, GetWeekday());
		mysql_tquery(MainPipeline, query, "GetShiftInfo", "is", INVALID_PLAYER_ID, szMiscArray);
		foreach(new i: Player)
		{
			if(PlayerInfo[i][pAdmin] >= 2)
			{
				if(tmphour == 0) ReportCount[i] = 0;
				ReportHourCount[i] = 0;
			}
			if(PlayerInfo[i][pWatchdog])
			{
				if(tmphour == 0) WDReportCount[i] = 0;
				WDReportHourCount[i] = 0;
			}
			if(PlayerInfo[i][pLevel] <= 5) SendClientMessageEx(i, COLOR_LIGHTBLUE, "Need to travel somewhere and don't have wheels? Use '/service taxi' to call a cab!");
			if(PlayerInfo[i][pDonateRank] >= 3)
			{
				sscanf(PlayerInfo[i][pBirthDate], "p<->iii", byear, bmonth, bday);
				if(month == bmonth && day == bday)
				{
					if(PlayerInfo[i][pLastBirthday] >= gettime()-86400 || gettime() >= PlayerInfo[i][pLastBirthday]+28512000)
					{
						SetPVarInt(i, "pBirthday", 1);
						PlayerInfo[i][pLastBirthday] = gettime();
						mysql_format(MainPipeline, query, sizeof(query), "UPDATE `accounts` SET `LastBirthday`=%d WHERE `Username` = '%e'", PlayerInfo[i][pLastBirthday], GetPlayerNameExt(i));
						mysql_tquery(MainPipeline, query, "OnQueryFinish", "ii", SENDDATA_THREAD, i);
					}
				}
				else
				{
					DeletePVar(i, "pBirthday");
				}
				if(GetPVarInt(i, "pBirthday") == 1)
				{
					if(PlayerInfo[i][pReceivedBGift] != 1)
					{
						PlayerInfo[i][pReceivedBGift] = 1;
						GiftPlayer(MAX_PLAYERS, i);
						format(szMiscArray, sizeof(szMiscArray), "Happy Birthday %s! You have received a free gift!", GetPlayerNameEx(i));
						SendClientMessageEx(i, COLOR_YELLOW, szMiscArray);
						format(szMiscArray, sizeof(szMiscArray), "%s(%d) has received a free gift for his birthday (%s) (Payday).", GetPlayerNameEx(i), GetPlayerSQLId(i), PlayerInfo[i][pBirthDate]);
						Log("logs/birthday.log", szMiscArray);
						SendClientMessageEx(i, COLOR_YELLOW, "Gold VIP: You will get x2 paycheck as a birthday gift today.");
						OnPlayerStatsUpdate(i);
					}
				}
			}
		}
		new iTempHour = CalculateWorldGameTime(hour, minuite);
		SetWorldTime(iTempHour);

		if(tmphour == 0) CountCitizens();

		for(new x = 0; x < MAX_POINTS; x++)
		{
			if(strcmp(DynPoints[x][poName], "NULL", true) != 0) {
				if(DynPoints[x][poTimer] > 0) DynPoints[x][poTimer]--, SavePoint(x);
				if(!DynPoints[x][poTimer] && !DynPoints[x][poCapturable] && !DynPoints[x][poLocked]) {
					format(szMiscArray, sizeof(szMiscArray), "%s has become available for capture.", DynPoints[x][poName]);
					SendClientMessageToAllEx(COLOR_YELLOW, szMiscArray);
					DynPoints[x][poCapturable] = 1;
					SavePoint(x);
				}
				if((0 <= DynPoints[x][poCaptureGroup] < MAX_GROUPS) && DynPoints[x][poAmountHour] > 0) {
					format(szMiscArray, sizeof(szMiscArray), "Your family has recieved %s %s for owning %s.", number_format(DynPoints[x][poAmountHour]), PointTypeToName(DynPoints[x][poType]), DynPoints[x][poName]);
					foreach(new i: Player)
					{
						if(PlayerInfo[i][pMember] == DynPoints[x][poCaptureGroup]) {
							SendClientMessageEx(i, COLOR_LIGHTBLUE, szMiscArray);
						}
					}
					if(DynPoints[x][poType] == 0) arrGroupData[DynPoints[x][poCaptureGroup]][g_iMaterials] += DynPoints[x][poAmountHour];
					if((1 <= DynPoints[x][poType] < 5)) arrGroupData[DynPoints[x][poCaptureGroup]][g_iDrugs][DynPoints[x][poType]-1] += DynPoints[x][poAmountHour];
				}
			}
		}

		Misc_Save();

		for(new i = 0; i < MAX_TURFS; i++)
		{
			if(TurfWars[i][twVulnerable] > 0)
			{
			    TurfWars[i][twVulnerable]--;

			    if(TurfWars[i][twVulnerable] == 0)
			    {
			    	if(TurfWars[i][twOwnerId] != -1)
			    	{
			        	format(szMiscArray,sizeof(szMiscArray),"%s that you currently own is vulnerable for capture!",TurfWars[i][twName]);
			        	foreach(new x: Player) if(PlayerInfo[x][pMember] == TurfWars[i][twOwnerId]) SendClientMessageEx(x, COLOR_YELLOW, szMiscArray);
			    	}
				}
			}
			if(TurfWars[i][twOwnerId] != INVALID_GROUP_ID && TurfWars[i][twSpecial] == 2)
			{
				arrGroupData[TurfWars[i][twOwnerId]][g_iDrugs][0] += 20;
			    arrGroupData[TurfWars[i][twOwnerId]][g_iDrugs][1] += 20;
			    arrGroupData[TurfWars[i][twOwnerId]][g_iDrugs][2] += 10;
			    arrGroupData[TurfWars[i][twOwnerId]][g_iDrugs][3] += 10;
			    arrGroupData[TurfWars[i][twOwnerId]][g_iDrugs][4] += 5;

			    foreach(new x: Player) if(PlayerInfo[x][pMember] == TurfWars[i][twOwnerId]) SendClientMessageEx(x, COLOR_LIGHTBLUE, "Your family has recieved drugs for owning a drug turf.");
			}
		}
		//CallRemoteFunction("ActivateRandomQuestion", "");//Olympics
		if(tmphour == 0 && day == 1) {
			foreach(new i: Player)
			{
				if(PlayerInfo[i][pDedicatedHours] > 0) {
					SendClientMessageEx(i, COLOR_YELLOW, "Player Dedicated has entered a new month your hours and rank have been reset.");
					PlayerInfo[i][pDedicatedHours] = 0;
					if(PlayerInfo[i][pDedicatedPlayer] != 4) PlayerInfo[i][pDedicatedPlayer] = 0;
				}
			}
			mysql_format(MainPipeline, query, sizeof(query), "UPDATE `accounts` SET `pDedicatedPlayer` = 0, `DedicatedHours` = 0 WHERE `DedicatedHours` > 0 AND `pDedicatedPlayer` != 4");
			mysql_tquery(MainPipeline, query, "OnQueryFinish", "i", SENDDATA_THREAD);
		}
	}
}

// Timer Name: ProductionUpdate()
// TickRate: 5 Minutes.
task ProductionUpdate[300000]()
{
	// Dump Accounts to /accdump/ for Crash Recovery.
	// g_mysql_DumpAccounts();

	SaveTurfWars();
	AdvisorMessage++;
	foreach(new i: Player)
	{
		if(GetPVarInt(i, "ManualSave")) DeletePVar(i, "ManualSave");

		if(AdvisorMessage == 3 && Advisors > 0 && PlayerInfo[i][pLevel] < 4)
		{
			SendClientMessageEx(i, COLOR_LIGHTBLUE, "Need help? The Advisors are here to help you. (/requesthelp to get help)");
		}
		if(PlayerInfo[i][pConnectHours] < 2) {
			SendClientMessageEx(i, COLOR_LIGHTRED, "Due to an increase in new playing accounts being created for Death Matching.");
			SendClientMessageEx(i, COLOR_LIGHTRED, "Weapons for new players are restricted for the first two hours of game play.");
		}

		/*if(PlayerInfo[i][pFishes] >= 5) {
			if(FishCount[i] >= 3) PlayerInfo[i][pFishes] = 0;
			else ++FishCount[i];
		}*/
		if(PlayerDrunk[i] > 0) { PlayerDrunk[i] = 0; PlayerDrunkTime[i] = 0; GameTextForPlayer(i, "~p~Drunk effect~n~~w~Gone", 3500, 1); }
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
				format(szMiscArray, sizeof(szMiscArray), "%s would like for you to come to Club VIP for free gifts and great times [%d minutes remains]", VIPGiftsName, VIPGiftsTimeLeft);
				SendVIPMessage(COLOR_LIGHTGREEN, szMiscArray);
			}
		}
		else
		{
			VIPGiftsTimeLeft = 0;
			VIPGifts = 0;
			format(szMiscArray, sizeof(szMiscArray), "Club VIP is no longer giving away free gifts. Thanks for coming!", VIPGiftsName, VIPGiftsTimeLeft);
			SendVIPMessage(COLOR_LIGHTGREEN, szMiscArray);
		}
	}
	ResetElevatorQueue();
	for(new h; h < MAX_HOUSES; h++)
	{
		if(HouseInfo[h][hSignExpire] && gettime() >= HouseInfo[h][hSignExpire])
		{
			format(szMiscArray, sizeof(szMiscArray), "[EXPIRE] House Sale Sign Expired - Housed ID: %d", h);
			ABroadCast(COLOR_YELLOW, szMiscArray, 4);
			Log("logs/house.log", szMiscArray);
			DeleteHouseSaleSign(h);
		}
	}
}


// Timer Name: MoneyUpdate()
// TickRate: 1 secs.
task MoneyUpdate[1000]()
{
	new minuitet=minuite;
	gettime(hour,minuite,second);
	FixHour(hour);
	hour = shifthour;

	if(minuitet != minuite)
	{
		if(minuite < 10)format(szMiscArray, sizeof(szMiscArray), "%d:0%d", hour, minuite);
		else format(szMiscArray, sizeof(szMiscArray), "%d:%d", hour, minuite);
		TextDrawSetString(WristWatch, szMiscArray);
	}
	if(EventKernel[EventStatus] >= 2 && EventKernel[EventTime] > 0)
	{
    	if(--EventKernel[EventTime] <= 0) {
    	    foreach(new i: Player)
			{
				if( GetPVarInt( i, "EventToken" ) == 1 )
				{
					if(EventKernel[EventType] == 3) {
						if(IsValidDynamic3DTextLabel(RFLTeamN3D[i])) {
							DestroyDynamic3DTextLabel(RFLTeamN3D[i]);
							RFLTeamN3D[i] = Text3D:-1;
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
					SetHealth(i, EventFloats[i][4]);
					if(EventFloats[i][5] > 0) {
						SetArmour(i, EventFloats[i][5]);
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
			    foreach(new p: Player)
				{
					new arenaid = GetPVarInt(p, "IsInArena");
					if(arenaid == i)
					{
						TogglePlayerControllable(p, 0);
						PaintballScoreboard(p, arenaid);
					}
				}
			    //SendPaintballArenaSound(i, 1057);
			}
			if(PaintBallArena[i][pbTimeLeft] <= 0)
			{
			    new
					winnerid = SortWinnerPaintballScores(i);

			    format(szMiscArray, sizeof(szMiscArray), "%s has won $%d from the Paintball Match, thanks for playing!", GetPlayerNameEx(winnerid),PaintBallArena[i][pbMoneyPool]);
			    GivePlayerCash(winnerid,PaintBallArena[i][pbMoneyPool]);
			    SendPaintballArenaMessage(i, COLOR_YELLOW, szMiscArray);
			    foreach(new p: Player)
				{
					new arenaid = GetPVarInt(p, "IsInArena");
					if(arenaid == i)
					{
						PaintballScoreboard(p, arenaid);
						TogglePlayerControllable(p, 1);
					}
				}
			    foreach(new p: Player)
				{
					new arenaid = GetPVarInt(p, "IsInArena");
					if(arenaid == i)
					{
						LeavePaintballArena(p, arenaid);
					}
				}
			    ResetPaintballArena(i);
			}
	    }
	}
}

// Timer Name: VehicleUpdate()
// TickRate: 60 secs.
task VehicleUpdate[60000]() {

    static engine, lights, alarm, doors, bonnet, boot, objective;

    foreach(new v : Vehicles) {

    	new i = GetVehicleModel(v);
    	switch(i) {

    		case 481, 509, 510: {}
    		default: {

    			GetVehicleParamsEx(v, engine, lights, alarm, doors, bonnet, boot, objective);

			    if(engine == VEHICLE_PARAMS_ON) {

					if(arr_Engine{v} == 0) SetVehicleParamsEx(v, VEHICLE_PARAMS_OFF, lights, alarm, doors, bonnet, boot, objective);

					else if(!IsVIPcar(v) && !IsFamedVeh(v)) {

						if(VehicleFuel[v] > 0.0) {

							VehicleFuel[v] -= 1.0;
							if(VehicleFuel[v] <= 0.0) SetVehicleParamsEx(v, VEHICLE_PARAMS_OFF, lights, alarm, doors, bonnet, boot, objective);
						}
					}
				}
			}
	    }
	}
}

// Task Name: hungerGames()
task hungerGames[1000]()
{
	if(hgActive)
	{
		if(hgCountdown > 0)
		{
			hgCountdown--;

			format(szMiscArray, sizeof(szMiscArray), "Time left until start: %d", hgCountdown);
			foreach(new i: Player)
			{
				if(HungerPlayerInfo[i][hgInEvent] == 1)
				{
					PlayerTextDrawSetString(i, HungerPlayerInfo[i][hgTimeLeftText], szMiscArray);
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
				foreach(new i: Player)
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

			format(szMiscArray, sizeof(szMiscArray), "Time left until start: %d", hgCountdown);
			foreach(new i: Player)
			{
				if(HungerPlayerInfo[i][hgInEvent] == 1)
				{
					PlayerTextDrawSetString(i, HungerPlayerInfo[i][hgTimeLeftText], szMiscArray);

					if(GetPVarInt(i, "HungerVoucher") == 1)
					{
						GivePlayerValidWeapon(i, 29);
						SetHealth(i, 100.0);
						DeletePVar(i, "HungerVoucher");
					}
					else
					{
						SetHealth(i, 50.0);
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


/* Player Tasks - (Optimized from tasks + foreach loop) - Jingles */

task PlayerHeartBeat[1000]() {
foreach(new i: Player)
{
		// alerttimer - Merged by Jingles
		if(AlertTime[i] != 0) AlertTime[i]--;

		new Float:playerArmour = GetArmour(i, playerArmour);
        // playertabbedloop - Merged by Jingles
        new
            iTick = gettime() - 1;

        if(floatround(playerArmour, floatround_round) < 0)
        {
            SetPlayerArmour(i, 0);
        }

		if(1 <= GetPlayerState(i) <= 3) {
			if(playerTabbed[i] >= 1) {
				if(++playerTabbed[i] >= 1200 && PlayerInfo[i][pAdmin] < 2) {
					SendClientMessageEx(i, COLOR_WHITE, "You have been automatically kicked for alt-tabbing.");
					return Disconnect(i);
				}
			}
			else if(++playerSeconds[i] < iTick && playerTabbed[i] == 0) {
				playerTabbed[i] = 1;
			}
			else if((IsPlayerInRangeOfPoint(i, 2.0, PlayerPos[i][0], PlayerPos[i][1], PlayerPos[i][2]) || InsidePlane[i] != INVALID_PLAYER_ID) && ++playerLastTyped[i] >= 10) {
				if(++playerAFK[i] >= 1200 && PlayerInfo[i][pAdmin] < 2) {
					SendClientMessageEx(i, COLOR_WHITE, "You have been automatically kicked for idling.");
					return Disconnect(i);
				}
			}
			else playerAFK[i] = 0;
			GetPlayerPos(i, PlayerPos[i][0], PlayerPos[i][1], PlayerPos[i][2]);
		}
		if(GetPVarType(i, "IsInArena") && GetPlayerVirtualWorld(i) == 0)
		{
			SendClientMessageEx(i, COLOR_WHITE, "SERVER: You have been kicked for PaintBall Exploiting.");
			format(szMiscArray, sizeof(szMiscArray), " %s(%d) (ID: %d) (IP: %s) has been kicked for attempting to Paint Ball Exploit.", GetPlayerNameEx(i), GetPlayerSQLId(i), i, GetPlayerIpEx(i));
			Log("logs/pbexploit.log", szMiscArray);
			SetTimerEx("KickEx", 1000, 0, "i", i);
		}
		// MoneyHeartBeat - Merged by Jingles
		if(gPlayerLogged{i})
		{
			if(IsSpawned[i] == 0 && PlayerInfo[i][pAdmin] < 1337)
			{
				SpawnKick[i]++;
				if(SpawnKick[i] >= 120)
				{
					IsSpawned[i] = 1;
					SpawnKick[i] = 0;

					SendClientMessageEx(i, COLOR_WHITE, "SERVER: You have been kicked for being AFK.");
					format(szMiscArray, sizeof(szMiscArray), " %s(%d) (ID: %d) (IP: %s) has been kicked for not being spawned over 2 minutes.", GetPlayerNameEx(i), GetPlayerSQLId(i), i, GetPlayerIpEx(i));
					Log("logs/spawnafk.log", szMiscArray);
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
						new ping;

						ping = GetPlayerPing(i);
						if(ping != 65535) // Invalid Ping
						{
							format(szMiscArray, sizeof(szMiscArray), "{AA3333}AdmWarning{FFFF00}: %s has just been kicked for %d ping (maximum: %d).", GetPlayerNameEx(i), ping, MAX_PING);
							ABroadCast(COLOR_YELLOW, szMiscArray, 2);
							SendClientMessageEx(i, COLOR_WHITE, "You have been kicked because your ping is higher than the maximum.");
							SetPVarInt(i, "BeingKicked", 1);
							SetTimerEx("KickEx", 1000, 0, "i", i);
						}
					}
				}
			}
			if(rBigEarT[i] > 0) {
				rBigEarT[i]--;
				if(rBigEarT[i] == 0) {
					DeletePVar(i, "BigEar");
					DeletePVar(i, "BigEarPlayer");
					SendClientMessageEx(i, COLOR_WHITE, "Big Ears has been turned off.");
				}
			}
			if(PlayerInfo[i][pTriageTime] != 0)	PlayerInfo[i][pTriageTime]--;
			if(PlayerInfo[i][pTicketTime] != 0)	PlayerInfo[i][pTicketTime]--;

			if(GetPVarInt(i, "InRangeBackup") > 0) SetPVarInt(i, "InRangeBackup", GetPVarInt(i, "InRangeBackup")-1);

			if(GetPVarInt(i, "HitCooldown") > 0) {

				SetPVarInt(i, "HitCooldown", GetPVarInt(i, "HitCooldown")-1);
				format(szMiscArray, sizeof(szMiscArray), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~r~%d seconds until approval", GetPVarInt(i, "HitCooldown"));
				GameTextForPlayer(i, szMiscArray, 1100, 3);
				if(GetPVarInt(i, "HitCooldown") == 0)
				{
					GameTextForPlayer(i, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~Contract Approved.", 5000, 3);
				}
			}
			if(GetPVarType(i, "IsTackled"))	{

				new copcount;
				foreach(new j: Player)
				{
					if(ProxDetectorS(4.0, i, j) && IsACop(j) && j != i)
					{
						copcount++;
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
						format(szMiscArray, sizeof(szMiscArray), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~r~%d", GetPVarInt(i, "TackleCooldown"));
						GameTextForPlayer(i, szMiscArray, 1100, 3);
						SetPVarInt(i, "TackleCooldown", GetPVarInt(i, "TackleCooldown")-1);
						if(GetPVarInt(i, "TackledResisting") == 2 && copcount <= 2 && GetPVarInt(i, "TackleCooldown") < 12) // resisting
						{
							new escapechance = random(100);
							switch(escapechance)
							{
								case 35,40,22,72,11..16, 62..64:
								{
									GameTextForPlayer(i, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~ESCAPE!", 10000, 3);
									SendClientMessageEx(i, COLOR_GREEN, "You're able to push the officer off you and escape.");
									format(szMiscArray, sizeof(szMiscArray), "** %s pushes %s aside and is able to escape.", GetPlayerNameEx(i), GetPlayerNameEx(GetPVarInt(i, "IsTackled")));
									ProxDetector(30.0, i, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
									TogglePlayerControllable(GetPVarInt(i, "IsTackled"), 0);
									ApplyAnimation(GetPVarInt(i, "IsTackled"), "SWEET", "Sweet_injuredloop", 4.0, 1, 1, 1, 1, 0, 1);
									SetTimerEx("CopGetUp", 2500, 0, "i", GetPVarInt(i, "IsTackled"));
									ClearTackle(i);
								}
							}
						}
						else if(GetPVarInt(i, "TackledResisting") == 2 && copcount <= 3 && GetPVarInt(i, "TackleCooldown") < 12) // resisting
						{
							new escapechance = random(100);
							switch(escapechance)
							{
								case 35,40,22,62:
								{
									GameTextForPlayer(i, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~ESCAPE!", 10000, 3);
									SendClientMessageEx(i, COLOR_GREEN, "You're able to push the officer off you and escape.");
									format(szMiscArray, sizeof(szMiscArray), "** %s pushes %s aside and is able to escape.", GetPlayerNameEx(i), GetPlayerNameEx(GetPVarInt(i, "IsTackled")));
									ProxDetector(30.0, i, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
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
					ShowPlayerDialogEx(i, -1, DIALOG_STYLE_LIST, "Close", "Close", "Close", "Close");
					ClearTackle(i);
				}
			}
			if(GetPVarInt(i, "CopTackleCooldown") > 0)
			{
				SetPVarInt(i, "CopTackleCooldown", GetPVarInt(i, "CopTackleCooldown")-1);
			}
			if(GetPVarInt(i, "CantBeTackledCount") > 0)
			{
				SetPVarInt(i, "CantBeTackledCount", GetPVarInt(i, "CantBeTackledCount")-1);
			}
			if(PlayerInfo[i][pCash] != GetPlayerMoney(i))
			{
				ResetPlayerMoney(i);
				GivePlayerMoney(i, PlayerInfo[i][pCash]);
			}
			if(PlayerInfo[i][pGPS] > 0 && GetPVarType(i, "gpsonoff"))
			{
				new zone[28];
				GetPlayer3DZone(i, zone, MAX_ZONE_NAME);
				PlayerTextDrawSetString(i, GPS[i], zone);
			}
			if(GetPVarType(i, "Injured")) SetPlayerArmedWeapon(i, 0);
			if(GetPVarType(i, "IsFrozen")) TogglePlayerControllable(i, 0);
			if(PlayerCuffed[i] > 1) {
				SetHealth(i, 1000);
				SetArmour(i, GetPVarFloat(i, "cuffarmor"));
			}
		}

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

		if (GetPVarInt(i, "MailTime") > 0) SetPVarInt(i, "MailTime", GetPVarInt(i, "MailTime") - 1);
		else DeletePVar(i, "MailTime");

		if(PlayerInfo[i][pJudgeJailType] != 0 && PlayerInfo[i][pJudgeJailTime] > 0 && !PlayerInfo[i][pBeingSentenced]) PlayerInfo[i][pJudgeJailTime]--;
		if(PlayerInfo[i][pJudgeJailTime] <= 0 && PlayerInfo[i][pJudgeJailType] != 0) PlayerInfo[i][pJudgeJailType] = 0;


		if(playerTabbed[i] == 0)
		{
			if(PlayerInfo[i][pJailTime] > 0 && --PlayerInfo[i][pJailTime] <= 0)
			{
				if(strfind(PlayerInfo[i][pPrisonReason], "[IC]", true) != -1)
				{
			    	ShowPlayerDialogEx(i, DIALOG_STAYPRISON, DIALOG_STYLE_MSGBOX, "Notice", "Your initial prison time has ran out. However, you can choose to stay.\nWould you like to be released?", "Yes", "No");
				}
				else
				{
					ReleasePlayerFromPrison(i);
				}
			}
			if(gettime() >= PlayerInfo[i][pPrisonWineTime] && GetPVarInt(i, "pPrisonMWine") == 1 && strfind(PlayerInfo[i][pPrisonReason], "[IC]", true) != -1)
			{
				SetPVarInt(i, "pPrisonMWine", 2);
			    SendClientMessageEx(i, COLOR_GREY, "Your pruno is finished. Go to your cell and type /finishpruno to collect it.");
			}
			

			if(GetPVarType(i, "AttemptingLockPick") && GetPVarType(i, "LockPickCountdown")) {

				new Float: vehSize[3],
					Float: Pos[3],
					vehicleid = GetPVarInt(i, "LockPickVehicle"),
					ownerid = GetPVarInt(i, "LockPickPlayer");
				GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_SIZE, vehSize[0], vehSize[1], vehSize[2]);
				GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_FRONTSEAT, Pos[0], Pos[1], Pos[2]);
				GetVehicleRelativePos(vehicleid, Pos[0], Pos[1], Pos[2], Pos[0]+((vehSize[0] / 2)-(vehSize[0])), Pos[1], 0.0);
				if(IsPlayerInRangeOfPoint(i, 1.0, Pos[0], Pos[1], Pos[2]) && !IsPlayerInAnyVehicle(i)) {
					SetPVarInt(i, "LockPickCountdown", GetPVarInt(i, "LockPickCountdown")-1);
					UpdateVLPTextDraws(i, vehicleid);
					if(GetPVarType(i, "LockPickVehicleSQLId")) {
						if(GetPVarInt(i, "LockPickCountdown") <= 0) {
							LockStatus{vehicleid} = 0;
							vehicle_unlock_doors(vehicleid);
							SetPVarInt(i, "VLPLocksLeft", GetPVarInt(i, "VLPLocksLeft")-1);
							mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "UPDATE `vehicles` SET `pvLocksLeft` = '%d', `pvLastLockPickedBy` = '%e' WHERE `id` = '%d' AND `sqlID` = '%d'", GetPVarInt(i, "VLPLocksLeft"), GetPlayerNameExt(i), GetPVarInt(i, "LockPickVehicleSQLId"), GetPVarInt(i, "LockPickPlayerSQLId"));
							mysql_tquery(MainPipeline, szMiscArray, "OnQueryFinish", "ii", SENDDATA_THREAD, i);
							new ip[MAX_PLAYER_NAME], ownername[MAX_PLAYER_NAME];
							GetPlayerIp(i, ip, sizeof(ip)), GetPVarString(i, "LockPickPlayerName", ownername, sizeof(ownername));
							format(szMiscArray, sizeof(szMiscArray), "[LOCK PICK] %s (IP:%s, SQLId: %d) successfully lock picked a %s(VID:%d SQLId %d) owned by %s(Offline, SQLId: %d)", GetPlayerNameEx(i), ip, GetPlayerSQLId(i), GetVehicleName(vehicleid), vehicleid, GetPVarInt(i, "LockPickVehicleSQLId"), ownername, GetPVarInt(i, "LockPickPlayerSQLId"));
							Log("logs/playervehicle.log", szMiscArray);
							/* DeletePVar(i, "LockPickVehicle");
							DeletePVar(i, "LockPickPlayer"); */
						}
					}
					else {
						new slot = GetPlayerVehicle(GetPVarInt(i, "LockPickPlayer"), GetPVarInt(i, "LockPickVehicle"));
						if(!PlayerVehicleInfo[ownerid][slot][pvAlarmTriggered] && (GetPVarInt(i, "LockPickCountdown") <= floatround((GetPVarInt(i, "LockPickTotalTime") * 0.4), floatround_ceil))) {
							TriggerVehicleAlarm(i, ownerid, vehicleid);
						}
						if(GetPVarInt(i, "LockPickCountdown") <= 0) {
							PlayerVehicleInfo[ownerid][slot][pvLocked] = 0;
							UnLockPlayerVehicle(ownerid, PlayerVehicleInfo[ownerid][slot][pvId], PlayerVehicleInfo[ownerid][slot][pvLock]);
							PlayerVehicleInfo[ownerid][slot][pvBeingPickLocked] = 2;
							if(--PlayerVehicleInfo[ownerid][slot][pvLocksLeft] <= 0 && PlayerVehicleInfo[ownerid][slot][pvLock]) {
								SendClientMessageEx(i, COLOR_PURPLE, "(( The lock has been damaged as result of the lock pick! ))");
							}
							strcpy(PlayerVehicleInfo[ownerid][slot][pvLastLockPickedBy], GetPlayerNameEx(i));
							new ip[MAX_PLAYER_NAME], ip2[MAX_PLAYER_NAME];
							GetPlayerIp(i, ip, sizeof(ip));
							GetPlayerIp(ownerid, ip2, sizeof(ip2));
							format(szMiscArray, sizeof(szMiscArray), "[LOCK PICK] %s (IP:%s SQLId: %d) successfully lock picked a %s(VID:%d Slot %d) owned by %s(IP:%s SQLId: %d)", GetPlayerNameEx(i), ip, GetPlayerSQLId(i), GetVehicleName(vehicleid), vehicleid, slot, GetPlayerNameEx(ownerid), ip2, GetPlayerSQLId(ownerid));
							Log("logs/playervehicle.log", szMiscArray);
						}
					}

					if(GetPVarInt(i, "LockPickCountdown") <= 0) {
						if(--PlayerInfo[i][pToolBox] <= 0) SendClientMessageEx(i, COLOR_PURPLE, "(( The tools from the Tool Box look spoiled, you may need to get a new Tool Box ))");
						if(++PlayerInfo[i][pLockPickVehCount] > 11) {
							PlayerInfo[i][pLockPickTime] = gettime() + 21600;
							PlayerInfo[i][pLockPickVehCount] = 0;
						}
						ClearCheckpoint(i);
						new engine, lights, alarm, doors, bonnet, boot, objective;
						GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
						SetVehicleParamsEx(vehicleid,engine,lights,VEHICLE_PARAMS_OFF,doors,bonnet,boot,objective);
						SendClientMessageEx(i, COLOR_YELLOW, "You have successfully picked this vehicle lock, you may now deliver this to the checkpoint mark to get money.");
						if(PlayerInfo[i][pCrowBar] > 0) SendClientMessageEx(i, COLOR_CYAN, "Optionally, you may try to open the trunk to see what's inside (/cracktrunk).");
						PlayerPlaySound(i, 1145, 0.0, 0.0, 0.0);
						SetPlayerSkin(i, GetPlayerSkin(i));
						SetPlayerSpecialAction(i, SPECIAL_ACTION_NONE);
						new rand = random(sizeof(lpRandomLocations));
						while(IsPlayerInRangeOfPoint(i, 1000.0, lpRandomLocations[rand][0], lpRandomLocations[rand][1], lpRandomLocations[rand][2]))
							rand = random(sizeof(lpRandomLocations));
						SetPlayerCheckpoint(i, lpRandomLocations[rand][0], lpRandomLocations[rand][1], lpRandomLocations[rand][2], 8.0);
						SetPVarInt(i, "DeliveringVehicleTime", gettime()+900);
						new Float: pX, Float: pY, Float: pZ;
						GetPlayerPos(i, pX, pY, pZ);
						SetPVarFloat(i, "tpDeliverVehX", pX);
				 		SetPVarFloat(i, "tpDeliverVehY", pY);
				  		SetPVarFloat(i, "tpDeliverVehZ", pZ);
						SetPVarInt(i, "tpDeliverVehTimer", 80);
						SetTimerEx("OtherTimerEx", 1000, false, "ii", i, TYPE_DELIVERVEHICLE);
						DestroyVLPTextDraws(i);
						DeletePVar(i, "AttemptingLockPick");
						DeletePVar(i, "LockPickCountdown");
						DeletePVar(i, "LockPickTotalTime");
						ClearAnimationsEx(i, 1);

						if(PlayerInfo[i][pDoubleEXP] > 0) {
							format(szMiscArray, sizeof(szMiscArray), "You have gained 2 Vehicle Lock Picking skill points instead of 1. You have %d hours left on the Double EXP token.", PlayerInfo[i][pDoubleEXP]);
							SendClientMessageEx(i, COLOR_YELLOW, szMiscArray);
							PlayerInfo[i][pCarLockPickSkill] += 2;
						}
						else ++PlayerInfo[i][pCarLockPickSkill];

						switch(PlayerInfo[i][pCarLockPickSkill]) {
							case 50: SendClientMessageEx(i, COLOR_YELLOW, "* Your Car Lock Picking Skill is now Level 2, you will get more rewards & time will be reduced.");
							case 125: SendClientMessageEx(i, COLOR_YELLOW, "* Your Car Lock Picking Skill is now Level 3, you will get more rewards & time will be reduced.");
							case 225: SendClientMessageEx(i, COLOR_YELLOW, "* Your Car Lock Picking Skill is now Level 4, you will get more rewards & time will be reduced.");
							case 350: SendClientMessageEx(i, COLOR_YELLOW, "* Your Car Lock Picking Skill is now Level 5, you will get more rewards & time will be reduced.");
						}
						/* DeletePVar(i, "LockPickVehicle");
						DeletePVar(i, "LockPickPlayer"); */
					}
					else if((GetPVarInt(i, "LockPickCountdown") <= floatround((GetPVarInt(i, "LockPickTotalTime") * 0.9), floatround_ceil)) && GetPlayerAnimationIndex(i) != 368) {
						SendClientMessageEx(i, COLOR_YELLOW, "Warning{FFFFFF}: You have moved from your current position therefore you have failed this lock pick.");
						DeletePVar(i, "AttemptingLockPick");
						DeletePVar(i, "LockPickCountdown");
						DeletePVar(i, "LockPickTotalTime");
						if(GetPVarType(i, "LockPickVehicleSQLId")) {
							DeletePVar(i, "LockPickVehicleSQLId");
							DeletePVar(i, "LockPickPlayerSQLId");
							DeletePVar(i, "LockPickPlayerName");
							DestroyVehicle(GetPVarInt(i, "LockPickVehicle"));
						}
						else {
							new slot = GetPlayerVehicle(GetPVarInt(i, "LockPickPlayer"), GetPVarInt(i, "LockPickVehicle"));
							PlayerVehicleInfo[GetPVarInt(i, "LockPickPlayer")][slot][pvBeingPickLocked] = 0;
							PlayerVehicleInfo[GetPVarInt(i, "LockPickPlayer")][slot][pvBeingPickLockedBy] = INVALID_PLAYER_ID;
						}
						DeletePVar(i, "LockPickVehicle");
						DeletePVar(i, "LockPickPlayer");
						DestroyVLPTextDraws(i);
						ClearAnimationsEx(i, 1);
					}
				}
				else {
					SendClientMessageEx(i, COLOR_YELLOW, "Warning{FFFFFF}: You have moved from your current position therefore you have failed this lock pick.");
					DeletePVar(i, "AttemptingLockPick");
					DeletePVar(i, "LockPickCountdown");
					DeletePVar(i, "LockPickTotalTime");
					if(GetPVarType(i, "LockPickVehicleSQLId")) {
						DeletePVar(i, "LockPickVehicleSQLId");
						DeletePVar(i, "LockPickPlayerSQLId");
						DeletePVar(i, "LockPickPlayerName");
						DestroyVehicle(GetPVarInt(i, "LockPickVehicle"));
					}
					else {
						new slot = GetPlayerVehicle(GetPVarInt(i, "LockPickPlayer"), GetPVarInt(i, "LockPickVehicle"));
						PlayerVehicleInfo[GetPVarInt(i, "LockPickPlayer")][slot][pvBeingPickLocked] = 0;
						PlayerVehicleInfo[GetPVarInt(i, "LockPickPlayer")][slot][pvBeingPickLockedBy] = INVALID_PLAYER_ID;
					}
					DeletePVar(i, "LockPickVehicle");
					DeletePVar(i, "LockPickPlayer");
					DestroyVLPTextDraws(i);
					ClearAnimationsEx(i, 1);
				}
			}
			if(GetPVarType(i, "AttemptingCrackTrunk") && GetPVarType(i, "CrackTrunkCountdown")) {
				new	vehicleid = GetPVarInt(i, "LockPickVehicle"),
					Float: Pos[3];

				GetPosBehindVehicle(vehicleid, Pos[0], Pos[1], Pos[2], 1.0);
				if(IsPlayerInRangeOfPoint(i, 1.0, Pos[0], Pos[1], Pos[2]) && !IsPlayerInAnyVehicle(i)) {
					SetPVarInt(i, "CrackTrunkCountdown", GetPVarInt(i, "CrackTrunkCountdown")-1);
					UpdateVLPTextDraws(i, vehicleid, 1);
					if(GetPVarInt(i, "CrackTrunkCountdown") <= 0) {
						new
							wslot,
							ownerid = GetPVarInt(i, "LockPickPlayer");
						SendClientMessageEx(i, COLOR_PURPLE, "(( The trunk cracks, you begin to search for any items ))");
						PlayerPlaySound(i, 1145, 0.0, 0.0, 0.0);
						new engine, lights, alarm, doors, bonnet, boot, objective;
						GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
						SetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,VEHICLE_PARAMS_ON,objective);
						ClearAnimationsEx(i, 1);
						SetPlayerSkin(i, GetPlayerSkin(i));
						SetPlayerSpecialAction(i, SPECIAL_ACTION_NONE);
						if(GetPVarType(i, "LockPickVehicleSQLId")) {
							mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "SELECT `pvWeapon0`, `pvWeapon1`, `pvWeapon2` FROM `vehicles` WHERE `id` = '%d' AND `sqlID` = '%d'", GetPVarInt(i, "LockPickVehicleSQLId"), GetPVarInt(i, "LockPickPlayerSQLId"));
							mysql_tquery(MainPipeline, szMiscArray, "CheckTrunkContents", "i", i);
						}
						else {
							new slot = GetPlayerVehicle(GetPVarInt(i, "LockPickPlayer"), GetPVarInt(i, "LockPickVehicle"));
							wslot = FindGunInVehicleForPlayer(ownerid, slot, i);
							if(wslot != -1) {
								format(szMiscArray, sizeof(szMiscArray), "You found a %s.", GetWeaponNameEx(PlayerVehicleInfo[ownerid][slot][pvWeapons][wslot]));
								SendClientMessageEx(i, COLOR_YELLOW, szMiscArray);
								GivePlayerValidWeapon(i, PlayerVehicleInfo[ownerid][slot][pvWeapons][wslot]);
								PlayerVehicleInfo[ownerid][slot][pvWeapons][wslot] = 0;
								g_mysql_SaveVehicle(ownerid, slot);
								new ip[MAX_PLAYER_NAME], ip2[MAX_PLAYER_NAME];
								GetPlayerIp(i, ip, sizeof(ip));
								GetPlayerIp(ownerid, ip2, sizeof(ip2));
								format(szMiscArray, sizeof(szMiscArray), "[LOCK PICK] %s(%s) (IP:%s) successfully cracked the trunk of a %s(VID:%d Slot %d Weapon ID: %d) owned by %s(IP:%s)", GetPlayerNameEx(i), GetPlayerSQLId(i), ip, GetVehicleName(vehicleid), vehicleid, slot, PlayerVehicleInfo[ownerid][slot][pvWeapons][wslot], GetPlayerNameEx(ownerid), ip2);
								Log("logs/playervehicle.log", szMiscArray);
							}
							else SendClientMessageEx(i, COLOR_YELLOW, "Warning{FFFFFF}: There was nothing inside the trunk.");
						}
						DestroyVLPTextDraws(i);
						if(--PlayerInfo[i][pCrowBar] <= 0) SendClientMessageEx(i, COLOR_PURPLE, "(( The tools from the Tool Box look spoiled, you may need to get a new Tool Box ))");
						SetPVarInt(i, "TrunkAlreadyCracked", 1);
						DeletePVar(i, "AttemptingCrackTrunk");
						DeletePVar(i, "CrackTrunkCountdown");
					}
					if(GetPlayerAnimationIndex(i) != 368 && GetPVarInt(i, "CrackTrunkCountdown") <= 50) {
						DestroyVLPTextDraws(i);
						SendClientMessageEx(i, COLOR_YELLOW, "Warning{FFFFFF}: You have moved from your current position therefore you have failed this lock pick.");
						DeletePVar(i, "AttemptingCrackTrunk");
						DeletePVar(i, "CrackTrunkCountdown");
						ClearAnimationsEx(i, 1);
					}
				}
				else {
					DestroyVLPTextDraws(i);
					SendClientMessageEx(i, COLOR_YELLOW, "Warning{FFFFFF}: You have moved from your current position therefore you have failed this lock pick.");
					DeletePVar(i, "AttemptingCrackTrunk");
					DeletePVar(i, "CrackTrunkCountdown");
					ClearAnimationsEx(i, 1);
				}
			}
			if(GetPVarType(i, "TrackVehicleBurglary")) {
				if(IsPlayerConnected(GetPVarInt(i, "CallId"))) {
					SetPVarInt(i, "TrackVehicleBurglary", GetPVarInt(i, "TrackVehicleBurglary")-1);
					new Float: carPos[3];
					GetVehiclePos(Calls[GetPVarInt(i, "CallId")][CallVehicleId], carPos[0], carPos[1], carPos[2]);
					if(GetPVarFloat(i, "CarLastX") != carPos[0] || GetPVarFloat(i, "CarLastY") != carPos[1] || GetPVarFloat(i, "CarLastZ") != carPos[2])
						SetPVarFloat(i, "CarLastX", carPos[0]), SetPVarFloat(i, "CarLastY", carPos[1]), SetPVarFloat(i, "CarLastZ", carPos[2]), SetPlayerCheckpoint(i, carPos[0], carPos[1], carPos[2], 15.0);
					if(GetPVarInt(i, "TrackVehicleBurglary") <= 0) {
						DisablePlayerCheckpoint(i);
						DeletePVar(i, "TrackVehicleBurglary");
						DeletePVar(i, "CallId");
						DeletePVar(i, "CarLastX");
						DeletePVar(i, "CarLastY");
						DeletePVar(i, "CarLastZ");
						SendClientMessageEx(i, COLOR_PURPLE, "(( The 2 minutes have been reached, you lost trace of this vehicle! ))");
					}
				}
				else {
					DisablePlayerCheckpoint(i);
					DeletePVar(i, "TrackVehicleBurglary");
					DeletePVar(i, "CallId");
					DeletePVar(i, "CarLastX");
					DeletePVar(i, "CarLastY");
					DeletePVar(i, "CarLastZ");
					SendClientMessageEx(i, COLOR_PURPLE, "The caller has disconnected!");
				}
			}
			if(GetPVarType(i, "wheelclampcountdown")) {
				SetPVarInt(i, "wheelclampcountdown", GetPVarInt(i, "wheelclampcountdown")-1);
				new vehicleid = GetPVarInt(i, "wheelclampvehicle"),
					Float:CarPos[3],
					arrVehParams[7];
				GetVehiclePos(vehicleid, CarPos[0], CarPos[1], CarPos[2]);
				if(!IsPlayerInRangeOfPoint(i, 5.0, CarPos[0], CarPos[1], CarPos[2]) || IsPlayerInAnyVehicle(i)) {
					DeletePVar(i, "wheelclampvehicle");
					DeletePVar(i, "wheelclampcountdown");
					SendClientMessageEx(i, COLOR_PURPLE, "(( You failed placing the Wheel Clamp in the vehicle's front tire. ))");
				}
				else if(GetPVarInt(i, "wheelclampcountdown") <= 0) {
					WheelClamp{vehicleid} = 1;
					arr_Engine{vehicleid} = 0;
					GetVehicleParamsEx(vehicleid, arrVehParams[0], arrVehParams[1], arrVehParams[2], arrVehParams[3], arrVehParams[4], arrVehParams[5], arrVehParams[6]);
					if(arrVehParams[0] == VEHICLE_PARAMS_ON) SetVehicleParamsEx(vehicleid,VEHICLE_PARAMS_OFF, arrVehParams[1], arrVehParams[2], arrVehParams[3], arrVehParams[4], arrVehParams[5], arrVehParams[6]);
					DeletePVar(i, "wheelclampvehicle");
					DeletePVar(i, "wheelclampcountdown");
					format(szMiscArray, sizeof(szMiscArray), "* %s has attached a Wheel Clamp on the %s's front tire.", GetPlayerNameEx(i), GetVehicleName(vehicleid), vehicleid);
					ProxDetector(30.0, i, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
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
					format(szMiscArray, sizeof(szMiscArray), "%d", BoxDelay - BoxWaitTime[i]);
					GameTextForPlayer(i, szMiscArray, 1500, 6);
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
					GetHealth(i, health);
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
													format(szMiscArray, sizeof(szMiscArray), "%s", titel);
													strmid(Titel[TitelName], szMiscArray, 0, strlen(szMiscArray), 255);
													Titel[TitelWins] = PlayerInfo[TBoxer][pWins];
													Titel[TitelLoses] = PlayerInfo[TBoxer][pLoses];
													Misc_Save();
													format(szMiscArray, sizeof(szMiscArray), "Boxing News: %s has Won the fight against Champion %s and is now the new Boxing Champion.",  titel, loser);
													ProxDetector(30.0, Boxer1, szMiscArray, COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE);
												}
												else
												{
													SendClientMessageEx(Boxer2, COLOR_LIGHTBLUE, "* You would have been the Champion if you had the Boxer Job!");
												}
											}
											else
											{
												GetPlayerName(TBoxer, titel, sizeof(titel));
												format(szMiscArray, sizeof(szMiscArray), "Boxing News: Boxing Champion %s has Won the fight against %s.",  titel, loser);
												ProxDetector(30.0, Boxer1, szMiscArray, COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE);
												Titel[TitelWins] = PlayerInfo[TBoxer][pWins];
												Titel[TitelLoses] = PlayerInfo[Boxer2][pLoses];
												Misc_Save();
											}
										}
									}//TBoxer
									format(szMiscArray, sizeof(szMiscArray), "* You have Lost the Fight against %s.", winner);
									SendClientMessageEx(Boxer1, COLOR_LIGHTBLUE, szMiscArray);
									GameTextForPlayer(Boxer1, "~r~You lost", 3500, 1);
									format(szMiscArray, sizeof(szMiscArray), "* You have Won the Fight against %s.", loser);
									SendClientMessageEx(Boxer2, COLOR_LIGHTBLUE, szMiscArray);
									GameTextForPlayer(Boxer2, "~r~You won", 3500, 1);
									if(GetHealth(Boxer1, health) < 20)
									{
										SendClientMessageEx(Boxer1, COLOR_LIGHTBLUE, "* You feel exhausted from the Fight, go eat somewhere.");
										SetHealth(Boxer1, 30.0);
									}
									else
									{
										SendClientMessageEx(Boxer1, COLOR_LIGHTBLUE, "* You feel perfect, even after the Fight.");
										SetHealth(Boxer1, 50.0);
									}
									if(GetHealth(Boxer2, health) < 20)
									{
										SendClientMessageEx(Boxer2, COLOR_LIGHTBLUE, "* You feel exhausted from the Fight, go eat somewhere.");
										SetHealth(Boxer2, 30.0);
									}
									else
									{
										SendClientMessageEx(Boxer2, COLOR_LIGHTBLUE, "* You feel perfect, even after the Fight.");
										SetHealth(Boxer2, 50.0);
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
												format(szMiscArray, sizeof(szMiscArray), "%s", titel);
												strmid(Titel[TitelName], szMiscArray, 0, strlen(szMiscArray), 255);
												Titel[TitelWins] = PlayerInfo[TBoxer][pWins];
												Titel[TitelLoses] = PlayerInfo[TBoxer][pLoses];
												Misc_Save();
												format(szMiscArray, sizeof(szMiscArray), "Boxing News: %s has Won the fight against Champion %s and is now the new Boxing Champion.",  titel, loser);
												ProxDetector(30.0, Boxer1, szMiscArray, COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE);
											}
											else
											{
												SendClientMessageEx(Boxer2, COLOR_LIGHTBLUE, "* You would have been the Champion if you had the Boxer Job!");
											}
										}
										else
										{
											GetPlayerName(TBoxer, titel, sizeof(titel));
											format(szMiscArray, sizeof(szMiscArray), "Boxing News: Boxing Champion %s has Won the fight against %s.",  titel, loser);
											ProxDetector(30.0, Boxer1, szMiscArray, COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE);
											Titel[TitelWins] = PlayerInfo[TBoxer][pWins];
											Titel[TitelLoses] = PlayerInfo[Boxer2][pLoses];
											Misc_Save();
										}
									}
								}//TBoxer
								format(szMiscArray, sizeof(szMiscArray), "* You have Lost the Fight against %s.", winner);
								SendClientMessageEx(Boxer1, COLOR_LIGHTBLUE, szMiscArray);
								GameTextForPlayer(Boxer1, "~r~You lost", 3500, 1);
								format(szMiscArray, sizeof(szMiscArray), "* You have Won the Fight against %s.", loser);
								SendClientMessageEx(Boxer2, COLOR_LIGHTBLUE, szMiscArray);
								GameTextForPlayer(Boxer2, "~r~You won", 3500, 1);
								if(GetHealth(Boxer1, health) < 20)
								{
									SendClientMessageEx(Boxer1, COLOR_LIGHTBLUE, "* You feel exhausted from the Fight, go eat somewhere.");
									SetHealth(Boxer1, 30.0);
								}
								else
								{
									SendClientMessageEx(Boxer1, COLOR_LIGHTBLUE, "* You feel perfect, even after the Fight.");
									SetHealth(Boxer1, 50.0);
								}
								if(GetHealth(Boxer2, health) < 20)
								{
									SendClientMessageEx(Boxer2, COLOR_LIGHTBLUE, "* You feel exhausted from the Fight, go eat somewhere.");
									SetHealth(Boxer2, 30.0);
								}
								else
								{
									SendClientMessageEx(Boxer2, COLOR_LIGHTBLUE, "* You feel perfect, even after the Fight.");
									SetHealth(Boxer2, 50.0);
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
													format(szMiscArray, sizeof(szMiscArray), "%s", titel);
													strmid(Titel[TitelName], szMiscArray, 0, strlen(szMiscArray), 255);
													Titel[TitelWins] = PlayerInfo[TBoxer][pWins];
													Titel[TitelLoses] = PlayerInfo[TBoxer][pLoses];
													Misc_Save();
													format(szMiscArray, sizeof(szMiscArray), "Boxing News: %s has Won the fight against Champion %s and is now the new Boxing Champion.",  titel, loser);
													ProxDetector(30.0, Boxer1, szMiscArray, COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE);
												}
												else
												{
													SendClientMessageEx(Boxer1, COLOR_LIGHTBLUE, "* You would have been the Champion if you had the Boxer Job!");
												}
											}
											else
											{
												GetPlayerName(TBoxer, titel, sizeof(titel));
												format(szMiscArray, sizeof(szMiscArray), "Boxing News: Boxing Champion %s has Won the fight against %s.",  titel, loser);
												ProxDetector(30.0, Boxer1, szMiscArray, COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE);
												Titel[TitelWins] = PlayerInfo[TBoxer][pWins];
												Titel[TitelLoses] = PlayerInfo[Boxer1][pLoses];
												Misc_Save();
											}
										}
									}
									//TBoxer
									format(szMiscArray, sizeof(szMiscArray), "* You have Lost the Fight against %s.", winner);
									SendClientMessageEx(Boxer2, COLOR_LIGHTBLUE, szMiscArray);
									GameTextForPlayer(Boxer2, "~r~You lost", 3500, 1);
									format(szMiscArray, sizeof(szMiscArray), "* You have Won the Fight against %s.", loser);
									SendClientMessageEx(Boxer1, COLOR_LIGHTBLUE, szMiscArray);
									GameTextForPlayer(Boxer1, "~g~You won", 3500, 1);
									if(GetHealth(Boxer1, health) < 20)
									{
										SendClientMessageEx(Boxer1, COLOR_LIGHTBLUE, "* You feel exhausted from the fight, go eat somewhere.");
										SetHealth(Boxer1, 30.0);
									}
									else
									{
										SendClientMessageEx(Boxer1, COLOR_LIGHTBLUE, "* You feel perfect, even after the Fight.");
										SetHealth(Boxer1, 50.0);
									}
									if(GetHealth(Boxer2, health) < 20)
									{
										SendClientMessageEx(Boxer2, COLOR_LIGHTBLUE, "* You feel exhausted from the fight, go eat somewhere.");
										SetHealth(Boxer2, 30.0);
									}
									else
									{
										SendClientMessageEx(Boxer2, COLOR_LIGHTBLUE, "* You feel perfect, even after the fight.");
										SetHealth(Boxer2, 50.0);
									}
									GameTextForPlayer(Boxer1, "~g~Match Over", 5000, 1); GameTextForPlayer(Boxer2, "~g~Match Over", 5000, 1);
									if(PlayerInfo[Boxer1][pJob] == 12 || PlayerInfo[Boxer1][pJob2] == 12 || PlayerInfo[Boxer1][pJob3] == 12) { PlayerInfo[Boxer1][pBoxSkill] += 1; }
									PlayerBoxing[Boxer1] = 0;
									PlayerBoxing[Boxer2] = 0;
								}
								SetPlayerPos(Boxer1, 768.48, -73.66, 1000.57);
								SetPlayerPos(Boxer2, 768.48, -73.66, 1000.57);
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
												format(szMiscArray, sizeof(szMiscArray), "%s", titel);
												strmid(Titel[TitelName], szMiscArray, 0, strlen(szMiscArray), 255);
												Titel[TitelWins] = PlayerInfo[TBoxer][pWins];
												Titel[TitelLoses] = PlayerInfo[TBoxer][pLoses];
												Misc_Save();
												format(szMiscArray, sizeof(szMiscArray), "Boxing News: %s has Won the fight against Champion %s and is now the new Boxing Champion.",  titel, loser);
												ProxDetector(30.0, Boxer1, szMiscArray, COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE);
											}
											else
											{
												SendClientMessageEx(Boxer1, COLOR_LIGHTBLUE, "* You would have been the Champion if you had the Boxer Job!");
											}
										}
										else
										{
											GetPlayerName(TBoxer, titel, sizeof(titel));
											format(szMiscArray, sizeof(szMiscArray), "Boxing News: Boxing Champion %s has Won the fight against %s.",  titel, loser);
											ProxDetector(30.0, Boxer1, szMiscArray, COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE);
											Titel[TitelWins] = PlayerInfo[TBoxer][pWins];
											Titel[TitelLoses] = PlayerInfo[Boxer1][pLoses];
											Misc_Save();
										}
									}
								}
								//TBoxer
								format(szMiscArray, sizeof(szMiscArray), "* You have Lost the Fight against %s.", winner);
								SendClientMessageEx(Boxer2, COLOR_LIGHTBLUE, szMiscArray);
								GameTextForPlayer(Boxer2, "~r~You lost", 3500, 1);
								format(szMiscArray, sizeof(szMiscArray), "* You have Won the Fight against %s.", loser);
								SendClientMessageEx(Boxer1, COLOR_LIGHTBLUE, szMiscArray);
								GameTextForPlayer(Boxer1, "~g~You won", 3500, 1);
								if(GetHealth(Boxer1, health) < 20)
								{
									SendClientMessageEx(Boxer1, COLOR_LIGHTBLUE, "* You feel exhausted from the Fight, go eat somewhere.");
									SetHealth(Boxer1, 30.0);
								}
								else
								{
									SendClientMessageEx(Boxer1, COLOR_LIGHTBLUE, "* You feel perfect, even after the Fight.");
									SetHealth(Boxer1, 50.0);
								}
								if(GetHealth(Boxer2, health) < 20)
								{
									SendClientMessageEx(Boxer2, COLOR_LIGHTBLUE, "* You feel exhausted from the Fight, go eat somewhere.");
									SetHealth(Boxer2, 30.0);
								}
								else
								{
									SendClientMessageEx(Boxer2, COLOR_LIGHTBLUE, "* You feel perfect, even after the Fight.");
									SetHealth(Boxer2, 50.0);
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
					GameTextForPlayer(i, "~r~Signal lost", 2500, 1);
				}
				else
				{
					format(szMiscArray, sizeof(szMiscArray), "%d", FindTimePoints[i] - FindTime[i]);
					GameTextForPlayer(i, szMiscArray, 1500, 6);
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
						if(!GetPlayerInterior(EMSAccepted[i])) {

							new Float:X,Float:Y,Float:Z;
							GetPlayerPos(EMSAccepted[i], X, Y, Z);
							new zone[MAX_ZONE_NAME];
							Get3DZone(X, Y, Z, zone, sizeof(zone));
							format(szMiscArray, sizeof(szMiscArray), "Your patient is located in %s.", zone);
							SetPlayerCheckpoint(i, X, Y, Z, 5);
						}
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
				// if(MedicCallTime[i] == 45) { MedicCallTime[i] = 0; DisablePlayerCheckpoint(i); PlayerPlaySound(i, 1056, 0.0, 0.0, 0.0); GameTextForPlayer(i, "~r~RedMarker gone", 2500, 1); }
				// else
				{
					format(szMiscArray, sizeof(szMiscArray), "%d", 45 - MedicCallTime[i]);
					new Float:X,Float:Y,Float:Z;
					GetPlayerPos(MedicAccepted[i], X, Y, Z);
					SetPlayerCheckpoint(i, X, Y, Z, 5);
					GameTextForPlayer(i, szMiscArray, 1500, 6);
					MedicCallTime[i] += 1;
				}
			}
			if(MechanicCallTime[i] > 0)
			{
				if(MechanicCallTime[i] == 30) { MechanicCallTime[i] = 0; DisablePlayerCheckpoint(i); PlayerPlaySound(i, 1056, 0.0, 0.0, 0.0); GameTextForPlayer(i, "~r~RedMarker gone", 2500, 1); }
				else
				{
					format(szMiscArray, sizeof(szMiscArray), "%d", 30 - MechanicCallTime[i]);
					GameTextForPlayer(i, szMiscArray, 1500, 6);
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
					ClearAnimationsEx(i);
					new Float:X, Float:Y, Float:Z;
					GetPlayerPos(i, X, Y, Z);
					SetPlayerPos(i, X, Y, Z);
					SetPlayerDrunkLevel(i, 0);
				}
				else
				{
					if(playerTabbed[i] == 0)
					{
						PlayerCuffedTime[i] -= 1;
						SetPlayerDrunkLevel(i, 10000);
					}
				}
			}
			if(PlayerCuffed[i] == 2)
			{
				if(PlayerCuffedTime[i] <= 0)
				{
					new Float:X, Float:Y, Float:Z;
					GetPlayerPos(i, X, Y, Z);
					new copinrange;
					foreach(new j: Player)
					{
						if(IsPlayerInRangeOfPoint(j, 15, X, Y, Z) && IsACop(j))
						{
							copinrange = 1;
						}
					}

					if(copinrange == 0)
					{
						//Frozen[i] = 0;
						DeletePVar(i, "IsFrozen");
						GameTextForPlayer(i, "~r~No-one is looking, run!", 2500, 3);
						TogglePlayerControllable(i, 1);
						PlayerCuffed[i] = 3;
						//SetHealth(i, GetPVarFloat(i, "cuffhealth"));
						//SetArmour(i, GetPVarFloat(i, "cuffarmor"));
						//DeletePVar(i, "cuffhealth");
						//DeletePVar(i, "PlayerCuffed");
						PlayerCuffedTime[i] = 180;
						//SetPlayerSpecialAction(i, SPECIAL_ACTION_NONE);
						//ClearAnimationsEx(i);
					}
					else
					{
						PlayerCuffedTime[i] = 60;
					}
				}
				else
				{
					if(playerTabbed[i] == 0)
					{
						PlayerCuffedTime[i] -= 1;
					}
				}
			}
			if(PlayerCuffed[i] == 3)
			{
				new Float:X, Float:Y, Float:Z;
				GetPlayerPos(i, X, Y, Z);
				new copinrange;
				foreach(new j: Player)
				{
					if(IsPlayerInRangeOfPoint(j, 4, X, Y, Z) && IsACop(j))
					{
						copinrange = 1;
					}
				}

				if(copinrange == 1) {
					TogglePlayerControllable(i, 0);
					PlayerCuffed[i] = 2;
					GameTextForPlayer(i, "~r~They caught you again!", 2500, 3);
				}

				if(PlayerCuffedTime[i] <= 0)
				{

					if(copinrange == 0)
					{
						//Frozen[i] = 0;
						DeletePVar(i, "IsFrozen");
						GameTextForPlayer(i, "~r~The cuffs broke!", 2500, 3);
						TogglePlayerControllable(i, 1);
						PlayerCuffed[i] = 0;
						SetHealth(i, GetPVarFloat(i, "cuffhealth"));
						SetArmour(i, GetPVarFloat(i, "cuffarmor"));
						DeletePVar(i, "cuffhealth");
						DeletePVar(i, "PlayerCuffed");
						PlayerCuffedTime[i] = 0;
						SetPlayerSpecialAction(i, SPECIAL_ACTION_NONE);
						ClearAnimationsEx(i);
					}
				}
				else
				{
					if(playerTabbed[i] == 0)
					{
						if(copinrange == 0) PlayerCuffedTime[i] -= 1;
					}
				}
			}
			UpdateSpeedCamerasForPlayer(i);
		}

		if (GetPVarInt(i, "_BoxingQueue") == 1)
		{
			SetPVarInt(i, "_BoxingQueueTick", GetPVarInt(i, "_BoxingQueueTick") + 1);
			new tick = GetPVarInt(i, "_BoxingQueueTick");

			if (tick == 10)
			{
				SetPVarInt(i, "_BoxingQueueTick", 1);

				foreach(new ii: Player)
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

								GetHealth(i, health);
								GetArmour(i, armour);
								SetPVarFloat(i, "_BoxingCacheHP", health);
								SetPVarFloat(i, "_BoxingCacheArmour", armour);

								GetHealth(ii, health);
								GetArmour(ii, armour);
								SetPVarFloat(ii, "_BoxingCacheHP", health);
								SetPVarFloat(ii, "_BoxingCacheArmour", armour);

								SetHealth(i, 100.0);
								SetHealth(ii, 100.0);
								RemoveArmor(i);
								RemoveArmor(ii);

								ResetPlayerWeapons(i);
								ResetPlayerWeapons(ii);

								TogglePlayerControllable(i, 0);
								TogglePlayerControllable(ii, 0);

								SetPVarInt(i, "_BoxingFight", ii + 1);
								SetPVarInt(ii, "_BoxingFight", i + 1);
								SetPVarInt(i, "_BoxingFightCountdown", 4);

								format(szMiscArray, sizeof(szMiscArray), "You are now in a boxing match with %s.", GetPlayerNameEx(ii));
								SendClientMessageEx(i, COLOR_WHITE, szMiscArray);
								format(szMiscArray, sizeof(szMiscArray), "You are now in a boxing match with %s.", GetPlayerNameEx(i));
								SendClientMessageEx(ii, COLOR_WHITE, szMiscArray);
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

								GetHealth(i, health);
								GetArmour(i, armour);
								SetPVarFloat(i, "_BoxingCacheHP", health);
								SetPVarFloat(i, "_BoxingCacheArmour", armour);

								GetHealth(ii, health);
								GetArmour(ii, armour);
								SetPVarFloat(ii, "_BoxingCacheHP", health);
								SetPVarFloat(ii, "_BoxingCacheArmour", armour);

								ResetPlayerWeapons(i);
								ResetPlayerWeapons(ii);

								SetHealth(i, 100.0);
								SetHealth(ii, 100.0);
								RemoveArmor(i);
								RemoveArmor(ii);

								TogglePlayerControllable(i, 0);
								TogglePlayerControllable(ii, 0);

								SetPVarInt(i, "_BoxingFight", ii + 1);
								SetPVarInt(ii, "_BoxingFight", i + 1);
								SetPVarInt(i, "_BoxingFightCountdown", 4);

								format(szMiscArray, sizeof(szMiscArray), "You are now in a boxing match with %s.", GetPlayerNameEx(ii));
								SendClientMessageEx(i, COLOR_WHITE, szMiscArray);
								format(szMiscArray, sizeof(szMiscArray), "You are now in a boxing match with %s.", GetPlayerNameEx(i));
								SendClientMessageEx(ii, COLOR_WHITE, szMiscArray);
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
		if(GetPVarInt(i, "_BoxingFightOver") != 0 && gettime() >= GetPVarInt(i, "_BoxingFightOver"))
		{
			if (GetPVarInt(i, "Injured") == 1)
			{
				KillEMSQueue(i);
				ClearAnimationsEx(i);
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
	        else SetPlayerPos(i, 2907.50, -2275.39, 7.25);

			SetHealth(i, GetPVarFloat(i, "_BoxingCacheHP"));
			SetArmour(i, GetPVarFloat(i, "_BoxingCacheArmour"));
			DeletePVar(i, "_BoxingCacheHP");
			DeletePVar(i, "_BoxingCacheArmour");
			DeletePVar(i, "_BoxingFightOver");
			SetPlayerWeapons(i);
		}
		if(GetPVarInt(i, "BackpackDisabled") > 0) SetPVarInt(i, "BackpackDisabled", GetPVarInt(i, "BackpackDisabled")-1);
		else DeletePVar(i, "BackpackDisabled");

		// ServerHeartBeatTwo (merged by Jingles)
		if(IsPlayerInAnyVehicle(i)) {
			if(GetPlayerState(i) == PLAYER_STATE_DRIVER) SetPlayerArmedWeapon(i, 0);
			else if(!IsADriveByWeapon(GetPlayerWeapon(i)) && !IsADriveByWeapon(GetPVarInt(i, "LastWeapon"))) SetPlayerArmedWeapon(i,0);
		}
		if(GetPlayerSpecialAction(i) == SPECIAL_ACTION_USEJETPACK && JetPack[i] == 0 && PlayerInfo[i][pAdmin] < 4)
		{
			if(GetPVarType(i, "Autoban")) return 1;
			SetPVarInt(i, "Autoban", 1);
			CreateBan(INVALID_PLAYER_ID, PlayerInfo[i][pId], i, PlayerInfo[i][pIP], "Jetpack Hacking", 180);
			TotalAutoBan++;
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

					format(szMiscArray, sizeof(szMiscArray), "* %s's phone rings.", GetPlayerNameEx(Mobile[i]));
					RingTone[Mobile[i]] = 10;
					ProxDetector(30.0, Mobile[i], szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				}
			}
		}

		if(CellTime[i] == 0 && CallCost[i] > 0)
		{
			format(szMiscArray, sizeof(szMiscArray), "~w~The call cost~n~~r~$%d",CallCost[i]);
			GivePlayerCash(i, -CallCost[i]);
			GameTextForPlayer(i, szMiscArray, 5000, 1);
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

					format(szMiscArray, sizeof(szMiscArray), "~w~Passenger left~n~~g~Earned $%d", TransportCost[i]);
					GameTextForPlayer(TransportDriver[i], szMiscArray, 5000, 1);
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
			format(szMiscArray, sizeof(szMiscArray), "~r~%d ~w~: ~g~$%d",TransportTime[i],TransportCost[i]);
			GameTextForPlayer(i, szMiscArray, 15000, 6);
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
return 1;
}

// Timer Name: SyncUp()
// TickRate: 1 Minute.
task SyncUp[60000]()
{
	foreach(new i: Player)
	{
		SyncMinTime(i);

		if(PlayerInfo[i][pDedicatedWarn] > 0)
		{
			PlayerInfo[i][pDedicatedWarn]--;
		}
		DeliverVehicleTimer(i);
		RentVehicleTimer(i);
		SetPlayerScore(i, PlayerInfo[i][pLevel]); 
		if(GetPVarInt(i, "TempLevel") > 0) { SetPlayerScore(i, GetPVarInt(i, "TempLevel")); } 
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
			GetHealth(i, health);
			SetHealth(i, health - 10.0);
			SendClientMessageEx(i, COLOR_LIGHTBLUE, "* Lost 10 health due to virus.");
			SendClientMessageEx(i, COLOR_LIGHTBLUE, "* Seek a medic to cure you!");
		}
		#endif
		switch(GetPVarInt(i, "STD")) {
			case 1: {
				new Float: health;
				GetHealth(i, health);
				SetHealth(i, health - 5.0);
				SendClientMessageEx(i, COLOR_LIGHTBLUE, "* Lost 4 health due to STD.");
			}
			case 2: {
				new Float: health;
				GetHealth(i, health);
				SetHealth(i, health - 12.0);
				SendClientMessageEx(i, COLOR_LIGHTBLUE, "* Lost 8 health due to STD.");
			}
			case 3: {
				new Float: health;
				GetHealth(i, health);
				SetHealth(i, health - 20.0);
				SendClientMessageEx(i, COLOR_LIGHTBLUE, "* Lost 12 health due to STD.");
			}
		}
		if(GetPlayerCash(i) < 0) {
			if(!GetPVarType(i, "debtMsg")) {
				format(szMiscArray, sizeof(szMiscArray), "You're now in debt; you must repay the debt of $%s. If not, you will be arrested...", number_format(GetPlayerCash(i)));
				SendClientMessageEx(i, COLOR_LIGHTRED, szMiscArray);
				SetPVarInt(i, "debtMsg", 1);
			}
		}
		else DeletePVar(i, "debtMsg");

		if(PlayerInfo[i][mPurchaseCount][1] && --PlayerInfo[i][mCooldown][1] <= 0)
		{
			format(szMiscArray, sizeof(szMiscArray), "Your Job Boost has expired! Reset Info: Job: %s | Skill: %d (Level: %d)", GetJobName(PlayerInfo[i][mBoost][0]), PlayerInfo[i][mBoost][1], GetJobLevel(i, PlayerInfo[i][mBoost][0]));
			SendClientMessageEx(i, COLOR_GREY, szMiscArray);
			format(szMiscArray, sizeof(szMiscArray), "[JOBBOOST - Expired] %s(%d) Job: %s (%d) Skill: %d (%d)", GetPlayerNameEx(i), GetPlayerSQLId(i), GetJobName(PlayerInfo[i][mBoost][0]), PlayerInfo[i][mBoost][0], PlayerInfo[i][mBoost][1], GetJobLevel(i, PlayerInfo[i][mBoost][0]));
			Log("logs/micro.log", szMiscArray);
			new skill;
			switch(PlayerInfo[i][mBoost][0])
			{
				case 1: skill = pInfo:pDetSkill;
				case 2: skill = pInfo:pLawSkill;
				case 3: skill = pInfo:pSexSkill;
				case 4: skill = pInfo:pDrugsSkill;
				case 7: skill = pInfo:pMechSkill;
				case 9: skill = pInfo:pArmsSkill;
				case 12: skill = pInfo:pBoxSkill;
				case 20: skill = pInfo:pTruckSkill;
			}
			PlayerInfo[i][pInfo:skill] = PlayerInfo[i][mBoost][1];
			PlayerInfo[i][mPurchaseCount][1] = 0;
			PlayerInfo[i][mCooldown][1] = 0;
			PlayerInfo[i][mBoost][0] = 0;
			PlayerInfo[i][mBoost][1] = 0;
		}
		if(PlayerInfo[i][mCooldown][4] && --PlayerInfo[i][mCooldown][4] <= 0)
		{
			SendClientMessageEx(i, COLOR_GREY, "Your Energy Bar has expired!");
			PlayerInfo[i][mCooldown][4] = 0;
		}
		if(PlayerInfo[i][mPurchaseCount][12] && --PlayerInfo[i][mCooldown][12] <= 0)
		{
			SendClientMessageEx(i, COLOR_GREY, "Your Quick Bank Access has expired!");
			PlayerInfo[i][mPurchaseCount][12] = 0;
			PlayerInfo[i][mCooldown][12] = 0;
		}
		if(PlayerInfo[i][pBuddyInvited] == 1 && --PlayerInfo[i][pTempVIP] <= 0)
		{
			PlayerInfo[i][pTempVIP] = 0;
			PlayerInfo[i][pBuddyInvited] = 0;
			PlayerInfo[i][pDonateRank] = 0;
			SendClientMessageEx(i, COLOR_LIGHTBLUE, "Your temporary VIP subscription has expired.");
			SetPlayerToTeamColor(i);
		}
		/*if(PlayerInfo[i][pBuddyInvited] == 1 && PlayerInfo[i][pTempVIP] == 15 && !PlayerInfo[i][pShopNotice])
		{
			PlayerTextDrawSetString(i, MicroNotice[i], ShopMsg[4]);
			PlayerTextDrawShow(i, MicroNotice[i]);
			SetTimerEx("HidePlayerTextDraw", 10000, false, "ii", i, _:MicroNotice[i]);
		}*/
	}
}
// Player Task Name: AFKUpdate()
// TickRate: 10 Secs.
ptask AFKUpdate[10000](i)
{
	if(Iter_Count(Player) > MAX_PLAYERS - 100)
	{
		if((playerTabbed[i] > 300 || playerAFK[i] > 300) && PlayerInfo[i][pShopTech] < 1 && PlayerInfo[i][pAdmin] < 4)
		{
			Kick(i);
		}
	}
	return 1;
}

// Timer Name: SaveAccountsUpdate()
// TickRate: 5 Minutes.
task SaveAccountsUpdate[900000]()
{
	foreach(new i: Player)
	{
		if(gPlayerLogged{i}) {
			SetPVarInt(i, "AccountSaving", 1);
			OnPlayerStatsUpdate(i);
			break; // We only need to save one person at a time.
		}
	}
}

ptask PlayerUpdate[1000](i) {

	if(gPlayerLogged{i})
	{
		if(IsSpawned[i] == 0 && PlayerInfo[i][pAdmin] < 1337)
		{
			SpawnKick[i]++;
			if(SpawnKick[i] >= 120)
			{
				IsSpawned[i] = 1;
				SpawnKick[i] = 0;
				new string[128];
				SendClientMessageEx(i, COLOR_WHITE, "SERVER: You have been kicked for being AFK.");
				format(string, sizeof(string), " %s(%d) (ID: %d) (IP: %s) has been kicked for not being spawned over 2 minutes.", GetPlayerNameEx(i), GetPlayerSQLId(i), i, GetPlayerIpEx(i));
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
			foreach(new j: Player)
			{
				if(ProxDetectorS(4.0, i, j) && IsACop(j) && j != i)
				{
					copcount++;
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
					if(GetPVarInt(i, "TackledResisting") == 2 && copcount <= 2 && GetPVarInt(i, "TackleCooldown") < 12) // resisting
					{
						new escapechance = random(100);
						switch(escapechance)
						{
							case 35,40,22,72,11..16, 62..64:
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
					else if(GetPVarInt(i, "TackledResisting") == 2 && copcount <= 3 && GetPVarInt(i, "TackleCooldown") < 12) // resisting
					{
						new escapechance = random(100);
						switch(escapechance)
						{
							case 35,40,22,62:
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
				ShowPlayerDialogEx(i, -1, DIALOG_STYLE_LIST, "Close", "Close", "Close", "Close");
				ClearTackle(i);
			}
		}
		if(GetPVarInt(i, "CopTackleCooldown") > 0)
		{
			SetPVarInt(i, "CopTackleCooldown", GetPVarInt(i, "CopTackleCooldown")-1);
		}
		if(GetPVarInt(i, "CantBeTackledCount") > 0)
		{
			SetPVarInt(i, "CantBeTackledCount", GetPVarInt(i, "CantBeTackledCount")-1);
		}
		if(PlayerInfo[i][pCash] != GetPlayerMoney(i))
		{
			ResetPlayerMoney(i);
			GivePlayerMoney(i, PlayerInfo[i][pCash]);
		}
		if(PlayerInfo[i][pGPS] > 0 && GetPVarType(i, "gpsonoff"))
		{
			new zone[28];
			GetPlayer3DZone(i, zone, MAX_ZONE_NAME);
			PlayerTextDrawSetString(i, GPS[i], zone);
		}
		if(GetPVarType(i, "Injured")) SetPlayerArmedWeapon(i, 0);
		if(GetPVarType(i, "IsFrozen")) TogglePlayerControllable(i, 0);
		if(PlayerCuffed[i] > 1) {
			SetHealth(i, 1000);
			SetArmour(i, GetPVarFloat(i, "cuffarmor"));
		}
		if(IsPlayerInAnyVehicle(i) && TruckUsed[i] != INVALID_VEHICLE_ID)
		{
			if(TruckUsed[i] == GetPlayerVehicleID(i) && GetPVarInt(i, "Gas_TrailerID") != 0)
			{
				if((0 <= TruckDeliveringTo[TruckUsed[i]] < MAX_BUSINESSES) && Businesses[TruckDeliveringTo[TruckUsed[i]]][bType] == BUSINESS_TYPE_GASSTATION)
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
				} else {
					CancelTruckDelivery(i);
					SendClientMessageEx(i, COLOR_REALRED, "There was an issue with the delivery unknown bussiness specified.");
				}
			}
		}
	}
}

// Timer Name: EMSUpdate()
// TickRate: 5 secs.
ptask EMSUpdate[5000](i) {
	
	if(GetPlayerVirtualWorld(i) < 6000) TextDrawHideForPlayer(i, g_tHouseLights);
	if(GetPVarType(i, "Injured"))
	{
		#if defined zombiemode
		if(zombieevent == 1 && GetPVarType(i, "pZombieBit"))
		{
			KillEMSQueue(i);
			ClearAnimationsEx(i);
			MakeZombie(i);
		}
		#endif
		if(GetPVarInt(i, "EMSAttempt") != 0)
		{

			new Float:health;
			GetHealth(i,health);
			if(PlayerInfo[i][mCooldown][4])
			{
				if(!GetPVarType(i, "_energybar")) SetPVarInt(i, "_energybar", 60);
				if(GetPVarType(i, "_energybar") && GetPVarInt(i, "_energybar")) SetPVarInt(i, "_energybar", GetPVarInt(i, "_energybar")-1);
				else SetHealth(i, health-1);
			}
			else SetHealth(i, health-1);
			if(GetPVarInt(i, "EMSAttempt") == -1)
			{
				// if(GetPlayerAnimationIndex(i) != 746) ClearAnimationsEx(i), PlayDeathAnimation(i);
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
				// if(GetPlayerAnimationIndex(i) != 746) ClearAnimationsEx(i), PlayDeathAnimation(i);
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

			GetHealth(i, health);
			if(health <= 5)
			{
				SendClientMessageEx(i, COLOR_WHITE, "You fell unconscious, you were immediately sent to the hospital.");
				KillEMSQueue(i);
				SpawnPlayer(i);
			}
		}
	}
}

// Timer Name: PlayerMicroBeat()
// TickRate: 500ms
ptask PlayerMicroBeat[500](i) {

    static
		Float: fExpHealth,
		Float: fCurrentSpeed,
		Float: fVehicleHealth,
		iVehicle,
		//szSpeed[42],
		arrVehParams[7];

	if(_vhudVisible[i] == 1 && !IsPlayerInAnyVehicle(i))
	{
		HideVehicleHUDForPlayer(i);
	}

	switch(GetPlayerState(i))
	{
		case PLAYER_STATE_DRIVER:
		{
			iVehicle = GetPlayerVehicleID(i);
			GetVehicleHealth(iVehicle, fVehicleHealth);
			fCurrentSpeed = player_get_speed(i);

			if(arr_Towing[i] != INVALID_VEHICLE_ID) {
				if(GetVehicleModel(arr_Towing[i]) && IsVehicleStreamedIn(arr_Towing[i], i)) AttachTrailerToVehicle(arr_Towing[i], iVehicle);
				else arr_Towing[i] = INVALID_VEHICLE_ID;
			}

			if(fCurrentSpeed >= 40 && 60 <= fCurrentSpeed)
			{
				if(PlayerInfo[i][pAdmin] <= 1 && !IsABoat(iVehicle)) switch(Seatbelt[i]) {
					case 0: if((fVehSpeed[i] - fCurrentSpeed > 40.0) && (fVehHealth[i] - fExpHealth > 0)) GetHealth(i, fExpHealth), SetHealth(i, fExpHealth - (fVehSpeed[i] - fCurrentSpeed) / 3.0);
					default: if((fVehSpeed[i] - fCurrentSpeed > 40.0) && (fVehHealth[i] - fExpHealth > 0)) GetHealth(i, fExpHealth), SetHealth(i, fExpHealth - ((fVehSpeed[i] - fCurrentSpeed) / 6.0));
				}
			}
			else
			{
				if(PlayerInfo[i][pAdmin] <= 1 && !IsABoat(iVehicle)) switch(Seatbelt[i]) {
					case 0: if((fVehSpeed[i] - fCurrentSpeed > 50.0) && (fVehHealth[i] - fExpHealth > 0)) GetHealth(i, fExpHealth), SetHealth(i, fExpHealth - (fVehSpeed[i] - fCurrentSpeed) / 3.0);
					default: if((fVehSpeed[i] - fCurrentSpeed > 50.0) && (fVehHealth[i] - fExpHealth > 0)) GetHealth(i, fExpHealth), SetHealth(i, fExpHealth - ((fVehSpeed[i] - fCurrentSpeed) / 6.0));
				}
			}

			fVehSpeed[i] = fCurrentSpeed;
			fVehHealth[i] = fVehicleHealth;

			if(fVehicleHealth < 350.0)
			{
				SetVehicleHealth(iVehicle, 251.0);
				GetVehicleParamsEx(iVehicle, arrVehParams[0], arrVehParams[1], arrVehParams[2], arrVehParams[3], arrVehParams[4], arrVehParams[5], arrVehParams[6]);
				if(arrVehParams[0] == VEHICLE_PARAMS_ON)
				{
					SetVehicleParamsEx(iVehicle,VEHICLE_PARAMS_OFF, arrVehParams[1], arrVehParams[2], arrVehParams[3], arrVehParams[4], arrVehParams[5], arrVehParams[6]);
					/*if(!PlayerInfo[i][pShopNotice])
					{
						PlayerTextDrawSetString(i, MicroNotice[i], ShopMsg[8]);
						PlayerTextDrawShow(i, MicroNotice[i]);
						SetTimerEx("HidePlayerTextDraw", 10000, false, "ii", i, _:MicroNotice[i]);
					}*/
				}
				GameTextForPlayer(i, "~r~Totalled!", 2500, 3);
				arr_Engine{iVehicle} = 0;
			}
			else if(PlayerInfo[i][pSpeedo] != 0) {
				UpdateVehicleHUDForPlayer(i, floatround(VehicleFuel[iVehicle]), floatround(fCurrentSpeed));
			}
		}
		case PLAYER_STATE_PASSENGER:
		{
			iVehicle = GetPlayerVehicleID(i);
			GetVehicleHealth(iVehicle,fExpHealth);
			fCurrentSpeed = player_get_speed(i);
			if(PlayerInfo[i][pSpeedo] != 0) {
				UpdateVehicleHUDForPlayer(i, floatround(VehicleFuel[iVehicle]), floatround(fCurrentSpeed));
			}
			if(fCurrentSpeed >= 40 && 60 <= fCurrentSpeed)
			{
				if(PlayerInfo[i][pAdmin] <= 1 && !IsABoat(iVehicle)) switch(Seatbelt[i]) {
					case 0: if((fVehSpeed[i] - fCurrentSpeed > 40.0) && (fVehHealth[i] - fExpHealth > 0)) GetHealth(i, fExpHealth), SetHealth(i, fExpHealth - (fVehSpeed[i] - fCurrentSpeed) / 1.6);
					default: if((fVehSpeed[i] - fCurrentSpeed > 40.0) && (fVehHealth[i] - fExpHealth > 0)) GetHealth(i, fExpHealth), SetHealth(i, fExpHealth - ((fVehSpeed[i] - fCurrentSpeed) / 3.2));
				}
			}
			else
			{
				if(PlayerInfo[i][pAdmin] <= 1 && !IsABoat(iVehicle)) switch(Seatbelt[i]) {
					case 0: if((fVehSpeed[i] - fCurrentSpeed > 50.0) && (fVehHealth[i] - fExpHealth > 0)) GetHealth(i, fExpHealth), SetHealth(i, fExpHealth - (fVehSpeed[i] - fCurrentSpeed) / 0.8);
					default: if((fVehSpeed[i] - fCurrentSpeed > 50.0) && (fVehHealth[i] - fExpHealth > 0)) GetHealth(i, fExpHealth), SetHealth(i, fExpHealth - ((fVehSpeed[i] - fCurrentSpeed) / 1.6));
				}
			}

			fVehSpeed[i] = fCurrentSpeed;
			fVehHealth[i] = fExpHealth;
		}
	}
	if(GetPVarType(i, "pDTest")) DrivingSchoolSpeedMeter(i, player_get_speed(i));
}

// Task Name: fpsCounterUpdate
ptask fpsCounterUpdate[500](i)
{
	if(Bit_State(arrPlayerBits[i], bitFPS)) {

		format(szMiscArray, sizeof(szMiscArray), "%d", pFPS[i]);
		PlayerTextDrawSetString(i, pFPSCounter[i], szMiscArray);
	}
	return 1;
}

// Timer Name: ShopItemQueue()
// TickRate: 60 seconds
ptask ShopItemQueue[60000](i)
{
	szMiscArray[0] = 0;
	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "SELECT * FROM `shop_orders` WHERE `user_id` = %d AND `status` = 0", GetPlayerSQLId(i));
	mysql_tquery(MainPipeline, szMiscArray, "ExecuteShopQueue", "ii", i, 0);

	if(ShopToggle == 1)
	{
		mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "SELECT * FROM `order_delivery_status` WHERE `player_id` = %d AND `status` = 0", GetPlayerSQLId(i));
		mysql_tquery(ShopPipeline, szMiscArray, "ExecuteShopQueue", "ii", i, 1);
	}
}
