/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Event Kernal System

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

CMD:joinevent(playerid, params[]) {
	if( EventKernel[ EventStatus ] == 0 ) {
		SendClientMessageEx( playerid, COLOR_WHITE, "There are currently no active events." );
	}
	else if( GetPVarInt( playerid, "EventToken" ) == 1 ) {
		SendClientMessageEx( playerid, COLOR_WHITE, "You are already in the event." );
	}
	else if(GetPVarInt(playerid, "IsInArena") >= 0) {
		SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this right now, you are in an arena!");
	}
	else if( PlayerCuffed[ playerid ] >= 1 || PlayerInfo[ playerid ][ pJailTime ] > 0 || PlayerInfo[playerid][pHospital] > 0 || GetPVarInt(playerid, "Injured")) {
		SendClientMessageEx( playerid, COLOR_WHITE, "You can't do this right now." );
	}
	else if(PlayerInfo[playerid][pAccountRestricted] != 0) {
		SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot do this while your account is restricted!");
	}
	else if(EventKernel[VipOnly] == 1 && PlayerInfo[playerid][pDonateRank] < 1) {
		SendClientMessageEx(playerid, COLOR_GRAD2, "This event is restricted to VIP's only.");
	}
	else if(EventKernel[EventPlayers] >= EventKernel[EventLimit] && EventKernel[EventTime] == 0) {
		SendClientMessageEx(playerid, COLOR_GRAD2, "This event has reached the max players limit.");
	}
	else if( EventKernel[ EventStatus ] == 2 || (EventKernel[ EventStatus ] == 1 && PlayerInfo[playerid][pDonateRank] >= 3)) {
		if(EventKernel[EventType] == 3)
		{
            new string[128];
			if(IsValidDynamic3DTextLabel(RFLTeamN3D[playerid])) {
				DestroyDynamic3DTextLabel(RFLTeamN3D[playerid]);
			}
			format(string, sizeof(string), "%s has joined the race event!", GetPlayerNameEx(playerid));
			ProxDetector(30.0, playerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
			SendClientMessageEx( playerid, COLOR_WHITE, EventKernel[ EventInfo ] );
		    if(EventKernel[EventFootRace]) {
		    	SendClientMessageEx( playerid, COLOR_YELLOW, "You have joined an onfoot race event, you have been teleported to a random checkpoint." );
			}
			else {
			    SendClientMessageEx( playerid, COLOR_YELLOW, "You have joined a vehicle race event, you have been teleported to a random checkpoint." );
			}
			SetPVarInt( playerid, "EventToken", 1 );
			TotalJoinsRace++;
			SetPlayerPos( playerid, EventKernel[ EventPositionX ], EventKernel[ EventPositionY ], EventKernel[ EventPositionZ ] );
			RCPIdCurrent[playerid] = 0;
		    new randcpscount = -1;
		    for(new i = 0; i < 20; i++)
		    {
		        if(EventRCPU[i] && EventRCPT[i] == 1) randcpscount = i;
		    }
		    ResetPlayerWeapons( playerid );
			pTazer{playerid} = 0;
			GetPlayerHealth(playerid, EventFloats[playerid][4]);
			GetPlayerArmour(playerid, EventFloats[playerid][5]);
			EventLastVW[playerid] = GetPlayerVirtualWorld(playerid);
			EventLastInt[playerid] = GetPlayerInterior(playerid);
			GetPlayerPos(playerid, EventFloats[playerid][1], EventFloats[playerid][2], EventFloats[playerid][3]);
			GetPlayerFacingAngle(playerid, EventFloats[playerid][0]);
		    new randrcp = randcpscount;
		    //SetPlayerPos(playerid, EventRCPX[randrcp], EventRCPY[randrcp], EventRCPZ[randrcp]);
			SetPlayerInterior( playerid, EventKernel[ EventInterior ] );
			SetPlayerVirtualWorld( playerid, EventKernel[ EventWorld ] );
			if(PlayerInfo[playerid][pRFLTeam] != -1) {
				new Float:X, Float:Y, Float:Z;
				GetPlayerPos( playerid, X, Y, Z );
				format(string, sizeof(string), "Team: %s", RFLInfo[PlayerInfo[playerid][pRFLTeam]][RFLname]);
				RFLTeamN3D[playerid] = CreateDynamic3DTextLabel(string,0x008080FF,X,Y,Z,10.0,.attachedplayer = playerid, .worldid = GetPlayerVirtualWorld(playerid));
			}
		    if(EventRCPT[randrcp] != 1)
		    {
				DisablePlayerCheckpoint(playerid);
		    	SetPlayerCheckpoint(playerid, EventRCPX[randrcp], EventRCPY[randrcp], EventRCPZ[randrcp], EventRCPS[randrcp]);
			}
			else
			{
			    DisablePlayerCheckpoint(playerid);
		    	SetPlayerCheckpoint(playerid, EventRCPX[randrcp], EventRCPY[randrcp], EventRCPZ[randrcp], EventRCPS[randrcp]);
			}
		}
		else
		{
			if(IsPlayerInAnyVehicle(playerid)) {
				return SendClientMessageEx(playerid, COLOR_GRAD2, "You can't join while in a vehicle.");
			}

			SetPVarInt( playerid, "EventToken", 1 );
			ResetPlayerWeapons( playerid );
			pTazer{playerid} = 0;
			GetPlayerHealth(playerid, EventFloats[playerid][4]);
			GetPlayerArmour(playerid, EventFloats[playerid][5]);
			EventLastVW[playerid] = GetPlayerVirtualWorld(playerid);
			EventLastInt[playerid] = GetPlayerInterior(playerid);
			GetPlayerPos(playerid, EventFloats[playerid][1], EventFloats[playerid][2], EventFloats[playerid][3]);
			GetPlayerFacingAngle(playerid, EventFloats[playerid][0]);
			if(EventKernel[EventType] != 2)
			{
				SetPlayerPos( playerid, EventKernel[ EventPositionX ], EventKernel[ EventPositionY ], EventKernel[ EventPositionZ ] );
				if(EventKernel[EventCustomInterior] == 1) Player_StreamPrep(playerid, EventKernel[EventPositionX], EventKernel[EventPositionY], EventKernel[EventPositionZ], FREEZE_TIME);
			}
			SetPlayerInterior( playerid, EventKernel[ EventInterior ] );
			SetPlayerVirtualWorld( playerid, EventKernel[ EventWorld ] );
			SendClientMessageEx( playerid, COLOR_WHITE, EventKernel[ EventInfo ] );
			
			SetPlayerHealth( playerid, EventKernel[ EventHealth ] );
			if(EventKernel[EventArmor] > 0) {
				SetPlayerArmor( playerid, EventKernel[ EventArmor ]);
			}
			//if(PlayerInfo[playerid][pBEquipped]) PlayerInfo[playerid][pBEquipped] = 0;
			for(new x;x<MAX_PLAYERTOYS;x++) {
				if(IsPlayerAttachedObjectSlotUsed(playerid, x)) 
				{
					if(x == 9 && PlayerInfo[playerid][pBEquipped]) 
						break;
					RemovePlayerAttachedObject(playerid, x); 
				}
			}
			for(new i; i < 11; i++) {
				PlayerHoldingObject[playerid][i] = 0;
			}

			if(EventKernel[EventType] == 2)
			{
				SetPlayerSkin(playerid, EventKernel[EventTeamSkin][nextteam]);
				new color = EventKernel[EventTeamColor][nextteam];
				if (color==0) SetPlayerColor(playerid, 0x00000000);
				if (color==1) SetPlayerColor(playerid, 0xFFFFFF00);
				if (color==2) SetPlayerColor(playerid, 0x2641FE00);
				if (color==3) SetPlayerColor(playerid, 0xAA333300);
				if (color==16) SetPlayerColor(playerid, 0x33AA3300);
				if (color==5) SetPlayerColor(playerid, 0xC2A2DA00);
				if (color==6) SetPlayerColor(playerid, 0xFFFF0000);
				if (color==7) SetPlayerColor(playerid, 0x33CCFF00);
				//if (strcmp(clr, "navy", true)==0) color=94;
				//if (strcmp(clr, "beige", true)==0) color=102;
				if (color==51) SetPlayerColor(playerid, 0x2D6F0000);
				if (color==103) SetPlayerColor(playerid, 0x0B006F00);
				if (color==13) SetPlayerColor(playerid, 0x52525200);
				if (color==55) SetPlayerColor(playerid, 0xB46F0000);
				if (color==84) SetPlayerColor(playerid, 0x814F0000);
				if (color==74) SetPlayerColor(playerid, 0x750A0000);
				//if (strcmp(clr, "maroon", true)==0) color=115;
				if (color==126) SetPlayerColor(playerid, 0xFF51F100);
				if(nextteam == 0)
				{
					SetPlayerPos(playerid, EventKernel[EventTeamPosX1], EventKernel[EventTeamPosY1], EventKernel[EventTeamPosZ1]);
					if(EventKernel[EventCustomInterior] == 1) Player_StreamPrep(playerid, EventKernel[EventTeamPosX1], EventKernel[EventTeamPosY1], EventKernel[EventTeamPosZ1], FREEZE_TIME);
				}
				else
				{
					SetPlayerPos(playerid, EventKernel[EventTeamPosX2], EventKernel[EventTeamPosY2], EventKernel[EventTeamPosZ2]);
					if(EventKernel[EventCustomInterior] == 1) Player_StreamPrep(playerid, EventKernel[EventTeamPosX2], EventKernel[EventTeamPosY2], EventKernel[EventTeamPosZ2], FREEZE_TIME);
				}
				if(nextteam == 0) nextteam++;
				else if(nextteam == 1) nextteam--;
			}
			if(EventKernel[EventType] == 4)
			{
			    SetPlayerColor(playerid, 0xAA333300);
			}
		}
		EventKernel[EventPlayers] ++;
		if(EventKernel[EventPlayers] == EventKernel[EventLimit] && EventKernel[EventTime] == 0)
		{
			ABroadCast(COLOR_YELLOW, "The event has now reached the max players limit, you can now start it.", 2);
		}
	}

	else if( EventKernel[ EventStatus ] == 3 )
	{
		SendClientMessageEx( playerid, COLOR_WHITE, "The event is already locked. You are unable to join." );
	}
	else if( EventKernel[ EventStatus ] == 4 )
	{
		SendClientMessageEx( playerid, COLOR_WHITE, "The event is already started. You are unable to join." );
	}

	return 1;
}

CMD:eventstaff(playerid, params[])
{
	new Float:health, Float:armor;
    if( PlayerInfo[ playerid ][ pAdmin ] >= 1 || PlayerInfo[playerid][pHelper] >= 2 || PlayerInfo[playerid][pSEC] >= 1) {
		if(GetPVarType(playerid, "pGodMode"))
			return SendClientMessageEx(playerid, COLOR_GRAD1, "Please disable your god mode before joining the event staff (/god)");
        if(EventKernel[EventJoinStaff] == 1) {
			if(GetPVarInt(playerid, "eventStaff") == 0) {
				for(new i; i < sizeof(EventKernel[EventStaff]); i++) if(EventKernel[EventStaff][i] == INVALID_PLAYER_ID) {
					SetPVarInt( playerid, "EventToken", 1 );
					EventLastVW[playerid] = GetPlayerVirtualWorld(playerid);
					EventLastInt[playerid] = GetPlayerInterior(playerid);
					GetPlayerPos(playerid, EventFloats[playerid][1], EventFloats[playerid][2], EventFloats[playerid][3]);
					GetPlayerFacingAngle(playerid, EventFloats[playerid][0]);
					SetPlayerPos( playerid, EventKernel[ EventPositionX ], EventKernel[ EventPositionY ], EventKernel[ EventPositionZ ] );
					SetPlayerInterior( playerid, EventKernel[ EventInterior ] );
					SetPlayerVirtualWorld( playerid, EventKernel[ EventWorld ] );
					PlayerInfo[playerid][pAGuns][GetWeaponSlot(38)] = 38;
					GivePlayerValidWeapon(playerid, 38, 60000);
					EventKernel[EventStaff][i] = playerid;
					GetPlayerHealth(playerid,health);
					SetPVarFloat(playerid, "pPreGodHealth", health);
					GetPlayerArmour(playerid,armor);
					SetPVarFloat(playerid, "pPreGodArmor", armor);
					SetPlayerHealth(playerid, 0x7FB00000);
					SetPlayerArmor(playerid, 0x7FB00000);
					SetPVarInt(playerid, "eventStaff", 1);
					return SendClientMessageEx( playerid, COLOR_WHITE, "You have joined the event staff." );
				}
				SendClientMessageEx(playerid, COLOR_GRAD2, "Unable to join the event staff, max is 5.");
			}	
        }
    }
    return 1;
}

CMD:quitevent(playerid, params[])
{
	new Float:health, Float:armor;
	if( GetPVarInt( playerid, "eventStaff" ) == 1) {
		if( EventKernel[ EventStatus ] == 1 || EventKernel[ EventStatus ] == 2 ) {
       		if(EventKernel[EventType] == 3) {
					DisablePlayerCheckpoint(playerid);
            	    ResetPlayerWeapons( playerid );
        			DeletePVar(playerid, "EventToken");
        			SetPlayerWeapons(playerid);
       				SetPlayerToTeamColor(playerid);
        			SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);
        			SetPlayerPos(playerid,EventFloats[playerid][1],EventFloats[playerid][2],EventFloats[playerid][3]);
        			SetPlayerVirtualWorld(playerid, EventLastVW[playerid]);
        			SetPlayerFacingAngle(playerid, EventFloats[playerid][0]);
        			SetPlayerInterior(playerid,EventLastInt[playerid]);
        			Player_StreamPrep(playerid, EventFloats[playerid][1],EventFloats[playerid][2],EventFloats[playerid][3], FREEZE_TIME);
        			RemovePlayerWeapon(playerid, 38);
        			for(new i = 0; i < 6; i++) {
        	   			EventFloats[playerid][i] = 0.0;
    	   			}
       		}
       		EventLastVW[playerid] = 0;
       		EventLastInt[playerid] = 0;
       		SendClientMessageEx( playerid, COLOR_LIGHTBLUE, "* You have quit the event as event staff." );
       		return 1;
		}
      	ResetPlayerWeapons( playerid );
       	DeletePVar(playerid, "EventToken");
       	SetPlayerWeapons(playerid);
       	SetPlayerToTeamColor(playerid);
       	SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);
       	SetPlayerPos(playerid,EventFloats[playerid][1],EventFloats[playerid][2],EventFloats[playerid][3]);
      	SetPlayerVirtualWorld(playerid, EventLastVW[playerid]);
       	SetPlayerFacingAngle(playerid, EventFloats[playerid][0]);
       	SetPlayerInterior(playerid,EventLastInt[playerid]);
       	Player_StreamPrep(playerid, EventFloats[playerid][1],EventFloats[playerid][2],EventFloats[playerid][3], FREEZE_TIME);
       	if(EventKernel[EventType] == 4)
		{
			if(GetPVarType(playerid, "pEventZombie")) DeletePVar(playerid, "pEventZombie");
 			SetPlayerToTeamColor(playerid);
		}
       	for(new i = 0; i < 6; i++) {
        	EventFloats[playerid][i] = 0.0;
        }
        EventLastVW[playerid] = 0;
        EventLastInt[playerid] = 0;
        RemovePlayerWeapon(playerid, 38);
		health = GetPVarFloat(playerid, "pPreGodHealth");
		SetPlayerHealth(playerid,health);
		armor = GetPVarFloat(playerid, "pPreGodArmor");
		SetPlayerArmor(playerid, armor);
		DeletePVar(playerid, "pPreGodHealth");
		DeletePVar(playerid, "pPreGodArmor");
		DeletePVar(playerid, "eventStaff");
        return SendClientMessageEx( playerid, COLOR_LIGHTBLUE, "* You have quit the event as event staff." );
	}	
    else if( GetPVarInt( playerid, "EventToken" ) == 1 ) {
        if( EventKernel[ EventStatus ] == 1 || EventKernel[ EventStatus ] == 2 ) {
       		if(EventKernel[EventType] == 3) {
					if(IsValidDynamic3DTextLabel(RFLTeamN3D[playerid])) {
						DestroyDynamic3DTextLabel(RFLTeamN3D[playerid]);
					}
					DisablePlayerCheckpoint(playerid);
            	    ResetPlayerWeapons( playerid );
        			DeletePVar(playerid, "EventToken");
        			SetPlayerWeapons(playerid);
       				SetPlayerToTeamColor(playerid);
        			SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);
        			SetPlayerPos(playerid,EventFloats[playerid][1],EventFloats[playerid][2],EventFloats[playerid][3]);
        			SetPlayerVirtualWorld(playerid, EventLastVW[playerid]);
        			SetPlayerFacingAngle(playerid, EventFloats[playerid][0]);
        			SetPlayerInterior(playerid,EventLastInt[playerid]);
        			SetPlayerHealth(playerid, EventFloats[playerid][4]);
        			if(EventFloats[playerid][5] > 0) {
        				SetPlayerArmor(playerid, EventFloats[playerid][5]);
        			}
        			Player_StreamPrep(playerid, EventFloats[playerid][1],EventFloats[playerid][2],EventFloats[playerid][3], FREEZE_TIME);
        			RemovePlayerWeapon(playerid, 38);
        			for(new i = 0; i < 6; i++) {
        	   			EventFloats[playerid][i] = 0.0;
    	   			}
       		}
       		EventLastVW[playerid] = 0;
       		EventLastInt[playerid] = 0;
       		SendClientMessageEx( playerid, COLOR_LIGHTBLUE, "* You have quit the event." );
       		return 1;
		}
      	ResetPlayerWeapons( playerid );
       	DeletePVar(playerid, "EventToken");
       	SetPlayerWeapons(playerid);
       	SetPlayerToTeamColor(playerid);
       	SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);
       	SetPlayerPos(playerid,EventFloats[playerid][1],EventFloats[playerid][2],EventFloats[playerid][3]);
      	SetPlayerVirtualWorld(playerid, EventLastVW[playerid]);
       	SetPlayerFacingAngle(playerid, EventFloats[playerid][0]);
       	SetPlayerInterior(playerid,EventLastInt[playerid]);
       	SetPlayerHealth(playerid, EventFloats[playerid][4]);
       	if(EventFloats[playerid][5] > 0) {
       		SetPlayerArmor(playerid, EventFloats[playerid][5]);
       	}
       	Player_StreamPrep(playerid, EventFloats[playerid][1],EventFloats[playerid][2],EventFloats[playerid][3], FREEZE_TIME);
       	if(EventKernel[EventType] == 4)
		{
			if(GetPVarType(playerid, "pEventZombie")) DeletePVar(playerid, "pEventZombie");
 			SetPlayerToTeamColor(playerid);
		}
       	for(new i = 0; i < 6; i++) {
        	EventFloats[playerid][i] = 0.0;
        }
        EventLastVW[playerid] = 0;
        EventLastInt[playerid] = 0;
        RemovePlayerWeapon(playerid, 38);
		health = GetPVarFloat(playerid, "pPreGodHealth");
		if(health > 0) {
			SetPlayerHealth(playerid,health);
		}
		armor = GetPVarFloat(playerid, "pPreGodArmor");
		if(armor > 0) {
			SetPlayerArmor(playerid, armor);
		}	
		DeletePVar(playerid, "pPreGodHealth");
		DeletePVar(playerid, "pPreGodArmor");
        SendClientMessageEx( playerid, COLOR_LIGHTBLUE, "* You have quit the event." );
    }
    return 1;
}

CMD:eventreset(playerid, params[])
{
    if( PlayerInfo[ playerid ][ pAdmin ] >= 1337 || PlayerInfo[playerid][pShopTech] >= 3) {
        new string[128];
        if( EventKernel[EventAdvisor] >= 1 ) {
            EventKernel[EventAdvisor] = 0;
            KillTimer( EventTimerHandle );
            format( string, sizeof(string), "{AA3333}AdmWarning{FFFF00}: %s has reset the event timer.", GetPlayerNameEx( playerid ) );
            ABroadCast( COLOR_YELLOW, string, 4 );
        }
        else {
            SendClientMessageEx( playerid, COLOR_GREY, "The timeout expired before you attempted to use this command. You can set-up an event." );
        }
    }
    return 1;
}

CMD:requestevent(playerid, params[])
{
    if( PlayerInfo[ playerid ][ pAdmin ] >= 2 || PlayerInfo[playerid][pHelper] >= 3 || PlayerInfo[playerid][pDonateRank] >= 4 || PlayerInfo[playerid][pSEC] >= 2) {
        new string[128];
        if( EventKernel[ EventStatus ] == 0 ) {
            if(EventKernel[EventRequest] != INVALID_PLAYER_ID || EventKernel[EventCreator] != INVALID_PLAYER_ID) {
                SendClientMessageEx(playerid, COLOR_GRAD2, "There's already someone requesting/making an event.");
                return 1;
            }
            if(EventKernel[EventAdvisor] == 1) {
                SendClientMessageEx(playerid, COLOR_GRAD2, "Another admin/advisor/coordinator already requested/made an event within the last three hours, please try again later!");
                return 1;
            }
            if(PlayerInfo[ playerid ][ pAdmin ] >= 2 || PlayerInfo[playerid][pHelper] >= 3 || PlayerInfo[playerid][pDonateRank] >= 4 || PlayerInfo[playerid][pSEC] >= 2) {
                EventKernel[ EventRequest ] = playerid;
                SendClientMessageEx( playerid, COLOR_GRAD2, "You have requested to set up an event, please wait until a Senior Admin approves it." );
                format( string, sizeof( string ), "{AA3333}AdmWarning{FFFF00}: %s would like to set up an event, do you approve? /acceptevent or /denyevent.", GetPlayerNameEx(playerid) );
                ABroadCast( COLOR_YELLOW, string, 4 );
                EventKernel[EventAdvisor] = 1;
                EventTimerHandle = SetTimer("ERequested", 9600000, false);
            }
        }
        else {
            SendClientMessageEx( playerid, COLOR_WHITE, "There is already an active event (use /endevent)." );
        }
    }
    return 1;
}

CMD:vipparty(playerid, params[])
{
    if( PlayerInfo[playerid][pDonateRank] == 5 )
	{
        new string[128+MAX_PLAYER_NAME];
        if( EventKernel[ EventStatus ] == 0 )
		{
            if(EventKernel[EventRequest] != INVALID_PLAYER_ID || EventKernel[EventCreator] != INVALID_PLAYER_ID)
			{
                SendClientMessageEx(playerid, COLOR_GRAD2, "There's already someone requesting/making an event.");
                return 1;
            }
            if(EventKernel[EventAdvisor] == 1)
			{
                SendClientMessageEx(playerid, COLOR_GRAD2, "Another admin/advisor already requested/made an event within the last three hours, please try again later!");
                return 1;
            }
            if(PlayerInfo[ playerid ][ pAdmin ] >= 4 || PlayerInfo[playerid][pDonateRank] == 5) {
                EventKernel[ EventRequest ] = playerid;
                SendClientMessageEx( playerid, COLOR_GRAD2, "You have requested to set up an event, please wait until a Senior Admin approves it." );
                format( string, sizeof( string ), "{AA3333}AdmWarning{FFFF00}: VIP Mod %s would like to set up a VIP event - /acceptevent or /denyevent", GetPlayerNameEx(playerid) );
                ABroadCast( COLOR_YELLOW, string, 4 );
                EventKernel[EventAdvisor] = 1;
                EventKernel[VipOnly] = 1;
                EventTimerHandle = SetTimer("ERequested", 9600000, false);
            }
        }
        else
		{
            SendClientMessageEx( playerid, COLOR_WHITE, "There is already an active event (use /endevent)." );
        }
    }
    return 1;
}

CMD:denyevent(playerid, params[])
{
    if( PlayerInfo[ playerid ][ pAdmin ] >= 4 ) {
        new string[128];
        SendClientMessageEx( EventKernel[EventRequest], COLOR_GRAD2, "Your request was denied." );
        EventKernel[EventRequest] = INVALID_PLAYER_ID;
        EventKernel[EventCreator] = INVALID_PLAYER_ID;
        format( string, sizeof( string ), "{AA3333}AdmWarning{FFFF00}: %s has denied the event request.", GetPlayerNameEx(playerid) );
        ABroadCast( COLOR_YELLOW, string, 4 );
        for(new i; i < sizeof(EventKernel[EventStaff]); i++) {
            if(EventKernel[EventStaff][i] != INVALID_PLAYER_ID) {
                SetPlayerWeapons(EventKernel[EventStaff][i]);
                SetPlayerPos(EventKernel[EventStaff][i],EventFloats[EventKernel[EventStaff][i]][1],EventFloats[EventKernel[EventStaff][i]][2],EventFloats[EventKernel[EventStaff][i]][3]);
                SetPlayerVirtualWorld(EventKernel[EventStaff][i], EventLastVW[EventKernel[EventStaff][i]]);
                SetPlayerFacingAngle(EventKernel[EventStaff][i], EventFloats[EventKernel[EventStaff][i]][0]);
                SetPlayerInterior(EventKernel[EventStaff][i],EventLastInt[EventKernel[EventStaff][i]]);
                SetPlayerHealth(EventKernel[EventStaff][i], EventFloats[EventKernel[EventStaff][i]][4]);
                if(EventFloats[EventKernel[EventStaff][i]][5] > 0) {
                	SetPlayerArmor(EventKernel[EventStaff][i], EventFloats[EventKernel[EventStaff][i]][5]);
                }
                for(new d = 0; d < 6; d++) {
                    EventFloats[EventKernel[EventStaff][i]][d] = 0.0;
                }
                EventLastVW[EventKernel[EventStaff][i]] = 0;
                EventLastInt[EventKernel[EventStaff][i]] = 0;
                EventKernel[EventStaff][i] = INVALID_PLAYER_ID;
                ResetPlayerWeapons( i );
            }
        }

        EventKernel[ EventStatus ] = 0;
        EventKernel[ EventType ] = 0;
        EventKernel[ EventLimit ] = 0;
        EventKernel[ EventPlayers ] = 0;
        EventKernel[ EventWeapons ][0] = 0;
        EventKernel[ EventWeapons ][1] = 0;
        EventKernel[ EventWeapons ][2] = 0;
        EventKernel[ EventWeapons ][3] = 0;
        EventKernel[ EventWeapons ][4] = 0;
        EventKernel[EventCreator] = INVALID_PLAYER_ID;
        EventKernel[VipOnly] = 0;
        EventKernel[EventJoinStaff] = 0;
		EventKernel[EventCustomInterior] = 0;
    }

    return 1;
}

CMD:acceptevent(playerid, params[])
{
    if( PlayerInfo[ playerid ][ pAdmin ] >= 4 ) {
        if( EventKernel[ EventStatus ] == 0 ) {
            if(EventKernel[EventRequest] != INVALID_PLAYER_ID) {
                if(IsPlayerConnected(EventKernel[EventRequest])) {
                    if(EventKernel[EventCreator] != INVALID_PLAYER_ID) {
                        SendClientMessageEx(playerid, COLOR_GRAD2, "There's already someone making an event.");
                        return 1;
                    }
                    new string[128];
                    EventKernel[EventCreator] = EventKernel[EventRequest];
                    EventKernel[EventRequest] = INVALID_PLAYER_ID;
                    SetPVarInt( EventKernel[EventCreator], "EventToken", 1 );
                    SendClientMessageEx( EventKernel[EventCreator], COLOR_GRAD2, "Your event request has been accepted, use /seteventpos to change the event position, once you do it people will be able to /eventstaff." );
                    if(PlayerInfo[EventKernel[EventCreator]][pHelper] >= 2) {
                        SendClientMessageEx( EventKernel[EventCreator], COLOR_GRAD2, "You now have temporary access to (/o)oc and /goto." );
                    }
                    format( string, sizeof( string ), "{AA3333}AdmWarning{FFFF00}: %s has approved the event request from %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(EventKernel[EventCreator]) );
                    ABroadCast( COLOR_YELLOW, string, 4 );
                    return 1;
                }
            }
        }
    }
    return 1;
}

CMD:approveevent(playerid, params[])
{
    if( PlayerInfo[ playerid ][ pAdmin ] >= 4 ) {
        if( EventKernel[ EventStartRequest ] == 1 ) {
            new string[128];
            EventKernel[ EventStatus ] = 1;
            EventKernel[EventStartRequest] = 0;
            SendClientMessageEx( EventKernel[EventCreator], COLOR_GRAD2, "Your event start request has been accepted, you can now use /announceevent to announce it to the server." );
            format( string, sizeof( string ), "{AA3333}AdmWarning{FFFF00}: %s has approved the event start request from %s.", GetPlayerNameEx(playerid), GetPlayerNameEx(EventKernel[EventCreator]) );
            ABroadCast( COLOR_YELLOW, string, 4 );
            //foreach(new i: Player)
			for(new i = 0; i < MAX_PLAYERS; ++i)
			{
				if(IsPlayerConnected(i))
				{
					if(PlayerInfo[i][pDonateRank] >= 3) {
						SendClientMessageEx(i, COLOR_YELLOW, "* Gold+ VIP Feature: An event has been started! /joinevent to join early");
					}
				}	
            }
            return 1;
        }
    }
    return 1;
}

CMD:eventhelp(playerid, params[])
{
	if (EventKernel[EventCreator] == playerid || PlayerInfo[playerid][pAdmin] >= 4)
	{
	    SendClientMessageEx(playerid, COLOR_GREEN,"_______________________________________");
		SendClientMessageEx(playerid, COLOR_GRAD4,"*** EVENT HELP *** type a command for more information");
		SendClientMessageEx(playerid, COLOR_WHITE,"*** EVENT HELP *** /event /seteventpos /seteventinfo /startevent /lockevent /endevent /announceevent /beginevent /quitevent");
		SendClientMessageEx(playerid, COLOR_GREEN,"_______________________________________");
	}
	return 1;
}