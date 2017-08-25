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
 
forward OnPlayerLoad(playerid);
public OnPlayerLoad(playerid)
{
	new string[128];
	if(PlayerInfo[playerid][pOnline] != 0)
	{
	    if(PlayerInfo[playerid][pOnline] != servernumber)
	    {
		    SendClientMessage(playerid, COLOR_WHITE, "SERVER: This account is already online!");
			SetTimerEx("KickEx", 1000, 0, "i", playerid);
			return 1;
		}
	}

	GetPlayerIp(playerid, PlayerInfo[playerid][pIP], 16);
	if( PlayerInfo[playerid][pPermaBanned] == 3 || PlayerInfo[playerid][pBanned] >= 1 )
	{
		format(string, sizeof(string), "WARNING: %s (IP:%s) tried to login whilst banned by the old system.", GetPlayerNameEx( playerid ), PlayerInfo[playerid][pIP] );
		ABroadCast(COLOR_YELLOW, string, 2);
		SendClientMessage(playerid, COLOR_RED, "Your account is banned! You can appeal this at http://www.ng-gaming.net/forums");
		SendClientMessage(playerid, COLOR_RED, "Your ban date will be set and when it's time it will automatically been banned. ");
		SetTimerEx("KickEx", 1000, 0, "i", playerid);
		return 1;
	}
	ConnectionDBLog(playerid);
	CheckBan(playerid);
	//CheckPlayerPollStatus(playerid);

	if(PlayerInfo[playerid][pDisabled] == 2)
	{
		ShowPlayerDialogEx(playerid, DIALOG_DISABLED, DIALOG_STYLE_MSGBOX, "Account Disabled - Visit http://www.ng-gaming.net/forums", "Your account has been disabled as it has been inactive for more than six months.\nPlease visit the forums and post an Administrative Request to begin the process to reactivate your account.", "Okay", "");
		SetTimerEx("KickEx", 5000, 0, "i", playerid);
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
		if(PlayerInfo[playerid][pHR] > 1) PlayerInfo[playerid][pHR] = 0;
		if(PlayerInfo[playerid][pAP] > 1) PlayerInfo[playerid][pAP] = 0;
		if(PlayerInfo[playerid][pSecurity] > 1) PlayerInfo[playerid][pSecurity] = 0;
		SendClientMessage(playerid, COLOR_WHITE, "SERVER: This account is disabled!");
		SetTimerEx("KickEx", 1000, 0, "i", playerid);
		return 1;
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
			PlayerVehicleInfo[playerid][v][pvPlate] = 0;
			PlayerVehicleInfo[playerid][v][pvAlarm] = 0;
			PlayerVehicleInfo[playerid][v][pvLocksLeft] = 5;
			PlayerVehicleInfo[playerid][v][pvAlarmTriggered] = 0;
			PlayerVehicleInfo[playerid][v][pvBeingPickLocked] = 0;
			PlayerVehicleInfo[playerid][v][pvLastLockPickedBy] = 0;
			ListItemTrackId[playerid][v] = -1;
			for(new m = 0; m < MAX_MODS; m++)
			{
				PlayerVehicleInfo[playerid][v][pvMods][m] = 0;
			}
			PlayerVehicleInfo[playerid][v][pvCrashFlag] = 0;
			PlayerVehicleInfo[playerid][v][pvCrashVW] = 0;
			PlayerVehicleInfo[playerid][v][pvCrashX] = 0.0;
			PlayerVehicleInfo[playerid][v][pvCrashY] = 0.0;
			PlayerVehicleInfo[playerid][v][pvCrashZ] = 0.0;
			PlayerVehicleInfo[playerid][v][pvCrashAngle] = 0.0;
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
			PlayerToyInfo[playerid][v][ptAutoAttach] = -2;
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
		PlayerInfo[playerid][pCash] = 50000;
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
		PlayerInfo[playerid][pWallpaper] = 0;
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
		strcpy(PlayerInfo[playerid][pBadge], "None", 9);
		PlayerInfo[playerid][pRank] = INVALID_RANK;
		PlayerInfo[playerid][pRenting] = INVALID_HOUSE_ID;
		PlayerInfo[playerid][pDetSkill] = 0;
		PlayerInfo[playerid][pSexSkill] = 0;
		PlayerInfo[playerid][pBoxSkill] = 0;
		PlayerInfo[playerid][pLawSkill] = 0;
		PlayerInfo[playerid][pMechSkill] = 0;
		PlayerInfo[playerid][pTruckSkill] = 0;
		PlayerInfo[playerid][pArmsSkill] = 0;
		PlayerInfo[playerid][pDrugSmuggler] = 0;
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
		PlayerInfo[playerid][pCarLic] = 0;
		PlayerInfo[playerid][pFlyLic] = 0;
		PlayerInfo[playerid][pBoatLic] = 0;
		PlayerInfo[playerid][pFishLic] = 1;
		PlayerInfo[playerid][pGunLic] = 0;
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
		PlayerInfo[playerid][pNonRPMeter] = 0;
		PlayerInfo[playerid][pAccountRestricted] = 0;
		PlayerInfo[playerid][pWatchlist] = 0;
		PlayerInfo[playerid][pWatchlistTime] = 0;
		PlayerInfo[playerid][pBackpack] = 0;
		PlayerInfo[playerid][pBEquipped] = 0;
		PlayerInfo[playerid][pBStoredV] = INVALID_PLAYER_VEHICLE_ID;
		PlayerInfo[playerid][pBStoredH] = INVALID_HOUSE_ID;
		PlayerInfo[playerid][pDigCooldown] = 0;
		PlayerInfo[playerid][pBugReportTimeout] = 0;
		PlayerInfo[playerid][pToolBox] = 0;
		PlayerInfo[playerid][pCrowBar] = 0;
		PlayerInfo[playerid][pCarLockPickSkill] = 0;
		PlayerInfo[playerid][pLockPickVehCount] = 0;
		PlayerInfo[playerid][pLockPickTime] = 0;
		PlayerInfo[playerid][pSEC] = 0;
		PlayerInfo[playerid][pBM] = 0;
		PlayerInfo[playerid][pIsolated] = 0;
		PlayerInfo[playerid][pWantedJailTime] = 0;
		PlayerInfo[playerid][pWantedJailFine] = 0;
		PlayerInfo[playerid][pNextNameChange] = 0;
		PlayerInfo[playerid][pExamineDesc][0] = 0;
		PlayerInfo[playerid][pFavStation][0] = 0;
		PlayerInfo[playerid][pReg] = 1;
		for(new i = 0; i < 12; i++) PlayerInfo[playerid][pBItems][i] = 0;
		for(new i = 0; i < MAX_MICROITEMS; i++)
		{
			PlayerInfo[playerid][mInventory][i] = 0;
			PlayerInfo[playerid][mPurchaseCount][i] = 0;
			PlayerInfo[playerid][mCooldown][i] = 0;
		}
		PlayerInfo[playerid][mBoost][0] = 0;
		PlayerInfo[playerid][mBoost][1] = 0;
		PlayerInfo[playerid][mShopCounter] = 0;
		PlayerInfo[playerid][mNotice] = 0;
		FIFInfo[playerid][FIFHours] = 0;
		FIFInfo[playerid][FIFChances] = 0;
		PlayerInfo[playerid][zFuelCan] = 0;
		PlayerInfo[playerid][bTicket] = 0;
		SetHealth(playerid, 50);
		SetArmour(playerid, 0);
		PlayerInfo[playerid][pLastPass][0] = 0;
		PlayerInfo[playerid][pEventTokens] = 0;
		PlayerInfo[playerid][pGroupToyBone] = 1;
		PlayerInfo[playerid][pGroupToy][0] = 0.0;
		PlayerInfo[playerid][pGroupToy][1] = 0.0;
		PlayerInfo[playerid][pGroupToy][2] = 0.0;
		PlayerInfo[playerid][pGroupToy][3] = 0.0;
		PlayerInfo[playerid][pGroupToy][4] = 0.0;
		PlayerInfo[playerid][pGroupToy][5] = 0.0;
		PlayerInfo[playerid][pGroupToy][6] = 1.0;
		PlayerInfo[playerid][pGroupToy][7] = 1.0;
		PlayerInfo[playerid][pGroupToy][8] = 1.0;

		PlayerInfo[playerid][pUsingTruck] = INVALID_VEHICLE_ID;
		PlayerInfo[playerid][pCurrentShipment] = -1;
	}

	if(PlayerInfo[playerid][pHospital] == 1)
	{
		PlayerInfo[playerid][pHospital] = 0;
		SetPVarInt(playerid, "MedicBill", 1);
	}
	if(PlayerInfo[playerid][pAdmin] < 2) { // If not admin, remove secondary tasks. More efficient because it's one check.
		PlayerInfo[playerid][pBanAppealer] = 0;
		PlayerInfo[playerid][pPR] = 0;
		PlayerInfo[playerid][pShopTech] = 0;
		PlayerInfo[playerid][pUndercover] = 0;
		PlayerInfo[playerid][pFactionModerator] = 0;
		PlayerInfo[playerid][pGangModerator] = 0;
		PlayerInfo[playerid][pAP] = 0;
		PlayerInfo[playerid][pHR] = 0;
		PlayerInfo[playerid][pBM] = 0;
	}
	if(PlayerInfo[playerid][pHelper] == 1 && PlayerInfo[playerid][pAdmin] >= 1) PlayerInfo[playerid][pHelper] = 0;
	if(gettime() >= PlayerInfo[playerid][pMechTime]) PlayerInfo[playerid][pMechTime] = 0;
	if(gettime() >= PlayerInfo[playerid][pLawyerTime]) PlayerInfo[playerid][pLawyerTime] = 0;
	if(gettime() >= PlayerInfo[playerid][pDrugsTime]) PlayerInfo[playerid][pDrugsTime] = 0;
	if(gettime() >= PlayerInfo[playerid][pSexTime]) PlayerInfo[playerid][pSexTime] = 0;

	HideMainMenuGUI(playerid);
	HideNoticeGUIFrame(playerid);
	
	if(PlayerInfo[playerid][pVIPExpire] > 0 && (1 <= PlayerInfo[playerid][pDonateRank] <= 4) && (PlayerInfo[playerid][pVIPExpire] < gettime()) && PlayerInfo[playerid][pAdmin] < 2)
	{
		format(string, sizeof(string), "%s(%d) (%s) VIP removed (VIP Expire: %d | Level: %d)", GetPlayerNameEx(playerid), GetPVarInt(playerid, "pSQLID"), GetPlayerIpEx(playerid), PlayerInfo[playerid][pVIPExpire], PlayerInfo[playerid][pDonateRank]);
		Log("logs/vipremove.log", string);
		PlayerInfo[playerid][pDonateRank] = 0;
		PlayerInfo[playerid][pVIPExpire] = 0;
		PlayerInfo[playerid][pVIPSellable] = 0;
	}

	if(PlayerInfo[playerid][pPendingRefReward] >= 1)
	{
	    new szQuery[128], szString[128];
	    if(PlayerInfo[playerid][pRefers] < 5 && PlayerInfo[playerid][pRefers] > 0)
	    {
		    PlayerInfo[playerid][pCredits] += CREDITS_AMOUNT_REFERRAL*PlayerInfo[playerid][pPendingRefReward];
			PlayerInfo[playerid][pPendingRefReward] = 0;
			PlayerInfo[playerid][pRefers]++;
			mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `accounts` SET `Credits`=%d WHERE `Username` = '%s'", PlayerInfo[playerid][pCredits], GetPlayerNameExt(playerid));
			mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
			format(szString, sizeof(szString), "%s(%d) has received %d credits for referring a player (The player reached level 3)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), CREDITS_AMOUNT_REFERRAL*PlayerInfo[playerid][pPendingRefReward]);
			Log("logs/referral.log", szString);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Your friend that you referred to the server has reached level 3, therefore you have received 100 credits.");
		}
	    else if(PlayerInfo[playerid][pRefers] == 5)
	    {
		    PlayerInfo[playerid][pCredits] += CREDITS_AMOUNT_REFERRAL*5*PlayerInfo[playerid][pPendingRefReward];
			PlayerInfo[playerid][pPendingRefReward] = 0;
			PlayerInfo[playerid][pRefers]++;
			mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `accounts` SET `Credits`=%d WHERE `Username` = '%s'", PlayerInfo[playerid][pCredits], GetPlayerNameExt(playerid));
			mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
			format(szString, sizeof(szString), "%s(%d) has received %d credits for referring a player (The player reached level 3)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), CREDITS_AMOUNT_REFERRAL*5*PlayerInfo[playerid][pPendingRefReward]);
			Log("logs/referral.log", szString);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Your friend that you referred to the server has reached level 3, therefore you have received 500 credits.");
		}
		else if(PlayerInfo[playerid][pRefers] < 10 && PlayerInfo[playerid][pRefers] > 5)
	    {
		    PlayerInfo[playerid][pCredits] += CREDITS_AMOUNT_REFERRAL*PlayerInfo[playerid][pPendingRefReward];
			PlayerInfo[playerid][pPendingRefReward] = 0;
			PlayerInfo[playerid][pRefers]++;
			mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `accounts` SET `Credits`=%d WHERE `Username` = '%s'", PlayerInfo[playerid][pCredits], GetPlayerNameExt(playerid));
			mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
			format(szString, sizeof(szString), "%s(%d) has received %d credits for referring a player (The player reached level 3)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), CREDITS_AMOUNT_REFERRAL*PlayerInfo[playerid][pPendingRefReward]);
			Log("logs/referral.log", szString);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Your friend that you referred to the server has reached level 3, therefore you have received 100 credits.");
		}
		else if(PlayerInfo[playerid][pRefers] == 10)
	    {
		    PlayerInfo[playerid][pCredits] += CREDITS_AMOUNT_REFERRAL*10*PlayerInfo[playerid][pPendingRefReward];
			PlayerInfo[playerid][pPendingRefReward] = 0;
			PlayerInfo[playerid][pRefers]++;
			mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `accounts` SET `Credits`=%d WHERE `Username` = '%s'", PlayerInfo[playerid][pCredits], GetPlayerNameExt(playerid));
			mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
			format(szString, sizeof(szString), "%s(%d) has received %d credits for referring a player (The player reached level 3)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), CREDITS_AMOUNT_REFERRAL*10*PlayerInfo[playerid][pPendingRefReward]);
			Log("logs/referral.log", szString);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Your friend that you referred to the server has reached level 3, therefore you have received 1000 credits.");
		}
		else if(PlayerInfo[playerid][pRefers] < 15 && PlayerInfo[playerid][pRefers] > 10)
	    {
		    PlayerInfo[playerid][pCredits] += CREDITS_AMOUNT_REFERRAL*PlayerInfo[playerid][pPendingRefReward];
			PlayerInfo[playerid][pPendingRefReward] = 0;
			PlayerInfo[playerid][pRefers]++;
			mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `accounts` SET `Credits`=%d WHERE `Username` = '%s'", PlayerInfo[playerid][pCredits], GetPlayerNameExt(playerid));
			mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
			format(szString, sizeof(szString), "%s(%d) has received %d credits for referring a player (The player reached level 3)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), CREDITS_AMOUNT_REFERRAL*PlayerInfo[playerid][pPendingRefReward]);
			Log("logs/referral.log", szString);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Your friend that you referred to the server has reached level 3, therefore you have received 100 credits.");
		}
		else if(PlayerInfo[playerid][pRefers] == 15)
	    {
		    PlayerInfo[playerid][pCredits] += CREDITS_AMOUNT_REFERRAL*15*PlayerInfo[playerid][pPendingRefReward];
			PlayerInfo[playerid][pPendingRefReward] = 0;
			PlayerInfo[playerid][pRefers]++;
			mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `accounts` SET `Credits`=%d WHERE `Username` = '%s'", PlayerInfo[playerid][pCredits], GetPlayerNameExt(playerid));
			mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
			format(szString, sizeof(szString), "%s(%d) has received %d credits for referring a player (The player reached level 3)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), CREDITS_AMOUNT_REFERRAL*15*PlayerInfo[playerid][pPendingRefReward]);
			Log("logs/referral.log", szString);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Your friend that you referred to the server has reached level 3, therefore you have received 1500 credits.");
		}
		else if(PlayerInfo[playerid][pRefers] < 20 && PlayerInfo[playerid][pRefers] > 15)
	    {
		    PlayerInfo[playerid][pCredits] += CREDITS_AMOUNT_REFERRAL*PlayerInfo[playerid][pPendingRefReward];
			PlayerInfo[playerid][pPendingRefReward] = 0;
			PlayerInfo[playerid][pRefers]++;
			mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `accounts` SET `Credits`=%d WHERE `Username` = '%s'", PlayerInfo[playerid][pCredits], GetPlayerNameExt(playerid));
			mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
			format(szString, sizeof(szString), "%s(%d) has received %d credits for referring a player (The player reached level 3)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), CREDITS_AMOUNT_REFERRAL*PlayerInfo[playerid][pPendingRefReward]);
			Log("logs/referral.log", szString);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Your friend that you referred to the server has reached level 3, therefore you have received 100 credits.");
		}
		else if(PlayerInfo[playerid][pRefers] == 20)
	    {
		    PlayerInfo[playerid][pCredits] += CREDITS_AMOUNT_REFERRAL*20*PlayerInfo[playerid][pPendingRefReward];
			PlayerInfo[playerid][pPendingRefReward] = 0;
			PlayerInfo[playerid][pRefers]++;
			mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `accounts` SET `Credits`=%d WHERE `Username` = '%s'", PlayerInfo[playerid][pCredits], GetPlayerNameExt(playerid));
			mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
			format(szString, sizeof(szString), "%s(%d) has received %d credits for referring a player (The player reached level 3)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), CREDITS_AMOUNT_REFERRAL*20*PlayerInfo[playerid][pPendingRefReward]);
			Log("logs/referral.log", szString);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Your friend that you referred to the server has reached level 3, therefore you have received 2000 credits.");
		}
        else if(PlayerInfo[playerid][pRefers] < 25 && PlayerInfo[playerid][pRefers] > 20)
	    {
		    PlayerInfo[playerid][pCredits] += CREDITS_AMOUNT_REFERRAL*PlayerInfo[playerid][pPendingRefReward];
			PlayerInfo[playerid][pPendingRefReward] = 0;
			PlayerInfo[playerid][pRefers]++;
			mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `accounts` SET `Credits`=%d WHERE `Username` = '%s'", PlayerInfo[playerid][pCredits], GetPlayerNameExt(playerid));
			mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
			format(szString, sizeof(szString), "%s(%d) has received %d credits for referring a player (The player reached level 3)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), CREDITS_AMOUNT_REFERRAL*PlayerInfo[playerid][pPendingRefReward]);
			Log("logs/referral.log", szString);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "Your friend that you referred to the server has reached level 3, therefore you have received 100 credits.");
		}
		else if(PlayerInfo[playerid][pRefers] >= 25)
	    {
		    PlayerInfo[playerid][pCredits] += CREDITS_AMOUNT_REFERRAL*25*PlayerInfo[playerid][pPendingRefReward];
			PlayerInfo[playerid][pPendingRefReward] = 0;
			PlayerInfo[playerid][pRefers]++;
			mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `accounts` SET `Credits`=%d WHERE `Username` = '%s'", PlayerInfo[playerid][pCredits], GetPlayerNameExt(playerid));
			mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
			format(szString, sizeof(szString), "%s(%d) has received %d credits for referring a player (The player reached level 3)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), CREDITS_AMOUNT_REFERRAL*25*PlayerInfo[playerid][pPendingRefReward]);
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

			foreach(new j: Player)
			{			
				if(PlayerInfo[j][pBusiness] == Business) {
					PlayerInfo[j][pBusiness] = INVALID_BUSINESS_ID;
					PlayerInfo[j][pBusinessRank] = 0;
					SendClientMessageEx(playerid, COLOR_WHITE, "An admin has sold this business, your business stats have been reset.");
				}
			}	

			Businesses[Business][bOwner] = -1;
			Businesses[Business][bMonths] = 0;
			Businesses[Business][bValue] = 0;
			SaveBusiness(Business);
			RefreshBusinessPickup(Business);

			mysql_format(MainPipeline, string, sizeof(string), "UPDATE `accounts` SET `Business` = "#INVALID_BUSINESS_ID", `BusinessRank` = 0 WHERE `Business` = '%d'", Business);
			mysql_tquery(MainPipeline, string, "OnQueryFinish", "i", SENDDATA_THREAD);

	        SendClientMessageEx(playerid, COLOR_RED, "Your business has been removed as it has expired.");
	        format(string, sizeof(string), "[BUSINESS EXPIRED] %s(%d) business id %i has been removed as it has expired.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), Business);
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
	if(PlayerInfo[playerid][pDonateRank] >= 4 && PlayerInfo[playerid][pArmsSkill] < 1200)
	{
		PlayerInfo[playerid][pArmsSkill] = 1200;
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
		PlayerInfo[playerid][pToggledChats][0] = 0;
	}
	if (PlayerInfo[playerid][pHelper] == 1)
	{
		PlayerInfo[playerid][pToggledChats][0] = 0;
	}
	if(PlayerInfo[playerid][pAdmin] != 0 && PlayerInfo[playerid][pAdmin] != 1 && PlayerInfo[playerid][pAdmin] != 2 && PlayerInfo[playerid][pAdmin] != 3 && PlayerInfo[playerid][pAdmin] != 4 &&PlayerInfo[playerid][pAdmin] != 1337 && PlayerInfo[playerid][pAdmin] != 1338 && PlayerInfo[playerid][pAdmin] != 99999)
	{
		new name[MAX_PLAYER_NAME];
		GetPlayerName(playerid, name, sizeof(name));
		format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s has attempted to log in with Admin Level %d.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pAdmin]);
		ABroadCast( COLOR_YELLOW, string, 4 );
		format(string, sizeof(string), "%s(%d) has attempted to log in with Admin Level %d.", name, GetPlayerSQLId(playerid), PlayerInfo[playerid][pAdmin]);
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

			new year, month, day, tmphour, tmpminute, tmpsecond, query[300];
			gettime(tmphour, tmpminute, tmpsecond);
			FixHour(tmphour);
			getdate(year, month, day);	
			format(string, sizeof(string), "SERVER: You are logged in as a %s{FFFFFF}.", GetStaffRank(playerid));
			mysql_format(MainPipeline, query, sizeof(query), "SELECT b.shift, b.needs_%s, COUNT(DISTINCT s.id) as ShiftCount FROM cp_shift_blocks b LEFT JOIN cp_shifts s ON b.shift_id = s.shift_id AND s.date = '%d-%02d-%02d' AND s.status >= 2 AND s.type = 1 WHERE b.time_start = '%02d:00:00' GROUP BY b.shift, b.needs_%s", GetWeekday(), year, month, day, tmphour, GetWeekday());
			mysql_tquery(MainPipeline, query, "GetShiftInfo", "is", playerid, string);
			format(string, sizeof(string), "SERVER: %s has logged in as a %s{FFFFFF}.", GetPlayerNameEx(playerid), GetStaffRank(playerid));
		}

		foreach(new i: Player)
		{
			if(PlayerInfo[i][pAdmin] >= 1337 && PlayerInfo[i][pAdmin] >= PlayerInfo[playerid][pAdmin]) SendClientMessageEx(i, COLOR_WHITE, string);
		}	
	}
	
	if(((0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS)) && (PlayerInfo[playerid][pAdmin] < 2 || (PlayerInfo[playerid][pAdmin] >= 2 && PlayerInfo[playerid][pTogReports])))
	{
		new badge[12], employer[GROUP_MAX_NAME_LEN], rank[GROUP_MAX_RANK_LEN], division[GROUP_MAX_DIV_LEN];
		if(strcmp(PlayerInfo[playerid][pBadge], "None", true) != 0) format(badge, sizeof(badge), "[%s] ", PlayerInfo[playerid][pBadge]);
		GetPlayerGroupInfo(playerid, rank, division, employer);
		if(IsACop(playerid))
		{
			if(PlayerInfo[playerid][pDuty])
			{
				format(string, sizeof(string), "** %s%s %s is in service **", badge, rank, GetPlayerNameEx(playerid));
				foreach(new i: Player) 
				{
					if(PlayerInfo[i][pToggledChats][12] == 0)
					{
						if(PlayerInfo[i][pMember] == PlayerInfo[playerid][pMember]) SendClientMessageEx(i, arrGroupData[PlayerInfo[playerid][pMember]][g_hRadioColour] * 256 + 255, string);
					}
				}
			}
			format(string, sizeof string, "%s%s has logged in.", badge, GetPlayerNameEx(playerid));
			GroupLog(PlayerInfo[playerid][pMember], string);
		}
		else if((0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS) && !IsACop(playerid))
		{
			if(PlayerInfo[playerid][pDuty] || arrGroupData[PlayerInfo[playerid][pMember]][g_iGroupType] == GROUP_TYPE_CRIMINAL)
			{
				format(string, sizeof(string), "** %s%s %s is now available **", badge, rank, GetPlayerNameEx(playerid));
				foreach(new i: Player) 
				{
					if(PlayerInfo[i][pToggledChats][12] == 0)
					{
						if(PlayerInfo[i][pMember] == PlayerInfo[playerid][pMember]) SendClientMessageEx(i, arrGroupData[PlayerInfo[playerid][pMember]][g_hRadioColour] * 256 + 255, string);
					}
				}
			}
			format(string, sizeof string, "%s%s has logged in.", badge, GetPlayerNameEx(playerid));
			GroupLog(PlayerInfo[playerid][pMember], string);
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

	if(PlayerInfo[playerid][pTut] != -1) 
	{
		if(PlayerInfo[playerid][pTut] < 14) PlayerInfo[playerid][pTut] = 0;
		AdvanceTutorial(playerid);
	}
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
	
	if(PlayerInfo[playerid][pWatchdog] > 0)
	{
		new tdate[11], thour[9], i_timestamp[3];
		getdate(i_timestamp[0], i_timestamp[1], i_timestamp[2]);
		format(tdate, sizeof(tdate), "%d-%02d-%02d", i_timestamp[0], i_timestamp[1], i_timestamp[2]);
		format(thour, sizeof(thour), "%02d:00:00", hour);
		GetWDCount(playerid, tdate);
		GetWDHourCount(playerid, thour, tdate);
	}

	if(PlayerInfo[playerid][pWarns] >= 3)
	{
		PlayerInfo[playerid][pWarns] = 0;
		//CreateBan(INVALID_PLAYER_ID, PlayerInfo[playerid][pId], playerid, PlayerInfo[playerid][pIP], "3 Warnings", 14);
		//return 1;
	}

	TogglePlayerSpectating(playerid, 0);
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
			SetPVarInt(playerid, "CAChat", 1);
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
	mysql_format(MainPipeline, string, sizeof(string), "SELECT * FROM `rentedcars` WHERE `sqlid` = '%d'", GetPlayerSQLId(playerid));
	mysql_tquery(MainPipeline, string, "LoadRentedCar", "i", playerid);

	if(0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS)
	{
		
		for(new i = 0; i < 3; i++)
		{
			format(string, sizeof(string), "MOTD: %s", gMOTD[PlayerInfo[playerid][pMember]][i]);
			SendClientMessageEx(playerid, arrGroupData[PlayerInfo[playerid][pMember]][g_hDutyColour] * 256 + 255, string);
		}
	}

	if(IsAHitman(playerid))
	{
		format(szMiscArray, sizeof szMiscArray, "Agency MOTD: %s", HMAMOTD);
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMiscArray);
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
				mysql_format(MainPipeline, szQuery, sizeof(szQuery), "UPDATE `accounts` SET `LastBirthday`=%d WHERE `Username` = '%s'", PlayerInfo[playerid][pLastBirthday], GetPlayerNameExt(playerid));
				mysql_tquery(MainPipeline, szQuery, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);
			}
		}
		else
		{
			DeletePVar(playerid, "pBirthday");
		}
	}
	DayDedicatedPlayer(playerid);
	if(GetPVarInt(playerid, "pBirthday") == 1)
	{
		if(PlayerInfo[playerid][pReceivedBGift] != 1)
		{
			PlayerInfo[playerid][pReceivedBGift] = 1;
			GiftPlayer(MAX_PLAYERS, playerid);
			format(string, sizeof(string), "Happy Birthday %s! You have received a free gift!", GetPlayerNameEx(playerid));
			SendClientMessageEx(playerid, COLOR_YELLOW, string);
			format(string, sizeof(string), "%s(%d) has received a free gift for his birthday (%s) (OnPlayerLoad).", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), PlayerInfo[playerid][pBirthDate]);
			Log("logs/birthday.log", string);
			OnPlayerStatsUpdate(playerid);
		}
		SendClientMessageEx(playerid, COLOR_YELLOW, "Gold VIP: You will get x2 paycheck as a birthday gift today.");
	}
	else
	{
		PlayerInfo[playerid][pReceivedBGift] = 0;
	}	
	// Auto Levels
	if(PlayerInfo[playerid][pAdmin] < 2) LevelCheck(playerid);
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
		mysql_format(MainPipeline, string, sizeof(string), "SELECT `id` FROM `zombie` WHERE `id` = '%d'", GetPlayerSQLId(playerid));
		mysql_tquery(MainPipeline, string, "OnZombieCheck", "i", playerid);
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

	if(PlayerInfo[playerid][pAdmin] < 2 && PlayerInfo[playerid][pWatchdog] == 0 && !IsValidName(GetPlayerNameExt(playerid)))
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You have been kicked for having a Non RP Name.");
		SetPVarString(playerid, "KickNonRP", GetPlayerNameEx(playerid));
		SetTimerEx("KickNonRP", 3000, false, "i", playerid);
	}
	new year, month, day;
	getdate(year, month, day);
	if(PlayerInfo[playerid][pReceivedPrize] == 0)
	{
		if(month == 12 && day == 22 && year == 2016)
		{
			new icount = GetPlayerToySlots(playerid), success = 0;
			for(new v = 0; v < icount; v++)
			{
				if(PlayerToyInfo[playerid][v][ptModelID] == 0)
				{
					PlayerToyInfo[playerid][v][ptModelID] = 19065;
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
					PlayerToyInfo[playerid][v][ptAutoAttach] = -2;
					SendClientMessageEx(playerid, COLOR_GRAD2, "You've been gifted a santa hat toy! Merry Christmas!");
					
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
						PlayerToyInfo[playerid][i][ptModelID] = 19065;
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
						PlayerToyInfo[playerid][i][ptAutoAttach] = -2;
						
						g_mysql_NewToy(playerid, i); 
						
						PlayerInfo[playerid][pReceivedPrize] = 1;
						SendClientMessageEx(playerid, COLOR_GRAD2, "You've been gifted a santa hat toy! Merry Christmas!");
						SendClientMessageEx(playerid, COLOR_GRAD1, "Due to you not having any available slots, we've temporarily gave you an additional slot to use/sell/trade your toy.");
						SendClientMessageEx(playerid, COLOR_RED, "Note: Please take note that after selling the toy, the temporarily additional toy slot will be removed.");
						break;
					}	
				}
			}
			print("Object ID: 19065");
		}
		if(PlayerInfo[playerid][pConnectHours] > 7 && month == 12 && day == 31 && year == 2016)
		{
			PlayerInfo[playerid][pFirework] += 5;
			PlayerInfo[playerid][pReceivedPrize] = 1;
			SendClientMessageEx(playerid, COLOR_GRAD2, "You've been gifted 5 fireworks to celebrate the new year!");
		}
	}
	
	if(PlayerInfo[playerid][pWatchdog] >= 1)
	{
		PlayerInfo[playerid][pToggledChats][17] = 0;
	}
	if(PlayerInfo[playerid][pVIPMod])
	{
		SetPVarInt(playerid, "vStaffChat", 1);
	}
	if(PlayerInfo[playerid][pSEC] >= 1) SetPVarInt(playerid, "SECChat", 1);
	CreateAccountRestTextdraw(playerid);
	if(PlayerInfo[playerid][pAccountRestricted] == 1)
	{
		PlayerTextDrawShow(playerid, AccountRestriction[playerid]);
		PlayerTextDrawShow(playerid, AccountRestrictionEx[playerid]);
	}

	//PVars for filterscripts
	if(PlayerInfo[playerid][pAdmin] >= 1) SetPVarInt(playerid, "aLvl", PlayerInfo[playerid][pAdmin]);
	if(PlayerInfo[playerid][pHelper] >= 1) SetPVarInt(playerid, "hLvl", PlayerInfo[playerid][pHelper]);
	if(PlayerInfo[playerid][pMember] != INVALID_GROUP_ID) SetPVarInt(playerid, "fLvl", PlayerInfo[playerid][pMember]);
	
	new szQuery[128];
	mysql_format(MainPipeline, szQuery, sizeof(szQuery), "SELECT * FROM `nonrppoints` WHERE `sqlid` = '%d' AND `active` = '1'", GetPlayerSQLId(playerid));
	mysql_tquery(MainPipeline, szQuery, "CheckClientWatchlist", "i", playerid);
	mysql_format(MainPipeline, szQuery, sizeof(szQuery), "SELECT `id`, `Subject` FROM `bugs` WHERE `status` = 6 AND `Userid` = %d", GetPlayerSQLId(playerid));
	mysql_tquery(MainPipeline, szQuery, "CheckPendingBugReports", "i", playerid);
	defer CheckVehiclesLeftSpawned(playerid);


	//mysql_format(MainPipeline, szQuery, sizeof(szQuery), "SELECT COUNT(*) as aFlagCount FROM `flags` WHERE id=%d AND type = 2", GetPlayerSQLId(playerid));
	//mysql_tquery(MainPipeline, szQuery, "FlagQueryFinish", "iii", playerid, INVALID_PLAYER_ID, 4);

	mysql_format(MainPipeline, szQuery, sizeof(szQuery), "SELECT COUNT(*) as aFlagCount FROM `flags` WHERE id=%d AND type = 2", GetPlayerSQLId(playerid));
	mysql_tquery(MainPipeline, szQuery,"FlagQueryFinish", "iii", playerid, INVALID_PLAYER_ID, 4);




	if(PlayerInfo[playerid][mPurchaseCount][1] && PlayerInfo[playerid][mCooldown][1]) format(string, sizeof(string), "You currently have a active Job Boost for the %s job for another %d minute(s).", GetJobName(PlayerInfo[playerid][mBoost][0]), PlayerInfo[playerid][mCooldown][1]), SendClientMessageEx(playerid, -1, string);
	if(PlayerInfo[playerid][mCooldown][4] && PlayerInfo[playerid][mCooldown][4]) format(string, sizeof(string), "You currently have a active Energy Bar for another %d minute(s).", PlayerInfo[playerid][mCooldown][4]), SendClientMessageEx(playerid, -1, string);
	if(PlayerInfo[playerid][mPurchaseCount][12] && PlayerInfo[playerid][mCooldown][12]) format(string, sizeof(string), "You currently have a active Quick Bank Access for another %d minute(s).", PlayerInfo[playerid][mCooldown][12]), SendClientMessageEx(playerid, -1, string);
	if(PlayerInfo[playerid][pPhousekey] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[playerid][pPhousekey]][hSignExpire]) format(string, sizeof(string), "Your first house has a active House Sale Sign for another %s", ConvertTimeS(HouseInfo[PlayerInfo[playerid][pPhousekey]][hSignExpire]-gettime())), SendClientMessageEx(playerid, -1, string);
	if(PlayerInfo[playerid][pPhousekey2] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[playerid][pPhousekey2]][hSignExpire]) format(string, sizeof(string), "Your second house has a active House Sale Sign for another %s", ConvertTimeS(HouseInfo[PlayerInfo[playerid][pPhousekey2]][hSignExpire]-gettime())), SendClientMessageEx(playerid, -1, string);
	if(PlayerInfo[playerid][pPhousekey3] != INVALID_HOUSE_ID && HouseInfo[PlayerInfo[playerid][pPhousekey3]][hSignExpire]) format(string, sizeof(string), "Your third house has a active House Sale Sign for another %s", ConvertTimeS(HouseInfo[PlayerInfo[playerid][pPhousekey3]][hSignExpire]-gettime())), SendClientMessageEx(playerid, -1, string);
	if(zombieevent && PlayerInfo[playerid][mInventory][18]) format(string, sizeof(string), "You currently have a antibiotic flowing through your bloodstream protecting you from %d zombie bite(s).", PlayerInfo[playerid][mInventory][18]), SendClientMessageEx(playerid, -1, string);

	if((PlayerInfo[playerid][pInsurance] == HOSPITAL_LSVIP || PlayerInfo[playerid][pInsurance] == HOSPITAL_SFVIP || PlayerInfo[playerid][pInsurance] == HOSPITAL_LVVIP || PlayerInfo[playerid][pInsurance] == HOSPITAL_HOMECARE) && !PlayerInfo[playerid][pDonateRank]) PlayerInfo[playerid][pInsurance] = random(2);
	if(PlayerInfo[playerid][pForcePasswordChange] == 1) ShowLoginDialogs(playerid, 0);
	if(!fexist("NoWhitelist.h")) CountryCheck(playerid);
	if(2 <= PlayerInfo[playerid][pAdmin] <= 4) ResetPlayerCash(playerid), PlayerInfo[playerid][pAccount] = 0;
	CallLocalFunction("NotifyInactiveStatus", "i", playerid);
	if(PlayerInfo[playerid][pTut] && emailcheck) InvalidEmailCheck(playerid, PlayerInfo[playerid][pEmail], 1);
	if(month == 4 && (day == 25 || day == 26)) // NGG B-Day 2015
	{
		if(PlayerInfo[playerid][pLevel] >= 3 && !PlayerInfo[playerid][pDonateRank])
		{
			PlayerInfo[playerid][pDonateRank] = 2;
			PlayerInfo[playerid][pTempVIP] = 0;
			PlayerInfo[playerid][pBuddyInvited] = 0;
			PlayerInfo[playerid][pVIPSellable] = 1;
			PlayerInfo[playerid][pVIPExpire] = 1430110800;
			LoadPlayerDisabledVehicles(playerid);
			SendClientMessageEx(playerid, -1, "You have been gifted Silver VIP for playing on NGG's B-Day weekend!");
		}
		if(PlayerInfo[playerid][pDonateRank] == 4 && !PlayerInfo[playerid][pReceivedPrize])
		{
			PlayerInfo[playerid][pEventTokens] += 10;
			PlayerInfo[playerid][pReceivedPrize] = 1;
			SendClientMessageEx(playerid, -1, "You have been given 10 event tokens for logging in as a PVIP!");
		}
	}
	//if(PlayerInfo[playerid][pChatbox][19] == 0) PlayerTextDrawShow(playerid, TD_ChatBox[0]);

	if(PlayerInfo[playerid][pToggledChats][7]) PhoneOnline[playerid] = 1;

	if(PlayerInfo[playerid][pTut] == -1 && PlayerInfo[playerid][pNation] != 0 && PlayerInfo[playerid][pNation] != 1) return ShowPlayerDialogEx(playerid, DIALOG_REGISTER_NATION, DIALOG_STYLE_LIST, "You currently do not have a nation. Please chose one.", "San Andreas\nNew Robada", "Select", "<<");
	return 1;
}

forward OnFreeGift(playerid, date[]);
public OnFreeGift(playerid, date[]) {

	return 1;
}