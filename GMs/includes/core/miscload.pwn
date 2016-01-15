/* 	Misc Variables load
	Secondary Chatbox
*/

#include <YSI\y_hooks>

hook OnGameModeInit() {

	TD_ServerError = TextDrawCreate(321.000000, 428.000000, "SERVER: Unknown command");
	TextDrawAlignment(TD_ServerError, 2);
	TextDrawBackgroundColor(TD_ServerError, 255);
	TextDrawFont(TD_ServerError, 2);
	TextDrawLetterSize(TD_ServerError, 0.210000, 0.899999);
	TextDrawColor(TD_ServerError, -1);
	TextDrawSetOutline(TD_ServerError, 0);
	TextDrawSetProportional(TD_ServerError, 1);
	TextDrawSetShadow(TD_ServerError, 1);
	TextDrawUseBox(TD_ServerError, 1);
	TextDrawBoxColor(TD_ServerError, -14803426);
	TextDrawTextSize(TD_ServerError, -300.000000, 655.000000);
	TextDrawSetSelectable(TD_ServerError, 0);
}


hook OnGameModeExit() {

	for(new i; i < sizeof(TD_ChatBox); ++i) {

		PlayerTextDrawDestroy(0, TD_ChatBox[i]);
	}
	return 1;
}

hook OnPlayerConnect(playerid) {
	/*
	TD_ChatBox[0] = CreatePlayerTextDraw(playerid, 520.000000, 352.000000, "chatbox");
	PlayerTextDrawAlignment(playerid,TD_ChatBox[0], 2);
	PlayerTextDrawBackgroundColor(playerid,TD_ChatBox[0], 255);
	PlayerTextDrawFont(playerid,TD_ChatBox[0], 2);
	PlayerTextDrawLetterSize(playerid,TD_ChatBox[0], 0.490000, 9.199996);
	PlayerTextDrawColor(playerid,TD_ChatBox[0], 0);
	PlayerTextDrawSetOutline(playerid,TD_ChatBox[0], 0);
	PlayerTextDrawSetProportional(playerid,TD_ChatBox[0], 1);
	PlayerTextDrawSetShadow(playerid,TD_ChatBox[0], 0);
	PlayerTextDrawUseBox(playerid,TD_ChatBox[0], 1);
	PlayerTextDrawBoxColor(playerid,TD_ChatBox[0], 50);
	PlayerTextDrawTextSize(playerid,TD_ChatBox[0], 341.000000, 280.000000);
	PlayerTextDrawSetPreviewModel(playerid, TD_ChatBox[0], 19300);
	PlayerTextDrawSetPreviewRot(playerid, TD_ChatBox[0], -16.000000, 0.000000, -55.000000, 50000.000000);
	PlayerTextDrawSetSelectable(playerid,TD_ChatBox[0], 0);

	TD_ChatBox[1] = CreatePlayerTextDraw(playerid,394.000000, 353.000000, "");
	PlayerTextDrawBackgroundColor(playerid,TD_ChatBox[1], 50);
	PlayerTextDrawFont(playerid,TD_ChatBox[1], 1);
	PlayerTextDrawLetterSize(playerid,TD_ChatBox[1], 0.130000, 0.799999);
	PlayerTextDrawColor(playerid,TD_ChatBox[1], -1);
	PlayerTextDrawSetOutline(playerid,TD_ChatBox[1], 1);
	PlayerTextDrawSetProportional(playerid,TD_ChatBox[1], 1);
	PlayerTextDrawSetSelectable(playerid,TD_ChatBox[1], 0);

	TD_ChatBox[2] = CreatePlayerTextDraw(playerid,394.000000, 361.000000, "");
	PlayerTextDrawBackgroundColor(playerid,TD_ChatBox[2], 50);
	PlayerTextDrawFont(playerid,TD_ChatBox[2], 1);
	PlayerTextDrawLetterSize(playerid,TD_ChatBox[2], 0.130000, 0.799999);
	PlayerTextDrawColor(playerid,TD_ChatBox[2], -1);
	PlayerTextDrawSetOutline(playerid,TD_ChatBox[2], 1);
	PlayerTextDrawSetProportional(playerid,TD_ChatBox[2], 1);
	PlayerTextDrawSetSelectable(playerid,TD_ChatBox[2], 0);

	TD_ChatBox[3] = CreatePlayerTextDraw(playerid,394.000000, 369.000000, "");
	PlayerTextDrawBackgroundColor(playerid,TD_ChatBox[3], 50);
	PlayerTextDrawFont(playerid,TD_ChatBox[3], 1);
	PlayerTextDrawLetterSize(playerid,TD_ChatBox[3], 0.130000, 0.799999);
	PlayerTextDrawColor(playerid,TD_ChatBox[3], -1);
	PlayerTextDrawSetOutline(playerid,TD_ChatBox[3], 1);
	PlayerTextDrawSetProportional(playerid,TD_ChatBox[3], 1);
	PlayerTextDrawSetSelectable(playerid,TD_ChatBox[3], 0);

	TD_ChatBox[4] = CreatePlayerTextDraw(playerid,394.000000, 377.000000, "");
	PlayerTextDrawBackgroundColor(playerid,TD_ChatBox[4], 50);
	PlayerTextDrawFont(playerid,TD_ChatBox[4], 1);
	PlayerTextDrawLetterSize(playerid,TD_ChatBox[4], 0.130000, 0.799999);
	PlayerTextDrawColor(playerid,TD_ChatBox[4], -1);
	PlayerTextDrawSetOutline(playerid,TD_ChatBox[4], 1);
	PlayerTextDrawSetProportional(playerid,TD_ChatBox[4], 1);
	PlayerTextDrawSetSelectable(playerid,TD_ChatBox[4], 0);

	TD_ChatBox[5] = CreatePlayerTextDraw(playerid,394.000000, 385.000000, "");
	PlayerTextDrawBackgroundColor(playerid,TD_ChatBox[5], 50);
	PlayerTextDrawFont(playerid,TD_ChatBox[5], 1);
	PlayerTextDrawLetterSize(playerid,TD_ChatBox[5], 0.130000, 0.799999);
	PlayerTextDrawColor(playerid,TD_ChatBox[5], -1);
	PlayerTextDrawSetOutline(playerid,TD_ChatBox[5], 1);
	PlayerTextDrawSetProportional(playerid,TD_ChatBox[5], 1);
	PlayerTextDrawSetSelectable(playerid,TD_ChatBox[5], 0);

	TD_ChatBox[6] = CreatePlayerTextDraw(playerid,394.000000, 393.000000, "");
	PlayerTextDrawBackgroundColor(playerid,TD_ChatBox[6], 50);
	PlayerTextDrawFont(playerid,TD_ChatBox[6], 1);
	PlayerTextDrawLetterSize(playerid,TD_ChatBox[6], 0.130000, 0.799999);
	PlayerTextDrawColor(playerid,TD_ChatBox[6], -1);
	PlayerTextDrawSetOutline(playerid,TD_ChatBox[6], 1);
	PlayerTextDrawSetProportional(playerid,TD_ChatBox[6], 1);
	PlayerTextDrawSetSelectable(playerid,TD_ChatBox[6], 0);
		
	TD_ChatBox[7] = CreatePlayerTextDraw(playerid,394.000000, 401.000000, "");
	PlayerTextDrawBackgroundColor(playerid,TD_ChatBox[7], 50);
	PlayerTextDrawFont(playerid,TD_ChatBox[7], 1);
	PlayerTextDrawLetterSize(playerid,TD_ChatBox[7], 0.130000, 0.799999);
	PlayerTextDrawColor(playerid,TD_ChatBox[7], -1);
	PlayerTextDrawSetOutline(playerid,TD_ChatBox[7], 1);
	PlayerTextDrawSetProportional(playerid,TD_ChatBox[7], 1);
	PlayerTextDrawSetSelectable(playerid,TD_ChatBox[7], 0);
	
	TD_ChatBox[8] = CreatePlayerTextDraw(playerid,394.000000, 409.000000, "");
	PlayerTextDrawBackgroundColor(playerid,TD_ChatBox[8], 50);
	PlayerTextDrawFont(playerid,TD_ChatBox[8], 1);
	PlayerTextDrawLetterSize(playerid,TD_ChatBox[8], 0.130000, 0.799999);
	PlayerTextDrawColor(playerid,TD_ChatBox[8], -1);
	PlayerTextDrawSetOutline(playerid,TD_ChatBox[8], 1);
	PlayerTextDrawSetProportional(playerid,TD_ChatBox[8], 1);
	PlayerTextDrawSetSelectable(playerid,TD_ChatBox[8], 0);

	TD_ChatBox[9] = CreatePlayerTextDraw(playerid,394.000000, 417.000000, "");
	PlayerTextDrawBackgroundColor(playerid,TD_ChatBox[9], 50);
	PlayerTextDrawFont(playerid,TD_ChatBox[9], 1);
	PlayerTextDrawLetterSize(playerid,TD_ChatBox[9], 0.130000, 0.799999);
	PlayerTextDrawColor(playerid,TD_ChatBox[9], -1);
	PlayerTextDrawSetOutline(playerid,TD_ChatBox[9], 1);
	PlayerTextDrawSetProportional(playerid,TD_ChatBox[9], 1);
	PlayerTextDrawSetSelectable(playerid,TD_ChatBox[9], 0);

	TD_ChatBox[10] = CreatePlayerTextDraw(playerid,394.000000, 425.000000, "");
	PlayerTextDrawBackgroundColor(playerid,TD_ChatBox[10], 50);
	PlayerTextDrawFont(playerid,TD_ChatBox[10], 1);
	PlayerTextDrawLetterSize(playerid,TD_ChatBox[10], 0.130000, 0.799999);
	PlayerTextDrawColor(playerid,TD_ChatBox[10], -1);
	PlayerTextDrawSetOutline(playerid,TD_ChatBox[10], 1);
	PlayerTextDrawSetProportional(playerid,TD_ChatBox[10], 1);
	PlayerTextDrawSetSelectable(playerid,TD_ChatBox[10], 0);
	*/
	return 1;
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