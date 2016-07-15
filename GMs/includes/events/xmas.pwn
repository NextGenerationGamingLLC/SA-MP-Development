/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Xmas Holidays Events

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

CMD:carol(playerid, params[]) // Christmas Event
{
	new year, month, day, string[256], cstring[32];
	getdate(year, month, day);
	if(month == 12 && day == 24)
	{
		if(PlayerInfo[playerid][pConnectHours] > 2)
		{
			for(new i = 0; i < sizeof(HouseInfo); i++)
			{
				if (IsPlayerInRangeOfPoint(playerid,3,HouseInfo[i][hExteriorX], HouseInfo[i][hExteriorY], HouseInfo[i][hExteriorZ]))
				{
					if(PlayerInfo[playerid][pTrickortreat] == 0)
					{
						GiftPlayer(MAX_PLAYERS, playerid);
						switch(PlayerInfo[playerid][pDonateRank])
						{
							case 0, 1: PlayerInfo[playerid][pTrickortreat] = 5;
							case 2: PlayerInfo[playerid][pTrickortreat] = 4;
							case 3: PlayerInfo[playerid][pTrickortreat] = 3;
							case 4: PlayerInfo[playerid][pTrickortreat] = 2;
							case 5: PlayerInfo[playerid][pTrickortreat] = 2;
						}

						new rand = Random(1, 5);
						switch(rand)
						{
							case 1: cstring = "Deck the Halls";
							case 2: cstring = "We Wish You a Merry Christmas";
							case 3: cstring = "Jingle Bells";
							case 4: cstring = "Jingle Bells Rock";
							case 5: cstring = "Silent Night";
							default: cstring = "Deck the Halls";
						}

						format(string, sizeof(string), "* %s begins to sing the Christmas Carol %s.",GetPlayerNameEx(playerid), cstring);
						ProxDetector(30.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
						return 1;
					}
					else
					{
						if(GetPVarInt(playerid, "PinConfirmed"))
						{
							format(string, sizeof(string),"Item: Reset Caroling Timer\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]), number_format(20), number_format(PlayerInfo[playerid][pCredits]-20));
							ShowPlayerDialogEx( playerid, DIALOG_SHOPTOTRESET, DIALOG_STYLE_MSGBOX, "Reset Timer", string, "Purchase", "Exit" );
							SendClientMessageEx(playerid, COLOR_GRAD2, "You have already sang in the last few hours!");
							return 1;
						}
						else
						{
							PinLogin(playerid);
							SendClientMessageEx(playerid, COLOR_GRAD2, "You have already sang in the last few hours!");
							return 1;
						}
					}
				}
			}
			SendClientMessageEx(playerid, COLOR_GREY, "You are not at a house. (green house icon)");
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GREY, "You have not played 2 hours.");
		}
	}
	else SendClientMessageEx(playerid, COLOR_GREY, "It isn't Christmas Eve!");
	return 1;
}

CMD:xmas(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 1337)
   	{
    	if(XMASGifts == 0)
     	{
     		XMASGifts = 1;
			new string[128];
			format( string, sizeof( string ), "%s would like for you to come to Pershing Square for free gifts and great times", GetPlayerNameEx(playerid));
			SendClientMessageToAllEx(COLOR_LIGHTGREEN, string);
		}
		else
		{
  			XMASGifts = 0;
			new string[128];
   			format( string, sizeof( string ), "AdmCmd: %s has disabled the /getgift command", GetPlayerNameEx(playerid));
			ABroadCast( COLOR_LIGHTRED, string, 1337 );
			format(string, sizeof(string), "Pershing Square is no longer giving away free gifts. Thanks for coming!", VIPGiftsName, VIPGiftsTimeLeft);
			SendClientMessageToAllEx(COLOR_LIGHTGREEN, string);
		}
	}
	return 1;
}

CMD:christmasshop(playerid, params[]) {

	new year, month, day;
	getdate(year, month, day);
	if(!GetPVarType(playerid, "PinConfirmed")) return PinLogin(playerid);
	if(month == 12 && (24 <= day <= 27)) {

		format(szMiscArray, sizeof(szMiscArray), "Ornament 1\t(100)\n\
			Ornament 2\t(100)\n\
			Ornament 3\t(100)\n\
			Ornament 4\t(100)\n\
			Ornament 5\t(100)\n\
			Xmas Tree\t(150)"
		);

		ShowPlayerDialogEx(playerid, XMAS_SHOP, DIALOG_STYLE_LIST, "Xmas Shop", szMiscArray, "Select", "Cancel");
	}
	else SendClientMessageEx(playerid, COLOR_GREY, "Humbug! No presents available yet!");

	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	switch(dialogid) {
		case XMAS_SHOP: {
			
			new 
				iLocate[2],
				szCreditCost[5],
				iExtCredCost,
				iToyID = 0;

			// extracting the credit cost position
			iLocate[0] = strfind(inputtext, "(");
			iLocate[1] = strfind(inputtext, ")");
			strmid(szCreditCost, inputtext, iLocate[0]+1, iLocate[1]);
			iExtCredCost = strval(szCreditCost);

			if(PlayerInfo[playerid][pCredits] < iExtCredCost) return SendClientMessageEx(playerid, COLOR_RED, "You do not have enough credits.");

			// extracting the item name
			if(strcmp(inputtext, "Ornament 1", false, iLocate[0]-1) == 0) {
				iToyID = 19059;
				SendClientMessageEx(playerid, COLOR_CYAN, "You have purchased Ornament 1 (19059) for 100 credits.");
				format(szMiscArray, sizeof(szMiscArray), "[TOYSALE] [User: %s(%i)] [IP: %s] [Credits: %s] [Ornament 1] [Price: %s]",GetPlayerNameEx(playerid), PlayerInfo[playerid][pId], GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(iExtCredCost));
			}
			else if(strcmp(inputtext, "Ornament 2", false, iLocate[0]-1) == 0) {
				iToyID = 19060;
				SendClientMessageEx(playerid, COLOR_CYAN, "You have purchased Ornament 2 (19060) for 100 credits.");
				format(szMiscArray, sizeof(szMiscArray), "[TOYSALE] [User: %s(%i)] [IP: %s] [Credits: %s] [Ornament 2] [Price: %s]",GetPlayerNameEx(playerid), PlayerInfo[playerid][pId], GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(iExtCredCost));
			}
			else if(strcmp(inputtext, "Ornament 3", false, iLocate[0]-1) == 0) {
				iToyID = 19061;
				SendClientMessageEx(playerid, COLOR_CYAN, "You have purchased Ornament 3 (19061) for 100 credits.");
				format(szMiscArray, sizeof(szMiscArray), "[TOYSALE] [User: %s(%i)] [IP: %s] [Credits: %s] [Ornament 3] [Price: %s]",GetPlayerNameEx(playerid), PlayerInfo[playerid][pId], GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(iExtCredCost));
			}
			else if(strcmp(inputtext, "Ornament 4", false, iLocate[0]-1) == 0) {
				iToyID = 19062;
				SendClientMessageEx(playerid, COLOR_CYAN, "You have purchased Ornament 4 (19062) for 100 credits.");
				format(szMiscArray, sizeof(szMiscArray), "[TOYSALE] [User: %s(%i)] [IP: %s] [Credits: %s] [Ornament 4] [Price: %s]",GetPlayerNameEx(playerid), PlayerInfo[playerid][pId], GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(iExtCredCost));
			}
			else if(strcmp(inputtext, "Ornament 5", false, iLocate[0]-1) == 0) {
				iToyID = 19063;
				SendClientMessageEx(playerid, COLOR_CYAN, "You have purchased Ornament 5 (19063) for 100 credits.");
				format(szMiscArray, sizeof(szMiscArray), "[TOYSALE] [User: %s(%i)] [IP: %s] [Credits: %s] [Ornament 5] [Price: %s]",GetPlayerNameEx(playerid), PlayerInfo[playerid][pId], GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(iExtCredCost));
			}
			else if(strcmp(inputtext, "Xmas Tree", false, iLocate[0]-1) == 0) {
				iToyID = 19076;
				SendClientMessageEx(playerid, COLOR_CYAN, "You have purchased an Xmas Tree (19076) for 150 credits.");
				format(szMiscArray, sizeof(szMiscArray), "[TOYSALE] [User: %s(%i)] [IP: %s] [Credits: %s] [Xmas Tree] [Price: %s]",GetPlayerNameEx(playerid), PlayerInfo[playerid][pId], GetPlayerIpEx(playerid), number_format(PlayerInfo[playerid][pCredits]), number_format(iExtCredCost));
			}

			Log("logs/micro.log", szMiscArray), print(szMiscArray);
			GivePlayerCredits(playerid, -iExtCredCost, 1);
			g_mysql_SaveAccount(playerid);

			new icount = GetPlayerToySlots(playerid);
			for(new v = 0; v < icount; v++) {
				
				if(PlayerToyInfo[playerid][v][ptModelID] == 0) {

					PlayerToyInfo[playerid][v][ptModelID] = iToyID;
					PlayerToyInfo[playerid][v][ptBone] = 6;
					PlayerToyInfo[playerid][v][ptPosX] = 0.0;
					PlayerToyInfo[playerid][v][ptPosY] = 0.0;
					PlayerToyInfo[playerid][v][ptPosZ] = 0.0;
					PlayerToyInfo[playerid][v][ptRotX] = 0.0;
					PlayerToyInfo[playerid][v][ptRotY] = 0.0;
					PlayerToyInfo[playerid][v][ptRotZ] = 0.0;
					PlayerToyInfo[playerid][v][ptScaleX] = 1.0;
					PlayerToyInfo[playerid][v][ptScaleY] = 1.0;
					PlayerToyInfo[playerid][v][ptScaleZ] = 1.0;
					PlayerToyInfo[playerid][v][ptTradable] = 1;

					g_mysql_NewToy(playerid, v);
					return 1;
				}
			}

			for(new i = 0; i < MAX_PLAYERTOYS; i++) { 

				if(PlayerToyInfo[playerid][i][ptModelID] == 0) {

					PlayerToyInfo[playerid][i][ptModelID] = iToyID;
					PlayerToyInfo[playerid][i][ptBone] = 6;
					PlayerToyInfo[playerid][i][ptPosX] = 0.0;
					PlayerToyInfo[playerid][i][ptPosY] = 0.0;
					PlayerToyInfo[playerid][i][ptPosZ] = 0.0;
					PlayerToyInfo[playerid][i][ptRotX] = 0.0;
					PlayerToyInfo[playerid][i][ptRotY] = 0.0;
					PlayerToyInfo[playerid][i][ptRotZ] = 0.0;
					PlayerToyInfo[playerid][i][ptScaleX] = 1.0;
					PlayerToyInfo[playerid][i][ptScaleY] = 1.0;
					PlayerToyInfo[playerid][i][ptScaleZ] = 1.0;
					PlayerToyInfo[playerid][i][ptTradable] = 1;
					PlayerToyInfo[playerid][i][ptSpecial] = 1;

					g_mysql_NewToy(playerid, i);

					SendClientMessageEx(playerid, COLOR_GRAD1, "Due to you not having any available slots, we've temporarily given you an additional slot to use/sell/trade your toy.");
					SendClientMessageEx(playerid, COLOR_RED, "Note: Please take note that after selling the toy, the temporarily additional toy slot will be removed.");
					break;
				}
			}
		}
	}
	return 0;
}