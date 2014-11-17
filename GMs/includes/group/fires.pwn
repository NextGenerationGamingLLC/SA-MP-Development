/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Fire System

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

CMD:fires(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pGangModerator] < 1 && PlayerInfo[playerid][pFactionModerator] < 1) return 1;
	if(GetPVarInt(playerid, "FireStart") != 1)
	{
		SetPVarInt(playerid, "FireStart", 1);
		SendClientMessageEx(playerid, COLOR_GREY, "You are now in fire creation mode");
		SendClientMessageEx(playerid, COLOR_GREY, "Please use a weapon and shoot whereever you wish to create a fire");
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You have exited fire creation mode and are no longer able to create fires");
		DeletePVar(playerid, "FireStart");
	}
	return 1;
}

CMD:destroyfire(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pGangModerator] < 1 && PlayerInfo[playerid][pFactionModerator] < 1) return 1;
	new fire;
	if(sscanf(params, "d", fire)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /destroyfire [fireid]");
	if(!(0 <= fire <= MAX_STRUCTURE_FIRES)) return SendClientMessageEx(playerid, COLOR_GREY, "Invalid Fire ID!");
	if(arrStructureFires[fire][fFirePos][0] == 0) return SendClientMessageEx(playerid, COLOR_GREY, "Fire has not been created!");
	DeleteStructureFire(fire);
	return 1;
}

CMD:destroyfires(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pGangModerator] < 2 && PlayerInfo[playerid][pFactionModerator] < 2) return 1;
	for(new i; i < MAX_STRUCTURE_FIRES; i++)
	{
		DeleteStructureFire(i);
	}
	return 1;
}

CMD:gotofire(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pGangModerator] < 1 && PlayerInfo[playerid][pFactionModerator] < 1) return 1;
	new fire;
	if(sscanf(params, "d", fire)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /gotofire [fireid]");
	if(!(0 <= fire <= MAX_STRUCTURE_FIRES)) return SendClientMessageEx(playerid, COLOR_GREY, "Invalid Fire ID!");
	if(arrStructureFires[fire][fFirePos][0] == 0) return SendClientMessageEx(playerid, COLOR_GREY, "Fire has not been created!");
	SetPlayerPos(playerid, arrStructureFires[fire][fFirePos][0], arrStructureFires[fire][fFirePos][1], arrStructureFires[fire][fFirePos][2]);
	return 1;
}

CMD:setfstrength(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4 && PlayerInfo[playerid][pGangModerator] < 1 && PlayerInfo[playerid][pFactionModerator] < 1) return 1;
	new fire, strength;
	if(sscanf(params, "dd", fire, strength)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /setfstrength [fireid] [strength]");
	if(!(0 <= fire <= MAX_STRUCTURE_FIRES)) return SendClientMessageEx(playerid, COLOR_GREY, "Invalid Fire ID!");
	arrStructureFires[fire][iFireStrength] = strength;
	return 1;
}
