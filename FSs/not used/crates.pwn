/*

	 		/$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
			| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
			| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
			| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
			| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
			| $$\  $$$| $$  \ $$        | $$  \ $$| $$
			| $$ \  $$|  $$$$$$/        | $$  | $$| $$
			|__/  \__/ \______/         |__/  |__/|__/

                  Next Generation RolePlay Crate Event
		(created by Next Generation Gaming Development Team)

		Combined Credits:
		(***) Scott

*/
#include <a_samp>
#include <zcmd>
#include <sscanf2>
#include <streamer>

#define COLOR_WHITE 0xFFFFFFAA

new cratesspawned;
new Crates[110];

public OnFilterScriptInit()
{
	AntiDeAMX();
}


CMD:cratehelp(playerid, params[])
{
	SendClientMessage(playerid, COLOR_WHITE, "Crate Commands:");
	SendClientMessage(playerid, COLOR_WHITE, "/cratespawn, /cratedestroy, /cratefall [number]");
	return 1;
}

CMD:cratefall(playerid, params[])
{
    new name[24];
	GetPlayerName(playerid, name, 24);
    if(IsPlayerAdmin(playerid) || strcmp(name, "Scott_Reed", true) == 0 || strcmp(name, "Dwight_Schrute", true) == 0)
	{
		if(cratesspawned == 0) return SendClientMessage(playerid, COLOR_WHITE, "Error: Crates are not yet spawned, use /cratespawn");
		new cratestofall;
		if(sscanf(params, "i",cratestofall)) return SendClientMessage(playerid, COLOR_WHITE, "USAGE: /cratefall [number]");
		CrateFall(playerid, cratestofall);
	}
	return 1;
}

CMD:cratespawn(playerid, params[])
{
	new name[24];
	GetPlayerName(playerid, name, 24);
    if(IsPlayerAdmin(playerid) || strcmp(name, "Scott_Reed", true) == 0 || strcmp(name, "Dwight_Schrute", true) == 0)
	{
		if(cratesspawned == 1) return SendClientMessage(playerid, COLOR_WHITE, "Error: Crates are already spawned, use /cratedestroy");
		SendClientMessage(playerid, COLOR_WHITE, "Spawning crates..");
		SpawnCrates(playerid);
	}
	return 1;
}

CMD:cratedestroy(playerid, params[])
{
	new name[24];
	GetPlayerName(playerid, name, 24);
    if(IsPlayerAdmin(playerid) || strcmp(name, "Scott_Reed", true) == 0 || strcmp(name, "Dwight_Schrute", true) == 0)
	{
		if(cratesspawned == 0) return SendClientMessage(playerid, COLOR_WHITE, "Error: Crates are not yet spawned, use /cratespawn");
		SendClientMessage(playerid, COLOR_WHITE, "Destroying crates..");
		DestroyCrates(playerid);
	}
	return 1;
}

public OnDynamicObjectMoved(objectid)
{
 	for(new x;x<sizeof(Crates);x++)
	{
		if(objectid == Crates[x])
		{
  			DestroyDynamicObject(Crates[x]);
	    	return 1;
		}
	}
	return 1;
}

stock SpawnCrates(playerid)
{
	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(playerid, X, Y, Z);
	//Generate the square
	new block = 0;
	for(new x;x<15;x++)
	{
		for(new y;y<7;y++)
		{
			Crates[block] = CreateDynamicObject(2932, X + (3*x), Y + (7.1*y), Z, 0, 0, 0);
			block ++;
		}
	}
	new string[128];
	format(string, sizeof(string), "Crates spawned at %f, %f, %f", X, Y, Z);
	SendClientMessage(playerid, COLOR_WHITE, string);
	cratesspawned=1;
	return 1;
}

stock DestroyCrates(playerid)
{
	new block = 0;
	for(new x;x<15;x++)
	{
		for(new y;y<7;y++)
		{
			DestroyDynamicObject(Crates[block]);
			block ++;
		}
	}
	SendClientMessage(playerid, COLOR_WHITE, "Crates Destroyed");
	cratesspawned=0;
	return 1;
}

stock CrateFall(playerid, number)
{
	new rand, x;
	top:
	rand = random(105);
	if(IsValidDynamicObject(Crates[rand]))
	{
		new Float:X, Float:Y, Float:Z;
		GetDynamicObjectPos(Crates[rand], X, Y, Z);
		MoveDynamicObject(Crates[rand], X, Y, Z-10, 2);
		number--;
	}
	x++;
	if(x > 10000 || number <= 0)
	{
		SendClientMessage(playerid, COLOR_WHITE, "Crates fallen (if no crates fell, try again.)");
	    return 1;
	}
	else
	{
		goto top;
	}
	return 1;
}

AntiDeAMX()
{
    new a[][] =
    {
        "Unarmed (Fist)",
        "Brass K"
    };
    #pragma unused a
}
