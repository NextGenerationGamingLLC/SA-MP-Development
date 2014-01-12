#define COLOR_RED (0xFF0000FF)
#define COLOR_YELLOW (0xFFFF00FF)
#define dcmd(%1,%2,%3) if ((strcmp((%3)[1], #%1, true, (%2)) == 0) && ((((%3)[(%2) + 1] == 0) && (dcmd_%1(playerid, "")))||(((%3)[(%2) + 1] == 32) && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1 // Courtesy of DracoBlue

#include <a_samp>
#include <audio>

public
	OnFilterScriptInit()
{
	// Set the audio pack when the filterscript loads
	Audio_SetPack("default_pack", true);
	return 1;
}

/*
	Here are some testing commands.
*/

public
	OnPlayerCommandText(playerid, cmdtext[])
{
	dcmd(createsequence, 14, cmdtext);
	dcmd(destroysequence, 15, cmdtext);
	dcmd(addtosequence, 13, cmdtext);
	dcmd(removefromsequence, 18, cmdtext);
	dcmd(play, 4, cmdtext);
	dcmd(playsequence, 12, cmdtext);
	dcmd(playstreamed, 12, cmdtext);
	dcmd(pause, 5, cmdtext);
	dcmd(resume, 6, cmdtext);
	dcmd(stop, 4, cmdtext);
	dcmd(restart, 7, cmdtext);
	dcmd(seek, 4, cmdtext);
	dcmd(setvolume, 9, cmdtext);
	dcmd(set3dposition, 13, cmdtext);
	dcmd(set3doffsets, 12, cmdtext);
	dcmd(seteax, 6, cmdtext);
	dcmd(removeeax, 9, cmdtext);
	dcmd(setfx, 5, cmdtext);
	dcmd(removefx, 8, cmdtext);
	dcmd(connected, 9, cmdtext);
	dcmd(setpack, 7, cmdtext);
	return 0;
}

dcmd_createsequence(playerid, params[])
{
	#pragma unused playerid, params
	new
		sequenceid,
		string[64];
	sequenceid = Audio_CreateSequence();
	if (sequenceid)
	{
		format(string, sizeof(string), "Sequence ID %d created", sequenceid);
	}
	else
	{
		format(string, sizeof(string), "Error creating sequence ID %d", sequenceid);
	}
	SendClientMessageToAll(COLOR_YELLOW, string);
	return 1;
}

dcmd_destroysequence(playerid, params[])
{
	#pragma unused playerid
	new
		sequenceid = strval(params);
	if (!sequenceid)
	{
		SendClientMessage(playerid, COLOR_YELLOW, "USAGE: /destroysequence <sequenceid>");
		return 1;
	}
	new
		string[64];
	if (Audio_DestroySequence(sequenceid))
	{
		format(string, sizeof(string), "Sequence ID %d destroyed", sequenceid);
	}
	else
	{
		format(string, sizeof(string), "Error destroying sequence ID %d", sequenceid);
	}
	SendClientMessageToAll(COLOR_YELLOW, string);
	return 1;
}

dcmd_addtosequence(playerid, params[])
{
	#pragma unused playerid
	new
		audioid,
		sequenceid;
	if (sscanf(params, "dd", sequenceid, audioid))
	{
		SendClientMessage(playerid, COLOR_YELLOW, "USAGE: /addtosequence <sequenceid> <audioid>");
		return 1;
	}
	new
		string[64];
	if (Audio_AddToSequence(sequenceid, audioid))
	{
		format(string, sizeof(string), "Audio ID %d added to sequence ID %d", audioid, sequenceid);
	}
	else
	{
		format(string, sizeof(string), "Error adding audio ID %d to sequence ID %d", audioid, sequenceid);
	}
	SendClientMessageToAll(COLOR_YELLOW, string);
	return 1;
}

dcmd_removefromsequence(playerid, params[])
{
	#pragma unused playerid
	new
		audioid,
		sequenceid;
	if (sscanf(params, "dd", sequenceid, audioid))
	{
		SendClientMessage(playerid, COLOR_YELLOW, "USAGE: /removefromsequence <sequenceid> <audioid>");
		return 1;
	}
	new
		string[64];
	if (Audio_RemoveFromSequence(sequenceid, audioid))
	{
		format(string, sizeof(string), "Audio ID %d removed from sequence ID %d", audioid, sequenceid);
	}
	else
	{
		format(string, sizeof(string), "Error removing audio ID %d from sequence ID %d", audioid, sequenceid);
	}
	SendClientMessageToAll(COLOR_YELLOW, string);
	return 1;
}

dcmd_play(playerid, params[])
{
	#pragma unused playerid
	new
		audioid,
		bool:downmix,
		bool:loop,
		bool:pause;
	if (sscanf(params, "dddd", audioid, pause, loop, downmix))
	{
		SendClientMessage(playerid, COLOR_YELLOW, "USAGE: /play <audioid> <pause (0/1)> <loop (0/1)> <downmix (0/1)>");
		return 1;
	}
	Audio_Play(playerid, audioid, pause, loop, downmix);
	return 1;
}

dcmd_playsequence(playerid, params[])
{
	#pragma unused playerid
	new
		audioid,
		bool:downmix,
		bool:loop,
		bool:pause;
	if (sscanf(params, "dddd", audioid, pause, loop, downmix))
	{
		SendClientMessage(playerid, COLOR_YELLOW, "USAGE: /playsequence <sequenceid> <pause (0/1)> <loop (0/1)> <downmix (0/1)>");
		return 1;
	}
	Audio_PlaySequence(playerid, audioid, pause, loop, downmix);
	return 1;
}

dcmd_playstreamed(playerid, params[])
{
	#pragma unused playerid
	new
		bool:downmix,
		bool:loop,
		bool:pause,
		url[256];
	if (sscanf(params, "sddd", url, pause, loop, downmix))
	{
		SendClientMessage(playerid, COLOR_YELLOW, "USAGE: /playstreamed <url> <pause (0/1)> <loop (0/1)> <downmix (0/1)>");
		return 1;
	}
	Audio_PlayStreamed(playerid, url, pause, loop, downmix);
	return 1;
}

dcmd_pause(playerid, params[])
{
	#pragma unused playerid
	new
		handleid = strval(params);
	if (!handleid)
	{
		SendClientMessage(playerid, COLOR_YELLOW, "USAGE: /pause <handleid>");
		return 1;
	}
	new
		string[64];
	format(string, sizeof(string), "Audio playback paused for handle ID %d", handleid);
	SendClientMessage(playerid, COLOR_YELLOW, string);
	Audio_Pause(playerid, handleid);
	return 1;
}

dcmd_resume(playerid, params[])
{
	#pragma unused playerid
	new
		handleid = strval(params);
	if (!handleid)
	{
		SendClientMessage(playerid, COLOR_YELLOW, "USAGE: /resume <handleid>");
		return 1;
	}
	new
		string[64];
	format(string, sizeof(string), "Audio playback resumed for handle ID %d", handleid);
	SendClientMessage(playerid, COLOR_YELLOW, string);
	Audio_Resume(playerid, handleid);
	return 1;
}

dcmd_stop(playerid, params[])
{
	#pragma unused playerid
	new
		handleid = strval(params);
	if (!handleid)
	{
		SendClientMessage(playerid, COLOR_YELLOW, "USAGE: /stop <handleid>");
		return 1;
	}
	Audio_Stop(playerid, handleid);
	return 1;
}

dcmd_restart(playerid, params[])
{
	#pragma unused playerid
	new
		handleid = strval(params);
	if (!handleid)
	{
		SendClientMessage(playerid, COLOR_YELLOW, "USAGE: /restart <handleid>");
		return 1;
	}
	new
		string[64];
	format(string, sizeof(string), "Audio playback restarted for handle ID %d", handleid);
	SendClientMessage(playerid, COLOR_YELLOW, string);
	Audio_Restart(playerid, handleid);
	return 1;
}

dcmd_seek(playerid, params[])
{
	#pragma unused playerid
	new
		handleid,
		seconds;
	if (sscanf(params, "dd", handleid, seconds))
	{
		SendClientMessage(playerid, COLOR_YELLOW, "USAGE: /seek <handleid> <seconds>");
		return 1;
	}
	new
		string[64];
	format(string, sizeof(string), "Audio seeked to %d seconds for handle ID %d", seconds, handleid);
	SendClientMessage(playerid, COLOR_YELLOW, string);
	Audio_Seek(playerid, handleid, seconds);
	return 1;
}

dcmd_setvolume(playerid, params[])
{
	#pragma unused playerid
	new
		handleid,
		volume;
	if (sscanf(params, "dd", handleid, volume))
	{
		SendClientMessage(playerid, COLOR_YELLOW, "USAGE: /setvolume <handleid> <volume (0-100)>");
		return 1;
	}
	new
		string[64];
	format(string, sizeof(string), "Audio volume set to %d for handle ID %d", volume, handleid);
	SendClientMessage(playerid, COLOR_YELLOW, string);
	Audio_SetVolume(playerid, handleid, volume);
	return 1;
}

dcmd_set3dposition(playerid, params[])
{
	#pragma unused playerid
	new
		handleid,
		Float:distance,
		Float:x,
		Float:y,
		Float:z;
	if (sscanf(params, "dffff", handleid, x, y, z, distance))
	{
		SendClientMessage(playerid, COLOR_YELLOW, "USAGE: /set3dposition <handleid> <x> <y> <z> <distance>");
		return 1;
	}
	new
		string[128];
	format(string, sizeof(string), "Audio 3D position set to %.01f, %.01f, %.01f (distance: %.01f) for handle ID %d", x, y, z, distance, handleid);
	SendClientMessage(playerid, COLOR_YELLOW, string);
	Audio_Set3DPosition(playerid, handleid, x, y, z, distance);
	return 1;
}

dcmd_set3doffsets(playerid, params[])
{
	#pragma unused playerid
	new
		handleid,
		Float:x,
		Float:y,
		Float:z;
	if (sscanf(params, "dfff", handleid, x, y, z))
	{
		SendClientMessage(playerid, COLOR_YELLOW, "USAGE: /set3doffsets <handleid> <x> <y> <z>");
		return 1;
	}
	new
		string[128];
	format(string, sizeof(string), "Audio 3D offsets set to %.01f, %.01f, %.01f for handle ID %d", x, y, z, handleid);
	SendClientMessage(playerid, COLOR_YELLOW, string);
	Audio_Set3DOffsets(playerid, handleid, x, y, z);
	return 1;
}

dcmd_seteax(playerid, params[])
{
	#pragma unused playerid
	new
		environment;
	if (sscanf(params, "d", environment))
	{
		SendClientMessage(playerid, COLOR_YELLOW, "USAGE: /seteax <environment (0-25)>");
		return 1;
	}
	new
		string[64];
	format(string, sizeof(string), "Audio EAX environment set to %d", environment);
	SendClientMessage(playerid, COLOR_YELLOW, string);
	Audio_SetEAX(playerid, environment);
	return 1;
}

dcmd_removeeax(playerid, params[])
{
	#pragma unused params, playerid
	new
		string[32];
	format(string, sizeof(string), "Audio EAX environment removed");
	SendClientMessage(playerid, COLOR_YELLOW, string);
	Audio_RemoveEAX(playerid);
	return 1;
}

dcmd_setfx(playerid, params[])
{
	#pragma unused playerid
	new
		handleid,
		type;
	if (sscanf(params, "dd", handleid, type))
	{
		SendClientMessage(playerid, COLOR_YELLOW, "USAGE: /setfx <handleid> <type (0-8)>");
		return 1;
	}
	new
		string[64];
	format(string, sizeof(string), "Audio FX type %d applied to handle ID %d", type, handleid);
	SendClientMessage(playerid, COLOR_YELLOW, string);
	Audio_SetFX(playerid, handleid, type);
	return 1;
}

dcmd_removefx(playerid, params[])
{
	#pragma unused playerid
	new
		handleid,
		type;
	if (sscanf(params, "dd", handleid, type))
	{
		SendClientMessage(playerid, COLOR_YELLOW, "USAGE: /removefx <handleid> <type (0-8)>");
		return 1;
	}
	new
		string[64];
	format(string, sizeof(string), "Audio FX type %d removed from handle ID %d", type, handleid);
	SendClientMessage(playerid, COLOR_YELLOW, string);
	Audio_RemoveFX(playerid, handleid, type);
	return 1;
}

dcmd_connected(playerid, params[])
{
	new
		clientMsg[32];
	if (Audio_IsClientConnected(strval(params)))
	{
		format(clientMsg, sizeof(clientMsg), "Client ID %d is connected", strval(params));
		SendClientMessage(playerid, COLOR_YELLOW, clientMsg);
	}
	else
	{
		format(clientMsg, sizeof(clientMsg), "Client ID %d is not connected", strval(params));
		SendClientMessage(playerid, COLOR_YELLOW, clientMsg);
	}
	return 1;
}

dcmd_setpack(playerid, params[])
{
	if (!IsPlayerAdmin(playerid))
	{
		SendClientMessage(playerid, COLOR_RED, "ERROR: You do not have permission to use this command.");
		return 1;
	}
	new
		audiopack[32],
		bool:transferable;
	if (sscanf(params, "sd", audiopack, transferable))
	{
		SendClientMessage(playerid, COLOR_YELLOW, "USAGE: /setpack <audiopack> <transferable (0/1)>");
		return 1;
	}
	Audio_SetPack(audiopack, transferable);
	return 1;
}

public
	Audio_OnClientConnect(playerid)
{
	new
		string[128];
	format(string, sizeof(string), "Audio client ID %d connected", playerid);
	SendClientMessageToAll(COLOR_YELLOW, string);
	// Transfer the audio pack when the player connects
	Audio_TransferPack(playerid);
	return 1;
}

public
	Audio_OnClientDisconnect(playerid)
{
	new
		string[128];
	format(string, sizeof(string), "Audio client ID %d disconnected", playerid);
	SendClientMessageToAll(COLOR_YELLOW, string);
	return 1;
}

public
	Audio_OnPlay(playerid, handleid)
{
	new
		string[64];
	format(string, sizeof(string), "Audio playback started for handle ID %d", handleid);
	SendClientMessage(playerid, COLOR_YELLOW, string);
	return 1;
}

public
	Audio_OnStop(playerid, handleid)
{
	new
		string[64];
	format(string, sizeof(string), "Audio playback stopped for handle ID %d", handleid);
	SendClientMessage(playerid, COLOR_YELLOW, string);
	return 1;
}

public
	Audio_OnSetPack(audiopack[])
{
	new
		string[64];
	format(string, sizeof(string), "Audio pack \"%s\" set", audiopack);
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		// Transfer the audio pack to all players when it is set
		Audio_TransferPack(i);
	}
	return 1;
}

public
	Audio_OnTransferFile(playerid, file[], current, total, result)
{
	new
		string[128];
	switch (result)
	{
		case 0:
		{
			format(string, sizeof(string), "Audio file \"%s\" (%d of %d) finished local download", file, current, total);
		}
		case 1:
		{
			format(string, sizeof(string), "Audio file \"%s\" (%d of %d) finished remote download", file, current, total);
		}
		case 2:
		{
			format(string, sizeof(string), "Audio archive \"%s\" (%d of %d) finished extraction", file, current, total);
		}
		case 3:
		{
			format(string, sizeof(string), "Audio file/archive \"%s\" (%d of %d) passed check", file, current, total);
		}
		case 4:
		{
			format(string, sizeof(string), "Audio file/archive \"%s\" (%d of %d) could not be downloaded or extracted", file, current, total);
		}
	}
	SendClientMessage(playerid, COLOR_YELLOW, string);
	if (current == total)
	{
		SendClientMessage(playerid, COLOR_YELLOW, "All files have been processed");
	}
	return 1;
}

public
	Audio_OnTrackChange(playerid, handleid, track[])
{
	new
		string[128];
	format(string, sizeof(string), "Now playing \"%s\" for handle ID %d", track, handleid);
	SendClientMessage(playerid, COLOR_YELLOW, string);
}

stock
	sscanf(string[], format[], {Float,_}:...)
{
	#if defined isnull
		if (isnull(string))
	#else
		if (string[0] == 0 || (string[0] == 1 && string[1] == 0))
	#endif
		{
			return format[0];
		}
	#pragma tabsize 4
	new
		formatPos = 0,
		stringPos = 0,
		paramPos = 2,
		paramCount = numargs(),
		delim = ' ';
	while (string[stringPos] && string[stringPos] <= ' ')
	{
		stringPos++;
	}
	while (paramPos < paramCount && string[stringPos])
	{
		switch (format[formatPos++])
		{
			case '\0':
			{
				return 0;
			}
			case 'i', 'd':
			{
				new
					neg = 1,
					num = 0,
					ch = string[stringPos];
				if (ch == '-')
				{
					neg = -1;
					ch = string[++stringPos];
				}
				do
				{
					stringPos++;
					if ('0' <= ch <= '9')
					{
						num = (num * 10) + (ch - '0');
					}
					else
					{
						return -1;
					}
				}
				while ((ch = string[stringPos]) > ' ' && ch != delim);
				setarg(paramPos, 0, num * neg);
			}
			case 'h', 'x':
			{
				new
					num = 0,
					ch = string[stringPos];
				do
				{
					stringPos++;
					switch (ch)
					{
						case 'x', 'X':
						{
							num = 0;
							continue;
						}
						case '0' .. '9':
						{
							num = (num << 4) | (ch - '0');
						}
						case 'a' .. 'f':
						{
							num = (num << 4) | (ch - ('a' - 10));
						}
						case 'A' .. 'F':
						{
							num = (num << 4) | (ch - ('A' - 10));
						}
						default:
						{
							return -1;
						}
					}
				}
				while ((ch = string[stringPos]) > ' ' && ch != delim);
				setarg(paramPos, 0, num);
			}
			case 'c':
			{
				setarg(paramPos, 0, string[stringPos++]);
			}
			case 'f':
			{
				setarg(paramPos, 0, _:floatstr(string[stringPos]));
			}
			case 'p':
			{
				delim = format[formatPos++];
				continue;
			}
			case '\'':
			{
				new
					end = formatPos - 1,
					ch;
				while ((ch = format[++end]) && ch != '\'') {}
				if (!ch)
				{
					return -1;
				}
				format[end] = '\0';
				if ((ch = strfind(string, format[formatPos], false, stringPos)) == -1)
				{
					if (format[end + 1])
					{
						return -1;
					}
					return 0;
				}
				format[end] = '\'';
				stringPos = ch + (end - formatPos);
				formatPos = end + 1;
			}
			case 'u':
			{
				new
					end = stringPos - 1,
					id = 0,
					bool:num = true,
					ch;
				while ((ch = string[++end]) && ch != delim)
				{
					if (num)
					{
						if ('0' <= ch <= '9')
						{
							id = (id * 10) + (ch - '0');
						}
						else
						{
							num = false;
						}
					}
				}
				if (num && IsPlayerConnected(id))
				{
					setarg(paramPos, 0, id);
				}
				else
				{
					#if !defined foreach
						#define foreach(%1,%2) for (new %2 = 0; %2 < MAX_PLAYERS; %2++) if (IsPlayerConnected(%2))
						#define __SSCANF_FOREACH__
					#endif
					string[end] = '\0';
					num = false;
					new
						name[MAX_PLAYER_NAME];
					id = end - stringPos;
					foreach (Player, playerid)
					{
						GetPlayerName(playerid, name, sizeof (name));
						if (!strcmp(name, string[stringPos], true, id))
						{
							setarg(paramPos, 0, playerid);
							num = true;
							break;
						}
					}
					if (!num)
					{
						setarg(paramPos, 0, INVALID_PLAYER_ID);
					}
					string[end] = ch;
					#if defined __SSCANF_FOREACH__
						#undef foreach
						#undef __SSCANF_FOREACH__
					#endif
				}
				stringPos = end;
			}
			case 's', 'z':
			{
				new
					i = 0,
					ch;
				if (format[formatPos])
				{
					while ((ch = string[stringPos++]) && ch != delim)
					{
						setarg(paramPos, i++, ch);
					}
					if (!i)
					{
						return -1;
					}
				}
				else
				{
					while ((ch = string[stringPos++]))
					{
						setarg(paramPos, i++, ch);
					}
				}
				stringPos--;
				setarg(paramPos, i, '\0');
			}
			default:
			{
				continue;
			}
		}
		while (string[stringPos] && string[stringPos] != delim && string[stringPos] > ' ')
		{
			stringPos++;
		}
		while (string[stringPos] && (string[stringPos] == delim || string[stringPos] <= ' '))
		{
			stringPos++;
		}
		paramPos++;
	}
	do
	{
		if ((delim = format[formatPos++]) > ' ')
		{
			if (delim == '\'')
			{
				while ((delim = format[formatPos++]) && delim != '\'') {}
			}
			else if (delim != 'z')
			{
				return delim;
			}
		}
	}
	while (delim > ' ');
	return 0;
}
