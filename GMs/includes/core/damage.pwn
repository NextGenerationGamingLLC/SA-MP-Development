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
	if(PlayerIsDead[damagedid]) return 1;
	if(damagedid != INVALID_PLAYER_ID && playerid != INVALID_PLAYER_ID)
	{
		if(!IsPlayerStreamedIn(playerid, damagedid) || !IsPlayerStreamedIn(damagedid, playerid)) return 1;
		if(PlayerInfo[playerid][pAccountRestricted] == 1 || PlayerInfo[damagedid][pAccountRestricted] == 1) return 1;
		if(PlayerInfo[damagedid][pHospital] == 1) return 1;
		if(GetPVarInt(damagedid, "PlayerCuffed") == 1) return 1;
		ShotPlayer[playerid][damagedid] = gettime();
		LastShot[damagedid] = gettime();
		aLastShot[damagedid] = playerid;
		if(GetPVarType(damagedid, "gt_Spraying")) DeletePVar(damagedid, "gt_Spraying");
		if(zombieevent && GetPVarInt(playerid, "z50Cal") == 1 && PlayerInfo[playerid][mInventory][17] && (weaponid == WEAPON_SNIPER || weaponid == WEAPON_RIFLE))
		{
			if(bodypart == BODY_PART_HEAD && GetPVarInt(damagedid, "pIsZombie")) SetHealth(damagedid, 0);
			if(PlayerInfo[playerid][mInventory][17]) PlayerInfo[playerid][mInventory][17]--;
			DeletePVar(playerid, "z50Cal");
		}
		if(IsAHitman(playerid) && GetPVarInt(playerid, "ExecutionMode") == 1 && (weaponid == WEAPON_DEAGLE || weaponid == WEAPON_SNIPER || weaponid == WEAPON_COLT45 || weaponid == WEAPON_RIFLE || weaponid == WEAPON_SILENCED))
		{
			if(damagedid == GoChase[playerid] && bodypart == BODY_PART_HEAD)
			{
				// Almost guarantees /execute to properly fulfill a hit every time, as long as the shot hits and not dependent on what the Player Death callback says killed them.
				SetPVarInt(damagedid, "KilledByExecute", playerid);
				SetPVarInt(playerid, "ExecutionMode", 0);
				SetPVarInt(playerid, "KillShotCooldown", gettime());
				SetHealth(damagedid, 0);
			}
			else
			{
				SetPVarInt(playerid, "ExecutionMode", 0);
				SendClientMessage(playerid, COLOR_RED, "You missed the target, wait 5 minutes before re-loading a HP Round.");
				SetPVarInt(playerid, "KillShotCooldown", gettime());
			}
		}
		if(pTazer{playerid} == 1)
		{
			if(weaponid !=  23) {
				RemovePlayerWeapon(playerid, 23);
				GivePlayerValidWeapon(playerid, pTazerReplace{playerid}, 60000);
				format(szMiscArray, sizeof(szMiscArray), "* %s holsters their tazer.", GetPlayerNameEx(playerid));
				ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				pTazer{playerid} = 0;
				return 1;
			}
			if(!ProxDetectorS(20.0, playerid, damagedid)) {
				format(szMiscArray, sizeof(szMiscArray), "* %s fires their tazer at %s, missing them.", GetPlayerNameEx(playerid), GetPlayerNameEx(damagedid));
				ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				return 1;
			}
			if(TazerTimeout[playerid] > 0 && !GetPVarType(damagedid, "IsFrozen")) return 1;
			if(GetPlayerState(damagedid) == PLAYER_STATE_ONFOOT && PlayerCuffed[damagedid] == 0 && PlayerInfo[playerid][pHasTazer] == 1)
			{
				if((PlayerInfo[damagedid][pAdmin] >= 2 || PlayerInfo[damagedid][pWatchdog] >= 2) && PlayerInfo[damagedid][pTogReports] != 1) return SendClientMessageEx(playerid, COLOR_GRAD2, "Admins can not be tazed!");
				if(PlayerInfo[damagedid][pHospital] == 1) return SendClientMessageEx(playerid, COLOR_GRAD2, "Players in hospital cannot be tazed!");
				new newkeys, dir1, dir2;
				GetPlayerKeys(damagedid, newkeys, dir1, dir2);
				if(ActiveKey(KEY_HANDBRAKE) && (!IsNotAGun(GetPlayerWeapon(playerid)))) return SendClientMessageEx(playerid, COLOR_WHITE, "You cannot taze players that are actively aiming.");
				if(ActiveKey(KEY_FIRE) && (!IsNotAGun(GetPlayerWeapon(playerid)))) return SendClientMessageEx(playerid, COLOR_WHITE, "You cannot taze players that are actively shooting.");
				#if defined zombiemode
				if(GetPVarInt(damagedid, "pIsZombie")) return SendClientMessageEx(playerid, COLOR_GRAD2, "Zombies can not be tazed!");
				#endif
				new Float:X, Float:Y, Float:Z;
				GetPlayerPos(playerid, X, Y, Z);
				format(szMiscArray, sizeof(szMiscArray), "* %s fires their tazer at %s, stunning them.", GetPlayerNameEx(playerid), GetPlayerNameEx(damagedid));
				ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				GameTextForPlayer(damagedid, "~r~Tazed", 3500, 3);
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
				return 1;
			}
		}
		if(pTazer{damagedid} == 1 && (!IsNotAGun(weaponid)))
		{
			RemovePlayerWeapon(damagedid, 23);
			GivePlayerValidWeapon(damagedid, pTazerReplace{damagedid}, 60000);
			format(szMiscArray, sizeof(szMiscArray), "* %s holsters their tazer.", GetPlayerNameEx(damagedid));
			ProxDetector(4.0, damagedid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			pTazer{damagedid} = 0;
			SendClientMessageEx(damagedid, COLOR_WHITE, "Your tazer has been holstered as you have taken damage from bullets.");
		}
	}
	if(GetPVarInt(damagedid, "AttemptingLockPick") == 1) {
		DeletePVar(damagedid, "AttemptingLockPick");
		DeletePVar(damagedid, "LockPickCountdown");
		DeletePVar(damagedid, "LockPickTotalTime");
		DeletePVar(damagedid, "LockPickPosX");
		DeletePVar(damagedid, "LockPickPosY");
		DeletePVar(damagedid, "LockPickPosZ");
		DeletePVar(damagedid, "LockPickPosZ");
		DestroyVLPTextDraws(damagedid);
		if(GetPVarType(damagedid, "LockPickVehicleSQLId")) {
			DeletePVar(damagedid, "LockPickVehicleSQLId");
			DeletePVar(damagedid, "LockPickPlayerSQLId");
			DeletePVar(damagedid, "LockPickPlayerName");
			DestroyVehicle(GetPVarInt(damagedid, "LockPickVehicle"));
		}
		else {
			new slot = GetPlayerVehicle(GetPVarInt(damagedid, "LockPickPlayer"), GetPVarInt(damagedid, "LockPickVehicle"));
			PlayerVehicleInfo[GetPVarInt(damagedid, "LockPickPlayer")][slot][pvBeingPickLocked] = 0;
			PlayerVehicleInfo[GetPVarInt(damagedid, "LockPickPlayer")][slot][pvBeingPickLockedBy] = INVALID_PLAYER_ID;
		}
		DeletePVar(damagedid, "LockPickVehicle");
		DeletePVar(damagedid, "LockPickPlayer");
		format(szMiscArray, sizeof(szMiscArray), "(( You took damage from %s(%d) using %s.))", GetPlayerNameEx(playerid), playerid, GetWeaponNameEx(weaponid));
		SendClientMessageEx(damagedid, COLOR_RED, "(( You failed to pick lock this vehicle because you took damage. ))");
		SendClientMessageEx(damagedid, COLOR_RED, szMiscArray);
		SendClientMessageEx(damagedid, COLOR_RED, "(( If this was DM, visit ng-gaming.net and make a Player Complaint. ))");
		ClearAnimations(damagedid, 1);
	}
	if(GetPVarType(damagedid, "AttemptingCrackTrunk")) {
		DeletePVar(damagedid, "AttemptingCrackTrunk");
		DeletePVar(damagedid, "CrackTrunkCountdown");
		DestroyVLPTextDraws(damagedid);
		ClearAnimations(damagedid, 1);
		format(szMiscArray, sizeof(szMiscArray), "(( You took damage from %s(%d) using %s.))", GetPlayerNameEx(playerid), playerid, GetWeaponNameEx(weaponid));
		SendClientMessageEx(damagedid, COLOR_RED, "(( You failed to crack this vehicle's trunk because you took damage. ))");
		SendClientMessageEx(damagedid, COLOR_RED, szMiscArray);
		SendClientMessageEx(damagedid, COLOR_RED, "(( If this was DM, visit ng-gaming.net and make a Player Complaint. ))");
	}
	if(GetPVarInt(damagedid, "commitSuicide") == 1) SetPVarInt(damagedid, "commitSuicide", 0);
	if(GetPVarInt(damagedid, "BackpackProt") == 1)
	{
		DeletePVar(damagedid, "BackpackProt");
		if(GetPVarInt(damagedid, "BackpackOpen") == 1)
		{
			SendClientMessageEx(damagedid, COLOR_RED, "You have taken damage during the backpack menu, your backpack is disabled for 3 minutes.");
			ShowPlayerDialog(damagedid, -1, 0, "", "", "", "");
			SetPVarInt(damagedid, "BackpackDisabled", 180);
			DeletePVar(damagedid, "BackpackOpen");
		}
	}
	if(GetPVarInt(damagedid, "BackpackMedKit") == 1) DeletePVar(damagedid, "BackpackMedKit");
	if(GetPVarInt(damagedid, "BackpackMeal") == 1) DeletePVar(damagedid, "BackpackMeal");

	switch(weaponid)
	{
		case 0 .. 8, 10 .. 15, 28, 32: if(amount > 7.0) amount = 7.0;
		case 9: if(amount > 30.0) amount = 30.0;
		case 23: if(amount > 14.0) amount = 14.0;
		case 24, 38: if(amount > 47.0) amount = 47.0;
		case 25, 26: if(amount > 50.0) amount = 50.0;
		case 27: if(amount > 40.0) amount = 40.0;
		case 22, 29: if(amount > 9.0) amount = 9.0;
		case 30, 31: if(amount > 10.0) amount = 10.0;
		case 33: if(amount > 25.0) amount = 25.0;
		case 34: if(amount > 42.0) amount = 42.0;
		case 37, 41, 42: if(amount > 3.0) amount = 3.0;
	}

	new Float:actual_damage = amount;
	//fitness damage modifier
	if (playerid != INVALID_PLAYER_ID && (weaponid == 0 || weaponid == 1 || weaponid == 2 || weaponid == 3 || weaponid == 5 || weaponid == 6 || weaponid == 7 || weaponid == 8) )
	{
		new Float: multiply;
		if(PlayerInfo[damagedid][pAdmin] >= 2 || PlayerInfo[damagedid][pWatchdog] >= 2 || PlayerInfo[damagedid][pJailTime] > 0 || HelpingNewbie[damagedid] != INVALID_PLAYER_ID || GetPVarInt(damagedid, "eventStaff") >= 1) return 1;
		if(hgActive == 1 && HungerPlayerInfo[damagedid][hgInEvent] == 1) return 1;
		if (PlayerInfo[playerid][pFitness] < 50)
		{
 			multiply = 2;
		}
		else if (PlayerInfo[playerid][pFitness] >= 50 && PlayerInfo[playerid][pFitness] <= 79)
		{
			multiply = 3.5;
		}
		else if (PlayerInfo[playerid][pFitness] >= 80)
		{
			multiply = 5;
		}
		if (PlayerInfo[damagedid][pFitness] >= 80)
		{
			actual_damage = actual_damage/2;
		}
		actual_damage *= multiply;
	}

	//heroin damage reduction
	if (GetPVarInt(damagedid, "HeroinDamageResist") == 1) {
		actual_damage *= 0.25;
	}

	//armor & hp calculations AFTER damage modifiers
	new Float:difference,
		Float:health,
		Float:armour;
	GetHealth(damagedid, health);
	GetArmour(damagedid, armour);

	/*format(szMiscArray, sizeof(szMiscArray), "Actual Damage: %f", actual_damage);
	SendClientMessageToAll(-1, line);*/

	if(armour < 0.1) // Player has no armour
	{
		difference = health - actual_damage;
		if(difference < 0.1)
		{
			SetHealth(damagedid, 0.0);
			OnPlayerDeath(damagedid, playerid, weaponid);
		}
		else SetHealth(damagedid, difference);	
	}
	else // Player has armour
	{
		difference = armour - actual_damage;
		if(difference < 0.1) 
		{
			SetArmour(damagedid, 0.0);
			health += difference;
			if(health < 0.1)
			{
				SetHealth(damagedid, 0.0);
				OnPlayerDeath(damagedid, playerid, weaponid);
			}
			else SetHealth(damagedid, health);
		}
		else SetArmour(damagedid, difference);
	}
	foreach(Player, i)
	{
		if(IsPlayerConnected(i))
		{
			if(PlayerInfo[i][pAdmin] >= 2 && GetPVarType(i, "_dCheck") && GetPVarInt(i, "_dCheck") == playerid) {
				format(szMiscArray, sizeof(szMiscArray), "Damagecheck on %s: Damaged: %s (%d) | Weapon: %s | Damage: %f (GIVE)", GetPlayerNameEx(playerid), GetPlayerNameEx(damagedid), damagedid, GetWeaponNameEx(weaponid), amount);
				SendClientMessageEx(i, COLOR_WHITE, szMiscArray);
			}
		}
	}
	return 1;
}

public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
	/*format(szMiscArray, sizeof(szMiscArray), "Playerid: %i Issuerid: %i, Amount: %f WeaponID: %i", playerid, issuerid, amount, weaponid);
	SendClientMessageToAll(-1, szMiscArray);*/
	if(issuerid == INVALID_PLAYER_ID && (weaponid == 51 || weaponid == 53 || weaponid == 54 || weaponid == 47 || weaponid == 37)) OnPlayerGiveDamage(issuerid, playerid, amount, weaponid, bodypart);
	else 
	{
		switch(weaponid)
		{
			case 50: { ClearAnimations(playerid); }
			case 49, 51, 35, 36, 37, 54, 47, 53: { OnPlayerGiveDamage(issuerid, playerid, amount, weaponid, bodypart); }
		}
	}
	foreach(Player, i)
	{
		if(IsPlayerConnected(i))
		{
			if(PlayerInfo[i][pAdmin] >= 2 && GetPVarType(i, "_dCheck") && GetPVarInt(i, "_dCheck") == playerid) {
				format(szMiscArray, sizeof(szMiscArray), "Damagecheck on %s: Issuer: %s (%d) | Weapon: %s | Damage: %f (TAKE)", GetPlayerNameEx(playerid), GetPlayerNameEx(issuerid), issuerid, GetWeaponNameEx(weaponid), amount);
				SendClientMessageEx(i, COLOR_WHITE, szMiscArray);
			}
		}
	}
	return 1;
}

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
    /*new szString[144];
    format(szString, sizeof(szString), "Weapon %i fired. hittype: %i   hitid: %i   pos: %f, %f, %f", weaponid, hittype, hitid, fX, fY, fZ);
    SendClientMessage(playerid, -1, szString);*/
	if(hittype == BULLET_HIT_TYPE_PLAYER)
	{
		if(!IsPlayerStreamedIn(playerid, hitid) || !IsPlayerStreamedIn(hitid, playerid)) return 0;
	}
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