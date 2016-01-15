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
					iVehTowed = GetVehicleTrailer(GetPlayerVehicleID(playerid)),
					iCost;

				if(!GetVehicleModel(iVehTowed)) {
					return SendClientMessageEx(playerid, COLOR_GREY, "The vehicle in tow has been desynced and therefore cannot be impounded.");
				}
				foreach(new i: Player)
				{
					iVehIndex = GetPlayerVehicle(i, iVehTowed);
					if(iVehIndex != -1) {
						iVehType = 1;
						iTargetOwner = i;
						iCost = (((PlayerVehicleInfo[iTargetOwner][iVehIndex][pvPrice] / 20 + PlayerVehicleInfo[iTargetOwner][iVehIndex][pvTicket]) / 100) * 20);
						break;
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
						arrGroupData[PlayerInfo[playerid][pMember]][g_iBudget] += iCost;
						
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
						SendGroupMessage(arrGroupData[PlayerInfo[playerid][pMember]][g_iGroupType], RADIO, szMessage);
						
						format(szMessage, sizeof(szMessage), "IMPOUND: %s has impounded %s's %s and gained $%s", GetPlayerNameEx(playerid), GetPlayerNameEx(iTargetOwner), VehicleName[PlayerVehicleInfo[iTargetOwner][iVehIndex][pvModelId] - 400], number_format(iCost));
						GroupLog(PlayerInfo[playerid][pMember], szMessage);
					}
				}
				arr_Towing[playerid] = INVALID_VEHICLE_ID;
			}
		}
	return 1;
}