/*##############################################################################


					#########################################
					#										#
					#	  BUTTONS - INCLUDE FILE BY YOM		#
					#       Steal my work and die >:D		#
					#                                       #
					#########################################


- Informations about this file:
===============================

	-   A set of more or less useful functions related to buttons.
	-	You must run the Button FS or these function will not work.
	-   See in the filterscript for more informations


##############################################################################*/




/*----------------------------------------------------------------------------*/
#define INVALID_BUTTON_ID   -1
/*----------------------------------------------------------------------------*/




/*----------------------------------------------------------------------------*/
forward OnPlayerPressButton(playerid, buttonid);
forward OnButtonMoved(buttonid);
/*----------------------------------------------------------------------------*/




/*------------------------------------------------------------------------------
native CreateButton(Float:X, Float:Y, Float:Z, Float:Angle = 0.0);
native DestroyButton(buttonid);

native GetButtonPos(buttonid, &Float:X, &Float:Y, &Float:Z, &Float:Angle = 0.0);
native SetButtonPos(buttonid, Float:X, Float:Y, Float:Z, Float:Angle = 0.0);

native MoveButton(buttonid, Float:X, Float:Y, Float:Z, Float:Speed);
native StopButton(buttonid);

native PrintButtonsInfos();
native bool:IsValidButton(buttonid);
native GetHighestButtonID();
native GetButtonObjectID(buttonid);
native GetObjectButtonID(objectid);

native Float:GetDistanceToButton(buttonid, Float:X, Float:Y, Float:Z);
native Float:GetPlayerDistanceToButton(playerid, buttonid);
native GetClosestButton(Float:X, Float:Y, Float:Z, &Float:Distance = 0.0);
native GetPlayerClosestButton(playerid, &Float:Distance = 0.0);
native ToggleButtonEnabled(buttonid, bool:enabled);
native ToggleButtonEnabledForPlayer(playerid, buttonid, bool:enabled);
native TeleportPlayerToButton(playerid, buttonid);
------------------------------------------------------------------------------*/




/*----------------------------------------------------------------------------*/
stock CreateButton(Float:X, Float:Y, Float:Z, Float:Angle = 0.0)
	return CallRemoteFunction("FS_CreateButton", "ffff", X, Y, Z, Angle);



stock DestroyButton(buttonid)
	return CallRemoteFunction("FS_DestroyButton", "i", buttonid);
/*----------------------------------------------------------------------------*/




/*----------------------------------------------------------------------------*/
stock GetButtonPos(buttonid, &Float:X, &Float:Y, &Float:Z, &Float:Angle = 0.0)
{
	new objectid = GetButtonObjectID(buttonid);
	GetObjectPos(objectid, X, Y, Z);
	GetObjectRot(objectid, Angle, Angle, Angle);
}



stock SetButtonPos(buttonid, Float:X, Float:Y, Float:Z, Float:Angle = 0.0)
	return CallRemoteFunction("FS_SetButtonPos", "iffff", buttonid, X, Y, Z, Angle);
/*----------------------------------------------------------------------------*/




/*----------------------------------------------------------------------------*/
stock MoveButton(buttonid, Float:X, Float:Y, Float:Z, Float:Speed)
	return CallRemoteFunction("FS_MoveButton", "iffff", buttonid, X, Y, Z, Speed);



stock StopButton(buttonid)
	return CallRemoteFunction("FS_StopButton", "i", buttonid);
/*----------------------------------------------------------------------------*/




/*----------------------------------------------------------------------------*/
stock PrintButtonsInfos()
	return CallRemoteFunction("FS_PrintButtonsInfos", "");

stock bool:IsValidButton(buttonid)
	return bool:CallRemoteFunction("FS_IsValidButton", "i", buttonid);



stock GetHighestButtonID()
	return CallRemoteFunction("FS_GetHighestButtonID", "");



stock GetButtonObjectID(buttonid)
    return CallRemoteFunction("FS_GetButtonObjectID", "i", buttonid);



stock GetObjectButtonID(objectid)
    return CallRemoteFunction("FS_GetObjectButtonID", "i", objectid);
/*----------------------------------------------------------------------------*/




/*----------------------------------------------------------------------------*/
stock Float:GetDistanceToButton(buttonid, Float:X, Float:Y, Float:Z)
	return Float:CallRemoteFunction("FS_GetDistanceToButton", "ifff", buttonid, X, Y, Z);



stock GetClosestButton(Float:X, Float:Y, Float:Z, &Float:Distance = 0.0)
{
	new Closest = INVALID_BUTTON_ID, Float:Distance2 = 100000.0;

	for (new buttonid = 1, highest = GetHighestButtonID(); buttonid <= highest; buttonid ++)
	{
		if (IsValidButton(buttonid))
		{
			Distance = GetDistanceToButton(buttonid, X, Y, Z);

			if (Distance < Distance2)
			{
				Distance2 = Distance;
				Closest = buttonid;
			}
		}
	}

	Distance = Distance2;

	return Closest;
}

stock ToggleButtonEnabled(buttonid, bool:enabled)
	return CallRemoteFunction("FS_ToggleButtonEnabled", "ii", buttonid, enabled);
/*----------------------------------------------------------------------------*/




/*----------------------------------------------------------------------------*/
stock Float:GetPlayerDistanceToButton(playerid, buttonid)
{
	new Float:PlayerPos[3];
	GetPlayerPos(playerid, PlayerPos[0], PlayerPos[1], PlayerPos[2]);
	return GetDistanceToButton(buttonid, PlayerPos[0], PlayerPos[1], PlayerPos[2]);
}



stock GetPlayerClosestButton(playerid, &Float:Distance = 0.0)
{
	new Float:PlayerPos[3];
	GetPlayerPos(playerid, PlayerPos[0], PlayerPos[1], PlayerPos[2]);
	return GetClosestButton(PlayerPos[0], PlayerPos[1], PlayerPos[2], Distance);
}



stock TeleportPlayerToButton(playerid, buttonid)
	return CallRemoteFunction("FS_TeleportPlayerToButton", "ii", playerid, buttonid);



stock ToggleButtonEnabledForPlayer(playerid, buttonid, bool:enabled)
	return CallRemoteFunction("FS_ToggleButtonEnabledForPlayer", "iii", playerid, buttonid, enabled);
/*----------------------------------------------------------------------------*/
