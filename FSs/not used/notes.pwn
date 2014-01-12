//-------------------------------------------
//   NFS Filter Script v1.1
//   Designed for SA-MP v3.0b
//-------------------------------------------
#include <a_samp>
#include <YSI\y_ini>
#define MAX_NOTES 50
#define MAX_MODERATORS 10
#define INVALID_NOTE_ID 1337
#define COLOR_REPORT 0xFFFF91FF
#define COLOR_YELLOW 0xFFFF00AA
#define COLOR_GRAD2 0xBFC0C2FF
#define COLOR_GREEN 0x33AA33AA
forward SendNoteToQue(notefrom, note[]);
forward ClearNotes();
forward LoadNotes();
forward SaveNotes();
forward split(const strsrc[], strdest[][], delimiter);
enum notesinfo
{
	HasBeenUsed,
	Note[128],
	NoteFrom[MAX_PLAYER_NAME],
}
new Notes[MAX_NOTES][notesinfo];
enum moderatorsinfo
{
	HasBeenUsed,
	ModeratorTitle[68],
	ModeratorName[MAX_PLAYER_NAME],
}
new Mods[MAX_MODERATORS][moderatorsinfo];
new modcount = 0;
INI:moderators[](name[], value[])
{
	strmid(Mods[modcount][ModeratorName], name, 0, strlen(name), 128);
	strmid(Mods[modcount][ModeratorTitle], value, 0, strlen(value), 128);
	printf("%s = %s (modcount = %d)", name, value, modcount);
	modcount++;
}
public OnFilterScriptInit()
{
	print("\n Notes v1.1 Loading...");
	INI_Load("moderators.ini");
	LoadNotes();
}
public OnFilterScriptExit()
{
	print("\n Notes Script UnLoaded");
	return 1;
}
public SendNoteToQue(notefrom, note[])
{
    new bool:breakingloop = false, newid = INVALID_NOTE_ID;
	for(new i=0;i<MAX_NOTES;i++)
	{
		if(!breakingloop)
		{
			if(Notes[i][HasBeenUsed] == 0) // Checking for next available ID.
			{
				breakingloop = true;
				newid = i;
			}
		}
    }
    if(newid != INVALID_NOTE_ID)
    {
        strmid(Notes[newid][Note], note, 0, strlen(note), 128);
        strmid(Notes[newid][NoteFrom], GetPlayerNameEx(notefrom), 0, strlen(GetPlayerNameEx(notefrom)), 128);
        Notes[newid][HasBeenUsed] = 1;
        new string[128];
        format(string, sizeof(string), "Note from [%i]%s (NID: %i): %s", notefrom, GetPlayerNameEx(notefrom), newid, (note));
        SendClientMessageToAll(COLOR_REPORT,string);
        SaveNotes();
    }
    else
    {
        ClearNotes();
        SendNoteToQue(notefrom, note);
    }
}
public ClearNotes()
{
	for(new i=0;i<MAX_NOTES;i++)
	{
		strmid(Notes[i][Note], "None", 0, 4, 4);
		strmid(Notes[i][NoteFrom], "No-one", 0, 6, 6);
        Notes[i][HasBeenUsed] = 0;
	}
	SaveNotes();
	return 1;
}
public SaveNotes()
{
	new idx;
	new File: file2;
	while (idx < sizeof(Notes))
	{
		new coordsstring[256];
		format(coordsstring, sizeof(coordsstring), "%s|%s|%d\n",
		Notes[idx][Note],
		Notes[idx][NoteFrom],
		Notes[idx][HasBeenUsed]);
		if(idx == 0)
		{
			file2 = fopen("notes.cfg", io_write);
		}
		else
		{
			file2 = fopen("notes.cfg", io_append);
		}
		fwrite(file2, coordsstring);
		idx++;
		fclose(file2);
	}
	return 1;
}

public LoadNotes()
{
	new arrCoords[3][128];
	new strFromFile2[256];
	new File: file = fopen("notes.cfg", io_read);
	if (file)
	{
		new idx;
		while (idx < sizeof(Notes))
		{
			fread(file, strFromFile2);
			split(strFromFile2, arrCoords, '|');
			strmid(Notes[idx][Note], arrCoords[0], 0, strlen(arrCoords[0]), 255);
			strmid(Notes[idx][NoteFrom], arrCoords[1], 0, strlen(arrCoords[1]), 255);
			Notes[idx][HasBeenUsed] = strval(arrCoords[2]);
			idx++;
		}
		fclose(file);
	}
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	new string[256];
	//printf( "[cmd] [%s]: %s", GetPlayerNameEx( playerid ), cmdtext );
	new cmd[256], idx;
	new tmp[256];
	cmd = strtok(cmdtext, idx);
	if(strcmp(cmd, "/addnote", true) == 0)
	{
		if(IsPlayerModerator(playerid))
		{
			new length = strlen(cmdtext);
			while ((idx < length) && (cmdtext[idx] <= ' '))
			{
				idx++;
			}
			new offset = idx;
			new result[128];
			while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
			{
				result[idx - offset] = cmdtext[idx];
				idx++;
			}
			result[idx - offset] = EOS;
			if(!strlen(result))
			{
				SendClientMessage(playerid, COLOR_GRAD2, "USAGE: /addnote [text]");
				return 1;
			}
			format(string, sizeof(string), "%s", (result));
			SendNoteToQue(playerid, string);
			SendClientMessage(playerid, COLOR_YELLOW, "Your note message was stored.");
		}
		return 1;
	}
	if(strcmp(cmd, "/delnote", true) == 0)
	{
		if(IsPlayerModerator(playerid))
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_GRAD2,"USAGE: /delnote [noteid]");
				return 1;
			}
			new noteid = strval(tmp);
			format(string, sizeof(string), "Note ID: %d was deleted.", noteid);
			strmid(Notes[noteid][Note], "None", 0, 4, 4);
			strmid(Notes[noteid][NoteFrom], "No-one", 0, 6, 6);
        	Notes[noteid][HasBeenUsed] = 0;
        	SaveNotes();
			SendClientMessage(playerid, COLOR_YELLOW, string);
		}
		return 1;
	}
	if(strcmp(cmd, "/addmoderator", true) == 0)
	{
		if(IsPlayerAdmin(playerid))
		{
			if(modcount == MAX_MODERATORS) return 1;
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_GRAD2,"USAGE: /addmoderator [player] [title]");
				return 1;
			}
			new playername[MAX_PLAYER_NAME];
			strmid(playername, tmp, 0, strlen(tmp), MAX_PLAYER_NAME);
			new length = strlen(cmdtext);
			while ((idx < length) && (cmdtext[idx] <= ' '))
			{
				idx++;
			}
			new offset = idx;
			new result[128];
			while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
			{
				result[idx - offset] = cmdtext[idx];
				idx++;
			}
			result[idx - offset] = EOS;
			if(!strlen(result))
			{
				SendClientMessage(playerid, COLOR_GRAD2, "USAGE: /addmoderator [player] [title]");
				return 1;
			}
			new INI:file = INI_Open("moderators.ini");
			for(new i=0;i<MAX_MODERATORS;i++)
			{
				if(strlen(Mods[i][ModeratorName]))
				{
					INI_WriteString(file, Mods[i][ModeratorName], Mods[i][ModeratorTitle]);
				}
			}
			INI_WriteString(file, playername, result);
			INI_Close(file);
			strmid(Mods[modcount][ModeratorName], playername, 0, strlen(playername), MAX_PLAYER_NAME);
			strmid(Mods[modcount][ModeratorTitle], result, 0, strlen(result), 68);
			modcount++;
		}
		return 1;
	}
	if(strcmp(cmd, "/clearnotes", true) == 0)
	{
  		if (IsPlayerModerator(playerid))
		{
			ClearNotes();
			new title[68];
			GetModeratorTitle(playerid, title);
			SendClientMessage(playerid,COLOR_GRAD2, "You have cleared all the active notes.");
			format( string, sizeof( string ), "AdmCmd: %s %s has cleared all the active notes.", title, GetPlayerNameEx(playerid) );
			SendClientMessageToAll( COLOR_GREEN, string );
		}
		else
		{
			SendClientMessage(playerid, COLOR_GRAD2, "You are not authorized to use that command!");
		}
		return 1;
	}
	if(strcmp(cmd, "/nmods", true) == 0)
	{
	    SendClientMessage(playerid,COLOR_GREEN, "Notes Moderators:");
	    for(new i=0;i<MAX_MODERATORS;i++)
		{
			if(strlen(Mods[i][ModeratorName]) > 0)
			{
				format( string, sizeof( string ), "Title: %s Name: %s.", Mods[i][ModeratorTitle], Mods[i][ModeratorName] );
				SendClientMessage( playerid , COLOR_GRAD2 , string );
			}
		}
	}
	if(strcmp(cmd, "/notes", true) == 0)
	{
	    SendClientMessage(playerid, COLOR_GREEN, "____________________ NOTES _____________________");
		for(new i = 0; i < MAX_NOTES; i++)
		{
		    if(Notes[i][HasBeenUsed] == 1)
		    {
				format(string, sizeof(string), "NID %d | From:%s | Note: %s.", i, (Notes[i][NoteFrom]), (Notes[i][Note]));
       			SendClientMessage(playerid, COLOR_REPORT, string);
			}
		}
		SendClientMessage(playerid, COLOR_GREEN, "___________________________________________________");
		return 1;
	}
	return 0;
}

stock GetPlayerNameEx(playerid)
{
	 new string[MAX_PLAYER_NAME];
	 GetPlayerName(playerid, string, sizeof(string));
	 for(new i; i < MAX_PLAYER_NAME; i++) if (string[i] == '_') string[i] = ' ';
	 return string;
}

stock IsPlayerModerator(playerid)
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	for(new i=0;i<MAX_MODERATORS;i++)
	{
		if(strcmp(name, Mods[i][ModeratorName])==0 && strlen(Mods[i][ModeratorName]))
		{
			printf("%s is a notes mod(modcount = %d)", name, i);
			return true;
		}
	}
	return false;
}

stock GetModeratorTitle(playerid, title[])
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	for(new i=0;i<MAX_MODERATORS;i++)
	{
		if(strcmp(name, Mods[i][ModeratorName])==0 && strlen(Mods[i][ModeratorName]))
		{
			printf("%s is a notes mod(title = %s modcount = %d)", name, Mods[i][ModeratorTitle], i);
			strmid(title, Mods[i][ModeratorTitle], 0, strlen(Mods[i][ModeratorTitle]), 128);
		}
	}
}

strtok(const string[], &index)
{
	new length = strlen(string);
	while ((index < length) && (string[index] <= ' '))
	{
		index++;
	}

	new offset = index;
	new result[20];
	while ((index < length) && (string[index] > ' ') && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	return result;
}

public split(const strsrc[], strdest[][], delimiter)
{
	new i, li;
	new aNum;
	new len;
	while(i <= strlen(strsrc)){
		if(strsrc[i]==delimiter || i==strlen(strsrc)){
			len = strmid(strdest[aNum], strsrc, li, i, 128);
			strdest[aNum][len] = 0;
			li = i+1;
			aNum++;
		}
		i++;
	}
	return 1;
}

public OnPlayerSpawn(playerid)
{
	if(GetPVarInt(playerid, "FirstSpawn") == 1)
	{
		if(IsPlayerModerator(playerid))
		{
			SendClientMessage(playerid, COLOR_GREEN, "You are allowed to use '/addnote' '/delnote' '/clearnotes'");
		}	
		else
		{
			SendClientMessage(playerid, COLOR_GREEN, "Please make sure you check /notes before doing anything.");
		}
	}
}
