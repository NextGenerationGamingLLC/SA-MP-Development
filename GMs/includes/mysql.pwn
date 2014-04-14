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
 
//--------------------------------[ FUNCTIONS ]---------------------------
 
PinLogin(playerid)
{
    new string[128];
    format(string, sizeof(string), "SELECT `Pin` FROM `accounts` WHERE `id` = %d", GetPlayerSQLId(playerid));
	mysql_function_query(MainPipeline, string, true, "OnPinCheck", "i", playerid);
	return 1;
}

Group_DisbandGroup(iGroupID) {

	new
		i = 0,
		szQuery[128];

	arrGroupData[iGroupID][g_iAllegiance] = 0;
	arrGroupData[iGroupID][g_iBugAccess] = INVALID_RANK;
	arrGroupData[iGroupID][g_iRadioAccess] = INVALID_RANK;
	arrGroupData[iGroupID][g_iDeptRadioAccess] = INVALID_RANK;
	arrGroupData[iGroupID][g_iIntRadioAccess] = INVALID_RANK;
	arrGroupData[iGroupID][g_iGovAccess] = INVALID_RANK;
	arrGroupData[iGroupID][g_iFreeNameChange] = INVALID_RANK;
	arrGroupData[iGroupID][g_iSpikeStrips] = INVALID_RANK;
	arrGroupData[iGroupID][g_iBarricades] = INVALID_RANK;
	arrGroupData[iGroupID][g_iCones] = INVALID_RANK;
	arrGroupData[iGroupID][g_iFlares] = INVALID_RANK;
	arrGroupData[iGroupID][g_iBarrels] = INVALID_RANK;
	arrGroupData[iGroupID][g_iBudget] = 0;
	arrGroupData[iGroupID][g_iBudgetPayment] = 0;
	arrGroupData[iGroupID][g_fCratePos][0] = 0;
	arrGroupData[iGroupID][g_fCratePos][1] = 0;
	arrGroupData[iGroupID][g_fCratePos][2] = 0;
	arrGroupData[iGroupID][g_szGroupName][0] = 0;
	arrGroupData[iGroupID][g_szGroupMOTD][0] = 0;

	arrGroupData[iGroupID][g_hDutyColour] = 0xFFFFFF;
	arrGroupData[iGroupID][g_hRadioColour] = 0xFFFFFF;

	DestroyDynamic3DTextLabel(arrGroupData[iGroupID][g_tCrate3DLabel]);

	while(i < MAX_GROUP_DIVS) {
		arrGroupDivisions[iGroupID][i++][0] = 0;
	}
	i = 0;

	while(i < MAX_GROUP_RANKS) {
		arrGroupRanks[iGroupID][i][0] = 0;
		arrGroupData[iGroupID][g_iPaycheck][i++] = 0;
	}
	i = 0;

	while(i < MAX_GROUP_WEAPONS) {
		arrGroupData[iGroupID][g_iLockerGuns][i] = 0;
		arrGroupData[iGroupID][g_iLockerCost][i++] = 0;
	}

	i = 0;
	while(i < MAX_GROUP_LOCKERS) {
		DestroyDynamic3DTextLabel(arrGroupLockers[iGroupID][i][g_tLocker3DLabel]);
		arrGroupLockers[iGroupID][i][g_fLockerPos][0] = 0.0;
		arrGroupLockers[iGroupID][i][g_fLockerPos][1] = 0.0;
		arrGroupLockers[iGroupID][i][g_fLockerPos][2] = 0.0;
		arrGroupData[iGroupID][g_iLockerGuns][i] = 0;
		arrGroupData[iGroupID][g_iLockerCost][i++] = 0;
	}
	SaveGroup(iGroupID);

	//foreach(new x: Player)
	for(new x = 0; x < MAX_PLAYERS; ++x)
	{
		if(IsPlayerConnected(x))
		{
			if(PlayerInfo[x][pMember] == iGroupID || PlayerInfo[x][pLeader] == iGroupID) {
				SendClientMessageEx(x, COLOR_WHITE, "Your group has been disbanded by an administrator. All members have been automatically removed.");
				PlayerInfo[x][pLeader] = INVALID_GROUP_ID;
				PlayerInfo[x][pMember] = INVALID_GROUP_ID;
				PlayerInfo[x][pRank] = INVALID_RANK;
				PlayerInfo[x][pDivision] = INVALID_DIVISION;
			}
			if (PlayerInfo[x][pBugged] == iGroupID) PlayerInfo[x][pBugged] = INVALID_GROUP_ID;
		}	
	}


	format(szQuery, sizeof szQuery, "DELETE FROM `groupbans` WHERE `GroupBan` = %i", iGroupID);
	mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "ii", SENDDATA_THREAD, iGroupID+1);

	format(szQuery, sizeof szQuery, "UPDATE `accounts` SET `Member` = "#INVALID_GROUP_ID", `Leader` = "#INVALID_GROUP_ID", `Division` = "#INVALID_DIVISION", `Rank` = "#INVALID_RANK" WHERE `Member` = %i OR `Leader` = %i", iGroupID, iGroupID);
	return mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "ii", SENDDATA_THREAD, iGroupID);
}

SaveGroup(iGroupID) {

	/*
		Internally, every group array/subarray starts from zero (divisions, group ids etc)
		When displaying to the clients or saving to the db, we add 1 to them!
		The only exception is ranks which already start from zero.
	*/

	if(!(0 <= iGroupID < MAX_GROUPS)) // Array bounds check. Use it.
		return 0;

	new
		szQuery[2048],
		i = 0;

	format(szQuery, sizeof szQuery, "UPDATE `groups` SET \
		`Type` = %i, `Name` = '%s', `MOTD` = '%s', `Allegiance` = %i, `Bug` = %i, \
		`Radio` = %i, `DeptRadio` = %i, `IntRadio` = %i, `GovAnnouncement` = %i, `FreeNameChange` = %i, `DutyColour` = %i, `RadioColour` = %i, ",
		arrGroupData[iGroupID][g_iGroupType], g_mysql_ReturnEscaped(arrGroupData[iGroupID][g_szGroupName], MainPipeline), g_mysql_ReturnEscaped(arrGroupData[iGroupID][g_szGroupMOTD], MainPipeline), arrGroupData[iGroupID][g_iAllegiance], arrGroupData[iGroupID][g_iBugAccess],
		arrGroupData[iGroupID][g_iRadioAccess], arrGroupData[iGroupID][g_iDeptRadioAccess], arrGroupData[iGroupID][g_iIntRadioAccess], arrGroupData[iGroupID][g_iGovAccess], arrGroupData[iGroupID][g_iFreeNameChange], arrGroupData[iGroupID][g_hDutyColour], arrGroupData[iGroupID][g_hRadioColour]
	);
	format(szQuery, sizeof szQuery, "%s\
		`Stock` = %i, `CrateX` = '%.2f', `CrateY` = '%.2f', `CrateZ` = '%.2f', \
		`SpikeStrips` = %i, `Barricades` = %i, `Cones` = %i, `Flares` = %i, `Barrels` = %i, \
		`Budget` = %i, `BudgetPayment` = %i, LockerCostType = %i, `CratesOrder` = '%d', `CrateIsland` = '%d', \
		`GarageX` = '%.2f', `GarageY` = '%.2f', `GarageZ` = '%.2f', `TackleAccess` = '%d'",
		szQuery,
		arrGroupData[iGroupID][g_iLockerStock], arrGroupData[iGroupID][g_fCratePos][0], arrGroupData[iGroupID][g_fCratePos][1], arrGroupData[iGroupID][g_fCratePos][2],
		arrGroupData[iGroupID][g_iSpikeStrips], arrGroupData[iGroupID][g_iBarricades], arrGroupData[iGroupID][g_iCones], arrGroupData[iGroupID][g_iFlares], arrGroupData[iGroupID][g_iBarrels],
		arrGroupData[iGroupID][g_iBudget], arrGroupData[iGroupID][g_iBudgetPayment], arrGroupData[iGroupID][g_iLockerCostType], arrGroupData[iGroupID][g_iCratesOrder], arrGroupData[iGroupID][g_iCrateIsland],
		arrGroupData[iGroupID][g_fGaragePos][0], arrGroupData[iGroupID][g_fGaragePos][1], arrGroupData[iGroupID][g_fGaragePos][2], arrGroupData[iGroupID][g_iTackleAccess]);

	for(i = 0; i != MAX_GROUP_RANKS; ++i) format(szQuery, sizeof szQuery, "%s, `Rank%i` = '%s'", szQuery, i, arrGroupRanks[iGroupID][i]);
	for(i = 0; i != MAX_GROUP_RANKS; ++i) format(szQuery, sizeof szQuery, "%s, `Rank%iPay` = %i", szQuery, i, arrGroupData[iGroupID][g_iPaycheck][i]);
	for(i = 0; i != MAX_GROUP_DIVS; ++i) format(szQuery, sizeof szQuery, "%s, `Div%i` = '%s'", szQuery, i+1, arrGroupDivisions[iGroupID][i]);
	for(i = 0; i != MAX_GROUP_WEAPONS; ++i) format(szQuery, sizeof szQuery, "%s, `Gun%i` = %i, `Cost%i` = %i", szQuery, i+1, arrGroupData[iGroupID][g_iLockerGuns][i], i+1, arrGroupData[iGroupID][g_iLockerCost][i]);
	format(szQuery, sizeof szQuery, "%s WHERE `id` = %i", szQuery, iGroupID+1);
	mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "ii", SENDDATA_THREAD, INVALID_PLAYER_ID);

	for (i = 0; i < MAX_GROUP_LOCKERS; i++)	{
		format(szQuery, sizeof(szQuery), "UPDATE `lockers` SET `LockerX` = '%.2f', `LockerY` = '%.2f', `LockerZ` = '%.2f', `LockerVW` = %d, `LockerShare` = %d WHERE `Id` = %d", arrGroupLockers[iGroupID][i][g_fLockerPos][0], arrGroupLockers[iGroupID][i][g_fLockerPos][1], arrGroupLockers[iGroupID][i][g_fLockerPos][2], arrGroupLockers[iGroupID][i][g_iLockerVW], arrGroupLockers[iGroupID][i][g_iLockerShare], arrGroupLockers[iGroupID][i][g_iLockerSQLId]);
		mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "ii", SENDDATA_THREAD, INVALID_PLAYER_ID);
	}
	return 1;
}

DynVeh_Save(iDvSlotID) {
	if((iDvSlotID > MAX_DYNAMIC_VEHICLES)) // Array bounds check. Use it.
		return 0;

	new
		szQuery[2248],
		i = 0;

	format(szQuery, sizeof szQuery,
		"UPDATE `groupvehs` SET `SpawnedID`= '%d',`gID`= '%d',`gDivID`= '%d', `fID`='%d', `rID`='%d', `vModel`= '%d', \
		`vPlate` = '%s',`vMaxHealth`= '%.2f',`vType`= '%d',`vLoadMax`= '%d',`vCol1`= '%d',`vCol2`= '%d', \
		`vX`= '%.2f',`vY`= '%.2f',`vZ`= '%.2f',`vRotZ`= '%.2f', `vUpkeep` = '%d', `vVW` = '%d', `vDisabled` = '%d', \
		`vInt` = '%d', `vFuel` = '%.5f'"
		, DynVehicleInfo[iDvSlotID][gv_iSpawnedID], DynVehicleInfo[iDvSlotID][gv_igID], DynVehicleInfo[iDvSlotID][gv_igDivID], DynVehicleInfo[iDvSlotID][gv_ifID], DynVehicleInfo[iDvSlotID][gv_irID], DynVehicleInfo[iDvSlotID][gv_iModel],
		g_mysql_ReturnEscaped(DynVehicleInfo[iDvSlotID][gv_iPlate], MainPipeline), DynVehicleInfo[iDvSlotID][gv_fMaxHealth], DynVehicleInfo[iDvSlotID][gv_iType], DynVehicleInfo[iDvSlotID][gv_iLoadMax], DynVehicleInfo[iDvSlotID][gv_iCol1], DynVehicleInfo[iDvSlotID][gv_iCol2],
		DynVehicleInfo[iDvSlotID][gv_fX], DynVehicleInfo[iDvSlotID][gv_fY], DynVehicleInfo[iDvSlotID][gv_fZ], DynVehicleInfo[iDvSlotID][gv_fRotZ], DynVehicleInfo[iDvSlotID][gv_iUpkeep], DynVehicleInfo[iDvSlotID][gv_iVW], DynVehicleInfo[iDvSlotID][gv_iDisabled],
		DynVehicleInfo[iDvSlotID][gv_iInt], DynVehicleInfo[iDvSlotID][gv_fFuel]);

	for(i = 0; i != MAX_DV_OBJECTS; ++i) {
		format(szQuery, sizeof szQuery, "%s, `vAttachedObjectModel%i` = '%d'", szQuery, i+1, DynVehicleInfo[iDvSlotID][gv_iAttachedObjectModel][i]);
		format(szQuery, sizeof szQuery, "%s, `vObjectX%i` = '%.2f'", szQuery, i+1, DynVehicleInfo[iDvSlotID][gv_fObjectX][i]);
		format(szQuery, sizeof szQuery, "%s, `vObjectY%i` = '%.2f'", szQuery, i+1, DynVehicleInfo[iDvSlotID][gv_fObjectY][i]);
		format(szQuery, sizeof szQuery, "%s, `vObjectZ%i` = '%.2f'", szQuery, i+1, DynVehicleInfo[iDvSlotID][gv_fObjectZ][i]);
		format(szQuery, sizeof szQuery, "%s, `vObjectRX%i` = '%.2f'", szQuery, i+1, DynVehicleInfo[iDvSlotID][gv_fObjectRX][i]);
		format(szQuery, sizeof szQuery, "%s, `vObjectRY%i` = '%.2f'", szQuery, i+1, DynVehicleInfo[iDvSlotID][gv_fObjectRY][i]);
		format(szQuery, sizeof szQuery, "%s, `vObjectRZ%i` = '%.2f'", szQuery, i+1, DynVehicleInfo[iDvSlotID][gv_fObjectRZ][i]);
	}

	for(i = 0; i != MAX_DV_MODS; ++i) format(szQuery, sizeof szQuery, "%s, `vMod%d` = %i", szQuery, i, DynVehicleInfo[iDvSlotID][gv_iMod][i]);

	format(szQuery, sizeof szQuery, "%s WHERE `id` = %i", szQuery, iDvSlotID);
	return mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "ii", SENDDATA_THREAD, INVALID_PLAYER_ID);
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
		if(ini_GetInt(fileString, "DEBUG", SQL_DEBUG)) continue;
		if(ini_GetInt(fileString, "DEBUGLOG", SQL_DEBUGLOG)) continue;
	}
	fclose(fileHandle);

	mysql_log(SQL_DEBUG, SQL_DEBUGLOG);
	MainPipeline = mysql_connect(SQL_HOST, SQL_USER, SQL_DB, SQL_PASS);

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
		ShopPipeline = mysql_connect(SQL_SHOST, SQL_SUSER, SQL_SDB, SQL_SPASS);

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
    new rows, fields;
	if(resultid != SENDDATA_THREAD) {
		if(extraid != INVALID_PLAYER_ID) {
			if(g_arrQueryHandle{extraid} != -1 && g_arrQueryHandle{extraid} != handleid) return 0;
		}
		cache_get_data(rows, fields, MainPipeline);
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
						cache_get_field_content(i,  szField, szResult, MainPipeline);
                        AmountSold[z] = strval(szResult);
						//ShopItems[z][sSold] = strval(szResult);


						format(szField, sizeof(szField), "AmountMade%d", z);
						cache_get_field_content(i,  szField, szResult, MainPipeline);
						AmountMade[z] = strval(szResult);
						//ShopItems[z][sMade] = strval(szResult);
						printf("TotalSold%d: %d | AmountMade%d: %d", z, AmountSold[z], z, AmountMade[z]);
					}
					break;
				}
			}
			else
			{
				mysql_function_query(MainPipeline, "INSERT INTO `sales` (`Month`) VALUES (NOW())", false, "OnQueryFinish", "i", SENDDATA_THREAD);
				mysql_function_query(MainPipeline, "SELECT * FROM `sales` WHERE `Month` > NOW() - INTERVAL 1 MONTH", true, "OnQueryFinish", "iii", LOADSALEDATA_THREAD, INVALID_PLAYER_ID, -1);
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
					cache_get_field_content(i,  szField, szResult, MainPipeline);
					ShopItems[z][sItemPrice] = strval(szResult);
					Price[z] = strval(szResult);
					if(ShopItems[z][sItemPrice] == 0) ShopItems[z][sItemPrice] = 99999999;
					printf("Price%d: %d", z, ShopItems[z][sItemPrice]);
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
   				cache_get_field_content(i, "gMOTD", GlobalMOTD, MainPipeline, 128);
				cache_get_field_content(i, "aMOTD", AdminMOTD, MainPipeline, 128);
				cache_get_field_content(i, "vMOTD", VIPMOTD, MainPipeline, 128);
				cache_get_field_content(i, "cMOTD", CAMOTD, MainPipeline, 128);
				cache_get_field_content(i, "pMOTD", pMOTD, MainPipeline, 128);
				cache_get_field_content(i, "ShopTechPay", szResult, MainPipeline); ShopTechPay = floatstr(szResult);
                cache_get_field_content(i, "GiftCode", GiftCode, MainPipeline, 32);
                cache_get_field_content(i, "GiftCodeBypass", szResult, MainPipeline); GiftCodeBypass = strval(szResult);
                cache_get_field_content(i, "SecurityCode", SecurityCode, MainPipeline, 32);
                cache_get_field_content(i, "ShopClosed", szResult, MainPipeline); ShopClosed = strval(szResult);
                cache_get_field_content(i, "RimMod", szResult, MainPipeline); RimMod = strval(szResult);
                cache_get_field_content(i, "CarVoucher", szResult, MainPipeline); CarVoucher = strval(szResult);
				cache_get_field_content(i, "PVIPVoucher", szResult, MainPipeline); PVIPVoucher = strval(szResult);
				cache_get_field_content(i, "GarageVW", szResult, MainPipeline); GarageVW = strval(szResult);
				cache_get_field_content(i, "PumpkinStock", szResult, MainPipeline); PumpkinStock = strval(szResult);
				cache_get_field_content(i, "HalloweenShop", szResult, MainPipeline); HalloweenShop = strval(szResult);
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
					cache_get_field_content(row, "Username", szField, MainPipeline, MAX_PLAYER_NAME);

					if(strcmp(szField, GetPlayerNameExt(extraid), true) != 0)
					{
						return 1;
					}
					cache_get_field_content(row,  "id", szResult, MainPipeline); PlayerInfo[extraid][pId] = strval(szResult);
					cache_get_field_content(row,  "Online", szResult, MainPipeline); PlayerInfo[extraid][pOnline] = strval(szResult);
					cache_get_field_content(row,  "Email", PlayerInfo[extraid][pEmail], MainPipeline, 128);
					cache_get_field_content(row,  "IP", PlayerInfo[extraid][pIP], MainPipeline, 16);
					cache_get_field_content(row,  "SecureIP", PlayerInfo[extraid][pSecureIP], MainPipeline, 16);
					cache_get_field_content(row,  "ConnectedTime", szResult, MainPipeline); PlayerInfo[extraid][pConnectHours] = strval(szResult);
					cache_get_field_content(row,  "BirthDate", PlayerInfo[extraid][pBirthDate], MainPipeline, 11);
					cache_get_field_content(row,  "Sex", szResult, MainPipeline); PlayerInfo[extraid][pSex] = strval(szResult);
					cache_get_field_content(row,  "Band", szResult, MainPipeline); PlayerInfo[extraid][pBanned] = strval(szResult);
					cache_get_field_content(row,  "PermBand", szResult, MainPipeline); PlayerInfo[extraid][pPermaBanned] = strval(szResult);
					cache_get_field_content(row,  "Registered", szResult, MainPipeline); PlayerInfo[extraid][pReg] = strval(szResult);
					cache_get_field_content(row,  "Warnings", szResult, MainPipeline); PlayerInfo[extraid][pWarns] = strval(szResult);
					cache_get_field_content(row,  "Disabled", szResult, MainPipeline); PlayerInfo[extraid][pDisabled] = strval(szResult);
					cache_get_field_content(row,  "Level", szResult, MainPipeline); PlayerInfo[extraid][pLevel] = strval(szResult);
					cache_get_field_content(row,  "AdminLevel", szResult, MainPipeline); PlayerInfo[extraid][pAdmin] = strval(szResult);
					cache_get_field_content(row,  "SeniorModerator", szResult, MainPipeline); PlayerInfo[extraid][pSMod] = strval(szResult);
					cache_get_field_content(row,  "DonateRank", szResult, MainPipeline); PlayerInfo[extraid][pDonateRank] = strval(szResult);
					cache_get_field_content(row,  "Respect", szResult, MainPipeline); PlayerInfo[extraid][pExp] = strval(szResult);
					cache_get_field_content(row,  "Money", szResult, MainPipeline); PlayerInfo[extraid][pCash] = strval(szResult);
					cache_get_field_content(row,  "Bank", szResult, MainPipeline); PlayerInfo[extraid][pAccount] = strval(szResult);
					cache_get_field_content(row,  "pHealth", szResult, MainPipeline); PlayerInfo[extraid][pHealth] = floatstr(szResult);
					cache_get_field_content(row,  "pArmor", szResult, MainPipeline); PlayerInfo[extraid][pArmor] = floatstr(szResult);
					cache_get_field_content(row,  "pSHealth", szResult, MainPipeline); PlayerInfo[extraid][pSHealth] = floatstr(szResult);
					cache_get_field_content(row,  "Int", szResult, MainPipeline); PlayerInfo[extraid][pInt] = strval(szResult);
					cache_get_field_content(row,  "VirtualWorld", szResult, MainPipeline); PlayerInfo[extraid][pVW] = strval(szResult);
					cache_get_field_content(row,  "Model", szResult, MainPipeline); PlayerInfo[extraid][pModel] = strval(szResult);
					cache_get_field_content(row,  "SPos_x", szResult, MainPipeline); PlayerInfo[extraid][pPos_x] = floatstr(szResult);
					cache_get_field_content(row,  "SPos_y", szResult, MainPipeline); PlayerInfo[extraid][pPos_y] = floatstr(szResult);
					cache_get_field_content(row,  "SPos_z", szResult, MainPipeline); PlayerInfo[extraid][pPos_z] = floatstr(szResult);
					cache_get_field_content(row,  "SPos_r", szResult, MainPipeline); PlayerInfo[extraid][pPos_r] = floatstr(szResult);
					cache_get_field_content(row,  "BanAppealer", szResult, MainPipeline); PlayerInfo[extraid][pBanAppealer] = strval(szResult);
					cache_get_field_content(row,  "PR", szResult, MainPipeline); PlayerInfo[extraid][pPR] = strval(szResult);
					cache_get_field_content(row,  "HR", szResult, MainPipeline); PlayerInfo[extraid][pHR] = strval(szResult);
					cache_get_field_content(row,  "AP", szResult, MainPipeline); PlayerInfo[extraid][pAP] = strval(szResult);
					cache_get_field_content(row,  "Security", szResult, MainPipeline); PlayerInfo[extraid][pSecurity] = strval(szResult);
					cache_get_field_content(row,  "ShopTech", szResult, MainPipeline); PlayerInfo[extraid][pShopTech] = strval(szResult);
					cache_get_field_content(row,  "FactionModerator", szResult, MainPipeline); PlayerInfo[extraid][pFactionModerator] = strval(szResult);
					cache_get_field_content(row,  "GangModerator", szResult, MainPipeline); PlayerInfo[extraid][pGangModerator] = strval(szResult);
					cache_get_field_content(row,  "Undercover", szResult, MainPipeline); PlayerInfo[extraid][pUndercover] = strval(szResult);
					cache_get_field_content(row,  "TogReports", szResult, MainPipeline); PlayerInfo[extraid][pTogReports] = strval(szResult);
					cache_get_field_content(row,  "Radio", szResult, MainPipeline); PlayerInfo[extraid][pRadio] = strval(szResult);
					cache_get_field_content(row,  "RadioFreq", szResult, MainPipeline); PlayerInfo[extraid][pRadioFreq] = strval(szResult);
					cache_get_field_content(row,  "UpgradePoints", szResult, MainPipeline); PlayerInfo[extraid][gPupgrade] = strval(szResult);
					cache_get_field_content(row,  "Origin", szResult, MainPipeline); PlayerInfo[extraid][pOrigin] = strval(szResult);
					cache_get_field_content(row,  "Muted", szResult, MainPipeline); PlayerInfo[extraid][pMuted] = strval(szResult);
					cache_get_field_content(row,  "Crimes", szResult, MainPipeline); PlayerInfo[extraid][pCrimes] = strval(szResult);
					cache_get_field_content(row,  "Accent", szResult, MainPipeline); PlayerInfo[extraid][pAccent] = strval(szResult);
					cache_get_field_content(row,  "CHits", szResult, MainPipeline); PlayerInfo[extraid][pCHits] = strval(szResult);
					cache_get_field_content(row,  "FHits", szResult, MainPipeline); PlayerInfo[extraid][pFHits] = strval(szResult);
					cache_get_field_content(row,  "Arrested", szResult, MainPipeline); PlayerInfo[extraid][pArrested] = strval(szResult);
					cache_get_field_content(row,  "Phonebook", szResult, MainPipeline); PlayerInfo[extraid][pPhoneBook] = strval(szResult);
					cache_get_field_content(row,  "LottoNr", szResult, MainPipeline); PlayerInfo[extraid][pLottoNr] = strval(szResult);
					cache_get_field_content(row,  "Fishes", szResult, MainPipeline); PlayerInfo[extraid][pFishes] = strval(szResult);
					cache_get_field_content(row,  "BiggestFish", szResult, MainPipeline); PlayerInfo[extraid][pBiggestFish] = strval(szResult);
					cache_get_field_content(row,  "Job", szResult, MainPipeline); PlayerInfo[extraid][pJob] = strval(szResult);
					cache_get_field_content(row,  "Job2", szResult, MainPipeline); PlayerInfo[extraid][pJob2] = strval(szResult);
					cache_get_field_content(row,  "Job3", szResult, MainPipeline); PlayerInfo[extraid][pJob3] = strval(szResult);
					cache_get_field_content(row,  "Paycheck", szResult, MainPipeline); PlayerInfo[extraid][pPayCheck] = strval(szResult);
					cache_get_field_content(row,  "HeadValue", szResult, MainPipeline); PlayerInfo[extraid][pHeadValue] = strval(szResult);
					cache_get_field_content(row,  "JailTime", szResult, MainPipeline); PlayerInfo[extraid][pJailTime] = strval(szResult);
					cache_get_field_content(row,  "WRestricted", szResult, MainPipeline); PlayerInfo[extraid][pWRestricted] = strval(szResult);
					cache_get_field_content(row,  "Materials", szResult, MainPipeline); PlayerInfo[extraid][pMats] = strval(szResult);
					cache_get_field_content(row,  "Crates", szResult, MainPipeline); PlayerInfo[extraid][pCrates] = strval(szResult);
					cache_get_field_content(row,  "Pot", szResult, MainPipeline); PlayerInfo[extraid][pPot] = strval(szResult);
					cache_get_field_content(row,  "Crack", szResult, MainPipeline); PlayerInfo[extraid][pCrack] = strval(szResult);
					cache_get_field_content(row,  "Nation", szResult, MainPipeline); PlayerInfo[extraid][pNation] = strval(szResult);
					cache_get_field_content(row,  "Leader", szResult, MainPipeline); PlayerInfo[extraid][pLeader] = strval(szResult);
					cache_get_field_content(row,  "Member", szResult, MainPipeline); PlayerInfo[extraid][pMember] = strval(szResult);
					cache_get_field_content(row,  "Division", szResult, MainPipeline); PlayerInfo[extraid][pDivision] = strval(szResult);
					cache_get_field_content(row,  "FMember", szResult, MainPipeline); PlayerInfo[extraid][pFMember] = strval(szResult);
					cache_get_field_content(row,  "Rank", szResult, MainPipeline); PlayerInfo[extraid][pRank] = strval(szResult);
					cache_get_field_content(row,  "DetSkill", szResult, MainPipeline); PlayerInfo[extraid][pDetSkill] = strval(szResult);
					cache_get_field_content(row,  "SexSkill", szResult, MainPipeline); PlayerInfo[extraid][pSexSkill] = strval(szResult);
					cache_get_field_content(row,  "BoxSkill", szResult, MainPipeline); PlayerInfo[extraid][pBoxSkill] = strval(szResult);
					cache_get_field_content(row,  "LawSkill", szResult, MainPipeline); PlayerInfo[extraid][pLawSkill] = strval(szResult);
					cache_get_field_content(row,  "MechSkill", szResult, MainPipeline); PlayerInfo[extraid][pMechSkill] = strval(szResult);
					cache_get_field_content(row,  "TruckSkill", szResult, MainPipeline); PlayerInfo[extraid][pTruckSkill] = strval(szResult);
					cache_get_field_content(row,  "DrugsSkill", szResult, MainPipeline); PlayerInfo[extraid][pDrugsSkill] = strval(szResult);
					cache_get_field_content(row,  "ArmsSkill", szResult, MainPipeline); PlayerInfo[extraid][pArmsSkill] = strval(szResult);
					cache_get_field_content(row,  "SmugglerSkill", szResult, MainPipeline); PlayerInfo[extraid][pSmugSkill] = strval(szResult);
					cache_get_field_content(row,  "FishSkill", szResult, MainPipeline); PlayerInfo[extraid][pFishSkill] = strval(szResult);
					cache_get_field_content(row,  "FightingStyle", szResult, MainPipeline); PlayerInfo[extraid][pFightStyle] = strval(szResult);
					cache_get_field_content(row,  "PhoneNr", szResult, MainPipeline); PlayerInfo[extraid][pPnumber] = strval(szResult);
					cache_get_field_content(row,  "Apartment", szResult, MainPipeline); PlayerInfo[extraid][pPhousekey] = strval(szResult);
					cache_get_field_content(row,  "Apartment2", szResult, MainPipeline); PlayerInfo[extraid][pPhousekey2] = strval(szResult);
					cache_get_field_content(row,  "Apartment3", szResult, MainPipeline); PlayerInfo[extraid][pPhousekey3] = strval(szResult);
					cache_get_field_content(row,  "Renting", szResult, MainPipeline); PlayerInfo[extraid][pRenting] = strval(szResult);
					cache_get_field_content(row,  "CarLic", szResult, MainPipeline); PlayerInfo[extraid][pCarLic] = strval(szResult);
					cache_get_field_content(row,  "FlyLic", szResult, MainPipeline); PlayerInfo[extraid][pFlyLic] = strval(szResult);
					cache_get_field_content(row,  "BoatLic", szResult, MainPipeline); PlayerInfo[extraid][pBoatLic] = strval(szResult);
					cache_get_field_content(row,  "FishLic", szResult, MainPipeline); PlayerInfo[extraid][pFishLic] = strval(szResult);
					cache_get_field_content(row,  "CheckCash", szResult, MainPipeline); PlayerInfo[extraid][pCheckCash] = strval(szResult);
					cache_get_field_content(row,  "Checks", szResult, MainPipeline); PlayerInfo[extraid][pChecks] = strval(szResult);
					cache_get_field_content(row,  "GunLic", szResult, MainPipeline); PlayerInfo[extraid][pGunLic] = strval(szResult);

					for(new i = 0; i < 12; i++)
					{
						format(szField, sizeof(szField), "Gun%d", i);
						cache_get_field_content(row,  szField, szResult, MainPipeline);
						PlayerInfo[extraid][pGuns][i] = strval(szResult);
					}

					cache_get_field_content(row,  "DrugsTime", szResult, MainPipeline); PlayerInfo[extraid][pDrugsTime] = strval(szResult);
					cache_get_field_content(row,  "LawyerTime", szResult, MainPipeline); PlayerInfo[extraid][pLawyerTime] = strval(szResult);
					cache_get_field_content(row,  "LawyerFreeTime", szResult, MainPipeline); PlayerInfo[extraid][pLawyerFreeTime] = strval(szResult);
					cache_get_field_content(row,  "MechTime", szResult, MainPipeline); PlayerInfo[extraid][pMechTime] = strval(szResult);
					cache_get_field_content(row,  "SexTime", szResult, MainPipeline); PlayerInfo[extraid][pSexTime] = strval(szResult);
					cache_get_field_content(row,  "PayDay", szResult, MainPipeline); PlayerInfo[extraid][pConnectSeconds] = strval(szResult);
					cache_get_field_content(row,  "PayDayHad", szResult, MainPipeline); PlayerInfo[extraid][pPayDayHad] = strval(szResult);
					cache_get_field_content(row,  "CDPlayer", szResult, MainPipeline); PlayerInfo[extraid][pCDPlayer] = strval(szResult);
					cache_get_field_content(row,  "Dice", szResult, MainPipeline); PlayerInfo[extraid][pDice] = strval(szResult);
					cache_get_field_content(row,  "Spraycan", szResult, MainPipeline); PlayerInfo[extraid][pSpraycan] = strval(szResult);
					cache_get_field_content(row,  "Rope", szResult, MainPipeline); PlayerInfo[extraid][pRope] = strval(szResult);
					cache_get_field_content(row,  "Cigars", szResult, MainPipeline); PlayerInfo[extraid][pCigar] = strval(szResult);
					cache_get_field_content(row,  "Sprunk", szResult, MainPipeline); PlayerInfo[extraid][pSprunk] = strval(szResult);
					cache_get_field_content(row,  "Bombs", szResult, MainPipeline); PlayerInfo[extraid][pBombs] = strval(szResult);
					cache_get_field_content(row,  "Wins", szResult, MainPipeline); PlayerInfo[extraid][pWins] = strval(szResult);
					cache_get_field_content(row,  "Loses", szResult, MainPipeline); PlayerInfo[extraid][pLoses] = strval(szResult);
					cache_get_field_content(row,  "Tutorial", szResult, MainPipeline); PlayerInfo[extraid][pTut] = strval(szResult);
					cache_get_field_content(row,  "OnDuty", szResult, MainPipeline); PlayerInfo[extraid][pDuty] = strval(szResult);
					cache_get_field_content(row,  "Hospital", szResult, MainPipeline); PlayerInfo[extraid][pHospital] = strval(szResult);
					cache_get_field_content(row,  "MarriedID", szResult, MainPipeline); PlayerInfo[extraid][pMarriedID] = strval(szResult);
					cache_get_field_content(row,  "ContractBy", PlayerInfo[extraid][pContractBy], MainPipeline, MAX_PLAYER_NAME);
					cache_get_field_content(row,  "ContractDetail", PlayerInfo[extraid][pContractDetail], MainPipeline, 64);
					cache_get_field_content(row,  "WantedLevel", szResult, MainPipeline); PlayerInfo[extraid][pWantedLevel] = strval(szResult);
					cache_get_field_content(row,  "Insurance", szResult, MainPipeline); PlayerInfo[extraid][pInsurance] = strval(szResult);
					cache_get_field_content(row,  "911Muted", szResult, MainPipeline); PlayerInfo[extraid][p911Muted] = strval(szResult);
					cache_get_field_content(row,  "NewMuted", szResult, MainPipeline); PlayerInfo[extraid][pNMute] = strval(szResult);
					cache_get_field_content(row,  "NewMutedTotal", szResult, MainPipeline); PlayerInfo[extraid][pNMuteTotal] = strval(szResult);
					cache_get_field_content(row,  "AdMuted", szResult, MainPipeline); PlayerInfo[extraid][pADMute] = strval(szResult);
					cache_get_field_content(row,  "AdMutedTotal", szResult, MainPipeline); PlayerInfo[extraid][pADMuteTotal] = strval(szResult);
					cache_get_field_content(row,  "HelpMute", szResult, MainPipeline); PlayerInfo[extraid][pHelpMute] = strval(szResult);
					cache_get_field_content(row,  "Helper", szResult, MainPipeline); PlayerInfo[extraid][pHelper] = strval(szResult);
					cache_get_field_content(row,  "ReportMuted", szResult, MainPipeline); PlayerInfo[extraid][pRMuted] = strval(szResult);
					cache_get_field_content(row,  "ReportMutedTotal", szResult, MainPipeline); PlayerInfo[extraid][pRMutedTotal] = strval(szResult);
					cache_get_field_content(row,  "ReportMutedTime", szResult, MainPipeline); PlayerInfo[extraid][pRMutedTime] = strval(szResult);
					cache_get_field_content(row,  "DMRMuted", szResult, MainPipeline); PlayerInfo[extraid][pDMRMuted] = strval(szResult);
					cache_get_field_content(row,  "VIPMuted", szResult, MainPipeline); PlayerInfo[extraid][pVMuted] = strval(szResult);
					cache_get_field_content(row,  "VIPMutedTime", szResult, MainPipeline); PlayerInfo[extraid][pVMutedTime] = strval(szResult);
					cache_get_field_content(row,  "GiftTime", szResult, MainPipeline); PlayerInfo[extraid][pGiftTime] = strval(szResult);
					cache_get_field_content(row,  "AdvisorDutyHours", szResult, MainPipeline); PlayerInfo[extraid][pDutyHours] = strval(szResult);
					cache_get_field_content(row,  "AcceptedHelp", szResult, MainPipeline); PlayerInfo[extraid][pAcceptedHelp] = strval(szResult);
					cache_get_field_content(row,  "AcceptReport", szResult, MainPipeline); PlayerInfo[extraid][pAcceptReport] = strval(szResult);
					cache_get_field_content(row,  "ShopTechOrders", szResult, MainPipeline); PlayerInfo[extraid][pShopTechOrders] = strval(szResult);
					cache_get_field_content(row,  "TrashReport", szResult, MainPipeline); PlayerInfo[extraid][pTrashReport] = strval(szResult);
					cache_get_field_content(row,  "GangWarn", szResult, MainPipeline); PlayerInfo[extraid][pGangWarn] = strval(szResult);
					cache_get_field_content(row,  "CSFBanned", szResult, MainPipeline); PlayerInfo[extraid][pCSFBanned] = strval(szResult);
					cache_get_field_content(row,  "VIPInviteDay", szResult, MainPipeline); PlayerInfo[extraid][pVIPInviteDay] = strval(szResult);
					cache_get_field_content(row,  "TempVIP", szResult, MainPipeline); PlayerInfo[extraid][pTempVIP] = strval(szResult);
					cache_get_field_content(row,  "BuddyInvite", szResult, MainPipeline); PlayerInfo[extraid][pBuddyInvited] = strval(szResult);
					cache_get_field_content(row,  "Tokens", szResult, MainPipeline); PlayerInfo[extraid][pTokens] = strval(szResult);
					cache_get_field_content(row,  "PTokens", szResult, MainPipeline); PlayerInfo[extraid][pPaintTokens] = strval(szResult);
					cache_get_field_content(row,  "TriageTime", szResult, MainPipeline); PlayerInfo[extraid][pTriageTime] = strval(szResult);
					cache_get_field_content(row,  "PrisonedBy", PlayerInfo[extraid][pPrisonedBy], MainPipeline, MAX_PLAYER_NAME);
					cache_get_field_content(row,  "PrisonReason", PlayerInfo[extraid][pPrisonReason], MainPipeline, 128);
					cache_get_field_content(row,  "TaxiLicense", szResult, MainPipeline); PlayerInfo[extraid][pTaxiLicense] = strval(szResult);
					cache_get_field_content(row,  "TicketTime", szResult, MainPipeline); PlayerInfo[extraid][pTicketTime] = strval(szResult);
					cache_get_field_content(row,  "Screwdriver", szResult, MainPipeline); PlayerInfo[extraid][pScrewdriver] = strval(szResult);
					cache_get_field_content(row,  "Smslog", szResult, MainPipeline); PlayerInfo[extraid][pSmslog] = strval(szResult);
					cache_get_field_content(row,  "Wristwatch", szResult, MainPipeline); PlayerInfo[extraid][pWristwatch] = strval(szResult);
					cache_get_field_content(row,  "Surveillance", szResult, MainPipeline); PlayerInfo[extraid][pSurveillance] = strval(szResult);
					cache_get_field_content(row,  "Tire", szResult, MainPipeline); PlayerInfo[extraid][pTire] = strval(szResult);
					cache_get_field_content(row,  "Firstaid", szResult, MainPipeline); PlayerInfo[extraid][pFirstaid] = strval(szResult);
					cache_get_field_content(row,  "Rccam", szResult, MainPipeline); PlayerInfo[extraid][pRccam] = strval(szResult);
					cache_get_field_content(row,  "Receiver", szResult, MainPipeline); PlayerInfo[extraid][pReceiver] = strval(szResult);
					cache_get_field_content(row,  "GPS", szResult, MainPipeline); PlayerInfo[extraid][pGPS] = strval(szResult);
					cache_get_field_content(row,  "Sweep", szResult, MainPipeline); PlayerInfo[extraid][pSweep] = strval(szResult);
					cache_get_field_content(row,  "SweepLeft", szResult, MainPipeline); PlayerInfo[extraid][pSweepLeft] = strval(szResult);
					cache_get_field_content(row,  "Bugged", szResult, MainPipeline); PlayerInfo[extraid][pBugged] = strval(szResult);
					cache_get_field_content(row,  "pWExists", szResult, MainPipeline); PlayerInfo[extraid][pWeedObject] = strval(szResult);
					cache_get_field_content(row,  "pWSeeds", szResult, MainPipeline); PlayerInfo[extraid][pWSeeds] = strval(szResult);
					cache_get_field_content(row,  "Warrants", PlayerInfo[extraid][pWarrant], MainPipeline, 128);
					cache_get_field_content(row,  "JudgeJailTime", szResult, MainPipeline); PlayerInfo[extraid][pJudgeJailTime] = strval(szResult);
					cache_get_field_content(row,  "JudgeJailType", szResult, MainPipeline); PlayerInfo[extraid][pJudgeJailType] = strval(szResult);
					cache_get_field_content(row,  "ProbationTime", szResult, MainPipeline); PlayerInfo[extraid][pProbationTime] = strval(szResult);
					cache_get_field_content(row,  "DMKills", szResult, MainPipeline); PlayerInfo[extraid][pDMKills] = strval(szResult);
					cache_get_field_content(row,  "Order", szResult, MainPipeline); PlayerInfo[extraid][pOrder] = strval(szResult);
					cache_get_field_content(row,  "OrderConfirmed", szResult, MainPipeline); PlayerInfo[extraid][pOrderConfirmed] = strval(szResult);
					cache_get_field_content(row,  "CallsAccepted", szResult, MainPipeline); PlayerInfo[extraid][pCallsAccepted] = strval(szResult);
					cache_get_field_content(row,  "PatientsDelivered", szResult, MainPipeline); PlayerInfo[extraid][pPatientsDelivered] = strval(szResult);
					cache_get_field_content(row,  "LiveBanned", szResult, MainPipeline); PlayerInfo[extraid][pLiveBanned] = strval(szResult);
					cache_get_field_content(row,  "FreezeBank", szResult, MainPipeline); PlayerInfo[extraid][pFreezeBank] = strval(szResult);
					cache_get_field_content(row,  "FreezeHouse", szResult, MainPipeline); PlayerInfo[extraid][pFreezeHouse] = strval(szResult);
					cache_get_field_content(row,  "FreezeCar", szResult, MainPipeline); PlayerInfo[extraid][pFreezeCar] = strval(szResult);
					cache_get_field_content(row,  "Firework", szResult, MainPipeline); PlayerInfo[extraid][pFirework] = strval(szResult);
					cache_get_field_content(row,  "Boombox", szResult, MainPipeline); PlayerInfo[extraid][pBoombox] = strval(szResult);
					cache_get_field_content(row,  "Hydration", szResult, MainPipeline); PlayerInfo[extraid][pHydration] = strval(szResult);
					cache_get_field_content(row,  "Speedo", szResult, MainPipeline); PlayerInfo[extraid][pSpeedo] = strval(szResult);
					cache_get_field_content(row,  "DoubleEXP", szResult, MainPipeline); PlayerInfo[extraid][pDoubleEXP] = strval(szResult);
					cache_get_field_content(row,  "EXPToken", szResult, MainPipeline); PlayerInfo[extraid][pEXPToken] = strval(szResult);
					cache_get_field_content(row,  "RacePlayerLaps", szResult, MainPipeline); PlayerInfo[extraid][pRacePlayerLaps] = strval(szResult);
					cache_get_field_content(row,  "Ringtone", szResult, MainPipeline); PlayerInfo[extraid][pRingtone] = strval(szResult);
					cache_get_field_content(row,  "VIPM", szResult, MainPipeline); PlayerInfo[extraid][pVIPM] = strval(szResult);
					cache_get_field_content(row,  "VIPMO", szResult, MainPipeline); PlayerInfo[extraid][pVIPMO] = strval(szResult);
					cache_get_field_content(row,  "VIPExpire", szResult, MainPipeline); PlayerInfo[extraid][pVIPExpire] = strval(szResult);
					cache_get_field_content(row,  "GVip", szResult, MainPipeline); PlayerInfo[extraid][pGVip] = strval(szResult);
					cache_get_field_content(row,  "Watchdog", szResult, MainPipeline); PlayerInfo[extraid][pWatchdog] = strval(szResult);
					cache_get_field_content(row,  "VIPSold", szResult, MainPipeline); PlayerInfo[extraid][pVIPSold] = strval(szResult);
					cache_get_field_content(row,  "GoldBoxTokens", szResult, MainPipeline); PlayerInfo[extraid][pGoldBoxTokens] = strval(szResult);
					cache_get_field_content(row,  "DrawChance", szResult, MainPipeline); PlayerInfo[extraid][pRewardDrawChance] = strval(szResult);
					cache_get_field_content(row,  "RewardHours", szResult, MainPipeline); PlayerInfo[extraid][pRewardHours] = floatstr(szResult);
					cache_get_field_content(row,  "CarsRestricted", szResult, MainPipeline); PlayerInfo[extraid][pRVehRestricted] = strval(szResult);
					cache_get_field_content(row,  "LastCarWarning", szResult, MainPipeline); PlayerInfo[extraid][pLastRVehWarn] = strval(szResult);
					cache_get_field_content(row,  "CarWarns", szResult, MainPipeline); PlayerInfo[extraid][pRVehWarns] = strval(szResult);
					cache_get_field_content(row,  "Flagged", szResult, MainPipeline); PlayerInfo[extraid][pFlagged] = strval(szResult);
					cache_get_field_content(row,  "Paper", szResult, MainPipeline); PlayerInfo[extraid][pPaper] = strval(szResult);
					cache_get_field_content(row,  "MailEnabled", szResult, MainPipeline); PlayerInfo[extraid][pMailEnabled] = strval(szResult);
					cache_get_field_content(row,  "Mailbox", szResult, MainPipeline); PlayerInfo[extraid][pMailbox] = strval(szResult);
					cache_get_field_content(row,  "Business", szResult, MainPipeline); PlayerInfo[extraid][pBusiness] = strval(szResult);
					cache_get_field_content(row,  "BusinessRank", szResult, MainPipeline); PlayerInfo[extraid][pBusinessRank] = strval(szResult);
					cache_get_field_content(row,  "TreasureSkill", szResult, MainPipeline); PlayerInfo[extraid][pTreasureSkill] = strval(szResult);
					cache_get_field_content(row,  "MetalDetector", szResult, MainPipeline); PlayerInfo[extraid][pMetalDetector] = strval(szResult);
					cache_get_field_content(row,  "HelpedBefore", szResult, MainPipeline); PlayerInfo[extraid][pHelpedBefore] = strval(szResult);
					cache_get_field_content(row,  "Trickortreat", szResult, MainPipeline); PlayerInfo[extraid][pTrickortreat] = strval(szResult);
					cache_get_field_content(row,  "LastCharmReceived", szResult, MainPipeline); PlayerInfo[extraid][pLastCharmReceived] = strval(szResult);
					cache_get_field_content(row,  "RHMutes", szResult, MainPipeline); PlayerInfo[extraid][pRHMutes] = strval(szResult);
					cache_get_field_content(row,  "RHMuteTime", szResult, MainPipeline); PlayerInfo[extraid][pRHMuteTime] = strval(szResult);
					cache_get_field_content(row,  "GiftCode", szResult, MainPipeline); PlayerInfo[extraid][pGiftCode] = strval(szResult);
					cache_get_field_content(row,  "Table", szResult, MainPipeline); PlayerInfo[extraid][pTable] = strval(szResult);
					cache_get_field_content(row,  "OpiumSeeds", szResult, MainPipeline); PlayerInfo[extraid][pOpiumSeeds] = strval(szResult);
					cache_get_field_content(row,  "RawOpium", szResult, MainPipeline); PlayerInfo[extraid][pRawOpium] = strval(szResult);
					cache_get_field_content(row,  "Heroin", szResult, MainPipeline); PlayerInfo[extraid][pHeroin] = strval(szResult);
					cache_get_field_content(row,  "Syringe", szResult, MainPipeline); PlayerInfo[extraid][pSyringes] = strval(szResult);
					cache_get_field_content(row,  "Skins", szResult, MainPipeline); PlayerInfo[extraid][pSkins] = strval(szResult);
					cache_get_field_content(row,  "Hunger", szResult, MainPipeline); PlayerInfo[extraid][pHunger] = strval(szResult);
					cache_get_field_content(row,  "HungerTimer", szResult, MainPipeline); PlayerInfo[extraid][pHungerTimer] = strval(szResult);
					cache_get_field_content(row,  "HungerDeathTimer", szResult, MainPipeline); PlayerInfo[extraid][pHungerDeathTimer] = strval(szResult);
					cache_get_field_content(row,  "Fitness", szResult, MainPipeline); PlayerInfo[extraid][pFitness] = strval(szResult);
					cache_get_field_content(row,  "ForcePasswordChange", szResult, MainPipeline); PlayerInfo[extraid][pForcePasswordChange] = strval(szResult);
					cache_get_field_content(row,  "Credits", szResult, MainPipeline); PlayerInfo[extraid][pCredits] = strval(szResult);
					cache_get_field_content(row,  "HealthCare", szResult, MainPipeline); PlayerInfo[extraid][pHealthCare] = strval(szResult);
					cache_get_field_content(row,  "TotalCredits", szResult, MainPipeline); PlayerInfo[extraid][pTotalCredits] = strval(szResult);
					cache_get_field_content(row,  "ReceivedCredits", szResult, MainPipeline); PlayerInfo[extraid][pReceivedCredits] = strval(szResult);
					cache_get_field_content(row,  "RimMod", szResult, MainPipeline); PlayerInfo[extraid][pRimMod] = strval(szResult);
					cache_get_field_content(row,  "Tazer", szResult, MainPipeline); PlayerInfo[extraid][pHasTazer] = strval(szResult);
					cache_get_field_content(row,  "Cuff", szResult, MainPipeline); PlayerInfo[extraid][pHasCuff] = strval(szResult);
					cache_get_field_content(row,  "CarVoucher", szResult, MainPipeline); PlayerInfo[extraid][pCarVoucher] = strval(szResult);
					cache_get_field_content(row,  "ReferredBy", PlayerInfo[extraid][pReferredBy], MainPipeline, MAX_PLAYER_NAME);
					cache_get_field_content(row,  "PendingRefReward", szResult, MainPipeline); PlayerInfo[extraid][pPendingRefReward] = strval(szResult);
					cache_get_field_content(row,  "Refers", szResult, MainPipeline); PlayerInfo[extraid][pRefers] = strval(szResult);
					cache_get_field_content(row,  "Famed", szResult, MainPipeline); PlayerInfo[extraid][pFamed] = strval(szResult);
					cache_get_field_content(row,  "FamedMuted", szResult, MainPipeline); PlayerInfo[extraid][pFMuted] = strval(szResult);
					cache_get_field_content(row,  "DefendTime", szResult, MainPipeline); PlayerInfo[extraid][pDefendTime] = strval(szResult);
					cache_get_field_content(row,  "VehicleSlot", szResult, MainPipeline); PlayerInfo[extraid][pVehicleSlot] = strval(szResult);
					cache_get_field_content(row,  "PVIPVoucher", szResult, MainPipeline); PlayerInfo[extraid][pPVIPVoucher] = strval(szResult);
					cache_get_field_content(row,  "ToySlot", szResult, MainPipeline); PlayerInfo[extraid][pToySlot] = strval(szResult);
					cache_get_field_content(row,  "RFLTeam", szResult, MainPipeline); PlayerInfo[extraid][pRFLTeam] = strval(szResult);
					cache_get_field_content(row,  "RFLTeamL", szResult, MainPipeline); PlayerInfo[extraid][pRFLTeamL] = strval(szResult);
					cache_get_field_content(row,  "VehVoucher", szResult, MainPipeline); PlayerInfo[extraid][pVehVoucher] = strval(szResult);
					cache_get_field_content(row,  "SVIPVoucher", szResult, MainPipeline); PlayerInfo[extraid][pSVIPVoucher] = strval(szResult);
					cache_get_field_content(row,  "GVIPVoucher", szResult, MainPipeline); PlayerInfo[extraid][pGVIPVoucher] = strval(szResult);
					cache_get_field_content(row,  "GiftVoucher", szResult, MainPipeline); PlayerInfo[extraid][pGiftVoucher] = strval(szResult);
					cache_get_field_content(row,  "FallIntoFun", szResult, MainPipeline); PlayerInfo[extraid][pFallIntoFun] = strval(szResult);
					cache_get_field_content(row,  "HungerVoucher", szResult, MainPipeline); PlayerInfo[extraid][pHungerVoucher] = strval(szResult);
					cache_get_field_content(row,  "BoughtCure", szResult, MainPipeline); PlayerInfo[extraid][pBoughtCure] = strval(szResult);
					cache_get_field_content(row,  "Vials", szResult, MainPipeline); PlayerInfo[extraid][pVials] = strval(szResult);
					cache_get_field_content(row,  "AdvertVoucher", szResult, MainPipeline); PlayerInfo[extraid][pAdvertVoucher] = strval(szResult);
					cache_get_field_content(row,  "ShopCounter", szResult, MainPipeline); PlayerInfo[extraid][pShopCounter] = strval(szResult);
					cache_get_field_content(row,  "ShopNotice", szResult, MainPipeline); PlayerInfo[extraid][pShopNotice] = strval(szResult);
					cache_get_field_content(row,  "SVIPExVoucher", szResult, MainPipeline); PlayerInfo[extraid][pSVIPExVoucher] = strval(szResult);
					cache_get_field_content(row,  "GVIPExVoucher", szResult, MainPipeline); PlayerInfo[extraid][pGVIPExVoucher] = strval(szResult);		
					cache_get_field_content(row,  "VIPSellable", szResult, MainPipeline); PlayerInfo[extraid][pVIPSellable] = strval(szResult);	
					cache_get_field_content(row,  "ReceivedPrize", szResult, MainPipeline); PlayerInfo[extraid][pReceivedPrize] = strval(szResult);
					cache_get_field_content(row,  "VIPSpawn", szResult, MainPipeline); PlayerInfo[extraid][pVIPSpawn] = strval(szResult);
					cache_get_field_content(row,  "FreeAdsDay", szResult, MainPipeline); PlayerInfo[extraid][pFreeAdsDay] = strval(szResult);
					cache_get_field_content(row,  "FreeAdsLeft", szResult, MainPipeline); PlayerInfo[extraid][pFreeAdsLeft] = strval(szResult);
					cache_get_field_content(row,  "BuddyInvites", szResult, MainPipeline); PlayerInfo[extraid][pBuddyInvites] = strval(szResult);
					cache_get_field_content(row,  "ReceivedBGift", szResult, MainPipeline); PlayerInfo[extraid][pReceivedBGift] = strval(szResult);
					cache_get_field_content(row,  "pVIPJob", szResult, MainPipeline); PlayerInfo[extraid][pVIPJob] = strval(szResult);	
					cache_get_field_content(row,  "LastBirthday", szResult, MainPipeline); PlayerInfo[extraid][pLastBirthday] = strval(szResult);
					cache_get_field_content(row,  "AccountRestricted", szResult, MainPipeline); PlayerInfo[extraid][pAccountRestricted] = strval(szResult);
					cache_get_field_content(row,  "Watchlist", szResult, MainPipeline); PlayerInfo[extraid][pWatchlist] = strval(szResult);
					cache_get_field_content(row,  "WatchlistTime", szResult, MainPipeline); PlayerInfo[extraid][pWatchlistTime] = strval(szResult);
					cache_get_field_content(row,  "Backpack", szResult, MainPipeline); PlayerInfo[extraid][pBackpack] = strval(szResult);
					cache_get_field_content(row,  "BEquipped", szResult, MainPipeline); PlayerInfo[extraid][pBEquipped] = strval(szResult);
					cache_get_field_content(row,  "BStoredH", szResult, MainPipeline); PlayerInfo[extraid][pBStoredH] = strval(szResult);
					cache_get_field_content(row,  "BStoredV", szResult, MainPipeline); PlayerInfo[extraid][pBStoredV] = strval(szResult);
					cache_get_field_content(row,  "BRTimeout", szResult, MainPipeline); PlayerInfo[extraid][pBugReportTimeout] = strval(szResult);
					cache_get_field_content(row,  "NewbieTogged", szResult, MainPipeline); PlayerInfo[extraid][pNewbieTogged] = strval(szResult);
					cache_get_field_content(row,  "VIPTogged", szResult, MainPipeline); PlayerInfo[extraid][pVIPTogged] = strval(szResult);
					cache_get_field_content(row,  "FamedTogged", szResult, MainPipeline); PlayerInfo[extraid][pFamedTogged] = strval(szResult);
					for(new i = 0; i < 10; i++)
					{
						format(szField, sizeof(szField), "BItem%d", i);
						cache_get_field_content(row,  szField, szResult, MainPipeline);
						PlayerInfo[extraid][pBItems][i] = strval(szResult);
					}
					cache_get_field_content(row,  "ToolBox", szResult, MainPipeline); PlayerInfo[extraid][pToolBox] = strval(szResult);
					cache_get_field_content(row,  "CrowBar", szResult, MainPipeline); PlayerInfo[extraid][pCrowBar] = strval(szResult);
					cache_get_field_content(row,  "CarLockPickSkill", szResult, MainPipeline); PlayerInfo[extraid][pCarLockPickSkill] = strval(szResult);
					cache_get_field_content(row,  "LockPickVehCount", szResult, MainPipeline); PlayerInfo[extraid][pLockPickVehCount] = strval(szResult);
					cache_get_field_content(row,  "LockPickTime", szResult, MainPipeline); PlayerInfo[extraid][pLockPickTime] = strval(szResult);
					
					GetPartnerName(extraid);
					IsEmailPending(extraid, PlayerInfo[extraid][pId], PlayerInfo[extraid][pEmail]);

					if(PlayerInfo[extraid][pCredits] > 0)
					{
						new szLog[128];
						format(szLog, sizeof(szLog), "[LOGIN] [User: %s(%i)] [IP: %s] [Credits: %s]", GetPlayerNameEx(extraid), PlayerInfo[extraid][pId], GetPlayerIpEx(extraid), number_format(PlayerInfo[extraid][pCredits]));
						Log("logs/logincredits.log", szLog), print(szLog);
					}

					g_mysql_LoadPVehicles(extraid);
					LoadPlayerNonRPPoints(extraid);
					g_mysql_LoadPlayerToys(extraid);
				
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

				//foreach(extraid: Player) if(gPlayerLogged{extraid})
				for(extraid = 0; extraid < MAX_PLAYERS; ++extraid) if(gPlayerLogged{extraid}) {
					SetPVarInt(extraid, "RestartKick", 1);
					return OnPlayerStatsUpdate(extraid);
				}
				ABroadCast(COLOR_YELLOW, "{AA3333}Maintenance{FFFF00}: Account saving finished!", 1);
				//g_mysql_DumpAccounts();

				SetTimer("FinishMaintenance", 1500, false);
			}
			if(GetPVarType(extraid, "AccountSaving") && (GetPVarInt(extraid, "AccountSaved") == 0)) {
				SetPVarInt(extraid, "AccountSaved", 1);
				//foreach(extraid: Player)
				for(extraid = 0; extraid < MAX_PLAYERS; ++extraid)
				{
					if(gPlayerLogged{extraid} && (GetPVarInt(extraid, "AccountSaved") == 0))
					{
						SetPVarInt(extraid, "AccountSaving", 1);
						return OnPlayerStatsUpdate(extraid);
					}
				}
				ABroadCast(COLOR_YELLOW, "{AA3333}Maintenance{FFFF00}: Account saving finished!", 1);
				print("Account Saving Complete");
				//foreach(new i: Player)
				for(new i = 0; i < MAX_PLAYERS; ++i)
				{
					if(IsPlayerConnected(i))
					{
						DeletePVar(i, "AccountSaved");
						DeletePVar(i, "AccountSaving");
					}	
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
				cache_get_field_content(i, "Username", name, MainPipeline, MAX_PLAYER_NAME);
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
				new
					szPass[129],
					szResult[129],
					szBuffer[129];

				cache_get_field_content(i, "Username", szResult, MainPipeline, MAX_PLAYER_NAME);
				if(strcmp(szResult, GetPlayerNameExt(extraid), true) != 0)
				{
					//g_mysql_AccountAuthCheck(extraid);
					return 1;
				}
				cache_get_field_content(i, "Key", szResult, MainPipeline, 129);
				GetPVarString(extraid, "PassAuth", szBuffer, sizeof(szBuffer));
				WP_Hash(szPass, sizeof(szPass), szBuffer);

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
				DeletePVar(extraid, "PassAuth");
				break;
			}
			HideNoticeGUIFrame(extraid);
			g_mysql_LoadAccount(extraid);
			return 1;
		}
		case REGISTER_THREAD:
		{
			if(IsPlayerConnected(extraid))
			{
				g_mysql_AccountLoginCheck(extraid);
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
				
					new szResult[32];
					
					cache_get_field_content(i, "id", szResult, MainPipeline);
					PlayerToyInfo[extraid][i][ptID] = strval(szResult);
					
					cache_get_field_content(i, "modelid", szResult, MainPipeline);
					PlayerToyInfo[extraid][i][ptModelID] = strval(szResult);
					
					if(PlayerToyInfo[extraid][i][ptModelID] != 0)
					{					
						cache_get_field_content(i, "bone", szResult, MainPipeline);
						PlayerToyInfo[extraid][i][ptBone] = strval(szResult);
						
						if(PlayerToyInfo[extraid][i][ptBone] > 18 || PlayerToyInfo[extraid][i][ptBone] < 1) PlayerToyInfo[extraid][i][ptBone] = 1;
						
						cache_get_field_content(i, "tradable", szResult, MainPipeline);
						PlayerToyInfo[extraid][i][ptTradable] = strval(szResult);
						
						cache_get_field_content(i, "posx", szResult, MainPipeline);
						PlayerToyInfo[extraid][i][ptPosX] = floatstr(szResult);
						
						cache_get_field_content(i, "posy", szResult, MainPipeline);
						PlayerToyInfo[extraid][i][ptPosY] = floatstr(szResult);
						
						cache_get_field_content(i, "posz", szResult, MainPipeline);
						PlayerToyInfo[extraid][i][ptPosZ] = floatstr(szResult);
						
						cache_get_field_content(i, "rotx", szResult, MainPipeline);
						PlayerToyInfo[extraid][i][ptRotX] = floatstr(szResult);
						
						cache_get_field_content(i, "roty", szResult, MainPipeline);
						PlayerToyInfo[extraid][i][ptRotY] = floatstr(szResult);
						
						cache_get_field_content(i, "rotz", szResult, MainPipeline);
						PlayerToyInfo[extraid][i][ptRotZ] = floatstr(szResult);
						
						cache_get_field_content(i, "scalex", szResult, MainPipeline);
						PlayerToyInfo[extraid][i][ptScaleX] = floatstr(szResult);
						
						cache_get_field_content(i, "scaley", szResult, MainPipeline);
						PlayerToyInfo[extraid][i][ptScaleY] = floatstr(szResult);
						
						cache_get_field_content(i, "scalez", szResult, MainPipeline);
						PlayerToyInfo[extraid][i][ptScaleZ] = floatstr(szResult);
						
						cache_get_field_content(i, "special", szResult, MainPipeline);
						PlayerToyInfo[extraid][i][ptSpecial] = strval(szResult);
						
						new szLog[128];
						format(szLog, sizeof(szLog), "[TOYSLOAD] [User: %s(%i)] [Toy Model ID: %d] [Toy ID]", GetPlayerNameEx(extraid), PlayerInfo[extraid][pId], PlayerToyInfo[extraid][i][ptModelID], PlayerToyInfo[extraid][i][ptID]);
						Log("logs/toydebug.log", szLog);
					}
					else
					{
						new szQuery[128];
						format(szQuery, sizeof(szQuery), "DELETE FROM `toys` WHERE `id` = '%d'", PlayerToyInfo[extraid][i][ptID]);
						mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "i", SENDDATA_THREAD);
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

				    new szResult[32];

					cache_get_field_content(i,  "pvModelId", szResult, MainPipeline);
					PlayerVehicleInfo[extraid][i][pvModelId] = strval(szResult);
					
					cache_get_field_content(i, "id", szResult, MainPipeline);
	    			PlayerVehicleInfo[extraid][i][pvSlotId] = strval(szResult);

					if(PlayerVehicleInfo[extraid][i][pvModelId] != 0)
					{
						cache_get_field_content(i,  "pvPosX", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvPosX] = floatstr(szResult);

						cache_get_field_content(i,  "pvPosY", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvPosY] = floatstr(szResult);

						cache_get_field_content(i,  "pvPosZ", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvPosZ] = floatstr(szResult);

						cache_get_field_content(i,  "pvPosAngle", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvPosAngle] = floatstr(szResult);

						cache_get_field_content(i,  "pvLock", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvLock] = strval(szResult);

						cache_get_field_content(i,  "pvLocked", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvLocked] = strval(szResult);

						cache_get_field_content(i,  "pvPaintJob", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvPaintJob] = strval(szResult);

						cache_get_field_content(i,  "pvColor1", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvColor1] = strval(szResult);

						cache_get_field_content(i,  "pvColor2", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvColor2] = strval(szResult);

						cache_get_field_content(i,  "pvPrice", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvPrice] = strval(szResult);

						cache_get_field_content(i,  "pvTicket", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvTicket] = strval(szResult);

						cache_get_field_content(i,  "pvRestricted", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvRestricted] = strval(szResult);

						cache_get_field_content(i,  "pvWeapon0", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvWeapons][0] = strval(szResult);

						cache_get_field_content(i,  "pvWeapon1", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvWeapons][1] = strval(szResult);

						cache_get_field_content(i,  "pvWeapon2", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvWeapons][2] = strval(szResult);

						cache_get_field_content(i,  "pvWepUpgrade", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvWepUpgrade] = strval(szResult);

						cache_get_field_content(i,  "pvFuel", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvFuel] = floatstr(szResult);

						cache_get_field_content(i,  "pvImpound", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvImpounded] = strval(szResult);

						cache_get_field_content(i,  "pvPlate", szResult, MainPipeline, 32);
						format(PlayerVehicleInfo[extraid][i][pvPlate], 32, "%s", szResult, MainPipeline);

						cache_get_field_content(i,  "pvVW", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvVW] = strval(szResult);

						cache_get_field_content(i,  "pvInt", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvInt] = strval(szResult);

						for(new m = 0; m < MAX_MODS; m++)
						{
		    				new szField[15];
							format(szField, sizeof(szField), "pvMod%d", m);
							cache_get_field_content(i,  szField, szResult, MainPipeline);
							PlayerVehicleInfo[extraid][i][pvMods][m] = strval(szResult);
						}
						
						cache_get_field_content(i,  "pvCrashFlag", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvCrashFlag] = strval(szResult);
						
						cache_get_field_content(i, "pvCrashVW", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvCrashVW] = strval(szResult);
						
						cache_get_field_content(i,  "pvCrashX", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvCrashX] = floatstr(szResult);
						
						cache_get_field_content(i,  "pvCrashY", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvCrashY] = floatstr(szResult);
						
						cache_get_field_content(i,  "pvCrashZ", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvCrashZ] = floatstr(szResult);
						
						cache_get_field_content(i,  "pvCrashAngle", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvCrashAngle] = floatstr(szResult);
						
						cache_get_field_content(i,  "pvAlarm", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvAlarm] = strval(szResult);
						
						cache_get_field_content(i,  "pvLastLockPickedBy", szResult, MainPipeline, MAX_PLAYER_NAME);
						format(PlayerVehicleInfo[extraid][i][pvLastLockPickedBy], MAX_PLAYER_NAME, "%s", szResult, MainPipeline);
						
						cache_get_field_content(i,  "pvLocksLeft", szResult, MainPipeline);
						PlayerVehicleInfo[extraid][i][pvLocksLeft] = strval(szResult);
						
						new szLog[128];
						format(szLog, sizeof(szLog), "[VEHICLELOAD] [User: %s(%i)] [Model: %d] [Vehicle ID: %d]", GetPlayerNameEx(extraid), PlayerInfo[extraid][pId], PlayerVehicleInfo[extraid][i][pvModelId], PlayerVehicleInfo[extraid][i][pvSlotId]);
						Log("logs/vehicledebug.log", szLog);
					}
					else
					{
						new query[128];
						format(query, sizeof(query), "DELETE FROM `vehicles` WHERE `id` = '%d'", PlayerVehicleInfo[extraid][i][pvSlotId]);
						mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "ii", SENDDATA_THREAD, extraid);
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
						new szResult[32], szPrefix[32], tmpVehModelId, Float:tmpVehArray[4];

						format(szPrefix, sizeof(szPrefix), "pv%dModelId", v);
						cache_get_field_content(i, szPrefix, szResult, MainPipeline); tmpVehModelId = strval(szResult);
						format(szPrefix, sizeof(szPrefix), "pv%dPosX", v);
						cache_get_field_content(i, szPrefix, szResult, MainPipeline); tmpVehArray[0] = floatstr(szResult);
						format(szPrefix, sizeof(szPrefix), "pv%dPosY", v);
						cache_get_field_content(i, szPrefix, szResult, MainPipeline); tmpVehArray[1] = floatstr(szResult);
						format(szPrefix, sizeof(szPrefix), "pv%dPosZ", v);
						cache_get_field_content(i, szPrefix, szResult, MainPipeline); tmpVehArray[2] = floatstr(szResult);
						format(szPrefix, sizeof(szPrefix), "pv%dPosAngle", v);
						cache_get_field_content(i, szPrefix, szResult, MainPipeline); tmpVehArray[3] = floatstr(szResult);

						if(tmpVehModelId >= 400)
						{
							printf("Stored %d Vehicle Slot", v);

							format(szPrefix, sizeof(szPrefix), "tmpVeh%dModelId", v);
							SetPVarInt(extraid, szPrefix, tmpVehModelId);

							format(szPrefix, sizeof(szPrefix), "tmpVeh%dPosX", v);
							SetPVarFloat(extraid, szPrefix, tmpVehArray[0]);

							format(szPrefix, sizeof(szPrefix), "tmpVeh%dPosY", v);
							SetPVarFloat(extraid, szPrefix, tmpVehArray[1]);

							format(szPrefix, sizeof(szPrefix), "tmpVeh%dPosZ", v);
							SetPVarFloat(extraid, szPrefix, tmpVehArray[2]);

							format(szPrefix, sizeof(szPrefix), "tmpVeh%dAngle", v);
							SetPVarFloat(extraid, szPrefix, tmpVehArray[3]);
						}
					}
					break;
				}

				if(bVehRestore == true) {
					// person Vehicle Position Restore Granted, Now Purge them from the Table.
					new query[128];
					format(query, sizeof(query), "DELETE FROM `pvehpositions` WHERE `id`='%d'", PlayerInfo[extraid][pId]);
					mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "ii", SENDDATA_THREAD, extraid);
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
		case LOADCRATE_THREAD:
		{
		    for(new i; i < rows; i++)
		    {
				new crateid, szResult[32], string[128];
				cache_get_field_content(i, "id", szResult, MainPipeline); crateid = strval(szResult);
				if(crateid < MAX_CRATES)
		        {
					cache_get_field_content(i, "Active", szResult, MainPipeline); CrateInfo[crateid][crActive] = strval(szResult);
					cache_get_field_content(i, "CrateX", szResult, MainPipeline); CrateInfo[crateid][crX] = floatstr(szResult);
					cache_get_field_content(i, "CrateY", szResult, MainPipeline); CrateInfo[crateid][crY] = floatstr(szResult);
					cache_get_field_content(i, "CrateZ", szResult, MainPipeline); CrateInfo[crateid][crZ] = floatstr(szResult);
					cache_get_field_content(i, "Int", szResult, MainPipeline); CrateInfo[crateid][crInt] = strval(szResult);
					cache_get_field_content(i, "VW", szResult, MainPipeline); CrateInfo[crateid][crVW] = strval(szResult);
					cache_get_field_content(i, "PlacedBy", szResult, MainPipeline); format(CrateInfo[crateid][crPlacedBy], MAX_PLAYER_NAME, szResult);
					cache_get_field_content(i, "GunQuantity", szResult, MainPipeline); CrateInfo[crateid][GunQuantity] = strval(szResult);
					cache_get_field_content(i, "InVehicle", szResult, MainPipeline); CrateInfo[crateid][InVehicle] = strval(szResult);
					if(CrateInfo[crateid][InVehicle] != INVALID_VEHICLE_ID)
					{
					    CrateInfo[crateid][crActive] = 0;
					    CrateInfo[crateid][InVehicle] = INVALID_VEHICLE_ID;
					}
					if(CrateInfo[crateid][crActive])
					{
						if(CrateInfo[crateid][crX] != 0.0)
						{
							CrateInfo[crateid][InVehicle] = INVALID_VEHICLE_ID;
							CrateInfo[crateid][crObject] = CreateDynamicObject(964,CrateInfo[crateid][crX],CrateInfo[crateid][crY],CrateInfo[crateid][crZ],0.00000000,0.00000000,0.00000000,CrateInfo[i][crVW], CrateInfo[i][crInt]);
							format(string, sizeof(string), "Serial Number: #%d\n High Grade Materials: %d/50\n (( Dropped by: %s ))", i, CrateInfo[crateid][GunQuantity], CrateInfo[crateid][crPlacedBy]);
							CrateInfo[crateid][crLabel] = CreateDynamic3DTextLabel(string, COLOR_ORANGE, CrateInfo[crateid][crX],CrateInfo[crateid][crY],CrateInfo[crateid][crZ]+1, 10.0, _, _, 1, CrateInfo[crateid][crVW], CrateInfo[crateid][crInt], _, 20.0);
						}
					}
				}
		    }
		    print("[LoadCrates] Loading Crates Finished");
		}
		case MAIN_REFERRAL_THREAD:
		{
		    new newrows, newfields, szString[128], szQuery[128];
		    cache_get_data(newrows, newfields, MainPipeline);

		    if(newrows == 0)
		    {
		        format(szString, sizeof(szString), "Nobody");
				strmid(PlayerInfo[extraid][pReferredBy], szString, 0, strlen(szString), MAX_PLAYER_NAME);
		        ShowPlayerDialog(extraid, REGISTERREF, DIALOG_STYLE_INPUT, "{FF0000}Error - Invalid Player", "There is no player registered to our server with such name.\nPlease enter the full name of the player who referred you.\nExample: FirstName_LastName", "Enter", "Cancel");
			}
			else {
			    format(szQuery, sizeof(szQuery), "SELECT `IP` FROM `accounts` WHERE `Username` = '%s'", PlayerInfo[extraid][pReferredBy]);
				mysql_function_query(MainPipeline, szQuery, true, "ReferralSecurity", "i", extraid);
			}
		}
		case REWARD_REFERRAL_THREAD:
		{
			new newrows, newfields;
			cache_get_data(newrows, newfields, MainPipeline);

			if(newrows != 0)
			{
			    SendClientMessageEx(extraid, COLOR_YELLOW, "The player who referred you does not have a account on our server anymore, therefore he has not received any credits");
			}
		}
		case OFFLINE_FAMED_THREAD:
		{
		    new newrows, newfields, szQuery[128], string[128], szName[MAX_PLAYER_NAME];
		    cache_get_data(newrows, newfields, MainPipeline);
		    
		    if(newrows == 0)
		    {
		        SendClientMessageEx(extraid, COLOR_RED, "Error - This account does not exist.");
		    }
		    else {
		        new
					ilevel = GetPVarInt(extraid, "Offline_Famed");

				GetPVarString(extraid, "Offline_Name", szName, MAX_PLAYER_NAME);
		        
		        format(szQuery, sizeof(szQuery), "UPDATE `accounts` SET `Famed` = %d WHERE `Username` = '%s'", ilevel, szName);
				mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "i", SENDDATA_THREAD);
				
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
				cache_get_field_content(i, "Username", szResult, MainPipeline); SendClientMessageEx(extraid, COLOR_GRAD2, szResult);
			}
		}
		case ADMINWHITELIST_THREAD:
		{
			new string[128];
			for(new i;i < rows;i++)
			{
				new secureip[16], szResult[32], alevel, wdlevel;
				cache_get_field_content(i, "AdminLevel", szResult, MainPipeline); alevel = strval(szResult);
				cache_get_field_content(i, "Watchdog", szResult, MainPipeline); wdlevel = strval(szResult);
				cache_get_field_content(i, "SecureIP", secureip, MainPipeline, 16);
				
				if((alevel > 1 || wdlevel > 2)  && !fexist("NoWhitelist.h"))  // Beta server check ( beta server does not require whitelisting)
				{
					if(isnull(secureip) || strcmp(GetPlayerIpEx(extraid), secureip, false, strlen(secureip)) != 0)
					{
						if(strcmp(GetPlayerIpEx(extraid), "127.0.0.1", false, 16) != 0)
						{
							SendClientMessage(extraid, COLOR_WHITE, "SERVER: Your IP does not match the whitelisted IP of that account. Contact a Senior+ Admin to whitelist your current IP.");
							for(new x; x < MAX_PLAYERS; x++)
							{
								if(IsPlayerConnected(x))
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
							return true;
						}
					}
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
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgMoney[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgRimKit%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgRimKit[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgFirework%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgFirework[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgGVIP%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgGVIP[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgSVIP%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgSVIP[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgGVIPEx%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgGVIPEx[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgSVIPEx%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgSVIPEx[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgCarSlot%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgCarSlot[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgToySlot%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgToySlot[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgArmor%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgArmor[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgFirstaid%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgFirstaid[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgDDFlag%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgDDFlag[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgGateFlag%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgGateFlag[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgCredits%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgCredits[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgPriorityAd%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgPriorityAd[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgHealthNArmor%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgHealthNArmor[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgGiftReset%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgGiftReset[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgMaterial%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgMaterial[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgWarning%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgWarning[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgPot%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgPot[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgCrack%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgCrack[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgPaintballToken%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgPaintballToken[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgVIPToken%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgVIPToken[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgRespectPoint%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgRespectPoint[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgCarVoucher%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgCarVoucher[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgBuddyInvite%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgBuddyInvite[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgLaser%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgLaser[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgCustomToy%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgCustomToy[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgAdmuteReset%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgAdmuteReset[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgNewbieMuteReset%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgNewbieMuteReset[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgRestrictedCarVoucher%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgRestrictedCarVoucher[array] = strval(szResult);
					format(arraystring, sizeof(arraystring), "dgPlatinumVIPVoucher%d", array);
					cache_get_field_content(i, arraystring, szResult, MainPipeline); dgPlatinumVIPVoucher[array] = strval(szResult);
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
					
					cache_get_field_content(i, "active", szResult, MainPipeline);
					
					// Is the row active?
					if(strval(szResult) == 1)
					{			
						cache_get_field_content(i, "point", szResult, MainPipeline);

						// Add up all the points
						count = count += strval(szResult);
					}
				}
				// We're done with our loop, let's get our count and store it to a player variable
				PlayerInfo[extraid][pNonRPMeter] = count;
			}
		}
	}
	return 1;
}

public OnQueryError(errorid, error[], callback[], query[], connectionHandle)
{
	printf("[MySQL] Query Error - (ErrorID: %d) (Handle: %d)",  errorid, connectionHandle);
	print("[MySQL] Check mysql_log.txt to review the query that threw the error.");
	SQL_Log(query, error);

	if(errorid == 2013 || errorid == 2014 || errorid == 2006 || errorid == 2027 || errorid == 2055)
	{
		print("[MySQL] Connection Error Detected in Threaded Query");
		//mysql_query(query, resultid, extraid, MainPipeline);
	}
}

//--------------------------------[ CUSTOM STOCK FUNCTIONS ]---------------------------

// g_mysql_ReturnEscaped(string unEscapedString)
// Description: Takes a unescaped string and returns an escaped one.
stock g_mysql_ReturnEscaped(unEscapedString[], connectionHandle)
{
	new EscapedString[256];
	mysql_real_escape_string(unEscapedString, EscapedString, connectionHandle);
	return EscapedString;
}

// g_mysql_AccountLoginCheck(playerid)
stock g_mysql_AccountLoginCheck(playerid)
{
	ShowNoticeGUIFrame(playerid, 2);

	new string[128];

	format(string, sizeof(string), "SELECT `Username`, `Key` FROM `accounts` WHERE `Username` = '%s'", GetPlayerNameExt(playerid));
	mysql_function_query(MainPipeline, string, true, "OnQueryFinish", "iii", LOGIN_THREAD, playerid, g_arrQueryHandle{playerid});
	return 1;
}

// g_mysql_AccountAuthCheck(playerid)
g_mysql_AccountAuthCheck(playerid)
{
	new string[128];

	format(string, sizeof(string), "SELECT `Username` FROM `accounts` WHERE `Username` = '%s'", GetPlayerNameExt(playerid));
	mysql_function_query(MainPipeline, string, true, "OnQueryFinish", "iii", AUTH_THREAD, playerid, g_arrQueryHandle{playerid});

	// Reset the GUI
	SetPlayerJoinCamera(playerid);
	ClearChatbox(playerid);
	SetPlayerVirtualWorld(playerid, 0);


	return 1;
}

// g_mysql_AccountOnline(int playerid, int stateid)
stock g_mysql_AccountOnline(playerid, stateid)
{
	new string[128];
	format(string, sizeof(string), "UPDATE `accounts` SET `Online`=%d, `LastLogin` = NOW() WHERE `id` = %d", stateid, GetPlayerSQLId(playerid));
	mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
	return 1;
}

stock g_mysql_AccountOnlineReset()
{
	new string[128];
	format(string, sizeof(string), "UPDATE `accounts` SET `Online` = 0 WHERE `Online` = %d", servernumber);
	mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	return 1;
}

// g_mysql_CreateAccount(int playerid, string accountPassword[])
// Description: Creates a new account in the database.
stock g_mysql_CreateAccount(playerid, accountPassword[])
{
	new string[256];
	new passbuffer[129];
	WP_Hash(passbuffer, sizeof(passbuffer), accountPassword);

	format(string, sizeof(string), "INSERT INTO `accounts` (`RegiDate`, `LastLogin`, `Username`, `Key`) VALUES (NOW(), NOW(), '%s','%s')", GetPlayerNameExt(playerid), passbuffer);
	mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "iii", REGISTER_THREAD, playerid, g_arrQueryHandle{playerid});
	return 1;
}

stock g_mysql_LoadPVehicles(playerid)
{
    new string[128];
	format(string, sizeof(string), "SELECT * FROM `vehicles` WHERE `sqlID` = %d", PlayerInfo[playerid][pId]);
	mysql_function_query(MainPipeline, string, true, "OnQueryFinish", "iii", LOADPVEHICLE_THREAD, playerid, g_arrQueryHandle{playerid});
	return 1;
}

// g_mysql_LoadPVehiclePositions(playerid)
// Description: Loads vehicle positions if person has timed out.
stock g_mysql_LoadPVehiclePositions(playerid)
{
	new string[128];

	format(string, sizeof(string), "SELECT * FROM `pvehpositions` WHERE `id` = %d", PlayerInfo[playerid][pId]);
	mysql_function_query(MainPipeline, string, true, "OnQueryFinish", "iii", LOADPVEHPOS_THREAD, playerid, g_arrQueryHandle{playerid});
	return 1;
}

// g_mysql_LoadPlayerToys(playerid)
// Description: Load the player toys
stock g_mysql_LoadPlayerToys(playerid)
{
	new szQuery[128];
	format(szQuery, sizeof(szQuery), "SELECT * FROM `toys` WHERE `player` = %d", PlayerInfo[playerid][pId]);
	mysql_function_query(MainPipeline, szQuery, true, "OnQueryFinish", "iii", LOADPTOYS_THREAD, playerid, g_arrQueryHandle{playerid});
	return 1;
}	

// g_mysql_LoadAccount(playerid)
// Description: Loads an account from database into memory.
stock g_mysql_LoadAccount(playerid)
{
	ShowNoticeGUIFrame(playerid, 3);

	new string[164];
	format(string, sizeof(string), "SELECT * FROM `accounts` WHERE `Username` = '%s'", GetPlayerNameExt(playerid));
 	mysql_function_query(MainPipeline, string, true, "OnQueryFinish", "iii", LOADUSERDATA_THREAD, playerid, g_arrQueryHandle{playerid});
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

	format(szQuery, sizeof(szQuery), "UPDATE `accounts` SET `Credits`=%d WHERE `id` = %d", PlayerInfo[Player][pCredits], GetPlayerSQLId(Player));
	mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "ii", SENDDATA_THREAD, Player);
	print(szQuery);

	if(Shop == 1)
	{
    	if(Amount < 0) Amount = Amount*-1;
		PlayerInfo[Player][pTotalCredits] += Amount;
	}

	format(szQuery, sizeof(szQuery), "UPDATE `accounts` SET `TotalCredits`=%d WHERE `id` = %d", PlayerInfo[Player][pTotalCredits], GetPlayerSQLId(Player));
	mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "ii", SENDDATA_THREAD, Player);
	print(szQuery);
}

// g_mysql_SaveVehicle(int playerid, int slotid)
// Description: Saves a account's specified vehicle slot.
stock g_mysql_SaveVehicle(playerid, slotid)
{
	new query[2048];
	printf("%s (%i) saving their %d (slot %i) (Model %i)...", GetPlayerNameEx(playerid), playerid, PlayerVehicleInfo[playerid][slotid][pvModelId], slotid, PlayerVehicleInfo[playerid][slotid][pvModelId]);

	format(query, sizeof(query), "UPDATE `vehicles` SET");
	format(query, sizeof(query), "%s `pvPosX` = %0.5f,", query, PlayerVehicleInfo[playerid][slotid][pvPosX]);
	format(query, sizeof(query), "%s `pvPosY` = %0.5f,", query, PlayerVehicleInfo[playerid][slotid][pvPosY]);
	format(query, sizeof(query), "%s `pvPosZ` = %0.5f,", query, PlayerVehicleInfo[playerid][slotid][pvPosZ]);
	format(query, sizeof(query), "%s `pvPosAngle` = %0.5f,", query, PlayerVehicleInfo[playerid][slotid][pvPosAngle]);
	format(query, sizeof(query), "%s `pvLock` = %d,", query, PlayerVehicleInfo[playerid][slotid][pvLock]);
	format(query, sizeof(query), "%s `pvLocked` = %d,", query, PlayerVehicleInfo[playerid][slotid][pvLocked]);
	format(query, sizeof(query), "%s `pvPaintJob` = %d,", query, PlayerVehicleInfo[playerid][slotid][pvPaintJob]);
	format(query, sizeof(query), "%s `pvColor1` = %d,", query, PlayerVehicleInfo[playerid][slotid][pvColor1]);
	format(query, sizeof(query), "%s `pvColor2` = %d,", query, PlayerVehicleInfo[playerid][slotid][pvColor2]);
	format(query, sizeof(query), "%s `pvPrice` = %d,", query, PlayerVehicleInfo[playerid][slotid][pvPrice]);
	format(query, sizeof(query), "%s `pvWeapon0` = %d,", query, PlayerVehicleInfo[playerid][slotid][pvWeapons][0]);
	format(query, sizeof(query), "%s `pvWeapon1` = %d,", query, PlayerVehicleInfo[playerid][slotid][pvWeapons][1]);
	format(query, sizeof(query), "%s `pvWeapon2` = %d,", query, PlayerVehicleInfo[playerid][slotid][pvWeapons][2]);
	format(query, sizeof(query), "%s `pvLock` = %d,", query, PlayerVehicleInfo[playerid][slotid][pvLock]);
	format(query, sizeof(query), "%s `pvWepUpgrade` = %d,", query, PlayerVehicleInfo[playerid][slotid][pvWepUpgrade]);
	format(query, sizeof(query), "%s `pvFuel` = %0.5f,", query, PlayerVehicleInfo[playerid][slotid][pvFuel]);
	format(query, sizeof(query), "%s `pvImpound` = %d,", query, PlayerVehicleInfo[playerid][slotid][pvImpounded]);
	format(query, sizeof(query), "%s `pvDisabled` = %d,", query, PlayerVehicleInfo[playerid][slotid][pvDisabled]);
	format(query, sizeof(query), "%s `pvPlate` = '%s',", query, g_mysql_ReturnEscaped(PlayerVehicleInfo[playerid][slotid][pvPlate], MainPipeline));
	format(query, sizeof(query), "%s `pvTicket` = %d,", query, PlayerVehicleInfo[playerid][slotid][pvTicket]);
	format(query, sizeof(query), "%s `pvRestricted` = %d,", query, PlayerVehicleInfo[playerid][slotid][pvRestricted]);
	format(query, sizeof(query), "%s `pvVW` = %d,", query, PlayerVehicleInfo[playerid][slotid][pvVW]);
	format(query, sizeof(query), "%s `pvInt` = %d,", query, PlayerVehicleInfo[playerid][slotid][pvInt]);
	format(query, sizeof(query), "%s `pvCrashFlag` = %d,", query, PlayerVehicleInfo[playerid][slotid][pvCrashFlag]);
	format(query, sizeof(query), "%s `pvCrashVW` = %d,", query, PlayerVehicleInfo[playerid][slotid][pvCrashVW]);
	format(query, sizeof(query), "%s `pvCrashX` = %0.5f,", query, PlayerVehicleInfo[playerid][slotid][pvCrashX]);
	format(query, sizeof(query), "%s `pvCrashY` = %0.5f,", query, PlayerVehicleInfo[playerid][slotid][pvCrashY]);
	format(query, sizeof(query), "%s `pvCrashZ` = %0.5f,", query, PlayerVehicleInfo[playerid][slotid][pvCrashZ]);
	format(query, sizeof(query), "%s `pvCrashAngle` = %0.5f,", query, PlayerVehicleInfo[playerid][slotid][pvCrashAngle]);
	format(query, sizeof(query), "%s `pvAlarm` = %d,", query, PlayerVehicleInfo[playerid][slotid][pvAlarm]);
	format(query, sizeof(query), "%s `pvLastLockPickedBy` = '%s',", query, g_mysql_ReturnEscaped(PlayerVehicleInfo[playerid][slotid][pvLastLockPickedBy], MainPipeline));
	format(query, sizeof(query), "%s `pvLocksLeft` = %d,", query, PlayerVehicleInfo[playerid][slotid][pvLocksLeft]);
	
	for(new m = 0; m < MAX_MODS; m++)
	{
		if(m == MAX_MODS-1)
		{
			format(query, sizeof(query), "%s `pvMod%d` = %d WHERE `id` = '%d'", query, m, PlayerVehicleInfo[playerid][slotid][pvMods][m], PlayerVehicleInfo[playerid][slotid][pvSlotId]);
		}
		else
		{
			format(query, sizeof(query), "%s `pvMod%d` = %d,", query, m, PlayerVehicleInfo[playerid][slotid][pvMods][m]);
		}
	}
    //print(query);

	new szLog[128];
	format(szLog, sizeof(szLog), "[VEHICLESAVE] [User: %s(%i)] [Model: %d] [Vehicle ID: %d]", GetPlayerNameEx(playerid), PlayerInfo[playerid][pId], PlayerVehicleInfo[playerid][slotid][pvModelId], PlayerVehicleInfo[playerid][slotid][pvSlotId]);
	Log("logs/vehicledebug.log", szLog);
	
	mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
}

// native g_mysql_SaveToys(int playerid, int slotid)
stock g_mysql_SaveToys(playerid, slotid)
{
	new szQuery[2048];
	
	if(PlayerToyInfo[playerid][slotid][ptID] >= 1) // Making sure the player actually has a toy so we won't save a empty row
	{
		//printf("%s (%i) saving toy %i...", GetPlayerNameEx(playerid), playerid, slotid);
		
		format(szQuery, sizeof(szQuery), "UPDATE `toys` SET `modelid` = '%d', `bone` = '%d', `posx` = '%f', `posy` = '%f', `posz` = '%f', `rotx` = '%f', `roty` = '%f', `rotz` = '%f', `scalex` = '%f', `scaley` = '%f', `scalez` = '%f', `tradable` = '%d' WHERE `id` = '%d'",
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
		PlayerToyInfo[playerid][slotid][ptID]);
		
		mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
	}	
}

// native g_mysql_NewToy(int playerid, int slotid)
stock g_mysql_NewToy(playerid, slotid)
{
	new szQuery[2048];
	if(PlayerToyInfo[playerid][slotid][ptSpecial] != 1) { PlayerToyInfo[playerid][slotid][ptSpecial] = 0; }
	
	format(szQuery, sizeof(szQuery), "INSERT INTO `toys` (player, modelid, bone, posx, posy, posz, rotx, roty, rotz, scalex, scaley, scalez, tradable, special) VALUES ('%d', '%d', '%d', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%d', '%d')",
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
	PlayerToyInfo[playerid][slotid][ptSpecial]);
		
	mysql_function_query(MainPipeline, szQuery, true, "OnQueryCreateToy", "ii", playerid, slotid);	
}				

// g_mysql_LoadMOTD()
// Description: Loads the MOTDs from the MySQL Database.
stock g_mysql_LoadMOTD()
{
	mysql_function_query(MainPipeline, "SELECT `gMOTD`,`aMOTD`,`vMOTD`,`cMOTD`,`pMOTD`,`ShopTechPay`,`GiftCode`,`GiftCodeBypass`,`TotalCitizens`,`TRCitizens`,`SecurityCode`,`ShopClosed`,`RimMod`,`CarVoucher`,`PVIPVoucher`, `GarageVW`, `PumpkinStock`, `HalloweenShop` FROM `misc`", true, "OnQueryFinish", "iii", LOADMOTDDATA_THREAD, INVALID_PLAYER_ID, -1);
}

stock g_mysql_LoadSales()
{
	mysql_function_query(MainPipeline, "SELECT * FROM `sales` WHERE `Month` > NOW() - INTERVAL 1 MONTH", true, "OnQueryFinish", "iii", LOADSALEDATA_THREAD, INVALID_PLAYER_ID, -1);
	//mysql_function_query(MainPipeline, "SELECT `TotalToySales`,`TotalCarSales`,`GoldVIPSales`,`SilverVIPSales`,`BronzeVIPSales` FROM `sales` WHERE `Month` > NOW() - INTERVAL 1 MONTH", true, "OnQueryFinish", "iii", LOADSALEDATA_THREAD, INVALID_PLAYER_ID, -1);
}

stock g_mysql_LoadPrices()
{
    mysql_function_query(MainPipeline, "SELECT * FROM `shopprices`", true, "OnQueryFinish", "iii", LOADSHOPDATA_THREAD, INVALID_PLAYER_ID, -1);
}

stock g_mysql_SavePrices()
{
	new query[2000];
	strins(query, "UPDATE `shopprices` SET ", 0);
	for(new p = 0; p < MAX_ITEMS; p++)
	{
		format(query, sizeof(query), "%s`Price%d` = '%d', ", query, p, ShopItems[p][sItemPrice]);
	}
	strdel(query, strlen(query)-2, strlen(query));
    mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
}

stock g_mysql_SaveMOTD()
{
	new query[1024];

	format(query, sizeof(query), "UPDATE `misc` SET ");

	format(query, sizeof(query), "%s `gMOTD` = '%s',", query, g_mysql_ReturnEscaped(GlobalMOTD, MainPipeline));
	format(query, sizeof(query), "%s `aMOTD` = '%s',", query, g_mysql_ReturnEscaped(AdminMOTD, MainPipeline));
	format(query, sizeof(query), "%s `vMOTD` = '%s',", query, g_mysql_ReturnEscaped(VIPMOTD, MainPipeline));
	format(query, sizeof(query), "%s `cMOTD` = '%s',", query, g_mysql_ReturnEscaped(CAMOTD, MainPipeline));
	format(query, sizeof(query), "%s `pMOTD` = '%s',", query, g_mysql_ReturnEscaped(pMOTD, MainPipeline));
	format(query, sizeof(query), "%s `ShopTechPay` = '%.2f',", query, ShopTechPay);
	format(query, sizeof(query), "%s `GiftCode` = '%s',", query, g_mysql_ReturnEscaped(GiftCode, MainPipeline));
	format(query, sizeof(query), "%s `GiftCodeBypass` = '%d',", query, GiftCodeBypass);
	format(query, sizeof(query), "%s `TotalCitizens` = '%d',", query, TotalCitizens);
	format(query, sizeof(query), "%s `TRCitizens` = '%d',", query, TRCitizens);
	format(query, sizeof(query), "%s `ShopClosed` = '%d',", query, ShopClosed);
	format(query, sizeof(query), "%s `RimMod` = '%d',", query, RimMod);
	format(query, sizeof(query), "%s `CarVoucher` = '%d',", query, CarVoucher);
	format(query, sizeof(query), "%s `PVIPVoucher` = '%d',", query, PVIPVoucher);
	format(query, sizeof(query), "%s `GarageVW` = '%d',", query, GarageVW);
	format(query, sizeof(query), "%s `PumpkinStock` = '%d',", query, PumpkinStock);
	format(query, sizeof(query), "%s `HalloweenShop` = '%d'", query, HalloweenShop);

	mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
}

// g_mysql_LoadMOTD()
// Description: Loads the Crates from the MySQL Database.
stock mysql_LoadCrates()
{
	mysql_function_query(MainPipeline, "SELECT * FROM `crates`", true, "OnQueryFinish", "iii", LOADCRATE_THREAD, INVALID_PLAYER_ID, -1);
    print("[LoadCrates] Load Query Sent");
}

stock mysql_SaveCrates()
{
	new query[1024];
	for(new i; i < MAX_CRATES; i++)
	{
		printf("Saving Crate %d", i);
		format(query, sizeof(query), "UPDATE `crates` SET ");

		format(query, sizeof(query), "%s `Active` = '%d',", query, CrateInfo[i][crActive]);
		format(query, sizeof(query), "%s `CrateX` = '%.2f',", query, CrateInfo[i][crX]);
		format(query, sizeof(query), "%s `CrateY` = '%.2f',", query, CrateInfo[i][crY]);
		format(query, sizeof(query), "%s `CrateZ` = '%.2f',", query, CrateInfo[i][crZ]);
		format(query, sizeof(query), "%s `GunQuantity` = '%d',", query, CrateInfo[i][GunQuantity]);
		format(query, sizeof(query), "%s `InVehicle` = '%d',", query, CrateInfo[i][InVehicle]);
		format(query, sizeof(query), "%s `Int` = '%d',", query, CrateInfo[i][crInt]);
		format(query, sizeof(query), "%s `VW` = '%d',", query, CrateInfo[i][crVW]);
		format(query, sizeof(query), "%s `PlacedBy` = '%s'", query, CrateInfo[i][crPlacedBy]);
		format(query, sizeof(query), "%s WHERE id = %d", query, i);

		mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	}
}

stock RemoveBan(Player, Ip[])
{
	new string[128];
	SetPVarString(Player, "UnbanIP", Ip);
	format(string, sizeof(string), "SELECT `ip` FROM `ip_bans` WHERE `ip` = '%s'", Ip);
	mysql_function_query(MainPipeline, string, true, "AddingBan", "ii", Player, 2);
	return 1;
}

stock CheckBanEx(playerid)
{
	new string[60];
	format(string, sizeof(string), "SELECT `ip` FROM `ip_bans` WHERE `ip` = '%s'", GetPlayerIpEx(playerid));
	mysql_function_query(MainPipeline, string, true, "OnQueryFinish", "iii", IPBAN_THREAD, playerid, g_arrQueryHandle{playerid});
	return 1;
}

stock AddBan(Admin, Player, Reason[])
{
    new string[128];
	SetPVarInt(Admin, "BanningPlayer", Player);
	SetPVarString(Admin, "BanningReason", Reason);
	format(string, sizeof(string), "SELECT `ip` FROM `ip_bans` WHERE `ip` = '%s'", GetPlayerIpEx(Player));
	mysql_function_query(MainPipeline, string, true, "AddingBan", "ii", Admin, 1);
	return 1;
}


stock SystemBan(Player, Reason[])
{
	new string[150];
    format(string, sizeof(string), "INSERT INTO `ip_bans` (`ip`, `date`, `reason`, `admin`) VALUES ('%s', NOW(), '%s', 'System')", GetPlayerIpEx(Player), Reason);
	mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	return 1;
}


stock MySQLBan(userid,ip[],reason[],status,admin[])
{
	new string[200];
    format(string, sizeof(string), "INSERT INTO `bans` (`user_id`, `ip_address`, `reason`, `date_added`, `status`, `admin`) VALUES ('%d','%s','%s', NOW(), '%d','%s')", userid,ip,reason,status,admin);
	mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);
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
	format(query, sizeof(query), "INSERT INTO `mdc` (`id` ,`time` ,`issuer` ,`crime`, `origin`) VALUES ('%d',NOW(),'%s','%s','%d')", GetPlayerSQLId(suspect), g_mysql_ReturnEscaped(GetPlayerNameEx(cop), MainPipeline), g_mysql_ReturnEscaped(crime, MainPipeline), iAllegiance);
	mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	format(query, sizeof(query), "MDC: %s added crime %s to %s.", GetPlayerNameEx(cop), crime, GetPlayerNameEx(suspect));
	Log("logs/crime.log", query);
	return 1;
}

stock ClearCrimes(playerid, clearerid = INVALID_PLAYER_ID)
{
	new query[80], iAllegiance;
	if(clearerid != INVALID_PLAYER_ID && (0 <= PlayerInfo[clearerid][pMember] < MAX_GROUPS))
	{
		iAllegiance = arrGroupData[PlayerInfo[clearerid][pMember]][g_iAllegiance];
		format(query, sizeof(query), "UPDATE `mdc` SET `active`=0 WHERE `id` = %i AND `active` = 1 AND origin = %d", GetPlayerSQLId(playerid), iAllegiance);
	}
	else {
		format(query, sizeof(query), "UPDATE `mdc` SET `active`=0 WHERE `id` = %i AND `active` = 1", GetPlayerSQLId(playerid));
	}	
	mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
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
    format(query, sizeof(query), "SELECT issuer, crime, active FROM `mdc` WHERE id=%d AND origin=%d ORDER BY `time` AND `active` DESC LIMIT 12", GetPlayerSQLId(suspectid), iAllegiance);
    mysql_function_query(MainPipeline, query, true, "MDCQueryFinish", "ii", playerid, suspectid);
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
    format(query, sizeof(query), "SELECT arrestreports.id, copid, shortreport, datetime, accounts.id, accounts.Username FROM `arrestreports` LEFT JOIN `accounts` ON	arrestreports.copid=accounts.id WHERE arrestreports.suspectid=%d AND arrestreports.origin=%d ORDER BY arrestreports.datetime DESC LIMIT 12", GetPlayerSQLId(suspectid), iAllegiance);
    mysql_function_query(MainPipeline, query, true, "MDCReportsQueryFinish", "ii", playerid, suspectid);
	return 1;
}

stock DisplayReport(playerid, reportid)
{
    new query[812];
    format(query, sizeof(query), "SELECT arrestreports.id, copid, shortreport, datetime, accounts.id, accounts.Username FROM `arrestreports` LEFT JOIN `accounts` ON	arrestreports.copid=accounts.id WHERE arrestreports.id=%d ORDER BY arrestreports.datetime DESC LIMIT 12", reportid);
    mysql_function_query(MainPipeline, query, true, "MDCReportQueryFinish", "ii", playerid, reportid);
	return 1;
}

stock SetUnreadMailsNotification(playerid)
{
    new query[128];
    format(query, sizeof(query), "SELECT COUNT(*) AS Unread_Count FROM letters WHERE Receiver_ID = %d AND `Read` = 0", GetPlayerSQLId(playerid));
    mysql_function_query(MainPipeline, query, true, "UnreadMailsNotificationQueryFin", "i", playerid);
	return 1;
}

stock DisplayMails(playerid)
{
    new query[150];
    format(query, sizeof(query), "SELECT `Id`, `Message`, `Read` FROM `letters` WHERE `Receiver_Id` = %d AND `Delivery_Min` = 0 ORDER BY `Id` DESC LIMIT 50", GetPlayerSQLId(playerid));
    mysql_function_query(MainPipeline, query, true, "MailsQueryFinish", "i", playerid);
}

stock DisplayMailDetails(playerid, letterid)
{
    new query[256];
    format(query, sizeof(query), "SELECT `Id`, `Date`, `Sender_Id`, `Read`, `Notify`, `Message`, (SELECT `Username` FROM `accounts` WHERE `id` = letters.Sender_Id) AS `SenderUser` FROM `letters` WHERE id = %d", letterid);
    mysql_function_query(MainPipeline, query, true, "MailDetailsQueryFinish", "i", playerid);
}

stock CountFlags(playerid)
{
	new query[80];
	format(query, sizeof(query), "SELECT * FROM `flags` WHERE id=%d", GetPlayerSQLId(playerid));
	mysql_function_query(MainPipeline, query, true, "FlagQueryFinish", "iii", playerid, INVALID_PLAYER_ID, Flag_Query_Count);
	return 1;
}

stock AddFlag(playerid, adminid, flag[])
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
	format(query, sizeof(query), "INSERT INTO `flags` (`id` ,`time` ,`issuer` ,`flag`) VALUES ('%d',NOW(),'%s','%s')", GetPlayerSQLId(playerid), g_mysql_ReturnEscaped(admin, MainPipeline), g_mysql_ReturnEscaped(flag, MainPipeline));
	mysql_function_query(MainPipeline, query, true, "OnAddFlag", "iss", playerid, admin, flag);
	return 1;
}

forward OnAddFlag(target, admin[], flag[]);
public OnAddFlag(target, admin[], flag[])
{
	new string[128], flag_sqlid = mysql_insert_id(MainPipeline);
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
	format(query, sizeof(query), "INSERT INTO `flags` (`id` ,`time` ,`issuer` ,`flag`) VALUES ('%d',NOW(),'%s','%s')", sqlid, g_mysql_ReturnEscaped(admin, MainPipeline), g_mysql_ReturnEscaped(flag, MainPipeline));
	mysql_function_query(MainPipeline, query, true, "OnAddOFlag", "isss", sqlid, name, admin, flag);
	DeletePVar(adminid, "OnAddFlag");
	return 1;
}

forward OnAddOFlag(psqlid, name[], admin[], flag[]);
public OnAddOFlag(psqlid, name[], admin[], flag[])
{
	new string[128], flag_sqlid = mysql_insert_id(MainPipeline);
	format(string, sizeof(string), "FLAG (%d): %s added flag \"%s\" to %s(%d)", flag_sqlid, admin, flag, name, psqlid);
	Log("logs/flags.log", string);
	return 1;
}

forward OnRequestDeleteFlag(playerid, flagid);
public OnRequestDeleteFlag(playerid, flagid)
{
	new rows, fields, string[256];
	new FlagText[64], FlagIssuer[MAX_PLAYER_NAME], FlagDate[24];
	cache_get_data(rows, fields, MainPipeline);
	if(!rows) return ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "{FF0000}Flag Error:", "Flag does not exist!", "Close", "");
	cache_get_field_content(0, "flag", FlagText, MainPipeline, 64);
	cache_get_field_content(0, "issuer", FlagIssuer, MainPipeline, MAX_PLAYER_NAME);
	cache_get_field_content(0, "time", FlagDate, MainPipeline, 24);
	SetPVarInt(playerid, "Flag_Delete_ID", flagid);
	SetPVarString(playerid, "FlagText", FlagText);
	format(string, sizeof(string), "Are you sure you want to delete:\n{FF6347}Flag ID:{BFC0C2} %d\n{FF6347}Flag:{BFC0C2} %s\n{FF6347}Issued by:{BFC0C2} %s\n{FF6347}Date Issued: {BFC0C2}%s", flagid, FlagText, FlagIssuer, FlagDate);
	return ShowPlayerDialog(playerid, FLAG_DELETE2, DIALOG_STYLE_MSGBOX, "FLAG DELETION", string, "Yes", "No");
}

stock DeleteFlag(flagid, adminid)
{
	new query[256], flagtext[64];
	GetPVarString(adminid, "FlagText", flagtext, sizeof(flagtext));
	format(query, sizeof(query), "FLAG (%d): \"%s\" was deleted by %s.", flagid, flagtext, GetPlayerNameEx(adminid));
	Log("logs/flags.log", query);
	format(query, sizeof(query), "DELETE FROM `flags` WHERE `fid` = %i", flagid);
	mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	DeletePVar(adminid, "Flag_Delete_ID");
	DeletePVar(adminid, "FlagText");
	return 1;
}

stock DisplayFlags(playerid, targetid)
{
    new query[128];
	CountFlags(targetid);
    format(query, sizeof(query), "SELECT fid, issuer, flag, time FROM `flags` WHERE id=%d ORDER BY `time` LIMIT 15", GetPlayerSQLId(targetid));
    mysql_function_query(MainPipeline, query, true, "FlagQueryFinish", "iii", playerid, targetid, Flag_Query_Display);
	return 1;
}

stock CountSkins(playerid)
{
	new query[80];
	format(query, sizeof(query), "SELECT NULL FROM `house_closet` WHERE playerid = %d", GetPlayerSQLId(playerid));
	mysql_function_query(MainPipeline, query, true, "SkinQueryFinish", "ii", playerid, Skin_Query_Count);
	return 1;
}

stock AddSkin(playerid, skinid)
{
	new query[300];
	PlayerInfo[playerid][pSkins]++;
	format(query, sizeof(query), "INSERT INTO `house_closet` (`id`, `playerid`, `skinid`) VALUES (NULL, '%d', '%d')", GetPlayerSQLId(playerid), skinid);
	mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	return 1;
}

stock DeleteSkin(skinid)
{
	new query[80];
	format(query, sizeof(query), "DELETE FROM `house_closet` WHERE `id` = %i", skinid);
	mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	return 1;
}

stock DisplaySkins(playerid)
{
    new query[128];
	CountSkins(playerid);
    format(query, sizeof(query), "SELECT `skinid` FROM `house_closet` WHERE playerid = %d ORDER BY `skinid` ASC", GetPlayerSQLId(playerid));
    mysql_function_query(MainPipeline, query, true, "SkinQueryFinish", "ii", playerid, Skin_Query_Display);
	return 1;
}

stock CountCitizens()
{
	mysql_function_query(MainPipeline, "SELECT NULL FROM `accounts` WHERE `Nation` = 1 && `UpdateDate` > NOW() - INTERVAL 1 WEEK",  true, "CitizenQueryFinish", "i", TR_Citizen_Count);
	mysql_function_query(MainPipeline, "SELECT NULL FROM `accounts` WHERE `UpdateDate` > NOW() - INTERVAL 1 WEEK",  true, "CitizenQueryFinish", "i", Total_Count);
	return 1;
}

stock CheckNationQueue(playerid, nation)
{
	new query[300];
	format(query, sizeof(query), "SELECT NULL FROM `nation_queue` WHERE `playerid` = %d AND `status` = 1", GetPlayerSQLId(playerid));
	mysql_function_query(MainPipeline, query, true, "NationQueueQueryFinish", "iii", playerid, nation, CheckQueue);
}

stock AddNationQueue(playerid, nation, status)
{
	new query[300];
	if(nation == 0)
	{
		format(query, sizeof(query), "INSERT INTO `nation_queue` (`id`, `playerid`, `name`, `date`, `nation`, `status`) VALUES (NULL, %d, '%s', NOW(), 0, %d)", GetPlayerSQLId(playerid), GetPlayerNameExt(playerid), status);
		mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	}
	if(nation == 1)
	{
		if(status == 1)
		{
			format(query, sizeof(query), "SELECT NULL FROM `nation_queue` WHERE `playerid` = %d AND `nation` = 1", GetPlayerSQLId(playerid));
			mysql_function_query(MainPipeline, query, true, "NationQueueQueryFinish", "iii", playerid, nation, AddQueue);
		}
		else if(status == 2)
		{
			format(query, sizeof(query), "INSERT INTO `nation_queue` (`id`, `playerid`, `name`, `date`, `nation`, `status`) VALUES (NULL, %d, '%s', NOW(), 1, %d)", GetPlayerSQLId(playerid), GetPlayerNameExt(playerid), status);
			mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
			PlayerInfo[playerid][pNation] = 1;
		}
	}
	return 1;
}

stock UpdateCitizenApp(playerid, nation)
{
	new query[300];
	format(query, sizeof(query), "SELECT NULL FROM `nation_queue` WHERE `playerid` = %d AND `status` = 1", GetPlayerSQLId(playerid));
	mysql_function_query(MainPipeline, query, true, "NationQueueQueryFinish", "iii", playerid, nation, UpdateQueue);
}

stock AddTicket(playerid, number)
{
	new query[80];
	PlayerInfo[playerid][pLottoNr]++;
	format(query, sizeof(query), "INSERT INTO `lotto` (`id` ,`number`) VALUES ('%d', '%d')", GetPlayerSQLId(playerid), number);
	mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	return 1;
}

stock DeleteTickets(playerid)
{
	new query[80];
	format(query, sizeof(query), "DELETE FROM `lotto` WHERE `id` = %i", GetPlayerSQLId(playerid));
	mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	return 1;
}

stock LoadTickets(playerid)
{
    new query[128];
    format(query, sizeof(query), "SELECT `tid`, `number` FROM `lotto` WHERE `id` = %d LIMIT 5", GetPlayerSQLId(playerid));
    mysql_function_query(MainPipeline, query, true, "LoadTicket", "i", playerid);
	return 1;
}

stock CountTickets(playerid)
{
	new query[80];
	format(query, sizeof(query), "SELECT * FROM `lotto` WHERE `id` = %i", GetPlayerSQLId(playerid));
	mysql_function_query(MainPipeline, query, true, "CountAmount", "i", playerid);
	return 1;
}

stock LoadTreasureInventory(playerid)
{
	new query[175];
	format(query, sizeof(query), "SELECT `junkmetal`, `newcoin`, `oldcoin`, `brokenwatch`, `oldkey`, `treasure`, `goldwatch`, `silvernugget`, `goldnugget` FROM `jobstuff` WHERE `pId` = %d", GetPlayerSQLId(playerid));
    mysql_function_query(MainPipeline, query, true, "LoadTreasureInvent", "i", playerid);
	return 1;
}

stock SaveTreasureInventory(playerid)
{
    new string[220];
	format(string, sizeof(string), "UPDATE `jobstuff` SET `junkmetal` = %d, `newcoin` = %d, `oldcoin` = %d, `brokenwatch` = %d, `oldkey` = %d, \
 	`treasure` = %d, `goldwatch` = %d, `silvernugget` = %d, `goldnugget` =%d  WHERE `pId` = %d", GetPVarInt(playerid, "junkmetal"), GetPVarInt(playerid, "newcoin"), GetPVarInt(playerid, "oldcoin"),
 	GetPVarInt(playerid, "brokenwatch"), GetPVarInt(playerid, "oldkey"), GetPVarInt(playerid, "treasure"), GetPVarInt(playerid, "goldwatch"), GetPVarInt(playerid, "silvernugget"), GetPVarInt(playerid, "goldnugget"), GetPlayerSQLId(playerid));
	mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	return 1;
}

stock SQL_Log(szQuery[], szDesc[] = "none", iExtraID = 0) {
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

stock LoadFamilies()
{
	printf("[LoadFamilies] Loading data from database...");
	mysql_function_query(MainPipeline, "SELECT * FROM `families`", true, "OnLoadFamilies", "");
}

stock FamilyMemberCount(famid)
{
	new query[56];
	format(query, sizeof(query), "SELECT NULL FROM `accounts` WHERE `FMember` = '%d'", famid);
	mysql_function_query(MainPipeline, query, true, "OnFamilyMemberCount", "i", famid);
	return 1;
}

stock SaveFamily(id) {

	new string[2048];

	format(string, sizeof(string), "UPDATE `families` SET \
		`Taken`=%d, \
		`Name`='%s', \
		`Leader`='%s', \
		`Bank`=%d, \
		`Cash`=%d, \
		`FamilyUSafe`=%d, \
		`FamilySafeX`=%f, \
		`FamilySafeY`=%f, \
		`FamilySafeZ`=%f, \
		`FamilySafeVW`=%d, \
		`FamilySafeInt`=%d, \
		`Pot`=%d, \
		`Crack`=%d, \
		`Mats`=%d, \
		`Heroin`=%d, \
		`Rank0`='%s', \
		`Rank1`='%s', \
		`Rank2`='%s', \
		`Rank3`='%s', \
		`Rank4`='%s', \
		`Rank5`='%s', \
		`Rank6`='%s', \
		`Division0`='%s', \
		`Division1`='%s', \
		`Division2`='%s', \
		`Division3`='%s', \
		`Division4`='%s', ",
		FamilyInfo[id][FamilyTaken],
		g_mysql_ReturnEscaped(FamilyInfo[id][FamilyName], MainPipeline),
		FamilyInfo[id][FamilyLeader],
		FamilyInfo[id][FamilyBank],
		FamilyInfo[id][FamilyCash],
		FamilyInfo[id][FamilyUSafe],
		FamilyInfo[id][FamilySafe][0],
		FamilyInfo[id][FamilySafe][1],
		FamilyInfo[id][FamilySafe][2],
		FamilyInfo[id][FamilySafeVW],
		FamilyInfo[id][FamilySafeInt],
		FamilyInfo[id][FamilyPot],
		FamilyInfo[id][FamilyCrack],
		FamilyInfo[id][FamilyMats],
		FamilyInfo[id][FamilyHeroin],
		g_mysql_ReturnEscaped(FamilyRankInfo[id][0], MainPipeline),
		g_mysql_ReturnEscaped(FamilyRankInfo[id][1], MainPipeline),
		g_mysql_ReturnEscaped(FamilyRankInfo[id][2], MainPipeline),
		g_mysql_ReturnEscaped(FamilyRankInfo[id][3], MainPipeline),
		g_mysql_ReturnEscaped(FamilyRankInfo[id][4], MainPipeline),
		g_mysql_ReturnEscaped(FamilyRankInfo[id][5], MainPipeline),
		g_mysql_ReturnEscaped(FamilyRankInfo[id][6], MainPipeline),
		g_mysql_ReturnEscaped(FamilyDivisionInfo[id][0], MainPipeline),
		g_mysql_ReturnEscaped(FamilyDivisionInfo[id][1], MainPipeline),
		g_mysql_ReturnEscaped(FamilyDivisionInfo[id][2], MainPipeline),
		g_mysql_ReturnEscaped(FamilyDivisionInfo[id][3], MainPipeline),
		g_mysql_ReturnEscaped(FamilyDivisionInfo[id][4], MainPipeline)
	);

	format(string, sizeof(string), "%s\
		`fontface`='%s', \
		`fontsize`=%d, \
		`bold`=%d, \
		`fontcolor`=%d, \
		`gtUsed`=%d, \
		`text`='%s', ",
		string,
		FamilyInfo[id][gt_FontFace],
		FamilyInfo[id][gt_FontSize],
		FamilyInfo[id][gt_Bold],
		FamilyInfo[id][gt_FontColor],
		FamilyInfo[id][gt_SPUsed],
		g_mysql_ReturnEscaped(FamilyInfo[id][gt_Text], MainPipeline)
	);

	format(string, sizeof(string), "%s \
        `MaxSkins`=%d, \
		`Skin1`=%d, \
		`Skin2`=%d, \
		`Skin3`=%d, \
		`Skin4`=%d, \
		`Skin5`=%d, \
		`Skin6`=%d, \
		`Skin7`=%d, \
		`Skin8`=%d, \
		`Color`=%d, \
		`TurfTokens`=%d, \
		`Gun1`=%d, \
		`Gun2`=%d, \
		`Gun3`=%d, \
		`Gun4`=%d, \
		`Gun5`=%d, \
		`Gun6`=%d, \
		`Gun7`=%d, \
		`Gun8`=%d, \
		`Gun9`=%d, \
		`Gun10`=%d, \
		`GtObject`=%d, \
		`MOTD1`='%s', \
		`MOTD2`='%s', \
		`MOTD3`='%s' \
		WHERE `ID` = %d",
		string,
		FamilyInfo[id][FamilyMaxSkins],
		FamilyInfo[id][FamilySkins][0],
		FamilyInfo[id][FamilySkins][1],
		FamilyInfo[id][FamilySkins][2],
		FamilyInfo[id][FamilySkins][3],
		FamilyInfo[id][FamilySkins][4],
		FamilyInfo[id][FamilySkins][5],
		FamilyInfo[id][FamilySkins][6],
		FamilyInfo[id][FamilySkins][7],
		FamilyInfo[id][FamilyColor],
		FamilyInfo[id][FamilyTurfTokens],
		FamilyInfo[id][FamilyGuns][0],
		FamilyInfo[id][FamilyGuns][1],
		FamilyInfo[id][FamilyGuns][2],
		FamilyInfo[id][FamilyGuns][3],
		FamilyInfo[id][FamilyGuns][4],
		FamilyInfo[id][FamilyGuns][5],
		FamilyInfo[id][FamilyGuns][6],
		FamilyInfo[id][FamilyGuns][7],
		FamilyInfo[id][FamilyGuns][8],
		FamilyInfo[id][FamilyGuns][9],
		FamilyInfo[id][gtObject],
		g_mysql_ReturnEscaped(FamilyMOTD[id][0], MainPipeline),
		g_mysql_ReturnEscaped(FamilyMOTD[id][1], MainPipeline),
		g_mysql_ReturnEscaped(FamilyMOTD[id][2], MainPipeline),
		id
	);

	mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);

	return 1;
}

stock SaveFamiliesHQ(id)
{
	if(!( 1 <= id < MAX_FAMILY))
		return 0;

	new query[300];
	format(query, sizeof(query), "UPDATE `families` SET `ExteriorX` = %f, `ExteriorY` = %f, `ExteriorZ` = %f, `ExteriorA` = %f, `InteriorX` = %f, `InteriorY` = %f, `InteriorZ` = %f, `InteriorA` = %f, \
	`INT` = %d, `VW` = %d, `CustomInterior` = %d WHERE ID = %d", FamilyInfo[id][FamilyEntrance][0], FamilyInfo[id][FamilyEntrance][1], FamilyInfo[id][FamilyEntrance][2], FamilyInfo[id][FamilyEntrance][3],
	FamilyInfo[id][FamilyExit][0], FamilyInfo[id][FamilyExit][1], FamilyInfo[id][FamilyExit][2], FamilyInfo[id][FamilyExit][3], FamilyInfo[id][FamilyInterior], FamilyInfo[id][FamilyVirtualWorld],
	FamilyInfo[id][FamilyCustomMap], id);
	mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "ii", SENDDATA_THREAD, INVALID_PLAYER_ID);
	return 1;
}

stock LoadGates()
{
	printf("[LoadGates] Loading data from database...");
	mysql_function_query(MainPipeline, "SELECT * FROM `gates`", true, "OnLoadGates", "");
}

stock SaveDynamicMapIcon(mapiconid)
{
	new string[512];

	format(string, sizeof(string), "UPDATE `dmapicons` SET \
		`MarkerType`=%d, \
		`Color`=%d, \
		`VW`=%d, \
		`Int`=%d, \
		`PosX`=%f, \
		`PosY`=%f, \
		`PosZ`=%f WHERE `id`=%d",
		DMPInfo[mapiconid][dmpMarkerType],
		DMPInfo[mapiconid][dmpColor],
		DMPInfo[mapiconid][dmpVW],
		DMPInfo[mapiconid][dmpInt],
		DMPInfo[mapiconid][dmpPosX],
		DMPInfo[mapiconid][dmpPosY],
		DMPInfo[mapiconid][dmpPosZ],
		mapiconid
	); // Array starts from zero, MySQL starts at 1 (this is why we are adding one).

	mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);
}

stock LoadDynamicMapIcon(mapiconid)
{
	new string[128];
	format(string, sizeof(string), "SELECT * FROM `dmapicons` WHERE `id`=%d", mapiconid);
	mysql_function_query(MainPipeline, string, true, "OnLoadDynamicMapIcon", "i", mapiconid);
}

stock LoadDynamicMapIcons()
{
	printf("[LoadDynamicMapIcons] Loading data from database...");
	mysql_function_query(MainPipeline, "SELECT * FROM `dmapicons`", true, "OnLoadDynamicMapIcons", "");
}

stock SaveDynamicDoor(doorid)
{
	new string[1024];
	format(string, sizeof(string), "UPDATE `ddoors` SET \
		`Description`='%s', \
		`Owner`=%d, \
		`OwnerName`='%s', \
		`CustomInterior`=%d, \
		`ExteriorVW`=%d, \
		`ExteriorInt`=%d, \
		`InteriorVW`=%d, \
		`InteriorInt`=%d, \
		`ExteriorX`=%f, \
		`ExteriorY`=%f, \
		`ExteriorZ`=%f, \
		`ExteriorA`=%f, \
		`InteriorX`=%f, \
		`InteriorY`=%f, \
		`InteriorZ`=%f, \
		`InteriorA`=%f,",
		g_mysql_ReturnEscaped(DDoorsInfo[doorid][ddDescription], MainPipeline),
		DDoorsInfo[doorid][ddOwner],
		g_mysql_ReturnEscaped(DDoorsInfo[doorid][ddOwnerName], MainPipeline),
		DDoorsInfo[doorid][ddCustomInterior],
		DDoorsInfo[doorid][ddExteriorVW],
		DDoorsInfo[doorid][ddExteriorInt],
		DDoorsInfo[doorid][ddInteriorVW],
		DDoorsInfo[doorid][ddInteriorInt],
		DDoorsInfo[doorid][ddExteriorX],
		DDoorsInfo[doorid][ddExteriorY],
		DDoorsInfo[doorid][ddExteriorZ],
		DDoorsInfo[doorid][ddExteriorA],
		DDoorsInfo[doorid][ddInteriorX],
		DDoorsInfo[doorid][ddInteriorY],
		DDoorsInfo[doorid][ddInteriorZ],
		DDoorsInfo[doorid][ddInteriorA]
	);

	format(string, sizeof(string), "%s \
		`CustomExterior`=%d, \
		`Type`=%d, \
		`Rank`=%d, \
		`VIP`=%d, \
		`Famed`=%d, \
		`DPC`=%d, \
		`Allegiance`=%d, \
		`GroupType`=%d, \
		`Family`=%d, \
		`Faction`=%d, \
		`Admin`=%d, \
		`Wanted`=%d, \
		`VehicleAble`=%d, \
		`Color`=%d, \
		`PickupModel`=%d, \
		`Pass`='%s', \
		`Locked`=%d WHERE `id`=%d",
		string,
		DDoorsInfo[doorid][ddCustomExterior],
		DDoorsInfo[doorid][ddType],
		DDoorsInfo[doorid][ddRank],
		DDoorsInfo[doorid][ddVIP],
		DDoorsInfo[doorid][ddFamed],
		DDoorsInfo[doorid][ddDPC],
		DDoorsInfo[doorid][ddAllegiance],
		DDoorsInfo[doorid][ddGroupType],
		DDoorsInfo[doorid][ddFamily],
		DDoorsInfo[doorid][ddFaction],
		DDoorsInfo[doorid][ddAdmin],
		DDoorsInfo[doorid][ddWanted],
		DDoorsInfo[doorid][ddVehicleAble],
		DDoorsInfo[doorid][ddColor],
		DDoorsInfo[doorid][ddPickupModel],
		g_mysql_ReturnEscaped(DDoorsInfo[doorid][ddPass], MainPipeline),
		DDoorsInfo[doorid][ddLocked],
		doorid+1
	); // Array starts from zero, MySQL starts at 1 (this is why we are adding one).

	mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);
}

stock LoadDynamicDoor(doorid)
{
	new string[128];
	format(string, sizeof(string), "SELECT * FROM `ddoors` WHERE `id`=%d", doorid+1); // Array starts at zero, MySQL starts at 1.
	mysql_function_query(MainPipeline, string, true, "OnLoadDynamicDoor", "i", doorid);
}

stock LoadDynamicDoors()
{
	printf("[LoadDynamicDoors] Loading data from database...");
	mysql_function_query(MainPipeline, "SELECT * FROM `ddoors`", true, "OnLoadDynamicDoors", "");
}

stock SaveHouse(houseid)
{
	new string[2048];
	printf("Saving House ID %d", houseid);
	format(string, sizeof(string), "UPDATE `houses` SET \
		`Owned`=%d, \
		`Level`=%d, \
		`Description`='%s', \
		`OwnerID`=%d, \
		`ExteriorX`=%f, \
		`ExteriorY`=%f, \
		`ExteriorZ`=%f, \
		`ExteriorR`=%f, \
		`InteriorX`=%f, \
		`InteriorY`=%f, \
		`InteriorZ`=%f, \
		`InteriorR`=%f, \
		`ExtIW`=%d, \
		`ExtVW`=%d, \
		`IntIW`=%d, \
		`IntVW`=%d,",
		HouseInfo[houseid][hOwned],
		HouseInfo[houseid][hLevel],
		g_mysql_ReturnEscaped(HouseInfo[houseid][hDescription], MainPipeline),
		HouseInfo[houseid][hOwnerID],
		HouseInfo[houseid][hExteriorX],
		HouseInfo[houseid][hExteriorY],
		HouseInfo[houseid][hExteriorZ],
		HouseInfo[houseid][hExteriorR],
		HouseInfo[houseid][hInteriorX],
		HouseInfo[houseid][hInteriorY],
		HouseInfo[houseid][hInteriorZ],
		HouseInfo[houseid][hInteriorR],
		HouseInfo[houseid][hExtIW],
		HouseInfo[houseid][hExtVW],
		HouseInfo[houseid][hIntIW],
		HouseInfo[houseid][hIntVW]
	);

	format(string, sizeof(string), "%s \
		`Lock`=%d, \
		`Rentable`=%d, \
		`RentFee`=%d, \
		`Value`=%d, \
		`SafeMoney`=%d, \
		`Pot`=%d, \
		`Crack`=%d, \
		`Materials`=%d, \
		`Heroin`=%d, \
		`Weapons0`=%d, \
		`Weapons1`=%d, \
		`Weapons2`=%d, \
		`Weapons3`=%d, \
		`Weapons4`=%d, \
		`GLUpgrade`=%d, \
		`CustomInterior`=%d, \
		`CustomExterior`=%d, \
		`ExteriorA`=%f, \
		`InteriorA`=%f, \
		`MailX`=%f, \
		`MailY`=%f, \
		`MailZ`=%f, \
		`MailA`=%f, \
		`MailType`=%d, \
		`ClosetX`=%f, \
		`ClosetY`=%f, \
		`ClosetZ`=%f WHERE `id`=%d",
		string,
		HouseInfo[houseid][hLock],
		HouseInfo[houseid][hRentable],
		HouseInfo[houseid][hRentFee],
		HouseInfo[houseid][hValue],
   		HouseInfo[houseid][hSafeMoney],
		HouseInfo[houseid][hPot],
		HouseInfo[houseid][hCrack],
		HouseInfo[houseid][hMaterials],
		HouseInfo[houseid][hHeroin],
		HouseInfo[houseid][hWeapons][0],
		HouseInfo[houseid][hWeapons][1],
		HouseInfo[houseid][hWeapons][2],
		HouseInfo[houseid][hWeapons][3],
		HouseInfo[houseid][hWeapons][4],
		HouseInfo[houseid][hGLUpgrade],
		HouseInfo[houseid][hCustomInterior],
		HouseInfo[houseid][hCustomExterior],
		HouseInfo[houseid][hExteriorA],
		HouseInfo[houseid][hInteriorA],
		HouseInfo[houseid][hMailX],
		HouseInfo[houseid][hMailY],
		HouseInfo[houseid][hMailZ],
		HouseInfo[houseid][hMailA],
		HouseInfo[houseid][hMailType],
		HouseInfo[houseid][hClosetX],
		HouseInfo[houseid][hClosetY],
		HouseInfo[houseid][hClosetZ],
		houseid+1
	); // Array starts from zero, MySQL starts at 1 (this is why we are adding one).

	mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);
}

stock LoadHouse(houseid)
{
	new string[128];
	printf("[LoadHouse] Loading HouseID %d's data from database...", houseid);
	format(string, sizeof(string), "SELECT OwnerName.Username, h.* FROM houses h LEFT JOIN accounts OwnerName ON h.OwnerID = OwnerName.id WHERE `id` = %d", houseid+1); // Array starts at zero, MySQL starts at one.
	mysql_function_query(MainPipeline, string, true, "OnLoadHouse", "i", houseid);
}

stock LoadHouses()
{
	printf("[LoadHouses] Loading data from database...");
	mysql_function_query(MainPipeline, "SELECT OwnerName.Username, h.* FROM houses h LEFT JOIN accounts OwnerName ON h.OwnerID = OwnerName.id", true, "OnLoadHouses", "");
}

stock LoadMailboxes()
{
	printf("[LoadMailboxes] Loading data from database...");
	mysql_function_query(MainPipeline, "SELECT * FROM `mailboxes`", true, "OnLoadMailboxes", "");
}

stock LoadPoints()
{
	printf("[LoadFamilyPoints] Loading Family Points from the database, please wait...");
	mysql_function_query(MainPipeline, "SELECT * FROM `points`", true, "OnLoadPoints", "");
}		

stock LoadHGBackpacks()
{
	printf("[Loading Hunger Games] Loading Hunger Games Backpacks from the database, please wait...");
	mysql_function_query(MainPipeline,  "SELECT * FROM `hgbackpacks`", true, "OnLoadHGBackpacks", "");
}

stock SaveMailbox(id)
{
	new string[512];

	format(string, sizeof(string), "UPDATE `mailboxes` SET \
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

	mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);
}

stock SaveSpeedCamera(i)
{
	if (SpeedCameras[i][_scActive] != true)
		return;

	new query[1024];
	format(query, sizeof(query), "UPDATE speed_cameras SET pos_x=%f, pos_y=%f, pos_z=%f, rotation=%f, `range`=%f, speed_limit=%f WHERE id=%i",
		SpeedCameras[i][_scPosX], SpeedCameras[i][_scPosY], SpeedCameras[i][_scPosZ], SpeedCameras[i][_scRotation], SpeedCameras[i][_scRange], SpeedCameras[i][_scLimit],
		SpeedCameras[i][_scDatabase]);

	mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
}

stock LoadSpeedCameras()
{
	printf("[SpeedCameras] Loading data from database...");
	mysql_function_query(MainPipeline, "SELECT * FROM speed_cameras", true, "OnLoadSpeedCameras", "");

	return 1;
}

stock StoreNewSpeedCameraInMySQL(index)
{
	new string[512];
	format(string, sizeof(string), "INSERT INTO speed_cameras (pos_x, pos_y, pos_z, rotation, `range`, speed_limit) VALUES (%f, %f, %f, %f, %f, %f)",
		SpeedCameras[index][_scPosX], SpeedCameras[index][_scPosY], SpeedCameras[index][_scPosZ], SpeedCameras[index][_scRotation], SpeedCameras[index][_scRange], SpeedCameras[index][_scLimit]);

	mysql_function_query(MainPipeline, string, true, "OnNewSpeedCamera", "i", index);
	return 1;
}

stock SaveTxtLabel(labelid)
{
	new string[1024];
	format(string, sizeof(string), "UPDATE `text_labels` SET \
		`Text`='%s', \
		`PosX`=%f, \
		`PosY`=%f, \
		`PosZ`=%f, \
		`VW`=%d, \
		`Int`=%d, \
		`Color`=%d, \
		`PickupModel`=%d WHERE `id`=%d",
		g_mysql_ReturnEscaped(TxtLabels[labelid][tlText], MainPipeline),
		TxtLabels[labelid][tlPosX],
		TxtLabels[labelid][tlPosY],
		TxtLabels[labelid][tlPosZ],
		TxtLabels[labelid][tlVW],
		TxtLabels[labelid][tlInt],
		TxtLabels[labelid][tlColor],
		TxtLabels[labelid][tlPickupModel],
		labelid+1
	); // Array starts from zero, MySQL starts at 1 (this is why we are adding one).

	mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);
}

stock LoadTxtLabel(labelid)
{
	new string[128];
	format(string, sizeof(string), "SELECT * FROM `text_labels` WHERE `id`=%d", labelid+1); // Array starts at zero, MySQL starts at 1.
	mysql_function_query(MainPipeline, string, true, "OnLoadTxtLabel", "i", labelid);
}

stock LoadTxtLabels()
{
	printf("[LoadTxtLabels] Loading data from database...");
	mysql_function_query(MainPipeline, "SELECT * FROM `text_labels`", true, "OnLoadTxtLabels", "");
}

stock SavePayNSpray(id)
{
	new string[1024];
	format(string, sizeof(string), "UPDATE `paynsprays` SET \
		`Status`=%d, \
		`PosX`=%f, \
		`PosY`=%f, \
		`PosZ`=%f, \
		`VW`=%d, \
		`Int`=%d, \
		`GroupCost`=%d, \
		`RegCost`=%d WHERE `id`=%d",
		PayNSprays[id][pnsStatus],
		PayNSprays[id][pnsPosX],
		PayNSprays[id][pnsPosY],
		PayNSprays[id][pnsPosZ],
		PayNSprays[id][pnsVW],
		PayNSprays[id][pnsInt],
		PayNSprays[id][pnsGroupCost],
		PayNSprays[id][pnsRegCost],
		id
	);

	mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);
}

stock SavePayNSprays()
{
	for(new i = 0; i < MAX_PAYNSPRAYS; i++)
	{
		SavePayNSpray(i);
	}
	return 1;
}

stock RehashPayNSpray(id)
{
	DestroyDynamicPickup(PayNSprays[id][pnsPickupID]);
	DestroyDynamic3DTextLabel(PayNSprays[id][pnsTextID]);
	DestroyDynamicMapIcon(PayNSprays[id][pnsMapIconID]);
	PayNSprays[id][pnsSQLId] = -1;
	PayNSprays[id][pnsStatus] = 0;
	PayNSprays[id][pnsPosX] = 0.0;
	PayNSprays[id][pnsPosY] = 0.0;
	PayNSprays[id][pnsPosZ] = 0.0;
	PayNSprays[id][pnsVW] = 0;
	PayNSprays[id][pnsInt] = 0;
	PayNSprays[id][pnsGroupCost] = 0;
	PayNSprays[id][pnsRegCost] = 0;
	LoadPayNSpray(id);
}

stock RehashPayNSprays()
{
	printf("[RehashPayNSprays] Deleting Pay N' Sprays from server...");
	for(new i = 0; i < MAX_PAYNSPRAYS; i++)
	{
		RehashPayNSpray(i);
	}
	LoadPayNSprays();
}

stock LoadPayNSpray(id)
{
	new string[128];
	format(string, sizeof(string), "SELECT * FROM `paynsprays` WHERE `id`=%d", id);
	mysql_function_query(MainPipeline, string, true, "OnLoadPayNSprays", "i", id);
}

stock IsAdminSpawnedVehicle(vehicleid)
{
	for(new i = 0; i < sizeof(CreatedCars); ++i) {
		if(CreatedCars[i] == vehicleid) return 1;
	}
	return 0;
}

forward OnLoadPayNSpray(index);
public OnLoadPayNSpray(index)
{
	new rows, fields, tmp[128], string[128];
	cache_get_data(rows, fields, MainPipeline);

	for(new row; row < rows; row++)
	{
		cache_get_field_content(row, "id", tmp, MainPipeline);  PayNSprays[index][pnsSQLId] = strval(tmp);
		cache_get_field_content(row, "Status", tmp, MainPipeline); PayNSprays[index][pnsStatus] = strval(tmp);
		cache_get_field_content(row, "PosX", tmp, MainPipeline); PayNSprays[index][pnsPosX] = floatstr(tmp);
		cache_get_field_content(row, "PosY", tmp, MainPipeline); PayNSprays[index][pnsPosY] = floatstr(tmp);
		cache_get_field_content(row, "PosZ", tmp, MainPipeline); PayNSprays[index][pnsPosZ] = floatstr(tmp);
		cache_get_field_content(row, "VW", tmp, MainPipeline); PayNSprays[index][pnsVW] = strval(tmp);
		cache_get_field_content(row, "Int", tmp, MainPipeline); PayNSprays[index][pnsInt] = strval(tmp);
		cache_get_field_content(row, "GroupCost", tmp, MainPipeline); PayNSprays[index][pnsGroupCost] = strval(tmp);
		cache_get_field_content(row, "RegCost", tmp, MainPipeline); PayNSprays[index][pnsRegCost] = strval(tmp);
		if(PayNSprays[index][pnsStatus] > 0)
		{
			format(string, sizeof(string), "/repaircar\nRepair Cost -- Regular: $%s | Faction: $%s\nID: %d", number_format(PayNSprays[index][pnsRegCost]), number_format(PayNSprays[index][pnsGroupCost]), index);
			PayNSprays[index][pnsTextID] = CreateDynamic3DTextLabel(string, COLOR_RED, PayNSprays[index][pnsPosX], PayNSprays[index][pnsPosY], PayNSprays[index][pnsPosZ]+0.5,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, PayNSprays[index][pnsVW], PayNSprays[index][pnsInt], -1);
			PayNSprays[index][pnsPickupID] = CreateDynamicPickup(1239, 23, PayNSprays[index][pnsPosX], PayNSprays[index][pnsPosY], PayNSprays[index][pnsPosZ], PayNSprays[index][pnsVW]);
			PayNSprays[index][pnsMapIconID] = CreateDynamicMapIcon(PayNSprays[index][pnsPosX], PayNSprays[index][pnsPosY], PayNSprays[index][pnsPosZ], 63, 0, PayNSprays[index][pnsVW], PayNSprays[index][pnsInt], -1, 500.0);
		}
	}
	return 1;
}

stock LoadPayNSprays()
{
	printf("[LoadPayNSprays] Loading data from database...");
	mysql_function_query(MainPipeline, "SELECT * FROM `paynsprays`", true, "OnLoadPayNSprays", "");
}

stock SaveArrestPoint(id)
{
	new string[1024];
	format(string, sizeof(string), "UPDATE `arrestpoints` SET \
		`PosX`=%f, \
		`PosY`=%f, \
		`PosZ`=%f, \
		`VW`=%d, \
		`Int`=%d, \
		`Type`=%d WHERE `id`=%d",
		ArrestPoints[id][arrestPosX],
		ArrestPoints[id][arrestPosY],
		ArrestPoints[id][arrestPosZ],
		ArrestPoints[id][arrestVW],
		ArrestPoints[id][arrestInt],
		ArrestPoints[id][arrestType],
		id
	);

	mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);
}

stock SaveArrestPoints()
{
	for(new i = 0; i < MAX_ARRESTPOINTS; i++)
	{
		SaveArrestPoint(i);
	}
	return 1;
}

stock RehashArrestPoint(id)
{
	DestroyDynamic3DTextLabel(ArrestPoints[id][arrestTextID]);
	DestroyDynamicPickup(ArrestPoints[id][arrestPickupID]);
	ArrestPoints[id][arrestSQLId] = -1;
	ArrestPoints[id][arrestPosX] = 0.0;
	ArrestPoints[id][arrestPosY] = 0.0;
	ArrestPoints[id][arrestPosZ] = 0.0;
	ArrestPoints[id][arrestVW] = 0;
	ArrestPoints[id][arrestInt] = 0;
	ArrestPoints[id][arrestType] = 0;
	LoadArrestPoint(id);
}

stock RehashArrestPoints()
{
	printf("[RehashArrestPoints] Deleting Arrest Points from server...");
	for(new i = 0; i < MAX_ARRESTPOINTS; i++)
	{
		RehashArrestPoint(i);
	}
	LoadArrestPoints();
}

stock LoadArrestPoint(id)
{
	new string[128];
	format(string, sizeof(string), "SELECT * FROM `arrestpoints` WHERE `id`=%d", id);
	mysql_function_query(MainPipeline, string, true, "OnLoadArrestPoints", "i", id);
}

stock LoadArrestPoints()
{
	printf("[LoadArrestPoints] Loading data from database...");
	mysql_function_query(MainPipeline, "SELECT * FROM `arrestpoints`", true, "OnLoadArrestPoints", "");
}

stock SaveImpoundPoint(id)
{
	new string[1024];
	format(string, sizeof(string), "UPDATE `impoundpoints` SET \
		`PosX`=%f, \
		`PosY`=%f, \
		`PosZ`=%f, \
		`VW`=%d, \
		`Int`=%d WHERE `id`=%d",
		ImpoundPoints[id][impoundPosX],
		ImpoundPoints[id][impoundPosY],
		ImpoundPoints[id][impoundPosZ],
		ImpoundPoints[id][impoundVW],
		ImpoundPoints[id][impoundInt],
		id
	);

	mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);
}

stock SaveImpoundPoints()
{
	for(new i = 0; i < MAX_ImpoundPoints; i++)
	{
		SaveImpoundPoint(i);
	}
	return 1;
}

stock RehashImpoundPoint(id)
{
	DestroyDynamic3DTextLabel(ImpoundPoints[id][impoundTextID]);
	ImpoundPoints[id][impoundSQLId] = -1;
	ImpoundPoints[id][impoundPosX] = 0.0;
	ImpoundPoints[id][impoundPosY] = 0.0;
	ImpoundPoints[id][impoundPosZ] = 0.0;
	ImpoundPoints[id][impoundVW] = 0;
	ImpoundPoints[id][impoundInt] = 0;
	LoadImpoundPoint(id);
}

stock RehashImpoundPoints()
{
	printf("[RehashImpoundPoints] Deleting impound Points from server...");
	for(new i = 0; i < MAX_ImpoundPoints; i++)
	{
		RehashImpoundPoint(i);
	}
	LoadImpoundPoints();
}

stock LoadImpoundPoint(id)
{
	new string[128];
	format(string, sizeof(string), "SELECT * FROM `impoundpoints` WHERE `id`=%d", id);
	mysql_function_query(MainPipeline, string, true, "OnLoadImpoundPoints", "i", id);
}

stock LoadImpoundPoints()
{
	printf("[LoadImpoundPoints] Loading data from database...");
	mysql_function_query(MainPipeline, "SELECT * FROM `impoundpoints`", true, "OnLoadImpoundPoints", "");
}

// credits to Luk0r
stock MySQLUpdateBuild(query[], sqlplayerid)
{
	new querylen = strlen(query);
	if (!query[0]) {
		format(query, 2048, "UPDATE `accounts` SET ");
	}
	else if (2048-querylen < 200)
	{
		new whereclause[32];
		format(whereclause, sizeof(whereclause), " WHERE `id`=%d", sqlplayerid);
		strcat(query, whereclause, 2048);
		mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
		format(query, 2048, "UPDATE `accounts` SET ");
	}
	else if (strfind(query, "=", true) != -1) strcat(query, ",", 2048);
	return 1;
}

stock MySQLUpdateFinish(query[], sqlplayerid)
{
	if (strcmp(query, "WHERE id=", false) == 0) mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	else
	{
		new whereclause[32];
		format(whereclause, sizeof(whereclause), " WHERE id=%d", sqlplayerid);
		strcat(query, whereclause, 2048);
		printf("Query size 2048 Query Length %d", strlen(query));
		mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
		format(query, 2048, "UPDATE `accounts` SET ");
	}
	return 1;
}

stock SavePlayerInteger(query[], sqlid, Value[], Integer)
{
	MySQLUpdateBuild(query, sqlid);
	new updval[64];
	format(updval, sizeof(updval), "`%s`=%d", Value, Integer);
	strcat(query, updval, 2048);
	return 1;
}


stock SavePlayerString(query[], sqlid, Value[], String[])
{
	MySQLUpdateBuild(query, sqlid);
	new escapedstring[160], string[160];
	mysql_real_escape_string(String, escapedstring);
	format(string, sizeof(string), "`%s`='%s'", Value, escapedstring);
	strcat(query, string, 2048);
	return 1;
}

stock SavePlayerFloat(query[], sqlid, Value[], Float:Number)
{
	new flotostr[32];
	format(flotostr, sizeof(flotostr), "%0.2f", Number);
	SavePlayerString(query, sqlid, Value, flotostr);
	return 1;
}

stock g_mysql_SaveAccount(playerid)
{
    new query[2048];
	
	format(query, 2048, "UPDATE `accounts` SET `SPos_x` = '%0.2f', `SPos_y` = '%0.2f', `SPos_z` = '%0.2f', `SPos_r` = '%0.2f' WHERE id = '%d'",PlayerInfo[playerid][pPos_x], PlayerInfo[playerid][pPos_y], PlayerInfo[playerid][pPos_z], PlayerInfo[playerid][pPos_r], GetPlayerSQLId(playerid));
	mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	
    format(query, 2048, "UPDATE `accounts` SET ");
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
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Pot", PlayerInfo[playerid][pPot]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Crack", PlayerInfo[playerid][pCrack]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Nation", PlayerInfo[playerid][pNation]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Leader", PlayerInfo[playerid][pLeader]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Member", PlayerInfo[playerid][pMember]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Division", PlayerInfo[playerid][pDivision]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "FMember", PlayerInfo[playerid][pFMember]);

    SavePlayerInteger(query, GetPlayerSQLId(playerid), "Rank", PlayerInfo[playerid][pRank]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "DetSkill", PlayerInfo[playerid][pDetSkill]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "SexSkill", PlayerInfo[playerid][pSexSkill]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "BoxSkill", PlayerInfo[playerid][pBoxSkill]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "LawSkill", PlayerInfo[playerid][pLawSkill]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "MechSkill", PlayerInfo[playerid][pMechSkill]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "TruckSkill", PlayerInfo[playerid][pTruckSkill]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "DrugsSkill", PlayerInfo[playerid][pDrugsSkill]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "ArmsSkill", PlayerInfo[playerid][pArmsSkill]);
    SavePlayerInteger(query, GetPlayerSQLId(playerid), "SmugglerSkill", PlayerInfo[playerid][pSmugSkill]);
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
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Heroin", PlayerInfo[playerid][pHeroin]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Syringe", PlayerInfo[playerid][pSyringes]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Skins", PlayerInfo[playerid][pSkins]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "Hunger", PlayerInfo[playerid][pHunger]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "HungerTimer", PlayerInfo[playerid][pHungerTimer]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "HungerDeathTimer", PlayerInfo[playerid][pHungerDeathTimer]);
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
	// Seriously, please save some lines! - Akatony
	new szForLoop[16];
	for(new x = 0; x < 10; x++)
	{	
		format(szForLoop, sizeof(szForLoop), "BItem%d", x);
		SavePlayerInteger(query, GetPlayerSQLId(playerid), szForLoop, PlayerInfo[playerid][pBItems][x]);
	}

	for(new x = 0; x < 12; x++)
	{
		format(szForLoop, sizeof(szForLoop), "Gun%d", x);
		SavePlayerInteger(query, GetPlayerSQLId(playerid), szForLoop, PlayerInfo[playerid][pGuns][x]);
	}
	
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "NewbieTogged", PlayerInfo[playerid][pNewbieTogged]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "VIPTogged", PlayerInfo[playerid][pVIPTogged]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "FamedTogged", PlayerInfo[playerid][pFamedTogged]);
	
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "BRTimeout", PlayerInfo[playerid][pBugReportTimeout]);
	
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "ToolBox", PlayerInfo[playerid][pToolBox]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "CrowBar", PlayerInfo[playerid][pCrowBar]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "CarLockPickSkill", PlayerInfo[playerid][pCarLockPickSkill]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "LockPickVehCount", PlayerInfo[playerid][pLockPickVehCount]);
	SavePlayerInteger(query, GetPlayerSQLId(playerid), "LockPickTime", PlayerInfo[playerid][pLockPickTime]);
	
	
	
	MySQLUpdateFinish(query, GetPlayerSQLId(playerid));
	return 1;
}

stock SaveGate(id) {
	new string[512];
	format(string, sizeof(string), "UPDATE `gates` SET \
		`HID`=%d, \
		`Speed`=%f, \
		`Range`=%f, \
		`Model`=%d, \
		`VW`=%d, \
		`Int`=%d, \
		`Pass`='%s', \
		`PosX`=%f, \
		`PosY`=%f, \
		`PosZ`=%f, \
		`RotX`=%f, \
		`RotY`=%f, \
		`RotZ`=%f, \
		`PosXM`=%f, \
		`PosYM`=%f, \
		`PosZM`=%f, \
		`RotXM`=%f, \
		`RotYM`=%f, \
		`RotZM`=%f, \
		`Allegiance`=%d, \
		`GroupType`=%d, \
		`GroupID`=%d, \
		`FamilyID`=%d, \
		`RenderHQ`=%d, \
		`Timer`=%d, \
		`Automate`=%d, \
		`Locked`=%d \
		WHERE `ID` = %d",
		GateInfo[id][gHID],
		GateInfo[id][gSpeed],
		GateInfo[id][gRange],
		GateInfo[id][gModel],
		GateInfo[id][gVW],
		GateInfo[id][gInt],
		g_mysql_ReturnEscaped(GateInfo[id][gPass], MainPipeline),
		GateInfo[id][gPosX],
		GateInfo[id][gPosY],
		GateInfo[id][gPosZ],
		GateInfo[id][gRotX],
		GateInfo[id][gRotY],
		GateInfo[id][gRotZ],
		GateInfo[id][gPosXM],
		GateInfo[id][gPosYM],
		GateInfo[id][gPosZM],
		GateInfo[id][gRotXM],
		GateInfo[id][gRotYM],
		GateInfo[id][gRotZM],
		GateInfo[id][gAllegiance],
		GateInfo[id][gGroupType],
		GateInfo[id][gGroupID],
		GateInfo[id][gFamilyID],
		GateInfo[id][gRenderHQ],
		GateInfo[id][gTimer],
		GateInfo[id][gAutomate],
		GateInfo[id][gLocked],
		id+1
	);
	mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	return 0;
}

stock SaveAuction(auction) {
	new query[200];
	format(query, sizeof(query), "UPDATE `auctions` SET");
	format(query, sizeof(query), "%s `BiddingFor` = '%s', `InProgress` = %d, `Bid` = %d, `Bidder` = %d, `Expires` = %d, `Wining` = '%s', `Increment` = %d", query, g_mysql_ReturnEscaped(Auctions[auction][BiddingFor], MainPipeline), Auctions[auction][InProgress], Auctions[auction][Bid], Auctions[auction][Bidder], Auctions[auction][Expires], g_mysql_ReturnEscaped(Auctions[auction][Wining], MainPipeline), Auctions[auction][Increment]);
    format(query, sizeof(query), "%s WHERE `id` = %d", query, auction+1);
    mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "ii", SENDDATA_THREAD, INVALID_PLAYER_ID);
}

stock SaveDealershipSpawn(businessid) {
	new query[200];
	format(query, sizeof(query), "UPDATE `businesses` SET");
	format(query, sizeof(query), "%s `PurchaseX` = %0.5f, `PurchaseY` = %0.5f, `PurchaseZ` = %0.5f, `PurchaseAngle` = %0.5f", query, Businesses[businessid][bPurchaseX], Businesses[businessid][bPurchaseY], Businesses[businessid][bPurchaseZ], Businesses[businessid][bPurchaseAngle]);
    format(query, sizeof(query), "%s WHERE `Id` = %d", query, businessid+1);
    mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "ii", SENDDATA_THREAD, INVALID_PLAYER_ID);
}

stock SaveDealershipVehicle(businessid, slotid)
{
	new query[256];
	//slotid++;
	format(query, sizeof(query), "UPDATE `businesses` SET");
	format(query, sizeof(query), "%s `Car%dPosX` = %0.5f,", query, slotid, Businesses[businessid][bParkPosX][slotid]);
	format(query, sizeof(query), "%s `Car%dPosY` = %0.5f,", query, slotid, Businesses[businessid][bParkPosY][slotid]);
	format(query, sizeof(query), "%s `Car%dPosZ` = %0.5f,", query, slotid, Businesses[businessid][bParkPosZ][slotid]);
	format(query, sizeof(query), "%s `Car%dPosAngle` = %0.5f,", query, slotid, Businesses[businessid][bParkAngle][slotid]);
	format(query, sizeof(query), "%s `Car%dModelId` = %d,", query, slotid, Businesses[businessid][bModel][slotid]);
	format(query, sizeof(query), "%s `Car%dPrice` = %d", query, slotid, Businesses[businessid][bPrice][slotid]);
	format(query, sizeof(query), "%s WHERE `Id` = %d", query, businessid+1);
	mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "ii", SENDDATA_THREAD, INVALID_PLAYER_ID);
}

stock GetLatestKills(playerid, giveplayerid)
{
	new query[256];
	format(query, sizeof(query), "SELECT Killer.Username, Killed.Username, k.* FROM kills k LEFT JOIN accounts Killed ON k.killedid = Killed.id LEFT JOIN accounts Killer ON Killer.id = k.killerid WHERE k.killerid = %d OR k.killedid = %d ORDER BY `date` DESC LIMIT 10", GetPlayerSQLId(giveplayerid), GetPlayerSQLId(giveplayerid));
	mysql_function_query(MainPipeline, query, true, "OnGetLatestKills", "ii", playerid, giveplayerid);
}

stock GetSMSLog(playerid)
{
	new query[256];
	format(query, sizeof(query), "SELECT `sender`, `sendernumber`, `message`, `date` FROM `sms` WHERE `receiverid` = %d ORDER BY `date` DESC LIMIT 10", GetPlayerSQLId(playerid));
	mysql_function_query(MainPipeline, query, true, "OnGetSMSLog", "i", playerid);
}

stock LoadBusinessSales() {

	print("[LoadBusinessSales] Loading data from database...");
	mysql_function_query(MainPipeline, "SELECT * FROM `businesssales`", true, "LoadBusinessesSaless", "");
}

stock LoadBusinesses() {
	printf("[LoadBusinesses] Loading data from database...");
	mysql_function_query(MainPipeline, "SELECT OwnerName.Username, b.* FROM businesses b LEFT JOIN accounts OwnerName ON b.OwnerID = OwnerName.id", true, "BusinessesLoadQueryFinish", "");
}

stock LoadAuctions() {
	printf("[LoadAuctions] Loading data from database...");
	mysql_function_query(MainPipeline, "SELECT * FROM `auctions`", true, "AuctionLoadQuery", "");
}

stock LoadPlants() {
	printf("[LoadPlants] Loading data from database...");
	mysql_function_query(MainPipeline, "SELECT * FROM `plants`", true, "PlantsLoadQuery", "");
}

stock SaveBusinessSale(id)
{
	new query[200];
	format(query, 200, "UPDATE `businesssales` SET `BusinessID` = '%d', `Text` = '%s', `Price` = '%d', `Available` = '%d', `Purchased` = '%d', `Type` = '%d' WHERE `bID` = '%d'", BusinessSales[id][bBusinessID], BusinessSales[id][bText],
	BusinessSales[id][bPrice], BusinessSales[id][bAvailable], BusinessSales[id][bPurchased], BusinessSales[id][bType], BusinessSales[id][bID]);
	mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	printf("[BusinessSale] saved %i", id);
	return 1;
}

stock SavePlant(plant)
{
	new query[300];
	format(query, sizeof(query), "UPDATE `plants` SET `Owner` = %d, `Object` = %d, `PlantType` = %d, `PositionX` = %f, `PositionY` = %f, `PositionZ` = %f, `Virtual` = %d, \
	`Interior` = %d, `Growth` = %d, `Expires` = %d, `DrugsSkill` = %d WHERE `PlantID` = %d",Plants[plant][pOwner], Plants[plant][pObject], Plants[plant][pPlantType], Plants[plant][pPos][0], Plants[plant][pPos][1], Plants[plant][pPos][2],
	Plants[plant][pVirtual], Plants[plant][pInterior], Plants[plant][pGrowth], Plants[plant][pExpires], Plants[plant][pDrugsSkill], plant+1);
	mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	return 1;
}

stock SaveBusiness(id)
{
	new query[4019];

	format(query, sizeof(query), "UPDATE `businesses` SET ");

	format(query, sizeof(query), "%s \
	`Name` = '%s', `Type` = %d, `Value` = %d, `OwnerID` = %d, `Months` = %d, `SafeBalance` = %d, `Inventory` = %d, `InventoryCapacity` = %d, `Status` = %d, `Level` = %d, \
	`LevelProgress` = %d, `AutoSale` = %d, `OrderDate` = '%s', `OrderAmount` = %d, `OrderBy` = '%s', `OrderState` = %d, `TotalSales` = %d, ",
	query,
	g_mysql_ReturnEscaped(Businesses[id][bName], MainPipeline), Businesses[id][bType], Businesses[id][bValue], Businesses[id][bOwner], Businesses[id][bMonths], Businesses[id][bSafeBalance], Businesses[id][bInventory], Businesses[id][bInventoryCapacity], Businesses[id][bStatus], Businesses[id][bLevel],
	Businesses[id][bLevelProgress], Businesses[id][bAutoSale], Businesses[id][bOrderDate], Businesses[id][bOrderAmount], g_mysql_ReturnEscaped(Businesses[id][bOrderBy], MainPipeline), Businesses[id][bOrderState], Businesses[id][bTotalSales]);

	format(query, sizeof(query), "%s \
	`ExteriorX` = %f, `ExteriorY` = %f, `ExteriorZ` = %f, `ExteriorA` = %f, \
	`InteriorX` = %f, `InteriorY` = %f, `InteriorZ` = %f, `InteriorA` = %f, \
	`Interior` = %d, `CustomExterior` = %d, `CustomInterior` = %d, `Grade` = %d, `CustomVW` = %d, `SupplyPointX` = %f, `SupplyPointY` = %f, `SupplyPointZ` = %f, ",
	query,
	Businesses[id][bExtPos][0],	Businesses[id][bExtPos][1],	Businesses[id][bExtPos][2],	Businesses[id][bExtPos][3],
	Businesses[id][bIntPos][0],	Businesses[id][bIntPos][1], Businesses[id][bIntPos][2], Businesses[id][bIntPos][3],
	Businesses[id][bInt], Businesses[id][bCustomExterior], Businesses[id][bCustomInterior], Businesses[id][bGrade], Businesses[id][bVW], Businesses[id][bSupplyPos][0],Businesses[id][bSupplyPos][1], Businesses[id][bSupplyPos][2]);

	for (new i; i < sizeof(StoreItems); i++) format(query, sizeof(query), "%s`Item%dPrice` = %d, ", query, i+1, Businesses[id][bItemPrices][i]);
	for (new i; i < 5; i++)	format(query, sizeof(query), "%s`Rank%dPay` = %d, ", query, i, Businesses[id][bRankPay][i], id);
	for (new i; i < MAX_BUSINESS_GAS_PUMPS; i++) format(query, sizeof(query), "%s `GasPump%dPosX` = %f, `GasPump%dPosY` = %f, `GasPump%dPosZ` = %f, `GasPump%dAngle` = %f, `GasPump%dModel` = %d, `GasPump%dCapacity` = %f, `GasPump%dGas` = %f, ", query, i+1, Businesses[id][GasPumpPosX][i],	i+1, Businesses[id][GasPumpPosY][i], i+1, Businesses[id][GasPumpPosZ][i], i+1, Businesses[id][GasPumpAngle][i], i+1, 1646,i+1, Businesses[id][GasPumpCapacity],	i+1, Businesses[id][GasPumpGallons]);

	format(query, sizeof(query), "%s \
	`Pay` = %d, `GasPrice` = %f, `MinInviteRank` = %d, `MinSupplyRank` = %d, `MinGiveRankRank` = %d, `MinSafeRank` = %d, `GymEntryFee` = %d, `GymType` = %d, `TotalProfits` = %d WHERE `Id` = %d",
	query,
	Businesses[id][bAutoPay], Businesses[id][bGasPrice], Businesses[id][bMinInviteRank], Businesses[id][bMinSupplyRank], Businesses[id][bMinGiveRankRank], Businesses[id][bMinSafeRank], Businesses[id][bGymEntryFee], Businesses[id][bGymType], Businesses[id][bTotalProfits], id+1);

	mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);

 	//printf("Len :%d", strlen(query));
	printf("[business] saved %i", id);

	return 1;
}

//--------------------------------[ CUSTOM PUBLIC FUNCTIONS ]---------------------------

forward OnPhoneNumberCheck(index, extraid);
public OnPhoneNumberCheck(index, extraid)
{
	if(IsPlayerConnected(index))
	{
		new string[128];
		new rows, fields;
		cache_get_data(rows, fields, MainPipeline);

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
					ShowPlayerDialog(index, VIPNUMMENU2, DIALOG_STYLE_MSGBOX, "Confirmation", string, "OK", "Cancel");
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
					format(string, sizeof(string), "UPDATE `accounts` SET `PhoneNr` = %d WHERE `id` = '%d'", PlayerInfo[index][pPnumber], GetPlayerSQLId(index));
					mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "ii", SENDDATA_THREAD, index);
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
					format(string, sizeof(string), "   %s's Phone Number has been set to %d.", GetPlayerNameEx(index), GetPVarInt(index, "WantedPh"));

					format(string, sizeof(string), "%s by %s", string, GetPlayerNameEx(index));
					Log("logs/undercover.log", string);
					SendClientMessageEx(index, COLOR_GRAD1, string);
					format(string, sizeof(string), "UPDATE `accounts` SET `PhoneNr` = %d WHERE `id` = '%d'", PlayerInfo[index][pPnumber], GetPlayerSQLId(index));
					mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "ii", SENDDATA_THREAD, index);
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
						format(string, sizeof(string), "   %s's Phone Number has been set to %d.", GetPlayerNameEx(index), GetPVarInt(index, "WantedPh"));

						format(string, sizeof(string), "%s by %s", string, GetPlayerNameEx(GetPVarInt(index, "PhChangerId")));
						Log("logs/stats.log", string);
						SendClientMessageEx(GetPVarInt(index, "PhChangerId"), COLOR_GRAD1, string);
						format(string, sizeof(string), "UPDATE `accounts` SET `PhoneNr` = %d WHERE `id` = '%d'", PlayerInfo[index][pPnumber], GetPlayerSQLId(index));
						mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "ii", SENDDATA_THREAD, index);
						DeletePVar(index, "PhChangerId");
						DeletePVar(index, "WantedPh");
						DeletePVar(index, "PhChangeCost");
						DeletePVar(index, "CurrentPh");
					}
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
    		cache_get_data(rows, fields, MainPipeline);
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
    		    	new string[150], reason[64];
    		    	GetPVarString(index, "BanningReason", reason, sizeof(reason));

		    	    format(string, sizeof(string), "INSERT INTO `ip_bans` (`ip`, `date`, `reason`, `admin`) VALUES ('%s', NOW(), '%s', '%s')", GetPlayerIpEx(GetPVarInt(index, "BanningPlayer")), reason, GetPlayerNameEx(index));
					mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);

					DeletePVar(index, "BanningPlayer");
		    	    DeletePVar(index, "BanningReason");
				}
	    	}
		}
		else if(type == 2) // Unban IP
		{
		    new rows, fields;
		    cache_get_data(rows, fields, MainPipeline);
		    if(rows)
		    {
		        new string[128], ip[32];
		        GetPVarString(index, "UnbanIP", ip, sizeof(ip));

		        format(string, sizeof(string), "DELETE FROM `ip_bans` WHERE `ip` = '%s'", ip);
				mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);

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
		    new rows, fields;
		    cache_get_data(rows, fields, MainPipeline);
		    if(rows)
		    {
		        SendClientMessageEx(index, COLOR_GREY, "That IP address is already banned.");
				DeletePVar(index, "BanIP");
		    }
		    else
		    {
		        new string[128], ip[32];
		        GetPVarString(index, "BanIP", ip, sizeof(ip));
		        format(string, sizeof(string), "INSERT INTO `ip_bans` (`ip`, `date`, `reason`, `admin`) VALUES ('%s', NOW(), '%s', '%s')", ip, "/banip", GetPlayerNameEx(index));
				mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);

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

    new rows, fields;
	cache_get_data(rows, fields, MainPipeline);

	if (rows == 0) {
		ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, " ", "Your mailbox is empty.", "OK", "");
		return 1;
	}

    new id, string[2000], message[129], tmp[128], read;
	for(new i; i < rows;i++)
	{
    	cache_get_field_content(i, "Id", tmp, MainPipeline);  	id = strval(tmp);
    	cache_get_field_content(i, "Read", tmp, MainPipeline); read= strval(tmp);
    	cache_get_field_content(i, "Message", message, MainPipeline, 129);
		strmid(message,message,0,30);
		if (strlen(message) > 30) strcat(message,"...");
		strcat(string, (read) ? ("{BBBBBB}") : ("{FFFFFF}"));
		strcat(string, message);
		if (i != rows - 1) strcat(string, "\n");
		ListItemTrackId[playerid][i] = id;
	}

    ShowPlayerDialog(playerid, DIALOG_POMAILS, DIALOG_STYLE_LIST, "Your mails", string, "Read", "Close");

	return 1;
}

forward MailDetailsQueryFinish(playerid);
public MailDetailsQueryFinish(playerid)
{
	new string[256];
    new rows, fields;
	cache_get_data(rows, fields, MainPipeline);

	new senderid, sender[MAX_PLAYER_NAME], message[131], notify, szTmp[128], Date[32], read, id;
	cache_get_field_content(0, "Id", szTmp, MainPipeline);	    	id = strval(szTmp);
	cache_get_field_content(0, "Notify", szTmp, MainPipeline);	    notify = strval(szTmp);
	cache_get_field_content(0, "Sender_Id", szTmp, MainPipeline);	senderid = strval(szTmp);
	cache_get_field_content(0, "Read", szTmp, MainPipeline);		read = strval(szTmp);
	cache_get_field_content(0, "Message", message, MainPipeline, 131);
	cache_get_field_content(0, "SenderUser", sender, MainPipeline, MAX_PLAYER_NAME);
	cache_get_field_content(0, "Date", Date, MainPipeline, 32);

	if (strlen(message) > 80) strins(message, "\n", 70);

	format(string, sizeof(string), "{EEEEEE}%s\n\n{BBBBBB}Sender: {FFFFFF}%s\n{BBBBBB}Date: {EEEEEE}%s", message, sender,Date);
	ShowPlayerDialog(playerid, DIALOG_PODETAIL, DIALOG_STYLE_MSGBOX, "Mail Content", string, "Back", "Trash");

	if (notify && !read) {
		//foreach(new i: Player)
		for(new i = 0; i < MAX_PLAYERS; ++i)
		{
			if(IsPlayerConnected(i))
			{
				if (GetPlayerSQLId(i) == senderid)	{
					format(string, sizeof(string), "Your message has just been read by %s!", GetPlayerNameEx(playerid));
					SendClientMessageEx(i, COLOR_YELLOW, string);
					break;
				}
			}	
		}
	}

	format(string, sizeof(string), "UPDATE `letters` SET `Read` = 1 WHERE `id` = %d", id);
	mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);

	return 1;
}


forward MailDeliveryQueryFinish();
public MailDeliveryQueryFinish()
{

    new rows, fields, id, tmp[128], i;
	cache_get_data(rows, fields, MainPipeline);

	for(; i < rows;i++)
	{
    	cache_get_field_content(i, "Receiver_Id", tmp, MainPipeline);
    	id = strval(tmp);
		//foreach(new j: Player)
		for(new j = 0; j < MAX_PLAYERS; ++j)
		{
			if(IsPlayerConnected(j))
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
 	}

	return 1;

}


forward MDCQueryFinish(playerid, suspectid);
public MDCQueryFinish(playerid, suspectid)
{
    new rows, fields;
	cache_get_data(rows, fields, MainPipeline);
    new resultline[1424];
    new crimes = PlayerInfo[suspectid][pCrimes];
	new arrests = PlayerInfo[suspectid][pArrested];
	format(resultline, sizeof(resultline), "{FF6347}Name:{BFC0C2} %s\t{FF6347}Phone Number:{BFC0C2} %d\n{FF6347}Total Previous Crimes: {BFC0C2}%d\t {FF6347}Total Arrests: {BFC0C2}%d \n{FF6347}Crime Key: {FF7D7D}Currently Wanted/{BFC0C2}Past Crime\n\n", GetPlayerNameEx(suspectid),PlayerInfo[suspectid][pPnumber], crimes, arrests);

	for(new i; i < rows; i++)
	{
	    cache_get_field_content(i, "issuer", MDCInfo[i][mdcIssuer], MainPipeline, MAX_PLAYER_NAME);
	    cache_get_field_content(i, "crime", MDCInfo[i][mdcCrime], MainPipeline, 64);
	    cache_get_field_content(i, "active", MDCInfo[i][mdcActive], MainPipeline, 2);
	    if(strval(MDCInfo[i][mdcActive]) == 1)
	    {
	        format(resultline, sizeof(resultline),"%s{FF6347}Crime: {FF7D7D}%s \t{FF6347}Charged by:{BFC0C2} %s\n",resultline, MDCInfo[i][mdcCrime], MDCInfo[i][mdcIssuer]);
		} else {
			format(resultline, sizeof(resultline),"%s{FF6347}Crime: {BFC0C2}%s \t{FF6347}Charged by:{BFC0C2} %s\n",resultline, MDCInfo[i][mdcCrime], MDCInfo[i][mdcIssuer]);
		}
	}
	ShowPlayerDialog(playerid, MDC_SHOWCRIMES, DIALOG_STYLE_MSGBOX, "MDC - Criminal History", resultline, "Back", "");
	return 1;
}

forward MDCReportsQueryFinish(playerid, suspectid);
public MDCReportsQueryFinish(playerid, suspectid)
{
    new rows, fields;
	cache_get_data(rows, fields, MainPipeline);
    new resultline[1424], str[12];
    new copname[MAX_PLAYER_NAME], datetime[64], reportsid;
	for(new i; i < rows; i++)
	{
		cache_get_field_content(i, "id", str, MainPipeline, 12); reportsid = strval(str); 
	    cache_get_field_content(i, "Username", copname, MainPipeline, MAX_PLAYER_NAME);
	    cache_get_field_content(i, "datetime", datetime, MainPipeline, 64);
	    format(resultline, sizeof(resultline),"%s{FF6347}Report (%d) {FF7D7D}Arrested by: %s on %s\n",resultline, reportsid, copname,datetime);
	}
	if(!resultline[0]) format(resultline, sizeof(resultline),"No Arrest Reports on record.",resultline, reportsid, copname,datetime);
	ShowPlayerDialog(playerid, MDC_SHOWREPORTS, DIALOG_STYLE_LIST, "MDC - Criminal History", resultline, "Back", "");
	return 1;
}

forward MDCReportQueryFinish(playerid, reportid);
public MDCReportQueryFinish(playerid, reportid)
{
    new rows, fields;
	cache_get_data(rows, fields, MainPipeline);
    new resultline[1424];
    new copname[MAX_PLAYER_NAME], datetime[64], shortreport[200];
	for(new i; i < rows; i++)
	{
	    cache_get_field_content(i, "Username", copname, MainPipeline, MAX_PLAYER_NAME);
	    cache_get_field_content(i, "datetime", datetime, MainPipeline, 64);
	    cache_get_field_content(i, "shortreport", shortreport, MainPipeline, 200);
	    format(resultline, sizeof(resultline),"{FF6347}Report #%d\n{FF7D7D}Arrested by: %s on %s\n{FF6347}Report:{BFC0C2} %s\n",reportid, copname,datetime, shortreport);
	}
	ShowPlayerDialog(playerid, MDC_SHOWCRIMES, DIALOG_STYLE_MSGBOX, "MDC - Arrest Report", resultline, "Back", "");
	return 1;
}

forward FlagQueryFinish(playerid, suspectid, queryid);
public FlagQueryFinish(playerid, suspectid, queryid)
{
    new rows, fields;
	cache_get_data(rows, fields, MainPipeline);
    new resultline[2000];
    new header[64], sResult[64];
    new FlagID, FlagIssuer[MAX_PLAYER_NAME], FlagText[64], FlagDate[24];
	switch(queryid)
	{
	    case Flag_Query_Display:
	    {
			format(header, sizeof(header), "{FF6347}Flag History for{BFC0C2} %s", GetPlayerNameEx(suspectid));

			for(new i; i < rows; i++)
			{
			    cache_get_field_content(i, "fid", sResult, MainPipeline); FlagID = strval(sResult);
			    cache_get_field_content(i, "issuer", FlagIssuer, MainPipeline, MAX_PLAYER_NAME);
			    cache_get_field_content(i, "flag", FlagText, MainPipeline, 64);
			    cache_get_field_content(i, "time", FlagDate, MainPipeline, 24);
				format(resultline, sizeof(resultline),"%s{FF6347}Flag (ID: %d): {BFC0C2} %s \t{FF6347}Issued by:{BFC0C2} %s \t{FF6347}Date: {BFC0C2}%s\n",resultline, FlagID, FlagText, FlagIssuer, FlagDate);
			}
			if(rows == 0)
			{
				format(resultline, sizeof(resultline),"{FF6347}No Flags on this account");
			}
			ShowPlayerDialog(playerid, FLAG_LIST, DIALOG_STYLE_MSGBOX, header, resultline, "Delete Flag", "Close");
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

				cache_get_field_content(0, "id", psqlid, MainPipeline);

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
	}
	return 1;
}

forward SkinQueryFinish(playerid, queryid);
public SkinQueryFinish(playerid, queryid)
{
    new rows, fields;
	cache_get_data(rows, fields, MainPipeline);
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
			    cache_get_field_content(i, "skinid", sResult, MainPipeline); skinid = strval(sResult);
				format(resultline, sizeof(resultline),"%sSkin ID: %d\n",resultline, skinid);
			}
			ShowPlayerDialog(playerid, SKIN_LIST, DIALOG_STYLE_LIST, header, resultline, "Select", "Cancel");
		}
		case Skin_Query_Count:
		{
		    PlayerInfo[playerid][pSkins] = rows;
		}
		case Skin_Query_ID:
		{
		    for(new i; i < rows; i++)
			{
			    cache_get_field_content(i, "skinid", sResult, MainPipeline); skinid = strval(sResult);
				if(i == GetPVarInt(playerid, "closetchoiceid"))
				{
					SetPVarInt(playerid, "closetskinid", skinid);
					SetPlayerSkin(playerid, skinid);
					ShowPlayerDialog(playerid, SKIN_CONFIRM, DIALOG_STYLE_MSGBOX, "Closet", "Do you want to wear these clothes?", "Yes", "Go Back");
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
			    cache_get_field_content(i, "skinid", sResult, MainPipeline); skinid = strval(sResult);
				format(resultline, sizeof(resultline),"%sSkin ID: %d\n",resultline, skinid);
			}
			ShowPlayerDialog(playerid, SKIN_DELETE, DIALOG_STYLE_LIST, header, resultline, "Select", "Cancel");
		}
		case Skin_Query_Delete_ID:
		{
		    for(new i; i < rows; i++)
			{
			    cache_get_field_content(i, "id", sResult, MainPipeline); skinid = strval(sResult);
				if(i == GetPVarInt(playerid, "closetchoiceid"))
				{
					SetPVarInt(playerid, "closetskinid", skinid);
					ShowPlayerDialog(playerid, SKIN_DELETE2, DIALOG_STYLE_MSGBOX, "Closet", "Are you sure you want to remove these clothes?", "Yes", "Cancel");
				}
			}
		}
	}
	return 1;
}


forward CitizenQueryFinish(playerid, queryid);
public CitizenQueryFinish(playerid, queryid)
{
    new rows, fields;
	cache_get_data(rows, fields, MainPipeline);
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
    new query[300], resultline[2000], sResult[64], rows, fields;
	cache_get_data(rows, fields, MainPipeline);
	switch(queryid)
	{
		case CheckQueue:
	    {
			if(rows == 0)
			{
				format(query, sizeof(query), "INSERT INTO `nation_queue` (`id`, `playerid`, `name`, `date`, `nation`, `status`) VALUES (NULL, %d, '%s', NOW(), %d, 1)", GetPlayerSQLId(playerid), GetPlayerNameExt(playerid), nation);
				mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
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
				format(query, sizeof(query), "UPDATE `nation_queue` SET `name` = '%s' WHERE `playerid` = %d", GetPlayerNameExt(playerid), GetPlayerSQLId(playerid));
				mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
			}
		}
		case AppQueue:
	    {
			new sDate[32];
			if(rows == 0) return SendClientMessageEx(playerid, COLOR_GREY, "There are currently no pending applications.");
			for(new i; i < rows; i++)
			{
				cache_get_field_content(i, "name", sResult, MainPipeline, MAX_PLAYER_NAME);
				cache_get_field_content(i, "date", sDate, MainPipeline, 32);
				format(resultline, sizeof(resultline), "%s%s -- Date Submitted: %s\n", resultline, sResult, sDate);
			}
			ShowPlayerDialog(playerid, NATION_APP_LIST, DIALOG_STYLE_LIST, "Nation Applications", resultline, "Select", "Cancel");
		}
	    case AddQueue:
	    {
			if(rows == 0)
			{
				format(query, sizeof(query), "INSERT INTO `nation_queue` (`id`, `playerid`, `name`, `date`, `nation`, `status`) VALUES (NULL, %d, '%s', NOW(), %d, 2)", GetPlayerSQLId(playerid), GetPlayerNameExt(playerid), nation);
				mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
				PlayerInfo[playerid][pNation] = 1;
			}
			else
			{
				format(query, sizeof(query), "INSERT INTO `nation_queue` (`id`, `playerid`, `name`, `date`, `nation`, `status`) VALUES (NULL, %d, NOW(), %d, 1)", GetPlayerSQLId(playerid), GetPlayerNameExt(playerid), nation);
				mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
			}
		}
	}
	return 1;
}

forward NationAppFinish(playerid, queryid);
public NationAppFinish(playerid, queryid)
{
    new query[300], string[128], sResult[64], rows, fields;
	cache_get_data(rows, fields, MainPipeline);
	switch(queryid)
	{
		case AcceptApp:
	    {
			for(new i; i < rows; i++)
			{
				cache_get_field_content(i, "id", sResult, MainPipeline); new AppID = strval(sResult);
				cache_get_field_content(i, "playerid", sResult, MainPipeline); new UserID = strval(sResult);
				cache_get_field_content(i, "name", sResult, MainPipeline, MAX_PLAYER_NAME);
				if(GetPVarInt(playerid, "Nation_App_ID") == i)
				{
					format(query, sizeof(query), "UPDATE `nation_queue` SET `status` = 2 WHERE `id` = %d", AppID);
					mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);

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
								format(query, sizeof(query), "UPDATE `accounts` SET `Nation` = 0 WHERE `id` = %d", UserID);
								mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
							}
							format(string, sizeof(string), "%s has approved %s's application for San Andreas citizenship", GetPlayerNameEx(playerid), sResult);
						}
						case 2:
						{
							if(IsPlayerConnected(giveplayerid))
							{
								PlayerInfo[giveplayerid][pNation] = 1;
								SendClientMessageEx(giveplayerid, COLOR_WHITE, "Your application for Tierra Robada citizenship has been approved!");
							}
							else
							{
								format(query, sizeof(query), "UPDATE `accounts` SET `Nation` = 1 WHERE `id` = %d", UserID);
								mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
							}
							format(string, sizeof(string), "%s has approved %s's application for Tierra Robada citizenship", GetPlayerNameEx(playerid), sResult);
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
				cache_get_field_content(i, "id", sResult, MainPipeline, 32); new AppID = strval(sResult);
				cache_get_field_content(i, "name", sResult, MainPipeline, MAX_PLAYER_NAME);
				if(GetPVarInt(playerid, "Nation_App_ID") == i)
				{
					format(query, sizeof(query), "UPDATE `nation_queue` SET `status` = 3 WHERE `id` = %d", AppID);
					mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
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
							format(string, sizeof(string), "%s has denied %s's application for Tierra Robada citizenship", GetPlayerNameEx(playerid), sResult);
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
    new rows, fields;
	cache_get_data(rows, fields, MainPipeline);
	PlayerInfo[playerid][pLottoNr] = rows;
	return 1;
}

forward UnreadMailsNotificationQueryFin(playerid);
public UnreadMailsNotificationQueryFin(playerid)
{
	new szResult[8];
	cache_get_field_content(0, "Unread_Count", szResult, MainPipeline);
	if (strval(szResult) > 0) {
		SetPVarInt(playerid, "UnreadMails", 1);
		SendClientMessageEx(playerid, COLOR_YELLOW, "You have unread items in your mailbox.");
	}
	return 1;
}


forward RecipientLookupFinish(playerid);
public RecipientLookupFinish(playerid)
{
	new rows,fields,szResult[16], admin, undercover, id;
	cache_get_data(rows, fields, MainPipeline);

	if (!rows) return ShowPlayerDialog(playerid, DIALOG_PORECEIVER, DIALOG_STYLE_INPUT, "Recipient", "{FF3333}Error: {FFFFFF}Invalid Recipient - Account does not exist!\n\nPlease type the name of the recipient (online or offline)", "Next", "Cancel");

	cache_get_field_content(0, "AdminLevel", szResult, MainPipeline); admin = strval(szResult);
	cache_get_field_content(0, "TogReports", szResult, MainPipeline); undercover = strval(szResult);
	cache_get_field_content(0, "id", szResult, MainPipeline); id = strval(szResult);

	if (admin >= 2 && undercover == 0) return ShowPlayerDialog(playerid, DIALOG_PORECEIVER, DIALOG_STYLE_INPUT, "Recipient", "{FF3333}Error: {FFFFFF}You can't send a letter to admins!\n\nPlease type the name of the recipient (online or offline)", "Next", "Cancel");

	SetPVarInt(playerid, "LetterRecipient", id);
	ShowPlayerDialog(playerid, DIALOG_POMESSAGE, DIALOG_STYLE_INPUT, "Send Letter", "{FFFFFF}Please type the message.", "Send", "Cancel");

	return 1;

}

forward CheckSales(index);
public CheckSales(index)
{
	if(IsPlayerConnected(index))
	{
	    new rows, fields, szDialog[512];
		cache_get_data(rows, fields, MainPipeline);
	    if(rows > 0)
		{
  			for(new i;i < rows;i++)
			{
			    new szResult[32], id;
			    cache_get_field_content(i, "id", szResult, MainPipeline); id = strval(szResult);
   				cache_get_field_content(i, "Month", szResult, MainPipeline, 25);
   				format(szDialog, sizeof(szDialog), "%s\n%s ", szDialog, szResult);
   				Selected[index][i] = id;
			}
			ShowPlayerDialog(index, DIALOG_VIEWSALE, DIALOG_STYLE_LIST, "Select a time frame", szDialog, "View", "Exit");
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
        new rows, fields, szDialog[3000];
		cache_get_data(rows, fields, MainPipeline);
	    if(rows)
		{
		    new szResult[32], szField[15], Solds[MAX_ITEMS], Amount[MAX_ITEMS];
		    for(new z = 0; z < MAX_ITEMS; z++)
			{
				format(szField, sizeof(szField), "TotalSold%d", z);
				cache_get_field_content(0,  szField, szResult, MainPipeline);
				Solds[z] = strval(szResult);

				format(szField, sizeof(szField), "AmountMade%d", z);
				cache_get_field_content(0,  szField, szResult, MainPipeline);
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
			Large Backpack: %d | Total Credits: %s\n", 
			Solds[33], number_format(Amount[33]), Solds[34], number_format(Amount[34]), Solds[35], number_format(Amount[35]), Solds[36], number_format(Amount[36]), Solds[37], number_format(Amount[37]), Solds[38], number_format(Amount[38]));
			
			format(szDialog, sizeof(szDialog), "%sCredits Transactions: %d | Total Credits %s\nTotal Amount of Credits spent: %s", szDialog, Solds[21], number_format(Amount[21]),
			number_format(Amount[0]+Amount[1]+Amount[2]+Amount[3]+Amount[4]+Amount[5]+Amount[6]+Amount[7]+Amount[8]+Amount[9]+Amount[10]+Amount[11]+Amount[12]+Amount[13]+Amount[14]+Amount[15]+Amount[16]+Amount[17]+Amount[18]+Amount[19]+Amount[20]+Amount[21]+Amount[22]+Amount[23]+Amount[24]+Amount[25]+Amount[26]+Amount[27]+Amount[28]+Amount[29]+Amount[30]+Amount[31]+Amount[32]+Amount[33]+Amount[34]+Amount[35]+Amount[36]+Amount[37]+Amount[38]));
		 	ShowPlayerDialog(index, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Shop Statistics", szDialog, "Next", "Exit");
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
	    new rows, fields;
	    cache_get_data(rows, fields, MainPipeline);
		if(rows)
		{
		    //`sqlid`, `modelid`, `posx`, `posy`, `posz`, `posa`, `spawned`, `hours`

            new szResult[32], Info[2], Float: pos[4], string[128];
 	    	cache_get_field_content(0, "modelid", szResult, MainPipeline); Info[0] = strval(szResult);
  	    	cache_get_field_content(0, "posx", szResult, MainPipeline); pos[0] = strval(szResult);
   	    	cache_get_field_content(0, "posy", szResult, MainPipeline); pos[1] = strval(szResult);
    	    cache_get_field_content(0, "posz", szResult, MainPipeline); pos[2] = strval(szResult);
    	    cache_get_field_content(0, "posa", szResult, MainPipeline); pos[3] = strval(szResult);
    	    cache_get_field_content(0, "hours", szResult, MainPipeline); Info[1] = strval(szResult);

			SetPVarInt(index, "RentedHours", Info[1]);
			SetPVarInt(index, "RentedVehicle", CreateVehicle(Info[0],pos[0],pos[1], pos[2], pos[3], random(128), random(128), 2000000));

			format(string, sizeof(string), "Your rented vehicle has been spawned and has %d minute(s) left.", Info[1]);
			SendClientMessageEx(index, COLOR_CYAN, string);
		}
	}
}

forward LoadTicket(playerid);
public LoadTicket(playerid) {
 	new rows, fields;
	cache_get_data(rows, fields, MainPipeline);

	if (rows == 0) {
		return 1;
	}

    new number, result[10];
	for(new i; i < rows; i++)
	{
    	cache_get_field_content(i, "number", result, MainPipeline);
    	number = strval(result);
		LottoNumbers[playerid][i] = number;
	}
	return 1;
}

forward LoadTreasureInvent(playerid);
public LoadTreasureInvent(playerid)
{
    new rows, fields, szResult[10];
	cache_get_data(rows, fields, MainPipeline);

    if(IsPlayerConnected(playerid))
    {
        if(!rows)
        {
            new query[60];
            format(query, sizeof(query), "INSERT INTO `jobstuff` (`pId`) VALUES ('%d')", GetPlayerSQLId(playerid));
			mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
        }
        else
        {
    		for(new row;row < rows;row++)
			{
				cache_get_field_content(row, "junkmetal", szResult, MainPipeline); SetPVarInt(playerid, "JunkMetal", strval(szResult));
				cache_get_field_content(row, "newcoin", szResult, MainPipeline); SetPVarInt(playerid, "newcoin", strval(szResult));
				cache_get_field_content(row, "oldcoin", szResult, MainPipeline); SetPVarInt(playerid, "oldcoin", strval(szResult));
				cache_get_field_content(row, "brokenwatch", szResult, MainPipeline); SetPVarInt(playerid, "brokenwatch", strval(szResult));
				cache_get_field_content(row, "oldkey", szResult, MainPipeline); SetPVarInt(playerid, "oldkey", strval(szResult));
				cache_get_field_content(row, "treasure", szResult, MainPipeline); SetPVarInt(playerid, "treasure", strval(szResult));
				cache_get_field_content(row, "goldwatch", szResult, MainPipeline); SetPVarInt(playerid, "goldwatch", strval(szResult));
				cache_get_field_content(row, "silvernugget", szResult, MainPipeline); SetPVarInt(playerid, "silvernugget", strval(szResult));
				cache_get_field_content(row, "goldnugget", szResult, MainPipeline); SetPVarInt(playerid, "goldnugget", strval(szResult));
			}
		}
	}
	return 1;
}

forward GetHomeCount(playerid);
public GetHomeCount(playerid)
{
	new string[128];
	format(string, sizeof(string), "SELECT NULL FROM `houses` WHERE `OwnerID` = %d", GetPlayerSQLId(playerid));
	return mysql_function_query(MainPipeline, string, true, "QueryGetCountFinish", "ii", playerid, 2);
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

	format(query, sizeof(query), "SELECT NULL FROM `tokens_report` WHERE `playerid` = %d AND `date` = '%s' AND `hour` = '%s'", GetPlayerSQLId(playerid), tdate, thour);
	mysql_function_query(MainPipeline, query, true, "QueryTokenFinish", "ii", playerid, 1);
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

	format(query, sizeof(query), "SELECT NULL FROM `tokens_request` WHERE `playerid` = %d AND `date` = '%s' AND `hour` = '%s'", GetPlayerSQLId(playerid), tdate, thour);
	mysql_function_query(MainPipeline, query, true, "QueryTokenFinish", "ii", playerid, 2);
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

	format(query, sizeof(query), "SELECT NULL FROM `tokens_call` WHERE `playerid` = %d AND `date` = '%s' AND `hour` = %d", GetPlayerSQLId(playerid), tdate, hour);
	mysql_function_query(MainPipeline, query, true, "QueryTokenFinish", "ii", playerid, 3);
	return 1;
}

forward QueryTokenFinish(playerid, type);
public QueryTokenFinish(playerid, type)
{
    new rows, fields, string[128], i_timestamp[3], tdate[11], thour[9];
	cache_get_data(rows, fields, MainPipeline);
	getdate(i_timestamp[0], i_timestamp[1], i_timestamp[2]);
	format(tdate, sizeof(tdate), "%d-%02d-%02d", i_timestamp[0], i_timestamp[1], i_timestamp[2]);
	format(thour, sizeof(thour), "%02d:00:00", hour);

	switch(type)
	{
		case 1:
		{
			if(rows == 0)
			{
				format(string, sizeof(string), "INSERT INTO `tokens_report` (`id`, `playerid`, `date`, `hour`, `count`) VALUES (NULL, %d, '%s', '%s', 1)", GetPlayerSQLId(playerid), tdate, thour);
				mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);
			}
			else
			{
				format(string, sizeof(string), "UPDATE `tokens_report` SET `count` = count+1 WHERE `playerid` = %d AND `date` = '%s' AND `hour` = '%s'", GetPlayerSQLId(playerid), tdate, thour);
				mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);
			}
		}
		case 2:
		{
			if(rows == 0)
			{
				format(string, sizeof(string), "INSERT INTO `tokens_request` (`id`, `playerid`, `date`, `hour`, `count`) VALUES (NULL, %d, '%s', '%s', 1)", GetPlayerSQLId(playerid), tdate, thour);
				mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);
			}
			else
			{
				format(string, sizeof(string), "UPDATE `tokens_request` SET `count` = count+1 WHERE `playerid` = %d AND `date` = '%s' AND `hour` = '%s'", GetPlayerSQLId(playerid), tdate, thour);
				mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);
			}
		}
		case 3:
		{
			if(rows == 0)
			{
				format(string, sizeof(string), "INSERT INTO `tokens_call` (`id`, `playerid`, `date`, `hour`, `count`) VALUES (NULL, %d, '%s', %d, 1)", GetPlayerSQLId(playerid), tdate, hour);
				mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);
			}
			else
			{
				format(string, sizeof(string), "UPDATE `tokens_call` SET `count` = count+1 WHERE `playerid` = %d AND `date` = '%s' AND `hour` = %d", GetPlayerSQLId(playerid), tdate, hour);
				mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);
			}
		}
	}
	return 1;
}

forward GetReportCount(userid, tdate[]);
public GetReportCount(userid, tdate[])
{
	new string[128];
	format(string, sizeof(string), "SELECT SUM(count) FROM `tokens_report` WHERE `playerid` = %d AND `date` = '%s'", GetPlayerSQLId(userid), tdate);
	return mysql_function_query(MainPipeline, string, true, "QueryGetCountFinish", "ii", userid, 0);
}

forward GetHourReportCount(userid, thour[], tdate[]);
public GetHourReportCount(userid, thour[], tdate[])
{
	new string[128];
	format(string, sizeof(string), "SELECT `count` FROM `tokens_report` WHERE `playerid` = %d AND `date` = '%s' AND `hour` = '%s'", GetPlayerSQLId(userid), tdate, thour);
	return mysql_function_query(MainPipeline, string, true, "QueryGetCountFinish", "ii", userid, 1);
}

forward GetRequestCount(userid, tdate[]);
public GetRequestCount(userid, tdate[])
{
	new string[128];
	format(string, sizeof(string), "SELECT SUM(count) FROM `tokens_request` WHERE `playerid` = %d AND `date` = '%s'", GetPlayerSQLId(userid), tdate);
	return mysql_function_query(MainPipeline, string, true, "QueryGetCountFinish", "ii", userid, 0);
}

forward GetHourRequestCount(userid, thour[], tdate[]);
public GetHourRequestCount(userid, thour[], tdate[])
{
	new string[128];
	format(string, sizeof(string), "SELECT `count` FROM `tokens_request` WHERE `playerid` = %d AND `date` = '%s' AND `hour` = '%s'", GetPlayerSQLId(userid), tdate, thour);
	return mysql_function_query(MainPipeline, string, true, "QueryGetCountFinish", "ii", userid, 1);
}

forward QueryGetCountFinish(userid, type);
public QueryGetCountFinish(userid, type)
{
    new rows, fields, sResult[24];
	cache_get_data(rows, fields, MainPipeline);

	switch(type)
	{
		case 0:
		{
			if(rows > 0)
			{
				cache_get_field_content(0, "SUM(count)", sResult, MainPipeline);
				ReportCount[userid] = strval(sResult);
			}
			else ReportCount[userid] = 0;
		}
		case 1:
		{
			if(rows > 0)
			{
				cache_get_field_content(0, "count", sResult, MainPipeline);
				ReportHourCount[userid] = strval(sResult);
			}
			else ReportHourCount[userid] = 0;
		}
		case 2:
		{
			Homes[userid] = rows;
		}
	}
	return 1;
}

forward OnLoadFamilies();
public OnLoadFamilies()
{
	new i, rows, fields, tmp[128], famid;
	cache_get_data(rows, fields, MainPipeline);

	new column[32];
	while(i < rows)
	{
	    FamilyMemberCount(i);
	    cache_get_field_content(i, "ID", tmp, MainPipeline); famid = strval(tmp);
		cache_get_field_content(i, "Taken", tmp, MainPipeline); FamilyInfo[famid][FamilyTaken] = strval(tmp);
		cache_get_field_content(i, "Name", FamilyInfo[famid][FamilyName], MainPipeline, 42);
		cache_get_field_content(i, "Leader", FamilyInfo[famid][FamilyLeader], MainPipeline, MAX_PLAYER_NAME);
		cache_get_field_content(i, "Bank", tmp, MainPipeline); FamilyInfo[famid][FamilyBank] = strval(tmp);
		cache_get_field_content(i, "Cash", tmp, MainPipeline); FamilyInfo[famid][FamilyCash] = strval(tmp);
		cache_get_field_content(i, "FamilyUSafe", tmp, MainPipeline); FamilyInfo[famid][FamilyUSafe] = strval(tmp);
		cache_get_field_content(i, "FamilySafeX", tmp, MainPipeline); FamilyInfo[famid][FamilySafe][0] = floatstr(tmp);
		cache_get_field_content(i, "FamilySafeY", tmp, MainPipeline); FamilyInfo[famid][FamilySafe][1] = floatstr(tmp);
		cache_get_field_content(i, "FamilySafeZ", tmp, MainPipeline); FamilyInfo[famid][FamilySafe][2] = floatstr(tmp);
		cache_get_field_content(i, "FamilySafeVW", tmp, MainPipeline); FamilyInfo[famid][FamilySafeVW] = strval(tmp);
		cache_get_field_content(i, "FamilySafeInt", tmp, MainPipeline); FamilyInfo[famid][FamilySafeInt] = strval(tmp);
		cache_get_field_content(i, "Pot", tmp, MainPipeline); FamilyInfo[famid][FamilyPot] = strval(tmp);
		cache_get_field_content(i, "Crack", tmp, MainPipeline); FamilyInfo[famid][FamilyCrack] = strval(tmp);
		cache_get_field_content(i, "Mats", tmp, MainPipeline); FamilyInfo[famid][FamilyMats] = strval(tmp);
		cache_get_field_content(i, "Heroin", tmp, MainPipeline); FamilyInfo[famid][FamilyHeroin] = strval(tmp);
		cache_get_field_content(i, "MaxSkins", tmp, MainPipeline); FamilyInfo[famid][FamilyMaxSkins] = strval(tmp);
		cache_get_field_content(i, "Color", tmp, MainPipeline); FamilyInfo[famid][FamilyColor] = strval(tmp);
		cache_get_field_content(i, "TurfTokens", tmp, MainPipeline); FamilyInfo[famid][FamilyTurfTokens] = strval(tmp);
		cache_get_field_content(i, "ExteriorX", tmp, MainPipeline); FamilyInfo[famid][FamilyEntrance][0] = floatstr(tmp);
		cache_get_field_content(i, "ExteriorY", tmp, MainPipeline); FamilyInfo[famid][FamilyEntrance][1] = floatstr(tmp);
		cache_get_field_content(i, "ExteriorZ", tmp, MainPipeline); FamilyInfo[famid][FamilyEntrance][2] = floatstr(tmp);
		cache_get_field_content(i, "ExteriorA", tmp, MainPipeline); FamilyInfo[famid][FamilyEntrance][3] = floatstr(tmp);
		cache_get_field_content(i, "InteriorX", tmp, MainPipeline); FamilyInfo[famid][FamilyExit][0] = floatstr(tmp);
		cache_get_field_content(i, "InteriorY", tmp, MainPipeline); FamilyInfo[famid][FamilyExit][1] = floatstr(tmp);
		cache_get_field_content(i, "InteriorZ", tmp, MainPipeline); FamilyInfo[famid][FamilyExit][2] = floatstr(tmp);
		cache_get_field_content(i, "InteriorA", tmp, MainPipeline); FamilyInfo[famid][FamilyExit][3] = floatstr(tmp);
		cache_get_field_content(i, "INT", tmp, MainPipeline); FamilyInfo[famid][FamilyInterior] = strval(tmp);
		cache_get_field_content(i, "VW", tmp, MainPipeline); FamilyInfo[famid][FamilyVirtualWorld] = strval(tmp);
		cache_get_field_content(i, "CustomInterior", tmp, MainPipeline); FamilyInfo[famid][FamilyCustomMap] = strval(tmp);
		cache_get_field_content(i, "GtObject", tmp, MainPipeline); FamilyInfo[famid][gtObject] = strval(tmp);
		cache_get_field_content(i, "MOTD1", FamilyMOTD[famid][0], MainPipeline, 128);
		cache_get_field_content(i, "MOTD2", FamilyMOTD[famid][1], MainPipeline, 128);
		cache_get_field_content(i, "MOTD3", FamilyMOTD[famid][2], MainPipeline, 128);
		cache_get_field_content(i, "fontface", tmp, MainPipeline); format(FamilyInfo[famid][gt_FontFace], 32, "%s", tmp);
		cache_get_field_content(i, "fontsize", tmp, MainPipeline); FamilyInfo[famid][gt_FontSize] = strval(tmp);
		cache_get_field_content(i, "bold", tmp, MainPipeline); FamilyInfo[famid][gt_Bold] = strval(tmp);
		cache_get_field_content(i, "fontcolor", tmp, MainPipeline); FamilyInfo[famid][gt_FontColor] = strval(tmp);
		cache_get_field_content(i, "text", FamilyInfo[famid][gt_Text], MainPipeline, 32);		
		cache_get_field_content(i, "gtUsed", tmp, MainPipeline); FamilyInfo[famid][gt_SPUsed] = strval(tmp);		
		if(strcmp(FamilyInfo[famid][gt_Text], "Preview", true) == 0)
		{
			FamilyInfo[famid][gtObject] = 1490;
			FamilyInfo[famid][gt_SPUsed] = 1;
		}
	    for (new j; j <= 6; j++) {
	        format(column,sizeof(column), "Rank%d", j);
	        cache_get_field_content(i, column, tmp, MainPipeline); format(FamilyRankInfo[famid][j], 20, "%s", tmp);
	    }

		for (new j = 0; j < 5 ;j++) {
	        format(column, sizeof(column), "Division%d", j);
	        cache_get_field_content(i, column, tmp, MainPipeline); format(FamilyDivisionInfo[famid][j], 20, "%s", tmp);
	    }
	    for (new j; j < 8; j++) {
	        format(column,sizeof(column), "Skin%d", j+1);
	        cache_get_field_content(i, column, tmp, MainPipeline); FamilyInfo[famid][FamilySkins][j] = strval(tmp);
	    }
	    for (new j; j < 10; j++) {
	        format(column,sizeof(column), "Gun%d", j+1);
	        cache_get_field_content(i, column, tmp, MainPipeline); FamilyInfo[famid][FamilyGuns][j] = strval(tmp);
	    }
		if(FamilyInfo[famid][FamilyUSafe] > 0)
		{
			FamilyInfo[famid][FamilyPickup] = CreateDynamicPickup(1239, 23, FamilyInfo[famid][FamilySafe][0], FamilyInfo[famid][FamilySafe][1], FamilyInfo[famid][FamilySafe][2], .worldid = FamilyInfo[famid][FamilySafeVW], .interiorid = FamilyInfo[famid][FamilySafeInt]);
		}
		if(FamilyInfo[famid][FamilyEntrance][0] != 0.0 && FamilyInfo[famid][FamilyEntrance][1] != 0.0)
		{
		    new string[42];
		    FamilyInfo[famid][FamilyEntrancePickup] = CreateDynamicPickup(1318, 23, FamilyInfo[famid][FamilyEntrance][0], FamilyInfo[famid][FamilyEntrance][1], FamilyInfo[famid][FamilyEntrance][2]);
			format(string, sizeof(string), "%s", FamilyInfo[famid][FamilyName]);
			FamilyInfo[famid][FamilyEntranceText] = CreateDynamic3DTextLabel(string,COLOR_YELLOW,FamilyInfo[famid][FamilyEntrance][0], FamilyInfo[famid][FamilyEntrance][1], FamilyInfo[famid][FamilyEntrance][2]+0.6,4.0);
		}
		i++;
	}
	//LoadGangTags();
}

forward OnFamilyMemberCount(famid);
public OnFamilyMemberCount(famid)
{
	new rows, fields;
	cache_get_data(rows, fields, MainPipeline);
	FamilyInfo[famid][FamilyMembers] = rows;
}

forward MailDeliveryTimer();
public MailDeliveryTimer()
{
	mysql_function_query(MainPipeline, "UPDATE `letters` SET `Delivery_Min` = `Delivery_Min` - 1 WHERE `Delivery_Min` > 0", false, "OnQueryFinish", "i", SENDDATA_THREAD);
	mysql_function_query(MainPipeline, "SELECT `Receiver_Id` FROM `letters` WHERE `Delivery_Min` = 1", true, "MailDeliveryQueryFinish", "");
	return 1;
}

forward OnLoadGates();
public OnLoadGates()
{
	new i, rows, fields, tmp[128];
	cache_get_data(rows, fields, MainPipeline);

	while(i < rows)
	{
		cache_get_field_content(i, "HID", tmp, MainPipeline);  GateInfo[i][gHID] = strval(tmp);
		cache_get_field_content(i, "Speed", tmp, MainPipeline); GateInfo[i][gSpeed] = floatstr(tmp);
		cache_get_field_content(i, "Range", tmp, MainPipeline); GateInfo[i][gRange] = floatstr(tmp);
		cache_get_field_content(i, "Model", tmp, MainPipeline); GateInfo[i][gModel] = strval(tmp);
		cache_get_field_content(i, "VW", tmp, MainPipeline); GateInfo[i][gVW] = strval(tmp);
		cache_get_field_content(i, "Int", tmp, MainPipeline); GateInfo[i][gInt] = strval(tmp);
		cache_get_field_content(i, "Pass", GateInfo[i][gPass], MainPipeline, 24);
		cache_get_field_content(i, "PosX", tmp, MainPipeline); GateInfo[i][gPosX] = floatstr(tmp);
		cache_get_field_content(i, "PosY", tmp, MainPipeline); GateInfo[i][gPosY] = floatstr(tmp);
		cache_get_field_content(i, "PosZ", tmp, MainPipeline); GateInfo[i][gPosZ] = floatstr(tmp);
		cache_get_field_content(i, "RotX", tmp, MainPipeline); GateInfo[i][gRotX] = floatstr(tmp);
		cache_get_field_content(i, "RotY", tmp, MainPipeline); GateInfo[i][gRotY] = floatstr(tmp);
		cache_get_field_content(i, "RotZ", tmp, MainPipeline); GateInfo[i][gRotZ] = floatstr(tmp);
		cache_get_field_content(i, "PosXM", tmp, MainPipeline); GateInfo[i][gPosXM] = floatstr(tmp);
		cache_get_field_content(i, "PosYM", tmp, MainPipeline); GateInfo[i][gPosYM] = floatstr(tmp);
		cache_get_field_content(i, "PosZM", tmp, MainPipeline); GateInfo[i][gPosZM] = floatstr(tmp);
		cache_get_field_content(i, "RotXM", tmp, MainPipeline); GateInfo[i][gRotXM] = floatstr(tmp);
		cache_get_field_content(i, "RotYM", tmp, MainPipeline); GateInfo[i][gRotYM] = floatstr(tmp);
		cache_get_field_content(i, "RotZM", tmp, MainPipeline); GateInfo[i][gRotZM] = floatstr(tmp);
		cache_get_field_content(i, "Allegiance", tmp, MainPipeline); GateInfo[i][gAllegiance] = strval(tmp);
		cache_get_field_content(i, "GroupType", tmp, MainPipeline); GateInfo[i][gGroupType] = strval(tmp);
		cache_get_field_content(i, "GroupID", tmp, MainPipeline); GateInfo[i][gGroupID] = strval(tmp);
		cache_get_field_content(i, "FamilyID", tmp, MainPipeline); GateInfo[i][gFamilyID] = strval(tmp);
		cache_get_field_content(i, "RenderHQ", tmp, MainPipeline); GateInfo[i][gRenderHQ] = strval(tmp);
		cache_get_field_content(i, "Timer", tmp, MainPipeline); GateInfo[i][gTimer] = strval(tmp);
		cache_get_field_content(i, "Automate", tmp, MainPipeline); GateInfo[i][gAutomate] = strval(tmp);
		cache_get_field_content(i, "Locked", tmp, MainPipeline); GateInfo[i][gLocked] = strval(tmp);
		if(GateInfo[i][gPosX] != 0.0) CreateGate(i);
		i++;
	}
}

forward OnLoadDynamicMapIcon(index);
public OnLoadDynamicMapIcon(index)
{
	new rows, fields, tmp[128];
	cache_get_data(rows, fields, MainPipeline);

	for(new row; row < rows; row++)
	{
		cache_get_field_content(row, "id", tmp, MainPipeline);  DMPInfo[index][dmpSQLId] = strval(tmp);
		cache_get_field_content(row, "MarkerType", tmp, MainPipeline); DMPInfo[index][dmpMarkerType] = strval(tmp);
		cache_get_field_content(row, "Color", tmp, MainPipeline); DMPInfo[index][dmpColor] = strval(tmp);
		cache_get_field_content(row, "VW", tmp, MainPipeline); DMPInfo[index][dmpVW] = strval(tmp);
		cache_get_field_content(row, "Int", tmp, MainPipeline); DMPInfo[index][dmpInt] = strval(tmp);
		cache_get_field_content(row, "PosX", tmp, MainPipeline); DMPInfo[index][dmpPosX] = floatstr(tmp);
		cache_get_field_content(row, "PosY", tmp, MainPipeline); DMPInfo[index][dmpPosY] = floatstr(tmp);
		cache_get_field_content(row, "PosZ", tmp, MainPipeline); DMPInfo[index][dmpPosZ] = floatstr(tmp);
		if(DMPInfo[index][dmpPosX] != 0.0)
		{
			if(DMPInfo[index][dmpMarkerType] != 0) DMPInfo[index][dmpMapIconID] = CreateDynamicMapIcon(DMPInfo[index][dmpPosX], DMPInfo[index][dmpPosY], DMPInfo[index][dmpPosZ], DMPInfo[index][dmpMarkerType], DMPInfo[index][dmpColor], DMPInfo[index][dmpVW], DMPInfo[index][dmpInt], -1, 500.0);
		}
	}
	return 1;
}

forward OnLoadDynamicMapIcons();
public OnLoadDynamicMapIcons()
{
	new i, rows, fields, tmp[128];
	cache_get_data(rows, fields, MainPipeline);

	while(i < rows)
	{
		cache_get_field_content(i, "id", tmp, MainPipeline);  DMPInfo[i][dmpSQLId] = strval(tmp);
		cache_get_field_content(i, "MarkerType", tmp, MainPipeline); DMPInfo[i][dmpMarkerType] = strval(tmp);
		cache_get_field_content(i, "Color", tmp, MainPipeline); DMPInfo[i][dmpColor] = strval(tmp);
		cache_get_field_content(i, "VW", tmp, MainPipeline); DMPInfo[i][dmpVW] = strval(tmp);
		cache_get_field_content(i, "Int", tmp, MainPipeline); DMPInfo[i][dmpInt] = strval(tmp);
		cache_get_field_content(i, "PosX", tmp, MainPipeline); DMPInfo[i][dmpPosX] = floatstr(tmp);
		cache_get_field_content(i, "PosY", tmp, MainPipeline); DMPInfo[i][dmpPosY] = floatstr(tmp);
		cache_get_field_content(i, "PosZ", tmp, MainPipeline); DMPInfo[i][dmpPosZ] = floatstr(tmp);
		if(DMPInfo[i][dmpPosX] != 0.0)
		{
			if(DMPInfo[i][dmpMarkerType] != 0) DMPInfo[i][dmpMapIconID] = CreateDynamicMapIcon(DMPInfo[i][dmpPosX], DMPInfo[i][dmpPosY], DMPInfo[i][dmpPosZ], DMPInfo[i][dmpMarkerType], DMPInfo[i][dmpColor], DMPInfo[i][dmpVW], DMPInfo[i][dmpInt], -1, 500.0);
		}
		i++;
	}
	if(i > 0) printf("[LoadDynamicMapIcons] %d map icons rehashed/loaded.", i);
	else printf("[LoadDynamicMapIcons] Failed to load any map icons.");
	return 1;
}

forward OnLoadDynamicDoor(index);
public OnLoadDynamicDoor(index)
{
	new rows, fields, tmp[128];
	cache_get_data(rows, fields, MainPipeline);

	for(new row; row < rows; row++)
	{
		cache_get_field_content(rows, "id", tmp, MainPipeline);  DDoorsInfo[index][ddSQLId] = strval(tmp);
		cache_get_field_content(rows, "Description", DDoorsInfo[index][ddDescription], MainPipeline, 128);
		cache_get_field_content(rows, "Owner", tmp, MainPipeline); DDoorsInfo[index][ddOwner] = strval(tmp);
		cache_get_field_content(rows, "OwnerName", DDoorsInfo[index][ddOwnerName], MainPipeline, 42);
		cache_get_field_content(rows, "CustomExterior", tmp, MainPipeline); DDoorsInfo[index][ddCustomExterior] = strval(tmp);
		cache_get_field_content(rows, "CustomInterior", tmp, MainPipeline); DDoorsInfo[index][ddCustomInterior] = strval(tmp);
		cache_get_field_content(rows, "ExteriorVW", tmp, MainPipeline); DDoorsInfo[index][ddExteriorVW] = strval(tmp);
		cache_get_field_content(rows, "ExteriorInt", tmp, MainPipeline); DDoorsInfo[index][ddExteriorInt] = strval(tmp);
		cache_get_field_content(rows, "InteriorVW", tmp, MainPipeline); DDoorsInfo[index][ddInteriorVW] = strval(tmp);
		cache_get_field_content(rows, "InteriorInt", tmp, MainPipeline); DDoorsInfo[index][ddInteriorInt] = strval(tmp);
		cache_get_field_content(rows, "ExteriorX", tmp, MainPipeline); DDoorsInfo[index][ddExteriorX] = floatstr(tmp);
		cache_get_field_content(rows, "ExteriorY", tmp, MainPipeline); DDoorsInfo[index][ddExteriorY] = floatstr(tmp);
		cache_get_field_content(rows, "ExteriorZ", tmp, MainPipeline); DDoorsInfo[index][ddExteriorZ] = floatstr(tmp);
		cache_get_field_content(rows, "ExteriorA", tmp, MainPipeline); DDoorsInfo[index][ddExteriorA] = floatstr(tmp);
		cache_get_field_content(rows, "InteriorX", tmp, MainPipeline); DDoorsInfo[index][ddInteriorX] = floatstr(tmp);
		cache_get_field_content(rows, "InteriorY", tmp, MainPipeline); DDoorsInfo[index][ddInteriorY] = floatstr(tmp);
		cache_get_field_content(rows, "InteriorZ", tmp, MainPipeline); DDoorsInfo[index][ddInteriorZ] = floatstr(tmp);
		cache_get_field_content(rows, "InteriorA", tmp, MainPipeline); DDoorsInfo[index][ddInteriorA] = floatstr(tmp);
		cache_get_field_content(rows, "Type", tmp, MainPipeline); DDoorsInfo[index][ddType] = strval(tmp);
		cache_get_field_content(rows, "Rank", tmp, MainPipeline); DDoorsInfo[index][ddRank] = strval(tmp);
		cache_get_field_content(rows, "VIP", tmp, MainPipeline); DDoorsInfo[index][ddVIP] = strval(tmp);
		cache_get_field_content(rows, "Famed", tmp, MainPipeline); DDoorsInfo[index][ddFamed] = strval(tmp);
		cache_get_field_content(rows, "DPC", tmp, MainPipeline); DDoorsInfo[index][ddDPC] = strval(tmp);
		cache_get_field_content(rows, "Allegiance", tmp, MainPipeline); DDoorsInfo[index][ddAllegiance] = strval(tmp);
		cache_get_field_content(rows, "GroupType", tmp, MainPipeline); DDoorsInfo[index][ddGroupType] = strval(tmp);
		cache_get_field_content(rows, "Family", tmp, MainPipeline); DDoorsInfo[index][ddFamily] = strval(tmp);
		cache_get_field_content(rows, "Faction", tmp, MainPipeline); DDoorsInfo[index][ddFaction] = strval(tmp);
		cache_get_field_content(rows, "Admin", tmp, MainPipeline); DDoorsInfo[index][ddAdmin] = strval(tmp);
		cache_get_field_content(rows, "Wanted", tmp, MainPipeline); DDoorsInfo[index][ddWanted] = strval(tmp);
		cache_get_field_content(rows, "VehicleAble", tmp, MainPipeline); DDoorsInfo[index][ddVehicleAble] = strval(tmp);
		cache_get_field_content(rows, "Color", tmp, MainPipeline); DDoorsInfo[index][ddColor] = strval(tmp);
		cache_get_field_content(rows, "PickupModel", tmp, MainPipeline); DDoorsInfo[index][ddPickupModel] = strval(tmp);
		cache_get_field_content(rows, "Pass", DDoorsInfo[index][ddPass], MainPipeline, 24);
		cache_get_field_content(rows, "Locked", tmp, MainPipeline); DDoorsInfo[index][ddLocked] = strval(tmp);
		if(DDoorsInfo[index][ddExteriorX] != 0.0) CreateDynamicDoor(index);
	}
	return 1;
}


forward OnLoadDynamicDoors();
public OnLoadDynamicDoors()
{
	new i, rows, fields, tmp[128];
	cache_get_data(rows, fields, MainPipeline);

	while(i < rows)
	{
		cache_get_field_content(i, "id", tmp, MainPipeline);  DDoorsInfo[i][ddSQLId] = strval(tmp);
		cache_get_field_content(i, "Description", DDoorsInfo[i][ddDescription], MainPipeline, 128);
		cache_get_field_content(i, "Owner", tmp, MainPipeline); DDoorsInfo[i][ddOwner] = strval(tmp);
		cache_get_field_content(i, "OwnerName", DDoorsInfo[i][ddOwnerName], MainPipeline, 42);
		cache_get_field_content(i, "CustomExterior", tmp, MainPipeline); DDoorsInfo[i][ddCustomExterior] = strval(tmp);
		cache_get_field_content(i, "CustomInterior", tmp, MainPipeline); DDoorsInfo[i][ddCustomInterior] = strval(tmp);
		cache_get_field_content(i, "ExteriorVW", tmp, MainPipeline); DDoorsInfo[i][ddExteriorVW] = strval(tmp);
		cache_get_field_content(i, "ExteriorInt", tmp, MainPipeline); DDoorsInfo[i][ddExteriorInt] = strval(tmp);
		cache_get_field_content(i, "InteriorVW", tmp, MainPipeline); DDoorsInfo[i][ddInteriorVW] = strval(tmp);
		cache_get_field_content(i, "InteriorInt", tmp, MainPipeline); DDoorsInfo[i][ddInteriorInt] = strval(tmp);
		cache_get_field_content(i, "ExteriorX", tmp, MainPipeline); DDoorsInfo[i][ddExteriorX] = floatstr(tmp);
		cache_get_field_content(i, "ExteriorY", tmp, MainPipeline); DDoorsInfo[i][ddExteriorY] = floatstr(tmp);
		cache_get_field_content(i, "ExteriorZ", tmp, MainPipeline); DDoorsInfo[i][ddExteriorZ] = floatstr(tmp);
		cache_get_field_content(i, "ExteriorA", tmp, MainPipeline); DDoorsInfo[i][ddExteriorA] = floatstr(tmp);
		cache_get_field_content(i, "InteriorX", tmp, MainPipeline); DDoorsInfo[i][ddInteriorX] = floatstr(tmp);
		cache_get_field_content(i, "InteriorY", tmp, MainPipeline); DDoorsInfo[i][ddInteriorY] = floatstr(tmp);
		cache_get_field_content(i, "InteriorZ", tmp, MainPipeline); DDoorsInfo[i][ddInteriorZ] = floatstr(tmp);
		cache_get_field_content(i, "InteriorA", tmp, MainPipeline); DDoorsInfo[i][ddInteriorA] = floatstr(tmp);
		cache_get_field_content(i, "Type", tmp, MainPipeline); DDoorsInfo[i][ddType] = strval(tmp);
		cache_get_field_content(i, "Rank", tmp, MainPipeline); DDoorsInfo[i][ddRank] = strval(tmp);
		cache_get_field_content(i, "VIP", tmp, MainPipeline); DDoorsInfo[i][ddVIP] = strval(tmp);
		cache_get_field_content(i, "Famed", tmp, MainPipeline); DDoorsInfo[i][ddFamed] = strval(tmp);
		cache_get_field_content(i, "DPC", tmp, MainPipeline); DDoorsInfo[i][ddDPC] = strval(tmp);
		cache_get_field_content(i, "Allegiance", tmp, MainPipeline); DDoorsInfo[i][ddAllegiance] = strval(tmp);
		cache_get_field_content(i, "GroupType", tmp, MainPipeline); DDoorsInfo[i][ddGroupType] = strval(tmp);
		cache_get_field_content(i, "Family", tmp, MainPipeline); DDoorsInfo[i][ddFamily] = strval(tmp);
		cache_get_field_content(i, "Faction", tmp, MainPipeline); DDoorsInfo[i][ddFaction] = strval(tmp);
		cache_get_field_content(i, "Admin", tmp, MainPipeline); DDoorsInfo[i][ddAdmin] = strval(tmp);
		cache_get_field_content(i, "Wanted", tmp, MainPipeline); DDoorsInfo[i][ddWanted] = strval(tmp);
		cache_get_field_content(i, "VehicleAble", tmp, MainPipeline); DDoorsInfo[i][ddVehicleAble] = strval(tmp);
		cache_get_field_content(i, "Color", tmp, MainPipeline); DDoorsInfo[i][ddColor] = strval(tmp);
		cache_get_field_content(i, "PickupModel", tmp, MainPipeline); DDoorsInfo[i][ddPickupModel] = strval(tmp);
		cache_get_field_content(i, "Pass", DDoorsInfo[i][ddPass], MainPipeline, 24);
		cache_get_field_content(i, "Locked", tmp, MainPipeline); DDoorsInfo[i][ddLocked] = strval(tmp);
		if(DDoorsInfo[i][ddExteriorX] != 0.0) CreateDynamicDoor(i);
		i++;
	}
	if(i > 0) printf("[LoadDynamicDoors] %d doors rehashed/loaded.", i);
	else printf("[LoadDynamicDoors] Failed to load any doors.");
	return 1;
}

forward OnLoadHouse(index);
public OnLoadHouse(index)
{
	new rows, fields, szField[24], tmp[128];
	cache_get_data(rows, fields, MainPipeline);

	for(new row; row < rows; row++)
	{
		cache_get_field_content(row, "id", tmp, MainPipeline); HouseInfo[index][hSQLId] = strval(tmp);
		cache_get_field_content(row, "Owned", tmp, MainPipeline); HouseInfo[index][hOwned] = strval(tmp);
		cache_get_field_content(row, "Level", tmp, MainPipeline); HouseInfo[index][hLevel] = strval(tmp);
		cache_get_field_content(row, "Description", HouseInfo[index][hDescription], MainPipeline, 16);
		cache_get_field_content(row, "OwnerID", tmp, MainPipeline); HouseInfo[index][hOwnerID] = strval(tmp);
		cache_get_field_content(row, "Username", HouseInfo[index][hOwnerName], MainPipeline, MAX_PLAYER_NAME);
		cache_get_field_content(row, "ExteriorX", tmp, MainPipeline); HouseInfo[index][hExteriorX] = floatstr(tmp);
		cache_get_field_content(row, "ExteriorY", tmp, MainPipeline); HouseInfo[index][hExteriorY] = floatstr(tmp);
		cache_get_field_content(row, "ExteriorZ", tmp, MainPipeline); HouseInfo[index][hExteriorZ] = floatstr(tmp);
		cache_get_field_content(row, "ExteriorR", tmp, MainPipeline); HouseInfo[index][hExteriorR] = floatstr(tmp);
		cache_get_field_content(row, "ExteriorA", tmp, MainPipeline); HouseInfo[index][hExteriorA] = floatstr(tmp);
		cache_get_field_content(row, "CustomExterior", tmp, MainPipeline); HouseInfo[index][hCustomExterior] = strval(tmp);
		cache_get_field_content(row, "InteriorX", tmp, MainPipeline); HouseInfo[index][hInteriorX] = floatstr(tmp);
		cache_get_field_content(row, "InteriorY", tmp, MainPipeline); HouseInfo[index][hInteriorY] = floatstr(tmp);
		cache_get_field_content(row, "InteriorZ", tmp, MainPipeline); HouseInfo[index][hInteriorZ] = floatstr(tmp);
		cache_get_field_content(row, "InteriorR", tmp, MainPipeline); HouseInfo[index][hInteriorR] = floatstr(tmp);
		cache_get_field_content(row, "InteriorA", tmp, MainPipeline); HouseInfo[index][hInteriorA] = floatstr(tmp);
		cache_get_field_content(row, "CustomInterior", tmp, MainPipeline); HouseInfo[index][hCustomInterior] = strval(tmp);
		cache_get_field_content(row, "ExtIW", tmp, MainPipeline); HouseInfo[index][hExtIW] = strval(tmp);
		cache_get_field_content(row, "ExtVW", tmp, MainPipeline); HouseInfo[index][hExtVW] = strval(tmp);
		cache_get_field_content(row, "IntIW", tmp, MainPipeline); HouseInfo[index][hIntIW] = strval(tmp);
		cache_get_field_content(row, "IntVW", tmp, MainPipeline); HouseInfo[index][hIntVW] = strval(tmp);
		cache_get_field_content(row, "Lock", tmp, MainPipeline); HouseInfo[index][hLock] = strval(tmp);
		cache_get_field_content(row, "Rentable", tmp, MainPipeline); HouseInfo[index][hRentable] = strval(tmp);
		cache_get_field_content(row, "RentFee", tmp, MainPipeline); HouseInfo[index][hRentFee] = strval(tmp);
		cache_get_field_content(row, "Value", tmp, MainPipeline); HouseInfo[index][hValue] = strval(tmp);
		cache_get_field_content(row, "SafeMoney", tmp, MainPipeline); HouseInfo[index][hSafeMoney] = strval(tmp);
		cache_get_field_content(row, "Pot", tmp, MainPipeline); HouseInfo[index][hPot] = strval(tmp);
		cache_get_field_content(row, "Crack", tmp, MainPipeline); HouseInfo[index][hCrack] = strval(tmp);
		cache_get_field_content(row, "Materials", tmp, MainPipeline); HouseInfo[index][hMaterials] = strval(tmp);
		cache_get_field_content(row, "Heroin", tmp, MainPipeline); HouseInfo[index][hHeroin] = strval(tmp);
		for(new i; i < 5; i++)
		{
			format(szField, sizeof(szField), "Weapons%d", i);
			cache_get_field_content(row, szField, tmp, MainPipeline);
			HouseInfo[index][hWeapons][i] = strval(tmp);
		}
		cache_get_field_content(row, "GLUpgrade", tmp, MainPipeline); HouseInfo[index][hGLUpgrade] = strval(tmp);
		cache_get_field_content(row, "PickupID", tmp, MainPipeline); HouseInfo[index][hPickupID] = strval(tmp);
		cache_get_field_content(row, "MailX", tmp, MainPipeline); HouseInfo[index][hMailX] = floatstr(tmp);
		cache_get_field_content(row, "MailY", tmp, MainPipeline); HouseInfo[index][hMailY] = floatstr(tmp);
		cache_get_field_content(row, "MailZ", tmp, MainPipeline); HouseInfo[index][hMailZ] = floatstr(tmp);
		cache_get_field_content(row, "MailA", tmp, MainPipeline); HouseInfo[index][hMailA] = floatstr(tmp);
		cache_get_field_content(row, "MailType", tmp, MainPipeline); HouseInfo[index][hMailType] = strval(tmp);
		cache_get_field_content(row, "ClosetX", tmp, MainPipeline); HouseInfo[index][hClosetX] = floatstr(tmp);
		cache_get_field_content(row, "ClosetY", tmp, MainPipeline); HouseInfo[index][hClosetY] = floatstr(tmp);
		cache_get_field_content(row, "ClosetZ", tmp, MainPipeline); HouseInfo[index][hClosetZ] = floatstr(tmp);

		if(HouseInfo[index][hExteriorX] != 0.0) ReloadHousePickup(index);
		if(HouseInfo[index][hClosetX] != 0.0) HouseInfo[index][hClosetTextID] = CreateDynamic3DTextLabel("Closet\n/closet to use", 0xFFFFFF88, HouseInfo[index][hClosetX], HouseInfo[index][hClosetY], HouseInfo[index][hClosetZ]+0.5,10.0, .testlos = 1, .worldid = HouseInfo[index][hIntVW], .interiorid = HouseInfo[index][hIntIW], .streamdistance = 10.0);
		if(HouseInfo[index][hMailX] != 0.0) RenderHouseMailbox(index);
	}
	return 1;
}

forward OnLoadHouses();
public OnLoadHouses()
{
	new i, rows, fields, szField[24], tmp[128];
	cache_get_data(rows, fields, MainPipeline);

	while(i < rows)
	{
		cache_get_field_content(i, "id", tmp, MainPipeline); HouseInfo[i][hSQLId] = strval(tmp);
		cache_get_field_content(i, "Owned", tmp, MainPipeline); HouseInfo[i][hOwned] = strval(tmp);
		cache_get_field_content(i, "Level", tmp, MainPipeline); HouseInfo[i][hLevel] = strval(tmp);
		cache_get_field_content(i, "Description", HouseInfo[i][hDescription], MainPipeline, 16);
		cache_get_field_content(i, "OwnerID", tmp, MainPipeline); HouseInfo[i][hOwnerID] = strval(tmp);
		cache_get_field_content(i, "Username", HouseInfo[i][hOwnerName], MainPipeline, MAX_PLAYER_NAME);
		cache_get_field_content(i, "ExteriorX", tmp, MainPipeline); HouseInfo[i][hExteriorX] = floatstr(tmp);
		cache_get_field_content(i, "ExteriorY", tmp, MainPipeline); HouseInfo[i][hExteriorY] = floatstr(tmp);
		cache_get_field_content(i, "ExteriorZ", tmp, MainPipeline); HouseInfo[i][hExteriorZ] = floatstr(tmp);
		cache_get_field_content(i, "ExteriorR", tmp, MainPipeline); HouseInfo[i][hExteriorR] = floatstr(tmp);
		cache_get_field_content(i, "ExteriorA", tmp, MainPipeline); HouseInfo[i][hExteriorA] = floatstr(tmp);
		cache_get_field_content(i, "CustomExterior", tmp, MainPipeline); HouseInfo[i][hCustomExterior] = strval(tmp);
		cache_get_field_content(i, "InteriorX", tmp, MainPipeline); HouseInfo[i][hInteriorX] = floatstr(tmp);
		cache_get_field_content(i, "InteriorY", tmp, MainPipeline); HouseInfo[i][hInteriorY] = floatstr(tmp);
		cache_get_field_content(i, "InteriorZ", tmp, MainPipeline); HouseInfo[i][hInteriorZ] = floatstr(tmp);
		cache_get_field_content(i, "InteriorR", tmp, MainPipeline); HouseInfo[i][hInteriorR] = floatstr(tmp);
		cache_get_field_content(i, "InteriorA", tmp, MainPipeline); HouseInfo[i][hInteriorA] = floatstr(tmp);
		cache_get_field_content(i, "CustomInterior", tmp, MainPipeline); HouseInfo[i][hCustomInterior] = strval(tmp);
		cache_get_field_content(i, "ExtIW", tmp, MainPipeline); HouseInfo[i][hExtIW] = strval(tmp);
		cache_get_field_content(i, "ExtVW", tmp, MainPipeline); HouseInfo[i][hExtVW] = strval(tmp);
		cache_get_field_content(i, "IntIW", tmp, MainPipeline); HouseInfo[i][hIntIW] = strval(tmp);
		cache_get_field_content(i, "IntVW", tmp, MainPipeline); HouseInfo[i][hIntVW] = strval(tmp);
		cache_get_field_content(i, "Lock", tmp, MainPipeline); HouseInfo[i][hLock] = strval(tmp);
		cache_get_field_content(i, "Rentable", tmp, MainPipeline); HouseInfo[i][hRentable] = strval(tmp);
		cache_get_field_content(i, "RentFee", tmp, MainPipeline); HouseInfo[i][hRentFee] = strval(tmp);
		cache_get_field_content(i, "Value", tmp, MainPipeline); HouseInfo[i][hValue] = strval(tmp);
		cache_get_field_content(i, "SafeMoney", tmp, MainPipeline); HouseInfo[i][hSafeMoney] = strval(tmp);
		cache_get_field_content(i, "Pot", tmp, MainPipeline); HouseInfo[i][hPot] = strval(tmp);
		cache_get_field_content(i, "Crack", tmp, MainPipeline); HouseInfo[i][hCrack] = strval(tmp);
		cache_get_field_content(i, "Materials", tmp, MainPipeline); HouseInfo[i][hMaterials] = strval(tmp);
		cache_get_field_content(i, "Heroin", tmp, MainPipeline); HouseInfo[i][hHeroin] = strval(tmp);
		for(new j; j < 5; j++)
		{
			format(szField, sizeof(szField), "Weapons%d", j);
			cache_get_field_content(i, szField, tmp, MainPipeline);
			HouseInfo[i][hWeapons][j] = strval(tmp);
		}
		cache_get_field_content(i, "GLUpgrade", tmp, MainPipeline); HouseInfo[i][hGLUpgrade] = strval(tmp);
		cache_get_field_content(i, "PickupID", tmp, MainPipeline); HouseInfo[i][hPickupID] = strval(tmp);
		cache_get_field_content(i, "MailX", tmp, MainPipeline); HouseInfo[i][hMailX] = floatstr(tmp);
		cache_get_field_content(i, "MailY", tmp, MainPipeline); HouseInfo[i][hMailY] = floatstr(tmp);
		cache_get_field_content(i, "MailZ", tmp, MainPipeline); HouseInfo[i][hMailZ] = floatstr(tmp);
		cache_get_field_content(i, "MailA", tmp, MainPipeline); HouseInfo[i][hMailA] = floatstr(tmp);
		cache_get_field_content(i, "MailType", tmp, MainPipeline); HouseInfo[i][hMailType] = strval(tmp);
		cache_get_field_content(i, "ClosetX", tmp, MainPipeline); HouseInfo[i][hClosetX] = floatstr(tmp);
		cache_get_field_content(i, "ClosetY", tmp, MainPipeline); HouseInfo[i][hClosetY] = floatstr(tmp);
		cache_get_field_content(i, "ClosetZ", tmp, MainPipeline); HouseInfo[i][hClosetZ] = floatstr(tmp);

		if(HouseInfo[i][hExteriorX] != 0.0) ReloadHousePickup(i);
		if(HouseInfo[i][hClosetX] != 0.0) HouseInfo[i][hClosetTextID] = CreateDynamic3DTextLabel("Closet\n/closet to use", 0xFFFFFF88, HouseInfo[i][hClosetX], HouseInfo[i][hClosetY], HouseInfo[i][hClosetZ]+0.5,10.0, .testlos = 1, .worldid = HouseInfo[i][hIntVW], .interiorid = HouseInfo[i][hIntIW], .streamdistance = 10.0);
		if(HouseInfo[i][hMailX] != 0.0) RenderHouseMailbox(i);
		i++;
	}
	if(i > 0) printf("[LoadHouses] %d houses rehashed/loaded.", i);
	else printf("[LoadHouses] Failed to load any houses.");
}

forward OnLoadMailboxes();
public OnLoadMailboxes()
{
	new string[512], i;
	new rows, fields;
	cache_get_data(rows, fields, MainPipeline);
	while(i<rows)
	{
	    for(new field;field<fields;field++)
	    {
 		    cache_get_row(i, field, string, MainPipeline);
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
// Someone fix this system, I hate it! - Nathan
forward OnLoadSpeedCameras();
public OnLoadSpeedCameras()
{
	new fields, rows, index, result[128];
	cache_get_data(rows, fields, MainPipeline);

	while ((index < rows))
	{
		cache_get_field_content(index, "id", result, MainPipeline); SpeedCameras[index][_scDatabase] = strval(result);
		cache_get_field_content(index, "pos_x", result, MainPipeline); SpeedCameras[index][_scPosX] = floatstr(result);
		cache_get_field_content(index, "pos_y", result, MainPipeline); SpeedCameras[index][_scPosY] = floatstr(result);
		cache_get_field_content(index, "pos_z", result, MainPipeline); SpeedCameras[index][_scPosZ] = floatstr(result);
		cache_get_field_content(index, "rotation", result, MainPipeline); SpeedCameras[index][_scRotation] = floatstr(result);
		cache_get_field_content(index, "range", result, MainPipeline); SpeedCameras[index][_scRange] = floatstr(result);
		cache_get_field_content(index, "speed_limit", result, MainPipeline); SpeedCameras[index][_scLimit] = floatstr(result);

		if(SpeedCameras[index][_scPosX] != 0.0)
		{
			SpeedCameras[index][_scActive] = true;
			SpeedCameras[index][_scObjectId] = -1;
			SpawnSpeedCamera(index);
		}
		index++;
	}

	if (index == 0)
		printf("[SpeedCameras] No Speed Cameras loaded.");
	else
		printf("[SpeedCameras] Loaded %i Speed Cameras.", index);

	return 1;
}

forward OnNewSpeedCamera(index);
public OnNewSpeedCamera(index)
{
	new db = mysql_insert_id(MainPipeline);
	SpeedCameras[index][_scDatabase] = db;
}

// @returns
//  ID of new speed cam on success, or -1 on failure

forward OnLoadTxtLabel(index);
public OnLoadTxtLabel(index)
{
	new rows, fields, tmp[128];
	cache_get_data(rows, fields, MainPipeline);

	for(new row; row < rows; row++)
	{
		cache_get_field_content(row, "id", tmp, MainPipeline);  TxtLabels[index][tlSQLId] = strval(tmp);
		cache_get_field_content(row, "Text", TxtLabels[index][tlText], MainPipeline, 128);
		cache_get_field_content(row, "PosX", tmp, MainPipeline); TxtLabels[index][tlPosX] = floatstr(tmp);
		cache_get_field_content(row, "PosY", tmp, MainPipeline); TxtLabels[index][tlPosY] = floatstr(tmp);
		cache_get_field_content(row, "PosZ", tmp, MainPipeline); TxtLabels[index][tlPosZ] = floatstr(tmp);
		cache_get_field_content(row, "VW", tmp, MainPipeline); TxtLabels[index][tlVW] = strval(tmp);
		cache_get_field_content(row, "Int", tmp, MainPipeline); TxtLabels[index][tlInt] = strval(tmp);
		cache_get_field_content(row, "Color", tmp, MainPipeline); TxtLabels[index][tlColor] = strval(tmp);
		cache_get_field_content(row, "PickupModel", tmp, MainPipeline); TxtLabels[index][tlPickupModel] = strval(tmp);
		if(TxtLabels[index][tlPosX] != 0.0) CreateTxtLabel(index);
	}
	return 1;
}

forward OnLoadTxtLabels();
public OnLoadTxtLabels()
{
	new i, rows, fields, tmp[128];
	cache_get_data(rows, fields, MainPipeline);

	while(i < rows)
	{
		cache_get_field_content(i, "id", tmp, MainPipeline);  TxtLabels[i][tlSQLId] = strval(tmp);
		cache_get_field_content(i, "Text", TxtLabels[i][tlText], MainPipeline, 128);
		cache_get_field_content(i, "PosX", tmp, MainPipeline); TxtLabels[i][tlPosX] = floatstr(tmp);
		cache_get_field_content(i, "PosY", tmp, MainPipeline); TxtLabels[i][tlPosY] = floatstr(tmp);
		cache_get_field_content(i, "PosZ", tmp, MainPipeline); TxtLabels[i][tlPosZ] = floatstr(tmp);
		cache_get_field_content(i, "VW", tmp, MainPipeline); TxtLabels[i][tlVW] = strval(tmp);
		cache_get_field_content(i, "Int", tmp, MainPipeline); TxtLabels[i][tlInt] = strval(tmp);
		cache_get_field_content(i, "Color", tmp, MainPipeline); TxtLabels[i][tlColor] = strval(tmp);
		cache_get_field_content(i, "PickupModel", tmp, MainPipeline); TxtLabels[i][tlPickupModel] = strval(tmp);
		if(TxtLabels[i][tlPosX] != 0.0) CreateTxtLabel(i);
		i++;
	}
}

forward OnLoadPayNSprays();
public OnLoadPayNSprays()
{
	new i, rows, fields, tmp[128], string[128];
	cache_get_data(rows, fields, MainPipeline);

	while(i < rows)
	{
		cache_get_field_content(i, "id", tmp, MainPipeline);  PayNSprays[i][pnsSQLId] = strval(tmp);
		cache_get_field_content(i, "Status", tmp, MainPipeline); PayNSprays[i][pnsStatus] = strval(tmp);
		cache_get_field_content(i, "PosX", tmp, MainPipeline); PayNSprays[i][pnsPosX] = floatstr(tmp);
		cache_get_field_content(i, "PosY", tmp, MainPipeline); PayNSprays[i][pnsPosY] = floatstr(tmp);
		cache_get_field_content(i, "PosZ", tmp, MainPipeline); PayNSprays[i][pnsPosZ] = floatstr(tmp);
		cache_get_field_content(i, "VW", tmp, MainPipeline); PayNSprays[i][pnsVW] = strval(tmp);
		cache_get_field_content(i, "Int", tmp, MainPipeline); PayNSprays[i][pnsInt] = strval(tmp);
		cache_get_field_content(i, "GroupCost", tmp, MainPipeline); PayNSprays[i][pnsGroupCost] = strval(tmp);
		cache_get_field_content(i, "RegCost", tmp, MainPipeline); PayNSprays[i][pnsRegCost] = strval(tmp);
		if(PayNSprays[i][pnsStatus] > 0)
		{
			if(PayNSprays[i][pnsPosX] != 0.0)
			{
				format(string, sizeof(string), "/repaircar\nRepair Cost -- Regular: $%s | Faction: $%s\nID: %d", number_format(PayNSprays[i][pnsRegCost]), number_format(PayNSprays[i][pnsGroupCost]), i);
				PayNSprays[i][pnsTextID] = CreateDynamic3DTextLabel(string, COLOR_RED, PayNSprays[i][pnsPosX], PayNSprays[i][pnsPosY], PayNSprays[i][pnsPosZ]+0.5,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, PayNSprays[i][pnsVW], PayNSprays[i][pnsInt], -1);
				PayNSprays[i][pnsPickupID] = CreateDynamicPickup(1239, 23, PayNSprays[i][pnsPosX], PayNSprays[i][pnsPosY], PayNSprays[i][pnsPosZ], PayNSprays[i][pnsVW]);
				PayNSprays[i][pnsMapIconID] = CreateDynamicMapIcon(PayNSprays[i][pnsPosX], PayNSprays[i][pnsPosY], PayNSprays[i][pnsPosZ], 63, 0, PayNSprays[i][pnsVW], PayNSprays[i][pnsInt], -1, 500.0);
			}
		}
		i++;
	}
}

forward OnLoadArrestPoint(index);
public OnLoadArrestPoint(index)
{
	new rows, fields, tmp[128], string[128];
	cache_get_data(rows, fields, MainPipeline);

	for(new row; row < rows; row++)
	{
		cache_get_field_content(row, "id", tmp, MainPipeline);  ArrestPoints[index][arrestSQLId] = strval(tmp);
		cache_get_field_content(row, "PosX", tmp, MainPipeline); ArrestPoints[index][arrestPosX] = floatstr(tmp);
		cache_get_field_content(row, "PosY", tmp, MainPipeline); ArrestPoints[index][arrestPosY] = floatstr(tmp);
		cache_get_field_content(row, "PosZ", tmp, MainPipeline); ArrestPoints[index][arrestPosZ] = floatstr(tmp);
		cache_get_field_content(row, "VW", tmp, MainPipeline); ArrestPoints[index][arrestVW] = strval(tmp);
		cache_get_field_content(row, "Int", tmp, MainPipeline); ArrestPoints[index][arrestInt] = strval(tmp);
		cache_get_field_content(row, "Type", tmp, MainPipeline); ArrestPoints[index][arrestType] = strval(tmp);
		if(ArrestPoints[index][arrestPosX] != 0)
		{
			switch(ArrestPoints[index][arrestType])
			{
				case 0:
				{
					format(string, sizeof(string), "/arrest\nArrest Point #%d", index);
					ArrestPoints[index][arrestTextID] = CreateDynamic3DTextLabel(string, COLOR_DBLUE, ArrestPoints[index][arrestPosX], ArrestPoints[index][arrestPosY], ArrestPoints[index][arrestPosZ]+0.6, 4.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, ArrestPoints[index][arrestVW], ArrestPoints[index][arrestInt], -1);
					ArrestPoints[index][arrestPickupID] = CreateDynamicPickup(1247, 23, ArrestPoints[index][arrestPosX], ArrestPoints[index][arrestPosY], ArrestPoints[index][arrestPosZ], ArrestPoints[index][arrestVW]);
				}
				case 2:
				{
					format(string, sizeof(string), "/docarrest\nArrest Point #%d", index);
					ArrestPoints[index][arrestTextID] = CreateDynamic3DTextLabel(string, COLOR_DBLUE, ArrestPoints[index][arrestPosX], ArrestPoints[index][arrestPosY], ArrestPoints[index][arrestPosZ]+0.6, 4.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, ArrestPoints[index][arrestVW], ArrestPoints[index][arrestInt], -1);
					ArrestPoints[index][arrestPickupID] = CreateDynamicPickup(1247, 23, ArrestPoints[index][arrestPosX], ArrestPoints[index][arrestPosY], ArrestPoints[index][arrestPosZ], ArrestPoints[index][arrestVW]);
				}
				case 3:
				{
					format(string, sizeof(string), "/warrantarrest\nArrest Point #%d", index);
					ArrestPoints[index][arrestTextID] = CreateDynamic3DTextLabel(string, COLOR_DBLUE, ArrestPoints[index][arrestPosX], ArrestPoints[index][arrestPosY], ArrestPoints[index][arrestPosZ]+0.6, 4.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, ArrestPoints[index][arrestVW], ArrestPoints[index][arrestInt], -1);
					ArrestPoints[index][arrestPickupID] = CreateDynamicPickup(1247, 23, ArrestPoints[index][arrestPosX], ArrestPoints[index][arrestPosY], ArrestPoints[index][arrestPosZ], ArrestPoints[index][arrestVW]);
				}
				case 4:
				{
					format(string, sizeof(string), "/jarrest\nArrest Point #%d", index);
					ArrestPoints[index][arrestTextID] = CreateDynamic3DTextLabel(string, COLOR_DBLUE, ArrestPoints[index][arrestPosX], ArrestPoints[index][arrestPosY], ArrestPoints[index][arrestPosZ]+0.6, 4.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, ArrestPoints[index][arrestVW], ArrestPoints[index][arrestInt], -1);
					ArrestPoints[index][arrestPickupID] = CreateDynamicPickup(1247, 23, ArrestPoints[index][arrestPosX], ArrestPoints[index][arrestPosY], ArrestPoints[index][arrestPosZ], ArrestPoints[index][arrestVW]);
				}
			}
		}
	}
	return 1;
}

forward OnLoadArrestPoints();
public OnLoadArrestPoints()
{
	new i, rows, fields, tmp[128], string[128];
	cache_get_data(rows, fields, MainPipeline);

	while(i < rows)
	{
		cache_get_field_content(i, "id", tmp, MainPipeline);  ArrestPoints[i][arrestSQLId] = strval(tmp);
		cache_get_field_content(i, "PosX", tmp, MainPipeline); ArrestPoints[i][arrestPosX] = floatstr(tmp);
		cache_get_field_content(i, "PosY", tmp, MainPipeline); ArrestPoints[i][arrestPosY] = floatstr(tmp);
		cache_get_field_content(i, "PosZ", tmp, MainPipeline); ArrestPoints[i][arrestPosZ] = floatstr(tmp);
		cache_get_field_content(i, "VW", tmp, MainPipeline); ArrestPoints[i][arrestVW] = strval(tmp);
		cache_get_field_content(i, "Int", tmp, MainPipeline); ArrestPoints[i][arrestInt] = strval(tmp);
		cache_get_field_content(i, "Type", tmp, MainPipeline); ArrestPoints[i][arrestType] = strval(tmp);
		if(ArrestPoints[i][arrestPosX] != 0)
		{
			switch(ArrestPoints[i][arrestType])
			{
				case 0:
				{
					format(string, sizeof(string), "/arrest\nArrest Point #%d", i);
					ArrestPoints[i][arrestTextID] = CreateDynamic3DTextLabel(string, COLOR_DBLUE, ArrestPoints[i][arrestPosX], ArrestPoints[i][arrestPosY], ArrestPoints[i][arrestPosZ]+0.6, 4.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, ArrestPoints[i][arrestVW], ArrestPoints[i][arrestInt], -1);
					ArrestPoints[i][arrestPickupID] = CreateDynamicPickup(1247, 23, ArrestPoints[i][arrestPosX], ArrestPoints[i][arrestPosY], ArrestPoints[i][arrestPosZ], ArrestPoints[i][arrestVW]);
				}
				case 2:
				{
					format(string, sizeof(string), "/docarrest\nArrest Point #%d", i);
					ArrestPoints[i][arrestTextID] = CreateDynamic3DTextLabel(string, COLOR_DBLUE, ArrestPoints[i][arrestPosX], ArrestPoints[i][arrestPosY], ArrestPoints[i][arrestPosZ]+0.6, 4.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, ArrestPoints[i][arrestVW], ArrestPoints[i][arrestInt], -1);
					ArrestPoints[i][arrestPickupID] = CreateDynamicPickup(1247, 23, ArrestPoints[i][arrestPosX], ArrestPoints[i][arrestPosY], ArrestPoints[i][arrestPosZ], ArrestPoints[i][arrestVW]);
				}
				case 3:
				{
					format(string, sizeof(string), "/warrantarrest\nArrest Point #%d", i);
					ArrestPoints[i][arrestTextID] = CreateDynamic3DTextLabel(string, COLOR_DBLUE, ArrestPoints[i][arrestPosX], ArrestPoints[i][arrestPosY], ArrestPoints[i][arrestPosZ]+0.6, 4.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, ArrestPoints[i][arrestVW], ArrestPoints[i][arrestInt], -1);
					ArrestPoints[i][arrestPickupID] = CreateDynamicPickup(1247, 23, ArrestPoints[i][arrestPosX], ArrestPoints[i][arrestPosY], ArrestPoints[i][arrestPosZ], ArrestPoints[i][arrestVW]);
				}
				case 4:
				{
					format(string, sizeof(string), "/jarrest\nArrest Point #%d", i);
					ArrestPoints[i][arrestTextID] = CreateDynamic3DTextLabel(string, COLOR_DBLUE, ArrestPoints[i][arrestPosX], ArrestPoints[i][arrestPosY], ArrestPoints[i][arrestPosZ]+0.6, 4.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, ArrestPoints[i][arrestVW], ArrestPoints[i][arrestInt], -1);
					ArrestPoints[i][arrestPickupID] = CreateDynamicPickup(1247, 23, ArrestPoints[i][arrestPosX], ArrestPoints[i][arrestPosY], ArrestPoints[i][arrestPosZ], ArrestPoints[i][arrestVW]);
				}
			}
		}
		i++;
	}
}

forward OnLoadImpoundPoint(index);
public OnLoadImpoundPoint(index)
{
	new rows, fields, tmp[128], string[128];
	cache_get_data(rows, fields, MainPipeline);

	for(new row; row < rows; row++)
	{
		cache_get_field_content(row, "id", tmp, MainPipeline);  ImpoundPoints[index][impoundSQLId] = strval(tmp);
		cache_get_field_content(row, "PosX", tmp, MainPipeline); ImpoundPoints[index][impoundPosX] = floatstr(tmp);
		cache_get_field_content(row, "PosY", tmp, MainPipeline); ImpoundPoints[index][impoundPosY] = floatstr(tmp);
		cache_get_field_content(row, "PosZ", tmp, MainPipeline); ImpoundPoints[index][impoundPosZ] = floatstr(tmp);
		cache_get_field_content(row, "VW", tmp, MainPipeline); ImpoundPoints[index][impoundVW] = strval(tmp);
		cache_get_field_content(row, "Int", tmp, MainPipeline); ImpoundPoints[index][impoundInt] = strval(tmp);
		if(ImpoundPoints[index][impoundPosX] != 0)
		{
			format(string, sizeof(string), "Impound Yard #%d\nType /impound to impound a vehicle", index);
			ImpoundPoints[index][impoundTextID] = CreateDynamic3DTextLabel(string, COLOR_YELLOW, ImpoundPoints[index][impoundPosX], ImpoundPoints[index][impoundPosY], ImpoundPoints[index][impoundPosZ]+0.6, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, ImpoundPoints[index][impoundVW], ImpoundPoints[index][impoundInt], -1);
		}
	}
	return 1;
}

forward OnLoadImpoundPoints();
public OnLoadImpoundPoints()
{
	new i, rows, fields, tmp[128], string[128];
	cache_get_data(rows, fields, MainPipeline);

	while(i < rows)
	{
		cache_get_field_content(i, "id", tmp, MainPipeline);  ImpoundPoints[i][impoundSQLId] = strval(tmp);
		cache_get_field_content(i, "PosX", tmp, MainPipeline); ImpoundPoints[i][impoundPosX] = floatstr(tmp);
		cache_get_field_content(i, "PosY", tmp, MainPipeline); ImpoundPoints[i][impoundPosY] = floatstr(tmp);
		cache_get_field_content(i, "PosZ", tmp, MainPipeline); ImpoundPoints[i][impoundPosZ] = floatstr(tmp);
		cache_get_field_content(i, "VW", tmp, MainPipeline); ImpoundPoints[i][impoundVW] = strval(tmp);
		cache_get_field_content(i, "Int", tmp, MainPipeline); ImpoundPoints[i][impoundInt] = strval(tmp);
		if(ImpoundPoints[i][impoundPosX] != 0)
		{
			format(string, sizeof(string), "Impound Yard #%d\nType /impound to impound a vehicle", i);
			ImpoundPoints[i][impoundTextID] = CreateDynamic3DTextLabel(string, COLOR_YELLOW, ImpoundPoints[i][impoundPosX], ImpoundPoints[i][impoundPosY], ImpoundPoints[i][impoundPosZ]+0.6, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, ImpoundPoints[i][impoundVW], ImpoundPoints[i][impoundInt], -1);
		}
		i++;
	}
}

forward LoadDynamicGroups();
public LoadDynamicGroups()
{
    mysql_function_query(MainPipeline, "SELECT * FROM `groups`", true, "Group_QueryFinish", "ii", GROUP_QUERY_LOAD, 0);
	mysql_function_query(MainPipeline, "SELECT * FROM `lockers`", true, "Group_QueryFinish", "ii", GROUP_QUERY_LOCKERS, 0);
	mysql_function_query(MainPipeline, "SELECT * FROM `jurisdictions`", true, "Group_QueryFinish", "ii", GROUP_QUERY_JURISDICTIONS, 0);
	return ;
}

forward LoadDynamicGroupVehicles();
public LoadDynamicGroupVehicles()
{
    mysql_function_query(MainPipeline, "SELECT * FROM `groupvehs`", true, "DynVeh_QueryFinish", "ii", GV_QUERY_LOAD, 0);
    return 1;
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

		format(string, sizeof(string), "UPDATE `rentedcars` SET `posx` = '%f', `posy` = '%f', `posz` = '%f', `posa` = '%f' WHERE `sqlid` = '%d'", x, y, z, angle, GetPlayerSQLId(playerid));
        mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);

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
	if(mysql_affected_rows(MainPipeline)) {

		new
			szBuffer[129],
			szMessage[103];

		GetPVarString(index, "PassChange", szBuffer, sizeof(szBuffer));
		format(szMessage, sizeof(szMessage), "You have changed your password to '%s'.", szBuffer);
		SendClientMessageEx(index, COLOR_YELLOW, szMessage);

		format(szMessage, sizeof(szMessage), "%s (IP: %s) has changed their password.", GetPlayerNameEx(index), PlayerInfo[index][pIP]);
		Log("logs/password.log", szMessage);
		DeletePVar(index, "PassChange");

		if(PlayerInfo[index][pForcePasswordChange] == 1)
		{
		    PlayerInfo[index][pForcePasswordChange] = 0;
		    format(szMessage, sizeof(szMessage), "UPDATE `accounts` SET `ForcePasswordChange` = '0' WHERE `id` = '%i'", PlayerInfo[index][pId]);
			mysql_function_query(MainPipeline, szMessage, false, "OnQueryFinish", "ii", SENDDATA_THREAD, index);
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

		if(mysql_affected_rows(MainPipeline)) {
			format(string, sizeof(string), "You have successfully changed %s's pin.", name);
			SendClientMessageEx(index, COLOR_WHITE, string);
		}
		else {
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

		if(mysql_affected_rows(MainPipeline)) {
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
    new string[128], rows, fields, sResult[24], tcount, hhour[9], chour;
	cache_get_data(rows, fields, MainPipeline);

	switch(type)
	{
		case 0:
		{
			cache_get_field_content(0, "SUM(count)", sResult, MainPipeline); tcount = strval(sResult);
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
					cache_get_field_content(i, "count", sResult, MainPipeline); new hcount = strval(sResult);
					cache_get_field_content(i, "hour", hhour, MainPipeline, sizeof(hhour));
					format(hhour, sizeof(hhour), "%s", str_replace(":00:00", "", hhour));
					chour = strval(hhour);
					format(string, sizeof(string), "%s: {%06x}%d", ConvertToTwelveHour(chour), COLOR_GREEN >>> 8, hcount);
					SendClientMessageEx(playerid, COLOR_WHITE, string);
				}
			}
		}
		case 2:
		{
			cache_get_field_content(0, "SUM(count)", sResult, MainPipeline); tcount = strval(sResult);
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
					cache_get_field_content(i, "count", sResult, MainPipeline); new hcount = strval(sResult);
					cache_get_field_content(i, "hour", hhour, MainPipeline, sizeof(hhour));
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
    new string[128], rows, fields, giveplayerid, sResult[MAX_PLAYER_NAME];
	cache_get_data(rows, fields, MainPipeline);

	if(rows > 0)
	{
		switch(type)
		{
			case 0:
			{
				cache_get_field_content(0, "id", sResult, MainPipeline); giveplayerid = strval(sResult);
				cache_get_field_content(0, "Username", sResult, MainPipeline, sizeof(sResult));
				format(string, sizeof(string), "SELECT SUM(count) FROM `tokens_report` WHERE `playerid` = %d AND `date` = '%s'", giveplayerid, tdate);
				mysql_function_query(MainPipeline, string, true, "QueryCheckCountFinish", "issi", playerid, sResult, tdate, 0);
				format(string, sizeof(string), "SELECT `count`, `hour` FROM `tokens_report` WHERE `playerid` = %d AND `date` = '%s' ORDER BY `hour` ASC", giveplayerid, tdate);
				mysql_function_query(MainPipeline, string, true, "QueryCheckCountFinish", "issi", playerid, sResult, tdate, 1);
			}
			case 1:
			{
				cache_get_field_content(0, "id", sResult, MainPipeline); giveplayerid = strval(sResult);
				cache_get_field_content(0, "Username", sResult, MainPipeline, sizeof(sResult));
				format(string, sizeof(string), "SELECT SUM(count) FROM `tokens_request` WHERE `playerid` = %d AND `date` = '%s'", giveplayerid, tdate);
				mysql_function_query(MainPipeline, string, true, "QueryCheckCountFinish", "issi", playerid, sResult, tdate, 2);
				format(string, sizeof(string), "SELECT `count`, `hour` FROM `tokens_request` WHERE `playerid` = %d AND `date` = '%s' ORDER BY `hour` ASC", giveplayerid, tdate);
				mysql_function_query(MainPipeline, string, true, "QueryCheckCountFinish", "issi", playerid, sResult, tdate, 3);
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
		if(mysql_affected_rows(MainPipeline)) {
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
	    new rows, fields;
	    new string[128], ip[32], sqlid[5], id;
    	cache_get_data(rows, fields, MainPipeline);

    	if(rows)
    	{
			cache_get_field_content(0, "id", sqlid, MainPipeline); id = strval(sqlid);
			cache_get_field_content(0, "IP", ip, MainPipeline, 16);

			MySQLBan(id, ip, "Offline Banned (/banaccount)", 1, GetPlayerNameEx(index));

			format(string, sizeof(string), "INSERT INTO `ip_bans` (`ip`, `date`, `reason`, `admin`) VALUES ('%s', NOW(), '%s', '%s')", ip, "Offline Banned", GetPlayerNameEx(index));
			mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);
		}
	}
	return 1;
}

forward OnUnbanPlayer(index);
public OnUnbanPlayer(index)
{
	new string[128], name[24];
	GetPVarString(index, "OnUnbanPlayer", name, 24);

	if(mysql_affected_rows(MainPipeline)) {
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
        new rows, fields;
		cache_get_data(rows, fields, MainPipeline);
		if(rows) {
			cache_get_field_content(0, "IP", ip, MainPipeline, 16);
			RemoveBan(index, ip);

			format(string, sizeof(string), "UPDATE `bans` SET `status` = 4, `date_unban` = NOW() WHERE `ip_address` = '%s'", ip);
			mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);
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
	if(mysql_affected_rows(MainPipeline)) {
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

	if(mysql_affected_rows(MainPipeline)) {
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

forward OnSetMyName(index);
public OnSetMyName(index)
{
	if(IsPlayerConnected(index))
	{
		new rows, fields;
		cache_get_data(rows, fields, MainPipeline);
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
		    new rows, fields;
			cache_get_data(rows, fields, MainPipeline);
			if(rows < 1)
			{
				new string[128], tmpName[24], playername[24];
				GetPVarString(index, "OnSetName", tmpName, 24);

				GetPlayerName(extraid, playername, sizeof(playername));

				UpdateCitizenApp(extraid, PlayerInfo[extraid][pNation]);
				
				if(PlayerInfo[extraid][pMarriedID] != -1)
				{
					//foreach(new i: Player)
					for(new i = 0; i < MAX_PLAYERS; ++i)
					{
						if(IsPlayerConnected(i))
						{
							if(PlayerInfo[extraid][pMarriedID] == GetPlayerSQLId(i)) format(PlayerInfo[i][pMarriedName], MAX_PLAYER_NAME, "%s", tmpName);
						}	
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
    					format(string, sizeof(string), "UPDATE `accounts` SET `Username`='%s' WHERE `Username`='%s'", tmpName, playername);
						mysql_function_query(MainPipeline, string, true, "OnSetNameTwo", "ii", index, extraid);
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
		new rows, fields;
		cache_get_data(rows, fields, MainPipeline);
		if(rows < 1)
		{
			new newname[24], oldname[24];
			GetPVarString(extraid, "NewNameRequest", newname, 24);
			GetPlayerName(extraid, oldname, sizeof(oldname));

			UpdateCitizenApp(extraid, PlayerInfo[extraid][pNation]);

			if(PlayerInfo[extraid][pMarriedID] != -1)
			{
				//foreach(new i: Player)
				for(new i = 0; i < MAX_PLAYERS; ++i)
				{
					if(IsPlayerConnected(i))
					{
						if(PlayerInfo[extraid][pMarriedID] == GetPlayerSQLId(i)) format(PlayerInfo[i][pMarriedName], MAX_PLAYER_NAME, "%s", newname);
					}	
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
				format(string, sizeof(string), "[VIP NAMECHANGES] %s has changed their name to %s.", GetPlayerNameEx(extraid), newname);
				Log("logs/vipnamechanges.log", string);
			}

			if((0 <= PlayerInfo[extraid][pMember] < MAX_GROUPS) && PlayerInfo[extraid][pRank] >= arrGroupData[PlayerInfo[extraid][pMember]][g_iFreeNameChange])
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
    					format(string, sizeof(string), "UPDATE `accounts` SET `Username`='%s' WHERE `Username`='%s'", newname, oldname);
						mysql_function_query(MainPipeline, string, true, "OnApproveSetName", "ii", index, extraid);
					}
					else
					{
					    SendClientMessage(extraid, COLOR_REALRED, "There was an issue with your name change.");
					    format(string, sizeof(string), "%s's name change has failed due to incorrect size or characters.", GetPlayerNameExt(extraid));
					    SendClientMessage(index, COLOR_REALRED, string);
					    format(string, sizeof(string), "Error changing %s's name to %s", GetPlayerNameExt(extraid), newname);
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
    					format(string, sizeof(string), "UPDATE `accounts` SET `Username`='%s' WHERE `Username`='%s'", newname, oldname);
						mysql_function_query(MainPipeline, string, true, "OnApproveSetName", "ii", index, extraid);
					}
					else
					{
					    SendClientMessage(extraid, COLOR_REALRED, "There was an issue with your name change.");
					    format(string, sizeof(string), "%s's name change has failed due to incorrect size or characters.", GetPlayerNameExt(extraid));
					    SendClientMessage(index, COLOR_REALRED, string);
					    format(string, sizeof(string), "Error changing %s's name to %s", GetPlayerNameExt(extraid), newname);
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
	    					format(string, sizeof(string), "UPDATE `accounts` SET `Username`='%s' WHERE `Username`='%s'", newname, oldname);
							mysql_function_query(MainPipeline, string, true, "OnApproveSetName", "ii", index, extraid);
						}
						else
						{
						    SendClientMessage(extraid, COLOR_REALRED, "There was an issue with your name change.");
						    format(string, sizeof(string), "%s's name change has failed due to incorrect size or characters.", GetPlayerNameExt(extraid));
						    SendClientMessage(index, COLOR_REALRED, string);
						    format(string, sizeof(string), "Error changing %s's name to %s", GetPlayerNameExt(extraid), newname);
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
						if(PlayerInfo[extraid][pDonateRank] >= 3)
						{
							format(string, sizeof(string), " Your name has been changed from %s to %s for $%d (10 percent VIP Discount).", GetPlayerNameEx(extraid), newname, GetPVarInt(extraid, "NameChangeCost"));
						}
						else
						{
							format(string, sizeof(string), " Your name has been changed from %s to %s for $%d.", GetPlayerNameEx(extraid), newname, GetPVarInt(extraid, "NameChangeCost"));
						}
						SendClientMessageEx(extraid, COLOR_YELLOW, string);
						GivePlayerCash(extraid, -GetPVarInt(extraid, "NameChangeCost"));
						format(string, sizeof(string), " You have changed %s's name to %s for $%d.", GetPlayerNameEx(extraid), newname, GetPVarInt(extraid, "NameChangeCost"));
						SendClientMessageEx(index,COLOR_YELLOW,string);
						format(string, sizeof(string), "%s changed \"%s\"s name to \"%s\" (id: %i) for $%d",GetPlayerNameEx(index),GetPlayerNameEx(extraid),newname, GetPlayerSQLId(extraid), GetPVarInt(extraid, "NameChangeCost"));
						Log("logs/stats.log", string);
						format(string, sizeof(string), "%s has approved %s's name change to %s for $%d",GetPlayerNameEx(index),GetPlayerNameEx(extraid), newname, GetPVarInt(extraid, "NameChangeCost"));
						ABroadCast(COLOR_YELLOW, string, 3);

						if(SetPlayerName(extraid, newname) == 1)
						{
	    					format(string, sizeof(string), "UPDATE `accounts` SET `Username`='%s' WHERE `Username`='%s'", newname, oldname);
							mysql_function_query(MainPipeline, string, true, "OnApproveSetName", "ii", index, extraid);
						}
						else
						{
						    SendClientMessage(extraid, COLOR_REALRED, "There was an issue with your name change.");
						    format(string, sizeof(string), "%s's name change has failed due to incorrect size or characters.", GetPlayerNameExt(extraid));
						    SendClientMessage(index, COLOR_REALRED, string);
						    format(string, sizeof(string), "Error changing %s's name to %s", GetPlayerNameExt(extraid), newname);
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
			SendClientMessageEx(extraid, COLOR_GRAD2, "That name already exists, please choose a different one.");
			SendClientMessageEx(index, COLOR_GRAD2, "That name already exists.");
			DeletePVar(extraid, "RequestingNameChange");
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

	if(mysql_affected_rows(MainPipeline)) {
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
		new rows, fields;
		cache_get_data(rows, fields, MainPipeline);
		if(rows)
		{
			cache_get_field_content(0, "AdminLevel", ip, MainPipeline, 16); AdminLvL = strval(ip);
			cache_get_field_content(0, "Username", name, MainPipeline, MAX_PLAYER_NAME);
			if(AdminLvL <= 1 || (AdminLvL <= PlayerInfo[index][pAdmin] && PlayerInfo[index][pAdmin] >= 1338))
			{
				cache_get_field_content(0, "IP", ip, MainPipeline, 16);
				format(string, sizeof(string), "%s's IP: %s", name, ip);
				SendClientMessageEx(index, COLOR_WHITE, string);
				format(string, sizeof(string), "%s has IP Checked %s", GetPlayerNameEx(index), name);
				if(AdminLvL >= 2) Log("logs/adminipcheck.log", string); else Log("logs/ipcheck.log", string);
				return 1;
			}
			if(AdminLvL >= 2)
			{
				if(AdminLvL > PlayerInfo[index][pAdmin])
				{
					format(string, sizeof(string), "%s has tried to offline check the IP address of a higher admin\nPlease report this to SIU/OED or an EA", GetPlayerNameEx(index));
					for(new i; i < MAX_PLAYERS; i++)
					{
						if(PlayerInfo[i][pAdmin] >= 4) ShowPlayerDialog(i, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "{FFFF00}AdminWarning - {FF0000}Report ASAP", string, "Close", "");
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

forward OnProcessOrderCheck(index, extraid);
public OnProcessOrderCheck(index, extraid)
{
	if(IsPlayerConnected(index))
	{
		new string[164],playerip[32], giveplayerip[32];
		GetPlayerIp(index, playerip, sizeof(playerip));
		GetPlayerIp(extraid, giveplayerip, sizeof(giveplayerip));

		new rows, fields;
		cache_get_data(rows, fields, MainPipeline);
		if(rows)
		{
			SendClientMessageEx(index, COLOR_WHITE, "This order has previously been processed, therefore it did not count toward your pay.");
			format(string, sizeof(string), "%s(IP: %s) has processed shop order ID %d from %s(IP: %s).", GetPlayerNameEx(index), playerip, GetPVarInt(index, "processorder"), GetPlayerNameEx(extraid), giveplayerip);
			Log("logs/shoporders.log", string);
		}
		else
		{
			format(string, sizeof(string), "%s(IP: %s) has processed shop order ID %d from %s(IP: %s).", GetPlayerNameEx(index), playerip, GetPVarInt(index, "processorder"), GetPlayerNameEx(extraid), giveplayerip);
			Log("logs/shopconfirmedorders.log", string);
			PlayerInfo[index][pShopTechOrders]++;

			format(string, sizeof(string), "INSERT INTO shoptech (id,total,dtotal) VALUES (%d,1,%f) ON DUPLICATE KEY UPDATE total = total + 1, dtotal = dtotal + %f", GetPlayerSQLId(index), ShopTechPay, ShopTechPay);
			mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "ii", SENDDATA_THREAD, index);

			format(string, sizeof(string), "INSERT INTO `orders` (`id`) VALUES ('%d')", GetPVarInt(index, "processorder"));
			mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "ii", SENDDATA_THREAD, index);
		}
		DeletePVar(index, "processorder");
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

	if(mysql_affected_rows(MainPipeline)) {
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

forward OnSetDDOwner(playerid, doorid);
public OnSetDDOwner(playerid, doorid)
{
	if(IsPlayerConnected(playerid))
	{
	    new rows, fields;
	    new string[128], sqlid[5], playername[MAX_PLAYER_NAME], id;
    	cache_get_data(rows, fields, MainPipeline);

    	if(rows)
    	{
			cache_get_field_content(0, "id", sqlid, MainPipeline); id = strval(sqlid);
			cache_get_field_content(0, "Username", playername, MainPipeline, MAX_PLAYER_NAME);
			strcat((DDoorsInfo[doorid][ddOwnerName][0] = 0, DDoorsInfo[doorid][ddOwnerName]), playername, MAX_PLAYER_NAME);
			DDoorsInfo[doorid][ddOwner] = id;

			format(string, sizeof(string), "Successfully set the owner to %s.", playername);
			SendClientMessageEx(playerid, COLOR_WHITE, string);

			DestroyDynamicPickup(DDoorsInfo[doorid][ddPickupID]);
			if(IsValidDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID])) DestroyDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID]);
			CreateDynamicDoor(doorid);
			SaveDynamicDoor(doorid);
			format(string, sizeof(string), "%s has edited door ID %d's owner to %s (SQL ID: %d).", GetPlayerNameEx(playerid), doorid, playername, id);
			Log("logs/ddedit.log", string);
		}
		else SendClientMessageEx(playerid, COLOR_GREY, "That account name does not appear to exist.");
	}
	return 1;
}

forward OnPrisonAccount(index);
public OnPrisonAccount(index)
{
	new string[128], name[24], reason[64];
	GetPVarString(index, "OnPrisonAccount", name, 24);
	GetPVarString(index, "OnPrisonAccountReason", reason, 64);

	if(mysql_affected_rows(MainPipeline)) {
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

	if(mysql_affected_rows(MainPipeline)) {
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
    new string[128], killername[MAX_PLAYER_NAME], killedname[MAX_PLAYER_NAME], kDate[20], weapon[56], rows, fields;
	cache_get_data(rows, fields, MainPipeline);
	if(rows)
	{
		for(new i; i < rows; i++)
		{
			cache_get_row(i, 0, killername, MainPipeline, MAX_PLAYER_NAME);
			cache_get_row(i, 1, killedname, MainPipeline, MAX_PLAYER_NAME);
			cache_get_field_content(i, "killerid", string, MainPipeline); new killer = strval(string);
			cache_get_field_content(i, "killedid", string, MainPipeline); new killed = strval(string);
			cache_get_field_content(i, "date", kDate, MainPipeline, sizeof(kDate));
			cache_get_field_content(i, "weapon", weapon, MainPipeline, sizeof(weapon));
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
		new string[256], giveplayerid;

		new rows, fields;
		cache_get_data(rows, fields, MainPipeline);

		if(rows)
		{
			cache_get_field_content(0, "id", string, MainPipeline); giveplayerid = strval(string);
			format(string, sizeof(string), "SELECT Killer.Username, Killed.Username, k.* FROM kills k LEFT JOIN accounts Killed ON k.killedid = Killed.id LEFT JOIN accounts Killer ON Killer.id = k.killerid WHERE k.killerid = %d OR k.killedid = %d ORDER BY `date` DESC LIMIT 10", giveplayerid, giveplayerid);
			mysql_function_query(MainPipeline, string, true, "OnGetLatestOKills", "iis", playerid, giveplayerid, giveplayername);
		}
		else return SendClientMessageEx(playerid, COLOR_GREY, "This account does not exist.");
	}
	return 1;
}

forward OnGetLatestOKills(playerid, giveplayerid, giveplayername[]);
public OnGetLatestOKills(playerid, giveplayerid, giveplayername[])
{
    new string[128], killername[MAX_PLAYER_NAME], killedname[MAX_PLAYER_NAME], kDate[20], weapon[56], rows, fields;
	cache_get_data(rows, fields, MainPipeline);
	if(rows)
	{
		SendClientMessageEx(playerid, COLOR_GREEN, "________________________________________________");
		format(string, sizeof(string), "<< Last 10 Kills/Deaths of %s >>", StripUnderscore(giveplayername));
		SendClientMessageEx(playerid, COLOR_YELLOW, string);
		for(new i; i < rows; i++)
		{
			cache_get_row(i, 0, killername, MainPipeline, MAX_PLAYER_NAME);
			cache_get_row(i, 1, killedname, MainPipeline, MAX_PLAYER_NAME);
			cache_get_field_content(i, "killerid", string, MainPipeline); new killer = strval(string);
			cache_get_field_content(i, "killedid", string, MainPipeline); new killed = strval(string);
			cache_get_field_content(i, "date", kDate, MainPipeline, sizeof(kDate));
			cache_get_field_content(i, "weapon", weapon, MainPipeline, sizeof(weapon));
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
	format(string, sizeof(string), "Deleted %d strikes against %s", mysql_affected_rows(MainPipeline), GetPlayerNameEx(giveplayerid));
	SendClientMessage(playerid, COLOR_WHITE, string);
	return 1;
}

forward OnDMRLookup(playerid, giveplayerid);
public OnDMRLookup(playerid, giveplayerid)
{
	new string[128], rows, fields;
	cache_get_data(rows, fields, MainPipeline);
	format(string, sizeof(string), "Showing the last %d /dmreports by %s", rows, GetPlayerNameEx(giveplayerid));
	SendClientMessage(playerid, COLOR_WHITE, string);
	SendClientMessage(playerid, COLOR_WHITE, "| Reported | Time |");
	for(new i;i < rows;i++)
	{
 		new szResult[32], name[MAX_PLAYER_NAME], timestamp;
		cache_get_row(i, 0, szResult, MainPipeline); timestamp = strval(szResult);
		cache_get_row(i, 1, name, MainPipeline, MAX_PLAYER_NAME);
		format(string, sizeof(string), "%s - %s", name, date(timestamp, 1));
		SendClientMessage(playerid, COLOR_WHITE, string);
	}
	return 1;
}

forward OnDMTokenLookup(playerid, giveplayerid);
public OnDMTokenLookup(playerid, giveplayerid)
{
	new string[128], rows, fields;
	cache_get_data(rows, fields, MainPipeline);
	format(string, sizeof(string), "Showing the %d active /dmreports on %s", rows, GetPlayerNameEx(giveplayerid));
	SendClientMessage(playerid, COLOR_WHITE, string);
	SendClientMessage(playerid, COLOR_WHITE, "| Reporter | Time |");
	for(new i;i < rows;i++)
	{
 		new szResult[32], name[MAX_PLAYER_NAME], timestamp;
		cache_get_row(i, 0, szResult, MainPipeline); timestamp = strval(szResult);
		cache_get_row(i, 1, name, MainPipeline);
		format(string, sizeof(string), "%s - %s", name, date(timestamp, 1));
		SendClientMessage(playerid, COLOR_WHITE, string);
	}
	return 1;
}

forward OnDMWatchListLookup(playerid);
public OnDMWatchListLookup(playerid)
{
	new string[128], rows, fields;
	cache_get_data(rows, fields, MainPipeline);
	format(string, sizeof(string), "Showing %d active people to watch", rows);
	SendClientMessage(playerid, COLOR_WHITE, string);
	for(new i;i < rows;i++)
	{
 		new name[MAX_PLAYER_NAME], watchid;
		cache_get_row(i, 0, name, MainPipeline);
		sscanf(name, "u", watchid);
		format(string, sizeof(string), "(ID: %d) %s", watchid, name);
		SendClientMessage(playerid, (PlayerInfo[watchid][pJailTime] > 0) ? TEAM_ORANGE_COLOR:COLOR_WHITE, string);
	}
	return 1;
}

forward OnDMWatch(playerid);
public OnDMWatch(playerid)
{
	new rows, fields;
    cache_get_data(rows, fields, MainPipeline);
    if(rows)
    {
		new string[128], namesql[MAX_PLAYER_NAME], name[MAX_PLAYER_NAME];
		cache_get_row(0, 0, namesql, MainPipeline);
		//foreach(new i: Player)
		for(new i = 0; i < MAX_PLAYERS; ++i)
		{
			if(IsPlayerConnected(i))
			{
				if(!PlayerInfo[i][pJailTime])
				{
					GetPlayerName(i, name, sizeof(name));
					if(strcmp(name, namesql, true) == 0)
					{
						//foreach(new x: Player)
						for(new x = 0; x < MAX_PLAYERS; ++x)
						{
							if(IsPlayerConnected(x))
							{
								if(GetPVarInt(x, "pWatchdogWatching") == i)
								{
									return SendClientMessage(playerid, COLOR_WHITE, "The random person selected for you is already being watched, please try again!");
								}
							}	
						}
						format(string, sizeof(string), "You now have access to /spec %s (ID: %i). Use /dmalert if this person deathmatches.", name, i);
						SendClientMessage(playerid, COLOR_WHITE, string);
						return SetPVarInt(playerid, "pWatchdogWatching", i);
					}
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

	if(mysql_affected_rows(MainPipeline)) {
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
		new rows, fields;
		cache_get_data(rows, fields, MainPipeline);
		if(rows)
		{
		    new Pin[256];
   			cache_get_field_content(0, "Pin", Pin, MainPipeline, 256);
   			if(isnull(Pin)) {
   			    ShowPlayerDialog(index, DIALOG_CREATEPIN, DIALOG_STYLE_INPUT, "Pin Number", "Create a pin number so you can secure your account credits.", "Create", "Exit");
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
							ShowPlayerDialog(index, DIALOG_MISCSHOP, DIALOG_STYLE_LIST, "Misc Shop", szDialog, "Select", "Cancel");
						}
						case 2: SetPVarInt(index, "RentaCar", 1), ShowModelSelectionMenu(index, CarList2, "Rent a Car!");
						case 3: ShowModelSelectionMenu(index, CarList2, "Car Shop");
						case 4: ShowPlayerDialog( index, DIALOG_HOUSESHOP, DIALOG_STYLE_LIST, "House Shop", "Purchase House\nHouse Interior Change\nHouse Move\nGarage - Small\nGarage - Medium\nGarage - Large\nGarage - Extra Large","Select", "Exit" );
						case 5: ShowPlayerDialog( index, DIALOG_VIPSHOP, DIALOG_STYLE_LIST, "VIP Shop", "Purchase VIP\nRenew Gold VIP","Continue", "Exit" );
						case 6: ShowPlayerDialog(index, DIALOG_SHOPBUSINESS, DIALOG_STYLE_LIST, "Businesses Shop", "Purchase Business\nRenew Business", "Select", "Exit");
						case 7: ShowModelSelectionMenu(index, PlaneList, "Plane Shop");
						case 8: ShowModelSelectionMenu(index, BoatList, "Boat Shop");
						case 9: ShowModelSelectionMenu(index, CarList3, "Restricted Car Shop");
					}
					DeletePVar(index, "OpenShop");
				}
				else
				{
					ShowPlayerDialog(index, DIALOG_ENTERPIN, DIALOG_STYLE_INPUT, "Pin Number", "(INVALID PIN)\n\nEnter your pin number to access credit shops.", "Confirm", "Exit");
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
		new rows, fields;
		cache_get_data(rows, fields, MainPipeline);
		if(rows)
		{
		    new Pin[128];
   			cache_get_field_content(0, "Pin", Pin, MainPipeline, 128);
   			if(isnull(Pin)) {
   			    ShowPlayerDialog(index, DIALOG_CREATEPIN, DIALOG_STYLE_INPUT, "Pin Number", "Create a pin number so you can secure your account credits.", "Create", "Exit");
   			}
   			else
   			{
   			    ShowPlayerDialog(index, DIALOG_ENTERPIN, DIALOG_STYLE_INPUT, "Pin Number", "Enter your pin number to access credit shops.", "Confirm", "Exit");
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
    new string[128], sender[MAX_PLAYER_NAME], message[256], sDate[20], rows, fields;
	cache_get_data(rows, fields, MainPipeline);
	if(rows)
	{
		SendClientMessageEx(playerid, COLOR_GREEN, "________________________________________________");
		SendClientMessageEx(playerid, COLOR_YELLOW, "<< Last 10 SMS Received >>");
		for(new i; i < rows; i++)
		{
			cache_get_field_content(i, "sender", sender, MainPipeline, MAX_PLAYER_NAME);
			cache_get_field_content(i, "sendernumber", string, MainPipeline); new sendernumber = strval(string);
			cache_get_field_content(i, "message", message, MainPipeline, sizeof(message));
			cache_get_field_content(i, "date", sDate, MainPipeline, sizeof(sDate));
			if(sendernumber != 0) format(string, sizeof(string), "[%s] SMS: %s, Sender: %s (%d)", sDate, message, StripUnderscore(sender), sendernumber);
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
		iFields,
		iRows,
		iIndex,
		i = 0,
		szResult[128];

	cache_get_data(iRows, iFields, MainPipeline);

	switch(iType) {
		case GROUP_QUERY_JURISDICTIONS:
  		{
  		    for(new iG = 0; iG < MAX_GROUPS; iG++)
  		    {
  		        arrGroupData[iG][g_iJCount] = 0;
  		    }
			while(iIndex < iRows) {

				cache_get_field_content(iIndex, "GroupID", szResult, MainPipeline, 24);
				new iGroup = strval(szResult);

				if(arrGroupData[iGroup][g_iJCount] > MAX_GROUP_JURISDICTIONS) arrGroupData[iGroup][g_iJCount] = MAX_GROUP_JURISDICTIONS;
				if (!(0 <= iGroup < MAX_GROUPS)) break;
				cache_get_field_content(iIndex, "id", szResult, MainPipeline, 24);
				arrGroupJurisdictions[iGroup][arrGroupData[iGroup][g_iJCount]][g_iJurisdictionSQLId] = strval(szResult);
				cache_get_field_content(iIndex, "AreaName", arrGroupJurisdictions[iGroup][arrGroupData[iGroup][g_iJCount]][g_iAreaName], MainPipeline, 64);
				arrGroupData[iGroup][g_iJCount]++;
				iIndex++;
			}
		}
		case GROUP_QUERY_LOCKERS: while(iIndex < iRows) {

			cache_get_field_content(iIndex, "Group_ID", szResult, MainPipeline);
			new iGroup = strval(szResult)-1;

			cache_get_field_content(iIndex, "Locker_ID", szResult, MainPipeline);
			new iLocker = strval(szResult)-1;

			if (!(0 <= iGroup < MAX_GROUPS)) break;
			if (!(0 <= iLocker < MAX_GROUP_LOCKERS)) break;

			cache_get_field_content(iIndex, "Id", szResult, MainPipeline);
			arrGroupLockers[iGroup][iLocker][g_iLockerSQLId] = strval(szResult);

			cache_get_field_content(iIndex, "LockerX", szResult, MainPipeline);
			arrGroupLockers[iGroup][iLocker][g_fLockerPos][0] = floatstr(szResult);

			cache_get_field_content(iIndex, "LockerY", szResult, MainPipeline);
			arrGroupLockers[iGroup][iLocker][g_fLockerPos][1] = floatstr(szResult);

			cache_get_field_content(iIndex, "LockerZ", szResult, MainPipeline);
			arrGroupLockers[iGroup][iLocker][g_fLockerPos][2] = floatstr(szResult);

			cache_get_field_content(iIndex, "LockerVW", szResult, MainPipeline);
			arrGroupLockers[iGroup][iLocker][g_iLockerVW] = strval(szResult);

			cache_get_field_content(iIndex, "LockerShare", szResult, MainPipeline);
			arrGroupLockers[iGroup][iLocker][g_iLockerShare] = strval(szResult);

			if(arrGroupLockers[iGroup][iLocker][g_fLockerPos][0] != 0.0)
			{
				format(szResult, sizeof szResult, "%s Locker\n{1FBDFF}/locker{FFFF00} to use\n ID: %i", arrGroupData[iGroup][g_szGroupName], arrGroupLockers[iGroup][iLocker]);
				arrGroupLockers[iGroup][iLocker][g_tLocker3DLabel] = CreateDynamic3DTextLabel(szResult, arrGroupData[iGroup][g_hDutyColour] * 256 + 0xFF, arrGroupLockers[iGroup][iLocker][g_fLockerPos][0], arrGroupLockers[iGroup][iLocker][g_fLockerPos][1], arrGroupLockers[iGroup][iLocker][g_fLockerPos][2], 15.0, .testlos = 1, .worldid = arrGroupLockers[iGroup][iLocker][g_iLockerVW]);
			}
			iIndex++;

		}
		case GROUP_QUERY_LOAD: while(iIndex < iRows) {
			cache_get_field_content(iIndex, "Name", arrGroupData[iIndex][g_szGroupName], MainPipeline, GROUP_MAX_NAME_LEN);

			cache_get_field_content(iIndex, "MOTD", arrGroupData[iIndex][g_szGroupMOTD], MainPipeline, GROUP_MAX_MOTD_LEN);

			cache_get_field_content(iIndex, "Type", szResult, MainPipeline);
			arrGroupData[iIndex][g_iGroupType] = strval(szResult);

			cache_get_field_content(iIndex, "Allegiance", szResult, MainPipeline);
			arrGroupData[iIndex][g_iAllegiance] = strval(szResult);

			cache_get_field_content(iIndex, "Bug", szResult, MainPipeline);
			arrGroupData[iIndex][g_iBugAccess] = strval(szResult);

			cache_get_field_content(iIndex, "RadioColour", szResult, MainPipeline);
			arrGroupData[iIndex][g_hRadioColour] = strval(szResult);

			cache_get_field_content(iIndex, "Radio", szResult, MainPipeline);
			arrGroupData[iIndex][g_iRadioAccess] = strval(szResult);

			cache_get_field_content(iIndex, "DeptRadio", szResult, MainPipeline);
			arrGroupData[iIndex][g_iDeptRadioAccess] = strval(szResult);

			cache_get_field_content(iIndex, "IntRadio", szResult, MainPipeline);
			arrGroupData[iIndex][g_iIntRadioAccess] = strval(szResult);

			cache_get_field_content(iIndex, "GovAnnouncement", szResult, MainPipeline);
			arrGroupData[iIndex][g_iGovAccess] = strval(szResult);

			cache_get_field_content(iIndex, "FreeNameChange", szResult, MainPipeline);
			arrGroupData[iIndex][g_iFreeNameChange] = strval(szResult);

			cache_get_field_content(iIndex, "Budget", szResult, MainPipeline);
			arrGroupData[iIndex][g_iBudget] = strval(szResult);

			cache_get_field_content(iIndex, "BudgetPayment", szResult, MainPipeline);
			arrGroupData[iIndex][g_iBudgetPayment] = strval(szResult);

			cache_get_field_content(iIndex, "SpikeStrips", szResult, MainPipeline);
			arrGroupData[iIndex][g_iSpikeStrips] = strval(szResult);

			cache_get_field_content(iIndex, "Barricades", szResult, MainPipeline);
			arrGroupData[iIndex][g_iBarricades] = strval(szResult);

			cache_get_field_content(iIndex, "Cones", szResult, MainPipeline);
			arrGroupData[iIndex][g_iCones] = strval(szResult);

			cache_get_field_content(iIndex, "Flares", szResult, MainPipeline);
			arrGroupData[iIndex][g_iFlares] = strval(szResult);

			cache_get_field_content(iIndex, "Barrels", szResult, MainPipeline);
			arrGroupData[iIndex][g_iBarrels] = strval(szResult);

			cache_get_field_content(iIndex, "DutyColour", szResult, MainPipeline);
			arrGroupData[iIndex][g_hDutyColour] = strval(szResult);

			cache_get_field_content(iIndex, "Stock", szResult, MainPipeline);
			arrGroupData[iIndex][g_iLockerStock] = strval(szResult);

			cache_get_field_content(iIndex, "CrateX", szResult, MainPipeline);
			arrGroupData[iIndex][g_fCratePos][0] = floatstr(szResult);

			cache_get_field_content(iIndex, "CrateY", szResult, MainPipeline);
			arrGroupData[iIndex][g_fCratePos][1] = floatstr(szResult);

			cache_get_field_content(iIndex, "CrateZ", szResult, MainPipeline);
			arrGroupData[iIndex][g_fCratePos][2] = floatstr(szResult);

			cache_get_field_content(iIndex, "LockerCostType", szResult, MainPipeline);
			arrGroupData[iIndex][g_iLockerCostType] = strval(szResult);

			cache_get_field_content(iIndex, "CratesOrder", szResult, MainPipeline);
			arrGroupData[iIndex][g_iCratesOrder] = strval(szResult);

			cache_get_field_content(iIndex, "CrateIsland", szResult, MainPipeline);
			arrGroupData[iIndex][g_iCrateIsland] = strval(szResult);
			
			cache_get_field_content(iIndex, "GarageX", szResult, MainPipeline);
			arrGroupData[iIndex][g_fGaragePos][0] = floatstr(szResult);

			cache_get_field_content(iIndex, "GarageY", szResult, MainPipeline);
			arrGroupData[iIndex][g_fGaragePos][1] = floatstr(szResult);

			cache_get_field_content(iIndex, "GarageZ", szResult, MainPipeline);
			arrGroupData[iIndex][g_fGaragePos][2] = floatstr(szResult);
			
			cache_get_field_content(iIndex, "TackleAccess", szResult, MainPipeline);
			arrGroupData[iIndex][g_iTackleAccess] = strval(szResult);

			while(i < MAX_GROUP_RANKS) {
				format(szResult, sizeof szResult, "Rank%i", i);
				cache_get_field_content(iIndex, szResult, arrGroupRanks[iIndex][i], MainPipeline, GROUP_MAX_RANK_LEN);
				format(szResult, sizeof szResult, "Rank%iPay", i);
				cache_get_field_content(iIndex, szResult, szResult, MainPipeline);
				arrGroupData[iIndex][g_iPaycheck][i] = strval(szResult);
				i++;
			}
			i = 0;

			while(i < MAX_GROUP_DIVS) {
				format(szResult, sizeof szResult, "Div%i", i + 1);
				cache_get_field_content(iIndex, szResult, arrGroupDivisions[iIndex][i], MainPipeline, GROUP_MAX_DIV_LEN);
				i++;
			}
			i = 0;

			while(i < MAX_GROUP_WEAPONS) {
				format(szResult, sizeof szResult, "Gun%i", i + 1);
				cache_get_field_content(iIndex, szResult, szResult, MainPipeline);
				arrGroupData[iIndex][g_iLockerGuns][i] = strval(szResult);
				format(szResult, sizeof szResult, "Cost%i", i + 1);
				cache_get_field_content(iIndex, szResult, szResult, MainPipeline);
				arrGroupData[iIndex][g_iLockerCost][i] = strval(szResult);
				i++;
			}
			i = 0;

			if (arrGroupData[iIndex][g_szGroupName][0] && arrGroupData[iIndex][g_fCratePos][0] != 0.0)
			{
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
			format(string, sizeof(string), "Administrator %s has group-banned %s from %s (%d)", GetPlayerNameEx(iExtraID), GetPlayerNameEx(otherplayer), arrGroupData[PlayerInfo[otherplayer][pMember]][g_szGroupName], PlayerInfo[otherplayer][pMember]);
			Log("logs/group.log", string);
			PlayerInfo[otherplayer][pMember] = INVALID_GROUP_ID;
			PlayerInfo[otherplayer][pLeader] = INVALID_GROUP_ID;
			PlayerInfo[otherplayer][pRank] = INVALID_RANK;
			PlayerInfo[otherplayer][pDuty] = 0;
			PlayerInfo[otherplayer][pDivision] = INVALID_DIVISION;
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
			if(mysql_affected_rows(MainPipeline))
			{
				format(string, sizeof(string), "You have group-unbanned %s from group %s (%d).", GetPlayerNameEx(otherplayer), arrGroupData[group][g_szGroupName], group);
				SendClientMessageEx(iExtraID, COLOR_WHITE, string);
				format(string, sizeof(string), "You have been group-unbanned from %s, by %s.", arrGroupData[group][g_szGroupName], GetPlayerNameEx(iExtraID));
				SendClientMessageEx(otherplayer, COLOR_LIGHTBLUE, string);
				format(string, sizeof(string), "Administrator %s has group-unbanned %s from %s (%d)", GetPlayerNameEx(iExtraID), GetPlayerNameEx(otherplayer), arrGroupData[group][g_szGroupName], group);
				Log("logs/group.log", string);
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
				cache_get_field_content(0, "Member", szResult, MainPipeline, MAX_PLAYER_NAME);
				if(strval(szResult) == PlayerInfo[iExtraID][pMember]) {
					cache_get_field_content(0, "Rank", szResult, MainPipeline);
					if(PlayerInfo[iExtraID][pRank] > strval(szResult) || PlayerInfo[iExtraID][pRank] >= Group_GetMaxRank(PlayerInfo[iExtraID][pMember])) {
						cache_get_field_content(0, "ID", szResult, MainPipeline);
						format(szResult, sizeof szResult, "UPDATE `accounts` SET `Model` = "#NOOB_SKIN", `Member` = "#INVALID_GROUP_ID", `Rank` = "#INVALID_RANK", `Leader` = "#INVALID_GROUP_ID", `Division` = -1 WHERE `id` = %i", strval(szResult));
						mysql_function_query(MainPipeline, szResult, true, "Group_QueryFinish", "ii", GROUP_QUERY_UNINVITE, iExtraID);
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
			if(mysql_affected_rows(MainPipeline)) {

				i = PlayerInfo[iExtraID][pRank];
				format(szResult, sizeof szResult, "You have successfully removed %s from your group.", szName);
				SendClientMessage(iExtraID, COLOR_GREY, szResult);

				format(szResult, sizeof szResult, "%s %s (rank %i) has offline uninvited %s from %s (%i).", arrGroupRanks[iGroupID][i], GetPlayerNameEx(iExtraID), i + 1, szName, arrGroupData[iGroupID][g_szGroupName], iGroupID + 1);
				Log("logs/group.log", szResult);
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
		iFields,
		iRows,
		iIndex,
		szResult[128];

	cache_get_data(iRows, iFields, MainPipeline);

	while(iIndex < iRows)
	{
	    new iGroupID;
		arrGroupData[iGroup][g_iJCount] = iRows;
		if(arrGroupData[iGroup][g_iJCount] > MAX_GROUP_JURISDICTIONS) {
			arrGroupData[iGroup][g_iJCount] = MAX_GROUP_JURISDICTIONS;
		}
		cache_get_field_content(iIndex, "GroupID", szResult, MainPipeline, 24);
		iGroupID = strval(szResult);
		if(iGroupID == iGroup)
		{
			cache_get_field_content(iIndex, "id", szResult, MainPipeline, 64);
			arrGroupJurisdictions[iGroup][iIndex][g_iJurisdictionSQLId] = strval(szResult);
			cache_get_field_content(iIndex, "AreaName", arrGroupJurisdictions[iGroup][iIndex][g_iAreaName], MainPipeline, 64);
		}
		iIndex++;
	}
}

forward DynVeh_QueryFinish(iType, iExtraID);
public DynVeh_QueryFinish(iType, iExtraID) {

	new
		iFields,
		iRows,
		iIndex,
		i = 0,
		sqlid,
		szResult[128];

	cache_get_data(iRows, iFields, MainPipeline);
	switch(iType) {
		case GV_QUERY_LOAD:
		{
		    format(szResult, sizeof(szResult), "UPDATE `groupvehs` SET `SpawnedID` = %d", INVALID_VEHICLE_ID);
			mysql_function_query(MainPipeline, szResult, false, "OnQueryFinish", "i", SENDDATA_THREAD);
			while((iIndex < iRows) && (iIndex < MAX_DYNAMIC_VEHICLES)) {
			    cache_get_field_content(iIndex, "id", szResult, MainPipeline); sqlid = strval(szResult);
				if((sqlid >= MAX_DYNAMIC_VEHICLES)) {// Array bounds check. Use it.
					format(szResult, sizeof(szResult), "DELETE FROM `groupvehs` WHERE `id` = %d", sqlid);
					mysql_function_query(MainPipeline, szResult, false, "OnQueryFinish", "i", SENDDATA_THREAD);
					return printf("SQL ID %d exceeds Max Dynamic Vehicles", sqlid);
				}
				cache_get_field_content(iIndex, "gID", szResult, MainPipeline); DynVehicleInfo[sqlid][gv_igID] = strval(szResult);
				cache_get_field_content(iIndex, "gDivID", szResult, MainPipeline); DynVehicleInfo[sqlid][gv_igDivID] = strval(szResult);
				cache_get_field_content(iIndex, "fID", szResult, MainPipeline); DynVehicleInfo[sqlid][gv_ifID] = strval(szResult);
				cache_get_field_content(iIndex, "rID", szResult, MainPipeline); DynVehicleInfo[sqlid][gv_irID] = strval(szResult);
				cache_get_field_content(iIndex, "vModel", szResult, MainPipeline); DynVehicleInfo[sqlid][gv_iModel] = strval(szResult);
                switch(DynVehicleInfo[sqlid][gv_iModel]) {
					case 538, 537, 449, 590, 569, 570: {
					    DynVehicleInfo[sqlid][gv_iModel] = 0;
					}
				}
				cache_get_field_content(iIndex, "vPlate", DynVehicleInfo[sqlid][gv_iPlate], MainPipeline, 32);
				cache_get_field_content(iIndex, "vMaxHealth", szResult, MainPipeline); DynVehicleInfo[sqlid][gv_fMaxHealth] = floatstr(szResult);
				cache_get_field_content(iIndex, "vType", szResult, MainPipeline); DynVehicleInfo[sqlid][gv_iType] = strval(szResult);
				cache_get_field_content(iIndex, "vLoadMax", szResult, MainPipeline); DynVehicleInfo[sqlid][gv_iLoadMax] = strval(szResult);
				if(DynVehicleInfo[sqlid][gv_iLoadMax] > 6) {
                    DynVehicleInfo[sqlid][gv_iLoadMax] = 6;
				}
				cache_get_field_content(iIndex, "vCol1", szResult, MainPipeline); DynVehicleInfo[sqlid][gv_iCol1] = strval(szResult);
				cache_get_field_content(iIndex, "vCol2", szResult, MainPipeline); DynVehicleInfo[sqlid][gv_iCol2] = strval(szResult);
				cache_get_field_content(iIndex, "vX", szResult, MainPipeline); DynVehicleInfo[sqlid][gv_fX] = floatstr(szResult);
				cache_get_field_content(iIndex, "vY", szResult, MainPipeline); DynVehicleInfo[sqlid][gv_fY] = floatstr(szResult);
				cache_get_field_content(iIndex, "vZ", szResult, MainPipeline); DynVehicleInfo[sqlid][gv_fZ] = floatstr(szResult);
				cache_get_field_content(iIndex, "vVW", szResult, MainPipeline); DynVehicleInfo[sqlid][gv_iVW] = strval(szResult);
				cache_get_field_content(iIndex, "vInt", szResult, MainPipeline); DynVehicleInfo[sqlid][gv_iInt] = strval(szResult);
				cache_get_field_content(iIndex, "vDisabled", szResult, MainPipeline); DynVehicleInfo[sqlid][gv_iDisabled] = strval(szResult);
				cache_get_field_content(iIndex, "vRotZ", szResult, MainPipeline); DynVehicleInfo[sqlid][gv_fRotZ] = floatstr(szResult);
				cache_get_field_content(iIndex, "vUpkeep", szResult, MainPipeline); DynVehicleInfo[sqlid][gv_iUpkeep] = strval(szResult);
				i = 1;
				while(i <= MAX_DV_OBJECTS) {
					format(szResult, sizeof szResult, "vAttachedObjectModel%i", i);
					cache_get_field_content(iIndex, szResult, szResult, MainPipeline); DynVehicleInfo[sqlid][gv_iAttachedObjectModel][i-1] = strval(szResult);
					format(szResult, sizeof szResult, "vObjectX%i", i);
					cache_get_field_content(iIndex, szResult, szResult, MainPipeline); DynVehicleInfo[sqlid][gv_fObjectX][i-1] = floatstr(szResult);
					format(szResult, sizeof szResult, "vObjectY%i", i);
					cache_get_field_content(iIndex, szResult, szResult, MainPipeline); DynVehicleInfo[sqlid][gv_fObjectY][i-1] = floatstr(szResult);
					format(szResult, sizeof szResult, "vObjectZ%i", i);
					cache_get_field_content(iIndex, szResult, szResult, MainPipeline); DynVehicleInfo[sqlid][gv_fObjectZ][i-1] = floatstr(szResult);
					format(szResult, sizeof szResult, "vObjectRX%i", i);
					cache_get_field_content(iIndex, szResult, szResult, MainPipeline); DynVehicleInfo[sqlid][gv_fObjectRX][i-1] = floatstr(szResult);
					format(szResult, sizeof szResult, "vObjectRY%i", i);
					cache_get_field_content(iIndex, szResult, szResult, MainPipeline); DynVehicleInfo[sqlid][gv_fObjectRY][i-1] = floatstr(szResult);
					format(szResult, sizeof szResult, "vObjectRZ%i", i);
					cache_get_field_content(iIndex, szResult, szResult, MainPipeline); DynVehicleInfo[sqlid][gv_fObjectRZ][i-1] = floatstr(szResult);
					i++;
				}
				i = 0;
				while(i < MAX_DV_MODS) {
					format(szResult, sizeof szResult, "vMod%i", i);
					cache_get_field_content(iIndex, szResult, szResult, MainPipeline); DynVehicleInfo[sqlid][gv_iMod][i++] = strval(szResult);
				}
				
				if(400 < DynVehicleInfo[sqlid][gv_iModel] < 612) {
					if(!IsWeaponizedVehicle(DynVehicleInfo[sqlid][gv_iModel])) {
						DynVeh_Spawn(iIndex);
						//printf("[DynVeh] Loaded Dynamic Vehicle %i.", iIndex);
						for(i = 0; i != MAX_DV_OBJECTS; i++)
						{
							if(DynVehicleInfo[sqlid][gv_iAttachedObjectModel][i] == 0 || DynVehicleInfo[sqlid][gv_iAttachedObjectModel][i] == INVALID_OBJECT_ID) {
								DynVehicleInfo[sqlid][gv_iAttachedObjectID][i] = INVALID_OBJECT_ID;
								DynVehicleInfo[sqlid][gv_iAttachedObjectModel][i] = INVALID_OBJECT_ID;
							}
						}
					} else {
						DynVehicleInfo[sqlid][gv_iSpawnedID] = INVALID_VEHICLE_ID;
					}	
				}
				iIndex++;
			}
		}
	}
	return 1;
}

forward LoadBusinessesSaless();
public LoadBusinessesSaless() {

	new
		iFields,
		iRows,
		iIndex,
		szResult[128];

	cache_get_data(iRows, iFields, MainPipeline);

	while((iIndex < iRows)) {
		cache_get_field_content(iIndex, "bID", szResult, MainPipeline); BusinessSales[iIndex][bID] = strval(szResult);
		cache_get_field_content(iIndex, "BusinessID", szResult, MainPipeline); BusinessSales[iIndex][bBusinessID] = strval(szResult);
		cache_get_field_content(iIndex, "Text", BusinessSales[iIndex][bText], MainPipeline, 128);
		cache_get_field_content(iIndex, "Price", szResult, MainPipeline); BusinessSales[iIndex][bPrice] = strval(szResult);
		cache_get_field_content(iIndex, "Available", szResult, MainPipeline); BusinessSales[iIndex][bAvailable] = strval(szResult);
		cache_get_field_content(iIndex, "Purchased", szResult, MainPipeline); BusinessSales[iIndex][bPurchased] = strval(szResult);
		cache_get_field_content(iIndex, "Type", szResult, MainPipeline); BusinessSales[iIndex][bType] = strval(szResult);
		iIndex++;
	}
	return 1;
}

forward AuctionLoadQuery();
public AuctionLoadQuery() {

	new
		iFields,
		iRows,
		iIndex,
		szResult[128];

	cache_get_data(iRows, iFields, MainPipeline);

	while((iIndex < iRows)) {
		cache_get_field_content(iIndex, "BiddingFor", Auctions[iIndex][BiddingFor], MainPipeline, 64);
		cache_get_field_content(iIndex, "InProgress", szResult, MainPipeline); Auctions[iIndex][InProgress] = strval(szResult);
		cache_get_field_content(iIndex, "Bid", szResult, MainPipeline); Auctions[iIndex][Bid] = strval(szResult);
		cache_get_field_content(iIndex, "Bidder", szResult, MainPipeline); Auctions[iIndex][Bidder] = strval(szResult);
		cache_get_field_content(iIndex, "Expires", szResult, MainPipeline); Auctions[iIndex][Expires] = strval(szResult);
		cache_get_field_content(iIndex, "Wining", Auctions[iIndex][Wining], MainPipeline, MAX_PLAYER_NAME);
		cache_get_field_content(iIndex, "Increment", szResult, MainPipeline); Auctions[iIndex][Increment] = strval(szResult);
		if(Auctions[iIndex][InProgress] == 1 && Auctions[iIndex][Expires] != 0)
		{
		    Auctions[iIndex][Timer] = SetTimerEx("EndAuction", 60000, true, "i", iIndex);
		    printf("[auction - %i - started] %s, %d, %d, %d, %d, %s, %d",iIndex, Auctions[iIndex][BiddingFor],Auctions[iIndex][InProgress],Auctions[iIndex][Bid],Auctions[iIndex][Bidder],Auctions[iIndex][Expires],Auctions[iIndex][Wining],Auctions[iIndex][Increment]);
		}
		iIndex++;
	}
	return 1;
}

forward PlantsLoadQuery();
public PlantsLoadQuery() {

	new
		iFields,
		iRows,
		iIndex,
		szResult[128];

	cache_get_data(iRows, iFields, MainPipeline);

	while((iIndex < iRows)) {
		cache_get_field_content(iIndex, "Owner", szResult, MainPipeline); Plants[iIndex][pOwner] = strval(szResult);
		cache_get_field_content(iIndex, "Object", szResult, MainPipeline); Plants[iIndex][pObject] = strval(szResult);
		cache_get_field_content(iIndex, "PlantType", szResult, MainPipeline); Plants[iIndex][pPlantType] = strval(szResult);
		cache_get_field_content(iIndex, "PositionX", szResult, MainPipeline); Plants[iIndex][pPos][0] = floatstr(szResult);
		cache_get_field_content(iIndex, "PositionY", szResult, MainPipeline); Plants[iIndex][pPos][1] = floatstr(szResult);
		cache_get_field_content(iIndex, "PositionZ", szResult, MainPipeline); Plants[iIndex][pPos][2] = floatstr(szResult);
		cache_get_field_content(iIndex, "Virtual", szResult, MainPipeline); Plants[iIndex][pVirtual] = strval(szResult);
		cache_get_field_content(iIndex, "Interior", szResult, MainPipeline); Plants[iIndex][pInterior] = strval(szResult);
		cache_get_field_content(iIndex, "Growth", szResult, MainPipeline); Plants[iIndex][pGrowth] = strval(szResult);
		cache_get_field_content(iIndex, "Expires", szResult, MainPipeline); Plants[iIndex][pExpires] = strval(szResult);
		cache_get_field_content(iIndex, "DrugsSkill", szResult, MainPipeline); Plants[iIndex][pDrugsSkill] = strval(szResult);

		if(Plants[iIndex][pOwner] != 0) {
		    Plants[iIndex][pObjectSpawned] = CreateDynamicObject(Plants[iIndex][pObject], Plants[iIndex][pPos][0], Plants[iIndex][pPos][1], Plants[iIndex][pPos][2], 0.0, 0.0, 0.0, Plants[iIndex][pVirtual], Plants[iIndex][pInterior]);
		}
		iIndex++;
	}
	if(iIndex > 0) printf("[LoadPlants] Successfully loaded %d plants", iIndex);
	else printf("[LoadPlants] Error: Failed to load any plants!");
	return 1;
}

forward BusinessesLoadQueryFinish();
public BusinessesLoadQueryFinish()
{

	new i, rows, fields, tmp[128];
	cache_get_data(rows, fields, MainPipeline);
	while(i < rows)
	{
		cache_get_field_content(i, "Name", Businesses[i][bName], MainPipeline, MAX_BUSINESS_NAME);
		cache_get_field_content(i, "OwnerID", tmp, MainPipeline); Businesses[i][bOwner] = strval(tmp);
		cache_get_field_content(i, "Username", Businesses[i][bOwnerName], MainPipeline, MAX_PLAYER_NAME);
		cache_get_field_content(i, "Type", tmp, MainPipeline); Businesses[i][bType] = strval(tmp);
		cache_get_field_content(i, "Value", tmp, MainPipeline); Businesses[i][bValue] = strval(tmp);
		cache_get_field_content(i, "Status", tmp, MainPipeline); Businesses[i][bStatus] = strval(tmp);
		cache_get_field_content(i, "Level", tmp, MainPipeline); Businesses[i][bLevel] = strval(tmp);
		cache_get_field_content(i, "LevelProgress", tmp, MainPipeline); Businesses[i][bLevelProgress] = strval(tmp);
		cache_get_field_content(i, "SafeBalance", tmp, MainPipeline); Businesses[i][bSafeBalance] = strval(tmp);
		cache_get_field_content(i, "Inventory", tmp, MainPipeline); Businesses[i][bInventory] = strval(tmp);
		cache_get_field_content(i, "InventoryCapacity", tmp, MainPipeline); Businesses[i][bInventoryCapacity] = strval(tmp);
		cache_get_field_content(i, "AutoSale", tmp, MainPipeline); Businesses[i][bAutoSale] = strval(tmp);
		cache_get_field_content(i, "TotalSales", tmp, MainPipeline); Businesses[i][bTotalSales] = strval(tmp);
		cache_get_field_content(i, "ExteriorX", tmp, MainPipeline); Businesses[i][bExtPos][0] = floatstr(tmp);
		cache_get_field_content(i, "ExteriorY", tmp, MainPipeline); Businesses[i][bExtPos][1] = floatstr(tmp);
		cache_get_field_content(i, "ExteriorZ", tmp, MainPipeline); Businesses[i][bExtPos][2] = floatstr(tmp);
		cache_get_field_content(i, "ExteriorA", tmp, MainPipeline); Businesses[i][bExtPos][3] = floatstr(tmp);
		cache_get_field_content(i, "InteriorX", tmp, MainPipeline); Businesses[i][bIntPos][0] = floatstr(tmp);
		cache_get_field_content(i, "InteriorY", tmp, MainPipeline); Businesses[i][bIntPos][1] = floatstr(tmp);
		cache_get_field_content(i, "InteriorZ", tmp, MainPipeline); Businesses[i][bIntPos][2] = floatstr(tmp);
		cache_get_field_content(i, "InteriorA", tmp, MainPipeline); Businesses[i][bIntPos][3] = floatstr(tmp);
		cache_get_field_content(i, "Interior", tmp, MainPipeline); Businesses[i][bInt] = strval(tmp);
		cache_get_field_content(i, "SupplyPointX", tmp, MainPipeline); Businesses[i][bSupplyPos][0] = floatstr(tmp);
		cache_get_field_content(i, "SupplyPointY", tmp, MainPipeline); Businesses[i][bSupplyPos][1] = floatstr(tmp);
		cache_get_field_content(i, "SupplyPointZ", tmp, MainPipeline); Businesses[i][bSupplyPos][2] = floatstr(tmp);
		cache_get_field_content(i, "GasPrice", tmp, MainPipeline); Businesses[i][bGasPrice] = floatstr(tmp);
		cache_get_field_content(i, "OrderBy", Businesses[i][bOrderBy], MainPipeline, MAX_PLAYER_NAME);
		cache_get_field_content(i, "OrderState", tmp, MainPipeline); Businesses[i][bOrderState] = strval(tmp);
		cache_get_field_content(i, "OrderAmount", tmp, MainPipeline); Businesses[i][bOrderAmount] = strval(tmp);
		cache_get_field_content(i, "OrderDate", Businesses[i][bOrderDate], MainPipeline, 30);
		cache_get_field_content(i, "CustomExterior", tmp, MainPipeline); Businesses[i][bCustomExterior] = strval(tmp);
		cache_get_field_content(i, "CustomInterior", tmp, MainPipeline); Businesses[i][bCustomInterior] = strval(tmp);
		cache_get_field_content(i, "Grade", tmp, MainPipeline); Businesses[i][bGrade] = strval(tmp);
		cache_get_field_content(i, "CustomVW", tmp, MainPipeline); Businesses[i][bVW] = strval(tmp);
		cache_get_field_content(i, "Pay", tmp, MainPipeline); Businesses[i][bAutoPay] = strval(tmp);
		cache_get_field_content(i, "MinInviteRank", tmp, MainPipeline); Businesses[i][bMinInviteRank] = strval(tmp);
		cache_get_field_content(i, "MinSupplyRank", tmp, MainPipeline); Businesses[i][bMinSupplyRank] = strval(tmp);
		cache_get_field_content(i, "MinGiveRankRank", tmp, MainPipeline); Businesses[i][bMinGiveRankRank] = strval(tmp);
		cache_get_field_content(i, "MinSafeRank", tmp, MainPipeline); Businesses[i][bMinSafeRank] = strval(tmp);
		cache_get_field_content(i, "Months", tmp, MainPipeline); Businesses[i][bMonths] = strval(tmp);
		cache_get_field_content(i, "GymEntryFee", tmp, MainPipeline); Businesses[i][bGymEntryFee] = strval(tmp);
		cache_get_field_content(i, "GymType", tmp, MainPipeline); Businesses[i][bGymType] = strval(tmp);

		if (Businesses[i][bOrderState] == 2) {
		    Businesses[i][bOrderState] = 1;
		}

		if(Businesses[i][bExtPos][0] != 0.0) RefreshBusinessPickup(i); // If the business is at blueberry, do not spawn it

		for (new j; j <= 5; j++)
		{
		    new col[9];
			format(col, sizeof(col), "Rank%dPay", j);
			cache_get_field_content(i, col, tmp, MainPipeline);
			Businesses[i][bRankPay][j] = strval(tmp);
		}

		if (Businesses[i][bType] == BUSINESS_TYPE_GASSTATION)
		{
			for (new j, column[17]; j < MAX_BUSINESS_GAS_PUMPS; j++)
			{
			    format(column, sizeof(column), "GasPump%dPosX", j + 1);
				cache_get_field_content(i, column, tmp, MainPipeline); Businesses[i][GasPumpPosX][j] = floatstr(tmp);
			    format(column, sizeof(column), "GasPump%dPosY", j + 1);
				cache_get_field_content(i, column, tmp, MainPipeline); Businesses[i][GasPumpPosY][j] = floatstr(tmp);
			    format(column, sizeof(column), "GasPump%dPosZ", j + 1);
				cache_get_field_content(i, column, tmp, MainPipeline); Businesses[i][GasPumpPosZ][j] = floatstr(tmp);
			    format(column, sizeof(column), "GasPump%dAngle", j + 1);
				cache_get_field_content(i, column, tmp, MainPipeline); Businesses[i][GasPumpAngle][j] = floatstr(tmp);
			    format(column, sizeof(column), "GasPump%dCapacity", j + 1);
				cache_get_field_content(i, column, tmp, MainPipeline); Businesses[i][GasPumpCapacity][j] = floatstr(tmp);
			    format(column, sizeof(column), "GasPump%dGas", j + 1);
				cache_get_field_content(i, column, tmp, MainPipeline); Businesses[i][GasPumpGallons][j] = floatstr(tmp);
				
				if(Businesses[i][GasPumpPosX][j] != 0.0) CreateDynamicGasPump(_, i, j);

				for (new z; z <= sizeof(StoreItems); z++)
				{
			    	new col[12];
					format(col, sizeof(col), "Item%dPrice", z + 1);
					cache_get_field_content(i, col, tmp, MainPipeline);
					Businesses[i][bItemPrices][z] = strval(tmp);
				}
			}
		}
		else if (Businesses[i][bType] == BUSINESS_TYPE_NEWCARDEALERSHIP || Businesses[i][bType] == BUSINESS_TYPE_OLDCARDEALERSHIP)
		{
			for (new j, column[16], label[50]; j < MAX_BUSINESS_DEALERSHIP_VEHICLES; j++)
			{

			    format(column, sizeof(column), "Car%dModelId", j);
				cache_get_field_content(i, column, tmp, MainPipeline); Businesses[i][bModel][j] = strval(tmp);
			    format(column, sizeof(column), "Car%dPosX", j);
				cache_get_field_content(i, column, tmp, MainPipeline); Businesses[i][bParkPosX][j] = floatstr(tmp);
			    format(column, sizeof(column), "Car%dPosY", j);
				cache_get_field_content(i, column, tmp, MainPipeline); Businesses[i][bParkPosY][j] = floatstr(tmp);
			    format(column, sizeof(column), "Car%dPosZ", j);
				cache_get_field_content(i, column, tmp, MainPipeline); Businesses[i][bParkPosZ][j] = floatstr(tmp);
			    format(column, sizeof(column), "Car%dPosAngle", j);
				cache_get_field_content(i, column, tmp, MainPipeline); Businesses[i][bParkAngle][j] = floatstr(tmp);
			    format(column, sizeof(column), "Car%dPrice", j);
				cache_get_field_content(i, column, tmp, MainPipeline); Businesses[i][bPrice][j] = strval(tmp);

				cache_get_field_content(i, "PurchaseX", tmp, MainPipeline); Businesses[i][bPurchaseX][j] = strval(tmp);
				cache_get_field_content(i, "PurchaseY", tmp, MainPipeline); Businesses[i][bPurchaseY][j] = strval(tmp);
				cache_get_field_content(i, "PurchaseZ", tmp, MainPipeline); Businesses[i][bPurchaseZ][j] = strval(tmp);
				cache_get_field_content(i, "PurchaseAngle", tmp, MainPipeline); Businesses[i][bPurchaseAngle][j] = strval(tmp);

				if(400 < Businesses[i][bModel][j] < 612 || Businesses[i][bParkPosX][j] != 0.0) 
				{
			 		Businesses[i][bVehID][j] = CreateVehicle(Businesses[i][bModel][j], Businesses[i][bParkPosX][j], Businesses[i][bParkPosY][j], Businesses[i][bParkPosZ][j], Businesses[i][bParkAngle][j], Businesses[i][bColor1][j], Businesses[i][bColor2][j], 10);
     				format(label, sizeof(label), "%s For Sale | Price: $%s", GetVehicleName(Businesses[i][bVehID][j]), number_format(Businesses[i][bPrice][j]));
					Businesses[i][bVehicleLabel][j] = CreateDynamic3DTextLabel(label,COLOR_LIGHTBLUE,Businesses[i][bParkPosX][j], Businesses[i][bParkPosY][j], Businesses[i][bParkPosZ][j],8.0,INVALID_PLAYER_ID, Businesses[i][bVehID][j]);
				}
			}
		}
		else
		{
			for (new j; j <= sizeof(StoreItems); j++)
			{
			    new col[12];
				format(col, sizeof(col), "Item%dPrice", j + 1);
				cache_get_field_content(i, col, tmp, MainPipeline);
				Businesses[i][bItemPrices][j] = strval(tmp);
			}
		}

		Businesses[i][bGymBoxingArena1][0] = INVALID_PLAYER_ID;
		Businesses[i][bGymBoxingArena1][1] = INVALID_PLAYER_ID;
		Businesses[i][bGymBoxingArena2][0] = INVALID_PLAYER_ID;
		Businesses[i][bGymBoxingArena2][1] = INVALID_PLAYER_ID;

		for (new it = 0; it < 10; ++it)
		{
			Businesses[i][bGymBikePlayers][it] = INVALID_PLAYER_ID;
			Businesses[i][bGymBikeVehicles][it] = INVALID_VEHICLE_ID;
		}

		i++;
	}
	if(i > 0) printf("[LoadBusinesses] %d businesses rehashed/loaded.", i);
	else printf("[LoadBusinesses] Failed to load any businesses.");
}

forward ReturnMoney(index);
public ReturnMoney(index)
{
	if(IsPlayerConnected(index))
	{
	    new
    		AuctionItem = GetPVarInt(index, "AuctionItem");

		new money[15], money2, string[128];
		new rows, fields;
		cache_get_data(rows, fields, MainPipeline);
		if(rows)
		{
   			cache_get_field_content(0, "Money", money, MainPipeline); money2 = strval(money);

   			format(string, sizeof(string), "UPDATE `accounts` SET `Money` = %d WHERE `id` = '%d'", money2+Auctions[AuctionItem][Bid], Auctions[AuctionItem][Bidder]);
			mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);

			format(string, sizeof(string), "Amount of $%d (Before: %i | After: %i) has been returned to (id: %i) for being outbid", Auctions[AuctionItem][Bid], money2,Auctions[AuctionItem][Bid]+money2,  Auctions[AuctionItem][Bidder]);
			Log("logs/auction.log", string);

            GivePlayerCash(index, -GetPVarInt(index, "BidPlaced"));
			Auctions[AuctionItem][Bid] = GetPVarInt(index, "BidPlaced");
			Auctions[AuctionItem][Bidder] = GetPlayerSQLId(index);
			strcpy(Auctions[AuctionItem][Wining], GetPlayerNameExt(index), MAX_PLAYER_NAME);

			format(string, sizeof(string), "You have placed a bid of %i on %s.", GetPVarInt(index, "BidPlaced"), Auctions[AuctionItem][BiddingFor]);
			SendClientMessageEx(index, COLOR_WHITE, string);

			format(string, sizeof(string), "%s (IP:%s) has placed a bid of %i on %s(%i)", GetPlayerNameEx(index), GetPlayerIpEx(index), GetPVarInt(index, "BidPlaced"), Auctions[AuctionItem][BiddingFor], AuctionItem);
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
	PlayerVehicleInfo[playerid][playervehicleid][pvSlotId] = mysql_insert_id(MainPipeline);
	printf("VNumber: %d", PlayerVehicleInfo[playerid][playervehicleid][pvSlotId]);

	new string[128];
    format(string, sizeof(string), "UPDATE `vehicles` SET `pvModelId` = %d WHERE `id` = %d", PlayerVehicleInfo[playerid][playervehicleid][pvModelId], PlayerVehicleInfo[playerid][playervehicleid][pvSlotId]);
	mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	
	g_mysql_SaveVehicle(playerid, playervehicleid);
}

forward CheckAccounts(playerid);
public CheckAccounts(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		new szString[128];
		new rows, fields;
		cache_get_data(rows, fields, MainPipeline);
		if(rows)
		{
		    format(szString, sizeof(szString), "{AA3333}AdmWarning{FFFF00}: Moderator %s has logged into the server with s0beit installed.", GetPlayerNameEx(playerid));
   			ABroadCast(COLOR_YELLOW, szString, 2);

    		format(szString, sizeof(szString), "Admin %s (IP: %s) has logged into the server with s0beit installed.", GetPlayerNameEx(playerid), GetPlayerIpEx(playerid));
     		Log("logs/sobeit.log", szString);
       		sobeitCheckvar[playerid] = 1;
     		sobeitCheckIsDone[playerid] = 1;
     		IsPlayerFrozen[playerid] = 0;
		}
		else
		{
		    format(szString, sizeof(szString), "INSERT INTO `sobeitkicks` (sqlID, Kicks) VALUES (%d, 1) ON DUPLICATE KEY UPDATE Kicks = Kicks + 1", GetPlayerSQLId(playerid));
			mysql_function_query(MainPipeline, szString, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);

		    SendClientMessageEx(playerid, COLOR_RED, "The hacking tool 's0beit' is not allowed on this server, please uninstall it.");
   			format(szString, sizeof(szString), "%s (IP: %s) has logged into the server with s0beit installed.", GetPlayerNameEx(playerid), GetPlayerIpEx(playerid));
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
    new newrows, newfields, newresult[16], currentIP[16], szString[128];
	GetPlayerIp(playerid, currentIP, sizeof(currentIP));
	cache_get_data(newrows, newfields, MainPipeline);

	if(newrows > 0)
	{
 		cache_get_field_content(0, "IP", newresult, MainPipeline);

   		if(!strcmp(newresult, currentIP, true))
	    {
	        format(szString, sizeof(szString), "Nobody");
			strmid(PlayerInfo[playerid][pReferredBy], szString, 0, strlen(szString), MAX_PLAYER_NAME);
            ShowPlayerDialog(playerid, REGISTERREF, DIALOG_STYLE_INPUT, "{FF0000}Error", "This person has the same IP as you.\nPlease choose another player that is not on your network.\n\nIf you haven't been referred, press 'Skip'.\n\nExample: FirstName_LastName (20 Characters Max)", "Enter", "Skip");
    	}
    	else {
    	    format(szString, sizeof(szString), "[Referral] (New Account: %s (IP:%s)) has been referred by (Referred Account: %s (IP:%s))", GetPlayerNameEx(playerid), currentIP, PlayerInfo[playerid][pReferredBy], newresult);
    	    Log("logs/referral.log", szString);
            mysql_free_result(MainPipeline);
			RegistrationStep[playerid] = 3;
			SetPlayerVirtualWorld(playerid, 0);
			ClearChatbox(playerid);
			ShowTutGUIBox(playerid);
			ShowTutGUIFrame(playerid, 1);
			TutStep[playerid] = 1;

			Streamer_UpdateEx(playerid, 1607.0160,-1510.8218,207.4438);
			SetPlayerPos(playerid, 1607.0160,-1510.8218,-10.0);
			SetPlayerCameraPos(playerid, 1850.1813,-1765.7552,81.9271);
			SetPlayerCameraLookAt(playerid, 1607.0160,-1510.8218,207.4438);
		}
	}
	return 1;
}

forward OnQueryCreateToy(playerid, toyslot);
public OnQueryCreateToy(playerid, toyslot)
{
	PlayerToyInfo[playerid][toyslot][ptID] = mysql_insert_id(MainPipeline);
	printf("Toy ID: %d", PlayerToyInfo[playerid][toyslot][ptID]);
	
	new szQuery[128];
	format(szQuery, sizeof(szQuery), "UPDATE `toys` SET `modelid` = '%d' WHERE `id` = '%d'", PlayerToyInfo[playerid][toyslot][ptID], PlayerToyInfo[playerid][toyslot][ptModelID]);
	mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	
	g_mysql_SaveToys(playerid, toyslot);
}

forward OnStaffAccountCheck(playerid);
public OnStaffAccountCheck(playerid)
{
	new string[156], rows, fields;
	cache_get_data(rows, fields, MainPipeline);
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
	format(string, sizeof(string), "SELECT * FROM `rflteams` WHERE `id`=%d", teamid);
	mysql_function_query(MainPipeline, string, true, "OnLoadRFLTeam", "i", mapiconid);
}

stock LoadRelayForLifeTeams()
{
	printf("[LoadRelayForLifeTeams] Loading data from database...");
	mysql_function_query(MainPipeline, "SELECT * FROM `rflteams`", true, "OnLoadRFLTeams", "");
}

forward OnLoadRFLTeams();
public OnLoadRFLTeams()
{
	new i, rows, fields, tmp[128];
	cache_get_data(rows, fields, MainPipeline);

	while(i < rows)
	{
		cache_get_field_content(i, "id", tmp, MainPipeline);  RFLInfo[i][RFLsqlid] = strval(tmp);
		cache_get_field_content(i, "name", RFLInfo[i][RFLname], MainPipeline);
		cache_get_field_content(i, "leader", RFLInfo[i][RFLleader], MainPipeline);
		cache_get_field_content(i, "used", tmp, MainPipeline); RFLInfo[i][RFLused] = strval(tmp);
		cache_get_field_content(i, "members", tmp, MainPipeline); RFLInfo[i][RFLmembers] = strval(tmp);
		cache_get_field_content(i, "laps", tmp, MainPipeline); RFLInfo[i][RFLlaps] = strval(tmp);
		i++;
	}
	if(i > 0) printf("[LoadRelayForLifeTeams] %d teams loaded.", i);
	else printf("[LoadRelayForLifeTeams] Failed to load any teams.");
	return 1;
}

forward OnLoadRFLTeam(index);
public OnLoadRFLTeam(index)
{
	new rows, fields, tmp[128];
	cache_get_data(rows, fields, MainPipeline);

	for(new row; row < rows; row++)
	{
		cache_get_field_content(row, "id", tmp, MainPipeline);  RFLInfo[index][RFLsqlid] = strval(tmp);
		cache_get_field_content(row, "name", RFLInfo[index][RFLname], MainPipeline);
		cache_get_field_content(row, "leader", RFLInfo[index][RFLleader], MainPipeline);
		cache_get_field_content(row, "used", tmp, MainPipeline); RFLInfo[index][RFLused] = strval(tmp);
		cache_get_field_content(row, "members", tmp, MainPipeline); RFLInfo[index][RFLmembers] = strval(tmp);
		cache_get_field_content(row, "laps", tmp, MainPipeline); RFLInfo[index][RFLlaps] = strval(tmp);
	}
}

stock SaveRelayForLifeTeam(teamid)
{
	new string[248];
	format(string, sizeof(string), "UPDATE `rflteams` SET `name`='%s', `leader`='%s', `used`=%d, `members`=%d, `laps`=%d WHERE id=%d",
		RFLInfo[teamid][RFLname],
		RFLInfo[teamid][RFLleader],
		RFLInfo[teamid][RFLused],
		RFLInfo[teamid][RFLmembers],
		RFLInfo[teamid][RFLlaps],
		RFLInfo[teamid][RFLsqlid]
	);
	mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);
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
	new i, rows, fields, string[1500], tmp[7], name[25], leader[25], laps;
	cache_get_data(rows, fields, MainPipeline);
	switch(id) {
		case 1: {
			while(i < rows)
			{
				cache_get_field_content(i, "name", name, MainPipeline);
				cache_get_field_content(i, "leader", leader, MainPipeline);
				cache_get_field_content(i, "laps", tmp, MainPipeline); laps = strval(tmp);
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
				ShowPlayerDialog(index, DIALOG_RFL_TEAMS, DIALOG_STYLE_LIST, "Relay For Life Teams", string, "Next", "Close");
				return 1;
			}
			else
			{
				DeletePVar(index, "rflTemp");
				ShowPlayerDialog(index, DIALOG_RFL_TEAMS, DIALOG_STYLE_LIST, "Relay For Life Teams", string, "Close", "");
				return 1;
			}
		}
		case 2: {
			while(i < rows)
			{
				cache_get_field_content(i, "Username", name, MainPipeline);
				cache_get_field_content(i, "RacePlayerLaps", tmp, MainPipeline); laps = strval(tmp);
				format(string, sizeof(string), "%s\n%s | Laps: %d",string, name, laps);
				i++;
			}
			if(i > 0) {
				ShowPlayerDialog(index, DIALOG_RFL_PLAYERS, DIALOG_STYLE_LIST, "Relay For Life Player Top 25", string, "Close", "");
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
		if(mysql_affected_rows(MainPipeline))
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
			//foreach(new i: Player) {
			for(new i = 0; i < MAX_PLAYERS; ++i)
			{
				if(IsPlayerConnected(i))
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

stock SavePoint(pid)
{
	new szQuery[2048];
	
	format(szQuery, sizeof(szQuery), "UPDATE `points` SET \
		`posx` = '%f', \
		`posy` = '%f', \
 		`posz` = '%f', \
		`vw` = '%d', \
		`type` = '%d', \
		`vulnerable` = '%d', \
		`matpoint` = '%d', \
		`owner` = '%s', \
		`cappername` = '%s', \
		`name` = '%s' WHERE `id` = %d",
		Points[pid][Pointx],
		Points[pid][Pointy],
		Points[pid][Pointz],
		Points[pid][pointVW],
		Points[pid][Type],
		Points[pid][Vulnerable],
		Points[pid][MatPoint],
		g_mysql_ReturnEscaped(Points[pid][Owner], MainPipeline),
		g_mysql_ReturnEscaped(Points[pid][CapperName], MainPipeline),
		g_mysql_ReturnEscaped(Points[pid][Name], MainPipeline),
		pid+1
	);	
		
	mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "i", SENDDATA_THREAD);	
}		

forward OnLoadPoints();
public OnLoadPoints()
{
	new fields, rows, index, result[128];
	cache_get_data(rows, fields, MainPipeline);

	while((index < rows))
	{
		cache_get_field_content(index, "id", result, MainPipeline); Points[index][pointID] = strval(result);
		cache_get_field_content(index, "posx", result, MainPipeline); Points[index][Pointx] = floatstr(result);
		cache_get_field_content(index, "posy", result, MainPipeline); Points[index][Pointy] = floatstr(result);
		cache_get_field_content(index, "posz", result, MainPipeline); Points[index][Pointz] = floatstr(result);
		cache_get_field_content(index, "vw", result, MainPipeline); Points[index][pointVW] = strval(result);
		cache_get_field_content(index, "type", result, MainPipeline); Points[index][Type] = strval(result);
		cache_get_field_content(index, "vulnerable", result, MainPipeline); Points[index][Vulnerable] = strval(result);
		cache_get_field_content(index, "matpoint", result, MainPipeline); Points[index][MatPoint] = strval(result);
		cache_get_field_content(index, "owner", Points[index][Owner], MainPipeline, 128);
		cache_get_field_content(index, "cappername", Points[index][CapperName], MainPipeline, MAX_PLAYER_NAME);
		cache_get_field_content(index, "name", Points[index][Name], MainPipeline, 128);
		cache_get_field_content(index, "captime", result, MainPipeline); Points[index][CapTime] = strval(result);
		cache_get_field_content(index, "capfam", result, MainPipeline); Points[index][CapFam] = strval(result);
		cache_get_field_content(index, "capname", Points[index][CapName], MainPipeline, MAX_PLAYER_NAME);
		
		Points[index][CaptureTimerEx2] = -1;
		Points[index][ClaimerId] = INVALID_PLAYER_ID;
		Points[index][PointPickupID] = CreateDynamicPickup(1239, 23, Points[index][Pointx], Points[index][Pointy], Points[index][Pointz], Points[index][pointVW]);
		
		if(Points[index][CapFam] != INVALID_FAMILY_ID)
		{
			Points[index][CapCrash] = 1;
			Points[index][TakeOverTimerStarted] = 1;
			Points[index][ClaimerTeam] = Points[index][CapFam];
			Points[index][TakeOverTimer] = Points[index][CapTime];
			format(Points[index][PlayerNameCapping], MAX_PLAYER_NAME, "%s", Points[index][CapName]);
			ReadyToCapture(index);
			Points[index][CaptureTimerEx2] = SetTimerEx("CaptureTimerEx", 60000, 1, "d", index);	
		}
		
		index++;
	}
	if(index == 0) print("[Family Points] No family points has been loaded.");
	if(index != 0) printf("[Family Points] %d family points has been loaded.", index);
	return 1;
}

stock GetPartnerName(playerid)
{
	if(PlayerInfo[playerid][pMarriedID] == -1) format(PlayerInfo[playerid][pMarriedName], MAX_PLAYER_NAME, "Nobody");
	else
	{
		new query[128];
		format(query, sizeof(query), "SELECT `Username` FROM `accounts` WHERE `id` = %d", PlayerInfo[playerid][pMarriedID]);	
		mysql_function_query(MainPipeline, query, true, "OnGetPartnerName", "i", playerid);
	}
}

forward OnGetPartnerName(playerid);
public OnGetPartnerName(playerid)
{
	new fields, rows, index;
	cache_get_data(rows, fields, MainPipeline);
	
	cache_get_field_content(index, "Username", PlayerInfo[playerid][pMarriedName], MainPipeline, MAX_PLAYER_NAME);
	return 1;
}

forward OnStaffPrize(playerid);
public OnStaffPrize(playerid)
{
	if(mysql_affected_rows(MainPipeline))
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
	format(string, sizeof(string), "INSERT into `hgbackpacks` (type, posx, posy, posz) VALUES ('%d', '%f', '%f', '%f')",
	HungerBackpackInfo[id][hgBackpackType],
	HungerBackpackInfo[id][hgBackpackPos][0],
	HungerBackpackInfo[id][hgBackpackPos][1],
	HungerBackpackInfo[id][hgBackpackPos][2]);
	
	mysql_function_query(MainPipeline, string, true, "OnQueryFinish", "i", SENDDATA_THREAD);
}
	
stock SaveHGBackpack(id)
{
	new string[1024];
	format(string, sizeof(string), "UPDATE `hgbackpacks` SET \
		`type` = %d,
		`posx` = %f,
		`posy` = %f,
		`posz` = %f WHERE `id` = %d",
		HungerBackpackInfo[id][hgBackpackType],
		HungerBackpackInfo[id][hgBackpackPos][0],
		HungerBackpackInfo[id][hgBackpackPos][1],
		HungerBackpackInfo[id][hgBackpackPos][2],
		id
	);
		
	mysql_function_query(MainPipeline, string, false "OnQueryFinish", "i", SENDDATA_THREAD);
}

forward OnLoadHGBackpacks();
public OnLoadHGBackpacks()
{
	new fields, rows, index, result[128], string[128];
	cache_get_data(rows, fields, MainPipeline);
	
	while((index < rows))
	{
		cache_get_field_content(index, "id", result, MainPipeline); HungerBackpackInfo[index][hgBackpackId] = strval(result);
		cache_get_field_content(index, "type", result, MainPipeline); HungerBackpackInfo[index][hgBackpackType] = strval(result);
		cache_get_field_content(index, "posx", result, MainPipeline); HungerBackpackInfo[index][hgBackpackPos][0] = floatstr(result);
		cache_get_field_content(index, "posy", result, MainPipeline); HungerBackpackInfo[index][hgBackpackPos][1] = floatstr(result);
		cache_get_field_content(index, "posz", result, MainPipeline); HungerBackpackInfo[index][hgBackpackPos][2] = floatstr(result);
		
		HungerBackpackInfo[index][hgActiveEx] = 1;
		
		HungerBackpackInfo[index][hgBackpackPickupId] = CreateDynamicPickup(371, 23, HungerBackpackInfo[index][hgBackpackPos][0], HungerBackpackInfo[index][hgBackpackPos][1], HungerBackpackInfo[index][hgBackpackPos][2], 2039);
		format(string, sizeof(string), "Hunger Games Backpack\nType: %s\n{FF0000}(ID: %d){FFFFFF}", GetBackpackName(index), index);
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
	new rows, fields, index, result[128], string[128], query[128], tmp[8];
	switch(id)
	{
		case 0:
		{
			cache_get_data(rows, fields, MainPipeline);
			if(IsPlayerConnected(playerid))
			{
				while(index < rows)
				{
					cache_get_field_content(index, "id", result, MainPipeline); tmp[0] = strval(result);
					cache_get_field_content(index, "GiftVoucher", result, MainPipeline); tmp[1] = strval(result);
					cache_get_field_content(index, "CarVoucher", result, MainPipeline); tmp[2] = strval(result);
					cache_get_field_content(index, "VehVoucher", result, MainPipeline); tmp[3] = strval(result);
					cache_get_field_content(index, "SVIPVoucher", result, MainPipeline); tmp[4] = strval(result);
					cache_get_field_content(index, "GVIPVoucher", result, MainPipeline); tmp[5] = strval(result);
					cache_get_field_content(index, "PVIPVoucher", result, MainPipeline); tmp[6] = strval(result);
					cache_get_field_content(index, "credits_spent", result, MainPipeline); tmp[7] = strval(result);
					
					if(tmp[1] > 0)
					{
						PlayerInfo[playerid][pGiftVoucher] += tmp[1];
						format(string, sizeof(string), "You have been automatically issued %d gift reset voucher(s).", tmp[1]);
						SendClientMessageEx(playerid, COLOR_WHITE, string);
						format(string, sizeof(string), "[ID: %d] %s was automatically issued %d gift reset voucher(s)", tmp[0], GetPlayerNameEx(playerid), tmp[1]);
						Log("logs/shoplog.log", string);
					}
					if(tmp[2] > 0)
					{
						PlayerInfo[playerid][pCarVoucher] += tmp[2];
						format(string, sizeof(string), "You have been automatically issued %d restricted car voucher(s).", tmp[2]);
						SendClientMessageEx(playerid, COLOR_WHITE, string);
						format(string, sizeof(string), "[ID: %d] %s was automatically issued %d restricted car voucher(s)", tmp[0], GetPlayerNameEx(playerid), tmp[2]);
						Log("logs/shoplog.log", string);
					}
					if(tmp[3] > 0)
					{
						PlayerInfo[playerid][pVehVoucher] += tmp[3];
						format(string, sizeof(string), "You have been automatically issued %d car voucher(s).", tmp[3]);
						SendClientMessageEx(playerid, COLOR_WHITE, string);
						format(string, sizeof(string), "[ID: %d] %s was automatically issued %d car voucher(s)", tmp[0], GetPlayerNameEx(playerid), tmp[3]);
						Log("logs/shoplog.log", string);
					}
					if(tmp[4] > 0)
					{
						PlayerInfo[playerid][pSVIPVoucher] += tmp[4];
						format(string, sizeof(string), "You have been automatically issued %d Silver VIP voucher(s).", tmp[4]);
						SendClientMessageEx(playerid, COLOR_WHITE, string);
						format(string, sizeof(string), "[ID: %d] %s was automatically issued %d Silver VIP voucher(s)", tmp[0], GetPlayerNameEx(playerid), tmp[4]);
						Log("logs/shoplog.log", string);
					}
					if(tmp[5] > 0)
					{
						PlayerInfo[playerid][pGVIPVoucher] += tmp[5];
						format(string, sizeof(string), "You have been automatically issued %d Gold VIP voucher(s).", tmp[5]);
						SendClientMessageEx(playerid, COLOR_WHITE, string);
						format(string, sizeof(string), "[ID: %d] %s was automatically issued %d Gold VIP voucher(s)", tmp[0], GetPlayerNameEx(playerid), tmp[5]);
						Log("logs/shoplog.log", string);
					}
					if(tmp[6] > 0)
					{
						PlayerInfo[playerid][pPVIPVoucher] += tmp[6];
						format(string, sizeof(string), "You have been automatically issued %d Platinum VIP voucher(s).", tmp[6]);
						SendClientMessageEx(playerid, COLOR_WHITE, string);
						format(string, sizeof(string), "[ID: %d] %s was automatically issued %d Platinum VIP voucher(s)", tmp[0], GetPlayerNameEx(playerid), tmp[6]);
						Log("logs/shoplog.log", string);
					}
					GivePlayerCredits(playerid, tmp[7], 1, 1);
					format(string, sizeof(string), "%s | Credits: %d - 1", GetPlayerNameEx(playerid), tmp[7]);
					Log("logs/shopdebug.log", string);
					format(query, sizeof(query), "UPDATE `shop_orders` SET `status` = 1 WHERE `id` = %d", tmp[0]);
					mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
					format(string, sizeof(string), "%s | Status set to 1 - 1", GetPlayerNameEx(playerid));
					Log("logs/shopdebug.log", string);
					OnPlayerStatsUpdate(playerid);
					return SendClientMessageEx(playerid, COLOR_CYAN, "* Use /myvouchers to check and use your vouchers at any time!");
				}
			}
		}
		case 1:
		{
			cache_get_data(rows, fields, ShopPipeline);
			if(IsPlayerConnected(playerid))
			{
				while(index < rows)
				{
					cache_get_field_content(index, "order_id", result, ShopPipeline); tmp[0] = strval(result);
					cache_get_field_content(index, "credit_amount", result, ShopPipeline); tmp[1] = strval(result);
					
					GivePlayerCredits(playerid, tmp[1], 1);
					format(string, sizeof(string), "%s | Credits: %d - 2", GetPlayerNameEx(playerid), tmp[1]);
					Log("logs/shopdebug.log", string);
					format(string, sizeof(string), "You have been automatically issued %s credit(s).", number_format(tmp[1]));
					SendClientMessageEx(playerid, COLOR_WHITE, string);
					format(string, sizeof(string), "[ID: %d] %s was automatically issued %s credit(s)", tmp[0], GetPlayerNameEx(playerid), number_format(tmp[1]));
					Log("logs/shoplog.log", string);
					format(query, sizeof(query), "UPDATE `order_delivery_status` SET `status` = 1 WHERE `order_id` = %d", tmp[0]);
					mysql_function_query(ShopPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
					format(string, sizeof(string), "%s | Status set to 1 - 2", GetPlayerNameEx(playerid));
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
	format(string, sizeof(string), "SELECT `AdminLevel`, `SecureIP`, `Watchdog` FROM `accounts` WHERE `Username` = '%s'", GetPlayerNameExt(playerid));
	mysql_function_query(MainPipeline, string, true, "OnQueryFinish", "iii", ADMINWHITELIST_THREAD, playerid, g_arrQueryHandle{playerid});
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
				format(szQuery, sizeof(szQuery), "UPDATE `accounts` SET `Bank`=%d WHERE `id` = %d", PlayerInfo[playerid][pAccount], GetPlayerSQLId(playerid));
				mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
			}
			case TYPE_ONHAND:
			{
				PlayerInfo[playerid][pCash] += amount;
				format(szQuery, sizeof(szQuery), "UPDATE `accounts` SET `Money`=%d WHERE `id` = %d", PlayerInfo[playerid][pCash], GetPlayerSQLId(playerid));
				mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);		
			}
		}
	}	
	return 1;
}

stock PointCrashProtection(point)
{
	new query[128], temp;
	temp = Points[point][ClaimerTeam];
	if(temp == INVALID_PLAYER_ID)
	{
		temp = INVALID_FAMILY_ID;
	}
	format(query, sizeof(query), "UPDATE `points` SET `captime` = %d, `capfam` = %d, `capname` = '%s' WHERE `id` = %d",Points[point][TakeOverTimer], temp, Points[point][PlayerNameCapping], Points[point][pointID]);
	mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	return 1;
}

/*stock LoadHelp()
{
	printf("[LoadHelp] Loading data from database...");
	mysql_function_query(MainPipeline, "SELECT * FROM `help`", true, "OnLoadHelp", "");
}

forward OnLoadHelp();
public OnLoadHelp()
{
	new i, rows, fields, tmp[128];
	cache_get_data(rows, fields, MainPipeline);

	TOTAL_COMMANDS = rows;
	while(i < rows)
	{
		cache_get_field_content(i, "id", tmp, MainPipeline); HelpInfo[i][id] = strval(tmp);
		cache_get_field_content(i, "name", HelpInfo[i][name], MainPipeline, 255);
		cache_get_field_content(i, "params", HelpInfo[i][params], MainPipeline, 255);
		cache_get_field_content(i, "description", HelpInfo[i][description], MainPipeline, 255);
		cache_get_field_content(i, "type", tmp, MainPipeline); HelpInfo[i][type] = strval(tmp);
		cache_get_field_content(i, "subtype", tmp, MainPipeline); HelpInfo[i][subtype] = strval(tmp);
		cache_get_field_content(i, "perms", tmp, MainPipeline); HelpInfo[i][perms] = strval(tmp);
		i++;
	}
}*/

stock LoadGangTags()
{
	new query[128];
	format(query, sizeof(query), "SELECT * FROM `gangtags` LIMIT %d", MAX_GANGTAGS);
	mysql_function_query(MainPipeline, query, true, "OnGangTagQueryFinish", "ii", LOAD_GANGTAGS, -1);
}

stock SaveGangTag(gangtag)
{
	new query[256];
	format(query, sizeof(query), "UPDATE `gangtags` SET \
		`posx` = %f, \
		`posy` = %f, \
		`posz` = %f, \
		`posrx` = %f, \
		`posry` = %f, \
		`posrz` = %f, \
		`objectid` = %d, \
		`vw` = %d, \
		`interior` = %d, \
		`family` = %d, \
		`time` = %d, \
		`used` = %d WHERE `id` = %d",
		GangTags[gangtag][gt_PosX],
		GangTags[gangtag][gt_PosY],
		GangTags[gangtag][gt_PosZ],
		GangTags[gangtag][gt_PosRX],
		GangTags[gangtag][gt_PosRY],
		GangTags[gangtag][gt_PosRZ],
		GangTags[gangtag][gt_ObjectID],
		GangTags[gangtag][gt_VW],
		GangTags[gangtag][gt_Int],
		GangTags[gangtag][gt_Family],
		GangTags[gangtag][gt_Time],
		GangTags[gangtag][gt_Used],
		GangTags[gangtag][gt_SQLID]
	);
	mysql_function_query(MainPipeline, query, false, "OnGangTagQueryFinish", "ii", SAVE_GANGTAG, gangtag);
}

forward OnGangTagQueryFinish(threadid, extraid);
public OnGangTagQueryFinish(threadid, extraid)
{
	new fields, rows;
	cache_get_data(rows, fields, MainPipeline);
	switch(threadid)
	{
		case LOAD_GANGTAGS:
		{
			new row, result[64];
			while(row < rows)
			{
				cache_get_field_content(row, "id", result, MainPipeline); GangTags[row][gt_SQLID] = strval(result);
				cache_get_field_content(row, "posx", result, MainPipeline); GangTags[row][gt_PosX] = floatstr(result);
				cache_get_field_content(row, "posy", result, MainPipeline); GangTags[row][gt_PosY] = floatstr(result);
				cache_get_field_content(row, "posz", result, MainPipeline); GangTags[row][gt_PosZ] = floatstr(result);
				cache_get_field_content(row, "posrx", result, MainPipeline); GangTags[row][gt_PosRX] = floatstr(result);
				cache_get_field_content(row, "posry", result, MainPipeline); GangTags[row][gt_PosRY] = floatstr(result);
				cache_get_field_content(row, "posrz", result, MainPipeline); GangTags[row][gt_PosRZ] = floatstr(result);
				cache_get_field_content(row, "objectid", result, MainPipeline); GangTags[row][gt_ObjectID] = strval(result);
				cache_get_field_content(row, "vw", result, MainPipeline); GangTags[row][gt_VW] = strval(result);
				cache_get_field_content(row, "interior", result, MainPipeline); GangTags[row][gt_Int] = strval(result);
				cache_get_field_content(row, "family", result, MainPipeline); GangTags[row][gt_Family] = strval(result);
				cache_get_field_content(row, "used", result, MainPipeline); GangTags[row][gt_Used] = strval(result);
				cache_get_field_content(row, "time", result, MainPipeline); GangTags[row][gt_Time] = strval(result);
				CreateGangTag(row);
				row++;
			}
			if(row > 0)
			{
				printf("[MYSQL] Successfully loaded %d gang tags.", row);
			}
			else
			{
				print("[MYSQL] Failed loading any gang tags.");
			}
		}
		case SAVE_GANGTAG:
		{
			if(mysql_affected_rows(MainPipeline))
			{
				printf("[MYSQL] Successfully saved gang tag %d (SQLID: %d).", extraid, GangTags[extraid][gt_SQLID]);
			}
			else
			{
				printf("[MYSQL] Failed saving gang tag %d (SQLID: %d).", extraid, GangTags[extraid][gt_SQLID]);
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
	mysql_function_query(MainPipeline, "SELECT * FROM `giftbox`", true, "OnQueryFinish", "iii", LOADGIFTBOX_THREAD, INVALID_PLAYER_ID, -1);
}

stock SaveDynamicGiftBox()
{
	new query[4096];
	for(new i = 0; i < 4; i++)
	{
		if(i == 0)
			format(query, sizeof(query), "UPDATE `giftbox` SET `dgMoney%d` = '%d',", i, dgMoney[i]);
		else
			format(query, sizeof(query), "%s `dgMoney%d` = '%d',", query, i, dgMoney[i]);
			
		format(query, sizeof(query), "%s `dgRimKit%d` = '%d',", query, i, dgRimKit[i]);
		format(query, sizeof(query), "%s `dgFirework%d` = '%d',", query, i, dgFirework[i]);
		format(query, sizeof(query), "%s `dgGVIP%d` = '%d',", query, i, dgGVIP[i]);
		format(query, sizeof(query), "%s `dgSVIP%d` = '%d',", query, i, dgSVIP[i]);
		format(query, sizeof(query), "%s `dgGVIPEx%d` = '%d',", query, i, dgGVIPEx[i]);
		format(query, sizeof(query), "%s `dgSVIPEx%d` = '%d',", query, i, dgSVIPEx[i]);
		format(query, sizeof(query), "%s `dgCarSlot%d` = '%d',", query, i, dgCarSlot[i]);
		format(query, sizeof(query), "%s `dgToySlot%d` = '%d',", query, i, dgToySlot[i]);
		format(query, sizeof(query), "%s `dgArmor%d` = '%d',", query, i, dgArmor[i]);
		format(query, sizeof(query), "%s `dgFirstaid%d` = '%d',", query, i, dgFirstaid[i]);
		format(query, sizeof(query), "%s `dgDDFlag%d` = '%d',", query, i, dgDDFlag[i]);
		format(query, sizeof(query), "%s `dgGateFlag%d` = '%d',", query, i, dgGateFlag[i]);
		format(query, sizeof(query), "%s `dgCredits%d` = '%d',", query, i, dgCredits[i]);
		format(query, sizeof(query), "%s `dgPriorityAd%d` = '%d',", query, i, dgPriorityAd[i]);
		format(query, sizeof(query), "%s `dgHealthNArmor%d` = '%d',", query, i, dgHealthNArmor[i]);
		format(query, sizeof(query), "%s `dgGiftReset%d` = '%d',", query, i, dgGiftReset[i]);
		format(query, sizeof(query), "%s `dgMaterial%d` = '%d',", query, i, dgMaterial[i]);
		format(query, sizeof(query), "%s `dgWarning%d` = '%d',", query, i, dgWarning[i]);
		format(query, sizeof(query), "%s `dgPot%d` = '%d',", query, i, dgPot[i]);
		format(query, sizeof(query), "%s `dgCrack%d` = '%d',", query, i, dgCrack[i]);
		format(query, sizeof(query), "%s `dgPaintballToken%d` = '%d',", query, i, dgPaintballToken[i]);
		format(query, sizeof(query), "%s `dgVIPToken%d` = '%d',", query, i, dgVIPToken[i]);
		format(query, sizeof(query), "%s `dgRespectPoint%d` = '%d',", query, i, dgRespectPoint[i]);
		format(query, sizeof(query), "%s `dgCarVoucher%d` = '%d',", query, i, dgCarVoucher[i]);
		format(query, sizeof(query), "%s `dgBuddyInvite%d` = '%d',", query, i, dgBuddyInvite[i]);
		format(query, sizeof(query), "%s `dgLaser%d` = '%d',", query, i, dgLaser[i]);
		format(query, sizeof(query), "%s `dgCustomToy%d` = '%d',", query, i, dgCustomToy[i]);
		format(query, sizeof(query), "%s `dgAdmuteReset%d` = '%d',", query, i, dgAdmuteReset[i]);
		format(query, sizeof(query), "%s `dgNewbieMuteReset%d` = '%d',", query, i, dgNewbieMuteReset[i]);
		
		if(i == 3)
			format(query, sizeof(query), "%s `dgRestrictedCarVoucher%d` = '%d'", query, i, dgRestrictedCarVoucher[i]);
		else
			format(query, sizeof(query), "%s `dgPlatinumVIPVoucher%d` = '%d',", query, i, dgPlatinumVIPVoucher[i]);
	}

	mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
}

stock LoadPaintballArenas()
{
	new query[64];
	printf("[LoadPaintballArenas] Loading Paintball Arenas from the database, please wait...");
	format(query, sizeof(query), "SELECT * FROM `arenas` LIMIT %d", MAX_ARENAS);
	mysql_function_query(MainPipeline, query, true, "OnLoadPaintballArenas", "");
}

forward OnLoadPaintballArenas();
public OnLoadPaintballArenas()
{
	new fields, rows, index, result[128];
	cache_get_data(rows, fields, MainPipeline);

	while((index < rows))
	{
		cache_get_field_content(index, "id", result, MainPipeline); PaintBallArena[index][pbSQLId] = strval(result);
		cache_get_field_content(index, "name", PaintBallArena[index][pbArenaName], MainPipeline, 64);
		cache_get_field_content(index, "vw", result, MainPipeline); PaintBallArena[index][pbVirtual] = strval(result);
		cache_get_field_content(index, "interior", result, MainPipeline); PaintBallArena[index][pbInterior] = strval(result);
		cache_get_field_content(index, "dm1", result, MainPipeline); sscanf(result, "p<|>ffff", PaintBallArena[index][pbDeathmatch1][0], PaintBallArena[index][pbDeathmatch1][1], PaintBallArena[index][pbDeathmatch1][2], PaintBallArena[index][pbDeathmatch1][3]);
		cache_get_field_content(index, "dm2", result, MainPipeline); sscanf(result, "p<|>ffff", PaintBallArena[index][pbDeathmatch2][0], PaintBallArena[index][pbDeathmatch2][1], PaintBallArena[index][pbDeathmatch2][2], PaintBallArena[index][pbDeathmatch2][3]);	
		cache_get_field_content(index, "dm3", result, MainPipeline); sscanf(result, "p<|>ffff", PaintBallArena[index][pbDeathmatch3][0], PaintBallArena[index][pbDeathmatch3][1], PaintBallArena[index][pbDeathmatch3][2], PaintBallArena[index][pbDeathmatch3][3]);
		cache_get_field_content(index, "dm4", result, MainPipeline); sscanf(result, "p<|>ffff", PaintBallArena[index][pbDeathmatch4][0], PaintBallArena[index][pbDeathmatch4][1], PaintBallArena[index][pbDeathmatch4][2], PaintBallArena[index][pbDeathmatch4][3]);
		cache_get_field_content(index, "red1", result, MainPipeline); sscanf(result, "p<|>ffff", PaintBallArena[index][pbTeamRed1][0], PaintBallArena[index][pbTeamRed1][1], PaintBallArena[index][pbTeamRed1][2], PaintBallArena[index][pbTeamRed1][3]);
		cache_get_field_content(index, "red2", result, MainPipeline); sscanf(result, "p<|>ffff", PaintBallArena[index][pbTeamRed2][0], PaintBallArena[index][pbTeamRed2][1], PaintBallArena[index][pbTeamRed2][2], PaintBallArena[index][pbTeamRed2][3]);
		cache_get_field_content(index, "red3", result, MainPipeline); sscanf(result, "p<|>ffff", PaintBallArena[index][pbTeamRed3][0], PaintBallArena[index][pbTeamRed3][1], PaintBallArena[index][pbTeamRed3][2], PaintBallArena[index][pbTeamRed3][3]);
		cache_get_field_content(index, "blue1", result, MainPipeline); sscanf(result, "p<|>ffff", PaintBallArena[index][pbTeamBlue1][0], PaintBallArena[index][pbTeamBlue1][1], PaintBallArena[index][pbTeamBlue1][2], PaintBallArena[index][pbTeamBlue1][3]);
		cache_get_field_content(index, "blue2", result, MainPipeline); sscanf(result, "p<|>ffff", PaintBallArena[index][pbTeamBlue2][0], PaintBallArena[index][pbTeamBlue2][1], PaintBallArena[index][pbTeamBlue2][2], PaintBallArena[index][pbTeamBlue2][3]);
		cache_get_field_content(index, "blue3", result, MainPipeline); sscanf(result, "p<|>ffff", PaintBallArena[index][pbTeamBlue3][0], PaintBallArena[index][pbTeamBlue3][1], PaintBallArena[index][pbTeamBlue3][2], PaintBallArena[index][pbTeamBlue3][3]);	
		cache_get_field_content(index, "flagred", result, MainPipeline); sscanf(result, "p<|>fff", PaintBallArena[index][pbFlagRedSpawn][0], PaintBallArena[index][pbFlagRedSpawn][1], PaintBallArena[index][pbFlagRedSpawn][2]);	
		cache_get_field_content(index, "flagblue", result, MainPipeline); sscanf(result, "p<|>fff", PaintBallArena[index][pbFlagBlueSpawn][0], PaintBallArena[index][pbFlagBlueSpawn][1], PaintBallArena[index][pbFlagBlueSpawn][2]);	
		cache_get_field_content(index, "hill", result, MainPipeline); sscanf(result, "p<|>fff", PaintBallArena[index][pbHillX], PaintBallArena[index][pbHillY], PaintBallArena[index][pbHillZ]);
		cache_get_field_content(index, "hillr", result, MainPipeline); PaintBallArena[index][pbHillRadius] = floatstr(result);
		cache_get_field_content(index, "veh1", result, MainPipeline); sscanf(result, "p<|>dffff", PaintBallArena[index][pbVeh1Model], PaintBallArena[index][pbVeh1X], PaintBallArena[index][pbVeh1Y], PaintBallArena[index][pbVeh1Z], PaintBallArena[index][pbVeh1A]);
 		cache_get_field_content(index, "veh2", result, MainPipeline); sscanf(result, "p<|>dffff", PaintBallArena[index][pbVeh2Model], PaintBallArena[index][pbVeh2X], PaintBallArena[index][pbVeh2Y], PaintBallArena[index][pbVeh2Z], PaintBallArena[index][pbVeh2A]);
		cache_get_field_content(index, "veh3", result, MainPipeline); sscanf(result, "p<|>dffff", PaintBallArena[index][pbVeh3Model], PaintBallArena[index][pbVeh3X], PaintBallArena[index][pbVeh3Y], PaintBallArena[index][pbVeh3Z], PaintBallArena[index][pbVeh3A]);
		cache_get_field_content(index, "veh4", result, MainPipeline); sscanf(result, "p<|>dffff", PaintBallArena[index][pbVeh4Model], PaintBallArena[index][pbVeh4X], PaintBallArena[index][pbVeh4Y], PaintBallArena[index][pbVeh4Z], PaintBallArena[index][pbVeh4A]);
		cache_get_field_content(index, "veh5", result, MainPipeline); sscanf(result, "p<|>dffff", PaintBallArena[index][pbVeh5Model], PaintBallArena[index][pbVeh5X], PaintBallArena[index][pbVeh5Y], PaintBallArena[index][pbVeh5Z], PaintBallArena[index][pbVeh5A]);
		cache_get_field_content(index, "veh6", result, MainPipeline); sscanf(result, "p<|>dffff", PaintBallArena[index][pbVeh6Model], PaintBallArena[index][pbVeh6X], PaintBallArena[index][pbVeh6Y], PaintBallArena[index][pbVeh6Z], PaintBallArena[index][pbVeh6A]);		
		index++;
	}
	if(index == 0) print("[LoadPaintBallArenas] No Paintball Arenas have been loaded.");
	if(index != 0) printf("[LoadPaintBallArenas] %d Paintball Arenas have been loaded.", index);
	return 1;
}

stock SavePaintballArena(index)
{
	new query[2048];
	format(query, sizeof(query), "UPDATE `arenas` SET `name`='%s',", g_mysql_ReturnEscaped(PaintBallArena[index][pbArenaName], MainPipeline));
	format(query, sizeof(query), "%s `vw`=%d,",query, PaintBallArena[index][pbVirtual]);
	format(query, sizeof(query), "%s `interior`=%d,", query, PaintBallArena[index][pbInterior]);
	format(query, sizeof(query), "%s `dm1`='%f|%f|%f|%f',", query, PaintBallArena[index][pbDeathmatch1][0], PaintBallArena[index][pbDeathmatch1][1], PaintBallArena[index][pbDeathmatch1][2], PaintBallArena[index][pbDeathmatch1][3]);
	format(query, sizeof(query), "%s `dm2`='%f|%f|%f|%f',", query, PaintBallArena[index][pbDeathmatch2][0], PaintBallArena[index][pbDeathmatch2][1], PaintBallArena[index][pbDeathmatch2][2], PaintBallArena[index][pbDeathmatch2][3]);
	format(query, sizeof(query), "%s `dm3`='%f|%f|%f|%f',", query, PaintBallArena[index][pbDeathmatch3][0], PaintBallArena[index][pbDeathmatch3][1], PaintBallArena[index][pbDeathmatch3][2], PaintBallArena[index][pbDeathmatch3][3]);
	format(query, sizeof(query), "%s `dm4`='%f|%f|%f|%f',", query, PaintBallArena[index][pbDeathmatch4][0], PaintBallArena[index][pbDeathmatch4][1], PaintBallArena[index][pbDeathmatch4][2], PaintBallArena[index][pbDeathmatch4][3]);
	format(query, sizeof(query), "%s `red1`='%f|%f|%f|%f',", query, PaintBallArena[index][pbTeamRed1][0], PaintBallArena[index][pbTeamRed1][1], PaintBallArena[index][pbTeamRed1][2], PaintBallArena[index][pbTeamRed1][3]);
	format(query, sizeof(query), "%s `red2`='%f|%f|%f|%f',", query, PaintBallArena[index][pbTeamRed2][0], PaintBallArena[index][pbTeamRed2][1], PaintBallArena[index][pbTeamRed2][2], PaintBallArena[index][pbTeamRed2][3]);
	format(query, sizeof(query), "%s `red3`='%f|%f|%f|%f',", query, PaintBallArena[index][pbTeamRed3][0], PaintBallArena[index][pbTeamRed3][1], PaintBallArena[index][pbTeamRed3][2], PaintBallArena[index][pbTeamRed3][3]);
	format(query, sizeof(query), "%s `blue1`='%f|%f|%f|%f',", query, PaintBallArena[index][pbTeamBlue1][0], PaintBallArena[index][pbTeamBlue1][1], PaintBallArena[index][pbTeamBlue1][2], PaintBallArena[index][pbTeamBlue1][3]);
	format(query, sizeof(query), "%s `blue2`='%f|%f|%f|%f',", query, PaintBallArena[index][pbTeamBlue2][0], PaintBallArena[index][pbTeamBlue2][1], PaintBallArena[index][pbTeamBlue2][2], PaintBallArena[index][pbTeamBlue2][3]);
	format(query, sizeof(query), "%s `blue3`='%f|%f|%f|%f',", query, PaintBallArena[index][pbTeamBlue3][0], PaintBallArena[index][pbTeamBlue3][1], PaintBallArena[index][pbTeamBlue3][2], PaintBallArena[index][pbTeamBlue3][3]);
	format(query, sizeof(query), "%s `flagred`='%f|%f|%f',", query, PaintBallArena[index][pbFlagRedSpawn][0], PaintBallArena[index][pbFlagRedSpawn][1], PaintBallArena[index][pbFlagRedSpawn][2]);
	format(query, sizeof(query), "%s `flagblue`='%f|%f|%f',", query, PaintBallArena[index][pbFlagBlueSpawn][0], PaintBallArena[index][pbFlagBlueSpawn][1], PaintBallArena[index][pbFlagBlueSpawn][2]);
	format(query, sizeof(query), "%s `hill`='%f|%f|%f',", query, PaintBallArena[index][pbHillX], PaintBallArena[index][pbHillY], PaintBallArena[index][pbHillZ]);
	format(query, sizeof(query), "%s `hillr`=%f,", query, PaintBallArena[index][pbHillRadius]);
	format(query, sizeof(query), "%s `veh1`='%d|%f|%f|%f|%f',", query, PaintBallArena[index][pbVeh1Model], PaintBallArena[index][pbVeh1X], PaintBallArena[index][pbVeh1Y], PaintBallArena[index][pbVeh1Z], PaintBallArena[index][pbVeh1A]);
	format(query, sizeof(query), "%s `veh2`='%d|%f|%f|%f|%f',", query, PaintBallArena[index][pbVeh2Model], PaintBallArena[index][pbVeh2X], PaintBallArena[index][pbVeh2Y], PaintBallArena[index][pbVeh2Z], PaintBallArena[index][pbVeh2A]);
	format(query, sizeof(query), "%s `veh3`='%d|%f|%f|%f|%f',", query, PaintBallArena[index][pbVeh3Model], PaintBallArena[index][pbVeh3X], PaintBallArena[index][pbVeh3Y], PaintBallArena[index][pbVeh3Z], PaintBallArena[index][pbVeh3A]);
	format(query, sizeof(query), "%s `veh4`='%d|%f|%f|%f|%f',", query, PaintBallArena[index][pbVeh4Model], PaintBallArena[index][pbVeh4X], PaintBallArena[index][pbVeh4Y], PaintBallArena[index][pbVeh4Z], PaintBallArena[index][pbVeh4A]);
	format(query, sizeof(query), "%s `veh5`='%d|%f|%f|%f|%f',", query, PaintBallArena[index][pbVeh5Model], PaintBallArena[index][pbVeh5X], PaintBallArena[index][pbVeh5Y], PaintBallArena[index][pbVeh5Z], PaintBallArena[index][pbVeh5A]);
	format(query, sizeof(query), "%s `veh6`='%d|%f|%f|%f|%f'", query, PaintBallArena[index][pbVeh6Model], PaintBallArena[index][pbVeh6X], PaintBallArena[index][pbVeh6Y], PaintBallArena[index][pbVeh6Z], PaintBallArena[index][pbVeh6A]);	
	format(query, sizeof(query), "%s WHERE `id` = %d", query, PaintBallArena[index][pbSQLId]);
	mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
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
	mysql_real_escape_string(reason, escapedstring);
	
	format(szQuery, sizeof(szQuery), "INSERT INTO `nonrppoints` (sqlid, point, expiration, reason, issuer, active, manual) VALUES ('%d', '%d', '%d', '%s', '%s', '1', '%d')",
	GetPlayerSQLId(playerid),
	point,
	expiration,
	escapedstring,
	GetPlayerSQLId(issuerid),
	manual,
	GetPlayerNameEx(issuerid));
	
	mysql_function_query(MainPipeline, szQuery, true, "OnQueryFinish", "i", SENDDATA_THREAD);
}

stock LoadPlayerNonRPPoints(playerid)
{
	new string[128];
	format(string, sizeof(string), "SELECT * FROM `nonrppoints` WHERE `sqlid` = '%d'", PlayerInfo[playerid][pId]);
	mysql_function_query(MainPipeline, string, true, "OnQueryFinish", "iii", LOADPNONRPOINTS_THREAD, playerid, g_arrQueryHandle{playerid});
	return true;
}

forward OnWDWhitelist(index);
public OnWDWhitelist(index)
{
	new string[128], name[24];
	GetPVarString(index, "OnWDWhitelist", name, 24);

	if(mysql_affected_rows(MainPipeline)) {
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
	new rows, fields;
	cache_get_data(rows, fields, MainPipeline);
	#pragma unused fields
	for(new i = 0; i < rows; i++)
	{
		new szResult[32], points, sqlid;
		cache_get_field_content(i, "sqlid", szResult, MainPipeline); sqlid = strval(szResult);
		cache_get_field_content(i, "point", szResult, MainPipeline); points = strval(szResult);
		
		// Is the player connected?
		for(new x = 0; x < MAX_PLAYERS; x++)
		{
			if(IsPlayerConnected(x) && PlayerInfo[x][pId] == sqlid)
			{
				format(PublicSQLString, sizeof(PublicSQLString), "%s %s (ID: %d) | Points: %d - Manually Added\n", PublicSQLString, GetPlayerNameEx(x), x, points);
				break;
			}
		}
	}
	
	mysql_function_query(MainPipeline, "SELECT sqlid, point  FROM `nonrppoints` LEFT JOIN accounts on sqlid = accounts.id WHERE (`active` = '1' AND `manual` = '0') AND accounts.`Online` = 1 ORDER BY `point` DESC LIMIT 15", true, "FetchWatchlist2", "i", index);
	return true;
}

forward FetchWatchlist2(index, input[]);
public FetchWatchlist2(index, input[])
{
	new rows, fields;
	cache_get_data(rows, fields, MainPipeline);
	#pragma unused fields
	for(new i = 0; i < rows; i++)
	{
		new szResult[32], points, sqlid;
		cache_get_field_content(i, "sqlid", szResult, MainPipeline); sqlid = strval(szResult);
		cache_get_field_content(i, "point", szResult, MainPipeline); points = strval(szResult);
		
		// Is the player connected?
		for(new x = 0; x < MAX_PLAYERS; x++)
		{
			if(IsPlayerConnected(x) && PlayerInfo[x][pId] == sqlid)
			{
				format(PublicSQLString, sizeof(PublicSQLString), "%s %s (ID: %d) | Points: %d - Automatically Added\n", PublicSQLString, GetPlayerNameEx(x), x, points);
				break;
			}
		}
	}
	
	ShowPlayerDialog(index, DIALOG_WATCHLIST, DIALOG_STYLE_LIST, "Current Watchlist", PublicSQLString, "Exit", "");
	FetchingWatchlist = 0;
	return true;
}

forward OnSetVMute(playerid);
public OnSetVMute(playerid)
{
	new string[128], tmpName[MAX_PLAYER_NAME];
	GetPVarString(playerid, "OnSetVMute", tmpName, sizeof(tmpName));
	DeletePVar(playerid, "OnSetVMute");
	if(cache_affected_rows(MainPipeline))
	{
		format(string, sizeof(string), "AdmCmd: %s has offline vip muted %s.", GetPlayerNameEx(playerid), tmpName);
		ABroadCast(COLOR_LIGHTRED, string, 3);
	}
	else
	{
		format(string, sizeof(string), "Could not vip mute %s..", tmpName);
		SendClientMessageEx(playerid, COLOR_YELLOW, string);
	}
	return 1;
}

forward OnBugReport(playerid);
public OnBugReport(playerid)
{
	new string[128], bug[41];
	GetPVarString(playerid, "BugSubject", bug, 40);
	format(string, sizeof(string), "[BugID: %d] %s(%d) submitted a%sbug (%s)", mysql_insert_id(MainPipeline), GetPlayerNameEx(playerid), GetPVarInt(playerid, "pSQLID"), GetPVarInt(playerid, "BugAnonymous") == 1 ? (" anonymous "):(" "), bug);
	Log("logs/bugreport.log", string);
	ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX , "Bug Report Submitted", 
	"{FFFFFF}Your bug report has been successfully submitted.\n\
	 We highly suggest adding more information regarding the bug by visiting: http://devcp.ng-gaming.net\n\
	 {FF8000}Note:{FFFFFF} If you are found abusing this system you will be restricted from submitting future bug reports.", "Close", "");
	PlayerInfo[playerid][pBugReportTimeout] = gettime();
	DeletePVar(playerid, "BugStep");
	DeletePVar(playerid, "BugSubject");
	DeletePVar(playerid, "BugDetail");
	DeletePVar(playerid, "BugAnonymous");
	DeletePVar(playerid, "BugListItem");
	return 1;
}

forward CheckClientWatchlist(index);
public CheckClientWatchlist(index)
{
	new rows, fields;
	cache_get_data(rows, fields, MainPipeline);
	if(rows == 0) PlayerInfo[index][pWatchlist] = 0;
	else PlayerInfo[index][pWatchlist] = 1;
	return true;
}

forward CheckBugReportBans(playerid, check);
public CheckBugReportBans(playerid, check)
{
	new rows, fields;
	cache_get_data(rows, fields, MainPipeline);
	if(rows == 0)
	{
		if(check == 1) ShowBugReportMainMenu(playerid);
		if(check == 2)
		{
			SetPVarInt(playerid, "BugStep", 3);
			SetPVarInt(playerid, "BugListItem", 2);
			ShowPlayerDialog(playerid, DIALOG_BUGREPORT, DIALOG_STYLE_LIST, "Bug Report - Submit Anonymously?", "No\nYes", "Continue", "Close");
		}
	}
	else
	{
		if(check == 1) ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Bug Report - {FF0000}Error", "You are restricted from submitting bug reports.\nContact the Director of Development for more information.", "Close", "");
		if(check == 2) ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Bug Report - {FF0000}Error", "You are restricted from submitting anonymous bug reports.\nContact the Director of Development for more information.", "Close", ""); 
	}
	return 1;
}

forward WatchWatchlist(index);
public WatchWatchlist(index)
{
	new rows, fields, result;
	cache_get_data(rows, fields, MainPipeline);
	#pragma unused fields
	for(new i = 0; i < rows; i++)
	{
		new szResult[32], sqlid;
		cache_get_field_content(i, "sqlid", szResult, MainPipeline); sqlid = strval(szResult);
		
		for(new x = 0; x < MAX_PLAYERS; x++)
		{
			// Is the player connected, does the SQLId matches the player & is he not being spectated?
			if(IsPlayerConnected(x) && PlayerInfo[x][pId] == sqlid && gPlayerLogged{x} == 1 && PlayerInfo[x][pJailTime] == 0 && GetPVarInt(x, "BeingSpectated") == 0)
			{
				SpectatePlayer(index, x);
				SetPVarInt(x, "BeingSpectated", 1);
				SendClientMessageEx(index, -1, "WATCHDOG: You have started watching, you may skip to another player in 3 minutes (/nextwatch).");
				SetPVarInt(index, "NextWatch", gettime()+180);
				SetPVarInt(index, "SpectatingWatch", x);
				SetPVarInt(index, "StartedWatching", 1);
				result = 1;
				break;
			}
		}
		if(result) break;
	}
	if(result == 0) 
	{
		SendClientMessageEx(index, COLOR_GRAD1, "No-one is available to spectate!, ");
	}
	return true;
}

forward CheckPendingBugReports(playerid);
public CheckPendingBugReports(playerid)
{
	new rows, fields;
	cache_get_data(rows, fields, MainPipeline);
	if(rows == 0) return 1;
	new string[256], szResult[41];
	format(string, sizeof(string), "{BFC0C2}You have {4A8BC2}%d{BFC0C2} bug report(s) pending your response.", rows);
	strcat(string, "\nPlease follow up with the bug reports listed below and provide as many details as you can.\n{4A8BC2}BugID\tBug{BFC0C2}");
	for(new i = 0; i < rows; i++)
	{
		cache_get_field_content(i, "id", szResult, MainPipeline);
		format(string, sizeof(string), "%s\n%s\t", string, szResult);
		cache_get_field_content(i, "Bug", szResult, MainPipeline);
		format(string, sizeof(string), "%s%s", string, szResult);
	}
	return ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Bug Reports Pending Response - {4A8BC2}http://devcp.ng-gaming.net", string, "Close", "");
}