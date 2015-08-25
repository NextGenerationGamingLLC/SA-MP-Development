/*
    	 		 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
				| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
				| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
				| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
				| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
				| $$\  $$$| $$  \ $$        | $$  \ $$| $$
				| $$ \  $$|  $$$$$$/        | $$  | $$| $$
				|__/  \__/ \______/         |__/  |__/|__/

//--------------------------------[WRAPPERS.PWN]--------------------------------


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

			/*  ---------------- WRAPPERS ----------------- */

Internal_SetPlayerPos(playerid, Float:X, Float:Y, Float:Z) {

	return SetPlayerPos(playerid, X, Y, Z);
}

Internal_TogglePlayerSpectating(playerid, toggle) {

	switch(toggle) {

		case 0: Character_Actor(playerid, 1);
		case 1: Character_Actor(playerid, 0);
	}
	return TogglePlayerSpectating(playerid, toggle);
}

Internal_SetPlayerHealth(playerid, Float:health) {

	PlayerInfo[playerid][pHealth] = health;
	return SetPlayerHealth(playerid, health);
}

Internal_SetPlayerArmour(playerid, Float:armour) {

	PlayerInfo[playerid][pArmor] = armour;
	return SetPlayerArmour(playerid, armour);
}

Internal_SetPlayerWeather(playerid, iWeatherID) {

	if(Bit_State(g_PlayerBits[playerid], dr_bitInDrugEffect)) return 1;
	return SetPlayerWeather(playerid, iWeatherID);
}

Internal_SetPlayerTime(playerid, iHour, iMinute) {

	if(Bit_State(g_PlayerBits[playerid], dr_bitInDrugEffect)) return 1;
	return SetPlayerTime(playerid, iHour, iMinute);
}

Internal_CreateVehicle(vehicletype, Float:x, Float:y, Float:z, Float:rotation, color1, color2, respawn_delay, addsiren=0) {

	new i = CreateVehicle(vehicletype, Float:x, Float:y, Float:z, Float:rotation, color1, color2, respawn_delay, addsiren);
	Iter_Add(Vehicles, i);
	return i;
}

Internal_DestroyVehicle(vehicleid) {
	
	Iter_Remove(Vehicles, vehicleid);
	return DestroyVehicle(vehicleid);
}


#define SetPlayerWeather(%0) Internal_SetPlayerWeather(%0)
#define SetPlayerTime(%0) Internal_SetPlayerTime(%0)
#define SetPlayerHealth(%0) Internal_SetPlayerHealth(%0)
#define SetPlayerArmour(%0) Internal_SetPlayerArmour(%0)
#define CreateVehicle(%0) Internal_CreateVehicle(%0)
#define DestroyVehicle(%0) Internal_DestroyVehicle(%0)
#define SetPlayerPos(%0) Internal_SetPlayerPos(%0)
#define TogglePlayerSpectating(%0) Internal_TogglePlayerSpectating(%0)
#define SetPlayerHealth(%0) Internal_SetPlayerHealth(%0)
#define SetPlayerArmour(%0) Internal_SetPlayerArmour(%0)