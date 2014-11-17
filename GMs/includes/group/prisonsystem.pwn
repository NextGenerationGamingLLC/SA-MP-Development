/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Prison System

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

CMD:bail(playerid, params[])
{
	if(PlayerInfo[playerid][pJailTime] > 0)
	{
		if(JailPrice[playerid] > 0)
		{
			if(GetPlayerCash(playerid) > JailPrice[playerid])
			{
				new string[128];
				format(string, sizeof(string), "You bailed yourself out for $%d.", JailPrice[playerid]);
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
				GivePlayerCash(playerid, -JailPrice[playerid]);
				JailPrice[playerid] = 0;
				WantLawyer[playerid] = 0; CallLawyer[playerid] = 0;
				PlayerInfo[playerid][pJailTime] = 1;
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GRAD1, "You can't afford the bail price.");
			}
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GRAD1, "You don't have a bail price.");
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You're not in jail.");
	}
	return 1;
}

CMD:backentrance(playerid, params[])
{
	if(IsACop(playerid) && PlayerInfo[playerid][pRank] >= 3) {
	    if(BackEntrance) {
	        BackEntrance = 0;
	        SendClientMessageEx(playerid, COLOR_WHITE, "The back entrance has been locked.");
	    }
	    else {
	        BackEntrance = 1;
	        SendClientMessageEx(playerid, COLOR_WHITE, "The back entrance has been unlocked.");
	    }
	}
	else SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use this command.");
	return 1;
}

/*CMD:isolate(playerid, params[])
{
	if(!IsACop(playerid)) {
	    SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use this command!");
	}

	else {

		new
		    iGivePlayer,
			szMessage[128];

	    if(sscanf(params, "u", iGivePlayer)) {
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /isolate [player]");
		}
		else if(iGivePlayer == playerid) {
		    SendClientMessageEx(playerid, COLOR_GREY, "You can't use this command on yourself!");
		}
		else if(!IsPlayerConnected(iGivePlayer)) {
			SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");
		}
		else if(!ProxDetectorS(10.0, playerid, iGivePlayer)) {
		    SendClientMessageEx(playerid, COLOR_GREY, "That person is to far from you.");
		}
		else {
			if(strfind(PlayerInfo[iGivePlayer][pPrisonReason], "[IC]", true) != -1)
   			{
                strcpy(PlayerInfo[iGivePlayer][pPrisonReason], "[ISOLATE] EBCF Arrest", 128);
         		format(szMessage, sizeof(szMessage), "You have sent %s to isolation.", GetPlayerNameEx(iGivePlayer));
           		SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
            	format(szMessage, sizeof(szMessage), "%s has sent you to isolation.", GetPlayerNameEx(playerid));
	            SendClientMessageEx(iGivePlayer, COLOR_WHITE, szMessage);
	            SetPlayerPos(iGivePlayer, -2095.3391, -215.8563, 978.8315);

	        }
	        else if(strfind(PlayerInfo[iGivePlayer][pPrisonReason], "[ISOLATE]", true) != -1)
	        {
         		new rand;
           		strcpy(PlayerInfo[iGivePlayer][pPrisonReason], "[IC] EBCF Arrest", 128);
	            format(szMessage, sizeof(szMessage), "You have released %s from isolation.", GetPlayerNameEx(iGivePlayer));
	            SendClientMessageEx(playerid, COLOR_WHITE, szMessage);
	            format(szMessage, sizeof(szMessage), "%s has released you from isolation.", GetPlayerNameEx(playerid));
	            SendClientMessageEx(iGivePlayer, COLOR_WHITE, szMessage);
          		rand = random(sizeof(DocPrison));
				SetPlayerPos(iGivePlayer, DocPrison[rand][0], DocPrison[rand][1], DocPrison[rand][2]);
		    }
		    else SendClientMessageEx(playerid, COLOR_WHITE, "That person isn't imprisoned.");
		}
	}
	return 1;
}*/

CMD:docarrest(playerid, params[])
{
	if(!IsACop(playerid)) SendClientMessageEx(playerid, COLOR_GREY, "You are not part of a LEO faction. ");
	else if(!IsAtArrestPoint(playerid, 2)) SendClientMessageEx(playerid, COLOR_GREY, "You are not at the DoC Prison arrest point." );

	else
	{
   		new
     		//moneys,
       		//time,
			string[256];

        new suspect = GetClosestPlayer(playerid);
  		/*if(sscanf(params, "dddd", moneys, time)) SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /docarrest [fine] [minutes]");
		else if(!(1 <= moneys <= 250000)) SendClientMessageEx(playerid, COLOR_GREY, "The jail fine can't be below $1 or above $250,000.");
		else if(!(1 <= time <= 120)) SendClientMessageEx(playerid, COLOR_GREY, "Jail time can't be below 1 or above 120 minutes - take the person to prison for more time.");*/
		if(!IsPlayerConnected(suspect)) SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");
		else if(!ProxDetectorS(5.0, playerid, suspect)) SendClientMessageEx(playerid, COLOR_GREY, "You are close enough to the suspect.");
		else if(PlayerInfo[suspect][pWantedLevel] < 1 && PlayerInfo[playerid][pMember] != 12) SendClientMessageEx(playerid, COLOR_GREY, "The person must have a wanted level of at least one star.");
		else {
			SetPVarInt(playerid, "Arrest_Price", PlayerInfo[suspect][pWantedJailFine]);
			SetPVarInt(playerid, "Arrest_Time", PlayerInfo[suspect][pWantedJailTime]);
			SetPVarInt(playerid, "Arrest_Suspect", suspect);
			SetPVarInt(playerid, "Arrest_Type", 2);
			format(string, sizeof(string), "Please write a brief arrest report on how %s acted during the arrest.\n\nThis report must be at least 30 characters and no more than 128.", GetPlayerNameEx(suspect));
			ShowPlayerDialog(playerid, DIALOG_ARRESTREPORT, DIALOG_STYLE_INPUT, "Arrest Report", string, "Submit", "");
	    }
	}
	return 1;
}

/*CMD:docarrest(playerid, params[])
{
	if(!IsACop(playerid)) SendClientMessageEx(playerid, COLOR_GREY, "You are not part of a LEO faction. ");
	else if(!IsAtArrestPoint(playerid, 2)) SendClientMessageEx(playerid, COLOR_GREY, "You are not at the DoC Prison arrest point." );

	else
	{
   		new
     		moneys,
       		time,
			string[128];

        new suspect = GetClosestPlayer(playerid);
  		if(sscanf(params, "dddd", moneys, time)) SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /docarrest [fine] [minutes]");
		else if(!(1 <= moneys <= 250000)) SendClientMessageEx(playerid, COLOR_GREY, "The jail fine can't be below $1 or above $250,000.");
		else if(!(1 <= time <= 120)) SendClientMessageEx(playerid, COLOR_GREY, "Jail time can't be below 1 or above 120 minutes - take the person to prison for more time.");
		else if(!IsPlayerConnected(suspect)) SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");
		else if(!ProxDetectorS(5.0, playerid, suspect)) SendClientMessageEx(playerid, COLOR_GREY, "You are close enough to the suspect.");
		else if(PlayerInfo[suspect][pWantedLevel] < 1 && PlayerInfo[playerid][pMember] != 12) SendClientMessageEx(playerid, COLOR_GREY, "The person must have a wanted level of at least one star.");
		else {

			format(string, sizeof(string), "* You arrested %s!", GetPlayerNameEx(suspect));
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
			GivePlayerCash(suspect, -moneys);
			new money = floatround(moneys / 3), iGroupID = PlayerInfo[playerid][pMember];
			Tax += money;
			arrGroupData[iGroupID][g_iBudget] += money;
			new str[128], file[32];
            format(str, sizeof(str), "%s has been arrested by %s and fined $%d. $%d has been sent to %s's budget fund.",GetPlayerNameEx(suspect), GetPlayerNameEx(playerid), moneys, money, arrGroupData[iGroupID][g_szGroupName]);
            new month, day, year;
			getdate(year,month,day);
			format(file, sizeof(file), "grouppay/%d/%d-%d-%d.log", iGroupID, month, day, year);
			Log(file, str);
			ResetPlayerWeaponsEx(suspect);
			for(new x; x < MAX_PLAYERVEHICLES; x++) if(PlayerVehicleInfo[suspect][x][pvTicket] >= 1) {
				PlayerVehicleInfo[suspect][x][pvTicket] = 0;
			}
			SetPlayerInterior(suspect, 10);
			new rand = random(sizeof(DocPrison));
			SetPlayerFacingAngle(suspect, 0);
			SetPlayerPos(suspect, DocPrison[rand][0], DocPrison[rand][1], DocPrison[rand][2]);
			if(PlayerInfo[suspect][pDonateRank] >= 2) PlayerInfo[suspect][pJailTime] = ((time*60)*75)/100;
			else PlayerInfo[suspect][pJailTime] = time * 60;
			DeletePVar(suspect, "IsFrozen");
			PhoneOnline[suspect] = 1;
			PlayerInfo[suspect][pArrested] += 1;
			SetPlayerFree(suspect,playerid, "was arrested");
			PlayerInfo[suspect][pWantedLevel] = 0;
			SetPlayerToTeamColor(suspect);
			SetPlayerWantedLevel(suspect, 0);
			WantLawyer[suspect] = 1;
			TogglePlayerControllable(suspect, 1);
			ClearAnimations(suspect);
			SetPlayerSpecialAction(suspect, SPECIAL_ACTION_NONE);
			PlayerCuffed[suspect] = 0;
			DeletePVar(suspect, "PlayerCuffed");
			PlayerCuffedTime[suspect] = 0;
			PlayerInfo[suspect][pVW] = 0;
			SetPlayerVirtualWorld(suspect, 0);
			SetPlayerHealth(suspect, 100);
			strcpy(PlayerInfo[suspect][pPrisonedBy], GetPlayerNameEx(playerid), MAX_PLAYER_NAME);
			strcpy(PlayerInfo[suspect][pPrisonReason], "[IC] EBCF Arrest", 128);
			SetPlayerToTeamColor(suspect);
			Player_StreamPrep(suspect, DocPrison[rand][0], DocPrison[rand][1], DocPrison[rand][2], FREEZE_TIME);
	    }
	}
	return 1;
}*/

CMD:arrest(playerid, params[])
{
	if(!IsACop(playerid)) {
	    SendClientMessageEx(playerid, COLOR_GREY, "You are not part of a LEO faction. ");
	}
	else if(!IsAtArrestPoint(playerid, 0) && !IsAtArrestPoint(playerid, 1)) {
 		SendClientMessageEx(playerid, COLOR_GREY, "You are not at a arrest point." );
 	}

	else {


   		new
     		/*moneys,
       		time,
         	bail,
          	bailprice,*/
			string[256];

        new suspect = GetClosestPlayer(playerid);
  		/*if(sscanf(params, "dddd", moneys, time, bail, bailprice)) {
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /arrest [price] [time (minutes)] [bail (0=no 1=yes)] [bailprice]");
		}
		else if(!(1 <= moneys <= 30000)) {
  			SendClientMessageEx(playerid, COLOR_GREY, "The jail price can't be below $1 or above $30,000.");
		}
		else if(!(1 <= time <= 30)) {
  			SendClientMessageEx(playerid, COLOR_GREY, "Jail time can't be below 1 or above 30 minutes - take the person to prison for more time.");
		}
		else if(!(0 <= bail <= 1)) {
  			SendClientMessageEx(playerid, COLOR_GREY, "The bail option must be set to 0 or 1.");
		}
		else if(!(0 <= bailprice <= 100000)) {
  			SendClientMessageEx(playerid, COLOR_GREY, "The bail price can't be below $0 or above $100,000.");
		}*/
		if(!IsPlayerConnected(suspect)) {
			SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");
		}
		else if(!ProxDetectorS(5.0, playerid, suspect)) {
		    SendClientMessageEx(playerid, COLOR_GREY, "You are not close enough to the suspect.");
		}
		else if(PlayerInfo[suspect][pWantedLevel] < 1 && !IsAJudge(playerid)) {
		    SendClientMessageEx(playerid, COLOR_GREY, "The person must have a wanted level of at least one star.");
		}
		else {
			SetPVarInt(playerid, "Arrest_Price", PlayerInfo[suspect][pWantedJailFine]);
			SetPVarInt(playerid, "Arrest_Time", PlayerInfo[suspect][pWantedJailTime]);
			//SetPVarInt(playerid, "Arrest_Bail", bail);
			//SetPVarInt(playerid, "Arrest_BailPrice", bailprice);
			SetPVarInt(playerid, "Arrest_Suspect", suspect);
			SetPVarInt(playerid, "Arrest_Type", 0);
			format(string, sizeof(string), "Please write a brief arrest report on how %s acted during the arrest.\n\nThis report must be at least 30 characters and no more than 128.", GetPlayerNameEx(suspect));
			ShowPlayerDialog(playerid, DIALOG_ARRESTREPORT, DIALOG_STYLE_INPUT, "Arrest Report", string, "Submit", "");
	    }
	}
	return 1;
}

CMD:listprisoners(playerid, params[]) 
{
	if(!IsADocGuard(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You must be a DOC Guard to use this command.");
	new szInmates[1024],
		szString[20],
		id;
	if(sscanf(params, "d", id)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /listprisoners [arrestpoint id]");
	foreach(Player, i)
	{
		if((GetPVarInt(i, "ArrestPoint") == id + 1) && PlayerInfo[i][pJailTime] > 0)
		{
			format(szInmates, sizeof(szInmates), "%s\n* [%d] Prisoner Name: %s", szInmates, i, GetPlayerNameEx(i));
		}
	}
	if(strlen(szInmates) == 0) format(szInmates, sizeof(szInmates), "Holding cell empty!");
	format(szString, sizeof(szString), "Holding Cell %d", id);
	ShowPlayerDialog(playerid, DIALOG_DOC_INMATES, DIALOG_STYLE_LIST, szString, szInmates, "Close", "");
	
	return 1;
}

CMD:loadprisoners(playerid, params[])
{
	if(!IsADocGuard(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You must be a DOC Guard to use this command.");
	if(GetArrestPointID(playerid) == -1) return SendClientMessageEx(playerid, COLOR_GREY, "You are not near a arrest point.");
	new	getVeh = GetPlayerVehicleID(playerid);
	
	if(GetVehicleModel(getVeh) == 431 || GetVehicleModel(getVeh) == 427)
	{
		ListDetainees(playerid);
	}
	else SendClientMessage(playerid, COLOR_WHITE, "You need to be in a bus to transport prisoners.");
	return 1;
}

CMD:deliverinmates(playerid, params[])
{
	if(!IsADocGuard(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You must be a DOC Guard to use this command.");
	if(!IsPlayerInRangeOfPoint(playerid, 4, -2053.6279,-198.0207,15.0703)) return SendClientMessageEx(playerid, COLOR_GREY, "You must be at the doc delivery point");
	foreach(Player, i)
	{
		if(IsPlayerInVehicle(i, GetPlayerVehicleID(playerid)) && GetPlayerVehicleSeat(i) != 0)
		{
			new rand = random(sizeof(DocPrison));
			SetPlayerFacingAngle(i, 0);
			SetPlayerPos(i, DocPrison[rand][0], DocPrison[rand][1], DocPrison[rand][2]);
			DeletePVar(i, "IsFrozen");
			TogglePlayerControllable(i, 1);
			SetPlayerInterior(i, 10);
			SetPlayerVirtualWorld(i, 0);
			PlayerInfo[i][pVW] = 0;
			Player_StreamPrep(i, DocPrison[rand][0], DocPrison[rand][1], DocPrison[rand][2], FREEZE_TIME);
		}
	}
	return 1;
}

CMD:getinmatefood(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 8, 554.3956,1497.6799,5996.9590))
	{
		new string[64];
		if(GetPVarInt(playerid, "inmatefood") < 5)
		{
			SetPVarInt(playerid, "inmatefood", 5);
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
			SetPlayerAttachedObject(playerid, 9, 2767, 6, 0.195999, 0.042999, -0.191, -108.6, 168.6, -83.4999);
			format(string, sizeof(string), "* %s has picked up a food tray.", GetPlayerNameEx(playerid));
			ProxDetector(4.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "You cannot carry anymore food on your tray.");
		}
	}
	else SendClientMessageEx(playerid, COLOR_WHITE, "You are not at the Prison Cafe!");
	return 1;
}

CMD:dropfoodtray(playerid, params[])
{
	new string[64];
	if(GetPVarInt(playerid, "inmatefood") > 0 || GetPVarInt(playerid, "carryingfood") > 0)
	{
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		RemovePlayerAttachedObject(playerid, 9);
		format(string, sizeof(string), "* %s has dropped their food tray.", GetPlayerNameEx(playerid));
		ProxDetector(4.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		DeletePVar(playerid, "inmatefood");
		DeletePVar(playerid, "carryingfood");
		DeletePVar(playerid, "OfferedMealTo");
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You do not have a foodtray with food on it.");
	}
	return 1;
}

CMD:offerinmatefood(playerid, params[])
{
	new iGiveTo,
		string[92];
	if(sscanf(params, "u", iGiveTo)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /offerinmatefood [playerid]");
	else if(iGiveTo == playerid) return SendClientMessageEx(playerid, COLOR_WHITE, "You cannot offer yourself food.");
	else if(!IsPlayerConnected(iGiveTo)) return SendClientMessageEx(playerid, COLOR_WHITE, "That player is not connected");
	else if(GetPVarInt(playerid, "OfferingMeal") == 1) return SendClientMessageEx(playerid, COLOR_WHITE, "You may only offer food to one person at a time.");
	else if(!PlayerInfo[iGiveTo][pJailTime]) return SendClientMessageEx(playerid, COLOR_WHITE, "You may only offer food to prison inmates.");
	else if(!GetPVarInt(playerid, "inmatefood")) return SendClientMessageEx(playerid, COLOR_WHITE, "You do not have any prison food to offer.");
	else if(ProxDetectorS(5.0, playerid, iGiveTo))
	{
		SetPVarInt(iGiveTo, "OfferedMeal", 1);
		SetPVarInt(iGiveTo, "OfferedMealBy", playerid);
		SetPVarInt(playerid, "OfferingMeal", 1);
		SetPVarInt(playerid, "OfferedMealTo", iGiveTo);
		format(string, sizeof(string), "%s has offered you a meal. Type /acceptjailfood to take it.", GetPlayerNameEx(playerid));
		SendClientMessageEx(iGiveTo, COLOR_LIGHTBLUE, string);
		format(string, sizeof(string), "You have offered %s some prisoner food", GetPlayerNameEx(iGiveTo));
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
	else SendClientMessageEx(playerid, COLOR_WHITE, "You are not in range of that player.");
	return 1;
}

CMD:acceptjailfood(playerid, params[])
{
	new iOffering = GetPVarInt(playerid, "OfferedMealBy"),
		string[101];
	if(GetPVarInt(playerid, "OfferedMeal") == 0) return SendClientMessageEx(playerid, COLOR_WHITE, "No one offered you a meal.");
	else if(!IsPlayerConnected(GetPVarInt(playerid, "OfferedMealBy"))) return SendClientMessageEx(playerid, COLOR_WHITE, "The person offering you food has disconnected.");
	else if(ProxDetectorS(5.0, playerid, iOffering))
	{
		if(PlayerInfo[playerid][pHunger] <= 100)
		{
			PlayerInfo[playerid][pHunger] += 33;
			if (PlayerInfo[playerid][pFitness] >= 3)
			{
				PlayerInfo[playerid][pFitness] -= 3;
			}
			else
			{
				PlayerInfo[playerid][pFitness] = 0;
			}
		}
		SetPVarInt(iOffering, "inmatefood", GetPVarInt(iOffering, "inmatefood") - 1);	
		if(!GetPVarInt(iOffering, "inmatefood")) {
			RemovePlayerAttachedObject(iOffering, 9);
			SetPlayerSpecialAction(iOffering, SPECIAL_ACTION_NONE);
		}
		DeletePVar(playerid, "OfferedMeal");
		DeletePVar(playerid, "OfferedMealBy");
		DeletePVar(iOffering, "OfferingMeal");
		DeletePVar(iOffering, "OfferedMealTo");
		format(string, sizeof(string), "* %s takes a plate of food from %s and begins to eat it.", GetPlayerNameEx(playerid), GetPlayerNameEx(iOffering));
		ProxDetector(4.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		//ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 1, 0, 4000, 1);
		ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.0, 0, 0, 0, 1, 0);
		SetTimerEx("ClearAnims", 3000, false, "d", playerid);
	}
	else SendClientMessageEx(playerid, COLOR_WHITE, "You are not in range of the person offering you food.");
	return 1;
}

CMD:getfood(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 8, 554.3956,1497.6799,5996.9590))
	{
		new string[94];
		if(GetPVarInt(playerid, "carryingfood") < 1)
		{
			SetPVarInt(playerid, "carryingfood", 1);
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
			SetPlayerAttachedObject(playerid, 9, 2767, 6, 0.195999, 0.042999, -0.191, -108.6, 168.6, -83.4999);
			format(string, sizeof(string), "* %s reaches towards the counter, grabbing a tray of food.", GetPlayerNameEx(playerid));
			ProxDetector(4.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "You cannot carry anymore food on your tray.");
		}
	}
	else SendClientMessageEx(playerid, COLOR_WHITE, "You are not at the Prison Cafe!");
	return 1;
}

CMD:eatfood(playerid, params[])
{
	if(GetPVarInt(playerid, "carryingfood") == 1)
	{	
		new string[94];
		if(PlayerInfo[playerid][pHunger] <= 100)
		{
			PlayerInfo[playerid][pHunger] += 33;
			if (PlayerInfo[playerid][pFitness] >= 3)
			{
				PlayerInfo[playerid][pFitness] -= 3;
			}
			else
			{
				PlayerInfo[playerid][pFitness] = 0;
			}
		}
		format(string, sizeof(string), "* %s grabs the food from the tray and eats it.", GetPlayerNameEx(playerid));
		ProxDetector(4.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		DeletePVar(playerid, "carryingfood");
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.0, 0, 0, 0, 1, 0);
		SetTimerEx("ClearAnims", 3000, false, "d", playerid);
		RemovePlayerAttachedObject(playerid, 9);
		
	}
	else SendClientMessageEx(playerid, COLOR_WHITE, "You are not carrying a food tray");
	return 1;
}

CMD:extendsentence(playerid, params[])
{
	if(!IsADocGuard(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You must be a DOC Guard to use this command.");
	new iTargetID,
		iExtended, 
		string[64];
	if(sscanf(params, "ud", iTargetID, iExtended)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /extendsentence [playerid] [percentage to extend (1 - 30)]");
	else if(strfind(PlayerInfo[iTargetID][pPrisonReason], "[IC]", true) == -1)  return SendClientMessageEx(playerid, COLOR_WHITE, "That player is not in IC Jail.");
	else if(!IsPlayerConnected(iTargetID)) return SendClientMessageEx(playerid, COLOR_WHITE, "ERROR: That player is not connected.");
	else if(iTargetID == playerid) return SendClientMessageEx(playerid, COLOR_WHITE, "ERROR: You cannot use this command on yourself.");
	else if(strfind(PlayerInfo[iTargetID][pPrisonReason], "[EXT]", true) != -1) return SendClientMessageEx(playerid, COLOR_WHITE, "That player has already had their time extended.");
	else if(iExtended >= 1 && iExtended <= 30)
	{
		new StartJail = PlayerInfo[iTargetID][pJailTime];
		new Float:EndJail;
		new Float:Manip;
		Manip = 1.0 + (float(iExtended) / 100);
		EndJail = StartJail * Manip;
		PlayerInfo[iTargetID][pJailTime] = floatround(EndJail); 
		format(string, sizeof(string), "Your jail time has been extended by %s by %d percent.", GetPlayerNameEx(playerid), iExtended);
		SendClientMessageEx(iTargetID, COLOR_RED, string);
		format(string, sizeof(string), "You have extended %s's jail sentence by %d percent.", GetPlayerNameEx(iTargetID), iExtended);
		SendClientMessageEx(playerid, COLOR_RED, string);
		format(string, sizeof(string), "Original Time: %s ------ New Time: %s", TimeConvert(StartJail), TimeConvert(PlayerInfo[iTargetID][pJailTime]));
		SendClientMessageEx(playerid, COLOR_RED, string);
		strcat(PlayerInfo[iTargetID][pPrisonReason], "[EXT]", 128);
	}
	else SendClientMessageEx(playerid, COLOR_WHITE, "ERROR: The extension percentage cannot be less than 1 or greater than 10.");
	return 1;
}

CMD:reducesentence(playerid, params[])
{
	if(!IsADocGuard(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You must be a DOC Guard to use this command.");
	new iTargetID,
		iReduce,
		string[64];
	if(sscanf(params, "ud", iTargetID, iReduce)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /reducesentence [playerid] [percentage to reduce (1 - 30)]");
	else if(strfind(PlayerInfo[iTargetID][pPrisonReason], "[IC]", true) == -1)  return SendClientMessageEx(playerid, COLOR_WHITE, "That player is not in IC Jail.");
	else if(!IsPlayerConnected(iTargetID)) return SendClientMessageEx(playerid, COLOR_WHITE, "ERROR: That player is not connected.");
	else if(iTargetID == playerid) return SendClientMessageEx(playerid, COLOR_WHITE, "ERROR: You cannot use this command on yourself.");
	else if(strfind(PlayerInfo[iTargetID][pPrisonReason], "[RED]", true) != -1) return SendClientMessageEx(playerid, COLOR_WHITE, "That player has already had their time reduced.");
	else if(iReduce >= 1 && iReduce <= 30)
	{
		new StartJail = PlayerInfo[iTargetID][pJailTime];
		new Float:EndJail;
		new Float:Manip;
		Manip = 1.0 - (float(iReduce) / 100);
		EndJail = StartJail * Manip;
		PlayerInfo[iTargetID][pJailTime] = floatround(EndJail); 
		format(string, sizeof(string), "Your jail time has been reduced by %s by %d percent.", GetPlayerNameEx(playerid), iReduce);
		SendClientMessageEx(iTargetID, COLOR_RED, string);
		format(string, sizeof(string), "You have reduced %s's jail sentence by %d percent.", GetPlayerNameEx(iTargetID), iReduce);
		SendClientMessageEx(playerid, COLOR_RED, string);
		format(string, sizeof(string), "Original Time: %s ------ New Time: %s", TimeConvert(StartJail), TimeConvert(PlayerInfo[iTargetID][pJailTime]));
		SendClientMessageEx(playerid, COLOR_RED, string);
		strcat(PlayerInfo[iTargetID][pPrisonReason], "[RED]", 128);
	}
	else SendClientMessageEx(playerid, COLOR_WHITE, "ERROR: The reduction percentage cannot be less than 1 or greater than 10.");
	
	return 1;
}

CMD:isolateinmate(playerid, params[])
{
	if(!IsADocGuard(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You must be a DOC Guard to use this command.");
	new iTargetID,
		iCellID,
		string[128];
	
	if(sscanf(params, "ud", iTargetID, iCellID)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /isolateinmate [playerid] [cellid]");
	else if(strfind(PlayerInfo[iTargetID][pPrisonReason], "[IC]", true) == -1) return SendClientMessageEx(playerid, COLOR_WHITE, "That player is not in IC Jail.");
	else if(iTargetID == playerid) return SendClientMessageEx(playerid, COLOR_WHITE, "ERROR: You cannot use this command on yourself.");
	else if(!IsPlayerConnected(iTargetID)) return SendClientMessageEx(playerid, COLOR_WHITE, "ERROR: That player is not connected.");
	else if(PlayerInfo[iTargetID][pIsolated] == 0)
	{
		DocIsolate(iTargetID, iCellID);
		
		format(string, sizeof(string), "You have been sent to isolation by %s.", GetPlayerNameEx(playerid));
		SendClientMessageEx(iTargetID, COLOR_LIGHTBLUE, string);
		format(string, sizeof(string), "You have sent %s to isolation.", GetPlayerNameEx(iTargetID));
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
	else SendClientMessageEx(playerid, COLOR_WHITE, "ERROR: That player is already in isolation.");
	
	return 1;
}

CMD:unisolateinmate(playerid, params[])
{
	if(!IsADocGuard(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You must be a DOC Guard to use this command.");
	new iTargetID,
		string[128];
	
	if(sscanf(params, "u", iTargetID)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /unisolateinmate [playerid]");
	else if(strfind(PlayerInfo[iTargetID][pPrisonReason], "[IC]", true) == -1) return SendClientMessageEx(playerid, COLOR_WHITE, "That player is not in IC Jail");
	else if(iTargetID == playerid) return SendClientMessageEx(playerid, COLOR_WHITE, "ERROR: You cannot use this command on yourself.");
	else if(PlayerInfo[iTargetID][pIsolated] == 0) return SendClientMessageEx(playerid, COLOR_WHITE, "That player is not in isolation");
	else if(IsPlayerConnected(iTargetID))
	{
		PlayerInfo[iTargetID][pIsolated] = 0;
		
		format(string, sizeof(string), "You have been released from isolation by %s.", GetPlayerNameEx(playerid));
		SendClientMessageEx(iTargetID, COLOR_LIGHTBLUE, string);
		format(string, sizeof(string), "You have released %s from isolation.", GetPlayerNameEx(iTargetID));
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
	else SendClientMessageEx(playerid, COLOR_WHITE, "ERROR: That player is not connected.");
	return 1;
}

CMD:inmates(playerid, params[])
{
	if(!IsADocGuard(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You must be a DOC Guard to use this command.");
	new szInmates[1024];
	
	foreach(Player, i)
	{
		if(PlayerInfo[i][pJailTime] > 0 && strfind(PlayerInfo[i][pPrisonReason], "[IC]", true) != -1)
		{
			format(szInmates, sizeof(szInmates), "%s\n* %s: %s", szInmates, GetPlayerNameEx(i), TimeConvert(PlayerInfo[i][pJailTime]));
		}
	}
	if(strlen(szInmates) == 0) format(szInmates, sizeof(szInmates), "No inmates");
	ShowPlayerDialog(playerid, DIALOG_DOC_INMATES, DIALOG_STYLE_LIST, "DOC Inmates Logbook", szInmates, "Close", "");
	
	return 1;
}

/*CMD:joinjailboxing(playerid, params[])
{
	if(IsPlayerAtJailBoxing(playerid))
	{
		if(GetPVarInt(playerid, "_InJailBoxing") != 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "You're already in a boxing arena. Use /leavejailboxing to leave.");
		else if(arrJailBoxingData[GetClosestJailBoxingRing(playerid)][bInProgress] == true) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are unable to join a boxing match that is in progress.");
		else SetPlayerIntoJailBoxing(playerid);
	}
	else SendClientMessageEx(playerid, COLOR_GRAD2, "You are not in range of a jail boxing ring.");
	
	return 1;
}

CMD:leavejailboxing(playerid, params[])
{
	if(GetPVarInt(playerid, "_InJailBoxing") == 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not in a boxing arena. Please use /joinjailboxing to join one.");
	else if(arrJailBoxingData[GetClosestJailBoxingRing(playerid)][bInProgress] == true) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are unable to leave a boxing match that is in progress.");
	else
	{
		RemoveFromJailBoxing(playerid);
		SendClientMessageEx(playerid, COLOR_WHITE, "You have withdrawn yourself from the boxing arena queue.");
	}
	return 1;
}*/

CMD:startbrawl(playerid, params[])
{
	new iTargetID, 
		string[MAX_PLAYER_NAME + 35];

	if(sscanf(params, "u", iTargetID)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /startbrawl [playerid]");
	else if(strfind(PlayerInfo[playerid][pPrisonReason], "[IC]", true) == -1) return SendClientMessageEx(playerid, COLOR_WHITE, "You must be in IC jail to do this.");
	else if(!ProxDetectorS(8.0, playerid, iTargetID)) return SendClientMessageEx(playerid, COLOR_WHITE, "You are not in range of that player.");
	else if(IsPlayerConnected(iTargetID))
	{
		SetPVarInt(playerid, "_InJailBrawl", iTargetID + 1);
		SetPVarInt(iTargetID, "_InJailBrawl", playerid + 1);
		
		format(string, sizeof(string), "You have initiated a brawl with %s", GetPlayerNameEx(iTargetID));
		SendClientMessageEx(playerid, COLOR_RED, string);
		
		format(string, sizeof(string), "%s has initiated a brawl with you", GetPlayerNameEx(playerid));
		SendClientMessageEx(iTargetID, COLOR_RED, string);
	}
	else SendClientMessageEx(playerid, COLOR_GRAD2, "That player is not connected.");
	
	return 1;
}

CMD:docjudgesubpoena(playerid, params[])
{
	new iTargetID,
		szCaseName[128],
		szString[128];
	
	if(sscanf(params, "us[128]", iTargetID, szCaseName)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /docjudgesubpoena [playerid] [case reason]");
	if(!IsPlayerConnected(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "ERROR: That player is not connected");
	if(!IsPlayerInRangeOfPoint(playerid, 20, 594.7211,1481.1313,6007.4780)) return SendClientMessageEx(playerid, COLOR_GREY, "You must be at the DOC courthouse to use this");
	else if(IsAJudge(playerid))
	{
		format(szString, sizeof(szString), "You have subpoenaed %s. Case: %s", GetPlayerNameEx(iTargetID), szCaseName);
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szString);
		
		format(szString, sizeof(szString), "You have been subpoenaed by %s. Case %s", GetPlayerNameEx(playerid), szCaseName);
		SendClientMessageEx(iTargetID, COLOR_LIGHTBLUE, szString);
	}
	else SendClientMessageEx(playerid, COLOR_GREY, "You must be a judge to use this command");
	return 1;
}

CMD:docjudgecharge(playerid, params[])
{
	new iTargetID,
		iTime,
		iFine,
		szCountry[5],
		szReason[128],
		szCrime[128],
		szMessage[128];
		
	if(sscanf(params, "udds[128]", iTargetID, iTime, iFine, szReason)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /docjudgecharge [playerid] [time] [fine] [reason]");
	if(!IsPlayerInRangeOfPoint(playerid, 20, 594.7211,1481.1313,6007.4780)) return SendClientMessageEx(playerid, COLOR_GREY, "You must be at the DOC courthouse to use this");
	if(!IsPlayerConnected(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "ERROR: That player is not connected");
	if(!IsAJudge(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You must be a judge to use this command");
	if(ProxDetectorS(14.0, playerid, iTargetID))
	{
		PlayerInfo[iTargetID][pWantedJailTime] += iTime;
		PlayerInfo[iTargetID][pWantedJailFine] += iFine;
		if(arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance] == 1)
		{
			format(szCountry, sizeof(szCountry), "[SA] ");
		}
		else if(arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance] == 2)
		{
			format(szCountry, sizeof(szCountry), "[TR] ");
		}
		strcat(szCrime, szCountry);
		strcat(szCrime, szReason);
		AddCrime(playerid, iTargetID, szCrime);

		format(szMessage, sizeof(szMessage), "You've commited a crime ( %s ). Reporter: %s.", szCrime, GetPlayerNameEx(playerid));
		SendClientMessageEx(iTargetID, COLOR_LIGHTRED, szMessage);

		format(szMessage, sizeof(szMessage), "Current wanted level: %d", PlayerInfo[iTargetID][pWantedLevel]);
		SendClientMessageEx(iTargetID, COLOR_YELLOW, szMessage);
		
		format(szMessage, sizeof(szMessage), "You have charged %s with a crime.", GetPlayerNameEx(iTargetID));
		SendClientMessage(playerid, COLOR_LIGHTRED, szMessage);
		
		format(szMessage, sizeof(szMessage), "%s: Time: %i minutes. Fine: %i", szCrime, iTime, iFine);
		SendClientMessage(playerid, COLOR_LIGHTRED, szMessage);
	}
	else SendClientMessageEx(playerid, COLOR_WHITE, "You must be in range of that player");
	return 1;
}

CMD:docjudgesentence(playerid, params[])
{
	new iSuspect,
		string[256];
	
	if(sscanf(params, "u", iSuspect)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /docjudgesentence [suspect]");
	if(!IsPlayerInRangeOfPoint(playerid, 20, 594.7211,1481.1313,6007.4780)) return SendClientMessageEx(playerid, COLOR_GREY, "You must be at the DOC courthouse to use this");
	if(!IsPlayerConnected(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "ERROR: That player is not connected");
	if(!IsAJudge(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You must be a judge to use this command");
	if(ProxDetectorS(14.0, playerid, iSuspect))
	{
		SetPVarInt(playerid, "Arrest_Price", PlayerInfo[iSuspect][pWantedJailFine]);
		SetPVarInt(playerid, "Arrest_Time", PlayerInfo[iSuspect][pWantedJailTime]);
		SetPVarInt(playerid, "Arrest_Suspect", iSuspect);
		SetPVarInt(playerid, "Arrest_Type", 3);
		format(string, sizeof(string), "Please write a brief report on how %s acted during the process.\n\nThis report must be at least 30 characters and no more than 128.", GetPlayerNameEx(iSuspect));
		ShowPlayerDialog(playerid, DIALOG_ARRESTREPORT, DIALOG_STYLE_INPUT, "Arrest Report", string, "Submit", "");
	}
	else SendClientMessageEx(playerid, COLOR_WHITE, "You must be in range of that player");
	
	return 1;
}

CMD:jailcall(playerid, params[])
{
	new phonenumb,
		JailPhone = GetClosestPrisonPhone(playerid), 
		string[128];
	
	if(sscanf(params, "d", phonenumb)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /jailcall [phone number]");
	if(!IsPlayerInRangeOfJailPhone(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD2, "You are not in range of a prison call phone");
	if(bJailPhoneUse[JailPhone] == true) return SendClientMessageEx(playerid, COLOR_GREY, "That phone is in use, please find another");
	if(Mobile[playerid] != INVALID_PLAYER_ID) return SendClientMessageEx(playerid, COLOR_GRAD2, "  You are already on a call...");
	foreach(new i: Player)
	{
		if(PlayerInfo[i][pPnumber] == phonenumb && phonenumb != 0)
		{
			new giveplayerid = i;
			Mobile[playerid] = giveplayerid; //caller connecting
			if(IsPlayerConnected(giveplayerid))
			{
				if(giveplayerid != INVALID_PLAYER_ID)
				{
					if(PhoneOnline[giveplayerid] > 0)
					{
						SendClientMessageEx(playerid, COLOR_GREY, "That player's phone is switched off.");
						Mobile[playerid] = INVALID_PLAYER_ID;
						return 1;
					}
					if(Mobile[giveplayerid] != INVALID_PLAYER_ID)
					{
						SendClientMessageEx(playerid, COLOR_GRAD2, "You just get a busy tone...");
						Mobile[playerid] = INVALID_PLAYER_ID;
						return 1;
					}
					if(Spectating[giveplayerid]!=0)
					{
						SendClientMessageEx(playerid, COLOR_GRAD2, "You just get a busy tone...");
						Mobile[playerid] = INVALID_PLAYER_ID;
						return 1;
					}
					if (Mobile[giveplayerid] == INVALID_PLAYER_ID)
					{
						format(string, sizeof(string), "* %s dials in a number.", GetPlayerNameEx(playerid));
						ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
						
						format(string, sizeof(string), "Your mobile is ringing - type /p to answer it. [Caller ID: DOC Phoneline]");
						SendClientMessageEx(giveplayerid, COLOR_YELLOW, string);
						format(string, sizeof(string), "* %s's phone begins to ring.", GetPlayerNameEx(i));
						SendClientMessageEx(playerid, COLOR_WHITE, "HINT: You now use T to talk on your cellphone, type /jailhangup to hang up.");
						ProxDetector(30.0, i, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
						SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
						TogglePlayerControllable(playerid, 0);
						SetPVarInt(playerid, "_UsingJailPhone", 1);
						bJailPhoneUse[JailPhone] = true;
						return 1;
					}
				}
			}
		}
	}
	SendClientMessageEx(playerid, COLOR_WHITE, "The call could not completed as requested, please try again");
	return 1;
}

CMD:jailhangup(playerid,params[])
{
	new string[128];
	new caller = Mobile[playerid],
		JailPhone = GetClosestPrisonPhone(playerid);
	if((IsPlayerConnected(caller) && caller != INVALID_PLAYER_ID))
	{
		if(caller < MAX_PLAYERS)
		{
			SendClientMessageEx(caller,  COLOR_GRAD2, "   They hung up.");
			format(string, sizeof(string), "* %s puts away their cellphone.", GetPlayerNameEx(caller));
			ProxDetector(30.0, caller, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			Mobile[caller] = INVALID_PLAYER_ID;
		}
		SendClientMessageEx(playerid,  COLOR_GRAD2, "   You hung up.");
		format(string, sizeof(string), "* %s steps away from the phone.", GetPlayerNameEx(playerid));
		ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		Mobile[playerid] = INVALID_PLAYER_ID;
		RemovePlayerAttachedObject(caller, 9);
		TogglePlayerControllable(playerid, 1);
		SetPlayerSpecialAction(caller, SPECIAL_ACTION_STOPUSECELLPHONE);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
		bJailPhoneUse[JailPhone] = false;
		DeletePVar(playerid, "_UsingJailPhone");
		return 1;
	}
	SendClientMessageEx(playerid,  COLOR_GRAD2, "   Your phone is in your pocket.");
	return 1;
}

CMD:jailcuff(playerid, params[])
{
	if(IsACop(playerid))
	{
		if(GetPVarInt(playerid, "Injured") == 1 || GetPVarInt(playerid, "jailcuffs") > 0 || PlayerCuffed[ playerid ] >= 1 || PlayerInfo[ playerid ][ pJailTime ] > 0 || PlayerInfo[playerid][pHospital] > 0)
		{
			SendClientMessageEx(playerid, COLOR_GREY, "You can't do this right now.");
			return 1;
		}

		if(PlayerInfo[playerid][pHasCuff] < 1)
		{
		    SendClientMessageEx(playerid, COLOR_WHITE, "You do not have any pair of cuffs on you!");
		    return 1;
		}

		new string[128], giveplayerid;
		if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /jailcuff [player]");
		if(IsPlayerConnected(giveplayerid))
		{
			if (ProxDetectorS(8.0, playerid, giveplayerid))
			{
				if(giveplayerid == playerid) { SendClientMessageEx(playerid, COLOR_GREY, "You cannot cuff yourself!"); return 1; }
				if(GetPlayerSpecialAction(giveplayerid) == SPECIAL_ACTION_HANDSUP)
				{
					format(string, sizeof(string), "* You have been handcuffed by %s.", GetPlayerNameEx(playerid));
					SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "* You handcuffed %s, till uncuff.", GetPlayerNameEx(giveplayerid));
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "* %s handcuffs %s, tightening the cuffs securely.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
					GameTextForPlayer(giveplayerid, "~r~Cuffed", 2500, 3);
					ClearAnimations(giveplayerid);
					TogglePlayerControllable(giveplayerid, 0);
					SetPlayerSpecialAction(giveplayerid, SPECIAL_ACTION_CUFFED);
					TogglePlayerControllable(giveplayerid, 1);
					SetPVarInt(giveplayerid, "jailcuffs", 1);
				}
				else if(GetPVarType(giveplayerid, "IsTackled"))
				{
				    format(string, sizeof(string), "* %s removes a set of cuffs from his belt and attempts to cuff %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
					ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
					SetTimerEx("CuffTackled", 4000, 0, "ii", playerid, giveplayerid);
				}
				else
				{
					SendClientMessageEx(playerid, COLOR_GREY, "That person isn't restrained!");
					return 1;
				}
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GREY, "That person isn't near you.");
				return 1;
			}
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");
			return 1;
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You're not a law enforcement officer.");
	}
	return 1;
}