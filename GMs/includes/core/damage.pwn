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
#include <YSI\y_hooks>
/*
static Float:WeaponRange[] = {

	10.0, // 0 - Fist
	10.0, // 1 - Brass knuckles
	10.0, // 2 - Golf club
	10.0, // 3 - Nitestick
	10.0, // 4 - Knife
	10.0, // 5 - Bat
	10.0, // 6 - Shovel
	10.0, // 7 - Pool cue
	10.0, // 8 - Katana
	10.0, // 9 - Chainsaw
	10.0, // 10 - Dildo
	10.0, // 11 - Dildo 2
	10.0, // 12 - Vibrator
	10.0, // 13 - Vibrator 2
	10.0, // 14 - Flowers
	10.0, // 15 - Cane
	40.0, // 16 - Grenade
	40.0, // 17 - Teargas
	40.0, // 18 - Molotov
	90.0, // 19 - Vehicle M4 (custom)
	75.0, // 20 - Vehicle minigun (custom)
	0.0, // 21
	35.0, // 22 - Colt 45
	35.0, // 23 - Silenced
	35.0, // 24 - Deagle
	40.0, // 25 - Shotgun
	35.0, // 26 - Sawed-off
	40.0, // 27 - Spas
	35.0, // 28 - UZI
	45.0, // 29 - MP5
	70.0, // 30 - AK47
	90.0, // 31 - M4
	35.0, // 32 - Tec9
	100.0, // 33 - Cuntgun
	320.0, // 34 - Sniper
	55.0, // 35 - Rocket launcher
	55.0, // 36 - Heatseeker
	5.1, // 37 - Flamethrower
	75.0  // 38 - Minigun
};*/


new HitStatus[MAX_PLAYERS];

hook OnPlayerConnect(playerid) {
	HitStatus[playerid] = 0;
	return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
	if((newkeys & KEY_SPRINT) || (newkeys & KEY_SECONDARY_ATTACK)) {
		if(IsDoingAnim[playerid]) ClearAnimationsEx(playerid);
	}
	return 1;
}

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ) {
	new string[128];
	//SendClientMessageEx(playerid, COLOR_WHITE, "Weapon %i fired. hittype: %i   hitid: %i   pos: %f, %f, %f", weaponid, hittype, hitid, fX, fY, fZ);
	if(GhostHacker[playerid][5] < gettime()) {
		GhostHacker[playerid][3] = 0;
		GhostHacker[playerid][5] = gettime()+9;
	}
    if(playerid != INVALID_PLAYER_ID) {
    	if(GetPVarInt(playerid, "EventToken") == 0 && !GetPVarType(playerid, "IsInArena")) {
		    if(weaponid > 0 && GetPlayerWeapon(playerid) == weaponid) {
				if(PlayerInfo[playerid][pGuns][GetWeaponSlot(weaponid)] != weaponid) {
					ExecuteHackerAction(playerid, weaponid);
					RemovePlayerWeapon(playerid, weaponid);
					return 0;
				}
			}
		}
		if(hittype == BULLET_HIT_TYPE_PLAYER) {
			if(hitid != INVALID_PLAYER_ID) {
				if(weaponid != 9 || weaponid != 37 || weaponid != 38 || weaponid != 41 || weaponid != 42) {
					//if(GetPVarInt(playerid, "EventToken") == 0 && !GetPVarType(playerid, "IsInArena")) {
						GhostHacker[playerid][2]++;
						if(!GhostHacker[playerid][4]) {
							GhostHacker[playerid][4] = 1;
							SetTimerEx("CheckBulletAmount", 1000, 0, "ii", playerid);
						}
					//}
				}
			}
		}
		if(weaponid == WEAPON_SILENCED && pTazer{playerid} == 1) {
			new iShots = GetPVarInt(playerid, "TazerShots");

			if(iShots > 0) {
				SetPVarInt(playerid, "TazerShots", iShots - 1);
			}
			if(iShots < 1) {
				TazerTimeout[playerid] = 12;
				SetTimerEx("TazerTimer",1000,false,"d",playerid);
				SendClientMessageEx(playerid, COLOR_WHITE, "Your tazer is recharging!");
				
				RemovePlayerWeapon(playerid, 23);
				GivePlayerValidWeapon(playerid, pTazerReplace{playerid});
				format(szMiscArray, sizeof(szMiscArray), "* %s holsters their tazer.", GetPlayerNameEx(playerid));
				ProxDetector(4.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				pTazer{playerid} = 0;
			}
		}
	}
/*
	if(GetPVarInt(playerid, "FireStart") == 1) {
		if(fX != 0 && fY != 0 && hittype != BULLET_HIT_TYPE_PLAYER && hittype != BULLET_HIT_TYPE_VEHICLE) {
			if(gettime() > GetPVarInt(playerid, "fCooldown")) CreateStructureFire(fX, fY, fZ, GetPlayerVirtualWorld(playerid));
		}
	}
*/
 	if(hittype != BULLET_HIT_TYPE_NONE ) // Bullet Crashing uses just this hittype
    {
        if(!(-1000.0 <= fX <= 1000.0) || !(-1000.0 <= fY <= 1000.0) || !(-1000.0 <= fZ <= 1000.0)) // a valid offset, it's impossible that a offset bigger than 1000 is legit (also less than -1000.0 is impossible, not used by this hack, but still, let's check for it, just for the future, who knows what hacks will appear). The object with biggest offset is having ~700-800 radius.
        {
			format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s was kicked for a possiable invalid hit type!", GetPlayerNameEx(playerid));
			ABroadCast(COLOR_YELLOW, string, 2);
            Kick(playerid);
            Log("logs/bulletcrasher.log", string);
            return 0; // let's desynchronize that bullet, so players won't crash
        }
    }
	return 1;
}

forward CheckBulletAmount(playerid);
public CheckBulletAmount(playerid) {
	new szMessage[128];
	if(GhostHacker[playerid][2] > 8) {
		if(++GhostHacker[playerid][3] > 2) {
			format(szMessage, sizeof(szMessage), "{AA3333}AdmWarning{FFFF00}: %s (ID %d) may possibly be using aim assist.", GetPlayerNameEx(playerid), playerid);
			ABroadCast(COLOR_YELLOW, szMessage, 2);
		}
	}
	GhostHacker[playerid][2] = 0;
	GhostHacker[playerid][4] = 0;
	return 1;
}

// Required as aiming with a single weapon wont update the anim index so we need to force clear.
stock IsAimingColt(playerid) {

	if(GetPlayerCameraMode(playerid) == 53) {
		if(GetPlayerWeapon(playerid) == 22 || GetPlayerWeapon(playerid) == 26 || GetPlayerWeapon(playerid) == 28 || GetPlayerWeapon(playerid) == 32) {
			return 1;
		}
	}
	return 0;
}

stock IsInvalidGunAnim(playerid)
{
	switch(GetPlayerAnimationIndex(playerid))
	{
		case
			320,
			471,
			1164,
			1183,
			1188,
			1189, // PED: IDLE_STANCE
			1196, // PED: JUMP_LAND
			1198, // PED: JUMP_LAUNCH_R
			1223, // PED: RUN_ARMED
			1231, // PED: RUN_PLAYER
			1197, // PED: JUMP_LAUNCH
			1195, // PED: JUMP_GLIDE
			1266, // PED: WALK_PLAYER
			1246, // PED: SPRINT_CIVI
			1066, // PED: PED CLIMB_STAND
			1067, // PED: CLIMB_STAND_FINISH
			224, // BUDDY: BUDDY_RELOAD
			1234, // PED: RUN_STOP
			1132, // PED: FALL_GLIDE
			1133, // PED: FALL_LAND
			1130, // PED: FALL_FALL
			1129, // PED: PED FALL_COLLAPSE
			1207, // PED: KO_SHOT_STOM
			1274, // PED: WEAPON_CROUCH
			1235, // PED: RUN_STOPR
			1233, // PED: RUN_ROCKET
			1225, // PED: RUN_CSAW
			1062, // PED: CLIMB_JUMP
			1065, // PED: CLIMB_PULL
			1159, // PED: GUNCROUCHFWD
			1269, // PED: WALK_START
			1180, // PED: HIT_WALL
			1069, // PED: CROUCH_ROLL_L
			1070: // PED: CROUCH_ROLL_R
			return 1;
	}
	return 0;
}


public OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid, bodypart)
{
	szMiscArray[0] = 0;
	if(gPlayerLogged{playerid} == 0) {
		format(szMiscArray, sizeof(szMiscArray), "%s(%d) [%s] has moved from the login screen position.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid));
		Log("logs/security.log", szMiscArray);
		SendClientMessage(playerid, COLOR_WHITE, "SERVER: You attempted to deal damage to someone when not logged in.");
		SetTimerEx("KickEx", 1000, 0, "i", playerid);
		return 1;
	}
	if((0 <= bodypart < 2)) return 1;
	if(IsAimingColt(playerid) && IsInvalidGunAnim(playerid)) {
		ClearAnimations(playerid, 1);
		return 1;
	}
	/*
    new animlib[32];
    new animname[32];
    GetAnimationName(GetPlayerAnimationIndex(playerid),animlib,32,animname,32);
    if(!IsInvalidGunAnim(playerid)) SendClientMessageEx(playerid, COLOR_WHITE, "Anim: %d | Name: %s %s", GetPlayerAnimationIndex(playerid), animlib, animname);*/
	if(PlayerIsDead[damagedid]) return 1;
	//if(!HitStatus[damagedid]) return 1;
	new Float:realdam = amount;
	if(damagedid != INVALID_PLAYER_ID && playerid != INVALID_PLAYER_ID) {
		if(GhostHacker[playerid][0] > 0 && GhostHacker[playerid][6] < gettime()) GhostHacker[playerid][6] = gettime()+6, GhostHacker[playerid][0] = 0;
		if(IsPlayerPaused(playerid) || IsDoingAnim[playerid] || IsInvalidGunAnim(playerid)) {
			if(GhostHacker[playerid][1] < gettime()) {
				if(++GhostHacker[playerid][0] > 1) {
					format(szMiscArray, sizeof(szMiscArray), "{AA3333}AdmWarning{FFFF00}: %s may possibly be Ghost Hacking, damage was denied.", GetPlayerNameEx(playerid));
					ABroadCast(COLOR_YELLOW, szMiscArray, 2);
					GhostHacker[playerid][1] = gettime()+3;
					format(szMiscArray, sizeof(szMiscArray), "%s may possibly be Ghost Hacking.", GetPlayerNameEx(playerid));
					Log("logs/hack.log", szMiscArray);
				}
			}
			foreach(Player, i)
			{
				if(IsPlayerConnected(i))
				{
					if(PlayerInfo[i][pAdmin] >= 2 && GetPVarType(i, "_dCheck") && GetPVarInt(i, "_dCheck") == playerid) {
						format(szMiscArray, sizeof(szMiscArray), "[Dmgcheck] %s: Dmgd: %s (%d) | Wp: %s | CSDmg: %.2f | SSDmg: Denied | %s (GIVE)", GetPlayerNameEx(playerid), GetPlayerNameEx(damagedid), damagedid, GetWeaponNameEx(weaponid), amount, ReturnBoneName(bodypart));
						SendClientMessageEx(i, COLOR_WHITE, szMiscArray);
					}
				}
			}
			return 1;
		}
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
		/*if(weaponid == WEAPON_SNIPER)
		{
			amount *= 1.30;
		}*/
		//heroin damage reduction
		if (GetPVarInt(damagedid, "HeroinDamageResist") == 1) {
			amount *= 0.45;
		}

		new Float:difference,
			Float:health,
			Float:armour;
		GetHealth(damagedid, health);
		GetArmour(damagedid, armour);

		// Ignore godmode. - Admins / Advisors (for health only)
		if(!GetPVarInt(damagedid, "pGodMode") && !GetPVarInt(damagedid, "eventStaff")) {
			if(health < 0.1) SetHealth(damagedid, 0.1), GetHealth(damagedid, health); // just set to this as they'll be killed either way.
			if(health > 150.0) SetHealth(damagedid, 150.0), GetHealth(damagedid, health);
			if(armour < 0.0) SetArmour(damagedid, 0.0), GetArmour(damagedid, armour);
			if(armour > 150.0) SetArmour(damagedid, 150.0), GetArmour(damagedid, armour);
		}

		if(!IsPlayerStreamedIn(playerid, damagedid) || !IsPlayerStreamedIn(damagedid, playerid)) return 1;
		/*
		new Float:fOriginX, Float:fOriginY, Float:fOriginZ, Float:fHitPosX, Float:fHitPosY, Float:fHitPosZ,
			Float:x, Float:y, Float:z;

		GetPlayerPos(playerid, x, y, z);
		GetPlayerLastShotVectors(playerid, fOriginX, fOriginY, fOriginZ, fHitPosX, fHitPosY, fHitPosZ);

		new Float:fDistance = VectorSize(fOriginX - fHitPosX, fOriginY - fHitPosY, fOriginZ - fHitPosZ),
			Float:origin_dist = VectorSize(fOriginX - x, fOriginY - y, fOriginZ - z);

		if(origin_dist > 15.0) {
			new iVehCheck = IsPlayerInAnyVehicle(damagedid) || GetPlayerSurfingVehicleID(playerid);
			if((!iVehCheck && GetPlayerSurfingVehicleID(playerid) == INVALID_VEHICLE_ID) || origin_dist > 50.0) {
				return 1;
			}
		}
		if(fDistance > WeaponRange[weaponid]) return 1;
		new Float:fHitDist = GetPlayerDistanceFromPoint(damagedid, fHitPosX, fHitPosY, fHitPosZ),
		iVehCheck = IsPlayerInAnyVehicle(damagedid);
		if ((!iVehCheck && fHitDist > 20.0) || fHitDist > 50.0) return 1;*/

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
				ClearAnimationsEx(damagedid);
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
				if((PlayerInfo[damagedid][pAdmin] >= 2 || PlayerInfo[damagedid][pWatchdog] >= 2) && PlayerInfo[damagedid][pTogReports] != 1) return SendClientMessageEx(playerid, COLOR_GRAD2, "Admins can not be bagged!");
				if(HelpingNewbie[damagedid] != INVALID_PLAYER_ID) return SendClientMessageEx(playerid, COLOR_GRAD2, "You cannot bag an advisor while they are helping someone.");
				if(PlayerInfo[damagedid][pHospital] == 1) return SendClientMessageEx(playerid, COLOR_GRAD2, "Players in hospital cannot be bagged!");
				new Float:fHealth, Float:fArmour;

				GetHealth(damagedid, fHealth);
				GetArmour(damagedid, fArmour);
				SetHealth(damagedid, fHealth);
				SetArmour(damagedid, fArmour);
				ClearAnimationsEx(damagedid);
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
	if((0 <= bodypart < 2)) return 1;
	if(PlayerIsDead[playerid]) return 1;
	new Float:realdam = amount;
	if(playerid != 65535) 
	{
	    if(amount < 0.0) amount = 0.0;
	    if(amount > 150.0) amount = 150.0;

		switch(weaponid)
		{
			// Take into account drug effects (needs to be 150 for fall damage etc..)
			case 50: { ClearAnimationsEx(playerid); if(amount > 150.0) amount = 150.0; }
			case 41: amount = 0.0;
			default: if(amount > 150.0) amount = 150.0;
		}

		//heroin damage reduction
		if (GetPVarInt(playerid, "HeroinDamageResist") == 1) {
			amount *= 0.45;
		}

		new Float:difference,
			Float:health,
			Float:armour;
		GetHealth(playerid, health);
		GetArmour(playerid, armour);

		// Ignore godmode. - Admins / Advisors (for health only)
		if(!GetPVarInt(playerid, "pGodMode") && !GetPVarInt(playerid, "eventStaff")) {
			if(health < 0.1) SetHealth(playerid, 0.1), GetHealth(playerid, health);
			if(health > 150.0) SetHealth(playerid, 150.0), GetHealth(playerid, health);
			if(armour < 0.0) SetArmour(playerid, 0.0), GetArmour(playerid, armour);
			if(armour > 150.0) SetArmour(playerid, 150.0), GetArmour(playerid, armour);
		}

		if(PlayerInfo[playerid][pHospital] == 1) return 1;
		if(GetPVarInt(playerid, "PlayerCuffed") == 1) return 1;

		if(weaponid == WEAPON_COLLISION && (1061 <= GetPlayerAnimationIndex(playerid) <= 1067)) // Climb Bug
		{
			new Float:hp;
			ClearAnimationsEx(playerid);
			GetHealth(playerid, hp);
			SetHealth(playerid, hp);
			return 1;
		}
		if(issuerid != 65535) {
			if(IsPlayerPaused(issuerid)) return 1;
			/*
			if(GhostHacker[issuerid][0] > 0 && GhostHacker[issuerid][6] < gettime()) GhostHacker[issuerid][6] = gettime()+6, GhostHacker[issuerid][0] = 0;
			if(IsPlayerPaused(issuerid) || IsDoingAnim[issuerid] || IsInvalidGunAnim(issuerid)) {
				if(GhostHacker[issuerid][1] < gettime()) {
					if(++GhostHacker[issuerid][0] > 1) {
						format(szMiscArray, sizeof(szMiscArray), "{AA3333}AdmWarning{FFFF00}: %s may possibly be Ghost Hacking, damage was denied.", GetPlayerNameEx(issuerid));
						ABroadCast(COLOR_YELLOW, szMiscArray, 2);
						GhostHacker[issuerid][1] = gettime()+3;
						format(szMiscArray, sizeof(szMiscArray), "%s may possibly be Ghost Hacking.", GetPlayerNameEx(issuerid));
						Log("logs/hack.log", szMiscArray);
					}
				}
				foreach(Player, i)
				{
					if(IsPlayerConnected(i))
					{
						if(PlayerInfo[i][pAdmin] >= 2 && GetPVarType(i, "_dCheck") && GetPVarInt(i, "_dCheck") == playerid) {
							format(szMiscArray, sizeof(szMiscArray), "[Dmgcheck] %s: Issuer: %s (%d) | Wp: %s (%d) | CSDmg: %.2f | SSDmg: Denied | %s (TAKE)", GetPlayerNameEx(playerid), GetPlayerNameEx(issuerid), issuerid, GetWeaponNameEx(weaponid), weaponid, amount, ReturnBoneName(bodypart));
							SendClientMessageEx(i, COLOR_WHITE, szMiscArray);
						}
					}
				}
				return 1;
			}*/
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
				ClearAnimationsEx(playerid, 1);
			}
			if(GetPVarType(playerid, "AttemptingCrackTrunk")) {
				DeletePVar(playerid, "AttemptingCrackTrunk");
				DeletePVar(playerid, "CrackTrunkCountdown");
				DestroyVLPTextDraws(playerid);
				ClearAnimationsEx(playerid, 1);
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
		if(issuerid != 65535 && (weaponid == 51 || weaponid == 38 || weaponid == 47 || weaponid == 37 || weaponid == 49 || GetVehicleModel(GetPlayerVehicleID(issuerid)) == 447 && weaponid == 31)) {
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
			mysql_format(MainPipeline, string, sizeof(string), "INSERT INTO humankills (id, num, name) VALUES (%d,1, '%s') ON DUPLICATE KEY UPDATE num = num + 1", PlayerInfo[killerid][pId], GetPlayerNameEx(killerid));
			mysql_tquery(MainPipeline, string, "OnQueryFinish", "ii", SENDDATA_THREAD, killerid);
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
		mysql_format(MainPipeline, query, sizeof(query), "INSERT INTO `kills` (`id`, `killerid`, `killedid`, `date`, `weapon`) VALUES (NULL, %d, %d, NOW(), '%e')", GetPlayerSQLId(killerid), GetPlayerSQLId(playerid), weaponname);
		PlayerKills[killerid]++;
		mysql_tquery(MainPipeline, query, "OnQueryFinish", "i", SENDDATA_THREAD);

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
				foreach(new i: Player) if(IsAHitman(i)) SendClientMessage(i, COLOR_YELLOW, szMessage);
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
			foreach(new i: Player) if(IsAHitman(i)) SendClientMessage(i, COLOR_YELLOW, szMessage);
			GivePlayerCash(playerid, -takemoney);
			format(szMessage, sizeof(szMessage),"You have just killed a hitman and gained $%s, removing the contract on your head.", number_format(takemoney));
			PlayerInfo[killerid][pContractDetail][0] = 0;
			SendClientMessageEx(killerid, COLOR_YELLOW, szMessage);
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