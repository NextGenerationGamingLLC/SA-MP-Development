/*

		Anticheat
		- Anticheat Script written by CalgonX / FreddoX.
		
	This filterscript will detect weapon hacking.

*/

#include 		<a_samp>
#include 		<foreach>

#define 		LIGHTRED 						0xFF8080FF
#define     	WEAPON_HACKER_WARNINGS     		3

forward AntiWeaponSpawnTimer();
forward GivePlayerValidWeapon( playerid, WeaponID, Ammo );
forward ExecuteHackerAction( playerid );

enum TimersEnum
{
	WeaponCheck,
}

new Timers[ TimersEnum ];

public OnFilterScriptInit()
{
	print( "Anticheat loaded." );
	
	Timers[ WeaponCheck ] = SetTimer( "AntiWeaponSpawnTimer", true, 1000 );
	
	return 1;
}

public OnFilterScriptExit()
{
	KillTimer( Timers[ WeaponCheck ] );
	
	print( "Anticheat unloaded." );
	return 1;
}

public GivePlayerValidWeapon( playerid, WeaponID, Ammo )
{
	switch( WeaponID )
	{
	    case 0, 1:
	    {
	        SetPVarInt( playerid, "WeaponSlot0", WeaponID );
	        GivePlayerWeapon( playerid, WeaponID, Ammo );
	    }
	    case 2, 3, 4, 5, 6, 7, 8, 9:
	    {
	        SetPVarInt( playerid, "WeaponSlot1", WeaponID );
	        GivePlayerWeapon( playerid, WeaponID, Ammo );
	    }
	    case 22, 23, 24:
	    {
	        SetPVarInt( playerid, "WeaponSlot2", WeaponID );
	        GivePlayerWeapon( playerid, WeaponID, Ammo );
	    }
	    case 25, 26, 27:
	    {
	        SetPVarInt( playerid, "WeaponSlot3", WeaponID );
	        GivePlayerWeapon( playerid, WeaponID, Ammo );
	    }
	    case 28, 29, 32:
	    {
	        SetPVarInt( playerid, "WeaponSlot4", WeaponID );
	        GivePlayerWeapon( playerid, WeaponID, Ammo );
	    }
	    case 30, 31:
	    {
	        SetPVarInt( playerid, "WeaponSlot5", WeaponID );
	        GivePlayerWeapon( playerid, WeaponID, Ammo );
	    }
	    case 33, 34:
	    {
	        SetPVarInt( playerid, "WeaponSlot6", WeaponID );
	        GivePlayerWeapon( playerid, WeaponID, Ammo );
	    }
	    case 35, 36, 37, 38:
	    {
	        SetPVarInt( playerid, "WeaponSlot7", WeaponID );
	        GivePlayerWeapon( playerid, WeaponID, Ammo );
	    }
	    case 16, 17, 18, 39:
	    {
	        SetPVarInt( playerid, "WeaponSlot8", WeaponID );
	        GivePlayerWeapon( playerid, WeaponID, Ammo );
	    }
	    case 41, 42, 43:
	    {
	        SetPVarInt( playerid, "WeaponSlot9", WeaponID );
	        GivePlayerWeapon( playerid, WeaponID, Ammo );
	    }
	    case 10, 11, 12, 13, 14, 15:
	    {
	        SetPVarInt( playerid, "WeaponSlot10", WeaponID );
	        GivePlayerWeapon( playerid, WeaponID, Ammo );
	    }
	    case 44, 45, 46:
	    {
	        SetPVarInt( playerid, "WeaponSlot11", WeaponID );
	        GivePlayerWeapon( playerid, WeaponID, Ammo );
	    }
	}
	
	return 1;
}

public ExecuteHackerAction( playerid )
{
	new HackWarnings = GetPVarInt( playerid, "HackWarnings" ), NameStr[ MAX_PLAYER_NAME ], String[ 128 ], WeaponName[ 128 ];
	SetPVarInt( playerid, "HackWarnings", HackWarnings+1 );
	GetWeaponName( GetPlayerWeapon( playerid ), WeaponName, sizeof( WeaponName ) );
	GetPlayerName( playerid, NameStr, sizeof( NameStr ) );
	
	format( String, sizeof( String ), "WARNING: %s may possibly be weapon-hacking (%s) [%d].", NameStr, WeaponName, HackWarnings-WEAPON_HACKER_WARNINGS );
	CallRemoteFunction( "SendAdminMessage", "ds", LIGHTRED, String );

	if( HackWarnings >= WEAPON_HACKER_WARNINGS )
	{
		format( String, sizeof( String ), "AdmCmd: %s has been banned, reason: Weapon Hacking (%s).", NameStr, WeaponName );
		SendClientMessageToAll( LIGHTRED, String );
		Ban( playerid );
	}

	return 1;
}

public AntiWeaponSpawnTimer()
{
	new PlayerWeapon;
	
	foreach(Player, i)
	{
	    PlayerWeapon = GetPlayerWeapon( i );
	    if( PlayerWeapon >= 1)
	    {
			switch( PlayerWeapon )
			{
			    case 0, 1:
			    {
			        if( GetPVarInt( i, "WeaponSlot0" ) != PlayerWeapon )
			        {
			            ExecuteHackerAction( i );
			        }
			    }
			    case 2, 3, 4, 5, 6, 7, 8, 9:
			    {
			        if( GetPVarInt( i, "WeaponSlot1" ) != PlayerWeapon )
			        {
			            ExecuteHackerAction( i );
			        }
			    }
			    case 22, 23, 24:
			    {
			        if( GetPVarInt( i, "WeaponSlot2" ) != PlayerWeapon )
			        {
			            ExecuteHackerAction( i );
			        }
			    }
			    case 25, 26, 27:
			    {
			        if( GetPVarInt( i, "WeaponSlot3" ) != PlayerWeapon )
			        {
			            ExecuteHackerAction( i );
			        }
			    }
			    case 28, 29, 32:
			    {
			        if( GetPVarInt( i, "WeaponSlot4" ) != PlayerWeapon )
			        {
			            ExecuteHackerAction( i );
			        }
			    }
			    case 30, 31:
			    {
			        if( GetPVarInt( i, "WeaponSlot5" ) != PlayerWeapon )
			        {
			            ExecuteHackerAction( i );
			        }
			    }
			    case 33, 34:
			    {
			        if( GetPVarInt( i, "WeaponSlot6" ) != PlayerWeapon )
			        {
			            ExecuteHackerAction( i );
			        }
			    }
			    case 35, 36, 37, 38:
			    {
			        if( GetPVarInt( i, "WeaponSlot7" ) != PlayerWeapon )
			        {
			            ExecuteHackerAction( i );
			        }
			    }
			    case 16, 17, 18, 39:
			    {
			        if( GetPVarInt( i, "WeaponSlot8" ) != PlayerWeapon )
			        {
			            ExecuteHackerAction( i );
			        }
			    }
			    case 41, 42, 43:
			    {
			        if( GetPVarInt( i, "WeaponSlot9" ) != PlayerWeapon )
			        {
			            ExecuteHackerAction( i );
			        }
			    }
			    case 10, 11, 12, 13, 14, 15:
			    {
			        if( GetPVarInt( i, "WeaponSlot10" ) != PlayerWeapon )
			        {
			            ExecuteHackerAction( i );
			        }
			    }
			    case 44, 45, 46:
			    {
			        if( GetPVarInt( i, "WeaponSlot11" ) != PlayerWeapon )
			        {
			            ExecuteHackerAction( i );
			        }
			    }
			}
	    }
	}
	return 1;
}
