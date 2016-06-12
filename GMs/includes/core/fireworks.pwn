/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Fireworks System

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

forward Firework(playerid, type);
public Firework(playerid, type)
{
	if(!IsPlayerConnected(playerid))
	{
	    DestroyDynamicObject(Rocket[playerid]);
	    DestroyDynamicObject(RocketLight[playerid]);
	    DestroyDynamicObject(RocketSmoke[playerid]);
	    return 1;
	}
    new Float:x, Float:y, Float:z;
    x = GetPVarFloat(playerid, "fxpos");
    y = GetPVarFloat(playerid, "fypos");
    z = GetPVarFloat(playerid, "fzpos");
    if (type == TYPE_COUNTDOWN)
    {
        new string[128];
		format(string, sizeof(string), "STAND BACK! 5 seconds till launch!", GetPlayerNameEx(playerid));
	    ProxDetector(30.0, playerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
	    SetTimerEx("Firework", 5000, 0, "ii", playerid, TYPE_LAUNCH);
    }
	else if(type == TYPE_LAUNCH)
	{
	    CreateExplosion(x ,y, z, 12, 5);
		new time = MoveDynamicObject(Rocket[playerid], x, y, z + RocketHeight, 10);
		MoveDynamicObject(RocketLight[playerid], x, y, z + 2 + RocketHeight, 10);
		MoveDynamicObject(RocketSmoke[playerid], x, y, z + RocketHeight, 10);
		SetTimerEx("Firework", time, 0, "ii", playerid, TYPE_EXPLODE);
	}
	else if(type == TYPE_EXPLODE)
	{
	    z += RocketHeight;
	    if (RocketExplosions[playerid] == 0)
		{
		    DestroyDynamicObject(Rocket[playerid]);
		    DestroyDynamicObject(RocketLight[playerid]);
		    DestroyDynamicObject(RocketSmoke[playerid]);
		    CreateExplosion(x ,y, z, 4, 10);
		    CreateExplosion(x ,y, z, 5, 10);
		    CreateExplosion(x ,y, z, 6, 10);
		}
		else if (RocketExplosions[playerid] >= MAX_FIREWORKS)
		{
		    for (new i = 0; i <= FireworkSpread; i++)
		    {
		    	CreateExplosion(x + float(i - (FireworkSpread / 2)), y, z, 7, 10);
		    	CreateExplosion(x, y + float(i - (FireworkSpread / 2)), z, 7, 10);
		    	CreateExplosion(x, y, z + float(i - (FireworkSpread / 2)), 7, 10);
		    }
		    RocketExplosions[playerid] = -1;
		    return 1;
		}
		else
		{
			x += float(random(FireworkSpread) - (FireworkSpread / 2));
			y += float(random(FireworkSpread) - (FireworkSpread / 2));
			z += float(random(FireworkSpread) - (FireworkSpread / 2));
		    CreateExplosion(x, y, z, 7, 10);
		}
		RocketExplosions[playerid]++;
  		SetTimerEx("Firework", 250, 0, "ii", playerid, TYPE_EXPLODE);
	}
	return 1;
}

CMD:placefirework(playerid, params[])
{
	if(fireworktog == 0 || GetPVarInt(playerid, "camerasc") == 1 || GetPVarInt(playerid, "rccam") == 1) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot currently launch fireworks.");
	if(PlayerInfo[playerid][pLevel] < 3) return SendClientMessageEx(playerid, COLOR_GREY, "You must be Level 3+ to place a firework!");
	if(GetPVarType(playerid, "IsInArena")) return SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this while being in an arena!");
	if(GetPVarInt(playerid, "WatchingTV")) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot do this while watching TV!");
	if(GetPVarInt(playerid, "Injured") == 1 || PlayerInfo[playerid][pHospital] > 0 || IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this right now.");
	if(RocketExplosions[playerid] != -1) return SendClientMessageEx(playerid, COLOR_WHITE, "You are already using another firework!");
	if (PlayerInfo[playerid][pVW] != 0 || PlayerInfo[playerid][pInt] != 0) return SendClientMessageEx(playerid, COLOR_WHITE, "You can't launch fireworks indoors!");
	if(PlayerInfo[playerid][pFirework] > 0 || PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1)
	{
		new Float:x, Float:y, Float:z, Float:a;
	    GetPlayerPos(playerid, x, y, z);
	    GetPlayerFacingAngle(playerid, a);
		
		if(dynamicgift != 0) // Currently a dynamic gift is placed down
		{
			new Float: Pos[3];
			GetDynamicObjectPos(dynamicgift, Pos[0], Pos[1], Pos[2]);
			
			if(IsPlayerInRangeOfPoint(playerid, 50.0, Pos[0], Pos[1], Pos[2]))
				return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot place a firework down near the giftbox.");
		}		
	    if (PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pASM] < 1)
	    {
	    	PlayerInfo[playerid][pFirework]--;
	    }
		new string[128];
		format(string, sizeof(string), "%s has placed a firework which will go off in 30 seconds!", GetPlayerNameEx(playerid));
	    ProxDetector(30.0, playerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
	    ApplyAnimation(playerid,"BOMBER","BOM_Plant_Crouch_In", 4.0, 0, 0, 0, 0, 0, 1);
	    x += (2 * floatsin(-a, degrees));
    	y += (2 * floatcos(-a, degrees));
	    Rocket[playerid] = CreateDynamicObject(3786, x, y, z, 0, 90, 0);
	    RocketLight[playerid] = CreateDynamicObject(354, x, y, z + 1, 0, 0, 0);
		RocketSmoke[playerid] = CreateDynamicObject(18716, x, y, z - 4, 0, 0, 0);
	    SetPVarFloat(playerid,"fxpos",x);
  		SetPVarFloat(playerid,"fypos",y);
  		SetPVarFloat(playerid,"fzpos",z);
  		RocketExplosions[playerid] = 0;
  		SetTimerEx("Firework", 25000, 0, "ii", playerid, TYPE_COUNTDOWN);
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You don't have any fireworks!");
	}
	return 1;
}

CMD:togfireworks(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 1337)
	{
		if(fireworktog == 0)
		{
			fireworktog = 1;
			SendClientMessageEx(playerid, COLOR_WHITE, "You have enabled the placement of fireworks.");
		}
		else
		{
			fireworktog = 0;
			SendClientMessageEx(playerid, COLOR_WHITE, "You have disabled the placement of fireworks.");
		}
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD2, "You're not authorized to use this command.");
	return 1;
}

CMD:fireworknear(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1)
	{
		new Float: pos[3];
		SendClientMessageEx(playerid, COLOR_RED, "* Listing all fireworks within 50 meters of you...");
		foreach(new i : Player)
		{
			if(RocketExplosions[i] != -1)
			{
				new string[128];
				
				pos[0] = GetPVarFloat(i, "fxpos");
				pos[1] = GetPVarFloat(i, "fypos");
				pos[2] = GetPVarFloat(i, "fzpos");
				if(IsPlayerInRangeOfPoint(playerid, 50, pos[0], pos[1], pos[2]))
				{
					format(string, sizeof(string), "** Firework Owner: %s | %f from you", GetPlayerNameEx(i), GetPlayerDistanceFromPoint(playerid, GetPVarFloat(i, "fxpos"), GetPVarFloat(i, "fypos"), GetPVarFloat(i, "fzpos")));
					SendClientMessageEx(playerid, COLOR_WHITE, string);
				}
			}
		}
	}
	else 
		return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not authorized to use this command!");
	return true;
}
