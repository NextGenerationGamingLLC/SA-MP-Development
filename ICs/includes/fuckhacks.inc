
/*
															 /$$$$$$$$                  /$$       /$$   /$$                     /$$                
															| $$_____/                 | $$      | $$  | $$                    | $$                
															| $$    /$$   /$$  /$$$$$$$| $$   /$$| $$  | $$  /$$$$$$   /$$$$$$$| $$   /$$  /$$$$$$$
															| $$$$$| $$  | $$ /$$_____/| $$  /$$/| $$$$$$$$ |____  $$ /$$_____/| $$  /$$/ /$$_____/
															| $$__/| $$  | $$| $$      | $$$$$$/ | $$__  $$  /$$$$$$$| $$      | $$$$$$/ |  $$$$$$ 
															| $$   | $$  | $$| $$      | $$_  $$ | $$  | $$ /$$__  $$| $$      | $$_  $$  \____  $$
															| $$   |  $$$$$$/|  $$$$$$$| $$ \  $$| $$  | $$|  $$$$$$$|  $$$$$$$| $$ \  $$ /$$$$$$$/
															|__/    \______/  \_______/|__/  \__/|__/  |__/ \_______/ \_______/|__/  \__/|_______/ 
																							 fuckhacks.inc														
															
																					Credits: Nathan Mallett (ViruZz)
																							
																							Version 0.2
	Nathan's Lessons:	
	Lesson 1: A hacker is your friend, he helps you make a better anti-cheat
	Lesson 2: Never trust the client
	Lesson 3: The server is NEVER wrong
	Lesson 4: Don't ban the hacker, just defeat their cheats and force them to play fair
*/

// All necessary includes (make sure to undef them if they're being used elsewhere)
#include <a_samp>
#include <zcmd>

#if defined _INC_zcmd
	#undef zcmd
#else
	#define _INC_zcmd
#endif

#define STATE_ONPLAYERUPDATE (2)

// Player Enumeration
enum FuckHacksEnum
{
	Float: playerHealth[2], // 0 = What the health should be at | 1 = Is the health synced?
	Float: playerArmour[2], // 0 = What the armour should be at | 1 = Is the armour synced?
	playerAlive,
	lastUpdateTime,
	syncFailed[2],
	playerStatus[3],
	OPUTick,
	playerState
}
new FuckHacksVar[MAX_PLAYERS][FuckHacksEnum];

// Forwards
forward FuckHacks_OnPlayerStateChange(playerid, newstate, oldstate);
forward FuckHacks_OnPlayerUpdate(playerid); 
forward FuckHacks_OnPlayerSpawn(playerid); // Native: FuckHacks_OnPlayerSpawn(playerid);
forward FuckHacks_OnPlayerConnect(playerid); // Native: FuckHacks_OnPlayerConnect(playerid);
forward FuckHacks_OnPlayerRequestSpawn(playerid); // Native: FuckHacks_OnPlayerRequestSpawn(playerid);
forward FuckHacks_OnPlayerDeath(playerid, killerid, reason); // Native: FuckHacks_OnPlayerDeath(playerid, killerid, reason);

// FuckHacks custom functions
stock FuckHacks_SetPlayerHealth(playerid, Float: value)
{
	// Make sure the value is not over what it should be
	if(value > 99.0) value = 99.0;
	if(value < 0.0) value = 0.0;
	FuckHacksVar[playerid][playerHealth][0] = value;
	new string[128];
	format(string, sizeof(string), "SetPlayerHealth has been triggered for player id %d | Amount %f", playerid, value);
	new logname[20+MAX_PLAYER_NAME];
	format(logname, sizeof(logname), "fuckhacks/debug/%s.log", GetClientNameEx(playerid));
	LogEx(logname, string);
	return SetPlayerHealth(playerid, value);
}

stock FuckHacks_SetPlayerArmour(playerid, Float: value)
{
	if(value > 99.0) value = 99.0;
	if(value < 0.0) value = 0.0;
	FuckHacksVar[playerid][playerArmour] = value;
	new string[128];
	format(string, sizeof(string), "SetPlayerHealth has been triggered for player id %d | Amount %f", playerid, value);
	new logname[20+MAX_PLAYER_NAME];
	format(logname, sizeof(logname), "fuckhacks/debug/%s.log", GetClientNameEx(playerid));
	LogEx(logname, string);
	return SetPlayerArmour(playerid, value);
}

Float: GetClientHealth(playerid)
{
	new Float: health;
	health = FuckHacksVar[playerid][playerHealth];
	return Float: health;
}

Float: GetClientArmour(playerid)
{
	new Float: armour;
	armour = FuckHacksVar[playerid][playerArmour];
	return Float: armour;
}


stock KickClientEx(playerid)
{
	Kick(playerid);
}

stock GetClientNameEx(playerid)
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	return name;
}


stock ResetAllSprunkMachines(playerid)
{
	RemoveBuildingForPlayer(playerid, 1302, 0.0, 0.0, 0.0, 6000.0);
    RemoveBuildingForPlayer(playerid, 1209, 0.0, 0.0, 0.0, 6000.0);
    RemoveBuildingForPlayer(playerid, 955, 0.0, 0.0, 0.0, 6000.0);
    RemoveBuildingForPlayer(playerid, 956, 0.0, 0.0, 0.0, 6000.0);
    RemoveBuildingForPlayer(playerid, 1775, 0.0, 0.0, 0.0, 6000.0);
    RemoveBuildingForPlayer(playerid, 1776, 0.0, 0.0, 0.0, 6000.0);
    RemoveBuildingForPlayer(playerid, 1977, 0.0, 0.0, 0.0, 6000.0);
	return true;
}

stock LogEx(user[], info[])
{
	new string[128+1], time[3], File: file;
	gettime(time[0], time[1], time[2]);
	
	format(string, sizeof(string), "%i:%i:%i | %s\r\n", time[0], time[1], time[2], info);
	
	if(file) fclose(file);
	if(!fexist(user)) file = fopen(user, io_write);
	else file = fopen(user, io_append);
	if(file)
	{
		fwrite(file, string);
		fclose(file);
	}
	return true;
}

forward OnPlayerSync(playerid);
public OnPlayerSync(playerid)
{
	// Is the player alt-tabbed?
	if(FuckHacksVar[playerid][playerState] == STATE_ONPLAYERUPDATE && (gettime() - 10 >= FuckHacksVar[playerid][playerState])) return SetTimerEx("OnPlayerSync", 100, 0, "i", playerid);
	
	// Is the player spawned and not dead?
	if(FuckHacksVar[playerid][playerAlive] == 1)
	{
		// Flag the player that he's currently being synced
		FuckHacksVar[playerid][playerStatus][2] = 1;

		new Float: fHealth, Float: fArmour, iHealth, iArmour, iRealHealth, iRealArmour;
		
		// Get the client health
		GetPlayerHealth(playerid, fHealth);
		
		// Get the client armour
		GetPlayerArmour(playerid, fArmour);
		
		// Round the client health to an integer
		iHealth = floatround(fHealth, floatround_round);
		
		// Round the client armour to an integer
		iArmour = floatround(fArmour, floatround_round);
		
		// Round the server side health to an integer
		iRealHealth = floatround(FuckHacksVar[playerid][playerHealth][0], floatround_round);
		
		// Round the server side armour to an integer
		iRealArmour = floatround(FuckHacksVar[playerid][playerArmour][0], floatround_round);
				
		// Is the client health above the limit?
		if(iHealth > 99)
		{
			// Increase the player status variable
			FuckHacksVar[playerid][playerStatus][0]++;
			
			// Did the player reach 5 flags of having over the limit health? If yes, kick them
			if(FuckHacksVar[playerid][playerStatus][0] == 5)
			{
				SendClientMessage(playerid, -1, "We're unable to sync your health, you might possibly be desynced. Please relog.");
				FuckHacksVar[playerid][syncFailed] = 0;
				new string[128];
				format(string, sizeof(string), "%s health wasnt syncing and has been kicked| Time: %d [Sync Failed - Over 99.9 Health]", GetClientNameEx(playerid), playerid, FuckHacksVar[playerid][playerStatus][0]);
				new logname[20+MAX_PLAYER_NAME];
				format(logname, sizeof(logname), "fuckhacks/debug/kick/%s.log", GetClientNameEx(playerid));
				LogEx(logname, string);
				FuckHacksVar[playerid][playerStatus][0] = 0;
				SetTimerEx("KickClientEx", 1000, 0, "i", playerid);
			}
		}
		
		if(iArmour > 99)
		{
			// Increase the player status variable
			FuckHacksVar[playerid][playerStatus][1]++;
			
			// Did the player reach 5 flags of having over the limit armour? If yes, kick them
			if(FuckHacksVar[playerid][playerStatus][1] == 5)
			{
				SendClientMessage(playerid, -1, "We're unable to sync your armour, you might possibly be desynced. Please relog.");
				FuckHacksVar[playerid][syncFailed] = 0;
				new string[128];
				format(string, sizeof(string), "%s armour wasnt syncing and has been kicked| Time: %d [Sync Failed - Over 99.9 Armour]", GetClientNameEx(playerid), playerid, FuckHacksVar[playerid][playerStatus][1]);
				new logname[20+MAX_PLAYER_NAME];
				format(logname, sizeof(logname), "fuckhacks/debug/kick/%s.log", GetClientNameEx(playerid));
				LogEx(logname, string);
				FuckHacksVar[playerid][playerStatus][1] = 0;
				SetTimerEx("KickClientEx", 1000, 0, "i", playerid);
			}
		}
			
		// Does the client health matches the server side health?
		if(iHealth != iRealHealth)
		{
			// Sets the player health to what it should be
			FuckHacks_SetPlayerHealth(playerid, iRealHealth);
			
			// Increase the sync failed value if it's below 10
			if(FuckHacksVar[playerid][syncFailed][0] < 10)
			{
				FuckHacksVar[playerid][syncFailed][0]++;
			}
					
			// Get the clients health again
			GetPlayerHealth(playerid, fHealth);
			
			// Round up the new client health to an integer
			iHealth = floatround(fHealth, floatround_round);
			
			// After setting the player health, check to see if it still doesn't match
			if(iHealth != iRealHealth)
			{
				// If this isn't the 10th flag, log it to their player log file
				if(FuckHacksVar[playerid][syncFailed][0] < 10)
				{
					// Yes, this will spam them but who the fuck cares?
					//SendClientMessage(playerid, -1, "Your health isn't syncing, you might be desynced..we'll keep on trying to sync you.");
					new string[128];
					format(string, sizeof(string), "%s health isn't synced, attempting to resync | Time: %d", GetClientNameEx(playerid), playerid, FuckHacksVar[playerid][syncFailed][0]);
					new logname[20+MAX_PLAYER_NAME];
					format(logname, sizeof(logname), "fuckhacks/debug/kick/%s.log", GetClientNameEx(playerid));
					LogEx(logname, string);
					
				}
				else if(FuckHacksVar[playerid][syncFailed][0] == 10) // If the flag was called 10 times, let's just tell them that they're desynced
				{
					//SendClientMessage(playerid, -1, "We're still unabled to set your health, please relog");
					//printf("Kcking Player ID %d because he is desynced or hacking", playerid);
					new string[128];
					format(string, sizeof(string), "%s health wasnt syncing and has been kicked| Time: %d [Sync Failed]", GetClientNameEx(playerid), playerid, FuckHacksVar[playerid][syncFailed][0]);
					new logname[20+MAX_PLAYER_NAME];
					format(logname, sizeof(logname), "fuckhacks/debug/kick/%s.log", GetClientNameEx(playerid));
					LogEx(logname, string);
					FuckHacksVar[playerid][syncFailed][0] = 0;
					SetTimerEx("KickClientEx", 1000, 0, "i", playerid);
				}
			}
		}
		
		// Does the client health matches the server side health?
		if(iArmour != iArmour)
		{
			// Sets the player health to what it should be
			FuckHacks_SetPlayerArmour(playerid, iRealHealth);
			
			// Increase the sync failed value if it's below 10
			if(FuckHacksVar[playerid][syncFailed][1] < 10)
			{
				FuckHacksVar[playerid][syncFailed][1]++;
			}
					
			// Get the clients health armour
			GetPlayerArmour(playerid, fArmour);
			
			// Round up the new client armour to an integer
			iArmour = floatround(fArmour, floatround_round);
			
			// After setting the player armour, check to see if it still doesn't match
			if(iArmour != iRealArmour)
			{
				// If this isn't the 10th flag, log it to their player log file
				if(FuckHacksVar[playerid][syncFailed][1] < 10)
				{
					// Yes, this will spam them but who the fuck cares?
					//SendClientMessage(playerid, -1, "Your armour isn't syncing, you might be desynced..we'll keep on trying to sync you.");
					//printf("Player ID %d armour isn't synced, attempting to resync | Time: %d", playerid, FuckHacksVar[playerid][syncFailed]);
					new string[128];
					format(string, sizeof(string), "%s armour isn't synced, attempting to resync | Time: %d", GetClientNameEx(playerid), playerid, FuckHacksVar[playerid][syncFailed][1]);
					new logname[20+MAX_PLAYER_NAME];
					format(logname, sizeof(logname), "fuckhacks/debug/kick/%s.log", GetClientNameEx(playerid));
					LogEx(logname, string);
				}
				else if(FuckHacksVar[playerid][syncFailed][1] == 10) // If the flag was called 10 times, let's just tell them that they're desynced
				{
					//SendClientMessage(playerid, -1, "We're still unabled to set your armour, please relog");
					//printf("Kcking Player ID %d because he is desynced or hacking [Armour]", playerid);
					new string[128];
					format(string, sizeof(string), "%s armour wasnt syncing and has been kicked| Time: %d [Sync Failed]", GetClientNameEx(playerid), playerid, FuckHacksVar[playerid][syncFailed][1]);
					new logname[20+MAX_PLAYER_NAME];
					format(logname, sizeof(logname), "fuckhacks/debug/kick/%s.log", GetClientNameEx(playerid));
					LogEx(logname, string);
					FuckHacksVar[playerid][syncFailed][1] = 0;
					SetTimerEx("KickClientEx", 1000, 0, "i", playerid);
				}
			}
		}
	}
	// Unflag the player
	FuckHacksVar[playerid][playerStatus][2] = 0;
	return SetTimerEx("OnPlayerSync", 100, 0, "i", playerid);
}

public OnPlayerConnect(playerid)
{
	ResetAllSprunkMachines(playerid);

	FuckHacksVar[playerid][playerAlive] = 0;
	new string[128];
	format(string, sizeof(string), "OnPlayerConnect has been triggered for player id %d", playerid);
	new logname[20+MAX_PLAYER_NAME];
	format(logname, sizeof(logname), "fuckhacks/debug/%s.log", GetClientNameEx(playerid));
	LogEx(logname, string);
	
	SetTimerEx("OnPlayerSync", 100, 0, "i", playerid);
	
	// Set the player to the same team so SA:MP cannot control their health
	SetPlayerTeam(playerid, 254);
	return CallRemoteFunction("FuckHacks_OnPlayerConnect", "i", playerid);
}

public OnPlayerDeath(playerid, killerid, reason)
{
	FuckHacksVar[playerid][playerAlive] = 0;
	/*new string[128];
	format(string, sizeof(string), "OnPlayerDeath has been triggered for player id %d | Killer ID %d", playerid, killerid);
	new logname[20+MAX_PLAYER_NAME];
	format(logname, sizeof(logname), "fuckhacks/debug/%s.log", GetClientNameEx(playerid));
	LogEx(logname, string); */
	return CallRemoteFunction("FuckHacks_OnPlayerDeath", "iii", playerid, killerid, reason);
}

public OnPlayerSpawn(playerid)
{
	FuckHacksVar[playerid][playerAlive] = 1;
	new string[128];
	format(string, sizeof(string), "OnPlayerSpawn has been triggered for player id %d", playerid);
	new logname[20+MAX_PLAYER_NAME];
	format(logname, sizeof(logname), "fuckhacks/debug/%s.log", GetClientNameEx(playerid));
	LogEx(logname, string);
	return CallRemoteFunction("FuckHacks_OnPlayerSpawn", "i", playerid);
}

public OnPlayerRequestSpawn(playerid)
{
	FuckHacksVar[playerid][playerAlive] = 0;
	new string[128];
	format(string, sizeof(string), "OnPlayerRequestSpawn has been triggered for player id %d", playerid);
	new logname[20+MAX_PLAYER_NAME];
	format(logname, sizeof(logname), "fuckhacks/debug/%s.log", GetClientNameEx(playerid));
	LogEx(logname, string);
	return CallRemoteFunction("FuckHacks_OnPlayerRequestSpawn", "i", playerid);
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	// If the player died, set their server side armour & health to 0
	if(newstate == PLAYER_STATE_WASTED) FuckHacksVar[playerid][playerArmour][0] = 0, FuckHacksVar[playerid][playerHealth][0] = 0;
	return true;
}

public OnPlayerUpdate(playerid) return FuckHacksVar[playerid][playerState] = STATE_ONPLAYERUPDATE, FuckHacksVar[playerid][OPUTick] = gettime(), true;

// ALS Defines

// OnPlayerUpdate
#if defined _ALS_OnPlayerUpdate
	#undef OnPlayerUpdate
#else
	#define _ALS_OnPlayerUpdate
#endif
#define OnPlayerUpdate FuckHacks_OnPlayerUpdate

// OnPlayerJoin
#if defined _ALS_OnPlayerConnect
	#undef OnPlayerConnect
#else
	#define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect FuckHacks_OnPlayerConnect

// OnPlayerSpawn
#if defined _ALS_OnPlayerSpawn
	#undef OnPlayerSpawn
#else
	#define _ALS_OnPlayerSpawn
#endif
#define OnPlayerSpawn FuckHacks_OnPlayerSpawn

// OnPlayerRequestSpawn
#if defined _ALS_OnPlayerRequestSpawn
	#undef OnPlayerRequestSpawn
#else
	#define _ALS_OnPlayerRequestSpawn
#endif
#define OnPlayerRequestSpawn FuckHacks_OnPlayerRequestSpawn

// OnPlayerStateChange
#if defined _ALS_OnPlayerStateChange
	#undef OnPlayerStateChange
#else
	#define _ALS_OnPlayerStateChange
#endif
#define OnPlayerStateChange FuckHacks_OnPlayerStateChange

// OnPlayerDeath
#if defined _ALS_OnPlayerDeath
	#undef OnPlayerDeath
#else
	#define _ALS_OnPlayerDeath
#endif
#define OnPlayerDeath FuckHacks_OnPlayerDeath

// SetPlayerHealth
#if defined _ALS_SetPlayerHealth
	#undef SetPlayerHealth
#else
	#define _ALS_SetPlayerHealth
#endif
#define SetPlayerHealth FuckHacks_SetPlayerHealth

// SetPlayerArmour
#if defined _ALS_SetPlayerArmour
	#undef SetPlayerArmour
#else
	#define _ALS_SetPlayerArmour
#endif
#define SetPlayerArmour FuckHacks_SetPlayerArmour

CMD:info(playerid, params[])
{
	new string[128], Float: fHealth;
	GetPlayerHealth(playerid, fHealth);
	format(string, sizeof(string), "syncFailed: %d | realHealth %f | Current Health %f | Sync: %d", FuckHacksVar[playerid][syncFailed], FuckHacksVar[playerid][playerHealth][0], fHealth, FuckHacksVar[playerid][playerHealth][1]);
	SendClientMessage(playerid, -1, string);
	return true;
}