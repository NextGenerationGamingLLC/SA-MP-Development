/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Helmets

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

CMD:hm(playerid, params[]) return cmd_helmet(playerid, params);

CMD:helmet(playerid, params[])
{
    if(!IsABike(GetPlayerVehicleID(playerid)))
	{
        SendClientMessageEx(playerid, COLOR_GRAD2, "You are not on a bike!");
        return 1;
    }
	new string[60 + MAX_PLAYER_NAME];
    if(Seatbelt[playerid] == 0)
	{
		new icount = GetPlayerToySlots(playerid), helmetlist[8], helmetcount;
		for(new x = 0; x < icount; x++)
		{
			if(PlayerToyInfo[playerid][x][ptModelID] != 0 && PlayerToyInfo[playerid][x][ptSpecial] == 2)
			{
				helmetlist[helmetcount] = PlayerToyInfo[playerid][x][ptModelID];
				gCustomExtraList[playerid][helmetcount] =  x;
				helmetcount++;
			}
		}
		if(helmetcount != 0)
			ShowModelSelectionMenuEx(playerid, helmetlist, helmetcount, "Helmet Selector", 2000, 0.0, 0.0, 120.0);
		else
			SendClientMessageEx(playerid, COLOR_GRAD2, "You do not own any helmets! Get one at any 24/7 in order to use /helmet");
    }
    else if(Seatbelt[playerid] == 2)
	{
        Seatbelt[playerid] = 0;
		for(new i; i < 10; i++) {
			if(PlayerHoldingObject[playerid][i] == GetPVarInt(playerid, "HelmetOn")) {
				PlayerHoldingObject[playerid][i] = 0;
				RemovePlayerAttachedObject(playerid, i);
				DeletePVar(playerid, "HelmetOn");
				break;
			}
		}
		format(string, sizeof(string), "{FF8000}** {C2A2DA}%s reaches for their helmet and takes it off.", GetPlayerNameEx(playerid));
		SendClientMessageEx(playerid, COLOR_WHITE, "You have taken off your helmet.");
		ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
    }
    return 1;
}

CMD:chm(playerid, params[]) return cmd_checkhelmet(playerid, params);

CMD:checkhelmet(playerid, params[])
{
	new giveplayerid;
	if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /checkhelmet [player]");

    if(GetPlayerState(giveplayerid) == PLAYER_STATE_ONFOOT)
	{
        SendClientMessageEx(playerid,COLOR_GREY,"That person is not in any vehicle!");
        return 1;
    }
    if (ProxDetectorS(9.0, playerid, giveplayerid))
	{
		new string[128];
        new stext[4];
        if(Seatbelt[giveplayerid] == 0) { stext = "off"; }
        else { stext = "on"; }
        if(IsABike(GetPlayerVehicleID(playerid)))
		{
            format(string, sizeof(string), "%s's helmet is currently %s." , GetPlayerNameEx(giveplayerid) , stext);
            SendClientMessageEx(playerid,COLOR_WHITE,string);

            format(string, sizeof(string), "* %s looks at %s, checking to see if they are wearing a helmet.", GetPlayerNameEx(playerid),GetPlayerNameEx(giveplayerid));
            ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
        }
    }
    else { SendClientMessageEx(playerid, COLOR_GREY, "You are not around that player!"); }
    return 1;
}