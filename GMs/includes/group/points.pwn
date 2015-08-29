/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

					Points System

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

stock UpdatePoints()
{
	for(new i; i < MAX_POINTS; i++)
	{
		SavePoint(i);
	}
}

stock SavePoint(pid)
{
	new szQuery[2048];
	
	format(szQuery, sizeof(szQuery), "UPDATE `points` SET \
		`posx` = '%f', \
		`posy` = '%f', \
 		`posz` = '%f', \
		`vw` = '%d', \
		`type` = '%d', \
		`vulnerable` = '%d', \
		`matpoint` = '%d', \
		`owner` = '%s', \
		`cappername` = '%s', \
		`name` = '%s' WHERE `id` = %d",
		Points[pid][Pointx],
		Points[pid][Pointy],
		Points[pid][Pointz],
		Points[pid][pointVW],
		Points[pid][Type],
		Points[pid][Vulnerable],
		Points[pid][MatPoint],
		g_mysql_ReturnEscaped(Points[pid][Owner], MainPipeline),
		g_mysql_ReturnEscaped(Points[pid][CapperName], MainPipeline),
		g_mysql_ReturnEscaped(Points[pid][Name], MainPipeline),
		pid+1
	);	
		
	mysql_function_query(MainPipeline, szQuery, false, "OnQueryFinish", "i", SENDDATA_THREAD);	
}		

forward OnLoadPoints();
public OnLoadPoints()
{
	new fields, rows, index, result[128];
	cache_get_data(rows, fields, MainPipeline);

	while((index < rows))
	{
		cache_get_field_content(index, "id", result, MainPipeline); Points[index][pointID] = strval(result);
		cache_get_field_content(index, "posx", result, MainPipeline); Points[index][Pointx] = floatstr(result);
		cache_get_field_content(index, "posy", result, MainPipeline); Points[index][Pointy] = floatstr(result);
		cache_get_field_content(index, "posz", result, MainPipeline); Points[index][Pointz] = floatstr(result);
		cache_get_field_content(index, "vw", result, MainPipeline); Points[index][pointVW] = strval(result);
		cache_get_field_content(index, "type", result, MainPipeline); Points[index][Type] = strval(result);
		cache_get_field_content(index, "vulnerable", result, MainPipeline); Points[index][Vulnerable] = strval(result);
		cache_get_field_content(index, "matpoint", result, MainPipeline); Points[index][MatPoint] = strval(result);
		cache_get_field_content(index, "owner", Points[index][Owner], MainPipeline, 128);
		cache_get_field_content(index, "cappername", Points[index][CapperName], MainPipeline, MAX_PLAYER_NAME);
		cache_get_field_content(index, "name", Points[index][Name], MainPipeline, 128);
		cache_get_field_content(index, "captime", result, MainPipeline); Points[index][CapTime] = strval(result);
		cache_get_field_content(index, "capfam", result, MainPipeline); Points[index][CapFam] = strval(result);
		cache_get_field_content(index, "capname", Points[index][CapName], MainPipeline, MAX_PLAYER_NAME);
		
		Points[index][CaptureTimerEx2] = -1;
		Points[index][ClaimerId] = INVALID_PLAYER_ID;
		Points[index][PointPickupID] = CreateDynamicPickup(1239, 23, Points[index][Pointx], Points[index][Pointy], Points[index][Pointz], Points[index][pointVW]);
		
		if(Points[index][CapFam] != INVALID_GROUP_ID)
		{
			Points[index][CapCrash] = 1;
			Points[index][TakeOverTimerStarted] = 1;
			Points[index][ClaimerTeam] = Points[index][CapFam];
			Points[index][TakeOverTimer] = Points[index][CapTime];
			format(Points[index][PlayerNameCapping], MAX_PLAYER_NAME, "%s", Points[index][CapName]);
			ReadyToCapture(index);
			Points[index][CaptureTimerEx2] = SetTimerEx("CaptureTimerEx", 60000, 1, "d", index);	
		}
		
		index++;
	}
	if(index == 0) print("[Family Points] No family points has been loaded.");
	if(index != 0) printf("[Family Points] %d family points has been loaded.", index);
	return 1;
}

stock PointCrashProtection(point)
{
	new query[128], temp;
	temp = Points[point][ClaimerTeam];
	if(temp == INVALID_PLAYER_ID)
	{
		temp = INVALID_GROUP_ID;
	}
	format(query, sizeof(query), "UPDATE `points` SET `captime` = %d, `capfam` = %d, `capname` = '%s' WHERE `id` = %d",Points[point][TakeOverTimer], temp, Points[point][PlayerNameCapping], Points[point][pointID]);
	mysql_function_query(MainPipeline, query, false, "OnQueryFinish", "i", SENDDATA_THREAD);
	return 1;
}

stock LoadPoints()
{
	printf("[LoadFamilyPoints] Loading Family Points from the database, please wait...");
	mysql_function_query(MainPipeline, "SELECT * FROM `points`", true, "OnLoadPoints", "");
}	

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
			fam = PlayerInfo[claimer][pMember];
            Points[point][PlayerNameCapping] = GetPlayerNameEx(claimer);
		   	format(string, sizeof(string), "%s has attempted to take control of the %s for %s, it will be theirs in %d minutes.", Points[point][PlayerNameCapping], Points[point][Name], arrGroupData[fam][g_szGroupName], TIME_TO_TAKEOVER);
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
	foreach(new i: Player)
	{
		if(IsACriminal(i))
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
	if(Points[pointid][CapCrash] == 1)
	{
		format(string, sizeof(string), "%s has successfully attempted to take over of %s for %s, it will be theirs in %d minutes!", Points[pointid][PlayerNameCapping], Points[pointid][Name], arrGroupData[Points[pointid][ClaimerTeam]][g_szGroupName], Points[pointid][TakeOverTimer]);
		Points[pointid][CaptureProccessEx] = 2;
		Points[pointid][CaptureProccess] = CreateDynamic3DTextLabel(string, COLOR_YELLOW, Points[pointid][Pointx], Points[pointid][Pointy], Points[pointid][Pointz], 10.0, _, _, _, _, _,_);
	}
	return 1;
}

forward CaptureTimerEx(point);
public CaptureTimerEx(point)
{
	new string[128];
	new fam;
	if (Points[point][TakeOverTimerStarted])
	{
		fam = Points[point][ClaimerTeam];
		if (Points[point][TakeOverTimer] > 0)
		{
			Points[point][TakeOverTimer]--;
			format(string, sizeof(string), "%s has successfully attempted to take over of %s for %s, it will be theirs in %d minutes!",
			Points[point][PlayerNameCapping], Points[point][Name], arrGroupData[fam][g_szGroupName], Points[point][TakeOverTimer]);
			UpdateDynamic3DTextLabelText(Points[point][CaptureProccess], COLOR_YELLOW, string);
			PointCrashProtection(point);
		}
		else
		{
			Points[point][ClaimerTeam] = INVALID_PLAYER_ID;
			Points[point][TakeOverTimer] = 0;
			Points[point][TakeOverTimerStarted] = 0;
			Points[point][Announced] = 0;
			Points[point][CapCrash] = 0;
			Points[point][Vulnerable] = NEW_VULNERABLE+1;
			DestroyDynamic3DTextLabel(Points[point][CaptureProccess]);
			Points[point][CaptureProccessEx] = 0;
			strmid(Points[point][Owner], arrGroupData[fam][g_szGroupName], 0, 32, 32);
			strmid(Points[point][CapperName], Points[point][PlayerNameCapping], 0, 32, 32);
			format(string, sizeof(string), "%s has successfully taken control of the %s for %s.", Points[point][CapperName], Points[point][Name], Points[point][Owner]);
			SendClientMessageToAllEx(COLOR_YELLOW, string);
			UpdatePoints();
			PointCrashProtection(point);
			KillTimer(Points[point][CaptureTimerEx2]);
			Points[point][CaptureTimerEx2] = -1;
		}
	}
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
	if (!IsACriminal(playerid) || PlayerInfo[playerid][pRank] < arrGroupData[PlayerInfo[playerid][pMember]][g_iPointCapRank])
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

CMD:points2(playerid, params[])
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
	new i;
	if(sscanf(params, "i", i)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /pointtime [pointid]");
		
	if(!IsValidDynamicArea(arrPoint[i][po_iAreaID])) return SendClientMessageEx(playerid, COLOR_GRAD1, "This point does not exist.");

	if(arrPoint[i][po_iCaptureAble])
	{
		if(!GetGVarType("PO_CAPT", i)) return SendClientMessageEx(playerid, COLOR_GRAD1, "This point is being captured.");
		format(szMiscArray, sizeof(szMiscArray), "Time left until fully captured: %d minutes.", GetGVarInt("PO_Time", i));
		SendClientMessageEx(playerid, COLOR_YELLOW, szMiscArray);
	}
	else SendClientMessageEx(playerid, COLOR_GRAD2, "This point is not being captured at the moment.");
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