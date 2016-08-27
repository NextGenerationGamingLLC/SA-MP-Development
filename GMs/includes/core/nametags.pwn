/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

					Anti Nametag System
					             Hannes

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

#include <YSI\y_hooks>

new NametagTimer[MAX_PLAYERS];

hook OnPlayerStreamIn(playerid, forplayerid)
{
	if(ac_ACToggle[AC_NAMETAGS]) 
	{ 
		NametagTimer[forplayerid] = SetTimerEx("RangeCheck", 100, true, "ii", playerid, forplayerid);
	}
	return 1;
}

hook OnPlayerStreamOut(playerid, forplayerid)
{
	KillTimer(NametagTimer[playerid]);
	return 1;
}

forward RangeCheck(playerid, forplayerid);
public RangeCheck(playerid, forplayerid)
{
	if(!ac_ACToggle[AC_NAMETAGS]) KillTimer(NametagTimer[playerid]);
	else
	{
		new Float:X, Float:Y, Float:Z;
		GetPlayerPos(forplayerid, X, Y, Z);
		
		if(playerTabbed[forplayerid] != 0) ShowPlayerNameTagForPlayer(forplayerid, playerid, true);
		if(IsPlayerInRangeOfPoint(playerid, 25.0, X, Y, Z)) ShowPlayerNameTagForPlayer(forplayerid, playerid, true);
		else ShowPlayerNameTagForPlayer(forplayerid, playerid, false);

		end:
	}
}