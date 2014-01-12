//-------------------------------------------
//   TowCars Filter Script v1.0
//   Designed for SA-MP v0.2.2
//   Created by zeruel_angel
//    Locks added by Sew_Sumi
//-------------------------------------------
#include <a_samp>

new TowTruckers=0;
new IsTowTrucker[MAX_PLAYERS];
new lockstate[MAX_VEHICLES]=-1;
new lastcar[MAX_PLAYERS];


public OnFilterScriptInit()
{
	print("\n TowCars Filter Script v1.0 Loading...\n**********************\n	  (Zeruel_Angel)\n");
}

public OnFilterScriptExit()
{
	print("\n TowCars Script UnLoaded\n********************************************\n\n");
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(newstate==PLAYER_STATE_DRIVER)
		{
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 525)
			{
			IsTowTrucker[playerid]=1;
			TowTruckers++;
			GameTextForPlayer(playerid, "~r~~k~~TOGGLE_SUBMISSIONS~~w~ to tow a car.",3000,4);
			}
		if(GetPlayerVehicleID(playerid)!=lastcar[playerid])
			{
			lockstate[lastcar[playerid]]=0;
			lastcar[playerid]=GetPlayerVehicleID(playerid);
			}
		}
	if((newstate==PLAYER_STATE_ONFOOT)&&(IsTowTrucker[playerid]==1))
		{
		IsTowTrucker[playerid]=0;
		TowTruckers--;
		}
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if((newkeys==KEY_SUBMISSION)&&(IsPlayerInAnyVehicle(playerid))&&(GetPlayerState(playerid)==PLAYER_STATE_DRIVER))
		{
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 525)
			{
			new Float:pX,Float:pY,Float:pZ;
			GetPlayerPos(playerid,pX,pY,pZ);
			new Float:vX,Float:vY,Float:vZ;
			new Found=0;
			new vid=0;
			while((vid<MAX_VEHICLES)&&(!Found))
				{
				vid++;
				GetVehiclePos(vid,vX,vY,vZ);
				if((floatabs(pX-vX)<7.0)&&(floatabs(pY-vY)<7.0)&&(floatabs(pZ-vZ)<7.0)&&(vid!=GetPlayerVehicleID(playerid)))
					{
					Found=1;
					if	(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
						{
						DetachTrailerFromVehicle(GetPlayerVehicleID(playerid));
						SendClientMessage(playerid,0xFFFF00AA,"Car droped!");
						}
					else
						{
						AttachTrailerToVehicle(vid,GetPlayerVehicleID(playerid));
						SendClientMessage(playerid,0xFF00AA,"Car towed!");
						}
					}
				}
			if(!Found)
				{			
				SendClientMessage(playerid,0x888888AA,"There is no car in range.");
				}
			}
		}
	if((newkeys==KEY_ANALOG_UP)&&(IsPlayerInAnyVehicle(playerid))&&(GetPlayerState(playerid)==PLAYER_STATE_DRIVER))
	{
		if(GetPlayerScore(playerid)>4)
		{
			new vehicleid = GetPlayerVehicleID(playerid);
			if(lockstate[vehicleid]==1)
			{
				lockstate[vehicleid]=0;
				GameTextForPlayer(playerid, "~g~Car unlocked.",3000,4);
				for(new i = 0; i <= MAX_PLAYERS; i++)
				{
					if(!IsVehicleStreamedIn(vehicleid,i)) continue;
					SetVehicleParamsForPlayer(vehicleid,i,0,0);
				}
			}
		}
	}
	if((newkeys==KEY_ANALOG_DOWN)&&(IsPlayerInAnyVehicle(playerid))&&(GetPlayerState(playerid)==PLAYER_STATE_DRIVER))
	{
		if(GetPlayerScore(playerid)>4)
		{
			if(lockstate[GetPlayerVehicleID(playerid)]==0)
			{
				new vehicleid = GetPlayerVehicleID(playerid);
				lockstate[vehicleid]=1;
				GameTextForPlayer(playerid, "~r~Car locked",3000,4);
				for(new i = 0; i <= MAX_PLAYERS; i++)
				{
					if(!IsVehicleStreamedIn(vehicleid,i)) continue;
					SetVehicleParamsForPlayer(vehicleid,i,0,1);
				}
			}
		}
		
	}
	if((newkeys==KEY_CROUCH)&&lockstate[lastcar[playerid]]>0&&(GetPlayerState(playerid)==PLAYER_STATE_ONFOOT))
	{
		if(GetPlayerScore(playerid)>4)
		{
			lockstate[lastcar[playerid]]=0;
			GameTextForPlayer(playerid, "~g~Car unlocked.",3000,4);
			for(new i = 0; i <= MAX_PLAYERS; i++)
			{
				if(!IsVehicleStreamedIn(lastcar[playerid], i)) continue;
				SetVehicleParamsForPlayer(lastcar[playerid],i,0,0);
			}
		}
	}
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
		if(lockstate[vehicleid]==1)
		{
		SetVehicleParamsForPlayer(vehicleid,forplayerid,0,1);
		}
}

public OnPlayerDisconnect(playerid)
{
	if 	(IsTowTrucker[playerid]==1)
		{
		IsTowTrucker[playerid]=0;
		TowTruckers--;
		}
	lockstate[lastcar[playerid]]=0;
	lastcar[playerid]=-1;
	return 1;
}

public OnPlayerConnect(playerid)
{
	lastcar[playerid]=-1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
}

public OnPlayerStreamOut(playerid, forplayerid)
{
}