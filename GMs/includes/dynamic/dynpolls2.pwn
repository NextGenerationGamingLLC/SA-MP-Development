// DOWNLOAD LINK: http://www.filedropper.com/pollingsystem
// This is the dump for the polls table: http://www.filedropper.com/polls
/* The following change was made to `accounts`: 
ALTER TABLE `accounts` ADD `PollKeyA` VARCHAR(128) NOT NULL AFTER `GuardsGiven`, ADD `PollKeyB` VARCHAR(128) NOT NULL AFTER `PollKeyA`, ADD `PollKeyC` VARCHAR(128) NOT NULL AFTER `PollKeyB`; */

/*
	Next Generation Gaming Development Team

	Project Name: Dynamic Polling System
	Author: Westen (westen@ng-gaming.net)

	Documentation: https://docs.google.com/document/d/1emwrE9iCG4ZomJZ5s_BskzHcSBQXlJ7nnRIkR8ChpXs/
*/

#include <YSI\y_hooks>

#define MIN_POLL_OPTIONS			(2) // No point having a poll for 1 option.
#define DEFAULT_POLL_OPTIONS		(4)
#define MAX_POLL_OPTIONS			(6)

#define MAX_POLLS 					(3)

#define MAX_POLL_TYPES				(5)
/*
	-- ENUMS --
*/

enum PollingInformation
{
	poll_iID,
	poll_szTitle[64], // The max chars a dialog can hold = 64.
	poll_iOptions, // The number of options available.
	poll_szOption1[35],
	poll_szOption2[35],
	poll_szOption3[35],
	poll_szOption4[35],
	poll_szOption5[35],
	poll_szOption6[35],
	poll_iOptionResults[6], // An array storing the votes.
	poll_szPlacedBy[MAX_PLAYER_NAME],
	poll_iInterior,
	poll_iVirtualWorld,
	poll_iNation,
	Float:poll_fLocation[3],

	poll_szUniqueKey[128],

	poll_iCreationDate,
	poll_iExpirationDate, // Expiration dates are in unix so are integers.

	poll_iType,
	poll_iTypeRank,
	poll_iTypeID, // TypeID = the group / business that the poll is restricted to.

	Text3D:poll_textLabel,
	poll_iPickupID
};

new PollInfo[MAX_POLLS][PollingInformation];

new PollTypes[5][] = {"None", "VIP", "Group", "Business", "Admin"};
/*
	-- FUNCTIONS & CALLBACKS --
*/

stock ShowPlayerEditPollDialog(playerid)
{
	new szTitle[64], iPollID = GetPVarInt(playerid, "iEditingPoll");

	if(PollInfo[iPollID][poll_iID] == -1) return 0;

	format(szTitle, sizeof szTitle, "Editing Poll | ID: %d", iPollID);

	new szNation[25];
	if(PollInfo[iPollID][poll_iNation] == 0) format(szNation, sizeof szNation, "San Andreas");
	else if(PollInfo[iPollID][poll_iNation] == 1) format(szNation, sizeof szNation, "New Robada");
	else format(szNation, sizeof szNation, "None");

	format(szMiscArray, sizeof szMiscArray, "{FFFFFF}Title: {5EC7EB}%s\n{FFFFFF}No. of Options: {5EC7EB}%d\n{FFFFFF}Edit Options\nEdit Position\nType: {5EC7EB}%s (%d)\n{FFFFFF}Type Rank: {5EC7EB}%d{FFFFFF}\nType ID (group/business): {5EC7EB}%d\n{FFFFFF}Nation: {5EC7EB}%s\n{FFFFFF}Expiration Date: {5EC7EB}%s",
	PollInfo[iPollID][poll_szTitle], PollInfo[iPollID][poll_iOptions], PollTypes[PollInfo[iPollID][poll_iType]], PollInfo[iPollID][poll_iType], PollInfo[iPollID][poll_iTypeRank], PollInfo[iPollID][poll_iTypeID], szNation, date(PollInfo[iPollID][poll_iExpirationDate], 1));

	return ShowPlayerDialogEx(playerid, DIALOG_EDIT_POLL, DIALOG_STYLE_LIST, szTitle, szMiscArray, "Select", "Cancel");
}

stock ParsePollType(type) return PollTypes[type];

stock CalculatePlayerPollKeys(playerid)
{
	new iFound[3];
	for(new i = 0; i < MAX_POLLS; i++)
	{
		if(PollInfo[i][poll_iID] != -1)
		{
			// Are any of the 3 keys that I have stored the same as any currently existing polls'?
			if(!strcmp(PlayerInfo[playerid][pPollKey1], PollInfo[i][poll_szUniqueKey])) iFound[0] = 1;
			if(!strcmp(PlayerInfo[playerid][pPollKey2], PollInfo[i][poll_szUniqueKey])) iFound[1] = 1;
			if(!strcmp(PlayerInfo[playerid][pPollKey3], PollInfo[i][poll_szUniqueKey])) iFound[2] = 1;
		}
	}

	// If not, then that key is reset.
	if(iFound[0] == 0) format(PlayerInfo[playerid][pPollKey1], 128, "Invalid Key");
	if(iFound[1] == 0) format(PlayerInfo[playerid][pPollKey2], 128, "Invalid Key");
	if(iFound[2] == 0) format(PlayerInfo[playerid][pPollKey3], 128, "Invalid Key");
}

stock GenerateRandomCharacter() return (random(1000) % 2 == 0) ? (65 + random(26)) : (97 + random(26)); // Decides whether it's upper / lower case, then generates a random ascii character based on that.

// valstr fix by Slice
stock FIX_valstr(dest[], value, bool:pack = false)
{
    // format can't handle cellmin properly
    static const cellmin_value[] = !"-2147483648";
 
    if (value == cellmin)
        pack && strpack(dest, cellmin_value, 12) || strunpack(dest, cellmin_value, 12);
    else
        format(dest, 12, "%d", value), pack && strpack(dest, dest, 12);
}
#define valstr FIX_valstr

forward LoadPoll();
public LoadPoll()
{
	new rows;
	cache_get_row_count(rows);
	for(new row; row < rows; row++)
	{
		cache_get_value_name_int(row, "ID", PollInfo[row][poll_iID]);
		cache_get_value_name(row, "Title", PollInfo[row][poll_szTitle], 64);
		cache_get_value_name_int(row, "Options", PollInfo[row][poll_iOptions]);

		cache_get_value_name(row, "Option1", PollInfo[row][poll_szOption1], 35);
		cache_get_value_name(row, "Option2", PollInfo[row][poll_szOption2], 35);
		cache_get_value_name(row, "Option3", PollInfo[row][poll_szOption3], 35);
		cache_get_value_name(row, "Option4", PollInfo[row][poll_szOption4], 35); 
		cache_get_value_name(row, "Option5", PollInfo[row][poll_szOption5], 35);
		cache_get_value_name(row, "Option6", PollInfo[row][poll_szOption6], 35);

		for(new i = 0; i < 6; i++) // Might work. Not too sure yet. Hoping it does?
		{
			format(szMiscArray, sizeof szMiscArray, "OptionResult%d", i + 1);
			cache_get_value_name_int(row, szMiscArray, PollInfo[row][poll_iOptionResults][i]);
		}

		cache_get_value_name_int(row, "Nation", PollInfo[row][poll_iNation]);
		cache_get_value_name(row, "PlacedBy", PollInfo[row][poll_szPlacedBy], MAX_PLAYER_NAME);
		cache_get_value_name_int(row, "Interior", PollInfo[row][poll_iInterior]);
		cache_get_value_name_int(row, "VirtualWorld", PollInfo[row][poll_iVirtualWorld]);
		cache_get_value_name_float(row, "LocationX", PollInfo[row][poll_fLocation][0]);
		cache_get_value_name_float(row, "LocationY", PollInfo[row][poll_fLocation][1]);
		cache_get_value_name_float(row, "LocationZ", PollInfo[row][poll_fLocation][2]);
		cache_get_value_name_int(row, "CreationDate", PollInfo[row][poll_iCreationDate]);
		cache_get_value_name_int(row, "ExpirationDate", PollInfo[row][poll_iExpirationDate]);
		cache_get_value_name_int(row, "Type", PollInfo[row][poll_iType]);
		cache_get_value_name_int(row, "TypeRank", PollInfo[row][poll_iTypeRank]);
		cache_get_value_name_int(row, "TypeID", PollInfo[row][poll_iTypeID]);
		cache_get_value_name(row, "UniqueKey", PollInfo[row][poll_szUniqueKey], 128);

		format(szMiscArray, sizeof szMiscArray, "Polling Station (ID: %d)\n{5EC7EB}%s\n{FFFF00}/vote", row, PollInfo[row][poll_szTitle]);
		PollInfo[row][poll_textLabel] = CreateDynamic3DTextLabel(szMiscArray, 0xFFFF00FF, PollInfo[row][poll_fLocation][0], PollInfo[row][poll_fLocation][1], PollInfo[row][poll_fLocation][2], 10.00, INVALID_PLAYER_ID,INVALID_VEHICLE_ID, 0, PollInfo[row][poll_iVirtualWorld], PollInfo[row][poll_iInterior]);

		PollInfo[row][poll_iPickupID] = CreateDynamicPickup(1239, 1, PollInfo[row][poll_fLocation][0], PollInfo[row][poll_fLocation][1], PollInfo[row][poll_fLocation][2], PollInfo[row][poll_iVirtualWorld], PollInfo[row][poll_iInterior]);

		printf("Poll %d (%s) loaded.", row, PollInfo[row][poll_szTitle]);
	}
	print("Polls loaded successfully.");
	return 1;
}

forward poll_MySQL_Load();
public poll_MySQL_Load()
{
	print("Dynamic Polling System Loading");
	mysql_tquery(MainPipeline, "SELECT * FROM `polls`", "LoadPoll", "");
	return 1;
}

hook OnGameModeInit()
{
	for(new i = 0; i < MAX_POLLS; i++) PollInfo[i][poll_iID] = -1; // Reset all the IDs.
	SetTimer("poll_MySQL_Load", 2500, false); // Adding a timer because hooks are called before the primary callback, so if I try to load before the main callback, then I won't be able to connect to the database.
}

hook OnGameModeExit()
{
	for(new i = 0; i < MAX_POLLS; i++) poll_MySQL_Save(i);
}

hook OnPlayerConnect(playerid)
{
	format(PlayerInfo[playerid][pPollKey1], 128, "Invalid Key");
	format(PlayerInfo[playerid][pPollKey2], 128, "Invalid Key");
	format(PlayerInfo[playerid][pPollKey3], 128, "Invalid Key");
	print("Reset keys.");
	SetTimerEx("poll_Player_ResetKeys", 1500, false, "i", playerid);
	return 1;
}

forward poll_Player_ResetKeys(playerid);
public poll_Player_ResetKeys(playerid)
{
	CalculatePlayerPollKeys(playerid);
	return 1;
}

forward poll_MySQL_Save(i);
public poll_MySQL_Save(i)
{
	// This is split into 2 queries to make it easier to handle.
	mysql_format(MainPipeline, szMiscArray, sizeof szMiscArray, "UPDATE `polls` SET `Title`='%e', `Options`=%d, `PlacedBy`='%e', `Interior`=%d, `VirtualWorld`=%d, `UniqueKey`='%s', `Type`=%d, `TypeRank`=%d, `TypeID`=%d, `CreationDate`=%d, `Nation`=%d, `ExpirationDate`=%d WHERE `ID`=%d",
	 PollInfo[i][poll_szTitle],
	 PollInfo[i][poll_iOptions],
	 PollInfo[i][poll_szPlacedBy],
	 PollInfo[i][poll_iInterior],
	 PollInfo[i][poll_iVirtualWorld],
	 PollInfo[i][poll_szUniqueKey],
	 PollInfo[i][poll_iType],
	 PollInfo[i][poll_iTypeRank],
	 PollInfo[i][poll_iTypeID],
	 PollInfo[i][poll_iCreationDate],
	 PollInfo[i][poll_iNation],
	 PollInfo[i][poll_iExpirationDate],
	 i + 1);

	mysql_tquery(MainPipeline, szMiscArray, "PollSaved", "i", i);

	mysql_format(MainPipeline, szMiscArray, sizeof szMiscArray, "UPDATE `polls` SET `Option1`='%e', `Option2`='%e', `Option3`='%e', `Option4`='%e', `Option5`='%e', `Option6`='%e', `OptionResult1`=%d, `OptionResult2`=%d, `OptionResult3`=%d, `OptionResult4`=%d, `OptionResult5`=%d, `OptionResult6`=%d WHERE `ID`=%d",
	 PollInfo[i][poll_szOption1],
	 PollInfo[i][poll_szOption2],
	 PollInfo[i][poll_szOption3],
	 PollInfo[i][poll_szOption4],
	 PollInfo[i][poll_szOption5],
	 PollInfo[i][poll_szOption6],
	 PollInfo[i][poll_iOptionResults][0],
	 PollInfo[i][poll_iOptionResults][1],
	 PollInfo[i][poll_iOptionResults][2],
	 PollInfo[i][poll_iOptionResults][3],
	 PollInfo[i][poll_iOptionResults][4],
	 PollInfo[i][poll_iOptionResults][5],
	 i + 1);

	mysql_tquery(MainPipeline, szMiscArray, "OnQueryFinish", "");


	mysql_format(MainPipeline, szMiscArray, sizeof szMiscArray, "UPDATE `polls` SET `LocationX`=%f, `LocationY`=%f, `LocationZ`=%f WHERE `ID`=%d", 
	 PollInfo[i][poll_fLocation][0], PollInfo[i][poll_fLocation][1], PollInfo[i][poll_fLocation][2], i + 1);

	mysql_tquery(MainPipeline, szMiscArray, "OnQueryFinish", "");
	szMiscArray[0] = 0;
	return 1;
}

forward PollSaved(pollid);
public PollSaved(pollid)
{
	format(szMiscArray, sizeof szMiscArray, "Poll ID %d (%s) has been saved.", pollid, PollInfo[pollid][poll_szTitle]);
	print(szMiscArray);
	Log("logs/polls.log", szMiscArray);
	return 1;
}

forward NewPollCreated(pollid);
public NewPollCreated(pollid)
{	
	format(szMiscArray, sizeof szMiscArray, "Poll ID %d has been created by %s, title: %s.", pollid, PollInfo[pollid][poll_szPlacedBy], PollInfo[pollid][poll_szTitle]);
	print(szMiscArray);
	Log("logs/polls.log", szMiscArray);
	return 1;
}

forward PollDeleted(pollid);
public PollDeleted(pollid)
{
	format(szMiscArray, sizeof szMiscArray, "Poll ID %d (%s) has been deleted by %s.", pollid, PollInfo[pollid][poll_szTitle], PollInfo[pollid][poll_szPlacedBy]);
	print(szMiscArray);
	Log("logs/polls.log", szMiscArray);
	format(PollInfo[pollid][poll_szPlacedBy], MAX_PLAYER_NAME, "");
	format(PollInfo[pollid][poll_szTitle], 25, "");
	PollInfo[pollid][poll_iID] = -1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	switch(dialogid)
	{
			/* 		
					#define DIALOG_EDIT_POLL			(6183)
					#define DIALOG_EDIT_TITLE			(6184)
					#define DIALOG_EDIT_NOOPTIONS		(6185)
					#define DIALOG_EDIT_SHOWOPTIONS		(6186)
					#define DIALOG_EDIT_OPTION			(6187) 

					Title | No. of Options | Edit Options | Edit Position
			*/

		case DIALOG_EDIT_POLL:
		{
			if(!response) 
			{
				DeletePVar(playerid, "iEditingPoll");
				return 0;
			}
			switch(listitem)
			{
				case 0: ShowPlayerDialogEx(playerid, DIALOG_EDIT_TITLE, DIALOG_STYLE_INPUT, "Editing Poll Title", "Input the desired poll title in the box below.\nNOTE: Poll titles are between 2 and 64 characters.", "Edit", "Cancel");
				case 1: ShowPlayerDialogEx(playerid, DIALOG_EDIT_NOOPTIONS, DIALOG_STYLE_INPUT, "Editing Option Amount", "Input the desired number of options in the box below.\nNOTE: Option amounts are between 2 and 6.", "Edit", "Cancel");
				case 2: 
				{
					new iPollID = GetPVarInt(playerid, "iEditingPoll");
					new szBody[300];

					format(szMiscArray, sizeof szMiscArray, "%s\n", PollInfo[iPollID][poll_szOption1]);
					strcat(szBody, szMiscArray);

					format(szMiscArray, sizeof szMiscArray, "%s\n", PollInfo[iPollID][poll_szOption2]);
					strcat(szBody, szMiscArray);

					format(szMiscArray, sizeof szMiscArray, "%s\n", PollInfo[iPollID][poll_szOption3]);
					if(PollInfo[iPollID][poll_iOptions] >= 3) strcat(szBody, szMiscArray);

					format(szMiscArray, sizeof szMiscArray, "%s\n", PollInfo[iPollID][poll_szOption4]);
					if(PollInfo[iPollID][poll_iOptions] >= 4) strcat(szBody, szMiscArray);

					format(szMiscArray, sizeof szMiscArray, "%s\n", PollInfo[iPollID][poll_szOption5]);
					if(PollInfo[iPollID][poll_iOptions] >= 5) strcat(szBody, szMiscArray);

					format(szMiscArray, sizeof szMiscArray, "%s\n", PollInfo[iPollID][poll_szOption6]);
					if(PollInfo[iPollID][poll_iOptions] == 6) strcat(szBody, szMiscArray);

					format(szMiscArray, sizeof szMiscArray, "Poll %d | Options", iPollID);

					ShowPlayerDialogEx(playerid, DIALOG_EDIT_SHOWOPTIONS, DIALOG_STYLE_LIST, szMiscArray, szBody, "Edit", "Cancel");
					szMiscArray[0] = 0;
				}
				case 3:
				{
					new 
						Float:fPos[3],
						iInterior,
						iVW;

					new iPollID = GetPVarInt(playerid, "iEditingPoll");

					GetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]);
					iVW = GetPlayerVirtualWorld(playerid);
					iInterior = GetPlayerInterior(playerid);

					format(szMiscArray, sizeof szMiscArray, "%s has edited poll ID %d's (%s) position from X: %f | Y: %f | Z: %f (Int: %d | VW: %d) to X: %f | Y: %f | Z: %f (Int: %d | VW: %d)", GetPlayerNameEx(playerid), iPollID, PollInfo[iPollID][poll_szTitle],
						PollInfo[iPollID][poll_fLocation][0], PollInfo[iPollID][poll_fLocation][1], PollInfo[iPollID][poll_fLocation][2], PollInfo[iPollID][poll_iInterior], PollInfo[iPollID][poll_iVirtualWorld],
						fPos[0], fPos[1], fPos[2], iInterior, iVW);
					print(szMiscArray);
					Log("logs/polls.log", szMiscArray);
					for(new i = 0; i < 3; i++) PollInfo[iPollID][poll_fLocation][i] = fPos[i];

					PollInfo[iPollID][poll_iInterior] = iInterior;
					PollInfo[iPollID][poll_iVirtualWorld] = iVW;

					#if defined TEXTLABEL_DEBUG
					Streamer_SetIntData(STREAMER_TYPE_3D_TEXT_LABEL, PollInfo[iPollID][poll_textLabel], E_STREAMER_EXTRA_ID, 8);
					#endif


					DestroyDynamic3DTextLabel(PollInfo[iPollID][poll_textLabel]);
					DestroyDynamicPickup(PollInfo[iPollID][poll_iPickupID]);

					format(szMiscArray, sizeof szMiscArray, "Polling Station (ID: %d)\n{5EC7EB}%s\n{FFFF00}/vote", iPollID, PollInfo[iPollID][poll_szTitle]);
					PollInfo[iPollID][poll_textLabel] = CreateDynamic3DTextLabel(szMiscArray, 0xFFFF00FF, fPos[0], fPos[1], fPos[2], 10.00, INVALID_PLAYER_ID,INVALID_VEHICLE_ID, 0, PollInfo[iPollID][poll_iVirtualWorld], PollInfo[iPollID][poll_iInterior]);
					PollInfo[iPollID][poll_iPickupID] = CreateDynamicPickup(1239, 1, fPos[0], fPos[1], fPos[2], PollInfo[iPollID][poll_iVirtualWorld], PollInfo[iPollID][poll_iInterior]);

					SendClientMessageEx(playerid, COLOR_WHITE, "Poll position edited successfully.");
					poll_MySQL_Save(iPollID);
					DeletePVar(playerid, "iEditingPoll");
					szMiscArray[0] = 0;

				}
				case 4: 
				{
					new iPollID = GetPVarInt(playerid, "iEditingPoll"), szBody[256], szTitle[64];
					format(szTitle, sizeof szTitle, "Editing Type | Current %s (%d)", PollTypes[PollInfo[iPollID][poll_iType]], PollInfo[iPollID][poll_iType]);

					for(new i = 0; i < sizeof PollTypes; i++)
					{
						format(szMiscArray, sizeof szMiscArray, "%s (ID: %d)\n", PollTypes[i], i);
						strcat(szBody, szMiscArray);
					}

					ShowPlayerDialogEx(playerid, DIALOG_EDIT_SHOWTYPES, DIALOG_STYLE_LIST, szTitle, szBody, "Edit", "Cancel");
				}
				case 5: ShowPlayerDialogEx(playerid, DIALOG_EDIT_TYPERANK, DIALOG_STYLE_INPUT, "Editing Type Rank", "Input the desired rank in the box below.", "Edit", "Cancel");
				case 6: 
				{
					new iPollID = GetPVarInt(playerid, "iEditingPoll");
					if(PollInfo[iPollID][poll_iType] == 2 || PollInfo[iPollID][poll_iType] == 3) ShowPlayerDialogEx(playerid, DIALOG_EDIT_TYPEID, DIALOG_STYLE_INPUT, "Editing Type ID", "Input the desired group / business ID in the box below.", "Edit", "Cancel");
					else return SendClientMessageEx(playerid, COLOR_GRAD2, "The current poll type does not support specific IDs.");
				}
				case 7:
				{
					ShowPlayerDialogEx(playerid, DIALOG_EDIT_NATION, DIALOG_STYLE_LIST, "Editing Nation Restriction", "No Nation Restriction\nSan Andreas\nNew Robada", "Edit", "Cancel");
				}
				case 8: ShowPlayerDialogEx(playerid, DIALOG_EDIT_EXPIRATIONDATE, DIALOG_STYLE_INPUT, "Editing Expiration Date", "Input the desired amount of days at which you want the poll to expire (note - this is from the creation date).", "Edit", "Cancel");
			}
		}
		case DIALOG_EDIT_TITLE:
		{
			if(!response) 
			{
				DeletePVar(playerid, "iEditingPoll");
				return 0;
			}

			if(strlen(inputtext) >= 2 && strlen(inputtext) < 64)
			{
				new iPollID = GetPVarInt(playerid, "iEditingPoll");
				format(PollInfo[iPollID][poll_szTitle], 64, inputtext);

				format(szMiscArray, sizeof szMiscArray, "Polling Station (ID: %d)\n{5EC7EB}%s\n{FFFF00}/vote", iPollID, PollInfo[iPollID][poll_szTitle]);
				UpdateDynamic3DTextLabelText(PollInfo[iPollID][poll_textLabel], 0xFFFF00FF, szMiscArray);

				ShowPlayerEditPollDialog(playerid);

				poll_MySQL_Save(iPollID);
				SendClientMessageEx(playerid, COLOR_WHITE, "Poll title edited successfully.");

			}
			else SendClientMessageEx(playerid, COLOR_GRAD2, "Invalid title length. Lengths are between 2 and 64 characters.");
		}
		case DIALOG_EDIT_NOOPTIONS:
		{
			if(!response) 
			{
				DeletePVar(playerid, "iEditingPoll");
				return 0;
			}

			new iOptionAmt = strval(inputtext), iPollID = GetPVarInt(playerid, "iEditingPoll");

			if(iOptionAmt > 1 && iOptionAmt < 7)
			{	
				PollInfo[iPollID][poll_iOptions] = iOptionAmt;

				ShowPlayerEditPollDialog(playerid);

				poll_MySQL_Save(iPollID);
				SendClientMessageEx(playerid, COLOR_WHITE, "Poll option amount edited successfully.");
			}
			else SendClientMessageEx(playerid, COLOR_GRAD2, "Invalid option amount. Amounts are between 2 and 6.");
		}
		case DIALOG_EDIT_SHOWOPTIONS:
		{
			if(!response)
			{
				DeletePVar(playerid, "iEditingPoll");
				return 0;
			}

			SetPVarInt(playerid, "iEditingOption", listitem + 1);
			ShowPlayerDialogEx(playerid, DIALOG_EDIT_OPTION, DIALOG_STYLE_INPUT, "Editing Option Value", "Input the desired option value in the box below.\nNOTE: Valid lengths are between 2 and 35 characters.", "Edit", "Cancel");
		}
		case DIALOG_EDIT_OPTION:
		{
			if(!response)
			{
				DeletePVar(playerid, "iEditingPoll");
				DeletePVar(playerid, "iEditingOption");
				return 0;
			}

			if(strlen(inputtext) >= 2 && strlen(inputtext) <= 35)
			{
				new iOpt = GetPVarInt(playerid, "iEditingOption"), iPollID = GetPVarInt(playerid, "iEditingPoll");
				switch(iOpt)
				{
					case 1: format(PollInfo[iPollID][poll_szOption1], 35, inputtext);
					case 2: format(PollInfo[iPollID][poll_szOption2], 35, inputtext);
					case 3: format(PollInfo[iPollID][poll_szOption3], 35, inputtext);
					case 4: format(PollInfo[iPollID][poll_szOption4], 35, inputtext);
					case 5: format(PollInfo[iPollID][poll_szOption5], 35, inputtext);
					case 6: format(PollInfo[iPollID][poll_szOption6], 35, inputtext);
				}

				SendClientMessageEx(playerid, COLOR_WHITE, "Poll option edited successfully.");

				ShowPlayerEditPollDialog(playerid);

				poll_MySQL_Save(iPollID);
			}
			else SendClientMessageEx(playerid, COLOR_GRAD2, "Invalid option length. Valid lengths are between 2 and 35 characters.");
		}
		case DIALOG_VOTE:
		{
			if(!response)
			{
				DeletePVar(playerid, "iVotingOnPoll");
				return 0;
			}

			new iPollID = GetPVarInt(playerid, "iVotingOnPoll");

			CalculatePlayerPollKeys(playerid);
			if(!strcmp(PlayerInfo[playerid][pPollKey1], "Invalid Key")) format(PlayerInfo[playerid][pPollKey1], 128, PollInfo[iPollID][poll_szUniqueKey]);
			else if(!strcmp(PlayerInfo[playerid][pPollKey2], "Invalid Key")) format(PlayerInfo[playerid][pPollKey2], 128, PollInfo[iPollID][poll_szUniqueKey]);
			else if(!strcmp(PlayerInfo[playerid][pPollKey3], "Invalid Key")) format(PlayerInfo[playerid][pPollKey3], 128, PollInfo[iPollID][poll_szUniqueKey]);
			else
			{
				SendClientMessageEx(playerid, COLOR_GRAD2, "An error has occured - you have voted on all current polls. Your vote has been voided.");
				return 0;
			}

			PollInfo[iPollID][poll_iOptionResults][listitem]++;

			format(szMiscArray, sizeof szMiscArray, "%s (%d) (IP: %s) has voted on poll %s (%d), for option %d.", GetPlayerNameEx(playerid), GetPlayerSQLId(playerid), GetPlayerIpEx(playerid), PollInfo[iPollID][poll_szTitle],
				iPollID, listitem + 1);

			Log("logs/pollvotes.log", szMiscArray);
			szMiscArray[0] = 0;

			poll_MySQL_Save(iPollID);
			SendClientMessageEx(playerid, COLOR_WHITE, "Your vote has been counted!");
		}
		case DIALOG_EDIT_SHOWTYPES:
		{
			if(!response)
			{
				DeletePVar(playerid, "iEditingPoll");
				return 0;
			}

			new iPollID = GetPVarInt(playerid, "iEditingPoll");

			PollInfo[iPollID][poll_iType] = listitem;
			SendClientMessageEx(playerid, COLOR_WHITE, "Poll type edited successfully.");

			ShowPlayerEditPollDialog(playerid);

			poll_MySQL_Save(iPollID);
		}
		case DIALOG_EDIT_TYPERANK:
		{
			if(!response)
			{
				DeletePVar(playerid, "iEditingPoll");
				return 0;
			}

			new iPollID = GetPVarInt(playerid, "iEditingPoll");

			new iRank = strval(inputtext), maxrank = 0;

			switch(PollInfo[iPollID][poll_iType]) // {"None", "VIP", "Group", "Business", "Admin"};
            {
                case 1: maxrank = 4; // Plat VIP.
                case 2: maxrank = 10; // 10 ranks.
                case 3: maxrank = 5; // 5 business ranks.
                case 4: maxrank = 99999;
            }

			if(iRank >= 0 && iRank <= maxrank)
			{
				PollInfo[iPollID][poll_iTypeRank] = iRank;
				SendClientMessageEx(playerid, COLOR_WHITE, "Poll type rank edited successfully.");

				ShowPlayerEditPollDialog(playerid);

				poll_MySQL_Save(iPollID);
			}
			else SendClientMessageEx(playerid, COLOR_GRAD2, "Invalid rank specified for your type.");
		}
		case DIALOG_EDIT_TYPEID:
		{
			if(!response)
			{
				DeletePVar(playerid, "iEditingPoll");
				return 0;
			}

			new iPollID = GetPVarInt(playerid, "iEditingPoll");

			new iGroupID = strval(inputtext);

			switch(PollInfo[iPollID][poll_iType])
			{
				case 2:
				{
					if(iGroupID >= 0 && iGroupID <= MAX_GROUPS)
					{
						PollInfo[iPollID][poll_iTypeID] = iGroupID;
						SendClientMessageEx(playerid, COLOR_WHITE, "Poll type ID edited successfully.");

						ShowPlayerEditPollDialog(playerid);
					}
					else SendClientMessageEx(playerid, COLOR_GRAD2, "Invalid group ID specified.");
				}
				case 3:
				{
					if(iGroupID >= 0 && iGroupID <= MAX_BUSINESSES)
					{
						PollInfo[iPollID][poll_iTypeID] = iGroupID;
						SendClientMessageEx(playerid, COLOR_WHITE, "Poll type ID edited successfully.");	

						ShowPlayerEditPollDialog(playerid);
					}
					else SendClientMessageEx(playerid, COLOR_GRAD2, "Invalid group ID specified.");
				}

			}
		}

		case DIALOG_EDIT_NATION:
		{
			if(!response)
			{
				DeletePVar(playerid, "iEditingPoll");
				return 0;
			}

			new iPollID = GetPVarInt(playerid, "iEditingPoll");

			switch(listitem)
			{
				case 0: PollInfo[iPollID][poll_iNation] = -1;
				case 1: PollInfo[iPollID][poll_iNation] = 0;
				case 2: PollInfo[iPollID][poll_iNation] = 1;
				default: return 1; // some sort of error occured here so we just gonna move along
			}

			poll_MySQL_Save(iPollID);
			SendClientMessage(playerid, COLOR_WHITE, "Poll nation restriction edited successfully.");
		}

		case DIALOG_EDIT_EXPIRATIONDATE:
		{	
			if(!response)
			{
				DeletePVar(playerid, "iEditingPoll");
				return 0;
			}

			new iPollID = GetPVarInt(playerid, "iEditingPoll");
			new iDays = strval(inputtext);

			if(iDays > 0 && iDays < 100)
			{
				PollInfo[iPollID][poll_iExpirationDate] = gettime() + (60 * 60 * (24 * iDays)); 
				SendClientMessageEx(playerid, COLOR_WHITE, "Poll expiration date edited successfully.");
				poll_MySQL_Save(iPollID);

				ShowPlayerEditPollDialog(playerid);
			}
			else SendClientMessageEx(playerid, COLOR_GRAD2, "Invalid date. Polls may only run for up to 99 days.");
		}
	}
	return 0;
}
/*
	-- COMMANDS --
*/

CMD:createpoll(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pPR] > 0)
	{
		new iPollID = -1, szTitle[64];
		if(sscanf(params, "s[64]", szTitle)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /createpoll [title]");

		// Get next poll ID.
		for(new i = 0; i < MAX_POLLS; i++) 
		{
			if(PollInfo[i][poll_iID] == -1) 
			{
				iPollID = i; 
				break;
			}
		}
		if(iPollID != -1)
		{
			PollInfo[iPollID][poll_iID] = iPollID;
			format(PollInfo[iPollID][poll_szTitle], 25, szTitle);
			PollInfo[iPollID][poll_iOptions] = 4;

			format(PollInfo[iPollID][poll_szOption1], 35, "Nothing");
			format(PollInfo[iPollID][poll_szOption2], 35, "Nothing");
			format(PollInfo[iPollID][poll_szOption3], 35, "Nothing");
			format(PollInfo[iPollID][poll_szOption4], 35, "Nothing");
			format(PollInfo[iPollID][poll_szOption5], 35, "Nothing");
			format(PollInfo[iPollID][poll_szOption6], 35, "Nothing");

			for(new i = 0; i < MAX_POLL_OPTIONS; i++) 
			{
				PollInfo[iPollID][poll_iOptionResults][i] = 0; // Reset all votes.
			}

			new szPlacedByName[MAX_PLAYER_NAME];
			GetPlayerName(playerid, szPlacedByName, MAX_PLAYER_NAME);
			format(PollInfo[iPollID][poll_szPlacedBy], MAX_PLAYER_NAME, szPlacedByName);

			new
				Float:fPos[3];

			GetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]);
			for(new i = 0; i < 3; i++) PollInfo[iPollID][poll_fLocation][i] = fPos[i]; // Setting location.

			PollInfo[iPollID][poll_iInterior] = GetPlayerInterior(playerid);
			PollInfo[iPollID][poll_iVirtualWorld] = GetPlayerVirtualWorld(playerid);

			format(szMiscArray, sizeof szMiscArray, "Polling Station (ID: %d)\n{5EC7EB}%s\n{FFFF00}/vote", iPollID, PollInfo[iPollID][poll_szTitle]);
			PollInfo[iPollID][poll_textLabel] = CreateDynamic3DTextLabel(szMiscArray, 0xFFFF00FF, fPos[0], fPos[1], fPos[2], 10.00, INVALID_PLAYER_ID,INVALID_VEHICLE_ID, 0, PollInfo[iPollID][poll_iVirtualWorld], PollInfo[iPollID][poll_iInterior]);

			PollInfo[iPollID][poll_iPickupID] = CreateDynamicPickup(1239, 1, fPos[0], fPos[1], fPos[2], PollInfo[iPollID][poll_iVirtualWorld], PollInfo[iPollID][poll_iInterior]);

			PollInfo[iPollID][poll_iType] = 0;
			PollInfo[iPollID][poll_iTypeRank] = 0;
			PollInfo[iPollID][poll_iTypeID] = 0;

			PollInfo[iPollID][poll_iNation] = -1;

			PollInfo[iPollID][poll_iCreationDate] = gettime();
			PollInfo[iPollID][poll_iExpirationDate] = gettime() + 432000; // 5 days.

			for(new i = 0; i < 12; i++) PollInfo[iPollID][poll_szUniqueKey][i] = GenerateRandomCharacter();

			format(szMiscArray, sizeof szMiscArray, "Poll ID %d created (topic: %s). You can edit it using /editpoll %d.", iPollID, PollInfo[iPollID][poll_szTitle], iPollID);
			SendClientMessageEx(playerid, COLOR_WHITE, szMiscArray);
			SendClientMessageEx(playerid, COLOR_WHITE, "It is set to expire automatically in 5 days.");
			
			mysql_format(MainPipeline, szMiscArray, sizeof szMiscArray, "INSERT INTO `polls` VALUES(%d, '%e', %d, '%e', '%e', '%e', '%e', '%e', '%e', %d, %d, %d, %d, %d, %d, '%e', %d, %d, %f, %f, %f, '%s', %d, %d, %d, %d, %d, %d)",
				iPollID + 1,
				PollInfo[iPollID][poll_szTitle],
				PollInfo[iPollID][poll_iOptions],
				PollInfo[iPollID][poll_szOption1],
				PollInfo[iPollID][poll_szOption2],
				PollInfo[iPollID][poll_szOption3],
				PollInfo[iPollID][poll_szOption4],
				PollInfo[iPollID][poll_szOption5],
				PollInfo[iPollID][poll_szOption6],
				PollInfo[iPollID][poll_iOptionResults][0],
				PollInfo[iPollID][poll_iOptionResults][1],
				PollInfo[iPollID][poll_iOptionResults][2],
				PollInfo[iPollID][poll_iOptionResults][3],
				PollInfo[iPollID][poll_iOptionResults][4],
				PollInfo[iPollID][poll_iOptionResults][5],
				PollInfo[iPollID][poll_szPlacedBy],
				PollInfo[iPollID][poll_iInterior],
				PollInfo[iPollID][poll_iVirtualWorld],
				PollInfo[iPollID][poll_fLocation][0],
				PollInfo[iPollID][poll_fLocation][1],
				PollInfo[iPollID][poll_fLocation][2],
				PollInfo[iPollID][poll_szUniqueKey],
				PollInfo[iPollID][poll_iCreationDate],
				PollInfo[iPollID][poll_iExpirationDate],
				PollInfo[iPollID][poll_iType],
				PollInfo[iPollID][poll_iTypeRank],
				PollInfo[iPollID][poll_iTypeID],
				PollInfo[iPollID][poll_iNation]);

			mysql_tquery(MainPipeline, szMiscArray, "NewPollCreated", "i", iPollID);
			szMiscArray[0] = 0;
		}
		else SendClientMessageEx(playerid, COLOR_GRAD2, "No more polls can be created.");
	}
	else SendClientMessageEx(playerid, COLOR_GRAD2, "You're not authorised to use this command.");
	return 1;
}

CMD:deletepoll(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pPR] > 0)
	{
		new iPollID;
		if(sscanf(params, "d", iPollID)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /deletepoll [poll ID]");

		if(iPollID >= 0 && iPollID < MAX_POLLS)
		{
			if(PollInfo[iPollID][poll_iID] != -1)
			{
				PollInfo[iPollID][poll_iOptions] = 4;

				format(PollInfo[iPollID][poll_szOption1], 35, "Nothing");
				format(PollInfo[iPollID][poll_szOption2], 35, "Nothing");
				format(PollInfo[iPollID][poll_szOption3], 35, "Nothing");
				format(PollInfo[iPollID][poll_szOption4], 35, "Nothing");
				format(PollInfo[iPollID][poll_szOption5], 35, "Nothing");
				format(PollInfo[iPollID][poll_szOption6], 35, "Nothing");

				PollInfo[iPollID][poll_iOptionResults][0] = 0;
				PollInfo[iPollID][poll_iOptionResults][1] = 0;
				PollInfo[iPollID][poll_iOptionResults][2] = 0;
				PollInfo[iPollID][poll_iOptionResults][3] = 0;
				PollInfo[iPollID][poll_iOptionResults][4] = 0;
				PollInfo[iPollID][poll_iOptionResults][5] = 0;

				PollInfo[iPollID][poll_iInterior] = 0;
				PollInfo[iPollID][poll_iVirtualWorld] = 0;

				PollInfo[iPollID][poll_iNation] = -1;

				mysql_format(MainPipeline, szMiscArray, sizeof szMiscArray, "DELETE FROM `polls` WHERE `ID`=%d", iPollID + 1);
				mysql_tquery(MainPipeline, szMiscArray, "PollDeleted", "i", iPollID);

				DestroyDynamic3DTextLabel(PollInfo[iPollID][poll_textLabel]);
				DestroyDynamicPickup(PollInfo[iPollID][poll_iPickupID]);

				SendClientMessageEx(playerid, COLOR_WHITE, "Poll deleted successfully.");
			}
			else SendClientMessageEx(playerid, COLOR_GRAD2, "This poll does not exist.");
		}
		else SendClientMessageEx(playerid, COLOR_GRAD2, "Invalid poll ID specified.");
	}
	else SendClientMessageEx(playerid, COLOR_GRAD2, "You're not authorised to use this command.");

	return 1;
}

CMD:editpoll(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pPR] > 0)
	{
		new iPollID;
		if(sscanf(params, "d", iPollID)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /editpoll [poll id]");

		if(iPollID >= 0 && iPollID < MAX_POLLS)
		{
			if(PollInfo[iPollID][poll_iID] != -1)
			{
				SetPVarInt(playerid, "iEditingPoll", iPollID);
				ShowPlayerEditPollDialog(playerid);
			}
			else SendClientMessageEx(playerid, COLOR_GRAD2, "This poll does not exist.");
		}
		else SendClientMessageEx(playerid, COLOR_GRAD2, "Invalid poll ID specified.");
	}
	else SendClientMessageEx(playerid, COLOR_GRAD2, "You're not authorised to use this command.");
	return 1;
}

CMD:viewpollresults(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pPR] > 0)
	{
		new iPollID;
		if(sscanf(params, "d", iPollID)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /viewpollresults [poll id]");

		if(iPollID >= 0 && iPollID < MAX_POLLS)
		{
			if(PollInfo[iPollID][poll_iID] != -1)
			{
				SendClientMessageEx(playerid, COLOR_GREEN, "_______________________________________");

				format(szMiscArray, sizeof szMiscArray, "Poll ID: %d | Title: %s", iPollID, PollInfo[iPollID][poll_szTitle]);
				SendClientMessageEx(playerid, COLOR_GREY, szMiscArray);

				format(szMiscArray, sizeof szMiscArray, "Option #1 (%s): %d votes.", PollInfo[iPollID][poll_szOption1], PollInfo[iPollID][poll_iOptionResults][0]);
				SendClientMessageEx(playerid, COLOR_GREY, szMiscArray);

				format(szMiscArray, sizeof szMiscArray, "Option #2 (%s): %d votes.", PollInfo[iPollID][poll_szOption2], PollInfo[iPollID][poll_iOptionResults][1]);
				SendClientMessageEx(playerid, COLOR_GREY, szMiscArray);

				format(szMiscArray, sizeof szMiscArray, "Option #3 (%s): %d votes.", PollInfo[iPollID][poll_szOption3], PollInfo[iPollID][poll_iOptionResults][2]);
				if(PollInfo[iPollID][poll_iOptions] >= 3) SendClientMessageEx(playerid, COLOR_GREY, szMiscArray);
				
				format(szMiscArray, sizeof szMiscArray, "Option #4 (%s): %d votes.", PollInfo[iPollID][poll_szOption4], PollInfo[iPollID][poll_iOptionResults][3]);
				if(PollInfo[iPollID][poll_iOptions] >= 4) SendClientMessageEx(playerid, COLOR_GREY, szMiscArray);

				format(szMiscArray, sizeof szMiscArray, "Option #5 (%s): %d votes.", PollInfo[iPollID][poll_szOption5], PollInfo[iPollID][poll_iOptionResults][4]);
				if(PollInfo[iPollID][poll_iOptions] >= 5) SendClientMessageEx(playerid, COLOR_GREY, szMiscArray);

				format(szMiscArray, sizeof szMiscArray, "Option #6 (%s): %d votes.", PollInfo[iPollID][poll_szOption6], PollInfo[iPollID][poll_iOptionResults][5]);
				if(PollInfo[iPollID][poll_iOptions] >= 6) SendClientMessageEx(playerid, COLOR_GREY, szMiscArray);

				SendClientMessageEx(playerid, COLOR_GREEN, "_______________________________________");
			}
			else SendClientMessageEx(playerid, COLOR_GRAD2, "This poll does not exist.");
		}
		else SendClientMessageEx(playerid, COLOR_GRAD2, "Invalid poll ID specified.");
	}
	else SendClientMessageEx(playerid, COLOR_GRAD2, "You're not authorised to use this command.");
	return 1;
}

CMD:vote(playerid, params[])
{
	new iPollID = -1;
	if(PlayerInfo[playerid][pConnectHours] < 2) return SendClientMessage(playerid, COLOR_GRAD2, "You do not have enough playing hours to vote in this poll.");
	for(new i = 0; i < MAX_POLLS; i++)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.0, PollInfo[i][poll_fLocation][0], PollInfo[i][poll_fLocation][1], PollInfo[i][poll_fLocation][2]) && GetPlayerInterior(playerid) == PollInfo[i][poll_iInterior] && GetPlayerVirtualWorld(playerid) == PollInfo[i][poll_iVirtualWorld])
		{
			iPollID = i;
			break;
		}
	}

	if(iPollID != -1)
	{
		if(!strcmp(PlayerInfo[playerid][pPollKey1], PollInfo[iPollID][poll_szUniqueKey]) || !strcmp(PlayerInfo[playerid][pPollKey2], PollInfo[iPollID][poll_szUniqueKey]) || !strcmp(PlayerInfo[playerid][pPollKey3], PollInfo[iPollID][poll_szUniqueKey]))
		{
			SendClientMessageEx(playerid, COLOR_GRAD2, "You have already voted on this poll.");
			return 1;
		}
		else
		{
			if(gettime() < PollInfo[iPollID][poll_iExpirationDate])
			{
				new iCanUse = 0;
				switch(PollInfo[iPollID][poll_iType])
				{ // new PollTypes[5][] = {"None", "VIP", "Group", "Business", "Admin"};
					case 0: iCanUse = 1;
					case 1: if(PlayerInfo[playerid][pDonateRank] >= PollInfo[iPollID][poll_iTypeRank]) iCanUse = 1;
					case 2: if(PlayerInfo[playerid][pMember] == PollInfo[iPollID][poll_iTypeID]  && PlayerInfo[playerid][pRank] >= PollInfo[iPollID][poll_iTypeRank]) iCanUse = 1;
					case 3: if(PlayerInfo[playerid][pBusiness] == PollInfo[iPollID][poll_iTypeID] && PlayerInfo[playerid][pBusinessRank] >= PollInfo[iPollID][poll_iTypeRank]) iCanUse = 1;
					case 4: if(PlayerInfo[playerid][pAdmin] >= PollInfo[iPollID][poll_iTypeRank]) iCanUse = 1;
				}

				if(PollInfo[iPollID][poll_iNation] != -1)
				{
					if(PollInfo[iPollID][poll_iNation] == 0 && PlayerInfo[playerid][pNation] != 0) return SendClientMessage(playerid, COLOR_GRAD2, "This poll is restricted to San Andreas - you cannot vote in it.");
					else if(PollInfo[iPollID][poll_iNation] == 1 && PlayerInfo[playerid][pNation] != 1) return SendClientMessage(playerid, COLOR_GRAD2, "This poll is restricted to New Robada - you cannot vote in it.");
				}

				if(iCanUse) // Just in case?
				{
					SetPVarInt(playerid, "iVotingOnPoll", iPollID);

					new szBody[300];

					format(szMiscArray, sizeof szMiscArray, "%s\n", PollInfo[iPollID][poll_szOption1]);
					strcat(szBody, szMiscArray);

					format(szMiscArray, sizeof szMiscArray, "%s\n", PollInfo[iPollID][poll_szOption2]);
					strcat(szBody, szMiscArray);

					format(szMiscArray, sizeof szMiscArray, "%s\n", PollInfo[iPollID][poll_szOption3]);
					if(PollInfo[iPollID][poll_iOptions] >= 3) strcat(szBody, szMiscArray);

					format(szMiscArray, sizeof szMiscArray, "%s\n", PollInfo[iPollID][poll_szOption4]);
					if(PollInfo[iPollID][poll_iOptions] >= 4) strcat(szBody, szMiscArray);

					format(szMiscArray, sizeof szMiscArray, "%s\n", PollInfo[iPollID][poll_szOption5]);
					if(PollInfo[iPollID][poll_iOptions] >= 5) strcat(szBody, szMiscArray);

					format(szMiscArray, sizeof szMiscArray, "%s\n", PollInfo[iPollID][poll_szOption6]);
					if(PollInfo[iPollID][poll_iOptions] == 6) strcat(szBody, szMiscArray);

					format(szMiscArray, sizeof szMiscArray, "Poll %d | Options", iPollID);

					ShowPlayerDialogEx(playerid, DIALOG_VOTE, DIALOG_STYLE_LIST, PollInfo[iPollID][poll_szTitle], szBody, "Edit", "Cancel");
					szMiscArray[0] = 0;
				}
				else SendClientMessageEx(playerid, COLOR_GRAD2, "This poll is restricted - you are not permitted to vote.");
			}
			else SendClientMessageEx(playerid, COLOR_GRAD2, "This poll has expired.");
		}
	}
	else SendClientMessageEx(playerid, COLOR_GRAD2, "You're not in range of any polling stations.");
	return 1;
}

CMD:pollhelp(playerid, params[]) {

    if(PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pPR] > 0) SendClientMessageEx(playerid, COLOR_GRAD2, "/createpoll, /deletepoll, /editpoll, /viewpollresults, /vote.");
    else SendClientMessageEx(playerid, COLOR_GRAD2, "You're not authorised to use this command.");
    return 1;
}

CMD:polls(playerid, params[]) {

    if(PlayerInfo[playerid][pAdmin] >= 1337 || PlayerInfo[playerid][pPR] > 0) {

        SendClientMessage(playerid, COLOR_GREEN, "_______________________________________");

        new iPollCount = 0;
       	new szNation[25];
        for(new i = 0; i < MAX_POLLS; i++) {

            if(PollInfo[i][poll_iID] != -1) {
            	
            	if(PollInfo[i][poll_iNation] == -1) format(szNation, sizeof szNation, "None");
            	else if(PollInfo[i][poll_iNation] == 0) format(szNation, sizeof szNation, "San Andreas");
            	else if(PollInfo[i][poll_iNation] == 1) format(szNation, sizeof szNation, "New Robada");

                iPollCount++;
                format(szMiscArray, sizeof(szMiscArray), "Poll ID: %d | Title / Topic: %s | No. of Options: %d | Placed By: %s (Unique Key: %s) | Nation: %s", i, PollInfo[i][poll_szTitle], PollInfo[i][poll_iOptions], PollInfo[i][poll_szPlacedBy], PollInfo[i][poll_szUniqueKey], szNation);
                SendClientMessage(playerid, COLOR_GRAD2, szMiscArray);
            }
        }
        if(iPollCount == 0) SendClientMessage(playerid, COLOR_GREY, "There are currently no active polls.");
        else SendClientMessage(playerid, COLOR_GREY, "To go to a poll, use /gotopoll [poll id]");

		SendClientMessage(playerid, COLOR_GREEN, "_______________________________________");
    }
    else SendClientMessage(playerid, COLOR_GRAD2, "You're not authorised to use this command.");
    return 1;
}

CMD:gotopoll(playerid, params[]) {

    if(PlayerInfo[playerid][pAdmin] < 1337 && PlayerInfo[playerid][pPR] == 0) return SendClientMessage(playerid, COLOR_GRAD2, "You're not authorised to use this command.");

    new iPollID;
    if(sscanf(params, "d", iPollID)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /gotopoll [poll id]");

    if(iPollID < 0 || iPollID >= MAX_POLLS) return SendClientMessage(playerid, COLOR_GRAD2, "Invalid poll specified.");

    if(PollInfo[iPollID][poll_iID] == -1) return SendClientMessage(playerid, COLOR_GRAD2, "This poll does not exist.");

    SetPlayerPos(playerid, PollInfo[iPollID][poll_fLocation][0], PollInfo[iPollID][poll_fLocation][1], PollInfo[iPollID][poll_fLocation][2]);
    SetPlayerInterior(playerid, PollInfo[iPollID][poll_iInterior]);
    SetPlayerVirtualWorld(playerid, PollInfo[iPollID][poll_iVirtualWorld]);

    format(szMiscArray, sizeof szMiscArray, "You have teleported to poll ID %d successfully.", iPollID);
    SendClientMessage(playerid, COLOR_WHITE, szMiscArray);
    return 1;
}