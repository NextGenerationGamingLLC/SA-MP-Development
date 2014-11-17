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

CMD:placefirework(playerid, params[])
{
	if(fireworktog == 0 || GetPVarInt(playerid, "camerasc") == 1 || GetPVarInt(playerid, "rccam") == 1) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot currently launch fireworks.");
	if(PlayerInfo[playerid][pLevel] < 3) return SendClientMessageEx(playerid, COLOR_GREY, "You must be Level 3+ to place a firework!");
	if(GetPVarInt(playerid, "IsInArena") >= 0) return SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this while being in an arena!");
	if(WatchingTV[playerid] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot do this while watching TV!");
	if(GetPVarInt(playerid, "Injured") == 1 || PlayerInfo[playerid][pHospital] > 0 || IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this right now.");
	if(RocketExplosions[playerid] != -1) return SendClientMessageEx(playerid, COLOR_WHITE, "You are already using another firework!");
	if (PlayerInfo[playerid][pVW] != 0 || PlayerInfo[playerid][pInt] != 0) return SendClientMessageEx(playerid, COLOR_WHITE, "You can't launch fireworks indoors!");
	if(PlayerInfo[playerid][pFirework] > 0 || PlayerInfo[playerid][pAdmin] >= 4)
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
	    if (PlayerInfo[playerid][pAdmin] < 4)
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
	if(PlayerInfo[playerid][pAdmin] >= 4)
	{
		new Float: pos[3];
		SendClientMessageEx(playerid, COLOR_RED, "* Listing all fireworks within 50 meters of you...");
		for(new i, string[128]; i < MAX_PLAYERS; i++)
		{
			if(RocketExplosions[i] != -1)
			{
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
