/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Judicial Group Type

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

CMD:present(playerid, params[])
{
  	if(IsAJudge(playerid))
	{
		new giveplayerid;
		if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /present [player]");
		if(IsPlayerConnected(giveplayerid))
		{
			if(giveplayerid == playerid) return SendClientMessageEx(playerid, COLOR_GRAD1, "You can't use this command on yourself!");
			if(PlayerInfo[giveplayerid][pBeingSentenced] == 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "That person isn't pending a sentence!");
			if(courtjail[giveplayerid] == 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "That person isn't in the courthouse jail!");
			if(courtjail[giveplayerid] > 0)
			{
				SetPlayerPos(giveplayerid, 1406.145, -1774.3, 7308.95);
		    	SetPlayerFacingAngle(giveplayerid, 93.34);
			}
			courtjail[giveplayerid] = 0;
		    SetCameraBehindPlayer(giveplayerid);
		}
	}
	else
	{
	    return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not a part of the Judicial System!");
	}
	return 1;
}

CMD:checkjudgements(playerid, params[])
{
    if(IsACop(playerid) || IsAJudge(playerid))
    {

    	if(JudgeOnlineCheck() == 0) return SendClientMessageEx(playerid, COLOR_GRAD4, "There must be at least one judge online to use this command!");
		SendClientMessageEx(playerid, COLOR_YELLOW, "Pending Judgements List:");

		new
			string[128],
			fCounter;

		//foreach(new i: Player)
		for(new i = 0; i < MAX_PLAYERS; ++i)
		{
			if(IsPlayerConnected(i))
			{
				if(PlayerInfo[i][pJudgeJailType] == 1)
				{
					if(PlayerInfo[i][pJailTime] > 1)
					{
						format(string, sizeof(string), "Sentenced: %s - jail (transport completed) - time: %d.",GetPlayerNameEx(i),PlayerInfo[i][pJudgeJailTime]);
						SendClientMessageEx(playerid, COLOR_GRAD1, string);
						++fCounter;
					}
					else
					{
						format(string, sizeof(string), "Sentenced: %s - jail (being transported) - time: %d.",GetPlayerNameEx(i),PlayerInfo[i][pJudgeJailTime]);
						SendClientMessageEx(playerid, COLOR_GRAD1, string);
						++fCounter;
					}
				}
				else if(PlayerInfo[i][pJudgeJailType] == 2)
				{
					if(PlayerInfo[i][pJailTime] > 1)
					{
						format(string, sizeof(string), "Sentenced: %s - prison (transport completed) - time: %d.",GetPlayerNameEx(i),PlayerInfo[i][pJudgeJailTime]);
						SendClientMessageEx(playerid, COLOR_GRAD1, string);
						++fCounter;
					}
					else
					{
						format(string, sizeof(string), "Sentenced: %s - prison (being transported) - time: %d.",GetPlayerNameEx(i),PlayerInfo[i][pJudgeJailTime]);
						SendClientMessageEx(playerid, COLOR_GRAD1, string);
						++fCounter;
					}
				}
			}	
		}
		if(fCounter == 0)
		{
  			SendClientMessageEx(playerid, COLOR_GRAD1, "Nobody is pending judgement.");
		}
  	}
	return 1;
}

CMD:freezebank(playerid, params[])
{
  	if(!IsAJudge(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You are not part of the Judicial System!");
	if(PlayerInfo[playerid][pRank] < 4) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command - only rank 4+ can do this.");
	new giveplayerid;
	if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /freezebank [player]");
	if(giveplayerid == playerid) return SendClientMessageEx(playerid, COLOR_GRAD1, "You can't use this command on yourself!");
	if(!IsPlayerConnected(giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");
	new	string[128],
		rank[GROUP_MAX_RANK_LEN],
		division[GROUP_MAX_DIV_LEN],
		employer[GROUP_MAX_NAME_LEN];
	if(PlayerInfo[giveplayerid][pFreezeBank] == 0)
    {
        PlayerInfo[giveplayerid][pFreezeBank] = 1;
       	GetPlayerGroupInfo(playerid, rank, division, employer);
	   	format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s %s has froze %s bank account.", rank, GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
    	ABroadCast(COLOR_YELLOW,string, 2);
    	format(string, sizeof(string), "You have frozen %s's bank account.", GetPlayerNameEx(giveplayerid));
   	 	SendClientMessageEx(playerid, COLOR_WHITE, string);
   	 	format(string, sizeof(string), "Your bank account has been frozen by %s", GetPlayerNameEx(playerid));
   	 	SendClientMessageEx(giveplayerid, COLOR_WHITE, string);
    }
    else
    {
		PlayerInfo[giveplayerid][pFreezeBank] = 0;
		format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s %s has unfrozen %s bank account.", rank, GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
		ABroadCast(COLOR_YELLOW,string, 2);
		format(string, sizeof(string), "You have unfrozen %s's bank account.", GetPlayerNameEx(giveplayerid));
		SendClientMessageEx(playerid, COLOR_WHITE, string);
   	 	format(string, sizeof(string), "Your bank account has been unfrozen by %s", GetPlayerNameEx(playerid));
   	 	SendClientMessageEx(giveplayerid, COLOR_WHITE, string);
	}
	return 1;
}

CMD:freezeassets(playerid, params[])
{
  	if(!IsAJudge(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You are not part of the Judicial System!");
	if(PlayerInfo[playerid][pRank] < 4) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command - only rank 4+ can do this.");
	new giveplayerid, houseorcar[8];
	if(sscanf(params, "us[8]", giveplayerid, houseorcar)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /freezeassets [player] [house/car]");
	if(giveplayerid == playerid) return SendClientMessageEx(playerid, COLOR_GRAD1, "You can't use this command on yourself!");
	if(!IsPlayerConnected(giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");
	new string[128],
		rank[GROUP_MAX_RANK_LEN],
		division[GROUP_MAX_DIV_LEN],
		employer[GROUP_MAX_NAME_LEN];
    if(strcmp(houseorcar, "house", true) == 0)
	{
		if(PlayerInfo[giveplayerid][pFreezeHouse] == 0)
	    {
			PlayerInfo[giveplayerid][pFreezeHouse] = 1;
	       	GetPlayerGroupInfo(playerid, rank, division, employer);
		   	format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s %s has frozen %s house assets.", rank, GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
		   	ABroadCast(COLOR_YELLOW,string, 2);
		   	format(string, sizeof(string), "You have frozen %s's house assets.", GetPlayerNameEx(giveplayerid));
	   	 	SendClientMessageEx(playerid, COLOR_WHITE, string);
	   	 	format(string, sizeof(string), "Your house assets have been frozen by %s", GetPlayerNameEx(playerid));
	   	 	SendClientMessageEx(giveplayerid, COLOR_WHITE, string);
	    }
	    else
	    {
	        PlayerInfo[giveplayerid][pFreezeHouse] = 0;
			format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s %s has unfrozen %s house assets.", rank, GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
	    	ABroadCast(COLOR_YELLOW,string, 2);
		   	format(string, sizeof(string), "You have unfrozen %s's house assets.", GetPlayerNameEx(giveplayerid));
	   	 	SendClientMessageEx(playerid, COLOR_WHITE, string);
	   	 	format(string, sizeof(string), "Your house assets have been unfrozen by %s", GetPlayerNameEx(playerid));
	   	 	SendClientMessageEx(giveplayerid, COLOR_WHITE, string);
		}
	}
	else if(strcmp(houseorcar, "car", true) == 0)
	{
	    if(PlayerInfo[giveplayerid][pFreezeCar] == 0)
		{
			PlayerInfo[giveplayerid][pFreezeCar] = 1;
	       	GetPlayerGroupInfo(playerid, rank, division, employer);
			format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s %s has frozen %s vehicle assets.", rank, GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
	    	ABroadCast(COLOR_YELLOW,string, 2);
	    	format(string, sizeof(string), "You have frozen %s's vehicle assets.", GetPlayerNameEx(giveplayerid));
	   	 	SendClientMessageEx(playerid, COLOR_WHITE, string);
	   	 	format(string, sizeof(string), "Your vehicle assets have been frozen by %s", GetPlayerNameEx(playerid));
		 	SendClientMessageEx(giveplayerid, COLOR_WHITE, string);
	    }
	    else
	    {
	        PlayerInfo[giveplayerid][pFreezeCar] = 0;
	        format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s %s has unfrozen %s vehicle assets.", rank, GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
	    	ABroadCast(COLOR_YELLOW,string, 2);
	    	format(string, sizeof(string), "You have unfrozen %s's vehicle assets.", GetPlayerNameEx(giveplayerid));
		 	SendClientMessageEx(playerid, COLOR_WHITE, string);
		 	format(string, sizeof(string), "Your vehicle assets have been unfrozen by %s", GetPlayerNameEx(playerid));
		 	SendClientMessageEx(giveplayerid, COLOR_WHITE, string);
	    }
	}
	else
	{
	    return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /freezeassets [player] [house/car]");
	}
	return 1;
}

CMD:reward(playerid, params[])
{

    if(!IsAJudge(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not part of the Judicial System!");
	if(PlayerInfo[playerid][pRank] < 4) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command - only rank 4+ can do this.");

	new
		giveplayerid,
		money;

	if(sscanf(params, "ud", giveplayerid, money)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /reward [player] [money(max of $50,000)]");
	if(giveplayerid == playerid) return SendClientMessageEx(playerid, COLOR_GRAD1, "You can't use this command on yourself!");
	if(IsPlayerConnected(giveplayerid))
	{
		new
			string[64 + (MAX_PLAYER_NAME * 2)];

  		if(money < 1 || money > 50000) return SendClientMessageEx(playerid, COLOR_GRAD5, "Reward amount cannot be lower than $1 or higher than $50,000!");
    	new rank[GROUP_MAX_RANK_LEN], division[GROUP_MAX_DIV_LEN], employer[GROUP_MAX_NAME_LEN];
   		GetPlayerGroupInfo(playerid, rank, division, employer);
	    format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s %s(%d) has just rewarded %s(%d) $%d.", rank, GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), money);
	    ABroadCast(COLOR_YELLOW,string, 2);

		format(string, sizeof(string), "AdmCmd: %s %s has just rewarded %s $%d", rank, GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), money);
		Log("logs/rpspecial.log", string);
		Tax -= money;
  		GivePlayerCash(giveplayerid, money);
    	format(string, sizeof(string), "You have given a reward of $%d to %s.", money, GetPlayerNameEx(giveplayerid));
	    SendClientMessageEx(playerid, COLOR_WHITE, string);
	    format(string, sizeof(string), "You have recieved a reward of $%d from %s %s.", money, rank, GetPlayerNameEx(playerid));
	   	SendClientMessageEx(giveplayerid, COLOR_WHITE, string);
	}
	return 1;
}

CMD:reversejudgement(playerid, params[])
{

    if(!IsAJudge(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not part of the Judicial System!");
	if(PlayerInfo[playerid][pRank] < 4) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command - only rank 4+ can do this.");

	new
		giveplayerid; // For future reference - sscanf plugin is 3 times as fast as ReturnUser, even when used on only one argument

	if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /reversejudgement [player]");
	if(giveplayerid == playerid) return SendClientMessageEx(playerid, COLOR_GRAD1, "You can't use this command on yourself!");
	if(IsPlayerConnected(giveplayerid))
	{
 		if(PlayerInfo[giveplayerid][pJudgeJailTime] != 0)
   		{
     		new rank[GROUP_MAX_RANK_LEN], division[GROUP_MAX_DIV_LEN], employer[GROUP_MAX_NAME_LEN], string[52 + (MAX_PLAYER_NAME * 2)];
       		GetPlayerGroupInfo(playerid, rank, division, employer);
			if(PlayerInfo[giveplayerid][pJailTime] != 0) PlayerInfo[giveplayerid][pJailTime] = 0;
			PlayerInfo[giveplayerid][pJudgeJailTime] = 0;
   			switch(PlayerInfo[playerid][pSex])
			{
			    case 1: format(string, sizeof(string), "%s %s has reversed %s's judgement, he is free to go.", rank, GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
			    case 2: format(string, sizeof(string), "%s %s has reversed %s's judgement, she is free to go.", rank, GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
			}
   			SendGroupMessage(1, DEPTRADIO, string);
   		}
	    else
   		{
        	SendClientMessageEx(playerid, COLOR_GRAD1, "That person doesn't have a jail/prison sentence.");
   		}
	}
	return 1;
}

CMD:commute(playerid, params[])
{
	if(IsAGovernment(playerid) && PlayerInfo[playerid][pRank] >= Group_GetMaxRank(PlayerInfo[playerid][pMember]))
 	{
		new
			giveplayerid;

		if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /commute [player]");
		if(giveplayerid == playerid) return SendClientMessageEx(playerid, COLOR_GRAD1, "You can't use this command on yourself!");
		if(IsPlayerConnected(giveplayerid))
		{
			if(PlayerInfo[giveplayerid][pJudgeJailTime] != 0)
		    {
				new string[68 + (MAX_PLAYER_NAME * 2)];
				if(PlayerInfo[giveplayerid][pJailTime] != 0) PlayerInfo[giveplayerid][pJailTime] = PlayerInfo[giveplayerid][pJailTime]/2;
				PlayerInfo[giveplayerid][pJudgeJailTime] = PlayerInfo[giveplayerid][pJudgeJailTime]/2;
				switch(PlayerInfo[playerid][pSex])
				{
					case 1: format(string, sizeof(string), "President %s has commuted %s, his sentence is now half (%d seconds).", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), PlayerInfo[giveplayerid][pJudgeJailTime]);
					case 2: format(string, sizeof(string), "President %s has commuted %s, her sentence is now half (%d seconds).", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), PlayerInfo[giveplayerid][pJudgeJailTime]);
				}
			    SendGroupMessage(1, DEPTRADIO, string);
	    	}
	    	else
   			{
	        	SendClientMessageEx(playerid, COLOR_GRAD1, "That person doesn't have a jail/prison sentence.");
   			}
		}
   	}
   	else
   	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "Only the President can use this command.");
	}
	return 1;
}

CMD:pardon(playerid, params[])
{
    if(IsAGovernment(playerid) && PlayerInfo[playerid][pRank] >= Group_GetMaxRank(PlayerInfo[playerid][pMember]))
    {
		new
			giveplayerid;

        if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /pardon [player]");
		if(giveplayerid == playerid) return SendClientMessageEx(playerid, COLOR_GRAD1, "You can't use this command on yourself!");
		if(IsPlayerConnected(giveplayerid))
		{
		    if(PlayerInfo[giveplayerid][pJudgeJailTime] != 0)
		    {
				new string[58 + (MAX_PLAYER_NAME * 2)];
		        if(PlayerInfo[giveplayerid][pJailTime] != 0) PlayerInfo[giveplayerid][pJailTime] = 0;
		        PlayerInfo[giveplayerid][pJudgeJailTime] = 0;
		        switch(PlayerInfo[playerid][pSex])
				{
				    case 1: format(string, sizeof(string), "President %s has forgiven %s of his crimes, he's now free.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
				    case 2: format(string, sizeof(string), "President %s has forgiven %s of his crimes, she's now free.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
				}
			    SendGroupMessage(1, DEPTRADIO, string);
		    }
		    else
	   		{
	       		SendClientMessageEx(playerid, COLOR_GRAD1, "That person doesn't have a jail/prison sentence.");
	   		}
		}
	}
 	else
  	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "Only the President can use this command.");
  	}
	return 1;
}

CMD:wants(playerid, params[])
{
    if(IsACop(playerid) || IsAJudge(playerid))
    {
    	if(JudgeOnlineCheck() == 0) return SendClientMessageEx(playerid, COLOR_GRAD4, "There must be at least one judge online to use this command!");
		SendClientMessageEx(playerid, COLOR_YELLOW, "Outstanding Warrants List:");

		new
			fCounter,
			string[128];

		//foreach(new i: Player)
		for(new i = 0; i < MAX_PLAYERS; ++i)
		{
			if(IsPlayerConnected(i))
			{
				if(!isnull(PlayerInfo[i][pWarrant]) || PlayerInfo[i][pWarrant] != 0)
				{
					format(string, sizeof(string), "%s (%d) - reason: %s.",GetPlayerNameEx(i), i, PlayerInfo[i][pWarrant]);
					SendClientMessageEx(playerid, COLOR_GRAD1, string);
					++fCounter;
				}
			}	
		}
		if(fCounter <= 0)
		{
		    SendClientMessageEx(playerid, COLOR_GRAD1, "Nobody has any pending warrants.");
		}
  	}
	return 1;
}

CMD:mywarrants(playerid, params[])
{
    if(IsPlayerInRangeOfPoint(playerid, 3.0, 361.8299,173.7117,1008.3828))
    {
		if(!isnull(PlayerInfo[playerid][pWarrant]))
  		{
			SendClientMessageEx(playerid, COLOR_WHITE, "You do have active warrants for your arrest. Please considering calling 911 to turn yourself in.");
   		}
     	else
      	{
       		SendClientMessageEx(playerid, COLOR_WHITE, "You do not have active warrants.");
      	}
   	}
    else
    {
    	SendClientMessageEx(playerid, COLOR_GRAD1, "You need to be at the point in City Hall to check if you have active warrants.");
    }
	return 1;
}

CMD:jarrest(playerid, params[])
{
    if(IsAJudge(playerid))
	{
 		if(!IsAtArrestPoint(playerid, 4))
		{
  			SendClientMessageEx(playerid, COLOR_GREY, "You aren't at the arrest point.");
	    	return 1;
		}
		new suspect = GetClosestPlayer(playerid), string[256];
		if(IsPlayerConnected(suspect))
		{
			if(ProxDetectorS(5.0, playerid,suspect))
			{
				if(PlayerInfo[suspect][pJudgeJailType] != 1) { return SendClientMessageEx(playerid, COLOR_GREY, "That person doesn't need to complete a sentence in jail."); }
				format(string, sizeof(string), "* You arrested %s!", GetPlayerNameEx(suspect));
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
				ResetPlayerWeaponsEx(suspect);
				for(new x; x < MAX_PLAYERVEHICLES; x++) if(PlayerVehicleInfo[suspect][x][pvTicket] >= 1) {
					PlayerVehicleInfo[suspect][x][pvTicket] = 0;
				}
				SetPlayerInterior(suspect, 5);
				SetPlayerPos(suspect,318.5971,312.9619,999.1484);
				PlayerInfo[suspect][pJailTime] = PlayerInfo[suspect][pJudgeJailTime];
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
				if(PlayerCuffed[suspect] == 2)
				{
					SetPlayerHealth(suspect, GetPVarFloat(suspect, "cuffhealth"));
					SetPlayerArmor(suspect, GetPVarFloat(suspect, "cuffarmor"));
					DeletePVar(suspect, "cuffhealth");
					DeletePVar(suspect, "PlayerCuffed");
				}
				PlayerCuffed[suspect] = 0;
				DeletePVar(suspect, "PlayerCuffed");
				PlayerCuffedTime[suspect] = 0;
				PlayerInfo[suspect][pVW] = 0;
				SetPlayerVirtualWorld(suspect, 0);
			}
		}
	}
	return 1;
}

CMD:deliver(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 8.0, 1991.7953,-2321.2532,13.5469))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You're not at the Los Santos International Airport.");
		return 1;
	}
	new giveplayerid;
	if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /deliver [player]");
	if(PlayerInfo[playerid][pRank] < 1)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "You must be at least rank 1.");
		return 1;
	}
	if(IsPlayerConnected(giveplayerid))
	{
		if(giveplayerid == playerid) { SendClientMessageEx(playerid, COLOR_GREY, "   Can't throw yourself into prison!"); return 1; }
		if(PlayerInfo[giveplayerid][pJudgeJailTime] == 0 && PlayerInfo[giveplayerid][pJudgeJailType] != 2) { SendClientMessageEx(playerid, COLOR_GREY, "That person doesn't need to be in prison!"); return 1; }
		if(ProxDetectorS(8.0, playerid, giveplayerid))
		{
			new string[37 + MAX_PLAYER_NAME];
  			DeletePVar(giveplayerid, "IsFrozen");
			format(string, sizeof(string), "* You've brought %s to the Department of Corrections.", GetPlayerNameEx(giveplayerid));
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
			format(string, sizeof(string), "* %s brought you to the Department of Corrections.", GetPlayerNameEx(playerid));
			SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
			GameTextForPlayer(giveplayerid, "~w~Welcome to ~n~~r~the Department of Corrections", 5000, 3);
			ClearAnimations(giveplayerid);
			PlayerCuffed[giveplayerid] = 0;
			DeletePVar(giveplayerid, "PlayerCuffed");
			format(PlayerInfo[giveplayerid][pPrisonedBy], 24, "%s", GetPlayerNameEx(playerid));
			format(PlayerInfo[giveplayerid][pPrisonReason], 128, "[IC] Judge Sentence");
			PlayerInfo[giveplayerid][pWantedLevel] = 0;
			SetPlayerToTeamColor(giveplayerid);
			SetPlayerWantedLevel(giveplayerid, 0);
			SetPlayerSkin(giveplayerid, 50);
			PhoneOnline[giveplayerid] = 1;
			PlayerInfo[giveplayerid][pJailTime] = PlayerInfo[giveplayerid][pJudgeJailTime];
			SetPlayerInterior(giveplayerid, 10);
			PlayerInfo[giveplayerid][pInt] = 10;
			SetPlayerSkin(giveplayerid, 50);
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;
			SetPlayerColor(giveplayerid, TEAM_ORANGE_COLOR);
			new rand = random(sizeof(DocPrison));
			SetPlayerFacingAngle(giveplayerid, 0);
			SetPlayerPos(giveplayerid, DocPrison[rand][0], DocPrison[rand][1], DocPrison[rand][2]);
			ResetPlayerWeaponsEx(giveplayerid);
			Player_StreamPrep(giveplayerid, DocPrison[rand][0], DocPrison[rand][1], DocPrison[rand][2], FREEZE_TIME);
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
	return 1;
}
