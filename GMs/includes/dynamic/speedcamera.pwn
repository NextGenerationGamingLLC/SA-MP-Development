/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

					Dynamic Camera System 

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
hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	if (dialogid == SPEEDCAM_DIALOG_MAIN)
	{
		if (!response) return 1;
		switch (listitem)
		{
			case 0:
			{
				if (SpeedCameras[MAX_SPEEDCAMERAS - 1][_scActive])
					return SendClientMessageEx(playerid, COLOR_GREY, "No more static speed cameras can be created.");
				ShowPlayerDialogEx(playerid, SPEEDCAM_DIALOG_RANGEC, DIALOG_STYLE_INPUT, "{FFFF00}Create a speed camera", "{FFFFFF}Enter the range of your camera.", "OK", "Back");
			}
			case 1:
			{
				ShowPlayerDialogEx(playerid, SPEEDCAM_DIALOG_EDIT, DIALOG_STYLE_INPUT, "{FFFF00}Edit a speed camera", "{FFFFFF}Enter the ID of the speed camera you wish to edit.", "OK", "Back");
			}
			case 2:
			{
				ShowPlayerDialogEx(playerid, SPEEDCAM_DIALOG_DELETE, DIALOG_STYLE_INPUT, "{FFFF00}Delete a speed camera", "{FFFFFF}Enter the ID of the speed camera you wish to delete.", "OK", "Back");
			}
			case 3:
			{
				new Float:playerPos[3];
				GetPlayerPos(playerid, playerPos[0], playerPos[1], playerPos[2]);

				new Float:distances[MAX_SPEEDCAMERAS];
				for (new c = 0; c < MAX_SPEEDCAMERAS; c++)
				{
					distances[c] = -1.000;
					if (SpeedCameras[c][_scActive] == true)
					{
						new Float:tmpPos[3];
						tmpPos[0] = SpeedCameras[c][_scPosX];
						tmpPos[1] = SpeedCameras[c][_scPosY];
						tmpPos[2] = SpeedCameras[c][_scPosZ];
						new Float:distance = floatsqroot(((playerPos[0] - tmpPos[0]) * (playerPos[0] - tmpPos[0])) + ((playerPos[1] - tmpPos[1]) * (playerPos[1] - tmpPos[1])) \
							+ ((playerPos[2] - tmpPos[2]) * ((playerPos[2] - tmpPos[2]))));
						distances[c] = distance;
					}
				}
				
				new lowest_index = -1;
				for (new i = 0; i < MAX_SPEEDCAMERAS; i++)
				{
					if (distances[i] != -1.000)
					{
						if (lowest_index == -1.000)
						{
							lowest_index = i;
						}
						else
						{
							if (distances[i] < distances[lowest_index])
								lowest_index = i;
						}
					}
				}
				if (lowest_index == -1) // no cameras exist, the closest cannot be calculated
				{
					ShowPlayerDialogEx(playerid, SPEEDCAM_DIALOG_GETNEAREST, DIALOG_STYLE_MSGBOX, "{FFFF00}Nearest speed camera", "{FFFFFF}No speed cameras exist, and thus the closest cannot be found.", "OK", "");
				}
				else
				{
					new msg[128];
					format(msg, sizeof(msg), "{FFFFFF}The nearest speed camera is: {FFFF00}%i\n\n{FFFFFF}With a distance of {FFFF00}%f", lowest_index, distances[lowest_index]);
					ShowPlayerDialogEx(playerid, SPEEDCAM_DIALOG_GETNEAREST, DIALOG_STYLE_MSGBOX, "{FFFF00}Nearest speed camera", msg, "OK", "");
				}
			}
		}
	}
	if (dialogid == SPEEDCAM_DIALOG_RANGEC)
	{
		if (!response)
			return ShowPlayerDialogEx(playerid, SPEEDCAM_DIALOG_MAIN, DIALOG_STYLE_LIST, "{FFFF00}Speed Cameras", \
					"Create a speed camera\nEdit a speed camera\nDelete a speed camera\nGet nearest speedcamera", "Select", "Cancel");

		new Float:range;
		if (sscanf(inputtext, "f", range))
		{
			return ShowPlayerDialogEx(playerid, SPEEDCAM_DIALOG_RANGEC, DIALOG_STYLE_INPUT, "{FFFF00}Create a speed camera", "{FFFFFF}Enter the range of your camera.\
					\n\n{FFFF00}Value must be a number (decimal places allowed).", "OK", "Back");
		}
		SetPVarFloat(playerid, "_scCacheRange", range);
		ShowPlayerDialogEx(playerid, SPEEDCAM_DIALOG_LIMIT, DIALOG_STYLE_INPUT, "{FFFF00}Create a speed camera", "{FFFFFF}Enter the limit of your camera (mph).", "OK", "Back");
	}
	if (dialogid == SPEEDCAM_DIALOG_LIMIT)
	{
		if (!response)
			return ShowPlayerDialogEx(playerid, SPEEDCAM_DIALOG_RANGEC, DIALOG_STYLE_INPUT, "{FFFF00}Create a speed camera", "{FFFFFF}Enter the range of your camera.", "OK", "Back");

		new Float:limit;
		if (sscanf(inputtext, "f", limit))
		{
			return ShowPlayerDialogEx(playerid, SPEEDCAM_DIALOG_LIMIT, DIALOG_STYLE_INPUT, "{FFFF00}Create a speed camera", "{FFFFFF}Enter the limit of your camera (mph).\
				\n\n{FFFF00}Value must be a number (decimal places allowed).", "OK", "Back");
		}
		SetPVarFloat(playerid, "_scCacheLimit", limit);
		new Float:range = GetPVarFloat(playerid, "_scCacheRange");
		new content[256];
		format(content, sizeof(content), "{FFFF00}Range: {FFFFFF}%f\n{FFFF00}Limit: {FFFFFF}%f mph\n\nAre you sure you want to create this speed camera?", range, limit);
		ShowPlayerDialogEx(playerid, SPEEDCAM_DIALOG_OVERVIEW, DIALOG_STYLE_MSGBOX, "{FFFF00}Speed camera overview", content, "Confirm", "Cancel");
	}
	if (dialogid == SPEEDCAM_DIALOG_OVERVIEW)
	{
		if (!response)
		{
			DeletePVar(playerid, "_scCacheRange");
			DeletePVar(playerid, "_scCacheLimit");
			return SendClientMessageEx(playerid, COLOR_RED, "Cancelled creation of speed camera.");
		}
		if (SpeedCameras[MAX_SPEEDCAMERAS - 1][_scActive])
		{
			DeletePVar(playerid, "_scCacheRange");
			DeletePVar(playerid, "_scCacheLimit");
			return SendClientMessageEx(playerid, COLOR_RED, "Error: Limit was reached whilst you were creating this camera.");
		}
		new Float:range = GetPVarFloat(playerid, "_scCacheRange");
		new Float:limit = GetPVarFloat(playerid, "_scCacheLimit");
		DeletePVar(playerid, "_scCacheRange");
		DeletePVar(playerid, "_scCacheLimit");

		new Float:x, Float:y, Float:z, Float:angle;
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, angle);

		z -= 3.00000; // for height issues
		angle += 180; // flip the angle

		new cam = CreateSpeedCamera(x, y, z, angle, range, limit);
		SendClientMessageEx(playerid, COLOR_GREEN, "Speed camera created!");

		new logText[128];
		format(logText, sizeof(logText), "%s(%d) has placed speed camera %d at [%f, %f, %f] with limit %f and range %f.",
			GetPlayerNameExt(playerid), GetPlayerSQLId(playerid), SpeedCameras[cam][_scDatabase], SpeedCameras[cam][_scPosX], SpeedCameras[cam][_scPosY], SpeedCameras[cam][_scPosZ], SpeedCameras[cam][_scLimit], SpeedCameras[cam][_scRange]);
		Log("logs/speedcam.log", logText);
	}
	if (dialogid == SPEEDCAM_DIALOG_EDIT)
	{
		if (!response)
			return ShowPlayerDialogEx(playerid, SPEEDCAM_DIALOG_MAIN, DIALOG_STYLE_LIST, "{FFFF00}Speed Cameras", "Create a speed camera\nEdit a speed camera\nDelete a speed camera\n\
				Get nearest speedcamera", \
				"Select", "Cancel");

		new id;
		if (sscanf(inputtext, "i", id))
			return ShowPlayerDialogEx(playerid, SPEEDCAM_DIALOG_EDIT, DIALOG_STYLE_INPUT, "{FFFF00}Edit a speed camera", "{FFFFFF}Enter the ID of the speed camera you wish to edit.\n\n\
				{FFFF00}ID must be a number.", "OK", "Back");

		if (id >= MAX_SPEEDCAMERAS || id < 0)
			return ShowPlayerDialogEx(playerid, SPEEDCAM_DIALOG_EDIT, DIALOG_STYLE_INPUT, "{FFFF00}Edit a speed camera", "{FFFFFF}Enter the ID of the speed camera you wish to edit.\n\n\
				{FFFF00}ID must not be above the maximum or below 0.", "OK", "Back");

		if (SpeedCameras[id][_scActive] == false)
			return ShowPlayerDialogEx(playerid, SPEEDCAM_DIALOG_EDIT, DIALOG_STYLE_INPUT, "{FFFF00}Edit a speed camera", "{FFFFFF}Enter the ID of the speed camera you wish to edit.\n\n\
				{FFFF00}No active speed camera with that ID.", "OK", "Back");

		SetPVarInt(playerid, "_scCacheEditId", id);
		ShowPlayerDialogEx(playerid, SPEEDCAM_DIALOG_EDIT_IDX, DIALOG_STYLE_LIST, "{FFFF00}Edit a speed camera", "Move position to player\nSet angle\nSet range\nSet limit", "Select", "Back");
	}
	if (dialogid == SPEEDCAM_DIALOG_EDIT_IDX)
	{
		if (!response)
		{
			DeletePVar(playerid, "_scCacheEditId");
			return ShowPlayerDialogEx(playerid, SPEEDCAM_DIALOG_MAIN, DIALOG_STYLE_LIST, "{FFFF00}Speed Cameras", "Create a speed camera\nEdit a speed camera\nDelete a speed camera\n\
				Get nearest speedcamera", \
				"Select", "Cancel");
		}

		switch (listitem)
		{
			case 0:
			{
				new Float:x, Float:y, Float:z, Float:angle;
				GetPlayerPos(playerid, x, y, z);
				GetPlayerFacingAngle(playerid, angle);
				new id = GetPVarInt(playerid, "_scCacheEditId");

				SpeedCameras[id][_scPosX] = x;
				SpeedCameras[id][_scPosY] = y;
				SpeedCameras[id][_scPosZ] = z;
				SpeedCameras[id][_scRotation] = angle - 180;

				SetDynamicObjectPos(SpeedCameras[id][_scObjectId], x, y, z-3.000);
				SetDynamicObjectRot(SpeedCameras[id][_scObjectId], 0, 0, angle - 180);
				SetPlayerPos(playerid, x + 1, y, z);
				SaveSpeedCamera(id);
				SendClientMessageEx(playerid, COLOR_WHITE, "Speed camera moved.");

				new logText[128];
				format(logText, sizeof(logText), "%s(%d) has moved speed camera %d to [%f, %f, %f]",
					GetPlayerNameExt(playerid), GetPlayerSQLId(playerid), SpeedCameras[id][_scDatabase], SpeedCameras[id][_scPosX], SpeedCameras[id][_scPosY], SpeedCameras[id][_scPosZ]);
				Log("logs/speedcam.log", logText);

				ShowPlayerDialogEx(playerid, SPEEDCAM_DIALOG_EDIT_IDX, DIALOG_STYLE_LIST, "{FFFF00}Edit a speed camera", "Move position to player\nSet angle\nSet range\nSet limit", "Select", "Back");
			}
			case 1:
			{
				ShowPlayerDialogEx(playerid, SPEEDCAM_DIALOG_EDIT_ROT, DIALOG_STYLE_INPUT, "{FFFF00}Edit a speed camera", "{FFFFFF}Enter the new (Z) angle of the speed camera.", "OK", "Back");
			}
			case 2:
			{
				ShowPlayerDialogEx(playerid, SPEEDCAM_DIALOG_EDIT_RANGE, DIALOG_STYLE_INPUT, "{FFFF00}Edit a speed camera", "{FFFFFF}Enter the new range of the speed camera.", "OK", "Back");
			}
			case 3:
			{
				ShowPlayerDialogEx(playerid, SPEEDCAM_DIALOG_EDIT_LIMIT, DIALOG_STYLE_INPUT, "{FFFF00}Edit a speed camera", "{FFFFFF}Enter the new speed limit of the speed camera (mph).", "OK", "Back");
			}
		}
	}
	if (dialogid == SPEEDCAM_DIALOG_EDIT_ROT)
	{
		if (!response)
		{
			return ShowPlayerDialogEx(playerid, SPEEDCAM_DIALOG_EDIT_IDX, DIALOG_STYLE_LIST, "{FFFF00}Edit a speed camera", "Move position to player\nSet angle\nSet range\nSet limit", "Select", "Back");
		}

		new Float:angle;
		if (sscanf(inputtext, "f", angle))
		{
			return ShowPlayerDialogEx(playerid, SPEEDCAM_DIALOG_EDIT_ROT, DIALOG_STYLE_LIST, "{FFFF00}Edit a speed camera", "{FFFFFF}Enter the new (Z) angle of the speed camera.\n\n\
				{FFFF00}The angle must be a number (decimals allowed).", "OK", "Back");
		}

		new id = GetPVarInt(playerid, "_scCacheEditId");
		SetDynamicObjectRot(SpeedCameras[id][_scObjectId], 0, 0, angle);
		SpeedCameras[id][_scRotation] = angle;
		SaveSpeedCamera(id);
		SendClientMessageEx(playerid, COLOR_WHITE, "Speed camera's Z-angle changed.");

		new logText[128];
		format(logText, sizeof(logText), "%s(%d) has changed speed camera %d's z-angle to %f",
			GetPlayerNameExt(playerid), GetPlayerSQLId(playerid), SpeedCameras[id][_scDatabase], SpeedCameras[id][_scRotation]);
		Log("logs/speedcam.log", logText);
		ShowPlayerDialogEx(playerid, SPEEDCAM_DIALOG_EDIT_IDX, DIALOG_STYLE_LIST, "{FFFF00}Edit a speed camera", "Move position to player\nSet angle\nSet range\nSet limit", "Select", "Back");
	}
	if (dialogid == SPEEDCAM_DIALOG_EDIT_RANGE)
	{
		if (!response)
			return ShowPlayerDialogEx(playerid, SPEEDCAM_DIALOG_EDIT_IDX, DIALOG_STYLE_LIST, "{FFFF00}Edit a speed camera", "Move position to player\nSet angle\nSet range\nSet limit", "Select", "Back");

		new Float:range;
		if (sscanf(inputtext, "f", range))
		{
			return ShowPlayerDialogEx(playerid, SPEEDCAM_DIALOG_EDIT_RANGE, DIALOG_STYLE_INPUT, "{FFFF00}Edit a speed camera", "{FFFFFF}Enter the new range of the speed camera.\n\n\
				{FFFF00}Range must be a number (decimals allowed).", "OK", "Back");
		}

		new id = GetPVarInt(playerid, "_scCacheEditId");
		SpeedCameras[id][_scRange] = range;
		SaveSpeedCamera(id);
		SendClientMessageEx(playerid, COLOR_WHITE, "Speed camera's ranged changed.");

		new logText[128];
		format(logText, sizeof(logText), "%s(%d) has changed speed camera %d's range to %f",
			GetPlayerNameExt(playerid), GetPlayerSQLId(playerid), SpeedCameras[id][_scDatabase], SpeedCameras[id][_scRange]);
		Log("logs/speedcam.log", logText);
		ShowPlayerDialogEx(playerid, SPEEDCAM_DIALOG_EDIT_IDX, DIALOG_STYLE_LIST, "{FFFF00}Edit a speed camera", "Move position to player\nSet angle\nSet range\nSet limit", "Select", "Back");
	}
	if (dialogid == SPEEDCAM_DIALOG_EDIT_LIMIT)
	{
		if (!response)
			return ShowPlayerDialogEx(playerid, SPEEDCAM_DIALOG_EDIT_IDX, DIALOG_STYLE_LIST, "{FFFF00}Edit a speed camera", "Move position to player\nSet angle\nSet range\nSet limit", "Select", "Back");

		new Float:limit;
		if (sscanf(inputtext, "f", limit))
		{
			return ShowPlayerDialogEx(playerid, SPEEDCAM_DIALOG_EDIT_LIMIT, DIALOG_STYLE_INPUT, "{FFFF00}Edit a speed camera", "{FFFFFF}Enter the new speed limit of the speed camera (mph).\n\n\
				{FFFF00}Limit must be a number (decimals allowed).", "OK", "Back");
		}

		new id = GetPVarInt(playerid, "_scCacheEditId");
		SpeedCameras[id][_scLimit] = limit;

		new szLimit[50];
		format(szLimit, sizeof(szLimit), "{FFFFFF}Speed Limit\n{FF0000}%i {FFFFFF}MPH", floatround(SpeedCameras[id][_scLimit], floatround_round));
		UpdateDynamic3DTextLabelText(SpeedCameras[id][_scTextID], COLOR_TWWHITE, szLimit);
		SaveSpeedCamera(id);
		SendClientMessageEx(playerid, COLOR_WHITE, "Speed camera's limit changed.");

		new logText[128];
		format(logText, sizeof(logText), "%s(%d) has changed speed camera %d's limit to %f",
			GetPlayerNameExt(playerid), GetPlayerSQLId(playerid), SpeedCameras[id][_scDatabase], SpeedCameras[id][_scLimit]);
		Log("logs/speedcam.log", logText);
		ShowPlayerDialogEx(playerid, SPEEDCAM_DIALOG_EDIT_IDX, DIALOG_STYLE_LIST, "{FFFF00}Edit a speed camera", "Move position to player\nSet angle\nSet range\nSet limit", "Select", "Back");
	}
	if (dialogid == SPEEDCAM_DIALOG_DELETE)
	{
		if (!response)
		{
			DeletePVar(playerid, "_scCacheDeleteId");
			return ShowPlayerDialogEx(playerid, SPEEDCAM_DIALOG_MAIN, DIALOG_STYLE_LIST, "{FFFF00}Speed Cameras", "Create a speed camera\nEdit a speed camera\nDelete a speed camera\n\
				Get nearest speedcamera (static only)", \
				"Select", "Cancel");
		}

		new id;
		if (sscanf(inputtext, "i", id))
			return ShowPlayerDialogEx(playerid, SPEEDCAM_DIALOG_DELETE, DIALOG_STYLE_INPUT, "{FFFF00}Delete a speed camera", "{FFFFFF}Enter the ID of the speed camera you wish to delete.\n\n\
				{FFFF00}ID must be a number.", "OK", "Back");

		if (id >= MAX_SPEEDCAMERAS || id < 0)
			return ShowPlayerDialogEx(playerid, SPEEDCAM_DIALOG_DELETE, DIALOG_STYLE_INPUT, "{FFFF00}Delete a speed camera", "{FFFFFF}Enter the ID of the speed camera you wish to delete.\n\n\
				{FFFF00}ID must not be above the maximum or below 0.", "OK", "Back");

		if (SpeedCameras[id][_scActive] == false)
			return ShowPlayerDialogEx(playerid, SPEEDCAM_DIALOG_DELETE, DIALOG_STYLE_INPUT, "{FFFF00}Delete a speed camera", "{FFFFFF}Enter the ID of the speed camera you wish to delete.\n\n\
				{FFFF00}No active camera with that ID.", "OK", "Back");

		SetPVarInt(playerid, "_scCacheDeleteId", id);

		new msg[256];
		format(msg, sizeof(msg), "{FFFFFF}Are you sure you want to delete speed camera %i?\n\n{FFFF00}Range: {FFFFFF}%f\n\
			{FFFF00}Limit: {FFFFFF}%f", id, SpeedCameras[id][_scRange], SpeedCameras[id][_scLimit]);
		ShowPlayerDialogEx(playerid, SPEEDCAM_DIALOG_CONFIRMDEL, DIALOG_STYLE_MSGBOX, "{FFFF00}Delete a speed camera", msg, "Delete", "Cancel");
	}
	if (dialogid == SPEEDCAM_DIALOG_CONFIRMDEL)
	{
		if (!response)
		{
			DeletePVar(playerid, "_scCacheDeleteId");
			return ShowPlayerDialogEx(playerid, SPEEDCAM_DIALOG_MAIN, DIALOG_STYLE_LIST, "{FFFF00}Speed Cameras", "Create a speed camera\nEdit a speed camera\nDelete a speed camera\n\
				Get nearest speedcamera", \
				"Select", "Cancel");
		}

		new id = GetPVarInt(playerid, "_scCacheDeleteId");
		new db = SpeedCameras[id][_scDatabase];
		DespawnSpeedCamera(id);
		SpeedCameras[id][_scActive] = false;
		new query[256];
		mysql_format(MainPipeline, query, sizeof(query), "DELETE FROM speed_cameras WHERE id=%i", SpeedCameras[id][_scDatabase]);
		mysql_tquery(MainPipeline, query, "OnQueryFinish", "i", SENDDATA_THREAD);
		//SaveSpeedCamera(id); dafuq is this doing here
		SendClientMessageEx(playerid, COLOR_RED, "Speed camera deleted.");
		DeletePVar(playerid, "_scCacheDeleteId");

		new logText[56];
		format(logText, sizeof(logText), "%s(%d) has deleted speed camera %d",
			GetPlayerNameExt(playerid), GetPlayerSQLId(playerid), db);
		Log("logs/speedcam.log", logText);
	}
	if (dialogid == SPEEDCAM_DIALOG_GETNEAREST)
	{
		return ShowPlayerDialogEx(playerid, SPEEDCAM_DIALOG_MAIN, DIALOG_STYLE_LIST, "{FFFF00}Speed Cameras", "Create a speed camera\nEdit a speed camera\nDelete a speed camera\n\
			Get nearest speedcamera", \
			"Select", "Cancel");
	}
	return 0;
}

stock CreateSpeedCamera(Float:x, Float:y, Float:z, Float:rotation, Float:range, Float:limit)
{
	new loadedCams = 0;
	new index;

	for (new i = 0; i < MAX_SPEEDCAMERAS; i++)
	{
		if (SpeedCameras[i][_scActive])
		{
			loadedCams++;
		}
		else
		{
			index = i;
			break;
		}
	}

	if (loadedCams == MAX_SPEEDCAMERAS)
		return -1;

	SpeedCameras[index][_scActive] = true;
	SpeedCameras[index][_scPosX] = x;
	SpeedCameras[index][_scPosY] = y;
	SpeedCameras[index][_scPosZ] = z;
	SpeedCameras[index][_scRotation] = rotation;
	SpeedCameras[index][_scRange] = range;
	SpeedCameras[index][_scLimit] = limit;
	SpeedCameras[index][_scObjectId] = -1;

	StoreNewSpeedCameraInMySQL(index);
	SpawnSpeedCamera(index);

	return index;
}

stock SpawnSpeedCamera(i)
{
	if (SpeedCameras[i][_scActive] && SpeedCameras[i][_scObjectId] == -1)
	{
		SpeedCameras[i][_scObjectId] = CreateDynamicObject(18880, SpeedCameras[i][_scPosX], SpeedCameras[i][_scPosY], SpeedCameras[i][_scPosZ], 0, 0, SpeedCameras[i][_scRotation]);
		new szLimit[50];
		format(szLimit, sizeof(szLimit), "{FFFFFF}Speed Limit\n{FF0000}%i {FFFFFF}MPH", floatround(SpeedCameras[i][_scLimit], floatround_round));
		SpeedCameras[i][_scTextID] = CreateDynamic3DTextLabel(szLimit, COLOR_TWWHITE, SpeedCameras[i][_scPosX], SpeedCameras[i][_scPosY], SpeedCameras[i][_scPosZ]+5, 30.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, -1, -1, -1);
	}
}

stock DespawnSpeedCamera(i)
{
	if (SpeedCameras[i][_scActive])
	{
		DestroyDynamicObject(SpeedCameras[i][_scObjectId]);
		DestroyDynamic3DTextLabel(SpeedCameras[i][_scTextID]);
		SpeedCameras[i][_scObjectId] = -1;
	}
}

stock SaveSpeedCameras()
{
	for (new c = 0; c < MAX_SPEEDCAMERAS; c++)
	{
		SaveSpeedCamera(c);
	}
}

CMD:speedcam(playerid, params[])
{
	if (IsPlayerInAnyVehicle(playerid))
		return SendClientMessageEx(playerid, COLOR_GREY, "You cannot manage speed cameras whilst inside a vehicle.");

	if (IsAGovernment(playerid) && PlayerInfo[playerid][pRank] == Group_GetMaxRank(PlayerInfo[playerid][pLeader]) || PlayerInfo[playerid][pAdmin] >= 1337)
	{
		ShowPlayerDialogEx(playerid, SPEEDCAM_DIALOG_MAIN, DIALOG_STYLE_LIST, "{FFFF00}Speed Cameras", "Create a speed camera\nEdit a speed camera\nDelete a speed camera\n\
			Get nearest speedcamera", "Select", "Cancel");
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You do not have permission to use this command.");
		return 1;
	}

	return 1;
}

CMD:gotospeedcam(playerid, params[]) {
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1)
	{
	    new i;
	    if(sscanf(params, "d", i)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /gotospeedcam [Speedcam id]");
		if(i < 0 || i > MAX_SPEEDCAMERAS) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /gotospeedcam [Speedcam id]");
    	if (SpeedCameras[i][_scActive] == true)
    	{
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, SpeedCameras[i][_scPosX], SpeedCameras[i][_scPosY], SpeedCameras[i][_scPosZ]);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				fVehSpeed[playerid] = 0.0;
			}
			else
			{
				SetPlayerPos(playerid, SpeedCameras[i][_scPosX], SpeedCameras[i][_scPosY], SpeedCameras[i][_scPosZ]);
			}
			SendClientMessageEx(playerid, COLOR_GRAD1, "   You have been teleported!");
			SetPlayerInterior(playerid,0);
			PlayerInfo[playerid][pInt] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			PlayerInfo[playerid][pVW] = 0;
			return 1;
    	}
	    else return SendClientMessageEx(playerid, COLOR_GRAD2, "That speed camera isn't active!");
	}
	else
	{
	    SendClientMessageEx(playerid, COLOR_GRAD2, " You are not authorized.");
	}
	return 1;
}

stock SaveSpeedCamera(i)
{
	if (SpeedCameras[i][_scActive] != true)
		return;

	new query[1024];
	mysql_format(MainPipeline, query, sizeof(query), "UPDATE speed_cameras SET pos_x=%f, pos_y=%f, pos_z=%f, rotation=%f, `range`=%f, speed_limit=%f WHERE id=%i",
		SpeedCameras[i][_scPosX], SpeedCameras[i][_scPosY], SpeedCameras[i][_scPosZ], SpeedCameras[i][_scRotation], SpeedCameras[i][_scRange], SpeedCameras[i][_scLimit],
		SpeedCameras[i][_scDatabase]);

	mysql_tquery(MainPipeline, query, "OnQueryFinish", "i", SENDDATA_THREAD);
}

stock LoadSpeedCameras()
{
	printf("[SpeedCameras] Loading data from database...");
	mysql_tquery(MainPipeline, "SELECT * FROM speed_cameras", "OnLoadSpeedCameras", "");
	return 1;
}

forward OnLoadSpeedCameras();
public OnLoadSpeedCameras()
{
	new rows, index;
	cache_get_row_count(rows);

	while((index < rows))
	{
		cache_get_value_name_int(index, "id", SpeedCameras[index][_scDatabase]);
		cache_get_value_name_float(index, "pos_x", SpeedCameras[index][_scPosX]);
		cache_get_value_name_float(index, "pos_y", SpeedCameras[index][_scPosY]);
		cache_get_value_name_float(index, "pos_z", SpeedCameras[index][_scPosZ]);
		cache_get_value_name_float(index, "rotation", SpeedCameras[index][_scRotation]); 
		cache_get_value_name_float(index, "range", SpeedCameras[index][_scRange]); 
		cache_get_value_name_float(index, "speed_limit", SpeedCameras[index][_scLimit]); 

		if(SpeedCameras[index][_scPosX] != 0.0)
		{
			SpeedCameras[index][_scActive] = true;
			SpeedCameras[index][_scObjectId] = -1;
			SpawnSpeedCamera(index);
		}
		index++;
	}

	if (index == 0)
		printf("[SpeedCameras] No Speed Cameras loaded.");
	else
		printf("[SpeedCameras] Loaded %i Speed Cameras.", index);

	return 1;
}

stock StoreNewSpeedCameraInMySQL(index)
{
	new string[512];
	mysql_format(MainPipeline, string, sizeof(string), "INSERT INTO speed_cameras (pos_x, pos_y, pos_z, rotation, `range`, speed_limit) VALUES (%f, %f, %f, %f, %f, %f)",
		SpeedCameras[index][_scPosX], SpeedCameras[index][_scPosY], SpeedCameras[index][_scPosZ], SpeedCameras[index][_scRotation], SpeedCameras[index][_scRange], SpeedCameras[index][_scLimit]);

	mysql_tquery(MainPipeline, string, "OnNewSpeedCamera", "i", index);
	return 1;
}

forward OnNewSpeedCamera(index);
public OnNewSpeedCamera(index)
{
	new db = cache_insert_id();
	SpeedCameras[index][_scDatabase] = db;
}

stock UpdateSpeedCamerasForPlayer(p)
{
	if (!IsPlayerConnected(p) || !IsPlayerInAnyVehicle(p) || GetPlayerState(p) != PLAYER_STATE_DRIVER) return;

	// static speed cameras
	for (new c = 0; c < MAX_SPEEDCAMERAS; c++)
	{
		if (SpeedCameras[c][_scActive] == false) continue;

		if (IsPlayerInRangeOfPoint(p, SpeedCameras[c][_scRange], SpeedCameras[c][_scPosX], SpeedCameras[c][_scPosY], SpeedCameras[c][_scPosZ]))
		{
		    if(PlayerInfo[p][pConnectHours] > 16)
		    {
				new Float:speedLimit = SpeedCameras[c][_scLimit];
				new Float:vehicleSpeed = player_get_speed(p);

				if (vehicleSpeed > speedLimit && PlayerInfo[p][pTicketTime] == 0)
				{
					new vehicleid = GetPlayerVehicleID(p);
					if(!IsAPlane(vehicleid) && !IsAHelicopter(vehicleid) && GetVehicleModel(vehicleid) != 481 && GetVehicleModel(vehicleid) != 509 && GetVehicleModel(vehicleid) != 510)
					{
						if(GetPVarType(p, "LockPickPlayerSQLId") && GetPVarInt(p, "LockPickVehicle") == vehicleid) {
							new string[155], Amount = floatround(125*(vehicleSpeed-speedLimit), floatround_round)+2000;
							SetPVarInt(p, "VLPTickets", GetPVarInt(p, "VLPTickets")+Amount);
							mysql_format(MainPipeline, string, sizeof(string), "UPDATE `vehicles` SET `pvTicket` = '%d' WHERE `id` = '%d'", GetPVarInt(p, "VLPTickets"), GetPVarInt(p, "LockPickVehicleSQLId"));
							mysql_tquery(MainPipeline, string, "OnQueryFinish", "ii", SENDDATA_THREAD, p);
							PlayerInfo[p][pTicketTime] = 60;
							format(string, sizeof(string), "You were caught speeding and have received a speeding ticket of $%s", number_format(Amount));
							SendClientMessageEx(p, COLOR_WHITE, string);
							PlayerPlaySound(p, 1132, 0.0, 0.0, 0.0);
							PlayerTextDrawShow(p, _vhudFlash[p]);
							SetTimerEx("TurnOffFlash", 500, 0, "i", p);
						}
					    foreach(new i: Player)
						{
							new v = GetPlayerVehicle(i, vehicleid);
							if(v != -1)
							{
								new string[128], Amount = floatround(125*(vehicleSpeed-speedLimit), floatround_round)+2000;
								PlayerVehicleInfo[i][v][pvTicket] += Amount;
								PlayerInfo[p][pTicketTime] = 60;
								format(string, sizeof(string), "You were caught speeding and have received a speeding ticket of $%s", number_format(Amount));
								SendClientMessageEx(p, COLOR_WHITE, string);
								PlayerPlaySound(p, 1132, 0.0, 0.0, 0.0);
								PlayerTextDrawShow(p, _vhudFlash[p]);
								SetTimerEx("TurnOffFlash", 500, 0, "i", p);
								g_mysql_SaveVehicle(i, v);
							}
						}	
					}
			  	}
			}
		}
	}
}