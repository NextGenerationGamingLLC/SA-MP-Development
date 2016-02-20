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

CMD:valgifts(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pPR] == 2)
    {
     	if(ValGifts == 0)
     	{
           	ValGifts = 1;
			format(szMiscArray, sizeof(szMiscArray), "AdmCmd: %s has enabled the /bemine command.", GetPlayerNameEx(playerid));
			ABroadCast(COLOR_LIGHTRED, szMiscArray, 1337);
		}
		else
		{
		    ValGifts = 0;
	   		format(szMiscArray, sizeof(szMiscArray), "AdmCmd: %s has disabled the /bemine command.", GetPlayerNameEx(playerid));
			ABroadCast(COLOR_LIGHTRED, szMiscArray, 1337);
		}
	}
	return 1;
}

CMD:bemine(playerid, params[])
{
	if(ValGifts == 0)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "This command has been disabled!");
		return 1;
	}
	new giveplayerid, style;
	if(sscanf(params, "ud", giveplayerid, style)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /bemine [player] [kissing style (1-6)]");
	if(!IsPlayerConnected(giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "That player is not connected");
	if(playerid == giveplayerid) return SendClientMessageEx(playerid, COLOR_GREY, "It cannot be yourself. </3");
	if(!(0 < style < 7)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /bemine [player] [kissing style (1-6)]");

	new Float:ppFloats[3];
	GetPlayerPos(giveplayerid, ppFloats[0], ppFloats[1], ppFloats[2]);

	if(!IsPlayerInRangeOfPoint(playerid, 2, ppFloats[0], ppFloats[1], ppFloats[2]) || Spectating[giveplayerid] > 0)
	{
		SendClientMessageEx(playerid, COLOR_GREY, "You're too far away! (get real close!)");
		return 1;
	}
	if(PlayerInfo[playerid][pGiftTime] > 0)
	{
		format(szMiscArray, sizeof(szMiscArray),"Item: Reset Gift Timer\nYour Credits: %s\nCost: {FFD700}%s{A9C4E4}\nCredits Left: %s", number_format(PlayerInfo[playerid][pCredits]), number_format(ShopItems[17][sItemPrice]), number_format(PlayerInfo[playerid][pCredits]-ShopItems[17][sItemPrice]));
		ShowPlayerDialogEx(playerid, DIALOG_SHOPGIFTRESET, DIALOG_STYLE_MSGBOX, "Reset Gift Timer", szMiscArray, "Purchase", "Exit" );
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

	format(szMiscArray, sizeof(szMiscArray), "You have requested %s to be your valentine, please wait for them to respond.", GetPlayerNameEx(giveplayerid));
	SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMiscArray);

	format(szMiscArray, sizeof(szMiscArray), "%s has requested to be your valentine, please use '/accept valentine' to approve it.", GetPlayerNameEx(playerid));
	SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, szMiscArray);
	return 1;
}
