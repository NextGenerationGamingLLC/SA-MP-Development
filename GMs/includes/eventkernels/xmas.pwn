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
							ShowPlayerDialog( playerid, DIALOG_SHOPTOTRESET, DIALOG_STYLE_MSGBOX, "Reset Timer", string, "Purchase", "Exit" );
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
