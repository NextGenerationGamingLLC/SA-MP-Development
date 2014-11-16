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