stock SpectatePlayer(playerid, giveplayerid)
{
	if(IsPlayerConnected(giveplayerid)) {
		if( InsideTut{giveplayerid} >= 1 ) {
			SendClientMessageEx(playerid, COLOR_WHITE, "NOTE: This person is in the tutorial. Please consider this before assuming that they're air-breaking.");
		}
		if(PlayerInfo[giveplayerid][pAccountRestricted]) SendClientMessageEx(playerid, COLOR_WHITE, "NOTE: This person has their account restricted. Please consider this before assuming that they're health hacking.");
		if(Spectating[playerid] == 0) {
			new Float: pPositions[3];
			GetPlayerPos(playerid, pPositions[0], pPositions[1], pPositions[2]);
			SetPVarFloat(playerid, "SpecPosX", pPositions[0]);
			SetPVarFloat(playerid, "SpecPosY", pPositions[1]);
			SetPVarFloat(playerid, "SpecPosZ", pPositions[2]);
			SetPVarInt(playerid, "SpecInt", GetPlayerInterior(playerid));
			SetPVarInt(playerid, "SpecVW", GetPlayerVirtualWorld(playerid));
			if(IsPlayerInAnyVehicle(giveplayerid)) {
				TogglePlayerSpectating(playerid, true);
				new carid = GetPlayerVehicleID( giveplayerid );
				PlayerSpectateVehicle( playerid, carid );
				SetPlayerInterior( playerid, GetPlayerInterior( giveplayerid ) );
				SetPlayerVirtualWorld( playerid, GetPlayerVirtualWorld( giveplayerid ) );
			}
			else if(InsidePlane[giveplayerid] != INVALID_VEHICLE_ID) {
				TogglePlayerSpectating(playerid, true);
				PlayerSpectateVehicle(playerid, InsidePlane[giveplayerid]);
				SetPlayerInterior(playerid, GetPlayerInterior(giveplayerid));
				SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(giveplayerid));
			}
			else {
				for(new i = 0; i < 2; i++) {
					TogglePlayerSpectating(playerid, true);
					PlayerSpectatePlayer( playerid, giveplayerid );
					SetPlayerInterior( playerid, GetPlayerInterior( giveplayerid ) );
					SetPlayerVirtualWorld( playerid, GetPlayerVirtualWorld( giveplayerid ) );
				}	
			}
			GettingSpectated[giveplayerid] = playerid;
			if(Spectate[playerid] != giveplayerid) SpecTime[playerid] = gettime();
			Spectate[playerid] = giveplayerid;
			Spectating[playerid] = 1;
		}
		else {
			if(IsPlayerInAnyVehicle(giveplayerid)) {
				TogglePlayerSpectating(playerid, true);
				new carid = GetPlayerVehicleID( giveplayerid );
				PlayerSpectateVehicle( playerid, carid );
				SetPlayerInterior( playerid, GetPlayerInterior( giveplayerid ) );
				SetPlayerVirtualWorld( playerid, GetPlayerVirtualWorld( giveplayerid ) );
			}
			else if(InsidePlane[giveplayerid] != INVALID_VEHICLE_ID) {
				TogglePlayerSpectating(playerid, true);
				PlayerSpectateVehicle(playerid, InsidePlane[giveplayerid]);
				SetPlayerInterior(playerid, GetPlayerInterior(giveplayerid));
				SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(giveplayerid));
			}
			else {
				for(new i = 0; i < 2; i++) {
					TogglePlayerSpectating(playerid, true);
					PlayerSpectatePlayer( playerid, giveplayerid );
					SetPlayerInterior( playerid, GetPlayerInterior( giveplayerid ) );
					SetPlayerVirtualWorld( playerid, GetPlayerVirtualWorld( giveplayerid ) );
				}	
			}
			GettingSpectated[Spectate[playerid]] = INVALID_PLAYER_ID;
			GettingSpectated[giveplayerid] = playerid;
			if(Spectate[playerid] != giveplayerid) SpecTime[playerid] = gettime();
			Spectate[playerid] = giveplayerid;
			Spectating[playerid] = 1;
		}
		new string[64];
		format(string, sizeof(string), "You are spectating %s (ID: %d).", GetPlayerNameEx(giveplayerid), giveplayerid);
		SendClientMessageEx(playerid, COLOR_WHITE, string);
	}	
	return 1;
}

forward SpecUpdate(playerid);
public SpecUpdate(playerid)
{
	if(Spectating[playerid] > 0 && Spectate[playerid] != INVALID_PLAYER_ID)
	{	
		for(new i = 0; i < 2; i++)
		{
			TogglePlayerSpectating(playerid, true);
			PlayerSpectatePlayer( playerid, Spectate[playerid] );
			SetPlayerInterior( playerid, GetPlayerInterior( Spectate[playerid] ) );
			SetPlayerVirtualWorld( playerid, GetPlayerVirtualWorld( Spectate[playerid] ) );
		}	
	}	
	else if(Spectating[playerid] > 0 && GetPVarType(playerid, "SpectatingWatch"))
	{
		for(new i = 0; i < 2; i++)
		{
			TogglePlayerSpectating(playerid, true);
			PlayerSpectatePlayer( playerid, GetPVarInt(playerid, "SpectatingWatch") );
			SetPlayerInterior( playerid, GetPlayerInterior( GetPVarInt(playerid, "SpectatingWatch") ) );
			SetPlayerVirtualWorld( playerid, GetPlayerVirtualWorld( GetPVarInt(playerid, "SpectatingWatch") ) );
		}	
	}
	return 1;
}