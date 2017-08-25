/*
    	 		 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
				| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
				| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
				| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
				| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
				| $$\  $$$| $$  \ $$        | $$  \ $$| $$
				| $$ \  $$|  $$$$$$/        | $$  | $$| $$
				|__/  \__/ \______/         |__/  |__/|__/

//--------------------------------[MYSQL.PWN]--------------------------------


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

stock SQLUpdateBuild(query[], table[], sqlplayerid)
{
	new querylen = strlen(query);
	if (!query[0]) {
		format(query, 2048, "UPDATE `%s` SET ", table);
	}
	else if (2048-querylen < 200)
	{
		new whereclause[32];
		format(whereclause, sizeof(whereclause), " WHERE `id`=%d", sqlplayerid);
		strcat(query, whereclause, 2048);
		mysql_tquery(MainPipeline, query, "OnQueryFinish", "i", SENDDATA_THREAD);
		format(query, 2048, "UPDATE `%s` SET ", table);
	}
	else if (strfind(query, "=", true) != -1) strcat(query, ",", 2048);
	return 1;
}

stock SQLUpdateFinish(query[], table[], sqlplayerid)
{
	if (strcmp(query, "WHERE id=", false) == 0) mysql_tquery(MainPipeline, query, "OnQueryFinish", "i", SENDDATA_THREAD);
	else
	{
		new whereclause[32];
		format(whereclause, sizeof(whereclause), " WHERE id=%d", sqlplayerid);
		strcat(query, whereclause, 2048);
		mysql_tquery(MainPipeline, query, "OnQueryFinish", "i", SENDDATA_THREAD);
		format(query, 2048, "UPDATE `%s` SET ", table);
	}
	return 1;
}

stock SaveInteger(query[], table[], sqlid, Value[], Integer)
{
	SQLUpdateBuild(query, table, sqlid);
	new updval[64];
	format(updval, sizeof(updval), "`%s`=%d", Value, Integer);
	strcat(query, updval, 2048);
	return 1;
}


stock SaveString(query[], table[], sqlid, Value[], String[])
{
	SQLUpdateBuild(query, table, sqlid);
	new escapedstring[160], string[160];
	mysql_escape_string(String, escapedstring);
	format(string, sizeof(string), "`%s`='%s'", Value, escapedstring);
	strcat(query, string, 2048);
	return 1;
}

stock SaveFloat(query[], table[], sqlid, Value[], Float:Number)
{
	new flotostr[32];
	format(flotostr, sizeof(flotostr), "%0.2f", Number);
	SaveString(query, table, sqlid, Value, flotostr);
	return 1;
}

//--------------------------------[ FUNCTIONS ]---------------------------

PinLogin(playerid)
{
    new string[128];
    mysql_format(MainPipeline, string, sizeof(string), "SELECT `Pin` FROM `accounts` WHERE `id` = %d", GetPlayerSQLId(playerid));
	mysql_tquery(MainPipeline, string, "OnPinCheck", "i", playerid);
	return 1;
}

//--------------------------------[ INITIATE/EXIT ]---------------------------

// g_mysql_Init()
// Description: Called with Gamemode Init.
stock g_mysql_Init()
{
	new SQL_HOST[64], SQL_DB[64], SQL_USER[32], SQL_PASS[128], SQL_DEBUG, SQL_DEBUGLOG;
	new SQL_SHOST[64], SQL_SDB[64], SQL_SUSER[32], SQL_SPASS[128];
	new fileString[128], File: fileHandle = fopen("mysql.cfg", io_read);

	while(fread(fileHandle, fileString, sizeof(fileString))) {
		if(ini_GetValue(fileString, "HOST", SQL_HOST, sizeof(SQL_HOST))) continue;
		if(ini_GetValue(fileString, "DB", SQL_DB, sizeof(SQL_DB))) continue;
		if(ini_GetValue(fileString, "USER", SQL_USER, sizeof(SQL_USER))) continue;
		if(ini_GetValue(fileString, "PASS", SQL_PASS, sizeof(SQL_PASS))) continue;
		if(ini_GetInt(fileString, "SHOPAUTOMATED", ShopToggle)) continue;
		if(ini_GetValue(fileString, "SHOST", SQL_SHOST, sizeof(SQL_SHOST))) continue;
		if(ini_GetValue(fileString, "SDB", SQL_SDB, sizeof(SQL_SDB))) continue;
		if(ini_GetValue(fileString, "SUSER", SQL_SUSER, sizeof(SQL_SUSER))) continue;
		if(ini_GetValue(fileString, "SPASS", SQL_SPASS, sizeof(SQL_SPASS))) continue;
		if(ini_GetInt(fileString, "SERVER", servernumber)) continue;
		if(ini_GetInt(fileString, "BETASERVER", betaserver)) continue;
		if(ini_GetInt(fileString, "DEBUG", SQL_DEBUG)) continue;
		if(ini_GetInt(fileString, "DEBUGLOG", SQL_DEBUGLOG)) continue;
	}
	fclose(fileHandle);

	mysql_log(NONE); // Has to be NONE for some the server will crash (runs out of memory)

	MainPipeline = mysql_connect(SQL_HOST, SQL_USER, SQL_PASS, SQL_DB);

	printf("[MySQL] (Main Pipelines) Connecting to %s...", SQL_HOST);
	if(mysql_errno(MainPipeline) != 0)
	{
		printf("[MySQL] (MainPipeline) Fatal Error! Could not connect to MySQL: Host %s - DB: %s - User: %s", SQL_HOST, SQL_DB, SQL_USER);
		print("[MySQL] Note: Make sure that you have provided the correct connection credentials.");
		printf("[MySQL] Error number: %d", mysql_errno(MainPipeline));
		SendRconCommand("exit");
	}
	else print("[MySQL] (MainPipeline) Connection successful toward MySQL Database Server!");

	if(ShopToggle == 1)
	{
		ShopPipeline = mysql_connect(SQL_SHOST, SQL_SUSER, SQL_SPASS, SQL_SDB);

		printf("[MySQL] (Shop Pipelines) Connecting to %s...", SQL_SHOST);
		if(mysql_errno(ShopPipeline) != 0)
		{
			printf("[MySQL] (ShopPipeline) Fatal Error! Could not connect to MySQL: Host %s - DB: %s - User: %s", SQL_SHOST, SQL_SDB, SQL_SUSER);
			print("[MySQL] Note: Make sure that you have provided the correct connection credentials.");
			printf("[MySQL] Error number: %d", mysql_errno(ShopPipeline));
			//SendRconCommand("exit");
		}
		else print("[MySQL] (ShopPipeline) Connection successful toward MySQL Database Server!");
	}

	InitiateGamemode(); // Start the server

	return 1;
}

// g_mysql_Exit()
// Description: Called with Gamemode Exit.
stock g_mysql_Exit()
{
	mysql_close(MainPipeline);
	if(ShopToggle == 1) mysql_close(ShopPipeline);
	return 1;
}

//--------------------------------[ CALLBACKS ]--------------------------------

forward OnQueryFinish(resultid, extraid, handleid);
public OnQueryFinish(resultid, extraid, handleid)
{
    new rows, fields, value;
    szMiscArray[0] = 0;
	if(resultid != SENDDATA_THREAD) {
		if(extraid != INVALID_PLAYER_ID) {
			if(g_arrQueryHandle{extraid} != -1 && g_arrQueryHandle{extraid} != handleid) return 0;
		}
		cache_get_row_count(rows);
		cache_get_field_count(fields);
	}
	switch(resultid)
	{
	    case LOADSALEDATA_THREAD:
	    {
	        if(rows > 0)
			{
                for(new i;i < rows;i++)
				{
			    	new szResult[32], szField[15];
			    	for(new z = 0; z < MAX_ITEMS; z++)
					{
						format(szField, sizeof(szField), "TotalSold%d", z);
						cache_get_value_name(i, szField, szResult);
                        AmountSold[z] = strval(szResult);
						//ShopItems[z][sSold] = strval(szResult);


						format(szField, sizeof(szField), "AmountMade%d", z);
						cache_get_value_name(i,  szField, szResult);
						AmountMade[z] = strval(szResult);
						//ShopItems[z][sMade] = strval(szResult);
						printf("TotalSold%d: %d | AmountMade%d: %d", z, AmountSold[z], z, AmountMade[z]);
					}
					new result[128];
					cache_get_value_name(i, "TotalSoldMicro", result);
					sscanf(result, MicroSpecifier, AmountSoldMicro);
					cache_get_value_name(i, "AmountMadeMicro", result);
					sscanf(result, MicroSpecifier, AmountMadeMicro);
					for(new m = 0; m < MAX_MICROITEMS; m++)
					{
						printf("TotalSoldMicro%d: %d | AmountMadeMicro%d: %d", m, AmountSoldMicro[m], m, AmountMadeMicro[m]);
					}
					break;
				}
			}
			else
			{
				mysql_tquery(MainPipeline, "INSERT INTO `sales` (`Month`) VALUES (NOW())", "OnQueryFinish", "i", SENDDATA_THREAD);
				mysql_tquery(MainPipeline, "SELECT * FROM `sales` WHERE `Month` > NOW() - INTERVAL 1 MONTH", "OnQueryFinish", "iii", LOADSALEDATA_THREAD, INVALID_PLAYER_ID, -1);
				print("[LOADSALEDATA] Inserted new row into `sales`");
			}
	    }
	    case LOADSHOPDATA_THREAD:
	    {
	        for(new i;i < rows;i++)
			{
	        	new szResult[32], szField[14];
	        	for(new z = 0; z < MAX_ITEMS; z++)
				{
					format(szField, sizeof(szField), "Price%d", z);
					cache_get_value_name(i,  szField, szResult);
					ShopItems[z][sItemPrice] = strval(szResult);
					Price[z] = strval(szResult);
					if(ShopItems[z][sItemPrice] == 0) ShopItems[z][sItemPrice] = 99999999;
					printf("Price%d: %d", z, ShopItems[z][sItemPrice]);
				}
				new result[128];
				cache_get_value_name(i, "MicroPrices", result);
				sscanf(result, MicroSpecifier, MicroItems);
				for(new m = 0; m < MAX_MICROITEMS; m++)
				{
					if(MicroItems[m] == 0) MicroItems[m] = 99999999;
					printf("MicroPrice%d: %d", m, MicroItems[m]);
				}
                //printf("[LOADSHOPDATA] Price0: %d, Price1: %d, Price2: %d, Price3: %d, Price4: %d, Price5: %d, Price6: %d, Price7: %d, Pricr8: %d, Price9: %d, Price10: %d", Price[0], Price[1], Price[2], Price[3], Price[4], Price[5], Price[6], Price[7], Price[8], Price[9], Price[10]);
				break;
			}
	    }
		case LOADMOTDDATA_THREAD:
		{
   			for(new i;i < rows;i++)
			{
			    new szResult[32];
   				cache_get_value_name(i, "gMOTD", GlobalMOTD);
				cache_get_value_name(i, "aMOTD", AdminMOTD);
				cache_get_value_name(i, "vMOTD", VIPMOTD);
				cache_get_value_name(i, "cMOTD", CAMOTD);
				cache_get_value_name(i, "pMOTD", pMOTD);
				cache_get_value_name_float(i, "ShopTechPay", ShopTechPay);
                cache_get_value_name(i, "GiftCode", GiftCode);
                cache_get_value_name_int(i, "GiftCodeBypass", GiftCodeBypass);
                cache_get_value_name(i, "SecurityCode", SecurityCode);
                cache_get_value_name_int(i, "ShopClosed", ShopClosed);
                cache_get_value_name_int(i, "RimMod", RimMod);
                cache_get_value_name_int(i, "CarVoucher", CarVoucher);
				cache_get_value_name_int(i, "PVIPVoucher", PVIPVoucher);
				cache_get_value_name_int(i, "GarageVW", GarageVW);
				cache_get_value_name_int(i, "PumpkinStock", PumpkinStock);
				cache_get_value_name_int(i, "HalloweenShop", HalloweenShop);
				cache_get_value_name_int(i, "PassComplexCheck", PassComplexCheck);

				cache_get_value_name(i, "prisonerMOTD", prisonerMOTD[0]);
				cache_get_value_name(i, "prisonerMOTD2", prisonerMOTD[1]);
				cache_get_value_name(i, "prisonerMOTD3", prisonerMOTD[2]);

				for(new x = 0; x < 7; x++)
				{
					format(szResult, sizeof(szResult), "GunPrice%d", x);
					cache_get_value_name_int(i, szResult, GunPrices[x]);
				}

				CallLocalFunction("LoadInactiveResourceSettings", "i", i);
				break;
			}
		}
		case LOADUSERDATA_THREAD:
		{
			if(IsPlayerConnected(extraid))
			{
   				new szField[MAX_PLAYER_NAME], szResult[64];

				for(new row;row < rows;row++)
				{
					cache_get_value_name(row, "Username", szField, MAX_PLAYER_NAME);

					if(strcmp(szField, GetPlayerNameExt(extraid), true) != 0)
					{
						return 1;
					}
					cache_get_value_name_int(row,  "id", PlayerInfo[extraid][pId]);
					cache_get_value_name_int(row,  "Online", PlayerInfo[extraid][pOnline]);
					cache_get_value_name(row,  "Email", PlayerInfo[extraid][pEmail]);
					cache_get_value_name(row,  "IP", PlayerInfo[extraid][pIP]);
					cache_get_value_name(row,  "SecureIP", PlayerInfo[extraid][pSecureIP]);
					cache_get_value_name_int(row,  "ConnectedTime", PlayerInfo[extraid][pConnectHours]);
					cache_get_value_name(row,  "BirthDate", PlayerInfo[extraid][pBirthDate]);
					cache_get_value_name_int(row,  "Sex", PlayerInfo[extraid][pSex]);
					cache_get_value_name_int(row,  "Band", PlayerInfo[extraid][pBanned]);
					cache_get_value_name_int(row, "PermBand", PlayerInfo[extraid][pPermaBanned]);
					cache_get_value_name_int(row,  "Registered", PlayerInfo[extraid][pReg]);
					cache_get_value_name_int(row,  "Warnings", PlayerInfo[extraid][pWarns]);
					cache_get_value_name_int(row,  "Disabled", PlayerInfo[extraid][pDisabled]);
					cache_get_value_name_int(row,  "Level", PlayerInfo[extraid][pLevel]);
					cache_get_value_name_int(row,  "AdminLevel", PlayerInfo[extraid][pAdmin]);
					cache_get_value_name_int(row,  "SeniorModerator", PlayerInfo[extraid][pSMod]);
					cache_get_value_name_int(row,  "DonateRank", PlayerInfo[extraid][pDonateRank]);
					cache_get_value_name_int(row,  "Respect", PlayerInfo[extraid][pExp]);
					cache_get_value_name_int(row,  "Money", PlayerInfo[extraid][pCash]);
					cache_get_value_name_int(row,  "Bank", PlayerInfo[extraid][pAccount]);
					cache_get_value_name_float(row,  "pHealth", PlayerInfo[extraid][pHealth]);
					cache_get_value_name_float(row,  "pArmor", PlayerInfo[extraid][pArmor]);
					cache_get_value_name_float(row,  "pSHealth", PlayerInfo[extraid][pSHealth]);
					cache_get_value_name_int(row,  "Int", PlayerInfo[extraid][pInt]);
					cache_get_value_name_int(row,  "VirtualWorld", PlayerInfo[extraid][pVW]);
					cache_get_value_name_int(row,  "Model", PlayerInfo[extraid][pModel]);
					cache_get_value_name_float(row,  "SPos_x", PlayerInfo[extraid][pPos_x]);
					cache_get_value_name_float(row,  "SPos_y", PlayerInfo[extraid][pPos_y]);
					cache_get_value_name_float(row,  "SPos_z", PlayerInfo[extraid][pPos_z]);
					cache_get_value_name_float(row,  "SPos_r", PlayerInfo[extraid][pPos_r]);
					cache_get_value_name_int(row,  "BanAppealer", PlayerInfo[extraid][pBanAppealer]);
					cache_get_value_name_int(row,  "PR", PlayerInfo[extraid][pPR]);
					cache_get_value_name_int(row,  "HR", PlayerInfo[extraid][pHR]);
					cache_get_value_name_int(row,  "AP", PlayerInfo[extraid][pAP]);
					cache_get_value_name_int(row,  "Security", PlayerInfo[extraid][pSecurity]);
					cache_get_value_name_int(row,  "ShopTech", PlayerInfo[extraid][pShopTech]);
					cache_get_value_name_int(row,  "FactionModerator", PlayerInfo[extraid][pFactionModerator]);
					cache_get_value_name_int(row,  "GangModerator", PlayerInfo[extraid][pGangModerator]);
					cache_get_value_name_int(row,  "Undercover", PlayerInfo[extraid][pUndercover]);
					cache_get_value_name_int(row,  "TogReports", PlayerInfo[extraid][pTogReports]);
					cache_get_value_name_int(row,  "Radio", PlayerInfo[extraid][pRadio]);
					cache_get_value_name_int(row,  "RadioFreq", PlayerInfo[extraid][pRadioFreq]);
					cache_get_value_name_int(row,  "UpgradePoints", PlayerInfo[extraid][gPupgrade]);
					cache_get_value_name_int(row,  "Origin", PlayerInfo[extraid][pOrigin]);
					cache_get_value_name_int(row,  "Muted", PlayerInfo[extraid][pMuted]);
					cache_get_value_name_int(row,  "Crimes", PlayerInfo[extraid][pCrimes]);
					cache_get_value_name_int(row,  "Accent", PlayerInfo[extraid][pAccent]);
					cache_get_value_name_int(row,  "CHits", PlayerInfo[extraid][pCHits]);
					cache_get_value_name_int(row,  "FHits", PlayerInfo[extraid][pFHits]);
					cache_get_value_name_int(row,  "Arrested", PlayerInfo[extraid][pArrested]);
					cache_get_value_name_int(row,  "Phonebook", PlayerInfo[extraid][pPhoneBook]);
					cache_get_value_name_int(row,  "LottoNr", PlayerInfo[extraid][pLottoNr]);
					cache_get_value_name_int(row,  "Fishes", PlayerInfo[extraid][pFishes]);
					cache_get_value_name_int(row,  "BiggestFish", PlayerInfo[extraid][pBiggestFish]);
					cache_get_value_name_int(row,  "Job", PlayerInfo[extraid][pJob]);
					cache_get_value_name_int(row,  "Job2", PlayerInfo[extraid][pJob2]);
					cache_get_value_name_int(row,  "Job3", PlayerInfo[extraid][pJob3]);
					cache_get_value_name_int(row,  "Paycheck", PlayerInfo[extraid][pPayCheck]);
					cache_get_value_name_int(row,  "HeadValue", PlayerInfo[extraid][pHeadValue]);
					cache_get_value_name_int(row,  "JailTime", PlayerInfo[extraid][pJailTime]);
					cache_get_value_name_int(row,  "WRestricted", PlayerInfo[extraid][pWRestricted]);
					cache_get_value_name_int(row,  "Materials", PlayerInfo[extraid][pMats]);
					cache_get_value_name_int(row,  "Crates", PlayerInfo[extraid][pCrates]);
					cache_get_value_name_int(row,  "StaffBanned", PlayerInfo[extraid][pStaffBanned]);
					// PlayerInfo[extraid][pPot]					= cache_get_value_name_int(row,  "Pot");
					// PlayerInfo[extraid][pCrack]					= cache_get_value_name_int(row,  "Crack");
					cache_get_value_name_int(row,  "Nation", PlayerInfo[extraid][pNation]);
					cache_get_value_name_int(row,  "Leader", PlayerInfo[extraid][pLeader]);
					cache_get_value_name_int(row,  "Member", PlayerInfo[extraid][pMember]);
					cache_get_value_name_int(row,  "Division", PlayerInfo[extraid][pDivision]);
					cache_get_value_name(row,  "Badge", PlayerInfo[extraid][pBadge]);
					cache_get_value_name_int(row,  "Rank", PlayerInfo[extraid][pRank]);
					cache_get_value_name_int(row,  "DetSkill", PlayerInfo[extraid][pDetSkill]);
					cache_get_value_name_int(row,  "SexSkill", PlayerInfo[extraid][pSexSkill]);
					cache_get_value_name_int(row,  "BoxSkill", PlayerInfo[extraid][pBoxSkill]);
					cache_get_value_name_int(row,  "LawSkill", PlayerInfo[extraid][pLawSkill]);
					cache_get_value_name_int(row,  "MechSkill", PlayerInfo[extraid][pMechSkill]);
					cache_get_value_name_int(row,  "TruckSkill", PlayerInfo[extraid][pTruckSkill]);
					cache_get_value_name_int(row,  "DrugSmuggler", PlayerInfo[extraid][pDrugSmuggler]);
					cache_get_value_name_int(row,  "ArmsSkill", PlayerInfo[extraid][pArmsSkill]);
					cache_get_value_name_int(row,  "FishSkill", PlayerInfo[extraid][pFishSkill]);
					cache_get_value_name_int(row,  "FightingStyle", PlayerInfo[extraid][pFightStyle]);
					cache_get_value_name_int(row,  "PhoneNr", PlayerInfo[extraid][pPnumber]);
					cache_get_value_name_int(row,  "Apartment", PlayerInfo[extraid][pPhousekey]);
					cache_get_value_name_int(row,  "Apartment2", PlayerInfo[extraid][pPhousekey2]);
					cache_get_value_name_int(row,  "Apartment3", PlayerInfo[extraid][pPhousekey3]);
					cache_get_value_name_int(row,  "Renting", PlayerInfo[extraid][pRenting]);
					cache_get_value_name_int(row,  "CarLic", PlayerInfo[extraid][pCarLic]);
					cache_get_value_name_int(row,  "FlyLic", PlayerInfo[extraid][pFlyLic]);
					cache_get_value_name_int(row,  "BoatLic", PlayerInfo[extraid][pBoatLic]);
					cache_get_value_name_int(row,  "FishLic", PlayerInfo[extraid][pFishLic]);
					cache_get_value_name_int(row,  "CheckCash", PlayerInfo[extraid][pCheckCash]);
					cache_get_value_name_int(row,  "Checks", PlayerInfo[extraid][pChecks]);
					cache_get_value_name_int(row,  "GunLic", PlayerInfo[extraid][pGunLic]);

					for(new i = 0; i < 12; i++)
					{
						format(szField, sizeof(szField), "Gun%d", i);
						cache_get_value_name_int(row,  szField, PlayerInfo[extraid][pGuns][i]);
					}

					cache_get_value_name_int(row,  "DrugsTime", PlayerInfo[extraid][pDrugsTime]);
					cache_get_value_name_int(row,  "LawyerTime", PlayerInfo[extraid][pLawyerTime]);
					cache_get_value_name_int(row,  "LawyerFreeTime", PlayerInfo[extraid][pLawyerFreeTime]);
					cache_get_value_name_int(row,  "MechTime", PlayerInfo[extraid][pMechTime]);
					cache_get_value_name_int(row,  "SexTime", PlayerInfo[extraid][pSexTime]);
					cache_get_value_name_int(row,  "PayDay", PlayerInfo[extraid][pConnectSeconds]);
					cache_get_value_name_int(row,  "PayDayHad", PlayerInfo[extraid][pPayDayHad]);
					cache_get_value_name_int(row,  "CDPlayer", PlayerInfo[extraid][pCDPlayer]);
					cache_get_value_name_int(row,  "Dice", PlayerInfo[extraid][pDice]);
					cache_get_value_name_int(row,  "Spraycan", PlayerInfo[extraid][pSpraycan]);
					cache_get_value_name_int(row,  "Rope", PlayerInfo[extraid][pRope]);
					cache_get_value_name_int(row,  "Rags", PlayerInfo[extraid][pRags]);
					cache_get_value_name_int(row,  "Cigars", PlayerInfo[extraid][pCigar]);
					cache_get_value_name_int(row,  "Sprunk", PlayerInfo[extraid][pSprunk]);
					cache_get_value_name_int(row,  "Bombs", PlayerInfo[extraid][pBombs]);
					cache_get_value_name_int(row,  "Wins", PlayerInfo[extraid][pWins]);
					cache_get_value_name_int(row,  "Loses", PlayerInfo[extraid][pLoses]);
					cache_get_value_name_int(row,  "Tutorial", PlayerInfo[extraid][pTut]);
					cache_get_value_name_int(row,  "OnDuty", PlayerInfo[extraid][pDuty]);
					cache_get_value_name_int(row,  "Hospital", PlayerInfo[extraid][pHospital]);
					cache_get_value_name_int(row,  "MarriedID", PlayerInfo[extraid][pMarriedID]);
					cache_get_value_name(row,  "ContractBy", PlayerInfo[extraid][pContractBy]);
					cache_get_value_name(row,  "ContractDetail", PlayerInfo[extraid][pContractDetail]);
					cache_get_value_name_int(row,  "WantedLevel", PlayerInfo[extraid][pWantedLevel]);
					cache_get_value_name_int(row,  "Insurance", PlayerInfo[extraid][pInsurance]);
					cache_get_value_name_int(row,  "911Muted", PlayerInfo[extraid][p911Muted]);
					cache_get_value_name_int(row,  "NewMuted", PlayerInfo[extraid][pNMute]);
					cache_get_value_name_int(row,  "NewMutedTotal", PlayerInfo[extraid][pNMuteTotal]);
					cache_get_value_name_int(row,  "AdMuted", PlayerInfo[extraid][pADMute]);
					cache_get_value_name_int(row,  "AdMutedTotal", PlayerInfo[extraid][pADMuteTotal]);
					cache_get_value_name_int(row,  "HelpMute", PlayerInfo[extraid][pHelpMute]);
					cache_get_value_name_int(row,  "Helper", PlayerInfo[extraid][pHelper]);
					cache_get_value_name_int(row,  "ReportMuted", PlayerInfo[extraid][pRMuted]);
					cache_get_value_name_int(row,  "ReportMutedTotal", PlayerInfo[extraid][pRMutedTotal]);
					cache_get_value_name_int(row,  "ReportMutedTime", PlayerInfo[extraid][pRMutedTime]);
					cache_get_value_name_int(row,  "DMRMuted", PlayerInfo[extraid][pDMRMuted]);
					cache_get_value_name_int(row,  "VIPMuted", PlayerInfo[extraid][pVMuted]);
					cache_get_value_name_int(row,  "VIPMutedTime", PlayerInfo[extraid][pVMutedTime]);
					cache_get_value_name_int(row,  "GiftTime", PlayerInfo[extraid][pGiftTime]);
					cache_get_value_name_int(row,  "AdvisorDutyHours", PlayerInfo[extraid][pDutyHours]);
					cache_get_value_name_int(row,  "AcceptedHelp", PlayerInfo[extraid][pAcceptedHelp]);
					cache_get_value_name_int(row,  "AcceptReport", PlayerInfo[extraid][pAcceptReport]);
					cache_get_value_name_int(row,  "ShopTechOrders", PlayerInfo[extraid][pShopTechOrders]);
					cache_get_value_name_int(row,  "TrashReport", PlayerInfo[extraid][pTrashReport]);
					cache_get_value_name_int(row,  "GangWarn", PlayerInfo[extraid][pGangWarn]);
					cache_get_value_name_int(row,  "CSFBanned", PlayerInfo[extraid][pCSFBanned]);
					cache_get_value_name_int(row,  "VIPInviteDay", PlayerInfo[extraid][pVIPInviteDay]);
					cache_get_value_name_int(row,  "TempVIP", PlayerInfo[extraid][pTempVIP]);
					cache_get_value_name_int(row,  "BuddyInvite", PlayerInfo[extraid][pBuddyInvited]);
					cache_get_value_name_int(row,  "Tokens", PlayerInfo[extraid][pTokens]);
					cache_get_value_name_int(row,  "PTokens", PlayerInfo[extraid][pPaintTokens]);
					cache_get_value_name_int(row,  "TriageTime", PlayerInfo[extraid][pTriageTime]);
					cache_get_value_name(row,  "PrisonedBy", PlayerInfo[extraid][pPrisonedBy]);
					cache_get_value_name(row,  "PrisonReason", PlayerInfo[extraid][pPrisonReason]);
					cache_get_value_name_int(row,  "TaxiLicense", PlayerInfo[extraid][pTaxiLicense]);
					cache_get_value_name_int(row,  "TicketTime", PlayerInfo[extraid][pTicketTime]);
					cache_get_value_name_int(row,  "Screwdriver", PlayerInfo[extraid][pScrewdriver]);
					cache_get_value_name_int(row,  "Smslog", PlayerInfo[extraid][pSmslog]);
					cache_get_value_name_int(row,  "Wristwatch", PlayerInfo[extraid][pWristwatch]);
					cache_get_value_name_int(row,  "Surveillance", PlayerInfo[extraid][pSurveillance]);
					cache_get_value_name_int(row,  "Tire", PlayerInfo[extraid][pTire]);
					cache_get_value_name_int(row,  "Firstaid", PlayerInfo[extraid][pFirstaid]);
					cache_get_value_name_int(row,  "Rccam", PlayerInfo[extraid][pRccam]);
					cache_get_value_name_int(row,  "Receiver", PlayerInfo[extraid][pReceiver]);
					cache_get_value_name_int(row,  "GPS", PlayerInfo[extraid][pGPS]);
					cache_get_value_name_int(row,  "Sweep", PlayerInfo[extraid][pSweep]);
					cache_get_value_name_int(row,  "SweepLeft", PlayerInfo[extraid][pSweepLeft]);
					cache_get_value_name_int(row,  "Bugged", PlayerInfo[extraid][pBugged]);
					cache_get_value_name_int(row,  "pWExists", PlayerInfo[extraid][pWeedObject]);
					cache_get_value_name_int(row,  "pWSeeds", PlayerInfo[extraid][pWSeeds]);
					cache_get_value_name(row,  "Warrants", PlayerInfo[extraid][pWarrant]);
					cache_get_value_name_int(row,  "JudgeJailTime", PlayerInfo[extraid][pJudgeJailTime]);
					cache_get_value_name_int(row,  "JudgeJailType", PlayerInfo[extraid][pJudgeJailType]);
					cache_get_value_name_int(row,  "BeingSentenced", PlayerInfo[extraid][pBeingSentenced]);
					cache_get_value_name_int(row,  "ProbationTime", PlayerInfo[extraid][pProbationTime]);
					cache_get_value_name_int(row,  "DMKills", PlayerInfo[extraid][pDMKills]);
					cache_get_value_name_int(row,  "Order", PlayerInfo[extraid][pOrder]);
					cache_get_value_name_int(row,  "OrderConfirmed", PlayerInfo[extraid][pOrderConfirmed]);
					cache_get_value_name_int(row,  "CallsAccepted", PlayerInfo[extraid][pCallsAccepted]);
					cache_get_value_name_int(row,  "PatientsDelivered", PlayerInfo[extraid][pPatientsDelivered]);
					cache_get_value_name_int(row,  "LiveBanned", PlayerInfo[extraid][pLiveBanned]);
					cache_get_value_name_int(row,  "FreezeBank", PlayerInfo[extraid][pFreezeBank]);
					cache_get_value_name_int(row,  "FreezeHouse", PlayerInfo[extraid][pFreezeHouse]);
					cache_get_value_name_int(row,  "FreezeCar", PlayerInfo[extraid][pFreezeCar]);
					cache_get_value_name_int(row,  "Firework", PlayerInfo[extraid][pFirework]);
					cache_get_value_name_int(row,  "Boombox", PlayerInfo[extraid][pBoombox]);
					cache_get_value_name_int(row,  "Hydration", PlayerInfo[extraid][pHydration]);
					cache_get_value_name_int(row,  "Speedo", PlayerInfo[extraid][pSpeedo]);
					cache_get_value_name_int(row,  "DoubleEXP", PlayerInfo[extraid][pDoubleEXP]);
					cache_get_value_name_int(row,  "EXPToken", PlayerInfo[extraid][pEXPToken]);
					cache_get_value_name_int(row,  "RacePlayerLaps", PlayerInfo[extraid][pRacePlayerLaps]);
					cache_get_value_name_int(row,  "Ringtone", PlayerInfo[extraid][pRingtone]);
					cache_get_value_name_int(row,  "Wallpaper", PlayerInfo[extraid][pWallpaper]);
					cache_get_value_name_int(row,  "VIPM", PlayerInfo[extraid][pVIPM]);
					cache_get_value_name_int(row,  "VIPMO", PlayerInfo[extraid][pVIPMO]);
					cache_get_value_name_int(row,  "VIPExpire", PlayerInfo[extraid][pVIPExpire]);
					cache_get_value_name_int(row,  "GVip", PlayerInfo[extraid][pGVip]);
					cache_get_value_name_int(row,  "Watchdog", PlayerInfo[extraid][pWatchdog]);
					cache_get_value_name_int(row,  "VIPSold", PlayerInfo[extraid][pVIPSold]);
					cache_get_value_name_int(row,  "GoldBoxTokens", PlayerInfo[extraid][pGoldBoxTokens]);
					cache_get_value_name_int(row,  "DrawChance", PlayerInfo[extraid][pRewardDrawChance]);
					cache_get_value_name_float(row,  "RewardHours", PlayerInfo[extraid][pRewardHours]);
					cache_get_value_name_int(row,  "CarsRestricted", PlayerInfo[extraid][pRVehRestricted]);
					cache_get_value_name_int(row,  "LastCarWarning", PlayerInfo[extraid][pLastRVehWarn]);
					cache_get_value_name_int(row,  "CarWarns", PlayerInfo[extraid][pRVehWarns]);
					cache_get_value_name_int(row,  "Flagged", PlayerInfo[extraid][pFlagged]);
					cache_get_value_name_int(row,  "Paper", PlayerInfo[extraid][pPaper]);
					cache_get_value_name_int(row,  "MailEnabled", PlayerInfo[extraid][pMailEnabled]);
					cache_get_value_name_int(row,  "Mailbox", PlayerInfo[extraid][pMailbox]);
					cache_get_value_name_int(row,  "Business", PlayerInfo[extraid][pBusiness]);
					cache_get_value_name_int(row,  "BusinessRank", PlayerInfo[extraid][pBusinessRank]);
					cache_get_value_name_int(row,  "TreasureSkill", PlayerInfo[extraid][pTreasureSkill]);
					cache_get_value_name_int(row,  "MetalDetector", PlayerInfo[extraid][pMetalDetector]);
					cache_get_value_name_int(row,  "HelpedBefore", PlayerInfo[extraid][pHelpedBefore]);
					cache_get_value_name_int(row,  "Trickortreat", PlayerInfo[extraid][pTrickortreat]);
					cache_get_value_name_int(row,  "LastCharmReceived", PlayerInfo[extraid][pLastCharmReceived]);
					cache_get_value_name_int(row,  "RHMutes", PlayerInfo[extraid][pRHMutes]);
					cache_get_value_name_int(row,  "RHMuteTime", PlayerInfo[extraid][pRHMuteTime]);
					cache_get_value_name_int(row,  "GiftCode", PlayerInfo[extraid][pGiftCode]);
					cache_get_value_name_int(row,  "Table", PlayerInfo[extraid][pTable]);
					cache_get_value_name_int(row,  "OpiumSeeds", PlayerInfo[extraid][pOpiumSeeds]);
					cache_get_value_name_int(row,  "RawOpium", PlayerInfo[extraid][pRawOpium]);
					//PlayerInfo[extraid][pHeroin]				= cache_get_value_name_int(row,  "Heroin", value);
					cache_get_value_name_int(row,  "Syringe", PlayerInfo[extraid][pSyringes]);
					cache_get_value_name_int(row,  "Skins", PlayerInfo[extraid][pSkins]);
					cache_get_value_name_int(row,  "Fitness", PlayerInfo[extraid][pFitness]);
					cache_get_value_name_int(row,  "ForcePasswordChange", PlayerInfo[extraid][pForcePasswordChange]);
					cache_get_value_name_int(row,  "Credits", PlayerInfo[extraid][pCredits]);
					cache_get_value_name_int(row,  "HealthCare", PlayerInfo[extraid][pHealthCare]);
					cache_get_value_name_int(row,  "TotalCredits", PlayerInfo[extraid][pTotalCredits]);
					//PlayerInfo[extraid][pReceivedCredits]		= cache_get_value_name_int(row,  "ReceivedCredits", value);
					cache_get_value_name_int(row,  "RimMod", PlayerInfo[extraid][pRimMod]);
					cache_get_value_name_int(row,  "Tazer", PlayerInfo[extraid][pHasTazer]);
					cache_get_value_name_int(row,  "Cuff", PlayerInfo[extraid][pHasCuff]);
					cache_get_value_name_int(row,  "CarVoucher", PlayerInfo[extraid][pCarVoucher]);
					cache_get_value_name(row,  "ReferredBy", PlayerInfo[extraid][pReferredBy]);
					cache_get_value_name_int(row,  "PendingRefReward", PlayerInfo[extraid][pPendingRefReward]);
					cache_get_value_name_int(row,  "Refers", PlayerInfo[extraid][pRefers]);
					cache_get_value_name_int(row,  "Famed", PlayerInfo[extraid][pFamed]);
					cache_get_value_name_int(row,  "FamedMuted", PlayerInfo[extraid][pFMuted]);
					cache_get_value_name_int(row,  "DefendTime", PlayerInfo[extraid][pDefendTime]);
					cache_get_value_name_int(row,  "VehicleSlot", PlayerInfo[extraid][pVehicleSlot]);
					cache_get_value_name_int(row,  "PVIPVoucher", PlayerInfo[extraid][pPVIPVoucher]);
					cache_get_value_name_int(row,  "ToySlot", PlayerInfo[extraid][pToySlot]);
					cache_get_value_name_int(row,  "RFLTeam", PlayerInfo[extraid][pRFLTeam]);
					cache_get_value_name_int(row,  "RFLTeamL", PlayerInfo[extraid][pRFLTeamL]);
					cache_get_value_name_int(row,  "VehVoucher", PlayerInfo[extraid][pVehVoucher]);
					cache_get_value_name_int(row,  "SVIPVoucher", PlayerInfo[extraid][pSVIPVoucher]);
					cache_get_value_name_int(row,  "GVIPVoucher", PlayerInfo[extraid][pGVIPVoucher]);
					cache_get_value_name_int(row,  "GiftVoucher", PlayerInfo[extraid][pGiftVoucher]);
					cache_get_value_name_int(row,  "FallIntoFun", PlayerInfo[extraid][pFallIntoFun]);
					cache_get_value_name_int(row,  "HungerVoucher", PlayerInfo[extraid][pHungerVoucher]);
					cache_get_value_name_int(row,  "BoughtCure", PlayerInfo[extraid][pBoughtCure]);
					cache_get_value_name_int(row,  "Vials", PlayerInfo[extraid][pVials]);
					cache_get_value_name_int(row,  "AdvertVoucher", PlayerInfo[extraid][pAdvertVoucher]);
					cache_get_value_name_int(row,  "ShopCounter", PlayerInfo[extraid][pShopCounter]);
					cache_get_value_name_int(row,  "ShopNotice", PlayerInfo[extraid][pShopNotice]);
					cache_get_value_name_int(row,  "SVIPExVoucher", PlayerInfo[extraid][pSVIPExVoucher]);
					cache_get_value_name_int(row,  "GVIPExVoucher", PlayerInfo[extraid][pGVIPExVoucher]);
					cache_get_value_name_int(row,  "VIPSellable", PlayerInfo[extraid][pVIPSellable]);
					cache_get_value_name_int(row,  "ReceivedPrize", PlayerInfo[extraid][pReceivedPrize]);
					cache_get_value_name_int(row,  "VIPSpawn", PlayerInfo[extraid][pVIPSpawn]);
					cache_get_value_name_int(row,  "FreeAdsDay", PlayerInfo[extraid][pFreeAdsDay]);
					cache_get_value_name_int(row,  "FreeAdsLeft", PlayerInfo[extraid][pFreeAdsLeft]);
					cache_get_value_name_int(row,  "BuddyInvites", PlayerInfo[extraid][pBuddyInvites]);
					cache_get_value_name_int(row,  "ReceivedBGift", PlayerInfo[extraid][pReceivedBGift]);
					cache_get_value_name_int(row,  "pVIPJob", PlayerInfo[extraid][pVIPJob]);
					cache_get_value_name_int(row,  "LastBirthday", PlayerInfo[extraid][pLastBirthday]);
					cache_get_value_name_int(row,  "AccountRestricted", PlayerInfo[extraid][pAccountRestricted]);
					cache_get_value_name_int(row,  "Watchlist", PlayerInfo[extraid][pWatchlist]);
					cache_get_value_name_int(row,  "WatchlistTime", PlayerInfo[extraid][pWatchlistTime]);
					cache_get_value_name_int(row,  "Backpack", PlayerInfo[extraid][pBackpack]);
					cache_get_value_name_int(row,  "BEquipped", PlayerInfo[extraid][pBEquipped]);
					cache_get_value_name_int(row,  "BStoredH", PlayerInfo[extraid][pBStoredH]);
					cache_get_value_name_int(row,  "BStoredV", PlayerInfo[extraid][pBStoredV]);
					cache_get_value_name_int(row,  "BRTimeout", PlayerInfo[extraid][pBugReportTimeout]);
					cache_get_value_name_int(row, "PrisonCredits", PlayerInfo[extraid][pPrisonCredits]);
					cache_get_value_name_int(row, "PrisonMaterials", PlayerInfo[extraid][pPrisonMaterials]);
					cache_get_value_name_int(row, "PrisonWineTime", PlayerInfo[extraid][pPrisonWineTime]);
					cache_get_value_name_int(row, "PrisonCell", PlayerInfo[extraid][pPrisonCell]);

					cache_get_value_name_int(row, "CopKit", value);
					SetPVarInt(extraid, "MedVestKit", value);

					cache_get_value_name_int(row, "PrisonSoap", value);
					SetPVarInt(extraid, "pPrisonSoap", value);

					cache_get_value_name_int(row, "PrisonSugar", value);
					SetPVarInt(extraid, "pPrisonSugar", value);

					cache_get_value_name_int(row, "PrisonBread", value);
					SetPVarInt(extraid, "pPrisonBread", value);

					cache_get_value_name_int(row, "PrisonShank", value);
					SetPVarInt(extraid, "pPrisonShank", value);

					cache_get_value_name_int(row, "PrisonShankOut", value);
					SetPVarInt(extraid, "pPrisonShankOut", value);

					cache_get_value_name_int(row, "ShankUsages", value);
					SetPVarInt(extraid, "pShankUsages", value);

					cache_get_value_name_int(row, "PrisonWine", value);
					SetPVarInt(extraid, "pPrisonWine", value);

					cache_get_value_name_int(row, "PrisonMWine", value);
					SetPVarInt(extraid, "pPrisonMWine", value);

					cache_get_value_name_int(row, "PrisonChisel", value);
					SetPVarInt(extraid, "pPrisonChisel", value);

					cache_get_value_name_int(row, "PrisonCellChisel", value);
					SetPVarInt(extraid, "pPrisonCellChisel", value);

					cache_get_value_name_int(row,  "FishingSkill", PlayerInfo[extraid][pFishingSkill]);
					cache_get_value_name_int(row,  "FishWeight", PlayerInfo[extraid][pFishWeight]);
					cache_get_value_name_int(row,  "GarbageSkill", PlayerInfo[extraid][pGarbageSkill]);
					for(new i = 0; i < 12; i++)	{

						format(szField, sizeof(szField), "BItem%d", i);
						cache_get_value_name_int(row,  szField, PlayerInfo[extraid][pBItems][i]);
					}
					for(new i = 0; i < sizeof(Drugs); i++) {

						format(szField, sizeof(szField), "BDrug%d", i);
						cache_get_value_name_int(row,  szField, PlayerInfo[extraid][pBDrugs][i]);
					}
					cache_get_value_name_int(row,  "pDigCooldown", PlayerInfo[extraid][pDigCooldown]);
					cache_get_value_name_int(row,  "ToolBox", PlayerInfo[extraid][pToolBox]);
					cache_get_value_name_int(row,  "CrowBar", PlayerInfo[extraid][pCrowBar]);
					cache_get_value_name_int(row,  "CarLockPickSkill", PlayerInfo[extraid][pCarLockPickSkill]);
					cache_get_value_name_int(row,  "LockPickVehCount", PlayerInfo[extraid][pLockPickVehCount]);
					cache_get_value_name_int(row,  "LockPickTime", PlayerInfo[extraid][pLockPickTime]);
					cache_get_value_name_int(row,  "SEC", PlayerInfo[extraid][pSEC]);
					cache_get_value_name_int(row,  "BM", PlayerInfo[extraid][pBM]);
					cache_get_value_name_int(row,  "ASM", PlayerInfo[extraid][pASM]);
					cache_get_value_name_int(row,  "Isolated", PlayerInfo[extraid][pIsolated]);
					cache_get_value_name_int(row,  "WantedJailTime", PlayerInfo[extraid][pWantedJailTime]);
					cache_get_value_name_int(row,  "WantedJailFine", PlayerInfo[extraid][pWantedJailFine]);
					cache_get_value_name_int(row,  "NextNameChange", PlayerInfo[extraid][pNextNameChange]);
					cache_get_value_name(row,  "pExamineDesc", PlayerInfo[extraid][pExamineDesc]);
					cache_get_value_name(row,  "FavStation", PlayerInfo[extraid][pFavStation]);

					// Austin's DP System
					cache_get_value_name_int(row,  "pDedicatedPlayer", PlayerInfo[extraid][pDedicatedPlayer]);
					cache_get_value_name_int(row,  "pDedicatedEnabled", PlayerInfo[extraid][pDedicatedEnabled]);
					cache_get_value_name_int(row,  "pDedicatedMuted", PlayerInfo[extraid][pDedicatedMuted]);
					cache_get_value_name_int(row,  "pDedicatedWarn", PlayerInfo[extraid][pDedicatedWarn]);
					cache_get_value_name(row,  "mInventory", szResult);
					sscanf(szResult, MicroSpecifier, PlayerInfo[extraid][mInventory]);
					cache_get_value_name(row,  "mPurchaseCounts", szResult);
					sscanf(szResult, MicroSpecifier, PlayerInfo[extraid][mPurchaseCount]);
					new result[256];
					cache_get_value_name(row,  "mCooldowns", result);
					sscanf(result, MicroSpecifier, PlayerInfo[extraid][mCooldown]);
					cache_get_value_name(row,  "mBoost", szResult);
					sscanf(szResult, "p<|>e<dd>", PlayerInfo[extraid][mBoost]);
					cache_get_value_name(row,  "mShopNotice", szResult);
					sscanf(szResult, "p<|>dd", PlayerInfo[extraid][mShopCounter], PlayerInfo[extraid][mNotice]);
					cache_get_value_name_int(row,  "zFuelCan", PlayerInfo[extraid][zFuelCan]);
					cache_get_value_name_int(row,  "bTicket", PlayerInfo[extraid][bTicket]);

					// Austin's Punishment Revamp
					cache_get_value_name(row,  "JailedInfo", szResult);
					sscanf(szResult, "p<|>e<ddddd>", PlayerInfo[extraid][pJailedInfo]);
					cache_get_value_name(row,  "JailedWeapons", szResult);
					sscanf(szResult, "p<|>e<dddddddddddd>", PlayerInfo[extraid][pJailedWeapons]);

					cache_get_value_name_int(row, "pVIPMod", PlayerInfo[extraid][pVIPMod]);
					cache_get_value_name_int(row, "EmailConfirmed", value);
					SetPVarInt(extraid, "EmailConfirmed", value);
					cache_get_value_name_int(row, "pEventTokens", PlayerInfo[extraid][pEventTokens]);
					cache_get_value_name_int(row, "pBailPrice", PlayerInfo[extraid][pBailPrice]);
					cache_get_value_name_int(row, "pLastPoll", PlayerInfo[extraid][pLastPoll]);
					cache_get_value_name_int(row, "VIPGunsCount", PlayerInfo[extraid][pVIPGuncount]);
					cache_get_value_name_int(row, "GroupToyBone", PlayerInfo[extraid][pGroupToyBone]);
					cache_get_value_name_float(row, "GroupToy0", PlayerInfo[extraid][pGroupToy][0]);
					cache_get_value_name_float(row, "GroupToy1", PlayerInfo[extraid][pGroupToy][1]);
					cache_get_value_name_float(row, "GroupToy2", PlayerInfo[extraid][pGroupToy][2]);
					cache_get_value_name_float(row, "GroupToy3", PlayerInfo[extraid][pGroupToy][3]);
					cache_get_value_name_float(row, "GroupToy4", PlayerInfo[extraid][pGroupToy][4]);
					cache_get_value_name_float(row, "GroupToy5", PlayerInfo[extraid][pGroupToy][5]);
					cache_get_value_name_float(row, "GroupToy6", PlayerInfo[extraid][pGroupToy][6]);
					cache_get_value_name_float(row, "GroupToy7", PlayerInfo[extraid][pGroupToy][7]);
					cache_get_value_name_float(row, "GroupToy8", PlayerInfo[extraid][pGroupToy][8]);
					cache_get_value_name_int(row, "Pot", PlayerInfo[extraid][pDrugs][0]);
					cache_get_value_name_int(row, "Crack", PlayerInfo[extraid][pDrugs][1]);
					cache_get_value_name_int(row, "Meth", PlayerInfo[extraid][pDrugs][2]);
					cache_get_value_name_int(row, "Ecstasy", PlayerInfo[extraid][pDrugs][3]);
					cache_get_value_name_int(row, "Heroin", PlayerInfo[extraid][pDrugs][4]);
					cache_get_value_name_int(row, "Hitman", PlayerInfo[extraid][pHitman]);
					cache_get_value_name_int(row, "HitmanLeader", PlayerInfo[extraid][pHitmanLeader]);
					cache_get_value_name_int(row, "HitmanBlacklisted", PlayerInfo[extraid][pHitmanBlacklisted]);
					cache_get_value_name(row, "BlacklistReason", PlayerInfo[extraid][pBlacklistReason]);
					cache_get_value_name(row, "PollKeyA", PlayerInfo[extraid][pPollKey1]);
					cache_get_value_name(row, "PollKeyB", PlayerInfo[extraid][pPollKey2]);
					cache_get_value_name(row, "PollKeyC", PlayerInfo[extraid][pPollKey3]);
					if(isnull(PlayerInfo[extraid][pPollKey1])) format(PlayerInfo[extraid][pPollKey1], 12, "Invalid Key");
					if(isnull(PlayerInfo[extraid][pPollKey2])) format(PlayerInfo[extraid][pPollKey2], 12, "Invalid Key");
					if(isnull(PlayerInfo[extraid][pPollKey3])) format(PlayerInfo[extraid][pPollKey3], 12, "Invalid Key");
					cache_get_value_name_int(row, "FurnitureSlots", PlayerInfo[extraid][pFurnitureSlots]);
					cache_get_value_name(row,  "DedicatedDaymarker", PlayerInfo[extraid][pDedicatedDaymarker]);
					cache_get_value_name(row,  "DedicatedTimestamp", PlayerInfo[extraid][pDedicatedTimestamp]);
					cache_get_value_name_int(row, "DedicatedHours", PlayerInfo[extraid][pDedicatedHours]);
					cache_get_value_name_int(row, "WalkStyle", PlayerInfo[extraid][pWalkStyle]);
					if(PlayerInfo[extraid][pWalkStyle]) SetPlayerWalkingStyle(extraid, PlayerInfo[extraid][pWalkStyle]);

					/*for(new i = 0; i < MAX_POLLS; i++)
					{
						format(szField, sizeof(szField), "HasVoted%d", i);
						PlayerInfo[extraid][pGuns][i] = cache_get_value_name_int(row,  szField);
					}*/

					// Jingles' Drug System:
					//for(new d; d != sizeof(Drugs); ++d) PlayerInfo[extraid][pDrugs][d] = cache_get_value_name_int(row, GetDrugName(d));
					//for(new d; d != sizeof(szIngredients); ++d) PlayerInfo[extraid][p_iIngredient][d] = cache_get_value_name_int(row, DS_Ingredients_GetSQLName(d));

					/*szMiscArray[0] = 0;	
					for(new d; d != sizeof(Drugs); ++d)
					{
						format(szMiscArray, sizeof(szMiscArray), "Prison%s", GetDrugName(d));
						PlayerInfo[extraid][p_iPrisonDrug][d] = cache_get_value_name_int(row, szMiscArray);
					} old */

					/*cache_get_value_name(row,  "PrisonDrugs", szResult);
					sscanf(szResult, "p<|>e<dddddddddddddd>", PlayerInfo[extraid][p_iPrisonDrug]);*/

					/*cache_get_value_name(row,  "DrugQuality", szResult);
					sscanf(szResult, "p<|>e<dddddddddddddd>", PlayerInfo[extraid][p_iDrugQuality]);*/

					// Account settings:
					/*cache_get_value_name(row,  "ToggledChats", szResult);
					sscanf(szResult, "p<|>e<dddddddddddddddddddd>", PlayerInfo[extraid][pToggledChats]);*/

					for(new c = 0; c < MAX_CHATSETS; c++) {
						format(szMiscArray, sizeof(szMiscArray), "ChatTog%d", c);
						cache_get_value_name_int(row, szMiscArray, PlayerInfo[extraid][pToggledChats][c]);
					}
					cache_get_value_name_int(row, "FlagCredits", PlayerInfo[extraid][pFlagCredits]);
					cache_get_value_name_int(row, "FlagClaimed", PlayerInfo[extraid][pFlagClaimed]);

					/*cache_get_value_name(row,  "ChatboxSettings", szResult);
					sscanf(szResult, "p<|>e<dddddddddddddddddddd>", PlayerInfo[extraid][pChatbox]);*/

					if(PlayerInfo[extraid][pCredits] > 0)
					{
						new szLog[128];
						format(szLog, sizeof(szLog), "[LOGIN] [User: %s(%i)] [IP: %s] [Credits: %s]", GetPlayerNameEx(extraid), PlayerInfo[extraid][pId], GetPlayerIpEx(extraid), number_format(PlayerInfo[extraid][pCredits]));
						Log("logs/logincredits.log", szLog), print(szLog);
					}
					GetPartnerName(extraid);
					g_mysql_LoadPVehicles(extraid);
					LoadPlayerNonRPPoints(extraid);
					g_mysql_LoadPlayerToys(extraid);
					g_mysql_LoadFIFInfo(extraid);

					SetPVarInt(extraid, "pSQLID", PlayerInfo[extraid][pId]);

					//g_mysql_LoadPVehiclePositions(extraid);
					OnPlayerLoad(extraid);
                	break;
				}
			}
			return 1;
		}
		case SENDDATA_THREAD:
		{
			if(GetPVarType(extraid, "RestartKick")) {
				gPlayerLogged{extraid} = 0;
				GameTextForPlayer(extraid, "Scheduled Maintenance...", 5000, 5);
				SendClientMessage(extraid, COLOR_LIGHTBLUE, "* The server will be going down for Scheduled Maintenance. A brief period of downtime will follow.");
				SendClientMessage(extraid, COLOR_GRAD2, "We will be going down to do some maintenance on the server/script, we will be back online shortly.");
				SetTimerEx("KickEx", 1000, 0, "i", extraid);

				foreach(extraid: Player) if(gPlayerLogged{extraid}) {
					SetPVarInt(extraid, "RestartKick", 1);
					return OnPlayerStatsUpdate(extraid);
				}
				ABroadCast(COLOR_YELLOW, "{AA3333}Maintenance{FFFF00}: Account saving finished!", 1);
				//g_mysql_DumpAccounts();

				SetTimer("FinishMaintenance", 1500, false);
			}
			if(GetPVarType(extraid, "AccountSaving") && (GetPVarInt(extraid, "AccountSaved") == 0)) {
				SetPVarInt(extraid, "AccountSaved", 1);
				foreach(new i: Player)
				{
					if(gPlayerLogged{i} && (GetPVarInt(i, "AccountSaved") == 0))
					{
						SetPVarInt(i, "AccountSaving", 1);
						OnPlayerStatsUpdate(i);
					}
				}
				ABroadCast(COLOR_YELLOW, "{AA3333}Maintenance{FFFF00}: Account saving finished!", 2);
				print("Account Saving Complete");
				foreach(new i: Player)
				{
					DeletePVar(i, "AccountSaved");
					DeletePVar(i, "AccountSaving");
				}
				//g_mysql_DumpAccounts();
			}
			return 1;
		}
		case AUTH_THREAD:
		{
			new name[24];
			for(new i;i < rows;i++)
			{
				cache_get_value_name(i, "Username", name, MAX_PLAYER_NAME);
				if(strcmp(name, GetPlayerNameExt(extraid), true) == 0)
				{
					HideNoticeGUIFrame(extraid);
					SafeLogin(extraid, 1);
					return 1;
				}
				else
				{
					return 1;
				}
			}
			HideNoticeGUIFrame(extraid);
			SafeLogin(extraid, 2);
			return 1;
		}
		case LOGIN_THREAD:
		{
			for(new i;i < rows;i++)
			{
				CheckAdminWhitelist(extraid);
				new
					szPass[129],
					szResult[129],
					szBuffer[129],
					salt[11];

				cache_get_value_name(i, "Username", szResult, MAX_PLAYER_NAME);
				if(strcmp(szResult, GetPlayerNameExt(extraid), true) != 0)
				{
					//g_mysql_AccountAuthCheck(extraid);
					return 1;
				}
				cache_get_value_name(i, "Key", szResult, 129);
				cache_get_value_name(i, "Salt", salt, 11);
				GetPVarString(extraid, "PassAuth", szBuffer, sizeof(szBuffer));
				if(!isnull(salt)) strcat(szBuffer, salt);
				WP_Hash(szPass, sizeof(szPass), szBuffer);
				/*if(cache_get_value_name_int(i, "Online")) {
					SendClientMessage(extraid, COLOR_RED, "SERVER: This account has already logged in.");
					SetTimerEx("KickEx", 1000, 0, "i", extraid);
					return 1;
				}*/

				if((isnull(szPass)) || (isnull(szResult)) || (strcmp(szPass, szResult) != 0)) {
					// Invalid Password - Try Again!
					ShowMainMenuDialog(extraid, 3);
					HideNoticeGUIFrame(extraid);
					if(++gPlayerLogTries[extraid] == 2) {
						SendClientMessage(extraid, COLOR_RED, "SERVER: Wrong password, you have been kicked out automatically.");
						SetTimerEx("KickEx", 1000, 0, "i", extraid);
					}
					return 1;
				}
				if(PassComplexCheck && CheckPasswordComplexity(szBuffer) != 1) ShowLoginDialogs(extraid, 0);
				break;
			}
			GetPVarString(extraid, "PassAuth", PlayerInfo[extraid][pLastPass], 65);
			DeletePVar(extraid, "PassAuth");
			HideNoticeGUIFrame(extraid);
			g_mysql_LoadAccount(extraid);
			return 1;
		}
		case REGISTER_THREAD:
		{
			if(IsPlayerConnected(extraid))
			{
				AdvanceTutorial(extraid);
				g_mysql_AccountLoginCheck(extraid);
				format(szMiscArray, sizeof(szMiscArray), "WARNING: %s (ID: %d) has registered from %s", GetPlayerNameEx(extraid), extraid, GetPlayerCountry(extraid));
				ABroadCast(COLOR_LIGHTRED, szMiscArray, 2);
				TotalRegister++;
			}
		}
		case LOADPTOYS_THREAD:
		{
			if(IsPlayerConnected(extraid))
			{
				new i = 0;
				while( i < rows)
				{
					if(i >= MAX_PLAYERTOYS)
						break;

					//new szResult[32];

					cache_get_value_name_int(i, "id", PlayerToyInfo[extraid][i][ptID]);
					cache_get_value_name_int(i, "modelid", PlayerToyInfo[extraid][i][ptModelID]);

					if(PlayerToyInfo[extraid][i][ptModelID] != 0)
					{
						cache_get_value_name_int(i, "bone", PlayerToyInfo[extraid][i][ptBone]);
						if(PlayerToyInfo[extraid][i][ptBone] > 18 || PlayerToyInfo[extraid][i][ptBone] < 1) PlayerToyInfo[extraid][i][ptBone] = 1;

						cache_get_value_name_int(i, "tradable", PlayerToyInfo[extraid][i][ptTradable]);
						cache_get_value_name_float(i, "posx", PlayerToyInfo[extraid][i][ptPosX]);
						cache_get_value_name_float(i, "posy", PlayerToyInfo[extraid][i][ptPosY]);
						cache_get_value_name_float(i, "posz", PlayerToyInfo[extraid][i][ptPosZ]);
						cache_get_value_name_float(i, "rotx", PlayerToyInfo[extraid][i][ptRotX]);
						cache_get_value_name_float(i, "roty", PlayerToyInfo[extraid][i][ptRotY]);
						cache_get_value_name_float(i, "rotz", PlayerToyInfo[extraid][i][ptRotZ]);
						cache_get_value_name_float(i, "scalex", PlayerToyInfo[extraid][i][ptScaleX]);
						cache_get_value_name_float(i, "scaley", PlayerToyInfo[extraid][i][ptScaleY]);
						cache_get_value_name_float(i, "scalez", PlayerToyInfo[extraid][i][ptScaleZ]);
						cache_get_value_name_int(i, "special", PlayerToyInfo[extraid][i][ptSpecial]);
						cache_get_value_name_int(i, "autoattach", PlayerToyInfo[extraid][i][ptAutoAttach]);
						
						if(PlayerToyInfo[extraid][i][ptAutoAttach] == -1 || PlayerToyInfo[extraid][i][ptAutoAttach] == GetPlayerSkin(extraid)) AttachToy(extraid, i, 0);

						format(szMiscArray, sizeof(szMiscArray), "[TOYSLOAD] [User: %s(%i)] [Toy Model ID: %d] [Toy ID]", GetPlayerNameEx(extraid), PlayerInfo[extraid][pId], PlayerToyInfo[extraid][i][ptModelID], PlayerToyInfo[extraid][i][ptID]);
						Log("logs/toydebug.log", szMiscArray);
					}
					else
					{
						mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "DELETE FROM `toys` WHERE `id` = '%d'", PlayerToyInfo[extraid][i][ptID]);
						mysql_tquery(MainPipeline, szMiscArray, "OnQueryFinish", "i", SENDDATA_THREAD);
						printf("Deleting Toy ID %d for Player %s (%i)", PlayerToyInfo[extraid][i][ptID], GetPlayerNameEx(extraid), GetPlayerSQLId(extraid));
					}
					i++;
				}
			}
		}
		case LOADPVEHICLE_THREAD:
		{
			if(IsPlayerConnected(extraid))
			{
			    new i = 0;
				while(i < rows)
				{
				    if(i >= MAX_PLAYERVEHICLES)
						break;

				    //new szResult[32];

					cache_get_value_name_int(i,  "pvModelId", PlayerVehicleInfo[extraid][i][pvModelId]);
					cache_get_value_name_int(i, "id", PlayerVehicleInfo[extraid][i][pvSlotId]);

					if(PlayerVehicleInfo[extraid][i][pvModelId] != 0)
					{
						cache_get_value_name_float(i,  "pvPosX", PlayerVehicleInfo[extraid][i][pvPosX]);
						cache_get_value_name_float(i,  "pvPosY", PlayerVehicleInfo[extraid][i][pvPosY]);
						cache_get_value_name_float(i,  "pvPosZ", PlayerVehicleInfo[extraid][i][pvPosZ]);
						cache_get_value_name_float(i, "pvPosAngle", PlayerVehicleInfo[extraid][i][pvPosAngle]);
						cache_get_value_name_int(i,  "pvLock", PlayerVehicleInfo[extraid][i][pvLock]);
						cache_get_value_name_int(i,  "pvLocked", PlayerVehicleInfo[extraid][i][pvLocked]);
						cache_get_value_name_int(i,  "pvPaintJob", PlayerVehicleInfo[extraid][i][pvPaintJob]);
						cache_get_value_name_int(i,  "pvColor1", PlayerVehicleInfo[extraid][i][pvColor1]);
						cache_get_value_name_int(i,  "pvColor2", PlayerVehicleInfo[extraid][i][pvColor2]);
						cache_get_value_name_int(i,  "pvPrice", PlayerVehicleInfo[extraid][i][pvPrice]);
						cache_get_value_name_int(i,  "pvTicket", PlayerVehicleInfo[extraid][i][pvTicket]);
						cache_get_value_name_int(i,  "pvRestricted", PlayerVehicleInfo[extraid][i][pvRestricted]);
						cache_get_value_name_int(i,  "pvWeapon0", PlayerVehicleInfo[extraid][i][pvWeapons][0]);
						cache_get_value_name_int(i,  "pvWeapon1", PlayerVehicleInfo[extraid][i][pvWeapons][1]);
						cache_get_value_name_int(i,  "pvWeapon2", PlayerVehicleInfo[extraid][i][pvWeapons][2]);
						cache_get_value_name_int(i,  "pvWepUpgrade", PlayerVehicleInfo[extraid][i][pvWepUpgrade]);
						cache_get_value_name_float(i, "pvFuel", PlayerVehicleInfo[extraid][i][pvFuel]);
						cache_get_value_name_int(i,  "pvImpound", PlayerVehicleInfo[extraid][i][pvImpounded]);
						cache_get_value_name(i,  "pvPlate", PlayerVehicleInfo[extraid][i][pvPlate]);
						cache_get_value_name_int(i,  "pvVW", PlayerVehicleInfo[extraid][i][pvVW]);
						cache_get_value_name_int(i,  "pvInt", PlayerVehicleInfo[extraid][i][pvInt]);
						for(new m = 0; m < MAX_MODS; m++)
						{
							format(szMiscArray, sizeof(szMiscArray), "pvMod%d", m);
							cache_get_value_name_int(i,  szMiscArray, PlayerVehicleInfo[extraid][i][pvMods][m]);
						}
						/*for(new m = 0; m < sizeof(Drugs); m++)
						{
							PlayerVehicleInfo[extraid][i][pvDrugs][m] = cache_get_value_name_int(i,   GetDrugName(m));
						}*/
						cache_get_value_name_int(i,  "pvCrashFlag", PlayerVehicleInfo[extraid][i][pvCrashFlag]);
						cache_get_value_name_int(i, "pvCrashVW", PlayerVehicleInfo[extraid][i][pvCrashVW]);
						cache_get_value_name_float(i,  "pvCrashX", PlayerVehicleInfo[extraid][i][pvCrashX]);
						cache_get_value_name_float(i,  "pvCrashY", PlayerVehicleInfo[extraid][i][pvCrashY]);
						cache_get_value_name_float(i,  "pvCrashZ", PlayerVehicleInfo[extraid][i][pvCrashZ]);
						cache_get_value_name_float(i,  "pvCrashAngle", PlayerVehicleInfo[extraid][i][pvCrashAngle]);
						cache_get_value_name_int(i,  "pvAlarm", PlayerVehicleInfo[extraid][i][pvAlarm]);
						cache_get_value_name(i,  "pvLastLockPickedBy", PlayerVehicleInfo[extraid][i][pvLastLockPickedBy]);
						cache_get_value_name_int(i,  "pvLocksLeft", PlayerVehicleInfo[extraid][i][pvLocksLeft]);
						cache_get_value_name_float(i, "pvHealth", PlayerVehicleInfo[extraid][i][pvHealth]);

						format(szMiscArray, sizeof(szMiscArray), "[VEHICLELOAD] [User: %s(%i)] [Model: %d] [Vehicle ID: %d]", GetPlayerNameEx(extraid), PlayerInfo[extraid][pId], PlayerVehicleInfo[extraid][i][pvModelId], PlayerVehicleInfo[extraid][i][pvSlotId]);
						Log("logs/vehicledebug.log", szMiscArray);
					}
					else
					{
						mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "DELETE FROM `vehicles` WHERE `id` = '%d'", PlayerVehicleInfo[extraid][i][pvSlotId]);
						mysql_tquery(MainPipeline, szMiscArray, "OnQueryFinish", "ii", SENDDATA_THREAD, extraid);
					}
					i++;
				}
			}
		}
		case LOADPVEHPOS_THREAD:
		{
			if(IsPlayerConnected(extraid))
			{
				new bool:bVehRestore;
				for(new i;i < rows;i++)
				{
					bVehRestore = true;
					for(new v; v < MAX_PLAYERVEHICLES; v++)
					{
						new tmpVehModelId, Float:tmpVehArray[4];

						format(szMiscArray, sizeof(szMiscArray), "pv%dModelId", v);
						cache_get_value_name_int(i, szMiscArray, tmpVehModelId);

						format(szMiscArray, sizeof(szMiscArray), "pv%dPosX", v);
						cache_get_value_name_float(i, szMiscArray, tmpVehArray[0]);

						format(szMiscArray, sizeof(szMiscArray), "pv%dPosY", v);
						cache_get_value_name_float(i, szMiscArray, tmpVehArray[1]);

						format(szMiscArray, sizeof(szMiscArray), "pv%dPosZ", v);
						cache_get_value_name_float(i, szMiscArray, tmpVehArray[2]);

						format(szMiscArray, sizeof(szMiscArray), "pv%dPosAngle", v);
						cache_get_value_name_float(i, szMiscArray, tmpVehArray[3]);

						if(tmpVehModelId >= 400)
						{
							printf("Stored %d Vehicle Slot", v);

							format(szMiscArray, sizeof(szMiscArray), "tmpVeh%dModelId", v);
							SetPVarInt(extraid, szMiscArray, tmpVehModelId);

							format(szMiscArray, sizeof(szMiscArray), "tmpVeh%dPosX", v);
							SetPVarFloat(extraid, szMiscArray, tmpVehArray[0]);

							format(szMiscArray, sizeof(szMiscArray), "tmpVeh%dPosY", v);
							SetPVarFloat(extraid, szMiscArray, tmpVehArray[1]);

							format(szMiscArray, sizeof(szMiscArray), "tmpVeh%dPosZ", v);
							SetPVarFloat(extraid, szMiscArray, tmpVehArray[2]);

							format(szMiscArray, sizeof(szMiscArray), "tmpVeh%dAngle", v);
							SetPVarFloat(extraid, szMiscArray, tmpVehArray[3]);
						}
					}
					break;
				}

				if(bVehRestore == true) {
					// person Vehicle Position Restore Granted, Now Purge them from the Table.
					mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "DELETE FROM `pvehpositions` WHERE `id`='%d'", PlayerInfo[extraid][pId]);
					mysql_tquery(MainPipeline, szMiscArray, "OnQueryFinish", "ii", SENDDATA_THREAD, extraid);
				}

				OnPlayerLoad(extraid);
			}
		}
		case IPBAN_THREAD:
		{
		    if(rows > 0)
			{
				SendClientMessage(extraid, COLOR_RED, "Your IP is banned! You can appeal this at http://www.ng-gaming.net/forums");
				SetTimerEx("KickEx", 1000, 0, "i", extraid);
			}
			else
			{
			    g_mysql_AccountAuthCheck(extraid);
			}
		}
		case MAIN_REFERRAL_THREAD:
		{
		    new newrows, newfields;
		    cache_get_row_count(newrows);
			cache_get_field_count(newfields);

		    if(newrows == 0)
		    {
		        format(szMiscArray, sizeof(szMiscArray), "Nobody");
				strmid(PlayerInfo[extraid][pReferredBy], szMiscArray, 0, strlen(szMiscArray), MAX_PLAYER_NAME);
		        ShowPlayerDialogEx(extraid, DIALOG_REGISTER_REFERRED, DIALOG_STYLE_INPUT, "{FF0000}Error - Invalid Player", "There is no player registered to our server with such name.\nPlease enter the full name of the player who referred you.\nExample: FirstName_LastName", "Enter", "Cancel");
			}
			else {
			    mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "SELECT `IP` FROM `accounts` WHERE `Username` = '%s'", PlayerInfo[extraid][pReferredBy]);
				mysql_tquery(MainPipeline, szMiscArray, "ReferralSecurity", "i", extraid);
			}
		}
		case REWARD_REFERRAL_THREAD:
		{
			new newrows, newfields;
			cache_get_row_count(newrows);
			cache_get_field_count(newfields);

			if(newrows != 0)
			{
			    SendClientMessageEx(extraid, COLOR_YELLOW, "The player who referred you does not have a account on our server anymore, therefore he has not received any credits");
			}
		}
		case OFFLINE_FAMED_THREAD:
		{
		    new newrows, newfields, szQuery[128], string[128], szName[MAX_PLAYER_NAME];
		    cache_get_row_count(newrows);
			cache_get_field_count(newfields);

		    if(newrows == 0)
		    {
		        SendClientMessageEx(extraid, COLOR_RED, "Error - This account does not exist.");
		    }
		    else {
		        new
					ilevel = GetPVarInt(extraid, "Offline_Famed");

				GetPVarString(extraid, "Offline_Name", szName, MAX_PLAYER_NAME);

		        mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `accounts` SET `Famed` = %d WHERE `Username` = '%s'", ilevel, szName);
				mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "i", SENDDATA_THREAD);

				format(string, sizeof(string), "AdmCmd: %s has offline set %s to a level %d famed", GetPlayerNameEx(extraid), szName, ilevel);
				SendFamedMessage(COLOR_LIGHTRED, string);
				ABroadCast(COLOR_LIGHTRED, string, 2);
				Log("logs/setfamed.log", string);
				DeletePVar(extraid, "Offline_Famed");
				DeletePVar(extraid, "Offline_Name");
			}
		}
		case BUG_LIST_THREAD:
		{
			if(rows == 0) return 1;
			new szResult[MAX_PLAYER_NAME];
			for(new i; i < rows; i++)
		    {
				cache_get_value_name(i, "Username", szResult); SendClientMessageEx(extraid, COLOR_GRAD2, szResult);
			}
		}
		case ADMINWHITELIST_THREAD:
		{
			new string[128];
			for(new i;i < rows;i++)
			{
				new secureip[16], szResult[32], alevel, wdlevel;
				cache_get_value_name(i, "AdminLevel", szResult); alevel = strval(szResult);
				cache_get_value_name(i, "Watchdog", szResult); wdlevel = strval(szResult);
				cache_get_value_name(i, "SecureIP", secureip, 16);

				if((alevel > 1 || wdlevel > 2)  && betaserver == 0)  // Beta server check ( beta server does not require whitelisting)
				{
					if(isnull(secureip) || strcmp(GetPlayerIpEx(extraid), secureip, false, strlen(secureip)) != 0)
					{
						SendClientMessage(extraid, COLOR_WHITE, "SERVER: Your IP does not match the whitelisted IP of that account. Contact a Senior+ Admin to whitelist your current IP.");
						foreach(new x: Player)
						{
							{
								if(PlayerInfo[x][pAdmin] < 1337 && (PlayerInfo[x][pAdmin] >= 2 || PlayerInfo[x][pWatchdog] >= 2))
								{
									format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s has been auto kicked for logging in with a non-whitelisted IP.", GetPlayerNameEx(extraid));
									SendClientMessageEx(x, COLOR_YELLOW, string);
								}
								else if(PlayerInfo[x][pAdmin] >= 1337)
								{
									if(alevel >= 1337) // If the person being checked for the whitelist is a HA+
									{
										format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s (IP: %s) has been auto kicked for logging in with a non-whitelisted IP.", GetPlayerNameEx(extraid), GetPlayerIpEx(extraid));
										SendClientMessageEx(x, COLOR_YELLOW, string);
									}
									else
									{
										format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s has been auto kicked for logging in with a non-whitelisted IP.", GetPlayerNameEx(extraid));
										SendClientMessageEx(x, COLOR_YELLOW, string);
									}
								}
							}
						}
						SetTimerEx("KickEx", 1000, 0, "i", extraid);
						format(string, sizeof(string), "%s failed whitelist auth. Secure IP: %s | Connected IP: %s", GetPlayerNameEx(extraid), secureip, GetPlayerIpEx(extraid));
						Log("logs/whitelist.log", string);
						return true;
					}
					format(string, sizeof(string), "%s passed whitelist auth. Secure IP: %s | Connected IP: %s", GetPlayerNameEx(extraid), secureip, GetPlayerIpEx(extraid));
					Log("logs/whitelist.log", string);
				}
			}
			return true;
		}
		case LOADGIFTBOX_THREAD:
		{
			for(new i; i < rows; i++)
			{
				new szResult[32], arraystring[128];
				for(new array = 0; array < 4; array++)
				{
					format(arraystring, sizeof(arraystring), "dgMoney%d", array);
					cache_get_value_name(i, arraystring, szResult); dgVar[dgMoney][array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgRimKit%d", array);
					cache_get_value_name(i, arraystring, szResult); dgVar[dgRimKit][array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgFirework%d", array);
					cache_get_value_name(i, arraystring, szResult); dgVar[dgFirework][array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgGVIP%d", array);
					cache_get_value_name(i, arraystring, szResult); dgVar[dgGVIP][array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgSVIP%d", array);
					cache_get_value_name(i, arraystring, szResult); dgVar[dgSVIP][array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgGVIPEx%d", array);
					cache_get_value_name(i, arraystring, szResult); dgVar[dgGVIPEx][array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgSVIPEx%d", array);
					cache_get_value_name(i, arraystring, szResult); dgVar[dgSVIPEx][array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgCarSlot%d", array);
					cache_get_value_name(i, arraystring, szResult); dgVar[dgCarSlot][array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgToySlot%d", array);
					cache_get_value_name(i, arraystring, szResult); dgVar[dgToySlot][array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgArmor%d", array);
					cache_get_value_name(i, arraystring, szResult); dgVar[dgArmor][array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgFirstaid%d", array);
					cache_get_value_name(i, arraystring, szResult); dgVar[dgFirstaid][array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgDDFlag%d", array);
					cache_get_value_name(i, arraystring, szResult); dgVar[dgDDFlag][array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgGateFlag%d", array);
					cache_get_value_name(i, arraystring, szResult); dgVar[dgGateFlag][array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgCredits%d", array);
					cache_get_value_name(i, arraystring, szResult); dgVar[dgCredits][array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgPriorityAd%d", array);
					cache_get_value_name(i, arraystring, szResult); dgVar[dgPriorityAd][array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgHealthNArmor%d", array);
					cache_get_value_name(i, arraystring, szResult); dgVar[dgHealthNArmor][array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgGiftReset%d", array);
					cache_get_value_name(i, arraystring, szResult); dgVar[dgGiftReset][array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgMaterial%d", array);
					cache_get_value_name(i, arraystring, szResult); dgVar[dgMaterial][array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgWarning%d", array);
					cache_get_value_name(i, arraystring, szResult); dgVar[dgWarning][array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgPot%d", array);
					cache_get_value_name(i, arraystring, szResult); dgVar[dgPot][array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgCrack%d", array);
					cache_get_value_name(i, arraystring, szResult); dgVar[dgCrack][array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgPaintballToken%d", array);
					cache_get_value_name(i, arraystring, szResult); dgVar[dgPaintballToken][array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgVIPToken%d", array);
					cache_get_value_name(i, arraystring, szResult); dgVar[dgVIPToken][array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgRespectPoint%d", array);
					cache_get_value_name(i, arraystring, szResult); dgVar[dgRespectPoint][array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgCarVoucher%d", array);
					cache_get_value_name(i, arraystring, szResult); dgVar[dgCarVoucher][array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgBuddyInvite%d", array);
					cache_get_value_name(i, arraystring, szResult); dgVar[dgBuddyInvite][array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgLaser%d", array);
					cache_get_value_name(i, arraystring, szResult); dgVar[dgLaser][array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgCustomToy%d", array);
					cache_get_value_name(i, arraystring, szResult); dgVar[dgCustomToy][array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgAdmuteReset%d", array);
					cache_get_value_name(i, arraystring, szResult); dgVar[dgAdmuteReset][array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgNewbieMuteReset%d", array);
					cache_get_value_name(i, arraystring, szResult); dgVar[dgNewbieMuteReset][array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgRestrictedCarVoucher%d", array);
					cache_get_value_name(i, arraystring, szResult); dgVar[dgRestrictedCarVoucher][array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgPlatinumVIPVoucher%d", array);
					cache_get_value_name(i, arraystring, szResult); dgVar[dgPlatinumVIPVoucher][array] = strval(szResult);
				}
				break;
			}
			print("[Dynamic Giftbox] Successfully loaded the dynamic giftbox.");
		}
		case LOADPNONRPOINTS_THREAD: // I have no idea if this will work lulz (it's 9:30am)
		{
			// Is the player still connected by the time the thread is called?
			if(IsPlayerConnected(extraid))
			{
				new count = 0;

				// Loop through all the rows that were called within that query
				for(new i = 0; i < rows; i++)
				{
					new szResult[32];

					cache_get_value_name(i, "active", szResult);

					// Is the row active?
					if(strval(szResult) == 1)
					{
						cache_get_value_name(i, "point", szResult);

						// Add up all the points
						count = count += strval(szResult);
					}
				}
				// We're done with our loop, let's get our count and store it to a player variable
				PlayerInfo[extraid][pNonRPMeter] = count;
			}
		}
		case OFFLINE_DEDICATED_THREAD:
		{
		    new iRows, iFields, szQuery[128], string[128], szName[MAX_PLAYER_NAME];
		    cache_get_row_count(iRows);
			cache_get_field_count(iFields);

		    if(iRows)
		    {
		        new
					ilevel = GetPVarInt(extraid, "Offline_Dedicated");

				GetPVarString(extraid, "Offline_DName", szName, MAX_PLAYER_NAME);

		        mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `accounts` SET `pDedicatedPlayer` = %d WHERE `Username` = '%s'", ilevel, szName);
				mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "i", SENDDATA_THREAD);

				format(string, sizeof(string), "AdmCmd: %s has offline set %s to a level %d Dedicated", GetPlayerNameEx(extraid), szName, ilevel);
				SendDedicatedMessage(COLOR_LIGHTRED, string);
				ABroadCast(COLOR_LIGHTRED, string, 2);
				Log("logs/dedicated.log", string);
				DeletePVar(extraid, "Offline_Dedicated");
				DeletePVar(extraid, "Offline_DName");
		    }
		    else
		    {
				SendClientMessageEx(extraid, COLOR_RED, "Error - This account does not exist.");
			}
		}
		case LOADFIF_THREAD:
		{
			if(IsPlayerConnected(extraid))
			{
				if(!rows)
				{
					new szQuery[128];
					mysql_format(MainPipeline, szQuery,sizeof(szQuery),"INSERT INTO `fallintofun` SET `player` = %d", PlayerInfo[extraid][pId]);
					mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "i", SENDDATA_THREAD);
					return 1;
				}
				new szResult[128];
				cache_get_value_name(0, "FIFHours", szResult);
				FIFInfo[extraid][FIFHours] =  strval(szResult);
				cache_get_value_name(0, "FIFChances", szResult);
				FIFInfo[extraid][FIFChances] = strval(szResult);
			}
		}
	}
	return 1;
}

public OnQueryError(errorid, const error[], const callback[], const query[], MySQL:handle) {

	printf("[MySQL] Query Error - (ErrorID: %d)",  errorid);
	print("[MySQL] Check mysql_log.txt to review the query that threw the error.");
	SQL_Log(query, error);

	if(errorid == 2013 || errorid == 2014 || errorid == 2006 || errorid == 2027 || errorid == 2055)	{
		print("[MySQL] Connection Error Detected in Threaded Query");
		//mysql_query(query, resultid, extraid);

		format(szMiscArray, sizeof(szMiscArray), "MYSQL [%d]: %d, %s, in callback: %s.", iErrorID, errorid, error, callback);
	}
	else format(szMiscArray, sizeof(szMiscArray), "MYSQL (THREADED) [%d]: %d, %s, in callback: %s.", iErrorID, errorid, error, callback);
	SendDiscordMessage(3, szMiscArray);
	format(szMiscArray, sizeof(szMiscArray), "     Query: %s", query);
	SendDiscordMessage(3, szMiscArray);
	iErrorID++;
}

//--------------------------------[ CUSTOM STOCK FUNCTIONS ]---------------------------

// g_mysql_ReturnEscaped(string unEscapedString)
// Description: Takes a unescaped string and returns an escaped one.
stock g_mysql_ReturnEscaped(unEscapedString[])
{
	new EscapedString[256];
	mysql_escape_string(unEscapedString, EscapedString);
	return EscapedString;
}

// g_mysql_AccountLoginCheck(playerid)
stock g_mysql_AccountLoginCheck(playerid)
{
	ShowNoticeGUIFrame(playerid, 2);

	new string[128];

	mysql_format(MainPipeline, string, sizeof(string), "SELECT `Username`, `Key`, `Salt`, `Online` FROM `accounts` WHERE `Username` = '%s'", GetPlayerNameExt(playerid));
	mysql_tquery(MainPipeline, string, "OnQueryFinish", "iii", LOGIN_THREAD, playerid, g_arrQueryHandle{playerid});
	return 1;
}

// g_mysql_AccountAuthCheck(playerid)
g_mysql_AccountAuthCheck(playerid)
{
	new string[128];

	mysql_format(MainPipeline, string, sizeof(string), "SELECT `Username` FROM `accounts` WHERE `Username` = '%s'", GetPlayerNameExt(playerid));
	mysql_tquery(MainPipeline, string, "OnQueryFinish", "iii", AUTH_THREAD, playerid, g_arrQueryHandle{playerid});

	// Reset the GUI
	//SetPlayerJoinCamera(playerid);
	ClearChatbox(playerid);
	SetPlayerVirtualWorld(playerid, 0);


	return 1;
}

// g_mysql_AccountOnline(int playerid, int stateid)
stock g_mysql_AccountOnline(playerid, stateid)
{
	new iTimeStamp = gettime();
	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "UPDATE `accounts` SET `Online`=%d, `LastLogin` = NOW() WHERE `id` = %d", stateid, GetPlayerSQLId(playerid));
	mysql_tquery(MainPipeline, szMiscArray, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
	if(PlayerInfo[playerid][pPhousekey] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[playerid][pPhousekey]][hOwnerID] == GetPlayerSQLId(playerid))
		HouseInfo[PlayerInfo[playerid][pPhousekey]][hLastLogin] = iTimeStamp, SaveHouse(PlayerInfo[playerid][pPhousekey]);
	if(PlayerInfo[playerid][pPhousekey2] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[playerid][pPhousekey2]][hOwnerID] == GetPlayerSQLId(playerid))
		HouseInfo[PlayerInfo[playerid][pPhousekey2]][hLastLogin] = iTimeStamp, SaveHouse(PlayerInfo[playerid][pPhousekey2]);
	if(PlayerInfo[playerid][pPhousekey3] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[playerid][pPhousekey3]][hOwnerID] == GetPlayerSQLId(playerid))
		HouseInfo[PlayerInfo[playerid][pPhousekey3]][hLastLogin] = iTimeStamp, SaveHouse(PlayerInfo[playerid][pPhousekey3]);

	for(new i; i != MAX_DDOORS; i++)
	{
		if(DDoorsInfo[i][ddType] == 1 && DDoorsInfo[i][ddOwner] == GetPlayerSQLId(playerid)) DDoorsInfo[i][ddLastLogin] = gettime(), SaveDynamicDoor(i);
	}
	return 1;
}

stock g_mysql_AccountOnlineReset()
{
	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "UPDATE `accounts` SET `Online` = 0 WHERE `Online` = %d", servernumber);
	mysql_tquery(MainPipeline, szMiscArray, "OnQueryFinish", "i", SENDDATA_THREAD);
	return 1;
}

// g_mysql_CreateAccount(int playerid, string accountPassword[])
// Description: Creates a new account in the database.
stock g_mysql_CreateAccount(playerid, accountPassword[])
{
	new string[300];
	new passbuffer[129];
	new salt[11];
	randomString(salt);
	format(string, sizeof(string), "%s%s", accountPassword, salt);
	WP_Hash(passbuffer, sizeof(passbuffer), string);

	mysql_format(MainPipeline, string, sizeof(string), "INSERT INTO `accounts` (`RegiDate`, `LastLogin`, `Username`, `Key`, `Salt`) VALUES (NOW(), NOW(), '%s', '%s', '%s')", GetPlayerNameExt(playerid), passbuffer, salt);
	mysql_tquery(MainPipeline, string, "OnQueryFinish", "iii", REGISTER_THREAD, playerid, g_arrQueryHandle{playerid});
	return 1;
}

stock g_mysql_LoadPVehicles(playerid)
{
    new string[128];
	mysql_format(MainPipeline, string, sizeof(string), "SELECT * FROM `vehicles` WHERE `sqlID` = %d", PlayerInfo[playerid][pId]);
	mysql_tquery(MainPipeline, string, "OnQueryFinish", "iii", LOADPVEHICLE_THREAD, playerid, g_arrQueryHandle{playerid});
	return 1;
}

// g_mysql_LoadPVehiclePositions(playerid)
// Description: Loads vehicle positions if person has timed out.
stock g_mysql_LoadPVehiclePositions(playerid)
{
	new string[128];

	mysql_format(MainPipeline, string, sizeof(string), "SELECT * FROM `pvehpositions` WHERE `id` = %d", PlayerInfo[playerid][pId]);
	mysql_tquery(MainPipeline, string, "OnQueryFinish", "iii", LOADPVEHPOS_THREAD, playerid, g_arrQueryHandle{playerid});
	return 1;
}

// g_mysql_LoadPlayerToys(playerid)
// Description: Load the player toys
stock g_mysql_LoadPlayerToys(playerid)
{
	new szQuery[128];
	mysql_format(MainPipeline, szQuery, sizeof(szQuery), "SELECT * FROM `toys` WHERE `player` = %d", PlayerInfo[playerid][pId]);
	mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "iii", LOADPTOYS_THREAD, playerid, g_arrQueryHandle{playerid});
	return 1;
}

// g_mysql_LoadAccount(playerid)
// Description: Loads an account from database into memory.
stock g_mysql_LoadAccount(playerid)
{
	ShowNoticeGUIFrame(playerid, 3);

	new string[164];
	mysql_format(MainPipeline, string, sizeof(string), "SELECT * FROM `accounts` WHERE `Username` = '%s'", GetPlayerNameExt(playerid));
 	mysql_tquery(MainPipeline, string, "OnQueryFinish", "iii", LOADUSERDATA_THREAD, playerid, g_arrQueryHandle{playerid});
	return 1;
}

// g_mysql_RemoveDumpFile(sqlid)
// Description: Removes a account's dump file. Helpful upon logoff.
stock g_mysql_RemoveDumpFile(sqlid)
{
	new pwnfile[128];
	format(pwnfile, sizeof(pwnfile), "/accdump/%d.dump", sqlid);

	if(fexist(pwnfile))
	{
		fremove(pwnfile);
		return 1;
	}
	return 0;
}

GivePlayerCredits(Player, Amount, Shop, option = 0)
{
	new szQuery[128];
	if(option == 0)
	{
		PlayerInfo[Player][pCredits] += Amount;
	}
	else if(option == 1)
	{
		PlayerInfo[Player][pCredits] -= Amount;
	}

	mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `accounts` SET `Credits`=%d WHERE `id` = %d", PlayerInfo[Player][pCredits], GetPlayerSQLId(Player));
	mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "ii", SENDDATA_THREAD, Player);
	print(szQuery);

	if(Shop == 1)
	{
    	if(Amount < 0) Amount = Amount*-1;
		PlayerInfo[Player][pTotalCredits] += Amount;
	}

	mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `accounts` SET `TotalCredits`=%d WHERE `id` = %d", PlayerInfo[Player][pTotalCredits], GetPlayerSQLId(Player));
	mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "ii", SENDDATA_THREAD, Player);
	print(szQuery);
}

// native g_mysql_SaveToys(int playerid, int slotid)
stock g_mysql_SaveToys(playerid, slotid)
{
	new szQuery[2048];

	if(PlayerToyInfo[playerid][slotid][ptID] >= 1) // Making sure the player actually has a toy so we won't save a empty row
	{
		//printf("%s (%i) saving toy %i...", GetPlayerNameEx(playerid), playerid, slotid);

		mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `toys` SET `modelid` = '%d', `bone` = '%d', `posx` = '%f', `posy` = '%f', `posz` = '%f', `rotx` = '%f', `roty` = '%f', `rotz` = '%f', `scalex` = '%f', `scaley` = '%f', `scalez` = '%f', `tradable` = '%d', `autoattach` = '%d' WHERE `id` = '%d'",
		PlayerToyInfo[playerid][slotid][ptModelID],
		PlayerToyInfo[playerid][slotid][ptBone],
		PlayerToyInfo[playerid][slotid][ptPosX],
		PlayerToyInfo[playerid][slotid][ptPosY],
		PlayerToyInfo[playerid][slotid][ptPosZ],
		PlayerToyInfo[playerid][slotid][ptRotX],
		PlayerToyInfo[playerid][slotid][ptRotY],
		PlayerToyInfo[playerid][slotid][ptRotZ],
		PlayerToyInfo[playerid][slotid][ptScaleX],
		PlayerToyInfo[playerid][slotid][ptScaleY],
		PlayerToyInfo[playerid][slotid][ptScaleZ],
		PlayerToyInfo[playerid][slotid][ptTradable],
		PlayerToyInfo[playerid][slotid][ptAutoAttach],
		PlayerToyInfo[playerid][slotid][ptID]);

		mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
	}
}

// native g_mysql_NewToy(int playerid, int slotid)
stock g_mysql_NewToy(playerid, slotid)
{
	new szQuery[2048];
	//if(PlayerToyInfo[playerid][slotid][ptSpecial] != 1) { PlayerToyInfo[playerid][slotid][ptSpecial] = 0; }

	format(szQuery, sizeof(szQuery), "INSERT INTO `toys` (player, modelid, bone, posx, posy, posz, rotx, roty, rotz, scalex, scaley, scalez, tradable, special, autoattach) VALUES ('%d', '%d', '%d', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%d', '%d', '%d')",
	PlayerInfo[playerid][pId],
	PlayerToyInfo[playerid][slotid][ptModelID],
	PlayerToyInfo[playerid][slotid][ptBone],
	PlayerToyInfo[playerid][slotid][ptPosX],
	PlayerToyInfo[playerid][slotid][ptPosY],
	PlayerToyInfo[playerid][slotid][ptPosZ],
	PlayerToyInfo[playerid][slotid][ptRotX],
	PlayerToyInfo[playerid][slotid][ptRotY],
	PlayerToyInfo[playerid][slotid][ptRotZ],
	PlayerToyInfo[playerid][slotid][ptScaleX],
	PlayerToyInfo[playerid][slotid][ptScaleY],
	PlayerToyInfo[playerid][slotid][ptScaleZ],
	PlayerToyInfo[playerid][slotid][ptTradable],
	PlayerToyInfo[playerid][slotid][ptSpecial],
	PlayerToyInfo[playerid][slotid][ptAutoAttach]);

	mysql_tquery(MainPipeline, szQuery, "OnQueryCreateToy", "ii", playerid, slotid);
}

// g_mysql_LoadMOTD()
// Description: Loads the MOTDs from the MySQL Database.
stock g_mysql_LoadMOTD()
{
	mysql_tquery(MainPipeline, "SELECT * FROM `misc`", "OnQueryFinish", "iii", LOADMOTDDATA_THREAD, INVALID_PLAYER_ID, -1);
}

stock g_mysql_LoadSales()
{
	mysql_tquery(MainPipeline, "SELECT * FROM `sales` WHERE `Month` > NOW() - INTERVAL 1 MONTH", "OnQueryFinish", "iii", LOADSALEDATA_THREAD, INVALID_PLAYER_ID, -1);
	//mysql_tquery(MainPipeline, "SELECT `TotalToySales`,`TotalCarSales`,`GoldVIPSales`,`SilverVIPSales`,`BronzeVIPSales` FROM `sales` WHERE `Month` > NOW() - INTERVAL 1 MONTH", true, "OnQueryFinish", "iii", LOADSALEDATA_THREAD, INVALID_PLAYER_ID, -1);
}

stock g_mysql_LoadPrices()
{
    mysql_tquery(MainPipeline, "SELECT * FROM `shopprices`", "OnQueryFinish", "iii", LOADSHOPDATA_THREAD, INVALID_PLAYER_ID, -1);
}

stock g_mysql_SavePrices()
{
	new query[2000];
	strins(query, "UPDATE `shopprices` SET ", 0);
	for(new p = 0; p < MAX_ITEMS; p++)
	{
		format(query, sizeof(query), "%s`Price%d` = '%d', ", query, p, ShopItems[p][sItemPrice]);
	}
	new mString[128];
	for(new m; m < MAX_MICROITEMS; m++)
	{
		format(mString, sizeof(mString), "%s%d", mString, MicroItems[m]);
		if(m != MAX_MICROITEMS-1) strcat(mString, "|");
	}
	mysql_format(MainPipeline, query, sizeof(query), "%s`MicroPrices` = '%s'", query, mString);
    mysql_tquery(MainPipeline, query, "OnQueryFinish", "i", SENDDATA_THREAD);
}
stock g_mysql_SaveMOTD()
{
	new query[1500];

	mysql_format(MainPipeline, query, sizeof(query), "UPDATE `misc` SET ");

	mysql_format(MainPipeline, query, sizeof(query), "%s `gMOTD` = '%e',", query, GlobalMOTD);
	mysql_format(MainPipeline, query, sizeof(query), "%s `aMOTD` = '%e',", query, AdminMOTD);
	mysql_format(MainPipeline, query, sizeof(query), "%s `vMOTD` = '%e',", query, VIPMOTD);
	mysql_format(MainPipeline, query, sizeof(query), "%s `cMOTD` = '%e',", query, CAMOTD);
	mysql_format(MainPipeline, query, sizeof(query), "%s `pMOTD` = '%e',", query, pMOTD);
	mysql_format(MainPipeline, query, sizeof(query), "%s `prisonerMOTD` = '%e',", query, prisonerMOTD[0]);
	mysql_format(MainPipeline, query, sizeof(query), "%s `prisonerMOTD2` = '%e',", query, prisonerMOTD[1]);
	mysql_format(MainPipeline, query, sizeof(query), "%s `prisonerMOTD3` = '%e',", query, prisonerMOTD[2]);
	mysql_format(MainPipeline, query, sizeof(query), "%s `ShopTechPay` = '%.2f',", query, ShopTechPay);
	mysql_format(MainPipeline, query, sizeof(query), "%s `GiftCode` = '%e',", query, GiftCode);
	mysql_format(MainPipeline, query, sizeof(query), "%s `GiftCodeBypass` = '%d',", query, GiftCodeBypass);
	mysql_format(MainPipeline, query, sizeof(query), "%s `TotalCitizens` = '%d',", query, TotalCitizens);
	mysql_format(MainPipeline, query, sizeof(query), "%s `TRCitizens` = '%d',", query, TRCitizens);
	mysql_format(MainPipeline, query, sizeof(query), "%s `ShopClosed` = '%d',", query, ShopClosed);
	mysql_format(MainPipeline, query, sizeof(query), "%s `RimMod` = '%d',", query, RimMod);
	mysql_format(MainPipeline, query, sizeof(query), "%s `CarVoucher` = '%d',", query, CarVoucher);
	mysql_format(MainPipeline, query, sizeof(query), "%s `PVIPVoucher` = '%d',", query, PVIPVoucher);
	mysql_format(MainPipeline, query, sizeof(query), "%s `GarageVW` = '%d',", query, GarageVW);
	mysql_format(MainPipeline, query, sizeof(query), "%s `PumpkinStock` = '%d',", query, PumpkinStock);
	mysql_format(MainPipeline, query, sizeof(query), "%s `HalloweenShop` = '%d',", query, HalloweenShop);
	mysql_format(MainPipeline, query, sizeof(query), "%s `PassComplexCheck` = '%d',", query, PassComplexCheck);
	mysql_format(MainPipeline, query, sizeof(query), "%s `GunPrice0` = '%d',", query, GunPrices[0]);
	mysql_format(MainPipeline, query, sizeof(query), "%s `GunPrice1` = '%d',", query, GunPrices[1]);
	mysql_format(MainPipeline, query, sizeof(query), "%s `GunPrice2` = '%d',", query, GunPrices[2]);
	mysql_format(MainPipeline, query, sizeof(query), "%s `GunPrice3` = '%d',", query, GunPrices[3]);
	mysql_format(MainPipeline, query, sizeof(query), "%s `GunPrice4` = '%d',", query, GunPrices[4]);
	mysql_format(MainPipeline, query, sizeof(query), "%s `GunPrice5` = '%d'", query, GunPrices[5]);
	CallLocalFunction("SaveInactiveResourceSettings", "is", sizeof(query), query);

	new qryLength = strlen(query);
	if(query[qryLength-1] == ',') strdel(query, qryLength-1, qryLength);
	mysql_tquery(MainPipeline, query, "OnQueryFinish", "i", SENDDATA_THREAD);
}
// g_mysql_LoadMOTD()
// Description: Loads the Crates from the MySQL Database.

/*stock RemoveBan(Player, Ip[])
{
	new string[128];
	SetPVarString(Player, "UnbanIP", Ip);
	format(string, sizeof(string), "SELECT `ip` FROM `ip_bans` WHERE `ip` = '%s'", Ip);
	mysql_tquery(MainPipeline, string, true, "AddingBan", "ii", Player, 2);
	return 1;
}*/

stock CheckBanEx(playerid)
{
	new string[280];
	mysql_format(MainPipeline, string, sizeof(string), "SELECT `IP` FROM `ban` WHERE `IP` = '%s' AND `active` = '1'", GetPlayerIpEx(playerid));
	mysql_tquery(MainPipeline, string, "OnQueryFinish", "iii", IPBAN_THREAD, playerid, g_arrQueryHandle{playerid});
	return 1;
}

stock AddBan(Admin, Player, Reason[])
{
    new string[128];
	SetPVarInt(Admin, "BanningPlayer", Player);
	SetPVarString(Admin, "BanningReason", Reason);
	mysql_format(MainPipeline, string, sizeof(string), "SELECT `ip` FROM `ip_bans` WHERE `ip` = '%s'", GetPlayerIpEx(Player));
	mysql_tquery(MainPipeline, string, "AddingBan", "ii", Admin, 1);
	return 1;
}


stock SystemBan(Player, Reason[])
{
	new string[256];
    mysql_format(MainPipeline, string, sizeof(string), "INSERT INTO `ip_bans` (`ip`, `date`, `reason`, `admin`) VALUES ('%s', NOW(), '%e', 'System')", GetPlayerIpEx(Player), Reason);
	mysql_tquery(MainPipeline, string, "OnQueryFinish", "i", SENDDATA_THREAD);
	return 1;
}


stock MySQLBan(userid,ip[],reason[],status,admin[])
{
	new string[256];
    mysql_format(MainPipeline, string, sizeof(string), "INSERT INTO `bans` (`user_id`, `ip_address`, `reason`, `date_added`, `status`, `admin`) VALUES ('%d','%s','%e', NOW(), '%d','%e')", userid, ip, reason, status, admin);
	mysql_tquery(MainPipeline, string, "OnQueryFinish", "i", SENDDATA_THREAD);
	return 1;
}

stock AddCrime(cop, suspect, crime[])
{
	new query[256], iAllegiance;
	if((0 <= PlayerInfo[cop][pMember] < MAX_GROUPS))
	{
		iAllegiance = arrGroupData[PlayerInfo[cop][pMember]][g_iAllegiance];
	}
	else iAllegiance = 1;
	mysql_format(MainPipeline, query, sizeof(query), "INSERT INTO `mdc` (`id` ,`time` ,`issuer` ,`crime`, `origin`) VALUES ('%d', NOW(), '%e', '%e', '%d')", GetPlayerSQLId(suspect), GetPlayerNameEx(cop), crime, iAllegiance);
	mysql_tquery(MainPipeline, query, "OnQueryFinish", "i", SENDDATA_THREAD);
	format(query, sizeof(query), "MDC: %s(%d) added crime %s to %s(%d).", GetPlayerNameEx(cop), GetPlayerSQLId(cop), crime, GetPlayerNameEx(suspect), GetPlayerSQLId(suspect));
	Log("logs/crime.log", query);
	return 1;
}

stock ClearCrimes(playerid, clearerid = INVALID_PLAYER_ID)
{
	new query[220], iAllegiance;
	if(clearerid != INVALID_PLAYER_ID && (0 <= PlayerInfo[clearerid][pMember] < MAX_GROUPS))
	{
		iAllegiance = arrGroupData[PlayerInfo[clearerid][pMember]][g_iAllegiance];
		mysql_format(MainPipeline, query, sizeof(query), "UPDATE `mdc` SET `active`= 0 WHERE `id` = %i AND `active` = 1 AND origin = %d", GetPlayerSQLId(playerid), iAllegiance);
	}
	else {
		mysql_format(MainPipeline, query, sizeof(query), "UPDATE `mdc` SET `active`= 0 WHERE `id` = %i AND `active` = 1", GetPlayerSQLId(playerid));
	}
	mysql_tquery(MainPipeline, query, "OnQueryFinish", "i", SENDDATA_THREAD);
	return 1;
}

stock DisplayCrimes(playerid, suspectid)
{
    new query[128], iAllegiance;
	if((0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS))
	{
		iAllegiance = arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance];
	}
	else iAllegiance = 1;
    mysql_format(MainPipeline, query, sizeof(query), "SELECT issuer, crime, active FROM `mdc` WHERE `id` = '%d' AND `origin` = '%d' ORDER BY `time` AND `active` DESC LIMIT 12", GetPlayerSQLId(suspectid), iAllegiance);
    mysql_tquery(MainPipeline, query, "MDCQueryFinish", "ii", playerid, suspectid);
	return 1;
}

stock DisplayReports(playerid, suspectid)
{
    new query[812], iAllegiance;
	if((0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS))
	{
		iAllegiance = arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance];
	}
	else iAllegiance = 1;
    mysql_format(MainPipeline, query, sizeof(query), "SELECT arrestreports.id, copid, shortreport, datetime, accounts.id, accounts.Username FROM `arrestreports` LEFT JOIN `accounts` ON	arrestreports.copid=accounts.id WHERE arrestreports.suspectid=%d AND arrestreports.origin=%d ORDER BY arrestreports.datetime DESC LIMIT 12", GetPlayerSQLId(suspectid), iAllegiance);
    mysql_tquery(MainPipeline, query, "MDCReportsQueryFinish", "ii", playerid, suspectid);
	return 1;
}

stock DisplayReport(playerid, reportid)
{
    new query[812];
    mysql_format(MainPipeline, query, sizeof(query), "SELECT arrestreports.id, copid, shortreport, datetime, accounts.id, accounts.Username FROM `arrestreports` LEFT JOIN `accounts` ON	arrestreports.copid=accounts.id WHERE arrestreports.id=%d ORDER BY arrestreports.datetime DESC LIMIT 12", reportid);
    mysql_tquery(MainPipeline, query, "MDCReportQueryFinish", "ii", playerid, reportid);
	return 1;
}

stock SetUnreadMailsNotification(playerid)
{
    new query[128];
    mysql_format(MainPipeline, query, sizeof(query), "SELECT COUNT(*) AS Unread_Count FROM letters WHERE Receiver_ID = %d AND `Read` = 0", GetPlayerSQLId(playerid));
    mysql_tquery(MainPipeline, query, "UnreadMailsNotificationQueryFin", "i", playerid);
	return 1;
}

stock DisplayMails(playerid)
{
    new query[150];
    mysql_format(MainPipeline, query, sizeof(query), "SELECT `Id`, `Message`, `Read` FROM `letters` WHERE `Receiver_Id` = %d AND `Delivery_Min` = 0 ORDER BY `Id` DESC LIMIT 50", GetPlayerSQLId(playerid));
    mysql_tquery(MainPipeline, query, "MailsQueryFinish", "i", playerid);
}

stock DisplayMailDetails(playerid, letterid)
{
    new query[256];
    mysql_format(MainPipeline, query, sizeof(query), "SELECT `Id`, `Date`, `Sender_Id`, `Read`, `Notify`, `Message`, (SELECT `Username` FROM `accounts` WHERE `id` = letters.Sender_Id) AS `SenderUser` FROM `letters` WHERE id = %d", letterid);
    mysql_tquery(MainPipeline, query, "MailDetailsQueryFinish", "i", playerid);
}

stock CountFlags(playerid)
{
	new query[80];
	mysql_format(MainPipeline, query, sizeof(query), "SELECT * FROM `flags` WHERE id=%d AND type = 1", GetPlayerSQLId(playerid));
	mysql_tquery(MainPipeline, query, "FlagQueryFinish", "iii", playerid, INVALID_PLAYER_ID, Flag_Query_Count);
	return 1;
}

stock AddFlag(playerid, adminid, flag[], type = 1)
{
	new query[300];
	new admin[24];
	if(adminid != INVALID_PLAYER_ID) {
		format(admin, sizeof(admin), "%s", GetPlayerNameEx(adminid));
	}
	else {
		format(admin, sizeof(admin), "Gifted/Script Added");
	}
	PlayerInfo[playerid][pFlagged]++;
	mysql_format(MainPipeline, query, sizeof(query), "INSERT INTO `flags` (`id` ,`time` ,`issuer` ,`flag`, `type`) VALUES ('%d',NOW(),'%e','%e','%d')", GetPlayerSQLId(playerid), admin, flag, type);
	mysql_tquery(MainPipeline, query, "OnAddFlag", "iss", playerid, admin, flag);
	return 1;
}

forward OnAddFlag(target, admin[], flag[]);
public OnAddFlag(target, admin[], flag[])
{
	new string[128], flag_sqlid = cache_insert_id();
	format(string, sizeof(string), "FLAG (%d): %s added flag \"%s\" to %s(%d)", flag_sqlid, admin, flag, GetPlayerNameEx(target), GetPlayerSQLId(target));
	Log("logs/flags.log", string);
	return 1;
}

stock AddOFlag(sqlid, adminid, flag[]) // offline add
{
	new query[300];
	new admin[24], name[24];
	if(adminid != INVALID_PLAYER_ID) {
		format(admin, sizeof(admin), "%s", GetPlayerNameEx(adminid));
	}
	else {
		format(admin, sizeof(admin), "Gifted/Script Added");
	}
	GetPVarString(adminid, "OnAddFlag", name, sizeof(name));
	mysql_format(MainPipeline, query, sizeof(query), "INSERT INTO `flags` (`id` ,`time` ,`issuer` ,`flag`) VALUES ('%d',NOW(),'%e','%e')", sqlid, admin, flag);
	mysql_tquery(MainPipeline, query, "OnAddOFlag", "isss", sqlid, name, admin, flag);
	DeletePVar(adminid, "OnAddFlag");
	return 1;
}

forward OnAddOFlag(psqlid, name[], admin[], flag[]);
public OnAddOFlag(psqlid, name[], admin[], flag[])
{
	new string[128], flag_sqlid = cache_insert_id();
	format(string, sizeof(string), "OFLAG (%d): %s added flag \"%s\" to %s(%d)", flag_sqlid, admin, flag, name, psqlid);
	Log("logs/flags.log", string);
	return 1;
}

forward OnRequestDeleteFlag(playerid, flagid);
public OnRequestDeleteFlag(playerid, flagid)
{
	new rows, fields, value, string[256];
	new FlagText[64], FlagIssuer[MAX_PLAYER_NAME], FlagDate[24];
	cache_get_row_count(rows);
	cache_get_field_count(fields);
	if(!rows) return ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "{FF0000}Flag Error:", "Flag does not exist!", "Close", "");
	cache_get_value_name_int(0, "type", value);
	if(value == 2 && PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1) return ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "{FF0000}Flag Error:", "Only Senior Admins+ can remove administrative flags!", "Close", "");
	cache_get_value_name(0, "flag", FlagText, 64);
	cache_get_value_name(0, "issuer", FlagIssuer, MAX_PLAYER_NAME);
	cache_get_value_name(0, "time", FlagDate, 24);
	SetPVarInt(playerid, "Flag_Delete_ID", flagid);
	SetPVarString(playerid, "FlagText", FlagText);
	format(string, sizeof(string), "Are you sure you want to delete:\n{FF6347}Flag ID:{BFC0C2} %d\n{FF6347}Flag:{BFC0C2} %s\n{FF6347}Issued by:{BFC0C2} %s\n{FF6347}Date Issued: {BFC0C2}%s", flagid, FlagText, FlagIssuer, FlagDate);
	return ShowPlayerDialogEx(playerid, FLAG_DELETE2, DIALOG_STYLE_MSGBOX, "FLAG DELETION", string, "Yes", "No");
}

stock DeleteFlag(flagid, adminid)
{
	new query[256], flagtext[64];
	GetPVarString(adminid, "FlagText", flagtext, sizeof(flagtext));
	format(query, sizeof(query), "FLAG (%d): \"%s\" was deleted by %s.", flagid, flagtext, GetPlayerNameEx(adminid));
	Log("logs/flags.log", query);
	mysql_format(MainPipeline, query, sizeof(query), "DELETE FROM `flags` WHERE `fid` = %i", flagid);
	mysql_tquery(MainPipeline, query, "OnQueryFinish", "i", SENDDATA_THREAD);
	DeletePVar(adminid, "Flag_Delete_ID");
	DeletePVar(adminid, "FlagText");
	return 1;
}

stock DisplayFlags(playerid, targetid, type = 1)
{
	new query[128];
	CountFlags(targetid);
	mysql_format(MainPipeline, query, sizeof(query), "SELECT fid, flag FROM `flags` WHERE id=%d AND type = %d ORDER BY `time` LIMIT 20", GetPlayerSQLId(targetid), type);
	mysql_tquery(MainPipeline, query, "FlagQueryFinish", "iii", playerid, targetid, Flag_Query_Display);
	SetPVarInt(playerid, "viewingflags", targetid);
	DeletePVar(playerid, "ManageFlagID");
	return 1;
}

stock CountSkins(playerid)
{
	new query[80];
	mysql_format(MainPipeline, query, sizeof(query), "SELECT NULL FROM `house_closet` WHERE playerid = %d", GetPlayerSQLId(playerid));
	mysql_tquery(MainPipeline, query, "SkinQueryFinish", "ii", playerid, Skin_Query_Count);
	return 1;
}

stock AddSkin(playerid, skinid)
{
	new query[300];
	PlayerInfo[playerid][pSkins]++;
	mysql_format(MainPipeline, query, sizeof(query), "INSERT INTO `house_closet` (`id`, `playerid`, `skinid`) VALUES (NULL, '%d', '%d')", GetPlayerSQLId(playerid), skinid);
	mysql_tquery(MainPipeline, query, "OnQueryFinish", "i", SENDDATA_THREAD);
	return 1;
}

stock DeleteSkin(skinid)
{
	new query[80];
	mysql_format(MainPipeline, query, sizeof(query), "DELETE FROM `house_closet` WHERE `id` = %i", skinid);
	mysql_tquery(MainPipeline, query, "OnQueryFinish", "i", SENDDATA_THREAD);
	return 1;
}

stock DisplaySkins(playerid)
{
    new query[128];
	CountSkins(playerid);
    mysql_format(MainPipeline, query, sizeof(query), "SELECT `skinid` FROM `house_closet` WHERE playerid = %d ORDER BY `skinid` ASC", GetPlayerSQLId(playerid));
    mysql_tquery(MainPipeline, query, "SkinQueryFinish", "ii", playerid, Skin_Query_Display);
	return 1;
}

stock CountCitizens()
{
	mysql_tquery(MainPipeline, "SELECT NULL FROM `accounts` WHERE `Nation` = 1 && `UpdateDate` > NOW() - INTERVAL 1 WEEK", "CitizenQueryFinish", "i", TR_Citizen_Count);
	mysql_tquery(MainPipeline, "SELECT NULL FROM `accounts` WHERE `UpdateDate` > NOW() - INTERVAL 1 WEEK", "CitizenQueryFinish", "i", Total_Count);
	return 1;
}

stock CheckNationQueue(playerid, nation)
{
	new query[300];
	mysql_format(MainPipeline, query, sizeof(query), "SELECT NULL FROM `nation_queue` WHERE `playerid` = %d AND `status` = 1", GetPlayerSQLId(playerid));
	mysql_tquery(MainPipeline, query, "NationQueueQueryFinish", "iii", playerid, nation, CheckQueue);
}

stock AddNationQueue(playerid, nation, status)
{
	new query[300];
	if(nation == 0)
	{
		mysql_format(MainPipeline, query, sizeof(query), "INSERT INTO `nation_queue` (`id`, `playerid`, `name`, `date`, `nation`, `status`) VALUES (NULL, %d, '%s', NOW(), 0, %d)", GetPlayerSQLId(playerid), GetPlayerNameExt(playerid), status);
		mysql_tquery(MainPipeline, query, "OnQueryFinish", "i", SENDDATA_THREAD);
	}
	if(nation == 1)
	{
		if(status == 1)
		{
			mysql_format(MainPipeline, query, sizeof(query), "SELECT NULL FROM `nation_queue` WHERE `playerid` = %d AND `nation` = 1", GetPlayerSQLId(playerid));
			mysql_tquery(MainPipeline, query, "NationQueueQueryFinish", "iii", playerid, nation, AddQueue);
		}
		else if(status == 2)
		{
			mysql_format(MainPipeline, query, sizeof(query), "INSERT INTO `nation_queue` (`id`, `playerid`, `name`, `date`, `nation`, `status`) VALUES (NULL, %d, '%s', NOW(), 1, %d)", GetPlayerSQLId(playerid), GetPlayerNameExt(playerid), status);
			mysql_tquery(MainPipeline, query, "OnQueryFinish", "i", SENDDATA_THREAD);
			PlayerInfo[playerid][pNation] = 1;
		}
	}
	return 1;
}

stock UpdateCitizenApp(playerid, nation)
{
	new query[300];
	mysql_format(MainPipeline, query, sizeof(query), "SELECT NULL FROM `nation_queue` WHERE `playerid` = %d AND `status` = 1", GetPlayerSQLId(playerid));
	mysql_tquery(MainPipeline, query, "NationQueueQueryFinish", "iii", playerid, nation, UpdateQueue);
}

stock AddTicket(playerid, number)
{
	new query[80];
	PlayerInfo[playerid][pLottoNr]++;
	mysql_format(MainPipeline, query, sizeof(query), "INSERT INTO `lotto` (`id` ,`number`) VALUES ('%d', '%d')", GetPlayerSQLId(playerid), number);
	mysql_tquery(MainPipeline, query, "OnQueryFinish", "i", SENDDATA_THREAD);
	return 1;
}

stock DeleteTickets(playerid)
{
	new query[80];
	mysql_format(MainPipeline, query, sizeof(query), "DELETE FROM `lotto` WHERE `id` = %i", GetPlayerSQLId(playerid));
	mysql_tquery(MainPipeline, query, "OnQueryFinish", "i", SENDDATA_THREAD);
	return 1;
}

stock LoadTickets(playerid)
{
    new query[128];
    mysql_format(MainPipeline, query, sizeof(query), "SELECT `tid`, `number` FROM `lotto` WHERE `id` = %d LIMIT 5", GetPlayerSQLId(playerid));
    mysql_tquery(MainPipeline, query, "LoadTicket", "i", playerid);
	return 1;
}

stock CountTickets(playerid)
{
	new query[80];
	mysql_format(MainPipeline, query, sizeof(query), "SELECT * FROM `lotto` WHERE `id` = %i", GetPlayerSQLId(playerid));
	mysql_tquery(MainPipeline, query, "CountAmount", "i", playerid);
	return 1;
}

stock LoadTreasureInventory(playerid)
{
	new query[175];
	mysql_format(MainPipeline, query, sizeof(query), "SELECT `junkmetal`, `newcoin`, `oldcoin`, `brokenwatch`, `oldkey`, `treasure`, `goldwatch`, `silvernugget`, `goldnugget` FROM `jobstuff` WHERE `pId` = %d", GetPlayerSQLId(playerid));
    mysql_tquery(MainPipeline, query, "LoadTreasureInvent", "i", playerid);
	return 1;
}

stock SaveTreasureInventory(playerid)
{
    new string[220];
	mysql_format(MainPipeline, string, sizeof(string), "UPDATE `jobstuff` SET `junkmetal` = %d, `newcoin` = %d, `oldcoin` = %d, `brokenwatch` = %d, `oldkey` = %d, \
 	`treasure` = %d, `goldwatch` = %d, `silvernugget` = %d, `goldnugget` =%d  WHERE `pId` = %d", GetPVarInt(playerid, "junkmetal"), GetPVarInt(playerid, "newcoin"), GetPVarInt(playerid, "oldcoin"),
 	GetPVarInt(playerid, "brokenwatch"), GetPVarInt(playerid, "oldkey"), GetPVarInt(playerid, "treasure"), GetPVarInt(playerid, "goldwatch"), GetPVarInt(playerid, "silvernugget"), GetPVarInt(playerid, "goldnugget"), GetPlayerSQLId(playerid));
	mysql_tquery(MainPipeline, string, "OnQueryFinish", "i", SENDDATA_THREAD);
	return 1;
}

stock SQL_Log(const szQuery[], const szDesc[] = "none", iExtraID = 0) {
	new i_dateTime[2][3];
	gettime(i_dateTime[0][0], i_dateTime[0][1], i_dateTime[0][2]);
	getdate(i_dateTime[1][0], i_dateTime[1][1], i_dateTime[1][2]);

	printf("Dumping query from %i/%i/%i (%i:%i:%i)\r\nDescription: %s (index %i). Query:\r\n", i_dateTime[1][0], i_dateTime[1][1], i_dateTime[1][2], i_dateTime[0][0], i_dateTime[0][1], i_dateTime[0][2], szDesc, iExtraID);
	if(strlen(szQuery) > 1023)
	{
	    new sz_print[1024];
	    new Float:maxfloat = strlen(szQuery)/1023;
		for(new x;x<=floatround(maxfloat, floatround_ceil);x++)
		{
		    strmid(sz_print, szQuery, 0+(x*1023), 1023+(x*1023));
		    print(sz_print);
		}
	}
	else
	{
		print(szQuery);
	}
	return 1;
}

stock LoadMailboxes()
{
	printf("[LoadMailboxes] Loading data from database...");
	mysql_tquery(MainPipeline, "SELECT * FROM `mailboxes`", "OnLoadMailboxes", "");
}

stock LoadHGBackpacks()
{
	printf("[Loading Hunger Games] Loading Hunger Games Backpacks from the database, please wait...");
	mysql_tquery(MainPipeline,  "SELECT * FROM `hgbackpacks`", "OnLoadHGBackpacks", "");
}

stock SaveMailbox(id)
{
	new string[512];

	mysql_format(MainPipeline, string, sizeof(string), "UPDATE `mailboxes` SET \
		`VW`=%d, \
		`Int`=%d, \
		`Model`=%d, \
		`PosX`=%f, \
		`PosY`=%f, \
		`PosZ`=%f, \
		`Angle`=%f WHERE `id`=%d",
		MailBoxes[id][mbVW],
		MailBoxes[id][mbInt],
		MailBoxes[id][mbModel],
		MailBoxes[id][mbPosX],
		MailBoxes[id][mbPosY],
		MailBoxes[id][mbPosZ],
		MailBoxes[id][mbAngle],
		id+1
	); // Array starts from zero, MySQL starts at 1 (this is why we are adding one).

	mysql_tquery(MainPipeline, string, "OnQueryFinish", "i", SENDDATA_THREAD);
}

stock IsAdminSpawnedVehicle(vehicleid)
{
	for(new i = 0; i < sizeof(CreatedCars); ++i) {
		if(CreatedCars[i] == vehicleid) return 1;
	}
	return 0;
}

// credits to Luk0r
stock MySQLUpdateBuild(query[], sqlplayerid)
{
	new querylen = strlen(query);
	if (!query[0]) {
		mysql_format(MainPipeline, query, 2048, "UPDATE `accounts` SET ");
	}
	else if (2048-querylen < 200)
	{
		new whereclause[32];
		mysql_format(MainPipeline, whereclause, sizeof(whereclause), " WHERE `id`=%d", sqlplayerid);
		strcat(query, whereclause, 2048);
		mysql_tquery(MainPipeline, query, "OnQueryFinish", "i", SENDDATA_THREAD);
		mysql_format(MainPipeline, query, 2048, "UPDATE `accounts` SET ");
	}
	else if (strfind(query, "=", true) != -1) strcat(query, ",", 2048);
	return 1;
}

stock MySQLUpdateFinish(query[], sqlplayerid)
{
	if (strcmp(query, "WHERE id=", false) == 0) mysql_tquery(MainPipeline, query, "OnQueryFinish", "i", SENDDATA_THREAD);
	else
	{
		new whereclause[32];
		mysql_format(MainPipeline, whereclause, sizeof(whereclause), " WHERE id=%d", sqlplayerid);
		strcat(query, whereclause, 2048);
		mysql_tquery(MainPipeline, query, "OnQueryFinish", "i", SENDDATA_THREAD);
		mysql_format(MainPipeline, query, 2048, "UPDATE `accounts` SET ");
	}
	return 1;
}

stock SavePlayerInteger(query[], sqlid, Value[], Integer)
{
	MySQLUpdateBuild(query, sqlid);
	new updval[64];
	mysql_format(MainPipeline, updval, sizeof(updval), "`%s`=%d", Value, Integer);
	strcat(query, updval, 2048);
	return 1;
}


stock SavePlayerString(query[], sqlid, Value[], String[])
{
	MySQLUpdateBuild(query, sqlid);
	new escapedstring[160], string[160];
	mysql_escape_string(String, escapedstring);
	mysql_format(MainPipeline, string, sizeof(string), "`%s`='%s'", Value, escapedstring);
	strcat(query, string, 2048);
	return 1;
}

stock SavePlayerFloat(query[], sqlid, Value[], Float:Number)
{
	new flotostr[32];
	mysql_format(MainPipeline, flotostr, sizeof(flotostr), "%0.2f", Number);
	SavePlayerString(query, sqlid, Value, flotostr);
	return 1;
}

stock g_mysql_SaveAccount(playerid)
{
    new query[2048];

	mysql_format(MainPipeline, query, 2048, "UPDATE `accounts` SET `SPos_x` = '%0.2f', `SPos_y` = '%0.2f', `SPos_z` = '%0.2f', `SPos_r` = '%0.2f' WHERE id = '%d'",PlayerInfo[playerid][pPos_x], PlayerInfo[playerid][pPos_y], PlayerInfo[playerid][pPos_z], PlayerInfo[playerid][pPos_r], GetPlayerSQLId(playerid));
	mysql_tquery(MainPipeline, query, "OnQueryFinish", "i", SENDDATA_THREAD);

    mysql_format(MainPipeline, query, 2048, "UPDATE `accounts` SET ");
    SavePlayerString(query, GetPlayerSQLId(playerid), "IP", PlayerInfo[playerid][pIP]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Registered", PlayerInfo[playerid][pReg]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "ConnectedTime", PlayerInfo[playerid][pConnectHours]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Sex", PlayerInfo[playerid][pSex]);
    SavePlayerString(query, GetPlayerSQLId(playerid), "BirthDate", PlayerInfo[playerid][pBirthDate]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Band", PlayerInfo[playerid][pBanned]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "PermBand", PlayerInfo[playerid][pPermaBanned]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Warnings", PlayerInfo[playerid][pWarns]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Disabled", PlayerInfo[playerid][pDisabled]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Level", PlayerInfo[playerid][pLevel]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "AdminLevel", PlayerInfo[playerid][pAdmin]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "SeniorModerator", PlayerInfo[playerid][pSMod]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Helper", PlayerInfo[playerid][pHelper]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "DonateRank", PlayerInfo[playerid][pDonateRank]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Respect", PlayerInfo[playerid][pExp]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Money", GetPlayerCash(playerid));

    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Bank", PlayerInfo[playerid][pAccount]);
	if(PlayerInfo[playerid][pHealth] > 150) PlayerInfo[playerid][pHealth] = 150;
	if(PlayerInfo[playerid][pArmor] > 150) PlayerInfo[playerid][pArmor] = 150;
    SavePlayerFloat(query, GetPlayerSQLId(playerid), "pHealth", PlayerInfo[playerid][pHealth]);
    SavePlayerFloat(query, GetPlayerSQLId(playerid), "pArmor", PlayerInfo[playerid][pArmor]);
    SavePlayerFloat(query, GetPlayerSQLId(playerid), "pSHealth", PlayerInfo[playerid][pSHealth]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Int", PlayerInfo[playerid][pInt]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "VirtualWorld", PlayerInfo[playerid][pVW]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Model", PlayerInfo[playerid][pModel]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "BanAppealer", PlayerInfo[playerid][pBanAppealer]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "PR", PlayerInfo[playerid][pPR]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "HR", PlayerInfo[playerid][pHR]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "AP", PlayerInfo[playerid][pAP]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Security", PlayerInfo[playerid][pSecurity]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "ShopTech", PlayerInfo[playerid][pShopTech]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "FactionModerator", PlayerInfo[playerid][pFactionModerator]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "GangModerator", PlayerInfo[playerid][pGangModerator]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Undercover", PlayerInfo[playerid][pUndercover]);

    SavePlayerInteger(query, GetPlayerSQLId(playerid), "TogReports", PlayerInfo[playerid][pTogReports]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Radio", PlayerInfo[playerid][pRadio]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "RadioFreq", PlayerInfo[playerid][pRadioFreq]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "UpgradePoints", PlayerInfo[playerid][gPupgrade]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Origin", PlayerInfo[playerid][pOrigin]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Muted", PlayerInfo[playerid][pMuted]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Crimes", PlayerInfo[playerid][pCrimes]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Accent", PlayerInfo[playerid][pAccent]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "CHits", PlayerInfo[playerid][pCHits]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "FHits", PlayerInfo[playerid][pFHits]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Arrested", PlayerInfo[playerid][pArrested]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Phonebook", PlayerInfo[playerid][pPhoneBook]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "LottoNr", PlayerInfo[playerid][pLottoNr]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Fishes", PlayerInfo[playerid][pFishes]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "BiggestFish", PlayerInfo[playerid][pBiggestFish]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Job", PlayerInfo[playerid][pJob]);

    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Job2", PlayerInfo[playerid][pJob2]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Job3", PlayerInfo[playerid][pJob3]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Paycheck", PlayerInfo[playerid][pPayCheck]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "HeadValue", PlayerInfo[playerid][pHeadValue]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "JailTime", PlayerInfo[playerid][pJailTime]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "WRestricted", PlayerInfo[playerid][pWRestricted]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Materials", PlayerInfo[playerid][pMats]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Crates", PlayerInfo[playerid][pCrates]);
    // SavePlayerInteger(query, GetPlayerSQLId(playerid), "Pot", PlayerInfo[playerid][pPot]);
    // SavePlayerInteger(query, GetPlayerSQLId(playerid), "Crack", PlayerInfo[playerid][pCrack]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Nation", PlayerInfo[playerid][pNation]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Leader", PlayerInfo[playerid][pLeader]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Member", PlayerInfo[playerid][pMember]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Division", PlayerInfo[playerid][pDivision]);
	SavePlayerString(query, GetPlayerSQLId(playerid), "Badge", PlayerInfo[playerid][pBadge]);

    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Rank", PlayerInfo[playerid][pRank]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "DetSkill", PlayerInfo[playerid][pDetSkill]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "SexSkill", PlayerInfo[playerid][pSexSkill]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "BoxSkill", PlayerInfo[playerid][pBoxSkill]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "LawSkill", PlayerInfo[playerid][pLawSkill]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "MechSkill", PlayerInfo[playerid][pMechSkill]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "TruckSkill", PlayerInfo[playerid][pTruckSkill]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "DrugSmuggler", PlayerInfo[playerid][pDrugSmuggler]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "ArmsSkill", PlayerInfo[playerid][pArmsSkill]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "FishSkill", PlayerInfo[playerid][pFishSkill]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "CheckCash", PlayerInfo[playerid][pCheckCash]);

    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Checks", PlayerInfo[playerid][pChecks]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "BoatLic", PlayerInfo[playerid][pBoatLic]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "FlyLic", PlayerInfo[playerid][pFlyLic]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "GunLic", PlayerInfo[playerid][pGunLic]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "FishLic", PlayerInfo[playerid][pFishLic]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "FishSkill", PlayerInfo[playerid][pFishSkill]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "FightingStyle", PlayerInfo[playerid][pFightStyle]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "PhoneNr", PlayerInfo[playerid][pPnumber]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Apartment", PlayerInfo[playerid][pPhousekey]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Apartment2", PlayerInfo[playerid][pPhousekey2]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Apartment3", PlayerInfo[playerid][pPhousekey3]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Renting", PlayerInfo[playerid][pRenting]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "CarLic", PlayerInfo[playerid][pCarLic]);

    SavePlayerInteger(query, GetPlayerSQLId(playerid), "DrugsTime", PlayerInfo[playerid][pDrugsTime]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "LawyerTime", PlayerInfo[playerid][pLawyerTime]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "LawyerFreeTime", PlayerInfo[playerid][pLawyerFreeTime]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "MechTime", PlayerInfo[playerid][pMechTime]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "SexTime", PlayerInfo[playerid][pSexTime]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "PayDay", PlayerInfo[playerid][pConnectSeconds]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "PayDayHad", PlayerInfo[playerid][pPayDayHad]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "CDPlayer", PlayerInfo[playerid][pCDPlayer]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Dice", PlayerInfo[playerid][pDice]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Spraycan", PlayerInfo[playerid][pSpraycan]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Rope", PlayerInfo[playerid][pRope]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Rags", PlayerInfo[playerid][pRags]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Cigars", PlayerInfo[playerid][pCigar]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Sprunk", PlayerInfo[playerid][pSprunk]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Bombs", PlayerInfo[playerid][pBombs]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Wins", PlayerInfo[playerid][pWins]);

    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Loses", PlayerInfo[playerid][pLoses]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Tutorial", PlayerInfo[playerid][pTut]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "OnDuty", PlayerInfo[playerid][pDuty]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Hospital", PlayerInfo[playerid][pHospital]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "MarriedID", PlayerInfo[playerid][pMarriedID]);
    SavePlayerString(query, GetPlayerSQLId(playerid), "ContractBy", PlayerInfo[playerid][pContractBy]);
    SavePlayerString(query, GetPlayerSQLId(playerid), "ContractDetail", PlayerInfo[playerid][pContractDetail]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "WantedLevel", PlayerInfo[playerid][pWantedLevel]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Insurance", PlayerInfo[playerid][pInsurance]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "911Muted", PlayerInfo[playerid][p911Muted]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "NewMuted", PlayerInfo[playerid][pNMute]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "NewMutedTotal", PlayerInfo[playerid][pNMuteTotal]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "AdMuted", PlayerInfo[playerid][pADMute]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "AdMutedTotal", PlayerInfo[playerid][pADMuteTotal]);

    SavePlayerInteger(query, GetPlayerSQLId(playerid), "HelpMute", PlayerInfo[playerid][pHelpMute]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "ReportMuted", PlayerInfo[playerid][pRMuted]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "ReportMutedTotal", PlayerInfo[playerid][pRMutedTotal]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "ReportMutedTime", PlayerInfo[playerid][pRMutedTime]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "DMRMuted", PlayerInfo[playerid][pDMRMuted]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "VIPMuted", PlayerInfo[playerid][pVMuted]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "VIPMutedTime", PlayerInfo[playerid][pVMutedTime]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "GiftTime", PlayerInfo[playerid][pGiftTime]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "AdvisorDutyHours", PlayerInfo[playerid][pDutyHours]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "AcceptedHelp", PlayerInfo[playerid][pAcceptedHelp]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "AcceptReport", PlayerInfo[playerid][pAcceptReport]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "TrashReport", PlayerInfo[playerid][pTrashReport]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "GangWarn", PlayerInfo[playerid][pGangWarn]);

    SavePlayerInteger(query, GetPlayerSQLId(playerid), "CSFBanned", PlayerInfo[playerid][pCSFBanned]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "VIPInviteDay", PlayerInfo[playerid][pVIPInviteDay]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "TempVIP", PlayerInfo[playerid][pTempVIP]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "BuddyInvite", PlayerInfo[playerid][pBuddyInvited]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Tokens", PlayerInfo[playerid][pTokens]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "PTokens", PlayerInfo[playerid][pPaintTokens]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "TriageTime", PlayerInfo[playerid][pTriageTime]);
    SavePlayerString(query, GetPlayerSQLId(playerid), "PrisonedBy", PlayerInfo[playerid][pPrisonedBy]);
    SavePlayerString(query, GetPlayerSQLId(playerid), "PrisonReason", PlayerInfo[playerid][pPrisonReason]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "TaxiLicense", PlayerInfo[playerid][pTaxiLicense]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "TicketTime", PlayerInfo[playerid][pTicketTime]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Screwdriver", PlayerInfo[playerid][pScrewdriver]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Smslog", PlayerInfo[playerid][pSmslog]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Speedo", PlayerInfo[playerid][pSpeedo]);

    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Wristwatch", PlayerInfo[playerid][pWristwatch]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Surveillance", PlayerInfo[playerid][pSurveillance]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Tire", PlayerInfo[playerid][pTire]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Firstaid", PlayerInfo[playerid][pFirstaid]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Rccam", PlayerInfo[playerid][pRccam]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Receiver", PlayerInfo[playerid][pReceiver]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "GPS", PlayerInfo[playerid][pGPS]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Sweep", PlayerInfo[playerid][pSweep]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "SweepLeft", PlayerInfo[playerid][pSweepLeft]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Bugged", PlayerInfo[playerid][pBugged]);

    SavePlayerInteger(query, GetPlayerSQLId(playerid), "pWExists", PlayerInfo[playerid][pWeedObject]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "pWSeeds", PlayerInfo[playerid][pWSeeds]);
    SavePlayerString(query, GetPlayerSQLId(playerid), "Warrants", PlayerInfo[playerid][pWarrant]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "JudgeJailTime", PlayerInfo[playerid][pJudgeJailTime]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "JudgeJailType", PlayerInfo[playerid][pJudgeJailType]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "BeingSentenced", PlayerInfo[playerid][pBeingSentenced]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "ProbationTime", PlayerInfo[playerid][pProbationTime]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "DMKills", PlayerInfo[playerid][pDMKills]);

	SavePlayerInteger(query, GetPlayerSQLId(playerid), "OrderConfirmed", PlayerInfo[playerid][pOrderConfirmed]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "FreezeHouse", PlayerInfo[playerid][pFreezeHouse]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "FreezeCar", PlayerInfo[playerid][pFreezeCar]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Firework", PlayerInfo[playerid][pFirework]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Boombox", PlayerInfo[playerid][pBoombox]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Hydration", PlayerInfo[playerid][pHydration]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "DoubleEXP", PlayerInfo[playerid][pDoubleEXP]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "EXPToken", PlayerInfo[playerid][pEXPToken]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "RacePlayerLaps", PlayerInfo[playerid][pRacePlayerLaps]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Ringtone", PlayerInfo[playerid][pRingtone]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Wallpaper", PlayerInfo[playerid][pWallpaper]);

	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Order", PlayerInfo[playerid][pOrder]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "CallsAccepted", PlayerInfo[playerid][pCallsAccepted]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "PatientsDelivered", PlayerInfo[playerid][pPatientsDelivered]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "LiveBanned", PlayerInfo[playerid][pLiveBanned]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "FreezeBank", PlayerInfo[playerid][pFreezeBank]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "VIPM", PlayerInfo[playerid][pVIPM]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "VIPMO", PlayerInfo[playerid][pVIPMO]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "VIPExpire", PlayerInfo[playerid][pVIPExpire]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "GVip", PlayerInfo[playerid][pGVip]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Watchdog", PlayerInfo[playerid][pWatchdog]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "VIPSold", PlayerInfo[playerid][pVIPSold]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "GoldBoxTokens", PlayerInfo[playerid][pGoldBoxTokens]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "DrawChance", PlayerInfo[playerid][pRewardDrawChance]);
	SavePlayerFloat(query, GetPlayerSQLId(playerid), "RewardHours", PlayerInfo[playerid][pRewardHours]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "CarsRestricted", PlayerInfo[playerid][pRVehRestricted]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "LastCarWarning", PlayerInfo[playerid][pLastRVehWarn]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "CarWarns", PlayerInfo[playerid][pRVehWarns]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Flagged", PlayerInfo[playerid][pFlagged]);

	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Paper", PlayerInfo[playerid][pPaper]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "MailEnabled", PlayerInfo[playerid][pMailEnabled]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Mailbox", PlayerInfo[playerid][pMailbox]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Business", PlayerInfo[playerid][pBusiness]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "BusinessRank", PlayerInfo[playerid][pBusinessRank]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "TreasureSkill", PlayerInfo[playerid][pTreasureSkill]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "MetalDetector", PlayerInfo[playerid][pMetalDetector]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "HelpedBefore", PlayerInfo[playerid][pHelpedBefore]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Trickortreat", PlayerInfo[playerid][pTrickortreat]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "LastCharmReceived", PlayerInfo[playerid][pLastCharmReceived]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "RHMutes", PlayerInfo[playerid][pRHMutes]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "RHMuteTime", PlayerInfo[playerid][pRHMuteTime]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "GiftCode", PlayerInfo[playerid][pGiftCode]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Table", PlayerInfo[playerid][pTable]);

	SavePlayerInteger(query, GetPlayerSQLId(playerid), "OpiumSeeds", PlayerInfo[playerid][pOpiumSeeds]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "RawOpium", PlayerInfo[playerid][pRawOpium]);
	//SavePlayerInteger(query, GetPlayerSQLId(playerid), "Heroin", PlayerInfo[playerid][pHeroin]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Syringe", PlayerInfo[playerid][pSyringes]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Skins", PlayerInfo[playerid][pSkins]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Fitness", PlayerInfo[playerid][pFitness]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "HealthCare", PlayerInfo[playerid][pHealthCare]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "ReceivedCredits", PlayerInfo[playerid][pReceivedCredits]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "RimMod", PlayerInfo[playerid][pRimMod]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Tazer", PlayerInfo[playerid][pHasTazer]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Cuff", PlayerInfo[playerid][pHasCuff]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "CarVoucher", PlayerInfo[playerid][pCarVoucher]);

	SavePlayerString(query, GetPlayerSQLId(playerid), "ReferredBy", PlayerInfo[playerid][pReferredBy]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "PendingRefReward", PlayerInfo[playerid][pPendingRefReward]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Refers", PlayerInfo[playerid][pRefers]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Famed", PlayerInfo[playerid][pFamed]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "FamedMuted", PlayerInfo[playerid][pFMuted]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "DefendTime", PlayerInfo[playerid][pDefendTime]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "PVIPVoucher", PlayerInfo[playerid][pPVIPVoucher]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "VehicleSlot", PlayerInfo[playerid][pVehicleSlot]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "ToySlot", PlayerInfo[playerid][pToySlot]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "RFLTeam", PlayerInfo[playerid][pRFLTeam]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "RFLTeamL", PlayerInfo[playerid][pRFLTeamL]);

	SavePlayerInteger(query, GetPlayerSQLId(playerid), "VehVoucher", PlayerInfo[playerid][pVehVoucher]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "SVIPVoucher", PlayerInfo[playerid][pSVIPVoucher]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "GVIPVoucher", PlayerInfo[playerid][pGVIPVoucher]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "GiftVoucher", PlayerInfo[playerid][pGiftVoucher]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "FallIntoFun", PlayerInfo[playerid][pFallIntoFun]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "HungerVoucher", PlayerInfo[playerid][pHungerVoucher]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "BoughtCure", PlayerInfo[playerid][pBoughtCure]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Vials", PlayerInfo[playerid][pVials]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "AdvertVoucher", PlayerInfo[playerid][pAdvertVoucher]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "ShopCounter", PlayerInfo[playerid][pShopCounter]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "ShopNotice", PlayerInfo[playerid][pShopNotice]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "SVIPExVoucher", PlayerInfo[playerid][pSVIPExVoucher]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "GVIPExVoucher", PlayerInfo[playerid][pGVIPExVoucher]);

	SavePlayerInteger(query, GetPlayerSQLId(playerid), "VIPSellable", PlayerInfo[playerid][pVIPSellable]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "ReceivedPrize", PlayerInfo[playerid][pReceivedPrize]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "VIPSpawn", PlayerInfo[playerid][pVIPSpawn]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "FreeAdsDay", PlayerInfo[playerid][pFreeAdsDay]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "FreeAdsLeft", PlayerInfo[playerid][pFreeAdsLeft]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "BuddyInvites", PlayerInfo[playerid][pBuddyInvites]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "ReceivedBGift", PlayerInfo[playerid][pReceivedBGift]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "pVIPJob", PlayerInfo[playerid][pVIPJob]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "LastBirthday", PlayerInfo[playerid][pLastBirthday]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "AccountRestricted", PlayerInfo[playerid][pAccountRestricted]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Watchlist", PlayerInfo[playerid][pWatchlist]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "WatchlistTime", PlayerInfo[playerid][pWatchlistTime]);

	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Backpack", PlayerInfo[playerid][pBackpack]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "BEquipped", PlayerInfo[playerid][pBEquipped]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "BStoredH", PlayerInfo[playerid][pBStoredH]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "BStoredV", PlayerInfo[playerid][pBStoredV]);

	SavePlayerInteger(query, GetPlayerSQLId(playerid), "PrisonCredits", PlayerInfo[playerid][pPrisonCredits]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "PrisonMaterials", PlayerInfo[playerid][pPrisonMaterials]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "PrisonWineTime", PlayerInfo[playerid][pPrisonWineTime]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "PrisonCell", PlayerInfo[playerid][pPrisonCell]);

	SavePlayerInteger(query, GetPlayerSQLId(playerid), "PrisonSoap", GetPVarInt(playerid, "pPrisonSoap"));
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "PrisonSugar", GetPVarInt(playerid, "pPrisonSugar"));
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "PrisonBread", GetPVarInt(playerid, "pPrisonBread"));
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "PrisonShank", GetPVarInt(playerid, "pPrisonShank"));
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "PrisonShankOut", GetPVarInt(playerid, "pPrisonShankOut"));
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "ShankUsages", GetPVarInt(playerid, "pShankUsages"));
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "PrisonWine", GetPVarInt(playerid, "pPrisonWine"));
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "PrisonMWine", GetPVarInt(playerid, "pPrisonMWine"));
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "PrisonChisel", GetPVarInt(playerid, "pPrisonChisel"));
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "PrisonCellChisel", GetPVarInt(playerid, "pPrisonCellChisel"));

	SavePlayerInteger(query, GetPlayerSQLId(playerid), "FishingSkill", PlayerInfo[playerid][pFishingSkill]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "FishWeight", PlayerInfo[playerid][pFishWeight]);

	SavePlayerInteger(query, GetPlayerSQLId(playerid), "GarbageSkill", PlayerInfo[playerid][pGarbageSkill]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Pot", PlayerInfo[playerid][pDrugs][0]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Crack", PlayerInfo[playerid][pDrugs][1]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Meth", PlayerInfo[playerid][pDrugs][2]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Ecstasy", PlayerInfo[playerid][pDrugs][3]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Heroin", PlayerInfo[playerid][pDrugs][4]);

	SavePlayerInteger(query, GetPlayerSQLId(playerid), "CopKit", GetPVarInt(playerid, "MedVestKit"));

	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Hitman", PlayerInfo[playerid][pHitman]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "HitmanLeader", PlayerInfo[playerid][pHitmanLeader]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "HitmanBlacklisted", PlayerInfo[playerid][pHitmanBlacklisted]);
	SavePlayerString(query, GetPlayerSQLId(playerid), "BlacklistReason", PlayerInfo[playerid][pBlacklistReason]);

	new szForLoop[16];
	for(new x = 0; x < 12; x++) {

		mysql_format(MainPipeline, szForLoop, sizeof(szForLoop), "BItem%d", x);
		SavePlayerInteger(query, GetPlayerSQLId(playerid), szForLoop, PlayerInfo[playerid][pBItems][x]);
	}
	for(new x = 0; x < sizeof(Drugs); x++) {

		mysql_format(MainPipeline, szForLoop, sizeof(szForLoop), "BDrug%d", x);
		SavePlayerInteger(query, GetPlayerSQLId(playerid), szForLoop, PlayerInfo[playerid][pBDrugs][x]);
	}
	for(new x = 0; x < 12; x++) {

		mysql_format(MainPipeline, szForLoop, sizeof(szForLoop), "Gun%d", x);
		SavePlayerInteger(query, GetPlayerSQLId(playerid), szForLoop, PlayerInfo[playerid][pGuns][x]);
	}

	SavePlayerInteger(query, GetPlayerSQLId(playerid), "BRTimeout", PlayerInfo[playerid][pBugReportTimeout]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "pDigCooldown", PlayerInfo[playerid][pDigCooldown]);

	SavePlayerInteger(query, GetPlayerSQLId(playerid), "ToolBox", PlayerInfo[playerid][pToolBox]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "CrowBar", PlayerInfo[playerid][pCrowBar]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "CarLockPickSkill", PlayerInfo[playerid][pCarLockPickSkill]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "LockPickVehCount", PlayerInfo[playerid][pLockPickVehCount]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "LockPickTime", PlayerInfo[playerid][pLockPickTime]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "SEC", PlayerInfo[playerid][pSEC]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "BM", PlayerInfo[playerid][pBM]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "ASM", PlayerInfo[playerid][pASM]);

	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Isolated", PlayerInfo[playerid][pIsolated]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "WantedJailTime", PlayerInfo[playerid][pWantedJailTime]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "WantedJailFine", PlayerInfo[playerid][pWantedJailFine]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "NextNameChange", PlayerInfo[playerid][pNextNameChange]);
	SavePlayerString(query, GetPlayerSQLId(playerid), "pExamineDesc", PlayerInfo[playerid][pExamineDesc]);
	SavePlayerString(query, GetPlayerSQLId(playerid), "FavStation", PlayerInfo[playerid][pFavStation]);

	// Austin's DP System
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "pDedicatedPlayer", PlayerInfo[playerid][pDedicatedPlayer]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "pDedicatedEnabled", PlayerInfo[playerid][pDedicatedEnabled]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "pDedicatedMuted", PlayerInfo[playerid][pDedicatedMuted]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "pDedicatedWarn", PlayerInfo[playerid][pDedicatedWarn]);

	new mistring[64], mpstring[64], mcstring[256];
	for(new m; m < MAX_MICROITEMS; m++)
	{
		mysql_format(MainPipeline, mistring, sizeof(mistring), "%s%d", mistring, PlayerInfo[playerid][mInventory][m]);
		mysql_format(MainPipeline, mpstring, sizeof(mpstring), "%s%d", mpstring, PlayerInfo[playerid][mPurchaseCount][m]);
		mysql_format(MainPipeline, mcstring, sizeof(mcstring), "%s%d", mcstring, PlayerInfo[playerid][mCooldown][m]);
		if(m != MAX_MICROITEMS-1) strcat(mistring, "|"), strcat(mpstring, "|"), strcat(mcstring, "|");
	}
	SavePlayerString(query, GetPlayerSQLId(playerid), "mInventory", mistring);
	SavePlayerString(query, GetPlayerSQLId(playerid), "mPurchaseCounts", mpstring);
	SavePlayerString(query, GetPlayerSQLId(playerid), "mCooldowns", mcstring);
	mysql_format(MainPipeline, mpstring, sizeof(mpstring), "%d|%d", PlayerInfo[playerid][mBoost][0], PlayerInfo[playerid][mBoost][1]);
	SavePlayerString(query, GetPlayerSQLId(playerid), "mBoost", mpstring);
	mysql_format(MainPipeline, mpstring, sizeof(mpstring), "%d|%d", PlayerInfo[playerid][mShopCounter], PlayerInfo[playerid][mNotice]);
	SavePlayerString(query, GetPlayerSQLId(playerid), "mShopNotice", mpstring);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "zFuelCan", PlayerInfo[playerid][zFuelCan]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "bTicket", PlayerInfo[playerid][bTicket]);

	// Austin's Punishment Revamp
	mysql_format(MainPipeline, mistring, 64, "%d|%d|%d|%d|%d", PlayerInfo[playerid][pJailedInfo][0], PlayerInfo[playerid][pJailedInfo][1],
		PlayerInfo[playerid][pJailedInfo][2], PlayerInfo[playerid][pJailedInfo][3], PlayerInfo[playerid][pJailedInfo][4]);
	SavePlayerString(query, GetPlayerSQLId(playerid), "JailedInfo", mistring);
	mistring[0] = 0;
	for(new jailX = 0; jailX < 12; jailX++)
	{
		mysql_format(MainPipeline, mistring, sizeof(mistring), "%s%d", mistring, PlayerInfo[playerid][pJailedWeapons][jailX]);
		if(jailX != 11) strcat(mistring, "|");
	}
	SavePlayerString(query, GetPlayerSQLId(playerid), "JailedWeapons", mistring);

	/*for(new idrugs = 0; idrugs < sizeof(Drugs); ++idrugs)
	{
		format(mistring, sizeof(mistring), "%s%d", mistring, PlayerInfo[playerid][p_iDrugQuality][idrugs]);
		if(idrugs != sizeof(Drugs) - 1) strcat(mistring, "|");
	}
	SavePlayerString(query, GetPlayerSQLId(playerid), "DrugQuality", mistring);*/

	/*mistring[0] = 0;
	for(new ipdrugs = 0; ipdrugs < sizeof(Drugs); ++ipdrugs)
	{
		format(mistring, sizeof(mistring), "%s%d", mistring, PlayerInfo[playerid][p_iPrisonDrug][ipdrugs]);
		if(ipdrugs != sizeof(Drugs) - 1) strcat(mistring, "|");
	}
	SavePlayerString(query, GetPlayerSQLId(playerid), "PrisonDrugs", mistring);*/

	/*format(szMiscArray, sizeof(szMiscArray), "%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d",
		PlayerInfo[playerid][pToggledChats][0],
		PlayerInfo[playerid][pToggledChats][1],
		PlayerInfo[playerid][pToggledChats][2],
		PlayerInfo[playerid][pToggledChats][3],
		PlayerInfo[playerid][pToggledChats][4],
		PlayerInfo[playerid][pToggledChats][5],
		PlayerInfo[playerid][pToggledChats][6],
		PlayerInfo[playerid][pToggledChats][7],
		PlayerInfo[playerid][pToggledChats][8],
		PlayerInfo[playerid][pToggledChats][9],
		PlayerInfo[playerid][pToggledChats][10],
		PlayerInfo[playerid][pToggledChats][11],
		PlayerInfo[playerid][pToggledChats][12],
		PlayerInfo[playerid][pToggledChats][13],
		PlayerInfo[playerid][pToggledChats][14],
		PlayerInfo[playerid][pToggledChats][15],
		PlayerInfo[playerid][pToggledChats][16],
		PlayerInfo[playerid][pToggledChats][17],
		PlayerInfo[playerid][pToggledChats][18],
		PlayerInfo[playerid][pToggledChats][19],
		PlayerInfo[playerid][pToggledChats][20]);
	SavePlayerString(query, GetPlayerSQLId(playerid), "ToggledChats", szMiscArray);*/

	for(new c = 0; c < MAX_CHATSETS; c++) {
		mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "ChatTog%d", c);
		SavePlayerInteger(query, GetPlayerSQLId(playerid), szMiscArray, PlayerInfo[playerid][pToggledChats][c]);
	}

	/*format(szMiscArray, sizeof(szMiscArray), "%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d",
		PlayerInfo[playerid][pChatbox][0],
		PlayerInfo[playerid][pChatbox][1],
		PlayerInfo[playerid][pChatbox][2],
		PlayerInfo[playerid][pChatbox][3],
		PlayerInfo[playerid][pChatbox][4],
		PlayerInfo[playerid][pChatbox][5],
		PlayerInfo[playerid][pChatbox][6],
		PlayerInfo[playerid][pChatbox][7],
		PlayerInfo[playerid][pChatbox][8],
		PlayerInfo[playerid][pChatbox][9],
		PlayerInfo[playerid][pChatbox][10],
		PlayerInfo[playerid][pChatbox][11],
		PlayerInfo[playerid][pChatbox][12],
		PlayerInfo[playerid][pChatbox][13],
		PlayerInfo[playerid][pChatbox][14],
		PlayerInfo[playerid][pChatbox][15],
		PlayerInfo[playerid][pChatbox][16],
		PlayerInfo[playerid][pChatbox][17],
		PlayerInfo[playerid][pChatbox][18],
		PlayerInfo[playerid][pChatbox][19]);

	SavePlayerString(query, GetPlayerSQLId(playerid), "ChatBoxSettings", szMiscArray);*/

	SavePlayerInteger(query, GetPlayerSQLId(playerid), "pVIPMod", PlayerInfo[playerid][pVIPMod]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "pEventTokens", PlayerInfo[playerid][pEventTokens]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "VIPGunsCount", PlayerInfo[playerid][pVIPGuncount]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "pBailPrice", PlayerInfo[playerid][pBailPrice]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "pLastPoll", PlayerInfo[playerid][pLastPoll]);
	SavePlayerString(query, GetPlayerSQLId(playerid), "PollKeyA", PlayerInfo[playerid][pPollKey1]);
    SavePlayerString(query, GetPlayerSQLId(playerid), "PollKeyB", PlayerInfo[playerid][pPollKey2]);
    SavePlayerString(query, GetPlayerSQLId(playerid), "PollKeyC", PlayerInfo[playerid][pPollKey3]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "FurnitureSlots", PlayerInfo[playerid][pFurnitureSlots]);

	SavePlayerInteger(query, GetPlayerSQLId(playerid), "StaffBanned", PlayerInfo[playerid][pStaffBanned]);

	SavePlayerString(query, GetPlayerSQLId(playerid), "DedicatedDaymarker", PlayerInfo[playerid][pDedicatedDaymarker]);
	SavePlayerString(query, GetPlayerSQLId(playerid), "DedicatedTimestamp", PlayerInfo[playerid][pDedicatedTimestamp]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "DedicatedHours", PlayerInfo[playerid][pDedicatedHours]);
	
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "WalkStyle", PlayerInfo[playerid][pWalkStyle]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "FlagCredits", PlayerInfo[playerid][pFlagCredits]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "FlagClaimed", PlayerInfo[playerid][pFlagClaimed]);

	//for(new d; d < sizeof(Drugs); ++d) SavePlayerInteger(query, GetPlayerSQLId(playerid), GetDrugName(d), PlayerInfo[playerid][pDrugs][d]);
	//for(new d; d < sizeof(szIngredients); ++d) if(d != 9) SavePlayerInteger(query, GetPlayerSQLId(playerid), DS_Ingredients_GetSQLName(d), PlayerInfo[playerid][p_iIngredient][d]);	

	/*szMiscArray[0] = 0;
	for(new d; d < sizeof(Drugs); ++d) 
	{		
		format(szMiscArray, sizeof(szMiscArray), "Prison%s", GetDrugName(d));
		SavePlayerInteger(query, GetPlayerSQLId(playerid), szMiscArray, PlayerInfo[playerid][p_iPrisonDrug][d]);
	} old */

	MySQLUpdateFinish(query, GetPlayerSQLId(playerid));
	if(FIFEnabled) g_mysql_SaveFIF(playerid);
	return 1;
}

stock SaveAuction(auction) {
	new query[200];
	mysql_format(MainPipeline, query, sizeof(query), "UPDATE `auctions` SET");
	mysql_format(MainPipeline, query, sizeof(query), "%s `BiddingFor` = '%e', `InProgress` = %d, `Bid` = %d, `Bidder` = %d, `Expires` = %d, `Wining` = '%e', `Increment` = %d", query, Auctions[auction][BiddingFor], Auctions[auction][InProgress], Auctions[auction][Bid], Auctions[auction][Bidder], Auctions[auction][Expires], Auctions[auction][Wining], Auctions[auction][Increment]);
    mysql_format(MainPipeline, query, sizeof(query), "%s WHERE `id` = %d", query, auction+1);
    mysql_tquery(MainPipeline, query, "OnQueryFinish", "ii", SENDDATA_THREAD, INVALID_PLAYER_ID);
}

stock GetLatestKills(playerid, giveplayerid)
{
	new query[256];
	mysql_format(MainPipeline, query, sizeof(query), "SELECT Killer.Username, Killed.Username, k.* FROM kills k LEFT JOIN accounts Killed ON k.killedid = Killed.id LEFT JOIN accounts Killer ON Killer.id = k.killerid WHERE k.killerid = %d OR k.killedid = %d ORDER BY `date` DESC LIMIT 10", GetPlayerSQLId(giveplayerid), GetPlayerSQLId(giveplayerid));
	mysql_tquery(MainPipeline, query, "OnGetLatestKills", "ii", playerid, giveplayerid);
}

stock GetSMSLog(playerid)
{
	new query[256];
	mysql_format(MainPipeline, query, sizeof(query), "SELECT `sender`, `sendernumber`, `message`, `date` FROM `sms` WHERE `receiverid` = %d ORDER BY `date` DESC LIMIT 10", GetPlayerSQLId(playerid));
	mysql_tquery(MainPipeline, query, "OnGetSMSLog", "i", playerid);
}

stock LoadAuctions() {
	printf("[LoadAuctions] Loading data from database...");
	mysql_tquery(MainPipeline, "SELECT * FROM `auctions`", "AuctionLoadQuery", "");
}

//--------------------------------[ CUSTOM PUBLIC FUNCTIONS ]---------------------------

forward OnPhoneNumberCheck(index, extraid);
public OnPhoneNumberCheck(index, extraid)
{
	if(IsPlayerConnected(index))
	{
		new string[128];
		new rows, fields;
		cache_get_row_count(rows);
		cache_get_field_count(fields);

		switch(extraid)
		{
			case 1: {
				if(rows)
				{
					SendClientMessageEx(index, COLOR_WHITE, "That phone number has already been taken.");
					DeletePVar(index, "PhChangerId");
					DeletePVar(index, "WantedPh");
					DeletePVar(index, "PhChangeCost");
					DeletePVar(index, "CurrentPh");
				}
				else
				{
					format(string,sizeof(string),"The phone number requested, %d, will cost a total of $%s.\n\nTo confirm, press OK.", GetPVarInt(index, "WantedPh"), number_format(GetPVarInt(index, "PhChangeCost")));
					ShowPlayerDialogEx(index, VIPNUMMENU2, DIALOG_STYLE_MSGBOX, "Confirmation", string, "OK", "Cancel");
				}
			}
			case 2: {
				if(rows)
				{
					SendClientMessageEx(index, COLOR_WHITE, "That phone number has already been taken.");
				}
				else
				{
					PlayerInfo[index][pPnumber] = GetPVarInt(index, "WantedPh");
					GivePlayerCash(index, -GetPVarInt(index, "PhChangeCost"));
					format(string, sizeof(string), "Cellphone purchased, your new phone number is %d.", GetPVarInt(index, "WantedPh"));
					SendClientMessageEx(index, COLOR_GRAD4, string);
					SendClientMessageEx(index, COLOR_GRAD5, "You can check this any time you wish by typing /stats.");
					SendClientMessageEx(index, COLOR_WHITE, "HINT: You can now type /cellphonehelp to see your cellphone commands.");
					mysql_format(MainPipeline, string, sizeof(string), "UPDATE `accounts` SET `PhoneNr` = %d WHERE `id` = '%d'", PlayerInfo[index][pPnumber], GetPlayerSQLId(index));
					mysql_tquery(MainPipeline, string, "OnQueryFinish", "ii", SENDDATA_THREAD, index);
					DeletePVar(index, "PhChangerId");
					DeletePVar(index, "WantedPh");
					DeletePVar(index, "PhChangeCost");
					DeletePVar(index, "CurrentPh");
				}
			}
			case 3: {
				if(rows && GetPVarInt(index, "WantedPh") != 0)
				{
					SendClientMessageEx(index, COLOR_WHITE, "That phone number has already been taken.");
				}
				else
				{
					PlayerInfo[index][pPnumber] = GetPVarInt(index, "WantedPh");
					format(string, sizeof(string), "   %s's(%d) Phone Number has been set to %d.", GetPlayerNameEx(index), GetPlayerSQLId(index), GetPVarInt(index, "WantedPh"));

					format(string, sizeof(string), "%s by %s", string, GetPlayerNameEx(index));
					Log("logs/undercover.log", string);
					SendClientMessageEx(index, COLOR_GRAD1, string);
					mysql_format(MainPipeline, string, sizeof(string), "UPDATE `accounts` SET `PhoneNr` = %d WHERE `id` = '%d'", PlayerInfo[index][pPnumber], GetPlayerSQLId(index));
					mysql_tquery(MainPipeline, string, "OnQueryFinish", "ii", SENDDATA_THREAD, index);
					DeletePVar(index, "PhChangerId");
					DeletePVar(index, "WantedPh");
					DeletePVar(index, "PhChangeCost");
					DeletePVar(index, "CurrentPh");
				}
			}
			case 4: {
				if(IsPlayerConnected(GetPVarInt(index, "PhChangerId")))
				{
					if(rows)
					{
						SendClientMessageEx(GetPVarInt(index, "PhChangerId"), COLOR_WHITE, "That phone number has already been taken.");
					}
					else
					{
						PlayerInfo[index][pPnumber] = GetPVarInt(index, "WantedPh");
						format(string, sizeof(string), "   %s's(%d) Phone Number has been set to %d.", GetPlayerNameEx(index), GetPlayerSQLId(index), GetPVarInt(index, "WantedPh"));

						format(string, sizeof(string), "%s by %s", string, GetPlayerNameEx(GetPVarInt(index, "PhChangerId")));
						Log("logs/stats.log", string);
						SendClientMessageEx(GetPVarInt(index, "PhChangerId"), COLOR_GRAD1, string);
						mysql_format(MainPipeline, string, sizeof(string), "UPDATE `accounts` SET `PhoneNr` = %d WHERE `id` = '%d'", PlayerInfo[index][pPnumber], GetPlayerSQLId(index));
						mysql_tquery(MainPipeline, string, "OnQueryFinish", "ii", SENDDATA_THREAD, index);
						DeletePVar(index, "PhChangerId");
						DeletePVar(index, "WantedPh");
						DeletePVar(index, "PhChangeCost");
						DeletePVar(index, "CurrentPh");
					}
				}
			}
			case 5: {
                if(rows) {
                    SendClientMessageEx(index, COLOR_WHITE, "That phone number has already been taken.");
                    DeletePVar(index, "oldnum");
                    DeletePVar(index, "newnum");
                }
                else {
                    format(string, sizeof(string), "You have set your temporary number to %d, type /tempnum to disable it.", GetPVarInt(index, "tempnum"));
                    SendClientMessage(index, COLOR_WHITE, string);
                    PlayerInfo[index][pPnumber] = GetPVarInt(index, "tempnum");
                    TempNumber[index] = 1;
                }
            }
		}
	}
	return 1;
}

forward AddingBan(index, type);
public AddingBan(index, type)
{
    if(IsPlayerConnected(index))
	{
	    if(type == 1) // Add Ban
	    {
    		new rows, fields;
    		cache_get_row_count(rows);
			cache_get_field_count(fields);
    		if(rows)
    		{
    		    DeletePVar(index, "BanningPlayer");
    		    DeletePVar(index, "BanningReason");
    		    SendClientMessageEx(index, COLOR_GREY, "That player is already banned.");
    		}
    		else
    		{
    		    if(IsPlayerConnected(GetPVarInt(index, "BanningPlayer")))
    		    {
    		    	new string[256], reason[64];
    		    	GetPVarString(index, "BanningReason", reason, sizeof(reason));

		    	    mysql_format(MainPipeline, string, sizeof(string), "INSERT INTO `ip_bans` (`ip`, `date`, `reason`, `admin`) VALUES ('%s', NOW(), '%e', '%e')", GetPlayerIpEx(GetPVarInt(index, "BanningPlayer")), reason, GetPlayerNameEx(index));
					mysql_tquery(MainPipeline, string, "OnQueryFinish", "i", SENDDATA_THREAD);

					DeletePVar(index, "BanningPlayer");
		    	    DeletePVar(index, "BanningReason");
				}
	    	}
		}
		else if(type == 2) // Unban IP
		{
		    new rows;
		    cache_get_row_count(rows);
		    if(rows)
		    {
		        new string[128], ip[32];
		        GetPVarString(index, "UnbanIP", ip, sizeof(ip));

		        mysql_format(MainPipeline, string, sizeof(string), "DELETE FROM `ip_bans` WHERE `ip` = '%s'", ip);
				mysql_tquery(MainPipeline, string, "OnQueryFinish", "i", SENDDATA_THREAD);

				DeletePVar(index, "UnbanIP");
		    }
		    else
		    {
		        SendClientMessageEx(index, COLOR_GREY, "That IP address was not found in the ban database.");
				DeletePVar(index, "UnbanIP");
			}
		}
		else if(type == 3) // Ban IP
		{
		    new rows;
		    cache_get_row_count(rows);
		    if(rows)
		    {
		        SendClientMessageEx(index, COLOR_GREY, "That IP address is already banned.");
				DeletePVar(index, "BanIP");
		    }
		    else
		    {
		        new string[256], ip[32];
		        GetPVarString(index, "BanIP", ip, sizeof(ip));
		        mysql_format(MainPipeline, string, sizeof(string), "INSERT INTO `ip_bans` (`ip`, `date`, `reason`, `admin`) VALUES ('%s', NOW(), '%s', '%s')", ip, "/banip", GetPlayerNameEx(index));
				mysql_tquery(MainPipeline, string, "OnQueryFinish", "i", SENDDATA_THREAD);

		        SendClientMessageEx(index, COLOR_WHITE, "That IP address was successfully banned.");
				DeletePVar(index, "BanIP");
			}
		}
	}
	return 1;
}

forward MailsQueryFinish(playerid);
public MailsQueryFinish(playerid)
{

    new rows;
	cache_get_row_count(rows);

	if (rows == 0) {
		ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, " ", "Your mailbox is empty.", "OK", "");
		return 1;
	}

    new id, string[2000], message[129], tmp[128], read;
	for(new i; i < rows;i++)
	{
    	cache_get_value_name(i, "Id", tmp);  	id = strval(tmp);
    	cache_get_value_name(i, "Read", tmp); read= strval(tmp);
    	cache_get_value_name(i, "Message", message, 129);
		strmid(message,message,0,30);
		if (strlen(message) > 30) strcat(message,"...");
		strcat(string, (read) ? ("{BBBBBB}") : ("{FFFFFF}"));
		strcat(string, message);
		if (i != rows - 1) strcat(string, "\n");
		ListItemTrackId[playerid][i] = id;
	}

    ShowPlayerDialogEx(playerid, DIALOG_POMAILS, DIALOG_STYLE_LIST, "Your mails", string, "Read", "Close");

	return 1;
}

forward MailDetailsQueryFinish(playerid);
public MailDetailsQueryFinish(playerid)
{
	new string[256];
    new rows;
	cache_get_row_count(rows);

	new senderid, sender[MAX_PLAYER_NAME], message[131], notify, szTmp[128], Date[32], read, id;
	cache_get_value_name(0, "Id", szTmp);	    	id = strval(szTmp);
	cache_get_value_name(0, "Notify", szTmp);	    notify = strval(szTmp);
	cache_get_value_name(0, "Sender_Id", szTmp);	senderid = strval(szTmp);
	cache_get_value_name(0, "Read", szTmp);		read = strval(szTmp);
	cache_get_value_name(0, "Message", message, 131);
	cache_get_value_name(0, "SenderUser", sender, MAX_PLAYER_NAME);
	cache_get_value_name(0, "Date", Date, 32);

	if (strlen(message) > 80) strins(message, "\n", 70);

	format(string, sizeof(string), "{EEEEEE}%s\n\n{BBBBBB}Sender: {FFFFFF}%s\n{BBBBBB}Date: {EEEEEE}%s", message, sender,Date);
	ShowPlayerDialogEx(playerid, DIALOG_PODETAIL, DIALOG_STYLE_MSGBOX, "Mail Content", string, "Back", "Trash");

	if (notify && !read) {
		foreach(new i: Player)
		{
			if (GetPlayerSQLId(i) == senderid)	{
				format(string, sizeof(string), "Your message has just been read by %s!", GetPlayerNameEx(playerid));
				SendClientMessageEx(i, COLOR_YELLOW, string);
				break;
			}
		}
	}

	mysql_format(MainPipeline, string, sizeof(string), "UPDATE `letters` SET `Read` = 1 WHERE `id` = %d", id);
	mysql_tquery(MainPipeline, string, "OnQueryFinish", "i", SENDDATA_THREAD);

	return 1;
}


forward MailDeliveryQueryFinish();
public MailDeliveryQueryFinish()
{

    new rows, id, tmp[128], i;
	cache_get_row_count(rows);

	for(; i < rows;i++)
	{
    	cache_get_value_name(i, "Receiver_Id", tmp);
    	id = strval(tmp);
		foreach(new j: Player)
		{
			if (GetPlayerSQLId(j) == id) {
				if (PlayerInfo[j][pDonateRank] >= 4 && HasMailbox(j))	{
					SendClientMessageEx(j, COLOR_YELLOW, "Mail has just been delivered to your mailbox.");
					SetPVarInt(j, "UnreadMails", 1);
					break;
				}
			}
		}
 	}

	return 1;

}


forward MDCQueryFinish(playerid, suspectid);
public MDCQueryFinish(playerid, suspectid)
{
    new rows;
	cache_get_row_count(rows);
    new resultline[1424], crimes = PlayerInfo[suspectid][pCrimes], arrests = PlayerInfo[suspectid][pArrested], nation[14];

	switch(PlayerInfo[suspectid][pNation])
	{
		case 0: nation = "San Andreas";
		case 1: nation = "New Robada";
		default: nation = "None";
	}

	format(resultline, sizeof(resultline), "{FF6347}Name:{BFC0C2} %s\t{FF6347}Phone Number:{BFC0C2} %d\n{FF6347}Total Previous Crimes: {BFC0C2}%d\t {FF6347}Total Arrests: {BFC0C2}%d \n{FF6347}Citizenship: {BFC0C2}%s \n{FF6347}Crime Key: {FF7D7D}Currently Wanted/{BFC0C2}Past Crime\n\n", GetPlayerNameEx(suspectid),PlayerInfo[suspectid][pPnumber], crimes, arrests, nation);

	for(new i; i < rows; i++)
	{
		cache_get_value_name(i, "issuer", MDCInfo[i][mdcIssuer], MAX_PLAYER_NAME);
		cache_get_value_name(i, "crime", MDCInfo[i][mdcCrime], 64);
	    cache_get_value_name_int(i, "active", MDCInfo[i][mdcActive]);
	    if(MDCInfo[i][mdcActive] == 1)
	    {
	        format(resultline, sizeof(resultline),"%s{FF6347}Crime: {FF7D7D}%s \t{FF6347}Charged by:{BFC0C2} %s\n",resultline, MDCInfo[i][mdcCrime], MDCInfo[i][mdcIssuer]);
		} else {
			format(resultline, sizeof(resultline),"%s{FF6347}Crime: {BFC0C2}%s \t{FF6347}Charged by:{BFC0C2} %s\n",resultline, MDCInfo[i][mdcCrime], MDCInfo[i][mdcIssuer]);
		}
	}
	ShowPlayerDialogEx(playerid, MDC_SHOWCRIMES, DIALOG_STYLE_MSGBOX, "MDC - Criminal History", resultline, "Back", "");
	return 1;
}

forward MDCReportsQueryFinish(playerid, suspectid);
public MDCReportsQueryFinish(playerid, suspectid)
{
    new rows;
	cache_get_row_count(rows);
    new resultline[1424], str[12];
    new copname[MAX_PLAYER_NAME], datetime[64], reportsid;
	for(new i; i < rows; i++)
	{
		cache_get_value_name(i, "id", str, 12); reportsid = strval(str);
	    cache_get_value_name(i, "Username", copname, MAX_PLAYER_NAME);
	    cache_get_value_name(i, "datetime", datetime, 64);
	    format(resultline, sizeof(resultline),"%s{FF6347}Report (%d) {FF7D7D}Arrested by: %s on %s\n",resultline, reportsid, copname,datetime);
	}
	if(!resultline[0]) format(resultline, sizeof(resultline),"No Arrest Reports on record.",resultline, reportsid, copname,datetime);
	ShowPlayerDialogEx(playerid, MDC_SHOWREPORTS, DIALOG_STYLE_LIST, "MDC - Criminal History", resultline, "Back", "");
	return 1;
}

forward MDCReportQueryFinish(playerid, reportid);
public MDCReportQueryFinish(playerid, reportid)
{
    new rows;
	cache_get_row_count(rows);
    new resultline[1424];
    new copname[MAX_PLAYER_NAME], datetime[64], shortreport[200];
	for(new i; i < rows; i++)
	{
	    cache_get_value_name(i, "Username", copname, MAX_PLAYER_NAME);
	    cache_get_value_name(i, "datetime", datetime, 64);
	    cache_get_value_name(i, "shortreport", shortreport, 200);
	    format(resultline, sizeof(resultline),"{FF6347}Report #%d\n{FF7D7D}Arrested by: %s on %s\n{FF6347}Report:{BFC0C2} %s\n",reportid, copname,datetime, shortreport);
	}
	ShowPlayerDialogEx(playerid, MDC_SHOWCRIMES, DIALOG_STYLE_MSGBOX, "MDC - Arrest Report", resultline, "Back", "");
	return 1;
}

forward FlagQueryFinish(playerid, suspectid, queryid);
public FlagQueryFinish(playerid, suspectid, queryid)
{
    new rows, value;
	cache_get_row_count(rows);
    new resultline[2000];
    new header[64], sResult[64];
    new FlagID, FlagIssuer[MAX_PLAYER_NAME], FlagText[64], FlagDate[24];
	switch(queryid)
	{
		case 0:
		{
			cache_get_value_name(0, "fid", sResult); FlagID = strval(sResult);
			cache_get_value_name(0, "issuer", FlagIssuer, MAX_PLAYER_NAME);
			cache_get_value_name(0, "flag", FlagText, 64);
			cache_get_value_name(0, "time", FlagDate, 24);
			format(resultline, sizeof(resultline),"{FF6347}FlagID: {BFC0C2}%d\n{FF6347}Flag: {BFC0C2}%s\n{FF6347}Issued by:{BFC0C2} %s \n{FF6347}Date: {BFC0C2}%s", FlagID, FlagText, FlagIssuer, FlagDate);
			ShowPlayerDialogEx(playerid, 0, DIALOG_STYLE_MSGBOX, "Viewing Flag Info", resultline, "Close", "");
		}
	    case Flag_Query_Display:
	    {
			format(header, sizeof(header), "{FF6347}Flag History for{BFC0C2} %s", GetPlayerNameEx(suspectid));
			if(!rows) return ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, header, "{FF6347}No Flags on this account", "Close", "");
			for(new i; i < rows; i++)
			{
				cache_get_value_name(i, "fid", sResult); FlagID = strval(sResult);
				cache_get_value_name(i, "flag", FlagText, 64);
				if(strlen(FlagText) > 60) strmid(FlagText, FlagText, 0, 58), format(FlagText, sizeof(FlagText), "%s[...]", FlagText);
				format(resultline, sizeof(resultline),"%s{FF6347}(ID: %d): {BFC0C2}%s\n", resultline, FlagID, FlagText);
			}
			ShowPlayerDialogEx(playerid, FLAG_LIST, DIALOG_STYLE_LIST, header, resultline, "Select", "Close");
		}
		case Flag_Query_Offline:
		{
			new string[128], name[24], reason[64], psqlid[12];
			GetPVarString(playerid, "OnAddFlag", name, 24);
			GetPVarString(playerid, "OnAddFlagReason", reason, 64);
			if(rows > 0) {
				format(string, sizeof(string), "You have appended %s's flag.", name);
				SendClientMessageEx(playerid, COLOR_WHITE, string);

				format(string, sizeof(string), "AdmCmd: %s was offline flagged by %s, reason: %s.", name, GetPlayerNameEx(playerid), reason);
				ABroadCast(COLOR_LIGHTRED, string, 2);

				format(string, sizeof(string), "%s was offline flagged by %s (%s).", name, GetPlayerNameEx(playerid), reason);
				Log("logs/flags.log", string);

				cache_get_value_name(0, "id", psqlid);

				AddOFlag(strval(psqlid), playerid, reason);
			}
			else {
				format(string, sizeof(string), "There was a problem with appending %s's flag.", name);
				SendClientMessageEx(playerid, COLOR_WHITE, string);
			}
			DeletePVar(playerid, "OnAddFlagReason");
		}
		case Flag_Query_Count:
		{
		    PlayerInfo[playerid][pFlagged] = rows;
		}
		case 4:
		{
			cache_get_value_name_int(0, "aFlagCount", value);
			if(value)
			{
				new string[128];
				format(string, sizeof(string), "SERVER: %s has logged in with %d outstanding admin flags /aviewflag to view!", GetPlayerNameEx(playerid), value);
				ABroadCast(COLOR_LIGHTRED, string, 2);
			}
		}
	}
	return 1;
}

forward SkinQueryFinish(playerid, queryid);
public SkinQueryFinish(playerid, queryid)
{
    new rows;
	cache_get_row_count(rows);
    new resultline[2000], header[32], sResult[64], skinid;
	switch(queryid)
	{
	    case Skin_Query_Display:
	    {
			if(PlayerInfo[playerid][pDonateRank] <= 0) format(header, sizeof(header), "Closet -- Space: %d/10", PlayerInfo[playerid][pSkins]);
			else if(PlayerInfo[playerid][pDonateRank] > 0) format(header, sizeof(header), "Closet -- Space: %d/25", PlayerInfo[playerid][pSkins]);

			if(rows == 0) return SendClientMessageEx(playerid, COLOR_GREY, "There are no clothes in this closet!");
			for(new i; i < rows; i++)
			{
			    cache_get_value_name(i, "skinid", sResult); skinid = strval(sResult);
				format(resultline, sizeof(resultline),"%sSkin ID: %d\n",resultline, skinid);
			}
			ShowPlayerDialogEx(playerid, SKIN_LIST, DIALOG_STYLE_LIST, header, resultline, "Select", "Cancel");
		}
		case Skin_Query_Count:
		{
		    PlayerInfo[playerid][pSkins] = rows;
		}
		case Skin_Query_ID:
		{
		    for(new i; i < rows; i++)
			{
			    cache_get_value_name(i, "skinid", sResult); skinid = strval(sResult);
				if(i == GetPVarInt(playerid, "closetchoiceid"))
				{
					SetPVarInt(playerid, "closetskinid", skinid);
					SetPlayerSkin(playerid, skinid);
					ShowPlayerDialogEx(playerid, SKIN_CONFIRM, DIALOG_STYLE_MSGBOX, "Closet", "Do you want to wear these clothes?", "Yes", "Go Back");
				}
			}
		}
		case Skin_Query_Delete:
	    {
			if(PlayerInfo[playerid][pDonateRank] <= 0) format(header, sizeof(header), "Closet -- Space: %d/10", PlayerInfo[playerid][pSkins]);
			else if(PlayerInfo[playerid][pDonateRank] > 0) format(header, sizeof(header), "Closet -- Space: %d/25", PlayerInfo[playerid][pSkins]);

			if(rows == 0) return SendClientMessageEx(playerid, COLOR_GREY, "There are no clothes in this closet!");
			for(new i; i < rows; i++)
			{
			    cache_get_value_name(i, "skinid", sResult); skinid = strval(sResult);
				format(resultline, sizeof(resultline),"%sSkin ID: %d\n",resultline, skinid);
			}
			ShowPlayerDialogEx(playerid, SKIN_DELETE, DIALOG_STYLE_LIST, header, resultline, "Select", "Cancel");
		}
		case Skin_Query_Delete_ID:
		{
		    for(new i; i < rows; i++)
			{
			    cache_get_value_name(i, "id", sResult); skinid = strval(sResult);
				if(i == GetPVarInt(playerid, "closetchoiceid"))
				{
					SetPVarInt(playerid, "closetskinid", skinid);
					ShowPlayerDialogEx(playerid, SKIN_DELETE2, DIALOG_STYLE_MSGBOX, "Closet", "Are you sure you want to remove these clothes?", "Yes", "Cancel");
				}
			}
		}
	}
	return 1;
}


forward CitizenQueryFinish(playerid, queryid);
public CitizenQueryFinish(playerid, queryid)
{
    new rows;
	cache_get_row_count(rows);
	switch(queryid)
	{
	    case TR_Citizen_Count:
	    {
			TRCitizens = rows;
		}
		case Total_Count:
		{
		    TotalCitizens = rows;
		}
	}
	return 1;
}

forward NationQueueQueryFinish(playerid, nation, queryid);
public NationQueueQueryFinish(playerid, nation, queryid)
{
    new query[300], resultline[2000], sResult[64], rows;
	cache_get_row_count(rows);
	switch(queryid)
	{
		case CheckQueue:
	    {
			if(rows == 0)
			{
				mysql_format(MainPipeline, query, sizeof(query), "INSERT INTO `nation_queue` (`id`, `playerid`, `name`, `date`, `nation`, `status`) VALUES (NULL, %d, '%s', NOW(), %d, 1)", GetPlayerSQLId(playerid), GetPlayerNameExt(playerid), nation);
				mysql_tquery(MainPipeline, query, "OnQueryFinish", "i", SENDDATA_THREAD);
				SendClientMessageEx(playerid, COLOR_GREY, "You have been added to the nation's application queue. The nation's leader can now choose to accept or deny your application.");
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GREY, "You are already in queue to join a nation.");
			}
		}
		case UpdateQueue:
	    {
			if(rows > 0)
			{
				mysql_format(MainPipeline, query, sizeof(query), "UPDATE `nation_queue` SET `name` = '%s' WHERE `playerid` = %d", GetPlayerNameExt(playerid), GetPlayerSQLId(playerid));
				mysql_tquery(MainPipeline, query, "OnQueryFinish", "i", SENDDATA_THREAD);
			}
		}
		case AppQueue:
	    {
			new sDate[32];
			if(rows == 0) return SendClientMessageEx(playerid, COLOR_GREY, "There are currently no pending applications.");
			for(new i; i < rows; i++)
			{
				cache_get_value_name(i, "name", sResult, MAX_PLAYER_NAME);
				cache_get_value_name(i, "date", sDate, 32);
				format(resultline, sizeof(resultline), "%s%s -- Date Submitted: %s\n", resultline, sResult, sDate);
			}
			ShowPlayerDialogEx(playerid, NATION_APP_LIST, DIALOG_STYLE_LIST, "Nation Applications", resultline, "Select", "Cancel");
		}
	    case AddQueue:
	    {
			if(rows == 0)
			{
				mysql_format(MainPipeline, query, sizeof(query), "INSERT INTO `nation_queue` (`id`, `playerid`, `name`, `date`, `nation`, `status`) VALUES (NULL, %d, '%s', NOW(), %d, 2)", GetPlayerSQLId(playerid), GetPlayerNameExt(playerid), nation);
				mysql_tquery(MainPipeline, query, "OnQueryFinish", "i", SENDDATA_THREAD);
				PlayerInfo[playerid][pNation] = 1;
			}
			else
			{
				mysql_format(MainPipeline, query, sizeof(query), "INSERT INTO `nation_queue` (`id`, `playerid`, `name`, `date`, `nation`, `status`) VALUES (NULL, %d, NOW(), %d, 1)", GetPlayerSQLId(playerid), GetPlayerNameExt(playerid), nation);
				mysql_tquery(MainPipeline, query, "OnQueryFinish", "i", SENDDATA_THREAD);
			}
		}
	}
	return 1;
}

forward NationAppFinish(playerid, queryid);
public NationAppFinish(playerid, queryid)
{
    new query[300], string[128], sResult[64], rows;
	cache_get_row_count(rows);
	switch(queryid)
	{
		case AcceptApp:
	    {
			for(new i; i < rows; i++)
			{
				cache_get_value_name(i, "id", sResult); new AppID = strval(sResult);
				cache_get_value_name(i, "playerid", sResult); new UserID = strval(sResult);
				cache_get_value_name(i, "name", sResult, MAX_PLAYER_NAME);
				if(GetPVarInt(playerid, "Nation_App_ID") == i)
				{
					mysql_format(MainPipeline, query, sizeof(query), "UPDATE `nation_queue` SET `status` = 2 WHERE `id` = %d", AppID);
					mysql_tquery(MainPipeline, query, "OnQueryFinish", "i", SENDDATA_THREAD);

					new giveplayerid = ReturnUser(sResult);
					switch(arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance])
					{
						case 1:
						{
							if(IsPlayerConnected(giveplayerid))
							{
								PlayerInfo[giveplayerid][pNation] = 0;
								SendClientMessageEx(giveplayerid, COLOR_WHITE, "Your application for San Andreas citizenship has been approved!");
							}
							else
							{
								mysql_format(MainPipeline, query, sizeof(query), "UPDATE `accounts` SET `Nation` = 0 WHERE `id` = %d", UserID);
								mysql_tquery(MainPipeline, query, "OnQueryFinish", "i", SENDDATA_THREAD);
							}
							format(string, sizeof(string), "%s has approved %s's application for San Andreas citizenship", GetPlayerNameEx(playerid), sResult);
						}
						case 2:
						{
							if(IsPlayerConnected(giveplayerid))
							{
								PlayerInfo[giveplayerid][pNation] = 1;
								SendClientMessageEx(giveplayerid, COLOR_WHITE, "Your application for New Robada citizenship has been approved!");
							}
							else
							{
								mysql_format(MainPipeline, query, sizeof(query), "UPDATE `accounts` SET `Nation` = 1 WHERE `id` = %d", UserID);
								mysql_tquery(MainPipeline, query, "OnQueryFinish", "i", SENDDATA_THREAD);
							}
							format(string, sizeof(string), "%s(%d) has approved %s's(%d) application for New Robada citizenship", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), sResult, UserID);
						}
					}
					Log("logs/gov.log", string);
					format(string, sizeof(string), "You have successfully approved %s's application.", sResult);
					SendClientMessageEx(playerid, COLOR_WHITE, string);
					DeletePVar(playerid, "Nation_App_ID");
				}
			}
		}
	    case DenyApp:
	    {
			for(new i; i < rows; i++)
			{
				cache_get_value_name(i, "id", sResult, 32); new AppID = strval(sResult);
				cache_get_value_name(i, "name", sResult, MAX_PLAYER_NAME);
				if(GetPVarInt(playerid, "Nation_App_ID") == i)
				{
					mysql_format(MainPipeline, query, sizeof(query), "UPDATE `nation_queue` SET `status` = 3 WHERE `id` = %d", AppID);
					mysql_tquery(MainPipeline, query, "OnQueryFinish", "i", SENDDATA_THREAD);
					new giveplayerid = ReturnUser(sResult);
					switch(arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance])
					{
						case 1:
						{
							if(IsPlayerConnected(giveplayerid)) SendClientMessageEx(giveplayerid, COLOR_GREY, "Your application for San Andreas citizenship has been denied.");
							format(string, sizeof(string), "%s has denied %s's application for San Andreas citizenship", GetPlayerNameEx(playerid), sResult);
						}
						case 2:
						{
							if(IsPlayerConnected(giveplayerid)) SendClientMessageEx(giveplayerid, COLOR_GREY, "Your application for San Andreas citizenship has been denied.");
							format(string, sizeof(string), "%s has denied %s's application for New Robada citizenship", GetPlayerNameEx(playerid), sResult);
						}
					}
					Log("logs/gov.log", string);
					format(string, sizeof(string), "You have successfully denied %s's application.", sResult);
					SendClientMessageEx(playerid, COLOR_WHITE, string);
					DeletePVar(playerid, "Nation_App_ID");
				}
			}
		}
	}
	return 1;
}

forward CountAmount(playerid);
public CountAmount(playerid)
{
    new rows;
	cache_get_row_count(rows);
	PlayerInfo[playerid][pLottoNr] = rows;
	return 1;
}

forward UnreadMailsNotificationQueryFin(playerid);
public UnreadMailsNotificationQueryFin(playerid)
{
	new szResult[8];
	cache_get_value_name(0, "Unread_Count", szResult);
	if (strval(szResult) > 0) {
		SetPVarInt(playerid, "UnreadMails", 1);
		SendClientMessageEx(playerid, COLOR_YELLOW, "You have unread items in your mailbox.");
	}
	return 1;
}


forward RecipientLookupFinish(playerid);
public RecipientLookupFinish(playerid)
{
	new rows, szResult[16], admin, undercover, id;
	cache_get_row_count(rows);

	if (!rows) return ShowPlayerDialogEx(playerid, DIALOG_PORECEIVER, DIALOG_STYLE_INPUT, "Recipient", "{FF3333}Error: {FFFFFF}Invalid Recipient - Account does not exist!\n\nPlease type the name of the recipient (online or offline)", "Next", "Cancel");

	cache_get_value_name(0, "AdminLevel", szResult); admin = strval(szResult);
	cache_get_value_name(0, "TogReports", szResult); undercover = strval(szResult);
	cache_get_value_name(0, "id", szResult); id = strval(szResult);

	if (admin >= 2 && undercover == 0) return ShowPlayerDialogEx(playerid, DIALOG_PORECEIVER, DIALOG_STYLE_INPUT, "Recipient", "{FF3333}Error: {FFFFFF}You can't send a letter to admins!\n\nPlease type the name of the recipient (online or offline)", "Next", "Cancel");

	SetPVarInt(playerid, "LetterRecipient", id);
	ShowPlayerDialogEx(playerid, DIALOG_POMESSAGE, DIALOG_STYLE_INPUT, "Send Letter", "{FFFFFF}Please type the message.", "Send", "Cancel");

	return 1;

}

forward CheckSales(index);
public CheckSales(index)
{
	if(IsPlayerConnected(index))
	{
	    new rows, szDialog[512];
		cache_get_row_count(rows);
	    if(rows > 0)
		{
  			for(new i;i < rows;i++)
			{
			    new szResult[32], id;
			    cache_get_value_name(i, "id", szResult); id = strval(szResult);
   				cache_get_value_name(i, "Month", szResult, 25);
   				format(szDialog, sizeof(szDialog), "%s\n%s ", szDialog, szResult);
   				Selected[index][i] = id;
			}
			ShowPlayerDialogEx(index, DIALOG_VIEWSALE, DIALOG_STYLE_LIST, "Select a time frame", szDialog, "View", "Exit");
		}
		else
		{
		    SendClientMessageEx(index, COLOR_WHITE, "There was an issue with checking the table.");
		}
	}
}

forward CheckSales2(index);
public CheckSales2(index)
{
	if(IsPlayerConnected(index))
	{
        new rows, szDialog[3000];
		cache_get_row_count(rows);
	    if(rows)
		{
		    new szResult[32], szField[15], Solds[MAX_ITEMS], Amount[MAX_ITEMS];
		    for(new z = 0; z < MAX_ITEMS; z++)
			{
				format(szField, sizeof(szField), "TotalSold%d", z);
				cache_get_value_name(0,  szField, szResult);
				Solds[z] = strval(szResult);

				format(szField, sizeof(szField), "AmountMade%d", z);
				cache_get_value_name(0,  szField, szResult);
				Amount[z] = strval(szResult);
			}

     	    format(szDialog, sizeof(szDialog),"\
		 	Gold VIP Sold: %d | Total Credits: %s\n\
		 	Gold VIP Renew Sold: %d | Total Credits: %s\n\
		 	Silver VIP Sold: %d | Total Credits: %s\n\
		 	Bronze VIP Sold: %d | Total Credits: %s\n\
		 	Toys Sold: %d | Total Credits: %s\n\
		 	Cars Sold: %d | Total Credits: %s\n", Solds[0], number_format(Amount[0]), Solds[1], number_format(Amount[1]), Solds[2], number_format(Amount[2]), Solds[3], number_format(Amount[3]), Solds[4], number_format(Amount[4]),
			 Solds[5], number_format(Amount[5]));

		 	format(szDialog, sizeof(szDialog), "%s\
		 	Pokertables Sold: %d | Total Credits: %s\n\
		 	Boomboxes Sold: %d | Total Credits: %s\n\
		 	Paintball Tokens Sold: %d | Total Credits: %s\n\
		 	EXP Tokens Sold: %d | Total Credits: %s\n\
		 	Fireworks Sold: %d | Total Credits: %s\n", szDialog, Solds[6], number_format(Amount[6]), Solds[7], number_format(Amount[7]), Solds[8], number_format(Amount[8]), Solds[9], number_format(Amount[9]), Solds[10], number_format(Amount[10]));

			format(szDialog, sizeof(szDialog), "%sBusiness Renew Regular Sold: %d | Total Credits: %s\n\
		 	Business Renew Standard Sold: %d | Total Credits: %s\n\
		 	Business Renew Premium Sold: %d | Total Credits: %s\n\
		 	Houses Sold: %d | Total Credits: %s\n", szDialog, Solds[11], number_format(Amount[11]), Solds[12], number_format(Amount[12]), Solds[13], number_format(Amount[13]), Solds[14], number_format(Amount[14]));

		 	format(szDialog, sizeof(szDialog), "%sHouse Moves Sold: %d | Total Credits: %s\n\
		 	House Interiors Sold: %d | Total Credits: %s\n\
			Reset Gift Timer Sold: %d | Total Credits: %s\n\
			Advanced Health Care Sold: %d | Total Credits: %s\n",szDialog, Solds[15], number_format(Amount[15]), Solds[16], number_format(Amount[16]), Solds[17], number_format(Amount[17]), Solds[18], number_format(Amount[18]));

			format(szDialog, sizeof(szDialog), "%sSuper Health Car Sold: %d | Total Credits: %s\n\
			Rented Cars Sold: %d | Total Credits: %s\n\
			Custom License Sold: %d | Total Credits: %s\n\
			Additional Vehicle Slot Sold: %d | Total Credits: %s\n",szDialog, Solds[19], number_format(Amount[19]), Solds[20], number_format(Amount[20]),Solds[22], number_format(Amount[22]), Solds[23], number_format(Amount[23]));

			format(szDialog, sizeof(szDialog), "%sGarage - Small Sold: %d | Total Credits: %s\n\
			Garage - Medium Sold: %d | Total Credits: %s\n\
			Garage - Large Sold: %d | Total Credits: %s\n\
			Garage - Extra Large Sold: %d | Total Credits: %s\n", szDialog, Solds[24], number_format(Amount[24]), Solds[25], number_format(Amount[25]), Solds[26], number_format(Amount[26]), Solds[27], number_format(Amount[27]));

			format(szDialog, sizeof(szDialog), "%sAdditional Toy Slot Sold: %d | Total Credits: %s\n\
			Hunger Voucher: %d | Total Credits: %s\n\
			Spawn at Gold VIP+: %d | Total Credits: %s\n\
			Restricted Last Name (NEW): %d | Total Credits: %s\n\
			Restricted Last Name (CHANGE): %d | Total Credits: %s\n", szDialog, Solds[28], number_format(Amount[28]), Solds[29], number_format(Amount[29]), Solds[30], number_format(Amount[30]), Solds[31], number_format(Amount[31]), Solds[32], number_format(Amount[32]));

			format(szDialog, sizeof(szDialog), "%sCustom User Title (NEW): %d | Total Credits: %s\n\
			Custom User Title (CHANGE): %d | Total Credits: %s\n\
			Teamspeak User Channel: %d | Total Credits: %s\n\
			Small Backpack: %d | Total Credits: %s\n\
			Medium Backpack: %d | Total Credits: %s\n\
			Large Backpack: %d | Total Credits: %s\n\
			Deluxe Car Alarm: %d | Total Credits: %s\n\
			Name Changes: %d | Total Credits: %s\n",
			szDialog, Solds[33], number_format(Amount[33]), Solds[34], number_format(Amount[34]), Solds[35], number_format(Amount[35]), Solds[36], number_format(Amount[36]), Solds[37], number_format(Amount[37]), Solds[38], number_format(Amount[38]), Solds[39], number_format(Amount[39]), Solds[40], number_format(Amount[40]));

			format(szDialog, sizeof(szDialog), "%sCredits Transactions: %d | Total Credits %s", szDialog, Solds[21], number_format(Amount[21]));
		 	ShowPlayerDialogEx(index, DIALOG_VIEWSALE2, DIALOG_STYLE_MSGBOX, "Shop Statistics", szDialog, "Next", "Exit");
		}
		else
		{
		    SendClientMessageEx(index, COLOR_GREY, "There was an issue with checking the table.");
		}
	}
}

forward CheckSales3(index);
public CheckSales3(index)
{
	if(IsPlayerConnected(index))
	{
		new rows, value;
		cache_get_row_count(rows);
		if(rows)
		{
			new szDialog[1024], szField[15], mSolds[MAX_MICROITEMS], mAmount[MAX_MICROITEMS], Total, mTotal;
			for(new z = 0; z < MAX_ITEMS; z++)
			{
				format(szField, sizeof(szField), "AmountMade%d", z);
				Total += cache_get_value_name_int(0, szField, value);
			}
			cache_get_value_name(0, "TotalSoldMicro", szDialog);
			sscanf(szDialog, MicroSpecifier, mSolds);
			cache_get_value_name(0, "AmountMadeMicro", szDialog);
			sscanf(szDialog, MicroSpecifier, mAmount);
			szDialog[0] = 0;
			for(new m; m < MAX_MICROITEMS; m++)
			{
				format(szDialog, sizeof(szDialog), "%s%s: %s | Total Credits: %s\n", szDialog, mItemName[m], number_format(mSolds[m]), number_format(mAmount[m]));
				mTotal += mAmount[m];
			}
			format(szDialog, sizeof(szDialog), "%sTotal Amount of Credits spent: %s", szDialog, number_format(Total+mTotal));
			ShowPlayerDialogEx(index, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Shop Statistics", szDialog, "Exit", "");
		}
		else
		{
			SendClientMessageEx(index, COLOR_GREY, "There was an issue with checking the table.");
		}
	}
}

forward LoadRentedCar(index);
public LoadRentedCar(index)
{
	if(IsPlayerConnected(index))
	{
	    new rows;
	    cache_get_row_count(rows);
		if(rows)
		{
		    //`sqlid`, `modelid`, `posx`, `posy`, `posz`, `posa`, `spawned`, `hours`

            new szResult[32], Info[2], Float: pos[4], string[128];
 	    	cache_get_value_name(0, "modelid", szResult); Info[0] = strval(szResult);
  	    	cache_get_value_name(0, "posx", szResult); pos[0] = strval(szResult);
   	    	cache_get_value_name(0, "posy", szResult); pos[1] = strval(szResult);
    	    cache_get_value_name(0, "posz", szResult); pos[2] = strval(szResult);
    	    cache_get_value_name(0, "posa", szResult); pos[3] = strval(szResult);
    	    cache_get_value_name(0, "hours", szResult); Info[1] = strval(szResult);

			SetPVarInt(index, "RentedHours", Info[1]);
			SetPVarInt(index, "RentedVehicle", CreateVehicle(Info[0],pos[0],pos[1], pos[2], pos[3], random(128), random(128), 2000000));

			format(string, sizeof(string), "Your rented vehicle has been spawned and has %d minute(s) left.", Info[1]);
			SendClientMessageEx(index, COLOR_CYAN, string);
		}
	}
}

forward LoadTicket(playerid);
public LoadTicket(playerid) {
 	new rows;
	cache_get_row_count(rows);

	if (rows == 0) {
		return 1;
	}

    new number, result[10];
	for(new i; i < rows; i++)
	{
    	cache_get_value_name(i, "number", result);
    	number = strval(result);
		LottoNumbers[playerid][i] = number;
	}
	return 1;
}

forward LoadTreasureInvent(playerid);
public LoadTreasureInvent(playerid)
{
    new rows, szResult[10];
	cache_get_row_count(rows);

    if(IsPlayerConnected(playerid))
    {
        if(!rows)
        {
            new query[60];
            mysql_format(MainPipeline, query, sizeof(query), "INSERT INTO `jobstuff` (`pId`) VALUES ('%d')", GetPlayerSQLId(playerid));
			mysql_tquery(MainPipeline, query, "OnQueryFinish", "i", SENDDATA_THREAD);
        }
        else
        {
    		for(new row;row < rows;row++)
			{
				cache_get_value_name(row, "junkmetal", szResult); SetPVarInt(playerid, "JunkMetal", strval(szResult));
				cache_get_value_name(row, "newcoin", szResult); SetPVarInt(playerid, "newcoin", strval(szResult));
				cache_get_value_name(row, "oldcoin", szResult); SetPVarInt(playerid, "oldcoin", strval(szResult));
				cache_get_value_name(row, "brokenwatch", szResult); SetPVarInt(playerid, "brokenwatch", strval(szResult));
				cache_get_value_name(row, "oldkey", szResult); SetPVarInt(playerid, "oldkey", strval(szResult));
				cache_get_value_name(row, "treasure", szResult); SetPVarInt(playerid, "treasure", strval(szResult));
				cache_get_value_name(row, "goldwatch", szResult); SetPVarInt(playerid, "goldwatch", strval(szResult));
				cache_get_value_name(row, "silvernugget", szResult); SetPVarInt(playerid, "silvernugget", strval(szResult));
				cache_get_value_name(row, "goldnugget", szResult); SetPVarInt(playerid, "goldnugget", strval(szResult));
			}
		}
	}
	return 1;
}

forward GetHomeCount(playerid);
public GetHomeCount(playerid)
{
	new string[128];
	mysql_format(MainPipeline, string, sizeof(string), "SELECT NULL FROM `houses` WHERE `OwnerID` = %d", GetPlayerSQLId(playerid));
	return mysql_tquery(MainPipeline, string, "QueryGetCountFinish", "ii", playerid, 2);
}

forward AddReportToken(playerid);
public AddReportToken(playerid)
{
	new
		sz_playerName[MAX_PLAYER_NAME],
		i_timestamp[3],
		tdate[11],
		thour[9],
		query[128];

	GetPlayerName(playerid, sz_playerName, MAX_PLAYER_NAME);
	getdate(i_timestamp[0], i_timestamp[1], i_timestamp[2]);
	format(tdate, sizeof(tdate), "%d-%02d-%02d", i_timestamp[0], i_timestamp[1], i_timestamp[2]);
	format(thour, sizeof(thour), "%02d:00:00", hour);

	mysql_format(MainPipeline, query, sizeof(query), "SELECT NULL FROM `tokens_report` WHERE `playerid` = %d AND `date` = '%s' AND `hour` = '%s'", GetPlayerSQLId(playerid), tdate, thour);
	mysql_tquery(MainPipeline, query, "QueryTokenFinish", "ii", playerid, 1);
	return 1;
}

forward AddCAReportToken(playerid);
public AddCAReportToken(playerid)
{
	new
		sz_playerName[MAX_PLAYER_NAME],
		i_timestamp[3],
		tdate[11],
		thour[9],
		query[128];

	GetPlayerName(playerid, sz_playerName, MAX_PLAYER_NAME);
	getdate(i_timestamp[0], i_timestamp[1], i_timestamp[2]);
	format(tdate, sizeof(tdate), "%d-%02d-%02d", i_timestamp[0], i_timestamp[1], i_timestamp[2]);
	format(thour, sizeof(thour), "%02d:00:00", hour);

	mysql_format(MainPipeline, query, sizeof(query), "SELECT NULL FROM `tokens_request` WHERE `playerid` = %d AND `date` = '%s' AND `hour` = '%s'", GetPlayerSQLId(playerid), tdate, thour);
	mysql_tquery(MainPipeline, query, "QueryTokenFinish", "ii", playerid, 2);
	return 1;
}

forward AddCallToken(playerid);
public AddCallToken(playerid)
{
	new
		sz_playerName[MAX_PLAYER_NAME],
		i_timestamp[3],
		tdate[11],
		query[128];

	GetPlayerName(playerid, sz_playerName, MAX_PLAYER_NAME);
	getdate(i_timestamp[0], i_timestamp[1], i_timestamp[2]);
	format(tdate, sizeof(tdate), "%d-%02d-%02d", i_timestamp[0], i_timestamp[1], i_timestamp[2]);

	mysql_format(MainPipeline, query, sizeof(query), "SELECT NULL FROM `tokens_call` WHERE `playerid` = %d AND `date` = '%s' AND `hour` = %d", GetPlayerSQLId(playerid), tdate, hour);
	mysql_tquery(MainPipeline, query, "QueryTokenFinish", "ii", playerid, 3);
	return 1;
}

forward AddWDToken(playerid);
public AddWDToken(playerid)
{
	new
		sz_playerName[MAX_PLAYER_NAME],
		i_timestamp[3],
		tdate[11],
		thour[9],
		query[128];

	GetPlayerName(playerid, sz_playerName, MAX_PLAYER_NAME);
	getdate(i_timestamp[0], i_timestamp[1], i_timestamp[2]);
	format(tdate, sizeof(tdate), "%d-%02d-%02d", i_timestamp[0], i_timestamp[1], i_timestamp[2]);
	format(thour, sizeof(thour), "%02d:00:00", hour);

	mysql_format(MainPipeline, query, sizeof(query), "SELECT NULL FROM `tokens_wd` WHERE `playerid` = %d AND `date` = '%s' AND `hour` = '%s'", GetPlayerSQLId(playerid), tdate, thour);
	mysql_tquery(MainPipeline, query, "QueryTokenFinish", "ii", playerid, 4);
	return 1;
}

forward QueryTokenFinish(playerid, type);
public QueryTokenFinish(playerid, type)
{
    new rows, string[128], i_timestamp[3], tdate[11], thour[9];
	cache_get_row_count(rows);
	getdate(i_timestamp[0], i_timestamp[1], i_timestamp[2]);
	format(tdate, sizeof(tdate), "%d-%02d-%02d", i_timestamp[0], i_timestamp[1], i_timestamp[2]);
	format(thour, sizeof(thour), "%02d:00:00", hour);

	switch(type)
	{
		case 1:
		{
			if(rows == 0)
			{
				mysql_format(MainPipeline, string, sizeof(string), "INSERT INTO `tokens_report` (`id`, `playerid`, `date`, `hour`, `count`) VALUES (NULL, %d, '%s', '%s', 1)", GetPlayerSQLId(playerid), tdate, thour);
				mysql_tquery(MainPipeline, string, "OnQueryFinish", "i", SENDDATA_THREAD);
			}
			else
			{
				mysql_format(MainPipeline, string, sizeof(string), "UPDATE `tokens_report` SET `count` = count+1 WHERE `playerid` = %d AND `date` = '%s' AND `hour` = '%s'", GetPlayerSQLId(playerid), tdate, thour);
				mysql_tquery(MainPipeline, string, "OnQueryFinish", "i", SENDDATA_THREAD);
			}
		}
		case 2:
		{
			if(rows == 0)
			{
				mysql_format(MainPipeline, string, sizeof(string), "INSERT INTO `tokens_request` (`id`, `playerid`, `date`, `hour`, `count`) VALUES (NULL, %d, '%s', '%s', 1)", GetPlayerSQLId(playerid), tdate, thour);
				mysql_tquery(MainPipeline, string, "OnQueryFinish", "i", SENDDATA_THREAD);
			}
			else
			{
				mysql_format(MainPipeline, string, sizeof(string), "UPDATE `tokens_request` SET `count` = count+1 WHERE `playerid` = %d AND `date` = '%s' AND `hour` = '%s'", GetPlayerSQLId(playerid), tdate, thour);
				mysql_tquery(MainPipeline, string, "OnQueryFinish", "i", SENDDATA_THREAD);
			}
		}
		case 3:
		{
			if(rows == 0)
			{
				mysql_format(MainPipeline, string, sizeof(string), "INSERT INTO `tokens_call` (`id`, `playerid`, `date`, `hour`, `count`) VALUES (NULL, %d, '%s', %d, 1)", GetPlayerSQLId(playerid), tdate, hour);
				mysql_tquery(MainPipeline, string, "OnQueryFinish", "i", SENDDATA_THREAD);
			}
			else
			{
				mysql_format(MainPipeline, string, sizeof(string), "UPDATE `tokens_call` SET `count` = count+1 WHERE `playerid` = %d AND `date` = '%s' AND `hour` = %d", GetPlayerSQLId(playerid), tdate, hour);
				mysql_tquery(MainPipeline, string, "OnQueryFinish", "i", SENDDATA_THREAD);
			}
		}
		case 4:
		{
			if(rows == 0)
			{
				mysql_format(MainPipeline, string, sizeof(string), "INSERT INTO `tokens_wd` (`id`, `playerid`, `date`, `hour`, `count`) VALUES (NULL, %d, '%s', '%s', 1)", GetPlayerSQLId(playerid), tdate, thour);
				mysql_tquery(MainPipeline, string, "OnQueryFinish", "i", SENDDATA_THREAD);
			}
			else
			{
				mysql_format(MainPipeline, string, sizeof(string), "UPDATE `tokens_wd` SET `count` = count+1 WHERE `playerid` = %d AND `date` = '%s' AND `hour` = '%s'", GetPlayerSQLId(playerid), tdate, thour);
				mysql_tquery(MainPipeline, string, "OnQueryFinish", "i", SENDDATA_THREAD);
			}
		}
	}
	return 1;
}

forward GetReportCount(userid, tdate[]);
public GetReportCount(userid, tdate[])
{
	new string[128];
	mysql_format(MainPipeline, string, sizeof(string), "SELECT SUM(count) FROM `tokens_report` WHERE `playerid` = %d AND `date` = '%s'", GetPlayerSQLId(userid), tdate);
	return mysql_tquery(MainPipeline, string, "QueryGetCountFinish", "ii", userid, 0);
}

forward GetHourReportCount(userid, thour[], tdate[]);
public GetHourReportCount(userid, thour[], tdate[])
{
	new string[128];
	mysql_format(MainPipeline, string, sizeof(string), "SELECT `count` FROM `tokens_report` WHERE `playerid` = %d AND `date` = '%s' AND `hour` = '%s'", GetPlayerSQLId(userid), tdate, thour);
	return mysql_tquery(MainPipeline, string, "QueryGetCountFinish", "ii", userid, 1);
}

forward GetRequestCount(userid, tdate[]);
public GetRequestCount(userid, tdate[])
{
	new string[128];
	mysql_format(MainPipeline, string, sizeof(string), "SELECT SUM(count) FROM `tokens_request` WHERE `playerid` = %d AND `date` = '%s'", GetPlayerSQLId(userid), tdate);
	return mysql_tquery(MainPipeline, string, "QueryGetCountFinish", "ii", userid, 0);
}

forward GetHourRequestCount(userid, thour[], tdate[]);
public GetHourRequestCount(userid, thour[], tdate[])
{
	new string[128];
	mysql_format(MainPipeline, string, sizeof(string), "SELECT `count` FROM `tokens_request` WHERE `playerid` = %d AND `date` = '%s' AND `hour` = '%s'", GetPlayerSQLId(userid), tdate, thour);
	return mysql_tquery(MainPipeline, string, "QueryGetCountFinish", "ii", userid, 1);
}

forward GetWDCount(userid, tdate[]);
public GetWDCount(userid, tdate[])
{
	new string[128];
	mysql_format(MainPipeline, string, sizeof(string), "SELECT SUM(count) FROM `tokens_wd` WHERE `playerid` = %d AND `date` = '%s'", GetPlayerSQLId(userid), tdate);
	return mysql_tquery(MainPipeline, string, "QueryGetCountFinish", "ii", userid, 3);
}

forward GetWDHourCount(userid, thour[], tdate[]);
public GetWDHourCount(userid, thour[], tdate[])
{
	new string[128];
	mysql_format(MainPipeline, string, sizeof(string), "SELECT `count` FROM `tokens_wd` WHERE `playerid` = %d AND `date` = '%s' AND `hour` = '%s'", GetPlayerSQLId(userid), tdate, thour);
	return mysql_tquery(MainPipeline, string, "QueryGetCountFinish", "ii", userid, 4);
}

forward QueryGetCountFinish(userid, type);
public QueryGetCountFinish(userid, type)
{
    new rows, sResult[24], value;
	cache_get_row_count(rows);

	switch(type)
	{
		case 0:
		{
			if(rows > 0)
			{
				cache_get_value_name(0, "SUM(count)", sResult);
				ReportCount[userid] = strval(sResult);
			}
			else ReportCount[userid] = 0;
		}
		case 1:
		{
			if(rows > 0)
			{
				cache_get_value_name(0, "count", sResult);
				ReportHourCount[userid] = strval(sResult);
			}
			else ReportHourCount[userid] = 0;
		}
		case 2:
		{
			Homes[userid] = rows;
		}
		case 3:
		{
			if(rows > 0)
			{
				cache_get_value_name(0, "SUM(count)", sResult);
				WDReportCount[userid] = strval(sResult);
			}
			else WDReportCount[userid] = 0;
		}
		case 4:
		{
			if(rows > 0)
			{
				WDReportHourCount[userid] = cache_get_value_name_int(0, "count", value);
			}
			else WDReportHourCount[userid] = 0;
		}
	}
	return 1;
}

task MailDeliveryTimer[60000 * 5]()
{
	mysql_tquery(MainPipeline, "UPDATE `letters` SET `Delivery_Min` = `Delivery_Min` - 1 WHERE `Delivery_Min` > 0", "OnQueryFinish", "i", SENDDATA_THREAD);
	mysql_tquery(MainPipeline, "SELECT `Receiver_Id` FROM `letters` WHERE `Delivery_Min` = 1", "MailDeliveryQueryFinish", "");
	return 1;
}

forward OnLoadMailboxes();
public OnLoadMailboxes()
{
	new string[512], i;
	new rows, fields;
	cache_get_row_count(rows);
	cache_get_field_count(fields);
	while(i<rows)
	{
	    for(new field; field < fields; field++)
	    {
 		    cache_get_value_index(i, field, string);
			switch(field)
			{
			    case 1: MailBoxes[i][mbVW] = strval(string);
				case 2: MailBoxes[i][mbInt] = strval(string);
				case 3: MailBoxes[i][mbModel] = strval(string);
				case 4: MailBoxes[i][mbPosX] = floatstr(string);
				case 5: MailBoxes[i][mbPosY] = floatstr(string);
				case 6: MailBoxes[i][mbPosZ] = floatstr(string);
				case 7: MailBoxes[i][mbAngle] = floatstr(string);
			}
		}
		if(MailBoxes[i][mbPosX] != 0.0) RenderStreetMailbox(i);
  		i++;
 	}
	if(i > 0) printf("[LoadMailboxes] %d mailboxes rehashed/loaded.", i);
	else printf("[LoadMailboxes] Failed to load any mailboxes.");
	return 1;
}

forward LoadDynamicGroups();
public LoadDynamicGroups()
{
    mysql_tquery(MainPipeline, "SELECT * FROM `groups`", "Group_QueryFinish", "ii", GROUP_QUERY_LOAD, 0);
	mysql_tquery(MainPipeline, "SELECT * FROM `lockers`", "Group_QueryFinish", "ii", GROUP_QUERY_LOCKERS, 0);
	mysql_tquery(MainPipeline, "SELECT * FROM `jurisdictions`", "Group_QueryFinish", "ii", GROUP_QUERY_JURISDICTIONS, 0);
	mysql_tquery(MainPipeline, "SELECT * FROM `gweaponsnew`", "Group_QueryFinish", "ii", GROUP_QUERY_GWEAPONS, 0);
	mysql_tquery(MainPipeline, "SELECT * FROM `locker_restrict`", "Group_QueryFinish", "ii", GROUP_QUERY_GWEAPONS_RANK, 0);
	//mysql_tquery(MainPipeline, "SELECT * FROM `gWeapons`", "Group_QueryFinish", "ii", GROUP_QUERY_GWEAPONS, 0);
	return ;
}

forward ParkRentedVehicle(playerid, vehicleid, modelid, Float:X, Float:Y, Float:Z);
public ParkRentedVehicle(playerid, vehicleid, modelid, Float:X, Float:Y, Float:Z)
{
	if(IsPlayerInRangeOfPoint(playerid, 1.0, X, Y, Z))
	{
	    new Float:x, Float:y, Float:z, Float:angle, Float:health, string[180], Float: oldfuel, arrDamage[4];
	    GetVehicleHealth(vehicleid, health);
     	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessageEx(playerid, COLOR_GREY, "You must be in the driver seat.");
     	if(health < 800) return SendClientMessageEx(playerid, COLOR_GREY, " Your vehicle is too damaged to park it.");

		GetVehiclePos(vehicleid, x, y, z);
		GetVehicleZAngle(vehicleid, angle);
		SurfingCheck(vehicleid);
		oldfuel = VehicleFuel[vehicleid];

		GetVehicleDamageStatus(vehicleid, arrDamage[0], arrDamage[1], arrDamage[2], arrDamage[3]);
		DestroyVehicle(GetPVarInt(playerid, "RentedVehicle"));
        SetPVarInt(playerid, "RentedVehicle", CreateVehicle(modelid, x, y, z, angle, random(128), random(128), 2000000));
		Vehicle_ResetData(GetPVarInt(playerid, "RentedVehicle"));
		VehicleFuel[GetPVarInt(playerid, "RentedVehicle")] = oldfuel;
		SetVehicleHealth(GetPVarInt(playerid, "RentedVehicle"), health);
		UpdateVehicleDamageStatus(vehicleid, arrDamage[0], arrDamage[1], arrDamage[2], arrDamage[3]);

		mysql_format(MainPipeline, string, sizeof(string), "UPDATE `rentedcars` SET `posx` = '%f', `posy` = '%f', `posz` = '%f', `posa` = '%f' WHERE `sqlid` = '%d'", x, y, z, angle, GetPlayerSQLId(playerid));
        mysql_tquery(MainPipeline, string, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);

		IsPlayerEntering{playerid} = true;
		PutPlayerInVehicle(playerid, vehicleid, 0);
		SetPlayerArmedWeapon(playerid, 0);
		format(string, sizeof(string), "* %s has parked their vehicle.", GetPlayerNameEx(playerid));
		ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

	}
	else
	{
	    SendClientMessage(playerid, COLOR_WHITE, "Vehicle did not park because you moved!");
	}
	return 1;
}

forward OnPlayerChangePass(index);
public OnPlayerChangePass(index)
{
	if(cache_affected_rows()) {

		new szMessage[103];

		GetPVarString(index, "PassChange", PlayerInfo[index][pLastPass], 65);
		format(szMessage, sizeof(szMessage), "You have changed your password to '%s'.", PlayerInfo[index][pLastPass]);
		SendClientMessageEx(index, COLOR_YELLOW, szMessage);

		format(szMessage, sizeof(szMessage), "%s(%d) (IP: %s) has changed their password.", GetPlayerNameEx(index), GetPlayerSQLId(index), PlayerInfo[index][pIP]);
		Log("logs/password.log", szMessage);
		DeletePVar(index, "PassChange");
		mysql_format(MainPipeline, szMessage, sizeof(szMessage), "UPDATE `accounts` SET `LastPassChange` = NOW() WHERE `id` = '%i'", PlayerInfo[index][pId]);
		mysql_tquery(MainPipeline, szMessage, "OnQueryFinish", "ii", SENDDATA_THREAD, index);
		if(PlayerInfo[index][pForcePasswordChange] == 1)
		{
		    PlayerInfo[index][pForcePasswordChange] = 0;
		    mysql_format(MainPipeline, szMessage, sizeof(szMessage), "UPDATE `accounts` SET `ForcePasswordChange` = '0' WHERE `id` = '%i'", PlayerInfo[index][pId]);
			mysql_tquery(MainPipeline, szMessage, "OnQueryFinish", "ii", SENDDATA_THREAD, index);
		}
	}
	else {
		SendClientMessageEx(index, COLOR_RED, "There was an issue with processing your request. Your password will remain as it is.");
		if(PlayerInfo[index][pForcePasswordChange] == 1) ShowLoginDialogs(index, 0);
	}
	return 1;
}

forward OnChangeUserPassword(index);
public OnChangeUserPassword(index)
{
	if(GetPVarType(index, "ChangePin"))
	{
	    new string[128], name[24];
		GetPVarString(index, "OnChangeUserPassword", name, 24);

		if(cache_affected_rows()) {
			format(string, sizeof(string), "You have successfully changed %s's pin.", name);
			SendClientMessageEx(index, COLOR_WHITE, string);
		}
		else {
			format(string, sizeof(string), "There was an issue with changing %s's pin.", name);
			format(string, sizeof(string), "There was an issue with changing %s's pin.", name);
			SendClientMessageEx(index, COLOR_WHITE, string);
		}
		DeletePVar(index, "ChangePin");
		DeletePVar(index, "OnChangeUserPassword");
	}
	else
	{
		new string[128], name[24];
		GetPVarString(index, "OnChangeUserPassword", name, 24);

		if(cache_affected_rows()) {
			format(string, sizeof(string), "You have successfully changed %s's password.", name);
			SendClientMessageEx(index, COLOR_WHITE, string);
		}
		else {
			format(string, sizeof(string), "There was an issue with changing %s's password.", name);
			SendClientMessageEx(index, COLOR_WHITE, string);
		}
		DeletePVar(index, "OnChangeUserPassword");
	}
	return 1;
}

forward QueryCheckCountFinish(playerid, giveplayername[], tdate[], type);
public QueryCheckCountFinish(playerid, giveplayername[], tdate[], type)
{
    new string[128], rows, sResult[24], tcount, hhour[9], chour;
	cache_get_row_count(rows);

	switch(type)
	{
		case 0:
		{
			cache_get_value_name(0, "SUM(count)", sResult); tcount = strval(sResult);
			if(tcount > 0)
			{
				format(string, sizeof(string), "%s accepted {%06x}%d {%06x}reports on %s.", giveplayername, COLOR_GREEN >>> 8, tcount, COLOR_WHITE >>> 8, tdate);
				SendClientMessageEx(playerid, COLOR_WHITE, string);
			}
			else
			{
				format(string, sizeof(string), "%s did not accept any reports on %s.", giveplayername, tdate);
				return SendClientMessageEx(playerid, COLOR_GRAD1, string);
			}
		}
		case 1:
		{
			if(rows > 0)
			{
				SendClientMessageEx(playerid, COLOR_GRAD1, "By hour:");
				for(new i; i < rows; i++)
				{
					cache_get_value_name(i, "count", sResult); new hcount = strval(sResult);
					cache_get_value_name(i, "hour", hhour, sizeof(hhour));
					format(hhour, sizeof(hhour), "%s", str_replace(":00:00", "", hhour));
					chour = strval(hhour);
					format(string, sizeof(string), "%s: {%06x}%d", ConvertToTwelveHour(chour), COLOR_GREEN >>> 8, hcount);
					SendClientMessageEx(playerid, COLOR_WHITE, string);
				}
			}
		}
		case 2:
		{
			cache_get_value_name(0, "SUM(count)", sResult); tcount = strval(sResult);
			if(tcount > 0)
			{
				format(string, sizeof(string), "%s accepted {%06x}%d {%06x}help requests on %s.", giveplayername, COLOR_GREEN >>> 8, tcount, COLOR_WHITE >>> 8, tdate);
				SendClientMessageEx(playerid, COLOR_WHITE, string);
			}
			else
			{
				format(string, sizeof(string), "%s did not accept any help requests on %s.", giveplayername, tdate);
				return SendClientMessageEx(playerid, COLOR_GRAD1, string);
			}
		}
		case 3:
		{
			if(rows > 0)
			{
				SendClientMessageEx(playerid, COLOR_GRAD1, "By hour:");
				for(new i; i < rows; i++)
				{
					cache_get_value_name(i, "count", sResult); new hcount = strval(sResult);
					cache_get_value_name(i, "hour", hhour, sizeof(hhour));
					format(hhour, sizeof(hhour), "%s", str_replace(":00:00", "", hhour));
					chour = strval(hhour);
					format(string, sizeof(string), "%s: {%06x}%d", ConvertToTwelveHour(chour), COLOR_GREEN >>> 8, hcount);
					SendClientMessageEx(playerid, COLOR_WHITE, string);
				}
			}
		}
		case 4:
		{
			cache_get_value_name(0, "SUM(count)", sResult); tcount = strval(sResult);
			if(tcount > 0)
			{
				format(string, sizeof(string), "%s watched {%06x}%d {%06x}people on %s.", giveplayername, COLOR_GREEN >>> 8, tcount, COLOR_WHITE >>> 8, tdate);
				SendClientMessageEx(playerid, COLOR_WHITE, string);
			}
			else
			{
				format(string, sizeof(string), "%s did not watch anyone on %s.", giveplayername, tdate);
				return SendClientMessageEx(playerid, COLOR_GRAD1, string);
			}
		}
		case 5:
		{
			if(rows > 0)
			{
				SendClientMessageEx(playerid, COLOR_GRAD1, "By hour:");
				for(new i; i < rows; i++)
				{
					cache_get_value_name(i, "count", sResult); new hcount = strval(sResult);
					cache_get_value_name(i, "hour", hhour, sizeof(hhour));
					format(hhour, sizeof(hhour), "%s", str_replace(":00:00", "", hhour));
					chour = strval(hhour);
					format(string, sizeof(string), "%s: {%06x}%d", ConvertToTwelveHour(chour), COLOR_GREEN >>> 8, hcount);
					SendClientMessageEx(playerid, COLOR_WHITE, string);
				}
			}
		}
	}
	return 1;
}

forward QueryUsernameCheck(playerid, tdate[], type);
public QueryUsernameCheck(playerid, tdate[], type)
{
    new string[128], rows, giveplayerid, sResult[MAX_PLAYER_NAME];
	cache_get_row_count(rows);

	if(rows > 0)
	{
		switch(type)
		{
			case 0:
			{
				cache_get_value_name(0, "id", sResult); giveplayerid = strval(sResult);
				cache_get_value_name(0, "Username", sResult, sizeof(sResult));
				mysql_format(MainPipeline, string, sizeof(string), "SELECT SUM(count) FROM `tokens_report` WHERE `playerid` = %d AND `date` = '%s'", giveplayerid, tdate);
				mysql_tquery(MainPipeline, string, "QueryCheckCountFinish", "issi", playerid, sResult, tdate, 0);
				mysql_format(MainPipeline, string, sizeof(string), "SELECT `count`, `hour` FROM `tokens_report` WHERE `playerid` = %d AND `date` = '%s' ORDER BY `hour` ASC", giveplayerid, tdate);
				mysql_tquery(MainPipeline, string, "QueryCheckCountFinish", "issi", playerid, sResult, tdate, 1);
			}
			case 1:
			{
				cache_get_value_name(0, "id", sResult); giveplayerid = strval(sResult);
				cache_get_value_name(0, "Username", sResult, sizeof(sResult));
				mysql_format(MainPipeline, string, sizeof(string), "SELECT SUM(count) FROM `tokens_request` WHERE `playerid` = %d AND `date` = '%s'", giveplayerid, tdate);
				mysql_tquery(MainPipeline, string, "QueryCheckCountFinish", "issi", playerid, sResult, tdate, 2);
				mysql_format(MainPipeline, string, sizeof(string), "SELECT `count`, `hour` FROM `tokens_request` WHERE `playerid` = %d AND `date` = '%s' ORDER BY `hour` ASC", giveplayerid, tdate);
				mysql_tquery(MainPipeline, string, "QueryCheckCountFinish", "issi", playerid, sResult, tdate, 3);
			}
			case 2:
			{
				cache_get_value_name(0, "id", sResult); giveplayerid = strval(sResult);
				cache_get_value_name(0, "Username", sResult, sizeof(sResult));
				mysql_format(MainPipeline, string, sizeof(string), "SELECT SUM(count) FROM `tokens_wd` WHERE `playerid` = %d AND `date` = '%s'", giveplayerid, tdate);
				mysql_tquery(MainPipeline, string, "QueryCheckCountFinish", "issi", playerid, sResult, tdate, 4);
				mysql_format(MainPipeline, string, sizeof(string), "SELECT `count`, `hour` FROM `tokens_wd` WHERE `playerid` = %d AND `date` = '%s' ORDER BY `hour` ASC", giveplayerid, tdate);
				mysql_tquery(MainPipeline, string, "QueryCheckCountFinish", "issi", playerid, sResult, tdate, 5);
			}
		}
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD1, "That account doesn't exist!");
	return 1;
}

forward OnBanPlayer(index);
public OnBanPlayer(index)
{
	new string[128], name[24], reason[64];
	GetPVarString(index, "OnBanPlayer", name, 24);
	GetPVarString(index, "OnBanPlayerReason", reason, 64);

	if(IsPlayerConnected(index))
	{
		if(cache_affected_rows()) {
			format(string, sizeof(string), "You have successfully banned %s's account.", name);
			SendClientMessageEx(index, COLOR_WHITE, string);

			format(string, sizeof(string), "AdmCmd: %s was offline banned by %s, reason: %s", name, GetPlayerNameEx(index), reason);
			Log("logs/ban.log", string);
			format(string, 128, "AdmCmd: %s was offline banned by %s, reason: %s", name, GetPlayerNameEx(index), reason);
			ABroadCast(COLOR_LIGHTRED,string,2);
			print(string);
		}
		else {
			format(string, sizeof(string), "There was an issue with banning %s's account.", name);
			SendClientMessageEx(index, COLOR_WHITE, string);
		}
  		DeletePVar(index, "OnBanPlayer");
		DeletePVar(index, "OnBanPlayerReason");
	}
	return 1;
}

forward OnBanIP(index);
public OnBanIP(index)
{
	if(IsPlayerConnected(index))
	{
		new rows;
		new string[256], ip[32], id, value;
		cache_get_row_count(rows);
		if(rows)
		{
			id = cache_get_value_name_int(0, "id", value);
			cache_get_value_name(0, "IP", ip);

			MySQLBan(id, ip, "Offline Banned (/banaccount)", 1, GetPlayerNameEx(index));

			mysql_format(MainPipeline, string, sizeof(string), "INSERT INTO `ip_bans` (`ip`, `date`, `reason`, `admin`) VALUES ('%s', NOW(), '%s', '%s')", ip, "Offline Banned", GetPlayerNameEx(index));
			mysql_tquery(MainPipeline, string, "OnQueryFinish", "i", SENDDATA_THREAD);
		}
	}
	return 1;
}

forward OnUnbanPlayer(index);
public OnUnbanPlayer(index)
{
	new string[128], name[24];
	GetPVarString(index, "OnUnbanPlayer", name, 24);

	if(cache_affected_rows()) {
		format(string, sizeof(string), "You have successfully unbanned %s's account.", name);
		SendClientMessageEx(index, COLOR_WHITE, string);

		format(string, 128, "AdmCmd: %s was unbanned by %s.", name, GetPlayerNameEx(index));
		ABroadCast(COLOR_LIGHTRED,string,2);
		format(string, sizeof(string), "AdmCmd: %s was unbanned by %s.", name, GetPlayerNameEx(index));
		Log("logs/ban.log", string);
		print(string);
	}
	else {
		format(string, sizeof(string), "There was an issue with unbanning %s's account.", name);
		SendClientMessageEx(index, COLOR_WHITE, string);
	}
	DeletePVar(index, "OnUnbanPlayer");

	return 1;
}

forward OnUnbanIP(index);
public OnUnbanIP(index)
{
	if(IsPlayerConnected(index))
	{
	    new string[128], ip[16];
        new rows;
		cache_get_row_count(rows);
		if(rows) {
			cache_get_value_name(0, "IP", ip, 16);
			//RemoveBan(index, ip);

			mysql_format(MainPipeline, string, sizeof(string), "UPDATE `bans` SET `status` = 4, `date_unban` = NOW() WHERE `ip_address` = '%s'", ip);
			mysql_tquery(MainPipeline, string, "OnQueryFinish", "i", SENDDATA_THREAD);
		}
	}
	return 1;
}

// Use this for generic "You have successfully altered X's account" messages... no need for 578947 public functions!
forward Query_OnExecution(iTargetID);
public Query_OnExecution(iTargetID) {

	new
		szName[MAX_PLAYER_NAME],
		szMessage[64];

	GetPVarString(iTargetID, "QueryEx_Name", szName, sizeof szName);
	if(cache_affected_rows()) {
		format(szMessage, sizeof szMessage, "The query on %s's account was successful.", szName);
		SendClientMessageEx(iTargetID, COLOR_WHITE, szMessage);
	}
	else {
		format(szMessage, sizeof szMessage, "The query on %s's account was unsuccessful.", szName);
		SendClientMessageEx(iTargetID, COLOR_WHITE, szMessage);
	}
	return DeletePVar(iTargetID, "QueryEx_Name");
}

forward OnSetSuspended(index, value);
public OnSetSuspended(index, value)
{
	new string[128], name[24];
	GetPVarString(index, "OnSetSuspended", name, 24);

	if(cache_affected_rows()) {
		format(string, sizeof(string), "You have successfully %s %s's account.", ((value) ? ("suspended") : ("unsuspended")), name);
		SendClientMessageEx(index, COLOR_WHITE, string);

		format(string, sizeof(string), "AdmCmd: %s was offline %s by %s.", name, ((value) ? ("suspended") : ("unsuspended")), GetPlayerNameEx(index));
		Log("logs/admin.log", string);
	}
	else {
		format(string, sizeof(string), "There was an issue with %s %s's account.", ((value) ? ("suspending") : ("unsuspending")), name);
		SendClientMessageEx(index, COLOR_WHITE, string);
	}
	DeletePVar(index, "OnSetSuspended");

	return 1;
}

forward OnSetCrime(index);
public OnSetCrime(index)
{
	new string[128], name[24];
	GetPVarString(index, "OfflineSU", name, 24);

	if(cache_affected_rows()) {
		format(string, sizeof(string), "You have successfully added a crime to %s's account.", name);
		SendClientMessageEx(index, COLOR_WHITE, string);
	}
	else {
		format(string, sizeof(string), "There was an issue with adding a crime to %s's account.", name);
		SendClientMessageEx(index, COLOR_WHITE, string);
	}
	DeletePVar(index, "OfflineSU");

	return 1;
}

forward OnSetMyName(index);
public OnSetMyName(index)
{
	if(IsPlayerConnected(index))
	{
		new rows;
		cache_get_row_count(rows);
		if(!rows)
		{
			new string[128], tmpName[24];
			GetPVarString(index, "OnSetMyName", tmpName, 24);

			new name[MAX_PLAYER_NAME];
			GetPlayerName(index, name, sizeof(name));
			SetPVarString(index, "TempNameName", name);
			if(strlen(tmpName) > 0)
			{
				SetPlayerName(index, tmpName);
				format(string, sizeof(string), "%s has changed their name to %s.", name, tmpName);
				Log("logs/undercover.log", string);
				DeletePVar(index, "OnSetMyName");

				format(string, sizeof(string), "You have temporarily set your name to %s.", tmpName);
				SendClientMessageEx(index, COLOR_YELLOW, string);
				SendClientMessageEx(index, COLOR_GRAD2, "NOTE: None of your stats will save until you type this command again.");
				SetPVarInt(index, "TempName", 1);
			}
		}
		else
		{
			SendClientMessageEx(index, COLOR_WHITE, "This name is already registered.");
		}
	}
	else
	{
		DeletePVar(index, "OnSetMyName");
	}
	return 1;
}

forward OnSetName(index, extraid);
public OnSetName(index, extraid)
{
	if(IsPlayerConnected(index))
	{
		if(IsPlayerConnected(extraid))
		{
		    new rows;
			cache_get_row_count(rows);
			if(rows < 1)
			{
				new string[128], tmpName[24], playername[24];
				GetPVarString(index, "OnSetName", tmpName, 24);

				GetPlayerName(extraid, playername, sizeof(playername));

				UpdateCitizenApp(extraid, PlayerInfo[extraid][pNation]);

				if(PlayerInfo[extraid][pMarriedID] != -1)
				{
					foreach(new i: Player)
					{
						if(PlayerInfo[extraid][pMarriedID] == GetPlayerSQLId(i)) format(PlayerInfo[i][pMarriedName], MAX_PLAYER_NAME, "%s", tmpName);
					}
				}

				for(new i; i < MAX_DDOORS; i++)
				{
					if(DDoorsInfo[i][ddType] == 1 && DDoorsInfo[i][ddOwner] == GetPlayerSQLId(extraid))
					{
						strcat((DDoorsInfo[i][ddOwnerName][0] = 0, DDoorsInfo[i][ddOwnerName]), tmpName, 42);
						DestroyDynamicPickup(DDoorsInfo[i][ddPickupID]);
						if(IsValidDynamic3DTextLabel(DDoorsInfo[i][ddTextID])) DestroyDynamic3DTextLabel(DDoorsInfo[i][ddTextID]);
						CreateDynamicDoor(i);
						SaveDynamicDoor(i);
					}
				}

				for(new i; i < MAX_GARAGES; i++)
				{
					if(GarageInfo[i][gar_Owner] == GetPlayerSQLId(extraid))
					{
						format(GarageInfo[i][gar_OwnerName], MAX_PLAYER_NAME, "%s", tmpName);
						CreateGarage(i);
						SaveGarage(i);
					}
				}

				if(Homes[extraid] > 0)
				{
					for(new i; i < MAX_HOUSES; i++)
					{
						if(GetPlayerSQLId(extraid) == HouseInfo[i][hOwnerID])
						{
							format(HouseInfo[i][hOwnerName], MAX_PLAYER_NAME, "%s", tmpName);
							SaveHouse(i);
							ReloadHouseText(i);
						}
					}
				}

				if(PlayerInfo[extraid][pDonateRank] >= 1)
				{
					new string2[128];
					format(string2, sizeof(string2), "[VIP NAMECHANGES] %s has changed their name to %s.", GetPlayerNameEx(extraid), tmpName);
					Log("logs/vipnamechanges.log", string2);
				}

				if(strlen(tmpName) > 0)
				{
					format(string, sizeof(string), " Your name has been changed from %s to %s.", GetPlayerNameEx(extraid), tmpName);
					SendClientMessageEx(extraid,COLOR_YELLOW,string);
					format(string, sizeof(string), " You have changed %s's name to %s.", GetPlayerNameEx(extraid), tmpName);
					SendClientMessageEx(index,COLOR_YELLOW,string);
					format(string, sizeof(string), "%s changed %s's name to %s",GetPlayerNameEx(index),GetPlayerNameExt(extraid),tmpName);
					Log("logs/stats.log", string);
					if(SetPlayerName(extraid, tmpName) == 1)
					{
    					mysql_format(MainPipeline, string, sizeof(string), "UPDATE `accounts` SET `Username`='%s' WHERE `Username`='%s'", tmpName, playername);
						mysql_tquery(MainPipeline, string, "OnSetNameTwo", "ii", index, extraid);
					}
					else
					{
					    SendClientMessage(extraid, COLOR_REALRED, "There was an issue with your name change.");
					    format(string, sizeof(string), "%s's name change has failed due to incorrect size or characters.", GetPlayerNameExt(extraid));
					    SendClientMessage(extraid, COLOR_REALRED, string);
					    format(string, sizeof(string), "Error changing %s's name to %s", GetPlayerNameExt(extraid), tmpName);
					    Log("logs/stats.log", string);
					    return 1;
					}
					OnPlayerStatsUpdate(extraid);
				}
			}
		}
	}
	DeletePVar(index, "OnSetName");
	return 1;
}

forward OnSetNameTwo(index, extraid);
public OnSetNameTwo(index, extraid)
{
	return 1;
}

forward OnApproveName(index, extraid);
public OnApproveName(index, extraid)
{
	if(IsPlayerConnected(extraid))
	{
		new string[128];
		new rows;
		cache_get_row_count(rows);
		if(rows < 1)
		{
			new newname[24], oldname[24];
			GetPVarString(extraid, "NewNameRequest", newname, 24);
			GetPlayerName(extraid, oldname, sizeof(oldname));

			UpdateCitizenApp(extraid, PlayerInfo[extraid][pNation]);

			if(PlayerInfo[extraid][pMarriedID] != -1)
			{
				foreach(new i: Player)
				{
					if(PlayerInfo[extraid][pMarriedID] == GetPlayerSQLId(i)) format(PlayerInfo[i][pMarriedName], MAX_PLAYER_NAME, "%s", newname);
				}
			}

			for(new i; i < MAX_DDOORS; i++)
			{
				if(DDoorsInfo[i][ddType] == 1 && DDoorsInfo[i][ddOwner] == GetPlayerSQLId(extraid))
				{
					strcat((DDoorsInfo[i][ddOwnerName][0] = 0, DDoorsInfo[i][ddOwnerName]), newname, 42);
					DestroyDynamicPickup(DDoorsInfo[i][ddPickupID]);
					if(IsValidDynamic3DTextLabel(DDoorsInfo[i][ddTextID])) DestroyDynamic3DTextLabel(DDoorsInfo[i][ddTextID]);
					CreateDynamicDoor(i);
					SaveDynamicDoor(i);
				}
			}

			for(new i; i < MAX_GARAGES; i++)
			{
				if(GarageInfo[i][gar_Owner] == GetPlayerSQLId(extraid))
				{
					format(GarageInfo[i][gar_OwnerName], MAX_PLAYER_NAME, "%s", newname);
					CreateGarage(i);
					SaveGarage(i);
				}
			}

			if(Homes[extraid] > 0)
			{
				for(new i; i < MAX_HOUSES; i++)
				{
					if(GetPlayerSQLId(extraid) == HouseInfo[i][hOwnerID])
					{
						format(HouseInfo[i][hOwnerName], MAX_PLAYER_NAME, "%s", newname);
						SaveHouse(i);
						ReloadHouseText(i);
					}
				}
			}

			if(PlayerInfo[extraid][pBusiness] != INVALID_BUSINESS_ID && Businesses[PlayerInfo[extraid][pBusiness]][bOwner] == GetPlayerSQLId(extraid))
			{
			    strcpy(Businesses[PlayerInfo[extraid][pBusiness]][bOwnerName], newname, MAX_PLAYER_NAME);
			    SaveBusiness(PlayerInfo[extraid][pBusiness]);
				RefreshBusinessPickup(PlayerInfo[extraid][pBusiness]);
			}

			if(PlayerInfo[extraid][pDonateRank] >= 1)
			{
				format(string, sizeof(string), "[VIP NAMECHANGES] %s(%d) has changed their name to %s.", GetPlayerNameEx(extraid), GetPlayerSQLId(extraid), newname);
				Log("logs/vipnamechanges.log", string);
			}

			if(GetPVarType(extraid, "marriagelastname"))
			{
				if(strlen(newname) > 0)
				{
					if(SetPlayerName(extraid, newname) == 1)
					{
						mysql_format(MainPipeline, string, sizeof(string), "UPDATE `accounts` SET `Username`='%s' WHERE `Username`='%s'", newname, oldname);
						mysql_tquery(MainPipeline, string, "OnApproveSetName", "ii", index, extraid);
						format(string, sizeof(string), "%s last name has been changed upon marriage. New Name: \"%s\" (id: %i).", oldname, newname, GetPlayerSQLId(extraid));
						Log("logs/stats.log", string);
						SendClientMessageEx(extraid, -1, "Upon a successful marriage your last name has been changed to match your spouse's at your own request.");
					}
					else
					{
						SendClientMessage(extraid, COLOR_REALRED, "There was an issue with your name change.");
						format(string, sizeof(string), "Error changing %s's(%d) name to %s", GetPlayerNameExt(extraid), GetPlayerSQLId(extraid), newname);
						Log("logs/stats.log", string);
						return 1;
					}
					DeletePVar(extraid, "marriagelastname");
				}
			}
			else if((0 <= PlayerInfo[extraid][pMember] < MAX_GROUPS) && PlayerInfo[extraid][pRank] >= arrGroupData[PlayerInfo[extraid][pMember]][g_iFreeNameChange])
			{
				if(strlen(newname) > 0)
				{
					format(string, sizeof(string), " Your name has been changed from %s to %s for free.", GetPlayerNameEx(extraid), newname);
					SendClientMessageEx(extraid,COLOR_YELLOW,string);
					format(string, sizeof(string), " You have changed %s's name to %s at no cost.", GetPlayerNameEx(extraid), newname);
					SendClientMessageEx(index,COLOR_YELLOW,string);
					format(string, sizeof(string), "%s changed \"%s\"s name to \"%s\" (id: %i)  for free.",GetPlayerNameEx(index),GetPlayerNameEx(extraid),newname, GetPlayerSQLId(extraid));
					Log("logs/stats.log", string);
					format(string, sizeof(string), "%s has approved %s's name change to %s at no cost.",GetPlayerNameEx(index),GetPlayerNameEx(extraid), newname);
					ABroadCast(COLOR_YELLOW, string, 3);


					if(SetPlayerName(extraid, newname) == 1)
					{
    					mysql_format(MainPipeline, string, sizeof(string), "UPDATE `accounts` SET `Username`='%s' WHERE `Username`='%s'", newname, oldname);
						mysql_tquery(MainPipeline, string, "OnApproveSetName", "ii", index, extraid);
					}
					else
					{
					    SendClientMessage(extraid, COLOR_REALRED, "There was an issue with your name change.");
					    format(string, sizeof(string), "%s's name change has failed due to incorrect size or characters.", GetPlayerNameExt(extraid));
					    SendClientMessage(index, COLOR_REALRED, string);
					    format(string, sizeof(string), "Error changing %s's(%d) name to %s", GetPlayerNameExt(extraid), GetPlayerSQLId(extraid), newname);
					    Log("logs/stats.log", string);
					    return 1;
					}
					DeletePVar(extraid, "RequestingNameChange");
				}
			}

			else if(PlayerInfo[extraid][pAdmin] == 1 && PlayerInfo[extraid][pSMod] > 0)
			{
				if(strlen(newname) > 0)
				{
					format(string, sizeof(string), " Your name has been changed from %s to %s for free (Senior Mod).", GetPlayerNameEx(extraid), newname);
					SendClientMessageEx(extraid,COLOR_YELLOW,string);
					format(string, sizeof(string), " You have changed %s's name to %s at no cost.", GetPlayerNameEx(extraid), newname);
					SendClientMessageEx(index,COLOR_YELLOW,string);
					format(string, sizeof(string), "%s changed \"%s\"s name to \"%s\" (id: %i) for free (Senior Mod).",GetPlayerNameEx(index),GetPlayerNameEx(extraid),newname, GetPlayerSQLId(extraid));
					Log("logs/stats.log", string);
					format(string, sizeof(string), "%s has approved %s's name change to %s at no cost (Senior Mod).",GetPlayerNameEx(index),GetPlayerNameEx(extraid), newname);
					ABroadCast(COLOR_YELLOW, string, 3);

					if(SetPlayerName(extraid, newname) == 1)
					{
    					mysql_format(MainPipeline, string, sizeof(string), "UPDATE `accounts` SET `Username`='%s' WHERE `Username`='%s'", newname, oldname);
						mysql_tquery(MainPipeline, string, "OnApproveSetName", "ii", index, extraid);
					}
					else
					{
					    SendClientMessage(extraid, COLOR_REALRED, "There was an issue with your name change.");
					    format(string, sizeof(string), "%s's name change has failed due to incorrect size or characters.", GetPlayerNameExt(extraid));
					    SendClientMessage(index, COLOR_REALRED, string);
					    format(string, sizeof(string), "Error changing %s's(%d) name to %s", GetPlayerNameExt(extraid), GetPlayerSQLId(extraid), newname);
					    Log("logs/stats.log", string);
					    return 1;
					}
					DeletePVar(extraid, "RequestingNameChange");
				}
			}

			else
			{
				if(GetPVarInt(extraid, "NameChangeCost") == 0)
				{
					if(strlen(newname) > 0)
					{
						format(string, sizeof(string), " Your name has been changed from %s to %s for free (non-RP name).", GetPlayerNameEx(extraid), newname);
						SendClientMessageEx(extraid,COLOR_YELLOW,string);
						format(string, sizeof(string), " You have changed %s's name to %s for free (non-RP name).", GetPlayerNameEx(extraid), newname);
						SendClientMessageEx(index,COLOR_YELLOW,string);
						format(string, sizeof(string), "%s changed \"%s\"s name to \"%s\" (id: %i) for free (non-RP name).",GetPlayerNameEx(index),GetPlayerNameEx(extraid),newname, GetPlayerSQLId(extraid));
						Log("logs/stats.log", string);
						format(string, sizeof(string), "%s has approved %s's name change to %s for free (non-RP name).",GetPlayerNameEx(index),GetPlayerNameEx(extraid), newname);
						ABroadCast(COLOR_YELLOW, string, 3);

						if(SetPlayerName(extraid, newname) == 1)
						{
	    					mysql_format(MainPipeline, string, sizeof(string), "UPDATE `accounts` SET `Username`='%s' WHERE `Username`='%s'", newname, oldname);
							mysql_tquery(MainPipeline, string, "OnApproveSetName", "ii", index, extraid);
						}
						else
						{
						    SendClientMessage(extraid, COLOR_REALRED, "There was an issue with your name change.");
						    format(string, sizeof(string), "%s's name change has failed due to incorrect size or characters.", GetPlayerNameExt(extraid));
						    SendClientMessage(index, COLOR_REALRED, string);
						    format(string, sizeof(string), "Error changing %s's(%d) name to %s", GetPlayerNameExt(extraid), GetPlayerSQLId(extraid), newname);
						    Log("logs/stats.log", string);
						    return 1;
						}
						DeletePVar(extraid, "RequestingNameChange");
					}
				}
				else if(gettime() >= PlayerInfo[extraid][pNextNameChange])
				{
					if(strlen(newname) > 0)
					{
						if(SetPlayerName(extraid, newname) == 1)
						{
							mysql_format(MainPipeline, string, sizeof(string), "UPDATE `accounts` SET `Username`='%s' WHERE `Username`='%s'", newname, oldname);
							mysql_tquery(MainPipeline, string, "OnApproveSetName", "ii", index, extraid);
							PlayerInfo[extraid][pNextNameChange] = gettime()+10368000;
							format(string, sizeof(string), " Your name has been changed from %s to %s for free.", oldname, newname);
							SendClientMessageEx(extraid, COLOR_YELLOW, string);
							format(string, sizeof(string), " Your next free name change will be on %s", date(PlayerInfo[extraid][pNextNameChange], 4));
							SendClientMessageEx(extraid, COLOR_CYAN, string);
							format(string, sizeof(string), " You have changed %s's name to %s for %s for free.", oldname, newname);
							SendClientMessageEx(index,COLOR_YELLOW,string);
							format(string, sizeof(string), "%s changed \"%s\"s name to \"%s\" (id: %i) for free. (Next Free N/C: %s)", GetPlayerNameEx(index), oldname, newname, GetPlayerSQLId(extraid), date(PlayerInfo[extraid][pNextNameChange], 4));
							Log("logs/stats.log", string);
							format(string, sizeof(string), "%s has approved %s's name change to %s for free.", GetPlayerNameEx(index), oldname, newname);
							ABroadCast(COLOR_YELLOW, string, 3);
						}
						else
						{
							SendClientMessage(extraid, COLOR_REALRED, "There was an issue with your name change.");
							format(string, sizeof(string), "%s's name change has failed due to incorrect size or characters.", GetPlayerNameExt(extraid));
							SendClientMessage(index, COLOR_REALRED, string);
							format(string, sizeof(string), "Error changing %s's(%d) name to %s", GetPlayerNameExt(extraid), GetPlayerSQLId(extraid), newname);
							Log("logs/stats.log", string);
							return 1;
						}
						DeletePVar(extraid, "RequestingNameChange");
					}
				}
				else
				{
					if(strlen(newname) > 0)
					{
						if(SetPlayerName(extraid, newname) == 1)
						{
							/*
							GivePlayerCredits(extraid, -ShopItems[40][sItemPrice], 1);
							printf("Price40: %d", ShopItems[40][sItemPrice]);
							AmountSold[40]++;
							AmountMade[40] += ShopItems[40][sItemPrice];
							mysql_format(MainPipeline, string, sizeof(string), "UPDATE `sales` SET `TotalSold40` = '%d', `AmountMade40` = '%d' WHERE `Month` > NOW() - INTERVAL 1 MONTH", AmountSold[40], AmountMade[40]);
							mysql_tquery(MainPipeline, string, "OnQueryFinish", "i", SENDDATA_THREAD);
							format(string, sizeof(string), "[Name Change] [User: %s(%i)] [IP: %s] [Credits: %s] [Price: %s]", GetPlayerNameEx(extraid), GetPlayerSQLId(extraid), GetPlayerIpEx(extraid), number_format(PlayerInfo[extraid][pCredits]), number_format(ShopItems[40][sItemPrice]));
							Log("logs/credits.log", string), print(string);
							mysql_format(MainPipeline, string, sizeof(string), "UPDATE `accounts` SET `Username`='%s' WHERE `Username`='%s'", newname, oldname);
							mysql_tquery(MainPipeline, string, "OnApproveSetName", "ii", index, extraid);

							format(string, sizeof(string), " Your name has been changed from %s to %s for %s credits.", oldname, newname, number_format(ShopItems[40][sItemPrice]));
							SendClientMessageEx(extraid, COLOR_CYAN, string);
							format(string, sizeof(string), " You have changed %s's name to %s for %s credits.", oldname, newname, number_format(ShopItems[40][sItemPrice]));
							SendClientMessageEx(index,COLOR_YELLOW,string);
							format(string, sizeof(string), "%s changed \"%s\"s name to \"%s\" (id: %i) for %s credits.", GetPlayerNameEx(index), oldname, newname, GetPlayerSQLId(extraid), number_format(ShopItems[40][sItemPrice]));
							Log("logs/stats.log", string);
							format(string, sizeof(string), "%s has approved %s's name change to %s for %s credits.", GetPlayerNameEx(index), oldname, newname, number_format(ShopItems[40][sItemPrice]));
							ABroadCast(COLOR_YELLOW, string, 3);
						*/
							GivePlayerCash(extraid, -GetPVarInt(extraid, "NameChangeCost"));

							mysql_format(MainPipeline, string, sizeof(string), "UPDATE `accounts` SET `Username`='%s' WHERE `Username`='%s'", newname, oldname);
							mysql_tquery(MainPipeline, string, "OnApproveSetName", "ii", index, extraid);

							format(string, sizeof(string), " Your name has been changed from %s to %s for $%s.", oldname, newname, number_format(GetPVarInt(extraid, "NameChangeCost")));
							SendClientMessageEx(extraid, COLOR_CYAN, string);
							format(string, sizeof(string), " You have changed %s's name to %s for $%s.", oldname, newname, number_format(GetPVarInt(extraid, "NameChangeCost")));
							SendClientMessageEx(index,COLOR_YELLOW,string);
							format(string, sizeof(string), "%s changed \"%s\"s name to \"%s\" (id: %i) for $%s.", GetPlayerNameEx(index), oldname, newname, GetPlayerSQLId(extraid), number_format(GetPVarInt(extraid, "NameChangeCost")));
							Log("logs/stats.log", string);
							format(string, sizeof(string), "%s has approved %s's name change to %s for $%s.", GetPlayerNameEx(index), oldname, newname, number_format(GetPVarInt(extraid, "NameChangeCost")));
							ABroadCast(COLOR_YELLOW, string, 3);
						}
						else
						{
							SendClientMessage(extraid, COLOR_REALRED, "There was an issue with your name change.");
							format(string, sizeof(string), "%s's name change has failed due to incorrect size or characters.", GetPlayerNameExt(extraid));
							SendClientMessage(index, COLOR_REALRED, string);
							format(string, sizeof(string), "Error changing %s's(%d) name to %s", GetPlayerNameExt(extraid), GetPlayerSQLId(extraid), newname);
							Log("logs/stats.log", string);
							return 1;
						}
						DeletePVar(extraid, "RequestingNameChange");
					}
				}
			}
		}
		else
		{
			if(GetPVarType(extraid, "marriagelastname"))
			{
				SendClientMessageEx(extraid, COLOR_GRAD2, "There was a error changing your name after marriage, the name already exists.");
			}
			else
			{
				SendClientMessageEx(extraid, COLOR_GRAD2, "That name already exists, please choose a different one.");
				SendClientMessageEx(index, COLOR_GRAD2, "That name already exists.");
			}
			DeletePVar(extraid, "RequestingNameChange");
			DeletePVar(extraid, "marriagelastname");
			return 1;
		}
	}
	return 1;
}

forward OnIPWhitelist(index);
public OnIPWhitelist(index)
{
	new string[128], name[24];
	GetPVarString(index, "OnIPWhitelist", name, 24);

	if(cache_affected_rows()) {
		format(string, sizeof(string), "You have successfully whitelisted %s's account.", name);
		SendClientMessageEx(index, COLOR_WHITE, string);
		format(string, sizeof(string), "%s has IP Whitelisted %s", GetPlayerNameEx(index), name);
		Log("logs/whitelist.log", string);
	}
	else {
		format(string, sizeof(string), "There was a issue with whitelisting %s's account.", name);
		SendClientMessageEx(index, COLOR_WHITE, string);
	}
	DeletePVar(index, "OnIPWhitelist");

	return 1;
}

forward OnIPCheck(index);
public OnIPCheck(index)
{
	if(IsPlayerConnected(index))
	{
		new string[128], ip[16], name[24], AdminLvL;
		new rows;
		cache_get_row_count(rows);
		if(rows)
		{
			cache_get_value_name(0, "AdminLevel", ip, 16); AdminLvL = strval(ip);
			cache_get_value_name(0, "Username", name, MAX_PLAYER_NAME);
			if(AdminLvL <= 1 || (AdminLvL <= PlayerInfo[index][pAdmin] && PlayerInfo[index][pAdmin] >= 1338))
			{
				cache_get_value_name(0, "IP", ip, 16);
				format(string, sizeof(string), "%s's IP: %s", name, ip);
				SendClientMessageEx(index, COLOR_WHITE, string);
				format(string, sizeof(string), "%s has offline IP Checked %s", GetPlayerNameEx(index), name);
				if(AdminLvL >= 2) Log("logs/adminipcheck.log", string); else Log("logs/ipcheck.log", string);
				return 1;
			}
			if(AdminLvL >= 2)
			{
				if(AdminLvL > PlayerInfo[index][pAdmin])
				{
					format(string, sizeof(string), "%s has tried to offline check the IP address of a higher admin\nPlease report this to SIU/OED or an EA", GetPlayerNameEx(index));
					foreach(new i: Player)
					{
						if(PlayerInfo[i][pAdmin] >= 4) ShowPlayerDialogEx(i, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "{FFFF00}AdminWarning - {FF0000}Report ASAP", string, "Close", "");
					}
				}
				format(string, sizeof(string), "%s tried to offline IP check %s", GetPlayerNameEx(index), name);
				Log("logs/adminipcheck.log", string);
			}
			SendClientMessageEx(index, COLOR_WHITE, "There was an issue with checking the account's IP.");
		}
		else
		{
			SendClientMessageEx(index, COLOR_WHITE, "There was an issue with checking the account's IP.");
		}
	}
	return 1;
}

forward OnFine(index);
public OnFine(index)
{
	new string[128], name[24], amount, reason[64];
	GetPVarString(index, "OnFine", name, 24);
	amount = GetPVarInt(index, "OnFineAmount");
	GetPVarString(index, "OnFineReason", reason, 64);

	if(cache_affected_rows()) {
		format(string, sizeof(string), "You have successfully fined %s's account.", name);
		SendClientMessageEx(index, COLOR_WHITE, string);

		format(string, sizeof(string), "AdmCmd: %s was offline fined $%d by %s, reason: %s", name, amount, GetPlayerNameEx(index), reason);
		Log("logs/admin.log", string);
	}
	else {
		format(string, sizeof(string), "There was an issue with fining %s's account.", name);
		SendClientMessageEx(index, COLOR_WHITE, string);
	}
	DeletePVar(index, "OnFine");
	DeletePVar(index, "OnFineAmount");
	DeletePVar(index, "OnFineReason");

	return 1;
}

forward OnPrisonAccount(index);
public OnPrisonAccount(index)
{
	new string[128], name[24], reason[64];
	GetPVarString(index, "OnPrisonAccount", name, 24);
	GetPVarString(index, "OnPrisonAccountReason", reason, 64);

	if(cache_affected_rows()) {
		format(string, sizeof(string), "You have successfully prisoned %s's account.", name);
		SendClientMessageEx(index, COLOR_WHITE, string);

		format(string, sizeof(string), "AdmCmd: %s was offline prisoned by %s, reason: %s ", name, GetPlayerNameEx(index), reason);
		Log("logs/admin.log", string);
	}
	else {
		format(string, sizeof(string), "There was an issue with prisoning %s's account.");
		SendClientMessageEx(index, COLOR_WHITE, string);
	}
	DeletePVar(index, "OnPrisonAccount");
	DeletePVar(index, "OnPrisonAccountReason");

	return 1;
}

forward OnJailAccount(index);
public OnJailAccount(index)
{
	new string[128], name[24], reason[64];
	GetPVarString(index, "OnJailAccount", name, 24);
	GetPVarString(index, "OnJailAccountReason", reason, 64);

	if(cache_affected_rows()) {
		format(string, sizeof(string), "You have successfully jailed %s's account.", name);
		SendClientMessageEx(index, COLOR_WHITE, string);

		format(string, sizeof(string), "AdmCmd: %s was offline jailed by %s, reason: %s", name, GetPlayerNameEx(index), reason);
		Log("logs/admin.log", string);
	}
	else {
		format(string, sizeof(string), "There was an issue with jailing %s's account.", name);
		SendClientMessageEx(index, COLOR_WHITE, string);
	}

	DeletePVar(index, "OnJailAccount");
	DeletePVar(index, "OnJailAccountReason");

	return 1;
}

forward OnGetLatestKills(playerid, giveplayerid);
public OnGetLatestKills(playerid, giveplayerid)
{
    new string[128], killername[MAX_PLAYER_NAME], killedname[MAX_PLAYER_NAME], kDate[20], weapon[56], rows;
	cache_get_row_count(rows);
	if(rows)
	{
		for(new i; i < rows; i++)
		{
			cache_get_value_index(i, 0, killername, MAX_PLAYER_NAME);
			cache_get_value_index(i, 1, killedname, MAX_PLAYER_NAME);
			cache_get_value_name(i, "killerid", string); new killer = strval(string);
			cache_get_value_name(i, "killedid", string); new killed = strval(string);
			cache_get_value_name(i, "date", kDate, sizeof(kDate));
			cache_get_value_name(i, "weapon", weapon, sizeof(weapon));
			if(GetPlayerSQLId(giveplayerid) == killer && GetPlayerSQLId(giveplayerid) == killed) format(string, sizeof(string), "[%s] %s killed themselves (%s)", kDate, StripUnderscore(killedname), weapon);
			else if(GetPlayerSQLId(giveplayerid) == killer && GetPlayerSQLId(giveplayerid) != killed) format(string, sizeof(string), "[%s] %s killed %s with %s", kDate, StripUnderscore(killername), StripUnderscore(killedname), weapon);
			else if(GetPlayerSQLId(giveplayerid) != killer && GetPlayerSQLId(giveplayerid) == killed) format(string, sizeof(string), "[%s] %s was killed by %s with %s", kDate, StripUnderscore(killedname), StripUnderscore(killername), weapon);
			SendClientMessageEx(playerid, COLOR_YELLOW, string);
		}
	}
	else SendClientMessageEx(playerid, COLOR_YELLOW, "No kills recorded on this player.");
	return 1;
}

forward OnGetOKills(playerid, giveplayername[]);
public OnGetOKills(playerid, giveplayername[])
{
	if(IsPlayerConnected(playerid))
	{
		new string[256], giveplayerid, rows;
		cache_get_row_count(rows);

		if(rows)
		{
			cache_get_value_name(0, "id", string); giveplayerid = strval(string);
			mysql_format(MainPipeline, string, sizeof(string), "SELECT Killer.Username, Killed.Username, k.* FROM kills k LEFT JOIN accounts Killed ON k.killedid = Killed.id LEFT JOIN accounts Killer ON Killer.id = k.killerid WHERE k.killerid = %d OR k.killedid = %d ORDER BY `date` DESC LIMIT 10", giveplayerid, giveplayerid);
			mysql_tquery(MainPipeline, string, "OnGetLatestOKills", "iis", playerid, giveplayerid, giveplayername);
		}
		else return SendClientMessageEx(playerid, COLOR_GREY, "This account does not exist.");
	}
	return 1;
}

forward OnGetLatestOKills(playerid, giveplayerid, giveplayername[]);
public OnGetLatestOKills(playerid, giveplayerid, giveplayername[])
{
    new string[128], killername[MAX_PLAYER_NAME], killedname[MAX_PLAYER_NAME], kDate[20], weapon[56], rows;
	cache_get_row_count(rows);
	if(rows)
	{
		SendClientMessageEx(playerid, COLOR_GREEN, "________________________________________________");
		format(string, sizeof(string), "<< Last 10 Kills/Deaths of %s >>", StripUnderscore(giveplayername));
		SendClientMessageEx(playerid, COLOR_YELLOW, string);
		for(new i; i < rows; i++)
		{
			cache_get_value_index(i, 0, killername, MAX_PLAYER_NAME);
			cache_get_value_index(i, 1, killedname, MAX_PLAYER_NAME);
			cache_get_value_name(i, "killerid", string); new killer = strval(string);
			cache_get_value_name(i, "killedid", string); new killed = strval(string);
			cache_get_value_name(i, "date", kDate, sizeof(kDate));
			cache_get_value_name(i, "weapon", weapon, sizeof(weapon));
			if(giveplayerid == killer && giveplayerid == killed) format(string, sizeof(string), "[%s] %s killed themselves (%s)", kDate, StripUnderscore(killedname), weapon);
			else if(giveplayerid == killer && giveplayerid != killed) format(string, sizeof(string), "[%s] %s killed %s with %s", kDate, StripUnderscore(killername), StripUnderscore(killedname), weapon);
			else if(giveplayerid != killer && giveplayerid == killed) format(string, sizeof(string), "[%s] %s was killed by %s with %s", kDate, StripUnderscore(killedname), StripUnderscore(killername), weapon);
			SendClientMessageEx(playerid, COLOR_YELLOW, string);
		}
	}
	else return SendClientMessageEx(playerid, COLOR_YELLOW, "No kills recorded on this player.");
	return 1;
}

forward OnDMStrikeReset(playerid, giveplayerid);
public OnDMStrikeReset(playerid, giveplayerid)
{
	new string[128];
	format(string, sizeof(string), "Deleted %d strikes against %s", cache_affected_rows(), GetPlayerNameEx(giveplayerid));
	SendClientMessage(playerid, COLOR_WHITE, string);
	return 1;
}

forward OnDMRLookup(playerid, giveplayerid);
public OnDMRLookup(playerid, giveplayerid)
{
	new string[128], rows;
	cache_get_row_count(rows);
	format(string, sizeof(string), "Showing the last %d /dmreports by %s", rows, GetPlayerNameEx(giveplayerid));
	SendClientMessage(playerid, COLOR_WHITE, string);
	SendClientMessage(playerid, COLOR_WHITE, "| Reported | Time |");
	for(new i;i < rows;i++)
	{
 		new szResult[32], name[MAX_PLAYER_NAME], timestamp;
		cache_get_value_index(i, 0, szResult); timestamp = strval(szResult);
		cache_get_value_index(i, 1, name, MAX_PLAYER_NAME);
		format(string, sizeof(string), "%s - %s", name, date(timestamp, 1));
		SendClientMessage(playerid, COLOR_WHITE, string);
	}
	return 1;
}

forward OnDMTokenLookup(playerid, giveplayerid);
public OnDMTokenLookup(playerid, giveplayerid)
{
	new string[128], rows;
	cache_get_row_count(rows);
	format(string, sizeof(string), "Showing the %d active /dmreports on %s", rows, GetPlayerNameEx(giveplayerid));
	SendClientMessage(playerid, COLOR_WHITE, string);
	SendClientMessage(playerid, COLOR_WHITE, "| Reporter | Time |");
	for(new i;i < rows;i++)
	{
 		new szResult[32], name[MAX_PLAYER_NAME], timestamp;
		cache_get_value_index(i, 0, szResult); timestamp = strval(szResult);
		cache_get_value_index(i, 1, name);
		format(string, sizeof(string), "%s - %s", name, date(timestamp, 1));
		SendClientMessage(playerid, COLOR_WHITE, string);
	}
	return 1;
}

forward OnDMWatchListLookup(playerid);
public OnDMWatchListLookup(playerid)
{
	new string[128], rows;
	cache_get_row_count(rows);
	format(string, sizeof(string), "Showing %d active people to watch", rows);
	SendClientMessage(playerid, COLOR_WHITE, string);
	for(new i;i < rows;i++)
	{
 		new name[MAX_PLAYER_NAME], watchid;
		cache_get_value_index(i, 0, name);
		sscanf(name, "u", watchid);
		format(string, sizeof(string), "(ID: %d) %s", watchid, name);
		SendClientMessage(playerid, (PlayerInfo[watchid][pJailTime] > 0) ? TEAM_ORANGE_COLOR:COLOR_WHITE, string);
	}
	return 1;
}

forward OnDMWatch(playerid);
public OnDMWatch(playerid)
{
	new rows;
    cache_get_row_count(rows);
    if(rows)
    {
		new string[128], namesql[MAX_PLAYER_NAME], name[MAX_PLAYER_NAME];
		cache_get_value_index(0, 0, namesql);
		foreach(new i: Player)
		{
			if(!PlayerInfo[i][pJailTime])
			{
				GetPlayerName(i, name, sizeof(name));
				if(strcmp(name, namesql, true) == 0)
				{
					foreach(new x: Player)
					{
						if(GetPVarInt(x, "pWatchdogWatching") == i)
						{
							return SendClientMessage(playerid, COLOR_WHITE, "The random person selected for you is already being watched, please try again!");
						}
					}
					format(string, sizeof(string), "You now have access to /spec %s (ID: %i). Use /dmalert if this person deathmatches.", name, i);
					SendClientMessage(playerid, COLOR_WHITE, string);
					return SetPVarInt(playerid, "pWatchdogWatching", i);
				}
			}
		}
	}
	return SendClientMessageEx(playerid, COLOR_WHITE, "There is no one online to DM Watch!");
}

forward OnWarnPlayer(index);
public OnWarnPlayer(index)
{
	new string[128], name[24], reason[64];
	GetPVarString(index, "OnWarnPlayer", name, 24);
	GetPVarString(index, "OnWarnPlayerReason", reason, 64);

	if(cache_affected_rows()) {
		format(string, sizeof(string), "You have successfully warned %s's account.", name);
		SendClientMessageEx(index, COLOR_WHITE, string);

		format(string, sizeof(string), "AdmCmd: %s was offline warned by %s, reason: %s", name, GetPlayerNameEx(index), reason);
		Log("logs/admin.log", string);
	}
	else {
		format(string, sizeof(string), "There was an issue with warning %s's account.", name);
		SendClientMessageEx(index, COLOR_WHITE, string);
	}
	DeletePVar(index, "OnWarnPlayer");
	DeletePVar(index, "OnWarnPlayerReason");

	return 1;
}

forward OnPinCheck2(index);
public OnPinCheck2(index)
{
	if(IsPlayerConnected(index))
	{
		new rows;
		cache_get_row_count(rows);
		if(rows)
		{
		    new Pin[256];
   			cache_get_value_name(0, "Pin", Pin, 256);
   			if(isnull(Pin)) {
   			    ShowPlayerDialogEx(index, DIALOG_CREATEPIN, DIALOG_STYLE_INPUT, "Pin Number", "Create a pin number so you can secure your account credits.", "Create", "Exit");
   			}
   			else
   			{
   			    new passbuffer[256], passbuffer2[64];
            	GetPVarString(index, "PinNumber", passbuffer2, sizeof(passbuffer2));
				WP_Hash(passbuffer, sizeof(passbuffer), passbuffer2);
				if (strcmp(passbuffer, Pin) == 0)
				{
				    SetPVarInt(index, "PinConfirmed", 1);
					SendClientMessageEx(index, COLOR_CYAN, "Pin confirmed, you will now be able to spend credits.");
					switch(GetPVarInt(index, "OpenShop"))
					{
	    				case 1:
						{
							new szDialog[1024];
							format(szDialog, sizeof(szDialog), "Poker Table (Credits: {FFD700}%s{A9C4E4})\nBoombox (Credits: {FFD700}%s{A9C4E4})\n100 Paintball Tokens (Credits: {FFD700}%s{A9C4E4})\nEXP Token (Credits: {FFD700}%s{A9C4E4})\nFireworks x5 (Credits: {FFD700}%s{A9C4E4})\nCustom License Plate (Credits: {FFD700}%s{A9C4E4})",
							number_format(ShopItems[6][sItemPrice]), number_format(ShopItems[7][sItemPrice]), number_format(ShopItems[8][sItemPrice]), number_format(ShopItems[9][sItemPrice]),
							number_format(ShopItems[10][sItemPrice]), number_format(ShopItems[22][sItemPrice]));
							format(szDialog, sizeof(szDialog), "%s\nRestricted Last Name (NEW) (Credits: {FFD700}%s{A9C4E4})\nRestricted Last Name (CHANGE) (Credits: {FFD700}%s{A9C4E4})\nCustom User Title (NEW) (Credits: {FFD700}%s{A9C4E4})\nCustom User Title (CHANGE) (Credits: {FFD700}%s{A9C4E4})\nTeamspeak User Channel (Credits: {FFD700}%s{A9C4E4})\nBackpacks\nDeluxe Car Alarm (Credits: {FFD700}%s{A9C4E4})",
							szDialog, number_format(ShopItems[31][sItemPrice]), number_format(ShopItems[32][sItemPrice]), number_format(ShopItems[33][sItemPrice]), number_format(ShopItems[34][sItemPrice]), number_format(ShopItems[35][sItemPrice]), number_format(ShopItems[39][sItemPrice]));
							ShowPlayerDialogEx(index, DIALOG_MISCSHOP, DIALOG_STYLE_LIST, "Misc Shop", szDialog, "Select", "Cancel");
						}
						case 2: SetPVarInt(index, "RentaCar", 1), ShowModelSelectionMenu(index, CarList2, "Rent a Car!");
						case 3: ShowModelSelectionMenu(index, CarList2, "Car Shop");
						case 4: ShowPlayerDialogEx( index, DIALOG_HOUSESHOP, DIALOG_STYLE_LIST, "House Shop", "Purchase House\nHouse Interior Change\nHouse Move\nGarage - Small\nGarage - Medium\nGarage - Large\nGarage - Extra Large","Select", "Exit" );
						case 5: ShowPlayerDialogEx( index, DIALOG_VIPSHOP, DIALOG_STYLE_LIST, "VIP Shop", "Purchase VIP\nRenew Gold VIP","Continue", "Exit" );
						case 6: ShowPlayerDialogEx(index, DIALOG_SHOPBUSINESS, DIALOG_STYLE_LIST, "Businesses Shop", "Purchase Business\nRenew Business", "Select", "Exit");
						case 7: ShowModelSelectionMenu(index, PlaneList, "Plane Shop");
						case 8: ShowModelSelectionMenu(index, BoatList, "Boat Shop");
						case 9: ShowModelSelectionMenu(index, CarList3, "Restricted Car Shop");
						case 10: cmd_changename(index, "");
						case 11: cmd_microshop(index, "");
					}
					DeletePVar(index, "OpenShop");
				}
				else
				{
					ShowPlayerDialogEx(index, DIALOG_ENTERPIN, DIALOG_STYLE_INPUT, "Pin Number", "(INVALID PIN)\n\nEnter your pin number to access credit shops.", "Confirm", "Exit");
				}
				DeletePVar(index, "PinNumber");
  			}
		}
		else
		{
			SendClientMessageEx(index, COLOR_WHITE, "There was an issue, please try again.");
		}
	}
	return 1;
}

forward OnPinCheck(index);
public OnPinCheck(index)
{
	if(IsPlayerConnected(index))
	{
		new rows;
		cache_get_row_count(rows);
		if(rows)
		{
		    new Pin[128];
   			cache_get_value_name(0, "Pin", Pin);
   			if(isnull(Pin)) {
   			    ShowPlayerDialogEx(index, DIALOG_CREATEPIN, DIALOG_STYLE_INPUT, "Pin Number", "Create a pin number so you can secure your account credits.", "Create", "Exit");
   			}
   			else
   			{
   			    ShowPlayerDialogEx(index, DIALOG_ENTERPIN, DIALOG_STYLE_INPUT, "Pin Number", "Enter your pin number to access credit shops.", "Confirm", "Exit");
   			}
		}
		else
		{
			SendClientMessageEx(index, COLOR_WHITE, "There was an issue, please try again.");
		}
	}
	return 1;
}

forward OnGetSMSLog(playerid);
public OnGetSMSLog(playerid)
{
    new string[128], message[256], sender[MAX_PLAYER_NAME], sDate[20], rows;
	cache_get_row_count(rows);
	if(rows)
	{
		SendClientMessageEx(playerid, COLOR_GREEN, "________________________________________________");
		SendClientMessageEx(playerid, COLOR_YELLOW, "<< Last 10 SMS Received >>");
		for(new i; i < rows; i++)
		{
			cache_get_value_name(i, "sender", sender, MAX_PLAYER_NAME);
			cache_get_value_name(i, "sendernumber", string); new sendernumber = strval(string);
			cache_get_value_name(i, "message", message, sizeof(message));
			cache_get_value_name(i, "date", sDate, sizeof(sDate));
			if(sendernumber != 0) format(string, sizeof(string), "[%s] SMS: %s, Sender: %d (( %s ))", sDate, message, sendernumber, sender);
			else format(string, sizeof(string), "[%s] SMS: %s, Sender: Unknown", sDate, message);
			SendClientMessageEx(playerid, COLOR_YELLOW, string);
		}
	}
	else SendClientMessageEx(playerid, COLOR_GREY, "You have not received any SMS messages.");
	return 1;
}

forward Group_QueryFinish(iType, iExtraID);
public Group_QueryFinish(iType, iExtraID) {

	/*
		Internally, every group array/subarray starts from zero (divisions, group ids etc)
		When displaying to the clients or saving to the db, we add 1 to them!
		The only exception is ranks which already start from zero.
	*/

	new
		iRows,
		iIndex,
		i = 0,
		szResult[128],
		number[12],
		value;

	cache_get_row_count(iRows);

	switch(iType) {
		case GROUP_QUERY_JURISDICTIONS:
  		{
  		    for(new iG = 0; iG < MAX_GROUPS; iG++)
  		    {
  		        arrGroupData[iG][g_iJCount] = 0;
  		    }
			while(iIndex < iRows) {

				cache_get_value_name(iIndex, "GroupID", szResult, 24);
				new iGroup = strval(szResult);

				if(arrGroupData[iGroup][g_iJCount] > MAX_GROUP_JURISDICTIONS) arrGroupData[iGroup][g_iJCount] = MAX_GROUP_JURISDICTIONS;
				if (!(0 <= iGroup < MAX_GROUPS)) break;
				cache_get_value_name(iIndex, "id", szResult, 24);
				arrGroupJurisdictions[iGroup][arrGroupData[iGroup][g_iJCount]][g_iJurisdictionSQLId] = strval(szResult);
				cache_get_value_name(iIndex, "AreaName", arrGroupJurisdictions[iGroup][arrGroupData[iGroup][g_iJCount]][g_iAreaName], 64);
				arrGroupData[iGroup][g_iJCount]++;
				iIndex++;
			}
		}
		case GROUP_QUERY_GWEAPONS: while(iIndex < iRows) {

			if (!(0 <= iIndex < MAX_GROUPS)) break;
			cache_get_value_name_int(iIndex, "id", value);
			LockerWep[iIndex][lwGroup] = value;

			for(new w = 0; w < 46; w++) {
				format(number, sizeof(number), "%d", w+1);
				cache_get_value_name_int(iIndex, number, value);
				LockerWep[iIndex][lwWep][w] = value;
			}
			iIndex++;
		}
		case GROUP_QUERY_GWEAPONS_RANK: while(iIndex < iRows) {

			if (!(0 <= iIndex < MAX_GROUPS)) break;

			for(new w = 0; w < 16; w++) {
				format(number, sizeof(number), "%d", w+1);
				cache_get_value_name_int(iIndex, number, value);
				LockerWep[iIndex][lwRank][w] = value;
			}
			iIndex++;
		}
		case GROUP_QUERY_LOCKERS: while(iIndex < iRows) {

			cache_get_value_name(iIndex, "Group_ID", szResult);
			new iGroup = strval(szResult)-1;

			cache_get_value_name(iIndex, "Locker_ID", szResult);
			new iLocker = strval(szResult)-1;

			if (!(0 <= iGroup < MAX_GROUPS)) break;
			if (!(0 <= iLocker < MAX_GROUP_LOCKERS)) break;

			cache_get_value_name(iIndex, "Id", szResult);
			arrGroupLockers[iGroup][iLocker][g_iLockerSQLId] = strval(szResult);

			cache_get_value_name(iIndex, "LockerX", szResult);
			arrGroupLockers[iGroup][iLocker][g_fLockerPos][0] = floatstr(szResult);

			cache_get_value_name(iIndex, "LockerY", szResult);
			arrGroupLockers[iGroup][iLocker][g_fLockerPos][1] = floatstr(szResult);

			cache_get_value_name(iIndex, "LockerZ", szResult);
			arrGroupLockers[iGroup][iLocker][g_fLockerPos][2] = floatstr(szResult);

			cache_get_value_name(iIndex, "LockerVW", szResult);
			arrGroupLockers[iGroup][iLocker][g_iLockerVW] = strval(szResult);

			cache_get_value_name(iIndex, "LockerShare", szResult);
			arrGroupLockers[iGroup][iLocker][g_iLockerShare] = strval(szResult);

			if(arrGroupLockers[iGroup][iLocker][g_fLockerPos][0] != 0.0)
			{
				format(szResult, sizeof szResult, "%s Locker\n{1FBDFF}Press ~k~~CONVERSATION_YES~ {FFFF00} to use\n ID: %i", arrGroupData[iGroup][g_szGroupName], arrGroupLockers[iGroup][iLocker]);
				arrGroupLockers[iGroup][iLocker][g_tLocker3DLabel] = CreateDynamic3DTextLabel(szResult, arrGroupData[iGroup][g_hDutyColour] * 256 + 0xFF, arrGroupLockers[iGroup][iLocker][g_fLockerPos][0], arrGroupLockers[iGroup][iLocker][g_fLockerPos][1], arrGroupLockers[iGroup][iLocker][g_fLockerPos][2], 15.0, .testlos = 1, .worldid = arrGroupLockers[iGroup][iLocker][g_iLockerVW]);

				arrGroupLockers[iGroup][iLocker][g_iLockerAreaID] = CreateDynamicSphere(arrGroupLockers[iGroup][iLocker][g_fLockerPos][0], arrGroupLockers[iGroup][iLocker][g_fLockerPos][1], arrGroupLockers[iGroup][iLocker][g_fLockerPos][2], 3.0, .worldid = arrGroupLockers[iGroup][iLocker][g_iLockerVW]);
				printf("%d", arrGroupLockers[iGroup][iLocker][g_iLockerAreaID]);
				// Streamer_SetIntData(STREAMER_TYPE_AREA, arrGroupLockers[iGroup][iLocker][g_iLockerAreaID], E_STREAMER_EXTRA_ID, iLocker);
			}
			iIndex++;

		}
		case GROUP_QUERY_LOAD: while(iIndex < iRows) {
			MemberCount(iIndex);
			cache_get_value_name(iIndex, "Name", arrGroupData[iIndex][g_szGroupName], GROUP_MAX_NAME_LEN);
			cache_get_value_name(iIndex, "MOTD", gMOTD[iIndex][0], GROUP_MAX_MOTD_LEN);
			cache_get_value_name(iIndex, "MOTD2", gMOTD[iIndex][1], GROUP_MAX_MOTD_LEN);
			cache_get_value_name(iIndex, "MOTD3", gMOTD[iIndex][2], GROUP_MAX_MOTD_LEN);
			cache_get_value_name_int(iIndex, "Type", arrGroupData[iIndex][g_iGroupType]);
			cache_get_value_name_int(iIndex, "Allegiance", arrGroupData[iIndex][g_iAllegiance]);
			cache_get_value_name_int(iIndex, "Bug", arrGroupData[iIndex][g_iBugAccess]);
			cache_get_value_name_int(iIndex, "Find", arrGroupData[iIndex][g_iFindAccess]);
			cache_get_value_name_int(iIndex, "RadioColour", arrGroupData[iIndex][g_hRadioColour]);
			cache_get_value_name_int(iIndex, "Radio", arrGroupData[iIndex][g_iRadioAccess]);
			cache_get_value_name_int(iIndex, "DeptRadio", arrGroupData[iIndex][g_iDeptRadioAccess]);
			cache_get_value_name_int(iIndex, "IntRadio", arrGroupData[iIndex][g_iIntRadioAccess]);
			cache_get_value_name_int(iIndex, "GovAnnouncement", arrGroupData[iIndex][g_iGovAccess]);
			cache_get_value_name_int(iIndex, "TreasuryAccess", arrGroupData[iIndex][g_iTreasuryAccess]);
			cache_get_value_name_int(iIndex, "FreeNameChange", arrGroupData[iIndex][g_iFreeNameChange]);
			cache_get_value_name_int(iIndex, "FreeNameChangeDiv", arrGroupData[iIndex][g_iFreeNameChangeDiv]);
			cache_get_value_name_int(iIndex, "Budget", arrGroupData[iIndex][g_iBudget]);
			cache_get_value_name_int(iIndex, "BudgetPayment", arrGroupData[iIndex][g_iBudgetPayment]);
			cache_get_value_name_int(iIndex, "SpikeStrips", arrGroupData[iIndex][g_iSpikeStrips]);
			cache_get_value_name_int(iIndex, "Barricades", arrGroupData[iIndex][g_iBarricades]);
			cache_get_value_name_int(iIndex, "Cones", arrGroupData[iIndex][g_iCones]);
			cache_get_value_name_int(iIndex, "Flares", arrGroupData[iIndex][g_iFlares]);
			cache_get_value_name_int(iIndex, "Barrels", arrGroupData[iIndex][g_iBarrels]);
			cache_get_value_name_int(iIndex, "Ladders", arrGroupData[iIndex][g_iLadders]);
			cache_get_value_name_int(iIndex, "Tapes", arrGroupData[iIndex][g_iTapes]);
			cache_get_value_name_int(iIndex, "DutyColour", arrGroupData[iIndex][g_hDutyColour]);
			cache_get_value_name_int(iIndex, "Stock", arrGroupData[iIndex][g_iLockerStock]);
			cache_get_value_name_float(iIndex, "CrateX", arrGroupData[iIndex][g_fCratePos][0]);
			cache_get_value_name_float(iIndex, "CrateY", arrGroupData[iIndex][g_fCratePos][1]);
			cache_get_value_name_float(iIndex, "CrateZ", arrGroupData[iIndex][g_fCratePos][2]);
			cache_get_value_name_int(iIndex, "LockerCostType", arrGroupData[iIndex][g_iLockerCostType]);
			cache_get_value_name_int(iIndex, "CratesOrder", arrGroupData[iIndex][g_iCratesOrder]);
			cache_get_value_name_int(iIndex, "CrateIsland", arrGroupData[iIndex][g_iCrateIsland]);
			cache_get_value_name_float(iIndex, "GarageX", arrGroupData[iIndex][g_fGaragePos][0]);
			cache_get_value_name_float(iIndex, "GarageY", arrGroupData[iIndex][g_fGaragePos][1]);
			cache_get_value_name_float(iIndex, "GarageZ", arrGroupData[iIndex][g_fGaragePos][2]);
			cache_get_value_name_int(iIndex, "TackleAccess", arrGroupData[iIndex][g_iTackleAccess]);
			cache_get_value_name_int(iIndex, "WheelClamps", arrGroupData[iIndex][g_iWheelClamps]);
			cache_get_value_name_int(iIndex, "DoCAccess", arrGroupData[iIndex][g_iDoCAccess]);
			cache_get_value_name_int(iIndex, "MedicAccess", arrGroupData[iIndex][g_iMedicAccess]);
			cache_get_value_name_int(iIndex, "DMVAccess", arrGroupData[iIndex][g_iDMVAccess]);
			cache_get_value_name_int(iIndex, "TempNum", arrGroupData[iIndex][gTempNum]);
			cache_get_value_name_int(iIndex, "LEOArrest", arrGroupData[iIndex][gLEOArrest]);
			cache_get_value_name_int(iIndex, "OOCChat", arrGroupData[iIndex][g_iOOCChat]);
			cache_get_value_name_int(iIndex, "OOCColor", arrGroupData[iIndex][g_hOOCColor]);
			cache_get_value_name_int(iIndex, "Pot", arrGroupData[iIndex][g_iPot]);
			cache_get_value_name_int(iIndex, "Crack", arrGroupData[iIndex][g_iCrack]);
			cache_get_value_name_int(iIndex, "Meth", arrGroupData[iIndex][g_iMeth]);
			cache_get_value_name_int(iIndex, "Ecstasy", arrGroupData[iIndex][g_iEcstasy]);
			cache_get_value_name_int(iIndex, "Heroin", arrGroupData[iIndex][g_iHeroin]);
			cache_get_value_name_int(iIndex, "Syringes", arrGroupData[iIndex][g_iSyringes]);
			cache_get_value_name_int(iIndex, "Mats", arrGroupData[iIndex][g_iMaterials]);
			cache_get_value_name_int(iIndex, "TurfCapRank", arrGroupData[iIndex][g_iTurfCapRank]);
			cache_get_value_name_int(iIndex, "PointCapRank", arrGroupData[iIndex][g_iPointCapRank]);
			cache_get_value_name_int(iIndex, "WithdrawRank", arrGroupData[iIndex][g_iWithdrawRank][0]);
			cache_get_value_name_int(iIndex, "WithdrawRank2", arrGroupData[iIndex][g_iWithdrawRank][1]);
			cache_get_value_name_int(iIndex, "WithdrawRank3", arrGroupData[iIndex][g_iWithdrawRank][2]);
			cache_get_value_name_int(iIndex, "WithdrawRank4", arrGroupData[iIndex][g_iWithdrawRank][3]);
			cache_get_value_name_int(iIndex, "WithdrawRank5", arrGroupData[iIndex][g_iWithdrawRank][4]);
			cache_get_value_name_int(iIndex, "Tokens", arrGroupData[iIndex][g_iTurfTokens]);
			cache_get_value_name_int(iIndex, "CrimeType", arrGroupData[iIndex][g_iCrimeType]);
			cache_get_value_name_int(iIndex, "GroupToyID", arrGroupData[iIndex][g_iGroupToyID]);
			cache_get_value_name(iIndex, "TurfTax", arrGroupData[iIndex][g_iTurfTax]);

			for(i = 0; i < MAX_GROUP_RIVALS; ++i)
			{
				format(szResult, sizeof(szResult), "gRival%i", i);
				cache_get_value_name_int(iIndex, szResult, arrGroupData[iIndex][g_iRivals][i]);
			}

			for(i = 0; i < MAX_GROUP_RANKS; ++i)
			{
				format(szResult, sizeof(szResult), "GClothes%i", i);
				cache_get_value_name_int(iIndex, szResult, arrGroupData[iIndex][g_iClothes][i]);
			}

			i = 0;
			while(i < MAX_GROUP_RANKS) {
				format(szResult, sizeof szResult, "Rank%i", i);
				cache_get_value_name(iIndex, szResult, arrGroupRanks[iIndex][i], GROUP_MAX_RANK_LEN);
				format(szResult, sizeof szResult, "Rank%iPay", i);
				cache_get_value_name(iIndex, szResult, szResult);
				arrGroupData[iIndex][g_iPaycheck][i] = strval(szResult);
				i++;
			}
			i = 0;

			while(i < MAX_GROUP_DIVS) {
				format(szResult, sizeof szResult, "Div%i", i + 1);
				cache_get_value_name(iIndex, szResult, arrGroupDivisions[iIndex][i], GROUP_MAX_DIV_LEN);
				i++;
			}
			i = 0;

			while(i < MAX_GROUP_WEAPONS) {
				format(szResult, sizeof szResult, "Gun%i", i + 1);
				cache_get_value_name(iIndex, szResult, szResult);
				arrGroupData[iIndex][g_iLockerGuns][i] = strval(szResult);
				format(szResult, sizeof szResult, "Cost%i", i + 1);
				cache_get_value_name(iIndex, szResult, szResult);
				arrGroupData[iIndex][g_iLockerCost][i] = strval(szResult);
				i++;
			}
			i = 0;

			// Jingles' Drug System:
			for(i = 0; i < sizeof(Drugs); ++i) cache_get_value_name_int(iIndex, GetDrugName(i), arrGroupData[iIndex][g_iDrugs][i]);
			//for(i = 0; i < sizeof(szIngredients); ++i) arrGroupData[iIndex][g_iIngredients][i] = cache_get_value_name_int(iIndex, DS_Ingredients_GetSQLName(i));
			i = 0;

			if (arrGroupData[iIndex][g_szGroupName][0] && arrGroupData[iIndex][g_fCratePos][0] != 0.0)
			{
				/*
				if(arrGroupData[iIndex][g_iGroupType] == GROUP_TYPE_CRIMINAL)
				{
					format(szResult, sizeof szResult, "%s Shipment Delivery Point\n{1FBDFF}/gdelivercrate", arrGroupData[iIndex][g_szGroupName]);
				}
				else
				{
					format(szResult, sizeof szResult, "%s Crate Delivery Point\n{1FBDFF}/delivercrate", arrGroupData[iIndex][g_szGroupName]);
				}*/
				format(szResult, sizeof szResult, "%s Crate Delivery Point\n{1FBDFF}/delivercrate", arrGroupData[iIndex][g_szGroupName]);
				arrGroupData[iIndex][g_tCrate3DLabel] = CreateDynamic3DTextLabel(szResult, arrGroupData[iIndex][g_hDutyColour] * 256 + 0xFF, arrGroupData[iIndex][g_fCratePos][0], arrGroupData[iIndex][g_fCratePos][1], arrGroupData[iIndex][g_fCratePos][2], 10.0, .testlos = 1, .streamdistance = 20.0);
			}
			iIndex++;
		}

		case GROUP_QUERY_INVITE: if(GetPVarType(iExtraID, "Group_Invited")) {
			if(!iRows) {

				i = GetPVarInt(iExtraID, "Group_Invited");
				iIndex = PlayerInfo[iExtraID][pMember];

				format(szResult, sizeof szResult, "%s %s has offered you an invite to %s (type /accept group to join).", arrGroupRanks[iIndex][PlayerInfo[iExtraID][pRank]], GetPlayerNameEx(iExtraID), arrGroupData[iIndex][g_szGroupName]);
				SendClientMessageEx(i, COLOR_LIGHTBLUE, szResult);

				format(szResult, sizeof szResult, "You have offered %s to join %s.", GetPlayerNameEx(i), arrGroupData[iIndex][g_szGroupName]);
				SendClientMessageEx(iExtraID, COLOR_LIGHTBLUE, szResult);
				SetPVarInt(i, "Group_Inviter", iExtraID);
			}
			else {
				SendClientMessage(iExtraID, COLOR_GREY, "That person is banned from joining this group.");
				DeletePVar(iExtraID, "Group_Invited");
			}
		}
		case GROUP_QUERY_ADDBAN: {
		    new string[128];
		    new otherplayer = GetPVarInt(iExtraID, "GroupBanningPlayer");
		    new group = GetPVarInt(iExtraID, "GroupBanningGroup");
			format(string, sizeof(string), "You have group-banned %s from group %d.", GetPlayerNameEx(otherplayer), group);
			SendClientMessageEx(iExtraID, COLOR_WHITE, string);
			format(string, sizeof(string), "You have been group-banned, by %s.", GetPlayerNameEx(iExtraID));
			SendClientMessageEx(otherplayer, COLOR_LIGHTBLUE, string);
			format(string, sizeof(string), "Administrator %s has group-banned %s (%d) from %s (%d)", GetPlayerNameEx(iExtraID), GetPlayerNameEx(otherplayer), GetPlayerSQLId(otherplayer), arrGroupData[PlayerInfo[otherplayer][pMember]][g_szGroupName], PlayerInfo[otherplayer][pMember]);
			GroupLog(PlayerInfo[otherplayer][pMember], string);
			PlayerInfo[otherplayer][pMember] = INVALID_GROUP_ID;
			PlayerInfo[otherplayer][pLeader] = INVALID_GROUP_ID;
			PlayerInfo[otherplayer][pRank] = INVALID_RANK;
			PlayerInfo[otherplayer][pDuty] = 0;
			PlayerInfo[otherplayer][pDivision] = INVALID_DIVISION;
			strcpy(PlayerInfo[otherplayer][pBadge], "None", 9);
			new rand = random(sizeof(CIV));
			PlayerInfo[otherplayer][pModel] = CIV[rand];
			SetPlayerToTeamColor(otherplayer);
			SetPlayerSkin(otherplayer, CIV[rand]);
			OnPlayerStatsUpdate(otherplayer);
			DeletePVar(iExtraID, "GroupBanningPlayer");
			DeletePVar(iExtraID, "GroupBanningGroup");
		}

		case GROUP_QUERY_UNBAN: {
			new string[128];
			new otherplayer = GetPVarInt(iExtraID, "GroupUnBanningPlayer");
			new group = GetPVarInt(iExtraID, "GroupUnBanningGroup");
			if(cache_affected_rows())
			{
				format(string, sizeof(string), "You have group-unbanned %s from group %s (%d).", GetPlayerNameEx(otherplayer), arrGroupData[group][g_szGroupName], group);
				SendClientMessageEx(iExtraID, COLOR_WHITE, string);
				format(string, sizeof(string), "You have been group-unbanned from %s, by %s.", arrGroupData[group][g_szGroupName], GetPlayerNameEx(iExtraID));
				SendClientMessageEx(otherplayer, COLOR_LIGHTBLUE, string);
				format(string, sizeof(string), "Administrator %s has group-unbanned %s (%d) from %s (%d)", GetPlayerNameEx(iExtraID), GetPlayerNameEx(otherplayer), GetPlayerSQLId(otherplayer), arrGroupData[group][g_szGroupName], group);
				GroupLog(group, string);
			}
			else
			{
				format(string, sizeof(string), "There was an issue group-unbanning %s from %s (%d)", GetPlayerNameEx(otherplayer), arrGroupData[group][g_szGroupName], group);
				SendClientMessageEx(iExtraID, COLOR_WHITE, string);
			}
			DeletePVar(iExtraID, "GroupUnBanningPlayer");
			DeletePVar(iExtraID, "GroupUnBanningGroup");
		}
		case GROUP_QUERY_UNCHECK: if(GetPVarType(iExtraID, "Group_Uninv")) {
			if(iRows) {
				cache_get_value_name(0, "Member", szResult, MAX_PLAYER_NAME);
				if(strval(szResult) == PlayerInfo[iExtraID][pMember]) {
					cache_get_value_name(0, "Rank", szResult);
					if(PlayerInfo[iExtraID][pRank] > strval(szResult) || PlayerInfo[iExtraID][pRank] >= Group_GetMaxRank(PlayerInfo[iExtraID][pMember])) {
						cache_get_value_name(0, "id", szResult);
						mysql_format(MainPipeline, szResult, sizeof szResult, "UPDATE `accounts` SET `Model` = "#NOOB_SKIN", `Member` = "#INVALID_GROUP_ID", `Rank` = "#INVALID_RANK", `Leader` = "#INVALID_GROUP_ID", `Division` = -1 WHERE `id` = %i", strval(szResult));
						mysql_tquery(MainPipeline, szResult, "Group_QueryFinish", "ii", GROUP_QUERY_UNINVITE, iExtraID);
					}
					else SendClientMessage(iExtraID, COLOR_GREY, "You can't do this to a person of equal or higher rank.");
				}
				else SendClientMessage(iExtraID, COLOR_GREY, "That person is not in your group.");

			}
			else {
				SendClientMessage(iExtraID, COLOR_GREY, "That account does not exist.");
				DeletePVar(iExtraID, "Group_Uninv");
			}
		}
		case GROUP_QUERY_UNINVITE: if(GetPVarType(iExtraID, "Group_Uninv")) {

			new
				szName[MAX_PLAYER_NAME],
				iGroupID = PlayerInfo[iExtraID][pMember];

			GetPVarString(iExtraID, "Group_Uninv", szName, sizeof szName);
			if(cache_affected_rows()) {

				i = PlayerInfo[iExtraID][pRank];
				format(szResult, sizeof szResult, "You have successfully removed %s from your group.", szName);
				SendClientMessage(iExtraID, COLOR_GREY, szResult);

				format(szResult, sizeof szResult, "%s %s (rank %i) has offline uninvited %s from %s (%i).", arrGroupRanks[iGroupID][i], GetPlayerNameEx(iExtraID), i + 1, szName, arrGroupData[iGroupID][g_szGroupName], iGroupID + 1);
				GroupLog(iGroupID, szResult);
			}
			else {
				format(szResult, sizeof szResult, "An error was encountered while attempting to remove %s from your group.", szName);
				SendClientMessage(iExtraID, COLOR_GREY, szResult);
			}
			DeletePVar(iExtraID, "Group_Uninv");
		}
	}
}

forward Jurisdiction_RehashFinish(iGroup);
public Jurisdiction_RehashFinish(iGroup) {

	new
		iRows,
		iIndex,
		szResult[128];
	cache_get_row_count(iRows);

	while(iIndex < iRows)
	{
	    new iGroupID;
		arrGroupData[iGroup][g_iJCount] = iRows;
		if(arrGroupData[iGroup][g_iJCount] > MAX_GROUP_JURISDICTIONS) {
			arrGroupData[iGroup][g_iJCount] = MAX_GROUP_JURISDICTIONS;
		}
		cache_get_value_name(iIndex, "GroupID", szResult, 24);
		iGroupID = strval(szResult);
		if(iGroupID == iGroup)
		{
			cache_get_value_name(iIndex, "id", szResult, 64);
			arrGroupJurisdictions[iGroup][iIndex][g_iJurisdictionSQLId] = strval(szResult);
			cache_get_value_name(iIndex, "AreaName", arrGroupJurisdictions[iGroup][iIndex][g_iAreaName], 64);
		}
		iIndex++;
	}
}

forward AuctionLoadQuery();
public AuctionLoadQuery() {

	new
		iRows,
		iIndex,
		szResult[128];

	cache_get_row_count(iRows);

	while((iIndex < iRows)) {
		cache_get_value_name(iIndex, "BiddingFor", Auctions[iIndex][BiddingFor], 64);
		cache_get_value_name(iIndex, "InProgress", szResult); Auctions[iIndex][InProgress] = strval(szResult);
		cache_get_value_name(iIndex, "Bid", szResult); Auctions[iIndex][Bid] = strval(szResult);
		cache_get_value_name(iIndex, "Bidder", szResult); Auctions[iIndex][Bidder] = strval(szResult);
		cache_get_value_name(iIndex, "Expires", szResult); Auctions[iIndex][Expires] = strval(szResult);
		cache_get_value_name(iIndex, "Wining", Auctions[iIndex][Wining], MAX_PLAYER_NAME);
		cache_get_value_name(iIndex, "Increment", szResult); Auctions[iIndex][Increment] = strval(szResult);
		if(Auctions[iIndex][InProgress] == 1 && Auctions[iIndex][Expires] != 0)
		{
		    Auctions[iIndex][Timer] = SetTimerEx("EndAuction", 60000, true, "i", iIndex);
		    printf("[auction - %i - started] %s, %d, %d, %d, %d, %s, %d",iIndex, Auctions[iIndex][BiddingFor],Auctions[iIndex][InProgress],Auctions[iIndex][Bid],Auctions[iIndex][Bidder],Auctions[iIndex][Expires],Auctions[iIndex][Wining],Auctions[iIndex][Increment]);
		}
		iIndex++;
	}
	return 1;
}

forward ReturnMoney(index);
public ReturnMoney(index)
{
	if(IsPlayerConnected(index))
	{
	    new
    		AuctionItem = GetPVarInt(index, "AuctionItem");

		new money[15], money2, string[128];
		new rows;
		cache_get_row_count(rows);
		if(rows)
		{
   			cache_get_value_name(0, "Money", money); money2 = strval(money);

   			mysql_format(MainPipeline, string, sizeof(string), "UPDATE `accounts` SET `Money` = %d WHERE `id` = '%d'", money2+Auctions[AuctionItem][Bid], Auctions[AuctionItem][Bidder]);
			mysql_tquery(MainPipeline, string, "OnQueryFinish", "i", SENDDATA_THREAD);

			format(string, sizeof(string), "Amount of $%d (Before: %i | After: %i) has been returned to (id: %i) for being outbid", Auctions[AuctionItem][Bid], money2,Auctions[AuctionItem][Bid]+money2,  Auctions[AuctionItem][Bidder]);
			Log("logs/auction.log", string);

            GivePlayerCash(index, -GetPVarInt(index, "BidPlaced"));
			Auctions[AuctionItem][Bid] = GetPVarInt(index, "BidPlaced");
			Auctions[AuctionItem][Bidder] = GetPlayerSQLId(index);
			strcpy(Auctions[AuctionItem][Wining], GetPlayerNameExt(index), MAX_PLAYER_NAME);

			format(string, sizeof(string), "You have placed a bid of %i on %s.", GetPVarInt(index, "BidPlaced"), Auctions[AuctionItem][BiddingFor]);
			SendClientMessageEx(index, COLOR_WHITE, string);

			format(string, sizeof(string), "%s(%d) (IP:%s) has placed a bid of %i on %s(%i)", GetPlayerNameEx(index), GetPlayerSQLId(index), GetPlayerIpEx(index), GetPVarInt(index, "BidPlaced"), Auctions[AuctionItem][BiddingFor], AuctionItem);
			Log("logs/auction.log", string);

			SaveAuction(AuctionItem);

			DeletePVar(index, "BidPlaced");
			DeletePVar(index, "AuctionItem");
		}
		else
		{
			printf("[AuctionError] id: %i | money %i", Auctions[AuctionItem][Bidder],  Auctions[AuctionItem][Bid]);
		}
	}
	return 1;
}

forward OnQueryCreateVehicle(playerid, playervehicleid);
public OnQueryCreateVehicle(playerid, playervehicleid)
{
	PlayerVehicleInfo[playerid][playervehicleid][pvSlotId] = cache_insert_id();
	printf("VNumber: %d", PlayerVehicleInfo[playerid][playervehicleid][pvSlotId]);

	new string[128];
    mysql_format(MainPipeline, string, sizeof(string), "UPDATE `vehicles` SET `pvModelId` = %d WHERE `id` = %d", PlayerVehicleInfo[playerid][playervehicleid][pvModelId], PlayerVehicleInfo[playerid][playervehicleid][pvSlotId]);
	mysql_tquery(MainPipeline, string, "OnQueryFinish", "i", SENDDATA_THREAD);

	g_mysql_SaveVehicle(playerid, playervehicleid);
}

forward CheckAccounts(playerid);
public CheckAccounts(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		new szString[128];
		new rows;
		cache_get_row_count(rows);
		if(rows)
		{
		    format(szString, sizeof(szString), "{AA3333}AdmWarning{FFFF00}: Moderator %s has logged into the server with s0beit installed.", GetPlayerNameEx(playerid));
   			ABroadCast(COLOR_YELLOW, szString, 2);

    		format(szString, sizeof(szString), "Admin %s(%d) (IP: %s) has logged into the server with s0beit installed.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid));
     		Log("logs/sobeit.log", szString);
       		sobeitCheckvar[playerid] = 1;
     		sobeitCheckIsDone[playerid] = 1;
     		IsPlayerFrozen[playerid] = 0;
		}
		else
		{
		    mysql_format(MainPipeline, szString, sizeof(szString), "INSERT INTO `sobeitkicks` (sqlID, Kicks) VALUES (%d, 1) ON DUPLICATE KEY UPDATE Kicks = Kicks + 1", GetPlayerSQLId(playerid));
			mysql_tquery(MainPipeline, szString, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);

		    SendClientMessageEx(playerid, COLOR_RED, "The hacking tool 's0beit' is not allowed on this server, please uninstall it.");
   			format(szString, sizeof(szString), "%s(%d) (IP: %s) has logged into the server with s0beit installed.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid));
   			Log("logs/sobeit.log", szString);
            sobeitCheckvar[playerid] = 1;
     		sobeitCheckIsDone[playerid] = 1;
     		IsPlayerFrozen[playerid] = 0;
    		SetTimerEx("KickEx", 1000, 0, "i", playerid);
		}
	}
	return 1;
}

forward ReferralSecurity(playerid);
public ReferralSecurity(playerid)
{
    new newrows, newresult[16], currentIP[16];
	GetPlayerIp(playerid, currentIP, sizeof(currentIP));
	cache_get_row_count(newrows);

	if(newrows > 0)
	{
 		cache_get_value_name(0, "IP", newresult);

   		if(!strcmp(newresult, currentIP, true))
	    {
	        format(szMiscArray, sizeof(szMiscArray), "Nobody");
			strmid(PlayerInfo[playerid][pReferredBy], szMiscArray, 0, strlen(szMiscArray), MAX_PLAYER_NAME);
            ShowPlayerDialogEx(playerid, DIALOG_REGISTER_REFERRED, DIALOG_STYLE_INPUT, "{FF0000}Error", "This person has the same IP as you.\nPlease choose another player that is not on your network.\n\nIf you haven't been referred, press 'Skip'.\n\nExample: FirstName_LastName (20 Characters Max)", "Enter", "Skip");
    	}
    	else {
    	    format(szMiscArray, sizeof(szMiscArray), " %s(%d) (IP:%s) has been referred by (Referred Account: %s (IP:%s))", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), currentIP, PlayerInfo[playerid][pReferredBy], newresult);
    	    Log("logs/referral.log", szMiscArray);
			RegistrationStep[playerid] = 3;
			SetPlayerVirtualWorld(playerid, 0);
			ClearChatbox(playerid);

			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Thanks for filling in all the information!");
			PlayerInfo[playerid][pTut] = 14;
			AdvanceTutorial(playerid);
		}
	}
	return 1;
}

forward OnQueryCreateToy(playerid, toyslot);
public OnQueryCreateToy(playerid, toyslot)
{
	PlayerToyInfo[playerid][toyslot][ptID] = cache_insert_id();
	printf("Toy ID: %d", PlayerToyInfo[playerid][toyslot][ptID]);

	new szQuery[128];
	mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `toys` SET `modelid` = '%d' WHERE `id` = '%d'", PlayerToyInfo[playerid][toyslot][ptID], PlayerToyInfo[playerid][toyslot][ptModelID]);
	mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "i", SENDDATA_THREAD);

	g_mysql_SaveToys(playerid, toyslot);
}

forward OnStaffAccountCheck(playerid);
public OnStaffAccountCheck(playerid)
{
	new string[156], rows;
	cache_get_row_count(rows);
	if(rows > 0)
	{
		format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s (ID: %d) was punished and has a staff account associated with their IP address.", GetPlayerNameEx(playerid), playerid);
		ABroadCast(COLOR_YELLOW, string, 2);
	}
	return 1;
}

// Relay For Life

stock LoadRelayForLifeTeam(teamid)
{
	new string[128];
	mysql_format(MainPipeline, string, sizeof(string), "SELECT * FROM `rflteams` WHERE `id`=%d", teamid);
	mysql_tquery(MainPipeline, string, "OnLoadRFLTeam", "i", mapiconid);
}

stock LoadRelayForLifeTeams()
{
	printf("[LoadRelayForLifeTeams] Loading data from database...");
	mysql_tquery(MainPipeline, "SELECT * FROM `rflteams`", "OnLoadRFLTeams", "");
}

forward OnLoadRFLTeams();
public OnLoadRFLTeams()
{
	new i, rows, tmp[128];
	cache_get_row_count(rows);

	while(i < rows)
	{
		cache_get_value_name(i, "id", tmp);  RFLInfo[i][RFLsqlid] = strval(tmp);
		cache_get_value_name(i, "name", RFLInfo[i][RFLname]);
		cache_get_value_name(i, "leader", RFLInfo[i][RFLleader]);
		cache_get_value_name(i, "used", tmp); RFLInfo[i][RFLused] = strval(tmp);
		cache_get_value_name(i, "members", tmp); RFLInfo[i][RFLmembers] = strval(tmp);
		cache_get_value_name(i, "laps", tmp); RFLInfo[i][RFLlaps] = strval(tmp);
		i++;
	}
	if(i > 0) printf("[LoadRelayForLifeTeams] %d teams loaded.", i);
	else printf("[LoadRelayForLifeTeams] Failed to load any teams.");
	return 1;
}

forward OnLoadRFLTeam(index);
public OnLoadRFLTeam(index)
{
	new rows, tmp[128];
	cache_get_row_count(rows);

	for(new row; row < rows; row++)
	{
		cache_get_value_name(row, "id", tmp);  RFLInfo[index][RFLsqlid] = strval(tmp);
		cache_get_value_name(row, "name", RFLInfo[index][RFLname]);
		cache_get_value_name(row, "leader", RFLInfo[index][RFLleader]);
		cache_get_value_name(row, "used", tmp); RFLInfo[index][RFLused] = strval(tmp);
		cache_get_value_name(row, "members", tmp); RFLInfo[index][RFLmembers] = strval(tmp);
		cache_get_value_name(row, "laps", tmp); RFLInfo[index][RFLlaps] = strval(tmp);
	}
}

stock SaveRelayForLifeTeam(teamid)
{
	new string[248];
	mysql_format(MainPipeline, string, sizeof(string), "UPDATE `rflteams` SET `name`='%s', `leader`='%s', `used`=%d, `members`=%d, `laps`=%d WHERE id=%d",
		RFLInfo[teamid][RFLname],
		RFLInfo[teamid][RFLleader],
		RFLInfo[teamid][RFLused],
		RFLInfo[teamid][RFLmembers],
		RFLInfo[teamid][RFLlaps],
		RFLInfo[teamid][RFLsqlid]
	);
	mysql_tquery(MainPipeline, string, "OnQueryFinish", "i", SENDDATA_THREAD);
}

stock SaveRelayForLifeTeams()
{
	for(new i = 0; i < MAX_RFLTEAMS; i++)
	{
		SaveRelayForLifeTeam(i);
	}
}

forward OnRFLPScore(index, id);
public OnRFLPScore(index, id)
{
	new i, rows, string[1500], tmp[7], name[25], leader[25], laps;
	cache_get_row_count(rows);
	switch(id) {
		case 1: {
			while(i < rows)
			{
				cache_get_value_name(i, "name", name);
				cache_get_value_name(i, "leader", leader);
				cache_get_value_name(i, "laps", tmp); laps = strval(tmp);
				format(string, sizeof(string), "%s\nTeam: %s | Leader: %s | Laps: %d",string, name, leader, laps);
				i++;
			}
			if(i < 1) {
				DeletePVar(index, "rflTemp");
				SendClientMessageEx(index, COLOR_GREY, "No teams found.");
				return 1;
			}
			if(i >= 15) {
				SetPVarInt(index, "rflTemp", GetPVarInt(index, "rflTemp") + i);
				ShowPlayerDialogEx(index, DIALOG_RFL_TEAMS, DIALOG_STYLE_LIST, "Relay For Life Teams", string, "Next", "Close");
				return 1;
			}
			else
			{
				DeletePVar(index, "rflTemp");
				ShowPlayerDialogEx(index, DIALOG_RFL_TEAMS, DIALOG_STYLE_LIST, "Relay For Life Teams", string, "Close", "");
				return 1;
			}
		}
		case 2: {
			while(i < rows)
			{
				cache_get_value_name(i, "Username", name);
				cache_get_value_name(i, "RacePlayerLaps", tmp); laps = strval(tmp);
				format(string, sizeof(string), "%s\n%s | Laps: %d",string, name, laps);
				i++;
			}
			if(i > 0) {
				ShowPlayerDialogEx(index, DIALOG_RFL_PLAYERS, DIALOG_STYLE_LIST, "Relay For Life Player Top 25", string, "Close", "");
			}
			else {
				SendClientMessageEx(index, COLOR_GREY, "No player has run any laps yet.");
			}
		}
	}
	return 1;
}

forward OnCheckRFLName(playerid, Player);
public OnCheckRFLName(playerid, Player)
{
	if(IsPlayerConnected(Player))
	{
		if(cache_affected_rows())
		{
			SendClientMessageEx(Player, COLOR_YELLOW, "This team name already exists.");
			SendClientMessageEx(playerid, COLOR_YELLOW, "This team name already exists.");
		}
		else
		{
			new newname[25], string[128];
			GetPVarString(Player, "NewRFLName", newname, sizeof(newname));
			format(RFLInfo[PlayerInfo[Player][pRFLTeam]][RFLname], 25, "%s", newname);
			format(string, sizeof(string), "* Your team name has been changed to %s.", newname);
			SendClientMessageEx(Player, COLOR_YELLOW, string);
			format(string, sizeof(string), "* You have changed %s's team name to %s.", GetPlayerNameEx(playerid), newname);
			SendClientMessageEx(playerid, COLOR_YELLOW, string);
			format(string, sizeof(string), "%s has accepted %s's team name change request",GetPlayerNameEx(playerid),GetPlayerNameEx(Player));
			ABroadCast(COLOR_YELLOW, string, 3);
			SaveRelayForLifeTeam(PlayerInfo[Player][pRFLTeam]);
			foreach(new i: Player)
			{
				if( GetPVarInt( i, "EventToken" ) == 1 ) {
					if( EventKernel[ EventStatus ] == 1 || EventKernel[ EventStatus ] == 2 ) {
						if(EventKernel[EventType] == 3) {
							if(PlayerInfo[i][pRFLTeam] == PlayerInfo[Player][pRFLTeam]) {
								format(string, sizeof(string), "Team: %s", newname);
								UpdateDynamic3DTextLabelText(RFLTeamN3D[i], 0x008080FF, string);
							}
						}
					}
				}
			}
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREY, "This user has logged off.");
	}
	DeletePVar(Player, "RFLNameRequest");
	DeletePVar(playerid, "RFLNameChange");
	DeletePVar(Player, "NewRFLName");
	return 1;
}

stock GetPartnerName(playerid)
{
	if(PlayerInfo[playerid][pMarriedID] == -1) format(PlayerInfo[playerid][pMarriedName], MAX_PLAYER_NAME, "Nobody");
	else
	{
		new query[128];
		mysql_format(MainPipeline, query, sizeof(query), "SELECT `Username` FROM `accounts` WHERE `id` = %d", PlayerInfo[playerid][pMarriedID]);
		mysql_tquery(MainPipeline, query, "OnGetPartnerName", "i", playerid);
	}
}

forward OnGetPartnerName(playerid);
public OnGetPartnerName(playerid)
{
	new rows, index;
	cache_get_row_count(rows);

	cache_get_value_name(index, "Username", PlayerInfo[playerid][pMarriedName], MAX_PLAYER_NAME);
	return 1;
}

forward OnStaffPrize(playerid);
public OnStaffPrize(playerid)
{
	if(cache_affected_rows())
	{
		new type[32], name[MAX_PLAYER_NAME], amount, string[128];
		GetPVarString(playerid, "OnSPrizeType", type, 16);
		GetPVarString(playerid, "OnSPrizeName", name, 24);
		amount = GetPVarInt(playerid, "OnSPrizeAmount");
		format(string, sizeof(string), "AdmCmd: %s has offline-given %s %d free %s.", GetPlayerNameEx(playerid), name, amount, type);
		ABroadCast(COLOR_LIGHTRED, string, 2);
		format(string, sizeof(string), "You have given %s %d %s.", name, amount, type);
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
		format(string, sizeof(string), "[Admin] %s(IP:%s) has offline-given %s %d free %s.", GetPlayerNameEx(playerid), GetPlayerIpEx(playerid), name, amount, type);
		Log("logs/adminrewards.log", string);
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_RED, "Failed to give the prize..");
	}
	DeletePVar(playerid, "OnSPrizeType");
	DeletePVar(playerid, "OnSPrizeName");
	DeletePVar(playerid, "OnSPrizeAmount");
	return 1;
}

stock AddNewBackpack(id)
{
	new string[1024];
	mysql_format(MainPipeline, string, sizeof(string), "INSERT into `hgbackpacks` (type, posx, posy, posz) VALUES ('%d', '%f', '%f', '%f')",
	HungerBackpackInfo[id][hgBackpackType],
	HungerBackpackInfo[id][hgBackpackPos][0],
	HungerBackpackInfo[id][hgBackpackPos][1],
	HungerBackpackInfo[id][hgBackpackPos][2]);

	mysql_tquery(MainPipeline, string, "OnQueryFinish", "i", SENDDATA_THREAD);
}

stock SaveHGBackpack(id)
{
	new string[1024];
	mysql_format(MainPipeline, string, sizeof(string), "UPDATE `hgbackpacks` SET \
		`type` = %d, \
		`posx` = %f,\
		`posy` = %f,\
		`posz` = %f WHERE `id` = %d",
		HungerBackpackInfo[id][hgBackpackType],
		HungerBackpackInfo[id][hgBackpackPos][0],
		HungerBackpackInfo[id][hgBackpackPos][1],
		HungerBackpackInfo[id][hgBackpackPos][2],
		id
	);

	mysql_tquery(MainPipeline, string, "OnQueryFinish", "i", SENDDATA_THREAD);
}

forward OnLoadHGBackpacks();
public OnLoadHGBackpacks()
{
	new rows, index, result[128], string[128];
	cache_get_row_count(rows);

	while((index < rows))
	{
		cache_get_value_name(index, "id", result); HungerBackpackInfo[index][hgBackpackId] = strval(result);
		cache_get_value_name(index, "type", result); HungerBackpackInfo[index][hgBackpackType] = strval(result);
		cache_get_value_name(index, "posx", result); HungerBackpackInfo[index][hgBackpackPos][0] = floatstr(result);
		cache_get_value_name(index, "posy", result); HungerBackpackInfo[index][hgBackpackPos][1] = floatstr(result);
		cache_get_value_name(index, "posz", result); HungerBackpackInfo[index][hgBackpackPos][2] = floatstr(result);

		HungerBackpackInfo[index][hgActiveEx] = 1;

		HungerBackpackInfo[index][hgBackpackPickupId] = CreateDynamicPickup(371, 23, HungerBackpackInfo[index][hgBackpackPos][0], HungerBackpackInfo[index][hgBackpackPos][1], HungerBackpackInfo[index][hgBackpackPos][2], 2039);
		format(string, sizeof(string), "Hunger Games Backpack\nType: %s\n{FF0000}(ID: %d){FFFFFF}", GetHungerBackpackName(index), index);
		HungerBackpackInfo[index][hgBackpack3DText] = CreateDynamic3DTextLabel(string, COLOR_ORANGE, HungerBackpackInfo[index][hgBackpackPos][0], HungerBackpackInfo[index][hgBackpackPos][1], HungerBackpackInfo[index][hgBackpackPos][2]+1, 20.0, .worldid = 2039, .interiorid = 0);

		index++;
	}

	hgBackpackCount = index;

	if(index == 0) print("[Hunger Games] No Backpack has been loaded.");
	if(index != 0) printf("[Hunger Games] %d Backpacks has been loaded.", index);
	return true;
}

forward ExecuteShopQueue(playerid, id);
public ExecuteShopQueue(playerid, id)
{
	new rows, index, result[128], string[128], query[128], tmp[8];
	switch(id)
	{
		case 0:
		{
			cache_get_row_count(rows);
			if(IsPlayerConnected(playerid))
			{
				while(index < rows)
				{
					cache_get_value_name(index, "id", result); tmp[0] = strval(result);
					cache_get_value_name(index, "GiftVoucher", result); tmp[1] = strval(result);
					cache_get_value_name(index, "CarVoucher", result); tmp[2] = strval(result);
					cache_get_value_name(index, "VehVoucher", result); tmp[3] = strval(result);
					cache_get_value_name(index, "SVIPVoucher", result); tmp[4] = strval(result);
					cache_get_value_name(index, "GVIPVoucher", result); tmp[5] = strval(result);
					cache_get_value_name(index, "PVIPVoucher", result); tmp[6] = strval(result);
					cache_get_value_name(index, "credits_spent", result); tmp[7] = strval(result);

					if(tmp[1] > 0)
					{
						PlayerInfo[playerid][pGiftVoucher] += tmp[1];
						format(string, sizeof(string), "You have been automatically issued %d gift reset voucher(s).", tmp[1]);
						SendClientMessageEx(playerid, COLOR_WHITE, string);
						format(string, sizeof(string), "[ID: %d] %s(%d) was automatically issued %d gift reset voucher(s)", tmp[0], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), tmp[1]);
						Log("logs/shoplog.log", string);
					}
					if(tmp[2] > 0)
					{
						PlayerInfo[playerid][pCarVoucher] += tmp[2];
						format(string, sizeof(string), "You have been automatically issued %d restricted car voucher(s).", tmp[2]);
						SendClientMessageEx(playerid, COLOR_WHITE, string);
						format(string, sizeof(string), "[ID: %d] %s(%d) was automatically issued %d restricted car voucher(s)", tmp[0], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), tmp[2]);
						Log("logs/shoplog.log", string);
					}
					if(tmp[3] > 0)
					{
						PlayerInfo[playerid][pVehVoucher] += tmp[3];
						format(string, sizeof(string), "You have been automatically issued %d car voucher(s).", tmp[3]);
						SendClientMessageEx(playerid, COLOR_WHITE, string);
						format(string, sizeof(string), "[ID: %d] %s(%d) was automatically issued %d car voucher(s)", tmp[0], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), tmp[3]);
						Log("logs/shoplog.log", string);
					}
					if(tmp[4] > 0)
					{
						PlayerInfo[playerid][pSVIPVoucher] += tmp[4];
						format(string, sizeof(string), "You have been automatically issued %d Silver VIP voucher(s).", tmp[4]);
						SendClientMessageEx(playerid, COLOR_WHITE, string);
						format(string, sizeof(string), "[ID: %d] %s(%d) was automatically issued %d Silver VIP voucher(s)", tmp[0], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), tmp[4]);
						Log("logs/shoplog.log", string);
					}
					if(tmp[5] > 0)
					{
						PlayerInfo[playerid][pGVIPVoucher] += tmp[5];
						format(string, sizeof(string), "You have been automatically issued %d Gold VIP voucher(s).", tmp[5]);
						SendClientMessageEx(playerid, COLOR_WHITE, string);
						format(string, sizeof(string), "[ID: %d] %s(%d) was automatically issued %d Gold VIP voucher(s)", tmp[0], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), tmp[5]);
						Log("logs/shoplog.log", string);
					}
					if(tmp[6] > 0)
					{
						PlayerInfo[playerid][pPVIPVoucher] += tmp[6];
						format(string, sizeof(string), "You have been automatically issued %d 1 month PVIP Voucher(s).", tmp[6]);
						SendClientMessageEx(playerid, COLOR_WHITE, string);
						format(string, sizeof(string), "[ID: %d] %s(%d) was automatically issued %d 1 month PVIP Voucher(s)", tmp[0], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), tmp[6]);
						Log("logs/shoplog.log", string);
					}
					GivePlayerCredits(playerid, tmp[7], 1, 1);
					format(string, sizeof(string), "%s(%d) | Credits: %d - 1", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), tmp[7]);
					Log("logs/shopdebug.log", string);
					mysql_format(MainPipeline, query, sizeof(query), "UPDATE `shop_orders` SET `status` = 1 WHERE `id` = %d", tmp[0]);
					mysql_tquery(MainPipeline, query, "OnQueryFinish", "i", SENDDATA_THREAD);
					format(string, sizeof(string), "%s(%d) | Status set to 1 - 1", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid));
					Log("logs/shopdebug.log", string);
					OnPlayerStatsUpdate(playerid);
					return SendClientMessageEx(playerid, COLOR_CYAN, "* Use /myvouchers to check and use your vouchers at any time!");
				}
			}
		}
		case 1:
		{
			cache_get_row_count(rows);
			if(IsPlayerConnected(playerid))
			{
				while(index < rows)
				{
					cache_get_value_name(index, "order_id", result); tmp[0] = strval(result);
					cache_get_value_name(index, "credit_amount", result); tmp[1] = strval(result);

					GivePlayerCredits(playerid, tmp[1], 1);
					format(string, sizeof(string), "%s(%d) | Credits: %d - 2", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), tmp[1]);
					Log("logs/shopdebug.log", string);
					format(string, sizeof(string), "You have been automatically issued %s credit(s).", number_format(tmp[1]));
					SendClientMessageEx(playerid, COLOR_WHITE, string);
					format(string, sizeof(string), "[ID: %d] %s(%d) was automatically issued %s credit(s)", tmp[0], GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), number_format(tmp[1]));
					Log("logs/shoplog.log", string);
					mysql_format(ShopPipeline, query, sizeof(query), "UPDATE `order_delivery_status` SET `status` = 1 WHERE `order_id` = %d", tmp[0]);
					mysql_tquery(ShopPipeline, query, "OnQueryFinish", "i", SENDDATA_THREAD);
					format(string, sizeof(string), "%s(%d) | Status set to 1 - 2", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid));
					Log("logs/shopdebug.log", string);
					OnPlayerStatsUpdate(playerid);
					return 1;
				}
			}
		}
	}
	return 1;
}

stock CheckAdminWhitelist(playerid)
{
	new string[128];
	mysql_format(MainPipeline, string, sizeof(string), "SELECT `AdminLevel`, `SecureIP`, `Watchdog` FROM `accounts` WHERE `Username` = '%s'", GetPlayerNameExt(playerid));
	mysql_tquery(MainPipeline, string, "OnQueryFinish", "iii", ADMINWHITELIST_THREAD, playerid, g_arrQueryHandle{playerid});
	return true;
}

stock GivePlayerCashEx(playerid, type, amount)
{
	if(IsPlayerConnected(playerid) && gPlayerLogged{playerid})
	{
		new szQuery[128];
		switch(type)
		{
			case TYPE_BANK:
			{
				PlayerInfo[playerid][pAccount] += amount;
				mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `accounts` SET `Bank`=%d WHERE `id` = %d", PlayerInfo[playerid][pAccount], GetPlayerSQLId(playerid));
				mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
			}
			case TYPE_ONHAND:
			{
				PlayerInfo[playerid][pCash] += amount;
				mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `accounts` SET `Money`=%d WHERE `id` = %d", PlayerInfo[playerid][pCash], GetPlayerSQLId(playerid));
				mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
			}
		}
	}
	return 1;
}

// g_mysql_LoadGiftBox()
// Description: Loads the data of the dynamic giftbox from the SQL Database.
stock g_mysql_LoadGiftBox()
{
	print("[Dynamic Giftbox] Loading the Dynamic Giftbox...");
	mysql_tquery(MainPipeline, "SELECT * FROM `giftbox`", "OnQueryFinish", "iii", LOADGIFTBOX_THREAD, INVALID_PLAYER_ID, -1);
}

stock SaveDynamicGiftBox()
{
	szMiscArray[0] = 0;
	for(new i = 0; i < 4; i++)
	{
		if(i == 0)
			mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "UPDATE `giftbox` SET `dgMoney%d` = '%d',", i, dgVar[dgMoney][i]);
		else
			mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `dgMoney%d` = '%d',", szMiscArray, i, dgVar[dgMoney][i]);

		mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `dgRimKit%d` = '%d',", szMiscArray, i, dgVar[dgRimKit][i]);
		mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `dgFirework%d` = '%d',", szMiscArray, i, dgVar[dgFirework][i]);
		mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `dgGVIP%d` = '%d',", szMiscArray, i, dgVar[dgGVIP][i]);
		mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `dgSVIP%d` = '%d',", szMiscArray, i, dgVar[dgSVIP][i]);
		mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `dgGVIPEx%d` = '%d',", szMiscArray, i, dgVar[dgGVIPEx][i]);
		mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `dgSVIPEx%d` = '%d',", szMiscArray, i, dgVar[dgSVIPEx][i]);
		mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `dgCarSlot%d` = '%d',", szMiscArray, i, dgVar[dgCarSlot][i]);
		mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `dgToySlot%d` = '%d',", szMiscArray, i, dgVar[dgToySlot][i]);
		mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `dgArmor%d` = '%d',", szMiscArray, i, dgVar[dgArmor][i]);
		mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `dgFirstaid%d` = '%d',", szMiscArray, i, dgVar[dgFirstaid][i]);
		mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `dgDDFlag%d` = '%d',", szMiscArray, i, dgVar[dgDDFlag][i]);
		mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `dgGateFlag%d` = '%d',", szMiscArray, i, dgVar[dgGateFlag][i]);
		mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `dgCredits%d` = '%d',", szMiscArray, i, dgVar[dgCredits][i]);
		mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `dgPriorityAd%d` = '%d',", szMiscArray, i, dgVar[dgPriorityAd][i]);
		mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `dgHealthNArmor%d` = '%d',", szMiscArray, i, dgVar[dgHealthNArmor][i]);
		mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `dgGiftReset%d` = '%d',", szMiscArray, i, dgVar[dgGiftReset][i]);
		mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `dgMaterial%d` = '%d',", szMiscArray, i, dgVar[dgMaterial][i]);
		mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `dgWarning%d` = '%d',", szMiscArray, i, dgVar[dgWarning][i]);
		mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `dgPot%d` = '%d',", szMiscArray, i, dgVar[dgPot][i]);
		mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `dgCrack%d` = '%d',", szMiscArray, i, dgVar[dgCrack][i]);
		mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `dgPaintballToken%d` = '%d',", szMiscArray, i, dgVar[dgPaintballToken][i]);
		mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `dgVIPToken%d` = '%d',", szMiscArray, i, dgVar[dgVIPToken][i]);
		mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `dgRespectPoint%d` = '%d',", szMiscArray, i, dgVar[dgRespectPoint][i]);
		mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `dgCarVoucher%d` = '%d',", szMiscArray, i, dgVar[dgCarVoucher][i]);
		mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `dgBuddyInvite%d` = '%d',", szMiscArray, i, dgVar[dgBuddyInvite][i]);
		mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `dgLaser%d` = '%d',", szMiscArray, i, dgVar[dgLaser][i]);
		mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `dgCustomToy%d` = '%d',", szMiscArray, i, dgVar[dgCustomToy][i]);
		mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `dgAdmuteReset%d` = '%d',", szMiscArray, i, dgVar[dgAdmuteReset][i]);
		mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `dgNewbieMuteReset%d` = '%d',", szMiscArray, i, dgVar[dgNewbieMuteReset][i]);

		if(i == 3)
			mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `dgRestrictedCarVoucher%d` = '%d'", szMiscArray, i, dgVar[dgRestrictedCarVoucher][i]);
		else
			mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "%s `dgPlatinumVIPVoucher%d` = '%d',", szMiscArray, i, dgVar[dgPlatinumVIPVoucher][i]);
	}
	mysql_tquery(MainPipeline, szMiscArray, "OnszMiscArrayFinish", "i", SENDDATA_THREAD);
}

stock LoadPaintballArenas()
{
	new query[64];
	printf("[LoadPaintballArenas] Loading Paintball Arenas from the database, please wait...");
	mysql_format(MainPipeline, query, sizeof(query), "SELECT * FROM `arenas` LIMIT %d", MAX_ARENAS);
	mysql_tquery(MainPipeline, query, "OnLoadPaintballArenas", "");
}

forward OnLoadPaintballArenas();
public OnLoadPaintballArenas()
{
	new rows, index, result[128];
	cache_get_row_count(rows);

	while((index < rows))
	{
		cache_get_value_name(index, "id", result); PaintBallArena[index][pbSQLId] = strval(result);
		cache_get_value_name(index, "name", PaintBallArena[index][pbArenaName], 64);
		cache_get_value_name(index, "vw", result); PaintBallArena[index][pbVirtual] = strval(result);
		cache_get_value_name(index, "interior", result); PaintBallArena[index][pbInterior] = strval(result);
		cache_get_value_name(index, "dm1", result); sscanf(result, "p<|>ffff", PaintBallArena[index][pbDeathmatch1][0], PaintBallArena[index][pbDeathmatch1][1], PaintBallArena[index][pbDeathmatch1][2], PaintBallArena[index][pbDeathmatch1][3]);
		cache_get_value_name(index, "dm2", result); sscanf(result, "p<|>ffff", PaintBallArena[index][pbDeathmatch2][0], PaintBallArena[index][pbDeathmatch2][1], PaintBallArena[index][pbDeathmatch2][2], PaintBallArena[index][pbDeathmatch2][3]);
		cache_get_value_name(index, "dm3", result); sscanf(result, "p<|>ffff", PaintBallArena[index][pbDeathmatch3][0], PaintBallArena[index][pbDeathmatch3][1], PaintBallArena[index][pbDeathmatch3][2], PaintBallArena[index][pbDeathmatch3][3]);
		cache_get_value_name(index, "dm4", result); sscanf(result, "p<|>ffff", PaintBallArena[index][pbDeathmatch4][0], PaintBallArena[index][pbDeathmatch4][1], PaintBallArena[index][pbDeathmatch4][2], PaintBallArena[index][pbDeathmatch4][3]);
		cache_get_value_name(index, "red1", result); sscanf(result, "p<|>ffff", PaintBallArena[index][pbTeamRed1][0], PaintBallArena[index][pbTeamRed1][1], PaintBallArena[index][pbTeamRed1][2], PaintBallArena[index][pbTeamRed1][3]);
		cache_get_value_name(index, "red2", result); sscanf(result, "p<|>ffff", PaintBallArena[index][pbTeamRed2][0], PaintBallArena[index][pbTeamRed2][1], PaintBallArena[index][pbTeamRed2][2], PaintBallArena[index][pbTeamRed2][3]);
		cache_get_value_name(index, "red3", result); sscanf(result, "p<|>ffff", PaintBallArena[index][pbTeamRed3][0], PaintBallArena[index][pbTeamRed3][1], PaintBallArena[index][pbTeamRed3][2], PaintBallArena[index][pbTeamRed3][3]);
		cache_get_value_name(index, "blue1", result); sscanf(result, "p<|>ffff", PaintBallArena[index][pbTeamBlue1][0], PaintBallArena[index][pbTeamBlue1][1], PaintBallArena[index][pbTeamBlue1][2], PaintBallArena[index][pbTeamBlue1][3]);
		cache_get_value_name(index, "blue2", result); sscanf(result, "p<|>ffff", PaintBallArena[index][pbTeamBlue2][0], PaintBallArena[index][pbTeamBlue2][1], PaintBallArena[index][pbTeamBlue2][2], PaintBallArena[index][pbTeamBlue2][3]);
		cache_get_value_name(index, "blue3", result); sscanf(result, "p<|>ffff", PaintBallArena[index][pbTeamBlue3][0], PaintBallArena[index][pbTeamBlue3][1], PaintBallArena[index][pbTeamBlue3][2], PaintBallArena[index][pbTeamBlue3][3]);
		cache_get_value_name(index, "flagred", result); sscanf(result, "p<|>fff", PaintBallArena[index][pbFlagRedSpawn][0], PaintBallArena[index][pbFlagRedSpawn][1], PaintBallArena[index][pbFlagRedSpawn][2]);
		cache_get_value_name(index, "flagblue", result); sscanf(result, "p<|>fff", PaintBallArena[index][pbFlagBlueSpawn][0], PaintBallArena[index][pbFlagBlueSpawn][1], PaintBallArena[index][pbFlagBlueSpawn][2]);
		cache_get_value_name(index, "hill", result); sscanf(result, "p<|>fff", PaintBallArena[index][pbHillX], PaintBallArena[index][pbHillY], PaintBallArena[index][pbHillZ]);
		cache_get_value_name(index, "hillr", result); PaintBallArena[index][pbHillRadius] = floatstr(result);
		cache_get_value_name(index, "veh1", result); sscanf(result, "p<|>dffff", PaintBallArena[index][pbVeh1Model], PaintBallArena[index][pbVeh1X], PaintBallArena[index][pbVeh1Y], PaintBallArena[index][pbVeh1Z], PaintBallArena[index][pbVeh1A]);
 		cache_get_value_name(index, "veh2", result); sscanf(result, "p<|>dffff", PaintBallArena[index][pbVeh2Model], PaintBallArena[index][pbVeh2X], PaintBallArena[index][pbVeh2Y], PaintBallArena[index][pbVeh2Z], PaintBallArena[index][pbVeh2A]);
		cache_get_value_name(index, "veh3", result); sscanf(result, "p<|>dffff", PaintBallArena[index][pbVeh3Model], PaintBallArena[index][pbVeh3X], PaintBallArena[index][pbVeh3Y], PaintBallArena[index][pbVeh3Z], PaintBallArena[index][pbVeh3A]);
		cache_get_value_name(index, "veh4", result); sscanf(result, "p<|>dffff", PaintBallArena[index][pbVeh4Model], PaintBallArena[index][pbVeh4X], PaintBallArena[index][pbVeh4Y], PaintBallArena[index][pbVeh4Z], PaintBallArena[index][pbVeh4A]);
		cache_get_value_name(index, "veh5", result); sscanf(result, "p<|>dffff", PaintBallArena[index][pbVeh5Model], PaintBallArena[index][pbVeh5X], PaintBallArena[index][pbVeh5Y], PaintBallArena[index][pbVeh5Z], PaintBallArena[index][pbVeh5A]);
		cache_get_value_name(index, "veh6", result); sscanf(result, "p<|>dffff", PaintBallArena[index][pbVeh6Model], PaintBallArena[index][pbVeh6X], PaintBallArena[index][pbVeh6Y], PaintBallArena[index][pbVeh6Z], PaintBallArena[index][pbVeh6A]);
		index++;
	}
	if(index == 0) print("[LoadPaintBallArenas] No Paintball Arenas have been loaded.");
	if(index != 0) printf("[LoadPaintBallArenas] %d Paintball Arenas have been loaded.", index);
	return 1;
}

stock SavePaintballArena(index)
{
	new query[2048];
	mysql_format(MainPipeline, query, sizeof(query), "UPDATE `arenas` SET `name`='%e',", PaintBallArena[index][pbArenaName]);
	mysql_format(MainPipeline, query, sizeof(query), "%s `vw`=%d,",query, PaintBallArena[index][pbVirtual]);
	mysql_format(MainPipeline, query, sizeof(query), "%s `interior`=%d,", query, PaintBallArena[index][pbInterior]);
	mysql_format(MainPipeline, query, sizeof(query), "%s `dm1`='%f|%f|%f|%f',", query, PaintBallArena[index][pbDeathmatch1][0], PaintBallArena[index][pbDeathmatch1][1], PaintBallArena[index][pbDeathmatch1][2], PaintBallArena[index][pbDeathmatch1][3]);
	mysql_format(MainPipeline, query, sizeof(query), "%s `dm2`='%f|%f|%f|%f',", query, PaintBallArena[index][pbDeathmatch2][0], PaintBallArena[index][pbDeathmatch2][1], PaintBallArena[index][pbDeathmatch2][2], PaintBallArena[index][pbDeathmatch2][3]);
	mysql_format(MainPipeline, query, sizeof(query), "%s `dm3`='%f|%f|%f|%f',", query, PaintBallArena[index][pbDeathmatch3][0], PaintBallArena[index][pbDeathmatch3][1], PaintBallArena[index][pbDeathmatch3][2], PaintBallArena[index][pbDeathmatch3][3]);
	mysql_format(MainPipeline, query, sizeof(query), "%s `dm4`='%f|%f|%f|%f',", query, PaintBallArena[index][pbDeathmatch4][0], PaintBallArena[index][pbDeathmatch4][1], PaintBallArena[index][pbDeathmatch4][2], PaintBallArena[index][pbDeathmatch4][3]);
	mysql_format(MainPipeline, query, sizeof(query), "%s `red1`='%f|%f|%f|%f',", query, PaintBallArena[index][pbTeamRed1][0], PaintBallArena[index][pbTeamRed1][1], PaintBallArena[index][pbTeamRed1][2], PaintBallArena[index][pbTeamRed1][3]);
	mysql_format(MainPipeline, query, sizeof(query), "%s `red2`='%f|%f|%f|%f',", query, PaintBallArena[index][pbTeamRed2][0], PaintBallArena[index][pbTeamRed2][1], PaintBallArena[index][pbTeamRed2][2], PaintBallArena[index][pbTeamRed2][3]);
	mysql_format(MainPipeline, query, sizeof(query), "%s `red3`='%f|%f|%f|%f',", query, PaintBallArena[index][pbTeamRed3][0], PaintBallArena[index][pbTeamRed3][1], PaintBallArena[index][pbTeamRed3][2], PaintBallArena[index][pbTeamRed3][3]);
	mysql_format(MainPipeline, query, sizeof(query), "%s `blue1`='%f|%f|%f|%f',", query, PaintBallArena[index][pbTeamBlue1][0], PaintBallArena[index][pbTeamBlue1][1], PaintBallArena[index][pbTeamBlue1][2], PaintBallArena[index][pbTeamBlue1][3]);
	mysql_format(MainPipeline, query, sizeof(query), "%s `blue2`='%f|%f|%f|%f',", query, PaintBallArena[index][pbTeamBlue2][0], PaintBallArena[index][pbTeamBlue2][1], PaintBallArena[index][pbTeamBlue2][2], PaintBallArena[index][pbTeamBlue2][3]);
	mysql_format(MainPipeline, query, sizeof(query), "%s `blue3`='%f|%f|%f|%f',", query, PaintBallArena[index][pbTeamBlue3][0], PaintBallArena[index][pbTeamBlue3][1], PaintBallArena[index][pbTeamBlue3][2], PaintBallArena[index][pbTeamBlue3][3]);
	mysql_format(MainPipeline, query, sizeof(query), "%s `flagred`='%f|%f|%f',", query, PaintBallArena[index][pbFlagRedSpawn][0], PaintBallArena[index][pbFlagRedSpawn][1], PaintBallArena[index][pbFlagRedSpawn][2]);
	mysql_format(MainPipeline, query, sizeof(query), "%s `flagblue`='%f|%f|%f',", query, PaintBallArena[index][pbFlagBlueSpawn][0], PaintBallArena[index][pbFlagBlueSpawn][1], PaintBallArena[index][pbFlagBlueSpawn][2]);
	mysql_format(MainPipeline, query, sizeof(query), "%s `hill`='%f|%f|%f',", query, PaintBallArena[index][pbHillX], PaintBallArena[index][pbHillY], PaintBallArena[index][pbHillZ]);
	mysql_format(MainPipeline, query, sizeof(query), "%s `hillr`=%f,", query, PaintBallArena[index][pbHillRadius]);
	mysql_format(MainPipeline, query, sizeof(query), "%s `veh1`='%d|%f|%f|%f|%f',", query, PaintBallArena[index][pbVeh1Model], PaintBallArena[index][pbVeh1X], PaintBallArena[index][pbVeh1Y], PaintBallArena[index][pbVeh1Z], PaintBallArena[index][pbVeh1A]);
	mysql_format(MainPipeline, query, sizeof(query), "%s `veh2`='%d|%f|%f|%f|%f',", query, PaintBallArena[index][pbVeh2Model], PaintBallArena[index][pbVeh2X], PaintBallArena[index][pbVeh2Y], PaintBallArena[index][pbVeh2Z], PaintBallArena[index][pbVeh2A]);
	mysql_format(MainPipeline, query, sizeof(query), "%s `veh3`='%d|%f|%f|%f|%f',", query, PaintBallArena[index][pbVeh3Model], PaintBallArena[index][pbVeh3X], PaintBallArena[index][pbVeh3Y], PaintBallArena[index][pbVeh3Z], PaintBallArena[index][pbVeh3A]);
	mysql_format(MainPipeline, query, sizeof(query), "%s `veh4`='%d|%f|%f|%f|%f',", query, PaintBallArena[index][pbVeh4Model], PaintBallArena[index][pbVeh4X], PaintBallArena[index][pbVeh4Y], PaintBallArena[index][pbVeh4Z], PaintBallArena[index][pbVeh4A]);
	mysql_format(MainPipeline, query, sizeof(query), "%s `veh5`='%d|%f|%f|%f|%f',", query, PaintBallArena[index][pbVeh5Model], PaintBallArena[index][pbVeh5X], PaintBallArena[index][pbVeh5Y], PaintBallArena[index][pbVeh5Z], PaintBallArena[index][pbVeh5A]);
	mysql_format(MainPipeline, query, sizeof(query), "%s `veh6`='%d|%f|%f|%f|%f'", query, PaintBallArena[index][pbVeh6Model], PaintBallArena[index][pbVeh6X], PaintBallArena[index][pbVeh6Y], PaintBallArena[index][pbVeh6Z], PaintBallArena[index][pbVeh6A]);
	mysql_format(MainPipeline, query, sizeof(query), "%s WHERE `id` = %d", query, PaintBallArena[index][pbSQLId]);
	mysql_tquery(MainPipeline, query, "OnQueryFinish", "i", SENDDATA_THREAD);
}

stock SavePaintballArenas()
{
	for(new i = 0; i < MAX_ARENAS; ++i)
	{
		SavePaintballArena(i);
	}
}

stock AddNonRPPoint(playerid, point, expiration, reason[], issuerid, manual)
{
	new szQuery[512], escapedstring[128];
	mysql_escape_string(reason, escapedstring);

	mysql_format(MainPipeline, szQuery, sizeof(szQuery), "INSERT INTO `nonrppoints` (sqlid, point, expiration, reason, issuer, active, manual) VALUES ('%d', '%d', '%d', '%s', '%d', '1', '%d')",
	GetPlayerSQLId(playerid),
	point,
	expiration,
	escapedstring,
	GetPlayerSQLId(issuerid),
	manual);

	mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "i", SENDDATA_THREAD);
}

stock LoadPlayerNonRPPoints(playerid)
{
	new string[128];
	mysql_format(MainPipeline, string, sizeof(string), "SELECT * FROM `nonrppoints` WHERE `sqlid` = '%d'", PlayerInfo[playerid][pId]);
	mysql_tquery(MainPipeline, string, "OnQueryFinish", "iii", LOADPNONRPOINTS_THREAD, playerid, g_arrQueryHandle{playerid});
	return true;
}

forward OnWDWhitelist(index);
public OnWDWhitelist(index)
{
	new string[128], name[24];
	GetPVarString(index, "OnWDWhitelist", name, 24);

	if(cache_affected_rows()) {
		format(string, sizeof(string), "You have successfully whitelisted %s's account.", name);
		SendClientMessageEx(index, COLOR_WHITE, string);
		format(string, sizeof(string), "%s has IP Whitelisted %s", GetPlayerNameEx(index), name);
		Log("logs/wdwhitelist.log", string);
	}
	else {
		format(string, sizeof(string), "There was a issue with whitelisting %s's account.", name);
		SendClientMessageEx(index, COLOR_WHITE, string);
	}
	DeletePVar(index, "OnWDWhitelist");

	return 1;
}

forward FetchWatchlist(index);
public FetchWatchlist(index)
{
	new rows;
	cache_get_row_count(rows);
	for(new i = 0; i < rows; i++)
	{
		new szResult[32], points, sqlid;
		cache_get_value_name(i, "sqlid", szResult); sqlid = strval(szResult);
		cache_get_value_name(i, "point", szResult); points = strval(szResult);

		foreach(new x: Player)
		{
			if(PlayerInfo[x][pId] == sqlid)
			{
				format(PublicSQLString, sizeof(PublicSQLString), "%s %s (ID: %d) | Points: %d - Manually Added\n", PublicSQLString, GetPlayerNameEx(x), x, points);
				break;
			}
		}
	}

	mysql_tquery(MainPipeline, "SELECT sqlid, point  FROM `nonrppoints` LEFT JOIN accounts on sqlid = accounts.id WHERE (`active` = '1' AND `manual` = '0') AND accounts.`Online` = 1 ORDER BY `point` DESC LIMIT 15", "FetchWatchlist2", "i", index);
	return true;
}

forward FetchWatchlist2(index, input[]);
public FetchWatchlist2(index, input[])
{
	new rows;
	cache_get_row_count(rows);
	for(new i = 0; i < rows; i++)
	{
		new szResult[32], points, sqlid;
		cache_get_value_name(i, "sqlid", szResult); sqlid = strval(szResult);
		cache_get_value_name(i, "point", szResult); points = strval(szResult);

		foreach(new x: Player)
		{
			if(PlayerInfo[x][pId] == sqlid)
			{
				format(PublicSQLString, sizeof(PublicSQLString), "%s %s (ID: %d) | Points: %d - Automatically Added\n", PublicSQLString, GetPlayerNameEx(x), x, points);
				break;
			}
		}
	}

	ShowPlayerDialogEx(index, DIALOG_WATCHLIST, DIALOG_STYLE_LIST, "Current Watchlist", PublicSQLString, "Exit", "");
	FetchingWatchlist = 0;
	return true;
}

forward OnSetVMute(playerid, task);
public OnSetVMute(playerid, task)
{
	new string[128], tmpName[MAX_PLAYER_NAME];
	GetPVarString(playerid, "OnSetVMute", tmpName, sizeof(tmpName));
	DeletePVar(playerid, "OnSetVMute");
	if(cache_affected_rows())
	{
		format(string, sizeof(string), "AdmCmd: %s has offline vip %s %s.", GetPlayerNameEx(playerid), (task==1)?("muted"):("unmuted"), tmpName);
		Log("logs/mute.log", string);
		ABroadCast(COLOR_LIGHTRED, string, 3);
	}
	else
	{
		format(string, sizeof(string), "Could not vip %s %s..", (task==1)?("mute"):("unmute"), tmpName);
		SendClientMessageEx(playerid, COLOR_YELLOW, string);
	}
	return 1;
}

forward CheckClientWatchlist(index);
public CheckClientWatchlist(index)
{
	new rows;
	cache_get_row_count(rows);
	if(rows == 0) PlayerInfo[index][pWatchlist] = 0;
	else PlayerInfo[index][pWatchlist] = 1;
	return true;
}

forward WatchWatchlist(index);
public WatchWatchlist(index)
{
	new rows, result;
	cache_get_row_count(rows);
	for(new i = 0; i < rows; i++)
	{
		new szResult[32], sqlid;
		cache_get_value_name(i, "sqlid", szResult); sqlid = strval(szResult);

		foreach(new x: Player)
		{
			if(PlayerInfo[x][pId] == sqlid && gPlayerLogged{x} == 1 && PlayerInfo[x][pJailTime] == 0 && GetPVarInt(x, "BeingSpectated") == 0)
			{
				SpectatePlayer(index, x);
				SetPVarInt(x, "BeingSpectated", 1);
				SendClientMessageEx(index, -1, "WATCHDOG: You have started watching, you may skip to another player in 3 minutes (/nextwatch).");
				if(PlayerInfo[index][pWatchdog] == 2) SetPVarInt(index, "NextWatch", gettime()+120); else SetPVarInt(index, "NextWatch", gettime()+180);
				SetPVarInt(index, "SpectatingWatch", x);
				SetPVarInt(index, "StartedWatching", 1);
				WDReportCount[index]++;
				WDReportHourCount[index]++;
				AddWDToken(index);
				result = 1;
				break;
			}
		}
		if(result) break;
	}
	if(result == 0)
	{
		SendClientMessageEx(index, COLOR_GRAD1, "No-one is available to spectate!");
	}
	return true;
}

forward CheckTrunkContents(playerid);
public CheckTrunkContents(playerid)
{
	new rows, TrunkWeaps[3];
	cache_get_row_count(rows);
	if(rows == 0) return 1;
	new string[189];
	cache_get_value_name_int(0, "pvWeapon0", TrunkWeaps[0]);
	cache_get_value_name_int(0, "pvWeapon1", TrunkWeaps[1]);
	cache_get_value_name_int(0, "pvWeapon2", TrunkWeaps[2]);
	new
		i = 0;
	while (i < 3 && (!TrunkWeaps[i] || PlayerInfo[playerid][pGuns][GetWeaponSlot(TrunkWeaps[i])] ==  TrunkWeaps[i]))
	{
		i++;
	}
	if (i == 3) return SendClientMessageEx(playerid, COLOR_YELLOW, "Warning{FFFFFF}: There was nothing inside the trunk.");
	else {
		format(string, sizeof(string), "You found a %s.", GetWeaponNameEx(TrunkWeaps[i]));
		SendClientMessageEx(playerid, COLOR_YELLOW, string);
		GivePlayerValidWeapon(playerid, TrunkWeaps[i]);
		mysql_format(MainPipeline, string, sizeof(string), "UPDATE `vehicles` SET `pvWeapon%d` = '0' WHERE `id` = '%d' AND `sqlID` = '%d'", i, GetPVarInt(playerid, "LockPickVehicleSQLId"), GetPVarInt(playerid, "LockPickPlayerSQLId"));
		mysql_tquery(MainPipeline, string, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
		new ip[MAX_PLAYER_NAME], ownername[MAX_PLAYER_NAME], vehicleid = GetPVarInt(playerid, "LockPickVehicle");
		GetPlayerIp(playerid, ip, sizeof(ip)), GetPVarString(playerid, "LockPickPlayerName", ownername, sizeof(ownername));
		format(string, sizeof(string), "[LOCK PICK] %s(%d) (IP:%s) successfully cracked the trunk of a %s(VID:%d SQLId %d Weapon ID: %d) owned by %s(Offline, SQLId:%d)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ip, GetVehicleName(vehicleid), vehicleid, GetPVarInt(playerid, "LockPickVehicleSQLId"), TrunkWeaps[i], ownername, GetPVarInt(playerid, "LockPickPlayerSQLId"));
		Log("logs/playervehicle.log", string);
	}
	return 1;
}

forward OnRequestTransferFlag(playerid, flagid, to, from);
public OnRequestTransferFlag(playerid, flagid, to, from)
{
	new rows, value, string[512];
	new FlagText[64], FlagIssuer[MAX_PLAYER_NAME], FlagDate[24];
	cache_get_row_count(rows);
	if(!rows) return ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "{FF0000}Flag Error:", "Flag does not exist!", "Close", "");
	cache_get_value_name_int(0, "type", value);
	if(value == 2)
		return ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "{FF0000}Flag Error:", "Administrative flags cannot be transferred!", "Close", "");
	cache_get_value_name_int(0, "id", value);
	if(value != GetPlayerSQLId(from))
		return format(string, sizeof(string), "Flag is not owned by %s!", GetPlayerNameEx(from)), ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "{FF0000}Flag Error:", string, "Close", "");
	cache_get_value_name(0, "flag", FlagText);
	cache_get_value_name(0, "issuer", FlagIssuer, MAX_PLAYER_NAME);
	cache_get_value_name(0, "time", FlagDate);
	SetPVarInt(playerid, "Flag_Transfer_ID", flagid);
	SetPVarInt(playerid, "Flag_Transfer_To", to);
	SetPVarInt(playerid, "Flag_Transfer_From", from);
	SetPVarString(playerid, "FlagText", FlagText);
	format(string, sizeof(string), "Are you sure you want to transfer:\n{FF6347}Flag ID:{BFC0C2} %d\n{FF6347}Flag:{BFC0C2} %s\n{FF6347}Issued by:{BFC0C2} %s\n{FF6347}Date Issued: {BFC0C2}%s\n{FF6347}To: {BFC0C2}%s\n{FF6347}From: {BFC0C2}%s", flagid, FlagText, FlagIssuer, FlagDate, GetPlayerNameEx(to), GetPlayerNameEx(from));
	return ShowPlayerDialogEx(playerid, FLAG_TRANSFER, DIALOG_STYLE_MSGBOX, "FLAG TRANSFER", string, "Yes", "No");
}

forward GetShiftInfo(playerid, szMessage[]);
public GetShiftInfo(playerid, szMessage[])
{
	new rows, fieldname[24], szResult[32], string[1288], shift[4], needs, signedup;
	cache_get_row_count(rows);

	if(rows)
	{
		format(fieldname, sizeof(fieldname), "needs_%s", GetWeekday());
		cache_get_value_name(0, "shift", shift, sizeof(shift));
		cache_get_value_name(0, fieldname, szResult); needs = strval(szResult);
		cache_get_value_name(0, "ShiftCount", szResult); signedup = strval(szResult);
	}

	if(needs - signedup > 0) format(string, sizeof(string), "The current shift is %s. We have {FF0000}%d/%d {FFFFFF}Admins signed up for the shift.", shift, signedup, needs);
	else format(string, sizeof(string), "The current shift is %s. We have {00FF00}%d/%d {FFFFFF}Admins signed up for the shift.", shift, signedup, needs);

	if(playerid == INVALID_PLAYER_ID)
	{
		if(needs - signedup > 0) format(string, sizeof(string), "The current shift is %s. We have {FF0000}%d/%d {FFFFFF}Admins signed up for the shift.", shift, signedup, needs);
		else format(string, sizeof(string), "The current shift is %s. We have {00FF00}%d/%d {FFFFFF}Admins signed up for the shift.", shift, signedup, needs);
		foreach(new i: Player)
		{
			if(PlayerInfo[i][pAdmin] >= 2) SendClientMessageEx(i, COLOR_WHITE, string);
		}
	}
	else if(playerid != INVALID_PLAYER_ID)
	{
		if(needs - signedup > 0) format(string, sizeof(string), "The current shift is %s. We have {FF0000}%d/%d {FFFFFF}Admins signed up for the shift.", shift, signedup, needs);
		else format(string, sizeof(string), "The current shift is %s. We have {00FF00}%d/%d {FFFFFF}Admins signed up for the shift.", shift, signedup, needs);
		SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
	}
	return 1;
}

// g_mysql_LoadFIFInfo(playerid)
// Description: Load the player's Fall Into Fun Info
stock g_mysql_LoadFIFInfo(playerid)
{
	new szQuery[128];
	mysql_format(MainPipeline, szQuery, sizeof(szQuery), "SELECT * FROM `fallintofun` WHERE `player` = %d", PlayerInfo[playerid][pId]);
	mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "iii", LOADFIF_THREAD, playerid, g_arrQueryHandle{playerid});
	return 1;
}

stock g_mysql_SaveFIF(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		new szQuery[128];
		mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `fallintofun` SET `FIFHours` = %d, `FIFChances` = %d WHERE `player` = %d", FIFInfo[playerid][FIFHours], FIFInfo[playerid][FIFChances], PlayerInfo[playerid][pId]);
		mysql_tquery(MainPipeline, szQuery, "OnSaveFIF", "i", playerid);
	}
}

forward OnSaveFIF(playerid);
public OnSaveFIF(playerid) {

	printf("Saved %s's FIF stats", GetPlayerNameEx(playerid));

	return 1;
}

g_mysql_SaveGroupToy(playerid) {

	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "UPDATE `accounts` SET\
		`GroupToy0` = '%f', `GroupToy1` = '%f', `GroupToy2` = '%f', `GroupToy3` = '%f', `GroupToy4` = '%f', `GroupToy5` = '%f', `GroupToy6` = '%f', \
		`GroupToy7` = '%f', `GroupToy8` = '%f' WHERE `id` = '%d'", PlayerInfo[playerid][pGroupToy][0], PlayerInfo[playerid][pGroupToy][1],
		PlayerInfo[playerid][pGroupToy][2], PlayerInfo[playerid][pGroupToy][3], PlayerInfo[playerid][pGroupToy][4],
		PlayerInfo[playerid][pGroupToy][5], PlayerInfo[playerid][pGroupToy][6], PlayerInfo[playerid][pGroupToy][7],
		PlayerInfo[playerid][pGroupToy][8], GetPlayerSQLId(playerid));

	mysql_tquery(MainPipeline, szMiscArray, "OnQueryFinish", "i", SENDDATA_THREAD);
}