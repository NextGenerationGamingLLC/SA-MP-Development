/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

    	    		  Drug System (Revision)
    			        by Winterfield

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

new dr_iPlayerTimeStamp[MAX_PLAYERS];

CMD:odrughelp(playerid, params[])
{
	SendClientMessageEx(playerid, COLOR_WHITE,"-----------------------------------------------------------------------------------");
	SendClientMessageEx(playerid, COLOR_GREY, "GENERAL: /mydrugs, /usedrug, /buypot, /buyopium, /plantpot, /plantopium, /pickplant, /checkplant /makeheroin");
	if(IsACop(playerid)) SendClientMessageEx(playerid, COLOR_GREY, "POLICE: /destroyplant, /searchcar");
	if(IsAdminLevel(playerid, ADMIN_JUNIOR, 0)) SendClientMessageEx(playerid, COLOR_GREY, "ADMINISTRATOR: /adestroyplant");
	SendClientMessageEx(playerid, COLOR_WHITE,"-----------------------------------------------------------------------------------");
	return 1;
}

CMD:mydrugs(playerid, params[])
{
	new string[450];
	SendClientMessageEx(playerid, COLOR_WHITE,"-----------------------------------------------------------------------------------");
	for(new i; i < sizeof(Drugs); i++) format(string, sizeof(string),"%s | %s: %dg", string, Drugs[i], PlayerInfo[playerid][pDrugs][i]);
	format(string, sizeof(string),"%s | Pot Seeds: %d | Opium Seeds: %d | Syringes: %d |", string, PlayerInfo[playerid][pWSeeds], PlayerInfo[playerid][pOpiumSeeds], PlayerInfo[playerid][pSyringes]);
	SendClientMessageEx(playerid, COLOR_GREY, string);
	SendClientMessageEx(playerid, COLOR_WHITE,"-----------------------------------------------------------------------------------");
	return 1;
}

CMD:checkdrugs(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] >= 2)
	{
		new giveplayerid;
		if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /checkdrugs [player]");
		if(IsPlayerConnected(giveplayerid))
		{
			new string[450];
			SendClientMessageEx(playerid, COLOR_WHITE,"-----------------------------------------------------------------------------------");
			for(new i; i < sizeof(Drugs); i++) format(string, sizeof(string),"%s | %s: %dg", string, Drugs[i], PlayerInfo[giveplayerid][pDrugs][i]);
			format(string, sizeof(string),"%s | Pot Seeds: %d | Opium Seeds: %d | Syringes: %d |", string, PlayerInfo[giveplayerid][pWSeeds], PlayerInfo[giveplayerid][pOpiumSeeds], PlayerInfo[giveplayerid][pSyringes]);
			SendClientMessageEx(playerid, COLOR_GREY, string);
			SendClientMessageEx(playerid, COLOR_WHITE,"-----------------------------------------------------------------------------------");
		}
		else SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid player specified.");
	}
	else SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use this command.");
	return 1;
}

CMD:usedrug(playerid, params[])
{
	if(GetPVarInt(playerid, "pDrugTime") > gettime()) return SendClientMessageEx(playerid, COLOR_GRAD1, "You must wait 60 seconds before using drugs again.");
	if(GetPVarType(playerid, "WatchingTV") || GetPVarType(playerid, "PreviewingTV")) return SendClientMessage(playerid, COLOR_GRAD1, "You cannot use drugs while watching TV.");
	if(HungerPlayerInfo[playerid][hgInEvent] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "   You cannot do this while being in the Hunger Games Event!");
   	#if defined zombiemode
	if(zombieevent == 1 && GetPVarType(playerid, "pIsZombie")) return SendClientMessageEx(playerid, COLOR_GREY, "Zombies can't use this.");
	#endif
	if(GetPVarType(playerid, "PlayerCuffed") || GetPVarInt(playerid, "pBagged") >= 1 || GetPVarType(playerid, "IsFrozen") || PlayerInfo[playerid][pHospital] || (PlayerInfo[playerid][pJailTime] > 0 && strfind(PlayerInfo[playerid][pPrisonReason], "[OOC]", true) != -1))
   		return SendClientMessage(playerid, COLOR_GRAD2, "You can't do that at this time!");
	if(GetPVarType(playerid, "AttemptingLockPick")) return SendClientMessageEx(playerid, COLOR_WHITE, "You are attempting to lockpick, please wait.");
	if(GetPVarType(playerid, "IsInArena")) return SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this while being in an arena!");
	if(PlayerBoxing[playerid] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use drugs while you're fighting.");
	if(UsedCrack[playerid] == 1) return SendClientMessageEx(playerid, COLOR_WHITE, "You must wait 5 seconds before using more drugs.");
	if(PlayerInfo[playerid][pHospital]) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot do this at this time.");

	new drugstring[16], amount;
	if(sscanf(params, "s[16]d", drugstring, amount))
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "USAGE: /usedrug [drug name] [amount]");
		ListDrugs(playerid);
		return 1;
	}

	if(amount < 1 || amount > 20) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot take that.");

	new drug = GetDrugID(drugstring);
	if(drug == -1)
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "USAGE: /usedrug [drug name] [amount]");
		ListDrugs(playerid);
		return 1;
	}

	if(PlayerInfo[playerid][pDrugs][drug] < amount) return SendClientMessageEx(playerid, COLOR_GRAD1, "You do not have that many drugs.");
	if(drug == 4 && amount != 10) return SendClientMessageEx(playerid, COLOR_GRAD1, "You must take only 10 heroin at a time.");
	if(drug == 4 && PlayerInfo[playerid][pSyringes] <= 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "You need a syringe. Craft one or buy one from a craftsman.");
	if(drug != 4 && dr_iPlayerTimeStamp[playerid] > gettime() - 60) return SendClientMessageEx(playerid, COLOR_GRAD1, "You have been injured in the last minute");
	if(drug != 4 && GetPVarType(playerid, "Injured")) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot do this right now.");
	if(!IsPlayerInAnyVehicle(playerid) && drug != 4) ApplyAnimation(playerid,"SMOKING","M_smkstnd_loop",2.1,0,0,0,0,0);

	PlayerInfo[playerid][pDrugs][drug] -= amount;

	SetPVarInt(playerid, "pDrugTime", gettime() + 60);
	GivePlayerDrugEffects(playerid, drug, amount);
	return 1;
}

CMD:buypot(playerid, params[])
{
	new string[256];
	if(PlayerInfo[playerid][pJob] != 14 && PlayerInfo[playerid][pJob2] != 14 && PlayerInfo[playerid][pJob3] != 14) return SendClientMessageEx(playerid,COLOR_GREY,"  You are not a drug smuggler!");

	for (new i=0; i<MAX_POINTS; i++)
	{
		if(IsPlayerInRangeOfPoint(playerid, 3.0, DynPoints[i][poPos][0], DynPoints[i][poPos][1], DynPoints[i][poPos][2]) && DynPoints[i][poType] == 1)
		{
			if(GetPlayerMoney(playerid) < 10000) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot afford the $10,000!");
			GivePlayerCashEx(playerid, TYPE_ONHAND, -10000);

			PlayerInfo[playerid][pWSeeds] += 1;
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have purchased a bag of pot seeds from the drug house.");

			format(string, sizeof(string), "* %s has purchased some pot seeds.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		}
	}
	return 1;
}

CMD:buyopium(playerid, params[])
{
	new string[256];
	if(PlayerInfo[playerid][pJob] != 14 && PlayerInfo[playerid][pJob2] != 14 && PlayerInfo[playerid][pJob3] != 14) return SendClientMessageEx(playerid,COLOR_GREY,"  You are not a drug smuggler!");
	if(GetPlayerMoney(playerid) < 100000) return SendClientMessageEx(playerid,COLOR_GREY,"  You can't afford to buy Opium");

	for (new i=0; i<MAX_POINTS; i++)
	{
		if(IsPlayerInRangeOfPoint(playerid, 5.0, DynPoints[i][poPos][0], DynPoints[i][poPos][1], DynPoints[i][poPos][2]) && DynPoints[i][poType] == 2)
		{
			if(GetPlayerMoney(playerid) < 100000) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot afford the $100,000!");
			GivePlayerCashEx(playerid, TYPE_ONHAND, -100000);

			PlayerInfo[playerid][pOpiumSeeds] += 1;
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have purchased a bag of opium seeds from the drug house.");

			format(string, sizeof(string), "* %s has purchased some opium seeds.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		}
	}
	return 1;
}

forward DrugEffectTime(playerid);
public DrugEffectTime(playerid)
{
	SyncPlayerTime(playerid);
    SetPlayerDrunkLevel(playerid, 0);
	SetPlayerWeather(playerid, gWeather);

	SendClientMessageEx(playerid, COLOR_GRAD1, "Your side affects have worn off.");
    return 1;
}

hook OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
	dr_iPlayerTimeStamp[playerid] = gettime();
}

GivePlayerDrugEffects(playerid, id, amount)
{
	new Float:health, Float:armour, string[256];
 	GetHealth(playerid, health);
 	GetArmour(playerid, armour);

	switch(id)
	{
		case 0: // Pot
		{
			new Float:increase = amount * 2;
			SetHealth(playerid, health + increase);
			if(health + increase > 100) SetHealth(playerid, 100);

			format(string, sizeof(string), "* %s has used some pot.", GetPlayerNameEx(playerid));
			ProxDetector(25.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		}
		case 1: // Crack
		{
			new Float:increase = amount * 2;
			SetArmour(playerid, armour + increase);
			if(armour + increase > 100) SetArmour(playerid, 100);

			format(string, sizeof(string), "* %s has used some crack.", GetPlayerNameEx(playerid));
			ProxDetector(25.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		}
		case 2: // Meth
		{
			new Float:increase = amount * 4;
			if(armour < 100 && amount == 20) SetArmour(playerid, 100);
			SetHealth(playerid, armour + increase);

			if(health + increase > 150) SetHealth(playerid, 150);

			format(string, sizeof(string), "* %s has used some meth.", GetPlayerNameEx(playerid));
			ProxDetector(25.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		}
		case 3: // Ecstasy
		{
			new Float:increase = amount * 5;
			SetHealth(playerid, health + increase);
			SetArmour(playerid, armour + increase);

			if(health + increase > 150) SetHealth(playerid, 150);
			if(armour + increase > 150) SetArmour(playerid, 150);

			format(string, sizeof(string), "* %s has used some ecstasy.", GetPlayerNameEx(playerid));
			ProxDetector(25.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		}
		case 4: // Heroin
		{
			if(GetPVarInt(playerid, "Injured") != 1)
			{
				SetPVarInt(playerid, "HeroinLastUsed", gettime());
				PlayerInfo[playerid][pSyringes] -= 1;

				SetPVarInt(playerid, "InjectHeroinStanding", SetTimerEx("InjectHeroinStanding", 5000, 0, "i", playerid));

				if(!IsPlayerInAnyVehicle(playerid)) ApplyAnimation(playerid,"SMOKING","M_smkstnd_loop",2.1,0,0,0,0,0);

				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have injected heroin into yourself, the effects will begin in 5 seconds.");
				format(string, sizeof(string), "* %s injects heroin into themself.", GetPlayerNameEx(playerid));
				ProxDetector(25.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
        		return 1;
			}

			SetPVarInt(playerid, "HeroinLastUsed", gettime());
			PlayerInfo[playerid][pSyringes] -= 1;

			SetPVarInt(playerid, "Health", 30);
			SetPVarInt(playerid, "InjectHeroin", SetTimerEx("InjectHeroin", 5000, 0, "i", playerid));

			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have injected heroin into yourself, the effects will begin in 5 seconds.");
			format(string, sizeof(string), "* %s injects heroin into themself.", GetPlayerNameEx(playerid));
			ProxDetector(25.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		}
	}

	if(id != 4) GivePlayerDrugSideEffect(playerid, id, amount);
	return 1;
}

forward InjectHeroin(playerid);
public InjectHeroin(playerid)
{
    KillEMSQueue(playerid);
	ClearAnimationsEx(playerid);
	SetHealth(playerid, 30);
	SetPVarInt(playerid, "HeroinEffect", SetTimerEx("HeroinEffect", 1000, 1, "i", playerid));

	SendClientMessageEx(playerid, COLOR_GREEN, "The effects of the heroin have started.");
	return 1;
}

forward HeroinEffectStanding(playerid);
public HeroinEffectStanding(playerid)
{
	SetPVarInt(playerid, "HeroinDamageResist", 0);
	SendClientMessageEx(playerid, COLOR_GREEN, "The effects of the heroin have worn off.");
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

forward InjectHeroinStanding(playerid);
public InjectHeroinStanding(playerid)
{
	SetPVarInt(playerid, "HeroinDamageResist", 1);
	SendClientMessageEx(playerid, COLOR_GREEN, "The effects of the heroin have started.");
	SetPVarInt(playerid, "HeroinEffectStanding", SetTimerEx("HeroinEffectStanding", 30000, 0, "i", playerid));
	return 1;
}

GivePlayerDrugSideEffect(playerid, id, amount)
{
	switch(id)
	{
		case 0:
		{
			SetPlayerDrunkLevel(playerid, 50000);
			SetPlayerWeather(playerid, 9);
			SetPlayerTime(playerid, 0, 0);
		}
		case 1:
		{
			SetPlayerDrunkLevel(playerid, 50000);
			SetPlayerWeather(playerid, 19);
			SetPlayerTime(playerid, 0, 0);
		}
		case 2:
		{
			SetPlayerDrunkLevel(playerid, 50000);
			SetPlayerWeather(playerid, 111);
			SetPlayerTime(playerid, 0, 0);
		}
		case 3:
		{
			SetPlayerDrunkLevel(playerid, 50000);
			SetPlayerWeather(playerid, 700);
			SetPlayerTime(playerid, 0, 0);
		}
		default: return 1;
	}
	switch(amount)
	{
		case 1 .. 2: SetTimerEx("DrugEffectTime", 10000, false, "i", playerid);
		case 3 .. 7: SetTimerEx("DrugEffectTime", 15000, false, "i", playerid);
		case 8 .. 12: SetTimerEx("DrugEffectTime", 20000, false, "i", playerid);
		case 13 .. 16: SetTimerEx("DrugEffectTime", 25000, false, "i", playerid);
		case 17 .. 20: SetTimerEx("DrugEffectTime", 30000, false, "i", playerid);
		default: SetTimerEx("DrugEffectTime", 30000, false, "i", playerid);
	}
	return 1;
}

GetDrugName(id)
{
	switch(id)
	{
		case 0: szMiscArray = "Pot";
		case 1: szMiscArray = "Crack";
		case 2: szMiscArray = "Meth";
		case 3: szMiscArray = "Ecstasy";
		case 4: szMiscArray = "Heroin";
	}
	return szMiscArray;
}

ListDrugs(playerid)
{
	szMiscArray[0] = 0;
	for(new i; i < sizeof(Drugs); ++i)
	{
		format(szMiscArray, sizeof(szMiscArray),"%s | %s | %s | %s | %s", Drugs[0], Drugs[1], Drugs[2], Drugs[3], Drugs[4]);
	}

	SendClientMessageEx(playerid, COLOR_GRAD1, szMiscArray);
}

GetDrugID(Drug[])
{
	for(new i; i < sizeof(Drugs); ++i) {

		if(strcmp(Drugs[i], Drug, true) == 0) return i;
	}
	return -1;
}

IncreaseSmugglerLevel(playerid)
{

    if(PlayerInfo[playerid][pDoubleEXP] > 0)
    {
        PlayerInfo[playerid][pDrugSmuggler] += 2;
        // PlayerInfo[playerid][pXP] += PlayerInfo[playerid][pLevel] * XP_RATE * 2;
    }
    else
    {
        PlayerInfo[playerid][pDrugSmuggler] += 1;
        // PlayerInfo[playerid][pXP] += PlayerInfo[playerid][pLevel] * XP_RATE;
    }
    return 1;
}

Smuggle_VehicleLoad(playerid, iTargetID, iVehID)
{
	new iTotalAmount;

	szMiscArray = "Ingredient\tAmount in vehicle\n";

	if(iTotalAmount == 0) {
		szMiscArray[0] = 0;
		szMiscArray = "Drugs\tAmount in vehicle\n";
		for(new i; i < sizeof(Drugs); ++i) {

			if(PlayerVehicleInfo[iTargetID][iVehID][pvDrugs][i] > 0) {

				format(szMiscArray, sizeof(szMiscArray), "%s%s\t%d\n", szMiscArray, Drugs[i], PlayerVehicleInfo[iTargetID][iVehID][pvDrugs][i]);
				iTotalAmount += PlayerVehicleInfo[iTargetID][iVehID][pvDrugs][i];
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

			#if defined TEXTLABEL_DEBUG
			Streamer_SetIntData(STREAMER_TYPE_3D_TEXT_LABEL, Text3D:GetPVarInt(playerid, PVAR_TEMPTEXT), E_STREAMER_EXTRA_ID, 6);
			#endif

			DestroyDynamic3DTextLabel(Text3D:GetPVarInt(playerid, PVAR_TEMPTEXT));
			DeletePVar(playerid, PVAR_TEMPACTOR);
			DeletePVar(playerid, PVAR_TEMPTEXT);
		}
	}
}

// PLANT SYSTEM //

stock LoadPlants() {
	printf("[LoadPlants] Loading data from database...");
	mysql_tquery(MainPipeline, "SELECT * FROM `plants`", "PlantsLoadQuery", "");
}

forward PlantsLoadQuery();
public PlantsLoadQuery() {

	new
		iRows,
		iIndex;

	cache_get_row_count(iRows);

	while((iIndex < iRows))
	{
		cache_get_value_name_int(iIndex, "Owner", Plants[iIndex][pOwner]);
		cache_get_value_name_int(iIndex, "Object", Plants[iIndex][pObject]);
		cache_get_value_name_int(iIndex, "PlantType", Plants[iIndex][pPlantType]);
		cache_get_value_name_float(iIndex, "PositionX", Plants[iIndex][pPos][0]);
		cache_get_value_name_float(iIndex, "PositionY", Plants[iIndex][pPos][1]);
		cache_get_value_name_float(iIndex, "PositionZ", Plants[iIndex][pPos][2]);
		cache_get_value_name_int(iIndex, "Virtual", Plants[iIndex][pVirtual]);
		cache_get_value_name_int(iIndex, "Interior", Plants[iIndex][pInterior]);
		cache_get_value_name_int(iIndex, "Growth", Plants[iIndex][pGrowth]);
		cache_get_value_name_int(iIndex, "Expires", Plants[iIndex][pExpires]);
		cache_get_value_name_int(iIndex, "DrugsSkill", Plants[iIndex][pDrugsSkill]);

		if(Plants[iIndex][pOwner] != 0)
		{
		    Plants[iIndex][pObjectSpawned] = CreateDynamicObject(Plants[iIndex][pObject], Plants[iIndex][pPos][0], Plants[iIndex][pPos][1], Plants[iIndex][pPos][2], 0.0, 0.0, 0.0, Plants[iIndex][pVirtual], Plants[iIndex][pInterior]);
		}
		iIndex++;
	}
	if(iIndex > 0) printf("[LoadPlants] Successfully loaded %d plants", iIndex);
	else printf("[LoadPlants] Error: Failed to load any plants!");
	return 1;
}

stock SavePlant(plant)
{
	new query[300];
	mysql_format(MainPipeline, query, sizeof(query), "UPDATE `plants` SET `Owner` = %d, `Object` = %d, `PlantType` = %d, `PositionX` = %f, `PositionY` = %f, `PositionZ` = %f, `Virtual` = %d, \
	`Interior` = %d, `Growth` = %d, `Expires` = %d, `DrugsSkill` = %d WHERE `PlantID` = %d",Plants[plant][pOwner], Plants[plant][pObject], Plants[plant][pPlantType], Plants[plant][pPos][0], Plants[plant][pPos][1], Plants[plant][pPos][2],
	Plants[plant][pVirtual], Plants[plant][pInterior], Plants[plant][pGrowth], Plants[plant][pExpires], Plants[plant][pDrugsSkill], plant+1);
	mysql_tquery(MainPipeline, query, "OnQueryFinish", "i", SENDDATA_THREAD);
	return 1;
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

CMD:makeheroin(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 15.0, -882.2048,1109.3385,5442.8193))
	    return SendClientMessageEx(playerid, COLOR_GREY, "You are not at the purification lab.");

	if(PlayerInfo[playerid][pRawOpium] == 0)
	    return SendClientMessageEx(playerid, COLOR_GREY, "You don't have any raw opium to purify.");

	if(Purification[0] == 1)
	    return SendClientMessageEx(playerid, COLOR_GREY, "Only one player may attempt to purify their opium at a time.");

	new szMessage[128];
	SendClientMessageEx(playerid, COLOR_GREEN, "You must wait 30 seconds, for purification to be complete.");

    format(szMessage, sizeof(szMessage), "* %s begins the purification process.", GetPlayerNameEx(playerid));
	ProxDetector(25.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

	Purification[0] = 1;
	SetPVarInt(playerid, "AttemptPurify", SetTimerEx("AttemptPurify", 1000, 1, "i", playerid));
	return 1;
}

CMD:plantopium(playerid, params[])
{
 	if(PlayerInfo[playerid][pOpiumSeeds] > 0)
 	{
		if(PlayerInfo[playerid][pWeedObject] > 0)
		{
		    SendClientMessageEx(playerid, COLOR_GRAD2, "You already have a plant growing." );
		    return 1;
		}
		if(GetPlayerInterior(playerid) == 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "   You need to be inside an inteiror!");
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER || GetPlayerState(playerid) == PLAYER_STATE_PASSENGER) return SendClientMessageEx(playerid, COLOR_WHITE, "You cannot plant seeds while inside a vehicle!");
		for(new i = 0; i < MAX_PLANTS; ++i)
		{
		    if(Plants[i][pObject] == 0)
		    {
		        new
					szMessage[48],
					Float:xyz[3];

        		ApplyAnimation(playerid,"BOMBER","BOM_Plant_Crouch_In", 4.0, 0, 0, 0, 0, 0, 1);
				SendClientMessageEx(playerid, COLOR_GREEN, "You have planted some opium. It will take around 2 hours to grow.");
		        GetPlayerPos(playerid, xyz[0], xyz[1], xyz[2]);
		        xyz[2] -= 1.0;

		        PlayerInfo[playerid][pOpiumSeeds]--;
		        PlayerInfo[playerid][pWeedObject] = 1;
				PlacePlant(i, GetPlayerSQLId(playerid), 2, 859, PlayerInfo[playerid][pDrugSmuggler], xyz[0], xyz[1], xyz[2], GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
				SavePlant(i);
				new string[128];
				format(string, sizeof(string), "%s(%d) (IP:%s) has placed opium plant (%d)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), i);
				Log("logs/plant.log", string);
				format(szMessage, sizeof(szMessage), "* %s plants some opium.", GetPlayerNameEx(playerid));
				ProxDetector(25.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				return 1;
			}
		}
		SendClientMessageEx(playerid, COLOR_GREY, "The server has reached the max number of plants. Try again later!");
	}
	else SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough seeds to plant opium - head to the crack house and pick up some seeds (/buyopium).");
	return 1;
}

CMD:plantpot(playerid, params[])
{
 	if(PlayerInfo[playerid][pWSeeds] > 0)
 	{
		if(PlayerInfo[playerid][pWeedObject] > 0)
		{
		    SendClientMessageEx(playerid, COLOR_GRAD2, "You already have a plant growing." );
		    return 1;
		}
		if(GetPlayerInterior(playerid) == 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "   You need to be inside an inteiror!");
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER || GetPlayerState(playerid) == PLAYER_STATE_PASSENGER) return SendClientMessageEx(playerid, COLOR_WHITE, "You cannot plant seeds while inside a vehicle!");
		for(new i = 0; i < MAX_PLANTS; ++i)
		{
		    if(Plants[i][pObject] == 0)
		    {
		        new
					szMessage[48],
					Float: xyz[3];

        		ApplyAnimation(playerid,"BOMBER","BOM_Plant_Crouch_In", 4.0, 0, 0, 0, 0, 0, 1);
				SendClientMessageEx(playerid, COLOR_GREEN, "You have planted some weed. It will take around 20-45 minutes to grow.");
		        GetPlayerPos(playerid, xyz[0], xyz[1], xyz[2]);
				xyz[2] -= 1.5;

		        Plants[i][pDrugsSkill] = PlayerInfo[playerid][pDrugSmuggler];
		        PlayerInfo[playerid][pWeedObject] = 1;
		        PlayerInfo[playerid][pWSeeds]--;
                PlacePlant(i, GetPlayerSQLId(playerid), 1, 19473, PlayerInfo[playerid][pDrugSmuggler], xyz[0], xyz[1], xyz[2], GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
                SavePlant(i);
                new string[128];
				format(string, sizeof(string), "%s(%d) (IP:%s) has placed weed plant (%d)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), i);
				Log("logs/plant.log", string);
				format(szMessage, sizeof(szMessage), "* %s plants some weed.", GetPlayerNameEx(playerid));
				ProxDetector(25.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				return 1;
			}
		}
		SendClientMessageEx(playerid, COLOR_GREY, "The server has reached the max number of plants.");
	}
	else SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough seeds to plant weed - head to the drug house and pick up some seeds (/buypot).");
	return 1;
}

CMD:adestroyplant(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1) {

		new
			iTargetID;

		if(sscanf(params, "u", iTargetID)) {
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /adestroyplant [player]");
		}
		else if(IsPlayerConnected(iTargetID)) {

			for(new i = 0; i < MAX_PLANTS; ++i)
			{
			    if(Plants[i][pOwner] == GetPlayerSQLId(iTargetID))
			    {
			        new
						szMessage[47 + MAX_PLAYER_NAME];

                    foreach(new z : Player)
					{
						if(Plants[i][pOwner] == GetPlayerSQLId(z))
						{
							PlayerInfo[z][pWeedObject] = 0;
						}
					}
					format(szMessage, sizeof(szMessage), "You have destroyed %s's plant.", GetPlayerNameEx(iTargetID), Plants[i][pGrowth]);
					SendClientMessageEx(playerid, COLOR_GREY, szMessage);

					format(szMessage, sizeof(szMessage), "Administrator %s has destroyed your plant.", GetPlayerNameEx(playerid), Plants[i][pGrowth]);
					SendClientMessageEx(iTargetID, COLOR_GREY, szMessage);
                    new string[128];
					format(string, sizeof(string), "%s (IP:%s) has destroyed %s(%d) (IP:%s) plant (%d)", GetPlayerNameEx(playerid), GetPlayerIpEx(playerid), GetPlayerNameEx(iTargetID), GetPlayerSQLId(iTargetID), GetPlayerIpEx(iTargetID), i);
					Log("logs/plant.log", string);
                    PlayerInfo[iTargetID][pWeedObject] = 0;
                    DestroyPlant(i);
                    SavePlant(i);
					return 1;
			    }
			}
		}
		else SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");
	}
	else SendClientMessageEx(playerid, COLOR_GREY, "You're not authorized to use this command.");
	return 1;
}

CMD:destroyplant(playerid, params[])
{
	if(IsACop(playerid) || IsAMedic(playerid))
	{
		for(new i = 0; i < MAX_PLANTS; ++i)
		{
			if(IsValidDynamicObject(Plants[i][pObjectSpawned]) && IsPlayerInRangeOfPoint(playerid, 2.5, Plants[i][pPos][0], Plants[i][pPos][1], Plants[i][pPos][2]))
			{
				if(GetPlayerVirtualWorld(playerid) == Plants[i][pVirtual] && GetPlayerInterior(playerid) == Plants[i][pInterior]) {

					new
						szMessage[128];

					ApplyAnimation(playerid,"BOMBER","BOM_Plant_Crouch_Out", 4.0, 0, 0, 0, 0, 0, 1);

					switch(Plants[i][pPlantType]) {
	    				case 1:
					    {
							format(szMessage, sizeof(szMessage), "* You seized a marijuana plant weighing %d grams.", Plants[i][pGrowth]);
							SendClientMessageEx(playerid, COLOR_GREY, szMessage);
							format(szMessage, sizeof(szMessage), "* %s seizes the weed plant.", GetPlayerNameEx(playerid), GetPlayerNameEx(i));
							ProxDetector(25.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
							foreach(new z : Player)
							{
								if(Plants[i][pOwner] == GetPlayerSQLId(z))
								{
									PlayerInfo[z][pWeedObject] = 0;
								}
							}
							format(szMessage, sizeof(szMessage), "%s(%d) (IP:%s) has destroyed weed plant (%d)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), i);
							Log("logs/plant.log", szMessage);
							DestroyPlant(i);
							SavePlant(i);
							return 1;
						}
						case 2:
						{
						    new Grams = Random(10, 30);
						    format(szMessage, sizeof(szMessage), "* You seized a opium plant weighing %d milligrams.", Grams);
							SendClientMessageEx(playerid, COLOR_GREY, szMessage);
							format(szMessage, sizeof(szMessage), "* %s seizes the opium plant.", GetPlayerNameEx(playerid), GetPlayerNameEx(i));
							ProxDetector(25.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
							foreach(new z : Player)
							{
								if(Plants[i][pOwner] == GetPlayerSQLId(z))
								{
									PlayerInfo[z][pWeedObject] = 0;
								}
							}
							format(szMessage, sizeof(szMessage), "%s(%d) (IP:%s) has destroyed opium plant (%d)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), i);
							Log("logs/plant.log", szMessage);
							DestroyPlant(i);
							SavePlant(i);
							return 1;
						}
					}
				}
			}
		}
		SendClientMessageEx(playerid, COLOR_GREY, "You are not at a plant.");
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You're not a law enforcement officer.");
	}
	return 1;
}

CMD:checkplant(playerid, params[])
{
    for(new i = 0; i < MAX_PLANTS; ++i)
	{
		if(IsValidDynamicObject(Plants[i][pObjectSpawned]) && IsPlayerInRangeOfPoint(playerid, 2.5, Plants[i][pPos][0], Plants[i][pPos][1], Plants[i][pPos][2]))
		{
		    if(GetPlayerVirtualWorld(playerid) == Plants[i][pVirtual] && GetPlayerInterior(playerid) == Plants[i][pInterior])
		    {
		        switch(Plants[i][pPlantType])
		        {
		            case 1:
		            {
		                if(Plants[i][pGrowth] > 10)
		                {
		        			new
								szMessage[66 + MAX_PLAYER_NAME];

							format(szMessage, sizeof(szMessage), "Your plant currently carries %i grams - use /pickplant to claim it.", Plants[i][pGrowth]);
							SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
							return 1;
						}
						else SendClientMessageEx(playerid, COLOR_YELLOW, "This plant isn't ready to be picked yet.");
						return 1;
					}
					case 2:
					{
					    if(Plants[i][pGrowth] >= 120)
					    {
							SendClientMessageEx(playerid, COLOR_WHITE, "Your plant is currently ready to be harvested - use /pickplant to claim it.");
							return 1;
						}
						else SendClientMessageEx(playerid, COLOR_WHITE, "Your opium plant still needs more time to grow.");
						return 1;
					}
				}
		    }
		}
	}
	return SendClientMessageEx(playerid, COLOR_GREY, "You are not at a plant.");
}

CMD:pickplant(playerid, params[])
{
	for(new i = 0; i < MAX_PLANTS; ++i)
	{
		if(IsValidDynamicObject(Plants[i][pObjectSpawned]) && IsPlayerInRangeOfPoint(playerid, 2.5, Plants[i][pPos][0], Plants[i][pPos][1], Plants[i][pPos][2]))
		{
		    if(GetPlayerVirtualWorld(playerid) == Plants[i][pVirtual] && GetPlayerInterior(playerid) == Plants[i][pInterior])
		    {
		        switch(Plants[i][pPlantType])
		        {
		            case 1:
		            {
						if(Plants[i][pGrowth] > 10)
						{
							new szMessage[128];

							ApplyAnimation(playerid,"BOMBER","BOM_Plant_Crouch_Out", 4.0, 0, 0, 0, 0, 0, 1);

							format(szMessage, sizeof(szMessage), "You picked the plant and gathered %d grams of pot.", Plants[i][pGrowth]);
							SendClientMessageEx(playerid, COLOR_GREY, szMessage);
							format(szMessage, sizeof(szMessage), "* %s picks the weed plant.", GetPlayerNameEx(playerid));
							ProxDetector(25.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
                            foreach(new z : Player)
							{
								if(Plants[i][pOwner] == GetPlayerSQLId(z))
								{
									PlayerInfo[z][pWeedObject] = 0;
								}
							}
							format(szMessage, sizeof(szMessage), "%s(%d) (IP:%s) has picked weed plant (%d) and recieved %d grams", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), i, Plants[i][pGrowth]);
							Log("logs/plant.log", szMessage);
							PlayerInfo[playerid][pDrugs][0] += Plants[i][pGrowth];
							DestroyPlant(i);
							SavePlant(i);
							return 1;
						}
						else SendClientMessageEx(playerid, COLOR_GREY, "This plant is not ready to be picked yet.");
						return 1;
					}
					case 2:
					{
					    if(Plants[i][pGrowth] >= 120)
					    {
							new szMessage[128],
								Grams = Random(10, 30);

							ApplyAnimation(playerid,"BOMBER","BOM_Plant_Crouch_Out", 4.0, 0, 0, 0, 0, 0, 1);

							format(szMessage, sizeof(szMessage), "You picked the plant and gathered %d milligrams of opium.", Grams);
							SendClientMessageEx(playerid, COLOR_GREY, szMessage);
							format(szMessage, sizeof(szMessage), "* %s picks the opium plant.", GetPlayerNameEx(playerid));
							ProxDetector(25.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
							foreach(new z : Player)
							{
								if(Plants[i][pOwner] == GetPlayerSQLId(z))
								{
									PlayerInfo[z][pWeedObject] = 0;
								}
							}
							format(szMessage, sizeof(szMessage), "%s(%d) (IP:%s) has picked opium plant (%d) and recieved %d milligrams", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), i, Grams);
							Log("logs/plant.log", szMessage);
							PlayerInfo[playerid][pRawOpium] += Grams;
							DestroyPlant(i);
							SavePlant(i);
							return 1;
					    }
					    else SendClientMessageEx(playerid, COLOR_GREY, "This plant is not ready to be picked yet.");
						return 1;
					}
				}
	   		}
		}
	}
	return SendClientMessageEx(playerid, COLOR_GREY, "You are not at a plant.");
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

				PlayerInfo[playerid][pDrugs][4] += 30;
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

				PlayerInfo[playerid][pDrugs][4] += PlayerInfo[playerid][pRawOpium];
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

PlacePlant(id, ownerid, planttype, objectid, drugskill, Float:x, Float:y, Float:z, virtualworld, interior)
{
    Plants[id][pObjectSpawned] = 0;
	Plants[id][pOwner] = ownerid;
	Plants[id][pPlantType] = planttype;
	Plants[id][pObject] = objectid;
	Plants[id][pGrowth] = 0;
	Plants[id][pPos][0] = x;
	Plants[id][pPos][1] = y;
	Plants[id][pPos][2] = z;
	Plants[id][pVirtual] = virtualworld;
	Plants[id][pInterior] = interior;
	Plants[id][pExpires] = gettime()+86400;
	Plants[id][pDrugsSkill] = drugskill;
	Plants[id][pObjectSpawned] = CreateDynamicObject(objectid, x, y, z, 0.0, 0.0, 0.0, virtualworld, interior);
	return id;
}

DestroyPlant(i)
{
    DestroyDynamicObject(Plants[i][pObjectSpawned]);
	Plants[i][pObjectSpawned] = 0;
	Plants[i][pOwner] = 0;
	Plants[i][pPlantType] = 0;
	Plants[i][pObject] = 0;
	Plants[i][pGrowth] = 0;
	Plants[i][pPos][0] = 0.0;
	Plants[i][pPos][1] = 0.0;
	Plants[i][pPos][2] = 0.0;
	Plants[i][pVirtual] = 0;
	Plants[i][pInterior] = 0;
	Plants[i][pExpires] = 0;
	Plants[i][pDrugsSkill] = 0;
	if(IsValidDynamicObject(Plants[i][pObjectSpawned])) DestroyDynamicObject(Plants[i][pObjectSpawned]);
	return i;
}

PlantTimer()
{
	szMiscArray[0] = 0;
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
							format(szMiscArray, sizeof(szMiscArray), "Opium plant (%d) is ready to be picked.", i);
							Log("logs/plant.log", szMiscArray);
						}
					}
				}
			}
			else if(Plants[i][pExpires] == 0) { }
			else
			{
				format(szMiscArray, sizeof(szMiscArray), "Plant (%d) has expired.", i);
				Log("logs/plant.log", szMiscArray);
				DestroyPlant(i);
				SavePlant(i);
			}
		}
	}
}
