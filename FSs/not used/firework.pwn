/*

	 		/$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
			| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
			| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
			| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
			| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
			| $$\  $$$| $$  \ $$        | $$  \ $$| $$
			| $$ \  $$|  $$$$$$/        | $$  | $$| $$
			|__/  \__/ \______/         |__/  |__/|__/

                  Next Generation RolePlay 4th of July Fireworks
		(created by Next Generation Gaming Development Team)

		Combined Credits:
		(***) Beren

*/

#define FILTERSCRIPT

#include <a_samp>
#include <zcmd>
#include <sscanf2>
#include <foreach>
#include <streamer>

#define COLOR_GREY 0xAFAFAFAA
#define COLOR_WHITE 0xFFFFFFAA
#define COLOR_YELLOW 0xFFFF00AA
#define RocketHeight 50
#define RocketSpread 30
#define MAX_LAUNCH 20
#define MAX_FIREWORKS 100

new Rocket[MAX_LAUNCH];
new RocketLight[MAX_LAUNCH];
new RocketSmoke[MAX_LAUNCH];
new RocketExplosions[MAX_LAUNCH];
new Float:rx[MAX_LAUNCH];
new Float:ry[MAX_LAUNCH];
new Float:rz[MAX_LAUNCH];
new FireworkTotal;
new Fired;

GetPlayerNameEx(playerid) {

	new	sz_playerName[MAX_PLAYER_NAME],	i_pos;

	GetPlayerName(playerid, sz_playerName, MAX_PLAYER_NAME);
	while ((i_pos = strfind(sz_playerName, "_", false, i_pos)) != -1) sz_playerName[i_pos] = ' ';
	return sz_playerName;
}

forward Firework(i);
public Firework(i)
{
	new Float:x, Float:y, Float:z;
	x = rx[i];
	y = ry[i];
	z = rz[i];
	z += RocketHeight;
	if (RocketExplosions[i] == 0)
	{
	    DestroyDynamicObject(Rocket[i]);
	    DestroyDynamicObject(RocketLight[i]);
	    DestroyDynamicObject(RocketSmoke[i]);
	    CreateExplosion(x ,y, z, 4, 10);
	    CreateExplosion(x ,y, z, 5, 10);
	    CreateExplosion(x ,y, z, 6, 10);
	}
	else if (RocketExplosions[i] >= MAX_FIREWORKS)
	{
	    for (new j = 0; j <= RocketSpread; j++)
	    {
	    	CreateExplosion(x + float(j - (RocketSpread / 2)), y, z, 7, 10);
	    	CreateExplosion(x, y + float(j - (RocketSpread / 2)), z, 7, 10);
	    	CreateExplosion(x, y, z + float(j - (RocketSpread / 2)), 7, 10);
	    }
	    RocketExplosions[i] = -1;
	    FireworkTotal = 0;
	    Fired = 0;
	    return 1;
	}
	else
	{
		x += float(random(RocketSpread) - (RocketSpread / 2));
		y += float(random(RocketSpread) - (RocketSpread / 2));
		z += float(random(RocketSpread) - (RocketSpread / 2));
	    CreateExplosion(x, y, z, 7, 10);
	}
	RocketExplosions[i]++;
	SetTimerEx("Firework", 250, 0, "i", i);
	return 1;
}

public OnFilterScriptInit()
{
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

CMD:placefw(playerid, params[])
{
	if(IsPlayerAdmin(playerid))
	{
		if(FireworkTotal == MAX_LAUNCH)
		{
		    SendClientMessage(playerid, COLOR_WHITE, "You have reached maximum number of fireworks!");
			return 1;
		}
		if(Fired == 1)
		{
		    SendClientMessage(playerid, COLOR_WHITE, "Wait till your fireworks are done before placing new ones!");
			return 1;
		}
		new string[128];
		format(string, sizeof(string), "%s has placed a special firework.", GetPlayerNameEx(playerid));
	    new Float:x, Float:y, Float:z, Float:a;
	    GetPlayerPos(playerid, x, y, z);
	    foreach(Player, i)
		{
			if(IsPlayerInRangeOfPoint(i, 30, x, y, z)) {
				SendClientMessage(i, COLOR_YELLOW, string);
			}
	    }
	    GetPlayerFacingAngle(playerid, a);
	    x += (2 * floatsin(-a, degrees));
    	y += (2 * floatcos(-a, degrees));
	    Rocket[FireworkTotal] = CreateDynamicObject(3786, x, y, z, 0, 90, 0);
	    RocketLight[FireworkTotal] = CreateDynamicObject(354, x, y, z + 1, 0, 90, 0);
		RocketSmoke[FireworkTotal] = CreateDynamicObject(18716, x, y, z - 4, 0, 0, 0);
		rx[FireworkTotal] = x;
		ry[FireworkTotal] = y;
		rz[FireworkTotal] = z;
		RocketExplosions[FireworkTotal] = 0;
		FireworkTotal++;
	}
	return 1;
}

CMD:launchfw(playerid, params[])
{
    if(IsPlayerAdmin(playerid))
	{
	    if(FireworkTotal == 0)
		{
		    SendClientMessage(playerid, COLOR_WHITE, "You dont have any fireworks!");
			return 1;
		}
		if(Fired == 1)
		{
		    SendClientMessage(playerid, COLOR_WHITE, "You have already fired your fireworks!");
			return 1;
		}
		for(new i = 0; i < FireworkTotal; i++)
		{
			CreateExplosion(rx[i] ,ry[i], rz[i], 12, 5);
			new time = MoveDynamicObject(Rocket[i], rx[i] ,ry[i], rz[i] + RocketHeight, 10);
			MoveDynamicObject(RocketLight[i], rx[i] ,ry[i], rz[i] + 2 + RocketHeight, 10);
			MoveDynamicObject(RocketSmoke[i], rx[i] ,ry[i], rz[i] + RocketHeight, 10);
			SetTimerEx("Firework", time, 0, "i", i);
		}
		Fired = 1;
	}
	return 1;
}
