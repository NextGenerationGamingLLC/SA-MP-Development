/*
    	 		 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
				| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
				| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
				| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
				| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
				| $$\  $$$| $$  \ $$        | $$  \ $$| $$
				| $$ \  $$|  $$$$$$/        | $$  | $$| $$
				|__/  \__/ \______/         |__/  |__/|__/

//--------------------------------[FUNCTIONS.PWN]--------------------------------


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

			/*  ---------------- FUNCTIONS ----------------- */
			
#if defined zombiemode

Float:GetPointDistanceToPoint(Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2)
{
  new Float:x, Float:y, Float:z;
  x = x1-x2;
  y = y1-y2;
  z = z1-z2;
  return floatsqroot(x*x+y*y+z*z);
}
#endif

CheckPointCheck(iTargetID)  {
	if(GetPVarType(iTargetID, "hFind") > 0 || GetPVarType(iTargetID, "TrackCar") > 0 || GetPVarType(iTargetID, "DV_TrackCar") > 0 || GetPVarType(iTargetID, "Packages") > 0 || TaxiAccepted[iTargetID] != INVALID_PLAYER_ID || EMSAccepted[iTargetID] != INVALID_PLAYER_ID || BusAccepted[iTargetID] != INVALID_PLAYER_ID || gPlayerCheckpointStatus[iTargetID] != CHECKPOINT_NONE || MedicAccepted[iTargetID] != INVALID_PLAYER_ID || MechanicCallTime[iTargetID] >= 1) {
		return 1;
	}
	if(GetPVarType(iTargetID, "TrackVehicleBurglary") > 0 || GetPVarType(iTargetID, "DeliveringVehicleTime") > 0 || GetPVarType(iTargetID, "pDTest") > 0) 
		return 1;
	return 0;
}

IsNumeric(szInput[]) {

	new
		iChar,
		i = 0;

	while ((iChar = szInput[i++])) if (!('0' <= iChar <= '9')) return 0;
	return 1;
}

ReturnUser(text[]) {

	new
		strPos,
		returnID = 0,
		bool: isnum = true;
	
	if(!strlen(text)) return INVALID_PLAYER_ID;
	
	while(text[strPos]) {
		if(isnum) {
			if ('0' <= text[strPos] <= '9') returnID = (returnID * 10) + (text[strPos] - '0');
			else isnum = false;
		}
		strPos++;
	}
	if (isnum) {
		if(IsPlayerConnected(returnID)) return returnID;
	}
	else {

		new
			sz_playerName[MAX_PLAYER_NAME];

		foreach(new i: Player)
		{
			GetPlayerName(i, sz_playerName, MAX_PLAYER_NAME);
			if(!strcmp(sz_playerName, text, true, strPos)) return i;
		}	
	}
	return INVALID_PLAYER_ID;
}

MainMenuUpdateForPlayer(playerid)
{
	new string[156];

	if(InsideMainMenu{playerid} == 1 || InsideTut{playerid} == 1)
	{
		format(string, sizeof(string), "~y~MOTD~w~: %s", GlobalMOTD);
		TextDrawSetString(MainMenuTxtdraw[9], string);
	}
}

TimeConvert(time) {
	new jhour;
    new jmin;
	new jdiv;
    new jsec;
    new string[128];
	if(time > 3599){
		jhour = floatround(time / (60*60));
		jdiv = floatround(time % (60*60));
        jmin = floatround(jdiv / 60, floatround_floor);
        jsec = floatround(jdiv % 60, floatround_ceil);
        format(string,sizeof(string),"%02d:%02d:%02d",jhour,jmin,jsec);
    }
    else if(time > 59 && time < 3600){
        jmin = floatround(time/60);
        jsec = floatround(time - jmin*60);
        format(string,sizeof(string),"%02d:%02d",jmin,jsec);
    }
    else{
        jsec = floatround(time);
        format(string,sizeof(string),"%02d seconds",jsec);
    }
    return string;
}

/*
Float:GetPointDistanceToPoint(Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2)
{
  new Float:x, Float:y, Float:z;
  x = x1-x2;
  y = y1-y2;
  z = z1-z2;
  return floatsqroot(x*x+y*y+z*z);
}

Float:GetPointDistanceToPointEx(Float:x1,Float:y1,Float:x2,Float:y2)
{
  new Float:x, Float:y;
  x = x1-x2;
  y = y1-y2;
  return floatsqroot(x*x+y*y);
} */

RemovePlayerWeapon(playerid, weaponid)
{
	ResetPlayerWeapons(playerid);
	PlayerInfo[playerid][pGuns][GetWeaponSlot(weaponid)] = 0;
	SetPlayerWeaponsEx(playerid);
	return 1;
}

IsPlayerInRangeOfVehicle(playerid, vehicleid, Float: radius) {

	new
		Float:Floats[3];

	GetVehiclePos(vehicleid, Floats[0], Floats[1], Floats[2]);
	return IsPlayerInRangeOfPoint(playerid, radius, Floats[0], Floats[1], Floats[2]);
}

ini_GetValue(szParse[], szValueName[], szDest[], iDestLen) { // brian!!1

	new
		iPos = strfind(szParse, "=", false),
		iLength = strlen(szParse);

	while(iLength-- && szParse[iLength] <= ' ') {
		szParse[iLength] = 0;
	}

	if(strcmp(szParse, szValueName, false, iPos) == 0) {
		strmid(szDest, szParse, iPos + 1, iLength + 1, iDestLen);
		return 1;
	}
	return 0;
}

SetPlayerPosObjectOffset(objectid, playerid, Float:offset_x, Float:offset_y, Float:offset_z)
{
	new Float:object_px,
        Float:object_py,
        Float:object_pz,
        Float:object_rx,
        Float:object_ry,
        Float:object_rz;

    GetDynamicObjectPos(objectid, object_px, object_py, object_pz);
    GetDynamicObjectRot(objectid, object_rx, object_ry, object_rz);

    printf("%f, %f, %f, %f, %f, %f", object_px, object_py, object_pz, object_rx, object_ry, object_rz);

    new Float:cos_x = floatcos(object_rx, degrees),
        Float:cos_y = floatcos(object_ry, degrees),
        Float:cos_z = floatcos(object_rz, degrees),
        Float:sin_x = floatsin(object_rx, degrees),
        Float:sin_y = floatsin(object_ry, degrees),
        Float:sin_z = floatsin(object_rz, degrees);

	new Float:x, Float:y, Float:z;
    x = object_px + offset_x * cos_y * cos_z - offset_x * sin_x * sin_y * sin_z - offset_y * cos_x * sin_z + offset_z * sin_y * cos_z + offset_z * sin_x * cos_y * sin_z;
    y = object_py + offset_x * cos_y * sin_z + offset_x * sin_x * sin_y * cos_z + offset_y * cos_x * cos_z + offset_z * sin_y * sin_z - offset_z * sin_x * cos_y * cos_z;
    z = object_pz - offset_x * cos_x * sin_y + offset_y * sin_x + offset_z * cos_x * cos_y;

	SetPlayerPos(playerid, x, y, z);
}

CameraRadiusSetPos(playerid, Float:x, Float:y, Float:z, Float:degree = 0.0, Float:height = 3.0, Float:radius = 8.0)
{
	new Float:deltaToX = x + radius * floatsin(-degree, degrees);
	new Float:deltaToY = y + radius * floatcos(-degree, degrees);
	new Float:deltaToZ = z + height;

	SetPlayerCameraPos(playerid, deltaToX, deltaToY, deltaToZ);
	SetPlayerCameraLookAt(playerid, x, y, z);
}

GlobalPlaySound(soundid, Float:x, Float:y, Float:z)
{
	for(new i = 0; i < GetMaxPlayers(); i++) {
		if(IsPlayerInRangeOfPoint(i, 25.0, x, y, z)) {
			PlayerPlaySound(i, soundid, x, y, z);
		}
	}
}

PayDay(i) {
	if(!gPlayerLogged{i}) return 1;
	new
		string[128],
		interest,
		pVIPTax,
		year,
		month,
		day;
		
	getdate(year, month, day);	
	
 	if(PlayerInfo[i][pLevel] > 0 && (PlayerInfo[i][pTogReports] == 1 || PlayerInfo[i][pAdmin] < 2)) {
		if(GetPVarType(i, "debtMsg")) {
			if(GetPlayerCash(i) < 0 && PlayerInfo[i][pJailTime] < 1 && !IsACop(i) && PlayerInfo[i][pWantedLevel] < 6) {
				format(string,sizeof(string),"You're in debt $%s - find a way to pay back the money or you might get in trouble!", number_format(GetPlayerCash(i)));
				SendClientMessageEx(i, COLOR_LIGHTRED, string);
			}
			else DeletePVar(i, "debtMsg");
		}

		if(0 <= PlayerInfo[i][pRenting] < sizeof HouseInfo) {
			if(HouseInfo[PlayerInfo[i][pRenting]][hRentFee] > PlayerInfo[i][pAccount]) {
				PlayerInfo[i][pRenting] = INVALID_HOUSE_ID;
				SendClientMessageEx(i, COLOR_WHITE, "You have been evicted from your residence for failing to pay rent fees.");
			}
			else {
				HouseInfo[PlayerInfo[i][pRenting]][hSafeMoney] += HouseInfo[PlayerInfo[i][pRenting]][hRentFee];
				PlayerInfo[i][pAccount] -= HouseInfo[PlayerInfo[i][pRenting]][hRentFee];
			}
		}
		if(PlayerInfo[i][pConnectSeconds] >= 3600) {
			if(GetPVarInt(i, "pBirthday") == 1) {
				PlayerInfo[i][pPayCheck] = PlayerInfo[i][pPayCheck] * 2;
			}
			if(GetPVarType(i, "AdvisorDuty")) {
				PlayerInfo[i][pDutyHours]++;
			}
			if(SpecTimer) AddSpecialToken(i);
			SendClientMessageEx(i, COLOR_WHITE, "________ BANK STATEMENT ________");
			if(PlayerInfo[i][pNation] == 0)
			{
				if(PlayerInfo[i][pDonateRank] < 4)
				{
					format(string, sizeof(string), "  Paycheck: $%s  |  SA Gov Tax: $%s (%d percent)", number_format(PlayerInfo[i][pPayCheck]), number_format((PlayerInfo[i][pPayCheck] / 100) * TaxValue), TaxValue);
					PlayerInfo[i][pAccount] -= (PlayerInfo[i][pPayCheck] / 100) * TaxValue;
					Tax += (PlayerInfo[i][pPayCheck] / 100) * TaxValue;
				}
				else
				{
					pVIPTax = TaxValue - 15;
					if(pVIPTax < 0) { pVIPTax = 0; }
					format(string, sizeof(string), "  Paycheck: $%s  |  SA Gov Tax: $%s (%d percent) {FFFF00}(Platinum VIP: 15 percent off)", number_format(PlayerInfo[i][pPayCheck]), number_format((PlayerInfo[i][pPayCheck] / 100) * pVIPTax), pVIPTax);
					PlayerInfo[i][pAccount] -= (PlayerInfo[i][pPayCheck] / 100) * pVIPTax;
					Tax += (PlayerInfo[i][pPayCheck] / 100) * pVIPTax;
				}
			}
			else if(PlayerInfo[i][pNation] == 1)
			{
				if(PlayerInfo[i][pDonateRank] < 4)
				{
					format(string, sizeof(string), "  Paycheck: $%s  |  TR Gov Tax: $%s (%d percent)", number_format(PlayerInfo[i][pPayCheck]), number_format((PlayerInfo[i][pPayCheck] / 100) * TRTaxValue), TRTaxValue);	
					PlayerInfo[i][pAccount] -= (PlayerInfo[i][pPayCheck] / 100) * TRTaxValue;
					TRTax += (PlayerInfo[i][pPayCheck] / 100) * TRTaxValue;
				}
				else
				{
					pVIPTax = TRTaxValue - 15;
					if(pVIPTax < 0) { pVIPTax = 0; }
					format(string, sizeof(string), "  Paycheck: $%s  |  TR Gov Tax: $%s (%d percent) {FFFF00}(Platinum VIP: 15 percent off)", number_format(PlayerInfo[i][pPayCheck]), number_format((PlayerInfo[i][pPayCheck] / 100) * pVIPTax), pVIPTax);	
					PlayerInfo[i][pAccount] -= (PlayerInfo[i][pPayCheck] / 100) * pVIPTax;
					TRTax += (PlayerInfo[i][pPayCheck] / 100) * pVIPTax;
				}
			}
			SendClientMessageEx(i, COLOR_GRAD1, string);
			interest = (PlayerInfo[i][pAccount] + 1) / 1000;

			switch(PlayerInfo[i][pDonateRank]) {
				case 0: {
					if(interest > 50000) interest = 50000;
					format(string, sizeof(string), "  Balance: $%s  |  Interest rate: 0.1 percent (50k max)", number_format(PlayerInfo[i][pAccount]));
					SendClientMessageEx(i, COLOR_GRAD1, string);
				}
				case 1: {
					if(interest > 100000) interest = 100000;
					format(string, sizeof(string), "  Balance: $%s  |  Interest rate: 0.1 percent {FFFF00}(Bronze VIP: 100k max)", number_format(PlayerInfo[i][pAccount]));
					SendClientMessageEx(i, COLOR_GRAD1, string);
				}
				case 2:	{
					if(interest > 150000) interest = 150000;
					format(string, sizeof(string), "  Balance: $%s  |  Interest rate: 0.1 percent {FFFF00}(Silver VIP: 150k max)", number_format(PlayerInfo[i][pAccount]));
					SendClientMessageEx(i, COLOR_GRAD1, string);
				}
				case 3: {
					if(interest > 200000) interest = 200000;
					format(string, sizeof(string), "  Balance: $%s  |  Interest rate: 0.1 percent {FFFF00}(Gold VIP: 200k max)", number_format(PlayerInfo[i][pAccount]));
					SendClientMessageEx(i, COLOR_GRAD1, string);
				}
				case 4, 5: {
					if(interest > 250000) interest = 250000;
					format(string, sizeof(string), "  Balance: $%s  |  Interest rate: 0.1 percent {FFFF00}(Platinum VIP: 250k max)", number_format(PlayerInfo[i][pAccount]));
					SendClientMessageEx(i, COLOR_GRAD1, string);
				}
			}
			if(PlayerInfo[i][pTaxiLicense] == 1) {
				PlayerInfo[i][pAccount] -= (PlayerInfo[i][pPayCheck] / 100) * 5;
				Tax += (PlayerInfo[i][pPayCheck] / 100) * 5;
				format(string, sizeof(string), "  Taxi licensing fee (5 percent): $%s", number_format((PlayerInfo[i][pPayCheck] / 100) * 5));
				SendClientMessageEx(i, COLOR_GRAD2, string);
			}
			for(new iGroupID; iGroupID < MAX_GROUPS; iGroupID++)
			{
				if(PlayerInfo[i][pNation] == 0)
				{
					if(arrGroupData[iGroupID][g_iAllegiance] == 1)
					{
						if(arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_GOV)
						{
							new str[128], file[32];
							format(str, sizeof(str), "%s has paid $%s in tax.", GetPlayerNameEx(i), number_format((PlayerInfo[i][pPayCheck] / 100) * TaxValue));
							format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", iGroupID, month, day, year);
							Log(file, str);
						}
					}
				}
				else if (PlayerInfo[i][pNation] == 1)
				{
					if(arrGroupData[iGroupID][g_iAllegiance] == 2)
					{
						if(arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_GOV)
						{
							new str[128], file[32];
							format(str, sizeof(str), "%s has paid $%s in tax.", GetPlayerNameEx(i), number_format((PlayerInfo[i][pPayCheck] / 100) * TaxValue));
							format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", iGroupID, month, day, year);
							Log(file, str);
						}
					}
				}
			}
			PlayerInfo[i][pAccount] += interest;
			format(string, sizeof(string), "  Interest gained: $%s", number_format(interest));
			SendClientMessageEx(i, COLOR_GRAD3, string);
			SendClientMessageEx(i, COLOR_GRAD4, "______________________________________");
			format(string, sizeof(string), "  New balance: $%s  |  Rent paid: $%s", number_format(PlayerInfo[i][pAccount]), number_format((0 <= PlayerInfo[i][pRenting] < sizeof HouseInfo) ? (HouseInfo[PlayerInfo[i][pRenting]][hRentFee]) : (0)));
			SendClientMessageEx(i, COLOR_GRAD5, string);

			GivePlayerCash(i, PlayerInfo[i][pPayCheck]);
			
			/*if(month == 12 && day == 5)
			{
				if(++PlayerInfo[i][pFallIntoFun] == 5)
				{
					if(PlayerInfo[i][pReceivedPrize] == 0)
					{
						PlayerInfo[i][pGVIPExVoucher] += 1;
						SendClientMessageEx(i, COLOR_LIGHTBLUE, "You have received a 7 day Gold VIP voucher for playing 5 hours.");
						PlayerInfo[i][pReceivedPrize] = 1;
					}
					PlayerInfo[i][pFallIntoFun] = 0;
				}
			}*/
			
			// Fall Into Fun - 100 HP every 5 paychecks
			/*PlayerInfo[i][pFallIntoFun]++;
			
			if(PlayerInfo[i][pFallIntoFun] == 5)
			{	
				new Float: health;
				GetHealth(i, health);
				
				if(health == 100)
				{
					PlayerInfo[i][pFirstaid]++;
					SendClientMessageEx(i, COLOR_LIGHTBLUE, "You have played for 5 hours and received a firstaid kit due to having 100 percent health already.");
					PlayerInfo[i][pFallIntoFun] = 0;
				}
				else 
				{
					SetHealth(i, 100.0);
					SendClientMessageEx(i, COLOR_LIGHTBLUE, "You have played for 5 hours and received 100 percent HP.");
					PlayerInfo[i][pFallIntoFun] = 0;
				}
			}*/
			new
				iGroupID = PlayerInfo[i][pMember],
				iRank = PlayerInfo[i][pRank];
			
			if((0 <= iGroupID < MAX_GROUPS) && 0 <= iRank <= 9 && arrGroupData[iGroupID][g_iPaycheck][iRank] > 0) { // added for sanews to get their own paychecks from their vaults.
				
				
				if(arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_NEWS)
				{
					if(arrGroupData[iGroupID][g_iBudget] > 0) {
						arrGroupData[iGroupID][g_iBudget] -= arrGroupData[iGroupID][g_iPaycheck][iRank];
						GivePlayerCash(i, arrGroupData[iGroupID][g_iPaycheck][iRank]);
						format(string,sizeof(string),"  Company pay: $%s", number_format(arrGroupData[iGroupID][g_iPaycheck][iRank]));
						SendClientMessageEx(i, COLOR_GRAD2, string);
						
						new str[128], file[32];
						format(str, sizeof(str), "%s has been paid $%s in company pay.", GetPlayerNameEx(i), number_format(arrGroupData[iGroupID][g_iPaycheck][iRank]));
						format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", iGroupID, month, day, year);
						Log(file, str);
					}
					else SendClientMessageEx(i, COLOR_RED, "The SA government is in debt; no money is available for pay.");
				}
				
				else if(arrGroupData[iGroupID][g_iAllegiance] == 1 && arrGroupData[iGroupID][g_iGroupType] != 4)
				{
					if(Tax > 0) {
						Tax -= arrGroupData[iGroupID][g_iPaycheck][iRank];
						GivePlayerCash(i, arrGroupData[iGroupID][g_iPaycheck][iRank]);
						format(string,sizeof(string),"  SA Government pay: $%s", number_format(arrGroupData[iGroupID][g_iPaycheck][iRank]));
						SendClientMessageEx(i, COLOR_GRAD2, string);
						for(new z; z < MAX_GROUPS; z++)
						{
							if(arrGroupData[z][g_iAllegiance] == 1)
							{
								if(arrGroupData[z][g_iGroupType] == GROUP_TYPE_GOV)
								{
									new str[128], file[32];
									format(str, sizeof(str), "%s has been paid $%s in government pay.", GetPlayerNameEx(i), number_format(arrGroupData[iGroupID][g_iPaycheck][iRank]));
									format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", z, month, day, year);
									Log(file, str);
									break;
								}
							}
						}	
					}
					else SendClientMessageEx(i, COLOR_RED, "The SA government is in debt; no money is available for pay.");
				}
				else if(arrGroupData[iGroupID][g_iAllegiance] == 2 && arrGroupData[iGroupID][g_iGroupType] != 4)
				{
					if(TRTax > 0) {
						TRTax -= arrGroupData[iGroupID][g_iPaycheck][iRank];
						GivePlayerCash(i, arrGroupData[iGroupID][g_iPaycheck][iRank]);
						format(string,sizeof(string),"  TR Government pay: $%s", number_format(arrGroupData[iGroupID][g_iPaycheck][iRank]));
						SendClientMessageEx(i, COLOR_GRAD2, string);
						for(new z; z < MAX_GROUPS; z++)
						{
							if(arrGroupData[z][g_iAllegiance] == 2)
							{
								if(arrGroupData[z][g_iGroupType] == GROUP_TYPE_GOV)
								{
									new str[128], file[32];
									format(str, sizeof(str), "%s has been paid $%s in government pay.", GetPlayerNameEx(i), number_format(arrGroupData[iGroupID][g_iPaycheck][iRank]));
									format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", z, month, day, year);
									Log(file, str);
									break;
								}
							}
						}
					}
					else SendClientMessageEx(i, COLOR_RED, "The TR government is in debt; no money is available for pay.");
				}
			}
   			if (PlayerInfo[i][pBusiness] != INVALID_BUSINESS_ID) {
				if (Businesses[PlayerInfo[i][pBusiness]][bAutoPay] && PlayerInfo[i][pBusinessRank] >= 0 && PlayerInfo[i][pBusinessRank] < 5) {
				    if (Businesses[PlayerInfo[i][pBusiness]][bSafeBalance] < Businesses[PlayerInfo[i][pBusiness]][bRankPay][PlayerInfo[i][pBusinessRank]]) {
				    	SendClientMessageEx(i,COLOR_RED,"Business doesn't have enough cash for your pay.");
				    }
					else {
						GivePlayerCash(i, Businesses[PlayerInfo[i][pBusiness]][bRankPay][PlayerInfo[i][pBusinessRank]]);
						Businesses[PlayerInfo[i][pBusiness]][bSafeBalance] -= Businesses[PlayerInfo[i][pBusiness]][bRankPay][PlayerInfo[i][pBusinessRank]];
						SaveBusiness(PlayerInfo[i][pBusiness]);
						format(string,sizeof(string),"  Business pay: $%s", number_format(Businesses[PlayerInfo[i][pBusiness]][bRankPay][PlayerInfo[i][pBusinessRank]]));
						SendClientMessageEx(i, COLOR_GRAD2, string);
					}
				}
			}
			
			GameTextForPlayer(i, "~y~PayDay~n~~w~Paycheck", 5000, 1);
			//SendAudioToPlayer(i, 63, 100);
			PlayerInfo[i][pConnectSeconds] = 0;
			PlayerInfo[i][pPayCheck] = 0;
			if(++PlayerInfo[i][pConnectHours] == 2) {
				SendClientMessageEx(i, COLOR_LIGHTRED, "You may now possess/use weapons!");
			}
			if(PlayerInfo[i][pDonateRank] > 0 && ++PlayerInfo[i][pPayDayHad] >= 5) {
				PlayerInfo[i][pExp]++;
				PlayerInfo[i][pPayDayHad] = 0;
			}
			
			// Zombie Halloween
			if(month == 10 && day == 30)
			{
				if(PlayerInfo[i][pFallIntoFun] < 4)
				{
					PlayerInfo[i][pFallIntoFun]++;
				}
				else {
					 PlayerInfo[i][pFallIntoFun] = 0;
					 PlayerInfo[i][pVials] += 1;
				}
			}	

			if((month == 12 && day == 24) || (month == 10 && day == 31))
			{
				if(PlayerInfo[i][pTrickortreat] > 0)
				{
					PlayerInfo[i][pTrickortreat]--;
				}
			}

			//Weekday Madness for Fall Into Fun event; re-using Trickortreat variable to check connected time
			/*if(month == 10 && (day == 9 || day == 16))
			{
				PlayerInfo[i][pRewardDrawChance] += 2;
			}
			else if(month == 10 && day == 19)
			{
				PlayerInfo[i][pRewardDrawChance] += 3;
			}
			else PlayerInfo[i][pRewardDrawChance]++;
			
			if(PlayerInfo[i][pDonateRank] >= 3 && month == 10 && day == 13)
			{
				PlayerInfo[i][pRewardDrawChance] += 3;
			}*/
			Misc_Save();
			if(iRewardPlay) {
				PlayerInfo[i][pRewardHours]++;
				if(floatround(PlayerInfo[i][pRewardHours]) % 16 == 0) {
					PlayerInfo[i][pGoldBoxTokens]++;
					SendClientMessage(i, COLOR_LIGHTBLUE, "You have received 1 Gold Giftbox token!  #FallIntoFun");
				}
				format(string, sizeof(string), "You currently have %d Reward Hours, please check /rewards for more information.", floatround(PlayerInfo[i][pRewardHours]));
				SendClientMessageEx(i, COLOR_YELLOW, string);
			}

			if(PlayerInfo[i][pDoubleEXP] > 0) {
				PlayerInfo[i][pDoubleEXP]--;
				format(string, sizeof(string), "You have gained 2 respect points instead of 1. You have %d hours left on the Double EXP token.", PlayerInfo[i][pDoubleEXP]);
				SendClientMessageEx(i, COLOR_YELLOW, string);
				PlayerInfo[i][pExp] += 2;
			}
			else PlayerInfo[i][pExp]++;

			if(GetPVarInt(i, "pBirthday") == 1) {
				SendClientMessageEx(i, COLOR_YELLOW, "Gold VIP: You have received x2 paycheck as a birthday gift!");
			}
			
			if(PlayerInfo[i][pWRestricted] > 0 && --PlayerInfo[i][pWRestricted] == 0) {
				SendClientMessageEx(i, COLOR_LIGHTRED, "Your weapons are no longer restricted!");
			}
			
			if(PlayerInfo[i][pShopNotice] > 0) PlayerInfo[i][pShopNotice]--;
			if(ShopReminder == 1 && PlayerInfo[i][pShopNotice] == 0)
			{
				PlayerInfo[i][pShopCounter]++;
				PlayerInfo[i][mShopCounter]++;
				if(PlayerInfo[i][pLevel] <= 5 && PlayerInfo[i][mShopCounter] == 3 || (PlayerInfo[i][pLevel] > 5 && PlayerInfo[i][mShopCounter] >= 4 && PlayerInfo[i][pCredits] >= 10))
				{
					PlayerTextDrawSetString(i, MicroNotice[i], ShopMsg[PlayerInfo[i][mNotice]]);
					PlayerTextDrawShow(i, MicroNotice[i]);
					SetTimerEx("HidePlayerTextDraw", 10000, false, "ii", i, _:MicroNotice[i]);
					if(++PlayerInfo[i][mNotice] > 3) PlayerInfo[i][mNotice] = 0;
					PlayerInfo[i][mShopCounter] = 0;
				}
				if(PlayerInfo[i][pLevel] <= 5 && PlayerInfo[i][pShopCounter] == 5 || PlayerInfo[i][pLevel] > 5 && PlayerInfo[i][pShopCounter] == 10)
				{
					format(string, sizeof(string), "Hey check this out, type: ~y~/nggshop");
					if(PlayerInfo[i][pConnectHours] >= 50)
					{
						strcat(string, "~w~~n~To disable this notice for 24 hours, type: ~y~/togshopnotice");
					}
					PlayerInfo[i][pShopCounter] = 0;
					PlayerTextDrawSetString(i, ShopNotice[i], string);
					PlayerTextDrawShow(i, ShopNotice[i]);
					SetTimerEx("HidePlayerTextDraw", 10000, false, "ii", i, _:ShopNotice[i]);
				}
			}
			if(FIFEnabled == 1)
			{
				FIFInfo[i][FIFHours] += 1;
				if((FIFInfo[i][FIFHours] % 3) == 0)
				{
					if(FIFGThurs == 1)
					{
						GThursChances += 1;
						if(GThursChances == 23)
						{
							PlayerInfo[i][pGVIPVoucher] += 1;
							SendClientMessageEx(i, COLOR_WHITE, "You have won a 1 Month Gold VIP Voucher for Fall Into Fun! To claim it, type /myvouchers.");
							GThursChances = 0;
							format(string, sizeof(string), "%s(%d) won a 1 Month GVIP Voucher", GetPlayerNameEx(i), GetPlayerSQLId(i));
							Log("logs/fif.log", string);
						}
					}
					if(FIFGP3 == 1 && PlayerInfo[i][pDonateRank] >= 3)
					{
						FIFInfo[i][FIFChances] += 3;
						format(string,sizeof(string), "You have earned 3 FIF Chance's! You now have %d chances!", FIFInfo[i][FIFChances]);
						SendClientMessageEx(i, COLOR_WHITE, string);
						format(string, sizeof(string), "%s(%d) won 3 FIF Chances", GetPlayerNameEx(i), GetPlayerSQLId(i));
						Log("logs/fif.log", string);
					}
					else
					{
						switch(FIFType)
						{
							case 1:
							{
								FIFInfo[i][FIFChances] += 1;
								format(string,sizeof(string), "You have earned 1 FIF Chance! You now have %d chances!", FIFInfo[i][FIFChances]);
								SendClientMessageEx(i, COLOR_WHITE, string);
								format(string, sizeof(string), "%s(%d) won 1 FIF Chance.", GetPlayerNameEx(i), GetPlayerSQLId(i));
								Log("logs/fif.log", string);
							}
							case 2:
							{
								FIFInfo[i][FIFChances] += 2;
								format(string,sizeof(string), "You have earned 2 FIF Chance's! You now have %d chances!", FIFInfo[i][FIFChances]);
								SendClientMessageEx(i, COLOR_WHITE, string);
								format(string, sizeof(string), "%s(%d) won 2 FIF Chances.", GetPlayerNameEx(i), GetPlayerSQLId(i));
								Log("logs/fif.log", string);
							}
							case 3:
							{
								FIFInfo[i][FIFChances] += 3;
								format(string,sizeof(string), "You have earned 3 FIF Chance's! You now have %d chances!", FIFInfo[i][FIFChances]);
								SendClientMessageEx(i, COLOR_WHITE, string);
								format(string, sizeof(string), "%s(%d) won 3 FIF Chances.", GetPlayerNameEx(i), GetPlayerSQLId(i));
								Log("logs/fif.log", string);
							}
						}
					}
				}
				if(FIFTimeWarrior == 1)
				{
					if(FIFInfo[i][FIFHours] % 32 == 0)
					{
						PlayerInfo[i][pGoldBoxTokens] += 1;
						SendClientMessageEx(i, COLOR_WHITE, "You have won a Gold Box Token for Fall Into Fun! To claim it, type /getrewardgift.");
						format(string, sizeof(string), "%s(%d) won a Gold Box Token", GetPlayerNameEx(i), GetPlayerSQLId(i));
						Log("logs/fif.log", string);
					}
				}
				g_mysql_SaveFIF(i);
			}
		}
		else SendClientMessageEx(i, COLOR_LIGHTRED, "* You haven't played long enough to obtain a paycheck.");
	}

	if (GetPVarType(i, "UnreadMails") && HasMailbox(i))
	{
		SendClientMessageEx(i, COLOR_YELLOW, "You have unread items in your mailbox");
	}
	return 1;
}

CreateGate(gateid) {
	if(IsValidDynamicObject(GateInfo[gateid][gGATE])) DestroyDynamicObject(GateInfo[gateid][gGATE]);
	if(GateInfo[gateid][gPosX] == 0.0) return 1;
	switch(GateInfo[gateid][gRenderHQ]) {
		case 1: GateInfo[gateid][gGATE] = CreateDynamicObject(GateInfo[gateid][gModel], GateInfo[gateid][gPosX], GateInfo[gateid][gPosY], GateInfo[gateid][gPosZ], GateInfo[gateid][gRotX], GateInfo[gateid][gRotY], GateInfo[gateid][gRotZ], GateInfo[gateid][gVW], GateInfo[gateid][gInt], -1, 100.0);
		case 2: GateInfo[gateid][gGATE] = CreateDynamicObject(GateInfo[gateid][gModel], GateInfo[gateid][gPosX], GateInfo[gateid][gPosY], GateInfo[gateid][gPosZ], GateInfo[gateid][gRotX], GateInfo[gateid][gRotY], GateInfo[gateid][gRotZ], GateInfo[gateid][gVW], GateInfo[gateid][gInt], -1, 150.0);
		case 3: GateInfo[gateid][gGATE] = CreateDynamicObject(GateInfo[gateid][gModel], GateInfo[gateid][gPosX], GateInfo[gateid][gPosY], GateInfo[gateid][gPosZ], GateInfo[gateid][gRotX], GateInfo[gateid][gRotY], GateInfo[gateid][gRotZ], GateInfo[gateid][gVW], GateInfo[gateid][gInt], -1, 200.0);
		default: GateInfo[gateid][gGATE] = CreateDynamicObject(GateInfo[gateid][gModel], GateInfo[gateid][gPosX], GateInfo[gateid][gPosY], GateInfo[gateid][gPosZ], GateInfo[gateid][gRotX], GateInfo[gateid][gRotY], GateInfo[gateid][gRotZ], GateInfo[gateid][gVW], GateInfo[gateid][gInt], -1, 60.0);
	}
	return 1;
}

AntiDeAMX()
{
    new a[][] = {
        "Unarmed (Fist)",
        "Brass K"
    };
    #pragma unused a
}

/*
RemoveCharmPoint()
{
	if (ActiveCharmPoint == -1)
		return;

	if (IsValidDynamicPickup(ActiveCharmPointPickup))
	{
		DestroyDynamicPickup(ActiveCharmPointPickup);
		ActiveCharmPointPickup = -1;
	}

	if (IsValidDynamic3DTextLabel(ActiveCharmPoint3DText))
	{
		DestroyDynamic3DTextLabel(ActiveCharmPoint3DText);
	}

	// DON'T RESET ActiveCharmPoint
	// IT IS USED TO MAKE SURE NO POINT IS PICKED TWICE!
}

SelectCharmPoint()
{
	new rand = random(sizeof(CharmPoints));

	while (rand == ActiveCharmPoint) // force new point
	{
		rand = random(sizeof(CharmPoints));
	}

	if (ActiveCharmPoint != -1)
	{
		if (IsValidDynamicPickup(ActiveCharmPointPickup))
		{
			DestroyDynamicPickup(ActiveCharmPointPickup);
			ActiveCharmPointPickup = -1;
		}

		if (IsValidDynamic3DTextLabel(ActiveCharmPoint3DText))
		{
			DestroyDynamic3DTextLabel(ActiveCharmPoint3DText);
		}
	}

	new vw = 0, int = 0;

	switch (rand)
	{
		case 0:
		{
			vw = 123051;
			int = 1;
		}

		case 1:
		{
			vw = 100078;
			int = 17;
		}

		case 2:
		{
			vw = 2345;
			int = 1;
		}

		case 3:
		{
			vw = 100084;
			int = 1;
		}

		case 4:
		{
			vw = 20083;
			int = 11;
		}
	}

	ActiveCharmPointPickup = CreateDynamicPickup(1318, 23, CharmPoints[rand][0], CharmPoints[rand][1], CharmPoints[rand][2], .worldid = vw, .interiorid = int);
	ActiveCharmPoint3DText = CreateDynamic3DTextLabel("Collect your Lucky Charm tokens!\n/claimtokens", 0x37A621FF, CharmPoints[rand][0], CharmPoints[rand][1], CharmPoints[rand][2] + 1.0, 100.0, .worldid = vw, .interiorid = int);
	ActiveCharmPoint = rand;
} */

ProxDetector(Float: f_Radius, playerid, string[],col1,col2,col3,col4,col5,chat=0)
{
	if(WatchingTV[playerid] != 1) {

		new
			Float: f_playerPos[3];

		GetPlayerPos(playerid, f_playerPos[0], f_playerPos[1], f_playerPos[2]);
		new str[128];
		foreach(new i: Player)
		{
			if((InsidePlane[playerid] == GetPlayerVehicleID(i) && GetPlayerState(i) == 2) || (InsidePlane[i] == GetPlayerVehicleID(playerid) && GetPlayerState(playerid) == 2) || (InsidePlane[playerid] != INVALID_VEHICLE_ID && InsidePlane[playerid] == InsidePlane[i])) {
				SendClientMessageEx(i, col1, string);
			}
			else if(GetPlayerVirtualWorld(i) == GetPlayerVirtualWorld(playerid)) {
				if(chat && IsPlayerInRangeOfPoint(i, f_Radius * 0.6, f_playerPos[0], f_playerPos[1], f_playerPos[2]) && PlayerInfo[i][pBugged] >= 0 && PlayerInfo[playerid][pAdmin] < 2 && PlayerInfo[i][pAdmin] < 2)
				{
					if(playerid == i)
					{
						format(str, sizeof(str), "{8D8DFF}(BUGGED) {CBCCCE}%s", string);
					}
					else {
						format(str, sizeof(str), "{8D8DFF}(BUG ID %d) {CBCCCE}%s", i,string);
					}
					SendBugMessage(PlayerInfo[i][pBugged], str);
				}

				if(IsPlayerInRangeOfPoint(i, f_Radius / 16, f_playerPos[0], f_playerPos[1], f_playerPos[2])) {
					SendClientMessageEx(i, col1, string);
				}
				else if(IsPlayerInRangeOfPoint(i, f_Radius / 8, f_playerPos[0], f_playerPos[1], f_playerPos[2])) {
					SendClientMessageEx(i, col2, string);
				}
				else if(IsPlayerInRangeOfPoint(i, f_Radius / 4, f_playerPos[0], f_playerPos[1], f_playerPos[2])) {
					SendClientMessageEx(i, col3, string);
				}
				else if(IsPlayerInRangeOfPoint(i, f_Radius / 2, f_playerPos[0], f_playerPos[1], f_playerPos[2])) {
					SendClientMessageEx(i, col4, string);
				}
				else if(IsPlayerInRangeOfPoint(i, f_Radius, f_playerPos[0], f_playerPos[1], f_playerPos[2])) {
					SendClientMessageEx(i, col5, string);
				}
			}
			if(GetPVarInt(i, "BigEar") == 1 || GetPVarInt(i, "BigEar") == 6 && GetPVarInt(i, "BigEarPlayer") == playerid) {
				new string2[128] = "(BE) ";
				strcat(string2,string, sizeof(string2));
				SendClientMessageEx(i, col1,string);
			}
		}	
	}
	return 1;
}

ProxDetectorS(Float:radi, playerid, targetid)
{
	if(WatchingTV[playerid] != 1)
	{
	    if(Spectating[targetid] != 0 && PlayerInfo[playerid][pAdmin] < 2)
	    {
	    	return 0;
	    }

		new
			Float: fp_playerPos[3];

		GetPlayerPos(targetid, fp_playerPos[0], fp_playerPos[1], fp_playerPos[2]);

		if(IsPlayerInRangeOfPoint(playerid, radi, fp_playerPos[0], fp_playerPos[1], fp_playerPos[2]) && GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(targetid))
		{
			return 1;
		}
	}
	return 0;
}

ProxDetectorWrap(playerid, string[], width, Float:wrap_radius, col1, col2, col3, col4, col5)
{
	if(strlen(string) > width)
	{
		new firstline[128], secondline[128];
		strmid(firstline, string, 0, 88);
		strmid(secondline, string, 88, 150);
		format(firstline, sizeof(firstline), "%s...", firstline);
		format(secondline, sizeof(secondline), "...%s", secondline);
		ProxDetector(wrap_radius, playerid, firstline, col1, col2, col3, col4, col5);
		ProxDetector(wrap_radius, playerid, secondline, col1, col2, col3, col4, col5);
	}
	else ProxDetector(wrap_radius, playerid, string, col1, col2, col3, col4, col5);
}

GetXYInFrontOfPlayer(playerid, &Float:x, &Float:y, Float:distance)
{
    new Float:a;
    GetPlayerPos(playerid, x, y, a);
    GetPlayerFacingAngle(playerid, a);
    if (GetPlayerVehicleID(playerid))
    {
      GetVehicleZAngle(GetPlayerVehicleID(playerid), a);
    }
    x += (distance * floatsin(-a, degrees));
    y += (distance * floatcos(-a, degrees));
}

GetXYBehindPlayer(playerid, &Float:x, &Float:y, Float:distance)
{
    new Float:a;
    GetPlayerPos(playerid, x, y, a);
    GetPlayerFacingAngle(playerid, a);
    if (GetPlayerVehicleID(playerid))
    {
      GetVehicleZAngle(GetPlayerVehicleID(playerid), a);
    }
    x += (distance * floatsin(-a+180, degrees));
    y += (distance * floatcos(-a+180, degrees));
}

/*GetXYInFrontOfVehicle(playerid, &Float:x, &Float:y, Float:distance)
{
    new Float:a;
    GetVehiclePos(playerid, x, y, a);
    GetVehicleZAngle(playerid, a);
    x += (distance * floatsin(-a, degrees));
    y += (distance * floatcos(-a, degrees));
}*/

IsInRangeOfPoint(Float: fPosX, Float: fPosY, Float: fPosZ, Float: fPosX2, Float: fPosY2, Float: fPosZ2, Float: fDist) {
    fPosX -= fPosX2;
	fPosY -= fPosY2;
    fPosZ -= fPosZ2;
    return ((fPosX * fPosX) + (fPosY * fPosY) + (fPosZ * fPosZ)) < (fDist * fDist);
}

/*PreloadAnimLib(playerid, animlib[])
{
	ApplyAnimation(playerid,animlib,"null",0.0,0,0,0,0,0,1);
}*/

IsValidName(iPlayer) {

	new
		iLength,
		szPlayerName[MAX_PLAYER_NAME], tmpName[MAX_PLAYER_NAME],
		invalids;

	GetPlayerName(iPlayer, szPlayerName, sizeof(szPlayerName));

	mysql_escape_string(szPlayerName, tmpName);
	if(strcmp(szPlayerName, tmpName, false) != 0)
	{
		return 0;
	}
	iLength = strlen(szPlayerName);

	if(strfind(szPlayerName, "_", false) == -1 || szPlayerName[iLength - 1] == '_' || szPlayerName[0] == '_') return 0;
	else if(szPlayerName[0] == '.' || szPlayerName[0] == '_') return 0;
	else for(new i; i < iLength; ++i) {
		if(!('a' <= szPlayerName[i] <= 'z' || 'A' <= szPlayerName[i] <= 'Z' 
			|| szPlayerName[i] == '_') && szPlayerName[i] != '.') return 0;
		if(szPlayerName[i] == 'I' && i == 0) continue;
		if(szPlayerName[i] == '_' && szPlayerName[i+1] == '.') invalids++;
		if(szPlayerName[i] == 'I' && szPlayerName[i-1] != '_') invalids++;
		if(invalids > 0) return 0;
	}
	return 1;
}

GetPlayerPriority(Player)
{
	if(PlayerInfo[Player][pDonateRank] >= 4 || PlayerInfo[Player][pRewardHours] > 150) return 2;
	else if(PlayerInfo[Player][pAdmin] >= 1 || PlayerInfo[Player][pHelper] >= 2) return 3;
	else return 4;
}

IsPlayerInRangeOfDynamicObject(iPlayerID, iObjectID, Float: fRadius) {

	new
		Float: fPos[3];

	GetDynamicObjectPos(iObjectID, fPos[0], fPos[1], fPos[2]);
	return IsPlayerInRangeOfPoint(iPlayerID, fRadius, fPos[0], fPos[1], fPos[2]);
}

Array_Count(arrCount[], iMax = sizeof arrCount) {

	new
		iCount,
		iPos;

	while(iPos < iMax) if(arrCount[iPos++]) ++iCount;
	return iCount;
}

String_Count(arrCount[][], iMax = sizeof arrCount) {

	new
		iCount,
		iPos;

	while(iPos < iMax) if(arrCount[iPos++][0]) ++iCount;
	return iCount;
}

LoadEventPoints() {

	if(!fexist("eventpoints.cfg"))
		return 1;

	new
		szFileStr[256],
		File: fHandle = fopen("eventpoints.cfg", io_read),
		iIndex;

	while(iIndex < MAX_EVENTPOINTS && fread(fHandle, szFileStr)) {
		if(!sscanf(szFileStr, "p<|>fffiis[64]i",
			EventPoints[iIndex][epPosX],
			EventPoints[iIndex][epPosY],
			EventPoints[iIndex][epPosZ],
			EventPoints[iIndex][epVW],
			EventPoints[iIndex][epInt],
			EventPoints[iIndex][epPrize],
			EventPoints[iIndex][epFlagable]
		) && EventPoints[iIndex][epPosX] != 0.0) {
			EventPoints[iIndex][epObjectID] = CreateDynamicPickup(1274, 1, EventPoints[iIndex][epPosX], EventPoints[iIndex][epPosY], EventPoints[iIndex][epPosZ], EventPoints[iIndex][epVW]);
			format(szFileStr,sizeof(szFileStr),"Event Point (ID: %d)\nPrize: %s\nType /claimpoint to claim your prize!", iIndex, EventPoints[iIndex][epPrize]);
			EventPoints[iIndex][epText3dID] = CreateDynamic3DTextLabel(szFileStr, COLOR_YELLOW, EventPoints[iIndex][epPosX], EventPoints[iIndex][epPosY], EventPoints[iIndex][epPosZ]+0.5, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, EventPoints[iIndex][epVW], EventPoints[iIndex][epInt]);
			++iIndex;
		}
	}
	printf("[LoadEventPoints] %i event points loaded.", iIndex);
	return fclose(fHandle);
}

			/*  ---------------- PUBLIC FUNCTIONS -----------------  */
			
			
forward OnPlayerModelSelection(playerid, response, listid, modelid);
forward OnPlayerModelSelectionEx(playerid, response, extraid, modelid, extralist_id);
//forward strfind(const string[],const sub[],bool:ignorecase=false,pos=0);

forward HideReportText(playerid);
public HideReportText(playerid)
{
    TextDrawHideForPlayer(playerid, PriorityReport[playerid]);
    return 1;
}

forward Countdown(playerid);
public Countdown(playerid)
{
	if(PlayerInfo[playerid][pAdmin] >= 3 && PlayerInfo[playerid][pTogReports] == 0) {
	    if(CountDown == 0) {
	 		CountDown++;
	 		SendClientMessageToAll(COLOR_LIGHTBLUE, "** 3");
	 		SetTimerEx("Countdown", 1000, false, "i", playerid);
		} else if(CountDown == 1) {
		    CountDown++;
		    SendClientMessageToAll(COLOR_LIGHTBLUE, "** 2");
		    SetTimerEx("Countdown", 1000, false, "i", playerid);
		} else if(CountDown == 2) {
		    CountDown++;
		    SendClientMessageToAll(COLOR_LIGHTBLUE, "** 1");
		    SetTimerEx("Countdown", 1000, false, "i", playerid);
		} else if(CountDown == 3) {
		    CountDown = 0;
		    SendClientMessageToAll(COLOR_LIGHTBLUE, "** Go Go Go!");
		}
	}
	else if(IsARacer(playerid)){
	    if(CountDown == 0) {
	 		CountDown++;
			ProxDetector(30.0, playerid, "** [Racer Countdown] 3 **", 0xEB41000, 0xEB41000, 0xEB41000, 0xEB41000, 0xEB41000);
			SetTimerEx("Countdown", 1000, false, "i", playerid);
		} else if(CountDown == 1) {
		    CountDown++;
		    ProxDetector(30.0, playerid, "** [Racer Countdown] 2 **", 0xEB41000, 0xEB41000, 0xEB41000, 0xEB41000, 0xEB41000);
		    SetTimerEx("Countdown", 1000, false, "i", playerid);
		} else if(CountDown == 2) {
		    CountDown++;
		    ProxDetector(30.0, playerid, "** [Racer Countdown] 1 **", 0xEB41000, 0xEB41000, 0xEB41000, 0xEB41000, 0xEB41000);
		    SetTimerEx("Countdown", 1000, false, "i", playerid);
		} else if(CountDown == 3) {
		    CountDown = 0;
		    ProxDetector(30.0, playerid, "** [Racer Countdown] Go Go Go! **", 0xEB41000, 0xEB41000, 0xEB41000, 0xEB41000, 0xEB41000);
		}
	}
	else if(IsARacer(playerid) && PlayerInfo[playerid][pTogReports] == 1) {
	    if(CountDown == 0) {
	 		CountDown++;
			ProxDetector(30.0, playerid, "** [Racer Countdown] 3 **", 0xEB41000, 0xEB41000, 0xEB41000, 0xEB41000, 0xEB41000);
			SetTimerEx("Countdown", 1000, false, "i", playerid);
		} else if(CountDown == 1) {
		    CountDown++;
		    ProxDetector(30.0, playerid, "** [Racer Countdown] 2 **", 0xEB41000, 0xEB41000, 0xEB41000, 0xEB41000, 0xEB41000);
		    SetTimerEx("Countdown", 1000, false, "i", playerid);
		} else if(CountDown == 2) {
		    CountDown++;
		    ProxDetector(30.0, playerid, "** [Racer Countdown] 1 **", 0xEB41000, 0xEB41000, 0xEB41000, 0xEB41000, 0xEB41000);
		    SetTimerEx("Countdown", 1000, false, "i", playerid);
		} else if(CountDown == 3) {
		    CountDown = 0;
		    ProxDetector(30.0, playerid, "** [Racer Countdown] Go Go Go! **", 0xEB41000, 0xEB41000, 0xEB41000, 0xEB41000, 0xEB41000);
		}
	}
	return 1;
}

forward sobeitCheck(playerid);
public sobeitCheck(playerid)
{
	if(GetPVarInt(playerid, "JailDelay") == 0)
	{
	    if(PlayerInfo[playerid][pJailTime] > 0)
		{
	        SetTimerEx("sobeitCheck", 1000, 0, "i", playerid);
	        SetPVarInt(playerid, "JailDelay", 1);
	        return 1;
	    }
	}

	DeletePVar(playerid, "JailDelay");
    if(IsPlayerFrozen[playerid] == 1)
	{
        new Float:hX, Float:hY, Float:hZ, Float:pX, Float:pY, Float:pZ, Float:cX, Float:cY, Float:cZ, Float:cX1, Float:cY1, Float:cZ1;
        GetPlayerCameraFrontVector(playerid, cX1, cY1, cZ1);
		GetPlayerPos(playerid, cX, cY, cZ);
        hX = GetPVarFloat(playerid, "FrontVectorX");
        hY = GetPVarFloat(playerid, "FrontVectorY");
        hZ = GetPVarFloat(playerid, "FrontVectorZ");
        pX = GetPVarFloat(playerid, "PlayerPositionX");
        pY = GetPVarFloat(playerid, "PlayerPositionY");
        pZ = GetPVarFloat(playerid, "PlayerPositionZ");

        if(pX != cX && pY != cY && pZ != cZ && hX != cX1 && hY != cY1 && hZ != cZ1)
        {
            SendClientMessageEx(playerid, COLOR_RED, "You have failed the player account check, please relog and try again!");
            IsPlayerFrozen[playerid] = 0;
            DeletePVar(playerid,"FrontVectorX");
            DeletePVar(playerid,"FrontVectorY");
            DeletePVar(playerid,"FrontVectorZ");
            DeletePVar(playerid,"PlayerPositionX");
            DeletePVar(playerid,"PlayerPositionY");
            DeletePVar(playerid,"PlayerPositionZ");
            SetTimerEx("KickEx", 1000, 0, "i", playerid);
            return 1;
        }
	}

	new Float:aX, Float:aY, Float:aZ, szString[128];
	GetPlayerCameraFrontVector(playerid, aX, aY, aZ);
	#pragma unused aX
	#pragma unused aY

	if(aZ < -0.7)
	{
		new IP[32];
		GetPlayerIp(playerid, IP, sizeof(IP));
		TogglePlayerControllable(playerid, true);

	 	if(PlayerInfo[playerid][pSMod] == 1 || PlayerInfo[playerid][pAdmin] == 1)
 		{
 		    format(szString, sizeof(szString), "SELECT `Username` FROM `accounts` WHERE `AdminLevel` > 1 AND `Disabled` = 0 AND `IP` = '%s'", GetPlayerIpEx(playerid));
 		    mysql_function_query(MainPipeline, szString, true, "CheckAccounts", "i", playerid);
       	}
		else {
		    format(szString, sizeof(szString), "INSERT INTO `sobeitkicks` (sqlID, Kicks) VALUES (%d, 1) ON DUPLICATE KEY UPDATE Kicks = Kicks + 1", GetPlayerSQLId(playerid));
			mysql_function_query(MainPipeline, szString, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);

			SendClientMessageEx(playerid, COLOR_RED, "The hacking tool 's0beit' is not allowed on this server, please uninstall it.");
   			format(szString, sizeof(szString), "%s(%d) (IP: %s) has logged into the server with s0beit installed.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), IP);
   			Log("logs/sobeit.log", szString);
   			IsPlayerFrozen[playerid] = 0;
    		SetTimerEx("KickEx", 1000, 0, "i", playerid);
     	}

	}
	
	if(playerTabbed[playerid] > 2) { SendClientMessageEx(playerid, COLOR_RED, "You have failed the account check, please relog."), SetTimerEx("KickEx", 1000, 0, "i", playerid); }

	if(PlayerInfo[playerid][pVW] > 0 || PlayerInfo[playerid][pInt] > 0) HideNoticeGUIFrame(playerid);
	sobeitCheckvar[playerid] = 1;
	sobeitCheckIsDone[playerid] = 1;
	IsPlayerFrozen[playerid] = 0;
	TogglePlayerControllable(playerid, true);
 	return 1;
}

forward killPlayer(playerid);
public killPlayer(playerid)
{
	new query[128];
	if(GetPVarInt(playerid, "commitSuicide") == 1) 
	{
		format(query, sizeof(query), "INSERT INTO `kills` (`id`, `killerid`, `killedid`, `date`, `weapon`) VALUES (NULL, %d, %d, NOW(), '/kill')", GetPlayerSQLId(playerid), GetPlayerSQLId(playerid));
		mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
		SetPVarInt(playerid, "commitSuicide", 0);
		SetHealth(playerid, 0);
	}
	else
		return SendClientMessageEx(playerid, COLOR_RED, "You have taken damage during the 10 seconds, therefore you couldn't commit suicide.");
	return 1;
}

forward DisableVehicleAlarm(vehicleid);
public DisableVehicleAlarm(vehicleid)
{
	new engine,lights,alarm,doors,bonnet,boot,objective;
 	GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
    SetVehicleParamsEx(vehicleid,engine,lights,VEHICLE_PARAMS_OFF,doors,bonnet,boot,objective);
	return 1;
}

forward ReleasePlayer(playerid);
public ReleasePlayer(playerid)
{
	DeletePVar(playerid, "IsFrozen");
	if(PlayerCuffed[playerid] == 0)
	{
		TogglePlayerControllable(playerid,1);
	}
}

forward ControlCam(playerid);
public ControlCam(playerid)
{
    new Float:X, Float:Y, Float:Z;
	GetDynamicObjectPos(Carrier[0], X, Y, Z);
 	SetPlayerCameraPos(playerid, X-200, Y, Z+40);
  	SetPlayerCameraLookAt(playerid, X, Y, Z);
}

forward IdiotSound(playerid);
public IdiotSound(playerid)
{
    PlayAudioStreamForPlayerEx(playerid, "http://www.ng-gaming.net/users/farva/you-are-an-idiot.mp3");
    ShowPlayerDialog(playerid,DIALOG_NOTHING,DIALOG_STYLE_MSGBOX,"BUSTED!","A 15% CLEO tax has been assessed to your account along with a 3 hour prison - future use could result in a ban","Exit","");
}

forward DynVeh_CreateDVQuery(playerid, model, col1, col2);
public DynVeh_CreateDVQuery(playerid, model, col1, col2)
{
	new
			iFields,
			iRows,
			sqlid,
			szResult[128];

	cache_get_data(iRows, iFields, MainPipeline);
	cache_get_field_content(0, "id", szResult, MainPipeline); sqlid = strval(szResult);
	DynVehicleInfo[sqlid][gv_iModel] = model;
	DynVehicleInfo[sqlid][gv_iCol1] = col1;
	DynVehicleInfo[sqlid][gv_iCol2] = col2;
	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(playerid, X, Y, Z);
	DynVehicleInfo[sqlid][gv_iVW] = GetPlayerVirtualWorld(playerid);
	DynVehicleInfo[sqlid][gv_iInt] = GetPlayerInterior(playerid);
	DynVehicleInfo[sqlid][gv_fX] = X+2;
	DynVehicleInfo[sqlid][gv_fY] = Y;
	DynVehicleInfo[sqlid][gv_fZ] = Z;
	DynVehicleInfo[sqlid][gv_igID] = INVALID_GROUP_ID;
	DynVehicleInfo[sqlid][gv_ifID] = 0;
	format(szResult, sizeof(szResult), "%s's DV Creation query has returned - attempting to spawn vehicle - SQL ID %d", GetPlayerNameEx(playerid), sqlid);
	Log("logs/dv.log", szResult);
	DynVeh_Save(sqlid);
	DynVeh_Spawn(sqlid);
	return 1;
}

forward SetCamBack(playerid);
public SetCamBack(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		new Float:plocx,Float:plocy,Float:plocz;
		GetPlayerPos(playerid, plocx, plocy, plocz);
		SetPlayerPos(playerid, -1863.15, -21.6598, 1060.15); // Warp the player
		SetPlayerInterior(playerid,14);
	}
}

forward FixHour(hourt);
public FixHour(hourt)
{
	hourt = timeshift+hourt;
	if (hourt < 0)
	{
		hourt = hourt+24;
	}
	else if (hourt > 23)
	{
		hourt = hourt-24;
	}
	shifthour = hourt;
	return 1;
}

forward HttpCallback_ShopIDCheck(index, response_code, data[]);
public HttpCallback_ShopIDCheck(index, response_code, data[])
{
	new string[128], shopstring[512], shoptechs, confirmed = strval(data);
	PlayerInfo[index][pOrderConfirmed] = confirmed;

	if(response_code == 200)
	{
		foreach(new i: Player)
		{
			if(PlayerInfo[i][pShopTech] > 0)
			{
				shoptechs++;
			}
		}	

		if(shoptechs > 0)
		{
			if(confirmed)
			{
				format(shopstring, sizeof(shopstring), "{FFFFFF}You are now waiting to receive shop order ID: %d (Confirmed)\n\nA shop tech will be with you as soon as possible.\n\nIf you have more than one order then please let the shop tech know once they are with you.\n\nShop Techs Online: %d\n\nNOTE: The shop order remains pending even if you go offline and log back in.", PlayerInfo[index][pOrder], shoptechs);
				ShowPlayerDialog(index, DIALOG_SHOPSENT, DIALOG_STYLE_MSGBOX, "{3399FF}Shop Order", shopstring, "Close", "");

				format(string, sizeof(string), "Shop order ID %d (Confirmed) from %s (ID: %d) is now pending.", PlayerInfo[index][pOrder], GetPlayerNameEx(index), index);
				ShopTechBroadCast(COLOR_SHOP, string);
			}
			else
			{
				format(shopstring, sizeof(shopstring), "{FFFFFF}You are now waiting to receive shop order ID: %d (Invalid)\n\nA shop tech will be with you as soon as possible.\n\nIf you have more than one order then please let the shop tech know once they are with you.\n\nShop Techs Online: %d\n\nNOTE: The shop order remains pending even if you go offline and log back in.", PlayerInfo[index][pOrder], shoptechs);
				ShowPlayerDialog(index, DIALOG_SHOPSENT, DIALOG_STYLE_MSGBOX, "{3399FF}Shop Order", shopstring, "Close", "");

				format(string, sizeof(string), "Shop order ID %d (Invalid) from %s (ID: %d) is now pending.", PlayerInfo[index][pOrder], GetPlayerNameEx(index), index);
				ShopTechBroadCast(COLOR_SHOP, string);
			}
		}
		else
		{
			if(confirmed)
			{
				format(shopstring, sizeof(shopstring), "{FFFFFF}You are now waiting to receive shop order ID: %d (Confirmed)\n\nA shop tech will be with you as soon as possible.\n\nIf you have more than one order then please let the shop tech know once they are with you.\n\nThere are currently no shop techs online, you can resume normal gameplay and a shop tech will be with you when they log on.\n\nNOTE: The shop order remains pending even if you go offline and log back in.", PlayerInfo[index][pOrder]);
				ShowPlayerDialog(index, DIALOG_SHOPSENT, DIALOG_STYLE_MSGBOX, "{3399FF}Shop Order", shopstring, "Close", "");
			}
			else
			{
				format(shopstring, sizeof(shopstring), "{FFFFFF}You are now waiting to receive shop order ID: %d (Invalid)\n\nA shop tech will be with you as soon as possible.\n\nIf you have more than one order then please let the shop tech know once they are with you.\n\nThere are currently no shop techs online, you can resume normal gameplay and a shop tech will be with you when they log on.\n\nNOTE: The shop order remains pending even if you go offline and log back in.", PlayerInfo[index][pOrder]);
				ShowPlayerDialog(index, DIALOG_SHOPSENT, DIALOG_STYLE_MSGBOX, "{3399FF}Shop Order", shopstring, "Close", "");
			}
		}
		new playerip[32];
		GetPlayerIp(index, playerip, sizeof(playerip));
		format(string, sizeof(string), "Shop order ID %d from %s(%d)(IP: %s) is now pending.", PlayerInfo[index][pOrder], GetPlayerNameEx(index), GetPlayerSQLId(index), playerip);
		Log("logs/shoporders.log", string);
	}
	else
	{
		PlayerInfo[index][pOrder] = 0;
		PlayerInfo[index][pOrderConfirmed] = 0;
		ShowPlayerDialog(index, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "{3399FF}Shop Order - Server Connection Error", "{FFFFFF}We are unable to process your order at this time.\n\nPlease try again later.", "Close", "");
	}
}

forward ShowPlayerBeaconForMedics(playerid);
public ShowPlayerBeaconForMedics(playerid)
{
	foreach(new i: Player)
	{
		if(IsAMedic(i))
		{
			SetPlayerMarkerForPlayer(i, playerid, COP_GREEN_COLOR);
		}
	}	
	return 1;
}

forward HidePlayerBeaconForMedics(playerid);
public HidePlayerBeaconForMedics(playerid)
{
	foreach(new i: Player)
	{
		if(IsAMedic(i))
		{
			SetPlayerMarkerForPlayer(i, playerid, TEAM_HIT_COLOR);
		}
	}	
	SetPlayerToTeamColor(playerid);
	return 1;
}

forward MoveEMS(playerid);
public MoveEMS(playerid)
{
    new Float:mX, Float:mY, Float:mZ;
    GetPlayerPos(playerid, mX, mY, mZ);

    SetPVarFloat(GetPVarInt(playerid, "MovingStretcher"), "MedicX", mX);
	SetPVarFloat(GetPVarInt(playerid, "MovingStretcher"), "MedicY", mY);
	SetPVarFloat(GetPVarInt(playerid, "MovingStretcher"), "MedicZ", mZ);
	SetPVarInt(GetPVarInt(playerid, "MovingStretcher"), "MedicVW", GetPlayerVirtualWorld(playerid));
	SetPVarInt(GetPVarInt(playerid, "MovingStretcher"), "MedicInt", GetPlayerInterior(playerid));

	Streamer_UpdateEx(GetPVarInt(playerid, "MovingStretcher"), mX, mY, mZ);
	SetPlayerPos(GetPVarInt(playerid, "MovingStretcher"), mX, mY, mZ);
	SetPlayerInterior(GetPVarInt(playerid, "MovingStretcher"), GetPlayerVirtualWorld(playerid));
	SetPlayerVirtualWorld(GetPVarInt(playerid, "MovingStretcher"), GetPlayerVirtualWorld(playerid));

	ClearAnimations(GetPVarInt(playerid, "MovingStretcher"));
	ApplyAnimation(GetPVarInt(playerid, "MovingStretcher"), "SWAT", "gnstwall_injurd", 4.0, 0, 1, 1, 1, 0, 1);

	DeletePVar(GetPVarInt(playerid, "MovingStretcher"), "OnStretcher");
	SetPVarInt(playerid, "MovingStretcher", -1);
}

forward KillEMSQueue(playerid);
public KillEMSQueue(playerid)
{
    DeletePVar(playerid, "Injured");
    DeletePVar(playerid, "InjuredWait");
    DeletePVar(playerid, "EMSAttempt");
	SetPVarInt(playerid, "MedicBill", 1);
	DeletePVar(playerid, "MedicCall");
	DeletePVar(playerid, "EMSWarns");
	DeletePVar(playerid, "_energybar");
	return 1;
}

forward SendEMSQueue(playerid,type);
public SendEMSQueue(playerid,type)
{
    #if defined zombiemode
	if(zombieevent == 1 && GetPVarType(playerid, "pIsZombie"))
	{
		KillEMSQueue(playerid);
		SpawnPlayer(playerid);
		return 1;
	}
	if(zombieevent == 1 && GetPVarType(playerid, "pZombieBit"))
	{
 		KillEMSQueue(playerid);
		ClearAnimations(playerid);
		MakeZombie(playerid);
		return 1;
	}
	#endif
	switch (type)
	{
		case 1:
		{
		    Streamer_UpdateEx(playerid, GetPVarFloat(playerid,"MedicX"), GetPVarFloat(playerid,"MedicY"), GetPVarFloat(playerid,"MedicZ"));
			SetPlayerPos(playerid, GetPVarFloat(playerid,"MedicX"), GetPVarFloat(playerid,"MedicY"), GetPVarFloat(playerid,"MedicZ"));
			SetPlayerVirtualWorld(playerid, GetPVarInt(playerid,"MedicVW"));
	  		SetPlayerInterior(playerid, GetPVarInt(playerid,"MedicInt"));

			SetPVarInt(playerid, "EMSAttempt", -1);

			if(GetPlayerInterior(playerid) > 0) Player_StreamPrep(playerid, GetPVarFloat(playerid,"MedicX"), GetPVarFloat(playerid,"MedicY"), GetPVarFloat(playerid,"MedicZ"), FREEZE_TIME);
			GameTextForPlayer(playerid, "~r~Injured~n~~w~/accept death or /service ems", 5000, 3);
			ClearAnimations(playerid);
			ApplyAnimation(playerid, "KNIFE", "KILL_Knife_Ped_Die", 4.0, 0, 1, 1, 1, 0, 1);
			SetHealth(playerid, 100);
			RemoveArmor(playerid);
			if(GetPVarInt(playerid, "usingfirstaid") == 1)
			{
			    firstaidexpire(playerid);
			}
			SetPVarInt(playerid,"MedicCall",1);
		}
		case 2:
		{
		    SetPVarInt(playerid,"EMSAttempt", 2);
			ClearAnimations(playerid);
		 	ApplyAnimation(playerid, "SWAT", "gnstwall_injurd", 4.0, 0, 1, 1, 1, 0, 1);
			SetHealth(playerid, 100);
			RemoveArmor(playerid);
		}
	}
	return 1;
}

forward TurnOffFlash(playerid);
public TurnOffFlash(playerid)
{
	PlayerTextDrawHide(playerid, _vhudFlash[playerid]);
	return 1;
}

forward ClearDrugs(playerid);
public ClearDrugs(playerid)
{
	UsedWeed[playerid] = 0;
	UsedCrack[playerid] = 0;
	return 1;
}

forward KickEx(playerid);
public KickEx(playerid)
{
	Kick(playerid);
}

forward SetVehicleEngine(vehicleid, playerid);
public SetVehicleEngine(vehicleid, playerid)
{
	new string[128];
	new engine,lights,alarm,doors,bonnet,boot,objective;
    GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
    if(engine == VEHICLE_PARAMS_ON)
	{
		SetVehicleParamsEx(vehicleid,VEHICLE_PARAMS_OFF,lights,alarm,doors,bonnet,boot,objective);
		SendClientMessageEx(playerid, COLOR_WHITE, "Vehicle engine stopped successfully.");
		arr_Engine{vehicleid} = 0;
	}
    else if(engine == VEHICLE_PARAMS_OFF || engine == VEHICLE_PARAMS_UNSET)
	{
		new
			Float: f_vHealth;

		GetVehicleHealth(vehicleid, f_vHealth);
		if (GetPVarInt(playerid, "Refueling")) return SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this while refueling.");
		if(f_vHealth < 350.0) return SendClientMessageEx(playerid, COLOR_RED, "The car won't start - it's totalled!");
		if(IsRefuelableVehicle(vehicleid) && !IsVIPcar(vehicleid) && !IsAdminSpawnedVehicle(vehicleid) && VehicleFuel[vehicleid] <= 0.0)
		{
			if(!PlayerInfo[playerid][pShopNotice])
			{
				PlayerTextDrawSetString(playerid, MicroNotice[playerid], ShopMsg[7]);
				PlayerTextDrawShow(playerid, MicroNotice[playerid]);
				SetTimerEx("HidePlayerTextDraw", 10000, false, "ii", playerid, _:MicroNotice[playerid]);
			}
			return SendClientMessageEx(playerid, COLOR_RED, "The car won't start - there's no fuel in the tank!");
		}
		SetVehicleParamsEx(vehicleid,VEHICLE_PARAMS_ON,lights,alarm,doors,bonnet,boot,objective);
		if(DynVeh[vehicleid] != -1 && DynVehicleInfo[DynVeh[vehicleid]][gv_iType] == 1 && IsAPlane(vehicleid)) { SendClientMessageEx(playerid, COLOR_WHITE, "Vehicle engine started successfully (/announcetakeoff to turn the engine off)."); }
		else SendClientMessageEx(playerid, COLOR_WHITE, "Vehicle engine started successfully (/car engine to turn the engine off).");
		arr_Engine{vehicleid} = 1;
		if(GetChased[playerid] != INVALID_PLAYER_ID && VehicleBomb{vehicleid} == 1)
		{
			if(PlayerInfo[playerid][pHeadValue] >= 1)
			{
				if (IsAHitman(playerid))
				{
					new Float:boomx, Float:boomy, Float:boomz;
					GetPlayerPos(playerid,boomx, boomy, boomz);
					CreateExplosion(boomx, boomy , boomz, 7, 1);
					VehicleBomb{vehicleid} = 0;
					PlacedVehicleBomb[GetChased[playerid]] = INVALID_VEHICLE_ID;
					new takemoney = PlayerInfo[playerid][pHeadValue];//(PlayerInfo[playerid][pHeadValue] / 4) * 2;
					GivePlayerCash(GetChased[playerid], takemoney);
					GivePlayerCash(playerid, -takemoney);
					format(string,sizeof(string),"Hitman %s has fulfilled the contract on %s and collected $%d.",GetPlayerNameEx(GetChased[playerid]),GetPlayerNameEx(playerid),takemoney);
					SendGroupMessage(2, COLOR_YELLOW, string);
					format(string,sizeof(string),"You have been critically injured by a hitman and lost $%d!",takemoney);
					ResetPlayerWeaponsEx(playerid);
					// SpawnPlayer(playerid);
					SendClientMessageEx(playerid, COLOR_YELLOW, string);
					PlayerInfo[playerid][pHeadValue] = 0;
					PlayerInfo[GetChased[playerid]][pCHits] += 1;
					SetHealth(playerid, 0.0);
					// KillEMSQueue(playerid);
					GoChase[GetChased[playerid]] = INVALID_PLAYER_ID;
					PlayerInfo[GetChased[playerid]][pC4Used] = 0;
					PlayerInfo[GetChased[playerid]][pC4] = 0;
					GotHit[playerid] = 0;
					GetChased[playerid] = INVALID_PLAYER_ID;
					return 1;
				}
			}
		}
	}
	return 1;
}

forward SurfingFix(playerid, Float:x, Float:y, Float:z);
public SurfingFix(playerid, Float:x, Float:y, Float:z)
{
	SetPlayerPos(playerid, x, y, z);
	return 1;
}

/*forward IslandThreatElim();
public IslandThreatElim()
{
	MoveDynamicObject(IslandGate, -1083.90002441,4289.70019531,14.10000038, 2);
    IslandGateStatus = 0;
    foreach(new i: Player)
	{
		if(IsPlayerInRangeOfPoint(i, 500, -1083.90002441,4289.70019531,7.59999990))
		{
			SendClientMessageEx(i, COLOR_YELLOW, "** MEGAPHONE ** INTRUDER THREAT ELIMINATED!! ");
			StopAudioStreamForPlayer(i);
		}
	}	
	return 1;
}*/

forward firstaid5(playerid);
public firstaid5(playerid)
{
	if(GetPVarInt(playerid, "usingfirstaid") == 1)
	{
		new Float:health;
		GetHealth(playerid, health);
		if(health < 100.0)
		{
			if((health+5.0) <= 100.0)
			{
 				SetHealth(playerid, health+5.0);
			}
		}
	}
}
forward firstaidexpire(playerid);
public firstaidexpire(playerid)
{
	SendClientMessageEx(playerid, COLOR_GRAD1, "Your first aid kit no longer takes effect.");
	KillTimer(GetPVarInt(playerid, "firstaid5"));
	SetPVarInt(playerid, "usingfirstaid", 0);
	foreach(new i: Player)
	{
		if(PlayerInfo[i][pAdmin] >= 2 && GetPVarType(i, "_dCheck") && GetPVarInt(i, "_dCheck") == playerid)
		{
			SendClientMessageEx(i, COLOR_ORANGE, "Note{ffffff}: First Aid effect has expired on the person you are damage checking.");
		}
	}	
}
forward rccam(playerid);
public rccam(playerid)
{
	DestroyVehicle(GetPVarInt(playerid, "rcveh"));
 	SetPlayerPos(playerid, GetPVarFloat(playerid, "rcX"), GetPVarFloat(playerid, "rcY"), GetPVarFloat(playerid, "rcZ"));
  	SendClientMessageEx(playerid, COLOR_GRAD1, "Your RC Cam has ran out of batteries!");
   	SetPVarInt(playerid, "rccam", 0);
}
forward cameraexpire(playerid);
public cameraexpire(playerid)
{
	SetPVarInt(playerid, "cameraactive", 0);
 	SetCameraBehindPlayer(playerid);
 	if(GetPVarInt(playerid, "camerasc") == 1)
 	{
	 	SetPlayerPos(playerid, GetPVarFloat(playerid, "cameraX2"), GetPVarFloat(playerid, "cameraY2"), GetPVarFloat(playerid, "cameraZ2"));
	  	SetPlayerVirtualWorld(playerid, GetPVarInt(playerid, "cameravw2"));
	  	SetPlayerInterior(playerid, GetPVarInt(playerid, "cameraint2"));
	}
 	TogglePlayerControllable(playerid,1);
  	DestroyDynamic3DTextLabel(Camera3D[playerid]);
   	SendClientMessageEx(playerid, COLOR_GRAD1, "Your camera ran out of batteries!");
}

forward split(const strsrc[], strdest[][], delimiter);
public split(const strsrc[], strdest[][], delimiter)
{
	new i, li;
	new aNum;
	new len;
	while(i <= strlen(strsrc)){
	    if(strsrc[i]==delimiter || i==strlen(strsrc)){
	        len = strmid(strdest[aNum], strsrc, li, i, 128);
	        strdest[aNum][len] = 0;
	        li = i+1;
	        aNum++;
		}
		i++;
	}
	return 1;
}

forward KickNonRP(playerid);
public KickNonRP(playerid)
{
	new name[MAX_PLAYER_NAME];
	GetPVarString(playerid, "KickNonRP", name, sizeof(name));
	if(strcmp(GetPlayerNameEx(playerid), name) == 0)
	{
	    SendClientMessage(playerid, COLOR_WHITE, "You have been kicked for failing to connect with a role play name (i.e. John_Smith).");
		SetTimerEx("KickEx", 1000, 0, "i", playerid);
	}
}

forward RotateWheel();
public RotateWheel()
{
    UpdateWheelTarget();

    new Float:fModifyWheelZPos = 0.0;
    if(gWheelTransAlternate) fModifyWheelZPos = 0.05;

    MoveObject( gFerrisWheel, gFerrisOrigin[0], gFerrisOrigin[1], gFerrisOrigin[2]+fModifyWheelZPos,
				0.01, 0.0, gCurrentTargetYAngle, -270.0 );
}

forward SetPlayerFree(playerid,declare,reason[]);
public SetPlayerFree(playerid,declare,reason[])
{
	if(IsPlayerConnected(playerid))
	{
		ClearCrimes(playerid, declare);
		new string[128];
		foreach(new i: Player)
		{
			if(IsACop(i))
			{
				format(string, sizeof(string), "HQ: All units, officer %s has completed their assignment.", GetPlayerNameEx(declare));
				SendClientMessageEx(i, COLOR_DBLUE, string);
				format(string, sizeof(string), "HQ: %s has been processed, %s.", GetPlayerNameEx(playerid), reason);
				SendClientMessageEx(i, COLOR_DBLUE, string);
			}
		}	
	}
}

forward OtherTimerEx(playerid, type);
public OtherTimerEx(playerid, type)
{
	switch(type) {
		case TYPE_TPMATRUNTIMER:
		{
			if(GetPVarInt(playerid, "tpMatRunTimer") > 0)
			{
				SetPVarInt(playerid, "tpMatRunTimer", GetPVarInt(playerid, "tpMatRunTimer")-1);
				SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_TPMATRUNTIMER);
			}
		}
		case TYPE_TPDRUGRUNTIMER:
		{
			if(GetPVarInt(playerid, "tpDrugRunTimer") > 0)
			{
				SetPVarInt(playerid, "tpDrugRunTimer", GetPVarInt(playerid, "tpDrugRunTimer")-1);
				SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_TPDRUGRUNTIMER);
			}
		}
		case TYPE_TPTRUCKRUNTIMER:
		{
			if(GetPVarInt(playerid, "tpTruckRunTimer") > 0)
			{
				SetPVarInt(playerid, "tpTruckRunTimer", GetPVarInt(playerid, "tpTruckRunTimer")-1);
				SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_TPTRUCKRUNTIMER);
			}
		}
		case TYPE_ARMSTIMER:
		{
			if(GetPVarInt(playerid, "ArmsTimer") > 0)
			{
				SetPVarInt(playerid, "ArmsTimer", GetPVarInt(playerid, "ArmsTimer")-1);
				SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_ARMSTIMER);
			}
		}
		case TYPE_GUARDTIMER:
		{
			if(GetPVarInt(playerid, "GuardTimer") > 0)
			{
				SetPVarInt(playerid, "GuardTimer", GetPVarInt(playerid, "GuardTimer")-1);
				SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GUARDTIMER);
			}
		}
		case TYPE_GIVEWEAPONTIMER:
		{
			if(GetPVarInt(playerid, "GiveWeaponTimer") > 0)
			{
				SetPVarInt(playerid, "GiveWeaponTimer", GetPVarInt(playerid, "GiveWeaponTimer")-1);
				SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_GIVEWEAPONTIMER);
			}
		}
		case TYPE_SHOPORDERTIMER:
		{
			if(GetPVarInt(playerid, "ShopOrderTimer") > 0)
			{
				SetPVarInt(playerid, "ShopOrderTimer", GetPVarInt(playerid, "ShopOrderTimer")-1);
				SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_SHOPORDERTIMER);
			}
		}
		case TYPE_SELLMATSTIMER:
		{
			if(GetPVarInt(playerid, "SellMatsTimer") > 0)
			{
				SetPVarInt(playerid, "SellMatsTimer", GetPVarInt(playerid, "SellMatsTimer")-1);
				SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_SELLMATSTIMER);
			}
		}
		case TYPE_HOSPITALTIMER:
		{
			if(GetPVarInt(playerid, "HospitalTimer") > 0)
			{
				new Float:curhealth;
				GetHealth(playerid, curhealth);
				SetPVarInt(playerid, "HospitalTimer", GetPVarInt(playerid, "HospitalTimer")-1);
				SetHealth(playerid, curhealth+1);
				SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_HOSPITALTIMER);
				if(GetPVarInt(playerid, "HospitalTimer") == 0)
				{
					//HospitalSpawn(playerid);
				}
			}
		}
		case TYPE_FLOODPROTECTION:
		{
			if( CommandSpamUnmute[playerid] >= 1)
			{
				CommandSpamUnmute[playerid]--;
				SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_FLOODPROTECTION);
			}
			if( TextSpamUnmute[playerid] >= 1)
			{
				TextSpamUnmute[playerid]--;
				SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_FLOODPROTECTION);
			}
		}
		case TYPE_HEALTIMER:
		{
			if( GetPVarInt(playerid, "TriageTimer") >= 1)
			{
				SetPVarInt(playerid, "TriageTimer", GetPVarInt(playerid, "TriageTimer")-1);
				SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_HEALTIMER);
			}
		}
		case TYPE_TPPIZZARUNTIMER:
		{
			if(GetPVarInt(playerid, "tpPizzaTimer") > 0 && GetPVarInt(playerid, "Pizza"))
			{
				SetPVarInt(playerid, "tpPizzaTimer", GetPVarInt(playerid, "tpPizzaTimer")-1);
				SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_TPPIZZARUNTIMER);
			}
		}
		case TYPE_PIZZATIMER:
		{
			if(GetPVarType(playerid, "pizzaTimer") && GetPVarInt(playerid, "pizzaTimer") == 0)
			{
				SendClientMessageEx(playerid, COLOR_WHITE, "You failed to deliver the pizza to the house before it got cold!");
				DeletePVar(playerid, "Pizza");
				DeletePVar(playerid, "pizzaTimer");
				DisablePlayerCheckpoint(playerid);
			}
			else if (GetPVarInt(playerid, "Pizza") == 0)
			{
				DeletePVar(playerid, "Pizza");
				DeletePVar(playerid, "pizzaTimer");
				DisablePlayerCheckpoint(playerid);
			}
			else if (GetPVarInt(playerid, "pizzaTimer") > 0 && GetPVarInt(playerid, "Pizza") > 0)
			{
				SetPVarInt(playerid, "pizzaTimer", GetPVarInt(playerid, "pizzaTimer")-1);
				new string[128];
				format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~%d seconds left", GetPVarInt(playerid, "pizzaTimer"));
				GameTextForPlayer(playerid, string, 1100, 3);
				SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_PIZZATIMER);
			}
		}
		case TYPE_CRATETIMER:
		{
			if(GetPVarInt(playerid, "tpForkliftTimer") > 0)
			{
			    if(IsPlayerInVehicle(playerid, GetPVarInt(playerid, "tpForkliftID")))
			    {
				    new Float: pX = GetPVarFloat(playerid, "tpForkliftX"), Float: pY = GetPVarFloat(playerid, "tpForkliftY"), Float: pZ = GetPVarFloat(playerid, "tpForkliftZ");
				    if(GetPlayerDistanceFromPoint(playerid, pX, pY, pZ) > 500)
				    {
				        if(GetPVarInt(playerid, "tpJustEntered") == 0)
				        {
				        	new string[128];
							format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s may be TP hacking with a crate/forklift.", GetPlayerNameEx(playerid));
							ABroadCast(COLOR_YELLOW, string, 2);
							SetPVarInt(playerid, "tpForkliftTimer", GetPVarInt(playerid, "tpForkliftTimer")+15);
						}
						else
						{
						    DeletePVar(playerid, "tpJustEntered");
						}
				    }
					GetPlayerPos(playerid, pX, pY, pZ);
					SetPVarFloat(playerid, "tpForkliftX", pX);
			 		SetPVarFloat(playerid, "tpForkliftY", pY);
			  		SetPVarFloat(playerid, "tpForkliftZ", pZ);
					SetPVarInt(playerid, "tpForkliftTimer", GetPVarInt(playerid, "tpForkliftTimer")-1);
					SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_CRATETIMER);
					if(GetPVarInt(playerid, "tpForkliftTimer") == 0)
					{
					    DeletePVar(playerid, "tpForkliftTimer");
					    DeletePVar(playerid, "tpForkliftID");
					    DeletePVar(playerid, "tpForkliftX");
					    DeletePVar(playerid, "tpForkliftY");
					    DeletePVar(playerid, "tpForkliftZ");
					}
				}
				else
				{
				    DeletePVar(playerid, "tpForkliftTimer");
				    DeletePVar(playerid, "tpForkliftID");
				    DeletePVar(playerid, "tpForkliftX");
				    DeletePVar(playerid, "tpForkliftY");
				    DeletePVar(playerid, "tpForkliftZ");
				}
			}
		}
		case TYPE_DELIVERVEHICLE: 
		{
			if(GetPVarType(playerid, "tpDeliverVehTimer") > 0 && GetPVarType(playerid, "DeliveringVehicleTime") > 0)
			{
				new Float: pX = GetPVarFloat(playerid, "tpDeliverVehX"), Float: pY = GetPVarFloat(playerid, "tpDeliverVehY"), Float: pZ = GetPVarFloat(playerid, "tpDeliverVehZ");
				if(GetPlayerDistanceFromPoint(playerid, pX, pY, pZ) > 500)
				{
					if(GetPVarType(playerid, "tpJustEntered") == 0)
					{
						new string[128];
						format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s(%d) may be TP hacking while delivering a lock picked vehicle.", GetPlayerNameEx(playerid), playerid);
						ABroadCast(COLOR_YELLOW, string, 2);
						SetPVarInt(playerid, "tpDeliverVehTimer", GetPVarInt(playerid, "tpDeliverVehTimer")+15);
					}
					else
					{
						DeletePVar(playerid, "tpJustEntered");
					}
				}
				GetPlayerPos(playerid, pX, pY, pZ);
				SetPVarFloat(playerid, "tpDeliverVehX", pX);
				SetPVarFloat(playerid, "tpDeliverVehY", pY);
				SetPVarFloat(playerid, "tpDeliverVehZ", pZ);
				SetPVarInt(playerid, "tpDeliverVehTimer", GetPVarInt(playerid, "tpDeliverVehTimer")-1);
				SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_DELIVERVEHICLE);
				if(GetPVarInt(playerid, "tpDeliverVehTimer") == 0)
				{
					DeletePVar(playerid, "tpDeliverVehTimer");
					DeletePVar(playerid, "tpDeliverVehX");
					DeletePVar(playerid, "tpDeliverVehY");
					DeletePVar(playerid, "tpDeliverVehZ");
				}
			}
			else
			{
				DeletePVar(playerid, "tpDeliverVehTimer");
				DeletePVar(playerid, "tpDeliverVehX");
				DeletePVar(playerid, "tpDeliverVehY");
				DeletePVar(playerid, "tpDeliverVehZ");
			}
		}
	}
}

forward Player_StreamPrep(iPlayer, Float: fPosX, Float: fPosY, Float: fPosZ, iTime);
public Player_StreamPrep(iPlayer, Float: fPosX, Float: fPosY, Float: fPosZ, iTime) {
    if(sobeitCheckvar[iPlayer] == 0)
	{
		if(sobeitCheckIsDone[iPlayer] == 0)
		{
   			if(PlayerInfo[iPlayer][pAdmin] < 2)
   			{
   			    ShowNoticeGUIFrame(iPlayer, 4);
		    	sobeitCheckIsDone[iPlayer] = 1;
   				SetTimerEx("sobeitCheck", 10000, 0, "i", iPlayer);
				TogglePlayerControllable(iPlayer, false);
				return 1;
			}
		}
	}
	switch(GetPVarInt(iPlayer, "StreamPrep")) {
		case 0: {

			ShowNoticeGUIFrame(iPlayer, 4);
			TogglePlayerControllable(iPlayer, false);
			//GameTextForPlayer(iPlayer, "~w~Collecting position...", iTime * 2, 3);
			SetPVarInt(iPlayer, "StreamPrep", 1);
			SetTimerEx("Player_StreamPrep", iTime / 2, false, "ifffi", iPlayer, fPosX, fPosY, fPosZ, iTime);
		}
		case 1: {

			if(GetPlayerState(iPlayer) == PLAYER_STATE_DRIVER && !GetPVarType(iPlayer, "ShopTP"))
				SetVehiclePos(GetPlayerVehicleID(iPlayer), fPosX, fPosY, fPosZ + 2.0);

			else
				SetPlayerPos(iPlayer, fPosX, fPosY, fPosZ + 0.5);

			//GameTextForPlayer(iPlayer, "~w~Streaming objects...", iTime * 2, 3);
			SetPVarInt(iPlayer, "StreamPrep", 2);
			SetTimerEx("Player_StreamPrep", iTime / 2, false, "ifffi", iPlayer, fPosX, fPosY, fPosZ, iTime);
		}
		default: {
			//GameTextForPlayer(iPlayer, "~r~Loaded!", 1000, 3);
			HideNoticeGUIFrame(iPlayer);
			if(!PlayerInfo[iPlayer][pHospital]) TogglePlayerControllable(iPlayer, true);

			if(GetPlayerState(iPlayer) == PLAYER_STATE_DRIVER && !GetPVarType(iPlayer, "ShopTP"))
				SetVehiclePos(GetPlayerVehicleID(iPlayer), fPosX, fPosY, fPosZ);

			else
				SetPlayerPos(iPlayer, fPosX, fPosY, fPosZ);

			if(GetPVarType(iPlayer, "MedicCall")) {
				ClearAnimations(iPlayer);
				ApplyAnimation(iPlayer, "KNIFE", "KILL_Knife_Ped_Die", 4.0, 0, 1, 1, 1, 0, 1);
			}
			DeletePVar(iPlayer, "StreamPrep");
		}
	}
	SetCameraBehindPlayer(iPlayer);
	Streamer_UpdateEx(iPlayer, fPosX, fPosY, fPosZ);
	return 1;
}

#if defined zombiemode
forward SyncPlayerTime(playerid);
public SyncPlayerTime(playerid)
{
	if(zombieevent == 0) SetPlayerTime(playerid, hour, minuite);
	else SetPlayerTime(playerid, 0, 0);
	return 1;
}

forward SyncMinTime();
public SyncMinTime()
{
	foreach(Player, i)
	{
 		if(GetPlayerVirtualWorld(i) == 133769)
		{
  			SetPlayerWeather(i, 45);
			SetPlayerTime(i, 0, 0);
		}
		else
		{
  			if(zombieevent == 0) SetPlayerTime(i, hour, minuite);
	    	else SetPlayerTime(i, 0, 0);
		}
	}
	return 1;
}
#else
forward SyncPlayerTime(playerid);
public SyncPlayerTime(playerid)
{
	SetPlayerTime(playerid, hour, minuite);
	return 1;
}

forward SyncMinTime();
public SyncMinTime()
{
	foreach(new i: Player)
	{
		if(GetPlayerVirtualWorld(i) == 133769)
		{
			SetPlayerWeather(i, 45);
			SetPlayerTime(i, 0, 0);
		}
		else
		{
			SetPlayerTime(i, hour, minuite);
		}
	}	
	return 1;
}
#endif

forward Disconnect(playerid);
public Disconnect(playerid)
{
	new string[24];
    GetPlayerIp(playerid, unbanip[playerid], 16);
    format(string, sizeof(string),"banip %s", unbanip[playerid]);
	SendRconCommand(string);
	Kick(playerid);
	return 1;
}

forward GetColorCode(clr[]);
public GetColorCode(clr[])
{
	new color = -1;

	if (IsNumeric(clr)) {
		color = strval(clr);
		return color;
	}

	if(strcmp(clr, "black", true)==0) color=0;
	if(strcmp(clr, "white", true)==0) color=1;
	if(strcmp(clr, "blue", true)==0) color=2;
	if(strcmp(clr, "red", true)==0) color=3;
	if(strcmp(clr, "green", true)==0) color=16;
	if(strcmp(clr, "purple", true)==0) color=5;
	if(strcmp(clr, "yellow", true)==0) color=6;
	if(strcmp(clr, "lightblue", true)==0) color=7;
	if(strcmp(clr, "navy", true)==0) color=94;
	if(strcmp(clr, "beige", true)==0) color=102;
	if(strcmp(clr, "darkgreen", true)==0) color=51;
	if(strcmp(clr, "darkblue", true)==0) color=103;
	if(strcmp(clr, "darkgrey", true)==0) color=13;
	if(strcmp(clr, "gold", true)==0) color=99;
	if(strcmp(clr, "brown", true)==0 || strcmp(clr, "dennell", true)==0) color=55;
	if(strcmp(clr, "darkbrown", true)==0) color=84;
	if(strcmp(clr, "darkred", true)==0) color=74;
	if(strcmp(clr, "maroon", true)==0) color=115;
	if(strcmp(clr, "pink", true)==0) color=126;
	return color;
}

forward Maintenance();
public Maintenance()
{
	new string[128];
    ABroadCast(COLOR_YELLOW, "{AA3333}Maintenance{FFFF00}: Freezing Accounts...", 1);

    foreach(new i: Player)
	{
		TogglePlayerControllable(i, false);
	}

    ABroadCast(COLOR_YELLOW, "{AA3333}Maintenance{FFFF00}: Locking Paintball Arenas...", 1);

    for(new i = 0; i < MAX_ARENAS; i++)
    {
		foreach(new p: Player)
		{
			new arenaid = GetPVarInt(p, "IsInArena");
			if(arenaid == i)
			{
				if(PaintBallArena[arenaid][pbBidMoney] > 0)
				{
					GivePlayerCash(p,PaintBallArena[GetPVarInt(p, "IsInArena")][pbBidMoney]);
					format(string,sizeof(string),"You have been refunded a total of $%d because of premature closure.",PaintBallArena[GetPVarInt(p, "IsInArena")][pbBidMoney]);
					SendClientMessageEx(p, COLOR_WHITE, string);
				}
				if(arenaid == GetPVarInt(p, "ArenaNumber"))
				{
					switch(PaintBallArena[arenaid][pbGameType])
					{
						case 1:
						{
							if(PlayerInfo[p][pDonateRank] < 3)
							{
								PlayerInfo[p][pPaintTokens] += 3;
								format(string,sizeof(string),"You have been refunded a total of %d Paintball Tokens because of premature closure.",3);
								SendClientMessageEx(p, COLOR_WHITE, string);
							}
						}
						case 2:
						{
							if(PlayerInfo[p][pDonateRank] < 3)
							{
								PlayerInfo[p][pPaintTokens] += 4;
								format(string,sizeof(string),"You have been refunded a total of %d Paintball Tokens because of premature closure.",4);
								SendClientMessageEx(p, COLOR_WHITE, string);
							}
						}
						case 3:
						{
							if(PlayerInfo[p][pDonateRank] < 3)
							{
								PlayerInfo[p][pPaintTokens] += 5;
								format(string,sizeof(string),"You have been refunded a total of %d Paintball Tokens because of premature closure.",5);
								SendClientMessageEx(p, COLOR_WHITE, string);
							}
						}
						case 4:
						{
							if(PlayerInfo[p][pDonateRank] < 3)
							{
								PlayerInfo[p][pPaintTokens] += 5;
								format(string,sizeof(string),"You have been refunded a total of %d Paintball Tokens because of premature closure.",5);
								SendClientMessageEx(p, COLOR_WHITE, string);
							}
						}
						case 5:
						{
							if(PlayerInfo[p][pDonateRank] < 3)
							{
								PlayerInfo[p][pPaintTokens] += 6;
								format(string,sizeof(string),"You have been refunded a total of %d Paintball Tokens because of premature closure.",6);
								SendClientMessageEx(p, COLOR_WHITE, string);
							}
						}
					}
				}
				LeavePaintballArena(p, arenaid);
			}
		}	
		ResetPaintballArena(i);
		PaintBallArena[i][pbLocked] = 2;
    }
    foreach(new i: Player)
	{
		GameTextForPlayer(i, "Scheduled Maintenance..", 5000, 5);
	}	


    ABroadCast(COLOR_YELLOW, "{AA3333}Maintenance{FFFF00}: Force Saving Accounts...", 1);
	SendRconCommand("password asdatasdhwda");
	SendRconCommand("hostname Next Generation Roleplay [Restarting for Maintenance]");
	foreach(new i: Player)
	{
		if(gPlayerLogged{i}) {
			SetPVarInt(i, "RestartKick", 1);
			//g_mysql_SaveAccount(i);
			OnPlayerStatsUpdate(i);
			break; // We only need to save one person at a time.
		}
	}	
	SetTimer("FinishMaintenance", 60000, false);
	//g_mysql_DumpAccounts();


	return 1;
}

forward HelpTimer(playerid);
public HelpTimer(playerid)
{
	if(GetPVarInt(playerid, "HelpTime") > 0)
 	{
  		SetPVarInt(playerid, "HelpTime", GetPVarInt(playerid, "HelpTime")-1);
    	if(GetPVarInt(playerid, "HelpTime") == 0)
     	{
      		SendClientMessageEx(playerid, COLOR_GREY, "Your help request has expired. Its recommended you seek help on the forums (www.ng-gaming.net/forums)");
        	DeletePVar(playerid, "COMMUNITY_ADVISOR_REQUEST");
         	return 1;
        }
		SetTimerEx("HelpTimer", 60000, 0, "d", playerid);
	}
	return 1;
}

forward DrinkCooldown(playerid);
public DrinkCooldown(playerid)
{
	SetPVarInt(playerid, "DrinkCooledDown", 1);
	return 1;
}

forward RadarCooldown(playerid);
public RadarCooldown(playerid)
{
   DeletePVar(playerid, "RadarTimeout");
   return 1;
}

forward OnPlayerPickUpDynamicPickup(playerid, pickupid);
public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{	
	new vehicleid = GetPlayerVehicleID(playerid);
	for(new iGroup; iGroup < MAX_GROUPS; iGroup++)
	{
		for(new x = 0; x < MAX_SPIKES; ++x)
		{
			if(SpikeStrips[iGroup][x][sX] != 0 && pickupid == SpikeStrips[iGroup][x][sPickupID])
			{
				DestroyDynamicPickup(SpikeStrips[iGroup][x][sPickupID]);
				SpikeStrips[iGroup][x][sPickupID] = CreateDynamicPickup(19300, 14, SpikeStrips[iGroup][x][sX], SpikeStrips[iGroup][x][sY], SpikeStrips[iGroup][x][sZ]);
				if(GetVehicleDistanceFromPoint(vehicleid, SpikeStrips[iGroup][x][sX], SpikeStrips[iGroup][x][sY], SpikeStrips[iGroup][x][sZ]) <= 6.0) 
				{
					new Float:pos[4];
					GetVehiclePos(vehicleid, pos[0], pos[1], pos[2]);
					GetVehicleZAngle(vehicleid, pos[3]);
					// TODO: This should be more specific to the vehicle
					// TODO: Bike tires should be checked differently

					if(GetDistanceBetweenPoints(pos[0], pos[1], pos[2], SpikeStrips[iGroup][x][sX], SpikeStrips[iGroup][x][sY], SpikeStrips[iGroup][x][sZ]) <= 4)
					{
							// Pop Front
						SetVehicleTireState(vehicleid, 0, 0, 0, 0);
					}
				}
			}	
		}
	}
	if (GetPVarInt(playerid, "_BikeParkourStage") > 0)
	{
		new stage = GetPVarInt(playerid, "_BikeParkourStage");
		new slot = GetPVarInt(playerid, "_BikeParkourSlot");
		new bikePickup = GetPVarInt(playerid, "_BikeParkourPickup");
		new business = InBusiness(playerid);

		if (pickupid != bikePickup)
		{
			SendClientMessageEx(playerid, COLOR_GRAD2, "That isn't your pickup!");
			return 1;
		}

		if (stage > 1 && !IsPlayerInAnyVehicle(playerid))
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "You must be on your bike to proceed!");
			return 1;
		}

		switch (GetPVarInt(playerid, "_BikeParkourStage"))
		{
			case 1:
			{
				DestroyDynamicPickup(bikePickup);

				new Float:pos[4];
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				GetPlayerFacingAngle(playerid, pos[3]);

				new vehicleId = CreateVehicle(481, pos[0], pos[1], pos[2], pos[3], 0, 0, 0);
				SetVehicleVirtualWorld(vehicleId, GetPlayerVirtualWorld(playerid));
				LinkVehicleToInterior(vehicleId, GetPlayerInterior(playerid));
				Businesses[business][bGymBikeVehicles][slot] = vehicleId;

				SendClientMessageEx(playerid, COLOR_WHITE, "Follow the arrow pickups to complete the track.");
				//SendClientMessageEx(playerid, COLOR_WHITE, "Type /leaveparkour to quit the activity without completing it.");

				bikePickup = CreateDynamicPickup(1318, 14, 2823.5071, -2260.9243, 97.5347, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 2);
			}

			case 2:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2821.0806, -2254.6775, 98.6094, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 3);
			}

			case 3:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2817.6206, -2246.4187, 98.6221, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 4);
			}

			case 4:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2813.2246, -2235.4602, 98.6094, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 5);
			}

			case 5:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2817.3789, -2228.5271, 98.6919, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 6);
			}

			case 6:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2823.3210, -2232.0654, 98.6221, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 7);
			}

			case 7:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2828.3071, -2231.8882, 99.2544, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 8);
			}

			case 8:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2831.8652, -2235.8438, 99.8750, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 9);
			}

			case 9:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2832.3789, -2243.1646, 98.8604, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 10);
			}

			case 10:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2830.2227, -2247.3076, 98.6094, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 11);
			}

			case 11:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2830.8708, -2251.3501, 99.7329, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 12);
			}

			case 12:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2840.0076, -2252.7549, 99.7329, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 13);
			}

			case 13:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2858.3438, -2252.1355, 99.2871, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 14);
			}

			case 14:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2857.1311, -2239.4653, 99.2373, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 15);
			}

			case 15:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2852.6345, -2239.1692, 98.6665, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 16);
			}

			case 16:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2846.7661, -2226.1548, 98.8716, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 17);
			}

			case 17:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2838.6113, -2228.2808, 98.7231, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 18);
			}

			case 18:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2837.6887, -2219.9446, 100.5010, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 19);
			}

			case 19:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2833.5979, -2215.8831, 100.4380, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 20);
			}

			case 20:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2825.3645, -2220.9446, 100.4761, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 21);
			}

			case 21:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2818.7837, -2223.2014, 98.6221, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 22);
			}

			case 22:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2823.7703, -2224.3865, 98.9653, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 23);
			}

			case 23:
			{
				DestroyDynamicPickup(bikePickup);
				bikePickup = CreateDynamicPickup(1318, 14, 2836.5769, -2232.2056, 96.0278, .playerid = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = 0);
				SetPVarInt(playerid, "_BikeParkourPickup", bikePickup);
				SetPVarInt(playerid, "_BikeParkourStage", 24);
			}

			case 24:
			{
				DestroyDynamicPickup(bikePickup);

				new vehicle = Businesses[business][bGymBikeVehicles][slot];
				DestroyVehicle(vehicle);

				Businesses[business][bGymBikePlayers][slot] = INVALID_PLAYER_ID;
				Businesses[business][bGymBikeVehicles][slot] = INVALID_VEHICLE_ID;

				SendClientMessageEx(playerid, COLOR_WHITE, "Track finished.");

				DeletePVar(playerid, "_BikeParkourStage");
				DeletePVar(playerid, "_BikeParkourSlot");
				DeletePVar(playerid, "_BikeParkourPickup");

				if(PlayerInfo[playerid][mCooldown][4]) PlayerInfo[playerid][pFitness] += 23;
				else PlayerInfo[playerid][pFitness] += 15;

				if (PlayerInfo[playerid][pFitness] > 100)
					PlayerInfo[playerid][pFitness] = 100;
			}
		}
	}
	return 1;
}

forward ReplyTimer(reportid);
public ReplyTimer(reportid)
{
    Reports[reportid][ReportPriority] = 0;
    Reports[reportid][ReportLevel] = 0;
    Reports[reportid][BeingUsed] = 0;
	Reports[reportid][ReportFrom] = INVALID_PLAYER_ID;
    Reports[reportid][CheckingReport] = INVALID_PLAYER_ID;
}

forward DisableCheckPoint(playerid);
public DisableCheckPoint(playerid)
{
    return DisablePlayerCheckpoint(playerid);
}

forward HijackTruck(playerid);
public HijackTruck(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);
  	new business = TruckDeliveringTo[vehicleid];

	SetPVarInt(playerid, "LoadTruckTime", GetPVarInt(playerid, "LoadTruckTime")-1);
	new string[128];
	format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~%d seconds left", GetPVarInt(playerid, "LoadTruckTime"));
	GameTextForPlayer(playerid, string, 1100, 3);
	if(GetPVarInt(playerid, "LoadTruckTime") > 0) SetTimerEx("HijackTruck", 1000, 0, "d", playerid);

	if(GetPVarInt(playerid, "LoadTruckTime") <= 0)
	{
		DeletePVar(playerid, "IsFrozen");
		TogglePlayerControllable(playerid, 1);
  		DeletePVar(playerid, "LoadTruckTime");

        if(!IsPlayerInVehicle(playerid, vehicleid))
        {
			TruckUsed[playerid] = INVALID_VEHICLE_ID;
			gPlayerCheckpointStatus[playerid] = CHECKPOINT_NONE;
 			DisablePlayerCheckpoint(playerid);
            SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* You failed to hijack the shipment.");
			return 1;
        }


		foreach(new i: Player)
		{
			if(TruckUsed[i] == vehicleid)
			{
				DeletePVar(i, "LoadTruckTime");
				TruckUsed[i] = INVALID_VEHICLE_ID;
				DisablePlayerCheckpoint(i);
				gPlayerCheckpointStatus[i] = CHECKPOINT_NONE;
				SendClientMessageEx(i, COLOR_WHITE, "Your shipment delivery has failed. Your shipment was Hijacked.");
			}
		}	

  		TruckUsed[playerid] = vehicleid;
  		if(!IsABoat(vehicleid))
  		{
			new route = TruckRoute[vehicleid];
			SetPVarInt(playerid, "TruckDeliver", TruckContents{vehicleid});
			switch(TruckContents{vehicleid}) {
			    case 0: {
			        if(business != INVALID_BUSINESS_ID)
			        {
						format(string, sizeof(string), "You hijacked a shipment of %s", GetInventoryType(TruckDeliveringTo[vehicleid]));
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);

				        SetPlayerCheckpoint(playerid, Businesses[business][bSupplyPos][0], Businesses[business][bSupplyPos][1], Businesses[business][bSupplyPos][2], 10.0);
					}
				}
				case 1: {
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"You hijacked a shipment of food & beverages.");
					SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 5);
				}
				case 2:
				{
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"You hijacked a shipment of clothing.");
					SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 5);
				}
				case 3:
				{
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"You hijacked a shipment of materials.");
					SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 5);
				}
				case 4:
				{
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* You hijacked a shipment of stolen 24/7 items - watch out for law enforcement!");
					SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 5);
				}
				case 5:
				{
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* You hijacked a shipment of weapons - watch out for law enforcement!");
					SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 5);
				}
				case 6:
				{
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"You hijacked a shipment of drugs - watch out for law enforcement!");
					SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 5);
				}
				case 7:
				{
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"You hijacked a shipment of illegal materials - watch out for law enforcement!");
					SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 5);
				}
			}
			SendClientMessageEx(playerid, COLOR_REALRED, "WARNING: Watch out for Truck hijackers, they can hijack your truck and get away with the goods.");
		}
		else
		{
		    SetPVarInt(playerid, "TruckDeliver", TruckContents{vehicleid});
			new route = TruckRoute[vehicleid];
			switch(TruckContents{vehicleid}) {
				case 1: {
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"You hijacked a shipment of food & beverages.");
					SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 5);
				}
				case 2:
				{
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"You hijacked a shipment of clothing.");
					SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 5);
				}
				case 3:
				{
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"You hijacked a shipment of materials.");
					SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 5);
				}
				case 4:
				{
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* You hijacked a shipment of stolen 24/7 items - watch out for law enforcement!");
					SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 5);
				}
				case 5:
				{
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* You hijacked a shipment of weapons - watch out for law enforcement!");
					SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 5);
				}
				case 6:
				{
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"You hijacked a shipment of drugs - watch out for law enforcement!");
					SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 5);
				}
				case 7:
				{
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"You hijacked a shipment of illegal materials - watch out for law enforcement!");
					SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 5);
				}
				default: return SendClientMessageEx(playerid, COLOR_GRAD2, "This vehicle is not loaded with hijackable goods.");
			}
			SendClientMessageEx(playerid, COLOR_REALRED, "WARNING: Watch out for boat hijackers, they can hijack your boat and get away with the goods.");
		}
		SendClientMessageEx(playerid, COLOR_WHITE, "Deliver the goods to the specified location (see checkpoint on radar).");
	}
	return 1;
}

forward LoadTruckOld(playerid);
public LoadTruckOld(playerid)
{
    SetPVarInt(playerid, "LoadTruckTime", GetPVarInt(playerid, "LoadTruckTime")-1);
	new string[128];
	format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~%d seconds left", GetPVarInt(playerid, "LoadTruckTime"));
	GameTextForPlayer(playerid, string, 1100, 3);

	if(GetPVarInt(playerid, "LoadTruckTime") > 0) SetTimerEx("LoadTruckOld", 1000, 0, "d", playerid);

	if(GetPVarInt(playerid, "LoadTruckTime") <= 0)
	{
		DeletePVar(playerid, "LoadTruckTime");
		DeletePVar(playerid, "IsFrozen");
		TogglePlayerControllable(playerid, 1);

  		new vehicleid = GetPlayerVehicleID(playerid);
  		new truckdeliver = GetPVarInt(playerid, "TruckDeliver");
  		TruckContents{vehicleid} = truckdeliver;
  		TruckUsed[playerid] = vehicleid;
  		if(!IsABoat(vehicleid))
  		{
	  		new route = random(sizeof(TruckerDropoffs));
	  		TruckRoute[vehicleid] = route;
			// 1 = food and bev
			// 2 = clothing
			// 3 = legal mats
			// 4 = 24/7 items
			// 5 = weapons
			// 6 = illegal drugs
			// 7 = illegal materials
			if(truckdeliver == 1)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Your Truck was filled with food & beverages.");
				SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 5);
			}
			else if(truckdeliver == 2)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Your Truck was filled with clothing.");
				SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 5);
			}
			else if(truckdeliver == 3)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Your Truck was filled with materials.");
				SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 5);
			}
			else if(truckdeliver == 4)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Your Truck was filled with 24/7 items.");
				SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 5);
			}
			else if(truckdeliver == 5)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Your Truck was filled with weapons.");
				SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 5);
			}
			else if(truckdeliver == 6)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Your Truck was filled with drugs.");
				SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 5);
			}
			else if(truckdeliver == 7)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Your Truck was filled with illegal materials.");
				SetPlayerCheckpoint(playerid, TruckerDropoffs[route][PosX], TruckerDropoffs[route][PosY], TruckerDropoffs[route][PosZ], 5);
			}
			SendClientMessageEx(playerid, COLOR_REALRED, "WARNING: Watch out for Truck hijackers, they can hijack your truck and get away with the goods.");
		}
		else
		{
			new route = random(sizeof(BoatDropoffs));
	  		TruckRoute[vehicleid] = route;

			if(truckdeliver == 1)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Your Boat was filled with food & beverages.");
				SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 5);
			}
			else if(truckdeliver == 2)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Your Boat was filled with clothing.");
				SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 5);
			}
			else if(truckdeliver == 3)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Your Boat was filled with materials.");
				SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 5);
			}
			else if(truckdeliver == 4)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Your Boat was filled with 24/7 items.");
				SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 5);
			}
			else if(truckdeliver == 5)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Your Boat was filled with weapons.");
				SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 5);
			}
			else if(truckdeliver == 6)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Your Boat was filled with drugs.");
				SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 5);
			}
			else if(truckdeliver == 7)
			{
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* Your Boat was filled with illegal materials.");
				SetPlayerCheckpoint(playerid, BoatDropoffs[route][PosX], BoatDropoffs[route][PosY], BoatDropoffs[route][PosZ], 5);
			}
			SendClientMessageEx(playerid, COLOR_REALRED, "WARNING: Watch out for boat hijackers, they can hijack your boat and get away with the goods.");
		}
		if(truckdeliver >= 5)
		{
			SendClientMessageEx(playerid, COLOR_REALRED, "WARNING #2: You are transporting illegal goods so watch out for law enforcement.");
		}
		SendClientMessageEx(playerid, COLOR_WHITE, "HINT: Deliver the goods to the specified location (see checkpoint on radar).");
		SetPVarInt(playerid, "tpTruckRunTimer", 30);
		SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_TPTRUCKRUNTIMER);
	}
	return 1;
}

forward LoadTruck(playerid);
public LoadTruck(playerid)
{
    SetPVarInt(playerid, "LoadTruckTime", GetPVarInt(playerid, "LoadTruckTime")-1);
	new string[128];
	format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~%d seconds left", GetPVarInt(playerid, "LoadTruckTime"));
	GameTextForPlayer(playerid, string, 1100, 3);

	if(GetPVarInt(playerid, "LoadTruckTime") > 0) SetTimerEx("LoadTruck", 1000, 0, "d", playerid);

	if(GetPVarInt(playerid, "LoadTruckTime") <= 0)
	{
		DeletePVar(playerid, "LoadTruckTime");
		DeletePVar(playerid, "IsFrozen");
		TogglePlayerControllable(playerid, 1);

  		new vehicleid = GetPlayerVehicleID(playerid);
  		new business = TruckDeliveringTo[vehicleid];
  		TruckUsed[playerid] = vehicleid;


		gPlayerCheckpointStatus[playerid] = CHECKPOINT_DELIVERY;

		format(string, sizeof(string), "* Your Truck was filled with %s", GetInventoryType(business));
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);

        SetPlayerCheckpoint(playerid, Businesses[business][bSupplyPos][0], Businesses[business][bSupplyPos][1], Businesses[business][bSupplyPos][2], 10.0);

		SendClientMessageEx(playerid, COLOR_WHITE, "HINT: Deliver the goods to the specified location (see checkpoint on radar).");
		SendClientMessageEx(playerid, COLOR_REALRED, "WARNING: Watch out for truck hijackers, they can hijack your truck and get away with the goods.");

		if (Businesses[business][bType] == BUSINESS_TYPE_GUNSHOP)
		{
			SendClientMessageEx(playerid, COLOR_REALRED, "WARNING #2: You are transporting illegal goods so watch out for law enforcement.");
		}
		else if (Businesses[business][bType] == BUSINESS_TYPE_GASSTATION)
		{
		  	new Float:x, Float:y, Float:z, Float:ang;
		  	SetVehiclePos(vehicleid, -1570.9833,96.7547,4.1442);
		  	SetVehicleZAngle(vehicleid, 136.18);
		    GetPlayerPos(playerid, x, y, z);
		    GetVehicleZAngle(vehicleid, ang);
		    new iTrailer = CreateVehicle(584, x, y, z+1, ang, -1, -1, 1000);
		    SetPVarInt(playerid, "Gas_TrailerID", iTrailer);
			SetTimerEx("AttachGasTrailer", 500, false, "ii", iTrailer, vehicleid);
		}
		/*else if (Businesses[business][bType] == BUSINESS_TYPE_NEWCARDEALERSHIP)
		{
			new iModel, iSlot;
		    for (new i; i < MAX_BUSINESS_DEALERSHIP_VEHICLES; i++)
		    {
			    if (Businesses[business][DealershipVehOrder][i]) {
					iModel = Businesses[business][bModel][i];
					iSlot = i;
	 			}
		    }
			new Float: fVehPos[4];
			GetVehiclePos(vehicleid, fVehPos[0], fVehPos[1], fVehPos[2]);
			GetVehicleZAngle(vehicleid, fVehPos[3]);
			new iDeliveredVeh = CreateVehicle(iModel, fVehPos[0], fVehPos[1], fVehPos[2] + 3, fVehPos[3], 1, 1, -1);
			SetVehicleZAngle(iDeliveredVeh, fVehPos[3]);
			vehicle_lock_doors(iDeliveredVeh);

			SetPVarInt(playerid, "CarryingVehicle", iDeliveredVeh);
			SetPVarInt(playerid, "CarryingSlot", iSlot);
		} */
		SetPVarInt(playerid, "tpTruckRunTimer", floatround(GetPlayerDistanceFromPoint(playerid, Businesses[business][bSupplyPos][0], Businesses[business][bSupplyPos][1], Businesses[business][bSupplyPos][2]) / 100));
		SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_TPTRUCKRUNTIMER);
	}
	return 1;
}

forward AttachGasTrailer(trailerid,vehicleid);
public AttachGasTrailer(trailerid,vehicleid)
{
	return AttachTrailerToVehicle(trailerid, vehicleid);
}

forward AttemptPurify(playerid);
public AttemptPurify(playerid)
{
	if(IsPlayerInRangeOfPoint(playerid, 5.0, -882.2048,1109.3385,5442.8193))
	{
	    if(playerTabbed[playerid] != 0)
		{
   			SendClientMessageEx(playerid, COLOR_GREY, "You alt-tabbed during the purification process.");
			Purification[0] = 0;
	    	KillTimer(GetPVarInt(playerid, "AttemptPurify"));
	    	DeletePVar(playerid, "PurifyTime");
	    	DeletePVar(playerid, "AttemptPurify");
    		return 1;
		}
	    if(GetPVarInt(playerid, "PurifyTime") == 30)
	    {
	        new szMessage[128];
	        if(PlayerInfo[playerid][pRawOpium] > 30)
	        {
	        	format(szMessage, sizeof(szMessage), "You have successfully purified %d milligrams of heroin!", 30);
	        	SendClientMessageEx(playerid, COLOR_GREEN, szMessage);

	        	format(szMessage, sizeof(szMessage), "* %s has successfully purified %d milligrams of heroin.", GetPlayerNameEx(playerid), 30);
				ProxDetector(25.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

				PlayerInfo[playerid][pHeroin] += 30;
	        	PlayerInfo[playerid][pRawOpium] -= 30;
            	KillTimer(GetPVarInt(playerid, "AttemptPurify"));
	        	Purification[0] = 0;
	        	DeletePVar(playerid, "PurifyTime");
	        	DeletePVar(playerid, "AttemptPurify");
			}
			else
			{
	        	format(szMessage, sizeof(szMessage), "You have successfully purified %d milligrams of heroin!", PlayerInfo[playerid][pRawOpium]);
	        	SendClientMessageEx(playerid, COLOR_GREEN, szMessage);

	        	format(szMessage, sizeof(szMessage), "* %s has successfully purified %d milligrams of heroin.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pRawOpium]);
				ProxDetector(25.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

				PlayerInfo[playerid][pHeroin] += PlayerInfo[playerid][pRawOpium];
	        	PlayerInfo[playerid][pRawOpium] = 0;
            	KillTimer(GetPVarInt(playerid, "AttemptPurify"));
	        	Purification[0] = 0;
	        	DeletePVar(playerid, "PurifyTime");
	        	DeletePVar(playerid, "AttemptPurify");
			}
		}
	    else
	    {
	    	SetPVarInt(playerid, "PurifyTime", GetPVarInt(playerid, "PurifyTime")+1);
		}
	}
	else
	{
	    DeletePVar(playerid, "PurifyTime");
	    Purification[0] = 0;
	    KillTimer(GetPVarInt(playerid, "AttemptPurify"));
	    DeletePVar(playerid, "AttemptPurify");
	    SendClientMessageEx(playerid, COLOR_GREY, "You stopped the purification process.");
	}
	return 1;
}

forward HeroinEffect(playerid);
public HeroinEffect(playerid)
{
	if(GetPVarInt(playerid, "Health") != 0)
	{
		SetPVarInt(playerid, "Health", GetPVarInt(playerid, "Health")-1);
		SetHealth(playerid, GetPVarInt(playerid, "Health"));
	}
	else
	{
	    KillTimer(GetPVarInt(playerid, "HeroinEffect"));
	    DeletePVar(playerid, "HeroinEffect");
	}
	return 1;
}

forward InjectHeroin(playerid);
public InjectHeroin(playerid)
{
    KillEMSQueue(playerid);
	ClearAnimations(playerid);
	SetHealth(playerid, 30);
	SetPVarInt(playerid, "HeroinEffect", SetTimerEx("HeroinEffect", 1000, 1, "i", playerid));
	return 1;
}

forward HeroinEffectStanding(playerid);
public HeroinEffectStanding(playerid)
{
	SetPVarInt(playerid, "HeroinDamageResist", 0);
	SendClientMessageEx(playerid, COLOR_GREEN, "The effects of the heroin have worn off.");
	return 1;
}

forward InjectHeroinStanding(playerid);
public InjectHeroinStanding(playerid)
{
	SetPVarInt(playerid, "HeroinDamageResist", 1);
	SendClientMessageEx(playerid, COLOR_GREEN, "The effects of the heroin have started.");
	SetPVarInt(playerid, "HeroinEffectStanding", SetTimerEx("HeroinEffectStanding", 30000, 0, "i", playerid));
	return 1;
}

forward ParkVehicle(playerid, ownerid, vehicleid, d, Float:X, Float:Y, Float:Z);
public ParkVehicle(playerid, ownerid, vehicleid, d, Float:X, Float:Y, Float:Z)
{
	if(IsPlayerInRangeOfPoint(playerid, 1.0, X, Y, Z))
	{
	    new Float:x, Float:y, Float:z, Float:angle, Float:health, string[29 + (MAX_PLAYER_NAME * 2)];
	    GetVehicleHealth(vehicleid, health);
     	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessageEx(playerid, COLOR_GREY, "You must be in the driver seat.");
     	if(health < 800) return SendClientMessageEx(playerid, COLOR_GREY, " Your vehicle is too damaged to park it.");
		if(ownerid != INVALID_PLAYER_ID)
	    {
			GetVehiclePos(vehicleid, x, y, z);
			GetVehicleZAngle(vehicleid, angle);
			SurfingCheck(vehicleid);
			UpdatePlayerVehicleParkPosition(ownerid, d, x, y, z, angle, health, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
			IsPlayerEntering{playerid} = true;
			PutPlayerInVehicle(playerid, vehicleid, 0);
			SetPlayerArmedWeapon(playerid, 0);
			format(string, sizeof(string), "* %s has parked %s's vehicle.", GetPlayerNameEx(playerid), GetPlayerNameEx(ownerid));
		}
		else
		{
		    GetVehiclePos(vehicleid, x, y, z);
			GetVehicleZAngle(vehicleid, angle);
			SurfingCheck(vehicleid);
			UpdatePlayerVehicleParkPosition(playerid, d, x, y, z, angle, health, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
			IsPlayerEntering{playerid} = true;
			PutPlayerInVehicle(playerid, vehicleid, 0);
			SetPlayerArmedWeapon(playerid, 0);
			format(string, sizeof(string), "* %s has parked their vehicle.", GetPlayerNameEx(playerid), GetPlayerNameEx(ownerid));
		}
		ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	}
	else
	{
	    SendClientMessage(playerid, COLOR_WHITE, "Vehicle did not park because you moved!");
	}
	return 1;
}

forward RevisionListHTTP(index, response_code, data[]);
public RevisionListHTTP(index, response_code, data[])
{
	ShowPlayerDialog(index, DIALOG_REVISION, DIALOG_STYLE_LIST, "Current Version: "SERVER_GM_TEXT" -- View full changes at http://dev.ng-gaming.net", data, "Close", "");
	return 1;
}

forward MoveTimerGate(gateid);
public MoveTimerGate(gateid)
{
	if(GateInfo[gateid][gTimer] != 0)
	{
		MoveDynamicObject(GateInfo[gateid][gGATE], GateInfo[gateid][gPosX], GateInfo[gateid][gPosY], GateInfo[gateid][gPosZ], GateInfo[gateid][gSpeed], GateInfo[gateid][gRotX], GateInfo[gateid][gRotY], GateInfo[gateid][gRotZ]);
		GateInfo[gateid][gStatus] = 0;
	}
	return 1;
}

forward CaptureTimerEx(point);
public CaptureTimerEx(point)
{
	new string[128];
	new fam;
	if (Points[point][TakeOverTimerStarted])
	{
		fam = Points[point][ClaimerTeam];
		if (Points[point][TakeOverTimer] > 0)
		{
			Points[point][TakeOverTimer]--;
			format(string, sizeof(string), "%s has successfully attempted to take over of %s for %s, it will be theirs in %d minutes!",
			Points[point][PlayerNameCapping], Points[point][Name], FamilyInfo[fam][FamilyName], Points[point][TakeOverTimer]);
			UpdateDynamic3DTextLabelText(Points[point][CaptureProccess], COLOR_YELLOW, string);
			PointCrashProtection(point);
		}
		else
		{
			Points[point][ClaimerTeam] = INVALID_PLAYER_ID;
			Points[point][TakeOverTimer] = 0;
			Points[point][TakeOverTimerStarted] = 0;
			Points[point][Announced] = 0;
			Points[point][CapCrash] = 0;
			Points[point][Vulnerable] = NEW_VULNERABLE+1;
			DestroyDynamic3DTextLabel(Points[point][CaptureProccess]);
			Points[point][CaptureProccessEx] = 0;
			strmid(Points[point][Owner], FamilyInfo[fam][FamilyName], 0, 32, 32);
			strmid(Points[point][CapperName], Points[point][PlayerNameCapping], 0, 32, 32);
			format(string, sizeof(string), "%s has successfully taken control of the %s for %s.", Points[point][CapperName], Points[point][Name], Points[point][Owner]);
			SendClientMessageToAllEx(COLOR_YELLOW, string);
			UpdatePoints();
			PointCrashProtection(point);
			KillTimer(Points[point][CaptureTimerEx2]);
			Points[point][CaptureTimerEx2] = -1;
		}
	}
}

forward StopMusic();
public StopMusic()
{
	foreach(new i: Player)
	{
		PlayerPlaySound(i, 1069, 0.0, 0.0, 0.0);
	}	
}

forward PlayerFixRadio2();
public PlayerFixRadio2()
{
	foreach(new i: Player)
	{
		if(Fixr[i])
		{
			PlayerPlaySound(i, 1069, 0.0, 0.0, 0.0);
			Fixr[i] = 0;
		}
	}	
}

forward Float: GetDistanceToCar(playerid, veh);
public Float: GetDistanceToCar(playerid, veh) {

	new
		Float: fVehiclePos[3];

	GetVehiclePos(veh, fVehiclePos[0], fVehiclePos[1], fVehiclePos[2]);
	return GetPlayerDistanceFromPoint(playerid, fVehiclePos[0], fVehiclePos[1], fVehiclePos[2]);
}


forward Float: vehicle_get_speed(vehicleid);
public Float: vehicle_get_speed(vehicleid)
{
	new
		Float: fVelocity[3];

	GetVehicleVelocity(vehicleid, fVelocity[0], fVelocity[1], fVelocity[2]);
	return floatsqroot((fVelocity[0] * fVelocity[0]) + (fVelocity[1] * fVelocity[1]) + (fVelocity[2] * fVelocity[2])) * 100;
}

Float:GetDistanceBetweenPlayers(iPlayerOne, iPlayerTwo)
{
	new
		Float: fPlayerPos[3];

	GetPlayerPos(iPlayerOne, fPlayerPos[0], fPlayerPos[1], fPlayerPos[2]);
	return GetPlayerDistanceFromPoint(iPlayerTwo, fPlayerPos[0], fPlayerPos[1], fPlayerPos[2]);
}

// This needs to be tested! - Akatony
forward Float: player_get_speed(playerid);
public Float: player_get_speed(playerid)
{
	new
		Float: fVelocity[3];

	GetVehicleVelocity(GetPlayerVehicleID(playerid), fVelocity[0], fVelocity[1], fVelocity[2]);
	return floatsqroot((fVelocity[0] * fVelocity[0]) + (fVelocity[1] * fVelocity[1]) + (fVelocity[2] * fVelocity[2])) * 100;
}

forward Float: GetDistance( Float: x1, Float: y1, Float: z1, Float: x2, Float: y2, Float: z2 );
public Float: GetDistance( Float: x1, Float: y1, Float: z1, Float: x2, Float: y2, Float: z2 )
{
	new Float:d;
	d += floatpower(x1-x2, 2.0 );
	d += floatpower(y1-y2, 2.0 );
	d += floatpower(z1-z2, 2.0 );
	d = floatsqroot(d);
	IsInRangeOfPoint(5, 5, 5, 6, 6, 6, 10.0);
	return d;
}


forward UpdateCarRadars();
public UpdateCarRadars()
{
	foreach(new p : Player)
	{
		if (!IsPlayerInAnyVehicle(p) || CarRadars[p] == 0) continue;

		new target = -1;
		new Float:tempDist = 50.0;

		if(CarRadars[p] == 1)
		{
			foreach(new t : Player)
			{
				if (!IsPlayerInAnyVehicle(t) || t == p || IsPlayerInVehicle(t, GetPlayerVehicleID(p))) continue;

				new Float:distance = GetDistanceBetweenPlayers(p, t);

				if (distance < tempDist)
				{
					target = t;
					tempDist = distance;
				}
			}	
			
			if (target == -1)
			{
				// no target was found
				PlayerTextDrawSetString(p, _crTextTarget[p], "Target Vehicle: ~r~N/A");
				PlayerTextDrawSetString(p, _crTextSpeed[p], "Speed: ~r~N/A");
				PlayerTextDrawSetString(p, _crTickets[p], "Tickets: ~r~N/A");
			}
			else
			{	
				new targetVehicle = GetPlayerVehicleID(target);
				new Float: speed = player_get_speed(target);

				new str[60];

				format(str, sizeof(str), "Target Vehicle: ~r~%s (%i)", GetVehicleName(targetVehicle), targetVehicle);
				PlayerTextDrawSetString(p, _crTextTarget[p], str);
				format(str, sizeof(str), "Speed: ~r~%d MPH", floatround(speed, floatround_round));
				PlayerTextDrawSetString(p, _crTextSpeed[p], str);
				foreach(new i : Player)
				{
					new veh = GetPlayerVehicle(i, targetVehicle);
					if (veh != -1 && PlayerVehicleInfo[i][veh][pvTicket] > 0)
					{
						format(str, sizeof(str), "Tickets: ~r~$%s", number_format(PlayerVehicleInfo[i][veh][pvTicket]));
						PlayerTextDrawSetString(p, _crTickets[p], str);
						if (gettime() >= (GetPVarInt(p, "_lastTicketWarning") + 10))
						{
							SetPVarInt(p, "_lastTicketWarning", gettime());
							PlayerPlaySound(p, 4202, 0.0, 0.0, 0.0);
						}
					}
				}	
			}
		}
	}
}

forward FinishMaintenance();
public FinishMaintenance()
{
    ABroadCast(COLOR_YELLOW, "{AA3333}Maintenance{FFFF00}: Force Saving Houses...", 1);
	SaveHouses();
	ABroadCast(COLOR_YELLOW, "{AA3333}Maintenance{FFFF00}: Force Saving Dynamic Doors...", 1);
	SaveDynamicDoors();
	ABroadCast(COLOR_YELLOW, "{AA3333}Maintenance{FFFF00}: Force Saving Garages...", 1);
	SaveGarages();
	ABroadCast(COLOR_YELLOW, "{AA3333}Maintenance{FFFF00}: Force Saving Map Icons...", 1);
	SaveDynamicMapIcons();
	ABroadCast(COLOR_YELLOW, "{AA3333}Maintenance{FFFF00}: Force Saving Gates...", 1);
	SaveGates();
	ABroadCast(COLOR_YELLOW, "{AA3333}Maintenance{FFFF00}: Force Saving Event Points...", 1);
	SaveEventPoints();
	ABroadCast(COLOR_YELLOW, "{AA3333}Maintenance{FFFF00}: Force Saving Paintball Arenas...", 1);
	SavePaintballArenas();
	ABroadCast(COLOR_YELLOW, "{AA3333}Maintenance{FFFF00}: Force Saving Server Configuration", 1);
    Misc_Save();
    ABroadCast(COLOR_YELLOW, "{AA3333}Maintenance{FFFF00}: Force Saving Office Elevator...", 1);
	SaveElevatorStuff();
	ABroadCast(COLOR_YELLOW, "{AA3333}Maintenance{FFFF00}: Force Saving Mail Boxes...", 1);
	SaveMailboxes();
	ABroadCast(COLOR_YELLOW, "{AA3333}Maintenance{FFFF00}: Force Saving Plants...", 1);
	SavePlants();
	ABroadCast(COLOR_YELLOW, "{AA3333}Maintenance{FFFF00}: Force Saving Speed Cameras...", 1);
	SaveSpeedCameras();
	if(rflstatus > 0) {
		ABroadCast(COLOR_YELLOW, "{AA3333}Maintenance{FFFF00}: Force Saving RFL Teams...", 1);
		SaveRelayForLifeTeams();
	}
	g_mysql_SavePrices();
	SaveTurfWars();
	ABroadCast(COLOR_YELLOW, "{AA3333}Maintenance{FFFF00}: Streamer Plugin Shutting Down...", 1);
	DestroyAllDynamicObjects();
	DestroyAllDynamic3DTextLabels();
	DestroyAllDynamicCPs();
	DestroyAllDynamicMapIcons();
	DestroyAllDynamicRaceCPs();
	DestroyAllDynamicAreas();

	SetTimer("ShutDown", 5000, false);
	return 1;
}


forward ShutDown();
public ShutDown()
{
	return SendRconCommand("exit");
}
			
			/*  ---------------- STOCK FUNCTIONS ----------------- */
stock IsRefuelableVehicle(vehicleid)
{
	new modelid = GetVehicleModel(vehicleid);
	switch (modelid)
	{
		case 481, 509, 510: return 0; // Bikes
	}
	return 1;
}

stock SetVehicleTireState(vehicleid, tire1, tire2, tire3, tire4)
{
    new panels, doors, Lights, tires;
   	GetVehicleDamageStatus(vehicleid, panels, doors, Lights, tires);
    tires = encode_tires(!tire1, !tire2, !tire3, !tire4);
    UpdateVehicleDamageStatus(vehicleid, panels, doors, Lights, tires);
}

stock GetVehicleTireState(vehicleid, &tire1, &tire2, &tire3, &tire4)
{
    new panels, doors, Lights, tires;
   	GetVehicleDamageStatus(vehicleid, panels, doors, Lights, tires);
    tire1 = !(tires >> 0 & 0x1);
	tire2 = !(tires >> 1 & 0x1);
	tire3 = !(tires >> 2 & 0x1);
	tire4 = !(tires >> 3 & 0x1);
}
forward Float:GetDistanceBetweenPoints(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2);

stock Float:GetDistanceBetweenPoints(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2) {
    return floatsqroot(floatpower(x1 - x2, 2) + floatpower(y1 - y2, 2) + floatpower(z1 - z2, 2));
}

stock ClearMarriage(playerid)
{
	if(IsPlayerConnected(playerid)) {
		new string[MAX_PLAYER_NAME];
		format(string, sizeof(string), "Nobody");
		strmid(PlayerInfo[playerid][pMarriedName], string, 0, strlen(string), MAX_PLAYER_NAME);
		PlayerInfo[playerid][pMarriedID] = -1;
	}
	return 1;
}

stock ClearHouse(houseid) {
	HouseInfo[houseid][hOwned] = 0;
	HouseInfo[houseid][hSafeMoney] = 0;
	HouseInfo[houseid][hPot] = 0;
	HouseInfo[houseid][hCrack] = 0;
	HouseInfo[houseid][hMaterials] = 0;
	HouseInfo[houseid][hHeroin] = 0;
	for(new i = 0; i < 5; i++)
	{
		HouseInfo[houseid][hWeapons][i] = 0;
	}
	HouseInfo[houseid][hGLUpgrade] = 1;
	HouseInfo[houseid][hClosetX] = 0.0;
	HouseInfo[houseid][hClosetY] = 0.0;
	HouseInfo[houseid][hClosetZ] = 0.0;
	DestroyDynamic3DTextLabel(Text3D:HouseInfo[houseid][hClosetTextID]);
	format(HouseInfo[houseid][hSignDesc], 64, "None");
	HouseInfo[houseid][hSign][0] = 0.0;
	HouseInfo[houseid][hSign][1] = 0.0;
	HouseInfo[houseid][hSign][2] = 0.0;
	HouseInfo[houseid][hSign][3] = 0.0;
	HouseInfo[houseid][hSignExpire] = 0;
	if(IsValidDynamicObject(HouseInfo[houseid][hSignObj])) DestroyDynamicObject(HouseInfo[houseid][hSignObj]);
	if(IsValidDynamic3DTextLabel(HouseInfo[houseid][hSignText])) DestroyDynamic3DTextLabel(HouseInfo[houseid][hSignText]);
}

stock ClearFamily(family)
{
	foreach(new i: Player)
	{
		if(PlayerInfo[i][pFMember] == family) {
			SendClientMessageEx(i, COLOR_LIGHTBLUE, "* The Family you are in has just been deleted by an Admin, you have been kicked out automatically.");
			PlayerInfo[i][pFMember] = INVALID_FAMILY_ID;
		}
	}	

	new string[MAX_PLAYER_NAME];
	format(string, sizeof(string), "None");
	FamilyInfo[family][FamilyTaken] = 0;
	strmid(FamilyInfo[family][FamilyName], string, 0, strlen(string), 255);
	strmid(FamilyMOTD[family][0], string, 0, strlen(string), 128);
	strmid(FamilyMOTD[family][1], string, 0, strlen(string), 128);
	strmid(FamilyMOTD[family][2], string, 0, strlen(string), 128);
	strmid(FamilyInfo[family][FamilyLeader], string, 0, strlen(string), 255);
	format(string, sizeof(string), "Newb");
	strmid(FamilyRankInfo[family][0], string, 0, strlen(string), 30);
	format(string, sizeof(string), "Outsider");
	strmid(FamilyRankInfo[family][1], string, 0, strlen(string), 30);
	format(string, sizeof(string), "Associate");
	strmid(FamilyRankInfo[family][2], string, 0, strlen(string), 30);
	format(string, sizeof(string), "Soldier");
	strmid(FamilyRankInfo[family][3], string, 0, strlen(string), 30);
	format(string, sizeof(string), "Capo");
	strmid(FamilyRankInfo[family][4], string, 0, strlen(string), 30);
	format(string, sizeof(string), "Underboss");
	strmid(FamilyRankInfo[family][5], string, 0, strlen(string), 30);
	format(string, sizeof(string), "Godfather");
	strmid(FamilyRankInfo[family][6], string, 0, strlen(string), 30);
	format(string, sizeof(string), "None");
	for(new i = 0; i < 5; i++)
	{
		strmid(FamilyDivisionInfo[family][i], string, 0, 16, 30);
	}
	FamilyInfo[family][FamilyColor] = 0;
	FamilyInfo[family][FamilyTurfTokens] = 24;
	FamilyInfo[family][FamilyMembers] = 0;
	for(new i = 0; i < 4; i++)
	{
		FamilyInfo[family][FamilySpawn][i] = 0.0;
	}
	for(new i = 0; i < 10; i++)
	{
		FamilyInfo[family][FamilyGuns][i] = 0;
	}
	FamilyInfo[family][FamilyCash] = 0;
	FamilyInfo[family][FamilyMats] = 0;
	FamilyInfo[family][FamilyHeroin] = 0;
	FamilyInfo[family][FamilyPot] = 0;
	FamilyInfo[family][FamilyCrack] = 0;
	FamilyInfo[family][FamilySafe][0] = 0.0;
	FamilyInfo[family][FamilySafe][1] = 0.0;
	FamilyInfo[family][FamilySafe][2] = 0.0;
	FamilyInfo[family][FamilySafeVW] = 0;
	FamilyInfo[family][FamilySafeInt] = 0;
	FamilyInfo[family][FamilyUSafe] = 0;
	FamilyInfo[family][FamColor] = 0x01FCFF;
	DestroyDynamicPickup( FamilyInfo[family][FamilyEntrancePickup] );
	DestroyDynamicPickup( FamilyInfo[family][FamilyExitPickup] );
	DestroyDynamic3DTextLabel( Text3D:FamilyInfo[family][FamilyEntranceText] );
	DestroyDynamic3DTextLabel( Text3D:FamilyInfo[family][FamilyExitText] );
	DestroyDynamicPickup( FamilyInfo[family][FamilyPickup] );
	new query[60];
	format(query, sizeof(query), "UPDATE `accounts` SET `FMember` = 255 WHERE `FMember` = %d", family);
	mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	SaveFamilies();
	return 1;
}

stock BubbleSort(a[], size)
{
	new tmp=0, bool:swapped;

	do
	{
		swapped = false;
		for(new i=1; i < size; i++) {
			if(a[i-1] > a[i]) {
				tmp = a[i];
				a[i] = a[i-1];
				a[i-1] = tmp;
				swapped = true;
			}
		}
	} while(swapped);
}

stock SendClientMessageEx(playerid, color, string[])
{
	if(InsideMainMenu{playerid} == 1 || InsideTut{playerid} == 1 || ActiveChatbox[playerid] == 0)
		return 0;

	else SendClientMessage(playerid, color, string);
	return 1;
}

stock SendClientMessageToAllEx(color, string[])
{
	foreach(new i: Player)
	{
		if(InsideMainMenu{i} == 1 || InsideTut{i} == 1 || ActiveChatbox[i] == 0) {}
		else SendClientMessage(i, color, string);
	}	
	return 1;
}

stock SendClientMessageWrap(playerid, color, width, string[])
{
	if(strlen(string) > width)
	{
		new firstline[128], secondline[128];
		strmid(firstline, string, 0, 88);
		strmid(secondline, string, 88, 128);
		format(firstline, sizeof(firstline), "%s...", firstline);
		format(secondline, sizeof(secondline), "...%s", secondline);
		SendClientMessageEx(playerid, color, firstline);
		SendClientMessageEx(playerid, color, secondline);
	}
	else SendClientMessageEx(playerid, color, string);
}

stock SetPlayerJoinCamera(playerid)
{
	new randcamera = Random(1,9);
	switch(randcamera)
	{
		case 1: // Gym
		{
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid,2229.4968,-1722.0701,13.5625);
			SetPlayerPos(playerid,2211.1460,-1748.3909,-10.0);
			SetPlayerCameraPos(playerid,2211.1460,-1748.3909,29.3744);
			SetPlayerCameraLookAt(playerid,2229.4968,-1722.0701,13.5625);
		}
		case 2: // Paintball Arena
		{
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid,1295.6960,-1422.5111,14.9596);
			SetPlayerPos(playerid,1283.8524,-1385.5304,-10.0);
			SetPlayerCameraPos(playerid,1283.8524,-1385.5304,25.8896);
			SetPlayerCameraLookAt(playerid,1295.6960,-1422.5111,14.9596);
		}
		case 3: // LSPD
		{
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid,1554.3381,-1675.5692,16.1953);
			SetPlayerPos(playerid,1514.7783,-1700.2913,-10.0);
			SetPlayerCameraPos(playerid,1514.7783,-1700.2913,36.7506);
			SetPlayerCameraLookAt(playerid,1554.3381,-1675.5692,16.1953);
		}
		case 4: // SaC HQ (Gang HQ)
		{
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid,655.5394,-1867.2231,5.4609);
			SetPlayerPos(playerid,655.5394,-1867.2231,-10.0);
			SetPlayerCameraPos(playerid,699.7435,-1936.7568,24.8646);
			SetPlayerCameraLookAt(playerid,655.5394,-1867.2231,5.4609);

		}
		case 5: // Fishing Pier
		{
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid,370.0804,-2087.8767,7.8359);
			SetPlayerPos(playerid,370.0804,-2087.8767,-10.0);
			SetPlayerCameraPos(playerid,423.3802,-2067.7915,29.8605);
			SetPlayerCameraLookAt(playerid,370.0804,-2087.8767,7.8359);
		}
		case 6: // VIP
		{
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid,1797.3397,-1578.3440,14.0798);
			SetPlayerPos(playerid,1797.3397,-1578.3440,-10.0);
			SetPlayerCameraPos(playerid,1832.1698,-1600.1538,32.2877);
			SetPlayerCameraLookAt(playerid,1797.3397,-1578.3440,14.0798);
		}
		case 7: // All Saints
		{
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid,1175.5581,-1324.7922,18.1610);
			SetPlayerPos(playerid, 1188.4574,-1309.2242,-10.0);
			SetPlayerCameraPos(playerid,1188.4574,-1309.2242,13.5625+6.0);
			SetPlayerCameraLookAt(playerid,1175.5581,-1324.7922,18.1610);
		}
		case 8: // Unity
		{
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid,1716.1129,-1880.0715,22.0264);
			SetPlayerPos(playerid,1716.1129,-1880.0715,-10.0);
			SetPlayerCameraPos(playerid,1755.0413,-1824.8710,20.2100);
			SetPlayerCameraLookAt(playerid,1716.1129,-1880.0715,22.0264);
		}
	}
	return 1;
}

stock ShowMainMenuDialog(playerid, frame)
{
	new titlestring[64];
	new string[512];

	switch(frame)
	{
		case 1:
		{
			format(titlestring, sizeof(titlestring), "{3399FF}Login - %s", GetPlayerNameEx(playerid));
			format(string, sizeof(string), "{FFFFFF}Welcome to Next Generation Roleplay, %s.\n\nThe name that you are using is registered, please enter a password to login:", GetPlayerNameEx(playerid));
			ShowPlayerDialog(playerid,MAINMENU,DIALOG_STYLE_PASSWORD,titlestring,string,"Login","Exit");
		}
		case 2:
		{
			format(titlestring, sizeof(titlestring), "{3399FF}Register - %s", GetPlayerNameEx(playerid));
			format(string, sizeof(string), "{FFFFFF}Welcome to Next Generation Roleplay, %s.\n\n{FFFFFF}You may {AA3333}register {FFFFFF}an account by entering a desired password here:", GetPlayerNameEx(playerid));
			if(PassComplexCheck) strcat(string, "\n\n- You can't select a password that's below 8 or above 64 characters\n\
			- Your password must contain a combination of letters, numbers and special characters.\n\
			- Invalid Character: %");
			ShowPlayerDialog(playerid,MAINMENU2,DIALOG_STYLE_PASSWORD,titlestring,string,"Register","Exit");
		}
		case 3:
		{
			format(titlestring, sizeof(titlestring), "{3399FF}Login - %s", GetPlayerNameEx(playerid));
			format(string, sizeof(string), "{FFFFFF}Invalid Password!\n\nWelcome to Next Generation Roleplay, %s.\n\nThe name that you are using is registered, please enter a password to login:", GetPlayerNameEx(playerid));
			ShowPlayerDialog(playerid,MAINMENU,DIALOG_STYLE_PASSWORD,titlestring,string,"Login","Exit");
		}
		case 4:
		{
			format(titlestring, sizeof(titlestring), "{3399FF}Account Locked - %s", GetPlayerNameEx(playerid));
			format(string, sizeof(string), "{FFFFFF}Our database indicates that %s is currently logged in, if this is a mistake please contact a tech administrator.", GetPlayerNameEx(playerid));
			ShowPlayerDialog(playerid,MAINMENU3,DIALOG_STYLE_MSGBOX,titlestring,string,"Exit","");
		}
	}
	return 1;
}

stock SafeLogin(playerid, type)
{
	switch(type)
	{
		case 1: // Account Exists
		{
			ShowMainMenuDialog(playerid, 1);
		}
		case 2: // No Account Exists
		{
			if(!IsValidName(playerid))
			{
			    SetPVarString(playerid, "KickNonRP", GetPlayerNameEx(playerid));
			    SetTimerEx("KickNonRP", 3000, false, "i", playerid);
			}
			else
			{
			    ShowMainMenuDialog(playerid, 2);
			}
		}
	}

	return 1;
}

stock InvalidNameCheck(playerid) {

	new
		arrForbiddenNames[][] = {
			"com1", "com2", "com3", "com4",
			"com5", "com6", "com7", "com8",
			"com9", "lpt4", "lpt5", "lpt6",
			"lpt7", "lpt8", "lpt9", "nul",
			"clock$", "aux", "prn", "con",
			"InvalidNick"
	    };

	new i = 0;
	while(i < sizeof(arrForbiddenNames)) if(strcmp(arrForbiddenNames[i++], GetPlayerNameExt(playerid), true) == 0) {
		SetPlayerName(playerid, "InvalidNick");
		SendClientMessage(playerid, COLOR_RED, "You have been kicked & logged for using a forbidden username.");
		SetTimerEx("KickEx", 1000, 0, "i", playerid);
		return 0;

	}
	return 1;
}

stock Float: GetVehicleFuelCapacity(vehicleid)
{
	new Float: capacity;
	if (IsABike(vehicleid)) {
		capacity = 5.0;
	}
 	else {
	 	capacity = 20.00;
	}
	return capacity;
	//TODO optimise more
}

stock UpdateSANewsBroadcast()
{
    new string[42];
	if(broadcasting == 0)
	{
	    format(string, sizeof(string), "Currently: Not Broadcasting\nViewers: %d", viewers);
	}
	else
	{
	    format(string, sizeof(string), "Currently: LIVE\nViewers: %d", viewers);
	}
	for(new i = 0; i < 3; i++)
	{
		UpdateDynamic3DTextLabelText(SANews3DText[i], COLOR_LIGHTBLUE, string);
	}
}

stock RespawnNearbyVehicles(iPlayerID, Float: fRadius) {

	new
		Float: fPlayerPos[3];

    GetPlayerPos(iPlayerID, fPlayerPos[0], fPlayerPos[1], fPlayerPos[2]);
    for(new i = 1; i < MAX_VEHICLES; i++)
	{
		if(GetVehicleModel(i) && GetVehicleDistanceFromPoint(i, fPlayerPos[0], fPlayerPos[1], fPlayerPos[2]) <= fRadius && !IsVehicleOccupied(i))
		{
			if(DynVeh[i] != -1)
			{
			    DynVeh_Spawn(DynVeh[i]);
			    TruckDeliveringTo[i] = INVALID_BUSINESS_ID;
			}
			SetVehicleToRespawn(i);
		}
	}
	return 1;
}

stock IsVehicleOccupied(iVehicleID, iSeatID = 0) {
	foreach(new x : Player)
	{
		if(GetPlayerVehicleID(x) == iVehicleID && GetPlayerVehicleSeat(x) == iSeatID) {
			return 1;
		}
	}	
	return 0;
}

stock IsVehicleInTow(iVehicleID) {
	foreach(new x : Player)
	{
		if(arr_Towing[x] == iVehicleID) {
			return 1;
		}
	}	
	return 0;
}

stock FindFreeAttachedObjectSlot(playerid)
{
	new index;
 	while (index < MAX_PLAYER_ATTACHED_OBJECTS && IsPlayerAttachedObjectSlotUsed(playerid, index))
	{
		index++;
	}
	if (index == MAX_PLAYER_ATTACHED_OBJECTS) return -1;
	return index;
}

stock HideModelSelectionMenu(playerid)
{
	mS_DestroySelectionMenu(playerid);
	SetPVarInt(playerid, "mS_ignore_next_esc", 1);
	CancelSelectTextDraw(playerid);
	return 1;
}

stock mS_DestroySelectionMenu(playerid)
{
	if(GetPVarInt(playerid, "mS_list_active") == 1)
	{
		if(mS_GetPlayerCurrentListID(playerid) == mS_CUSTOM_LISTID)
		{
			DeletePVar(playerid, "mS_custom_Xrot");
			DeletePVar(playerid, "mS_custom_Yrot");
			DeletePVar(playerid, "mS_custom_Zrot");
			DeletePVar(playerid, "mS_custom_Zoom");
			DeletePVar(playerid, "mS_custom_extraid");
			DeletePVar(playerid, "mS_custom_item_amount");
		}
		DeletePVar(playerid, "mS_list_time");
		SetPVarInt(playerid, "mS_list_active", 0);
		mS_DestroyPlayerMPs(playerid);

		PlayerTextDrawDestroy(playerid, gHeaderTextDrawId[playerid]);
		PlayerTextDrawDestroy(playerid, gBackgroundTextDrawId[playerid]);
		PlayerTextDrawDestroy(playerid, gCurrentPageTextDrawId[playerid]);
		PlayerTextDrawDestroy(playerid, gNextButtonTextDrawId[playerid]);
		PlayerTextDrawDestroy(playerid, gPrevButtonTextDrawId[playerid]);
		PlayerTextDrawDestroy(playerid, gCancelButtonTextDrawId[playerid]);

		gHeaderTextDrawId[playerid] = PlayerText:INVALID_TEXT_DRAW;
		gBackgroundTextDrawId[playerid] = PlayerText:INVALID_TEXT_DRAW;
		gCurrentPageTextDrawId[playerid] = PlayerText:INVALID_TEXT_DRAW;
		gNextButtonTextDrawId[playerid] = PlayerText:INVALID_TEXT_DRAW;
		gPrevButtonTextDrawId[playerid] = PlayerText:INVALID_TEXT_DRAW;
		gCancelButtonTextDrawId[playerid] = PlayerText:INVALID_TEXT_DRAW;
	}
}

stock LoadModelSelectionMenu(f_name[])
{
	new File:f, str[75];
	format(str, sizeof(str), "%s", f_name);
	f = fopen(str, io_read);
	if( !f ) {
		printf("-mSelection- WARNING: Failed to load list: \"%s\"", f_name);
		return mS_INVALID_LISTID;
	}

	if(gListAmount >= mS_TOTAL_LISTS)
	{
		printf("-mSelection- WARNING: Reached maximum amount of lists, increase \"mS_TOTAL_LISTS\"", f_name);
		return mS_INVALID_LISTID;
	}
	new tmp_ItemAmount = gItemAmount; // copy value if loading fails


	new line[128], idxx;
	while(fread(f,line,sizeof(line),false))
	{
		if(tmp_ItemAmount >= mS_TOTAL_ITEMS)
		{
			printf("-mSelection- WARNING: Reached maximum amount of items, increase \"mS_TOTAL_ITEMS\"", f_name);
			break;
		}
		idxx = 0;
		if(!line[0]) continue;
		new mID = strval( mS_strtok(line,idxx) );
		if(0 <= mID < 20000)
		{
			gItemList[tmp_ItemAmount][mS_ITEM_MODEL] = mID;

			new tmp_mS_strtok[20];
			new Float:mRotation[3], Float:mZoom = 1.0;
			new bool:useRotation = false;

			tmp_mS_strtok = mS_strtok(line,idxx);
			if(tmp_mS_strtok[0]) {
				useRotation = true;
				mRotation[0] = floatstr(tmp_mS_strtok);
			}
			tmp_mS_strtok = mS_strtok(line,idxx);
			if(tmp_mS_strtok[0]) {
				useRotation = true;
				mRotation[1] = floatstr(tmp_mS_strtok);
			}
			tmp_mS_strtok = mS_strtok(line,idxx);
			if(tmp_mS_strtok[0]) {
				useRotation = true;
				mRotation[2] = floatstr(tmp_mS_strtok);
			}
			tmp_mS_strtok = mS_strtok(line,idxx);
			if(tmp_mS_strtok[0]) {
				useRotation = true;
				mZoom = floatstr(tmp_mS_strtok);
			}
			if(useRotation)
			{
				new bool:foundRotZoom = false;
				for(new i=0; i < gRotZoomAmount; i++)
				{
					if(gRotZoom[i][0] == mRotation[0] && gRotZoom[i][1] == mRotation[1] && gRotZoom[i][2] == mRotation[2] && gRotZoom[i][3] == mZoom)
					{
						foundRotZoom = true;
						gItemList[tmp_ItemAmount][mS_ITEM_ROT_ZOOM_ID] = i;
						break;
					}
				}
				if(gRotZoomAmount < mS_TOTAL_ROT_ZOOM)
				{
					if(!foundRotZoom)
					{
						gRotZoom[gRotZoomAmount][0] = mRotation[0];
						gRotZoom[gRotZoomAmount][1] = mRotation[1];
						gRotZoom[gRotZoomAmount][2] = mRotation[2];
						gRotZoom[gRotZoomAmount][3] = mZoom;
						gItemList[tmp_ItemAmount][mS_ITEM_ROT_ZOOM_ID] = gRotZoomAmount;
						gRotZoomAmount++;
					}
				}
				else print("-mSelection- WARNING: Not able to save rotation/zoom information. Reached maximum rotation/zoom information count. Increase '#define mS_TOTAL_ROT_ZOOM' to fix the issue");
			}
			else gItemList[tmp_ItemAmount][mS_ITEM_ROT_ZOOM_ID] = -1;
			tmp_ItemAmount++;
		}
	}
	if(tmp_ItemAmount > gItemAmount) // any models loaded ?
	{
		gLists[gListAmount][mS_LIST_START] = gItemAmount;
		gItemAmount = tmp_ItemAmount; // copy back
		gLists[gListAmount][mS_LIST_END] = (gItemAmount-1);

		gListAmount++;
		return (gListAmount-1);
	}
	printf("-mSelection- WARNING: No Items found in file: %s", f_name);
	return mS_INVALID_LISTID;
}



stock mS_strtok(const string[], &index)
{
	new length = strlen(string);
	while ((index < length) && (string[index] <= ' '))
	{
		index++;
	}

	new offset = index;
	new result[20];
	while ((index < length) && (string[index] > ' ') && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	return result;
}

stock mS_GetNumberOfPages(ListID)
{
	new ItemAmount = mS_GetAmountOfListItems(ListID);
	if((ItemAmount >= mS_SELECTION_ITEMS) && (ItemAmount % mS_SELECTION_ITEMS) == 0)
	{
		return (ItemAmount / mS_SELECTION_ITEMS);
	}
	else return (ItemAmount / mS_SELECTION_ITEMS) + 1;
}

stock mS_GetNumberOfPagesEx(playerid)
{
	new ItemAmount = mS_GetAmountOfListItemsEx(playerid);
	if((ItemAmount >= mS_SELECTION_ITEMS) && (ItemAmount % mS_SELECTION_ITEMS) == 0)
	{
		return (ItemAmount / mS_SELECTION_ITEMS);
	}
	else return (ItemAmount / mS_SELECTION_ITEMS) + 1;
}

stock mS_GetAmountOfListItems(ListID)
{
	return (gLists[ListID][mS_LIST_END] - gLists[ListID][mS_LIST_START])+1;
}

stock mS_GetAmountOfListItemsEx(playerid)
{
	return GetPVarInt(playerid, "mS_custom_item_amount");
}

stock mS_GetPlayerCurrentListID(playerid)
{
	if(GetPVarInt(playerid, "mS_list_active") == 1) return GetPVarInt(playerid, "mS_list_id");
	else return mS_INVALID_LISTID;
}

stock PlayerText:mS_CreateCurrentPageTextDraw(playerid, Float:Xpos, Float:Ypos)
{
	new PlayerText:txtInit;
   	txtInit = CreatePlayerTextDraw(playerid, Xpos, Ypos, "0/0");
   	PlayerTextDrawUseBox(playerid, txtInit, 0);
	PlayerTextDrawLetterSize(playerid, txtInit, 0.4, 1.1);
	PlayerTextDrawFont(playerid, txtInit, 1);
	PlayerTextDrawSetShadow(playerid, txtInit, 0);
    PlayerTextDrawSetOutline(playerid, txtInit, 1);
    PlayerTextDrawColor(playerid, txtInit, 0xACCBF1FF);
    PlayerTextDrawShow(playerid, txtInit);
    return txtInit;
}

stock PlayerText:mS_CreatePlayerDialogButton(playerid, Float:Xpos, Float:Ypos, Float:Width, Float:Height, button_text[])
{
 	new PlayerText:txtInit;
   	txtInit = CreatePlayerTextDraw(playerid, Xpos, Ypos, button_text);
   	PlayerTextDrawUseBox(playerid, txtInit, 1);
   	PlayerTextDrawBoxColor(playerid, txtInit, 0x000000FF);
   	PlayerTextDrawBackgroundColor(playerid, txtInit, 0x000000FF);
	PlayerTextDrawLetterSize(playerid, txtInit, 0.4, 1.1);
	PlayerTextDrawFont(playerid, txtInit, 1);
	PlayerTextDrawSetShadow(playerid, txtInit, 0); // no shadow
    PlayerTextDrawSetOutline(playerid, txtInit, 0);
    PlayerTextDrawColor(playerid, txtInit, 0x4A5A6BFF);
    PlayerTextDrawSetSelectable(playerid, txtInit, 1);
    PlayerTextDrawAlignment(playerid, txtInit, 2);
    PlayerTextDrawTextSize(playerid, txtInit, Height, Width); // The width and height are reversed for centering.. something the game does <g>
    PlayerTextDrawShow(playerid, txtInit);
    return txtInit;
}

stock PlayerText:mS_CreatePlayerHeaderTextDraw(playerid, Float:Xpos, Float:Ypos, header_text[])
{
	new PlayerText:txtInit;
   	txtInit = CreatePlayerTextDraw(playerid, Xpos, Ypos, header_text);
   	PlayerTextDrawUseBox(playerid, txtInit, 0);
	PlayerTextDrawLetterSize(playerid, txtInit, 1.25, 3.0);
	PlayerTextDrawFont(playerid, txtInit, 0);
	PlayerTextDrawSetShadow(playerid, txtInit, 0);
    PlayerTextDrawSetOutline(playerid, txtInit, 1);
    PlayerTextDrawColor(playerid, txtInit, 0xACCBF1FF);
    PlayerTextDrawShow(playerid, txtInit);
    return txtInit;
}

stock PlayerText:mS_CreatePlayerBGTextDraw(playerid, Float:Xpos, Float:Ypos, Float:Width, Float:Height, bgcolor)
{
	new PlayerText:txtBackground = CreatePlayerTextDraw(playerid, Xpos, Ypos,"                                            ~n~"); // enough space for everyone
    PlayerTextDrawUseBox(playerid, txtBackground, 1);
    PlayerTextDrawBoxColor(playerid, txtBackground, bgcolor);
	PlayerTextDrawLetterSize(playerid, txtBackground, 5.0, 5.0);
	PlayerTextDrawFont(playerid, txtBackground, 0);
	PlayerTextDrawSetShadow(playerid, txtBackground, 0);
    PlayerTextDrawSetOutline(playerid, txtBackground, 0);
    PlayerTextDrawColor(playerid, txtBackground,0x000000FF);
    PlayerTextDrawTextSize(playerid, txtBackground, Width, Height);
   	PlayerTextDrawBackgroundColor(playerid, txtBackground, bgcolor);
    PlayerTextDrawShow(playerid, txtBackground);
    return txtBackground;
}

stock PlayerText:mS_CreateMPTextDraw(playerid, modelindex, Float:Xpos, Float:Ypos, Float:Xrot, Float:Yrot, Float:Zrot, Float:mZoom, Float:width, Float:height, bgcolor)
{
    new PlayerText:txtPlayerSprite = CreatePlayerTextDraw(playerid, Xpos, Ypos, ""); // it has to be set with SetText later
    PlayerTextDrawFont(playerid, txtPlayerSprite, TEXT_DRAW_FONT_MODEL_PREVIEW);
    PlayerTextDrawColor(playerid, txtPlayerSprite, 0xFFFFFFFF);
    PlayerTextDrawBackgroundColor(playerid, txtPlayerSprite, bgcolor);
    PlayerTextDrawTextSize(playerid, txtPlayerSprite, width, height); // Text size is the Width:Height
    PlayerTextDrawSetPreviewModel(playerid, txtPlayerSprite, modelindex);
    PlayerTextDrawSetPreviewRot(playerid,txtPlayerSprite, Xrot, Yrot, Zrot, mZoom);
    PlayerTextDrawSetSelectable(playerid, txtPlayerSprite, 1);
    PlayerTextDrawShow(playerid,txtPlayerSprite);
    return txtPlayerSprite;
}

stock mS_DestroyPlayerMPs(playerid)
{
	new x=0;
	while(x != mS_SELECTION_ITEMS) {
	    if(gSelectionItems[playerid][x] != PlayerText:INVALID_TEXT_DRAW) {
			PlayerTextDrawDestroy(playerid, gSelectionItems[playerid][x]);
			gSelectionItems[playerid][x] = PlayerText:INVALID_TEXT_DRAW;
		}
		x++;
	}
}

stock mS_ShowPlayerMPs(playerid)
{
	new bgcolor = GetPVarInt(playerid, "mS_previewBGcolor");
    new x=0;
	new Float:BaseX = mS_DIALOG_BASE_X;
	new Float:BaseY = mS_DIALOG_BASE_Y - (mS_SPRITE_DIM_Y * 0.33); // down a bit
	new linetracker = 0;

	new mS_listID = mS_GetPlayerCurrentListID(playerid);
	if(mS_listID == mS_CUSTOM_LISTID)
	{
		new itemat = (GetPVarInt(playerid, "mS_list_page") * mS_SELECTION_ITEMS);
		new Float:rotzoom[4];
		rotzoom[0] = GetPVarFloat(playerid, "mS_custom_Xrot");
		rotzoom[1] = GetPVarFloat(playerid, "mS_custom_Yrot");
		rotzoom[2] = GetPVarFloat(playerid, "mS_custom_Zrot");
		rotzoom[3] = GetPVarFloat(playerid, "mS_custom_Zoom");
		new itemamount = mS_GetAmountOfListItemsEx(playerid);
		// Destroy any previous ones created
		mS_DestroyPlayerMPs(playerid);

		while(x != mS_SELECTION_ITEMS && itemat < (itemamount)) {
			if(linetracker == 0) {
				BaseX = mS_DIALOG_BASE_X + 25.0; // in a bit from the box
				BaseY += mS_SPRITE_DIM_Y + 1.0; // move on the Y for the next line
			}
			gSelectionItems[playerid][x] = mS_CreateMPTextDraw(playerid, gCustomList[playerid][itemat], BaseX, BaseY, rotzoom[0], rotzoom[1], rotzoom[2], rotzoom[3], mS_SPRITE_DIM_X, mS_SPRITE_DIM_Y, bgcolor);
			gSelectionItemsTag[playerid][x] = gCustomList[playerid][itemat];
			gSelectionItemsExtra[playerid][x] = gCustomExtraList[playerid][itemat];
			BaseX += mS_SPRITE_DIM_X + 1.0; // move on the X for the next sprite
			linetracker++;
			if(linetracker == mS_ITEMS_PER_LINE) linetracker = 0;
			itemat++;
			x++;
		}
	}
	else
	{
		new itemat = (gLists[mS_listID][mS_LIST_START] + (GetPVarInt(playerid, "mS_list_page") * mS_SELECTION_ITEMS));

		// Destroy any previous ones created
		mS_DestroyPlayerMPs(playerid);

		while(x != mS_SELECTION_ITEMS && itemat < (gLists[mS_listID][mS_LIST_END]+1)) {
			if(linetracker == 0) {
				BaseX = mS_DIALOG_BASE_X + 25.0; // in a bit from the box
				BaseY += mS_SPRITE_DIM_Y + 1.0; // move on the Y for the next line
			}
			new rzID = gItemList[itemat][mS_ITEM_ROT_ZOOM_ID]; // avoid long line
			if(rzID > -1) gSelectionItems[playerid][x] = mS_CreateMPTextDraw(playerid, gItemList[itemat][mS_ITEM_MODEL], BaseX, BaseY, gRotZoom[rzID][0], gRotZoom[rzID][1], gRotZoom[rzID][2], gRotZoom[rzID][3], mS_SPRITE_DIM_X, mS_SPRITE_DIM_Y, bgcolor);
			else gSelectionItems[playerid][x] = mS_CreateMPTextDraw(playerid, gItemList[itemat][mS_ITEM_MODEL], BaseX, BaseY, 0.0, 0.0, 0.0, 1.0, mS_SPRITE_DIM_X, mS_SPRITE_DIM_Y, bgcolor);
			gSelectionItemsTag[playerid][x] = gItemList[itemat][mS_ITEM_MODEL];
			BaseX += mS_SPRITE_DIM_X + 1.0; // move on the X for the next sprite
			linetracker++;
			if(linetracker == mS_ITEMS_PER_LINE) linetracker = 0;
			itemat++;
			x++;
		}
	}
}

stock mS_UpdatePageTextDraw(playerid)
{
	new PageText[64+1];
	new listID = mS_GetPlayerCurrentListID(playerid);
	if(listID == mS_CUSTOM_LISTID)
	{
		format(PageText, 64, "%d/%d", GetPVarInt(playerid,"mS_list_page") + 1, mS_GetNumberOfPagesEx(playerid));
		PlayerTextDrawSetString(playerid, gCurrentPageTextDrawId[playerid], PageText);
	}
	else
	{
		format(PageText, 64, "%d/%d", GetPVarInt(playerid,"mS_list_page") + 1, mS_GetNumberOfPages(listID));
		PlayerTextDrawSetString(playerid, gCurrentPageTextDrawId[playerid], PageText);
	}
}

stock ShowModelSelectionMenu(playerid, ListID, header_text[], dialogBGcolor = 0x4A5A6BBB, previewBGcolor = 0x88888899 , tdSelectionColor = 0xFFFF00AA)
{
	if(!(0 <= ListID < mS_TOTAL_LISTS && gLists[ListID][mS_LIST_START] != gLists[ListID][mS_LIST_END])) return 0;
	mS_DestroySelectionMenu(playerid);
	SetPVarInt(playerid, "mS_list_page", 0);
	SetPVarInt(playerid, "mS_list_id", ListID);
	SetPVarInt(playerid, "mS_list_active", 1);
	SetPVarInt(playerid, "mS_list_time", GetTickCount());

    gBackgroundTextDrawId[playerid] = mS_CreatePlayerBGTextDraw(playerid, mS_DIALOG_BASE_X, mS_DIALOG_BASE_Y + 20.0, mS_DIALOG_WIDTH, mS_DIALOG_HEIGHT, dialogBGcolor);
    gHeaderTextDrawId[playerid] = mS_CreatePlayerHeaderTextDraw(playerid, mS_DIALOG_BASE_X, mS_DIALOG_BASE_Y, header_text);
    gCurrentPageTextDrawId[playerid] = mS_CreateCurrentPageTextDraw(playerid, mS_DIALOG_WIDTH - 30.0, mS_DIALOG_BASE_Y + 15.0);
    gNextButtonTextDrawId[playerid] = mS_CreatePlayerDialogButton(playerid, mS_DIALOG_WIDTH - 30.0, mS_DIALOG_BASE_Y+mS_DIALOG_HEIGHT+100.0, 50.0, 16.0, mS_NEXT_TEXT);
    gPrevButtonTextDrawId[playerid] = mS_CreatePlayerDialogButton(playerid, mS_DIALOG_WIDTH - 90.0, mS_DIALOG_BASE_Y+mS_DIALOG_HEIGHT+100.0, 50.0, 16.0, mS_PREV_TEXT);
    gCancelButtonTextDrawId[playerid] = mS_CreatePlayerDialogButton(playerid, mS_DIALOG_WIDTH - 150.0, mS_DIALOG_BASE_Y+mS_DIALOG_HEIGHT+100.0, 50.0, 16.0, mS_CANCEL_TEXT);

	SetPVarInt(playerid, "mS_previewBGcolor", previewBGcolor);
    mS_ShowPlayerMPs(playerid);
    mS_UpdatePageTextDraw(playerid);

	SelectTextDraw(playerid, tdSelectionColor);
	return 1;
}

stock ShowModelSelectionMenuEx(playerid, items_array[], item_amount, header_text[], extraid, Float:Xrot = 0.0, Float:Yrot = 0.0, Float:Zrot = 0.0, Float:mZoom = 1.0, dialogBGcolor = 0x4A5A6BBB, previewBGcolor = 0x88888899 , tdSelectionColor = 0xFFFF00AA)
{
	mS_DestroySelectionMenu(playerid);
	if(item_amount > mS_CUSTOM_MAX_ITEMS)
	{
		item_amount = mS_CUSTOM_MAX_ITEMS;
		print("-mSelection- WARNING: Too many items given to \"ShowModelSelectionMenuEx\", increase \"mS_CUSTOM_MAX_ITEMS\" to fix this");
	}
	if(item_amount > 0)
	{
		for(new i=0;i<item_amount;i++)
		{
			gCustomList[playerid][i] = items_array[i];
		}
		SetPVarInt(playerid, "mS_list_page", 0);
		SetPVarInt(playerid, "mS_list_id", mS_CUSTOM_LISTID);
		SetPVarInt(playerid, "mS_list_active", 1);
		SetPVarInt(playerid, "mS_list_time", GetTickCount());

		SetPVarInt(playerid, "mS_custom_item_amount", item_amount);
		SetPVarFloat(playerid, "mS_custom_Xrot", Xrot);
		SetPVarFloat(playerid, "mS_custom_Yrot", Yrot);
		SetPVarFloat(playerid, "mS_custom_Zrot", Zrot);
		SetPVarFloat(playerid, "mS_custom_Zoom", mZoom);
		SetPVarInt(playerid, "mS_custom_extraid", extraid);


		gBackgroundTextDrawId[playerid] = mS_CreatePlayerBGTextDraw(playerid, mS_DIALOG_BASE_X, mS_DIALOG_BASE_Y + 20.0, mS_DIALOG_WIDTH, mS_DIALOG_HEIGHT, dialogBGcolor);
		gHeaderTextDrawId[playerid] = mS_CreatePlayerHeaderTextDraw(playerid, mS_DIALOG_BASE_X, mS_DIALOG_BASE_Y, header_text);
		gCurrentPageTextDrawId[playerid] = mS_CreateCurrentPageTextDraw(playerid, mS_DIALOG_WIDTH - 30.0, mS_DIALOG_BASE_Y + 15.0);
		gNextButtonTextDrawId[playerid] = mS_CreatePlayerDialogButton(playerid, mS_DIALOG_WIDTH - 30.0, mS_DIALOG_BASE_Y+mS_DIALOG_HEIGHT+100.0, 50.0, 16.0, mS_NEXT_TEXT);
		gPrevButtonTextDrawId[playerid] = mS_CreatePlayerDialogButton(playerid, mS_DIALOG_WIDTH - 90.0, mS_DIALOG_BASE_Y+mS_DIALOG_HEIGHT+100.0, 50.0, 16.0, mS_PREV_TEXT);
		gCancelButtonTextDrawId[playerid] = mS_CreatePlayerDialogButton(playerid, mS_DIALOG_WIDTH - 150.0, mS_DIALOG_BASE_Y+mS_DIALOG_HEIGHT+100.0, 50.0, 16.0, mS_CANCEL_TEXT);

		SetPVarInt(playerid, "mS_previewBGcolor", previewBGcolor);
		mS_ShowPlayerMPs(playerid);
		mS_UpdatePageTextDraw(playerid);

		SelectTextDraw(playerid, tdSelectionColor);
		return 1;
	}
	return 0;
}

stock date( timestamp, _form=0 )
{
    /*
        date( 1247182451 )  will print >> 09.07.2009-23:34:11
        date( 1247182451, 1) will print >> 09/07/2009, 23:34:11
        date( 1247182451, 2) will print >> July 09, 2009, 23:34:11
        date( 1247182451, 3) will print >> 9 Jul 2009, 23:34
    */
    new year=1970, day=0, month=0, hourt=0, mins=0, sec=0;

    new days_of_month[12] = { 31,28,31,30,31,30,31,31,30,31,30,31 };
    new names_of_month[12][10] = {"January","February","March","April","May","June","July","August","September","October","November","December"};
    new returnstring[32];

    while(timestamp>31622400){
        timestamp -= 31536000;
        if ( ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0) ) timestamp -= 86400;
        year++;
    }

    if ( ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0) )
        days_of_month[1] = 29;
    else
        days_of_month[1] = 28;


    while(timestamp>86400){
        timestamp -= 86400, day++;
        if(day==days_of_month[month]) day=0, month++;
    }

    while(timestamp>60){
        timestamp -= 60, mins++;
        if( mins == 60) mins=0, hourt++;
    }

    sec=timestamp;

    switch( _form ){
        case 1: format(returnstring, 31, "%02d/%02d/%d %02d:%02d:%02d", day+1, month+1, year, hourt, mins, sec);
        case 2: format(returnstring, 31, "%s %02d, %d, %02d:%02d:%02d", names_of_month[month],day+1,year, hourt, mins, sec);
        case 3: format(returnstring, 31, "%d %c%c%c %d, %02d:%02d", day+1,names_of_month[month][0],names_of_month[month][1],names_of_month[month][2], year,hourt,mins);
		case 4: format(returnstring, 31, "%s %02d, %d", names_of_month[month],day+1,year);
        default: format(returnstring, 31, "%02d.%02d.%d-%02d:%02d:%02d", day+1, month+1, year, hourt, mins, sec);
    }

    return returnstring;
}

stock SurfingCheck(vehicleid)
{
	foreach(new p: Player)
	{
		if(GetPlayerSurfingVehicleID(p) == vehicleid)
		{
			new Float:x, Float:y, Float:z;
			GetPlayerPos(p, x, y, z);
			SetTimerEx("SurfingFix", 2000, 0, "ifff", p, x, y, z);
		}
	}	
}

stock InvalidModCheck(model, partid) {
    switch(model) {
		case 430, 446, 452, 453, 454, 472, 473, 484, 493, 595, 573, 556, 557, 539, 471, 432, 406, 444,
		448, 461, 462, 463, 468, 481, 509, 510, 521, 522, 581, 586, 417, 425, 447, 460, 469, 476, 487,
		488, 511, 512, 513, 519, 520, 548, 553, 563, 577, 592, 593: return 0;
		default: switch(GetVehicleComponentType(partid)) {
			case 5: switch(partid) {
				case 1008, 1009, 1010: return 1;
				default: return 0;
			}
			case 7: switch(partid) {
				case 1073, 1074, 1075, 1076, 1077, 1078, 1079, 1080, 1081, 1082, 1083, 1084, 1085, 1096, 1097, 1098, 1025: return 1;
				default: return 0;
			}
			case 8: switch(partid) {
				case 1086: return 1;
				default: return 0;
			}
			case 9: switch(partid) {
				case 1087: return 1;
				default: return 0;
			}
			case 12, 13: switch(partid) {
				case 1142, 1144, 1143, 1145: return 1;
				default: return 0;
			}
		}
	}
	return 1;
}

stock JudgeOnlineCheck()
{
	foreach(new i: Player)
	{
		if(IsAJudge(i))	return 1;
	}	
	return 0;
}

stock TaxSale(amount)
{
	new iTaxAmount = floatround(amount / 100 * BUSINESS_TAX_PERCENT);
	Tax += iTaxAmount;
	for(new iGroupID; iGroupID < MAX_GROUPS; iGroupID++)
	{
		if(arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_GOV && arrGroupData[iGroupID][g_iAllegiance] == 1)
		{
			new str[128], file[32], month, day, year;
			getdate(year,month,day);
			format(str, sizeof(str), "A Business has paid $%s in sales tax.", number_format(iTaxAmount));
			format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", iGroupID, month, day, year);
			Log(file, str);
		}
	}
	Misc_Save();
	return amount - iTaxAmount;
}

stock SendAudioURLToRange(url[], Float:x, Float:y, Float:z, Float:range)
{
    audiourlid = CreateDynamicSphere(x, y, z, range);
	format(audiourlurl, sizeof(audiourlurl), "%s", url);
	audiourlparams[0] = x;
	audiourlparams[1] = y;
	audiourlparams[2] = z;
	audiourlparams[3] = range;
	return 1;
}


stock SetVehicleLights(vehicleid, playerid)
{
	new engine,lights,alarm,doors,bonnet,boot,objective;
    GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
    if(lights == VEHICLE_PARAMS_ON)
	{
		SetVehicleParamsEx(vehicleid,engine,VEHICLE_PARAMS_OFF,alarm,doors,bonnet,boot,objective);
		SendClientMessageEx(playerid, COLOR_WHITE, "Vehicle lights successfully turned off.");
	}
    else if(lights == VEHICLE_PARAMS_OFF || lights == VEHICLE_PARAMS_UNSET)
	{
		SetVehicleParamsEx(vehicleid,engine,VEHICLE_PARAMS_ON,alarm,doors,bonnet,boot,objective);
		SendClientMessageEx(playerid, COLOR_WHITE, "Vehicle lights successfully turned on.");
	}
	return 1;
}

stock SetVehicleHood(vehicleid, playerid)
{
	new engine,lights,alarm,doors,bonnet,boot,objective;
    GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
    if(bonnet == VEHICLE_PARAMS_ON)
	{
		SetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,VEHICLE_PARAMS_OFF,boot,objective);
		SendClientMessageEx(playerid, COLOR_WHITE, "Vehicle hood successfully closed.");
	}
    else if(bonnet == VEHICLE_PARAMS_OFF || bonnet == VEHICLE_PARAMS_UNSET)
	{
		SetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,VEHICLE_PARAMS_ON,boot,objective);
		SendClientMessageEx(playerid, COLOR_WHITE, "Vehicle hood successfully opened.");
	}
	return 1;
}

stock SetVehicleTrunk(vehicleid, playerid)
{
	new engine,lights,alarm,doors,bonnet,boot,objective;
    GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
    if(boot == VEHICLE_PARAMS_ON)
	{
		SetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,VEHICLE_PARAMS_OFF,objective);
		SendClientMessageEx(playerid, COLOR_WHITE, "Vehicle trunk successfully closed.");
	}
    else if(boot == VEHICLE_PARAMS_OFF || boot == VEHICLE_PARAMS_UNSET)
	{
		SetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,VEHICLE_PARAMS_ON,objective);
		SendClientMessageEx(playerid, COLOR_WHITE, "Vehicle trunk successfully opened.");
	}
	return 1;
}

stock SetVehicleDoors(vehicleid, playerid)
{
	new engine,lights,alarm,doors,bonnet,boot,objective;
    GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
    if(doors == VEHICLE_PARAMS_ON)
	{
		SetVehicleParamsEx(vehicleid,engine,lights,alarm,VEHICLE_PARAMS_OFF,bonnet,boot,objective);
		SendClientMessageEx(playerid, COLOR_WHITE, "Vehicle {AA3333}Doors {FFFFFF}successfully {33AA33}closed{FFFFFF}.");
	}
    else if(doors == VEHICLE_PARAMS_OFF || doors == VEHICLE_PARAMS_UNSET)
	{
		SetVehicleParamsEx(vehicleid,engine,lights,alarm,VEHICLE_PARAMS_ON,bonnet,boot,objective);
		SendClientMessageEx(playerid, COLOR_WHITE, "Vehicle {AA3333}Doors {FFFFFF}successfully {33AA33}opened{FFFFFF}.");
	}
	return 1;
}

stock ClearChatbox(playerid)
{
	for(new i = 0; i < 50; i++) {
		SendClientMessage(playerid, COLOR_WHITE, "");
	}
	return 1;
}

stock ShowNoticeGUIFrame(playerid, frame)
{
	HideNoticeGUIFrame(playerid);

	TextDrawShowForPlayer(playerid, NoticeTxtdraw[0]);
	TextDrawShowForPlayer(playerid, NoticeTxtdraw[1]);

	switch(frame)
	{
		case 1: // Looking up account
		{
			TextDrawShowForPlayer(playerid, NoticeTxtdraw[2]);
		}
		case 2: // Fetching & Comparing Password
		{
			TextDrawShowForPlayer(playerid, NoticeTxtdraw[3]);
		}
		case 3: // Fetching & Loading Account
		{
			TextDrawShowForPlayer(playerid, NoticeTxtdraw[4]);
		}
		case 4: // Streaming Objects
		{
			TextDrawShowForPlayer(playerid, NoticeTxtdraw[5]);
		}
		case 5: // Login Queue
		{
			TextDrawShowForPlayer(playerid, NoticeTxtdraw[6]);
		}
		case 6: // General loading
		{
		    TextDrawShowForPlayer(playerid, NoticeTxtdraw[7]);
		}
	}
}

stock HideNoticeGUIFrame(playerid)
{
	for(new i = 0; i < 8; i++)
	{
		TextDrawHideForPlayer(playerid, NoticeTxtdraw[i]);
	}
}

stock ShowTutGUIFrame(playerid, frame)
{
	switch(frame)
	{
		case 1:
		{
			for(new i = 4; i < 14; i++) {
				TextDrawShowForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 2:
		{
			for(new i = 14; i < 18; i++) {
				TextDrawShowForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 3:
		{
			TextDrawShowForPlayer(playerid, TutTxtdraw[18]);
		}
		case 4:
		{
			TextDrawShowForPlayer(playerid, TutTxtdraw[19]);
		}
		case 5:
		{
			TextDrawShowForPlayer(playerid, TutTxtdraw[20]);
		}
		case 6:
		{
			TextDrawShowForPlayer(playerid, TutTxtdraw[21]);
		}
		case 7:
		{
			TextDrawShowForPlayer(playerid, TutTxtdraw[22]);
		}
		case 8:
		{
			TextDrawShowForPlayer(playerid, TutTxtdraw[23]);
		}
		case 9:
		{
			TextDrawShowForPlayer(playerid, TutTxtdraw[24]);
		}
		case 10:
		{
			for(new i = 25; i < 34; i++) {
				TextDrawShowForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 11:
		{
			for(new i = 34; i < 40; i++) {
				TextDrawShowForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 12:
		{
			for(new i = 40; i < 46; i++) {
				TextDrawShowForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 13:
		{
			for(new i = 46; i < 52; i++) {
				TextDrawShowForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 14:
		{
			for(new i = 52; i < 58; i++) {
				TextDrawShowForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 15:
		{
			for(new i = 58; i < 65; i++) {
				TextDrawShowForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 16:
		{
			for(new i = 65; i < 71; i++) {
				TextDrawShowForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 17:
		{
			for(new i = 71; i < 77; i++) {
				TextDrawShowForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 18:
		{
			for(new i = 77; i < 82; i++) {
				TextDrawShowForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 19:
		{
			for(new i = 82; i < 87; i++) {
				TextDrawShowForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 20:
		{
			for(new i = 87; i < 93; i++) {
				TextDrawShowForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 21:
		{
			for(new i = 93; i < 100; i++) {
				TextDrawShowForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 22:
		{
			for(new i = 100; i < 108; i++) {
				TextDrawShowForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 23:
		{
			for(new i = 108; i < 114; i++) {
				TextDrawShowForPlayer(playerid, TutTxtdraw[i]);
			}
		}
	}
}

stock HideTutGUIFrame(playerid, frame)
{
	switch(frame)
	{
		case 1:
		{
			for(new i = 4; i < 14; i++) {
				TextDrawHideForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 2:
		{
			for(new i = 14; i < 18; i++) {
				TextDrawHideForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 3:
		{
			TextDrawHideForPlayer(playerid, TutTxtdraw[18]);
		}
		case 4:
		{
			TextDrawHideForPlayer(playerid, TutTxtdraw[19]);
		}
		case 5:
		{
			TextDrawHideForPlayer(playerid, TutTxtdraw[20]);
		}
		case 6:
		{
			TextDrawHideForPlayer(playerid, TutTxtdraw[21]);
		}
		case 7:
		{
			TextDrawHideForPlayer(playerid, TutTxtdraw[22]);
		}
		case 8:
		{
			TextDrawHideForPlayer(playerid, TutTxtdraw[23]);
		}
		case 9:
		{
			TextDrawHideForPlayer(playerid, TutTxtdraw[24]);
		}
		case 10:
		{
			for(new i = 25; i < 34; i++) {
				TextDrawHideForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 11:
		{
			for(new i = 34; i < 40; i++) {
				TextDrawHideForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 12:
		{
			for(new i = 40; i < 46; i++) {
				TextDrawHideForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 13:
		{
			for(new i = 46; i < 52; i++) {
				TextDrawHideForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 14:
		{
			for(new i = 52; i < 58; i++) {
				TextDrawHideForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 15:
		{
			for(new i = 58; i < 65; i++) {
				TextDrawHideForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 16:
		{
			for(new i = 65; i < 71; i++) {
				TextDrawHideForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 17:
		{
			for(new i = 71; i < 77; i++) {
				TextDrawHideForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 18:
		{
			for(new i = 77; i < 82; i++) {
				TextDrawHideForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 19:
		{
			for(new i = 82; i < 87; i++) {
				TextDrawHideForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 20:
		{
			for(new i = 87; i < 93; i++) {
				TextDrawHideForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 21:
		{
			for(new i = 93; i < 100; i++) {
				TextDrawHideForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 22:
		{
			for(new i = 100; i < 108; i++) {
				TextDrawHideForPlayer(playerid, TutTxtdraw[i]);
			}
		}
		case 23:
		{
			for(new i = 108; i < 114; i++) {
				TextDrawHideForPlayer(playerid, TutTxtdraw[i]);
			}
		}
	}
}

stock ShowTutGUIBox(playerid)
{
	InsideTut{playerid} = true;

	TextDrawShowForPlayer(playerid, MainMenuTxtdraw[0]);
	TextDrawShowForPlayer(playerid, MainMenuTxtdraw[1]);
	TextDrawShowForPlayer(playerid, MainMenuTxtdraw[2]);
	TextDrawShowForPlayer(playerid, MainMenuTxtdraw[3]);
	TextDrawShowForPlayer(playerid, MainMenuTxtdraw[4]);
	TextDrawShowForPlayer(playerid, MainMenuTxtdraw[5]);
	TextDrawShowForPlayer(playerid, MainMenuTxtdraw[6]);
	TextDrawShowForPlayer(playerid, MainMenuTxtdraw[9]);
	TextDrawShowForPlayer(playerid, MainMenuTxtdraw[10]);

	TextDrawShowForPlayer(playerid, TutTxtdraw[0]);
	TextDrawShowForPlayer(playerid, TutTxtdraw[1]);
	TextDrawShowForPlayer(playerid, TutTxtdraw[2]);
	TextDrawShowForPlayer(playerid, TutTxtdraw[3]);
	TextDrawShowForPlayer(playerid, TutTxtdraw[114]);

}

stock HideTutGUIBox(playerid)
{
	InsideTut{playerid} = false;

	TextDrawHideForPlayer(playerid, MainMenuTxtdraw[0]);
	TextDrawHideForPlayer(playerid, MainMenuTxtdraw[1]);
	TextDrawHideForPlayer(playerid, MainMenuTxtdraw[2]);
	TextDrawHideForPlayer(playerid, MainMenuTxtdraw[3]);
	TextDrawHideForPlayer(playerid, MainMenuTxtdraw[4]);
	TextDrawHideForPlayer(playerid, MainMenuTxtdraw[5]);
	TextDrawHideForPlayer(playerid, MainMenuTxtdraw[6]);
	TextDrawHideForPlayer(playerid, MainMenuTxtdraw[9]);
	TextDrawHideForPlayer(playerid, MainMenuTxtdraw[10]);

	TextDrawHideForPlayer(playerid, TutTxtdraw[0]);
	TextDrawHideForPlayer(playerid, TutTxtdraw[1]);
	TextDrawHideForPlayer(playerid, TutTxtdraw[2]);
	TextDrawHideForPlayer(playerid, TutTxtdraw[3]);
	TextDrawHideForPlayer(playerid, TutTxtdraw[114]);
}

stock ShowMainMenuGUI(playerid)
{
	InsideMainMenu{playerid} = true;
	MainMenuUpdateForPlayer(playerid);

	TextDrawShowForPlayer(playerid, MainMenuTxtdraw[0]);
	TextDrawShowForPlayer(playerid, MainMenuTxtdraw[1]);
	TextDrawShowForPlayer(playerid, MainMenuTxtdraw[2]);
	TextDrawShowForPlayer(playerid, MainMenuTxtdraw[3]);
	TextDrawShowForPlayer(playerid, MainMenuTxtdraw[4]);
	TextDrawShowForPlayer(playerid, MainMenuTxtdraw[5]);
	TextDrawShowForPlayer(playerid, MainMenuTxtdraw[6]);
	TextDrawShowForPlayer(playerid, MainMenuTxtdraw[9]);
	TextDrawShowForPlayer(playerid, MainMenuTxtdraw[10]);
}

stock HideMainMenuGUI(playerid)
{
	InsideMainMenu{playerid} = false;

	TextDrawHideForPlayer(playerid, MainMenuTxtdraw[0]);
	TextDrawHideForPlayer(playerid, MainMenuTxtdraw[1]);
	TextDrawHideForPlayer(playerid, MainMenuTxtdraw[2]);
	TextDrawHideForPlayer(playerid, MainMenuTxtdraw[3]);
	TextDrawHideForPlayer(playerid, MainMenuTxtdraw[4]);
	TextDrawHideForPlayer(playerid, MainMenuTxtdraw[5]);
	TextDrawHideForPlayer(playerid, MainMenuTxtdraw[6]);
	TextDrawHideForPlayer(playerid, MainMenuTxtdraw[9]);
	TextDrawHideForPlayer(playerid, MainMenuTxtdraw[10]);
}

stock ShowNMuteFine(playerid)
{
	new playername[MAX_PLAYER_NAME];
	GetPlayerName(playerid, playername, sizeof(playername));

	new totalwealth = PlayerInfo[playerid][pAccount] + GetPlayerCash(playerid);
	if(PlayerInfo[playerid][pPhousekey] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[playerid][pPhousekey]][hOwnerID] == GetPlayerSQLId(playerid)) totalwealth += HouseInfo[PlayerInfo[playerid][pPhousekey]][hSafeMoney];
	if(PlayerInfo[playerid][pPhousekey2] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[playerid][pPhousekey2]][hOwnerID] == GetPlayerSQLId(playerid)) totalwealth += HouseInfo[PlayerInfo[playerid][pPhousekey2]][hSafeMoney];
	if(PlayerInfo[playerid][pPhousekey3] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[playerid][pPhousekey3]][hOwnerID] == GetPlayerSQLId(playerid)) totalwealth += HouseInfo[PlayerInfo[playerid][pPhousekey3]][hSafeMoney];

    new fine = 10*totalwealth/100;
	if(PlayerInfo[playerid][pNMuteTotal] < 4)
	{
		new string[64];
		format(string,sizeof(string),"Jail for %d Minutes\nCash Fine ($%d)",PlayerInfo[playerid][pNMuteTotal] * 15, fine);
		ShowPlayerDialog(playerid,NMUTE,DIALOG_STYLE_LIST,"Newbie Chat Unmute - Select your Punishment:",string,"Select","Cancel");
	}
	else if(PlayerInfo[playerid][pNMuteTotal] == 4) ShowPlayerDialog(playerid,NMUTE,DIALOG_STYLE_LIST,"Newbie Chat Unmute - Select your Punishment:","Prison for 1 Hour","Select","Cancel");
	else if(PlayerInfo[playerid][pNMuteTotal] == 5) ShowPlayerDialog(playerid,NMUTE,DIALOG_STYLE_LIST,"Newbie Chat Unmute - Select your Punishment:","Prison for 1 Hour and 15 Minutes","Select","Cancel");
	else if(PlayerInfo[playerid][pNMuteTotal] == 6) ShowPlayerDialog(playerid,NMUTE,DIALOG_STYLE_LIST,"Newbie Chat Unmute - Select your Punishment:","Prison for 1 Hour and 30 Minutes","Select","Cancel");
}

stock ShowAdMuteFine(playerid)
{
	new string[128];
	new playername[MAX_PLAYER_NAME];
	GetPlayerName(playerid, playername, sizeof(playername));

	new totalwealth = PlayerInfo[playerid][pAccount] + GetPlayerCash(playerid);
	if(PlayerInfo[playerid][pPhousekey] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[playerid][pPhousekey]][hOwnerID] == GetPlayerSQLId(playerid)) totalwealth += HouseInfo[PlayerInfo[playerid][pPhousekey]][hSafeMoney];
	if(PlayerInfo[playerid][pPhousekey2] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[playerid][pPhousekey2]][hOwnerID] == GetPlayerSQLId(playerid)) totalwealth += HouseInfo[PlayerInfo[playerid][pPhousekey2]][hSafeMoney];
	if(PlayerInfo[playerid][pPhousekey3] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[playerid][pPhousekey3]][hOwnerID] == GetPlayerSQLId(playerid)) totalwealth += HouseInfo[PlayerInfo[playerid][pPhousekey3]][hSafeMoney];

    new fine = 10*totalwealth/100;
	if(PlayerInfo[playerid][pADMuteTotal] < 4)
	{
		format(string,sizeof(string),"Jail for %d Minutes\nCash Fine ($%d)",PlayerInfo[playerid][pADMuteTotal]*15,fine);
	}
	if(PlayerInfo[playerid][pADMuteTotal] == 4)
	{
	    format(string,sizeof(string),"Prison for 1 Hour");
	}
	if(PlayerInfo[playerid][pADMuteTotal] == 5)
	{
	    format(string,sizeof(string),"Prison for 1 Hour and 15 Minutes)");
	}
	if(PlayerInfo[playerid][pADMuteTotal] == 6)
	{
	    format(string,sizeof(string),"Prison for 1 Hour and 30 Minutes");
	}
	ShowPlayerDialog(playerid,ADMUTE,DIALOG_STYLE_LIST,"Advertisements Unmute - Select your Punishment:",string,"Select","Cancel");
}

stock TurfWarsEditTurfsSelection(playerid)
{
	new string[4096];
	for(new i = 0; i < MAX_TURFS; i++)
	{
		if(TurfWars[i][twOwnerId] != -1)
		{
			if(TurfWars[i][twOwnerId] < 0 || TurfWars[i][twOwnerId] > MAX_FAMILY-1)
			{
				format(string,sizeof(string),"%s%d) %s - (Invalid Family)\n",string,i,TurfWars[i][twName]);
			}
			else
			{
				format(string,sizeof(string),"%s%d) %s - (%s)\n",string,i,TurfWars[i][twName],FamilyInfo[TurfWars[i][twOwnerId]][FamilyName]);
			}
		}
		else
		{
			format(string,sizeof(string),"%s%d) %s - (%s)\n",string,i,TurfWars[i][twName],"Vacant");
		}
	}
	ShowPlayerDialog(playerid,TWEDITTURFSSELECTION,DIALOG_STYLE_LIST,"Turf Wars - Edit Turfs Selection Menu:",string,"Select","Back");
}

stock TurfWarsEditFColorsSelection(playerid)
{
	new string[1024];
	for(new i = 1; i < MAX_FAMILY; i++)
	{
	    format(string,sizeof(string),"%s (ID: %d) %s - (%d)\n",string,i,FamilyInfo[i][FamilyName],FamilyInfo[i][FamilyColor]);
	}
	ShowPlayerDialog(playerid,TWEDITFCOLORSSELECTION,DIALOG_STYLE_LIST,"Turf Wars - Edit Family Colors Selection:",string,"Select","Back");
}

stock PaintballEditMenu(playerid)
{
	new string[1024], status[64];
	for(new i = 0; i < MAX_ARENAS; i++)
	{
	    if(PaintBallArena[i][pbLocked] == 0)
 	    {
 	        format(status,sizeof(status),"Open");
 	    }
 	    if(PaintBallArena[i][pbLocked] == 1)
 	    {
 	        format(status,sizeof(status),"Active");
 	    }
 	    if(PaintBallArena[i][pbLocked] == 2)
 	    {
 	        format(status,sizeof(status),"Closed");
 	    }
 	    if(PaintBallArena[i][pbLocked] == 3)
 	    {
 	        format(status,sizeof(status),"Setup");
 	    }
		format(string,sizeof(string),"%s%s - \t(%s)\n",string,PaintBallArena[i][pbArenaName],status);
	}
	ShowPlayerDialog(playerid,PBEDITMENU,DIALOG_STYLE_LIST,"Paintball Arena - Edit Menu:",string,"Select","Back");
}

stock PaintballEditArenaMenu(playerid)
{
	if(GetPVarInt(playerid, "ArenaNumber") == -1) { return 1; }
	new string[1024];
	new arenaid = GetPVarInt(playerid, "ArenaNumber");
	format(string,sizeof(string),"Edit Arena Name - (%s)\nEdit Deathmatch Positions...\nEdit Team Positions...\nEdit Flag Positions...\nEdit Hill Position...\nHill Radius (%f)\nInterior (%d)\nVirtual World (%d)\nWar Vehicle 1\nWar Vehicle 2\nWar Vehicle 3\nWar Vehicle 4\nWar Vehicle 5\nWar Vehicle 6",PaintBallArena[arenaid][pbArenaName],PaintBallArena[arenaid][pbHillRadius],PaintBallArena[arenaid][pbInterior],PaintBallArena[arenaid][pbVirtual]);
	ShowPlayerDialog(playerid,PBEDITARENAMENU,DIALOG_STYLE_LIST,"Paintball Arena - Edit Arena Menu:",string,"Select","Back");
	return 1;
}

stock PaintballEditArenaName(playerid)
{
	if(GetPVarInt(playerid, "ArenaNumber") == -1) { return 1; }
	new string[128];
	new arenaid = GetPVarInt(playerid, "ArenaNumber");
	format(string,sizeof(string),"Enter a new Arena Name for Arena Slot %d:",arenaid);
	ShowPlayerDialog(playerid,PBEDITARENANAME,DIALOG_STYLE_INPUT,"Paintball Arena - Edit Arena Name:",string,"Change","Back");
	return 1;
}

stock PaintballEditArenaDMSpawns(playerid)
{
    if(GetPVarInt(playerid, "ArenaNumber") == -1) { return 1; }
	ShowPlayerDialog(playerid,PBEDITARENADMSPAWNS,DIALOG_STYLE_LIST,"Paintball Arena - Edit Arena DM Spawns:","Deathmatch Spawn 1\nDeathmatch Spawn 2\nDeathmatch Spawn 3\nDeathmatch Spawn 4","Change","Back");
	return 1;
}

stock PaintballEditArenaTeamSpawns(playerid)
{
	if(GetPVarInt(playerid, "ArenaNumber") == -1) { return 1; }
	ShowPlayerDialog(playerid,PBEDITARENATEAMSPAWNS,DIALOG_STYLE_LIST,"Paintball Arena - Edit Arena Team Spawns:","Red Team Spawn 1\nRed Team Spawn 2\nRed Team Spawn 3\nBlue Team Spawn 1\nBlue Team Spawn 2\nBlue Team Spawn 3","Change","Back");
	return 1;
}

stock PaintballEditArenaFlagSpawns(playerid)
{
	if(GetPVarInt(playerid, "ArenaNumber") == -1) { return 1; }
	ShowPlayerDialog(playerid,PBEDITARENAFLAGSPAWNS,DIALOG_STYLE_LIST,"Paintball Arena - Edit Arena Flag Spawns:","Red Team Flag\nBlue Team Flag","Change","Back");
	return 1;
}

stock PaintballEditArenaInt(playerid)
{
	if(GetPVarInt(playerid, "ArenaNumber") == -1) { return 1; }
	ShowPlayerDialog(playerid,PBEDITARENAINT,DIALOG_STYLE_INPUT,"Paintball Arena - Edit Arena Interior:","Please enter a new interior id to place on the Arena:","Change","Back");
	return 1;
}

stock PaintballEditArenaVW(playerid)
{
	if(GetPVarInt(playerid, "ArenaNumber") == -1) { return 1; }
	ShowPlayerDialog(playerid,PBEDITARENAVW,DIALOG_STYLE_INPUT,"Paintball Arena - Edit Arena Virtual World:","Please enter a new virtual world id to place on the Arena:","Change","Back");
	return 1;
}

stock PaintballEditArenaHillRadius(playerid)
{
	if(GetPVarInt(playerid, "ArenaNumber") == -1) { return 1; }
	ShowPlayerDialog(playerid,PBEDITARENAHILLRADIUS,DIALOG_STYLE_INPUT,"Paintball Arena - Edit Arena Hill Radius:","Please enter a new hill radius for the Arena:","Change","Back");
	return 1;
}

stock PaintballScoreboard(playerid, arenaid)
{
	if(GetPVarInt(playerid, "IsInArena") == -1) { return 1; }
	new titlestring[128];
	new string[2048];
 	foreach(new p: Player)
	{
		if(GetPVarInt(p, "IsInArena") == arenaid)
		{
			if(PaintBallArena[arenaid][pbGameType] == 1)
			{
				format(string,sizeof(string),"%s(ID: %d) %s - (Kills: %d) (Deaths: %d) (Ping: %d)\n", string, p, GetPlayerNameEx(p),PlayerInfo[p][pKills],PlayerInfo[p][pDeaths],GetPlayerPing(p));
			}
			if(PaintBallArena[arenaid][pbGameType] == 2 || PaintBallArena[arenaid][pbGameType] == 3)
			{
				switch(PlayerInfo[p][pPaintTeam])
				{
					case 1: // Red Team
					{
						format(string,sizeof(string),"%s(ID: %d) ({FF0000}Red Team{FFFFFF}) %s - (Points: %d) (Ping: %d)\n", string, p, GetPlayerNameEx(p),PlayerInfo[p][pKills],GetPlayerPing(p));
					}
					case 2: // Blue Team
					{
						format(string,sizeof(string),"%s(ID: %d) ({0000FF}Blue Team{FFFFFF}) %s - (Points: %d) (Ping: %d)\n", string, p, GetPlayerNameEx(p),PlayerInfo[p][pKills],GetPlayerPing(p));
					}
				}
			}
			if(PaintBallArena[arenaid][pbGameType] == 4)
			{
				format(string,sizeof(string),"%s(ID: %d) %s - (Points: %d) (Ping: %d)\n", string, p, GetPlayerNameEx(p),PlayerInfo[p][pKills],GetPlayerPing(p));
			}
			if(PaintBallArena[arenaid][pbGameType] == 5)
			{
				switch(PlayerInfo[p][pPaintTeam])
				{
					case 1: // Red Team
					{
						format(string,sizeof(string),"%s(ID: %d) ({FF0000}Red Team{FFFFFF}) %s - (Points: %d) (Ping: %d)\n", string, p, GetPlayerNameEx(p),PlayerInfo[p][pKills],GetPlayerPing(p));
					}
					case 2: // Blue Team
					{
						format(string,sizeof(string),"%s(ID: %d) ({0000FF}Blue Team{FFFFFF}) %s - (Points: %d) (Ping: %d)\n", string, p, GetPlayerNameEx(p),PlayerInfo[p][pKills],GetPlayerPing(p));
					}
				}
			}
		}
	}	
	switch (PaintBallArena[arenaid][pbGameType])
	{
		case 1: // Deathmatch
		{
			format(titlestring,sizeof(titlestring),"(DM) Scoreboard - Time Left: (%d)",PaintBallArena[arenaid][pbTimeLeft]);
		}
		case 2: // Team Deathmatch
		{
		    format(titlestring,sizeof(titlestring),"(TDM) Scoreboard - Red: (%d) - Blue: (%d) - Time Left: (%d)",
			PaintBallArena[arenaid][pbTeamRedKills],
			PaintBallArena[arenaid][pbTeamBlueKills],
			PaintBallArena[arenaid][pbTimeLeft]);
		}
		case 3: // Capture The Flag
		{
		    format(titlestring,sizeof(titlestring),"(CTF) Scoreboard - Red: (%d) - Blue: (%d) - Time Left: (%d)",PaintBallArena[arenaid][pbTeamRedScores],PaintBallArena[arenaid][pbTeamBlueScores],PaintBallArena[arenaid][pbTimeLeft]);
		}
		case 4: // King of the Hill
		{
		    format(titlestring,sizeof(titlestring),"(KOTH) Scoreboard - Time Left: (%d)",PaintBallArena[arenaid][pbTimeLeft]);
		}
		case 5: // Team King of the Hill
		{
		    format(titlestring,sizeof(titlestring),"(TKOTH) Scoreboard - Red: (%d) - Blue: (%d) - Time Left (%d)",PaintBallArena[arenaid][pbTeamRedScores],PaintBallArena[arenaid][pbTeamBlueScores],PaintBallArena[arenaid][pbTimeLeft]);
		}
	}
	ShowPlayerDialog(playerid,PBARENASCORES,DIALOG_STYLE_LIST,titlestring,string,"Update","Close");
	return 1;
}

stock PaintballArenaSelection(playerid)
{
	new string[2048], status[64], gametype[64], eperm[64], war[32], limit, count, money;
 	for(new i = 0; i < MAX_ARENAS; i++) if(!isnull(PaintBallArena[i][pbArenaName]))
 	{
 	    limit = PaintBallArena[i][pbLimit];
 	    count = PaintBallArena[i][pbPlayers];
 	    money = PaintBallArena[i][pbBidMoney];

 	    if(PaintBallArena[i][pbLocked] == 0)
 	    {
 	        format(status,sizeof(status),"{00FF00}Open{FFFFFF}");
 	    }
 	    if(PaintBallArena[i][pbLocked] == 1)
 	    {
 	        format(status,sizeof(status),"{00FF00}Active{FFFFFF}");
 	    }
 	    if(PaintBallArena[i][pbLocked] == 2)
 	    {
 	        format(status,sizeof(status),"{FF0000}Closed{FFFFFF}");
 	    }
 	    if(PaintBallArena[i][pbLocked] == 3)
 	    {
 	        format(status,sizeof(status),"{FF6600}Setup{FFFFFF}");
 	    }

 	    if(PaintBallArena[i][pbGameType] == 1)
 	    {
 	        format(gametype,sizeof(gametype),"DM");
		}
		if(PaintBallArena[i][pbGameType] == 2)
		{
		    format(gametype,sizeof(gametype),"TDM");
		}
		if(PaintBallArena[i][pbGameType] == 3)
		{
		    format(gametype,sizeof(gametype),"CTF");
		}
		if(PaintBallArena[i][pbGameType] == 4)
		{
		    format(gametype,sizeof(gametype),"KOTH");
		}
		if(PaintBallArena[i][pbGameType] == 5)
		{
		    format(gametype,sizeof(gametype),"TKOTH");
		}

		if(PaintBallArena[i][pbExploitPerm] == 0)
		{
		    format(eperm,sizeof(eperm),"{FF0000}No QS/CS{FFFFFF}");
		}
		if(PaintBallArena[i][pbExploitPerm] == 1)
		{
		    format(eperm,sizeof(eperm),"{00FF00}QS/CS{FFFFFF}");
		}
		
		if(PaintBallArena[i][pbWar] == 0)
		{
			format(war, sizeof(war), "");
		}
		if(PaintBallArena[i][pbWar] == 1)
		{
			format(war, sizeof(war), " ({FFFF00}War{FFFFFF})");
		}

		if(!strcmp(PaintBallArena[i][pbPassword], "None", false))
		{
 	    	format(string,sizeof(string),"%s{FFFFFF}%s - \t(%s) (%s) (%s) (%d/%d) ($%d) (%s)%s\n",string,PaintBallArena[i][pbArenaName],PaintBallArena[i][pbOwner],status,gametype,count,limit,money,eperm,war);
		}
		else
		{
		    format(string,sizeof(string),"%s{FFFFFF}%s - \t(%s) (%s) (%s) (%d/%d) ($%d) (%s)%s (PW)\n",string,PaintBallArena[i][pbArenaName],PaintBallArena[i][pbOwner],status,gametype,count,limit,money,eperm,war);
		}
	}
	ShowPlayerDialog(playerid,PBARENASELECTION,DIALOG_STYLE_LIST,"Paintball Arena - Choose a Arena:",string,"Select","Back");
}

stock PaintballTokenBuyMenu(playerid)
{
	new string[150];
	format(string,sizeof(string),"{FFFFFF}How many Paintball Tokens do you wish to purchase?\n\nEach token costs a total of $%d. You currently have {AA3333}%d{FFFFFF} Tokens.", 5000, PlayerInfo[playerid][pPaintTokens]);
	ShowPlayerDialog(playerid,PBTOKENBUYMENU,DIALOG_STYLE_INPUT,"Paintball Arena - Paintball Tokens:",string,"Buy","Back");
}

stock PaintballSetupArena(playerid)
{
	new string[1024], gametype[32], password[64], wepname1[128], wepname2[128], wepname3[128], eperm[64], finstagib[64], fnoweapons[64], war[32];
	new timelimit, limit, money, Float:health, Float:armor, wep1, wep2, wep3;
	new a = GetPVarInt(playerid, "ArenaNumber");

	format(password,sizeof(password),"%s", PaintBallArena[a][pbPassword]);
	timelimit = PaintBallArena[a][pbTimeLeft]/60;
	limit = PaintBallArena[a][pbLimit];
	money = PaintBallArena[a][pbBidMoney];
	health = PaintBallArena[a][pbHealth];
	armor = PaintBallArena[a][pbArmor];
	wep1 = PaintBallArena[a][pbWeapons][0];
	wep2 = PaintBallArena[a][pbWeapons][1];
	wep3 = PaintBallArena[a][pbWeapons][2];

	GetWeaponName(wep1,wepname1,sizeof(wepname1));
	GetWeaponName(wep2,wepname2,sizeof(wepname2));
	GetWeaponName(wep3,wepname3,sizeof(wepname3));

	if(PaintBallArena[a][pbGameType] == 1)
	{
		format(gametype,sizeof(gametype),"DM");
	}
	if(PaintBallArena[a][pbGameType] == 2)
	{
	    format(gametype,sizeof(gametype),"TDM");
	}
	if(PaintBallArena[a][pbGameType] == 3)
	{
	    format(gametype,sizeof(gametype),"CTF");
	}
	if(PaintBallArena[a][pbGameType] == 4)
	{
	    format(gametype,sizeof(gametype),"KOTH");
	}
	if(PaintBallArena[a][pbGameType] == 5)
	{
	    format(gametype,sizeof(gametype),"TKOTH");
	}

	if(PaintBallArena[a][pbExploitPerm] == 0)
	{
		format(eperm,sizeof(eperm),"Not Allowed");
	}
	if(PaintBallArena[a][pbExploitPerm] == 1)
	{
	    format(eperm,sizeof(eperm),"Allowed");
	}

	if(PaintBallArena[a][pbFlagInstagib] == 0)
	{
	    format(finstagib,sizeof(finstagib),"Off");
	}
	if(PaintBallArena[a][pbFlagInstagib] == 1)
	{
	    format(finstagib,sizeof(finstagib),"On");
	}

	if(PaintBallArena[a][pbFlagNoWeapons] == 0)
	{
	    format(fnoweapons,sizeof(fnoweapons),"Off");
	}
	if(PaintBallArena[a][pbFlagNoWeapons] == 1)
	{
	    format(fnoweapons,sizeof(fnoweapons),"On");
	}
	if(PaintBallArena[a][pbWar] == 0)
	{
		format(war, sizeof(war), "Off");
	}
	if(PaintBallArena[a][pbWar] == 1)
	{
		format(war, sizeof(war), "On");
	}

	switch(PaintBallArena[a][pbGameType])
	{
	    case 1:
	    {
	        format(string,sizeof(string),"Password - (%s)\nGameType - (%s)\nLimit - (%d)\nTime Limit - (%d Minutes)\nBid Money - ($%d)\nHealth - (%.2f)\nArmor - (%.2f)\nWeapons Slot 1 - (%s)\nWeapons Slot 2 - (%s)\nWeapons Slot 3 - (%s)\nQS/CS - (%s)\nWar - (%s)\nBegin Arena",password,gametype,limit,timelimit,money,health,armor,wepname1,wepname2,wepname3,eperm,war);
	    }
	    case 2:
	    {
	        format(string,sizeof(string),"Password - (%s)\nGameType - (%s)\nLimit - (%d)\nTime Limit - (%d Minutes)\nBid Money - ($%d)\nHealth - (%.2f)\nArmor - (%.2f)\nWeapons Slot 1 - (%s)\nWeapons Slot 2 - (%s)\nWeapons Slot 3 - (%s)\nQS/CS - (%s)\nWar - (%s)\nBegin Arena",password,gametype,limit,timelimit,money,health,armor,wepname1,wepname2,wepname3,eperm,war);
	    }
	    case 3:
	    {
	        format(string,sizeof(string),"Password - (%s)\nGameType - (%s)\nLimit - (%d)\nTime Limit - (%d Minutes)\nBid Money - ($%d)\nHealth - (%.2f)\nArmor - (%.2f)\nWeapons Slot 1 - (%s)\nWeapons Slot 2 - (%s)\nWeapons Slot 3 - (%s)\nQS/CS - (%s)\nWar - (%s)\nFlag Instagib - (%s)\nFlag No Weapons - (%s)\nBegin Arena",password,gametype,limit,timelimit,money,health,armor,wepname1,wepname2,wepname3,eperm,war,finstagib,fnoweapons);
	    }
	    case 4:
	    {
	        format(string,sizeof(string),"Password - (%s)\nGameType - (%s)\nLimit - (%d)\nTime Limit - (%d Minutes)\nBid Money - ($%d)\nHealth - (%.2f)\nArmor - (%.2f)\nWeapons Slot 1 - (%s)\nWeapons Slot 2 - (%s)\nWeapons Slot 3 - (%s)\nQS/CS - (%s)\nWar - (%s)\nBegin Arena",password,gametype,limit,timelimit,money,health,armor,wepname1,wepname2,wepname3,eperm,war);
	    }
	    case 5:
	    {
	        format(string,sizeof(string),"Password - (%s)\nGameType - (%s)\nLimit - (%d)\nTime Limit - (%d Minutes)\nBid Money - ($%d)\nHealth - (%.2f)\nArmor - (%.2f)\nWeapons Slot 1 - (%s)\nWeapons Slot 2 - (%s)\nWeapons Slot 3 - (%s)\nQS/CS - (%s)\nWar - (%s)\nBegin Arena",password,gametype,limit,timelimit,money,health,armor,wepname1,wepname2,wepname3,eperm,war);
	    }
	}
	ShowPlayerDialog(playerid,PBSETUPARENA,DIALOG_STYLE_LIST,"Paintball Arena - Setup Arena:",string,"Select","Leave");
}

stock PaintballSwitchTeam(playerid)
{
	new arenaid = GetPVarInt(playerid, "IsInArena");
	new teamlimit = PaintBallArena[arenaid][pbLimit]/2;
	new string[128];
	format(string,sizeof(string),"{FF0000}Red Team (%d/%d)\n{0000FF}Blue Team (%d/%d)",PaintBallArena[arenaid][pbTeamRed],teamlimit,PaintBallArena[arenaid][pbTeamBlue],teamlimit);
	ShowPlayerDialog(playerid,PBSWITCHTEAM,DIALOG_STYLE_LIST,"Paintball Arena - Choose a Team:",string,"Switch","Cancel");
}

stock SendBugMessage(member, string[])
{
    if(!(0 <= member < MAX_GROUPS))
        return 0;

	new iGroupID;
	foreach(new i: Player)
	{
		iGroupID = PlayerInfo[i][pMember];
		if(iGroupID == member && PlayerInfo[i][pRank] >= arrGroupData[iGroupID][g_iBugAccess] && gBug{i} == 1)	{
			SendClientMessageEx(i, COLOR_LIGHTGREEN, string);
		}
	}	
	return 1;
}

/*stock ReplacePH(oldph, newph)
{
    #pragma unused oldph
    #pragma unused newph
    new File: file2 = fopen("tmpPHList.cfg", io_write);
    new number;
    new string[32];
    new PHList[32];
    format(string, sizeof(string), "%d\r\n", newph);
    fwrite(file2, string);
    fclose(file2);
    file2 = fopen("tmpPHList.cfg", io_append);
    if(fexist("PHList.cfg"))
	{
		new File: file = fopen("PHList.cfg", io_read);
	    while(fread(file, string))
		{
	        strmid(PHList, string, 0, strlen(string)-1, 255);
	        number = strval(PHList);
	    	if (number != oldph)
			{
	            format(string, sizeof(string), "%d\r\n", number);
	        	fwrite(file2, string);
	    	}
	    }
	    fclose(file);
	    fclose(file2);
	    file2 = fopen("PHList.cfg", io_write);
	    file = fopen("tmpPHList.cfg", io_read);
		while(fread(file, string))
		{
	        strmid(PHList, string, 0, strlen(string)-1, 255);
	        number = strval(PHList);
	        if (number != oldph)
			{
	            format(string, sizeof(string), "%d\r\n", number);
	        	fwrite(file2, string);
	    	}
	    }
	    fclose(file);
	    fclose(file2);
		fremove("tmpPHList.cfg");
	}
	return 1;
}*/


stock SearchingHit(playerid)
{
	new string[128], group = PlayerInfo[playerid][pMember];
   	SendClientMessageEx(playerid, COLOR_WHITE, "Available Contracts:");
   	new hits;
	foreach(new i: Player)
	{
		if(!IsAHitman(i) && PlayerInfo[i][pHeadValue] > 0)
		{
			if(GotHit[i] == 0)
			{
				hits++;
				format(string, sizeof(string), "%s (ID %d) | $%s | Placed By: %s | Reason: %s | Chased By: Nobody", GetPlayerNameEx(i), i, number_format(PlayerInfo[i][pHeadValue]), PlayerInfo[i][pContractBy], PlayerInfo[i][pContractDetail]);
				SendClientMessageEx(playerid, COLOR_GRAD2, string);
			}
			else
			{
				format(string, sizeof(string), "%s (ID %d) | $%s | Placed By: %s | Reason: %s | Chased By: %s", GetPlayerNameEx(i), i, number_format(PlayerInfo[i][pHeadValue]), PlayerInfo[i][pContractBy], PlayerInfo[i][pContractDetail], GetPlayerNameEx(GetChased[i]));
				SendClientMessageEx(playerid, COLOR_GRAD2, string);
			}
		}
	}	
	if(hits && PlayerInfo[playerid][pRank] <= 1 && arrGroupData[group][g_iGroupType] == GROUP_TYPE_CONTRACT)
	{
		SendClientMessageEx(playerid, COLOR_YELLOW, "Use /givemehit to assign a contract to yourself.");
	}
	if(hits && PlayerInfo[playerid][pRank] >= 6 && arrGroupData[group][g_iGroupType] == GROUP_TYPE_CONTRACT)
	{
		SendClientMessageEx(playerid, COLOR_YELLOW, "Use /givehit to assign a contract to one of the hitmen.");
	}
	if(hits == 0)
	{
	    SendClientMessageEx(playerid, COLOR_GREY, "There are no hits available.");
	}
	return 0;
}

stock GetWeaponSlot(weaponid)
{
	switch( weaponid )
	{
		case 0, 1:
		{
			return 0;
		}
		case 2, 3, 4, 5, 6, 7, 8, 9:
		{
			return 1;
		}
		case 22, 23, 24:
		{
			return 2;
		}
		case 25, 26, 27:
		{
			return 3;
		}
		case 28, 29, 32:
		{
			return 4;
		}
		case 30, 31:
		{
			return 5;
		}
		case 33, 34:
		{
			return 6;
		}
		case 35, 36, 37, 38:
		{
			return 7;
		}
		case 16, 17, 18, 39, 40:
		{
			return 8;
		}
		case 41, 42, 43:
		{
			return 9;
		}
		case 10, 11, 12, 13, 14, 15:
		{
			return 10;
		}
		case 44, 45, 46:
		{
			return 11;
		}
	}
	return 0;
}


stock ExecuteHackerAction( playerid, weaponid )
{
	if(!gPlayerLogged{playerid}) { return 1; }
	if(PlayerInfo[playerid][pTut] == 0) { return 1; }
	if(playerTabbed[playerid] >= 1) { return 1; }
	if(GetPVarInt(playerid, "IsInArena") >= 0) { return 1; }

	new String[ 128 ], WeaponName[ 128 ];
	GetWeaponName( weaponid, WeaponName, sizeof( WeaponName ) );

	format( String, sizeof( String ), "{AA3333}AdmWarning{FFFF00}: %s (ID %d) may possibly be weapon hacking (%s).", GetPlayerNameEx(playerid), playerid, WeaponName );
	ABroadCast( COLOR_YELLOW, String, 2 );
	format(String, sizeof(String), "%s(%d) (ID %d) may possibly be weapon hacking (%s)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), playerid, WeaponName);
	Log("logs/hack.log", String);

	return 1;
}

stock IsValidIP(ip[])
{
    new a;
	for (new i = 0; i < strlen(ip); i++)
	{
		if (ip[i] == '.')
		{
		    a++;
		}
	}
	if (a != 3)
	{
	    return 1;
	}
	return 0;
}

stock GetPlayersName(playerid)
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	return name;
}

stock IsValidSkin(skinid)
{
	if (skinid < 0 || skinid > 299)
	    return 0;

	switch (skinid)
	{
	    case
		0, 105, 106, 107, 102, 103, 69, 123,
		104, 114, 115, 116, 174, 175, 100, 247, 173,
		248, 117, 118, 147, 163, 21, 24, 143, 71,
		156, 176, 177, 108, 109, 110, 165, 166,
		265, 266, 267, 269, 270, 271, 274, 276,
		277, 278, 279, 280, 281, 282, 283, 284,
		285, 286, 287, 288, 294, 296, 297: return 0;
	}

	return 1;
}

stock IsFemaleSpawnSkin(skinid)
{
	switch (skinid)
	{
	    case
		9, 11, 12, 13, 31, 38, 39, 40, 41, 53, 54,
		55, 56, 65, 76, 77, 89, 91, 93, 129, 130,
		131, 141, 148, 150, 151, 157, 169, 172, 190,
		191, 192, 193, 194, 195, 196, 197, 198, 199,
		211, 214, 215, 216, 218, 219, 224, 225, 226,
		231, 232, 233, 263, 298: return 1;
	}

	return 0;
}

stock IsFemaleSkin(skinid)
{
	switch (skinid)
	{
	    case
		9, 11, 12, 13, 31, 38, 39, 40, 41, 53, 54, 55,
		56, 63, 64, 65, 75, 76, 77, 85, 87, 88, 89, 90,
		91, 92, 93, 129, 130, 131, 138, 139, 140, 141,
		145, 148, 150, 151, 152, 157, 169, 172, 178, 190,
		191, 192, 193, 194, 195, 196, 197, 198, 199, 201,
		205, 207, 211, 214, 215, 216, 218, 219, 224, 225,
		226, 231, 232, 233, 237, 238, 243, 244, 245, 246,
		251, 256, 257, 263, 298: return 1;
	}

	return 0;
}

/*
stock IsPlayerInRangeOfCharm(playerid)
{
	if (ActiveCharmPoint == -1 || !IsValidDynamicPickup(ActiveCharmPointPickup))
		return false;

	new Float:x, Float:y, Float:z, vw, int;
	x = CharmPoints[ActiveCharmPoint][0];
	y = CharmPoints[ActiveCharmPoint][1];
	z = CharmPoints[ActiveCharmPoint][2];

	switch (ActiveCharmPoint)
	{
		case 0:
		{
			vw = 123051;
			int = 1;
		}

		case 1:
		{
			vw = 100078;
			int = 17;
		}

		case 2:
		{
			vw = 2345;
			int = 1;
		}

		case 3:
		{
			vw = 100084;
			int = 1;
		}

		case 4:
		{
			vw = 20083;
			int = 11;
		}
	}

	if (GetPlayerVirtualWorld(playerid) == vw && GetPlayerInterior(playerid) == int && IsPlayerInRangeOfPoint(playerid, 1.0, x, y, z))
	{
		return true;
	}

	return false;
} */

stock PlayerFacePlayer( playerid, targetplayerid )
{
	new Float: Angle;
	GetPlayerFacingAngle( playerid, Angle );
	SetPlayerFacingAngle( targetplayerid, Angle+180 );
	return true;
}

stock GivePlayerEventWeapons( playerid )
{
	if( GetPVarInt( playerid, "EventToken" ) == 1 )
	{
		GivePlayerWeapon( playerid, EventKernel[ EventWeapons ][ 0 ], 60000 );
		GivePlayerWeapon( playerid, EventKernel[ EventWeapons ][ 1 ], 60000 );
		GivePlayerWeapon( playerid, EventKernel[ EventWeapons ][ 2 ], 60000 );
		GivePlayerWeapon( playerid, EventKernel[ EventWeapons ][ 3 ], 60000 );
		GivePlayerWeapon( playerid, EventKernel[ EventWeapons ][ 4 ], 60000 );
	}

	return 1;
}

stock crc32(string[])
{
	new crc_table[256] = {
			0x00000000, 0x77073096, 0xEE0E612C, 0x990951BA, 0x076DC419, 0x706AF48F, 0xE963A535,
			0x9E6495A3, 0x0EDB8832, 0x79DCB8A4, 0xE0D5E91E, 0x97D2D988, 0x09B64C2B, 0x7EB17CBD,
			0xE7B82D07, 0x90BF1D91, 0x1DB71064, 0x6AB020F2, 0xF3B97148, 0x84BE41DE, 0x1ADAD47D,
			0x6DDDE4EB, 0xF4D4B551, 0x83D385C7, 0x136C9856, 0x646BA8C0, 0xFD62F97A, 0x8A65C9EC,
			0x14015C4F, 0x63066CD9, 0xFA0F3D63, 0x8D080DF5, 0x3B6E20C8, 0x4C69105E, 0xD56041E4,
			0xA2677172, 0x3C03E4D1, 0x4B04D447, 0xD20D85FD, 0xA50AB56B, 0x35B5A8FA, 0x42B2986C,
			0xDBBBC9D6, 0xACBCF940, 0x32D86CE3, 0x45DF5C75, 0xDCD60DCF, 0xABD13D59, 0x26D930AC,
			0x51DE003A, 0xC8D75180, 0xBFD06116, 0x21B4F4B5, 0x56B3C423, 0xCFBA9599, 0xB8BDA50F,
			0x2802B89E, 0x5F058808, 0xC60CD9B2, 0xB10BE924, 0x2F6F7C87, 0x58684C11, 0xC1611DAB,
			0xB6662D3D, 0x76DC4190, 0x01DB7106, 0x98D220BC, 0xEFD5102A, 0x71B18589, 0x06B6B51F,
			0x9FBFE4A5, 0xE8B8D433, 0x7807C9A2, 0x0F00F934, 0x9609A88E, 0xE10E9818, 0x7F6A0DBB,
			0x086D3D2D, 0x91646C97, 0xE6635C01, 0x6B6B51F4, 0x1C6C6162, 0x856530D8, 0xF262004E,
			0x6C0695ED, 0x1B01A57B, 0x8208F4C1, 0xF50FC457, 0x65B0D9C6, 0x12B7E950, 0x8BBEB8EA,
			0xFCB9887C, 0x62DD1DDF, 0x15DA2D49, 0x8CD37CF3, 0xFBD44C65, 0x4DB26158, 0x3AB551CE,
			0xA3BC0074, 0xD4BB30E2, 0x4ADFA541, 0x3DD895D7, 0xA4D1C46D, 0xD3D6F4FB, 0x4369E96A,
			0x346ED9FC, 0xAD678846, 0xDA60B8D0, 0x44042D73, 0x33031DE5, 0xAA0A4C5F, 0xDD0D7CC9,
			0x5005713C, 0x270241AA, 0xBE0B1010, 0xC90C2086, 0x5768B525, 0x206F85B3, 0xB966D409,
			0xCE61E49F, 0x5EDEF90E, 0x29D9C998, 0xB0D09822, 0xC7D7A8B4, 0x59B33D17, 0x2EB40D81,
			0xB7BD5C3B, 0xC0BA6CAD, 0xEDB88320, 0x9ABFB3B6, 0x03B6E20C, 0x74B1D29A, 0xEAD54739,
			0x9DD277AF, 0x04DB2615, 0x73DC1683, 0xE3630B12, 0x94643B84, 0x0D6D6A3E, 0x7A6A5AA8,
			0xE40ECF0B, 0x9309FF9D, 0x0A00AE27, 0x7D079EB1, 0xF00F9344, 0x8708A3D2, 0x1E01F268,
			0x6906C2FE, 0xF762575D, 0x806567CB, 0x196C3671, 0x6E6B06E7, 0xFED41B76, 0x89D32BE0,
			0x10DA7A5A, 0x67DD4ACC, 0xF9B9DF6F, 0x8EBEEFF9, 0x17B7BE43, 0x60B08ED5, 0xD6D6A3E8,
			0xA1D1937E, 0x38D8C2C4, 0x4FDFF252, 0xD1BB67F1, 0xA6BC5767, 0x3FB506DD, 0x48B2364B,
			0xD80D2BDA, 0xAF0A1B4C, 0x36034AF6, 0x41047A60, 0xDF60EFC3, 0xA867DF55, 0x316E8EEF,
			0x4669BE79, 0xCB61B38C, 0xBC66831A, 0x256FD2A0, 0x5268E236, 0xCC0C7795, 0xBB0B4703,
			0x220216B9, 0x5505262F, 0xC5BA3BBE, 0xB2BD0B28, 0x2BB45A92, 0x5CB36A04, 0xC2D7FFA7,
			0xB5D0CF31, 0x2CD99E8B, 0x5BDEAE1D, 0x9B64C2B0, 0xEC63F226, 0x756AA39C, 0x026D930A,
			0x9C0906A9, 0xEB0E363F, 0x72076785, 0x05005713, 0x95BF4A82, 0xE2B87A14, 0x7BB12BAE,
			0x0CB61B38, 0x92D28E9B, 0xE5D5BE0D, 0x7CDCEFB7, 0x0BDBDF21, 0x86D3D2D4, 0xF1D4E242,
			0x68DDB3F8, 0x1FDA836E, 0x81BE16CD, 0xF6B9265B, 0x6FB077E1, 0x18B74777, 0x88085AE6,
			0xFF0F6A70, 0x66063BCA, 0x11010B5C, 0x8F659EFF, 0xF862AE69, 0x616BFFD3, 0x166CCF45,
			0xA00AE278, 0xD70DD2EE, 0x4E048354, 0x3903B3C2, 0xA7672661, 0xD06016F7, 0x4969474D,
			0x3E6E77DB, 0xAED16A4A, 0xD9D65ADC, 0x40DF0B66, 0x37D83BF0, 0xA9BCAE53, 0xDEBB9EC5,
			0x47B2CF7F, 0x30B5FFE9, 0xBDBDF21C, 0xCABAC28A, 0x53B39330, 0x24B4A3A6, 0xBAD03605,
			0xCDD70693, 0x54DE5729, 0x23D967BF, 0xB3667A2E, 0xC4614AB8, 0x5D681B02, 0x2A6F2B94,
			0xB40BBE37, 0xC30C8EA1, 0x5A05DF1B, 0x2D02EF8D
	};
	new crc = -1;
	for(new i = 0; i < strlen(string); i++)
	{
 		crc = ( crc >>> 8 ) ^ crc_table[(crc ^ string[i]) & 0xFF];
  	}
  	return crc ^ -1;
}

stock GetPlayerSQLId(playerid)
{
	if(gPlayerLogged{playerid})
	{
		return PlayerInfo[playerid][pId];
	}
	return -1;
}

stock GetPlayerNameExt(playerid)
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	return name;
}

stock GetWeaponNameEx(weaponid)
{
	new name[MAX_PLAYER_NAME];
	GetWeaponName(weaponid, name, sizeof(name));
	return name;
}

stock GetPlayerNameEx(playerid) {

	new
		szName[MAX_PLAYER_NAME],
		iPos;

	GetPlayerName(playerid, szName, MAX_PLAYER_NAME);
	while ((iPos = strfind(szName, "_", false, iPos)) != -1) szName[iPos] = ' ';
	return szName;
}

stock StripUnderscore(string[]) // Doesn't remove underscore from original string any more
{
	new iPos, newstring[128];
	format(newstring, sizeof(newstring), "%s", string);
	while ((iPos = strfind(newstring, "_", false, iPos)) != -1) newstring[iPos] = ' ';
	return newstring;
}

stock GetPlayerIpEx(playerid)
{
    new ip[16];
	GetPlayerIp(playerid, ip, sizeof(ip));
	return ip;
}

stock GetJobName(job)
{
	new name[20];
	switch(job)
	{
		case 1: name = "Detective";
		case 2: name = "Lawyer";
		case 3: name = "Whore";
		case 4: name = "Drugs Dealer";
		case 6: name = "News Reporter";
		case 7: name = "Car Mechanic";
		case 8: name = "Bodyguard";
		case 9: name = "Arms Dealer";
		case 10: name = "Car Dealer";
		case 12: name = "Boxer";
		case 14: name = "Drug Smuggler";
		case 15: name = "Paper Boy";
		case 16: name = "Shipment Contractor";
		case 17: name = "Taxi Driver";
		case 18: name = "Craftsman";
		case 19: name = "Bartender";
		case 20: name = "Shipment Contractor";
		case 21: name = "Pizza Boy";
		default: name = "None";
	}
	return name;
}

stock GetJobLevel(playerid, job)
{
	new jlevel;
	switch(job)
	{
		case 1:
		{
			new skilllevel = PlayerInfo[playerid][pDetSkill];
			if(skilllevel >= 0 && skilllevel < 50) jlevel = 1;
			else if(skilllevel >= 50 && skilllevel < 100) jlevel = 2;
			else if(skilllevel >= 100 && skilllevel < 200) jlevel = 3;
			else if(skilllevel >= 200 && skilllevel < 400) jlevel = 4;
			else if(skilllevel >= 400) jlevel = 5;
		}
		case 2:
		{
			new skilllevel = PlayerInfo[playerid][pLawSkill];
			if(skilllevel >= 0 && skilllevel < 50) jlevel = 1;
			else if(skilllevel >= 50 && skilllevel < 100) jlevel = 2;
			else if(skilllevel >= 100 && skilllevel < 200) jlevel = 3;
			else if(skilllevel >= 200 && skilllevel < 400) jlevel = 4;
			else if(skilllevel >= 400) jlevel = 5;
		}
		case 3:
		{
			new skilllevel = PlayerInfo[playerid][pSexSkill];
			if(skilllevel >= 0 && skilllevel < 50) jlevel = 1;
			else if(skilllevel >= 50 && skilllevel < 100) jlevel = 2;
			else if(skilllevel >= 100 && skilllevel < 200) jlevel = 3;
			else if(skilllevel >= 200 && skilllevel < 400) jlevel = 4;
			else if(skilllevel >= 400) jlevel = 5;
		}
		case 4:
		{
			new skilllevel = PlayerInfo[playerid][pDrugsSkill];
			if(skilllevel >= 0 && skilllevel < 50) jlevel = 1;
			else if(skilllevel >= 50 && skilllevel < 100) jlevel = 2;
			else if(skilllevel >= 100 && skilllevel < 200) jlevel = 3;
			else if(skilllevel >= 200 && skilllevel < 400) jlevel = 4;
			else if(skilllevel >= 400) jlevel = 5;
		}
		case 7:
		{
			new skilllevel = PlayerInfo[playerid][pMechSkill];
			if(skilllevel >= 0 && skilllevel < 50) jlevel = 1;
			else if(skilllevel >= 50 && skilllevel < 100) jlevel = 2;
			else if(skilllevel >= 100 && skilllevel < 200) jlevel = 3;
			else if(skilllevel >= 200 && skilllevel < 400) jlevel = 4;
			else if(skilllevel >= 400) jlevel = 5;
		}
		case 9:
		{
			new skilllevel = PlayerInfo[playerid][pArmsSkill];
			if(skilllevel >= 0 && skilllevel < 50) jlevel = 1;
			else if(skilllevel >= 50 && skilllevel < 100) jlevel = 2;
			else if(skilllevel >= 100 && skilllevel < 200) jlevel = 3;
			else if(skilllevel >= 200 && skilllevel < 400) jlevel = 4;
			else if(skilllevel >= 400) jlevel = 5;
		}
		case 12:
		{
			new skilllevel = PlayerInfo[playerid][pBoxSkill];
			if(skilllevel >= 0 && skilllevel < 50) jlevel = 1;
			else if(skilllevel >= 50 && skilllevel < 100) jlevel = 2;
			else if(skilllevel >= 100 && skilllevel < 200) jlevel = 3;
			else if(skilllevel >= 200 && skilllevel < 400) jlevel = 4;
			else if(skilllevel >= 400) jlevel = 5;
		}
		case 14: jlevel = 1;
		case 20:
		{
			new skilllevel = PlayerInfo[playerid][pTruckSkill];
			if(skilllevel >= 0 && skilllevel < 50) jlevel = 1;
			else if(skilllevel >= 50 && skilllevel < 100) jlevel = 2;
			else if(skilllevel >= 100 && skilllevel < 200) jlevel = 3;
			else if(skilllevel >= 200 && skilllevel < 400) jlevel = 4;
			else if(skilllevel >= 400) jlevel = 5;
		}
		case 22:
		{
			new skilllevel = PlayerInfo[playerid][pTreasureSkill];
			if(skilllevel >= 0 && skilllevel <= 24) jlevel = 1;
			else if(skilllevel >= 25 && skilllevel <= 149) jlevel = 2;
			else if(skilllevel >= 150 && skilllevel <= 299) jlevel = 3;
			else if(skilllevel >= 300 && skilllevel <= 599) jlevel = 4;
			else if(skilllevel >= 600) jlevel = 5;
		}
	}
	return jlevel;
}

stock StripNewLine(string[])
{
  new len = strlen(string);
  if (string[0]==0) return ;
  if ((string[len - 1] == '\n') || (string[len - 1] == '\r'))
    {
      string[len - 1] = 0;
      if (string[0]==0) return ;
      if ((string[len - 2] == '\n') || (string[len - 2] == '\r')) string[len - 2] = 0;
    }
}

stock StripColorEmbedding(string[])
{
 	new i, tmp[7];
  	while (i < strlen(string) - 7)
	{
	    if (string[i] == '{' && string[i + 7] == '}')
		{
		    strmid(tmp, string, i + 1, i + 7);
			if (ishex(tmp))
			{
				strdel(string, i, i + 8);
				i = 0;
				continue;
			}
		}
		i++;
  	}
}

stock strtoupper(string[])
{
        new retStr[128], i, j;
        while ((j = string[i])) retStr[i++] = chrtoupper(j);
        retStr[i] = '\0';
        return retStr;
}

stock wordwrap(string[], width, seperator[] = "\n", dest[], size = sizeof(dest))
{
    if (dest[0])
    {
        dest[0] = '\0';
    }
    new
        length,
        multiple,
        processed,
        tmp[192];

    strmid(tmp, string, 0, width);
    length = strlen(string);

    if (width > length || !width)
    {
        memcpy(dest, string, _, size * 4, size);
        return 0;
    }
    for (new i = 1; i < length; i ++)
    {
        if (tmp[0] == ' ')
        {
            strdel(tmp, 0, 1);
        }
        multiple = !(i % width);
        if (multiple)
        {
            strcat(dest, tmp, size);
            strcat(dest, seperator, size);
            strmid(tmp, string, i, width + i);
            if (strlen(tmp) < width)
            {
                strmid(tmp, string, (width * processed) + width, length);
                if (tmp[0] == ' ')
                {
                    strdel(tmp, 0, 1);
                }
                strcat(dest, tmp, size);
                break;
            }
            processed++;
            continue;
        }
        else if (i == length - 1)
        {
            strmid(tmp, string, (width * processed), length);
            strcat(dest, tmp, size);
            break;
        }
    }
    return 1;
}

stock IsAtNameChange(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		if(IsPlayerInRangeOfPoint(playerid, 3.0,1154.7295,-1440.2323,15.7969)) return 1;//LS
		else if(IsPlayerInRangeOfPoint(playerid, 3.0,-2279.6545, 2311.2238, 4.9641)) return 1;//TR
	}
	return 0;
}

stock IsAtATM(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		if(IsPlayerInRangeOfPoint(playerid,3.0,2065.439453125, -1897.5510253906, 13.19670009613) || IsPlayerInRangeOfPoint(playerid,3.0,1497.7467041016, -1749.8747558594, 15.088212013245) || IsPlayerInRangeOfPoint(playerid,3.0,2093.5124511719, -1359.5474853516, 23.62727355957) || IsPlayerInRangeOfPoint(playerid,3.0,1155.6235351563, -1464.9141845703, 15.44321346283))
		{//ATMS
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,3.0,2139.4487304688, -1164.0811767578, 23.63508605957) || IsPlayerInRangeOfPoint(playerid,3.0,1482.7761230469, -1010.3353881836, 26.48664855957) || IsPlayerInRangeOfPoint(playerid,3.0,1482.7761230469, -1010.3353881836, 26.48664855957) || IsPlayerInRangeOfPoint(playerid,3.0,387.16552734375, -1816.0512695313, 7.4834146499634))
		{//ATMS
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,3.0,-24.385023117065, -92.001075744629, 1003.1897583008) || IsPlayerInRangeOfPoint(playerid,3.0,-31.811220169067, -58.106018066406, 1003.1897583008) || IsPlayerInRangeOfPoint(playerid,3.0,1212.7785644531, 2.451762676239, 1000.5647583008) || IsPlayerInRangeOfPoint(playerid,3.0,2324.4028320313, -1644.9445800781, 14.469946861267))
		{//ATMS
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,3.0,2228.39, -1707.78, 13.25) || IsPlayerInRangeOfPoint(playerid,3.0,651.19305419922, -520.48815917969, 15.978837013245) || IsPlayerInRangeOfPoint(playerid, 3.0, 45.78035736084, -291.80926513672, 1.5024013519287) || IsPlayerInRangeOfPoint(playerid,3.0,1275.7958984375, 368.31481933594, 19.19758605957) || IsPlayerInRangeOfPoint(playerid,3.0,2303.4577636719, -13.539554595947, 26.12727355957))/*End of Red County Random ATM's*/
		{//ATMS
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,3.0,294.80, -84.01, 1001.0) || /*Start of Red County Random ATM's*/IsPlayerInRangeOfPoint(playerid,3.0,691.08215332031, -618.5625, 15.978837013245) || IsPlayerInRangeOfPoint(playerid,3.0,173.23471069336, -155.07606506348, 1.2210245132446) || IsPlayerInRangeOfPoint(playerid,3.0,1260.8796386719, 209.30152893066, 19.19758605957) || IsPlayerInRangeOfPoint(playerid,3.0,2316.1015625, -88.522567749023, 26.12727355957))/*End of Red County Random ATM's*/
		{//ATMS
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,3.0,1311.0361,-1446.2249,0.2216))
		{//ATMS
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,3.0,2052.9246, -1660.6346, 13.1300) || IsPlayerInRangeOfPoint(playerid,3.0,-1980.6300,121.5300,27.3100))
		{
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,3.0,-2453.7600,754.8200,34.8000) || IsPlayerInRangeOfPoint(playerid,3.0,-2678.6201,-283.3400,6.8000))
		{
		    return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,5.0,519.8157,-2890.8601,4.4609))
		{
		    return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,5.0,2565.667480, 1406.839355, 7699.584472) || IsPlayerInRangeOfPoint(playerid, 5.0, 3265.30004883, -631.90002441, 8423.90039062) || IsPlayerInRangeOfPoint(playerid, 5.0, 1829.5000, 1391.0000, 1464.0000) || IsPlayerInRangeOfPoint(playerid, 5.0, 1755.8000, 1434.1000, 2013.4000))
		{// VIP Lounge ATM || Package Club Interior
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,5.0,-665.975341, -4033.334716, 20.779014) || IsPlayerInRangeOfPoint(playerid,5.0,-1619.9645996094,713.67535400391, 19995.501953125))
		{// Random Island ATM
			return 1;
		}
		// Famed Lounge
		else if(IsPlayerInRangeOfPoint(playerid, 3.0, 883.7170, 1442.4282, -82.3370))
		{
		    return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid, 3.0, 2926.9199, -1529.9800, 10.6900)) return 1; //NGG Shop
		else if(IsPlayerInRangeOfPoint(playerid, 3.0, 986.4434,2056.2480,1085.8531) || IsPlayerInRangeOfPoint(playerid, 3.0, 1014.1396,2060.8284,1085.8531) || IsPlayerInRangeOfPoint(playerid, 3.0, 1013.4720,2023.8784,1085.8531)) return 1; //Glen Park
		else if(IsPlayerInRangeOfPoint(playerid, 3.0, 1378.0894, 1740.0106, 927.3564)) return 1; //Olympics
	}
	return 0;
}

stock SetPlayerSpawn(playerid)
{
    if(IsPlayerConnected(playerid))
	{
		if(PlayerInfo[playerid][pBackpack] > 0 && PlayerInfo[playerid][pBEquipped])
		{
			switch(PlayerInfo[playerid][pBackpack])
			{
				case 1:
				{
					if(PlayerHoldingObject[playerid][9] != 0 && IsPlayerAttachedObjectSlotUsed(playerid, 9)) 
						RemovePlayerAttachedObject(playerid, 9), PlayerHoldingObject[playerid][9] = 0;
					SetPlayerAttachedObject(playerid, 9, 371, 1, -0.002, -0.140999, -0.01, 8.69999, 88.8, -8.79993, 1.11, 0.963);
					//PlayerInfo[playerid][pBEquipped] = 1;
				}
				case 2: // Med
				{
					if(PlayerHoldingObject[playerid][9] != 0 && IsPlayerAttachedObjectSlotUsed(playerid, 9)) 
						RemovePlayerAttachedObject(playerid, 9), PlayerHoldingObject[playerid][9] = 0;
					SetPlayerAttachedObject(playerid, 9, 371, 1, -0.002, -0.140999, -0.01, 8.69999, 88.8, -8.79993, 1.11, 0.963);
					//PlayerInfo[playerid][pBEquipped] = 1;
				}
				case 3: // Large
				{
					if(PlayerHoldingObject[playerid][9] != 0 && IsPlayerAttachedObjectSlotUsed(playerid, 9)) 
						RemovePlayerAttachedObject(playerid, 9), PlayerHoldingObject[playerid][9] = 0;
					SetPlayerAttachedObject(playerid, 9, 3026, 1, -0.254999, -0.109, -0.022999, 10.6, -1.20002, 3.4, 1.265, 1.242, 1.062);
					//PlayerInfo[playerid][pBEquipped] = 1;
				}
			}
		}
	    SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);
		if(HungerPlayerInfo[playerid][hgInEvent] == 1)
		{
			if(hgActive > 0)
			{
				if(hgPlayerCount == 3)
				{
					new szmessage[128];
					format(szmessage, sizeof(szmessage), "** %s has came in third place in the Hunger Games Event.", GetPlayerNameEx(playerid));
					SendClientMessageToAll(COLOR_LIGHTBLUE, szmessage);
						
					SetHealth(playerid, HungerPlayerInfo[playerid][hgLastHealth]);
					SetArmour(playerid, HungerPlayerInfo[playerid][hgLastArmour]);
					SetPlayerVirtualWorld(playerid, HungerPlayerInfo[playerid][hgLastVW]);
					SetPlayerInterior(playerid, HungerPlayerInfo[playerid][hgLastInt]);
					SetPlayerPos(playerid, HungerPlayerInfo[playerid][hgLastPosition][0], HungerPlayerInfo[playerid][hgLastPosition][1], HungerPlayerInfo[playerid][hgLastPosition][2]);
							
					ResetPlayerWeapons(playerid);
						
					HungerPlayerInfo[playerid][hgInEvent] = 0;
					hgPlayerCount--;
					HideHungerGamesTextdraw(playerid);
					PlayerInfo[playerid][pRewardDrawChance] += 10;
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "** You have been given 10 Draw Chances for the Fall Into Fun Event.");
					
					for(new w = 0; w < 12; w++)
					{
						PlayerInfo[playerid][pGuns][w] = HungerPlayerInfo[playerid][hgLastWeapon][w];
						if(PlayerInfo[playerid][pGuns][w] > 0 && PlayerInfo[playerid][pAGuns][w] == 0)
						{
							GivePlayerValidWeapon(playerid, PlayerInfo[playerid][pGuns][w], 60000);
						}
					}
				}
				else if(hgPlayerCount == 2)
				{
					new szmessage[128];
					format(szmessage, sizeof(szmessage), "** %s has came in second place in the Hunger Games Event.", GetPlayerNameEx(playerid));
					SendClientMessageToAll(COLOR_LIGHTBLUE, szmessage);
						
					SetHealth(playerid, HungerPlayerInfo[playerid][hgLastHealth]);
					SetArmour(playerid, HungerPlayerInfo[playerid][hgLastArmour]);
					SetPlayerVirtualWorld(playerid, HungerPlayerInfo[playerid][hgLastVW]);
					SetPlayerInterior(playerid, HungerPlayerInfo[playerid][hgLastInt]);
					SetPlayerPos(playerid, HungerPlayerInfo[playerid][hgLastPosition][0], HungerPlayerInfo[playerid][hgLastPosition][1], HungerPlayerInfo[playerid][hgLastPosition][2]);
							
					ResetPlayerWeapons(playerid);
						
					HungerPlayerInfo[playerid][hgInEvent] = 0;
					hgPlayerCount--;
					HideHungerGamesTextdraw(playerid);
					PlayerInfo[playerid][pRewardDrawChance] += 25;
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "** You have been given 25 Draw Chances for the Fall Into Fun Event.");
						
					for(new w = 0; w < 12; w++)
					{
						PlayerInfo[playerid][pGuns][w] = HungerPlayerInfo[playerid][hgLastWeapon][w];
						if(PlayerInfo[playerid][pGuns][w] > 0 && PlayerInfo[playerid][pAGuns][w] == 0)
						{
							GivePlayerValidWeapon(playerid, PlayerInfo[playerid][pGuns][w], 60000);
						}
					}	
						
					foreach(new i: Player) 
					{
						if(HungerPlayerInfo[i][hgInEvent] == 1)
						{
							format(szmessage, sizeof(szmessage), "** %s has came in first place in the Hunger Games Event.", GetPlayerNameEx(i));
							SendClientMessageToAll(COLOR_LIGHTBLUE, szmessage);
								
							SetHealth(i, HungerPlayerInfo[i][hgLastHealth]);
							SetArmour(i, HungerPlayerInfo[i][hgLastArmour]);
							SetPlayerVirtualWorld(i, HungerPlayerInfo[i][hgLastVW]);
							SetPlayerInterior(i, HungerPlayerInfo[i][hgLastInt]);
							SetPlayerPos(i, HungerPlayerInfo[i][hgLastPosition][0], HungerPlayerInfo[i][hgLastPosition][1], HungerPlayerInfo[i][hgLastPosition][2]);
									
							ResetPlayerWeapons(i);
								
							HungerPlayerInfo[i][hgInEvent] = 0;
							hgPlayerCount--;
							HideHungerGamesTextdraw(i);
							PlayerInfo[i][pRewardDrawChance] += 50;
							SendClientMessageEx(i, COLOR_LIGHTBLUE, "** You have been given 50 Draw Chances for the Fall Into Fun Event.");
							hgActive = 0;
							
							for(new w = 0; w < 12; w++)
							{
								PlayerInfo[i][pGuns][w] = HungerPlayerInfo[i][hgLastWeapon][w];
								if(PlayerInfo[i][pGuns][w] > 0 && PlayerInfo[i][pAGuns][w] == 0)
								{
									GivePlayerValidWeapon(i, PlayerInfo[i][pGuns][w], 60000);
								}
							}
						}
					}
					
					for(new i = 0; i < 600; i++)
					{
						if(IsValidDynamic3DTextLabel(HungerBackpackInfo[i][hgBackpack3DText]))
						{
							DestroyDynamic3DTextLabel(HungerBackpackInfo[i][hgBackpack3DText]);
						}
						if(IsValidDynamicPickup(HungerBackpackInfo[i][hgBackpackPickupId]))
						{
							DestroyDynamicPickup(HungerBackpackInfo[i][hgBackpackPickupId]);
						}
						
						HungerBackpackInfo[i][hgActiveEx] = 0;
					}
					
				}
				else if(hgPlayerCount > 3 || hgPlayerCount == 1)
				{
					SetHealth(playerid, HungerPlayerInfo[playerid][hgLastHealth]);
					SetArmour(playerid, HungerPlayerInfo[playerid][hgLastArmour]);
					SetPlayerVirtualWorld(playerid, HungerPlayerInfo[playerid][hgLastVW]);
					SetPlayerInterior(playerid, HungerPlayerInfo[playerid][hgLastInt]);
					SetPlayerPos(playerid, HungerPlayerInfo[playerid][hgLastPosition][0], HungerPlayerInfo[playerid][hgLastPosition][1], HungerPlayerInfo[playerid][hgLastPosition][2]);
							
					ResetPlayerWeapons(playerid);
						
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You have died and has been removed from the Hunger Games Event, better luck next time.");
						
					HungerPlayerInfo[playerid][hgInEvent] = 0;
					hgPlayerCount--;
						
					HideHungerGamesTextdraw(playerid);
					
					for(new w = 0; w < 12; w++)
					{
						PlayerInfo[playerid][pGuns][w] = HungerPlayerInfo[playerid][hgLastWeapon][w];
						if(PlayerInfo[playerid][pGuns][w] > 0 && PlayerInfo[playerid][pAGuns][w] == 0)
						{
							GivePlayerValidWeapon(playerid, PlayerInfo[playerid][pGuns][w], 60000);
						}
					}
				}
				
				
				new string[128];
				format(string, sizeof(string), "Players in event: %d", hgPlayerCount);
				foreach(new i: Player) 
				{
					PlayerTextDrawSetString(i, HungerPlayerInfo[i][hgPlayerText], string);
				}
			}
			return true;
		}
		if(GetPVarInt(playerid, "IsInArena") >= 0)
		{
			SpawnPaintballArena(playerid, GetPVarInt(playerid, "IsInArena"));
			return 1;
		}
		if(GetPVarType(playerid, "SpecOff"))
		{
			SetPlayerInterior(playerid, GetPVarInt(playerid, "SpecInt"));
			PlayerInfo[playerid][pInt] = GetPVarInt(playerid, "SpecInt");
			SetPlayerVirtualWorld(playerid, GetPVarInt(playerid, "SpecVW"));
			PlayerInfo[playerid][pVW] = GetPVarInt(playerid, "SpecVW");
			SetPlayerPos(playerid, GetPVarFloat(playerid, "SpecPosX"), GetPVarFloat(playerid, "SpecPosY"), GetPVarFloat(playerid, "SpecPosZ"));
			if(GetPVarInt(playerid, "SpecInt") > 0) {
				Player_StreamPrep(playerid, GetPVarFloat(playerid, "SpecPosX"), GetPVarFloat(playerid, "SpecPosY"), GetPVarFloat(playerid, "SpecPosZ"), FREEZE_TIME);
			}	
			DeletePVar(playerid, "SpecOff");
			DeletePVar(playerid, "SpecInt");
			DeletePVar(playerid, "SpecVW");
			DeletePVar(playerid, "SpecPosX");
			DeletePVar(playerid, "SpecPosY");
			DeletePVar(playerid, "SpecPosZ");
			if(GetPVarType(playerid, "pGodMode"))
	    	{
	        	SetHealth(playerid, 0x7FB00000);
		    	SetArmour(playerid, 0x7FB00000);
			}
			return 1;
		}
		if(PlayerInfo[playerid][pTut] == 0)
		{
			gOoc[playerid] = 1; gNews[playerid] = 1; gFam[playerid] = 1;
			TogglePlayerControllable(playerid, false);
			SetPlayerColor(playerid,TEAM_HIT_COLOR);
			PlayerNationSelection[playerid] = -1;
			PlayerHasNationSelected[playerid] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid, 2229.4968,-1722.0701,13.5625);
			SetPlayerPos(playerid, 2229.4968,-1722.0701,-10.0);
			SetPlayerCameraPos(playerid, 2211.1460,-1748.3909,29.3744);
			SetPlayerCameraLookAt(playerid, 2229.4968,-1722.0701,13.5625);

   			RegistrationStep[playerid] = 1;
   			ShowPlayerDialog(playerid, REGISTERSEX, DIALOG_STYLE_LIST, "{FF0000}Is your character male or female?", "Male\nFemale", "Submit", "");
			return 1;
		}
		new rand;
		if(PlayerInfo[playerid][pBeingSentenced] > 0)
		{
		    PhoneOnline[playerid] = 1;
		    rand = random(sizeof(WarrantJail));
			SetPlayerPos(playerid, WarrantJail[rand][0], WarrantJail[rand][1], WarrantJail[rand][2]);
			if(rand != 0) courtjail[playerid] = 2;
			else courtjail[playerid] = 1;
			Player_StreamPrep(playerid, WarrantJail[rand][0], WarrantJail[rand][1], WarrantJail[rand][2], FREEZE_TIME);
			PlayerInfo[playerid][pInt] = 0;
			DeletePVar(playerid, "Injured");
			SetPlayerColor(playerid, SHITTY_JUDICIALSHITHOTCH);
			return 1;
		}
		if(PlayerInfo[playerid][pJailTime] > 0)
		{
			if(strfind(PlayerInfo[playerid][pPrisonReason], "[IC]", true) != -1)
			{
				PhoneOnline[playerid] = 1;
				SetPlayerInterior(playerid, 1);
				PlayerInfo[playerid][pInt] = 1;
				SetPlayerVirtualWorld(playerid, 0);
				PlayerInfo[playerid][pVW] = 0;
				//SetPlayerSkin(playerid, 50); 
				SetPlayerColor(playerid, TEAM_ORANGE_COLOR);
				SetHealth(playerid, 100);
				DeletePVar(playerid, "Injured");
				DeletePVar(playerid, "ArrestPoint");
				ResetPlayerWeaponsEx(playerid);
				rand = random(sizeof(DocPrison));
				if(PlayerInfo[playerid][pIsolated] > 0)
				{
					SetPlayerPos(playerid, DocIsolation[PlayerInfo[playerid][pIsolated] - 1][0], DocIsolation[PlayerInfo[playerid][pIsolated] - 1][1], DocIsolation[PlayerInfo[playerid][pIsolated] - 1][2]);
					Player_StreamPrep(playerid, DocIsolation[PlayerInfo[playerid][pIsolated] - 1][0], DocIsolation[PlayerInfo[playerid][pIsolated] - 1][1], DocIsolation[PlayerInfo[playerid][pIsolated] - 1][2], FREEZE_TIME);
				}
				else
				{
					SetPlayerPos(playerid, DocPrison[rand][0], DocPrison[rand][1], DocPrison[rand][2]);
					Player_StreamPrep(playerid, DocPrison[rand][0], DocPrison[rand][1], DocPrison[rand][2], FREEZE_TIME);
				}
				return 1;
			}
		    else
		    {
		        SetHealth(playerid, 0x7FB00000);
		       	PhoneOnline[playerid] = 1;
				SetPlayerInterior(playerid, 1);
				PlayerInfo[playerid][pInt] = 1;
				rand = random(sizeof(OOCPrisonSpawns));
				SetPlayerPos(playerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2]);
				SetPlayerSkin(playerid, 50);
				SetPlayerColor(playerid, TEAM_APRISON_COLOR);
				new string[128];
				format(string, sizeof(string), "You are in prison, reason: %s", PlayerInfo[playerid][pPrisonReason]);
				SendClientMessageEx(playerid, COLOR_LIGHTRED, string);
				ResetPlayerWeaponsEx(playerid);
				DeletePVar(playerid, "Injured");
				Player_StreamPrep(playerid, OOCPrisonSpawns[rand][0], OOCPrisonSpawns[rand][1], OOCPrisonSpawns[rand][2], FREEZE_TIME);
				return 1;
		    }
		}
		if(GetPVarInt(playerid, "Injured") == 1)
		{
		    SendEMSQueue(playerid,1);
		    return 1;
		}
		if(GetPVarInt(playerid, "EventToken") == 1)
		{
			for(new i; i < sizeof(EventKernel[EventStaff]); i++)
			{
				if(EventKernel[EventStaff][i] == playerid)
				{
					/*SetPlayerWeapons(playerid);
					SetPlayerPos(playerid,EventFloats[playerid][1],EventFloats[playerid][2],EventFloats[playerid][3]);
					//PlayerInfo[playerid][pInterior] = PlayerInfo[playerid][pInt];
					SetPlayerVirtualWorld(playerid, EventLastVW[playerid]);
					SetPlayerFacingAngle(playerid, EventFloats[playerid][0]);
					SetPlayerInterior(playerid,EventLastInt[playerid]);
					SetHealth(playerid, EventFloats[playerid][4]);
					if(EventFloats[playerid][5] > 0) {
						SetArmour(playerid, EventFloats[playerid][5]);
					}
					for(new d = 0; d < 6; d++)
					{
						EventFloats[playerid][d] = 0.0;
					}
					EventLastInt[playerid] = 0;
					EventLastVW[playerid] = 0;
					EventKernel[EventStaff][i] = INVALID_PLAYER_ID;*/
					new Float:health, Float:armor;
					ResetPlayerWeapons( playerid );
					DeletePVar(playerid, "EventToken");
					SetPlayerWeapons(playerid);
					SetPlayerToTeamColor(playerid);
					SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);
					SetPlayerPos(playerid,EventFloats[playerid][1],EventFloats[playerid][2],EventFloats[playerid][3]);
					SetPlayerVirtualWorld(playerid, EventLastVW[playerid]);
					SetPlayerFacingAngle(playerid, EventFloats[playerid][0]);
					SetPlayerInterior(playerid,EventLastInt[playerid]);
					Player_StreamPrep(playerid, EventFloats[playerid][1],EventFloats[playerid][2],EventFloats[playerid][3], FREEZE_TIME);
					if(EventKernel[EventType] == 4)
					{
						if(GetPVarType(playerid, "pEventZombie")) DeletePVar(playerid, "pEventZombie");
						SetPlayerToTeamColor(playerid);
					}
					for(new d = 0; d < 6; d++)
					{
						EventFloats[playerid][d] = 0.0;
					}
					EventLastVW[playerid] = 0;
					EventLastInt[playerid] = 0;
					RemovePlayerWeapon(playerid, 38);
					health = GetPVarFloat(playerid, "pPreGodHealth");
					SetHealth(playerid,health);
					armor = GetPVarFloat(playerid, "pPreGodArmor");
					SetArmour(playerid, armor);
					DeletePVar(playerid, "pPreGodHealth");
					DeletePVar(playerid, "pPreGodArmor");
					DeletePVar(playerid, "eventStaff");
					return 1;
				}
			}
            if(EventKernel[EventType] == 4)
			{
			   	SetPlayerPos(playerid, EventKernel[ EventPositionX ], EventKernel[ EventPositionY ], EventKernel[ EventPositionZ ] );
				SetPlayerInterior(playerid, EventKernel[ EventInterior ] );
				SetPlayerVirtualWorld(playerid, EventKernel[ EventWorld ] );
				SendClientMessageEx(playerid, COLOR_WHITE, "You are a zombie! Use /bite to infect others");
				SetHealth(playerid, 30);
				RemoveArmor(playerid);
				SetPlayerSkin(playerid, 134);
				SetPlayerColor(playerid, 0x0BC43600);
				SetPVarInt(playerid, "pEventZombie", 1);
				return 1;
			}
			else
			{
			    DeletePVar(playerid, "EventToken");
			    SetPlayerWeapons(playerid);
			    SetPlayerPos(playerid,EventFloats[playerid][1],EventFloats[playerid][2],EventFloats[playerid][3]);
				//PlayerInfo[playerid][pInterior] = PlayerInfo[playerid][pInt];
				SetPlayerVirtualWorld(playerid, EventLastVW[playerid]);
				SetPlayerFacingAngle(playerid, EventFloats[playerid][0]);
				SetPlayerInterior(playerid,EventLastInt[playerid]);
				Player_StreamPrep(playerid, EventFloats[playerid][1],EventFloats[playerid][2],EventFloats[playerid][3], FREEZE_TIME);
				SetHealth(playerid, EventFloats[playerid][4]);
				if(EventFloats[playerid][5] > 0) {
					SetArmour(playerid, EventFloats[playerid][5]);
				}
				for(new i = 0; i < 6; i++)
				{
				    EventFloats[playerid][i] = 0.0;
				}
				EventLastVW[playerid] = 0;
				EventLastInt[playerid] = 0;
				return 1;
			}
		}
		if(GetPVarInt(playerid, "MedicBill") == 1 && PlayerInfo[playerid][pJailTime] == 0)
		{
			
		    #if defined zombiemode
	    	if(zombieevent == 1 && GetPVarType(playerid, "pIsZombie"))
			{
				SpawnZombie(playerid);
  				return 1;
			}
			#endif
			if(PlayerInfo[playerid][pWantedLevel] > 0 && (PlayerInfo[playerid][pInsurance] == HOSPITAL_LSVIP || PlayerInfo[playerid][pInsurance] == HOSPITAL_LVVIP || PlayerInfo[playerid][pInsurance] == HOSPITAL_SFVIP || PlayerInfo[playerid][pInsurance] == HOSPITAL_HOMECARE || PlayerInfo[playerid][pInsurance] == HOSPITAL_FAMED))
			{
				new wantedplace;
				
				switch(random(3))
				{
					case 0: {wantedplace = HOSPITAL_COUNTYGEN;}
					case 1: {wantedplace = HOSPITAL_SANFIERRO;}
					case 2: {wantedplace = HOSPITAL_ALLSAINTS;}
				}
				DeliverPlayerToHospital(playerid, wantedplace);
				
				return 1;
			}
			else
			{
				return DeliverPlayerToHospital(playerid, PlayerInfo[playerid][pInsurance]);
			}
			
		}
		if(!PlayerInfo[playerid][pHospital])
		{
			SetPlayerPos(playerid,PlayerInfo[playerid][pPos_x],PlayerInfo[playerid][pPos_y],PlayerInfo[playerid][pPos_z]);
			SetPlayerVirtualWorld(playerid, PlayerInfo[playerid][pVW]);
			SetPlayerFacingAngle(playerid, PlayerInfo[playerid][pPos_r]);
			SetPlayerInterior(playerid,PlayerInfo[playerid][pInt]);
			if(PlayerInfo[playerid][pHealth] < 1) PlayerInfo[playerid][pHealth] = 100;
			SetHealth(playerid, PlayerInfo[playerid][pHealth]);
			if(PlayerInfo[playerid][pArmor] > 0) SetArmour(playerid, PlayerInfo[playerid][pArmor]);
			SetCameraBehindPlayer(playerid);
			if(PlayerInfo[playerid][pInt] > 0) Player_StreamPrep(playerid, PlayerInfo[playerid][pPos_x],PlayerInfo[playerid][pPos_y],PlayerInfo[playerid][pPos_z], FREEZE_TIME);
		}
		new Float: x, Float: y, Float: z;
		GetPlayerPos(playerid, x, y, z);
		if(x == 0.0 && y == 0.0)
		{
  			SetPlayerInterior(playerid,0);
			SetPlayerPos(playerid, 1715.1201,-1903.1711,13.5665);
			SetPlayerFacingAngle(playerid, 359.4621);
			SetCameraBehindPlayer(playerid);
		}
		SetPlayerToTeamColor(playerid);
		return 1;
	}
	return 1;
}

stock IsAtFishPlace(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		if(IsPlayerInRangeOfPoint(playerid,1.0,403.8266,-2088.7598,7.8359) || IsPlayerInRangeOfPoint(playerid,1.0,398.7553,-2088.7490,7.8359))
		{//Fishplace at the bigwheel
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,1.0,396.2197,-2088.6692,7.8359) || IsPlayerInRangeOfPoint(playerid,1.0,391.1094,-2088.7976,7.8359))
		{//Fishplace at the bigwheel
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,1.0,383.4157,-2088.7849,7.8359) || IsPlayerInRangeOfPoint(playerid,1.0,374.9598,-2088.7979,7.8359))
		{//Fishplace at the bigwheel
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,1.0,369.8107,-2088.7927,7.8359) || IsPlayerInRangeOfPoint(playerid,1.0,367.3637,-2088.7925,7.8359))
		{//Fishplace at the bigwheel
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,1.0,362.2244,-2088.7981,7.8359) || IsPlayerInRangeOfPoint(playerid,1.0,354.5382,-2088.7979,7.8359))
		{//Fishplace at the bigwheel
			return 1;
		}
	}
	return 0;
}

stock fcreate(filename[])
{
	if (fexist(filename)) return false;
	new File:fhnd;
	fhnd=fopen(filename,io_write);
	if (fhnd) {
		fclose(fhnd);
		return true;
	}
	return false;
}

stock IsAtBar(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		if(IsPlayerInRangeOfPoint(playerid,3.0,495.7801,-76.0305,998.7578) || IsPlayerInRangeOfPoint(playerid,3.0,499.9654,-20.2515,1000.6797) || IsPlayerInRangeOfPoint(playerid,9.0,1497.5735,-1811.6150,825.3397))
		{//In grove street bar (with girlfriend), and in Havanna
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,4.0,1215.9480,-13.3519,1000.9219) || IsPlayerInRangeOfPoint(playerid,10.0,-2658.9749,1407.4136,906.2734) || IsPlayerInRangeOfPoint(playerid,10.0,2155.3367,-97.3984,3.8308))
		{//PIG Pen
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,10.0,1131.3655,-1641.2759,18.6054) || IsPlayerInRangeOfPoint(playerid,10.0,-2676.4509,1540.6925,900.8359))
		{//Families 8 & SaC
		    return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,5.0,2492.5532,-1698.2817,1715.5508) || IsPlayerInRangeOfPoint(playerid,5.0,2462.8247,-1649.5435,1732.0295) || IsPlayerInRangeOfPoint(playerid,5.0,2498.9863,-1666.6274,1738.3696))
		{
		    //Custom House
		    return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,5.0,878.6188,1431.0234,-82.3449) || IsPlayerInRangeOfPoint(playerid,5.0,918.7236,1421.3997,-81.1839))
		{
		    //VIP
		    return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,10.0,2574.3931,-1682.1548,1030.0206))
		{
			//The Cove
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,10.0,1266.14,-1073.00,1082.92))
		{
			//The Cove
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,10.0,1886.993652, -734.707275, 3380.847656))
		{
			//Syndicate HQ Bar
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,10.0,300.4993, 203.9201, 1104.3500))
		{
			//SHIELD HQ Bar
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,10.0,252.205978, -54.826644, 1.577644))
		{
			//Red County Liquor Store
			return 1;
		}
		else if(IsPlayerInRangeOfPoint(playerid,10.0,453.2437,-105.4000,999.5500) || IsPlayerInRangeOfPoint(playerid,10.0,1255.69, -791.76, 1085.38) ||
		IsPlayerInRangeOfPoint(playerid,10.0,2561.94, -1296.44, 1062.04) || IsPlayerInRangeOfPoint(playerid,10.0,1139.72, -3.96, 1000.67) ||
		IsPlayerInRangeOfPoint(playerid,10.0,1139.72, -3.96, 1000.67) || IsPlayerInRangeOfPoint(playerid, 10.0, 880.06, 1430.86, -82.34) ||
		IsPlayerInRangeOfPoint(playerid,10.0,499.96, -20.66, 1000.68) || IsPlayerInRangeOfPoint(playerid,10.0,3282, -635, 8424))
		{
			//Bars
			return 1;
		}
	}
	return 0;
}

GetArrestPointID(playerid) {
	new a = -1;
	for(new x = 0; x < MAX_ARRESTPOINTS; x++) 
	{
		if(IsPlayerInRangeOfPoint(playerid, 8.0, ArrestPoints[x][arrestPosX], ArrestPoints[x][arrestPosY], ArrestPoints[x][arrestPosZ]) && GetPlayerInterior(playerid) == ArrestPoints[x][arrestInt] && GetPlayerVirtualWorld(playerid) == ArrestPoints[x][arrestVW])
		{
			a = x;
			break;
		}
	}
	return a;
}

stock IsAtArrestPoint(playerid, type)
{
	if(IsPlayerConnected(playerid))
	{
		for(new x; x < MAX_ARRESTPOINTS; x++)
		{
			if(ArrestPoints[x][arrestPosX] != 0)
			{
				if(ArrestPoints[x][arrestType] == type)
				{
					switch(ArrestPoints[x][arrestType])
					{
						case 0:
						{
							if(IsPlayerInRangeOfPoint(playerid, 4.0, ArrestPoints[x][arrestPosX], ArrestPoints[x][arrestPosY], ArrestPoints[x][arrestPosZ]) && GetPlayerInterior(playerid) == ArrestPoints[x][arrestInt] && GetPlayerVirtualWorld(playerid) == ArrestPoints[x][arrestVW]) return 1;
						}
						case 1:
						{
							if(IsPlayerInRangeOfPoint(playerid, 50.0, ArrestPoints[x][arrestPosX], ArrestPoints[x][arrestPosY], ArrestPoints[x][arrestPosZ]) && GetPlayerInterior(playerid) == ArrestPoints[x][arrestInt] && GetPlayerVirtualWorld(playerid) == ArrestPoints[x][arrestVW]) return 1;
						}
						case 2:
						{
							if(IsPlayerInRangeOfPoint(playerid, 10.0, ArrestPoints[x][arrestPosX], ArrestPoints[x][arrestPosY], ArrestPoints[x][arrestPosZ]) && GetPlayerInterior(playerid) == ArrestPoints[x][arrestInt] && GetPlayerVirtualWorld(playerid) == ArrestPoints[x][arrestVW]) return 1;
						}
						case 3:
						{
							if(IsPlayerInRangeOfPoint(playerid, 4.0, ArrestPoints[x][arrestPosX], ArrestPoints[x][arrestPosY], ArrestPoints[x][arrestPosZ]) && GetPlayerInterior(playerid) == ArrestPoints[x][arrestInt] && GetPlayerVirtualWorld(playerid) == ArrestPoints[x][arrestVW]) return 1;
						}
						case 4:
						{
							if(IsPlayerInRangeOfPoint(playerid, 4.0, ArrestPoints[x][arrestPosX], ArrestPoints[x][arrestPosY], ArrestPoints[x][arrestPosZ]) && GetPlayerInterior(playerid) == ArrestPoints[x][arrestInt] && GetPlayerVirtualWorld(playerid) == ArrestPoints[x][arrestVW]) return 1;
						}
					}
				}
			}
		}
	}
	return 0;
}

stock IsAtImpoundingPoint(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		for(new x; x < MAX_IMPOUNDPOINTS; x++)
		{
			if(ImpoundPoints[x][impoundPosX] != 0)
			{
				if(IsPlayerInRangeOfPoint(playerid, 4.0, ImpoundPoints[x][impoundPosX], ImpoundPoints[x][impoundPosY], ImpoundPoints[x][impoundPosZ]) && GetPlayerInterior(playerid) == ImpoundPoints[x][impoundInt] && GetPlayerVirtualWorld(playerid) == ImpoundPoints[x][impoundVW]) return 1;
			}
		}
	}
	return 0;
}

stock IsAtPostOffice(playerid)
{
	return IsPlayerInRangeOfPoint(playerid,100.0,-262.0643, 6.0924, 2000.9038);
}

stock IsNearHouseMailbox(playerid)
{
	if (PlayerInfo[playerid][pPhousekey] != INVALID_HOUSE_ID && IsPlayerInRangeOfPoint(playerid,3.0,HouseInfo[PlayerInfo[playerid][pPhousekey]][hMailX], HouseInfo[PlayerInfo[playerid][pPhousekey]][hMailY], HouseInfo[PlayerInfo[playerid][pPhousekey]][hMailZ])) return 1;
	if (PlayerInfo[playerid][pPhousekey2] != INVALID_HOUSE_ID && IsPlayerInRangeOfPoint(playerid,3.0,HouseInfo[PlayerInfo[playerid][pPhousekey2]][hMailX], HouseInfo[PlayerInfo[playerid][pPhousekey2]][hMailY], HouseInfo[PlayerInfo[playerid][pPhousekey2]][hMailZ])) return 1;
	if (PlayerInfo[playerid][pPhousekey3] != INVALID_HOUSE_ID && IsPlayerInRangeOfPoint(playerid,3.0,HouseInfo[PlayerInfo[playerid][pPhousekey3]][hMailX], HouseInfo[PlayerInfo[playerid][pPhousekey3]][hMailY], HouseInfo[PlayerInfo[playerid][pPhousekey3]][hMailZ])) return 1;	
	return 0;
}

stock IsNearPublicMailbox(playerid)
{
    for(new i = 0; i < sizeof(MailBoxes); i++) if (IsPlayerInRangeOfPoint(playerid, 3.0, MailBoxes[i][mbPosX], MailBoxes[i][mbPosY], MailBoxes[i][mbPosZ])) return 1;
	return 0;
}

stock InRangeOfWhichHouse(playerid, Float: range)
{
	if (PlayerInfo[playerid][pPhousekey] != INVALID_HOUSE_ID && IsPlayerInRangeOfPoint(playerid,range,HouseInfo[PlayerInfo[playerid][pPhousekey]][hExteriorX], HouseInfo[PlayerInfo[playerid][pPhousekey]][hExteriorY], HouseInfo[PlayerInfo[playerid][pPhousekey]][hExteriorZ]) && GetPlayerInterior(playerid) == HouseInfo[PlayerInfo[playerid][pPhousekey]][hExtIW] && GetPlayerVirtualWorld(playerid) == HouseInfo[PlayerInfo[playerid][pPhousekey]][hExtVW]) return PlayerInfo[playerid][pPhousekey];
	if (PlayerInfo[playerid][pPhousekey2] != INVALID_HOUSE_ID && IsPlayerInRangeOfPoint(playerid,range,HouseInfo[PlayerInfo[playerid][pPhousekey2]][hExteriorX], HouseInfo[PlayerInfo[playerid][pPhousekey2]][hExteriorY], HouseInfo[PlayerInfo[playerid][pPhousekey2]][hExteriorZ]) && GetPlayerInterior(playerid) == HouseInfo[PlayerInfo[playerid][pPhousekey2]][hExtIW] && GetPlayerVirtualWorld(playerid) == HouseInfo[PlayerInfo[playerid][pPhousekey2]][hExtVW]) return PlayerInfo[playerid][pPhousekey2];
	if (PlayerInfo[playerid][pPhousekey3] != INVALID_HOUSE_ID && IsPlayerInRangeOfPoint(playerid,range,HouseInfo[PlayerInfo[playerid][pPhousekey3]][hExteriorX], HouseInfo[PlayerInfo[playerid][pPhousekey3]][hExteriorY], HouseInfo[PlayerInfo[playerid][pPhousekey3]][hExteriorZ]) && GetPlayerInterior(playerid) == HouseInfo[PlayerInfo[playerid][pPhousekey3]][hExtIW] && GetPlayerVirtualWorld(playerid) == HouseInfo[PlayerInfo[playerid][pPhousekey3]][hExtVW]) return PlayerInfo[playerid][pPhousekey3];
	return INVALID_HOUSE_ID;
}

stock IsVIPcar(carid)
{
	for(new i = 0; i < sizeof(VIPVehicles); i++)
	{
		if(carid == VIPVehicles[i]) return 1;
	}
	return 0;
}

stock IsVIPModel(carid)
{
	new Cars[] = { 451, 411, 429, 522, 444, 556, 557 };
	for(new i = 0; i < sizeof(Cars); i++)
	{
		if(GetVehicleModel(carid) == Cars[i]) return 1;
	}
	return 0;
}

stock IsARC(carid)
{
	switch(GetVehicleModel(carid)) {
		case 441, 464, 465, 501, 564: return 1;
	}
	return 0;
}

stock IsABoat(carid) {
	switch(GetVehicleModel(carid)) {
		case 472, 473, 493, 484, 430, 454, 453, 452, 446, 595: return 1;
	}
	return 0;
}

stock IsABike(carid) {
	switch(GetVehicleModel(carid)) {
		case 509, 481, 510, 462, 448, 581, 522, 461, 521, 523, 463, 586, 468, 471: return 1;
	}
	return 0;
}

stock IsATrain(modelid) {
	switch(modelid) {
		case 538, 537, 449, 590, 569, 570: return 1;
	}
	return 0;
}

stock IsASpawnedTrain(carid) {
	switch(GetVehicleModel(carid)) {
		case 538, 537, 449, 590, 569, 570: return 1;
	}
	return 0;
}

stock IsAPlane(carid, type = 0)
{
	if(type == 0)
	{
		switch(GetVehicleModel(carid)) {
			case 592, 577, 511, 512, 593, 520, 553, 476, 519, 460, 513, 548, 425, 417, 487, 488, 497, 563, 447, 469: return 1;
		}
	}
	else
	{
		switch(carid) {
			case 592, 577, 511, 512, 593, 520, 553, 476, 519, 460, 513, 548, 425, 417, 487, 488, 497, 563, 447, 469: return 1;
		}
	}
	return 0;
}

stock IsRestrictedVehicle(modelid)
{
	switch(modelid) {
		case 406, 407, 408, 416, 425, 430, 432, 433, 447, 464, 465, 476, 486, 488, 490, 497, 501, 520, 523, 524, 525, 528, 532, 544, 548, 552, 563, 564, 577, 582, 592, 594, 596, 597, 598, 599, 601, 610, 611: return 1;
	}
	return 0;
}

stock IsWeaponizedVehicle(modelid)
{
	switch(modelid) {
		case 425, 432, 447, 476, 520: return 1;
	}
	return 0;
}	

stock IsATruckerCar(carid)
{
	for(new v = 0; v < sizeof(TruckerVehicles); v++) {
	    if(carid == TruckerVehicles[v]) return 1;
	}
	return 0;
}

stock IsAPizzaCar(carid)
{
	for (new v = 0; v < sizeof(PizzaVehicles); v++) {
	    if(carid == PizzaVehicles[v]) return 1;
	}
	return 0;
}

stock IsATowTruck(carid)
{
	if(GetVehicleModel(carid) == 525) {
		return 1;
	}
	return 0;
}

stock IsAAircraftTowTruck(carid)
{
	if(GetVehicleModel(carid) == 485 || GetVehicleModel(carid) == 583) {
		return 1;
	}
	return 0;
}
stock IsAHelicopter(carid)
{
	if(GetVehicleModel(carid) == 548 || GetVehicleModel(carid) == 425 || GetVehicleModel(carid) == 417 || GetVehicleModel(carid) == 487 || GetVehicleModel(carid) == 488 || GetVehicleModel(carid) == 497 || GetVehicleModel(carid) == 563 || GetVehicleModel(carid) == 447 || GetVehicleModel(carid) == 469 || GetVehicleModel(carid) == 593) {
		return 1;
	}
	return 0;
}


stock IsAnBus(carid)
{
	if(GetVehicleModel(carid) == 431 || GetVehicleModel(carid) == 437) {
		return 1;
	}
	return 0;
}

stock IsAnTaxi(carid)
{
	if(GetVehicleModel(carid) == 420 || GetVehicleModel(carid) == 438) {
		return 1;
	}
	return 0;
}

stock IsFamedVeh(carid)
{
	for(new i = 0; i < sizeof(FamedVehicles); i++)
	{
	    if(carid == FamedVehicles[i]) return 1;
	}
	return 0;
}

stock IsOSModel(carid)
{
	new Cars[] = {461, 559, 579, 426, 468};
	for(new i = 0; i < sizeof(Cars); i++)
	{
	    if(GetVehicleModel(carid) == Cars[i]) return 1;
	}
	return 0;
}

stock IsCOSModel(carid)
{
	new Cars[] = {560, 506, 411};
	for(new i = 0; i < sizeof(Cars); i++)
	{
	    if(GetVehicleModel(carid) == Cars[i]) return 1;
	}
	return 0;
}

stock IsFamedModel(carid)
{
	new Cars[] = {415, 522, 480, 541, 429, 558};
	for(new i = 0; i < sizeof(Cars); i++)
	{
	    if(GetVehicleModel(carid) == Cars[i]) return 1;
	}
	return 0;
}

stock partType(type)
{
	new name[32];
	switch(type)
	{
	    case 0:
		{
			name = "Spoiler";
        }
        case 1:
		{
			name = "Hood";
        }
        case 2:
		{
			name = "Roof";
        }
        case 3:
		{
			name = "Sideskirt";
        }
        case 4:
		{
			name = "Lamps";
        }
        case 5:
		{
			name = "Nitro";
        }
        case 6:
		{
			name = "Exhaust";
        }
        case 7:
		{
			name = "Wheels";
        }
        case 8:
		{
			name = "Stereo";
        }
        case 9:
		{
			name = "Hydraulics";
        }
        case 10:
		{
			name = "Front Bumper";
        }
        case 11:
		{
			name = "Rear Bumper";
        }
        case 12:
		{
			name = "Left Vent";
        }
        case 13:
		{
			name = "Right Vent";
        }
        default:
        {
            name = "Unknown";
		}
	}
	return name;
}

stock partName(part)
{
	new name[32];
	switch(part - 1000)
	{
		case 0:
		{
			name = "Pro";
        }
		case 1:
        {
			name = "Win";
        }
		case 2:
        {
			name = "Drag";
        }
		case 3:
        {
			name = "Alpha";
        }
		case 4:
        {
			name = "Champ Scoop";
        }
		case 5:
        {
			name = "Fury Scoop";
        }
		case 6:
        {
			name = "Roof Scoop";
        }
		case 7:
        {
			name = "Sideskirt";
        }
        case 8:
        {
            name = "2x";
        }
        case 9:
        {
            name = "5x";
        }
        case 10:
        {
            name = "10x";
        }
		case 11:
        {
			name = "Race Scoop";
        }
		case 12:
        {
			name = "Worx Scoop";
        }
		case 13:
        {
			name = "Round Fog";
        }
		case 14:
        {
			name = "Champ";
        }
		case 15:
        {
			name = "Race";
        }
		case 16:
        {
			name = "Worx";
        }
		case 17:
        {
			name = "Sideskirt";
        }
		case 18:
        {
			name = "Upswept";
        }
		case 19:
        {
			name = "Twin";
        }
		case 20:
		{
			name = "Large";
        }
		case 21:
        {
			name = "Medium";
        }
		case 22:
        {
			name = "Small";
        }
		case 23:
        {
			name = "Fury";
        }
		case 24:
        {
			name = "Square Fog";
        }
        case 25:
        {
            name = "Offroad";
        }
		case 26:
        {
			name = "Alien";
        }
		case 27:
        {
			name = "Alien";
        }
		case 28:
        {
			name = "Alien";
        }
		case 29:
        {
			name = "X-Flow";
        }
		case 30:
        {
			name = "X-Flow";
        }
		case 31:
        {
			name = "X-Flow";
        }
		case 32:
        {
			name = "Alien Roof Vent";
        }
		case 33:
        {
			name = "X-Flow Roof Vent";
        }
		case 34:
        {
			name = "Alien";
        }
		case 35:
        {
			name = "X-Flow Roof Vent";
        }
		case 36:
        {
			name = "Alien";
        }
		case 37:
        {
			name = "X-Flow";
        }
		case 38:
        {
			name = "Alien Roof Vent";
        }
		case 39:
        {
			name = "X-Flow";
        }
		case 40:
        {
			name = "Alien";
        }
		case 41:
        {
			name = "X-Flow";
        }
		case 42:
        {
			name = "Chrome";
        }
		case 43:
        {
			name = "Slamin";
        }
		case 44:
        {
			name = "Chrome";
        }
		case 45:
        {
			name = "X-Flow";
        }
		case 46:
        {
			name = "Alien";
        }
		case 47:
        {
			name = "Alien";
        }
		case 48:
        {
			name = "X-Flow";
        }
		case 49:
        {
			name = "Alien";
        }
		case 50:
        {
			name = "X-Flow";
        }
		case 51:
        {
			name = "Alien";
        }
		case 52:
        {
			name = "X-Flow";
        }
		case 53:
        {
			name = "X-Flow";
        }
		case 54:
        {
			name = "Alien";
        }
		case 55:
        {
			name = "Alien";
        }
		case 56:
        {
			name = "Alien";
        }
		case 57:
        {
			name = "X-Flow";
        }
		case 58:
        {
			name = "Alien";
        }
		case 59:
        {
			name = "X-Flow";
        }
		case 60:
        {
			name = "X-Flow";
        }
		case 61:
        {
			name = "X-Flow";
        }
		case 62:
        {
			name = "Alien";
        }
		case 63:
        {
			name = "X-Flow";
        }
		case 64:
        {
			name = "Alien";
        }
		case 65:
        {
			name = "Alien";
        }
		case 66:
        {
			name = "X-Flow";
        }
		case 67:
        {
			name = "Alien";
        }
		case 68:
        {
			name = "X-Flow";
        }
		case 69:
        {
			name = "Alien";
        }
		case 70:
        {
			name = "X-Flow";
        }
		case 71:
        {
			name = "Alien";
        }
		case 72:
        {
			name = "X-Flow";
        }
        case 73:
        {
            name = "Shadow";
        }
        case 74:
        {
            name = "Mega";
        }
        case 75:
        {
            name = "Rimshine";
        }
        case 76:
        {
            name = "Wires";
        }
        case 77:
        {
            name = "Classic";
        }
        case 78:
        {
            name = "Twist";
        }
        case 79:
        {
            name = "Cutter";
        }
        case 80:
        {
            name = "Switch";
        }
        case 81:
        {
            name = "Grove";
        }
        case 82:
        {
            name = "Import";
        }
        case 83:
        {
            name = "Dollar";
        }
        case 84:
        {
            name = "Trance";
        }
        case 85:
        {
            name = "Atomic";
        }
		case 88:
        {
			name = "Alien";
        }
		case 89:
        {
			name = "X-Flow";
        }
		case 90:
        {
			name = "Alien";
        }
		case 91:
        {
			name = "X-Flow";
        }
		case 92:
        {
			name = "Alien";
        }
		case 93:
        {
			name = "X-Flow";
        }
		case 94:
        {
			name = "Alien";
        }
		case 95:
        {
			name = "X-Flow";
        }
        case 96:
        {
            name = "Ahab";
        }
        case 97:
        {
            name = "Virtual";
        }
        case 98:
        {
            name = "Access";
        }
		case 99:
        {
			name = "Chrome";
        }
		case 100:
        {
			name = "Chrome Grill";
        }
 		case 101:
        {
			name = "Chrome Flames";
        }
		case 102:
        {
			name = "Chrome Strip";
        }
		case 103:
        {
			name = "Covertible";
        }
		case 104:
        {
			name = "Chrome";
        }
		case 105:
        {
			name = "Slamin";
        }
		case 106:
        {
			name = "Chrome Arches";
        }
		case 107:
        {
			name = "Chrome Strip";
        }
		case 108:
        {
			name = "Chrome Strip";
        }
		case 109:
        {
			name = "Chrome";
        }
		case 110:
        {
			name = "Slamin";
        }
		case 113:
        {
			name = "Chrome";
        }
		case 114:
        {
			name = "Slamin";
        }
		case 115:
        {
			name = "Chrome";
        }
		case 116:
        {
			name = "Slamin";
        }
		case 117:
        {
			name = "Chrome";
        }
		case 118:
        {
			name = "Chrome Trim";
        }
		case 119:
        {
			name = "Wheelcovers";
        }
		case 120:
        {
			name = "Chrome Trim";
        }
		case 121:
        {
			name = "Wheelcovers";
        }
		case 122:
        {
			name = "Chrome Flames";
        }
		case 123:
        {
			name = "Bullbar Chrome Bars";
        }
		case 124:
        {
			name = "Chrome Arches";
        }
		case 125:
        {
			name = "Bullbar Chrome Lights";
        }
		case 126:
        {
			name = "Chrome";
        }
		case 127:
        {
			name = "Slamin";
        }
		case 128:
        {
			name = "Vinyl Hardtop";
        }
		case 129:
        {
			name = "Chrome";
        }
		case 130:
        {
			name = "Hardtop";
        }
		case 131:
        {
			name = "Softtop";
        }
		case 132:
        {
			name = "Slamin";
        }
		case 133:
        {
			name = "Chrome Strip";
        }
		case 134:
        {
			name = "Chrome Strip";
        }
		case 135:
        {
			name = "Slamin";
        }
		case 136:
        {
			name = "Chrome";
        }
		case 137:
        {
			name = "Chrome Strip";
        }
		case 138:
        {
			name = "Alien";
        }
		case 139:
        {
			name = "X-Flow";
        }
		case 140:
        {
			name = "X-Flow";
        }
		case 141:
        {
			name = "Alien";
        }
		case 142:
        {
			name = "Left Oval Vents";
        }
		case 143:
        {
			name = "Right Oval Vents";
        }
		case 144:
        {
			name = "Left Square Vents";
        }
		case 145:
        {
			name = "Right Square Vents";
        }
		case 146:
        {
			name = "X-Flow";
        }
		case 147:
        {
			name = "Alien";
        }
		case 148:
        {
			name = "X-Flow";
        }
		case 149:
        {
			name = "Alien";
        }
		case 150:
        {
			name = "Alien";
        }
		case 151:
        {
			name = "X-Flow";
        }
		case 152:
        {
			name = "X-Flow";
        }
		case 153:
        {
			name = "Alien";
        }
		case 154:
        {
			name = "Alien";
        }
		case 155:
        {
			name = "Alien";
        }
		case 156:
        {
			name = "X-Flow";
        }
		case 157:
        {
			name = "X-Flow";
        }
		case 158:
        {
			name = "X-Flow";
        }
		case 159:
        {
			name = "Alien";
        }
		case 160:
        {
			name = "Alien";
        }
		case 161:
        {
			name = "X-Flow";
        }
		case 162:
        {
			name = "Alien";
        }
		case 163:
        {
			name = "X-Flow";
        }
		case 164:
        {
			name = "Alien";
        }
		case 165:
        {
			name = "X-Flow";
        }
		case 166:
        {
			name = "Alien";
        }
		case 167:
        {
			name = "X-Flow";
        }
		case 168:
        {
			name = "Alien";
        }
		case 169:
        {
			name = "Alien";
        }
		case 170:
        {
			name = "X-Flow";
        }
		case 171:
        {
			name = "Alien";
        }
		case 172:
        {
			name = "X-Flow";
        }
		case 173:
        {
			name = "X-Flow";
        }
		case 174:
        {
			name = "Chrome";
        }
		case 175:
        {
			name = "Slamin";
        }
		case 176:
        {
			name = "Chrome";
        }
		case 177:
        {
			name = "Slamin";
        }
		case 178:
        {
			name = "Slamin";
        }
		case 179:
        {
			name = "Chrome";
        }
		case 180:
        {
			name = "Chrome";
        }
		case 181:
        {
			name = "Slamin";
        }
		case 182:
        {
			name = "Chrome";
        }
		case 183:
        {
			name = "Slamin";
        }
		case 184:
        {
			name = "Chrome";
        }
		case 185:
        {
			name = "Slamin";
        }
		case 186:
        {
			name = "Slamin";
        }
		case 187:
        {
			name = "Chrome";
        }
		case 188:
        {
			name = "Slamin";
        }
		case 189:
        {
			name = "Chrome";
        }
		case 190:
        {
			name = "Slamin";
        }
		case 191:
        {
			name = "Chrome";
        }
		case 192:
        {
			name = "Chrome";
        }
		case 193:
        {
			name = "Slamin";
        }
   	}
	return name;
}

stock GetXYBehindVehicle(vehicleid, &Float:x, &Float:y, Float:distance)
{
    new
        Float:a;
    GetVehiclePos( vehicleid, x, y, a );
    GetVehicleZAngle( vehicleid, a );
    x += ( distance * floatsin( -a+180, degrees ));
    y += ( distance * floatcos( -a+180, degrees ));
}

stock GetPosBehindVehicle(vehicleid, &Float:x, &Float:y, &Float:z, Float:offset=1.0)
{
	new Float:vehicleSize[3], Float:vehiclePos[3];
	GetVehiclePos(vehicleid, vehiclePos[0], vehiclePos[1], vehiclePos[2]);
	GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_SIZE, vehicleSize[0], vehicleSize[1], vehicleSize[2]);
	GetXYBehindVehicle(vehicleid, vehiclePos[0], vehiclePos[1], (vehicleSize[1]/2)+offset);
	x = vehiclePos[0];
	y = vehiclePos[1];
	z = vehiclePos[2];
	return 1;
}

stock ShowEditMenu(playerid)
{
	new
		iIndex = GetPVarInt(playerid, "ToySlot");

	new toys = 99999;			
	for(new i; i < 10; i++)
	{
		if(PlayerHoldingObject[playerid][i] == iIndex)
		{
			toys = i;
			if(IsPlayerAttachedObjectSlotUsed(playerid, toys))
			{
				PlayerHoldingObject[playerid][i] = 0;
				if(!PlayerInfo[playerid][pBEquipped]) RemovePlayerAttachedObject(playerid, toys);
			}
			break;
		}
	}	
	if(PlayerToyInfo[playerid][iIndex][ptScaleX] == 0) {
		PlayerToyInfo[playerid][iIndex][ptScaleX] = 1.0;
		PlayerToyInfo[playerid][iIndex][ptScaleY] = 1.0;
		PlayerToyInfo[playerid][iIndex][ptScaleZ] = 1.0;
	}
	if(IsPlayerInAnyVehicle(playerid) && PlayerToyInfo[playerid][iIndex][ptSpecial] == 2)
		return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Edit your toy", "You cannot edit toys while you are inside a vehicle!", "Okay", "");
	new toycount = GetFreeToySlot(playerid);
	if(toycount == -1) return SendClientMessageEx(playerid, COLOR_GRAD1, "You currently have 10 objects attached, please deattach an object.");
	if(toycount == 9 && PlayerInfo[playerid][pBEquipped]) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot attach an object to slot 10 since you have a backpack equipped.");
	PlayerHoldingObject[playerid][toycount] = iIndex;
	SetPlayerAttachedObject(playerid, toycount, PlayerToyInfo[playerid][iIndex][ptModelID],
	PlayerToyInfo[playerid][iIndex][ptBone], PlayerToyInfo[playerid][iIndex][ptPosX],
	PlayerToyInfo[playerid][iIndex][ptPosY], PlayerToyInfo[playerid][iIndex][ptPosZ],
	PlayerToyInfo[playerid][iIndex][ptRotX], PlayerToyInfo[playerid][iIndex][ptRotY],
	PlayerToyInfo[playerid][iIndex][ptRotZ], PlayerToyInfo[playerid][iIndex][ptScaleX],
	PlayerToyInfo[playerid][iIndex][ptScaleY], PlayerToyInfo[playerid][iIndex][ptScaleZ]);

    new stringg[128];
    format(stringg, sizeof(stringg), "Bone (%s)\nOffset", HoldingBones[PlayerToyInfo[playerid][iIndex][ptBone]]);
 	ShowPlayerDialog(playerid, EDITTOYS2, DIALOG_STYLE_LIST, "Toy Menu: Edit", stringg, "Select", "Cancel");
	return 1;
}

stock DynVeh_Spawn(iDvSlotID, free = 0)
{
	if(!(0 <= iDvSlotID < MAX_DYNAMIC_VEHICLES)) return 1;
	new string[128];
	format(string, sizeof(string), "Attempting to spawn DV Slot ID %d", iDvSlotID);
	Log("logs/dvspawn.log", string);
	new tmpdv = INVALID_VEHICLE_ID;
	if(DynVehicleInfo[iDvSlotID][gv_iSpawnedID] != INVALID_VEHICLE_ID)
	{
		tmpdv = DynVeh[DynVehicleInfo[iDvSlotID][gv_iSpawnedID]];
		DynVeh[DynVehicleInfo[iDvSlotID][gv_iSpawnedID]] = -1;
	}
	if(DynVehicleInfo[iDvSlotID][gv_iSpawnedID] != INVALID_VEHICLE_ID) {
		if(tmpdv == iDvSlotID) {
			format(string, sizeof(string), "Destroying Vehicle ID %d for DV Slot %d",DynVehicleInfo[iDvSlotID][gv_iSpawnedID], iDvSlotID);
			Log("logs/dvspawn.log", string);
			DestroyVehicle(DynVehicleInfo[iDvSlotID][gv_iSpawnedID]);
			DynVehicleInfo[iDvSlotID][gv_iSpawnedID] = INVALID_VEHICLE_ID;
			for(new i = 0; i != MAX_DV_OBJECTS; i++)
			{
				if(DynVehicleInfo[iDvSlotID][gv_iAttachedObjectID][i] != INVALID_OBJECT_ID) {
					DestroyDynamicObject(DynVehicleInfo[iDvSlotID][gv_iAttachedObjectID][i]);
					DynVehicleInfo[iDvSlotID][gv_iAttachedObjectID][i] = INVALID_OBJECT_ID;
				}
			}
		}
	}
	if(!(400 < DynVehicleInfo[iDvSlotID][gv_iModel] < 612)) {
		format(string, sizeof(string), "Invalid Vehicle Model ID for DV Slot %d", iDvSlotID);
		Log("logs/dvspawn.log", string);
		return 1;
	}
	if(DynVehicleInfo[iDvSlotID][gv_iDisabled]) return 1;
	if(free == 0)
	{
		if(DynVehicleInfo[iDvSlotID][gv_igID] != INVALID_GROUP_ID && tmpdv != -1) {
			new iGroupID = DynVehicleInfo[iDvSlotID][gv_igID];
			if(arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_LEA || arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_MEDIC || arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_JUDICIAL || arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_TAXI)
			{
				if(arrGroupData[iGroupID][g_iBudget] >= floatround(DynVehicleInfo[iDvSlotID][gv_iUpkeep] / 2))
				{
					arrGroupData[iGroupID][g_iBudget] -= floatround(DynVehicleInfo[iDvSlotID][gv_iUpkeep] / 2);
					new str[128], file[32];
					format(str, sizeof(str), "Vehicle Slot ID %d RTB fee cost $%d to %s's budget fund.", iDvSlotID, floatround(DynVehicleInfo[iDvSlotID][gv_iUpkeep] / 2), arrGroupData[iGroupID][g_szGroupName]);
					new month, day, year;
					getdate(year,month,day);
					format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", iGroupID, month, day, year);
					Log(file, str);
				}
				else
				{
					DynVehicleInfo[iDvSlotID][gv_iDisabled] = 1;
					return 1;
				}
			}
		}
	}
	DynVehicleInfo[iDvSlotID][gv_iSpawnedID] = CreateVehicle(DynVehicleInfo[iDvSlotID][gv_iModel], DynVehicleInfo[iDvSlotID][gv_fX], DynVehicleInfo[iDvSlotID][gv_fY], DynVehicleInfo[iDvSlotID][gv_fZ], DynVehicleInfo[iDvSlotID][gv_fRotZ], DynVehicleInfo[iDvSlotID][gv_iCol1], DynVehicleInfo[iDvSlotID][gv_iCol2], VEHICLE_RESPAWN);
	DynVeh_Save(iDvSlotID);
	format(string, sizeof(string), "Vehicle ID %d spawned for DV Slot %d",DynVehicleInfo[iDvSlotID][gv_iSpawnedID], iDvSlotID);
	Log("logs/dvspawn.log", string);
	SetVehicleHealth(DynVehicleInfo[iDvSlotID][gv_iSpawnedID], DynVehicleInfo[iDvSlotID][gv_fMaxHealth]);
	SetVehicleVirtualWorld(DynVehicleInfo[iDvSlotID][gv_iSpawnedID], DynVehicleInfo[iDvSlotID][gv_iVW]);
	LinkVehicleToInterior(DynVehicleInfo[iDvSlotID][gv_iSpawnedID], DynVehicleInfo[iDvSlotID][gv_iInt]);
	VehicleFuel[DynVehicleInfo[iDvSlotID][gv_iSpawnedID]] = DynVehicleInfo[iDvSlotID][gv_fFuel];
	DynVeh[DynVehicleInfo[iDvSlotID][gv_iSpawnedID]] = iDvSlotID;
	for(new i = 0; i != MAX_DV_OBJECTS; i++)
	{
		if(DynVehicleInfo[iDvSlotID][gv_iAttachedObjectModel][i] != INVALID_OBJECT_ID && DynVehicleInfo[iDvSlotID][gv_iAttachedObjectModel][i] != 0)
		{
			DynVehicleInfo[iDvSlotID][gv_iAttachedObjectID][i] = CreateDynamicObject(DynVehicleInfo[iDvSlotID][gv_iAttachedObjectModel][i],0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
			AttachDynamicObjectToVehicle(DynVehicleInfo[iDvSlotID][gv_iAttachedObjectID][i], DynVehicleInfo[iDvSlotID][gv_iSpawnedID], DynVehicleInfo[iDvSlotID][gv_fObjectX][i], DynVehicleInfo[iDvSlotID][gv_fObjectY][i], DynVehicleInfo[iDvSlotID][gv_fObjectZ][i], DynVehicleInfo[iDvSlotID][gv_fObjectRX][i], DynVehicleInfo[iDvSlotID][gv_fObjectRY][i], DynVehicleInfo[iDvSlotID][gv_fObjectRZ][i]);
		}
	}
	if(!isnull(DynVehicleInfo[iDvSlotID][gv_iPlate])) {
		SetVehicleNumberPlate(DynVehicleInfo[iDvSlotID][gv_iSpawnedID], DynVehicleInfo[iDvSlotID][gv_iPlate]);
	}
	Vehicle_ResetData(DynVehicleInfo[iDvSlotID][gv_iSpawnedID]);
	LoadGroupVehicleMods(DynVehicleInfo[iDvSlotID][gv_iSpawnedID]);
    return 1;
}

stock Group_NumToDialogHex(iValue)
{
	new szValue[7];
	format(szValue, sizeof(szValue), "%x", iValue);
	new i, padlength = 6 - strlen(szValue);
	while (i++ != padlength) {
		strins(szValue, "0", 0, 7);
	}
	return szValue;
}

stock GivePlayerStoreItem(playerid, type, business, item, price)
{
	if(Businesses[business][bInventory] <= StoreItemCost[item-1][ItemValue]) return SendClientMessageEx(playerid, COLOR_GRAD2, "The store does not have enough stock for that item!");
	new string[256];
	switch (item)
  	{
  		case ITEM_CELLPHONE:
		{
			new randphone = 99999 + random(900000);
			new query[128];
			SetPVarInt(playerid, "WantedPh", randphone);
			SetPVarInt(playerid, "CurrentPh", PlayerInfo[playerid][pPnumber]);
	        SetPVarInt(playerid, "PhChangeCost", 500);
			format(query, sizeof(query), "SELECT `Username` FROM `accounts` WHERE `PhoneNr` = '%d'",randphone);
			mysql_function_query(MainPipeline, query, true, "OnPhoneNumberCheck", "ii", playerid, 2);
		}
  		case ITEM_PHONEBOOK:
		{
			PlayerInfo[playerid][pPhoneBook] = 1;
			SendClientMessageEx(playerid, COLOR_GRAD4, "Phonebook purchased, you can now look up other player's numbers.");
			SendClientMessageEx(playerid, COLOR_WHITE, "HINT: Type /number <id/name>.");
		}
  		case ITEM_DICE:
		{
			PlayerInfo[playerid][pDice] = 1;
			SendClientMessageEx(playerid, COLOR_GRAD4, "Dice purchased.");

		}
  		case ITEM_CONDOM:
		{
			Condom[playerid]++;
			SendClientMessageEx(playerid, COLOR_GRAD4, "Condom Purchased.");
		}
  		case ITEM_MUSICPLAYER:
		{
			PlayerInfo[playerid][pCDPlayer] = 1;
			SendClientMessageEx(playerid, COLOR_GRAD4, "Music Player purchased.");
			SendClientMessageEx(playerid, COLOR_WHITE, "HINT: Type /music");
		}
  		case ITEM_ROPE:
		{
			if(PlayerInfo[playerid][pRope] < 8)
			{
				PlayerInfo[playerid][pRope] += 3;
				SendClientMessageEx(playerid, COLOR_GRAD4, "3 Ropes purchased.");
				SendClientMessageEx(playerid, COLOR_WHITE, "HINT: Type /tie while driving a car to tie someone.");
			}
			else return SendClientMessageEx(playerid, COLOR_GRAD4, "You can't hold any more of this item!");
		}
  		case ITEM_CIGAR:
		{
			PlayerInfo[playerid][pCigar] = 10;
			SendClientMessageEx(playerid, COLOR_GRAD4, "10 cigars purchased.");
			SendClientMessageEx(playerid, COLOR_WHITE, "HINT: Type /usecigar to use your cigars. Left mouse button to smoke it, F to throw it away.");
		}
  		case ITEM_SPRUNK:
		{
			PlayerInfo[playerid][pSprunk] = 1;
			SendClientMessageEx(playerid, COLOR_GRAD4, "Sprunk purchased.");
			SendClientMessageEx(playerid, COLOR_WHITE, "HINT: Type /usesprunk to drink a can of Sprunk. Left mouse button to take a sip, F to throw it away.");
		}
  		case ITEM_VEHICLELOCK:
		{
			PlayerInfo[playerid][pLock] = 1;
			SendClientMessageEx(playerid, COLOR_GRAD4, "Vehicle Lock purchased.");
			SendClientMessageEx(playerid, COLOR_WHITE, "HINT: Type /lock to lock your vehicle.");
		}
		case ITEM_SPRAYCAN:
		{
			if(PlayerInfo[playerid][pSpraycan] < 20)
			{
				PlayerInfo[playerid][pSpraycan] += 10;
				SendClientMessageEx(playerid, COLOR_GRAD4, "10 Spraycans purchased.");
				SendClientMessageEx(playerid, COLOR_WHITE, "HINT: Type /colorcar or /paintcar while inside a vehicle.");
			}
			else return SendClientMessageEx(playerid, COLOR_GRAD4, "You can't hold any more of this item!");
		}
  		case ITEM_RADIO:
		{
			PlayerInfo[playerid][pRadio] = 1;
			PlayerInfo[playerid][pRadioFreq] = 0;
			SendClientMessageEx(playerid, COLOR_GRAD4, "Portable radio purchased.");
			SendClientMessageEx(playerid, COLOR_WHITE, "HINT: Type /pr to talk over your portable radio.");
			SendClientMessageEx(playerid, COLOR_WHITE, "HINT: Type /setfreq to set the frequency of your portable radio.");
		}
  		case ITEM_CAMERA:
		{
			GivePlayerValidWeapon(playerid, WEAPON_CAMERA, 99999);
			SendClientMessageEx(playerid, COLOR_GRAD4, "Camera purchased.");
			SendClientMessageEx(playerid, COLOR_WHITE, "HINT: Remember look into the viewfinder and take a picture.");
		}
  		case ITEM_LOTTERYTICKET:
		{
			ShowPlayerDialog(playerid, LOTTOMENU, DIALOG_STYLE_INPUT, "Lottery Ticket Selection","Please enter a Lotto Number", "Select", "Cancel" );
		}
  		case ITEM_CHECKBOOK:
		{
	        if(PlayerInfo[playerid][pChecks] == 0)
	    	{
		        PlayerInfo[playerid][pChecks] += 10;
			    SendClientMessageEx(playerid, COLOR_GRAD4, "Checkbook purchased, you now have 10 checks.");
			    SendClientMessageEx(playerid, COLOR_WHITE, "HINT: Type /writecheck to write a check.");
		    }
			else return SendClientMessageEx(playerid, COLOR_GREY, "You still have unused checks, please use them before getting another checkbook.");
		}
  		case ITEM_PAPERS:
		{
	        if(PlayerInfo[playerid][pPaper] == 0)
	        {
		        PlayerInfo[playerid][pPaper] = 15;
			    SendClientMessageEx(playerid, COLOR_GRAD4, "Papers purchased, you now have 15 writing papers for sending letters.");
		    }
			else return SendClientMessageEx(playerid, COLOR_GREY, "You still have unused papers, please use them before getting more papers.");
		}
		case ITEM_SCALARM:
		{
			if(GetPlayerVehicleCount(playerid) != 0)
			{
				SetPVarInt(playerid, "lockmenu", 1);
				for(new i=0; i<MAX_PLAYERVEHICLES; i++)
				{
					if(PlayerVehicleInfo[playerid][i][pvId] != INVALID_PLAYER_VEHICLE_ID)
					{
						format(string, sizeof(string), "Vehicle %d| Name: %s.",i+1,GetVehicleName(PlayerVehicleInfo[playerid][i][pvId]));
						SendClientMessageEx(playerid, COLOR_WHITE, string);
					}
				}
				return ShowPlayerDialog(playerid, DIALOG_CDLOCKMENU, DIALOG_STYLE_INPUT, "24-7;"," Select a vehicle you wish to install this on:", "Select", "Cancel");
			}
			else return SendClientMessageEx(playerid, COLOR_WHITE, "You don't have any cars - where we can install this item?");
		}
		case ITEM_ELOCK:
		{
			if(GetPlayerVehicleCount(playerid) != 0)
			{
				SetPVarInt(playerid, "lockmenu", 2);
				for(new i=0; i<MAX_PLAYERVEHICLES; i++)
				{
					if(PlayerVehicleInfo[playerid][i][pvId] != INVALID_PLAYER_VEHICLE_ID)
					{
						format(string, sizeof(string), "Vehicle %d | Name: %s.",i+1,GetVehicleName(PlayerVehicleInfo[playerid][i][pvId]));
						SendClientMessageEx(playerid, COLOR_WHITE, string);
					}
				}
				return ShowPlayerDialog(playerid, DIALOG_CDLOCKMENU, DIALOG_STYLE_INPUT, "24-7;"," Select a vehicle you wish to install this on:", "Select", "Cancel");
			}
			else return SendClientMessageEx(playerid, COLOR_WHITE, "You don't have any cars - where we can install this item?");
		}
		case ITEM_ILOCK:
		{
			if(GetPlayerVehicleCount(playerid) != 0)
			{
				SetPVarInt(playerid, "lockmenu", 3);
				for(new i=0; i<MAX_PLAYERVEHICLES; i++)
				{
					if(PlayerVehicleInfo[playerid][i][pvId] != INVALID_PLAYER_VEHICLE_ID)
					{
						format(string, sizeof(string), "Vehicle %d | Name: %s.",i+1,GetVehicleName(PlayerVehicleInfo[playerid][i][pvId]));
						SendClientMessageEx(playerid, COLOR_WHITE, string);
					}
				}
				return ShowPlayerDialog(playerid, DIALOG_CDLOCKMENU, DIALOG_STYLE_INPUT, "24-7;"," Select a vehicle you wish to install this on:", "Select", "Cancel");
			}
			else return SendClientMessageEx(playerid, COLOR_WHITE, "You don't have any cars - where we can install this item?");
		}
		case ITEM_HELMET:
		{
			/* if(GetPlayerVehicleCount(playerid) != 0)
			{ */
			SetPVarInt(playerid, "helmetsel", 1);
			SetPVarInt(playerid, "helcost", price);
			SetPVarInt(playerid, "businessid", business);
			SetPVarInt(playerid, "item", item);
			new models[8] = {18936, 18937, 18938, 18976, 18977, 18978, 18979, 18645};
			return ShowModelSelectionMenuEx(playerid, models, sizeof(models), "Helmet Selector", 1339, 0.0, 0.0, 120.0);
			/* }
			else return SendClientMessageEx(playerid, COLOR_WHITE, "You don't have any cars - where we can install this item?"); */
		}
		default:
		{
			printf("Error %d ITEM", item);
		    return 0;
		}
	}
	Businesses[business][bInventory] -= StoreItemCost[item-1][ItemValue];
	Businesses[business][bTotalSales]++;
	Businesses[business][bSafeBalance] += TaxSale(price);
	GivePlayerCash(playerid, -price);
	if(PlayerInfo[playerid][pBusiness] != InBusiness(playerid)) Businesses[business][bLevelProgress]++;
	SaveBusiness(business);
	PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	switch(type)
	{
		case 0:
		{
			format(string,sizeof(string),"%s(%d) (IP: %s) has bought a %s in %s (%d) for $%s.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), StoreItems[item-1], Businesses[business][bName], business, number_format(price));
			Log("logs/business.log", string);
			format(string,sizeof(string),"* You have purchased a %s from %s for $%s.", StoreItems[item-1], Businesses[business][bName], number_format(price));
			SendClientMessage(playerid, COLOR_GRAD2, string);
		}
		case 1:
		{
			new offerer = GetPVarInt(playerid, "Business_ItemOfferer");
			format(string, sizeof(string), "%s %s(%d) (IP: %s) has sold a %s to %s (IP: %s) for $%s in %s (%d)", GetBusinessRankName(PlayerInfo[offerer][pBusinessRank]), GetPlayerNameEx(offerer), GetPlayerSQLId(offerer), GetPlayerIpEx(offerer), StoreItems[item-1], GetPlayerNameEx(playerid), GetPlayerIpEx(playerid), number_format(price), Businesses[business][bName], business);
			Log("logs/business.log", string);
			format(string,sizeof(string),"* %s has purchased the %s from you for $%s.", GetPlayerNameEx(playerid), StoreItems[item-1], number_format(price));
			SendClientMessage(offerer, COLOR_GRAD2, string);
			format(string,sizeof(string),"* You have purchased the %s from %s for $%s.", StoreItems[item-1], GetPlayerNameEx(offerer), number_format(price));
			SendClientMessage(playerid, COLOR_GRAD2, string);
			DeletePVar(playerid, "Business_ItemType");
			DeletePVar(playerid, "Business_ItemPrice");
			DeletePVar(playerid, "Business_ItemOfferer");
			DeletePVar(playerid, "Business_ItemOffererSQLId");
		}
	}
	return 1;
}

stock FIXES_valstr(dest[], value, bool:pack = false)
{
    // format can't handle cellmin properly
    static const cellmin_value[] = !"-2147483648";

    if (value == cellmin)
        pack && strpack(dest, cellmin_value, 12) || strunpack(dest, cellmin_value, 12);
    else
        format(dest, 12, "%d", value) && pack && strpack(dest, dest, 12);
}

stock GetClosestPlayer(p1)
{
	new Float:dis,Float:dis2,player;
	player = -1;
	dis = 99999.99;
	foreach(new x: Player)
	{
		if(x != p1)
		{
			dis2 = GetDistanceBetweenPlayers(x,p1);
			if(dis2 < dis && dis2 != -1.00)
			{
				dis = dis2;
				player = x;
			}
		}
	}	
	return player;
}

stock Float: FormatFloat(Float:number) {
    if(number != number) return 0.0;
    else return number;
}

stock OnPlayerStatsUpdate(playerid) {
	if(gPlayerLogged{playerid}) {
		if(!GetPVarType(playerid, "TempName") && !GetPVarInt(playerid, "EventToken") && GetPVarInt(playerid, "IsInArena") == -1) {
		    new Float: Pos[4], Float: Health[2];
			GetHealth(playerid, Health[0]);
			GetArmour(playerid, Health[1]);

			PlayerInfo[playerid][pInt] = GetPlayerInterior(playerid);
			PlayerInfo[playerid][pVW] = GetPlayerVirtualWorld(playerid);

			GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
			GetPlayerFacingAngle(playerid, Pos[3]);

			PlayerInfo[playerid][pHealth] = FormatFloat(Health[0]);
			PlayerInfo[playerid][pArmor] = FormatFloat(Health[1]);
		    if(IsPlayerInRangeOfPoint(playerid, 1200, -1083.90002441,4289.70019531,7.59999990) && PlayerInfo[playerid][pMember] == INVALID_GROUP_ID)
			{
				PlayerInfo[playerid][pInt] = 0;
				PlayerInfo[playerid][pVW] = 0;
				GetPlayerFacingAngle(playerid, PlayerInfo[playerid][pPos_r]);
				PlayerInfo[playerid][pPos_x] = 1529.6;
				PlayerInfo[playerid][pPos_y] = -1691.2;
				PlayerInfo[playerid][pPos_z] = 13.3;
			}
			else if(GetPVarInt(playerid, "ShopTP") == 1 && GetPVarFloat(playerid, "tmpX") != 0)
			{
				PlayerInfo[playerid][pPos_x] = GetPVarFloat(playerid, "tmpX");
				PlayerInfo[playerid][pPos_y] = GetPVarFloat(playerid, "tmpY");
				PlayerInfo[playerid][pPos_z] = GetPVarFloat(playerid, "tmpZ");
				PlayerInfo[playerid][pInt] = GetPVarInt(playerid, "tmpInt");
				PlayerInfo[playerid][pVW] = GetPVarInt(playerid, "tmpVW");
			}
			else
			{
				PlayerInfo[playerid][pPos_x] = FormatFloat(Pos[0]);
				PlayerInfo[playerid][pPos_y] = FormatFloat(Pos[1]);
				PlayerInfo[playerid][pPos_z] = FormatFloat(Pos[2]);
				PlayerInfo[playerid][pPos_r] = FormatFloat(Pos[3]);
			}
		}
		g_mysql_SaveAccount(playerid);
	}
	return 1;
}

stock ConvertToTwelveHour(tHour)
{
	new string[56], suffix[3], cHour;
	if(tHour > 12 && tHour < 24)
	{
		cHour = tHour - 12;
		suffix = "PM";
	}
	else if(tHour == 12)
	{
		cHour = 12;
		suffix = "PM";
	}
	else if(tHour > 0 && tHour < 12)
	{
		cHour = tHour;
		suffix = "AM";
	}
	else if(tHour == 0)
	{
		cHour = 12;
		suffix = "AM";
	}
	format(string, sizeof(string), "%d%s", cHour, suffix);
	return string;
}

forward SyncTime();
public SyncTime()
{
	new string[128], tmphour, tmpminute, tmpsecond;
	gettime(tmphour, tmpminute, tmpsecond);
	FixHour(tmphour);
	tmphour = shifthour;

	if ((tmphour > ghour) || (tmphour == 0 && ghour == 23))
	{
	    SavePlants();
	    if(tmphour == 3 || tmphour == 6 || tmphour == 9 || tmphour == 12 || tmphour == 15 || tmphour == 18 || tmphour == 21 || tmphour == 0) PrepareLotto();
		else
		{
		    if(SpecLotto) {
		        format(string, sizeof(string), "Special Lottery: Remember to buy a lotto ticket at a 24/7. Next drawing is at %s. The total jackpot is $%s", ConvertToTwelveHour(tmphour), number_format(Jackpot));
				SendClientMessageToAllEx(COLOR_WHITE, string);
		        format(string, sizeof(string), "Special Prize: %s", LottoPrize);
				SendClientMessageToAllEx(COLOR_WHITE, string);
		    }
		    else {
		    	format(string, sizeof(string), "Lottery: Remember to buy a lotto ticket at a 24/7. Next drawing is at %s. The total jackpot is $%s", ConvertToTwelveHour(tmphour), number_format(Jackpot));
				SendClientMessageToAllEx(COLOR_WHITE, string);
			}
		}
		for(new iGroupID; iGroupID < MAX_GROUPS; iGroupID++)
		{
			if(arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_GOV && arrGroupData[iGroupID][g_iAllegiance] == 1)
			{
				new str[128], file[32];
				format(str, sizeof(str), "The tax vault is at $%s", number_format(Tax));
				new month, day, year;
				getdate(year,month,day);
				format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", iGroupID, month, day, year);
				Log(file, str);
			}
			else if(arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_GOV && arrGroupData[iGroupID][g_iAllegiance] == 2)
			{
				new str[128], file[32];
				format(str, sizeof(str), "The tax vault is at $%s", number_format(TRTax));
				new month, day, year;
				getdate(year,month,day);
				format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", iGroupID, month, day, year);
				Log(file, str);
			}
			else
			{
				new str[128], file[32];
				format(str, sizeof(str), "The faction vault is at $%s", number_format(arrGroupData[iGroupID][g_iBudget]));
				new month, day, year;
				getdate(year,month,day);
				format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", iGroupID, month, day, year);
				Log(file, str);
			}
			if(arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_LEA || arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_MEDIC || arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_JUDICIAL || arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_TAXI)
			{
				if(arrGroupData[iGroupID][g_iBudgetPayment] > 0)
				{
					if(Tax > arrGroupData[iGroupID][g_iBudgetPayment] && arrGroupData[iGroupID][g_iAllegiance] == 1)
					{
						Tax -= arrGroupData[iGroupID][g_iBudgetPayment];
						arrGroupData[iGroupID][g_iBudget] += arrGroupData[iGroupID][g_iBudgetPayment];
						new str[128], file[32];
						format(str, sizeof(str), "SA Gov Paid $%s to %s budget fund.", number_format(arrGroupData[iGroupID][g_iBudgetPayment]), arrGroupData[iGroupID][g_szGroupName]);
						new month, day, year;
						getdate(year,month,day);
						format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", iGroupID, month, day, year);
						Log(file, str);
						Misc_Save();
						SaveGroup(iGroupID);
						for(new z; z < MAX_GROUPS; z++)
						{
							if(arrGroupData[z][g_iAllegiance] == 1)
							{
								if(arrGroupData[z][g_iGroupType] == GROUP_TYPE_GOV)
								{
									format(str, sizeof(str), "SA Gov Paid $%s to %s budget fund.", number_format(arrGroupData[iGroupID][g_iBudgetPayment]), arrGroupData[iGroupID][g_szGroupName]);
									format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", z, month, day, year);
									Log(file, str);
									break;
								}
							}
						}
					}
					else if(TRTax > arrGroupData[iGroupID][g_iBudgetPayment] && arrGroupData[iGroupID][g_iAllegiance] == 2)
					{
						TRTax -= arrGroupData[iGroupID][g_iBudgetPayment];
						arrGroupData[iGroupID][g_iBudget] += arrGroupData[iGroupID][g_iBudgetPayment];
						new str[128], file[32];
						format(str, sizeof(str), "TR Gov Paid $%s to %s budget fund.", number_format(arrGroupData[iGroupID][g_iBudgetPayment]), arrGroupData[iGroupID][g_szGroupName]);
						new month, day, year;
						getdate(year,month,day);
						format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", iGroupID, month, day, year);
						Log(file, str);
						Misc_Save();
						SaveGroup(iGroupID);
						for(new z; z < MAX_GROUPS; z++)
						{
							if(arrGroupData[z][g_iAllegiance] == 2)
							{
								if(arrGroupData[z][g_iGroupType] == GROUP_TYPE_GOV)
								{
									format(str, sizeof(str), "TR Gov Paid $%s to %s budget fund.", number_format(arrGroupData[iGroupID][g_iBudgetPayment]), arrGroupData[iGroupID][g_szGroupName]);
									format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", z, month, day, year);
									Log(file, str);
									break;
								}
							}
						}
					}
					else
					{
						format(string, sizeof(string), "Warning: The Government Vault has insufficient funds to fund %s.", arrGroupData[iGroupID][g_szGroupName]);
						SendGroupMessage(5, COLOR_RED, string);
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
								new str[128], file[32];
								format(str, sizeof(str), "Vehicle ID %d (Slot ID %d) Maintainence fee cost $%s to %s's budget fund.",DynVehicleInfo[iDvSlotID][gv_iSpawnedID], iDvSlotID, number_format(DynVehicleInfo[iDvSlotID][gv_iUpkeep]), arrGroupData[iGroupID][g_szGroupName]);
								new month, day, year;
								getdate(year,month,day);
								format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", iGroupID, month, day, year);
								Log(file, str);
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
			}
		}

		WeatherCalling += random(5) + 1;
		#if defined zombiemode
  		if(WeatherCalling > 20)
		{
  			WeatherCalling = 0;
	    	gWeather = random(19) + 1;
		    if(gWeather == 1) gWeather=10;
		    if(zombieevent == 0) SetWeather(gWeather);
		}
		#else
		if(WeatherCalling > 20)
		{
 			WeatherCalling = 0;
   			gWeather = random(19) + 1;
		    if(gWeather == 1) gWeather=10;
		    SetWeather(gWeather);
		}
		#endif

		ghour = tmphour;
		TotalUptime += 1;
		GiftAllowed = 1;
		
		new bmonth, bday, byear;
		new year, month, day;
		getdate(year, month, day);		

		//foreach(new i: Player)
		format(string, sizeof(string), "The time is now %s.", ConvertToTwelveHour(tmphour));
		SendClientMessageToAllEx(COLOR_WHITE, string);
		new query[300];
		format(query, sizeof(query), "SELECT b.shift, b.needs_%s, COUNT(DISTINCT s.id) as ShiftCount FROM cp_shift_blocks b LEFT JOIN cp_shifts s ON b.shift_id = s.shift_id AND s.date = '%d-%02d-%02d' AND s.status >= 2 AND s.type = 1 WHERE b.time_start = '%02d:00:00' AND b.type = 1 GROUP BY b.shift, b.needs_%s", GetWeekday(), year, month, day, tmphour, GetWeekday());
		mysql_function_query(MainPipeline, query, true, "GetShiftInfo", "is", INVALID_PLAYER_ID, string);
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
						format(query, sizeof(query), "UPDATE `accounts` SET `LastBirthday`=%d WHERE `Username` = '%s'", PlayerInfo[i][pLastBirthday], GetPlayerNameExt(i));
						mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "ii", SENDDATA_THREAD, i);
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
						format(string, sizeof(string), "Happy Birthday %s! You have received a free gift!", GetPlayerNameEx(i));
						SendClientMessageEx(i, COLOR_YELLOW, string);
						format(string, sizeof(string), "%s(%d) has received a free gift for his birthday (%s) (Payday).", GetPlayerNameEx(i), GetPlayerSQLId(i), PlayerInfo[i][pBirthDate]);
						Log("logs/birthday.log", string);
						SendClientMessageEx(i, COLOR_YELLOW, "Gold VIP: You will get x2 paycheck as a birthday gift today.");
						OnPlayerStatsUpdate(i);
					}
				}
			}
		}	

		SetWorldTime(tmphour);

		if(tmphour == 0) CountCitizens();

		for (new x = 0; x < MAX_POINTS; x++)
		{
			Points[x][Announced] = 0;
			if (Points[x][Vulnerable] > 0)
			{
				Points[x][Vulnerable]--;
				UpdatePoints();
			}
			if (Points[x][Vulnerable] == 0 && Points[x][Type] >= 0 && Points[x][Announced] == 0 && Points[x][ClaimerId] == INVALID_PLAYER_ID)
			{
				format(string, sizeof(string), "%s has become available for capture.", Points[x][Name]);
				SendClientMessageToAllEx(COLOR_YELLOW, string);
				//SetPlayerCheckpoint(i, Points[i][Pointx], Points[i][Pointy], Points[i][Pointz], 3);
				ReadyToCapture(x);
				Points[x][Announced] = 1;
			}
		}
		Misc_Save();
		FMemberCounter(); // Family member counter (requested by game affairs to track gang activity)

		for(new i = 0; i < MAX_TURFS; i++)
		{
			if(TurfWars[i][twVulnerable] > 0)
			{
			    TurfWars[i][twVulnerable]--;
			    if(TurfWars[i][twVulnerable] == 0)
			    {
			    	if(TurfWars[i][twOwnerId] != -1)
			    	{
			        	format(string,sizeof(string),"%s that you currently own is vulnerable for capture!",TurfWars[i][twName]);
			        	SendNewFamilyMessage(i, COLOR_YELLOW, string);
			    	}
				}
			}
		}

		for(new i = 1; i < MAX_FAMILY; i++)
		{
		    if(FamilyInfo[i][FamilyTurfTokens] < 24)
		    {
		        FamilyInfo[i][FamilyTurfTokens]++;
		        switch(FamilyInfo[i][FamilyTurfTokens])
		        {
					case 12:
					{
		        		SendNewFamilyMessage(i, COLOR_WHITE, "Your family/gang now has 1 Turf Token, you may /claim to use it.");
					}
					case 24:
					{
					    SendNewFamilyMessage(i, COLOR_WHITE, "Your family/gang now has 2 Turf Tokens, you may /claim to use them.");
					}
		        }
		    }
		}
		SaveFamilies();
	}
}

stock splits(const strsrc[], strdest[][], delimiter)
{
	new i, li;
	new aNum;
	new len;
	while(i <= strlen(strsrc)){
		if(strsrc[i]==delimiter || i==strlen(strsrc)){
			len = strmid(strdest[aNum], strsrc, li, i, 128);
			strdest[aNum][len] = 0;
			li = i+1;
			aNum++;
		}
		i++;
	}
	return 1;
}

Float:DistanceCameraTargetToLocation(Float:CamX, Float:CamY, Float:CamZ,  Float:ObjX, Float:ObjY, Float:ObjZ,  Float:FrX, Float:FrY, Float:FrZ)
{

    new Float:TGTDistance;

    // get distance from camera to target
    TGTDistance = floatsqroot((CamX - ObjX) * (CamX - ObjX) + (CamY - ObjY) * (CamY - ObjY) + (CamZ - ObjZ) * (CamZ - ObjZ));

    new Float:tmpX, Float:tmpY, Float:tmpZ;

    tmpX = FrX * TGTDistance + CamX;
    tmpY = FrY * TGTDistance + CamY;
    tmpZ = FrZ * TGTDistance + CamZ;

    return floatsqroot((tmpX - ObjX) * (tmpX - ObjX) + (tmpY - ObjY) * (tmpY - ObjY) + (tmpZ - ObjZ) * (tmpZ - ObjZ));
}

stock IsPlayerAimingAt(playerid, Float:x, Float:y, Float:z, Float:radius)
{
    new Float:cx,Float:cy,Float:cz,Float:fx,Float:fy,Float:fz;
    GetPlayerCameraPos(playerid, cx, cy, cz);
    GetPlayerCameraFrontVector(playerid, fx, fy, fz);
    return (radius >= DistanceCameraTargetToLocation(cx, cy, cz, x, y, z, fx, fy, fz));
}

stock HireCost(carid)
{
	switch (carid)
	{
		case 69:
		{
			return 90000; //bullit
		}
		case 70:
		{
			return 130000; //infurnus
		}
		case 71:
		{
			return 100000; //turismo
		}
		case 72:
		{
			return 80000;
		}
		case 73:
		{
			return 70000;
		}
		case 74:
		{
			return 60000;
		}
	}
	return 0;
}

stock SaveMailboxes()
{
	for(new i = 0; i < MAX_MAILBOXES; i++)
	{
		SaveMailbox(i);
	}
	return 1;
}

stock UpdatePoints()
{
	for(new i; i < MAX_POINTS; i++)
	{
		SavePoint(i);
	}
}

stock CreateDynamicDoor(doorid)
{
	if(IsValidDynamicPickup(DDoorsInfo[doorid][ddPickupID])) DestroyDynamicPickup(DDoorsInfo[doorid][ddPickupID]);
	if(IsValidDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID])) DestroyDynamic3DTextLabel(DDoorsInfo[doorid][ddTextID]);
	if(DDoorsInfo[doorid][ddExteriorX] == 0.0) return 1;
	new string[128];
	if(DDoorsInfo[doorid][ddType] != 0) format(string, sizeof(string), "%s | Owner: %s\nID: %d", DDoorsInfo[doorid][ddDescription], StripUnderscore(DDoorsInfo[doorid][ddOwnerName]), doorid);
	else format(string, sizeof(string), "%s\nID: %d", DDoorsInfo[doorid][ddDescription], doorid);

	switch(DDoorsInfo[doorid][ddColor])
	{
	    case -1:{ /* Disable 3d Textdraw */ }
	    case 1:{DDoorsInfo[doorid][ddTextID] = CreateDynamic3DTextLabel(string, COLOR_TWWHITE, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ]+1,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, DDoorsInfo[doorid][ddExteriorVW], DDoorsInfo[doorid][ddExteriorInt], -1);}
	    case 2:{DDoorsInfo[doorid][ddTextID] = CreateDynamic3DTextLabel(string, COLOR_TWPINK, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ]+1,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, DDoorsInfo[doorid][ddExteriorVW], DDoorsInfo[doorid][ddExteriorInt], -1);}
	    case 3:{DDoorsInfo[doorid][ddTextID] = CreateDynamic3DTextLabel(string, COLOR_TWRED, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ]+1,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, DDoorsInfo[doorid][ddExteriorVW], DDoorsInfo[doorid][ddExteriorInt], -1);}
	    case 4:{DDoorsInfo[doorid][ddTextID] = CreateDynamic3DTextLabel(string, COLOR_TWBROWN, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ]+1,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, DDoorsInfo[doorid][ddExteriorVW], DDoorsInfo[doorid][ddExteriorInt], -1);}
	    case 5:{DDoorsInfo[doorid][ddTextID] = CreateDynamic3DTextLabel(string, COLOR_TWGRAY, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ]+1,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, DDoorsInfo[doorid][ddExteriorVW], DDoorsInfo[doorid][ddExteriorInt], -1);}
	    case 6:{DDoorsInfo[doorid][ddTextID] = CreateDynamic3DTextLabel(string, COLOR_TWOLIVE, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ]+1,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, DDoorsInfo[doorid][ddExteriorVW], DDoorsInfo[doorid][ddExteriorInt], -1);}
	    case 7:{DDoorsInfo[doorid][ddTextID] = CreateDynamic3DTextLabel(string, COLOR_TWPURPLE, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ]+1,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, DDoorsInfo[doorid][ddExteriorVW], DDoorsInfo[doorid][ddExteriorInt], -1);}
	    case 8:{DDoorsInfo[doorid][ddTextID] = CreateDynamic3DTextLabel(string, COLOR_TWORANGE, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ]+1,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, DDoorsInfo[doorid][ddExteriorVW], DDoorsInfo[doorid][ddExteriorInt], -1);}
	    case 9:{DDoorsInfo[doorid][ddTextID] = CreateDynamic3DTextLabel(string, COLOR_TWAZURE, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ]+1,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, DDoorsInfo[doorid][ddExteriorVW], DDoorsInfo[doorid][ddExteriorInt], -1);}
	    case 10:{DDoorsInfo[doorid][ddTextID] = CreateDynamic3DTextLabel(string, COLOR_TWGREEN, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ]+1,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, DDoorsInfo[doorid][ddExteriorVW], DDoorsInfo[doorid][ddExteriorInt], -1);}
	    case 11:{DDoorsInfo[doorid][ddTextID] = CreateDynamic3DTextLabel(string, COLOR_TWBLUE, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ]+1,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, DDoorsInfo[doorid][ddExteriorVW], DDoorsInfo[doorid][ddExteriorInt], -1);}
	    case 12:{DDoorsInfo[doorid][ddTextID] = CreateDynamic3DTextLabel(string, COLOR_TWBLACK, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ]+1,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, DDoorsInfo[doorid][ddExteriorVW], DDoorsInfo[doorid][ddExteriorInt], -1);}
		default:{DDoorsInfo[doorid][ddTextID] = CreateDynamic3DTextLabel(string, COLOR_YELLOW, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ]+1,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, DDoorsInfo[doorid][ddExteriorVW], DDoorsInfo[doorid][ddExteriorInt], -1);}
	}

	switch(DDoorsInfo[doorid][ddPickupModel])
	{
	    case -1: { /* Disable Pickup */ }
		case 1:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1210, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
		case 2:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1212, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
		case 3:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1239, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
		case 4:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1240, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
		case 5:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1241, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
		case 6:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1242, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
		case 7:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1247, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
		case 8:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1248, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
		case 9:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1252, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
		case 10:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1253, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
		case 11:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1254, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
		case 12:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1313, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
		case 13:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1272, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
		case 14:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1273, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
		case 15:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1274, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
		case 16:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1275, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
		case 17:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1276, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
		case 18:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1277, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
		case 19:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1279, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
		case 20:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1314, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
		case 21:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1316, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
		case 22:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1317, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
		case 23:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1559, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
		case 24:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1582, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
		case 25:{DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(2894, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);}
	    default:
	    {
			DDoorsInfo[doorid][ddPickupID] = CreateDynamicPickup(1318, 23, DDoorsInfo[doorid][ddExteriorX], DDoorsInfo[doorid][ddExteriorY], DDoorsInfo[doorid][ddExteriorZ], DDoorsInfo[doorid][ddExteriorVW]);
	    }
	}
	return 1;
}

stock InitEventPoints()
{
	for(new i = 0; i < MAX_EVENTPOINTS; i++)
	{
	    EventPoints[i][epObjectID] = 0;
	}
	return 1;
}

stock vehicle_lock_doors(vehicle) {

	new
		vParamArr[7];

	GetVehicleParamsEx(vehicle, vParamArr[0], vParamArr[1], vParamArr[2], vParamArr[3], vParamArr[4], vParamArr[5], vParamArr[6]);
	return SetVehicleParamsEx(vehicle, vParamArr[0], vParamArr[1], vParamArr[2], VEHICLE_PARAMS_ON, vParamArr[4], vParamArr[5], vParamArr[6]);
}

stock vehicle_unlock_doors(vehicle) {

	new
		vParamArr[7];

	GetVehicleParamsEx(vehicle, vParamArr[0], vParamArr[1], vParamArr[2], vParamArr[3], vParamArr[4], vParamArr[5], vParamArr[6]);
	return SetVehicleParamsEx(vehicle, vParamArr[0], vParamArr[1], vParamArr[2], VEHICLE_PARAMS_OFF, vParamArr[4], vParamArr[5], vParamArr[6]);
}

stock IsSeatAvailable(vehicleid, seat)
{
	switch(GetVehicleModel(vehicleid)) {
		case 425, 430, 432, 441, 446, 448, 452, 453, 454, 464, 465, 472, 473, 476, 481, 484, 485, 486, 493, 501, 509, 510, 519, 520, 530, 531, 532, 539, 553, 564, 568, 571, 572, 574, 583, 592, 594, 595: return 0;
		default: if(IsVehicleOccupied(vehicleid, seat)) return 0;
	}
	return 1;
}

stock IsPlayerInInvalidNosVehicle(playerid)
{
	switch(GetVehicleModel(GetPlayerVehicleID(playerid))) {
		case 430, 446, 448, 449, 452, 453, 454, 461, 462, 463, 468, 472, 473, 481, 484, 493, 509, 510, 521, 522, 523, 537, 538, 569, 570, 581, 586, 590, 595: return 1;
	}
	return 0;
}

stock AddSpecialToken(playerid)
{

	new
		sz_FileStr[10 + MAX_PLAYER_NAME],
		sz_playerName[MAX_PLAYER_NAME],
		File: fPointer;

	GetPlayerName(playerid, sz_playerName, MAX_PLAYER_NAME);
	format(sz_FileStr, sizeof(sz_FileStr), "stokens/%s", sz_playerName);
	if(fexist(sz_FileStr)) {
		fPointer = fopen(sz_FileStr, io_read);
		fread(fPointer, sz_playerName), fclose(fPointer);

		new
			i_tokenVal = strval(sz_playerName);

		format(sz_playerName, sizeof(sz_playerName), "%i", i_tokenVal + 1);
		fPointer = fopen(sz_FileStr, io_write);
		if(fPointer)
		{
			fwrite(fPointer, sz_playerName);
			fclose(fPointer);
		}
	}
	else {
		fPointer = fopen(sz_FileStr, io_write);
	    if(fPointer)
		{
			fwrite(fPointer, "1");
			fclose(fPointer);
		}
	}
	return 1;
}

stock SeeSpecialTokens(playerid, hoursneeded)
{
	if(PlayerInfo[playerid][pAdmin] >= 2) return 0; // Admins cant win
	if(hoursneeded <= 0) return 1;

	new
		szName[MAX_PLAYER_NAME],
		szFileStr[10 + MAX_PLAYER_NAME];

	GetPlayerName(playerid, szName, MAX_PLAYER_NAME);
	format(szFileStr, sizeof(szFileStr), "stokens/%s", szName);
	if(fexist(szFileStr)) {

		new
			File: iFile = fopen(szFileStr, io_read);

		fread(iFile, szFileStr);
		fclose(iFile);
		if(strval(szFileStr) >= hoursneeded) return 1;
	}
	return 0;
}

stock ResetPlayerCash(playerid)
{
	PlayerInfo[playerid][pCash] = 0;
	ResetPlayerMoney(playerid);
	return 1;
}

stock SaveGates()
{
	for(new i = 0; i < MAX_GATES; i++)
	{
		SaveGate(i);
	}
	return 1;
}

stock SaveEventPoints() {

	new
		szFileStr[256],
		File: fHandle = fopen("eventpoints.cfg", io_write);

	if(fHandle)
	{
		for(new iIndex; iIndex < MAX_EVENTPOINTS; iIndex++) {
			format(szFileStr, sizeof(szFileStr), "%f|%f|%f|%d|%d|%s|%d\r\n",
				EventPoints[iIndex][epPosX],
				EventPoints[iIndex][epPosY],
				EventPoints[iIndex][epPosZ],
				EventPoints[iIndex][epVW],
				EventPoints[iIndex][epInt],
				EventPoints[iIndex][epPrize],
				EventPoints[iIndex][epFlagable]
			);
			fwrite(fHandle, szFileStr);
		}
		return fclose(fHandle);
	}
	return 0;
}
stock ShopTechBroadCast(color,string[])
{
	foreach(new i: Player)
	{
		if ((PlayerInfo[i][pShopTech] >= 1 || PlayerInfo[i][pAdmin] >= 1338) && PlayerInfo[i][pTogReports] == 0)
		{
			SendClientMessageEx(i, color, string);
		}
	}	
	return 1;
}

stock ABroadCast(hColor, szMessage[], iLevel, bool: bUndercover = false) {
	foreach(new i: Player)
	{
		if(PlayerInfo[i][pAdmin] >= iLevel && (bUndercover || !PlayerInfo[i][pTogReports])) {
			SendClientMessageEx(i, hColor, szMessage);
		}
	}	
	return 1;
}

stock CBroadCast(color,string[],level)
{
	foreach(new i: Player)
	{
		if (PlayerInfo[i][pHelper] >= level)
		{
			SendClientMessageEx(i, color, string);
			//printf("%s", string);
		}
	}	
	return 1;
}

stock OOCOff(color,string[])
{
	foreach(new i: Player)
	{
		if(!gOoc[i]) {
			SendClientMessageEx(i, color, string);
		}
	}	
}

stock OOCNews(color,string[])
{
	foreach(new i: Player)
	{
		if(!gNews[i]) {
			SendClientMessageEx(i, color, string);
		}
	}	
}

stock SendGroupMessage(iGroupType, color, string[], allegiance = 0)
{
	new iGroupID;
	foreach(new i: Player)
	{
		iGroupID = PlayerInfo[i][pMember];
		if( iGroupType == -1 || ((0 <= iGroupID < MAX_GROUPS) && arrGroupData[iGroupID][g_iGroupType] == iGroupType) )
		{
			if(allegiance == 0 || allegiance == arrGroupData[iGroupID][g_iAllegiance])
			{
				SendClientMessageEx(i, color, string);
			}
		}
	}	
}

stock SendDivisionMessage(member, division, color, string[])
{
	foreach(new i: Player)
	{
		if(PlayerInfo[i][pMember] == member && PlayerInfo[i][pDivision] == division) {
			SendClientMessageEx(i, color, string);
		}
	}	
}

stock SendJobMessage(job, color, string[])
{
	foreach(new i: Player)
	{
		if(((PlayerInfo[i][pJob] == job || PlayerInfo[i][pJob2] == job || PlayerInfo[i][pJob3] == job) && JobDuty[i] == 1) || ((PlayerInfo[i][pJob] == job || PlayerInfo[i][pJob2] == job || PlayerInfo[i][pJob3] == job) && (job == 7 && GetPVarInt(i, "MechanicDuty") == 1) || (job == 2 && GetPVarInt(i, "LawyerDuty") == 1))) {
			SendClientMessageEx(i, color, string);
		}	
	}
}

stock SendNewFamilyMessage(family, color, string[])
{
	foreach(new i: Player)
	{
		if(PlayerInfo[i][pFMember] == family) {
			if(!gFam[i]) {
				SendClientMessageEx(i, color, string);
			}
		}
		if(PlayerInfo[i][pAdmin] > 1 && GetPVarInt(i, "BigEarFamily") == family && GetPVarInt(i, "BigEar") == 5) {
			new szAntiprivacy[128];
			format(szAntiprivacy, sizeof(szAntiprivacy), "(BE) %s", string);
			SendClientMessageEx(i, color, szAntiprivacy);
		}
	}	
}

stock SendTaxiMessage(color, string[])
{
	foreach(new i: Player)
	{
		if(IsATaxiDriver(i) && PlayerInfo[i][pDuty] > 0) {
			SendClientMessageEx(i, color, string);
		}

		if(TransportDuty[i] > 0 && (PlayerInfo[i][pJob] == 17 || PlayerInfo[i][pJob2] == 17 || PlayerInfo[i][pJob3] == 17 || PlayerInfo[i][pTaxiLicense] == 1)) {
			if(!IsATaxiDriver(i)) {
				SendClientMessageEx(i, color, string);
			}
		}
	}	
}

stock RadioBroadCast(playerid, string[])
{
	new MiscString[128], Float: aaaPositions[3];
	foreach(new i: Player)
	{
		if(PlayerInfo[i][pRadioFreq] == PlayerInfo[playerid][pRadioFreq] && PlayerInfo[i][pRadio] >= 1 && gRadio{i} != 0)
		{
			GetPlayerPos(i, aaaPositions[0], aaaPositions[1], aaaPositions[2]);
			format(MiscString, sizeof(MiscString), "** Radio (%d khz) ** %s: %s", PlayerInfo[playerid][pRadioFreq], GetPlayerNameEx(playerid), string);
			SendClientMessageEx(i, PUBLICRADIO_COLOR, MiscString);
			format(MiscString, sizeof(MiscString), "(radio) %s", string);
			SetPlayerChatBubble(playerid,MiscString,COLOR_WHITE,15.0,5000);
		}
	}	
}

stock SendTeamBeepMessage(color, string[])
{
	foreach(new i: Player)
	{
		if(IsACop(i))
		{
			SendClientMessageEx(i, color, string);
			RingTone[i] = 20;
		}
	}	
}

stock PlayerPlayMusic(playerid)
{
	if(IsPlayerConnected(playerid)) {
		SetTimer("StopMusic", 5000, 0);
		PlayerPlaySound(playerid, 1068, 0.0, 0.0, 0.0);
	}
}

stock PlayerFixRadio(playerid)
{
	if(IsPlayerConnected(playerid)) {
		SetTimer("PlayerFixRadio2", 1000, 0);
		PlayerPlaySound(playerid, 1068, 0.0, 0.0, 0.0);
		Fixr[playerid] = 1;
	}
}

stock SavePlants()
{
	new i = 0;
	while(i < MAX_PLANTS)
	{
		SavePlant(i);
		i++;
	}
	if(i > 0) printf("[plant] %i plants saved", i);
	else printf("[plant] Error: No plants saved!");
	return 1;
}

stock number_format(number)
{
	new i, string[15];
	FIXES_valstr(string, number);
	if(strfind(string, "-") != -1) i = strlen(string) - 4;
	else i = strlen(string) - 3;
	while (i >= 1)
 	{
		if(strfind(string, "-") != -1) strins(string, ",", i + 1);
		else strins(string, ",", i);
		i -= 3;
	}
	return string;
}

stock abs(value)
{
    return ((value < 0 ) ? (-value) : (value));
}

stock GetWeaponParam(id, WeaponsEnum: param)
{
	for (new i; i < sizeof(Weapons); i++)
	{
		if (Weapons[i][WeaponId] == id)	return Weapons[i][param];
	}
	return 0;
}

stock legalRims(playerid, compenent, vehicleid)
{
	if(IsPlayerInRangeOfPoint(playerid, 20, 617.5360,-1.9900,1000.6592)) // Transfender
	{
		switch(compenent)
		{
		    case 1098, 1096, 1085, 1081, 1082, 1074, 1025, 1078, 1097, 1076:
		    {
		        switch(GetVehicleModel(vehicleid))
		        {
		            case  579, 400, 500, 418, 404, 489, 479, 442, 458, 602, 496, 401, 518, 527, 589, 419, 533, 526, 474, 545,
		            517, 410, 600, 436, 439, 549, 491, 555, 445, 507, 585, 604, 466, 492, 546, 551, 516, 467, 426, 405, 580, 409, 550,
		            540, 421, 529, 402, 542, 603, 475, 429, 541, 415, 480, 587, 411, 506, 451, 477, 422, 478, 438, 420, 547: return 1;
		            default: return 0;
		        }
			}
		}
	}
	if(IsPlayerInRangeOfPoint(playerid, 20,615.2861,-124.2390,997.6703)) //Wheel Arch
	{
	    switch(compenent)
		{
		    case 1085, 1077, 1079, 1083, 1081, 1082, 1074, 1075, 1073, 1080:
		    {
		        switch(GetVehicleModel(vehicleid))
		        {
		            case  562, 565, 559, 561, 560, 558: return 1;
		            default: return 0;
		        }
			}
		}
	}
	if(IsPlayerInRangeOfPoint(playerid, 20, 616.7914,-74.8150,997.8929)) // Loco
	{
	    switch(compenent)
		{
		    case 1098, 1077, 1079, 1083, 1075, 1084, 1078, 1097, 1076:
		    {
		        switch(GetVehicleModel(vehicleid))
		        {
		            case  536, 575, 534, 567, 535, 566, 576, 412: return 1;
		            default: return 0;
		        }
			}
		}
	}
	return 0;
}

stock DestroyPlayerVehicle(playerid, playervehicleid)
{
	if(PlayerVehicleInfo[playerid][playervehicleid][pvModelId])
	{
	    VehicleSpawned[playerid]--;
	    PlayerCars--;
		DestroyVehicle(PlayerVehicleInfo[playerid][playervehicleid][pvId]);
		PlayerVehicleInfo[playerid][playervehicleid][pvModelId] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvPosX] = 0.0;
		PlayerVehicleInfo[playerid][playervehicleid][pvPosY] = 0.0;
		PlayerVehicleInfo[playerid][playervehicleid][pvPosZ] = 0.0;
		PlayerVehicleInfo[playerid][playervehicleid][pvPosAngle] = 0.0;
		PlayerVehicleInfo[playerid][playervehicleid][pvPaintJob] = -1;
		PlayerVehicleInfo[playerid][playervehicleid][pvColor1] = 126;
		PlayerVehicleInfo[playerid][playervehicleid][pvColor2] = 126;
		PlayerVehicleInfo[playerid][playervehicleid][pvPrice] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvFuel] = 0.0;
		PlayerVehicleInfo[playerid][playervehicleid][pvImpounded] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvSpawned] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvVW] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvInt] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvTicket] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvWeapons][0] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvWeapons][1] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvWeapons][2] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvPlate] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvLock] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvLocksLeft] = 0;
        PlayerVehicleInfo[playerid][playervehicleid][pvLocked] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvAlarm] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvAlarmTriggered] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvBeingPickLocked] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvBeingPickLockedBy] = INVALID_PLAYER_ID;
		PlayerVehicleInfo[playerid][playervehicleid][pvLastLockPickedBy] = 0;
		VehicleFuel[PlayerVehicleInfo[playerid][playervehicleid][pvId]] = 0.0;
	    PlayerVehicleInfo[playerid][playervehicleid][pvId] = INVALID_PLAYER_VEHICLE_ID;
	    if(PlayerVehicleInfo[playerid][playervehicleid][pvAllowedPlayerId] != INVALID_PLAYER_ID)
	    {
	        PlayerInfo[PlayerVehicleInfo[playerid][playervehicleid][pvAllowedPlayerId]][pVehicleKeys] = INVALID_PLAYER_VEHICLE_ID;
	        PlayerInfo[PlayerVehicleInfo[playerid][playervehicleid][pvAllowedPlayerId]][pVehicleKeysFrom] = INVALID_PLAYER_ID;
	    	PlayerVehicleInfo[playerid][playervehicleid][pvAllowedPlayerId] = INVALID_PLAYER_ID;
		}

		new query[60];
		format(query, sizeof(query), "DELETE FROM `vehicles` WHERE `id` = '%d'", PlayerVehicleInfo[playerid][playervehicleid][pvSlotId]);
		mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
		PlayerVehicleInfo[playerid][playervehicleid][pvSlotId] = 0;

		//g_mysql_SaveVehicle(playerid, playervehicleid);
	}
}

stock LoadPlayerVehicles(playerid, logoff = 0) {
	for(new v = 0; v < MAX_PLAYERVEHICLES; v++) {
		if(PlayerVehicleInfo[playerid][v][pvBeingPickLocked] > 0 && logoff == 0) continue;
		if(vehicleSpawnCountCheck(playerid)) {
			if(PlayerVehicleInfo[playerid][v][pvModelId] >= 400) {
				if(PlayerVehicleInfo[playerid][v][pvSpawned] && !PlayerVehicleInfo[playerid][v][pvDisabled] && !PlayerVehicleInfo[playerid][v][pvImpounded]) {

					PlayerCars++;
					VehicleSpawned[playerid]++;
					new carcreated = CreateVehicle(PlayerVehicleInfo[playerid][v][pvModelId], PlayerVehicleInfo[playerid][v][pvPosX], PlayerVehicleInfo[playerid][v][pvPosY], PlayerVehicleInfo[playerid][v][pvPosZ], PlayerVehicleInfo[playerid][v][pvPosAngle],PlayerVehicleInfo[playerid][v][pvColor1], PlayerVehicleInfo[playerid][v][pvColor2], -1);

					SetVehicleVirtualWorld(carcreated, PlayerVehicleInfo[playerid][v][pvVW]);
  					LinkVehicleToInterior(carcreated, PlayerVehicleInfo[playerid][v][pvInt]);

					Vehicle_ResetData(carcreated);
					PlayerVehicleInfo[playerid][v][pvId] = carcreated;
					VehicleFuel[carcreated] = PlayerVehicleInfo[playerid][v][pvFuel];

					if(PlayerVehicleInfo[playerid][v][pvLocked]) {
						if(PlayerVehicleInfo[playerid][v][pvLocksLeft]) LockPlayerVehicle(playerid, carcreated, PlayerVehicleInfo[playerid][v][pvLock]);
						else PlayerVehicleInfo[playerid][v][pvLocked] = 0;
					}
					LoadPlayerVehicleMods(playerid, v);

					if(PlayerVehicleInfo[playerid][v][pvCrashFlag] == 1 && PlayerVehicleInfo[playerid][v][pvCrashX] != 0.0)
					{
						SetVehiclePos(carcreated, PlayerVehicleInfo[playerid][v][pvCrashX], PlayerVehicleInfo[playerid][v][pvCrashY], PlayerVehicleInfo[playerid][v][pvCrashZ]);
						SetVehicleZAngle(carcreated, PlayerVehicleInfo[playerid][v][pvCrashAngle]);
						SetVehicleVirtualWorld(carcreated, PlayerVehicleInfo[playerid][v][pvCrashVW]);
						PlayerVehicleInfo[playerid][v][pvCrashFlag] = 0;
						PlayerVehicleInfo[playerid][v][pvCrashVW] = 0;
						PlayerVehicleInfo[playerid][v][pvCrashX] = 0.0;
						PlayerVehicleInfo[playerid][v][pvCrashY] = 0.0;
						PlayerVehicleInfo[playerid][v][pvCrashZ] = 0.0;
						PlayerVehicleInfo[playerid][v][pvCrashAngle] = 0.0;
						SendClientMessageEx(playerid, COLOR_WHITE, "Your vehicles have been restored to their last known location from your previous timeout.");
					}
				}
				else if(PlayerVehicleInfo[playerid][v][pvSpawned] != 0) {
					PlayerVehicleInfo[playerid][v][pvSpawned] = 0;
				}
			}
			else if(PlayerVehicleInfo[playerid][v][pvImpounded] != 0) {
				PlayerVehicleInfo[playerid][v][pvImpounded] = 0;
			}
			else if(PlayerVehicleInfo[playerid][v][pvSpawned] != 0) {
				PlayerVehicleInfo[playerid][v][pvSpawned] = 0;
			}
		}
		else PlayerVehicleInfo[playerid][v][pvSpawned] = 0;
	}
	return 1;
}

stock UnloadPlayerVehicles(playerid, logoff = 0, reason = 0) {
	for(new v = 0; v < MAX_PLAYERVEHICLES; v++) if(PlayerVehicleInfo[playerid][v][pvId] != INVALID_PLAYER_VEHICLE_ID && !PlayerVehicleInfo[playerid][v][pvImpounded] && PlayerVehicleInfo[playerid][v][pvSpawned]) {
		if(PlayerVehicleInfo[playerid][v][pvBeingPickLocked] > 0 && logoff == 0) continue;
		if(WheelClamp{PlayerVehicleInfo[playerid][v][pvId]} && logoff == 1) {
			PlayerVehicleInfo[playerid][v][pvImpounded] = 1;
		}
		if(IsVehicleInTow(PlayerVehicleInfo[playerid][v][pvId]) && logoff == 1)
		{
			DetachTrailerFromVehicle(GetPlayerVehicleID(playerid));
			PlayerVehicleInfo[playerid][v][pvImpounded] = 1;
			SetVehiclePos(PlayerVehicleInfo[playerid][v][pvId], 0, 0, 0); // Attempted desync fix
		}
		GetVehicleHealth(PlayerVehicleInfo[playerid][v][pvId], PlayerVehicleInfo[playerid][v][pvHealth]);
		if(PlayerVehicleInfo[playerid][v][pvBeingPickLocked] > 0) {
			new extraid = PlayerVehicleInfo[playerid][v][pvBeingPickLockedBy];
			SetPVarInt(extraid, "LockPickVehicleSQLId", PlayerVehicleInfo[playerid][v][pvSlotId]);
			SetPVarInt(extraid, "LockPickPlayerSQLId", GetPlayerSQLId(playerid));
			SetPVarInt(extraid, "VLPLocksLeft", PlayerVehicleInfo[playerid][v][pvLocksLeft]);
			SetPVarInt(extraid, "VLPTickets", PlayerVehicleInfo[playerid][v][pvTicket]);
			SetPVarString(extraid, "LockPickPlayerName", GetPlayerNameEx(playerid));
			new szMessage[150], rsMessage[20];
			switch(reason){
				case 0: rsMessage = "timed out";
				case 1:	rsMessage = "logged off";
				case 2: rsMessage = "been kicked/banned";
			}
			format(szMessage, sizeof(szMessage), "The player (%s) that owns this vehicle (%s) has %s.", GetPlayerNameEx(playerid), GetVehicleName(PlayerVehicleInfo[playerid][v][pvId]), rsMessage);
			SendClientMessageEx(extraid, COLOR_YELLOW, szMessage);
			new ip2[MAX_PLAYER_NAME];
			GetPlayerIp(extraid, ip2, sizeof(ip2));
			SendClientMessageEx(extraid, COLOR_YELLOW, "(( The vehicle will de-spawn once you complete or fail the deliver. ))");
			format(szMessage, sizeof(szMessage), "[LOCK PICK] %s(%d) (IP:%s) has %s while his %s(VID:%d Slot %d) was lock picked by %s(IP:%s SQLId: %d)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), PlayerInfo[playerid][pIP], rsMessage, GetVehicleName(PlayerVehicleInfo[playerid][v][pvId]), PlayerVehicleInfo[playerid][v][pvId], v, GetPlayerNameEx(extraid), ip2, GetPlayerSQLId(extraid));
			Log("logs/playervehicle.log", szMessage);
			DeletePVar(extraid, "LockPickPlayer");
			PlayerVehicleInfo[playerid][v][pvBeingPickLocked] = 0;
			PlayerVehicleInfo[playerid][v][pvBeingPickLockedBy] = INVALID_PLAYER_ID;
		}
		else {
			if(LockStatus{PlayerVehicleInfo[playerid][v][pvId]} != 0) LockStatus{PlayerVehicleInfo[playerid][v][pvId]} = 0;
			DestroyVehicle(PlayerVehicleInfo[playerid][v][pvId]);
		}
		PlayerCars--;
		PlayerVehicleInfo[playerid][v][pvId] = INVALID_PLAYER_VEHICLE_ID;
		PlayerVehicleInfo[playerid][v][pvSpawned] = 0;
		if(PlayerVehicleInfo[playerid][v][pvAllowedPlayerId] != INVALID_PLAYER_ID)
		{
			PlayerInfo[PlayerVehicleInfo[playerid][v][pvAllowedPlayerId]][pVehicleKeys] = INVALID_PLAYER_VEHICLE_ID;
			PlayerInfo[PlayerVehicleInfo[playerid][v][pvAllowedPlayerId]][pVehicleKeysFrom] = INVALID_PLAYER_ID;
			PlayerVehicleInfo[playerid][v][pvAllowedPlayerId] = INVALID_PLAYER_ID;
		}
		g_mysql_SaveVehicle(playerid, v);
    }
	VehicleSpawned[playerid] = 0;
}

stock UpdatePlayerVehicleParkPosition(playerid, playervehicleid, Float:newx, Float:newy, Float:newz, Float:newangle, Float:health, VW, Int)
{
	if(PlayerVehicleInfo[playerid][playervehicleid][pvId] != INVALID_PLAYER_VEHICLE_ID && GetVehicleModel(PlayerVehicleInfo[playerid][playervehicleid][pvId]))
	{
		new Float:oldx, Float:oldy, Float:oldz, Float: oldfuel, arrDamage[4];
		oldx = PlayerVehicleInfo[playerid][playervehicleid][pvPosX];
		oldy = PlayerVehicleInfo[playerid][playervehicleid][pvPosY];
		oldz = PlayerVehicleInfo[playerid][playervehicleid][pvPosZ];

		if(oldx == newx && oldy == newy && oldz == newz) return 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvPosX] = newx;
		PlayerVehicleInfo[playerid][playervehicleid][pvPosY] = newy;
		PlayerVehicleInfo[playerid][playervehicleid][pvPosZ] = newz;
		PlayerVehicleInfo[playerid][playervehicleid][pvPosAngle] = newangle;
		PlayerVehicleInfo[playerid][playervehicleid][pvVW] = VW;
		PlayerVehicleInfo[playerid][playervehicleid][pvInt] = Int;
		oldfuel = VehicleFuel[PlayerVehicleInfo[playerid][playervehicleid][pvId]];
		UpdatePlayerVehicleMods(playerid, playervehicleid);
		GetVehicleDamageStatus(PlayerVehicleInfo[playerid][playervehicleid][pvId], arrDamage[0], arrDamage[1], arrDamage[2], arrDamage[3]);
		DestroyVehicle(PlayerVehicleInfo[playerid][playervehicleid][pvId]);
		new carcreated = CreateVehicle(PlayerVehicleInfo[playerid][playervehicleid][pvModelId], PlayerVehicleInfo[playerid][playervehicleid][pvPosX], PlayerVehicleInfo[playerid][playervehicleid][pvPosY], PlayerVehicleInfo[playerid][playervehicleid][pvPosZ],
		PlayerVehicleInfo[playerid][playervehicleid][pvPosAngle],PlayerVehicleInfo[playerid][playervehicleid][pvColor1], PlayerVehicleInfo[playerid][playervehicleid][pvColor2], -1);
		SetVehicleVirtualWorld(carcreated, PlayerVehicleInfo[playerid][playervehicleid][pvVW]);
  		LinkVehicleToInterior(carcreated, PlayerVehicleInfo[playerid][playervehicleid][pvInt]);
		PlayerVehicleInfo[playerid][playervehicleid][pvId] = carcreated;
		Vehicle_ResetData(carcreated);
		VehicleFuel[carcreated] = oldfuel;
		// SetVehicleNumberPlate(carcreated, PlayerVehicleInfo[playerid][playervehicleid][pvNumberPlate]);
		SetVehicleHealth(carcreated, health);
		if(PlayerVehicleInfo[playerid][playervehicleid][pvLocked] == 1) LockPlayerVehicle(playerid, PlayerVehicleInfo[playerid][playervehicleid][pvId], PlayerVehicleInfo[playerid][playervehicleid][pvLock]);
		LoadPlayerVehicleMods(playerid, playervehicleid);
		UpdateVehicleDamageStatus(PlayerVehicleInfo[playerid][playervehicleid][pvId], arrDamage[0], arrDamage[1], arrDamage[2], arrDamage[3]);

		g_mysql_SaveVehicle(playerid, playervehicleid);
		return 1;
	}
	return 0;
}

stock UpdatePlayerVehicleMods(playerid, playervehicleid)
{
	if(GetVehicleModel(PlayerVehicleInfo[playerid][playervehicleid][pvId]) && PlayerVehicleInfo[playerid][playervehicleid][pvImpounded] == 0 && PlayerVehicleInfo[playerid][playervehicleid][pvSpawned] == 1 && !PlayerVehicleInfo[playerid][playervehicleid][pvDisabled]) {
		new carid = PlayerVehicleInfo[playerid][playervehicleid][pvId];
		new exhaust, frontbumper, rearbumper, roof, spoilers, sideskirt1,
			sideskirt2, wheels, hydraulics, nitro, hood, lamps, stereo, ventright, ventleft;
		exhaust = GetVehicleComponentInSlot(carid, CARMODTYPE_EXHAUST);
		frontbumper = GetVehicleComponentInSlot(carid, CARMODTYPE_FRONT_BUMPER);
		rearbumper = GetVehicleComponentInSlot(carid, CARMODTYPE_REAR_BUMPER);
		roof = GetVehicleComponentInSlot(carid, CARMODTYPE_ROOF);
		spoilers = GetVehicleComponentInSlot(carid, CARMODTYPE_SPOILER);
		sideskirt1 = GetVehicleComponentInSlot(carid, CARMODTYPE_SIDESKIRT);
		sideskirt2 = GetVehicleComponentInSlot(carid, CARMODTYPE_SIDESKIRT);
		wheels = GetVehicleComponentInSlot(carid, CARMODTYPE_WHEELS);
		hydraulics = GetVehicleComponentInSlot(carid, CARMODTYPE_HYDRAULICS);
		nitro = GetVehicleComponentInSlot(carid, CARMODTYPE_NITRO);
		hood = GetVehicleComponentInSlot(carid, CARMODTYPE_HOOD);
		lamps = GetVehicleComponentInSlot(carid, CARMODTYPE_LAMPS);
		stereo = GetVehicleComponentInSlot(carid, CARMODTYPE_STEREO);
		ventright = GetVehicleComponentInSlot(carid, CARMODTYPE_VENT_RIGHT);
		ventleft = GetVehicleComponentInSlot(carid, CARMODTYPE_VENT_LEFT);
		if(spoilers >= 1000)    PlayerVehicleInfo[playerid][playervehicleid][pvMods][0] = spoilers;
		if(hood >= 1000)        PlayerVehicleInfo[playerid][playervehicleid][pvMods][1] = hood;
		if(roof >= 1000)        PlayerVehicleInfo[playerid][playervehicleid][pvMods][2] = roof;
		if(sideskirt1 >= 1000)  PlayerVehicleInfo[playerid][playervehicleid][pvMods][3] = sideskirt1;
		if(lamps >= 1000)       PlayerVehicleInfo[playerid][playervehicleid][pvMods][4] = lamps;
		if(nitro >= 1000)       PlayerVehicleInfo[playerid][playervehicleid][pvMods][5] = nitro;
		if(exhaust >= 1000)     PlayerVehicleInfo[playerid][playervehicleid][pvMods][6] = exhaust;
		if(wheels >= 1000)      PlayerVehicleInfo[playerid][playervehicleid][pvMods][7] = wheels;
		if(stereo >= 1000)      PlayerVehicleInfo[playerid][playervehicleid][pvMods][8] = stereo;
		if(hydraulics >= 1000)  PlayerVehicleInfo[playerid][playervehicleid][pvMods][9] = hydraulics;
		if(frontbumper >= 1000) PlayerVehicleInfo[playerid][playervehicleid][pvMods][10] = frontbumper;
		if(rearbumper >= 1000)  PlayerVehicleInfo[playerid][playervehicleid][pvMods][11] = rearbumper;
		if(ventright >= 1000)   PlayerVehicleInfo[playerid][playervehicleid][pvMods][12] = ventright;
		if(ventleft >= 1000)    PlayerVehicleInfo[playerid][playervehicleid][pvMods][13] = ventleft;
		if(sideskirt2 >= 1000)  PlayerVehicleInfo[playerid][playervehicleid][pvMods][14] = sideskirt2;

		g_mysql_SaveVehicle(playerid, playervehicleid);
	}
}

stock UpdateGroupVehicleMods(groupvehicleid)
{
	if(GetVehicleModel(DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][gv_iSpawnedID])) {
		new carid = DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][gv_iSpawnedID];
		new exhaust, frontbumper, rearbumper, roof, spoilers, sideskirt1,
			sideskirt2, wheels, hydraulics, nitro, hood, lamps, stereo, ventright, ventleft;
		exhaust = GetVehicleComponentInSlot(carid, CARMODTYPE_EXHAUST);
		frontbumper = GetVehicleComponentInSlot(carid, CARMODTYPE_FRONT_BUMPER);
		rearbumper = GetVehicleComponentInSlot(carid, CARMODTYPE_REAR_BUMPER);
		roof = GetVehicleComponentInSlot(carid, CARMODTYPE_ROOF);
		spoilers = GetVehicleComponentInSlot(carid, CARMODTYPE_SPOILER);
		sideskirt1 = GetVehicleComponentInSlot(carid, CARMODTYPE_SIDESKIRT);
		sideskirt2 = GetVehicleComponentInSlot(carid, CARMODTYPE_SIDESKIRT);
		wheels = GetVehicleComponentInSlot(carid, CARMODTYPE_WHEELS);
		hydraulics = GetVehicleComponentInSlot(carid, CARMODTYPE_HYDRAULICS);
		nitro = GetVehicleComponentInSlot(carid, CARMODTYPE_NITRO);
		hood = GetVehicleComponentInSlot(carid, CARMODTYPE_HOOD);
		lamps = GetVehicleComponentInSlot(carid, CARMODTYPE_LAMPS);
		stereo = GetVehicleComponentInSlot(carid, CARMODTYPE_STEREO);
		ventright = GetVehicleComponentInSlot(carid, CARMODTYPE_VENT_RIGHT);
		ventleft = GetVehicleComponentInSlot(carid, CARMODTYPE_VENT_LEFT);
		if(spoilers >= 1000)    DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][0] = spoilers;
		if(hood >= 1000)        DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][1] = hood;
		if(roof >= 1000)        DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][2] = roof;
		if(sideskirt1 >= 1000)  DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][3] = sideskirt1;
		if(lamps >= 1000)       DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][4] = lamps;
		if(nitro >= 1000)       DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][5] = nitro;
		if(exhaust >= 1000)     DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][6] = exhaust;
		if(wheels >= 1000)      DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][7] = wheels;
		if(stereo >= 1000)      DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][8] = stereo;
		if(hydraulics >= 1000)  DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][9] = hydraulics;
		if(frontbumper >= 1000) DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][10] = frontbumper;
		if(rearbumper >= 1000)  DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][11] = rearbumper;
		if(ventright >= 1000)   DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][12] = ventright;
		if(ventleft >= 1000)    DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][13] = ventleft;
		if(sideskirt2 >= 1000)  DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][14] = sideskirt2;

		DynVeh_Save(DynVeh[groupvehicleid]);
	}
}

stock LoadGroupVehicleMods(groupvehicleid)
{
	if(GetVehicleModel(DynVehicleInfo[DynVeh[groupvehicleid]][gv_iSpawnedID])) {

        /*if(strlen(PlayerVehicleInfo[playerid][groupvehicleid][pvPlate]) > 0)
		{
		    SetVehicleNumberPlate(PlayerVehicleInfo[playerid][groupvehicleid][pvId], PlayerVehicleInfo[playerid][groupvehicleid][pvPlate]);
		    SetVehiclePos(PlayerVehicleInfo[playerid][groupvehicleid][pvId], 9999.9, 9999.9, 9999.9);
		    SetVehiclePos(PlayerVehicleInfo[playerid][groupvehicleid][pvId], PlayerVehicleInfo[playerid][groupvehicleid][pvPosX], PlayerVehicleInfo[playerid][groupvehicleid][pvPosY], PlayerVehicleInfo[playerid][groupvehicleid][pvPosZ]);
		}*/

		/*if(PlayerVehicleInfo[playerid][groupvehicleid][pvPaintJob] != -1)
		{
			 ChangeVehiclePaintjob(PlayerVehicleInfo[playerid][groupvehicleid][pvId], PlayerVehicleInfo[playerid][groupvehicleid][pvPaintJob]);
			 ChangeVehicleColor(PlayerVehicleInfo[playerid][groupvehicleid][pvId], PlayerVehicleInfo[playerid][groupvehicleid][pvColor1], PlayerVehicleInfo[playerid][groupvehicleid][pvColor2]);
		}*/
		for(new m = 0; m < MAX_MODS; m++)
		{
		    if (DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][m] >= 1000  && DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][m] <= 1193)
		    {
				if (InvalidModCheck(GetVehicleModel(DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][gv_iSpawnedID]),DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][m]))
				{
					AddVehicleComponent(DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][gv_iSpawnedID], DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][m]);
				}
				else
				{
				    DynVehicleInfo[DynVeh[groupvehicleid]][gv_iMod][m] = 0;
				}
			}
		}
	}
}

stock LoadPlayerVehicleMods(playerid, playervehicleid)
{
	if(GetVehicleModel(PlayerVehicleInfo[playerid][playervehicleid][pvId]) && PlayerVehicleInfo[playerid][playervehicleid][pvImpounded] == 0 && PlayerVehicleInfo[playerid][playervehicleid][pvSpawned] == 1) {

        if(strlen(PlayerVehicleInfo[playerid][playervehicleid][pvPlate]) > 0)
		{
		    SetVehicleNumberPlate(PlayerVehicleInfo[playerid][playervehicleid][pvId], PlayerVehicleInfo[playerid][playervehicleid][pvPlate]);
		    SetVehiclePos(PlayerVehicleInfo[playerid][playervehicleid][pvId], 9999.9, 9999.9, 9999.9);
		    SetVehiclePos(PlayerVehicleInfo[playerid][playervehicleid][pvId], PlayerVehicleInfo[playerid][playervehicleid][pvPosX], PlayerVehicleInfo[playerid][playervehicleid][pvPosY], PlayerVehicleInfo[playerid][playervehicleid][pvPosZ]);
		}

		if(PlayerVehicleInfo[playerid][playervehicleid][pvPaintJob] != -1)
		{
			 ChangeVehiclePaintjob(PlayerVehicleInfo[playerid][playervehicleid][pvId], PlayerVehicleInfo[playerid][playervehicleid][pvPaintJob]);
			 ChangeVehicleColor(PlayerVehicleInfo[playerid][playervehicleid][pvId], PlayerVehicleInfo[playerid][playervehicleid][pvColor1], PlayerVehicleInfo[playerid][playervehicleid][pvColor2]);
		}
		for(new m = 0; m < MAX_MODS; m++)
		{
		    if (PlayerVehicleInfo[playerid][playervehicleid][pvMods][m] >= 1000  && PlayerVehicleInfo[playerid][playervehicleid][pvMods][m] <= 1193)
		    {
				if (InvalidModCheck(GetVehicleModel(PlayerVehicleInfo[playerid][playervehicleid][pvId]),PlayerVehicleInfo[playerid][playervehicleid][pvMods][m]))
				{
					AddVehicleComponent(PlayerVehicleInfo[playerid][playervehicleid][pvId], PlayerVehicleInfo[playerid][playervehicleid][pvMods][m]);
				}
				else
				{
				    PlayerVehicleInfo[playerid][playervehicleid][pvMods][m] = 0;
				}
			}
		}
	}
}

stock GetPlayerFreeVehicleId(playerid) {
	for(new i; i < MAX_PLAYERVEHICLES; ++i) {
		if(PlayerVehicleInfo[playerid][i][pvModelId] == 0) return i;
	}
	return -1;
}

/*
stock LoadNGVehicles()
{
    new Float:X, Float:Y, Float:Z;
    for(new x;x<sizeof(NGVehicles);x++)
	{
	    GetVehiclePos(NGVehicles[x], X, Y, Z);
	    if(GetPointDistanceToPointEx(X, Y, 20000, 20000) < 1000) SetVehicleToRespawn(NGVehicles[x]);
	}
}

stock UnloadNGVehicles()
{
    new Float:X, Float:Y, Float:Z;
    new Float:XB, Float:YB, Float:ZB;
    GetObjectPos(Carrier[0], XB, YB, ZB);
    for(new x;x<sizeof(NGVehicles);x++)
	{
	    GetVehiclePos(NGVehicles[x], X, Y, Z);
	    if(GetPointDistanceToPoint(X, Y, Z, XB, YB, ZB) < 300) SetVehiclePos(NGVehicles[x], 20000, 20000, 20000);
	}
}*/

stock GetPlayerVehicle(playerid, vehicleid)
{
    for(new v = 0; v < MAX_PLAYERVEHICLES; v++)
    {
        if(PlayerVehicleInfo[playerid][v][pvId] == vehicleid)
        {
            return v;
        }
    }
    return -1;
}

stock str_replace(sSearch[], sReplace[], const sSubject[], &iCount = 0)
{
	new
		iLengthTarget = strlen(sSearch),
		iLengthReplace = strlen(sReplace),
		iLengthSource = strlen(sSubject),
		iItterations = (iLengthSource - iLengthTarget) + 1;

	new
		sTemp[128],
		sReturn[128];

	strcat(sReturn, sSubject, 256);
	iCount = 0;

	for(new iIndex; iIndex < iItterations; ++iIndex)
	{
		strmid(sTemp, sReturn, iIndex, (iIndex + iLengthTarget), (iLengthTarget + 1));

		if(!strcmp(sTemp, sSearch, false))
		{
			strdel(sReturn, iIndex, (iIndex + iLengthTarget));
			strins(sReturn, sReplace, iIndex, iLengthReplace);

			iIndex += iLengthTarget;
			iCount++;
		}
	}
	return sReturn;
}

stock SaveAllAccountsUpdate()
{
	foreach(new i: Player)
	{
		if(gPlayerLogged{i}) {
			GetPlayerIp(i, PlayerInfo[i][pIP], 16);
			SetPVarInt(i, "AccountSaving", 1);
			OnPlayerStatsUpdate(i);
			break; // We only need to save one person at a time.
		}
	}	
}

stock Misc_Save() {

	new
		szFileStr[50],
		File: iFileHandle = fopen("serverConfig.ini", io_write);

	ini_SetInteger(iFileHandle, szFileStr, "RaceLaps", RaceTotalLaps);
	ini_SetInteger(iFileHandle, szFileStr, "RaceJoins", TotalJoinsRace);
	ini_SetInteger(iFileHandle, szFileStr, "Jackpot", Jackpot);
	ini_SetInteger(iFileHandle, szFileStr, "Tax", Tax);
	ini_SetInteger(iFileHandle, szFileStr, "TaxVal", TaxValue);
	ini_SetInteger(iFileHandle, szFileStr, "VIPM", VIPM);
	ini_SetInteger(iFileHandle, szFileStr, "LoginCount", TotalLogin);
	ini_SetInteger(iFileHandle, szFileStr, "ConnCount", TotalConnect);
	ini_SetInteger(iFileHandle, szFileStr, "ABanCount", TotalAutoBan);
	ini_SetInteger(iFileHandle, szFileStr, "RegCount", TotalRegister);
	ini_SetInteger(iFileHandle, szFileStr, "MaxPCount", MaxPlayersConnected);
	ini_SetInteger(iFileHandle, szFileStr, "MaxPDay", MPDay);
	ini_SetInteger(iFileHandle, szFileStr, "MaxPMonth", MPMonth);
	ini_SetInteger(iFileHandle, szFileStr, "MaxPYear", MPYear);
	ini_SetInteger(iFileHandle, szFileStr, "Uptime", TotalUptime);
	ini_SetInteger(iFileHandle, szFileStr, "BoxWins", Titel[TitelWins]);
	ini_SetInteger(iFileHandle, szFileStr, "BoxLosses", Titel[TitelLoses]);
	ini_SetInteger(iFileHandle, szFileStr, "SpecTimer", SpecTimer);
	ini_SetInteger(iFileHandle, szFileStr, "TRTax", TRTax);
	ini_SetInteger(iFileHandle, szFileStr, "TRTaxVal", TRTaxValue);
	ini_SetInteger(iFileHandle, szFileStr, "SpeedingTickets", SpeedingTickets);
	ini_SetInteger(iFileHandle, szFileStr, "FIFType", FIFType);
	ini_SetInteger(iFileHandle, szFileStr, "FIFEnabled", FIFEnabled);
	ini_SetInteger(iFileHandle, szFileStr, "FIFGP3", FIFGP3);
	ini_SetInteger(iFileHandle, szFileStr, "FIFTimeWarrior", FIFTimeWarrior);
	ini_SetFloat(iFileHandle, szFileStr, "FIFGambleX", FIFGamble[0]);
	ini_SetFloat(iFileHandle, szFileStr, "FIFGambleY", FIFGamble[1]);
	ini_SetFloat(iFileHandle, szFileStr, "FIFGambleZ", FIFGamble[2]);
	ini_SetInteger(iFileHandle, szFileStr, "FIFGThurs", FIFGThurs);
	if(iRewardPlay) {
		ini_SetInteger(iFileHandle, szFileStr, "RewardPlay", true);
	}
	if(iRewardBox) {

	    new
			Float: fObjectPos[3];

		GetDynamicObjectPos(iRewardObj, fObjectPos[0], fObjectPos[1], fObjectPos[2]);
	    ini_SetFloat(iFileHandle, szFileStr, "RewardPosX", fObjectPos[0]);
		ini_SetFloat(iFileHandle, szFileStr, "RewardPosY", fObjectPos[1]);
		ini_SetFloat(iFileHandle, szFileStr, "RewardPosZ", fObjectPos[2]);
	}
	ini_SetInteger(iFileHandle, szFileStr, "TicketsSold", TicketsSold);
	fclose(iFileHandle);
}

stock Misc_Load() {

	new
		szResult[32],
		szFileStr[160],
		Float: fObjectPos[3],
		File: iFileHandle = fopen("serverConfig.ini", io_read);

	while(fread(iFileHandle, szFileStr, sizeof(szFileStr))) {

		if(ini_GetValue(szFileStr, "RaceLaps", szResult, sizeof(szResult)))													RaceTotalLaps = strval(szResult);
		else if(ini_GetValue(szFileStr, "RaceJoins", szResult, sizeof(szResult)))											TotalJoinsRace = strval(szResult);
		else if(ini_GetValue(szFileStr, "Jackpot", szResult, sizeof(szResult)))												Jackpot = strval(szResult);
		else if(ini_GetValue(szFileStr, "Tax", szResult, sizeof(szResult)))													Tax = strval(szResult);
		else if(ini_GetValue(szFileStr, "TaxVal", szResult, sizeof(szResult)))												TaxValue = strval(szResult);
		else if(ini_GetValue(szFileStr, "VIPM", szResult, sizeof(szResult)))												VIPM = strval(szResult);
		else if(ini_GetValue(szFileStr, "LoginCount", szResult, sizeof(szResult)))											TotalLogin = strval(szResult);
		else if(ini_GetValue(szFileStr, "ConnCount", szResult, sizeof(szResult)))											TotalConnect = strval(szResult);
		else if(ini_GetValue(szFileStr, "ABanCount", szResult, sizeof(szResult)))											TotalAutoBan = strval(szResult);
		else if(ini_GetValue(szFileStr, "RegCount", szResult, sizeof(szResult)))											TotalRegister = strval(szResult);
		else if(ini_GetValue(szFileStr, "MaxPCount", szResult, sizeof(szResult)))											MaxPlayersConnected	= strval(szResult);
		else if(ini_GetValue(szFileStr, "MaxPDay", szResult, sizeof(szResult)))												MPDay = strval(szResult);
		else if(ini_GetValue(szFileStr, "MaxPMonth", szResult, sizeof(szResult)))											MPMonth = strval(szResult);
		else if(ini_GetValue(szFileStr, "MaxPYear", szResult, sizeof(szResult)))											MPYear = strval(szResult);
		else if(ini_GetValue(szFileStr, "Uptime", szResult, sizeof(szResult)))												TotalUptime = strval(szResult);
		else if(ini_GetValue(szFileStr, "BoxWins", szResult, sizeof(szResult)))												Titel[TitelWins] = strval(szResult);
		else if(ini_GetValue(szFileStr, "BoxLosses", szResult, sizeof(szResult)))											Titel[TitelLoses] = strval(szResult);
		else if(ini_GetValue(szFileStr, "SpecTimer", szResult, sizeof(szResult)))											SpecTimer = strval(szResult);
		else if(ini_GetValue(szFileStr, "RewardPlay", szResult, sizeof(szResult)))											iRewardPlay = strval(szResult);
		else if(ini_GetValue(szFileStr, "RewardPosX", szResult, sizeof(szResult)))											fObjectPos[0] = floatstr(szResult);
		else if(ini_GetValue(szFileStr, "RewardPosY", szResult, sizeof(szResult)))											fObjectPos[1] = floatstr(szResult);
		else if(ini_GetValue(szFileStr, "RewardPosZ", szResult, sizeof(szResult)))											fObjectPos[2] = floatstr(szResult);
		else if(ini_GetValue(szFileStr, "TicketsSold", szResult, sizeof(szResult)))                                         TicketsSold = strval(szResult);
		else if(ini_GetValue(szFileStr, "TRTax", szResult, sizeof(szResult)))												TRTax = strval(szResult);
		else if(ini_GetValue(szFileStr, "TRTaxVal", szResult, sizeof(szResult)))											TRTaxValue = strval(szResult);
		else if(ini_GetValue(szFileStr, "SpeedingTickets", szResult, sizeof(szResult)))										SpeedingTickets = strval(szResult);
		else if(ini_GetValue(szFileStr, "FIFType", szResult, sizeof(szResult)))												FIFType = strval(szResult);
		else if(ini_GetValue(szFileStr, "FIFEnabled", szResult, sizeof(szResult)))											FIFEnabled = strval(szResult);
		else if(ini_GetValue(szFileStr, "FIFGP3", szResult, sizeof(szResult)))												FIFGP3 = strval(szResult);
		else if(ini_GetValue(szFileStr, "FIFTimeWarrior", szResult, sizeof(szResult)))										FIFTimeWarrior = strval(szResult);
		else if(ini_GetValue(szFileStr, "FIFGambleX", szResult, sizeof(szResult)))											FIFGamble[0] = floatstr(szResult);
		else if(ini_GetValue(szFileStr, "FIFGambleY", szResult, sizeof(szResult)))											FIFGamble[1] = floatstr(szResult);
		else if(ini_GetValue(szFileStr, "FIFGambleZ", szResult, sizeof(szResult)))											FIFGamble[2] = floatstr(szResult);
		else if(ini_GetValue(szFileStr, "FIFGThurs", szResult, sizeof(szResult)))											FIFGThurs = strval(szResult);
	}
	if(iRewardBox) {
		iRewardObj = CreateDynamicObject(19055, fObjectPos[0], fObjectPos[1], fObjectPos[2], 0.0, 0.0, 0.0, .streamdistance = 100.0);
		tRewardText = CreateDynamic3DTextLabel("Gold Reward Gift Box\n{FFFFFF}/getrewardgift{F3FF02} to claim your gift!", COLOR_YELLOW, fObjectPos[0], fObjectPos[1], fObjectPos[2], 10.0, .testlos = 1, .streamdistance = 50.0);
	}
	if(FIFEnabled == 1)
	{
		FIFPickup = CreateDynamicPickup(1239, 23, FIFGamble[0], FIFGamble[1], FIFGamble[2], 0);
		FIFText = CreateDynamic3DTextLabel("Chance Gambler\n/gamblechances to risk all of your chances or double them", COLOR_RED, FIFGamble[0], FIFGamble[1], FIFGamble[2]+0.5,10.0);  
	}
	fclose(iFileHandle);
	printf("[MiscLoad] Misc Loaded");
}
stock ini_GetInt(szParse[], szValueName[], &iValue) {

	new
		iPos = strfind(szParse, "=", false);

	if(strcmp(szParse, szValueName, false, iPos) == 0) {
		iValue = strval(szParse[iPos + 1]);
		return 1;
	}
	return 0;
}

stock ini_GetFloat(szParse[], szValueName[], & Float: iValue) {

	new
		iPos = strfind(szParse, "=", false);

	if(strcmp(szParse, szValueName, false, iPos) == 0) {
		iValue = floatstr(szParse[iPos + 1]);
		return 1;
	}
	return 0;
}

stock ini_GetString(szParse[], szValueName[], szDest[], iLength = sizeof(szDest)) {

	new
		iPos = strfind(szParse, "=", false);

	if(strcmp(szParse, szValueName, false, iPos) == 0) {
		strcat(szDest, szParse[iPos + 1], iLength);
		return 1;
	}
	return 0;
}

stock Log(sz_fileName[], sz_input[]) {

	new
		sz_logEntry[256],
		#if defined _LINUX
		File: logfile,
		#endif
		i_dateTime[2][3];

	gettime(i_dateTime[0][0], i_dateTime[0][1], i_dateTime[0][2]);
	getdate(i_dateTime[1][0], i_dateTime[1][1], i_dateTime[1][2]);

	format(sz_logEntry, sizeof(sz_logEntry), "[%i/%i/%i - %i:%02i:%02i] %s\r\n", i_dateTime[1][0], i_dateTime[1][1], i_dateTime[1][2], i_dateTime[0][0], i_dateTime[0][1], i_dateTime[0][2], sz_input);
	if(logfile) fclose(logfile);
	if(!fexist(sz_fileName)) logfile = fopen(sz_fileName, io_write);
	else logfile = fopen(sz_fileName, io_append);
	if(logfile)
	{
		fwrite(logfile, sz_logEntry);
		fclose(logfile);
	}
	return 1;
}

stock LoadElevatorStuff() {

	if(!fexist("elevator.ini")) return 1;

	new
		szFileStr[64],
		iIndex,
		File: iFileHandle = fopen("elevator.ini", io_read);

	while(iIndex < 20 && fread(iFileHandle, szFileStr)) {
		sscanf(szFileStr, "p<|>s[24]s[24]", LAElevatorFloorData[0][iIndex], LAElevatorFloorData[1][iIndex]);
		StripNL(LAElevatorFloorData[1][iIndex]);
	 	iIndex++;
	}
	printf("[LoadElevatorStuff] %i floors loaded.", iIndex);
	return fclose(iFileHandle);
}

stock SaveElevatorStuff() {

	new
		File: iFileHandle = fopen("elevator.ini", io_write);

	for(new iIndex; iIndex < 20; ++iIndex) {
		fwrite(iFileHandle, LAElevatorFloorData[0][iIndex]);
		fputchar(iFileHandle, '|', false);
		fwrite(iFileHandle, LAElevatorFloorData[1][iIndex]);
		fwrite(iFileHandle, "\r\n");
	}
	return fclose(iFileHandle);
}

stock CreatePlayerVehicle(playerid, playervehicleid, modelid, Float: x, Float: y, Float: z, Float: angle, color1, color2, price, VW, Int)
{
	if(PlayerVehicleInfo[playerid][playervehicleid][pvId] == INVALID_PLAYER_VEHICLE_ID)
	{
 		VehicleSpawned[playerid]++;
	    PlayerCars++;
		PlayerVehicleInfo[playerid][playervehicleid][pvModelId] = modelid;
		PlayerVehicleInfo[playerid][playervehicleid][pvPosX] = x;
		PlayerVehicleInfo[playerid][playervehicleid][pvPosY] = y;
		PlayerVehicleInfo[playerid][playervehicleid][pvPosZ] = z;
		PlayerVehicleInfo[playerid][playervehicleid][pvPosAngle] = angle;
		PlayerVehicleInfo[playerid][playervehicleid][pvColor1] = color1;
		PlayerVehicleInfo[playerid][playervehicleid][pvColor2] = color2;
		PlayerVehicleInfo[playerid][playervehicleid][pvPark] = 1;
		PlayerVehicleInfo[playerid][playervehicleid][pvPrice] = price;
		for(new w = 0; w < 3; w++)
	    {
	    	PlayerVehicleInfo[playerid][playervehicleid][pvWeapons][w] = 0;
		}
		PlayerVehicleInfo[playerid][playervehicleid][pvWepUpgrade] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvImpounded] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvVW] = VW;
		PlayerVehicleInfo[playerid][playervehicleid][pvInt] = Int;
		PlayerVehicleInfo[playerid][playervehicleid][pvTicket] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvPlate] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvLock] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvLocksLeft] = 5;
        PlayerVehicleInfo[playerid][playervehicleid][pvLocked] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvAlarm] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvAlarmTriggered] = 0;
		PlayerVehicleInfo[playerid][playervehicleid][pvBeingPickLocked] = 0;
		
		for(new m = 0; m < MAX_MODS; m++)
	    {
	    	PlayerVehicleInfo[playerid][playervehicleid][pvMods][m] = 0;
		}
		new carcreated = CreateVehicle(modelid,x,y,z,angle,color1,color2,-1);
		SetVehicleVirtualWorld(carcreated, PlayerVehicleInfo[playerid][playervehicleid][pvVW]);
  		LinkVehicleToInterior(carcreated, PlayerVehicleInfo[playerid][playervehicleid][pvInt]);
		Vehicle_ResetData(carcreated);
		PlayerVehicleInfo[playerid][playervehicleid][pvId] = carcreated;
		PlayerVehicleInfo[playerid][playervehicleid][pvSpawned] = 1;
		PlayerVehicleInfo[playerid][playervehicleid][pvFuel] = 100.0;
		//SetVehicleNumberPlate(carcreated, PlayerVehicleInfo[playerid][playervehicleid][pvNumberPlate]);

		new string[128];
        format(string, sizeof(string), "INSERT INTO `vehicles` (`sqlID`) VALUES ('%d')", GetPlayerSQLId(playerid));
		mysql_function_query(MainPipeline, string, true, "OnQueryCreateVehicle", "ii", playerid, playervehicleid);

		return carcreated;
	}
	return INVALID_PLAYER_VEHICLE_ID;
}

forward SetPlayerWeapons(playerid);
public SetPlayerWeapons(playerid)
{
	if(HungerPlayerInfo[playerid][hgInEvent] == 1) { return 1;}
    if(GetPVarInt(playerid, "IsInArena") >= 0) { return 1; }
	ResetPlayerWeapons(playerid);
	for(new s = 0; s < 12; s++)
	{
		if(PlayerInfo[playerid][pGuns][s] > 0 && PlayerInfo[playerid][pAGuns][s] == 0)
		{
			GivePlayerValidWeapon(playerid, PlayerInfo[playerid][pGuns][s], 60000);
		}
	}
	return 1;
}

stock SetPlayerWeaponsEx(playerid)
{
	if(GetPVarInt(playerid, "IsInArena") >= 0) { return 1; }	
	ResetPlayerWeapons(playerid);
	for(new s = 0; s < 12; s++)
	{
		if(PlayerInfo[playerid][pGuns][s] > 0)
		{
			GivePlayerValidWeapon(playerid, PlayerInfo[playerid][pGuns][s], 60000);
		}
	}
	SetPlayerArmedWeapon(playerid, GetPVarInt(playerid, "LastWeapon"));
	return 1;
}

stock ShowStats(playerid,targetid)
{
	if(IsPlayerConnected(targetid))
	{
		new resultline[1024], header[65], org[128], employer[GROUP_MAX_NAME_LEN], rank[GROUP_MAX_RANK_LEN], division[GROUP_MAX_DIV_LEN];
		new sext[16], std[20], nation[24], biz[128];
		if(PlayerInfo[targetid][pSex] == 1) { sext = "Male"; } else { sext = "Female"; }
		switch(GetPVarInt(targetid, "STD"))
		{
		    case 1: std = "Chlamydia";
		    case 2: std = "Gonorrhea";
		    case 3: std = "Syphilis";
		    default: std = "None";
		}
		if(PlayerInfo[targetid][pMember] != INVALID_GROUP_ID)
		{
			GetPlayerGroupInfo(targetid, rank, division, employer);
			format(org, sizeof(org), "Faction: %s (%d)\nRank: %s (%d)\nBadge Number: %s\nDivision: %s (%d)\n", employer, PlayerInfo[targetid][pMember], rank, PlayerInfo[targetid][pRank], PlayerInfo[targetid][pBadge], division, PlayerInfo[targetid][pDivision]);
		}
		else if(PlayerInfo[targetid][pFMember] < INVALID_FAMILY_ID)
		{
			if(0 <= PlayerInfo[targetid][pDivision] < 5) format(division, sizeof(division), "%s", FamilyDivisionInfo[PlayerInfo[targetid][pFMember]][PlayerInfo[targetid][pDivision]]);
			else division = "None";
			format(org, sizeof(org), "Family: %s (%d)\nRank: %s (%d)\nDivision: %s (%d)\n", FamilyInfo[PlayerInfo[targetid][pFMember]][FamilyName], PlayerInfo[targetid][pFMember], FamilyRankInfo[PlayerInfo[targetid][pFMember]][PlayerInfo[targetid][pRank]], PlayerInfo[targetid][pRank], division, PlayerInfo[targetid][pDivision]);
		}
		else format(org, sizeof(org), "");
		if(PlayerInfo[targetid][pBusiness] != INVALID_BUSINESS_ID) format(biz, sizeof(biz), "Business: %s (%d)\nRank: %s (%d)\n", Businesses[PlayerInfo[targetid][pBusiness]][bName], PlayerInfo[targetid][pBusiness], GetBusinessRankName(PlayerInfo[targetid][pBusinessRank]), PlayerInfo[targetid][pBusinessRank]);
		else format(biz, sizeof(biz), "");
		switch(PlayerInfo[targetid][pNation])
		{
			case 0: nation = "San Andreas";
			case 1: nation = "Tierra Robada";
		}
		new insur[32];
		insur = GetHospitalName(PlayerInfo[targetid][pInsurance]);

		new staffrank[64];
		if(PlayerInfo[targetid][pHelper] > 0 || PlayerInfo[targetid][pWatchdog] > 0 || PlayerInfo[targetid][pSEC] > 0 || PlayerInfo[targetid][pAdmin] == 1 || (PlayerInfo[targetid][pAdmin] > 1 && PlayerInfo[playerid][pAdmin] <= PlayerInfo[targetid][pAdmin])) format(staffrank, sizeof(staffrank), "%s", GetStaffRank(targetid));
		else staffrank = "";
		new drank[64];
		if(PlayerInfo[targetid][pDonateRank] > 0)
		{
			switch(PlayerInfo[targetid][pDonateRank])
			{
				case 1: drank = "{800080}Bronze VIP{FFFFFF}\n";
				case 2: drank = "{800080}Silver VIP{FFFFFF}\n";
				case 3: drank = "{FFD700}Gold VIP{FFFFFF}\n";
				case 4: drank = "{E5E4E2}Platinum VIP{FFFFFF}\n";
			}
		}
		new svipmod[40];
		if(PlayerInfo[targetid][pVIPMod])
		{
			switch(PlayerInfo[targetid][pVIPMod])
			{
				case 1: svipmod = "{800080}VIP Moderator{FFFFFF}\n";
				case 2: svipmod = "{800080}Senior VIP Moderator{FFFFFF}\n";
			}
		}
		new famedrank[64];
		if(PlayerInfo[targetid][pFamed] > 0)
		{
			switch(PlayerInfo[targetid][pFamed])
			{
				case 1: famedrank = "{228B22}Old-School{FFFFFF}\n";
				case 2: famedrank = "{FF7F00}Chartered Old-School{FFFFFF}\n";
				case 3: famedrank = "{ADFF2F}Famed{FFFFFF}\n";
				case 4: famedrank = "{8F00FF}Famed Commissioner{FFFFFF}\n";
				case 5: famedrank = "{8F00FF}Famed Moderator{FFFFFF}\n";
				case 6: famedrank = "{8F00FF}Famed Vice-Chairman{FFFFFF}\n";
				case 7: famedrank = "{8F00FF}Famed Chairman{FFFFFF}\n";
			}
		}
		new dprank[64];
		if(PlayerInfo[targetid][pDedicatedPlayer] > 0)
		{
			switch(PlayerInfo[targetid][pDedicatedPlayer])
			{
				case 1: dprank = "{336600}Dedicated Player{FFFFFF}\n";
				case 2: dprank = "{336600}Super Dedicated Player{FFFFFF}\n";
				case 3: dprank = "{336600}Dedicated Moderator{FFFFFF}\n";
				case 4: dprank = "{336600}Dedicated Associate{FFFFFF}\n";
			}
		}
		if(PlayerInfo[targetid][pMarriedID] == -1) format(PlayerInfo[targetid][pMarriedName], MAX_PLAYER_NAME, "Nobody");
		new nxtlevel = PlayerInfo[targetid][pLevel]+1;
		new expamount = nxtlevel*4;
		new costlevel = nxtlevel*25000;
		new Float:health, Float:armor;
		GetHealth(targetid, health);
		GetArmour(targetid, armor);
		new Float:px,Float:py,Float:pz;
		GetPlayerPos(targetid, px, py, pz);
		new zone[MAX_ZONE_NAME];
		GetPlayer3DZone(targetid, zone, sizeof(zone));
		new fifstr[128];
		//if(FIFEnabled)
		//{
		format(fifstr, sizeof(fifstr), "{FF8000}FIF Hours:{FFFFFF} %d\n{FF8000}FIF Chances:{FFFFFF} %d\n", FIFInfo[targetid][FIFHours], FIFInfo[targetid][FIFChances]);
		//}
		SetPVarInt(playerid, "ShowStats", targetid);
		format(header, sizeof(header), "Showing Statistics of %s", GetPlayerNameEx(targetid));
		format(resultline, sizeof(resultline),"%s\n\
		%s\
		%s\
		%s\
		%s\
		%s\
		{FFFFFF}Level: %d\n\
		Gender: %s\n\
		Date of Birth: %s\n\
		Current Location: %s (%0.2f, %0.2f, %0.2f)\n\
		Married To: %s\n\
		Health: %.1f\n\
		Armor: %.1f\n\
		Hunger: %d\n\
		Fitness: %d\n\
		Playing Hours: %s\n\
		Upgrade Points: %s\n\
		Next Level: %s{303030}/{FFFFFF}%s hours ($%s)\n\
		Nation: %s\n\
		%s\
		%s\
		Job: %s (Level: %d)\n\
		Job 2: %s (Level: %d)\n\
		Job 3: %s (Level: %d)\n\
		Insurance: %s",
		staffrank,
		famedrank,
		dprank,
		drank,
		svipmod,
		fifstr,
		PlayerInfo[targetid][pLevel],
		sext,
		PlayerInfo[targetid][pBirthDate],
		zone, px, py, pz,
		PlayerInfo[targetid][pMarriedName],
		health,
		armor,
		PlayerInfo[targetid][pHunger],
		PlayerInfo[targetid][pFitness],
		number_format(PlayerInfo[targetid][pConnectHours]),
		number_format(PlayerInfo[targetid][gPupgrade]),
		number_format(PlayerInfo[targetid][pExp]),
		number_format(expamount),
		number_format(costlevel),
		nation,
		org,
		biz,
		GetJobName(PlayerInfo[targetid][pJob]),
		GetJobLevel(targetid, PlayerInfo[targetid][pJob]),
		GetJobName(PlayerInfo[targetid][pJob2]),
		GetJobLevel(targetid, PlayerInfo[targetid][pJob2]),
		GetJobName(PlayerInfo[targetid][pJob3]),
		GetJobLevel(targetid, PlayerInfo[targetid][pJob3]),
		insur);
		ShowPlayerDialog(playerid, DISPLAY_STATS, DIALOG_STYLE_MSGBOX, header, resultline, "Next Page", "Close");
	}
	return 1;
}

stock SetPlayerToTeamColor(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		if(PlayerInfo[playerid][pWantedLevel] > 0) {
			SetPlayerWantedLevel(playerid, PlayerInfo[playerid][pWantedLevel]);
		}
	    #if defined zombiemode
   		if(GetPVarType(playerid, "pZombieBit"))
    	{
	    	SetPlayerColor(playerid, 0xFFCC0000);
  	   		return 1;
		}
		if(GetPVarType(playerid, "pIsZombie"))
		{
  			SetPlayerColor(playerid, 0x0BC43600);
	    	return 1;
		}
 		if(GetPVarType(playerid, "pEventZombie"))
		{
			SetPlayerColor(playerid, 0x0BC43600);
			return 1;
		}
		#endif
		if(GetPVarInt(playerid, "IsInArena") >= 0)
	    {
	        new arenaid = GetPVarInt(playerid, "IsInArena");
	        if(PaintBallArena[arenaid][pbGameType] == 2 || PaintBallArena[arenaid][pbGameType] == 3 || PaintBallArena[arenaid][pbGameType] == 5) switch(PlayerInfo[playerid][pPaintTeam]) {
				case 1: SetPlayerColor(playerid, PAINTBALL_TEAM_RED);
				case 2: SetPlayerColor(playerid, PAINTBALL_TEAM_BLUE);
	        }
	    }
	    else if(PlayerInfo[playerid][pJailTime] > 0) {
            if(strfind(PlayerInfo[playerid][pPrisonReason], "[IC]", true) != -1 || strfind(PlayerInfo[playerid][pPrisonReason], "[ISOLATE]", true) != -1) {
				SetPlayerColor(playerid,TEAM_ORANGE_COLOR);
			}
			else if(strfind(PlayerInfo[playerid][pPrisonReason], "[OOC]", true) != -1) {
    			SetPlayerColor(playerid,TEAM_APRISON_COLOR);
			}
		}
		else if(PlayerInfo[playerid][pBeingSentenced] != 0)
		{
			SetPlayerColor(playerid, SHITTY_JUDICIALSHITHOTCH);
		}
		else if((PlayerInfo[playerid][pJob] == 17 || PlayerInfo[playerid][pJob2] == 17 || PlayerInfo[playerid][pJob3] == 17 || PlayerInfo[playerid][pTaxiLicense] == 1) && TransportDuty[playerid] != 0) {
			SetPlayerColor(playerid,TEAM_TAXI_COLOR);
		}
	    else if(0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS && PlayerInfo[playerid][pDuty]) {
			SetPlayerColor(playerid, arrGroupData[PlayerInfo[playerid][pMember]][g_hDutyColour] * 256);
		}
		else if(GetPVarType(playerid, "HitmanBadgeColour") && IsAHitman(playerid))
		{
		    SetPlayerColor(playerid, GetPVarInt(playerid, "HitmanBadgeColour"));
		}
		else {
			SetPlayerColor(playerid,TEAM_HIT_COLOR);
		}
	}
	return 1;
}

stock strfindcount(substring[], string[], bool:ignorecase = false, startpos = 0)
{
	new ncount, start = strfind(string, substring, ignorecase, startpos);
	while(start >- 1)
	{
		start = strfind(string, substring, ignorecase, start + strlen(substring));
		ncount++;
	}
	return ncount;
}

stock IsInvalidSkin(skin) {
	if(!(0 <= skin <= 299)) return 1;
    return 0;
}

stock IsKeyJustDown(key, newkeys, oldkeys)
{
	if((newkeys & key) && !(oldkeys & key)) return 1;
	return 0;
}

stock ResetPlayerWeaponsEx( playerid )
{
	DeletePVar(playerid, "HidingKnife");
	ResetPlayerWeapons(playerid);
	PlayerInfo[playerid][pGuns][ 0 ] = 0;
	PlayerInfo[playerid][pGuns][ 1 ] = 0;
	PlayerInfo[playerid][pGuns][ 2 ] = 0;
	PlayerInfo[playerid][pGuns][ 3 ] = 0;
	PlayerInfo[playerid][pGuns][ 4 ] = 0;
	PlayerInfo[playerid][pGuns][ 5 ] = 0;
	PlayerInfo[playerid][pGuns][ 6 ] = 0;
	PlayerInfo[playerid][pGuns][ 7 ] = 0;
	PlayerInfo[playerid][pGuns][ 8 ] = 0;
	PlayerInfo[playerid][pGuns][ 9 ] = 0;
	PlayerInfo[playerid][pGuns][ 10 ] = 0;
	PlayerInfo[playerid][pGuns][ 11 ] = 0;
	PlayerInfo[playerid][pAGuns][ 0 ] = 0;
	PlayerInfo[playerid][pAGuns][ 1 ] = 0;
	PlayerInfo[playerid][pAGuns][ 2 ] = 0;
	PlayerInfo[playerid][pAGuns][ 3 ] = 0;
	PlayerInfo[playerid][pAGuns][ 4 ] = 0;
	PlayerInfo[playerid][pAGuns][ 5 ] = 0;
	PlayerInfo[playerid][pAGuns][ 6 ] = 0;
	PlayerInfo[playerid][pAGuns][ 7 ] = 0;
	PlayerInfo[playerid][pAGuns][ 8 ] = 0;
	PlayerInfo[playerid][pAGuns][ 9 ] = 0;
	PlayerInfo[playerid][pAGuns][ 10 ] = 0;
	PlayerInfo[playerid][pAGuns][ 11 ] = 0;
	return 1;
}

stock ShowVehicleHUDForPlayer(playerid)
{
	PlayerTextDrawShow(playerid, _vhudTextFuel[playerid]);
	PlayerTextDrawShow(playerid, _vhudTextSpeed[playerid]);
	PlayerTextDrawShow(playerid, _vhudSeatBelt[playerid]);
	PlayerTextDrawShow(playerid, _vhudLights[playerid]);
	_vhudVisible[playerid] = 1;
}


stock HideVehicleHUDForPlayer(playerid)
{
	PlayerTextDrawHide(playerid, _vhudTextFuel[playerid]);
	PlayerTextDrawHide(playerid, _vhudTextSpeed[playerid]);
	PlayerTextDrawHide(playerid, _vhudSeatBelt[playerid]);
	PlayerTextDrawHide(playerid, _vhudLights[playerid]);
	_vhudVisible[playerid] = 0;
}

stock ShowBackupActiveForPlayer(playerid)
{
	PlayerTextDrawShow(playerid, BackupText[playerid]);
}

stock HideBackupActiveForPlayer(playerid)
{
	PlayerTextDrawHide(playerid, BackupText[playerid]);
}

stock UpdateVehicleHUDForPlayer(p, fuel, speed)
{
	new str[128], vehicleid = GetPlayerVehicleID(p), szColor[4];
	new engine,lights,alarm,doors,bonnet,boot,objective;
	GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
	switch(speed)
	{
	    case 0..40: szColor = "~w~";
	    case 41..60: szColor = "~y~";
	    default: szColor = "~r~";
	}

	if (IsVIPcar(vehicleid) || IsAdminSpawnedVehicle(vehicleid) || IsFamedVeh(vehicleid) || GetVehicleModel(vehicleid) == 481 || GetVehicleModel(vehicleid) == 509 || GetVehicleModel(vehicleid) == 510)
		format(str, sizeof(str), "~b~Fuel: ~w~U");
	else
		format(str, sizeof(str), "~b~Fuel: ~w~%i",fuel);

	PlayerTextDrawSetString(p, _vhudTextFuel[p], str);

	format(str, sizeof(str), "~b~MPH: %s%i",szColor, speed);
	PlayerTextDrawSetString(p, _vhudTextSpeed[p], str);
	
	if(Seatbelt[p] == 0)
	{
		format(str, sizeof(str), "~b~SB: ~r~OFF");
		PlayerTextDrawSetString(p, _vhudSeatBelt[p], str);
	}
	else if(Seatbelt[p] == 2) {
		format(str, sizeof(str), "~b~HM: ~g~ON");
		PlayerTextDrawSetString(p, _vhudSeatBelt[p], str);
	}
	else {
		format(str, sizeof(str), "~b~SB: ~g~ON");
		PlayerTextDrawSetString(p, _vhudSeatBelt[p], str);
	}
	if(lights != VEHICLE_PARAMS_ON) {
		format(str, sizeof(str), "~b~Lights: ~r~OFF");
		PlayerTextDrawSetString(p, _vhudLights[p], str);	
	}
	else {
		format(str, sizeof(str), "~b~Lights: ~g~ON");
		PlayerTextDrawSetString(p, _vhudLights[p], str);
	}
}

stock UpdateSpeedCamerasForPlayer(p)
{
	if (!IsPlayerConnected(p) || !IsPlayerInAnyVehicle(p) || GetPlayerState(p) != PLAYER_STATE_DRIVER) return;

	// static speed cameras
	for (new c = 0; c < MAX_SPEEDCAMERAS; c++)
	{
		if (SpeedCameras[c][_scActive] == false) continue;

		if (IsPlayerInRangeOfPoint(p, SpeedCameras[c][_scRange], SpeedCameras[c][_scPosX], SpeedCameras[c][_scPosY], SpeedCameras[c][_scPosZ]))
		{
		    if(PlayerInfo[p][pConnectHours] > 16)
		    {
				new Float:speedLimit = SpeedCameras[c][_scLimit];
				new Float:vehicleSpeed = player_get_speed(p);

				if (vehicleSpeed > speedLimit && PlayerInfo[p][pTicketTime] == 0)
				{
					new vehicleid = GetPlayerVehicleID(p);
					if(!IsAPlane(vehicleid) && !IsAHelicopter(vehicleid) && GetVehicleModel(vehicleid) != 481 && GetVehicleModel(vehicleid) != 509 && GetVehicleModel(vehicleid) != 510)
					{
						if(GetPVarType(p, "LockPickPlayerSQLId") && GetPVarInt(p, "LockPickVehicle") == vehicleid) {
							new string[155], Amount = floatround(125*(vehicleSpeed-speedLimit), floatround_round)+2000;
							SetPVarInt(p, "VLPTickets", GetPVarInt(p, "VLPTickets")+Amount);
							mysql_format(MainPipeline, string, sizeof(string), "UPDATE `vehicles` SET `pvTicket` = '%d' WHERE `id` = '%d'", GetPVarInt(p, "VLPTickets"), GetPVarInt(p, "LockPickVehicleSQLId"));
							mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "ii", SENDDATA_THREAD, p);
							PlayerInfo[p][pTicketTime] = 60;
							format(string, sizeof(string), "You were caught speeding and have received a speeding ticket of $%s", number_format(Amount));
							SendClientMessageEx(p, COLOR_WHITE, string);
							PlayerPlaySound(p, 1132, 0.0, 0.0, 0.0);
							PlayerTextDrawShow(p, _vhudFlash[p]);
							SetTimerEx("TurnOffFlash", 500, 0, "i", p);
						}
					    foreach(new i: Player)
						{
							new v = GetPlayerVehicle(i, vehicleid);
							if(v != -1)
							{
								new string[128], Amount = floatround(125*(vehicleSpeed-speedLimit), floatround_round)+2000;
								PlayerVehicleInfo[i][v][pvTicket] += Amount;
								PlayerInfo[p][pTicketTime] = 60;
								format(string, sizeof(string), "You were caught speeding and have received a speeding ticket of $%s", number_format(Amount));
								SendClientMessageEx(p, COLOR_WHITE, string);
								PlayerPlaySound(p, 1132, 0.0, 0.0, 0.0);
								PlayerTextDrawShow(p, _vhudFlash[p]);
								SetTimerEx("TurnOffFlash", 500, 0, "i", p);
								g_mysql_SaveVehicle(i, v);
							}
						}	
					}
			  	}
			}
		}
	}
}

stock UpdateWheelTarget()
{
    gCurrentTargetYAngle += 36.0; // There are 10 carts, so 360 / 10
    if(gCurrentTargetYAngle >= 360.0) {
		gCurrentTargetYAngle = 0.0;
    }
	if(gWheelTransAlternate) gWheelTransAlternate = 0;
	else gWheelTransAlternate = 1;
}

stock ConvertTimeS(seconds, TYPE = 0)
{
	new string[64], minutes;
	if(TYPE == 0) {
		if(seconds > 86400)
		{
			if(floatround((seconds/86400), floatround_floor) > 1) format(string, sizeof(string), "%d days", floatround((seconds/86400), floatround_floor));
			else format(string, sizeof(string), "%d day", floatround((seconds/86400), floatround_floor));
			seconds=seconds-((floatround((seconds/86400), floatround_floor))*86400);
		}
		if(seconds > 3600)
		{
			if(strlen(string) > 0) format(string, sizeof(string), "%s, ", string);
			if(floatround((seconds/3600), floatround_floor) > 1) format(string, sizeof(string), "%s%d hours", string, floatround((seconds/3600), floatround_floor));
			else format(string, sizeof(string), "%s%d hour", string, floatround((seconds/3600), floatround_floor));
			seconds=seconds-((floatround((seconds/3600), floatround_floor))*3600);
		}
		if(seconds > 60)
		{
			if(strlen(string) > 0) format(string, sizeof(string), "%s, ", string);
			if(floatround((seconds/60), floatround_floor) > 1) format(string, sizeof(string), "%s%d minutes", string, floatround((seconds/60), floatround_floor));
			else format(string, sizeof(string), "%s%d minute", string, floatround((seconds/60), floatround_floor));
			seconds=seconds-((floatround((seconds/60), floatround_floor))*60);
		}
		if(strlen(string) > 0) format(string, sizeof(string), "%s, ", string);
		if(seconds > 1) format(string, sizeof(string), "%s%d seconds", string, seconds);
		else if(seconds != 0) format(string, sizeof(string), "%s%d second", string, seconds);
	}
	else {
		if(seconds > 60)
		{
			minutes = floatround((seconds/60), floatround_floor);
			if(minutes > 9) format(string, sizeof(string), "%d", minutes);
			else format(string, sizeof(string), "0%d", minutes);
			seconds = seconds - (minutes * 60);
		}
		if(minutes > 0) {
			if(seconds > 9) format(string, sizeof(string), "%s:%d", string, seconds);
			else format(string, sizeof(string), "%s:0%d", string, seconds);
		}
		else {
			if(seconds > 9) format(string, sizeof(string), "00:%d", seconds);
			else format(string, sizeof(string), "00:0%d", seconds);
		}
		
	}
	return string;
}

stock ConvertTime(cts, &ctm=-1,&cth=-1,&ctd=-1,&ctw=-1,&ctmo=-1,&cty=-1)
{
    //Defines to drastically reduce the code..

    #define PLUR(%0,%1,%2) (%0),((%0) == 1)?((#%1)):((#%2))

    #define CTM_cty 31536000
    #define CTM_ctmo 2628000
    #define CTM_ctw 604800
    #define CTM_ctd 86400
    #define CTM_cth 3600
    #define CTM_ctm 60

    #define CT(%0) %0 = cts / CTM_%0; cts %= CTM_%0


    new strii[128];

    if(cty != -1)
    {
        CT(cty); CT(ctmo); CT(ctw); CT(ctd); CT(cth); CT(ctm);
        format(strii, sizeof(strii), "%d %s, %d %s, %d %s, %d %s, %d %s, %d %s, and %d %s",PLUR(cty,"year","years"),PLUR(ctmo,"month","months"),PLUR(ctw,"week","weeks"),PLUR(ctd,"day","days"),PLUR(cth,"hour","hours"),PLUR(ctm,"minute","minutes"),PLUR(cts,"second","seconds"));
        return strii;
    }
    if(ctmo != -1)
    {
        CT(ctmo); CT(ctw); CT(ctd); CT(cth); CT(ctm);
        format(strii, sizeof(strii), "%d %s, %d %s, %d %s, %d %s, %d %s, and %d %s",PLUR(ctmo,"month","months"),PLUR(ctw,"week","weeks"),PLUR(ctd,"day","days"),PLUR(cth,"hour","hours"),PLUR(ctm,"minute","minutes"),PLUR(cts,"second","seconds"));
        return strii;
    }
    if(ctw != -1)
    {
        CT(ctw); CT(ctd); CT(cth); CT(ctm);
        format(strii, sizeof(strii), "%d %s, %d %s, %d %s, %d %s, and %d %s",PLUR(ctw,"week","weeks"),PLUR(ctd,"day","days"),PLUR(cth,"hour","hours"),PLUR(ctm,"minute","minutes"),PLUR(cts,"second","seconds"));
        return strii;
    }
    if(ctd != -1)
    {
        CT(ctd); CT(cth); CT(ctm);
        format(strii, sizeof(strii), "%d %s, %d %s, %d %s, and %d %s",PLUR(ctd,"day","days"),PLUR(cth,"hour","hours"),PLUR(ctm,"minute","minutes"),PLUR(cts,"second","seconds"));
        return strii;
    }
    if(cth != -1)
    {
        CT(cth); CT(ctm);
        format(strii, sizeof(strii), "%d %s, %d %s, and %d %s",PLUR(cth,"hour","hours"),PLUR(ctm,"minute","minutes"),PLUR(cts,"second","seconds"));
        return strii;
    }
    if(ctm != -1)
    {
        CT(ctm);
        format(strii, sizeof(strii), "%d %s, and %d %s",PLUR(ctm,"minute","minutes"),PLUR(cts,"second","seconds"));
        return strii;
    }
    format(strii, sizeof(strii), "%d %s", PLUR(cts,"second","seconds"));
    return strii;
}

stock IsValidVehicleID(vehicleid)
{
   if(GetVehicleModel(vehicleid)) return 1;
   return 0;
}

stock ExecuteNOPAction(playerid)
{
	new string[128];
	new newcar = GetPlayerVehicleID(playerid);
	if(NOPTrigger[playerid] >= MAX_NOP_WARNINGS) { return 1; }
	NOPTrigger[playerid]++;
	RemovePlayerFromVehicle(playerid);
	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(playerid, X, Y, Z);
	SetPlayerPos(playerid, X, Y, Z+2);
	defer NOPCheck(playerid);
	if(NOPTrigger[playerid] > 1)
	{
		new sec = (NOPTrigger[playerid] * 5000)/1000-1;
		format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s (ID %d) may be NOP hacking - restricted vehicle (model %d) for %d seconds.", GetPlayerNameEx(playerid), playerid, GetVehicleModel(newcar),sec);
		ABroadCast(COLOR_YELLOW, string, 2);
	}
	return 1;
}

stock Random(min, max)
{
    new a = random(max - min) + min;
    return a;
}

stock CheckServerAd(szInput[]) {

	new
		iCount,
		iPeriod,
		iPos,
		iChar,
		iColon;

	while((iChar = szInput[iPos++])) {
		if('0' <= iChar <= '9') iCount++;
		else if(iChar == '.') iPeriod++;
		else if(iChar == ':') iColon++;
	}
	if(iCount >= 7 && iPeriod >= 3 && iColon >= 1) {
		return 1;
	}

	return 0;
}

stock FMemberCounter()
{

	new
		arrCounts[sizeof(FamilyInfo)],
		szFileStr[128],
		arrTimeStamp[2][3],
		File: iFileHandle;
	if(!fexist("logs/fmembercount.log")) {
		iFileHandle = fopen("logs/fmembercount.log", io_write);
	}
	else {
		iFileHandle = fopen("logs/fmembercount.log", io_append);
	}
	if(iFileHandle)
	{
		gettime(arrTimeStamp[0][0], arrTimeStamp[0][1], arrTimeStamp[0][2]);
		getdate(arrTimeStamp[1][0], arrTimeStamp[1][1], arrTimeStamp[1][2]);
		foreach(new i: Player)
		{
			if(PlayerInfo[i][pAdmin] < 2 && playerTabbed[i] == 0 && PlayerInfo[i][pFMember] != 255) ++arrCounts[PlayerInfo[i][pFMember]];
		}
		format(szFileStr, sizeof(szFileStr), "----------------------------------------\r\nDate: %d/%d/%d - Time: %d:%d\r\n", arrTimeStamp[1][1], arrTimeStamp[1][2], arrTimeStamp[1][0], arrTimeStamp[0][0], arrTimeStamp[0][1]);
		fwrite(iFileHandle, szFileStr);

		for(new iFam; iFam < sizeof(FamilyInfo); ++iFam) format(szFileStr, sizeof(szFileStr), "(%i) %s: %i\r\n", iFam+1, FamilyInfo[iFam][FamilyName], arrCounts[iFam]), fwrite(iFileHandle, szFileStr);
		return fclose(iFileHandle);

	}
	return 0;
}

stock SaveFamilies()
{
	for(new i = 1; i < MAX_FAMILY; i++)
	{
		SaveFamily(i);
	}
	return 1;
}

stock GivePlayerValidWeapon( playerid, WeaponID, Ammo )
{
    #if defined zombiemode
   	if(zombieevent == 1 && GetPVarType(playerid, "pIsZombie")) return SendClientMessageEx(playerid, COLOR_GREY, "Zombies can't have guns.");
	#endif
	switch( WeaponID )
	{
  		case 0, 1:
		{
			PlayerInfo[playerid][pGuns][ 0 ] = WeaponID;
			GivePlayerWeapon( playerid, WeaponID, Ammo );
		}
		case 2, 3, 4, 5, 6, 7, 8, 9:
		{
			PlayerInfo[playerid][pGuns][ 1 ] = WeaponID;
			GivePlayerWeapon( playerid, WeaponID, Ammo );
		}
		case 22, 23, 24:
		{
			PlayerInfo[playerid][pGuns][ 2 ] = WeaponID;
			GivePlayerWeapon( playerid, WeaponID, Ammo );
		}
		case 25, 26, 27:
		{
			PlayerInfo[playerid][pGuns][ 3 ] = WeaponID;
			GivePlayerWeapon( playerid, WeaponID, Ammo );
		}
		case 28, 29, 32:
		{
			PlayerInfo[playerid][pGuns][ 4 ] = WeaponID;
			GivePlayerWeapon( playerid, WeaponID, Ammo );
		}
		case 30, 31:
		{
			PlayerInfo[playerid][pGuns][ 5 ] = WeaponID;
			GivePlayerWeapon( playerid, WeaponID, Ammo );
		}
		case 33, 34:
		{
			PlayerInfo[playerid][pGuns][ 6 ] = WeaponID;
			GivePlayerWeapon( playerid, WeaponID, Ammo );
		}
		case 35, 36, 37, 38:
		{
			PlayerInfo[playerid][pGuns][ 7 ] = WeaponID;
			GivePlayerWeapon( playerid, WeaponID, Ammo );
		}
		case 16, 17, 18, 39, 40:
		{
			PlayerInfo[playerid][pGuns][ 8 ] = WeaponID;
			GivePlayerWeapon( playerid, WeaponID, Ammo );
		}
		case 41, 42, 43:
		{
			PlayerInfo[playerid][pGuns][ 9 ] = WeaponID;
			GivePlayerWeapon( playerid, WeaponID, Ammo );
		}
		case 10, 11, 12, 13, 14, 15:
		{
			PlayerInfo[playerid][pGuns][ 10 ] = WeaponID;
			GivePlayerWeapon( playerid, WeaponID, Ammo );
		}
		case 44, 45, 46:
		{
			PlayerInfo[playerid][pGuns][ 11 ] = WeaponID;
			GivePlayerWeapon( playerid, WeaponID, Ammo );
		}
	}
	return 1;
}

stock RegisterVehicleNumberPlate(vehicleid, sz_NumPlate[]) {
	new
	    Float: a_CarPos[4], Float: fuel; // X, Y, Z, Z Angle, Fuel

	GetVehiclePos(vehicleid, a_CarPos[0], a_CarPos[1], a_CarPos[2]);
	GetVehicleZAngle(vehicleid, a_CarPos[3]);
	fuel = VehicleFuel[vehicleid];
	SetVehicleNumberPlate(vehicleid, sz_NumPlate);
	SetVehicleToRespawn(vehicleid);
	SetVehiclePos(vehicleid, a_CarPos[0], a_CarPos[1], a_CarPos[2]);
	SetVehicleZAngle(vehicleid, a_CarPos[3]);
	VehicleFuel[vehicleid] = fuel;
	return 1;
}

stock DisplayOrders(playerid)
{
	new szDialog[2048];
	for (new i, j; i < MAX_BUSINESSES; i++)
	{
	    if (Businesses[i][bOrderState] == 1)
	    {
	        if(Businesses[i][bType] > 0)
	        {
		    	format(szDialog, sizeof(szDialog), "%s%s\t%s\n", szDialog, Businesses[i][bName], GetInventoryType(i));
				ListItemTrackId[playerid][j++] = i;
			}
		}
	}

	if (!szDialog[0] || IsABoat(GetPlayerVehicleID(playerid)))
	{

		/*ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Error", "No jobs available right now. Try again later.", "OK", "");
		TogglePlayerControllable(playerid, 1);
		DeletePVar(playerid, "IsFrozen"); */
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 456 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 414 || IsABoat(GetPlayerVehicleID(playerid)))
		{
			ShowPlayerDialog(playerid,DIALOG_LOADTRUCKOLD,DIALOG_STYLE_LIST,"What do you want to transport?","{00F70C}Legal goods {FFFFFF}(no risk but also no bonuses)\n{FF0606}Illegal goods {FFFFFF}(risk of getting caught but a bonus)","Select","Cancel");
		}
		else
		{
			ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Error", "No jobs available for this type of truck right now. Try again later.", "OK", "");
			TogglePlayerControllable(playerid, 1);
			DeletePVar(playerid, "IsFrozen");
		}
	}
	else
	{
	    ShowPlayerDialog(playerid, DIALOG_LOADTRUCK, DIALOG_STYLE_LIST, "Available Orders", szDialog, "Take", "Close");
	}
	return 1;
}

stock GetClosestCar(iPlayer, iException = INVALID_VEHICLE_ID, Float: fRange = Float: 0x7F800000) {

	new
		iReturnID = INVALID_VEHICLE_ID,
		Float: fVehiclePos[4];

	for(new i = 1; i <= MAX_VEHICLES; ++i) if(GetVehicleModel(i) && i != iException) {
		GetVehiclePos(i, fVehiclePos[0], fVehiclePos[1], fVehiclePos[2]);
		if((fVehiclePos[3] = GetPlayerDistanceFromPoint(iPlayer, fVehiclePos[0], fVehiclePos[1], fVehiclePos[2])) < fRange) {
			fRange = fVehiclePos[3];
			iReturnID = i;
		}
	}
	return iReturnID;
}

stock MoveGate(playerid, gateid)
{
	new string[128];
	if(GateInfo[gateid][gStatus] == 0)
	{
		format(string, sizeof(string), "* %s uses their remote to open the gates.", GetPlayerNameEx(playerid));
		ProxDetector(GateInfo[gateid][gRange], playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		MoveDynamicObject(GateInfo[gateid][gGATE], GateInfo[gateid][gPosXM], GateInfo[gateid][gPosYM], GateInfo[gateid][gPosZM], GateInfo[gateid][gSpeed], GateInfo[gateid][gRotXM], GateInfo[gateid][gRotYM], GateInfo[gateid][gRotZM]);
		GateInfo[gateid][gStatus] = 1;
		if(GateInfo[gateid][gTimer] != 0)
		{
			switch(GateInfo[gateid][gTimer])
			{
				case 1: SetTimerEx("MoveTimerGate", 3000, false, "i", gateid);
				case 2: SetTimerEx("MoveTimerGate", 5000, false, "i", gateid);
				case 3: SetTimerEx("MoveTimerGate", 8000, false, "i", gateid);
				case 4: SetTimerEx("MoveTimerGate", 10000, false, "i", gateid);
			}
		}
	}
	else if(GateInfo[gateid][gStatus] == 1 && GateInfo[gateid][gTimer] == 0)
	{
		format(string, sizeof(string), "* %s uses their remote to close the gates.", GetPlayerNameEx(playerid));
		ProxDetector(GateInfo[gateid][gRange], playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		MoveDynamicObject(GateInfo[gateid][gGATE], GateInfo[gateid][gPosX], GateInfo[gateid][gPosY], GateInfo[gateid][gPosZ], GateInfo[gateid][gSpeed], GateInfo[gateid][gRotX], GateInfo[gateid][gRotY], GateInfo[gateid][gRotZ]);
		GateInfo[gateid][gStatus] = 0;
	}
}

stock IsAnAmbulance(carid)
{
	if(DynVeh[carid] != -1)
	{
	    new iDvSlotID = DynVeh[carid], iGroupID = DynVehicleInfo[iDvSlotID][gv_igID];
	    if((0 <= iGroupID < MAX_GROUPS))
	    {
	    	if(arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_MEDIC) return 1;
			else if(arrGroupData[iGroupID][g_iMedicAccess] != INVALID_RANK) return 1;
			else if(carid == 416) return 1;
		}
	}
	return 0;
}
stock IsACopCar(carid)
{
	if(DynVeh[carid] != -1)
	{
	    new iDvSlotID = DynVeh[carid], iGroupID = DynVehicleInfo[iDvSlotID][gv_igID];
	    if((0 <= iGroupID < MAX_GROUPS))
	    {
	    	if(arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_LEA) return 1;
		}
	}
	return 0;
}

stock IsANewsCar(carid)
{
	if(DynVeh[carid] != -1)
	{
	    new iDvSlotID = DynVeh[carid], iGroupID = DynVehicleInfo[iDvSlotID][gv_igID];
	    if((0 <= iGroupID < MAX_GROUPS))
	    {
	    	if(arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_NEWS) return 1;
		}
	}
	return 0;
}

stock DisplayItemPricesDialog(businessid, playerid)
{

	new szDialog[612], pvar[25], iListIndex, i;
	if (Businesses[businessid][bType] == BUSINESS_TYPE_STORE || Businesses[businessid][bType] == BUSINESS_TYPE_GASSTATION) i = sizeof(StoreItems);
	if (Businesses[businessid][bType] == BUSINESS_TYPE_SEXSHOP) i = sizeof(SexItems);
	if (Businesses[businessid][bType] == BUSINESS_TYPE_RESTAURANT) i = sizeof(RestaurantItems);

	for(new item; item < i; item++)
	{
	    if(Businesses[businessid][bItemPrices][item] == 0) continue;
		new cost = (PlayerInfo[playerid][pDonateRank] >= 1) ? (floatround(Businesses[businessid][bItemPrices][item] * 0.8)) : (Businesses[businessid][bItemPrices][item]);
	    if(Businesses[businessid][bType] == BUSINESS_TYPE_STORE || Businesses[businessid][bType] == BUSINESS_TYPE_GASSTATION) format(szDialog, sizeof(szDialog), "%s%s  ($%s)\n", szDialog, StoreItems[item], number_format(cost));
	    else if(Businesses[businessid][bType] == BUSINESS_TYPE_SEXSHOP) format(szDialog, sizeof(szDialog), "%s%s  ($%s)\n", szDialog, SexItems[item], number_format(cost));
	    else if(Businesses[businessid][bType] == BUSINESS_TYPE_RESTAURANT) format(szDialog, sizeof(szDialog), "%s%s  ($%s)\n", szDialog, RestaurantItems[item], number_format(cost));
		format(pvar, sizeof(pvar), "Business_MenuItem%d", iListIndex);
		SetPVarInt(playerid, pvar, item + 1);
	    format(pvar, sizeof(pvar), "Business_MenuItemPrice%d", iListIndex++);
		SetPVarInt(playerid, pvar, Businesses[businessid][bItemPrices][item]);
	}

   	if(strlen(szDialog) == 0) {
        SendClientMessageEx(playerid, COLOR_GRAD2, "   Store is not selling any items!");
    }
    else {
        if (Businesses[businessid][bType] == BUSINESS_TYPE_SEXSHOP)
        {
			ShowPlayerDialog(playerid, SHOPMENU, DIALOG_STYLE_LIST, GetBusinessTypeName(Businesses[businessid][bType]), szDialog, "Buy", "Cancel");
        }
		else if (Businesses[businessid][bType] == BUSINESS_TYPE_RESTAURANT)
		{
			ShowPlayerDialog(playerid, RESTAURANTMENU2, DIALOG_STYLE_LIST, GetBusinessTypeName(Businesses[businessid][bType]), szDialog, "Buy", "Cancel");
		}
        else
        {
    		ShowPlayerDialog(playerid, STOREMENU, DIALOG_STYLE_LIST, GetBusinessTypeName(Businesses[businessid][bType]), szDialog, "Buy", "Cancel");
		}
    }
}

LoadPlayerDisabledVehicles(playerid)
{
	new vehiclecount;
	switch(PlayerInfo[playerid][pDonateRank]) {
		case 0: {
			for(new v = 0; v < MAX_PLAYERVEHICLES; v++)
			{
				vehiclecount++;
				if(PlayerInfo[playerid][pVehicleSlot] + 6 <= vehiclecount) {
					PlayerVehicleInfo[playerid][v][pvDisabled] = 1;
				} else {
					PlayerVehicleInfo[playerid][v][pvDisabled] = 0;
				}	
			}
		}
		case 1: {
            for(new v = 0; v < MAX_PLAYERVEHICLES; v++)
			{
				vehiclecount++;
				if(PlayerInfo[playerid][pVehicleSlot] + 7 <= vehiclecount) {
					PlayerVehicleInfo[playerid][v][pvDisabled] = 1;
				} else {
					PlayerVehicleInfo[playerid][v][pvDisabled] = 0;
				}	
			}
		}
		case 2: {
            for(new v = 0; v < MAX_PLAYERVEHICLES; v++)
			{
				vehiclecount++;
				if(PlayerInfo[playerid][pVehicleSlot] + 8 <= vehiclecount) {
					PlayerVehicleInfo[playerid][v][pvDisabled] = 1;
				} else {
					PlayerVehicleInfo[playerid][v][pvDisabled] = 0;
				}	
			}
        }
		case 3: {
            for(new v = 0; v < MAX_PLAYERVEHICLES; v++)
			{
				vehiclecount++;
				if(PlayerInfo[playerid][pVehicleSlot] + 9 <= vehiclecount) {
					PlayerVehicleInfo[playerid][v][pvDisabled] = 1;
				} else {
					PlayerVehicleInfo[playerid][v][pvDisabled] = 0;
				}	
			}
        }
        default: {
        	for(new v = 0; v < MAX_PLAYERVEHICLES; v++)
			{
				vehiclecount++;
				if(PlayerInfo[playerid][pVehicleSlot] + 11 <= vehiclecount) {
					PlayerVehicleInfo[playerid][v][pvDisabled] = 1;
				} else {
					PlayerVehicleInfo[playerid][v][pvDisabled] = 0;
				}	
			}
        }
	}
	return 1;
}	

stock CompleteToyTrade(playerid)
{
	new string[156],
		sellerid = GetPVarInt(playerid, "ttSeller"),
		name[24],
		toyid = GetPVarInt(sellerid, "ttToy");
				
	for(new i;i<sizeof(HoldingObjectsAll);i++)
	{
		if(HoldingObjectsAll[i][holdingmodelid] == toyid)
		{
			format(name, sizeof(name), "(%s)", HoldingObjectsAll[i][holdingmodelname]);
		}
	}
	if(toyid != 0 && (strcmp(name, "None", true) == 0))
	{
		format(name, sizeof(name), "(ID: %d)", toyid);
	}
	
	new icount = GetPlayerToySlots(playerid);
	
	if(!toyCountCheck(playerid))
	{
		format(string, sizeof(string), "%s has declined the toy offer. (no free toy slots)", GetPlayerNameEx(playerid));
		SendClientMessageEx(sellerid, COLOR_GREY, string);
		SendClientMessageEx(playerid, COLOR_GREY, "You don't have any free toy slots.");
		SetPVarInt(GetPVarInt(playerid, "ttSeller"), "ttBuyer", INVALID_PLAYER_ID);
		SetPVarInt(GetPVarInt(playerid, "ttSeller"), "ttCost", 0);
		SetPVarInt(playerid, "ttSeller", INVALID_PLAYER_ID);
					
		HideTradeToysGUI(playerid);
		return 1;
	}	
	
	if(GetPlayerCash(playerid) < GetPVarInt(sellerid, "ttCost"))
	{
		format(string, sizeof(string), "%s has declined the toy offer. (Not enough money)", GetPlayerNameEx(playerid));
		SendClientMessageEx(sellerid, COLOR_GREY, string);
		SendClientMessageEx(playerid, COLOR_GREY, "You do not have enough money on you.");
		SetPVarInt(GetPVarInt(playerid, "ttSeller"), "ttBuyer", INVALID_PLAYER_ID);
		SetPVarInt(GetPVarInt(playerid, "ttSeller"), "ttCost", 0);
		SetPVarInt(playerid, "ttSeller", INVALID_PLAYER_ID);
				
		HideTradeToysGUI(playerid);
		return 1;
	}	
		
	GivePlayerCash(playerid, -GetPVarInt(sellerid, "ttCost"));
	GivePlayerCash(sellerid, GetPVarInt(sellerid, "ttCost"));
	
	for(new i = 0; i < icount; i++)
	{
		if(!PlayerToyInfo[playerid][i][ptModelID]) 
		{
			PlayerToyInfo[playerid][i][ptModelID] = toyid;
			PlayerToyInfo[playerid][i][ptBone] = 1; // Doesn't need to be accurate, you can let the player choose.
			PlayerToyInfo[playerid][i][ptPosX] = 1.0;
			PlayerToyInfo[playerid][i][ptPosY] = 1.0;
			PlayerToyInfo[playerid][i][ptPosZ] = 1.0;
			PlayerToyInfo[playerid][i][ptRotX] = 0.0;
			PlayerToyInfo[playerid][i][ptRotY] = 0.0;
			PlayerToyInfo[playerid][i][ptRotZ] = 0.0;
			PlayerToyInfo[playerid][i][ptScaleX] = 1.0;
			PlayerToyInfo[playerid][i][ptScaleY] = 1.0;
			PlayerToyInfo[playerid][i][ptScaleZ] = 1.0;
			PlayerToyInfo[playerid][i][ptTradable] = 1;
			
			if(PlayerToyInfo[playerid][i][ptSpecial] == 1) 
			{
				PlayerToyInfo[playerid][i][ptSpecial] = 0;
			}
			else
				PlayerToyInfo[playerid][i][ptSpecial] = PlayerToyInfo[sellerid][GetPVarInt(sellerid, "ttToySlot")][ptSpecial];
			if(PlayerToyInfo[playerid][i][ptSpecial] == 2)
			{
				PlayerToyInfo[playerid][i][ptBone] = 2;
				PlayerToyInfo[playerid][i][ptPosX] = 0.07;
				PlayerToyInfo[playerid][i][ptPosY] = 0.0;
				PlayerToyInfo[playerid][i][ptPosZ] = 0.0;
				PlayerToyInfo[playerid][i][ptRotX] = 88.0;
				PlayerToyInfo[playerid][i][ptRotY] = 75.0;
				PlayerToyInfo[playerid][i][ptRotZ] = 0.0;
				PlayerToyInfo[playerid][i][ptScaleX] = 0.0;
				PlayerToyInfo[playerid][i][ptScaleY] = 0.0;
				PlayerToyInfo[playerid][i][ptScaleZ] = 0.0;
			}
			// Seller	
			format(string, sizeof(string), "DELETE FROM `toys` WHERE `id` = '%d'", PlayerToyInfo[sellerid][GetPVarInt(sellerid, "ttToySlot")][ptID]);
			mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "ii", SENDDATA_THREAD, sellerid);
				
			g_mysql_NewToy(playerid, i);
			break;
		}	
	}
	
	PlayerToyInfo[sellerid][GetPVarInt(sellerid, "ttToySlot")][ptID] = 0;
	PlayerToyInfo[sellerid][GetPVarInt(sellerid, "ttToySlot")][ptModelID] = 0;
	PlayerToyInfo[sellerid][GetPVarInt(sellerid, "ttToySlot")][ptBone] = 0;
	PlayerToyInfo[sellerid][GetPVarInt(sellerid, "ttToySlot")][ptSpecial] = 0;
	
	OnPlayerStatsUpdate(playerid);
	OnPlayerStatsUpdate(sellerid);
			
	format(string, sizeof(string), "%s has accepted your offer and purchased your toy for $%s. %s", GetPlayerNameEx(playerid), number_format(GetPVarInt(sellerid, "ttCost")), name);
	SendClientMessageEx(sellerid, COLOR_LIGHTBLUE, string);
	format(string, sizeof(string), "You have accepted %s's offer and purchased the toy for $%s. %s", GetPlayerNameEx(sellerid), number_format(GetPVarInt(sellerid, "ttCost")), name);
	SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	format(string, sizeof(string), "[S %s(%d)][IP %s][B %s(%d)][IP %s][P $%s][T: %s(%d)]", GetPlayerNameEx(sellerid), GetPlayerSQLId(sellerid), GetPlayerIpEx(sellerid),
	GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), number_format(GetPVarInt(sellerid, "ttCost")), name, toyid);
	Log("logs/toys.log", string);
			
	SetPVarInt(GetPVarInt(playerid, "ttSeller"), "ttSeller", INVALID_PLAYER_ID);
	SetPVarInt(GetPVarInt(playerid, "ttSeller"), "ttBuyer", INVALID_PLAYER_ID);
	SetPVarInt(GetPVarInt(playerid, "ttSeller"), "ttCost", 0);
	SetPVarInt(playerid, "ttSeller", INVALID_PLAYER_ID);
			
	HideTradeToysGUI(playerid);
	return 1;
}

forward FixServerTime();
public FixServerTime()
{
	gettime(ghour, gminute, gsecond);
	FixHour(ghour);
	ghour = shifthour;
	
	new tmphour;
	new tmpminute;
	new tmpsecond;
	gettime(tmphour, tmpminute, tmpsecond);
	FixHour(tmphour);
	tmphour = shifthour;
	SetWorldTime(tmphour);
	print("Adjusted the server time...");
	return 1;
}	

forward ResetVariables();
public ResetVariables()
{
	for(new i = 1; i < MAX_VEHICLES; i++)  {
		DynVeh[i] = -1;
		TruckDeliveringTo[i] = INVALID_BUSINESS_ID;
	}
	
	if(Jackpot < 0) Jackpot = 0;
	if(TaxValue < 0) TaxValue = 0;

	for(new i = 0; i < MAX_VEHICLES; ++i) {
		VehicleFuel[i] = 100.0;
	}
	for(new i = 0; i < sizeof(CreatedCars); ++i) {
		CreatedCars[i] = INVALID_VEHICLE_ID;
	}
	
	EventKernel[EventRequest] = INVALID_PLAYER_ID;
	EventKernel[EventCreator] = INVALID_PLAYER_ID;
	for(new x; x < sizeof(EventKernel[EventStaff]); x++) {
		EventKernel[EventStaff][x] = INVALID_PLAYER_ID;
	}
	print("Resetting default server variables..");
	return 1;
}	

forward ResetNews();
public ResetNews()
{
	News[hTaken1] = 0; News[hTaken2] = 0; News[hTaken3] = 0; News[hTaken4] = 0; News[hTaken5] = 0; new string[32];
	for(new i = 0; i < 6; i++)
	{
		format(string, sizeof(string), "News[hAdd%d]", i);
		strcat(string, "Nothing");
		format(string, sizeof(string), "News[hContact%d]", i);
		strcat(string, "No-one");
	}
	print("Resetting news...");
	return true;
}

forward SpecUpdate(playerid);
public SpecUpdate(playerid)
{
	if(Spectating[playerid] > 0 && Spectate[playerid] != INVALID_PLAYER_ID)
	{	
		for(new i = 0; i < 2; i++)
		{
			TogglePlayerSpectating(playerid, true);
			PlayerSpectatePlayer( playerid, Spectate[playerid] );
			SetPlayerInterior( playerid, GetPlayerInterior( Spectate[playerid] ) );
			SetPlayerVirtualWorld( playerid, GetPlayerVirtualWorld( Spectate[playerid] ) );
		}	
	}	
	else if(Spectating[playerid] > 0 && GetPVarInt(playerid, "SpectatingWatch") != INVALID_PLAYER_ID)
	{
		for(new i = 0; i < 2; i++)
		{
			TogglePlayerSpectating(playerid, true);
			PlayerSpectatePlayer( playerid, GetPVarInt(playerid, "SpectatingWatch") );
			SetPlayerInterior( playerid, GetPlayerInterior( GetPVarInt(playerid, "SpectatingWatch") ) );
			SetPlayerVirtualWorld( playerid, GetPlayerVirtualWorld( GetPVarInt(playerid, "SpectatingWatch") ) );
		}	
	}
	return 1;
}	

forward Float: GetPlayerSpeed(playerid);
public Float: GetPlayerSpeed(playerid)
{
	new Float: fVelocity[3];
	GetPlayerVelocity(playerid, fVelocity[0], fVelocity[1], fVelocity[2]);
	return floatsqroot((fVelocity[0] * fVelocity[0]) + (fVelocity[1] * fVelocity[1]) + (fVelocity[2] * fVelocity[2])) * 100;
}

stock SpectatePlayer(playerid, giveplayerid)
{
	if(IsPlayerConnected(giveplayerid)) {
		if( InsideTut{giveplayerid} >= 1 ) {
			SendClientMessageEx(playerid, COLOR_WHITE, "NOTE: This person is in the tutorial. Please consider this before assuming that they're air-breaking.");
		}
		if(PlayerInfo[giveplayerid][pAccountRestricted]) SendClientMessageEx(playerid, COLOR_WHITE, "NOTE: This person has their account restricted. Please consider this before assuming that they're health hacking.");
		if(Spectating[playerid] == 0) {
			new Float: pPositions[3];
			GetPlayerPos(playerid, pPositions[0], pPositions[1], pPositions[2]);
			SetPVarFloat(playerid, "SpecPosX", pPositions[0]);
			SetPVarFloat(playerid, "SpecPosY", pPositions[1]);
			SetPVarFloat(playerid, "SpecPosZ", pPositions[2]);
			SetPVarInt(playerid, "SpecInt", GetPlayerInterior(playerid));
			SetPVarInt(playerid, "SpecVW", GetPlayerVirtualWorld(playerid));
			if(IsPlayerInAnyVehicle(giveplayerid)) {
				TogglePlayerSpectating(playerid, true);
				new carid = GetPlayerVehicleID( giveplayerid );
				PlayerSpectateVehicle( playerid, carid );
				SetPlayerInterior( playerid, GetPlayerInterior( giveplayerid ) );
				SetPlayerVirtualWorld( playerid, GetPlayerVirtualWorld( giveplayerid ) );
			}
			else if(InsidePlane[giveplayerid] != INVALID_VEHICLE_ID) {
				TogglePlayerSpectating(playerid, true);
				PlayerSpectateVehicle(playerid, InsidePlane[giveplayerid]);
				SetPlayerInterior(playerid, GetPlayerInterior(giveplayerid));
				SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(giveplayerid));
			}
			else {
				for(new i = 0; i < 2; i++) {
					TogglePlayerSpectating(playerid, true);
					PlayerSpectatePlayer( playerid, giveplayerid );
					SetPlayerInterior( playerid, GetPlayerInterior( giveplayerid ) );
					SetPlayerVirtualWorld( playerid, GetPlayerVirtualWorld( giveplayerid ) );
				}	
			}
			GettingSpectated[giveplayerid] = playerid;
			if(Spectate[playerid] != giveplayerid) SpecTime[playerid] = gettime();
			Spectate[playerid] = giveplayerid;
			Spectating[playerid] = 1;
		}
		else {
			if(IsPlayerInAnyVehicle(giveplayerid)) {
				TogglePlayerSpectating(playerid, true);
				new carid = GetPlayerVehicleID( giveplayerid );
				PlayerSpectateVehicle( playerid, carid );
				SetPlayerInterior( playerid, GetPlayerInterior( giveplayerid ) );
				SetPlayerVirtualWorld( playerid, GetPlayerVirtualWorld( giveplayerid ) );
			}
			else if(InsidePlane[giveplayerid] != INVALID_VEHICLE_ID) {
				TogglePlayerSpectating(playerid, true);
				PlayerSpectateVehicle(playerid, InsidePlane[giveplayerid]);
				SetPlayerInterior(playerid, GetPlayerInterior(giveplayerid));
				SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(giveplayerid));
			}
			else {
				for(new i = 0; i < 2; i++) {
					TogglePlayerSpectating(playerid, true);
					PlayerSpectatePlayer( playerid, giveplayerid );
					SetPlayerInterior( playerid, GetPlayerInterior( giveplayerid ) );
					SetPlayerVirtualWorld( playerid, GetPlayerVirtualWorld( giveplayerid ) );
				}	
			}
			GettingSpectated[Spectate[playerid]] = INVALID_PLAYER_ID;
			GettingSpectated[giveplayerid] = playerid;
			if(Spectate[playerid] != giveplayerid) SpecTime[playerid] = gettime();
			Spectate[playerid] = giveplayerid;
			Spectating[playerid] = 1;
		}
		new string[64];
		format(string, sizeof(string), "You are spectating %s (ID: %d).", GetPlayerNameEx(giveplayerid), giveplayerid);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
	}	
	return 1;
}

forward ForceSpawn(playerid);
public ForceSpawn(playerid)
{
	SpawnPlayer(playerid);
	return 1;
}

stock MoveAutomaticGate(playerid, gateid)
{
	MoveDynamicObject(GateInfo[gateid][gGATE], GateInfo[gateid][gPosXM], GateInfo[gateid][gPosYM], GateInfo[gateid][gPosZM], GateInfo[gateid][gSpeed], GateInfo[gateid][gRotXM], GateInfo[gateid][gRotYM], GateInfo[gateid][gRotZM]);
	GateInfo[gateid][gStatus] = 1;
	switch(GateInfo[gateid][gTimer])
	{
		case 1: SetTimerEx("AutomaticGateTimerClose", 3000, false, "ii", playerid, gateid);
		case 2: SetTimerEx("AutomaticGateTimerClose", 5000, false, "ii", playerid, gateid);
		case 3: SetTimerEx("AutomaticGateTimerClose", 8000, false, "ii", playerid, gateid);
		case 4: SetTimerEx("AutomaticGateTimerClose", 10000, false, "ii", playerid, gateid);
		default: SetTimerEx("AutomaticGateTimerClose", 3000, false, "ii", playerid, gateid);
	}
	return 1;
}

forward AutomaticGateTimer(playerid, gateid);
public AutomaticGateTimer(playerid, gateid)
{
	if(GateInfo[gateid][gLocked] == 0)
	{
		if(GateInfo[gateid][gStatus] == 0 && IsPlayerInRangeOfPoint(playerid, GateInfo[gateid][gRange], GateInfo[gateid][gPosX], GateInfo[gateid][gPosY], GateInfo[gateid][gPosZ]))
		{
			if(GateInfo[gateid][gFamilyID] != -1 && PlayerInfo[playerid][pFMember] == GateInfo[gateid][gFamilyID]) MoveAutomaticGate(playerid, gateid);
			else if(GateInfo[gateid][gGroupID] != -1 && (0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS) && PlayerInfo[playerid][pMember] == GateInfo[gateid][gGroupID]) MoveAutomaticGate(playerid, gateid);
			else if(GateInfo[gateid][gAllegiance] != 0 && GateInfo[gateid][gGroupType] != 0 && (0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS) && arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance] == GateInfo[gateid][gAllegiance] && arrGroupData[PlayerInfo[playerid][pMember]][g_iGroupType] == GateInfo[gateid][gGroupType]) MoveAutomaticGate(playerid, gateid);
			else if(GateInfo[gateid][gAllegiance] != 0 && GateInfo[gateid][gGroupType] == 0 && (0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS) && arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance] == GateInfo[gateid][gAllegiance]) MoveAutomaticGate(playerid, gateid);
			else if(GateInfo[gateid][gAllegiance] == 0 && GateInfo[gateid][gGroupType] != 0 && (0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS) && arrGroupData[PlayerInfo[playerid][pMember]][g_iGroupType] == GateInfo[gateid][gGroupType]) MoveAutomaticGate(playerid, gateid);
			else MoveAutomaticGate(playerid, gateid);
		}
		SetTimerEx("AutomaticGateTimer", 1000, false, "ii", playerid, gateid);
	}
	else
	{
		if(GateInfo[gateid][gStatus] == 1 && !IsPlayerInRangeOfPoint(playerid, GateInfo[gateid][gRange], GateInfo[gateid][gPosXM], GateInfo[gateid][gPosYM], GateInfo[gateid][gPosZM]))
		{
			MoveDynamicObject(GateInfo[gateid][gGATE], GateInfo[gateid][gPosX], GateInfo[gateid][gPosY], GateInfo[gateid][gPosZ], GateInfo[gateid][gSpeed], GateInfo[gateid][gRotX], GateInfo[gateid][gRotY], GateInfo[gateid][gRotZ]);
			SetTimerEx("AutomaticGateTimer", 1000, false, "ii", playerid, gateid);
			GateInfo[gateid][gStatus] = 0;
			return 1;
		}
	}
	return 1;
}

forward AutomaticGateTimerClose(playerid, gateid);
public AutomaticGateTimerClose(playerid, gateid)
{
	if(GateInfo[gateid][gLocked] == 0)
	{
		if(GateInfo[gateid][gStatus] == 1 && !IsPlayerInRangeOfPoint(playerid, GateInfo[gateid][gRange], GateInfo[gateid][gPosXM], GateInfo[gateid][gPosYM], GateInfo[gateid][gPosZM]))
		{
			MoveDynamicObject(GateInfo[gateid][gGATE], GateInfo[gateid][gPosX], GateInfo[gateid][gPosY], GateInfo[gateid][gPosZ], GateInfo[gateid][gSpeed], GateInfo[gateid][gRotX], GateInfo[gateid][gRotY], GateInfo[gateid][gRotZ]);
			SetTimerEx("AutomaticGateTimer", 1000, false, "ii", playerid, gateid);
			GateInfo[gateid][gStatus] = 0;
			return 1;
		}
		switch(GateInfo[gateid][gTimer])
		{
			case 1: SetTimerEx("AutomaticGateTimerClose", 3000, false, "ii", playerid, gateid);
			case 2: SetTimerEx("AutomaticGateTimerClose", 5000, false, "ii", playerid, gateid);
			case 3: SetTimerEx("AutomaticGateTimerClose", 8000, false, "ii", playerid, gateid);
			case 4: SetTimerEx("AutomaticGateTimerClose", 10000, false, "ii", playerid, gateid);
			default: SetTimerEx("AutomaticGateTimerClose", 3000, false, "ii", playerid, gateid);
		}
	}
	else
	{
		if(GateInfo[gateid][gStatus] == 1 && !IsPlayerInRangeOfPoint(playerid, GateInfo[gateid][gRange], GateInfo[gateid][gPosXM], GateInfo[gateid][gPosYM], GateInfo[gateid][gPosZM]))
		{
			MoveDynamicObject(GateInfo[gateid][gGATE], GateInfo[gateid][gPosX], GateInfo[gateid][gPosY], GateInfo[gateid][gPosZ], GateInfo[gateid][gSpeed], GateInfo[gateid][gRotX], GateInfo[gateid][gRotY], GateInfo[gateid][gRotZ]);
			SetTimerEx("AutomaticGateTimer", 1000, false, "ii", playerid, gateid);
			GateInfo[gateid][gStatus] = 0;
			return 1;
		}
	}
	return 1;
}

forward LoginCheck(playerid);
public LoginCheck(playerid)
{
	if(gPlayerLogged{playerid} == 0 && IsPlayerConnected(playerid))
	{
		new string[128];
		format(string, sizeof(string), "%s(%d) [%s] has timed out of the login screen.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid));
		Log("logs/security.log", string);
		SendClientMessage(playerid, COLOR_WHITE, "SERVER: Login timeout - you must login within 60 seconds!");
		ShowPlayerDialog(playerid, -1, DIALOG_STYLE_MSGBOX, "", "", "", "");
		SetTimerEx("KickEx", 1000, 0, "i", playerid);
	}
	return 1;
}

stock ShowLoginDialogs(playerid, index)
{
	new string[128];
	switch(index)
	{
		case 0:
		{
			ShowPlayerDialog(playerid, DIALOG_CHANGEPASS2, DIALOG_STYLE_INPUT, "Password Change Required!", "Please enter a new password for your account.", "Change", "Exit" );
			if(PassComplexCheck) ShowPlayerDialog(playerid, DIALOG_CHANGEPASS2, DIALOG_STYLE_INPUT, "Password Change Required!", "Please enter a new password for your account.\n\n\
			- You can't select a password that's below 8 or above 64 characters\n\
			- Your password must contain a combination of letters, numbers and special characters.\n\
			- Invalid Character: %", "Change", "Exit" );
		}
		case 1: ShowPlayerDialog(playerid, REGISTERMONTH, DIALOG_STYLE_LIST, "{FF0000}Which month was your character born?", "January\nFebruary\nMarch\nApril\nMay\nJune\nJuly\nAugust\nSeptember\nOctober\nNovember\nDecember", "Submit", "");
		case 4: ShowPlayerDialog(playerid, PMOTDNOTICE, DIALOG_STYLE_MSGBOX, "Notice", pMOTD, "Dismiss", "");
		case 5:
		{
			format(string, sizeof(string), "You have recieved {FFD700}%s{A9C4E4} credits! Use /shophelp for more information.", number_format(PlayerInfo[playerid][pReceivedCredits]));
			ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Credits Received!", string, "Close", "");

			new szLog[128];
			format(szLog, sizeof(szLog), "[ISSUED] [User: %s(%i)] [IP: %s] [Credits: %s]", GetPlayerNameEx(playerid), PlayerInfo[playerid][pId], GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pReceivedCredits]));
			Log("logs/logincredits.log", szLog), print(szLog);

			PlayerInfo[playerid][pReceivedCredits] = 0;
		}
	}
	return 1;
}

forward TeleportToShop(playerid);
public TeleportToShop(playerid)
{
	if(GetPVarType(playerid, "PlayerCuffed") || GetPVarType(playerid, "Injured") || GetPVarType(playerid, "IsFrozen") || PlayerInfo[playerid][pHospital] || PlayerInfo[playerid][pJailTime] > 0 || GetPVarInt(playerid, "EventToken") == 1 || GetPVarInt(playerid, "IsInArena") >= 0 || !GetPVarInt(playerid, "ShopTP"))
		return DeletePVar(playerid, "ShopTP"), SendClientMessage(playerid, COLOR_GRAD2, "SERVER: Shop Teleportation has been cancelled.");
	if(gettime() - LastShot[playerid] < 30) return DeletePVar(playerid, "ShopTP"), SendClientMessageEx(playerid, COLOR_GRAD2, "You have been injured within the last 30 seconds, you will not be teleported to the shop.");
	if(GetPVarInt(playerid, "ShopTP") == 1)
	{
		SetPlayerPos(playerid, 2957.9670, -1459.4045, 10.8092);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		TogglePlayerControllable(playerid, 1);
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "If you wish to leave the shop, type /leaveshop to return to your previous location.");
		SendClientMessageEx(playerid, COLOR_ORANGE, "Note{ffffff}: You will {ff0000}not{ffffff} be able to return to your previous location upon purchasing a vehicle.");
	}
	return 1;
}

forward HidePlayerTextDraw(playerid, PlayerText:txd);
public HidePlayerTextDraw(playerid, PlayerText:txd) return PlayerTextDrawHide(playerid, txd);

forward LoginCheckEx(i);
public LoginCheckEx(i)
{
	new ok = 0, count = 0, Float: pos[3], string[128];
	if(gPlayerLogged{i} == 0 && IsPlayerConnected(i))
	{
		GetPlayerPos(i, pos[0], pos[1], pos[2]);
		for(new x; x < sizeof(JoinCameraPosition); x++)
		{
			if(pos[0] != JoinCameraPosition[x][0] && pos[1] != JoinCameraPosition[x][1] && pos[2] != JoinCameraPosition[x][2] && (count == 8))
			{
				format(string, sizeof(string), "%s(%d) [%s] has moved from the login screen position.", GetPlayerNameEx(i), GetPlayerSQLId(i), GetPlayerIpEx(i));
				Log("logs/security.log", string);
				SendClientMessage(i, COLOR_WHITE, "SERVER: You have moved while being in the login screen!");
				ShowPlayerDialog(i, -1, DIALOG_STYLE_MSGBOX, "", "", "", "");
				SetTimerEx("KickEx", 1000, 0, "i", i);
				ok = 1;
			}
			count++;
		}
		
		if(ok == 0)
		{
			SetTimerEx("LoginCheckEx", 5000, 0, "i", i);
		}
	}
	return true;
}

stock IsWeaponHandgun(weaponid) {
	switch(weaponid) {
		case 2..8: return true;
		case 10..24: return true;
		default: return false;
	}
	return false;
}

stock IsWeaponPrimary(weaponid) {
	switch(weaponid) {
		case 25..34: return true;
		default: return false;
	}
	return false;
}

forward DG_AutoReset();
public DG_AutoReset()
{
	for(new i = 0; i < sizeof(dgVar); i++)
	{
		if(dgVar[dgItems:i][0] == 1 && dgVar[dgItems:i][1] == 0)
		{
			dgVar[dgItems:i][1] += dgAmount;
		}
	}
}

stock GetVehicleRelativePos(vehicleid, &Float:x, &Float:y, &Float:z, Float:xoff=0.0, Float:yoff=0.0, Float:zoff=0.0)
{
    new Float:rot;
    GetVehicleZAngle(vehicleid, rot);
    rot = 360 - rot;    // Making the vehicle rotation compatible with pawns sin/cos
	GetVehiclePos(vehicleid, x, y, z);
    
    x = floatsin(rot,degrees) * yoff + floatcos(rot,degrees) * xoff + x;
    y = floatcos(rot,degrees) * yoff - floatsin(rot,degrees) * xoff + y;
    z = zoff + z;

    /*
       where xoff/yoff/zoff are the offsets relative to the vehicle
       x/y/z then are the coordinates of the point with the given offset to the vehicle
       xoff = 1.0 would e.g. point to the right side of the vehicle, -1.0 to the left, etc.
    */
}

TriggerVehicleAlarm(triggerid, ownerid, vehicleid)
{
	new szMessage[128], szCarLocation[MAX_ZONE_NAME], slot = GetPlayerVehicle(ownerid, vehicleid), Float: CarPos[3], engine, lights, alarm, doors, bonnet, boot, objective;
	if(PlayerVehicleInfo[ownerid][slot][pvAlarm] > 0) {
		ProxDetector(30.0, triggerid, "(( A vehicle alarm has been triggered. ))", COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		GetVehiclePos(vehicleid, CarPos[0], CarPos[1], CarPos[2]);
		Get3DZone(CarPos[0], CarPos[1], CarPos[2], szCarLocation, sizeof(szCarLocation));
		format(szMessage, sizeof(szMessage), "SMS: Your %s(%d)'s Alarm at %s has been triggered, call 911, Sender: Vehicle Security Company", VehicleName[PlayerVehicleInfo[ownerid][slot][pvModelId] - 400], vehicleid, szCarLocation);
		SendClientMessageEx(ownerid, COLOR_YELLOW, szMessage);
		PlayerVehicleInfo[ownerid][slot][pvAlarmTriggered] = 1;
		GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
		SetVehicleParamsEx(vehicleid,engine,lights,VEHICLE_PARAMS_ON,doors,bonnet,boot,objective);
	}
}

ClearCheckpoint(playerid) {
	TaxiAccepted[playerid] = INVALID_PLAYER_ID;
	EMSAccepted[playerid] = INVALID_PLAYER_ID;
	BusAccepted[playerid] = INVALID_PLAYER_ID;
	MedicAccepted[playerid] = INVALID_PLAYER_ID;
	MechanicCallTime[playerid] = 0;
	TaxiCallTime[playerid] = 0;
	BusCallTime[playerid] = 0;

	DeletePVar(playerid, "DV_TrackCar");
	DeletePVar(playerid, "TrackVehicleBurglary");
	if(GetPVarType(playerid, "DeliveringVehicleTime")) {
		if(GetPVarType(playerid, "LockPickVehicleSQLId")) {
			new szQuery[128];
			format(szQuery, sizeof(szQuery), "UPDATE `vehicles` SET `pvFuel` = %0.5f WHERE `id` = '%d' AND `sqlID` = '%d'", VehicleFuel[GetPVarInt(playerid, "LockPickVehicle")], GetPVarInt(playerid, "LockPickVehicleSQLId"), GetPVarInt(playerid, "LockPickPlayerSQLId"));
			mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
			DeletePVar(playerid, "LockPickVehicleSQLId");
			DeletePVar(playerid, "LockPickPlayerSQLId");
			DeletePVar(playerid, "LockPickPlayerName");
			DestroyVehicle(GetPVarInt(playerid, "LockPickVehicle"));
		}
		else {
			new slot = GetPlayerVehicle(GetPVarInt(playerid, "LockPickPlayer"), GetPVarInt(playerid, "LockPickVehicle"));
			PlayerVehicleInfo[GetPVarInt(playerid, "LockPickPlayer")][slot][pvBeingPickLocked] = 0;
			PlayerVehicleInfo[GetPVarInt(playerid, "LockPickPlayer")][slot][pvBeingPickLockedBy] = INVALID_PLAYER_ID;
		}
		DeletePVar(playerid, "DeliveringVehicleTime");
		DeletePVar(playerid, "LockPickVehicle");
		DeletePVar(playerid, "LockPickPlayer");
	}
    DeletePVar(playerid, "TrackCar");
	DeletePVar(playerid, "Pizza");
	DeletePVar(playerid, "Packages");
	DeletePVar(playerid, "hFind");
	DeletePVar(playerid, "pDTest");
	DisablePlayerCheckpoint(playerid);
	gPlayerCheckpointStatus[playerid] = CHECKPOINT_NONE;
	return;
}

UpdateVLPTextDraws(playerid, vehicleid, TYPE = 0) {
	new tdMessage[9 + MAX_ZONE_NAME], tdCarLocation[MAX_ZONE_NAME], Float:CarPos[3];
	GetVehiclePos(vehicleid, CarPos[0], CarPos[1], CarPos[2]);
	Get3DZone(CarPos[0], CarPos[1], CarPos[2], tdCarLocation, sizeof(tdCarLocation));
	format(tdMessage, sizeof(tdMessage), "%s Robbery", tdCarLocation);
	PlayerTextDrawSetString(playerid, VLPTextDraws[playerid][0], tdMessage);
	switch(TYPE) {
		case 0: {
			PlayerTextDrawSetString(playerid, VLPTextDraws[playerid][0], "Attempting to lock pick vehicle");
			format(tdMessage, sizeof(tdMessage), "%s", ConvertTimeS(GetPVarInt(playerid, "LockPickCountdown"), 1));
			PlayerTextDrawSetString(playerid, VLPTextDraws[playerid][3], tdMessage);
		}
		case 1: {
			PlayerTextDrawSetString(playerid, VLPTextDraws[playerid][0], "Attempting to crack the trunk");
			format(tdMessage, sizeof(tdMessage), "%s", ConvertTimeS(GetPVarInt(playerid, "CrackTrunkCountdown"), 1));
			PlayerTextDrawSetString(playerid, VLPTextDraws[playerid][3], tdMessage);
		}
		case 2: {
			PlayerTextDrawSetString(playerid, VLPTextDraws[playerid][0], "Deliver Vehicle");
			format(tdMessage, sizeof(tdMessage), "00:%d", GetPVarInt(playerid, "DeliveringVehicleTime"));
			PlayerTextDrawSetString(playerid, VLPTextDraws[playerid][3], tdMessage);
		}
	}
}

DestroyVLPTextDraws(playerid) {
	for(new i = 0; i < 4; i++)
		PlayerTextDrawDestroy(playerid, VLPTextDraws[playerid][i]);
}

CheckPasswordComplexity(const password[])
{
	if(!(8 <= strlen(password) <= 64)) return 0;
	new i = 0, containsletters, containsnumbers, containsspecial;
	while(password[i] != '\0')
	{
		if('a' <= password[i] <= 'z') containsletters = 1;
		else if('A' <= password[i] <= 'Z') containsletters = 1;
		else if('0' <= password[i] <= '9') containsnumbers = 1;
		// !"#$%&'()*+,-./ :;<=>?@[\]^_`  {|}~
		else if(33 <= password[i] <= 47 || 58 <= password[i] <= 64 || 91 <= password[i] <= 96 || 123 <= password[i] <= 126) containsspecial = 1;
		if(containsletters && containsnumbers && containsspecial) break;
		i++;
	}
	if(!containsletters || !containsnumbers || !containsspecial) return 0;
	return 1;
}

//Dom
forward Anti_Rapidfire();
public Anti_Rapidfire()
{
	new string[128];
	foreach(new i: Player) 
	{
		new weaponid = GetPlayerWeapon(i);
		if(((weaponid == 24 || weaponid == 25 || weaponid == 26) && PlayerShots[i] > 10)/* || (weaponid == 31 && PlayerShots[i] > 20)*/)
		{
			format(string, sizeof(string), "%s(%d) (%d): %d shots in 1 second -- Weapon ID: %d", GetPlayerNameEx(i), i, GetPVarInt(i, "pSQLID"), PlayerShots[i], weaponid);
			Log("logs/rapid.log", string);

			SetPVarInt(i, "MaxRFWarn", GetPVarInt(i, "MaxRFWarn")+1);
			format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s (ID: %d) may be rapidfire hacking. %d/%d warnings", GetPlayerNameEx(i), i, GetPVarInt(i, "MaxRFWarn"), MAX_RF_WARNS);
			ABroadCast(COLOR_YELLOW, string, 2);
			if(GetPVarInt(i, "MaxRFWarn") >= MAX_RF_WARNS)
			{
				format(string, sizeof(string), "AdmCmd: %s has been banned, reason: Rapidfire Hacking. %d/%d warnings", GetPlayerNameEx(i), GetPVarInt(i, "MaxRFWarn"), MAX_RF_WARNS);
				ABroadCast(COLOR_LIGHTRED, string, 2);
				DeletePVar(i, "MaxRFWarn");
				format(string, sizeof(string), "AdmCmd: %s(%d) (IP:%s) was banned, reason: Rapidfire Hacking.", GetPlayerNameEx(i), GetPlayerSQLId(i), GetPlayerIpEx(i));
				PlayerInfo[i][pBanned] = 3;
				Log("logs/ban.log", string);
				SystemBan(i, "[System] (Rapidfire Hacking)");
				MySQLBan(GetPlayerSQLId(i), GetPlayerIpEx(i), "Rapidfire Hacking", 1, "System");
				Kick(i);
				TotalAutoBan++;
			}
		}
		PlayerShots[i] = 0;
	}
	return 1;
}

stock FindPlayerVehicleWithSQLId(ownerid, sqlid)
{
	new
		i = 0;
	while (i < MAX_PLAYERVEHICLES && PlayerVehicleInfo[ownerid][i][pvSlotId] != sqlid)
	{
		i++;
	}
	if (i == MAX_PLAYERVEHICLES) return -1;
	return i;
}

stock SaveGarages()
{
	for(new i = 0; i < MAX_GARAGES; i++)
	{
		SaveGarage(i);
	}
	return 1;
}

forward ClearAnims(playerid);
public ClearAnims(playerid)
{
	ClearAnimations(playerid);
}

CheckPlayerFacing(iTargetID, Float:x, Float:y, Float:z, Float:range)
{
	new Float:camx,Float:camy,Float:camz,Float:fvecx,Float:fvecy,Float:fvecz;
	GetPlayerCameraPos(iTargetID, camx, camy, camz);
	GetPlayerCameraFrontVector(iTargetID, fvecx, fvecy, fvecz);
	return (range >= DistanceCameraTargetToLocation(camx, camy, camz, x, y, z, fvecx, fvecy, fvecz));
}

stock GetFirstName(playerid)
{
	new name[MAX_PLAYER_NAME], underscore;
	GetPlayerName(playerid, name, MAX_PLAYER_NAME);
	underscore = strfind(name, "_");
	strdel(name, underscore, MAX_PLAYER_NAME);
	return name;
}

stock GetLastName(playerid)
{
	new name[MAX_PLAYER_NAME], underscore;
	GetPlayerName(playerid, name, MAX_PLAYER_NAME);
	underscore = strfind(name, "_");
	strdel(name, 0, underscore+1);
	return name;
}

GetWeekday(display = 0, day = 0, month = 0, year = 0)
{
	if(!day) getdate(year, month, day);

	new weekday_str[10], j, e;

	if(month <= 2)
	{
		month += 12;
		--year;
	}

	j = year % 100;
	e = year / 100;
	
	if(display == 1)
	{
		switch((day + (month+1)*26/10 + j + j/4 + e/4 - 2*e) % 7)
		{
			case 0: weekday_str = "sat";
			case 1: weekday_str = "sun";
			case 2: weekday_str = "mon";
			case 3: weekday_str = "tues";
			case 4: weekday_str = "wed";
			case 5: weekday_str = "thurs";
			case 6: weekday_str = "fri";
		}
	}
	else
	{
		switch((day + (month+1)*26/10 + j + j/4 + e/4 - 2*e) % 7)
		{
			case 0: weekday_str = "saturday";
			case 1: weekday_str = "sunday";
			case 2: weekday_str = "monday";
			case 3: weekday_str = "tuesday";
			case 4: weekday_str = "wednesday";
			case 5: weekday_str = "thursday";
			case 6: weekday_str = "friday";
		}
	}

	return weekday_str;
}

/*ShowPlayerHolsterDialog(playerid)
{
	new szString[128];
	
	for(new i = 0; i < 12; i++)
	{
		if(PlayerInfo[playerid][pGuns][i] == 0 && i == 0)
		{
			format(szString, sizeof(szString), "%s\n", ReturnWeaponName(PlayerInfo[playerid][pGuns][i]));
		}
		else if(PlayerInfo[playerid][pGuns][i] != 0 && i > 0)
		{
			format(szString, sizeof(szString), "%s%s\n", szString, ReturnWeaponName(PlayerInfo[playerid][pGuns][i]));
		}
		else 
		{
			format(szString, sizeof(szString), "%sN/A\n", szString);
		}
	}
	return ShowPlayerDialog(playerid, DIALOG_HOLSTER, DIALOG_STYLE_LIST, "Holster Menu", szString, "Select", "Cancel"); 
}*/

stock randomString(strDest[], strLen = 10)
{
	while(strLen--) strDest[strLen] = random(2) ? (random(26) + (random(2) ? 'a' : 'A')) : (random(10) + '0');
}

IsPlayerInArea(playerid, Float:minx, Float:maxx, Float:miny, Float:maxy)
{
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    if (x > minx && x < maxx && y > miny && y < maxy) return 1;
    return 0;
}