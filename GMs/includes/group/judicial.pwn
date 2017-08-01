/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$f
	|__/  \__/ \______/         |__/  |__/|__/

						Judicial Group Type

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
stock JudgeOnlineCheck()
{
	foreach(new i: Player)
	{
		if(IsAJudge(i))	return 1;
	}	
	return 0;
}

/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

					Offline Warranting

				Next Generation Gaming, LLC
	(created by Next Generation Gaming Development Team)

	* Copyright (c) 2016, Next Generation Gaming, LLC
*/

// Created by Bohemoth

#include <YSI\y_hooks>

forward OfflineWarranting(index);
public OfflineWarranting(index)
{
	new string[128], name[24], reason[64];
	GetPVarString(index, "OfflineWarrant", name, 24);
	GetPVarString(index, "WarrantRes", reason, 64);

	if(cache_affected_rows()) {
		format(string, sizeof(string), "You have successfully warranted %s's account.", name);
		SendClientMessageEx(index, COLOR_WHITE, string);

		format(string, sizeof(string), "You are hereby commanded to apprehend and present to the court %s to answer the charges of:", name);
		SendGroupMessage(1, DEPTRADIO, string);
		format(string, sizeof(string), "%s", reason);
		SendGroupMessage(1, DEPTRADIO, string);

		//format(string, sizeof(string), "%s offline warranted %s for %s", GetPlayerNameEx(index), name, reason);
		//Log("logs/warrant.log", string);
	}
	else {
		format(string, sizeof(string), "There was an issue with warranting %s's account.", name);
		SendClientMessageEx(index, COLOR_WHITE, string);
	}

	DeletePVar(index, "OfflineWarrant");
	DeletePVar(index, "WarrantRes");
	return 1;
}

forward OfflineWarrantWD(index);
public OfflineWarrantWD(index)
{
	new string[128], name[24];
	GetPVarString(index, "OfflineWarrant", name, 24);

	if(cache_affected_rows()) {
		format(string, sizeof(string), "You have successfully recalled the warrant on %s's account.", name);
		SendClientMessageEx(index, COLOR_WHITE, string);

		//format(string, sizeof(string), "%s recalled the warrant on %s's account", GetPlayerNameEx(index), name);
		//Log("logs/warrant.log", string);
	}
	else {
		format(string, sizeof(string), "There was an issue with recalling the warrant on %s's account.", name);
		SendClientMessageEx(index, COLOR_WHITE, string);
	}

	DeletePVar(index, "OfflineWarrant");
	return 1;
}


CMD:owarrant(playerid, params[]) {
	if(!IsAJudge(playerid)) {
  		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not part of the Judicial System!");
  		return 1;
	}
	if(PlayerInfo[playerid][pRank] < 3) {
  		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command - only rank 3+ can do this.");
  		return 1;
	}

	new string[128], name[MAX_PLAYER_NAME], reason[64];
	if(sscanf(params, "s[24]s[64]", name, reason)) return SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /owarrant [player name] [crime]");

	if(!IsPlayerConnected(ReturnUser(name))) {
		new query[512];

		SetPVarString(playerid, "OfflineWarrant", name);
		SetPVarString(playerid, "WarrantRes", reason);

		format(string, sizeof(string), "Attempting to warrant %s's account for %s...", name, reason);
		SendClientMessageEx(playerid, COLOR_YELLOW, string);

		mysql_format(MainPipeline, query,sizeof(query),"UPDATE `accounts` SET `Warrants` = '%e' WHERE `Warrants` = '' AND `Username` = '%e'", reason, name);
		mysql_tquery(MainPipeline, query, "OfflineWarranting", "i", playerid);
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot offline warrant online players!");
	return 1;
}

CMD:owarrantwd(playerid, params[])
{
    if(!IsAJudge(playerid))
	{
  		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not part of the Judicial System!");
  		return 1;
 	}
	if(PlayerInfo[playerid][pMember] < 3)
	{
  		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command - only rank 3+ can do this.");
  		return 1;
  	}

  	new string[128], name[MAX_PLAYER_NAME];
	if(sscanf(params, "s[24]s[64]", name)) return SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /owarrantwd [player name]");

	if(!IsPlayerConnected(ReturnUser(name))) {
		new query[512];

		SetPVarString(playerid, "OfflineWarrant", name);

		format(string, sizeof(string), "Attempting to recall the warrant on %s's account...", name);
		SendClientMessageEx(playerid, COLOR_YELLOW, string);

		mysql_format(MainPipeline, query, sizeof(query), "UPDATE `accounts` SET `Warrants` = '' WHERE `Warrants` != '' AND `Username` = '%e'", name);
		mysql_tquery(MainPipeline, query, "OfflineWarrantWD", "i", playerid);
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot offline warrant online players!");
	return 1;
}

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
				SetPlayerPos(giveplayerid, 1494.8669, -1552.0634, 1127.0251);
		    	SetPlayerFacingAngle(giveplayerid, 176.9777);
		    	SetPlayerVirtualWorld(giveplayerid, GetPlayerVirtualWorld(playerid));
		    	SetPlayerInterior(giveplayerid, GetPlayerInterior(playerid));
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

		foreach(new i: Player)
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
		if(fCounter == 0)
		{
  			SendClientMessageEx(playerid, COLOR_GRAD1, "Nobody is pending judgement.");
		}
  	}
	return 1;
}

CMD:freezeassets(playerid, params[])
{
  	if(!IsAJudge(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You are not part of the Judicial System!");
	if(PlayerInfo[playerid][pRank] < 4) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command - only rank 4+ can do this.");
	new giveplayerid, houseorcar[8];
	if(sscanf(params, "us[8]", giveplayerid, houseorcar)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /freezeassets [player] [house/car/bank]");
	if(giveplayerid == playerid) return SendClientMessageEx(playerid, COLOR_GRAD1, "You can't use this command on yourself!");
	if(!IsPlayerConnected(giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");
	new string[128],
		rank[GROUP_MAX_RANK_LEN],
		division[GROUP_MAX_DIV_LEN],
		employer[GROUP_MAX_NAME_LEN];

	szMiscArray[0] = 0;
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

	   	 	format(szMiscArray, sizeof(szMiscArray), "%s %s has frozen %s house assets.", rank, GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
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

	   	 	format(szMiscArray, sizeof(szMiscArray), "%s %s has unfrozen %s house assets.", rank, GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
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

		 	format(szMiscArray, sizeof(szMiscArray), "%s %s has frozen %s vehicle assets.", rank, GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
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

		 	format(szMiscArray, sizeof(szMiscArray), "%s %s has unfrozen %s vehicle assets.", rank, GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
	    }
	}
	else if(strcmp(houseorcar, "bank", true) == 0)
	{
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

   	 		format(szMiscArray, sizeof(szMiscArray), "%s %s has frozen %s bank assets.", rank, GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
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

   	 		format(szMiscArray, sizeof(szMiscArray), "%s %s has unfrozen %s bank assets.", rank, GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
		}
	}
	else
	{
	    return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /freezeassets [player] [house/car/bank]");
	}
	GroupLogEx(PlayerInfo[playerid][pMember], szMiscArray, 1);
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
   			SendGroupMessage(GROUP_TYPE_LEA, DEPTRADIO, string);
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
	cmd_pardon(playerid, "");
	SendClientMessageEx(playerid, COLOR_GRAD1, "You can also use /pardon.");
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
		        if(PlayerInfo[giveplayerid][pJailTime] != 0) PlayerInfo[giveplayerid][pJailTime] = 2;
		        PlayerInfo[giveplayerid][pJudgeJailTime] = 2;
		        switch(PlayerInfo[playerid][pSex])
				{
				    case 1: format(string, sizeof(string), "President %s has forgiven %s of his crimes, he's now free.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
				    case 2: format(string, sizeof(string), "President %s has forgiven %s of his crimes, she's now free.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
				}
			    SendGroupMessage(GROUP_TYPE_LEA, DEPTRADIO, string);
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

		foreach(new i: Player)
		{
			if(!isnull(PlayerInfo[i][pWarrant]) || PlayerInfo[i][pWarrant] != 0)
			{
				format(string, sizeof(string), "%s (%d) - reason: %s.",GetPlayerNameEx(i), i, PlayerInfo[i][pWarrant]);
				SendClientMessageEx(playerid, COLOR_GRAD1, string);
				++fCounter;
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
				ClearAnimationsEx(suspect);
				if(PlayerCuffed[suspect] == 2)
				{
					SetHealth(suspect, GetPVarFloat(suspect, "cuffhealth"));
					SetArmour(suspect, GetPVarFloat(suspect, "cuffarmor"));
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
			ClearAnimationsEx(giveplayerid);
			PlayerCuffed[giveplayerid] = 0;
			DeletePVar(giveplayerid, "PlayerCuffed");
			format(PlayerInfo[giveplayerid][pPrisonedBy], 24, "%s", GetPlayerNameEx(playerid));
			format(PlayerInfo[giveplayerid][pPrisonReason], 128, "[IC] Judge Sentence");
			PlayerInfo[giveplayerid][pWantedLevel] = 0;
			SetPlayerToTeamColor(giveplayerid);
			SetPlayerWantedLevel(giveplayerid, 0);
			
			Prison_SetPlayerSkin(giveplayerid);
			PhoneOnline[giveplayerid] = 1;
			PlayerInfo[giveplayerid][pJailTime] = PlayerInfo[giveplayerid][pJudgeJailTime];
			SetPlayerInterior(giveplayerid, 10);
			PlayerInfo[giveplayerid][pInt] = 10;
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


CMD:warrant(playerid, params[])
{
	if(!IsAJudge(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not part of the Judicial System!");
 	if(PlayerInfo[playerid][pRank] < 3)
	{
  		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command - only rank 3+ can do this.");
  		return 1;
	}

	new string[128], crime[64], giveplayerid;
	if(sscanf(params, "us[64]", giveplayerid, crime)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /warrant [player] [crime]");

	if(giveplayerid == playerid) return SendClientMessageEx(playerid, COLOR_GRAD1, "You can't place warrants on yourself!");
	if(IsPlayerConnected(giveplayerid))
	{
		if(!isnull(PlayerInfo[giveplayerid][pWarrant])) return SendClientMessageEx(playerid, COLOR_GRAD5, "That person has active warrants already.");
		format(PlayerInfo[giveplayerid][pWarrant], 64, crime);
		format(string, sizeof(string), "You are hereby commanded to apprehend and present to the court %s to answer the charges of:", GetPlayerNameEx(giveplayerid));
		SendGroupMessage(GROUP_TYPE_LEA, DEPTRADIO, string);
		format(string, sizeof(string), "%s", crime);
		SendGroupMessage(GROUP_TYPE_JUDICIAL, DEPTRADIO, string);
		format(string, sizeof(string), "%s has warranted %s to answer for his charges against the Sovereign Republic.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
		SendGroupMessage(GROUP_TYPE_JUDICIAL, DEPTRADIO, string);
		GroupLogEx(PlayerInfo[playerid][pMember], string, 0);
		return 1;
	}
	return 1;
}

CMD:warrantwd(playerid, params[])
{
    if(!IsAJudge(playerid))
	{
  		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not part of the Judicial System!");
  		return 1;
 	}
	if(PlayerInfo[playerid][pMember] < 3)
	{
  		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command - only rank 3+ can do this.");
  		return 1;
  	}

  	new string[128], giveplayerid;
  	if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /warrantwd [player]");

	if(giveplayerid == playerid) return SendClientMessageEx(playerid, COLOR_GRAD1, "You can't remove warrants on yourself!");
	if(IsPlayerConnected(giveplayerid))
	{
 		if(strlen(PlayerInfo[giveplayerid][pWarrant]) == 0) return SendClientMessageEx(playerid, COLOR_GRAD5, "That person doesn't have any active warrants.");
		format(PlayerInfo[giveplayerid][pWarrant], 128, "");
		format(string, sizeof(string), "You have successfully recalled %s's warrant.", GetPlayerNameEx(giveplayerid));
  		SendClientMessageEx(playerid, COLOR_GRAD2, string);
		format(string, sizeof(string), "%s has withdrawn the warrant on %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
		SendGroupMessage(GROUP_TYPE_JUDICIAL, DEPTRADIO, string);
		GroupLogEx(PlayerInfo[playerid][pMember], string, 0);
		return 1;
	}
	return 1;
}

CMD:warrantarrest(playerid, params[])
{
    new string[256];

    if(IsACop(playerid))
	{
	    if(JudgeOnlineCheck() == 0) return SendClientMessageEx(playerid, COLOR_GRAD4, "There must be at least one judge online to do this!");
        if(!IsAtArrestPoint(playerid, 3))
		{
  			SendClientMessageEx(playerid, COLOR_GREY, "You aren't at a warrant arrest point.");
	    	return 1;
		}

		new suspect = GetClosestPlayer(playerid);
		if(IsPlayerConnected(suspect))
		{
			if(ProxDetectorS(5.0, playerid,suspect))
			{
				if(strlen(PlayerInfo[suspect][pWarrant]) < 1)
				{
	   				SendClientMessageEx(playerid, COLOR_GREY, "The person must have active warrants.");
				    return 1;
				}
				format(string, sizeof(string), "* You warrant arrested %s!", GetPlayerNameEx(suspect));
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
				ResetPlayerWeaponsEx(suspect);
				format(string, sizeof(string), "<< Defendant %s has been delivered to the courtroom pending trial by %s >>", GetPlayerNameEx(suspect), GetPlayerNameEx(playerid));
				SendGroupMessage(GROUP_TYPE_JUDICIAL, DEPTRADIO, string);
				SetPlayerInterior(suspect, 5);
				PlayerInfo[suspect][pInt] = 1;
				SetPlayerVirtualWorld(suspect, 0);
				PlayerInfo[suspect][pVW] = 0;
				new rand = random(sizeof(WarrantJail));
				SetPlayerFacingAngle(suspect, 180);
				SetPlayerPos(suspect, WarrantJail[rand][0], WarrantJail[rand][1], WarrantJail[rand][2]);
				if(rand != 0) courtjail[suspect] = 2;
				else courtjail[suspect] = 1;
				SetCameraBehindPlayer(suspect);
				DeletePVar(suspect, "IsFrozen");
				PlayerCuffed[suspect] = 0;
				DeletePVar(suspect, "PlayerCuffed");
				PlayerCuffedTime[suspect] = 0;
				PhoneOnline[suspect] = 1;
				PlayerInfo[suspect][pArrested] += 1;
				SetPlayerFree(suspect,playerid, "was warrant arrested");
				PlayerInfo[suspect][pWantedLevel] = 0;
				SetPlayerToTeamColor(suspect);
				SetPlayerWantedLevel(suspect, 0);
				WantLawyer[suspect] = 1;
				ClearAnimationsEx(suspect);
				PlayerInfo[suspect][pBeingSentenced] = 60;
				SetPlayerColor(suspect, SHITTY_JUDICIALSHITHOTCH);
				SendClientMessageEx(suspect, COLOR_LIGHTBLUE, "You have been arrested for a pending warrant on you, you'll be attended by a judge soon.");
				Player_StreamPrep(suspect, WarrantJail[rand][0], WarrantJail[rand][1], WarrantJail[rand][2], FREEZE_TIME);
				
			}
		}
		else
		{
  			SendClientMessageEx(playerid, COLOR_GREY, "   No-one close enough to arrest.");
	    	return 1;
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "   You are not a law enforcement officer!");
   		return 1;
	}
	return 1;
}

CMD:adjourn(playerid, params[])
{
	new string[128], giveplayerid;

    if(!IsAJudge(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not part of the Judicial System!");
	if(PlayerInfo[playerid][pRank] < 3) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command - only rank 3+ can do this.");
	if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /adjourn [player]");
	if(giveplayerid == playerid) return SendClientMessageEx(playerid, COLOR_GRAD1, "You can't use this command on yourself!");
	if(IsPlayerConnected(giveplayerid))
	{
	    if(PlayerInfo[giveplayerid][pBeingSentenced])
	    {
	    	PlayerInfo[giveplayerid][pBeingSentenced] = 0;
	    	TogglePlayerControllable(giveplayerid, 1);
	    	DeletePVar(giveplayerid, "IsFrozen");
			PhoneOnline[giveplayerid] = 0;
			format(PlayerInfo[giveplayerid][pWarrant], 128, "");
	    	format(string, sizeof(string), "You have released %s from the courtroom.", GetPlayerNameEx(giveplayerid));
	    	SendClientMessageEx(playerid, COLOR_WHITE, string);
	    	format(string, sizeof(string), "%s has released you from the courtroom, you can now leave.", GetPlayerNameEx(playerid));
	    	SendClientMessageEx(giveplayerid, COLOR_WHITE, string);
		}
		else SendClientMessageEx(playerid, COLOR_GRAD2, "The person needs to be on the courtroom being sentenced");
	}
	return 1;
}

CMD:sentence(playerid, params[]) {

	new giveplayerid;

    if(!IsAJudge(playerid)) {
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not part of the Judicial System!");
	}
	else if(PlayerInfo[playerid][pRank] < 3) {
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command - only rank 3+ can do this.");
	}
	else if(sscanf(params, "u", giveplayerid)) {
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /sentence [player]");
	}
	else if(IsPlayerConnected(giveplayerid)) {
		if(giveplayerid == playerid) {
			SendClientMessageEx(playerid, COLOR_GRAD1, "You can't use this command on yourself!");
		}
 		else if(PlayerInfo[giveplayerid][pBeingSentenced]) {
			PlayerInfo[giveplayerid][pBeingSentenced] = 0;
	    	TogglePlayerControllable(giveplayerid, 0);
	    	SetPVarInt(giveplayerid, "IsFrozen", 1);
			PhoneOnline[giveplayerid] = 1;
			PlayerInfo[giveplayerid][pWarrant][0] = 0;
			SetPlayerPos(giveplayerid, 1384.0507,-1688.8254,13.5341);
			SetPlayerInterior(giveplayerid, 0);
			PlayerInfo[giveplayerid][pInt] = 0;
			SetPlayerVirtualWorld(giveplayerid, 0);
			PlayerInfo[giveplayerid][pVW] = 0;
			new string[58 + MAX_PLAYER_NAME];
  			format(string, sizeof(string), "You have released %s from the courtroom.", GetPlayerNameEx(giveplayerid));
    		SendClientMessageEx(playerid, COLOR_WHITE, string);
	    	format(string, sizeof(string), "%s has released you from the courtroom, you can now leave.", GetPlayerNameEx(playerid));
	    	SendClientMessageEx(giveplayerid, COLOR_WHITE, string);
		}
		else SendClientMessageEx(playerid, COLOR_GRAD2, "The person needs to be in the courtroom being sentenced.");
	}
	else SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid player specified.");
	return 1;
}

CMD:trial(playerid, params[])
{
	new string[128], giveplayerid;

    if(!IsAJudge(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not part of the Judicial System!");
	if(PlayerInfo[playerid][pRank] < 3) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command - only rank 3+ can do this.");
	if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /trial [player]");
	if(giveplayerid == playerid) return SendClientMessageEx(playerid, COLOR_GRAD1, "You can't use this command on yourself!");
	if(IsPlayerConnected(giveplayerid))
	{
	    if(PlayerInfo[giveplayerid][pBeingSentenced])
	    {
	    	PlayerInfo[giveplayerid][pBeingSentenced] += 10;
	    	format(string, sizeof(string), "You have extended %s's courtroom time by 10 minutes, courtroom time: %d", GetPlayerNameEx(giveplayerid), PlayerInfo[giveplayerid][pBeingSentenced]);
	    	SendClientMessageEx(playerid, COLOR_WHITE, string);
	    	format(string, sizeof(string), "%s has extended your courtroom time by 10 minutes, courtroom time: %d", GetPlayerNameEx(playerid), PlayerInfo[giveplayerid][pBeingSentenced]);
	    	SendClientMessageEx(giveplayerid, COLOR_WHITE, string);
		}
		else SendClientMessageEx(playerid, COLOR_GRAD2, "The person needs to be in the courtroom being sentenced");
	}
	return 1;
}

CMD:subpoena(playerid, params[])
{
	new string[128], dates[32], message[64], giveplayerid;

    if(!IsAJudge(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not part of the Judicial System!");
	if(PlayerInfo[playerid][pRank] < 1) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command - only rank 1+ can do this.");
	if(sscanf(params, "us[32]s[64]", giveplayerid, dates, message)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /subpoena [player] [date] [message]");
	if(giveplayerid == playerid) return SendClientMessageEx(playerid, COLOR_GRAD1, "You can't use this command on yourself!");
	if(IsPlayerConnected(giveplayerid))
	{
	    SendClientMessageEx(giveplayerid, COLOR_WHITE, "|___________ Important Message from the Courts ___________|");
	    format(string, sizeof(string), "You have been summoned for a Court Appearance on the day of %s for the following reason(s): %s", dates, message);
		SendClientMessageEx(giveplayerid, COLOR_YELLOW, string);
		SendClientMessageEx(giveplayerid, COLOR_WHITE, "|_________________________________________________________|");
		format(string, sizeof(string), "You have summoned %s for a Court Appearance", GetPlayerNameEx(giveplayerid));
		SendClientMessageEx(playerid, COLOR_WHITE, string);
	}
	return 1;
}

CMD:judgejail(playerid, params[])
{
    if(!IsAJudge(playerid))
	{
  		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not part of the Judicial System!");
  		return 1;
	}
	if(PlayerInfo[playerid][pRank] < 3)
	{
  		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command - only rank 3+ can do this.");
  		return 1;
	}

	new string[128], giveplayerid, jailtime, reason[64];
	if(sscanf(params, "uds[64]", giveplayerid, jailtime, reason)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /judgejail [player] [time (minutes)] [reason]");

	if(giveplayerid == playerid) return SendClientMessageEx(playerid, COLOR_GRAD1, "You can't use this command on yourself!");
	if(IsPlayerConnected(giveplayerid))
	{
		if(!PlayerInfo[giveplayerid][pBeingSentenced]) return SendClientMessageEx(playerid, COLOR_GRAD5, "That person isn't being sentenced!");
		if(jailtime < 5)
		{
			return SendClientMessageEx(playerid, COLOR_GRAD5, "Sentence must be at least 5 minute!");
		}
		if(jailtime > 120)
		{
			return SendClientMessageEx(playerid, COLOR_GRAD5, "Maximum sentence is 2 Hours / 120 Minutes");
		}
		PlayerInfo[giveplayerid][pJudgeJailType] = 1;
		PlayerInfo[giveplayerid][pJudgeJailTime] = jailtime*60;
		format(string, sizeof(string), "You have sentenced %s to fulfill %d minutes in jail, reason: %s", GetPlayerNameEx(giveplayerid), jailtime, reason);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "You have been sentenced to fulfill %d minutes in jail by %s, reason: %s", jailtime, GetPlayerNameEx(playerid), reason);
		SendClientMessageEx(giveplayerid, COLOR_WHITE, string);
		if(IsACop(giveplayerid))
		{
		    SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE,"* You have been auto-removed from your faction by being sentenced to jail, you are now a civilian again.");
			PlayerInfo[giveplayerid][pMember] = INVALID_GROUP_ID;
			PlayerInfo[giveplayerid][pLeader] = INVALID_GROUP_ID;
			PlayerInfo[giveplayerid][pRank] = INVALID_RANK;
			PlayerInfo[giveplayerid][pDuty] = 0;
			if(!IsValidSkin(GetPlayerSkin(giveplayerid)))
			{
			    new rand = random(sizeof(CIV));
				SetPlayerSkin(giveplayerid,CIV[rand]);
				PlayerInfo[giveplayerid][pModel] = CIV[rand];
			}
			player_remove_vip_toys(giveplayerid);
			SetPlayerToTeamColor(giveplayerid);
			pTazer{giveplayerid} = 0;
		}
	}
	return 1;
}

CMD:judgeprison(playerid, params[])
{
    if(!IsAJudge(playerid))
	{
  		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not part of the Judicial System!");
  		return 1;
	}
	if(PlayerInfo[playerid][pRank] < 3)
	{
  		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command - only rank 3+ can do this.");
  		return 1;
	}

	new string[128], giveplayerid, jailtime, reason[64];
	if(sscanf(params, "uds[64]", giveplayerid, jailtime, reason)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /judgeprison [player] [time (mins)] [reason]");

	if(giveplayerid == playerid) return SendClientMessageEx(playerid, COLOR_GRAD1, "You can't use this command on yourself!");
	if(IsPlayerConnected(giveplayerid))
	{
	    if(!PlayerInfo[giveplayerid][pBeingSentenced]) return SendClientMessageEx(playerid, COLOR_GRAD5, "That person isn't being sentenced!");
		if(jailtime < 5)
		{
			return SendClientMessageEx(playerid, COLOR_GRAD5, "Sentence must be at least 5 minute!");
		}
		if(jailtime > 120)
		{
			return SendClientMessageEx(playerid, COLOR_GRAD5, "Maximum sentence is 2 Hours / 120 Minutes");
		}
		PlayerInfo[giveplayerid][pJudgeJailType] = 2;
		PlayerInfo[giveplayerid][pJudgeJailTime] = jailtime*60;
		format(string, sizeof(string), "You have sentenced %s to fulfill %d minutes in prison, reason: %s", GetPlayerNameEx(giveplayerid), jailtime, reason);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		format(string, sizeof(string), "You have been sentenced to fulfill %d minutes in prison by %s, reason: %s", jailtime, GetPlayerNameEx(playerid), reason);
		SendClientMessageEx(giveplayerid, COLOR_WHITE, string);
		if(IsACop(giveplayerid))
		{
		    SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE,"* You have been auto-removed from your faction by being sentenced to jail, you are now a civilian again.");
			PlayerInfo[giveplayerid][pMember] = INVALID_GROUP_ID;
			PlayerInfo[giveplayerid][pLeader] = INVALID_GROUP_ID;
			PlayerInfo[giveplayerid][pRank] = INVALID_RANK;
			PlayerInfo[giveplayerid][pDuty] = 0;
			if(!IsValidSkin(GetPlayerSkin(giveplayerid)))
			{
			    new rand = random(sizeof(CIV));
				SetPlayerSkin(giveplayerid,CIV[rand]);
				PlayerInfo[giveplayerid][pModel] = CIV[rand];
			}
			player_remove_vip_toys(giveplayerid);
			SetPlayerToTeamColor(giveplayerid);
   			pTazer{giveplayerid} = 0;
		}
	}
	return 1;
}

CMD:judgefine(playerid, params[])
{
	if(!IsAJudge(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not part of the Judicial System!");
	if(PlayerInfo[playerid][pRank] < 3) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command - only rank 3+ can do this.");

	new giveplayerid, judgefine, reason[64], totalwealth;

	if(sscanf(params, "uds[64]", giveplayerid, judgefine, reason)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /judgefine [player] [amount] [reason]");
	if(!IsPlayerConnected(giveplayerid)) return SendClientMessageEx(playerid, COLOR_GRAD2, "Invalid player specified.");
	totalwealth = PlayerInfo[giveplayerid][pCash] + PlayerInfo[giveplayerid][pAccount];
	if(giveplayerid == playerid) return SendClientMessageEx(playerid, COLOR_GRAD1, "You can't use this command on yourself!");
	if(!(1 <= judgefine <= 500000)) return SendClientMessageEx(playerid, COLOR_GREY, "Fine amount cannot be lower than $1 or higher than $500,000!");
	if(totalwealth < 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "That person is already in debt - contact an administrator.");
	if(!PlayerInfo[giveplayerid][pBeingSentenced]) return SendClientMessageEx(playerid, COLOR_GRAD5, "That person isn't being sentenced!");
	SetPVarInt(playerid, "judgefine", judgefine);
	SetPVarInt(playerid, "jfined", giveplayerid);
	SetPVarString(playerid, "jreason", reason);
	Group_ListGroups(playerid, DIALOG_JFINECONFIRM);
	return 1;
}

CMD:probation(playerid, params[])
{
    if(!IsAJudge(playerid))
	{
        SendClientMessageEx(playerid, COLOR_GRAD1, "You are not part of the Judicial System!");
        return 1;
    }
    if(PlayerInfo[playerid][pRank] < 3)
	{
        SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command - only rank 3+ can do this.");
        return 1;
    }

	new string[128], giveplayerid, probtime, reason[64];
	if(sscanf(params, "uds[64]", giveplayerid, probtime, reason)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /probation [player] [time 1-360 Minutes] [reason and terms]");

    if(giveplayerid == playerid) return SendClientMessageEx(playerid, COLOR_GRAD1, "You can't use this command on yourself!");
    if(IsPlayerConnected(giveplayerid))
	{
        if(!PlayerInfo[giveplayerid][pBeingSentenced]) return SendClientMessageEx(playerid, COLOR_GRAD5, "That person isn't being sentenced!");
        if(probtime < 1 && probtime > 360) return SendClientMessageEx(playerid, COLOR_GRAD5, "Time cannot be lower 1 minute or higher than 360 minutes!");
        PlayerInfo[giveplayerid][pProbationTime] = probtime;
        format(string, sizeof(string), "You have set %s in probation for %d minutes, reason and terms: %s", GetPlayerNameEx(giveplayerid), probtime, reason);
        SendClientMessageEx(playerid, COLOR_WHITE, string);
        format(string, sizeof(string), "You have been set in probation for %d minutes by %s, reason and terms: %s", probtime, GetPlayerNameEx(playerid), reason);
        SendClientMessageEx(giveplayerid, COLOR_WHITE, string);
    }
    return 1;
}

CMD:viewassets(playerid, params[])
{
  	if(!IsAJudge(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You are not part of the Judicial System!");
	if(PlayerInfo[playerid][pRank] < 5) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command - only rank 5+ can do this.");
	
	new giveplayerid;

	if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /viewassets [player]");
	if(!IsPlayerConnected(giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");
	
	format(szMiscArray, sizeof(szMiscArray), "%s's assets | Vehicle Status: %d - House Status: %d - Bank Account Status: %d", GetPlayerNameEx(giveplayerid), PlayerInfo[giveplayerid][pFreezeCar], PlayerInfo[giveplayerid][pFreezeHouse], PlayerInfo[giveplayerid][pFreezeBank]);
	SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
	format(szMiscArray, sizeof(szMiscArray), "%s's assets | Cash: $%s - Bank: $%s", GetPlayerNameEx(giveplayerid), number_format(PlayerInfo[giveplayerid][pCash]), number_format(PlayerInfo[giveplayerid][pAccount]));
	SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
	return true;
}

CMD:alimony(playerid, params[]) {

	if(!IsAJudge(playerid)) 
  		return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not part of the Judicial System!");
	if(PlayerInfo[playerid][pRank] < 3) 
  		return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command - only rank 3+ can do this.");
  	new charged, recieved, amount;
  	if(sscanf(params, "iii", charged, amount, recieved)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /alimony [charging id] [percentage] [reciever id]");
  	if(charged == playerid || recieved == playerid) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot use this command on yourself!");
  	
  	new totalwealth = PlayerInfo[charged][pAccount] + GetPlayerCash(charged),
  		fine = amount * totalwealth / 100;
  	if(totalwealth < 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "That person is in debt - contact an administrator.");  	
  	if(IsPlayerConnected(charged) || IsPlayerConnected(recieved))
	{
		if(amount < 5)
			return SendClientMessageEx(playerid, COLOR_GRAD2, "Minimum percentage must be atleast 5");
		if(amount > 25)
			return SendClientMessageEx(playerid, COLOR_GRAD2, "Maximum percentage must not exceed 25");
		if(fine < 300000) {
			format(szMiscArray, sizeof(szMiscArray), "The charge was $%d however as it falls below the minimum amount, %s was only charged $300,000", fine, GetPlayerNameEx(charged));
			SendClientMessageEx(playerid, COLOR_GRAD2, szMiscArray);
			fine = 300000;			
		}
		if(fine > 2500000) {
			format(szMiscArray, sizeof(szMiscArray), "The charge was $%d however as it exceeds the maximum amount, %s was only charged $2,500,000", fine, GetPlayerNameEx(charged));
			SendClientMessageEx(playerid, COLOR_GRAD2, szMiscArray);
			fine = 2500000;
		}

		GivePlayerCashEx(charged, TYPE_ONHAND, -fine);
		format(szMiscArray, sizeof(szMiscArray), "You have been charged $%d for alimony to %s by Judge %s.", fine, GetPlayerNameEx(recieved), GetPlayerNameEx(playerid));
		SendClientMessageEx(charged, COLOR_WHITE, szMiscArray);

		GivePlayerCashEx(recieved, TYPE_ONHAND, fine);
		format(szMiscArray, sizeof(szMiscArray), "You have been given $%d from %s as alimony.", fine, GetPlayerNameEx(recieved));
		SendClientMessageEx(recieved, COLOR_WHITE, szMiscArray);

		foreach(new i: Player) {
			if(PlayerInfo[i][pAdmin] >= 3) {
			    format(szMiscArray, sizeof(szMiscArray), "Judicial: %s has charged %s $%d for alimony to %s", GetPlayerNameEx(playerid), GetPlayerNameEx(charged), fine, GetPlayerNameEx(recieved));
			    SendClientMessage(i, COLOR_LIGHTRED, szMiscArray);
			}
		}
	}
	else return SendClientMessageEx(playerid, COLOR_GREY, "That player is not online!");
	return 1;
}

