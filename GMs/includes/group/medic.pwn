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
                    if(PlayerInfo[giveplayerid][pJailTime] > 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can't use this command on jailed players.");
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
							format(string, sizeof(string), "* %s loads %s in the ambulance.", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
							ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
							SetPVarInt(giveplayerid, "EMSAttempt", 3);
							ClearAnimations(giveplayerid);
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
	new giveplayerid, price;
	if(sscanf(params, "ud", giveplayerid, price)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /heal [player] [price]");

	if(!(200 <= price <= 1000))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "Healing price can't below $200 or above $1,000.");
		return 1;
	}
	if (giveplayerid == playerid)
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You can't heal yourself.");
		return 1;
	}
	if (IsPlayerConnected(giveplayerid))
	{
		new iVehicle = GetPlayerVehicleID(playerid);
		if(IsAMedic(playerid) || IsFirstAid(playerid))
		{
			if(GetPlayerVehicleID(giveplayerid) == iVehicle && (IsAnAmbulance(iVehicle)))
			{
			    new Float:X, Float:Y, Float:Z;
	   			GetPlayerPos(giveplayerid, X, Y, Z);

				if(!IsPlayerInRangeOfPoint(playerid, 10, X, Y, Z)) return SendClientMessageEx(playerid, TEAM_GREEN_COLOR,"You are not near them!");
				new Float:tempheal;
				GetHealth(giveplayerid,tempheal);
				if(tempheal >= 100.0)
				{
					SendClientMessageEx(playerid, TEAM_GREEN_COLOR,"That person is fully healed.");
					return 1;
				}
				new string[64];
				format(string, sizeof(string), "You healed %s for $%d.", GetPlayerNameEx(giveplayerid),price);
				SendClientMessageEx(playerid, COLOR_PINK, string);
				GivePlayerCash(playerid, price / 2);
				Tax += price / 2;
				GivePlayerCash(giveplayerid, -price);
				SetHealth(giveplayerid, 100);
				PlayerPlaySound(playerid, 1150, 0.0, 0.0, 0.0);
				PlayerPlaySound(giveplayerid, 1150, 0.0, 0.0, 0.0);
				format(string, sizeof(string), "You have been healed to 100 health for $%d by %s.",price, GetPlayerNameEx(playerid));
				SendClientMessageEx(giveplayerid, TEAM_GREEN_COLOR,string);
				if(GetPVarType(giveplayerid, "STD"))
				{
					DeletePVar(giveplayerid, "STD");
					SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, "* You are no longer infected with a STD because of the medic's help.");
				}
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GRAD1, "Both you and the patient must be in an ambulance.");
				return 1;
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
				if(PlayerInfo[giveplayerid][pJailTime] > 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can't use this command on jailed players.");
				format(string, sizeof(string), "EMS Driver %s has accepted the Emergency Dispatch call for (%d) %s.",GetPlayerNameEx(playerid),giveplayerid,GetPlayerNameEx(giveplayerid));
				SendGroupMessage(3, TEAM_MED_COLOR, string);
				format(string, sizeof(string), "* You have accepted EMS Call from %s, you will see the marker until you have reached it.",GetPlayerNameEx(giveplayerid));
				SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
				format(string, sizeof(string), "* EMS Driver %s has accepted your EMS Call; please wait at your current position.",GetPlayerNameEx(playerid));
				SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
				GameTextForPlayer(playerid, "~w~EMS Caller~n~~r~Go to the red marker.", 5000, 1);
				EMSCallTime[playerid] = 1;
				EMSAccepted[playerid] = giveplayerid;
				SetPVarInt(giveplayerid, "EMSAttempt", 1);
				PlayerInfo[playerid][pCallsAccepted]++;
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_WHITE, "The person has not requested any EMS attention!");
			}
		}
	}
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
				if(PlayerInfo[giveplayerid][pJailTime] > 0) return SendClientMessageEx(playerid, COLOR_GRAD2, "You can't use this command on jailed players.");
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
						GivePlayerCash(playerid,2500);
                        Tax += 1000;
						//SendClientMessageEx(giveplayerid, TEAM_CYAN_COLOR, "Doc: Your medical bill comes in at $1000. Have a nice day!");
                        format(string,sizeof(string),"You received $2500 for successfully delivering the patient!");
                        SendClientMessageEx(playerid, TEAM_CYAN_COLOR, string);
						
                        KillEMSQueue(giveplayerid);
                        SetPVarInt(giveplayerid, "_HospitalBeingDelivered", 1);
						DeletePVar(giveplayerid, "Injured");
                        
						new iHospitalDeliver = GetClosestDeliverPatientPoint(playerid);
						new iHospital = ReturnDeliveryPoint(iHospitalDeliver);
						
						
						DeliverPlayerToHospital(giveplayerid, iHospital);
                        PlayerInfo[playerid][pPatientsDelivered]++;
                        
						format(string, sizeof(string), "EMS Driver %s has successfully delivered Patient %s to the hospital.",GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
						SendGroupMessage(3, TEAM_MED_COLOR, string);
						
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
