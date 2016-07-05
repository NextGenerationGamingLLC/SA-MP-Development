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

forward ERequested();
public ERequested()
{
	EventKernel[EventAdvisor] = 0;
	return 1;
}

CMD:joinevent(playerid, params[]) {
	if( EventKernel[ EventStatus ] == 0 ) {
		SendClientMessageEx( playerid, COLOR_WHITE, "There are currently no active events." );
	}
	else if( GetPVarInt( playerid, "EventToken" ) == 1 ) {
		SendClientMessageEx( playerid, COLOR_WHITE, "You are already in the event." );
	}
	else if(GetPVarType(playerid, "IsInArena")) {
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
				RFLTeamN3D[playerid] = Text3D:-1;
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
			GetHealth(playerid, EventFloats[playerid][4]);
			GetArmour(playerid, EventFloats[playerid][5]);
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
			GetHealth(playerid, EventFloats[playerid][4]);
			GetArmour(playerid, EventFloats[playerid][5]);
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
			
			SetHealth( playerid, EventKernel[ EventHealth ] );
			if(EventKernel[EventArmor] > 0) {
				SetArmour( playerid, EventKernel[ EventArmor ]);
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
			for(new i; i < 10; i++) {
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
					GivePlayerValidWeapon(playerid, 38);
					EventKernel[EventStaff][i] = playerid;
					GetHealth(playerid,health);
					SetPVarFloat(playerid, "pPreGodHealth", health);
					GetArmour(playerid,armor);
					SetPVarFloat(playerid, "pPreGodArmor", armor);
					SetHealth(playerid, 0x7FB00000);
					SetArmour(playerid, 0x7FB00000);
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
		SetHealth(playerid,health);
		armor = GetPVarFloat(playerid, "pPreGodArmor");
		SetArmour(playerid, armor);
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
						RFLTeamN3D[playerid] = Text3D:-1;
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
        			SetHealth(playerid, EventFloats[playerid][4]);
        			if(EventFloats[playerid][5] > 0) {
        				SetArmour(playerid, EventFloats[playerid][5]);
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
       	SetHealth(playerid, EventFloats[playerid][4]);
       	if(EventFloats[playerid][5] > 0) {
       		SetArmour(playerid, EventFloats[playerid][5]);
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
			SetHealth(playerid,health);
		}
		armor = GetPVarFloat(playerid, "pPreGodArmor");
		if(armor > 0) {
			SetArmour(playerid, armor);
		}	
		DeletePVar(playerid, "pPreGodHealth");
		DeletePVar(playerid, "pPreGodArmor");
        SendClientMessageEx( playerid, COLOR_LIGHTBLUE, "* You have quit the event." );
    }
    return 1;
}

CMD:eventreset(playerid, params[])
{
    if( PlayerInfo[ playerid ][ pAdmin ] >= 4 || PlayerInfo[playerid][pShopTech] >= 3) {
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
    if(PlayerInfo[playerid][pVIPMod])
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
            if(PlayerInfo[ playerid ][ pAdmin ] >= 4 || PlayerInfo[playerid][pVIPMod]) {
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
                SetHealth(EventKernel[EventStaff][i], EventFloats[EventKernel[EventStaff][i]][4]);
                if(EventFloats[EventKernel[EventStaff][i]][5] > 0) {
                	SetArmour(EventKernel[EventStaff][i], EventFloats[EventKernel[EventStaff][i]][5]);
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
            foreach(new i: Player)
			{
				if(PlayerInfo[i][pDonateRank] >= 3) {
					SendClientMessageEx(i, COLOR_YELLOW, "* Gold+ VIP Feature: An event has been started! /joinevent to join early");
				}
			}	
            return 1;
        }
    }
    return 1;
}

CMD:eventhelp(playerid, params[])
{
	if (EventKernel[EventCreator] == playerid || PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1)
	{
	    SendClientMessageEx(playerid, COLOR_GREEN,"_______________________________________");
		SendClientMessageEx(playerid, COLOR_GRAD4,"*** EVENT HELP *** type a command for more information");
		SendClientMessageEx(playerid, COLOR_WHITE,"*** EVENT HELP *** /event /seteventpos /seteventinfo /startevent /lockevent /endevent /announceevent /beginevent /quitevent");
		SendClientMessageEx(playerid, COLOR_GREEN,"_______________________________________");
	}
	return 1;
}

CMD:seteventpos(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[playerid][pHelper] >= 3 || PlayerInfo[playerid][pDonateRank] >= 4 || PlayerInfo[playerid][pSEC] >= 2)
	{
		if(EventKernel[EventCreator] == playerid || PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1)
		{
			new string[128];

			GetPlayerPos(playerid, EventKernel[EventPositionX], EventKernel[EventPositionY], EventKernel[EventPositionZ]);
			EventKernel[EventInterior] = GetPlayerInterior(playerid);
			EventKernel[EventWorld] = GetPlayerVirtualWorld(playerid);
			SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully adjusted the event position, type /seteventinfo to change the event properties.");
			EventKernel[EventJoinStaff] = 1;
			format(string, sizeof( string ), "{AA3333}AdmWarning{FFFF00}: %s has started an event, type /eventstaff if you want to be in the event staff.", GetPlayerNameEx(playerid) );
			ABroadCast(COLOR_YELLOW, string, 1);
			CBroadCast(COLOR_YELLOW, string, 2);
			foreach(new i: Player) if(PlayerInfo[i][pSEC] >= 1) SendClientMessageEx(i, COLOR_YELLOW, string);
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_GRAD2, "You are not making an event, or you're not the correct admin level.");
		}
	}
	return 1;
}

CMD:seteventtype(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[playerid][pHelper] >= 3 || PlayerInfo[playerid][pDonateRank] >= 4 || PlayerInfo[playerid][pSEC] >= 2)
	{
		if(EventKernel[EventCreator] == playerid || PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1)
		{
			if(isnull(params))
			{
				SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /seteventtype [type]");
				SendClientMessageEx(playerid, COLOR_GREY, "Available names: DM, TDM, Infection");
				return 1;
			}

			if(strcmp(params,"dm",true) == 0)
			{
				EventKernel[ EventType ] = 1;
				SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully adjusted the event type to DM.");
			}
			else if(strcmp(params,"tdm",true) == 0)
			{
				EventKernel[ EventType ] = 2;
				SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully adjusted the event type to TDM.");
			}
			else if(strcmp(params,"race",true) == 0)
			{
				EventKernel[ EventType ] = 3;
				SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully adjusted the event type to Race.");
			}
			else if(strcmp(params,"infection",true) == 0)
			{
				EventKernel[ EventType ] = 4;
				SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully adjusted the event type to infection.");
			}
			else if(strcmp(params,"none",true) == 0)
			{
				EventKernel[ EventType ] = 0;
				SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully adjusted the event type to None.");
			}
		}
	}
	return 1;
}

CMD:editevent(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[playerid][pHelper] >= 3 || PlayerInfo[playerid][pDonateRank] >= 4 || PlayerInfo[playerid][pSEC] >= 2)
	{
		if(EventKernel[EventCreator] == playerid || PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1)
		{
			new choice[32], opstring[64];
			if(EventKernel[EventType] == 1)
			{
			    if(sscanf(params, "s[32]S[64]", choice, opstring))
				{
					SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /editevent [name]");
					SendClientMessageEx(playerid, COLOR_GREY, "Available names: Jointext, Limit, Health, Armor, Gun1, Gun2, Gun3, Gun4, Gun5");
					return 1;
				}
			}
			else if(EventKernel[EventType] == 2)
			{
			    if(sscanf(params, "s[32]S[64]", choice, opstring))
				{
					SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /editevent [name]");
					SendClientMessageEx(playerid, COLOR_GREY, "Available names: Jointext, Limit, CustomInterior, Team1Skin, Team2Skin, Team1Color, Team2Color");
					SendClientMessageEx(playerid, COLOR_GREY, "Team1Spawn, Team2Spawn, Health, Armor, Gun1, Gun2, Gun3, Gun4, Gun5");
					return 1;
				}
			}
			else if(EventKernel[EventType] == 3)
			{
			    if(sscanf(params, "s[32]S("")[64]", choice, opstring))
				{
					SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /editevent [name]");
					SendClientMessageEx(playerid, COLOR_GREY, "Available names: Jointext, Limit, Health, Hours, CheckPoints, RaceType(Future Development), OnFoot(0/1)");
					SendClientMessageEx(playerid, COLOR_GREY, "Relay For Life Note: Set hours to something between 1-5 and don't touch the limit!");
					SendClientMessageEx(playerid, COLOR_GREY, "Relay For Life Note: Enable OnFoot!");
					return 1;
				}
			}
			else if(EventKernel[EventType] == 4)
			{
			    if(sscanf(params, "s[32]S[64]", choice, opstring))
				{
					SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /editevent [name]");
					SendClientMessageEx(playerid, COLOR_GREY, "Available names: Jointext, Limit, Health, Armor, Gun1, Gun2, Gun3, Gun4, Gun5");
					return 1;
				}
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GREY, "You need to set the event type first!");
				return 1;
			}

			if(strcmp(choice, "jointext",true) == 0)
			{
				if(!opstring[0])
				{
					SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /editevent jointext [text]");
					return 1;
				}
				strmid(EventKernel[EventInfo], opstring, 0, strlen(opstring), 64);
				SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully adjusted the event join text.");
			}
			else if(strcmp(choice, "health", true) == 0)
			{
				if(EventKernel[EventType] != 1 && EventKernel[EventType] != 2 && EventKernel[EventType] != 3 && EventKernel[EventType] != 4)
				{
					SendClientMessageEx(playerid, COLOR_GRAD2, "This name is not available for this event type.");
					return 1;
				}

				if(!opstring[0])
				{
					SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /editevent health [health]");
					return 1;
				}
				new Float: health;
				health = floatstr(opstring);
				EventKernel[EventHealth] = health;
				SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully adjusted the event health.");
			}
			else if(strcmp(choice, "armor", true) == 0)
			{
				if(EventKernel[EventType] != 1 && EventKernel[EventType] != 2 && EventKernel[EventType] != 4)
				{
					SendClientMessageEx(playerid, COLOR_WHITE, "This name is not available for this event type.");
					return 1;
				}

				if(!opstring[0])
				{
					SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /editevent armor [armor]");
					return 1;
				}
				new Float: armor;
				armor = floatstr(opstring);
				if(armor == 100) armor = 99;
				EventKernel[EventArmor] = armor;
				SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully adjusted the event armor.");
			}
			else if(strcmp(choice, "team1skin", true) == 0)
			{
				if(EventKernel[EventType] != 2)
				{
					SendClientMessageEx(playerid, COLOR_WHITE, "This name is not available for this event type.");
					return 1;
				}

				if(!opstring[0])
				{
					SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /editevent team1skin [skinid]");
					return 1;
				}

				new skin;
				skin = strval(opstring);
				EventKernel[EventTeamSkin][0] = skin;
				SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully adjusted the event team 1 skin.");
			}
			else if(strcmp(choice, "team2skin", true) == 0)
			{
				if(EventKernel[EventType] != 2)
				{
					SendClientMessageEx(playerid, COLOR_GRAD2, "This name is not available for this event type.");
					return 1;
				}

				if(!opstring[0])
				{
					SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /editevent team2skin [skinid]");
					return 1;
				}

				new skin;
				skin = strval(opstring);
				EventKernel[EventTeamSkin][1] = skin;
				SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully adjusted the event team 2 skin.");
			}
			else if(strcmp(choice, "team1color", true) == 0)
			{
				if(EventKernel[EventType] != 2)
				{
					SendClientMessageEx(playerid, COLOR_GRAD2, "This name is not available for this event type.");
					return 1;
				}

				if(!strlen(opstring))
				{
					SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /editevent team1color [color]");
					SendClientMessageEx(playerid, COLOR_GREY, "black | white | blue | red | green | purple | yellow | lightblue |");
					SendClientMessageEx(playerid, COLOR_GREY, "darkgreen | darkblue | darkgrey | brown | darkbrown | darkred | pink ");
					return 1;
				}
				EventKernel[EventTeamColor][0] = GetColorCode(opstring);
				SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully adjusted the event team 1 color.");
			}
			else if(strcmp(choice, "team2color", true) == 0)
			{
				if(EventKernel[EventType] != 2)
				{
					SendClientMessageEx(playerid, COLOR_GRAD2, "This name is not available for this event type.");
					return 1;
				}

				if(!strlen(opstring))
				{
					SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /editevent team2color [color]");
					SendClientMessageEx(playerid, COLOR_GREY, "black | white | blue | red | green | purple | yellow | lightblue |");
					SendClientMessageEx(playerid, COLOR_GREY, "darkgreen | darkblue | darkgrey | brown | darkbrown | darkred | pink ");
					return 1;
				}
				EventKernel[EventTeamColor][1] = GetColorCode(opstring);
				SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully adjusted the event team 2 color.");
			}
			else if(strcmp(choice, "team1spawn", true) == 0)
			{
				if(EventKernel[EventType] != 2)
				{
					SendClientMessageEx(playerid, COLOR_GRAD2, "This name is not available for this event type.");
					return 1;
				}
				GetPlayerPos(playerid, EventKernel[ EventTeamPosX1 ], EventKernel[ EventTeamPosY1 ], EventKernel[ EventTeamPosZ1 ] );
				SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully adjusted team 1's spawn position.");
			}
			else if(strcmp(choice, "team2spawn", true) == 0)
			{
				if(EventKernel[EventType] != 2)
				{
					SendClientMessageEx(playerid, COLOR_GRAD2, "This feature is not available for this event type.");
					return 1;
				}
				GetPlayerPos(playerid, EventKernel[ EventTeamPosX2 ], EventKernel[ EventTeamPosY2 ], EventKernel[ EventTeamPosZ2 ]);
				SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully adjusted team 2's spawn position.");
			}
			else if(strcmp(choice, "limit", true) == 0)
			{
			    if(EventKernel[EventTime] != 0)
			        return SendClientMessageEx(playerid, COLOR_GRAD2, "This feature is not available for this event, everyone is free to join. If you want to enable this please set the hours to 0.");
				if(!opstring[0])
				{
					SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /editevent limit [limit 0-60]");
					return 1;
				}

				new limit;
				limit = strval(opstring);
				if(limit < 0 || limit > 120) return SendClientMessageEx(playerid, COLOR_RED, "You cannot adjust the event limit higher than 120 or below 0");
				EventKernel[EventLimit] = limit;
				SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully adjusted the players in event limit.");
			}
			else if(strcmp(choice, "hours", true) == 0)
			{
			    if(EventKernel[EventType] != 3)
				{
					SendClientMessageEx(playerid, COLOR_GRAD2, "This feature is not available for this event type.");
					return 1;
				}
				if(!opstring[0])
				{
					SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /editevent hours [hours 0-5]");
					return 1;
				}

				new hours, seconds;
				hours = strval(opstring);
				if(hours < 0 || hours > 5) return SendClientMessageEx(playerid, COLOR_RED, "You cannot adjust the event hours higher than 5 or below 0");
				seconds = hours*3600;
				EventKernel[EventTime] = seconds;
				SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully adjusted the event hours that the event will be active for, timer will start once you fully start the event.");
                SendClientMessageEx(playerid, COLOR_GREY, "NOTE: If you set the event hours to 0 the event will finish once the last racer goes into the last checkpoint.");
				if(hours != 0)
					SendClientMessageEx(playerid, COLOR_YELLOW, "The feature players in event limit(/editevent limit) is now disabled since you changed the hours more than 0.");
			}
   			else if(strcmp(choice, "checkpoints", true) == 0)
			{
				if(EventKernel[EventType] != 3)
				{
					SendClientMessageEx(playerid, COLOR_GRAD2, "This feature is not available for this event type.");
					return 1;
				}
				ConfigEventCPs[playerid][0] = 1;
				ConfigEventCPs[playerid][1] = 0;
				ConfigEventCPs[playerid][2] = 0;
				ConfigEventCPId[playerid] = 0;
				new string[279];
				format(string,sizeof(string),"Welcome to the race checkpoint configuration system!\nThis is a quick guide on the steps you need to follow to successfully get the race checkpoints done.\nFirst and most important you need to remember to make the checkpoints in order, from the start line to the end line.");
				ShowPlayerDialogEx(playerid,RCPINTRO,DIALOG_STYLE_MSGBOX,"Race Checkpoints Introduction",string,"Next","Skip");
			}
			else if(strcmp(choice, "onfoot", true) == 0)
			{
				if(EventKernel[EventFootRace])
				{
				    EventKernel[EventFootRace] = 0;
					SendClientMessageEx(playerid, COLOR_GRAD2, "You have toggled off the onfoot feature, people can use vehicles(Future development, please don't use not working proprely)");
				}
				else {
				    EventKernel[EventFootRace] = 1;
					SendClientMessageEx(playerid, COLOR_GRAD2, "You have toggled on the onfoot feature, people cannot use vehicles.");
				}
			}
			else if(strcmp(choice, "gun1", true) == 0)
			{
				if(EventKernel[EventType] != 1 && EventKernel[EventType] != 2 && EventKernel[EventType] != 4)
				{
					SendClientMessageEx(playerid, COLOR_GRAD2, "This name is not available for this event type.");
					return 1;
				}

				if(!opstring[0])
				{
					SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /editevent gun1 [weaponid]");
					return 1;
				}

				new weapon;
				weapon = strval(opstring);
				if(weapon == 16 || weapon == 18 || weapon == 35 || weapon == 37 || weapon == 38 || weapon == 39) return SendClientMessageEx(playerid, COLOR_WHITE, "This weapon cannot be set as an event weapon!");
				EventKernel[EventWeapons][0] = weapon;
				SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully adjusted the event gun 1.");
			}
			else if(strcmp(choice, "gun2", true) == 0)
			{
				if(EventKernel[EventType] != 1 && EventKernel[EventType] != 2 && EventKernel[EventType] != 4)
				{
					SendClientMessageEx(playerid, COLOR_GRAD2, "This name is not available for this event type.");
					return 1;
				}

				if(!opstring[0])
				{
					SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /editevent gun1 [weaponid]");
					return 1;
				}

				new weapon;
				weapon = strval(opstring);
				if(weapon == 16 || weapon == 18 || weapon == 35 || weapon == 37 || weapon == 38 || weapon == 39) return SendClientMessageEx(playerid, COLOR_WHITE, "This weapon cannot be set as an event weapon!");
				EventKernel[EventWeapons][1] = weapon;
				SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully adjusted the event gun 2.");
			}
			else if(strcmp(choice, "gun3", true) == 0)
			{
				if(EventKernel[EventType] != 1 && EventKernel[EventType] != 2 && EventKernel[EventType] != 4)
				{
					SendClientMessageEx(playerid, COLOR_GRAD2, "This name is not available for this event type.");
					return 1;
				}

				if(!opstring[0])
				{
					SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /editevent gun1 [weaponid]");
					return 1;
				}

				new weapon;
				weapon = strval(opstring);
				if(weapon == 16 || weapon == 18 || weapon == 35 || weapon == 37 || weapon == 38 || weapon == 39) return SendClientMessageEx(playerid, COLOR_WHITE, "This weapon cannot be set as an event weapon!");
				EventKernel[EventWeapons][2] = weapon;
				SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully adjusted the event gun 3.");
			}
			else if(strcmp(choice, "gun4", true) == 0)
			{
				if(EventKernel[EventType] != 1 && EventKernel[EventType] != 2 && EventKernel[EventType] != 4)
				{
					SendClientMessageEx(playerid, COLOR_GRAD2, "This name is not available for this event type.");
					return 1;
				}

				if(!opstring[0])
				{
					SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /editevent gun1 [weaponid]");
					return 1;
				}

				new weapon;
				weapon = strval(opstring);
				if(weapon == 35 || weapon == 37 || weapon == 38) return SendClientMessageEx(playerid, COLOR_WHITE, "This weapon cannot be set as an event weapon!");
				EventKernel[EventWeapons][3] = weapon;
				SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully adjusted the event gun 4.");
			}
			else if(strcmp(choice, "gun5", true) == 0)
			{
				if(EventKernel[EventType] != 1 && EventKernel[EventType] != 2 && EventKernel[EventType] != 4)
				{
					SendClientMessageEx(playerid, COLOR_GRAD2, "This name is not available for this event type.");
					return 1;
				}

				if(!opstring[0])
				{
					SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /editevent gun1 [weaponid]");
					return 1;
				}

				new weapon;
				weapon = strval(opstring);
				if(weapon == 35 || weapon == 37 || weapon == 38) return SendClientMessageEx(playerid, COLOR_WHITE, "This weapon cannot be set as an event weapon!");
				EventKernel[EventWeapons][4] = weapon;
				SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully adjusted the event gun 5.");
			}
			else if(strcmp(choice, "custominterior", true) == 0)
			{
				if(!opstring[0]) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /editevent custominterior [0/1]");
				
				EventKernel[EventCustomInterior] = strval(opstring);
				
				new szstring[128];
				format(szstring, sizeof(szstring), "You have set the Custom Interior Value to %d.", strval(opstring));
				SendClientMessageEx(playerid, COLOR_WHITE, szstring);
			}
		}
	}
	return 1;
}

CMD:seteventviponly(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 2 || PlayerInfo[playerid][pHelper] >= 3 || PlayerInfo[playerid][pDonateRank] >= 4)
	{
		if(EventKernel[EventCreator] == playerid || PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1)
		{
			if(isnull(params)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /seteventviponly [0/1]");

			if(PlayerInfo[playerid][pVIPMod] && PlayerInfo[playerid][pAdmin] == 0)
			{
				SendClientMessageEx(playerid, COLOR_WHITE, "Error: You're not allowed to change this value!");
				return 1;
			}

			if(strcmp(params,"0",true) == 0)
			{
				EventKernel[ VipOnly ] = 0;
				SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully adjusted the event type to not VIP Only.");
			}
			else if(strcmp(params,"1",true) == 0)
			{
				EventKernel[ VipOnly ] = 1;
				SendClientMessageEx(playerid, COLOR_WHITE, "You have successfully adjusted the event type to VIP Only.");
			}

		}
	}
	return 1;
}

CMD:seteventinfo(playerid, params[])
{
	if( PlayerInfo[ playerid ][ pAdmin ] >= 2 || PlayerInfo[playerid][pHelper] >= 3 || PlayerInfo[playerid][pDonateRank] >= 4 || PlayerInfo[playerid][pSEC] >= 2)
	{
		if( EventKernel[EventCreator] == playerid || PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1)
		{
			SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /seteventtype /editevent /seteventviponly (once ready, type /startevent)");
			return 1;
		}
	}
	return 1;
}

CMD:endevent(playerid, params[])
{
	new Float: health, Float:armor;
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1 || EventKernel[EventCreator] == playerid)
	{
		if(EventKernel[EventStatus] != 0)
		{
			foreach(new i: Player)
			{
				if( GetPVarInt( i, "eventStaff" ) == 1)
				{
					ResetPlayerWeapons( i );
					DeletePVar(i, "EventToken");
					for(new w = 0; w < 12; w++)
						if(PlayerInfo[i][pAGuns][w]) PlayerInfo[i][pGuns][w] = 0, PlayerInfo[i][pAGuns][w] = 0;
					SetPlayerWeapons(i);
					SetPlayerToTeamColor(i);
					SetPlayerSkin(i, PlayerInfo[i][pModel]);
					SetPlayerPos(i,EventFloats[i][1],EventFloats[i][2],EventFloats[i][3]);
					SetPlayerVirtualWorld(i, EventLastVW[i]);
					SetPlayerFacingAngle(i, EventFloats[i][0]);
					SetPlayerInterior(i,EventLastInt[i]);
					Player_StreamPrep(i, EventFloats[i][1],EventFloats[i][2],EventFloats[i][3], FREEZE_TIME);
					if(EventKernel[EventType] == 4)
					{
						if(GetPVarType(i, "pEventZombie")) DeletePVar(i, "pEventZombie");
						SetPlayerToTeamColor(i);
					}
					
					for(new d = 0; d < 6; d++)
					{
						EventFloats[i][d] = 0.0;
					}
					EventLastVW[i] = 0;
					EventLastInt[i] = 0;
					RemovePlayerWeapon(i, 38);
					health = GetPVarFloat(i, "pPreGodHealth");
					SetHealth(i,health);
					armor = GetPVarFloat(i, "pPreGodArmor");
					SetArmour(i, armor);
					DeletePVar(i, "pPreGodHealth");
					DeletePVar(i, "pPreGodArmor");
					SetPVarInt(i, "eventStaff", 0);
					SendClientMessageEx( i, COLOR_YELLOW, "You have been removed from the event as it has been terminated by an administrator." );
				}	
				else if( GetPVarInt( i, "EventToken" ) == 1 )
				{
					if(EventKernel[EventType] == 3)  {
						if(IsValidDynamic3DTextLabel(RFLTeamN3D[playerid])) {
							DestroyDynamic3DTextLabel(RFLTeamN3D[playerid]);
						}
						DisablePlayerCheckpoint(i);
					} 
					else if(EventKernel[EventType] == 4) {
						if(GetPVarType(i, "pEventZombie")) DeletePVar(i, "pEventZombie");
					}
					ResetPlayerWeapons( i );
					for(new w = 0; w < 12; w++)
						if(PlayerInfo[i][pAGuns][w]) PlayerInfo[i][pGuns][w] = 0, PlayerInfo[i][pAGuns][w] = 0;
					SetPlayerWeapons(i);
					SetPlayerToTeamColor(i);
					SetPlayerSkin(i, PlayerInfo[i][pModel]);
					SetPlayerPos(i,EventFloats[i][1],EventFloats[i][2],EventFloats[i][3]);
					Player_StreamPrep(i, EventFloats[i][1],EventFloats[i][2],EventFloats[i][3], FREEZE_TIME);
					SetPlayerVirtualWorld(i, EventLastVW[i]);
					SetPlayerFacingAngle(i, EventFloats[i][0]);
					SetPlayerInterior(i,EventLastInt[i]);
					SetHealth(i, EventFloats[i][4]);
					if(EventFloats[i][5] > 0) {
						SetArmour(i, EventFloats[i][5]);
					}
					for(new d = 0; d < 6; d++)
					{
						EventFloats[i][d] = 0.0;
					}
					EventLastVW[i] = 0;
					EventLastInt[i] = 0;
					DeletePVar(i, "EventToken");
					SendClientMessageEx( i, COLOR_YELLOW, "You have been removed from the event as it has been terminated by an administrator." );
				}
			}	
			EventKernel[ EventPositionX ] = 0;
			EventKernel[ EventPositionY ] = 0;
			EventKernel[ EventPositionZ ] = 0;
			EventKernel[ EventTeamPosX1 ] = 0;
			EventKernel[ EventTeamPosY1 ] = 0;
			EventKernel[ EventTeamPosZ1 ] = 0;
			EventKernel[ EventTeamPosX2 ] = 0;
			EventKernel[ EventTeamPosY2 ] = 0;
			EventKernel[ EventTeamPosZ2 ] = 0;
			EventKernel[ EventStatus ] = 0;
			EventKernel[ EventType ] = 0;
			EventKernel[ EventHealth ] = 0;
			EventKernel[ EventLimit ] = 0;
			EventKernel[ EventPlayers ] = 0;
			EventKernel[ EventTime ] = 0;
			EventKernel[ EventWeapons ][0] = 0;
			EventKernel[ EventWeapons ][1] = 0;
			EventKernel[ EventWeapons ][2] = 0;
			EventKernel[ EventWeapons ][3] = 0;
			EventKernel[ EventWeapons ][4] = 0;
			for(new i = 0; i < 20; i++)
			{
				EventRCPU[i] = 0;
				EventRCPX[i] = 0.0;
				EventRCPY[i] = 0.0;
				EventRCPZ[i] = 0.0;
				EventRCPS[i] = 0.0;
				EventRCPT[i] = 0;
			}
			EventKernel[EventCreator] = INVALID_PLAYER_ID;
			EventKernel[VipOnly] = 0;
			EventKernel[EventJoinStaff] = 0;
			for(new i; i < sizeof(EventKernel[EventStaff]); i++) {
				EventKernel[EventStaff][i] = INVALID_PLAYER_ID;
			}	
			EventKernel[EventCustomInterior] = 0;
			SendClientMessageToAllEx( COLOR_LIGHTBLUE, "* The event has been finished by an Administrator." );
		}
		else
		{
			SendClientMessageEx( playerid, COLOR_WHITE, "There isn't an active event at the moment." );
		}
	}
	return 1;
}
 
CMD:startevent(playerid, params[])
{
	if( PlayerInfo[ playerid ][ pAdmin ] >= 2 || PlayerInfo[playerid][pHelper] >= 3 || PlayerInfo[playerid][pDonateRank] >= 4 || PlayerInfo[playerid][pSEC] >= 2)
	{
		new string[128];

		if( EventKernel[ EventStatus ] == 0)
		{
			if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1)
			{
				if(EventKernel[ EventHealth ] == 0)
				{
					SendClientMessageEx( playerid, COLOR_GRAD2, "You did not set the event health!" );
					return 1;
				}
				if((EventKernel[ EventPositionX ] == 0 || EventKernel[ EventPositionY ] == 0 || EventKernel[ EventPositionZ ] == 0) && EventKernel[EventType] != 3)
				{
					SendClientMessageEx( playerid, COLOR_GRAD2, "You did not set the event position!" );
					return 1;
				}
				if( (EventKernel[ EventTeamPosX1 ] == 0 || EventKernel[ EventTeamPosY1 ] == 0 || EventKernel[ EventTeamPosZ1 ] == 0) && EventKernel[ EventType ] == 2)
				{
					SendClientMessageEx( playerid, COLOR_GRAD2, "You did not set team 1's spawn position!" );
					return 1;
				}
				if( (EventKernel[ EventTeamPosX2 ] == 0 || EventKernel[ EventTeamPosY2 ] == 0 || EventKernel[ EventTeamPosZ2 ] == 0) && EventKernel[ EventType ] == 2)
				{
					SendClientMessageEx( playerid, COLOR_GRAD2, "You did not set team 2's spawn position!" );
					return 1;
				}
				if(EventKernel[ EventLimit ] == 0)
				{
					EventKernel[ EventLimit ] = 60;
				}
				EventKernel[ EventStatus ] = 1;
				SendClientMessageEx( playerid, COLOR_GRAD2, "You have started an event, use /announceevent to announce the event to the whole server." );
				foreach(new i: Player)
				{
					if(PlayerInfo[i][pDonateRank] >= 3)
					{
						SendClientMessageEx(i, COLOR_YELLOW, "* Gold+ VIP feature: An event has been started! /joinevent to join early");
					}
				}	
				return 1;
			}
			else if( EventKernel[EventCreator] == playerid)
			{
				if(EventKernel[ EventHealth ] == 0)
				{
					SendClientMessageEx( playerid, COLOR_GRAD2, "You did not set the event health!" );
					return 1;
				}
				if((EventKernel[ EventPositionX ] == 0 || EventKernel[ EventPositionY ] == 0 || EventKernel[ EventPositionZ ] == 0) && EventKernel[EventType] != 3)
				{
					SendClientMessageEx( playerid, COLOR_GRAD2, "You did not set the event position!" );
					return 1;
				}
				if(EventKernel[ EventLimit ] == 0)
				{
					EventKernel[ EventLimit ] = 60;
				}
				EventKernel[ EventStartRequest ] = 1;
				SendClientMessageEx( playerid, COLOR_GRAD2, "You have requested the event to start, please wait until a Senior Admin approves it." );
				if(EventKernel[EventType] != 3)
				{
					format( string, sizeof( string ), "Event Position: x:%f y:%f z:%f.", EventKernel[EventPositionX], EventKernel[EventPositionY], EventKernel[EventPositionZ] );
					ABroadCast( COLOR_GRAD2, string, 4 );
					format( string, sizeof( string ), "Event Jointext: %s EventLimit: %d.", EventKernel[EventInfo], EventKernel[EventLimit] );
					ABroadCast( COLOR_GRAD2, string, 4 );
					format( string, sizeof( string ), "Event Health: %f Event Armor: %f.", EventKernel[EventHealth], EventKernel[EventArmor] );
					ABroadCast( COLOR_GRAD2, string, 4 );
					if(EventKernel[EventWeapons][0] != 0)
					{
						format( string, sizeof( string ), "Event Gun1: %d.", EventKernel[EventWeapons][0] );
						ABroadCast( COLOR_GRAD2, string, 4 );
					}
					if(EventKernel[EventWeapons][1] != 0)
					{
						format( string, sizeof( string ), "Event Gun2: %d.", EventKernel[EventWeapons][1] );
						ABroadCast( COLOR_GRAD2, string, 4 );
					}
					if(EventKernel[EventWeapons][2] != 0)
					{
						format( string, sizeof( string ), "Event Gun3: %d.", EventKernel[EventWeapons][2] );
						ABroadCast( COLOR_GRAD2, string, 4 );
					}
					if(EventKernel[EventWeapons][3] != 0)
					{
						format( string, sizeof( string ), "Event Gun4: %d.", EventKernel[EventWeapons][3] );
						ABroadCast( COLOR_GRAD2, string, 4 );
					}
					if(EventKernel[EventWeapons][4] != 0)
					{
      					format( string, sizeof( string ), "Event Gun5: %d.", EventKernel[EventWeapons][4] );
						ABroadCast( COLOR_GRAD2, string, 4 );
					}
					if(EventKernel[EventType] == 2)
					{
						format( string, sizeof( string ), "Event Team 1 Color: %d Event Team 1 Skin: %d.", EventKernel[EventTeamColor][0], EventKernel[EventTeamSkin][0] );
						ABroadCast( COLOR_GRAD2, string, 4 );
						format( string, sizeof( string ), "Event Team 2 Color: %d Event Team 2 Skin: %d.", EventKernel[EventTeamColor][1], EventKernel[EventTeamSkin][1] );
						ABroadCast( COLOR_GRAD2, string, 4 );
					}
				}
				else {
				    if(EventKernel[EventTime] != 0) {
				    	format( string, sizeof( string ), "Event Jointext: %s EventTimeLimit: %d.", EventKernel[EventInfo], EventKernel[EventTime] );
						ABroadCast( COLOR_GRAD2, string, 4 );
					}
					else {
						format( string, sizeof( string ), "Event Jointext: %s EventLimit: %d.", EventKernel[EventInfo], EventKernel[EventLimit] );
						ABroadCast( COLOR_GRAD2, string, 4 );
					}
					ABroadCast( COLOR_GRAD2, "This is a race type event, to view the race checkpoints use /edit checkpoints", 4 );
				}
				format( string, sizeof( string ), "{AA3333}AdmWarning{FFFF00}: %s would like to start the event, do you approve? /approveevent or /denyevent.", GetPlayerNameEx(playerid) );
				ABroadCast( COLOR_YELLOW, string, 4 );
			}
		}
		else
		{
			SendClientMessageEx( playerid, COLOR_WHITE, "There is already an active event (use /endevent)." );
		}
	}

	return 1;
}

CMD:beginevent(playerid, params[])
{
	if( PlayerInfo[ playerid ][ pAdmin ] >= 4 || EventKernel[EventCreator] == playerid)
	{
		if( EventKernel[ EventStatus ] == 3 )
		{
		    if(EventKernel[EventType] == 3 && EventKernel[EventTime] != 0) return SendClientMessageEx(playerid, COLOR_RED, "ERROR: This feature is not available with the configuration setup for this event.");
			EventKernel[ EventStatus ] = 4;
   			new zombiemade;
			foreach(new i: Player)
			{
				if( GetPVarType( i, "EventToken" ) == 1 )
				{
					if( EventKernel[ EventType ] == 1 )
					{
						//GivePlayerEventWeapons( i );
						SendClientMessageEx( i, COLOR_LIGHTBLUE, "GO! The Event has started." );
						if(GetPVarInt(i, "eventStaff") < 1) {
							SetHealth( i, EventKernel[ EventHealth ] );
						}	
						if(EventKernel[EventArmor] > 0 && GetPVarInt(i, "eventStaff") < 1) {
							SetArmour( i, EventKernel[ EventArmor ]);
						}
						GivePlayerEventWeapons( i );
					}
					else if( EventKernel[ EventType ] == 2 )
					{
						//GivePlayerEventWeapons( i );
						SendClientMessageEx( i, COLOR_LIGHTBLUE, "GO! The Event has started." );
						if(GetPVarInt(i, "eventStaff") < 1) {
							SetHealth( i, EventKernel[ EventHealth ] );
						}
						if(EventKernel[EventArmor] > 0 && GetPVarInt(i, "eventStaff") < 1) {
							SetArmour( i, EventKernel[ EventArmor ]);
						}	
						GivePlayerEventWeapons( i );
					}
					else if( EventKernel[ EventType ] == 4 )
					{
						if(zombiemade == 0)
						{
							SendClientMessageEx(playerid, COLOR_WHITE, "You are a zombie! Use /bite to infect others");
							SetHealth(playerid, 30);
							RemoveArmor(playerid);
							SetPlayerSkin(playerid, 134);
							SetPlayerColor(playerid, 0x0BC43600);
							SetPVarInt(playerid, "pEventZombie", 1);
							zombiemade=1;
							continue;
						}
						else
						{
							//GivePlayerEventWeapons( i );
							SendClientMessageEx( i, COLOR_LIGHTBLUE, "The Event has started, kill the zombies (green names!)" );
							if(GetPVarInt(i, "eventStaff") < 1) {
								SetHealth( i, EventKernel[ EventHealth ] );
							}	
							if(EventKernel[EventArmor] > 0 && GetPVarInt(i, "eventStaff") < 1) {
								SetArmour( i, EventKernel[ EventArmor ]);
							}
							GivePlayerEventWeapons( i );
						}
					}
				}
				else
				{
					SendClientMessageEx( i, COLOR_WHITE, "The event has now started. If you wish to join next time, please use /joinevent." );
				}
			}	
		}
		else
		{
			SendClientMessageEx( playerid, COLOR_WHITE, "There is already an active event (use /endevent)." );
		}
	}
	return 1;
}

CMD:announceevent(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1 || EventKernel[EventCreator] == playerid)
	{
		if( EventKernel[ EventStatus ] == 1)
		{
			EventKernel[ EventStatus ] = 2;
			SendClientMessageEx(playerid, COLOR_GRAD2, "To lock the event use /lockevent");
			if(EventKernel[VipOnly] == 1) SendClientMessageToAllEx( COLOR_LIGHTBLUE, "* A VIP only event has been started by an Administrator, VIP's type /joinevent to participate." );
			else SendClientMessageToAllEx( COLOR_LIGHTBLUE, "* An event has been started by an Administrator, type /joinevent to participate." );
		}
		else
		{
			SendClientMessageEx( playerid, COLOR_WHITE, "There is already an active event (use /endevent)." );
		}
	}
	return 1;
}

CMD:lockevent(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1 || EventKernel[EventCreator] == playerid)
	{
		if( EventKernel[ EventStatus ] == 2 )
		{
		    if(EventKernel[EventType] == 3 && EventKernel[EventTime] != 0) return SendClientMessageEx(playerid, COLOR_RED, "ERROR: This feature is not available with the configuration setup for this event.");
			EventKernel[ EventStatus ] = 3;
			SendClientMessageEx( playerid, COLOR_GRAD2, "You have locked an event, use /beginevent to officially start the event." );
			SendClientMessageToAllEx( COLOR_LIGHTBLUE, "* The event has been locked by an Administrator." );
		}
		else
		{
			SendClientMessageEx( playerid, COLOR_WHITE, "There is already an active event (use /endevent)." );
		}
	}
	return 1;
}

CMD:event(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 4 || PlayerInfo[playerid][pASM] >= 1 || EventKernel[EventCreator] == playerid)
	{
		if(EventKernel[ EventStatus ] == 0) return SendClientMessageEx(playerid, COLOR_WHITE, "There are currently no active events.");
		new string[128];
		format(string, sizeof(string), "[Event] %s: %s", GetPlayerNameEx(playerid), params);
		foreach(new i: Player)
		{
			if(GetPVarInt(i, "EventToken") || PlayerInfo[i][pAdmin] >= 2 || EventKernel[EventCreator] == i || GetPVarInt(i, "eventStaff"))
			{
				SendClientMessageEx(i, COLOR_OOC, string);
			}
		}
	}
	return 1;
}