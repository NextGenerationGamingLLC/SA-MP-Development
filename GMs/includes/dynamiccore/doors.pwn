/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

					Dynamic Door System

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

CMD:changedoorpass(playerid, params[])
{
    for(new i = 0; i < sizeof(DDoorsInfo); i++) {
        if (IsPlayerInRangeOfPoint(playerid,3.0,DDoorsInfo[i][ddExteriorX], DDoorsInfo[i][ddExteriorY], DDoorsInfo[i][ddExteriorZ]) && PlayerInfo[playerid][pVW] == DDoorsInfo[i][ddExteriorVW] || IsPlayerInRangeOfPoint(playerid,3.0,DDoorsInfo[i][ddInteriorX], DDoorsInfo[i][ddInteriorY], DDoorsInfo[i][ddInteriorZ]) && PlayerInfo[playerid][pVW] == DDoorsInfo[i][ddInteriorVW])
		{
			new doorpass[24];
			if(sscanf(params, "s[24]", doorpass)) { SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /changedoorpass [pass]"); SendClientMessageEx(playerid, COLOR_WHITE, "To remove the password on the door set the password to 'none'."); return 1; }
        	if(DDoorsInfo[i][ddType] == 2 && DDoorsInfo[i][ddFaction] != INVALID_GROUP_ID && PlayerInfo[playerid][pLeader] == DDoorsInfo[i][ddFaction])
			{
				format(DDoorsInfo[i][ddPass], 24, "%s", doorpass);
				SendClientMessageEx(playerid, COLOR_WHITE, "You have changed the password of this door.");
				SaveDynamicDoor(i);
			}
			else if(DDoorsInfo[i][ddType] == 3 && DDoorsInfo[i][ddFamily] != INVALID_FAMILY_ID && PlayerInfo[playerid][pFMember] == DDoorsInfo[i][ddFamily] && PlayerInfo[playerid][pRank] == 6)
			{
				format(DDoorsInfo[i][ddPass], 24, "%s", doorpass);
				SendClientMessageEx(playerid, COLOR_WHITE, "You have changed the password of this door.");
				SaveDynamicDoor(i);
			}
			else if(DDoorsInfo[i][ddType] == 1 && DDoorsInfo[i][ddOwner] == GetPlayerSQLId(playerid))
			{
				format(DDoorsInfo[i][ddPass], 24, "%s", doorpass);
				SendClientMessageEx(playerid, COLOR_WHITE, "You have changed the password of this door.");
				SaveDynamicDoor(i);
			}
			else SendClientMessageEx(playerid, COLOR_GREY, "You cannot change the password on this lock.");
		}
	}
	return 1;
}

CMD:lockdoor(playerid, params[])
{
    for(new i = 0; i < sizeof(DDoorsInfo); i++) {
        if (IsPlayerInRangeOfPoint(playerid,3.0,DDoorsInfo[i][ddExteriorX], DDoorsInfo[i][ddExteriorY], DDoorsInfo[i][ddExteriorZ]) && PlayerInfo[playerid][pVW] == DDoorsInfo[i][ddExteriorVW] || IsPlayerInRangeOfPoint(playerid,3.0,DDoorsInfo[i][ddInteriorX], DDoorsInfo[i][ddInteriorY], DDoorsInfo[i][ddInteriorZ]) && PlayerInfo[playerid][pVW] == DDoorsInfo[i][ddInteriorVW])
		{
        	if(DDoorsInfo[i][ddType] == 2 && DDoorsInfo[i][ddFaction] != INVALID_GROUP_ID && PlayerInfo[playerid][pLeader] == DDoorsInfo[i][ddFaction])
			{
				if(DDoorsInfo[i][ddLocked] == 0)
				{
					DDoorsInfo[i][ddLocked] = 1;
					SendClientMessageEx(playerid, COLOR_WHITE, "This door has been locked.");
				}
				else if(DDoorsInfo[i][ddLocked] == 1)
				{
					DDoorsInfo[i][ddLocked] = 0;
					SendClientMessageEx(playerid, COLOR_GREY, "This door has been unlocked.");
				}
			}
			else if(DDoorsInfo[i][ddType] == 3 && DDoorsInfo[i][ddFamily] != INVALID_FAMILY_ID && PlayerInfo[playerid][pFMember] == DDoorsInfo[i][ddFamily] && PlayerInfo[playerid][pRank] == 6)
			{
				if(DDoorsInfo[i][ddLocked] == 0)
				{
					DDoorsInfo[i][ddLocked] = 1;
					SendClientMessageEx(playerid, COLOR_WHITE, "This door has been locked.");
				}
				else if(DDoorsInfo[i][ddLocked] == 1)
				{
					DDoorsInfo[i][ddLocked] = 0;
					SendClientMessageEx(playerid, COLOR_GREY, "This door has been unlocked.");
				}
			}
			else if(DDoorsInfo[i][ddType] == 1 && DDoorsInfo[i][ddOwner] == GetPlayerSQLId(playerid))
			{
				if(DDoorsInfo[i][ddLocked] == 0)
				{
					DDoorsInfo[i][ddLocked] = 1;
					SendClientMessageEx(playerid, COLOR_WHITE, "This door has been locked.");
				}
				else if(DDoorsInfo[i][ddLocked] == 1)
				{
					DDoorsInfo[i][ddLocked] = 0;
					SendClientMessageEx(playerid, COLOR_GREY, "This door has been unlocked.");
				}
			}
			else SendClientMessageEx(playerid, COLOR_GREY, "You cannot lock this door.");
		}
	}
	return 1;
}

CMD:doorpass(playerid, params[])
{
    for(new i = 0; i < sizeof(DDoorsInfo); i++) {
        if (IsPlayerInRangeOfPoint(playerid,3.0,DDoorsInfo[i][ddExteriorX], DDoorsInfo[i][ddExteriorY], DDoorsInfo[i][ddExteriorZ]) && PlayerInfo[playerid][pVW] == DDoorsInfo[i][ddExteriorVW] || IsPlayerInRangeOfPoint(playerid,3.0,DDoorsInfo[i][ddInteriorX], DDoorsInfo[i][ddInteriorY], DDoorsInfo[i][ddInteriorZ]) && PlayerInfo[playerid][pVW] == DDoorsInfo[i][ddInteriorVW]) {
        	if(DDoorsInfo[i][ddPass] < 1)
                return SendClientMessageEx(playerid, COLOR_GREY, "This door isn't allowed to be locked");
         	if(strcmp(DDoorsInfo[i][ddPass], "None", true) == 0)
                return SendClientMessageEx(playerid, COLOR_GREY, "This door isn't allowed to be locked");

			ShowPlayerDialog(playerid, DOORLOCK, DIALOG_STYLE_INPUT, "Door Security","Enter the password for this door","Login","Cancel");
			SetPVarInt(playerid, "Door", i);
		}
	}
	return 1;
}
