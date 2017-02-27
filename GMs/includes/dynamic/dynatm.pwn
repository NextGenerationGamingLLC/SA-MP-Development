/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

					Dynamic ATM System
						Connolly

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

new ATMCount = 0;

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {

    if((newkeys & KEY_YES) && IsPlayerInAnyDynamicArea(playerid)) {

        new areaid[1];
        GetPlayerDynamicAreas(playerid, areaid);
        // new i = Streamer_GetIntData(STREAMER_TYPE_AREA, areaid[0], E_STREAMER_EXTRA_ID);

        if(areaid[0] != INVALID_STREAMER_ID) {
            for(new i; i < MAX_ATM; ++i) {
                if(areaid[0] == JobData[i][aAreaID]) Job_GetJob(playerid, i);
            }
        }
    }
}

forward ATMCheck(playerid, action, hacked, atm);
public ATMCheck(playerid, action, hacked, atm)
{
	new string[128];
	switch(action) { // -1 to reset player.
		case 0: { // Preform check
			ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.0, 0, 1, 1, 1, 0, 1);
			format(string, sizeof(string), "%s attempts to take the panel off the ATM.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			if(hacked > 0) { SetTimerEx("ATMCheck", 3000, false, "ii", playerid, 3, atm); } else { SetTimerEx("ATMCheck", 3000, false, "ii", playerid, 1, atm); }

		}
		case 1: { // Checking panel
			ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 1, 1, 1, 0, 1);
			format(string, sizeof(string), "* As I take the panel off I check for any suspicious devices. (( %s ))", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			SetTimerEx("ATMCheck", 3000, false, "ii", playerid, 2, atm);
		}
		case 2: { // Check Complete
			ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.0, 0, 1, 1, 1, 0, 1);
			format(string, sizeof(string), "* Nothing suspicious was found; I place the panel back onto the ATM. (( %s ))", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			SetTimerEx("ATMCheck", 2000, false, "ii", playerid, -1, atm);
		}
		case 3: {
			new Chance;
			ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 1, 1, 1, 0, 1);
			format(string, sizeof(string), "* As I take the panel off I check for any suspicious devices. (( %s ))", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			switch(Atm[atm][aHacked])
			{
				case 0..14: Chance = 75;
				case 15..29: Chance = 65;
				case 30..44: Chance = 55;
				case 45..59: Chance = 45;
				default: Chance = 35;
			}
			if(random(100) <= Chance) {
				foreach(new p: Player) {
					if(IsPlayerConnected(p) && GetPlayerSQLId(p) == Atm[atm][aPid]) {
						SendClientMessageEx(p, COLOR_CYAN, "Law Enforcements failed to detect your device on the ATM; The ATM will no longer send alerts.");
					}
				}
				SetTimerEx("ATMCheck", 3000, false, "ii", playerid, 2, atm);
			}
			else
			{
				if(Atm[atm][aPrints] > 0) {
					SetTimerEx("ATMCheck", 3000, false, "ii", playerid, 4, atm);
				}
				else
				{
					SetTimerEx("ATMCheck", 3000, false, "ii", playerid, 5, atm);
				}
			}
		}
		case 4: {
			ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.0, 0, 1, 1, 1, 0, 1);
			format(string, sizeof(string), "* I found a suspicious looking device attached I managed to retrieve finger prints from it. (( %s ))", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			foreach(new p: Player) {
				if(IsPlayerConnected(p) && GetPlayerSQLId(p) == Atm[atm][aPid]) {
					SendClientMessageEx(p, COLOR_CYAN, "Law Enforcements have detected your device on the ATM!");
					SendClientMessageEx(p, COLOR_CYAN, "They managed to retrieve your finger prints from the device!");
					format(string, sizeof(string), "HQ DNA Results: %s", GetPlayerNameEx(p));
					SendClientMessageEx(playerid, TEAM_BLUE_COLOR, string);
				}
			}
			Atm[atm][aHacked] = 0;
			Atm[atm][aPid] = 0;
			Atm[atm][aCooldown] = 30;
			Atm[atm][aPrints] = 0;
			Atm[atm][aCheck] = 0;
			SaveATM(atm);
			SetTimerEx("ATMCheck", 3000, false, "ii", playerid, -1, atm);
		}
		case 5: {
			foreach(new p: Player) {
				if(IsPlayerConnected(p) && GetPlayerSQLId(p) == Atm[atm][aPid]) {
					SendClientMessageEx(p, COLOR_CYAN, "Law Enforcements have detected your device on the ATM!");
					SendClientMessageEx(p, COLOR_CYAN, "They were unable to retrieve your finger prints!");
				}
			}
			ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.0, 0, 1, 1, 1, 0, 1);
			format(string, sizeof(string), "* I found a suspicious looking device attached but was unable to retrieve any finger prints from it. (( %s ))", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			Atm[atm][aHacked] = 0;
			Atm[atm][aPid] = 0;
			Atm[atm][aCooldown] = 30;
			Atm[atm][aPrints] = 0;
			Atm[atm][aCheck] = 0;
			SaveATM(atm);
			SetTimerEx("ATMCheck", 3000, false, "ii", playerid, -1, atm);
		}
		default: {
			ClearAnimations(playerid);
		}
	}
	return 1;
}

CMD:hackatm(playerid, params[]) {
	if (PlayerInfo[playerid][pJob] != 23 && PlayerInfo[playerid][pJob2] != 23 && PlayerInfo[playerid][pJob3] != 23)
	{
		SendClientMessageEx(playerid,COLOR_GREY, "You are not a Robber.");
		return 1;
	}
	new atm, hack, e, FingerPrint = 50, Chance, timer, wait;

	FetchATM(playerid, atm, hack, e);

	if(atm == INVALID_ATM) return SendClientMessageEx(playerid, COLOR_GREY, "You are not near a ATM.");
	if(hack == 1) return SendClientMessageEx(playerid, COLOR_GREY, "You've already hacked an ATM, you must wait for it to expire. (Expires: %d minutes)", e);
	if(PlayerInfo[playerid][pCards] == 0) return SendClientMessageEx(playerid, COLOR_GREY, "You don't have any devices to place onto the ATM!");
	if(Atm[atm][aHacked] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "This ATM has already been hacked by someone else.");
	if(Atm[atm][aCooldown] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "This ATM was recently hacked you must wait %d minutes.", Atm[atm][aCooldown]);

	if(gettime() < ATMHackTimer[playerid])
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You must wait %d seconds before attempting to hack this ATM.", ATMHackTimer[playerid]-gettime());
		return 1;
	}

	switch(PlayerInfo[playerid][pRobberySkill])
	{
		case 0..49: Chance = 65, timer = 15, wait = 30;
		case 50..99: Chance = 55, timer = 30, wait = 25;
		case 100..199: Chance = 45, timer = 45, wait = 20;
		case 200..399: Chance = 35, timer = 60, wait = 15;
		default: Chance = 25, timer = 75, wait = 10;
	}
	if(random(100) <= Chance)
	{
		Atm[atm][aUses] -= 5;
		if(Atmfails[playerid] < 3) {
			Atmfails[playerid]++;
			SendClientMessageEx(playerid, COLOR_GREY, "You failed to attach the device - try again!");
		}
		else {
			Atmfails[playerid] = 0;
			PlayerInfo[playerid][pCards]--;
			SendClientMessageEx(playerid, COLOR_GREY, "You failed to many times your device became damaged in the process.");
		}
		//PlayerInfo[playerid][pCards]--;
		ATMHackTimer[playerid] = gettime()+wait;
		return 1;
	}
	else
	{
		if(PlayerInfo[playerid][pGloves] > 0) {
			FingerPrint = 65;
			PlayerInfo[playerid][pGloves]--;
			SendClientMessageEx(playerid, COLOR_CYAN, "You have a 15 percent higher chance of not leaving finger prints on the attached device.");
		}
		if(random(100) <= FingerPrint) {
			Atm[atm][aPrints] = 1;
		}

		Atm[atm][aPid] = GetPlayerSQLId(playerid);
		Atm[atm][aHacked] = timer;
		Atm[atm][aCheck] = 0;
		PlayerInfo[playerid][pCards]--;
		Atmfails[playerid] = 0;
		ATMHackTimer[playerid] = gettime()+wait;

		UpdateATM(atm);
		SendClientMessage(playerid, COLOR_YELLOW, "You have successfully attached the device to this ATM!");
	}
	return 1;
}

CMD:makeitem(playerid, params[])
{
	if(PlayerTied[playerid] != 0 || PlayerCuffed[playerid] != 0 || PlayerInfo[playerid][pJailTime] > 0 || GetPVarInt(playerid, "Injured")) return SendClientMessageEx(playerid, COLOR_GRAD2, "You cannot do this at this time.");
	if(PlayerInfo[playerid][pJailTime] && strfind(PlayerInfo[playerid][pPrisonReason], "[OOC]", true) != -1) return SendClientMessageEx(playerid, COLOR_GREY, "OOC prisoners are restricted to only speak in /b");
	if(PlayerInfo[playerid][pJob] == 9 || PlayerInfo[playerid][pJob2] == 9 || PlayerInfo[playerid][pJob3] == 9)
	{
		if(GetPVarInt(playerid, "pMakeItemTime") > gettime()) return SendClientMessageEx(playerid, COLOR_GRAD1, "You must wait 10 seconds before making another item.");
		if(GetPVarType(playerid, "WatchingTV") || GetPVarType(playerid, "PreviewingTV")) return SendClientMessage(playerid, COLOR_GRAD1, "You cannot make items while watching TV.");
		if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_GRAD1, "You cannot make an item while in a vehicle!");
		if(HungerPlayerInfo[playerid][hgInEvent] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "   You cannot do this while being in the Hunger Games Event!");
   		#if defined zombiemode
		if(zombieevent == 1 && GetPVarType(playerid, "pIsZombie")) return SendClientMessageEx(playerid, COLOR_GREY, "Zombies can't use this.");
		#endif
		if(GetPVarType(playerid, "PlayerCuffed") || GetPVarInt(playerid, "pBagged") >= 1 || GetPVarType(playerid, "IsFrozen") || PlayerInfo[playerid][pHospital] || (PlayerInfo[playerid][pJailTime] > 0 && strfind(PlayerInfo[playerid][pPrisonReason], "[OOC]", true) != -1))
   		return SendClientMessage(playerid, COLOR_GRAD2, "You can't do that at this time!");
		if(GetPVarType(playerid, "AttemptingLockPick")) return SendClientMessageEx(playerid, COLOR_WHITE, "You are attempting to lockpick, please wait.");
		if(GetPVarType(playerid, "IsInArena")) return SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this while being in an arena!");
		if(PlayerInfo[playerid][pHospital]) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot do this at this time.");

		szMiscArray[0] = 0;
		new choice[32], string[128];
		if(sscanf(params, "s[32]", choice))
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "-------------------------------------");
			switch(PlayerInfo[playerid][pRobberySkill])
			{
				case 0 .. 49: // level 1
				{
           			SendClientMessageEx(playerid, COLOR_GRAD1, "screwdriver(1,000)	cardswipe(5,000)");
				}
				case 50 .. 99: // level 2
				{
					SendClientMessageEx(playerid, COLOR_GRAD1, "screwdriver(1,000)	cardswipe(5,000)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "toolbox(15,000)	crowbar(10,000)");
				}
				case 100 .. 199: // level 3
				{
					SendClientMessageEx(playerid, COLOR_GRAD1, "screwdriver(1,000)	cardswipe(5,000)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "toolbox(15,000)	crowbar(10,000)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "keycard(%s)", number_format(PlayerInfo[playerid][pLevel] * 2500));
				}
				case 200 .. 399:// Level 4 
				{
					SendClientMessageEx(playerid, COLOR_GRAD1, "screwdriver(1,000)	cardswipe(5,000)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "toolbox(15,000)	crowbar(10,000)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "keycard(%s)", number_format(PlayerInfo[playerid][pLevel] * 2500));
				}
				default:
				{
					SendClientMessageEx(playerid, COLOR_GRAD1, "screwdriver(1,000)	cardswipe(5,000)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "toolbox(15,000)	crowbar(10,000)");
					SendClientMessageEx(playerid, COLOR_GRAD1, "keycard(%s)", number_format(PlayerInfo[playerid][pLevel] * 2500));
				}
			}
			if(PlayerInfo[playerid][pRobberySkill] >= 401) SendClientMessageEx(playerid, COLOR_WHITE, "Gloves(2500) - Requires Gold VIP");
			SendClientMessageEx(playerid, COLOR_WHITE, "-------------------------------------");
			SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /make [item]");
			return 1;
		}
		if(strcmp(choice, "screwdriver", true) == 0)
		{
			if(PlayerInfo[playerid][pMats] >= 1000)
			{
				PlayerInfo[playerid][pMats] -= 1000;
				PlayerInfo[playerid][pScrewdriver]++;
				SendClientMessageEx(playerid, COLOR_GRAD1, "You have given yourself a %s.", choice);
			}
			else
			{
				SendClientMessageEx(playerid,COLOR_GREY,"Not enough Materials for that!");
				return 1;
			}
		}
		else if(strcmp(choice, "cardswipe", true) == 0)
		{
			if(PlayerInfo[playerid][pMats] >= 5000)
			{
				PlayerInfo[playerid][pMats] -= 5000;
				PlayerInfo[playerid][pCards]++;
				SendClientMessageEx(playerid, COLOR_GRAD1, "You have given yourself a %s.", choice);
				SendClientMessageEx(playerid, COLOR_GRAD1, "When you're at an ATM, you can hack it to gain money. (( /hackatm ))", choice);
			}
			else
			{
				SendClientMessageEx(playerid,COLOR_GREY,"Not enough Materials for that!");
				return 1;
			}
		}
		else if(strcmp(choice, "toolbox", true) == 0)
		{
			if(PlayerInfo[playerid][pRobberySkill] < 50) return SendClientMessageEx(playerid, COLOR_GREY, "You are not the required level to create that!");
			if(PlayerInfo[playerid][pMats] >= 15000)
			{
				PlayerInfo[playerid][pMats] -= 15000;
				PlayerInfo[playerid][pToolBox]++;
				SendClientMessageEx(playerid, COLOR_GRAD1, "You have given yourself a %s.", choice);
				SendClientMessageEx(playerid, COLOR_GRAD1, "You can now break into player owned vehicles. /picklock");
			}
			else
			{
				SendClientMessageEx(playerid,COLOR_GREY,"Not enough Materials for that!");
				return 1;
			}
		}
		else if(strcmp(choice, "crowbar", true) == 0)
		{
			if(PlayerInfo[playerid][pRobberySkill] < 50) return SendClientMessageEx(playerid, COLOR_GREY, "You are not the required level to create that!");
			if(PlayerInfo[playerid][pMats] >= 10000)
			{
				PlayerInfo[playerid][pMats] -= 10000;
				PlayerInfo[playerid][pCrowBar]++;
				SendClientMessageEx(playerid, COLOR_GRAD1, "You have given yourself a %s.", choice);
				SendClientMessageEx(playerid, COLOR_GRAD1, "You can now break into player owned vehicles trunks. /robcar");
			}
			else
			{
				SendClientMessageEx(playerid,COLOR_GREY,"Not enough Materials for that!");
				return 1;
			}
		}
		else if(strcmp(choice, "keycard", true) == 0)
		{
			if(PlayerInfo[playerid][pRobberySkill] < 100) return SendClientMessageEx(playerid, COLOR_GREY, "You are not the required level to create that!");
			if(PlayerInfo[playerid][pLevel] < 10) return SendClientMessageEx(playerid, COLOR_GREY, "You need to be at least level 10 to create this item!");
			if(PlayerInfo[playerid][pKeyCards] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "You already have a Key Card!");
			if(PlayerInfo[playerid][pMats] >= PlayerInfo[playerid][pLevel] * 2500)
			{
				PlayerInfo[playerid][pMats] -= PlayerInfo[playerid][pLevel] * 2500;
				PlayerInfo[playerid][pKeyCards]++;
				SendClientMessageEx(playerid, COLOR_GRAD1, "You have given yourself a %s.", choice);
				SendClientMessageEx(playerid, COLOR_GRAD1, "Gloves gives a 15 percent higher chance of not leaving finger prints on ATMs.");
			}
			else
			{
				SendClientMessageEx(playerid,COLOR_GREY,"Not enough Materials for that!");
				return 1;
			}
		}
		else if(strcmp(choice, "gloves", true) == 0)
		{
			if(PlayerInfo[playerid][pDonateRank] < 3) return SendClientMessageEx(playerid, COLOR_GREY, " You are not a Gold VIP+!");
			if(PlayerInfo[playerid][pGloves] > 0) return SendClientMessageEx(playerid, COLOR_GREY, "You already have a pair of gloves on you!");
			if(PlayerInfo[playerid][pMats] >= 2500)
			{
				PlayerInfo[playerid][pMats] -= 2500;
				PlayerInfo[playerid][pGloves]++;
				SendClientMessageEx(playerid, COLOR_GRAD1, "You have given yourself a pair of %s.", choice);
				SendClientMessageEx(playerid, COLOR_GRAD1, "A pair of gloves give a 25 percent higher chance of not leaving finger prints on ATMs.", choice);
			}
			else
			{
				SendClientMessageEx(playerid,COLOR_GREY,"Not enough Materials for that!");
				return 1;
			}
		}
		else { SendClientMessageEx(playerid,COLOR_GREY,"Invalid item name!"); return 1; }

		PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
		PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
		switch( PlayerInfo[playerid][pSex] )
		{
			case 1: format(string, sizeof(string), "* %s created something from Materials, and hands it to himself.", GetPlayerNameEx(playerid));
			case 2: format(string, sizeof(string), "* %s created something from Materials, and hands it to herself.", GetPlayerNameEx(playerid));
		}
		ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		if(PlayerInfo[playerid][pAdmin] < 3)
		{
			SetPVarInt(playerid, "ArmsTimer", 10); SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_ARMSTIMER);
		}
		return 1;
	}
}

CMD:checkatm(playerid, params[]) {

	new atmid, check, hacked, prints, p;
	if(IsACop(playerid))
	{
		CheckATM(playerid, atmid, check, hacked, prints, p);

		if(atmid == INVALID_ATM) return SendClientMessageEx(playerid, COLOR_GREY, "You are not near a ATM.");
		if(check > 0) return SendClientMessageEx(playerid, COLOR_GREY, "This ATM has already been checked! - You must wait till the next cycle before you can check again.");
		Atm[atmid][aCheck] = 1;
		if(Atm[atmid][aHacked] < 1)
		{
			ATMCheck(playerid, 0, 0, atmid);
			return 1;
		}
		else
		{
			ATMCheck(playerid, 0, 1, atmid);
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You do not have permission to use this command.");
	}
	return 1;
}

stock IsAtATM(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		for(new x; x < MAX_ATM; x++)
		{
			if(IsPlayerInRangeOfPoint(playerid,3.0,Atm[x][aPosX], Atm[x][aPosY], Atm[x][aPosZ])) return 1;
		}
	}
	return 0;
}

stock FetchATM(playerid, &atm, &pid, &e)
{
	atm = INVALID_ATM;
	e = 0;
	pid = 0;

    for(new a = 0; a < MAX_ATM; a++)
    {
 	    if(IsPlayerInRangeOfPoint(playerid,3.0,Atm[a][aPosX], Atm[a][aPosY], Atm[a][aPosZ]))
		{
			atm = a;
	    }
	    if(GetPlayerSQLId(playerid) == Atm[a][aPid]) {
	    	pid = 1;
	    	e = Atm[a][aHacked];
	    }
 	}
}

stock CheckATM(playerid, &atm, &check, &prints, &hack, &player)
{
	atm = INVALID_ATM;

    for(new a = 0; a < MAX_ATM; a++)
    {
 	    if(IsPlayerInRangeOfPoint(playerid,3.0,Atm[a][aPosX], Atm[a][aPosY], Atm[a][aPosZ]))
		{
			atm = a;
			check = Atm[a][aCheck];
			prints = Atm[a][aPrints];
			hack = Atm[a][aHacked];
			player = Atm[a][aPid];
	    }
 	}
}

stock GetATM(playerid, &atm, &status, &money, &sieze)
{
	atm = INVALID_ATM;

    for(new a = 0; a < MAX_ATM; a++)
    {
 	    if(IsPlayerInRangeOfPoint(playerid,3.0,Atm[a][aPosX], Atm[a][aPosY], Atm[a][aPosZ]))
		{
			atm = a;
			status = Atm[a][aDestroyed];
			money = Atm[a][aMoney];
			sieze = Atm[a][aSeize];
	    }
 	}
}

stock ATMDevice(playerid, aID, Pid, value)
{
	new Chance, string[128];
	new cash = 10*value/100;
	if(cash == 0) { cash = 1; }
	foreach(new p: Player) {
		if(IsPlayerConnected(p) && GetPlayerSQLId(p) == Pid) {
			new hacker = p;
			if(playerid != hacker) {
				switch(PlayerInfo[hacker][pRobberySkill])
				{
					case 0..49: Chance = 65;
					case 50..124: Chance = 55;
					case 125..224: Chance = 45;
					case 225..349: Chance = 35;
					default: Chance = 25;
				}
				if(random(100) <= Chance)
				{
					Atm[aID][aFailSwipes]++;
					if(Atm[aID][aCheck] == 0) {
					    if(++Atm[aID][aFails] == 10) {
					    	foreach(new c: Player) {
					    		if(IsACop(c)) {
									new szZone[MAX_ZONE_NAME], Float:pos[3];
									GetDynamicObjectPos(Atm[aID][aSpawned], pos[0], pos[1], pos[2]);
									Get3DZone(pos[0], pos[1], pos[2], szZone, sizeof(szZone));

									format(string, sizeof(string), "HQ: All Units APB: Reporter: Automated Message");
									SendClientMessageEx(c, TEAM_BLUE_COLOR, string);
									format(string, sizeof(string), "HQ: Location: %s, Description: Suspicious ATM activity!", szZone);
									SendClientMessageEx(c, TEAM_BLUE_COLOR, string);
					    		}
					    	}
							Atm[aID][aFails] = 0;
						}
					}
				}
				else
				{
					Atm[aID][aSucSwipes]++;
					if(DoubleXP) {
						SendClientMessageEx(hacker, COLOR_YELLOW, "You have gained 2 robbery skill points instead of 1. (Double XP Active)");
						PlayerInfo[hacker][pRobberySkill] += 2;
						SetXP(hacker, PlayerInfo[hacker][pLevel] * XP_RATE * 2);
					}
					else
		 			if(PlayerInfo[hacker][pDoubleEXP] > 0)
				    {
						format(string, sizeof(string), "You have gained 2 robbery skill points instead of 1. You have %d hours left on the Double EXP token.", PlayerInfo[hacker][pDoubleEXP]);
						SendClientMessageEx(hacker, COLOR_YELLOW, string);
		   				PlayerInfo[hacker][pRobberySkill] += 2;
						SetXP(hacker, PlayerInfo[hacker][pLevel] * XP_RATE * 2);
					}
					else
					{
		  				PlayerInfo[hacker][pRobberySkill] += 1;
		  				SetXP(hacker, PlayerInfo[hacker][pLevel] * XP_RATE);
					}
					SendClientMessageEx(hacker, COLOR_YELLOW, "You managed to swipe someones card and got $%s!", number_format(cash));
					GivePlayerCash(hacker, cash);
					GivePlayerCash(playerid, -cash);
				}
			}
		}
	}
}

AtmTimer()
{
	szMiscArray[0] = 0;
	for(new a = 0; a < MAX_ATM; a++) {
		if(Atm[a][aPid] > 0)
		{
			if(Atm[a][aHacked] > 0) {
				Atm[a][aHacked]--;
			}
			else
			{
				foreach(new p: Player) {
					if(IsPlayerConnected(p) && GetPlayerSQLId(p) == Atm[a][aPid]) {
						SendClientMessageEx(p, COLOR_YELLOW, "The device you planted on the ATM has now expired.");
					}
				}
				Atm[a][aPid] = 0;
				Atm[a][aCooldown] = 30;
				Atm[a][aPrints] = 0;
				Atm[a][aCheck] = 0;
				SaveATM(a);
			}
		}
		if(Atm[a][aCooldown] > 0) {
			Atm[a][aCooldown]--;
		}
	}
}

hook OnPlayerConnect(playerid)
{
	Atmfails[playerid] = 0;
	ATMHackTimer[playerid] = 0;
}

forward OnLoadDynamicATMs();
public OnLoadDynamicATMs()
{
	new i, rows, fields, tmp[128];
	cache_get_data(rows, fields, MainPipeline);

	while(i < rows)
	{
		//cache_get_field_content(i, "id", tmp, MainPipeline);  Atm[i][aId] = strval(tmp);
		cache_get_field_content(i, "PosX", tmp, MainPipeline); Atm[i][aPosX] = floatstr(tmp);
		cache_get_field_content(i, "PosY", tmp, MainPipeline); Atm[i][aPosY] = floatstr(tmp);
		cache_get_field_content(i, "PosZ", tmp, MainPipeline); Atm[i][aPosZ] = floatstr(tmp);
		cache_get_field_content(i, "PosRX", tmp, MainPipeline); Atm[i][aPosRX] = floatstr(tmp);
		cache_get_field_content(i, "PosRY", tmp, MainPipeline); Atm[i][aPosRY] = floatstr(tmp);
		cache_get_field_content(i, "PosRZ", tmp, MainPipeline); Atm[i][aPosRZ] = floatstr(tmp);
		cache_get_field_content(i, "Int", tmp, MainPipeline);  Atm[i][aInt] = strval(tmp);
		cache_get_field_content(i, "VW", tmp, MainPipeline);  Atm[i][aVW] = strval(tmp);
		cache_get_field_content(i, "Damaged", tmp, MainPipeline);  Atm[i][aDestroyed] = strval(tmp);
		cache_get_field_content(i, "Pid", tmp, MainPipeline);  Atm[i][aPid] = strval(tmp);
		cache_get_field_content(i, "Fails", tmp, MainPipeline);  Atm[i][aFails] = strval(tmp);
		cache_get_field_content(i, "Money", tmp, MainPipeline);  Atm[i][aMoney] = strval(tmp);
		cache_get_field_content(i, "Fee", tmp, MainPipeline);  Atm[i][aFee] = strval(tmp);
		cache_get_field_content(i, "Hacked", tmp, MainPipeline);  Atm[i][aHacked] = strval(tmp);
		cache_get_field_content(i, "FingerPrints", tmp, MainPipeline);  Atm[i][aPrints] = strval(tmp);
		cache_get_field_content(i, "Cooldown", tmp, MainPipeline);  Atm[i][aCooldown] = strval(tmp);
		cache_get_field_content(i, "Uses", tmp, MainPipeline);  Atm[i][aUses] = strval(tmp);
		cache_get_field_content(i, "Seized", tmp, MainPipeline);  Atm[i][aSeize] = strval(tmp);
		cache_get_field_content(i, "Checked", tmp, MainPipeline);  Atm[i][aCheck] = strval(tmp);
		cache_get_field_content(i, "SSwipes", tmp, MainPipeline);  Atm[i][aSucSwipes] = strval(tmp);
		cache_get_field_content(i, "FSwipes", tmp, MainPipeline);  Atm[i][aFailSwipes] = strval(tmp);
		if(Atm[i][aPosX] != 0 && Atm[i][aPosY] != 0 && Atm[i][aPosZ] != 0) {
			//CreateDynamicObject(objectid, Atm[i][aPosX], Atm[i][aPosY], Atm[i][aPosZ], 0.0, 0.0, 0.0, Atm[i][aVW], Atm[i][aInt]);
			CreateATM(i);
			++ATMCount;
		}
		i++;
	}
	if(ATMCount > 0) {
		printf("[Load Dynamic ATMs] %d ATMs rehashed/loaded.", i);
		InitTurfWars();
	}
	else printf("[Load Dynamic ATMs] Failed to load any ATMs.");
	return 1;
}

stock LoadDynamicATMs()
{
	printf("[Load Dynamic ATMs] Loading Trufs from database...");
	mysql_function_query(MainPipeline, "SELECT * FROM `atms`", true, "OnLoadDynamicATMs", "");
}

stock SaveATM(atm) {
	new query[2048];

	format(query, 2048, "UPDATE `atms` SET ");
	SaveFloat(query, "atms", atm+1, "posX", Atm[atm][aPosX]);
	SaveFloat(query, "atms", atm+1, "posY", Atm[atm][aPosY]);
	SaveFloat(query, "atms", atm+1, "posZ", Atm[atm][aPosZ]);
	SaveFloat(query, "atms", atm+1, "posRX", Atm[atm][aPosRX]);
	SaveFloat(query, "atms", atm+1, "posRY", Atm[atm][aPosRY]);
	SaveFloat(query, "atms", atm+1, "posRZ", Atm[atm][aPosRZ]);
	SaveInteger(query, "atms", atm+1, "int", Atm[atm][aInt]);
	SaveInteger(query, "atms", atm+1, "vw", Atm[atm][aVW]);
	SaveInteger(query, "atms", atm+1, "Damaged", Atm[atm][aDestroyed]);
	SaveInteger(query, "atms", atm+1, "Money", Atm[atm][aMoney]);
	SaveInteger(query, "atms", atm+1, "Fee", Atm[atm][aFee]);
	SaveInteger(query, "atms", atm+1, "Pid", Atm[atm][aPid]);
	SaveInteger(query, "atms", atm+1, "Fails", Atm[atm][aFails]);
	SaveInteger(query, "atms", atm+1, "Hacked", Atm[atm][aHacked]);
	SaveInteger(query, "atms", atm+1, "FingerPrints", Atm[atm][aPrints]);
	SaveInteger(query, "atms", atm+1, "Cooldown", Atm[atm][aCooldown]);
	SaveInteger(query, "atms", atm+1, "Seized", Atm[atm][aSeize]);
	SaveInteger(query, "atms", atm+1, "Uses", Atm[atm][aUses]);	
	SaveInteger(query, "atms", atm+1, "Checked", Atm[atm][aCheck]);
	SaveInteger(query, "atms", atm+1, "SSwipes", Atm[atm][aSucSwipes]);
	SaveInteger(query, "atms", atm+1, "FSwipes", Atm[atm][aFailSwipes]);
	SQLUpdateFinish(query, "atms", atm+1);

}

stock SaveATMs()
{
	new i = 0;
	while(i < MAX_ATM)
	{
		SaveATM(i);
		i++;
	}
	if(i > 0) printf("[ATM] %i atms saved", i);
	else printf("[ATM] Error: No atms saved!");
	return 1;
}

UpdateATM(atmid) {
	if(Atm[atmid][aUses] < 0) Atm[atmid][aUses] = 0;
	if(Atm[atmid][aUses] == 0) {
		Atm[atmid][aDestroyed] = 1;
		CreateATM(atmid);
	}
	SaveATM(atmid);
}

CreateATM(atmid) {
	new string[128];
	if(IsValidDynamicArea(Atm[atmid][aAreaID])) DestroyDynamicArea(Atm[atmid][aAreaID]);
	if(IsValidDynamic3DTextLabel(Atm[atmid][aTextID])) DestroyDynamic3DTextLabel(Atm[atmid][aTextID]);
	if(IsValidDynamicObject(Atm[atmid][aSpawned])) DestroyDynamicObject(Atm[atmid][aSpawned]);

	if(Atm[atmid][aPosX] != 0 && Atm[atmid][aPosY] != 0 && Atm[atmid][aPosZ] != 0)
	{
		switch(Atm[atmid][aDestroyed]) {
			case 2: { Atm[atmid][aSpawned] = CreateDynamicObject(3067, Atm[atmid][aPosX], Atm[atmid][aPosY], Atm[atmid][aPosZ], Atm[atmid][aPosRX], Atm[atmid][aPosRY], Atm[atmid][aPosRZ], Atm[atmid][aVW], Atm[atmid][aInt]);  }
			case 1: { Atm[atmid][aSpawned] = CreateDynamicObject(2943, Atm[atmid][aPosX], Atm[atmid][aPosY], Atm[atmid][aPosZ], Atm[atmid][aPosRX], Atm[atmid][aPosRY], Atm[atmid][aPosRZ], Atm[atmid][aVW], Atm[atmid][aInt]);  }
			default: { Atm[atmid][aSpawned] = CreateDynamicObject(2942, Atm[atmid][aPosX], Atm[atmid][aPosY], Atm[atmid][aPosZ], Atm[atmid][aPosRX], Atm[atmid][aPosRY], Atm[atmid][aPosRZ], Atm[atmid][aVW], Atm[atmid][aInt]); }
		}
		if(Atm[atmid][aDestroyed] == 0) {
			if(Atm[atmid][aSeize] == 1) {
				format(string, sizeof(string), "ATM has been seized by the Goverment.");
				Atm[atmid][aTextID] = CreateDynamic3DTextLabel(string, COLOR_YELLOW, Atm[atmid][aPosX], Atm[atmid][aPosY], Atm[atmid][aPosZ]+1.45,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, Atm[atmid][aVW], Atm[atmid][aInt], -1);
				Atm[atmid][aAreaID] = CreateDynamicSphere(Atm[atmid][aPosX], Atm[atmid][aPosY], Atm[atmid][aPosZ], 3.0, Atm[atmid][aVW], Atm[atmid][aInt]);			
			} else {
				format(string, sizeof(string), "ATM Withdrawal Fee: $%s", number_format(Atm[atmid][aFee]));
				Atm[atmid][aTextID] = CreateDynamic3DTextLabel(string, COLOR_YELLOW, Atm[atmid][aPosX], Atm[atmid][aPosY], Atm[atmid][aPosZ]+1.45,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, Atm[atmid][aVW], Atm[atmid][aInt], -1);
				Atm[atmid][aAreaID] = CreateDynamicSphere(Atm[atmid][aPosX], Atm[atmid][aPosY], Atm[atmid][aPosZ], 3.0, Atm[atmid][aVW], Atm[atmid][aInt]);
			}
		}
	}
}

CMD:atmsave(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1)
	{
        SendClientMessageEx(playerid, COLOR_YELLOW, "You have force saved the ATM database.");
        SaveATM();
    }
    else
	{
        SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
    }
    return 1;
}

CMD:atmnear(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 4)
	{
		SendClientMessageEx(playerid, COLOR_RED, "* Listing all ATM's within 30 meters of you");
		new Float:X, Float:Y, Float:Z;
  		GetPlayerPos(playerid, X, Y, Z);
		for(new i=0;i<MAX_ATM;i++)
		{
			if(IsPlayerInRangeOfPoint(playerid, 30, Atm[i][aPosX], Atm[i][aPosY], Atm[i][aPosZ]))
			{
			    new string[128];
		    	format(string, sizeof(string), "ATM ID %d | %f from you | Uses: %d", i, GetDistance(Atm[i][aPosX], Atm[i][aPosY], Atm[i][aPosZ], X, Y, Z), Atm[i][aUses]);
		    	SendClientMessageEx(playerid, COLOR_WHITE, string);
			}
		}
	}
	else
	{
	    SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use that command.");
	}
	return 1;
}

CMD:atmnext(playerid, params[]) {
    if(PlayerInfo[playerid][pAdmin] >= 4)
	{
		SendClientMessageEx(playerid, COLOR_RED, "* Listing next available ATM...");
		for(new x;x<MAX_ATM;x++)
		{
		    if(Atm[x][aPosX] == 0 && Atm[x][aPosY] == 0 && Atm[x][aPosZ] == 0)
		    {
		        new string[128];
		        format(string, sizeof(string), "ATM ID %d is available to use.", x);
		        SendClientMessageEx(playerid, COLOR_WHITE, string);
		        break;
			}
		}
	}
	else
	{
	    SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use that command.");
		return 1;
	}
	return 1;
}

CMD:atmedit(playerid, params[]) {
    if(PlayerInfo[playerid][pAdmin] >= 4)
	{
		new x_job[128], atmid, Float:ofloat, string[128];

		if(sscanf(params, "s[128]iF", x_job, atmid, ofloat))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /aedit [name] [atmid] [value]");
			SendClientMessageEx(playerid, COLOR_GREY, "Available names: tome, move, status, fee, seize");
			return 1;
		}
		if(atmid < 0 || atmid > MAX_ATM) return SendClientMessageEx(playerid, COLOR_WHITE, "* Invalid ATM ID!");
		if(strcmp(x_job, "tome", true) == 0)
		{
		    GetPlayerPos(playerid,Atm[atmid][aPosX], Atm[atmid][aPosY], Atm[atmid][aPosZ]);
		    Atm[atmid][aVW] = GetPlayerVirtualWorld(playerid);
		    Atm[atmid][aInt] = GetPlayerInterior(playerid);
			format(string, sizeof(string), "ATM %d's Pos moved to %f %f %f, VW: %d INT: %d", atmid, Atm[atmid][aPosX], Atm[atmid][aPosY], Atm[atmid][aPosZ], Atm[atmid][aVW], Atm[atmid][aInt]);
		    SendClientMessageEx(playerid, COLOR_WHITE, string);
			if(IsValidDynamicObject(Atm[atmid][aSpawned])) DestroyDynamicObject(Atm[atmid][aSpawned]);
			CreateATM(atmid);
			SaveATM(atmid);

			format(string, sizeof(string), "%s has edited ATM ID %d's Position.", GetPlayerNameEx(playerid), atmid);
		    Log("logs/atmedit.log", string);
		}
		else if(strcmp(x_job, "move", true) == 0)
		{
			foreach(new i:Player)
			{
				if(GetPVarInt(i, "EditingATMID") == atmid && i != playerid)
				{
					format(string, sizeof(string), "ERROR: %s (ID: %d) is currently editing this ATM.", GetPlayerNameEx(i), i);
					return SendClientMessageEx(playerid, COLOR_WHITE, string);
				}
			}
			SetPVarInt(playerid, "aEdit", 1);
			SetPVarInt(playerid, "EditingATMID", atmid);
			SetDynamicObjectPos(Atm[atmid][aSpawned], Atm[atmid][aPosX], Atm[atmid][aPosY], Atm[atmid][aPosZ]);
			SetDynamicObjectRot(Atm[atmid][aSpawned], Atm[atmid][aPosRX], Atm[atmid][aPosRY], Atm[atmid][aPosRZ]);
			EditDynamicObject(playerid, Atm[atmid][aSpawned]);
			format(string, sizeof(string), "You are now editing the position of ATM ID: %d.", atmid);
			SendClientMessage(playerid, COLOR_WHITE, string);
			SendClientMessage(playerid, 0xFFFFAAAA, "HINT: Hold {8000FF}~k~~PED_SPRINT~ {FFFFAA}to move your camera, press escape to cancel");
		}
		else if(strcmp(x_job, "status", true) == 0)
		{
			new value = floatround(ofloat, floatround_round);
			if(value < 0 || value > 2) return SendClientMessageEx(playerid, COLOR_GRAD2, "Available status: 0, 1, 2");
			if(value == 0) {
				Atm[atmid][aUses] = 150;
			}
			Atm[atmid][aDestroyed] = value;
			SendClientMessageEx(playerid, COLOR_GRAD2, "You have edited ATM ID %d status to %d", atmid, value);
			CreateATM(atmid);
			SaveATM(atmid);
		    format(string, sizeof(string), "%s has edited ATM ID %d's Status to %s.", GetPlayerNameEx(playerid), atmid, number_format(value));
		    Log("logs/atmedit.log", string);
		}
		else if(strcmp(x_job, "fee", true) == 0)
		{
			new value = floatround(ofloat, floatround_round);
			Atm[atmid][aFee] = value;
			SendClientMessageEx(playerid, COLOR_GRAD2, "You have adjusted the fee amount to $%s for ATM %d", number_format(value), atmid);
			CreateATM(atmid);
			SaveATM(atmid);
		    format(string, sizeof(string), "%s has edited ATM ID %d's fee to %s.", GetPlayerNameEx(playerid), atmid, number_format(value));
		    Log("logs/atmedit.log", string);
		}
		else if(strcmp(x_job, "seize", true) == 0)
		{
			new value = floatround(ofloat, floatround_round);
			if(value < 0 || value > 1) return SendClientMessageEx(playerid, COLOR_GRAD2, "Available status: 0, 1");
			Atm[atmid][aSeize] = value;
			SendClientMessageEx(playerid, COLOR_GRAD2, "You have edited ATM ID %d seized status to %d", atmid, value);
			CreateATM(atmid);
			SaveATM(atmid);
		    format(string, sizeof(string), "%s has edited ATM ID %d's seized to %s.", GetPlayerNameEx(playerid), atmid, number_format(value));
		    Log("logs/atmedit.log", string);
		}
		else { SendClientMessageEx(playerid,COLOR_GREY,"Invalid name specified!"); }
	}
	else
	{
	    SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use that command.");
		return 1;
	}
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	switch(dialogid) {

		case ATM: {
			
			if(!response) {
				TogglePlayerControllable(playerid, 1);
				return 1;
			}

			TogglePlayerControllable(playerid, 0);

			switch(listitem) {		
				case 0: ShowATMMenu(playerid, 1);
				case 1: ShowATMMenu(playerid, 2);
				case 2: ShowATMMenu(playerid, 3);
			}
		}

		case ATM_AMOUNT: {
			if(!response) {
				DeletePVar(playerid, "ATMWithdraw");
				DeletePVar(playerid, "ATMDeposit");
				return ShowATMMenu(playerid);
			}

			new 
				iAmount = strval(inputtext);

			if(GetPVarType(playerid, "ATMWithdraw")) {
				
				if(iAmount < 1) {
					SendClientMessageEx(playerid, COLOR_WHITE, "  Negative amounts cannot be transfered!");
					return ShowATMMenu(playerid, 1);
				}

				if(iAmount > PlayerInfo[playerid][pAccount]) {
					SendClientMessageEx(playerid, COLOR_WHITE, "  You are trying to withdraw more than you have!");
					return ShowATMMenu(playerid, 1);
				}

				if(gettime()-GetPVarInt(playerid, "LastTransaction") < 10) {
					SendClientMessageEx(playerid, COLOR_GRAD2, "You can only make a transaction once every 10 seconds, please wait!");
					return ShowATMMenu(playerid, 1);
				}
				SetPVarInt(playerid, "LastTransaction", gettime());
				
				if(!Bank_TransferCheck(-iAmount)) return 1;
				GivePlayerCash(playerid, iAmount);
				PlayerInfo[playerid][pAccount] -= iAmount;
				format(szMiscArray, sizeof(szMiscArray), "  You have withdrawn $%s from your account. ", number_format(iAmount));
				SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);

				if(PlayerInfo[playerid][pDonateRank] == 0) {
					new fee;
					fee = 3*iAmount/100;
					if(!Bank_TransferCheck(-fee)) return 1;
					PlayerInfo[playerid][pAccount] -= fee;
					format(szMiscArray, sizeof(szMiscArray), "  You have been charged a 3 percent withdraw fee: -$%d.", fee);
					SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
				}

				Atm[atm][aUses]--;
				ATMDevice(playerid, atm, Atm[atm][aPid], amount); 
				OnPlayerStatsUpdate(playerid);
				UpdateATM(atm);

				DeletePVar(playerid, "ATMWithdraw");

				return ShowATMMenu(playerid);
			}
			else if(GetPVarType(playerid, "ATMDeposit")) {

				if(iAmount < 1) {
					SendClientMessageEx(playerid, COLOR_WHITE, "  Negative amounts cannot be transfered!");
					return ShowATMMenu(playerid, 2);
				}

				if(iAmount > GetPlayerCash(playerid)) {
					SendClientMessageEx(playerid, COLOR_WHITE, "  You are trying to deposit more than you have!");
					return ShowATMMenu(playerid, 2);
				}

				if(gettime()-GetPVarInt(playerid, "LastTransaction") < 10) {
					SendClientMessageEx(playerid, COLOR_GRAD2, "You can only make a transaction once every 10 seconds, please wait!");
					return ShowATMMenu(playerid, 2);
				}
				SetPVarInt(playerid, "LastTransaction", gettime());
				
				if(!Bank_TransferCheck(iAmount)) return 1;
				GivePlayerCash(playerid, -iAmount);
				PlayerInfo[playerid][pAccount] += iAmount; 
				format(szMiscArray, sizeof(szMiscArray), "  You have deposited $%s to your account. ", number_format(iAmount));
				SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);

				if(PlayerInfo[playerid][pDonateRank] == 0) {
					new fee;
					fee = 3*iAmount/100;
					if(!Bank_TransferCheck(-fee)) return 1;
					PlayerInfo[playerid][pAccount] -= fee;
					format(szMiscArray, sizeof(szMiscArray), "  You have been charged a 3 percent deposit fee: -$%d.", fee);
					SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
				}

				OnPlayerStatsUpdate(playerid);

				DeletePVar(playerid, "ATMDeposit");

				return ShowATMMenu(playerid);
			}
		}

		case ATM_TRANSFER_TO: {
			
			if(!response) {
				return ShowATMMenu(playerid);
			}

			new id = strval(inputtext);
			
			if(!IsPlayerConnected(id) || !gPlayerLogged{id}) {
				SendClientMessageEx(playerid, COLOR_WHITE, "  The player you are trying to transfer to is not connected!");
				return ShowATMMenu(playerid, 3);
			}

			SetPVarInt(playerid, "ATMTransferTo", id);
			return ShowATMMenu(playerid, 4);
		}

		case ATM_TRANSFER_AMT: {

			if(!response) {
				DeletePVar(playerid, "ATMTransferTo");
				return ShowATMMenu(playerid, 3);
			}

			new 
				id = GetPVarInt(playerid, "ATMTransferTo"),
				iAmount = strval(inputtext);


			if(restarting) {
				SendClientMessageEx(playerid, COLOR_GRAD2, "Transactions are currently disabled due to the server being restarted for maintenance.");
				return ShowATMMenu(playerid, 3);
			}
			if(PlayerInfo[playerid][pLevel] < 3) {
				SendClientMessageEx(playerid, COLOR_GRAD1, "   You must be at least level 3 to use this feature!");
				return ShowATMMenu(playerid, 3);
			}
			if(gettime()-GetPVarInt(playerid, "LastTransaction") < 10) {
				SendClientMessageEx(playerid, COLOR_GRAD2, "You can only make a transaction once every 10 seconds, please wait!");
				return ShowATMMenu(playerid, 3);
			}

			if(iAmount > PlayerInfo[playerid][pAccount] || iAmount < 0) return SendClientMessageEx(playerid, COLOR_WHITE, "You are trying to send more than you have!");

			if(PlayerInfo[playerid][pDonateRank] == 0) {
				new fee;
				fee = 3*iAmount/100;
				PlayerInfo[playerid][pAccount] -= fee;
				format(szMiscArray, sizeof(szMiscArray), "  You have been charged a 3 percent transfer fee: -$%d.", fee);
				SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
			}

			// Use these as they update the MySQL Directly with less function calls
			GivePlayerCashEx(playerid, TYPE_BANK, -iAmount);
			GivePlayerCashEx(id, TYPE_BANK, iAmount);

			format(szMiscArray, sizeof(szMiscArray), "   You have transferred $%s to %s's account.", number_format(iAmount), GetPlayerNameEx(id));
			SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
			
			format(szMiscArray, sizeof(szMiscArray), "   $%s has been transferred to your bank account from %s.", number_format(iAmount), GetPlayerNameEx(playerid));
			SendClientMessageEx(id, COLOR_YELLOW, szMiscArray);

			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			PlayerPlaySound(id, 1052, 0.0, 0.0, 0.0);
				
				
			new ip[32], ipex[32];
			GetPlayerIp(playerid, ip, sizeof(ip));
			GetPlayerIp(id, ipex, sizeof(ipex));
			format(szMiscArray, sizeof(szMiscArray), "[ATM] %s(%d) (IP:%s) has transferred $%s to %s(%d) (IP:%s).", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), ip, number_format(iAmount), GetPlayerNameEx(id), GetPlayerSQLId(id), ipex);
			if(PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[id][pAdmin] >= 2) Log("logs/adminpay.log", szMiscArray); else Log("logs/pay.log", szMiscArray);
			format(szMiscArray, sizeof(szMiscArray), "[ATM] %s (IP:%s) has transferred $%s to %s (IP:%s).", GetPlayerNameEx(playerid), ip, number_format(iAmount), GetPlayerNameEx(id), ipex);
			

			if(PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[id][pAdmin] >= 2) {
				format(szMiscArray, sizeof(szMiscArray), "[ATM] Admin %s has transferred $%s to %s", GetPlayerNameEx(playerid), number_format(iAmount), GetPlayerNameEx(id));
				if(!strcmp(GetPlayerIpEx(playerid),  GetPlayerIpEx(id), true)) strcat(szMiscArray, " (1)");
				ABroadCast(COLOR_YELLOW,szMiscArray, 4);
			}
			else ABroadCast(COLOR_YELLOW,szMiscArray,2);
			
			SetPVarInt(playerid, "LastTransaction", gettime());
			DeletePVar(playerid, "ATMTransferTo");

			return ShowATMMenu(playerid);
		}
	}
	return 0;
}

ShowATMMenu(playerid, menu = 0) {

	szMiscArray[0] = 0;

	new szTitle[48], atm, status, money, string[128], amount, sieze;

	GetATM(playerid, atm, status, money, sieze);

	format(szTitle, sizeof(szTitle), "ATM Menu ($%s)", number_format(PlayerInfo[playerid][pAccount]));

	if(atm == INVALID_ATM) return SendClientMessageEx(playerid, COLOR_GREY, "You are not at an ATM.");
	if(status > 0) return SendClientMessageEx(playerid, COLOR_GREY, "This ATM has been damaged and can't be used!");
	if(sieze > 0) return SendClientMessageEx(playerid, COLOR_GREY, "This ATM has been seized its not in operation.");
	//if(money < 1) return SendClientMessageEx(playerid, COLOR_GREY, "This ATM has no money for any withdrawal, please use a different ATM.");
	if(PlayerInfo[playerid][pFreezeBank] == 1) return ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, szTitle, "Your assets have been frozen! Contact judicial!", "Ok", "");

	switch(menu) {

		case 0: { // main menu
			ShowPlayerDialogEx(playerid, ATM, DIALOG_STYLE_LIST, szTitle, "Withdraw\nDeposit\nTransfer", "Select", "Cancel");
		}

		case 1: { // iAmount withdraw
			ShowPlayerDialogEx(playerid, ATM_AMOUNT, DIALOG_STYLE_INPUT, szTitle, "Please input how much you wish to withdraw from your account.", "Withdraw", "Cancel");
			SetPVarInt(playerid, "ATMWithdraw", 1);
		}

		case 2: { // iAmount deposit
			ShowPlayerDialogEx(playerid, ATM_AMOUNT, DIALOG_STYLE_INPUT, szTitle, "Please input how much you wish to deposit to your account.", "Deposit", "Cancel");
			SetPVarInt(playerid, "ATMDeposit", 1);
		}

		case 3: { // transfer to
			ShowPlayerDialogEx(playerid, ATM_TRANSFER_TO, DIALOG_STYLE_INPUT, szTitle, "Please input the player id you wish to transfer money to.", "Next", "Cancel");
		}

		case 4: { // transfer iAmount
			format(szMiscArray, sizeof(szMiscArray), "Please input the amount you wish to transfer to {FF0000}%s", GetPlayerNameEx(GetPVarInt(playerid, "ATMTransferTo")));
			ShowPlayerDialogEx(playerid, ATM_TRANSFER_AMT, DIALOG_STYLE_INPUT, szTitle, szMiscArray, "Transfer", "Cancel");
		}
	}

	return 1;
}