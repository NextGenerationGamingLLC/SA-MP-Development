/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

					Turfs / Points System

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

// Akatony Note: You need to destroy the 3D Label text no matter what's the state of the capture.
forward ProgressTimer(point);
public ProgressTimer(point)
{
	if (Points[point][ClaimerId] != INVALID_PLAYER_ID && Points[point][TimeToClaim])
	{
	    new string[128];
		Points[point][TimeLeft]--;
		format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~%d seconds left", Points[point][TimeLeft]);
		GameTextForPlayer(Points[point][ClaimerId], string, 1100, 3);
		if(Points[point][TimeLeft] >= 1) SetTimerEx("ProgressTimer", 1000, 0, "d", point);
		format(string, sizeof(string), "%s is attempting to capture the point, time left: %d", GetPlayerNameEx(Points[point][ClaimerId]), Points[point][TimeLeft]);
		if(Points[point][TimeLeft] == 9) Points[point][CaptureProgress] = CreateDynamic3DTextLabel(string, COLOR_RED, Points[point][Pointx], Points[point][Pointy], Points[point][Pointz]+1.0, 10.0);
				else if(Points[point][TimeLeft] < 9 && Points[point][TimeLeft] >= 0) UpdateDynamic3DTextLabelText(Points[point][CaptureProgress], COLOR_RED, string);
	}
	else
	{
	    DestroyDynamic3DTextLabel(Points[point][CaptureProgress]);
	    Points[point][ClaimerId] = INVALID_PLAYER_ID;
		Points[point][TimeToClaim] = 0;
	}

	if(Points[point][TimeLeft] <= 0)
	{
		DestroyDynamic3DTextLabel(Points[point][CaptureProgress]);
	    CaptureTimer(point);
	    Points[point][TimeLeft] = 0;
	}
	return 1;
}

forward CaptureTimer(point);
public CaptureTimer(point)
{
	new string[128];
	new fam;
	if (Points[point][ClaimerId] != INVALID_PLAYER_ID && Points[point][TimeToClaim])
	{
		new claimer = Points[point][ClaimerId];
		new Float: x, Float: y, Float: z;
		GetPlayerPos(claimer, x, y, z);
		if (Points[point][Capturex] != x || Points[point][Capturey] != y || Points[point][Capturez] != z || GetPVarInt(Points[point][ClaimerId],"Injured") == 1)
		{
			SendClientMessageEx(Points[point][ClaimerId], COLOR_LIGHTBLUE, "You failed to capture. You either moved or died while attempting to capture.");
			Points[point][ClaimerId] = INVALID_PLAYER_ID;
			Points[point][TimeToClaim] = 0;
		}
		else
		{
			if(Points[point][Vulnerable] > 0)
			{
			    SendClientMessageEx(Points[point][ClaimerId], COLOR_LIGHTBLUE, "You failed to capture. The point was already captured.");
				Points[point][ClaimerId] = INVALID_PLAYER_ID;
				Points[point][TimeToClaim] = 0;
				return 1;
			}
			if(playerTabbed[claimer] != 0)
			{
			    SendClientMessageEx(Points[point][ClaimerId], COLOR_LIGHTBLUE, "You failed to capture. You were alt-tabbed.");
			    format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s (ID %d) may have possibly alt tabbed to capture a point.", GetPlayerNameEx(claimer), claimer);
				ABroadCast( COLOR_YELLOW, string, 2 );
   				Points[point][ClaimerId] = INVALID_PLAYER_ID;
				Points[point][TimeToClaim] = 0;
			    return 1;
			}
			new cappervw = GetPlayerVirtualWorld(Points[point][ClaimerId]);
			if(cappervw != Points[point][pointVW])
			{
			    SendClientMessageEx(Points[point][ClaimerId], COLOR_LIGHTBLUE, "You failed to capture. You were not in the point virtual world.");
			    format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s (ID %d) may have possibly desynced himself to capture a point.", GetPlayerNameEx(claimer), claimer);
				ABroadCast( COLOR_YELLOW, string, 2 );
   				Points[point][ClaimerId] = INVALID_PLAYER_ID;
				Points[point][TimeToClaim] = 0;
			    return 1;
			}
			fam = PlayerInfo[claimer][pFMember];
            Points[point][PlayerNameCapping] = GetPlayerNameEx(claimer);
		   	format(string, sizeof(string), "%s has attempted to take control of the %s for %s, it will be theirs in %d minutes.", Points[point][PlayerNameCapping], Points[point][Name], FamilyInfo[fam][FamilyName], TIME_TO_TAKEOVER);
			SendClientMessageToAllEx(COLOR_YELLOW, string);
			if(Points[point][CaptureProccessEx] >= 1)
			{
				UpdateDynamic3DTextLabelText(Points[point][CaptureProccess], COLOR_YELLOW, string);
				Points[point][CaptureProccessEx] = 2;
			}
			Points[point][TakeOverTimerStarted] = 1;
			Points[point][TakeOverTimer] = 10;
			Points[point][ClaimerId] = INVALID_PLAYER_ID;
			Points[point][ClaimerTeam] = fam;
			Points[point][TimeToClaim] = 0;
			PointCrashProtection(point);
			if(Points[point][CaptureTimerEx2] != -1) KillTimer(Points[point][CaptureTimerEx2]);
			Points[point][CaptureTimerEx2] = SetTimerEx("CaptureTimerEx", 60000, 1, "d", point);
		}
	}
	return 1;
}

ReadyToCapture(pointid)
{
	new string[128];
	//foreach(new i: Player)
	for(new i = 0; i < MAX_PLAYERS; ++i)
	{
		if(IsPlayerConnected(i))
		{
			if(PlayerInfo[i][pFMember] < INVALID_FAMILY_ID)
			{
				if(Points[pointid][Type] == 3 && Points[pointid][Type] == 4) return 1;
				if(Points[pointid][CapCrash] != 1)
				{
					format(string, sizeof(string), "%s has become available to capture! Stand at here and /capture it!", Points[pointid][Name]);
					Points[pointid][CaptureProccessEx] = 1;
					Points[pointid][CaptureProccess] = CreateDynamic3DTextLabel(string, COLOR_YELLOW, Points[pointid][Pointx], Points[pointid][Pointy], Points[pointid][Pointz], 10.0, _, _, _, _, _,i);
				}	
			}
		}	
	}
	if(Points[pointid][CapCrash] == 1)
	{
		format(string, sizeof(string), "%s has successfully attempted to take over of %s for %s, it will be theirs in %d minutes!", Points[pointid][PlayerNameCapping], Points[pointid][Name], FamilyInfo[Points[pointid][ClaimerTeam]][FamilyName], Points[pointid][TakeOverTimer]);
		Points[pointid][CaptureProccessEx] = 2;
		Points[pointid][CaptureProccess] = CreateDynamic3DTextLabel(string, COLOR_YELLOW, Points[pointid][Pointx], Points[pointid][Pointy], Points[pointid][Pointz], 10.0, _, _, _, _, _,_);
	}
	return 1;
}

stock SaveTurfWar(turfid)
{
	new string[128];
	format(string, sizeof(string), "UPDATE `turfs` SET data='%s|%d|%d|%d|%d|%f|%f|%f|%f' WHERE id = %d",
	g_mysql_ReturnEscaped(TurfWars[turfid][twName], MainPipeline),
	TurfWars[turfid][twOwnerId],
	TurfWars[turfid][twLocked],
	TurfWars[turfid][twSpecial],
	TurfWars[turfid][twVulnerable],
	TurfWars[turfid][twMinX],
	TurfWars[turfid][twMinY],
	TurfWars[turfid][twMaxX],
	TurfWars[turfid][twMaxY],
	turfid);
	mysql_function_query(MainPipeline, string, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	return 1;
}

stock SaveTurfWars()
{
	for(new i; i < MAX_TURFS; i++)
	{
		SaveTurfWar(i);
	}
}

forward OnLoadTurfWars();
public OnLoadTurfWars()
{
	new i, rows, fields, tmp[128];
	cache_get_data(rows, fields, MainPipeline);
	while(i < rows)
	{
		cache_get_field_content(i, "data", tmp, MainPipeline);
		if(!sscanf(tmp, "p<|>s[64]iiiiffff",
			TurfWars[i][twName],
			TurfWars[i][twOwnerId],
			TurfWars[i][twLocked],
			TurfWars[i][twSpecial],
			TurfWars[i][twVulnerable],
			TurfWars[i][twMinX],
			TurfWars[i][twMinY],
			TurfWars[i][twMaxX],
			TurfWars[i][twMaxY]
		)) CreateTurfWarsZone(0, i++);
	}
	if(i) printf("[LoadTurfWars] %d turfs loaded.", i);
	else printf("[LoadTurfWars] Failed to load any turfs.");
	return 1;
}

stock LoadTurfWars() {
	printf("[LoadTurfWars] Loading data from database...");
	mysql_function_query(MainPipeline, "SELECT * FROM `turfs`", true, "OnLoadTurfWars", "");
}

stock InitTurfWars()
{
	for(new i = 0; i < MAX_TURFS; i++)
	{
	    TurfWars[i][twOwnerId] = -1;
	    TurfWars[i][twActive] = 0;
	    TurfWars[i][twLocked] = 0;
	    TurfWars[i][twSpecial] = 0;
	    TurfWars[i][twTimeLeft] = 0;
	    TurfWars[i][twVulnerable] = 12;
	    TurfWars[i][twAttemptId] = -1;
	    TurfWars[i][twGangZoneId] = -1;
	    TurfWars[i][twAreaId] = -1;
	    TurfWars[i][twFlash] = -1;
	    TurfWars[i][twFlashColor] = 0;
	}
	return 1;
}

stock CreateTurfWarsZone(forcesync, zone)
{

    if(TurfWars[zone][twMinX] != 0.0 && TurfWars[zone][twMinY] != 0.0 && TurfWars[zone][twMaxX] != 0.0 && TurfWars[zone][twMaxY] != 0.0) {
 		TurfWars[zone][twGangZoneId] = GangZoneCreate(TurfWars[zone][twMinX],TurfWars[zone][twMinY],TurfWars[zone][twMaxX],TurfWars[zone][twMaxY]);
   		TurfWars[zone][twAreaId] = CreateDynamicRectangle(TurfWars[zone][twMinX],TurfWars[zone][twMinY],TurfWars[zone][twMaxX],TurfWars[zone][twMaxY],-1,-1,-1);
	}

	if(forcesync) {
	    SyncTurfWarsRadarToAll();
	}

	SaveTurfWar(zone);
}

stock ResetTurfWarsZone(forcesync, zone)
{
	TurfWars[zone][twActive] = 0;
	TurfWars[zone][twFlash] = -1;
	TurfWars[zone][twFlashColor] = 0;
	TurfWars[zone][twTimeLeft] = 0;
	TurfWars[zone][twAttemptId] = -1;

	if(forcesync) {
	    SyncTurfWarsRadarToAll();
	}

	SaveTurfWar(zone);
}

stock SetOwnerTurfWarsZone(forcesync, zone, ownerid)
{
	TurfWars[zone][twOwnerId] = ownerid;

	if(forcesync) {
	    SyncTurfWarsRadarToAll();
	}

	SaveTurfWar(zone);
}

stock DestroyTurfWarsZone(zone)
{
	TurfWars[zone][twActive] = 0;

	if(TurfWars[zone][twGangZoneId] != -1) {
	    GangZoneDestroy(TurfWars[zone][twGangZoneId]);
	}

	if(TurfWars[zone][twAreaId] != -1) {
	    DestroyDynamicArea(TurfWars[zone][twAreaId]);
	}

	TurfWars[zone][twMinX] = 0;
	TurfWars[zone][twMinY] = 0;
	TurfWars[zone][twMaxX] = 0;
	TurfWars[zone][twMaxY] = 0;
 	TurfWars[zone][twOwnerId] = -1;
	TurfWars[zone][twGangZoneId] = -1;
	TurfWars[zone][twAreaId] = -1;
	TurfWars[zone][twFlash] = -1;
	TurfWars[zone][twFlashColor] = 0;
	TurfWars[zone][twActive] = 0;
 	TurfWars[zone][twLocked] = 0;
 	TurfWars[zone][twSpecial] = 0;
 	TurfWars[zone][twTimeLeft] = 0;
 	TurfWars[zone][twAttemptId] = -1;
	TurfWars[zone][twVulnerable] = 12;

	SyncTurfWarsRadarToAll();
	SaveTurfWar(zone);

}

stock GetPlayerTurfWarsZone(playerid)
{
	for(new i = 0; i < MAX_TURFS; i++) {
    	if(IsPlayerInDynamicArea(playerid, TurfWars[i][twAreaId])) {
    	    return i;
    	}
	}
	return -1;
}

stock ShutdownTurfWarsZone(zone)
{
	new string[128];
	//foreach(new i: Player)
	for(new i = 0; i < MAX_PLAYERS; ++i)
	{
		if(IsPlayerConnected(i))
		{
			if(IsPlayerInDynamicArea(i, TurfWars[zone][twAreaId])) {
				format(string,sizeof(string),"Law Enforcement has attempted to shutdown this turf!");
				SendClientMessageEx(i,COLOR_YELLOW,string);
			}
		}	
	}
	ResetTurfWarsZone(0, zone);

	TurfWars[zone][twActive] = 1;
	TurfWars[zone][twTimeLeft] = 600;
	TurfWars[zone][twVulnerable] = 0;
	TurfWars[zone][twAttemptId] = -2;
	TurfWars[zone][twFlash] = 1;
	TurfWars[zone][twFlashColor] = 0;

	SyncTurfWarsRadarToAll();

	SaveTurfWar(zone);
}

stock TakeoverTurfWarsZone(familyid, zone)
{
	new string[128];
	//forreach(new i: Player)
	for(new i = 0; i < MAX_PLAYERS; ++i)
	{
		if(IsPlayerConnected(i))
		{
			if(IsPlayerInDynamicArea(i, TurfWars[zone][twAreaId])) {
				format(string,sizeof(string),"%s has attempted to takeover this turf for their own!",FamilyInfo[familyid][FamilyName]);
				SendClientMessageEx(i,COLOR_YELLOW,string);
			}
		}	
	}
	ResetTurfWarsZone(0, zone);

	TurfWars[zone][twActive] = 1;
	TurfWars[zone][twTimeLeft] = 600;
	TurfWars[zone][twVulnerable] = 0;
	TurfWars[zone][twAttemptId] = familyid;
	TurfWars[zone][twFlash] = 1;
	TurfWars[zone][twFlashColor] = FamilyInfo[familyid][FamilyColor];

	SyncTurfWarsRadarToAll();
}

stock CaptureTurfWarsZone(familyid, zone)
{
	new string[128];
	//foreach(new i: Player)
	for(new i = 0; i < MAX_PLAYERS; ++i)
	{
		if(IsPlayerConnected(i))
		{
		    if(turfWarsMiniMap[i] == 1)
			{
				turfWarsMiniMap[i] = 0;
				SetPlayerToTeamColor(i);
			}
			if(IsPlayerInDynamicArea(i, TurfWars[zone][twAreaId])) {
			    if(familyid != -2) {
					format(string,sizeof(string),"%s has successfully claimed this turf for their own!",FamilyInfo[familyid][FamilyName]);
					SendClientMessageEx(i,COLOR_RED,string);
					//SendAudioToPlayer(i, 62, 100);
				}
				else {
					format(string,sizeof(string),"Law Enforcement has successfully shut down this turf!",FamilyInfo[familyid][FamilyName]);
					SendClientMessageEx(i,COLOR_RED,string);
				}
			}
			if(PlayerInfo[i][pGangModerator] >= 1) {
			    if(familyid != -2) {
					format(string,sizeof(string),"%s has successfully claimed turf %d",FamilyInfo[familyid][FamilyName], zone);
					SendClientMessageEx(i,COLOR_RED,string);
				}
				else {
					format(string,sizeof(string),"Law Enforcement has successfully shut down turf %d",FamilyInfo[familyid][FamilyName], zone);
					SendClientMessageEx(i,COLOR_RED,string);
				}
			}
		}	
	}
	if(familyid != -2) TurfWars[zone][twOwnerId] = familyid;
	else TurfWars[zone][twOwnerId] = -1;
	SaveTurfWar(zone);
}

stock ExtortionTurfsWarsZone(playerid, type, money)
{
    if(GetPlayerTurfWarsZone(playerid) != -1)
	{
	    if(GetPlayerInterior(playerid) != 0) return 1; // Interior fix
	    new string[128];
 		new tw = GetPlayerTurfWarsZone(playerid);
		switch(type)
		{
			case 1: // Drugs
			{
			    if(TurfWars[tw][twOwnerId] != -1)
			    {
			        new ownerid = TurfWars[tw][twOwnerId];
			        new famid = PlayerInfo[playerid][pFMember];
			        if(famid != ownerid)
			        {
						format(string,sizeof(string),"* You have been taxed $%d dollars for selling drugs on %s's Turf.",money/4,FamilyInfo[ownerid][FamilyName]);
						FamilyInfo[ownerid][FamilyCash] += money/4;
						GivePlayerCash(playerid, -money/4);
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
						SaveFamily(ownerid);
					}
				}
			}
			case 2: // Vests
			{
			    if(TurfWars[tw][twOwnerId] != -1)
			    {
			        new ownerid = TurfWars[tw][twOwnerId];
			        new famid = PlayerInfo[playerid][pFMember];
			        if(famid != ownerid)
			        {
						format(string,sizeof(string),"* You have been taxed $%d dollars for selling vests on %s's Turf.",money/4,FamilyInfo[ownerid][FamilyName]);
						FamilyInfo[ownerid][FamilyCash] += money/4;
						GivePlayerCash(playerid, -money/4);
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
						SaveFamily(ownerid);
					}
				}
			}
			case 3: // Weapons
			{
			    if(TurfWars[tw][twOwnerId] != -1)
			    {
			        new ownerid = TurfWars[tw][twOwnerId];
			        new famid = PlayerInfo[playerid][pFMember];
			        if(famid != ownerid)
			        {
						format(string,sizeof(string),"* You have been taxed $%d dollars for selling weapons on %s's Turf.",money/4,FamilyInfo[ownerid][FamilyName]);
						FamilyInfo[ownerid][FamilyCash] += money/4;
						GivePlayerCash(playerid, -money/4);
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
						SaveFamily(ownerid);
					}
				}
			}
			case 4: // Sex
			{
			    if(TurfWars[tw][twOwnerId] != -1)
			    {
			        new ownerid = TurfWars[tw][twOwnerId];
			        new famid = PlayerInfo[playerid][pFMember];
			        if(famid != ownerid)
			        {
						format(string,sizeof(string),"* You have been taxed $%d dollars for selling sex on %s's Turf.",money/4,FamilyInfo[ownerid][FamilyName]);
						FamilyInfo[ownerid][FamilyCash] += money/4;
						GivePlayerCash(playerid, -money/4);
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
						SaveFamily(ownerid);
					}
				}
			}
			case 5: // Fireworks
			{
			    if(TurfWars[tw][twOwnerId] != -1)
			    {
			        new ownerid = TurfWars[tw][twOwnerId];
			        new famid = PlayerInfo[playerid][pFMember];
			        if(famid != ownerid)
			        {
						format(string,sizeof(string),"* You have been taxed $%d dollars for selling fireworks on %s's Turf.",money/4,FamilyInfo[ownerid][FamilyName]);
						FamilyInfo[ownerid][FamilyCash] += money/4;
						GivePlayerCash(playerid, -money/4);
						SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
						SaveFamily(ownerid);
					}
				}
			}
		}
	}
	return 1;
}

stock ShowTurfWarsRadar(playerid)
{
	if(turfWarsRadar[playerid] == 1) { return 1; }
	turfWarsRadar[playerid] = 1;
	SyncTurfWarsRadar(playerid);
    return 1;
}

stock HideTurfWarsRadar(playerid)
{
	if(turfWarsRadar[playerid] == 0) { return 1; }
	for(new i = 0; i < MAX_TURFS; i++) {
	    if(TurfWars[i][twGangZoneId] != -1) {
	    	GangZoneHideForPlayer(playerid,TurfWars[i][twGangZoneId]);
		}
	}
	turfWarsRadar[playerid] = 0;
	return 1;
}

stock SyncTurfWarsRadarToAll()
{
	//foreach(new i: Player)
	for(new i = 0; i < MAX_PLAYERS; ++i)
	{
		if(IsPlayerConnected(i))
		{
			SyncTurfWarsRadar(i);
		}	
	}
}

stock SyncTurfWarsRadar(playerid)
{
	if(turfWarsRadar[playerid] == 0) { return 1; }
	HideTurfWarsRadar(playerid);
	turfWarsRadar[playerid] = 1;
	for(new i = 0; i < MAX_TURFS; i++)
	{
	    if(TurfWars[i][twGangZoneId] != -1)
	    {
	        if(TurfWars[i][twOwnerId] >= 0 && TurfWars[i][twOwnerId] <= MAX_FAMILY-1)
	        {
	            switch(FamilyInfo[TurfWars[i][twOwnerId]][FamilyColor])
	            {
	                case 0: // Black
	                {
	            		GangZoneShowForPlayer(playerid,TurfWars[i][twGangZoneId],COLOR_TWBLACK);
					}
					case 1: // White
					{
					    GangZoneShowForPlayer(playerid,TurfWars[i][twGangZoneId],COLOR_TWWHITE);
					}
					case 2: // Red
					{
					    GangZoneShowForPlayer(playerid,TurfWars[i][twGangZoneId],COLOR_TWRED);
					}
					case 3: // Blue
					{
					    GangZoneShowForPlayer(playerid,TurfWars[i][twGangZoneId],COLOR_TWBLUE);
					}
					case 4: // Yellow
					{
					    GangZoneShowForPlayer(playerid,TurfWars[i][twGangZoneId],COLOR_TWYELLOW);
					}
					case 5: // Purple
					{
					    GangZoneShowForPlayer(playerid,TurfWars[i][twGangZoneId],COLOR_TWPURPLE);
					}
					case 6: // Pink
					{
					    GangZoneShowForPlayer(playerid,TurfWars[i][twGangZoneId],COLOR_TWPINK);
					}
					case 7: // Brown
					{
					    GangZoneShowForPlayer(playerid,TurfWars[i][twGangZoneId],COLOR_TWBROWN);
					}
					case 8: // Gray
					{
					    GangZoneShowForPlayer(playerid,TurfWars[i][twGangZoneId],COLOR_TWGRAY);
					}
					case 9: // Olive
					{
					    GangZoneShowForPlayer(playerid,TurfWars[i][twGangZoneId],COLOR_TWOLIVE);
					}
					case 10: // Tan
					{
					    GangZoneShowForPlayer(playerid,TurfWars[i][twGangZoneId],COLOR_TWTAN);
					}
					case 11: // Aqua
					{
					    GangZoneShowForPlayer(playerid,TurfWars[i][twGangZoneId],COLOR_TWAQUA);
					}
					case 12: // Orange
					{
					    GangZoneShowForPlayer(playerid,TurfWars[i][twGangZoneId],COLOR_TWORANGE);
					}
					case 13: // Azure
					{
					    GangZoneShowForPlayer(playerid,TurfWars[i][twGangZoneId],COLOR_TWAZURE);
					}
					case 14: // Green
					{
					    GangZoneShowForPlayer(playerid,TurfWars[i][twGangZoneId],COLOR_TWGREEN);
					}
				}
	        }
	        else
	        {
	            GangZoneShowForPlayer(playerid,TurfWars[i][twGangZoneId],COLOR_BLACK);
	        }

	        if(TurfWars[i][twFlash] == 1)
	        {
	            switch(TurfWars[i][twFlashColor])
	            {
	                case 0: // Black
	                {
	            		GangZoneFlashForPlayer(playerid, TurfWars[i][twGangZoneId],COLOR_TWBLACK);
					}
					case 1: // White
					{
					    GangZoneFlashForPlayer(playerid, TurfWars[i][twGangZoneId],COLOR_TWWHITE);
					}
					case 2: // Red
					{
         				GangZoneFlashForPlayer(playerid, TurfWars[i][twGangZoneId],COLOR_TWRED);
					}
					case 3: // Blue
					{
					    GangZoneFlashForPlayer(playerid, TurfWars[i][twGangZoneId],COLOR_TWBLUE);
					}
					case 4: // Yellow
					{
					    GangZoneFlashForPlayer(playerid, TurfWars[i][twGangZoneId],COLOR_TWYELLOW);
					}
					case 5: // Purple
					{
					    GangZoneFlashForPlayer(playerid, TurfWars[i][twGangZoneId],COLOR_TWPURPLE);
					}
					case 6: // Pink
					{
					    GangZoneFlashForPlayer(playerid, TurfWars[i][twGangZoneId],COLOR_TWPINK);
					}
					case 7: // Brown
					{
					    GangZoneFlashForPlayer(playerid, TurfWars[i][twGangZoneId],COLOR_TWBROWN);
					}
					case 8: // Gray
					{
					    GangZoneFlashForPlayer(playerid, TurfWars[i][twGangZoneId],COLOR_TWGRAY);
					}
					case 9: // Olive
					{
					    GangZoneFlashForPlayer(playerid, TurfWars[i][twGangZoneId],COLOR_TWOLIVE);
					}
					case 10: // Tan
					{
					    GangZoneFlashForPlayer(playerid, TurfWars[i][twGangZoneId],COLOR_TWTAN);
					}
					case 11: // Aqua
					{
					    GangZoneFlashForPlayer(playerid, TurfWars[i][twGangZoneId],COLOR_TWAQUA);
					}
					case 12: // Orange
					{
					    GangZoneFlashForPlayer(playerid, TurfWars[i][twGangZoneId],COLOR_TWORANGE);
					}
					case 13: // Azure
					{
					    GangZoneFlashForPlayer(playerid, TurfWars[i][twGangZoneId],COLOR_TWAZURE);
					}
					case 14: // Green
					{
					    GangZoneFlashForPlayer(playerid, TurfWars[i][twGangZoneId],COLOR_TWGREEN);
					}
				}
	        }
	        else
	        {
	            GangZoneStopFlashForPlayer(playerid, TurfWars[i][twGangZoneId]);
	        }
	    }
	}
	return 1;
}

CMD:turfinfo(playerid, params[])
{
    if(GetPlayerTurfWarsZone(playerid) != -1) {
        new string[128];
        new tw = GetPlayerTurfWarsZone(playerid);
        format(string,sizeof(string),"|___________ (ID: %d) %s ___________|",tw,TurfWars[tw][twName]);
        SendClientMessageEx(playerid, COLOR_GREEN, string);
        if(TurfWars[tw][twOwnerId] != -1) {
            format(string,sizeof(string),"Owner: %s.",FamilyInfo[TurfWars[tw][twOwnerId]][FamilyName]);
        }
        else {
            format(string,sizeof(string),"Owner: Vacant.");
        }
        SendClientMessageEx(playerid, COLOR_WHITE, string);
        format(string,sizeof(string),"Vulnerable: %d Hours.",TurfWars[tw][twVulnerable]);
        SendClientMessageEx(playerid, COLOR_WHITE, string);
        format(string,sizeof(string),"Locked: %d.",TurfWars[tw][twLocked]);
        SendClientMessageEx(playerid, COLOR_WHITE, string);
        format(string,sizeof(string),"Active: %d.",TurfWars[tw][twActive]);
        SendClientMessageEx(playerid, COLOR_WHITE, string);
        if(TurfWars[tw][twActive] != 0) {
            format(string,sizeof(string),"Time Left: %d Secs.",TurfWars[tw][twTimeLeft]);
            SendClientMessageEx(playerid, COLOR_WHITE, string);
            if(TurfWars[tw][twAttemptId] == -2) {
                format(string,sizeof(string),"Takeover Faction: Law Enforcement.");
                SendClientMessageEx(playerid, COLOR_WHITE, string);
            }
            else {
                format(string,sizeof(string),"Takeover Family: %s.",FamilyInfo[TurfWars[tw][twAttemptId]][FamilyName]);
                SendClientMessageEx(playerid, COLOR_WHITE, string);
            }
        }
        switch(TurfWars[tw][twSpecial]) {
            case 1:
            {
                format(string,sizeof(string),"Special Perks: Extortion.");
            }
            default:
            {
                format(string,sizeof(string),"Special Perks: None.");
            }
        }
        SendClientMessageEx(playerid, COLOR_WHITE, string);
    }
    else {
        SendClientMessageEx(playerid, COLOR_WHITE, "You are not in a turf!");
    }
    return 1;
}

CMD:savetwpos(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] > 3 || PlayerInfo[playerid][pGangModerator] >= 1) {
        new string[128];
        new tw = GetPVarInt(playerid, "EditingTurfs");
        new stage = GetPVarInt(playerid, "EditingTurfsStage");
        new Float:x, Float: y, Float: z;
        new Float:tminx, Float: tminy, Float: tmaxx, Float: tmaxy;
        GetPlayerPos(playerid, x, y, z);
        if(stage == -1) {
            SendClientMessageEx(playerid, COLOR_GRAD2, "You are not editing any Turf Dimensions right now!");
            return 1;
        }
        else {
            switch(stage) {
                case 1:
                {
                    SetPVarFloat(playerid, "EditingTurfsMinX", x);
                    format(string,sizeof(string),"X=%f, Y=%f, Z=%f",x,y,z);
                    SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully edited Turf West Wall.");
                    SendClientMessageEx(playerid, COLOR_GRAD2, string);
                    SendClientMessageEx(playerid, COLOR_WHITE, "Goto a location and type (/savetwpos) to edit the South Wall.");
                    SetPVarInt(playerid, "EditingTurfsStage", 2);
                }
                case 2:
                {
                    SetPVarFloat(playerid, "EditingTurfsMinY", y);
                    format(string,sizeof(string),"X=%f, Y=%f, Z=%f",x,y,z);
                    SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully edited Turf South Wall.");
                    SendClientMessageEx(playerid, COLOR_GRAD2, string);
                    SendClientMessageEx(playerid, COLOR_WHITE, "Goto a location and type (/savetwpos) to edit the East Wall.");
                    SetPVarInt(playerid, "EditingTurfsStage", 3);
                }
                case 3:
                {
                    SetPVarFloat(playerid, "EditingTurfsMaxX", x);
                    format(string,sizeof(string),"X=%f, Y=%f, Z=%f",x,y,z);
                    SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully edited Turf East Wall.");
                    SendClientMessageEx(playerid, COLOR_GRAD2, string);
                    SendClientMessageEx(playerid, COLOR_WHITE, "Goto a location and type (/savetwpos) to edit the North Wall.");
                    SetPVarInt(playerid, "EditingTurfsStage", 4);
                }
                case 4:
                {
                    SetPVarFloat(playerid, "EditingTurfsMaxY", y);
                    format(string,sizeof(string),"X=%f, Y=%f, Z=%f",x,y,z);
                    SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully edited Turf North Wall.");
                    SendClientMessageEx(playerid, COLOR_GRAD2, string);
                    format(string,sizeof(string),"You have successfully re-created (TurfID: %d) %s.",tw,TurfWars[tw][twName]);
                    SendClientMessageEx(playerid, COLOR_WHITE, string);
                    SetPVarInt(playerid, "EditingTurfsStage", -1);

                    DestroyTurfWarsZone(tw);

                    tminx = GetPVarFloat(playerid, "EditingTurfsMinX");
                    tminy = GetPVarFloat(playerid, "EditingTurfsMinY");
                    tmaxx = GetPVarFloat(playerid, "EditingTurfsMaxX");
                    tmaxy = GetPVarFloat(playerid, "EditingTurfsMaxY");

                    TurfWars[tw][twMinX] = tminx;
                    TurfWars[tw][twMinY] = tminy;
                    TurfWars[tw][twMaxX] = tmaxx;
                    TurfWars[tw][twMaxY] = tmaxy;

                    SetPVarFloat(playerid, "EditingTurfsMinX", 0.0);
                    SetPVarFloat(playerid, "EditingTurfsMinY", 0.0);
                    SetPVarFloat(playerid, "EditingTurfsMaxX", 0.0);
                    SetPVarFloat(playerid, "EditingTurfsMaxY", 0.0);

                    CreateTurfWarsZone(1,tw);
                    ShowPlayerDialog(playerid,TWEDITTURFSMENU,DIALOG_STYLE_LIST,"Turf Wars - Edit Turfs Menu:","Edit Dimensions...\nEdit Owners...\nEdit Vulnerable Time...\nEdit Locked...\nEdit Perks...\nReset War...\nDestroy Turf","Select","Back");
                }
            }
        }
    }
    else {
        SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use this command!");
    }
    return 1;
}

CMD:twmenu(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] > 3 || PlayerInfo[playerid][pGangModerator] >= 1)
	{
        ShowPlayerDialog(playerid,TWADMINMENU,DIALOG_STYLE_LIST,"Turf Wars - Admin Menu:","Edit Turfs...\nEdit Family Colors...","Select","Exit");
    }
    else
	{
        SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use this command!");
    }
    return 1;
}

CMD:turfs(playerid, params[])
{
    if(turfWarsRadar[playerid] == 0) {
        SendClientMessageEx(playerid, COLOR_WHITE, "You have enabled the Turf Minimap Radar.");
        ShowTurfWarsRadar(playerid);
    }
    else {
        SendClientMessageEx(playerid, COLOR_WHITE, "You have disabled the Turf Minimap Radar.");
        HideTurfWarsRadar(playerid);
    }
    return 1;
}

CMD:shutdown(playerid, params[])
{
    if(IsACop(playerid)) {
        new string[128];
        new tw = GetPlayerTurfWarsZone(playerid);
        new rank = PlayerInfo[playerid][pRank];
        if(rank < 3) {
            SendClientMessageEx(playerid, COLOR_GRAD2, "You have to be at least Rank 3 to shutdown turfs!");
            return 1;
        }
        if(tw != -1) {
            if(TurfWars[tw][twLocked] == 1) {
                SendClientMessageEx(playerid, COLOR_GRAD2, "The turf is currently locked by a admin, you can not shutdown the turf!");
                return 1;
            }
            if(TurfWars[tw][twVulnerable] == 0) {
                if(TurfWars[tw][twActive] == 0) {
                    SendClientMessageEx(playerid, COLOR_GRAD2, "The turf isn't in a active turf war, you have no reason to shutdown the turf!");
                }
                else {
                    new count = 0;
                    if(TurfWars[tw][twAttemptId] == -2) {
                        SendClientMessageEx(playerid, COLOR_GRAD2, "The LEO Factions are already attempting to shutdown the turf war!");
                        return 1;
                    }

                    //foreach(new i: Player)
					for(new i = 0; i < MAX_PLAYERS; ++i)
					{
						if(IsPlayerConnected(i))
						{
							if(TurfWars[tw][twAttemptId] == PlayerInfo[i][pFMember]) {
								if(GetPlayerTurfWarsZone(i) == tw) {
									count++;
								}
							}
						}	
                    }
                    if(count != 0) {
                        format(string,sizeof(string),"There is still %d Attacking Members on the Turf, you must get rid of them before shuting down!",count);
                        SendClientMessageEx(playerid, COLOR_GRAD2, string);
                    }
                    else {
                        ShutdownTurfWarsZone(tw);
                    }
                }
            }
            else {
                SendClientMessageEx(playerid, COLOR_GRAD2, "This turf is currently not vulnerable, you are unable to shutdown!");
                SendClientMessageEx(playerid, COLOR_GRAD1, "If you are in FBI, You must contact a admin to lock down the turf with a IC Casefile.");
            }
        }
        else {
            SendClientMessageEx(playerid, COLOR_GRAD2, "You have to be in a turf to be able to shutdown turfs!");
        }
    }
    else {
        SendClientMessageEx(playerid, COLOR_GRAD2, "You are not in a LEO Faction, you can not shutdown turfs!");
    }
	return 1;
}


CMD:claim(playerid, params[])
{
	if(servernumber == 2)
	{
	    SendClientMessage(playerid, COLOR_WHITE, "This command is disabled!");
	    return 1;
	}
    new string[128];
    new tw = GetPlayerTurfWarsZone(playerid);
    new family = PlayerInfo[playerid][pFMember];
    new rank = PlayerInfo[playerid][pRank];
    if(family == INVALID_FAMILY_ID) {
        SendClientMessageEx(playerid, COLOR_GRAD2, "You are not in a family/gang, you can not claim turfs!");
        return 1;
    }
    if(rank < 5) {
        SendClientMessageEx(playerid, COLOR_GRAD2, "You have to be at least Rank 5 to claim turfs!");
        return 1;
    }
    if(FamilyInfo[family][FamilyTurfTokens] < 12) {
        SendClientMessageEx(playerid, COLOR_GRAD2, "Your family/gang does not have any turf claim tokens, please wait at least 12 hours.");
        return 1;
    }
    if(tw != -1) {
        if(TurfWars[tw][twLocked] == 1) {
            SendClientMessageEx(playerid, COLOR_GRAD2, "The turf is currently locked by a admin, you can not claim it!");
            return 1;
        }
        if(TurfWars[tw][twVulnerable] == 0) {
            if(TurfWars[tw][twActive] == 0) {
                if(TurfWars[tw][twOwnerId] == family) {
                    SendClientMessageEx(playerid, COLOR_GRAD2, "Your family/gang already owns this turf, you are unable to claim it!");
                    return 1;
                }
                new count = 0;
                //foreach(new i: Player)
				for(new i = 0; i < MAX_PLAYERS; ++i)
				{
					if(IsPlayerConnected(i))
					{
						if(family == PlayerInfo[i][pFMember] && PlayerInfo[i][pAccountRestricted] != 1) {
							if(GetPlayerTurfWarsZone(i) == tw) {
								count++;
							}
						}
					}	
                }

                if(count > 2) {
                    FamilyInfo[family][FamilyTurfTokens] -= 12;
                    TakeoverTurfWarsZone(family, tw);
                }
                else {
                    SendClientMessageEx(playerid, COLOR_GRAD2, "You need at least 3 of your family/gang members on the turf, to be able to claim it!");
                }
            }
            else {
                new count = 0;
                new leocount = 0;
                if(TurfWars[tw][twAttemptId] == family) {
                    SendClientMessageEx(playerid, COLOR_GRAD2, "You are already attempting to capture this turf!");
                    return 1;
                }

                //foreach(new i: Player)
				for(new i = 0; i < MAX_PLAYERS; ++i)
				{
					if(IsPlayerConnected(i))
					{
						if(TurfWars[tw][twAttemptId] == PlayerInfo[i][pFMember]) {
							if(GetPlayerTurfWarsZone(i) == tw) {
								count++;
							}
						}
						if(TurfWars[tw][twAttemptId] == -2) {
							if(IsACop(i)) {
								if(GetPlayerTurfWarsZone(i) == tw) {
									leocount++;
								}
							}
						}
					}	
                }

                if(count == 0 && leocount == 0) {
                    if(family != TurfWars[tw][twOwnerId]) {
                        FamilyInfo[family][FamilyTurfTokens] -= 12;
                    }
                    //foreach(new i: Player)
					for(new i = 0; i < MAX_PLAYERS; ++i)
					{
						if(IsPlayerConnected(i))
						{
							if(PlayerInfo[i][pGangModerator] >= 1) {
								format(string,sizeof(string),"%s has attempted to takeover turf %d for family %s",GetPlayerNameEx(playerid),tw,FamilyInfo[family][FamilyName]);
								SendClientMessageEx(i,COLOR_YELLOW,string);
							}
						}	
                    }
                    TakeoverTurfWarsZone(family, tw);
                }
                else {
                    if(leocount == 0) {
                        format(string,sizeof(string),"There is still %d Attacking Members on the Turf, you must get rid of them before reclaiming!",count);
                        SendClientMessageEx(playerid, COLOR_GRAD2, string);
                    }
                    else {
                        format(string,sizeof(string),"There is still %d Officers on the Turf, you must get rid of them before reclaiming!",leocount);
                        SendClientMessageEx(playerid, COLOR_GRAD2, string);
                    }
                }
            }
        }
        else {
            SendClientMessageEx(playerid, COLOR_GRAD2, "This turf is currently not vulnerable, you are unable to claim it!");
        }
    }
    else {
        SendClientMessageEx(playerid, COLOR_GRAD2, "You have to be in a turf to be able to claim turfs!");
    }

    if(turfWarsRadar[playerid] == 0) {
        ShowTurfWarsRadar(playerid);
    }
    return 1;
}

CMD:setcapping(playerid, params[]) {
	if(PlayerInfo[playerid][pAdmin] >= 4) {
		if(isnull(params)) {
			return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /setcapping [ping]");
		}

		new
			iPingas = strval(params);

		if(!(250 <= iPingas <= 1000)) {
			return SendClientMessageEx(playerid, COLOR_WHITE, "The specified ping limit can not be lower than 250 or higher than 1000.");
		}

		new
			szMessage[58 + MAX_PLAYER_NAME];

		format(szMessage, sizeof(szMessage), "AdmCmd: %s has adjusted the /capture ping limit to %d.", GetPlayerNameEx(playerid), iPingas);
		ABroadCast(COLOR_LIGHTRED, szMessage, 4);
		pointpinglimit = iPingas;
	}
	return 1;
}

CMD:gotofpoint(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] > 2) 
	{
		new points, string[128];
		if(sscanf(params, "d", points)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /gotofpoint [pointid]");
		if(points < 1 || points > 9) return SendClientMessageEx(playerid, COLOR_GREY, "Invalid point id!");
		
		SetPlayerPos(playerid, Points[points][Pointx], Points[points][Pointy], Points[points][Pointz]), SetPlayerVirtualWorld(playerid, Points[points][pointVW]);
		format(string, sizeof(string), "You have teleported to family point %d", points);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
	}
	else return SendClientMessageEx(playerid, COLOR_GREY, "You're not authorized to use this command!");
	return 1;
}	
CMD:capture(playerid, params[])
{
    if(servernumber == 2)
	{
	    SendClientMessage(playerid, COLOR_WHITE, "This command is disabled!");
	    return 1;
	}
	new string[128];
	new myvw = GetPlayerVirtualWorld(playerid);

	new mypoint = -1;
	if(GetPVarInt(playerid,"Injured") == 1)
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, " You can not capture while injured!");
		return 1;
	}
	if (PlayerInfo[playerid][pFMember] == INVALID_FAMILY_ID || PlayerInfo[playerid][pRank] < 5)
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, " You are not high rank enough to capture!");
		return 1;
	}
	for (new i=0; i<MAX_POINTS; i++)
	{
		if (IsPlayerInRangeOfPoint(playerid, 1.0, Points[i][Pointx], Points[i][Pointy], Points[i][Pointz]))
		{
			if(myvw == Points[i][pointVW])
			{
				mypoint = i;
			}
		}		
	}
	if (mypoint == -1)
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, " You are not at the capture place!");
		return 1;
	}
	if (Points[mypoint][Vulnerable] > 0)
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, " This point is not ready for takeover.");
		return 1;
	}
	if (Points[mypoint][TimeToClaim])
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, " This point is already being captured!");
		return 1;
	}
	if(GetPlayerPing(playerid) > pointpinglimit)
	{
		format(string,sizeof(string), " You can not capture with %d+ ping!", pointpinglimit);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
		return 1;
	}
	format(string,sizeof(string), " %s is attempting to capture the point (VW: %d).", GetPlayerNameEx(playerid), Points[mypoint][pointVW]);
	ProxDetector(70.0, playerid, string, COLOR_RED,COLOR_RED,COLOR_RED,COLOR_RED,COLOR_RED);
	GetPlayerPos(playerid, Points[mypoint][Capturex], Points[mypoint][Capturey], Points[mypoint][Capturez]);

	Points[mypoint][ClaimerId] = playerid;
	Points[mypoint][TimeToClaim] = 1;
	Points[mypoint][TimeLeft] = 10;
	SetTimerEx("ProgressTimer", 1000, 0, "d", mypoint);
	return 1;
}

CMD:points(playerid, params[])
{
	new string[128];

	for(new i; i < MAX_POINTS; i++)
	{
		if (Points[i][Type] >= 0)
		{
			if(Points[i][pointID] != 0)
			{
				format(string, sizeof(string), "Point ID: %d | Name: %s | Owner: %s | Captured By: %s | Hours: %d",
				Points[i][pointID], Points[i][Name],Points[i][Owner],Points[i][CapperName],Points[i][Vulnerable]);
				SendClientMessageEx(playerid, COLOR_WHITE, string);
			}
		}
	}
	return 1;
}

CMD:pointtime(playerid, params[])
{
	new point, string[128];
	if(sscanf(params, "i", point)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /pointtime [pointid]");
	
	if(point < 1 || point > 9) return SendClientMessageEx(playerid, COLOR_GRAD2, "Invalid ID!");
	
	if(Points[point-1][TakeOverTimerStarted])
	{
		if(Points[point-1][TakeOverTimer] > 0)
		{
			format(string, sizeof(string), "Time left until fully captured: %d minutes.", Points[point-1][TakeOverTimer]);
			SendClientMessageEx(playerid, COLOR_YELLOW, string);
		}
		else return SendClientMessageEx(playerid, COLOR_GRAD2, "This point is not being captured at the moment.");
	}	
	else return SendClientMessageEx(playerid, COLOR_GRAD2, "This point is not being captured at the moment.");
	return 1;
}

CMD:pedit(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pGangModerator] >= 2)
	{
		new string[128], hours;
		if(sscanf(params, "d", hours))
		{
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /pedit [hours]");
			SendClientMessageEx(playerid, COLOR_GREY, "HINT: Stand close to a point to set the hours.");
			return 1;
		}

		for(new h = 0; h < sizeof(Points); h++)
		{
			if(IsPlayerInRangeOfPoint(playerid, 3.0, Points[h][Pointx], Points[h][Pointy], Points[h][Pointz]))
			{
				if(hours < 1|| hours > 24)
				{
					SendClientMessageEx(playerid, COLOR_GREY, "You can not set the point time lower than 1 or higher than 24!");
				}
				else if(hours >= 1|| hours <= 24)
				{
					format(string, sizeof(string), "You have set this point's time to %d hours !", hours);
					Points[h][Vulnerable] = hours;
					SendClientMessageEx(playerid, COLOR_WHITE, string);
					UpdatePoints();
				}
			}
		}
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use this command.");
	return 1;
}

CMD:pointfix(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pGangModerator] >= 2)
	{
		for(new h = 0; h < sizeof(Points); h++)
		{
			if(IsPlayerInRangeOfPoint(playerid, 3.0, Points[h][Pointx], Points[h][Pointy], Points[h][Pointz]))
			{
				Points[h][TimeToClaim] = 0;
				SendClientMessageEx(playerid, COLOR_WHITE, "You have fixed the point, players can now attempt to capture the point!");
				UpdatePoints();
				return 1;
			}
		}
		SendClientMessageEx(playerid, COLOR_GREY, "Error: You need to stand close to the capture point to fix it.");
	}
	else return SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use this command!");
	return 1;
}