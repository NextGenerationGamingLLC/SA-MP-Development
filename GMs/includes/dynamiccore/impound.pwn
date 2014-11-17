/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

					Dynamic Impound System 

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

CMD:impoundedit(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pFactionModerator] >= 1)
	{
		new string[128], choice[32], id, amount;
		if(sscanf(params, "s[32]dD", choice, id, amount))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /impoundedit [name] [id] [amount]");
			SendClientMessageEx(playerid, COLOR_GREY, "Available names: Position, Delete");
			return 1;
		}

		if(id >= MAX_IMPOUNDPOINTS)
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "Invalid Impound Points ID!");
			return 1;
		}

		if(strcmp(choice, "position", true) == 0)
		{
			GetPlayerPos(playerid, ImpoundPoints[id][impoundPosX], ImpoundPoints[id][impoundPosY], ImpoundPoints[id][impoundPosZ]);
			ImpoundPoints[id][impoundInt] = GetPlayerInterior(playerid);
			ImpoundPoints[id][impoundVW] = GetPlayerVirtualWorld(playerid);
			format(string, sizeof(string), "You have changed the position on impound Point #%d.", id);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			DestroyDynamic3DTextLabel(ImpoundPoints[id][impoundTextID]);
			format(string, sizeof(string), "Impound Yard #%d\nType /impound to impound a vehicle", id);
			ImpoundPoints[id][impoundTextID] = CreateDynamic3DTextLabel(string, COLOR_YELLOW, ImpoundPoints[id][impoundPosX], ImpoundPoints[id][impoundPosY], ImpoundPoints[id][impoundPosZ]+0.6, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, ImpoundPoints[id][impoundVW], ImpoundPoints[id][impoundInt], -1);
			SaveImpoundPoint(id);
			format(string, sizeof(string), "%s has edited Impound Point ID %d's position.", GetPlayerNameEx(playerid), id);
			Log("logs/impoundedit.log", string);
			return 1;
		}
		else if(strcmp(choice, "delete", true) == 0)
		{
			if(ImpoundPoints[id][impoundPosX] == 0)
			{
				format(string, sizeof(string), "Impound Point #%d does not exist.", id);
				SendClientMessageEx(playerid, COLOR_WHITE, string);
				return 1;
			}
			DestroyDynamic3DTextLabel(ImpoundPoints[id][impoundTextID]);
			ImpoundPoints[id][impoundPosX] = 0.0;
			ImpoundPoints[id][impoundPosY] = 0.0;
			ImpoundPoints[id][impoundPosZ] = 0.0;
			ImpoundPoints[id][impoundVW] = 0;
			ImpoundPoints[id][impoundInt] = 0;
			SaveImpoundPoint(id);
			format(string, sizeof(string), "You have deleted Impound Point #%d.", id);
			SendClientMessageEx(playerid, COLOR_WHITE, string);
			format(string, sizeof(string), "%s has deleted Impound Point ID %d.", GetPlayerNameEx(playerid), id);
			Log("logs/impoundedit.log", string);
			return 1;
		}
	}
	else SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	return 1;
}

CMD:impoundstatus(playerid, params[])
{
	new id;
	if(sscanf(params, "i", id))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /impoundstatus [id]");
		return 1;
	}
	if (PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pFactionModerator] >= 1)
	{
		new string[128];
		format(string,sizeof(string),"|___________ Impound Point Status (ID: %d) ___________|", id);
		SendClientMessageEx(playerid, COLOR_GREEN, string);
		format(string, sizeof(string), "[Position] X: %f | Y: %f | Z: %f | VW: %d | Int: %d", ImpoundPoints[id][impoundPosX], ImpoundPoints[id][impoundPosY], ImpoundPoints[id][impoundPosZ], ImpoundPoints[id][impoundVW], ImpoundPoints[id][impoundInt]);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use that command.");
	}
	return 1;
}

CMD:impoundnext(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pFactionModerator] == 2)
	{
		SendClientMessageEx(playerid, COLOR_RED, "* Listing next available Impound Point...");
		for(new x = 0; x < MAX_IMPOUNDPOINTS; x++)
		{
			if(ImpoundPoints[x][impoundPosX] == 0)
		    {
		        new string[128];
		        format(string, sizeof(string), "%d is available to use.", x);
		        SendClientMessageEx(playerid, COLOR_WHITE, string);
		        break;
			}
		}
	}
	else
	{
	    SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use that command.");
		return 1;
	}
	return 1;
}

CMD:gotoimpoundpoint(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pFactionModerator] >= 1)
	{
		new id;
		if(sscanf(params, "d", id)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /gotoimpoundpoint [id]");

		SetPlayerPos(playerid, ImpoundPoints[id][impoundPosX], ImpoundPoints[id][impoundPosY], ImpoundPoints[id][impoundPosZ]);
		SetPlayerInterior(playerid, ImpoundPoints[id][impoundInt]);
		PlayerInfo[playerid][pInt] = ImpoundPoints[id][impoundInt];
		SetPlayerVirtualWorld(playerid, ImpoundPoints[id][impoundVW]);
		PlayerInfo[playerid][pVW] = ImpoundPoints[id][impoundVW];
	}
	return 1;
}