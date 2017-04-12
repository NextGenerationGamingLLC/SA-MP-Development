/* Anti-Cheat v2.0

	Slice (weapon-config.inc data from weapons.dat)
	Jingles (modified and added custom checks)
*/

// add autocbug

#include <YSI\y_hooks>

new PLoss; // Temp. var to toggle packet loss function.

// From 3DTryg Funcs By AbyssMorgan (http://forum.sa-mp.com/showthread.php?t=591010)
#define GetRotationFor2Point2D(%0,%1,%2,%3,%4)			(CompRotationFloat((atan2((%3)-(%1),(%2)-(%0))-90.0),(%4)))
#define GetDistanceBetweenPoints3D(%1,%2,%3,%4,%5,%6)	VectorSize((%1)-(%4),(%2)-(%5),(%3)-(%6))

stock Float:CompRotationFloat(Float:rotation,&Float:crotation=0.0){
	crotation = rotation;
	while(crotation < 0.0) crotation += 360.0;
	while(crotation >= 360.0) crotation -= 360.0;
	return crotation;
}

//new code version support 3D made by Abyss Morgan
stock bool:GetRotationFor2Point3D(Float:x,Float:y,Float:z,Float:tx,Float:ty,Float:tz,&Float:rx,&Float:rz){
	new Float:radius = GetDistanceBetweenPoints3D(x,y,z,tx,ty,tz);
	if(radius <= 0.0) return false;
	CompRotationFloat(-(acos((tz-z)/radius)-90.0),rx);
	CompRotationFloat((atan2(ty-y,tx-x)-90.0),rz);
	return true;`
}

// Made by Fusez
stock Float:GetPlayerPacketloss(playerid) {

	if(PLoss == 1) return 0.0;
	if(!IsPlayerConnected(playerid)) return 0.0;

	new nstats[400+1], nstats_loss[20], start, end;
	GetPlayerNetworkStats(playerid, nstats, sizeof(nstats));

	start = strfind(nstats,"packetloss",true);
	end = strfind(nstats,"%",true,start);

	strmid(nstats_loss, nstats, start+12, end, sizeof(nstats_loss));
	return floatstr(nstats_loss);
}

enum E_SHOT_INFO {
	acl_Tick,
	acl_Weapon,
	acl_HitType,
	acl_HitId,
	acl_Hits,
	Float:acl_fPos[3],
	Float:acl_fTargetPos[3],
	Float:acl_fOrigin[3],
	Float:acl_fHitPos[3],
	Float:acl_fDistance,
	bool:acl_Valid,
}

static ac_LastUpdate[MAX_PLAYERS] = {-1, ...};
static ac_RejectedHitsIdx[MAX_PLAYERS];
static ac_iCBugFreeze[MAX_PLAYERS];
static arrLastBulletData[MAX_PLAYERS][E_SHOT_INFO];
static ac_LastBulletIdx[MAX_PLAYERS];
static ac_LastBulletTicks[MAX_PLAYERS][10];
static ac_LastBulletWeapons[MAX_PLAYERS][10];
static ac_LastExplosive[MAX_PLAYERS];
static ac_LastHitTicks[MAX_PLAYERS][10];
static ac_LastHitWeapons[MAX_PLAYERS][10];
static ac_LastHitIdx[MAX_PLAYERS];
static Float:ac_PlayerMaxHealth[MAX_PLAYERS] = {100.0, ...};


// Max continuous shots.
static ac_MaxWeaponContShots[] = {

	0, // 0 - Fist
	0, // 1 - Brass knuckles
	0, // 2 - Golf club
	0, // 3 - Nitestick
	0, // 4 - Knife
	0, // 5 - Bat
	0, // 6 - Shovel
	0, // 7 - Pool cue
	0, // 8 - Katana
	0, // 9 - Chainsaw
	0, // 10 - Dildo
	0, // 11 - Dildo 2
	0, // 12 - Vibrator
	0, // 13 - Vibrator 2
	0, // 14 - Flowers
	0, // 15 - Cane
	0, // 16 - Grenade
	0, // 17 - Teargas
	0, // 18 - Molotov
	0, // 19 - Vehicle M4 (custom)
	0, // 20 - Vehicle minigun (custom)
	0, // 21
	10, // 22 - Colt 45
	10, // 23 - Silenced
	10, // 24 - Deagle
	10, // 25 - Shotgun
	20, // 26 - Sawed-off
	20, // 27 - Spas
	30, // 28 - UZI
	30, // 29 - MP5
	30, // 30 - AK47
	30, // 31 - M4
	30, // 32 - Tec9
	10, // 33 - Cuntgun
	10, // 34 - Sniper
	0, // 35 - Rocket launcher
	0, // 36 - Heatseeker
	0, // 37 - Flamethrower
	400, // 38 - Minigun
	0, // 39 - Satchel
	0, // 40 - Detonator
	0, // 41 - Spraycan
	0, // 42 - Fire extinguisher
	0, // 43 - Camera
	0, // 44 - Night vision
	0, // 45 - Infrared
	0, // 46 - Parachute
	0, // 47 - Fake pistol
	0 // 48 - Pistol whip (custom)
};

// The default weapon range (from weapon.dat)
// Note that due to various bugs, these can be exceeded, but
// this include blocks out-of-range values.
static Float:ac_WeaponRange[] = {

	0.0, // 0 - Fist
	0.0, // 1 - Brass knuckles
	0.0, // 2 - Golf club
	0.0, // 3 - Nitestick
	0.0, // 4 - Knife
	0.0, // 5 - Bat
	0.0, // 6 - Shovel
	0.0, // 7 - Pool cue
	0.0, // 8 - Katana
	0.0, // 9 - Chainsaw
	0.0, // 10 - Dildo
	0.0, // 11 - Dildo 2
	0.0, // 12 - Vibrator
	0.0, // 13 - Vibrator 2
	0.0, // 14 - Flowers
	0.0, // 15 - Cane
	0.0, // 16 - Grenade
	0.0, // 17 - Teargas
	0.0, // 18 - Molotov
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
	0.0, // 35 - Rocket launcher
	0.0, // 36 - Heatseeker
	0.0, // 37 - Flamethrower
	75.0  // 38 - Minigun
};

enum {
	HIT_NO_DAMAGEDID,
	HIT_INVALID_WEAPON,
	HIT_LAST_SHOT_INVALID,
	HIT_MULTIPLE_PLAYERS,
	HIT_MULTIPLE_PLAYERS_SHOTGUN,
	HIT_DYING_PLAYER,
	HIT_SAME_TEAM,
	HIT_UNSTREAMED,
	HIT_INVALID_HITTYPE,
	HIT_BEING_RESYNCED,
	HIT_NOT_SPAWNED,
	HIT_OUT_OF_RANGE,
	HIT_TOO_FAR_FROM_SHOT,
	SHOOTING_RATE_TOO_FAST,
	SHOOTING_RATE_TOO_FAST_MULTIPLE,
	HIT_RATE_TOO_FAST,
	HIT_RATE_TOO_FAST_MULTIPLE,
	HIT_KNIFE_FAILED,
	HIT_TOO_FAR_FROM_ORIGIN,
	HIT_INVALID_DAMAGE,
	HIT_SAME_VEHICLE,
	HIT_OWN_VEHICLE,
	HIT_INVALID_VEHICLE,
	HIT_DISCONNECTED
}

// Must be in sync with the enum above
// Used in debug messages and GetRejectedHit
stock const g_HitRejectReasons[][] = {
	"None or invalid player shot",
	"Invalid weapon",
	"Last shot invalid",
	"One bullet hit %d players",
	"Hit too many players with shotgun: %d",
	"Hit a dying player",
	"Hit a teammate",
	"Hit someone that can't see you (not streamed in)",
	"Invalid hit type: %d",
	"Hit while being resynced",
	"Hit when not spawned or dying",
	"Hit out of range (%f > %f)",
	"Hit player too far from hit position (dist %f)",
	"Shooting rate too fast: %d (%d samples, max %d)",
	"Shooting rate too fast: %d (%d samples, multiple weapons)",
	"Hit rate too fast: %d (%d samples, max %d)",
	"Hit rate too fast: %d (%d samples, multiple weapons)",
	"The knife kill did not sync",
	"Damage inflicted too far from current position (dist %f)",
	"Invalid weapon damage (%.4f)",
	"Hit a player in the same vehicle",
	"Hit the vehicle you're in",
	"Hit invalid vehicle: %d",
	"Hit a disconnected player ID: %d"
};

stock const g_WeaponName[57][59] = {
	{"Fist"             }, {"Brass knuckles"}, {"Golf club"           },
	{"Nightstick"       }, {"Knife"         }, {"Bat"                 },
	{"Shovel"           }, {"Pool cue"      }, {"Katana"              },
	{"Chainsaw"         }, {"Purple dildo"  }, {"Dildo"               },
	{"Vibrator"         }, {"Vibrator"      }, {"Flowers"             },
	{"Cane"             }, {"Grenade"       }, {"Tear gas"            },
	{"Molotov"          }, {"Vehicle gun"   }, {"Vehicle gun"         },
	{""                 }, {"Colt 45"       }, {"Silenced pistol"     },
	{"Deagle"           }, {"Shotgun"       }, {"Sawn-off shotgun"    },
	{"Combat shotgun"   }, {"Mac-10"        }, {"MP5"                 },
	{"AK-47"            }, {"M4"            }, {"Tec-9"               },
	{"Cuntgun"          }, {"Sniper"        }, {"Rocket launcher"     },
	{"Heat seeking RPG" }, {"Flamethrower"  }, {"Minigun"             },
	{"Satchel"          }, {"Detonator"     }, {"Spraycan"            },
	{"Fire extinguisher"}, {"Camera"        }, {"Night vision goggles"},
	{"Infrared goggles" }, {"Parachute"     }, {"Fake pistol"         },
	{"Pistol whip"      }, {"Vehicle"       }, {"Helicopter blades"   },
	{"Explosion"        }, {"Car parking"   }, {"Drowning"            },
	{"Collision"        }, {"Splat"         }, {"Unknown"             }
};

stock const ac_ACNames[][] = {
	"Aimbot",
	"(Auto) C-Bug",
	"Silent Aim",
	"Pro-Aim",
	"Range Hacks",
	"Speed Hacks",
	"Vehicle Hacks",
	"Command Spamming",
	"Car Surfing",
	"Ninja Jacking",
	"Ghost Hacks",
	"Name Tags",
	"Airbreaking",
	"Infinite Stamina",
	"Health/Armor Hacks",
	"Dialog Spoofing",
	"Rejected Hits (view-only)",
	"Desync"
};


// #define AC_DEBUG
#define 			HACKTIMER_INTERVAL 			5000

#define 			BODY_PART_UNKNOWN 			0
#define 			WEAPON_UNARMED 				0
#define 			WEAPON_VEHICLE_M4 			19
#define 			WEAPON_VEHICLE_MINIGUN 		20
#define 			WEAPON_PISTOLWHIP 			48
#define 			WEAPON_HELIBLADES 			50
#define 			WEAPON_EXPLOSION 			51
#define 			WEAPON_CARPARK 				52
#define 			WEAPON_UNKNOWN 				55

#define 			AC_MAX_REJECTED_HITS 		15
#define 			AC_MAX_DAMAGE_RANGES 		5

enum e_WeaponDataAC {

	ac_iBulletsFired[46],
	ac_iBulletsHit[46],
	ac_iFakeMiss[46]
}
new arrWeaponDataAC[MAX_PLAYERS][e_WeaponDataAC];

enum e_WeaponData {
	ac_DamageRangeSteps,
	Float:ac_WeaponDamage,
	Float:ac_DamageRangeRanges[AC_MAX_DAMAGE_RANGES],
	Float:ac_DamageRangeValues[AC_MAX_DAMAGE_RANGES]
}
new arrWeaponData[55][e_WeaponData];

// Given in AC_OnRejectedHit
enum E_REJECTED_HIT {

	acr_iReason,
	acr_iTime,
	acr_iWeaponID,
	acr_szName[MAX_PLAYER_NAME],
	acr_iDamagedID,
	acr_iInfo[3]
}
new arrRejectedHitData[MAX_PLAYERS][AC_MAX_REJECTED_HITS][E_REJECTED_HIT];


new ac_iSilentAimWarnings[MAX_PLAYERS],
	ac_iSilentAimWarnings2[MAX_PLAYERS],
	ac_iSilentAimWarnings3[MAX_PLAYERS],
	ac_iSilentAimTick[MAX_PLAYERS],
	ac_iGhostHackWarnings[MAX_PLAYERS],

	ac_iPlayerKeySpam[MAX_PLAYERS],
	ac_iVehicleDriverID[MAX_PLAYERS],
	ac_iLastVehicleID[MAX_PLAYERS],

	ac_TotalShots[MAX_PLAYERS],
	ac_HitsIssued[MAX_PLAYERS],
	bool:ac_IsDead[MAX_PLAYERS],
	bool:ac_BeingResynced[MAX_PLAYERS],
	iShotVariance = 5;

ptask HackCheck_Micro[1000](playerid) {
	
	if(PlayerInfo[playerid][pAdmin] < 2)
	{
		if(IsSpawned[playerid] && gPlayerLogged{playerid} && playerTabbed[playerid] < 1) {
			if(ac_ACToggle[AC_AIRBREAKING] && AC_AirBreaking(playerid)) AC_Process(playerid, AC_AIRBREAKING);

			/* Reset arrPAntiCheat bits that were set in callback wrappers */
			Bit_Off(arrPAntiCheat[playerid], ac_bitValidPlayerPos);
			Bit_Off(arrPAntiCheat[playerid], ac_bitValidSpectating);
		}
	}
}

ptask HackCheck[HACKTIMER_INTERVAL](playerid) {

	DeletePVar(playerid, "ACCooldown");
	arrAntiCheat[playerid][ac_iCommandCount] = 0;
	ac_iPlayerKeySpam[playerid] = 0;
	arrAntiCheat[playerid][ac_iSpeed] = GetPlayerSpeed(playerid);

	ac_iSilentAimWarnings[playerid] = 0;
	ac_iSilentAimWarnings2[playerid] = 0;
	ac_iSilentAimWarnings3[playerid] = 0;
	ac_iGhostHackWarnings[playerid] = 0;

	if(PlayerInfo[playerid][pAdmin] < 2)
	{
		if(IsSpawned[playerid] && gPlayerLogged{playerid} && playerTabbed[playerid] < 1) {
			if(ac_ACToggle[AC_CARSURFING] && AC_IsPlayerSurfing(playerid)) AC_Process(playerid, AC_CARSURFING, INVALID_PLAYER_ID);
			if(ac_ACToggle[AC_HEALTHARMORHACKS] && AC_PlayerHealthArmor(playerid)) AC_Process(playerid, AC_HEALTHARMORHACKS, INVALID_PLAYER_ID);
			if(ac_ACToggle[AC_INFINITESTAMINA] && AC_InfiniteStamina(playerid)) AC_Process(playerid, AC_INFINITESTAMINA);
		}
	}
}

timer AC_RevivePlayer[5000](playerid) {

	format(szMiscArray, sizeof(szMiscArray), "SYSTEM: %s(%d) has been revived by [SYSTEM]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerNameEx(playerid));
	Log("logs/system.log", szMiscArray);
	KillEMSQueue(playerid);
	ClearAnimationsEx(playerid);
	SetHealth(playerid, 100);
}


timer AC_ResetPVars[2000](playerid, processid) {

	switch(processid) {
		case 0: {
			ac_iLastVehicleID[playerid] = INVALID_VEHICLE_ID;
		}
		case 1: {
			DeletePVar(playerid, "PCMute");
		}
	}
}

timer AC_ResetAnim[2000](playerid) {
	ClearAnimationsEx(playerid, 1);
}

hook OnGameModeInit() {
	
	for(new i = 1; i < sizeof(ac_ACToggle); ++i) ac_ACToggle[i] = false;
	
	/* Default On: */
	ac_ACToggle[AC_NINJAJACK] = true;
	ac_ACToggle[AC_DIALOGSPOOFING] = true;

	AC_InitWeaponData();
}

/*
CMD:rehashpareas(playerid, params[]) {

	if(!IsAdminLevel(playerid, ADMIN_SENIOR, 1)) return 1;
	if(!ac_ACToggle[AC_NAMETAGS]) return SendClientMessageEx(playerid, COLOR_GRAD1, "This feature isn't enabled in /system.");

	new iRange;
	if(sscanf(params, "d", iRange)) return SendClientMessageEx(playerid, COLOR_GRAD1, "USAGE: /resetpareas [range]");
	if(!(0 < iRange < 70)) return SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid range (between 0 and 70).");

	new szData[2];
	szData[0] = STREAMER_AREATYPE_PLAYERAREA; // to make sure we can recognize this as a player area type.
	foreach(new i : Player) {

		foreach(new x : Player) if(!IsPlayerInDynamicArea(x, arrAntiCheat[i][ac_iPlayerAreaID])) ShowPlayerNameTagForPlayer(x, i, false);

		szData[1] = i;
		DestroyDynamicArea(arrAntiCheat[i][ac_iPlayerAreaID]);
		arrAntiCheat[i][ac_iPlayerAreaID] = CreateDynamicSphere(0.0, 0.0, 0.0, iRange);
		AttachDynamicAreaToPlayer(arrAntiCheat[i][ac_iPlayerAreaID], i, 0.0, 0.0, 0.0);
		Streamer_SetArrayData(STREAMER_TYPE_AREA, arrAntiCheat[i][ac_iPlayerAreaID], E_STREAMER_EXTRA_ID, szData, sizeof(szData));
	}
	format(szMiscArray, sizeof(szMiscArray), "%s set the player nametag distance to %d meters.", GetPlayerNameEx(playerid), iRange);
	ABroadCast(COLOR_YELLOW, szMiscArray, 2 );
	return 1;
}
*/

/*
CMD:setnametagdistance(playerid, params[]) {

	if(!IsAdminLevel(playerid, ADMIN_SENIOR, 1)) return 1;

	new iRange;
	if(sscanf(params, "d", iRange)) return SendClientMessageEx(playerid, COLOR_GRAD1, "USAGE: /setnametagdistance [range]");
	if(!(0 < iRange < 70)) return SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid range (between 0 and 70).");

	new szData[2];
	szData[0] = STREAMER_AREATYPE_PLAYERAREA; // to make sure we can recognize this as a player area type.

	foreach(new i : Player) {

		szData[1] = i;
		DestroyDynamicArea(arrAntiCheat[i][ac_iPlayerAreaID]);
		arrAntiCheat[i][ac_iPlayerAreaID] = CreateDynamicSphere(0.0, 0.0, 0.0, iRange);
		AttachDynamicAreaToPlayer(arrAntiCheat[i][ac_iPlayerAreaID], i, 0.0, 0.0, 0.0);
		Streamer_SetArrayData(STREAMER_TYPE_AREA, arrAntiCheat[i][ac_iPlayerAreaID], E_STREAMER_EXTRA_ID, szData, sizeof(szData));
	}

	format(szMiscArray, sizeof(szMiscArray), "You set the nametag distance to %d meters.", iRange);
	SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
	return 1;	
}
*/


hook OnPlayerConnect(playerid) {

	/*
	new szData[2];
	szData[0] = STREAMER_AREATYPE_PLAYERAREA; // to make sure we can recognize this as a player area type.
	szData[1] = playerid;

	arrAntiCheat[playerid][ac_iPlayerAreaID] = CreateDynamicSphere(0.0, 0.0, 0.0, 25.0);
	AttachDynamicAreaToPlayer(arrAntiCheat[playerid][ac_iPlayerAreaID], playerid, 0.0, 0.0, 0.0);
	Streamer_SetArrayData(STREAMER_TYPE_AREA, arrAntiCheat[playerid][ac_iPlayerAreaID], E_STREAMER_EXTRA_ID, szData, sizeof(szData));

	if(ac_ACToggle[AC_NAMETAGS]) {
		foreach(new i : Player) {
			if(!IsPlayerInDynamicArea(playerid, arrAntiCheat[i][ac_iPlayerAreaID])) {
				ShowPlayerNameTagForPlayer(i, playerid, false); // So people don't see the playerid when they shouldn't
				ShowPlayerNameTagForPlayer(playerid, i, false); // So the player doesn't see the others when they shouldn't
			}
		}
	}
	*/

	new iTick = GetTickCount();
	arrAntiCheat[playerid][ac_iVehID] = INVALID_VEHICLE_ID;
	arrAntiCheat[playerid][ac_iShots][0] = 0;
	arrAntiCheat[playerid][ac_iShots][1] = 0;
	arrAntiCheat[playerid][ac_fPos][0] = 0;
	arrAntiCheat[playerid][ac_fPos][1] = 0;
	arrAntiCheat[playerid][ac_fPos][2] = 0;
	arrAntiCheat[playerid][ac_fCamPos][0] = 0;
	arrAntiCheat[playerid][ac_fCamPos][1] = 0;
	arrAntiCheat[playerid][ac_fCamPos][2] = 0;
	arrAntiCheat[playerid][ac_fCamPos][3] = 0;
	arrAntiCheat[playerid][ac_fCamPos][4] = 0;
	arrAntiCheat[playerid][ac_fCamPos][5] = 0;
	arrAntiCheat[playerid][ac_fCamFVector][0] = 0;
	arrAntiCheat[playerid][ac_fCamFVector][1] = 0;
	arrAntiCheat[playerid][ac_fCamFVector][2] = 0;
	arrAntiCheat[playerid][ac_fCamFVector][3] = 0;
	arrAntiCheat[playerid][ac_fCamFVector][4] = 0;
	arrAntiCheat[playerid][ac_fCamFVector][5] = 0;
	arrAntiCheat[playerid][ac_fPlayerAngle][0] = 0;
	arrAntiCheat[playerid][ac_fPlayerAngle][1] = 0;
	arrAntiCheat[playerid][ac_iLastTargetID] = INVALID_PLAYER_ID;
	arrAntiCheat[playerid][ac_fAimAccuracy] = 0;
	for(new i; i < AC_MAX; ++i) arrAntiCheat[playerid][ac_iFlags][i] = 0;
	arrAntiCheat[playerid][ac_iCommandCount] = 0;
	//if(IsValidDynamicArea(arrAntiCheat[playerid][ac_iPlayerAreaID])) DestroyDynamicArea(arrAntiCheat[playerid][ac_iPlayerAreaID]);
	arrAntiCheat[playerid][ac_fProbability] = 0;
	arrAntiCheat[playerid][ac_iCheatingIndex][0] = 0;
	arrAntiCheat[playerid][ac_iCheatingIndex][1] = 0;
	arrAntiCheat[playerid][ac_iIsCheating] = false;
	arrAntiCheat[playerid][ac_inTrainingMode] = false;


	Bit_Off(arrPAntiCheat[playerid], ac_bitValidPlayerPos);
	Bit_Off(arrPAntiCheat[playerid], ac_bitValidSpectating);

	ac_LastUpdate[playerid] = iTick;
	ac_PlayerMaxHealth[playerid] = 100.0;
	ac_LastExplosive[playerid] = 0;
	ac_LastBulletIdx[playerid] = 0;
	ac_LastHitIdx[playerid] = 0;
	ac_RejectedHitsIdx[playerid] = 0;
	ac_TotalShots[playerid] = 0;
	ac_HitsIssued[playerid] = 0;
	ac_IsDead[playerid] = false;
	ac_iCBugFreeze[playerid] = 0;

	arrLastBulletData[playerid][acl_Tick] = 0;
	arrLastBulletData[playerid][acl_Weapon] = 0;
	arrLastBulletData[playerid][acl_HitType] = HIT_INVALID_HITTYPE;
	arrLastBulletData[playerid][acl_HitId] = INVALID_PLAYER_ID;
	arrLastBulletData[playerid][acl_fPos][0] = 0;
	arrLastBulletData[playerid][acl_fPos][1] = 0;
	arrLastBulletData[playerid][acl_fPos][2] = 0;
	arrLastBulletData[playerid][acl_fTargetPos][0] = 0;
	arrLastBulletData[playerid][acl_fTargetPos][1] = 0;
	arrLastBulletData[playerid][acl_fTargetPos][2] = 0;
	arrLastBulletData[playerid][acl_fOrigin][0] = 0;
	arrLastBulletData[playerid][acl_fOrigin][1] = 0;
	arrLastBulletData[playerid][acl_fOrigin][2] = 0;
	arrLastBulletData[playerid][acl_fHitPos][0] = 0;
	arrLastBulletData[playerid][acl_fHitPos][1] = 0;
	arrLastBulletData[playerid][acl_fHitPos][2] = 0;
	arrLastBulletData[playerid][acl_fDistance] = 0;
	arrLastBulletData[playerid][acl_Hits] = 0;

	for (new i; i < 46; i++) {
		arrWeaponDataAC[playerid][ac_iBulletsFired][i] = 0;
		arrWeaponDataAC[playerid][ac_iBulletsHit][i] = 0;
		arrWeaponDataAC[playerid][ac_iFakeMiss][i] = 0;
	}

	for (new i; i < sizeof(arrRejectedHitData[]); i++) {
		arrRejectedHitData[playerid][i][acr_iTime] = 0;
	}

	ac_iSilentAimWarnings[playerid] = 0;
	ac_iSilentAimWarnings2[playerid] = 0;
	ac_iSilentAimWarnings3[playerid] = 0;
	ac_iSilentAimTick[playerid] = 0;
	ac_iGhostHackWarnings[playerid] = 0;
}

/*
hook OnPlayerDisconnect(playerid, reason) {

	if(IsValidDynamicArea(arrAntiCheat[playerid][ac_iPlayerAreaID])) DestroyDynamicArea(arrAntiCheat[playerid][ac_iPlayerAreaID]);
	//if(IsValidDynamic3DTextLabel(PlayerLabel[playerid])) DestroyDynamic3DTextLabel(PlayerLabel[playerid]);
}
*/

/*
hook OnPlayerEnterDynamicArea(playerid, areaid) {

	if(ac_ACToggle[AC_NAMETAGS]) {
		new szData[2];
		Streamer_GetArrayData(STREAMER_TYPE_AREA, areaid, E_STREAMER_EXTRA_ID, szData, sizeof(szData));
		if(szData[0] == STREAMER_AREATYPE_PLAYERAREA) ShowPlayerNameTagForPlayer(playerid, szData[1], 1);
	}
}

hook OnPlayerLeaveDynamicArea(playerid, areaid) {

	if(ac_ACToggle[AC_NAMETAGS]) {
		new szData[2];
		Streamer_GetArrayData(STREAMER_TYPE_AREA, areaid, E_STREAMER_EXTRA_ID, szData, sizeof(szData));
		if(szData[0] == STREAMER_AREATYPE_PLAYERAREA) ShowPlayerNameTagForPlayer(playerid, szData[1], 0);
	}
}
*/

/*
hook OnPlayerCommandReceived(playerid, cmdtext[]) {

	arrAntiCheat[playerid][ac_iCommandCount]++;
	switch(arrAntiCheat[playerid][ac_iCommandCount]) {
		case 0 .. 9: {}
		case 10 .. 15: {
			AC_Process(playerid, AC_CMDSPAM, arrAntiCheat[playerid][ac_iCommandCount]);
			return 0;
		}
		default: {
			AC_Process(playerid, AC_CMDSPAM, arrAntiCheat[playerid][ac_iCommandCount]);
			return 0;
		}
	}
	return 1;
}
*/

hook OnPlayerUpdate(playerid) {

	if(ac_ACToggle[AC_SPEEDHACKS]) AC_SpeedHacks(playerid);
    if(IsPlayerInAnyVehicle(playerid)){

		if(GetPlayerVehicleID(playerid) != arrAntiCheat[playerid][ac_iVehID]) {

			arrAntiCheat[playerid][ac_iVehID] = INVALID_VEHICLE_ID;
			
			new Float:fPos[3];
			GetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]);
			SetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]+1); 
			AC_Process(playerid, AC_VEHICLEHACKS);
		} 
	} 
	ac_LastUpdate[playerid] = GetTickCount();
	return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {

	if(newkeys == KEY_YES) ac_iPlayerKeySpam[playerid]++;
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) {

		if(newkeys & KEY_FIRE) {
			
			new weaponid = GetPlayerWeapon(playerid);
			switch (weaponid) {
				case WEAPON_BOMB, WEAPON_SATCHEL: ac_LastExplosive[playerid] = WEAPON_SATCHEL;
				case WEAPON_ROCKETLAUNCHER, WEAPON_HEATSEEKER, WEAPON_GRENADE: ac_LastExplosive[playerid] = weaponid;
			}
		}
		if(newkeys & KEY_CROUCH) {

			if(IsPlayerInAnyVehicle(playerid) || GetPVarType(playerid, "EventToken") || (GetPVarType(playerid, "IsInArena") && PaintBallArena[GetPVarInt(playerid, "IsInArena")][pbExploitPerm] == 1)) return 1;

			new iTick = GetTickCount(),
				iDiff = iTick - arrLastBulletData[playerid][acl_Tick];

			if(arrLastBulletData[playerid][acl_Tick] && iDiff < 1200 && !ac_iCBugFreeze[playerid]) {

				AC_Process(playerid, AC_CBUG);
				ac_iCBugFreeze[playerid] = GetTickCount();
			}
		}
	}
	return 1;
}

hook OnPlayerEnterVehicle(playerid, vehicleid, ispassenger) {
	if(!ispassenger) ac_iVehicleDriverID[playerid] = GetDriverID(vehicleid);
	arrAntiCheat[playerid][ac_iVehID] = vehicleid;
}

hook OnPlayerStateChange(playerid, newstate, oldstate) {

	if(newstate == PLAYER_STATE_DRIVER) ac_iLastVehicleID[playerid] = GetPlayerVehicleID(playerid);
	if(oldstate == PLAYER_STATE_DRIVER && newstate == PLAYER_STATE_ONFOOT) defer AC_ResetPVars(playerid, 0);
}

hook OnPlayerSpawn(playerid) {

	ac_LastUpdate[playerid] = GetTickCount();
	if(ac_IsDead[playerid]) ac_IsDead[playerid] = false;
}

hook OnPlayerDeath(playerid, killerid, reason) {

	ac_IsDead[playerid] = true;
	new iKillerID = GetDriverID(ac_iLastVehicleID[playerid]),
		iKillerVehID = GetPlayerVehicleID(iKillerID);

	if(iKillerID != INVALID_PLAYER_ID) {
		if(ac_iVehicleDriverID[iKillerID] == playerid || (iKillerVehID == ac_iLastVehicleID[playerid] && iKillerVehID != INVALID_VEHICLE_ID)) {
			
			new Float:fPos[3];
			GetPlayerPos(iKillerID, fPos[0], fPos[1], fPos[2]);
			if(IsPlayerInRangeOfPoint(playerid, 15.0, fPos[0], fPos[1], fPos[2]) && GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(iKillerID)) {
				AC_Process(playerid, AC_NINJAJACK, iKillerID);
			}
		}
	}
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	switch(dialogid) {

		case DIALOG_AC_MAIN: {

			if(response) {
			
				if(ac_ACToggle[listitem]) {
					format(szMiscArray, sizeof(szMiscArray), "[SYSTEM] %s turned off the %s detection.", GetPlayerNameEx(playerid), ac_ACNames[listitem]);
					ac_ACToggle[listitem] = false;
				}
				else {
					format(szMiscArray, sizeof(szMiscArray), "[SYSTEM] %s turned on the %s detection.", GetPlayerNameEx(playerid), ac_ACNames[listitem]);
					ac_ACToggle[listitem] = true;
				}
				Log("logs/ACSystem.log", szMiscArray);
				ABroadCast(COLOR_LIGHTRED, szMiscArray, 2);
			}
		}
	}
	return 0;
}


public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ) {

	szMiscArray[0] = 0;

	if(IsPlayerPaused(playerid) && ac_iGhostHackWarnings[playerid] > 5) AC_Process(playerid, AC_GHOSTHACKS, weaponid);
	if(!IsCorrectCameraMode(playerid)) AC_Process(playerid, AC_DESYNC, GetPlayerCameraMode(playerid));

	new vehmodel = GetVehicleModel(GetPlayerVehicleID(playerid));
	if(hittype == BULLET_HIT_TYPE_PLAYER && (BadFloat(fX) || BadFloat(fY) || BadFloat(fZ)))	{
		Kick(playerid); // CRASHER DETECTED
	    return 0;
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
	if(GetPVarInt(playerid, "EventToken") == 0 && !GetPVarType(playerid, "IsInArena") && (vehmodel != 425 && vehmodel != 432 && vehmodel != 447 && vehmodel != 464 && vehmodel != 476 && vehmodel != 520) && GetWeaponSlot(weaponid) != -1) {
		if(PlayerInfo[playerid][pGuns][GetWeaponSlot(weaponid)] != weaponid) return 1;
	}

	if(hittype == BULLET_HIT_TYPE_PLAYER) {

		if(!IsPlayerStreamedIn(playerid, hitid) || !IsPlayerStreamedIn(hitid, playerid)) return 0;
	}
	if(weaponid == 24 || weaponid == 25 || weaponid == 26/* || weaponid == 31*/) {
		++PlayerShots[playerid];
	}
	if(weaponid == 34) {

		++PlayerSniperShots[playerid];	
	}
/*	if(GetPVarInt(playerid, "FireStart") == 1) {
		if(fX != 0 && fY != 0 && hittype != BULLET_HIT_TYPE_PLAYER && hittype != BULLET_HIT_TYPE_VEHICLE) {

			if(gettime() > GetPVarInt(playerid, "fCooldown")) CreateStructureFire(fX, fY, fZ, GetPlayerVirtualWorld(playerid));
		}
	}
*/
	
	
	#if defined AC_DEBUG
	if(hittype == BULLET_HIT_TYPE_PLAYER) {
		AC_SendDebugMessage(playerid, "OnPlayerWeaponShot(%s shot %s with %s at %f, %f, %f) ", GetPlayerNameEx(playerid),  GetPlayerNameEx(hitid), AC_GetWeaponName(weaponid), fX, fY, fZ);
	}
	else if(hittype) {
		AC_SendDebugMessage(playerid, "OnPlayerWeaponShot(%s shot %s %d with %s at %f, %f, %f", GetPlayerNameEx(playerid),  GetPlayerNameEx(hitid), AC_GetWeaponName(weaponid), fX, fY, fZ);
	}
	else {
		AC_SendDebugMessage(playerid, "OnPlayerWeaponShot(%s shot with %s at %f, %f, %f)", GetPlayerNameEx(playerid), AC_GetWeaponName(weaponid), fX, fY, fZ);
	}
	#endif
	

	arrLastBulletData[playerid][acl_Valid] = false;
	arrLastBulletData[playerid][acl_Hits] = false;

	// C-Bug
	if(ac_iCBugFreeze[playerid] && GetTickCount() - ac_iCBugFreeze[playerid] < 900) {
		return 0;
	}
	ac_iCBugFreeze[playerid] = 0;

	// Desync
	new damagedid = INVALID_PLAYER_ID;
	if(hittype == BULLET_HIT_TYPE_PLAYER && hitid != INVALID_PLAYER_ID) {
		
		if(!IsPlayerConnected(hitid)) {
			AC_AddRejectedHit(playerid, hitid, HIT_DISCONNECTED, weaponid, hittype);
			return 0;
		}
		damagedid = hitid;
	}

	// Invalid hit type
	if(hittype < 0 || hittype > 4) {
		AC_AddRejectedHit(playerid, damagedid, HIT_INVALID_HITTYPE, weaponid, hittype);
		return 0;
	}

	// Hitting when player isn't spawned.
	if(!IsPlayerSpawned(playerid)) {
		AC_AddRejectedHit(playerid, damagedid, HIT_NOT_SPAWNED, weaponid, hittype);
		return 0;
	}

	// Just in case
	if(!IsBulletWeapon(weaponid)) {
		AC_AddRejectedHit(playerid, damagedid, HIT_INVALID_WEAPON, weaponid, hittype);
		return 0;
	}

	new Float:fOriginX, Float:fOriginY, Float:fOriginZ, Float:fHitPosX, Float:fHitPosY, Float:fHitPosZ,
		Float:x, Float:y, Float:z;

	GetPlayerPos(playerid, x, y, z);
	GetPlayerLastShotVectors(playerid, fOriginX, fOriginY, fOriginZ, fHitPosX, fHitPosY, fHitPosZ);

	new Float:fDistance = VectorSize(fOriginX - fHitPosX, fOriginY - fHitPosY, fOriginZ - fHitPosZ),
		Float:origin_dist = VectorSize(fOriginX - x, fOriginY - y, fOriginZ - z);

	if(origin_dist > 15.0) {
		
		new iVehCheck = IsPlayerInAnyVehicle(hitid) || GetPlayerSurfingVehicleID(playerid);
		if((!iVehCheck && GetPlayerSurfingVehicleID(playerid) == INVALID_VEHICLE_ID) || origin_dist > 50.0) {
			AC_AddRejectedHit(playerid, damagedid, HIT_TOO_FAR_FROM_ORIGIN, weaponid, _:origin_dist);
			return 0;
		}
	}

	// Bullet range check.
	if(hittype != BULLET_HIT_TYPE_NONE) {
		if(fDistance > ac_WeaponRange[weaponid] + 10.0) {
			if(hittype == BULLET_HIT_TYPE_PLAYER) {
				AC_AddRejectedHit(playerid, damagedid, HIT_OUT_OF_RANGE, weaponid, _:fDistance, _:ac_WeaponRange[weaponid]);
			}
			return 0;
		}
		if(hittype == BULLET_HIT_TYPE_PLAYER) {
			if(IsPlayerInAnyVehicle(playerid) && GetPlayerVehicleID(playerid) == GetPlayerVehicleID(hitid)) {
				AC_AddRejectedHit(playerid, damagedid, HIT_SAME_VEHICLE, weaponid);
				return 0;
			}

			new Float:fHitDist = GetPlayerDistanceFromPoint(hitid, fHitPosX, fHitPosY, fHitPosZ),
				iVehCheck = IsPlayerInAnyVehicle(hitid);

			if ((!iVehCheck && fHitDist > 20.0) || fHitDist > 50.0) {
				AC_AddRejectedHit(playerid, damagedid, HIT_TOO_FAR_FROM_SHOT, weaponid, _:fHitDist);
				return 0;
			}
		}
	}

	new iTick = GetTickCount();
	if(iTick == 0) iTick = 1;

	new idx = (ac_LastBulletIdx[playerid] + 1) % sizeof(ac_LastBulletTicks[]);

	// JIT plugin fix
	if (idx < 0) {
		idx += sizeof(ac_LastBulletTicks[]);
	}
	
	ac_LastBulletIdx[playerid] = idx;
	ac_LastBulletTicks[playerid][idx] = iTick;
	ac_LastBulletWeapons[playerid][idx] = weaponid;
	ac_TotalShots[playerid]++;

	/* LOG FUNCTIONS */
	arrLastBulletData[playerid][acl_Tick] = GetTickCount();
	arrLastBulletData[playerid][acl_Weapon] = weaponid;
	arrLastBulletData[playerid][acl_HitType] = hittype;
	arrLastBulletData[playerid][acl_HitId] = hitid;
	arrLastBulletData[playerid][acl_fPos][0] = fX;
	arrLastBulletData[playerid][acl_fPos][1] = fY;
	arrLastBulletData[playerid][acl_fPos][2] = fZ;
	if(hitid != INVALID_PLAYER_ID) {
		arrLastBulletData[playerid][acl_fTargetPos][0] = fHitPosX;
		arrLastBulletData[playerid][acl_fTargetPos][1] = fHitPosY;
		arrLastBulletData[playerid][acl_fTargetPos][2] = fHitPosZ;
	}
	arrLastBulletData[playerid][acl_fOrigin][0] = fOriginX;
	arrLastBulletData[playerid][acl_fOrigin][1] = fOriginY;
	arrLastBulletData[playerid][acl_fOrigin][2] = fOriginZ;
	arrLastBulletData[playerid][acl_fHitPos][0] = fHitPosX;
	arrLastBulletData[playerid][acl_fHitPos][1] = fHitPosY;
	arrLastBulletData[playerid][acl_fHitPos][2] = fHitPosZ;
	arrLastBulletData[playerid][acl_fDistance] = fDistance;
	arrLastBulletData[playerid][acl_Hits] = 0;

	/*
		AimBot check 2 and:
		Pro Aim Check by Pottus
		Reference: http://forum.sa-mp.com/showpost.php?p=3038425
	*/
	if(hittype == BULLET_HIT_TYPE_PLAYER) {

		if(!playerTabbed[hitid]) {
			/*
			Too many false positives.
			if(GetPlayerSpeed(hitid) > 3) {
				arrAntiCheat[playerid][ac_iShots][1]++;
				if(arrAntiCheat[playerid][ac_iShots][1] > ac_MaxWeaponContShots[weaponid] + 15) AC_Process(playerid, AC_AIMBOT, weaponid);
			}
			*/
			if(ac_ACToggle[3]) {

				if(ProAimCheck(playerid, hitid)) {

					arrAntiCheat[playerid][ac_iFlags][3]++;
					if(arrAntiCheat[playerid][ac_iFlags][3] > 3) AC_Flag(playerid, AC_PROAIM, weaponid, arrAntiCheat[playerid][ac_iFlags][3]);
				}
			}
		}
		else arrAntiCheat[playerid][ac_iShots][1] = 0;
	}	

	// AimBot Player Scheme
	arrWeaponDataAC[playerid][ac_iBulletsFired][weaponid]++;
	if(hittype == BULLET_HIT_TYPE_PLAYER && ac_MaxWeaponContShots[weaponid] && !IsPlayerPaused(hitid)) {

		if(!playerTabbed[hitid]) {

	    	new fSpeed = GetPlayerSpeed(hitid);

		    if(fSpeed > 5) { // subject to discussion
	    	
				arrWeaponDataAC[playerid][ac_iBulletsHit][weaponid]++;
				//if(!(++arrAntiCheat[playerid][ac_iShots][0] % ac_MaxWeaponContShots[weaponid])) AC_Process(playerid, AC_AIMBOT, weaponid);

				new iRelevantMiss = arrWeaponDataAC[playerid][ac_iBulletsFired][weaponid] - arrWeaponDataAC[playerid][ac_iBulletsHit][weaponid] - arrWeaponDataAC[playerid][ac_iFakeMiss][weaponid],
					Float:fRatio;

				iRelevantMiss++; // Can't divide by 0.
				fRatio = arrWeaponDataAC[playerid][ac_iBulletsHit][weaponid] / iRelevantMiss;
				if(arrWeaponDataAC[playerid][ac_iBulletsFired][weaponid] > 50 && fRatio > 3) AC_Flag(playerid, AC_AIMBOT, weaponid, fRatio);
			}
			else arrWeaponDataAC[playerid][ac_iFakeMiss][weaponid]++;
		}
	}
	else arrAntiCheat[playerid][ac_iShots][0] = 0; // reset it when missed :)
	return 1;
}

ProAimCheck(playerid, hitid) {

	new 
		Float: fOrigin[3],
		Float: fHit[3];

	GetPlayerLastShotVectors(playerid, fOrigin[0], fOrigin[1], fOrigin[2], fHit[0], fHit[1], fHit[2]);

	new Float:fPlayerHitPos[3];
	GetPlayerPos(hitid, fPlayerHitPos[0], fPlayerHitPos[1], fPlayerHitPos[2]);

	new Float:fDistance = GetPlayerDistanceFromPoint(hitid, fHit[0], fHit[1], fHit[2]);

	if(fDistance >= iShotVariance && fDistance <= 300.0) return 1;
	return 0;
}

AC_SpeedHacks(playerid) {

	new iSpeed = GetPlayerSpeed(playerid),
		Float:fVel[3];

	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && GetPlayerSurfingVehicleID(playerid) == INVALID_VEHICLE_ID && GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_USEJETPACK && iSpeed > 45) {
		
		GetPlayerVelocity(playerid, fVel[0], fVel[1], fVel[2]);
		if(fVel[2] == 0) {

			if(GetPlayerPacketloss(playerid) < 0.3) AC_Process(playerid, AC_SPEEDHACKS);
		}
	}
}

AC_InfiniteStamina(playerid) {

	if(arrAntiCheat[playerid][ac_iSpeed] > 24) arrAntiCheat[playerid][ac_iFlags][AC_INFINITESTAMINA]++;
	else arrAntiCheat[playerid][ac_iFlags][AC_INFINITESTAMINA] = 0;

	// Subject to discussion (HACKTIMER_INTERVAL * NUMBER = 5 seconds * 8 = 40 seconds running faster than 24).
	if(arrAntiCheat[playerid][ac_iFlags][AC_INFINITESTAMINA] > 8) return 1;
	return 0;
}

AC_AirBreaking(i) {

	if(GetPlayerSurfingVehicleID(i) != INVALID_VEHICLE_ID) return 0;

	new Float:fPos[3],
		iDistance;

	GetPlayerPos(i, fPos[0], fPos[1], fPos[2]);
	if(arrAntiCheat[i][ac_fPos][0] == 0.0 || arrAntiCheat[i][ac_fPos][1] == 0.0 || arrAntiCheat[i][ac_fPos][2] == 0.0 ||
		Bit_State(arrPAntiCheat[i], ac_bitValidPlayerPos) || Bit_State(arrPAntiCheat[i], ac_bitValidSpectating) || GetPlayerState(i) == PLAYER_STATE_SPECTATING) {

		arrAntiCheat[i][ac_fPos][0] = fPos[0];
		arrAntiCheat[i][ac_fPos][1] = fPos[1];
		arrAntiCheat[i][ac_fPos][2] = fPos[2];
		return 0;
	}

	iDistance = floatround(GetDistanceBetweenPoints(fPos[0], fPos[1], fPos[2], arrAntiCheat[i][ac_fPos][0], arrAntiCheat[i][ac_fPos][1], arrAntiCheat[i][ac_fPos][2]));
	arrAntiCheat[i][ac_fPos][0] = fPos[0];
	arrAntiCheat[i][ac_fPos][1] = fPos[1];
	arrAntiCheat[i][ac_fPos][2] = fPos[2];

	#if defined AC_DEBUG
	format(szMiscArray, sizeof(szMiscArray), "Distance: %d (%f, %f, %f, %f, %f, %f)", iDistance, fPos[0], fPos[1], fPos[2], arrAntiCheat[i][ac_fPos][0], arrAntiCheat[i][ac_fPos][1], arrAntiCheat[i][ac_fPos][2]);
	SendClientMessage(i, 0xFFFFFFFF, szMiscArray);
	#endif

	new iSpeed = GetPlayerSpeed(i);
	if(IsPlayerInAnyVehicle(i)) {
		
		#if defined AC_DEBUG
		format(szMiscArray, sizeof(szMiscArray), "VEH SPEED: %d", iSpeed);
		SendClientMessage(i, 0xFFFFFFFF, szMiscArray);
		#endif
		if(iSpeed < 0.2 && iDistance > iSpeed + 30) return 1;
	}
	else {

		#if defined AC_DEBUG
		format(szMiscArray, sizeof(szMiscArray), "FOOT SPEED: %d", iSpeed);
		SendClientMessage(i, 0xFFFFFFFF, szMiscArray);
		#endif
		if(iDistance > iSpeed + 30) return 1;
	}
	return 0;
}

hook OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid, bodypart) {

	if((!IsPlayerStreamedIn(playerid, damagedid) && !IsPlayerPaused(damagedid)) || !IsPlayerStreamedIn(damagedid, playerid)) {
		AC_AddRejectedHit(playerid, damagedid, HIT_UNSTREAMED, weaponid, damagedid);
		return 0;
	}

	if(!IsPlayerSpawned(playerid)) {
		// OnPlayerWeaponShot copy prevention.
		if(!IsBulletWeapon(weaponid) || arrLastBulletData[playerid][acl_Valid]) {
			AC_AddRejectedHit(playerid, damagedid, HIT_NOT_SPAWNED, weaponid);
		}
		return 0;
	}

	new iTick = GetTickCount();
	if(iTick == 0) iTick = 1;

	new idx = (ac_LastHitIdx[playerid] + 1) % sizeof(ac_LastHitTicks[]);

	// JIT plugin fix
	if (idx < 0) {
		idx += sizeof(ac_LastHitTicks[]);
	}

	ac_LastHitIdx[playerid] = idx;
	ac_LastHitTicks[playerid][idx] = iTick;
	ac_LastHitWeapons[playerid][idx] = weaponid;
	ac_HitsIssued[playerid] += 1;

	if(IsBulletWeapon(weaponid) && !IsPlayerPaused(damagedid)) {

		new Float:fPos[3];
		GetPlayerPos(damagedid, fPos[0], fPos[1], fPos[2]);
		new Float:fDistance = GetPlayerDistanceFromPoint(playerid, fPos[0], fPos[1], fPos[2]);
		if(fDistance > ac_WeaponRange[weaponid] + 2.0) {
			AC_AddRejectedHit(playerid, damagedid, HIT_OUT_OF_RANGE, weaponid, _:fDistance, _:ac_WeaponRange[weaponid]);
			AC_Process(playerid, AC_RANGEHACKS, weaponid);
			return 0;
		}
	}

	if(ac_ACToggle[AC_SILENTAIM]) {
		
		// Anti Silent-Aim (Jingles)
 		if(GetPlayerPacketloss(playerid) < 0.5 && GetPlayerPacketloss(damagedid) < 0.5) {

 			if(GetTickCount() - ac_iSilentAimTick[playerid] > 50) {

				ac_iSilentAimTick[playerid] = GetTickCount();
				if(GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_USEJETPACK) {

					if(!IsPlayerInAnyVehicle(damagedid)) {

						if(20 < weaponid < 35 || weaponid > 54) {

							new szWeapon[32],
								iCameraMode = GetPlayerCameraMode(playerid);

							GetWeaponName(weaponid, szWeapon, 32);		
						
							// Pro Aim
							new Float:fOriginX,
								Float:fOriginY,
								Float:fOriginZ,
								Float:fHitPosX,
								Float:fHitPosY,
								Float:fHitPosZ,
								Float:fDistance;

						    GetPlayerLastShotVectors(playerid, fOriginX, fOriginY, fOriginZ, fHitPosX, fHitPosY, fHitPosZ);
							fDistance = GetPlayerDistanceFromPoint(damagedid, fHitPosX, fHitPosY, fHitPosZ);

							if(iCameraMode != 4 && iCameraMode != 55) {

								if(GetPlayerTargetPlayer(playerid) != damagedid) {

									ac_iSilentAimWarnings[playerid]++;
									if(ac_iSilentAimWarnings[playerid] > 10) {

										AC_Process(playerid, AC_SILENTAIM, weaponid, damagedid, 1);
									}
								}

								if(fDistance <= 0.1) {

									ac_iSilentAimWarnings2[playerid]++;
									if(ac_iSilentAimWarnings2[playerid] > 4) {

										AC_Process(playerid, AC_SILENTAIM, weaponid, damagedid, 2);
									}
								}
								else ac_iSilentAimWarnings2[playerid] = 0;

								if(weaponid != 28 && weaponid != 32) {
								
									new Float:fPos[3],
										Float:fAngle[2];

									if(fDistance < 100)
									{

										GetRotationFor2Point2D(fOriginX, fOriginY, fHitPosX, fHitPosY, fAngle[0]);
										GetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]);
										GetPlayerFacingAngle(playerid, fAngle[1]);
										
										new Float:fDifference;
										fDifference = floatabs((360 - fAngle[1]) - (360 - fAngle[0]));
										if(fDifference > 10) {

											ac_iSilentAimWarnings3[playerid]++;
											if(ac_iSilentAimWarnings3[playerid] > 3) {

												AC_Process(playerid, AC_SILENTAIM, weaponid, damagedid, 3);
											}
										}							
									}
								}
							}

							// ProAim
							/*
							if(fDistance >= MAX_SHOT_VARIANCE && fDistance < 300.0) {

								ac_iSilentAimWarnings[playerid]++;
								if(ac_iSilentAimWarnings[playerid] > 5) {
									
									format(szMiscArray, sizeof(szMiscArray), "%s is using pro aim (%d).", GetPlayerNameExt(playerid), ac_iSilentAimWarnings[playerid]);
									SendClientMessageToAll(COLOR_YELLOW, szMiscArray);
								}
							}
							*/
						}
					}
				}
			}
		}
	}
	return 0;
}

// Is called after OnPlayerWeaponShot
hook OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart) {

	// Ignore unreliable and invalid damage
	if(playerid == INVALID_PLAYER_ID) return 0;

	// Carjack damage
	if(weaponid == 54 && _:amount == _:0.0) {
		// SendClientMessageToAll(0xFFFFFFFF, "NJ?");
		return 0;
	}

	// Climb bug
	if(weaponid == WEAPON_COLLISION) {

		new iAnimIdx = GetPlayerAnimationIndex(playerid);
		if(1061 <= iAnimIdx <= 1067) {
			// AC_SendDebugMessage(playerid, "Climb bug.");
			return 0;
		}
	}
	//AC_InflictDamage(playerid, amount, issuerid, weaponid, bodypart); // Server Sided Health
	return 1;
}

stock AC_InitWeaponData() {

	// Default weapon.dat
	arrWeaponData[0][ac_WeaponDamage] = 1.0; // 0 - Fist
	arrWeaponData[1][ac_WeaponDamage] = 1.0; // 1 - Brass knuckles
	arrWeaponData[2][ac_WeaponDamage] = 1.0; // 2 - Golf club
	arrWeaponData[3][ac_WeaponDamage] = 1.0; // 3 - Nitestick
	arrWeaponData[4][ac_WeaponDamage] = 1.0; // 4 - Knife
	arrWeaponData[5][ac_WeaponDamage] = 1.0; // 5 - Bat
	arrWeaponData[6][ac_WeaponDamage] = 1.0; // 6 - Shovel
	arrWeaponData[7][ac_WeaponDamage] = 1.0; // 7 - Pool cue
	arrWeaponData[8][ac_WeaponDamage] = 1.0; // 8 - Katana
	arrWeaponData[9][ac_WeaponDamage] = 1.0; // 9 - Chainsaw
	arrWeaponData[10][ac_WeaponDamage] = 1.0; // 10 - Dildo
	arrWeaponData[11][ac_WeaponDamage] = 1.0; // 11 - Dildo 2
	arrWeaponData[12][ac_WeaponDamage] = 1.0; // 12 - Vibrator
	arrWeaponData[13][ac_WeaponDamage] = 1.0; // 13 - Vibrator 2
	arrWeaponData[14][ac_WeaponDamage] = 1.0; // 14 - Flowers
	arrWeaponData[15][ac_WeaponDamage] = 1.0; // 15 - Cane
	arrWeaponData[16][ac_WeaponDamage] = 82.5; // 16 - Grenade
	arrWeaponData[17][ac_WeaponDamage] = 0.0; // 17 - Teargas
	arrWeaponData[18][ac_WeaponDamage] = 1.0; // 18 - Molotov
	arrWeaponData[19][ac_WeaponDamage] = 9.9; // 19 - Vehicle M4 (custom)
	arrWeaponData[20][ac_WeaponDamage] = 46.2; // 20 - Vehicle minigun (custom)
	arrWeaponData[21][ac_WeaponDamage] = 0.0; // 21
	arrWeaponData[22][ac_WeaponDamage] = 8.25; // 22 - Colt 45
	arrWeaponData[23][ac_WeaponDamage] = 13.2; // 23 - Silenced
	arrWeaponData[24][ac_WeaponDamage] = 46.2; // 24 - Deagle
	arrWeaponData[25][ac_WeaponDamage] = 3.3; // 25 - Shotgun
	arrWeaponData[26][ac_WeaponDamage] = 3.3; // 26 - Sawed-off
	arrWeaponData[27][ac_WeaponDamage] = 4.95; // 27 - Spas
	arrWeaponData[28][ac_WeaponDamage] = 6.6; // 28 - UZI
	arrWeaponData[29][ac_WeaponDamage] = 8.25; // 29 - MP5
	arrWeaponData[30][ac_WeaponDamage] = 9.9; // 30 - AK47
	arrWeaponData[31][ac_WeaponDamage] = 9.9; // 31 - M4
	arrWeaponData[32][ac_WeaponDamage] = 6.6; // 32 - Tec9
	arrWeaponData[33][ac_WeaponDamage] = 24.75; // 33 - Cuntgun
	arrWeaponData[34][ac_WeaponDamage] = 41.25; // 34 - Sniper
	arrWeaponData[35][ac_WeaponDamage] = 82.5; // 35 - Rocket launcher
	arrWeaponData[36][ac_WeaponDamage] = 82.5; // 36 - Heatseeker
	arrWeaponData[37][ac_WeaponDamage] = 1.0; // 37 - Flamethrower
	arrWeaponData[38][ac_WeaponDamage] = 46.2; // 38 - Minigun
	arrWeaponData[39][ac_WeaponDamage] = 82.5; // 39 - Satchel
	arrWeaponData[40][ac_WeaponDamage] = 0.0; // 40 - Detonator
	arrWeaponData[41][ac_WeaponDamage] = 0.33; // 41 - Spraycan
	arrWeaponData[42][ac_WeaponDamage] = 0.33; // 42 - Fire extinguisher
	arrWeaponData[43][ac_WeaponDamage] = 0.0; // 43 - Camera
	arrWeaponData[44][ac_WeaponDamage] = 0.0; // 44 - Night vision
	arrWeaponData[45][ac_WeaponDamage] = 0.0;// 45 - Infrared
	arrWeaponData[46][ac_WeaponDamage] = 0.0; // 46 - Parachute
	arrWeaponData[47][ac_WeaponDamage] = 0.0; // 47 - Fake pistol
	arrWeaponData[48][ac_WeaponDamage] = 2.64; // 48 - Pistol whip (custom)
	arrWeaponData[49][ac_WeaponDamage] = 9.9; // 49 - Vehicle
	arrWeaponData[50][ac_WeaponDamage] = 330.0; // 50 - Helicopter blades
	arrWeaponData[51][ac_WeaponDamage] = 82.5; // 51 - Explosion
	arrWeaponData[52][ac_WeaponDamage] = 1.0; // 52 - Car park (custom)
	arrWeaponData[53][ac_WeaponDamage] = 1.0; // 53 - Drowning
	arrWeaponData[54][ac_WeaponDamage] = 165.0;  // 54 - Splat
}

stock AC_AddRejectedHit(playerid, damagedid, reason, weapon, inf0 = 0, inf1 = 0, inf2 = 0) {

	new idx = ac_RejectedHitsIdx[playerid];
	if (arrRejectedHitData[playerid][idx][acr_iTime]) {
		idx += 1;

		if (idx >= sizeof(arrRejectedHitData[])) {
			idx = 0;
		}

		ac_RejectedHitsIdx[playerid] = idx;
	}

	arrRejectedHitData[playerid][idx][acr_iReason] = reason;
	arrRejectedHitData[playerid][idx][acr_iTime] = gettime();
	arrRejectedHitData[playerid][idx][acr_iWeaponID] = weapon;
	arrRejectedHitData[playerid][idx][acr_iDamagedID] = damagedid;
	arrRejectedHitData[playerid][idx][acr_iInfo][0] = inf0;
	arrRejectedHitData[playerid][idx][acr_iInfo][2] = inf1;
	arrRejectedHitData[playerid][idx][acr_iInfo][2] = inf2;

	if (damagedid != INVALID_PLAYER_ID) {
		GetPlayerName(damagedid, arrRejectedHitData[playerid][idx][acr_szName], MAX_PLAYER_NAME);
	}
	else {
		arrRejectedHitData[playerid][idx][acr_szName][0] = '#';
		arrRejectedHitData[playerid][idx][acr_szName][1] = '\0';
	}
}

/*stock IsPlayerPaused(playerid) {

	return (GetTickCount() - ac_LastUpdate[playerid] > 2000);
}*/

stock IsPlayerSpawned(playerid) {

	if(ac_IsDead[playerid] || ac_BeingResynced[playerid]) {
		return false;
	}

	switch (GetPlayerState(playerid)) {
		case PLAYER_STATE_ONFOOT .. PLAYER_STATE_PASSENGER, PLAYER_STATE_SPAWNED: return true;
	}
	return false;
}

forward Float:AngleBetweenPoints(Float:x1, Float:y1, Float:x2, Float:y2);
stock Float:AngleBetweenPoints(Float:x1, Float:y1, Float:x2, Float:y2) {

	return -(90.0 - atan2(y1 - y2, x1 - x2));
}

forward GetPlayerSpeed(i);
stock GetPlayerSpeed(i) {

	new Float:fVel[3],
		iSpeed;

	if(IsPlayerInAnyVehicle(i)) GetVehicleVelocity(GetPlayerVehicleID(i), fVel[0], fVel[1], fVel[2]);
	else GetPlayerVelocity(i, fVel[0], fVel[1], fVel[2]);
	iSpeed = floatround(floatsqroot(((fVel[0]*fVel[0])+(fVel[1]*fVel[1]))+(fVel[2]*fVel[2])) * 136.666667, floatround_round);
	return iSpeed;
}

stock GetDriverID(iVehID) {

	if(iVehID == INVALID_VEHICLE_ID) return INVALID_PLAYER_ID;
	foreach(new i : Player) {
		if(GetPlayerVehicleID(i) == iVehID && GetPlayerState(i) == PLAYER_STATE_DRIVER) return i;
	}
	return INVALID_PLAYER_ID;
}

AC_Flag(playerid, processid, iExtraID = INVALID_PLAYER_ID, Float:fInfo = 0.0) {

	switch(processid) {
		
		case AC_PROAIM: {

			new iInfo = floatround(fInfo);
			if(iInfo > 6) AC_Process(playerid, AC_PROAIM, iExtraID);
			else { 
				format(szMiscArray, sizeof(szMiscArray), "{AA3333}[SYSTEM]: {FFFF00}AimBot - I flagged %s for using pro-aim (%dx) with their %s.", GetPlayerNameEx(playerid), iInfo, AC_GetWeaponName(iExtraID));
				ABroadCast(COLOR_LIGHTRED, szMiscArray, 2);
			}
		}
		case AC_AIMBOT: {
			if(fInfo > 20) AC_Process(playerid, AC_AIMBOT, iExtraID);
			else {
				format(szMiscArray, sizeof(szMiscArray), "{AA3333}[SYSTEM]: {FFFF00}AimBot - I flagged %s for a high hit-ratio (%.1f) with their %s.", GetPlayerNameEx(playerid), fInfo, AC_GetWeaponName(iExtraID));
				ABroadCast(COLOR_LIGHTRED, szMiscArray, 2);
			}
		}
	}
}

AC_Process(playerid, processid, iExtraID = INVALID_PLAYER_ID, iExtraID2 = -1, iExtraID3 = -1) {

	if(PlayerInfo[playerid][pAdmin] > 1 && PlayerInfo[playerid][pTogReports] == 0) return 1;
	if(!ac_ACToggle[processid]) return 1;
	arrAntiCheat[playerid][ac_iFlags][processid]++;
	if(GetPVarType(playerid, "ACCooldown") && GetPVarInt(playerid, "ACCooldown") == processid) return 1;
	SetPVarInt(playerid, "ACCooldown", processid);
	//if(arrAntiCheat[playerid][ac_iFlags][processid] == 1 || arrAntiCheat[playerid][ac_iFlags][processid] % 5 == 0) { // prevent spamming
	{
		new	szQuery[512];

		szMiscArray[0] = 0;
		switch(processid) {

			case AC_AIMBOT: {

				format(szMiscArray, sizeof(szMiscArray), "{AA3333}[SYSTEM]: {FFFF00}%s is using Aimbot", GetPlayerNameEx(playerid));
				ABroadCast(COLOR_LIGHTRED, szMiscArray, 2);

				new iTotalMiss = arrWeaponDataAC[playerid][ac_iBulletsFired][iExtraID] - arrWeaponDataAC[playerid][ac_iBulletsHit][iExtraID],
					iRelevantMiss = arrWeaponDataAC[playerid][ac_iBulletsFired][iExtraID] - arrWeaponDataAC[playerid][ac_iBulletsHit][iExtraID] - arrWeaponDataAC[playerid][ac_iFakeMiss][iExtraID];

				iRelevantMiss++; // Can't divide by 0;
				new Float:fRatio = arrWeaponDataAC[playerid][ac_iBulletsHit][iExtraID] / iRelevantMiss;

				format(szQuery, sizeof(szQuery), "INSERT INTO `ac` (`DBID`, `timestamp`, `type`, `flags`, `extraid`, `totalfired`, `hits`, `rmisses`, `tmisses`, `ratio`) VALUES (%d, NOW(), %d, %d, %d, %d, %d, %d, %d, %.1f)",
					PlayerInfo[playerid][pId], processid, arrAntiCheat[playerid][ac_iFlags][processid], iExtraID, arrWeaponDataAC[playerid][ac_iBulletsFired][iExtraID], arrWeaponDataAC[playerid][ac_iBulletsHit][iExtraID], iRelevantMiss, iTotalMiss, fRatio);
				mysql_tquery(MainPipeline, szQuery, false, "OnQueryFinish", "i", SENDDATA_THREAD);
				return 1;

			}
			case AC_CBUG: {

				PlayerPlaySound(playerid, 1055, 0.0, 0.0, 0.0);
				if(arrLastBulletData[playerid][acl_Valid] && floatabs(arrLastBulletData[playerid][acl_fHitPos][0]) > 1.0 && floatabs(arrLastBulletData[playerid][acl_fPos][1]) > 1.0) {
					SetPlayerFacingAngle(playerid, AngleBetweenPoints(
						arrLastBulletData[playerid][acl_fPos][0],
						arrLastBulletData[playerid][acl_fPos][1],
						arrLastBulletData[playerid][acl_fOrigin][0],
						arrLastBulletData[playerid][acl_fOrigin][1]
					));
				}

				new w, a;
				GetPlayerWeaponData(playerid, 0, w, a);

				ClearAnimationsEx(playerid, 1);
				ApplyAnimation(playerid, "PED", "IDLE_stance", 4.1, 0, 0, 0, 0, 0, 1);
				defer AC_ResetAnim(playerid);
				GivePlayerWeapon(playerid, w, 0);
				SendClientMessageEx(playerid, COLOR_LIGHTRED, "[SYSTEM]: Please do not C-Bug / CS.");
				return 1;
			}
			case AC_SILENTAIM: {

				format(szMiscArray, sizeof(szMiscArray), "[SYSTEM]: %s (%d) used Silent Aim (detector %d) on %s (%d) with a %s (warnings: %d).", GetPlayerNameExt(playerid), PlayerInfo[playerid][pId], iExtraID3, GetPlayerNameExt(iExtraID2), PlayerInfo[iExtraID2][pId], AC_GetWeaponName(iExtraID), arrAntiCheat[playerid][ac_iFlags][processid]);
				Log("logs/anticheat.log", szMiscArray);
				
				/*
				if(arrWeaponDataAC[playerid][ac_iBulletsHit][iExtraID] > 0) {
					
					new iTotalMiss = arrWeaponDataAC[playerid][ac_iBulletsFired][iExtraID] - arrWeaponDataAC[playerid][ac_iBulletsHit][iExtraID],
						iRelevantMiss = arrWeaponDataAC[playerid][ac_iBulletsFired][iExtraID] - arrWeaponDataAC[playerid][ac_iBulletsHit][iExtraID] - arrWeaponDataAC[playerid][ac_iFakeMiss][iExtraID];

					iRelevantMiss++; // Can't divide by 0;
					new Float:fRatio = arrWeaponDataAC[playerid][ac_iBulletsHit][iExtraID] / iRelevantMiss;

					format(szQuery, sizeof(szQuery), "INSERT INTO `ac` (`DBID`, `timestamp`, `type`, `flags`, `extraid`, `totalfired`, `hits`, `rmisses`, `tmisses`, `ratio`) VALUES (%d, NOW(), %d, %d, %d, %d, %d, %d, %d, %.1f)",
						PlayerInfo[playerid][pId], processid, arrAntiCheat[playerid][ac_iFlags][processid], iExtraID, arrWeaponDataAC[playerid][ac_iBulletsFired][iExtraID], arrWeaponDataAC[playerid][ac_iBulletsHit][iExtraID], iRelevantMiss, iTotalMiss, fRatio);
					mysql_tquery(MainPipeline, szQuery, false, "OnQueryFinish", "i", SENDDATA_THREAD);
				}
				*/

				SendClientMessageEx(playerid, COLOR_LIGHTRED, "[SYSTEM]: You were kicked for being desynced.");
				SetTimerEx("KickEx", 1000, 0, "i", playerid);

				format(szMiscArray, sizeof(szMiscArray), "{AA3333}[SYSTEM]: {FFFF00}%s is using Silent Aim (detector %d) on %s with a %s (warnings: %d).", GetPlayerNameExt(playerid), iExtraID3, GetPlayerNameExt(iExtraID2), AC_GetWeaponName(iExtraID), arrAntiCheat[playerid][ac_iFlags][processid]);
			}
			case AC_PROAIM: {

				format(szMiscArray, sizeof(szMiscArray), "{AA3333}[SYSTEM]: {FFFF00}%s is using Pro-Aim.", GetPlayerNameEx(playerid));
				ABroadCast(COLOR_LIGHTRED, szMiscArray, 2);

				new iTotalMiss = arrWeaponDataAC[playerid][ac_iBulletsFired][iExtraID] - arrWeaponDataAC[playerid][ac_iBulletsHit][iExtraID],
					iRelevantMiss = arrWeaponDataAC[playerid][ac_iBulletsFired][iExtraID] - arrWeaponDataAC[playerid][ac_iBulletsHit][iExtraID] - arrWeaponDataAC[playerid][ac_iFakeMiss][iExtraID];

				iRelevantMiss++; // Can't divide by 0;
				new Float:fRatio = arrWeaponDataAC[playerid][ac_iBulletsHit][iExtraID] / iRelevantMiss;

				format(szQuery, sizeof(szQuery), "INSERT INTO `ac` (`DBID`, `timestamp`, `type`, `flags`, `extraid`, `totalfired`, `hits`, `rmisses`, `tmisses`, `ratio`) VALUES (%d, NOW(), %d, %d, %d, %d, %d, %d, %d, %.1f)",
					PlayerInfo[playerid][pId], processid, arrAntiCheat[playerid][ac_iFlags][processid], iExtraID, arrWeaponDataAC[playerid][ac_iBulletsFired][iExtraID], arrWeaponDataAC[playerid][ac_iBulletsHit][iExtraID], iRelevantMiss, iTotalMiss, fRatio);
				mysql_tquery(MainPipeline, szQuery, false, "OnQueryFinish", "i", SENDDATA_THREAD);


				if(arrAntiCheat[playerid][ac_iFlags][processid] > 15) {
					
					SendClientMessageEx(playerid, COLOR_LIGHTRED, "[SYSTEM]: You were kicked for being desynced.");
					SetTimerEx("KickEx", 1000, 0, "i", playerid);
				}
				return 1;
			}
			case AC_RANGEHACKS: {

				format(szMiscArray, sizeof(szMiscArray), "{AA3333}[SYSTEM]: {FFFF00}%s is using range-hacks.", GetPlayerNameEx(playerid));
				ABroadCast(COLOR_LIGHTRED, szMiscArray, 2);

				new iTotalMiss = arrWeaponDataAC[playerid][ac_iBulletsFired][iExtraID] - arrWeaponDataAC[playerid][ac_iBulletsHit][iExtraID],
					iRelevantMiss = arrWeaponDataAC[playerid][ac_iBulletsFired][iExtraID] - arrWeaponDataAC[playerid][ac_iBulletsHit][iExtraID] - arrWeaponDataAC[playerid][ac_iFakeMiss][iExtraID];

				iRelevantMiss++; // Can't divide by 0;
				new Float:fRatio = arrWeaponDataAC[playerid][ac_iBulletsHit][iExtraID] / iRelevantMiss;

				format(szQuery, sizeof(szQuery), "INSERT INTO `ac` (`DBID`, `timestamp`, `type`, `flags`, `extraid`, `totalfired`, `hits`, `rmisses`, `tmisses`, `ratio`) VALUES (%d, NOW(), %d, %d, %d, %d, %d, %d, %d, %.1f)",
					PlayerInfo[playerid][pId], processid, arrAntiCheat[playerid][ac_iFlags][processid], iExtraID, arrWeaponDataAC[playerid][ac_iBulletsFired][iExtraID], arrWeaponDataAC[playerid][ac_iBulletsHit][iExtraID], iRelevantMiss, iTotalMiss, fRatio);
				mysql_tquery(MainPipeline, szQuery, false, "OnQueryFinish", "i", SENDDATA_THREAD);
				return 1;
			}
			case AC_SPEEDHACKS: format(szMiscArray, sizeof(szMiscArray), "{AA3333}[SYSTEM]: {FFFF00}%s is using speed hacks (B2, B5)", GetPlayerNameEx(playerid));
			case AC_VEHICLEHACKS: format(szMiscArray, sizeof(szMiscArray), "{AA3333}[SYSTEM]: {FFFF00}%s is using vehicle hacks.", GetPlayerNameEx(playerid));
			case AC_CMDSPAM: {

				if(iExtraID > 15) {
					SendClientMessageEx(playerid, COLOR_YELLOW, "You are muted from submitting commands.");
					format(szMiscArray, sizeof(szMiscArray), "{AA3333}AdmWarning{FFFF00}: %s is spamming commands (%d times).", GetPlayerNameEx(playerid), arrAntiCheat[playerid][ac_iCommandCount]);
				}
				else return SendClientMessageEx(playerid, COLOR_YELLOW, "You are muted from submitting commands.");
			}
			case AC_CARSURFING: {

				new Float:fPos[3];
				GetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]);
				SetPlayerPos(playerid, fPos[0] + 1.0, fPos[1] + 1.0, fPos[2]);
				PlayAnimEx(playerid, "PED", "BIKE_fallR", 4.1, 0, 1, 1, 1, 0, 1);
				SendClientMessageEx(playerid, COLOR_LIGHTRED, "[SYSTEM]: Please do not car surf.");
				return 1;
			}
			case AC_NINJAJACK: {

				defer AC_RevivePlayer(playerid);
				SendClientMessageEx(playerid, COLOR_LIGHTRED, "[SYSTEM]: You will be revived from the ninja-jacking in a few seconds.");
				SendClientMessageEx(iExtraID, COLOR_LIGHTRED, "[SYSTEM]: You were caught plausibly ninja-jacking. Admins were warned.");
				format(szMiscArray, sizeof(szMiscArray), "[SYSTEM]: %s has plausibly ninja-jacked %s.", GetPlayerNameEx(iExtraID), GetPlayerNameEx(playerid));
			}
			case AC_AIRBREAKING: format(szMiscArray, sizeof(szMiscArray), "{AA3333}[SYSTEM]: {FFFF00}%s is AirBreaking.", GetPlayerNameEx(playerid));
			case AC_HEALTHARMORHACKS: {
				
				SendClientMessageEx(playerid, COLOR_LIGHTRED, "[SYSTEM]: You were kicked for plausibly health/armor hacking.");
				SetTimerEx("KickEx", 1000, 0, "i", iExtraID);
				format(szMiscArray, sizeof(szMiscArray), "[SYSTEM]: %s was kicked for (plausibly!) health/armor hacking. Refrain from taking more action until fully tested.", GetPlayerNameEx(playerid));
			}			
			case AC_DIALOGSPOOFING: {
				format(szMiscArray, sizeof(szMiscArray), "[SYSTEM]: %s is spoofing dialogs (dialog ID: %d).", GetPlayerNameEx(playerid), iExtraID);
				Log("logs/anticheat.log", szMiscArray);
			}

			case AC_GHOSTHACKS: {

				SendClientMessageEx(playerid, COLOR_LIGHTRED, "[SYSTEM]: You were kicked for being desynced.");
				SetTimerEx("KickEx", 1000, 0, "i", playerid);
				format(szMiscArray, sizeof(szMiscArray), "[SYSTEM]: %s is using ghost hacks (Shooting while AFK). WeaponID: %d", GetPlayerNameEx(playerid), iExtraID);
				Log("logs/anticheat.log", szMiscArray);
			}
			case AC_DESYNC: {

				format(szMiscArray, sizeof(szMiscArray), "[SYSTEM]: %s has a weird camera mode (probably aimbot). Camera Mode: %d.", GetPlayerNameEx(playerid), iExtraID);
				Log("logs/anticheat.log", szMiscArray);
				SendClientMessageEx(playerid, COLOR_LIGHTRED, "[SYSTEM]: You were kicked for being desynced.");
				SetTimerEx("KickEx", 1000, 0, "i", playerid);
			}
		
		}
		ABroadCast(COLOR_LIGHTRED, szMiscArray, 2);
		format(szQuery, sizeof(szQuery), "INSERT INTO `ac` (`DBID`, `timestamp`, `type`, `flags`, `extraid`, `totalfired`, `hits`, `rmisses`, `tmisses`, `ratio`) VALUES (%d, NOW(), %d, %d, %d, %d, %d, %d, %d, %.1f)",
			PlayerInfo[playerid][pId], processid, arrAntiCheat[playerid][ac_iFlags][processid], iExtraID, -1, -1, -1, -1, 0.0);
		mysql_tquery(MainPipeline, szQuery, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	}
	return 1;
}

AC_IsPlayerSurfing(playerid) {

	if(zombieevent) return 0;
	if(PlayerInfo[playerid][pAdmin] >= 2) return 0;
	new iVehID = GetPlayerSurfingVehicleID(playerid);
	if(iVehID == INVALID_VEHICLE_ID) return 0;
	switch(GetVehicleModel(iVehID)) {

		case 403, 406, 422, 430, 432, 433, 443, 446, 452, 453, 454, 455, 470, 472, 473, 478, 484, 493, 500, 514, 515, 525, 543, 554, 578, 595, 605, 607: return 0;
		case 417, 423, 416, 425, 427, 431, 437, 447, 469, 487, 488, 497, 508, 528, 537, 538, 449, 548, 563, 56, 570, 577, 590, 592, 490: return 0; // often modded vehicles
	}
	return 1;
}

AC_KeySpamCheck(playerid) {
	if(GetPVarType(playerid, "PCMute")) {
		SendClientMessageEx(playerid, COLOR_WHITE, "[SYSTEM]: You are currently blocked from using interaction keys.");
		return 0;
	}
	if(ac_iPlayerKeySpam[playerid] > 4) {
		SetPVarInt(playerid, "PCMute", 1);
		defer AC_ResetPVars[10000](playerid, 1);
		SendClientMessageEx(playerid, COLOR_LIGHTRED, "[SYSTEM]: You were muted for spamming an interaction key. Refrain from doing it again.");
		return 0;
	}
	return 1;
}

AC_PlayerHealthArmor(playerid) {

	if(GetPVarInt(playerid, "Injured") == 1) return 0;
	if(PlayerInfo[playerid][pHospital] > 0) return 0;

	new Float:fData[4];
	GetPlayerHealth(playerid, fData[0]);
	GetHealth(playerid, fData[1]);
	GetPlayerArmour(playerid, fData[2]);
	GetArmour(playerid, fData[3]);
	if(fData[1] < -40) {
		format(szMiscArray, sizeof(szMiscArray), "[SYSTEM (BETA)]: %s (%d) may be health hacking.", GetPlayerNameEx(playerid), playerid);
		ABroadCast(COLOR_LIGHTRED, szMiscArray, 2);
	}
	if(fData[0] > (fData[1] + 10.0) || fData[2] > (fData[3] + 10.0)) return 1;
	return 0;
}


stock AC_GetWeaponName(weaponid) {

	new szWeaponName[32];
	if(!(0 <= weaponid <= sizeof(g_WeaponName))) format(szWeaponName, sizeof(szWeaponName), "Weapon %d", weaponid);
	else strunpack(szWeaponName, g_WeaponName[weaponid], sizeof(szWeaponName));
	return szWeaponName;
}

stock IsBulletWeapon(weaponid) {

	return (WEAPON_COLT45 <= weaponid <= WEAPON_SNIPER) || weaponid == WEAPON_MINIGUN;
}

stock IsHighRateWeapon(weaponid) {

	switch (weaponid) {
		case WEAPON_FLAMETHROWER, WEAPON_DROWN, WEAPON_CARPARK,
		     WEAPON_SPRAYCAN, WEAPON_FIREEXTINGUISHER: {
			return true;
		}
	}

	return false;
}

stock IsMeleeWeapon(weaponid) {

	return (WEAPON_UNARMED <= weaponid <= WEAPON_KATANA) || (WEAPON_DILDO <= weaponid <= WEAPON_CANE) || weaponid == WEAPON_PISTOLWHIP;
}

IsCorrectCameraMode(playerid) {

	switch(GetPlayerCameraMode(playerid)) {

		case 4, 7, 8, 15, 46, 51, 53, 55: return 1;
	}
	return 0;
}

CMD:system(playerid, params[]) {

	if(!IsAdminLevel(playerid, ADMIN_SENIOR)) return 1;
	format(szMiscArray, sizeof(szMiscArray), "Detecting\tStatus\n\
		Aimbot\t%s\n\
		(Auto) C-Bug\t%s\n\
		Silent Aim\t%s\n\
		Pro-Aim\t%s\n\
		Weapon Range Hacks\t%s\n\
		Speed Hacks (B2-B5)\t%s\n\
		Vehicle Hacks\t%s\n\
		Command Spamming\t%s\n\
		Car Surfing\t%s\n\
		Ninja Jacking\t%s\n\
		Ghost Hacks\t%s\n\
		Name Tags\t%s\n\
		Airbreaking\t%s\n\
		Infinite Stamina\t%s\n\
		---------\t%s\n\
		Dialog Spoofing\t%s\n\
		Rejected Hits\t%s\n\
		Desync\t%s",
		(ac_ACToggle[AC_AIMBOT] == true) ? ("{00FF00}On") : ("{FF0000}Off"),
		(ac_ACToggle[AC_CBUG] == true) ? ("{00FF00}On") : ("{FF0000}Off"),
		(ac_ACToggle[AC_SILENTAIM] == true) ? ("{00FF00}On") : ("{FF0000}Off"),
		(ac_ACToggle[AC_PROAIM] == true) ? ("{00FF00}On") : ("{FF0000}Off"),
		(ac_ACToggle[AC_RANGEHACKS] == true) ? ("{00FF00}On") : ("{FF0000}Off"),
		(ac_ACToggle[AC_SPEEDHACKS] == true) ? ("{00FF00}On") : ("{FF0000}Off"),
		(ac_ACToggle[AC_VEHICLEHACKS] == true) ? ("{00FF00}On") : ("{FF0000}Off"),
		(ac_ACToggle[AC_CMDSPAM] == true) ? ("{00FF00}On") : ("{FF0000}Off"),
		(ac_ACToggle[AC_CARSURFING] == true) ? ("{00FF00}On") : ("{FF0000}Off"),
		(ac_ACToggle[AC_NINJAJACK] == true) ? ("{00FF00}On") : ("{FF0000}Off"),
		(ac_ACToggle[AC_GHOSTHACKS] == true) ? ("{00FF00}On") : ("{FF0000}Off"),
		(ac_ACToggle[AC_NAMETAGS] == true) ? ("{00FF00}On") : ("{FF0000}Off"),
		(ac_ACToggle[AC_AIRBREAKING] == true) ? ("{00FF00}On") : ("{FF0000}Off"),
		(ac_ACToggle[AC_INFINITESTAMINA] == true) ? ("{00FF00}On") : ("{FF0000}Off"),
		(ac_ACToggle[AC_HEALTHARMORHACKS] == true) ? ("{00FF00}On") : ("{FF0000}Off"),
		(ac_ACToggle[AC_DIALOGSPOOFING] == true) ? ("{00FF00}On") : ("{FF0000}Off"),
		(ac_ACToggle[AC_REJECTHITS] == true) ? ("{00FF00}On") : ("{FF0000}Off"),
		(ac_ACToggle[AC_DESYNC] == true) ? ("{00FF00}On") : ("{FF0000}Off"));
	ShowPlayerDialogEx(playerid, DIALOG_AC_MAIN, DIALOG_STYLE_TABLIST_HEADERS, "[SYSTEM]: Anti-Cheat", szMiscArray, "Toggle", "");
	return 1;
}


CMD:aimcheck(playerid, params[]) {

	if(!IsAdminLevel(playerid, ADMIN_SENIOR)) return 1;

	new uPlayer,
		szTitle[32 + MAX_PLAYER_NAME];

	if(sscanf(params, "u", uPlayer)) return SendClientMessage(playerid, 0xFFFFFFFF, "Usage: /aimcheck [playerid/name]");
	if(!IsPlayerConnected(uPlayer)) return SendClientMessage(playerid, 0xFFFFFFFF, "You specified an invalid player.");

	format(szMiscArray, sizeof(szMiscArray), "Weapon (total fired)\tHit --- Real Miss (of Total Missed)\tRatio\n");

	new Float:fRatio,
		iTotalMiss,
		iRelevantMiss;

	for(new i; i < 46; ++i) {
		if(IsBulletWeapon(i)) {
			iTotalMiss = arrWeaponDataAC[uPlayer][ac_iBulletsFired][i] - arrWeaponDataAC[uPlayer][ac_iBulletsHit][i];
			iRelevantMiss = arrWeaponDataAC[uPlayer][ac_iBulletsFired][i] - arrWeaponDataAC[uPlayer][ac_iBulletsHit][i] - arrWeaponDataAC[uPlayer][ac_iFakeMiss][i];

			iRelevantMiss++;
			fRatio = arrWeaponDataAC[uPlayer][ac_iBulletsHit][i] / iRelevantMiss;
			
			if(arrWeaponDataAC[uPlayer][ac_iBulletsFired][i] < 30) {
				format(szMiscArray, sizeof(szMiscArray), "%s {FFFFFF}[IGNORE] %s (tot: %d)\tHit: %d --- Miss: %d (missed total: %d)\tRatio: %.1f\n", szMiscArray, AC_GetWeaponName(i), arrWeaponDataAC[uPlayer][ac_iBulletsFired][i],
					arrWeaponDataAC[uPlayer][ac_iBulletsHit][i], iRelevantMiss, iTotalMiss, fRatio);
			}
			else if(fRatio < 1.5) {
				format(szMiscArray, sizeof(szMiscArray), "%s {FFFFFF}%s (tot: %d)\tHit: %d --- Miss: %d (missed total: %d)\tRatio: %.1f\n", szMiscArray, AC_GetWeaponName(i), arrWeaponDataAC[uPlayer][ac_iBulletsFired][i],
					arrWeaponDataAC[uPlayer][ac_iBulletsHit][i], iRelevantMiss, iTotalMiss, fRatio);
			}
			else if(1.5 <= fRatio < 3.0) {
				format(szMiscArray, sizeof(szMiscArray), "%s {FFFF00}%s (tot: %d)\t{FFFF00}Hit: %d --- Miss: %d (missed total: %d)\t{FFFF00}Ratio: %.1f\n", szMiscArray, AC_GetWeaponName(i), arrWeaponDataAC[uPlayer][ac_iBulletsFired][i],
					arrWeaponDataAC[uPlayer][ac_iBulletsHit][i], iRelevantMiss, iTotalMiss, fRatio);
			}
			else {
				format(szMiscArray, sizeof(szMiscArray), "%s {FF0000}%s (tot: %d)\t{FF0000}Hit: %d --- Miss: %d (missed total: %d)\t{FF0000}Ratio: %.1f\n", szMiscArray, AC_GetWeaponName(i), arrWeaponDataAC[uPlayer][ac_iBulletsFired][i],
					arrWeaponDataAC[uPlayer][ac_iBulletsHit][i], iRelevantMiss, iTotalMiss, fRatio);
			}
		}
	}
	format(szTitle, sizeof(szTitle), "Aimbot Check | Weapon Data {FFFF00}(%s)", GetPlayerNameEx(uPlayer));
	ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_TABLIST_HEADERS, szTitle, szMiscArray, "<>", "");
	SendClientMessageEx(playerid, COLOR_YELLOW, "---------- [ ANTICHEAT ] ----------");
	SendClientMessageEx(playerid, COLOR_GRAD1, "Jingles:");
	SendClientMessageEx(playerid, COLOR_GRAD1, "");
	SendClientMessageEx(playerid, COLOR_GRAD1, "Player ratios for some weapons (especially Combat Shotguns (SPAS)) can be high even though they're not aimbotting.");
	format(szMiscArray, sizeof(szMiscArray), "Only make conclusions if the total shots fired is higher than approx. 50. TIMESTAMP: %s", date(gettime(), 3));
	SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
	SendClientMessageEx(playerid, COLOR_YELLOW, "------------------------------ ");
	return 1;
}

CMD:acflags(playerid, params[]) {

	if(!IsAdminLevel(playerid, ADMIN_SENIOR)) return 1;
	new uPlayer,
		szTitle[32 + MAX_PLAYER_NAME];

	if(sscanf(params, "u", uPlayer)) return SendClientMessage(playerid, 0xFFFFFFFF, "Usage: /acflags [playerid/name]");
	if(!IsPlayerConnected(uPlayer)) return SendClientMessage(playerid, 0xFFFFFFFF, "You specified an invalid player.");

	format(szMiscArray, sizeof(szMiscArray), "Name\tFlags");
	for(new i; i < AC_MAX; ++i) {

		switch(arrAntiCheat[uPlayer][ac_iFlags][i]) {

			case 0: format(szMiscArray, sizeof(szMiscArray), "%s\n{FFFFFF}%s\t%d", szMiscArray, ac_ACNames[i], arrAntiCheat[uPlayer][ac_iFlags][i]);
			case 1 .. 9: format(szMiscArray, sizeof(szMiscArray), "%s\n{FFFF00}%s\t{FFFF00}%d", szMiscArray, ac_ACNames[i], arrAntiCheat[uPlayer][ac_iFlags][i]);
			default: format(szMiscArray, sizeof(szMiscArray), "%s\n{FF0000}%s\t{FF0000}%d", szMiscArray, ac_ACNames[i], arrAntiCheat[uPlayer][ac_iFlags][i]);	
		}
	}
	format(szTitle, sizeof(szTitle), "AC System Flags | %s", GetPlayerNameEx(uPlayer));
	ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_TABLIST_HEADERS, szTitle, szMiscArray, "<>", "");
	return 1;
}

CMD:resetacflags(playerid, params[]) {

	if(!IsAdminLevel(playerid, ADMIN_SENIOR)) return 1;
	
	new uPlayer;

	if(sscanf(params, "u", uPlayer)) return SendClientMessage(playerid, 0xFFFFFFFF, "Usage: /resetacflags [playerid/name]");
	if(!IsPlayerConnected(uPlayer)) return SendClientMessage(playerid, 0xFFFFFFFF, "You specified an invalid player.");
	for(new i; i < AC_MAX; ++i) arrAntiCheat[uPlayer][ac_iFlags][i] = 0;
	format(szMiscArray, sizeof(szMiscArray), "You removed %s's anticheat flags.", GetPlayerNameEx(uPlayer));
	SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
	format(szMiscArray, sizeof(szMiscArray), "Administrator %s removed your anticheat flags.", GetPlayerNameEx(playerid));
	SendClientMessageEx(uPlayer, COLOR_YELLOW, szMiscArray);
	return 1;
}

CMD:rejects(playerid, params[]) {

	if(!IsAdminLevel(playerid, ADMIN_SENIOR)) return 1;
	new uPlayer,
		szTitle[32 + MAX_PLAYER_NAME];

	if(sscanf(params, "u", uPlayer)) return SendClientMessage(playerid, 0xFFFFFFFF, "Usage: /aimcheck [playerid/name]");
	if(!IsPlayerConnected(uPlayer)) return SendClientMessage(playerid, 0xFFFFFFFF, "You specified an invalid player.");
	
	format(szMiscArray, sizeof(szMiscArray), "Reason || Date\tWeapon\tTarget || (Info (0, 1, 2))\n");
	for(new idx; idx < AC_MAX_REJECTED_HITS; ++idx) {

		format(szMiscArray, sizeof(szMiscArray), "%s\n%s || %s\t%s\t%s || (Info: %d, %d, %d)",
			szMiscArray,
			g_HitRejectReasons[arrRejectedHitData[uPlayer][idx][acr_iReason]],
			date(arrRejectedHitData[uPlayer][idx][acr_iTime], 1),
			AC_GetWeaponName(arrRejectedHitData[uPlayer][idx][acr_iWeaponID]),
			GetPlayerNameEx(arrRejectedHitData[uPlayer][idx][acr_iDamagedID]),
			arrRejectedHitData[uPlayer][idx][acr_iInfo][0],
			arrRejectedHitData[uPlayer][idx][acr_iInfo][2],
			arrRejectedHitData[uPlayer][idx][acr_iInfo][2]);
	}
	format(szTitle, sizeof(szTitle), "Rejected Shots | Weapon Data (%s)", GetPlayerNameEx(uPlayer));
	ShowPlayerDialogEx(playerid, 32767, DIALOG_STYLE_TABLIST_HEADERS, szTitle, szMiscArray, "<>", "");
	return 1;
}

CMD:resetaim(playerid, params[]) {

	if(!IsAdminLevel(playerid, ADMIN_SENIOR)) return 1;
	foreach(new i : Player) {

		for(new j; j < 46; ++j) {
			arrWeaponDataAC[i][ac_iBulletsHit][j] = 0;
			arrWeaponDataAC[i][ac_iBulletsFired][j] = 0;
			arrWeaponDataAC[i][ac_iFakeMiss][j] = 0;
		}
	}
	return 1;
}

CMD:listacflags(playerid, params[]) {

	if(PlayerInfo[playerid][pAdmin] >= 2) {

		SendClientMessageEx(playerid, COLOR_GREEN, "____________________ Current players flagged by the anti pro-aim system: ____________________");
		foreach(new i: Player) {

			if(arrAntiCheat[i][ac_iFlags][AC_PROAIM] > 0) {

				format(szMiscArray, sizeof szMiscArray, "%s (ID: %d) - %d flags.", GetPlayerNameEx(i), i, PlayerInfo[i][pProAimFlags]);
				SendClientMessage(playerid, COLOR_GRAD1, szMiscArray);
			}
		}
		if(PlayerInfo[playerid][pAdmin] >= 4) SendClientMessage(playerid, COLOR_GRAD2, "NOTE: If you are certain a player is not hacking, you may use /resetpaflags.");
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD2, "You're not authorized to use this command.");
	return 1;
}

CMD:setproaimvar(playerid, params[]) {

	if(!IsAdminLevel(playerid, ADMIN_SENIOR, 1)) return 1;
	if(sscanf(params, "d", iShotVariance)) return SendClientMessageEx(playerid, COLOR_GRAD1, "USAGE: /setproaimvar [range]");

	if(!(0 < strval(params) < 30)) return SendClientMessageEx(playerid, COLOR_GRAD1, "Set it between 0 and 30.");
	iShotVariance = strval(params);
	format(szMiscArray, sizeof(szMiscArray), "You set the shot variance to: %d", iShotVariance);
	SendClientMessageEx(playerid, COLOR_GRAD1, szMiscArray);
	return 1;
}

CMD:ploss(playerid, params[]) {

	if(!IsAdminLevel(playerid, ADMIN_SENIOR, 1)) return 1;
	if(PLoss) PLoss = 0;
	else PLoss = 1;
	SendClientMessageEx(playerid, COLOR_GRAD1, "You toggled the packet loss function.");
	return 1;
}

/* Custom Anti-Aimbot by Jingles
1) Cheating (C), with C ∈ [true,false],
2) Player Moving (M p ) with M p ∈ [true, f alse],
3) Target moving (Mt) with Mt ∈ [true,false],
4) Changing aiming direction (deltaD), with deltaD ∈[true, f alse],
5) Distance from aiming target (D), with D ∈ [0,1,2,3] in which larger the value implies further away is the distance and,
6) Aiming accuracy (A) with A ∈ [0, 1, 2, 3] in which the lower the value implies higher is the aiming accuracy.

Using these data, one can obtain the following prior proba- bility distributions by counting frequencies and then normalize the values:
	1) P(Ct|Ct−1), and
	2) P(At|At−1,Ct,Mtp,Mt,△Dt,Dt),

Inferring the probability of cheating for any particular player follows the following steps.
At the very first time slice where t = 0, we initialize P(C ̃ = true) to 0.5 (i.e., a player is 0 equally likely to be a cheater or an honest player).
For each time slice t, the inference carries out in two stages: (See paper)



stock AC_BayesianNetwork(playerid, iTargetID) {

	if(!arrAntiCheat[playerid][ac_inTrainingMode]) return 1;
	
	new bool:iWasHit,
		iSpeed[2],
		bool:isPlayerMoving[2],
		Float:fDistanceToTarget,
		Float:fAimAccuracy[2],
		Float:fDeltaAimAccuracy,
		Float:fDeltaAimingDirection;

	if(iTargetID == INVALID_PLAYER_ID) {
		iTargetID = arrAntiCheat[playerid][ac_iLastTargetID];
		iWasHit = false;
	}
	else {
		arrAntiCheat[playerid][ac_iLastTargetID] = iTargetID;
		iWasHit = true;
	}

	iSpeed[0] = GetPlayerSpeed(playerid);
	iSpeed[1] = GetPlayerSpeed(iTargetID);
	if(iSpeed[0] > 0) isPlayerMoving[0] = true; // Mp
	if(iSpeed[1] > 0) isPlayerMoving[1] = true; // Mt

	GetPlayerFacingAngle(playerid, arrAntiCheat[playerid][ac_fPlayerAngle][0]); //delta D
	fDistanceToTarget = GetDistanceBetweenPlayers(playerid, iTargetID); //D


	GetPlayerCameraPos(playerid, arrAntiCheat[playerid][ac_fCamPos][0], arrAntiCheat[playerid][ac_fCamPos][1], arrAntiCheat[playerid][ac_fCamPos][2]);
	GetPlayerCameraFrontVector(playerid, arrAntiCheat[playerid][ac_fCamFVector][0], arrAntiCheat[playerid][ac_fCamFVector][1], arrAntiCheat[playerid][ac_fCamFVector][2]);

	if(arrAntiCheat[playerid][ac_fCamFVector][3] != 0) {

		fDeltaAimingDirection = arrAntiCheat[playerid][ac_fPlayerAngle][1]-arrAntiCheat[playerid][ac_fPlayerAngle][0];

		if(arrLastBulletData[playerid][acl_fTargetPos][0] != 0) {
			
			// t
			fAimAccuracy[0] = DistanceCameraTargetToLocation(
					arrAntiCheat[playerid][ac_fCamPos][0], arrAntiCheat[playerid][ac_fCamPos][1], arrAntiCheat[playerid][ac_fCamPos][2],
					arrLastBulletData[playerid][acl_fTargetPos][0], arrLastBulletData[playerid][acl_fTargetPos][1], arrLastBulletData[playerid][acl_fTargetPos][2],
					arrAntiCheat[playerid][ac_fCamFVector][0], arrAntiCheat[playerid][ac_fCamFVector][1], arrAntiCheat[playerid][ac_fCamFVector][2]
				);
			// t-1
			fAimAccuracy[1] = DistanceCameraTargetToLocation(
					arrAntiCheat[playerid][ac_fCamPos][0], arrAntiCheat[playerid][ac_fCamPos][1], arrAntiCheat[playerid][ac_fCamPos][2],
					arrLastBulletData[playerid][acl_fTargetPos][0], arrLastBulletData[playerid][acl_fTargetPos][1], arrLastBulletData[playerid][acl_fTargetPos][2],
					arrAntiCheat[playerid][ac_fCamFVector][3], arrAntiCheat[playerid][ac_fCamFVector][4], arrAntiCheat[playerid][ac_fCamFVector][5]
				);
		}
	}

	// Normalize:
	if(fDeltaAimingDirection < 0) fDeltaAimingDirection = fDeltaAimingDirection * -1; // Always positive.
	switch(fDeltaAimingDirection) {

		case 0 .. 10: fDeltaAimingDirection = 0;
		case 11 .. 40: fDeltaAimingDirection = 1;
		case 41 .. 100: fDeltaAimingDirection = 2;
		default: fDeltaAimingDirection = 3;
	}

	switch(fDistanceToTarget) {

		case 0 .. 5: fDistanceToTarget = 0;
		case 6 .. 10: fDistanceToTarget = 1;
		case 11 .. 20: fDistanceToTarget = 2;
		default: fDistanceToTarget = 3;
	}
	fDeltaAimAccuracy = fAimAccuracy[1] - fAimAccuracy[0];

	if(fAimAccuracy[0] <= 1.5) fAimAccuracy[0] = 0;
	if(1.5 < fAimAccuracy[0] <= 6) fAimAccuracy[0] = 1;
	if(6 < fAimAccuracy[0] <= 10) fAimAccuracy[0] = 2;
	if(fAimAccuracy[0] > 10) fAimAccuracy[0] = 3;

	if(fAimAccuracy[1] <= 1.5) fAimAccuracy[1] = 0;
	if(1.5 < fAimAccuracy[1] <= 6) fAimAccuracy[1] = 1;
	if(6 < fAimAccuracy[1] <= 10) fAimAccuracy[1] = 2;
	if(fAimAccuracy[1] > 10) fAimAccuracy[1] = 3;
	
	switch(fDeltaAimAccuracy) {

		case 0 .. 4: fDeltaAimAccuracy = 0;
		case 5 .. 7: fDeltaAimAccuracy = 1;
		case 8 .. 13: fDeltaAimAccuracy = 2;
		default: fDeltaAimAccuracy = 3;
	}

	
	arrAntiCheat[playerid][ac_fCamFVector][3] = arrAntiCheat[playerid][ac_fCamFVector][0];
	arrAntiCheat[playerid][ac_fCamFVector][4] = arrAntiCheat[playerid][ac_fCamFVector][1];
	arrAntiCheat[playerid][ac_fCamFVector][5] = arrAntiCheat[playerid][ac_fCamFVector][2];
	arrAntiCheat[playerid][ac_fPlayerAngle][1] = arrAntiCheat[playerid][ac_fPlayerAngle][0];

	
	format(szMiscArray, sizeof(szMiscArray), "IC: %d, TH: %d, MP: %d, MT: %d, DTT: %0.1f, DAimDir: %0.1f, AimAcc: %0.1f, AimAcc(t-1): %0.1f, DAimAcc: %0.1f", 
		arrAntiCheat[playerid][ac_iIsCheating], iWasHit, isPlayerMoving[0], isPlayerMoving[1], fDistanceToTarget, fDeltaAimingDirection, fAimAccuracy[0], fAimAccuracy[1], fDeltaAimAccuracy);
	SendClientMessageEx(playerid, COLOR_GRAD1, szMiscArray);


	format(szMiscArray, sizeof(szMiscArray), "INSERT INTO `aimbot` (`pID`, `Username`, `time`, `ischeating`, `truehit`, `accuracy`, `aimingdirection`, `playerspeed`, `targetspeed`, `distance`, `deltaaim`) VALUES \
		(%d, '%s', %d, %d, %d, %0.1f, %0.1f, %d, %d, %0.1f, %0.1f)",
		PlayerInfo[playerid][pId],
		GetPlayerNameExt(playerid),
		gettime(),
		arrAntiCheat[playerid][ac_iIsCheating],
		iWasHit,
		fAimAccuracy[0],
		fDeltaAimingDirection,
		iSpeed[0],
		iSpeed[1],
		fDistanceToTarget,
		fDeltaAimAccuracy);
	mysql_tquery(MainPipeline, szMiscArray, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	return 1;
}

stock AC_Probability(playerid, iTargetID) {

	new Float:fDeltaAimingDirection,
		Float:fPlayerAngle[2], //t and t=-1
		Float:fAimAccuracy[2], //t and t=-1
		Float:fDeltaCrossHair,
		Float:fDeltaAimAccuracy;

	new iSpeed[2], // 0 == player, 1 == target
		bool:isPlayerMoving[2], // 0 == player, 1 == target
		Float:fDistanceToTarget;

	if(iTargetID != INVALID_PLAYER_ID) {

		iSpeed[0] = GetPlayerSpeed(playerid);
		iSpeed[1] = GetPlayerSpeed(iTargetID);
		if(iSpeed[0] > 0) isPlayerMoving[0] = true; // Mp
		if(iSpeed[1] > 0) isPlayerMoving[1] = true; // Mt

		GetPlayerFacingAngle(playerid, fPlayerAngle[0]); //delta D
		fDistanceToTarget = GetDistanceBetweenPlayers(playerid, iTargetID); //D
	}

	GetPlayerCameraPos(playerid, arrAntiCheat[playerid][ac_fCamPos][0], arrAntiCheat[playerid][ac_fCamPos][1], arrAntiCheat[playerid][ac_fCamPos][2]);
	GetPlayerCameraFrontVector(playerid, arrAntiCheat[playerid][ac_fCamFVector][0], arrAntiCheat[playerid][ac_fCamFVector][1], arrAntiCheat[playerid][ac_fCamFVector][2]);
	if(arrAntiCheat[playerid][ac_fCamFVector][3] != 0) {

		fDeltaAimingDirection = fPlayerAngle[1]-fPlayerAngle[0];

		if(arrLastBulletData[playerid][acl_fTargetPos][0] != 0) {
			
			// t
			fAimAccuracy[0] = DistanceCameraTargetToLocation(
					arrAntiCheat[playerid][ac_fCamPos][0], arrAntiCheat[playerid][ac_fCamPos][1], arrAntiCheat[playerid][ac_fCamPos][2],
					arrLastBulletData[playerid][acl_fTargetPos][0], arrLastBulletData[playerid][acl_fTargetPos][1], arrLastBulletData[playerid][acl_fTargetPos][2],
					arrAntiCheat[playerid][ac_fCamFVector][0], arrAntiCheat[playerid][ac_fCamFVector][1], arrAntiCheat[playerid][ac_fCamFVector][2]
				);
			// t-1
			fAimAccuracy[1] = DistanceCameraTargetToLocation(
					arrAntiCheat[playerid][ac_fCamPos][0], arrAntiCheat[playerid][ac_fCamPos][1], arrAntiCheat[playerid][ac_fCamPos][2],
					arrLastBulletData[playerid][acl_fTargetPos][0], arrLastBulletData[playerid][acl_fTargetPos][1], arrLastBulletData[playerid][acl_fTargetPos][2],
					arrAntiCheat[playerid][ac_fCamFVector][3], arrAntiCheat[playerid][ac_fCamFVector][4], arrAntiCheat[playerid][ac_fCamFVector][5]
				);
		}
	}

	format(szMiscArray, sizeof(szMiscArray), "%s aimed %0.1f units from the target. Before, they aimed: %0.1f from the target. Target distance: %0.1f", GetPlayerNameEx(playerid), fAimAccuracy[0], fAimAccuracy[1], fDistanceToTarget);
	SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);

	format(szMiscArray, sizeof(szMiscArray), "%s aimed %0.1f units off from before.", GetPlayerNameEx(playerid), fDeltaAimingDirection);
	SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);


	if(fDeltaCrossHair < 2.0) fDeltaCrossHair = 0;
	else fDeltaCrossHair = 1;

	switch(fDeltaAimingDirection) {

		case 0 .. 19: fDeltaAimingDirection = 0;
		case 20 .. 45: fDeltaAimingDirection = 1;
		case 46 .. 75: fDeltaAimingDirection = 2;
		default: fDeltaAimingDirection = 3;
	}

	switch(fDistanceToTarget) {

		case 0 .. 4: fDistanceToTarget = 0;
		case 5 .. 9: fDistanceToTarget = 1;
		case 10 .. 14: fDistanceToTarget = 2;
		default: fDistanceToTarget = 3;
	}
	fDeltaAimAccuracy = fAimAccuracy[1] - fAimAccuracy[0];

	if(fAimAccuracy[0] <= 1.5) fAimAccuracy[0] = 0;
	if(1.5 < fAimAccuracy[0] <= 6) fAimAccuracy[0] = 1;
	if(6 < fAimAccuracy[0] <= 10) fAimAccuracy[0] = 2;
	if(fAimAccuracy[0] > 10) fAimAccuracy[0] = 3;

	if(fAimAccuracy[1] <= 1.5) fAimAccuracy[1] = 0;
	if(1.5 < fAimAccuracy[1] <= 6) fAimAccuracy[1] = 1;
	if(6 < fAimAccuracy[1] <= 10) fAimAccuracy[1] = 2;
	if(fAimAccuracy[1] > 10) fAimAccuracy[1] = 3;


	fPlayerAngle[1] = fPlayerAngle[0];
	arrAntiCheat[playerid][ac_fCamFVector][3] = arrAntiCheat[playerid][ac_fCamFVector][0];
	arrAntiCheat[playerid][ac_fCamFVector][4] = arrAntiCheat[playerid][ac_fCamFVector][1];
	arrAntiCheat[playerid][ac_fCamFVector][5] = arrAntiCheat[playerid][ac_fCamFVector][2];
	
	// The Equation:
	// Computation of our variables:
	// P(At|At−1,Ct,Mtp,Mt,Pt,Dt,△Dt,△At)
	arrAntiCheat[playerid][ac_fAimAccuracy] = isPlayerMoving[0] + isPlayerMoving[1] + fDeltaCrossHair + fDistanceToTarget + fDeltaAimingDirection + fAimAccuracy[0] + fDeltaAimAccuracy;
	// 1:
	arrAntiCheat[playerid][ac_fProbability] = arrAntiCheat[playerid][ac_fAimAccuracy] * arrAntiCheat[playerid][ac_iCheatingIndex][1] + arrAntiCheat[playerid][ac_fAimAccuracy] * (1.0 - arrAntiCheat[playerid][ac_iCheatingIndex][1]);

	// 2:
	new Float:T,
		Float:F;

	T = arrAntiCheat[playerid][ac_fAimAccuracy] * arrAntiCheat[playerid][ac_fProbability]; // etc.
	F = arrAntiCheat[playerid][ac_fAimAccuracy] * (arrAntiCheat[playerid][ac_fAimAccuracy] - arrAntiCheat[playerid][ac_fProbability]);

	arrAntiCheat[playerid][ac_iCheatingIndex][0] = T / (T + F); // on t=0;


	format(szMiscArray, sizeof(szMiscArray), "Prob: %0.1f, CI(t): %d, CI(t-1): %d, MP: %d, MT: %d, DCH: %d, DTT: %d, DAimDir: %d, AimAcc: %d, DAimAcc: %d", 
		arrAntiCheat[playerid][ac_fProbability], arrAntiCheat[playerid][ac_iCheatingIndex][0], arrAntiCheat[playerid][ac_iCheatingIndex][1],
		isPlayerMoving[0], isPlayerMoving[1], fDeltaCrossHair, fDistanceToTarget, fDeltaAimingDirection, fAimAccuracy[0], fDeltaAimAccuracy);
	SendClientMessageEx(playerid, COLOR_GRAD1, szMiscArray);

	arrAntiCheat[playerid][ac_iCheatingIndex][1] = arrAntiCheat[playerid][ac_iCheatingIndex][0]; // t-1 = t;


	format(szMiscArray, sizeof(szMiscArray), "INSERT INTO `aimbot` (`pID`, `time`, `ratio`, `accuracy`, `aimingdirection`, `playerspeed`, `targetspeed`, `distance`, `deltaaim`) VALUES \
		(%d, %d, %0.1f, %0.1f, %0.1f, %d, %d, %d, %d)",
		PlayerInfo[playerid][pId],
		gettime(),
		arrAntiCheat[playerid][ac_iCheatingIndex][0],
		fAimAccuracy[0],
		fDeltaAimingDirection,
		iSpeed[0],
		iSpeed[1],
		fDistanceToTarget,
		fDeltaAimAccuracy);
	mysql_tquery(MainPipeline, szMiscArray, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	return 1;
}

CMD:analytics(playerid, params[]) {

	if(!IsAdminLevel(playerid, ADMIN_SENIOR, 1)) return 1;

	new uPlayer;
	if(sscanf(params, "u", uPlayer)) return SendClientMessageEx(playerid, COLOR_GRAD1, "USAGE: /analytics [playerid / part of name]");

	if(!IsPlayerConnected(uPlayer)) return 1;

	format(szMiscArray, sizeof(szMiscArray), "Player: %s\n\n\
		Average Accuracy: %0.1f",
		GetPlayerNameEx(uPlayer),
		floatdiv(arrAntiCheat[uPlayer][ac_fAimAccuracy], ac_TotalShots[uPlayer]));

	ShowPlayerDialogEx(playerid, DIALOG_NOTHING, DIALOG_STYLE_MSGBOX, "Player Analytics", szMiscArray, "Okay", "");
	return 1;
}
*/

/*
CMD:setcheating(playerid, params[]) {

	if(!IsAdminLevel(playerid, ADMIN_SENIOR, 1)) return 1;

	new uPlayer;
	if(sscanf(params, "u", uPlayer)) return SendClientMessageEx(playerid, COLOR_GRAD1, "USAGE: /setcheating [0/1]");

	if(arrAntiCheat[uPlayer][ac_iIsCheating]) {

		format(szMiscArray, sizeof(szMiscArray), "You set %s to a honest player.", GetPlayerNameEx(uPlayer));
		SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
		arrAntiCheat[uPlayer][ac_iIsCheating] = 0;
	}
	else {

		format(szMiscArray, sizeof(szMiscArray), "You set %s to a cheating player.", GetPlayerNameEx(uPlayer));
		SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
		arrAntiCheat[uPlayer][ac_iIsCheating] = 1;

	}
	return 1;
}

CMD:settraining(playerid, params[]) {

	if(!IsAdminLevel(playerid, ADMIN_SENIOR, 1)) return 1;

	new uPlayer;
	if(sscanf(params, "u", uPlayer)) return SendClientMessageEx(playerid, COLOR_GRAD1, "USAGE: /settraining [0/1]");

	if(arrAntiCheat[uPlayer][ac_inTrainingMode]) {

		format(szMiscArray, sizeof(szMiscArray), "You removed %s from the BN training.", GetPlayerNameEx(uPlayer));
		SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
		arrAntiCheat[uPlayer][ac_inTrainingMode] = 0;
	}
	else {

		format(szMiscArray, sizeof(szMiscArray), "You added %s to the BN training.", GetPlayerNameEx(uPlayer));
		SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
		arrAntiCheat[uPlayer][ac_inTrainingMode] = 1;
	}
	return 1;
}
*/

/*
CMD:acresults(playerid, params[]) {

	if(!IsAdminLevel(playerid, ADMIN_SENIOR, 1)) return 1;
	mysql_tquery(MainPipeline, "SELECT * FROM `aimbot` WHERE `accuracy` = '3'", true, "OnACQueryResult", "i", 3);
	return 1;
}


new iACCountTracker[6],
	iFrequency,
	ACTrackCount;

forward OnACQueryResult(i);
public OnACQueryResult(i) {

	new iRows;
	iRows = cache_get_row_count(MainPipeline);

	for(iACCountTracker[0] = 0; iACCountTracker[0] < 2; iACCountTracker[0]++) { // ischeaitng
		for(iACCountTracker[1] = 0; iACCountTracker[1] < 4; iACCountTracker[1]++) { // aimingdirection
			for(iACCountTracker[2] = 0; iACCountTracker[2] < 2; iACCountTracker[2]++) { //playerspeed
				for(iACCountTracker[3] = 0; iACCountTracker[3] < 2; iACCountTracker[3]++) { //targetspeed
					for(iACCountTracker[4] = 0; iACCountTracker[4] < 4; iACCountTracker[4]++) { // distance
						for(iACCountTracker[5] = 0; iACCountTracker[5] < 4; iACCountTracker[5]++) ACSQLQuery(i, iRows); // deltaaim
					}
				}
			}
		}
	}
	i = i - 1;
	if(i < 0) return SendClientMessageToAll(-1, "done");
	else {
		format(szMiscArray, sizeof(szMiscArray), "SELECT * FROM `aimbot` WHERE `accuracy` = '%d'", i);
		mysql_tquery(MainPipeline, szMiscArray, true, "OnACQueryResult", "i", i);
	}
	return 1;
}

forward OnACQueryResult2(i, iRows);
public OnACQueryResult2(i, iRows) {

	iFrequency = cache_get_row_count(MainPipeline);
	printf("%d ::: %0.1f, %d, %d, %d, %d, %d, %d, %d", ACTrackCount, floatdiv(iFrequency, iRows) * 100, i, iACCountTracker[0], iACCountTracker[1], iACCountTracker[2], iACCountTracker[3], iACCountTracker[4], iACCountTracker[5]);
	format(szMiscArray, sizeof(szMiscArray), "INSERT INTO `aimbayesian` (`probability`, `ischeating`, `accuracy`, `aimingdirection`, `playerspeed`, `targetspeed`, `distance`, `deltaaim`) VALUES \
		(%0.1f, %d, %d, %d, %d, %d, %d, %d)",

		floatdiv(iFrequency, iRows) * 100, iACCountTracker[0], i, iACCountTracker[1], iACCountTracker[2], iACCountTracker[3], iACCountTracker[4], iACCountTracker[5]);
	mysql_tquery(MainPipeline, szMiscArray, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	ACTrackCount++;
}


stock ACSQLQuery(i, iRows) {

	format(szMiscArray, sizeof(szMiscArray), "SELECT * FROM `aimbot` WHERE `accuracy` = '%d' AND `ischeating` = '%d' \
			AND `aimingdirection` = '%d' AND `playerspeed` = '%d' AND `targetspeed` = '%d' AND `distance` = '%d' AND `deltaaim` = '%d'",
			i, iACCountTracker[0], iACCountTracker[1], iACCountTracker[2], iACCountTracker[3], iACCountTracker[4], iACCountTracker[5]);

	mysql_tquery(MainPipeline, szMiscArray, true, "OnACQueryResult2", "ii", i, iRows);
}
*/

/*
GetHealthArmorForLabel(playerid) {

	// -----
	new Float:fHealth,
		Float:fArmour;

	GetHealth(playerid, fHealth);
	GetArmour(playerid, fArmour);

	if(IsPlayerPaused(playerid)) {

		if(!fArmour) format(szMiscArray, sizeof(szMiscArray), "%s (%d)\n(Tabbed)\n\n{FF0000}-[%s{FF0000}]-", GetPlayerNameEx(playerid), playerid, GetPValueForLabel(fHealth));
		else format(szMiscArray, sizeof(szMiscArray), "%s (%d)\n(Tabbed)\n\n-[%s{FF0000}]-\n{FF0000}-[%s{FF0000}]-", GetPlayerNameEx(playerid), playerid, GetPValueForLabel(fArmour), GetPValueForLabel(fHealth));
	}
	else {

		if(!fArmour) format(szMiscArray, sizeof(szMiscArray), "%s (%d)\n\n{FF0000}-[%s{FF0000}]-", GetPlayerNameEx(playerid), playerid, GetPValueForLabel(fHealth));
		else format(szMiscArray, sizeof(szMiscArray), "%s (%d)\n\n-[%s]-\n{FF0000}-[%s{FF0000}]-", GetPlayerNameEx(playerid), playerid, GetPValueForLabel(fArmour), GetPValueForLabel(fHealth));

	}
	// ------

	if(IsPlayerPaused(playerid)) {

		format(szMiscArray, sizeof(szMiscArray), "%s (%d)\n(Tabbed)", GetPlayerNameEx(playerid), playerid);
	}
	else format(szMiscArray, sizeof(szMiscArray), "%s (%d)", GetPlayerNameEx(playerid), playerid);
	return szMiscArray;	
}
*/

/*
stock GetPValueForLabel(Float:fData) {

	new szString[128],
		iData;

	iData = floatround(fData);
	switch(iData) {

		case 0: strins(szString, "{000000}0", 0, sizeof(szString));
		case 1 .. 5: strins(szString, ".{000000}.....................", 0, sizeof(szString));
		case 6 .. 10: strins(szString, "..{000000}...................", 0, sizeof(szString));
		case 11 .. 15: strins(szString, "...{000000}.................", 0, sizeof(szString));
		case 16 .. 20: strins(szString, "....{000000}................", 0, sizeof(szString));
		case 21 .. 25: strins(szString, ".....{000000}...............", 0, sizeof(szString));
		case 26 .. 30: strins(szString, "......{000000}..............", 0, sizeof(szString));
		case 31 .. 35: strins(szString, ".......{000000}.............", 0, sizeof(szString));
		case 36 .. 40: strins(szString, "........{000000}............", 0, sizeof(szString));
		case 41 .. 45: strins(szString, ".........{000000}...........", 0, sizeof(szString));
		case 46 .. 50: strins(szString, "..........{000000}..........", 0, sizeof(szString));
		case 51 .. 55: strins(szString, "...........{000000}.........", 0, sizeof(szString));
		case 56 .. 60: strins(szString, "............{000000}........", 0, sizeof(szString));
		case 61 .. 65: strins(szString, ".............{000000}.......", 0, sizeof(szString));
		case 66 .. 70: strins(szString, "..............{000000}......", 0, sizeof(szString));
		case 71 .. 75: strins(szString, "................{000000}....", 0, sizeof(szString));
		case 76 .. 80: strins(szString, ".................{000000}...", 0, sizeof(szString));
		case 81 .. 85: strins(szString, "..................{000000}..", 0, sizeof(szString));
		case 90 .. 95: strins(szString, "...................{000000}.", 0, sizeof(szString));
		case 96 .. 300: strins(szString, "....................", 0, sizeof(szString));
		default: szString = "-------";
	}

	return szString;
}
*/

/*
CreatePlayerLabel(playerid) {

	PlayerLabel[playerid] = CreateDynamic3DTextLabel(GetHealthArmorForLabel(playerid), 0xFFFFFFFF, 0.0, 0.0, 0.15, 30, playerid, .testlos = 1);
}

CMD:playerlabel(playerid, params[]) {
	
	if(IsValidDynamic3DTextLabel(PlayerLabel[playerid])) {

		foreach(new i : Player) ShowPlayerNameTagForPlayer(i, playerid, true);
		DestroyDynamic3DTextLabel(PlayerLabel[playerid]);
		SendClientMessageEx(playerid, COLOR_GRAD1, "You turned off your player label.");
	}
	else {

		foreach(new i : Player) ShowPlayerNameTagForPlayer(i, playerid, false);
		PlayerLabel[playerid] = CreateDynamic3DTextLabel(GetHealthArmorForLabel(playerid), 0xFFFFFFFF, 0.0, 0.0, 0.25, 30, playerid, .testlos = 1);
		SendClientMessageEx(playerid, COLOR_GRAD1, "You turned on your player label.");
	}
	return 1;	
}
*/