/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

				Next Generation Gaming, LLC
	(created by Next Generation Gaming Development Team)

	Developers:
		(***) Austin


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

	-- 

	This is a module, not a filterscript.

	VERSION: 0.1

*/

new Float:_t_Pos[3];
new _t_zone;
new Float:_t_scatter[7][3] = {
	{520.026, -2006.262, 2.007},
	{504.765, -2006.710, 2.007},
	{504.792, -1995.228, 2.007},
	{508.803, -1985.477, 2.007},
	{517.988, -1980.903, 2.007},
	{520.514, -1972.035, 2.007},
	{505.900, -1970.852, 2.007}
};

hook OnGameModeInit()
{
	_t_zone = CreateDynamicRectangle(496.749359, -2013.100585, 526.126831, -1963.961425);
	_t_resetTreasure();
	return 1;
}

_t_resetTreasure() 
{
	new point = random(sizeof(_t_scatter));
	_t_Pos[0] = _t_scatter[point][0]+random(2);
	_t_Pos[1] = _t_scatter[point][1]+random(3);
	_t_Pos[2] = _t_scatter[point][2];
	printf("[TREASURE_ISLAND] %.f %.f %.f", _t_Pos[0], _t_Pos[1], _t_Pos[2]);
	return 1;
}

_t_ableTo(playerid)
{
	new year, month, day;
	getdate(year, month, day);
	if(!(month == 4 && day == 26)) return SendClientMessageEx(playerid, COLOR_GRAD2, "It's not NGG's BDay!"), 0;
	if(GetPVarType(playerid, "PlayerCuffed") || GetPVarInt(playerid, "pBagged") >= 1 || GetPVarType(playerid, "Injured") || GetPVarType(playerid, "IsFrozen") || GetPVarInt(playerid, "Hospital") || GetPVarType(playerid, "IsLive")) {
		SendClientMessage(playerid, COLOR_GRAD2, "You perform this action right now.");
		return 0;
	}
	new animlib[32],tmp[32];
	GetAnimationName(GetPlayerAnimationIndex(playerid),animlib,32,tmp,32);
	if(!strcmp(animlib, "SWIM")) return SendClientMessageEx(playerid, COLOR_GRAD2, "You cannot use this command while swimming!"), 0;
	if(IsPlayerInAnyVehicle(playerid) == 1)
	{
		SendClientMessage(playerid, COLOR_GRAD2, "You cannot use this whilst in a vehicle.");
		return 0;
	}
	new string[128];
	if(gettime() < PlayerInfo[playerid][pDigCooldown])
	{
		new seconds = PlayerInfo[playerid][pDigCooldown]-gettime();
		new minutes = seconds/60;
		format(string, sizeof(string), "[Treasure Island] %d minute(s) before you can use /dig again.", minutes);
		SendClientMessageEx(playerid, COLOR_GRAD2, string);
		return 0;
	}
	if(gettime() < GetPVarInt(playerid, "AntiDigSpam")) 
	{
		format(string, sizeof(string), "Please wait %d seconds before using the command again.", GetPVarInt(playerid, "AntiDigSpam")-gettime());
		SendClientMessageEx(playerid, COLOR_GRAD2, string);
		return 0;
	}
	return 1;
}

CMD:dig(playerid, params[]) 
{
	if(IsPlayerInDynamicArea(playerid, _t_zone)) {
		if(!_t_ableTo(playerid)) return 1;
		ApplyAnimation(playerid, "MEDIC", "CPR", 4.0, 0, 0, 0, 0, 0, 1);
		SetPVarInt(playerid, "AntiDigSpam", gettime()+30);
		if(IsPlayerInRangeOfPoint(playerid, 2.0, _t_Pos[0], _t_Pos[1], _t_Pos[2])) {
			SendClientMessageEx(playerid, COLOR_YELLOW, "TREASURE: You have found it! You may try again in 5 hours.");
			GiftPlayer(MAX_PLAYERS, playerid);
			PlayerInfo[playerid][pDigCooldown] = gettime()+18000;
			_t_resetTreasure();
		}
		else {
			SendClientMessageEx(playerid, COLOR_GRAD2, "Sorry! Seems you did not find it this time around.");
		}
	}
	else {
		SendClientMessageEx(playerid, COLOR_GRAD2, "You must be in the digging area at the beach to use this command!");
	}
	return 1;
}