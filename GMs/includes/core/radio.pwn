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

#include <YSI\y_hooks>

stock SendAudioURLToRange(url[], Float:x, Float:y, Float:z, Float:range)
{
    audiourlid = CreateDynamicSphere(x, y, z, range);
	format(audiourlurl, sizeof(audiourlurl), "%s", url);
	audiourlparams[0] = x;
	audiourlparams[1] = y;
	audiourlparams[2] = z;
	audiourlparams[3] = range;
	return 1;
}

stock PlayerPlayMusic(playerid)
{
	if(IsPlayerConnected(playerid)) {
		SetTimer("StopMusic", 5000, 0);
		PlayerPlaySound(playerid, 1068, 0.0, 0.0, 0.0);
	}
}

stock PlayerFixRadio(playerid)
{
	if(IsPlayerConnected(playerid)) {
		SetTimer("PlayerFixRadio2", 1000, 0);
		PlayerPlaySound(playerid, 1068, 0.0, 0.0, 0.0);
		Fixr[playerid] = 1;
	}
}

forward RevisionListHTTP(index, response_code, data[]);
public RevisionListHTTP(index, response_code, data[])
{
	ShowPlayerDialogEx(index, DIALOG_REVISION, DIALOG_STYLE_LIST, "Current Version: "SERVER_GM_TEXT" -- View full changes at http://dev.ng-gaming.net", data, "Close", "");
	return 1;
}

forward StopMusic();
public StopMusic()
{
	foreach(new i: Player)
	{
		PlayerPlaySound(i, 1069, 0.0, 0.0, 0.0);
	}	
}

forward PlayerFixRadio2();
public PlayerFixRadio2()
{
	foreach(new i: Player)
	{
		if(Fixr[i])
		{
			PlayerPlaySound(i, 1069, 0.0, 0.0, 0.0);
			Fixr[i] = 0;
		}
	}	
}

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
		ShowPlayerDialogEx(index,TOP50LIST,DIALOG_STYLE_LIST,"Top 50 Stations",data,"Select", "Back");
	}
	return 1;
}

forward Top50InfoHTTP(index, response_code, data[]);
public Top50InfoHTTP(index, response_code, data[])
{
	DeletePVar(index, "pHTTPWait");
 	if(response_code == 200)
 	{
		ShowPlayerDialogEx(index,TOP50LISTEN,DIALOG_STYLE_MSGBOX,"Station Info",data,"Listen", "Back");
	}
	return 1;
}

forward GenreHTTP(index, response_code, data[]);
public GenreHTTP(index, response_code, data[])
{
	DeletePVar(index, "pHTTPWait");
 	if(response_code == 200)
 	{
		ShowPlayerDialogEx(index,GENRES,DIALOG_STYLE_LIST,"Genres",data,"Select", "Back");
	}
	return 1;
}

forward StationListHTTP(index, response_code, data[]);
public StationListHTTP(index, response_code, data[])
{
    DeletePVar(index, "pHTTPWait");
 	if(response_code == 200)
 	{
		ShowPlayerDialogEx(index,STATIONLIST,DIALOG_STYLE_LIST,"Stations",data,"Select", "Back");
	}
	return 1;
}

forward StationInfoHTTP(index, response_code, data[]);
public StationInfoHTTP(index, response_code, data[])
{
    DeletePVar(index, "pHTTPWait");
 	if(response_code == 200)
 	{
		ShowPlayerDialogEx(index,STATIONLISTEN,DIALOG_STYLE_MSGBOX,"Station Info",data,"Listen", "Back");
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
		ShowPlayerDialogEx(index,STATIONSEARCHLIST,DIALOG_STYLE_LIST,"Stations",data,"Select", "Back");
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
		ShowPlayerDialogEx(index,STATIONSEARCHLISTEN,DIALOG_STYLE_MSGBOX,"Station Info",data,"Listen", "Back");
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
	new string[256];
	format(string, sizeof(string), "Favorite Station\nGenres\nTop 50 Stations\nSearch\nK-LSR\nRadio New Robada\nNick's Radio\nCustom Audio URL\n%sTurn radio off", ((!isnull(PlayerInfo[playerid][pFavStation])) ? ("Favorite Station Settings\n") : ("")));
	return ShowPlayerDialogEx(playerid, SETSTATION, DIALOG_STYLE_LIST, title, string, "Select", "Close");
}

hook OnPlayerEnterDynamicArea(playerid, areaid) {

	//if(areaid == audiourlid) PlayAudioStreamForPlayerEx(playerid, audiourlurl, audiourlparams[0], audiourlparams[1], audiourlparams[2], audiourlparams[3], 1);
	if(areaid == GetGVarInt("MusicArea")) {
		PlayAudioStreamForPlayerEx(playerid, audiourlurl);
	}
}

hook OnPlayerLeaveDynamicArea(playerid, areaid) {

	//if(areaid == audiourlid) StopAudioStreamForPlayerEx(playerid);
	if(areaid == GetGVarInt("MusicArea")) StopAudioStreamForPlayerEx(playerid);
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	szMiscArray[0] = 0;
	if(dialogid == SETSTATION)
	{
		if(response)
		{
			if(listitem == 0)
			{
				if(isnull(PlayerInfo[playerid][pFavStation]))
				{
					if(GetPVarType(playerid, "pAudioStream")) ShowPlayerDialogEx(playerid, STATIONFAV, DIALOG_STYLE_MSGBOX, "Favorite Station", "You don't currently have a favorite station set.\n\nWould you like to set the one that is currently playing?", "Select", "Back");
					else ShowPlayerDialogEx(playerid, STATIONFAV2, DIALOG_STYLE_MSGBOX, "Favorite Station", "You don't currently have a favorite station set.\n\nPlease find a station and return to this menu to set a favorite station.", "Back", "");
				}
				else
				{
					if(IsPlayerInAnyVehicle(playerid))
					{
						foreach(new i: Player) 
						{
							if(GetPlayerVehicleID(i) != 0 && GetPlayerVehicleID(i) == GetPlayerVehicleID(playerid)) PlayAudioStreamForPlayerEx(i, PlayerInfo[playerid][pFavStation]);
						}
						format(stationidv[GetPlayerVehicleID(playerid)], 255, "%s", PlayerInfo[playerid][pFavStation]);
						format(szMiscArray, sizeof(szMiscArray), "* %s changes the radio station.", GetPlayerNameEx(playerid), szMiscArray);
						ProxDetector(10.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
					}
					else if(GetPVarType(playerid, "pBoomBox"))
					{
						foreach(new i: Player) 
						{
							if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "pBoomBoxArea"))) PlayAudioStreamForPlayerEx(i, PlayerInfo[playerid][pFavStation], GetPVarFloat(playerid, "pBoomBoxX"), GetPVarFloat(playerid, "pBoomBoxY"), GetPVarFloat(playerid, "pBoomBoxZ"), 30.0, 1);
						}	
						SetPVarString(playerid, "pBoomBoxStation", PlayerInfo[playerid][pFavStation]);
					}
					else
					{
						PlayAudioStreamForPlayerEx(playerid, PlayerInfo[playerid][pFavStation]);
						SetPVarInt(playerid, "MusicIRadio", 1);
					}
				}
			}
			if(listitem == 1)
			{
				if(!GetPVarType(playerid, "pHTTPWait"))
				{
					SetPVarInt(playerid, "pHTTPWait", 1);
					format(szMiscArray, sizeof(szMiscArray), "%s/radio/radio.php?listgenres=1", SAMP_WEB);
					HTTP(playerid, HTTP_GET, szMiscArray, "", "GenreHTTP");
				}
				else
				{
					SendClientMessage(playerid, 0xFFFFFFAA, "HTTP Thread is busy");
				}
			}
			else if(listitem == 2)
			{
				if(!GetPVarType(playerid, "pHTTPWait"))
				{
					SetPVarInt(playerid, "pHTTPWait", 1);
					format(szMiscArray, sizeof(szMiscArray), "%s/radio/radio.php?top50=1", SAMP_WEB);
					HTTP(playerid, HTTP_GET, szMiscArray, "", "Top50HTTP");
				}
				else
				{
					SendClientMessage(playerid, 0xFFFFFFAA, "HTTP Thread is busy");
				}
			}
			else if(listitem == 3)
			{
				ShowPlayerDialogEx(playerid,STATIONSEARCH,DIALOG_STYLE_INPUT,"Station Search","Input a search criteria:","Search","Back");
			}
			else if(listitem == 4)
			{
				if(IsPlayerInAnyVehicle(playerid))
				{
					foreach(new i: Player)
					{
						if(GetPlayerVehicleID(i) != 0 && GetPlayerVehicleID(i) == GetPlayerVehicleID(playerid)) {
							PlayAudioStreamForPlayerEx(i, "http://shoutcast.ng-gaming.net:8000/listen.pls?sid=1");
						}
					}	
					format(stationidv[GetPlayerVehicleID(playerid)], 64, "%s", "http://shoutcast.ng-gaming.net:8000/listen.pls?sid=1");
					format(szMiscArray, sizeof(szMiscArray), "* %s changes the radio station.", GetPlayerNameEx(playerid), szMiscArray);
					ProxDetector(10.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				}
				else if(GetPVarType(playerid, "pBoomBox"))
				{
					foreach(new i: Player)
					{
						if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "pBoomBoxArea")))
						{
							PlayAudioStreamForPlayerEx(i, "http://shoutcast.ng-gaming.net:8000/listen.pls?sid=1", GetPVarFloat(playerid, "pBoomBoxX"), GetPVarFloat(playerid, "pBoomBoxY"), GetPVarFloat(playerid, "pBoomBoxZ"), 30.0, 1);
						}
					}	
					SetPVarString(playerid, "pBoomBoxStation", "http://shoutcast.ng-gaming.net:8000/listen.pls?sid=1");
				}
				else
				{
					PlayAudioStreamForPlayerEx(playerid, "http://shoutcast.ng-gaming.net:8000/listen.pls?sid=1");
					SetPVarInt(playerid, "MusicIRadio", 1);
				}
			}
			else if(listitem == 5)
			{
				if(IsPlayerInAnyVehicle(playerid))
				{
					foreach(new i: Player)
					{
						if(GetPlayerVehicleID(i) != 0 && GetPlayerVehicleID(i) == GetPlayerVehicleID(playerid)) {
							PlayAudioStreamForPlayerEx(i, "https://radio.newrobada.com/radio/8000/autodj.mp3");
						}
					}	
					format(stationidv[GetPlayerVehicleID(playerid)], 64, "%s", "https://radio.newrobada.com/radio/8000/autodj.mp3");
					format(szMiscArray, sizeof(szMiscArray), "* %s changes the radio station.", GetPlayerNameEx(playerid), szMiscArray);
					ProxDetector(10.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				}
				else if(GetPVarType(playerid, "pBoomBox"))
				{
					foreach(new i: Player)
					{
						if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "pBoomBoxArea")))
						{
							PlayAudioStreamForPlayerEx(i, "https://radio.newrobada.com/radio/8000/autodj.mp3", GetPVarFloat(playerid, "pBoomBoxX"), GetPVarFloat(playerid, "pBoomBoxY"), GetPVarFloat(playerid, "pBoomBoxZ"), 30.0, 1);
						}
					}	
					SetPVarString(playerid, "pBoomBoxStation", "https://radio.newrobada.com/radio/8000/autodj.mp3");
				}
				else
				{
					PlayAudioStreamForPlayerEx(playerid, "https://radio.newrobada.com/radio/8000/autodj.mp3");
					SetPVarInt(playerid, "MusicIRadio", 1);
				}
			}
			else if(listitem == 6)
			{
				if(IsPlayerInAnyVehicle(playerid))
				{
					foreach(new i: Player)
					{
						if(GetPlayerVehicleID(i) != 0 && GetPlayerVehicleID(i) == GetPlayerVehicleID(playerid)) {
							PlayAudioStreamForPlayerEx(i, "http://nick.ng-gaming.net:8000/listen.pls");
						}
					}	
					format(stationidv[GetPlayerVehicleID(playerid)], 64, "%s", "http://nick.ng-gaming.net:8000/listen.pls");
					format(szMiscArray, sizeof(szMiscArray), "* %s changes the radio station.", GetPlayerNameEx(playerid), szMiscArray);
					ProxDetector(10.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				}
				else if(GetPVarType(playerid, "pBoomBox"))
				{
					foreach(new i: Player)
					{
						if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "pBoomBoxArea")))
						{
							PlayAudioStreamForPlayerEx(i, "http://nick.ng-gaming.net:8000/listen.pls", GetPVarFloat(playerid, "pBoomBoxX"), GetPVarFloat(playerid, "pBoomBoxY"), GetPVarFloat(playerid, "pBoomBoxZ"), 30.0, 1);
						}
					}	
					SetPVarString(playerid, "pBoomBoxStation", "http://nick.ng-gaming.net:8000/listen.pls");
				}
				else
				{
					PlayAudioStreamForPlayerEx(playerid, "http://nick.ng-gaming.net:8000/listen.pls");
					SetPVarInt(playerid, "MusicIRadio", 1);
				}
			}
			else if(listitem == 7)
			{
				ShowPlayerDialogEx(playerid, CUSTOM_URLCHOICE, DIALOG_STYLE_INPUT, "Custom URL", "Please insert a valid audio url stream.", "Enter", "Back");
			}
			else if(!isnull(PlayerInfo[playerid][pFavStation]) && listitem == 8)
			{
				ShowPlayerDialogEx(playerid, STATIONFAVSETTING, DIALOG_STYLE_LIST, "Favorite Station Settings", "Modify Station\nRemove Station", "Select", "Back");
			}
			else if((isnull(PlayerInfo[playerid][pFavStation]) && listitem == 8) || (!isnull(PlayerInfo[playerid][pFavStation]) && listitem == 9))
			{
				if(!IsPlayerInAnyVehicle(playerid))
				{
					if(GetPVarType(playerid, "pBoomBox"))
					{
						SendClientMessage(playerid, COLOR_WHITE, "You have turned off the boom box.");
						new Float:playerPos[3];
						GetPlayerPos(playerid, playerPos[0], playerPos[1], playerPos[2]);
						foreach(new i: Player)
						{						
							if(IsPlayerInRangeOfPoint(i, 35, playerPos[0], playerPos[1], playerPos[2])) StopAudioStreamForPlayerEx(i);
						}
						DeletePVar(playerid, "pBoomBoxStation");
					}
					else
					{
						StopAudioStreamForPlayerEx(playerid);
					}
				}
				else
				{
					format(szMiscArray, sizeof(szMiscArray), "* %s turns off the radio.", GetPlayerNameEx(playerid), szMiscArray);
					ProxDetector(10.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
					foreach(new i: Player)
					{
						if(GetPlayerVehicleID(i) == GetPlayerVehicleID(playerid)) {
							StopAudioStreamForPlayerEx(i);
						}
					}	
					stationidv[GetPlayerVehicleID(playerid)][0] = 0;
				}
			}
		}
	}
	else if(dialogid == CUSTOM_URLCHOICE)
	{
		if(response)
		{
			if(isnull(inputtext) || IsNumeric(inputtext)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You have not entered a valid URL.");
			if(IsPlayerInAnyVehicle(playerid))
			{
				foreach(new i: Player)
				{
					if(GetPlayerVehicleID(i) != 0 && GetPlayerVehicleID(i) == GetPlayerVehicleID(playerid))
					{
						PlayAudioStreamForPlayerEx(i, inputtext);
						Log("logs/radiourl.log", inputtext);
					}
				}
				format(stationidv[GetPlayerVehicleID(playerid)], 64, "%s", inputtext);
				format(szMiscArray, sizeof(szMiscArray), "* %s changes the radio station.", GetPlayerNameEx(playerid));
				ProxDetector(10.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				DeletePVar(playerid, "pSelectGenre");
				DeletePVar(playerid, "pSelectStation");
			}
			else if(GetPVarType(playerid, "pBoomBox"))
			{
				foreach(new i: Player) 
				{
					if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "pBoomBoxArea")))
					{
						PlayAudioStreamForPlayerEx(i, inputtext, GetPVarFloat(playerid, "pBoomBoxX"), GetPVarFloat(playerid, "pBoomBoxY"), GetPVarFloat(playerid, "pBoomBoxZ"), 30.0, 1);
					}
				}
				SetPVarString(playerid, "pBoomBoxStation", inputtext);
			}
			else
			{
				PlayAudioStreamForPlayerEx(playerid, inputtext);
				SetPVarInt(playerid, "MusicIRadio", 1);
				//format(szMiscArray, sizeof(szMiscArray), "You are now playing %s", inputtext);
				//SendClientMessageEx(playerid, COLOR_GREEN, szMiscArray);
			}
		}
		else
		{
			ShowSetStation(playerid);
		}
	}		
	else if(dialogid == GENRES)
	{
		if(response)
		{
			if(!GetPVarType(playerid, "pHTTPWait"))
			{
				format(szMiscArray, sizeof(szMiscArray), "%s/radio/radio.php?genre=%d", SAMP_WEB, (listitem+1));
				SetPVarInt(playerid, "pSelectGenre", (listitem+1));
				SetPVarInt(playerid, "pHTTPWait", 1);
				HTTP(playerid, HTTP_GET, szMiscArray, "", "StationListHTTP");
			}
			else
			{
				SendClientMessage(playerid, 0xFFFFFFAA, "HTTP Thread is busy");
			}
		}
		else
		{
			ShowSetStation(playerid);
			DeletePVar(playerid, "pSelectGenre");
		}
	}
	else if(dialogid == STATIONLIST)
	{
		if(response)
		{
			if(!GetPVarType(playerid, "pHTTPWait"))
			{
				format(szMiscArray, sizeof(szMiscArray), "%s/radio/radio.php?genre=%d&station=%d", SAMP_WEB, GetPVarInt(playerid, "pSelectGenre"), (listitem+1));
				SetPVarInt(playerid, "pHTTPWait", 1);
				SetPVarInt(playerid, "pSelectStation", (listitem+1));
				HTTP(playerid, HTTP_GET, szMiscArray, "", "StationInfoHTTP");
			}
			else
			{
				SendClientMessage(playerid, 0xFFFFFFAA, "HTTP Thread is busy");
			}
		}
		else
		{
			if(!GetPVarType(playerid, "pHTTPWait"))
			{
				SetPVarInt(playerid, "pHTTPWait", 1);
				format(szMiscArray, sizeof(szMiscArray), "%s/radio/radio.php?listgenres=1", SAMP_WEB);
				HTTP(playerid, HTTP_GET, szMiscArray, "", "GenreHTTP");
			}
			else
			{
				SendClientMessage(playerid, 0xFFFFFFAA, "HTTP Thread is busy");
			}
		}
	}
	else if(dialogid == TOP50LIST)
	{
		if(!response)
		{
			ShowSetStation(playerid);
		}
		else
		{
			if(!GetPVarType(playerid, "pHTTPWait"))
			{
				format(szMiscArray, sizeof(szMiscArray), "%s/radio/radio.php?top50=1&station=%d", SAMP_WEB, (listitem+1));
				SetPVarInt(playerid, "pHTTPWait", 1);
				SetPVarInt(playerid, "pSelectStation", (listitem+1));
				HTTP(playerid, HTTP_GET, szMiscArray, "", "Top50InfoHTTP");
			}
			else
			{
				SendClientMessage(playerid, 0xFFFFFFAA, "HTTP Thread is busy");
			}
		}
	}
	else if(dialogid == STATIONLISTEN)
	{
		if(response)
		{
			if(!GetPVarType(playerid, "pHTTPWait"))
			{
				format(szMiscArray, sizeof(szMiscArray), "%s/radio/radio.php?genre=%d&station=%d&listen=1", SAMP_WEB, GetPVarInt(playerid, "pSelectGenre"), GetPVarInt(playerid, "pSelectStation"));
				SetPVarInt(playerid, "pHTTPWait", 1);
				HTTP(playerid, HTTP_GET, szMiscArray, "", "StationSelectHTTP");
			}
			else
			{
				SendClientMessage(playerid, 0xFFFFFFAA, "HTTP Thread is busy");
			}
		}
		else
		{
			if(!GetPVarType(playerid, "pHTTPWait"))
			{
				format(szMiscArray, sizeof(szMiscArray), "%s/radio/radio.php?genre=%d", SAMP_WEB, GetPVarInt(playerid, "pSelectGenre"));
				SetPVarInt(playerid, "pHTTPWait", 1);
				HTTP(playerid, HTTP_GET, szMiscArray, "", "StationListHTTP");
				DeletePVar(playerid, "pSelectStation");
			}
			else
			{
				SendClientMessage(playerid, 0xFFFFFFAA, "HTTP Thread is busy");
			}
		}
	}
	else if(dialogid == TOP50LISTEN)
	{
		if(!response)
		{
			if(!GetPVarType(playerid, "pHTTPWait"))
			{
				DeletePVar(playerid, "pSelectStation");
				SetPVarInt(playerid, "pHTTPWait", 1);
				format(szMiscArray, sizeof(szMiscArray), "%s/radio/radio.php?top50=1", SAMP_WEB);
				HTTP(playerid, HTTP_GET, szMiscArray, "", "Top50HTTP");
			}
			else
			{
				SendClientMessage(playerid, 0xFFFFFFAA, "HTTP Thread is busy");
			}
		}
		else
		{
			if(!GetPVarType(playerid, "pHTTPWait"))
			{
				format(szMiscArray, sizeof(szMiscArray), "%s/radio/radio.php?top50=1&station=%d&listen=1", SAMP_WEB, GetPVarInt(playerid, "pSelectStation"));
				SetPVarInt(playerid, "pHTTPWait", 1);
				HTTP(playerid, HTTP_GET, szMiscArray, "", "StationSelectHTTP");
			}
			else
			{
				SendClientMessage(playerid, 0xFFFFFFAA, "HTTP Thread is busy");
			}
		}
	}
	else if(dialogid == STATIONSEARCH)
	{
		if(response)
		{
			if(strlen(inputtext) < 0 || strlen(inputtext) > 64)
			{
				ShowSetStation(playerid);
			}
			else
			{
				if(!GetPVarType(playerid, "pHTTPWait"))
				{
					format(szMiscArray, sizeof(szMiscArray), "%s/radio/radio.php?search=%s", SAMP_WEB, inputtext);
					SetPVarString(playerid, "pSearchStation", inputtext);
					SetPVarInt(playerid, "pHTTPWait", 1);
					ShowNoticeGUIFrame(playerid, 6);
					HTTP(playerid, HTTP_GET, szMiscArray, "", "StationSearchHTTP");
				}
				else
				{
					SendClientMessage(playerid, 0xFFFFFFAA, "HTTP Thread is busy");
				}
			}
		}
		else
		{
			ShowSetStation(playerid);
		}
	}
	else if(dialogid == STATIONSEARCHLIST)
	{
		if(response)
		{
			if(!GetPVarType(playerid, "pHTTPWait"))
			{
				GetPVarString(playerid, "pSearchStation", szMiscArray, sizeof(szMiscArray));
				format(szMiscArray, sizeof(szMiscArray), "%s/radio/radio.php?search=%s&station=%d", SAMP_WEB, szMiscArray, (listitem+1));
				SetPVarInt(playerid, "pHTTPWait", 1);
				ShowNoticeGUIFrame(playerid, 6);
				SetPVarInt(playerid, "pSelectStation", (listitem+1));
				HTTP(playerid, HTTP_GET, szMiscArray, "", "StationSearchInfoHTTP");
			}
			else
			{
				SendClientMessage(playerid, 0xFFFFFFAA, "HTTP Thread is busy");
			}
		}
		else
		{
			ShowSetStation(playerid);
		}
	}
	else if(dialogid == STATIONSEARCHLISTEN)
	{
		if(response)
		{
			if(!GetPVarType(playerid, "pHTTPWait"))
			{
				GetPVarString(playerid, "pSearchStation", szMiscArray, sizeof(szMiscArray));
				format(szMiscArray, sizeof(szMiscArray), "%s/radio/radio.php?search=%s&station=%d&listen=1", SAMP_WEB, szMiscArray, GetPVarInt(playerid, "pSelectStation"));
				SetPVarInt(playerid, "pHTTPWait", 1);
				ShowNoticeGUIFrame(playerid, 6);
				HTTP(playerid, HTTP_GET, szMiscArray, "", "StationSelectHTTP");
			}
			else
			{
				SendClientMessage(playerid, 0xFFFFFFAA, "HTTP Thread is busy");
			}
		}
		else
		{
			if(!GetPVarType(playerid, "pHTTPWait"))
			{
				GetPVarString(playerid, "pSearchStation", szMiscArray, sizeof(szMiscArray));
				format(szMiscArray, sizeof(szMiscArray), "%s/radio/radio.php?search=%s", SAMP_WEB, szMiscArray);
				ShowNoticeGUIFrame(playerid, 6);
				HTTP(playerid, HTTP_GET, szMiscArray, "", "StationSearchHTTP");
				DeletePVar(playerid, "pSelectStation");
			}
			else
			{
				SendClientMessage(playerid, 0xFFFFFFAA, "HTTP Thread is busy");
			}
		}
	}
	else if(dialogid == STATIONFAV)
	{
		if(response)
		{
			GetPVarString(playerid, "pAudioStream", PlayerInfo[playerid][pFavStation], 255);
			SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully set your favorite station.");
		}
		else ShowSetStation(playerid);
	}
	else if(dialogid == STATIONFAV2)
	{
		ShowSetStation(playerid);
	}
	else if(dialogid == STATIONFAVSETTING)
	{
		switch(listitem)
		{
			case 0:
			{
				GetPVarString(playerid, "pAudioStream", PlayerInfo[playerid][pFavStation], 255);
				ShowPlayerDialogEx(playerid, STATIONFAVMODIFY, DIALOG_STYLE_MSGBOX, "Favorite Station", "You have successfully modified your favorite station!", "Go Back", "Exit");
			}
			case 1:
			{
				strcat((PlayerInfo[playerid][pFavStation][0] = 0, PlayerInfo[playerid][pFavStation]), "", 8);
				ShowPlayerDialogEx(playerid, STATIONREMOVE, DIALOG_STYLE_MSGBOX, "Favorite Station", "You have successfully removed your favorite station!", "Go Back", "Exit");
			}
		}
		if(!response) ShowSetStation(playerid);
	}
	else if(dialogid == STATIONFAVMODIFY)
	{
		if(response) ShowPlayerDialogEx(playerid, STATIONFAVSETTING, DIALOG_STYLE_LIST, "Favorite Station Settings", "Modify Station\nRemove Station", "Select", "Back");
	}
	else if(dialogid == STATIONREMOVE)
	{
		if(response) ShowSetStation(playerid);
	}
	return 0;
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
    if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1) {
    	if(IsValidDynamicArea(GetGVarInt("MusicArea")))
    	{
	        new string[128];

	        foreach(new i: Player)
			{
				StopAudioStreamForPlayerEx(i);
			}
			DestroyDynamicArea(GetGVarInt("MusicArea"));
			DeleteGVar("MusicArea");
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
    if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1) {

        new range;
        if(sscanf(params, "d", range)) {
            SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /audiourl [range].");
            return 1;
        }

        SetPVarInt(playerid, "aURLrange", range);
        ShowPlayerDialogEx(playerid, AUDIO_URL, DIALOG_STYLE_INPUT, "Audio URL", "Enter Audio URL", "OK", "Cancel");
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
