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

stock InitPaintballArenas()
{
    new string[64];
	for(new i = 0; i < MAX_ARENAS; i++)
	{
	    format(string, sizeof(string), "Unoccupied");
		strmid(PaintBallArena[i][pbOwner], string, 0, strlen(string), 64);

		format(string, sizeof(string), "None");
		strmid(PaintBallArena[i][pbPassword], string, 0, strlen(string), 64);

	    PaintBallArena[i][pbGameType] = 1;
  		PaintBallArena[i][pbActive] = 0;
  		PaintBallArena[i][pbExploitPerm] = 0;
		PaintBallArena[i][pbWar] = 0;
  		PaintBallArena[i][pbFlagInstagib] = 0;
  		PaintBallArena[i][pbFlagNoWeapons] = 0;
  		PaintBallArena[i][pbTimeLeft] = 900;
  		PaintBallArena[i][pbHealth] = 100;
   		PaintBallArena[i][pbArmor] = 99;
   		PaintBallArena[i][pbLocked] = 0;
		PaintBallArena[i][pbLimit] = 16;
		PaintBallArena[i][pbPlayers] = 0;
		PaintBallArena[i][pbTeamRed] = 0;
		PaintBallArena[i][pbTeamBlue] = 0;
		PaintBallArena[i][pbBidMoney] = 500;
		PaintBallArena[i][pbMoneyPool] = 0;
		PaintBallArena[i][pbWeapons][0] = 29;
		PaintBallArena[i][pbWeapons][1] = 24;
		PaintBallArena[i][pbWeapons][2] = 27;
		PaintBallArena[i][pbHillX] = 0.0;
		PaintBallArena[i][pbHillY] = 0.0;
		PaintBallArena[i][pbHillZ] = 0.0;
		PaintBallArena[i][pbHillRadius] = 0.0;
	}
	return 1;
}

stock ResetPaintballArena(arenaid)
{
	new string[64];

	format(string, sizeof(string), "Unoccupied");
	strmid(PaintBallArena[arenaid][pbOwner], string, 0, strlen(string), 64);
	format(string, sizeof(string), "None");
	strmid(PaintBallArena[arenaid][pbPassword], string, 0, strlen(string), 64);

	if(PaintBallArena[arenaid][pbGameType] == 3) {
	    if(PaintBallArena[arenaid][pbFlagRedActive] == 1) {
	        Delete3DTextLabel(PaintBallArena[arenaid][pbFlagRedTextID]);
		}
		if(PaintBallArena[arenaid][pbFlagBlueActive] == 1) {
		    Delete3DTextLabel(PaintBallArena[arenaid][pbFlagBlueTextID]);
		}
	    Delete3DTextLabel(PaintBallArena[arenaid][pbTeamRedTextID]);
		Delete3DTextLabel(PaintBallArena[arenaid][pbTeamBlueTextID]);
		DestroyDynamicObject(PaintBallArena[arenaid][pbFlagRedID]);
		DestroyDynamicObject(PaintBallArena[arenaid][pbFlagBlueID]);
	}

	if(PaintBallArena[arenaid][pbGameType] == 4 || PaintBallArena[arenaid][pbGameType] == 5) {
	    ResetPaintballArenaHill(arenaid);
	}

  	PaintBallArena[arenaid][pbGameType] = 1;
  	PaintBallArena[arenaid][pbActive] = 0;
  	PaintBallArena[arenaid][pbExploitPerm] = 0;
	PaintBallArena[arenaid][pbWar] = 0;
  	PaintBallArena[arenaid][pbFlagInstagib] = 0;
	PaintBallArena[arenaid][pbFlagNoWeapons] = 0;
  	PaintBallArena[arenaid][pbTimeLeft] = 900;
  	PaintBallArena[arenaid][pbHealth] = 100;
   	PaintBallArena[arenaid][pbArmor] = 99;
   	PaintBallArena[arenaid][pbLocked] = 0;
	PaintBallArena[arenaid][pbLimit] = 16;
	PaintBallArena[arenaid][pbPlayers] = 0;
	PaintBallArena[arenaid][pbTeamRed] = 0;
	PaintBallArena[arenaid][pbTeamBlue] = 0;
	PaintBallArena[arenaid][pbBidMoney] = 500;
	PaintBallArena[arenaid][pbMoneyPool] = 0;
	PaintBallArena[arenaid][pbWeapons][0] = 29;
	PaintBallArena[arenaid][pbWeapons][1] = 24;
	PaintBallArena[arenaid][pbWeapons][2] = 27;
	PaintBallArena[arenaid][pbTeamRedKills] = 0;
	PaintBallArena[arenaid][pbTeamBlueKills] = 0;
	PaintBallArena[arenaid][pbTeamRedDeaths] = 0;
	PaintBallArena[arenaid][pbTeamBlueDeaths] = 0;
	
	if(IsValidVehicleID(PaintBallArena[arenaid][pbVeh1ID]))
	{
		DestroyVehicle(PaintBallArena[arenaid][pbVeh1ID]);
	}
	if(IsValidVehicleID(PaintBallArena[arenaid][pbVeh2ID]))
	{
		DestroyVehicle(PaintBallArena[arenaid][pbVeh2ID]);
	}
	if(IsValidVehicleID(PaintBallArena[arenaid][pbVeh3ID]))
	{
		DestroyVehicle(PaintBallArena[arenaid][pbVeh3ID]);
	}
	if(IsValidVehicleID(PaintBallArena[arenaid][pbVeh4ID]))
	{
		DestroyVehicle(PaintBallArena[arenaid][pbVeh4ID]);
	}
	if(IsValidVehicleID(PaintBallArena[arenaid][pbVeh5ID]))
	{
		DestroyVehicle(PaintBallArena[arenaid][pbVeh5ID]);
	}
	if(IsValidVehicleID(PaintBallArena[arenaid][pbVeh6ID]))
	{
		DestroyVehicle(PaintBallArena[arenaid][pbVeh6ID]);
	}
	PaintBallArena[arenaid][pbVeh1ID] = INVALID_VEHICLE_ID;
	PaintBallArena[arenaid][pbVeh2ID] = INVALID_VEHICLE_ID;
	PaintBallArena[arenaid][pbVeh3ID] = INVALID_VEHICLE_ID;
	PaintBallArena[arenaid][pbVeh4ID] = INVALID_VEHICLE_ID;
	PaintBallArena[arenaid][pbVeh5ID] = INVALID_VEHICLE_ID;
	PaintBallArena[arenaid][pbVeh6ID] = INVALID_VEHICLE_ID;
	return 1;
}

stock CreatePaintballArenaHill(arenaid) {
	PaintBallArena[arenaid][pbHillTextID] = Create3DTextLabel("Hill", COLOR_GREEN, PaintBallArena[arenaid][pbHillX], PaintBallArena[arenaid][pbHillY], PaintBallArena[arenaid][pbHillZ], 200.0, PaintBallArena[arenaid][pbVirtual], 0);
}

stock ResetPaintballArenaHill(arenaid) {
    Delete3DTextLabel(PaintBallArena[arenaid][pbHillTextID]);
}

stock SortWinnerPaintballScores(arenaid)
{
	new highscore = 0;
	new score = 0;
	new winnerid;
	for(new i = 0; i < PaintBallArena[arenaid][pbLimit]; i++) {
	    //foreach(new p: Player) {
		for(new p = 0; p < MAX_PLAYERS; ++p)
		{
			if(IsPlayerConnected(p))
			{	
				if(GetPVarInt(p, "IsInArena") == arenaid) {
					score = PlayerInfo[p][pKills];
					if(score > highscore) {
						highscore = score;
						winnerid = p;
					}
				}
			}	
	    }
	}
	return winnerid;
}

stock SendPaintballArenaTextMessage(arenaid, style, message[])
{
	//foreach(new p: Player) {
	for(new p = 0; p < MAX_PLAYERS; ++p)
	{
		if(IsPlayerConnected(p))
		{	
			new carenaid = GetPVarInt(p, "IsInArena");
			if(arenaid == carenaid) {
				GameTextForPlayer(p, message, 5000, style);
			}
		}	
	}
	return 1;
}

stock SendPaintballArenaMessage(arenaid, color, message[])
{
	//foreach(new p: Player) {
	for(new p = 0; p < MAX_PLAYERS; ++p)
	{
		if(IsPlayerConnected(p))
		{	
			new carenaid = GetPVarInt(p, "IsInArena");
			if(arenaid == carenaid) {
				SendClientMessageEx(p, color, message);
			}
		}	
	}
	return 1;
}
/*
stock SendPaintballArenaSound(arenaid, soundid)
{
    foreach(new p: Player) {
   		new carenaid = GetPVarInt(p, "IsInArena");
   		if(arenaid == carenaid) {
	      	PlayerPlaySound(p, soundid, 0.0, 0.0, 0.0);
		}
	}
	return 1;
}

stock //SendPaintballArenaAudio(arenaid)
{
	foreach(new p: Player) {
	    new carenaid = GetPVarInt(p, "IsInArena");
	    if(arenaid == carenaid) {
	        //SendAudioToPlayer(p, soundid, volume);
	    }
	}
	return 1;
}

stock SendPaintballArenaAudioTeam(arenaid, team)
{
	foreach(new p: Player) {
	    new carenaid = GetPVarInt(p, "IsInArena");
	    if(arenaid == carenaid) {
	        if(PlayerInfo[p][pPaintTeam] == team) {
	            //SendAudioToPlayer(p, soundid, volume);
	        }
	    }
	}
}*/

stock ResetFlagPaintballArena(arenaid, flagid)
{
	switch(flagid)
	{
	    case 1: // Red Flag
	    {
	        if(PaintBallArena[arenaid][pbFlagRedActive] == 1)
	        {
	            Delete3DTextLabel(PaintBallArena[arenaid][pbFlagRedTextID]);
	        }
	        ////SendPaintballArenaAudio(arenaid, 24, 75);
	        //SetTimerEx("//SendPaintballArenaAudio", 250, false, "iii", arenaid, 29, 100);
	        PaintBallArena[arenaid][pbFlagRedActive] = 0;
	        SendPaintballArenaTextMessage(arenaid, 5, "~r~Red Flag ~w~Returned!");
	        DestroyDynamicObject(PaintBallArena[arenaid][pbFlagRedID]);
	        PaintBallArena[arenaid][pbFlagRedID] = CreateDynamicObject(RED_FLAG_OBJ, PaintBallArena[arenaid][pbFlagRedSpawn][0], PaintBallArena[arenaid][pbFlagRedSpawn][1], PaintBallArena[arenaid][pbFlagRedSpawn][2], 0.0, 0.0, 0.0, PaintBallArena[arenaid][pbVirtual], PaintBallArena[arenaid][pbInterior], -1);


	        PaintBallArena[arenaid][pbFlagRedPos][0] = PaintBallArena[arenaid][pbFlagRedSpawn][0];
	        PaintBallArena[arenaid][pbFlagRedPos][1] = PaintBallArena[arenaid][pbFlagRedSpawn][1];
	        PaintBallArena[arenaid][pbFlagRedPos][2] = PaintBallArena[arenaid][pbFlagRedSpawn][2];
	    }
	    case 2: // Blue Flag
	    {
	        if(PaintBallArena[arenaid][pbFlagBlueActive] == 1)
	        {
	            Delete3DTextLabel(PaintBallArena[arenaid][pbFlagBlueTextID]);
	        }
	        ////SendPaintballArenaAudio(arenaid, 24, 75);
	        //SetTimerEx("//SendPaintballArenaAudio", 250, false, "iii", arenaid, 11, 100);
	        PaintBallArena[arenaid][pbFlagBlueActive] = 0;
	        SendPaintballArenaTextMessage(arenaid, 5, "~b~Blue Flag ~w~Returned!");
	        DestroyDynamicObject(PaintBallArena[arenaid][pbFlagBlueID]);
	        PaintBallArena[arenaid][pbFlagBlueID] = CreateDynamicObject(BLUE_FLAG_OBJ, PaintBallArena[arenaid][pbFlagBlueSpawn][0], PaintBallArena[arenaid][pbFlagBlueSpawn][1], PaintBallArena[arenaid][pbFlagBlueSpawn][2], 0.0, 0.0, 0.0, PaintBallArena[arenaid][pbVirtual], PaintBallArena[arenaid][pbInterior], -1);

	        PaintBallArena[arenaid][pbFlagBluePos][0] = PaintBallArena[arenaid][pbFlagBlueSpawn][0];
	        PaintBallArena[arenaid][pbFlagBluePos][1] = PaintBallArena[arenaid][pbFlagBlueSpawn][1];
	        PaintBallArena[arenaid][pbFlagBluePos][2] = PaintBallArena[arenaid][pbFlagBlueSpawn][2];
	    }
	}
}

stock ScoreFlagPaintballArena(playerid, arenaid, flagid)
{
	new string[128];
	switch(flagid)
	{
	    case 1: // Red Flag
	    {
	        if(PaintBallArena[arenaid][pbFlagInstagib] == 1)
	        {
	            SetPlayerHealth(playerid, PaintBallArena[arenaid][pbHealth]);
	            if(PaintBallArena[arenaid][pbArmor] > 0) {
	            	SetPlayerArmor(playerid, PaintBallArena[arenaid][pbArmor]);
	            }
	        }

	        PlayerInfo[playerid][pKills] += 5;

			////SendPaintballArenaAudio(arenaid, 25, 75);
         	//SetTimerEx("//SendPaintballArenaAudio", 250, false, "iii", arenaid, 15, 100);
	        RemovePlayerAttachedObject(playerid, GetPVarInt(playerid, "AOSlotPaintballFlag"));
	        SetPVarInt(playerid, "AOSlotPaintballFlag", -1);
	        PaintBallArena[arenaid][pbFlagRedActive] = 0;
	        PaintBallArena[arenaid][pbTeamBlueScores]++;
	        SendPaintballArenaTextMessage(arenaid, 5, "~b~Blue Team ~w~Scores!");
			format(string,sizeof(string),"[Paintball Arena] %s has scored for the Blue Team!", GetPlayerNameEx(playerid));
	        SendPaintballArenaMessage(arenaid, COLOR_YELLOW, string);
	        PaintBallArena[arenaid][pbFlagRedID] = CreateDynamicObject(RED_FLAG_OBJ, PaintBallArena[arenaid][pbFlagRedSpawn][0], PaintBallArena[arenaid][pbFlagRedSpawn][1], PaintBallArena[arenaid][pbFlagRedSpawn][2], 0.0, 0.0, 0.0, PaintBallArena[arenaid][pbVirtual], PaintBallArena[arenaid][pbInterior], -1);

	        PaintBallArena[arenaid][pbFlagRedPos][0] = PaintBallArena[arenaid][pbFlagRedSpawn][0];
	        PaintBallArena[arenaid][pbFlagRedPos][1] = PaintBallArena[arenaid][pbFlagRedSpawn][1];
	        PaintBallArena[arenaid][pbFlagRedPos][2] = PaintBallArena[arenaid][pbFlagRedSpawn][2];
	    }
	    case 2: // Blue Flag
	    {
	        if(PaintBallArena[arenaid][pbFlagInstagib] == 1)
	        {
	            SetPlayerHealth(playerid, PaintBallArena[arenaid][pbHealth]);
	            if(PaintBallArena[arenaid][pbArmor] > 0) {
	            	SetPlayerArmor(playerid, PaintBallArena[arenaid][pbArmor]);
	            }
	        }

	        PlayerInfo[playerid][pKills] += 5;

			////SendPaintballArenaAudio(arenaid, 25, 75);
	        //SetTimerEx("//SendPaintballArenaAudio", 250, false, "iii", arenaid, 33, 100);
	        RemovePlayerAttachedObject(playerid, GetPVarInt(playerid, "AOSlotPaintballFlag"));
	        SetPVarInt(playerid, "AOSlotPaintballFlag", -1);
	        PaintBallArena[arenaid][pbFlagBlueActive] = 0;
	        PaintBallArena[arenaid][pbTeamRedScores]++;
	        SendPaintballArenaTextMessage(arenaid, 5, "~r~Red Team ~w~Scores!");
			format(string,sizeof(string),"[Paintball Arena] %s has scored for the Red Team!", GetPlayerNameEx(playerid));
	        SendPaintballArenaMessage(arenaid, COLOR_YELLOW, string);
	        PaintBallArena[arenaid][pbFlagBlueID] = CreateDynamicObject(BLUE_FLAG_OBJ, PaintBallArena[arenaid][pbFlagBlueSpawn][0], PaintBallArena[arenaid][pbFlagBlueSpawn][1], PaintBallArena[arenaid][pbFlagBlueSpawn][2], 0.0, 0.0, 0.0, PaintBallArena[arenaid][pbVirtual], PaintBallArena[arenaid][pbInterior], -1);

	        PaintBallArena[arenaid][pbFlagBluePos][0] = PaintBallArena[arenaid][pbFlagBlueSpawn][0];
	        PaintBallArena[arenaid][pbFlagBluePos][1] = PaintBallArena[arenaid][pbFlagBlueSpawn][1];
	        PaintBallArena[arenaid][pbFlagBluePos][2] = PaintBallArena[arenaid][pbFlagBlueSpawn][2];
	    }
	}
}

stock DropFlagPaintballArena(playerid, arenaid, flagid)
{
	new string[128];
	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(playerid, X, Y, Z);
	RemovePlayerAttachedObject(playerid, GetPVarInt(playerid, "AOSlotPaintballFlag"));
	SetPVarInt(playerid, "AOSlotPaintballFlag", -1);

	switch(flagid)
	{
	    case 1: // Red Flag
	    {
  			////SendPaintballArenaAudio(arenaid, 28, 100);
	        PaintBallArena[arenaid][pbFlagRedActive] = 1;
	        SendPaintballArenaTextMessage(arenaid, 5, "~r~Red Flag ~w~Dropped!");
			format(string,sizeof(string),"[Paintball Arena] %s has dropped the Red Flag!", GetPlayerNameEx(playerid));
	        SendPaintballArenaMessage(arenaid, COLOR_YELLOW, string);
	        PaintBallArena[arenaid][pbFlagRedID] = CreateDynamicObject(RED_FLAG_OBJ, X, Y, Z, 0.0, 0.0, 0.0, PaintBallArena[arenaid][pbVirtual], PaintBallArena[arenaid][pbInterior], -1);
	        PaintBallArena[arenaid][pbFlagRedTextID] = Create3DTextLabel("Red Flag", COLOR_RED, X, Y, Z, 200.0, PaintBallArena[arenaid][pbVirtual], 0);
	        //PaintBallArena[arenaid][pbFlagRedTextID] = CreateDynamic3DTextLabel("Red Flag", COLOR_RED, X, Y, Z, 200.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, PaintBallArena[arenaid][pbVirtual], PaintBallArena[arenaid][pbInterior]);
	        PaintBallArena[arenaid][pbFlagRedActiveTime] = 30;

	        PaintBallArena[arenaid][pbFlagRedPos][0] = X;
	        PaintBallArena[arenaid][pbFlagRedPos][1] = Y;
	        PaintBallArena[arenaid][pbFlagRedPos][2] = Z;
	    }
	    case 2: // Blue Flag
	    {
	        ////SendPaintballArenaAudio(arenaid, 10, 100);
	        PaintBallArena[arenaid][pbFlagBlueActive] = 1;
	        SendPaintballArenaTextMessage(arenaid, 5, "~b~Blue Flag ~w~Dropped!");
			format(string,sizeof(string),"[Paintball Arena] %s has dropped the Blue Flag!", GetPlayerNameEx(playerid));
	        SendPaintballArenaMessage(arenaid, COLOR_YELLOW, string);
	        PaintBallArena[arenaid][pbFlagBlueID] = CreateDynamicObject(BLUE_FLAG_OBJ, X, Y, Z, 0.0, 0.0, 0.0, PaintBallArena[arenaid][pbVirtual], PaintBallArena[arenaid][pbInterior], -1);
	        PaintBallArena[arenaid][pbFlagBlueTextID] = Create3DTextLabel("Blue Flag", COLOR_DBLUE, X, Y, Z, 200.0, PaintBallArena[arenaid][pbVirtual], 0);
	        //PaintBallArena[arenaid][pbFlagBlueTextID] = CreateDynamic3DTextLabel("Blue Flag", COLOR_DBLUE, X, Y, Z, 200.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, PaintBallArena[arenaid][pbVirtual], PaintBallArena[arenaid][pbInterior]);
	        PaintBallArena[arenaid][pbFlagBlueActiveTime] = 30;

	        PaintBallArena[arenaid][pbFlagBluePos][0] = X;
	        PaintBallArena[arenaid][pbFlagBluePos][1] = Y;
	        PaintBallArena[arenaid][pbFlagBluePos][2] = Z;
	    }
	}
}

stock PickupFlagPaintballArena(playerid, arenaid, flagid)
{
	new string[128];
	new index = -1;
    if(GetPlayerState(playerid) == PLAYER_STATE_WASTED) { return 1; }
	switch(flagid)
	{
	    case 1: // Red Flag
	    {
	        if(PaintBallArena[arenaid][pbFlagRedActive] == 1)
	        {
	            Delete3DTextLabel(PaintBallArena[arenaid][pbFlagRedTextID]);
	        }
	        ////SendPaintballArenaAudio(arenaid, 23, 75);
	        //SetTimerEx("//SendPaintballArenaAudio", 250, false, "iii", arenaid, 30, 100);
	        PaintBallArena[arenaid][pbFlagRedActive] = -1;
	        SendPaintballArenaTextMessage(arenaid, 5, "~r~Red Flag ~w~Taken!");
			format(string,sizeof(string),"[Paintball Arena] %s has taken the Red Flag!", GetPlayerNameEx(playerid));
	        SendPaintballArenaMessage(arenaid, COLOR_YELLOW, string);
	        //SetTimerEx("//SendAudioToPlayer", 1500, false, "iii", playerid, 42, 100);
			index = FindFreeAttachedObjectSlot(playerid);
			if(index == -1) { RemovePlayerAttachedObject(playerid, 4), index = 4; }
	        SetPlayerAttachedObject(playerid,index,RED_FLAG_OBJ,5,0.0,0.0,0.0,30.0,0.0,0.0);
	        DestroyDynamicObject(PaintBallArena[arenaid][pbFlagRedID]);
	    }
	    case 2: // Blug Flag
	    {
	        if(PaintBallArena[arenaid][pbFlagBlueActive] == 1)
	        {
	            Delete3DTextLabel(PaintBallArena[arenaid][pbFlagBlueTextID]);
	        }
	        ////SendPaintballArenaAudio(arenaid, 23, 75);
	        //SetTimerEx("//SendPaintballArenaAudio", 250, false, "iii", arenaid, 12, 100);
	        PaintBallArena[arenaid][pbFlagBlueActive] = -1;
	        SendPaintballArenaTextMessage(arenaid, 5, "~b~Blue Flag ~w~Taken!");
			format(string,sizeof(string),"[Paintball Arena] %s has taken the Blue Flag!", GetPlayerNameEx(playerid));
	        SendPaintballArenaMessage(arenaid, COLOR_YELLOW, string);
	        //SetTimerEx("//SendAudioToPlayer", 1500, false, "iii", playerid, 42, 100);
			index = FindFreeAttachedObjectSlot(playerid);
			if(index == -1) { RemovePlayerAttachedObject(playerid, 4), index = 4; }
	        SetPlayerAttachedObject(playerid,index,BLUE_FLAG_OBJ,5,0.0,0.0,0.0,30.0,0.0,0.0);
	        DestroyDynamicObject(PaintBallArena[arenaid][pbFlagBlueID]);
	    }
	}
	SetPVarInt(playerid, "AOSlotPaintballFlag", index);
	return 1;
}

stock SpawnPaintballArena(playerid, arenaid)
{
	switch(PaintBallArena[arenaid][pbGameType])
	{
	    case 1,4: // Deathmatch, KOTH
	    {
			new rand = Random(1,5);
			switch (rand)
			{
	    		case 1:
	    		{
	        		SetPlayerPos(playerid, PaintBallArena[arenaid][pbDeathmatch1][0],PaintBallArena[arenaid][pbDeathmatch1][1],PaintBallArena[arenaid][pbDeathmatch1][2]);
 					SetPlayerFacingAngle(playerid, PaintBallArena[arenaid][pbDeathmatch1][3]);
	    		}
	    		case 2:
				{
		    		SetPlayerPos(playerid, PaintBallArena[arenaid][pbDeathmatch2][0],PaintBallArena[arenaid][pbDeathmatch2][1],PaintBallArena[arenaid][pbDeathmatch2][2]);
 					SetPlayerFacingAngle(playerid, PaintBallArena[arenaid][pbDeathmatch2][3]);
				}
				case 3:
				{
		    		SetPlayerPos(playerid, PaintBallArena[arenaid][pbDeathmatch3][0],PaintBallArena[arenaid][pbDeathmatch3][1],PaintBallArena[arenaid][pbDeathmatch3][2]);
 					SetPlayerFacingAngle(playerid, PaintBallArena[arenaid][pbDeathmatch3][3]);
				}
				case 4:
				{
		    		SetPlayerPos(playerid, PaintBallArena[arenaid][pbDeathmatch4][0],PaintBallArena[arenaid][pbDeathmatch4][1],PaintBallArena[arenaid][pbDeathmatch4][2]);
 					SetPlayerFacingAngle(playerid, PaintBallArena[arenaid][pbDeathmatch4][3]);
				}
			}
		}
		case 2,3,5: // Team Deathmatch, Capture the Flag or Team KOTH
		{
		    if(PlayerInfo[playerid][pPaintTeam] == 1) // Red
		    {
		    	new rand = Random(1,4);
		    	switch (rand)
		    	{
		    	    case 1:
		    	    {
		    	        SetPlayerPos(playerid, PaintBallArena[arenaid][pbTeamRed1][0],PaintBallArena[arenaid][pbTeamRed1][1],PaintBallArena[arenaid][pbTeamRed1][2]);
 						SetPlayerFacingAngle(playerid, PaintBallArena[arenaid][pbTeamRed1][3]);
		    	    }
		    	    case 2:
		    	    {
		    	        SetPlayerPos(playerid, PaintBallArena[arenaid][pbTeamRed2][0],PaintBallArena[arenaid][pbTeamRed2][1],PaintBallArena[arenaid][pbTeamRed2][2]);
 						SetPlayerFacingAngle(playerid, PaintBallArena[arenaid][pbTeamRed2][3]);
		    	    }
		    	    case 3:
		    	    {
		    	        SetPlayerPos(playerid, PaintBallArena[arenaid][pbTeamRed3][0],PaintBallArena[arenaid][pbTeamRed3][1],PaintBallArena[arenaid][pbTeamRed3][2]);
 						SetPlayerFacingAngle(playerid, PaintBallArena[arenaid][pbTeamRed3][3]);
		    	    }
		    	}
				SetPlayerColor(playerid, PAINTBALL_TEAM_RED);
			}
			if(PlayerInfo[playerid][pPaintTeam] == 2) // Blue
			{
			    new rand = Random(1,4);
			    switch (rand)
			    {
			        case 1:
		    	    {
		    	        SetPlayerPos(playerid, PaintBallArena[arenaid][pbTeamBlue1][0],PaintBallArena[arenaid][pbTeamBlue1][1],PaintBallArena[arenaid][pbTeamBlue1][2]);
 						SetPlayerFacingAngle(playerid, PaintBallArena[arenaid][pbTeamBlue1][3]);
		    	    }
		    	    case 2:
		    	    {
		    	        SetPlayerPos(playerid, PaintBallArena[arenaid][pbTeamBlue2][0],PaintBallArena[arenaid][pbTeamBlue2][1],PaintBallArena[arenaid][pbTeamBlue2][2]);
 						SetPlayerFacingAngle(playerid, PaintBallArena[arenaid][pbTeamBlue2][3]);
		    	    }
		    	    case 3:
		    	    {
		    	        SetPlayerPos(playerid, PaintBallArena[arenaid][pbTeamBlue3][0],PaintBallArena[arenaid][pbTeamBlue3][1],PaintBallArena[arenaid][pbTeamBlue3][2]);
 						SetPlayerFacingAngle(playerid, PaintBallArena[arenaid][pbTeamBlue3][3]);
		    	    }
			    }
			    SetPlayerColor(playerid, PAINTBALL_TEAM_BLUE);
			}
		}
	}
	PlayerInfo[playerid][pVW] = PaintBallArena[arenaid][pbVirtual];
	PlayerInfo[playerid][pInt] = PaintBallArena[arenaid][pbInterior];


	pTazer{playerid} = 0; // Reset Tazer
	ResetPlayerWeapons(playerid);

 	SetPlayerInterior(playerid, PaintBallArena[arenaid][pbInterior]);
 	SetPlayerVirtualWorld(playerid, PaintBallArena[arenaid][pbVirtual]);
 	SetPlayerHealth(playerid, PaintBallArena[arenaid][pbHealth]);
 	if(PaintBallArena[arenaid][pbArmor] >= 0) {
 		SetPlayerArmor(playerid, PaintBallArena[arenaid][pbArmor]);
 	}
 	GivePlayerWeapon(playerid, PaintBallArena[arenaid][pbWeapons][0], 60000);
 	GivePlayerWeapon(playerid, PaintBallArena[arenaid][pbWeapons][1], 60000);
 	GivePlayerWeapon(playerid, PaintBallArena[arenaid][pbWeapons][2], 60000);
}

stock JoinPaintballArena(playerid, arenaid, password[])
{
	new string[128];
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid,name,sizeof(name));

	if(PaintBallArena[arenaid][pbPlayers] >= PaintBallArena[arenaid][pbLimit]) {
	   	return 0;
	}

	if(strcmp(PaintBallArena[arenaid][pbPassword], password, false)) {
	    return 0;
	}

	new team = GetPVarInt(playerid, "pbTeamChoice");
	new teamlimit = PaintBallArena[arenaid][pbLimit]/2;
	new Float:oldX, Float:oldY, Float:oldZ, Float:oldHealth, Float:oldArmor;
	GetPlayerPos(playerid, oldX, oldY, oldZ);

	SetPVarFloat(playerid, "pbOldX", oldX);
	SetPVarFloat(playerid, "pbOldY", oldY);
	SetPVarFloat(playerid, "pbOldZ", oldZ);

	GetPlayerHealth(playerid,oldHealth);
	GetPlayerArmour(playerid,oldArmor);
	SetPVarInt(playerid, "pbOldInt", GetPlayerInterior(playerid));
	SetPVarInt(playerid, "pbOldVW", GetPlayerVirtualWorld(playerid));
	SetPVarFloat(playerid, "pbOldHealth", oldHealth);
	SetPVarFloat(playerid, "pbOldArmor", oldArmor);

	firstaidexpire(playerid);

 	PaintBallArena[arenaid][pbPlayers]++;

 	if(PaintBallArena[arenaid][pbGameType] == 3) {
		SetPVarInt(playerid, "TickCTFID", SetTimerEx("TickCTF", 1000, true, "d", playerid)); // Player's CTF Tick Function
	}

 	if(PaintBallArena[arenaid][pbGameType] == 4 || PaintBallArena[arenaid][pbGameType] == 5) {
 		SetPlayerCheckpoint(playerid, PaintBallArena[arenaid][pbHillX], PaintBallArena[arenaid][pbHillY], PaintBallArena[arenaid][pbHillZ], PaintBallArena[arenaid][pbHillRadius]);
   		SetPVarInt(playerid, "TickKOTHID", SetTimerEx("TickKOTH", 1000, true, "d", playerid)); // Player's KOTH Tick Function
	}

 	SetPVarInt(playerid, "IsInArena", arenaid);
	switch(team)
	{
	    case 0: // No Team
	    {
	        format(string,sizeof(string),"[Paintball Arena] %s has joined the Paintball Arena!", name);
	        SendPaintballArenaMessage(arenaid,COLOR_WHITE,string);
	        //SendAudioToPlayer(playerid, 27, 100);
	    }
	    case 1: // Red Team
		{
		    if(PaintBallArena[arenaid][pbTeamRed] >= teamlimit)
		    {
		        SendClientMessageEx(playerid, COLOR_WHITE, "Red team is currently full, sending you to the Blue team.");
		        PlayerInfo[playerid][pPaintTeam] = 2;
		    	PaintBallArena[arenaid][pbTeamBlue]++;
		    	format(string,sizeof(string),"[Paintball Arena] %s has joined the Paintball Arena on the Blue Team!", name);
		       	SendPaintballArenaMessage(arenaid,PAINTBALL_TEAM_BLUE,string);
		       	//SendAudioToPlayer(playerid, 40, 100);
		    }
		    else
		    {
		        if(PaintBallArena[arenaid][pbTeamRed] > PaintBallArena[arenaid][pbTeamBlue])
		        {
		            SendClientMessageEx(playerid, COLOR_WHITE, "Teams are currently un-even, sending you to the Blue team.");
		        	PlayerInfo[playerid][pPaintTeam] = 2;
		    		PaintBallArena[arenaid][pbTeamBlue]++;
		    		format(string,sizeof(string),"[Paintball Arena] %s has joined the Paintball Arena on the Blue Team!", name);
		       		SendPaintballArenaMessage(arenaid,PAINTBALL_TEAM_BLUE,string);
		       		//SendAudioToPlayer(playerid, 40, 100);
		        }
		        else
		        {
		        	PlayerInfo[playerid][pPaintTeam] = 1;
		    		PaintBallArena[arenaid][pbTeamRed]++;
		    		format(string,sizeof(string),"[Paintball Arena] %s has joined the Paintball Arena on the Red Team!", name);
		       		SendPaintballArenaMessage(arenaid,PAINTBALL_TEAM_RED,string);
		       		//SendAudioToPlayer(playerid, 41, 100);
				}
		    }
		}
  		case 2: // Blue Team
	   	{
     		if(PaintBallArena[arenaid][pbTeamBlue] >= teamlimit)
   			{
      			SendClientMessageEx(playerid, COLOR_WHITE, "Blue team is currently full, sending you to the Red team.");
	        	PlayerInfo[playerid][pPaintTeam] = 1;
	    		PaintBallArena[arenaid][pbTeamRed]++;
	    		format(string,sizeof(string),"[Paintball Arena] %s has joined the Paintball Arena on the Red Team!", name);
      			SendPaintballArenaMessage(arenaid,PAINTBALL_TEAM_RED,string);
      			//SendAudioToPlayer(playerid, 41, 100);
		    }
	    	else
		    {
		        if(PaintBallArena[arenaid][pbTeamBlue] > PaintBallArena[arenaid][pbTeamRed])
		        {
		            SendClientMessageEx(playerid, COLOR_WHITE, "Teams are currently un-even, sending you to the Red team.");
	        		PlayerInfo[playerid][pPaintTeam] = 1;
	    			PaintBallArena[arenaid][pbTeamRed]++;
	    			format(string,sizeof(string),"[Paintball Arena] %s has joined the Paintball Arena on the Red Team!", name);
      				SendPaintballArenaMessage(arenaid,PAINTBALL_TEAM_RED,string);
      				//SendAudioToPlayer(playerid, 41, 100);
		        }
		        else
		        {
      				PlayerInfo[playerid][pPaintTeam] = 2;
	    			PaintBallArena[arenaid][pbTeamBlue]++;
		    		format(string,sizeof(string),"[Paintball Arena] %s has joined the Paintball Arena on the Blue Team!", name);
      				SendPaintballArenaMessage(arenaid,PAINTBALL_TEAM_BLUE,string);
      				//SendAudioToPlayer(playerid, 40, 100);
				}
		    }
	    }
	}
 	SendClientMessageEx(playerid, COLOR_WHITE, "Paintball Arena Commands: /scores - /exitarena - /joinarena - /switchteam");

	if(PaintBallArena[arenaid][pbExploitPerm] == 0)
 	{
 	    SendClientMessageEx(playerid, COLOR_YELLOW, "Warning: This room does not allow any QS/CS, any attempt will be punishable.");
 	}
 	else
 	{
 	    SendClientMessageEx(playerid, COLOR_YELLOW, "Warning: This room allows QS/CS, if you do not like it, leave the arena now.");
 	}

 	PlayerInfo[playerid][pKills] = 0;
  	PlayerInfo[playerid][pDeaths] = 0;

  	GivePlayerCash(playerid,-PaintBallArena[GetPVarInt(playerid, "IsInArena")][pbBidMoney]);
    PaintBallArena[GetPVarInt(playerid, "IsInArena")][pbMoneyPool] += PaintBallArena[GetPVarInt(playerid, "IsInArena")][pbBidMoney];

 	SpawnPaintballArena(playerid,GetPVarInt(playerid, "IsInArena"));
 	return 1;
}

stock LeavePaintballArena(playerid, arenaid)
{
	if(arenaid == GetPVarInt(playerid, "IsInArena"))
	{
	    new string[128];
	    new name[MAX_PLAYER_NAME];
	    GetPlayerName(playerid, name, sizeof(name));

		if(arenaid == GetPVarInt(playerid, "ArenaNumber"))
		{
		    SetPVarInt(playerid, "ArenaNumber", -1);
		}
		SetPVarInt(playerid, "IsInArena", -1);

		PlayerInfo[playerid][pKills] = 0;
	    PlayerInfo[playerid][pDeaths] = 0;

		if(PaintBallArena[arenaid][pbGameType] == 4 || PaintBallArena[arenaid][pbGameType] == 5)
		{
		    KillTimer(GetPVarInt(playerid, "TickKOTHID"));
		    DisablePlayerCheckpoint(playerid);
		}
		if(PlayerInfo[playerid][pPaintTeam] == 1)
		{
		    if(GetPVarInt(playerid, "AOSlotPaintballFlag") != -1)
		    {
				DropFlagPaintballArena(playerid, arenaid, 2);
		    }
		    KillTimer(GetPVarInt(playerid, "TickCTFID"));
		    PaintBallArena[arenaid][pbTeamRed]--;
		    PlayerInfo[playerid][pPaintTeam] = 0;
		}
		if(PlayerInfo[playerid][pPaintTeam] == 2)
		{
		    if(GetPVarInt(playerid, "AOSlotPaintballFlag") != -1)
		    {
				DropFlagPaintballArena(playerid, arenaid, 1);
		    }
		    KillTimer(GetPVarInt(playerid, "TickCTFID"));
		    PaintBallArena[arenaid][pbTeamBlue]--;
		    PlayerInfo[playerid][pPaintTeam] = 0;
		}
		PaintBallArena[arenaid][pbPlayers]--;
		if(PaintBallArena[arenaid][pbTimeLeft] > 30)
		{
			format(string,sizeof(string),"[Paintball Arena] %s has left the Paintball Arena!", name);
			SendPaintballArenaMessage(arenaid, COLOR_WHITE, string);
		}
		if(PaintBallArena[arenaid][pbPlayers] == 0)
		{
		    ResetPaintballArena(arenaid);
		}

		SetPlayerWeapons(playerid);
  		// SetPlayerToTeamColor(playerid);
  		SetPlayerColor(playerid,TEAM_HIT_COLOR);
  		SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);
		SetPlayerPos(playerid, GetPVarFloat(playerid, "pbOldX"), GetPVarFloat(playerid, "pbOldY"), GetPVarFloat(playerid, "pbOldZ"));
		SetPlayerHealth(playerid, GetPVarFloat(playerid, "pbOldHealth"));
		SetPlayerArmor(playerid, GetPVarFloat(playerid, "pbOldArmor"));
		SetPlayerVirtualWorld(playerid, GetPVarInt(playerid, "pbOldVW"));
		SetPlayerInterior(playerid, GetPVarInt(playerid, "pbOldInt"));
		PlayerInfo[playerid][pVW] = GetPVarInt(playerid, "pbOldVW");
		PlayerInfo[playerid][pInt] = GetPVarInt(playerid, "pbOldInt");
        PlayerInfo[playerid][pPaintTeam] = 0;
        DeletePVar(playerid, "pbTeamChoice");
		Player_StreamPrep(playerid, GetPVarFloat(playerid, "pbOldX"), GetPVarFloat(playerid, "pbOldY"), GetPVarFloat(playerid, "pbOldZ"), FREEZE_TIME);
	}
}

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

CMD:lockarena(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 3)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use this command.");
		return 1;
	}

	new string[128], arenaid;
	if(sscanf(params, "d", arenaid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /lockarena [arenaid]");

	arenaid--;

	if(arenaid < 0 || arenaid > MAX_ARENAS-1)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "You have entered a invalid arenaid.");
		return 1;
	}
	//foreach(new p: Player)
	for(new p = 0; p < MAX_PLAYERS; ++p)
	{
		if(IsPlayerConnected(p))
		{
			new cid = GetPVarInt(p, "IsInArena");
			if(cid == arenaid)
			{
				if(PaintBallArena[cid][pbBidMoney] > 0)
				{
					GivePlayerCash(p,PaintBallArena[cid][pbBidMoney]);
					format(string,sizeof(string),"You have been refunded a total of $%d because of premature closure.",PaintBallArena[cid][pbBidMoney]);
					SendClientMessageEx(p, COLOR_WHITE, string);
				}
				if(arenaid == GetPVarInt(p, "ArenaNumber"))
				{
					switch(PaintBallArena[arenaid][pbGameType])
					{
					case 1:
						{
							if(PlayerInfo[p][pDonateRank] < 3)
							{
								PlayerInfo[p][pPaintTokens] += 3;
								format(string,sizeof(string),"You have been refunded a total of %d Paintball Tokens because of premature closure.",3);
								SendClientMessageEx(p, COLOR_WHITE, string);
							}
						}
					case 2:
						{
							if(PlayerInfo[p][pDonateRank] < 3)
							{
								PlayerInfo[p][pPaintTokens] += 4;
								format(string,sizeof(string),"You have been refunded a total of %d Paintball Tokens because of premature closure.",4);
								SendClientMessageEx(p, COLOR_WHITE, string);
							}
						}
					case 3:
						{
							if(PlayerInfo[p][pDonateRank] < 3)
							{
								PlayerInfo[p][pPaintTokens] += 5;
								format(string,sizeof(string),"You have been refunded a total of %d Paintball Tokens because of premature closure.",5);
								SendClientMessageEx(p, COLOR_WHITE, string);
							}
						}
					case 4:
						{
							if(PlayerInfo[p][pDonateRank] < 3)
							{
								PlayerInfo[p][pPaintTokens] += 5;
								format(string,sizeof(string),"You have been refunded a total of %d Paintball Tokens because of premature closure.",5);
								SendClientMessageEx(p, COLOR_WHITE, string);
							}
						}
					case 5:
						{
							if(PlayerInfo[p][pDonateRank] < 3)
							{
								PlayerInfo[p][pPaintTokens] += 6;
								format(string,sizeof(string),"You have been refunded a total of %d Paintball Tokens because of premature closure.",6);
								SendClientMessageEx(p, COLOR_WHITE, string);
							}
						}
					}
				}
				LeavePaintballArena(p, cid);
			}
		}	
	}
	ResetPaintballArena(arenaid);
	PaintBallArena[arenaid][pbLocked] = 2;
	format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s has locked %s.", GetPlayerNameEx(playerid),PaintBallArena[arenaid][pbArenaName]);
	ABroadCast(COLOR_YELLOW, string, 2);
	format(string, sizeof(string), "* Admin %s has locked %s (ArenaID: %d) for some short maintenance.", GetPlayerNameEx(playerid),PaintBallArena[arenaid][pbArenaName],arenaid+1);
	SendClientMessageToAllEx(COLOR_LIGHTBLUE, string);
	return 1;
}

CMD:unlockarena(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 3)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to use this command.");
		return 1;
	}

	new string[128], arenaid;
	if(sscanf(params, "d", arenaid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /unlockarena [arenaid]");

	arenaid--;

	if(arenaid < 0 || arenaid > MAX_ARENAS-1)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "You have entered a invalid arenaid.");
		return 1;
	}
	if(PaintBallArena[arenaid][pbLocked] == 2)
	{
		ResetPaintballArena(arenaid);
		format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s has unlocked %s.", GetPlayerNameEx(playerid),PaintBallArena[arenaid][pbArenaName]);
		ABroadCast(COLOR_YELLOW, string, 2);
		format(string, sizeof(string), "* Admin %s has unlocked %s (ArenaID: %d), you may join/create it now.", GetPlayerNameEx(playerid),PaintBallArena[arenaid][pbArenaName],arenaid+1);
		SendClientMessageToAllEx(COLOR_LIGHTBLUE, string);
	}
	return 1;
}

CMD:givepainttokens(playerid, params[])
{
	new string[128], giveplayerid, amount;
	if(sscanf(params, "ud", giveplayerid, amount)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /givepainttokens [player] [amount]");

	if(IsPlayerConnected(giveplayerid))
	{
		if(PlayerInfo[playerid][pAdmin] < 4)
		{
			SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use this command.");
			return 1;
		}
		PlayerInfo[giveplayerid][pPaintTokens] += amount;

		format(string, sizeof(string), "You have received %d Paintball Tokens from Admin %s.", amount, GetPlayerNameEx(playerid));
		SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, string);
		format(string, sizeof(string), "You have given %s %d Paintbll Tokens.", GetPlayerNameEx(giveplayerid), amount);
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
		format(string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s has given %s, %d Paintball Tokens.", GetPlayerNameEx(playerid),GetPlayerNameEx(giveplayerid),amount);
		ABroadCast(COLOR_YELLOW, string, 2);

	}
	return 1;
}

CMD:savepbvehicle(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 1337) return SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use this command.");
	if(GetPVarInt(playerid, "ArenaNumber") == -1) return SendClientMessageEx(playerid, COLOR_WHITE, "You did not select an arena yet.");
	new arenaid = GetPVarInt(playerid, "ArenaNumber");
	new vehslot = GetPVarInt(playerid, "PBVeh");
	new string[128];
	if(IsPlayerInAnyVehicle(playerid))
	{
		new Float: vPosX, Float: vPosY, Float: vPosZ, Float: vPosA, vID;
		vID = GetPlayerVehicleID(playerid);
		GetVehiclePos(vID, vPosX, vPosY, vPosZ);
		GetVehicleZAngle(vID, vPosA);
		switch(vehslot)
		{
			case 1:
			{
				PaintBallArena[arenaid][pbVeh1Model] = GetVehicleModel(vID);
				PaintBallArena[arenaid][pbVeh1X] = vPosX;
				PaintBallArena[arenaid][pbVeh1Y] = vPosY;
				PaintBallArena[arenaid][pbVeh1Z] = vPosZ;
				PaintBallArena[arenaid][pbVeh1A] = vPosA;
			}
			case 2:
			{
				PaintBallArena[arenaid][pbVeh2Model] = GetVehicleModel(vID);
				PaintBallArena[arenaid][pbVeh2X] = vPosX;
				PaintBallArena[arenaid][pbVeh2Y] = vPosY;
				PaintBallArena[arenaid][pbVeh2Z] = vPosZ;
				PaintBallArena[arenaid][pbVeh2A] = vPosA;
			}
			case 3:
			{
				PaintBallArena[arenaid][pbVeh3Model] = GetVehicleModel(vID);
				PaintBallArena[arenaid][pbVeh3X] = vPosX;
				PaintBallArena[arenaid][pbVeh3Y] = vPosY;
				PaintBallArena[arenaid][pbVeh3Z] = vPosZ;
				PaintBallArena[arenaid][pbVeh3A] = vPosA;
			}
			case 4:
			{
				PaintBallArena[arenaid][pbVeh4Model] = GetVehicleModel(vID);
				PaintBallArena[arenaid][pbVeh4X] = vPosX;
				PaintBallArena[arenaid][pbVeh4Y] = vPosY;
				PaintBallArena[arenaid][pbVeh4Z] = vPosZ;
				PaintBallArena[arenaid][pbVeh4A] = vPosA;
			}
			case 5:
			{
				PaintBallArena[arenaid][pbVeh5Model] = GetVehicleModel(vID);
				PaintBallArena[arenaid][pbVeh5X] = vPosX;
				PaintBallArena[arenaid][pbVeh5Y] = vPosY;
				PaintBallArena[arenaid][pbVeh5Z] = vPosZ;
				PaintBallArena[arenaid][pbVeh5A] = vPosA;
			}
			case 6:
			{
				PaintBallArena[arenaid][pbVeh6Model] = GetVehicleModel(vID);
				PaintBallArena[arenaid][pbVeh6X] = vPosX;
				PaintBallArena[arenaid][pbVeh6Y] = vPosY;
				PaintBallArena[arenaid][pbVeh6Z] = vPosZ;
				PaintBallArena[arenaid][pbVeh6A] = vPosA;
			}
		}
	}
	else
	{
		switch(vehslot)
		{
			case 1:
			{
				PaintBallArena[arenaid][pbVeh1Model] = 0;
				PaintBallArena[arenaid][pbVeh1X] = 0.0;
				PaintBallArena[arenaid][pbVeh1Y] = 0.0;
				PaintBallArena[arenaid][pbVeh1Z] = 0.0;
				PaintBallArena[arenaid][pbVeh1A] = 0.0;
			}
			case 2:
			{
				PaintBallArena[arenaid][pbVeh2Model] = 0;
				PaintBallArena[arenaid][pbVeh2X] = 0.0;
				PaintBallArena[arenaid][pbVeh2Y] = 0.0;
				PaintBallArena[arenaid][pbVeh2Z] = 0.0;
				PaintBallArena[arenaid][pbVeh2A] = 0.0;
			}
			case 3:
			{
				PaintBallArena[arenaid][pbVeh3Model] = 0;
				PaintBallArena[arenaid][pbVeh3X] = 0.0;
				PaintBallArena[arenaid][pbVeh3Y] = 0.0;
				PaintBallArena[arenaid][pbVeh3Z] = 0.0;
				PaintBallArena[arenaid][pbVeh3A] = 0.0;
			}
			case 4:
			{
				PaintBallArena[arenaid][pbVeh4Model] = 0;
				PaintBallArena[arenaid][pbVeh4X] = 0.0;
				PaintBallArena[arenaid][pbVeh4Y] = 0.0;
				PaintBallArena[arenaid][pbVeh4Z] = 0.0;
				PaintBallArena[arenaid][pbVeh4A] = 0.0;
			}
			case 5:
			{
				PaintBallArena[arenaid][pbVeh5Model] = 0;
				PaintBallArena[arenaid][pbVeh5X] = 0.0;
				PaintBallArena[arenaid][pbVeh5Y] = 0.0;
				PaintBallArena[arenaid][pbVeh5Z] = 0.0;
				PaintBallArena[arenaid][pbVeh5A] = 0.0;
			}
			case 6:
			{
				PaintBallArena[arenaid][pbVeh6Model] = 0;
				PaintBallArena[arenaid][pbVeh6X] = 0.0;
				PaintBallArena[arenaid][pbVeh6Y] = 0.0;
				PaintBallArena[arenaid][pbVeh6Z] = 0.0;
				PaintBallArena[arenaid][pbVeh6A] = 0.0;
			}
		}
	}
	format(string, sizeof(string), "You have adjusted War Vehicle %d for ArenaID %d.",vehslot, arenaid);
	SendClientMessageEx(playerid, COLOR_WHITE, string);
	SavePaintballArena(arenaid);
	PaintballEditArenaMenu(playerid);
	return 1;
}
