// Kareemtastics Change
#include <a_samp>
#include <foreach>

#define dcmd(%1,%2,%3) if ((strcmp((%3)[1], #%1, true, (%2)) == 0) && ((((%3)[(%2) + 1] == 0) && (dcmd_%1(playerid, "")))||(((%3)[(%2) + 1] == 32) && (dcmd_%1(playerid, (%3)[(%2) + 2])))))return 1

forward IsPlayerInInvalidNosVehicle(playerid,vehicleid);

forward CrankTick();
new cranked[MAX_PLAYERS];

public OnFilterScriptInit()
{
	SetTimer("CrankTick", 3500, 1);
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	dcmd(crank, 5, cmdtext);
	return 0;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(newstate==PLAYER_STATE_ONFOOT&&oldstate==PLAYER_STATE_DRIVER)
	{
		cranked[playerid]=0;
	}
}

dcmd_crank(playerid, params[])
{
	#pragma unused params
	if(IsPlayerInInvalidNosVehicle(playerid, GetPlayerVehicleID(playerid))==1){SendClientMessage(playerid,0xAAAAAAAA, "You can't crank this.");return 1;}
	AddVehicleComponent(GetPlayerVehicleID(playerid),1087);
	AddVehicleComponent(GetPlayerVehicleID(playerid),1075);
	AddVehicleComponent(GetPlayerVehicleID(playerid),1010);
	SendClientMessage(playerid, 0xFFFFFFFF, "CRANKED");
	cranked[playerid]=1;
	return 1;
}

public IsPlayerInInvalidNosVehicle(playerid,vehicleid)
{
    #define MAX_INVALID_NOS_VEHICLES 30
    new InvalidNosVehicles[MAX_INVALID_NOS_VEHICLES] =
    {
	581,523,462,521,463,522,461,448,468,586,
	509,481,510,472,473,493,595,484,430,453,
	452,446,454,590,569,537,538,570,449,520
    };
    vehicleid = GetPlayerVehicleID(playerid);
    if(IsPlayerInVehicle(playerid,vehicleid)) {
	for(new i = 0; i < MAX_INVALID_NOS_VEHICLES; i++) {
	    if(GetVehicleModel(vehicleid) == InvalidNosVehicles[i])
		{
	        return true;
	    }
	}
    }
    return 0;
}

public CrankTick()
{
	foreach(Player, i)
	{
		if(!cranked[i]) continue;
		{
			if(!IsPlayerInInvalidNosVehicle(i, GetPlayerVehicleID(i))){AddVehicleComponent(GetPlayerVehicleID(i),1010);}
		}
	}
}
