/*
    	 		 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
				| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
				| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
				| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
				| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
				| $$\  $$$| $$  \ $$        | $$  \ $$| $$
				| $$ \  $$|  $$$$$$/        | $$  | $$| $$
				|__/  \__/ \______/         |__/  |__/|__/

//--------------------------------[IRC.PWN]--------------------------------


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
 
/*
 *  walkstyle.inc - Walking/running styles.
 *  Created by Emmet on November 3, 2012 @ 9:19 AM
*/

#include <YSI\y_hooks>

#if defined walkstyle_included
	#endinput
#endif
#define walkstyle_included

/*
	native SetWalkingKey(key);
	native AddWalkingStyle(animlib[], animname[], Float:fDelta = 4.0, loop = 1, lockx = 1, locky = 1, freeze = 1, time = 1);
	native RemoveWalkingStyle(styleid);
	native SetPlayerWalkingStyle(playerid, styleid);
	native ResetPlayerWalkingStyle(playerid);
	native IsPlayerWalking(playerid);
*/

#if !defined MAX_WALKING_STYLES
	#define MAX_WALKING_STYLES (128)
#endif

#define IsPlayerWalking(%0)         GetPVarInt(%0, "Walking")

new PlayerWalkStyle[27];
hook OnGameModeInit()
{
	PlayerWalkStyle[1] = AddWalkingStyle("PED", "JOG_femaleA");
	PlayerWalkStyle[2] = AddWalkingStyle("PED", "JOG_maleA");
	PlayerWalkStyle[3] = AddWalkingStyle("PED", "WOMAN_walkfatold");
	PlayerWalkStyle[4] = AddWalkingStyle("PED", "run_fat");
	PlayerWalkStyle[5] = AddWalkingStyle("PED", "run_fatold");
	PlayerWalkStyle[6] = AddWalkingStyle("PED", "run_old");
	PlayerWalkStyle[7] = AddWalkingStyle("PED", "Run_Wuzi");
	PlayerWalkStyle[8] = AddWalkingStyle("PED", "swat_run");
	PlayerWalkStyle[9] = AddWalkingStyle("PED", "WALK_fat");
	PlayerWalkStyle[10] = AddWalkingStyle("PED", "WALK_fatold");
	PlayerWalkStyle[11] = AddWalkingStyle("PED", "WALK_gang1");
	PlayerWalkStyle[12] = AddWalkingStyle("PED", "WALK_gang2");
	PlayerWalkStyle[13] = AddWalkingStyle("PED", "WALK_old");
	PlayerWalkStyle[14] = AddWalkingStyle("PED", "WALK_shuffle");
	PlayerWalkStyle[15] = AddWalkingStyle("PED", "woman_run");
	PlayerWalkStyle[16] = AddWalkingStyle("PED", "WOMAN_runbusy");
	PlayerWalkStyle[17] = AddWalkingStyle("PED", "WOMAN_runfatold");
	PlayerWalkStyle[18] = AddWalkingStyle("PED", "woman_runpanic");
	PlayerWalkStyle[19] = AddWalkingStyle("PED", "WOMAN_runsexy");
	PlayerWalkStyle[20] = AddWalkingStyle("PED", "WOMAN_walkbusy");
	PlayerWalkStyle[21] = AddWalkingStyle("PED", "WOMAN_walkfatold");
	PlayerWalkStyle[22] = AddWalkingStyle("PED", "WOMAN_walknorm");
	PlayerWalkStyle[23] = AddWalkingStyle("PED", "WOMAN_walkold");
	PlayerWalkStyle[24] = AddWalkingStyle("PED", "WOMAN_walkpro");
	PlayerWalkStyle[25] = AddWalkingStyle("PED", "WOMAN_walksexy");
	PlayerWalkStyle[26] = AddWalkingStyle("PED", "WOMAN_walkshop");
}

enum E_WALKING_ENUM
{
	E_STYLE_ACTIVE,
	E_STYLE_LIB[32],
	E_STYLE_ANIM[32],
	Float:E_STYLE_DELTA,
	E_STYLE_LOOP,
	E_STYLE_LOCK_X,
	E_STYLE_LOCK_Y,
	E_STYLE_FREEZE,
	E_STYLE_TIME
};
new WalkingStyles[MAX_WALKING_STYLES + 1][E_WALKING_ENUM];
new walking_key = KEY_WALK;

stock SetWalkingKey(key)
{
	if (walking_key == key) return 0;
	walking_key = key;
	return 1;
}

stock AddWalkingStyle(animlib[], animname[], Float:fDelta = 4.0, loop = 1, lockx = 1, locky = 1, freeze = 1, time = 1)
{
	new id;
	for (new i = 1; i < sizeof(WalkingStyles); i ++)
	{
		if (!WalkingStyles[i][E_STYLE_ACTIVE])
		{
		    id = i;
		    break;
		}
	}
	if (!id)
	{
		return 0;
	}
	else
	{
	 	WalkingStyles[id][E_STYLE_ACTIVE] = 1;
		format(WalkingStyles[id][E_STYLE_LIB], 32, animlib);
		format(WalkingStyles[id][E_STYLE_ANIM], 32, animname);
		WalkingStyles[id][E_STYLE_DELTA] = fDelta;
		WalkingStyles[id][E_STYLE_LOOP] = loop;
		WalkingStyles[id][E_STYLE_LOCK_X] = lockx;
		WalkingStyles[id][E_STYLE_LOCK_Y] = locky;
		WalkingStyles[id][E_STYLE_FREEZE] = freeze;
		WalkingStyles[id][E_STYLE_TIME] = time;
	}
	return id;
}

stock RemoveWalkingStyle(styleid)
{
	if (styleid < 1 || styleid > MAX_WALKING_STYLES)
	{
	    return 0;
	}
	else if (!WalkingStyles[styleid][E_STYLE_ACTIVE])
	{
	    return 0;
	}
	else
	{
	    for (new i = 0; i < MAX_PLAYERS; i ++)
	    {
	        if (IsPlayerConnected(i) && PlayerInfo[i][pWalkStyle] == styleid)
	        {
	            ResetPlayerWalkingStyle(i);
	        }
		}
	    WalkingStyles[styleid][E_STYLE_ACTIVE] = 0;
		strdel(WalkingStyles[styleid][E_STYLE_LIB], 0, 32);
		strdel(WalkingStyles[styleid][E_STYLE_ANIM], 0, 32);
		WalkingStyles[styleid][E_STYLE_DELTA] = 0.0;
		WalkingStyles[styleid][E_STYLE_LOOP] = 0;
		WalkingStyles[styleid][E_STYLE_LOCK_X] = 0;
		WalkingStyles[styleid][E_STYLE_LOCK_Y] = 0;
		WalkingStyles[styleid][E_STYLE_FREEZE] = 0;
		WalkingStyles[styleid][E_STYLE_TIME] = 0;
	}
	return 1;
}

stock SetPlayerWalkingStyle(playerid, styleid)
{
	if(PlayerInfo[playerid][pWalkStyle] == styleid) return 0;
	return PlayerInfo[playerid][pWalkStyle] = styleid;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    new animlib[32], animname[32], Float:x, Float:y, Float:z;
	GetPlayerVelocity(playerid, x, y, z);
    GetAnimationName(GetPlayerAnimationIndex(playerid), animlib, sizeof(animlib), animname, sizeof(animname));

	if (newkeys & walking_key && PlayerInfo[playerid][pWalkStyle] && strfind(animname, "JUMP", false) == -1 && floatsqroot(floatpower(x, 2) + floatpower(y, 2) + floatpower(z, 2)) <= 0.05)
	{
	    if (GetPlayerAnimationIndex(playerid) >= 1538 && GetPlayerAnimationIndex(playerid) <= 1544 && GetPlayerAnimationIndex(playerid) != 1542)
	    {
	        return 0;
	    }
	    if (!GetPVarInt(playerid, "Frozen"))
	    {
	        new styleid = PlayerInfo[playerid][pWalkStyle];
	        switch (GetPVarInt(playerid, "Walking"))
	        {
		        case 0:
		        {
					if (WalkingStyles[styleid][E_STYLE_ACTIVE] && strlen(WalkingStyles[styleid][E_STYLE_LIB]) && strlen(WalkingStyles[styleid][E_STYLE_ANIM]))
					{
			 	 		ApplyAnimation(playerid, WalkingStyles[styleid][E_STYLE_LIB], WalkingStyles[styleid][E_STYLE_ANIM], WalkingStyles[styleid][E_STYLE_DELTA], WalkingStyles[styleid][E_STYLE_LOOP], WalkingStyles[styleid][E_STYLE_LOCK_X], WalkingStyles[styleid][E_STYLE_LOCK_Y], WalkingStyles[styleid][E_STYLE_FREEZE], WalkingStyles[styleid][E_STYLE_TIME], 1);
			  			SetPVarInt(playerid, "Walking", 1);
					}
				}
				case 1:
				{
					if (WalkingStyles[styleid][E_STYLE_ACTIVE] && strlen(WalkingStyles[styleid][E_STYLE_LIB]) && strlen(WalkingStyles[styleid][E_STYLE_ANIM]))
					{
			 	 		ApplyAnimation(playerid, WalkingStyles[styleid][E_STYLE_LIB], WalkingStyles[styleid][E_STYLE_ANIM], WalkingStyles[styleid][E_STYLE_DELTA], 0, WalkingStyles[styleid][E_STYLE_LOCK_X], WalkingStyles[styleid][E_STYLE_LOCK_Y], 0, WalkingStyles[styleid][E_STYLE_TIME], 1);
					}
				    DeletePVar(playerid, "Walking");
				}
			}
		}
	}
    return CallLocalFunction("walk_OnPlayerKeyStateChange", "ddd", playerid, newkeys, oldkeys);
}

stock ResetPlayerWalkingStyle(playerid)
{
	PlayerInfo[playerid][pWalkStyle] = 0;
	if(GetPVarInt(playerid, "Walking"))
	{
	    new styleid = PlayerInfo[playerid][pWalkStyle];
		if (WalkingStyles[styleid][E_STYLE_ACTIVE] && strlen(WalkingStyles[styleid][E_STYLE_LIB]) && strlen(WalkingStyles[styleid][E_STYLE_ANIM]))
		{
			ApplyAnimation(playerid, WalkingStyles[styleid][E_STYLE_LIB], WalkingStyles[styleid][E_STYLE_ANIM], WalkingStyles[styleid][E_STYLE_DELTA], 0, WalkingStyles[styleid][E_STYLE_LOCK_X], WalkingStyles[styleid][E_STYLE_LOCK_Y], 0, WalkingStyles[styleid][E_STYLE_TIME], 1);
		}
  		DeletePVar(playerid, "Walking");
	}
	return 1;
}

stock walk_TogglePlayerControllable(playerid, toggle)
{
	SetPVarInt(playerid, "Frozen", !toggle);
	return TogglePlayerControllable(playerid, toggle);
}

#define TogglePlayerControllable walk_TogglePlayerControllable

#if defined _ALS_OnPlayerKeyStateChange
    #undef OnPlayerKeyStateChange
#else
    #define _ALS_OnPlayerKeyStateChange
#endif
#define OnPlayerKeyStateChange walk_OnPlayerKeyStateChange
forward walk_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);

CMD:walkstyle(playerid, params[])
{
	if(isnull(params))
	{
	    SendClientMessage(playerid, COLOR_GRAD2, "USAGE: /walkstyle [1-26]");
		return 1;
	}
	new string[64], styleid = strval(params);
	if(styleid == 0)
	{
		ResetPlayerWalkingStyle(playerid);
		return SendClientMessage(playerid, COLOR_WHITE, "* Walking style has been reset!");
	}
	if(styleid < 1 || styleid > 26) return SendClientMessage(playerid, COLOR_GRAD2, "Style can't be below 1, or above 26.");
	SetPlayerWalkingStyle(playerid, PlayerWalkStyle[styleid]);
	format(string, sizeof(string), "* Walking style set to %d.", styleid);
	SendClientMessage(playerid, COLOR_WHITE, string);
	return 1;
}