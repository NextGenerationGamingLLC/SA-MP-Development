/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Pizzaboy System

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
/*
CMD:getpizza(playerid, params[]) {
	if(PlayerInfo[playerid][pJob] != 21 && PlayerInfo[playerid][pJob2] != 21 && PlayerInfo[playerid][pJob3] != 21) {
		SendClientMessageEx(playerid,COLOR_GREY,"   You are not a Pizza Boy!");
	}
    else if(!IsAPizzaCar(GetPlayerVehicleID(playerid))) {
	    SendClientMessageEx(playerid,COLOR_GREY,"   You need to be driving a pizzaboy found at the side of the Pizza Stack!");
	}
	else if(GetPlayerSkin(playerid) != 155) {
	    SendClientMessageEx(playerid,COLOR_GREY,"   You need to be in the Pizza Stack uniform!");
	}
	else if(GetPVarType(playerid, "Pizza")) {
		SendClientMessageEx(playerid, COLOR_GREY, "   You are already delivering pizzas!");
	}
	else if(!IsPlayerInRangeOfPoint(playerid, 5.0, 2103.6714,-1785.5222,12.9849)) {
		SendClientMessageEx(playerid,COLOR_GREY,"   You are not at the Pizza Stack pickup!");
	}
	else if(gettime() < GetPVarInt(playerid, "PizzaCoolDown")) {
		new str[53];
		format(str, sizeof(str), "Please wait %d seconds before getting another pizza!", GetPVarInt(playerid, "PizzaCoolDown")-gettime());
		SendClientMessageEx(playerid,COLOR_GREY, str);
	}
	else {

		new rand = random(MAX_HOUSES - 1), i;
		while(!(HouseInfo[rand][hOwned] && HouseInfo[rand][hExteriorZ] <= 100 && HouseInfo[rand][hExteriorX] > 516.5287 && HouseInfo[rand][hExteriorX] < 2881.0891 && HouseInfo[rand][hExteriorY] < -909.6716 && HouseInfo[rand][hExteriorY] > -1785.5222 && HouseInfo[rand][hExtIW] == PlayerInfo[playerid][pVW] && HouseInfo[rand][hExtVW] == PlayerInfo[playerid][pInt])) {
			if(++rand >= MAX_HOUSES) {
				rand = 0;
			}
			if (i++ > MAX_HOUSES) return 1;
		}

		new
			iDist = floatround(GetPlayerDistanceFromPoint(playerid, HouseInfo[rand][hExteriorX], HouseInfo[rand][hExteriorY], HouseInfo[rand][hExteriorZ])),
			szMessage[86];

		SetPVarInt(playerid, "tpPizzaTimer", iDist / 80);
		SetPVarInt(playerid, "pizzaTotal", iDist / 10);
		SetPVarInt(playerid, "pizzaTimer", iDist / 10);
		SetPVarInt(playerid, "Pizza", rand);
		SetPVarInt(playerid, "PizzaCoolDown", gettime()+60);

		SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_TPPIZZARUNTIMER);
		SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_PIZZATIMER);

		format(szMessage, sizeof(szMessage), "You have picked up a pizza for %s. You have %d seconds to deliver it!", StripUnderscore(HouseInfo[rand][hOwnerName]), iDist / 10);
		SendClientMessageEx(playerid, COLOR_WHITE, szMessage);

		SetPlayerCheckpoint(playerid, HouseInfo[rand][hExteriorX], HouseInfo[rand][hExteriorY], HouseInfo[rand][hExteriorZ], 5);
	}
	return 1;
}
*/

CMD:getpizza(playerid, params[]) {
	if(PlayerInfo[playerid][pJob] != 21 && PlayerInfo[playerid][pJob2] != 21 && PlayerInfo[playerid][pJob3] != 21) {
		SendClientMessageEx(playerid,COLOR_GREY,"You are not a Pizza Boy!");
	}
    else if(!IsAPizzaCar(GetPlayerVehicleID(playerid))) {
	    SendClientMessageEx(playerid,COLOR_GREY,"You need to be driving a pizzaboy found at the side of the Pizza Stack!");
	}
	else if(GetPlayerSkin(playerid) != 155) {
	    SendClientMessageEx(playerid,COLOR_GREY,"You need to be in the Pizza Stack uniform!");
	}
	else if(GetPVarType(playerid, "Pizza")) {
		SendClientMessageEx(playerid, COLOR_GREY, "You are already delivering pizzas!");
	}
	else if (!IsPlayerInRangeOfPoint(playerid, 5.0, -1713.961425, 1348.545166, 7.180452) && !IsPlayerInRangeOfPoint(playerid, 5.0, 2103.6714,-1785.5222,12.9849)) { // Sort this out
		SendClientMessageEx(playerid,COLOR_GREY,"You are not at a Pizza Stack pickup!");
	}
	else if(gettime() < GetPVarInt(playerid, "PizzaCoolDown")) {
		new str[53];
		format(str, sizeof(str), "Please wait %d seconds before getting another pizza!", GetPVarInt(playerid, "PizzaCoolDown")-gettime());
		SendClientMessageEx(playerid,COLOR_GREY, str);
	}
	else if(IsPlayerInRangeOfPoint(playerid, 3.0, -1713.961425, 1348.545166, 7.180452)) { // Pier 69
		
		new rand = random(MAX_HOUSES - 1), i;
		while(!(HouseInfo[rand][hOwned] && HouseInfo[rand][hExteriorZ] <= 100 && HouseInfo[rand][hExteriorX] > -2802.389648 && HouseInfo[rand][hExteriorX] < -1400.710327 && HouseInfo[rand][hExteriorY] < 2800 && HouseInfo[rand][hExteriorY] > -216.298019 && HouseInfo[rand][hExtIW] == PlayerInfo[playerid][pVW] && HouseInfo[rand][hExtVW] == PlayerInfo[playerid][pInt])) {
			if(++rand >= MAX_HOUSES) {
				rand = 0;
			}
			if (i++ > MAX_HOUSES) return 1;
		}

		new
			iDist = floatround(GetPlayerDistanceFromPoint(playerid, HouseInfo[rand][hExteriorX], HouseInfo[rand][hExteriorY], HouseInfo[rand][hExteriorZ])),
			szMessage[86];

		SetPVarInt(playerid, "tpPizzaTimer", iDist / 80);
		SetPVarInt(playerid, "pizzaTotal", iDist / 10);
		SetPVarInt(playerid, "pizzaTimer", iDist / 10);
		SetPVarInt(playerid, "Pizza", rand);
		SetPVarInt(playerid, "PizzaCoolDown", gettime()+60);

		SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_TPPIZZARUNTIMER);
		SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_PIZZATIMER);

		format(szMessage, sizeof(szMessage), "You have picked up a pizza for %s. You have %d seconds to deliver it!", StripUnderscore(HouseInfo[rand][hOwnerName]), iDist / 10);
		SendClientMessageEx(playerid, COLOR_WHITE, szMessage);

		SetPlayerCheckpoint(playerid, HouseInfo[rand][hExteriorX], HouseInfo[rand][hExteriorY], HouseInfo[rand][hExteriorZ], 5);
	}
	else if(IsPlayerInRangeOfPoint(playerid, 5.0, 2103.6714,-1785.5222,12.9849)) { // Idlewood

		new rand = random(MAX_HOUSES - 1), i;
		while(!(HouseInfo[rand][hOwned] && HouseInfo[rand][hExteriorZ] <= 100 && HouseInfo[rand][hExteriorX] > 516.5287 && HouseInfo[rand][hExteriorX] < 2881.0891 && HouseInfo[rand][hExteriorY] < -909.6716 && HouseInfo[rand][hExteriorY] > -1785.5222 && HouseInfo[rand][hExtIW] == PlayerInfo[playerid][pVW] && HouseInfo[rand][hExtVW] == PlayerInfo[playerid][pInt])) {
			if(++rand >= MAX_HOUSES) {
				rand = 0;
			}
			if (i++ > MAX_HOUSES) return 1;
		}

		new
			iDist = floatround(GetPlayerDistanceFromPoint(playerid, HouseInfo[rand][hExteriorX], HouseInfo[rand][hExteriorY], HouseInfo[rand][hExteriorZ])),
			szMessage[86];

		SetPVarInt(playerid, "tpPizzaTimer", iDist / 80);
		SetPVarInt(playerid, "pizzaTotal", iDist / 10);
		SetPVarInt(playerid, "pizzaTimer", iDist / 10);
		SetPVarInt(playerid, "Pizza", rand);
		SetPVarInt(playerid, "PizzaCoolDown", gettime()+60);

		SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_TPPIZZARUNTIMER);
		SetTimerEx("OtherTimerEx", 1000, false, "ii", playerid, TYPE_PIZZATIMER);

		format(szMessage, sizeof(szMessage), "You have picked up a pizza for %s. You have %d seconds to deliver it!", StripUnderscore(HouseInfo[rand][hOwnerName]), iDist / 10);
		SendClientMessageEx(playerid, COLOR_WHITE, szMessage);

		SetPlayerCheckpoint(playerid, HouseInfo[rand][hExteriorX], HouseInfo[rand][hExteriorY], HouseInfo[rand][hExteriorZ], 5);
	}
	return 1;
}