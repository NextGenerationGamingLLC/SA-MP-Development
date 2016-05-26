/* Anti-Cheat v2.0
	[###] Jingles
*/

// add autocbug

#include <YSI\y_hooks>
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

#define 			AC_MAX_CONT_SHOTS			10
#define 			AC_MAX_REJECTED_HITS 		15
#define 			AC_MAX_DAMAGE_RANGES 		5



enum E_SHOT_INFO {
	acl_Tick,
	acl_Weapon,
	acl_HitType,
	acl_HitId,
	acl_Hits,
	Float:acl_fPos[3],
	Float:acl_fOrigin[3],
	Float:acl_fHitPos[3],
	Float:acl_fDistance,
	bool:acl_Valid,
}

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


new ac_iPlayerKeySpam[MAX_PLAYERS],
	ac_iVehicleDriverID[MAX_PLAYERS],
	ac_iLastVehicleID[MAX_PLAYERS],

	ac_TotalShots[MAX_PLAYERS],
	ac_HitsIssued[MAX_PLAYERS],
	bool:ac_ACToggle[AC_MAX],
	bool:ac_IsDead[MAX_PLAYERS],
	bool:ac_BeingResynced[MAX_PLAYERS];
	
static ac_LagCompMode;
static ac_LastUpdate[MAX_PLAYERS] = {-1, ...};
static ac_RejectedHitsIdx[MAX_PLAYERS];
static ac_iCBugFreeze[MAX_PLAYERS];
static ac_MaxShootRateSamples = 5;
static ac_MaxHitRateSamples = 5;
static arrLastBulletData[MAX_PLAYERS][E_SHOT_INFO];
static ac_LastBulletIdx[MAX_PLAYERS];
static ac_LastBulletTicks[MAX_PLAYERS][10];
static ac_LastBulletWeapons[MAX_PLAYERS][10];
static ac_LastExplosive[MAX_PLAYERS];
static ac_LastHitTicks[MAX_PLAYERS][10];
static ac_LastHitWeapons[MAX_PLAYERS][10];
static ac_LastHitIdx[MAX_PLAYERS];
static Float:ac_PlayerMaxHealth[MAX_PLAYERS] = {100.0, ...};
//static Float:ac_PlayerMaxArmour[MAX_PLAYERS] = {100.0, ...};
//static ac_LastSentHealth[MAX_PLAYERS];
//static ac_LastSentArmour[MAX_PLAYERS];
static bool:ac_DamageArmourToggle[2] = {false, ...};
static Float:ac_DamageDoneHealth[MAX_PLAYERS];
static Float:ac_DamageDoneArmour[MAX_PLAYERS];

// The fastest possible gap between weapon shots in milliseconds
static ac_MaxWeaponShootRate[] = {

	250, // 0 - Fist
	250, // 1 - Brass knuckles
	250, // 2 - Golf club
	250, // 3 - Nitestick
	250, // 4 - Knife
	250, // 5 - Bat
	250, // 6 - Shovel
	250, // 7 - Pool cue
	250, // 8 - Katana
	30, // 9 - Chainsaw
	250, // 10 - Dildo
	250, // 11 - Dildo 2
	250, // 12 - Vibrator
	250, // 13 - Vibrator 2
	250, // 14 - Flowers
	250, // 15 - Cane
	0, // 16 - Grenade
	0, // 17 - Teargas
	0, // 18 - Molotov
	20, // 19 - Vehicle M4 (custom)
	20, // 20 - Vehicle minigun (custom)
	0, // 21
	160, // 22 - Colt 45
	120, // 23 - Silenced
	120, // 24 - Deagle
	800, // 25 - Shotgun
	120, // 26 - Sawed-off
	120, // 27 - Spas
	50, // 28 - UZI
	90, // 29 - MP5
	90, // 30 - AK47
	90, // 31 - M4
	70, // 32 - Tec9
	800, // 33 - Cuntgun
	900, // 34 - Sniper
	0, // 35 - Rocket launcher
	0, // 36 - Heatseeker
	0, // 37 - Flamethrower
	20, // 38 - Minigun
	0, // 39 - Satchel
	0, // 40 - Detonator
	10, // 41 - Spraycan
	10, // 42 - Fire extinguisher
	0, // 43 - Camera
	0, // 44 - Night vision
	0, // 45 - Infrared
	0, // 46 - Parachute
	0, // 47 - Fake pistol
	400 // 48 - Pistol whip (custom)
};

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

// Whether the damage is applied directly to health (1) or is distributed between health and armour (0), and whether this rule applies only to the torso (1) or not (0)
static ac_DamageArmour[][2] = {
	{0, 0}, // 0 - Fist
	{0, 0}, // 1 - Brass knuckles
	{0, 0}, // 2 - Golf club
	{0, 0}, // 3 - Nitestick
	{0, 0}, // 4 - Knife
	{0, 0}, // 5 - Bat
	{0, 0}, // 6 - Shovel
	{0, 0}, // 7 - Pool cue
	{0, 0}, // 8 - Katana
	{0, 0}, // 9 - Chainsaw
	{0, 0}, // 10 - Dildo
	{0, 0}, // 11 - Dildo 2
	{0, 0}, // 12 - Vibrator
	{0, 0}, // 13 - Vibrator 2
	{0, 0}, // 14 - Flowers
	{0, 0}, // 15 - Cane
	{0, 0}, // 16 - Grenade
	{0, 0}, // 17 - Teargas
	{0, 0}, // 18 - Molotov
	{1, 1}, // 19 - Vehicle M4 (custom)
	{1, 1}, // 20 - Vehicle minigun (custom)
	{1, 0}, // 21
	{1, 1}, // 22 - Colt 45
	{1, 1}, // 23 - Silenced
	{1, 1}, // 24 - Deagle
	{1, 1}, // 25 - Shotgun
	{1, 1}, // 26 - Sawed-off
	{1, 1}, // 27 - Spas
	{1, 1}, // 28 - UZI
	{1, 1}, // 29 - MP5
	{1, 1}, // 30 - AK47
	{1, 1}, // 31 - M4
	{1, 1}, // 32 - Tec9
	{1, 1}, // 33 - Cuntgun
	{1, 1}, // 34 - Sniper
	{0, 0}, // 35 - Rocket launcher
	{0, 0}, // 36 - Heatseeker
	{0, 0}, // 37 - Flamethrower
	{1, 1}, // 38 - Minigun
	{0, 0}, // 39 - Satchel
	{0, 0}, // 40 - Detonator
	{0, 0}, // 41 - Spraycan
	{0, 0}, // 42 - Fire extinguisher
	{1, 0}, // 43 - Camera
	{1, 0}, // 44 - Night vision
	{1, 0}, // 45 - Infrared
	{1, 0}, // 46 - Parachute
	{1, 0}, // 47 - Fake pistol
	{0, 0}, // 48 - Pistol whip (custom)
	{0, 0}, // 49 - Vehicle
	{0, 1}, // 50 - Helicopter blades
	{0, 0}, // 51 - Explosion
	{0, 0}, // 52 - Car park
	{0, 0}, // 53 - Drowning
	{0, 0}  // 54 - Splat
};

// Weapons allowed in OnPlayerGiveDamage
static const ac_ValidDamageGiven[] = {
	1, // 0 - Fist
	1, // 1 - Brass knuckles
	1, // 2 - Golf club
	1, // 3 - Nitestick
	1, // 4 - Knife
	1, // 5 - Bat
	1, // 6 - Shovel
	1, // 7 - Pool cue
	1, // 8 - Katana
	1, // 9 - Chainsaw
	1, // 10 - Dildo
	1, // 11 - Dildo 2
	1, // 12 - Vibrator
	1, // 13 - Vibrator 2
	1, // 14 - Flowers
	1, // 15 - Cane
	0, // 16 - Grenade
	0, // 17 - Teargas
	0, // 18 - Molotov
	0, // 19 - Vehicle M4 (custom)
	0, // 20 - Vehicle minigun
	0, // 21
	1, // 22 - Colt 45
	1, // 23 - Silenced
	1, // 24 - Deagle
	1, // 25 - Shotgun
	1, // 26 - Sawed-off
	1, // 27 - Spas
	1, // 28 - UZI
	1, // 29 - MP5
	1, // 30 - AK47
	1, // 31 - M4
	1, // 32 - Tec9
	1, // 33 - Cuntgun
	1, // 34 - Sniper
	0, // 35 - Rocket launcher
	0, // 36 - Heatseeker
	0, // 37 - Flamethrower
	1, // 38 - Minigun
	0, // 39 - Satchel
	0, // 40 - Detonator
	1, // 41 - Spraycan
	1, // 42 - Fire extinguisher
	0, // 43 - Camera
	0, // 44 - Night vision
	0, // 45 - Infrared
	1  // 46 - Parachute
};

// Weapons allowed in OnPlayerTakeDamage
// 2 = valid in both OnPlayerGiveDamage and OnPlayerTakeDamage
static const ac_ValidDamageTaken[] = {
	1, // 0 - Fist
	1, // 1 - Brass knuckles
	1, // 2 - Golf club
	1, // 3 - Nitestick
	1, // 4 - Knife
	1, // 5 - Bat
	1, // 6 - Shovel
	1, // 7 - Pool cue
	1, // 8 - Katana
	1, // 9 - Chainsaw
	1, // 10 - Dildo
	1, // 11 - Dildo 2
	1, // 12 - Vibrator
	1, // 13 - Vibrator 2
	1, // 14 - Flowers
	1, // 15 - Cane
	0, // 16 - Grenade
	0, // 17 - Teargas
	0, // 18 - Molotov
	0, // 19 - Vehicle M4 (custom)
	0, // 20 - Vehicle minigun (custom)
	0, // 21
	1, // 22 - Colt 45
	1, // 23 - Silenced
	1, // 24 - Deagle
	1, // 25 - Shotgun
	1, // 26 - Sawed-off
	1, // 27 - Spas
	1, // 28 - UZI
	1, // 29 - MP5
	1, // 30 - AK47
	1, // 31 - M4
	1, // 32 - Tec9
	1, // 33 - Cuntgun
	1, // 34 - Sniper
	0, // 35 - Rocket launcher
	0, // 36 - Heatseeker
	2, // 37 - Flamethrower
	1, // 38 - Minigun
	0, // 39 - Satchel
	0, // 40 - Detonator
	1, // 41 - Spraycan
	1, // 42 - Fire extinguisher
	0, // 43 - Camera
	0, // 44 - Night vision
	0, // 45 - Infrared
	1, // 46 - Parachute
	0, // 47 - Fake pistol
	0, // 48 - Pistol whip (custom)
	2, // 49 - Vehicle
	2, // 50 - Helicopter blades
	2, // 51 - Explosion
	0, // 52 - Car park (custom)
	2, // 53 - Drowning
	2  // 54 - Splat
};


#assert DAMAGE_TYPE_MULTIPLIER == 0
#assert DAMAGE_TYPE_STATIC == 1

// Whether the damage is multiplied by the given/taken value (0) or always the same value (1)
static ac_DamageType[] = {
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
	1, // 17 - Teargas
	0, // 18 - Molotov
	1, // 19 - Vehicle M4 (custom)
	1, // 20 - Vehicle minigun (custom)
	0, // 21
	1, // 22 - Colt 45
	1, // 23 - Silenced
	1, // 24 - Deagle
	1, // 25 - Shotgun
	1, // 26 - Sawed-off
	1, // 27 - Spas
	1, // 28 - UZI
	1, // 29 - MP5
	1, // 30 - AK47
	1, // 31 - M4
	1, // 32 - Tec9
	1, // 33 - Cuntgun
	1, // 34 - Sniper
	0, // 35 - Rocket launcher
	0, // 36 - Heatseeker
	0, // 37 - Flamethrower
	1, // 38 - Minigun
	0, // 39 - Satchel
	0, // 40 - Detonator
	1, // 41 - Spraycan
	1, // 42 - Fire extinguisher
	0, // 43 - Camera
	0, // 44 - Night vision
	0, // 45 - Infrared
	0, // 46 - Parachute
	0, // 47 - Fake pistol
	1, // 48 - Pistol whip (custom)
	1, // 49 - Vehicle
	1, // 50 - Helicopter blades
	0, // 51 - Explosion
	0, // 52 - Car park
	0, // 53 - Drowning
	0  // 54 - Splat
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
	AC_NO_ERROR,
	AC_NO_ISSUER,
	AC_NO_DAMAGED,
	AC_INVALID_DAMAGE,
	AC_INVALID_DISTANCE
}

enum {
	DAMAGE_TYPE_MULTIPLIER,
	DAMAGE_TYPE_STATIC,
	DAMAGE_TYPE_RANGE_MULTIPLIER,
	DAMAGE_TYPE_RANGE
}

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


hook OnGameModeInit() {
	
	for(new i = 1; i < sizeof(ac_ACToggle); ++i) ac_ACToggle[i] = false;
	/* Default On: */
	ac_ACToggle[AC_CARSURFING] = true;
	ac_ACToggle[AC_NINJAJACK] = true;

	AC_InitWeaponData();
	ac_LagCompMode = GetServerVarAsInt("lagcompmode");
}

hook OnPlayerConnect(playerid) {

	new iTick = GetTickCount();
	arrAntiCheat[playerid][ac_iCommandCount] = 0;
	arrAntiCheat[playerid][ac_iVehID] = -1;
	arrAntiCheat[playerid][ac_fPos][0] = 0;
	arrAntiCheat[playerid][ac_fPos][1] = 0;
	arrAntiCheat[playerid][ac_fPos][2] = 0;
	arrAntiCheat[playerid][ac_fSpeed] = 0;
	for(new i; i < AC_MAX; ++i) arrAntiCheat[playerid][ac_iFlags][i] = 0;
	Bit_Off(arrPAntiCheat[playerid], ac_bitValidPlayerPos);
	Bit_Off(arrPAntiCheat[playerid], ac_bitValidSpectating);

	ac_LastUpdate[playerid] = iTick;
	ac_PlayerMaxHealth[playerid] = 100.0;
	// ac_PlayerMaxArmour[playerid] = 100.0;
	ac_LastExplosive[playerid] = 0;
	ac_LastBulletIdx[playerid] = 0;
	ac_LastHitIdx[playerid] = 0;
	ac_RejectedHitsIdx[playerid] = 0;
	ac_TotalShots[playerid] = 0;
	ac_HitsIssued[playerid] = 0;
	ac_IsDead[playerid] = false;
	// ac_PreviousHitI[playerid] = 0;
	ac_iCBugFreeze[playerid] = 0;

	/*
	for (new i = 0; i < sizeof(s_PreviousHits[]); i++) {
		ac_PreviousHits[playerid][i][e_Tick] = 0;
	}
	*/

	arrLastBulletData[playerid][acl_Tick] = 0;
	arrLastBulletData[playerid][acl_Weapon] = 0;
	arrLastBulletData[playerid][acl_HitType] = HIT_INVALID_HITTYPE;
	arrLastBulletData[playerid][acl_HitId] = INVALID_PLAYER_ID;
	arrLastBulletData[playerid][acl_fPos][0] = 0;
	arrLastBulletData[playerid][acl_fPos][1] = 0;
	arrLastBulletData[playerid][acl_fPos][2] = 0;
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
}

hook OnPlayerUpdate(playerid) {

	if(ac_ACToggle[AC_SPEEDHACKS]) AC_SpeedHacks(playerid);
    if(IsPlayerInAnyVehicle(playerid)){

		if(GetPlayerVehicleID(playerid) != arrAntiCheat[playerid][ac_iVehID]) {

			arrAntiCheat[playerid][ac_iVehID] = -1;
			
			new Float:fPos[3];
			GetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]);
			SetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]+1); 
			AC_Process(playerid, AC_VEHICLEHACKS);
		} 
	} 
	ac_LastUpdate[playerid] = GetTickCount();
	return 1;
}

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

				AC_Process(playerid, AC_CBUG); //GetPlayerWeapon(playerid));
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

/*
hook OnPlayerRequestClass(playerid, classid) {
	if(ac_IsDead[playerid]) ac_IsDead[playerid] = false;
}
*/
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

	switch(dialogid) {

		case DIALOG_AC_MAIN: {

			if(response) {
			
				if(ac_ACToggle[listitem]) {
					format(szMiscArray, sizeof(szMiscArray), "[SYSTEM] %s turned off the %s detection.", GetPlayerNameEx(playerid), AC_GetACName(listitem));
					ac_ACToggle[listitem] = false;
				}
				else {
					format(szMiscArray, sizeof(szMiscArray), "[SYSTEM] %s turned on the %s detection.", GetPlayerNameEx(playerid), AC_GetACName(listitem));
					ac_ACToggle[listitem] = true;
				}
				ABroadCast(COLOR_LIGHTRED, szMiscArray, 2);
			}
			// else SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot turn these on yet.");
		}
	}
	return 1;
}


public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ) {

	new vehmodel = GetVehicleModel(GetPlayerVehicleID(playerid));

	szMiscArray[0] = 0;

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

	if(hittype == BULLET_HIT_TYPE_PLAYER)
	{
		if(!IsPlayerStreamedIn(playerid, hitid) || !IsPlayerStreamedIn(hitid, playerid)) return 0;
	}
	if(weaponid == 24 || weaponid == 25 || weaponid == 26 || weaponid == 34/* || weaponid == 31*/)
	{
		++PlayerShots[playerid];
	}
	if(GetPVarInt(playerid, "FireStart") == 1)
	{
		if(fX != 0 && fY != 0 && hittype != BULLET_HIT_TYPE_PLAYER && hittype != BULLET_HIT_TYPE_VEHICLE)
		{
			if(gettime() > GetPVarInt(playerid, "fCooldown")) CreateStructureFire(fX, fY, fZ, GetPlayerVirtualWorld(playerid));
		}
	}
	
	/*
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
	*/

	arrLastBulletData[playerid][acl_Valid] = false;
	arrLastBulletData[playerid][acl_Hits] = false;

	// C-Bug
	if(ac_iCBugFreeze[playerid] && GetTickCount() - ac_iCBugFreeze[playerid] < 900) {
		return 0;
	}
	ac_iCBugFreeze[playerid] = 0;

	// Desync
	new damagedid = INVALID_PLAYER_ID;
	if (hittype == BULLET_HIT_TYPE_PLAYER && hitid != INVALID_PLAYER_ID) {
		
		if(!IsPlayerConnected(hitid)) {
			AC_AddRejectedHit(playerid, hitid, HIT_DISCONNECTED, weaponid, hittype);
			return 0;
		}
		damagedid = hitid;
	}

	// Invalid hit type
	/*
	if(hittype < 0 || hittype > 4) {
		AC_AddRejectedHit(playerid, damagedid, HIT_INVALID_HITTYPE, weaponid, hittype);
		return 0;
	}
	*/

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

	new Float:fOriginX, Float:fOriginY, Float:fOriginZ, Float:fHitPosX, Float:fHitPosY, Float:fHitPosZ;
	new Float:x, Float:y, Float:z;

	GetPlayerPos(playerid, x, y, z);
	GetPlayerLastShotVectors(playerid, fOriginX, fOriginY, fOriginZ, fHitPosX, fHitPosY, fHitPosZ);

	new Float:fDistance = VectorSize(fOriginX - fHitPosX, fOriginY - fHitPosY, fOriginZ - fHitPosZ);
	new Float:origin_dist = VectorSize(fOriginX - x, fOriginY - y, fOriginZ - z);

	if(origin_dist > 15.0) {
		
		new iVehCheck = IsPlayerInAnyVehicle(hitid) || GetPlayerSurfingVehicleID(playerid);
		if((!iVehCheck && GetPlayerSurfingVehicleID(playerid) == INVALID_VEHICLE_ID) || origin_dist > 50.0) {
			AC_AddRejectedHit(playerid, damagedid, HIT_TOO_FAR_FROM_ORIGIN, weaponid, _:origin_dist);
			return 0;
		}
	}

	// Bullet range check.
	if(hittype != BULLET_HIT_TYPE_NONE) {
		if(fDistance > ac_WeaponRange[weaponid]) {
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

			new Float:fHitDist = GetPlayerDistanceFromPoint(hitid, fHitPosX, fHitPosY, fHitPosZ);
			new iVehCheck = IsPlayerInAnyVehicle(hitid);

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

	#if defined AC_DEBUG
	if(ac_TotalShots[playerid] > 1) {
		new prev_tick_idx = (idx - 1) % sizeof(ac_LastBulletTicks[]);

		// JIT plugin fix
		if (prev_tick_idx < 0) {
			prev_tick_idx += sizeof(ac_LastBulletTicks[]);
		}

		new prev_tick = ac_LastBulletTicks[playerid][prev_tick_idx];

		// AC_SendDebugMessage(playerid, "(shot) last: %d last 3: %d", iTick - prev_tick, AverageShootRate(playerid, 3));
	}
	#endif

	/* LOG FUNCTIONS */
	arrLastBulletData[playerid][acl_Tick] = GetTickCount();
	arrLastBulletData[playerid][acl_Weapon] = weaponid;
	arrLastBulletData[playerid][acl_HitType] = hittype;
	arrLastBulletData[playerid][acl_HitId] = hitid;
	arrLastBulletData[playerid][acl_fPos][0] = fX;
	arrLastBulletData[playerid][acl_fPos][1] = fY;
	arrLastBulletData[playerid][acl_fPos][2] = fZ;
	arrLastBulletData[playerid][acl_fOrigin][0] = fOriginX;
	arrLastBulletData[playerid][acl_fOrigin][1] = fOriginY;
	arrLastBulletData[playerid][acl_fOrigin][2] = fOriginZ;
	arrLastBulletData[playerid][acl_fHitPos][0] = fHitPosX;
	arrLastBulletData[playerid][acl_fHitPos][1] = fHitPosY;
	arrLastBulletData[playerid][acl_fHitPos][2] = fHitPosZ;
	arrLastBulletData[playerid][acl_fDistance] = fDistance;
	arrLastBulletData[playerid][acl_Hits] = 0;


	/*if(IsValidDynamicObject(iObject)) DestroyDynamicObject(iObject);
	iObject = CreateDynamicObject(1238, fHitPosX, fHitPosY, fHitPosZ, 0.0, 0.0, 0.0);
	*/
	// Bullet destination comparison
	/*
	new Float:fPlayerDistance;
	foreach(new i : Player) {

		fPlayerDistance = GetPlayerDistanceFromPoint(i, arrLastBulletData[playerid][acl_fHitPos][0], arrLastBulletData[playerid][acl_fHitPos][1], arrLastBulletData[playerid][acl_fHitPos][2]);
		if(fPlayerDistance < 2.5)
		{
			new Float:fPos[3],
				Float:fAngle[2];

			GetPlayerFacingAngle(playerid, fAngle[0]);
			fAngle[1] = AngleBetweenPoints(fPos[0], fPos[1], arrLastBulletData[playerid][acl_fHitPos][0], arrLastBulletData[playerid][acl_fHitPos][1]);
			GetPlayerPos(i, fPos[0], fPos[1], fPos[2]);
			format(szMiscArray, sizeof(szMiscArray), "%s is %.1f meters away from %s's last bullet.", GetPlayerNameEx(playerid), fPlayerDistance, GetPlayerNameEx(i));
			SendClientMessageToAll(0xFFFFFFFF, szMiscArray);
			format(szMiscArray, sizeof(szMiscArray), "Target: %.1f, %.1f, %.1f | Bullet: %.1f, %.1f, %.1f", fPos[0], fPos[1], fPos[2], arrLastBulletData[playerid][acl_fHitPos][0], arrLastBulletData[playerid][acl_fHitPos][1], arrLastBulletData[playerid][acl_fHitPos][2]);
			SendClientMessageToAll(0xFFFFFFFF, szMiscArray);

			format(szMiscArray, sizeof(szMiscArray), "Aim Angle: %.1f | My Angle: %.1f", fAngle[1], fAngle[0]);
			SendClientMessageToAll(0xFFFFFFFF, szMiscArray);

			SetPlayerFacingAngle(playerid, fAngle[1]);

			// Real Miss
			arrWeaponDataAC[playerid][ac_iFakeMiss][weaponid]--;
		}
	}
	*/

	// AimBot Player Scheme
	arrWeaponDataAC[playerid][ac_iBulletsFired][weaponid]++;
	if(hittype == BULLET_HIT_TYPE_PLAYER && ac_MaxWeaponContShots[weaponid] && !IsPlayerPaused(hitid)) {

    	new Float:fSpeed = GetPlayerSpeed(hitid);

	    if(fSpeed > 5) { // subject to discussion
    	
			arrWeaponDataAC[playerid][ac_iBulletsHit][weaponid]++;
			if(!(++arrAntiCheat[playerid][ac_iShots] % ac_MaxWeaponContShots[weaponid])) AC_Process(playerid, AC_AIMBOT, weaponid);

			new iRelevantMiss = arrWeaponDataAC[playerid][ac_iBulletsFired][weaponid] - arrWeaponDataAC[playerid][ac_iBulletsHit][weaponid] - arrWeaponDataAC[playerid][ac_iFakeMiss][weaponid],
				Float:fRatio;

			iRelevantMiss++; // Can't divide by 0.
			fRatio = arrWeaponDataAC[playerid][ac_iBulletsHit][weaponid] / iRelevantMiss;
			if(arrWeaponDataAC[playerid][ac_iBulletsFired][weaponid] > 50 && fRatio > 3) AC_Flag(playerid, AC_AIMBOT, weaponid, fRatio);
	    }
	    else arrWeaponDataAC[playerid][ac_iFakeMiss][weaponid]++;
	}
	else arrAntiCheat[playerid][ac_iShots] = 0; // reset it when missed :)
	SetTimerEx("Health", 100, false, "");


	new iMultipleWeps,
		iAvgRate = AverageShootRate(playerid, ac_MaxShootRateSamples, iMultipleWeps);

	// Bullet flood?
	// Could be either a cheat or just lag
	if(iAvgRate != -1) {
		if(iMultipleWeps) {
			if(iAvgRate < 100) {
				// AC_AddRejectedHit(playerid, damagedid, SHOOTING_RATE_TOO_FAST_MULTIPLE, weaponid, iAvgRate, ac_MaxShootRateSamples);
				return 0;
			}
		}
		else if(ac_MaxWeaponShootRate[weaponid] - iAvgRate > 40) { // was 20
			// AC_AddRejectedHit(playerid, damagedid, SHOOTING_RATE_TOO_FAST, weaponid, iAvgRate, ac_MaxShootRateSamples, ac_MaxWeaponShootRate[weaponid]);
			return 0;
		}
	}
	return 1;
}

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
	arrAntiCheat[playerid][ac_fSpeed] = GetPlayerSpeed(playerid);
	if(PlayerInfo[playerid][pAdmin] < 2)
	{
		if(IsSpawned[playerid] && gPlayerLogged{playerid} && playerTabbed[playerid] < 1) {
			if(ac_ACToggle[AC_CARSURFING] && AC_IsPlayerSurfing(playerid)) AC_Process(playerid, AC_CARSURFING, INVALID_PLAYER_ID);
			if(ac_ACToggle[AC_HEALTHARMORHACKS] && AC_PlayerHealthArmor(playerid)) AC_Process(playerid, AC_HEALTHARMORHACKS, INVALID_PLAYER_ID);
			if(ac_ACToggle[AC_INFINITESTAMINA] && AC_InfiniteStamina(playerid)) AC_Process(playerid, AC_INFINITESTAMINA);
		}
	}
}

AC_SpeedHacks(playerid) {

	new Float:fSpeed = GetPlayerSpeed(playerid),
		Float:fVel[3];
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && !IsPlayerInRangeOfVehicle(playerid, GetClosestCar(playerid), 5.0) && GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_USEJETPACK && fSpeed > 45) {
		GetPlayerVelocity(playerid, fVel[0], fVel[1], fVel[2]);
		if(fVel[2] == 0) AC_Process(playerid, AC_SPEEDHACKS);
	}
}

AC_InfiniteStamina(playerid) {

	if(arrAntiCheat[playerid][ac_fSpeed] > 24) arrAntiCheat[playerid][ac_iFlags][AC_INFINITESTAMINA]++;
	else arrAntiCheat[playerid][ac_iFlags][AC_INFINITESTAMINA] = 0;

	// Subject to discussion (HACKTIMER_INTERVAL * NUMBER = 5 seconds * 8 = 40 seconds running faster than 24).
	if(arrAntiCheat[playerid][ac_iFlags][AC_INFINITESTAMINA] > 8) return 1;
	return 0;
}

AC_AirBreaking(i) {

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

	new iSpeed = floatround(GetPlayerSpeed(i));
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

	if(damagedid == INVALID_PLAYER_ID) {
		#if defined OnInvalidWeaponDamage
			OnInvalidWeaponDamage(playerid, damagedid, amount, weaponid, bodypart, AC_NO_DAMAGED, true);
		#endif

		AC_AddRejectedHit(playerid, damagedid, HIT_NO_DAMAGEDID, weaponid);

		return 0;
	}
	if (ac_IsDead[damagedid]) {
		AC_AddRejectedHit(playerid, damagedid, HIT_DYING_PLAYER, weaponid);
		return 0;
	}

	// Ignore unreliable and invalid damage
	if (!(0 <= weaponid <= sizeof(ac_ValidDamageGiven)) || !ac_ValidDamageGiven[weaponid]) {
		// Fire is synced as taken damage (because it's not reliable as given), so no need to show a rejected hit.
		// Vehicle damage is also synced as taken, so no need to show that either.
		if (weaponid != WEAPON_FLAMETHROWER && weaponid != WEAPON_VEHICLE) {
			AC_AddRejectedHit(playerid, damagedid, HIT_INVALID_WEAPON, weaponid);
		}
		return 0;
	}

	if ((!IsPlayerStreamedIn(playerid, damagedid) && !IsPlayerPaused(damagedid)) || !IsPlayerStreamedIn(damagedid, playerid)) {
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


	new Float:fBullets, iErrorCode;
	if((iErrorCode = ProcessDamage(damagedid, playerid, amount, weaponid, bodypart, fBullets))) {
		if(iErrorCode == AC_INVALID_DAMAGE) {
			AC_AddRejectedHit(playerid, damagedid, HIT_INVALID_DAMAGE, weaponid, _:amount);
		}

		if(iErrorCode != AC_INVALID_DISTANCE) {
			#if defined OnInvalidWeaponDamage
				OnInvalidWeaponDamage(playerid, damagedid, amount, weaponid, bodypart, iErrorCode, true);
			#endif
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

	#if defined AC_DEBUG
		if (ac_HitsIssued[playerid] > 1) {
			new prev_tick_idx = (idx - 1) % sizeof(ac_LastHitTicks[]);

			// JIT plugin fix
			if (prev_tick_idx < 0) {
				prev_tick_idx += sizeof(ac_LastHitTicks[]);
			}

			new prev_tick = ac_LastHitTicks[playerid][prev_tick_idx];

			// AC_SendDebugMessage(playerid, "(hit) last: %d last 3: %d", iTick - prev_tick, AverageHitRate(playerid, 3));
		}
	#endif

	if(IsBulletWeapon(weaponid) && !IsPlayerPaused(damagedid)) {

		new Float:fPos[3];
		GetPlayerPos(damagedid, fPos[0], fPos[1], fPos[2]);
		new Float:fDistance = GetPlayerDistanceFromPoint(playerid, fPos[0], fPos[1], fPos[2]);


		/*
		format(szMiscArray, sizeof(szMiscArray), "Wep ID: %d, Player Range: %f, Weapon Range: %f", weaponid, fDistance, ac_WeaponRange[weaponid]);
		SendClientMessageToAll(0xFFFFFFFF, szMiscArray);
		*/
		if(fDistance > ac_WeaponRange[weaponid] + 2.0) {
			AC_AddRejectedHit(playerid, damagedid, HIT_OUT_OF_RANGE, weaponid, _:fDistance, _:ac_WeaponRange[weaponid]);
			AC_Process(playerid, AC_RANGEHACKS, weaponid);
			return 0;
		}
	}

	new iMultipleWeps,
		iAvgRate = AverageHitRate(playerid, ac_MaxHitRateSamples, iMultipleWeps);

	// Hit issue flood?
	// Could be either a cheat or just lag
	if (iAvgRate != -1) {
		if (iMultipleWeps) {
			if(iAvgRate < 100) {
				// AC_AddRejectedHit(playerid, damagedid, HIT_RATE_TOO_FAST_MULTIPLE, weaponid, iAvgRate, ac_MaxHitRateSamples);
				return 0;
			}
		}
		else if(ac_MaxWeaponShootRate[weaponid] - iAvgRate > 40) { // was 20
			// AC_AddRejectedHit(playerid, damagedid, HIT_RATE_TOO_FAST, weaponid, iAvgRate, ac_MaxHitRateSamples, ac_MaxWeaponShootRate[weaponid]);
			return 0;
		}
	}

	if (IsBulletWeapon(weaponid) && _:amount != _:2.6400001049041748046875 && !(IsPlayerInAnyVehicle(playerid) && GetPlayerVehicleSeat(playerid) == 0)) {
		
		new valid = true;
		// not gooood
		if(!arrLastBulletData[playerid][acl_Valid]) {
			// AC_AddRejectedHit(playerid, damagedid, HIT_LAST_SHOT_INVALID, weaponid);
			valid = false;
			// AC_SendDebugMessage(playerid, "!! - Last shot not valid");
		}
		else if (WEAPON_SHOTGUN <= weaponid <= WEAPON_SHOTGSPA) {
			// Let's assume someone won't hit 3 players with 1 shotgun shot, and that one OnPlayerWeaponShot can be out of sync
			if(arrLastBulletData[playerid][acl_Hits] >= 3) {
				valid = false;
				AC_AddRejectedHit(playerid, damagedid, HIT_MULTIPLE_PLAYERS_SHOTGUN, weaponid, arrLastBulletData[playerid][acl_Hits] + 1);
			}
		}
		else if(arrLastBulletData[playerid][acl_Hits] > 0) {
			// Sniper doesn't always send OnPlayerWeaponShot
			if(arrLastBulletData[playerid][acl_Hits] > 4 && weaponid != WEAPON_SNIPER) {
				valid = false;
				AC_AddRejectedHit(playerid, damagedid, HIT_MULTIPLE_PLAYERS, weaponid, arrLastBulletData[playerid][acl_Hits] + 1);
			}
			else {
				// AC_SendDebugMessage(playerid, "!!! - Hit %d players with 1 shot", arrLastBulletData[playerid][acl_Hits] + 1);
			}
		}

		arrLastBulletData[playerid][acl_Hits] += 1;

		if (!valid) {
			return 0;
		}
	}

	AC_InflictDamage(damagedid, amount, playerid, weaponid, bodypart);

	// Don't send OnPlayerGiveDamage to the rest of the script, since it should not be used
	return 0;
}

// Is called after OnPlayerWeaponShot
hook OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart) {

	if(ac_IsDead[playerid]) return 0;
	
	if(!IsHighRateWeapon(weaponid)) {
		#if defined AC_DEBUG
		// AC_SendDebugMessage(playerid, "OnPlayerTakeDamage(%d took %f from %d by %d on bodypart %d)", playerid, amount, issuerid, weaponid, bodypart);
		#endif
	}

	// Ignore unreliable and invalid damage
	if(!(0 <= weaponid <= sizeof(ac_ValidDamageTaken)) || !ac_ValidDamageTaken[weaponid]) return 0;
	if(playerid == INVALID_PLAYER_ID) return 0;

	// Carjack damage
	if(weaponid == 54 && _:amount == _:0.0) {
		// SendClientMessageToAll(0xFFFFFFFF, "NINJA JACK DETECTED!?!?");
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

	// If LagComp is on: only allow damage that's valid in both OnPlayerGiveDamage and OnPlayerTakeDamage.
	if (ac_LagCompMode && ac_ValidDamageTaken[weaponid] != 2) {
		if(issuerid != INVALID_PLAYER_ID && IsPlayerInAnyVehicle(issuerid) && GetPlayerVehicleSeat(issuerid) == 0 && (weaponid == WEAPON_M4 || weaponid == WEAPON_MINIGUN)) {
			weaponid = weaponid == WEAPON_M4 ? WEAPON_VEHICLE_M4 : WEAPON_VEHICLE_MINIGUN;
		}
		else return 0;
	}
	/*
	new Float:fBullets = 0.0, iErrorCode;
	if((iErrorCode = ProcessDamage(playerid, issuerid, amount, weaponid, bodypart, fBullets))) {
		if(iErrorCode == AC_INVALID_DAMAGE) {
			AC_AddRejectedHit(issuerid, playerid, HIT_INVALID_DAMAGE, weaponid, _:amount);
		}

		if (iErrorCode != AC_INVALID_DISTANCE) {
			#if defined OnInvalidWeaponDamage
				OnInvalidWeaponDamage(issuerid, playerid, amount, weaponid, bodypart, iErrorCode, false);
			#endif
		}
		return 0;
	}


	Doesn't get called if issuerid is out of range.
	if(IsBulletWeapon(weaponid)) {

		new Float:fPos[3];
		GetPlayerPos(issuerid, fPos[0], fPos[1], fPos[2]);
		new Float:fDistance = GetPlayerDistanceFromPoint(playerid, fPos[0], fPos[1], fPos[2]);


		format(szMiscArray, sizeof(szMiscArray), "Wep ID: %d, Player Range: %f, Weapon Range: %f", weaponid, fDistance, ac_WeaponRange[weaponid]);
		SendClientMessageToAll(0xFFFFFFFF, szMiscArray);
		if (fDistance > ac_WeaponRange[weaponid] + 2.0) {
			AC_AddRejectedHit(issuerid, playerid, HIT_OUT_OF_RANGE, weaponid, _:fDistance, _:ac_WeaponRange[weaponid]);
			AC_Warning(issuerid, AC_DISTANCE);
			return 0;
		}
	}
	*/

	AC_InflictDamage(playerid, amount, issuerid, weaponid, bodypart); // Server Sided Health
	return 1;
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
	ClearAnimations(playerid, 1);
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
	if(ac_ACToggle[AC_REJECTHITS]) OnRejectedHit(playerid, arrRejectedHitData[playerid][idx]);
}

forward OnRejectedHit(playerid, arrRejectedHit[E_REJECTED_HIT]);
public OnRejectedHit(playerid, arrRejectedHit[E_REJECTED_HIT]) {
	
	format(szMiscArray, sizeof(szMiscArray), "Rejected hit: %s -- (%s -> %s) %s", AC_GetWeaponName(arrRejectedHit[acr_iWeaponID]), arrRejectedHit[acr_szName], g_HitRejectReasons[arrRejectedHit[acr_iReason]]);
	ABroadCast(COLOR_YELLOW, szMiscArray, 2);
}

static ProcessDamage(&playerid, &issuerid, &Float:amount, &weaponid, &bodypart, &Float:bullets) {

	if(amount < 0.0) return AC_INVALID_DAMAGE;

	// Adjust invalid amounts caused by an animation bug
	switch(amount) {
		case 3.63000011444091796875,
		     5.940000057220458984375,
		     5.610000133514404296875: {
			amount = 2.6400001049041748046875;
		}

		case 3.30000019073486328125: {
			if (weaponid != WEAPON_SHOTGUN && weaponid != WEAPON_SAWEDOFF) {
				amount = 2.6400001049041748046875;
			}
		}

		case 4.950000286102294921875: {
			if(IsMeleeWeapon(weaponid)) {
				amount = 2.6400001049041748046875;
			}
		}

		case 6.270000457763671875,
		     6.93000030517578125,
		     7.2600002288818359375,
		     7.9200000762939453125,
		     8.5799999237060546875,
		     9.24000072479248046875,
		     11.88000011444091796875,
		     11.22000026702880859375: {
			amount = 2.6400001049041748046875;
		}

		case 9.90000057220458984375: {
			switch (weaponid) {
				case WEAPON_VEHICLE, WEAPON_VEHICLE_M4, WEAPON_AK47,
				     WEAPON_M4, WEAPON_SHOTGUN, WEAPON_SAWEDOFF, WEAPON_SHOTGSPA: {}

				default: {
					amount = 6.6000003814697265625;
				}
			}
		}
	}

	// Car parking and disable heli-blading.
	if(weaponid == WEAPON_HELIBLADES) {
		if(_:amount != _:330.0) weaponid = WEAPON_CARPARK;
		else return AC_INVALID_DAMAGE;
	}

	// Finish processing drown/fire/carpark quickly, since they are sent at very high rates
	if(IsHighRateWeapon(weaponid)) {
		
		// Apply reasonable bounds
		if(weaponid == WEAPON_DROWN) {
			if(amount > 10.0) amount = 10.0;
		}
		else if(amount > 1.0) amount = 1.0;

		// Adjust the damage if the multiplier is not 1.0
		if (_:arrWeaponData[weaponid][ac_WeaponDamage] != _:1.0) {
			amount *= arrWeaponData[weaponid][ac_WeaponDamage];
		}

		// Make sure the distance and issuer is valid; carpark can be self-inflicted so it doesn't require an issuer
		if(weaponid == WEAPON_SPRAYCAN || weaponid == WEAPON_FIREEXTINGUISHER || (weaponid == WEAPON_CARPARK && issuerid != INVALID_PLAYER_ID)) {
			if(issuerid == INVALID_PLAYER_ID) {
				return AC_NO_ISSUER;
			}

			new Float:fPos[3], Float:fDistance;
			GetPlayerPos(issuerid, fPos[0], fPos[1], fPos[2]);
			fDistance = GetPlayerDistanceFromPoint(playerid, fPos[0], fPos[1], fPos[2]);

			if(fDistance > 15.0) {
				AC_AddRejectedHit(issuerid, playerid, HIT_TOO_FAR_FROM_ORIGIN, weaponid, _:fDistance);
				return AC_INVALID_DISTANCE;
			}
		}
		return AC_NO_ERROR;
	}

	// Bullet or melee damage must have an issuerid, otherwise something has gone wrong (e.g. sniper bug)
	if(issuerid == INVALID_PLAYER_ID && (IsBulletWeapon(weaponid) || IsMeleeWeapon(weaponid))) {
		return AC_NO_ISSUER;
	}

	// Punching with a parachute
	if(weaponid == WEAPON_PARACHUTE) {
		weaponid = WEAPON_UNARMED;
	}

	// Collision damage should never be above 165
	if(weaponid == WEAPON_COLLISION) {
		if (amount > 165.0) {
			amount = 1.0;
		}
		else amount /= 165.0;
	}

	if(weaponid == WEAPON_EXPLOSION) {
		// Explosions do at most 82.5 damage. This will later be multipled by the damage value
		amount /= 82.5;

		// Figure out what caused the explosion
		if (issuerid != INVALID_PLAYER_ID && ac_LastExplosive[issuerid]) {
			weaponid = ac_LastExplosive[issuerid];
		}
	}

	// Check for pistol whip
	switch (weaponid) {
		case WEAPON_COLT45 .. WEAPON_SNIPER,
		     WEAPON_MINIGUN, WEAPON_SPRAYCAN, WEAPON_FIREEXTINGUISHER: {
			// A pistol whip inflicts 2.64 damage
			if (_:amount == _:2.6400001049041748046875) {
				// Save the weapon in the bodypart argument (it's always BODY_PART_TORSO)
				bodypart = weaponid;
				weaponid = WEAPON_PISTOLWHIP;
			}
		}
	}

	new melee = IsMeleeWeapon(weaponid);

	// Can't punch from a vehicle
	if(melee && IsPlayerInAnyVehicle(issuerid)) return AC_INVALID_DAMAGE;
	if(weaponid != WEAPON_PISTOLWHIP) {
		switch (amount) {
			case 1.32000005245208740234375,
			     1.650000095367431640625,
			     1.980000019073486328125,
			     2.3100001811981201171875,
			     2.6400001049041748046875,
			     2.9700000286102294921875,
			     3.96000003814697265625,
			     4.28999996185302734375,
			     4.62000036239624023437,
			     5.280000209808349609375: {
				// Damage is most likely from punching and switching weapon quickly
				if (!melee) {
					// AC_SendDebugMessage(issuerid, "weapon changed from %d to melee (punch & swap)", weaponid);
					weaponid = WEAPON_UNARMED;
					melee = true;
				}
			}

			case 6.6000003814697265625: {
				if (!melee) {
					switch (weaponid) {
						case WEAPON_UZI, WEAPON_TEC9, WEAPON_CHAINSAW,
						     WEAPON_SHOTGUN, WEAPON_SAWEDOFF: {}

						default: {
							// AC_SendDebugMessage(issuerid, "weapon changed from %d to melee (punch & swap)", weaponid);
							weaponid = WEAPON_UNARMED;
							melee = true;
						}
					}
				}
			}

			case 54.12000274658203125: {
				if (!melee) {
					// AC_SendDebugMessage(issuerid, "weapon changed from %d to melee (punch & swap)", weaponid);
					melee = true;
					weaponid = WEAPON_UNARMED;
					amount = 1.32000005245208740234375;
				}

				// Be extra sure about this one
				if (GetPlayerFightingStyle(issuerid) != FIGHT_STYLE_KNEEHEAD) {
					return AC_INVALID_DAMAGE;
				}
			}

			// Melee damage has been tampered with
			default: {
				if (melee) {
					return AC_INVALID_DAMAGE;
				}
			}
		}
	}

	if(melee) {
		new Float:fPos[3], Float:fDistance;
		GetPlayerPos(issuerid, fPos[0], fPos[1], fPos[2]);
		fDistance = GetPlayerDistanceFromPoint(playerid, fPos[0], fPos[1], fPos[2]);

		if(fDistance > 15.0) {
			AC_AddRejectedHit(issuerid, playerid, HIT_TOO_FAR_FROM_ORIGIN, weaponid, _:fDistance);
			return AC_INVALID_DISTANCE;
		}
	}

	switch(weaponid) {
		// The spas shotguns shoot 8 bullets, each inflicting 4.95 damage
		case WEAPON_SHOTGSPA: {
			bullets = amount / 4.950000286102294921875;

			if (8.0 - bullets < -0.05) {
				return AC_INVALID_DAMAGE;
			}
		}

		// Shotguns and sawed-off shotguns shoot 15 bullets, each inflicting 3.3 damage
		case WEAPON_SHOTGUN, WEAPON_SAWEDOFF: {
			bullets = amount / 3.30000019073486328125;

			if (15.0 - bullets < -0.05) {
				return AC_INVALID_DAMAGE;
			}
		}
	}

	if(_:bullets) {

		new Float:f = floatfract(bullets);
		// The damage for each bullet has been tampered with
		if(f > 0.01 && f < 0.99) return AC_INVALID_DAMAGE;

		// Divide the damage amount by the number of bullets
		amount /= bullets;
	}

	// Check chainsaw damage
	if(weaponid == WEAPON_CHAINSAW) {
		switch (amount) {
			case 6.6000003814697265625,
			     13.5300006866455078125,
			     16.1700000762939453125,
			     26.40000152587890625,
			     27.060001373291015625: {}

			default: return AC_INVALID_DAMAGE;
		}
	}

	// Check deagle damage
	if(weaponid == WEAPON_DEAGLE) {
		switch (amount) {
			case 46.200000762939453125,
			     23.1000003814697265625: {}

			default: return AC_INVALID_DAMAGE;
		}
	}

	// Check gun damage
	new Float:def_amount = 0.0;

	switch (weaponid) {
		case WEAPON_COLT45,
		     WEAPON_MP5: def_amount = 8.25;
		case WEAPON_SILENCED: def_amount = 13.200000762939453125;
		case WEAPON_UZI,
		     WEAPON_TEC9: def_amount = 6.6000003814697265625;
		case WEAPON_AK47,
		     WEAPON_M4,
		     WEAPON_VEHICLE_M4: def_amount = 9.90000057220458984375;
		case WEAPON_RIFLE: def_amount = 24.7500019073486328125;
		case WEAPON_SNIPER: def_amount = 41.25;
		case WEAPON_MINIGUN,
		     WEAPON_VEHICLE_MINIGUN: def_amount = 46.200000762939453125;
		case WEAPON_VEHICLE: def_amount = 9.90000057220458984375;
	}

	if (_:def_amount && _:def_amount != _:amount) {
		return AC_INVALID_DAMAGE;
	}

	// Adjust the damage
	switch (ac_DamageType[weaponid]) {
		
		case DAMAGE_TYPE_MULTIPLIER: {
			if (_:arrWeaponData[weaponid][ac_WeaponDamage] != _:1.0) amount *= arrWeaponData[weaponid][ac_WeaponDamage];
		}
		case DAMAGE_TYPE_STATIC: {
			if (_:bullets) amount = arrWeaponData[weaponid][ac_WeaponDamage] * bullets;
			else amount = arrWeaponData[weaponid][ac_WeaponDamage];
		}
		case DAMAGE_TYPE_RANGE,
		     DAMAGE_TYPE_RANGE_MULTIPLIER: {
			
			new Float:length = arrLastBulletData[issuerid][acl_fDistance];
			for (new i = arrWeaponData[weaponid][ac_DamageRangeSteps] - 1; i >= 0; i--) {
				if (i == 0 || length >= arrWeaponData[weaponid][ac_DamageRangeRanges][i]) {
					if (ac_DamageType[weaponid] == DAMAGE_TYPE_RANGE_MULTIPLIER) {
						if (_:arrWeaponData[weaponid][ac_DamageRangeValues][i] != _:1.0) {
							amount *= arrWeaponData[weaponid][ac_DamageRangeValues][i];
						}
					} else {
						if (_:bullets) {
							amount = arrWeaponData[weaponid][ac_DamageRangeValues][i] * bullets;
						} else {
							amount = arrWeaponData[weaponid][ac_DamageRangeValues][i];
						}
					}
					break;
				}
			}
		}
	}
	return AC_NO_ERROR;
}

stock AverageShootRate(playerid, shots, &multiple_weapons = 0) {

	if(playerid == INVALID_PLAYER_ID || ac_TotalShots[playerid] < shots) return -1;

	new total = 0, idx = ac_LastBulletIdx[playerid];
	multiple_weapons = false;

	for (new i = shots - 2; i >= 0; i--) {
		
		new prev_idx = (idx - i - 1) % sizeof(ac_LastBulletTicks[]);

		// JIT plugin fix
		if (prev_idx < 0) {
			prev_idx += sizeof(ac_LastBulletTicks[]);
		}

		new prev = ac_LastBulletTicks[playerid][prev_idx],
			prev_weap = ac_LastBulletWeapons[playerid][prev_idx],
			this_idx = (idx - i) % sizeof(ac_LastBulletTicks[]);

		// JIT plugin fix
		if (this_idx < 0) {
			this_idx += sizeof(ac_LastBulletTicks[]);
		}

		if (prev_weap != ac_LastBulletWeapons[playerid][this_idx]) {
			multiple_weapons = true;
		}

		total += ac_LastBulletTicks[playerid][this_idx] - prev;
	}

	return total / (shots - 1);
}

stock AverageHitRate(playerid, hits, &multiple_weapons = 0) {

	if(playerid == INVALID_PLAYER_ID || ac_HitsIssued[playerid] < hits) return -1;

	new total = 0, idx = ac_LastHitIdx[playerid];
	multiple_weapons = false;
	for(new i = hits - 2; i >= 0; i--) {

		new prev_idx = (idx - i - 1) % sizeof(ac_LastHitTicks[]);

		// JIT plugin fix
		if (prev_idx < 0) {
			prev_idx += sizeof(ac_LastHitTicks[]);
		}

		new prev = ac_LastHitTicks[playerid][prev_idx],
			prev_weap = ac_LastHitWeapons[playerid][prev_idx],
			this_idx = (idx - i) % sizeof(ac_LastHitTicks[]);

		// JIT plugin fix
		if(this_idx < 0) {
			this_idx += sizeof(ac_LastHitTicks[]);
		}
		if(prev_weap != ac_LastHitWeapons[playerid][this_idx]) {
			multiple_weapons = true;
		}
		total += ac_LastHitTicks[playerid][this_idx] - prev;
	}

	return total / (hits - 1);
}

stock SetWeaponDamage(weaponid, damage_type, Float:amount, Float:...) {

	if(!(0 <= weaponid <= sizeof(ac_WeaponDamage))) return 0;
	
	if(damage_type == DAMAGE_TYPE_RANGE || damage_type == DAMAGE_TYPE_RANGE_MULTIPLIER) {
		
		if (!IsBulletWeapon(weaponid)) return 0;

		new args = numargs();
		if(!(args & 0b1)) return 0;

		new steps = (args - 1) / 2;

		ac_DamageType[weaponid] = damage_type;
		ac_DamageRangeSteps[weaponid] = steps;

		for(new i = 0; i < steps; i++) {
			if(i) {
				ac_DamageRangeRanges[weaponid][i] = Float:getarg(1 + i*2);
				ac_DamageRangeValues[weaponid][i] = Float:getarg(2 + i*2);
			}
			else ac_DamageRangeValues[weaponid][i] = amount;
		}
		return 1;
	}

	else if(damage_type == DAMAGE_TYPE_MULTIPLIER || damage_type == DAMAGE_TYPE_STATIC) {
		ac_DamageType[weaponid] = damage_type;
		ac_DamageRangeSteps[weaponid] = 0;
		ac_WeaponDamage[weaponid] = amount;
		return 1;
	}

	return 0;
}

static AC_InflictDamage(playerid, Float:amount, issuerid = INVALID_PLAYER_ID, weaponid = WEAPON_UNKNOWN, bodypart = BODY_PART_UNKNOWN, bool:ignore_armour = false) {

	if(!IsPlayerSpawned(playerid) || amount < 0.0 || !IsPlayerSpawned(issuerid)) return;
	if (!(0 <= weaponid <= WEAPON_UNKNOWN)) weaponid = WEAPON_UNKNOWN;
	#if defined AC_DEBUG

		new Float:fDistance = 0.0;
		if(issuerid != INVALID_PLAYER_ID) {
			if(IsBulletWeapon(weaponid)) fDistance = arrLastBulletData[issuerid][acl_fDistance];
		}
		if(!IsHighRateWeapon(weaponid)) {
			// AC_SendDebugMessageAll("InflictDamage(%s, %.4f, %d, %s, %s) Distance = %f", GetPlayerNameEx(playerid), amount, GetPlayerNameEx(issuerid), AC_GetWeaponName(weaponid), bodypart, fDistance);
		}
	#endif

	if(!ignore_armour && weaponid != WEAPON_COLLISION && weaponid != WEAPON_DROWN && weaponid != WEAPON_CARPARK && (!ac_DamageArmourToggle[0] ||
		(ac_DamageArmour[weaponid][0] && (!ac_DamageArmourToggle[1] || ((ac_DamageArmour[weaponid][1] && bodypart == 3) || (!ac_DamageArmour[weaponid][1])))))) {
		
		if (amount <= 0.0) amount = PlayerHealth[playerid] + PlayerArmor[playerid];
		// PlayerArmor[playerid] -= amount;
	}
	else {
		if(amount <= 0.0) amount = PlayerHealth[playerid];
		// PlayerHealth[playerid] -= amount;
	}

	if(PlayerArmor[playerid] < 0.0) {
		ac_DamageDoneArmour[playerid] = amount + PlayerArmor[playerid];
		ac_DamageDoneHealth[playerid] = -PlayerArmor[playerid];
		// PlayerHealth[playerid] += PlayerArmor[playerid];
		// PlayerArmor[playerid] = 0.0;
	}
	else {
		ac_DamageDoneArmour[playerid] = amount;
		ac_DamageDoneHealth[playerid] = 0.0;
	}

	if(PlayerHealth[playerid] <= 0.0) {
		amount += PlayerHealth[playerid];
		ac_DamageDoneHealth[playerid] += PlayerHealth[playerid];
		// PlayerHealth[playerid] = 0.0;
	}

	/*
	OnPlayerDamageDone(playerid, amount, issuerid, weaponid, bodypart);

	if(PlayerHealth[playerid] <= 0.0005) {
		
		new iVehID = GetPlayerVehicleID(playerid);
		if(iVehID) {
			
			new iModelID = GetVehicleModel(vehicleid),
				iSeatID = GetPlayerVehicleSeat(playerid);

			TogglePlayerControllable(playerid, false);

			switch(iModelID) {

				case 509, 481, 510, 462, 448, 581, 522,
				     461, 521, 523, 463, 586, 468, 471: {

					new Float:fVel[3];
					GetVehicleVelocity(vehicleid, fVel[0], fVel[1], fVel[2]);

					if (fVel[0]*fVel[0] + fVel[1]*fVel[1] + fVel[2]*fVel[2] >= 0.4) {
						PlayerDeath(playerid, "PED", "BIKE_fallR", 0);
					} else {
						PlayerDeath(playerid, "PED", "BIKE_fall_off", 0);
					}
				}

				default: {
					if(iSeatID & 1) PlayerDeath(playerid, "PED", "CAR_dead_LHS");
					else PlayerDeath(playerid, "PED", "CAR_dead_RHS");
				}
			}
		}
		else if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USEJETPACK) {
			PlayerDeath(playerid, "PED", "KO_skid_back", .freeze_sync = false);
		}
		else {
			if(gettime() - s_LastVehicleEnterTime[playerid] < 10) {
				TogglePlayerControllable(playerid, false);
			}

			new anim = GetPlayerAnimationIndex(playerid);

			if(anim == 1250 || (1538 <= anim <= 1544) || weaponid == WEAPON_DROWN) {
				
				// In water
				PlayerDeath(playerid, "PED", "Drown");
			}
			else if (1195 <= anim <= 1198) {
				
				// Jumping animation
				PlayerDeath(playerid, "PED", "KO_skid_back");
			}
			else if (WEAPON_SHOTGUN <= weaponid <= WEAPON_SHOTGSPA) {

				if(IsPlayerBehindPlayer(issuerid, playerid)) {
					MakePlayerFacePlayer(playerid, issuerid, true);
					PlayerDeath(playerid, "PED", "KO_shot_front");
				}
				else {
					MakePlayerFacePlayer(playerid, issuerid);
					PlayerDeath(playerid, "PED", "BIKE_fall_off");
				}
			}
			else if (WEAPON_RIFLE <= weaponid <= WEAPON_SNIPER) {
				if (bodypart == 9) {
					PlayerDeath(playerid, "PED", "KO_shot_face");
				} else if (IsPlayerBehindPlayer(issuerid, playerid)) {
					PlayerDeath(playerid, "PED", "KO_shot_front");
				} else {
					PlayerDeath(playerid, "PED", "KO_shot_stom");
				}
			} else if (IsBulletWeapon(weaponid)) {
				if (bodypart == 9) {
					PlayerDeath(playerid, "PED", "KO_shot_face");
				} else {
					PlayerDeath(playerid, "PED", "KO_shot_front");
				}
			} else if (weaponid == WEAPON_PISTOLWHIP) {
				PlayerDeath(playerid, "PED", "KO_spin_R");
			} else if (IsMeleeWeapon(weaponid) || weaponid == WEAPON_CARPARK) {
				PlayerDeath(playerid, "PED", "KO_skid_front");
			} else if (weaponid == WEAPON_SPRAYCAN || weaponid == WEAPON_FIREEXTINGUISHER) {
				PlayerDeath(playerid, "KNIFE", "KILL_Knife_Ped_Die");
			} else {
				PlayerDeath(playerid, "PED", "KO_skid_back");
			}
		}

		#if defined WC_OnPlayerDeath
			if (s_CbugAllowed) WC_OnPlayerDeath(playerid, issuerid, weaponid);
			}
			else s_DelayedDeathTimer[playerid] = SetTimerEx(#WC_DelayedDeath, 1200, false, "iii", playerid, issuerid, weaponid);
		#endif
	}
	*/
}

stock IsPlayerPaused(playerid) {
	return (GetTickCount() - ac_LastUpdate[playerid] > 2000);
}

stock IsPlayerSpawned(playerid)
{
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

forward Float:GetPlayerSpeed(i);
stock Float:GetPlayerSpeed(i) {

	new Float:fVel[3],
		Float:fSpeed;

	if(IsPlayerInAnyVehicle(i)) GetVehicleVelocity(GetPlayerVehicleID(i), fVel[0], fVel[1], fVel[2]);
	else GetPlayerVelocity(i, fVel[0], fVel[1], fVel[2]);
	fSpeed = floatsqroot(((fVel[0]*fVel[0])+(fVel[1]*fVel[1]))+(fVel[2]*fVel[2])) * 136.666667;
	floatround(fSpeed, floatround_round);
	return fSpeed;
}

stock GetDriverID(iVehID) {

	if(iVehID == INVALID_VEHICLE_ID) return INVALID_PLAYER_ID;
	foreach(new i : Player) {
		if(GetPlayerVehicleID(i) == iVehID && GetPlayerState(i) == PLAYER_STATE_DRIVER) return i;
	}
	return INVALID_PLAYER_ID;
}

stock AC_GetACName(i) {

	new szName[64];
	switch(i) {
		case AC_AIMBOT: szName = "Aimbot";
		case AC_CBUG: szName = "(Auto) C-Bug";
		case AC_RANGEHACKS: szName = "Weapon Range Hacks (e.g. ProAim)";
		case AC_SPEEDHACKS: szName = "Speed Hacks (B2-B5)";
		case AC_VEHICLEHACKS: szName = "Vehicle Hacks";
		case AC_CMDSPAM: szName = "Command Spamming";
		case AC_CARSURFING: szName = "Car Surfing";
		case AC_NINJAJACK: szName = "Ninja Jacking";
		case AC_AIRBREAKING: szName = "Airbreaking";
		case AC_INFINITESTAMINA: szName = "Infinite Stamina";
		case AC_HEALTHARMORHACKS: szName = "Health/Armor Hacks";
		case AC_DIALOGSPOOFING: szName = "Dialog Spoofing";
		case AC_REJECTHITS: szName = "Rejected Hits (view-only)";
	}
	return szName;
}

stock AC_FinePlayer(playerid, fineid) {

	switch(fineid) {
		case AC_NINJAJACK: GivePlayerCash(playerid, -2000);
		case AC_DIALOGSPOOFING: GivePlayerCash(playerid, -2000);
	}
}

stock AC_PutPlayerInVehicle(playerid,vehicle,seat){ 

	arrAntiCheat[playerid][ac_iVehID] = vehicle;
	PutPlayerInVehicle(playerid,vehicle,seat); 
}

timer AC_RevivePlayer[5000](playerid) {

	format(szMiscArray, sizeof(szMiscArray), "SYSTEM: %s(%d) has been revived by [SYSTEM]", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerNameEx(playerid));
	Log("logs/system.log", szMiscArray);
	KillEMSQueue(playerid);
	ClearAnimations(playerid);
	SetHealth(playerid, 100);
}

AC_Flag(playerid, processid, iExtraID = INVALID_PLAYER_ID, Float:fInfo = 0.0) {

	switch(processid) {
		case AC_AIMBOT: {
			if(fInfo > 20) AC_Process(playerid, AC_AIMBOT, iExtraID);
			else {
				format(szMiscArray, sizeof(szMiscArray), "{AA3333}[SYSTEM]: {FFFF00}AimBot - I flagged %s for a high hit-ratio (%.1f) with their %s.", GetPlayerNameEx(playerid), fInfo, AC_GetWeaponName(iExtraID));
				ABroadCast(COLOR_LIGHTRED, szMiscArray, 2);
			}
		}
	}
}

AC_Process(playerid, processid, iExtraID = INVALID_PLAYER_ID) {

	if(PlayerInfo[playerid][pAdmin] > 1) return 1;
	if(!ac_ACToggle[processid]) return 1;
	arrAntiCheat[playerid][ac_iFlags][processid]++;
	if(GetPVarType(playerid, "ACCooldown") && GetPVarInt(playerid, "ACCooldown") == processid) return 1;
	SetPVarInt(playerid, "ACCooldown", processid);
	// if(processid == AC_SPEEDHACKS && arrAntiCheat[playerid][ac_iFlags][processid] != 1 && !(arrAntiCheat[playerid][ac_iFlags][processid] % 20)) return 1;
	if(arrAntiCheat[playerid][ac_iFlags][processid] == 1 || arrAntiCheat[playerid][ac_iFlags][processid] % 5) { // prevent spamming
		new szString[128],
			szQuery[512];

		szMiscArray[0] = 0;
		switch(processid) {

			case AC_AIMBOT: {

				format(szMiscArray, sizeof(szMiscArray), "{AA3333}[SYSTEM]: {FFFF00}%s is using Aimbot", GetPlayerNameEx(playerid));

				new iTotalMiss = arrWeaponDataAC[playerid][ac_iBulletsFired][iExtraID] - arrWeaponDataAC[playerid][ac_iBulletsHit][iExtraID],
					iRelevantMiss = arrWeaponDataAC[playerid][ac_iBulletsFired][iExtraID] - arrWeaponDataAC[playerid][ac_iBulletsHit][iExtraID] - arrWeaponDataAC[playerid][ac_iFakeMiss][iExtraID];

				iRelevantMiss++; // Can't divide by 0;
				new Float:fRatio = arrWeaponDataAC[playerid][ac_iBulletsHit][iExtraID] / iRelevantMiss;

				format(szQuery, sizeof(szQuery), "INSERT INTO `ac` (`DBID`, `timestamp`, `type`, `flags`, `weaponid`, `totalfired`, `hits`, `rmisses`, `tmisses`, `ratio`) VALUES (%d, NOW(), %d, %d, %d, %d, %d, %d, %d, %.1f)",
					PlayerInfo[playerid][pId], processid, arrAntiCheat[playerid][ac_iFlags][processid], iExtraID, arrWeaponDataAC[playerid][ac_iBulletsFired][iExtraID], arrWeaponDataAC[playerid][ac_iBulletsHit][iExtraID], iRelevantMiss, iTotalMiss, fRatio);
				mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "i", SENDDATA_THREAD);

			}
			case AC_CBUG: {
				// format(szMiscArray, sizeof(szMiscArray), "{AA3333}[SYSTEM]: {FFFF00}%s is C-Bugging", GetPlayerNameEx(playerid));
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

				ClearAnimations(playerid, 1);
				ApplyAnimation(playerid, "PED", "IDLE_stance", 4.1, 0, 0, 0, 0, 0, 1);
				defer AC_ResetAnim(playerid);
				// FreezeSyncData(playerid, true);
				GivePlayerWeapon(playerid, w, 0);

				szMiscArray = "[SYSTEM]: Please do not C-Bug / CS.";
				SendClientMessageEx(playerid, COLOR_LIGHTRED, szMiscArray);
				return 1;
			}
			case AC_RANGEHACKS: {

				new iTotalMiss = arrWeaponDataAC[playerid][ac_iBulletsFired][iExtraID] - arrWeaponDataAC[playerid][ac_iBulletsHit][iExtraID],
					iRelevantMiss = arrWeaponDataAC[playerid][ac_iBulletsFired][iExtraID] - arrWeaponDataAC[playerid][ac_iBulletsHit][iExtraID] - arrWeaponDataAC[playerid][ac_iFakeMiss][iExtraID];

				iRelevantMiss++; // Can't divide by 0;
				new Float:fRatio = arrWeaponDataAC[playerid][ac_iBulletsHit][iExtraID] / iRelevantMiss;

				format(szMiscArray, sizeof(szMiscArray), "{AA3333}[SYSTEM]: {FFFF00}%s is using range-hacks (ProAim)", GetPlayerNameEx(playerid));
				format(szQuery, sizeof(szQuery), "INSERT INTO `ac` (`DBID`, `timestamp`, `type`, `flags`, `weaponid`, `totalfired`, `hits`, `rmisses`, `tmisses`, `ratio`) VALUES (%d, NOW(), %d, %d, %d, %d, %d, %d, %d, %.1f)",
					PlayerInfo[playerid][pId], processid, arrAntiCheat[playerid][ac_iFlags][processid], iExtraID, arrWeaponDataAC[playerid][ac_iBulletsFired][iExtraID], arrWeaponDataAC[playerid][ac_iBulletsHit][iExtraID], iRelevantMiss, iTotalMiss, fRatio);
				mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "i", SENDDATA_THREAD);
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
				szMiscArray = "[SYSTEM]: Please do not car surf.";
				SendClientMessageEx(playerid, COLOR_LIGHTRED, szMiscArray);
				return 1;
			}
			case AC_NINJAJACK: {

				defer AC_RevivePlayer(playerid);
				/*
				AC_FinePlayer(iExtraID, processid);
				SetTimerEx("KickEx", 1000, 0, "i", iExtraID);
				*/
				szMiscArray = "[SYSTEM]: You will be revived from the ninja-jacking in a few seconds.";
				SendClientMessageEx(playerid, COLOR_LIGHTRED, szMiscArray);
				szString = "[SYSTEM]: You were caught plausibly ninja-jacking. Admins were warned.";
				format(szMiscArray, sizeof(szMiscArray), "[SYSTEM]: %s has plausibly ninja-jacked %s.", GetPlayerNameEx(iExtraID), GetPlayerNameEx(playerid));
			}
			case AC_AIRBREAKING: format(szMiscArray, sizeof(szMiscArray), "{AA3333}[SYSTEM]: {FFFF00}%s is AirBreaking.", GetPlayerNameEx(playerid));
			case AC_HEALTHARMORHACKS: {
				
				// AC_FinePlayer(playerid, processid);
				// SetTimerEx("KickEx", 1000, 0, "i", iExtraID);
				szMiscArray = "[SYSTEM]: You were kicked for plausibly health/armor hacking.";
				SendClientMessageEx(playerid, COLOR_LIGHTRED, szMiscArray);
				format(szMiscArray, sizeof(szMiscArray), "[SYSTEM]: %s was kicked for (plausibly!) health/armor hacking. Refrain from taking more action until fully tested.", GetPlayerNameEx(playerid));
			}
			/*
			case AC_DIALOGSPOOFING: {
				if(!ac_ACToggle[DIALOGSPOOFING]) return 1;
				AC_FinePlayer(playerid, processid);
				SetTimerEx("KickEx", 1000, 0, "i", iExtraID);
				format(szMiscArray, sizeof(szMiscArray), "[SYSTEM]: %s was kicked for (plausibly!) dialog spoofing. Refrain from taking more action until fully tested.", GetPlayerNameEx(playerid));
				ABroadCast(COLOR_LIGHTRED, szMiscArray, 2);
				szMiscArray = "[SYSTEM]: You were kicked for plausibly dialog spoofing.";
			}
			*/
		}
		// format(szMiscArray, sizeof(szMiscArray), "%s %s (ID: %d)", szMiscArray, GetPlayerNameExt(playerid), playerid);
		ABroadCast(COLOR_LIGHTRED, szMiscArray, 2);
		if(iExtraID != INVALID_PLAYER_ID) SendClientMessageEx(iExtraID, COLOR_LIGHTRED, szString);
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

CMD:system(playerid, params[]) {

	if(!IsAdminLevel(playerid, ADMIN_SENIOR)) return 1;
	format(szMiscArray, sizeof(szMiscArray), "Detecting\tStatus\n\
		Aimbot\t%s\n\
		(Auto)-C-Bug\t%s\n\
		Weapon Range Hacks (ProAim)\t%s\n\
		Speed Hacks (B2-B5)\t%s\n\
		Vehicle Hacks\t%s\n\
		Command Spamming\t%s\n\
		Car Surfing\t%s\n\
		Ninja Jacking\t%s\n\
		Airbreaking\t%s\n\
		Infinite Stamina\t%s\n\
		---------\t%s\n\
		---------\t%s\n\
		Rejected Hits\t%s",
		(ac_ACToggle[AC_AIMBOT] == true) ? ("{00FF00}On") : ("{FF0000}Off"),
		(ac_ACToggle[AC_CBUG] == true) ? ("{00FF00}On") : ("{FF0000}Off"),
		(ac_ACToggle[AC_RANGEHACKS] == true) ? ("{00FF00}On") : ("{FF0000}Off"),
		(ac_ACToggle[AC_SPEEDHACKS] == true) ? ("{00FF00}On") : ("{FF0000}Off"),
		(ac_ACToggle[AC_VEHICLEHACKS] == true) ? ("{00FF00}On") : ("{FF0000}Off"),
		(ac_ACToggle[AC_CMDSPAM] == true) ? ("{00FF00}On") : ("{FF0000}Off"),
		(ac_ACToggle[AC_CARSURFING] == true) ? ("{00FF00}On") : ("{FF0000}Off"),
		(ac_ACToggle[AC_NINJAJACK] == true) ? ("{00FF00}On") : ("{FF0000}Off"),
		(ac_ACToggle[AC_AIRBREAKING] == true) ? ("{00FF00}On") : ("{FF0000}Off"),
		(ac_ACToggle[AC_INFINITESTAMINA] == true) ? ("{00FF00}On") : ("{FF0000}Off"),
		(ac_ACToggle[AC_HEALTHARMORHACKS] == true) ? ("{00FF00}On") : ("{FF0000}Off"),
		(ac_ACToggle[AC_DIALOGSPOOFING] == true) ? ("{00FF00}On") : ("{FF0000}Off"),
		(ac_ACToggle[AC_REJECTHITS] == true) ? ("{00FF00}On") : ("{FF0000}Off"));
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
	ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_TABLIST_HEADERS, szTitle, szMiscArray, "<>", "");
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

	if(sscanf(params, "u", uPlayer)) return SendClientMessage(playerid, 0xFFFFFFFF, "Usage: /aimcheck [playerid/name]");
	if(!IsPlayerConnected(uPlayer)) return SendClientMessage(playerid, 0xFFFFFFFF, "You specified an invalid player.");

	format(szMiscArray, sizeof(szMiscArray), "Name\tFlags");

	for(new i; i < AC_MAX; ++i) {

		switch(arrAntiCheat[playerid][ac_iFlags][i]) {

			case 0: format(szMiscArray, sizeof(szMiscArray), "%s\n{FFFFFF}%s\t%d", szMiscArray, AC_GetACName(i), arrAntiCheat[playerid][ac_iFlags][i]);
			case 1 .. 9: format(szMiscArray, sizeof(szMiscArray), "%s\n{FFFF00}%s\t{FFFF00}%d", szMiscArray, AC_GetACName(i), arrAntiCheat[playerid][ac_iFlags][i]);
			default: format(szMiscArray, sizeof(szMiscArray), "%s\n{FF0000}%s\t{FF0000}%d", szMiscArray, AC_GetACName(i), arrAntiCheat[playerid][ac_iFlags][i]);	
		}
	}
	format(szTitle, sizeof(szTitle), "AC System Flags | {FFFF00}(%s)", GetPlayerNameEx(uPlayer));
	ShowPlayerDialog(playerid, DIALOG_NOTHING, DIALOG_STYLE_TABLIST_HEADERS, szTitle, szMiscArray, "<>", "");
	SendClientMessageEx(playerid, COLOR_YELLOW, "---------- [ ANTICHEAT ] ----------");
	SendClientMessageEx(playerid, COLOR_GRAD1, "Jingles:");
	SendClientMessageEx(playerid, COLOR_YELLOW, "");
	SendClientMessageEx(playerid, COLOR_GRAD1, "These stats are still in beta.");
	SendClientMessageEx(playerid, COLOR_YELLOW, "------------------------------ ");
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
	ShowPlayerDialog(playerid, 32767, DIALOG_STYLE_TABLIST_HEADERS, szTitle, szMiscArray, "<>", "");
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