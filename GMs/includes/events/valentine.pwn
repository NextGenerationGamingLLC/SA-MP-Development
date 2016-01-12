/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Valentines Events

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

CMD:valgifts(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pPR] == 2)
    {
     	if(ValGifts == 0)
     	{
           	ValGifts = 1;
           	new sString[41 + MAX_PLAYER_NAME];
			format( sString, sizeof( sString ), "AdmCmd: %s has enabled the /kissvalentine command.", GetPlayerNameEx(playerid));
			ABroadCast( COLOR_LIGHTRED, sString, 1337 );
			vgtext = CreateDynamic3DTextLabel("/kissvalentine", COLOR_RED, -1984.5751, 1117.9972, 53.1250, 10.0);
		}
		else
		{
		    ValGifts = 0;
		    new sString[41 + MAX_PLAYER_NAME];
	   		format( sString, sizeof( sString ), "AdmCmd: %s has disabled the /kissvalentine command.", GetPlayerNameEx(playerid));
			ABroadCast( COLOR_LIGHTRED, sString, 1337 );
			DestroyDynamic3DTextLabel(vgtext);
		}
	}
	return 1;
}

CMD:kissvalentine(playerid, params[])
{
	new string[128], year, month, day;
	getdate(year, month, day);
	if(ValGifts == 0)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "This command has been disabled!");
		return 1;
	}
	if(IsPlayerInRangeOfPoint(playerid, 10.0,-1984.5751,1117.9972,53.1250))
	{
		new giveplayerid, style;
		if(sscanf(params, "ud", giveplayerid, style)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /kissvalentine [player] [style (1-6)]");
		if(!IsPlayerConnected(giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "That player is not connected");
		if(playerid == giveplayerid) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /kissvalentine [player] [style (1-6)]");
		if(!(0 < style < 7)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /kissvalentine [player] [style (1-6)]");
		new Float: ppFloats[3];

		GetPlayerPos(giveplayerid, ppFloats[0], ppFloats[1], ppFloats[2]);

		if(!IsPlayerInRangeOfPoint(playerid, 2, ppFloats[0], ppFloats[1], ppFloats[2]) || Spectating[giveplayerid] > 0)
		{
			SendClientMessageEx(playerid, COLOR_GREY, "You're too far away. You can't kiss right now.");
			return 1;
		}
		if(PlayerInfo[playerid][pGiftTime] > 0)
		{
			format(string, sizeof(string),"Item: Reset Gift Timer\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[17][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[17][sItemPrice]));
			ShowPlayerDialogEx( playerid, DIALOG_SHOPGIFTRESET, DIALOG_STYLE_MSGBOX, "Reset Gift Timer", string, "Purchase", "Exit" );
			SendClientMessageEx(playerid, COLOR_GRAD2, "You have already received a gift in the last 5 hours!");
			return 1;
		}
		else if(PlayerInfo[giveplayerid][pGiftTime] > 0)
		{
			SendClientMessageEx(playerid, COLOR_GRAD2, "That player has already received a gift in the last 5 hours!");
			return 1;
		}
		SetPVarInt(playerid, "kissvalstyle", style);
		SetPVarInt(giveplayerid, "kissvaloffer", playerid);
		SetPVarInt(giveplayerid, "kissvalsqlid", GetPlayerSQLId(playerid));
		
		format(string, sizeof(string), "You have requested to kiss %s, please wait for them to respond.", GetPlayerNameEx(giveplayerid));
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);

		format(string, sizeof(string), "%s has requested to give you a kiss, please use '/accept kiss' to approve it.", GetPlayerNameEx(playerid));
		SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
	}
	else return SendClientMessageEx(playerid, COLOR_GREY, "You need to be near the San Fierro Church in order to use this command.");
	return 1;
}