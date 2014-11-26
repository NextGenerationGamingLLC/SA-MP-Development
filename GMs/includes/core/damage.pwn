/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

					  Damage System

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

public OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid, bodypart)
{
	if (damagedid == INVALID_PLAYER_ID) return 1;
	if (playerid == INVALID_PLAYER_ID) return 1;

	if(zombieevent && GetPVarInt(playerid, "z50Cal") == 1 && PlayerInfo[playerid][mInventory][17] && (weaponid == WEAPON_SNIPER || weaponid == WEAPON_RIFLE))
	{
		if(bodypart == BODY_PART_HEAD && GetPVarInt(damagedid, "pIsZombie")) SetPlayerHealth(damagedid, 0);
		if(PlayerInfo[playerid][mInventory][17]) PlayerInfo[playerid][mInventory][17]--;
		DeletePVar(playerid, "z50Cal");
	}
	if(IsAHitman(playerid) && GetPVarInt(playerid, "ExecutionMode") == 1 && (weaponid == WEAPON_DEAGLE || weaponid == WEAPON_SNIPER || weaponid == WEAPON_COLT45 || weaponid == WEAPON_RIFLE || weaponid == WEAPON_SILENCED))
	{
		if(damagedid == GoChase[playerid] && bodypart == BODY_PART_HEAD)
		{
			SetPlayerHealth(damagedid, 0);
			SetPVarInt(playerid, "ExecutionMode", 0);
			SetPVarInt(playerid, "KillShotCooldown", gettime());
		}
		else
		{
			SetPVarInt(playerid, "ExecutionMode", 0);
			SendClientMessage(playerid, COLOR_RED, "You missed the target, wait 5 minutes before re-loading a HP Round.");
			SetPVarInt(playerid, "KillShotCooldown", gettime());		
		}
	}
	if(PlayerInfo[damagedid][pHospital] == 1)
	{
		new Float:hp;
		GetPlayerHealth(damagedid, hp);
		SetPlayerHealth(damagedid, hp+amount);
		return 1;
	}
    if(pTazer{playerid} == 1)
	{
	    if(weaponid !=  23) {
	    	new string[44 + MAX_PLAYER_NAME];
			RemovePlayerWeapon(playerid, 23);
			GivePlayerValidWeapon(playerid, pTazerReplace{playerid}, 60000);
			format(string, sizeof(string), "* %s holsters their tazer.", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			pTazer{playerid} = 0;
			return 1;
		}
		if(!ProxDetectorS(20.0, playerid, damagedid)) {
			new string[44 + (MAX_PLAYER_NAME * 2)];
			format(string, sizeof(string), "* %s fires their tazer at %s, missing them.", GetPlayerNameEx(playerid), GetPlayerNameEx(damagedid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			return 1;
		}
 		if(TazerTimeout[playerid] > 0 && !GetPVarType(damagedid, "IsFrozen"))
  		{
  		    new Float:hp;
  		    GetPlayerHealth(damagedid, hp);
  		    SetPlayerHealth(damagedid, hp-amount);
			return 1;
		}
		if(GetPlayerState(damagedid) == PLAYER_STATE_ONFOOT && PlayerCuffed[damagedid] == 0 && PlayerInfo[playerid][pHasTazer] == 1 && GetPVarInt(damagedid, "Injured") != 1)
		{
		    if((PlayerInfo[damagedid][pAdmin] >= 2 || PlayerInfo[damagedid][pWatchdog] >= 2) && PlayerInfo[damagedid][pTogReports] != 1)
			{
			    SendClientMessageEx(playerid, COLOR_GRAD2, "Admins can not be tazed!");
			    new Float:hp;
	  		    GetPlayerHealth(damagedid, hp);
	  		    SetPlayerHealth(damagedid, hp+amount);
				return 1;
			}
			if(PlayerInfo[damagedid][pHospital] == 1)
			{
				SendClientMessageEx(playerid, COLOR_GRAD2, "Players in hospital cannot be tazed!");
			    new Float:hp;
	  		    GetPlayerHealth(damagedid, hp);
	  		    SetPlayerHealth(damagedid, hp+amount);
				return 1;
			}
			#if defined zombiemode
			if(GetPVarInt(damagedid, "pIsZombie"))
			{
			    SendClientMessageEx(playerid, COLOR_GRAD2, "Zombies can not be tazed!");
				return 1;
			}
			#endif
			new Float:X, Float:Y, Float:Z, Float:hp;
	  		GetPlayerPos(playerid, X, Y, Z);
			GetPlayerHealth(damagedid, hp);
			new string[44 + (MAX_PLAYER_NAME * 2)];
			format(string, sizeof(string), "* %s fires their tazer at %s, stunning them.", GetPlayerNameEx(playerid), GetPlayerNameEx(damagedid));
			ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			GameTextForPlayer(damagedid, "~r~Tazed", 3500, 3);
   			SetPlayerHealth(damagedid, hp+amount);
			TogglePlayerControllable(damagedid, 0);
			ApplyAnimation(damagedid,"CRACK","crckdeth2",4.1,0,1,1,1,1,1);
			PlayerPlaySound(damagedid, 1085, X, Y, Z);
			PlayerPlaySound(playerid, 1085, X, Y, Z);
			PlayerCuffed[damagedid] = 1;
			SetPVarInt(damagedid, "PlayerCuffed", 1);
			PlayerCuffedTime[damagedid] = 16;
			SetPVarInt(damagedid, "IsFrozen", 1);
			TazerTimeout[playerid] = 6;
			SetTimerEx("TazerTimer",1000,false,"d",playerid);
			GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~r~Tazer reloading... ~w~5", 1500,3);
		}
	}
	for(new i = 0; i < MAX_PLAYERS; ++i)
	{
		if(IsPlayerConnected(i))
		{
			if(PlayerInfo[i][pAdmin] >= 2 && GetPVarType(i, "_dCheck") && GetPVarInt(i, "_dCheck") == playerid) {
				new string[128];
				format(string, sizeof(string), "Damagecheck on %s: Damaged: %s (%d) | Weapon: %s | Damage: %f (GIVE)", GetPlayerNameEx(playerid), GetPlayerNameEx(damagedid), damagedid, GetWeaponNameEx(weaponid), amount);
				SendClientMessageEx(i, COLOR_WHITE, string);
			}
		}
	}
	return 1;
}

public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
	if(issuerid != INVALID_PLAYER_ID)
	{
		if(PlayerInfo[issuerid][pAccountRestricted] == 1 || PlayerInfo[playerid][pAccountRestricted] == 1)
		{
			new Float: fHealth, Float: fArmour;
			GetPlayerHealth(playerid, fHealth);
			GetPlayerArmour(playerid, fArmour);
			SetPlayerHealth(playerid, fHealth);
			SetPlayerArmour(playerid, fArmour);
			return true;
		}
	}
	if(GetPVarInt(playerid, "AttemptingLockPick") == 1) {
		DeletePVar(playerid, "AttemptingLockPick");
		DeletePVar(playerid, "LockPickCountdown");
		DeletePVar(playerid, "LockPickTotalTime");
		DeletePVar(playerid, "LockPickPosX");
		DeletePVar(playerid, "LockPickPosY");
		DeletePVar(playerid, "LockPickPosZ");
		DeletePVar(playerid, "LockPickPosZ");
		DestroyVLPTextDraws(playerid);
		if(GetPVarType(playerid, "LockPickVehicleSQLId")) {
			DeletePVar(playerid, "LockPickVehicleSQLId");
			DeletePVar(playerid, "LockPickPlayerSQLId");
			DeletePVar(playerid, "LockPickPlayerName");
			DestroyVehicle(GetPVarInt(playerid, "LockPickVehicle"));
		}
		else {
			new slot = GetPlayerVehicle(GetPVarInt(playerid, "LockPickPlayer"), GetPVarInt(playerid, "LockPickVehicle"));
			PlayerVehicleInfo[GetPVarInt(playerid, "LockPickPlayer")][slot][pvBeingPickLocked] = 0;
			PlayerVehicleInfo[GetPVarInt(playerid, "LockPickPlayer")][slot][pvBeingPickLockedBy] = INVALID_PLAYER_ID;
		}
		DeletePVar(playerid, "LockPickVehicle");
		DeletePVar(playerid, "LockPickPlayer");
		new failMessage[42 + MAX_PLAYER_NAME];
		format(failMessage, sizeof(failMessage), "(( You took damage from %s(%d) using %s.))", GetPlayerNameEx(issuerid), issuerid, GetWeaponNameEx(weaponid));
		SendClientMessageEx(playerid, COLOR_RED, "(( You failed to pick lock this vehicle because you took damage. ))");
		SendClientMessageEx(playerid, COLOR_RED, failMessage);
		SendClientMessageEx(playerid, COLOR_RED, "(( If this was DM, visit ng-gaming.net and make a Player Complaint. ))");
		ClearAnimations(playerid, 1);
	}
	if(GetPVarType(playerid, "AttemptingCrackTrunk")) {
		DeletePVar(playerid, "AttemptingCrackTrunk");
		DeletePVar(playerid, "CrackTrunkCountdown");
		DestroyVLPTextDraws(playerid);
		ClearAnimations(playerid, 1);
		new failMessage[42 + MAX_PLAYER_NAME];
		format(failMessage, sizeof(failMessage), "(( You took damage from %s(%d) using %s.))", GetPlayerNameEx(issuerid), issuerid, GetWeaponNameEx(weaponid));
		SendClientMessageEx(playerid, COLOR_RED, "(( You failed to crack this vehicle's trunk because you took damage. ))");
		SendClientMessageEx(playerid, COLOR_RED, failMessage);
		SendClientMessageEx(playerid, COLOR_RED, "(( If this was DM, visit ng-gaming.net and make a Player Complaint. ))");
	}
	if(GetPVarInt(playerid, "commitSuicide") == 1)
	{
		SetPVarInt(playerid, "commitSuicide", 0);
	}
	if(GetPVarInt(playerid, "BackpackProt") == 1)
	{
		DeletePVar(playerid, "BackpackProt");
		if(GetPVarInt(playerid, "BackpackOpen") == 1)
		{
			SendClientMessageEx(playerid, COLOR_RED, "You have taken damage during the backpack menu, your backpack is disabled for 3 minutes.");
			ShowPlayerDialog(playerid, -1, 0, "", "", "", "");
			SetPVarInt(playerid, "BackpackDisabled", 180);
			DeletePVar(playerid, "BackpackOpen");
		}
	}
	if(GetPVarInt(playerid, "BackpackMedKit") == 1)
	{
		DeletePVar(playerid, "BackpackMedKit");
	}
	if(GetPVarInt(playerid, "BackpackMeal") == 1)
	{
		DeletePVar(playerid, "BackpackMeal");
	}
	if(issuerid != INVALID_PLAYER_ID)
	{
	    ShotPlayer[issuerid][playerid] = gettime();
	    LastShot[playerid] = gettime();
		aLastShot[playerid] = issuerid;
		if(GetPVarType(playerid, "gt_Spraying"))
		{
			DeletePVar(playerid, "gt_Spraying");
		}
	}

	if(GetPVarInt(playerid, "PlayerCuffed") == 1)
	{
		new Float:currenthealth;
		GetPlayerHealth(playerid, currenthealth);
		if(currenthealth+amount > 100) SetPlayerHealth(playerid, 100); else SetPlayerHealth(playerid, currenthealth+amount);
	}

	//foreach(new i: Player) {
	for(new i = 0; i < MAX_PLAYERS; ++i)
	{
		if(IsPlayerConnected(i))
		{	
			if(PlayerInfo[i][pAdmin] >= 2 && GetPVarType(i, "_dCheck") && GetPVarInt(i, "_dCheck") == playerid) {
				new string[128];
				format(string, sizeof(string), "Damagecheck on %s: Issuer: %s (%d) | Weapon: %s | Damage: %f (TAKE)", GetPlayerNameEx(playerid), GetPlayerNameEx(issuerid), issuerid, GetWeaponNameEx(weaponid), amount);
				SendClientMessageEx(i, COLOR_WHITE, string);
			}
		}	
	}	
	new Float:actual_damage = amount;
	//fitness damage modifier
	if (weaponid == 0 || weaponid == 1 || weaponid == 2 || weaponid == 3 || weaponid == 5 || weaponid == 6 || weaponid == 7 || weaponid == 8)
	{
	    new Float: multiply;

	    if(PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[playerid][pWatchdog] >= 2 || PlayerInfo[playerid][pJailTime] > 0 || HelpingNewbie[playerid] != INVALID_PLAYER_ID || GetPVarInt(playerid, "eventStaff") >= 1) return 1;
		
		if(hgActive == 1 && HungerPlayerInfo[playerid][hgInEvent] == 1) return 1;
		
		if (PlayerInfo[issuerid][pFitness] < 50)
		{
 			multiply = 2;
		}
		else if (PlayerInfo[issuerid][pFitness] >= 50 && PlayerInfo[issuerid][pFitness] <= 79)
		{
		    multiply = 3.5;
		}
		else if (PlayerInfo[issuerid][pFitness] >= 80)
		{
		    multiply = 5;
		}

		if (PlayerInfo[playerid][pFitness] >= 80)
		{
			actual_damage = actual_damage/2;
		}

  		actual_damage *= multiply;

	}

	//heroin damage reduction
	if (GetPVarInt(playerid, "HeroinDamageResist") == 1) {
		actual_damage *= 0.25;
	}

	//armor & hp calculations AFTER damage modifiers
	new Float:difference;
	new Float:health, Float:armour;
	GetPlayerHealth(playerid, health);
	GetPlayerArmour(playerid, armour);

	if (armour == 0)
	{
		if (actual_damage > amount)
		{
			difference = actual_damage - amount;
			SetPlayerHealth(playerid, health - difference);
		}
		else if (actual_damage < amount)
		{
			difference = amount - actual_damage;
			SetPlayerHealth(playerid, health - difference);
		}
	}
	else if (armour >= actual_damage)
	{
		if (actual_damage > amount)
		{
			difference = actual_damage - amount;
			SetPlayerArmor(playerid, armour - difference);
		}
		else if (actual_damage < amount)
		{
			difference = amount - actual_damage;
			SetPlayerArmor(playerid, armour - difference);
		}
	}
	else // damage needs to be split between armour & health
	{
		if (actual_damage > amount)
		{
			difference = actual_damage - amount;

			new Float:leftOver = difference - armour;
			SetPlayerArmor(playerid, 0);
			SetPlayerHealth(playerid, health - leftOver);
		}
		else if (actual_damage < amount)
		{
			difference = amount - actual_damage;

			new Float:leftOver = difference - armour;
			SetPlayerArmor(playerid, 0);
			SetPlayerHealth(playerid, health - leftOver);
		}
	}


	return 1;
}

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
    /*new szString[144];
    format(szString, sizeof(szString), "Weapon %i fired. hittype: %i   hitid: %i   pos: %f, %f, %f", weaponid, hittype, hitid, fX, fY, fZ);
    SendClientMessage(playerid, -1, szString);*/
	if(weaponid == 24 || weaponid == 25 || weaponid == 26/* || weaponid == 31*/)
	{
		++PlayerShots[playerid];
	}
	if(IsAHitman(playerid) && GetPVarInt(playerid, "ExecutionMode") == 1 && (weaponid == WEAPON_DEAGLE || weaponid == WEAPON_SNIPER))
	{
		if(hittype != BULLET_HIT_TYPE_PLAYER && hitid != GoChase[playerid])
		{
			SetPVarInt(playerid, "ExecutionMode", 0);
			SendClientMessage(playerid, COLOR_RED, "You missed the target, wait 5 minutes before re-loading a HP Round.");
			SetPVarInt(playerid, "KillShotCooldown", gettime());
		}
	}
	if(GetPVarInt(playerid, "FireStart") == 1)
	{
		if(fX != 0 && fY != 0 && fZ != 0 && hittype != BULLET_HIT_TYPE_PLAYER && hittype != BULLET_HIT_TYPE_VEHICLE)
		{
			if(gettime() > GetPVarInt(playerid, "fCooldown")) CreateStructureFire(fX, fY, fZ, GetPlayerVirtualWorld(playerid));
		}
	}
	return 1;
}