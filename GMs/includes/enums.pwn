/*
    	 		 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
				| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
				| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
				| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
				| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
				| $$\  $$$| $$  \ $$        | $$  \ $$| $$
				| $$ \  $$|  $$$$$$/        | $$  | $$| $$
				|__/  \__/ \______/         |__/  |__/|__/

//--------------------------------[ENUMS.PWN]--------------------------------


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

enum eGroupData {
	g_iGroupType,
	g_szGroupMOTD[GROUP_MAX_MOTD_LEN],
	g_szGroupName[GROUP_MAX_NAME_LEN],
	g_iLockerGuns[MAX_GROUP_WEAPONS],
	g_iLockerCost[MAX_GROUP_WEAPONS],
	g_iAllegiance,
	g_iBugAccess,
	g_iRadioAccess,
	g_iDeptRadioAccess,
	g_iIntRadioAccess,
	g_iGovAccess,
	g_hDutyColour,
	g_hRadioColour,
	g_iLockerStock,
	g_iFreeNameChange,
	g_iSpikeStrips,
	g_iBarricades,
	g_iCones,
	g_iFlares,
	g_iBarrels,
	g_iLadders,
	g_iBudget,
	g_iBudgetPayment,
	Float: g_fCratePos[3],
	g_iPaycheck[MAX_GROUP_RANKS],
	g_iCrateIsland,
	Text3D: g_tCrate3DLabel,
	g_iLockerCostType,
	g_iCratesOrder,
	g_iJCount,
	g_iTackleAccess,
	Float: g_fGaragePos[3],
	g_iWheelClamps,
	g_iDoCAccess
}

enum eLockerData {
	g_iLockerSQLId,
	Float: g_fLockerPos[3],
	g_iLockerVW,
	g_iLockerShare,
	Text3D: g_tLocker3DLabel
}

enum eJurisdictionData {
	g_iJurisdictionSQLId,
	g_iAreaName[64]
}

enum eGroupVehData {
	gv_iSQLID,
	gv_iDisabled, // is equal to 1 when a car has been despawned due to a group not being able to afford it | 2 for dvstorage
	gv_iSpawnedID, // In-game spawned ID of vehicle
	gv_igID, // ID of group (faction) (0 if unrestricted - for civilian use)
	gv_igDivID, // ID of division restriction (0 if unrestricted)
	gv_irID, // ID of rank restriction (0 if unrestricted)
	gv_ifID, // ID of family (0 if unrestricted)
	gv_iType, // (0 - standard | 1 - Crate Transport)
	gv_iLoadMax, //(ie if type is set to 1, and vLoadMax set to 2, car will have a max capacity of 2 crates)
	gv_iModel, // Model of Vehicle
	gv_iPlate[32],
	Float:gv_fMaxHealth, //Maximum Health of Vehicle
	Float:gv_fFuel, // gas level of the vehicle
	gv_iCol1, // Color 1
	gv_iCol2, // Color 2
	gv_iVW,
	gv_iInt,
	Float:gv_fX, // X axis
	Float:gv_fY, // Y axis
	Float:gv_fZ, // Z axis
	Float:gv_fRotZ, // Vehicle Z Rotation
	gv_iUpkeep, // Upkeep fee - costs faction $
	gv_iMod[15],
	gv_iAttachedObjectID[2],
	gv_iAttachedObjectModel[2], // For permanently attached vehicle objects.. ie lightbar, neons
	Float:gv_fObjectX[2],
	Float:gv_fObjectY[2],
	Float:gv_fObjectZ[2],
	Float:gv_fObjectRX[2],
	Float:gv_fObjectRY[2],
	Float:gv_fObjectRZ[2],
}

enum eBiz {
    bName[MAX_BUSINESS_NAME],
	bOwner,
	bOwnerName[MAX_PLAYER_NAME],
	bValue,
	bType,
	bLevel,
	bLevelProgress,
	bAutoSale,
	bSafeBalance,
	bInventory,
	bInventoryCapacity,
	bStatus,
	bRankPay[6],
	Float: bExtPos[4],
	Float: bIntPos[4],
	Float: bSupplyPos[3],
	bInt,
	bVW,
	bMinInviteRank,
	bMinGiveRankRank,
	bMinSupplyRank,
	bMinSafeRank,
	bMinInventoryRank,
	bMinStatusRank,
	bMinDoorRank,
	bGunsOffered[31],
	bSkinsOffered[300],
	bToysOffered[100],
	bItemPrices[18],
	bTotalSales,
	bTotalProfits,
	Text3D: bStateText,
	Text3D: bDoorText,
	Text3D: bSupplyText,
	bPickup,
	bAutoPay,
	Float: bGasPrice,
	bStrictPrice,
	bOrderBy[MAX_PLAYER_NAME],
	bOrderState,
	bOrderAmount,
	bOrderDate[30],
	bCustomExterior,
	bCustomInterior,
	bGrade,

	Float: GasPumpPosX[MAX_BUSINESS_GAS_PUMPS],
	Float: GasPumpPosY[MAX_BUSINESS_GAS_PUMPS],
	Float: GasPumpPosZ[MAX_BUSINESS_GAS_PUMPS],
	Float: GasPumpAngle[MAX_BUSINESS_GAS_PUMPS],
	Float: GasPumpCapacity[MAX_BUSINESS_GAS_PUMPS],
	Float: GasPumpGallons[MAX_BUSINESS_GAS_PUMPS],
	GasPumpObjectID[MAX_BUSINESS_GAS_PUMPS],
	Text3D: GasPumpInfoTextID[MAX_BUSINESS_GAS_PUMPS],
	Text3D: GasPumpSaleTextID[MAX_BUSINESS_GAS_PUMPS],
	Float: GasPumpSaleGallons[MAX_BUSINESS_GAS_PUMPS],
	Float: GasPumpSalePrice[MAX_BUSINESS_GAS_PUMPS],
	GasPumpTimer[MAX_BUSINESS_GAS_PUMPS],
	GasPumpVehicleID[MAX_BUSINESS_GAS_PUMPS],

	Float: bParkPosX[MAX_BUSINESS_DEALERSHIP_VEHICLES],
	Float: bParkPosY[MAX_BUSINESS_DEALERSHIP_VEHICLES],
	Float: bParkPosZ[MAX_BUSINESS_DEALERSHIP_VEHICLES],
	Float: bParkAngle[MAX_BUSINESS_DEALERSHIP_VEHICLES],

	Float: bPurchaseX[MAX_BUSINESS_DEALERSHIP_VEHICLES],
	Float: bPurchaseY[MAX_BUSINESS_DEALERSHIP_VEHICLES],
	Float: bPurchaseZ[MAX_BUSINESS_DEALERSHIP_VEHICLES],
	Float: bPurchaseAngle[MAX_BUSINESS_DEALERSHIP_VEHICLES],

	bColor1[MAX_BUSINESS_DEALERSHIP_VEHICLES],
	bColor2[MAX_BUSINESS_DEALERSHIP_VEHICLES],
	bModel[MAX_BUSINESS_DEALERSHIP_VEHICLES],
	bPrice[MAX_BUSINESS_DEALERSHIP_VEHICLES],
	Float: bHealth[MAX_BUSINESS_DEALERSHIP_VEHICLES],
	Float: bFuel[MAX_BUSINESS_DEALERSHIP_VEHICLES],
	Lock[MAX_BUSINESS_DEALERSHIP_VEHICLES],
	bVehID[MAX_BUSINESS_DEALERSHIP_VEHICLES],
	DealershipVehStock[MAX_BUSINESS_DEALERSHIP_VEHICLES],
	DealershipVehOrder[MAX_BUSINESS_DEALERSHIP_VEHICLES],
	Text3D:bVehicleLabel[MAX_BUSINESS_DEALERSHIP_VEHICLES],
	bMonths,

	bGymEntryFee,
	bGymType, // 1 = swimming pool
	bGymBoxingArena1[2],
	bGymBoxingArena2[2],
	bGymBikePlayers[10],
	bGymBikeVehicles[10]
}

enum StoreItemCostEnum
{
	ItemValue
}

enum CargoArrayData
{
	Float:PosX,
	Float:PosY,
	Float:PosZ
}

enum WeaponsEnum
{
	WeaponId,
	WeaponMats,
	WeaponMinLevel
}

enum pkrInfo
{
	pkrActive,
	pkrPlaced,
	pkrObjectID,
	pkrMiscObjectID[MAX_POKERTABLEMISCOBJS],
	Text3D:pkrText3DID,
	Float:pkrX,
	Float:pkrY,
	Float:pkrZ,
	Float:pkrRX,
	Float:pkrRY,
	Float:pkrRZ,
	pkrVW,
	pkrInt,
	pkrPlayers,
	pkrActivePlayers,
	pkrActiveHands,
	pkrSlot[6],
	pkrPass[32],
	pkrLimit,
	pkrPulseTimer,
	pkrBuyInMax,
	pkrBuyInMin,
	pkrBlind,
	pkrTinkerLiveTime,
	pkrDelay,
	pkrSetDelay,
	pkrPos,
	pkrRotations,
	pkrSlotRotations,
	pkrActivePlayerID,
	pkrActivePlayerSlot,
	pkrRound,
	pkrStage,
	pkrActiveBet,
	pkrDeck[52],
	pkrCCards[5],
	pkrPot,
	pkrWinners,
	pkrWinnerID,
};

enum ShopItem
{
	sItemPrice,
	//sSold,
	//sMade,
}

enum cVehicleLoad
{
	vCrateAmt,
	vCrateID[6],
	vForkLoaded,
	vForkObject,
	vCarVestKit,
	vCarWindows,
	vLastDriver[MAX_PLAYER_NAME],
}

enum crateInfo
{
	crActive,
	crObject,
	crInt,
	crVW,
	crPlacedBy[MAX_PLAYER_NAME],
	Float: crX,
	Float: crY,
	Float: crZ,
	GunQuantity,
	InVehicle,
	Text3D: crLabel,
}

enum Auction
{
    BiddingFor[64],
	InProgress,
	Bid,
	Bidder,
	Expires,
	Wining[MAX_PLAYER_NAME],
	Increment,
	Timer,
}

enum Barrel
{
	Float:sX,
	Float:sY,
	Float:sZ,
	sObjectID,
	sDeployedBy[MAX_PLAYER_NAME],
	sDeployedByStatus,
	sDeployedAt[MAX_ZONE_NAME]
}

enum Barricade
{
	Float:sX,
	Float:sY,
	Float:sZ,
	sObjectID,
	sObject,
	sDeployedBy[MAX_PLAYER_NAME],
	sDeployedByStatus,
	sDeployedAt[MAX_ZONE_NAME]
}

enum Flare
{
	Float:sX,
	Float:sY,
	Float:sZ,
	sObjectID,
	sDeployedBy[MAX_PLAYER_NAME],
	sDeployedByStatus,
	sDeployedAt[MAX_ZONE_NAME]
}

enum Cone
{
	Float:sX,
	Float:sY,
	Float:sZ,
	sObjectID,
	sDeployedBy[MAX_PLAYER_NAME],
	sDeployedByStatus,
	sDeployedAt[MAX_ZONE_NAME]
}

enum Spikes
{
	Float:sX,
	Float:sY,
	Float:sZ,
	sObjectID,
	sPickupID,
	sDeployedBy[MAX_PLAYER_NAME],
	sDeployedByStatus,
	sDeployedAt[MAX_ZONE_NAME]
}

enum Ladder
{
	Float:sX,
	Float:sY,
	Float:sZ,
	sObjectID,
	sPickupID,
	sDeployedBy[MAX_PLAYER_NAME],
	sDeployedByStatus,
	sDeployedAt[MAX_ZONE_NAME]
}

enum Plant
{
	 pOwner,
	 pObject,
	 pPlantType,
	Float: pPos[3],
	 pVirtual,
	 pInterior,
	 pGrowth,
	 pExpires,
	pDrugsSkill,
	pObjectSpawned,
}

enum BusinessSale
{
	bID,
	bBusinessID,
	 bText[128],
	 bPrice,
	 bAvailable,
	 bPurchased,
	 bType,
}

enum SAZONE_MAIN { //Betamaster
	SAZONE_NAME[28],
	Float:SAZONE_AREA[6]
};

enum MAIN_ZONES { //Betamaster
	SAZONE_NAME[28],
	Float:SAZONE_AREA[6]
};

enum callinfo
{
	HasBeenUsed,
	Area[28],
	MainZone[28],
	Description[128],
	CallFrom,
	RespondingID,
	Type,
 	TimeToExpire,
	BeingUsed,
	CallExpireTimer,
	ReplyTimerr,
	CallVehicleId
}

enum reportinfo
{
	HasBeenUsed,
	Report[128],
	ReportFrom,
	CheckingReport,
 	TimeToExpire,
	BeingUsed,
	ReportExpireTimer,
	ReplyTimerr,
	ReportPriority,
	ReportLevel
}

enum pBoxingStats
{
	TitelName[128],
	TitelWins,
	TitelLoses,
};

enum EventKernelEnum
{
	EventAdvisor,
	EventStatus,
	EventType,
	EventInfo[128],
	Float: EventHealth,
	Float: EventArmor,
	Float: EventPositionX,
	Float: EventPositionY,
	Float: EventPositionZ,
	EventInterior,
	EventWorld,
	EventWeapons[5],
	EventTeamColor[2],
    EventTeamSkin[2],
    EventLimit,
    EventTime,
	EventFootRace,
    EventPlayers,
    EventRequest,
    EventStartRequest,
    EventCreator,
    EventStaff[5],
    EventJoinStaff,
	EventCustomInterior,
    VipOnly,
    Float: EventTeamPosX1,
    Float: EventTeamPosY1,
    Float: EventTeamPosZ1,
    Float: EventTeamPosX2,
    Float: EventTeamPosY2,
    Float: EventTeamPosZ2
}

enum PaintBallArenaEnum
{
	pbSQLId,
	pbArenaName[64],
	pbOwner[MAX_PLAYER_NAME],
	pbPassword[64],
	pbActive,
	pbExploitPerm,
	pbFlagInstagib,
	pbFlagNoWeapons,
	pbTimeLeft,
	pbGameType,
	pbLocked,
	pbLimit,
	pbPlayers,
	pbTeamRedKills,
	pbTeamRedDeaths,
	pbTeamRedScores,
	pbTeamBlueKills,
	pbTeamBlueDeaths,
	pbTeamBlueScores,
	pbTeamRed,
	pbTeamBlue,
	Float:pbHillX,
	Float:pbHillY,
	Float:pbHillZ,
	Float:pbHillRadius,
	Text3D:pbHillTextID,
	pbWorldBonds[3],
	pbBidMoney,
	pbMoneyPool,
	pbWeapons[3],
	pbVirtual,
	pbInterior,
	pbFlagRedActive,
	pbFlagBlueActive,
	pbFlagRedActiveTime,
	pbFlagBlueActiveTime,
	Text3D:pbTeamRedTextID,
	Text3D:pbTeamBlueTextID,
	Text3D:pbFlagRedTextID,
	Text3D:pbFlagBlueTextID,
	pbFlagRedID,
	pbFlagBlueID,
	Float: pbHealth,
	Float: pbArmor,
	Float: pbFlagRedSpawn[3],
	Float: pbFlagBlueSpawn[3],
	Float: pbFlagRedPos[3],
	Float: pbFlagBluePos[3],
	Float: pbDeathmatch1[4],
	Float: pbDeathmatch2[4],
	Float: pbDeathmatch3[4],
	Float: pbDeathmatch4[4],
	Float: pbTeamRed1[4],
	Float: pbTeamRed2[4],
	Float: pbTeamRed3[4],
	Float: pbTeamBlue1[4],
	Float: pbTeamBlue2[4],
	Float: pbTeamBlue3[4],
	pbWar,
	pbVeh1Model,
	pbVeh1ID,
	Float: pbVeh1X,
	Float: pbVeh1Y,
	Float: pbVeh1Z,
	Float: pbVeh1A,
	pbVeh2Model,
	pbVeh2ID,
	Float: pbVeh2X,
	Float: pbVeh2Y,
	Float: pbVeh2Z,
	Float: pbVeh2A,
	pbVeh3Model,
	pbVeh3ID,
	Float: pbVeh3X,
	Float: pbVeh3Y,
	Float: pbVeh3Z,
	Float: pbVeh3A,
	pbVeh4Model,
	pbVeh4ID,
	Float: pbVeh4X,
	Float: pbVeh4Y,
	Float: pbVeh4Z,
	Float: pbVeh4A,
	pbVeh5Model,
	pbVeh5ID,
	Float: pbVeh5X,
	Float: pbVeh5Y,
	Float: pbVeh5Z,
	Float: pbVeh5A,
	pbVeh6Model,
	pbVeh6ID,
	Float: pbVeh6X,
	Float: pbVeh6Y,
	Float: pbVeh6Z,
	Float: pbVeh6A	
};

enum TurfWarsEnum
{
	twName[64],
	twOwnerId,
	twLocked,
	twSpecial,
	twVulnerable,
	twAttemptId,
	twTimeLeft,
	twGangZoneId,
	twAreaId,
	twActive,
	twFlash,
	twFlashColor,
	Float: twMinX,
	Float: twMinY,
	Float: twMaxX,
	Float: twMaxY,
};

enum fInfo
{
	FamilyTaken,
	FamilyName[42],
	FamilyColor,
	FamilyTurfTokens,
	FamilyLeader[MAX_PLAYER_NAME],
	FamilyMembers,
	Float:FamilySpawn[4],
	FamilyInterior,
	FamilyCash,
	FamilyBank,
	FamilyMats,
	FamilyHeroin,
	FamilyPot,
	FamilyCrack,
	Float:FamilySafe[3],
	FamilySafeVW,
	FamilySafeInt,
	FamilyUSafe,
	FamilyPickup,
	FamilyMaxSkins,
	FamilySkins[8],
	Float: FamilyEntrance[4],
	Float: FamilyExit[4],
	FamilyEntrancePickup,
	FamilyExitPickup,
	Text3D:FamilyEntranceText,
	Text3D:FamilyExitText,
	FamilyCustomMap,
	FamilyVirtualWorld,
	FamilyResetSpawns,
	FamilyGuns[10],
	gtObject,
	gt_Text[32],
	gt_FontFace[32],
	gt_FontSize,
	gt_Bold,
	gt_FontColor,
	gt_BackColor,
	gt_SPUsed,
	FamColor
};

enum fPoint
{
	pointID,
	pointVW,
	Float:Pointx,
	Float:Pointy,
	Float:Pointz,
	Type,
	Vulnerable,
	MatPoint,
	CratePoint,
	Announced,
	ClaimerId,
	ClaimerTeam,
	TimeToClaim,
	TimeLeft,
	Owner[32],
	PlayerNameCapping[MAX_PLAYER_NAME],
	CapperName[MAX_PLAYER_NAME],
	Name[32],
	TakeOverTimerStarted,
	TakeOverTimer,
	Text3D:TextLabel,
	CaptureTimerEx2,
	Stock,
	Text3D:CaptureProccess,
	Text3D:CaptureProgress,
	CaptureProccessEx,
	Float: Capturex,
	Float: Capturey,
	Float: Capturez,
	CapTime,
	CapFam,
	CapName[MAX_PLAYER_NAME],
	CapCrash,
	PointPickupID
}

enum pFishing
{
	pFish1[20],
	pFish2[20],
	pFish3[20],
	pFish4[20],
	pFish5[20],
	pWeight1,
	pWeight2,
	pWeight3,
	pWeight4,
	pWeight5,
	pFid1,
	pFid2,
	pFid3,
	pFid4,
	pFid5,
	pLastFish,
	pFishID,
	pLastWeight,
};

enum hNews
{
	hTaken1,
	hTaken2,
	hTaken3,
	hTaken4,
	hTaken5,
	hTaken6,
	hTaken7,
	hTaken8,
	hTaken9,
	hTaken10,
	hTaken11,
	hTaken12,
	hTaken13,
	hTaken14,
	hTaken15,
	hTaken16,
	hTaken17,
	hTaken18,
	hTaken19,
	hTaken20,
	hTaken21,
	hAdd1[64],
	hAdd2[64],
	hAdd3[64],
	hAdd4[64],
	hAdd5[64],
	hAdd6[64],
	hAdd7[64],
	hAdd8[64],
	hAdd9[64],
	hAdd10[64],
	hAdd11[64],
	hAdd12[64],
	hAdd13[64],
	hAdd14[64],
	hAdd15[64],
	hAdd16[64],
	hAdd17[64],
	hAdd18[64],
	hAdd19[64],
	hAdd20[64],
	hAdd21[64],
	hContact1[64],
	hContact2[64],
	hContact3[64],
	hContact4[64],
	hContact5[64],
	hContact6[64],
	hContact7[64],
	hContact8[64],
	hContact9[64],
	hContact10[64],
	hContact11[64],
	hContact12[64],
	hContact13[64],
	hContact14[64],
	hContact15[64],
	hContact16[64],
	hContact17[64],
	hContact18[64],
	hContact19[64],
	hContact20[64],
	hContact21[64],
};

enum sInfo
{
	sStorage,
	sAttached,
	sCash,
	sPot,
	sCrack,
	sMats,
	sHouseID,
	sVehicleSlot
};

enum pInfo
{
	pId,
	pOnline,
	pLevel,
	pAdmin,
	pDonateRank,
	gPupgrade,
	pConnectHours,
	pReg,
	pSex,
	pBirthDate[11],
	pOrigin,
	pCash,
	pHospital,
	pMuted,
	pPrisonReason[128],
	pPrisonedBy[MAX_PLAYER_NAME],
	pRMuted,
	pRMutedTotal,
	pRMutedTime,
	pDMRMuted,
	pVMuted,
	pVMutedTime,
	pExp,
	pAccount,
	pCrimes,
	pPaintTeam,
	pKills,
	pDeaths,
	pArrested,
	pPhoneBook,
	pLottoNr,
	pFishes,
	pBiggestFish,
	pJob,
	pAutoTextReply[64],
	pPhonePrivacy,
	pJob2,
	pJob3,
	p911Muted,
	pNMute,
	pNMuteTotal,
	pADMute,
	pADMuteTotal,
	pHelpMute,
	pPayCheck,
	pHeadValue,
	pJailTime,
	pWRestricted,
	pMats,
	pNation,
	pLeader,
	pMember,
	pDivision,
	pBadge[9],
	pFMember,
	pSpeakerPhone,
	pRank,
	pDetSkill,
	pSexSkill,
	pBoxSkill,
	pLawSkill,
	pMechSkill,
	pTruckSkill,
	pWantedLevel,
	pPot,
	pCrack,
	pHelper,
	pDrugsSkill,
	pArmsSkill,
	pSmugSkill,
	pFishSkill,
	Float:pHealth,
	Float:pArmor,
	Float:pSHealth,
	pInt,
	pBanAppealer,
	pPR,
	pHR,
	pAP,
	pSecurity,
	pShopTech,
	pFactionModerator,
	pGangModerator,
	pUndercover,
	pTogReports,
	pModel,
	pPnumber,
	pPhousekey,
	pPhousekey2,
	pPhousekey3,
	Float:pPos_x,
	Float:pPos_y,
	Float:pPos_z,
	Float:pPos_r,
	pCarLic,
	pSpeedo,
	pFlyLic,
	pBoatLic,
	pFishLic,
	pGunLic,
	pGuns[12],
	pAGuns[12],
	pConnectSeconds,
	pPayDayHad,
	pCDPlayer,
	pWins,
	pLoses,
	pTut,
	pWarns,
	pC4,
	pC4Get,
	pC4Used,
	pMarriedID,
	pMarriedName[MAX_PLAYER_NAME],
	pLock,
	pLockCar,
	pSprunk,
	pCigar,
	pPole,
	pSpraycan,
	pRope,
	pDice,
	pBombs,
	pDuty,
	pFightStyle,
	pEmail[128],
	pIP[16],
	pSecureIP[16],
	pBanned,
	pPermaBanned,
	pDisabled,
	pAccent,
	pCHits,
	pFHits,
	pCrates,
	pVW,
	pRenting,
	pTempVIP,
	pBuddyInvited,
	pVIPInviteDay,
	pTokens,
	pPaintTokens,
	pDrugsTime,
	pLawyerTime,
	pGangWarn,
	pCSFBanned,
	pMechTime,
	pSexTime,
	pLawyerFreeTime,
	pGiftTime,
	pContractBy[MAX_PLAYERS],
	pContractDetail[64],
	pRadio,
	pRadioFreq,
	pDutyHours,
	pAcceptedHelp,
	pAcceptReport,
	pShopTechOrders,
	pTrashReport,
	pInsurance,
	pTriageTime,
	pVehicleKeys,
	pVehicleKeysFrom,
	pTaxiLicense,
	pTicketTime,
	pScrewdriver,
	pWristwatch,
	pSurveillance,
	pSmslog,
	pTire,
	pFirstaid,
	pRccam,
	pReceiver,
	pGPS,
	pSweep,
	pSweepLeft,
	pBugged,
	pCheckCash,
	pChecks,
	pWeedObject,
	pWSeeds,
	pWarrant[128],
	pJudgeJailTime,
	pJudgeJailType,
	pBeingSentenced,
	pProbationTime,
	pDMKills,
	pOrder,
	pOrderConfirmed,
	pCallsAccepted,
	pPatientsDelivered,
	pLiveBanned,
	pFreezeBank,
	pFreezeHouse,
	pFreezeCar,
	pServiceTime,
	pFirework,
	pBoombox,
	pHydration,
	pRacePlayerLaps,
	pDoubleEXP,
	pEXPToken,
	pRingtone,
	pVIPM,
	pVIPMO,
	pVIPExpire,
	pGVip,
	pSMod,
	pWatchdog,
	pPSFPot,
	pPSFCrack,
	pPSFMats,
	pVIPSold,
	pGoldBoxTokens,
	Float: pRewardHours,
	pRewardDrawChance,
	pRVehRestricted,
	pRVehWarns,
	pLastRVehWarn,
	pFlagged,
	pPaper,
	pMailEnabled,
	pMailbox,
	pBusiness,
	pBusinessRank,
	pTreasureSkill,
	pMetalDetector,
	pHelpedBefore,
	pTrickortreat, // REUSED FOR ST PATRICK'S DAY LUCKY CHARMS AS PER JOHN
	pLastCharmReceived,
	pRHMutes,
	pRHMuteTime,
	pGiftCode,
	pTable,
	pOpiumSeeds,
	pRawOpium,
	pHeroin,
	pSyringes,
	pSkins,
	pHunger,
	pHungerTimer,
	pHungerDeathTimer,
	pFitness,
	pForcePasswordChange,
	pCredits,
	pHealthCare,
	pTotalCredits,
	pReceivedCredits,
	pRimMod,
	pHasTazer,
	pHasCuff,
	pCarVoucher,
	pReferredBy[MAX_PLAYER_NAME],
	pPendingRefReward,
	pRefers,
	pFamed,
	pFMuted,
	pDefendTime,
	pPVIPVoucher,
	pVehicleSlot,
	pToySlot,
	pRFLTeam,
	pRFLTeamL,
	pVehVoucher,
	pSVIPVoucher,
	pGVIPVoucher,
	pGiftVoucher,
	pFallIntoFun,
	pHungerVoucher,
	pBoughtCure,
	pVials,
	pAdvertVoucher,
	pShopCounter,
	pShopNotice,
	pSVIPExVoucher,
	pGVIPExVoucher,
	pVIPSellable,
	pReceivedPrize,
	pVIPSpawn,
	pFreeAdsDay,
	pFreeAdsLeft,
	pBuddyInvites,
	pReceivedBGift,
	pLastBirthday,
	pVIPJob,
	pNonRPMeter,
	pAccountRestricted,
	pWatchlist,
	pWatchlistTime,
	pBackpack, // 0 = no bckpk 1 = small 2 = med 3 = large
	pBEquipped,
	pBItems[12], // 0 = food 1 = pot 2 = crack 3 = heroin 4 = opium 5 = medkit 6 = gun1 7 = gun2 8 = gun3 9 = gun4 10 = gun5 11 = Energy Bars
	pBStoredH,
	pBStoredV,
	pBugReportTimeout,
	pNewbieTogged,
	pVIPTogged,
	pFamedTogged,
	pToolBox,
	pCrowBar,
	pCarLockPickSkill,
	pLockPickVehCount,
	pLockPickTime,
	pSEC,
	pBM,
	pIsolated,
	pWantedJailTime,
	pWantedJailFine,
	pNextNameChange,
	pExamineDesc[128],
	pFavStation[255],
	pDedicatedPlayer,
	pDedicatedEnabled,
	pDedicatedMuted,
	pDedicatedWarn,
	pHolsteredWeapon,
	mInventory[MAX_MICROITEMS],
	mPurchaseCount[MAX_MICROITEMS],
	mCooldown[MAX_MICROITEMS],
	mBoost[2], // Job | Skill
	mShopCounter,
	mNotice
};

enum pvInfo
{
	pvSlotId,
    Float:pvPosX,
	Float:pvPosY,
	Float:pvPosZ,
 	Float:pvPosAngle,
	pvId,
	pvModelId,
	pvLock,
	pvLocked,
	pvPaintJob,
	pvColor1,
	pvColor2,
	pvMods[MAX_MODS],
	pvAllowedPlayerId,
	pvPark,
	//pvNumberPlate[32], // sz
	pvPrice,
	pvTicket,
	pvWeapons[3],
	pvWepUpgrade,
	pvImpounded,
	pvSpawned,
	pvDisabled,
	pvPlate[32],
	pvRestricted,
	Float: pvFuel,
	Float: pvHealth,
	pvVW,
	pvInt,
	pvCrashFlag,
	pvCrashVW,
	Float:pvCrashX,
	Float:pvCrashY,
	Float:pvCrashZ,
	Float:pvCrashAngle,
	pvAlarm,
	pvAlarmTriggered,
	pvBeingPickLocked,
	pvBeingPickLockedBy,
	pvLastLockPickedBy[MAX_PLAYER_NAME],
	pvLocksLeft
};

enum ptInfo
{
	ptID,
    ptModelID,
	ptBone,
	ptTradable,
	ptSpecial,
    Float:ptPosX,
	Float:ptPosY,
	Float:ptPosZ,
	Float:ptRotX,
	Float:ptRotY,
	Float:ptRotZ,
	Float:ptScaleX,
	Float:ptScaleY,
	Float:ptScaleZ,
};

enum hInfo
{
	hSQLId,
	hOwned,
	hLevel,
	hCustomInterior,
	hDescription[16],
	hOwnerID,
	hOwnerName[MAX_PLAYER_NAME],
	Float: hExteriorX,
	Float: hExteriorY,
	Float: hExteriorZ,
	Float: hExteriorR,
	Float: hExteriorA,
	Float: hInteriorX,
	Float: hInteriorY,
	Float: hInteriorZ,
	Float: hInteriorR,
	Float: hInteriorA,
	hExtIW,
	hExtVW,
	hIntIW,
	hIntVW,
	hLock,
	hRentable,
	hRentFee,
	hValue,
	hSafeMoney,
	hPot,
	hCrack,
	hMaterials,
	hHeroin,
	hWeapons[ 5 ],
	hGLUpgrade,
	hPickupID,
	Text3D: hTextID,
	hCustomExterior,
	Float: hMailX,
	Float: hMailY,
	Float: hMailZ,
	Float: hMailA,
	hMailType,
	hMailObjectId,
	Text3D: hMailTextID,
	Float: hClosetX,
	Float: hClosetY,
	Float: hClosetZ,
	Text3D: hClosetTextID,
	hSignDesc[64],
	Float:hSign[4],
	hSignExpire,
	hSignObj,
	Text3D:hSignText
};

enum dmpInfo
{
	dmpSQLId,
	dmpMapIconID,
	Float: dmpPosX,
	Float: dmpPosY,
	Float: dmpPosZ,
	dmpMarkerType,
	dmpColor,
	dmpVW,
	dmpInt,
}

enum ddInfo
{
	ddSQLId,
	ddDescription[128],
	ddOwner,
	ddOwnerName[42],
	ddPickupID,
	Text3D: ddTextID,
	ddCustomInterior,
	ddExteriorVW,
	ddExteriorInt,
	ddInteriorVW,
	ddInteriorInt,
	Float: ddExteriorX,
	Float: ddExteriorY,
	Float: ddExteriorZ,
	Float: ddExteriorA,
	Float: ddInteriorX,
	Float: ddInteriorY,
	Float: ddInteriorZ,
	Float: ddInteriorA,
	ddCustomExterior,
	ddType,
	ddRank,
	ddVIP,
	ddFamed,
	ddDPC,
	ddAllegiance,
	ddGroupType,
	ddFamily,
	ddFaction,
	ddAdmin,
	ddWanted,
	ddVehicleAble,
	ddColor,
	ddPickupModel,
	ddPass[24],
	ddLocked,
};

enum gInfo
{
    gGATE,
    gHID,
	Float: gSpeed,
	Float: gRange,
	gModel,
	gVW,
	gInt,
	Float:gPosX,
	Float:gPosY,
	Float:gPosZ,
	Float:gRotX,
	Float:gRotY,
	Float:gRotZ,
	Float:gPosXM,
	Float:gPosYM,
	Float:gPosZM,
	Float:gRotXM,
	Float:gRotYM,
    Float:gRotZM,
    gStatus,
    gPass[24],
	gAllegiance,
	gGroupType,
	gGroupID,
	gFamilyID,
    gRenderHQ,
	gTimer,
	gAutomate,
	gLocked,
};

enum ePoints
{
	epObjectID,
	Text3D: epText3dID,
	Float:epPosX,
	Float:epPosY,
	Float:epPosZ,
	epVW,
	epInt,
	epPrize[64],
	epFlagable,
};

/*enum cmdInfo
{
    id,
	name[255],
	params[255],
	description[255],
	type,
	subtype,
	perms
};*/

/*enum pCrime
{
	pBplayer[32],
	pAccusing[32],
	pAccusedof[32],
	pVictim[32],
};*/

enum _scInfoEnum
{
	_scDatabase,            // database ID
	bool:_scActive,         // whether or not the speed camera array pos is in use
	Float:_scPosX,          // x position of speedcam
	Float:_scPosY,          // y position of speedcam
	Float:_scPosZ,          // z position of speedcam
	Text3D: _scTextID,
	Float:_scRotation,      // rotation of speedcam
	Float:_scRange,         // range that the speedcam will capture at
	Float:_scLimit,         // speed limit that will trigger the speedcam capture callback
	_scObjectId,            // self-explanatory
};

enum mbInfo
{
	mbVW,
	mbInt,
	mbModel,
	Float: mbPosX,
	Float: mbPosY,
	Float: mbPosZ,
	Float: mbAngle,
	mbObjectId,
	Text3D: mbTextId
}

enum tlInfo
{
	tlSQLId,
	tlText[128],
	tlPickupID,
	Text3D: tlTextID,
	Float: tlPosX,
	Float: tlPosY,
	Float: tlPosZ,
	tlVW,
	tlInt,
	tlColor,
	tlPickupModel
}

enum pnsInfo
{
	pnsSQLId,
	pnsStatus,
	Float: pnsPosX,
	Float: pnsPosY,
	Float: pnsPosZ,
	pnsVW,
	pnsInt,
	pnsPickupID,
	Text3D: pnsTextID,
	pnsMapIconID,
	pnsGroupCost,
	pnsRegCost
}

enum arrestInfo
{
	arrestSQLId,
	arrestType,
	Float: arrestPosX,
	Float: arrestPosY,
	Float: arrestPosZ,
	arrestVW,
	arrestInt,
	Float: JailPos1[3],
	Float: JailPos2[3],
	jailVW,
	jailInt,
	Text3D: arrestTextID,
	arrestPickupID
}

enum eJailBoxing {
	bool:bInProgress = false,
	iParticipants,
	iDocBoxingCountdown = 4,
	iDocCountDownTimer
}

enum impoundInfo
{
	impoundSQLId,
	Float: impoundPosX,
	Float: impoundPosY,
	Float: impoundPosZ,
	impoundVW,
	impoundInt,
	Text3D: impoundTextID
}

enum HoldingEnumAll
{
	holdingmodelid,
	holdingprice,
	holdingmodelname[24]
}

enum HoldingEnum
{
	holdingmodelid,
	holdingprice,
	holdingmodelname[24]
}

enum AC_STRUCT_INFO {
	Float:LastOnFootPosition[3],
	checkmaptp,
	maptplastclick,
	Float:maptp[3]
}

enum mdcInfo
{
	mdcCrime[64],
	mdcIssuer[24],
	mdcActive[3],
}

// Relay For Life
enum rflinfo
{
	RFLsqlid,
	RFLused,
	RFLname[25],
	RFLmembers,
	RFLleader[MAX_PLAYER_NAME],
	RFLlaps
}

// Hunger Games
enum HUNGER_PLAYER_INFO
{
	hgInEvent,
	Float: hgLastPosition[3],
	Float: hgLastHealth,
	Float: hgLastArmour,
	hgLastVW,
	hgLastInt,
	hgLastWeapon[12],
	hgVoucher,
	PlayerText: hgPlayerText,
	PlayerText: hgLoadingText,
	PlayerText: hgTimeLeftText,
	PlayerText: hgCreditsText
}

enum HUNGER_BACKPACK_INFO
{
	hgBackpackId,
	hgBackpackPickupId,
	Text3D: hgBackpack3DText,
	hgBackpackType,
	Float: hgBackpackPos[3],
	hgActiveEx
}

enum GANG_TAG_INFO
{
	gt_SQLID,
	gt_Object,
	Float:gt_PosX,
	Float:gt_PosY,
	Float:gt_PosZ,
	Float:gt_PosRX,
	Float:gt_PosRY,
	Float:gt_PosRZ,
	gt_VW,
	gt_Int,
	gt_ObjectID,
	gt_Used,
	gt_Family,
	gt_Time,
	gt_TimeLeft,
	gt_Timer
}

enum FIREWORK_INFO
{
	fireworkId,
	Float: fireworkPos[3]
}

// Business System 2.0
enum DYNAMIC_BUSINESS_INFO
{
	bID, // SQL ID of the business itself
	bType,
	bName[MAX_DYNAMIC_BUSINESS_NAME],
	bMOTD,
	bLevel,
	bOwnerSQLId, // Use the owner SQL ID
	bNation,
	bVault,
	bResupply[5], // Coords, interior & virtual world
	Float: bEntrance[5], // Coords, interior & virtual world
	Float: bExit[5], // Coords, interior and virtual world
	bCustomInterior,
	bCustomExterior,
	bRankName[MAX_DYNAMIC_BUSINESS_RANKS],
	bRankPay[MAX_DYNAMIC_BUSINESS_RANKS]
}

/* Server Side Health WIP
enum AC
{
	Float: acHealth,
	Float: acArmour,
	acState,
	acTimer
}
new AntiCheat[MAX_PLAYERS][AC];
*/

/* Dynamic Gift Box Stuff
Note: dgGVIP = 7 Days | dgGVIPEx = 1 Month
Example: 
	dgVar[dgMoney][0] = Is it enabled? 
	dgVar[dgMoney][1] = Quantity of gift available
	dgVar[dgMoney][2] = Quantity of money the player will receive
	dgVar[dgMoney][3] = Rarity Category of Item (Common, Less Common, Rare, Super Rare)
*/
enum dgItems
{
	dgMoney,
	dgRimKit,
	dgFirework,
	dgGVIP,
	dgGVIPEx,
	dgSVIP,
	dgSVIPEx,
	dgCarSlot,
	dgToySlot,
	dgArmor,
	dgFirstaid,
	dgDDFlag,
	dgGateFlag,
	dgCredits,
	dgPriorityAd,
	dgHealthNArmor,
	dgGiftReset,
	dgMaterial,
	dgWarning,
	dgPot,
	dgCrack,
	dgPaintballToken,
	dgVIPToken,
	dgRespectPoint,
	dgCarVoucher,
	dgBuddyInvite,
	dgLaser,
	dgCustomToy,
	dgAdmuteReset,
	dgNewbieMuteReset,
	dgRestrictedCarVoucher,
	dgPlatinumVIPVoucher
};

enum garInfo
{
	gar_SQLId,
	gar_Owner,
	gar_OwnerName[24],
	Float: gar_ExteriorX,
	Float: gar_ExteriorY,
	Float: gar_ExteriorZ,
	Float: gar_ExteriorA,
	gar_ExteriorVW,
	gar_ExteriorInt,
	gar_CustomExterior,
	Float: gar_InteriorX,
	Float: gar_InteriorY,
	Float: gar_InteriorZ,
	Float: gar_InteriorA,
	gar_InteriorVW,
	gar_Pass[24],
	gar_Locked,
	Text3D: gar_TextID
};

enum eStructureFires {
	iFireObj,
	Text3D:szFireLabel,
	iFireStrength,
	Float:fFirePos[3],
}

enum FallIntoFun
{
	FIFHours,
	FIFChances
}