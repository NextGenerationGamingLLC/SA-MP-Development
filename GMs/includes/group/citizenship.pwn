/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

					Citizenship System

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
/*
NationSel_InitNationNameText(Text:txtInit)
{
  	TextDrawUseBox(txtInit, 0);
	TextDrawLetterSize(txtInit,1.25,3.0);
	TextDrawFont(txtInit, 0);
	TextDrawSetShadow(txtInit,0);
    TextDrawSetOutline(txtInit,1);
    TextDrawColor(txtInit,0xEEEEEEFF);
    TextDrawBackgroundColor(txtNationSelHelper,0x000000FF);
}

NationSel_InitTextDraws()
{
    // Init our observer helper text display
	txtSanAndreas = TextDrawCreate(10.0, 380.0, "San Andreas");
	NationSel_InitNationNameText(txtSanAndreas);
	txtTierraRobada = TextDrawCreate(10.0, 380.0, "Tierro Robada");
	NationSel_InitNationNameText(txtTierraRobada);

    // Init our observer helper text display
	txtNationSelHelper = TextDrawCreate(10.0, 415.0,
	   " Press ~b~~k~~GO_LEFT~ ~w~or ~b~~k~~GO_RIGHT~ ~w~to switch cities.~n~ Press ~r~~k~~PED_FIREWEAPON~ ~w~to select.");
	TextDrawUseBox(txtNationSelHelper, 1);
	TextDrawBoxColor(txtNationSelHelper,0x222222BB);
	TextDrawLetterSize(txtNationSelHelper,0.3,1.0);
	TextDrawTextSize(txtNationSelHelper,400.0,40.0);
	TextDrawFont(txtNationSelHelper, 2);
	TextDrawSetShadow(txtNationSelHelper,0);
    TextDrawSetOutline(txtNationSelHelper,1);
    TextDrawBackgroundColor(txtNationSelHelper,0x000000FF);
    TextDrawColor(txtNationSelHelper,0xFFFFFFFF);

	txtNationSelMain = TextDrawCreate(10.0, 50.0, "Select Your Nation");
	TextDrawUseBox(txtNationSelMain, 0);
	TextDrawLetterSize(txtNationSelMain, 1.25, 3.0);
	TextDrawFont(txtNationSelMain, 1);
	TextDrawSetShadow(txtNationSelMain, 0);
    TextDrawSetOutline(txtNationSelMain, 1);
    TextDrawBackgroundColor(txtNationSelMain, 0x000000FF);
    TextDrawColor(txtNationSelMain, 0xFFFFFFFF);
}

NationSel_SetupSelectedNation(playerid)
{
	if(PlayerNationSelection[playerid] == -1) {
		PlayerNationSelection[playerid] = NATION_SAN_ANDREAS;
	}

	if(PlayerNationSelection[playerid] == NATION_SAN_ANDREAS) {
		SetPlayerInterior(playerid,0);
   		SetPlayerCameraPos(playerid,1630.6136,-2286.0298,110.0);
		SetPlayerCameraLookAt(playerid,1887.6034,-1682.1442,47.6167);

		TextDrawShowForPlayer(playerid,txtSanAndreas);
		TextDrawHideForPlayer(playerid,txtTierraRobada);
	}
	else if(PlayerNationSelection[playerid] == NATION_TIERRA_ROBADA) {
		SetPlayerInterior(playerid,0);
   		SetPlayerCameraPos(playerid,1310.6155,1675.9182,110.7390);
		SetPlayerCameraLookAt(playerid,2285.2944,1919.3756,68.2275);

		TextDrawHideForPlayer(playerid,txtSanAndreas);
		TextDrawShowForPlayer(playerid,txtTierraRobada);
	}
}

NationSel_SwitchToNextNation(playerid)
{
    PlayerNationSelection[playerid]++;
	if(PlayerNationSelection[playerid] > NATION_TIERRA_ROBADA) {
	    PlayerNationSelection[playerid] = NATION_SAN_ANDREAS;
	}
	PlayerPlaySound(playerid,1052,0.0,0.0,0.0);
	NationSel_SetupSelectedNation(playerid);
}

NationSel_SwitchToPrevNation(playerid)
{
    PlayerNationSelection[playerid]--;
	if(PlayerNationSelection[playerid] < NATION_SAN_ANDREAS) {
	    PlayerNationSelection[playerid] = NATION_TIERRA_ROBADA;
	}
	PlayerPlaySound(playerid,1053,0.0,0.0,0.0);
	NationSel_SetupSelectedNation(playerid);
}

NationSel_HandleNationSelection(playerid)
{
	new Keys,ud,lr;
	new Float:diff = float(TRCitizens)/float(TotalCitizens)*100;
    GetPlayerKeys(playerid,Keys,ud,lr);

    if(PlayerNationSelection[playerid] == -1) {
		NationSel_SwitchToNextNation(playerid);
		return;
	}

	if(Keys & KEY_FIRE)
	{
	    PlayerHasNationSelected[playerid] = 1;
	    TextDrawHideForPlayer(playerid,txtNationSelHelper);
		TextDrawHideForPlayer(playerid,txtNationSelMain);
		TextDrawHideForPlayer(playerid,txtSanAndreas);
		TextDrawHideForPlayer(playerid,txtTierraRobada);
		RegistrationStep[playerid] = 0;
	    PlayerInfo[playerid][pTut] = 1;
		gOoc[playerid] = 0; gNews[playerid] = 0;
		TogglePlayerControllable(playerid, 1);
		SetCamBack(playerid);
		DeletePVar(playerid, "MedicBill");
		SetPlayerColor(playerid,TEAM_HIT_COLOR);
		SetPlayerInterior(playerid,0);
		SetHealth(playerid, 100);
		for(new x;x<10000;x++)
		{
			new rand=random(300);
			if(PlayerInfo[playerid][pSex] == 2)
			{
				if(IsValidSkin(rand) && IsFemaleSpawnSkin(rand))
				{
					PlayerInfo[playerid][pModel] = rand;
					SetPlayerSkin(playerid, rand);
					break;
				}
			}
			else
			{
				if(IsValidSkin(rand) && !IsFemaleSkin(rand))
				{
					PlayerInfo[playerid][pModel] = rand;
					SetPlayerSkin(playerid, rand);
					break;
				}
			}
		}
		SetCameraBehindPlayer(playerid);
		SetPlayerVirtualWorld(playerid, 0);
		if(NATION_SAN_ANDREAS == PlayerNationSelection[playerid])
		{
			PlayerInfo[playerid][pNation] = 0;
			switch(random(2))
			{
				case 0:
				{
					SetPlayerPos(playerid, 1715.1201,-1903.1711,13.5665);
					SetPlayerFacingAngle(playerid, 360.0);
				}
				case 1:
				{
					SetPlayerPos(playerid, -1969.0737,138.1210,27.6875);
					SetPlayerFacingAngle(playerid, 90.0);
				}
			}
		}
		else if(NATION_TIERRA_ROBADA == PlayerNationSelection[playerid])
		{
			if(floatround(diff) >= 30)
			{
				AddNationQueue(playerid, 1, 1);
				SendClientMessageEx(playerid, COLOR_RED, "The nation of New Robada is currently full. You have been placed into a queue to join.");
				switch(random(2))
				{
					case 0:
					{
						SetPlayerPos(playerid, 1715.1201,-1903.1711,13.5665);
						SetPlayerFacingAngle(playerid, 360.0);
					}
					case 1:
					{
						SetPlayerPos(playerid, -1969.0737,138.1210,27.6875);
						SetPlayerFacingAngle(playerid, 90.0);
					}
				}
			}
			else
			{
				AddNationQueue(playerid, 1, 2);
				switch(random(2))
				{
					case 0:
					{
						SetPlayerPos(playerid, 1699.2, 1435.1, 10.7);
						SetPlayerFacingAngle(playerid, 270.0);
					}
					case 1:
					{
						SetPlayerPos(playerid, -1446.5997, 2608.4478, 55.8359);
						SetPlayerFacingAngle(playerid, 180.0);
					}
				}
			}
		}
	    return;
	}

	if(lr > 0) {
	   NationSel_SwitchToNextNation(playerid);
	}
	else if(lr < 0) {
	   NationSel_SwitchToPrevNation(playerid);
	}
}*/


stock NationCheck(playerid, giveplayerid) {

	if(PlayerInfo[playerid][pNation] != PlayerInfo[giveplayerid][pNation]) {
		SendClientMessageEx(playerid, COLOR_GRAD1, "This person is not part of your nation and can therefore not be processed.");
		return 0;
	}
	return 1;
}

stock GetPlayerNation(playerid) {

	szMiscArray[0] = 0;
	switch(PlayerInfo[playerid][pNation]) {
		case 0: szMiscArray = "San Andreas";
		case 1: szMiscArray = "New Robada";
		case 2: szMiscArray = "None";
	}
	return szMiscArray;
}

CMD:apply(playerid, params[])
{
	new choice[3];
	if(sscanf(params, "s[3]", choice))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /apply [SA|NR]");
		return 1;
	}
	if(PlayerInfo[playerid][pFreezeBank] || PlayerInfo[playerid][pFreezeHouse] || PlayerInfo[playerid][pFreezeCar]) {
		return SendClientMessageEx(playerid, COLOR_GRAD1, "The current nation you're in has frozen your assets. Therefore, you cannot apply.");
	}

	if(strcmp(choice, "sa", true) == 0)
	{
		if(PlayerInfo[playerid][pNation] == 0) return SendClientMessageEx(playerid, COLOR_GREY, "You're currently part of San Andreas.");
		CheckNationQueue(playerid, 0);
	}
	else if(strcmp(choice, "nr", true) == 0)
	{
		if(PlayerInfo[playerid][pNation] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "You're currently part of New Robada.");
		CheckNationQueue(playerid, 1);
	}
	return 1;
}

CMD:checkapps(playerid, params[])
{
	if((0 <= PlayerInfo[playerid][pLeader] < MAX_GROUPS) && arrGroupData[PlayerInfo[playerid][pLeader]][g_iGroupType] == GROUP_TYPE_GOV)
	{
		switch(arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance])
		{
			case 1: mysql_tquery(MainPipeline, "SELECT `playerid`, `name`, `date` FROM `nation_queue` WHERE `nation` = 0 AND `status` = 1 ORDER BY `id` ASC", "NationQueueQueryFinish", "iii", playerid, 0, AppQueue);
			case 2: mysql_tquery(MainPipeline, "SELECT `playerid`, `name`, `date` FROM `nation_queue` WHERE `nation` = 1 AND `status` = 1 ORDER BY `id` ASC", "NationQueueQueryFinish", "iii", playerid, 1, AppQueue);
		}
	}
	else SendClientMessage(playerid, COLOR_GREY, "You are not the leader of a Government agency.");
	return 1;
}

CMD:deport(playerid, params[])
{
	if((0 <= PlayerInfo[playerid][pLeader] < MAX_GROUPS) && arrGroupData[PlayerInfo[playerid][pLeader]][g_iGroupType] == GROUP_TYPE_GOV)
	{
   		new string[128], giveplayerid;
		if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /deport [player]");
		if(!IsPlayerConnected(giveplayerid)) SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");
		else if(!ProxDetectorS(5.0, playerid, giveplayerid)) SendClientMessageEx(playerid, COLOR_GREY, "You are not close enough to the deportee.");
		else if(PlayerInfo[playerid][pNation] == 0 && PlayerInfo[giveplayerid][pNation] == 0) SendClientMessageEx(playerid, COLOR_GREY, "You can't deport a citizen of San Andreas!");
		else
		{
			format(string, sizeof(string), "* You deported %s!", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
			DeletePVar(giveplayerid, "IsFrozen");
			TogglePlayerControllable(giveplayerid, 1);
			ClearAnimationsEx(giveplayerid);
			SetPlayerSpecialAction(giveplayerid, SPECIAL_ACTION_NONE);
			PlayerCuffed[giveplayerid] = 0;
			DeletePVar(giveplayerid, "PlayerCuffed");
			PlayerCuffedTime[giveplayerid] = 0;
			if(PlayerInfo[playerid][pNation] == 0 && PlayerInfo[giveplayerid][pNation] == 1)
			{
				switch(random(2))
				{
					case 0:
					{
						SetPlayerPos(giveplayerid, 2231.578613, -48.729660, 26.484375);
						SetPlayerFacingAngle(giveplayerid, 270.0);
					}
					case 1:
					{
						SetPlayerPos(giveplayerid, 2231.578613, -48.729660, 26.484375);
						SetPlayerFacingAngle(giveplayerid, 180.0);
					}
				}
				SendClientMessageEx(giveplayerid, COLOR_RED, "You have been deported back to New Robada.");
			}
			else if(PlayerInfo[playerid][pNation] == 1 && PlayerInfo[giveplayerid][pNation] == 0)
			{
				switch(random(2))
				{
					case 0:
					{
						SetPlayerPos(giveplayerid, 1715.1201,-1903.1711,13.5665);
						SetPlayerFacingAngle(giveplayerid, 360.0);
					}
					case 1:
					{
						SetPlayerPos(giveplayerid, -1969.0737,138.1210,27.6875);
						SetPlayerFacingAngle(giveplayerid, 90.0);
					}
				}
				SendClientMessageEx(giveplayerid, COLOR_RED, "You have been deported back to San Andreas.");
			}
			else if(PlayerInfo[playerid][pNation] == 0 && PlayerInfo[giveplayerid][pNation] == 0)
			{
				switch(random(2))
				{
					case 0:
					{
						SetPlayerPos(giveplayerid, 1715.1201,-1903.1711,13.5665);
						SetPlayerFacingAngle(giveplayerid, 360.0);
					}
					case 1:
					{
						SetPlayerPos(giveplayerid, -1969.0737,138.1210,27.6875);
						SetPlayerFacingAngle(giveplayerid, 90.0);
					}
				}
				PlayerInfo[giveplayerid][pNation] = 2;
				SendClientMessageEx(giveplayerid, COLOR_RED, "You were deported from your country. You have lost your citizenship.");
			}
			else if(PlayerInfo[playerid][pNation] == 1 && PlayerInfo[giveplayerid][pNation] == 1)
			{
				switch(random(2))
				{
					case 0:
					{
						SetPlayerPos(giveplayerid, 1715.1201,-1903.1711,13.5665);
						SetPlayerFacingAngle(giveplayerid, 360.0);
					}
					case 1:
					{
						SetPlayerPos(giveplayerid, -1969.0737,138.1210,27.6875);
						SetPlayerFacingAngle(giveplayerid, 90.0);
					}
				}
				PlayerInfo[giveplayerid][pNation] = 2;
				SendClientMessageEx(giveplayerid, COLOR_RED, "You were deported from your country. You have lost your citizenship.");
			}
	    }
	}
	else SendClientMessage(playerid, COLOR_GREY, "You are not the leader of a Government agency.");
	return 1;
}

// Citizenship Commands
/*CMD:grantcitizenship(playerid, params[]) {

	new iGroupID = PlayerInfo[playerid][pLeader];

	if((0 <= iGroupID < MAX_GROUPS)) {


	}
	else SendClientMessageEx(playerid, COLOR_GRAD1, "Only authorized business employees may use this command.");
	return 1;
}*/
