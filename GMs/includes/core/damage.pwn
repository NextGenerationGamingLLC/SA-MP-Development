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

public OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid, bodypart)
{
	szMiscArray[0] = 0;
	if(PlayerIsDead[damagedid]) return 1;
	new Float:realdam = amount;
	if(damagedid != INVALID_PLAYER_ID && playerid != INVALID_PLAYER_ID) {

	    if(amount < 0.0) amount = 0.0;
	    if(amount > 150.0) amount = 150.0;
	    // First define our base damage.
		switch(weaponid)
		{
			case 0 .. 3, 5 .. 8, 10 .. 15, 28, 32: if(amount > 20.0) amount = 20.0;
			case 4: if(amount > 150.0) amount = 150.0;
			case 9: if(amount > 30.0) amount = 30.0;
			case 23: if(amount > 14.0) amount = 14.0;
			case 24, 38: if(amount > 47.0) amount = 47.0;
			case 25, 26: if(amount > 50.0) amount = 50.0;
			case 27: if(amount > 40.0) amount = 40.0;
			case 22, 29: if(amount > 9.0) amount = 9.0;
			case 30, 31: if(amount > 10.0) amount = 10.0;
			case 33: if(amount > 25.0) amount = 25.0;
			case 34: if(amount > 42.0) amount = 42.0;
			case 37, 42: if(amount > 3.0) amount = 3.0;
			case 41: amount = 0.0;
			default: if(amount > 20.0) amount = 20.0; // If there is no gun defined fall onto this (Should stop hacks going out of the 32-bit range)
		}
		if(GetPlayerCameraMode(playerid) == 55 && amount > 9.0) amount = 9.0;

		if(weaponid == WEAPON_COLT45 || weaponid == WEAPON_SILENCED || weaponid == WEAPON_AK47)
		{
			amount *= 1.65;
		}
		if(weaponid == WEAPON_SNIPER)
		{
			amount *= 1.30;
		}
		//heroin damage reduction
		if (GetPVarInt(damagedid, "HeroinDamageResist") == 1) {
			amount *= 0.25;
		}

		new Float:difference,
			Float:health,
			Float:armour;
		GetHealth(damagedid, health);
		GetArmour(damagedid, armour);

		// Ignore godmode. - Admins / Advisors (for health only)
		if(!GetPVarInt(damagedid, "pGodMode")) {
			if(health < 0.1) SetHealth(damagedid, 0.1), GetHealth(damagedid, health); // just set to this as they'll be killed either way.
			if(health > 150.0) SetHealth(damagedid, 150.0), GetHealth(damagedid, health);
		}

		if(armour < 0.0) SetArmour(damagedid, 0.0), GetArmour(damagedid, armour);
		if(armour > 100.0) SetArmour(damagedid, 100.0), GetArmour(damagedid, armour);

		if(!IsPlayerStreamedIn(playerid, damagedid) || !IsPlayerStreamedIn(damagedid, playerid)) return 1;
		new vehmodel = GetVehicleModel(GetPlayerVehicleID(playerid));
		if(GetPVarInt(playerid, "EventToken") == 0 && !GetPVarType(playerid, "IsInArena") && (vehmodel != 425 && vehmodel != 432 && vehmodel != 447 && vehmodel != 464 && vehmodel != 476 && vehmodel != 520) && GetWeaponSlot(weaponid) != -1)
		{
			if(PlayerInfo[playerid][pGuns][GetWeaponSlot(weaponid)] != weaponid)
			{
				if(gettime() > GetPVarInt(playerid, "NopeWepWarn"))
				{
					format(szMiscArray, sizeof(szMiscArray), "{AA3333}AdmWarning{FFFF00}: %s (ID: %d) has been denied issuing damage. Possible weapon hack: Server Weapon: %d | Used Weapon: %d", GetPlayerNameEx(playerid), playerid, PlayerInfo[playerid][pGuns][GetWeaponSlot(weaponid)], weaponid);
					ABroadCast(COLOR_YELLOW, szMiscArray, 2);
					format(szMiscArray, sizeof(szMiscArray), "%s (%d) has been denied issuing damage. Possible weapon hack: Server Weapon: %d | Used Weapon: %d", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), PlayerInfo[playerid][pGuns][GetWeaponSlot(weaponid)], weaponid);
					Log("logs/hack.log", szMiscArray);
					SetPVarInt(playerid, "NopeWepWarn", gettime()+60);
				}
				return 1;
			}
			if((PlayerInfo[playerid][pWRestricted] > 0 || PlayerInfo[playerid][pConnectHours] < 2) && (weaponid != 0 && weaponid != 46))
			{
				if(gettime() > GetPVarInt(playerid, "WepResWarn"))
				{
					format(szMiscArray, sizeof(szMiscArray), "{AA3333}AdmWarning{FFFF00}: %s (ID: %d) has been denied issuing damage while being weapon restricted. WeaponID: %d", GetPlayerNameEx(playerid), playerid, weaponid);
					ABroadCast(COLOR_YELLOW, szMiscArray, 2);
					format(szMiscArray, sizeof(szMiscArray), "%s (%d) has been denied issuing damage while being weapon restricted. WeaponID: %d", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), weaponid);
					Log("logs/hack.log", szMiscArray);
					SetPVarInt(playerid, "WepResWarn", gettime()+60);
				}
				return 1;
			}
		}
		if(PlayerInfo[playerid][pAccountRestricted] == 1 || PlayerInfo[damagedid][pAccountRestricted] == 1) return 1;
		if(PlayerInfo[playerid][pHospital] == 1 || PlayerInfo[damagedid][pHospital] == 1) return 1;
		if(GetPVarInt(damagedid, "PlayerCuffed") == 1) return 1;
		ShotPlayer[playerid][damagedid] = gettime();
		LastShot[damagedid] = gettime();
		aLastShot[damagedid] = playerid;
		aLastShotBone[damagedid] = bodypart;
		aLastShotWeapon[damagedid] = weaponid;
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
				SetPVarInt(playerid, "ExecutionMode", 0);
				SetPVarInt(playerid, "KillShotCooldown", gettime());
				SetHealth(damagedid, 0);
				OnPlayerDeath(damagedid, playerid, weaponid);
				return 1;
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
				GivePlayerValidWeapon(playerid, pTazerReplace{playerid});
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
				if(HelpingNewbie[damagedid] != INVALID_PLAYER_ID) return SendClientMessageEx(playerid, COLOR_GRAD2, "You cannot taze an advisor while they are helping someone.");
				if(PlayerInfo[damagedid][pHospital] == 1) return SendClientMessageEx(playerid, COLOR_GRAD2, "Players in hospital cannot be tazed!");
				new newkeys, dir1, dir2;
				GetPlayerKeys(damagedid, newkeys, dir1, dir2);
				if(GetPlayerCameraMode(damagedid) == 53 || GetPlayerCameraMode(damagedid) == 7 || GetPlayerCameraMode(damagedid) == 8 || GetPlayerCameraMode(damagedid) == 51) return SendClientMessageEx(playerid, COLOR_WHITE, "You cannot taze players that are actively aiming.");
				//if(ActiveKey(KEY_HANDBRAKE) && (!IsNotAGun(GetPlayerWeapon(damagedid)))) return SendClientMessageEx(playerid, COLOR_WHITE, "You cannot taze players that are actively aiming.");
				//if(ActiveKey(KEY_FIRE) && (!IsNotAGun(GetPlayerWeapon(damagedid)))) return SendClientMessageEx(playerid, COLOR_WHITE, "You cannot taze players that are actively shooting.");
				#if defined zombiemode
				if(GetPVarInt(damagedid, "pIsZombie")) return SendClientMessageEx(playerid, COLOR_GRAD2, "Zombies can not be tazed!");
				#endif
				new Float:X, Float:Y, Float:Z;
				GetPlayerPos(playerid, X, Y, Z);
				format(szMiscArray, sizeof(szMiscArray), "* %s fires their tazer at %s, stunning them.", GetPlayerNameEx(playerid), GetPlayerNameEx(damagedid));
				ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				//GameTextForPlayer(damagedid, "~r~Tazed", 3500, 3);
				TogglePlayerControllable(damagedid, 0);
				ApplyAnimation(damagedid,"CRACK","crckdeth2",4.1,0,1,1,1,1,1);
				PlayerPlaySound(damagedid, 1085, X, Y, Z);
				PlayerPlaySound(playerid, 1085, X, Y, Z);
				PlayerCuffed[damagedid] = 1;
				SetPVarInt(damagedid, "PlayerCuffed", 1);
				PlayerCuffedTime[damagedid] = 16;
				SetPVarInt(damagedid, "IsFrozen", 1);
				TazerTimeout[playerid] = 12;
				SetTimerEx("TazerTimer",1000,false,"d",playerid);
				PlayerTextDrawShow(damagedid, _vhudFlash[damagedid]);
				SetTimerEx("TurnOffFlash", 800, 0, "i", damagedid);
				if(GetPVarType(damagedid, "FixVehicleTimer")) KillTimer(GetPVarInt(damagedid, "FixVehicleTimer")), DeletePVar(damagedid, "FixVehicleTimer");
				GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~r~Tazer reloading... ~w~12", 1500,3);
				return 1;
			}
		}
		if(GetPlayerWeapon(playerid) == 25 && GetPVarType(playerid, "pBeanBag")) 
		{
			if(GetPVarInt(damagedid, "pBagged") >= 1) return 0;
	    	else if(GetPlayerState(damagedid) == PLAYER_STATE_ONFOOT)
			{
				if(GetPlayerCameraMode(damagedid) == 53 || GetPlayerCameraMode(damagedid) == 7 || GetPlayerCameraMode(damagedid) == 8 || GetPlayerCameraMode(damagedid) == 51) return SendClientMessageEx(playerid, COLOR_WHITE, "You cannot bag players that are actively aiming.");
				if(HelpingNewbie[damagedid] != INVALID_PLAYER_ID) return SendClientMessageEx(playerid, COLOR_GRAD2, "You cannot taze an advisor while they are helping someone.");
				if(PlayerInfo[damagedid][pHospital] == 1) return SendClientMessageEx(playerid, COLOR_GRAD2, "Players in hospital cannot be tazed!");
				new Float:fHealth, Float:fArmour;

				GetHealth(damagedid, fHealth);
				GetArmour(damagedid, fArmour);
				SetHealth(damagedid, fHealth);
				SetArmour(damagedid, fArmour);

	    		TogglePlayerControllable(damagedid, FALSE);
     			ApplyAnimation(damagedid,"PED","KO_shot_stom",4.1,0,1,1,1,1,1);
	    		SetTimerEx("_UnbeanbagTimer", 20000, false, "d", damagedid);
	    		SetPlayerDrunkLevel(damagedid, 10000);
	    		PlayerTextDrawShow(damagedid, _vhudFlash[damagedid]);
	    		SetPVarInt(damagedid, "IsFrozen", 1);
     			SetTimerEx("TurnOffFlash", 5000, 0, "i", damagedid);

     			SetPVarInt(damagedid, "pBagged", 1);

	    		GameTextForPlayer(damagedid, "~r~Bagged!", 7000, 3);
	    		format(szMiscArray, sizeof(szMiscArray), "* %s fires their beanbag shotgun at %s, stunning them.", GetPlayerNameEx(playerid), GetPlayerNameEx(damagedid));
				ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	    		if(GetPVarType(damagedid, "FixVehicleTimer")) KillTimer(GetPVarInt(damagedid, "FixVehicleTimer")), DeletePVar(damagedid, "FixVehicleTimer");
	    		return 1;
	    	}
		}
		if(pTazer{damagedid} == 1 && (!IsNotAGun(weaponid)))
		{
			RemovePlayerWeapon(damagedid, 23);
			GivePlayerValidWeapon(damagedid, pTazerReplace{damagedid});
			format(szMiscArray, sizeof(szMiscArray), "* %s holsters their tazer.", GetPlayerNameEx(damagedid));
			ProxDetector(4.0, damagedid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			pTazer{damagedid} = 0;
			SendClientMessageEx(damagedid, COLOR_WHITE, "Your tazer has been holstered as you have taken damage from bullets.");
		}
		// Apply Ending Result
		if(armour < 0.1)
		{
			difference = health - amount;
			if(difference < 0.1)
			{
				SetHealth(damagedid, 0.0);
				OnPlayerDeath(damagedid, playerid, weaponid);
			}
			else SetHealth(damagedid, difference);
		}
		else
		{
			difference = armour - amount;
			if(difference < 0.1)
			{
				SetArmour(damagedid, 0.0);
				health += difference;
				if(health < 0.1) {
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
					format(szMiscArray, sizeof(szMiscArray), "[Dmgcheck] %s: Dmgd: %s (%d) | Wp: %s | CSDmg: %.2f | SSDmg: %.2f | %s (GIVE)", GetPlayerNameEx(playerid), GetPlayerNameEx(damagedid), damagedid, GetWeaponNameEx(weaponid), realdam, amount, ReturnBoneName(bodypart));
					SendClientMessageEx(i, COLOR_WHITE, szMiscArray);
				}
			}
		}
	}
	return 1;
}


timer DeathScreen[4000](playerid) {

	if(!GetPVarType(playerid, "InjuredTL")) return 1;

	new Float:fPos[3],
		iObjectID;

	GetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]);
	iObjectID = CreateObject(19300, fPos[0], fPos[1], fPos[2], 0.0, 0.0, 0.0);
	SetPVarInt(playerid, "DS_OBJ", iObjectID);
	MoveObject(iObjectID, fPos[0], fPos[1], fPos[2] + 3.0, 1.0, 1.0, 0.0, 0.0);
	AttachCameraToObject(playerid, iObjectID);
	// ApplyAnimation(playerid, "WUZI", "CS_Dead_Guy", 4.1, 1, 1, 1, 1, 0, 1);
	return 1;
}

public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
	szMiscArray[0] = 0;
	if(PlayerIsDead[playerid]) return 1;
	new Float:realdam = amount;
	if(playerid != 65535) 
	{
	    if(amount < 0.0) amount = 0.0;
	    if(amount > 150.0) amount = 150.0;

		switch(weaponid)
		{
			// Take into account drug effects (needs to be 150 for fall damage etc..)
			case 50: { ClearAnimations(playerid); if(amount > 150.0) amount = 150.0; }
			default: if(amount > 150.0) amount = 150.0;
		}

		//heroin damage reduction
		if (GetPVarInt(playerid, "HeroinDamageResist") == 1) {
			amount *= 0.25;
		}

		new Float:difference,
			Float:health,
			Float:armour;
		GetHealth(playerid, health);
		GetArmour(playerid, armour);

		// Ignore godmode. - Admins / Advisors (for health only)
		if(!GetPVarInt(playerid, "pGodMode")) {
			if(health < 0.1) SetHealth(playerid, 0.1), GetHealth(playerid, health);
			if(health > 150.0) SetHealth(playerid, 150.0), GetHealth(playerid, health);
		}

		if(armour < 0.0) SetArmour(playerid, 0.0), GetArmour(playerid, armour);
		if(armour > 100.0) SetArmour(playerid, 100.0), GetArmour(playerid, armour);

		if(PlayerInfo[playerid][pHospital] == 1) return 1;
		if(GetPVarInt(playerid, "PlayerCuffed") == 1) return 1;

		if(weaponid == WEAPON_COLLISION && (1061 <= GetPlayerAnimationIndex(playerid) <= 1067)) // Climb Bug
		{
			new Float:hp;
			ClearAnimations(playerid);
			GetHealth(playerid, hp);
			SetHealth(playerid, hp);
			return 1;
		}
		if(issuerid != 65535) {
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
				format(szMiscArray, sizeof(szMiscArray), "(( You took damage from %s(%d) using %s.))", GetPlayerNameEx(issuerid), issuerid, GetWeaponNameEx(weaponid));
				SendClientMessageEx(playerid, COLOR_RED, "(( You failed to pick lock this vehicle because you took damage. ))");
				SendClientMessageEx(playerid, COLOR_RED, szMiscArray);
				SendClientMessageEx(playerid, COLOR_RED, "(( If this was DM, visit ng-gaming.net and make a Player Complaint. ))");
				ClearAnimations(playerid, 1);
			}
			if(GetPVarType(playerid, "AttemptingCrackTrunk")) {
				DeletePVar(playerid, "AttemptingCrackTrunk");
				DeletePVar(playerid, "CrackTrunkCountdown");
				DestroyVLPTextDraws(playerid);
				ClearAnimations(playerid, 1);
				format(szMiscArray, sizeof(szMiscArray), "(( You took damage from %s(%d) using %s.))", GetPlayerNameEx(issuerid), issuerid, GetWeaponNameEx(weaponid));
				SendClientMessageEx(playerid, COLOR_RED, "(( You failed to crack this vehicle's trunk because you took damage. ))");
				SendClientMessageEx(playerid, COLOR_RED, szMiscArray);
				SendClientMessageEx(playerid, COLOR_RED, "(( If this was DM, visit ng-gaming.net and make a Player Complaint. ))");
			}

			if(GetPVarInt(playerid, "commitSuicide") == 1) SetPVarInt(playerid, "commitSuicide", 0);
			if(GetPVarInt(playerid, "BackpackProt") == 1)
			{
				DeletePVar(playerid, "BackpackProt");
				if(GetPVarInt(playerid, "BackpackOpen") == 1)
				{
					SendClientMessageEx(playerid, COLOR_RED, "You have taken damage during the backpack menu, your backpack is disabled for 3 minutes.");
					ShowPlayerDialogEx(playerid, -1, 0, "", "", "", "");
					SetPVarInt(playerid, "BackpackDisabled", 180);
					DeletePVar(playerid, "BackpackOpen");
				}
			}
			if(GetPVarInt(playerid, "BackpackMedKit") == 1) DeletePVar(playerid, "BackpackMedKit");
			if(GetPVarInt(playerid, "BackpackMeal") == 1) DeletePVar(playerid, "BackpackMeal");
		}
		/*
		51 - Explosion
		38 - Hunter Minigun
		47 - Fake Pistol
		37 - Flamethrower
		49 - Car Ramming
		50 - Heliblade
		31 - Seasparrow minigun (M4)
		54 - Splat
		*/
		if(issuerid == 65535) {
			difference = health - amount;
			if(difference < 0.1)
			{
				SetHealth(playerid, 0.0);
				OnPlayerDeath(playerid, issuerid, weaponid);
			}
			else SetHealth(playerid, difference);
		}
		if(issuerid != 65535 && (weaponid == 51 || weaponid == 38 || weaponid == 47 || weaponid == 37 || weaponid == 49 || weaponid == 31)) {
			if(armour < 0.1)
			{
				difference = health - amount;
				if(difference < 0.1)
				{
					SetHealth(playerid, 0.0);
					OnPlayerDeath(playerid, issuerid, weaponid);
				}
				else SetHealth(playerid, difference);
			}
			else
			{
				difference = armour - amount;
				if(difference < 0.1)
				{
					SetArmour(playerid, 0.0);
					health += difference;
					if(health < 0.1) {
						SetHealth(playerid, 0.0);
						OnPlayerDeath(playerid, issuerid, weaponid);
					}
					else SetHealth(playerid, health);
				}
				else SetArmour(playerid, difference);
			}
		}
		foreach(Player, i)
		{
			if(IsPlayerConnected(i))
			{
				if(PlayerInfo[i][pAdmin] >= 2 && GetPVarType(i, "_dCheck") && GetPVarInt(i, "_dCheck") == playerid) {
					format(szMiscArray, sizeof(szMiscArray), "[Dmgcheck] %s: Issuer: %s (%d) | Wp: %s (%d) | CSDmg: %.2f | SSDmg: %.2f | %s (TAKE)", GetPlayerNameEx(playerid), GetPlayerNameEx(issuerid), issuerid, GetWeaponNameEx(weaponid), weaponid, realdam, amount, ReturnBoneName(bodypart));
					SendClientMessageEx(i, COLOR_WHITE, szMiscArray);
				}
			}
		}
	}
	return 1;
}
/*
public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	return 1;
}
*/

public OnPlayerDeath(playerid, killerid, reason)
{
	if(IsPlayerNPC(playerid)) return 1;
	// if(GetPVarType(playerid, "pTut")) return 1;
	if(PlayerIsDead[playerid]) return 1;
	PlayerIsDead[playerid] = true;
	IsSpawned[playerid] = 0;
	SpawnKick[playerid] = 0;
	for(new x; x < MAX_PLAYERTOYS; x++)
	{
		if(IsPlayerAttachedObjectSlotUsed(playerid, x))
		{
			if(x == 9 && PlayerInfo[playerid][pBEquipped])
				break;
			RemovePlayerAttachedObject(playerid, x);
		}
	}
	for(new i; i < 10; i++) PlayerHoldingObject[playerid][i] = 0;
	SetPVarInt(playerid, "Health", 0);
	if(GetPVarInt(playerid, "HeroinDamageResist") == 1) HeroinEffectStanding(playerid), KillTimer(GetPVarInt(playerid, "HeroinEffectStanding"));
	if(IsPlayerConnected(playerid) && IsPlayerConnected(killerid))
	{
		if(gPlayerUsingLoopingAnim[playerid])
		{
			gPlayerUsingLoopingAnim[playerid] = 0;
			TextDrawHideForPlayer(playerid,txtAnimHelper);
		}

		SetPVarInt(playerid, "PlayerOwnASurf", 0);
		#if defined zombiemode
		if(zombieevent == 1 && GetPVarType(playerid, "pIsZombie"))
		{
			new string[128];
			format(string, sizeof(string), "INSERT INTO humankills (id, num, name) VALUES (%d,1, '%s') ON DUPLICATE KEY UPDATE num = num + 1", PlayerInfo[killerid][pId], GetPlayerNameEx(killerid));
			mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "ii", SENDDATA_THREAD, killerid);
		}

		if(zombieevent == 1 && GetPVarType(playerid, "pIsZombie"))
		{
			new Float:mX, Float:mY, Float:mZ;
			GetPlayerPos(playerid, mX, mY, mZ);

			SetPVarFloat(playerid, "MedicX", mX);
			SetPVarFloat(playerid, "MedicY", mY);
			SetPVarFloat(playerid, "MedicZ", mZ);
		}
		#endif

		if(SpoofKill[playerid] == 0)
			KillTime[playerid] = gettime();

		SpoofKill[playerid]++;


		if(SpoofKill[playerid] >= 4)
		{
			if((gettime() - KillTime[playerid]) <= 2)
			{
				CreateBan(INVALID_PLAYER_ID, PlayerInfo[playerid][pId], playerid, PlayerInfo[playerid][pIP], "Kill-spoofing", 180);
				TotalAutoBan++;
				Kick(playerid);
			}
			else
			{
				SpoofKill[playerid] = 0;
			}
		}

		RemoveArmor(playerid);

		PlayerInfo[playerid][pHolsteredWeapon] = 0;

		if (GetPVarInt(playerid, "_SwimmingActivity") >= 1)
		{
			DisablePlayerCheckpoint(playerid);
			DeletePVar(playerid, "_SwimmingActivity");
		}
		if (GetPVarInt(playerid, "_BoxingQueue") == 1)
		{
			DeletePVar(playerid, "_BoxingQueue");
		}
		if (GetPVarInt(playerid, "_BoxingFight") != 0)
		{
			new winner = GetPVarInt(playerid, "_BoxingFight") - 1;
			SendClientMessageEx(winner, COLOR_GREEN, "You have won the fight!");
			SendClientMessageEx(playerid, COLOR_RED, "You have lost the fight!");

			DeletePVar(winner, "_BoxingFight");
			DeletePVar(playerid, "_BoxingFight");

			new time = gettime();
			SetPVarInt(playerid, "_BoxingFightOver", time + 8);
			SetPVarInt(winner, "_BoxingFightOver", time + 1);
		}
		if(GetPVarInt(playerid, "_InJailBoxing") > 0)
		{
			new string[60 + MAX_PLAYER_NAME];

			if(killerid == GetPVarInt(playerid, "_JailBoxingChallenger"))
			{
				SendClientMessageEx(playerid, COLOR_WHITE, "You have lost the boxing fight. You may now leave the arena.");
				SendClientMessageEx(killerid, COLOR_WHITE, "You have won the boxing fight. You may now leave the arena.");

				format(string, sizeof(string), "** [Boxing News (Arena:%d)] %s has won! **", (GetPVarInt(playerid, "_InJailBoxing") - 1), GetPlayerNameEx(killerid));
				ProxDetector(10.0, playerid, string, 0xEB41000, 0xEB41000, 0xEB41000, 0xEB41000, 0xEB41000);

				arrJailBoxingData[GetPVarInt(playerid, "_InJailBoxing") - 1][bInProgress] = false;
				RemoveFromJailBoxing(playerid);
				RemoveFromJailBoxing(killerid);
			}
			else
			{
				arrJailBoxingData[GetPVarInt(playerid, "_InJailBoxing") - 1][bInProgress] = false;
				RemoveFromJailBoxing(playerid);
				RemoveFromJailBoxing(killerid);
			}
		}
		if(GetPVarInt(playerid, "_InJailBrawl") != 0)
		{
			if(killerid == GetPVarInt(playerid, "_InJailBrawl") - 1)
			{
				SendClientMessageEx(playerid, COLOR_WHITE, "You have lost the brawl.");
				SendClientMessageEx(killerid, COLOR_WHITE, "You have won the brawl.");
			}
			DeletePVar(playerid, "_InJailBrawl");
			DeletePVar(killerid, "_InJailBrawl");
			DeletePVar(GetPVarInt(playerid, "_InJailBrawl") - 1, "_InJailBrawl");
		}
		if (_vhudVisible[playerid] == 1)
		{
			HideVehicleHUDForPlayer(playerid); // incase vehicle despawns
		}
		if (CarRadars[playerid] > 0)
		{
			CarRadars[playerid] = 0;
			PlayerTextDrawHide(playerid, _crTextTarget[playerid]);
			PlayerTextDrawHide(playerid, _crTextSpeed[playerid]);
			PlayerTextDrawHide(playerid, _crTickets[playerid]);
			DeletePVar(playerid, "_lastTicketWarning");
		}
		if(GetPVarInt(playerid, "AttemptPurify"))
		{
			Purification[0] = 0;
			KillTimer(GetPVarInt(playerid, "AttemptPurify"));
		}
		if(GetPVarInt(playerid, "HeroinEffect"))
		{
			DeletePVar(playerid, "HeroinEffect");
			KillTimer(GetPVarInt(playerid, "HeroinEffect"));
		}
		if(GetPVarInt(playerid, "InjectHeroin"))
		{
			KillTimer(GetPVarInt(playerid, "InjectHeroin"));
		}
		new weaponname[32];
		GetWeaponName(reason, weaponname, sizeof(weaponname));

		new query[256];
		format(query, sizeof(query), "INSERT INTO `kills` (`id`, `killerid`, `killedid`, `date`, `weapon`) VALUES (NULL, %d, %d, NOW(), '%s')", GetPlayerSQLId(killerid), GetPlayerSQLId(playerid), weaponname);
		PlayerKills[killerid]++;
		mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);

		if(GetPVarType(killerid, "IsInArena")) PlayerInfo[killerid][pDMKills]++;
		if(GetPVarType(playerid, "FixVehicleTimer")) KillTimer(GetPVarInt(playerid, "FixVehicleTimer")), DeletePVar(playerid, "FixVehicleTimer");
	}

	TextDrawHideForPlayer(playerid, BFText);
	DeletePVar(playerid, "BlindFolded");
	pTazer{playerid} = 0;
	InsidePlane[playerid] = INVALID_VEHICLE_ID;
	DeletePVar(playerid, "SpeedRadar");
	DeletePVar(playerid, "UsingSprunk");
	KillTimer(GetPVarInt(playerid, "firstaid5"));
	DeletePVar(playerid, "usingfirstaid");
	if(GetPVarType(playerid, "MovingStretcher"))
	{
		KillTimer(GetPVarInt(playerid, "TickEMSMove"));
		DeletePVar(GetPVarInt(playerid, "MovingStretcher"), "OnStretcher");
		DeletePVar(playerid, "MovingStretcher");
	}
	if(GetPVarType(playerid, "DraggingPlayer"))
	{
		DeletePVar(GetPVarInt(playerid, "DraggingPlayer"), "BeingDragged");
		DeletePVar(playerid, "DraggingPlayer");
	}
	if(IsPlayerConnected(Mobile[playerid]))
	{
		new
			iCaller = Mobile[playerid],
			szMessage[64];

		SendClientMessageEx(iCaller, COLOR_GRAD2, "The line went dead.");
		format(szMessage, sizeof(szMessage), "* %s puts away their cellphone.", GetPlayerNameEx(iCaller));
		ProxDetector(30.0, iCaller, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		CellTime[iCaller] = 0;
		Mobile[iCaller] = INVALID_PLAYER_ID;
		RemovePlayerAttachedObject(Mobile[playerid], 8);
	}
	Mobile[playerid] = INVALID_PLAYER_ID;
	CellTime[playerid] = 0;
	RingTone[playerid] = 0;
	RemovePlayerAttachedObject(playerid, 8);

	if(GetPVarType(playerid, "SpecOff"))
	{
		SpawnPlayer(playerid);
		return 1;
	}

	if(GetPVarInt(playerid, "Injured") == 1)
	{
		foreach(new i: Player)
		{
			if(EMSAccepted[i] == playerid)
			{
				EMSAccepted[i] = INVALID_PLAYER_ID;
				GameTextForPlayer(i, "~w~EMS Caller~n~~r~Has Died", 5000, 1);
				EMSCallTime[i] = 0;
				DisablePlayerCheckpoint(i);
			}
		}
		SendClientMessageEx(playerid, COLOR_WHITE, "You appear to be stuck in limbo, medics are trying to revive you.");
		KillEMSQueue(playerid);
		ResetPlayerWeaponsEx(playerid);
		return 1;
	}

	if(GetPVarInt(playerid, "EventToken") == 0)
	{
		if(!GetPVarType(playerid, "IsInArena"))
		{
			if(HungerPlayerInfo[playerid][hgInEvent] != 1)
			{
				SetPVarInt(playerid, "Injured", 1);
				SetPVarInt(playerid, "InjuredWait", gettime()+5);

				new Float:mX, Float:mY, Float:mZ;
				GetPlayerPos(playerid, mX, mY, mZ);

				SetPVarFloat(playerid, "MedicX", mX);
				SetPVarFloat(playerid, "MedicY", mY);
				SetPVarFloat(playerid, "MedicZ", mZ);
				SetPVarInt(playerid, "MedicVW", GetPlayerVirtualWorld(playerid));
				SetPVarInt(playerid, "MedicInt", GetPlayerInterior(playerid));

			}
		}
	}

	if(GetPVarType(playerid, "IsInArena"))
	{
		new
			iPlayer = GetPVarInt(playerid, "IsInArena"),
			iKiller = GetPVarInt(killerid, "IsInArena"),
			szMessage[96];

		if(GetPVarInt(playerid, "AOSlotPaintballFlag") != -1)
		{
			switch(PlayerInfo[playerid][pPaintTeam])
			{
				case 1:
				{
					DropFlagPaintballArena(playerid, iPlayer, 2);
				}
				case 2:
				{
					DropFlagPaintballArena(playerid, iPlayer, 1);
				}
			}
		}
		if(reason >= 0 && reason <= 46)
		{
			new weapon[24];
			++PlayerInfo[killerid][pKills];
			++PlayerInfo[playerid][pDeaths];
			if(PlayerInfo[killerid][pPaintTeam] == 1)
			{
				if(PlayerInfo[killerid][pPaintTeam] == PlayerInfo[playerid][pPaintTeam])
				{
					--PaintBallArena[iKiller][pbTeamRedKills];
					++PaintBallArena[iPlayer][pbTeamBlueKills];
					SetHealth(killerid, 0);
					PlayerInfo[killerid][pKills] -= 2;
					++PlayerInfo[killerid][pDeaths];
					--PlayerInfo[playerid][pDeaths];
					SendClientMessageEx(killerid, COLOR_WHITE, "You have been warned, do not team-kill!");
				}
				else
				{
					++PaintBallArena[iKiller][pbTeamRedKills];
					++PaintBallArena[iPlayer][pbTeamBlueDeaths];
				}
			}
			if(PlayerInfo[killerid][pPaintTeam] == 2)
			{
				if(PlayerInfo[killerid][pPaintTeam] == PlayerInfo[playerid][pPaintTeam])
				{
					--PaintBallArena[iKiller][pbTeamBlueKills];
					++PaintBallArena[iPlayer][pbTeamRedKills];
					SetHealth(killerid, 0);
					PlayerInfo[killerid][pKills] -= 2;
					++PlayerInfo[killerid][pDeaths];
					--PlayerInfo[playerid][pDeaths];
					SendClientMessageEx(killerid, COLOR_WHITE, "You have been warned, do not team-kill!");
				}
				++PaintBallArena[iKiller][pbTeamBlueKills];
				++PaintBallArena[iPlayer][pbTeamRedDeaths];
			}
			GetWeaponName(reason,weapon,sizeof(weapon));
			if(PaintBallArena[iKiller][pbTimeLeft] < 12)
			{
				GivePlayerCash(killerid, 1000);
				format(szMessage,sizeof(szMessage),"[Paintball Arena] %s has earned $1000 bonus for a sudden death kill!",GetPlayerNameEx(killerid));
				SendPaintballArenaMessage(iKiller, COLOR_YELLOW, szMessage);
				////SendAudioToPlayer(killerid, 19, 100);
			}
			if(reason == 0) format(szMessage,sizeof(szMessage),"[Paintball Arena] %s has killed %s with their bare hands!",GetPlayerNameEx(killerid),GetPlayerNameEx(playerid));
			else format(szMessage,sizeof(szMessage),"[Paintball Arena] %s has killed %s with a %s.",GetPlayerNameEx(killerid),GetPlayerNameEx(playerid),weapon);
		}
		else
		{
			++PlayerInfo[playerid][pDeaths];
			format(szMessage,sizeof(szMessage),"[Paintball Arena] %s has died.",GetPlayerNameEx(playerid));
		}
		SendPaintballArenaMessage(iPlayer, COLOR_RED, szMessage);
	}

	if(GetPVarInt(playerid, "Injured") == 0)
	{
		new arenaid = GetPVarInt(playerid, "IsInArena");
		if(GetPVarInt(playerid, "EventToken") >= 1 || (arenaid >= 0 && (PaintBallArena[arenaid][pbGameType] < 4 || PaintBallArena[arenaid][pbGameType] > 5)))
		{
			DisablePlayerCheckpoint(playerid);
			ResetPlayerWeapons(playerid);
		}
		else
		{
			ResetPlayerWeaponsEx(playerid);
		}
	}
	if(IsPlayerConnected(killerid) && PlayerInfo[killerid][pAdmin] < 2 && GetPlayerState(killerid) == PLAYER_STATE_DRIVER)
	{
		switch(reason)
		{
			case 49: {
				new szMessage[128];
				format(szMessage, sizeof(szMessage), "{AA3333}AdmWarning{FFFF00}: %s (ID %d) has possibly just car-rammed %s (ID %d) to death.", GetPlayerNameEx(killerid), killerid, GetPlayerNameEx(playerid), playerid);
				ABroadCast(COLOR_YELLOW, szMessage, 2);
			}
			case 50: if(IsAHelicopter(GetPlayerVehicleID(killerid))) {
				new szMessage[128];
				format(szMessage, sizeof(szMessage), "{AA3333}AdmWarning{FFFF00}: %s (ID %d) has possibly just blade-killed %s (ID %d).", GetPlayerNameEx(killerid), killerid, GetPlayerNameEx(playerid), playerid);
				ABroadCast(COLOR_YELLOW, szMessage, 2);
			}
			default: switch(GetPlayerWeapon(killerid)) {
				case 32, 28, 29: {
					new szMessage[128];
					format(szMessage, sizeof(szMessage), "{AA3333}AdmWarning{FFFF00}: %s (ID %d) has possibly just driver-shot %s (ID %d) to death.", GetPlayerNameEx(killerid), killerid, GetPlayerNameEx(playerid), playerid);
					ABroadCast(COLOR_YELLOW, szMessage, 2);
				}
			}
		}
	}

	if (gPlayerCheckpointStatus[playerid] > 4 && gPlayerCheckpointStatus[playerid] < 11)
	{
		DisablePlayerCheckpoint(playerid);
		gPlayerCheckpointStatus[playerid] = CHECKPOINT_NONE;
	}

	if(IsPlayerConnected(killerid))
	{
		if(PlayerInfo[playerid][pHeadValue] >= 1)
		{
			if(GoChase[killerid] == playerid) // && GetPVarInt(killerid, "HitCooldown") <= 0)
			{
				new szMessage[86 + MAX_PLAYER_NAME];
				new takemoney = PlayerInfo[playerid][pHeadValue];//floatround((PlayerInfo[playerid][pHeadValue] / 4) * 2);
				GivePlayerCash(killerid, floatround(takemoney * 0.9));
				GivePlayerCash(playerid, -takemoney);
				format(szMessage, sizeof(szMessage),"Hitman %s has fulfilled the contract on %s and collected $%d.",GetPlayerNameEx(killerid),GetPlayerNameEx(playerid),takemoney);
				foreach(new i: Player) if(IsAHitmanLeader(i)) SendClientMessage(i, COLOR_YELLOW, szMessage);
				format(szMessage, sizeof szMessage, "You have completed the hit on %s and collected $%s", GetPlayerNameEx(playerid), number_format(takemoney));
				SendClientMessage(killerid, COLOR_YELLOW, szMessage);
				format(szMessage, sizeof(szMessage),"You have been critically injured by a hitman and lost $%d.",takemoney);
				PlayerInfo[playerid][pContractDetail][0] = 0;
				ResetPlayerWeaponsEx(playerid);
				SendClientMessageEx(playerid, COLOR_YELLOW, szMessage);
				PlayerInfo[playerid][pHeadValue] = 0;
				PlayerInfo[killerid][pCHits] += 1;
				GotHit[playerid] = 0;
				GetChased[playerid] = INVALID_PLAYER_ID;
				GoChase[killerid] = INVALID_PLAYER_ID;

				new weaponname[32];
				GetWeaponName(reason, weaponname, sizeof(weaponname));
				new iHitPercent = floatround(takemoney * 0.10);
				iHMASafe_Val += iHitPercent;
				format(szMiscArray, sizeof szMiscArray, "[hit] %s (%d) has killed %s (%d) [%s] for $%s ($%s deposited to safe).", GetPlayerNameEx(killerid), GetPlayerSQLId(killerid), GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), weaponname, number_format(takemoney), number_format(iHitPercent));
				Log("logs/hitman.log", szMiscArray);
			}
		}
		if(GoChase[playerid] == killerid)
		{
			new szMessage[86 + MAX_PLAYER_NAME];
			new takemoney = PlayerInfo[killerid][pHeadValue]; //floatround((PlayerInfo[killerid][pHeadValue] / 4) * 2);
			GivePlayerCash(killerid, takemoney);
			format(szMessage, sizeof(szMessage),"Hitman %s has failed the contract on %s and lost $%s.", GetPlayerNameEx(playerid), GetPlayerNameEx(killerid), number_format(takemoney));
			foreach(new i: Player) if(IsAHitmanLeader(i)) SendClientMessage(i, COLOR_HMARADIO, szMessage);
			GivePlayerCash(playerid, -takemoney);
			format(szMessage, sizeof(szMessage),"You have just killed a hitman and gained $%s, removing the contract on your head.", number_format(takemoney));
			PlayerInfo[killerid][pContractDetail][0] = 0;
			SendClientMessageEx(killerid, COLOR_YELLOW, szMessage);
			format(szMessage, sizeof szMessage, "You have failed the contract on %s and lost $%s.", GetPlayerNameEx(killerid), number_format(takemoney));
			SendClientMessage(playerid, COLOR_YELLOW, szMessage);
			PlayerInfo[killerid][pHeadValue] = 0;
			PlayerInfo[playerid][pFHits] += 1;
			GotHit[playerid] = 0;
			GetChased[killerid] = INVALID_PLAYER_ID;
			GoChase[playerid] = INVALID_PLAYER_ID;

			new weaponname[32], iGroupID = PlayerInfo[killerid][pMember];
			GetWeaponName(reason, weaponname, sizeof(weaponname));
			format(szMessage, sizeof szMessage, "[HMA] %s (%d) has has failed to kill %s (%d) with a %s.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerNameEx(killerid), GetPlayerSQLId(killerid), weaponname);
			GroupLog(iGroupID, szMessage);
		}
	}
	SetPlayerColor(playerid,TEAM_HIT_COLOR);
	if(IsValidDynamic3DTextLabel(RFLTeamN3D[playerid])) {

		#if defined TEXTLABEL_DEBUG
		Streamer_SetIntData(STREAMER_TYPE_3D_TEXT_LABEL, RFLTeamN3D[playerid], E_STREAMER_EXTRA_ID, 5);
		#endif

		DestroyDynamic3DTextLabel(RFLTeamN3D[playerid]);
		RFLTeamN3D[playerid] = Text3D:-1;
	}
	if(PlayerTied[playerid]) {
		DeletePVar(playerid, "IsFrozen");
		TogglePlayerControllable(playerid, 1);
		PlayerTied[playerid] = 0;
	}
	// SetPVarInt(playerid, "MedicAid", 1);
	return 1;
}
