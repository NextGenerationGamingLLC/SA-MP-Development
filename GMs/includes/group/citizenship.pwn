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

CMD:apply(playerid, params[])
{
	new choice[3];
	if(sscanf(params, "s[3]", choice))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /apply [SA|TR]");
		return 1;
	}

	if(strcmp(choice, "sa", true) == 0)
	{
		if(PlayerInfo[playerid][pNation] == 0) return SendClientMessageEx(playerid, COLOR_GREY, "You're currently part of San Andreas.");
		CheckNationQueue(playerid, 0);
	}
	else if(strcmp(choice, "tr", true) == 0)
	{
		if(PlayerInfo[playerid][pNation] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "You're currently part of Tierra Robada.");
		CheckNationQueue(playerid, 1);
	}
	return 1;
}

CMD:checkapps(playerid, params[])
{
	if((0 <= PlayerInfo[playerid][pLeader] < MAX_GROUPS) && arrGroupData[PlayerInfo[playerid][pLeader]][g_iGroupType] == 5)
	{
		switch(arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance])
		{
			case 1: mysql_function_query(MainPipeline, "SELECT `playerid`, `name`, `date` FROM `nation_queue` WHERE `nation` = 0 AND `status` = 1 ORDER BY `id` ASC", true, "NationQueueQueryFinish", "iii", playerid, 0, AppQueue);
			case 2: mysql_function_query(MainPipeline, "SELECT `playerid`, `name`, `date` FROM `nation_queue` WHERE `nation` = 1 AND `status` = 1 ORDER BY `id` ASC", true, "NationQueueQueryFinish", "iii", playerid, 1, AppQueue);
		}
	}
	else SendClientMessage(playerid, COLOR_GREY, "You are not the leader of a Government agency.");
	return 1;
}

CMD:deport(playerid, params[])
{
	if((0 <= PlayerInfo[playerid][pLeader] < MAX_GROUPS) && arrGroupData[PlayerInfo[playerid][pLeader]][g_iGroupType] == 5)
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
			ClearAnimations(giveplayerid);
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
						SetPlayerPos(giveplayerid, 1699.2, 1435.1, 10.7);
						SetPlayerFacingAngle(giveplayerid, 270.0);
					}
					case 1:
					{
						SetPlayerPos(giveplayerid, -1446.5997, 2608.4478, 55.8359);
						SetPlayerFacingAngle(giveplayerid, 180.0);
					}
				}
				SendClientMessageEx(giveplayerid, COLOR_RED, "You have been deported back to Tierra Robada.");
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
				PlayerInfo[giveplayerid][pNation] = 0;
				SendClientMessageEx(giveplayerid, COLOR_RED, "You have been deported to San Andreas.");
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
