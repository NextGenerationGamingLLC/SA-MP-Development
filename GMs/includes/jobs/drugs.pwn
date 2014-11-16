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

CMD:useheroin(playerid, params[])
{
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
				for(new z = 0; z < sizeof(FamilyInfo); z++)
				{
					if(strcmp(Points[i][Owner], FamilyInfo[z][FamilyName], true) == 0)
					{
						FamilyInfo[z][FamilyBank] += 2500;
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
	for(new i = 0; i < sizeof(FamilyInfo); i++)
	{
		if(strcmp(Points[mypoint][Owner], FamilyInfo[i][FamilyName], true) == 0)
		{
			FamilyInfo[i][FamilyBank] += 2500;
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

                    //foreach(new z : Player)
					for(new z = 0; z < MAX_PLAYERS; ++z)
					{
						if(IsPlayerConnected(z))
						{
							if(Plants[i][pOwner] == GetPlayerSQLId(z))
							{
								PlayerInfo[z][pWeedObject] = 0;
							}
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
							//foreach(new z : Player)
							for(new z = 0; z < MAX_PLAYERS; ++z)
							{
								if(IsPlayerConnected(z))
								{
									if(Plants[i][pOwner] == GetPlayerSQLId(z))
									{
										PlayerInfo[z][pWeedObject] = 0;
									}
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
							//foreach(new z : Player)
							for(new z = 0; z < MAX_PLAYERS; ++z)
							{
								if(IsPlayerConnected(z))
								{
									if(Plants[i][pOwner] == GetPlayerSQLId(z))
									{
										PlayerInfo[z][pWeedObject] = 0;
									}
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
                            //foreach(new z : Player)
							for(new z = 0; z < MAX_PLAYERS; ++z)
							{
								if(IsPlayerConnected(z))
								{
									if(Plants[i][pOwner] == GetPlayerSQLId(z))
									{
										PlayerInfo[z][pWeedObject] = 0;
									}
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
							//foreach(new z : Player)
							for(new z = 0; z < MAX_PLAYERS; ++z)
							{
								if(IsPlayerConnected(z))
								{
									if(Plants[i][pOwner] == GetPlayerSQLId(z))
									{
										PlayerInfo[z][pWeedObject] = 0;
									}
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
