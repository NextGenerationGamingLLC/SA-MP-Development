/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Drugs System

				Next Generation Gaming, LLC
	(created by Next Generation Gaming Development Team)
					
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
stock LoadPlants() {
	printf("[LoadPlants] Loading data from database...");
	mysql_function_query(MainPipeline, "SELECT * FROM `plants`", true, "PlantsLoadQuery", "");
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

stock SavePlant(plant)
{
	new query[300];
	format(query, sizeof(query), "UPDATE `plants` SET `Owner` = %d, `Object` = %d, `PlantType` = %d, `PositionX` = %f, `PositionY` = %f, `PositionZ` = %f, `Virtual` = %d, \
	`Interior` = %d, `Growth` = %d, `Expires` = %d, `DrugsSkill` = %d WHERE `PlantID` = %d",Plants[plant][pOwner], Plants[plant][pObject], Plants[plant][pPlantType], Plants[plant][pPos][0], Plants[plant][pPos][1], Plants[plant][pPos][2],
	Plants[plant][pVirtual], Plants[plant][pInterior], Plants[plant][pGrowth], Plants[plant][pExpires], Plants[plant][pDrugsSkill], plant+1);
	mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
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

CMD:useheroin(playerid, params[])
{
	if(PlayerInfo[playerid][pHospital])
		return SendClientMessageEx(playerid, COLOR_GREY, "You cannot do this at this time.");
	if(PlayerInfo[playerid][pHeroin] < 10)
	    return SendClientMessageEx(playerid, COLOR_GREY, "You need at least 10 milligrams of heroin.");

	if(PlayerInfo[playerid][pSyringes] == 0)
	    return SendClientMessageEx(playerid, COLOR_GREY, "You don't have any syringes.");

    if(gettime()-GetPVarInt(playerid, "HeroinLastUsed") < 300)
		return SendClientMessageEx(playerid, COLOR_GRAD2, "You can only use heroin once every 5 minutes.");
	
	if(GetPVarType(playerid, "AttemptingLockPick")) 
		return SendClientMessageEx(playerid, COLOR_WHITE, "You are attempting a lockpick, please wait.");
	
    if(GetPVarInt(playerid, "Injured") != 1) {
		new szMessage[128];

		SetPVarInt(playerid, "HeroinLastUsed", gettime());
		PlayerInfo[playerid][pHeroin] -= 10;
		PlayerInfo[playerid][pSyringes] -= 1;

		SetPVarInt(playerid, "InjectHeroinStanding", SetTimerEx("InjectHeroinStanding", 5000, 0, "i", playerid));

		SendClientMessageEx(playerid, COLOR_GREEN, "You have injected heroin into yourself, the effects will begin in 5 seconds.");
		format(szMessage, sizeof(szMessage), "* %s injects heroin into himself.", GetPlayerNameEx(playerid));
		ProxDetector(25.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

		if(!IsPlayerInAnyVehicle(playerid)) ApplyAnimation(playerid,"SMOKING","M_smkstnd_loop",2.1,0,0,0,0,0);

        return 1;
	}

	new szMessage[128];

	SetPVarInt(playerid, "HeroinLastUsed", gettime());
	PlayerInfo[playerid][pHeroin] -= 10;
	PlayerInfo[playerid][pSyringes] -= 1;

	SetPVarInt(playerid, "Health", 30);
	SetPVarInt(playerid, "InjectHeroin", SetTimerEx("InjectHeroin", 5000, 0, "i", playerid));

	SendClientMessageEx(playerid, COLOR_GREEN, "You have injected heroin into yourself, the effects will begin in 5 seconds.");
	format(szMessage, sizeof(szMessage), "* %s injects heroin into himself.", GetPlayerNameEx(playerid));
	ProxDetector(25.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	return 1;
}

CMD:makeheroin(playerid, params[]) {

	if(!IsPlayerInRangeOfPoint(playerid, 5.0, -882.2048,1109.3385,5442.8193))
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

CMD:plantopiumseeds(playerid, params[]) {
	if(PlayerInfo[playerid][pJob] != 4 && PlayerInfo[playerid][pJob2] != 4 && PlayerInfo[playerid][pJob3] != 4) {
		SendClientMessageEx(playerid, COLOR_GREY, "   You're not a drug dealer.");
	}
 	else if(PlayerInfo[playerid][pOpiumSeeds] > 0) {
		if(PlayerInfo[playerid][pWeedObject] > 0)
		{
		    SendClientMessageEx(playerid, COLOR_GRAD2, "You already have a plant growing." );
		    return 1;
		}
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
				PlacePlant(i, GetPlayerSQLId(playerid), 2, 859, PlayerInfo[playerid][pDrugsSkill], xyz[0], xyz[1], xyz[2], GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
				SavePlant(i);
				new string[128];
				format(string, sizeof(string), "%s(%d) (IP:%s) has placed opium plant (%d)", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), i);
				Log("logs/plant.log", string);
				format(szMessage, sizeof(szMessage), "* %s plants some opium.", GetPlayerNameEx(playerid));
				ProxDetector(25.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				return 1;
			}
		}
		SendClientMessageEx(playerid, COLOR_GREY, "The server has reached the max number of plants.");
	}
	else SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough seeds to plant opium - head to the drug house and pick up some seeds (/getopiumseeds).");
	return 1;
}

CMD:plantpotseeds(playerid, params[]) {
	if(PlayerInfo[playerid][pJob] != 4 && PlayerInfo[playerid][pJob2] != 4 && PlayerInfo[playerid][pJob3] != 4) {
		SendClientMessageEx(playerid, COLOR_GREY, "   You're not a drug dealer.");
	}
 	else if(PlayerInfo[playerid][pWSeeds] > 0) {
		if(PlayerInfo[playerid][pWeedObject] > 0)
		{
		    SendClientMessageEx(playerid, COLOR_GRAD2, "You already have a plant growing." );
		    return 1;
		}
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

		        Plants[i][pDrugsSkill] = PlayerInfo[playerid][pDrugsSkill];
		        PlayerInfo[playerid][pWeedObject] = 1;
		        PlayerInfo[playerid][pWSeeds]--;
                PlacePlant(i, GetPlayerSQLId(playerid), 1, 19473, PlayerInfo[playerid][pDrugsSkill], xyz[0], xyz[1], xyz[2], GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
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
	else SendClientMessageEx(playerid, COLOR_GREY, "You don't have enough seeds to plant weed - head to the drug house and pick up some seeds (/getseeds).");
	return 1;
}

CMD:getopiumseeds(playerid, params[])
{
	if(PlayerInfo[playerid][pJob] != 4 && PlayerInfo[playerid][pJob2] != 4 && PlayerInfo[playerid][pJob3] != 4)
	    return SendClientMessageEx(playerid, COLOR_GREY, "You're not a drug dealer.");

	else if(PlayerInfo[playerid][pOpiumSeeds] == 3)
	    return SendClientMessageEx(playerid, COLOR_GREY, "You can only hold 3 bags of opium seeds.");

	else if(GetPlayerCash(playerid) < 75000)
	    return SendClientMessageEx(playerid, COLOR_GREY, "You don't have $75,000.");

	else {

    	for (new i=0; i<MAX_POINTS; i++)
  		{
	   		if (IsPlayerInRangeOfPoint(playerid, 3.0, Points[i][Pointx], Points[i][Pointy], Points[i][Pointz]) && Points[i][Type] == 3)
	   		{
			    if(Points[i][Stock] < 1 && PlayerInfo[playerid][pDonateRank] < 1) return SendClientMessageEx(playerid, COLOR_GREY, "   This drug house doesn't have any seeds.");
				if(PlayerInfo[playerid][pDonateRank] < 1)
				{
					new string[32];
					Points[i][Stock] -= 1;
					format(string, sizeof(string), " POT/OPIUM AVAILABLE: %d/1000.", Points[i][Stock]);
					UpdateDynamic3DTextLabelText(Points[i][TextLabel], COLOR_YELLOW, string);
				}
				PlayerInfo[playerid][pOpiumSeeds] += 1;
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have purchased a bag of opium seeds from the drug house.");
				GivePlayerCash(playerid, -75000);
				GameTextForPlayer(playerid, "~r~-$75000", 3000, 1 );
				for(new z = 0; z < MAX_GROUPS; z++)
				{
					if(strcmp(Points[i][Owner], arrGroupData[z][g_szGroupName], true) == 0)
					{
						arrGroupData[z][g_iBudget] += 2500;
					}
				}
				return 1;
			}
   		}
   		SendClientMessageEx(playerid, COLOR_GREY, "You are not at the drug house.");
	}
	return 1;
}

CMD:getseeds(playerid, params[])
{
    if(PlayerInfo[playerid][pJob] != 4 && PlayerInfo[playerid][pJob2] != 4 && PlayerInfo[playerid][pJob3] != 4)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "   You're not a drug dealer.");
		return 1;
	}
	if(PlayerInfo[playerid][pWSeeds] > 0)
	{
	    SendClientMessageEx(playerid, COLOR_GREY, "You already have a bag of seeds, use them first.");
	    return 1;
	}
	if(GetPlayerCash(playerid) < 10000)
	{
	    SendClientMessageEx(playerid, COLOR_GREY, " You do not have $10,000.");
	    return 1;
	}
	new mypoint = -1;
	for (new i=0; i<MAX_POINTS; i++)
  	{
	   	if (IsPlayerInRangeOfPoint(playerid, 3.0, Points[i][Pointx], Points[i][Pointy], Points[i][Pointz]) && Points[i][Type] == 3)
	   	{
			mypoint = i;
		}
   	}
   	if (mypoint == -1)
   	{
		SendClientMessageEx(playerid, COLOR_GREY, " You are not at the Drug House!");
		return 1;
   	}
	if(Points[mypoint][Stock] < 1 && PlayerInfo[playerid][pDonateRank] < 1) return SendClientMessageEx(playerid, COLOR_GREY, "   This drug house doesn't have any seeds.");
	if(PlayerInfo[playerid][pDonateRank] < 1)
	{
		new string[32];
		Points[mypoint][Stock] -= 1;
		format(string, sizeof(string), " POT/OPIUM AVAILABLE: %d/1000.", Points[mypoint][Stock]);
		UpdateDynamic3DTextLabelText(Points[mypoint][TextLabel], COLOR_YELLOW, string);
	}
	PlayerInfo[playerid][pWSeeds] += 3;
	SendClientMessageEx(playerid, COLOR_LIGHTBLUE, " You have purchased a bag of Pot Seeds from the Drug House. ");
	GivePlayerCash(playerid, -10000);
	GameTextForPlayer(playerid, "~r~-$10000", 3000, 1 );
	for(new i = 0; i < MAX_GROUPS; i++)
	{
		if(strcmp(Points[mypoint][Owner], arrGroupData[i][g_szGroupName], true) == 0)
		{
			arrGroupData[i][g_iBudget] += 2500;
		}
	}
	return 1;
}

CMD:adestroyplant(playerid, params[]) {
	if(PlayerInfo[playerid][pAdmin] >= 4) {

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

CMD:destroyplant(playerid, params[]) {
	if(IsACop(playerid) || IsAMedic(playerid)) {
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
							PlayerInfo[playerid][pPot] += Plants[i][pGrowth];
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

CMD:getcrate(playerid, params[])
{
	if (PlayerInfo[playerid][pJob] != 14 && PlayerInfo[playerid][pJob2] != 14 && PlayerInfo[playerid][pJob3] != 14)
	{
		SendClientMessageEx(playerid,COLOR_GREY,"   You are not a Drug Smuggler!");
		return 1;
	}
	new mypoint = -1;

	new playername[MAX_PLAYER_NAME];
	GetPlayerName(playerid, playername, sizeof(playername));
	for (new i=0; i<MAX_POINTS; i++)
	{
		if (IsPlayerInRangeOfPoint(playerid, 3.0, Points[i][Pointx], Points[i][Pointy], Points[i][Pointz]) && strcmp(Points[i][Name], "Drug Factory", true) == 0)
		{
			mypoint = i;
		}
	}
	if (mypoint == -1)
	{
		SendClientMessageEx(playerid, COLOR_GREY, " You are not at the Drug Factory!");
		return 1;
	}
	if(PlayerInfo[playerid][pCrates])
	{
		SendClientMessageEx(playerid, COLOR_GREY, "   You can't hold any more Drug Crates!");
		return 1;
	}
	if(GetPlayerCash(playerid) > 1000)
	{
		SendClientMessageEx(playerid, COLOR_LIGHTRED,"What type of drugs would you like to smuggle? (Type crack or pot)");
		SetPVarInt(playerid, "ChoosingDrugs", 1);
		return 1;
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREY," You can't afford the $1000!");
		return 1;
	}
}

CMD:getpot(playerid, params[])
{
	new string[128], amount;
	if(sscanf(params, "d", amount)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /getpot [amount]");

	new tel;
	new price;
	new level = PlayerInfo[playerid][pDrugsSkill];
	if(level >= 0 && level <= 50)
	{ tel = 100; if(amount < 1 || amount > 10) { SendClientMessageEx(playerid, COLOR_GREY, "   You cant go above 10 at your Skill Level!"); return 1; } }
	else if(level >= 51 && level <= 100)
	{ tel = 100; if(amount < 1 || amount > 20) { SendClientMessageEx(playerid, COLOR_GREY, "   You cant go above 20 at your Skill Level!"); return 1; } }
	else if(level >= 101 && level <= 200)
	{ tel = 100; if(amount < 1 || amount > 30) { SendClientMessageEx(playerid, COLOR_GREY, "   You cant go above 30 at your Skill Level!"); return 1; } }
	else if(level >= 201 && level <= 400)
	{ tel = 100; if(amount < 1 || amount > 40) { SendClientMessageEx(playerid, COLOR_GREY, "   You cant go above 40 at your Skill Level!"); return 1; } }
	else if(level >= 401)
	{ tel = 100; if(amount < 1 || amount > 50) { SendClientMessageEx(playerid, COLOR_GREY, "   You cant go above 50 at your Skill Level!"); return 1; } }
	new mypoint = -1;
	for (new i=0; i<MAX_POINTS; i++)
	{
		if (IsPlayerInRangeOfPoint(playerid, 3.0, Points[i][Pointx], Points[i][Pointy], Points[i][Pointz]) && Points[i][Type] == 3)
		{
			mypoint = i;
		}
	}
	if (mypoint == -1)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You aren't at the Drug House!");
		return 1;
	}
	if ( PlayerInfo[playerid][pPot] >= 25)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "You have reached your pot limit of 25 pot.");
		return 1;
	}
	if (PlayerInfo[playerid][pJob] == 4 || PlayerInfo[playerid][pJob2] == 4 || PlayerInfo[playerid][pJob3] == 4)
	{
		price = amount * tel;
		if(Points[mypoint][Stock] < amount && PlayerInfo[playerid][pDonateRank] < 1) return SendClientMessageEx(playerid, COLOR_GREY, "   This Drug House doesn't have that much pot!");
		if(GetPlayerCash(playerid) > price)
		{
			format(string, sizeof(string), "* You bought %d grams for $%d.", amount, price);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
			GivePlayerCash(playerid, -price);
			PlayerInfo[playerid][pPot] += amount;
			if(PlayerInfo[playerid][pDonateRank] < 1)
			{
				Points[mypoint][Stock] -= amount;
				format(string, sizeof(string), " POT/OPIUM AVAILABLE: %d/1000.", Points[mypoint][Stock]);
				UpdateDynamic3DTextLabelText(Points[mypoint][TextLabel], COLOR_YELLOW, string);
			}
			for(new i = 0; i < MAX_GROUPS; i++)
			{
				if(strcmp(Points[mypoint][Owner], arrGroupData[i][g_szGroupName], true) == 0)
				{
					arrGroupData[i][g_iBudget] += price/2;
				}
			}
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "You can't afford the drugs!");
			return 1;
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You're not a drug dealer.");
		return 1;
	}
	return 1;
}

CMD:getcrack(playerid, params[])
{
	new string[128], amount;
	if(sscanf(params, "d", amount)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /getcrack [amount]");

	new tel;
	new price;
	new level = PlayerInfo[playerid][pDrugsSkill];
	if(level >= 0 && level <= 50)
	{
		tel = 500;
		if(amount < 1 || amount > 5)
		{
			SendClientMessageEx(playerid, COLOR_GREY, "   You can't go above 5 at your Skill Level!");
			return 1;
		}
	}
	else if(level >= 51 && level <= 100)
	{ tel = 500; if(amount < 1 || amount > 5) { SendClientMessageEx(playerid, COLOR_GREY, "   You can't go above 10 at your Skill Level!"); return 1; } }
	else if(level >= 101 && level <= 200)
	{ tel = 500; if(amount < 1 || amount > 15) { SendClientMessageEx(playerid, COLOR_GREY, "   You can't go above 15 at your Skill Level!"); return 1; } }
	else if(level >= 201 && level <= 400)
	{ tel = 500; if(amount < 1 || amount > 20) { SendClientMessageEx(playerid, COLOR_GREY, "   You can't go above 20 at your Skill Level!"); return 1; } }
	else if(level >= 401)
	{ tel = 500; if(amount < 1 || amount > 25) { SendClientMessageEx(playerid, COLOR_GREY, "   You can't go above 25 at your Skill Level!"); return 1; } }
	new mypoint = -1;
	for (new i=0; i<MAX_POINTS; i++)
	{
		if (IsPlayerInRangeOfPoint(playerid, 3.0, Points[i][Pointx], Points[i][Pointy], Points[i][Pointz]) && Points[i][Type] == 4)
		{
			mypoint = i;
		}
	}
	if (mypoint == -1)
	{
		SendClientMessageEx(playerid, COLOR_GREY, " You are not at the Crack Lab!");
		return 1;
	}
	if ( PlayerInfo[playerid][pCrack] >= 25)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, " You have reached your crack limit of 25 crack.");
		return 1;
	}
	if (PlayerInfo[playerid][pJob] == 4 || PlayerInfo[playerid][pJob2] == 4 || PlayerInfo[playerid][pJob3] == 4)
	{
		price = amount * tel;
		if(Points[mypoint][Stock] < amount && PlayerInfo[playerid][pDonateRank] < 1) return SendClientMessageEx(playerid, COLOR_GREY, "   This Crack Lab doesn't have that much crack!");
		if(GetPlayerCash(playerid) > price)
		{
			format(string, sizeof(string), "* You bought %d grams for $%d.", amount, price);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
			GivePlayerCash(playerid, -price);
			PlayerInfo[playerid][pCrack] += amount;
			if(PlayerInfo[playerid][pDonateRank] < 1) Points[mypoint][Stock] = Points[mypoint][Stock]-amount;
			format(string, sizeof(string), " CRACK AVAILABLE: %d/500.", Points[mypoint][Stock]);
			UpdateDynamic3DTextLabelText(Points[mypoint][TextLabel], COLOR_YELLOW, string);
			for(new i = 0; i < MAX_GROUPS; i++)
			{
				if(strcmp(Points[mypoint][Owner], arrGroupData[i][g_szGroupName], true) == 0)
				{
					arrGroupData[i][g_iBudget] += price/2;
				}
			}
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "   You cant afford the Drugs!");
			return 1;
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREY, "   You're not a drug dealer.");
		return 1;
	}
	return 1;
}

CMD:usepot(playerid, params[])
{
	if(HungerPlayerInfo[playerid][hgInEvent] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "   You cannot do this while being in the Hunger Games Event!");
	#if defined zombiemode
	if(zombieevent == 1 && GetPVarType(playerid, "pIsZombie")) return SendClientMessageEx(playerid, COLOR_GREY, "Zombies can't use this.");
	#endif
	if(GetPVarType(playerid, "PlayerCuffed") || GetPVarType(playerid, "Injured") || GetPVarType(playerid, "IsFrozen") || PlayerInfo[playerid][pHospital] || PlayerInfo[playerid][pJailTime] > 0) {
   		return SendClientMessage(playerid, COLOR_GRAD2, "You can't do that at this time!");
	}
	if(GetPVarType(playerid, "AttemptingLockPick")) return SendClientMessageEx(playerid, COLOR_WHITE, "You are attempting a lockpick, please wait.");
	if(GetPVarInt(playerid, "IsInArena") >= 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this while being in an arena!");
		return 1;
	}
	if(PlayerBoxing[playerid] > 0)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You can't use drugs while you're fighting.");
		return 1;
	}
	if(UsedWeed[playerid] == 1)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You must wait 5 seconds before using more drugs.");
		return 1;
	}
	new string[128], Float:health, healthint, storageid;

	/*if(sscanf(params, "d", storageid)) {
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /usepot [storageid]");
		SendClientMessageEx(playerid, COLOR_GREY, "StorageIDs: (0) Pocket - (1) Equipped Storage Device");
		return 1;
	}

	if(storageid < 0 || storageid > 1) {
		SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /usepot [storageid]");
		SendClientMessageEx(playerid, COLOR_GREY, "StorageIDs: (0) Pocket - (1) Equipped Storage Device");
		return 1;
	}

	// Find the storageid of the storagedevice.
	if(storageid == 1) {
		new bool:itemEquipped = false;
		for(new i = 0; i < 3; i++)
		{
			if(StorageInfo[playerid][i][sAttached] == 1) {
				storageid = i+1;
				itemEquipped = true;
			}
		}
		if(itemEquipped == false) return SendClientMessageEx(playerid, COLOR_WHITE, "You don't have a storage device equipped!");
	}*/

	if(storageid == 0 && PlayerInfo[playerid][pPot] > 1 || (storageid > 0) && StorageInfo[playerid][storageid-1][sPot] > 1)
	{
		GetHealth(playerid, health);
		healthint = floatround(health, floatround_round);
		if(healthint >= 100 )
		{
			SendClientMessageEx(playerid, COLOR_GREY, "You already have full health.");
			return 1;
		}
		if(PlayerStoned[playerid] > 3) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are too stoned to use pot.");
		PlayerStoned[playerid] += 1;
		if(PlayerStoned[playerid] == 3)
		{
			GameTextForPlayer(playerid, "~w~you are ~b~stoned", 5000, 3);
		}
		if(healthint > 80)
		{
			SetHealth(playerid, 100);
		}
		else
		{
			SetHealth(playerid, health + 20.0);
		}
		SendClientMessageEx(playerid, COLOR_GREY, " You used 2 grams of pot!");
		format(string, sizeof(string), "* %s has used some pot.", GetPlayerNameEx(playerid));
		ProxDetector(15.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

		if(storageid == 0) {
			PlayerInfo[playerid][pPot] -= 2;
		} else {
			StorageInfo[playerid][storageid-1][sPot] -= 2;
		}

		UsedWeed[playerid] = 1;
		SetTimerEx("ClearDrugs", 5000, false, "d", playerid);
		if(!IsPlayerInAnyVehicle(playerid)) ApplyAnimation(playerid,"SMOKING","M_smkstnd_loop",2.1,0,0,0,0,0);
		switch(GetPVarInt(playerid, "STD")) {
			case 1:
			{
				DeletePVar(playerid, "STD");
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You are no longer infected with a STD anymore because of the Drugs!");
			}
			case 2:
			{
				SetPVarInt(playerid, "STD", 1);
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You reduced the STI to chlamydia because of the drugs!");
			}
			case 3:
			{
				SetPVarInt(playerid, "STD", 2);
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You reduced the STI to gonorrhea because of the drugs!");
			}
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You don't have any pot left!");
	}
	return 1;
}

CMD:usecrack(playerid, params[])
{
	if(HungerPlayerInfo[playerid][hgInEvent] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "   You cannot do this while being in the Hunger Games Event!");
    #if defined zombiemode
	if(zombieevent == 1 && GetPVarType(playerid, "pIsZombie")) return SendClientMessageEx(playerid, COLOR_GREY, "Zombies can't use this.");
	#endif
	if(GetPVarType(playerid, "PlayerCuffed") || GetPVarType(playerid, "Injured") || GetPVarType(playerid, "IsFrozen") || PlayerInfo[playerid][pHospital] || PlayerInfo[playerid][pJailTime] > 0) {
   		return SendClientMessage(playerid, COLOR_GRAD2, "You can't do that at this time!");
	}
	if(GetPVarType(playerid, "AttemptingLockPick")) return SendClientMessageEx(playerid, COLOR_WHITE, "You are attempting a lockpick, please wait.");
	if(GetPVarInt(playerid, "IsInArena") >= 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this while being in an arena!");
		return 1;
	}
	if(PlayerBoxing[playerid] > 0)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You can't use drugs while you're fighting.");
		return 1;
	}
	if(UsedCrack[playerid] == 1)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You must wait 5 seconds before using more drugs.");
		return 1;
	}
	new Float:armour;
	GetArmour(playerid, armour);
	if(armour >= 100)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You already have full armor.");
		return 1;
	}

	new storageid;
	/*if(sscanf(params, "d", storageid)) {
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /usecrack [storageid]");
		SendClientMessageEx(playerid, COLOR_GREY, "StorageIDs: (0) Pocket - (1) Equipped Storage Device");
		return 1;
	}

	if(storageid < 0 || storageid > 1) {
		SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /usecrack [storageid]");
		SendClientMessageEx(playerid, COLOR_GREY, "StorageIDs: (0) Pocket - (1) Equipped Storage Device");
		return 1;
	}

	// Find the storageid of the storagedevice.
	if(storageid == 1) {
		new bool:itemEquipped = false;
		for(new i = 0; i < 3; i++)
		{
			if(StorageInfo[playerid][i][sAttached] == 1) {
				storageid = i+1;
				itemEquipped = true;
			}
		}
		if(itemEquipped == false) return SendClientMessageEx(playerid, COLOR_WHITE, "You don't have a storage device equipped!");
	}*/

	if(storageid == 0 && PlayerInfo[playerid][pCrack] > 1 || (storageid > 0) && StorageInfo[playerid][storageid-1][sCrack] > 1)
	{
		if(PlayerStoned[playerid] > 3) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are too stoned to use crack.");
		PlayerStoned[playerid] += 1;
		if(PlayerStoned[playerid] == 3)
		{
			GameTextForPlayer(playerid, "~w~you are ~b~stoned", 5000, 3);
		}
		new string[128], Float:PlayersArmour;
		GetArmour(playerid, PlayersArmour);
		SendClientMessageEx(playerid, COLOR_GREY, " You used 2 grams of crack!");
		format(string, sizeof(string), "* %s has used some crack.", GetPlayerNameEx(playerid));
		ProxDetector(15.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

		if(storageid == 0) {
			PlayerInfo[playerid][pCrack] -= 2;
		} else {
			StorageInfo[playerid][storageid-1][sCrack] -= 2;
		}
		UsedCrack[playerid] = 1;
		SetTimerEx("ClearDrugs", 5000, false, "d", playerid);
		if(PlayersArmour > 90)
		{
			SetArmour(playerid, 100);
		}
		else
		{
			SetArmour(playerid, PlayersArmour + 10.0);
		}
		if(!IsPlayerInAnyVehicle(playerid)) ApplyAnimation(playerid,"SMOKING","M_smkstnd_loop",2.1,0,0,0,0,0);
		switch(GetPVarInt(playerid, "STD")) {
			case 1:
			{
				DeletePVar(playerid, "STD");
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You are no longer infected with an STI anymore because of the drugs!");
			}
			case 2:
			{
				SetPVarInt(playerid, "STD", 1);
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You reduced the STI to chlamydia because of the drugs!");
			}
			case 3:
			{
				SetPVarInt(playerid, "STD", 2);
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* You reduced the STI to gonorrhea because of the drugs!");
			}
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You don't have any crack left!");
	}
	return 1;
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