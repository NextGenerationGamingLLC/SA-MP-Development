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

stock PlayAudioStreamForPlayerEx(playerid, url[], Float:posX = 0.0, Float:posY = 0.0, Float:posZ = 0.0, Float:distance = 50.0, usepos = 0)
{
	if(GetPVarType(playerid, "pAudioStream"))
	{
		SetPVarString(playerid, "pAudioStream", url);
		StopAudioStreamForPlayerEx(playerid, 1);
	}
	else SetPVarString(playerid, "pAudioStream", url);
    PlayAudioStreamForPlayer(playerid, url, posX, posY, posZ, distance, usepos);
}

stock StopAudioStreamForPlayerEx(playerid, reset = 0)
{
	if(reset == 0) DeletePVar(playerid, "pAudioStream");
    StopAudioStreamForPlayer(playerid);
}

forward Top50HTTP(index, response_code, data[]);
public Top50HTTP(index, response_code, data[])
{
	DeletePVar(index, "pHTTPWait");
 	if(response_code == 200)
 	{
		ShowPlayerDialog(index,TOP50LIST,DIALOG_STYLE_LIST,"Top 50 Stations",data,"Select", "Back");
	}
	return 1;
}

forward Top50InfoHTTP(index, response_code, data[]);
public Top50InfoHTTP(index, response_code, data[])
{
	DeletePVar(index, "pHTTPWait");
 	if(response_code == 200)
 	{
		ShowPlayerDialog(index,TOP50LISTEN,DIALOG_STYLE_MSGBOX,"Station Info",data,"Listen", "Back");
	}
	return 1;
}

forward GenreHTTP(index, response_code, data[]);
public GenreHTTP(index, response_code, data[])
{
	DeletePVar(index, "pHTTPWait");
 	if(response_code == 200)
 	{
		ShowPlayerDialog(index,GENRES,DIALOG_STYLE_LIST,"Genres",data,"Select", "Back");
	}
	return 1;
}

forward StationListHTTP(index, response_code, data[]);
public StationListHTTP(index, response_code, data[])
{
    DeletePVar(index, "pHTTPWait");
 	if(response_code == 200)
 	{
		ShowPlayerDialog(index,STATIONLIST,DIALOG_STYLE_LIST,"Stations",data,"Select", "Back");
	}
	return 1;
}

forward StationInfoHTTP(index, response_code, data[]);
public StationInfoHTTP(index, response_code, data[])
{
    DeletePVar(index, "pHTTPWait");
 	if(response_code == 200)
 	{
		ShowPlayerDialog(index,STATIONLISTEN,DIALOG_STYLE_MSGBOX,"Station Info",data,"Listen", "Back");
	}
	return 1;
}

forward StationSearchHTTP(index, response_code, data[]);
public StationSearchHTTP(index, response_code, data[])
{
    DeletePVar(index, "pHTTPWait");
    HideNoticeGUIFrame(index);
 	if(response_code == 200)
 	{
		ShowPlayerDialog(index,STATIONSEARCHLIST,DIALOG_STYLE_LIST,"Stations",data,"Select", "Back");
	}
	return 1;
}

forward StationSearchInfoHTTP(index, response_code, data[]);
public StationSearchInfoHTTP(index, response_code, data[])
{
    DeletePVar(index, "pHTTPWait");
    HideNoticeGUIFrame(index);
 	if(response_code == 200)
 	{
		ShowPlayerDialog(index,STATIONSEARCHLISTEN,DIALOG_STYLE_MSGBOX,"Station Info",data,"Listen", "Back");
	}
	return 1;
}

forward StationSelectHTTP(index, response_code, data[]);
public StationSelectHTTP(index, response_code, data[])
{
    DeletePVar(index, "pHTTPWait");
    HideNoticeGUIFrame(index);
 	if(response_code == 200)
 	{
		if(IsPlayerInAnyVehicle(index))
		{
	 	    foreach(new i: Player)
			{
				if(GetPlayerVehicleID(i) != 0 && GetPlayerVehicleID(i) == GetPlayerVehicleID(index)) {
					PlayAudioStreamForPlayerEx(i, data);
				}
			}	
		  	format(stationidv[GetPlayerVehicleID(index)], 64, "%s", data);
		  	new string[53];
		  	format(string, sizeof(string), "* %s changes the radio station.", GetPlayerNameEx(index), string);
			ProxDetector(10.0, index, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	        DeletePVar(index, "pSelectGenre");
	        DeletePVar(index, "pSelectStation");
		}
		else if(GetPVarType(index, "pBoomBox"))
		{
		    foreach(new i: Player)
			{
				if(IsPlayerInDynamicArea(i, GetPVarInt(index, "pBoomBoxArea")))
				{
					PlayAudioStreamForPlayerEx(i, data, GetPVarFloat(index, "pBoomBoxX"), GetPVarFloat(index, "pBoomBoxY"), GetPVarFloat(index, "pBoomBoxZ"), 30.0, 1);
				}
			}	
		  	SetPVarString(index, "pBoomBoxStation", data);
		}
		else
		{
		    PlayAudioStreamForPlayerEx(index, data);
		    SetPVarInt(index, "MusicIRadio", 1);
		}
	}
	return 1;
}

stock ShowSetStation(playerid, title[] = "Radio Menu")
{
	new string[128];
	format(string, sizeof(string), "Favorite Station\nGenres\nTop 50 Stations\nSearch\nK-LSR\nNick's Radio\nCustom Audio URL\n%sTurn radio off", ((!isnull(PlayerInfo[playerid][pFavStation])) ? ("Favorite Station Settings\n") : ("")));
	return ShowPlayerDialog(playerid, SETSTATION, DIALOG_STYLE_LIST, title, string, "Select", "Close");
}

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

	        foreach(new i: Player)
			{
				if(IsPlayerInRangeOfPoint(i, audiourlparams[3], audiourlparams[0], audiourlparams[1], audiourlparams[2]))
				{
					StopAudioStreamForPlayerEx(i);
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
