/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Medic Group Type

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

forward ShowPlayerBeaconForMedics(playerid);
public ShowPlayerBeaconForMedics(playerid)
{
	foreach(new i: Player)
	{
		if(IsAMedic(i))
		{
			SetPlayerMarkerForPlayer(i, playerid, COP_GREEN_COLOR);
		}
	}	
	return 1;
}

forward HidePlayerBeaconForMedics(playerid);
public HidePlayerBeaconForMedics(playerid)
{
	foreach(new i: Player)
	{
		if(IsAMedic(i))
		{
			SetPlayerMarkerForPlayer(i, playerid, TEAM_HIT_COLOR);
		}
	}	
	SetPlayerToTeamColor(playerid);
	return 1;
}

forward MoveEMS(playerid);
public MoveEMS(playerid)
{
    new Float:mX, Float:mY, Float:mZ,
    	iTargetPlayerID = GetPVarInt(playerid, "MovingStretcher");
    GetPlayerPos(playerid, mX, mY, mZ);

    SetPVarFloat(iTargetPlayerID, "MedicX", mX);
	SetPVarFloat(iTargetPlayerID, "MedicY", mY);
	SetPVarFloat(iTargetPlayerID, "MedicZ", mZ);
	SetPVarInt(iTargetPlayerID, "MedicVW", GetPlayerVirtualWorld(playerid));
	SetPVarInt(iTargetPlayerID, "MedicInt", GetPlayerInterior(playerid));

	Streamer_UpdateEx(iTargetPlayerID, mX, mY, mZ);
	SetPlayerPos(iTargetPlayerID, mX, mY, mZ);
	SetPlayerInterior(iTargetPlayerID, GetPlayerVirtualWorld(playerid));
	SetPlayerVirtualWorld(iTargetPlayerID, GetPlayerVirtualWorld(playerid));

	ClearAnimationsEx(iTargetPlayerID);
	if(!IsPlayerInAnyVehicle(iTargetPlayerID)) ApplyAnimation(iTargetPlayerID, "SWAT", "gnstwall_injurd", 4.0, 0, 1, 1, 1, 0, 1);

	DeletePVar(iTargetPlayerID, "OnStretcher");
	DeletePVar(playerid, "MovingStretcher");
}

forward KillEMSQueue(playerid);
public KillEMSQueue(playerid)
{
	DestroyObject(GetPVarInt(playerid, "DS_OBJ"));
	DeletePVar(playerid, "DS_OBJ");
    DeletePVar(playerid, "Injured");
    DeletePVar(playerid, "InjuredWait");
    DeletePVar(playerid, "EMSAttempt");
	SetPVarInt(playerid, "MedicBill", 1);
	DeletePVar(playerid, "MedicCall");
	DeletePVar(playerid, "EMSWarns");
	DeletePVar(playerid, "_energybar");
	DestroyDynamic3DTextLabel(Text3D:GetPVarInt(playerid, "InjuredTL"));
	DeletePVar(playerid, "InjuredTL");
	SetCameraBehindPlayer(playerid);
	return 1;
}

forward SendEMSQueue(playerid,type);
public SendEMSQueue(playerid,type)
{
    #if defined zombiemode
	if(zombieevent == 1 && GetPVarType(playerid, "pIsZombie"))
	{
		KillEMSQueue(playerid);
		SpawnPlayer(playerid);
		return 1;
	}
	if(zombieevent == 1 && GetPVarType(playerid, "pZombieBit"))
	{
 		KillEMSQueue(playerid);
		ClearAnimationsEx(playerid);
		MakeZombie(playerid);
		return 1;
	}
	#endif
	switch (type)
	{
		case 1:
		{
		    Streamer_UpdateEx(playerid, GetPVarFloat(playerid,"MedicX"), GetPVarFloat(playerid,"MedicY"), GetPVarFloat(playerid,"MedicZ"));
			SetPlayerPos(playerid, GetPVarFloat(playerid,"MedicX"), GetPVarFloat(playerid,"MedicY"), GetPVarFloat(playerid,"MedicZ"));
			SetPlayerVirtualWorld(playerid, GetPVarInt(playerid,"MedicVW"));
	  		SetPlayerInterior(playerid, GetPVarInt(playerid,"MedicInt"));

			SetPVarInt(playerid, "EMSAttempt", -1);

			if(GetPlayerInterior(playerid) > 0) Player_StreamPrep(playerid, GetPVarFloat(playerid,"MedicX"), GetPVarFloat(playerid,"MedicY"), GetPVarFloat(playerid,"MedicZ"), FREEZE_TIME);
			GameTextForPlayer(playerid, "~r~Injured~n~~w~/accept death or /service ems", 5000, 3);
			ClearAnimationsEx(playerid);
			PlayDeathAnimation(playerid);
			SetHealth(playerid, 100);
			RemoveArmor(playerid);
			if(GetPVarInt(playerid, "usingfirstaid") == 1)
			{
			    firstaidexpire(playerid);
			}
			SetPVarInt(playerid,"MedicCall",1);
		}
		case 2:
		{
		    SetPVarInt(playerid,"EMSAttempt", 2);
			ClearAnimationsEx(playerid);
		 	if(!IsPlayerInAnyVehicle(playerid)) ApplyAnimation(playerid, "SWAT", "gnstwall_injurd", 4.0, 0, 1, 1, 1, 0, 1);
			SetHealth(playerid, 50); // Set to 50.
			RemoveArmor(playerid);
		}
	}
	return 1;
}

PlayDeathAnimation(playerid) {

	new i = random(5);
	switch(i) {
		case 0: ApplyAnimation(playerid, "KNIFE", "KILL_Knife_Ped_Die", 4.0, 0, 1, 1, 1, 0, 1);
		case 1: ApplyAnimation(playerid, "PED", "KO_shot_stom", 4.0, 0, 1, 1, 1, 0, 1);
		case 2: ApplyAnimation(playerid, "PED", "KO_shot_stom", 4.0, 0, 1, 1, 1, 0, 1);
		case 3: ApplyAnimation(playerid, "PED", "BIKE_fall_off", 4.1, 0, 1, 1, 1, 0, 1);
		case 4: ApplyAnimation(playerid, "BASEBALL", "Bat_Hit_3", 4.1, 0, 1, 1, 1, 0, 1);
		default: ApplyAnimation(playerid, "FIGHT_E", "Hit_fightkick_B", 4.1, 0, 1, 1, 1, 0, 1);
	}
}

Medic_GetPatient(playerid, params[]) {

	if(IsAMedic(playerid) || IsFirstAid(playerid))
	{
		new string[128], giveplayerid;
		if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /getpt(patient) [player]");

		if(IsPlayerConnected(giveplayerid))
		{
		    if (giveplayerid == playerid)
		    {
		        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You cannot accept your own Emergency Dispatch call!");
				return 1;
		    }
			if(GetPVarInt(giveplayerid,"MedicCall") == 1)
			{
				if(PlayerInfo[giveplayerid][pJailTime] > 0 && strfind(PlayerInfo[playerid][pPrisonReason], "[OOC]", true) != -1) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can't use this command on jailed players.");
				format(string, sizeof(string), "EMS Driver %s (%s, R%d) has accepted the Emergency Dispatch call for (%d) %s.", GetPlayerNameEx(playerid),
					arrGroupData[PlayerInfo[playerid][pMember]][g_szGroupName], PlayerInfo[playerid][pRank], giveplayerid, GetPlayerNameEx(giveplayerid));
				SendMedicMessage(TEAM_MED_COLOR, string);
				format(string, sizeof(string), "* You have accepted EMS Call from %s, you will see the marker until you have reached it.",GetPlayerNameEx(giveplayerid));
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
				format(string, sizeof(string), "* EMS Driver %s has accepted your EMS Call; please wait at your current position.",GetPlayerNameEx(playerid));
				SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
				GameTextForPlayer(playerid, "~w~EMS Caller~n~~r~Go to the red marker.", 5000, 1);
				EMSCallTime[playerid] = 1;
				EMSAccepted[playerid] = giveplayerid;
				SetPVarInt(giveplayerid, "EMSAttempt", 1);
				PlayerInfo[playerid][pCallsAccepted]++;
				if(GetPlayerInterior(giveplayerid)) SendClientMessageEx(playerid, COLOR_GRAD1, "This person is currently in an interior.");
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_WHITE, "The person has not requested any EMS attention!");
			}
		}
	}
	return 1;
}

stock IsAnAmbulance(carid)
{
	if(DynVeh[carid] != -1)
	{
	    new iDvSlotID = DynVeh[carid], iGroupID = DynVehicleInfo[iDvSlotID][gv_igID];
	    if((0 <= iGroupID < MAX_GROUPS))
	    {
	    	if(arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_MEDIC) return 1;
			else if(arrGroupData[iGroupID][g_iMedicAccess] != INVALID_DIVISION) return 1;
			else if(carid == 416) return 1;
		}
	}
	return 0;
}

/*
CMD:aid(playerid, params[]) {

	if(IsAMedic(playerid) || IsFirstAid(playerid)) {

	}
	else SendClientMessageEx(playerid, COLOR_GRAD2, "   You are not a medic!");
	return 1;
}
*/

CMD:emslist(playerid, params[]) {

	if(IsAMedic(playerid) || IsFirstAid(playerid)) {

		new szZone[MAX_ZONE_NAME],
			x;
		szMiscArray[0] = 0;
		foreach(new i : Player) {

			if(GetPVarType(i, "EMSAttempt")) {
				GetPlayer3DZone(i, szZone, sizeof(szZone));
				switch(GetPVarInt(i, "EMSAttempt")) {

					case 1: {
						ListItemTrackId[playerid][x] = i;
						x++;
						format(szMiscArray, sizeof(szMiscArray), "%s{FF0000}Emergency - %s - %s\n", szMiscArray, GetPlayerNameEx(i), szZone);
					}
					case 2: {
						ListItemTrackId[playerid][x] = i;
						x++;
						format(szMiscArray, sizeof(szMiscArray), "%s{FFFF00}Treated - %s - %s\n", szMiscArray, GetPlayerNameEx(i), szZone);
					}
					case 3: {
						ListItemTrackId[playerid][x] = i;
						x++;
						format(szMiscArray, sizeof(szMiscArray), "%s{FF00FF}Rescued - %s - %s\n", szMiscArray, GetPlayerNameEx(i), szZone);
					}
				}
			}
			else if(strlen(szMiscArray) <= 1) 
			{
				format(szMiscArray, sizeof(szMiscArray), "There are currently no active EMS calls.");
			}
		}
		ShowPlayerDialogEx(playerid, DIALOG_MEDIC_LIST, DIALOG_STYLE_LIST, "Medic | Dispatch List", szMiscArray, "Enroute", "Cancel");
	}
	else SendClientMessageEx(playerid, COLOR_GRAD1, "You are not a medic.");
	return 1;
}

CMD:loadpt(playerid, params[])
{
    if(IsAMedic(playerid) || IsFirstAid(playerid))
	{
        if(IsPlayerInAnyVehicle(playerid))
		{
            SendClientMessageEx(playerid, COLOR_GREY, "   Cannot use this while you're in a car!");
            return 1;
        }

        new string[128], giveplayerid, seat;
        if(sscanf(params, "ud", giveplayerid, seat)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /loadpt [player] [seatid]");

        if(IsPlayerConnected(giveplayerid))
		{
            if(giveplayerid != INVALID_PLAYER_ID)
			{
                if(!(2 <= seat <= 3))
				{
                    SendClientMessageEx(playerid, COLOR_GRAD1, "The seat ID cannot be above 3 or below 2.");
                    return 1;
                }
                if(GetPVarInt(giveplayerid, "Injured") != 1)
				{
                    SendClientMessageEx(playerid, COLOR_GREY, "That patient not injured - you can't load them.");
                    return 1;
                }
                if(IsPlayerInAnyVehicle(giveplayerid))
				{
                    SendClientMessageEx(playerid, COLOR_GREY, "That patient is inside a car - you can't load them.");
                    return 1;
                }
                if (ProxDetectorS(8.0, playerid, giveplayerid))
				{
                    if(giveplayerid == playerid) { SendClientMessageEx(playerid, COLOR_GREY, "You cannot load yourself!"); return 1; }
                    if(PlayerInfo[giveplayerid][pJailTime] > 0 && strfind(PlayerInfo[playerid][pPrisonReason], "[OOC]", true) != -1) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can't use this command on jailed players.");
                    // if(GetPVarType(playerid, "MedicAid")) return SendClientMessage(playerid, COLOR_GREY, "This patient requires aid! Use /aid [playerid] to aid them.");
                    new carid = gLastCar[playerid];
                    if(IsAnAmbulance(carid))
					{
                        if(IsVehicleOccupied(carid, seat)) {
							SendClientMessageEx(playerid, COLOR_GREY, "That seat is occupied.");
							return 1;
						}
						if(IsPlayerInRangeOfVehicle(giveplayerid, carid, 10.0) && IsPlayerInRangeOfVehicle(playerid, carid, 10.0)) {
							format(string, sizeof(string), "* You were loaded by paramedic %s.", GetPlayerNameEx(playerid));
							SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
							format(string, sizeof(string), "* You loaded patient %s.", GetPlayerNameEx(giveplayerid));
							SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
							format(string, sizeof(string), "* %s loads %s in the %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), GetVehicleName(carid));
							ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
							SetPVarInt(giveplayerid, "EMSAttempt", 3);
							ClearAnimationsEx(giveplayerid);
							IsPlayerEntering{giveplayerid} = true;
							PutPlayerInVehicle(giveplayerid,carid,seat);
							TogglePlayerControllable(giveplayerid, false);
						}
						else SendClientMessageEx(playerid, COLOR_GREY, "Both you and your patient must be near the ambulance.");
                    }
                    else
					{
                        SendClientMessageEx(playerid, COLOR_GRAD2, "Your last car needs to be an ambulance!");
                    }
                }
                else
				{
                    SendClientMessageEx(playerid, COLOR_GREY, " You're not close enough to the person or your car!");
                    return 1;
                }
            }
        }
        else
		{
            SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");
            return 1;
        }
    }
    else
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "   You are not a medic!");
    }
    return 1;
}

CMD:triage(playerid, params[])
{
    if(IsAMedic(playerid) || IsFirstAid(playerid))
	{
 		if(PlayerInfo[playerid][pTriageTime] != 0)
   		{
     		SendClientMessageEx(playerid, COLOR_GREY, "You must wait for 2 minutes to use this command.");
       		return 1;
	    }

	    new string[128], giveplayerid;
	    if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /triage [player]");

   		if(IsPlayerConnected(giveplayerid))
   		{
    	    if(playerid == giveplayerid) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can't use this command on yourself.");
    	    if (ProxDetectorS(5.0, playerid, giveplayerid))
			{
	    	    new Float: health;
	    	    GetHealth(giveplayerid, health);
	    	    if(health >= 85) SetHealth(giveplayerid, 100);
				else SetHealth(giveplayerid, health+15.0);
	    	    format(string, sizeof(string), "* %s has given %s 15 health.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
	    	    ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				PlayerInfo[playerid][pTriageTime] = 120;
			}
			else
			{
			    SendClientMessageEx(playerid, COLOR_GREY, "That person isn't near you.");
			}
 		}
	}
	return 1;
}

CMD:heal(playerid, params[])
{
	new giveplayerid, price = 1000;
	if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /heal [player]");

	if (giveplayerid == playerid)
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You can't heal yourself.");
		return 1;
	}

	if(gettime() < GetPVarInt(playerid, "pHealTimer")) return SendClientMessage(playerid, COLOR_GRAD1, "You must wait 1 minute before you can heal again.");

	if (IsPlayerConnected(giveplayerid))
	{
		if(IsAMedic(playerid) || IsFirstAid(playerid))
		{
			new Float:X, Float:Y, Float:Z;
	   		GetPlayerPos(giveplayerid, X, Y, Z);

			if(!IsPlayerInRangeOfPoint(playerid, 10, X, Y, Z)) return SendClientMessageEx(playerid, TEAM_GREEN_COLOR," You are not near them!");

			if(GetPlayerCash(giveplayerid) < 1000) return SendClientMessage(playerid, COLOR_GRAD1, "That player cannot afford this treatment.");

			new Float:tempheal;
			GetHealth(giveplayerid,tempheal);
			if(tempheal >= 100.0)
			{
				SendClientMessageEx(playerid, TEAM_GREEN_COLOR,"That person is fully healed.");
				return 1;
			}
			new string[64];
			format(string, sizeof(string), "You healed %s for $%d.", GetPlayerNameEx(giveplayerid), price);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
			GivePlayerCash(playerid, price / 2);
			Tax += price / 2;
			GivePlayerCash(giveplayerid, -price);
			SetHealth(giveplayerid, 100);
			PlayerPlaySound(playerid, 1150, 0.0, 0.0, 0.0);
			PlayerPlaySound(giveplayerid, 1150, 0.0, 0.0, 0.0);
			format(string, sizeof(string), "You have been healed to 100 health for $%d by %s.",price, GetPlayerNameEx(playerid));
			SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);

			SetPVarInt(playerid, "pHealTimer", gettime() + 60); // Adding a minute check.

			if(GetPVarType(giveplayerid, "STD"))
			{
				DeletePVar(giveplayerid, "STD");
				SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, "* You are no longer infected with a STD because of the medic's help.");
			}
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
			return 1;
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid player specified.");
	}
	return 1;
}

CMD:getpt(playerid, params[])
{
	Medic_GetPatient(playerid, params);
	return 1;
}

CMD:movept(playerid, params[])
{
	if(IsAMedic(playerid) || IsFirstAid(playerid))
	{
		new string[128], giveplayerid;
		if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /movepatient [player]");

		if(IsPlayerConnected(giveplayerid))
		{
			if(GetPVarInt(giveplayerid,"Injured") == 1)
			{
				if(IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can't use this command while in a vehicle.");
				if(PlayerInfo[giveplayerid][pJailTime] > 0 && strfind(PlayerInfo[playerid][pPrisonReason], "[OOC]", true) != -1) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can't use this command on jailed players.");
				if(GetPVarInt(giveplayerid, "OnStretcher") == 1)
				{
					SendClientMessageEx(playerid, COLOR_GRAD2, "The person is already on a stretcher, you can't do this right now!");
					return 1;
				}

				new Float:mX, Float:mY, Float:mZ;
				GetPlayerPos(giveplayerid, mX, mY, mZ);
				if(!IsPlayerInRangeOfPoint(playerid, 5.0, mX, mY, mZ))
				{
					SendClientMessageEx(playerid, COLOR_GRAD2, "You have to be close to the patient to be able to move them!");
					return 1;
				}
				SendClientMessageEx(playerid, COLOR_GRAD2, "You have 30 seconds to move to another location or you can either press the '{AA3333}FIRE{BFC0C2}' button.");
				format(string, sizeof(string), "* You have been put on a stretcher by %s.", GetPlayerNameEx(playerid));
				SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
				format(string, sizeof(string), "* You have put %s on a stretcher, you may move them now.", GetPlayerNameEx(giveplayerid));
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
				format(string, sizeof(string), "* %s puts %s on a stretcher, tightening the belts securely.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
				ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

				SetPVarInt(giveplayerid, "OnStretcher", 1);
				SetPVarInt(playerid, "TickEMSMove", SetTimerEx("MoveEMS", 30000, false, "d", playerid));
				SetPVarInt(playerid, "MovingStretcher", giveplayerid);
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GRAD2, "The person has to be injured in-order to move them!");
			}
		}
	}
	return 1;
}

CMD:deliverpt(playerid, params[])
{
    if(IsAMedic(playerid) || IsFirstAid(playerid))
	{
        if(IsPlayerInAnyVehicle(playerid))
		{
			new string[128], giveplayerid;
		    if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /deliverpt [player]");

            new carid = GetPlayerVehicleID(playerid);
            new caridex = GetPlayerVehicleID(giveplayerid);
            if(IsAnAmbulance(carid))
			{
                if(carid == caridex)
				{
                    if(IsAtDeliverPatientPoint(playerid))
					{
                        if(playerid == giveplayerid)
						{
                            SendClientMessageEx(playerid, COLOR_GRAD2, "You cannot deliver yourself to the hospital!");
                            return 1;
                        }
                        if(GetPVarInt(giveplayerid, "Injured") == 0)
						{
                            return SendClientMessageEx(playerid, COLOR_GRAD2, "That person is not injured!");
                        }
                        if(playerTabbed[giveplayerid] >= 1)
						{
                            SendClientMessageEx(playerid, COLOR_GRAD2, "That person is paused, you can't currently deliver him!");
                            return 1;
                        }
                        SetHealth(giveplayerid, 100);
                        if(GetPVarType(giveplayerid, "STD"))
						{
							DeletePVar(giveplayerid, "STD");
                            SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, "* You are no longer infected with a STD anymore because of the hospital's help!");
                        }
                        GivePlayerCash(giveplayerid, -1000);
						GivePlayerCash(playerid, 20000);

						//SendClientMessageEx(giveplayerid, TEAM_CYAN_COLOR, "Doc: Your medical bill comes in at $1000. Have a nice day!");
                        format(string,sizeof(string),"You received $20,000 for successfully delivering the patient!");
                        SendClientMessageEx(playerid, TEAM_CYAN_COLOR, string);
						
                        KillEMSQueue(giveplayerid);
                        SetPVarInt(giveplayerid, "_HospitalBeingDelivered", 1);
                        
						new iHospitalDeliver = GetClosestDeliverPatientPoint(playerid);
						new iHospital = ReturnDeliveryPoint(iHospitalDeliver);
						
						switch(ReturnDeliveryPointNation(iHospitalDeliver))
						{
							case 0: Tax += 1000;
							case 1: TRTax += 1000;
						}

						arrGroupData[PlayerInfo[playerid][pMember]][g_iBudget] -= 20000;
                        						
						DeliverPlayerToHospital(giveplayerid, iHospital);
                        PlayerInfo[playerid][pPatientsDelivered]++;
                        
						format(string, sizeof(string), "EMS Driver %s has successfully delivered Patient %s to the hospital.",GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
						SendGroupMessage(GROUP_TYPE_MEDIC, TEAM_MED_COLOR, string);
						GroupLog(PlayerInfo[playerid][pMember], string);
						foreach(new i: Player)
						{
							if(IsFirstAid(i))
							{
								SendClientMessage(i, TEAM_MED_COLOR, string);
							}
						}
						PlayerInfo[giveplayerid][pHydration] = 100;
					}
                    else
					{
                        SendClientMessageEx(playerid, COLOR_GRAD2, "You are not near a deliver point - look out near the hospitals.");
                    }
                }
                else
				{
                    SendClientMessageEx(playerid, COLOR_GRAD2, "Patient must be in your car in order to deliver him.");
                }
            }
            else
			{
                SendClientMessageEx(playerid, COLOR_GRAD2, "You are not in an FDSA vehicle.");
            }
        }
    }
    return 1;
}

CMD:renderaid(playerid, params[])
{
	if(!(0 <= PlayerInfo[playerid][pMember] < MAX_GROUPS)) return SendClientMessageEx(playerid, COLOR_GREY, "You are not in a group.");
	if(GetPVarInt(playerid, "MedVestKit") != 1) return SendClientMessageEx(playerid, COLOR_GRAD1, "You aren't carrying a kit.");
	new target;
	if(sscanf(params, "u", target)) return SendClientMessageEx(playerid, COLOR_GRAD2, "USAGE: /renderaid [player]");
	if(!IsPlayerConnected(target)) return SendClientMessageEx(playerid, COLOR_GRAD2, "Invalid player specified.");
	if(target == playerid) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can not aid yourself!");
	if(!GetPVarType(target, "Injured")) return SendClientMessageEx(playerid, COLOR_GRAD2, "Player is not in a injured state.");
	SetPVarInt(target, "renderaid", playerid);
	format(szMiscArray, sizeof(szMiscArray), "* You have offered %s assistance.", GetPlayerNameEx(target));
	SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMiscArray);
	format(szMiscArray, sizeof(szMiscArray), "* %s wants to assist you, (type /accept renderaid) to accept.", GetPlayerNameEx(playerid));
	SendClientMessageEx(target, COLOR_LIGHTBLUE, szMiscArray);
	return 1;
}
