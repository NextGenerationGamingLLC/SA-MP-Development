/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

    	    Drug/Ingredients & Black Market System
    			        by Jingles

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

#define 		MAX_BLACKMARKETS				MAX_GROUPS

#define 		DIALOG_DRUGS_MYDRUGS			11000
#define 		DIALOG_DRUGS_DRUGSTORE			11001
#define 		DIALOG_DRUGS_MIX_START			11002
#define 		DIALOG_DRUGS_MIX_MAIN			11003
#define 		DIALOG_DRUGS_MIX_INGREDIENT		11004
#define 		DIALOG_DRUGS_MIX_AMOUNT			11005
#define 		DIALOG_DRUGS_ORDER_ING			11006
#define 		DIALOG_DRUGS_ORDER_INGAM		11007
#define 		DIALOG_DRUGS_ORDER_LIST			11008

#define 		DIALOG_BLACKMARKET_CREATE 		10999
#define 		DIALOG_BLACKMARKET_MAIN			11009
#define 		DIALOG_BLACKMARKET_INGREDIENTS	11010
#define 		DIALOG_BLACKMARKET_EDITPRICE	11011
#define 		DIALOG_BLACKMARKET_EDITPRICE2	11012
#define 		DIALOG_BLACKMARKET_EDITPAYMENT 	11013
#define 		DIALOG_BLACKMARKET_EDITPAYMENT2 11014
#define 		DIALOG_BLACKMARKET_TRANSFERC 	11029
#define 		DIALOG_BLACKMARKET_TRANSFER		11015
#define 		DIALOG_BLACKMARKET_TRANSFER2	11016
#define 		DIALOG_BLACKMARKET_ORDER_ING 	11017
#define 		DIALOG_BLACKMARKET_ORDER_INGAM	11018
#define 		DIALOG_BLACKMARKET_LIST			11019
#define 		DIALOG_BLACKMARKET_ALIST 		11020
#define 		DIALOG_BLACKMARKET_APOINT 		11021
#define 		DIALOG_BLACKMARKET_ADELPOINT	11022
#define 		DIALOG_BLACKMARKET_ADELBM		11023
#define 		DIALOG_DRUGPOOL					11024
#define 		DIALOG_BLACKMARKET_ASEIZE 		11045

#define 		DIALOG_SMUGGLE_PREPARE			11025
#define 		DIALOG_SMUGGLE_PREPARE2			11026
#define 		DIALOG_SMUGGLE_DELIVERTO		11027
#define 		DIALOG_SMUGGLE_BMDELPOINT		11028

#define 		DIALOG_POINT_NAME 				11039
#define 		DIALOG_POINT_TYPE 				11040
#define 		DIALOG_POINT_LIST 				11041

#define 		ADDICT_TIMER_MINUTES			60

#define 		DRUGS_OVERDOSE_THRESHOLD		50
#define 		DRUGS_MAX_BONUS_HEALTH			200
#define 		DRUGS_MAX_BONUS_ARMOUR			150

#define 		DRUGS_ADDICTION_RATE			10 // + and - addicted points per take
#define 		DRUGS_ADDICTED_THRESHOLD		300 // addicted level threshold
#define 		DRUGS_ADDICTED_LEVEL			400

#define 		DRUGS_TRACKABLE_THRESHOLD		50 // Amount of drugs/ingredients orderable without LEA tracking.
#define 		MAX_DRUGINGREDIENT_SLOTS		5

#define 		DRUG_ORDER_TIME					2 * 3600 // 2 hours.
#define 		DRUGS_GROWTH_TIME				2 * 3600 // 2 hours.

#define 		MAX_PLAYERDRUGS					10

#define 		CHECKPOINT_SMUGGLE_BLACKMARKET	5000
#define 		CHECKPOINT_SMUGGLE_PLAYER		5001

#define 		BLACKMARKET_SEIZE_DAYS			1

/*
new const szDrugs[][] = {
	"LSD",
	"Cannabis",
	"Meth",
	"Heroin",
	"Cocaine",
	"Crack",
	"Opium",
	"Ecstasy",
	"Speed",
	"Alcohol",
	"Demerol",
	"Morphine",
	"Haloperidol",
	"Aspirin",
};


new const szIngredients[][] = {
	"Morning Glory Seeds",
	"Cannabis Seeds",
	"Muriatic Acid",
	"Lye",
	"Ethyl Ether",
	"Ephedrine",
	"Distilled Water",
	"Opium Poppy",
	"Lime",
	"Cocaine",
	"Baking Soda",
	"Cocaine Plant Extract",
	"N-Benzynol",
	"PMK Oil",
	"MDMA Crystals",
	"Caffeine"
};
*/
/*
	pInfo enums:

	p_iDrug[sizeof(szDrugs)],
	p_iDrugQuality[sizeof(szDrugs)],
	p_iDrugTaken[sizeof(szDrugs)],
	p_iAddicted[sizeof(szDrugs)],
	p_iAddictedLevel[sizeof(szDrugs)],
	p_iIngredient[sizeof(szIngredients)]
*/


enum e_drMix {
	drm_iAmount,
	drm_iIngredientID
}
new dr_arrDrugMix[MAX_PLAYERS][MAX_DRUGINGREDIENT_SLOTS][e_drMix];

enum eDrugData {

	dr_iDrugID,
	dr_iDrugQuality,
	// dr_iAreaID,
	Float:dr_fPos[3],
	Text3D:dr_iTextID,
	dr_iObjectID,
	dr_iDBID
}
new arrDrugData[MAX_DRUGS][eDrugData];

enum eSmuggleVehicle {
	smv_iIngredientAmount[sizeof(szIngredients)]
}
new arrSmuggleVehicle[MAX_VEHICLES][eSmuggleVehicle];

new dr_iPlayerTimeStamp[MAX_PLAYERS],
	Text:ODTextDraw;

new Iterator:Points<MAX_DYNPOINTS>,
	Iterator:BlackMarkets<MAX_BLACKMARKETS>;

CMD:givealldrugs(playerid) {

	if(!IsAdminLevel(playerid, ADMIN_LEAD)) return 1;
	for(new i; i < sizeof(szDrugs); ++i) PlayerInfo[playerid][p_iDrug][i] = 200;
	for(new i; i < sizeof(szIngredients); ++i) PlayerInfo[playerid][p_iIngredient][i] = 200;
	return 1;
}


DS_LoadDrugSystem()
{
	Drugs_ODTextDraw();
	BM_LoadBlackMarkets();
	PO_LoadPoints();
	Drugs_LoadPlayerPlants();
}

DS_Drugs_GetSQLName(id)
{
	switch(id) {

		case 0: szMiscArray = "Lsd";
		case 1: szMiscArray = "Cannabis";
		case 2: szMiscArray = "Meth";
		case 3: szMiscArray = "Heroin";
		case 4: szMiscArray = "Cocaine";
		case 5: szMiscArray = "Crack";
		case 6: szMiscArray = "Opium";
		case 7: szMiscArray = "Ecstasy";
		case 8: szMiscArray = "Speed";
		case 9: szMiscArray = "Alcohol";
		case 10: szMiscArray = "Demerol";
		case 11: szMiscArray = "Morphine";
		case 12: szMiscArray = "Haloperidol";
		case 13: szMiscArray = "Aspirin";
	}
	return szMiscArray;
}

DS_Ingredients_GetSQLName(id)
{
	switch(id) {

		case 0: szMiscArray = "Mgseeds";
		case 1: szMiscArray = "Canseeds";
		case 2: szMiscArray = "Muriatic";
		case 3: szMiscArray = "Lye";
		case 4: szMiscArray = "Ethyl";
		case 5: szMiscArray = "Ephedrine";
		case 6: szMiscArray = "Diswater";
		case 7: szMiscArray = "Opiumpop";
		case 8: szMiscArray = "Lime";
		case 9: szMiscArray = "Cocextract";
		case 10: szMiscArray = "Baking";
		case 11: szMiscArray = "Cocextract";
		case 12: szMiscArray = "Nbenzynol";
		case 13: szMiscArray = "Pmkoil";
		case 14: szMiscArray = "Mdmacrys";
		case 15: szMiscArray = "Caffeine";
	}
	return szMiscArray;
}

task Drugs_GrowthCheck[60000 * 10]() {

	mysql_function_query(MainPipeline, "SELECT * FROM `drugpool`", true, "Drugs_OnGrowthCheck", "");
	return 1;
}

task Point_Process[60000 * 10]() {

	BM_SeizeCheck();

	format(szMiscArray, sizeof(szMiscArray), "SELECT `id` FROM `dynpoints` WHERE `timestamp` < %d AND `capturable` = 0 AND `posx` != 0", gettime());
	mysql_function_query(MainPipeline, szMiscArray, true, "Point_OnCapCheck", "");
}

task Drugs_Plants[60000 * 720]() {

	Drugs_FlushDrugs();
}

ptask PlayerAddiction[60000 * ADDICT_TIMER_MINUTES](playerid)
{
	new i = random(3);
	if(i == 2) {

		for(new idx; idx < sizeof(szDrugs); ++idx) {

			if(PlayerInfo[playerid][p_iAddicted][idx] == 1)	{

				Addicted_TimerProcess(playerid, idx);
				break;
			}
		}
	}
	for(new x; x < sizeof(szDrugs); ++x) PlayerInfo[playerid][p_iDrugTaken][x] = 0;
	return 1;
}

timer Point_Capture[1000 * 10](playerid, i, iGroupID) {

	if(GetGVarType("PO_CAPT", i) && GetGVarInt("PO_CAPT", i) == PlayerInfo[playerid][pMember]) return SendClientMessageEx(playerid, COLOR_GRAD1, "Someone in your gang already captured the point.");
	new Float:fHealth,
		Float:fPos[3];

	GetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]);
	GetHealth(playerid, fHealth);
	if(GetPVarFloat(playerid, "X") != fPos[0] || GetPVarFloat(playerid, "Y") != fPos[1] || GetPVarFloat(playerid, "Z") != fPos[2] || GetPVarInt(playerid, "Injured") || !IsPlayerConnected(playerid)) {

		DeletePVar(playerid, "X");
		DeletePVar(playerid, "Y");
		DeletePVar(playerid, "Z");
		DeletePVar(playerid, "PO_CAPTUR");
		return SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You failed to capture the point. You either moved or died while attempting to capture.");
	}

	DeletePVar(playerid, "X");
	DeletePVar(playerid, "Y");
	DeletePVar(playerid, "Z");

	if(GetGVarType("PO_CAPT", i)) {
		new iGroupCapID = GetGVarInt("PO_CAPT", i);
		foreach(new p : Player) {
			if(PlayerInfo[p][pMember] == iGroupCapID) {

				DeletePVar(p, "PO_CAPTUR");
				SendClientMessageEx(p, COLOR_YELLOW, "The point was taken by another gang. Therefore you failed to capture it.");
				TextDrawHideForPlayer(p, PointTime);
			}
		}
	}

	format(szMiscArray, sizeof(szMiscArray), "%s has attempted to take control of %s for %s, it will be theirs in 10 minutes.",
		GetPlayerNameEx(playerid), arrPoint[i][po_szPointName], arrGroupData[iGroupID][g_szGroupName]);

	foreach(new p : Player) ChatTrafficProcess(p, COLOR_YELLOW, szMiscArray, 22);
	SetGVarInt("PO_CAPT", iGroupID, i);
	GangZoneShowForAll(arrPoint[i][po_iZoneID], arrGroupData[iGroupID][g_hDutyColour] * 256 + 170);
	GangZoneFlashForAll(arrPoint[i][po_iZoneID], COLOR_RED);
	DeleteGVar("PO_Time", i);
	SetGVarInt("PO_Time", 10, i);
	defer PO_PointTimer(playerid, i, iGroupID);
	defer PO_PointMicroTimer(iGroupID, i, 0);
	return 1;
}

timer PO_PointMicroTimer[1000](iGroupID, i, s) {

	if(!GetGVarType("PO_Time", i) || !GetGVarType("PO_CAPT", i) || (GetGVarType("PO_CAPT", i) && GetGVarInt("PO_CAPT", i) != iGroupID)) {
		foreach(new p : Player) if (PlayerInfo[p][pMember] == iGroupID) TextDrawHideForPlayer(p, PointTime);
		return 1;
	}
	new iTime = GetGVarInt("PO_Time", i);
	if(s < 0) { iTime--; s = 59; }
	if(iTime < 1 && s < 1) {
		foreach(new p : Player) if (PlayerInfo[p][pMember] == iGroupID) TextDrawHideForPlayer(p, PointTime);
		return 1;
	}

	SetGVarInt("PO_Time", iTime, i);
	format(szMiscArray, sizeof(szMiscArray), "%d:%02d", iTime, s);
	TextDrawSetString(PointTime, szMiscArray);
	foreach(new p : Player) {
		if(PlayerInfo[p][pMember] == iGroupID) TextDrawShowForPlayer(p, PointTime);
		else TextDrawHideForPlayer(p, PointTime);
	}
	s--;
	defer PO_PointMicroTimer(iGroupID, i, s);
	return 1;
}

timer BM_BlackMarketMicroTimer[1000](iGroupID, i, s) {

	if(!GetGVarType("BM_Time", i) || arrBlackMarket[i][bm_iSeized] == 0 || (GetGVarType("BM_Capturer", i) && GetGVarInt("BM_Capturer", i) != iGroupID)) {
		foreach(new p : Player) if(PlayerInfo[p][pMember] == iGroupID) TextDrawHideForPlayer(p, PointTime);
		foreach(new p : Player) if(IsACop(p)) TextDrawHideForPlayer(p, PointTime);
		return 1;
	}
	new iTime = GetGVarInt("BM_Time", i);
	if(s < 0) { iTime--; s = 59; }
	if(iTime < 1 && s < 1) {
		foreach(new p : Player) TextDrawHideForPlayer(p, PointTime);
		return 1;
	}

	SetGVarInt("BM_Time", iTime, i);
	format(szMiscArray, sizeof(szMiscArray), "%d:%02d", iTime, s);
	TextDrawSetString(PointTime, szMiscArray);
	foreach(new p : Player) {
		if(PlayerInfo[p][pMember] == iGroupID) TextDrawShowForPlayer(p, PointTime);
		else if(IsACop(p)) TextDrawShowForPlayer(p, PointTime);
		else TextDrawHideForPlayer(p, PointTime);
	}
	s--;
	defer BM_BlackMarketMicroTimer(iGroupID, i, s);
	return 1;
}



timer Drug_ResetEffects[60000](playerid, iDrugID) {

	new Float:fPos[3];

	GetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]);
	PlayerPlaySound(playerid, 1184, fPos[0], fPos[1], fPos[2]);

	switch(iDrugID) {

		case 0 .. 9: format(szMiscArray, sizeof(szMiscArray), "[Drugs]: {DDDDDD}%s's side-effect wore off.", szDrugs[iDrugID]);
		default: szMiscArray = "[Drugs]: All side-effects wore off from the medicine.";
	}
	SendClientMessageEx(playerid, COLOR_GREEN, szMiscArray);

	Bit_Off(arrPlayerBits[playerid], dr_bitUsedDrug);
	Bit_Off(arrPlayerBits[playerid], dr_bitInDrugEffect);

	new iTime[3];

	gettime(iTime[0], iTime[1], iTime[2]);
	SetPlayerTime(playerid, iTime[0], iTime[1]);
	SetPlayerDrunkLevel(playerid, 0);
	SetPlayerWeather(playerid, gWeather);
	DeletePVar(playerid, "DR_LastTake");
	return 1;
}

timer Drug_ResetDrunkEffects[30000](playerid) {

	SetPlayerDrunkLevel(playerid, 0);
	return 1;
}

timer Addiction_Effects[60000](playerid, iDrugID, iTaken) {

	if(PlayerInfo[playerid][p_iAddictedLevel][iDrugID] > DRUGS_ADDICTED_THRESHOLD) {

		defer Addiction_Effects(playerid, iDrugID, iTaken); // cooldown = 60 seconds
	}
	else {

		PlayerInfo[playerid][p_iAddicted][iDrugID] = 1;
		PlayerInfo[playerid][p_iAddictedLevel][iDrugID] = 50;
		PlayerInfo[playerid][p_iAddicted][iDrugID] = 1;

		Drug_ResetEffects(playerid, iDrugID);

		SendClientMessageEx(playerid, COLOR_GRAD1, "The effects of your addiction wore off.");

		return 1;
	}

	Drug_SideEffects(playerid, iDrugID, iTaken);

	new Float:fHealth;

	GetHealth(playerid, fHealth);

	PlayerInfo[playerid][p_iAddictedLevel][iDrugID] =- DRUGS_ADDICTED_LEVEL / 5;

	if(fHealth > 30.0) {

		switch(iDrugID)
		{
			case 0:
			{
				SetHealth(playerid, fHealth - (PlayerInfo[playerid][p_iAddictedLevel] * 0.02));
				return 1;
			}
			case 1:
			{
				SetHealth(playerid, fHealth - (PlayerInfo[playerid][p_iAddictedLevel] * 0.04));
				return 1;
			}
			case 2:
			{
				SetHealth(playerid, fHealth - (PlayerInfo[playerid][p_iAddictedLevel] * 0.06));
				return 1;
			}
			case 3:
			{
				SetHealth(playerid, fHealth - (PlayerInfo[playerid][p_iAddictedLevel] * 0.08));
				return 1;
			}
			case 4:
			{
				SetHealth(playerid, fHealth - (PlayerInfo[playerid][p_iAddictedLevel] * 0.08));
				return 1;
			}
			case 5:
			{
				SetHealth(playerid, fHealth - (PlayerInfo[playerid][p_iAddictedLevel] * 0.1));
				return 1;
			}
			default: {

				SetHealth(playerid, fHealth - (PlayerInfo[playerid][p_iAddictedLevel] * 0.1));
				return 1;
			}
		}
	}
	return 1;
}


timer Drug_ResetOverDose[30000](playerid) {

	for(new i; i < sizeof(szDrugs); ++i) PlayerInfo[playerid][p_iDrugTaken][i] = 0;
	DeletePVar(playerid, PVAR_DRUGS_OVERDOSE);
	SetPlayerDrunkLevel(playerid, 0);
	TextDrawHideForPlayer(playerid, ODTextDraw);
	ClearAnimations(playerid, 1);
	TogglePlayerControllable(playerid, 1);
	Bit_Off(arrPlayerBits[playerid], dr_bitUsedDrug);
	Main_DestroyAttached3DTextLabel(playerid);
}

timer Drug_DestroyRunPerk[20000](pickupid) {

	DestroyDynamicPickup(pickupid);
	return 1;
}

timer Drug_ExplosionEffects[40000](playerid, iDrugID) {
	new Float:fPos[3];
	GetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]);
	if(Bit_State(arrPlayerBits[playerid], dr_bitUsedDrug))
	{
		new i = random(13);
		CreateExplosionForPlayer(playerid, fPos[0] - 50.0, fPos[1] + 50.0, fPos[2] + 20.0, i, 0.1);
		defer Drug_ExplosionEffects(playerid, iDrugID);
	}
	return 1;
}

/*
timer Drug_ResetGunPerk[20000](playerid)
{
	// for(new i; i < 11; ++i) SetPlayerSkillLevel(playerid, i, 1);
	return 1;
}
*/

timer Drug_SoundEffects[20000](playerid, iDrugID) {

	if(Bit_State(arrPlayerBits[playerid], dr_bitUsedDrug))
	{
		new i = random(8),
			j,
			Float:fPos[3];

		GetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]);
		switch(i)
		{
			case 0: j = 4803;
			case 1: j = 4807;
			case 2: j = 6201;
			case 3: j = 4200;
			case 4: j = 5461;
			case 5: j = 1076;
			case 6: j = 1097;
			case 7: j = 1183;
		}

		PlayerPlaySound(playerid, 1184, fPos[0], fPos[1], fPos[2]);
		PlayerPlaySound(playerid, j, fPos[0] + 10.0, fPos[1] + 10.0, fPos[2] + 40.0);
		defer Drug_SoundEffects(playerid, iDrugID);
	}
	return 1;
}


timer BM_Seize[60000 * 15](i) {

	new iCount;

	foreach(new p : Player) {

		if(IsACop(p)) {

			if(IsPlayerInRangeOfPoint(p, 20.0, arrBlackMarket[i][bm_fPos][0], arrBlackMarket[i][bm_fPos][1], arrBlackMarket[i][bm_fPos][2])) iCount++;
		}
	}
	if(iCount > 6) format(szMiscArray, sizeof(szMiscArray), "[Black Market]: {DDDDDD}%s's black market has been successfully seized.", arrGroupData[arrBlackMarket[i][bm_iGroupID]][g_szGroupName]);
	else {
		arrBlackMarket[i][bm_iSeized] = 0;
		format(szMiscArray, sizeof(szMiscArray), "[Black Market]:{EE0000}Failed to seize {DDDDDD}%s's {EE0000}black market.", arrGroupData[arrBlackMarket[i][bm_iGroupID]][g_szGroupName]);
	}
	foreach(new p : Player) SendClientMessageEx(p, COLOR_GREEN, szMiscArray);
	if(iCount > 6) {

		format(szMiscArray, sizeof(szMiscArray), "%s's Black Market\n\n{FF0000}Seized", arrGroupData[arrBlackMarket[i][bm_iGroupID]][g_szGroupName]);
		UpdateDynamic3DTextLabelText(arrBlackMarket[i][bm_iTextID], COLOR_GREEN, szMiscArray);
		format(szMiscArray, sizeof(szMiscArray), "UPDATE `blackmarkets` SET `seized` = '1' WHERE `id` = '%d'", i + 1);
		mysql_function_query(MainPipeline, szMiscArray, falze, "OnQueryFinish", "i", SENDDATA_THREAD);
	}

	new gz = GetGVarInt("BM_GZ"),
		iad = GetGVarInt("BM_A");

	DeleteGVar("BM_Time", i);
	DeleteGVar("BM_Capturer", i);
	GangZoneHideForAll(gz);
	GangZoneDestroy(gz);
	DestroyDynamicArea(iad);
}


hook OnPlayerConnect(playerid) {

	for(new i; i < sizeof(szDrugs); ++i) {
		PlayerInfo[playerid][p_iDrug][i] = 0;
		PlayerInfo[playerid][p_iDrugQuality][i] = 0;
		PlayerInfo[playerid][p_iDrugTaken][i] = 0;
		PlayerInfo[playerid][p_iAddicted][i] = 0;
		PlayerInfo[playerid][p_iAddictedLevel][i] = 0;
	}
	for(new i; i < sizeof(szIngredients); ++i) PlayerInfo[playerid][p_iIngredient][i] = 0;
	DeletePVar(playerid, PVAR_ATDRUGPOINT);
	DeletePVar(playerid, "Aliens");
	DeletePVar(playerid, "DS_BMTC");
	//DeletePVar(playerid, "AtDrugArea");
	DeletePVar(playerid, "AtBlackMarket");
	DeletePVar(playerid, "PO_CAPTUR");
	DeletePVar(playerid, "X");
	DeletePVar(playerid, "Y");
	DeletePVar(playerid, "Z");
	DeletePVar(playerid, "DR_LastTake");
	DeletePVar(playerid, "BM_PAY");
}

hook OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
	dr_iPlayerTimeStamp[playerid] = gettime();

	if(issuerid != INVALID_PLAYER_ID) {

		if(GetPVarInt(playerid, "Aliens")) {

			Aliens_ResetPlayer(playerid);
		}
	}
}

/*

hook OnPlayerDeath(playerid) {

	if(GetPVarType(playerid, "PO_CAPTUR")) {

		new i = GetPVarInt(playerid, "PO_CAPTUR");

		if(!GetGVarType("PO_CAPT", i)) DeletePVar(playerid, "PO_CAPTUR");
		else {

			DeleteGVar("PO_CAPT", i);
			DeletePVar(playerid, "PO_CAPTUR");
			GangZoneHideForAll(arrPoint[i][po_iZoneID]);

			foreach(new p : Player) if(PlayerInfo[p][pMember] == PlayerInfo[playerid][pMember]) SendClientMessageEx(p, COLOR_YELLOW, "The gang leader died. You failed to capture the point.");
		}
	}
}

*/

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {

	if((newkeys & KEY_YES)) {
		/*
		new areaid[1];
		GetPlayerDynamicAreas(playerid, areaid);
		*/
		Process_DAreas(playerid);
	}
	return 1;
}

hook OnPlayerLeaveDynamicArea(playerid, areaid) {
	
	DeletePVar(playerid, "AtDrugArea");
	DeletePVar(playerid, "AtBlackMarket");
	DeletePVar(playerid, "AtPoint");
}

Run_KickPlayer(playerid) {

	SendClientMessageEx(playerid, COLOR_LIGHTRED, "[SYSTEM]: You're possibly exploiting a system and administrators have been notified. Don't do that again!");
	// SetTimerEx("KickEx", 1000, false, "i", playerid);
	format(szMiscArray, sizeof(szMiscArray), "{AA3333}AdmWarning{FFFF00}: %s (ID %d) is possibly TP-running (drug smuggle).", GetPlayerNameEx(playerid), playerid);
	ABroadCast(COLOR_YELLOW, szMiscArray, 2);
	return 1;
}

hook OnPlayerEnterCheckpoint(playerid) {

	//DisablePlayerCheckpoint(playerid);
	switch(gPlayerCheckpointStatus[playerid]) {

		case CHECKPOINT_SMUGGLE_BLACKMARKET: {

			if(GetPVarInt(playerid, "RunTS") > (gettime() - 20)) {

				DisablePlayerCheckpoint(playerid);
				DeletePVar(playerid, "BM_PAY");
				DeletePVar(playerid, PVAR_ATDRUGPOINT);
				DeletePVar(playerid, "DrugPoint");
				DeletePVar(playerid, PVAR_SMUGGLE_DELIVERINGTO);
				DeletePVar(playerid, "Smuggling");
				gPlayerCheckpointStatus[playerid] = CHECKPOINT_NONE;
				return Run_KickPlayer(playerid);
			}

			DeletePVar(playerid, "RunTS");
			if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not in a vehicle.");
			new iVehID = GetPlayerVehicleID(playerid),
				iBlackMarketID = GetPVarInt(playerid, PVAR_SMUGGLE_DELIVERINGTO),
				iPointID = GetPVarInt(playerid, PVAR_ATDRUGPOINT);

			SendClientMessageEx(playerid, COLOR_GREEN, "____________ Drug Smuggle Completed ____________");

			format(szMiscArray, sizeof(szMiscArray), "------ %s's Black Market (po. %d) ------", arrGroupData[arrBlackMarket[iBlackMarketID][bm_iGroupID]][g_szGroupName], iPointID);
			SendClientMessageEx(playerid, COLOR_GRAD1, szMiscArray);

			for(new i; i < sizeof(szIngredients); ++i) {

				if(arrSmuggleVehicle[iVehID][smv_iIngredientAmount][i] > 0)	{

					format(szMiscArray, sizeof(szMiscArray), "Delivered: %s | Pieces: %d", szIngredients[i], arrSmuggleVehicle[iVehID][smv_iIngredientAmount][i]);
					SendClientMessageEx(playerid, COLOR_GRAD1, szMiscArray);
					arrBlackMarket[iBlackMarketID][bm_iIngredientAmount][i] += arrSmuggleVehicle[iVehID][smv_iIngredientAmount][i]; // ROTHSCHILD - MONEY EXPLOIT HERE
					arrGroupData[arrPoint[iPointID][po_iGroupID]][g_iBudget] += (10 * arrSmuggleVehicle[iVehID][smv_iIngredientAmount][i]); // $10 per amount goes to Point's gang locker.
					arrSmuggleVehicle[iVehID][smv_iIngredientAmount][i] = 0;

					format(szMiscArray, sizeof(szMiscArray), "UPDATE `blackmarkets` SET `%s` = '%d' WHERE `id` = '%d'",
						DS_Ingredients_GetSQLName(i), arrBlackMarket[iBlackMarketID][bm_iIngredientAmount][i], iBlackMarketID + 1);
					mysql_function_query(MainPipeline, szMiscArray, false, "OnQueryFinish", "i", SENDDATA_THREAD);
				}
			}

			// new iCash = GetPVarInt(playerid, "BM_PAY");
			new iCash = 500;

			if(arrGroupData[arrBlackMarket[iBlackMarketID][bm_iGroupID]][g_iBudget] - iCash > 0) {

				GivePlayerCash(playerid, iCash);

				/*if(arrBlackMarket[iBlackMarketID][bm_iGroupID] == arrPoint[iPointID][po_iGroupID])
					arrGroupData[arrBlackMarket[iBlackMarketID][bm_iGroupID]][g_iBudget] -= iCash;*/

				arrGroupData[arrBlackMarket[iBlackMarketID][bm_iGroupID]][g_iBudget] -= iCash;

				SendClientMessage(playerid, COLOR_GRAD1, "--------------------------");
				format(szMiscArray, sizeof(szMiscArray), "Pay: $%s\n", number_format(iCash));
				SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
				SendClientMessageEx(playerid, COLOR_GREEN, "____________________________________________");

				format(szMiscArray, sizeof(szMiscArray), "You received $%s from %s's (ID %d) point delivery to %s's (ID %d) black market",
					number_format(iCash), GetPlayerNameExt(playerid), GetPlayerSQLId(playerid), arrGroupData[arrPoint[iPointID][po_iGroupID]][g_szGroupName], arrPoint[iPointID][po_iGroupID]);
				GroupLog(arrPoint[iPointID][po_iGroupID], szMiscArray);

				format(szMiscArray, sizeof(szMiscArray), "%s (%d) has been paid $%s for a delivery to %s's (ID %d) black market",
					GetPlayerNameExt(playerid), GetPlayerSQLId(playerid), number_format(iCash), arrGroupData[arrBlackMarket[iBlackMarketID][bm_iGroupID]][g_szGroupName], arrBlackMarket[iBlackMarketID][bm_iGroupID]);
				Log("logs/drugsmuggles.log", szMiscArray);
			}
			else SendClientMessageEx(playerid, COLOR_RED, "There was insufficient money to pay you for your services!");

			DisablePlayerCheckpoint(playerid);
			DeletePVar(playerid, "BM_PAY");
			DeletePVar(playerid, PVAR_ATDRUGPOINT);
			DeletePVar(playerid, "DrugPoint");
			DeletePVar(playerid, PVAR_SMUGGLE_DELIVERINGTO);
			DeletePVar(playerid, "Smuggling");
			gPlayerCheckpointStatus[playerid] = CHECKPOINT_NONE;
			
			PlayerInfo[playerid][pSmugSkill] += 1;
  			if(PlayerInfo[playerid][pSmugSkill] == 50) SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* You have reached level 2 of the drug smuggling skill.");
			if(PlayerInfo[playerid][pSmugSkill] == 100) SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* You have reached level 3 of the drug smuggling skill.");
			if(PlayerInfo[playerid][pSmugSkill] == 200) SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* You have reached level 4 of the drug smuggling skill.");
			if(PlayerInfo[playerid][pSmugSkill] == 400) SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* You have reached level 5 of the drug smuggling skill.");
			if(PlayerInfo[playerid][pSmugSkill] > 400) PlayerInfo[playerid][pSmugSkill] = 400;

		}

		case CHECKPOINT_SMUGGLE_PLAYER:	{

			if(GetPVarInt(playerid, "RunTS") > (gettime() - 20)) {

				DisablePlayerCheckpoint(playerid);
				DeletePVar(playerid, "DrugPoint");
				DeletePVar(playerid, PVAR_ATDRUGPOINT);
				DeletePVar(playerid, PVAR_SMUGGLE_DELIVERINGTO);
				DeletePVar(playerid, "Smuggling");
				gPlayerCheckpointStatus[playerid] = CHECKPOINT_NONE;
				return Run_KickPlayer(playerid);
			}

			DeletePVar(playerid, "RunTS");
			if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not in a vehicle.");

			new iVehID = GetPlayerVehicleID(playerid),
				iPointID = GetPVarInt(playerid, PVAR_ATDRUGPOINT),
				iPointRevenue,
				iCash = 10;

			SendClientMessageEx(playerid, COLOR_GREEN, "____________ Drug Smuggle Completed ____________");
			format(szMiscArray, sizeof(szMiscArray), "%s's Point (ID %d)", arrGroupData[arrPoint[iPointID][po_iGroupID]][g_szGroupName], iPointID);
			SendClientMessageEx(playerid, COLOR_GRAD1, szMiscArray);

			for(new i; i < sizeof(szIngredients); ++i) {

				if(arrSmuggleVehicle[iVehID][smv_iIngredientAmount][i] > 0) {

					format(szMiscArray, sizeof(szMiscArray), "Delivered: %s | Pieces: %d", szIngredients[i], arrSmuggleVehicle[iVehID][smv_iIngredientAmount][i]);
					SendClientMessageEx(playerid, COLOR_GRAD1, szMiscArray);
					PlayerInfo[playerid][p_iIngredient][i] += arrSmuggleVehicle[iVehID][smv_iIngredientAmount][i];
					// arrGroupData[arrPoint[iPointID][po_iGroupID]][g_iBudget] += (10 * arrSmuggleVehicle[iVehID][smv_iIngredientAmount][i]);
					arrGroupData[arrPoint[iPointID][po_iGroupID]][g_iBudget] += iCash;
					// iPointRevenue += (10 * arrSmuggleVehicle[iVehID][smv_iIngredientAmount][i]);
					iPointRevenue += iCash;
					arrSmuggleVehicle[iVehID][smv_iIngredientAmount][i] = 0;
				}
			}

			SendClientMessageEx(playerid, COLOR_GREEN, "____________________________________________");

			format(szMiscArray, sizeof(szMiscArray), "You received $%s from %s's (ID %d) point delivery to %s's (ID %d) black market",
				number_format(iCash), GetPlayerNameExt(playerid), GetPlayerSQLId(playerid), arrGroupData[arrPoint[iPointID][po_iGroupID]][g_szGroupName], arrPoint[iPointID][po_iGroupID]);
			GroupLog(arrPoint[iPointID][po_iGroupID], szMiscArray);

			format(szMiscArray, sizeof(szMiscArray), "%s (%d) has received $10 for a delivery by %s's (ID %d).",
				arrGroupData[arrPoint[iPointID][po_iGroupID]][g_szGroupName], arrPoint[iPointID][po_iGroupID], GetPlayerNameExt(playerid), GetPlayerSQLId(playerid));
			Log("logs/drugsmuggles.log", szMiscArray);

			Point_AddUsage(iPointID, iPointRevenue);

			DisablePlayerCheckpoint(playerid);
			DeletePVar(playerid, "DrugPoint");
			DeletePVar(playerid, PVAR_ATDRUGPOINT);
			DeletePVar(playerid, PVAR_SMUGGLE_DELIVERINGTO);
			DeletePVar(playerid, "Smuggling");
			gPlayerCheckpointStatus[playerid] = CHECKPOINT_NONE;
			

			PlayerInfo[playerid][pSmugSkill] += 1;
   			if(PlayerInfo[playerid][pSmugSkill] == 50) SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* You have reached level 2 of the drug smuggling skill.");
			if(PlayerInfo[playerid][pSmugSkill] == 100) SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* You have reached level 3 of the drug smuggling skill.");
			if(PlayerInfo[playerid][pSmugSkill] == 200) SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* You have reached level 4 of the drug smuggling skill.");
			if(PlayerInfo[playerid][pSmugSkill] == 400) SendClientMessageEx(playerid, COLOR_LIGHTBLUE,"* You have reached level 5 of the drug smuggling skill.");
			if(PlayerInfo[playerid][pSmugSkill] > 400) PlayerInfo[playerid][pSmugSkill] = 400;
		}
	}
	return 1;
}

Point_AddUsage(iPointID, iPointRevenue) {

	format(szMiscArray, sizeof(szMiscArray), "UPDATE `dynpoints` SET `traffic` = traffic + '1', `revenue` = revenue + '%d' WHERE `id` = '%d'", iPointRevenue, iPointID + 1);
	mysql_function_query(MainPipeline, szMiscArray, false, "OnQueryFinish", "i", SENDDATA_THREAD);
}

Point_ResetUsage(iPointID) {

	format(szMiscArray, sizeof(szMiscArray), "UPDATE `dynpoints` SET `traffic` = '0', `revenue` = '0' WHERE `id` = '%d'", iPointID + 1);
	mysql_function_query(MainPipeline, szMiscArray, false, "OnQueryFinish", "i", SENDDATA_THREAD);
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case DIALOG_DRUGS_MIX_START:
		{
			if(!response) return 1;
			SetPVarInt(playerid, PVAR_MAKINGDRUG, listitem);
			format(szMiscArray, sizeof(szMiscArray), "[Drugs]: {CCCCCC}You started making: {FFFF00}%s{CCCCCC}. Use /clearmix to start over.", szDrugs[listitem]);
			SendClientMessageEx(playerid, COLOR_GREEN, szMiscArray);
			Drug_ShowMix(playerid);
		}
		case DIALOG_DRUGS_MIX_MAIN:
		{
			if(!response) return DeletePVar(playerid, PVAR_DRUGS_MIXSLOT), 1;
			if(listitem == MAX_DRUGINGREDIENT_SLOTS) return 1;
			if(listitem == MAX_DRUGINGREDIENT_SLOTS+1) {
				Drug_FinishMix(playerid, GetPVarInt(playerid, PVAR_MAKINGDRUG));
				return 1;
			}
			SetPVarInt(playerid, PVAR_DRUGS_MIXSLOT, listitem);
			szMiscArray[0] = 0;
			for(new i; i < sizeof(szIngredients); ++i)
			{
				format(szMiscArray, sizeof(szMiscArray), "%s%s\n", szMiscArray, szIngredients[i]);
			}
			ShowPlayerDialogEx(playerid, DIALOG_DRUGS_MIX_INGREDIENT, DIALOG_STYLE_LIST, "Drug Mix | Choose ingredient", szMiscArray, "Select", "Back");
		}
		case DIALOG_DRUGS_MIX_INGREDIENT:
		{
			if(!response) return Drug_ShowMix(playerid);
			dr_arrDrugMix[playerid][GetPVarInt(playerid, PVAR_DRUGS_MIXSLOT)][drm_iIngredientID] = listitem;
			ShowPlayerDialogEx(playerid, DIALOG_DRUGS_MIX_AMOUNT, DIALOG_STYLE_INPUT, "Drug Mix | How many pieces?", "Specify the amount of pieces you would like to put in your mix.", "Enter", "Cancel");
		}
		case DIALOG_DRUGS_MIX_AMOUNT:
		{
			if(!response || isnull(inputtext) || !IsNumeric(inputtext))
			{
				for(new i; i < sizeof(szIngredients); ++i)
				{
					format(szMiscArray, sizeof(szMiscArray), "%s%s\n", szMiscArray, szIngredients[i]);
				}
				ShowPlayerDialogEx(playerid, DIALOG_DRUGS_MIX_INGREDIENT, DIALOG_STYLE_LIST, "Drug Mix | Choose ingredient", szMiscArray, "Select", "Back");
			}
			else
			{
				if(strval(inputtext) > 50) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot add more than 50 pieces.");
				new iSlotID = GetPVarInt(playerid, PVAR_DRUGS_MIXSLOT),
					iIngredientID = dr_arrDrugMix[playerid][iSlotID][drm_iIngredientID];
				if(PlayerInfo[playerid][p_iIngredient][iIngredientID] < strval(inputtext)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You do not have enough on you.");
				dr_arrDrugMix[playerid][GetPVarInt(playerid, PVAR_DRUGS_MIXSLOT)][drm_iAmount] = strval(inputtext);
				format(szMiscArray, sizeof(szMiscArray), "[Drug Slot #%d] {CCCCCC}You added %d pieces of %s to your mixture.", iSlotID, strval(inputtext), szIngredients[iIngredientID]);
				SendClientMessageEx(playerid, COLOR_GREEN, szMiscArray);
				Drug_ShowMix(playerid);
			}
		}
		case DIALOG_BLACKMARKET_CREATE: {

			if(!response) return 1;
			new iGroupID = ListItemTrackId[playerid][listitem],
				i = Iter_Free(BlackMarkets);
			if(i != -1) {
				format(szMiscArray, sizeof(szMiscArray), "SELECT `id` FROM `blackmarkets` WHERE `groupid` = '%d'", iGroupID);
				mysql_function_query(MainPipeline, szMiscArray, true, "BM_OnCheckBlackMarket", "iii", playerid, i, iGroupID);
			}
			else SendClientMessageEx(playerid, COLOR_GRAD1, "The maximum amount of blackmarkets has been reached.");
		}
		case DIALOG_BLACKMARKET_MAIN:
		{
			if(!response) return DeletePVar(playerid, PVAR_BLMARKETID), 1;
			switch(listitem)
			{
				case 0: BM_ShowBlackMarketOrders(playerid);
				case 1: BM_ShowBlackMarket(playerid);
				case 2: BM_EditBlackMarket(playerid, GetPVarInt(playerid, PVAR_BLMARKETID), 0);
				case 3: BM_EditBlackMarket(playerid, GetPVarInt(playerid, PVAR_BLMARKETID), 1);
				case 4: BM_EditBlackMarket(playerid, GetPVarInt(playerid, PVAR_BLMARKETID), 2);
			}
		}
		case DIALOG_BLACKMARKET_EDITPRICE:
		{
			if(!response) return DeletePVar(playerid, PVAR_BM_EDITINGID), DeletePVar(playerid, PVAR_BLMARKETID), 1;
			SetPVarInt(playerid, PVAR_BM_EDITINGID, listitem);
			format(szMiscArray, sizeof(szMiscArray), "Specify the price of the {FFFF00}%s.", szIngredients[listitem]);
			ShowPlayerDialogEx(playerid, DIALOG_BLACKMARKET_EDITPRICE2, DIALOG_STYLE_INPUT, "Black Market | Edit Price", szMiscArray, "Set", "<<");
		}
		case DIALOG_BLACKMARKET_EDITPRICE2:
		{
			if(!response || isnull(inputtext) || strval(inputtext) < 0 || !IsNumeric(inputtext)) return BM_EditBlackMarket(playerid, GetPVarInt(playerid, PVAR_BLMARKETID), 0), 1;
			BM_OnEditBlackMarket(playerid, GetPVarInt(playerid, PVAR_BLMARKETID), GetPVarInt(playerid, PVAR_BM_EDITINGID), strval(inputtext), 0);
			DeletePVar(playerid, PVAR_BM_EDITINGID);
			return 1;
		}
		case DIALOG_BLACKMARKET_EDITPAYMENT:
		{
			if(!response) return DeletePVar(playerid, PVAR_BM_EDITINGID), DeletePVar(playerid, PVAR_BLMARKETID), 1;
			SetPVarInt(playerid, PVAR_BM_EDITINGID, listitem);
			format(szMiscArray, sizeof(szMiscArray), "Specify the smuggle payment of the {FFFF00}%s.", szIngredients[listitem]);
			ShowPlayerDialogEx(playerid, DIALOG_BLACKMARKET_EDITPAYMENT2, DIALOG_STYLE_INPUT, "Black Market | Edit Smuggle Payment", szMiscArray, "Set", "<<");
		}
		case DIALOG_BLACKMARKET_EDITPAYMENT2:
		{
			if(!response || isnull(inputtext) || strval(inputtext) < 0 || !IsNumeric(inputtext)) return BM_EditBlackMarket(playerid, GetPVarInt(playerid, PVAR_BLMARKETID), 0), 1;
			BM_OnEditBlackMarket(playerid, GetPVarInt(playerid, PVAR_BLMARKETID), GetPVarInt(playerid, PVAR_BM_EDITINGID), strval(inputtext), 1);
			DeletePVar(playerid, PVAR_BM_EDITINGID);
			return 1;
		}
		case DIALOG_BLACKMARKET_TRANSFERC: {

			if(!response) return 1;

			new iBlackMarketID = GetPVarInt(playerid, PVAR_BLMARKETID);

			SetPVarInt(playerid, "DS_BMTC", listitem);

			szMiscArray = "Ingredient Name\tPieces\n";

			switch(listitem) {
				case 0: {

					for(new i; i < sizeof(szIngredients); ++i) {

						format(szMiscArray, sizeof(szMiscArray), "%s%s\t%d\n", szMiscArray, szIngredients[i], arrGroupData[PlayerInfo[playerid][pMember]][g_iIngredients][i]);
					}
				}
				case 1: {

					for(new i; i < sizeof(szIngredients); ++i) {

						format(szMiscArray, sizeof(szMiscArray), "%s%s\t%d\n", szMiscArray, szIngredients[i], arrBlackMarket[iBlackMarketID][bm_iIngredientAmount][i]);
					}
				}
			}
			return ShowPlayerDialogEx(playerid, DIALOG_BLACKMARKET_TRANSFER, DIALOG_STYLE_TABLIST_HEADERS, "Black Market | Transfer Stock", szMiscArray, "Edit", "<<");
		}
		case DIALOG_BLACKMARKET_TRANSFER:
		{
			if(!response) return DeletePVar(playerid, PVAR_BM_EDITINGID), DeletePVar(playerid, PVAR_BLMARKETID), 1;
			SetPVarInt(playerid, PVAR_BM_EDITINGID, listitem);
			format(szMiscArray, sizeof(szMiscArray), "Specify the transfer amount of the {FFFF00}%s.", szIngredients[listitem]);
			ShowPlayerDialogEx(playerid, DIALOG_BLACKMARKET_TRANSFER2, DIALOG_STYLE_INPUT, "Black Market | Transfer Stock", szMiscArray, "Set", "<<");
		}
		case DIALOG_BLACKMARKET_TRANSFER2:
		{
			if(!response || isnull(inputtext) || strval(inputtext) < 0 || !IsNumeric(inputtext)) return BM_EditBlackMarket(playerid, GetPVarInt(playerid, PVAR_BLMARKETID), 1), 1;
			BM_OnEditBlackMarket(playerid, GetPVarInt(playerid, PVAR_BLMARKETID), GetPVarInt(playerid, PVAR_BM_EDITINGID), strval(inputtext), 2);
			DeletePVar(playerid, PVAR_BM_EDITINGID);
			return 1;
		}
		case DIALOG_BLACKMARKET_ORDER_ING:
		{
			if(!response) return DeletePVar(playerid, PVAR_BLMARKETID), DeletePVar(playerid, "AtBlackMarket"), 1;
			if(arrBlackMarket[GetPVarInt(playerid, PVAR_BLMARKETID)][bm_iIngredientPrice][listitem] < 1) return SendClientMessage(playerid, COLOR_GRAD1, "This item is not for sale.");
			SetPVarInt(playerid, PVAR_INGREDIENT_ORDERING, listitem);
			format(szMiscArray, sizeof(szMiscArray), "Black Market | Ingredient: %s", szIngredients[listitem]);
			ShowPlayerDialogEx(playerid, DIALOG_BLACKMARKET_ORDER_INGAM, DIALOG_STYLE_INPUT, szMiscArray, "Please specify the amount of pieces you would like to order.", "Order", "Cancel");
		}
		case DIALOG_BLACKMARKET_ORDER_INGAM:
		{
			if(!response) return DeletePVar(playerid, PVAR_INGREDIENT_ORDERING), 1;
			if(isnull(inputtext) || strval(inputtext) < 0 || !IsNumeric(inputtext) || strval(inputtext) > 1000) return SendClientMessageEx(playerid, COLOR_GRAD1, "You specified an invalid amount");
			Drug_OrderIngredient(playerid, GetPVarInt(playerid, PVAR_BLMARKETID), GetPVarInt(playerid, PVAR_INGREDIENT_ORDERING), strval(inputtext));
			DeletePVar(playerid, PVAR_INGREDIENT_ORDERING);
		}
		case DIALOG_BLACKMARKET_LIST:
		{
			if(!response) return DeletePVar(playerid, PVAR_BLMARKETID);
			SetPVarInt(playerid, PVAR_BLMARKETID, ListItemTrackId[playerid][listitem]);
			BM_BlackMarketMain(playerid);
			return 1;
		}
		case DIALOG_BLACKMARKET_ALIST:
		{
			if(!response) return 1;
			SetPlayerPos(playerid, arrBlackMarket[ListItemTrackId[playerid][listitem]][bm_fPos][0], arrBlackMarket[ListItemTrackId[playerid][listitem]][bm_fPos][1], arrBlackMarket[ListItemTrackId[playerid][listitem]][bm_fPos][2]);
			return 1;
		}
		case DIALOG_BLACKMARKET_APOINT:
		{
			if(!response) return 1;
			new Float:fPos[3],
				iBlackMarketID = ListItemTrackId[playerid][listitem];
			GetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]);
			new iVW = GetPlayerVirtualWorld(playerid),
				iINT = GetPlayerInterior(playerid);
			if(GetPlayerVirtualWorld(playerid) > 0 || GetPlayerInterior(playerid) > 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "Your virtual world and interior must be 0.");
			if(IsValidDynamicPickup(arrBlackMarket[iBlackMarketID][bm_iPickupID])) DestroyDynamicPickup(arrBlackMarket[iBlackMarketID][bm_iPickupID]);
			if(IsValidDynamic3DTextLabel(arrBlackMarket[iBlackMarketID][bm_iTextID])) DestroyDynamic3DTextLabel(arrBlackMarket[iBlackMarketID][bm_iTextID]);
			if(IsValidDynamicArea(arrBlackMarket[iBlackMarketID][bm_iAreaID])) DestroyDynamicArea(arrBlackMarket[iBlackMarketID][bm_iAreaID]);
			arrBlackMarket[iBlackMarketID][bm_iAreaID] = CreateDynamicSphere(fPos[0], fPos[1], fPos[2], 2.0);
			// Streamer_SetIntData(STREAMER_TYPE_AREA, arrBlackMarket[iBlackMarketID][bm_iAreaID], E_STREAMER_EXTRA_ID, iBlackMarketID);

			arrBlackMarket[iBlackMarketID][bm_fPos][0] = fPos[0];
			arrBlackMarket[iBlackMarketID][bm_fPos][1] = fPos[1];
			arrBlackMarket[iBlackMarketID][bm_fPos][2] = fPos[2];

			arrBlackMarket[iBlackMarketID][bm_iPickupID] = CreateDynamicPickup(1254, 1, fPos[0], fPos[1], fPos[2], .worldid = 0, .interiorid = 0, .streamdistance = 20.0);
			format(szMiscArray, sizeof(szMiscArray), "%s's Black Market\n{AAAAAA}ID: %d\n{FFFFFF}Press ~k~~CONVERSATION_YES~ to access the market.", arrGroupData[arrBlackMarket[iBlackMarketID][bm_iGroupID]][g_szGroupName], iBlackMarketID);
			arrBlackMarket[iBlackMarketID][bm_iTextID] = CreateDynamic3DTextLabel(szMiscArray, COLOR_GREEN, fPos[0], fPos[1], fPos[2] + 1.0, 10.0, .worldid = iVW, .interiorid = iINT);

			if(arrBlackMarket[iBlackMarketID][bm_iSeized]) {
				format(szMiscArray, sizeof(szMiscArray), "%s's Black Market\n\n{FF0000}Seized", arrGroupData[arrBlackMarket[iBlackMarketID][bm_iGroupID]][g_szGroupName]);
				UpdateDynamic3DTextLabelText(arrBlackMarket[iBlackMarketID][bm_iTextID], COLOR_GREEN, szMiscArray);
			}

			format(szMiscArray, sizeof(szMiscArray), "You successfully edited %s black market's position.", arrGroupData[arrBlackMarket[iBlackMarketID][bm_iGroupID]][g_szGroupName]);
			SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
			format(szMiscArray, sizeof(szMiscArray), "UPDATE `blackmarkets` SET `posx` = '%f', `posy` = '%f', `posz` = '%f', `vw` = '%d', `int` = '%d' WHERE `id` = '%d'", fPos[0], fPos[1], fPos[2], iVW, iINT, iBlackMarketID + 1);
			mysql_function_query(MainPipeline, szMiscArray, false, "OnQueryFinish", "i", SENDDATA_THREAD);
			return 1;
		}
		case DIALOG_BLACKMARKET_ADELPOINT:
		{
			if(!response) return 1;
			new Float:fPos[3],
				iBlackMarketID = ListItemTrackId[playerid][listitem];
			GetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]);
			if(GetPlayerVirtualWorld(playerid) > 0 || GetPlayerInterior(playerid) > 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "Your virtual world and interior must be 0.");
			if(IsValidDynamic3DTextLabel(arrBlackMarket[iBlackMarketID][bm_iDelTextID])) DestroyDynamic3DTextLabel(arrBlackMarket[iBlackMarketID][bm_iDelTextID]);
			format(szMiscArray, sizeof(szMiscArray), "{DDDDDD}Delivery Point\n%s's Black Market\n{AAAAAA}ID: %d", arrGroupData[arrBlackMarket[iBlackMarketID][bm_iGroupID]][g_szGroupName], iBlackMarketID);
			arrBlackMarket[iBlackMarketID][bm_iDelTextID] = CreateDynamic3DTextLabel(szMiscArray, COLOR_GREEN, fPos[0], fPos[1], fPos[2] + 1.0, 10.0, .worldid = 0, .interiorid = 0);
			format(szMiscArray, sizeof(szMiscArray), "You successfully edited %s black market's delivery point.", arrGroupData[arrBlackMarket[iBlackMarketID][bm_iGroupID]][g_szGroupName]);
			SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
			format(szMiscArray, sizeof(szMiscArray), "UPDATE `blackmarkets` SET `delposx` = '%f', `delposy` = '%f', `delposz` = '%f' WHERE `id` = '%d'", fPos[0], fPos[1], fPos[2], iBlackMarketID + 1);
			mysql_function_query(MainPipeline, szMiscArray, false, "OnQueryFinish", "i", SENDDATA_THREAD);
			return 1;
		}
		case DIALOG_BLACKMARKET_ADELBM:
		{
			new iBlackMarketID = ListItemTrackId[playerid][listitem];
			Iter_Remove(BlackMarkets, iBlackMarketID);
			DestroyDynamicPickup(arrBlackMarket[iBlackMarketID][bm_iPickupID]);
			DestroyDynamic3DTextLabel(arrBlackMarket[iBlackMarketID][bm_iTextID]);
			DestroyDynamic3DTextLabel(arrBlackMarket[iBlackMarketID][bm_iDelTextID]);
			arrBlackMarket[iBlackMarketID][bm_fPos][0] = 0.0;
			arrBlackMarket[iBlackMarketID][bm_fPos][1] = 0.0;
			arrBlackMarket[iBlackMarketID][bm_fPos][2] = 0.0;
			if(IsValidDynamicArea(arrBlackMarket[iBlackMarketID][bm_iAreaID])) DestroyDynamicArea(arrBlackMarket[iBlackMarketID][bm_iAreaID]);
			format(szMiscArray, sizeof(szMiscArray), "UPDATE `blackmarkets` SET `groupid` = '-1' WHERE `id` = '%d'", iBlackMarketID + 1);
			mysql_function_query(MainPipeline, szMiscArray, false, "BM_OnDeleteBlackMarket", "ii", playerid, iBlackMarketID);
		}
		case DIALOG_BLACKMARKET_ASEIZE: {

			new iBlackMarketID = ListItemTrackId[playerid][listitem];
			arrBlackMarket[iBlackMarketID][bm_iSeized] = 0;
			SendClientMessageEx(playerid, COLOR_GRAD1, "Successfully unseized the black market.");
			format(szMiscArray, sizeof(szMiscArray), "UPDATE `blackmarkets` SET `seized` = '0' WHERE `id` = '%d'", iBlackMarketID + 1);
			mysql_function_query(MainPipeline, szMiscArray, false, "OnQueryFinish", "i", SENDDATA_THREAD);

		}
		case DIALOG_BLACKMARKET_INGREDIENTS:
		{
			DeletePVar(playerid, PVAR_BLMARKETID);
			return 1;
		}
		case DIALOG_DRUGPOOL:
		{
			if(response) {

				new Float:fPos[3];
				gPlayerCheckpointStatus[playerid] = CHECKPOINT_NOTHING;
				Streamer_GetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, arrDrugData[ListItemTrackId[playerid][listitem]][dr_iTextID], E_STREAMER_X, fPos[0]);
				Streamer_GetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, arrDrugData[ListItemTrackId[playerid][listitem]][dr_iTextID], E_STREAMER_Y, fPos[1]);
				Streamer_GetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, arrDrugData[ListItemTrackId[playerid][listitem]][dr_iTextID], E_STREAMER_Z, fPos[2]);

				SetPlayerCheckpoint(playerid, fPos[0], fPos[1], fPos[2], 10.0);
			}
			return 1;
		}
		case DIALOG_SMUGGLE_PREPARE:
		{
			if(!response) return DeletePVar(playerid, "DrugPoint"), DeletePVar(playerid, "AtPoint"), 1;
			if(listitem == 0) return Smuggle_LoadIngredients(playerid), 1;
			if(listitem == sizeof(szIngredients)) return Smuggle_LoadIngredients(playerid), 1;
			if(strcmp(inputtext, "Start Smuggle", true) == 0)
			{
				new iTotalAmount,
					iCapacity = Smuggle_GetSmuggleCapacity(playerid) + Smuggle_GetVehicleCapacity(GetPlayerVehicleID(playerid)),
					iVehID = GetPlayerVehicleID(playerid);

				for(new i; i < sizeof(szIngredients); ++i) iTotalAmount += arrSmuggleVehicle[iVehID][smv_iIngredientAmount][i];

				if(iTotalAmount > iCapacity)
				{
					format(szMiscArray, sizeof(szMiscArray), "You cannot smuggle more than %d pieces.", iCapacity);
					SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
					Smuggle_LoadIngredients(playerid);
					return 1;
				}
				// return ShowPlayerDialogEx(playerid, DIALOG_SMUGGLE_DELIVERTO, DIALOG_STYLE_LIST, "Smuggle | Deliver to Black Market or own storage?", "Black Market\nOwn Storage", "Select", "Cancel");
				Smuggle_StartSmuggle(playerid);
				return 1;
			}
			SetPVarInt(playerid, PVAR_INGREDIENT_ORDERING, listitem - 1);
			format(szMiscArray, sizeof(szMiscArray), "Specify the amount you would like to add to package:\n\n {FFFF00}%s.", szIngredients[listitem - 1]);
			ShowPlayerDialogEx(playerid, DIALOG_SMUGGLE_PREPARE2, DIALOG_STYLE_INPUT, "Drug Smuggle | Add to Package", szMiscArray, "Set", "<<");
		}
		case DIALOG_SMUGGLE_PREPARE2:
		{
			if(!response || isnull(inputtext) || strval(inputtext) < 0 || !IsNumeric(inputtext)) return DeletePVar(playerid, PVAR_INGREDIENT_ORDERING), Smuggle_LoadIngredients(playerid), SendClientMessageEx(playerid, COLOR_GRAD1, "You specified an invalid amount.");
			arrSmuggleVehicle[GetPlayerVehicleID(playerid)][smv_iIngredientAmount][GetPVarInt(playerid, PVAR_INGREDIENT_ORDERING)] = strval(inputtext);
			DeletePVar(playerid, PVAR_INGREDIENT_ORDERING);
			Smuggle_LoadIngredients(playerid);
			return 1;
		}
		case DIALOG_SMUGGLE_DELIVERTO:
		{
			if(!response) return Smuggle_LoadIngredients(playerid);
			switch(listitem)
			{
				case 0: Smuggle_GetBMDelPos(playerid);
				case 1: Smuggle_StartSmuggle(playerid);
			}
			return 1;
		}
		case DIALOG_SMUGGLE_BMDELPOINT:
		{
			if(!response) return Smuggle_LoadIngredients(playerid);
			Smuggle_StartSmuggle(playerid, ListItemTrackId[playerid][listitem]);
			return 1;
		}

		case DIALOG_POINT_NAME: {

			if(!isnull(inputtext) && !IsNumeric(inputtext)) {

				SetPVarString(playerid, "PO_Name", inputtext);
				return ShowPlayerDialogEx(playerid, DIALOG_POINT_TYPE, DIALOG_STYLE_LIST, "Create Point", "Weapon Point\nDrug Point", "Select", "Cancel");
			}
			else return SendClientMessageEx(playerid, COLOR_GRAD1, "You specified an invalid name.");
		}
		case DIALOG_POINT_TYPE: {

			if(response) {

				new Float:fPos[3];

				new i = Iter_Free(Points);
				if(i != -1) {

					if(GetPlayerInterior(playerid) != 0 || GetPlayerVirtualWorld(playerid) != 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "You can only create points in the exterior world.");
					GetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]);
					new szName[MAX_PLAYER_NAME];
					arrPoint[i][po_iType] = listitem;
					arrPoint[i][po_iCapturable] = 1;
					arrPoint[i][po_iGroupID] = INVALID_GROUP_ID;
					arrPoint[i][po_fPos][0] = fPos[0];
					arrPoint[i][po_fPos][1] = fPos[1];
					arrPoint[i][po_fPos][2] = fPos[2];

					GetPVarString(playerid, "PO_Name", szName, sizeof(szName));
					DeletePVar(playerid, "PO_NAME");

					format(arrPoint[i][po_szPointName], MAX_PLAYER_NAME, szName);

					mysql_escape_string(szName, szName);

					format(szMiscArray, sizeof(szMiscArray), "UPDATE `dynpoints` SET `type` = '%d', `name` = '%s', `capturable` = '1', `timestamp` = '%d', `groupid` = '%d', `posx` = '%f', `posy` = '%f', `posz` = '%f', `vw` = '%d', `int` = '%d' WHERE `id` = '%d'",
						listitem, szName, gettime() + 14400, INVALID_GROUP_ID, fPos[0], fPos[1], fPos[2], GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), i + 1);

					mysql_function_query(MainPipeline, szMiscArray, false, "PO_OnCreatePoint", "ii", playerid, i);
					PO_CreatePoint(i, fPos[0], fPos[1], fPos[2], fPos[0], fPos[1], fPos[2]);
				}
				else SendClientMessageEx(playerid, COLOR_GRAD1, "The maximum amount of points has been reached.");
			}
		}
		case DIALOG_POINT_LIST: {

			if(response) {

				if(listitem == 0) return 1;

				new i = ListItemTrackId[playerid][listitem-1];

				Player_KillCheckPoint(playerid);
				if(!IsAdminLevel(playerid, ADMIN_GENERAL, 0)) {

					gPlayerCheckpointStatus[playerid] = CHECKPOINT_NOTHING;
					SetPlayerCheckpoint(playerid, arrPoint[i][po_fPos][0], arrPoint[i][po_fPos][1], arrPoint[i][po_fPos][2], 2.0);
				}
				else {

					SetPlayerPos(playerid, arrPoint[i][po_fPos][0], arrPoint[i][po_fPos][1], arrPoint[i][po_fPos][2]);
					SetPlayerVirtualWorld(playerid, 0);
					SetPlayerInterior(playerid, 0);
				}
				return 1;
			}
		}
		case DIALOG_PVEHICLE_DRUGS: {
			if(!response) return DeletePVar(playerid, "PVDTransfer"), DeletePVar(playerid, "PVehID");
			if(listitem == sizeof(szDrugs)) return Drug_TransferAllToVeh(playerid, GetPVarInt(playerid, "PVehID"), GetPVarInt(playerid, "PVDTransfer"));
			SetPVarInt(playerid, "PVDrug", listitem);
			switch(GetPVarInt(playerid, "PVDTransfer")) {

				case 0: ShowPlayerDialogEx(playerid, DIALOG_PVEHICLE_DRUGS2, DIALOG_STYLE_INPUT, "Drugs | Withdraw Amount", "\
					Please enter the amount you want to take from the vehicle.", "Withdraw", "Cancel");
				case 1: ShowPlayerDialogEx(playerid, DIALOG_PVEHICLE_DRUGS2, DIALOG_STYLE_INPUT, "Drugs | Deposit Amount", "\
					Please enter the amount you want to put into the vehicle.", "Deposit", "Cancel");
			}
		}
		case DIALOG_PVEHICLE_DRUGS2: {
			if(!response) return DeletePVar(playerid, "PVDrug"), DeletePVar(playerid, "PVDTransfer"), DeletePVar(playerid, "PVehID");
			new iDrugID = GetPVarInt(playerid, "PVDrug");
			DeletePVar(playerid, "PVDrug");
			switch(GetPVarInt(playerid, "PVDTransfer")) {
				case 0: {
					if(!(0 < strval(inputtext) <= PlayerVehicleInfo[playerid][GetPVarInt(playerid, "PVehID")][pvDrugs][iDrugID])) {
						return SendClientMessageEx(playerid, COLOR_GRAD1, "You specified an invalid amount.");
					}
					PlayerInfo[playerid][p_iDrug][iDrugID] += strval(inputtext);
					PlayerVehicleInfo[playerid][GetPVarInt(playerid, "PVehID")][pvDrugs][iDrugID] -= strval(inputtext);

					format(szMiscArray, sizeof(szMiscArray), "You took %d grams of %s from your vehicle.", strval(inputtext), szDrugs[iDrugID]);
					SendClientMessageEx(playerid, COLOR_GRAD1, szMiscArray);
				}
				case 1: {
					if(!(0 < strval(inputtext) <= PlayerInfo[playerid][p_iDrug][iDrugID])) return SendClientMessageEx(playerid, COLOR_GRAD1, "You specified an invalid amount.");
					PlayerInfo[playerid][p_iDrug][iDrugID] -= strval(inputtext);
					PlayerVehicleInfo[playerid][GetPVarInt(playerid, "PVehID")][pvDrugs][iDrugID] += strval(inputtext);

					format(szMiscArray, sizeof(szMiscArray), "You put %d grams of %s in your vehicle.", strval(inputtext), szDrugs[iDrugID]);
					SendClientMessageEx(playerid, COLOR_GRAD1, szMiscArray);
				}
			}
			g_mysql_SaveAccount(playerid);
			g_mysql_SaveVehicle(playerid, GetPVarInt(playerid, "PVehID"));
			DeletePVar(playerid, "PVDTransfer");
			DeletePVar(playerid, "PVehID");
		}
		case DIALOG_DRUG_INTERACT: {
			if(!response) return DeletePVar(playerid, "AtDrugArea"), 1;
			new i = GetPVarInt(playerid, "AtDrugArea");
			if(IsACop(playerid)) {
				switch(listitem) {
					case 0: { // Harvest
						Drugs_Retrieve(playerid, i);
					}
					case 1: { // Remove
						Drugs_Remove(playerid, i);
					}
				}
			}
			else Drugs_Retrieve(playerid, i);
		}
	}
	return 0;
}


forward Point_OnCapCheck();
public Point_OnCapCheck() {

	new iRows,
		iFields,
		iCount,
		i;

	cache_get_data(iRows, iFields, MainPipeline);

	while(iCount < iRows) {

		i = cache_get_field_content_int(iCount, "id", MainPipeline);
		format(szMiscArray, sizeof(szMiscArray), "UPDATE `dynpoints` SET `capturable` = '1' AND `timestamp` = '0' WHERE `id` = '%d'", i);
		mysql_function_query(MainPipeline, szMiscArray, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	
		i -= 1; // MySQL -> Game.
		foreach(new p : Player) {

			format(szMiscArray, sizeof(szMiscArray), "%s has become available for capture.", arrPoint[i][po_szPointName]);
			ChatTrafficProcess(p, COLOR_YELLOW, szMiscArray, 22);
		}

		arrPoint[i][po_iCapturable] = 1;

		// Weapon Factories
		if(arrPoint[i][po_iType] == 0) {

			new newammo = Random(150, 200), // amount of ammo created per 3 hours.
				totammo,
				iGroupID = arrPoint[i][po_iGroupID];

			AddGroupSafeWeapon(INVALID_PLAYER_ID, iGroupID, WEAPON_COLT45, 20);
			AddGroupSafeWeapon(INVALID_PLAYER_ID, iGroupID, WEAPON_SILENCED, 20);
			AddGroupSafeWeapon(INVALID_PLAYER_ID, iGroupID, WEAPON_DEAGLE, 20);
			AddGroupSafeWeapon(INVALID_PLAYER_ID, iGroupID, WEAPON_SHOTGUN, 20);
			AddGroupSafeWeapon(INVALID_PLAYER_ID, iGroupID, WEAPON_SAWEDOFF, 5);
			AddGroupSafeWeapon(INVALID_PLAYER_ID, iGroupID, WEAPON_SHOTGSPA, 5);
			AddGroupSafeWeapon(INVALID_PLAYER_ID, iGroupID, WEAPON_UZI, 35);
			AddGroupSafeWeapon(INVALID_PLAYER_ID, iGroupID, WEAPON_TEC9, 35);
			AddGroupSafeWeapon(INVALID_PLAYER_ID, iGroupID, WEAPON_AK47, 35);
			AddGroupSafeWeapon(INVALID_PLAYER_ID, iGroupID, WEAPON_M4, 5);
			AddGroupSafeWeapon(INVALID_PLAYER_ID, iGroupID, WEAPON_RIFLE, 20);
			AddGroupSafeWeapon(INVALID_PLAYER_ID, iGroupID, WEAPON_SNIPER, 5);

			for(new j; j < 5; ++j) {

				arrGroupData[iGroupID][g_iAmmo][j] += newammo;
				totammo += newammo;
			}

			foreach(new p : Player) {

				if(PlayerInfo[p][pMember] == arrPoint[i][po_iGroupID]) {

					format(szMiscArray, sizeof(szMiscArray), "[Weapon Point] - {DDDDDD}weapons and %d rounds of ammo have been added to your locker from a weapon factory you own.", totammo);
					SendClientMessageEx(p, COLOR_GREEN, szMiscArray);
				}
			}
			SaveGroup(iGroupID);
		}
		iCount++;
	}
}

Process_DAreas(playerid) {

	if(GetPVarType(playerid, "IsInArena")) return 1;

	new areaid[1];
	GetPlayerDynamicAreas(playerid, areaid);

	if(IsPlayerInAnyDynamicArea(playerid)) {
		for(new i; i < MAX_BLACKMARKETS; ++i) {
			
			if(areaid[0] == arrBlackMarket[i][bm_iAreaID]) {
			// if(IsPlayerInRangeOfPoint(playerid, 2.0, arrBlackMarket[i][bm_fPos][0], arrBlackMarket[i][bm_fPos][1], arrBlackMarket[i][bm_fPos][2])) {
				if(arrBlackMarket[i][bm_iSeized]) SendClientMessageEx(playerid, COLOR_GRAD1, "This black market is currently seized.");
				else {
					SetPVarInt(playerid, PVAR_BLMARKETID, i);
					BM_BlackMarketMain(playerid);
				}
				break;
			}
		}
		for(new i; i < MAX_DYNPOINTS; ++i) {
			
			// if(areaid[0] == arrPoint[i][po_iAreaID]) {
			if(IsPlayerInRangeOfPoint(playerid, 2.0, arrPoint[i][po_fPos][0], arrPoint[i][po_fPos][1], arrPoint[i][po_fPos][2]) && PlayerInfo[playerid][pVW] == 0) {
				if(arrPoint[i][po_iType] == 0) cmd_getmats(playerid, "");
			
				if(arrPoint[i][po_iType] == 1) {
					if(GetPVarType(playerid, "Smuggling")) return SendClientMessageEx(playerid, COLOR_GRAD1, "You must complete your current smuggle before you can start another!");
					if(!IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessageEx(playerid, COLOR_GRAD1, "You must be driving a vehicle to load ingredients.");

					SetPVarInt(playerid, "DrugPoint", i);
					SetPVarInt(playerid, PVAR_ATDRUGPOINT, i);
					Smuggle_LoadIngredients(playerid);
				}
				break;
			}
		}
	}
	
	/*
	if(IsPlayerInAnyDynamicArea(playerid)) {

		for(new i = 0; i < MAX_DRUGS; i++) {
			if(areaid == arrDrugData[i][dr_iAreaID]) {
				SetPVarInt(playerid, "AtDrugArea", i);
				break;
			}
			else DeletePVar(playerid, "AtDrugArea");
		}
		for(new i = 0; i < MAX_BLACKMARKETS; i++) {
			if(areaid == arrBlackMarket[i][bm_iAreaID]) {
				SetPVarInt(playerid, "AtBlackMarket", i);
				break;
			}
			else DeletePVar(playerid, "AtBlackMarket");
		}
		for(new i = 0; i < MAX_DYNPOINTS; i++) {
			if(areaid == arrPoint[i][po_iAreaID]) {
				SetPVarInt(playerid, "AtPoint", i);
				break;
			}
			else DeletePVar(playerid, "AtPoint");
		}s
		if(GetPVarType(playerid, "AtBlackMarket") && GetPVarInt(playerid, "AtBlackMarket") > -1) {

			new a = GetPVarInt(playerid, "AtBlackMarket");
			if(IsValidDynamicArea(arrBlackMarket[a][bm_iAreaID])) {

				if(arrBlackMarket[a][bm_iSeized]) SendClientMessageEx(playerid, COLOR_GRAD1, "This black market is currently seized.");
				else {
					SetPVarInt(playerid, PVAR_BLMARKETID, a);
					BM_BlackMarketMain(playerid);
				}
			}
		}
		if(GetPVarType(playerid, "AtPoint") && GetPVarInt(playerid, "AtPoint") > -1) {

			new a = GetPVarInt(playerid, "AtPoint");
			if(arrPoint[a][po_iType] == 0) {
				cmd_getmats(playerid, "");
			}
			if(arrPoint[a][po_iType] == 1) {

				if(GetPVarType(playerid, "Smuggling")) return SendClientMessageEx(playerid, COLOR_GRAD1, "You must complete your current smuggle before you can start another!");
				if(!IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessageEx(playerid, COLOR_GRAD1, "You must be driving a vehicle to load ingredients.");

				SetPVarInt(playerid, "DrugPoint", a);
				SetPVarInt(playerid, PVAR_ATDRUGPOINT, a);
				Smuggle_LoadIngredients(playerid);
			}
		}
		if(GetPVarType(playerid, "AtDrugArea") && GetPVarInt(playerid, "AtDrugArea") > -1) {
			if(IsACop(playerid)) ShowPlayerDialogEx(playerid, DIALOG_DRUG_INTERACT, DIALOG_STYLE_LIST, "Drug Plant | Cop Menu", "{00FF00}Harvest\n{FF0000}Destroy", "Select", "Cancel");
			else ShowPlayerDialogEx(playerid, DIALOG_DRUG_INTERACT, DIALOG_STYLE_MSGBOX, "Drug Plant | Harvest", "{FFFFFF}Would you like to {00FF00}harvest{FFFFFF} this drug plant?", "Harvest", "Cancel");
		}
	}
	*/
	return 1;
}


Drug_TransferAllToVeh(playerid, iVehID, iChoiceID) {

	DeletePVar(playerid, "PVDTransfer");
	DeletePVar(playerid, "PVehID");
	switch(iChoiceID) {

		case 0: { // withdraw
			SendClientMessageEx(playerid, COLOR_GRAD1, "You have taken all your drugs from the vehicle.");
			for(new i; i < sizeof(szDrugs); ++i) {

				PlayerInfo[playerid][p_iDrug][i] += PlayerVehicleInfo[playerid][iVehID][pvDrugs][i] ;
				PlayerVehicleInfo[playerid][iVehID][pvDrugs][i] = 0;
			}
		}
		case 1: { // deposit
			SendClientMessageEx(playerid, COLOR_GRAD1, "You have put all your drugs in the vehicle.");
			for(new i; i < sizeof(szDrugs); ++i) {

				PlayerVehicleInfo[playerid][iVehID][pvDrugs][i] += PlayerInfo[playerid][p_iDrug][i];
				PlayerInfo[playerid][p_iDrug][i] = 0;
			}
		}
	}
	g_mysql_SaveAccount(playerid);
	g_mysql_SaveVehicle(playerid, iVehID);
	return 1;
}

GetMaxDrugsAllowed(iDrugID) {
	
	
	switch(iDrugID) {

		case 0: return 1000;
		case 1: return 1000;
		case 2: return 1000;
		case 3: return 1000;
		case 4: return 1000;
		case 5: return 1000;
		case 6: return 1000;
		case 7: return 1000;
		case 8: return 1000;
		case 9: return 1000;
		case 10: return 1000;
		case 11: return 1000;
		case 12: return 1000;
		case 13: return 1000;
		case 14: return 1000;
	}
	return 0;
}

GetMaxIngredientsAllowed(iIngredientID) {

	switch(iIngredientID) {

		case 0: return 1000;
		case 1: return 1000;
		case 2: return 1000;
		case 3: return 1000;
		case 4: return 1000;
		case 5: return 1000;
		case 6: return 1000;
		case 7: return 1000;
		case 8: return 1000;
		case 9: return 1000;
		case 10: return 1000;
		case 11: return 1000;
		case 12: return 1000;
		case 13: return 1000;
		case 14: return 1000;
	}
	return 0;
}

Drug_ListDrugs(playerid) {

	format(szMiscArray, sizeof(szMiscArray),"%s | %s | %s | %s | %s | %s | %s | %s | %s | %s | %s | %s", szDrugs[0], szDrugs[1], szDrugs[2], szDrugs[3], szDrugs[4], szDrugs[5], szDrugs[6],
		szDrugs[7], szDrugs[8], szDrugs[9], szDrugs[10], szDrugs[11], szDrugs[12], szDrugs[13]);

	SendClientMessageEx(playerid, COLOR_GRAD1, szMiscArray);
}

Drug_ListIngredients(playerid) {

	format(szMiscArray, sizeof(szMiscArray),"%s | %s | %s | %s | %s", szIngredients[0], szIngredients[1], szIngredients[2], szIngredients[3], szIngredients[4]);
	SendClientMessageEx(playerid, COLOR_GRAD1, szMiscArray);
	format(szMiscArray, sizeof(szMiscArray),"%s | %s | %s | %s | %s | %s", szIngredients[5], szIngredients[6], szIngredients[7], szIngredients[8], szIngredients[9], szIngredients[10]);
	SendClientMessageEx(playerid, COLOR_GRAD1, szMiscArray);
}

Drug_StartMix(playerid) {

	szMiscArray[0] = 0;

	for(new i; i < 9; ++i) {

		format(szMiscArray, sizeof(szMiscArray), "%s%s\n", szMiscArray, szDrugs[i]);
	}

	return ShowPlayerDialogEx(playerid, DIALOG_DRUGS_MIX_START, DIALOG_STYLE_LIST, "Drugs | Which drug would you like to make?", szMiscArray, "Select", "Cancel");
}

Drug_ShowMix(playerid) {

	new szTitle[128];

	format(szTitle, sizeof(szTitle), "Drug Mix | Preparing: %s", szDrugs[GetPVarInt(playerid, PVAR_MAKINGDRUG)]);

	szMiscArray = "Slot\tIngredient\tPieces\n";

	for(new i; i < MAX_DRUGINGREDIENT_SLOTS; ++i) {

		if(dr_arrDrugMix[playerid][i][drm_iAmount] > 0)
			format(szMiscArray, sizeof(szMiscArray), "%sSlot %d\t%s\t%d\n", szMiscArray, i, szIngredients[dr_arrDrugMix[playerid][i][drm_iIngredientID]], dr_arrDrugMix[playerid][i][drm_iAmount]);

		else format(szMiscArray, sizeof(szMiscArray), "%sSlot %d\tNone\t0\n", szMiscArray, i);
	}

	strins(szMiscArray, "\n-\t____________\t-\n-\tExtract\t-", strlen(szMiscArray), strlen(szMiscArray)+1);

	return ShowPlayerDialogEx(playerid, DIALOG_DRUGS_MIX_MAIN, DIALOG_STYLE_TABLIST_HEADERS, szTitle, szMiscArray, "Select", "Cancel");
}

Drug_FinishMix(playerid, iDrugID) {

	new iDrugAmount = 1,
		iDrugQuality = 1,
		bool:bDrugCheck[MAX_DRUGINGREDIENT_SLOTS];

	switch(iDrugID)	{

		case 0: { // LSD -- Morning Glory Seeds (5)

			for(new i; i < MAX_DRUGINGREDIENT_SLOTS; ++i) {

				if(dr_arrDrugMix[playerid][i][drm_iAmount] < 1) continue;
				switch(dr_arrDrugMix[playerid][i][drm_iIngredientID]) {

					case 0: // Morning Glory Seeds
					{
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 2 == 0) iDrugQuality = 25;
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 3 == 0) iDrugQuality = 60;
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 4 == 0) iDrugQuality = 50;
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 5 == 0) iDrugQuality = 100;
						else iDrugQuality = 0;
						iDrugAmount = dr_arrDrugMix[playerid][i][drm_iAmount] / 5; // 5 Morning Glory Seeds
						PlayerInfo[playerid][p_iIngredient][0] -= dr_arrDrugMix[playerid][i][drm_iAmount];
						bDrugCheck[0] = true;
					}
					case 2: // Muriatic Acid
					{
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 5 == 0) iDrugQuality = 10;
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 3 == 0) iDrugQuality = 20;
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 4 == 0) iDrugQuality = 30;
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % (iDrugAmount * 5 * 2) == 0) iDrugQuality = 100;
						else iDrugQuality = 0;
						PlayerInfo[playerid][p_iIngredient][2] -= dr_arrDrugMix[playerid][i][drm_iAmount];
						bDrugCheck[1] = true;
					}
					case 6: // Distilled water
					{
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 1 == 0) iDrugQuality = 10;
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 3 == 0) iDrugQuality = 10;
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % (iDrugAmount * 5) == 0) iDrugQuality = 100;
						else iDrugQuality = 10;
						PlayerInfo[playerid][p_iIngredient][6] -= dr_arrDrugMix[playerid][i][drm_iAmount];
						bDrugCheck[2] = true;
					}
					case 13: // PMK Oil
					{
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 3 == 0) iDrugQuality = 10;
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 4 == 0) iDrugQuality = 20;
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % (iDrugAmount * 5 * 2) == 0) iDrugQuality = 100;
						else iDrugQuality = 0;
						PlayerInfo[playerid][p_iIngredient][13] -= dr_arrDrugMix[playerid][i][drm_iAmount];
						bDrugCheck[3] = true;
					}
				}
			}
			if(bDrugCheck[0] == false || bDrugCheck[1] == false || bDrugCheck[2] == false || bDrugCheck[3] == false) {
				iDrugAmount = 0;
				iDrugQuality = 0;
			}
		}
		case 1: // Cannabis
		{
			DeletePVar(playerid, PVAR_MAKINGDRUG);
			return SendClientMessageEx(playerid, COLOR_GRAD1, "You can only get cannabis from Morning Glory Seeds (/plantseeds).");
		}
		case 2: // Meth
		{
			for(new i; i < MAX_DRUGINGREDIENT_SLOTS; ++i)
			{
				if(dr_arrDrugMix[playerid][i][drm_iAmount] < 1) continue;
				switch(dr_arrDrugMix[playerid][i][drm_iIngredientID])
				{
					case 2: // Muriatic Acid
					{
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 5 == 0) iDrugQuality = 10;
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 3 == 0) iDrugQuality = 20;
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 4 == 0) iDrugQuality = 30;
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 10 == 0) iDrugQuality = 100;
						else iDrugQuality = 0;
						iDrugAmount = dr_arrDrugMix[playerid][i][drm_iAmount] / 2; // 10 Muriatic Acid
						PlayerInfo[playerid][p_iIngredient][2] -= dr_arrDrugMix[playerid][i][drm_iAmount];
						bDrugCheck[0] = true;
					}
					case 3: // Lye
					{
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 2 == 0) iDrugQuality = 10;
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 3 == 0) iDrugQuality = 20;
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 4 == 0) iDrugQuality = 30;
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % (iDrugAmount * 3) == 0) iDrugQuality = 100;
						else iDrugQuality = 15;
						PlayerInfo[playerid][p_iIngredient][3] -= dr_arrDrugMix[playerid][i][drm_iAmount];
						bDrugCheck[1] = true;
					}
					case 4: // Ethyl Ether
					{
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 2 == 0) iDrugQuality = 10;
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 3 == 0) iDrugQuality = 20;
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 4 == 0) iDrugQuality = 30;
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % (iDrugAmount * 2) == 0) iDrugQuality = 100;
						else iDrugQuality = 10;
						PlayerInfo[playerid][p_iIngredient][4] -= dr_arrDrugMix[playerid][i][drm_iAmount];
						bDrugCheck[2] = true;
					}
					case 5: // Ephedrine
					{
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 1 == 0) iDrugQuality = 10;
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 3 == 0) iDrugQuality = 10;
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % (iDrugAmount * 2) == 0) iDrugQuality = 100;
						else iDrugQuality = 10;
						PlayerInfo[playerid][p_iIngredient][5] -= dr_arrDrugMix[playerid][i][drm_iAmount];
						bDrugCheck[3] = true;
					}
					case 6: // Distilled water
					{
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 1 == 0) iDrugQuality = 10;
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 3 == 0) iDrugQuality = 10;
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % (iDrugAmount * 3) == 0) iDrugQuality = 100;
						else iDrugQuality = 10;
						PlayerInfo[playerid][p_iIngredient][6] -= dr_arrDrugMix[playerid][i][drm_iAmount];
						bDrugCheck[4] = true;
					}
				}
			}
			if(bDrugCheck[0] == false || bDrugCheck[1] == false || bDrugCheck[2] == false || bDrugCheck[3] == false || bDrugCheck[4] == false) {
				iDrugAmount = 0;
				iDrugQuality = 0;
			}
		}
		case 3: // Heroine
		{
			for(new i; i < MAX_DRUGINGREDIENT_SLOTS; ++i)
			{
				if(dr_arrDrugMix[playerid][i][drm_iAmount] < 1) continue;
				switch(dr_arrDrugMix[playerid][i][drm_iIngredientID])
				{
					case 7: // Opium Poppy
					{
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 5 == 0) iDrugQuality = 50;
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 3 == 0) iDrugQuality = 25;
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 4 == 0) iDrugQuality = 40;
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 10 == 0) iDrugQuality = 100;
						else iDrugQuality = 0;
						iDrugAmount = dr_arrDrugMix[playerid][i][drm_iAmount] * 2;
						PlayerInfo[playerid][p_iIngredient][7] -= dr_arrDrugMix[playerid][i][drm_iAmount];
						bDrugCheck[0] = true;
					}
					case 8: // Lime
					{
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 2 == 0) iDrugQuality = 50;
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 3 == 0) iDrugQuality = 25;
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 4 == 0) iDrugQuality = 40;
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % (iDrugAmount * 2) == 0) iDrugQuality = 100;
						else iDrugQuality = 0;
						PlayerInfo[playerid][p_iIngredient][8] -= dr_arrDrugMix[playerid][i][drm_iAmount];
						bDrugCheck[1] = true;
					}
					case 6: // Distilled water
					{
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 1 == 0) iDrugQuality = 10;
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 3 == 0) iDrugQuality = 10;
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % (iDrugAmount * 3) == 0) iDrugQuality = 100;
						else iDrugQuality = 10;
						PlayerInfo[playerid][p_iIngredient][6] -= dr_arrDrugMix[playerid][i][drm_iAmount];
						bDrugCheck[2] = true;
					}
				}
			}
			if(bDrugCheck[0] == false || bDrugCheck[1] == false || bDrugCheck[2] == false) {
				iDrugAmount = 0;
				iDrugQuality = 0;
			}
		}
		case 4: // Cocaine
		{
			for(new i; i < MAX_DRUGINGREDIENT_SLOTS; ++i)
			{
				if(dr_arrDrugMix[playerid][i][drm_iAmount] < 1) continue;
				switch(dr_arrDrugMix[playerid][i][drm_iIngredientID])
				{
					case 11: // Cocaine Plant Extract
					{
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 5 == 0) iDrugQuality = 50;
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 3 == 0) iDrugQuality = 25;
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 4 == 0) iDrugQuality = 40;
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 10 == 0) iDrugQuality = 100;
						else iDrugQuality = 0;
						iDrugAmount = dr_arrDrugMix[playerid][i][drm_iAmount] * 2;
						PlayerInfo[playerid][p_iIngredient][11] -= dr_arrDrugMix[playerid][i][drm_iAmount];
						bDrugCheck[0] = true;
					}
					case 12: // N-Benzynol
					{
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 2 == 0) iDrugQuality = 50;
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 3 == 0) iDrugQuality = 25;
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 4 == 0) iDrugQuality = 40;
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % (iDrugAmount * 2) == 0) iDrugQuality = 100;
						else iDrugQuality = 10;
						PlayerInfo[playerid][p_iIngredient][12] -= dr_arrDrugMix[playerid][i][drm_iAmount];
						bDrugCheck[1] = true;
					}
				}
			}
			if(bDrugCheck[0] == false || bDrugCheck[1] == false) {
				iDrugAmount = 0;
				iDrugQuality = 0;
			}
		}
		case 5: // Crack
		{
			for(new i; i < MAX_DRUGINGREDIENT_SLOTS; ++i) {

				if(dr_arrDrugMix[playerid][i][drm_iAmount] < 1) continue;
				switch(dr_arrDrugMix[playerid][i][drm_iIngredientID])
				{
					case 9: // Cocaine
					{
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 2 == 0) iDrugQuality = 50;
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 3 == 0) iDrugQuality = 25;
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 4 == 0) iDrugQuality = 40;
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 5 == 0) iDrugQuality = 100;
						else iDrugQuality = 10;
						iDrugAmount = dr_arrDrugMix[playerid][i][drm_iAmount] * 2;
						PlayerInfo[playerid][p_iIngredient][9] -= dr_arrDrugMix[playerid][i][drm_iAmount];
						bDrugCheck[0] = true;
					}
					case 10: // Baking Soda
					{
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 3 == 0) iDrugQuality = 10;
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 4 == 0) iDrugQuality = 20;
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % (iDrugAmount * 2) == 0) iDrugQuality = 100;
						else iDrugQuality = 0;
						PlayerInfo[playerid][p_iIngredient][10] -= dr_arrDrugMix[playerid][i][drm_iAmount];
						bDrugCheck[1] = true;
					}
					case 6: // Distilled water
					{
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 1 == 0) iDrugQuality = 10;
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 3 == 0) iDrugQuality = 10;
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % (iDrugAmount * 3) == 0) iDrugQuality = 100;
						else iDrugQuality = 10;
						PlayerInfo[playerid][p_iIngredient][6] -= dr_arrDrugMix[playerid][i][drm_iAmount];
						bDrugCheck[2] = true;
					}
				}
			}
			if(bDrugCheck[0] == false || bDrugCheck[1] == false || bDrugCheck[2] == false) {
				iDrugAmount = 0;
				iDrugQuality = 0;
			}
		}
		case 6: // Opium
		{
			DeletePVar(playerid, PVAR_MAKINGDRUG);
			return SendClientMessageEx(playerid, COLOR_GRAD1, "You can only get opium from Opium Poppy Seeds (/plantseeds).");
		}
		case 7: // Ecstasy
		{
			for(new i; i < MAX_DRUGINGREDIENT_SLOTS; ++i)
			{
				if(dr_arrDrugMix[playerid][i][drm_iAmount] < 1) continue;
				switch(dr_arrDrugMix[playerid][i][drm_iIngredientID])
				{
					case 13: // PMK Oil
					{
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 3 == 0) iDrugQuality = 10;
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 4 == 0) iDrugQuality = 20;
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 10 == 0) iDrugQuality = 100;
						else iDrugQuality = 0;
						iDrugAmount = dr_arrDrugMix[playerid][i][drm_iAmount];
						PlayerInfo[playerid][p_iIngredient][13] -= dr_arrDrugMix[playerid][i][drm_iAmount];
						bDrugCheck[0] = true;
					}
					case 14: // MDMA Crystals
					{
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 2 == 0) iDrugQuality = 50;
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 3 == 0) iDrugQuality = 25;
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 4 == 0) iDrugQuality = 40;
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % (iDrugAmount * 2) == 0) iDrugQuality = 100;
						else iDrugQuality = 10;
						PlayerInfo[playerid][p_iIngredient][14] -= dr_arrDrugMix[playerid][i][drm_iAmount];
						bDrugCheck[1] = true;
					}
					case 6: // Distilled water
					{
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 1 == 0) iDrugQuality = 10;
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 3 == 0) iDrugQuality = 10;
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % (iDrugAmount * 2) == 0) iDrugQuality = 100;
						else iDrugQuality = 10;
						PlayerInfo[playerid][p_iIngredient][6] -= dr_arrDrugMix[playerid][i][drm_iAmount];
						bDrugCheck[2] = true;
					}
				}
			}
			if(bDrugCheck[0] == false || bDrugCheck[1] == false || bDrugCheck[2] == false) {
				iDrugAmount = 0;
				iDrugQuality = 0;
			}
		}
		case 8: // Speed
		{
			for(new i; i < MAX_DRUGINGREDIENT_SLOTS; ++i)
			{
				if(dr_arrDrugMix[playerid][i][drm_iAmount] < 1) continue;
				switch(dr_arrDrugMix[playerid][i][drm_iIngredientID])
				{
					case 13: // PMK Oil
					{
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 1 == 0) iDrugQuality = 10;
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 2 == 0) iDrugQuality = 100;
						else iDrugQuality = 0;
						iDrugAmount = dr_arrDrugMix[playerid][i][drm_iAmount]; // 1 speed
						PlayerInfo[playerid][p_iIngredient][13] -= dr_arrDrugMix[playerid][i][drm_iAmount];
						bDrugCheck[0] = true;
					}
					case 14: // MDMA Crystals
					{
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 2 == 0) iDrugQuality = 10;
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 3 == 0) iDrugQuality = 20;
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 4 == 0) iDrugQuality = 10;
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % (iDrugAmount * 5) == 0) iDrugQuality = 100;
						else iDrugQuality = 10;
						PlayerInfo[playerid][p_iIngredient][14] -= dr_arrDrugMix[playerid][i][drm_iAmount];
						bDrugCheck[1] = true;
					}
					case 6: // Distilled water
					{
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 1 == 0) iDrugQuality = 10;
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % 3 == 0) iDrugQuality = 10;
						if(dr_arrDrugMix[playerid][i][drm_iAmount] % (iDrugAmount * 5) == 0) iDrugQuality = 100;
						else iDrugQuality = 10;
						PlayerInfo[playerid][p_iIngredient][6] -= dr_arrDrugMix[playerid][i][drm_iAmount];
						bDrugCheck[2] = true;
					}
				}
			}
			if(bDrugCheck[0] == false || bDrugCheck[1] == false || bDrugCheck[2] == false) {
				iDrugAmount = 0;
				iDrugQuality = 0;
			}
		}
	}
	if(iDrugAmount == 0) return SendClientMessageEx(playerid, COLOR_GREEN, "[Drugs]: {CCCCCC}You did not add the right ingredients.");
	if(iDrugAmount > 100) return SendClientMessageEx(playerid, COLOR_GREEN, "[Drugs]: {CCCCCC} You cannot make more than 100 pieces (pc) of drugs in one mix. It got wasted.");
	Drug_CreateDrug(playerid, iDrugID, iDrugAmount, iDrugQuality);
	DeletePVar(playerid, PVAR_MAKINGDRUG);
	return 1;
}

Drug_CreateDrug(playerid, iDrugID, iAmount, iDrugQuality) {

	format(szMiscArray, sizeof(szMiscArray), "[Drugs]: {CCCCCC}You made %d pc of %s with a quality of %dqP.", iAmount, szDrugs[iDrugID], iDrugQuality);
	SendClientMessageEx(playerid, COLOR_GREEN, szMiscArray);
	PlayerInfo[playerid][p_iDrug][iDrugID] += iAmount;
	PlayerInfo[playerid][p_iDrugQuality][iDrugID] += iDrugQuality;
	if(PlayerInfo[playerid][p_iDrugQuality][iDrugID] > 100) PlayerInfo[playerid][p_iDrugQuality][iDrugID] = 100;
	for(new i; i < MAX_DRUGINGREDIENT_SLOTS; ++i) dr_arrDrugMix[playerid][i][drm_iAmount] = 0;
	return 1;
}


Drug_Process(playerid, iDrugID, iTaken)
{
	if(PlayerInfo[playerid][p_iAddictedLevel][iDrugID] < DRUGS_ADDICTED_THRESHOLD)
	{
		Drug_SideEffects(playerid, iDrugID, iTaken);
		return 1;
	}
	if(PlayerInfo[playerid][p_iAddictedLevel][iDrugID] == DRUGS_ADDICTED_THRESHOLD && PlayerInfo[playerid][p_iAddicted][iDrugID] < 1)
	{
		PlayerInfo[playerid][p_iAddicted][iDrugID] = 2;
		PlayerInfo[playerid][p_iAddictedLevel][iDrugID] = DRUGS_ADDICTED_LEVEL;
		format(szMiscArray, sizeof(szMiscArray), "[Drugs]: {CCCCCC}You are now addicted to %s.", szDrugs[iDrugID]);
		SendClientMessageEx(playerid, COLOR_GREEN, szMiscArray);
	}
	Addiction_Effects(playerid, iDrugID, iTaken);
	return 1;
}

Addicted_TimerProcess(playerid, iDrugID)
{
	format(szMiscArray, sizeof(szMiscArray), "[Drugs]: {CCCCCC}Some effects started to kick in from %s addiction...", szDrugs[iDrugID]);
	SendClientMessageEx(playerid, COLOR_GREEN, szMiscArray);
	PlayerInfo[playerid][p_iAddicted][iDrugID] = 2;
	PlayerInfo[playerid][p_iAddictedLevel][iDrugID] = DRUGS_ADDICTED_LEVEL;
	Addiction_Effects(playerid, iDrugID, PlayerInfo[playerid][p_iDrugTaken][iDrugID]);
}

Drug_GetID(szDrug[]) {

	for(new i; i < sizeof(szDrugs); ++i) {

		if(strcmp(szDrugs[i], szDrug, true) == 0) return i;
	}

	return -1;
}

Drug_IngredientID(szIngredient[]) {

	for(new i; i < sizeof(szIngredients); ++i) {

		if(strcmp(szIngredients[i], szIngredient, true) == 0) return i;
	}
	return -1;
}

forward Drug_SideEffects(playerid, iDrugID, iTaken);
public Drug_SideEffects(playerid, iDrugID, iTaken) {

	if(GetPVarType(playerid, PVAR_DRUGS_OVERDOSE)) return 1;

	new iTotalTaken = PlayerInfo[playerid][p_iDrugTaken][iDrugID],
		iAllTaken,
		Float:fHealth,
		Float:fArmour;

	defer Drug_ResetDrunkEffects(playerid);
	GetHealth(playerid, fHealth), GetArmour(playerid, fArmour);

	for(new i; i < sizeof(szDrugs); ++i) iAllTaken += PlayerInfo[playerid][p_iDrugTaken][i];

	if(iAllTaken > DRUGS_OVERDOSE_THRESHOLD - 5) {

		new rand = random(20);

		if(rand == 13) {

			Ufo_CreateUfo(playerid);
			return 1;
		}
	}
	if(iAllTaken > DRUGS_OVERDOSE_THRESHOLD) {

		ClearAnimations(playerid, 1);
		SetPVarInt(playerid, PVAR_DRUGS_OVERDOSE, 1);
		TogglePlayerControllable(playerid, 0);
		TextDrawShowForPlayer(playerid, ODTextDraw);
		SetPlayerDrunkLevel(playerid, 6000);
		PlayAnimEx(playerid, "CRACK", "crckdeth2", 4.1, 1, 0, 0, 1, 30000, 1);
		SendClientMessageEx(playerid, COLOR_GREEN, "[Drugs]: {DDDDDD}You are currently overdosed.");
		Main_CreateAttached3DTextLabel(playerid, "Would appear to be overdosed.");
		defer Drug_ResetOverDose(playerid);
		return 1;
	}


	if(!GetPVarType(playerid, "DR_LastTake") || GetPVarInt(playerid, "DR_LastTake") > iTaken && iDrugID < 10) defer Drug_ResetEffects[10000 * iTotalTaken](playerid, iDrugID);

	SetPVarInt(playerid, "DR_LastTake", iTaken);
	switch(iDrugID)	{

		case 0: // LSD
		{

			SetHealth(playerid, fHealth + (2.0 * iTaken));
			switch(iTotalTaken)
			{
				case 0 .. 5: SetPlayerWeather(playerid, 108), SetPlayerTime(playerid, 10, 0);
				case 6 .. 10:
				{
					SetPlayerTime(playerid, 10, 0);
					SetPlayerWeather(playerid, 700);
					Drug_ExplosionEffects(playerid, iDrugID);
					Drug_SoundEffects(playerid, iDrugID);
				}
				case 11 .. 15: SetPlayerWeather(playerid, 111);
				default: {
					SetPlayerTime(playerid, 22, 0);
					SetPlayerWeather(playerid, 700);
					Drug_SoundEffects(playerid, iDrugID);
				}
			}
		}
		case 1: // Cannabis
		{
			SetHealth(playerid, fHealth + (2.0 * iTaken));
			if(PlayerInfo[playerid][pHunger] > 0) PlayerInfo[playerid][pHunger] -= 0.5;
			else PlayerInfo[playerid][pHunger] = 0;
			switch(iTotalTaken) {

				case 0 .. 5: SetPlayerWeather(playerid, 700);
				case 6 .. 9: SetPlayerWeather(playerid, 900), SetPlayerDrunkLevel(playerid, 2000);
				default: {

					SetPlayerWeather(playerid, 842);
					SetPlayerDrunkLevel(playerid, 5000);
					Drug_SoundEffects(playerid, iDrugID);
				}
			}
		}
		case 2: // Meth
		{
			SetHealth(playerid, fHealth + (4.0 * iTaken));
			switch(iTotalTaken)	{

				case 0 .. 5: SetPlayerWeather(playerid, 108);
				case 6 .. 10: SetPlayerWeather(playerid, 110);
				case 11 .. 15: SetPlayerWeather(playerid, 111);
				default: SetPlayerWeather(playerid, 109);
			}
		}
		case 3: // Heroine
		{
			SetArmour(playerid, fArmour + (8.0 * iTaken));
			SetPlayerTime(playerid, 0, 0);
			switch(iTotalTaken)	{

				case 0 .. 5: SetPlayerWeather(playerid, 700);
				case 6 .. 10:
				{
					SetPlayerWeather(playerid, 700);
					Drug_ExplosionEffects(playerid, iDrugID);
					Drug_SoundEffects(playerid, iDrugID);
				}
				case 11 .. 15: SetPlayerWeather(playerid, 700);
				default:
				{
					SetPlayerWeather(playerid, 700);
					Drug_SoundEffects(playerid, iDrugID);
				}
			}
		}
		case 4: // Cocaine
		{
			SetArmour(playerid, fArmour + (8.0 * iTaken));
			Drug_GunPerk(playerid);
			SetPlayerTime(playerid, 3, 0);
			switch(iTotalTaken)
			{
				case 0 .. 5:
				{
					SetPlayerWeather(playerid, 700);
					Drug_ExplosionEffects(playerid, iDrugID);
					Drug_SoundEffects(playerid, iDrugID);
				}
				case 6 .. 10: SetPlayerWeather(playerid, 700);
				default:
				{
					SetPlayerWeather(playerid, 8421);
					Drug_SoundEffects(playerid, iDrugID);
				}
			}
		}
		case 5: // Crack
		{
			SetArmour(playerid, fArmour + (8.0 * iTaken));
			SetPlayerTime(playerid, 13, 0);
			switch(iTotalTaken)
			{
				case 0 .. 5: SetPlayerWeather(playerid, 700);
				case 6 .. 10: SetPlayerWeather(playerid, 700);
				case 11 .. 15: SetPlayerWeather(playerid, 700);
				default: SetPlayerWeather(playerid, 700);
			}
		}
		case 6: // Opium
		{
			SetHealth(playerid, fHealth + (5.0 * iTaken));
			SetArmour(playerid, fArmour + (5.0 * iTaken));
			if(PlayerInfo[playerid][pHunger] > 0) PlayerInfo[playerid][pHunger] -= 0.5;
			else PlayerInfo[playerid][pHunger] = 0;
			switch(iTotalTaken)
			{
				case 0 .. 5:
				{
					SetPlayerWeather(playerid, 700), SetPlayerTime(playerid, 10, 0);
					Drug_ExplosionEffects(playerid, iDrugID);
				}
				case 6 .. 10: SetPlayerWeather(playerid, 700), SetPlayerTime(playerid, 20, 0);
				case 11 .. 15:
				{
					SetPlayerWeather(playerid, 700);
					SetPlayerTime(playerid, 0, 0);
					Drug_SoundEffects(playerid, iDrugID);
				}
				default:
				{
					SetPlayerWeather(playerid, 732);
					SetPlayerTime(playerid, 5, 0);
					Drug_SoundEffects(playerid, iDrugID);
				}
			}
		}
		case 7: // Ecstasy
		{
			SetHealth(playerid, fHealth + (8.0 * iTaken));
			SetArmour(playerid, fArmour + (8.0 * iTaken));
			switch(iTotalTaken)
			{
				case 0 .. 5:
				{
					SetPlayerWeather(playerid, 700), SetPlayerTime(playerid, 11, 0);
					Drug_ExplosionEffects(playerid, iDrugID);
				}
				case 6 .. 10: SetPlayerWeather(playerid, 700), SetPlayerTime(playerid, 11, 0);
				case 11 .. 15:
				{
					SetPlayerWeather(playerid, 700);
					SetPlayerTime(playerid, 11, 0);
					Drug_SoundEffects(playerid, iDrugID);
				}
				default:
				{
					SetPlayerWeather(playerid, 700);
					SetPlayerTime(playerid, 11, 0);
					Drug_SoundEffects(playerid, iDrugID);
				}
			}
		}
		case 8: // Speed
		{
			new Float:fPos[3];
			GetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]);
			defer Drug_DestroyRunPerk(CreateDynamicPickup(1241, 2, fPos[0], fPos[1], fPos[2], .playerid = playerid));
			SetPlayerTime(playerid, 13, 0);
			switch(iTotalTaken)
			{
				case 0 .. 5:
				{
					SetPlayerWeather(playerid, 700);
					Drug_ExplosionEffects(playerid, iDrugID);
					Drug_SoundEffects(playerid, iDrugID);
				}
				case 6 .. 10: SetPlayerWeather(playerid, 700);
				case 11 .. 15:
				{
					SetPlayerWeather(playerid, 700);
					Drug_SoundEffects(playerid, iDrugID);
				}
				default:
				{
					SetPlayerWeather(playerid, 700);
					Drug_SoundEffects(playerid, iDrugID);
				}
			}
		}
		case 9: // Alcohol
		{
			switch(iTotalTaken)
			{
				case 0 .. 5: SetPlayerDrunkLevel(playerid, 2000);
				case 6 .. 10: SetPlayerDrunkLevel(playerid, 4000);
				case 11 .. 15: SetPlayerDrunkLevel(playerid, 6000);
				default:
				{
					SetPlayerDrunkLevel(playerid, 8000);
					Drug_SoundEffects(playerid, iDrugID);
				}
			}
		}
		case 10, 11, 12:
		{
			SetHealth(playerid, fHealth + (2.0 * iTaken));
			SetArmour(playerid, fArmour + (2.0 * iTaken));
			switch(iTotalTaken)
			{
				case 0 .. 15: return Drug_ResetEffects(playerid, iDrugID);
				default:
				{
					SetPlayerWeather(playerid, 700);
					Drug_ExplosionEffects(playerid, iDrugID);
					Drug_SoundEffects(playerid, iDrugID);
				}
			}
		}
	}
	GetHealth(playerid, fHealth);
	GetArmour(playerid, fArmour);
	if(floatround(fHealth, floatround_round) > DRUGS_MAX_BONUS_HEALTH) SetHealth(playerid, DRUGS_MAX_BONUS_HEALTH);
	if(floatround(fArmour, floatround_round) > DRUGS_MAX_BONUS_ARMOUR) SetArmour(playerid, DRUGS_MAX_BONUS_ARMOUR);
	Bit_On(arrPlayerBits[playerid], dr_bitInDrugEffect);
	return 1;
}

Drug_GunPerk(playerid) {

	SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL, 999);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL_SILENCED, 999);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_DESERT_EAGLE, 999);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_SHOTGUN, 999);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_SPAS12_SHOTGUN, 999);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_MP5, 999);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_AK47, 999);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_M4, 999);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_SNIPERRIFLE, 999);
	// defer Drug_ResetGunPerk(playerid);
}

Drug_OrderIngredient(playerid, iBlackMarketID, iIngredientID, iAmount) // change sqlid
{
	if(GetPlayerCash(playerid) < (arrBlackMarket[iBlackMarketID][bm_iIngredientPrice][iIngredientID] * iAmount)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You do not have enough cash on you.");
	if(arrBlackMarket[iBlackMarketID][bm_iIngredientAmount][iIngredientID] < iAmount) return SendClientMessageEx(playerid, COLOR_GRAD1, "The black market doesn't have that much in stock.");

	new bool:iTrackable,
		iGroupID = arrBlackMarket[iBlackMarketID][bm_iGroupID],
		iCost;

	if(iAmount > DRUGS_TRACKABLE_THRESHOLD) iTrackable = true;
	else {
		switch(random(3))
		{
			case 0, 1: iTrackable = false;
			case 2: iTrackable = true;
		}
	}

	if(GetPlayerCash(playerid) < iCost)
		return SendClientMessage(playerid, COLOR_LIGHTRED, "You have insufficient funds to pay for this order.");

	GivePlayerCash(playerid, -arrBlackMarket[iBlackMarketID][bm_iIngredientPrice][iIngredientID] * iAmount);
	arrBlackMarket[iBlackMarketID][bm_iIngredientAmount][iIngredientID] -= iAmount;
	// arrGroupData[iGroupID][g_iBudget] += (arrBlackMarket[iBlackMarketID][bm_iIngredientPrice][iIngredientID] * iAmount);

	format(szMiscArray, sizeof(szMiscArray), "UPDATE `blackmarkets` SET `%s` = '%d' WHERE `id` = '%d'",
		DS_Ingredients_GetSQLName(iIngredientID), arrBlackMarket[iBlackMarketID][bm_iIngredientAmount][iIngredientID], iBlackMarketID + 1);
	mysql_function_query(MainPipeline, szMiscArray, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	format(szMiscArray, sizeof(szMiscArray), "INSERT INTO `blackmarkets_orders` (`DBID`, `name`, `timestamp`, `groupid`, `ingredientid`, `amount`, `trackable`)\
		VALUES ('%d', '%s', '%d', '%d', '%d', '%d', '%d')", GetPlayerSQLId(playerid), GetPlayerNameExt(playerid), gettime(), iGroupID, iIngredientID, iAmount, iTrackable);
	mysql_function_query(MainPipeline, szMiscArray, false, "Drug_OnOrderIngredient", "iiii", playerid, iIngredientID, iAmount, iGroupID);
	return 1;
}

forward Drug_OnOrderIngredient(playerid, iIngredientID, iAmount, iGroupID);
public Drug_OnOrderIngredient(playerid, iIngredientID, iAmount, iGroupID)
{
	format(szMiscArray, sizeof(szMiscArray), "[Drugs]: {CCCCCC}You ordered %d pieces of %s from %s.", iAmount, szIngredients[iIngredientID], arrGroupData[iGroupID][g_szGroupName]);
	SendClientMessageEx(playerid, COLOR_GREEN, szMiscArray);
	return 1;
}


BM_LoadBlackMarkets()
{
	format(szMiscArray, sizeof(szMiscArray), "SELECT * FROM `blackmarkets`");
	mysql_function_query(MainPipeline, szMiscArray, true, "BM_OnLoadBlackMarkets", "");
}

forward BM_OnLoadBlackMarkets();
public BM_OnLoadBlackMarkets()
{
	new iRows = cache_get_row_count(MainPipeline);

	if(!iRows) return print("[Black Markets] No black markets were found in the database.");

	new iFields,
		iCount;

	cache_get_data(iRows, iFields, MainPipeline);

	while(iCount < iRows) {
		new Float:fPos[3],
			iVW,
			iINT,
			iGroupID;

		iGroupID = cache_get_field_content_int(iCount, "groupid", MainPipeline);

		if(iGroupID != INVALID_GROUP_ID) {

			arrBlackMarket[iCount][bm_fPos][0] = cache_get_field_content_float(iCount, "posx", MainPipeline);
			arrBlackMarket[iCount][bm_fPos][1] = cache_get_field_content_float(iCount, "posy", MainPipeline);
			arrBlackMarket[iCount][bm_fPos][2] = cache_get_field_content_float(iCount, "posz", MainPipeline);
			fPos[0] = cache_get_field_content_float(iCount, "delposx", MainPipeline);
			fPos[1] = cache_get_field_content_float(iCount, "delposy", MainPipeline);
			fPos[2] = cache_get_field_content_float(iCount, "delposz", MainPipeline);
			iVW = cache_get_field_content_int(iCount, "vw", MainPipeline);
			iINT = cache_get_field_content_int(iCount, "int", MainPipeline);

			arrBlackMarket[iCount][bm_iSeized] = cache_get_field_content_int(iCount, "seized", MainPipeline);

			arrBlackMarket[iCount][bm_iGroupID] = iGroupID;

			arrBlackMarket[iCount][bm_iAreaID] = CreateDynamicSphere(arrBlackMarket[iCount][bm_fPos][0], arrBlackMarket[iCount][bm_fPos][1], arrBlackMarket[iCount][bm_fPos][2], 2.0);
			// Streamer_SetIntData(STREAMER_TYPE_AREA, arrBlackMarket[iCount][bm_iAreaID], E_STREAMER_EXTRA_ID, iCount);

			for(new i; i < sizeof(szIngredients); ++i) {
				arrBlackMarket[iCount][bm_iIngredientAmount][i] = cache_get_field_content_int(iCount, DS_Ingredients_GetSQLName(i), MainPipeline);
				format(szMiscArray, sizeof(szMiscArray), "%s%s", DS_Ingredients_GetSQLName(i), "price");
				arrBlackMarket[iCount][bm_iIngredientPrice][i] = cache_get_field_content_int(iCount, szMiscArray, MainPipeline);
			}

			if(arrBlackMarket[iCount][bm_fPos][0] != 0 && arrBlackMarket[iCount][bm_fPos][0] != 0) {

				Iter_Add(BlackMarkets, iCount);
				arrBlackMarket[iCount][bm_iPickupID] = CreateDynamicPickup(1254, 1, arrBlackMarket[iCount][bm_fPos][0], arrBlackMarket[iCount][bm_fPos][1], arrBlackMarket[iCount][bm_fPos][2], iVW, iINT);
				format(szMiscArray, sizeof(szMiscArray), "%s's Black Market\n{AAAAAA}ID: %d\n{FFFFFF}Press ~k~~CONVERSATION_YES~ to access the Black Market.", arrGroupData[iGroupID][g_szGroupName], iCount);
				arrBlackMarket[iCount][bm_iTextID] = CreateDynamic3DTextLabel(szMiscArray, COLOR_GREEN, arrBlackMarket[iCount][bm_fPos][0], arrBlackMarket[iCount][bm_fPos][1], arrBlackMarket[iCount][bm_fPos][2] + 1.0, 10.0, .worldid = iVW, .interiorid = iINT);
				format(szMiscArray, sizeof(szMiscArray), "Delivery Point\n%s's Black Market\n{AAAAAA}ID: %d", arrGroupData[iGroupID][g_szGroupName], iCount);
				arrBlackMarket[iCount][bm_iDelTextID] = CreateDynamic3DTextLabel(szMiscArray, COLOR_GRAD1, fPos[0], fPos[1], fPos[2] + 1.0, 10.0, .worldid = iVW, .interiorid = iINT);

				if(arrBlackMarket[iCount][bm_iSeized]) {
					format(szMiscArray, sizeof(szMiscArray), "%s's Black Market\n\n{FF0000}Seized", arrGroupData[iGroupID][g_szGroupName]);
					UpdateDynamic3DTextLabelText(arrBlackMarket[iCount][bm_iTextID], COLOR_GREEN, szMiscArray);
				}
			}
		}

		iCount++;
	}
	printf("[Black Markets] Loaded %d black markets.", iCount);
	return 1;
}

forward BM_OnCreateBlackMarket(playerid, i);
public BM_OnCreateBlackMarket(playerid, i)
{
	format(szMiscArray, sizeof(szMiscArray), "You have successfully created a blackmarket for %s with ID %d", arrGroupData[arrBlackMarket[i][bm_iGroupID]][g_szGroupName], i);
	SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
	SendClientMessageEx(playerid, COLOR_GRAD1, "Make sure to also set up a delivery point for the black market (/ablackmarket deliverpos)");
	return 1;
}

forward BM_OnDeleteBlackMarket(playerid, iBlackMarketID);
public BM_OnDeleteBlackMarket(playerid, iBlackMarketID) {

	if(mysql_errno()) return SendClientMessageEx(playerid, COLOR_GRAD1, "Something went wrong. Please try again later.");
	for(new i; i < sizeof(szIngredients); ++i) {

		arrBlackMarket[iBlackMarketID][bm_iIngredientAmount][i] = 0;
		arrBlackMarket[iBlackMarketID][bm_iIngredientSmugglePay][i] = 0;
		arrBlackMarket[iBlackMarketID][bm_iIngredientPrice][i] = 0;
	}
	format(szMiscArray, sizeof(szMiscArray), "You successfully destroyed black market ID %d", iBlackMarketID);
	SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
	return 1;
}


BM_ShowBlackMarketOrders(playerid) {

	format(szMiscArray, sizeof(szMiscArray), "SELECT * FROM `blackmarkets_orders` WHERE `groupid` = %d", arrBlackMarket[GetPVarInt(playerid, PVAR_BLMARKETID)][bm_iGroupID]); //editsqlid
	mysql_function_query(MainPipeline, szMiscArray, true, "BM_OnListBMOrders", "i", playerid);
}

forward BM_OnListBMOrders(playerid);
public BM_OnListBMOrders(playerid) {

	new iRows = cache_get_row_count(MainPipeline);
	if(!iRows) return SendClientMessageEx(playerid, COLOR_GRAD1, "No orders matched your query.");

	new iFields,
		iCount,
		szName[MAX_PLAYER_NAME + 1],
		szDate[64];

	cache_get_data(iRows, iFields, MainPipeline);

	new iDeliverTime = cache_get_field_content_int(iCount, "timestamp", MainPipeline) + DRUG_ORDER_TIME;

	if(gettime() < iDeliverTime) format(szDate, sizeof(szDate), "{FFFF00}%s", date(iDeliverTime, 2));
	else format(szDate, sizeof(szDate), "{00FF00}%s", date(iDeliverTime, 2));

	szMiscArray = "Name\tOrdering\tExpected delivery\n";

	while(iCount < iRows) {

		cache_get_field_content(iCount, "name", szName, MainPipeline, sizeof(szName));

		format(szMiscArray, sizeof(szMiscArray), "%s%s\t%s (%d)\t%s\n",
			szMiscArray,
			StripUnderscore(szName),
			szIngredients[cache_get_field_content_int(iCount, "ingredientid", MainPipeline)],
			cache_get_field_content_int(iCount, "amount", MainPipeline),
			szDate);

		iCount++;
	}
	ShowPlayerDialogEx(playerid, DIALOG_DRUGS_ORDER_LIST, DIALOG_STYLE_TABLIST_HEADERS, "Black Market | Orders", szMiscArray, "<<", "");
	return 1;
}

BM_ShowBlackMarket(playerid)
{
	new iBlackMarketID = GetPVarInt(playerid, PVAR_BLMARKETID),
		szTitle[64];

	szMiscArray = "Ingredient Name\tAmount\n";

	for(new i; i < sizeof(szIngredients); ++i) {

		format(szMiscArray, sizeof(szMiscArray), "%s%s\t%s\n", szMiscArray, szIngredients[i], number_format(arrBlackMarket[iBlackMarketID][bm_iIngredientAmount][i]));
	}

	format(szTitle, sizeof(szTitle), "%s's Black Market | Ingredients", arrGroupData[PlayerInfo[playerid][pMember]][g_szGroupName]);
	ShowPlayerDialogEx(playerid, DIALOG_BLACKMARKET_INGREDIENTS, DIALOG_STYLE_TABLIST_HEADERS, szTitle, szMiscArray, "<<", "");
}



BM_EditBlackMarket(playerid, iBlackMarketID, choice)
{
	switch(choice)
	{
		case 0:	{

			szMiscArray = "Ingredient Name\tPrice (per piece)\n";

			for(new i; i < sizeof(szIngredients); ++i) {

				format(szMiscArray, sizeof(szMiscArray), "%s%s\t$%s\n", szMiscArray, szIngredients[i], number_format(arrBlackMarket[iBlackMarketID][bm_iIngredientPrice][i]));
			}
			return ShowPlayerDialogEx(playerid, DIALOG_BLACKMARKET_EDITPRICE, DIALOG_STYLE_TABLIST_HEADERS, "Black Market | Edit Prices", szMiscArray, "Edit", "<<");
		}
		case 1: {

			szMiscArray = "Ingredient Name\tPaying (per piece)\n";

			for(new i; i < sizeof(szIngredients); ++i) {

				format(szMiscArray, sizeof(szMiscArray), "%s%s\t$%s\n", szMiscArray, szIngredients[i], number_format(arrBlackMarket[iBlackMarketID][bm_iIngredientSmugglePay][i]));
			}
			return ShowPlayerDialogEx(playerid, DIALOG_BLACKMARKET_EDITPAYMENT, DIALOG_STYLE_TABLIST_HEADERS, "Black Market | Edit Smuggle Payment", szMiscArray, "Edit", "<<");
		}
		case 2:	return ShowPlayerDialogEx(playerid, DIALOG_BLACKMARKET_TRANSFERC, DIALOG_STYLE_LIST, "Black Market - Transfer Stock", "Withdraw from Locker\nDeposit to Locker", "Select", "Cancel");
	}
	return 1;
}

BM_OnEditBlackMarket(playerid, id, iChoice, iAmount, choice)
{
	new iGroupID = PlayerInfo[playerid][pMember];

	switch(choice)
	{
		case 0: {

			arrBlackMarket[id][bm_iIngredientPrice][iChoice] = iAmount;
			format(szMiscArray, sizeof(szMiscArray), "UPDATE `blackmarkets` SET `%sprice` = '%d' WHERE `id` = '%d'", DS_Ingredients_GetSQLName(iChoice), iAmount, id + 1);
			mysql_function_query(MainPipeline, szMiscArray, false, "BM_FinishEditBlackMarket", "iiiii", playerid, id, iChoice, iAmount, choice);
		}
		case 1:	{

			arrBlackMarket[id][bm_iIngredientSmugglePay][iChoice] = iAmount;
			format(szMiscArray, sizeof(szMiscArray), "UPDATE `blackmarkets` SET `%spay` = '%d' WHERE `id` = '%d'", DS_Ingredients_GetSQLName(iChoice), iAmount, id + 1);
			mysql_function_query(MainPipeline, szMiscArray, false, "BM_FinishEditBlackMarket", "iiiii", playerid, id, iChoice, iAmount, choice);
		}
		case 2:	{

			switch(GetPVarInt(playerid, "DS_BMTC")) {
				case 0: {
					if(arrGroupData[iGroupID][g_iIngredients][iChoice] < iAmount) return SendClientMessageEx(playerid, COLOR_GRAD1, "You do not have enough in the locker.");
					arrBlackMarket[id][bm_iIngredientAmount][iChoice] += iAmount;
					arrGroupData[iGroupID][g_iIngredients][iChoice] -= iAmount;
				}
				case 1: {
					if(arrBlackMarket[id][bm_iIngredientAmount][iChoice] < iAmount) return SendClientMessageEx(playerid, COLOR_GRAD1, "You do not have enough in stock.");
					arrBlackMarket[id][bm_iIngredientAmount][iChoice] -= iAmount;
					arrGroupData[iGroupID][g_iIngredients][iChoice] += iAmount;
				}
			}

			format(szMiscArray, sizeof(szMiscArray), "%s updated the ingredient price for %s for GroupID %d to $%s", GetPlayerNameEx(playerid), DS_Ingredients_GetSQLName(iChoice), iGroupID, number_format(iAmount));
			Log("logs/blackmarkets.log", szMiscArray);

			format(szMiscArray, sizeof(szMiscArray), "UPDATE `blackmarkets` SET `%s` = '%d' WHERE `id` = '%d'", DS_Ingredients_GetSQLName(iChoice), arrBlackMarket[id][bm_iIngredientAmount][iChoice], id + 1);
			mysql_function_query(MainPipeline, szMiscArray, false, "BM_FinishEditBlackMarket", "iiiii", playerid, id, iChoice, iAmount, choice);
			format(szMiscArray, sizeof(szMiscArray), "UPDATE `groups` SET `%s` = '%d' WHERE `id` = '%d'", DS_Ingredients_GetSQLName(iChoice), arrGroupData[iGroupID][g_iIngredients][iChoice], iGroupID + 1);
			mysql_function_query(MainPipeline, szMiscArray, false, "BM_FinishEditBlackMarket", "iiiii", playerid, id, iChoice, iAmount, choice);
			return 1;
		}
	}
	return 1;
}

forward BM_FinishEditBlackMarket(playerid, id, iChoice, iAmount, choice);
public BM_FinishEditBlackMarket(playerid, id, iChoice, iAmount, choice)
{
	if(mysql_errno()) return SendClientMessageEx(playerid, COLOR_GRAD1, "Something went wrong. Please try again later.");
	switch(choice) {

		case 0:	{

			format(szMiscArray, sizeof(szMiscArray), "[Black Market] {CCCCCC}You successfully edited the price of %s to $%s", szIngredients[iChoice], number_format(iAmount));
			BM_EditBlackMarket(playerid, GetPVarInt(playerid, PVAR_BLMARKETID), 0);
		}
		case 1:	{

			format(szMiscArray, sizeof(szMiscArray), "[Black Market] {CCCCCC}You successfully edited the smuggle payment of %s to $%s per piece.", szIngredients[iChoice], number_format(iAmount));
			BM_EditBlackMarket(playerid, GetPVarInt(playerid, PVAR_BLMARKETID), 1);
		}
		case 2:	{

			switch(GetPVarInt(playerid, "DS_BMTC"))
			{
				case 0: format(szMiscArray, sizeof(szMiscArray), "[Black Market] {CCCCCC}You successfully transferred %d pieces of %s to the black market's stock.", iAmount, szIngredients[iChoice]);
				case 1: format(szMiscArray, sizeof(szMiscArray), "[Black Market] {CCCCCC}You successfully transferred %d pieces of %s to the locker.", iAmount, szIngredients[iChoice]);
			}
			BM_EditBlackMarket(playerid, GetPVarInt(playerid, PVAR_BLMARKETID), 2);
			DeletePVar(playerid, "DS_BMTC");
		}
	}

	SendClientMessageEx(playerid, COLOR_GREEN, szMiscArray);
	return 1;
}

BM_BlackMarketMain(playerid) {

	new iBlackMarketID = GetPVarInt(playerid, PVAR_BLMARKETID);

	szMiscArray = "Ingredient name\tPrice (per piece)\n";

	for(new i; i < sizeof(szIngredients); ++i) {

		format(szMiscArray, sizeof(szMiscArray), "%s%s\t$%s\n", szMiscArray, szIngredients[i], number_format(arrBlackMarket[iBlackMarketID][bm_iIngredientPrice][i]));
	}

	new szTitle[64];

	format(szTitle, sizeof(szTitle), "%s's Black Market | Buy Ingredients", arrGroupData[arrBlackMarket[iBlackMarketID][bm_iGroupID]][g_szGroupName]);
	ShowPlayerDialogEx(playerid, DIALOG_BLACKMARKET_ORDER_ING, DIALOG_STYLE_TABLIST_HEADERS, szTitle, szMiscArray, "Select", "");
	return 1;
}

BM_SeizeCheck() {

	for(new i; i < MAX_BLACKMARKETS; ++i) {

		if(IsValidDynamicArea(arrBlackMarket[i][bm_iAreaID])) {
		// if(arrBlackMarket[i][bm_fPos][0] != 0.0) {

			if(arrBlackMarket[i][bm_iSeized] == 1) {

				format(szMiscArray, sizeof(szMiscArray), "SELECT `seized` FROM `blackmarkets` WHERE `id` = '%d'", i + 1);
				mysql_function_query(MainPipeline, szMiscArray, true, "BM_OnSeizeCheck", "i", i);
				break;
			}
		}
	}
	return 1;
}

forward BM_OnSeizeCheck(i);
public BM_OnSeizeCheck(i) {

	new iRows,
		iFields,
		iCount;

	cache_get_data(iRows, iFields, MainPipeline);

	while(iCount < iRows) {

		new iTime = cache_get_field_content_int(iCount, "seizetimestamp", MainPipeline);
		if(gettime() > iTime) {

			arrBlackMarket[i][bm_iSeized] = 0;
			format(szMiscArray, sizeof(szMiscArray), "UPDATE `blackmarkets` SET `seized` = '0', `seizedtimestamp` = '%d' WHERE `id` = '%d'", (gettime() + (BLACKMARKET_SEIZE_DAYS * 60 * 60 * 24)), i + 1);
			mysql_function_query(MainPipeline, szMiscArray, false, "OnQueryFinish", "i", SENDDATA_THREAD);

			foreach(new p : Player) {

				if(PlayerInfo[p][pMember] == arrBlackMarket[i][bm_iGroupID]) SendClientMessageEx(p, COLOR_GREEN, "[Black Market]: {DDDDD}Your black market has recovered from the seizure.");
			}
		}
		iCount++;
	}
	return 1;
}

forward BM_OnCheckBlackMarket(playerid, i, iGroupID);
public BM_OnCheckBlackMarket(playerid, i, iGroupID) {

	if(cache_get_row_count()) return SendClientMessage(playerid, COLOR_GRAD1, "This group has a black market already.");

	new iVW = GetPlayerVirtualWorld(playerid),
		iINT = GetPlayerInterior(playerid),
		Float:fPos[3];

	Iter_Add(BlackMarkets, i);
	arrBlackMarket[i][bm_iGroupID] = iGroupID;
	GetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]);
	arrBlackMarket[i][bm_fPos][0] = fPos[0];
	arrBlackMarket[i][bm_fPos][1] = fPos[1];
	arrBlackMarket[i][bm_fPos][2] = fPos[2];
	arrBlackMarket[i][bm_iAreaID] = CreateDynamicSphere(fPos[0], fPos[1], fPos[2], 2.0);
	// Streamer_SetIntData(STREAMER_TYPE_AREA, arrBlackMarket[i][bm_iAreaID], E_STREAMER_EXTRA_ID, i);
	arrBlackMarket[i][bm_iPickupID] = CreateDynamicPickup(1254, 1, arrBlackMarket[i][bm_fPos][0], arrBlackMarket[i][bm_fPos][1], arrBlackMarket[i][bm_fPos][2], .worldid = iVW, .interiorid = iINT, .streamdistance = 20.0);
	format(szMiscArray, sizeof(szMiscArray), "%s's Black Market\n{AAAAAA}ID: %d\n{FFFFFF}Press ~k~~CONVERSATION_YES~ to access the market.", arrGroupData[arrBlackMarket[i][bm_iGroupID]][g_szGroupName], i);
	arrBlackMarket[i][bm_iTextID] = CreateDynamic3DTextLabel(szMiscArray, COLOR_GREEN, arrBlackMarket[i][bm_fPos][0], arrBlackMarket[i][bm_fPos][1], arrBlackMarket[i][bm_fPos][2] + 1.0, 10.0, .worldid = iVW, .interiorid = iINT, .streamdistance = 20.0);
	format(szMiscArray, sizeof(szMiscArray), "Delivery Point\n%s's Black Market\n{CCCCCC}ID: %d", arrGroupData[arrBlackMarket[i][bm_iGroupID]][g_szGroupName], i);
	arrBlackMarket[i][bm_iDelTextID] = CreateDynamic3DTextLabel(szMiscArray, COLOR_GREEN, arrBlackMarket[i][bm_fPos][0], arrBlackMarket[i][bm_fPos][1], arrBlackMarket[i][bm_fPos][2] + 1.0, 10.0, .worldid = iVW, .interiorid = iINT, .streamdistance = 20.0);

	format(szMiscArray, sizeof(szMiscArray), "UPDATE `blackmarkets` SET `groupid` = '%d', `posx` = '%f', `posy` = '%f', `posz` = '%f', `vw` = '%d', `int` = '%d' WHERE `id` = '%d'",
		iGroupID, arrBlackMarket[i][bm_fPos][0], arrBlackMarket[i][bm_fPos][1], arrBlackMarket[i][bm_fPos][2], iVW, iINT, i + 1);
	mysql_function_query(MainPipeline, szMiscArray, false, "BM_OnCreateBlackMarket", "ii", playerid, i);
	return 1;
}

Drugs_LoadPlayerPlants() {

	mysql_function_query(MainPipeline, "SELECT * FROM `drugpool`", true, "Drugs_OnLoadPlayerPlants", "");
}

forward Drugs_OnLoadPlayerPlants();
public Drugs_OnLoadPlayerPlants()
{
	print("[Drug System] Loading player drugs...");

	new iRows = cache_get_row_count(MainPipeline);

	if(!iRows) return print("[Drug System] No player drugs were found in the database.");

	new iFields,
		iCount,
		szName[MAX_PLAYER_NAME],
		// Float:fPos[3],
		iVW,
		iINT;

	cache_get_data(iRows, iFields, MainPipeline);

	while(iCount < iRows) {

		new iCompletedTimeStamp = cache_get_field_content_int(iCount, "timestamp", MainPipeline) + DRUGS_GROWTH_TIME;

		if(cache_get_field_content_int(iCount, "spawned", MainPipeline) == 1 || gettime() > iCompletedTimeStamp) {
			
			new iFreeID = Iter_Free(PlayerDrugs);
			Iter_Add(PlayerDrugs, iFreeID);
			arrDrugData[iFreeID][dr_iDBID] = iCount;

			cache_get_field_content(iCount, "name", szName, MainPipeline, sizeof(szName));
			arrDrugData[iFreeID][dr_iDrugID] = cache_get_field_content_int(iCount, "drugid", MainPipeline);
			arrDrugData[iFreeID][dr_fPos][0] = cache_get_field_content_float(iCount, "posx", MainPipeline);
			arrDrugData[iFreeID][dr_fPos][1] = cache_get_field_content_float(iCount, "posy", MainPipeline);
			arrDrugData[iFreeID][dr_fPos][2] = cache_get_field_content_float(iCount, "posz", MainPipeline);
			iVW = cache_get_field_content_int(iCount, "vw", MainPipeline);
			iINT = cache_get_field_content_int(iCount, "int", MainPipeline);

			arrDrugData[iFreeID][dr_iDrugQuality] = cache_get_field_content_int(iCount, "quality", MainPipeline);

			// arrDrugData[iFreeID][dr_iAreaID] = CreateDynamicSphere(arrDrugData[iFreeID][dr_fPos][0], arrDrugData[iFreeID][dr_fPos][1], arrDrugData[iFreeID][dr_fPos][2], 2.0, iVW, iINT);
			
			if(arrDrugData[iFreeID][dr_fPos][0] != 0 && arrDrugData[iFreeID][dr_fPos][1] != 0) {

				arrDrugData[iFreeID][dr_iObjectID] = CreateDynamicObject(3409, arrDrugData[iFreeID][dr_fPos][0], arrDrugData[iFreeID][dr_fPos][1], arrDrugData[iFreeID][dr_fPos][2] - 1.25, 0.0, 0.0, 0.0, iVW, iINT);
				format(szMiscArray, sizeof(szMiscArray), "UPDATE `drugpool` SET `spawned` = 1 WHERE `id` = '%d'", iCount);
				mysql_function_query(MainPipeline, szMiscArray, false, "OnQueryFinish", "i", SENDDATA_THREAD);
				// format(szMiscArray, sizeof(szMiscArray), "%s's %s\n{AAAAAA}(ID %d)\n{DDDDDD}Press ~k~~CONVERSATION_YES~ to harvest it.", StripUnderscore(szName), szDrugs[arrDrugData[iFreeID][dr_iDrugID]], iCount);
				format(szMiscArray, sizeof(szMiscArray), "%s's %s\n{AAAAAA}(ID %d)\n{DDDDDD}Use /getplant to harvest it.", StripUnderscore(szName), szDrugs[arrDrugData[iFreeID][dr_iDrugID]], iCount);
				arrDrugData[iFreeID][dr_iTextID] = CreateDynamic3DTextLabel(szMiscArray, COLOR_GREEN, arrDrugData[iFreeID][dr_fPos][0], arrDrugData[iFreeID][dr_fPos][1], arrDrugData[iFreeID][dr_fPos][2], 10.0, .worldid = iVW, .interiorid = iINT);
			}
			else {
				format(szMiscArray, sizeof(szMiscArray), "DELETE FROM `drugpool` WHERE `id` = '%d'", iCount);
				mysql_function_query(MainPipeline, szMiscArray, false, "OnQueryFinish", "i", SENDDATA_THREAD);
				Iter_Remove(PlayerDrugs, iFreeID);
			}
		}
		++iCount;
	}
	printf("[Drug System] Loaded %d player drugs.", iCount);
	return 1;
}

forward Drugs_OnDestroyPlant(playerid, i);
public Drugs_OnDestroyPlant(playerid, i) {

	if(mysql_errno(MainPipeline)) return SendClientMessageEx(playerid, COLOR_GRAD1, "Something went wrong. Please try again later.");
	if(IsValidDynamicObject(arrDrugData[i][dr_iObjectID])) DestroyDynamicObject(arrDrugData[i][dr_iObjectID]);
	if(IsValidDynamic3DTextLabel(arrDrugData[i][dr_iTextID])) DestroyDynamic3DTextLabel(arrDrugData[i][dr_iTextID]);
	// if(IsValidDynamicArea(arrDrugData[i][dr_iAreaID])) DestroyDynamicArea(arrDrugData[i][dr_iAreaID]);
	Iter_Remove(PlayerDrugs, i);
	arrDrugData[i][dr_fPos][0] = 0;
	arrDrugData[i][dr_fPos][1] = 0;
	arrDrugData[i][dr_fPos][2] = 0;
	format(szMiscArray, sizeof(szMiscArray), "Administrator %s removed a plant.", GetPlayerNameExt(playerid));
	Log("logs/plant.log", szMiscArray);
	return 1;
}


Drugs_Remove(playerid, i)
{
	ApplyAnimation(playerid, "BOMBER","BOM_Plant_In", 4.0, 0, 0, 0, 0, 0);
	format(szMiscArray, sizeof(szMiscArray), "DELETE FROM `drugpool` WHERE `id` = '%d'", arrDrugData[i][dr_iDBID]);
	mysql_function_query(MainPipeline, szMiscArray, false, "Drugs_OnLEODestroyPlant", "ii", playerid, i);
}

forward Drugs_OnLEODestroyPlant(playerid, i);
public Drugs_OnLEODestroyPlant(playerid, i) {

	if(IsValidDynamicObject(arrDrugData[i][dr_iObjectID])) DestroyDynamicObject(arrDrugData[i][dr_iObjectID]);
	if(IsValidDynamic3DTextLabel(arrDrugData[i][dr_iTextID])) DestroyDynamic3DTextLabel(arrDrugData[i][dr_iTextID]);
	// if(IsValidDynamicArea(arrDrugData[i][dr_iAreaID])) DestroyDynamicArea(arrDrugData[i][dr_iAreaID]);

	DeletePVar(playerid, "AtDrugArea");
	Iter_Remove(PlayerDrugs, i);
	arrDrugData[i][dr_iDrugQuality] = 0;
	arrDrugData[i][dr_fPos][0] = 0;
	arrDrugData[i][dr_fPos][1] = 0;
	arrDrugData[i][dr_fPos][2] = 0;
	SendClientMessageEx(playerid, COLOR_GREEN, "[Drugs]: {CCCCCC}You have removed the drug plant.");
	return 1;
}

Drugs_Retrieve(playerid, i) {

	DeletePVar(playerid, "AtDrugArea");
	format(szMiscArray, sizeof(szMiscArray), "DELETE FROM `drugpool` WHERE `id` = '%d'", arrDrugData[i][dr_iDBID]);
	mysql_function_query(MainPipeline, szMiscArray, false, "Drugs_OnRetrievePlant", "ii", playerid, i);
	return 1;
}

forward Drugs_OnRetrievePlant(playerid, i);
public Drugs_OnRetrievePlant(playerid, i) {

	new iDrugID = arrDrugData[i][dr_iDrugID];
	ApplyAnimation(playerid, "BOMBER","BOM_Plant_In", 4.0, 0, 0, 0, 0, 0);
	if(IsValidDynamicObject(arrDrugData[i][dr_iObjectID])) DestroyDynamicObject(arrDrugData[i][dr_iObjectID]);
	if(IsValidDynamic3DTextLabel(arrDrugData[i][dr_iTextID])) DestroyDynamic3DTextLabel(arrDrugData[i][dr_iTextID]);
	// if(IsValidDynamicArea(arrDrugData[i][dr_iAreaID])) DestroyDynamicArea(arrDrugData[i][dr_iAreaID]);
	PlayerInfo[playerid][p_iDrug][iDrugID] += 20;
	PlayerInfo[playerid][p_iDrugQuality][iDrugID] = arrDrugData[i][dr_iDrugQuality];
	format(szMiscArray, sizeof(szMiscArray), "[Drugs]: {CCCCCC}You have retrieved 20 pieces of cannabis/opium from the plant with a quality of %dqP.", arrDrugData[i][dr_iDrugQuality]);
	SendClientMessageEx(playerid, COLOR_GREEN, szMiscArray);
	arrDrugData[i][dr_iDrugQuality] = 0;
	arrDrugData[i][dr_fPos][0] = 0;
	arrDrugData[i][dr_fPos][1] = 0;
	arrDrugData[i][dr_fPos][2] = 0;
	Iter_Remove(PlayerDrugs, i);
}

forward Drugs_OnCheckAmount(playerid, iDrugID);
public Drugs_OnCheckAmount(playerid, iDrugID)
{
	new iRows = cache_get_row_count(MainPipeline);
	if(iRows < MAX_PLAYERDRUGS) 
	{
		format(szMiscArray, sizeof(szMiscArray), "SELECT * FROM `drugpool`");
		mysql_function_query(MainPipeline, szMiscArray, true, "Drugs_OnGLOBALCheckAmount", "ii", playerid, iDrugID);
	}
	else SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot plant any more cannabis.");
	return 1;
}
forward Drugs_OnGLOBALCheckAmount(playerid, iDrugID);
public Drugs_OnGLOBALCheckAmount(playerid, iDrugID)
{
	new iRows = cache_get_row_count(MainPipeline);
	if(iRows < MAX_DRUGS) Drugs_CreateQuery(playerid, iDrugID);
	else SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot plant any more cannabis.");
	return 1;
}
Drugs_CreateQuery(playerid, iDrugID) {

	new i = Iter_Free(PlayerDrugs),
		iIngredientID;

	if(i == -1) return SendClientMessageEx(playerid, COLOR_GRAD1, "Not enough space to plant more. Max. server limit reached.");

	new Float:fPos[3],
		iVW = GetPlayerVirtualWorld(playerid),
		iINT = GetPlayerInterior(playerid);

	switch(iDrugID) {

		case 1: iIngredientID = 1;
		case 6: iIngredientID = 7;
	}

	PlayerInfo[playerid][p_iIngredient][iIngredientID] -= 10;
	GetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]);
	format(szMiscArray, sizeof(szMiscArray), "INSERT INTO `drugpool` (`id`, `drugid`, `quality`, `DBID`, `name`, `timestamp`, `posx`, `posy`, `posz`,\
		`vw`, `int`) VALUES ('%d', '%d', '%d', '%d', '%s', '%d', '%f', '%f', '%f', '%d', '%d')",
		i, iDrugID, (PlayerInfo[playerid][pDrugsSkill] + 1) * 40, GetPlayerSQLId(playerid), GetPlayerNameExt(playerid), gettime(), fPos[0], fPos[1], fPos[2], iVW, iINT);
	mysql_function_query(MainPipeline, szMiscArray, false, "Drugs_OnCreateQuery", "iiifffii", playerid, iDrugID, i, fPos[0], fPos[1], fPos[2], iVW, iINT);
	return 1;
}



forward Drugs_OnCreateQuery(playerid, iDrugID, id, Float:X, Float:Y, Float:Z, iVW, iINT);
public Drugs_OnCreateQuery(playerid, iDrugID, id, Float:X, Float:Y, Float:Z, iVW, iINT)
{
	if(mysql_errno(MainPipeline)) SendClientMessageEx(playerid, COLOR_GRAD1, "Something went wrong. Please try again later.");

	Iter_Add(PlayerDrugs, id);
	format(szMiscArray, sizeof(szMiscArray), "%s's %s\n{AAAAAA}(ID %d)\n{DDDDDD}Growing.", GetPlayerNameEx(playerid), szDrugs[iDrugID], id);
	arrDrugData[id][dr_iTextID] = CreateDynamic3DTextLabel(szMiscArray, COLOR_GREEN, X, Y, Z, 10.0, .worldid = iVW, .interiorid = iINT);
	arrDrugData[id][dr_iDrugID] = iDrugID;

	format(szMiscArray, sizeof(szMiscArray), "[Drugs]: {DDDDDD}You have successfully planted the %s plant. Type /myplants for more information.", szDrugs[iDrugID]);
	SendClientMessageEx(playerid, COLOR_GREEN, szMiscArray);

	format(szMiscArray, sizeof(szMiscArray), "%s(%d) (IP:%s) has placed an %s plant (%d)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), szDrugs[iDrugID], id);
	Log("logs/plant.log", szMiscArray);

	format(szMiscArray, sizeof(szMiscArray), "* %s plants something.", GetPlayerNameEx(playerid));
	ProxDetector(25.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

	ApplyAnimation(playerid, "BOMBER","BOM_Plant_In", 4.0, 0, 0, 0, 0, 0);
	return 1;
}

forward Drugs_OnGrowthCheck();
public Drugs_OnGrowthCheck()
{
	print("[Drug System] Checking player drug pool.");
	new iRows = cache_get_row_count(MainPipeline);
	if(!iRows) return 1;
	new iFields,
		iCount,
		// Float:fPos[3],
		iVW,
		iINT;

	cache_get_data(iRows, iFields, MainPipeline);
	new szName[MAX_PLAYER_NAME];
	while(iCount < iRows) {

		if(cache_get_field_content_int(iCount, "spawned", MainPipeline) == 0) {

			new iCompletedTimeStamp = cache_get_field_content_int(iCount, "timestamp", MainPipeline);
			if(gettime() > iCompletedTimeStamp + 345600) { // Making sure all unused plants are wiped.
				format(szMiscArray, sizeof(szMiscArray), "DELETE FROM `drugpool` WHERE `id` = '%d'", iCount);
				mysql_function_query(MainPipeline, szMiscArray, false, "OnQueryFinish", "i", SENDDATA_THREAD);
				if(iCount < MAX_DRUGS) Iter_Remove(PlayerDrugs, iCount);
			}
			else {

				iCompletedTimeStamp += DRUGS_GROWTH_TIME;
				if(gettime() > iCompletedTimeStamp)	{

					new iFreeID = Iter_Free(PlayerDrugs);
					Iter_Add(PlayerDrugs, iFreeID);
					cache_get_field_content(iCount, "name", szName, MainPipeline, sizeof(szName));
					arrDrugData[iFreeID][dr_fPos][0] = cache_get_field_content_float(iCount, "posx", MainPipeline);
					arrDrugData[iFreeID][dr_fPos][1] = cache_get_field_content_float(iCount, "posy", MainPipeline);
					arrDrugData[iFreeID][dr_fPos][2] = cache_get_field_content_float(iCount, "posz", MainPipeline);
					iVW = cache_get_field_content_int(iCount, "vw", MainPipeline);
					iINT = cache_get_field_content_int(iCount, "int", MainPipeline);
					arrDrugData[iFreeID][dr_iDrugID] = cache_get_field_content_int(iCount, "drugid", MainPipeline);

					arrDrugData[iFreeID][dr_iDrugQuality] = cache_get_field_content_int(iCount, "quality", MainPipeline);
					
					arrDrugData[iFreeID][dr_iDBID] = iCount;
					DestroyDynamic3DTextLabel(arrDrugData[iFreeID][dr_iTextID]);
					// format(szMiscArray, sizeof(szMiscArray), "%s's %s\n{AAAAAA}(ID %d)\n{DDDDDD}Press ~k~~CONVERSATION_YES~ to harvest it.", StripUnderscore(szName), szDrugs[arrDrugData[iFreeID][dr_iDrugID]], iCount);
					format(szMiscArray, sizeof(szMiscArray), "%s's %s\n{AAAAAA}(ID %d)\n{DDDDDD}Use /getplant to harvest it.", StripUnderscore(szName), szDrugs[arrDrugData[iFreeID][dr_iDrugID]], iCount);
					arrDrugData[iFreeID][dr_iTextID] = CreateDynamic3DTextLabel(szMiscArray, COLOR_GREEN, arrDrugData[iFreeID][dr_fPos][0], arrDrugData[iFreeID][dr_fPos][1], arrDrugData[iFreeID][dr_fPos][2], 10.0, .worldid = iVW, .interiorid = iINT);
					arrDrugData[iFreeID][dr_iObjectID] = CreateDynamicObject(3409, arrDrugData[iFreeID][dr_fPos][0], arrDrugData[iFreeID][dr_fPos][1], arrDrugData[iFreeID][dr_fPos][2] - 1.25, 0.0, 0.0, 0.0, iVW, iINT);
					format(szMiscArray, sizeof(szMiscArray), "UPDATE `drugpool` SET `spawned` = 1 WHERE `id` = '%d'", arrDrugData[iFreeID][dr_iDBID]);
					mysql_function_query(MainPipeline, szMiscArray, false, "OnQueryFinish", "i", SENDDATA_THREAD);
				}
			}
		}
		++iCount;
	}
	return 1;
}


forward Drugs_OnSearchDrugs(playerid);
public Drugs_OnSearchDrugs(playerid) {

	new iRows = cache_get_row_count(MainPipeline);

	if(!iRows) return SendClientMessageEx(playerid, COLOR_GRAD1, "You haven't planted any drugs.");

	new iFields,
		iCount,
		iDialogCount,
		szDate[64];

	cache_get_data(iRows, iFields, MainPipeline);

	szMiscArray = "Drug\tExpected Completion\n";

	while(iCount < iRows) {

		new iDeliverTime = cache_get_field_content_int(iCount, "timestamp", MainPipeline) + DRUGS_GROWTH_TIME,
			iDrugID = cache_get_field_content_int(iCount, "drugid", MainPipeline);

		if(gettime() < iDeliverTime) format(szDate, sizeof(szDate), "{FFFF00}%s", date(iDeliverTime, 2));
		else format(szDate, sizeof(szDate), "{00FF00}%s", date(iDeliverTime, 2));

		ListItemTrackId[playerid][iDialogCount] = iCount;

		if(cache_get_field_content_int(iCount, "int", MainPipeline) > 0) format(szMiscArray, sizeof(szMiscArray), "%s%s (INTERIOR!)\t%s\n", szMiscArray, szDrugs[iDrugID], szDate);
		else format(szMiscArray, sizeof(szMiscArray), "%s%s\t%s\n", szMiscArray, szDrugs[iDrugID], szDate);

		++iCount;
		++iDialogCount;
	}

	ShowPlayerDialogEx(playerid, DIALOG_DRUGPOOL, DIALOG_STYLE_TABLIST_HEADERS, "Your plants", szMiscArray, "Find", "");
	return 1;
}

forward Drug_OnListPostOrders(playerid);
public Drug_OnListPostOrders(playerid) {

	new iRows = cache_get_row_count(MainPipeline);
	if(!iRows) return SendClientMessageEx(playerid, COLOR_GRAD1, "No post orders matched your query.");

	new iFields,
		iCount,
		szName[MAX_PLAYER_NAME + 1],
		szDate[64];

	cache_get_data(iRows, iFields, MainPipeline);

	new iDeliverTime = cache_get_field_content_int(iCount, "timestamp", MainPipeline) + DRUG_ORDER_TIME;

	if(gettime() < iDeliverTime) format(szDate, sizeof(szDate), "{FFFF00}%s", date(iDeliverTime, 2));
	else format(szDate, sizeof(szDate), "{00FF00}%s", date(iDeliverTime, 2));

	szMiscArray = "Name\tOrdering\tExpected delivery\n";

	while(iCount < iRows) {

		cache_get_field_content(iCount, "name", szName, MainPipeline, sizeof(szName));

		format(szMiscArray, sizeof(szMiscArray), "%s%s\t%s (%d)\t%s\n",
			szMiscArray,
			StripUnderscore(szName),
			szIngredients[cache_get_field_content_int(iCount, "ingredientid", MainPipeline)],
			cache_get_field_content_int(iCount, "amount", MainPipeline),
			szDate);

		iCount++;
	}

	ShowPlayerDialogEx(playerid, DIALOG_DRUGS_ORDER_LIST, DIALOG_STYLE_TABLIST_HEADERS, "Post Office | Orders", szMiscArray, "<<", "");
	return 1;
}

forward Drug_OnGetPostOrders(playerid);
public Drug_OnGetPostOrders(playerid) {

	new iRows = cache_get_row_count(MainPipeline);

	if(!iRows) return SendClientMessageEx(playerid, COLOR_GRAD1, "You do not have any post orders.");

	new iFields,
		iCount,
		szQuery[200];

	format(szMiscArray, sizeof(szMiscArray), "__________ [%s's Order Delivery] __________", GetPlayerNameEx(playerid));
	SendClientMessageEx(playerid, COLOR_GREEN, szMiscArray);

	cache_get_data(iRows, iFields, MainPipeline);

	while(iCount < iRows)
	{
		new iDeliverTime = cache_get_field_content_int(iCount, "timestamp", MainPipeline) + DRUG_ORDER_TIME;
		if(gettime() > iDeliverTime) {

			new iIngredientID = cache_get_field_content_int(iCount, "ingredientid", MainPipeline),
				iAmount = cache_get_field_content_int(iCount, "amount", MainPipeline);

			PlayerInfo[playerid][p_iIngredient][iIngredientID] += iAmount;
			format(szMiscArray, sizeof(szMiscArray), "[Order Delivery]: {CCCCCC}%d pieces of %s.", iAmount, szIngredients[iIngredientID]);
			SendClientMessageEx(playerid, COLOR_GREEN, szMiscArray);

			format(szQuery, sizeof(szQuery), "DELETE FROM `blackmarkets_orders` WHERE `DBID` = '%d' AND `timestamp` < '%d'", GetPlayerSQLId(playerid), iDeliverTime);
			mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "i", SENDDATA_THREAD);
		}
		iCount++;
	}
	SendClientMessageEx(playerid, COLOR_GREEN, "____________________________________________");
	return 1;
}

CMD:triggerpoints(playerid, params[]) {

	if(IsAdminLevel(playerid, ADMIN_SENIOR)) Point_Process();
	return 1;
}

CMD:rehashpoints(playerid, params[]) {

	if(IsAdminLevel(playerid, ADMIN_SENIOR)) {
		SendClientMessageEx(playerid, COLOR_YELLOW, "[Point]: Reloading all points.");
		for(new i; i < MAX_DYNPOINTS; ++i) {

			arrPoint[i][po_iGroupID] = INVALID_GROUP_ID;
			arrPoint[i][po_iCapturable] = 0;
			arrPoint[i][po_fPos][0] = 0.0;
			arrPoint[i][po_fPos][1] = 0.0;
			arrPoint[i][po_fPos][2] = 0.0;

			DestroyDynamicPickup(arrPoint[i][po_iPickupID]);
			DestroyDynamic3DTextLabel(arrPoint[i][po_iTextID]);
			DestroyDynamic3DTextLabel(arrPoint[i][po_iDelTextID]);
			DestroyDynamicArea(arrPoint[i][po_iBigAreaID]);
			GangZoneDestroy(arrPoint[i][po_iZoneID]);
			Iter_Remove(Points, i);
		}
		PO_LoadPoints();
	}
	else SendClientMessageEx(playerid, COLOR_GRAD1, "You do not have the authority to use this command.");
	return 1;
}

CMD:getplant(playerid, params[]) {

	/*
	new areaid[1];
	GetPlayerDynamicAreas(playerid, areaid, sizeof(areaid));
	*/

	for(new i; i < MAX_DRUGS; ++i) {

		if(IsPlayerInRangeOfPoint(playerid, 2.0, arrDrugData[i][dr_fPos][0], arrDrugData[i][dr_fPos][1], arrDrugData[i][dr_fPos][2])) {
		// if(areaid[0] == arrDrugData[i][dr_iAreaID]) {
			SetPVarInt(playerid, "AtDrugArea", i);
			// if(IsPlayerInRangeOfPoint(playerid, 2.0, arrDrugData[i][dr_fPos][0], arrDrugData[i][dr_fPos][1], arrDrugData[i][dr_fPos][2])) {
			if(IsACop(playerid)) ShowPlayerDialogEx(playerid, DIALOG_DRUG_INTERACT, DIALOG_STYLE_LIST, "Drug Plant | Cop Menu", "{00FF00}Harvest\n{FF0000}Destroy", "Select", "Cancel");
			else ShowPlayerDialogEx(playerid, DIALOG_DRUG_INTERACT, DIALOG_STYLE_MSGBOX, "Drug Plant | Harvest", "{FFFFFF}Would you like to {00FF00}harvest{FFFFFF} this drug plant?", "Harvest", "Cancel");
			break;
		}
	}
	return 1;
}

CMD:flushdrugs(playerid, params[]) {

	if(IsAdminLevel(playerid, ADMIN_SENIOR)) {

		SendClientMessageEx(playerid, COLOR_GRAD1, "You flushed the player drugs data.");
		Drugs_FlushDrugs();
	}
	return 1;
}

Drugs_FlushDrugs() {

	mysql_function_query(MainPipeline, "DELETE FROM `drugpool`", false, "OnQueryFinish", "i", SENDDATA_THREAD);
	for(new i; i < MAX_DRUGS; ++i) {

		if(IsValidDynamicObject(arrDrugData[i][dr_iObjectID])) DestroyDynamicObject(arrDrugData[i][dr_iObjectID]);
		if(IsValidDynamic3DTextLabel(arrDrugData[i][dr_iTextID])) DestroyDynamic3DTextLabel(arrDrugData[i][dr_iTextID]);
		// if(IsValidDynamicArea(arrDrugData[i][dr_iAreaID])) DestroyDynamicArea(arrDrugData[i][dr_iAreaID]);
		arrDrugData[i][dr_iDrugQuality] = 0;
		arrDrugData[i][dr_fPos][0] = 0;
		arrDrugData[i][dr_fPos][1] = 0;
		arrDrugData[i][dr_fPos][2] = 0;
		Iter_Remove(PlayerDrugs, i);
	}
}

CMD:mydrugs(playerid, params[]) {

	format(szMiscArray, sizeof(szMiscArray),"_______ %s's drugs _______", GetPlayerNameEx(playerid));
	SendClientMessageEx(playerid, COLOR_GREEN, szMiscArray);

	for(new i; i < sizeof(szDrugs); ++i) {

		format(szMiscArray, sizeof(szMiscArray),"{CCCCCC}%s: %dpc {AAAAAA}(%dqP){CCCCCC} | %s: %d pc {AAAAAA}(%dqP)", szDrugs[i], PlayerInfo[playerid][p_iDrug][i], PlayerInfo[playerid][p_iDrugQuality][i],
			szDrugs[i+1], PlayerInfo[playerid][p_iDrug][i+1], PlayerInfo[playerid][p_iDrugQuality][i+1]);
		SendClientMessageEx(playerid, COLOR_GRAD1, szMiscArray);

		i++;
	}

	SendClientMessageEx(playerid, COLOR_GREEN, "__________________________________");
	return 1;
}

CMD:buydrugs(playerid, params[]) {

	szMiscArray[0] = 0;

	for(new i; i < sizeof(szIngredients); ++i) format(szMiscArray, sizeof(szMiscArray), "%s%s\n", szMiscArray, szIngredients[i]);

	ShowPlayerDialogEx(playerid, DIALOG_DRUGS_DRUGSTORE, DIALOG_STYLE_LIST, "Drug Store", szMiscArray, "Buy", "");
	return 1;
}

CMD:dropdrug(playerid, params[]) {

	new szChoice[16],
		iAmount;

	if(sscanf(params, "s[16]d", szChoice, iAmount)) {

		SendClientMessageEx(playerid, COLOR_GRAD1, "Usage: /dropdrug [drug] [amount]");
		Drug_ListDrugs(playerid);
		return 1;
	}

	new iDrugID = Drug_GetID(szChoice);

	if(iDrugID == -1) return SendClientMessageEx(playerid, COLOR_GRAD1, "You specified an invalid drug.");

	if((0 < iAmount > PlayerInfo[playerid][p_iDrug][iDrugID])) return SendClientMessageEx(playerid, COLOR_GRAD1, "You do not have enough on you.");

	PlayerInfo[playerid][p_iDrug][iDrugID] -= iAmount;
	format(szMiscArray, sizeof(szMiscArray), "[Drugs]: {CCCCCC} You dropped %d pc of %s.", iAmount, szChoice);
	SendClientMessageEx(playerid, COLOR_GREEN, szMiscArray);
	return 1;
}

CMD:addictchart(playerid, params[]) {

	format(szMiscArray, sizeof(szMiscArray), "_______ Drugs | %s's Addicted Chart _______", GetPlayerNameEx(playerid));
	SendClientMessageEx(playerid, COLOR_GREEN, szMiscArray);

	for(new i; i < 9; ++i) {

		if(PlayerInfo[playerid][p_iAddicted][i] > 0) format(szMiscArray, sizeof(szMiscArray), "%s | Addicted: %dpQ", szDrugs[i], PlayerInfo[playerid][p_iAddictedLevel][i]);
		else format(szMiscArray, sizeof(szMiscArray), "%s | Addicted: No", szDrugs[i]);
		SendClientMessageEx(playerid, COLOR_GRAD1, szMiscArray);
	}

	// SendClientMessageEx(playerid, COLOR_GREEN, "________________________________");
	return 1;
}

CMD:usedrug(playerid, params[]) {

	if(GetPVarType(playerid, PVAR_DRUGS_OVERDOSE)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are currently overdosed.");
	if(GetPVarType(playerid, "WatchingTV") || GetPVarType(playerid, "PreviewingTV")) return SendClientMessage(playerid, COLOR_GRAD1, "You cannot use drugs while watching TV.");

	if(dr_iPlayerTimeStamp[playerid] > gettime() - 120) return SendClientMessageEx(playerid, COLOR_GRAD1, "You have been injured in the last two minutes");
	if(HungerPlayerInfo[playerid][hgInEvent] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "   You cannot do this while being in the Hunger Games Event!");

   	#if defined zombiemode
	if(zombieevent == 1 && GetPVarType(playerid, "pIsZombie")) return SendClientMessageEx(playerid, COLOR_GREY, "Zombies can't use this.");
	#endif

	if(GetPVarType(playerid, "PlayerCuffed") || GetPVarInt(playerid, "pBagged") >= 1 || GetPVarType(playerid, "Injured") || GetPVarType(playerid, "IsFrozen") || PlayerInfo[playerid][pHospital] || (PlayerInfo[playerid][pJailTime] > 0 && strfind(PlayerInfo[playerid][pPrisonReason], "[OOC]", true) != -1))
   		return SendClientMessage(playerid, COLOR_GRAD2, "You can't do that at this time!");

	if(GetPVarType(playerid, "AttemptingLockPick")) return SendClientMessageEx(playerid, COLOR_WHITE, "You are attempting to lockpick, please wait.");
	if(GetPVarType(playerid, "IsInArena")) return SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this while being in an arena!");
	if(PlayerBoxing[playerid] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use drugs while you're fighting.");
	if(UsedCrack[playerid] == 1) return SendClientMessageEx(playerid, COLOR_WHITE, "You must wait 5 seconds before using more drugs.");
	if(PlayerInfo[playerid][pHospital]) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot do this at this time.");

	new szChoice[16],
		iAmount,
		iAnim;

	if(sscanf(params, "s[16]dD(1)", szChoice, iAmount, iAnim)) {
		SendClientMessageEx(playerid, COLOR_GRAD1, "Usage: /usedrug [drug] [amount] [emote]");
		Drug_ListDrugs(playerid);
		return 1;
	}

	if(iAmount < 1 || iAmount > 30) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot take that.");

	new iDrugID = Drug_GetID(szChoice);

	if(iDrugID == -1) return SendClientMessageEx(playerid, COLOR_GRAD1, "You specified an invalid drug.");

	if(PlayerInfo[playerid][p_iDrug][iDrugID] < iAmount) return SendClientMessageEx(playerid, COLOR_GRAD1, "You do not have enough on you.");

	Bit_On(arrPlayerBits[playerid], dr_bitUsedDrug);

	PlayerInfo[playerid][p_iDrug][iDrugID] -= iAmount;
	format(szMiscArray, sizeof(szMiscArray), "[Drugs]: {CCCCCC}You used %dpc of %s.", iAmount, szChoice);

	if(iAnim) ApplyAnimation(playerid, "FOOD", "EAT_Pizza", 4.1, 1, 0, 0, 0, 4000, 0);

	SendClientMessageEx(playerid, COLOR_GREEN, szMiscArray);
	PlayerInfo[playerid][p_iDrugTaken][iDrugID] += iAmount;

	switch(iDrugID) {

		case 0 .. 9: {

			if(PlayerInfo[playerid][p_iAddicted][iDrugID] < 2) PlayerInfo[playerid][p_iAddictedLevel][iDrugID] += DRUGS_ADDICTION_RATE * iAmount;

			if(PlayerInfo[playerid][p_iAddicted][iDrugID] == 2) PlayerInfo[playerid][p_iAddictedLevel][iDrugID] -= DRUGS_ADDICTION_RATE * iAmount;
		}
	}

	Drug_Process(playerid, iDrugID, iAmount);
	return 1;
}

CMD:myingredients(playerid, params[]) {

	format(szMiscArray, sizeof(szMiscArray),"_______ %s's ingredients _______", GetPlayerNameEx(playerid));
	SendClientMessageEx(playerid, COLOR_GREEN, szMiscArray);

	for(new i; i < sizeof(szIngredients); ++i) {

		format(szMiscArray, sizeof(szMiscArray),"%s: %d pc | %s: %d pc", szIngredients[i], PlayerInfo[playerid][p_iIngredient][i], szIngredients[i+1], PlayerInfo[playerid][p_iIngredient][i+1]);
		SendClientMessageEx(playerid, COLOR_GRAD1, szMiscArray);
		i++;
	}

	SendClientMessageEx(playerid, COLOR_GREEN, "__________________________________");
	return 1;
}

CMD:dropingredient(playerid, params[]) {

	new szChoice[16],
		iAmount;

	if(sscanf(params, "s[16]d", szChoice, iAmount)) {

		SendClientMessageEx(playerid, COLOR_GRAD1, "Usage: /dropingredient [ingredient] [amount]");
		Drug_ListIngredients(playerid);
		return 1;
	}

	new iIngredientID = Drug_IngredientID(szChoice);

	if(iIngredientID == -1) return SendClientMessageEx(playerid, COLOR_GRAD1, "You specified an invalid ingredient.");

	if(!(0 <= iAmount <= PlayerInfo[playerid][p_iIngredient][iIngredientID])) return SendClientMessageEx(playerid, COLOR_GRAD1, "You do not have enough on you.");

	PlayerInfo[playerid][p_iIngredient][iIngredientID] -= iAmount;
	format(szMiscArray, sizeof(szMiscArray), "[Drugs]: {CCCCCC} You dropped %dpc of %s.", iAmount, szChoice);
	SendClientMessageEx(playerid, COLOR_GREEN, szMiscArray);
	return 1;
}

CMD:mymix(playerid, params[]) {

	if(!GetPVarType(playerid, PVAR_MAKINGDRUG)) format(szMiscArray, sizeof(szMiscArray), "_______ %s's Drug Mix _______", GetPlayerNameEx(playerid));
	else format(szMiscArray, sizeof(szMiscArray), "_______ %s's Drug Mix for %s _______", GetPlayerNameEx(playerid), szDrugs[GetPVarInt(playerid, PVAR_MAKINGDRUG)]);

	SendClientMessageEx(playerid, COLOR_GREEN, szMiscArray);

	for(new i; i < MAX_DRUGINGREDIENT_SLOTS; ++i) {

		if(dr_arrDrugMix[playerid][i][drm_iAmount] > 0)
			format(szMiscArray, sizeof(szMiscArray), "[Drug Slot #%d]: {CCCCCC}Ingredient: %s | Pc: %d", i, szIngredients[dr_arrDrugMix[playerid][i][drm_iIngredientID]], dr_arrDrugMix[playerid][i][drm_iAmount]);

		else format(szMiscArray, sizeof(szMiscArray), "[Drug Slot #%d]: {CCCCCC}None", i);

		SendClientMessageEx(playerid, COLOR_GREEN, szMiscArray);
	}

	SendClientMessageEx(playerid, COLOR_GREEN, "________________________________");
	return 1;
}

CMD:mix(playerid, params[]) {

	if(!GetPVarType(playerid, PVAR_MAKINGDRUG)) Drug_StartMix(playerid);
	else Drug_ShowMix(playerid);
	return 1;
}

CMD:clearmix(playerid, params[]) {

	for(new i; i < MAX_DRUGINGREDIENT_SLOTS; ++i) dr_arrDrugMix[playerid][i][drm_iAmount] = 0;

	SendClientMessageEx(playerid, COLOR_GREEN, "[Drugs]: {CCCCCC} You cleared your mixture.");
	DeletePVar(playerid, PVAR_MAKINGDRUG);
	return 1;
}

/* Black Markets */

BM_GetBlackMarketID(playerid) {

	if(IsPlayerInAnyDynamicArea(playerid)) {

		new areaid[1];
		GetPlayerDynamicAreas(playerid, areaid);

		for(new i; i < MAX_BLACKMARKETS; ++i) {
			// if(IsPlayerInRangeOfPoint(playerid, 2.0, arrBlackMarket[i][bm_fPos][0], arrBlackMarket[i][bm_fPos][1], arrBlackMarket[i][bm_fPos][2])) 
			if(arrBlackMarket[i][bm_iAreaID] == areaid[0]) return i;
		}
	}
	return -1;
}

CMD:seize(playerid, params[]) {

	if(!IsACop(playerid)) return SendClientMessage(playerid, COLOR_GRAD1, "You are not a cop");
	if(PlayerInfo[playerid][pRank] < 5) return SendClientMessage(playerid, COLOR_GRAD1, "You must be at least rank 5 to seize a black market.");

	new i = BM_GetBlackMarketID(playerid);
	if(i == -1) return SendClientMessage(playerid, COLOR_GRAD1, "You are not near a black market.");

	SetPVarInt(playerid, "AtBlackMarket", i);
	if(arrBlackMarket[i][bm_iSeized]) return SendClientMessage(playerid, COLOR_GRAD1, "This black market has already been seized.");

	new iCount[2],
		iGangGroupID = arrBlackMarket[i][bm_iGroupID];

	foreach(new p : Player) {
		if(IsACop(p)) iCount[0]++;
		if(PlayerInfo[p][pMember] == iGangGroupID) iCount[1]++;
	}

	// if(iCount[0] < 10 || (iCount[0] > iCount[1] + 5)) return SendClientMessageEx(playerid, COLOR_GRAD1, "There need to be at least 10 LEOs. Or, there are 5 or more gang members less than LEOs.");
	/*
	new Float:fPos[3];

	Streamer_GetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, arrBlackMarket[i][bm_iTextID], E_STREAMER_X, fPos[0]);
	Streamer_GetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, arrBlackMarket[i][bm_iTextID], E_STREAMER_Y, fPos[1]);
	Streamer_GetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, arrBlackMarket[i][bm_iTextID], E_STREAMER_Z, fPos[2]);
	*/


	new gz = GangZoneCreate(arrBlackMarket[i][bm_fPos][0] - 100.0, arrBlackMarket[i][bm_fPos][1] - 100.0, arrBlackMarket[i][bm_fPos][0] + 100.0, arrBlackMarket[i][bm_fPos][1] + 100.0);
	SetGVarInt("BM_GZ", gz);

	GangZoneShowForAll(gz, COLOR_GREEN);
	GangZoneFlashForAll(gz, COLOR_BLACK);

	gz = CreateDynamicRectangle(arrBlackMarket[i][bm_fPos][0] - 100.0, arrBlackMarket[i][bm_fPos][1] - 100.0, arrBlackMarket[i][bm_fPos][0] + 100.0, arrBlackMarket[i][bm_fPos][1] + 100.0);
	SetGVarInt("BM_A", gz);

	arrBlackMarket[i][bm_iSeized] = 1;

	SetGVarInt("BM_Time", 15, i);

	SetGVarInt("BM_Capturer", PlayerInfo[playerid][pMember], i);

	BM_BlackMarketMicroTimer(PlayerInfo[playerid][pMember], i, 0);

	defer BM_Seize[60000 * 15](i);

	foreach(new p : Player) {

		if(IsACop(p) || PlayerInfo[playerid][pMember] == arrBlackMarket[i][bm_iGroupID]) {

			format(szMiscArray, sizeof(szMiscArray), "[Black Market]: {FF4C4C}%s has started to seize {FFFF00}%s{FF4C4C}'s black market.", GetPlayerNameEx(playerid), arrGroupData[iGangGroupID][g_szGroupName]);
			SendClientMessageEx(p, COLOR_GREEN, szMiscArray);
			SendClientMessage(p, COLOR_GREEN, "[Objective]: {DDDDDD}In 15 minutes, it will be seized if there are at least 6 LEOs near the black market.");
		}
	}
	return 1;
}

CMD:createblackmarket(playerid, params[]) {

	szMiscArray[0] = 0;

	if(PlayerInfo[playerid][pAdmin] < 1337 && PlayerInfo[playerid][pGangModerator] < 2 && PlayerInfo[playerid][pFactionModerator] < 2) return 1;

	//if(!IsAdminLevel(playerid, ADMIN_HEAD)) return 1;

	new	j;

	for(new i; i < MAX_GROUPS; ++i) {

		if(arrGroupData[i][g_iGroupType] == GROUP_TYPE_CRIMINAL) {

			if(arrGroupData[i][g_szGroupName][0]) {

				format(szMiscArray, sizeof szMiscArray, "%s\n(%i) {%s}%s{FFFFFF}", szMiscArray, i+1, Group_NumToDialogHex(arrGroupData[i][g_hDutyColour]), arrGroupData[i][g_szGroupName]);
				ListItemTrackId[playerid][j++] = i;
			}
		}
	}
	ShowPlayerDialogEx(playerid, DIALOG_BLACKMARKET_CREATE, DIALOG_STYLE_LIST, "Create Black Market", szMiscArray, "Select", "Cancel");
	return 1;
}

CMD:destroyblackmarket(playerid, params[])
{

	if(PlayerInfo[playerid][pAdmin] < 1337 && PlayerInfo[playerid][pGangModerator] < 2 && PlayerInfo[playerid][pFactionModerator] < 2) return 1;
	new i;
	if(sscanf(params, "d", i)) return SendClientMessageEx(playerid, COLOR_GRAD1, "Usage: /destroyblackmarket [id]");

	// if(IsValidDynamicPickup(arrBlackMarket[i][bm_iPickupID])) {
	if(Iter_Contains(BlackMarkets, i)) {

		DestroyDynamicPickup(arrBlackMarket[i][bm_iPickupID]);
		DestroyDynamic3DTextLabel(arrBlackMarket[i][bm_iTextID]);
		DestroyDynamic3DTextLabel(arrBlackMarket[i][bm_iDelTextID]);
		arrBlackMarket[i][bm_fPos][0] = 0.0;
		arrBlackMarket[i][bm_fPos][1] = 0.0;
		arrBlackMarket[i][bm_fPos][2] = 0.0;
		if(IsValidDynamicArea(arrBlackMarket[i][bm_iAreaID])) DestroyDynamicArea(arrBlackMarket[i][bm_iAreaID]);
		Iter_Remove(BlackMarkets, i);
		format(szMiscArray, sizeof(szMiscArray), "UPDATE `blackmarkets` SET `groupid` = '-1' WHERE `id` = '%d'", i + 1);
		mysql_function_query(MainPipeline, szMiscArray, false, "BM_OnDeleteBlackMarket", "ii", playerid, i);

		foreach(new p : Player) if(PlayerInfo[p][pMember] == arrBlackMarket[i][bm_iGroupID]) SendClientMessageEx(p, COLOR_LIGHTRED, "An administrator deleted your black market.");
	}
	else SendClientMessageEx(playerid, COLOR_GRAD1, "You specified an invalid ID.");
	return 1;
}

CMD:gblackmarket(playerid, params[])
{
	DeletePVar(playerid, PVAR_BLMARKETID);
	if(!(0 <= PlayerInfo[playerid][pLeader] < MAX_GROUPS) || !IsACriminal(playerid)) return 1;

	for(new i; i < MAX_BLACKMARKETS; ++i) if(arrBlackMarket[i][bm_iGroupID] == PlayerInfo[playerid][pMember] && IsValidDynamicPickup(arrBlackMarket[i][bm_iPickupID])) {
		SetPVarInt(playerid, PVAR_BLMARKETID, i);
		break;
	}

	if(!GetPVarType(playerid, PVAR_BLMARKETID)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not part of a gang or your black market has not been setup yet.");
	if(arrBlackMarket[GetPVarInt(playerid, PVAR_BLMARKETID)][bm_iSeized]) return SendClientMessageEx(playerid, COLOR_GRAD1, "This black market is currently seized.");
	ShowPlayerDialogEx(playerid, DIALOG_BLACKMARKET_MAIN, DIALOG_STYLE_LIST, "Your Black Market", "Show orders\nShow stock\nEdit prices\nEdit smuggle payment\nTransfer stock", "Select", "");
	return 1;
}

CMD:ablackmarket(playerid, params[]) {

	szMiscArray[0] = 0;

	new szChoice[16],
		iDialogCount;

	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pFactionModerator] < 2) return SendClientMessageEx(playerid, COLOR_GREY, "You do not have the authority to use this command.");
	if(sscanf(params, "s[16]", szChoice)) return SendClientMessageEx(playerid, COLOR_GRAD1, "Usage: /ablackmarket [choice] | Available: 'goto', 'position', 'deliverpos', 'destroy', 'seized'");

	for(new i; i < MAX_BLACKMARKETS; ++i) {

		if(IsValidDynamicPickup(arrBlackMarket[i][bm_iPickupID])) {

			format(szMiscArray, sizeof(szMiscArray), "%s%s\n", szMiscArray, arrGroupData[arrBlackMarket[i][bm_iGroupID]][g_szGroupName]);
			ListItemTrackId[playerid][iDialogCount] = i;
			iDialogCount++;
		}
	}
	if(strcmp(szChoice, "goto", true) == 0) return ShowPlayerDialogEx(playerid, DIALOG_BLACKMARKET_ALIST, DIALOG_STYLE_LIST, "Black Markets", szMiscArray, "Teleport", "");
	if(strcmp(szChoice, "position", true) == 0) return ShowPlayerDialogEx(playerid, DIALOG_BLACKMARKET_APOINT, DIALOG_STYLE_LIST, "Black Markets", szMiscArray, "Set", "");
	if(strcmp(szChoice, "deliverpos", true) == 0) return ShowPlayerDialogEx(playerid, DIALOG_BLACKMARKET_ADELPOINT, DIALOG_STYLE_LIST, "Black Markets", szMiscArray, "Set", "");
	if(strcmp(szChoice, "destroy", true) == 0) return ShowPlayerDialogEx(playerid, DIALOG_BLACKMARKET_ADELBM, DIALOG_STYLE_LIST, "Black Markets", szMiscArray, "Destroy", "");
	if(strcmp(szChoice, "seized", true) == 0) return ShowPlayerDialogEx(playerid, DIALOG_BLACKMARKET_ASEIZE, DIALOG_STYLE_LIST, "Black Markets", szMiscArray, "Unseize", "");
	SendClientMessageEx(playerid, COLOR_GRAD1, "You specified an invalid choice.");
	return 1;
}

CMD:orderingredient(playerid, params[]) {

	new iDialogCount;

	szMiscArray[0] = 0;

	for(new i; i < MAX_BLACKMARKETS; ++i) {

		if(IsValidDynamicPickup(arrBlackMarket[i][bm_iPickupID])) {

			format(szMiscArray, sizeof(szMiscArray), "%s%s\n", szMiscArray, arrGroupData[arrBlackMarket[i][bm_iGroupID]][g_szGroupName]);
			ListItemTrackId[playerid][iDialogCount] = i;
			iDialogCount++;
		}
	}
	ShowPlayerDialogEx(playerid, DIALOG_BLACKMARKET_LIST, DIALOG_STYLE_LIST, "Black Markets", szMiscArray, "Select", "");
	return 1;
}

CMD:mypostorders(playerid, params[]) {

	format(szMiscArray, sizeof(szMiscArray), "SELECT * FROM `blackmarkets_orders` WHERE `DBID` = %d", GetPlayerSQLId(playerid));
	mysql_function_query(MainPipeline, szMiscArray, true, "Drug_OnListPostOrders", "i", playerid);
	return 1;
}

CMD:listpostorders(playerid, params[]) {

	if(!IsACop(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not a cop.");
	mysql_function_query(MainPipeline, "SELECT * FROM `blackmarkets_orders` WHERE `trackable` = 1", true, "Drug_OnListPostOrders", "i", playerid);
	return 1;
}

CMD:getpostorder(playerid, params[]) {

	if(!IsNearHouseMailbox(playerid) && !IsAtPostOffice(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not near your mailbox or a post office.");
	format(szMiscArray, sizeof(szMiscArray), "SELECT * FROM `blackmarkets_orders` WHERE `DBID` = %d", GetPlayerSQLId(playerid));
	mysql_function_query(MainPipeline, szMiscArray, true, "Drug_OnGetPostOrders", "i", playerid);
	return 1;
}

CMD:plantseeds(playerid, params[]) {

	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot plant seeds inside a vehicle.");
	if(PlayerInfo[playerid][pJailTime] && strfind(PlayerInfo[playerid][pPrisonReason], "[OOC]", true) != -1) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot plant seeds as an OOC prisoner.");
	new szChoice[16],
		iDrugID = -1,
		iIngredientID;

	if(sscanf(params, "s[16]", szChoice)) {

		SendClientMessageEx(playerid, COLOR_GRAD1, "Usage: /plantseeds [choice]");
		SendClientMessageEx(playerid, COLOR_GRAD1, "Choices: Cannabis, Opium");
		return 1;
	}

	iDrugID = Drug_GetID(szChoice);

	switch(iDrugID) {

		case 1: iIngredientID = 1;
		case 6: iIngredientID = 7;
		default: iIngredientID = 1;
	}

	if(iDrugID == -1) return SendClientMessageEx(playerid, COLOR_GRAD1, "You specified an invalid drug.");

	if(PlayerInfo[playerid][p_iIngredient][iIngredientID] < 10) return SendClientMessageEx(playerid, COLOR_GRAD1, "You need at least 10 seeds to grow a plant.");

	format(szMiscArray, sizeof(szMiscArray), "SELECT `DBID` FROM `drugpool` WHERE `DBID` = '%d'", GetPlayerSQLId(playerid));
	mysql_function_query(MainPipeline, szMiscArray, true, "Drugs_OnCheckAmount", "ii", playerid, iDrugID);
	return 1;
}

CMD:myplants(playerid, params[]) {

	format(szMiscArray, sizeof(szMiscArray), "SELECT `drugid`, `timestamp`, `posx`, `posy`, `posz`, `int` FROM `drugpool` WHERE `DBID` = '%d'", GetPlayerSQLId(playerid));
	mysql_function_query(MainPipeline, szMiscArray, true, "Drugs_OnSearchDrugs", "i", playerid);
	return 1;
}

CMD:destroyplant(playerid, params[]) {

	if(IsAdminLevel(playerid, ADMIN_SENIOR)) {

		new i;
		if(sscanf(params, "d", i)) return SendClientMessage(playerid, COLOR_GRAD1, "Usage: /destroyplant [id]");

		if(!IsValidDynamic3DTextLabel(arrDrugData[i][dr_iTextID])) return SendClientMessageEx(playerid, COLOR_GRAD1, "You specified an invalid drug plant.");
		format(szMiscArray, sizeof(szMiscArray), "DELETE FROM `drugpool` WHERE `id` = '%d'", arrDrugData[i][dr_iDBID]);
		mysql_function_query(MainPipeline, szMiscArray, false, "Drugs_OnDestroyPlant", "ii", playerid, i);
	}
	return 1;
}

// Dynamic Points

CMD:points(playerid, params[]) {

	if(PlayerInfo[playerid][pAdmin]) {
		
		szMiscArray = "Name\tOwned or Captured By\tType\n{FF0000}Capturable\t{FFFF00}Being Captured by\t{00FF00}Neutral\n";

		new iDialogCount;
		for(new i; i < MAX_DYNPOINTS; ++i) {

			// if(IsValidDynamicArea(arrPoint[i][po_iAreaID])) {
			if(arrPoint[i][po_fPos][0] != 0.0) {
				
				ListItemTrackId[playerid][iDialogCount] = i;
				iDialogCount++;

				if(GetGVarType("PO_CAPT", i)) {

					format(szMiscArray, sizeof(szMiscArray), "%s{FFFF00}(%d) {FFFF00}%s\t{FFFF00}%s\t{FFFF00}%s\n", szMiscArray, i, arrPoint[i][po_szPointName], arrGroupData[GetGVarInt("PO_CAPT", i)][g_szGroupName], (arrPoint[i][po_iType] == 0) ? ("Weapon Point") : ("Drug Point"));
				}
				else {

					new szGroup[GROUP_MAX_NAME_LEN];

					switch(arrPoint[i][po_iGroupID]) {

						case INVALID_GROUP_ID: szGroup = "None";
						default: strcat(szGroup, arrGroupData[arrPoint[i][po_iGroupID]][g_szGroupName], sizeof(szGroup));
					}

					switch(arrPoint[i][po_iCapturable]) {

						case 0: format(szMiscArray, sizeof(szMiscArray), "%s{FF4D4D}(%d) {FF4D4D}%s\t{FF4D4D}%s\t{FF4D4D}%s\n", szMiscArray, i, arrPoint[i][po_szPointName], szGroup, (arrPoint[i][po_iType] == 0) ? ("Weapon Point") : ("Drug Point"));
						case 1: format(szMiscArray, sizeof(szMiscArray), "%s{66FF66}(%d) {66FF66}%s\t{66FF66}%s\t{66FF66}%s\n", szMiscArray, i, arrPoint[i][po_szPointName], szGroup, (arrPoint[i][po_iType] == 0) ? ("Weapon Point") : ("Drug Point"));
					}
				}
			}
		}

		ShowPlayerDialogEx(playerid, DIALOG_POINT_LIST, DIALOG_STYLE_TABLIST_HEADERS, "Points", szMiscArray, "<<", "" );
	}
	SendClientMessageEx(playerid, COLOR_YELLOW, "___________________ [Points] ___________________");
	for(new i; i < MAX_DYNPOINTS; ++i) {

		if(IsValidDynamicPickup(arrPoint[i][po_iPickupID])) {

			if(GetGVarType("PO_CAPT", i)) {

				format(szMiscArray, sizeof(szMiscArray), "(%d) {FFFF00}%s {FFFF00}(%s) - Being captured by: {FFFF00}%s (capturable)", i, arrPoint[i][po_szPointName], (arrPoint[i][po_iType] == 0) ? ("Weapon Point") : ("Drug Point"), arrGroupData[GetGVarInt("PO_CAPT", i)][g_szGroupName]);
			}
			else {

				new szGroup[GROUP_MAX_NAME_LEN];

				switch(arrPoint[i][po_iGroupID]) {

					case INVALID_GROUP_ID: szGroup = "None";
					default: strcat(szGroup, arrGroupData[arrPoint[i][po_iGroupID]][g_szGroupName], sizeof(szGroup));
				}

				switch(arrPoint[i][po_iCapturable]) {

					case 0: format(szMiscArray, sizeof(szMiscArray), "(%d) {FF4D4D}%s {FF4D4D}(%s) - Owned by: %s", i, arrPoint[i][po_szPointName], (arrPoint[i][po_iType] == 0) ? ("Weapon Point") : ("Drug Point"), szGroup);
					case 1: format(szMiscArray, sizeof(szMiscArray), "(%d) {66FF66}%s {66FF66}(%s) - Owned by: %s (capturable)", i, arrPoint[i][po_szPointName], (arrPoint[i][po_iType] == 0) ? ("Weapon Point") : ("Drug Point"), szGroup);
				}
			}
			SendClientMessageEx(playerid, COLOR_GRAD1, szMiscArray);
		}
	}
	return 1;
}


/*
CMD:points(playerid, params[]) {

	szMiscArray = "Name\tOwned or Captured By\tType\n{FF0000}Capturable\t{FFFF00}Being Captured by\t{00FF00}Neutral\n";

	for(new i; i < MAX_DYNPOINTS; ++i) {

		if(IsValidDynamicArea(arrPoint[i][po_iAreaID])) {
		// if(arrPoint[i][po_fPos][0] != 0.0) {

			if(GetGVarType("PO_CAPT", i)) {

				format(szMiscArray, sizeof(szMiscArray), "%s{FFFF00}(%d) {FFFF00}%s\t{FFFF00}%s\t{FFFF00}%s\n", szMiscArray, i, arrPoint[i][po_szPointName], arrGroupData[GetGVarInt("PO_CAPT", i)][g_szGroupName], (arrPoint[i][po_iType] == 0) ? ("Weapon Point") : ("Drug Point"));
			}
			else {

				new szGroup[GROUP_MAX_NAME_LEN];

				switch(arrPoint[i][po_iGroupID]) {

					case INVALID_GROUP_ID: szGroup = "None";
					default: strcat(szGroup, arrGroupData[arrPoint[i][po_iGroupID]][g_szGroupName], sizeof(szGroup));
				}

				switch(arrPoint[i][po_iCapturable]) {

					case 0: format(szMiscArray, sizeof(szMiscArray), "%s{00FF00}(%d) {00FF00}%s\t{00FF00}%s\t{00FF00}%s\n", szMiscArray, i, arrPoint[i][po_szPointName], szGroup, (arrPoint[i][po_iType] == 0) ? ("Weapon Point") : ("Drug Point"));
					case 1: format(szMiscArray, sizeof(szMiscArray), "%s{FF0000}(%d) {FF0000}%s\t{FF0000}%s\t{FF0000}%s\n", szMiscArray, i, arrPoint[i][po_szPointName], szGroup, (arrPoint[i][po_iType] == 0) ? ("Weapon Point") : ("Drug Point"));
				}
			}
		}
	}

	ShowPlayerDialogEx(playerid, DIALOG_POINT_LIST, DIALOG_STYLE_TABLIST_HEADERS, "Points", szMiscArray, "<<", "" );
	return 1;
}
*/


CMD:pointtime(playerid, params[]) {

	szMiscArray[0] = 0;
	// szMiscArray = "Name\tTime\n";

	for(new i; i < MAX_DYNPOINTS; ++i) {

		if(GetGVarType("PO_CAPT", i)) {

			format(szMiscArray, sizeof(szMiscArray), "%s {CCCCCC}(%d) {FFFF00}- Being captured by: %s - %d {CCCCCC}minutes.", arrPoint[i][po_szPointName], i, arrGroupData[GetGVarInt("PO_CAPT", i)][g_szGroupName], GetGVarInt("PO_Time", i) + 1);
			SendClientMessage(playerid, COLOR_YELLOW, szMiscArray);
		}
	}
	// ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_TABLIST_HEADERS, "Point Time", szMiscArray, "<<", "");
	return 1;
}

CMD:mypoints(playerid, params[]) {

	if(!IsACriminal(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not in a gang.");
	format(szMiscArray, sizeof(szMiscArray), "SELECT `id`, `traffic`, `revenue` FROM `dynpoints` WHERE `groupid` = '%d'", PlayerInfo[playerid][pMember]);
	mysql_function_query(MainPipeline, szMiscArray, true, "Point_GetPointInfo", "i", playerid);
	return 1;
}

forward Point_GetPointInfo(playerid);
public Point_GetPointInfo(playerid) {

	new iRows,
		iFields;
	iRows = cache_get_row_count(MainPipeline);
	if(!iRows) return SendClientMessageEx(playerid, COLOR_GRAD1, "Your gang does not own any points.");

	new iCount,
		iPointID,
		iTraffic,
		iRevenue;

	cache_get_data(iRows, iFields, MainPipeline);

	while(iCount < iRows) {

		iPointID = cache_get_field_content_int(iCount, "id", MainPipeline);
		iTraffic = cache_get_field_content_int(iCount, "traffic", MainPipeline);
		iRevenue = cache_get_field_content_int(iCount, "revenue", MainPipeline);

		format(szMiscArray, sizeof(szMiscArray), "[Point]: {CCCCCC}(%d) {FFFF00}- Traffic: {CCCCCC}%d people {FFFF00}- Revenue: {CCCCCC}$%s", iPointID - 1, iTraffic, number_format(iRevenue));
		SendClientMessageEx(playerid, COLOR_GREEN, szMiscArray);
		iCount++;
	}
	return 1;
}

CMD:createdpoint(playerid, params[])
{
	//if(!IsAdminLevel(playerid, ADMIN_HEAD)) return 1;
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pGangModerator] < 2 && PlayerInfo[playerid][pFactionModerator] < 2) return 1;

	ShowPlayerDialogEx(playerid, DIALOG_POINT_NAME, DIALOG_STYLE_INPUT, "Create Point | Specify Name", "Please enter a name for the point (max. 32 characters).", "Select", "Cancel");
	return 1;
}

CMD:destroypoint(playerid, params[]) {

	if(PlayerInfo[playerid][pAdmin] < 1337 && PlayerInfo[playerid][pGangModerator] < 2 && PlayerInfo[playerid][pFactionModerator] < 2) return SendClientMessageEx(playerid, COLOR_GRAD1, "You do not have the authority to use this command.");

	new i;
	if(sscanf(params, "d", i)) return SendClientMessageEx(playerid, COLOR_GRAD1, "Usage: /destroypoint [id]");

	if(arrPoint[i][po_fPos][0] == 0.0 && !IsValidDynamicPickup(arrPoint[i][po_iPickupID])) return SendClientMessageEx(playerid, COLOR_GRAD1, "This is not a valid point ID.");
	// if(!IsValidDynamicArea(arrPoint[i][po_iAreaID])) return SendClientMessageEx(playerid, COLOR_GRAD1, "This is not a valid point ID.");

	format(szMiscArray, sizeof(szMiscArray), "UPDATE `dynpoints` SET `groupid` = '-1', `Name` = 'Factory', `timestamp` = '0', `posx` = '0', `posy` = '0', `posz` = '0', \
		`delposx` = '0', `delposy` = '0', `delposz` = '0' WHERE `id` = '%d'", i + 1);
	mysql_function_query(MainPipeline, szMiscArray, false, "PO_OnDeletePoint", "ii", playerid, i);
	return 1;
}

CMD:pointname(playerid, params[]) {

	szMiscArray[0] = 0;

	new i;

	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pGangModerator] < 2 && PlayerInfo[playerid][pFactionModerator] < 2) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot use this command. ");

	if(sscanf(params, "ds[32]", i, szMiscArray)) return SendClientMessageEx(playerid, COLOR_GRAD1, "Usage: /editpoint [id] [name]");

	// if(arrPoint[i][po_fPos][0] == 0.0) return SendClientMessageEx(playerid, COLOR_GRAD1, "You specified an invalid drug point ID.");
	if(!IsValidDynamicPickup(arrPoint[i][po_iPickupID])) return SendClientMessageEx(playerid, COLOR_GRAD1, "You specified an invalid drug point ID.");


	format(arrPoint[i][po_szPointName], MAX_PLAYER_NAME, szMiscArray);

	format(szMiscArray, sizeof(szMiscArray), "You successfully edited Point ID %d's name to: %s.", i, szMiscArray);
	SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);

	new szGroup[GROUP_MAX_NAME_LEN],
		iGroupID = arrPoint[i][po_iGroupID];

	switch(arrPoint[i][po_iGroupID]) {

		case INVALID_GROUP_ID: szGroup = "Nobody";
		default: strcat(szGroup, arrGroupData[iGroupID][g_szGroupName], sizeof(szGroup));
	}

	switch(arrPoint[i][po_iType]) {

		case 0: format(szMiscArray, sizeof(szMiscArray), "Weapon Point {CCCCCC}(ID: %d)\n%s\nOwned by: %s\n{FFFFFF}Press ~k~~CONVERSATION_YES~ to use the point.", i, arrPoint[i][po_szPointName], szGroup);
		case 1: format(szMiscArray, sizeof(szMiscArray), "Drug Point {CCCCCC}(ID: %d)\n%s\nOwned by: %s\n{FFFFFF}Press ~k~~CONVERSATION_YES~ to use the point.", i, arrPoint[i][po_szPointName], szGroup);
	}
	UpdateDynamic3DTextLabelText(arrPoint[i][po_iTextID], COLOR_GREEN, szMiscArray);

	format(szMiscArray, sizeof(szMiscArray), "Delivery Point (ID %d)\n%s", i, arrPoint[i][po_szPointName]);
	UpdateDynamic3DTextLabelText(arrPoint[i][po_iDelTextID], COLOR_GRAD1, szMiscArray);

	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "UPDATE `dynpoints` SET `name` = '%e' WHERE `id` = '%d'", arrPoint[i][po_szPointName], i + 1);
	mysql_function_query(MainPipeline, szMiscArray, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	return 1;
}

CMD:editpoint(playerid, params[]) {

	szMiscArray[0] = 0;

	new szChoice[16],
		i,
		Float:fPos[3];

	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pGangModerator] < 2 && PlayerInfo[playerid][pFactionModerator] < 2) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot use this command. ");

	if(sscanf(params, "s[16]dD", szChoice, i, szMiscArray)) return SendClientMessageEx(playerid, COLOR_GRAD1, "Usage: /editpoint [choice] [id] [value] | Available: 'position', 'deliverpos', 'name', 'capturable'");

	// if(arrPoint[i][po_fPos][0] == 0.0) return SendClientMessageEx(playerid, COLOR_GRAD1, "You specified an invalid drug point ID.");
	if(!IsValidDynamicPickup(arrPoint[i][po_iPickupID])) return SendClientMessageEx(playerid, COLOR_GRAD1, "You specified an invalid drug point ID.");

	if(strcmp(szChoice, "position", true) == 0) {

		if(GetPlayerVirtualWorld(playerid) > 0 || GetPlayerInterior(playerid) > 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "Your virtual world and interior must be 0.");

		PO_DestroyPoint(i);
		GetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]);
		arrPoint[i][po_fPos][0] = fPos[0];
		arrPoint[i][po_fPos][1] = fPos[1];
		arrPoint[i][po_fPos][2] = fPos[2];
		PO_CreatePoint(i, arrPoint[i][po_fPos][0], arrPoint[i][po_fPos][1], arrPoint[i][po_fPos][2],
			arrPoint[i][po_fPos][0], arrPoint[i][po_fPos][1], arrPoint[i][po_fPos][2]);

		format(szMiscArray, sizeof(szMiscArray), "You successfully moved Point ID %d to your position.", i);
		SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
		format(szMiscArray, sizeof(szMiscArray), "UPDATE `dynpoints` SET `posx` = '%f', `posy` = '%f', `posz` = '%f', `vw` = '%d', `int` = '%d' WHERE `id` = '%d'", fPos[0], fPos[1], fPos[2], 0, 0, i + 1);
		mysql_function_query(MainPipeline, szMiscArray, false, "OnQueryFinish", "i", SENDDATA_THREAD);
		return 1;
	}
	if(strcmp(szChoice, "deliverpos", true) == 0) {

		if(GetPlayerVirtualWorld(playerid) > 0 || GetPlayerInterior(playerid) > 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "Your virtual world and interior must be 0.");

		GetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]);

		if(IsValidDynamic3DTextLabel(arrPoint[i][po_iDelTextID])) DestroyDynamic3DTextLabel(arrPoint[i][po_iDelTextID]);

		format(szMiscArray, sizeof(szMiscArray), "Delivery Point (ID %d)\n%s", i, arrPoint[i][po_szPointName]);
		arrPoint[i][po_iDelTextID] = CreateDynamic3DTextLabel(szMiscArray, COLOR_GRAD1, fPos[0], fPos[1], fPos[2], 10.0);

		format(szMiscArray, sizeof(szMiscArray), "You successfully edited Point ID %d's delivery point to your position.", i);
		SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);

		format(szMiscArray, sizeof(szMiscArray), "UPDATE `dynpoints` SET `delposx` = '%f', `delposy` = '%f', `delposz` = '%f' WHERE `id` = '%d'", fPos[0], fPos[1], fPos[2], i + 1);
		mysql_function_query(MainPipeline, szMiscArray, false, "OnQueryFinish", "i", SENDDATA_THREAD);
		return 1;
	}
	if(strcmp(szChoice, "capturable", true) == 0) {

		arrPoint[i][po_iCapturable] = 1;
		format(szMiscArray, sizeof(szMiscArray), "UPDATE `dynpoints` SET `capturable` = '1' WHERE `id` = '%d'", i + 1);
		mysql_function_query(MainPipeline, szMiscArray, false, "OnQueryFinish", "i", SENDDATA_THREAD);
		return 1;
	}
	SendClientMessageEx(playerid, COLOR_GRAD1, "You specified an invalid choice.");
	return 1;
}

Point_GetPointID(playerid) {

	/*
	if(IsPlayerInAnyDynamicArea(playerid)) {
		
		new areaid[1];
		GetPlayerDynamicAreas(playerid, areaid);
		for(new i; i < MAX_DYNPOINTS; ++i) {

			if(areaid[0] == arrPoint[i][po_iAreaID]) return i;
		}
	}
	*/
	for(new i; i < MAX_DYNPOINTS; ++i) {
		if(IsPlayerInRangeOfPoint(playerid, 2.0, arrPoint[i][po_fPos][0], arrPoint[i][po_fPos][1], arrPoint[i][po_fPos][2]) && PlayerInfo[playerid][pVW] == 0) return i;
	}
	return -1;
}

CMD:capturepoint(playerid, params[]) {
	SendClientMessageEx(playerid, COLOR_GRAD1, "You can also use /capture for this command.");
	return cmd_capture(playerid, params);
}

CMD:capture(playerid, params[]) {

	if (!IsACriminal(playerid) || PlayerInfo[playerid][pRank] < arrGroupData[PlayerInfo[playerid][pMember]][g_iPointCapRank]) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to capture a point.");

	if(GetPVarInt(playerid,"Injured") == 1) return SendClientMessageEx(playerid, COLOR_GRAD1, "You can not capture while injured!");

	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot be in a vehicle when attempting to capture a point.");

	new i;
	i = Point_GetPointID(playerid);

	if(i == -1) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not at a point.");

	if(arrPoint[i][po_iCapturable] == 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "This point isn't capturable.");
	if(GetPVarType(playerid, "PO_CAPTUR")) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are already capturing a point.");
	for(new j; j < MAX_DYNPOINTS; ++j) {
		if(GetGVarInt("PO_CAPT", j) == PlayerInfo[playerid][pMember]) return SendClientMessageEx(playerid, COLOR_GRAD1, "Your gang is already capturing a point.");
	}
	if(GetGVarType("PO_CAPT", i)) {

		new iGroupID = GetGVarInt("PO_CAPT", i);
		if(PlayerInfo[playerid][pMember] == iGroupID) return SendClientMessageEx(playerid, COLOR_GRAD1, "Someone in your gang is already capturing this point.");
		foreach(new p : Player) {
			if(PlayerInfo[p][pMember] == iGroupID) {
				SendClientMessageEx(p, COLOR_YELLOW, "Another gang leader is attempting to capture your point.");
			}
		}
	}

	new Float:fPos[3];

	GetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]);
	SetPVarFloat(playerid, "X", fPos[0]);
	SetPVarFloat(playerid, "Y", fPos[1]);
	SetPVarFloat(playerid, "Z", fPos[2]);

	SetPVarInt(playerid, "PO_CAPTUR", i);
	format(szMiscArray, sizeof(szMiscArray), "You are attempting to capture %s.", arrPoint[i][po_szPointName]);
	SendClientMessage(playerid, COLOR_YELLOW, szMiscArray);

	defer Point_Capture(playerid, i, PlayerInfo[playerid][pMember]);
	return 1;
}

Smuggle_VehicleLoad(playerid, iVehID)
{
	new iTotalAmount;

	szMiscArray = "Ingredient\tAmount in vehicle\n";

	for(new i; i < sizeof(szIngredients); ++i) {

		if(arrSmuggleVehicle[iVehID][smv_iIngredientAmount][i] > 0) {

			format(szMiscArray, sizeof(szMiscArray), "%s%s\t%d\n", szMiscArray, szIngredients[i], arrSmuggleVehicle[iVehID][smv_iIngredientAmount][i]);
			iTotalAmount += arrSmuggleVehicle[iVehID][smv_iIngredientAmount][i];
		}
	}

	if(iTotalAmount == 0) {
		szMiscArray[0] = 0;
		szMiscArray = "Drugs\tAmount in vehicle\n";
		for(new i; i < sizeof(szDrugs); ++i) {

			if(PlayerVehicleInfo[playerid][iVehID][pvDrugs][i] > 0) {

				format(szMiscArray, sizeof(szMiscArray), "%s%s\t%d\n", szMiscArray, szDrugs[i], PlayerVehicleInfo[playerid][iVehID][pvDrugs][i]);
				iTotalAmount += PlayerVehicleInfo[playerid][iVehID][pvDrugs][i];
			}
		}
		if(iTotalAmount == 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "There are no drugs in this vehicle.");
	}
	ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_TABLIST_HEADERS, "Vehicle | Drug Packages", szMiscArray, "Select", "");

	format(szMiscArray, sizeof(szMiscArray), "_________ %s | Drugs Stored _________", GetVehicleName(iVehID));
	SendClientMessageEx(playerid, COLOR_GREEN, szMiscArray);
	format(szMiscArray, sizeof(szMiscArray), "Total amount: %d pieces.", iTotalAmount);
	SendClientMessageEx(playerid, COLOR_GRAD1, szMiscArray);
	SendClientMessageEx(playerid, COLOR_GREEN, "_______________________________________________");
	return 1;
}

Smuggle_GetVehicleCapacity(iVehID) {

	new Float:fPos[3];
	GetVehicleModelInfo(GetVehicleModel(iVehID), VEHICLE_MODEL_INFO_SIZE, fPos[0], fPos[1], fPos[2]);
	fPos[0] = (fPos[0] + fPos[1] + fPos[2]) * 3; // size to drug permutation
	new iAmount = floatround(fPos[0], floatround_round);
	if(iAmount > 80) iAmount = 80;
	return iAmount;
}

Smuggle_GetSmuggleCapacity(playerid) {

	new i = PlayerInfo[playerid][pSmugSkill] + 20;
	if(i > 400) i = 400;
	return i;
}

Smuggle_LoadIngredients(playerid)
{
	new iVehID = GetPlayerVehicleID(playerid);

	format(szMiscArray, sizeof(szMiscArray), "Ingredient\tAmount in vehicle\n{DDDDDD}Vehicle capacity: {FFFF00}%dpc\t{DDDDDD}Smuggle level capacity: {FFFF00}%dpc{DDDDDD} -- TOTAL: %d\n", Smuggle_GetVehicleCapacity(iVehID), Smuggle_GetSmuggleCapacity(playerid), Smuggle_GetVehicleCapacity(iVehID) + Smuggle_GetSmuggleCapacity(playerid));

	for(new i; i < sizeof(szIngredients); ++i) {

		format(szMiscArray, sizeof(szMiscArray), "%s%s\t%d\n", szMiscArray, szIngredients[i], arrSmuggleVehicle[iVehID][smv_iIngredientAmount][i]);
	}

	strins(szMiscArray, "\n---------------\nStart Smuggle", strlen(szMiscArray), strlen(szMiscArray)+1);

	ShowPlayerDialogEx(playerid, DIALOG_SMUGGLE_PREPARE, DIALOG_STYLE_TABLIST_HEADERS, "Smuggle | Prepare Package", szMiscArray, "Select", "");
	return 1;
}

Smuggle_GetBMDelPos(playerid) {

	new iDialogCount;

	szMiscArray = "Black Market\tPay\n";

	for(new i; i < MAX_BLACKMARKETS; ++i) {

		if(IsValidDynamicPickup(arrBlackMarket[i][bm_iPickupID]) && arrBlackMarket[i][bm_iSeized] == 0) {

			format(szMiscArray, sizeof(szMiscArray), "%s%s\t$%s\n", szMiscArray, arrGroupData[arrBlackMarket[i][bm_iGroupID]][g_szGroupName], number_format(BM_SmugglePayment(playerid, i)));
			ListItemTrackId[playerid][iDialogCount] = i;
			iDialogCount++;
		}
	}
	ShowPlayerDialogEx(playerid, DIALOG_SMUGGLE_BMDELPOINT, DIALOG_STYLE_TABLIST_HEADERS, "Black Markets | Where do you want to deliver to?", szMiscArray, "Select", "");
	return 1;
}

BM_SmugglePayment(playerid, iBlackMarketID, iExtra = 0) {

	new iVehID = GetPlayerVehicleID(playerid),
		iPrice;

	for(new i; i < sizeof(szIngredients); ++i) {

		if(arrSmuggleVehicle[iVehID][smv_iIngredientAmount][i] > 0)	{

			iPrice += (arrSmuggleVehicle[iVehID][smv_iIngredientAmount][i] * arrBlackMarket[iBlackMarketID][bm_iIngredientSmugglePay][i]);
		}
	}
	if(iExtra == 1) SetPVarInt(playerid, "BM_PAY", iPrice);
	return iPrice;
}

Smuggle_StartSmuggle(playerid, iBlackMarketID = -1) {

	new Float:fPos[3],
		iVehID = GetPlayerVehicleID(playerid);


	SetPVarInt(playerid, "Smuggling", 1);

	if(GetPVarType(playerid, "hFind")) {
   		SendClientMessageEx(playerid, COLOR_GRAD2, "Hfind has been toggled whilst you drug run!");
        DeletePVar(playerid, "hFind");
        DisablePlayerCheckpoint(playerid);
	}

	if(iBlackMarketID > -1) {

		Streamer_GetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, arrBlackMarket[iBlackMarketID][bm_iDelTextID], E_STREAMER_X, fPos[0]);
		Streamer_GetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, arrBlackMarket[iBlackMarketID][bm_iDelTextID], E_STREAMER_Y, fPos[1]);
		Streamer_GetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, arrBlackMarket[iBlackMarketID][bm_iDelTextID], E_STREAMER_Z, fPos[2]);

		foreach(new i : Player) if(GetPlayerVehicleID(i) == iVehID) SetPlayerCheckpoint(i, fPos[0], fPos[1], fPos[2], 10.0);

		gPlayerCheckpointStatus[playerid] = CHECKPOINT_SMUGGLE_BLACKMARKET;

		SetPVarInt(playerid, PVAR_SMUGGLE_DELIVERINGTO, iBlackMarketID);

		BM_SmugglePayment(playerid, iBlackMarketID, 1);
	}
	else {

		new iPointID = GetPVarInt(playerid, PVAR_ATDRUGPOINT);

		Streamer_GetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, arrPoint[iPointID][po_iDelTextID], E_STREAMER_X, fPos[0]);
		Streamer_GetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, arrPoint[iPointID][po_iDelTextID], E_STREAMER_Y, fPos[1]);
		Streamer_GetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, arrPoint[iPointID][po_iDelTextID], E_STREAMER_Z, fPos[2]);

		foreach(new i : Player) if(GetPlayerVehicleID(i) == iVehID) SetPlayerCheckpoint(i, fPos[0], fPos[1], fPos[2], 10.0);

		gPlayerCheckpointStatus[playerid] = CHECKPOINT_SMUGGLE_PLAYER;
	}
	SetPVarInt(playerid, "RunTS", gettime());
	SendClientMessageEx(playerid, COLOR_GREEN, "[Drug Smuggle] {CCCCCC}You started your drug smuggle. Make your way to the delivery point.");
	return 1;
}

Point_FinalizeCapture(i) {

	DeleteGVar("PO_CAPT", i);
	DeleteGVar("PO_Time", i);
	return 1;
}

timer PO_PointTimer[60000 * 10](playerid, i, iGroupID) {

	if(!GetGVarType("PO_CAPT", i)) return Point_FinalizeCapture(i);
	if(GetGVarInt("PO_CAPT", i) != iGroupID) return 1;

	Point_FinalizeCapture(i);

	GangZoneHideForAll(arrPoint[i][po_iZoneID]);
	
	/*
	new Float:fPos[3];
	Streamer_GetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, arrPoint[i][po_iTextID], E_STREAMER_X, fPos[0]);
	Streamer_GetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, arrPoint[i][po_iTextID], E_STREAMER_Y, fPos[1]);
	Streamer_GetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, arrPoint[i][po_iTextID], E_STREAMER_Z, fPos[2]);
	*/

	if(GetPlayerVirtualWorld(playerid) != 0) {

		format(szMiscArray, sizeof(szMiscArray), "{AA3333}AdmWarning{FFFF00}: %s (ID %d) may have possibly desynced himself to capture a point.", GetPlayerNameEx(playerid), playerid);
		ABroadCast(COLOR_YELLOW, szMiscArray, 2);
		foreach(new p : Player) if(PlayerInfo[p][pMember] == iGroupID) {

			SendClientMessageEx(p, COLOR_YELLOW, "You failed to capture the point.");
			TextDrawHideForPlayer(p, PointTime);
		}
		DeletePVar(playerid, "PO_CAPTUR");
		return 1;
	}

	DeletePVar(playerid, "PO_CAPTUR");
	
	format(szMiscArray, sizeof(szMiscArray), "%s has successfully captured %s for %s.", GetPlayerNameEx(playerid), arrPoint[i][po_szPointName], arrGroupData[iGroupID][g_szGroupName]);
	foreach(new p : Player) {
		ChatTrafficProcess(p, COLOR_YELLOW, szMiscArray, 22);
		if(PlayerInfo[p][pMember] == iGroupID) TextDrawHideForPlayer(p, PointTime);
	}

	arrPoint[i][po_iGroupID] = iGroupID;
	arrPoint[i][po_iCapturable] = 0;
	format(szMiscArray, sizeof(szMiscArray), "UPDATE `dynpoints` SET `capturable` = '0', `groupid` = '%d', `timestamp` = '%d' WHERE `id` = '%d'", iGroupID, gettime() + 14400, i + 1);
	mysql_function_query(MainPipeline, szMiscArray, false, "OnQueryFinish", "i", SENDDATA_THREAD);

	new szGroup[GROUP_MAX_NAME_LEN];

	switch(arrPoint[i][po_iGroupID]) {

		case INVALID_GROUP_ID: szGroup = "Nobody";
		default: strcat(szGroup, arrGroupData[iGroupID][g_szGroupName], sizeof(szGroup));
	}

	switch(arrPoint[i][po_iType]) {

		case 0: format(szMiscArray, sizeof(szMiscArray), "Weapon Point {CCCCCC}(ID: %d)\n%s\nOwned by: %s\n{FFFFFF}Press ~k~~CONVERSATION_YES~ to use the point.", i, arrPoint[i][po_szPointName], szGroup);
		case 1: format(szMiscArray, sizeof(szMiscArray), "Drug Point {CCCCCC}(ID: %d)\n%s\nOwned by: %s\n{FFFFFF}Press ~k~~CONVERSATION_YES~ to use the point.", i, arrPoint[i][po_szPointName], szGroup);
	}

	UpdateDynamic3DTextLabelText(arrPoint[i][po_iTextID], COLOR_GREEN, szMiscArray);

	format(szMiscArray, sizeof(szMiscArray), "Delivery Point (ID: %d)\n\n%s", i, arrPoint[i][po_szPointName]);
	UpdateDynamic3DTextLabelText(arrPoint[i][po_iDelTextID], COLOR_GRAD1, szMiscArray);

	Point_ResetUsage(i); // Reset point traffic and revenue.
	return 1;
}

forward PO_OnCreatePoint(playerid, i);
public PO_OnCreatePoint(playerid, i) {

	format(szMiscArray, sizeof(szMiscArray), "You have successfully created a point with ID %d", i);
	SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
	SendClientMessageEx(playerid, COLOR_GRAD1, "Make sure to also set up a delivery point! Use '/editpoint deliverpos' to set it up.");
	return 1;
}

forward PO_OnDeletePoint(playerid, i);
public PO_OnDeletePoint(playerid, i) {

	format(szMiscArray, sizeof(szMiscArray), "[Point] - {DDDDDD}You have successfully deleted point ID %d", i);
	SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
	PO_DestroyPoint(i);
	return 1;
}


PO_LoadPoints() {

	mysql_function_query(MainPipeline, "SELECT * FROM `dynpoints`", true, "PO_OnLoadPoints", "");
}

forward PO_OnLoadPoints();
public PO_OnLoadPoints() {

	new iRows = cache_get_row_count(MainPipeline);
	if(!iRows) return print("[Points] No points were found in the database.");

	new iFields,
		iCount;

	cache_get_data(iRows, iFields, MainPipeline);

	while(iCount < iRows)
	{
		new Float:fPos[3];

		arrPoint[iCount][po_fPos][0] = cache_get_field_content_float(iCount, "posx", MainPipeline);
		arrPoint[iCount][po_fPos][1] = cache_get_field_content_float(iCount, "posy", MainPipeline);
		arrPoint[iCount][po_fPos][2] = cache_get_field_content_float(iCount, "posz", MainPipeline);
		fPos[0] = cache_get_field_content_float(iCount, "delposx", MainPipeline);
		fPos[1] = cache_get_field_content_float(iCount, "delposy", MainPipeline);
		fPos[2] = cache_get_field_content_float(iCount, "delposz", MainPipeline);
		arrPoint[iCount][po_iGroupID] = cache_get_field_content_int(iCount, "groupid", MainPipeline);
		arrPoint[iCount][po_iCapturable] = cache_get_field_content_int(iCount, "capturable", MainPipeline);
		arrPoint[iCount][po_iType] = cache_get_field_content_int(iCount, "type", MainPipeline);

		cache_get_field_content(iCount, "name", arrPoint[iCount][po_szPointName], MainPipeline, MAX_PLAYER_NAME);

		PO_CreatePoint(iCount, arrPoint[iCount][po_fPos][0], arrPoint[iCount][po_fPos][1], arrPoint[iCount][po_fPos][2], fPos[0], fPos[1], fPos[2], 1);
		iCount++;
	}
	printf("[Points] Loaded %d points.", iCount);
	return 1;
}

PO_CreatePoint(i, Float:X, Float:Y, Float:Z, Float:DX = 0.0, Float:DY = 0.0, Float:DZ = 0.0, sql = 0) {

	if(X == 0 && Y == 0) return 1;

	if(!sql) { // X, Y will remain until streamer bug has been found - Jingles.
		X += 0.0;
		Y += 0.0;
		Z -= 1.0; // Somehow has an odd Z-offset.
	}

	Iter_Add(Points, i);
	switch(arrPoint[i][po_iType]) {
		case 0: arrPoint[i][po_iPickupID] = CreateDynamicPickup(355, 1, arrPoint[i][po_fPos][0], arrPoint[i][po_fPos][1], arrPoint[i][po_fPos][2], .worldid = 0, .interiorid = 0, .streamdistance = 20.0);
		case 1: arrPoint[i][po_iPickupID] = CreateDynamicPickup(1279, 1, arrPoint[i][po_fPos][0], arrPoint[i][po_fPos][1], arrPoint[i][po_fPos][2], .worldid = 0, .interiorid = 0, .streamdistance = 20.0);
	}

	new szGroup[GROUP_MAX_NAME_LEN],
		iGroupID = arrPoint[i][po_iGroupID];

	switch(arrPoint[i][po_iGroupID]) {

		case INVALID_GROUP_ID: szGroup = "Nobody";
		default: strcat(szGroup, arrGroupData[iGroupID][g_szGroupName], sizeof(szGroup));
	}

	switch(arrPoint[i][po_iType]) {

		case 0: format(szMiscArray, sizeof(szMiscArray), "Weapon Point {CCCCCC}(ID: %d)\n%s\nOwned by: %s\n{FFFFFF}Press ~k~~CONVERSATION_YES~ to use the point.", i, arrPoint[i][po_szPointName], szGroup);
		case 1: format(szMiscArray, sizeof(szMiscArray), "Drug Point {CCCCCC}(ID: %d)\n%s\nOwned by: %s\n{FFFFFF}Press ~k~~CONVERSATION_YES~ to use the point.", i, arrPoint[i][po_szPointName], szGroup);
	}

	arrPoint[i][po_iTextID] = CreateDynamic3DTextLabel(szMiscArray, COLOR_GREEN, arrPoint[i][po_fPos][0], arrPoint[i][po_fPos][1], arrPoint[i][po_fPos][2] + 1.0, 10.0, .worldid = 0, .interiorid = 0);

	if(DX != 0) {
		DestroyDynamic3DTextLabel(arrPoint[i][po_iDelTextID]);
		format(szMiscArray, sizeof(szMiscArray), "{DDDDDD}Delivery Point {AAAAAA}(ID: %d)\n%s\nOwned by: %s", i, arrPoint[i][po_szPointName], szGroup);
		arrPoint[i][po_iDelTextID] = CreateDynamic3DTextLabel(szMiscArray, COLOR_GREEN, DX, DY, DZ, 10.0, .worldid = 0, .interiorid = 0);
	}

	// arrPoint[i][po_iAreaID] = CreateDynamicSphere(arrPoint[i][po_fPos][0], arrPoint[i][po_fPos][1], arrPoint[i][po_fPos][2], 2.0);
	//Streamer_SetIntData(STREAMER_TYPE_AREA, arrPoint[i][po_iAreaID], E_STREAMER_EXTRA_ID, i);

	arrPoint[i][po_iBigAreaID] = CreateDynamicSphere(arrPoint[i][po_fPos][0], arrPoint[i][po_fPos][1], arrPoint[i][po_fPos][2], 100.0);
	// Streamer_SetIntData(STREAMER_TYPE_AREA, arrPoint[i][po_iBigAreaID], E_STREAMER_EXTRA_ID, i);

	arrPoint[i][po_iZoneID] = GangZoneCreate(arrPoint[i][po_fPos][0] - 100.0, arrPoint[i][po_fPos][1] - 100.0, arrPoint[i][po_fPos][0] + 100.0, arrPoint[i][po_fPos][1] + 100.0);
	return 1;
}

PO_DestroyPoint(i) {

	arrPoint[i][po_iGroupID] = INVALID_GROUP_ID;
	arrPoint[i][po_iCapturable] = 0;
	arrPoint[i][po_fPos][0] = 0.0;
	arrPoint[i][po_fPos][1] = 0.0;
	arrPoint[i][po_fPos][2] = 0.0;

	DestroyDynamicPickup(arrPoint[i][po_iPickupID]);
	DestroyDynamic3DTextLabel(arrPoint[i][po_iTextID]);
	DestroyDynamic3DTextLabel(arrPoint[i][po_iDelTextID]);
	// DestroyDynamicArea(arrPoint[i][po_iAreaID]);
	DestroyDynamicArea(arrPoint[i][po_iBigAreaID]);
	GangZoneDestroy(arrPoint[i][po_iZoneID]);
	Iter_Remove(Points, i);

	format(szMiscArray, sizeof(szMiscArray), "UPDATE `dynpoints` SET `type` = '0', `name` = 'Factory', `capturable` = '0', `timestamp` = '0', `groupid` = '-1', \
		`posx` = '0.0', `posy` = '0.0', `posz` = '0.0', `delposx` = '0.0', `delposy` = '0.0', `delposz` = '0.0'");
	mysql_function_query(MainPipeline, szMiscArray, false, "OnQueryFinish", "i", SENDDATA_THREAD);
}

/*
PO_RehashPoint(i) {

		new Float:fPos[6];

		Streamer_GetFloatData(STREAMER_TYPE_AREA, arrPoint[i][po_iAreaID], E_STREAMER_X, fPos[0]);
		Streamer_GetFloatData(STREAMER_TYPE_AREA, arrPoint[i][po_iAreaID], E_STREAMER_Y, fPos[1]);
		Streamer_GetFloatData(STREAMER_TYPE_AREA, arrPoint[i][po_iAreaID], E_STREAMER_Z, fPos[2]);
		Streamer_GetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, arrPoint[i][po_iDelTextID], E_STREAMER_X, fPos[3]);
		Streamer_GetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, arrPoint[i][po_iDelTextID], E_STREAMER_Y, fPos[4]);
		Streamer_GetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, arrPoint[i][po_iDelTextID], E_STREAMER_Z, fPos[5]);

		PO_DestroyPoint(i);
		PO_CreatePoint(i, fPos[0], fPos[1], fPos[2], fPos[3], fPos[4], fPos[5]);
}
*/

CMD:drughelp(playerid, params[]) {

	SendClientMessageEx(playerid, COLOR_GREEN, "__________ [Drug System] __________");
	SendClientMessageEx(playerid, COLOR_GRAD1, "/mydrugs | /usedrug | /dropdrug | /plantseeds | /myplants");
	SendClientMessageEx(playerid, COLOR_GRAD1, "/myingredients | /dropingredient | /orderingredient");
	SendClientMessageEx(playerid, COLOR_GRAD1, "/mymix | /mix | /clearmix");
	SendClientMessageEx(playerid, COLOR_GRAD1, "/blackmarket | /gblackmarket | /mypostorders | /getpostorder");
	if(IsACop(playerid) || IsAMedic(playerid)) SendClientMessageEx(playerid, COLOR_LIGHTRED, "[MEDIC/LEA] | /listpostorders | /searchcar");
	if(IsAdminLevel(playerid, ADMIN_JUNIOR, 0)) SendClientMessageEx(playerid, COLOR_YELLOW, "[Administrators] /createblackmarket | /ablackmarket | /createdpoint | /editpoint | /points");
	SendClientMessageEx(playerid, COLOR_GREEN, "_______________________________________________________");
	szMiscArray[0] = 0;

	strcat(szMiscArray, "You can use drugs by using /usedrug [drug name] [amount]. You will first have to make a drug by mixing ingredients.\n", sizeof(szMiscArray));
	strcat(szMiscArray, "You can obtain ingredients by doing drug smuggles.\n\nMake your way to a drug point to start a smuggle.", sizeof(szMiscArray));
	strcat(szMiscArray, "You will need to be in a vehicle to load ingredients.\n", sizeof(szMiscArray));
	strcat(szMiscArray, "The max capacity depends on your drug smuggle skill and vehicle size.\n\n\n", sizeof(szMiscArray));
	strcat(szMiscArray, "You can also deliver to a gang's black market. They can specify a payment if you deliver the ingredients to their black market.\n", sizeof(szMiscArray));
	strcat(szMiscArray, "If you deliver the the delivery point, the smuggle will go to your inventory.\n", sizeof(szMiscArray));
	ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Drug System Help", szMiscArray, "<<", "");
	return 1;
}

CMD:pointhelp(playerid, params[]) {

	SendClientMessageEx(playerid, COLOR_GREEN, "__________ [Point System] __________");
	SendClientMessageEx(playerid, COLOR_GRAD1, "/points | /capture | /mypoints");
	if(IsAdminLevel(playerid, ADMIN_JUNIOR, 0)) SendClientMessageEx(playerid, COLOR_YELLOW, "[Administrators] /createdpoint | /editpoint |/destroypoint | /points");
	SendClientMessageEx(playerid, COLOR_GREEN, "_______________________________________________________");
	szMiscArray[0] = 0;

	strcat(szMiscArray, "You can obtain ingredients or materials by doing drug or weapon smuggles.\n\nMake your way to a drug or weapon point to start a drug or material smuggle.", sizeof(szMiscArray));
	strcat(szMiscArray, "You will need to be in a vehicle to load ingredients or materials.\n", sizeof(szMiscArray));
	strcat(szMiscArray, "The drug smugle capacity depends on your drug smuggle skill + vehicle size.\n\n\n", sizeof(szMiscArray));
	strcat(szMiscArray, "You can also deliver to a gang's black market. They can specify a payment if you deliver the ingredients to their black market.\n", sizeof(szMiscArray));
	strcat(szMiscArray, "If you deliver the the delivery point, the smuggle will go to your inventory.\n", sizeof(szMiscArray));
	ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Point System Help", szMiscArray, "<<", "");
	return 1;
}

Drugs_ODTextDraw() {

	ODTextDraw = TextDrawCreate(-41.000000, 0.000000, "New Textdraw");
	TextDrawBackgroundColor(ODTextDraw, 255);
	TextDrawFont(ODTextDraw, 1);
	TextDrawLetterSize(ODTextDraw, 3.199999, 59.000000);
	TextDrawColor(ODTextDraw, 0);
	TextDrawSetOutline(ODTextDraw, 0);
	TextDrawSetProportional(ODTextDraw, 1);
	TextDrawSetShadow(ODTextDraw, 0);
	TextDrawUseBox(ODTextDraw, 1);
	TextDrawBoxColor(ODTextDraw, 167772380);
	TextDrawTextSize(ODTextDraw, 770.000000, 51.000000);
	TextDrawSetSelectable(ODTextDraw, 0);
}

/* Alien Easter Egg */

hook OnGameModeInit() {

	EasterEgg_Aliens();

	PointTime = TextDrawCreate(547.000000,28.000000,"--");
	TextDrawFont(PointTime, 3);
	TextDrawLetterSize(PointTime, 0.399999, 1.600000);
	TextDrawColor(PointTime, 0xffffffff);
	return 1;
}

hook OnPlayerGiveDamageActor(playerid, damaged_actorid, Float: amount, weaponid, bodypart) {

	new Float:fHealth;

	GetActorHealth(damaged_actorid, fHealth);

	foreach(new i : Player) {

		if(!GetPVarType(i, PVAR_TEMPACTOR)) continue;
		if(GetPVarInt(i, PVAR_TEMPACTOR) == damaged_actorid) {

			if(GetPVarType(i, "Aliens")) {

				SetHealth(i, fHealth);
				// Character_Actor(i, 1);
				Aliens_ResetPlayer(i);
			}
		}
	}
	return 1;
}

hook OnPlayerEnterDynamicArea(playerid, areaid) {

	for(new i; i < MAX_DYNPOINTS; ++i) {

		if(areaid == arrPoint[i][po_iBigAreaID] && GetGVarInt("PO_CAPT", i)) {
			SendClientMessageEx(playerid, COLOR_YELLOW, "[Point]: You have entered an active OOC point.");
		}
	}
	return 1;
}

timer Ufo_Aliens[500](playerid) {

	new stage = GetPVarInt(playerid, "Aliens");

	switch(stage) {

		case 0: {

			new Float:fPos[3];
			GetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]);
			SetPVarFloat(playerid, "PX", fPos[0]);
			SetPVarFloat(playerid, "PY", fPos[1]);
			SetPVarFloat(playerid, "PZ", fPos[2]);
			SetPlayerWeather(playerid, 15);
			PlayAudioStreamForPlayer(playerid, "http://jingles.ml/audio/starwars.mp3");
			// ClearChatbox(playerid);
			SendClientMessage(playerid, COLOR_GREEN, "[Aliens]: {DDDDDD}Greetings, Earthling... You are the chosen one... Come with us, fair creature... To a better place...");
			// Character_Actor(playerid, 0);
			SetPlayerVirtualWorld(playerid, 100);
		}
		case 8: {

			new Float:fPos[3];
			GetPlayerCameraPos(playerid, fPos[0], fPos[1], fPos[2]);
			InterpolateCameraPos(playerid, fPos[0], fPos[1], fPos[2], fPos[0] + 90.0, fPos[1] + 80.0, fPos[2] + 45.0, 8000, CAMERA_MOVE);
			SetPlayerDrunkLevel(playerid, 3000);
		}
		case 40: {

			SetPlayerWeather(playerid, 0);
			SetPlayerTime(playerid, 3, 0);

			Player_StreamPrep(playerid, 342.4695, 162.9769, 1321.8794, FREEZE_TIME);
			Streamer_Update(playerid);
			SetCameraBehindPlayer(playerid);
			SetPlayerSpecialAction(playerid, 5);
			PlayAudioStreamForPlayer(playerid, "http://jingles.ml/audio/boogie.mp3");
			// ClearChatbox(playerid);
		}
		case 80: {

			Aliens_ResetPlayer(playerid);
			return 1;
		}
	}
	if(stage < 40) SetPlayerVelocity(playerid, 0.0, 0.0, 1.1);
	stage++;
	SetPVarInt(playerid, "Aliens", stage);
	if(GetPVarType(playerid, "Aliens")) defer Ufo_Aliens(playerid);
	return 1;
}

Aliens_ResetPlayer(playerid) {

	// Character_Actor(playerid, 1);
	SetPlayerPos(playerid, GetPVarFloat(playerid, "PX"), GetPVarFloat(playerid, "PY"), GetPVarFloat(playerid, "PZ"));
	SetPlayerVirtualWorld(playerid, 0);
	DeletePVar(playerid, "PX");
	DeletePVar(playerid, "PY");
	DeletePVar(playerid, "PZ");
	DeletePVar(playerid, "Aliens");
	Ufo_DestroyUfo(playerid);
	ClearAnimations(playerid, 1);
	StopAudioStreamForPlayer(playerid);
}

EasterEgg_Aliens() {

	new i = CreateActor(ALIEN_ACTORMODEL, 341.3365, 159.0100, 1324.5111, random(360));
	ApplyActorAnimation(i, "DANCING", "dance_loop", 4.0, 1, 0, 0, 1, 0);
	SetActorVirtualWorld(i, 100);
	i = CreateActor(ALIEN_ACTORMODEL, 332.4268, 157.1670, 1324.2773, random(360));
	ApplyActorAnimation(i, "DANCING", "dance_loop", 4.0, 1, 0, 0, 1, 0);
	SetActorVirtualWorld(i, 100);
	i = CreateActor(ALIEN_ACTORMODEL, 332.4458, 170.4236, 1323.4000, random(360));
	ApplyActorAnimation(i, "DANCING", "dance_loop", 4.0, 1, 0, 0, 1, 0);
	SetActorVirtualWorld(i, 100);
	i = CreateActor(ALIEN_ACTORMODEL, 340.7448, 170.2712, 1322.4946, random(360));
	ApplyActorAnimation(i, "DANCING", "dance_loop", 4.0, 1, 0, 0, 1, 0);
	SetActorVirtualWorld(i, 100);
	i = CreateActor(ALIEN_ACTORMODEL, 339.7888, 163.5347, 1322.7216, random(360));
	ApplyActorAnimation(i, "DANCING", "dance_loop", 4.0, 1, 0, 0, 1, 0);
	SetActorVirtualWorld(i, 100);
	i = CreateActor(ALIEN_ACTORMODEL, 341.3365, 159.0100, 1324.5111, random(360));
	ApplyActorAnimation(i, "DANCING", "dance_loop", 4.0, 1, 0, 0, 1, 0);
	SetActorVirtualWorld(i, 100);
	i = CreateActor(ALIEN_ACTORMODEL, 340.5054, 168.3707, 1322.0000, random(360));
	ApplyActorAnimation(i, "DANCING", "dance_loop", 4.0, 1, 0, 0, 1, 0);
	SetActorVirtualWorld(i, 100);

	CreateDynamicObject(7264, 277.46997, 94.69891, 1321.55212,   0.00000, 0.00000, 0.00000, .worldid = 100);
	CreateDynamicObject(7264, 402.31766, 147.72301, 1321.55212,   0.00000, 0.00000, 90.00000, .worldid = 100);
	CreateDynamicObject(7264, 369.71414, 228.60138, 1321.55212,   0.00000, 0.00000, 180.00000, .worldid = 100);
	CreateDynamicObject(7264, 272.70834, 214.62027, 1321.55212,   0.00000, 0.00000, 270.00000, .worldid = 100);
	CreateDynamicObject(7264, 348.56042, 202.58948, 1267.59900,   90.00000, 0.00000, 270.00000, .worldid = 100);
	CreateDynamicObject(7264, 333.47507, 202.79184, 1265.30090,   90.00000, 0.00000, 270.00000, .worldid = 100);
	CreateDynamicObject(7264, 328.10861, 134.25200, 1266.49133,   90.00000, 0.00000, 90.00000, .worldid = 100);
	CreateDynamicObject(7264, 324.75668, 198.09085, 1375.49133,   270.00000, 0.00000, 270.00000, .worldid = 100);
	CreateDynamicObject(7264, 336.23752, 198.49298, 1375.49133,   270.00000, 0.00000, 270.00000, .worldid = 100);
	CreateDynamicObject(7264, 352.71371, 130.80672, 1375.49133,   270.00000, 0.00000, 90.00000, .worldid = 100);

	i = CreateDynamicObject(18769, 338.98148, 164.45738, 1319.34302,   0.00000, 0.00000, 0.00000);
	for(new j; j < 3; ++j) SetDynamicObjectMaterial(i, j, 0, "none", "none", 0);
	i = CreateDynamicObject(18769, 348.31168, 164.42392, 1329.21985,   0.00000, 90.00000, 0.00000);
	for(new j; j < 3; ++j) SetDynamicObjectMaterial(i, j, 0, "none", "none", 0);
	i = CreateDynamicObject(18769, 328.52719, 164.34248, 1329.21985,   0.00000, 90.00000, 0.00000);
	for(new j; j < 3; ++j) SetDynamicObjectMaterial(i, j, 0, "none", "none", 0);
	i = CreateDynamicObject(18769, 338.74298, 173.78041, 1329.21985,   0.00000, 90.00000, 90.00000);
	for(new j; j < 3; ++j) SetDynamicObjectMaterial(i, j, 0, "none", "none", 0);
	i = CreateDynamicObject(18769, 338.96732, 154.25504, 1329.21985,   0.00000, 90.00000, 90.00000);
	for(new j; j < 3; ++j) SetDynamicObjectMaterial(i, j, 0, "none", "none", 0);
}

Ufo_CreateUfo(playerid) {

	new Float:fPos[3],
		Float:foPos[6];
	GetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]);

	fPos[2] += 100.0;

	SetPlayerTime(playerid, 3, 0);
	SetPlayerWeather(playerid, 710);

	SetPVarInt(playerid, "Aliens", 0);
	defer Ufo_Aliens(playerid);

	for(new i; i < MAX_UFOS; ++i) {

		if(!IsValidDynamicObject(arrUfo[i][ufo_iObjectID][0])) {

			arrUfo[i][ufo_iPlayerID] = playerid;

			arrUfo[i][ufo_iObjectID][0] = CreateDynamicObject(10955, fPos[0] + -0.55725, fPos[1] + 2.92444, fPos[2] + 5.34400,   0.00000, 0.00000, 0.00000, .playerid = playerid);
			arrUfo[i][ufo_iObjectID][1] = CreateDynamicObject(10955, fPos[0] + -0.55725, fPos[1] + 2.92444, fPos[2] + 5.34399,   0.00000, 0.00000, 90.00000, .playerid = playerid);
			arrUfo[i][ufo_iObjectID][2] = CreateDynamicObject(10955, fPos[0] + -0.55725, fPos[1] + 2.92444, fPos[2] + 12.68831,   0.00000, 180.00000, 90.00000, .playerid = playerid);
			arrUfo[i][ufo_iObjectID][3] = CreateDynamicObject(10955, fPos[0] + -0.55725, fPos[1] + 2.92444, fPos[2] + 12.68829,   0.00000, 180.00000, 0.00000, .playerid = playerid);
			arrUfo[i][ufo_iObjectID][4] = CreateDynamicObject(18656, fPos[0] + -0.23865, fPos[1] + 2.01184, fPos[2] + 4.47868,   270.00000, 0.00000, 0.00000, .playerid = playerid);
			arrUfo[i][ufo_iObjectID][5] = CreateDynamicObject(3872, fPos[0] + 4.32544, fPos[1] + 1.36792, fPos[2] + -12.68831,   0.00000, 270.00000, 0.29480, .playerid = playerid);
			arrUfo[i][ufo_iObjectID][6] = CreateDynamicObject(3872, fPos[0] + -3.95508, fPos[1] + 0.24829, fPos[2] + -12.68831,   0.00000, 330.00000, 0.29480, .playerid = playerid);
			arrUfo[i][ufo_iObjectID][7] = CreateDynamicObject(3872, fPos[0] + 0.17798, fPos[1] + 4.61609, fPos[2] + -12.68831,   0.00000, 270.00000, 90.00000, .playerid = playerid);
			arrUfo[i][ufo_iObjectID][8] = CreateDynamicObject(3872, fPos[0] + 0.20605, fPos[1] + -5.38574, fPos[2] + -12.68831,   0.00000, 270.00000, 270.00000, .playerid = playerid);
			arrUfo[i][ufo_iObjectID][9] = CreateDynamicObject(9123, fPos[0] + 5.77893, fPos[1] + 2.94751, fPos[2] + -10.47681,   0.00000, 90.00000, 0.00000, .playerid = playerid);
			arrUfo[i][ufo_iObjectID][10] = CreateDynamicObject(9123, fPos[0] + -5.77881,fPos[1] +  2.94519, fPos[2] + -10.47681,   0.00000, 90.00000, 180.00000, .playerid = playerid);
			arrUfo[i][ufo_iObjectID][11] = CreateDynamicObject(9127, fPos[0] + 3.37561, fPos[1] + 5.38574, fPos[2] + -5.61124,   0.00000, 0.00000, 0.72686, .playerid = playerid);
			arrUfo[i][ufo_iObjectID][12] = CreateDynamicObject(9127, fPos[0] + 3.88684, fPos[1] + 4.88086, fPos[2] + -5.61121,   0.00000, 0.00000, 45.00000, .playerid = playerid);


			for(new j; j < 13; ++j) {

				GetDynamicObjectPos(arrUfo[i][ufo_iObjectID][j], foPos[0], foPos[1], foPos[2]);
				GetDynamicObjectRot(arrUfo[i][ufo_iObjectID][j], foPos[3], foPos[4], foPos[5]);

				MoveDynamicObject(arrUfo[i][ufo_iObjectID][j], foPos[0], foPos[1], foPos[2] - 20.0, 1.0, foPos[3], foPos[4], foPos[5]);
			}
			return 1;
		}
	}
	return 1;
}

/*Ufo_CreateAdminUfo(playerid) {

	new Float:fPos[3],
		Float:foPos[6];

	GetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]);

	fPos[2] += 100.0;

	SetPVarInt(playerid, "Aliens", 0);

	for(new i; i < MAX_UFOS; ++i) {

		if(!IsValidDynamicObject(arrUfo[i][ufo_iObjectID][0])) {

			arrUfo[i][ufo_iPlayerID] = playerid;

			arrUfo[i][ufo_iObjectID][0] = CreateDynamicObject(10955, fPos[0] + -0.55725, fPos[1] + 2.92444, fPos[2] + 5.34400,   0.00000, 0.00000, 0.00000);
			arrUfo[i][ufo_iObjectID][1] = CreateDynamicObject(10955, fPos[0] + -0.55725, fPos[1] + 2.92444, fPos[2] + 5.34399,   0.00000, 0.00000, 90.00000);
			arrUfo[i][ufo_iObjectID][2] = CreateDynamicObject(10955, fPos[0] + -0.55725, fPos[1] + 2.92444, fPos[2] + 12.68831,   0.00000, 180.00000, 90.00000);
			arrUfo[i][ufo_iObjectID][3] = CreateDynamicObject(10955, fPos[0] + -0.55725, fPos[1] + 2.92444, fPos[2] + 12.68829,   0.00000, 180.00000, 0.00000);
			arrUfo[i][ufo_iObjectID][4] = CreateDynamicObject(18656, fPos[0] + -0.23865, fPos[1] + 2.01184, fPos[2] + 4.47868,   270.00000, 0.00000, 0.00000);
			arrUfo[i][ufo_iObjectID][5] = CreateDynamicObject(3872, fPos[0] + 4.32544, fPos[1] + 1.36792, fPos[2] + -12.68831,   0.00000, 270.00000, 0.29480);
			arrUfo[i][ufo_iObjectID][6] = CreateDynamicObject(3872, fPos[0] + -3.95508, fPos[1] + 0.24829, fPos[2] + -12.68831,   0.00000, 330.00000, 0.29480);
			arrUfo[i][ufo_iObjectID][7] = CreateDynamicObject(3872, fPos[0] + 0.17798, fPos[1] + 4.61609, fPos[2] + -12.68831,   0.00000, 270.00000, 90.00000);
			arrUfo[i][ufo_iObjectID][8] = CreateDynamicObject(3872, fPos[0] + 0.20605, fPos[1] + -5.38574, fPos[2] + -12.68831,   0.00000, 270.00000, 270.00000);
			arrUfo[i][ufo_iObjectID][9] = CreateDynamicObject(9123, fPos[0] + 5.77893, fPos[1] + 2.94751, fPos[2] + -10.47681,   0.00000, 90.00000, 0.00000);
			arrUfo[i][ufo_iObjectID][10] = CreateDynamicObject(9123, fPos[0] + -5.77881,fPos[1] +  2.94519, fPos[2] + -10.47681,   0.00000, 90.00000, 180.00000);
			arrUfo[i][ufo_iObjectID][11] = CreateDynamicObject(9127, fPos[0] + 3.37561, fPos[1] + 5.38574, fPos[2] + -5.61124,   0.00000, 0.00000, 0.72686);
			arrUfo[i][ufo_iObjectID][12] = CreateDynamicObject(9127, fPos[0] + 3.88684, fPos[1] + 4.88086, fPos[2] + -5.61121,   0.00000, 0.00000, 45.00000);


			for(new j; j < 13; ++j) {

				GetDynamicObjectPos(arrUfo[i][ufo_iObjectID][j], foPos[0], foPos[1], foPos[2]);
				GetDynamicObjectRot(arrUfo[i][ufo_iObjectID][j], foPos[3], foPos[4], foPos[5]);

				MoveDynamicObject(arrUfo[i][ufo_iObjectID][j], foPos[0], foPos[1], foPos[2] - 20.0, 1.0, foPos[3], foPos[4], foPos[5]);
			}
			return 1;
		}
	}
	return 1;
}*/

Ufo_DestroyUfo(playerid) {

	new i;
	for(i = 0; i < MAX_UFOS; ++i) if(arrUfo[i][ufo_iPlayerID] == playerid) break;
	for(new j; j < 13; ++j) DestroyDynamicObject(arrUfo[i][ufo_iObjectID][j]);
	return 1;
}

/*Ufo_DestroyAdminUfo() {

	for(new i; i < MAX_UFOS; ++i) for(new j; j < 13; ++j) DestroyDynamicObject(arrUfo[i][ufo_iObjectID][j]);
	return 1;
}*/


CMD:aliens(playerid, params) {

	if(IsAdminLevel(playerid, ADMIN_SENIOR)) Ufo_CreateUfo(playerid);
	else SendClientMessage(playerid, COLOR_GRAD1, "You are not high enough for this experience.");
	return 1;
}


Character_Actor(playerid, choice)
{
	switch(choice) {

		case 0:	{

			PlayerInfo[playerid][pModel] = GetPlayerSkin(playerid);

			new Float:fPos[4],
				iVW = GetPlayerVirtualWorld(playerid),
				iActorID,
				Float:fHealth;

			GetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]);
			GetPlayerFacingAngle(playerid, fPos[3]);
			GetHealth(playerid, fHealth);
			iActorID = CreateActor(PlayerInfo[playerid][pModel], fPos[0], fPos[1], fPos[2], fPos[3]);
			SetActorVirtualWorld(iActorID, iVW);
			SetActorInvulnerable(iActorID, false);
			SetActorHealth(iActorID, fHealth);
			SetPVarInt(playerid, PVAR_TEMPACTOR, iActorID);
			format(szMiscArray, sizeof(szMiscArray), "%s (%d)", GetPlayerNameEx(playerid), playerid);
			SetPVarInt(playerid, PVAR_TEMPTEXT, _:CreateDynamic3DTextLabel(szMiscArray, COLOR_WHITE, fPos[0], fPos[1], fPos[2] + 1.0, 5.0, .worldid = iVW));

		}
		case 1:	{

			DestroyActor(GetPVarInt(playerid, PVAR_TEMPACTOR));
			DestroyDynamic3DTextLabel(Text3D:GetPVarInt(playerid, PVAR_TEMPTEXT));
			DeletePVar(playerid, PVAR_TEMPACTOR);
			DeletePVar(playerid, PVAR_TEMPTEXT);
		}
	}
}


Main_CreateAttached3DTextLabel(playerid, szString[]) {

	new Float:fPos[3];
	GetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]);
	if(GetPVarType(playerid, "TEMP_TL")) return 1;
	SetPVarInt(playerid, "TEMP_TL", _:CreateDynamic3DTextLabel(szString, COLOR_LIGHTBLUE, fPos[0], fPos[1], fPos[2]+0.1, 5, .attachedplayer = playerid, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = GetPlayerInterior(playerid), .streamdistance = 5));
	return 1;
}

Main_DestroyAttached3DTextLabel(playerid) {

	DestroyDynamic3DTextLabel(Text3D:GetPVarInt(playerid, "TEMP_TL"));
	DeletePVar(playerid, "TEMP_TL");
}

Drugs_ShowTrunkMenu(playerid, iVehID, iChoiceID) {

	szMiscArray[0] = 0;
	szMiscArray = "Drug\tOn you\tIn vehicle";
	SetPVarInt(playerid, "PVehID", iVehID);
	SetPVarInt(playerid, "PVDTransfer", iChoiceID);
	for(new i; i < sizeof(szDrugs); ++i) {

		format(szMiscArray, sizeof(szMiscArray), "%s\n%s\t%d\t%d",
			szMiscArray, szDrugs[i],
			PlayerInfo[playerid][p_iDrug][i],
			PlayerVehicleInfo[playerid][iVehID][pvDrugs][i]);
	}
	switch(iChoiceID) {

		case 0: {
			strcat(szMiscArray, "\nWithdraw All\t-\t-", sizeof(szMiscArray));
		}
		case 1: {
			strcat(szMiscArray, "\nDeposit All\t-\t-", sizeof(szMiscArray));
		}
	}
	ShowPlayerDialogEx(playerid, DIALOG_PVEHICLE_DRUGS, DIALOG_STYLE_TABLIST_HEADERS, "Vehicle | Drug Transfer", szMiscArray, "Enter", "Cancel");
	return 1;
}