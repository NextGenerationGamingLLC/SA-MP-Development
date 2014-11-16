/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

					Dynamic Impound System 

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

CMD:impoundedit(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pFactionModerator] >= 1)
	{
		new string[128], choice[32], id, amount;
		if(sscanf(params, "s[32]dD", choice, id, amount))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /impoundedit [name] [id] [amount]");
			SendClientMessageEx(playerid, COLOR_GREY, "Available names: Position, Delete");
			return 1;
		}

		if(id >= MAX_IMPOUNDPOINTS)
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "Invalid Impound Points ID!");
			return 1;
		}

		if(strcmp(choice, "position", true) == 0)
		{
			GetPlayerPos(playerid, ImpoundPoints[id][impoundPosX], ImpoundPoints[id][impoundPosY], ImpoundPoints[id][impoundPosZ]);
			ImpoundPoints[id][impoundInt] = GetPlayerInterior(playerid);
			ImpoundPoints[id][impoundVW] = GetPlayerVirtualWorld(playerid);
			format(string, sizeof(string), "You have changed the position on impound Point #%d.", id);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			DestroyDynamic3DTextLabel(ImpoundPoints[id][impoundTextID]);
			format(string, sizeof(string), "Impound Yard #%d\nType /impound to impound a vehicle", id);
			ImpoundPoints[id][impoundTextID] = CreateDynamic3DTextLabel(string, COLOR_YELLOW, ImpoundPoints[id][impoundPosX], ImpoundPoints[id][impoundPosY], ImpoundPoints[id][impoundPosZ]+0.6, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, ImpoundPoints[id][impoundVW], ImpoundPoints[id][impoundInt], -1);
			SaveImpoundPoint(id);
			format(string, sizeof(string), "%s has edited Impound Point ID %d's position.", GetPlayerNameEx(playerid), id);
			Log("logs/impoundedit.log", string);
			return 1;
		}
		else if(strcmp(choice, "delete", true) == 0)
		{
			if(ImpoundPoints[id][impoundPosX] == 0)
			{
				format(string, sizeof(string), "Impound Point #%d does not exist.", id);
				SendClientMessageEx(playerid, COLOR_WHITE, string);
				return 1;
			}
			DestroyDynamic3DTextLabel(ImpoundPoints[id][impoundTextID]);
			ImpoundPoints[id][impoundPosX] = 0.0;
			ImpoundPoints[id][impoundPosY] = 0.0;
			ImpoundPoints[id][impoundPosZ] = 0.0;
			ImpoundPoints[id][impoundVW] = 0;
			ImpoundPoints[id][impoundInt] = 0;
			SaveImpoundPoint(id);
			format(string, sizeof(string), "You have deleted Impound Point #%d.", id);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			format(string, sizeof(string), "%s has deleted Impound Point ID %d.", GetPlayerNameEx(playerid), id);
			Log("logs/impoundedit.log", string);
			return 1;
		}
	}
	else SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	return 1;
}

CMD:impoundstatus(playerid, params[])
{
	new id;
	if(sscanf(params, "i", id))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /impoundstatus [id]");
		return 1;
	}
	if (PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pFactionModerator] >= 1)
	{
		new string[128];
		format(string,sizeof(string),"|___________ Impound Point Status (ID: %d) ___________|", id);
		SendClientMessageEx(playerid, COLOR_GREEN, string);
		format(string, sizeof(string), "[Position] X: %f | Y: %f | Z: %f | VW: %d | Int: %d", ImpoundPoints[id][impoundPosX], ImpoundPoints[id][impoundPosY], ImpoundPoints[id][impoundPosZ], ImpoundPoints[id][impoundVW], ImpoundPoints[id][impoundInt]);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	}
	return 1;
}

CMD:impoundnext(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pFactionModerator] == 2)
	{
		SendClientMessageEx(playerid, COLOR_RED, "* Listing next available Impound Point...");
		for(new x = 0; x < MAX_IMPOUNDPOINTS; x++)
		{
			if(ImpoundPoints[x][impoundPosX] == 0)
		    {
		        new string[128];
		        format(string, sizeof(string), "%d is available to use.", x);
		        SendClientMessageEx(playerid, COLOR_WHITE, string);
		        break;
			}
		}
	}
	else
	{
	    SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use that command.");
		return 1;
	}
	return 1;
}

CMD:gotoimpoundpoint(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pFactionModerator] >= 1)
	{
		new id;
		if(sscanf(params, "d", id)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /gotoimpoundpoint [id]");

		SetPlayerPos(playerid, ImpoundPoints[id][impoundPosX], ImpoundPoints[id][impoundPosY], ImpoundPoints[id][impoundPosZ]);
		SetPlayerInterior(playerid, ImpoundPoints[id][impoundInt]);
		PlayerInfo[playerid][pInt] = ImpoundPoints[id][impoundInt];
		SetPlayerVirtualWorld(playerid, ImpoundPoints[id][impoundVW]);
		PlayerInfo[playerid][pVW] = ImpoundPoints[id][impoundVW];
	}
	return 1;
}

CMD:impound(playerid, params[]) {

	if (IsACop(playerid) || IsATowman(playerid))
	{
			if(!IsAtImpoundingPoint(playerid))
			{
				SendClientMessageEx(playerid, COLOR_GREY, "You are not near the impound point, you can't impound!");
				return 1;
			}
			if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
			{

				new
					iVehType,
					iVehIndex,
					iTargetOwner,
					iVehTowed = GetVehicleTrailer(GetPlayerVehicleID(playerid));

				if(!GetVehicleModel(iVehTowed)) {
					return SendClientMessageEx(playerid, COLOR_GREY, "The vehicle in tow has been desynced and therefore cannot be impounded.");
				}
				//foreach(new i: Player)
				for(new i = 0; i < MAX_PLAYERS; ++i)
				{
					if(IsPlayerConnected(i))
					{
						iVehIndex = GetPlayerVehicle(i, iVehTowed);
						if(iVehIndex != -1) {
							iVehType = 1;
							iTargetOwner = i;
							break;
						}
					}	
				}
				switch(iVehType) {
					case 0, 2: {
						SendClientMessageEx(playerid, COLOR_GRAD1, "The impound administration could not find any registration on the vehicle and has returned it.");
						DetachTrailerFromVehicle(GetPlayerVehicleID(playerid));
						SetVehiclePos(iVehTowed, 0, 0, 0); // Attempted desync fix
						SetVehicleToRespawn(iVehTowed);
					}
					case 1: {

						PlayerVehicleInfo[iTargetOwner][iVehIndex][pvImpounded] = 1;
						PlayerVehicleInfo[iTargetOwner][iVehIndex][pvSpawned] = 0;
						GetVehicleHealth(PlayerVehicleInfo[iTargetOwner][iVehIndex][pvId], PlayerVehicleInfo[iTargetOwner][iVehIndex][pvHealth]);
						PlayerVehicleInfo[iTargetOwner][iVehIndex][pvId] = INVALID_PLAYER_VEHICLE_ID;
						DetachTrailerFromVehicle(GetPlayerVehicleID(playerid));
						SetVehiclePos(iVehTowed, 0, 0, 0); // Attempted desync fix
						DestroyVehicle(iVehTowed);
                        g_mysql_SaveVehicle(iTargetOwner, iVehIndex);
						VehicleSpawned[iTargetOwner]--;
						--PlayerCars;

						new
							szMessage[96];

						format(szMessage, sizeof(szMessage),"* You have impounded %s's %s.",GetPlayerNameEx(iTargetOwner), VehicleName[PlayerVehicleInfo[iTargetOwner][iVehIndex][pvModelId] - 400]);
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);

						format(szMessage, sizeof(szMessage), "Your %s has been impounded. You may release it at the DMV in Dillimore.", VehicleName[PlayerVehicleInfo[iTargetOwner][iVehIndex][pvModelId] - 400]);
						SendClientMessageEx(iTargetOwner, COLOR_LIGHTBLUE, szMessage);

						format(szMessage, sizeof(szMessage), "HQ: %s has impounded %s's %s ($%s unpaid tickets).", GetPlayerNameEx(playerid), GetPlayerNameEx(iTargetOwner), VehicleName[PlayerVehicleInfo[iTargetOwner][iVehIndex][pvModelId] - 400], number_format(PlayerVehicleInfo[iTargetOwner][iVehIndex][pvTicket]));
						SendGroupMessage(1, RADIO, szMessage);
					}
					/*case 2: {

						new
							szMessage[29 + MAX_PLAYER_NAME];

						format(szMessage, sizeof(szMessage),"* You have impounded %s's %s.",FamilyInfo[iTargetOwner][FamilyName], GetVehicleNameEx(iVehTowed));
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);

						format(szMessage, sizeof(szMessage), "Your %s has been impounded. You may release it at the DMV in Dillimore.", GetVehicleNameEx(iVehTowed));
						SendNewFamilyMessage(iTargetOwner, COLOR_LIGHTBLUE, szMessage);

						FamilyVehicleInfo[iTargetOwner][iVehIndex][fvImpounded] = 1;
						FamilyVehicleInfo[iTargetOwner][iVehIndex][fvId] = INVALID_VEHICLE_ID;
						DestroyVehicle(iVehTowed);
					}*/
				}
				arr_Towing[playerid] = INVALID_VEHICLE_ID;
			}
		}
	return 1;
}