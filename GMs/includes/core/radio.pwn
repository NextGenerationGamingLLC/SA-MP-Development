/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Radio System

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

CMD:setstation(playerid, params[]) {
    if(!IsPlayerInAnyVehicle(playerid)) {
		return SendClientMessageEx(playerid, COLOR_GRAD2, "You must be in a car to use a car radio.");
	}
	ShowSetStation(playerid);
    return 1;
}

CMD:audiostopurl(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 4) {
    	if(IsValidDynamicArea(audiourlid))
    	{
	        new string[128];

	        //foreach(new i: Player)
			for(new i = 0; i < MAX_PLAYERS; ++i)
			{
				if(IsPlayerConnected(i))
				{
					if(IsPlayerInRangeOfPoint(i, audiourlparams[3], audiourlparams[0], audiourlparams[1], audiourlparams[2]))
					{
						StopAudioStreamForPlayerEx(i);
					}
				}	
	        }
	        DestroyDynamicArea(audiourlid);
	        format(string,sizeof(string),"{AA3333}AdmWarning{FFFF00}: %s has stopped the audiourl",GetPlayerNameEx(playerid));
	        ABroadCast(COLOR_YELLOW, string, 4);
		}
		else
		{
		    SendClientMessage(playerid, COLOR_WHITE, "There is no audiourl to stop");
		}
    }
    else {
        SendClientMessageEx(playerid, COLOR_GRAD1, "   You are not authorized to use that command !");
        return 1;
    }
    return 1;
}

CMD:audiourl(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 4) {

        new range;
        if(sscanf(params, "d", range)) {
            SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /audiourl [range].");
            return 1;
        }

        SetPVarInt(playerid, "aURLrange", range);
        ShowPlayerDialog(playerid, AUDIO_URL, DIALOG_STYLE_INPUT, "Audio URL", "Enter Audio URL", "OK", "Cancel");
    }
    else {
        SendClientMessageEx(playerid, COLOR_GRAD1, "   You are not authorized to use that command !");
        return 1;
    }
    return 1;
}

CMD:fixr(playerid, params[])
{
	PlayerFixRadio(playerid);
	return 1;
}

CMD:music(playerid, params[])
{
	if(PlayerInfo[playerid][pCDPlayer])
	{
		new choice[32];
		if(sscanf(params, "s[32]", choice))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /music [name]");
			SendClientMessageEx(playerid, COLOR_GREY, "Available names: On, Off, Next");
			return 1;
		}

		if(strcmp(choice,"on",true) == 0)
		{
			GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~g~Music person On", 5000, 5);
			new channel = Music[playerid];
			PlayerPlaySound(playerid, Songs[channel][0], 0.0, 0.0, 0.0);
		}
		else if(strcmp(choice,"off",true) == 0)
		{
			GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~r~Music person Off", 5000, 5);
			PlayerFixRadio(playerid);
			if(GetPVarType(playerid, "MusicIRadio"))
			{
			    StopAudioStreamForPlayerEx(playerid);
			    DeletePVar(playerid, "MusicIRadio");
			}
		}
		else if(strcmp(choice,"next",true) == 0)
		{
			if(Music[playerid] == 0) { Music[playerid] = 1; }
			else if(Music[playerid] == 1) { Music[playerid] = 2; }
			else if(Music[playerid] == 2) { Music[playerid] = 3; }
			else if(Music[playerid] == 3) { Music[playerid] = 4; }
			else if(Music[playerid] == 4) { Music[playerid] = 5; }
			else if(Music[playerid] == 5) { Music[playerid] = 6; }
			else if(Music[playerid] == 6) { Music[playerid] = 0; }
			new channel = Music[playerid];
			PlayerPlaySound(playerid, Songs[channel][0], 0.0, 0.0, 0.0);
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "   Unknown music command!");
			return 1;
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_GREY, "   You don't have a Music-Player!");
		return 1;
	}
	return 1;
}

CMD:mp3(playerid, params[])
{
	if(PlayerInfo[playerid][pCDPlayer] || PlayerInfo[playerid][pAdmin] >= 2)
	{
		if(IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, COLOR_GRAD2, "You must be on foot to use your MP3 Player.");
		
		ShowSetStation(playerid, "MP3 Player - Choose a station");
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD2, "You do not have a CD Player/MP3 Player.");
	return 1;
}	
