/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Paintball System

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

CMD:areloadpb(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 1337)
    {
		LoadPaintballArenas();
		SendClientMessageEx(playerid, COLOR_RED, " Paintball Arenas Loaded from the database. ");
    }
}

CMD:unlockarenas(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 4) {
        SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use this command.");
        return 1;
    }
    for(new i = 0; i < MAX_ARENAS; i++) {
        if(PaintBallArena[i][pbLocked] == 2) {
            ResetPaintballArena(i);
        }
    }
    new string[128];
    format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s has unlocked all Paintball Arenas.", GetPlayerNameEx(playerid));
    ABroadCast(COLOR_YELLOW, string, 2);
    format(string, sizeof(string), "* Admin %s has unlocked all Paintball Arenas, you may join/create them now.", GetPlayerNameEx(playerid));
    SendClientMessageToAllEx(COLOR_LIGHTBLUE, string);
    return 1;
}

CMD:lockarenas(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 4) {
        SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use this command.");
        return 1;
    }
    new string[128];
    for(new i = 0; i < MAX_ARENAS; i++) {
        //foreach(new p: Player) {
		for(new p = 0; p < MAX_PLAYERS; ++p)
		{
			if(IsPlayerConnected(p))
			{		
				new arenaid = GetPVarInt(p, "IsInArena");
				if(arenaid == i) {
					if(PaintBallArena[arenaid][pbBidMoney] > 0) {
						GivePlayerCash(p,PaintBallArena[GetPVarInt(p, "IsInArena")][pbBidMoney]);
						format(string,sizeof(string),"You have been refunded a total of $%d because of premature closure.",PaintBallArena[GetPVarInt(p, "IsInArena")][pbBidMoney]);
						SendClientMessageEx(p, COLOR_WHITE, string);
					}
					if(arenaid == GetPVarInt(p, "ArenaNumber")) {
						switch(PaintBallArena[arenaid][pbGameType]) {
							case 1:
							{
								if(PlayerInfo[p][pDonateRank] < 3) {
									PlayerInfo[p][pPaintTokens] += 3;
									format(string,sizeof(string),"You have been refunded a total of %d Paintball Tokens because of premature closure.",3);
									SendClientMessageEx(p, COLOR_WHITE, string);
								}
							}
							case 2:
							{
								if(PlayerInfo[p][pDonateRank] < 3) {
									PlayerInfo[p][pPaintTokens] += 4;
									format(string,sizeof(string),"You have been refunded a total of %d Paintball Tokens because of premature closure.",4);
									SendClientMessageEx(p, COLOR_WHITE, string);
								}
							}
							case 3:
							{
								if(PlayerInfo[p][pDonateRank] < 3) {
									PlayerInfo[p][pPaintTokens] += 5;
									format(string,sizeof(string),"You have been refunded a total of %d Paintball Tokens because of premature closure.",5);
									SendClientMessageEx(p, COLOR_WHITE, string);
								}
							}
							case 4:
							{
								if(PlayerInfo[p][pDonateRank] < 3) {
									PlayerInfo[p][pPaintTokens] += 5;
									format(string,sizeof(string),"You have been refunded a total of %d Paintball Tokens because of premature closure.",5);
									SendClientMessageEx(p, COLOR_WHITE, string);
								}
							}
							case 5:
							{
								if(PlayerInfo[p][pDonateRank] < 3) {
									PlayerInfo[p][pPaintTokens] += 6;
									format(string,sizeof(string),"You have been refunded a total of %d Paintball Tokens because of premature closure.",6);
									SendClientMessageEx(p, COLOR_WHITE, string);
								}
							}
						}
					}
					LeavePaintballArena(p, arenaid);
				}
			}	
        }
        ResetPaintballArena(i);
        PaintBallArena[i][pbLocked] = 2;
    }
    format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s has locked all Paintball Arenas.", GetPlayerNameEx(playerid));
    ABroadCast(COLOR_YELLOW, string, 2);
    format(string, sizeof(string), "* Admin %s has locked all Paintball Arenas for some short maintenance.", GetPlayerNameEx(playerid));
    SendClientMessageToAllEx(COLOR_LIGHTBLUE, string);
    return 1;
}

CMD:savedmpos(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 1337) {
        if(GetPVarInt(playerid, "EditingDMPos") == 0) {
            SendClientMessageEx(playerid, COLOR_GRAD2, "You are currently not editing any spawn positions.");
            return 1;
        }
        if(GetPVarInt(playerid, "ArenaNumber") == -1) {
            SendClientMessageEx(playerid, COLOR_GRAD2, "You are currently not editing any arenas.");
            return 1;
        }
        new string[128];
        new arenaid = GetPVarInt(playerid, "ArenaNumber");
        new dmposid = GetPVarInt(playerid, "EditingDMPos");
        new Float:x, Float: y, Float: z, Float: angle;
        GetPlayerPos(playerid, x, y, z);
        GetPlayerFacingAngle(playerid, angle);

        switch(dmposid) {
            case 1:
            {
                PaintBallArena[arenaid][pbDeathmatch1][0] = x;
                PaintBallArena[arenaid][pbDeathmatch1][1] = y;
                PaintBallArena[arenaid][pbDeathmatch1][2] = z;
                PaintBallArena[arenaid][pbDeathmatch1][3] = angle;

                format(string,sizeof(string),"X=%f, Y=%f, Z=%f, Angle=%f",x,y,z,angle);
                SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully edited DM Spawn Position 1.");
                SendClientMessageEx(playerid, COLOR_GRAD2, string);

                SetPVarInt(playerid, "EditingDMPos", 0);
                PaintballEditArenaDMSpawns(playerid);
            }
            case 2:
            {
                PaintBallArena[arenaid][pbDeathmatch2][0] = x;
                PaintBallArena[arenaid][pbDeathmatch2][1] = y;
                PaintBallArena[arenaid][pbDeathmatch2][2] = z;
                PaintBallArena[arenaid][pbDeathmatch2][3] = angle;

                format(string,sizeof(string),"X=%f, Y=%f, Z=%f, Angle=%f",x,y,z,angle);
                SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully edited DM Spawn Position 2.");
                SendClientMessageEx(playerid, COLOR_GRAD2, string);

                SetPVarInt(playerid, "EditingDMPos", 0);
                PaintballEditArenaDMSpawns(playerid);
            }
            case 3:
            {
                PaintBallArena[arenaid][pbDeathmatch3][0] = x;
                PaintBallArena[arenaid][pbDeathmatch3][1] = y;
                PaintBallArena[arenaid][pbDeathmatch3][2] = z;
                PaintBallArena[arenaid][pbDeathmatch3][3] = angle;

                format(string,sizeof(string),"X=%f, Y=%f, Z=%f, Angle=%f",x,y,z,angle);
                SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully edited DM Spawn Position 3.");
                SendClientMessageEx(playerid, COLOR_GRAD2, string);

                SetPVarInt(playerid, "EditingDMPos", 0);
                PaintballEditArenaDMSpawns(playerid);
            }
            case 4:
            {
                PaintBallArena[arenaid][pbDeathmatch4][0] = x;
                PaintBallArena[arenaid][pbDeathmatch4][1] = y;
                PaintBallArena[arenaid][pbDeathmatch4][2] = z;
                PaintBallArena[arenaid][pbDeathmatch4][3] = angle;

                format(string,sizeof(string),"X=%f, Y=%f, Z=%f, Angle=%f",x,y,z,angle);
                SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully edited DM Spawn Position 4.");
                SendClientMessageEx(playerid, COLOR_GRAD2, string);

                SetPVarInt(playerid, "EditingDMPos", 0);
                PaintballEditArenaDMSpawns(playerid);
            }
        }

    }
    else {
        SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use this command.");
    }
    return 1;
}

CMD:saveteampos(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 1337) {
        if(GetPVarInt(playerid, "EditingTeamPos") == 0) {
            SendClientMessageEx(playerid, COLOR_GRAD2, "You are currently not editing any spawn positions.");
            return 1;
        }
        if(GetPVarInt(playerid, "ArenaNumber") == -1) {
            SendClientMessageEx(playerid, COLOR_GRAD2, "You are currently not editing any arenas.");
            return 1;
        }
        new string[128];
        new arenaid = GetPVarInt(playerid, "ArenaNumber");
        new teamposid = GetPVarInt(playerid, "EditingTeamPos");
        new Float:x, Float: y, Float: z, Float: angle;
        GetPlayerPos(playerid, x, y, z);
        GetPlayerFacingAngle(playerid, angle);

        switch(teamposid) {
            case 1:
            {
                PaintBallArena[arenaid][pbTeamRed1][0] = x;
                PaintBallArena[arenaid][pbTeamRed1][1] = y;
                PaintBallArena[arenaid][pbTeamRed1][2] = z;
                PaintBallArena[arenaid][pbTeamRed1][3] = angle;

                format(string,sizeof(string),"X=%f, Y=%f, Z=%f, Angle=%f",x,y,z,angle);
                SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully edited Red Team Spawn Position 1.");
                SendClientMessageEx(playerid, COLOR_GRAD2, string);

                SetPVarInt(playerid, "EditingTeamPos", 0);
                PaintballEditArenaTeamSpawns(playerid);
            }
            case 2:
            {
                PaintBallArena[arenaid][pbTeamRed2][0] = x;
                PaintBallArena[arenaid][pbTeamRed2][1] = y;
                PaintBallArena[arenaid][pbTeamRed2][2] = z;
                PaintBallArena[arenaid][pbTeamRed2][3] = angle;

                format(string,sizeof(string),"X=%f, Y=%f, Z=%f, Angle=%f",x,y,z,angle);
                SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully edited Red Team Spawn Position 2.");
                SendClientMessageEx(playerid, COLOR_GRAD2, string);

                SetPVarInt(playerid, "EditingTeamPos", 0);
                PaintballEditArenaTeamSpawns(playerid);
            }
            case 3:
            {
                PaintBallArena[arenaid][pbTeamRed3][0] = x;
                PaintBallArena[arenaid][pbTeamRed3][1] = y;
                PaintBallArena[arenaid][pbTeamRed3][2] = z;
                PaintBallArena[arenaid][pbTeamRed3][3] = angle;

                format(string,sizeof(string),"X=%f, Y=%f, Z=%f, Angle=%f",x,y,z,angle);
                SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully edited Red Team Spawn Position 3.");
                SendClientMessageEx(playerid, COLOR_GRAD2, string);

                SetPVarInt(playerid, "EditingTeamPos", 0);
                PaintballEditArenaTeamSpawns(playerid);
            }
            case 4:
            {
                PaintBallArena[arenaid][pbTeamBlue1][0] = x;
                PaintBallArena[arenaid][pbTeamBlue1][1] = y;
                PaintBallArena[arenaid][pbTeamBlue1][2] = z;
                PaintBallArena[arenaid][pbTeamBlue1][3] = angle;

                format(string,sizeof(string),"X=%f, Y=%f, Z=%f, Angle=%f",x,y,z,angle);
                SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully edited Blue Team Spawn Position 1.");
                SendClientMessageEx(playerid, COLOR_GRAD2, string);

                SetPVarInt(playerid, "EditingTeamPos", 0);
                PaintballEditArenaTeamSpawns(playerid);
            }
            case 5:
            {
                PaintBallArena[arenaid][pbTeamBlue2][0] = x;
                PaintBallArena[arenaid][pbTeamBlue2][1] = y;
                PaintBallArena[arenaid][pbTeamBlue2][2] = z;
                PaintBallArena[arenaid][pbTeamBlue2][3] = angle;

                format(string,sizeof(string),"X=%f, Y=%f, Z=%f, Angle=%f",x,y,z,angle);
                SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully edited Blue Team Spawn Position 2.");
                SendClientMessageEx(playerid, COLOR_GRAD2, string);

                SetPVarInt(playerid, "EditingTeamPos", 0);
                PaintballEditArenaTeamSpawns(playerid);
            }
            case 6:
            {
                PaintBallArena[arenaid][pbTeamBlue3][0] = x;
                PaintBallArena[arenaid][pbTeamBlue3][1] = y;
                PaintBallArena[arenaid][pbTeamBlue3][2] = z;
                PaintBallArena[arenaid][pbTeamBlue3][3] = angle;

                format(string,sizeof(string),"X=%f, Y=%f, Z=%f, Angle=%f",x,y,z,angle);
                SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully edited Blue Team Spawn Position 3.");
                SendClientMessageEx(playerid, COLOR_GRAD2, string);

                SetPVarInt(playerid, "EditingTeamPos", 0);
                PaintballEditArenaTeamSpawns(playerid);
            }
        }

    }
    else {
        SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use this command.");
    }
    return 1;
}

CMD:saveflagpos(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 1337) {
        if(GetPVarInt(playerid, "EditingFlagPos") == 0) {
            SendClientMessageEx(playerid, COLOR_GRAD2, "You are currently not editing any flag positions.");
            return 1;
        }
        if(GetPVarInt(playerid, "ArenaNumber") == -1) {
            SendClientMessageEx(playerid, COLOR_GRAD2, "You are currently not editing any arenas.");
            return 1;
        }
        new string[128];
        new arenaid = GetPVarInt(playerid, "ArenaNumber");
        new flagposid = GetPVarInt(playerid, "EditingFlagPos");
        new Float:x, Float: y, Float: z;
        GetPlayerPos(playerid, x, y, z);

        switch(flagposid) {
            case 1:                               // Red Flag Spawn Position
            {
                PaintBallArena[arenaid][pbFlagRedSpawn][0] = x;
                PaintBallArena[arenaid][pbFlagRedSpawn][1] = y;
                PaintBallArena[arenaid][pbFlagRedSpawn][2] = z;

                format(string,sizeof(string),"X=%f, Y=%f, Z=%f",x,y,z);
                SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully edited Red Team Flag Position.");
                SendClientMessageEx(playerid, COLOR_GRAD2, string);

                SetPVarInt(playerid, "EditingFlagPos", 0);
                PaintballEditArenaFlagSpawns(playerid);
            }
            case 2:                               // Blue Flag Spawn Position
            {
                PaintBallArena[arenaid][pbFlagBlueSpawn][0] = x;
                PaintBallArena[arenaid][pbFlagBlueSpawn][1] = y;
                PaintBallArena[arenaid][pbFlagBlueSpawn][2] = z;

                format(string,sizeof(string),"X=%f, Y=%f, Z=%f",x,y,z);
                SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully edited Blue Team Flag Position.");
                SendClientMessageEx(playerid, COLOR_GRAD2, string);

                SetPVarInt(playerid, "EditingFlagPos", 0);
                PaintballEditArenaFlagSpawns(playerid);
            }
        }

    }
    else {
        SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use this command.");
    }
    return 1;
}

CMD:savehillpos(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 1337) {
        if(GetPVarInt(playerid, "ArenaNumber") == -1) {
            SendClientMessageEx(playerid, COLOR_GRAD2, "You are currently not editing any arenas.");
            return 1;
        }
        new string[128];
        new arenaid = GetPVarInt(playerid, "ArenaNumber");
        new stage = GetPVarInt(playerid, "EditingHillStage");
        new Float:x, Float: y, Float: z;
        GetPlayerPos(playerid, x, y, z);

        if(stage == -1) {
            SendClientMessageEx(playerid, COLOR_GRAD2, "You are not editing any Hill Positions right now!");
            return 1;
        }
        else {
            switch(stage) {
                case 1:
                {
                    PaintBallArena[arenaid][pbHillX] = x;
                    PaintBallArena[arenaid][pbHillY] = y;
                    PaintBallArena[arenaid][pbHillZ] = z;

                    format(string,sizeof(string),"X=%f, Y=%f, Z=%f",x,y,z);
                    SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully edited the Hill Position.");
                    SendClientMessageEx(playerid, COLOR_GRAD2, string);

                    SetPVarInt(playerid, "EditingHillStage", -1);
                    PaintballEditArenaMenu(playerid);
                }
            }
        }
    }
    else {
        SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use this command.");
    }
    return 1;
}

CMD:switchteam(playerid, params[])
{
    if(GetPVarInt(playerid, "IsInArena") == -1) {
        SendClientMessageEx(playerid,COLOR_WHITE,"You are not in an arena, you can not switch teams!");
        return 1;
    }
    if(GetPVarInt(playerid, "AOSlotPaintballFlag") != -1) {
        SendClientMessageEx(playerid,COLOR_WHITE,"You can not switch teams while holding the flag!");
        return 1;
    }

    new arenaid = GetPVarInt(playerid, "IsInArena");
    if(PaintBallArena[arenaid][pbGameType] == 2 || PaintBallArena[arenaid][pbGameType] == 3 || PaintBallArena[arenaid][pbGameType] == 5) {
        PaintballSwitchTeam(playerid);
    }
    else {
        SendClientMessageEx(playerid,COLOR_WHITE,"You can not switch teams in this gamemode!");
    }
    return 1;
}

CMD:joinarena(playerid, params[])
{
    if(GetPVarInt(playerid, "IsInArena") == -1) {
        if(PlayerInfo[playerid][pConnectHours] < 2) {
            SendClientMessageEx(playerid, COLOR_WHITE, "You are unable to join a Paintball Match due to your weapon restriction.");
            return 1;
        }
        if(GetPVarInt(playerid, "Packages") >= 1 || TaxiAccepted[playerid] != INVALID_PLAYER_ID || EMSAccepted[playerid] != INVALID_PLAYER_ID || BusAccepted[playerid] != INVALID_PLAYER_ID || MedicAccepted[playerid] != INVALID_PLAYER_ID || MechanicCallTime[playerid] >= 1) {
            SendClientMessageEx(playerid, COLOR_WHITE, "Please ensure that your current checkpoint is destroyed first (you either have material packages, or another existing checkpoint).");
            return 1;
        }
        if(pTazer{playerid} != 0)
		{
			new string[128];
			RemovePlayerWeapon(playerid, 23);
			GivePlayerValidWeapon(playerid, pTazerReplace{playerid}, 60000);
			format(string, sizeof(string), "* %s holsters their tazer.", GetPlayerNameEx(playerid));			ProxDetector(4.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
 			pTazer{playerid} = 0;
 		}
		if(PlayerCuffed[playerid] >= 1 || PlayerInfo[playerid][pJailTime] > 0 || GetPVarInt(playerid, "Injured")) return SendClientMessageEx( playerid, COLOR_WHITE, "You can't do this right now." );
        if(PlayerInfo[playerid][pAdmin] > 2) {
            ShowPlayerDialog(playerid,PBMAINMENU,DIALOG_STYLE_LIST,"Paintball Arena - Main Menu:","Choose an Arena\nPaintball Tokens\nAdmin Menu","Select","Leave");
            return 1;
        }
        if(IsPlayerInRangeOfPoint(playerid,10.0,1294.5062,-1445.0599,0.4403)) {
            ShowPlayerDialog(playerid,PBMAINMENU,DIALOG_STYLE_LIST,"Paintball Arena - Main Menu:","Choose an Arena\nPaintball Tokens\nAdmin Menu","Select","Leave");
        }
        else {
            SendClientMessageEx(playerid, COLOR_WHITE, "You are not near the Paintball Arena!");
        }

    }
    else {
        SendClientMessageEx(playerid, COLOR_WHITE, "You are already in an arena!");
    }
    return 1;
}

CMD:exitarena(playerid, params[])
{
    if(GetPVarInt(playerid, "IsInArena") >= 0) {
        if(GetPlayerState(playerid) == PLAYER_STATE_WASTED) {
            SendClientMessageEx(playerid, COLOR_WHITE, "You cannot do that at this time.");
            return 1;
        }
        if(PaintBallArena[GetPVarInt(playerid, "IsInArena")][pbTimeLeft] <= 30) {
            SendClientMessageEx(playerid, COLOR_WHITE, "You cannot leave when there is less than 30 seconds left!");
            return 1;
        }
        if(GetPVarInt(playerid, "commitSuicide") == 1) {
        	DeletePVar(playerid, "commitSuicide");
        	SendClientMessageEx(playerid, COLOR_GREY, "Exiting the arena cancelled your request to /kill.");
        } 
        LeavePaintballArena(playerid, GetPVarInt(playerid, "IsInArena"));
    }
    else {
        SendClientMessageEx(playerid, COLOR_WHITE, "You are not in an arena!");
    }
    return 1;
}

CMD:scores(playerid, params[])
{
    if(GetPVarInt(playerid, "IsInArena") >= 0)
	{
        PaintballScoreboard(playerid, GetPVarInt(playerid, "IsInArena"));
    }
    else
	{
        SendClientMessageEx(playerid, COLOR_WHITE, "You are not in an arena!");
    }
    return 1;
}
