//#define FILTERSCRIPT

#include <a_samp>
#include <YSI\y_timers>
#include <foreach>
#include <zcmd>

#define MAX_CAR_TELEPORT_WARNINGS 5 // Define how many warnings you want to show up

#define COLOR_YELLOW 0xFFFF00AA


new PlayerVehicleID[MAX_PLAYERS];
new PlayerEnterTime[MAX_PLAYERS][2];
new PlayerCarTeleportWarnings[MAX_PLAYERS];

/*
PlayerEnterTime[playerid][0] is used for a popular CLEO mod.
PlayerEnterTime[playerid][1] is used for a random vehicle teleporter.
*/


stock PlayerName(playerid)
{
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    return name;
}


public OnPlayerConnect(playerid)
{
    PlayerVehicleID[playerid] = INVALID_VEHICLE_ID;
    PlayerCarTeleportWarnings[playerid] = 0;
    return 1;
}

stock SendWarningMessage(message[])
{
	foreach(Player, playerid)
	{
	    new tog = GetPVarInt(playerid, "TPWarnings");
	    if(tog) SendClientMessage(playerid, COLOR_YELLOW, message);
	}
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
    if(newstate == PLAYER_STATE_DRIVER)
    {
        PlayerEnterTime[playerid][1] ++;
    }
    else if(oldstate == PLAYER_STATE_DRIVER)
    {
        if(PlayerEnterTime[playerid][1] > 2)
        {
            if(PlayerCarTeleportWarnings[playerid] <= MAX_CAR_TELEPORT_WARNINGS)
            {
                PlayerCarTeleportWarnings[playerid] ++;
                new string[128];
                format(string, sizeof(string), "Warning: %s (ID: %d) might possibly teleporting cars.", PlayerName(playerid), playerid);
                SendWarningMessage(string);
                PlayerEnterTime[playerid][1] --;
            }
        }
    }
    return 1;
}

task Timer2[500]()
{
    foreach(Player, i)
    {
        if(IsPlayerInAnyVehicle(i))
        {
            if(PlayerVehicleID[i] == INVALID_VEHICLE_ID)
            {
                PlayerVehicleID[i] = GetPlayerVehicleID(i);
            }
            else if(GetPlayerVehicleID(i) != PlayerVehicleID[i])
            {
                PlayerEnterTime[i][0] ++;
                PlayerVehicleID[i] = GetPlayerVehicleID(i);
            }
        }
    }
}


task Timer[1000]()
{
    foreach(Player, i)
    {
        if(PlayerEnterTime[i][0] == 1)
        {
            PlayerEnterTime[i][0] --;
        }
        if(PlayerEnterTime[i][1] >= 1)
        {
            PlayerEnterTime[i][1] --;
        }
        else if(PlayerEnterTime[i][0] >= 2)
        {
            if(PlayerCarTeleportWarnings[i] < MAX_CAR_TELEPORT_WARNINGS)
            {
                new string[128];
                format(string, sizeof(string), "Warning: %s (ID: %d) might possibly teleporting cars.",PlayerName(i), i);
                SendWarningMessage(string);
                PlayerCarTeleportWarnings[i] ++;
            }
            PlayerEnterTime[i][0] --;
        }
    }
}

CMD:togcartpwarnings(playerid, params[])
{
	new tog = GetPVarInt(playerid, "TPWarnings");
	if(tog)
	{
		SetPVarInt(playerid, "TPWarnings", 0);
		SendClientMessage(playerid, COLOR_YELLOW, "Car TP Warnings Disabled");
	}
	else
	{
		SetPVarInt(playerid, "TPWarnings", 1);
		SendClientMessage(playerid, COLOR_YELLOW, "Car TP Warnings Enabled");
	}
	return 1;
}
