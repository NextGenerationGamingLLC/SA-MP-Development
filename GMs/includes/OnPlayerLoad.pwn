/*
    	 		 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
				| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
				| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
				| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
				| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
				| $$\  $$$| $$  \ $$        | $$  \ $$| $$
				| $$ \  $$|  $$$$$$/        | $$  | $$| $$
				|__/  \__/ \______/         |__/  |__/|__/

//--------------------------------[ONPLAYERLOAD.PWN]--------------------------------


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
 
forward OnPlayerLoad(playerid);
public OnPlayerLoad(playerid)
{
	new string[128];
	if(PlayerInfo[playerid][pOnline] != 0)
	{
	    if(PlayerInfo[playerid][pOnline] != servernumber)
	    {
		    SendClientMessageEx(playerid, COLOR_WHITE, "SERVER: This account is already online!");
			SetTimerEx("KickEx", 1000, 0, "i", playerid);
			return 1;
		}
	}

	GetPlayerIp(playerid, PlayerInfo[playerid][pIP], 16);
	if( PlayerInfo[playerid][pPermaBanned] == 3 || PlayerInfo[playerid][pBanned] >= 1 )
	{
		format(string, sizeof(string), "WARNING: %s (IP:%s) tried to login whilst banned and has been auto-banned.", GetPlayerNameEx( playerid ), PlayerInfo[playerid][pIP] );
		ABroadCast(COLOR_YELLOW, string, 2);
		SendClientMessageEx(playerid, COLOR_RED, "Your account is banned! You can appeal this at http://www.ng-gaming.net/forums");
		SystemBan(playerid, "[System] (Tried to login while banned)");
		Log("logs/ban.log", string);
		SetTimerEx("KickEx", 1000, 0, "i", playerid);
		return 1;
	}

	if(PlayerInfo[playerid][pDisabled] != 0)
	{
		if( PlayerInfo[playerid][pBanAppealer] > 1) PlayerInfo[playerid][pBanAppealer] = 0;
		if( PlayerInfo[playerid][pShopTech] > 1) PlayerInfo[playerid][pShopTech] = 0;
		if( PlayerInfo[playerid][pUndercover] > 1) PlayerInfo[playerid][pUndercover] = 0;
		if( PlayerInfo[playerid][pFactionModerator] > 1) PlayerInfo[playerid][pFactionModerator] = 0;
		if( PlayerInfo[playerid][pGangModerator] > 1) PlayerInfo[playerid][pGangModerator] = 0;
		if( PlayerInfo[playerid][pPR] > 1) PlayerInfo[playerid][pPR] = 0;
		SendClientMessageEx(playerid, COLOR_WHITE, "SERVER: This account is disabled!");
		SetTimerEx("KickEx", 1000, 0, "i", playerid);
		return 1;
	}

	if((PlayerInfo[playerid][pMember] != INVALID_GROUP_ID && arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance] == 2) && PlayerInfo[playerid][pNation] == 0)
	{
		PlayerInfo[playerid][pNation] = 1;
	}	
	TotalLogin++;

	SetPlayerScore(playerid, PlayerInfo[playerid][pLevel]);
	if(PlayerInfo[playerid][pReg] == 0)
	{
		for(new v = 0; v < MAX_PLAYERVEHICLES; v++)
		{
			PlayerVehicleInfo[playerid][v][pvModelId] = 0;
			PlayerVehicleInfo[playerid][v][pvPosX] = 0.0;
			PlayerVehicleInfo[playerid][v][pvPosY] = 0.0;
			PlayerVehicleInfo[playerid][v][pvPosZ] = 0.0;
			PlayerVehicleInfo[playerid][v][pvPosAngle] = 0.0;
			PlayerVehicleInfo[playerid][v][pvLock] = 0;
			PlayerVehicleInfo[playerid][v][pvLocked] = 0;
			PlayerVehicleInfo[playerid][v][pvPaintJob] = -1;
			PlayerVehicleInfo[playerid][v][pvColor1] = 0;
			PlayerVehicleInfo[playerid][v][pvImpounded] = 0;
			PlayerVehicleInfo[playerid][v][pvSpawned] = 0;
			PlayerVehicleInfo[playerid][v][pvColor2] = 0;
			PlayerVehicleInfo[playerid][v][pvPrice] = 0;
			PlayerVehicleInfo[playerid][v][pvTicket] = 0;
			PlayerVehicleInfo[playerid][v][pvWeapons][0] = 0;
			PlayerVehicleInfo[playerid][v][pvWeapons][1] = 0;
			PlayerVehicleInfo[playerid][v][pvWeapons][2] = 0;
			PlayerVehicleInfo[playerid][v][pvWepUpgrade] = 0;
			PlayerVehicleInfo[playerid][v][pvFuel] = 0.0;
			PlayerVehicleInfo[playerid][v][pvAllowedPlayerId] = INVALID_PLAYER_ID;
			PlayerVehicleInfo[playerid][v][pvPark] = 0;
			ListItemReleaseId[playerid][v] = -1;
			PlayerVehicleInfo[playerid][v][pvDisabled] = 0;
			PlayerVehicleInfo[playerid][v][pvPlate] = 0;
			PlayerVehicleInfo[playerid][v][pvVW] = 0;
			PlayerVehicleInfo[playerid][v][pvInt] = 0;
			ListItemTrackId[playerid][v] = -1;
			for(new m = 0; m < MAX_MODS; m++)
			{
				PlayerVehicleInfo[playerid][v][pvMods][m] = 0;
			}
		}
		for(new v = 0; v < MAX_PLAYERTOYS; v++)
		{
			PlayerToyInfo[playerid][v][ptModelID] = 0;
			PlayerToyInfo[playerid][v][ptBone] = 0;
			PlayerToyInfo[playerid][v][ptTradable] = 0;
			PlayerToyInfo[playerid][v][ptPosX] = 0.0;
			PlayerToyInfo[playerid][v][ptPosY] = 0.0;
			PlayerToyInfo[playerid][v][ptPosZ] = 0.0;
			PlayerToyInfo[playerid][v][ptRotX] = 0.0;
			PlayerToyInfo[playerid][v][ptRotY] = 0.0;
			PlayerToyInfo[playerid][v][ptRotZ] = 0.0;
			PlayerToyInfo[playerid][v][ptScaleX] = 1.0;
			PlayerToyInfo[playerid][v][ptScaleY] = 1.0;
			PlayerToyInfo[playerid][v][ptScaleZ] = 1.0;
			PlayerToyInfo[playerid][v][ptSpecial] = 0;
		}

		PlayerInfo[playerid][pTokens] = 0;
		PlayerInfo[playerid][pSecureIP][0] = 0;
		PlayerInfo[playerid][pCrates] = 0;
		PlayerInfo[playerid][pOrder] = 0;
		PlayerInfo[playerid][pOrderConfirmed] = 0;
		PlayerInfo[playerid][pRacePlayerLaps] = 0;
		PlayerInfo[playerid][pSprunk] = 0;
		PlayerInfo[playerid][pSpraycan] = 0;
		PlayerInfo[playerid][pCigar] = 0;
		PlayerInfo[playerid][pConnectSeconds] = 0;
		PlayerInfo[playerid][pPayDayHad] = 0;
		PlayerInfo[playerid][pCDPlayer] = 0;
		PlayerInfo[playerid][pWins] = 0;
		PlayerInfo[playerid][pLoses] = 0;
		PlayerInfo[playerid][pTut] = 0;
		PlayerInfo[playerid][pWarns] = 0;
		PlayerInfo[playerid][pRope] = 0;
		PlayerInfo[playerid][pDice] = 0;
		PlayerInfo[playerid][pScrewdriver] = 0;
		PlayerInfo[playerid][pWantedLevel] = 0;
		PlayerInfo[playerid][pInsurance] = 0;
		PlayerInfo[playerid][pDutyHours] = 0;
		PlayerInfo[playerid][pAcceptedHelp] = 0;
		PlayerInfo[playerid][pAcceptReport] = 0;
		PlayerInfo[playerid][pShopTechOrders] = 0;
		PlayerInfo[playerid][pTrashReport] = 0;
		PlayerInfo[playerid][pGiftTime] = 0;
		PlayerInfo[playerid][pTicketTime] = 0;
		PlayerInfo[playerid][pServiceTime] = 0;
		PlayerInfo[playerid][pFirework] = 0;
		PlayerInfo[playerid][pBoombox] = 0;
		PlayerInfo[playerid][pCash] = 10000;
		PlayerInfo[playerid][pHunger] = 100;
		PlayerInfo[playerid][pLevel] = 1;
		PlayerInfo[playerid][pAdmin] = 0;
		PlayerInfo[playerid][pHelper] = 0;
		PlayerInfo[playerid][pSMod] = 0;
		PlayerInfo[playerid][pWatchdog] = 0;
		PlayerInfo[playerid][pBanned] = 0;
		PlayerInfo[playerid][pDisabled] = 0;
		PlayerInfo[playerid][pMuted] = 0;
		PlayerInfo[playerid][pRMuted] = 0;
		PlayerInfo[playerid][pRMutedTotal] = 0;
		PlayerInfo[playerid][pRMutedTime] = 0;
		PlayerInfo[playerid][pDMRMuted] = 0;
		PlayerInfo[playerid][pNMute] = 0;
		PlayerInfo[playerid][pNMuteTotal] = 0;
		PlayerInfo[playerid][pADMute] = 0;
		PlayerInfo[playerid][pADMuteTotal] = 0;
		PlayerInfo[playerid][pHelpMute] = 0;
		PlayerInfo[playerid][pVMutedTime] = 0;
		PlayerInfo[playerid][pVMuted] = 0;
		PlayerInfo[playerid][pRadio] = 0;
		PlayerInfo[playerid][pRadioFreq] = 0;
		PlayerInfo[playerid][pPermaBanned] = 0;
		PlayerInfo[playerid][pDonateRank] = 0;
		PlayerInfo[playerid][gPupgrade] = 0;
		PlayerInfo[playerid][pConnectHours] = 0;
		PlayerInfo[playerid][pReg] = 0;
		PlayerInfo[playerid][pSex] = 0;
		strcpy(PlayerInfo[playerid][pBirthDate], "0000-00-00", 64);
		PlayerInfo[playerid][pRingtone] = 0;
		PlayerInfo[playerid][pVIPM] = 0;
		PlayerInfo[playerid][pVIPMO] = 0;
		PlayerInfo[playerid][pVIPExpire] = 0;
		PlayerInfo[playerid][pGVip] = 0;
		PlayerInfo[playerid][pHydration] = 100;
		PlayerInfo[playerid][pDoubleEXP] = 0;
		PlayerInfo[playerid][pEXPToken] = 0;
		PlayerInfo[playerid][pExp] = 0;
		PlayerInfo[playerid][pAccount] = 0;
		PlayerInfo[playerid][pCrimes] = 0;
		PlayerInfo[playerid][pDeaths] = 0;
		PlayerInfo[playerid][pArrested] = 0;
		PlayerInfo[playerid][pPhoneBook] = 0;
		PlayerInfo[playerid][pLottoNr] = 0;
		PlayerInfo[playerid][pFishes] = 0;
		PlayerInfo[playerid][pBiggestFish] = 0;
		PlayerInfo[playerid][pJob] = 0;
		PlayerInfo[playerid][pJob2] = 0;
		PlayerInfo[playerid][pJob3] = 0;
		PlayerInfo[playerid][pPayCheck] = 0;
		PlayerInfo[playerid][pHeadValue] = 0;
		PlayerInfo[playerid][pJailTime] = 0;
		PlayerInfo[playerid][pWRestricted] = 0;
		PlayerInfo[playerid][pMats] = 0;
		PlayerInfo[playerid][pNation] = -1;
		PlayerInfo[playerid][pLeader] = INVALID_GROUP_ID;
		PlayerInfo[playerid][pMember] = INVALID_GROUP_ID;
		PlayerInfo[playerid][pBusiness] = INVALID_BUSINESS_ID;
		PlayerInfo[playerid][pDivision] = INVALID_DIVISION;
		PlayerInfo[playerid][pFMember] = INVALID_FAMILY_ID;
		PlayerInfo[playerid][pRank] = INVALID_RANK;
		PlayerInfo[playerid][pRenting] = INVALID_HOUSE_ID;
		PlayerInfo[playerid][pDetSkill] = 0;
		PlayerInfo[playerid][pSexSkill] = 0;
		PlayerInfo[playerid][pBoxSkill] = 0;
		PlayerInfo[playerid][pLawSkill] = 0;
		PlayerInfo[playerid][pMechSkill] = 0;
		PlayerInfo[playerid][pTruckSkill] = 0;
		PlayerInfo[playerid][pDrugsSkill] = 0;
		PlayerInfo[playerid][pArmsSkill] = 0;
		PlayerInfo[playerid][pSmugSkill] = 0;
		PlayerInfo[playerid][pFishSkill] = 0;
		PlayerInfo[playerid][pSHealth] = 0.0;
		PlayerInfo[playerid][pHealth] = 50.0;
		PlayerInfo[playerid][pCheckCash] = 0;
		PlayerInfo[playerid][pChecks] = 0;
		PlayerInfo[playerid][pWeedObject] = 0;
		PlayerInfo[playerid][pWSeeds] = 0;
		PlayerInfo[playerid][pWarrant][0] = 0;
		PlayerInfo[playerid][pContractBy][0] = 0;
		PlayerInfo[playerid][pContractDetail] = 0;
		PlayerInfo[playerid][pJudgeJailTime] = 0;
		PlayerInfo[playerid][pJudgeJailType] = 0;
		PlayerInfo[playerid][pBeingSentenced] = 0;
		PlayerInfo[playerid][pProbationTime] = 0;
		PlayerInfo[playerid][pModel] = 299;
		PlayerInfo[playerid][pPnumber] = 0;
		PlayerInfo[playerid][pPhousekey] = INVALID_HOUSE_ID;
		PlayerInfo[playerid][pPhousekey2] = INVALID_HOUSE_ID;
		PlayerInfo[playerid][pPhousekey3] = INVALID_HOUSE_ID;
		PlayerInfo[playerid][pCarLic] = 1;
		PlayerInfo[playerid][pFlyLic] = 0;
		PlayerInfo[playerid][pBoatLic] = 0;
		PlayerInfo[playerid][pFishLic] = 1;
		PlayerInfo[playerid][pGunLic] = 1;
		PlayerInfo[playerid][pTaxiLicense] = 0;
		PlayerInfo[playerid][pBugged] = INVALID_GROUP_ID;
		PlayerInfo[playerid][pCallsAccepted] = 0;
		PlayerInfo[playerid][pPatientsDelivered] = 0;
		PlayerInfo[playerid][pLiveBanned] = 0;
		PlayerInfo[playerid][pFreezeBank] = 0;
		PlayerInfo[playerid][pFreezeHouse] = 0;
		PlayerInfo[playerid][pFreezeCar] = 0;
		strcpy(PlayerInfo[playerid][pAutoTextReply], "Nothing", 64);
		PlayerInfo[playerid][pLevel] = 1;
		PlayerInfo[playerid][pSHealth] = 0.0;
		PlayerInfo[playerid][pPnumber] = 0;
		PlayerInfo[playerid][pPhousekey] = INVALID_HOUSE_ID;
		PlayerInfo[playerid][pPhousekey2] = INVALID_HOUSE_ID;
		PlayerInfo[playerid][pPhousekey3] = INVALID_HOUSE_ID;
		PlayerInfo[playerid][pAccount] = 20000;
		PlayerInfo[playerid][pGangWarn] = 0;
		PlayerInfo[playerid][pPaintTokens] = 0;
		PlayerInfo[playerid][pTogReports] = 0;
		PlayerInfo[playerid][pCHits] = 0;
		PlayerInfo[playerid][pFHits] = 0;
		PlayerInfo[playerid][pAccent] = 1;
		PlayerInfo[playerid][pCSFBanned] = 0;
		PlayerInfo[playerid][pWristwatch] = 0;
		PlayerInfo[playerid][pSurveillance] = 0;
		PlayerInfo[playerid][pTire] = 0;
		PlayerInfo[playerid][pFirstaid] = 0;
		PlayerInfo[playerid][pRccam] = 0;
		PlayerInfo[playerid][pReceiver] = 0;
		PlayerInfo[playerid][pGPS] = 0;
		PlayerInfo[playerid][pSweep] = 0;
		PlayerInfo[playerid][pSweepLeft] = 0;
		PlayerInfo[playerid][pTreasureSkill] = 0;
		PlayerInfo[playerid][pMetalDetector] = 0;
		PlayerInfo[playerid][pHelpedBefore] = 0;
		PlayerInfo[playerid][pTrickortreat] = 0;
		PlayerInfo[playerid][pRHMutes] = 0;
		PlayerInfo[playerid][pRHMuteTime] = 0;
		PlayerInfo[playerid][pCredits] = 0;
        PlayerInfo[playerid][pReceivedCredits] = 0;
		PlayerInfo[playerid][pTotalCredits] = 0;
		PlayerInfo[playerid][pHasTazer] = 0;
		PlayerInfo[playerid][pHasCuff] = 0;
		PlayerInfo[playerid][pCarVoucher] = 0;
		strcpy(PlayerInfo[playerid][pReferredBy], "Nobody", MAX_PLAYER_NAME);
		PlayerInfo[playerid][pPendingRefReward] = 0;
		PlayerInfo[playerid][pRefers] = 0;
		PlayerInfo[playerid][pFamed] = 0;
		PlayerInfo[playerid][pFMuted] = 0;
		PlayerInfo[playerid][pDefendTime] = 0;
		PlayerInfo[playerid][pVehicleSlot] = 0;
		PlayerInfo[playerid][pToySlot] = 0;
		PlayerInfo[playerid][pVehVoucher] = 0;
		PlayerInfo[playerid][pSVIPVoucher] = 0;
		PlayerInfo[playerid][pGVIPVoucher] = 0;
		PlayerInfo[playerid][pFallIntoFun] = 0;
		PlayerInfo[playerid][pHungerVoucher] = 0;
		PlayerInfo[playerid][pAdvertVoucher] = 0;
		PlayerInfo[playerid][pShopCounter] = 0;
		PlayerInfo[playerid][pShopNotice] = 0;
		PlayerInfo[playerid][pSVIPExVoucher] = 0;
		PlayerInfo[playerid][pGVIPExVoucher] = 0;
		PlayerInfo[playerid][pVIPSellable] = 0;
		PlayerInfo[playerid][pReceivedPrize] = 0;
		PlayerInfo[playerid][pReg] = 1;
	}

	if(PlayerInfo[playerid][pHospital] == 1)
	{
		PlayerInfo[playerid][pHospital] = 0;
		SetPVarInt(playerid, "MedicBill", 1);
	}

	if(PlayerInfo[playerid][pBanAppealer] >= 1 && PlayerInfo[playerid][pAdmin] < 2) PlayerInfo[playerid][pBanAppealer] = 0;
	if(PlayerInfo[playerid][pPR] >= 1 && PlayerInfo[playerid][pAdmin] < 2) PlayerInfo[playerid][pPR] = 0;
	if(PlayerInfo[playerid][pShopTech] >= 1 && PlayerInfo[playerid][pAdmin] < 2) PlayerInfo[playerid][pShopTech] = 0;
	if(PlayerInfo[playerid][pUndercover] >= 1 && PlayerInfo[playerid][pAdmin] < 2) PlayerInfo[playerid][pUndercover] = 0;
	if(PlayerInfo[playerid][pFactionModerator] >= 1 && PlayerInfo[playerid][pAdmin] < 2) PlayerInfo[playerid][pFactionModerator] = 0;
	if(PlayerInfo[playerid][pGangModerator] >= 1 && PlayerInfo[playerid][pAdmin] < 2) PlayerInfo[playerid][pGangModerator] = 0;
	if(PlayerInfo[playerid][pHelper] == 1 && PlayerInfo[playerid][pAdmin] >= 1) PlayerInfo[playerid][pHelper] = 0;
	if(gettime() >= PlayerInfo[playerid][pMechTime]) PlayerInfo[playerid][pMechTime] = 0;
	if(gettime() >= PlayerInfo[playerid][pLawyerTime]) PlayerInfo[playerid][pLawyerTime] = 0;
	if(gettime() >= PlayerInfo[playerid][pDrugsTime]) PlayerInfo[playerid][pDrugsTime] = 0;
	if(gettime() >= PlayerInfo[playerid][pSexTime]) PlayerInfo[playerid][pSexTime] = 0;

	HideMainMenuGUI(playerid);
	HideNoticeGUIFrame(playerid);
	
	if(PlayerInfo[playerid][pVIPExpire] > 0 && (1 <= PlayerInfo[playerid][pDonateRank] <= 3) && (PlayerInfo[playerid][pVIPExpire] < gettime()) && PlayerInfo[playerid][pAdmin] < 2)
	{
	    PlayerInfo[playerid][pVIPSellable] = 0;
	    format(string, sizeof(string), "[DEBUG] %s (%s) VIP removed (VIP Expire: %d | Level: %d)", GetPlayerNameEx(playerid), GetPlayerIpEx(playerid), PlayerInfo[playerid][pVIPExpire], PlayerInfo[playerid][pDonateRank]);
	    Log("logs/vipremove.log", string);
	    //format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: Please check person %s as their VIP may have expired.", GetPlayerNameEx(playerid));
		//ABroadCast(COLOR_YELLOW, string, 4);
	    //PlayerInfo[playerid][pDonateRank] = 0;
	    //SendClientMessageEx(playerid, COLOR_YELLOW, "Your VIP has been removed as it has expired");
	}

	if(PlayerInfo[playerid][pPendingRefReward] >= 1)
	{
	    new szQuery[128], szString[128];
	    if(PlayerInfo[playerid][pRefers] < 5 && PlayerInfo[playerid][pRefers] > 0)
	    {
		    PlayerInfo[playerid][pCredits] += CREDITS_AMOUNT_REFERRAL*PlayerInfo[playerid][pPendingRefReward];
			PlayerInfo[playerid][pPendingRefReward] = 0;
			PlayerInfo[playerid][pRefers]++;
			format(szQuery, sizeof(szQuery), "UPDATE `accounts` SET `Credits`=%d WHERE `Username` = '%s'", PlayerInfo[playerid][pCredits], GetPlayerNameExt(playerid));
			mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
			format(szString, sizeof(szString), "%s has received %d credits for referring a player (The player reached level 3)", GetPlayerNameEx(playerid), CREDITS_AMOUNT_REFERRAL*PlayerInfo[playerid][pPendingRefReward]);
			Log("logs/referral.log", szString);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Your friend that you referred to the server has reached level 3, therefore you have received 100 credits.");
		}
	    else if(PlayerInfo[playerid][pRefers] == 5)
	    {
		    PlayerInfo[playerid][pCredits] += CREDITS_AMOUNT_REFERRAL*5*PlayerInfo[playerid][pPendingRefReward];
			PlayerInfo[playerid][pPendingRefReward] = 0;
			PlayerInfo[playerid][pRefers]++;
			format(szQuery, sizeof(szQuery), "UPDATE `accounts` SET `Credits`=%d WHERE `Username` = '%s'", PlayerInfo[playerid][pCredits], GetPlayerNameExt(playerid));
			mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
			format(szString, sizeof(szString), "%s has received %d credits for referring a player (The player reached level 3)", GetPlayerNameEx(playerid), CREDITS_AMOUNT_REFERRAL*5*PlayerInfo[playerid][pPendingRefReward]);
			Log("logs/referral.log", szString);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Your friend that you referred to the server has reached level 3, therefore you have received 500 credits.");
		}
		else if(PlayerInfo[playerid][pRefers] < 10 && PlayerInfo[playerid][pRefers] > 5)
	    {
		    PlayerInfo[playerid][pCredits] += CREDITS_AMOUNT_REFERRAL*PlayerInfo[playerid][pPendingRefReward];
			PlayerInfo[playerid][pPendingRefReward] = 0;
			PlayerInfo[playerid][pRefers]++;
			format(szQuery, sizeof(szQuery), "UPDATE `accounts` SET `Credits`=%d WHERE `Username` = '%s'", PlayerInfo[playerid][pCredits], GetPlayerNameExt(playerid));
			mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
			format(szString, sizeof(szString), "%s has received %d credits for referring a player (The player reached level 3)", GetPlayerNameEx(playerid), CREDITS_AMOUNT_REFERRAL*PlayerInfo[playerid][pPendingRefReward]);
			Log("logs/referral.log", szString);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Your friend that you referred to the server has reached level 3, therefore you have received 100 credits.");
		}
		else if(PlayerInfo[playerid][pRefers] == 10)
	    {
		    PlayerInfo[playerid][pCredits] += CREDITS_AMOUNT_REFERRAL*10*PlayerInfo[playerid][pPendingRefReward];
			PlayerInfo[playerid][pPendingRefReward] = 0;
			PlayerInfo[playerid][pRefers]++;
			format(szQuery, sizeof(szQuery), "UPDATE `accounts` SET `Credits`=%d WHERE `Username` = '%s'", PlayerInfo[playerid][pCredits], GetPlayerNameExt(playerid));
			mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
			format(szString, sizeof(szString), "%s has received %d credits for referring a player (The player reached level 3)", GetPlayerNameEx(playerid), CREDITS_AMOUNT_REFERRAL*10*PlayerInfo[playerid][pPendingRefReward]);
			Log("logs/referral.log", szString);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Your friend that you referred to the server has reached level 3, therefore you have received 1000 credits.");
		}
		else if(PlayerInfo[playerid][pRefers] < 15 && PlayerInfo[playerid][pRefers] > 10)
	    {
		    PlayerInfo[playerid][pCredits] += CREDITS_AMOUNT_REFERRAL*PlayerInfo[playerid][pPendingRefReward];
			PlayerInfo[playerid][pPendingRefReward] = 0;
			PlayerInfo[playerid][pRefers]++;
			format(szQuery, sizeof(szQuery), "UPDATE `accounts` SET `Credits`=%d WHERE `Username` = '%s'", PlayerInfo[playerid][pCredits], GetPlayerNameExt(playerid));
			mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
			format(szString, sizeof(szString), "%s has received %d credits for referring a player (The player reached level 3)", GetPlayerNameEx(playerid), CREDITS_AMOUNT_REFERRAL*PlayerInfo[playerid][pPendingRefReward]);
			Log("logs/referral.log", szString);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Your friend that you referred to the server has reached level 3, therefore you have received 100 credits.");
		}
		else if(PlayerInfo[playerid][pRefers] == 15)
	    {
		    PlayerInfo[playerid][pCredits] += CREDITS_AMOUNT_REFERRAL*15*PlayerInfo[playerid][pPendingRefReward];
			PlayerInfo[playerid][pPendingRefReward] = 0;
			PlayerInfo[playerid][pRefers]++;
			format(szQuery, sizeof(szQuery), "UPDATE `accounts` SET `Credits`=%d WHERE `Username` = '%s'", PlayerInfo[playerid][pCredits], GetPlayerNameExt(playerid));
			mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
			format(szString, sizeof(szString), "%s has received %d credits for referring a player (The player reached level 3)", GetPlayerNameEx(playerid), CREDITS_AMOUNT_REFERRAL*15*PlayerInfo[playerid][pPendingRefReward]);
			Log("logs/referral.log", szString);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Your friend that you referred to the server has reached level 3, therefore you have received 1500 credits.");
		}
		else if(PlayerInfo[playerid][pRefers] < 20 && PlayerInfo[playerid][pRefers] > 15)
	    {
		    PlayerInfo[playerid][pCredits] += CREDITS_AMOUNT_REFERRAL*PlayerInfo[playerid][pPendingRefReward];
			PlayerInfo[playerid][pPendingRefReward] = 0;
			PlayerInfo[playerid][pRefers]++;
			format(szQuery, sizeof(szQuery), "UPDATE `accounts` SET `Credits`=%d WHERE `Username` = '%s'", PlayerInfo[playerid][pCredits], GetPlayerNameExt(playerid));
			mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
			format(szString, sizeof(szString), "%s has received %d credits for referring a player (The player reached level 3)", GetPlayerNameEx(playerid), CREDITS_AMOUNT_REFERRAL*PlayerInfo[playerid][pPendingRefReward]);
			Log("logs/referral.log", szString);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Your friend that you referred to the server has reached level 3, therefore you have received 100 credits.");
		}
		else if(PlayerInfo[playerid][pRefers] == 20)
	    {
		    PlayerInfo[playerid][pCredits] += CREDITS_AMOUNT_REFERRAL*20*PlayerInfo[playerid][pPendingRefReward];
			PlayerInfo[playerid][pPendingRefReward] = 0;
			PlayerInfo[playerid][pRefers]++;
			format(szQuery, sizeof(szQuery), "UPDATE `accounts` SET `Credits`=%d WHERE `Username` = '%s'", PlayerInfo[playerid][pCredits], GetPlayerNameExt(playerid));
			mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
			format(szString, sizeof(szString), "%s has received %d credits for referring a player (The player reached level 3)", GetPlayerNameEx(playerid), CREDITS_AMOUNT_REFERRAL*20*PlayerInfo[playerid][pPendingRefReward]);
			Log("logs/referral.log", szString);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Your friend that you referred to the server has reached level 3, therefore you have received 2000 credits.");
		}
        else if(PlayerInfo[playerid][pRefers] < 25 && PlayerInfo[playerid][pRefers] > 20)
	    {
		    PlayerInfo[playerid][pCredits] += CREDITS_AMOUNT_REFERRAL*PlayerInfo[playerid][pPendingRefReward];
			PlayerInfo[playerid][pPendingRefReward] = 0;
			PlayerInfo[playerid][pRefers]++;
			format(szQuery, sizeof(szQuery), "UPDATE `accounts` SET `Credits`=%d WHERE `Username` = '%s'", PlayerInfo[playerid][pCredits], GetPlayerNameExt(playerid));
			mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
			format(szString, sizeof(szString), "%s has received %d credits for referring a player (The player reached level 3)", GetPlayerNameEx(playerid), CREDITS_AMOUNT_REFERRAL*PlayerInfo[playerid][pPendingRefReward]);
			Log("logs/referral.log", szString);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Your friend that you referred to the server has reached level 3, therefore you have received 100 credits.");
		}
		else if(PlayerInfo[playerid][pRefers] >= 25)
	    {
		    PlayerInfo[playerid][pCredits] += CREDITS_AMOUNT_REFERRAL*25*PlayerInfo[playerid][pPendingRefReward];
			PlayerInfo[playerid][pPendingRefReward] = 0;
			PlayerInfo[playerid][pRefers]++;
			format(szQuery, sizeof(szQuery), "UPDATE `accounts` SET `Credits`=%d WHERE `Username` = '%s'", PlayerInfo[playerid][pCredits], GetPlayerNameExt(playerid));
			mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
			format(szString, sizeof(szString), "%s has received %d credits for referring a player (The player reached level 3)", GetPlayerNameEx(playerid), CREDITS_AMOUNT_REFERRAL*25*PlayerInfo[playerid][pPendingRefReward]);
			Log("logs/referral.log", szString);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Your friend that you referred to the server has reached level 3, therefore you have received 2500 credits.");
		}
	}
	if(PlayerInfo[playerid][pBusiness] >= 0 && Businesses[PlayerInfo[playerid][pBusiness]][bMonths] != 0)
	{
	    if(Businesses[PlayerInfo[playerid][pBusiness]][bMonths] < gettime())
	    {
	        new
				Business = PlayerInfo[playerid][pBusiness];

			//foreach(new j: Player) {
			for(new j = 0; j < MAX_PLAYERS; ++j)
			{
				if(IsPlayerConnected(j))
				{			
					if(PlayerInfo[j][pBusiness] == Business) {
						PlayerInfo[j][pBusiness] = INVALID_BUSINESS_ID;
						PlayerInfo[j][pBusinessRank] = 0;
						SendClientMessageEx(playerid, COLOR_WHITE, "An admin has sold this business, your business stats have been reset.");
					}
				}	
			}

			Businesses[Business][bOwner] = -1;
			Businesses[Business][bMonths] = 0;
			Businesses[Business][bValue] = 0;
			SaveBusiness(Business);
			RefreshBusinessPickup(Business);

			format(string, sizeof(string), "UPDATE `accounts` SET `Business` = "#INVALID_BUSINESS_ID", `BusinessRank` = 0 WHERE `Business` = '%d'", Business);
			mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);

	        SendClientMessageEx(playerid, COLOR_RED, "Your business has been removed as it has expired.");
	        format(string, sizeof(string), "[BUSINESS EXPIRED] %s business id %i has been removed as it has expired.", GetPlayerNameEx(playerid), Business);
			Log("logs/shoplog.log", string);

	    }
	    else if(Businesses[PlayerInfo[playerid][pBusiness]][bMonths] - 259200 < gettime())
	    {
	        SendClientMessageEx(playerid, COLOR_RED, "Your business expires in less than three days - renew today at shop.ng-gaming.net! Type /businessdate for more information.");
	    }
	}
	if(PlayerInfo[playerid][pJob2] >= 1 && (PlayerInfo[playerid][pDonateRank] < 1 && PlayerInfo[playerid][pFamed] < 1))
	{
		PlayerInfo[playerid][pJob2] = 0;
		SendClientMessageEx(playerid, COLOR_YELLOW, "You have lost your secondary job due to the fact that you are no longer a VIP/Famed.");
	}
	if(PlayerInfo[playerid][pJob3] >= 1 && PlayerInfo[playerid][pDonateRank] < 3)
	{
		PlayerInfo[playerid][pJob3] = 0;
		SendClientMessageEx(playerid, COLOR_YELLOW, "You have lost your third job due to the fact that you are no longer a Gold VIP+.");
	}	
	if(PlayerInfo[playerid][pDonateRank] >= 4 && PlayerInfo[playerid][pArmsSkill] < 400)
	{
		PlayerInfo[playerid][pArmsSkill] = 401;
		SendClientMessageEx(playerid, COLOR_YELLOW, "Platinum VIP Feature: You have been given Level 5 Arms Dealer.");
	}
	if(PlayerInfo[playerid][pDonateRank] >= 4)
	{
		new days;
		ConvertTime(gettime() - PlayerInfo[playerid][pFreeAdsDay], .ctd=days);
		if(days >= 1)
		{
			PlayerInfo[playerid][pFreeAdsDay] = gettime();
			PlayerInfo[playerid][pFreeAdsLeft] = 3;
		}
		ConvertTime(gettime() - PlayerInfo[playerid][pVIPInviteDay], .ctd=days);
		if(days >= 1)
		{
			PlayerInfo[playerid][pVIPInviteDay] = gettime();
			PlayerInfo[playerid][pBuddyInvites] = 3;
		}
	}	
	if (PlayerInfo[playerid][pLevel] < 6 || PlayerInfo[playerid][pHelper] > 0)
	{
		gNewbie[playerid] = 0;
	}
	if (PlayerInfo[playerid][pHelper] == 1)
	{
		gHelp[playerid] = 0;
	}
	if(PlayerInfo[playerid][pAdmin] != 0 && PlayerInfo[playerid][pAdmin] != 1 && PlayerInfo[playerid][pAdmin] != 2 && PlayerInfo[playerid][pAdmin] != 3 && PlayerInfo[playerid][pAdmin] != 4 &&PlayerInfo[playerid][pAdmin] != 1337 && PlayerInfo[playerid][pAdmin] != 1338 && PlayerInfo[playerid][pAdmin] != 99999)
	{
		new name[MAX_PLAYER_NAME];
		GetPlayerName(playerid, name, sizeof(name));
		format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s has attempted to log in with Admin Level %d.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pAdmin]);
		ABroadCast( COLOR_YELLOW, string, 4 );
		format(string, sizeof(string), "%s has attempted to log in with Admin Level %d.", name, PlayerInfo[playerid][pAdmin]);
		Log("logs/security.log", string);
		PlayerInfo[playerid][pAdmin] = 0;
	}
	if (PlayerInfo[playerid][pAdmin] > 0)
	{
		if(PlayerInfo[playerid][pAdmin] == 1)
		{
			if(PlayerInfo[playerid][pSMod] == 1)
			{
				SendClientMessageEx(playerid, COLOR_WHITE,"SERVER: You are logged in as a Senior Moderator.");
				format( string, sizeof( string ), "SERVER: %s has logged in as a Senior Moderator.", GetPlayerNameEx(playerid));
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_WHITE,"SERVER: You are logged in as a Moderator.");
				format(string, sizeof(string), "SERVER: %s has logged in as a Moderator.", GetPlayerNameEx(playerid));
			}
		}
		else
		{
		    PriorityReport[playerid] = TextDrawCreate(261.000000, 373.000000, "New Report");
			TextDrawBackgroundColor(PriorityReport[playerid], 255);
			TextDrawFont(PriorityReport[playerid], 2);
			TextDrawLetterSize(PriorityReport[playerid], 0.460000, 1.800000);
			TextDrawColor(PriorityReport[playerid], -65281);
			TextDrawSetOutline(PriorityReport[playerid], 0);
			TextDrawSetProportional(PriorityReport[playerid], 1);
			TextDrawSetShadow(PriorityReport[playerid], 1);

			format(string, sizeof(string), "SERVER: You are logged in as a %s{FFFFFF}.", GetStaffRank(playerid));
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			format(string, sizeof(string), "SERVER: %s has logged in as a %s{FFFFFF}.", GetPlayerNameEx(playerid), GetStaffRank(playerid));
		}

		//foreach(new i: Player)
		for(new i = 0; i < MAX_PLAYERS; ++i)
		{
			if(IsPlayerConnected(i))
			{
				if(PlayerInfo[i][pAdmin] >= 1337 && PlayerInfo[i][pAdmin] >= PlayerInfo[playerid][pAdmin]) SendClientMessageEx(i, COLOR_WHITE, string);
			}	
		}
	}
	
	for(new i = 0; i < sizeof(GateInfo); i++)
	{
		if(GateInfo[i][gAutomate] == 1)
		{
			if(GateInfo[i][gFamilyID] != -1 && PlayerInfo[playerid][pFMember] == GateInfo[i][gFamilyID]) SetTimerEx("AutomaticGateTimer", 1000, false, "ii", playerid, i);
			else if(GateInfo[i][gGroupID] != -1 && (0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS) && PlayerInfo[playerid][pMember] == GateInfo[i][gGroupID]) SetTimerEx("AutomaticGateTimer", 1000, false, "ii", playerid, i);
			else if(GateInfo[i][gAllegiance] != 0 && GateInfo[i][gGroupType] != 0 && (0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS) && arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance] == GateInfo[i][gAllegiance] && arrGroupData[PlayerInfo[playerid][pMember]][g_iGroupType] == GateInfo[i][gGroupType]) SetTimerEx("AutomaticGateTimer", 1000, false, "ii", playerid, i);
			else if(GateInfo[i][gAllegiance] != 0 && GateInfo[i][gGroupType] == 0 && (0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS) && arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance] == GateInfo[i][gAllegiance]) SetTimerEx("AutomaticGateTimer", 1000, false, "ii", playerid, i);
			else if(GateInfo[i][gAllegiance] == 0 && GateInfo[i][gGroupType] != 0 && (0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS) && arrGroupData[PlayerInfo[playerid][pMember]][g_iGroupType] == GateInfo[i][gGroupType]) SetTimerEx("AutomaticGateTimer", 1000, false, "ii", playerid, i);
			else if(GateInfo[i][gAllegiance] == 0 && GateInfo[i][gGroupType] == 0 && GateInfo[i][gGroupID] == -1 && GateInfo[i][gFamilyID] == -1) SetTimerEx("AutomaticGateTimer", 1000, false, "ii", playerid, i);
		}
	}
	
	// Create the player necessary textdraws
	CreatePlayerTextDraws(playerid);


	printf("%s has logged in.", GetPlayerNameEx(playerid));
	format(string, sizeof(string), "SERVER: Welcome, %s.", GetPlayerNameEx(playerid));
	SendClientMessageEx(playerid, COLOR_WHITE, string);
	
	SetSpawnInfo(playerid, 0, PlayerInfo[playerid][pModel], PlayerInfo[playerid][pPos_x], PlayerInfo[playerid][pPos_y], PlayerInfo[playerid][pPos_z], 1.0, -1, -1, -1, -1, -1, -1);
	defer SkinDelay(playerid);

	gPlayerLogged{playerid} = 1;
	g_mysql_AccountOnline(playerid, servernumber);
	GetHomeCount(playerid);

	new ip[32];
	GetPlayerIp(playerid, ip, sizeof(ip));
	format(string, sizeof(string), "%s (ID: %d | SQL ID: %d | Level: %d | IP: %s) has logged in.", GetPlayerNameExt(playerid), playerid, GetPlayerSQLId(playerid), PlayerInfo[playerid][pLevel], ip);
	Log("logs/login.log", string);

	if(PlayerInfo[playerid][pAdmin] >= 2)
	{
		new tdate[11], thour[9], i_timestamp[3];
		getdate(i_timestamp[0], i_timestamp[1], i_timestamp[2]);
		format(tdate, sizeof(tdate), "%d-%02d-%02d", i_timestamp[0], i_timestamp[1], i_timestamp[2]);
		format(thour, sizeof(thour), "%02d:00:00", hour);
		GetReportCount(playerid, tdate);
		GetHourReportCount(playerid, thour, tdate);
	}

	if(PlayerInfo[playerid][pHelper] > 0)
	{
		new tdate[11], thour[9], i_timestamp[3];
		getdate(i_timestamp[0], i_timestamp[1], i_timestamp[2]);
		format(tdate, sizeof(tdate), "%d-%02d-%02d", i_timestamp[0], i_timestamp[1], i_timestamp[2]);
		format(thour, sizeof(thour), "%02d:00:00", hour);
		GetRequestCount(playerid, tdate);
		GetHourRequestCount(playerid, thour, tdate);
	}

	if(PlayerInfo[playerid][pWarns] >= 3)
	{
		format(string, sizeof(string), "AdmCmd: %s (IP: %s) was banned (had 3 Warnings)", GetPlayerNameEx(playerid), GetPlayerIpEx(playerid));
		Log("logs/ban.log", string);
		format(string, sizeof(string), "AdmCmd: %s was banned (had 3 Warnings)", GetPlayerNameEx(playerid));
		SendClientMessageToAllEx(COLOR_LIGHTRED, string);
		PlayerInfo[playerid][pBanned] = 1;
		SystemBan(playerid, "[System] (Had 3 Warnings)");
		MySQLBan(GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), "Third Warning", 1, "System");
		SetTimerEx("KickEx", 1000, 0, "i", playerid);
		return 1;
	}

	TogglePlayerSpectating(playerid, 0);
	//SpawnPlayer(playerid);
	format(string, sizeof(string), "~w~Welcome,~n~~y~%s!", GetPlayerNameEx(playerid));
	GameTextForPlayer(playerid, string, 5000, 1);
	SendClientMessageEx(playerid, COLOR_YELLOW, GlobalMOTD);

	if(PlayerInfo[playerid][pAdmin] > 0) {
		if(PlayerInfo[playerid][pAdmin] >= 2) SendClientMessageEx(playerid, COLOR_YELLOW, AdminMOTD);
		SendClientMessageEx(playerid, TEAM_AZTECAS_COLOR, CAMOTD);
	}

	if(PlayerInfo[playerid][pDonateRank] >= 1)
	SendClientMessageEx(playerid, COLOR_VIP, VIPMOTD);

	if(PlayerInfo[playerid][pHelper] >= 1) {
		SendClientMessageEx(playerid, TEAM_AZTECAS_COLOR, CAMOTD);
		if(PlayerInfo[playerid][pHelper] >= 2) {
			SetPVarInt(playerid, "AdvisorDuty", 1);
			++Advisors;
		}
	}

	if(PlayerInfo[playerid][pInt] > 0 || PlayerInfo[playerid][pVW] > 0)
	{
	    TogglePlayerControllable(playerid, 1);
	}

	SetPlayerFightingStyle(playerid, PlayerInfo[playerid][pFightStyle]);

	LoadPlayerDisabledVehicles(playerid);

	SetPlayerToTeamColor(playerid);
	if(PlayerInfo[playerid][pLottoNr] > 0)
	{
	    CountTickets(playerid);
	    LoadTickets(playerid);
	}
	format(string, sizeof(string), "SELECT * FROM `rentedcars` WHERE `sqlid` = '%d'", GetPlayerSQLId(playerid));
	mysql_function_query(MainPipeline, string, true, "LoadRentedCar", "i", playerid);

	if(PlayerInfo[playerid][pFMember] == -1) { PlayerInfo[playerid][pFMember] = INVALID_FAMILY_ID; }
	if(PlayerInfo[playerid][pFMember] >= 0 && PlayerInfo[playerid][pFMember] < INVALID_FAMILY_ID)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "Family MOTD's:");
		for(new i = 1; i <= 3; i++)
		{
			format(string, sizeof(string), "%d: %s", i, FamilyMOTD[PlayerInfo[playerid][pFMember]][i-1]);
			SendClientMessageEx(playerid, COLOR_YELLOW, string);
		}
		for(new i = 0; i < MAX_POINTS; i++)
		{
			if(Points[i][CapCrash] == 1)
			{
				SendClientMessageEx(playerid, COLOR_YELLOW, "Point Crash Protection:");
				format(string, sizeof(string), "%s has attempted to take control of the %s for %s, it will be theirs in %d minutes.", Points[i][PlayerNameCapping], Points[i][Name], FamilyInfo[Points[i][ClaimerTeam]][FamilyName], Points[i][TakeOverTimer]);
				SendClientMessageEx(playerid, COLOR_YELLOW, string);
			}
		}
	}
	if(0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS && arrGroupData[PlayerInfo[playerid][pMember]][g_szGroupMOTD][0])
	{
		format(string, sizeof(string), "MOTD: %s", arrGroupData[PlayerInfo[playerid][pMember]][g_szGroupMOTD]);
		SendClientMessageEx(playerid, arrGroupData[PlayerInfo[playerid][pMember]][g_hDutyColour] * 256 + 255, string);
	}
	CountFlags(playerid);
	if(PlayerInfo[playerid][pFlagged] > 5)
	{
		format(string, sizeof(string), "SERVER: %s has %d outstanding flags.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pFlagged]);
		ABroadCast(COLOR_WHITE, string, 2);
	}
	LoadTreasureInventory(playerid);
	if(PlayerInfo[playerid][pOrder] > 0)
	{
		if(PlayerInfo[playerid][pOrderConfirmed] == 1)
		{
			format(string, sizeof(string), "SERVER: %s has an outstanding shop (Confirmed) order.", GetPlayerNameEx(playerid));
			ShopTechBroadCast(COLOR_WHITE, string);
		}
		else
		{
			format(string, sizeof(string), "SERVER: %s has an outstanding shop (Invalid) order.", GetPlayerNameEx(playerid));
			ShopTechBroadCast(COLOR_WHITE, string);
		}
	}
	
	if(PlayerInfo[playerid][pDonateRank] >= 3)
	{
		new bmonth, bday, byear;
		new year, month, day;
		new szQuery[128];
		getdate(year, month, day);
		sscanf(PlayerInfo[playerid][pBirthDate], "p<->iii", byear, bmonth, bday);
		printf("%d-%d-%d -pBirthDate",byear, bmonth, bday);
		printf("%d-%d-%d -getdate", year, month, day);
		if(month == bmonth && day == bday)
		{
			if(PlayerInfo[playerid][pLastBirthday] >= gettime()-86400 || gettime() >= PlayerInfo[playerid][pLastBirthday]+28512000)
			{
				SetPVarInt(playerid, "pBirthday", 1);
				PlayerInfo[playerid][pLastBirthday] = gettime();
				format(szQuery, sizeof(szQuery), "UPDATE `accounts` SET `LastBirthday`=%d WHERE `Username` = '%s'", PlayerInfo[playerid][pLastBirthday], GetPlayerNameExt(playerid));
				mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
			}
		}
		else
		{
			DeletePVar(playerid, "pBirthday");
		}
	}
	if(GetPVarInt(playerid, "pBirthday") == 1)
	{
		if(PlayerInfo[playerid][pReceivedBGift] != 1)
		{
			PlayerInfo[playerid][pReceivedBGift] = 1;
			GiftPlayer(MAX_PLAYERS, playerid);
			format(string, sizeof(string), "Happy Birthday %s! You have received a free gift!", GetPlayerNameEx(playerid));
			SendClientMessageEx(playerid, COLOR_YELLOW, string);
			format(string, sizeof(string), "%s has received a free gift for his birthday (%s) (OnPlayerLoad).", GetPlayerNameEx(playerid), PlayerInfo[playerid][pBirthDate]);
			Log("logs/birthday.log", string);
			OnPlayerStatsUpdate(playerid);
		}
		SendClientMessageEx(playerid, COLOR_YELLOW, "Gold VIP: You will get x2 paycheck as a birthday gift today.");
	}
	else
	{
		PlayerInfo[playerid][pReceivedBGift] = 0;
	}	

	new
	iCheckOne = INVALID_HOUSE_ID,
	iCheckTwo = INVALID_HOUSE_ID,
	iCheckThree = INVALID_HOUSE_ID,
	szPlayerName[MAX_PLAYER_NAME];

	GetPlayerName(playerid, szPlayerName, sizeof(szPlayerName));

	for(new i = 0; i < MAX_HOUSES; ++i)
	{
		if(HouseInfo[i][hOwnerID] == GetPlayerSQLId(playerid))
		{
			if(iCheckOne == INVALID_HOUSE_ID) iCheckOne = i;
			else if(iCheckTwo == INVALID_HOUSE_ID) iCheckTwo = i;
			else if(iCheckThree == INVALID_HOUSE_ID) iCheckThree = i;
			else break;
		}
	}
	if(iCheckOne != INVALID_HOUSE_ID) PlayerInfo[playerid][pPhousekey] = iCheckOne;
	else PlayerInfo[playerid][pPhousekey] = INVALID_HOUSE_ID;

	if(iCheckTwo != INVALID_HOUSE_ID) PlayerInfo[playerid][pPhousekey2] = iCheckTwo;
	else PlayerInfo[playerid][pPhousekey2] = INVALID_HOUSE_ID;
	
	if(iCheckThree != INVALID_HOUSE_ID) PlayerInfo[playerid][pPhousekey3] = iCheckThree;
	else PlayerInfo[playerid][pPhousekey3] = INVALID_HOUSE_ID;

	if(PlayerInfo[playerid][pRenting] != INVALID_HOUSE_ID && (PlayerInfo[playerid][pPhousekey] != INVALID_HOUSE_ID || PlayerInfo[playerid][pPhousekey2] != INVALID_HOUSE_ID || PlayerInfo[playerid][pPhousekey3] != INVALID_HOUSE_ID)) {
		PlayerInfo[playerid][pRenting] = INVALID_HOUSE_ID;
	}
	if(iRewardPlay)
    {
	    format(string, sizeof(string), "You currently have %d Reward Hours, please check /rewards for more information.", floatround(PlayerInfo[playerid][pRewardHours]));
		SendClientMessageEx(playerid, COLOR_YELLOW, string);
    }
	if(1 <= PlayerInfo[playerid][pDonateRank] <= 3  && PlayerInfo[playerid][pVIPExpire] > 0 && (PlayerInfo[playerid][pVIPExpire] - 259200 < gettime()))
    {
		SendClientMessageEx(playerid, COLOR_RED, "Your VIP expires in less than three days - renew today at shop.ng-gaming.net! Type /vipdate for more information.");
    }
	if(PlayerInfo[playerid][pRVehWarns] != 0 && PlayerInfo[playerid][pLastRVehWarn] + 2592000 < gettime()) {
		SendClientMessageEx(playerid, COLOR_WHITE, "Your restricted vehicle warnings have expired!");
		PlayerInfo[playerid][pLastRVehWarn] = 0;
		PlayerInfo[playerid][pRVehWarns] = 0;
	}

    SetUnreadMailsNotification(playerid);
    #if defined zombiemode
   	if(zombieevent == 1)
	{
		format(string, sizeof(string), "SELECT `id` FROM `zombie` WHERE `id` = '%d'", GetPlayerSQLId(playerid));
		mysql_function_query(MainPipeline, string, true, "OnZombieCheck", "i", playerid);
	}
	#endif

	if(PlayerInfo[playerid][pWeedObject] != 0) {
	    for(new i; i < MAX_PLANTS; i++)
	    {
	        if(Plants[i][pOwner] == GetPlayerSQLId(playerid))
	        {
				return 1;
	        }
	    }
		PlayerInfo[playerid][pWeedObject] = 0;
	}
	if(PlayerInfo[playerid][pAdmin] < 2 && !IsValidName(playerid))
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You have been kicked for having a Non RP Name.");
		SetPVarString(playerid, "KickNonRP", GetPlayerNameEx(playerid));
		SetTimerEx("KickNonRP", 3000, false, "i", playerid);
	}
	new year, month, day;
	getdate(year, month, day);
	if(PlayerInfo[playerid][pReceivedPrize] == 0 && month == 12 && day == 30 && year == 2013)
	{
		new icount = GetPlayerToySlots(playerid), success = 0;
		for(new v = 0; v < icount; v++)
		{
			if(PlayerToyInfo[playerid][v][ptModelID] == 0)
			{
				PlayerToyInfo[playerid][v][ptModelID] = 19064;
				PlayerToyInfo[playerid][v][ptBone] = 6;
				PlayerToyInfo[playerid][v][ptPosX] = 0.0;
				PlayerToyInfo[playerid][v][ptPosY] = 0.0;
				PlayerToyInfo[playerid][v][ptPosZ] = 0.0;
				PlayerToyInfo[playerid][v][ptRotX] = 0.0;
				PlayerToyInfo[playerid][v][ptRotY] = 0.0;
				PlayerToyInfo[playerid][v][ptRotZ] = 0.0;
				PlayerToyInfo[playerid][v][ptScaleX] = 1.0;
				PlayerToyInfo[playerid][v][ptScaleY] = 1.0;
				PlayerToyInfo[playerid][v][ptScaleZ] = 1.0;
				PlayerToyInfo[playerid][v][ptTradable] = 1;
				SendClientMessageEx(playerid, COLOR_GRAD2, "You've been gifted a toy!  Happy New Year!");
				
				g_mysql_NewToy(playerid, v);
				success = 1;
				PlayerInfo[playerid][pReceivedPrize] = 1;
				break;
			}
		}
		
		if(success == 0)
		{
			for(new i = 0; i < MAX_PLAYERTOYS; i++)
			{
				if(PlayerToyInfo[playerid][i][ptModelID] == 0)
				{
					PlayerToyInfo[playerid][i][ptModelID] = 19064;
					PlayerToyInfo[playerid][i][ptBone] = 6;
					PlayerToyInfo[playerid][i][ptPosX] = 0.0;
					PlayerToyInfo[playerid][i][ptPosY] = 0.0;
					PlayerToyInfo[playerid][i][ptPosZ] = 0.0;
					PlayerToyInfo[playerid][i][ptRotX] = 0.0;
					PlayerToyInfo[playerid][i][ptRotY] = 0.0;
					PlayerToyInfo[playerid][i][ptRotZ] = 0.0;
					PlayerToyInfo[playerid][i][ptScaleX] = 1.0;
					PlayerToyInfo[playerid][i][ptScaleY] = 1.0;
					PlayerToyInfo[playerid][i][ptScaleZ] = 1.0;
					PlayerToyInfo[playerid][i][ptTradable] = 1;
					PlayerToyInfo[playerid][i][ptSpecial] = 1;
					
					g_mysql_NewToy(playerid, i); 
					
					PlayerInfo[playerid][pReceivedPrize] = 1;
					SendClientMessageEx(playerid, COLOR_GRAD2, "You've been gifted a toy!  Happy New Year!");
					SendClientMessageEx(playerid, COLOR_GRAD1, "Due to you not having any available slots, we've temporarily gave you an additional slot to use/sell/trade your laser.");
					SendClientMessageEx(playerid, COLOR_RED, "Note: Please take note that after selling the laser, the temporarily additional toy slot will be removed.");
					break;
				}	
			}
		}
	}
	return 1;
}
