// This is a comment
// uncomment the line below if you want to write a filterscript
//#define FILTERSCRIPT

#include <a_samp>

forward Tracker();
forward DebugLog(string[]);

new Member[MAX_PLAYERS];
new Float:GetLocation[MAX_PLAYERS][3];
new pInt[MAX_PLAYERS];

public OnFilterScriptInit()
{
	print("\nIn-Game Plotter loaded...");
	print("Maps Spots/pickups and entrances\n");
	SetTimer("Tracker", 500, 1);
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

public OnPlayerConnect(playerid)
{
	Member[playerid]=0;
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	new idx;
	if (strcmp("/joindebug", cmdtext, true, 10) == 0)
	{
	    Member[playerid]=1;
	    return 1;
	}
	if (strcmp("/debugnote", cmdtext, true, 10) == 0)
	{
        if(!Member[playerid])
		{
		    SendClientMessage(playerid, 0xF0F0F0FF, "You are not concerned...");
			return 1;
		}
		new sendername[MAX_PLAYER_NAME];
		GetPlayerName(playerid, sendername, sizeof(sendername));
		new length = strlen(cmdtext);
		while ((idx < length) && (cmdtext[idx] <= ' '))
		{
			idx++;
		}
		new offset = idx;
		new result[64];
		while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
		{
			result[idx - offset] = cmdtext[idx];
			idx++;
		}
		result[idx - offset] = EOS;
		if(!strlen(result))
		{
			SendClientMessage(playerid, 0xF0F0F0FF, "USAGE: /debugnote [text]");
			return 1;
		}
        new string[128];
		format(string, sizeof(string), "Note from %s: %s", sendername, (result));
		SendClientMessage(playerid, 0x33DDDDFF, "Pickup or enter the entrance now.");
	    return 1;
	}
    if (strcmp("/savenote", cmdtext, true, 10) == 0)
	{
		new sendername[MAX_PLAYER_NAME];
		GetPlayerName(playerid, sendername, sizeof(sendername));
		new length = strlen(cmdtext);
		while ((idx < length) && (cmdtext[idx] <= ' '))
		{
			idx++;
		}
		new offset = idx;
		new result[64];
		while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
		{
			result[idx - offset] = cmdtext[idx];
			idx++;
		}
		result[idx - offset] = EOS;
		if(!Member[playerid])
		{
		    SendClientMessage(playerid, 0xF0F0F0FF, "You are not concerned...");
			return 1;
		}
		if(!strlen(result))
		{
			SendClientMessage(playerid, 0xF0F0F0FF, "USAGE: /debugnote [text]");
			return 1;
		}
        new string[128];
		format(string, sizeof(string), "Note from %s: %s", sendername, (result));
		DebugLog(string);
		GetPlayerPos(playerid, GetLocation[playerid][0], GetLocation[playerid][1], GetLocation[playerid][2]);
	    pInt[playerid] = GetPlayerInterior(playerid);
		format(string, sizeof(string), "AT %f,%f,%f : INT %d", GetLocation[playerid][0], GetLocation[playerid][1], GetLocation[playerid][2], pInt[playerid]);
		DebugLog(string);
		
	    return 1;
	}
	return 0;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	if(Member[playerid])
	{
	    if(GetPlayerInterior(playerid)>0&&Member[playerid])
	    {
            new debugname[MAX_PLAYER_NAME];
			new string[128];
			GetPlayerName(playerid,debugname[playerid], 24);
			if(newinteriorid!=0&&oldinteriorid==0)
			{
			format(string, sizeof(string), "%s entered interior", debugname[playerid]);
   	    	DebugLog("Entered\n");
			}
			if(newinteriorid==0&&oldinteriorid!=0)
			{
			format(string, sizeof(string), "%s exited interior", debugname[playerid]);
   	    	DebugLog("Exited\n");
			}
			GetPlayerPos(playerid, GetLocation[playerid][0], GetLocation[playerid][1], GetLocation[playerid][2]);
	    	pInt[playerid] = GetPlayerInterior(playerid);
	    	format(string, sizeof(string), "\nPosition: AT %f,%f,%f : INT ID %i\n", GetLocation[playerid][0], GetLocation[playerid][1], GetLocation[playerid][2], pInt[playerid]);
	    	DebugLog(string);
		}
	}
	return 1;
}

public DebugLog(string[])
{
	new entry[256];
	format(entry, sizeof(entry), "%s\n",string);
	new File:hFile;
	hFile = fopen("debug.log", io_append);
	fwrite(hFile, entry);
	fclose(hFile);
}
