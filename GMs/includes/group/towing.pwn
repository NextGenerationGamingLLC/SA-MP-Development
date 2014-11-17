/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Towing Group Type

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

CMD:dmvrelease(playerid, params[]) {
	if(IsACop(playerid) || IsATowman(playerid))
    {
		if(IsPlayerInRangeOfPoint(playerid, 3.0, 833.60, 3.23, 1004.17)) {

			new
				iTargetID;

			if(sscanf(params, "u", iTargetID)) {
				SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /dmvrelease [player]");
			}
			else if(IsPlayerConnected(iTargetID)) {

				new
					vstring[4096],
					iCount,
					pVehSlots = GetPlayerVehicleSlots(iTargetID);
					
				for(new i; i < pVehSlots; i++) {
					if(PlayerVehicleInfo[iTargetID][i][pvPrice] < 1) PlayerVehicleInfo[iTargetID][i][pvPrice] = 2000000;
					if(PlayerVehicleInfo[iTargetID][i][pvId] > INVALID_PLAYER_VEHICLE_ID) {
						if(PlayerVehicleInfo[iTargetID][i][pvTicket]) {
							format(vstring, sizeof(vstring), "%s\n%s (ticket - $%i)", vstring, VehicleName[PlayerVehicleInfo[iTargetID][i][pvModelId] - 400], PlayerVehicleInfo[iTargetID][i][pvTicket]);
							++iCount;
						}
						else format(vstring, sizeof(vstring), "%s\n%s", vstring, VehicleName[PlayerVehicleInfo[iTargetID][i][pvModelId] - 400]);
					}	
					else if(PlayerVehicleInfo[iTargetID][i][pvImpounded]) {
						format(vstring, sizeof(vstring), "%s\n%s (impounded - $%i release)", vstring, VehicleName[PlayerVehicleInfo[iTargetID][i][pvModelId] - 400], (PlayerVehicleInfo[iTargetID][i][pvPrice] / 20) + PlayerVehicleInfo[iTargetID][i][pvTicket] + (PlayerInfo[iTargetID][pLevel] * 3000));
						++iCount;
					}
					else format(vstring, sizeof(vstring), "%s\nNone", vstring);
				}
				if(iCount) ShowPlayerDialog(playerid, MPSPAYTICKETSCOP, DIALOG_STYLE_LIST, "Vehicles", vstring, "Release", "Cancel"), SetPVarInt(playerid, "vRel", iTargetID);
				else SendClientMessageEx(playerid, COLOR_GRAD2, "This person doesn't have any tickets to be paid or vehicles to be released.");
			}
			else SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");
		}
		else SendClientMessageEx(playerid, COLOR_GRAD2, "You are not at the DMV release point in Dillimore (inside the DMV).");
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use this command.");
	return 1;
}

CMD:dmvmenu(playerid, params[])
{
	new vstring[1024], icount, icountz = GetPlayerVehicleSlots(playerid);
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 833.60, 3.23, 1004.17)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not at the DMV release point in Dillimore (inside the DMV).");
	if(PlayerInfo[playerid][pFreezeCar] != 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot do this while having your assets frozen!");
	if(PlayerInfo[playerid][pCarLic] == 0) return SendClientMessageEx(playerid, COLOR_GRAD1, "A valid driver's license is required to release your vehicle from the impound, or pay any tickets.");
	
	for(new i; i < icountz; i++) {
		if(PlayerVehicleInfo[playerid][i][pvPrice] < 1) PlayerVehicleInfo[playerid][i][pvPrice] = 2000000;
		if(PlayerVehicleInfo[playerid][i][pvId] > INVALID_PLAYER_VEHICLE_ID) {
			if(PlayerVehicleInfo[playerid][i][pvTicket]) {
				format(vstring, sizeof(vstring), "%s\n%s (ticket - $%i)", vstring, VehicleName[PlayerVehicleInfo[playerid][i][pvModelId] - 400], PlayerVehicleInfo[playerid][i][pvTicket]);
				++icount;
			}
			else format(vstring, sizeof(vstring), "%s\n%s", vstring, VehicleName[PlayerVehicleInfo[playerid][i][pvModelId] - 400]);
		}	
		else if(PlayerVehicleInfo[playerid][i][pvImpounded]) {
			format(vstring, sizeof(vstring), "%s\n%s (impounded - $%i release)", vstring, VehicleName[PlayerVehicleInfo[playerid][i][pvModelId] - 400], (PlayerVehicleInfo[playerid][i][pvPrice] / 20) + PlayerVehicleInfo[playerid][i][pvTicket] + (PlayerInfo[playerid][pLevel] * 3000));
			++icount;
		}
		else format(vstring, sizeof(vstring), "%s\nNone", vstring);
	}	
	if(icount) {
		ShowPlayerDialog(playerid, MPSPAYTICKETS, DIALOG_STYLE_LIST, "Vehicles", vstring, "Release", "Cancel");
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD2, "You don't have any tickets to be paid or vehicles to be released.");
	return 1;
}
