/*

	 /$$   /$$  /$$$$$$          /$$$$$$$  /$$$$$$$
	| $$$ | $$ /$$__  $$        | $$__  $$| $$__  $$
	| $$$$| $$| $$  \__/        | $$  \ $$| $$  \ $$
	| $$ $$ $$| $$ /$$$$ /$$$$$$| $$$$$$$/| $$$$$$$/
	| $$  $$$$| $$|_  $$|______/| $$__  $$| $$____/
	| $$\  $$$| $$  \ $$        | $$  \ $$| $$
	| $$ \  $$|  $$$$$$/        | $$  | $$| $$
	|__/  \__/ \______/         |__/  |__/|__/

						Dynamic Crime System

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

#include <YSI\y_hooks>

#define MAX_CRIMES				150

forward OnCrimesLoad();
forward LoadCrimes();
// Dynamic Charges
enum eCrimeDatum {
	c_iID, // SQL ID
	c_iType, // how many stars the crime will give
	c_iNation, // Nation, 0 = SA, 1 = TR
	c_szName[32],
	c_iJTime, // Jail Time
	c_iJFine, // Fine
	c_iBail
}
new arrCrimeData[MAX_CRIMES][eCrimeDatum];

public LoadCrimes()
{
	mysql_tquery(MainPipeline, "SELECT * FROM `crimesdata`", "OnCrimesLoad", "");
	print("[LoadCrimes] Loading Crimes...");
}

public OnCrimesLoad()
{
	szMiscArray[0] = 0;
	new rows;
	cache_get_row_count(rows);

	for(new i = 0; i < rows; i++)
	{
		cache_get_value_name_int(i, "id", arrCrimeData[i][c_iID]);
		cache_get_value_name_int(i, "type", arrCrimeData[i][c_iType]);
		cache_get_value_name_int(i, "nation", arrCrimeData[i][c_iNation]); 
		cache_get_value_name(i, "name", arrCrimeData[i][c_szName], 32);
		cache_get_value_name_int(i, "jailtime", arrCrimeData[i][c_iJTime]); 
		cache_get_value_name_int(i, "fine", arrCrimeData[i][c_iJFine]); 
		cache_get_value_name_int(i, "bail", arrCrimeData[i][c_iBail]); 
	}
	print("[LoadCrimes] Crime Data Loaded.");
}

stock SaveCrimes()
{
	for(new i = 0; i < MAX_CRIMES; i++)
	{
		SaveCrime(i);
	}
}

stock SaveCrime(id)
{
	szMiscArray[0] = 0;
	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "UPDATE `crimesdata` SET  \
	`type` = '%i', \
	`nation` = '%i', \
	`name` = '%e', \
	`jailtime` = '%i', \
	`fine` = '%i', \
	`bail` = '%i' \
	WHERE `id` = '%i'",
	arrCrimeData[id][c_iType],
	arrCrimeData[id][c_iNation],
	arrCrimeData[id][c_szName],
	arrCrimeData[id][c_iJTime],
	arrCrimeData[id][c_iJFine],
	arrCrimeData[id][c_iBail],
	arrCrimeData[id][c_iID]);
	mysql_tquery(MainPipeline, szMiscArray, "OnQueryFinish", "i", SENDDATA_THREAD);
}

stock ShowCrimesDialog(iPlayerID, iSuspectID = INVALID_PLAYER_ID, iDialogID = DIALOG_SHOW_CRIMES)
{
	szMiscArray[0] = 0;
	switch(iDialogID)
	{
		case DIALOG_SHOW_CRIMES:
		{
			format(szMiscArray, sizeof(szMiscArray), "----Misdemeanors----\n");
			for(new i = 0; i < MAX_CRIMES; i++)
			{
				if(arrCrimeData[i][c_iNation] == arrGroupData[PlayerInfo[iPlayerID][pMember]][g_iAllegiance] && arrCrimeData[i][c_iType] == 1)
				{
					format(szMiscArray, sizeof(szMiscArray), "%s{FFFF00}%i\t%s\n", szMiscArray, arrCrimeData[i][c_iID], arrCrimeData[i][c_szName]);
				}
			}
			format(szMiscArray, sizeof(szMiscArray), "%s----Felonies----\n", szMiscArray);
			for(new i = 0; i < MAX_CRIMES; i++)
			{
				if(arrCrimeData[i][c_iNation] == arrGroupData[PlayerInfo[iPlayerID][pMember]][g_iAllegiance] && arrCrimeData[i][c_iType] == 2)
				{
					format(szMiscArray, sizeof(szMiscArray), "%s{AA3333}%i\t%s\n", szMiscArray, arrCrimeData[i][c_iID], arrCrimeData[i][c_szName]);
				}
			}
			SetPVarInt(iPlayerID, "suspect_TargetID", iSuspectID);
			ShowPlayerDialogEx(iPlayerID, iDialogID, DIALOG_STYLE_LIST, "Select a committed crime", szMiscArray, "Select", "Exit");
		}
		case DIALOG_EDIT_CRIMES:
		{
			ShowPlayerDialogEx(iPlayerID, iDialogID, DIALOG_STYLE_LIST, "Select a Nation.", "SA\nNE", "Select", "Exit");
		}
	}
	return 1;
}

stock ShowOfflineCrimesDialog(playerid)
{
	szMiscArray[0] = 0;
	format(szMiscArray, sizeof(szMiscArray), "----Misdemeanors----\n");
	for(new i = 0; i < MAX_CRIMES; i++)
	{
		if(arrCrimeData[i][c_iNation] == arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance] && arrCrimeData[i][c_iType] == 1)
		{
			format(szMiscArray, sizeof(szMiscArray), "%s{FFFF00}%i\t%s\n", szMiscArray, arrCrimeData[i][c_iID], arrCrimeData[i][c_szName]);
		}
	}
	format(szMiscArray, sizeof(szMiscArray), "%s----Felonies----\n", szMiscArray);
	for(new i = 0; i < MAX_CRIMES; i++)
	{
		if(arrCrimeData[i][c_iNation] == arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance] && arrCrimeData[i][c_iType] == 2)
		{
			format(szMiscArray, sizeof(szMiscArray), "%s{AA3333}%i\t%s\n", szMiscArray, arrCrimeData[i][c_iID], arrCrimeData[i][c_szName]);
		}
	}
	ShowPlayerDialogEx(playerid, DIALOG_SHOW_OFFLINE_CRIMES, DIALOG_STYLE_LIST, "Select a committed crime", szMiscArray, "Select", "Exit");
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	szMiscArray[0] = 0;
	switch(dialogid)
	{
		case DIALOG_SHOW_CRIMES:
		{
			if(!response) return 1;
			for(new i = 0; i < MAX_CRIMES; i++)
			{
				if(arrCrimeData[i][c_iNation] == arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance])
				{
					if(arrCrimeData[i][c_iID] == strval(inputtext))
					{
						new iTargetID = GetPVarInt(playerid, "suspect_TargetID");
						++PlayerInfo[iTargetID][pCrimes];
						PlayerInfo[iTargetID][pWantedLevel] += arrCrimeData[i][c_iType];
						if(PlayerInfo[iTargetID][pWantedLevel] > 6)
						{
							PlayerInfo[iTargetID][pWantedLevel] = 6;
						}
						SetPlayerWantedLevel(iTargetID, PlayerInfo[iTargetID][pWantedLevel]);
						if(PlayerInfo[iTargetID][pConnectHours] < 64)
						{
							PlayerInfo[iTargetID][pWantedJailTime] += 4;
							PlayerInfo[iTargetID][pWantedJailFine] += 4000;
						}
						else
						{
							PlayerInfo[iTargetID][pWantedJailTime] += arrCrimeData[i][c_iJTime];
							PlayerInfo[iTargetID][pWantedJailFine] += arrCrimeData[i][c_iJFine];
						}
						new szCountry[10], szCrime[128];
						if(arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance] == 1)
						{
							format(szCountry, sizeof(szCountry), "[SA] ");
						}
						else if(arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance] == 2)
						{
							format(szCountry, sizeof(szCountry), "[NE] ");
						}
						strcat(szCrime, szCountry);
						strcat(szCrime, arrCrimeData[i][c_szName]);
						AddCrime(playerid, iTargetID, szCrime);

						format(szMiscArray, sizeof(szMiscArray), "You've commited a crime ( %s ). Reporter: %s.", szCrime, GetPlayerNameEx(playerid));
						SendClientMessageEx(iTargetID, COLOR_LIGHTRED, szMiscArray);

						format(szMiscArray, sizeof(szMiscArray), "Current wanted level: %d", PlayerInfo[iTargetID][pWantedLevel]);
						SendClientMessageEx(iTargetID, COLOR_YELLOW, szMiscArray);

						foreach(new p: Player)
						{
							if(IsACop(p) && arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance] == arrGroupData[PlayerInfo[p][pMember]][g_iAllegiance]) {
								format(szMiscArray, sizeof(szMiscArray), "HQ: All units APB (reporter: %s)",GetPlayerNameEx(playerid));
								SendClientMessageEx(p, TEAM_BLUE_COLOR, szMiscArray);
								format(szMiscArray, sizeof(szMiscArray), "HQ: Crime: %s, suspect: %s", szCrime, GetPlayerNameEx(iTargetID));
								SendClientMessageEx(p, TEAM_BLUE_COLOR, szMiscArray);
							}
						}
						PlayerInfo[iTargetID][pDefendTime] = 60;
					}
				}
			}
		}
		case DIALOG_SHOW_OFFLINE_CRIMES:
		{
			if(!response) return 1;
			for(new i = 0; i < MAX_CRIMES; i++)
			{
				if(arrCrimeData[i][c_iNation] == arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance])
				{
					if(arrCrimeData[i][c_iID] == strval(inputtext))
					{
						new PlayerName[MAX_PLAYER_NAME];

						new szCountry[10], szCrime[128];
						if(arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance] == 1)
						{
							format(szCountry, sizeof(szCountry), "[SA] ");
						}
						else if(arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance] == 2)
						{
							format(szCountry, sizeof(szCountry), "[NE] ");
						}
						strcat(szCrime, szCountry);
						strcat(szCrime, arrCrimeData[i][c_szName]);

						GetPVarString(playerid, "OfflineSU", PlayerName, MAX_PLAYER_NAME);
						Crime_AddOffline(playerid, szCrime, PlayerName);
					}
				}
			}
		}
		case DIALOG_EDIT_CRIMES:
		{
			if(!response) return 1;
			ShowCrimesList(playerid);
		}
		case DIALOG_CRIMES_LIST:
		{
			if(!response) return 1;
			szMiscArray[0] = 0;
			SetPVarInt(playerid, "iEditCrime", strval(inputtext));
			format(szMiscArray, sizeof(szMiscArray), "{80FF00}%s", arrCrimeData[strval(inputtext)-1][c_szName]);
			ShowPlayerDialogEx(playerid, DIALOG_CRIMES_EDIT, DIALOG_STYLE_LIST, szMiscArray, "Edit Type\nnEdit Nation\nEdit Name\nEdit Time\nEdit Fine", "Select", "Cancel");
		}
		case DIALOG_CRIMES_EDIT:
		{
			if(!response) return ShowCrimesList(playerid);
			szMiscArray[0] = 0;
			new iEditCrime = GetPVarInt(playerid, "iEditCrime")-1;
			switch(listitem)
			{
				case 0:
				{
					format(szMiscArray, sizeof(szMiscArray), "{80FF00}%s - {FF0000}EDIT TYPE", arrCrimeData[iEditCrime][c_szName]);
					ShowPlayerDialogEx(playerid, DIALOG_CRIMES_TYPE, DIALOG_STYLE_LIST, szMiscArray, "Misdemeanor\nFelony", "Select", "Cancel");
				}	
				case 1:
				{
					format(szMiscArray, sizeof(szMiscArray), "{80FF00}%s - {FF0000}EDIT NATION", arrCrimeData[iEditCrime][c_szName]);
					ShowPlayerDialogEx(playerid, DIALOG_CRIMES_NATION, DIALOG_STYLE_LIST, szMiscArray, "San Andreas\nNew Robada", "Select", "Cancel");
				}
				case 2:
				{
					format(szMiscArray, sizeof(szMiscArray), "{80FF00}%s - {FF0000}EDIT NAME", arrCrimeData[iEditCrime][c_szName]);
					ShowPlayerDialogEx(playerid, DIALOG_CRIMES_NAME, DIALOG_STYLE_INPUT, szMiscArray, "Please input a new name for the crime.", "Select", "Cancel");
				}
				case 3:
				{
					format(szMiscArray, sizeof(szMiscArray), "{80FF00}%s - {FF0000}EDIT TIME", arrCrimeData[iEditCrime][c_szName]);
					ShowPlayerDialogEx(playerid, DIALOG_CRIMES_TIME, DIALOG_STYLE_INPUT, szMiscArray, "Please input a new time for the crime.", "Select", "Cancel");
				}
				case 4:
				{
					format(szMiscArray, sizeof(szMiscArray), "{80FF00}%s - {FF0000}EDIT FINE", arrCrimeData[iEditCrime][c_szName]);
					ShowPlayerDialogEx(playerid, DIALOG_CRIMES_FINE, DIALOG_STYLE_INPUT, szMiscArray, "Please input a new fine for the crime.", "Select", "Cancel");
				}
			}
		}
		case DIALOG_CRIMES_TYPE:
		{
			if(!response) return ShowCrimesList(playerid);
			new iEditCrime = GetPVarInt(playerid, "iEditCrime")-1;
			arrCrimeData[iEditCrime][c_iType] = listitem+1;
			szMiscArray[0] = 0;
			format(szMiscArray, sizeof(szMiscArray), "You have set %s's type to %s", arrCrimeData[iEditCrime][c_szName], inputtext);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMiscArray);
			SaveCrime(iEditCrime);
		}
		case DIALOG_CRIMES_NATION:
		{
			if(!response) return ShowCrimesList(playerid);
			new iEditCrime = GetPVarInt(playerid, "iEditCrime")-1;
			arrCrimeData[iEditCrime][c_iNation] = listitem+1;
			szMiscArray[0] = 0;
			format(szMiscArray, sizeof(szMiscArray), "You have set %s's nation to %s", arrCrimeData[iEditCrime][c_szName], inputtext);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMiscArray);
			SaveCrime(iEditCrime);
		}
		case DIALOG_CRIMES_NAME:
		{
			if(!response) return ShowCrimesList(playerid);
			if(isnull(inputtext) || strlen(inputtext) > 32) return SendClientMessageEx(playerid, COLOR_GRAD2, "Please enter a valid name no longer than 32 characters.");
			new iEditCrime = GetPVarInt(playerid, "iEditCrime")-1;
			szMiscArray[0] = 0;
			format(szMiscArray, sizeof(szMiscArray), "You updated crime %s's name to %s", arrCrimeData[iEditCrime][c_szName], inputtext);
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMiscArray);
			format(arrCrimeData[iEditCrime][c_szName], 32, "%s", inputtext);
			SaveCrime(iEditCrime);
		}
		case DIALOG_CRIMES_TIME:
		{
			if(!response) return ShowCrimesList(playerid);
			new iEditCrime = GetPVarInt(playerid, "iEditCrime")-1;
			if(strval(inputtext) < 1) return SendClientMessageEx(playerid, COLOR_GRAD2, "Please input a time above 0 minutes.");
			arrCrimeData[iEditCrime][c_iJTime] = strval(inputtext);
			szMiscArray[0] = 0;
			format(szMiscArray, sizeof(szMiscArray), "You updated crime %s's time to %i minute(s)", arrCrimeData[iEditCrime][c_szName], strval(inputtext));
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMiscArray);
			SaveCrime(iEditCrime);
		}
		case DIALOG_CRIMES_FINE:
		{
			if(!response) return ShowCrimesList(playerid);
			new iEditCrime = GetPVarInt(playerid, "iEditCrime")-1;
			if(strval(inputtext) < 1) return SendClientMessageEx(playerid, COLOR_GRAD2, "Please input a fine above $0.");
			arrCrimeData[iEditCrime][c_iJFine] = strval(inputtext);
			szMiscArray[0] = 0;
			format(szMiscArray, sizeof(szMiscArray), "You updated crime %s's fine to $%s dollars", arrCrimeData[iEditCrime][c_szName], number_format(strval(inputtext)));
			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMiscArray);
			SaveCrime(iEditCrime);
		}
	}
	return 0;
}

CMD:clist(playerid, params[]) return cmd_crimelist(playerid, params);
CMD:crimelist(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 1337 && !PlayerInfo[playerid][pFactionModerator]) return SendClientMessageEx(playerid, COLOR_WHITE, "SERVER: You are not authorized to use this command.");
	ShowCrimesList(playerid);
	return 1;
}

CMD:su(playerid, params[]) 
{
	if(IsACop(playerid)) 
	{
		if(PlayerInfo[playerid][pJailTime] > 0) return SendClientMessageEx(playerid, COLOR_WHITE, "You cannot use this in jail/prison.");

		new iTargetID;

		if(sscanf(params, "u", iTargetID)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: (/su)spect [player]");
		if(!IsPlayerConnected(iTargetID)) return SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid player specified.");
		if(iTargetID == playerid) return SendClientMessageEx(playerid, COLOR_GRAD1, "You cannot place charges on yourself.");
		if(IsACop(iTargetID) && arrGroupData[PlayerInfo[playerid][pMember]][g_iAllegiance] == arrGroupData[PlayerInfo[iTargetID][pMember]][g_iAllegiance]) 
		{
			if(arrGroupData[PlayerInfo[playerid][pMember]][gLEOArrest] == INVALID_RANK || arrGroupData[PlayerInfo[playerid][pMember]][gLEOArrest] > PlayerInfo[playerid][pRank]) return SendClientMessageEx(playerid, COLOR_GREY, "You can't use this command on a law enforcement officer.");
		}
		if(PlayerInfo[iTargetID][pWantedLevel] >= 6) return SendClientMessageEx(playerid, COLOR_GRAD2, "Target is already most wanted.");

		ShowCrimesDialog(playerid, iTargetID);
	}
	else SendClientMessageEx(playerid, COLOR_GRAD2, "You're not a law enforcement officer.");
	return 1;
}

CMD:osu(playerid, params[]) 
{
	if(IsACop(playerid)) 
	{
		if(PlayerInfo[playerid][pJailTime] > 0) {
			return SendClientMessageEx(playerid, COLOR_WHITE, "You cannot use this in jail/prison.");
		}

		if(isnull(params)) return SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /osu(spect) [player name]");

		new PlayerName[MAX_PLAYER_NAME];
		mysql_escape_string(params, PlayerName);

		if(IsPlayerConnected(ReturnUser(PlayerName))) return SendClientMessageEx(playerid, COLOR_GREY, "That player is currently connected, use /su.");

		SetPVarString(playerid, "OfflineSU", PlayerName);

		ShowOfflineCrimesDialog(playerid);
	}
	else SendClientMessageEx(playerid, COLOR_GRAD2, "You're not a law enforcement officer.");
	return 1;
}

ShowCrimesList(playerid)
{
	szMiscArray[0] = 0;
	strcat(szMiscArray, "ID\tName\tTime (min)\tFine");
	for(new i = 0; i < MAX_CRIMES; i++)
	{
		format(szMiscArray, sizeof(szMiscArray), "%s\n%i\t%s\t%d\t$%s", szMiscArray, arrCrimeData[i][c_iID], arrCrimeData[i][c_szName], arrCrimeData[i][c_iJTime], number_format(arrCrimeData[i][c_iJFine]));
	}
	return ShowPlayerDialogEx(playerid, DIALOG_CRIMES_LIST, DIALOG_STYLE_TABLIST_HEADERS, "Select a crime to edit.", szMiscArray, "Select", "Exit");
}

Crime_AddOffline(iPlayerID, szAddCrime[], szPName[], iExtra = 0) {

	szMiscArray[0] = 0;
	mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "SELECT `id`, `Username` FROM `accounts` WHERE `Username` = '%s' LIMIT 1", szPName);
	mysql_tquery(MainPipeline, szMiscArray, "OnCrimeAddOffline", "dssd", iPlayerID, szAddCrime, szPName, iExtra);
	return 1;
}

forward OnCrimeAddOffline(iPlayerID, szAddCrime[], szPName[], iExtra);
public OnCrimeAddOffline(iPlayerID, szAddCrime[], szPName[], iExtra) 
{

	new
		iRows,
		iTempID;
	cache_get_row_count(iRows);

	switch(iExtra) {
		case 0: {
			
			if(!iRows) return SendClientMessageEx(iPlayerID, 0xFFFFFF, "That player was not found!");

			cache_get_value_name_int(0, "id", iTempID);
			mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "INSERT INTO `mdc` (`id` ,`time` ,`issuer` ,`crime`, `origin`) VALUES ('%d',NOW(),'%s','%s','%d')", iTempID, GetPlayerNameEx(iPlayerID), szAddCrime, arrGroupData[PlayerInfo[iPlayerID][pMember]][g_iAllegiance]);
			mysql_tquery(MainPipeline, szMiscArray, "OnCrimeAddOffline", "dssd", iPlayerID, szAddCrime, szPName, 1);
			new PlayerName[MAX_PLAYER_NAME];
			GetPVarString(iPlayerID, "OfflineSU", PlayerName, MAX_PLAYER_NAME);
			foreach(new p: Player)
			{
				if(IsACop(p) && arrGroupData[PlayerInfo[iPlayerID][pMember]][g_iAllegiance] == arrGroupData[PlayerInfo[p][pMember]][g_iAllegiance]) {
					format(szMiscArray, sizeof(szMiscArray), "(offline) HQ: All units APB (reporter: %s)",GetPlayerNameEx(iPlayerID));
					SendClientMessageEx(p, TEAM_BLUE_COLOR, szMiscArray);
					format(szMiscArray, sizeof(szMiscArray), "(offline) HQ: Crime: %s, suspect: %s", szAddCrime, PlayerName);
					SendClientMessageEx(p, TEAM_BLUE_COLOR, szMiscArray);
				}
			}
			DeletePVar(iPlayerID, "OfflineSU");
		}

		case 1: {
			
			if(!cache_affected_rows()) return SendClientMessageEx(iPlayerID, 0xFFFFFF, "There was an issue appending that crime!");

			format(szMiscArray, sizeof(szMiscArray), "Crime Added: %s - %s", szPName, szAddCrime);
			SendClientMessage(iPlayerID, 0xFFFFFF, szMiscArray);
		}
	}


	return 1;
}