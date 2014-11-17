/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Poker System

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

CMD:jointable(playerid, params[])
{
	if(PlayerInfo[playerid][pConnectHours] < 5) {
	    SendClientMessageEx(playerid, COLOR_GREY, "You need 5 playing hours to join a poker table.");
	    return 1;
	}
	if(GetPVarType(playerid, "pkrTableID") == 0) {
		for(new t = 0; t < MAX_POKERTABLES; t++) {
			if(IsPlayerInRangeOfPoint(playerid, 5.0, PokerTable[t][pkrX], PokerTable[t][pkrY], PokerTable[t][pkrZ])) {
				if(PokerTable[t][pkrPass][0] != EOS) {
					if(!strcmp(params, PokerTable[t][pkrPass], false, 32)) {
						JoinPokerTable(playerid, t);
					} else {
						return SendClientMessage(playerid, COLOR_WHITE, "Usage: /jointable (password)");
					}
				} else {
					JoinPokerTable(playerid, t);
				}
				return 1;
			}
		}
	} else {
		SendClientMessage(playerid, COLOR_WHITE, "You are already at a Poker Table! You must /leavetable before you join another one!");
	}
	return 1;
}

CMD:leavetable(playerid, params[])
{
	if(GetPVarType(playerid, "pkrTableID")) {
		LeavePokerTable(playerid);
	}
	return 1;
}

CMD:placetable(playerid, params[])
{
	if(PlayerInfo[playerid][pTable] == 1 || PlayerInfo[playerid][pAdmin] >= 4)
	{
	    if(GetPVarInt(playerid, "IsInArena") >= 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can't do this while being in an arena!");
		if(WatchingTV[playerid] != 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can not do this while watching TV!");
		if(GetPVarInt(playerid, "Injured") == 1 || PlayerInfo[playerid][pHospital] > 0 || IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You can't do this right now.");
		if(PlayerInfo[playerid][pVW] == 0 || PlayerInfo[playerid][pInt] == 0) return SendClientMessageEx(playerid, COLOR_GREY, "You can only place poker tables inside interiors.");
		if(GetPVarType(playerid, "pTable")) return SendClientMessageEx(playerid, COLOR_GREY, "You already have a poker table out, use /destroytable.");

		//foreach(new i: Player)
		for(new i = 0; i < MAX_PLAYERS; ++i)
		{
			if(IsPlayerConnected(i))
			{
				if(GetPVarType(i, "pTable"))
				{
					if(IsPlayerInRangeOfPoint(playerid, 7.0, PokerTable[GetPVarInt(i, "pTable")][pkrX], PokerTable[GetPVarInt(i, "pTable")][pkrY], PokerTable[GetPVarInt(i, "pTable")][pkrZ]))
					{
						SendClientMessage(playerid, COLOR_GREY, "You are in range of another poker table, you can't place one here!");
						return 1;
					}
				}
			}	
		}


		new string[128];
		format(string, sizeof(string), "%s has placed a poker table!", GetPlayerNameEx(playerid));
	    ProxDetector(30.0, playerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);

	    new Float:x, Float:y, Float:z, Float:a;
	    GetPlayerPos(playerid, x, y, z);
	    GetPlayerFacingAngle(playerid, a);
	    ApplyAnimation(playerid,"BOMBER","BOM_Plant_Crouch_In", 4.0, 0, 0, 0, 0, 0, 1);
	    x += (2 * floatsin(-a, degrees));
    	y += (2 * floatcos(-a, degrees));
		z -= 0.5;

        for(new i = 0; i < MAX_POKERTABLES; i++) {
		    if(PokerTable[i][pkrPlaced] == 0) {
				PlacePokerTable(i, 1, x, y, z, 0, 0, 0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
				SetPVarInt(playerid, "pTable", i);
				break;
			}
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You don't have a poker table! Buy from one shop.ng-gaming.net");
	}
	return 1;
}

CMD:destroytable(playerid, params[])
{
	if(GetPVarType(playerid, "pTable"))
	{
	    if(PokerTable[GetPVarType(playerid, "pTable")][pkrPlayers] != 0)
			return SendClientMessageEx(playerid, COLOR_GREY, "You can't destroy your table while a game is in progress.");

	    DestroyPokerTable(GetPVarInt(playerid, "pTable"));
		DeletePVar(playerid, "pTable");
		SendClientMessage(playerid, COLOR_GREY, "You've destroyed your poker table!");
	}
	return 1;
}

CMD:shoptable(playerid, params[])
{
	if (PlayerInfo[playerid][pShopTech] < 1)
	{
		SendClientMessageEx(playerid, COLOR_GREY, " You are not allowed to use this command.");
		return 1;
	}

	new giveplayerid, invoice;
	if(sscanf(params, "ui", giveplayerid, invoice)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /shoptable [player] [invoice #]");
	new string[128];

	if(PlayerInfo[giveplayerid][pTable] == 1)
	{
	    PlayerInfo[giveplayerid][pTable] = 0;
    	format(string, sizeof(string), "Your poker table has been taken by Shop Tech %s. ", GetPlayerNameEx(playerid));
		SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
		format(string, sizeof(string), "[SHOPPOKERTABLE] %s has taken %s(%d) poker table - Invoice %d", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), invoice);
		SendClientMessageEx(playerid, COLOR_GRAD1, string);
		Log("logs/shoplog.log", string);
	}
	else
	{
		PlayerInfo[giveplayerid][pTable] = 1;
    	format(string, sizeof(string), "You have been given a poker table from Shop Tech %s. ", GetPlayerNameEx(playerid));
		SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
		format(string, sizeof(string), "[SHOPPOKERTABLE] %s has given %s(%d) a poker table - Invoice %d", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), GetPlayerSQLId(giveplayerid), invoice);
		SendClientMessageEx(playerid, COLOR_GRAD1, string);
		Log("logs/shoplog.log", string);
	}
	return 1;
}