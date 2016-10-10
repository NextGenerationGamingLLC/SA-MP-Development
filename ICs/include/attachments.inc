/*
attachments.inc
- This include fixes the attachments bug, which is expierenced while zooming with snipers, camera, RPGs..
- The attached object info now can be retrieved from GetPlayerAttachedObject
- This include also restores player attachments on Spawn, so they will remain!
- Disconnect fix; Destroys the attachments on Disconnect.
Author:
- Gammix
(c) Copyright 2015
- This file is provided as is (no warranties).
*/

/*
native SetPlayerAttachedObject(playerid, index, modelid, bone, Float:fOffsetX = 0.0, Float:fOffsetY = 0.0, Float:fOffsetZ = 0.0, Float:fRotX = 0.0, Float:fRotY = 0.0, Float:fRotZ = 0.0, Float:fScaleX = 1.0, Float:fScaleY = 1.0, Float:fScaleZ = 1.0, materialcolor1 = 0, materialcolor2 = 0);
native GetPlayerAttachedObject(playerid, index, &modelid, &bone, &Float:fOffsetX, &Float:fOffsetY, &Float:fOffsetZ, &Float:fRotX, &Float:fRotY, &Float:fRotZ, &Float:fScaleX, &Float:fScaleY, &Float:fScaleZ, &materialcolor1, &materialcolor2);
native RemovePlayerAttachedObject(playerid, index);
*/

#define att_modelid 		(0)
#define att_bone 			(1)
#define att_offset_x 		(2)
#define att_offset_y 		(3)
#define att_offset_z 		(4)
#define att_rot_x 			(5)
#define att_rot_y 			(6)
#define att_rot_z 			(7)
#define att_scale_x 		(8)
#define att_scale_y 		(9)
#define att_scale_z 		(10)
#define att_color_1 		(11)
#define att_color_2 		(12)
#define att_used 			(13)

new
	g_AttachmentData[][45] =
{
	"att_modelid",
	"att_bone",
	"att_offset_x",
	"att_offset_y",
	"att_offset_z",
	"att_rot_x",
	"att_rot_y",
	"att_rot_z",
	"att_scale_x",
	"att_scale_y",
	"att_scale_z",
	"att_color_1",
	"att_color_2",
	"att_used"
};

stock static ATT_SetInt(playerid, index, type, val)
{
	new
	    s_String[45]
	;

	format(s_String, sizeof(s_String), "%i_%s", index, g_AttachmentData[type]);

	return SetPVarInt(playerid, s_String, val);
}

stock static ATT_GetInt(playerid, index, type)
{
	new
	    s_String[45]
	;

	format(s_String, sizeof(s_String), "%i_%s", index, g_AttachmentData[type]);

	return GetPVarInt(playerid, s_String);
}

stock static ATT_SetFloat(playerid, index, type, Float:val)
{
	new
	    s_String[45]
	;

	format(s_String, sizeof(s_String), "%i_%s", index, g_AttachmentData[type]);

	return SetPVarFloat(playerid, s_String, val);
}

stock static Float:ATT_GetFloat(playerid, index, type)
{
	new
	    s_String[45]
	;

	format(s_String, sizeof(s_String), "%i_%s", index, g_AttachmentData[type]);

	return GetPVarFloat(playerid, s_String);
}

public OnPlayerSpawn(playerid)
{
	for(new i; i < MAX_PLAYER_ATTACHED_OBJECTS; i++)
	{
	    if(ATT_GetInt(playerid, i, att_used))
	    {
	        SetPlayerAttachedObject(	playerid,
										i,
										ATT_GetInt(playerid, i, att_modelid),
										ATT_GetInt(playerid, i, att_bone),
										ATT_GetFloat(playerid, i, att_offset_x),
										ATT_GetFloat(playerid, i, att_offset_y),
										ATT_GetFloat(playerid, i, att_offset_z),
										ATT_GetFloat(playerid, i, att_rot_x),
										ATT_GetFloat(playerid, i, att_rot_y),
										ATT_GetFloat(playerid, i, att_rot_z),
										ATT_GetFloat(playerid, i, att_scale_x),
										ATT_GetFloat(playerid, i, att_scale_y),
										ATT_GetFloat(playerid, i, att_scale_z),
										ATT_GetInt(playerid, i, att_color_1),
										ATT_GetInt(playerid, i, att_color_2)
									);
	    }
	}

    #if defined ATT_OnPlayerSpawn
       	return ATT_OnPlayerSpawn(playerid);
	#else
	   	return 1;
	#endif
}
#if defined _ALS_OnPlayerSpawn
    #undef OnPlayerSpawn
#else
    #define _ALS_OnPlayerSpawn
#endif
#define OnPlayerSpawn ATT_OnPlayerSpawn
#if defined ATT_OnPlayerSpawn
    forward ATT_OnPlayerSpawn(playerid);
#endif

public OnPlayerConnect(playerid)
{
	for(new i; i < MAX_PLAYER_ATTACHED_OBJECTS; i++)
	{
	    ATT_SetInt(playerid, i, att_used, false);
	}

    #if defined ATT_OnPlayerConnect
       	return ATT_OnPlayerConnect(playerid);
	#else
	   	return 1;
	#endif
}
#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect ATT_OnPlayerConnect
#if defined ATT_OnPlayerConnect
    forward ATT_OnPlayerConnect(playerid);
#endif

public OnPlayerDisconnect(playerid, reason)
{
	for(new i; i < MAX_PLAYER_ATTACHED_OBJECTS; i++)
	{
	    ATT_SetInt(playerid, i, att_used, false);

	    if(IsPlayerAttachedObjectSlotUsed(playerid, i))
	    {
	        RemovePlayerAttachedObject(playerid, i);
	    }
	}

    #if defined ATT_OnPlayerDisconnect
       	return ATT_OnPlayerDisconnect(playerid, reason);
	#else
	   	return 1;
	#endif
}
#if defined _ALS_OnPlayerDisconnect
    #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect ATT_OnPlayerDisconnect
#if defined ATT_OnPlayerDisconnect
    forward ATT_OnPlayerDisconnect(playerid, reason);
#endif

public OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
	ATT_SetInt(playerid, index, att_modelid, modelid);
	ATT_SetInt(playerid, index, att_bone, boneid);
	ATT_SetFloat(playerid, index, att_offset_x, fOffsetX);
	ATT_SetFloat(playerid, index, att_offset_y, fOffsetY);
	ATT_SetFloat(playerid, index, att_offset_z, fOffsetZ);
	ATT_SetFloat(playerid, index, att_rot_x, fRotX);
	ATT_SetFloat(playerid, index, att_rot_y, fRotY);
	ATT_SetFloat(playerid, index, att_rot_z, fRotZ);
	ATT_SetFloat(playerid, index, att_scale_x, fScaleX);
	ATT_SetFloat(playerid, index, att_scale_y, fScaleY);
	ATT_SetFloat(playerid, index, att_scale_z, fScaleZ);
	
	#if defined ATT_OnPlayerEditAttachedObject
		return ATT_OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerEditAttachedObject
	#undef OnPlayerEditAttachedObject
#else
	#define _ALS_OnPlayerEditAttachedObject
#endif
#define OnPlayerEditAttachedObject ATT_OnPlayerEditAttachedObject
#if defined ATT_OnPlayerEditAttachedObject
	forward ATT_OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ);
#endif

#if ! defined KEY_AIM
	#define KEY_AIM 128
#endif

#if ! defined HOLDING
    #define HOLDING(%0) ((newkeys & (%0)) == (%0))
#endif

#if ! defined RELEASED
	#define RELEASED(%0) (((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))
#endif

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if (HOLDING(KEY_AIM))
	{
	    switch (GetPlayerWeapon(playerid))
		{
			case WEAPON_SNIPER, WEAPON_ROCKETLAUNCHER, WEAPON_HEATSEEKER, WEAPON_CAMERA:
			{
			    for (new i; i < MAX_PLAYER_ATTACHED_OBJECTS; i++)
				{
				    if (IsPlayerAttachedObjectSlotUsed(playerid, i) &&
	    				ATT_GetInt(playerid, i, att_used))
				    {
						RemovePlayerAttachedObject(playerid, i);
	     			}
		        }
		    }
		}
	}
	if(RELEASED(KEY_AIM))
	{
	    for (new i; i < MAX_PLAYER_ATTACHED_OBJECTS; i++)
		{
		    if (! IsPlayerAttachedObjectSlotUsed(playerid, i) &&
				ATT_GetInt(playerid, i, att_used))
		    {
		        SetPlayerAttachedObject(	playerid,
											i,
											ATT_GetInt(playerid, i, att_modelid),
											ATT_GetInt(playerid, i, att_bone),
											ATT_GetFloat(playerid, i, att_offset_x),
											ATT_GetFloat(playerid, i, att_offset_y),
											ATT_GetFloat(playerid, i, att_offset_z),
											ATT_GetFloat(playerid, i, att_rot_x),
											ATT_GetFloat(playerid, i, att_rot_y),
											ATT_GetFloat(playerid, i, att_rot_z),
											ATT_GetFloat(playerid, i, att_scale_x),
											ATT_GetFloat(playerid, i, att_scale_y),
											ATT_GetFloat(playerid, i, att_scale_z),
											ATT_GetInt(playerid, i, att_color_1),
											ATT_GetInt(playerid, i, att_color_2)
									);
		    }
		}
	}

	#if defined ATT_OnPlayerKeyStateChange
       	return ATT_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
	#else
	   	return 1;
	#endif
}
#if defined _ALS_OnPlayerKeyStateChange
    #undef OnPlayerKeyStateChange
#else
    #define _ALS_OnPlayerKeyStateChange
#endif
#define OnPlayerKeyStateChange ATT_OnPlayerKeyStateChange
#if defined ATT_OnPlayerKeyStateChange
    forward ATT_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
#endif

stock ATT_SetPlayerAttachedObject(playerid, index, modelid, bone, Float:fOffsetX = 0.0, Float:fOffsetY = 0.0, Float:fOffsetZ = 0.0, Float:fRotX = 0.0, Float:fRotY = 0.0, Float:fRotZ = 0.0, Float:fScaleX = 1.0, Float:fScaleY = 1.0, Float:fScaleZ = 1.0, materialcolor1 = 0, materialcolor2 = 0)
{
	if(SetPlayerAttachedObject(playerid, index, modelid, bone, fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ, materialcolor1, materialcolor2))
	{
	    ATT_SetInt(playerid, index, att_modelid, modelid);
		ATT_SetInt(playerid, index, att_bone, bone);
		ATT_SetFloat(playerid, index, att_offset_x, fOffsetX);
		ATT_SetFloat(playerid, index, att_offset_y, fOffsetY);
		ATT_SetFloat(playerid, index, att_offset_z, fOffsetZ);
		ATT_SetFloat(playerid, index, att_rot_x, fRotX);
		ATT_SetFloat(playerid, index, att_rot_y, fRotY);
		ATT_SetFloat(playerid, index, att_rot_z, fRotZ);
		ATT_SetFloat(playerid, index, att_scale_x, fScaleX);
		ATT_SetFloat(playerid, index, att_scale_y, fScaleY);
		ATT_SetFloat(playerid, index, att_scale_z, fScaleZ);
		ATT_SetInt(playerid, index, att_color_1, materialcolor1);
		ATT_SetInt(playerid, index, att_color_2, materialcolor2);

		ATT_SetInt(playerid, index, att_used, true);
		return true;
	}
	return false;
}
#if defined _ALS_SetPlayerAttachedObject
    #undef SetPlayerAttachedObject
#else
    #define _ALS_SetPlayerAttachedObject
#endif
#define SetPlayerAttachedObject ATT_SetPlayerAttachedObject

stock GetPlayerAttachedObject(playerid, index, &modelid, &bone, &Float:fOffsetX, &Float:fOffsetY, &Float:fOffsetZ, &Float:fRotX, &Float:fRotY, &Float:fRotZ, &Float:fScaleX, &Float:fScaleY, &Float:fScaleZ, &materialcolor1, &materialcolor2)
{
    if(ATT_GetInt(playerid, index, att_used))
    {
        modelid = ATT_GetInt(playerid, index, att_modelid);
		bone = ATT_GetInt(playerid, index, att_bone);
		fOffsetX = ATT_GetFloat(playerid, index, att_offset_x);
		fOffsetY = ATT_GetFloat(playerid, index, att_offset_y);
		fOffsetZ = ATT_GetFloat(playerid, index, att_offset_z);
		fRotX = ATT_GetFloat(playerid, index, att_rot_x);
		fRotY = ATT_GetFloat(playerid, index, att_rot_y);
		fRotZ = ATT_GetFloat(playerid, index, att_rot_z);
		fScaleX = ATT_GetFloat(playerid, index, att_scale_x);
		fScaleY = ATT_GetFloat(playerid, index, att_scale_y);
		fScaleZ = ATT_GetFloat(playerid, index, att_scale_z);
		materialcolor1 = ATT_GetInt(playerid, index, att_color_1);
		materialcolor2 = ATT_GetInt(playerid, index, att_color_2);
        return true;
    }
	return false;
}

stock ATT_RemovePlayerAttachedObject(playerid, index)
{
	if(RemovePlayerAttachedObject(playerid, index))
	{
		ATT_SetInt(playerid, index, att_used, false);
		return true;
	}
	return false;
}
#if defined _ALS_RemovePlayerAttachedObject
    #undef RemovePlayerAttachedObject
#else
    #define _ALS_RemovePlayerAttachedObject
#endif
#define RemovePlayerAttachedObject ATT_RemovePlayerAttachedObject

#undef att_modelid
#undef att_bone
#undef att_offset_x
#undef att_offset_y
#undef att_offset_z
#undef att_rot_x
#undef att_rot_y
#undef att_rot_z
#undef att_scale_x
#undef att_scale_y
#undef att_scale_z
#undef att_color_1
#undef att_color_2
#undef att_used