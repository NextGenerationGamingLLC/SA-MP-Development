/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						News Group Type

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
stock IsANewsCar(carid)
{
	if(DynVeh[carid] != -1)
	{
	    new iDvSlotID = DynVeh[carid], iGroupID = DynVehicleInfo[iDvSlotID][gv_igID];
	    if((0 <= iGroupID < MAX_GROUPS))
	    {
	    	if(arrGroupData[iGroupID][g_iGroupType] == GROUP_TYPE_NEWS) return 1;
		}
	}
	return 0;
}

stock OOCNews(color, string[])
{
	foreach(new i: Player) {
		
		ChatTrafficProcess(i, color, string, 1);
	}	
}


CMD:tognews(playerid, params[])
{
	if (!gNews[playerid])
	{
		gNews[playerid] = 1;
		PlayerInfo[playerid][pToggledChats][1] = 1;
		SendClientMessageEx(playerid, COLOR_GRAD2, "You have disabled news chat.");
	}
	else
	{
		gNews[playerid] = 0;
		PlayerInfo[playerid][pToggledChats][1] = 0;
		SendClientMessageEx(playerid, COLOR_GRAD2, "You have enabled news chat.");
	}
	return 1;
}

CMD:liveban(playerid, params[])
{
	if (IsAReporter(playerid))
	{
	    new giveplayerid,
	        string[128];

	    if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /liveban [player]");
		if(!IsPlayerConnected(giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "That player is not connected.");
	    if(PlayerInfo[giveplayerid][pLiveBanned] == 0)
	    {
	        PlayerInfo[giveplayerid][pLiveBanned] = 1;
	        format(string, sizeof(string), "%s has interview banned %s", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
	        SendGroupMessage(GROUP_TYPE_NEWS, RADIO, string);
	        return 1;
	    }
	    else SendClientMessageEx(playerid, COLOR_WHITE, "That player is already live banned.");
	}
	return 1;
}

CMD:liveunban(playerid, params[])
{
	new string[128],
		giveplayerid;
		
	if(IsAReporter(playerid) && PlayerInfo[playerid][pRank] >= 7)
	{
		if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /liveban [player]");
		if(!IsPlayerConnected(giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "That player is not connected.");
		if(PlayerInfo[giveplayerid][pLiveBanned] == 1)
		{
			PlayerInfo[giveplayerid][pLiveBanned] = 0;
			format(string, sizeof(string), "%s has unbanned %s from interviews", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
			SendGroupMessage(GROUP_TYPE_NEWS, RADIO, string);
		}
		else SendClientMessageEx(playerid, COLOR_WHITE, "That player is currently not live banned");
	}
	else SendClientMessageEx(playerid, COLOR_WHITE, "You must be at least Rank 7 to use this command");
	
	return 1;
}


CMD:live(playerid, params[])
{
	if(IsAReporter(playerid) && PlayerInfo[playerid][pRank] > 0)
	{
	    if(shutdown == 1) return SendClientMessageEx(playerid, COLOR_WHITE, "The news system is currently shut down." );
		if(TalkingLive[playerid] != INVALID_PLAYER_ID)
		{
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Live conversation ended.");
			SendClientMessageEx(TalkingLive[playerid], COLOR_LIGHTBLUE, "* Live conversation ended.");
			TogglePlayerControllable(playerid, 1);
			TogglePlayerControllable(TalkingLive[playerid], 1);
			DeletePVar(playerid, "IsLive");
			DeletePVar(TalkingLive[playerid], "IsLive");
			TalkingLive[TalkingLive[playerid]] = INVALID_PLAYER_ID;
			TalkingLive[playerid] = INVALID_PLAYER_ID;
			return 1;
		}

		new string[128], giveplayerid;
		if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /live [player]");

		if (IsPlayerConnected(giveplayerid))
		{
			if (ProxDetectorS(5.0, playerid, giveplayerid))
			{
			    if(PlayerInfo[giveplayerid][pLiveBanned] == 1) return SendClientMessageEx(playerid, COLOR_GREY, "That person is interview banned.");
				if(PlayerCuffed[giveplayerid] >= 1 || PlayerCuffed[playerid] >= 1)
				{
					SendClientMessageEx(playerid, COLOR_GRAD2, "You are unable to do this right now.");
				}
				else
				{
					if(giveplayerid == playerid) { SendClientMessageEx(playerid, COLOR_GREY, "You cannot talk live with yourself!"); return 1; }
					format(string, sizeof(string), "* You offered %s to have a live conversation.", GetPlayerNameEx(giveplayerid));
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
					format(string, sizeof(string), "* %s offered you to have a live conversation, type /accept live to accept.", GetPlayerNameEx(playerid));
					SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
					LiveOffer[giveplayerid] = playerid;
				}
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GREY, "That person isn't near you.");
				return 1;
			}

		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");
			return 1;
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREY, "   You are not a News Reporter!");
	}
	return 1;
}
